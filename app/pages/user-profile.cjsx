# @cjsx React.DOM

React = require 'react'
ChildRouter = require 'react-child-router'
{Link} = ChildRouter

getUser = (login, callback) ->
  setTimeout ->
    callback null,
      login: 'brian-c'
      display_name: 'brian-c'
      avatar: 'https://pbs.twimg.com/profile_images/420634335964692480/aXU3vnUq.jpeg'
      credited_name: 'Brian Carstensen'
      location: 'Chicago, IL'
      twitter: '__brian_c__'
      website: 'https://github.com/brian-c'
      bio: '''
        Web developer at the Zooniverse!
      '''
      projects: []
      recents: []
      collections: []
      messages: []

OwnerHeader = React.createClass
  displayName: 'UserHeader'

  render: ->
    <div className="owner-header content-container columns-container">
      <div>
        <img src={@props.user.avatar} className="avatar"/>
      </div>
      <div>
        <span className="credited-name">{@props.user.credited_name || @props.user.display_name}</span>
        {if @props.user.credited_name
          <span className="display-name">&emsp;({@props.user.display_name})</span>}
        {if @props.user.location
          <div className="location">{@props.user.location}</div>}
        <hr />
        <div className="external-links">
          {if @props.user.website
            <div><i>[w]</i> <a href={@props.user.website}>{@props.user.website}</a></div>}
          {if @props.user.twitter
            <div><i>[t]</i> @<a href="https://twitter.com/#{@props.user.twitter}">{@props.user.twitter}</a></div>}
        </div>
      </div>
    </div>

module.exports = React.createClass
  displayName: 'UserPage'

  componentWillMount: ->
    console.log 'MOUNTING WITH', @props.params.login
    getUser @props.params.login, (error, user) =>
      @setState {user}

  render: ->
    if @state?.user?
      <div className="user-page">
        <OwnerHeader className="content-container" user={@state.user} />

        <div className="tabbed-content" data-side="top">
          <div className="tabbed-content-tabs">
            <Link href="#/users/#{@state.user.display_name}" className="tabbed-content-tab">Bio</Link>
            <Link href="#/users/#{@state.user.display_name}/activity" className="tabbed-content-tab">Activity</Link>
            <Link href="#/users/#{@state.user.display_name}/collections" className="tabbed-content-tab">Collections</Link>
            <Link href="#/users/#{@state.user.display_name}/projects" className="tabbed-content-tab">Projects</Link>
            <Link href="#/users/#{@state.user.display_name}/talk" className="tabbed-content-tab">Talk</Link>
          </div>

          <ChildRouter className="content-container">
            <div hash="#/users/#{@state.user.display_name}">User's bio</div>
            <div hash="#/users/#{@state.user.display_name}/activity">Timeline of this user's recent activity</div>
            <div hash="#/users/#{@state.user.display_name}/collections">Collections this user has created</div>
            <div hash="#/users/#{@state.user.display_name}/projects">Projects this user has created or has a special role in</div>
            <div hash="#/users/#{@state.user.display_name}/talk">Your private messages with this user</div>
          </ChildRouter>
        </div>
      </div>

    else
      <div className="loading">Loading...</div>
