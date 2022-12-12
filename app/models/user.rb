# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  validates_presence_of :name, on: :create
  validates_presence_of :email
  validates_uniqueness_of :email, on: :create

  has_many :user_movie_parties
  has_many :movie_parties, through: :user_movie_parties

  def self.find_all_except(user)
    all.where('id != ?', user.id)
  end
end
