if Meteor.isClient
    Template.drinks.onCreated ->
        @autorun -> Meteor.subscribe 'docs', selected_tags.array(), 'drink'
        @autorun -> Meteor.subscribe 'model_docs', 'drink_category'

    Template.drinks.helpers
        drink_items: ->
            Docs.find
                model:'drink'

        drink_categories: ->
            Docs.find
                model:'drink_category'

    Template.drinks.events
        'click .new_drink': ->
            new_id = Docs.insert
                model:'drink'
            Router.go "/drink/#{new_id}/edit"

    Template.drink_card_template.events
        'click .drink_card': ->
            Docs.update @_id,
                $inc:views:1
            Router.go "/drink/#{@_id}"


    Template.drink_page.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
    Template.drink_edit.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id

    Template.drink_page.helpers
        is_member: ->
            drink = Docs.findOne Router.current().params.doc_id
            if drink.members and Meteor.user().username in drink.members then true else false

    Template.drink_page.events
        'click .join': ->
            Docs.update Router.current().params.doc_id,
                $addToSet:
                    members: Meteor.user().username
        'click .leave': ->
            Docs.update Router.current().params.doc_id,
                $pull:
                    members: Meteor.user().username
