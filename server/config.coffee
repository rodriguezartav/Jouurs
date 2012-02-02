express = require 'express'
sys     = require 'sys'
Hem     = require 'hem'
eco     = require 'eco'

module.exports = (app,twitter) ->
  app.use express.logger()
  app.use express.bodyParser()
  app.use express.cookieParser()
  app.use express.session secret: 'saimiri_australianus'
  app.set 'views'        , './server/views'
  app.set 'view engine'  , 'eco'
  app.use app.router
   
  app.use twitter.middleware
    consumerKey: "LfVyGdaDNRoUNG89TOtyFQ" 
    consumerSecret: "LUCPMMHsa9ofNETzSZ621WgL7M23nv9GAOOS3wRu14"
    baseURL: 'http://localhost:9294'
    logging: true
    afterLogin: '/after_login'
    afterLogout: '/after_logout'
  
  hem = new Hem()
  app.get(hem.options.cssPath, hem.cssPackage().createServer())
  app.get(hem.options.jsPath, hem.hemPackage().createServer())
  app.use(express.static("./public"))