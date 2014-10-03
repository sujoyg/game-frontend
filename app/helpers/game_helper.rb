module GameHelper
  def get_score
    session[:score] ||= 0
  end

  def get_rounds
    session[:rounds] ||= 0
  end

  def set_current_round(person)
    session[:person_id] = person.id
    session[:name] = person.name
    session[:email] = person.email
    session[:image] = person.image
    session[:state] = 'waiting'
  end

  def reset_game
    session.delete :score
    session.delete :hit
    session.delete :rounds
    session.delete :name
    session.delete :guess
    session.delete :email
    session.delete :hit
    session.delete :image
    session.delete :person_id
    session.delete :state
  end

  def set_result(name, guess)
    hit = name.downcase == guess.downcase
    increase_score if hit
    increase_round

    session[:guess] = guess
    session[:hit] = hit
  end

  def increase_score
    session[:score] ||= 0
    session[:score] = session[:score] + 1
  end

  def increase_round
    session[:rounds] ||= 0
    session[:rounds] = session[:rounds] + 1
  end
end
