moment = require('moment')

module.exports = {
    collections:
        projects: (database) ->
            database.findAllLive({type: 'project'})
    events:
        extendTemplateData: ({templateData}) ->
            templateData.formatDate = (date, fmt) ->
                moment(date).format(fmt)

    reportErrors: false
}
