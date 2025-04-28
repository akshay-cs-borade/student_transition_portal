# app/jobs/csv_processing_job.rb
class CsvProcessingJob < ApplicationJob
  queue_as :default

  def perform(csv_upload_id)
    csv_upload = CsvUpload.find(csv_upload_id)
    csv_upload.update!(status: :processing)

    validation_service = CsvValidationService.new(csv_upload.csv_file)
    errors = validation_service.validate

    if errors.any?
      error_csv = ErrorReportGenerator.new(errors).generate_csv
      csv_upload.error_report_file.attach(io: StringIO.new(error_csv), filename: "error_report.csv")
      csv_upload.update!(status: :failed)
      return
    end

    ActiveRecord::Base.transaction do
      @processed_family_emails = CsvTransitionService.new(csv_upload.csv_file, School.first).process!
    end

    # After successful transaction → Generate Completed Report
    processed_families = Family.where(email: @processed_family_emails)

    completed_csv = CompletedReportGenerator.new(processed_families).generate_csv
    csv_upload.completed_report_file.attach(io: StringIO.new(completed_csv), filename: "completed_report.csv")

    csv_upload.update!(status: :completed)
  rescue => e
    Rails.logger.error "CSV Processing Failed: #{e.message}"
    csv_upload.update!(status: :failed)
    raise e # Important: re-raise to force full rollback
  end
end
