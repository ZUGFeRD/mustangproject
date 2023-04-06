var expect = require('expect.js');
var shouldProxy = require('..');

// Sets properties to true or false based on shouldProxy
function checkObject(urlList, options) {
  console.log();
  console.log(urlList);
  console.log(options);
  for (var url in urlList) {
    urlList[url] = shouldProxy(url, options);
    console.log(url, urlList[url]);
  }
  return urlList;
}

var tests = {
  subdomain: function () {
    var urlList = {
      "http://google.com/": null,
      "http://something.google.com/": null
    };
    // First try with subdomain
    var options = {
      no_proxy: "localhost,127.0.0.0/8,.something.google.com"
    };
    // Check the urls
    urlList = checkObject(urlList, options);
    // Expects
    expect(urlList["http://google.com/"]).to.equal(true);
    expect(urlList["http://something.google.com/"]).to.equal(false);
    // Now try with only domain
    options = {
      no_proxy: "localhost,127.0.0.0/8,.google.com"
    };
    // Check the urls
    urlList = checkObject(urlList, options);
    // Expects
    expect(urlList["http://google.com/"]).to.equal(false);
    expect(urlList["http://something.google.com/"]).to.equal(false);
  },
  ip: function () {
    var urlList = {
      "http://127.0.0.1/": null,
      "http://192.168.0.1/": null,
      "http://192.100.0.1/": null
    };
    // First try with subdomain
    var options = {
      no_proxy: "127.0.0.0/8,192.168.0.0/16"
    };
    // Check the urls
    urlList = checkObject(urlList, options);
    // Expects
    expect(urlList["http://127.0.0.1/"]).to.equal(false);
    expect(urlList["http://192.168.0.1/"]).to.equal(false);
    expect(urlList["http://192.100.0.1/"]).to.equal(true);
    // Now try with only domain
    options = {
      no_proxy: "192.100.0.0/16"
    };
    // Check the urls
    urlList = checkObject(urlList, options);
    // Expects
    expect(urlList["http://127.0.0.1/"]).to.equal(true);
    expect(urlList["http://192.168.0.1/"]).to.equal(true);
    expect(urlList["http://192.100.0.1/"]).to.equal(false);
  },
  hostname: function () {
    var urlList = {
      "http://localhost/": null
    };
    // First try with subdomain
    var options = {
      no_proxy: ""
    };
    // Check the urls
    urlList = checkObject(urlList, options);
    // Expects
    expect(urlList["http://localhost/"]).to.equal(true);
    // Now try with only domain
    options = {
      no_proxy: "localhost"
    };
    // Check the urls
    urlList = checkObject(urlList, options);
    // Expects
    expect(urlList["http://localhost/"]).to.equal(false);
  },
};

// Run all tests
for (var func in tests) {
  tests[func]();
}
