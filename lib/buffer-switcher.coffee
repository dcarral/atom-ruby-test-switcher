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
    testPath = @finder.findTestPath(@getCurrentPath())
    @switchToFile(testPath, "right") if testPath

  switchToSourceFile: ->
    sourcePath = @finder.findSourcePath(@getCurrentPath())
    @switchToFile(sourcePath, "left") if sourcePath

  getCurrentPath: ->
    atom.workspace.getActiveTextEditor().getPath()

  inRubyFile: ->
    currentPath = @getCurrentPath()
    currentPath.endsWith(".rb")

  inRubyTestFile: ->
    currentPath = @getCurrentPath()
    currentPath.endsWith("_spec.rb") || currentPath.endsWith("_test.rb")

  switchToFile: (filepath, splitDirection) ->
    atom.workspace.open(filepath, split: splitDirection, searchAllPanes: true)
