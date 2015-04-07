require 'securerandom'

module Authentication
  extend ActiveSupport::Concern

  included do
    # Rails' User based Authentcation base
    has_secure_password

    # Validations
    validates_uniqueness_of :email
    validates_presence_of   :token
    validates_length_of     :password, minimum: 6

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

end
