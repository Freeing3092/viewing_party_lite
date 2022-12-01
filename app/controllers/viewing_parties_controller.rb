class ViewingPartiesController < ApplicationController
  def new
    @user = User.find(params[:user_id])
    @movie = MoviesFacade.get_movie_lite(params[:movie_id])

    # Move to User model method
    @users = User.all.where('id != ?', @user.id)
  end

  def create
    user = User.find(params[:user_id])

    party = MovieParty.create!(viewing_party_params)
    UserMovieParty.create!(user_id: user.id, movie_party_id: party.id, status: 0)

    params[:invitees].each do |invitee|
      UserMovieParty.create!(user_id: invitee, movie_party_id: party.id, status: 1)
    end
    
    redirect_to user_path(user)
  end

  private

  def viewing_party_params
    params.permit(:movie_id, :movie_title, :duration, :start_time)
  end
end