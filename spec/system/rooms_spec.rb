require 'rails_helper'

RSpec.describe "Rooms", type: :system do
  before do
    @room = FactoryBot.create(:room)
  end

  context 'ルーム作成できるとき' do
    it 'メンバー募集できる' do
      # ログインする
      sign_in(@room.user)
      # トップページに遷移する
      visit rooms_path
      # メンバー募集のボタンが表示されていることを確認する
      expect(page).to have_content('メンバー募集')
      # 投稿ページに遷移する
      visit new_room_path
      # フォームに情報を入力する
      fill_in 'ルーム名', with: @room.room_name
      host_date(@room)
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
    it 'メンバー募集できない' do
      # ログインする
      sign_in(@room.user)
      # トップページに遷移する
      visit root_path
      # メンバー募集のボタンが表示されていることを確認する
      expect(page).to have_content('メンバー募集')
      # 投稿ページに遷移する
      visit new_room_path
      # フォーム情報を入力する
      fill_in 'ルーム名', with: ""
      host_date_no(@room)
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

RSpec.describe 'ルーム編集', type: :system do
  before do
    @room1 = FactoryBot.create(:room)
    @room2 = FactoryBot.create(:room)
  end

  context 'ルーム編集できるとき' do
    it 'ログインしたユーザーは自分の作成したルームを編集することができる' do
      # ルーム1で作成したユーザーでログインする
      sign_in(@room1.user)
      # ルーム1に「編集」ボタンがあることを確認する
      expect(page).to have_link '編集', href: edit_room_path(@room1)
      # 編集ページに遷移する
      visit edit_room_path(@room1)
      # すでに投稿済みの内容がフォームに入っていることを確認する
      expect(
        find('#room_room_name').value
      ).to eq(@room1.room_name)
      host_date(@room)
      expect(
        find('#prefecture').value
      ).to eq"#{@room1.prefecture_id}"
      expect(
        find('#room_municipalities').value
      ).to eq(@room1.municipalities)
      # 投稿内容を編集する
      fill_in 'room_room_name', with: "#{@room1.room_name}+編集したルーム名"
      host_date(@room)
      select '山形県', from: 'room[prefecture_id]'
      fill_in '主催地(市町村)', with: "#{@room1.municipalities}+編集した主催地（市町村）"
      # 編集してもroomモデルのカウントは変わらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change{Room.count}.by(0)
      # トップページに先程変更したルームの内容が存在することを確認する
      expect(page).to have_content("#{@room1.room_name}+編集したルーム名")
      expect(page).to have_content("#{@room1.municipalities}+編集した主催地（市町村）")
    end
  end

  context 'ルーム編集できないとき' do
    it 'ログインしたユーザーは自分以外の投稿の編集画面には遷移できない' do
      # ルーム1を作成したユーザーでログインする
      sign_in(@room1.user)
      # ルーム2に「編集」ボタンがないことを確認する
      expect(page).to have_no_link '編集', href: edit_room_path(@room2)
    end

    it 'ログインしていないとルーム編集画面には遷移できない' do
      # トップページにいる
      visit root_path
      # ツイート1に「編集」ボタンがないことを確認する
      expect(page).to have_no_link '編集', href: edit_room_path(@room1)
      # ツイート2に「編集」ボタンがないことを確認する
      expect(page).to have_no_link '編集', href: edit_room_path(@room2)
    end
  end
end

RSpec.describe 'ルーム削除', type: :system do
  before do
    @room1 = FactoryBot.create(:room)
    @room2 = FactoryBot.create(:room)
  end

  context 'ルーム削除できるとき' do
    it 'ログインしたユーザーは自ら作成したルームを削除することができる' do
      # ルーム1を作成したユーザーがログインする
      sign_in(@room1.user)
      # ルーム1に「削除」ボタンがあることを確認する
      expect(page).to have_link '削除', href: room_path(@room1)
      # ルームを削除するとルームカウントが1減ることを確認する
      expect{
        page.accept_confirm do
          find_link('削除', href: room_path(@room1)).click
        end
      sleep 0.5
      }.to change{ Room.count }.by(-1)
      # トップページにいることを確認する
      expect(current_path).to eq(root_path)
      # トップページにはルーム1が存在しないことを確認する
      expect(page).to have_no_content("#{@room1}")
      # トップページにはルーム1が存在しないことを確認する（編集ボタン）
      expect(page).to have_no_link "編集", href: edit_room_path(@room1)
      # ルームを削除したら付随するコメントも削除できていることを確認する
      expect{@room1.destroy}.to change{ Comment.count }.by(0)
    end
  end

  context 'ルーム削除できないとき' do
    it 'ログインしたユーザーは自分以外が投稿したルームを削除することができない' do
      # ルーム1を作成したユーザーでログインする
      sign_in(@room1.user)
      # ルーム2に「削除」ボタンがないことを確認する
      expect(page).to have_no_link "削除", href: room_path(@room2)
    end

    it 'ログインしていなければ削除ボタンがない' do
      # トップページに移動する
      visit root_path
      # ツイート1に「削除」ボタンがないことを確認する
      expect(page).to have_no_link "削除", href: room_path(@room1)
      # ツイート2に「削除」ボタンがないことを確認する
      expect(page).to have_no_link "削除", href: room_path(@room2)
    end
  end
end

RSpec.describe 'ルーム詳細', type: :system do
  before do
    @room = FactoryBot.create(:room)
    @comment = FactoryBot.build(:comment)
  end

  context 'コメントできるとき' do
    it 'ログインしたユーザーはコメントページに遷移しコメント投稿ができる' do
      # ログインする
      sign_in(@room.user)
      # ルームに「コメント」ボタンがあることを確認する
      expect(page).to have_link "コメント", href: room_path(@room)
      # コメント詳細ページに遷移する
      visit room_path(@room)    
      # コメント用のフォームが存在する
      expect(page).to have_selector 'form'
      # フォームに情報を入力する
      fill_in "comment_text", with: @comment.text
      find('input[name="commit"]').click
      # コメントすると詳細ページに表示される
      expect(page).to have_content("#{@comment.text}")
    end
  end

  context 'コメントできないとき' do
    it 'ログインしていない状態ではコメントができない' do
      # トップページに遷移する
      visit root_path
      # ルームに「コメント」がないことを確認する
      expect(page).to have_no_content("コメント")
    end
  end
end

