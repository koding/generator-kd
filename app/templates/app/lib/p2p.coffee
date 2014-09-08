DB          = require './db'
DOMListener = require './domlistener'
DMP         = require './diff_match_patch_uncompressed.js'
sjcl        = require './sjcl.js'
peer        = require './peer.js'
# textrange   = require './jquery-textrange.js'
_           = require './underscore-min.js'

# dmp = new DMP

# a = "This library is available in multiple languages. Regardless of the language used, the interface for using it is the same. This page describes the API for the public functions. For further examples, see the relevant test harness."
# b = "This library1 is available2 in multiple3 languages4 Regardless of the language used, the interface for using it is the same. This page describes the API for the public functions. For further examples, see the relevant test harness."

# # calculate the patch
# patch = dmp.patch_make(a,b)

# # convert to text for transmission
# ptext = dmp.patch_toText patch
# console.log ptext,ptext.length
# # convert text to patches object
# patches = dmp.patch_fromText(ptext)
# console.log (dmp.patch_apply patches,a)[0]
# console.log c = sjcl.encrypt "pass",a
# console.log d = sjcl.decrypt "pass",c



module.exports = class P2P

    connectedPeers = {}
    @db = new DB
    constructor: (options,callback)->
        @db = P2P.db
        @peerid = null
        @peer = null
        @peers = {}
        @throttledBroadcast = _.throttle(@broadcast, 50)

        @domlistener = new DOMListener().start()

        @domlistener.on "event",(data)->
            console.log data

        @db.on "update",(data)->
            # console.log data
            # traverse(data).paths().forEach (path)->
            #     console.log "updated: #{path}"

    join : (options,callback)->

        @peer = new Peer
            # key: "x7fwx2kavpy6tj4i"
            debug: 0
            host: window.location.hostname
            port: window.location.port
            path: "/-/ps"
            allow_discovery : yes

        console.log @peer


        @peer.on "open", (id) =>
            @peerid = id
            @fetchPeers {},(err,peers)=>
                console.log "peers:",peers
                @peers = peers
                @connectToPeers peers



        @peer.on "connection", (conn)->
            log "hello connection i'm #{conn.peer} and i'm now connected to you."

        @peer.on "error",(err)->
            if err.type is "unavailable-id"
                console.log "unavailable-id",arguments
            else if err.type is "socket-closed"
                console.log "||socket-closed||"
            else if err.type is "network"
                console.log "---> going down..."
                # after 3,location.reload.bind(location)
            console.log "--->", err.type

        @peer.on "close",->
            console.log "connection closed..."

        @peer.on "disconnect",->
            console.log "i am disconnected..."

        return @peer

    fetchPeers: (options,callback) ->
        $.ajax
          url: "/peers"
          # data: data
          dataType: "json"
          success: (data) ->
            callback null, data

    broadcastCount = 0
    lastBroadcast = Date.now()





    broadcast : (obj) ->
        # console.log "#{broadcastCount++} broadcasting:",obj

        obj      = {data : obj, type : "msg"} if typeof obj is "string"
        obj.peer = @peerid
        obj.path = window.location.pathname
        obj.dept = P2P.db.utcTime()

        # log "broadcasting", obj
        for peerid,peer of connectedPeers when peerid isnt @peerid
            # log "broadcasting to:", peerid
            if peer.send
                peer.send JSON.stringify obj
            else
                log "this #{peerid} is not for real.", peer

    connectToPeer : (requestedPeer)->

        unless connectedPeers[requestedPeer]
            c = @peer.connect requestedPeer,
                label         : "chat"
                serialization : "json"
                metadata      :
                    message   : "hi i want to chat with you!"

            c.on "open", ->
                console.log "connected to:", requestedPeer

            c.on "error", (err) ->
                console.log "err: #{requestedPeer}",err

            c.on "close", ->
                console.log  "#{c.peer} has left the chat."
                delete connectedPeers[c.peer]

            # connectedPeers[c.peer] = c
            # console.log connectedPeers

            connectedPeers[requestedPeer] = c

            # c.on "data", (msg) ->

            #     # console.log "-->",self
            #     # console.log "db",@db
            #     # publicChannel.append "<div><span class=\"peer\">" + c.peer + "</span>: " + data + "</div>"
            #     # console.log "received:",msg
            #     obj = JSON.parse msg
            #     # console.log  obj
            #     if typeof obj is "string"
            #         return console.log "plain string is arrived, not inserting to db" # or @peer is obj.peer

            #     console.log  obj

            #     if obj.type is "event"
            #         console.log "got #{obj.data.type} from:",obj.peer,"at:", obj.data.pageX, obj.data.pageY unless obj.data.type is "mousemove"

            #         switch obj.data.type
            #             when "mousemove"

            #                 $("body").append("<div class='pointer #{obj.peer}'>#{obj.peer}</div>") unless $(".pointer.#{obj.peer}").length

            #                 $(".pointer.#{obj.peer}").css
            #                     top : obj.data.pageY
            #                     left : obj.data.pageX

            #                 # $(".pointer.#{obj.peer}").animate
            #                 #     top : obj.data.pageY
            #                 #     left : obj.data.pageX
            #                 # ,100

            #             when "click"
            #                 a = 2
            #                 # a = $().trigger(obj.data.type,obj.peer)
            #                 clickedElement = document.elementFromPoint(obj.data.pageX, obj.data.pageY)
            #                 $(clickedElement).trigger("click",p2p.peerid)
            #                 console.log clickedElement

            #             when "focusin"
            #                 a = 2
            #                 # a = $().trigger(obj.data.type,obj.peer)
            #                 clickedElement = document.elementFromPoint(obj.data.pageX, obj.data.pageY)
            #                 console.log clickedElement

            #                 setTimeout ->
            #                     log 'triggerin focus'
            #                     $(clickedElement).trigger("focus", p2p.peerid)
            #                 , 10


            #     if obj.type is not "event"
            #         obj.arrv = P2P.db.utcTime()
            #         obj.lag  = obj.arrv - obj.dept
            #         P2P.db.set  obj
            #         console.log P2P.db.all()

                # scrollDown()



    connectToPeers : (peers)->
        console.log "connecting to:",peers
        for peer,info of @peers
            console.log "connecting to:",peer
            @connectToPeer(peer)






