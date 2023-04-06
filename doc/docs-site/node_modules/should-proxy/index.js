var url = require('url');

function matchDomain(hostname, no_proxy) {
  var hostnameArray = hostname.split(".");
  // Remove any empty elements from the no_proxy
  var no_proxyArrayWithBlanks = no_proxy.split(".");
  var no_proxyArray = [];
  // Get rid of the trailing 0's so we match the broadest subnet
  for (var i = 0; i < no_proxyArrayWithBlanks.length; i++) {
    if (no_proxyArrayWithBlanks[i] === "") {
      continue;
    }
    no_proxyArray.push(no_proxyArrayWithBlanks[i]);
  }
  // Match in reverse order, all of the no_proxy should match
  // So that subdomains work
  // for example
  // [ 'something', 'internal', 'com' ] [ '', 'interal', 'com' ]
  // match
  // [ 'something', 'external', 'com' ] [ '', 'interal', 'com' ]
  // no match
  // [ 'something', 'internal', 'com' ] [ 'other', 'interal', 'com' ]
  // no match
  var matchedAll = no_proxyArray.length;
  var matches = 0;
  // Where to start matching
  var hostnameIndex = hostnameArray.length - 1;
  // Where to start matching
  var no_proxyIndex = no_proxyArray.length - 1;
  // Count all the matched numbers
  while (hostnameIndex > -1 && no_proxyIndex > -1) {
    if (hostnameArray[hostnameIndex] === no_proxyArray[no_proxyIndex]) {
      ++matches;
    }
    --hostnameIndex;
    --no_proxyIndex;
  }
  // If its the amount we needed then yes it is in the network
  if (matchedAll == matches) {
    return true;
  }
  // Ips didnt match its not in the network
  return false;
}

function matchNetwork(ip, network) {
  // This is lazy because we ignore whats after the slash
  // But hey at least we have no_proxy now right
  network = network.split("/")[0];
  // Make some arrays of numbers to match
  var ipArray = ip.split(".");
  var networkArrayWithZeros = network.split(".");
  var networkArray = [];
  // Get rid of the trailing 0's so we match the broadest subnet
  for (var i = 0; i < networkArrayWithZeros.length; i++) {
    if (networkArrayWithZeros[i] === "0") {
      break;
    }
    networkArray.push(networkArrayWithZeros[i]);
  }
  // The length of the networkArray without zeros is the number
  // of numbers that need to match, for example
  // ip: [ '192', '168', '0', '1' ] network: [ '192', '168' ]
  // match
  // ip: [ '192', '169', '0', '1' ] network: [ '192', '168' ]
  // no match
  // ip: [ '127', '0', '0', '1' ] network: [ '127' ]
  // match
  var matchedAll = networkArray.length;
  var matches = 0;
  // Count all the matched numbers
  for (var i = 0; i < ipArray.length && i < networkArray.length; i++) {
    if (ipArray[i] === networkArray[i]) {
      ++matches;
    }
  }
  // If its the amount we needed then yes it is in the network
  if (matchedAll == matches) {
    return true;
  }
  // Ips didnt match its not in the network
  return false;
}

function getNoProxy(options) {
  var no_proxy = "";
  if (typeof options !== "undefined") {
    if (typeof options["no_proxy"] !== "undefined") {
      no_proxy = options["no_proxy"];
    }
  } else if (typeof process.env["no_proxy"] !== "undefined") {
    no_proxy = process.env["no_proxy"];
  }
  return no_proxy.split(",");
}

function matchNoProxy(requestUrl, no_proxy) {
  var parsedUrl = url.parse(requestUrl);
  var hostname = parsedUrl.hostname;
  // If the hostname is null then dont proxy, we cant check
  if (hostname == null) {
    return false;
    // If the hostname is the no_proxy then its a match
  } else if (hostname === no_proxy) {
    return true;
    // If the ip matches a no_proxy subnet
  } else if (matchNetwork(hostname, no_proxy)) {
    return true;
    // If the host matches a domain / subdomain
  } else if (matchDomain(hostname, no_proxy)) {
    return true;
  }
  return false;
}

function shouldProxy(requestUrl, options) {
  // Get the no_proxy list
  var no_proxy = getNoProxy(options);
  // There is no no_proxy list so proxy everything
  if (no_proxy.length < 1 || no_proxy[0].length < 1) {
    return true;
  }
  // There is a no_proxy list so check if this should be proxied
  for (var i = 0; i < no_proxy.length; i++) {
    // If the requestUrl matches the no_proxy string return false
    // meaning should not proxy
    if (matchNoProxy(requestUrl, no_proxy[i])) {
      return false;
    }
  }
  // Url did not match no_proxy list so do proxy
  return true;
}

module.exports = shouldProxy;
