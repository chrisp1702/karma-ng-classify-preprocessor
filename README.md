# karma-ng-classify-preprocessor

> Preprocessor to complie ng-classify on the fly.

## Installation

Can be simply done through `npm`:

```
npm install karma-ng-classify-preprocessor --save-dev
```

## Configuration
This is the default configuration..
```js
module.exports = function(config) {
  config.set({
    preprocessors: {
     '**/*.coffee': ['ng-classify']
    },
    ngClassifyPreprocessor: {
      // options passed to ng-classify
      options: {
	// any options supported by ng-classify
	// https://github.com/CaryLandholt/ng-classify#api
        sourceMap: false
      },
      transformPath: function(path) {
        return path.replace(/\.coffee$/, '.js');
      },
      transformAppName: function(path) {
      	// function to change app name determined by path
        // this function will overwrite the `appName` option
      	return 'app';
      }
    }
  });
}
```

If you set the `sourcemap` option to `true` then the generated source map will be inlined as a data-uri.

---
Credit to the [karma-coffee-preprocessor] for example on writing this plugin.

[karma-coffee-preprocessor]: https://github.com/karma-runner/karma-coffee-preprocessor
