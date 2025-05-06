class MatchReportsController < ApplicationController
  before_action :set_match
  before_action :set_match_report, only: %i[show edit update destroy]
  before_action :authorize_user

  def index
    @match_reports = policy_scope(MatchReport).includes(:match)
  end

  def show; end

  def new
    @match_report = @match.match_reports.new(user: current_user, reported_at: Time.zone.now)
  end

  def edit; end

  def create
    @match_report = @match.match_reports.new(match_report_params)
    @match_report.user = current_user
    @match_report.tenant = ActsAsTenant.current_tenant

    if @match_report.save
      redirect_to match_match_report_path(@match, @match_report), notice: 'Match report was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @match_report.update(match_report_params)
      redirect_to match_match_report_path(@match, @match_report), notice: 'Match report was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @match_report.destroy
    redirect_to match_match_reports_path(@match), notice: 'Match report was deleted.'
  end

  private

  def set_match
    @match = Match.find(params[:match_id])
  end

  def set_match_report
    @match_report = @match.match_reports.find(params[:id])
  end

  def match_report_params
    params.require(:match_report).permit(
      :author_role, :general_observations, :incidents,
      :team_claims, :final_notes, :reported_at, attachments: []
    )
  end

  def authorize_user
    authorize :match_report, :index?
  end
end