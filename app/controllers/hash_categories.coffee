require('lib/setup')
Spine = require('spine')

Article = require('models/article')
Hash_Category = require("models/hash_category")
Hash_Tag = require("models/hash_tag")

User = require('models/user')


class Hash_Category_Item extends Spine.Controller

  events:
    "click .article_container" : "on_click"

  constructor: ->
    super
    throw "@hash_category required" unless @hash_category
    @hash_category.bind "change", @render
    @hash_category.bind "destroy", @remove

  remove: =>
    @el.remove()  

  render: =>
    @html require("views/hash_categories/item")(@hash_category)
    @

  on_click: (e) =>
    target = $(e.target).parents('.article_container')
    item_id = target.attr 'data-id'
    item = Article.find item_id
    Spine.trigger "show_lightbox" , "article_edit" , { data: item , action: "" }
    


class Hash_Categories extends Spine.Controller

  events:
    "click .add_category" : "on_add_category"
    "click .article_container" : "on_click"

  constructor: ->
    super
    Hash_Category.bind("create",  @addOne)
    Hash_Category.bind "after_update" , @refresh
    Hash_Tag.bind "current_hash_tag_changed" , @refresh

  refresh: =>    
    hash_tag = Hash_Tag.current
    Hash_Category.each (hash) ->
      hash.destroy()
    hash_categories = {}
    for article in Article.findAllByAttribute("Hash_Tag" , hash_tag.Name )
      field_value = article.Category || ""
      obj = hash_categories[field_value] || false
      obj = { Name: field_value, Articles: []  } if obj == false
      obj.Articles.push article
      hash_categories[field_value] = obj
    hash_array = []
    hash_array.push value for key,value of hash_categories
    Hash_Category.refresh hash_array , {clear: true}
    @render()
    
  render: ->
    @html require('views/hash_categories/layout')(Hash_Tag.current)
    Hash_Category.each(@addOne)

  on_click: (e) =>
     target = $(e.target).parents('.article_container')
     item_id = target.attr 'data-id'
     item = Article.find item_id
     Spine.trigger "show_lightbox" , "article_edit" , { data: item , action: "" }

  addOne: (cat) =>
    @append require("views/hash_categories/item")(cat)

  on_add_category: =>
    cat = Hash_Category.create {Name: "New" , Articles: []}
    
    

module.exports = Hash_Categories