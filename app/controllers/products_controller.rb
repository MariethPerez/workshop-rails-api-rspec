class ProductsController < ApplicationController
  def index
    render json: Product.all
  end

  def show
    render json: Product.find(params[:id])
  end

  def create
    product = Product.create(name: params[:name])
    render json: product, status: :created
  end

  def update
    product = Product.find(params[:id])
    params.keys.each do |key|
      if key != :id && product.attributes.key?(key)
        product[key] = params[key]
      end
    end
    product.save
    render json: product
  end

  def destroy
    product = Product.find(params[:id])
    product.destroy
    render nothing: true, status: :no_content
  end
  
  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { message: e.message }, status: :not_found
  end
end

