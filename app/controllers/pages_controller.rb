class PagesController < ApplicationController

  skip_before_filter :authenticate_user!

  # def account_redirect
  #   if current_user
  #     redirect_to 
  #   end
  # end

  def landing
    render layout: "landing"
  end

  def privacy
  end

  def terms
  end
end
