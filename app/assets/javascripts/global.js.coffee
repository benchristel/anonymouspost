window.Global = {}

Global.data =
    user_key: null
    location:
        longitude: 0
        latitude:  0
        
Global.init = () ->
    @displayHomepage()
        
Global.displayHomepage = () ->
    content = $('#content')
    if !$('#formHeader').length
        content.append('<div id="formHeader"></div>')
    if !$('ol#posts').length
        content.append('<ol id="posts"></ol>')
    
    $('#formHeader').empty()
    if Global.data.user_key?
        # user already signed in
        Global.appendPostFormToContent()
    else
        Global.appendSignInFormToContent()
    
    Global.getLocation( (position) =>
        Global.refresh_posts()
    )

Global.appendPostFormToContent = () ->
    $('#formHeader').append(
        """
        <form id="post" action="javascript:void(0)" onsubmit="Global.post()">
            <textarea class="content"></textarea>
            <input type="submit" value="Post"></input>
        </form>
        """
    )
    
Global.appendSignInFormToContent = () ->
    $('#formHeader').append(
        """
        <form id="sign_in" action="javascript:void(0)" onsubmit="Global.sign_in()">
            <input type="text" class="username"></input>
            <input type="password" class="password"></input>
            <input type="submit" value="Sign in"></input>
        </form>
        """
    )
    
Global.getLocation = (onSuccess=->) ->
    if navigator.geolocation
        navigator.geolocation.getCurrentPosition(
            (position) =>
                @data.location.longitude = position.coords.longitude
                @data.location.latitude  = position.coords.latitude
                onSuccess(position)
            , onFailure = ->
                alert "We couldn't find your position."
        )
    else
        alert "Your browser doesn't support geolocation."

Global.refresh_posts = (container=$('ol#posts')) ->
    @get_posts( (posts) ->
        container.empty()
        for post in posts
            container.append(
                """
                <li class="post">
                    <div class="vote">
                        <div class="vote_up" onclick="Global.voteUp(#{post.id})"></div>
                        <div class="vote_total">
                            #{post.net_upvotes}
                        </div>
                        <div class="vote_down" onclick="Global.voteDown(#{post.id})"></div>
                    </div>
                    
                    <div class="content">#{post.content}</div>
                    <div class="location">
                        <div class="longitude">
                            #{post.longitude}
                        </div>
                        <div class="latitude">
                            #{post.latitude}
                        </div>
                    </div>
                    <div class="time">
                        #{post.created_at}
                    </div>
                </li>
                """
            )
            
    )

Global.get_posts = (onComplete, user_key=@data.user_key, location=@data.location) ->
    url =
    if @data.user_key?
        "posts.json?user_key=#{@data.user_key}&latitude=#{location.latitude}&longitude=#{location.longitude}"
    else
        "posts.json?latitude=#{location.latitude}&longitude=#{location.longitude}"
    $.ajax(
        url: url
    ).done( onComplete )

Global.sign_in = ->
    console.log "sign in"
    @data.user_key = $('#sign_in .username').val() + $('#sign_in .password').val()
    @displayHomepage()
    
Global.post = ->
    if @data.user_key?
        @getLocation( (position) =>
            $.post("posts.json",
                post:
                    content: $("form#post .content").val()
                    longitude: @data.location.longitude
                    latitude:  @data.location.latitude
            ).done( @displayHomepage )
        )

Global.voteUp = (postId) ->
    $.ajax(
        type: 'PUT'
        url: "/posts/#{postId}/upvote.json?user_key=#{Global.data.user_key}"
    ).done(Global.displayHomepage)
    
Global.voteDown = (postId) ->
    $.ajax(
        type: 'PUT'
        url: "/posts/#{postId}/downvote.json?user_key=#{Global.data.user_key}"
    ).done(Global.displayHomepage)
    