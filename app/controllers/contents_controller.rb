class ContentsController < ApplicationController
  before_action :set_content, only: [:show, :destroy]
  before_action :set_contents

  def index
    pickup_category_content = Content.order("RAND()").find_by(buyer_id: nil)
    pickup_category_grandchild = Category.find(pickup_category_content.category_id)
    pickup_category_child = Category.find(pickup_category_grandchild.parent_id)
    @pickup_category = Category.find(pickup_category_child.ancestry)
    @contents_category = Content.where(category_id: @pickup_category.indirect_ids).where(buyer_id: nil).order("RAND()").limit(5).includes(:images)
    @pickup_brand_content = Content.order("RAND()").where.not(brand: "").find_by(buyer_id: nil)
    if @pickup_brand_content
      @contents_brand = Content.where(brand: @pickup_brand_content.brand).where(buyer_id: nil).order("RAND()").limit(5).includes(:images)
    end
  end

  def show
    @contents_category = Content.where(category_id: @content.category_id).where(buyer_id: nil).order("RAND()").limit(3).includes(:images)
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

  def set_contents
    @contents = Content.all.includes(:images)
  end

end
