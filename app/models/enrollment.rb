class Enrollment < ApplicationRecord
  belongs_to :course, counter_cache: true
  #Course.find_each{|course|Course.reset_counters(course.id, :enrollments)}
  belongs_to :user, counter_cache: true
  #User.find_each { |user| User.reset_counters(user.id, :enrollments) }

  validates :user, :course, presence: true


  #
  validates_presence_of :rating, if: :review?
  validates_presence_of :review, if: :rating?
  
  # validates :rating, presence: true, if: -> { review.present? }
  # validates :review, presence: true, if: -> { rating.present? }

  
  # 驗證rating跟review兩者不能同時為空
  # validate :rating_or_review_presence

  # def rating_or_review_presence
  #   if rating.blank? && review.blank?
  #     errors.add(:base, "Please provide a rating or a review")
  #   end
  # end

  #
  validates_uniqueness_of :user_id, scope: :course_id  
  #user cant be subscribed to the same course twice
  validates_uniqueness_of :course_id, scope: :user_id  
  #user cant be subscribed to the same course twice

  validate :cant_subscribe_to_own_course  
  #user can't create a subscription if course.user == current_user.id

  #
  scope :pending_review, -> { where(rating: [0, nil, ""], review: [0, nil, ""]) }

  #static_pages
  scope :reviewed, -> { where.not(review: [0, nil, ""]) }
  scope :latest_good_reviews, -> { order(rating: :desc, created_at: :desc).limit(3) }

  #
  extend FriendlyId
  friendly_id :to_s, use: :slugged

  #average_rating
  after_save do
    unless rating.nil? || rating.zero?
      course.update_rating
    end
  end

  after_destroy do
    course.update_rating
  end
  
  #
  def to_s
    user.to_s + " " + course.to_s
  end

  protected
  def cant_subscribe_to_own_course
    if self.new_record?
      if self.user_id.present?
        if self.user_id == course.user_id
          errors.add(:base, "You can not subscribe to your own course")
        end
      end
    end
  end

end
