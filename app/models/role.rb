class Role < ActiveRecord::Base
  has_many :user_roles
  has_many :role_privileges

  def change_role_privileges(privileges, role_id)
    begin
      RolePrivilege.where(role_id: role_id).destroy_all
      privileges.each do |privilege|
        RolePrivilege.create!(
          role_id: role_id,
          privilege_id: privilege.id
        )
      end
    rescue DataBaseException => e
      presentable_error_response('INTERNAL_ISSUE')
    end
  end

  def change_user_role(user_id, role_id)
    begin
      @user = User.find(user_id)
      @user_roles = @user.user_roles.find(
          UserRole.where(user_id: user_id).first.id
      )
      @user_roles.update_attributes(role_id: role_id)
    rescue DataBaseException => e
      presentable_error_response('INTERNAL_ISSUE')
    end
  end

  def create(name)
    begin
      Role.create!(
          name: name
      )
      return Role.last
    rescue DataBaseException => e
      presentable_error_response('INTERNAL_ISSUE')
    end
  end

  def delete(id)
    begin
      @role = Role.find(id)
      @role.destroy
      UserRole.destroy_all(role_id: id)
    rescue DataBaseException => e
      presentable_error_response('INTERNAL_ISSUE')
    end

    return true
  end

  def edit(id, name)
    begin
      @role = Role.find(id)
      @role.update!(
          name: name
      )
    rescue DataBaseException => e
      presentable_error_response('INTERNAL_ISSUE')
    end

    return true
  end

  def get_all_role
    begin
      return Role.all.order(:name)
    rescue DataBaseException => e
      presentable_error_response('INTERNAL_ISSUE')
    end
  end

  def get_privilege_by_role(id)
    begin
      @role = Role.find(id)
      return @role.role_privileges
    rescue DataBaseException => e
      presentable_error_response('INTERNAL_ISSUE')
    end
  end

  def get_user_role(id)
    begin
      @user = User.find(id)
      return @user.user_roles
    rescue DataBaseException => e
      presentable_error_response('INTERNAL_ISSUE')
    end
  end

  def find_by_id(id)
    begin
      return Role.find_by_id(id).present?
    rescue DataBaseException => e
      presentable_error_response('INTERNAL_ISSUE')
    end
  end

  def is_available(name)
    begin
      if Role.where(name: name).present?
        return true
      end
    rescue DataBaseException => e
      presentable_error_response('INTERNAL_ISSUE')
    end

    return false
  end
end
