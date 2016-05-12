class Shop < ActiveRecord::Base
  def check_availability(name, address, latitude, longitude)
    begin
      if Shop.where(name: name, address: address, latitude: latitude, longitude: longitude).present? || Shop.where(latitude: latitude, longitude: longitude).present? || Shop.where(address: address).present?
        return false
      end
    rescue DataBaseException => e
      presentable_error_response('INTERNAL_ISSUE')
    end

    return true
  end

  def create(name, address, latitude, longitude)
    begin
      Shop.create!(
          name: name,
          address: address,
          latitude: latitude,
          longitude: longitude
      )
    rescue DataBaseException => e
      presentable_error_response('INTERNAL_ISSUE')
    end

    return true
  end

  def get_all_details
    begin
      @shop =  Shop.all
    rescue DataBaseException => e
      presentable_error_response('INTERNAL_ISSUE')
    end

    return @shop
  end
end
