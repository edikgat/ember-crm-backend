class CreateSupportAgents < ActiveRecord::Migration
  def change
    create_table :support_agents do |t|
      t.string :email, null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.string :first_name, null: false
      t.string :last_name, null: false

      t.timestamps null: false
    end
    add_index :support_agents, :email, unique: true
  end
end
