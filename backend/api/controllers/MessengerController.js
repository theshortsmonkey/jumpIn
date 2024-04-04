/**
 * MessengerController
 *
 * @description :: Server-side actions for handling incoming requests.
 * @help        :: See https://sailsjs.com/docs/concepts/actions
 */

module.exports = {
  joinRideChat: function (req, res) {
    console.log("hello");
    if (!req.isSocket) {
      return res.badRequest();
    }

    sails.sockets.join(req, `${ride_id}${username}`);
    res.ok()
  },

  sendMessage: function (req, res) {
    if (!req.isSocket) {
      return res.badRequest();
    }

    const ride_id = req.params.ride_id;
    const username = req.params.username;

    sails.sockets.broadcast(
      `${ride_id}${username}`,
      { message: req.body.message },
      req
    );

    return res.json({});
  },
};
