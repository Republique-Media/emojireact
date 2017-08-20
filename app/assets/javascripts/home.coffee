# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  wdtEmojiBundle.defaults.emojiSheets =
    'apple': 'https://d2ibghu3vsr5hn.cloudfront.net/wdt-emoji-bundle/sheet_apple_64_indexed_128.png'
    'google': 'https://d2ibghu3vsr5hn.cloudfront.net/wdt-emoji-bundle/sheet_google_64_indexed_128.png'
    'twitter': 'https://d2ibghu3vsr5hn.cloudfront.net/wdt-emoji-bundle/sheet_twitter_64_indexed_128.png'
    'emojione': 'https://d2ibghu3vsr5hn.cloudfront.net/wdt-emoji-bundle/sheet_emojione_64_indexed_128.png'
    'facebook': 'https://d2ibghu3vsr5hn.cloudfront.net/wdt-emoji-bundle/sheet_facebook_64_indexed_128.png'
    'messenger': 'https://d2ibghu3vsr5hn.cloudfront.net/wdt-emoji-bundle/sheet_messenger_64_indexed_128.png'
  wdtEmojiBundle.init '.wdt-emoji-bundle-enabled'
  wdtEmojiBundle.defaults.type = 'apple'

