module AuthThree
  module Generators
    module ControllerHelpers
      def users_controller_contents
<<RUBY
  def show
    @user = User.find(params[:id])
    render :show
  end

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      sign_in(@user)
      redirect_to links_url
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
    render :edit
  end

  def update
    @user = User.find(params[:id])
    if @user.update
      # default will redirect to root_url, change as you wish
      redirect_to root_url
    else
      flash.now[:errors] = @user.errors.full_messages
      render :edit
    end
  end
RUBY
      end

      def sessions_controller_contents
<<RUBY
  def new
    render :new
  end

  def create
    user = User.find_by_credentials(
      params[:user][:username],
      params[:user][:password]
    )

    if user
      login!(user)
      # requires root_url to be set in routes.rb
      redirect_to root_url
    else
      flash.now[:errors] = ["Invalid username or password"]
      render :new
    end
  end

  def destroy
    logout!
    redirect_to new_session_url
  end
RUBY
      end

      def namespace_sessions_contents(namespace_label)
<<RUBY
  def create
    @user = User.find_by_credentials(
      params[:user][:username],
      params[:user][:password]
    )

    if @user
      login!(@user)
      render :"#{namespace_label}/users/show"
    else
      render(json: ['Sorry, you entered an incorrect email address or password.'], status: 401)
    end
  end

  def destroy
    @user = current_user
      if @user
        logout!
        render json: @user
      else
        render(json: ["You are not signed in"], status: 404)
      end
  end
RUBY
      end

      def namespace_users_contents(namespace_label)
<<RUBY
  def create
    @user = User.new(user_params)
    if @user.save
      login!(@user)
      render :show
    else
      errors = @user.errors.full_messages
      render(json: errors, status: 422)
    end
  end

  def show
    @user = User.find(params[:id])
    render :show
  end

  def update
    @user = User.find(params[:user][:id])
    if @user.update(user_params)
      render :show
    else
      errors = @user.errors.full_messages
      render(json: errors, status: 422)
    end
  end
RUBY
      end

      def router_contents(namespace_label)
<<-RUBY

  namespace :#{namespace_label}, defaults: {format: :json} do
    resources :users
  end
  namespace :#{namespace_label}, defaults: {format: :json} do
    resource :session
  end
RUBY
      end

    end
  end
end
