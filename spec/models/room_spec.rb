require 'rails_helper'

RSpec.describe Room, type: :model do
  before do
    @room = FactoryBot.build(:room)
  end

  describe 'ルーム投稿機能' do
    context 'ルーム投稿できるとき' do
      it '全て正しく入力されていれば登録できる' do
        expect(@room).to be_valid
      end
    end

    context 'ルーム投稿できないとき' do
      it 'room_nameが空では登録できない' do
        @room.room_name = ""
        @room.valid?
        expect(@room.errors.full_messages).to include("Room nameを入力してください")
      end

      it 'prifectrue_idが1では登録できないとき' do
        @room.prefecture_id = 1
        @room.valid?
        expect(@room.errors.full_messages).to include("PrefectureSelect")
      end

      it 'municipalitiesが空では登録できないとき' do
        @room.municipalities = ""
        @room.valid?
        expect(@room.errors.full_messages).to include("Municipalitiesを入力してください")
      end

      it 'userと紐付いていなければ登録できない' do
        @room.user = nil
        @room.valid?
        expect(@room.errors.full_messages).to include("Userを入力してください")
      end
    end
  end
end
