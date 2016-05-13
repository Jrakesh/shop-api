module API
  module V1
    class Users < Grape::API
      require 'api/root'
      version 'v1'
      format :json
      include GlobalConstant
      include ErrorMessage
      include SuccessMessage

      helpers do
        include APIBase

        # This method provide logout functionality and destroy authentication token
        def logout
          begin
            AuthenticationToken.new.destroy_authentication_token(headers['Authentication-Token'])

            return prepare_success_response({message: SUCCESS_MESSAGES["LOGOUT_SUCCESS"]})
          rescue DataBaseException => e
            presentable_error_response("INTERNAL_ISSUE")
          end
        end

        # This method is used to edit a user profile
        # Parameters: params
        def edit(params)
          begin
            if(all_params_present(params[:first_name], params[:last_name], params[:sex], params[:date]))
              presentable_error_response("BLANK_USER_DATA")
            end
            presentable_error_response("WRONG_GENDER_FORMAT") unless is_valid_gender(params[:sex])
            presentable_error_response("WRONG_DATE_FORMAT") unless is_valid_date(params[:date])

            User.new.edit_user(
                params[:first_name],
                params[:last_name],
                params[:sex],
                params[:date],
                AuthenticationToken.new.find_user_id(headers['Authentication-Token'])
            )

            return prepare_success_response({message: SUCCESS_MESSAGES["EDIT_SUCCESS"]})
          rescue DataBaseException => e
            presentable_error_response("INTERNAL_ISSUE")
          end
        end

        def is_logged_in(params)
          return prepare_success_response({message: SUCCESS_MESSAGES["IS_LOGGED_IN"]})
        end

        def get_details
          begin
            return prepare_success_response(
                User.new.get_details(
                    AuthenticationToken.new.find_user_id(headers['Authentication-Token'])
                )
            )
          rescue DataBaseException => e
            presentable_error_response("INTERNAL_ISSUE")
          end
        end
      end

      resource :users do
        before do
          authenticate_user(headers['Api-Key'], AUTHENTICATION_FLAG_TRUE, headers['Authentication-Token'])
        end

        desc 'Get user authentication token (SignIn User)'
        get '/logout' do
          return logout
        end

        desc 'Edit user deatils (Edit User)'
        post '/edit' do
          return edit(params)
        end

        desc 'Is logged in (Is Looged In)'
        get '/is_logged_in' do
          return is_logged_in(params)
        end

        desc 'User profile details (User Details)'
        get '/get_details' do
          return get_details
        end
      end
    end
  end
end