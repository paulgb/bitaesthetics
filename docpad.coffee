moment = require('moment')
{spawn} = require('child_process')

module.exports = {
    collections:
        projects: (database) ->
            database.findAllLive({type: 'project'})
        posts: (database) ->
            database.findAllLive({type: 'post'})
    templateData:
        site:
            name: 'bitaesthetics'
            nav: [['projects', '/index.html']
                  ['blog', '/blog.html']
                  ['about', '/pages/about.html']]
        formatDate: (date, fmt) ->
            moment(date).format(fmt)

    events:
        render: (opts, next) ->
            if opts.inExtension == 'png' and opts.outExtension == 'png'
                {fullPath, outDirPath, basename, outExtension} = opts.file.attributes
                outName = "#{outDirPath}/#{basename}-bg.#{outExtension}"

                args = "-rotate -2 -colorspace Gray -normalize +level-colors black,#ff3311 #{fullPath} #{outName}"
                command = 'convert'

                proc = spawn(command, args.split(' '))

                proc.on 'close', (code) ->
                    next(code) if code
                    next()
            else
                next()

    reportErrors: false
}
