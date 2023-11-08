class Api::V1::ReferralsController < ApplicationController

  def user_referrals
    @referrals = Referral.where(referrer_id: current_user.id)
    render json: {status: 200, referrals: @referral}
  end

  def create
    @referral = current_user.referrals.create(referral_params)
    if @referral.save
      # send referral email
      send_referral_email
      render json: {status: 200, message: "Referral email sent successfully.", referral: @referral}
    else
      render json: { errors: @referral.errors }
    end
  end

  private

  def referral_params
    params.require(:referral).permit(:email)
  end

  def send_referral_email
    ReferralMailer.with(referral: @referral).send_email.deliver_now
  end
end