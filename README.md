# Creating an API with Rails

- To see the options to create an app with rails, run:
  `$ rails --help`
- Create new Rails project
  `$ rails new my-api --skip-test --database=postgresql --api`
- `$ cd my-api`
- Add to Gemfile
  `gem 'rspec-rails'`
- Run `bundle install`
- Create the RSpec configuration
  `$ rails generate rspec:install`
- Generate Product model
  `$ rails g model Product name:string description:string price:float category:string`
- Create the database
  `$ rails db:create`
- Run the pending migrations
  `$ rails db:migrate`
- `$ mkdir spec/controllers`
- `$ touch spec/controllers/products_controller_spec.rb`
- Add to `spec/controllers/products_controller_spec.rb`
  ```ruby
  require 'rails_helper'

  describe ProductsController do
  end
  ```
- Run `$ rspec`
- `$ touch app/controllers/products_controller.rb`
- Add to `app/controllers/products_controller.rb`
  ```ruby
  class ProductsController < ApplicationController
  end
  ```
- **GET all the videos**
  - RED
    Add to `spec/controllers/products_controller_spec.rb`
    ```ruby
    describe 'GET index' do
      it 'returns http status ok' do
        get :index
        expect(response.status).to eq 200
      end
    end
    ```
  - GREEN
    Add to `config/routes.rb`
    ```ruby
    resources :products, only: :index
    ```
    Add to `app/controllers/products_controller.rb`
    ```ruby
    def index
      render nothing: true, status: :ok
    end
    ```
  - RED
    Add another spec in `spec/controllers/products_controller_spec.rb`
    ```ruby
    it 'render json with all products' do
      Product.create(name: 'Apple')
      get :index
      products = JSON.parse(response.body)
      expect(products.size).to eq 1
    end
    ```
  - GREEN
    Add to `app/controllers/products_controller.rb`
    ```ruby
    def index
      render json: Product.all
    end
    ```
  - REFACTOR
    Before `describe 'GET index'`, add:
    ```ruby
    before do
      Product.delete_all
    end
    ```
    Replace
    `expect(response.status).to eq 200`
    To
    `expect(response).to have_http_status(:ok)`

- **GET a specific video**
  - RED
    Add to `spec/controllers/products_controller_spec.rb`
    ```ruby
    describe 'GET show' do
      it 'returns http status ok' do
        product = Product.create(name: 'Apple')
        get :show, params: { id: product }
        expect(response).to have_http_status(:ok)
      end
    end
    ````
  - GREEN
    Edit in `config/routes.rb`
    ```ruby
    resources :products, only: [:index, :show]
    ```
    Add to `app/controllers/products_controller.rb`
    ```ruby
    def show
      render json: Product.find(params[:id])
    end
    ```
  - REFACTOR
    Add another spec
    ```ruby
    it 'render the correct video' do
      product = Product.create(name: 'Apple')
      get :show, params: { id: product }
      expected_product = JSON.parse(response.body)
      expect(expected_product).to eq(product)
    end
    ```
  - RED
    Add another spec
    ```ruby
    it 'returns http status not found' do
      get :show, params: { id: 'xxx' }
      expect(response).to have_http_status(:not_found)
    end
    ```
  - GREEN
    Add to `app/controllers/products_controller.rb`
    ```ruby
    rescue_from ActiveRecord::RecordNotFound do |e|
      render json: { message: e.message }, status: :not_found
    end
    ```
- Exercises:
  - Create a new product
  - Update an existing product
  - Delete an existing product
