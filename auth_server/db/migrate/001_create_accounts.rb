migration 1, :create_accounts do
  up do
    create_table :accounts do
      column :id, Integer, :serial => true
      column :nick, String, :length => 255, :unique => true
      column :email, String, :length => 255
      column :crypted_password, String, :length => 255
      column :salt, String, :length => 255
      column :session_hash, String, :length => 255
      column :server_hash, String, :length => 255
    end
  end

  down do
    drop_table :accounts
  end
end
