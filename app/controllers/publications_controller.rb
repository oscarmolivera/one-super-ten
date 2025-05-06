class PublicationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_publication, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized
  after_action :verify_policy_scoped, only: [:index]

  def index
    @publications = policy_scope(Publication).order(published_at: :desc)
    authorize Publication
  end

  def show
    authorize @publication
  end

  def new
    @publication = current_user.authored_publications.build
    authorize @publication
  end

  def create
    @publication = current_user.authored_publications.build(publication_params)
    @publication.tenant = ActsAsTenant.current_tenant
    authorize @publication

    if @publication.save
      redirect_to @publication, notice: "Publication was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @publication
  end

  def update
    authorize @publication

    if @publication.update(publication_params)
      redirect_to @publication, notice: "Publication was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @publication
    @publication.destroy
    redirect_to publications_path, notice: "Publication was successfully destroyed."
  end

  private

  def set_publication
    @publication = Publication.find(params[:id])
  end

  def publication_params
    params.require(:publication).permit(
      :title, :body, :visibility, :category_id, :pinned, :published_at, :expires_at
    )
  end
end