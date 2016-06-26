module EmojiHelper
  def emojify(content)
    if emoji = Emoji.find_by_alias(content)
      %(<img alt="#{content}" src="#{image_path("emoji/#{emoji.image_filename}")}" style="vertical-align:middle" width="40" height="40" />).html_safe
    end if content.present?
  end
end
