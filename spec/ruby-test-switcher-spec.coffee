path = require "path"
{File} = require "atom"
RubyTestSwitcher = require "../lib/ruby-test-switcher"
BufferSwitcher = require "../lib/buffer-switcher"

describe "RubyTestSwitcher", ->
  [workspaceElement, activationPromise, sourcePath, testPath] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage("ruby-test-switcher")
    sourcePath = path.join(__dirname, "fixtures", "app", "models", "foo.rb")
    testPath = path.join(__dirname, "fixtures", "spec", "models", "foo_spec.rb")

  describe "when the ruby-test-switcher:switch event is triggered", ->
    describe "with an active text editor", ->
      beforeEach ->
        waitsForPromise ->
          atom.workspace.open(sourcePath)

      it "switches to the spec file splitting pane", ->
        atom.commands.dispatch(workspaceElement, "ruby-test-switcher:switch")

        waitsFor ->
          activationPromise
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

    it "switches to the spec file without splitting pane", ->
      atom.commands.dispatch(workspaceElement, "ruby-test-switcher:switch-without-split")

      waitsFor ->
        activationPromise
      waitsFor ->
        atom.workspace.getActiveTextEditor().getPath() != sourcePath

      runs ->
        currentPath = atom.workspace.getActiveTextEditor().getPath()
        expect(currentPath).toBe(testPath)
        expect(atom.workspace.getPanes().length).toBe(1)
