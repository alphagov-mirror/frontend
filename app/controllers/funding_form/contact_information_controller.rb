class FundingForm::ContactInformationController < ApplicationController
  def show
    render "funding_form/contact_information"
  end

  def submit
    # TODO: do something here then redirect to next step
    render "funding_form/contact_information"
  end
end
