path = require "path"
PathFinder = require "../lib/path-finder"

describe "PathFinder", ->
  [finder] = []

  beforeEach ->
    finder = new PathFinder
    @rootPath = path.join(__dirname, "fixtures")
    waitsForPromise ->
      atom.workspace.open(@rootPath)

  describe "::findSpecPath", ->
    it "returns undefined if there aren't spec files for that source code", ->
      sourcePath = path.join(@rootPath, "lib", "without_tests.rb")
      expect(finder.findSpecPath(sourcePath)).toBe(undefined)

    describe "with non-Rails projects", ->
      describe "at /lib", ->
        it "returns the filepath where the spec file is located", ->
          sourcePath = path.join(@rootPath, "lib", "foo.rb")
          expectedPath = path.join(@rootPath, "spec", "foo_spec.rb")
          expect(finder.findSpecPath(sourcePath)).toBe(expectedPath)

        describe "with minitest/test-unit files", ->
          it "returns the filepath where the spec file is located", ->
            sourcePath = path.join(@rootPath, "lib", "minitest.rb")
            expectedPath = path.join(@rootPath, "test", "minitest_test.rb")
            expect(finder.findSpecPath(sourcePath)).toBe(expectedPath)

      describe "at /lib/foo", ->
        it "returns the filepath where the spec file is located", ->
          sourcePath = path.join(@rootPath, "lib", "foo", "bar.rb")
          expectedPath = path.join(@rootPath, "spec", "foo", "bar_spec.rb")
          expect(finder.findSpecPath(sourcePath)).toBe(expectedPath)

    describe "with Rails projects", ->
      describe "at /lib", ->
        it "returns the filepath where the spec file is located", ->
          sourcePath = path.join(@rootPath, "lib", "rails.rb")
          expectedPath = path.join(@rootPath, "spec", "lib", "rails_spec.rb")
          expect(finder.findSpecPath(sourcePath)).toBe(expectedPath)

        describe "with minitest/test-unit files", ->
          it "returns the filepath where the spec file is located", ->
            sourcePath = path.join(@rootPath, "lib", "minitest_rails.rb")
            expectedPath = path.join(@rootPath, "test", "lib", "minitest_rails_test.rb")
            expect(finder.findSpecPath(sourcePath)).toBe(expectedPath)

      describe "at /app/models", ->
        it "returns the filepath where the spec file is located", ->
          sourcePath = path.join(@rootPath, "app", "models", "foo.rb")
          expectedPath = path.join(@rootPath, "spec", "models", "foo_spec.rb")
          expect(finder.findSpecPath(sourcePath)).toBe(expectedPath)

      describe "at /app/controllers", ->
        it "returns the filepath where the spec file is located", ->
          sourcePath = path.join(@rootPath, "app", "controllers", "foo.rb")
          expectedPath = path.join(@rootPath, "spec", "controllers", "foo_spec.rb")
          expect(finder.findSpecPath(sourcePath)).toBe(expectedPath)

  describe "::findSourcePath", ->
    it "returns undefined if there aren't source files for that test file", ->
      testPath = path.join(@rootPath, "spec", "without_source_spec.rb")
      expect(finder.findSourcePath(testPath)).toBe(undefined)

    describe "with non-Rails projects", ->
      describe "at /lib", ->
        it "returns the filepath where the source file is located", ->
          testPath = path.join(@rootPath, "spec", "foo_spec.rb")
          expectedPath = path.join(@rootPath, "lib", "foo.rb")
          expect(finder.findSourcePath(testPath)).toBe(expectedPath)

        describe "with minitest/test-unit files", ->
          it "returns the filepath where the source file is located", ->
            testPath = path.join(@rootPath, "test", "minitest_test.rb")
            expectedPath = path.join(@rootPath, "lib", "minitest.rb")
            expect(finder.findSourcePath(testPath)).toBe(expectedPath)

      describe "at /lib/foo", ->
        it "returns the filepath where the source file is located", ->
          testPath = path.join(@rootPath, "spec", "foo", "bar_spec.rb")
          expectedPath = path.join(@rootPath, "lib", "foo", "bar.rb")
          expect(finder.findSourcePath(testPath)).toBe(expectedPath)

    describe "with Rails projects", ->
      describe "at /lib", ->
        it "returns the filepath where the source file is located", ->
          testPath = path.join(@rootPath, "spec", "lib", "rails_spec.rb")
          expectedPath = path.join(@rootPath, "lib", "rails.rb")
          expect(finder.findSourcePath(testPath)).toBe(expectedPath)

        describe "with minitest/test-unit files", ->
          it "returns the filepath where the source file is located", ->
            testPath = path.join(@rootPath, "test", "lib", "minitest_rails_test.rb")
            expectedPath = path.join(@rootPath, "lib", "minitest_rails.rb")
            expect(finder.findSourcePath(testPath)).toBe(expectedPath)

      describe "at /app/models", ->
        it "returns the filepath where the source file is located", ->
          testPath = path.join(@rootPath, "spec", "models", "foo_spec.rb")
          expectedPath = path.join(@rootPath, "app", "models", "foo.rb")
          expect(finder.findSourcePath(testPath)).toBe(expectedPath)

      describe "at /app/controllers", ->
        it "returns the filepath where the source file is located", ->
          testPath = path.join(@rootPath, "spec", "controllers", "foo_spec.rb")
          expectedPath = path.join(@rootPath, "app", "controllers", "foo.rb")
          expect(finder.findSourcePath(testPath)).toBe(expectedPath)
