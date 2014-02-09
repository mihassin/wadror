module OwnTestHelper

  def sign_in(creds)
    visit signin_path
    fill_in('username', with:creds[:username])
    fill_in('password', with:creds[:password])
    click_button('Log in')
  end

  def create_rating(fill_in_data)
    visit new_rating_path
    select(fill_in_data[:beer], from:'rating[beer_id]')
    fill_in('rating[score]', with:fill_in_data[:score])
    click_button "Create Rating"
  end
end
