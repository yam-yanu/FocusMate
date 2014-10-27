dispatcher = new WebSocketRails("ws://#{localhost.host}/websocket")
channel = dispatcher.subscribe("streaming")
channel.bind "create", (tweet) ->
  # something