require 'bcrypt'

class User
  
  include DataMapper::Resource

  property :id,              Serial
  property :email,           String, :unique => true, :message => "This email is already taken"
  property :password_digest, Text,   :lazy   => false
  property :password_token,  Text,   :lazy   => false
  property :created_at,      DateTime
  property :updated_at,      DateTime

  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
  end

  attr_reader   :password
  attr_accessor :password_confirmation

  validates_confirmation_of :password

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def self.authenticate(email, password)
    user = first(:email => email)
    user && BCrypt::Password.new(user.password_digest) == password ? user : nil
  end

  def password_token
    (1..32).map{('A'..'Z').to_a.sample}.join
  end

end