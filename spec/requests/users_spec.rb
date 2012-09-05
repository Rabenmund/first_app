require 'spec_helper'

describe "Static pages" do

  subject     { page }
  let(:user)  { create :user }
  let(:admin) { create :admin}
  
  before { user.activate!; signin user }
  
  describe :index do
    describe "user cannot see inactive users" do
      before do 
        @user = create :user
        visit users_path
      end
      it { should_not have_selector('title', text: '| Home') }
      it { should_not have_content(@user.name) }
      it { should_not have_link(@user.nickname, href: user_path(@user)) }
    end
    describe "user sees active user" do
      before do 
        @user = create :user
        @user.activate!
        visit users_path
      end
      it { should have_content(@user.name) }
      it { should have_link(@user.nickname, href: user_path(@user)) }
    end
    describe "admin sees all" do
      before do
        @user = create :user
        signout user
        signin admin
        visit users_path
      end
      it { should have_content(user.name) }
      it { should have_link(user.nickname, href: user_path(user)) }
      it { should have_content(@user.name) }
      it { should have_link(@user.nickname, href: user_path(@user)) }
    end
  end
  
  describe :new do
    before do
      signout user
      signin admin
      visit new_user_path
      fill_in "user_nickname", with: "Nickname"
      fill_in "user_name", with: "MeinName"
      fill_in "user_email", with: "MeinName@example.com"
      fill_in "user_password", with: "password"
      fill_in "user_password_confirmation", with: "password"
      click_button "Speichern"
    end
    specify { User.last.name.should eq "MeinName" }
  end
  
  describe :edit do
    before { visit edit_user_path(user) }
    it { should_not have_content("Name")}
    describe "user edits himself" do
      before do
        fill_in "user_nickname", with: "New Nickname"
        click_button "Speichern"
      end
      it { should have_content("New Nickname")}
    end
  end
  
  describe :show do
    before { visit user_path(user) }
    it { should have_content user.name }
    it { should have_content user.nickname }
    it { should have_link("Einstellung", href: edit_user_path(user))}
    describe :show_other_user do
      before { @user = create :user; visit user_path(@user) }
      it { should_not have_link("Einstellung", href: edit_user_path(@user))}
    end
  end
  
end