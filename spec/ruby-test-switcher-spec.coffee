path = require "path"
{File} = require "atom"
RubyTestSwitcher = require "../lib/ruby-test-switcher"
BufferSwitcher = require "../lib/buffer-switcher"

describe "RubyTestSwitcher", ->
  [workspaceElement, sourcePath, testPath, switcher] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    sourcePath = path.join(__dirname, "fixtures", "app", "models", "foo.rb")
    testPath = path.join(__dirname, "fixtures", "spec", "models", "foo_spec.rb")
    waitsForPromise ->
      atom.packages.activatePackage("ruby-test-switcher")

  describe "with an active text editor containing a Ruby source file", ->
    beforeEach ->
      waitsForPromise ->
        atom.workspace.open(sourcePath)

    describe "when 'switch' is triggered", ->
      it "switches to the test file, splitting pane", ->
        atom.commands.dispatch(workspaceElement, "ruby-test-switcher:switch")

        waitsFor ->
          atom.workspace.getActiveTextEditor() != undefined

        runs ->
          currentPath = atom.workspace.getActiveTextEditor().getPath()
          expect(currentPath).toBe(testPath)
          expect(atom.workspace.getPanes().length).toBe(2)

    describe "when 'switch-without-split' is triggered", ->
      it "switches to the test file, without splitting pane", ->
        atom.commands.dispatch(workspaceElement, "ruby-test-switcher:switch-without-split")

        waitsFor ->
          atom.workspace.getActiveTextEditor().getPath() != sourcePath

        runs ->
          currentPath = atom.workspace.getActiveTextEditor().getPath()
          expect(currentPath).toBe(testPath)
          expect(atom.workspace.getPanes().length).toBe(1)

  # Uses 'rom-rb' as sample Ruby project using 'non-standard' locations for its test files
  describe "with an active text editor containing rom-rb-like Ruby source file", ->
    beforeEach ->
      sourcePath = path.join(__dirname, "fixtures", "lib", "rom", "rom.rb")
      testPath = path.join(__dirname, "fixtures", "spec", "unit", "rom", "rom_spec.rb")
      waitsForPromise ->
        atom.workspace.open(sourcePath)

    it "switches to the test file, splitting pane when 'switch is triggered'", ->
      atom.commands.dispatch(workspaceElement, "ruby-test-switcher:switch")

      waitsFor ->
        atom.workspace.getActiveTextEditor() != undefined

      runs ->
        currentPath = atom.workspace.getActiveTextEditor().getPath()
        expect(currentPath).toBe(testPath)


  describe "without an active text editor", ->
    beforeEach ->
      switcher = jasmine.createSpyObj("switcher", ["switch"])
      spyOn(RubyTestSwitcher, "switcher").andCallFake ->
        switcher

    describe "when 'switch' is triggered", ->
      it "doesn't ask BufferSwitcher to switch", ->
        atom.commands.dispatch(workspaceElement, "ruby-test-switcher:switch")

        expect(switcher.switch).not.toHaveBeenCalled()

    describe "when 'switch-without-split' is triggered", ->
      it "doesn't ask BufferSwitcher to switch", ->
        atom.commands.dispatch(workspaceElement, "ruby-test-switcher:switch-without-split")

        expect(switcher.switch).not.toHaveBeenCalled()

  describe "with a blank document", ->
    beforeEach ->
      switcher = jasmine.createSpyObj("switcher", ["switch"])
      spyOn(RubyTestSwitcher, "switcher").andCallFake ->
        switcher
      waitsForPromise ->
        atom.workspace.open()

    describe "when 'switch' is triggered", ->
      it "doesn't ask BufferSwitcher to switch", ->
        waitsFor ->
          atom.workspace.getActiveTextEditor() != undefined

        runs ->
          atom.commands.dispatch(workspaceElement, "ruby-test-switcher:switch-without-split")
          expect(switcher.switch).not.toHaveBeenCalled()

    describe "when 'switch-without-split' is triggered", ->
      it "doesn't ask BufferSwitcher to switch", ->
        waitsFor ->
          atom.workspace.getActiveTextEditor() != undefined

        runs ->
          atom.commands.dispatch(workspaceElement, "ruby-test-switcher:switch-without-split")
          expect(switcher.switch).not.toHaveBeenCalled()
