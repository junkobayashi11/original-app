require 'rails_helper'

RSpec.describe "Rooms", type: :request do
  before do
    @room = FactoryBot.create(:room)
  end

  describe "GET #index" do
    it 'indexアクションのリクエストが成功すること' do
      get root_path
      expect(response.status).to eq 200
    end

    it '投稿済みのルームが表示されること' do
      get root_path
      expect(response.body).to include(@room.room_name)
    end

    it '検索フォームが存在すること' do
      get root_path
      expect(response.body).to include('ルームを検索する')
    end

    it '検索ボタンが存在すること' do
      get root_path
      expect(response.body).to include("検索")
    end
  end

  describe "GET #show" do
    it 'showアクションのリクエストが成功すること' do
      get room_path(@room)
      expect(response.status).to eq 200
    end

    it '投稿済みのルームが存在すること' do
      get room_path(@room)
      expect(response.body).to include(@room.room_name)
    end

    it '投稿のフォームが存在すること' do
      get room_path(@room)
      expect(response.body).to include("コメントする")
    end

    it '検索ボタンが存在すること' do
      get room_path(@room)
      expect(response.body).to include("送信")
    end
  end
end