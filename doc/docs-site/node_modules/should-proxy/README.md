#should-proxy

should-proxy uses a no_proxy list formatted like so
`localhost,127.0.0.0/8,10.0.0.0/8,192.168.0.0/16,172.16.0.0/12,.internal.com`
To determine if a url should be proxied or not.

should-proxy is a function that takes a url as well as options.
If no options are provided should-proxy uses the environment variable `no_proxy`

Usage
---

```javascript
var shouldProxy = require('should-proxy');

var result = shouldProxy("http://something.google.com/", {
  no_proxy: "google.com"
});
// Should be false, because google.com is on the no_proxy list provided
console.log("http://something.google.com/", result);

result = shouldProxy("http://localhost/", {
  no_proxy: ""
});
// Should be true, because localhost is not the no_proxy list provided
console.log("http://localhost/", result);

// Omitting the options object will cause should-proxy
// to use process.env["no_proxy"]
```
