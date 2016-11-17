module ApplicationHelper

  def flash_messages
    messages = ""
    [:notice, :info, :warning, :error].each do |type|
      if flash[type]
        messages = "<div id=\"flash-#{ type }\">#{ flash[type] }</div>"
      end
    end
    messages
  end

  def background_image
    no_section = Section.find_by_slug('none')
    background = Background.where(:section_id => no_section.id).first # Default Background is set to the 'no-section' background first.
    bg_image_url = asset_path "background_seagull_on_misty_lake.jpg" # Default image for when no Background can be found
    if controller.controller_name == 'backgrounds' && controller.action_name == 'show' # Previewing a background image in the CMS.
      background = Background.find(params[:id])
    elsif controller.controller_name == 'pages' && controller.action_name == 'homepage'
      homepage_section = Section.find_by_slug('homepage') # Homepage background (homepage isn't a real section, so need to check for it explicitly).
      background = Background.where(:section_id => homepage_section.id).first
    else
      background = Background.where(:section_id => @section.id).first unless @section.blank?
    end
    bg_image_url = background.image unless background.blank?

    "background: transparent url('#{ bg_image_url }') center 0 no-repeat;"
  end

end
