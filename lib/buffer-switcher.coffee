{File} = require "atom"

module.exports =
class BufferSwitcher
  switch: ->
    if @inRubyTestFile()
      @switchToCodeFile()
    else if @inRubyFile()
      @switchToTestFile()

  switchToTestFile: ->
    specPath = @findSpecPath(@currentPath())

    specFile = new File(specPath)
    return unless specFile.existsSync()

    @openFile(specPath, "right")

  switchToCodeFile: ->
    codePath = @findCodePath(@currentPath())

    codeFile = new File(codeFile)
    return unless codeFile.existsSync()

    @openFile(codePath, "left")

  currentPath: ->
    atom.workspace.getActiveTextEditor().getPath()

  inRubyFile: ->
    @currentPath().endsWith(".rb")

  inRubyTestFile: ->
    @currentPath().endsWith("_spec.rb")

  findSpecPath: (currentPath) ->
    # TODO

  findCodePath: (currentPath) ->
    # TODO

  openFile: (filepath, splitDirection) ->
    atom.workspace.open(filepath, {
      split: splitDirection,
      searchAllPanes: true
    })
