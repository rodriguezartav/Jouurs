mongoose = require("mongoose")

# hardcoded for now
mongoose.connect('mongodb://rodriguezartav:monomono@staff.mongohq.com:10038/contacts')

port =  process.env.PORT || 3000

express = require('express')
app = express.createServer()
app.use(express.bodyParser())
app.use(express.logger())

# setting up Hem manually rather than use the server option
# so we can add things to our express server
if process.env.NODE_ENV != "production"
  Hem = require("hem")
  hem = new Hem()
  app.get(hem.options.cssPath, hem.cssPackage().createServer())
  app.get(hem.options.jsPath, hem.hemPackage().createServer())

app.use(express.static("./public"))

# mongoose-rest gives us restful route for our mongoose models
mongooseRest = require("mongoose-rest")
mongooseRest.use(app, mongoose)

require "spine/lib/ajax"
Contact = require("./app/models/contact")

spineGoose = require("./lib/mongoose-spine")
spineGoose.mountModel(app, Contact)
  
app.listen(port)

