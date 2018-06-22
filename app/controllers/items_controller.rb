class ItemsController < ApplicationController
  before_action :require_user_logged_in
  
  def new
    # @itemsをカラの配列として初期化
    @items = []
    
    # フォームから送信される検索ワードの取得
    @keyword = params[:keyword]
    if @keyword.present? #
      results = RakutenWebService::Ichiba::Item.search({
        keyword: @keyword,
        imageFlag: 1,
        hits: 20,
      })
      
      # resultsからItemモデルのインスタンスを作成
      results.each do |result|
        item = Item.find_or_initialize_by(read(result))
        # itemを[]に追加
        @items << item
      end
    end
  end
  
  def show
    @item = Item.find(params[:id])
    @want_users = @item.want_users
    @have_users = @item.have_users
  end
end