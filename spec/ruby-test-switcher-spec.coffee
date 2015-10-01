path = require "path"
{File} = require "atom"
RubyTestSwitcher = require "../lib/ruby-test-switcher"
BufferSwitcher = require "../lib/buffer-switcher"

describe "RubyTestSwitcher", ->
  [workspaceElement, sourcePath, testPath] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    sourcePath = path.join(__dirname, "fixtures", "app", "models", "foo.rb")
    testPath = path.join(__dirname, "fixtures", "spec", "models", "foo_spec.rb")
    waitsForPromise ->
      atom.packages.activatePackage("ruby-test-switcher")

  describe "when 'switch' is triggered", ->
    describe "with an active text editor", ->
      beforeEach ->
        waitsForPromise ->
          atom.workspace.open(sourcePath)

      it "switches to the test file, splitting pane", ->
        atom.commands.dispatch(workspaceElement, "ruby-test-switcher:switch")

        waitsFor ->
          atom.workspace.getActiveTextEditor() != undefined

        runs ->
          currentPath = atom.workspace.getActiveTextEditor().getPath()
          expect(currentPath).toBe(testPath)
          expect(atom.workspace.getPanes().length).toBe(2)

    describe "without an active text editor", ->
      it "doesn't ask BufferSwitcher to switch", ->
        switcher = jasmine.createSpyObj("switcher", ["switch"])
        spyOn(RubyTestSwitcher, "switcher").andCallFake ->
          switcher
        atom.commands.dispatch(workspaceElement, "ruby-test-switcher:switch")

        expect(switcher.switch).not.toHaveBeenCalled()

  describe "when 'switch-without-split' is triggered in a source file", ->
    beforeEach ->
      waitsForPromise ->
        atom.workspace.open(sourcePath)

    it "switches to the test file, without splitting pane", ->
      atom.commands.dispatch(workspaceElement, "ruby-test-switcher:switch-without-split")

      waitsFor ->
        atom.workspace.getActiveTextEditor().getPath() != sourcePath

      runs ->
        currentPath = atom.workspace.getActiveTextEditor().getPath()
        expect(currentPath).toBe(testPath)
        expect(atom.workspace.getPanes().length).toBe(1)
