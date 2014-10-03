require 'spec_helper'

describe SiteController, :type => :controller do
  describe '#home' do
    it 'should render.' do
      get :home
      expect(response).to be_success
    end
  end
end
