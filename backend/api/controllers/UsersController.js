/**
 * UserController
 *
 * @description :: Server-side actions for handling incoming requests.
 * @help        :: See https://sailsjs.com/docs/concepts/actions
 */

module.exports = {
    image: async (req, res) => {
        try {
            const db = Users.getDatastore().manager;
            console.log(db);
            const findImage = await db.collection('images.files').find({_id: req.params.filename}).toArray();
            res.ok(findImage);
        } catch (error) {
            return res.badRequest(error);
        }
     },     
};

