User = require("models/user")
Spine ?= require('spine')
$      = Spine.$
Model  = Spine.Model

Include = 
  update_field: (field,value) ->
    item = @
    old_value = item[field]
    item[field] = value
    item.save()
    @after_field_change?(field,old_value,value)
    @constructor.trigger "after_update"

    
Model.Editable =
  extended: ->
    @include Include

class Editable_Plugin extends Spine.Controller
  events:
    "click .editable" : "on_editable_click"
    "focusout .editable>input" : "on_editable_edited"

  constructor: ->
    super
    @models = {}

  on_key_up: (e) ->
    target = $(e.target)
    e.stopImmediatePropagation()
    target.blur()
    return false

  on_editable_click: (e) ->
    target = $(e.target).parent()
    return false if target.attr("data-read-only") or !User.can_edit() 
    target.addClass "editing"

  on_editable_edited: (e) =>
    e.stopImmediatePropagation()
    
    text_input = $(e.target)
    text_input.data = ""
    target = text_input.parent()
    @log e

    itemId = target.attr "data-id"
    itemType = target.attr "data-type"
    itemField = target.attr "data-field"
    itemNewValue = text_input.val()
    itemUpdateLabel = target.attr("data-update-label") or false     

    model = @models[itemType] or require("models/#{itemType}")
    @models[itemType] = model
    item = model.find(itemId)

    item.update_field(itemField,itemNewValue)
    target.find(".label").html item[itemField] if itemUpdateLabel
    target.removeClass "editing"
    return false
    
module.exports= Editable_Plugin