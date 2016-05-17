class RolePrivilege < ActiveRecord::Base
  belongs_to :role
  belongs_to :privilege
end
