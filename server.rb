env = ENV["RACK_ENV"] || "development"
require 'data_mapper'
DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")
require './lib/link'
DataMapper.finalize
DataMapper.auto_upgrade!

require 'sinatra/base'


class BookmarkManager < Sinatra::Base
  get '/' do
    @links = Link.all
    erb :index
  end

  post '/links' do
    url = params["url"]
    title = params["title"]
    Link.create(:url => url, :title => title)
    redirect to('/')
  end

  run! if app_file == $0
end
