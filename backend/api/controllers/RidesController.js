/**
 * RidesController
 *
 * @description :: Server-side actions for handling incoming requests.
 * @help        :: See https://sailsjs.com/docs/concepts/actions
 */

module.exports = {
  getUserDistance: async (req, res) => {
    try {
      const db = Rides.getDatastore().manager;
      const findRides = await db
        .collection("rides")
        .aggregate([
          {
            $match: {
              rider_usernames: req.params.username,
              driver_rating: { $gt: 0 },
              rider_rating: { $gt: 0 },
            },
          },
          {
            $group: {
              _id: "$rider_usernames",
              totalDistance: { $sum: "$distance" },
            },
          },
        ])
        .toArray();
      res.ok(findRides[0]);
    } catch (error) {
      return res.badRequest(error);
    }
  },
  getUserCarbon: async (req, res) => {
    try {
      const db = Rides.getDatastore().manager;
      const findRides = await db
        .collection("rides")
        .aggregate([
          {
            $match: {
              rider_usernames: req.params.username,
              driver_rating: { $gt: 0 },
              rider_rating: { $gt: 0 },
            },
          },
          {
            $group: {
              _id: "$rider_usernames",
              totalCarbon: { $sum: "$carbon_emissions" },
            },
          },
        ])
        .toArray();
      res.ok(findRides[0]);
    } catch (error) {
      return res.badRequest(error);
    }
  },
  getUserSpend: async (req, res) => {
    try {
      const db = Rides.getDatastore().manager;
      const findRides = await db
        .collection("rides")
        .aggregate([
          {
            $match: {
              rider_usernames: req.params.username,
              driver_rating: { $gt: 0 },
              rider_rating: { $gt: 0 },
            },
          },
          {
            $group: { _id: "$rider_usernames", totalSpend: { $sum: "$price" } },
          },
        ])
        .toArray();
      res.ok(findRides[0]);
    } catch (error) {
      return res.badRequest(error);
    }
  },
  postMessage: async (req, res) => {
    const findRide = await Rides.findOne({ id: req.params.ride_id });
    findRide.chats.push(req.body);
    const updatedRide = await Rides.updateOne(
      {
        id: req.params.ride_id,
      },
      {
        chats: findRide.chats,
      }
    ).fetch();
    return res.ok(updatedRide.chats);
  },
  getMessages: async (req, res) => {
    const findRide = await Rides.findOne({ id: req.params.ride_id });
    const chats = findRide.chats.filter(
      (chat) =>
        chat.to === req.params.username || chat.from === req.params.username
    );
    return res.ok(chats);
  },
  getUserMessages: async (req, res) => {
    const db = Rides.getDatastore().manager;
    const findRides = await db
      .collection("rides")
      .find({
        $or: [
          {
            "chats.to": req.params.username,
          },
          {
            "chats.from": req.params.username,
          },
        ],
      })
      .project({ id: 1, chats: 1, from: 1, to: 1 })
      .toArray();
    const filteredChats = findRides.map((ride) => {
      ride.chats = ride.chats.filter(
        (chat) =>
          chat.from === req.params.username || chat.to === req.params.username
      );
      return ride;
    });
    return res.ok(filteredChats);
  },
};
