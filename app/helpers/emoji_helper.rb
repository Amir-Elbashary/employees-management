module EmojiHelper
  def emojify(content, **options)
    Twemoji.parse(h(content), options).html_safe if content.present?
  end

  def react_emoji_size(type, emoji_icon)
    return '2.8em' if type == emoji_icon 
    '1.8em'
  end
end
