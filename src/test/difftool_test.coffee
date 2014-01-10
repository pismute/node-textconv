'use strict'

{exec, textconv, which, find} = require '../lib/difftool'

###
======== A Handy Little Mocha Reference ========
https://github.com/visionmedia/should.js
https://github.com/visionmedia/mocha

Mocha hooks:
  before ()-> # before describe
  after ()-> # after describe
  beforeEach ()-> # before each it
  afterEach ()-> # after each it

Should assertions:
  should.exist('hello')
  should.fail('expected an error!')
  true.should.be.ok
  true.should.be.true
  false.should.be.false

  (()-> arguments)(1,2,3).should.be.arguments
  [1,2,3].should.eql([1,2,3])
  should.strictEqual(undefined, value)
  user.age.should.be.within(5, 50)
  username.should.match(/^\w+$/)
j
  user.should.be.a('object')
  [].should.be.an.instanceOf(Array)

  user.should.have.property('age', 15)

  user.age.should.be.above(5)
  user.age.should.be.below(100)
  user.pets.should.have.length(5)

  res.should.have.status(200) #res.statusCode should be 200
  res.should.be.json
  res.should.be.html
  res.should.have.header('Content-Length', '123')

  [].should.be.empty
  [1,2,3].should.include(3)
  'foo bar baz'.should.include('foo')
  { name: 'TJ', pet: tobi }.user.should.include({ pet: tobi, name: 'TJ' })
  { foo: 'bar', baz: 'raz' }.should.have.keys('foo', 'bar')

  (()-> throw new Error('failed to baz')).should.throwError(/^fail.+/)

  user.should.have.property('pets').with.lengthOf(4)
  user.should.be.a('object').and.have.property('name', 'tj')
###

os = require 'os'
path = require 'path'

require('when/monitor/console')

describe "difftool's", ()->
  describe 'exec', ()->
    it 'should grap out the stdout from cmd', (done)->
      exec('node --version')
        .then (stdout)->
          stdout.trim().should.be.eql(process.version)
          done()
    it 'should grap out error', (done)->
      exec('isnotnode')
        .catch (error)->
          #console.log( JSON.stringify error, '  ', false)
          error.code.should.not.be.eql(0)
          done()
  describe 'which', ()->
    describe 'should', ()->
      it 'find src directory', (done)->
        which('src')
          .then (result)->
            done()
      it 'not find nothing-command', (done)->
        which('nothing-command')
          .catch (error)->
            done()
  describe 'textconv', ()->
    it 'should binary filename to text filename', (done)->
      textconv('src/test/data/the-attorney.xlsx')
        .then (result)->
          expected = path.resolve(os.tmpdir(), 'src/test/data/the-attorney.xlsx.textconv')
          result.should.be.eql(expected)
          done()
