#
# brocfile.coffee
#

env = require('broccoli-env').getEnv()
plugins = require('broccoli-load-plugins')()

preprocess = (tree) ->
  tree = plugins.coffee(tree, {bare: true})
  tree = plugins.jade(tree)
  tree = plugins.stylus(tree)
  tree

processStyles = (tree) ->
  tree = plugins.autoprefixer(tree)
  tree = plugins.csso(tree)
  tree

processTemplates = (tree) ->
  tree = plugins.htmlmin(tree)
  tree


assets = 'assets'

# JS
jsFiles = plugins.staticCompiler(assets,
  srcDir: '/js'
  destDir: 'js'
)
jsFiles = preprocess(jsFiles)
jsFiles = plugins.ngMin(jsFiles)
if plugins.env.getEnv() is 'production'
  jsFiles = plugins.closureCompiler(jsFiles,
    externs: 'config/externs/angular-1.2.js'
  )

# CSS
cssFiles = plugins.staticCompiler(assets,
  srcDir: '/css'
  destDir: 'css'
)
cssFiles = preprocess(cssFiles)
cssFiles = processStyles(cssFiles)

# HTML
templateFiles = plugins.staticCompiler(assets,
  srcDir: '/templates'
  destDir: 'templates'
)
templateFiles = preprocess(templateFiles)
templateFiles = processTemplates(templateFiles)

# Public
publicFiles = plugins.staticCompiler('public',
  srcDir: '/'
  destDir: '/'
)
publicFiles = preprocess(publicFiles)
publicFiles = processTemplates(publicFiles)

# Bower Modules
bowerFiles = plugins.staticCompiler('bower_components',
  srcDir: '/'
  destDir: '/vendor'
)

sourceTrees = [
  jsFiles
  cssFiles
  templateFiles
  publicFiles
  bowerFiles
]

module.exports = plugins.mergeTrees(sourceTrees, {overwrite: true})