require "integration_test_helper"
require "gds_api/test_helpers/account_api"

class SessionsTest < ActionDispatch::IntegrationTest
  include GdsApi::TestHelpers::AccountApi

  context "when logged in" do
    should "redirect the user to the account manager URL if they visit /sign-in" do
      get "/sign-in", headers: { "GOVUK-Account-Session" => "placeholder" }
      assert_redirected_to Plek.find("account-manager")
    end
  end

  context "when logged out" do
    should "prefer the redirect_path over the HTTP Referer" do
      stub = stub_account_api_get_sign_in_url(redirect_path: "/from-param")

      get "/sign-in", headers: { "Referer" => "#{Plek.new.website_root}/from-referer" }, params: { redirect_path: "/from-param" }

      assert_response :redirect
      assert_requested stub
    end

    should "add a redirect_path param to /sign-in from the HTTP Referer header" do
      stub = stub_account_api_get_sign_in_url(redirect_path: "/from-referer")

      get "/sign-in", headers: { "Referer" => "#{Plek.new.website_root}/from-referer" }

      assert_response :redirect
      assert_requested stub
    end

    should "preserve a redirect_path params stored in the HTTP Referer header" do
      stub = stub_account_api_get_sign_in_url(redirect_path: "/from-referer?foo=bar")

      get "/sign-in", headers: { "Referer" => "#{Plek.new.website_root}/from-referer?foo=bar" }

      assert_response :redirect
      assert_requested stub
    end

    should "not add an invalid path as the redirect param" do
      stub_account_api_get_sign_in_url
      stub_evil = stub_account_api_get_sign_in_url(redirect_path: "/from-referer")

      get "/sign-in", headers: { "Referer" => "//evil/from-referer" }

      assert_response :redirect
      assert_not_requested stub_evil
    end
  end
end
