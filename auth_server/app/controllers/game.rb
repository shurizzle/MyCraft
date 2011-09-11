AuthServer.controllers :game do
  post :getversion, :map => '/game/getversion.jsp' do
    return 'Old version' if params[:version].to_i < 13

    if account = Account.authenticate(params[:user], params[:password])
      uuid = UUID.generate(:compact)
      account.update(session_hash: uuid)
      "2:unused:#{account.nick}:#{uuid}:"
    else
      'STICAZZI?'
    end
  end

  get :joinserver, :map => '/game/joinserver.jsp' do
    if account = Account.first(nick: params[:user], session_hash: params[:sessionId])
      account.update(server_hash: params[:serverId])
      'OK'
    else
      'Bad login'
    end
  end

  get :checkserver, :map => '/game/checkserver.jsp' do
    if Account.first(nick: params[:user], server_hash: params[:serverId])
      'YES'
    else
      'Failed to verify username!'
    end
  end
end
