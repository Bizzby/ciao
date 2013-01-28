ScriptParser = require 'lib/ScriptParser'
should = require 'should'
fs = require 'fs'

script01 = fs.readFileSync 'fixtures/script01.coffee'
script101 = fs.readFileSync 'fixtures/script101.coffee'

describe 'ScriptParser', ->

  describe 'constructor', ->

    it 'should parse the script in to lines', ->

      parser = new ScriptParser script01
      parser.lines.should.eql [ 'A', 'FILE' ]

    describe 'script101', ->

      parser = new ScriptParser script101, 'script101'

      it 'should create empty sections', ->

        parser.sections.junk.should.be.instanceOf Array
        parser.sections.auth.should.be.instanceOf Array
        parser.sections.request.should.be.instanceOf Array
        parser.sections.assert.should.be.instanceOf Array

      it 'should parse auth sections', ->

        parser.sections.auth[0].title.should.eql 'Requried Headers'
        parser.sections.auth[0].source.should.eql parser.lines[2]

        parser.sections.auth[1].title.should.eql 'Log in'
        parser.sections.auth[1].source.should.eql parser.lines[5]

      it 'should parse request sections', ->

        parser.sections.request[0].title.should.eql 'Register new user'
        parser.sections.request[0].source.should.eql parser.lines[8..17].join '\n'

        parser.sections.request[1].title.should.eql 'Foo Bar'
        parser.sections.request[1].source.should.eql parser.lines[20..21].join '\n'

      it 'should parse assert sections', ->

        parser.sections.assert[0].title.should.eql 'Status: 303 See other'
        parser.sections.assert[0].source.should.eql parser.lines[24]

        parser.sections.assert[1].title.should.eql 'Response header has a location /'
        parser.sections.assert[1].source.should.eql parser.lines[27]

        parser.sections.assert[2].title.should.eql 'Response.body should be empty'
        parser.sections.assert[2].source.should.eql parser.lines[30]

        parser.sections.assert[3].title.should.eql 'Should set a cookie'
        parser.sections.assert[3].source.should.eql parser.lines[33]