if Meteor.isClient
    Template.edit_date.onRendered ->
        Meteor.setTimeout (->
            $('#date').datetimepicker(
                onChangeDateTime: (dp,$input)->
                    val = $input.val()
    
                    console.log moment(val).format("dddd, MMMM Do YYYY, h:mm:ss a")
                    minute = moment(val).minute()
                    hour = moment(val).format('h')
                    date = moment(val).format('Do')
                    ampm = moment(val).format('a')
                    weekdaynum = moment(val).isoWeekday()
                    weekday = moment().isoWeekday(weekdaynum).format('dddd')
    
                    month = moment(val).format('MMMM')
                    year = moment(val).format('YYYY')
    
                    date_array = [hour, minute, ampm, weekday, month, date, year]
    
                    doc_id = FlowRouter.getParam 'doc_id'
    
                    doc = Docs.findOne doc_id
                    tags_without_date = _.difference(doc.tags, doc.date_array)
                    tags_with_new = _.union(tags_without_date, date_array)
    
                    Docs.update doc_id,
                        $set:
                            tags: tags_with_new
                            date_array: date_array
                            dateTime: val
                )), 2000
    
    
    
    Template.edit_date.events
        'click .clearDT': ->
            tagsWithoutDate = _.difference(@tags, @datearray)
            Docs.update FlowRouter.getParam('docId'),
                $set:
                    tags: tagsWithoutDate
                    datearray: []
                    dateTime: null
            $('#datetimepicker').val('')

