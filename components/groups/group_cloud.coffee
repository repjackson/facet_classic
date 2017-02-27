@Group_tags= new Meteor.Collection 'group_tags'




if Meteor.isClient
    @selected_group_tags = new ReactiveArray []
    
    Template.group_cloud.onCreated ->
        @autorun -> Meteor.subscribe 'group_tags', selected_group_tags.array()
    
    
    Template.group_cloud.helpers
        group_tags: ->
            group_count = Groups.find().count()
            if 0 < group_count < 3 then Group_tags.find { count: $lt: group_count } else Group_tags.find()

            # group_tags.find()

        cloud_tag_class: ->
            button_class = switch
                when @index <= 5 then 'large'
                when @index <= 12 then ''
                when @index <= 20 then 'small'
            return button_class
    
        selected_group_tags: -> selected_group_tags.list()
    
        settings: -> {
            position: 'bottom'
            limit: 10
            rules: [
                {
                    collection: Group_tags
                    field: 'name'
                    matchAll: true
                    template: Template.tag_result
                }
                ]
        }

    
    
    Template.group_cloud.events
        'click .select_tag': -> selected_group_tags.push @name
        'click .unselect_tag': -> selected_group_tags.remove @valueOf()
        'click #clear_tags': -> selected_group_tags.clear()
    
        'keyup #search': (e,t)->
            e.preventDefault()
            val = $('#search').val().toLowerCase().trim()
            switch e.which
                when 13 #enter
                    switch val
                        when 'clear'
                            selected_group_tags.clear()
                            $('#search').val ''
                        else
                            unless val.length is 0
                                selected_group_tags.push val.toString()
                                $('#search').val ''
                when 8
                    if val.length is 0
                        selected_group_tags.pop()
                        
        'autocompleteselect #search': (event, template, doc) ->
            # console.log 'selected ', doc
            selected_group_tags.push doc.name
            $('#search').val ''


if Meteor.isServer
    Meteor.publish 'group_tags', (selected_group_tags)->
        self = @
        match = {}
        if selected_group_tags.length > 0 then match.tags = $all: selected_group_tags

    
        cloud = Groups.aggregate [
            { $match: match }
            { $project: tags: 1 }
            { $unwind: "$tags" }
            { $group: _id: '$tags', count: $sum: 1 }
            { $match: _id: $nin: selected_group_tags }
            { $sort: count: -1, _id: 1 }
            { $limit: 20 }
            { $project: _id: 0, name: '$_id', count: 1 }
            ]
        # console.log 'cloud, ', cloud
        cloud.forEach (tag, i) ->
            self.added 'group_tags', Random.id(),
                name: tag.name
                count: tag.count
                index: i
    
        self.ready()
        
    
    
