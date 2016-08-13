QuickPathFinder = require "./quick-path-finder"
GlobalPathFinder = require "./global-path-finder"
PathFinderUtilities = require "./path-finder-utilities"

module.exports =
class PathFinder
  constructor: ->
    utilities = new PathFinderUtilities()

    @quickFinder = new QuickPathFinder(utilities)

    if atom.config.get 'ruby-test-switcher.useGlobalPathFinder'
      @globalFinder = new GlobalPathFinder(utilities)

  findTestPath: (sourcePath) ->
    quickPath = @quickFinder.findTestPath(sourcePath)
    return quickPath if quickPath

    @globalFinder.findTestPath(sourcePath) if @globalFinder

  findSourcePath: (testPath) ->
    quickPath = @quickFinder.findSourcePath(testPath)
    return quickPath if quickPath

    @globalFinder.findSourcePath(testPath) if @globalFinder
