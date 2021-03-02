require 'rails_helper'

RSpec.describe Comment, type: :model do
  before do
    @comment = FactoryBot.build(:comment)
  end

  describe 'コメント投稿機能' do
    context 'コメント投稿できるとき' do
      it '入力されていれば登録できる' do
        expect(@comment).to be_valid
      end
    end

    context 'コメント投稿できないとき' do
      it 'コメントが空では投稿できない' do
        @comment.text = ""
        @comment.valid?
        expect(@comment.errors.full_messages).to include("Textを入力してください")
      end

      it 'コメントがuserと紐付いていなければ投稿できない' do
        @comment.user = nil
        @comment.valid?
        expect(@comment.errors.full_messages).to include("Userを入力してください")
      end

      it 'コメントがroomと紐付いていなければ投稿できない' do
        @comment.room = nil
        @comment.valid?
        expect(@comment.errors.full_messages).to include("Roomを入力してください")
      end
    end
  end
end
