import {Schema, model} from 'mongoose';

const message = new Schema({
    username: String,
    text: String,
    timeStamp: {type: Date, default: Date.now},
})

const chat = new Schema({ 
    messages: [message],
})

const rideSchema = new Schema({
    to: String,
    from: String,
    driver_username: String,
    rider_usernames: Array,
    available_Seats: Number,
    carbon_emissions: Number,
    distance: Number,
    price: Number,
    map: Object,
    driver_rating: Number,
    rider_rating: Number,
    date_and_time: Date,
    chats: [chat],
})

export const Ride = model('Ride', rideSchema)