P2P  = require "./p2p"
p2p  = new P2P
peer = p2p.join()

peer.on "open",(id)->
    console.log "my id is: ",id
    ChatItem = require './chatitem'

    # Let's create a simple view
    view = new KDView
      cssClass : "sample-view"
      partial  : "Hello KD Peer! "+id



    chatInput = new KDHitEnterInputView
        callback : ->
            controller.addItem
                title: @getValue()
            p2p.broadcast @getValue()
            @setFocus()
            @setValue ""


    editableInput = new KDInputView
        cssClass : "editable"
        type     : "textarea"
        # autogrow : yes
        callback : ->
            console.log arguments
        keyup : ->
            console.log arguments
        keydown: (e)->
            # log @$()
            log @getCaretPosition()
            # console.log e
            {type,keyCode} = e
            p2p.broadcast
                type : "event"
                data : {type,keyCode}


    controller = new KDListViewController
        itemClass   : ChatItem
        lastToFirst : yes

    # view.addSubView chatSendButton
    # view.addSubView chatInput
    view.addSubView editableInput
    view.addSubView controller.getView()




    # And append it to DOM
    KDView.appendToDOMBody view

