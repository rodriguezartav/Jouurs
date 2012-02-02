Spine = require('spine')

Article = require('models/article')
Hash_Category = require("models/hash_category")
Hash_Tag = require("models/hash_tag")
Hash_Categories = require("controllers/hash_categories")
User = require('models/user')


class Info_Page extends Spine.Controller
  className: "info_page"
  
  constructor: ->
    super
    @append new Hash_Categories

module.exports = Info_Page