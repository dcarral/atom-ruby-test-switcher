PathFinder = require "./path-finder"

module.exports =
class BufferSwitcher
  constructor: (@finder, @editor) ->
    @currentPath = @editor.getPath()

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
    atom.workspace.open(filepath, split: splitDirection, searchAllPanes: true)
