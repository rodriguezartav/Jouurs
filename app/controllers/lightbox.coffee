Spine         =  require('spine')
$             =  Spine.$
Article_Edit  =  require('controllers/lightbox/article_edit')

class Lightbox extends Spine.Controller
  className: 'lightbox reveal-modal-bg'

  elements:
    ".content" : "content"
    ".loader" : "loader"
    ".alert-box" : "alert_box"
    
  events:
    "click .close-reveal-modal" : "hide"
    "click .close" : "hide"
    
  constructor: ->
    super
    @el.hide()
    Spine.bind "show_lightbox" , @show
    Spine.bind "hide_lightbox" , @hide

    
  show: ( type , options={} ) =>
    @current = new Article_Edit(options) if type == "article_edit"
    @el.show()
    @html @current
    
  hide: =>
    @current.release()
    @el.hide()

module.exports = Lightbox