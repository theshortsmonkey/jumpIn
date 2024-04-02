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
            const findRides = await db.collection('rides').aggregate([
                { $match: {rider_usernames: req.params.username,
                            driver_rating: {$gt: 0}, rider_rating: {$gt: 0} }},
                { $group: { _id: "$rider_usernames", totalDistance: { $sum: "$distance" } }}
            ]).toArray();
            res.ok(findRides[0]);
        } catch (error) {
            return res.badRequest(error);
        }
     },
     getUserCarbon: async (req, res) => {
        try {
            const db = Rides.getDatastore().manager;
            const findRides = await db.collection('rides').aggregate([
                { $match: {rider_usernames: req.params.username,
                            driver_rating: {$gt: 0}, rider_rating: {$gt: 0} }},
                { $group: { _id: "$rider_usernames", totalCarbon: { $sum: "$carbon_emissions" } }}
            ]).toArray();
            res.ok(findRides[0]);
        } catch (error) {
            return res.badRequest(error);
        }
     },
     getUserSpend: async (req, res) => {
        try {
            const db = Rides.getDatastore().manager;
            const findRides = await db.collection('rides').aggregate([
                { $match: {rider_usernames: req.params.username,
                            driver_rating: {$gt: 0}, rider_rating: {$gt: 0} }},
                { $group: { _id: "$rider_usernames", totalSpend: { $sum: "$price" } }}
            ]).toArray();
            res.ok(findRides[0]);
        } catch (error) {
            return res.badRequest(error);
        }
     },
};

