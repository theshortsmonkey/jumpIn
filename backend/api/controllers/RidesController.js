/**
 * RidesController
 *
 * @description :: Server-side actions for handling incoming requests.
 * @help        :: See https://sailsjs.com/docs/concepts/actions
 */


module.exports = {
    distance: async (req, res) => {
        try {
            const db = Rides.getDatastore().manager;
            const findRides = await db.collection('rides').aggregate([
                { $match: {rider_usernames: req.params.id}},
                { $group: { _id: "$rider_usernames", totalDistance: { $sum: "$distance" } }}
            ]).toArray();
            res.ok(findRides);
        } catch (error) {
            return res.badRequest(error);
        }
     },
};

