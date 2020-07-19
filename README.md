# Base 1 Rails app API

Môi trường:

* Ruby 2.7.1
* Rails 6.0.0.2

Các công việc cần làm:
1. Tạo Rails app với option --api `rails new your_app --api`
2. Update [Gemfile](/Gemfile), add một số gem cần thiết như: mysql2, config, dotenv-rails, rack-cors, active_model_serializers, pry-rails
3. Config kết nối với database ở file [config/database.yml](/config/database.yml), nên set các giá trị ở biến môi trường.
4. Tạo file quản lý biến môi trường, ở đây là file `.env`, ignore file này ra khỏi Git. Tạo file [.env.example](/.env.example) để quản lý các biến phải set trong project.
5. Config rspec để viết UT:

  * Add thêm các Gem liên quan
  ```ruby
  group :development, :test do
    gem "factory_bot_rails"
    gem "faker"
    gem "rspec-rails"
    gem "shoulda-matchers"
    gem "simplecov"
    gem "simplecov-json"
    gem "simplecov-rcov"
  end
  ```

  * `bundle install` và run `rails generate rspec:install` để generate các file config

6. Add thêm các thư viện check convention, code style, ... nếu cần dùng

  ```ruby
  group :development, :test do
    gem "brakeman", require: false
    gem "rails_best_practices"
    gem "reek"
    gem "rubocop", require: false
    gem "rubocop-checkstyle_formatter", require: false
  end
  ```

7. Nếu đã có design DB cơ bản, có thể generate một số model chính như User, Company, ...
8. Thiết kế cấu trúc thư mục quản lý version (Ở đây sẽ quản lý version theo kiểu api/v1)
  * Define routes:
  ```ruby
    Rails.application.routes.draw do
      namespace :api, format: :json do
        namespace :v1 do
        end
      end
    end
  ```
  * Tạo file [base_controller](/app/controllers/api/v1/base_controller.rb) của v1, các controller của v1 sẽ kế thừa từ file này
  * Tương tự serializer, services, cũng nên quản lý theo version
  ```ruby
  class Api::V1::BaseController < ApplicationController
  end
  ```
9. Định nghĩa các success responses:
  * Cấu trúc success response có dạng:
  ```json
    {
      "success": true,
      "data": {"Sẽ trả về những data chính của request"},
      "meta": {"Các data bổ trợ thêm, ví dụ như phân trang, ..."}
    }
  ```
  * Định nghĩa hàm `render_jsonapi` nhận một object, thông qua Active Model Serializer trả về response. Tham khảo: [app/controllers/concerns/api/v1/json_rendered.rb](/app/controllers/concerns/json_rendered.rb)

10. Định nghĩa errors responses:
  * Cấu trúc errors responses có dạng:
  ```json
    {
      "success": false,
      "errors": [
        {
          "resource": "Resource phát sinh lỗi, có thể null nếu không phải lỗi từ Active Record",
          "field": "Trường bị lỗi validation, có thể null nếu không phải lỗi validation",
          "code": "Custom code, không dùng code trùng với HTTP code",
          "message": "Message lỗi"
        }
      ]
    }
  ```
  * Sử dụng exeption để raise lỗi luôn, khỏi phải if else rối code. Define các exception có thể xảy ra tại [app/controllers/concerns/api/v1/rescue_exception.rb](/app/controllers/concerns/api/v1/rescue_exception.rb)
  * Định nghĩa các custom exception trong [lib/api/error.rb](/lib/api/error.rb)
  * Định nghĩa response cho các validation errors [lib/active_record_validation/error.rb](/lib/active_record_validation/error.rb)
  * Định nghĩa các serializer errors tương ứng
    * [app/serializers/validation_error_serializer.rb](/app/serializers/validation_error_serializer.rb)
    * [app/serializers/record_not_found_serializer.rb](/app/serializers/record_not_found_serializer.rb)
    * [app/serializers/action_not_allowed_serializer.rb](/app/serializers/action_not_allowed_serializer.rb)
    * Define các errors message cơ bản [config/locales/errors.en.yml](/config/locales/ja.yml)
11. Xử lý pagination response.
  * Ở đây sẽ viết dựa trên gem pagy, vì nó có module Pagy::Backend khá ngon. Define vào [app/controllers/concerns/api/v1/pagination.rb](/app/controllers/concerns/api/v1/pagination.rb).
  * Một số giá trị default trong settings
  ```yml
    # config/settings.yml
    pagy:
      instances:
        vars: vars
      items_default: 30
      page_default: 1
  ```
12. Cuối cùng include 3 cái modules trên vào base_controller để sử dụng
  * Để cho đẹp thì tạo 1 cái base_concern nhét 3 cái modules này vào [app/controllers/concerns/api/v1/base_concern.rb](/app/controllers/concerns/api/v1/base_concern.rb)
  ```ruby
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
  ```
  * Rồi include base_concern vào base_controller
  ```ruby
  # app/controllers/api/v1/base_controller.rb
    class Api::V1::BaseController < ApplicationController
      include Api::V1::BaseConcern
    end
  ```
