require 'spec_helper'

describe 'site/home', :type => :view do
  it 'should render a message.' do
    render
    expect(rendered).to match 'Hello, World.'
  end
end