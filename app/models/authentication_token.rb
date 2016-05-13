class AuthenticationToken < ActiveRecord::Base
  belongs_to :user

  before_save :ensure_authentication_token

  def ensure_authentication_token
    self.authentication_token ||= generate_authentication_token
  end

  def generate_authentication_token
    token = Devise.friendly_token
  end

  def availability(authentication_token)
    begin
      return AuthenticationToken.find_by(authentication_token: authentication_token)
    rescue Exception => e
      raise DataBaseException.new e
    end
  end

  def destroy_authentication_token(authentication_token)
    begin
      AuthenticationToken.find_by(authentication_token: authentication_token).destroy
    rescue Exception => e
      raise DataBaseException.new e
    end
  end

  def find_user_id(authentication_token)
    begin
      return AuthenticationToken.where(authentication_token: authentication_token).first.user_id
    rescue Exception => e
      raise DataBaseException.new e
    end
  end
end
