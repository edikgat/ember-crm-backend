class CreateSupportRequests < ActiveRecord::Migration
  def change
    create_table :support_requests do |t|
      t.string :subject, null: false
      t.integer :user_id, null: false
      t.string :status, null: false, default: 'open'
      t.datetime :closed_at
      t.text :feedback

      t.timestamps null: false
    end
    add_index :support_requests, :user_id
    add_index :support_requests, [:user_id, :subject], unique: true
  end
end
