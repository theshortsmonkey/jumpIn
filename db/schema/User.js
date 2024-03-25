import {Schema, model} from "mongoose";

const reportUpdate = new Schema({
    text: String,
    timeStamp: {type: Date, default: Date.now} 
})

const report = new Schema({
    reported_user: String,
    report_history: [reportUpdate]
})

const userSchema = new Schema({
    username: {type: String, unique: true},
    firstName: String,
    lastName: String,
    email: String,
    profile_pic: String,
    password: String,
    phoneNumber: String,
    bio: String,
    car: {
        reg: {type: String, default: ''},
        make: {type: String, default: ''},
        colour: {type: String, default: ''},
        tax_status: {type: String, default: ''},
    },
    identity_verification_status: {type: Boolean, default: false},
    driver_verification_status: {type: Boolean, default: false},
    licence_status: {type: String, default: ''},
    reports: [report]
})

export const User = model('User', userSchema);