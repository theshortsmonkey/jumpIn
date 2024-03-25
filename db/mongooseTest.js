import mongoose from "mongoose";
import mongodb from "mongodb";
import { User } from "./schema/User.js";
import { Ride } from "./schema/Ride.js";

mongoose.connect("mongodb://localhost:27017/testJumpInDb");
// const connection = mongoose.connection;

async function createUser() {
  try {
    const connection = mongoose.connection;
    await User.init();
    const userProfile = await User.create({
      username: "testUSername",
      firstName: "testFirstName",
      lastName: "testLastName",
      email: "testEmail",
      profile_pic: "testProfilePic",
      password: "testPassword",
      phoneNumber: "0123456789",
      bio: "testBio testBio",
      car: {
        reg: "TEST 123",
        make: "testMAke",
        colour: "testColour",
        tax_status: "testTaxStatus",
      },
      identity_verification_status: true,
      driver_verification_status: true,
      licence_status: "testLicenceStatus",
    });
    console.log(userProfile);
    connection.close();
  } catch (error) {
    console.log(error);
  }
}

function createRide() {
  const connection = mongoose.connection;
  Ride.create({
    to: "Manchester",
    from: "Huddersfield",
    driver_username: "testUsername",
    rider_usernames: ["testUsername1", "testUsername2"],
    available_Seats: 2,
    carbon_emissions: 123,
    distance: 345,
    price: 456,
    map: {
      properties: {
        fillcolor: "rgb(33,67,11)",
        fillopacity: 0.4,
      },
      geometry: {
        type: "Polygon",
        coordinates: [
          [
            [35, 10],
            [45, 45],
            [15, 40],
            [10, 20],
            [35, 10],
          ],
          [
            [20, 30],
            [35, 35],
            [30, 20],
            [20, 30],
          ],
        ],
      },
      type: "Feature",
    },
    driver_rating: 4,
    rider_rating: 5,
    date_and_time: Date.now(),
  }).then((document) => {
    console.log(document);
    connection.close();
  });
}

createUser();
//  createRide()
