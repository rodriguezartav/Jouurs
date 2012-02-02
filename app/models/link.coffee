Spine = require('spine')

class Link extends Spine.Model
  @configure 'Link' , "Url" , "Title" , "Thumb" , "Description" , "Owner" , "isLink"
  
  @extend Spine.Model.Ajax



 
module.exports = Link