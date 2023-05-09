class Lesson < ApplicationRecord
  belongs_to :course, counter_cache: true
  #Course.find_each { |course| Course.reset_counters(course.id, :lessons) }

  has_many :user_lessons

  validates :title, :content, :course, presence: true

  #
  extend FriendlyId
  friendly_id :title, use: :slugged


  #
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }

  def to_s
    title
  end

  #text
  has_rich_text :content

  #
  def viewed(user)
    self.user_lessons.where(user: user).present?
    #self.user_lessons.where(user_id: [user.id], lesson_id: [self.id]).empty?
  end

end
