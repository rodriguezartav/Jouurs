require('lib/setup')
Spine = require('spine')

Article = require('models/article')
User = require('models/user')
Link = require('models/link')

class PostBar extends Spine.Controller
  className: "container postbar"
  
  elements:
    "input"     :  "url"

  events:
    "click .button" : "on_click"
  
  constructor: ->
    super
    @html require('views/postbar/anonymous')

  on_click: (e) =>
    if @disabled then return false
    return @show_error() if @url.val().length < 10
    @el.addClass  "disabled"
    @disabled = true
    @get_page_info @url.val()  
      
  get_page_info: () =>
    Link.create Url: @url.val() ,Owner: User.current.Name
    Link.bind "ajaxSuccess" , @on_info_response
    Link.bind "ajaxError" , @on_send_error

    
  on_info_response: (link)  =>
    @enable()
    @url.val ""
    @log link
    @log link.isLink
    Link.unbind "ajaxSuccess" , @on_info_response
    Link.unbind "ajaxError" , @on_send_error
    Spine.trigger "show_lightbox" , "article_post"

  on_send_error: (error) =>
    @enable()
    Link.unbind "ajaxSuccess" , @on_info_response
    Link.unbind "ajaxError" , @on_send_error
    @log arguments
    alert "URL IS NOT VALID"
   
  show_error: =>
   alert("Copy the link url to the textfield before clicking on GO".i18n())
  
  disable: =>
   @disabled = true
   @el.addClass  "disabled"

   
  enable: =>
    @disabled = false
    @el.removeClass  "disabled"
    
   
module.exports = PostBar
