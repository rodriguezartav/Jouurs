require('lib/setup')
Spine = require('spine')
Article = require('models/article')
User = require('models/user')
Link = require('models/link')

class Header extends Spine.Controller

  constructor: ->
    super
    Spine.bind "current_view_changed" , @render
    @render()
  
  render: =>
    auth_user = User.auth_user
    if auth_user == null
      @html require('views/header/anonymous')
    else
      @html require('views/header/user')(auth_user)

module.exports = Header
