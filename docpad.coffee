moment = require('moment')

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

    reportErrors: false
}
