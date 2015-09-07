{File} = require "atom"
PathFinder = require "./path-finder"

module.exports =
class BufferSwitcher
  finder: new PathFinder

  switch: ->
    if @inRubyTestFile()
      @switchToSourceFile()
    else if @inRubyFile()
      @switchToTestFile()

  switchToTestFile: ->
    testPath = @finder.findTestPath(@currentPath())
    @switchToFile(testPath, "right") if testPath

  switchToSourceFile: ->
    sourcePath = @finder.findSourcePath(@currentPath())
    @switchToFile(sourcePath, "left") if sourcePath

  currentPath: ->
    atom.workspace.getActiveTextEditor().getPath()

  inRubyFile: ->
    @currentPath().endsWith(".rb")

  inRubyTestFile: ->
    @currentPath().endsWith("_spec.rb") || @currentPath().endsWith("_test.rb")

  switchToFile: (filepath, splitDirection) ->
    atom.workspace.open(filepath, split: splitDirection, searchAllPanes: true)
