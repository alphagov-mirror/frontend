class HomepageController < ApplicationController
  before_action :set_expiry

  def index
    sleep(2) if params["gatling-cachebust"].present?

    set_slimmer_headers(
      template: "homepage",
      remove_search: true,
    )

    setup_content_item("/")

    render locals: { full_width: true }
  end
end
