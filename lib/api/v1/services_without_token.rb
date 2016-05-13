module API
  module V1
    class ServicesWithoutToken < Grape::API
      require 'api/root'
      require 'date'
      version 'v1'
      format :json
      include GlobalConstant
      include ErrorMessage
      include SuccessMessage

      helpers do
        include APIBase

        # This method is used to create a new user
        # Parameters: params
        def signup(params)
          begin
            # This is a object of User model
            user = User.new

            if all_params_present(params[:first_name], params[:last_name], params[:sex], params[:date], params[:email], params[:password])
              presentable_error_response('BLANK_USER_DATA')
            end
            presentable_error_response("USER_ALREADY_EXISTS") if user.find_email(params[:email])
            unless(params[:password].to_s.length > 7 && params[:password].to_s.length < 21)
              presentable_error_response("WRONG_PASSWORD_LENGTH")
            end
            presentable_error_response("WRONG_GENDER_FORMAT") unless is_valid_gender(params[:sex])
            presentable_error_response("WRONG_DATE_FORMAT") unless is_valid_date(params[:date])

            user.create(params[:first_name], params[:last_name], valid_sex(params[:sex]), params[:date], params[:email], params[:password])

            return prepare_success_response({message: SUCCESS_MESSAGES['USER_CREATED']})
          rescue DataBaseException => e
            presentable_error_response('INTERNAL_ISSUE')
          end
        end

        # This method provide login functionality and checks user credentials and returns authentication token
        # Parameters: params
        def login(params)
          begin
            # This is a object of User model
            user = User.new

            presentable_error_response("BLANK_EMAIL_PASSWORD") if all_params_present(params[:email], params[:password])
            presentable_error_response("INVALID_EMAIL_PASSWORD") unless user.find_email_password(params[:email],params[:password])

            return prepare_success_response(user.create_authentication_token(user.find_data_by_email((params[:email]).downcase)))
          rescue DataBaseException => e
            presentable_error_response("INTERNAL_ISSUE")
          end
        end
      end

      resource :services_without_token do
        before do
          authenticate_user(headers['Api-Key'], AUTHENTICATION_FLAG_FALSE)
        end

        desc 'Create user'
        post '/signup' do
          return signup(params)
        end

        desc 'Provide authentication token to user and user sign-in'
        post '/login' do
          return login(params)
        end
      end
    end
  end
end
