const supertest = require("supertest");
const should = require("should");

describe("GET /rides", () => {
  it("GET:200 sends an array of rides to the client", (done) => {
    supertest(sails.hooks.http.app)
      .get("/rides")
      .expect(200)
      .end(function (err, res) {
        if (err) return done(err);
        res.body[0].should.have.property("available_seats");
        res.body[0].should.have.property("carbon_emissions");
        res.body[0].should.have.property("chats");
        res.body[0].should.have.property("date_and_time");
        res.body[0].should.have.property("distance");
        res.body[0].should.have.property("driver_rating");
        res.body[0].should.have.property("driver_username");
        res.body[0].should.have.property("from");
        res.body[0].should.have.property("from_region");
        res.body[0].should.have.property("map");
        res.body[0].should.have.property("price");
        res.body[0].should.have.property("rider_rating");
        res.body[0].should.have.property("rider_usernames");
        res.body[0].should.have.property("to");
        res.body[0].should.have.property("to_region");
        done();
      });
  });
  it("GET:200 sends an array of rides to the client with correct value types", (done) => {
    supertest(sails.hooks.http.app)
      .get("/rides")
      .expect(200)
      .end(function (err, res) {
        if (err) return done(err);
        res.body[0].available_seats.should.be.type("number");
        res.body[0].carbon_emissions.should.be.type("number");
        res.body[0].chats.should.be.type("object");
        res.body[0].date_and_time.should.be.type("string");
        res.body[0].distance.should.be.type("number");
        res.body[0].driver_rating.should.be.type("number");
        res.body[0].driver_username.should.be.type("string");
        res.body[0].from.should.be.type("string");
        res.body[0].from_region.should.be.type("string");
        res.body[0].map.should.be.type("object");
        res.body[0].price.should.be.type("number");
        res.body[0].rider_rating.should.be.type("number");
        res.body[0].rider_usernames.should.be.type("object");
        res.body[0].to.should.be.type("string");
        res.body[0].to_region.should.be.type("string");
        done();
      });
  });
  xit("GET:200 sends a single ride to the client with matching details", (done) => {
    supertest(sails.hooks.http.app)
      .get("/rides/660592a63366fc405dc0e8a0")
      .expect(200)
      .end(function (err, res) {
        if (err) return done(err);
        res.body.should.have.property("available_seats", 1);
        res.body.should.have.property("carbon_emissions", 122);
        res.body.should.have.property("chats", []);
        res.body.should.have.property("date_and_time",   "2024-03-28T15:54:14.476Z"
        );
        res.body.should.have.property("distance", 330);
        res.body.should.have.property("driver_rating", 2);
        res.body.should.have.property("driver_username", "testUsername1");
        res.body.should.have.property("from", "Leeds");
        res.body.should.have.property("from_region", "Leeds");
        res.body.should.have.property("map", {
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
        });
        res.body.should.have.property("price", 1000);
        res.body.should.have.property("rider_rating", 5);
        res.body.should.have.property("rider_usernames", ["testUsername2"]);
        res.body.should.have.property("to", "Manchester");
        res.body.should.have.property("to_region", "Manchester");
        done();
      });
  });
  it("GET:404 returns not found when non existant ride id is sent", (done) => {
    supertest(sails.hooks.http.app)
      .get("/rides/6")
      .expect(404, done)
  });
});
