path = require "path"
glob = require "glob"
_ = require "underscore"
PathFinderUtilities = require "./path-finder-utilities.coffee"

module.exports =
class GlobalPathFinder
  constructor: (@utilities) ->

  findPattern: (pattern) ->
    matches = glob.sync(pattern)
    _(matches).first()

  findTestPath: (sourcePath) ->
    pattern = @getTestFilePattern(sourcePath)
    @findPattern(pattern)

  findSourcePath: (testPath) ->
    pattern = @getSourceFilePattern(testPath)
    @findPattern(pattern)

  getTestFilePattern: (sourcePath) ->
    rootPath = @utilities.getProjectRootPath(sourcePath)
    testFilenames = @utilities.getTestFilenameCandidates(sourcePath)

    patterns = _(testFilenames).map (testFilename) ->
      rootPath + "/**/" + testFilename

    "{" + patterns.join(",") + "}"

  getSourceFilePattern: (testPath) ->
    rootPath = @utilities.getProjectRootPath(testPath)
    sourceFilename = @utilities.getSourceFilename(testPath)

    rootPath + "/**/" + sourceFilename
