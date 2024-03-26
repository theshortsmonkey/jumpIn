import mongoose from 'mongoose'
import mongodb from 'mongodb'
import fs from 'fs'
import { User } from './schema/User.js'
import { Ride } from './schema/Ride.js'
import { devUserData, devRideData, devFileNamesArr } from './test-data/dev-seed-data.js'
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
    devFileNamesArr.forEach((file) => {
      const streamWrite = bucket.openUploadStream(file.name,{metadata: { username: file.username}})
      fs.createReadStream(`${__dirname}/test-data/${file.name}`).pipe(streamWrite)
    })
})
  .then(() => {
    return User.init()
  })
  .then(() => {
    return User.create(devUserData)
  })
  .then(() => {
    return Ride.create(devRideData)
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
