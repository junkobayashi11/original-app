require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end

  describe 'ユーザー登録' do
    context '新規登録できるとき' do
      it '全て入力されていれば登録できる' do
        expect(@user).to be_valid
      end
    end

    context '新規登録できないとき' do
      it 'nameが空では登録できない' do
        @user.name = ""
        @user.valid?
        expect(@user.errors.full_messages).to include("Nameを入力してください")
      end

      it 'profileが空では登録できない' do
        @user.profile = ""
        @user.valid?
        expect(@user.errors.full_messages).to include("Profileを入力してください")
      end

      it 'prefecture_idが1では登録できない' do
        @user.prefecture_id = 1
        @user.valid?
        expect(@user.errors.full_messages).to include("PrefectureSelect")
      end

      it 'passwordが空では登録できない' do
        @user.password = ""
        @user.valid?
        expect(@user.errors.full_messages).to include("パスワードを入力してください")
      end

      it 'passwordは英数含めなければならない' do
        @user.password = 11111111
        @user.valid?
        expect(@user.errors.full_messages).to include("パスワードには英字と数字の両方を含めて設定してください")
      end

      it 'passwordとpassword_confimationが一致しなければ登録できない' do
        @user.password= "7777jjjj"
        @user.password_confirmation= "7777jjj"
        @user.valid?
        expect(@user.errors.full_messages).to include("パスワード（確認用）とパスワードの入力が一致しません")
      end

      it 'emailが空では登録できない' do
        @user.email = ""
        @user.valid?
        expect(@user.errors.full_messages).to include("Eメールを入力してください")
      end

      it 'emailに@が含まれていなければ登録できない' do
        @user.email = "email.com"
        @user.valid?
        expect(@user.errors.full_messages).to include("Eメールは不正な値です")
      end
    end
  end
end
