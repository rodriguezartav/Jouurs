Spine = require('spine')

Article = require("models/article")

class Hash_Tag extends Spine.Model
  @configure 'Hash_Tag' , "Name" , "Articles", "Hash_Categories"
  @extend Spine.Model.Editable

  @current= null
  
  @set_current: (hash_tag) ->
    return false if !hash_tag
    @current = hash_tag
    Hash_Tag.trigger "current_hash_tag_changed"

  @first_or_free: ->
    first = Hash_Tag.first() || {Name: "" , Articles: []}
    return first
    

  after_field_change: (field,old_value,new_value) ->
    if field =="Name"
      @relocate_articles(old_value,new_value)
      @bulk_update(old_value,new_value)

  relocate_articles: ( old_value , new_value ) =>
    Spine.Ajax.disable =>
      for article in Article.findAllByAttribute( "Hash_Tag" , old_value )
        article.Hash_Tag = @Name
        article.save()

  bulk_update: (old_value,new_value) ->
    console.log "callind ajax" + @Name
    
    data=
      new_value: new_value
      old_value: old_value
      user_name: "rodriguezartav"
      
    $.ajax(
      url:  Spine.Model.host + "/articles/Hash_Tag",
      data: data
      type: "POST"
    )

module.exports = Hash_Tag