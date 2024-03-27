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
    to_region: String,
    from_region: String,
    driver_username: String,
    rider_usernames: Array,
    available_seats: Number,
    carbon_emissions: Number,
    distance: Number,
    price: Number,
    map: Object,
    driver_rating: { type: Number, default: null },
    rider_rating: { type: Number, default: null },
    date_and_time: Date,
    chats: [chat],
})

export const Ride = model('Ride', rideSchema)