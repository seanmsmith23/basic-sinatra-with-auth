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

  scenario "user should see error messages (flash) when not providing username or password" do
    visit '/register'

    click_button "Submit"

    expect(page).to have_content("Username and password is required")

    fill_in "username", :with => "Sean"
    click_button "Submit"

    expect(page).to have_content("Password is required")

    fill_in "password", :with => "pass"
    click_button "Submit"

    expect(page).to have_content("Username is required")

  end

  scenario "user cannot register a username that already exists" do
    visit '/register'

    fill_in "username", :with => "Sean"
    fill_in "password", :with => "baby"

    click_button "Submit"

    visit '/register'

    fill_in "username", :with => "Sean"
    fill_in "password", :with => "second"

    click_button "Submit"

    expect(page).to have_content("This username is already taken")
  end

end

feature "login" do
  scenario "user should be able to login and see welcome message" do
    visit '/register'

    fill_in "username", :with => "Sean"
    fill_in "password", :with => "baby"

    click_button "Submit"

    visit '/'

    fill_in "username", :with => "Sean"
    fill_in "password", :with => "baby"

    click_button "Login"
    expect(page).to have_content("Welcome, Sean")
  end
  scenario "a user should see list of all users after logging in, but not themselves" do
    visit '/register'

    fill_in "username", :with => "Sean"
    fill_in "password", :with => "baby"

    click_button "Submit"

    visit '/register'

    fill_in "username", :with => "Bobby"
    fill_in "password", :with => "baby"

    click_button "Submit"

    visit '/register'

    fill_in "username", :with => "Peter"
    fill_in "password", :with => "baby"

    click_button "Submit"

    visit '/'

    fill_in "username", :with => "Sean"
    fill_in "password", :with => "baby"

    click_button "Login"

    expect(page).to have_content("Bobby")
    expect(page).to have_content("Peter")
    within('h2#other_users') { expect(page).to_not have_content("Sean") }
  end

  scenario "a user should see error messages if they haven't registered before login" do
    visit '/'

    fill_in "username", :with => "Henry"
    fill_in "password", :with => "baby"

    click_button "Login"

    expect(page).to have_content("Username/password combination not found")

    visit '/'

    fill_in "username", :with => "Henry"
    click_button "Login"

    expect(page).to have_content("No password entered")

    visit '/'

    fill_in "password", :with => "baby"
    click_button "Login"

    expect(page).to have_content("No username entered")

  end

end

feature "logged in vs logged out" do
  scenario "user should have different views depending on if they are logged in or logged out" do
    visit '/register'

    fill_in "username", :with => "Sean"
    fill_in "password", :with => "baby"

    click_button "Submit"

    visit '/'

    fill_in "username", :with => "Sean"
    fill_in "password", :with => "baby"

    click_button "Login"
    expect(page).to have_content("Welcome, Sean")

    visit '/'

    expect(page).to have_content("Welcome, Sean")
    expect(page).to have_button("Logout")
  end
end

feature "logging out works" do
  scenario "when a user clicks logout they are taken to the homepage. should see login and register" do
    visit '/register'

    fill_in "username", :with => "Sean"
    fill_in "password", :with => "baby"

    click_button "Submit"

    visit '/'

    fill_in "username", :with => "Sean"
    fill_in "password", :with => "baby"

    click_button "Login"

    visit '/'

    click_button "Logout"

    expect(page).to have_content("Register")
    expect(page).to have_button("Login")
  end
end

feature "fish" do
  scenario "user can create fish and view them on the homepage" do
    visit '/register'

    fill_in "username", :with => "Sean"
    fill_in "password", :with => "baby"

    click_button "Submit"

    visit '/'

    fill_in "username", :with => "Sean"
    fill_in "password", :with => "baby"

    click_button "Login"

    visit '/'

    expect(page).to have_content("Create Fish:")

    fill_in "fish_name", :with => "Puffer"
    fill_in "wikipedia", :with => "http://en.wikipedia.org/wiki/Tetraodontidae"

    click_button "Create Fish"

    expect(page).to have_content "Puffer"

    click_link "Puffer"

    expect(page).to have_content "Tetraodontidae"
  end

  scenario "user can only view fish that they create" do
    visit '/register'

    fill_in "username", :with => "Sean"
    fill_in "password", :with => "baby"

    click_button "Submit"

    visit '/register'

    fill_in "username", :with => "Paul"
    fill_in "password", :with => "baby"

    click_button "Submit"

    visit '/'

    fill_in "username", :with => "Sean"
    fill_in "password", :with => "baby"

    click_button "Login"

    visit '/'

    expect(page).to have_content("Create Fish:")

    fill_in "fish_name", :with => "Puffer"
    fill_in "wikipedia", :with => "http://en.wikipedia.org/wiki/Tetraodontidae"

    click_button "Create Fish"

    expect(page).to have_content "Puffer"

    click_button "Logout"

    visit '/'

    fill_in "username", :with => "Paul"
    fill_in "password", :with => "baby"

    click_button "Login"

    expect(page).to_not have_content "Puffer"

  end
end