import mongoose from 'mongoose'
import mongodb from 'mongodb'
import { User } from './schema/User.js'
import { Ride } from './schema/Ride.js'
import { testUserData, testRideData } from './test-data/test-seed-data.js'

mongoose.connect('mongodb://localhost:27017/testJumpInDb')
const connection = mongoose.connection
connection
  .dropDatabase()
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
    connection.close()
  })
  // .catch(console.log)
