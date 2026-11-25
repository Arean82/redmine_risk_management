class RiskCategoriesController < ApplicationController
  before_action :find_project_by_project_id
  before_action :find_category, only: [:edit, :update, :destroy]
  before_action :authorize

  def new
    @category = @project.risk_categories.build
  end

  def create
    @category = @project.risk_categories.build
    @category.safe_attributes = params[:risk_category]
    if @category.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to project_settings_path(@project, tab: 'categories')
    else
      render action: 'new'
    end
  end

  def edit
  end

  def update
    @category.safe_attributes = params[:risk_category]
    if @category.save
      flash[:notice] = l(:notice_successful_update)
      redirect_to project_settings_path(@project, tab: 'categories')
    else
      render action: 'edit'
    end
  end

  def destroy
    @category.destroy
    flash[:notice] = l(:notice_successful_delete)
    redirect_to project_settings_path(@project, tab: 'categories')
  end

  private

  def find_category
    @category = @project.risk_categories.find(params[:id])
  end
end
