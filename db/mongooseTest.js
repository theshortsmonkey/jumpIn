import mongoose from 'mongoose'
import mongodb from 'mongodb'
import fs from 'fs'
import Gridfs from 'gridfs-stream'
import { User } from './schema/User.js'
import { Ride } from './schema/Ride.js'
import { testUserData, testRideData, testFileNamesArr } from './test-data/test-seed-data.js'
import { dirname } from 'path'

const client = new mongodb.MongoClient('mongodb://localhost:27017')
mongoose.connect('mongodb://localhost:27017/testJumpInDb')
const connection = mongoose.connection

connection
  .dropDatabase()
  .then(() => {
    const db = connection
    const bucket = new mongodb.GridFSBucket(db, {bucketName: 'images'})
    const __dirname = import.meta.dirname;
    testFileNamesArr.forEach((file) => {
        const streamWrite = bucket.openUploadStream(file)
        fs.createReadStream(`${__dirname}/test-data/${file}`).pipe(streamWrite)
    })
    // return Promise.all([bucket, client.connect()])
    
})
  .then(() => {
    return User.init()
  })
  .then(() => {
    return User.create(testUserData)
  })
  .then(() => {
    return Ride.create(testRideData)
  })
  .then(() => {
    return User.countDocuments({})
  }).then((res) => {
    console.log(res,'- created users')
    return Ride.countDocuments({})
  }).then((res) => {
    console.log(res, '- created rides')
    console.log('Test Data Seeded')
    return connection.close()
    
// .then((promiseArr) => {
  })

    // .on('close', (file) => {
        // console.log(file)  
        // imageUpload(promiseArr[0], testFileNamesArr)
    // })
// })
// .then(() => {
//     return client.close()
// })
    // .catch(console.log)
    
// function imageUpload(bucket, fileNamesArr) {
//     const __dirname = import.meta.dirname;
//     return fileNamesArr.forEach((file) => {
//         const streamWrite = bucket.openUploadStream(file)
//         fs.createReadStream(`${__dirname}/test-data/${file}`).pipe(streamWrite)
//         streamWrite.on('close', (res) => {
//             console.log(res, "<<<< res from on.close")
//         })
//     })
// }