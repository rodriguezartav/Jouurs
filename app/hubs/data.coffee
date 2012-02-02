require('lib/setup')
Spine = require('spine')
Article = require('models/article')
Hash_Tag = require('models/hash_tag')
Hash_Category = require('models/hash_category')
User = require('models/user')

class Data extends Spine.Controller

  constructor: ->
    super
    #Spine.bind "current_view_changed" , @create_hash_tags
    #Hash_Tag.bind "current_hash_tag_changed" , @create_hash_categories
    #Article.bind "update", @article_change

  article_change: (article) ->
    cat = Hash_Category.findByAttribute("Name", article.Category) || Hash_Category.create({Name: article.Category , Articles: []})
    cat.Articles.push article
    article.current_cat.Articles
    cat.save()

  create_hash_tags: ->
    hash_tags = {}
    for article in Article.all()
      hash_tag_name = article.Hash_Tag || ""
      hash_tag = hash_tags[hash_tag_name] || false
      hash_tag = { Name: hash_tag_name , Articles: [] } if hash_tag == false
      hash_tag.Articles.push article
      hash_tags[hash_tag_name] = hash_tag
    hash_array = []
    hash_array.push value for key,value of hash_tags
    Hash_Tag.refresh hash_array , {clear: true}
    Hash_Tag.trigger "hash_tags_created"
    Hash_Tag.set_current Hash_Tag.first()

  create_hash_categories: () ->
    hash_tag = Hash_Tag.current
    Hash_Category.each (hash) ->
      hash.destroy()
    hash_categories = {}
    for article in hash_tag.Articles
      field_value = article.Category || ""
      obj = hash_categories[field_value] || false
      obj = { Name: field_value , Articles: [] } if obj == false
      obj.Articles.push article
      hash_categories[field_value] = obj
    hash_array = []
    hash_array.push value for key,value of hash_categories
    hash_tag.Hash_Categories = hash_array
    hash_tag.save()
    Hash_Category.refresh hash_array , {clear: true}

module.exports = Data