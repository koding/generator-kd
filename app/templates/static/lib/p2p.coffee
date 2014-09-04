

class P2P

    connectedPeers = {}

    constructor: (options,callback)->
        @db = new DB
        @peerid = null
        @peer = null
        @peers = {}
        @throttledBroadcast = _.throttle(@broadcast, 50)

        @db.on "update",(data)->
            console.log data
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
            MY_ID = id
            log {MY_ID}
            @peerid = id
            $("#pid").text "hi "+id
            @fetchPeers {},(err,peers)=>
                console.log "peers:",peers
                @peers = peers
                @connectToPeers peers



        @peer.on "connection", @connect

        @peer.on "error",(err)->
            if err.type is "unavailable-id"
                console.log "unavailable-id",arguments
            else if err.type is "socket-closed"
                console.log "||socket-closed||"
            else if err.type is "network"
                console.log "---> going down..."
                after 3,location.reload.bind(location)
            console.log "--->", err.type

        @peer.on "close",->
            console.log "connection closed..."

        @peer.on "disconnect",->
            console.log "i am disconnected..."

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
        for _peerid,_peer of connectedPeers when _peer.send and obj.peer isnt _peerid
            _peer.send JSON.stringify obj

    connectToPeer : (requestedPeer)->
        unless connectedPeers[requestedPeer]
            c = @peer.connect requestedPeer,
                label         : "chat"
                serialization : "json"
                metadata      :
                    message   : "hi i want to chat with you!"

            c.on "open", => @connect c,requestedPeer
            c.on "error", (err) -> alert err

        connectedPeers[requestedPeer] = 1

    connectToPeers : (peers)->
        console.log "connecting to:",peers
        for peer,info of @peers
            console.log "connecting to:",peer
            @connectToPeer(peer)


    connect : (c) ->

        c.on "data", (msg) ->


            # console.log "db",@db
            # publicChannel.append "<div><span class=\"peer\">" + c.peer + "</span>: " + data + "</div>"
            # console.log "received:",msg
            obj = JSON.parse msg

            return  if MY_ID is obj.peer

            console.log "got #{obj.data.type} from:",obj.peer,"at:", obj.data.pageX, obj.data.pageY unless obj.data.type is "mousemove"

            if obj.type is "event"

                switch obj.data.type
                    when "mousemove"

                        $("body").append("<div class='pointer #{obj.peer}'>#{obj.peer}</div>") unless $(".pointer.#{obj.peer}").length

                        $(".pointer.#{obj.peer}").css
                            top : obj.data.pageY
                            left : obj.data.pageX

                        # $(".pointer.#{obj.peer}").animate
                        #     top : obj.data.pageY
                        #     left : obj.data.pageX
                        # ,100

                    when "click"
                        a = 2
                        # a = $().trigger(obj.data.type,obj.peer)
                        clickedElement = document.elementFromPoint(obj.data.pageX, obj.data.pageY)
                        $(clickedElement).trigger("click",p2p.peerid)
                        console.log clickedElement

                    when "focusin"
                        a = 2
                        # a = $().trigger(obj.data.type,obj.peer)
                        clickedElement = document.elementFromPoint(obj.data.pageX, obj.data.pageY)
                        console.log clickedElement

                        setTimeout ->
                            log 'triggerin focus'
                            $(clickedElement).trigger("focus", p2p.peerid)
                        , 10


            else
                @db.set
                    peer : obj.peer
                    dept : obj.dept
                    arrv : @db.utcTime()
                    path : obj.path
                ,obj.data

            # scrollDown()

        c.on "close", ->
            console.log  "#{c.peer} has left the chat."
            delete connectedPeers[c.peer]

        connectedPeers[c.peer] = c
        # console.log connectedPeers


