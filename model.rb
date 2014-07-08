## REGISTRATION

def checks_username_password(user_hash)
  if user_hash[:username] == "" && user_hash[:password] == ""
    flash[:registration] = "Username and password is required"
    redirect '/register'
  elsif user_hash[:username] == ""
    flash[:registration] = "Username is required"
    redirect '/register'
  elsif user_hash[:password] == ""
    flash[:registration] = "Password is required"
    redirect '/register'
  else
    unique_username(user_hash)
  end
end

def unique_username(user_hash)
  match = @user_database.all.select do |existing_user|
    existing_user[:username] == user_hash[:username]
  end
  if match != []
    flash[:registration] = "This username is already taken"
    redirect '/register'
  elsif match == []
    @user_database.insert(user_hash)
    flash[:notice] = "Thank you for registering"
    redirect '/'
  end
end

## LOGIN ERRORS

def check_for_registered_user(user, password)
  match = @user_database.all.select do |existing_user|
    existing_user[:username] == user && existing_user[:password] == password
  end

  if user == ""
    flash[:registration] = "No username entered"
  elsif password == ""
    flash[:registration] = "No password entered"
  elsif match == []
    flash[:registration] = "Username/password combination not found"
  end
end


##LOGIN-SESSIONS

def create_session_id(user, password)
  @user_database.all.each do |user_hash|
    if user_hash[:username] == user && user_hash[:password] == password
      session[:user_id] = user_hash[:id]
    end
  end
end

##HTML LIST GENERATORS

def generate_html_userlist(user)
  output = @user_database.all.map do |hash|
    if hash[:username] != user
    '<li>' + "<a href='/#{hash[:username]}/#{hash[:id]}/fish'>#{hash[:username]}</a>" + delete_button_html(hash[:username], hash[:id]) + '</li>'
    end
  end
  output.join
end

def generate_html_fishlist(fishes, id)
  output = fishes.map do |hash|
    if hash[:author] == id
    '<li>' + "<a href='#{hash[:wiki]}'>" + hash[:name] + '</a>' + '</li>'
    end
  end
  output.join
end

def delete_button_html(username, id)
  "<br><form action='/delete' method='post'><button name='delete_user' type='submit' value='#{id}'>Delete #{username}</button></form>"
end

