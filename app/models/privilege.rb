class Privilege < ActiveRecord::Base
  has_many :role_privileges

  def create(name)
    begin
      Privilege.create!(
          name: name
      )
      # Added all privilege to admin default.
      role_user_id = Role.where(name: 'Admin').first.id
      @privilege = Privilege.last
      RolePrivilege.create!(
          privilege_id: @privilege.id,
          role_id: role_user_id
      )
    rescue DataBaseException => e
      presentable_error_response('INTERNAL_ISSUE')
    end
  end

  def delete(id)
    begin
      @privilege = Privilege.find(id)
      @privilege.destroy
    rescue DataBaseException => e
      presentable_error_response('INTERNAL_ISSUE')
    end

    return true
  end

  def get_all_privilege
    begin
      return Privilege.all
    rescue DataBaseException => e
      presentable_error_response('INTERNAL_ISSUE')
    end
  end

  def find_by_id(id)
    begin
      return Privilege.find_by_id(id).present?
    rescue DataBaseException => e
      presentable_error_response('INTERNAL_ISSUE')
    end
  end

  def is_available(name)
    begin
      p Privilege.where(name: name).present?
      if Privilege.where(name: name).present?
        return true
      end
    rescue DataBaseException => e
      presentable_error_response('INTERNAL_ISSUE')
    end

    return false
  end
end
