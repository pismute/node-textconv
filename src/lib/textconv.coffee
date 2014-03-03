###

node-textconv
https://github.com/pismute/node-textconv

Copyright (c) 2014+ Changwoo Park
Licensed under the MIT license.

###

'use strict'

fs = require('fs')
sheetJs = require('xlsx')

xlsx = (mixed, cb = xlsx.defaultCallback)->
  workbook = xlsx.parse(mixed)

  workbook.SheetNames.forEach (name)-> xlsx.sheet2md(workbook, name, cb)

xlsx.parse = (mixed)-> sheetJs.readFile(mixed)

xlsx.defaultCallback = (err, data)-> console.log(data)

xlsx.sheet2md = (workbook, name, cb)->
  worksheet = workbook.Sheets[name]

  cb(null, "### #{name}\n" )
  cb(null, "``` csv\n" )
  cb(null, sheetJs.utils.make_csv(worksheet) )
  cb(null, "```\n" )

exports.xlsx = xlsx
