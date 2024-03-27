/**
 * UserController
 *
 * @description :: Server-side actions for handling incoming requests.
 * @help        :: See https://sailsjs.com/docs/concepts/actions
 */

const { mongo } = require('mongoose')
const { createWriteStream, createReadStream, unlink } = require('fs')

module.exports = {
  image: async (req, res) => {
    try {
      const db = Users.getDatastore().manager
      const findImage = await db
        .collection('images.files')
        .findOne({ metadata: { username: req.params.username } })
      const path = require('path').resolve()

      if (!findImage) {
        const filePath = path + '/utils/blank-profile-picture.png'
        createReadStream(filePath).pipe(res)
      } else {
        const bucket = new mongo.GridFSBucket(db, { bucketName: 'images' })
        const filePath = path + '/temp/' + findImage.filename
        bucket
          .openDownloadStream(findImage._id)
          .pipe(createWriteStream(filePath))
          .on('close', () => {
            createReadStream(filePath).pipe(res)
            unlink(filePath, () => {})
          })
      }
    } catch (error) {
      return res.badRequest(error)
    }
  },
}
