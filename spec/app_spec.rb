require "spec_helper"

feature "Homepage" do
  scenario "should have a register button" do
    visit '/'

    expect(page).to have_button("Register")
  end

  scenario "clicking register should take me to a registration page" do
    visit '/'

    click_link "Register"

    expect(page).to have_content("Username")
    expect(page).to have_content("Password")
    expect(page).to have_button("Submit")
  end

end

feature "Registration" do
  scenario "after completing registration form user should see be taken to home page and see confirmation" do
    visit '/register'

    fill_in "username", :with => "Sean"
    fill_in "password", :with => "baby"

    click_button "Submit"
    expect(page).to have_content("Thank you for registering")
    visit '/'
    expect(page).to_not have_content("Thank you for registering")
  end

end

feature "login" do
  scenario "user should be able to login and see welcome message" do
    visit '/'

    fill_in "username", :with => "Sean"
    fill_in "password", :with => "baby"

    click_button "Login"
    expect(page).to have_content("Welcome, Sean")
  end

end

feature "logged in vs logged out" do
  scenario "user should have different views depending on if they are logged in or logged out" do
    visit '/'

    fill_in "username", :with => "Sean"
    fill_in "password", :with => "baby"

    click_button "Login"
    expect(page).to have_content("Welcome, Sean")

    visit '/'
    expect(page).to_not have_button("Register")
    expect(page).to_not have_button("Login``")
    expect(page).to have_button("Logout")

  end
end