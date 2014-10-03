require 'lib/api'

class Play
  def self.finish(user, score)
    API.post 'game', {email: user.email, score: score}
  end

  def self.leaderboard
    records = JSON.parse API.get "/bestGames?n=50"
    records.
        select { |record| User.exists?(email: record['email']) }.
        map do |record|
      OpenStruct.new(user: User.where(email: record['email']).first,
                     score: record['score'])
    end
  end
end
