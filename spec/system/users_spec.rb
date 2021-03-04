require 'rails_helper'

RSpec.describe "Users新規登録", type: :system do
  before do
    @user = FactoryBot.build(:user)
  end

  context 'ユーザーが新規登録できるとき' do
    it '正しい情報を入力すればユーザー新規登録ができてトップページに遷移する' do
      # トップページに遷移する
      visit root_path
      # トップページに新規登録ボタンがあることを確認する
      expect(page).to have_content('新規登録')
      # 新規登録ページへ遷移する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in "ユーザー名", with: @user.name
      fill_in "Eメール", with: @user.email
      fill_in "パスワード", with: @user.password
      fill_in "password (再入力)", with: @user.password_confirmation
      fill_in "電話番号", with: @user.phone_number
      fill_in "プロフィール", with: @user.profile
      select '青森県', from: 'user[prefecture_id]'
      # 新規登録ボタンを押すとユーザーモデルのカウントが1上がることを確認する
      expect{
        find('input[name="commit"]').click
      }.to change{ User.count }.by(1)
      # トップページへ遷移することを確認する
      expect(current_path).to eq(root_path)
      # ログインボタンと新規登録のボタンが表示されていることを確認する
      expect(page).to have_no_content('新規登録')
      expect(page).to have_no_content('ログイン')
    end
  end

  context 'ユーザー新規登録ができないとき' do
    it '誤った情報ではユーザー新規登録ができずに新規登録ページに戻ってくる' do
      # トップページに遷移する
      visit root_path
      # トップページに新規登録ボタンがあることを確認する
      expect(page).to have_content('新規登録')
      # 新規登録ページへ遷移する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in "ユーザー名", with: ""
      fill_in "Eメール", with: ""
      fill_in "パスワード", with: ""
      fill_in "password (再入力)", with: ""
      fill_in "電話番号", with: ""
      fill_in "プロフィール", with: ""
      select '---', from: 'user[prefecture_id]'
      # 新規登録ボタンを押してもユーザーモデルのカウントが上がらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change{User.count}.by(0)
      # 新規登録ページへ戻ることを確認する
      expect(current_path).to eq('/users')
      # ログインボタンと新規登録のボタンが表示されていることを確認する
      expect(page).to have_content('新規登録')
      expect(page).to have_content('ログイン')
    end
  end
end

RSpec.describe 'ログイン', type: :system do
  before do
  @user = FactoryBot.create(:user)
  end

  context 'ログインできるとき' do
    it '保存されているユーザーの情報と合致すればログインできる' do
      # トップページに遷移する
      visit root_path
      # トップページにログインボタンが表示されることを確認する
      expect(page).to have_content("ログイン")
      # ログインへ遷移する
      visit new_user_session_path
      # 正しい情報を入力する
      fill_in 'Eメール', with: @user.email
      fill_in 'パスワード', with: @user.password
      # ログインボタンを押す
      find('input[name="commit"]').click
      # ログアウトボタンとメンバー募集ボタンが表示されることを確認する
      expect(page).to have_content("ログアウト")
      expect(page).to have_content("メンバー募集")
    end
  end

  context 'ログインできないとき' do
    it '保存されているユーザーの情報が合致しないとログインできない' do
      # トップページに遷移する
      visit root_path
      # トップページにログインボタンが表示されることを確認する
      expect(page).to have_content("ログイン")
      # ログインページに遷移する
      visit new_user_session_path
      # ユーザー情報を入力する
      fill_in 'Eメール', with: ""
      fill_in 'パスワード', with: ""
      # ログインボタンを押す
      find('input[name="commit"]').click
      # ログインページへ戻されることを確認する
      expect(current_path).to eq(new_user_session_path)
    end
  end
end