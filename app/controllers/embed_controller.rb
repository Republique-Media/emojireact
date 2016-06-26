class EmbedController < ApplicationController

  def index
    @page = Page.find_or_create_by(url: params[:url])
  end

end
