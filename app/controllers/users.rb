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

get '/users/reset_password' do
  params[:token].nil? ? @reset = false : @reset = true
  erb :"users/reset"
end

get '/users/reset_password/:token' do
  params[:token].nil? ? @reset = false : @reset = true
  @user = User.first(:password_digest => params[:token])
  erb :"users/reset"
end

post '/users/reset' do
  @email = params[:email]
  @user = User.first(:email => @email)
  token = @user.password_token
  @user.update(:password_digest => token)
  link = base_url+'/users/reset_password/:'+token
  #puts link+'|'+@user.updated_at.to_s
  erb :"users/reset"
end