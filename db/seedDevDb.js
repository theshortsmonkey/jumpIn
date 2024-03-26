import mongoose from 'mongoose'
import mongodb from 'mongodb'
import fs from 'fs'
import { User } from './schema/User.js'
import { Ride } from './schema/Ride.js'
import { testUserData, testRideData, testFileNamesArr } from './test-data/test-seed-data.js'
import connectToDB from './connectToDb.js'
import "dotenv/config.js";

const connectionString = process.env.DB_STRING
connectToDB(connectionString)
const client = new mongodb.MongoClient(connectionString)
const connection = mongoose.connection

connection  
  .dropDatabase()
  .then(() => {
    const db = client.db('jumpIn')
    const bucket = new mongodb.GridFSBucket(db, {bucketName: 'images'})
    const __dirname = import.meta.dirname;
    testFileNamesArr.forEach((file) => {
        const streamWrite = bucket.openUploadStream(file)
        fs.createReadStream(`${__dirname}/test-data/${file}`).pipe(streamWrite)
    })
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
    
  })
