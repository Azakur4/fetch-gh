fs = require 'fs'
request = require 'request'
DecompressZip = require 'decompress-zip'

{$, TextEditorView, SelectListView}  = require 'atom-space-pen-views'

module.exports =
class FetchGhTags extends SelectListView
  initialize: (@proj, urlTags) ->
    super
    @panel ?= atom.workspace.addModalPanel(item: this, visible: true)
    @listTags(urlTags)
    @focusFilterEditor()

  cancelled: -> @close()

  close: ->
    @panel?.destroy()

  getFilterKey: ->
    "name"

  viewForItem: (item) ->
    "<li>#{item.name}</li>"

  confirmed: (item) ->
    @cancel()
    downPath = atom.project.getPaths()[0] + '/Fetch-GH/'

    if !fs.existsSync downPath
      fs.mkdirSync downPath, '0777', (err) ->
        if err
          console.log err

    options = {
      url: item.zipball_url
      headers: {'User-Agent': 'request'}
    }

    request(options).pipe(fs.createWriteStream(downPath + @proj + '.zip')).on 'close', =>
      unzipper = new DecompressZip(downPath + @proj + '.zip')
      unzipper.extract({path: downPath})
      unzipper.on 'extract', (log) =>
        fs.unlink(downPath + @proj + '.zip')

  listTags: (urlTags) ->
    options = {
      url: urlTags
      headers: {'User-Agent': 'request'}
    }

    request options, (error, response, body) =>
      if (!error && response.statusCode == 200)
        data = JSON.parse(body)
        @setItems(data)
