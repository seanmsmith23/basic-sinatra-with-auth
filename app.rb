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
    @fish_database = []
  end

  post "/signout" do
    session.delete(:user_id)
    redirect '/'
  end

  post "/signin" do
    user = params[:username]
    pwrd = params[:password]

    check_for_registered_user(user, pwrd)
    create_session_id(user, pwrd)

    redirect "/"
  end

  get "/" do

    if session[:user_id]
      user_hash = @user_database.find(session[:user_id])
      user_name = user_hash[:username]
      puts user_name
      erb :logged_in, :locals => { :name => user_name, :user_list => generate_html_userlist(user_name), :fish_list => generate_html_fishlist(@fish_database, session[:user_id]) }
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

  post "/fish/new" do
    fish_entry = { name: params[:fish_name], wiki: params[:wikipedia], author: session[:user_id] }
    @fish_database << fish_entry
    redirect "/"
  end

  post "/delete" do
    user_id_to_delete = params[:delete_user].to_i
    @user_database.delete(user_id_to_delete)
    redirect "/"
  end

  get "/:username/:id/fish" do
    user_id = params[:id].to_i
    username = params[:username]
    erb :users_fish, :locals => { :the_fish => generate_html_fishlist(@fish_database, user_id), :name => username }
  end

end