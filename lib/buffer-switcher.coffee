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
    @switchToFile(testPath, "right") if new File(testPath).existsSync()

  switchToSourceFile: ->
    sourcePath = @finder.findSourcePath(@currentPath())
    @switchToFile(sourcePath, "left") if new File(sourcePath).existsSync()

  currentPath: ->
    atom.workspace.getActiveTextEditor().getPath()

  inRubyFile: ->
    @currentPath().endsWith(".rb")

  inRubyTestFile: ->
    @currentPath().endsWith("_spec.rb") || @currentPath().endsWith("_test.rb")

  switchToFile: (filepath, splitDirection) ->
    atom.workspace.open(filepath, {
      split: splitDirection,
      searchAllPanes: true
    })
