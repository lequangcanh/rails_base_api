module Api
  module V1
    module JsonRenderer
      extend ActiveSupport::Concern

      class DataSanitizer
        def initialize object, options, api_version
          @object = object
          @options = options
          @root = options[:root]
          @api_version = api_version
        end

        def sanitize
          case object
          when ActiveRecord::Relation, Array
            @root ||= klass_name.tableize
            {root => sanitized_array_data}
          when Hash
            root ? {root => sanitized_data} : sanitized_data
          else
            @root ||= klass_name.underscore
            {root => sanitized_data}
          end
        end

        private
        attr_reader :object, :options, :api_version, :root

        def sanitized_data
          @sanitized_data ||= serializer.new object, opts
        end

        def sanitized_array_data
          @sanitized_array_data = ActiveModel::Serializer::CollectionSerializer.new(object, opts)
        end

        def klass_name
          @klass_name ||= (object.respond_to?(:klass) ? object.klass : object.class).name
        end

        def serializer
          @serializer ||=
            unless klass_name == Array.name
              options[:serializer] || "Api::#{api_version}::#{klass_name}Serializer".constantize
            end
        end

        def opts
          @opts ||= options.except(:success, :status, :meta, :root).merge namespace: "Api::#{api_version}"
        end
      end

      protected
      included do
        def render_jsonapi object, options = {}
          success = options.fetch :success, true
          meta = options.fetch :meta, {}
          status = options.fetch :status, :ok
          data_serializer = DataSanitizer.new(object, options, api_version).sanitize

          response_data = {
            success: success,
            data: data_serializer,
            meta: meta
          }
          render json: response_data, status: status
        end
      end

      def api_version
        @api_version ||= request.path.split("/")[2].upcase
      end
    end
  end
end
