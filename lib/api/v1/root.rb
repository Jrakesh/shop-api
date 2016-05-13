module API
  module V1
    class Root < Grape::API
      mount API::V1::Shops
      mount API::V1::ServicesWithoutToken
      mount API::V1::Users
    end
  end
end