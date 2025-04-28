class CreateAuditLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :audit_logs do |t|
      t.string :action_type
      t.string :record_type
      t.integer :record_id
      t.jsonb :changes_snapshot

      t.timestamps
    end
  end
end
