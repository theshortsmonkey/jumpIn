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
    password: String,
    phoneNumber: String,
    bio: {type: String, default: ''},
    car: {
        reg: {type: String, default: ''},
        make: {type: String, default: ''},
        colour: {type: String, default: ''},
        tax_due_date: {type: String, default: ''},
    },
    identity_verification_status: {type: Boolean, default: false},
    driver_verification_status: {type: Boolean, default: false},
    license_expiry_date: {type: String, default: ''},
    reports: [report]
})

export const User = model('User', userSchema);