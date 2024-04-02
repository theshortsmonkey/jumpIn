const supertest = require("supertest");
const should = require('should')



describe("GET /users", () => {
  it("GET:200 sends an array of users to the client", (done) => {
    supertest(sails.hooks.http.app)
      .get("/users")
      .expect(200)
      .end(function (err, res) {
        if (err) return done(err);
        res.body[0].should.have.property('id');
        res.body[0].should.have.property('bio');
        res.body[0].should.have.property('car');
        res.body[0].should.have.property('email');
        res.body[0].should.have.property('firstName');
        res.body[0].should.have.property('lastName');
        res.body[0].should.have.property('driver_verification_status');
        res.body[0].should.have.property('identity_verification_status');
        res.body[0].should.have.property('password');
        res.body[0].should.have.property('phoneNumber');
        res.body[0].should.have.property('reports');
        res.body[0].should.have.property('username');
        done();
    });
  });
  it("GET:200 sends an array of users to the client with correct value types", (done) => {
    supertest(sails.hooks.http.app)
      .get("/users")
      .expect(200)
      .end(function (err, res) {
        if (err) return done(err);
        res.body[0].id.should.be.type('string');
        res.body[0].bio.should.be.type('string');
        res.body[0].car.should.be.type('object');
        res.body[0].email.should.be.type('string');
        res.body[0].firstName.should.be.type('string');
        res.body[0].lastName.should.be.type('string');
        res.body[0].driver_verification_status.should.be.type('boolean');
        res.body[0].identity_verification_status.should.be.type('boolean');
        res.body[0].password.should.be.type('string');
        res.body[0].phoneNumber.should.be.type('string');
        res.body[0].reports.should.be.type('object');
        res.body[0].username.should.be.type('string');
        done();
    });
  });
  //it("GET:200 sends a single user to the client with matching username", (done) => {
  //  supertest(sails.hooks.http.app)
  //    .get("/users/testUSername2")
  //    .expect(200)
  //    .end(function (err, res) {
  //      if (err) return done(err);
  //      res.body[0].id.should.equal('6605439644469274454fd98d');
  //      res.body[0].bio.should.equal('testBio testBio2');
  //      res.body[0].car.should.equal({
  //        "reg": "AB23 AAB",
  //        "make": "testMAke2",
  //        "colour": "testColour2",
  //        "tax_due_date": "2025-01-02"
  //      });
  //      res.body[0].email.should.equal('testEmail2');
  //      res.body[0].firstName.should.equal('testFirstName2');
  //      res.body[0].lastName.should.equal('testLastName2');
  //      res.body[0].driver_verification_status.should.equal(false);
  //      res.body[0].identity_verification_status.should.equal(true);
  //      res.body[0].password.should.equal('testPassword2');
  //      res.body[0].phoneNumber.should.equal('0123456789');
  //      res.body[0].reports.should.equal([]);
  //      res.body[0].username.should.equal('testUSername2');
  //      done();
  //  });
  //});
});
