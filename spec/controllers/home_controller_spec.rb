require 'rails_helper'

RSpec.describe HomeController, type: :controller do

  describe "GET #index" do
    context 'when the user is not authenticated' do
      it "redirects the user to the login page" do
        get :index
        expect(response).to have_http_status(:found)
      end
    end

  end

  # context 'when the user is authenticated' do
  #   'Authenticate user...'
  #   it "returns http success" do
  #     get :index
  #     expect(response).to have_http_status(:success)
  #   end
  # end
end
