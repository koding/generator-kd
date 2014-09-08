
module.exports = class DOMListener extends KDEventEmitter

    start: ->

        browserEvents = [
            "abort"
            "afterprint"
            "beforeprint"
            "beforeunload"
            "blur"
            "canplay"
            "canplaythrough"
            "change"
            "click"
            "contextmenu"
            "copy"
            "cuechange"
            "cut"
            "dblclick"
            "DOMContentLoaded"
            "drag"
            "dragend"
            "dragenter"
            "dragleave"
            "dragover"
            "dragstart"
            "drop"
            "durationchange"
            "emptied"
            "ended"
            "error"
            "focus"
            "focusin"
            "focusout"
            "formchange"
            "forminput"
            "hashchange"
            "input"
            "invalid"
            "keydown"
            "keypress"
            "keyup"
            "load"
            "loadeddata"
            "loadedmetadata"
            "loadstart"
            "message"
            "mousedown"
            "mouseenter"
            "mouseleave"
            "mousemove"
            "mouseout"
            "mouseover"
            "mouseup"
            "mousewheel"
            "offline"
            "online"
            "pagehide"
            "pageshow"
            "paste"
            "pause"
            "play"
            "playing"
            "popstate"
            "progress"
            "ratechange"
            "readystatechange"
            "redo"
            "reset"
            "resize"
            "scroll"
            "seeked"
            "seeking"
            "select"
            "show"
            "stalled"
            "storage"
            "submit"
            "suspend"
            "timeupdate"
            "undo"
            "unload"
            "volumechange"
            "waiting"
        ]

        i=0

        $(document).on browserEvents.join(" "),(e, peerid=null)=>
            # e.stopPropagation()
            # console.log "event from:",peerid
            {pageX, pageY, type} = e
            # console.log "event:",type

            if typeof pageX is 'undefined'
                # log 'pagex yoktu ben geldim'
                pageY = e.target?.offsetTop
                pageX = e.target?.offsetLeft



            if peerid is null and type in ["mousemove","click", "focus", "focusin"]

                @emit "event",
                    type : "event"
                    data : { type, pageX, pageY }

            return yes





