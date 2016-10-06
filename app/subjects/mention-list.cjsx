React = require 'react'
talkClient = require 'panoptes-client/lib/talk-client'
Comment = require '../talk/comment'
Loading = require '../components/loading-indicator'

module.exports = React.createClass
  displayName: 'SubjectMentionList'

  componentWillMount: ->
    @getMentions()

  getInitialState: ->
    mentions: null

  getMentions: ->
    query =
      section: @props.section
      mentionable_id: @props.subject.id
      mentionable_type: 'Subject'
      sort: '-created_at'
      page_size: 20
      include: 'comment'

    talkClient.type('mentions').get(query).then (mentions) =>
      Promise.all mentions.map (mention) ->
        mention.get('comment').then (comment) ->
          mention.update {comment}
      .then (mentions) =>
        @setState {mentions}

  render: ->
    return <Loading /> unless @state.mentions

    if @state.mentions.length > 0
      <div>
        <h2>Mentions:</h2>
        <div>
          {@state.mentions.map (mention) ->
            <Comment
              key={"mention-#{mention.comment.id}"}
              data={mention.comment}
              locked={true}
              linked={true}
              params={@props.params} />
          }
        </div>
      </div>
    else
      <span></span>
