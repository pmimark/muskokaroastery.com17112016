class VersionsController < ApplicationController
  def revert
    @version = Version.find(params[:id])
    if @version.reify
      @version.reify.save!
    else
      @version.item.destroy
    end
    link_name = params[:redo] == "true" ? "Undo" : "Redo"
    link = view_context.link_to(link_name, revert_version_path(@version.next, :redo => !params[:redo]), :method => :post)
    redirect_to root_path, :notice => "Undid #{ @version.event }. #{ link }"
  end
end
