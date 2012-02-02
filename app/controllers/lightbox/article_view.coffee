Spine   = require('spine')
$       = Spine.$
Article = require('models/article')
User = require('models/user')
Link = require('models/link')

class Article_View extends Spine.Controller
  className: 'article_post reveal-modal'

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

module.exports = Article_View
