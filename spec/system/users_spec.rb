RSpec.describe 'Users', type: :system do
  let!(:user) { create(:user, name: 'Alice', email: 'alice@example.com', password: 'Abcd1234') }

  describe 'ログイン' do
    before do
      visit new_user_session_path
    end

    context 'フォームの入力値が正常' do
      it 'ログイン成功' do
        fill_in 'user_email', with: 'alice@example.com'
        fill_in 'user_password', with: 'Abcd1234'
        within '.form-actions' do
          click_button 'ログイン'
        end

        expect(page).to have_content 'ログインしました'
        expect(current_path).to eq root_path
      end
    end

    context 'フォームの入力値が異常' do
      it 'ログイン失敗(パスワード不正)' do
        fill_in 'user_email', with: 'alice@example.com'
        fill_in 'user_password', with: 'aaa'
        within '.form-actions' do
          click_button 'ログイン'
        end

        expect(page).to have_css 'h1', text: 'ログイン'
        expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
      end

      it 'ログイン失敗(メールアドレス不正)' do
        fill_in 'user_email', with: 'aaa@example.com'
        fill_in 'user_password', with: 'Abcd1234'
        within '.form-actions' do
          click_button 'ログイン'
        end

        expect(page).to have_css 'h1', text: 'ログイン'
        expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
      end
    end
  end

  describe '新規登録' do
    before do
      visit new_user_registration_path
    end

    context 'フォームの入力値が正常' do
      it '登録成功' do
        fill_in 'user_name', with: 'Bob'
        fill_in 'user_email', with: 'bob@example.com'
        fill_in 'user_password', with: 'Abcd1234'
        fill_in 'user_password_confirmation', with: 'Abcd1234'
        within '.form-actions' do
          click_button '新規登録'
        end

        expect(page).to have_content 'アカウント登録が完了しました。'
        expect(current_path).to eq root_path
      end
    end

    context 'フォームの入力値が異常' do
      it '登録失敗' do
        fill_in 'user_name', with: 'Bob'
        fill_in 'user_email', with: 'alice@example.com'
        fill_in 'user_password', with: 'Abcd1234'
        fill_in 'user_password_confirmation', with: 'Abcd1235'
        within '.form-actions' do
          click_button '新規登録'
        end

        expect(page).to have_content 'メールアドレスはすでに存在します'
        expect(page).to have_content 'パスワード（確認用）とパスワードの入力が一致しません'
        expect(page).to have_css 'h1', text: '新規登録'
      end

      it '登録失敗（パスワード不正）' do
        fill_in 'user_name', with: 'Bob'
        fill_in 'user_email', with: 'bob@example.com'
        fill_in 'user_password', with: '12345678'
        fill_in 'user_password_confirmation', with: '12345678'
        within '.form-actions' do
          click_button '新規登録'
        end

        expect(page).to have_content '8文字以上20文字以下で半角英数字の小文字、大文字、数字が含まれている必要があります。'
        expect(page).to have_css 'h1', text: '新規登録'
      end
    end

    it 'ログアウトできる', :js do
      user_login(user)
      click_on 'ログアウト'

      expect(page).to have_content 'ログアウトしました。'
    end
  end
end
