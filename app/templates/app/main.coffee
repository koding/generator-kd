# b = require "./p2p"
# b()

# Let's create a simple view
view = new KDView
  cssClass : "sample-view"
  partial  : "It works!"+b()
  click    : ->
    console.log "yo"



chatInput = new KDInputView

chatSendButton = new KDButtonView
    title:"Send"
    callback : ->
        controller.addItem
            title: chatInput.getValue()

controller = new KDListViewController

view.addSubView controller.getView()



# And append it to DOM
KDView.appendToDOMBody view

