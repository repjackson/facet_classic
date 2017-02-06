Template.edit_point_price.events
    'change #point_price': ->
        doc_id = FlowRouter.getParam('doc_id')
        point_price = $('#point_price').val()
        price_num = parseInt point_price

        Docs.update doc_id,
            $set: point_price: price_num