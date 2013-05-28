database = require('mongodb')

class Model
  class TypeError extends Error
  class ValidationError extends Error

  parseObject = (model, schema, validators, path = '') ->
    _model = {}
    for name, _schema of schema
      _model[name] = switch getType(_schema)
        when 'string' then parseString(model[name], _schema, validators, path + name)
        when 'object' then parseObject(model[name], _schema, validators, path + name + '.')
        when 'array' then parseArray(model[name], _schema[0], validators, path + name + '.')
    _model

  parseArray = (model, schema, validators, path = '') ->
    switch getType(schema)
      when 'string' then parseString(_model, schema, validators, path) for _model in model
      when 'object' then parseObject(_model, schema, validators, path) for _model in model
      when 'array' then parseArray(_model, schema, validators, path) for _model in model

  parseString = (model, schema, validators, path = '') ->
    # console.log "#{path} #{model}:#{schema}"
    for validator in validators[path] or []
      throw new ValidationError("Invalid #{path} - #{model}") unless validator(model)

    switch schema
      when 'ObjectId' then castObjectId(model)
      when 'String' then castString(model)
      when 'Date' then castDate(model)
      when 'Binary' then castBinary(model)
      when 'Long' then castLong(model)
      when 'Double' then castDouble(model)

  castObjectId = (objectId) ->
    switch getType(objectId)
      when 'string' then database.ObjectID(objectId)
      when 'number' then database.ObjectID(objectId)
      else throw new TypeError("Unable to cast #{getType(objectId)} as objectid")

  castString = (string) ->
    return string if getType(string) is 'string'
    return string.toString() if string.toString
    throw new TypeError("Unable to cast #{getType(string)} as string")

  castDate = (date) ->
    switch getType(date)
      when 'object' then new Date(date)
      when 'number' then new Date(date)
      when 'string' then new Date(Date.parse date)
      else
        return database.Timestamp() if date is Date.now
        throw new TypeError("Unable to cast #{getType(date)} as date")

  castBinary = (binary) ->
    switch getType(binary)
      when 'string' then database.Binary(binary)
      when 'buffer' then database.Binary(binary)
      else throw new TypeError("Unable to cast #{getType(binary)} as binary")

  castLong = (long) ->
    return database.Long(long) if getType(long) is 'number'
    throw new TypeError("Unable to cast #{getType(long)} as long")

  castDouble = (double) ->
    return database.Double(double) if getType(double) is 'number'
    throw new TypeError("Unable to cast #{getType(double)} as double")

  getType = (object) ->
    switch typeof object
      when 'number' then 'number'
      when 'string' then 'string'
      when 'object'
        return 'array' if Array.isArray(object)
        return 'buffer' if Buffer.isBuffer(object)
        'object'

  initCache = (base, object, array) ->
    base[object]        = base[object] or {}
    base[object][array] = base[object][array] or []

  @default: (selector, value) ->
    initCache(@, '_defaults', selector)
    @_defaults[selector].push(value)

  @validate: (selector, hook) ->
    initCache(@, '_validators', selector)
    @_validators[selector].push(hook)

  @hook: (action, hook) ->
    initCache(@, '_hooks', action)
    @_hooks[action].push(hook)

  save: ->
    defaults          = @constructor._defaults or []
    validators        = @constructor._validators or []
    before_save_hooks = @constructor._hooks?['beforeSave'] or []
    after_save_hooks  = @constructor._hooks?['afterSave'] or []

    hook(@) for hook in before_save_hooks

    toSave = parseObject(@, @constructor.schema, validators)

    hook(@) for hook in after_save_hooks

    toSave

class MyModel extends Model
  @schema =
    id: 'ObjectId'
    type: 'String'
    handle: 'String'
    names:[
      first: 'String'
      last: 'String'
    ]
    location: 'String'
    createdAt: 'Date'
    updatedAt: 'Date'

  @hook 'beforeSave', -> console.log 'beforeSave'
  @hook 'afterSave', -> console.log 'afterSave'

  @validate 'names.first', (firstName) -> firstName.match /Bob|Joe/

  testSave: ->
    @id        = '12a4bfe34a9f'
    @type      = 'twitter'
    @handle    = 'wkf'
    @names     = [
      {first: 'Bob', last: 'Hope'}
      {first: 'Joe', last: 'Glum'}
    ]
    @location  = 'Providence, RI'
    @createdAt = Date.now
    @updatedAt = Date.now

    @save()

console.log (new MyModel()).testSave()
