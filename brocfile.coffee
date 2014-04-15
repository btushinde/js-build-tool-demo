# ###
# brocfile.coffee
# ###



#=============================================
# Load Modules
#=============================================
filterCoffeeScript =  require('broccoli-coffee')
mergeTrees =          require('broccoli-merge-trees')
env =                 require('broccoli-env').getEnv()
findBowerTrees =      require('broccoli-bower')


plugins =             require('broccoli-load-plugins')()

var filterCoffeeScript = require('broccoli-coffee')
var filterTemplates = require('broccoli-template')
var uglifyJavaScript = require('broccoli-uglify-js')
var mergeTrees = require('broccoli-merge-trees')
var findBowerTrees = require('broccoli-bower')
var env = require('broccoli-env').getEnv()


#=============================================
# Config
#=============================================
app = 'app'
publicFiles = 'public'
styles = 'styles'
tests = 'tests'
vendor = 'vendor'

# compileCoffee = (tree) ->
#   tree = plugins.coffee(tree,
#     bare: true
#   )

# compileJade = (tree) ->
#   tree = plugins.jade(tree)


preprocess = (tree) ->
  # tree = plugins.jade(tree)
  tree = plugins.templates(tree, {
    extensions: ['hbs', 'handlebars'],
    compileFunction: 'Ember.Handlebars.compile'
  })
  tree = plugins.coffee(tree, {
    bare: true
  })
  tree

# App Files
app = plugins.staticCompiler(app,
  srcDir: '/'
  destDir: 'appkit' # move under appkit namespace
)
app = preprocess(app)


# Style Files
# styles = plugins.staticCompiler(styles,
#   srcDir: '/'
#   destDir: 'appkit'
# )
# styles = preprocess(styles)



# Test Files
# tests = plugins.staticCompiler(tests,
#   srcDir: '/'
#   destDir: 'appkit/tests'
)
# tests = preprocess(tests)





# Combine trees
sourceTrees = [
  app
  # styles
  # vendor
]
# sourceTrees.push tests  if env isnt 'production'
# sourceTrees = sourceTrees.concat(findBowerTrees())

appAndDependencies = new mergeTrees(sourceTrees,
  overwrite: true
)



#---------------------------------------------
# JS
#---------------------------------------------
appJs = appAndDependencies
appCss = plugins.stylus(sourceTrees, 'appkit/app.styl', 'assets/app.styl')
# appJs = uglifyJavaScript(appJs, {})  if env is 'production'


module.exports = mergeTrees([
  appJs
  appCss
  publicFiles
])