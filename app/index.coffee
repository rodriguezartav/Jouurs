require('lib/setup')
i18n = require('lib/i18n')
Spine = require('spine')
Editable_Plugin = require("lib/editable_plugin")
Lightbox = require('controllers/lightbox')
Header = require('controllers/header')
Articles = require('controllers/articles')
Hash_Tags = require('controllers/hash_tags')
Users = require('controllers/users')

Data_Hub = require('hubs/data')

User = require("models/user")
Article = require("models/article")
Hash_Tag = require("models/hash_tag")

class App extends Spine.Controller

  elements:
    "header"     : "header"
    ".hash_tags"  : "hash_tags"
    ".articles"   : "articles"
    ".users"      : "users"
    
  constructor: ->
    super
    editable_plugin = new Editable_Plugin(el: @el)
    Spine.locale = 0    
    Spine.Model.host = "http://localhost:9393"
    Spine.Route.setup(history: true)
    User.auth_object = @auth
    
    new Data_Hub 
    
    header = new Header(el: @header)
    hash_tags = new Hash_Tags(el: @hash_tags)
    articles = new Articles(el: @articles)
    users = new Users(el: @users)
    lightbox = new Lightbox()
    @append lightbox
    
    Spine.change_current_view = (view) =>
      isUser = view.indexOf("@") == 0
      Spine.current_view = {isUser: isUser , name: view}
      User.fetch(Spine.current_view , App.on_load_data_success, App.on_load_data_error)
      
    Spine.change_current_view if @view != '' then "@#{@view}" else "init"
   
  @on_load_data_success: (raw) =>
    Hash_Tag.current=null
    
    results = JSON.parse raw
    single= false
    articles = []
    
    if !Spine.isArray(results)     
      results = [results]
      User.reset_view_user()
      single= true

    for result in results
      user = User.create Username: result.Username , Name: result.Name
      articles = articles.concat result.Articles
      if single
        User.set_view_user user
        #TODO FIX THIS: USER TAKES CARE OF CHECKING AUTH
        User.set_auth_user user
  
    Spine.Ajax.disable =>
      Article.refresh  articles, {clear: true}
      
    Spine.trigger "current_view_changed"

  @on_load_data_error: (error) =>
    console.log error
    #if auth and view correspond, then create user.
    #Spine.trigger "show_lightbox" , "register_user" ,  
    
    # if auth is null, display user not found
    

module.exports = App
    