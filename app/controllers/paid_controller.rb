class PaidController < ApplicationController
  def paid
    ownership.mark_as_paid! if can_be_paid?
    redirect_to league
  end

  def unpaid
    ownership.mark_as_unpaid! if can_be_unpaid?
    redirect_to league
  end


  private

  def can_be_paid?
    !ownership.paid?
  end

  def can_be_unpaid?
    ownership.paid?
  end

  def ownership
    @ownership ||= Ownership.find(params[:id])
  end

  def league
    @league ||= League.find_by_token(params[:league_token])
  end
end
