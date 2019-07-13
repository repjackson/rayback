@selected_tags = new ReactiveArray []
@selected_user_tags = new ReactiveArray []

# Meteor.startup ->
#     scheduler.init "scheduler_here", new Date()
#     scheduler.meteor(Docs.find(model:'event'), Docs);

$.cloudinary.config
    cloud_name:"facet"
# Router.notFound =
    # action: 'not_found'
Meteor.subscribe 'me'


Session.setDefault 'invert', false
Template.registerHelper 'dark_mode', () -> Session.equals('dark_mode',true)
Template.registerHelper 'parent', () -> Template.parentData()
Template.registerHelper 'invert_class', () -> if Session.equals('dark_mode',true) then 'invert' else ''
Template.registerHelper 'is_loading', () -> Session.get 'loading'
Template.registerHelper 'dev', () -> Meteor.isDevelopment
Template.registerHelper 'is_author', () ->
    # console.log @
    @_author_id is Meteor.userId()
Template.registerHelper 'is_grandparent_author', () ->
    grandparent = Template.parentData(2)
    grandparent._author_id is Meteor.userId()
Template.registerHelper 'to_percent', (number) -> (number*100).toFixed()
Template.registerHelper 'long_date', (input) -> moment(input).format("dddd, MMMM Do h:mm a")
Template.registerHelper 'short_date', (input) -> moment(input).format("h:mm a")
Template.registerHelper 'when', () -> moment(@_timestamp).fromNow()
Template.registerHelper 'from_now', (input) -> moment(input).fromNow()
Template.registerHelper 'to_now', (input) -> moment(input).to()
Template.registerHelper 'logging_out', () -> Session.get 'logging_out'
Template.registerHelper 'is_event', () -> @shop_type is 'event'
Template.registerHelper 'is_service', () -> @shop_type is 'service'
Template.registerHelper 'is_product', () -> @shop_type is 'product'


Template.registerHelper 'current_month', () -> moment(Date.now()).format("MMMM")
Template.registerHelper 'current_day', () -> moment(Date.now()).format("DD")




# Template.registerHelper 'parent_template', () -> Template.parentData()
    # Session.get 'displaying_profile'

# Template.registerHelper 'checking_in_doc', () ->
#     Docs.findOne
#         model:'healthclub_session'
#         current:true
#      # Session.get('session_document')

# Template.registerHelper 'current_session_doc', () ->
#         Docs.findOne
#             model:'healthclub_session'
#             current:true



# Template.registerHelper 'checkin_guest_docs', () ->
#     Docs.findOne Router.current().params.doc_id
#     session_document = Docs.findOne Router.current().params.doc_id
#     # console.log session_document.guest_ids
#     Docs.find
#         _id:$in:session_document.guest_ids


Template.registerHelper 'referenced_product', () ->
    Docs.findOne
        _id:@product_id


Template.registerHelper 'available_servings', () ->


Template.registerHelper 'author', () -> Meteor.users.findOne @_author_id

Template.registerHelper 'is_text', () ->
    # console.log @field_type
    @field_type is 'text'

Template.registerHelper 'template_parent', () ->
    # console.log Template.parentData()
    Template.parentData()

Template.registerHelper 'fields', () ->
    model = Docs.findOne
        model:'model'
        slug:Router.current().params.model_slug
    if model
        Docs.find {
            model:'field'
            parent_id:model._id
            view_roles:$in:Meteor.user().roles
        }, sort:rank:1

Template.registerHelper 'edit_fields', () ->
    model = Docs.findOne
        model:'model'
        slug:Router.current().params.model_slug
    if model
        Docs.find {
            model:'field'
            parent_id:model._id
            # edit_roles:$in:Meteor.user().roles
        }, sort:rank:1

Template.registerHelper 'current_user', (input) ->
    Meteor.user() and Meteor.user().username is Router.current().params.username


Template.registerHelper 'user_is_client', (input) ->
    user = Meteor.users.findOne username:Router.current().params.username
    if user and user.roles and 'client' in user.roles then true else false

Template.registerHelper 'nl2br', (text)->
    nl2br = (text + '').replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '$1' + '<br>' + '$2')
    new Spacebars.SafeString(nl2br)


Template.registerHelper 'loading_class', () ->
    if Session.get 'loading' then 'disabled' else ''

Template.registerHelper 'current_model', (input) ->
    Docs.findOne
        model:'model'
        slug: Router.current().params.model_slug

Template.registerHelper 'in_list', (key) ->
    if Meteor.userId()
        if Meteor.userId() in @["#{key}"] then true else false


Template.registerHelper 'is_admin', () ->
    if Meteor.user() and Meteor.user().roles
        # if _.intersection(['dev','admin'], Meteor.user().roles) then true else false
        if 'admin' in Meteor.user().roles then true else false

Template.registerHelper 'is_dev', () ->
    if Meteor.user() and Meteor.user().roles
        if 'dev' in Meteor.user().roles then true else false

Template.registerHelper 'is_user', () ->
    if Meteor.user() and Meteor.user().roles
        if 'user' in Meteor.user().roles then true else false

Template.registerHelper 'user_is_user', () -> if @roles and 'user' in @roles then true else false

Template.registerHelper 'is_eric', () -> if Meteor.userId() and 'Ksjij8XyNwYsnvZiD' is Meteor.userId() then true else false

Template.registerHelper 'current_user', () ->  Meteor.users.findOne username:Router.current().params.username
Template.registerHelper 'is_current_user', () ->  Meteor.user().username is Router.current().params.username
Template.registerHelper 'view_template', -> "#{@field_type}_view"
Template.registerHelper 'edit_template', -> "#{@field_type}_edit"
Template.registerHelper 'is_model', -> @model is 'model'


# Template.body.events
#     'click .toggle_sidebar': -> $('.ui.sidebar').sidebar('toggle')

Template.registerHelper 'is_editing', () -> Session.equals 'editing_id', @_id


Template.registerHelper 'can_edit', () -> Meteor.userId() is @_author_id or 'admin' in Meteor.user().roles

Template.registerHelper 'publish_when', () -> moment(@publish_date).fromNow()

Template.registerHelper 'current_doc', ->
    doc = Docs.findOne Router.current().params.doc_id
    user = Meteor.users.findOne Router.current().params.doc_id
    # console.log doc
    # console.log user
    if doc then doc else if user then user


Template.registerHelper 'user_from_username_param', () ->
    found = Meteor.users.findOne username:Router.current().params.username
    # console.log found
    found
Template.registerHelper 'field_value', () ->
    # console.log @
    parent = Template.parentData()
    parent5 = Template.parentData(5)
    parent6 = Template.parentData(6)


    if @direct
        parent = Template.parentData()
    else if parent5._id
        parent = Template.parentData(5)
    else if parent6._id
        parent = Template.parentData(6)
    if parent
        parent["#{@key}"]


Template.registerHelper 'is_marketplace', () -> @model is 'marketplace'
Template.registerHelper 'is_post', () -> @model is 'post'
Template.registerHelper 'is_meal', () -> @model is 'meal'

Template.registerHelper 'in_dev', () -> Meteor.isDevelopment

Template.registerHelper 'calculated_size', (metric) ->
    # console.log metric
    # console.log typeof parseFloat(@relevance)
    # console.log typeof (@relevance*100).toFixed()
    whole = parseInt(@["#{metric}"]*10)
    # console.log whole

    if whole is 2 then 'f2'
    else if whole is 3 then 'f3'
    else if whole is 4 then 'f4'
    else if whole is 5 then 'f5'
    else if whole is 6 then 'f6'
    else if whole is 7 then 'f7'
    else if whole is 8 then 'f8'
    else if whole is 9 then 'f9'
    else if whole is 10 then 'f10'



Template.registerHelper 'in_dev', () -> Meteor.isDevelopment
