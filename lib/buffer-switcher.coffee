{File} = require "atom"

module.exports =
class BufferSwitcher
  switch: ->
    @openSpecFile()

  openSpecFile: ->
    console.log("BufferSwitcher::openSpecFile")
