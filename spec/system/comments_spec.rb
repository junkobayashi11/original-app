require 'rails_helper'

RSpec.describe "Comments", type: :system do
  before do
    @comment = FactoryBot.create(:comment)
  end

  context 'コメントできるとき' do
    it 'ログインしたユーザーはコメント投稿できる' do
      # ログインする
      sign_in(@comment.user)
      # コメントが表示されていることを確認する
      expect(page).to have_content('コメント')
      # コメント詳細ページに遷移する
      visit room_path(@comment.room)
      # ファーム情報を入力する
      fill_in 'comment_text', with: @comment.text
      # コメントするとcommentモデルのカウントが1上がることを確認する
      expect{
        find('input[name="commit"]').click
      }.to change{Comment.count}.by(1)
      # コメント詳細ページにリダイレクトされることを確認する
      expect(current_path).to eq(room_path(@comment.room))
      # コメント詳細ページに先程コメントした内容が表示されていることを確認する
      expect(page).to have_content(@comment.text)
    end
  end

  context 'コメントできないとき' do
    it 'ログインしたユーザーが空でメッセージを空で送信したとき' do
      # ログインする
      sign_in(@comment.user)
      # コメントが表示されていることを確認する
      expect(page).to have_content("コメント")
      # コメント詳細ページに遷移する
      visit room_path(@comment.room)
      # フォーム情報を入力する
      fill_in "comment_text", with: ""
      # コメントしてもcommentモデルのカウントが0のままであることを確認する
      expect{
        find('input[name="commit"]').click
      }.to change{Comment.count}.by(0)
      # コメント詳細ページにリダイレクトされることを確認する
      expect(current_path).to eq(room_path(@comment.room))
      # コメント詳細ページにコメントが存在しないことを確認する
      expect(page).to have_no_content(@comment)
    end
  end
end
