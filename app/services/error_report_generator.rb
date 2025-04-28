# app/services/error_report_generator.rb
require 'csv'

class ErrorReportGenerator
  def initialize(errors)
    @errors = errors
  end

  def generate_csv
    CSV.generate(headers: true) do |csv|
      csv << %w[Row Field Error]
      @errors.each do |error|
        csv << [error[:line], error[:field], error[:error]]
      end
    end
  end
end
