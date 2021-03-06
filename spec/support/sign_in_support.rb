module SignInSupport
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Eメール', with: user.email
    fill_in 'パスワード', with: user.password
    find('input[name="commit"]').click
    expect(current_path).to eq(root_path)
  end

  def host_date(room)
    select '2020', from: 'room[host_date(1i)]'
    select '1月', from: 'room[host_date(2i)]'
    select '1', from: 'room[host_date(3i)]'
    select '10', from: 'room[host_date(4i)]'
    select '00', from: 'room[host_date(5i)]'
  end

  def host_date_no(room)
    select '2020', from: 'room[host_date(1i)]'
    select '1月', from: 'room[host_date(2i)]'
    select '1', from: 'room[host_date(3i)]'
    select '10', from: 'room[host_date(4i)]'
    select '00', from: 'room[host_date(5i)]'
    select '---', from: 'room[prefecture_id]'
  end
end