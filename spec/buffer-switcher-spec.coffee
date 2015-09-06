BufferSwitcher = require "../lib/buffer-switcher"

describe "BufferSwitcher", ->
  [switcher] = []

  beforeEach ->
    switcher = new BufferSwitcher

  describe "when a code file is active", ->
    beforeEach ->
      waitsForPromise ->
        atom.workspace.open("/tmp/foo.rb").then ->
          textEditor = atom.workspace.getActiveTextEditor()

    describe "::switch", ->
      it "invokes ::switchToTestFile", ->
        spyOn(switcher, "switchToTestFile")
        runs -> switcher.switch
        expect(switcher.switchToTestFile).toHaveBeenCalled

    describe "::inRubyFile", ->
      it "returns true", ->
        expect(switcher.inRubyFile()).toBeTruthy()

    describe "::inRubyTestFile", ->
      it "returns false", ->
        expect(switcher.inRubyTestFile()).toBeFalsy()

  describe "when a spec file is active", ->
    beforeEach ->
      waitsForPromise ->
        atom.workspace.open("/tmp/foo_spec.rb")

    describe "::switch", ->
      it "invokes ::switchToCodeFile", ->
        spyOn(switcher, "switchToCodeFile")
        runs -> switcher.switch
        expect(switcher.switchToCodeFile).toHaveBeenCalled

    describe "::inRubyFile", ->
      it "returns true", ->
        expect(switcher.inRubyFile()).toBeTruthy()

    describe "::inRubyTestFile", ->
      it "returns true", ->
        expect(switcher.inRubyTestFile()).toBeTruthy()

  describe "when a test file is active", ->
    beforeEach ->
      waitsForPromise ->
        atom.workspace.open("/tmp/foo_test.rb")

    describe "::switch", ->
      it "invokes ::switchToCodeFile", ->
        spyOn(switcher, "switchToCodeFile")
        runs -> switcher.switch
        expect(switcher.switchToCodeFile).toHaveBeenCalled

    describe "::inRubyFile", ->
      it "returns true", ->
        expect(switcher.inRubyFile()).toBeTruthy()

    describe "::inRubyTestFile", ->
      it "returns true", ->
        expect(switcher.inRubyTestFile()).toBeTruthy()