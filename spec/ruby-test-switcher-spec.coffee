RubyTestSwitcher = require "../lib/ruby-test-switcher"
BufferSwitcher = require "../lib/buffer-switcher"

describe "RubyTestSwitcher", ->
  [workspaceElement, activationPromise] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage("ruby-test-switcher")

  describe "when the ruby-test-switcher:switch event is triggered", ->
    it "asks BufferSwitcher to switch", ->
      switcher = jasmine.createSpyObj("switcher", ["switch"])
      spyOn(RubyTestSwitcher, "switcher").andCallFake ->
        switcher

      atom.commands.dispatch(workspaceElement, "ruby-test-switcher:switch")

      waitsForPromise ->
        activationPromise

      runs ->
        expect(switcher.switch).toHaveBeenCalled()
