class TermsController < ApplicationController
  skip_before_filter :authenticate_user!, only: [:index, :show]
  fine_print_skip_signatures :general_terms_of_use, :privacy_policy

  before_filter :get_contract, only: [:show]

  def show
    # Hide old agreements (should never get them)
    raise ActiveRecord::RecordNotFound if !@contract.is_latest? && !current_user.is_administrator?
  end

  def pose
    @contract = FinePrint.get_contract(params['terms'].first)
  end

  def agree
    signature = FinePrint.sign_contract(current_user, params[:contract_id]) if params[:i_agree]

    if signature && signature.errors.none? 
      fine_print_return
    else
      debugger
      @contract = FinePrint.get_contract(params[:contract_id])
      flash.now[:alert] = 'There was an error when trying to agree to these terms.'
      render 'pose'
    end
  end

  protected

  def get_contract
    @contract = FinePrint.get_contract(params[:id])
  end
end
