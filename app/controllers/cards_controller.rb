class CardsController < ApplicationController
  require 'payjp'
  before_action :set_card
  before_action :set_secretkey, only: [:index ,:create, :destroy, :pay]

  def index
    @cards = Card.all
    # カードがある場合、カードの情報をセットする
    if @card
      customer = Payjp::Customer.retrieve(@card.customer_id)
      @card_info = customer.cards.data.first
      set_card_brand(@card_info.brand)
    end
  end

  # クレジットカード情報入力画面
  def new
    redirect_to action: "index" if @card.present?
  end

  # 登録画面で入力した情報をDBに保存
  def create
    if params['payjp-token'].blank?
      redirect_to action: "new", alert: "クレジットカードを登録できませんでした。"
    else

      # ここで先ほど生成したトークンを顧客情報と紐付け、PAY.JP管理サイトに送信
      customer = Payjp::Customer.create(card: params['payjp-token'])
      @card = Card.new(user_id: current_user.id, customer_id: customer.id, card_id: customer.default_card)
      if @card.save
        redirect_to action: "index"
      else
        redirect_to action: "create"
      end
    end
  end

  def destroy
    # 今回はクレジットカードを削除するだけでなく、PAY.JPの顧客情報も削除する。これによりcreateメソッドが複雑にならない。
    # PAY.JPの顧客情報を取得
    customer = Payjp::Customer.retrieve(@card.payjp_id)
    customer.delete # PAY.JPの顧客情報を削除
    if @card.destroy # App上でもクレジットカードを削除
      redirect_to action: "index", notice: "削除しました"
    else
      redirect_to action: "index", alert: "削除できませんでした"
    end
  end

  private

  def set_card
    @card = Card.find_by(user_id: current_user.id) if Card.find_by(user_id: current_user.id).present?
  end

  def set_secretkey
    Payjp.api_key = ENV["PAYJP_ACCESS_KEY"]
  end

  def set_card_brand(brand)
    case brand
    when "Visa"
      @card_src = "card/visa.svg"
      @card_alt = "visa"
    when "JCB"
      @card_src = "card/jcb.svg"
      @card_alt = "jcb"
    when "MasterCard"
      @card_src = "card/master-card.svg"
      @card_alt = "mastercard"
    when "American Express"
      @card_src = "card/american_express.svg"
      @card_alt = "amex"
    when "Diners Club"
      @card_src = "card/dinersclub.svg"
      @card_alt = "dinersclub"
    when "Discover"
      @card_src = "card/discover.svg"
      @card_alt = "discover"
    end
  end
end
