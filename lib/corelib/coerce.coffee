# Singleton class for type coercion inside RubyJS.
#
# to_int(obj) converts obj to R.Fixnum
#
# to_int_native(obj) converts obj to a JS number primitive through R(obj).to_int() if not already one.
#
# There is a shortcut for Coerce.prototype: CoerceProto.
#
#     CoerceProto.to_num_native(1)
#
# @private
class Coerce
  # TODO: replace class with some more lightweight.

  # Mimicks rubys single block args behaviour
  single_block_args: (args, block) ->
    if block
      if block.length != 1
        if args.length > 1 then _slice_.call(args) else args[0]
      else
        args[0]
    else
      if args.length != 1 then _slice_.call(args) else args[0]


  # @example
  #      __coerce_to__(1, 'to_int')
  coerce: (obj, to_what, skip_native) ->
    if skip_native isnt undefined and skip_native is typeof obj
      obj
    else
      if obj is null or obj is undefined
        throw new R.TypeError.new()

      obj = R(obj)

      unless obj[to_what]?
        throw RubyJS.TypeError.new("TypeError: cant't convert ... into String")

      if skip_native isnt undefined
        obj[to_what]().to_native()
      else
        obj[to_what]()


  # Coerces element to a Number primitive.
  #
  # Throws error if typecasted RubyJS object is not a numeric.
  to_num_native: (obj) ->
    if typeof obj is 'number'
      obj
    else
      obj = R(obj)
      throw RubyJS.TypeError.new() if !obj.is_numeric?
      obj.to_native()


  to_int: (obj) ->
    @coerce(obj, 'to_int')


  to_int_native: (obj) ->
    if typeof obj is 'number' && (obj % 1 is 0)
      obj
    else
      @coerce(obj, 'to_int').to_native()


  to_str: (obj) ->
    @coerce(obj, 'to_str')


  to_str_native: (obj) ->
    @coerce(obj, 'to_str', 'string')


  to_ary: (obj) ->
    @coerce(obj, 'to_ary')


CoerceProto = Coerce.prototype
R.CoerceProto = Coerce.prototype