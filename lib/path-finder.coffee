path = require "path"
_ = require "underscore"
{File} = require "atom"

module.exports =
class PathFinder
  testFilesDirectories: ["spec", "test"]
  testFilesSuffixes: ["_spec", "_test"]

  findTestPath: (sourcePath) ->
    @findQuickTestPath(sourcePath)

  findSourcePath: (testPath) ->
    @findQuickSourcePath(testPath)

  findQuickTestPath: (sourcePath) ->
    rootPath = @getProjectRootPath(sourcePath)
    sourceRelativePath = @getRelativePath(sourcePath)
    testFilenames = @testFilenames(sourceRelativePath)

    quickRelativePaths = @findQuickTestRelativePaths(sourceRelativePath)
    quickPath = @findQuickPath(rootPath, quickRelativePaths, testFilenames)
    return quickPath if quickPath

    quickRailsRelativePaths = @findQuickRailsTestRelativePaths(sourceRelativePath)
    railsQuickPath = @findQuickPath(rootPath, quickRailsRelativePaths, testFilenames)
    return railsQuickPath if railsQuickPath

  findQuickSourcePath: (testPath) ->
    rootPath = @getProjectRootPath(testPath)
    testRelativePath = @getRelativePath(testPath)
    sourceFilename = @getSourceFilename(testRelativePath)

    quickRelativePath = @findQuickSourceRelativePath(testRelativePath, false)
    quickPath = @findQuickPath(rootPath, [quickRelativePath], [sourceFilename])
    return quickPath if quickPath

    quickRailsRelativePaths = @findQuickRailsSourceRelativePaths(testRelativePath)
    railsQuickPath = @findQuickPath(rootPath, quickRailsRelativePaths, [sourceFilename])
    return railsQuickPath if railsQuickPath

  findQuickTestRelativePaths: (sourceRelativePath) ->
    _(@testFilesDirectories).map (testFilesDirectory) ->
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

  testFilenames: (sourceRelativePath) ->
    _(@testFilesSuffixes).map (testFileSuffix) ->
      path.basename(sourceRelativePath, ".rb") + testFileSuffix + ".rb"

  getSourceFilename: (testRelativePath) ->
    testBasename = path.basename(testRelativePath, ".rb")
    testFileSuffix = _(@testFilesSuffixes).find (suffix) ->
      testBasename.includes(suffix)
    testBasename.replace(testFileSuffix, "") + ".rb"

  findQuickPath: (rootPath, candidateDirectories, candidateFilenames) ->
    _(candidateFilenames).chain()
      .map (candidateFilename) ->
        _(candidateDirectories).map (candidateDirectory) ->
          path.join(rootPath, candidateDirectory, candidateFilename)
      .flatten()
      .find (quickPath) ->
        new File(quickPath).existsSync()
      .value()

  getProjectRootPath: (fullPath) ->
    atom.project.relativizePath(fullPath)[0]

  getRelativePath: (fullPath) ->
    atom.project.relativizePath(fullPath)[1]
