module API
  module V1
    module APIBase
      include GlobalConstant
      include ErrorMessage
      include SuccessMessage

      def authenticate_user(api_key)
        error!(prepare_error_response('API_AUTH_FAILED'),APIBase::HTTP_ERROR_CODE) unless api_key == Api_Key
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
    end
  end
end