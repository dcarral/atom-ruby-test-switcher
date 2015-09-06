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
    specPath = @finder.findSpecPath(@currentPath())
    @switchToFile(specPath, "right") if new File(specPath).existsSync()

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
