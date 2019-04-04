require 'rails_helper'

describe ProductsController do
  before do
    Product.delete_all
  end

  describe 'GET index' do
    it 'returns http status ok' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it 'render json with all products' do
      Product.create(name: 'Apple')
      get :index
      products = JSON.parse(response.body)
      expect(products.size).to eq 1
    end
  end

  describe 'GET show' do
    it 'returns http status ok' do
      product = Product.create(name: 'Apple')
      get :show, params: { id: product }
      expect(response).to have_http_status(:ok)
    end

    it 'render the correct product' do
      product = Product.create(name: 'Apple')
      get :show, params: { id: product }
      expected_product = JSON.parse(response.body)
      expect(expected_product["id"]).to eq(product.id)
    end

    it 'returns http status not found' do
      get :show, params: { id: 'xxx' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST create" do
    it "returns http status created" do
      post :create, params: { name: "Pear" }
      expect(response.status).to eq(201)
      expect(response).to have_http_status(:created)
    end

    it "returns the created product" do
      post :create, params: { name: "Banana" }
      expected_product = JSON.parse(response.body)
      expect(expected_product).to have_key("id")
      expect(expected_product["name"]).to eq("Banana")
    end
  end

  describe "PATCH update" do
    it "returns http status ok" do
      product = Product.create(name: 'Apple')
      patch :update, params: { name: "Orange", id: product.id, category: "Hola" }
      expect(response).to have_http_status(:ok)
    end

    it "returns the updated product" do
      product = Product.create(name: 'Apple')
      patch :update, params: { name: "Orange", id: product.id, category: "Hola" }
      expected_product = JSON.parse(response.body)
      expect(expected_product["name"]).to eq("Orange")
      expect(expected_product["category"]).to eq("Hola")
    end
  end

  describe "DELETE destroy" do
    it "returns http status no content" do
      product = Product.create(name: 'Apple')
      delete :destroy, params: { id: product }
      expect(response).to have_http_status(:no_content)
    end

    it "returns empty body" do
      product = Product.create(name: 'Apple')
      delete :destroy, params: { id: product }
      expect(response.body).to eq(" ")
    end

    it "decrement by 1 the total of products" do
      product = Product.create(name: 'Apple')
      expect do
        delete :destroy, params: { id: product }
      end.to change { Product.count }.by(-1)
    end

    it "actually delete the product" do
      delete :destroy, params: { id: product }
      products = Product.where(id: product.id)
      expect(products.size).to eq(0)
    end
  end
end
