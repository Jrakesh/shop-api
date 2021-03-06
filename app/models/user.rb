class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :authentication_tokens
  has_many :user_roles

  include API::GlobalConstant

  def create(first_name, last_name, sex, date, email, password)
    begin
      User.create!(
          first_name: first_name,
             last_name: last_name,
             sex: sex,
             date_of_birth: date,
             email: email,
             password: password
      )
      # Added default user role as a user
      role_user_id = Role.where(name: 'User').first.id
      @user = User.last
      UserRole.create!(
          user_id: @user.id,
          role_id: role_user_id
      )
    rescue Exception => e
      raise DataBaseException.new e
    end
  end

  def create_authentication_token(user)
    begin
      @user_role = user.user_roles
      @role = Role.find((@user_role.as_json)[0]["role_id"])
      @role_privileges = @role.role_privileges
      privileges = []
      @role_privileges.each do |role_privilege|
        privileges << Privilege.where(id: role_privilege.privilege_id).first.name
      end
      authentication_token = user.authentication_tokens.create

      return {
          authentication_token: authentication_token.authentication_token,
          user: {
              first_name: user.first_name,
              last_name: user.last_name
          },
          privileges: privileges
      }
    rescue Exception => e
      raise DataBaseException.new e
    end
  end

  def edit_user(first_name, last_name, sex, date, user_id)
    begin
      @user = User.find(user_id)
      @user.update(
          first_name: first_name,
          last_name: last_name,
          sex: sex,
          date_of_birth: date
      )
    rescue Exception => e
      raise DataBaseException.new e
    end
  end

  def find_by_id(id)
    begin
      return User.find_by_id(id).present?
    rescue DataBaseException => e
      presentable_error_response('INTERNAL_ISSUE')
    end
  end

  def find_email(email)
    begin
      return User.find_by(email: email).present?
    rescue Exception => e
      raise DataBaseException.new e
    end
  end

  def find_data_by_email(email)
    begin
      User.find_by(email: email)
    rescue Exception => e
      raise DataBaseException.new e
    end
  end

  def find_email_password(email, password)
    begin
      user = User.find_by(email: email)
      User.find_by(email: email).present? && user.valid_password?(password)
    rescue Exception => e
      raise DataBaseException.new e
    end
  end

  def get_all_user
    begin
      return User.all.order(:first_name)
    rescue DataBaseException => e
      presentable_error_response('INTERNAL_ISSUE')
    end
  end

  def get_details(user_id)
    begin
      @user = User.find(user_id)

      date_of_birth = (Date.parse((@user.date_of_birth).to_s))
      formatted_date_of_birth = date_of_birth.strftime('%e/%m/%Y')

      return {
          "first_name" => @user.first_name,
          "last_name"  => @user.last_name,
          "sex"        => @user.sex,
          "date"       => formatted_date_of_birth,
          "email"      => @user.email
      }
    rescue Exception => e
      raise DataBaseException.new e
    end
  end
end
