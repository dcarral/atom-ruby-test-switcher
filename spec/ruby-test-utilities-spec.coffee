RubyTestUtilities = require "../lib/ruby-test-utilities"
BufferSwitcher = require "../lib/buffer-switcher"

describe "RubyTestUtilities", ->
  [workspaceElement, activationPromise] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage("ruby-test-utilities")

  describe "when the ruby-test-utilities:switch event is triggered", ->
    it "asks BufferSwitcher to switch", ->
      switcher = jasmine.createSpyObj("switcher", ["switch"])
      spyOn(RubyTestUtilities, "switcher").andCallFake ->
        switcher

      atom.commands.dispatch(workspaceElement, "ruby-test-utilities:switch")

      waitsForPromise ->
        activationPromise

      runs ->
        expect(switcher.switch).toHaveBeenCalled()
