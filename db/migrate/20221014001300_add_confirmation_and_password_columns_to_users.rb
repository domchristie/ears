class AddConfirmationAndPasswordColumnsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :confirmed_at, :datetime
    add_column :users, :password_digest, :string

    User.find_each do |user|
      password = (SecureRandom.hex(6) + SecureRandom.hex(6).upcase)
        .chars.shuffle.join("")
      user.update!(password: password)
    end

    change_column_null :users, :password_digest, false
  end
end
