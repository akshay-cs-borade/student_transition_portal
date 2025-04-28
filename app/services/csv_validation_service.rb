# app/services/csv_validation_service.rb
class CsvValidationService
  REQUIRED_PARENT_FIELDS = %w[E-Mail]
  REQUIRED_STUDENT_FIELDS = %w[Student First Name Student Last Name Student Grade]

  def initialize(file)
    @file = file
    @errors = []
  end

  def validate
    @file.open(tmpdir: Dir.tmpdir) do |file|
      CSV.foreach(file.path, headers: true).with_index(2) do |row, line_number|
        validate_row(row, line_number)
      end
    end
    @errors
  end

  private

  def validate_row(row, line_number)
    if row['E-Mail'].blank?
      @errors << { line: line_number, field: 'E-Mail', error: 'Missing required field' }
    elsif !valid_email_format?(row['E-Mail'])
      @errors << { line: line_number, field: 'E-Mail', error: 'Invalid email format' }
    end

    (1..4).each do |i|
      next unless row["Student #{i} First Name"].present? || row["Student #{i} Last Name"].present?

      grade = row["Student #{i} Grade"]
      if grade.blank? || !(1..12).include?(grade.to_i)
        @errors << { line: line_number, field: "Student #{i} Grade", error: 'Invalid or missing grade' }
      end
    end
  end

  def valid_email_format?(email)
    URI::MailTo::EMAIL_REGEXP.match?(email)
  end
end
