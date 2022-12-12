# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def new; end

  def create
    user = User.create(user_params)
    if user.save
      redirect_to "/users/#{user.id}"
    else
      redirect_to '/register'
      flash[:alert] = user.errors.full_messages
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def login_user
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      redirect_to user_path(user)
    else
      redirect_to '/login'
      flash[:alert] = 'Invalid email/password'
    end
  end

  private

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end
end
