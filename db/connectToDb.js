import mongoose from 'mongoose'
import mongodb from 'mongodb'

const connectToDB = async (connectionString) => {
  try {
      await mongoose.connect(connectionString, {
          autoIndex: true
      })
      console.log('Connected to Mongodb Atlas');} catch (error) {
      console.error(error);
  } 
}
export default connectToDB