class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  # protect_from_forgery 更新這邊不用加
  after_action :user_activity, if: :user_signed_in?
  
  #
  include PublicActivity::StoreController 

  before_action :set_global_variables, if: :user_signed_in?
  def set_global_variables
    @ransack_courses = Course.ransack(params[:courses_search], search_key: :courses_search) #navbar search
  end
  
  #
  include Pundit::Authorization
  # protect_from_forgery
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  #
  include Pagy::Backend

  

  private
  def user_activity
    current_user.try :touch
  end

  def user_not_authorized #pundit
    flash[:alert] = "You are not authorized to perform this action."
    # redirect_back(fallback_location: root_path)
    redirect_to(request.referrer || root_path)
  end
  
end
