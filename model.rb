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
    @user_database.insert(user_hash)
    flash[:notice] = "Thank you for registering"
    redirect '/'
  end
end

