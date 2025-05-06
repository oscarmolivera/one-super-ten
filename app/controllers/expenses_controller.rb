class ExpensesController < ApplicationController
  before_action :set_expense, only: %i[show edit update destroy]
  before_action :authorize_expense, except: %i[index new create]
  after_action :verify_policy_scoped, only: :index

  def index
    @expenses = policy_scope(Expense).recent.includes(:author, :expensable)
  end

  def show; end

  def new
    @expense = current_tenant.expenses.new(author: current_user)
    authorize @expense
  end

  def create
    @expense = current_tenant.expenses.new(expense_params.merge(author: current_user))
    authorize @expense

    if @expense.save
      redirect_to @expense, notice: "Expense was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @expense.update(expense_params)
      redirect_to @expense, notice: "Expense was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @expense.destroy
    redirect_to expenses_path, notice: "Expense was successfully deleted."
  end

  private

  def set_expense
    @expense = Expense.find(params[:id])
  end

  def authorize_expense
    authorize :expense, :index?
  end

  def expense_params
    params.require(:expense).permit(
      :title, :description, :amount, :spent_on, :expense_type,
      :payment_method, :reference_code,
      :expensable_id, :expensable_type
    )
  end
end