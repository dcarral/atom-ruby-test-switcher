BufferSwitcher = require "../lib/buffer-switcher"
PathFinder = require "../lib/path-finder"

describe "BufferSwitcher", ->
  [switcher] = []

  beforeEach ->
    @finder = new PathFinder()
    @mockEditor = jasmine.createSpyObj("editor", ["getPath"])

  describe "when a source code file is active", ->
    beforeEach ->
      waitsForPromise ->
        atom.workspace.open("/tmp/foo.rb").then ->
          editor = atom.workspace.getActiveTextEditor()
          switcher = new BufferSwitcher(@finder, editor)

    describe "::switch", ->
      it "invokes ::switchToTestFile", ->
        spyOn(switcher, "switchToTestFile")
        switcher.switch()
        expect(switcher.switchToTestFile).toHaveBeenCalled()

    describe "::inRubyFile", ->
      it "returns true", ->
        expect(switcher.inRubyFile()).toBeTruthy()

    describe "::inRubyTestFile", ->
      it "returns false", ->
        expect(switcher.inRubyTestFile()).toBeFalsy()

  describe "when a test file is active", ->
    beforeEach ->
      waitsForPromise ->
        atom.workspace.open("/tmp/foo_spec.rb").then ->
          editor = atom.workspace.getActiveTextEditor()
          switcher = new BufferSwitcher(@finder, editor)

    describe "::switch", ->
      it "invokes ::switchToSourceFile", ->
        spyOn(switcher, "switchToSourceFile")
        switcher.switch()
        expect(switcher.switchToSourceFile).toHaveBeenCalled()

    describe "::inRubyFile", ->
      it "returns true", ->
        expect(switcher.inRubyFile()).toBeTruthy()

    describe "::inRubyTestFile", ->
      it "returns true", ->
        expect(switcher.inRubyTestFile()).toBeTruthy()

  describe "when a minitest/test-unit test file is active", ->
    beforeEach ->
      waitsForPromise ->
        atom.workspace.open("/tmp/foo_test.rb").then ->
          editor = atom.workspace.getActiveTextEditor()
          switcher = new BufferSwitcher(@finder, editor)

    describe "::switch", ->
      it "invokes ::switchToSourceFile", ->
        spyOn(switcher, "switchToSourceFile")
        switcher.switch()
        expect(switcher.switchToSourceFile).toHaveBeenCalled()

    describe "::inRubyFile", ->
      it "returns true", ->
        expect(switcher.inRubyFile()).toBeTruthy()

    describe "::inRubyTestFile", ->
      it "returns true", ->
        expect(switcher.inRubyTestFile()).toBeTruthy()

    describe "::switchToTestFile", ->
      describe "with createTestFileIfNoneFound set to false (default)", ->
        describe "when a test file path is found", ->
          it "invokes ::switchToFile", ->
            spyOn(@finder, "findTestPath").andReturn("whatever")
            switcher = new BufferSwitcher(@finder, @mockEditor)
            spyOn(switcher, "switchToFile")
            switcher.switchToTestFile()
            expect(switcher.switchToFile).toHaveBeenCalled()

        describe "when a test file path isn't found", ->
          it "doesn't invoke ::switchToFile", ->
            spyOn(@finder, "findTestPath").andReturn(undefined)
            switcher = new BufferSwitcher(@finder, @mockEditor)
            spyOn(switcher, "switchToFile")
            switcher.switchToTestFile()
            expect(switcher.switchToFile).not.toHaveBeenCalled()

      describe "with createTestFileIfNoneFound set to true", ->
        describe "when a test file path is found", ->
          it "invokes ::switchToFile", ->
            spyOn(@finder, "findTestPath").andReturn("whatever")
            switcher = new BufferSwitcher(@finder, @mockEditor)
            spyOn(switcher, "switchToFile")
            switcher.switchToTestFile()
            expect(switcher.switchToFile).toHaveBeenCalled()

        describe "when a test file path isn't found", ->
          it "invokes ::switchToFile anyway", ->
            atom.config.set("ruby-test-switcher.createTestFileIfNoneFound", true)
            spyOn(@finder, "findTestPath").andReturn(undefined)
            spyOn(@finder, "findBestTestCandidatePath").andReturn("whatever")
            switcher = new BufferSwitcher(@finder, @mockEditor)
            spyOn(switcher, "switchToFile")
            switcher.switchToTestFile()
            expect(switcher.switchToFile).toHaveBeenCalled()

    describe "::switchToSourceFile", ->
      describe "when a source file path is found", ->
        it "invokes ::switchToFile", ->
          spyOn(@finder, "findSourcePath").andReturn("whatever")
          switcher = new BufferSwitcher(@finder, @mockEditor)
          spyOn(switcher, "switchToFile")
          switcher.switchToSourceFile()
          expect(switcher.switchToFile).toHaveBeenCalled()

      describe "when a source file path isn't found", ->
        it "doesn't invoke ::switchToFile", ->
          spyOn(@finder, "findSourcePath").andReturn(undefined)
          switcher = new BufferSwitcher(@finder, @mockEditor)
          spyOn(switcher, "switchToFile")
          switcher.switchToSourceFile()
          expect(switcher.switchToFile).not.toHaveBeenCalled()
