module ApplicationHelper

  def parse_emojis(emojis)
    if emojis.include?(",")
      emojis = emojis.gsub(":", "").gsub(" ", "")
    elsif emojis.include?("::")
      emojis = emojis.gsub("::", ",").gsub(":", "").gsub(" ", "")
    elsif emojis.include?(":")
      emojis = emojis.gsub(":", "").gsub(" ", "")
    else
      emojis
    end
  end

end
