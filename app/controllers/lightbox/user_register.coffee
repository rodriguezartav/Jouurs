Spine   = require('spine')
$       = Spine.$
Article = require('models/article')
User = require('models/user')
Link = require('models/link')

class User_Register extends Spine.Controller
  className: 'user_register reveal-modal'

  events:
    "submit form" : "on_submit"
  
  constructor: ->
    super
    Link.bind "update" , @render
  
  render: (link) =>
    @html require('views/lightbox/article_post')(link)
  
  on_submit: (e) =>
     e.preventDefault()
     article = Article.fromForm(e.target)
     article.save()
     @html require('views/lightbox/article_post_success')

module.exports = User_Register
