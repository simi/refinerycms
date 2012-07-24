require 'spec_helper'

module Refinery
  describe 'layout' do
    refinery_login_with :refinery_user

    let(:home_page) { Page.create :title => 'Home', :link_url => '/' }

    describe 'body' do
      it "id is the page's canonical id" do
        visit home_page.url

        page.should have_css 'body#home-page'
      end
    end
  end
end
