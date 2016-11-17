class BlogPostsController < ApplicationController
  before_filter :require_admin, :except => [:index, :show, :category]
  #uses_tiny_mce :only => [:new, :create, :edit, :update]

  def index
    if current_user and current_user.is_admin?
      @blog_posts = BlogPost.order("created_at desc").page(params[:page])
    else
      @blog_posts = BlogPost.order("created_at desc").where(:is_draft => false).page(params[:page])
    end
    @page = Page.where({ :slug => "blog" }).first
    @section = Section.find_by_name("Blog")
    @featured_product = Feature.where(:is_active => true).first
  end

  def show
    if params[:slug].blank?
      @blog_post = BlogPost.find(params[:id])
    else
      @blog_post = BlogPost.where({ :slug => params[:slug] }).first
    end
    if @blog_post and @blog_post.is_draft and !current_user
      redirect_to root_url, :flash => { :warning => "The blog post you are looking for is currently unavailable." }
    end
    @section = Section.find_by_name("Blog")
    @featured_product = Feature.where(:is_active => true).first
  end

  def category
    @blog_category = BlogCategory.where(:slug => params[:slug]).first
    if current_user and current_user.is_admin?
      @blog_posts = BlogPost.order("created_at desc").where(:blog_category_id => @blog_category.id).page(params[:page])
    else
      @blog_posts = BlogPost.where(:blog_category_id => @blog_category.id, :is_draft => false).page(params[:page]).order("created_at desc")
    end
    @blog_posts.to_json
    @section = Section.find_by_name("Blog")
    @featured_product = Feature.where(:is_active => true).first
  end

  def new
    @blog_post = BlogPost.new
  end

  def edit
    @blog_post = BlogPost.find(params[:id])
  end

  def create
    @blog_post = BlogPost.new(blog_post_params)

    if @blog_post.save
      redirect_to(blog_post_show_path(:slug => @blog_post.slug), :notice => "Blog post was successfully created.")
    else
      render :action => "new"
    end
  end

  def update
    @blog_post = BlogPost.find(params[:id])

    if @blog_post.update(blog_post_params)
      redirect_to(blog_post_show_path(:slug => @blog_post.slug), :notice => "Blog post was successfully updated.")
    else
      render :action => "edit"
    end
  end

  def destroy
    @blog_post = BlogPost.find(params[:id])
    @blog_post.destroy

    redirect_to(blog_posts_path, :notice => "Successfully destroyed blog post.")
  end

  private

  def undo_link
    view_context.link_to("Undo", revert_version_path(@blog_post.versions.scoped.last), :method => :post)
  end

  def blog_post_params
    params.require(:blog_post).permit(:name, :body, :keywords, :description,
      :blog_category_id, :is_draft, :created_at)
  end

end
