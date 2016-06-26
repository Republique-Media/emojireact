class EmbedController < ApplicationController

  after_action :allow_iframe

  def index
    @page = Page.find_or_create_by(url: params[:url])
    @emoji = Emoji.find_by_alias(params[:emoji])

    if @page && @emoji && params[:vote] == "true"
      @page.reactions.create emoji: @emoji.name
    end

    render layout: false
  end

  private

  def allow_iframe
    response.headers.except! "X-Frame-Options"
  end

end
