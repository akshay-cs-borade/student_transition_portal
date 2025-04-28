# app/services/completed_report_generator.rb
require 'csv'

class CompletedReportGenerator
  def initialize(families)
    @families = families
  end

  def generate_csv
    CSV.generate(headers: true) do |csv|
      csv << [
        "Parent First Name", "Parent Last Name", "Email", "Mobile", "Address",
        "Student ID", "Student Name", "Student Grade"
      ]

      @families.each do |family|
        family.students.each do |student|
          csv << [
            family.parent_first_name,
            family.parent_last_name,
            family.email,
            family.mobile,
            family.address,
            student.student_id,
            student.name,
            student.grade
          ]
        end
      end
    end
  end
end
