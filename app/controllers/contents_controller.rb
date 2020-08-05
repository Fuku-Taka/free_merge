class ContentsController < ApplicationController
  before_action :set_content, only: [:show, :destroy]

  def index
  end

  def show
  end
  

  def new
    @category_parent_array = Category.where(ancestry: nil)
    if user_signed_in?
      @content = Content.new
      @content.images.build
    else
      redirect_to root_path
    end
  end

  def create
    @content = Content.new(content_params)
    @content.images.present?
    @content.save!
    redirect_to root_path 
  end

  def destroy
    if @content.destroy
      redirect_to root_path, notice: '削除しました'
    else
      render :show
    end
  end

  def purchase
    @content = Content.find(params[:id])
    Payjp.api_key = "sk_test_34b9c40833f2c90f739205a4"
    charge = Payjp::Charge.create(
    amount: @content.price,
    card: params['payjp-token'],
    currency: 'jpy'
    )
  end


  def get_category_children
    @category_children = Category.find("#{params[:parent_id]}").children
  end

  def get_category_grandchildren
    @category_grandchildren = Category.find("#{params[:child_id]}").children
  end

  private

  def content_params
    params.require(:content).permit(:name, :category_id, :price, :explain, :size, :brand, :status, :postage, :shipment, :prefecture, images_attributes: [:content_image] ).merge(user_id: current_user.id)
  end

  def set_content
    @content = Content.find(params[:id])
  end

end
