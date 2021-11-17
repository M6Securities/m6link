class AddDeviseSecurity < ActiveRecord::Migration[6.1]
  def change

    safety_assured do
      change_table :users do |t|
        # password expirable
        t.datetime :password_changed_at
        t.index :password_changed_at

        # session limitable
        t.string :unique_session_id

        # Expirable
        t.datetime :last_activity_at
        t.datetime :expired_at
        t.index :last_activity_at
        t.index :expired_at

        # Paranoid verifiable
        t.string   :paranoid_verification_code
        t.integer  :paranoid_verification_attempt, default: 0
        t.datetime :paranoid_verified_at
        t.index :paranoid_verification_code
        t.index :paranoid_verified_at

      end

      # Password archivable
      create_table :old_passwords do |t|
        t.string :encrypted_password, null: false
        t.string :password_archivable_type, null: false
        t.integer :password_archivable_id, null: false
        t.string :password_salt # Optional. bcrypt stores the salt in the encrypted password field so this column may not be necessary.
        t.datetime :created_at
      end
      add_index :old_passwords, [:password_archivable_type, :password_archivable_id], name: 'index_password_archivable'
    end

  end
end
