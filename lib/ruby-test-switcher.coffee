{CompositeDisposable} = require "atom"
BufferSwitcher = require "./buffer-switcher"
PathFinder = require "./path-finder"

module.exports = RubyTestSwitcher =
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
    if @editor()
      switcher = @switcher(split: true)
      switcher.switch()

  switchWithoutSplit: ->
    @switcher().switch() if @editor()

  switcher: (opts = {}) ->
    new BufferSwitcher(@pathFinder(), @editor(), opts)

  editor: ->
    atom.workspace.getActiveTextEditor()

  pathFinder: ->
    new PathFinder()
