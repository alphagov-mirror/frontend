# encoding: utf-8
require 'integration_test_helper'

class CompletedTransactionTest < ActionDispatch::IntegrationTest
  context "a completed transaction edition" do
    should "show no promotion when presentation toggle is not present" do
      artefact = artefact_for_slug "done/no-promotion"
      artefact = artefact.merge("format" => "completed_transaction")
      content_api_and_content_store_have_page("done/no-promotion", artefact)
      visit "/done/no-promotion"

      assert_equal 200, page.status_code
      within '.content-block' do
        assert page.has_no_selector?('#organ-donor-registration-promotion')
        assert page.has_no_selector?('#register-to-vote-promotion')
      end
    end

    should "show organ donor registration promotion and survey heading if chosen" do
      artefact = artefact_for_slug "/done/shows-organ-donation-registration-promotion"
      artefact = artefact.merge("format" => "completed_transaction",
        details: {
          presentation_toggles: {
            promotion_choice: {
              choice: 'organ_donor',
              url: '/organ-donor-registration-url'
            }
          }
        })
      content_api_and_content_store_have_page("done/shows-organ-donation-registration-promotion", artefact)

      visit "/done/shows-organ-donation-registration-promotion"

      assert_equal 200, page.status_code
      within '.content-block' do
        assert page.has_text?("If you needed an organ transplant would you have one? If so please help others.")
        assert page.has_link?("Join", href: "/organ-donor-registration-url")
        within 'h2.satisfaction-survey-heading' do
          assert page.has_text?("Satisfaction survey")
        end
      end
    end

    should "show register to vote promotion and survey heading if chosen" do
      artefact = artefact_for_slug "done/shows-register-to-vote-promotion"
      artefact = artefact.merge("format" => "completed_transaction",
        details: {
          presentation_toggles: {
            promotion_choice: {
              choice: 'register_to_vote',
              url: '/register-to-vote-url'
            }
          }
        })
      content_api_and_content_store_have_page("done/shows-register-to-vote-promotion", artefact)

      visit "/done/shows-register-to-vote-promotion"

      assert_equal 200, page.status_code
      within '.content-block' do
        assert page.has_text?("You must register to vote by 7 June if you want to take part in the EU referendum. You can register online and it only takes 5 minutes.")
        assert page.has_link?("Register", href: "/register-to-vote-url")
        within 'h2.satisfaction-survey-heading' do
          assert page.has_text?("Satisfaction survey")
        end
      end
    end

    should "show no promotion when choice is not organ donor or register to vote" do
      artefact = artefact_for_slug "done/unknown-promotion"
      artefact = artefact.merge("format" => "completed_transaction",
        details: {
          presentation_toggles: {
            promotion_choice: {
              choice: 'cheese_hats',
              url: '/get-free-cheese-hats-url'
            }
          }
        })
      content_api_and_content_store_have_page("done/unknown-promotion", artefact)

      visit "/done/unknown-promotion"

      assert_equal 200, page.status_code
      within '.content-block' do
        assert page.has_no_selector?('#organ-donor-registration-promotion')
        assert page.has_no_selector?('#register-to-vote-promotion')
        assert page.has_no_link?(href: '/get-free-cheese-hats-url')
      end
    end

    should "render a completed transaction edition in preview" do
      artefact = artefact_for_slug "done/no-promotion"
      artefact = artefact.merge("format" => "completed_transaction")
      content_api_and_content_store_have_unpublished_page("done/no-promotion", 5, artefact)

      visit "/done/no-promotion?edition=5"

      assert_equal 200, page.status_code

      within '#content' do
        within 'header' do
          assert page.has_content?("")
        end
      end # within #content

      assert_current_url "/done/no-promotion?edition=5"
    end
  end

  context "legacy transaction finished pages' special cases" do
    should "not show the satisfaction survey for transaction-finished" do
      artefact = artefact_for_slug("done/transaction-finished").merge("format" => "completed_transaction")
      content_api_and_content_store_have_page("done/transaction-finished", artefact)
      visit "/done/transaction-finished"

      assert_not page.has_css?("h2.satisfaction-survey-heading")
    end

    should "not show the satisfaction survey for driving-transaction-finished" do
      artefact = artefact_for_slug("done/driving-transaction-finished").merge("format" => "completed_transaction")
      content_api_and_content_store_have_page("done/driving-transaction-finished", artefact)
      visit "/done/driving-transaction-finished"

      assert_not page.has_css?("h2.satisfaction-survey-heading")
    end
  end
end