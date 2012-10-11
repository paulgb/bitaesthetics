moment = require('moment')

module.exports = {
    collections:
        projects: (database) ->
            database.findAllLive({type: 'project'})
    templateData:
        site:
            name: 'bitaesthetics'
            nav: [['projects', 'index.html']
                  ['blog', 'blog.html']
                  ['about', 'about.html']]
        formatDate: (date, fmt) ->
            moment(date).format(fmt)

    reportErrors: false
}
