moment = require('moment')
im = require 'imagemagick'

module.exports = {
    collections:
        projects: (database) ->
            database.findAllLive({type: 'project'})
        posts: (database) ->
            database.findAllLive({type: 'post'})
    templateData:
        site:
            name: 'bitaesthetics'
            nav: [['projects', '/']
                  ['blog', '/blog.html']
                  ['about', '/pages/about.html']]
        formatDate: (date, fmt) ->
            moment(date).format(fmt)

    events:
        render: (opts, next) ->
            if opts.inExtension == 'png' and opts.outExtension == 'png'
                {fullPath, outDirPath, basename, outExtension} = opts.file.attributes

                args = "-rotate -2 -colorspace Gray -normalize +level-colors black,#ff3311".split(' ')

                im.convert args.concat([fullPath, '-']), (err, stdout) ->
                  console.log 'err', err
                  opts.content = new Buffer(stdout, 'binary')
                  next()

            else
                next()

    reportErrors: false
}
