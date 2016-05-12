module API
  module V1
    class Shops < Grape::API
      require 'api/root'
      version 'v1'
      format :json
      include GlobalConstant
      include ErrorMessage
      include SuccessMessage

      helpers do
        include APIBase

        # This method is used to create new shop
        # Parameters: params
        def create(params)
          begin
            # This is a object of Shop model
            shop = Shop.new

            presentable_error_response('BLANK_SHOP_DATA') if all_params_present(params[:name], params[:address], params[:latitude], params[:longitude])
            presentable_error_response('LATITUTE_OUT_OF_RANGE') unless is_latitude_range(params[:latitude])
            presentable_error_response('LONGITUTE_OUT_OF_RANGE') unless is_latitude_range(params[:longitude])
            presentable_error_response('SHOP_ALREADY_EXIST') unless shop.check_availability(params[:name], params[:address], params[:latitude], params[:longitude])

            shop.create(params[:name], params[:address], params[:latitude], params[:longitude])
          rescue DataBaseException => e
            presentable_error_response('INTERNAL_ISSUE')
          end
          return prepare_success_response({message: SUCCESS_MESSAGES['SHOP_CREATED']})
        end

        # This method is used to get a all shop details
        # Parameters: params
        def get_all_details(params)
          begin
            @all_shop_details = Shop.new.get_all_details
          rescue DataBaseException => e
            presentable_error_response('INTERNAL_ISSUE')
          end
          return prepare_success_response(@all_shop_details)
        end

        # This method is used to check range of latitude.
        def is_latitude_range(latitude)
          latitude.to_f >= -90 && latitude.to_f <= 90 ? true : false
        end

        # This method is used to check range of longitude.
        def is_longitude_range(longitude)
          longitude.to_f >= -180 && longitude.to_f <= 180 ? true : false
        end
      end

      resource :shops do
        before do
          authenticate_user(headers['Api-Key'])
        end

        desc 'Create shop'
        post '/create' do
          return create(params)
        end

        desc 'Get all shop details'
        get '/get_all_details' do
          return get_all_details(params)
        end
      end
    end
  end
end
