class CreateFamilies < ActiveRecord::Migration[7.1]
  def change
    create_table :families do |t|
      t.references :school, null: false, foreign_key: true
      t.string :parent_first_name
      t.string :parent_last_name
      t.string :email
      t.string :mobile
      t.string :address

      t.timestamps
    end
  end
end
