mongoose = require("mongoose")
mongooseRest = require("mongoose-rest")
lingo = lingo = require('lingo').en

addUserToBody = (req, res, next) ->
  req.body.user = req.user if req.user?
  console.log req.user?.username
  next()
  
exports.mountModel = (app, model) ->
  schemaAttrs = {}
  for attr in model.attributes
    schemaAttrs[attr] = String
  schema = new mongoose.Schema(schemaAttrs)
  mongoose.model model.className, schema
  mongooseRest.use(app, mongoose)
  pluralClassName = lingo.pluralize(model.className)
  routes = mongooseRest.routes()[pluralClassName]
  app.get "/#{pluralClassName.toLowerCase()}.:format?", routes.index
  app.post "/#{pluralClassName.toLowerCase()}", routes.create
  app.get "/#{pluralClassName.toLowerCase()}/:#{model.className.toLowerCase()}", routes.show
  app.put "/#{pluralClassName.toLowerCase()}/:#{model.className.toLowerCase()}", routes.update
  app.del "/#{pluralClassName.toLowerCase()}/:#{model.className.toLowerCase()}", routes.destroy
    