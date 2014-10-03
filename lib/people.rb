require 'lib/api'

class People
  @@people = nil

  def self.people
    if !@@people
      @@people = {}
      JSON.parse(API.get 'users').each do |record|
        record['id'] = record['id'].to_s
        @@people[record['id']] = OpenStruct.new record
      end
    end

    @@people
  end

  def self.all
    people.values
  end

  def self.find(id)
    people[id.to_s]
  end
end