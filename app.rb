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

  get "/" do
    user = params[:username]
    pwrd = params[:password]



    @user_database.all.each do |users_database|
      if users_database.has_value?(user) && users_database.has_value?(pwrd)
        session[:user_id] = users_database[:id]
      end
    end

    if session[:user_id]
      # user_info = @user_database.find(session[:user_id])
      erb :logged_in, :locals => { :name => user }
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