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

        # This method is used to create a new shop
        # Parameters: params
        def create(params)
          begin
            # This is a object of Shop model
            shop = Shop.new

            if all_params_present(params[:name], params[:address], params[:latitude], params[:longitude])
              presentable_error_response('BLANK_SHOP_DATA')
            end
            presentable_error_response('LATITUTE_OUT_OF_RANGE') unless is_latitude_range(params[:latitude])
            presentable_error_response('LONGITUTE_OUT_OF_RANGE') unless is_latitude_range(params[:longitude])
            if shop.is_available(params[:name], params[:address], params[:latitude], params[:longitude])
              presentable_error_response('SHOP_ALREADY_EXIST')
            end

            shop.create(params[:name], params[:address], params[:latitude], params[:longitude])

            return prepare_success_response({message: SUCCESS_MESSAGES['SHOP_CREATED']})
          rescue DataBaseException => e
            presentable_error_response('INTERNAL_ISSUE')
          end
        end

        # This method is used to delete a shop
        # Parameters: params
        def delete(params)
          begin
            # This is a object of Shop model
            shop = Shop.new

            presentable_error_response('BLANK_SHOP_DATA') if all_params_present(params[:id])
            presentable_error_response('SHOP_NOT_EXIST') unless shop.find_by_id(params[:id])

            shop.delete(params[:id])

            return prepare_success_response({message: SUCCESS_MESSAGES['SHOP_DELETED']})
          rescue DataBaseException => e
            presentable_error_response('INTERNAL_ISSUE')
          end
        end

        # This method is used to edit a shop
        # Parameters: params
        def edit(params)
          begin
            # This is a object of Shop model
            shop = Shop.new

            if all_params_present(params[:id], params[:name], params[:address], params[:latitude], params[:longitude])
              presentable_error_response('BLANK_SHOP_DATA')
            end
            presentable_error_response('LATITUTE_OUT_OF_RANGE') unless is_latitude_range(params[:latitude])
            presentable_error_response('LONGITUTE_OUT_OF_RANGE') unless is_latitude_range(params[:longitude])
            presentable_error_response('SHOP_NOT_EXIST') unless shop.find_by_id(params[:id])

            shop.edit(params[:id], params[:name], params[:address], params[:latitude], params[:longitude])

            return prepare_success_response({message: SUCCESS_MESSAGES['SHOP_EDITED']})
          rescue DataBaseException => e
            presentable_error_response('INTERNAL_ISSUE')
          end
        end

        # This method is used to get a all shop details
        def get_all_details
          begin
            @all_shop_details = Shop.new.get_all_details

            return prepare_success_response(@all_shop_details)
          rescue DataBaseException => e
            presentable_error_response('INTERNAL_ISSUE')
          end
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
          authenticate_user(headers['Api-Key'], AUTHENTICATION_FLAG_FALSE, headers['Authentication-Token'])
        end

        desc 'Create shop'
        post '/create' do
          return create(params)
        end

        desc 'Delete shop'
        post '/delete' do
          return delete(params)
        end

        desc 'Edit shop'
        post '/edit' do
          return edit(params)
        end

        desc 'Get all shop details'
        get '/get_all_details' do
          return get_all_details
        end
      end
    end
  end
end
