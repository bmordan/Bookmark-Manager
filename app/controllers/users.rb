get '/users/new' do
  @user = User.new
  erb :"users/new", :layout => !request.xhr?
end

post '/users' do
  @user = User.new(:email => params[:email], 
              :password => params[:password],
              :password_confirmation => params[:password_confirmation])  
  if @user.save
    session[:user_id] = @user.id
    redirect to('/')
  else
    flash.now[:errors] = @user.errors.full_messages
    erb :"users/new"
  end
end

post '/users/reset' do
  @email = params[:email]
  @user = User.first(:email => @email)
  redirect '/users/new' if @user.nil?
  token = @user.password_token
  @user.update(:password_token => token)
  link = base_url+'/users/reset_password/:'+token
  send_email(@user.email,link)
  erb :"users/reset"
end

get '/users/reset_password' do
  params[:token].nil? ? @reset = false : @reset = true
  erb :"users/reset"
end

get '/users/reset_password/:token' do
  params[:token].nil? ? @reset = false : @reset = true
  puts params[:token]
  @user = User.first(:password_token => params[:token].slice(1..params[:token].length))
  raise "Sorry we cant find that user, try again" if @user.nil?
  TimeDifference.between(@user.updated_at.to_time, Time.new).in_minutes > 20 ? @expired = true : @expired = false
  erb :"users/reset"
end

post '/users/reset_password_save' do
  user = User.get(params[:user_id])
  password = BCrypt::Password.create(params[:password])
  user.update(:password_digest => password)
end

