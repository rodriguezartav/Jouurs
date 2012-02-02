Spine ?= require('spine')

class i18n
  String.prototype.i18n = -> 
    return i18n.translate(this.valueOf(), arguments)

  @translate: (key,args) =>
    value = @map[key]
    return key if Spine.locale == 0 or !value
    return value[Spine.locale - 1]

  
  @map =
    "Free" : "Libres"
    "Share the news!":  ["Comparta la noticia!"]
    "Optional: Describe the Link":  ["Opcional: Detalles del link"]
    "Don't worry if you don't want to type, we can pull the info from the link": ["De click en Submit si no quiere escribir, podemos obtener la informacion del link"]
    "The shorter the better":  ["Titulo Corto y Directo"]
    "Title":["Titulo"]
    "Why do you share it?":["Porque lo leriamos?"]
    "Copy the link url to the textfield before clicking on GO":["Copie el url del link antes de estripar el boton"]



module?.exports = i18n