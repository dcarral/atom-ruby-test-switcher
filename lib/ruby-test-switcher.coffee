{CompositeDisposable} = require "atom"
BufferSwitcher = require "./buffer-switcher"
PathFinder = require "./path-finder"
_ = require "underscore"

module.exports = RubyTestSwitcher =
  config:
    createTestFileIfNoneFound:
      title: "When switching, creates a new test file if none has been found."
      type: "boolean"
      default: false

  subscriptions: null

  activate: (_state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add "atom-workspace",
     "ruby-test-switcher:switch": => @switch()
    @subscriptions.add atom.commands.add "atom-workspace",
     "ruby-test-switcher:switch-without-split": => @switchWithoutSplit()

  deactivate: ->
    @subscriptions.dispose()

  switch: ->
    if @fileInEditor()
      switcher = @switcher(split: true)
      switcher.switch()

  switchWithoutSplit: ->
    @switcher().switch() if @fileInEditor()

  switcher: (opts = {}) ->
    new BufferSwitcher(@pathFinder(), @editor(), opts)

  editor: ->
    atom.workspace.getActiveTextEditor()

  fileInEditor: ->
    @editor() && !_(@editor().getPath()).isUndefined()

  pathFinder: ->
    new PathFinder()
