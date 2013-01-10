moment = require('moment')
{spawn} = require('child_process')

module.exports = {
    collections:
        projects: (database) ->
            database.findAllLive({type: 'project'}, {date: -1})
        posts: (database) ->
            database.findAllLive({type: 'post'}, {date: -1})
    templateData:
        site:
            name: 'bitaesthetics'
            nav: [['projects', '/']
                  ['blog', '/blog.html']
                  ['about', '/pages/about.html']]
        moment: moment

    events:
        render: (opts, next) ->
            if opts.inExtension == 'png' and opts.outExtension == 'png'
                {fullPath} = opts.file.attributes

                args = '-gravity Center -crop 1440x400+0+0 +repage'

                cp = spawn('convert', args.split(' ').concat([fullPath, '-']))
                chunks = []
                size = 0
                cp.stdout.on 'data', (chunk) ->
                  chunks.push(chunk)
                  size += chunk.length

                cp.on 'close', ->
                  buffer = new Buffer(size)
                  i = 0
                  for chunk in chunks
                    chunk.copy buffer, i, 0, chunk.length
                    i += chunk.length
                  opts.content = buffer
                  next()

            else
                next()

    reportErrors: false
}
