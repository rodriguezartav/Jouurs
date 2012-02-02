require('lib/setup')
Spine = require('spine')

Article = require('models/article')

User = require('models/user')

class Users extends Spine.Controller


  constructor: ->
    super
    Spine.bind "current_view_changed" , @render
    @render()

  render: =>
    @html require('views/users/user')(User.all())




module.exports = Users
