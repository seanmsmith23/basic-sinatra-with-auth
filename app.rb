require "sinatra"
require "rack-flash"

require "./lib/user_database"

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @user_database = UserDatabase.new
  end

  post "/signout" do
    print "SESSION ID BEFORE DELETE #{session[:user_id]}"
    session.delete(:user_id)
    print "SESSION ID AFTER DELETE #{session[:user_id]}"
    redirect '/'
  end

  get "/" do
    user = params[:username]
    pwrd = params[:password]

    print "SESSION ID AFTER REDIRECT #{session[:user_id]}"

    @user_database.all.each do |user_hash|
      if user_hash.has_value?(user) && user_hash.has_value?(pwrd)
        session[:user_id] = user_hash[:id]
        print "this is user hash #{user_hash}"
      end
    end

    print "session ID after iteration"

    if session[:user_id]
      puts "THIS IS THE SESSION INFO #{session[:user_id]}"
      user_info = @user_database.find(session[:user_id])
      user_name = user_info[:username]
      puts "USER INFO #{user_info}"
      erb :logged_in, :locals => { :name => user_name }
    else
      erb :root, :locals => { :thanks_notice => "" }
    end

  end

  post "/" do
    user = { :username => params[:username], :password => params[:password], :user_id => nil }
    @user_database.insert(user)
    confirmation = flash.now[:notice] = "Thank you for registering"
    erb :root, :locals => { :thanks_notice => confirmation }
  end

  get "/register" do
    erb :register
  end

end