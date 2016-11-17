class BackgroundsController < ApplicationController
  before_filter :require_admin
  before_filter :get_all_sections

  def index
    @backgrounds = Background.order(:section_id)
  end

  def show
    @background = Background.find(params[:id])
  end

  def new
    @background = Background.new
  end

  def edit
    @background = Background.find(params[:id])
  end

  def create
    @background = Background.new(background_params)

    if @background.save
      redirect_to backgrounds_path
    else
      render :action => "new"
    end
  end

  def update
    @background = Background.find(params[:id])

    if @background.update(background_params)
      section_background = Background.where(['section_id = ? AND id != ?', @background.section_id, @background.id]).first
      unless section_background.blank?
        section_background.section_id = Section.find_by_slug('hidden').id
        section_background.save
      end
      redirect_to backgrounds_path
    else
      render :action => "edit"
    end
  end

  private

  def get_all_sections
    @all_sections = Array.new @sections
    @all_sections.push @homepage_section
    @all_sections.push @hidden_section
  end

  def background_params
    params.require(:background).permit(:section_id, :image, :image_file_name,
      :image_content_type, :image_file_size, :image_updated_at)
  end

end
