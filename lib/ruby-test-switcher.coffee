{CompositeDisposable} = require "atom"
BufferSwitcher = require "./buffer-switcher"
PathFinder = require "./path-finder"
_ = require "underscore"

module.exports = RubyTestSwitcher =
  config:
    useGlobalPathFinder:
      title: "Enable support for looking up source and test files in 'non-standard' locations"
      type: 'boolean'
      default: true

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
