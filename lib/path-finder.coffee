QuickPathFinder = require "./quick-path-finder"

module.exports =
class PathFinder
  testFilesDirectories: ["spec", "test"]
  testFilesSuffixes: ["_spec", "_test"]

  constructor: (@finder, @editor, opts = {}) ->
    @quickFinder = new QuickPathFinder(@testFilesDirectories, @testFilesSuffixes)

  findTestPath: (sourcePath) ->
    @quickFinder.findTestPath(sourcePath)

  findSourcePath: (testPath) ->
    @quickFinder.findSourcePath(testPath)
