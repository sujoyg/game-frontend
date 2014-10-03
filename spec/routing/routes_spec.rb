require 'spec_helper'

describe 'routes', :type => :routing do
  it 'routes GET /' do
    expect(root_path).to eq '/'
    expect({ get: '/' }).to route_to controller: 'site', action: 'home'
  end
end
