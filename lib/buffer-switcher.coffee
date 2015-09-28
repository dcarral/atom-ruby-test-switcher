_ = require "underscore"
PathFinder = require "./path-finder"

module.exports =
class BufferSwitcher
  constructor: (@finder, @editor, opts = {}) ->
    @currentPath = @editor.getPath()
    @splitEnabled = opts.split

  switch: ->
    if @inRubyTestFile()
      @switchToSourceFile()
    else if @inRubyFile()
      @switchToTestFile()

  switchToTestFile: ->
    testPath = @finder.findTestPath(@currentPath)
    @switchToFile(testPath, "right") if testPath

  switchToSourceFile: ->
    sourcePath = @finder.findSourcePath(@currentPath)
    @switchToFile(sourcePath, "left") if sourcePath

  inRubyFile: ->
    @currentPath.endsWith(".rb")

  inRubyTestFile: ->
    @currentPath.endsWith("_spec.rb") || @currentPath.endsWith("_test.rb")

  switchToFile: (filepath, splitDirection) ->
    base_options = searchAllPanes: true

    if @splitEnabled
      options = _(base_options).extend({split: splitDirection})
    else
      options = base_options

    atom.workspace.open(filepath, options)
