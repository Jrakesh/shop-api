class CreateRolePrivileges < ActiveRecord::Migration
  def change
    create_table :role_privileges do |t|
      t.references :role, index: true
      t.references :privilege, index: true

      t.timestamps
    end
  end
end
