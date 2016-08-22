path = require "path"
_ = require "underscore"
{File} = require "atom"
PathFinderUtilities = require "./path-finder-utilities.coffee"

module.exports =
class QuickPathFinder
  constructor: (@utilities) ->

  findTestPath: (sourcePath) ->
    rootPath = @utilities.getProjectRootPath(sourcePath)
    sourceRelativePath = @utilities.getRelativePath(sourcePath)
    testFilenames = @utilities.getTestFilenameCandidates(sourceRelativePath)

    quickRelativePaths = @findQuickTestRelativePaths(sourceRelativePath)
    quickPath = @findQuickAndExistingPath(rootPath, quickRelativePaths, testFilenames)
    return quickPath if quickPath

    quickRailsRelativePaths = @findQuickRailsTestRelativePaths(sourceRelativePath)
    railsQuickPath = @findQuickAndExistingPath(rootPath, quickRailsRelativePaths, testFilenames)
    return railsQuickPath if railsQuickPath

  findSourcePath: (testPath) ->
    rootPath = @utilities.getProjectRootPath(testPath)
    testRelativePath = @utilities.getRelativePath(testPath)
    sourceFilename = @utilities.getSourceFilename(testPath)

    quickRelativePath = @findQuickSourceRelativePath(testRelativePath, false)
    quickPath = @findQuickAndExistingPath(rootPath, [quickRelativePath], [sourceFilename])
    return quickPath if quickPath

    quickRailsRelativePaths = @findQuickRailsSourceRelativePaths(testRelativePath)
    railsQuickPath = @findQuickAndExistingPath(rootPath, quickRailsRelativePaths, [sourceFilename])
    return railsQuickPath if railsQuickPath

  findQuickTestRelativePaths: (sourceRelativePath) ->
    testFilesDirectories = @utilities.getTestFilesDirectories()

    _(testFilesDirectories).map (testFilesDirectory) ->
      sourceDirectories = path.dirname(sourceRelativePath).split(path.sep)
      sourceDirectories[0] = testFilesDirectory
      path.join.apply(null, sourceDirectories)

  findQuickRailsTestRelativePaths: (sourceRelativePath) ->
    _(@findQuickTestRelativePaths(sourceRelativePath)).map (quickDirectoryPath) ->
      quickDirectoryPathParts = quickDirectoryPath.split(path.sep)
      quickDirectoryPathParts.splice(1, 0, "lib")
      path.join.apply(null, quickDirectoryPathParts)

  findQuickSourceRelativePath: (testRelativePath, forRailsProject) ->
    testDirectories = path.dirname(testRelativePath).split(path.sep)
    if forRailsProject
      testDirectories[0] = "lib"
    else
      testDirectories[0] = "app"

    path.join.apply(null, testDirectories)

  findQuickRailsSourceRelativePaths: (testRelativePath) ->
    quickDirectoryPathParts = @findQuickSourceRelativePath(testRelativePath).split(path.sep)
    quickLibDirectoryPathParts = quickDirectoryPathParts.slice(1)

    lib_path = path.join.apply(null, quickLibDirectoryPathParts)
    app_path = @findQuickSourceRelativePath(testRelativePath, true)
    [lib_path, app_path]

  findQuickAndExistingPath: (rootPath, candidateDirectories, candidateFilenames) ->
    quickCandidatePaths = @findQuickCandidatePaths(rootPath, candidateDirectories, candidateFilenames)

    quickCandidatePaths.find (quickCandidatePath) ->
      new File(quickCandidatePath).existsSync()

  findQuickCandidatePaths: (rootPath, candidateDirectories, candidateFilenames) ->
    _(candidateFilenames).chain()
      .map (candidateFilename) ->
        _(candidateDirectories).map (candidateDirectory) ->
          path.join(rootPath, candidateDirectory, candidateFilename)
      .flatten()
      .value()

  findBestTestCandidatePath: (sourcePath) ->
    rootPath = @utilities.getProjectRootPath(sourcePath)
    sourceRelativePath = @utilities.getRelativePath(sourcePath)

    testDirectories = @findQuickTestRelativePaths(sourceRelativePath)
    testFilenames = @utilities.getTestFilenameCandidates(sourceRelativePath)

    candidatePaths = @findQuickCandidatePaths(rootPath, testDirectories, testFilenames)
    _(candidatePaths).first()
