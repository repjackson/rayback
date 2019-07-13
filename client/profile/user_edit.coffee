# profilePicImage = '/icons/Logo_sm_100.png'

Template.user_edit.onCreated ->
    @autorun -> Meteor.subscribe 'user_from_username', Router.current().params.username


Template.user_model_editor.onCreated ->
    @autorun -> Meteor.subscribe 'user_models'


Template.user_edit.onRendered ->
    Meteor.setTimeout ->
        $('.button').popup()
    , 2000


Template.user_model_editor.helpers
    models: ->
        Docs.find
            model:'model'
            user_model:true

    user_model_class: ->
        current_user = Meteor.users.findOne username:Router.current().params.username

        if current_user.model_ids and @_id in current_user.model_ids then 'grey' else ''



Template.user_model_editor.events
    'click .toggle_model': ->
        current_user = Meteor.users.findOne username:Router.current().params.username
        if current_user.model_ids and @_id in current_user.model_ids
            Meteor.users.update current_user._id,
                $pull: model_ids: @_id
        else
            Meteor.users.update current_user._id,
                $addToSet: model_ids: @_id



Template.user_single_doc_ref_editor.onCreated ->
    @autorun => Meteor.subscribe 'type', @data.model




Template.user_single_doc_ref_editor.events
    'click .select_choice': ->
        context = Template.currentData()
        current_user = Meteor.users.findOne Router.current().params._id
        Meteor.users.update current_user._id,
            $set: "#{context.key}": @slug

Template.user_single_doc_ref_editor.helpers
    choices: ->
        Docs.find
            model:@model

    choice_class: ->
        context = Template.parentData()
        current_user = Meteor.users.findOne Router.current().params._id
        if current_user["#{context.key}"] and @slug is current_user["#{context.key}"] then 'grey' else ''




# Template.phone_editor.helpers
#     'newNumber': ->
#         Phoneformat.formatLocal 'US', Meteor.user().profile.phone

Template.phone_editor.events
    'click .remove_phone': (event, template) ->
        Meteor.call 'UpdateMobileNo'
        return
    'click .resend_verification': (event, template) ->
        Meteor.call 'generateAuthCode', Meteor.userId(), Meteor.user().profile.phone
        bootbox.prompt 'We texted you a validation code. Enter the code below:', (result) ->
            code = result.toUpperCase()
            if Meteor.user().profile.phone_auth == code
                Meteor.call 'updatePhoneVerified', (err, res) ->
                    if err
                        toastr.error err.reason
                    else
                        toastr.success 'Your phone was successfully verified!'
                    return
            else
                toastr.success 'Your verification code does not match.'

    'click .update_phone': ->
        `var phone`
        phone = $('#phone').val()
        phone = Phoneformat.formatE164('US', phone)
        Meteor.call 'savePhone2', Meteor.userId(), phone, (error, result) ->
            if error
                toastr.success 'There was an error processing your request.'
            else
                if result.error
                    toastr.success result.message
                else
                    bootbox.prompt result.message, (result) ->
                        code = result.toUpperCase()
                        if Meteor.user().profile.phone_auth == code
                            Meteor.call 'updatePhoneVerified'
                            toastr.success 'Your phone was successfully verified!'
                        else
                            toastr.success 'Your verification code does not match.'


Template.user_edit.events
    'click .remove_user': ->
        if confirm "Confirm delete #{@username}?  Cannot be undone."
            Meteor.users.remove @_id
            Router.go "/users"

    "change input[name='profile_image']": (e) ->
        files = e.currentTarget.files
        Cloudinary.upload files[0],
            # folder:"secret" # optional parameters described in http://cloudinary.com/documentation/upload_images#remote_upload
            # model:"private" # optional: makes the image accessible only via a signed url. The signed url is available publicly for 1 hour.
            (err,res) -> #optional callback, you can catch with the Cloudinary collection as well
                # console.dir res
                if err
                    console.error 'Error uploading', err
                else
                    user = Meteor.users.findOne username:Router.current().params.username
                    Meteor.users.update user._id,
                        $set: "image_id": res.public_id
                return





Template.username_edit.events
    'click .change_username': (e,t)->
        new_username = t.$('.new_username').val()
        current_user = Meteor.users.findOne username:Router.current().params.username
        if new_username
            if confirm "Change username from #{current_user.username} to #{new_username}?"
                Meteor.call 'change_username', current_user._id, new_username, (err,res)->
                    if err
                        alert err
                    else
                        alert "Username changed."
                        Router.go("/user/#{new_username}")




Template.password_edit.events
    'click .change_password': (e, t) ->
        Accounts.changePassword $('#password').val(), $('#new_password').val(), (err, res) ->
            if err
                alert err.reason
            else
                alert 'Password Changed'
                # $('.amSuccess').html('<p>Password Changed</p>').fadeIn().delay('5000').fadeOut();

    'click .set_password': (e, t) ->
        new_password = $('#new_password').val()
        current_user = Meteor.users.findOne username:Router.current().params.username
        Meteor.call 'set_password', current_user._id, new_password, ->
            alert "Password set to #{new_password}."

    'click .send_enrollment_email': (e,t)->
        current_user = Meteor.users.findOne username:Router.current().params.username
        Meteor.call 'send_enrollment_email', current_user._id, @address, ->
            alert 'Enrollment Email Sent'



# Template.password_edit.onRendered ->
#     $('#passwordUpdate').bootstrapValidator
#         message: 'This value is not valid'
#         feedbackIcons:
#             valid: 'glyphicon glyphicon-ok'
#             invalid: 'glyphicon glyphicon-remove'
#             validating: 'glyphicon glyphicon-refresh'
#         fields:
#             password:
#                 message: 'You must enter your existing password.'
#                 validators: notEmpty: message: 'Password is mandatory'
#             new_password:
#                 message: 'You must provide a new password.'
#                 validators: notEmpty: message: 'New Password is mandatory'



# profilePicImage = '/icons/Logo_sm_100.png'


#     "change input[type='file']": (e) ->
#         files = e.currentTarget.files
#         Cloudinary.upload files[0],
#             # folder:"secret" # optional parameters described in http://cloudinary.com/documentation/upload_images#remote_upload
#             # model:"private" # optional: makes the image accessible only via a signed url. The signed url is available publicly for 1 hour.
#             (err,res) -> #optional callback, you can catch with the Cloudinary collection as well
#                 # console.dir res
#                 if err
#                     console.error 'Error uploading', err
#                 else
#                     Meteor.users.update Router.current().params._id,
#                         $set: "profile.image_id": res.public_id
#                 return


#     'click #remove_photo': ->
#         if confirm 'Remove photo?'
#             Meteor.users.update Router.current().params._id,
#                 $unset: "profile.image_id": 1




#     'change #Profile_photo': (event, template) ->
#         #  $('.imageprocessing').show();
#         showLoadingMask()
#         $('.clsProfilePic').hide()
#         uploader = new (Slingshot.Upload)('myFileUploads')
#         uploader.send document.getElementById('Profile_photo').files[0], (error, downloadUrl) ->
#             if error
#                 hideLoadingMask()
#                 # Log service detailed response
#                 # console.error('Error uploading', uploader.xhr.response);
#                 alert error.reason
#             else
#                 hideLoadingMask()
#                 #  $('.imageprocessing').hide();
#                 $('.clsProfilePic').show()
#                 profilePicImage = downloadUrl
#                 $('.clsProfilePic').attr 'src', downloadUrl
#                 # ChurchCodes.update(template.data.code._id,{$set: {'customPage.header_image': downloadUrl}})

#     'click .update_account': (event, template) ->
#         $('#churchForm').data('bootstrapValidator').validate()
#         if $('#churchForm').data('bootstrapValidator').isValid()
#             showLoadingMask()
#             address = encodeURIComponent($('#address').val() + ',' + $('#city').val() + ',' + $('#state').val() + ' ' + $('#zip').val())
#             geoURL = 'https://maps.googleapis.com/maps/api/geocode/json?address=' + address + '&key=' + Session.get('SETTINGS').mapsApiKey
#             mydata =
#                 'link': geoURL
#                 'usr': Meteor.userId()
#             coord = undefined
#             Meteor.call 'getGeoLoc', mydata, (err, data) ->
#                 if err
#                     hideLoadingMask()
#                     toastr.error err.reason
#                 else
#                     coord = data
#                     dataJson =
#                         'profile.churchName': $('#name').val()
#                         'profile.phone': $('#phone').val()
#                         'profile.address':
#                             street: $('#address').val()
#                             city: $('#city').val()
#                             state: $('#state').val()
#                             zip: $('#zip').val()
#                         'profile.website': $('#website').val()
#                         'profile.loc':
#                             'type': 'Point'
#                             'coordinates': coord
#                         'profile.profilePic': if profilePicImage == '/icons/Logo_sm_100.png' then '/icons/Logo_sm_100.png' else profilePicImage
#                     Meteor.call 'updateChurchDetail', dataJson, (err, res) ->
#                         hideLoadingMask()
#                         if err
#                             toastr.error err.reason
#                         else
#                             toastr.success 'Account Details Updated'

#     'click .update_user': (event, template) ->
#         $('#userInfo').data('bootstrapValidator').validate()
#         if $('#userInfo').data('bootstrapValidator').isValid()
#             Meteor.call 'checkChurchUserExist', $('#email').val(), (err, res) ->
#                 if res.statusCode
#                     emailsObj = Meteor.user().emails
#                     loggedinEmailId = readCookie('loggedinEmailId')
#                     indexofEmailID = -1
#                     emailsObj.forEach (d, i) ->
#                         if d.address == loggedinEmailId
#                             indexofEmailID = i
#                         return
#                     Meteor.call 'addeditChurchUser', $('#email').val(), indexofEmailID, loggedinEmailId, (err, res) ->
#                         toastr.success 'Representative Info Updated'
#                         Meteor.logout()
#                         return
#                 else
#                     toastr.success 'This email id already registered.'


Template.emails_edit.helpers
    current_user: ->
        Meteor.users.findOne username:Router.current().params.username

Template.emails_edit.events
    'click #add_email': ->
        new_email = $('#new_email').val().trim()
        current_user = Meteor.users.findOne username:Router.current().params.username

        re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
        valid_email = re.test(new_email)

        if valid_email
            Meteor.call 'add_email', current_user._id, new_email, (error, result) ->
                if error
                    alert "Error adding email: #{error.reason}"
                else
                    # alert result
                    $('#new_email').val('')
                return

    'click .remove_email': ->
        if confirm 'Remove email?'
            current_user = Meteor.users.findOne username:Router.current().params.username
            Meteor.call 'remove_email', current_user._id, @address, (error,result)->
                if error
                    alert "Error removing email: #{error.reason}"


    'click .send_verification_email': (e,t)->
        current_user = Meteor.users.findOne username:Router.current().params.username
        Meteor.call 'verify_email', current_user._id, @address, ->
            alert 'verification email sent'
