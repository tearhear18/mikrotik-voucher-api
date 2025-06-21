# spec/requests/vouchers_spec.rb
require 'rails_helper'

RSpec.describe "Events", type: :request do
  let(:login_params) {
    {
      code: "AB-312345",
      mac: "MAC-DUMMY",
      mode: "login"
    }
  }

  describe "POST /create" do
    context "with valid parameters" do
      subject { post events_url, params: { event: login_params } }

      it "creates a new Events" do
        expect(subject).to be_truthy
        expect(response.status).to eq(201)
        expect(Event.last.mode).to eq("login")
      end
    end
  end
end
