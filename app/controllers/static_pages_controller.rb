class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:landing_pages]

  def landing_pages
    @courses = Course.all.limit(3)
    @latest_couses = Course.all.limit(3).order(created_at: :desc)
  end

  def privacy_policy
  end

end
