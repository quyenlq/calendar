class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:show, :edit, :update]
  before_filter :correct_user,   only: [:show, :edit, :update]
  before_filter :admin_permission, only: [:new,:create]
  def new
  	@user=User.new
  end

  def show
  	@user= User.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Welcome to EasyURL, thanks for using our service"
      sign_in(@user)
      redirect_to root_path
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

  def signed_in_user
      redirect_to signin_url, notice: "Please sign in." unless signed_in?
  end

  def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
  end

  def admin_permission
		redirect_to root_url unless admin?
  end
	
end

