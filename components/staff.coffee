if Meteor.isClient
    Template.staff_tasks.onCreated ->
        @autorun => Meteor.subscribe 'staff_tasks'
    Template.staff_tasks.helpers
        tasks: ->
            Docs.find
                model:'task'



    Template.working_staff.onCreated ->
        @autorun => Meteor.subscribe 'checked_in_staff'
    Template.working_staff.helpers
        checked_in_staff: ->
            Meteor.users.find
                roles:$in:['staff']
                checked_in:true




if Meteor.isServer
    Meteor.publish 'staff_tasks', ->
        Docs.find
            model:'task'
    Meteor.publish 'checked_in_staff', ->
        Meteor.users.find
            roles:$in:['staff']
            checked_in:true
