require 'sinatra/base'
require 'data_mapper'

class BookmarkManager < Sinatra::Base

  env = ENV["RACK_ENV"] || "development"
  DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")
  Dir["./lib/*"].each { |file| require file }
  DataMapper.finalize
  DataMapper.auto_upgrade!

  set :public_folder, 'public'
  enable :sessions
  set :session_secret, 'super secret'
  
  get '/' do
    @links = Link.all
    erb :index
  end

  post '/links' do
    url = params["url"]
    title = params["title"]
    tags = params["tags"].split(" ").map { |tag| Tag.first_or_create(:text => tag) }
    Link.create(:url => url, :title => title, :tags => tags)
    redirect to('/')
  end

  get '/tags/:text' do
    tag = Tag.first(:text => params[:text])
    @links = tag ? tag.links : []
    erb :index
  end

  get '/users/new' do
    erb :"users/new"
  end

  post '/users' do
    user = User.create(:email => params[:email],:password => params[:password])
    session[:user_id] = user.id
    redirect '/'
  end

  def current_user
    @current_user ||=User.get(session[:user_id]) if session[:user_id]
  end

  run! if app_file == $0
end