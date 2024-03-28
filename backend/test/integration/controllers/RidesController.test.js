const supertest = require("supertest");

describe("GET /rides", () => {
  it("GET:200 sends an array of rides to the client", (done) => {
    supertest(sails.hooks.http.app)
      .get("/rides")
      .expect(200)
      .end(function (err, res) {
        if (err) return done(err);
        res.body[0].should.have.property('available_seats')
        res.body[0].should.have.property('carbon_emissions');
        res.body[0].should.have.property('chats');
        res.body[0].should.have.property('date_and_time');
        res.body[0].should.have.property('distance');
        res.body[0].should.have.property('driver_rating');
        res.body[0].should.have.property('driver_username');
        res.body[0].should.have.property('from');
        res.body[0].should.have.property('from_region');
        res.body[0].should.have.property('map');
        res.body[0].should.have.property('price');
        res.body[0].should.have.property('rider_rating');
        res.body[0].should.have.property('rider_usernames');
        res.body[0].should.have.property('to');
        res.body[0].should.have.property('to_region');
        done();
    });
  });
  it("GET:200 sends an array of rides to the client with correct value types", (done) => {
    supertest(sails.hooks.http.app)
      .get("/rides")
      .expect(200)
      .end(function (err, res) {
        if (err) return done(err);
        res.body[0].available_seats.should.be.type('number')
        res.body[0].carbon_emissions.should.be.type('number');
        res.body[0].chats.should.be.type('object');
        res.body[0].date_and_time.should.be.type('string');
        res.body[0].distance.should.be.type('number');
        res.body[0].driver_rating.should.be.type('number');
        res.body[0].driver_username.should.be.type('string');
        res.body[0].from.should.be.type('string');
        res.body[0].from_region.should.be.type('string');
        res.body[0].map.should.be.type('object');
        res.body[0].price.should.be.type('number');
        res.body[0].rider_rating.should.be.type('number');
        res.body[0].rider_usernames.should.be.type('object');
        res.body[0].to.should.be.type('string');
        res.body[0].to_region.should.be.type('string');
        done();
    });
  });
  it("GET:200 sends a single ride to the client with matching username", (done) => {
    supertest(sails.hooks.http.app)
      .get("/rides/6605439644469274454fd997")
      .expect(200)
      .end(function (err, res) {
        if (err) return done(err);
        res.body[0].id.should.equal('6605439644469274454fd98d');
        res.body[0].bio.should.equal('testBio testBio2');
        res.body[0].car.should.equal({
          "reg": "AB23 AAB",
          "make": "testMAke2",
          "colour": "testColour2",
          "tax_due_date": "2025-01-02"
        });
        res.body[0].email.should.equal('testEmail2');
        res.body[0].firstName.should.equal('testFirstName2');
        res.body[0].lastName.should.equal('testLastName2');
        res.body[0].driver_verification_status.should.equal(false);
        res.body[0].identity_verification_status.should.equal(true);
        res.body[0].password.should.equal('testPassword2');
        res.body[0].phoneNumber.should.equal('0123456789');
        res.body[0].reports.should.equal([]);
        res.body[0].username.should.equal('testUSername2');
        done();
    });
  });
});
