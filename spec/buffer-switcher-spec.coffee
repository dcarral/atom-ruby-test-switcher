BufferSwitcher = require "../lib/buffer-switcher"

describe "BufferSwitcher", ->
  [switcher] = []

  beforeEach ->
    switcher = new BufferSwitcher

  describe "when a source code file is active", ->
    beforeEach ->
      waitsForPromise ->
        atom.workspace.open("/tmp/foo.rb")

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
        atom.workspace.open("/tmp/foo_spec.rb")

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
        atom.workspace.open("/tmp/foo_test.rb")

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
