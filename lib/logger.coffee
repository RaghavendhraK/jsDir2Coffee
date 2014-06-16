fs = require 'fs-extra'
filename = __dirname + '/../logs/log.txt'

logger = module.exports 

logger.log = (level, message, errDetails) ->
  date = new Date
  message = date.toUTCString() + ':' + level + ':' + message
  console.log message
  if level == 'Error'
    fs.ensureFile(filename, ->
      fs.appendFile(filename, message + '\n' + errDetails + '\n', (err) ->
        if (err)
          console.log "Error happened whil logging: #{err}"
      )
    )
  return