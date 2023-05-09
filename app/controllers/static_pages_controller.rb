class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:landing_pages]

  def landing_pages
    # @courses = Course.all.limit(3)
    
    # @latest_good_reviews = Enrollment.reviewed.order(rating: :desc, created_at: :desc).limit(3)
    @latest_good_reviews = Enrollment.reviewed.latest_good_reviews

    # @latest_couses = Course.all.limit(3).order(created_at: :desc)
    @latest = Course.latest

    # @top_rated_courses = Course.order(average_rating: :desc, created_at: :desc).limit(3)
    @top_rated = Course.top_rated


    # @popular_courses = Course.order(enrollments_count: :desc, created_at: :desc).limit(3)
    @popular = Course.popular
    
    @purchased_courses = Course.joins(:enrollments).where(enrollments: {user: current_user}).order(created_at: :desc).limit(3)
  end

  def privacy_policy
  end

  def activity
    @activities = PublicActivity::Activity.all
  end
end
