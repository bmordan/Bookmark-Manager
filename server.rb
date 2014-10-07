require 'sinatra/base'
require 'data_mapper'

class BookmarkManager < Sinatra::Base

  env = ENV["RACK_ENV"] || "development"
  DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")
  require './lib/link'
  require './lib/tag'
  DataMapper.finalize
  DataMapper.auto_upgrade!

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
    puts tag.links.inspect
    erb :index
  end

  run! if app_file == $0
end