

# Underscore's Template Module
# Courtesy of underscorejs.org

# By default, Underscore uses ERB-style template delimiters, change the
# following template settings to use alternative delimiters.

# When customizing `templateSettings`, if you don't want to define an
# interpolation, evaluation or escaping regex, we need one that is
# guaranteed not to match.

# Certain characters need to be escaped so that they can be put into a
# string literal.

# JavaScript micro-templating, similar to John Resig's implementation.
# Underscore templating handles arbitrary delimiters, preserves whitespace,
# and correctly escapes quotes within interpolated code.

# Combine delimiters into one regular expression via alternation.

# Compile the template source, escaping string literals appropriately.

# If a variable is not specified, place data values in local scope.

# Provide the compiled function source as a convenience for precompilation.
redirect = ->
  location.href = location.href.replace("tastejs.github.io/todomvc", "todomvc.com")  if location.hostname is "tastejs.github.io"
  return
findRoot = ->
  base = undefined
  [
    /labs/
    /\w*-examples/
  ].forEach (href) ->
    match = location.href.match(href)
    base = location.href.indexOf(match)  if not base and match
    return

  location.href.substr 0, base
getFile = (file, callback) ->
  return console.info("Miss the info bar? Run TodoMVC from a server to avoid a cross-origin error.")  unless location.host
  xhr = new XMLHttpRequest()
  xhr.open "GET", findRoot() + file, true
  xhr.send()
  xhr.onload = ->
    callback xhr.responseText  if xhr.status is 200 and callback
    return

  return
Learn = (learnJSON, config) ->
  return new Learn(learnJSON, config)  unless this instanceof Learn
  template = undefined
  framework = undefined
  if typeof learnJSON isnt "object"
    try
      learnJSON = JSON.parse(learnJSON)
    catch e
      return
  if config
    template = config.template
    framework = config.framework
  template = learnJSON.templates.todomvc  if not template and learnJSON.templates
  framework = document.querySelector("[data-framework]").getAttribute("data-framework")  if not framework and document.querySelector("[data-framework]")
  if template and learnJSON[framework]
    @frameworkJSON = learnJSON[framework]
    @template = template
    @append()
  return
"use strict"
_ = ((_) ->
  _.defaults = (object) ->
    return object  unless object
    argsIndex = 1
    argsLength = arguments_.length

    while argsIndex < argsLength
      iterable = arguments_[argsIndex]
      if iterable
        for key of iterable
          object[key] = iterable[key]  unless object[key]?
      argsIndex++
    object

  _.templateSettings =
    evaluate: /<%([\s\S]+?)%>/g
    interpolate: /<%=([\s\S]+?)%>/g
    escape: /<%-([\s\S]+?)%>/g

  noMatch = /(.)^/
  escapes =
    "'": "'"
    "\\": "\\"
    "\r": "r"
    "\n": "n"
    "\t": "t"
    "": "u2028"
    "": "u2029"

  escaper = /\\|'|\r|\n|\t|\u2028|\u2029/g
  _.template = (text, data, settings) ->
    render = undefined
    settings = _.defaults({}, settings, _.templateSettings)
    matcher = new RegExp([
      (settings.escape or noMatch).source
      (settings.interpolate or noMatch).source
      (settings.evaluate or noMatch).source
    ].join("|") + "|$", "g")
    index = 0
    source = "__p+='"
    text.replace matcher, (match, escape, interpolate, evaluate, offset) ->
      source += text.slice(index, offset).replace(escaper, (match) ->
        "\\" + escapes[match]
      )
      source += "'+\n((__t=(" + escape + "))==null?'':_.escape(__t))+\n'"  if escape
      source += "'+\n((__t=(" + interpolate + "))==null?'':__t)+\n'"  if interpolate
      source += "';\n" + evaluate + "\n__p+='"  if evaluate
      index = offset + match.length
      match

    source += "';\n"
    source = "with(obj||{}){\n" + source + "}\n"  unless settings.variable
    source = "var __t,__p='',__j=Array.prototype.join," + "print=function(){__p+=__j.call(arguments,'');};\n" + source + "return __p;\n"
    try
      render = new Function(settings.variable or "obj", "_", source)
    catch e
      e.source = source
      throw e
    return render(data, _)  if data
    template = (data) ->
      render.call this, data, _

    template.source = "function(" + (settings.variable or "obj") + "){\n" + source + "}"
    template

  _
)({})
if location.hostname is "todomvc.com"
  window._gaq = [
    [
      "_setAccount"
      "UA-31081062-1"
    ]
    ["_trackPageview"]
  ]
  ((d, t) ->
    g = d.createElement(t)
    s = d.getElementsByTagName(t)[0]
    g.src = "//www.google-analytics.com/ga.js"
    s.parentNode.insertBefore g, s
    return
  ) document, "script"
Learn::append = ->
  aside = document.createElement("aside")
  aside.innerHTML = _.template(@template, @frameworkJSON)
  aside.className = "learn"

  # Localize demo links
  demoLinks = aside.querySelectorAll(".demo-link")
  Array::forEach.call demoLinks, (demoLink) ->
    demoLink.setAttribute "href", findRoot() + demoLink.getAttribute("href")
    return

  document.body.className = (document.body.className + " learn-bar").trim()
  document.body.insertAdjacentHTML "afterBegin", aside.outerHTML
  return

redirect()
getFile "learn.json", Learn

