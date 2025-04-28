# app/services/csv_transition_service.rb
class CsvTransitionService
  def initialize(file, school)
    @file = file
    @school = school
  end

  def process!
    @processed_family_emails = []
    @file.open(tmpdir: Dir.tmpdir) do |file|
      CSV.foreach(file.path, headers: true) do |row|
        process_row(row)
      end
    end
    
    @processed_family_emails
  end

  private

  def process_row(row)
    email = row['E-Mail']&.strip
    
    family = Family.find_or_initialize_by(email: email, school: @school)
    family.update!(
      parent_first_name: row['Parent First Name'],
      parent_last_name: row['Parent Last Name'],
      mobile: row['Mobile Phone Number'],
      address: "#{row['Address Line 1']}, #{row['City']}, #{row['State']}, #{row['Post/Zip Code']}, #{row['Country']}"
    )

    @processed_family_emails << email unless @processed_family_emails.include?(email)

    audit('update', 'Family', family.id, family.previous_changes)

    (1..4).each do |i|
      next unless row["Student #{i} ID"].present?

      student = family.students.find_or_initialize_by(student_id: row["Student #{i} ID"])
      student.update!(
        name: "#{row["Student #{i} First Name"]} #{row["Student #{i} Last Name"]}",
        grade: row["Student #{i} Grade"].to_i
      )
      audit('update', 'Student', student.id, student.previous_changes)
    end
  end

  def audit(action, type, id, changes)
    AuditLog.create!(
      action_type: action,
      record_type: type,
      record_id: id,
      changes_snapshot: changes
    )
  end
end
