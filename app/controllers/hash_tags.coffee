require('lib/setup')
Spine = require('spine')

User = require('models/user')
Article = require('models/article')
Hash_Tag = require('models/hash_tag')

class Hash_Tags extends Spine.Controller
 
  elements:
   ".list" : "list"
   "input" : "input"
 
  events:
    "change input" : "on_create"
    "click dd" : "on_hash_tag_click"
 
  constructor: ->
    super
    Article.bind "refresh" , @prepare_tags
    Hash_Tag.bind "after_update" , @prepare_tags

  prepare_tags: =>
    Hash_Tag.each (hash) ->
      hash.destroy()
    hash_tags = {}
    for article in Article.all()
      hash_tag_name = article.Hash_Tag || ""
      hash_tag = hash_tags[hash_tag_name] || false
      hash_tag = { Name: hash_tag_name } if hash_tag == false
      hash_tags[hash_tag_name] = hash_tag

    hash_array = []
    hash_array.push value for key,value of hash_tags
    Hash_Tag.refresh hash_array , {clear: true}
    Hash_Tag.refresh hash_array , {clear: true}
    Hash_Tag.set_current Hash_Tag.first_or_free() if Hash_Tag.current == null
    @render()

  render: =>
    if Hash_Tag.count > 0 or User.can_edit()
      @html require ('views/hash_tags/layout')
      @input.show() if User.can_edit()
      @list.html require('views/hash_tags/item')(Hash_Tag.all() )

  on_hash_tag_click: (e) =>
    target = $(e.target).parent()
    tag = target.item()
    Hash_Tag.set_current tag

  on_create: (e) =>
    target = $(e.target)
    val = target.val()
    Hash_Tag.create Name: val , Articles: []
    target.val ''

module.exports = Hash_Tags
