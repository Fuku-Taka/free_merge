class ContentsController < ApplicationController

  before_action :set_content, only: [:show, :destroy, :edit, :update, :buy]
  before_action :content_category, only: [:edit, :update]
  before_action :set_contents
  before_action :set_current_user_products,only:[:p_transaction,:p_exhibiting,:p_soldout]
  before_action :set_user,only:[:p_transaction,:p_exhibiting,:p_soldout]


  def index
    unless @contents.length == 0
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

  def purchase
    @content = Content.find(params[:id])
    Payjp.api_key = "sk_test_34b9c40833f2c90f739205a4"
    charge = Payjp::Charge.create(
    amount: @content.price,
    card: params['payjp-token'],
    currency: 'jpy'
    )
  end

  def edit   
  end

  def update
    if params[:content].keys.include?("image") || params[:content].keys.include?("images_attributes") 
      if @content.valid?
        if params[:content].keys.include?("image") 
        # dbにある画像がedit画面で一部削除してるか確認
          update_images_ids = params[:content][:image].values #投稿済み画像 
          before_images_ids = @content.images.ids
          #  商品に紐づく投稿済み画像が、投稿済みにない場合は削除する
          # @product.images.ids.each doで、一つずつimageハッシュにあるか確認。なければdestroy
          before_images_ids.each do |before_img_id|
            Image.find(before_img_id).destroy unless update_images_ids.include?("#{before_img_id}") 

          end
        else
          before_images_ids.each do |before_img_id|
            Image.find(before_img_id).destroy 
          end
        end
        @content.update(content_params)
 
        redirect_to content_path(@content.id), notice: "商品を更新しました"
      else
        render 'edit'
      end
    else
      redirect_back(fallback_location: root_path, notice: '必須項目を入力してください')
    end
  end

  def get_category_children
    @category_children = Category.find("#{params[:parent_id]}").children
  end

  def get_category_grandchildren
    @category_grandchildren = Category.find("#{params[:child_id]}").children
  end

  def buy
    @content.update(auction_id: current_user.id)
  end

  def p_exhibiting #出品中のアクション

  end

  def p_transaction  #取引中のアクション

  end

  def p_soldout    #売却済みのアクション

  end

  private

  def content_params
    params.require(:content).permit(:name, :category_id, :price, :explain, :size, :brand, :status, :postage, :shipment, :prefecture, images_attributes: [:content_image, :id, :_destroy] ).merge(seller_id: current_user.id)
  end

  def set_content
    @content = Content.find(params[:id])
  end


  def content_category
    @grandchild = @content.category
    @child = @grandchild.parent
    @category_parent_array = Category.where(ancestry: nil)
    @category_child_array = Category.where(ancestry: @child.ancestry)
    @category_grandchild_array = Category.where(ancestry: @grandchild.ancestry)
  end

  def set_contents
    @contents = Content.all.includes(:seller,:buyer,:auction,:images)
  end

  def set_current_user_contents
    if user_signed_in? 
      @contents = current_user.contents.includes(:seller,:buyer,:auction,:images)
    else
      redirect_to new_user_session_path
    end
  end

  def set_user
    @user = User.find(current_user.id)
  end
end
