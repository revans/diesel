require 'securerandom'

module Authentication
  extend ActiveSupport::Concern

  included do
    has_secure_password
    validates_uniqueness_of :email
    validates_presence_of :token

    before_validation :ensure_lowercase_email
    before_validation :set_token
  end


  module ClassMethods
    def authenticate(email, password)
      User.find_by(email: email.downcase).
        try(:authenticate, password)
    end
  end



  def valid_password?(password)
    !!authenticate(password)
  end

  private

  def ensure_lowercase_email
    self.email.try(:downcase!)
  end


  def generate_token(length = 28)
    SecureRandom.hex(length)
  end

  private

  def set_token
    self.token ||= ::SecureRandom.hex(22)
  end

end
