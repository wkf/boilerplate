module.exports = (app) ->
  class UserModel extends app.Model
    @collection: 'users'
    @schema:
      id: 'ObjectId'
      type: 'String'
      handle: 'String'
      name:
        first: 'String'
        last: 'String'
      location: 'String'
      createdAt: 'Date'
      updatedAt: 'Date'

    @default 'type', 'twitter'

    @validate 'name.first', (firstName) -> firstName.match /name/
    @validate 'name.last', (lastName) -> lastName.match /name/

    @findOrCreateFromTwitterProfile: (profile) ->
    @findOrCreateFromFacebookProfile: (profile) ->

