require File.join UserAuthentication::Engine.config.root, 'app/models/user.rb'

class User < ActiveRecord::Base
  #validates_presence_of :name
end