class PagesController < ApplicationController
  before_filter :require_admin, :except => [:show, :homepage, :products, :contact]
  before_filter :set_cache_buster, :only => [:homepage]
  #uses_tiny_mce :only => [:new, :create, :edit, :update]

  def index
    @pages = Page.all
  end

  def show
    if params[:id]
      @section = Section.find_by_name("None")
      @page = Page.find(params[:id])
    elsif params[:section_slug] && params[:overview] && params[:overview] == true
      @section = Section.where(slug: params[:section_slug]).first
      @page = @section.page
    elsif params[:section_slug] && params[:page_slug]
      @section = Section.where(slug: params[:section_slug]).first
      @page = Page.where(slug: params[:page_slug], section_id: @section.id).first
    elsif params[:page_slug] && !params[:section_slug]
      @page = Page.where(slug: params[:page_slug]).first
    end
    @featured_product = Feature.where(:is_active => true).first()
  end

  def homepage
    @homepage_title = DynamicSetting.find_by_name("homepage_title").value
    @blog_posts = BlogPost.order("created_at desc").where(:is_draft => false).limit(3)
  end

  def products
  end

  def contact
    contact_page_id = DynamicSetting.find_by_name("contact_page_id").value.to_i
    @page = Page.find(contact_page_id)
    @feedback = Feedback.new
  end

  def sort
    page = Page.find(params[:id])
    page.insert_at(params[:new_position].to_i)

    render :nothing => true
  end

  def new
    @page = Page.new
    if params[:section_id]
      @section = Section.find(params[:section_id])
      @page.section_id = @section.id
    end
  end

  def edit
    @page = Page.find(params[:id])
  end

  def edit_homepage_title
    @homepage_title = DynamicSetting.find_by_name("homepage_title")
  end

  def create
    @page = Page.new(page_params)
    if Page.where(:section_id => @page.section_id).count > 0
      last_page_in_section = Page.where(:section_id => @page.section_id).order(:position).last
      @page.position = last_page_in_section.position + 1
    else
      @page.position = 1
    end

    if @page.save
      redirect_to(@page, :notice => "Page was successfully created. #{ undo_link }")
    else
      render :action => "new"
    end
  end

  def update
    @page = Page.find(params[:id])

    if @page.update(page_params)
      contact_page_id = DynamicSetting.find_by_name("contact_page_id").value.to_i
      if @page.id == contact_page_id
        redirect_to(contact_path, :notice => "Page was successfully updated. #{ undo_link }")
      else
        redirect_to(@page, :notice => "Page was successfully updated. #{ undo_link }")
      end
    else
      render :action => "edit"
    end
  end

  def update_homepage_title
    @homepage_title = DynamicSetting.find_by_name("homepage_title")
    @homepage_title.update_attributes(params[:dynamic_setting].permit(:value))
    redirect_to root_url, :notice => "Homepage title has been successfully updated."
  end

  def destroy
    @page = Page.find(params[:id])
    @page.destroy

    redirect_to root_url, :notice => "Successfully destroyed page. #{ undo_link }"
  end

  private

    def undo_link
      #view_context.link_to("Undo", revert_version_path(@page.versions.scoped.last), :method => :post)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def page_params
      params.require(:page).permit(:section_id, :name, :slug, :position, :hidden,
        :body, :sticky, :description, :keywords, :created_at, :intro, :product_ids => [])
    end
end
