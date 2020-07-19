module Api
  module V1
    module BaseConcern
      extend ActiveSupport::Concern

      include Api::V1::JsonRenderer
      include Api::V1::RescueExceptions
      include Api::V1::Pagination
    end
  end
end
