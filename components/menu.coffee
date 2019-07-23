if Meteor.isClient
    Template.menu.onCreated ->
        @autorun -> Meteor.subscribe 'model_docs', 'drink_category'
        @autorun -> Meteor.subscribe 'model_docs', 'drink'

    Template.menu.onRendered ->
        # Meteor.setTimeout ->
        #     $('.accordion').accordion()
        # , 1000


    Template.menu.helpers
        drink_categories: ->
            Docs.find {
                model:'drink_category'
            }

    Template.drink_category_segment.helpers
        category_drinks: ->
            console.log @
            Docs.find {
                model:'drink'
                category_ids:$in:[@_id]
            }






if Meteor.isServer
    Meteor.publish 'my_products', (user_id)->
        Docs.find
            model:'shop'
            _author_id:user_id

    Meteor.publish 'todays_reservations', (user_id)->
        user = Meteor.users.findOne user_id
        product_cursor = Docs.find(model:'shop',_author_id:user_id)
        # console.log 'product count', product_count
        product_ids = []
        for product in product_cursor.fetch()
            product_ids.push product._id
        today_formatted = moment(Date.now()).format("MM-DD-YY")

        Docs.find(
            model:'reservation',
            product_id:$in:product_ids
            date:today_formatted
            )


if Meteor.isServer
    Meteor.publish 'checked_in_users', ->
        Meteor.users.find
            checked_in:true
