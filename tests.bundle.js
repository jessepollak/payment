var context = require.context('./spec', true, /.+\.spec\.(js|coffee)?$/)
context.keys().forEach(context)
module.exports = context
