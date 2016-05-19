module API
  module V1
    class UsersRole < Grape::API
      require 'api/root'
      version 'v1'
      format :json
      include GlobalConstant
      include ErrorMessage
      include SuccessMessage

      helpers do
        include APIBase

        # This method is used to create privilege
        # Parameters: params
        def create_privilege(params)
          begin
            # This is a object of Privilege model
            privilege = Privilege.new

            presentable_error_response("BLANK_PRIVILEGE_DATA") if all_params_present(params[:name])
            presentable_error_response("PRIVILEGE_ALREADY_EXISTS") if privilege.is_available(params[:name])

            return prepare_success_response({message: SUCCESS_MESSAGES["PRIVILEGE_CREATED"], privilege: privilege.create(params[:name])})
          rescue DataBaseException => e
            presentable_error_response("INTERNAL_ISSUE")
          end
        end

        # This method is used to edit privilege
        # Parameters: params
        def edit_privilege(params)
          begin
            # This is a object of Privilege model
            privilege = Privilege.new

            presentable_error_response("BLANK_PRIVILEGE_DATA") if all_params_present(params[:id], params[:name])
            presentable_error_response("PRIVILEGE_NOT_EXISTS") unless privilege.find_by_id(params[:id])

            privilege.edit(params[:id], params[:name])

            return prepare_success_response({message: SUCCESS_MESSAGES["PRIVILEGE_EDITED"]})
          rescue DataBaseException => e
            presentable_error_response("INTERNAL_ISSUE")
          end
        end

        # This method is used to delete privilege
        # Parameters: params
        def delete_privilege(params)
          begin
            # This is a object of Privilege model
            privilege = Privilege.new

            presentable_error_response("BLANK_PRIVILEGE_DATA") if all_params_present(params[:id])
            presentable_error_response("PRIVILEGE_NOT_EXISTS") unless privilege.find_by_id(params[:id])

            privilege.delete(params[:id])

            return prepare_success_response({message: SUCCESS_MESSAGES["PRIVILEGE_DELETED"]})
          rescue DataBaseException => e
            presentable_error_response("INTERNAL_ISSUE")
          end
        end

        # This method is used to create role
        # Parameters: params
        def create_role(params)
          begin
            # This is a object of Role model
            role = Role.new

            presentable_error_response("BLANK_ROLE_DATA") if all_params_present(params[:name])
            presentable_error_response("ROLE_ALREADY_EXISTS") if role.is_available(params[:name])

            return prepare_success_response({message: SUCCESS_MESSAGES["ROLE_CREATED"], role: role.create(params[:name])})
          rescue DataBaseException => e
            presentable_error_response("INTERNAL_ISSUE")
          end
        end

        # This method is used to edit role
        # Parameters: params
        def edit_role(params)
          begin
            # This is a object of Role model
            role = Role.new

            presentable_error_response("BLANK_ROLE_DATA") if all_params_present(params[:id], params[:name])
            presentable_error_response("ROLE_NOT_EXISTS") unless role.find_by_id(params[:id])

            role.edit(params[:id], params[:name])

            return prepare_success_response({message: SUCCESS_MESSAGES["ROLE_EDITED"]})
          rescue DataBaseException => e
            presentable_error_response("INTERNAL_ISSUE")
          end
        end

        # This method is used to delete role
        # Parameters: params
        def delete_role(params)
          begin
            # This is a object of Role model
            role = Role.new

            presentable_error_response("BLANK_ROLE_DATA") if all_params_present(params[:id])
            presentable_error_response("ROLE_NOT_EXISTS") unless role.find_by_id(params[:id])

            role.delete(params[:id])

            return prepare_success_response({message: SUCCESS_MESSAGES["ROLE_DELETED"]})
          rescue DataBaseException => e
            presentable_error_response("INTERNAL_ISSUE")
          end
        end

        # This method is used to get role of user
        # Parameters: params
        def get_user_role(params)
          begin
            presentable_error_response("BLANK_USER_DATA") if all_params_present(params[:id])
            presentable_error_response("USER_NOT_EXISTS") unless User.new.find_by_id(params[:id])

            return prepare_success_response(Role.new.get_user_role(params[:id]))
          rescue DataBaseException => e
            presentable_error_response("INTERNAL_ISSUE")
          end
        end

        # This method is used to change role of user
        # Parameters: params
        def change_user_role(params)
          begin
            # This is a object of Role model
            role = Role.new

            presentable_error_response("BLANK_USER_DATA") if all_params_present(params[:user_id], params[:role_id])
            presentable_error_response("USER_NOT_EXISTS") unless User.new.find_by_id(params[:user_id])
            presentable_error_response("ROLE_NOT_EXISTS") unless role.find_by_id(params[:role_id])
            role.change_user_role(params[:user_id], params[:role_id])

            return prepare_success_response({message: SUCCESS_MESSAGES["ROLE_CHANGED"]})
          rescue DataBaseException => e
            presentable_error_response("INTERNAL_ISSUE")
          end
        end

        # This method is used to change role privileges
        # Parameters: params
        def change_role_privileges(params)
          begin
            # This is a object of Role model
            role = Role.new

            presentable_error_response("BLANK_ROLE_DATA") if all_params_present(params[:role_id])
            presentable_error_response("ROLE_NOT_EXISTS") unless role.find_by_id(params[:role_id])
            role.change_role_privileges(params[:privileges], params[:role_id])

            return prepare_success_response({message: SUCCESS_MESSAGES["PRIVILEGE_CHANGED"]})
          rescue DataBaseException => e
            presentable_error_response("INTERNAL_ISSUE")
          end
        end

        # This method is used to get all privilege by role
        # Parameters: params
        def get_privilege_by_role(params)
          begin
            # This is a object of Role model
            role = Role.new

            presentable_error_response("BLANK_ROLE_DATA") if all_params_present(params[:id])
            presentable_error_response("ROLE_NOT_EXISTS") unless role.find_by_id(params[:id])

            return prepare_success_response(role.get_privilege_by_role(params[:id]))
          rescue DataBaseException => e
            presentable_error_response("INTERNAL_ISSUE")
          end
        end

        # This method is used to get all role
        # Parameters: params
        def get_all_role
          begin
            return prepare_success_response(Role.new.get_all_role)
          rescue DataBaseException => e
            presentable_error_response("INTERNAL_ISSUE")
          end
        end

        # This method is used to get all privileges
        # Parameters: params
        def get_all_privilege
          begin
            return prepare_success_response(Privilege.new.get_all_privilege)
          rescue DataBaseException => e
            presentable_error_response("INTERNAL_ISSUE")
          end
        end
      end

      resource :users_role do
        before do
          authenticate_user(headers['Api-Key'], AUTHENTICATION_FLAG_TRUE, headers['Authentication-Token'])
        end

        desc 'Create privilege'
        post '/create_privilege' do
          return create_privilege(params)
        end

        desc 'Edit privilege'
        post '/edit_privilege' do
          return edit_privilege(params)
        end

        desc 'Delete privilege'
        post '/delete_privilege' do
          return delete_privilege(params)
        end

        desc 'Create role'
        post '/create_role' do
          return create_role(params)
        end

        desc 'Edit role'
        post '/edit_role' do
          return edit_role(params)
        end

        desc 'Delete role'
        post '/delete_role' do
          return delete_role(params)
        end

        desc 'Get privilege by role'
        post '/get_privilege_by_role' do
          return get_privilege_by_role(params)
        end

        desc 'Get user role'
        post '/get_user_role' do
          return get_user_role(params)
        end

        desc 'Change user role'
        post '/change_user_role' do
          return change_user_role(params)
        end

        desc 'Change role privileges'
        post '/change_role_privileges' do
          return change_role_privileges(params)
        end

        desc 'Get all role'
        get '/get_all_role' do
          return get_all_role
        end

        desc 'Get all privilege'
        get '/get_all_privilege' do
          return get_all_privilege
        end
      end
    end
  end
end