###

node-textconv
https://github.com/pismute/node-textconv

Copyright (c) 2014+ Changwoo Park
Licensed under the MIT license.

###

'use strict'

fs = require('fs')
sheetJs = require('xlsx')
_ = require('lodash')

xlsx = (mixed, cb = xlsx.defaultCallback)->
  if _.isArray( mixed )
    mixed.forEach (file)->
      xlsx(file, if mixed.length > 1 then _.partialRight(cb, file) else cb)
  else
    workbook = xlsx.parse(mixed)

    workbook.SheetNames.forEach (name)-> xlsx.sheet2md(workbook, name, cb)

xlsx.parse = (mixed)-> sheetJs.readFile(mixed)

xlsx.defaultCallback = (err, data, context)->
  console.log(if context then "#{context}:#{data}" else data)

xlsx.sheet2md = (workbook, name, cb)->
  worksheet = workbook.Sheets[name]

  cb(null, "### #{name}\n" )
  cb(null, "``` csv\n" )
  sheetJs.utils.make_csv(worksheet).split('\n').forEach (line)-> cb(null, line)
  cb(null, "```\n" )

exports.xlsx = xlsx
