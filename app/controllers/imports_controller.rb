class ImportsController < ApplicationController
  def new
    @csv_upload = CsvUpload.new
  end

  def create
    @csv_upload = CsvUpload.create!(status: :pending, csv_file: params[:csv_upload][:csv_file])
    CsvProcessingJob.perform_later(@csv_upload.id)
    redirect_to imports_path, notice: "CSV is being processed in the background."
  end

  def index
    @csv_uploads = CsvUpload.order(created_at: :desc)
  end
end
