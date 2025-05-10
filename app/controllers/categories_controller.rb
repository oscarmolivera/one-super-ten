class CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  before_action :set_school, only: [:new, :edit, :update]

  def index
    authorize :category, :index?
    @categories = policy_scope(Category)
  end

  def show
    authorize :category, :index?
  end

  def new
    authorize :category, :index?
    @category = Category.new
  end

  def create
    authorize :category, :index?
    @category = Category.new(category_params)
    if @category.save
      redirect_to categories_path, notice: "Category created successfully."
    else
      render :new
    end
  end

  def edit
    authorize :category, :index?
  end

  def update
    authorize :category, :index?
    if @category.update(category_params)
      redirect_to categories_path, notice: "Category updated successfully."
    else
      render :edit
    end
  end

def destroy
  authorize :category, :destroy?
  if @category.destroy
    respond_to do |format|
      format.html { redirect_to categories_path, notice: "Category deleted." }
      format.turbo_stream
    end
  else
    respond_to do |format|
      format.html { redirect_to categories_path, alert: "Failed to delete category: #{@category.errors.full_messages.join(', ')}" }
      format.turbo_stream do
        render turbo_stream: turbo_stream.append("messages", partial: "shared/flash", locals: { alert: "Failed to delete category: #{@category.errors.full_messages.join(', ')}" })
      end
    end
  end
end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def set_school
    @schools = ActsAsTenant.current_tenant.schools
  end

  def category_params
    params.require(:category).permit(:name, :description, :school_id)
  end
end