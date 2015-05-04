request = require 'request'

{TextEditorView, View}  = require 'atom-space-pen-views'

FetchGhList = require './fetch-gh-list'

module.exports =
class FetchGhView extends View
  githubSearch = 'https://api.github.com/search/repositories?q='

  @content: ->
    @div class: 'fetch-gh', =>
      @subview 'miniEditor', new TextEditorView(mini: true)
      @div class: 'message', 'Enter the name of a project to search in GitHub'

  initialize: ->
    atom.commands.add @miniEditor.element, 'core:confirm', => @confirm()
    atom.commands.add @miniEditor.element, 'core:cancel', => @close()

  open: ->
    @panel = atom.workspace.addModalPanel(item: this, visible: true)
    @miniEditor.focus()

  close: ->
    @miniEditor.setText('')
    @destroy()

  # Tear down any state and detach
  destroy: ->
    @panel?.destroy()

  confirm: ->
    toSearch = @miniEditor.getText()
    urlApi = githubSearch + toSearch

    options = {
      url: urlApi
      headers: {'User-Agent': 'request'}
    }

    request options, (error, response, body) ->
      if (!error && response.statusCode == 200)
        data = JSON.parse(body)
        new FetchGhList(data)

    @close()
