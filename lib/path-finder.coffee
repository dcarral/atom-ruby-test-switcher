path = require "path"
_ = require "underscore"
{File} = require "atom"

module.exports =
class PathFinder
  testFilesDirectories: ["spec", "test"]
  testFilesSuffixes: ["_spec", "_test"]

  findSpecPath: (sourcePath) ->
    @findQuickSpecPath(sourcePath)

  findSourcePath: (specPath) ->
    # TODO

  findQuickSpecPath: (sourcePath) ->
    sourceRelativizedPath = atom.project.relativizePath(sourcePath)
    rootPath = sourceRelativizedPath[0]
    sourceRelativePath = sourceRelativizedPath[1]

    specFilenames = @specFilenames(sourceRelativePath)

    quickRelativePaths = @findQuickRelativePaths(sourceRelativePath)
    quickPath = @findQuickPath(rootPath, quickRelativePaths, specFilenames)
    return quickPath if quickPath

    quickRailsRelativePaths = @findQuickRailsRelativePaths(sourceRelativePath)
    railsQuickPath = @findQuickPath(rootPath, quickRailsRelativePaths, specFilenames)
    return railsQuickPath if railsQuickPath

  findQuickRelativePaths: (sourceRelativePath) ->
    _(@testFilesDirectories).map (testFilesDirectory) ->
      sourceDirectories = path.dirname(sourceRelativePath).split(path.sep)
      sourceDirectories[0] = testFilesDirectory
      path.join.apply(null, sourceDirectories)

  findQuickRailsRelativePaths: (sourceRelativePath) ->
    _(@findQuickRelativePaths(sourceRelativePath)).map (quickDirectoryPath) ->
      quickDirectoryPathParts = quickDirectoryPath.split(path.sep)
      quickDirectoryPathParts.splice(1, 0, "lib")
      path.join.apply(null, quickDirectoryPathParts)

  specFilenames: (sourceRelativePath) ->
    _(@testFilesSuffixes).map (testFileSuffix) ->
      path.basename(sourceRelativePath, ".rb") + testFileSuffix + ".rb"

  findQuickPath: (rootPath, candidateDirectories, specFilenames) ->
    _(specFilenames).chain()
      .map (specFilename) ->
        _(candidateDirectories).map (candidateDirectory) ->
          path.join(rootPath, candidateDirectory, specFilename)
      .flatten()
      .find (quickPath) ->
        new File(quickPath).existsSync()
      .value()
