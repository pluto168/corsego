class Course < ApplicationRecord
  validates :title, :description, :short_description, :language, :price, :level,  presence: true
  validates :description, length: { :minimum => 5 }
  validates :short_description, length: { :maximum => 300 }

  validates :title, uniqueness: true
  
  belongs_to :user, counter_cache: true
  #User.find_each { |user| User.reset_counters(user.id, :courses) }  
  
  #course刪除lessons也會被刪除
  has_many :lessons, dependent: :destroy    
  
  has_many :enrollments, dependent: :restrict_with_error

  has_many :user_lessons, through: :lessons
  
  #
  scope :latest, -> { limit(3).order(created_at: :desc) }
  scope :top_rated, -> { limit(3).order(average_rating: :desc, created_at: :desc) }
  scope :popular, -> { limit(3).order(enrollments_count: :desc, created_at: :desc) }

  scope :published, -> { where(published: true) }
  scope :unpublished, -> { where(published: false) }
  scope :approved, -> { where(approved: true) }
  scope :unapproved, -> { where(approved: false) }

  #
  def to_s
    title
  end

  #text
  has_rich_text :description

  #
  extend FriendlyId
  friendly_id :title, use: :slugged

  # friendly_id :generated_slug, use:slugged
  # def generated_slug
  #   require `securerandom`
  #   @random_slug ||= persisted? ?friendly_id :SecureRandom.hex(4)
  # end

  # def to_s
  #   slug
  # end

  #
  LANGUAGES = [:"English", :"Russian", :"Polish", :"Spanish", :"Chinese"]
  def self.languages
    LANGUAGES.map { |language| [language, language] }
  end

  # LEVELS = [:"Beginner", :"Intermediate", :"Advanced"]
  LEVELS = [:"All levels", :"Beginner", :"Intermediate", :"Advanced"]
  def self.levels
    LEVELS.map { |level| [level, level] }
  end

  #public_activity
  include PublicActivity::Model
  # tracked
  tracked owner: Proc.new{ |controller, model| controller.current_user }

  #
  def bought(user)
    self.enrollments.where(user_id: [user.id], course_id: [self.id]).any?
  end

  #average_rating
  def update_rating
    if enrollments.any? && enrollments.where.not(rating: nil).any?
      update_column :average_rating, (enrollments.average(:rating).round(2).to_f)
    else
      update_column :average_rating, (0)
    end
  end

  def progress(user)
    unless self.lessons_count == 0
      user_lessons.where(user: user).count/self.lessons_count.to_f*100
    end
  end

end
