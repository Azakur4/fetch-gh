{$, TextEditorView, SelectListView}  = require 'atom-space-pen-views'

FetchGhTags = require './fetch-gh-tags'

module.exports =
class FetchGhList extends SelectListView
  initialize: (data) ->
    super
    @panel ?= atom.workspace.addModalPanel(item: this, visible: true)
    @setItems(data.items)
    @focusFilterEditor()

  cancelled: -> @close()

  close: ->
    @panel?.destroy()

  getFilterKey: ->
    "name"

  viewForItem: (item) ->
    '<li class="fetch-gh-item">' +
    "<span>#{item.name}</span><br />" +
    "<span><b>Owner:</b> #{item.owner.login}</span><br />" +
    "<span>#{item.description}</span>" +
    "</li>"

  confirmed: (item) ->
    @cancel()
    new FetchGhTags(item.name, item.tags_url)
