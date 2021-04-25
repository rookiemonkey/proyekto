class PaymongoController < ApplicationController
  before_action :authenticate_user!

  def create
    render json: Paymongo.new_payment_intent(chosen_plan)
  end

  private

  def chosen_plan
    params[:plan].to_sym
  end
end
