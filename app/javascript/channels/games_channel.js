import consumer from "./consumer"

const GamesChannel = (slug) => consumer.subscriptions.create({channel: "GamesChannel", slug: slug}, {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
  }
});

export default GamesChannel
