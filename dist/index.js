var createNgClassifyPreprocessor, ngClassify, path;

ngClassify = require('ng-classify');

path = require('path');

createNgClassifyPreprocessor = function(args, config, logger, helper) {
  var defaultOptions, log, options, transformPath;
  if (config == null) {
    config = {};
  }
  log = logger.create('preprocessor.ng-classify');
  defaultOptions = {};
  options = helper.merge(defaultOptions, args.options || {}, config.options || {});
  transformPath = args.transformPath || config.transformPath || function(filepath) {
    return filepath.replace(/\.coffee$/, '.js');
  };
  return function(content, file, done) {
    var datauri, e, map, opts, result;
    log.debug("Processing \"" + file.originalPath + "\"");
    file.path = transformPath(file.originalPath);
    opts = helper._.clone(options);
    try {
      result = ngClassify(content, options);
    } catch (_error) {
      e = _error;
      log.error("${e.message}\n  at " + file.originalPath + ":" + e.location.first_line);
      return done(e, null);
    }
    if (result.v3SourceMap) {
      map = JSON.parse(result.v3SourceMap);
      map.sources[0] = path.basename(file.originalPath);
      map.sourcesContent = [content];
      map.file = path.basename(file.path);
      file.sourceMap = map;
      datauri = "data:application/json;charset=utf-8;base64," + (new Buffer(JSON.stringify(map)).toString('base64'));
      return done(null, result.js + ("\n//@ sourceMappingURL=" + datauri + "\n"));
    } else {
      return done(null, result.js || result);
    }
  };
};

createNgClassifyPreprocessor.$inject = ['args', 'config.ngClassifyPreprocessor', 'logger', 'helper'];

module.exports = {
  'preprocessor:ng-classify': ['factory', createNgClassifyPreprocessor]
};
