if Meteor.isClient
    Template.edit_date.onRendered ->
        Meteor.setTimeout (->
            $('#date').datetimepicker(
                onChangeDateTime: (dp,$input)->
                    val = $input.val()
    
                    # console.log moment(val).format("dddd, MMMM Do YYYY, h:mm:ss a")
                    minute = moment(val).minute()
                    hour = moment(val).format('h')
                    date = moment(val).format('Do')
                    ampm = moment(val).format('a')
                    weekdaynum = moment(val).isoWeekday()
                    weekday = moment().isoWeekday(weekdaynum).format('dddd').toLowerCase()
    
                    month = moment(val).format('MMMM').toLowerCase()
                    year = moment(val).format('YYYY').toLowerCase()
    
                    # date_array = [hour, minute, ampm, weekday, month, date, year]
                    date_array = [weekday, month, date, year]
    
                    doc_id = FlowRouter.getParam 'doc_id'
    
                    doc = Docs.findOne doc_id
                    tags_without_date = _.difference(doc.tags, doc.date_array)
                    tags_with_new = _.union(tags_without_date, date_array)
    
                    Docs.update doc_id,
                        $set:
                            tags: tags_with_new
                            date_array: date_array
                            date_time: val
                )), 2000
    
    
    
    Template.edit_date.events
        'click .clear': ->
            tags_without_date = _.difference(@tags, @date_array)
            Docs.update FlowRouter.getParam('docId'),
                $set:
                    tags: tags_without_date
                    date_array: []
                    date_time: null
            $('#date').val('')

