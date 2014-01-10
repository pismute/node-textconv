###

node-textconv
https://github.com/pismute/node-textconv

Copyright (c) 2014+ Changwoo Park
Licensed under the MIT license.

###

'use strict'
fs = require('fs')
path = require('path')
os = require('os')
wn = require('when')
nodefn = require("when/node/function")
callbacks = require("when/callbacks")
mkdirp = require('mkdirp')

difftool = (cmd, local, remote)->
  #console.log( "difftool: #{JSON.stringify arguments, '  ', false}")

  which(cmd)
    .then (result)->
      cmd = result
      wn.join(
        difftool.textconv(local)
          .catch ()-> local #failed to textconv
      ,
        difftool.textconv(remote)
          .catch ()-> remote #failed to textconv
      )
    .then (filenames)->
      cmdString = "\"#{cmd}\" \"#{filenames[0]}\" \"#{filenames[1]}\""
      #console.log("#{cmdString}")
      exec(cmdString)
    .catch (error)->
      #console.log("error:#{cmd} not found:#{error}")
      exit(error.code)
    .done ()->
      exit(0)

textconv = (src)->
  tmpdir = os.tmpdir()
  filename = path.basename(src)
  textconvFilename = path.resolve(tmpdir, src + '.textconv')

  exec("git check-attr diff #{filename}")
    .then (result)->
      driver = /diff: (.+)/.exec(result)[1]

      if driver is "unspecified"
        wn.reject(new Error("'git check-attr diff #{filename}' returns: unspecified"))
      else
        exec("git config diff.#{driver}.textconv")
    .then (cmd)->
      #console.log("#{cmd.trim()} #{src}")
      exec("#{cmd.trim()} #{src}")
    .then (data)->
      #console.log("mkdirp #{path.dirname(textconvFilename)}")
      nodefn.call(mkdirp, path.dirname(textconvFilename))
        .then ()->
          #console.log("fs.writeFile #{textconvFilename}")
          nodefn.call(fs.writeFile, textconvFilename, data)
    .then ()->
      #console.log("textconved #{textconvFilename}")
      textconvFilename

exit = (exitCode)->
  if process.stdout._pendingWriteReqs or process.stderr._pendingWriteReqs
    process.nextTick ()-> exit(exitCode)
  else
    process.exit(exitCode)

which = (name)->
  if which.preset[name] and which.preset[name][os.platform()]
    maybe = Array::slice.call(which.preset[name][os.platform()])
  else
    maybe = []

  maybe.push(name)

  for cmd in maybe
    if fs.existsSync(cmd)
      return wn.resolve(cmd)

  wn.reject("#{name} is not found")

which.preset =
  diffmerge:
    darwin: ["/Applications/DiffMerge.app/Contents/MacOS/diffmerge"]
    linux: ["/usr/bin/diffmerge"]
    win32: [
      "C:/Program Files/SourceGear/Common/DiffMerge/sgdm.exe"
      "C:/Program Files (x86)/SourceGear/Common/DiffMerge/sgdm.exe"
    ]

exec = (cmd)->
  deffered = wn.defer()

  require('child_process').exec cmd, (error, stdin, stderr)->
    if error
      if stderr and stderr.length > 0
        #console.error("#{cmd}'s stderr: #{stderr}")
        error.stderr = stderr

      deffered.reject(error)
    else
      deffered.resolve(stdin)

  deffered.promise

difftool.exec = exec
difftool.textconv = textconv
difftool.which = which

## exit code
module.exports = difftool
