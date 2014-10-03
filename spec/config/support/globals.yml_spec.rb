require 'spec_helper'
require 'globals'

describe 'config/support/globals.yml' do
  let(:user) { random_text }
  let(:globals) do
    with_user(user) do
      configs = [:development, :production, :sandbox, :test].map do |e|
        [e, Globals.read('config/support/globals.yml', e)]
      end
      Hash[*configs.flatten]
    end
  end

  describe 'app' do
    [:development, :production, :sandbox, :test].each do |environment|
      it environment do
        expect(globals[environment].app).to eq $app
      end
    end
  end


  describe 'host' do
    it 'development' do
      expect(globals[:development].host).to eq 'localhost:3000'
    end

    it 'production' do
      expect(globals[:production].host).to eq "www.#{$app.parameterize}.com"
    end

    it 'sandbox' do
      expect(globals[:sandbox].host).to eq "sandbox-www.#{$app.parameterize}.com"
    end

    it 'test' do
      expect(globals[:test].host).to eq 'test.host'
    end
  end

  describe 'token' do
    [:development, :production, :sandbox, :test].each do |environment|
      it environment do
        expect(globals[environment].token).to eq '2def5bdfe89f8dda89d37fb95932483450cf995b20252fc60cbe82cf1e0688504a79c25bfcc52c123c9d37cc3b806753854b9b473e4f3ba8db415bbe40390fe6'
      end
    end
  end
end