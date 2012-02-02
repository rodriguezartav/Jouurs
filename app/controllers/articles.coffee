Spine = require('spine')

Article = require('models/article')
Hash_Category = require("models/hash_category")
Hash_Tag = require("models/hash_tag")
Hash_Categories = require("controllers/hash_categories")
User = require('models/user')


class Viewbox extends Spine.Controller
  className: "category_list"
  
  constructor: ->
    super
    @append new Hash_Categories

class Articles extends Spine.Controller

  elements: 
    ".breadcrum_text" : "breadcrum_text"
    ".breadcrum_div>a" : "add_category_button"

  constructor: ->
    super
    @html new Viewbox
    
  on_click: (e) =>
    target = $(e.target).parents('.article_container')
    @log target
    item_id = target.attr 'data-id'
    item = Article.find item_id
    Spine.trigger "show_lightbox" , "article_edit" , { data: item , action: "" }

module.exports = Articles