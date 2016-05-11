module API
  module V1
    class Root < Grape::API
      mount API::V1::Shops
    end
  end
end