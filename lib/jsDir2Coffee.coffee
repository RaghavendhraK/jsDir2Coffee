argv = require('minimist')(process.argv.slice(2));
logger = require './logger.coffee'

if typeof(argv['src']) == 'undefined'
    logger.log("Info", "--src Source directory is not provided")
    return
else 
    src = argv['src']

if typeof(argv['dest']) == 'undefined'
    logger.log("Info", "--dest Destination directory is not provided")
    return
else 
    dest = argv['dest']

fs = require 'fs-extra'

fs.exists(dest, (exists)->
    if !exists
        logger.log("Info", "Destination directory '#{dest}' not exists")
        return
    else 
        fs.exists(src, (exists)->
            if !exists
                logger.log("Info", "Source directory '#{src}' not exists")
                return
            else 
                isError = false
                recursiveConvertJs2Coffee(src)
                if (isError)
                    console.log "Error happened please see the log files for more information"

        )
)

path = require 'path'
getExtension = (filename) ->
    ext = path.extname(filename||'').split('.');
    return ext[ext.length - 1];

js2coffee = require 'js2coffee'
recursiveConvertJs2Coffee = (srcFile) ->
    if (fs.lstatSync(srcFile).isDirectory()) 
        fs.readdirSync(srcFile).forEach (file) ->
            recursiveConvertJs2Coffee(srcFile + '/' + file)
    else 
        destFile = srcFile.replace(src, dest)
        if (getExtension(srcFile) == 'js')
            try
                jsContents = fs.readFileSync(srcFile, 'utf-8')

                coffeeContent = js2coffee.build(jsContents)

                destFile = destFile.replace('.js', '.coffee')
                fs.ensureFileSync(destFile)
                fs.writeFileSync(destFile, coffeeContent)
                
                logger.log("Info", "Js2Coffee #{srcFile}")
            catch e
                if (!isError) isError = true
                logger.log("Error", "Error happened while converting #{srcFile}", e)           
        else
            logger.log("Info", "Direct Copy #{srcFile}")
            fs.copy(srcFile, destFile)
    return