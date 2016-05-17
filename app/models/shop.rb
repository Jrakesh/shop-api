class Shop < ActiveRecord::Base
  def is_available(name, address, latitude, longitude)
    begin
      if Shop.where(name: name, address: address, latitude: latitude, longitude: longitude).present? || Shop.where(latitude: latitude, longitude: longitude).present? || Shop.where(address: address).present?
        return true
      end
    rescue DataBaseException => e
      presentable_error_response('INTERNAL_ISSUE')
    end

    return false
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

  def edit(id, name, address, latitude, longitude)
    begin
      Shop.update(
          id,
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

  def find_by_id(id)
    begin
      return Shop.find(id).present?
    rescue DataBaseException => e
      presentable_error_response('INTERNAL_ISSUE')
    end
  end

  def get_all_details
    begin
      @shop =  Shop.all
    rescue DataBaseException => e
      presentable_error_response('INTERNAL_ISSUE')
    end

    return @shop
  end

  def delete(id)
    begin
      Shop.destroy(id)
    rescue DataBaseException => e
      presentable_error_response('INTERNAL_ISSUE')
    end

    return true
  end
end
