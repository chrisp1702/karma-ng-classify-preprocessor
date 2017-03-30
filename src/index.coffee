ngClassify = require 'ng-classify'
path = require 'path'
assign = require 'object-assign'

createNgClassifyPreprocessor = (args, config = {}, logger, helper) ->

  log = logger.create 'preprocessor.ng-classify'
  defaultOptions = {}
  options = helper.merge defaultOptions, args.options or {}, config.options or {}

  transformPath = args.transformPath or config.transformPath or (filepath) ->
    filepath.replace(/\.coffee$/, '.js')

  transformAppName = args.transformAppName or config.transformAppName

  (content, file, done) ->

    log.debug "Processing \"#{file.originalPath}\""
    file.path = transformPath file.originalPath

    opts = assign({}, options)

    options.appName = transformAppName(file.path) if transformAppName

    try
      result = ngClassify content, options
    catch e
      log.error "${e.message}\n  at #{file.originalPath}:#{e.location.first_line}"
      return done e, null

    if result.v3SourceMap
      map = JSON.parse result.v3SourceMap
      map.sources[0] = path.basename file.originalPath
      map.sourcesContent = [content]
      map.file = path.basename file.path
      file.sourceMap = map
      datauri = "data:application/json;charset=utf-8;base64,#{new Buffer(JSON.stringify map).toString 'base64'}"
      done null, result.js + "\n//@ sourceMappingURL=#{datauri}\n"
    else
      done null, result.js or result

createNgClassifyPreprocessor.$inject = [ 'args', 'config.ngClassifyPreprocessor', 'logger', 'helper' ]

module.exports = 'preprocessor:ng-classify': [ 'factory', createNgClassifyPreprocessor ]
