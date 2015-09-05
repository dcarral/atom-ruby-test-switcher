{CompositeDisposable} = require "atom"
BufferSwitcher = require "./buffer-switcher"

module.exports = RubyTestUtilities =
  subscriptions: null

  activate: (_state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add "atom-workspace",
     "ruby-test-utilities:switch": => @switch()

  deactivate: ->
    @subscriptions.dispose()

  switch: ->
    @switcher().switch()

  switcher: ->
    new BufferSwitcher
