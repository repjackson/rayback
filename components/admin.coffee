if Meteor.isClient
    Template.user_table.onCreated ->
        @autorun ->  Meteor.subscribe 'users'


    Template.user_table.helpers
        users: -> Meteor.users.find {}


    Template.user_table.events
        'click #add_staff': ->
            Router.go '/add_user'

    Template.user_role_toggle.helpers
        is_in_role: ->
            Template.parentData().roles and @role in Template.parentData().roles

    Template.user_role_toggle.events
        'click .add_role': ->
            parent_user = Template.parentData()
            Meteor.users.update parent_user._id,
                $addToSet:roles:@role

        'click .remove_role': ->
            parent_user = Template.parentData()
            Meteor.users.update parent_user._id,
                $pull:roles:@role



    Template.add_user.onCreated ->
        Session.set 'permission', false

    Template.add_user.events
        'keyup #last_name': (e,t)->
            first_name = $('#first_name').val()
            last_name = $('#last_name').val()
            $('#username').val("#{first_name.toLowerCase()}_#{last_name.toLowerCase()}")
            Session.set 'permission',true

        'click .create_staff': ->
            first_name = $('#first_name').val()
            last_name = $('#last_name').val()
            username = "#{first_name.toLowerCase()}_#{last_name.toLowerCase()}"
            Meteor.call 'add_user', username, (err,res)=>
                if err
                    alert err
                else
                    Meteor.users.update res,
                        $set:
                            first_name:first_name
                            last_name:last_name
                            added_by_username:Meteor.user().username
                            added_by_user_id:Meteor.userId()
                            roles:['staff']
                            # healthclub_checkedin:true
                    Docs.insert
                        model: 'log_event'
                        object_id: res
                        body: "#{username} was created"
                    # Docs.insert
                    #     model:'log_event'
                    #     object_id:res
                    #     body: "#{username} checked in."
                    new_user = Meteor.users.findOne res
                    Session.set 'username_query',null
                    $('.username_search').val('')
                    Router.go "/user/#{username}/edit"


    Template.add_user.helpers
        permission: -> Session.get 'permission'
