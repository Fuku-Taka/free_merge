class ContentsController < ApplicationController
  before_action :set_content, only: [:show, :destroy]

  def index
    @contents_category = Content.where(category_id: 3).where("buyer_id is NULL").order("RAND()").limit(5).includes(:images)
    @contents_brand = Content.where(brand: "ジャーマン").where("buyer_id is NULL").order("RAND()").limit(5).includes(:images)
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
    if @content.save
      redirect_to root_path
    else
      flash.now[:alert] = '必須項目を入力してください'
      @category_parent_array = Category.where(ancestry: nil)
      @content = Content.new
      @content.images.build
      render :new
    end
  end

  def destroy
    if @content.destroy
      redirect_to root_path, notice: '削除しました'
    else
      render :show
    end
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
