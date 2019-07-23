if Meteor.isClient
    Template.drink_categories.onCreated ->
        @autorun -> Meteor.subscribe 'docs', selected_tags.array(), 'drink'
        @autorun -> Meteor.subscribe 'model_docs', 'drink_category'
    Template.drink_categories.helpers
        drink_items: ->
            Docs.find
                model:'drink'
        drink_categories: ->
            Docs.find
                model:'drink_category'

    Template.drink_categories.events
        'click .new_drink': ->
            new_id = Docs.insert
                model:'drink'
            Router.go "/drink/#{new_id}/edit"

    Template.drink_category.onCreated ->
        @autorun -> Meteor.subscribe 'doc', Router.current().params.doc_id
    Template.drink_category.helpers
        category_drinks: ->
            Docs.find
                model:'drink'

    Template.drink_category.events
        'click .new_drink': ->
            new_id = Docs.insert
                model:'drink'
            Router.go "/drink/#{new_id}/edit"

    Template.drink_card_template.events
        'click .drink_card': ->
            Docs.update @_id,
                $inc:views:1
            Router.go "/drink/#{@_id}/view"


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



    Template.beer_info.onCreated ->
        # console.log @
        # console.log Template.parentData()
        # @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id



    Template.category_selector.onCreated ->
        @autorun -> Meteor.subscribe 'model_docs', 'drink_category'
    Template.category_selector.helpers
        drink_categories: ->
            Docs.find
                model:'drink_category'
        category_class: ->
            # console.log @
            drink = Docs.findOne Router.current().params.doc_id
            if @_id in drink.category_ids then 'active' else ''
    Template.category_selector.events
        'click .select_category':->
            drink = Docs.findOne Router.current().params.doc_id
            console.log Template.parentData()
            console.log @
            if drink.category_ids
                if @_id in drink.category_ids
                    Docs.update drink._id,
                        $pull:category_ids:@_id
                else
                    Docs.update drink._id,
                        $addToSet:category_ids:@_id
            else
                Docs.update drink._id,
                    $addToSet:category_ids:@_id
