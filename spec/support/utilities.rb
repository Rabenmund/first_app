include ApplicationHelper

def signin(user)
  visit new_session_path
  fill_in "session_auth",    with: user.email
  fill_in "session_password", with: user.password
  click_button "submit"
end

def signout(user)
  click_link "Abmelden"
end
