class UsersController < ApplicationController

  before_action :authenticate_user!, :except => [:index, :show]

  # list all users - GET /users
  def index
    @users = User.all
  end

  #show a single user - GET /users/:id
  def show
    if user_signed_in?
      @user = User.find(params[:id])
    else
      redirect_to new_user_session_path
    end
  end

  #new user creation form - GET /users/new
  def new
    new_user_registration_path
  end

  #create a new user - POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to @user
    else
      render :new
    end
  end

  #edit user form - GET /users/:id/edit
  def edit
    @user = User.find(params[:id])
  end

  #update an existing user - PUT /users/:id
  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to @user
    else
      render :edit
    end
  end

  #destroy an existing user - DELETE /users/:id
  def destroy
    @user = User.find(params[:id])

    if @user.destroy
      redirect_to @user
    else
      render :destroy
    end

  end

  private
  def user_params
    params.require(:user).permit(:name, :email)
  end

end
