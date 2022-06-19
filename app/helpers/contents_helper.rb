module ContentsHelper
  def explanation_placeholder
    <<-"EOS".strip_heredoc
      商品の説明（色、素材、重さ、定価、注意点など）
      
      例）・2010年頃に1万円で購入したジャケット
      　　・ライトグレーで傷はあり
      　　・あわせやすいのでおすすめ！
    EOS
  end
end
