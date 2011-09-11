AuthServer.controllers do
  get :login do
    redirect url(:index) if logged_in?

    render 'base/login'
  end

  get :logout do
    if logged_in?
      redirect url(:session, :destroy)
    else
      redirect url(:index)
    end
  end

  get :index do
    'YAY! THE INDEX!1!!'
  end

  post :index do
    return 'Old version' if params[:version].to_i < 13

    if account = Account.authenticate(params[:user], params[:password])
      uuid = UUID.generate(:compact)
      account.update(session_hash: uuid)
      "2:unused:#{account.nick}:#{uuid}:"
    else
      'STICAZZI?'
    end
  end

  get :MinecraftSkins, with: :nick, provides: :png do
    account = Account.first(nick: params[:nick])
    file = File.join('public', 'images', 'skin', "#{account.nick rescue nil}.png")

    response['Content-Type'] = 'application/octet-stream'

    if File.exists?(file)
      File.read(file)
    else
      File.read(File.join('public', 'images', 'default_skin.png'))
    end
  end
end
