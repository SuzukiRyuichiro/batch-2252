class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :demo_message]

  def home
  end

  def demo_message
    @text = params[:text]
  end
end
