QuickPathFinder = require "./quick-path-finder"
GlobalPathFinder = require "./global-path-finder"
PathFinderUtilities = require "./path-finder-utilities"

module.exports =
class PathFinder
  constructor: (@finder, @editor, opts = {}) ->
    utilities = new PathFinderUtilities()

    @quickFinder = new QuickPathFinder(utilities)
    @globalFinder = new GlobalPathFinder(utilities)

  findTestPath: (sourcePath) ->
    quickPath = @quickFinder.findTestPath(sourcePath)
    return quickPath if quickPath

    @globalFinder.findTestPath(sourcePath)

  findSourcePath: (testPath) ->
    quickPath = @quickFinder.findSourcePath(testPath)
    return quickPath if quickPath

    @globalFinder.findSourcePath(testPath)
