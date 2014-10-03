require 'lib/people'
require 'lib/play'

class GameController < ApplicationController
  include GameHelper

  before_filter do |c|
    params[:action] == 'leaderboard' ? true : c.send(:authorize, root_path)
  end

  def autocomplete
    people = People.all

    pattern = params[:term].split.join('.*').downcase
    render json: people.map(&:name).select { |name| name.downcase =~ /.*#{pattern}.*/ }
  end

  def check
    if get_rounds < $globals.game.rounds
      set_result session[:name], params[:guess]
    end

    session[:state] = 'flipped'

    render json: {
        state: session[:state],
        score: session[:score] || 0,
        hit: session[:hit],
        name: session[:name],
        email: session[:email],
        image: session[:image],
        guess: session[:guess],
        remaining: $globals.game.rounds - (session[:rounds] || 0)
    }
  end

  def next
    if get_rounds < $globals.game.rounds
      if session[:state] == 'waiting' # This is a skip
        increase_round
      end

      set_current_round(People.all.sample)

      render json: {
          state: session[:state],
          score: session[:score] || 0,
          hit: session[:hit],
          image: session[:image],
          guess: session[:guess],
          remaining: $globals.game.rounds - (session[:rounds] || 0)
      }
    else
      # Run out of rounds to play.
      render json: {
          state: 'over',
          score: session[:score] || 0,
          hit: session[:hit],
          name: session[:name],
          email: session[:email],
          image: session[:image],
          guess: session[:guess],
          remaining: 0
      }
    end
  end

  def finish
    Play.finish(current_user, get_score)
    redirect_to game_leaderboard_path
  end

  def state
    render json: {
        state: session[:state],
        score: session[:score] || 0,
        hit: session[:hit],
        name: session[:name],
        image: session[:image],
        email: session[:email],
        guess: session[:guess],
        remaining: $globals.game.rounds - (session[:rounds] || 0)
    }
  end

  def leaderboard
    @leaderboard = Play.leaderboard
  end
end
