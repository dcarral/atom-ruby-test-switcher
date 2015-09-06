Path = require "path"
PathFinder = require "../lib/path-finder"

describe "PathFinder", ->
  [finder] = []

  beforeEach ->
    finder = new PathFinder
    @rootPath = Path.join(__dirname, "fixtures")
    waitsForPromise ->
      atom.workspace.open(@rootPath)

  describe "::findSpecPath", ->
    describe "with non-Rails projects", ->
      describe "at /lib", ->
        it "returns the filepath where the spec file should be located", ->
          codePath = Path.join(@rootPath, "lib", "foo.rb")
          expectedPath = Path.join(@rootPath, "spec", "foo_spec.rb")
          expect(finder.findSpecPath(codePath)).toBe(expectedPath)

        it "returns the filepath of a minitest/unit test file", ->
          codePath = Path.join(@rootPath, "lib", "minitest.rb")
          expectedPath = Path.join(@rootPath, "test", "minitest_test.rb")
          expect(finder.findSpecPath(codePath)).toBe(expectedPath)

      describe "at /lib/foo", ->
        it "returns the filepath where the spec file should be located", ->
          codePath = Path.join(@rootPath, "lib", "foo", "bar.rb")
          expectedPath = Path.join(@rootPath, "spec", "foo", "bar_spec.rb")
          expect(finder.findSpecPath(codePath)).toBe(expectedPath)

    describe "with Rails projects", ->
      describe "at /lib", ->
        it "returns the filepath where the spec file should be located", ->
          codePath = Path.join(@rootPath, "lib", "rails.rb")
          expectedPath = Path.join(@rootPath, "spec", "lib", "rails_spec.rb")
          expect(finder.findSpecPath(codePath)).toBe(expectedPath)

        it "returns the filepath of a minitest/unit test file", ->
          codePath = Path.join(@rootPath, "lib", "minitest_rails.rb")
          expectedPath = Path.join(@rootPath, "test", "lib", "minitest_rails_test.rb")
          expect(finder.findSpecPath(codePath)).toBe(expectedPath)

      describe "at /app/models", ->
        it "returns the filepath where the spec file should be located", ->
          codePath = Path.join(@rootPath, "app", "models", "foo.rb")
          expectedPath = Path.join(@rootPath, "spec", "models", "foo_spec.rb")
          expect(finder.findSpecPath(codePath)).toBe(expectedPath)

      describe "at /app/controllers", ->
        it "returns the filepath where the spec file should be located", ->
          codePath = Path.join(@rootPath, "app", "controllers", "foo.rb")
          expectedPath = Path.join(@rootPath, "spec", "controllers", "foo_spec.rb")
          expect(finder.findSpecPath(codePath)).toBe(expectedPath)

  describe "::findCodePath", ->
    # TODO
