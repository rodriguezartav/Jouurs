Spine = require('spine')

class Article extends Spine.Model
  @configure 'Article' , "Title" , "Description" , "Url" , "Votes" , 
  "Thumb" , "Owner" , "Hash_Tag" ,"Category" , "Order" , "Hash_Tag_Ref" , "Hash_Category_Ref"
  @extend Spine.Model.Ajax


  constructor: ->
    super
    @Hash_Tag = @Hash_Tag or  ""


module.exports = Article