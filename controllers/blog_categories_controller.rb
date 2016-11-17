class BlogCategoriesController < ApplicationController
  before_filter :require_admin

  def index
    @blog_categories = BlogCategory.all
  end

  def show
    @blog_category = BlogCategory.find(params[:id])
  end

  def sort
    blog_category = BlogCategory.find(params[:id])
    blog_category.insert_at(params[:new_position])
    render :nothing => true
  end

  def new
    @blog_category = BlogCategory.new
  end

  def edit
    @blog_category = BlogCategory.find(params[:id])
  end

  def create
    @blog_category = BlogCategory.new(blog_category_params)
    last_category = BlogCategory.order(:position).last
    @blog_category.position = last_category.position + 1

    if @blog_category.save
      redirect_to(blog_categories_path, :notice => 'Blog category was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @blog_category = BlogCategory.find(params[:id])

    if @blog_category.update(blog_category_params)
      redirect_to(blog_categories_path, :notice => 'Blog category was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @blog_category = BlogCategory.find(params[:id])
    @blog_category.destroy

    redirect_to(blog_categories_path)
  end

  private

  def blog_category_params
    params.require(:blog_category).permit(:name, :description, :position)
  end
end
