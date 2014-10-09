class Link
  
  include DataMapper::Resource

  property :id, Serial
  property :title, String
  property :url, Text

  has n, :tags,  :through => Resource

end