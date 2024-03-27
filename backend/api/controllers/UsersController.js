/**
 * UserController
 *
 * @description :: Server-side actions for handling incoming requests.
 * @help        :: See https://sailsjs.com/docs/concepts/actions
 */

const { mongo } = require('mongoose')
const { createWriteStream, createReadStream, unlink } = require('fs')

module.exports = {
  imageDownload: async (req, res) => {
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
        const filePath = path + '/.tmp/downloads/' + findImage.filename
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
  imageUpload: async (req, res) => {
    try {
      const db = Users.getDatastore().manager
      req.file(`image`).upload(function (err, files) {
          if (err) return res.serverError(err);
          const bucket = new mongo.GridFSBucket(db, { bucketName: 'images' })
          const streamWrite = bucket.openUploadStream(files[0].filename,{metadata: { username: req.params.username}})
          createReadStream(files[0].fd).pipe(streamWrite).on('close', () => {
            unlink(files[0].fd, () => {})
          })
          res.status(201)
          return res.json({
            message: files[0].filename + ' uploaded successfully!'
          });
        });
      
    } catch (error) {
      return res.badRequest(error)
    }
  },
  imageDelete: async (req,res) => {
    try {
      const db = Users.getDatastore().manager
      const findImage = await db
        .collection('images.files')
        .findOne({ metadata: { username: req.params.username } })

      const bucket = new mongo.GridFSBucket(db, { bucketName: 'images' })
      bucket.delete(findImage._id)
      return res.status(204)
    } catch (error) {
      return res.badRequest(error)
    }
  },
}
