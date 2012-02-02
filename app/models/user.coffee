Spine = require('spine')
Article = require("models/article")

class User extends Spine.Model
  @configure 'User' , "Name" , "Username"
  @extend Spine.Model.Ajax.Methods

  @view_user = null
  @auth_user = null
  @auth_object = null
  
  @can_edit: ->
    return false if @view_user == null or @auth_user == null
    if @view_user?.Username == @auth_user?.Username
      return true
    return false
  
  @reset_view_user: ->
    @view_user = null
  
  @set_view_user: (user) ->
    @view_user = user
    @trigger "view_user_changed"

  @set_auth_user: (user) ->
    if user.Username == @auth_object and @auth_user == null
      @auth_user = user
      @trigger "auth_user_changed"  

  @fetch: (view , on_success,on_error) ->
    url = User.url()
    if view.isUser
      url += "/" + view.name.replace("@","")
    else
      url += "?view=#{view.name}"
    
    $.ajax(
      url: url,
      type: "GET"
    ).success(on_success)
     .error(on_error)

  to_timestamp: ->
    @Name + '_' + new Date().getTime();

module.exports = User