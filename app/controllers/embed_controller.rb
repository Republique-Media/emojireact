class EmbedController < ApplicationController

  after_action :allow_iframe

  def index
    begin
      @page = Page.includes(:reactions).find_or_initialize_by(url: params[:url])

      if @page
        # single emojis
        if params[:emoji]
          @emoji = Emoji.find_by_alias(params[:emoji])
          begin
            @reactions = @page.reactions.where(ip_address: (request.headers["HTTP_CF_CONNECTING_IP"] || request.ip), emoji: @emoji.name)

            if params[:vote] == "add"
              unless @reactions.present?
                @page.reactions.create emoji: @emoji.name, ip_address: (request.headers["HTTP_CF_CONNECTING_IP"] || request.ip), referrer: request.referrer
              end

              redirect_back(fallback_location: embed_path(url: @page.url, emoji: @emoji.name)) and return
            elsif params[:vote] == "remove"
              @page.reactions.where(emoji: @emoji.name, ip_address: (request.headers["HTTP_CF_CONNECTING_IP"] || request.ip)).first.try(:destroy)
              redirect_back(fallback_location: embed_path(url: @page.url, emoji: @emoji.name)) and return
            end
          rescue # if an emoji doesn't exist
            render nothing: true
          end
        else

          # expires_in(7.days, public: true)

          fresh_when(last_modified: @page.updated_at, public: true)

        end



        render layout: "iframe"
      else
        render nothing: true
      end
    rescue ActiveRecord::StatementInvalid
      render nothing: true
    end
  end

  private

  def allow_iframe
    response.headers.except! "X-Frame-Options"
  end

end
