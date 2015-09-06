path = require "path"
_ = require "underscore"
{File} = require "atom"

module.exports =
class PathFinder
  testFilesDirectories: ["spec", "test"]
  testFilesSuffixes: ["_spec", "_test"]

  findSpecPath: (sourcePath) ->
    @findQuickSpecPath(sourcePath)

  findCodePath: (sourcePath) ->
    # TODO

  findQuickSpecPath: (sourcePath) ->
    codeRelativizedPath = atom.project.relativizePath(sourcePath)
    rootPath = codeRelativizedPath[0]
    codeRelativePath = codeRelativizedPath[1]

    specFilenames = @specFilenames(codeRelativePath)

    quickRelativePaths = @findQuickRelativePaths(codeRelativePath)
    quickPath = @findQuickPath(rootPath, quickRelativePaths, specFilenames)
    return quickPath if quickPath

    quickRailsRelativePaths = @findQuickRailsRelativePaths(codeRelativePath)
    railsQuickPath = @findQuickPath(rootPath, quickRailsRelativePaths, specFilenames)
    return railsQuickPath if railsQuickPath

  findQuickRelativePaths: (codeRelativePath) ->
    _(@testFilesDirectories).map (testFilesDirectory) ->
      sourceDirectories = path.dirname(codeRelativePath).split(path.sep)
      sourceDirectories[0] = testFilesDirectory
      path.join.apply(null, sourceDirectories)

  findQuickRailsRelativePaths: (codeRelativePath) ->
    _(@findQuickRelativePaths(codeRelativePath)).map (quickDirectoryPath) ->
      quickDirectoryPathParts = quickDirectoryPath.split(path.sep)
      quickDirectoryPathParts.splice(1, 0, "lib")
      path.join.apply(null, quickDirectoryPathParts)

  specFilenames: (codeRelativePath) ->
    _(@testFilesSuffixes).map (testFileSuffix) ->
      path.basename(codeRelativePath, ".rb") + testFileSuffix + ".rb"

  findQuickPath: (rootPath, candidateDirectories, specFilenames) ->
    _(specFilenames).chain()
      .map (specFilename) ->
        _(candidateDirectories).map (candidateDirectory) ->
          path.join(rootPath, candidateDirectory, specFilename)
      .flatten()
      .find (quickPath) ->
        new File(quickPath).existsSync()
      .value()
