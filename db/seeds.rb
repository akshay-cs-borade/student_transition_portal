# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Clear existing data first (optional but good for testing)
AuditLog.destroy_all
Student.destroy_all
Family.destroy_all
School.destroy_all

puts "Existing data cleared ✅"

# Create one School
school = School.create!(
  name: "Green Valley International School"
)

puts "School created: #{school.name} ✅"