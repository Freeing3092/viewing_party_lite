# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def new; end

  def create
    user = User.create(user_params)
    if user.save
      session[:user_id] = user.id
      redirect_to "/users/#{user.id}"
    else
      redirect_to '/register'
      flash[:alert] = user.errors.full_messages
    end
  end

  def show
    if session[:user_id] != params[:id].to_i
      redirect_to '/'
      flash[:alert] = 'You must be logged in or registered to access your dashboard'
    elsif session[:user_id] == params[:id].to_i
      @user = User.find(params[:id])
    end
  end

  def login_user
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.name}!"
      redirect_to user_path(user)
    else
      redirect_to '/login'
      flash[:alert] = 'Invalid email/password'
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to '/'
  end

  private

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end
end
