class CoursePolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def show?
    @record.published && @record.approved || 
    @user.present? && @user.has_role?(:admin) || 
    @user.present? && @record.user_id == @user.id || 
    @user.present? && @record.bought(@user)
  end

  def edit?
    # @user.has_role?:admin || @record.user = @user
    # @user.has_role?(:admin) || @record.user = @user
    # @user.has_role?(:admin) || @record.user_id == @user.id
    # @user.has_role?(:admin) || @record.user == @user
    @record.user == @user
  end

  def update?
    # @user.has_role?(:admin) || @record.user = @user
    # @user.has_role?(:admin) || @record.user_id == @user.id
    # @user.has_role?(:admin) || @record.user == @user
    @record.user == @user
  end

  def new?
    # @user.has_role?:teacher
    @user.has_role?(:teacher)
  end

  def create?
    # @user.has_role?:teacher
    @user.has_role?(:teacher)
  end

  def destroy?
    # @user.has_role?(:admin) || @record.user = @user
    # @user.has_role?(:admin) || @record.user_id == @user.id
    @user.has_role?(:admin) || @record.user == @user
  end

  def approve?
    @user.has_role?(:admin)
  end

  def owner?
    @record.user == @user      #只有user自己可以用
  end
end
