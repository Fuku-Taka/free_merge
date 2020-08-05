# README

# DB設計

![ER図](images/free_margeDB.png "ER図")

## usersテーブル

|Column|Type|Options|
|------|----|-------|
|nickname|string|null: false|
|email|string|null: false, unique: true|
|password|string|null: false|
|user_image|string||
|introduction|text||
|first_name|string|null: false|
|family_name|string|null: false|
|first_name_kana|string|null: false|
|family_name_kana|string|null: false|
|birthday|date|null: false|

### Association
- belongs_to :address, dependent: :destroy
- belongs_to :credit_card, dependent: :destroy
- has_many :contents


## addressesテーブル

|Column|Type|Options|
|------|----|-------|
|user_id|references|null: false, foreign_key: true|
|postal_code|string|null: false|
|prefecture|integer|null: false|
|city|string|null: false|
|address|string|null: false|
|apartment|string|null: false|

### Association
- belongs_to :user

## Credit_cardsテーブル

|Column|Type|Options|
|------|----|-------|
|user_id|references|null: false, foreign_key: true|
|card_company|string|null: false|
|card_number|string|null: false|
|card_year|integer|null: false|
|card_month|integer|null: false|
|card_pass|integer|null: false|
|customer_id|string|null: false|
|card_id|string|null: false|

### Association
- belongs to :user

## contentsテーブル

|Column|Type|Options|
|------|----|-------|
|user_id|integer|null: false, foreign_key: true|
|name|string|null: false|
|price|integer|null: false|
|explain|text|null: false|
|status_id|references|null: false, foreign_key: true|
|size_id|references|null: false, foreign_key: true|
|postage|string|null: false|
|prefecture_id|references|null: false, foreign_key: true|
|shipment_id|references|null: false, foreign_key: true|
|brand|string||
|buyer_id|references|null: false, foreign_key: true|

### Association

- belongs_to :status
- belongs_to :size
- belongs_to :prefecture
- belongs_to :shipment
- belongs_to :category
- belongs_to :user
- has_many :images, dependent: :destroy


## statusesテーブル

|Column|Type|Options|
|------|----|-------|
|status|integer|null: false|



### Association

- has_many :contents

## sizesテーブル

|Column|Type|Options|
|------|----|-------|
|size|string|null: false|


### Association

- has_many :contents


## prefectures(active_hash)テーブル

|Column|Type|Options|
|------|----|-------|
|prefecture|string|null: false|

### Association

- has_many :contents


## shipmentテーブル

|Column|Type|Options|
|------|----|-------|
|shipment|string|null: false|


### Association
- has many :contents

## imagesテーブル

|Column|Type|Options|
|------|----|-------|
|content_id|references|null: false, foreign_key: true|
|content_image|string|null: false|

### Association
- belongs_to :content

## categoriesテーブル

|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
|ancestry|string||

### Association
- has_many :contents


    @pickup_category = Category.order("RAND()").find_by(ancestry: nil)
    @contents_category = Content.where(category_id: @pickup_category.indirect_ids).where(buyer_id: nil).order("RAND()").limit(5).includes(:images)
    @pickup_brand_content = Content.order("RAND()").where.not(brand: "").find_by(buyer_id: nil)
    @contents_brand = Content.where(brand: @pickup_brand_content.brand).where(buyer_id: nil).order("RAND()").limit(5).includes(:images)
