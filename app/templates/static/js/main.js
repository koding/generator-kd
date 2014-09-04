(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var b, chatInput, chatSendButton, controller, view;

b = require("./p2p");

b();

view = new KDView({
  cssClass: "sample-view",
  partial: "It works!",
  click: function() {
    return console.log("yo");
  }
});

chatInput = new KDInputView;

chatSendButton = new KDButtonView({
  title: "Send",
  callback: function() {
    return controller.addItem({
      title: chatInput.getValue()
    });
  }
});

controller = new KDListViewController;

view.addSubView(controller.getView());

KDView.appendToDOMBody(view);



},{"./p2p":2}],2:[function(require,module,exports){
module.exports = function() {
  return "hello world!";
};



},{}]},{},[1])