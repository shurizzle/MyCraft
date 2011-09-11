AuthServer.controllers :session do
  post :create do
    if account = Account.authenticate(params[:nick], params[:password])
      set_current_account(account)
      redirect url(:user, :show, nick: account.nick)
    else
      flash[:warning] = 'Login or password wrong.'
      redirect url(:login)
    end
  end

  get :destroy do
    set_current_account(nil)
    redirect url(:index)
  end
end
