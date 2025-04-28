class CsvUpload < ApplicationRecord
    has_one_attached :csv_file
    has_one_attached :error_report_file
    has_one_attached :completed_report_file
  
    enum status: { pending: 0, processing: 1, completed: 2, failed: 3 } 
end
