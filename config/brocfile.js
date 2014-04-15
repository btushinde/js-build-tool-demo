//
//  brocfile.js
//


var env = require('broccoli-env').getEnv()
var plugins = require('broccoli-load-plugins')()

function preprocess (tree) {
  tree = plugins.coffee(tree, {
    bare: true
  })
  tree = plugins.jade(tree, {})
  tree = plugins.stylus(tree, {})
  return tree
}

function processStyles (tree){
  tree = plugins.autoprefixer(tree, {})
  tree = plugins.uncss(tree, {
    html: ['index.html']
  })
  tree = plugins.csso(tree, {})
  return tree
}

function processTemplates (tree) {
  tree = plugins.htmlmin(tree)
  return tree
}


var assets = 'assets'

// JS
var jsFiles = plugins.staticCompiler(assets, {
  srcDir: '/js',
  destDir: 'js'
})
jsFiles = preprocess(jsFiles)
jsFiles = plugins.ngMin(jsFiles)

if (plugins.env.getEnv() === 'production') {
  jsFiles = plugins.closureCompiler(jsFiles, {
    externs: 'config/externs/angular-1.2.js'
  })
}


// CSS
var cssFiles = plugins.staticCompiler(assets, {
  srcDir: '/css',
  destDir: 'css'
})
cssFiles = preprocess(cssFiles)
cssFiles = processStyles(cssFiles)


// HTML
var templateFiles = plugins.staticCompiler(assets, {
  srcDir: '/templates',
  destDir: 'templates'
})
templateFiles = preprocess(templateFiles)
templateFiles = processTemplates(templateFiles)


// Public
var publicFiles = plugins.staticCompiler('public', {
  srcDir: '/',
  destDir: '/'
})
publicFiles = preprocess(publicFiles)
publicFiles = processTemplates(publicFiles)


// Bower Modules
var bowerFiles = plugins.staticCompiler('bower_components', {
  srcDir: '/',
  destDir: '/vendor'
})


var sourceTrees = [jsFiles, cssFiles, templateFiles, publicFiles, bowerFiles]
var appAndDependencies = new plugins.mergeTrees(sourceTrees, { overwrite: true })

module.exports = plugins.mergeTrees([appAndDependencies])





