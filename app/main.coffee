yeoman = require('yeoman-generator')

class Generator extends yeoman.generators.Base

  # The name `constructor` is important here
  constructor: ->

    # Calling the super constructor is important so our generator is correctly setup
    yeoman.generators.Base.apply this, arguments

    @option "coffee" # This method adds support for a `--coffee` flag
    console.log "destination root:",@env.cwd
    @destinationRoot @env.cwd
    # console.dir @options

  method1: ->
    console.log "method 1 just ran"
    # console.dir Generator



  method2: ->
    console.log "method 2 just ran"
  promptTask: ->
    done = @async()
    @prompt
      type: "input"
      name: "name"
      message: "Install dir"
      default: @env.cwd+"/mykdapp"
    , (answers) =>
      @log "answer name",answers.name
      @destinationRoot answers.name
      @npmInstall ['express','node-eden','coffee-script'],{save:yes}, @async()
      @directory "static","static"
      @directory "server","server"
      @directory "app","app"
      done



module.exports = Generator
