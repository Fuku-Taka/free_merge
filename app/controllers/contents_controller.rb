class ContentsController < ApplicationController

  def index
  end

  def show
    @content = Content.find(params[:id])
    # ↑↑↑showアクションで使うインスタンス変数を作っときます。
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
    @content = Content.find(params[:id])
    @content.destroy
    redirect_to("/")
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

end
