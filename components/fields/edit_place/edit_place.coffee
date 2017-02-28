if Meteor.isClient
    Meteor.startup ->
        GoogleMaps.load
            key: 'AIzaSyBluAacaAcSdXuk0hTRrnvoly0HI5wcf2Q'
            libraries: 'places'



    Template.edit_place.onRendered ->    
        @autorun ->
            if GoogleMaps.loaded()
                $('#place').geocomplete().bind 'geocode:result', (event, result) ->
                    doc_id = FlowRouter.getParam('doc_id')
                    # console.log result
                    Meteor.call 'update_place', doc_id, result, ->

    

    
    Template.edit_place.events
        'change #place': ->
            place = $('#place').val()
    
            Docs.update doc_id,
                $set: place: place


if Meteor.isServer
    Meteor.methods
        update_place: (doc_id, result)->
            address_tags = (component.long_name for component in result.address_components)
            lowered_address_tags = _.map(address_tags, (tag)->
                tag.toLowerCase()
                )
    
            # console.log address_tags
    
            doc = Docs.findOne doc_id
            tags_without_address = _.difference(doc.tags, doc.address_tags)
            tags_with_new = _.union(tags_without_address, lowered_address_tags)
    
            Docs.update doc_id,
                $set:
                    tags: tags_with_new
                    placeob: result
                    address_tags: lowered_address_tags

