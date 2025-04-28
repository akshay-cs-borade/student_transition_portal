class CreateStudents < ActiveRecord::Migration[7.1]
  def change
    create_table :students do |t|
      t.references :family, null: false, foreign_key: true
      t.string :student_id
      t.string :name
      t.integer :grade

      t.timestamps
    end
  end
end
