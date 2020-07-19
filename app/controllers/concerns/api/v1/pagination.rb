module Api
  module V1
    module Pagination
      extend ActiveSupport::Concern
      include Pagy::Backend

      protected
      included do
        def paginate relation
          options = {page: page, items: items, outset: params[:outset]}
          options[:count] = params[:count] if params[:count].to_i.positive?

          pagy_info, records = pagy relation, options
          [pagy_repsonse(pagy_info), records]
        end
      end

      private
      def pagy_repsonse pagy
        pagy.instance_values.except Settings.pagy.instances.vars
      end

      def page
        @page ||= params[:page].to_i < 1 ? Settings.pagy.page_default : params[:page]
      end

      def items
        @items ||= params[:items].to_i < 1 ? Settings.pagy.items_default : params[:items]
      end
    end
  end
end
