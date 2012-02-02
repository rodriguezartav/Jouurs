Spine   = require('spine')
$       = Spine.$
Article = require('models/article')
User = require('models/user')
Link = require('models/link')

class Article_Edit extends Spine.Controller
  className: 'article_post reveal-modal'

  events:
    "submit form" : "on_submit"
    "click .destroy.yes" : "on_destroy"

  constructor: ->
    super
    if @action == "destroy"
      @html require('views/lightbox/article_destroy')
    else
      @render(@data)
    
    
  render: (article) =>
    @html require('views/lightbox/article_post')(article)
  
  on_submit: (e) =>
     e.preventDefault()
     article = Article.fromForm(e.target)
     article.save()
     @html require('views/lightbox/article_post_success')

    
  on_destroy: (e) =>
    @data.destroy()
    Spine.trigger "hide_lightbox"


module.exports = Article_Edit