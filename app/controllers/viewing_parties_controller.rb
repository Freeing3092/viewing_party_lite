# frozen_string_literal: true

class ViewingPartiesController < ApplicationController
  before_action :find_user

  def new
    # require 'pry'; binding.pry
    if session[:user_id] != params[:user_id].to_i
      redirect_to user_movie_path(params[:user_id], params[:movie_id])
      flash[:alert] = "You must be logged in or registered to create a viewing party"
    elsif session[:user_id] == params[:user_id].to_i
      @movie = MoviesFacade.get_movie_heavy(params[:movie_id])
      @users = User.find_all_except(@user)
    end
  end

  def create
    party = MovieParty.new(viewing_party_params)
    if party.save
      party.create_user_movie_parties(@user, params[:invitees])
      redirect_to user_path(@user)
    else
      flash[:alert] = 'Error: Datetime field cannot be left blank'
      redirect_to new_user_movie_viewing_party_path(@user, party.movie_id)
    end
  end

  private

  def viewing_party_params
    params.permit(:movie_id, :movie_title, :duration, :start_time)
  end

  def find_user
    @user = User.find(params[:user_id])
  end
end
