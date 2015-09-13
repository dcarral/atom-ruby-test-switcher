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
