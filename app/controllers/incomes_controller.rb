class IncomesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_income, only: %i[show edit update destroy]
  before_action :authorize_income

  def index
    @incomes = policy_scope(Income).order(received_at: :desc)
  end

  def show; end

  def new
    @income = Income.new(received_at: Time.zone.today)
  end

  def create
    @income = Income.new(income_params)
    @income.tenant = ActsAsTenant.current_tenant

    if @income.save
      redirect_to @income, notice: "Ingreso registrado correctamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @income.update(income_params)
      redirect_to @income, notice: "Ingreso actualizado correctamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @income.destroy
    redirect_to incomes_path, notice: "Ingreso eliminado correctamente."
  end

  private

  def set_income
    @income = Income.find(params[:id])
  end

  def authorize_income
    authorize :income, :index?
  end

  def income_params
    params.require(:income).permit(:title, :description, :amount, :currency, :income_type, :received_at, :tag)
  end
end