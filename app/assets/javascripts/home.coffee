# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  wdtEmojiBundle.defaults.emojiType = 'emojione'
  wdtEmojiBundle.defaults.emojiSheets =
    'apple': 'https://cdnjs.cloudflare.com/ajax/libs/wdt-emoji-bundle/0.2.1/sheets/sheet_apple_64_indexed_128.png'
    'google': 'https://cdnjs.cloudflare.com/ajax/libs/wdt-emoji-bundle/0.2.1/sheets/sheet_google_64_indexed_128.png'
    'twitter': 'https://cdnjs.cloudflare.com/ajax/libs/wdt-emoji-bundle/0.2.1/sheets/sheet_twitter_64_indexed_128.png'
    'emojione': 'https://cdnjs.cloudflare.com/ajax/libs/wdt-emoji-bundle/0.2.1/sheets/sheet_emojione_64_indexed_128.png'
    'facebook': 'https://cdnjs.cloudflare.com/ajax/libs/wdt-emoji-bundle/0.2.1/sheets/sheet_facebook_64_indexed_128.png'
    'messenger': 'https://cdnjs.cloudflare.com/ajax/libs/wdt-emoji-bundle/0.2.1/sheets/sheet_messenger_64_indexed_128.png'
  wdtEmojiBundle.init '.wdt-emoji-bundle-enabled'

