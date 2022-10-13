class AddPasswordDigestAndVerifiedToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :password_digest, :string
    add_column :users, :verified, :string, null: false, default: false

    User.find_each do |user|
      password = (SecureRandom.hex(6).upcase + SecureRandom.hex(6))
        .chars.shuffle.join("")
      user.update!(password: password)
    end

    change_column_null(:users, :password_digest, false)
  end
end
