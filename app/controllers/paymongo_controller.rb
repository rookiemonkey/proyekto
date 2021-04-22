class PaymongoController < ApplicationController
  def create
    render json: Paymongo.new_payment_intent(chosen_plan)
  end

  private

  def chosen_plan
    params[:plan].to_sym
  end
end
