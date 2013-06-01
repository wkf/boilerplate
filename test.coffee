$      = require('when')
fs     = require('fs')
mongo  = require('mongodb')
# rename will
defer  = require('deferrable')($)
stream = require('stream')


server    = new mongo.Server('localhost', 27017)
connector = new mongo.Db('test_database', server)


# write
write = ->
  connector.defer('open').then (db) ->
    id   = new mongo.ObjectID()
    file = new mongo.GridStore db, id, 'w',
      metadata:
        name: 'test_file.txt'

    file.defer('open')
    .then (store) ->
      store.defer('write', 'Test data!!')
      .then (result) ->
         console.log id
      .then ->
        store.defer('close')
    .fail (error) ->
      console.log

# read
read = (id) ->
  connector.defer('open').then (db) ->
    file = new mongo.GridStore db, mongo.ObjectID.createFromHexString(id), 'r'

    file.defer('open')
    .then (store) ->
      console.log file.metadata
      store.defer('read').then (result) ->
        console.log result.toString()
      .then ->
        store.defer('close')
    .fail (error) ->
      console.log

# write()
# read('51a954683005b821ed000001')



# mongo.Db('mixlair_development', mongo.Server('localhost', 27017)).open (e, db) => @db = db
# # @db.collection 'users', (e, c) => @c = c
# # @c.save { id: 13501222, provider: 'twitter' }, (e, r) => @r = r



# class GridStream extends require('stream').Stream

class GridStoreReadableStream extends stream.Readable
  constructor: (store, options = {}) ->
    @_store  = store
    @_cursor = 0
    @_offset = options.offset or 0
    @_length = options.length or store.length
    @_chunk  = options.chunk or 1024 * 16

    @_readable = true

    @_store.seek @_offset, (error) =>
      return @_error(error) if error
      @_ready = true
      @_more() if @_asked

    super {}

  _read: (size) ->
    return unless @_readable
    if not @_ready
      @_asked = true
    else unless @_reading
      @_more()

  _more: (size) ->
    amount = Math.min(size or @_chunk, @_chunk, @_length - @_cursor)
    @_store.read amount, (error, buffer) =>
      return console.log('ERROR - ', error) if error

      done = (@_cursor += amount) >= @_length
      more = @push(buffer)

      @push(null) if done
      @_reading = false unless more
      @_more(Math.max(size - amount,0)) if more and not done

  _error: (error) ->
    @_readable = false
    console.log('ERROR - ', error)

class GridStoreWritableStream extends stream.Writable
  constructor: (store, options = {}) ->
    @_store = store
    super {}

  _write: (chunk, encoding, callback) ->
    @_store.write chunk, (error, result) => callback(error)


readStream = (id) ->
  connector.defer('open').then (db) ->
    file = new mongo.GridStore db, mongo.ObjectID.createFromHexString(id), 'r'

    file.defer('open').then (store) ->
      readStream = new GridStoreReadableStream(store)
      writeStream = fs.createWriteStream('./bear2.png')

      readStream.pipe(writeStream)

      writeStream.on 'finish', ->
        console.log('done')

        # console.log stream.read(1).toString()

writeStream = ->
  connector.defer('open').then (db) ->
    id   = new mongo.ObjectID()
    file = new mongo.GridStore db, id, 'w',
      metadata:
        name: 'test_file.txt'

    console.log id

    file.defer('open').then (store) ->
      writeStream = new GridStoreWritableStream(store)
      readStream = fs.createReadStream('./bear.png')

      readStream.pipe(writeStream)

      writeStream.on 'finish', ->
        file.defer('close').then ->
          console.log('done')


readStream('51a971c95c2f6301f2000001')
# writeStream()


#console.log fs.createReadStream('./bear.png')










