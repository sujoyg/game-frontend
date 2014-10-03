require 'lib/people'

class UsersController < ApplicationController
  include GameHelper
  before_filter { |c| c.send :authorize, root_path }

  def home
    if get_rounds >= $globals.game.rounds
      Play.finish(current_user, get_score)
    end

    if session[:state]
      @person = People.find(session[:person_id])
    else
      @person = People.all.sample
      set_current_round(@person)
    end

    @score = get_score
    @rounds = $globals.game.rounds
    @remaining = $globals.game.rounds - get_rounds
  end

  def on_login
    reset_game
    redirect_to home_path
  end

  def on_logout
    redirect_to root_path
  end
end
