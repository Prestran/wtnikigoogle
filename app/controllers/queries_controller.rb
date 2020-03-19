class QueriesController < ApplicationController
  before_action :find_query, only: [:edit, :destroy, :show, :create]
  skip_before_action :verify_authenticity_token

  def index
    @queries = []
    unless current_user.nil?
      @queries = current_user.queries
    end
  end

  def new; end

  def show; end

  def create
    respond_to do |format|
      if !params[:searched].nil? && @query.build_query(params[:searched])
        format.json { render json: { message: 'Query created!', redirect_path: query_path(@query) }, status: :ok }
      else
        format.json { render json:  @query.errors.messages, status: :unprocessable_entity }
      end
    end
  end

  def edit

  end

  def destroy
    respond_to do |format|
      if @query.destroy!
        format.json { render json: { message: 'Query deleted!', redirect_path: queries_path }, status: :ok }
      else
        format.json { render json: { message: 'Something went wrong' }, status: :unprocessable_entity }
      end
    end
  end

  private

  def query_params

  end

  def find_query
    @query = params[:id].present? ? Query.includes(:query_results).find(params[:id]) : current_user.queries.new
  end
end
