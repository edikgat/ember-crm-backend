class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.string :first_name, null: false
      t.string :last_name, null: false

      t.timestamps null: false
    end
    add_index :users, :email, unique: true
    add_foreign_key :support_requests, :users
  end
end
