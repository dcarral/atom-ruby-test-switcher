{CompositeDisposable} = require "atom"
BufferSwitcher = require "./buffer-switcher"
PathFinder = require "./path-finder"

module.exports = RubyTestSwitcher =
  subscriptions: null

  activate: (_state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add "atom-workspace",
     "ruby-test-switcher:switch": => @switch()

  deactivate: ->
    @subscriptions.dispose()

  switch: ->
    @switcher().switch() if @editor()

  switcher: ->
    finder = new PathFinder()
    new BufferSwitcher(finder, @editor())

  editor: ->
    atom.workspace.getActiveTextEditor()
