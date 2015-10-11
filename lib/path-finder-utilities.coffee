path = require "path"
_ = require "underscore"

module.exports =
class PathFinderUtilities
  testFilesSuffixes: ["_spec", "_test"]
  testFilesDirectories: ["spec", "test"]

  getProjectRootPath: (fullPath) ->
    atom.project.relativizePath(fullPath)[0]

  getRelativePath: (fullPath) ->
    atom.project.relativizePath(fullPath)[1]

  getTestFilenameCandidates: (sourcePath) ->
    sourceBasename = @getRubyBasename(sourcePath)
    _(@testFilesSuffixes).map (testFileSuffix) ->
      sourceBasename + testFileSuffix + ".rb"

  getSourceFilename: (testPath) ->
    testBasename = @getRubyBasename(testPath)

    testSuffixesPattern = @testFilesSuffixes.join("|")
    sourceBasename = testBasename.replace(new RegExp(testSuffixesPattern), "")

    sourceBasename + ".rb"

  getRubyBasename: (rubyFilepath) ->
    path.basename(rubyFilepath, ".rb")

  getTestFilesDirectories: ->
    @testFilesDirectories
