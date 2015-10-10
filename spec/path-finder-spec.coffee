path = require "path"
PathFinder = require "../lib/path-finder"

describe "PathFinder", ->
  [finder] = []

  beforeEach ->
    finder = new PathFinder
    @rootPath = path.join(__dirname, "fixtures")
    waitsForPromise ->
      atom.workspace.open(@rootPath)

  describe "::findTestPath", ->
    describe "with a source code filepath without related test file", ->
      it "returns undefined", ->
        sourcePath = path.join(@rootPath, "lib", "without_tests.rb")
        expect(finder.findTestPath(sourcePath)).toBeUndefined()

    describe "with non-Rails projects", ->
      describe "with a source code file located at /lib", ->
        it "returns the related test filepath", ->
          sourcePath = path.join(@rootPath, "lib", "foo.rb")
          expectedPath = path.join(@rootPath, "spec", "foo_spec.rb")
          expect(finder.findTestPath(sourcePath)).toBe(expectedPath)

        describe "with related minitest/test-unit files", ->
          it "returns the related test filepath", ->
            sourcePath = path.join(@rootPath, "lib", "minitest.rb")
            expectedPath = path.join(@rootPath, "test", "minitest_test.rb")
            expect(finder.findTestPath(sourcePath)).toBe(expectedPath)

      describe "with a source code file located at /lib/foo", ->
        it "returns the related test filepath", ->
          sourcePath = path.join(@rootPath, "lib", "foo", "bar.rb")
          expectedPath = path.join(@rootPath, "spec", "foo", "bar_spec.rb")
          expect(finder.findTestPath(sourcePath)).toBe(expectedPath)

    describe "with Rails projects", ->
      describe "with a source code file located at /lib", ->
        it "returns the related test filepath", ->
          sourcePath = path.join(@rootPath, "lib", "rails.rb")
          expectedPath = path.join(@rootPath, "spec", "lib", "rails_spec.rb")
          expect(finder.findTestPath(sourcePath)).toBe(expectedPath)

        describe "with related minitest/test-unit files", ->
          it "returns the related test filepath", ->
            sourcePath = path.join(@rootPath, "lib", "minitest_rails.rb")
            expectedPath = path.join(@rootPath, "test", "lib", "minitest_rails_test.rb")
            expect(finder.findTestPath(sourcePath)).toBe(expectedPath)

      describe "with a source code file located at /app/models", ->
        it "returns the related test filepath", ->
          sourcePath = path.join(@rootPath, "app", "models", "foo.rb")
          expectedPath = path.join(@rootPath, "spec", "models", "foo_spec.rb")
          expect(finder.findTestPath(sourcePath)).toBe(expectedPath)

      describe "with a source code file located at /app/controllers", ->
        it "returns the related test filepath", ->
          sourcePath = path.join(@rootPath, "app", "controllers", "foo.rb")
          expectedPath = path.join(@rootPath, "spec", "controllers", "foo_spec.rb")
          expect(finder.findTestPath(sourcePath)).toBe(expectedPath)

    # Uses 'rom-rb' as sample Ruby project using 'non-standard' locations for its test files
    describe "with rom-rb-like projects", ->
      describe "with a source code file located at lib/rom", ->
        it "returns the related test filepath if it exists", ->
          sourcePath = path.join(@rootPath, "lib", "rom", "rom.rb")
          expectedPath = path.join(@rootPath, "spec", "unit", "rom", "rom_spec.rb")
          expect(finder.findTestPath(sourcePath)).toBe(expectedPath)

        it "returns undefined if it doesn't have related test file", ->
          sourcePath = path.join(@rootPath, "lib", "rom", "rom_fake.rb")
          expect(finder.findTestPath(sourcePath)).toBeUndefined()

  describe "::findSourcePath", ->
    describe "with a source code file without related test file", ->
      it "returns undefined", ->
        testPath = path.join(@rootPath, "spec", "without_source_spec.rb")
        expect(finder.findSourcePath(testPath)).toBeUndefined()

    describe "with non-Rails projects", ->
      describe "with a test file located at /lib", ->
        it "returns the related source code filepath", ->
          testPath = path.join(@rootPath, "spec", "foo_spec.rb")
          expectedPath = path.join(@rootPath, "lib", "foo.rb")
          expect(finder.findSourcePath(testPath)).toBe(expectedPath)

        describe "which is a minitest/test-unit file", ->
          it "returns the related source code filepath", ->
            testPath = path.join(@rootPath, "test", "minitest_test.rb")
            expectedPath = path.join(@rootPath, "lib", "minitest.rb")
            expect(finder.findSourcePath(testPath)).toBe(expectedPath)

      describe "with a test file located at /lib/foo", ->
        it "returns the related source code filepath", ->
          testPath = path.join(@rootPath, "spec", "foo", "bar_spec.rb")
          expectedPath = path.join(@rootPath, "lib", "foo", "bar.rb")
          expect(finder.findSourcePath(testPath)).toBe(expectedPath)

    describe "with Rails projects", ->
      describe "with a test file located at /lib", ->
        it "returns the related source code filepath", ->
          testPath = path.join(@rootPath, "spec", "lib", "rails_spec.rb")
          expectedPath = path.join(@rootPath, "lib", "rails.rb")
          expect(finder.findSourcePath(testPath)).toBe(expectedPath)

        describe "which is a minitest/test-unit file", ->
          it "returns the related source code filepath", ->
            testPath = path.join(@rootPath, "test", "lib", "minitest_rails_test.rb")
            expectedPath = path.join(@rootPath, "lib", "minitest_rails.rb")
            expect(finder.findSourcePath(testPath)).toBe(expectedPath)

      describe "with a test file located at /app/models", ->
        it "returns the related source code filepath", ->
          testPath = path.join(@rootPath, "spec", "models", "foo_spec.rb")
          expectedPath = path.join(@rootPath, "app", "models", "foo.rb")
          expect(finder.findSourcePath(testPath)).toBe(expectedPath)

      describe "with a test file located at /app/controllers", ->
        it "returns the related source code filepath", ->
          testPath = path.join(@rootPath, "spec", "controllers", "foo_spec.rb")
          expectedPath = path.join(@rootPath, "app", "controllers", "foo.rb")
          expect(finder.findSourcePath(testPath)).toBe(expectedPath)

    # Uses 'rom-rb' as sample Ruby project using 'non-standard' locations for its test files
    describe "with rom-rb-like projects", ->
      describe "with a test file located at spec/unit/rom", ->
        it "returns the related source code filepath if it exists", ->
          testPath = path.join(@rootPath, "spec", "unit", "rom", "rom_spec.rb")
          expectedPath = path.join(@rootPath, "lib", "rom", "rom.rb")
          expect(finder.findSourcePath(testPath)).toBe(expectedPath)
