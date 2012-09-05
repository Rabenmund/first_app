#!/bin/env ruby
# encoding: utf-8

require 'spec_helper'

describe "Static pages" do

  subject     { page }
  let(:user)  { create :user }
  let(:admin) { create :admin}
  before { user.activate!; signin user }
  
  describe :home do
    before { visit root_path }
    it { should_not have_selector('title', text: '| Home') }
    it { should have_content user.nickname }
    it { should have_link("Startseite", href: root_path) }
    it { should have_link("Hilfe", href: help_path) }
    it { should have_link("Mitspieler", href: users_path) }
    it { should have_link("Profil", href: user_path(user)) }
    it { should have_link("Einstellungen", href: edit_user_path(user)) }
    it { should have_link("Abmelden", href: session_path(user)) }
    it { should have_link("Wir sind...", href: about_path) }
    it { should have_link("Kontakt", href: contact_path) }
    it { should have_selector("textarea", id: "micropost_content") }
    it { should have_selector("i", id: "Kurznachrichten aktualisieren") }
    
    describe :enter_micropost do
      before { fill_in "micropost_content", with: "Test the Post with more than 30 characters and a looooooooooooooooooooooooooooong word"; click_button "commit" }
      it { should have_content("Test the Post with more than 30 characters") }
      describe :can_be_seen_by_other_user do
        before { @user = create :user; @user.activate!; signin @user }
        it { should have_content("Test the Post with more than 30 characters") }
        it { should have_link("#{user.nickname}", href: user_path(Micropost.last.user))}
      end
      describe :can_be_destroyed_by_admin do
        before { signin admin }
        it { should have_content("Test the Post with more than 30 characters") }
        it { should have_link("löschen", href: micropost_path(Micropost.last), method: :delete)}
      end
    end
  end
  
  describe :landing do
    before { visit landing_path }
    it { should_not have_selector('title', text: '| Landing') }
    it { should have_link("Anmelden", href: new_session_path) }
    it { should have_link("Kontakt", href: contact_path) }
  end

  describe :about do
    before { visit about_path }
    it { should have_selector('title', text: '| About Us') }
    it { should have_link("Abmelden", href: session_path(user)) }
    it { should have_link("Kontakt", href: contact_path) }
  end
  
  describe :contact do
    before { signout user; visit contact_path }
    it { should have_selector('title', text: '| Contact') }
    it { should have_link("Anmelden", href: signin_path) }
    it { should have_link("Kontakt", href: contact_path) }
  end
  
  describe :help do
    before { visit help_path }
    it { should have_selector('title', text: '| Help') }
    it { should have_link("Abmelden", href: session_path(user)) }
    it { should have_link("Kontakt", href: contact_path) }
  end
end