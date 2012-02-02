Spine = require('spine')



class Hash_Category extends Spine.Model
  @configure 'Hash_Category' , "Name" , "Articles"
  @extend Spine.Model.Editable

  after_field_change: (field,old_value,new_value) ->
    if field == "Name"
      @relocate_articles(new_value)
      @bulk_update old_value,new_value

  relocate_articles: (new_category) =>
    Spine.Ajax.disable =>
      for article in @Articles
        article.Category = @Name
        article.save()

  bulk_update: (old_value,new_value) ->
     console.log "callind ajax" + @Name

     data=
       new_value: new_value
       old_value: old_value
       user_name: "rodriguezartav"

     $.ajax(
       url:  Spine.Model.host + "/articles/Category",
       data: data
       type: "POST"
     )

module.exports = Hash_Category