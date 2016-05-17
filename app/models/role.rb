class Role < ActiveRecord::Base
  has_many :user_roles
  has_many :role_privileges

  def create(name)
    begin
      Role.create!(
          name: name
      )
    rescue DataBaseException => e
      presentable_error_response('INTERNAL_ISSUE')
    end
  end

  def delete(id)
    begin
      @role = Role.find(id)
      @role.destroy
    rescue DataBaseException => e
      presentable_error_response('INTERNAL_ISSUE')
    end

    return true
  end

  def get_all_role
    begin
      return Role.all
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
