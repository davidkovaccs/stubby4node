describe 'CLI', ->
   sut = null

   beforeEach ->
      sut = require('../src/cli')
      spyOn process, 'exit'
      spyOn sut, 'log'

   describe 'version', ->
      it 'should return the version of stubby in package.json', ->
         expected = require('../package.json').version

         actual = sut.version()

         expect(actual).toBe expected

   describe 'help', ->
      it 'should return help text', ->
         text = sut.help()

         expect(typeof text).toBe 'string'
         expect(text.length).not.toBe 0

   describe 'getArgs', ->
      describe '-a, --admin', ->
         it 'should return default if no flag provided', ->
            expected = 8889
            actual = sut.getArgs []

            expect(actual.admin).toBe expected

         it 'should return supplied value when provided', ->
            expected = 81
            actual = sut.getArgs ['-a', expected]

            expect(actual.admin).toBe expected

         it 'should return supplied value when provided with full flag', ->
            expected = 81
            actual = sut.getArgs ['--admin', expected]

            expect(actual.admin).toBe expected

      describe '-s, --stub', ->
         it 'should return default if no flag provided', ->
            expected = 8882
            actual = sut.getArgs []

            expect(actual.stub).toBe expected

         it 'should return supplied value when provided', ->
            expected = 80
            actual = sut.getArgs ['-s', expected]

            expect(actual.stub).toBe expected

         it 'should return supplied value when provided with full flag', ->
            expected = 80
            actual = sut.getArgs ['--stub', expected]

            expect(actual.stub).toBe expected

      describe '-l, --location', ->
         it 'should return default if no flag provided', ->
            expected = 'localhost'
            actual = sut.getArgs []

            expect(actual.location).toBe expected

         it 'should return supplied value when provided', ->
            expected = 'stubby.com'
            actual = sut.getArgs ['-l', expected]

            expect(actual.location).toBe expected

         it 'should return supplied value when provided with full flag', ->
            expected = 'stubby.com'
            actual = sut.getArgs ['--location', expected]

            expect(actual.location).toBe expected
      describe '-v, --version', ->
         it 'should exit the process', ->
            sut.getArgs(['--version'])
            expect(process.exit).toHaveBeenCalled()

         it 'should print out version info', ->
            version = require('../package.json').version

            sut.getArgs(['-v'])

            expect(sut.log).toHaveBeenCalledWith version

      describe '-h, --help', ->
         it 'should exit the process', ->
            sut.getArgs(['--help'])
            expect(process.exit).toHaveBeenCalled()

         it 'should print out help text', ->
            help = sut.help()

            sut.getArgs(['-h'])

            expect(sut.log).toHaveBeenCalledWith help

   describe 'data', ->
      expected = [
         request:
            url: '/testput'
            method: 'PUT'
            post: 'test data'
         response:
            headers:
               'content-type': 'text/plain'
            status: 404
            latency: 2000
            body: 'test response'
      ,
         request:
            url: '/testdelete'
            method: 'DELETE'
            post: null
         response:
            headers:
               'content-type': 'text/plain'
            status: 204
            body: null
      ]

      it 'should be about to parse json file with array', ->
         actual = sut.getArgs ['-d', 'spec/data/cli.getData.json']

         expect(actual.data).toEqual expected

      it 'should be about to parse yaml file with array', ->
         actual = sut.getArgs ['-d', 'spec/data/cli.getData.yaml']

         expect(actual.data).toEqual expected

   describe 'key', ->
      it 'should return contents of file', ->
         expected = 'some generated key'
         actual = sut.key 'spec/data/cli.getKey.pem'

         expect(actual).toBe expected

   describe 'cert', ->
      expected = 'some generated certificate'

      it 'should return contents of file', ->
         actual = sut.cert 'spec/data/cli.getCert.pem'

         expect(actual).toBe expected

   describe 'pfx', ->
      it 'should return contents of file', ->
         expected = 'some generated pfx'
         actual = sut.pfx 'spec/data/cli.getPfx.pfx'

         expect(actual).toBe expected


   describe 'getArgs', ->
      it 'should gather all arguments', ->
         expected = 
            data : 'a file'
            stub : 88
            admin : 90
            location : 'stubby.com'
            key: 'a key'
            cert: 'a certificate'
            pfx: 'a pfx'

         spyOn(sut, 'data').andReturn expected.data
         spyOn(sut, 'key').andReturn expected.key
         spyOn(sut, 'cert').andReturn expected.cert
         spyOn(sut, 'pfx').andReturn expected.pfx

         actual = sut.getArgs [
            '-s', expected.stub
            '-a', expected.admin
            '-d', 'anything'
            '-l', expected.location
            '-k', 'anything'
            '-c', 'anything'
            '-p', 'anything'
         ]

         expect(actual).toEqual expected
