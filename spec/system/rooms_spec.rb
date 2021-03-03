require 'rails_helper'

RSpec.describe "Rooms", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @room = FactoryBot.create(:room)
  end

  context 'ルーム作成できるとき' do
    it 'メンバー募集できるとき' do
      # ログインする
      visit new_user_session_path
      fill_in 'Eメール', with: @user.email
      fill_in 'パスワード', with: @user.password
      find('input[name="commit"]').click
      expect(current_path).to eq(root_path)
      # トップページに遷移する
      visit rooms_path
      # メンバー募集のボタンが表示されていることを確認する
      expect(page).to have_content('メンバー募集')
      # 投稿ページに遷移する
      visit new_room_path
      # フォームに情報を入力する
      fill_in 'ルーム名', with: @room.room_name
      select '2020', from: 'room[host_date(1i)]'
      select '1月', from: 'room[host_date(2i)]'
      select '1', from: 'room[host_date(3i)]'
      select '10', from: 'room[host_date(4i)]'
      select '00', from: 'room[host_date(5i)]'
      select '青森県', from: 'room[prefecture_id]'
      fill_in '主催地(市町村)', with: @room.municipalities
      # 保存するとroomモデルのカウントが1上がることを確認する
      expect{
        find('input[name="commit"]').click
      }. to change {Room.count}.by(1)
      # トップページに投稿したルームが存在することを確認する
      expect(page).to have_content(@room.room_name)
    end
  end

  context 'ルーム作成できないとき' do
    it 'メンバー募集できないとき' do
      # ログインする
      visit new_user_session_path
      fill_in 'Eメール', with: @user.email
      fill_in 'パスワード', with: @user.password
      find('input[name="commit"]').click
      expect(current_path).to eq(root_path)
      # トップページに遷移する
      visit root_path
      # メンバー募集のボタンが表示されていることを確認する
      expect(page).to have_content('メンバー募集')
      # 投稿ページに遷移する
      visit new_room_path
      # フォーム情報を入力する
      fill_in 'ルーム名', with: ""
      select '2020', from: 'room[host_date(1i)]'
      select '1月', from: 'room[host_date(2i)]'
      select '1', from: 'room[host_date(3i)]'
      select '10', from: 'room[host_date(4i)]'
      select '00', from: 'room[host_date(5i)]'
      select '---', from: 'room[prefecture_id]'
      fill_in '主催地(市町村)', with: ""
      # 保存してもroomモデルのカウントが上がらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Room.count}.by(0)
      # 新規投稿ページに戻ることを確認する
      expect(current_path).to eq ('/rooms')
    end
  end
end