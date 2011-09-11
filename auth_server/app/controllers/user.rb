require 'oily_png'

AuthServer.controllers :user do
  get :new do
    @account = Account.new
    render 'user/new'
  end

  post :create do
    @account = Account.new(params[:account])

    if @account.save
      flash[:notice] = 'Account was successfully created.'
      set_current_account(Account.authenticate(params[:account][:nick], params[:account][:password]))
      redirect url(:user, :show, nick: params[:account][:nick])
    else
      render 'user/new'
    end
  end

  get :show, with: :nick do
    if @account = Account.first(nick: params[:nick])
      render 'user/show', locals: { is_the_same: (@account == current_account) }
    else
      render :haml, '%p Account doesn\'t exist.'
    end
  end

  get :me do
    logged_in? ? redirect(url(:user, :show, nick: current_account.nick)) : not_found
  end

  post :update do
    @account = Account.find_by_id(params[:id])
    redirect url(:index) unless @account
    redirect url(:user, :show, nick: @account.nick) if @account != current_account

    if @account.update(params[:account])
      @account.save
      redirect url(:user, :show, nick: @account.nick)
    else
      render 'user/show'
    end
  end

  post :upload do
    begin
      raise 'You\'re not logged in' unless logged_in?

      if params[:skin]
        begin
          h = ChunkyPNG::Image.from_file(params[:skin][:tempfile])
        rescue ChunkyPNG::SignatureMismatch
          raise 'Not a PNG skin'
        end

        raise 'Incorrect image size' if h.width != 64 or h.height != 32

        file = File.join('public', 'images', 'skin', "#{current_account.nick}.png")
        File.open(file, 'wb') {|f|
          f.write(params[:skin][:tempfile].read)
        }

        redirect url(:user, :show, nick: current_account.nick)
      else
        raise 'Skin not given'
      end
    rescue Exception => e
      @skin = Struct.new(:errors).new({skin: e.message})
      @account = current_account

      render 'user/show', locals: { is_the_same: true }
    end
  end

  get :delete do
    redirect url(:index) unless logged_in?
    file = File.join('public', 'images', 'skin', "#{current_account.nick}.png")

    File.unlink(file) if File.exists?(file)

    redirect url(:user, :show, nick: current_account.nick)
  end

  get :destroy do
    current_account.destroy
    set_current_account(nil)
    redirect url(:index)
  end
end
