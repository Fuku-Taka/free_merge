require 'rails_helper'

describe ContentsController do
  describe 'GET #new' do
    it "出品ページに遷移するか" do
      get :new
      expect(response).to render_template :new
    end
  end
  describe 'POST #create' do
    context 'can save' do
      it '商品が正しく登録されるか' do
        expect do
          post :create, params: { content: FactoryBot.attributes_for(:content) }
        end.to change(Content, :count).by(1)
      end
      it "root_pathへ遷移するか" do
        content = create(:content)
        post :create, params: { content: FactoryBot.attributes_for(:content) }
        expect(response).to redirect_to(root_path)
      end
    end
    context 'can not save' do
      it '商品が正しく登録されないかどうか' do
        expect do
          post :create, params: { content: FactoryBot.attributes_for(:content, :invalid) }
        end.to_not change(Content, :count)
      end
      it ":new templateへ遷移するか" do
        content = create(:content)
        post :create, params: { content: FactoryBot.attributes_for(:content, :invalid) }
        expect(response).to render_template :new
      end
    end
  end
  describe "GET #show" do
  it "インスタンス変数が期待したものになるか" do
    content = create(:content)
    get :show, params: { id: content }
    expect(assigns(:content)).to eq content
  end
    it "商品詳細ページに遷移するか" do
      content = create(:content)
      get :show, params: {id: content}
      expect(response).to render_template :show  
    end
  end
  describe 'GET #edit' do
    it "インスタンス変数の値が期待したものになるか" do
      content = create(:content)
      get :edit, params: { id: content }
      expect(assigns(:content)).to eq content
    end
    it "商品編集ページに遷移するか" do
      content = create(:content)
      get :edit, params: { id: content }
      expect(response).to render_template :edit
    end
  end

  describe "GET #index" do
    it "期待するビューに変遷するか？" do
      get :index
      expect(response).to render_template :index
    end
  
    it "@ladiesが期待される値を持つか？" do
      ladies = create_list(:content, 10, category_id: "1") 
      get :index
      expect(assigns(:ladies)).to match(ladies.sort{ |a, b| b.created_at <=> a.created_at } )
    end

    it "@menが期待される値を持つか？" do
      men = create_list(:content, 10, category_id: "2") 
      get :index
      expect(assigns(:men)).to match(men.sort{ |a, b| b.created_at <=> a.created_at } )
    end

    it "@home_appliancesが期待される値を持つか？" do
      home_appliances = create_list(:content, 10, category_id: "8") 
      get :index
      expect(assigns(:home_appliances)).to match(home_appliances.sort{ |a, b| b.created_at <=> a.created_at } )
    end

    it "@hobbiesが期待される値を持つか？" do
      hobbies = create_list(:content, 10, category_id: "6") 
      get :index
      expect(assigns(:hobbies)).to match(hobbies.sort{ |a, b| b.created_at <=> a.created_at } )
    end
  end

  describe 'DELETE #destroy' do
    let(:content) { FactoryBot.create(:content) }
      it "リクエストが成功すること" do
      expect(content).to be_valid
      end
      it "商品が削除されること" do
        content=create(:content)
        expect do
          delete :destroy, params:{ id: content }
        end.to change(Content, :count).by(-1)
      end
  end
end