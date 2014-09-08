
module.exports = class DB extends KDEventEmitter
    Db  =
        strings  : []
        objects  : []
        arrays   : []
        messages : []


    mergeRecursive = (obj1, obj2) ->
      for p of obj2
        try

          # Property in destination object set; update its value.
          if obj2[p].constructor is Object
            obj1[p] = mergeRecursive(obj1[p], obj2[p])
          else
            obj1[p] = obj2[p]
        catch e

          # Property in destination object not set; create it and set its value.
          obj1[p] = obj2[p]
      return obj1


    utcTime : ->
        now = new Date
        return Date.UTC(now.getUTCFullYear(),now.getUTCMonth(), now.getUTCDate(), now.getUTCHours(), now.getUTCMinutes(), now.getUTCSeconds(), now.getUTCMilliseconds())


        # try
        #     json = JSON.parse data
        #     # db = _.extend db,json
        #     {name,type,path,data} = json

        #     if type is "json"
        #         db[name].data = mergeRecursive db[name].data,data

        #     # dbnew = traverse(db).set(path.split("."),data)
        #     # db = dbnew if dbnew
        #     # @emit "update",path
        # catch err
        #     console.log "cannot set. invalid json.",err

    set : (obj)->

        obj.arrv = @utcTime()


        Db.messages.push obj
        # @updateView()
        @emit "set",obj
        return obj

    all : -> JSON.stringify Db,null,2

    updateView : (div) ->
        scrollDown = ->
            a = document.getElementById("general")
            a.scrollTop = a.scrollHeight

        scrollDown()
        $("#general").html("<div><pre><code class='javascript'>"+@all()+"</pre></code></div>")


