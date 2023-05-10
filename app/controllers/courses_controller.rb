class CoursesController < ApplicationController
  before_action :set_course, only: %i[ show edit update destroy ]

  # GET /courses or /courses.json
  def index
    # @courses = Course.all
    # if params[:title]
    #   @courses = Course.where('title ILIKE ?', "%#{params[:title]}%") #case-insensitive
    # else
    #   #@courses = Course.all

    #   #@q = Course.ransack(params[:q])
    #   # @courses = @q.result(distinct: true)
    #   #@courses = @q.result.includes(:user)
    # end
    
    @ransack_path = courses_path
    @ransack_courses = Course.ransack(params[:courses_search], search_key:  :courses_search)
    #@courses = @ransack_courses.result.includes(:user)
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user))
  end

  def purchased
    @ransack_path = purchased_courses_path

    @ransack_courses = Course.joins(:enrollments).where(enrollments: {user: current_user}).ransack(params[:courses_search], search_key: :courses_search)

    @pagy, @courses = pagy(@ransack_courses.result.includes(:user))
    
    render 'index'
  end

  def pending_review
    @ransack_path = pending_review_courses_path

    @ransack_courses = Course.joins(:enrollments).merge(Enrollment.pending_review.where(user: current_user)).ransack(params[:courses_search], search_key: :courses_search)

    @pagy, @courses = pagy(@ransack_courses.result.includes(:user))
    
    render 'index'

  end

  def created
    @ransack_path = created_courses_path

    @ransack_courses = Course.where(user: current_user).ransack(params[:courses_search], search_key: :courses_search)
    
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user))

    render 'index'
  end

  # GET /courses/1 or /courses/1.json
  def show
    @lessons = @course.lessons
    @enrollments_with_review = @course.enrollments.reviewed
  end

  # GET /courses/new
  def new
    @course = Course.new
    authorize @course
  end

  # GET /courses/1/edit
  def edit
    # authorize @course
  end

  # POST /courses or /courses.json
  def create
    @course = Course.new(course_params)
    authorize @course  #順序有差
    @course.user = current_user

    respond_to do |format|
      if @course.save
        format.html { redirect_to course_url(@course), notice: "Course was successfully created." }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1 or /courses/1.json
  def update
    authorize @course

    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to course_url(@course), notice: "Course was successfully updated." }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1 or /courses/1.json
  def destroy
    authorize @course

    @course.destroy

    respond_to do |format|
      format.html { redirect_to courses_url, notice: "Course was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.friendly.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def course_params
      params.require(:course).permit(:title, :description, :short_description, :price, :level, :language)
    end
end
