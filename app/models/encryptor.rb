class Encryptor
  KEY = ActiveSupport::KeyGenerator.new(
    Rails.application.credentials.secret_key_base
  ).generate_key(
    Rails.application.credentials.encryptor_salt,
    ActiveSupport::MessageEncryptor.key_len
  ).freeze

  private_constant :KEY

  delegate :encrypt_and_sign, :decrypt_and_verify, to: :encryptor

  def self.encrypt(value)
    new.encrypt_and_sign(value)
  end

  def self.decrypt(value)
    new.decrypt_and_verify(value)
  end

  def self.url_safe_encrypt(value)
    Base64.urlsafe_encode64 encrypt(value)
  end

  def self.url_safe_decrypt(value)
    decrypt Base64.urlsafe_decode64(value)
  end

  private

  def encryptor
    ActiveSupport::MessageEncryptor.new(KEY)
  end
end
