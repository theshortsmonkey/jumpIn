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
      const findImage = await db
        .collection("images.files")
        .findOne({ metadata: { username: req.params.username } })
        
        const blobAdapter = require('@dmedina2015/skipper-gridfs')({
            uri: 'mongodb://localhost:27017/testJumpInDb'
        });

        blobAdapter.read(findImage.filename, function(error , file) {
            console.log(findImage.filename)
            if(error) {
                console.log(error)
                res.json(error);
            } else {
                res.contentType('image/png');
                res.send(new Buffer(file));
            }
        });
      //res.ok(findImage);
    } catch (error) {
      return res.badRequest(error);
    }
  },
};
