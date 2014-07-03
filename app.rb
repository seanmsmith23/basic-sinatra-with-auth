require "sinatra"
require "rack-flash"
require_relative "model"

require "./lib/user_database"

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @user_database = UserDatabase.new
  end

  post "/signout" do
    session.delete(:user_id)
    redirect '/'
  end

  post "/signin" do
    user = params[:username]
    pwrd = params[:password]

    @user_database.all.each do |user_hash|
      if user_hash[:username] == user && user_hash[:password] == pwrd
        session[:user_id] = user_hash[:id]
      end
    end

    redirect "/"
  end

  get "/" do

    if session[:user_id]
      user_hash = @user_database.find(session[:user_id])
      user_name = user_hash[:username]
      erb :logged_in, :locals => { :name => user_name }
    else
      erb :root
    end

  end

  get "/register" do
    erb :register
  end

  post "/register" do
    user = { :username => params[:username], :password => params[:password] }
    checks_username_password(user)
  end

end