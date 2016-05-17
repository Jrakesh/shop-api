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

            privilege.create(params[:name])

            return prepare_success_response({message: SUCCESS_MESSAGES["PRIVILEGE_CREATED"]})
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

            role.create(params[:name])

            return prepare_success_response({message: SUCCESS_MESSAGES["ROLE_CREATED"]})
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

        desc 'Delete privilege'
        post '/delete_privilege' do
          return delete_privilege(params)
        end

        desc 'Create role'
        post '/create_role' do
          return create_role(params)
        end

        desc 'Delete role'
        post '/delete_role' do
          return delete_role(params)
        end

        desc 'Get privilege by role'
        post '/get_privilege_by_role' do
          return get_privilege_by_role(params)
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