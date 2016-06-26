class EmbedController < ApplicationController

  after_action :allow_iframe

  def index
    @page = Page.find_by(url: params[:url])
    unless @page
      @page = Page.create(url: params[:url])
    end

    @emoji = Emoji.find_by_alias(params[:emoji])

    if @page && @emoji
      @reactions_by_ip = @page.reactions.where(ip_address: request.ip)
      @reactions_by_ip_for_emoji = @page.reactions.where(ip_address: request.ip, emoji: @emoji.name)

      if params[:vote] == "add"
        @page.reactions.create emoji: @emoji.name, ip_address: request.ip, referrer: request.referrer
      elsif params[:vote] == "remove"
        @page.reactions.where(emoji: @emoji.name, ip_address: request.ip).first.try(:destroy)
      end
      render layout: false
    else
      render nothing: true
    end
  end

  private

  def allow_iframe
    response.headers.except! "X-Frame-Options"
  end

end
