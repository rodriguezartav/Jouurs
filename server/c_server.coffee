express          = require 'express'
sys              = require 'sys'
http             = require 'http'
twitter          = require './twitter_wrapper'

app     = express.createServer()
require('./config')(app,twitter)

app.get '/', (req, res) ->
  res.redirect("/" + req.session.twitter.name) if req.session.twitter
  res.render 'index' , title: "ok"

app.get '/login', (req, res) ->
  twitter.login(req,res)

app.get '/:view', (req, res) ->
  #check for existance
  res.render 'index', view: req.params.view , auth: req.session.twitter?.name


app.listen 9294
console.log "Listening on Port 9294"