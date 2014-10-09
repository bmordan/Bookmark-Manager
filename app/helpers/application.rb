helpers do

  def current_user    
    @current_user ||= User.get(session[:user_id]) if session[:user_id]
  end

  def base_url
    @base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
  end

  def send_email(email,link)
    RestClient.post "https://api:key-3ax6xnjp29jd6fds4gc373sgvjxteol0"\
    "@api.mailgun.net/v2/samples.mailgun.org/messages",
    :from => "Excited User <me@samples.mailgun.org>",
    :to => "#{email}",
    :subject => "Hello",
    :text => "Reset your password #{link}"
  end

end