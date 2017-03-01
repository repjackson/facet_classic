if Meteor.isClient
    Template.eventbrite.events
        'keydown #eventbrite_id': (e,t)->
            e.preventDefault
            if e.which is 13
                event_id = t.find('#eventbrite_id').value.trim()
                if event_id.length > 0
                    # console.log 'attemping to add event with id ', event_id
                    Meteor.call 'import_eventbrite', event_id, (err,res)->
                        t.find('#import_eventbrite').value = ''
                        console.log res



if Meteor.isServer
    Meteor.methods
        import_eventbrite: (event_id)->
            HTTP.get "https://www.eventbriteapi.com/v3/events/#{event_id}", {
                    params:
                        token: 'QLL5EULOADTSJDS74HH7'
                        expand: 'organizer,venue,logo,format,category,subcategory,ticket_classes,bookmark_info'
                }, 
                (err, res)->
                    if err
                        console.error err
                    else
                        event = res.data
                        existing_event = Docs.findOne { id: event.id} 
                        if existing_event
                            console.log 'found duplicate', event.id
                            return
                        else
                            image_id = event.logo.id
                            image_object = HTTP.get "https://www.eventbriteapi.com/v3/media/#{image_id}", {
                                params:
                                    token: 'QLL5EULOADTSJDS74HH7'
                            }
                            # console.log image_object
                            # console.dir event
                            new_image_url = image_object.data.url
                            event.big_image_url = new_image_url
                            val = event.start.local
                            # console.log val
                            minute = moment(val).minute()
                            hour = moment(val).format('h')
                            date = moment(val).format('Do')
                            ampm = moment(val).format('a')
                            weekdaynum = moment(val).isoWeekday()
                            weekday = moment().isoWeekday(weekdaynum).format('dddd')
            
                            month = moment(val).format('MMMM')
                            year = moment(val).format('YYYY')
            
                            # datearray = [hour, minute, ampm, weekday, month, date, year]
                            datearray = [weekday, month]
                            datearray = _.map(datearray, (el)-> el.toString().toLowerCase())
    
                            
                            event.date_array = datearray
                            
                            tags = datearray
                          
                            tags.push event.venue.name
                            tags.push event.organizer.name
                            
                            if event.category 
                                for category_object in event.category
                                    tags push category_object.name
                            
                            trimmed_tags = _.map tags, (tag) ->
                                tag.trim().toLowerCase()
                            unique_tags = _.uniq trimmed_tags
                            event.tags = unique_tags 
                            
                            new_event_doc =
                                eventbrite_id: event.id
                                title: event.name.text
                                description: event.description.html
                                location: event.venue.name
                                start_datetime: event.start.local
                                end_datetime: event.end.local
                                type: 'event'
                                eventbrite_image: event.big_image_url
                                tags: event.tags
                                published: false
                                link: event.url
                            
                            new_event_id = Docs.insert new_event_doc
                            
                            console.log 'new_event_id', new_event_id
                            return new_event_id
                        console.log 'here?', new_event_id
                        return new_event_id
