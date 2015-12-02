require 'securerandom'

module Authentication
  extend ActiveSupport::Concern

  included do
    # Rails' User based Authentcation base
    has_secure_password

    # Validations
    validates :email, uniqueness: { case_sensitive: false }
    validates :token, presence: true
    validates :password, length: { minimum: 6, allow_blank: true }

    # Before Validation Filters
    before_validation :ensure_lowercase_email
    before_validation :set_token
  end


  module ClassMethods

    # Class method to authenticate a user with an email & password
    def authenticate(email, password)
      User.find_by(email: email.downcase).
        try(:authenticate, password)
    end


    def with_token?(token)
      User.where(token: token).first
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

  def password_has_changed?
    return false if self.password.blank?
  end
end
