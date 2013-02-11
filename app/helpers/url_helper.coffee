exports.encode = (v) -> encodeURIComponent(v).replace(/\./g, '-')
exports.decode = (v) -> decodeURIComponent(v.replace(/-/g, '.'))
