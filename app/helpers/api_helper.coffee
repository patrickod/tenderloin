url = Caboose.get('UrlHelper')
Organization = Caboose.get('Organization')

exports.ensure_logged_in = (next) ->
    return @respond_json(401, {error: 'Unauthorized'}) unless @is_logged_in()
    next()

exports.fetch_organization = (params_key) ->
  (next) ->
    if @request.api_key?
      Organization.where(api_key: @request.api_key).first (err, org) =>
        return @error(err) if err?
        return @respond_json(401, {error: 'Invalid API key'}) unless org?
        @organization = org
        next()
    else
      exports.ensure_logged_in.call @, =>
        return next() unless @params[params_key]?
        Organization.where(_id: url.decode(@params[params_key]), users: @current_user._id).first (err, org) =>
          return next(err) if err?
          @organization = org
          next()

exports.fetch_room = (next) ->
  exports.fetch_organization('organizations_id').call @, =>
    @organization.room(@params.rooms_id || @params.id).first (err, room) =>
      return next(err) if err?
      @room = room
      next()
