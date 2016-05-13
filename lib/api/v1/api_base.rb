module API
  module V1
    module APIBase
      include GlobalConstant
      include ErrorMessage
      include SuccessMessage

      # This method is used to authenticate a user.
      def authenticate_user(api_key, authentication_token_flag, authentication_token = nil)
        begin
          error!(prepare_error_response("API_AUTH_FAILED"),APIBase::HTTP_ERROR_CODE) unless api_key == Api_Key
          if authentication_token_flag
            error!(prepare_error_response("INVALID_AUTH_TOKEN"), APIBase::HTTP_ERROR_CODE) unless AuthenticationToken.new.availability(authentication_token)
          end
        rescue DataBaseException => e
          return prepare_error_response("INTERNAL_ISSUE")
        end
      end

      # This method prepare error response according to error code.
      # Parameters: error code
      def prepare_error_response(error_code)
        return  {
            status: APIBase::ERROR_STATUS, error:  {
                code: APIBase::ERROR_CODES[error_code],
                message: APIBase::ERROR_MESSAGES[APIBase::ERROR_CODES[error_code]]
            }
        }
      end

      # This method prepare success response according to error code.
      # Parameters: data to be sent in response message
      def prepare_success_response(data)
        return  {
            status: APIBase::SUCCESS_STATUS,
            data: data
        }
      end

      def presentable_error_response(error_code)
        error!(prepare_error_response(error_code), APIBase::HTTP_ERROR_CODE)
      end

      def is_param_present(key)
        if key.blank?
          return true
        end
        return false
      end

      def all_params_present(*keys_array)
        keys_array.each do |key|
          if(is_param_present(key))
            return true
          end
        end
        return false
      end

      # This method is used to check gender format.
      def is_valid_gender(sex)
        return (sex == 'M') || (sex == 'male') || (sex == 'F') || (sex == 'female')
      end

      # This method is used to check date format.
      def is_valid_date(date)
        d, m, y = date.split '/'

        return Date.valid_date? y.to_i, m.to_i, d.to_i
      end

      # This method is used to return gender which is used to stored in database.
      def valid_sex(sex)
        (sex == 'M') || (sex == 'male') ? 'M' : 'F'
      end
    end
  end
end