class FundingForm::ProjectDetailsController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  include MandatoryFieldHelper

  def show
    render "funding_form/project_details"
  end

  def submit
    keys = %i[project_name total_amount_awarded start_date_year start_date_month start_date_day end_date_year end_date_month end_date_day]
    mandatory_text_fields = %i[project_name]
    keys.each do |key|
      session[key] = sanitize(params[key])
    end
    invalid_fields = validate_mandatory_text_fields(mandatory_text_fields, "project_details")
    invalid_fields << { text: t("funding_form.errors.invalid_money") } unless is_number?(session[:total_amount_awarded]) || session[:total_amount_awarded].blank?
    invalid_fields << validate_date_fields(session[:start_date_year], session[:start_date_month], session[:start_date_day], "Start day")
    invalid_fields << validate_date_fields(session[:end_date_year], session[:end_date_month], session[:end_date_day], "End day")
    invalid_fields = invalid_fields.flatten
    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      render "funding_form/project_details"
    else
      session[:total_amount_awarded] = session[:total_amount_awarded].gsub(",", "")
      unless params[:start_date_year].blank? && params[:start_date_month].blank? && params[:start_date_day].blank?
        session[:award_start_date] = DateTime.new(params[:start_date_year].to_i, params[:start_date_month].to_i, params[:start_date_day].to_i).strftime("%Y-%m-%d")
      end
      unless params[:end_date_year].blank? && params[:end_date_month].blank? && params[:end_date_day].blank?
        session[:award_end_date] = DateTime.new(params[:end_date_year].to_i, params[:end_date_month].to_i, params[:end_date_day].to_i).strftime("%Y-%m-%d")
      end
      unless params[:start_date_year].blank? && params[:start_date_month].blank? && params[:start_date_day].blank? || params[:end_date_year].blank? && params[:end_date_month].blank? && params[:end_date_day].blank?
        invalid_fields = validate_date_order(session[:award_start_date], session[:award_end_date])
      end
      if invalid_fields.any?
        flash.now[:validation] = invalid_fields
        render "funding_form/project_details"
      else
        redirect_to controller: session["check_answers_seen"] ? "funding_form/check_answers" : "funding_form/partners", action: "show"
      end
    end
  end

private

  def is_number?(string)
    string = string.gsub(",", "")
    true if Float(string) rescue false
  end
end