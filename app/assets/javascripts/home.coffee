# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

do ->
  wdtEmojiBundle.defaults.emojiSheets =
    'apple': 'https://cdn.rawgit.com/needim/wdt-emoji-bundle/master/sheets/sheet_apple_64.png'
    'google': 'https://cdn.rawgit.com/needim/wdt-emoji-bundle/master/sheets/sheet_google_64.png'
    'twitter': 'https://cdn.rawgit.com/needim/wdt-emoji-bundle/master/sheets/sheet_twitter_64.png'
    'emojione': 'https://cdn.rawgit.com/needim/wdt-emoji-bundle/master/sheets/sheet_emojione_64.png'
  wdtEmojiBundle.init '.wdt-emoji-bundle-enabled'
  wdtEmojiBundle.defaults.type = 'apple'
