FetchGhView = require './fetch-gh-view'
{CompositeDisposable} = require 'atom'

module.exports = FetchGh =
  fetchghView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable
    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'Fetch-GH:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @fetchghView.destroy()

  toggle: ->
    unless @fetchGhView
      @fetchGhView = new FetchGhView()

    @fetchGhView.open()
