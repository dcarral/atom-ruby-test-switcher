{CompositeDisposable} = require "atom"
BufferSwitcher = require "./buffer-switcher"
PathFinder = require "./path-finder"
_ = require "underscore"

module.exports = RubyTestSwitcher =
  config:
    createTestFileIfNoneFound:
      title: "Create test file if none is found"
      description: """
        If enabled, a new text editor is opened when switching to inexistent test files.
        If disabled, no text editors are opened.
      """
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
