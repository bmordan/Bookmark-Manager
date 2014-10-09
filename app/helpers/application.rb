helpers do

  def current_user    
    @current_user ||= User.get(session[:user_id]) if session[:user_id]
  end

  def base_url
    @base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
  end

  def send_email(email,link)
    RestClient.post "https://api:key-7577f504028fa8de43dc70aea8bdb787@api.mailgun.net/v2/app30532338.mailgun.org/messages",
    :from => "bookmarkmanager <bookmarks@manager.org>",
    :to => "#{email}",
    :subject => "Reset your password",
    :text => "Reset your password #{link}"
  end

end