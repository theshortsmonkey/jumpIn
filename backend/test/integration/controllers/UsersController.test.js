const supertest = require("supertest");
const should = require("should");

describe("GET /users", () => {
  it("GET:200 sends an array of users to the client", (done) => {
    supertest(sails.hooks.http.app)
      .get("/users")
      .expect(200)
      .end((err, res) => {
        if (err) return done(err);
        res.body[0].should.have.property("id");
        res.body[0].should.have.property("bio");
        res.body[0].should.have.property("car");
        res.body[0].should.have.property("email");
        res.body[0].should.have.property("firstName");
        res.body[0].should.have.property("lastName");
        res.body[0].should.have.property("driver_verification_status");
        res.body[0].should.have.property("identity_verification_status");
        res.body[0].should.have.property("password");
        res.body[0].should.have.property("phoneNumber");
        res.body[0].should.have.property("reports");
        res.body[0].should.have.property("username");
        done();
      });
  });
  it("GET:200 sends an array of users to the client with correct value types", (done) => {
    supertest(sails.hooks.http.app)
      .get("/users")
      .expect(200)
      .end((err, res) => {
        if (err) return done(err);
        res.body[0].id.should.be.type("string");
        res.body[0].bio.should.be.type("string");
        res.body[0].car.should.be.type("object");
        res.body[0].email.should.be.type("string");
        res.body[0].firstName.should.be.type("string");
        res.body[0].lastName.should.be.type("string");
        res.body[0].driver_verification_status.should.be.type("boolean");
        res.body[0].identity_verification_status.should.be.type("boolean");
        res.body[0].password.should.be.type("string");
        res.body[0].phoneNumber.should.be.type("string");
        res.body[0].reports.should.be.type("object");
        res.body[0].username.should.be.type("string");
        done();
      });
  });
  it("GET:200 sends a single user to the client with matching username", (done) => {
    supertest(sails.hooks.http.app)
      .get("/users/testUSername2")
      .expect(200)
      .end((err, res) => {
        if (err) return done(err);
        res.body.should.have.property("bio", "testBio testBio2");
        res.body.should.have.property("car", {
          reg: "AB23 AAB",
          make: "testMAke2",
          colour: "testColour2",
          tax_due_date: "2025-01-02",
        });
        res.body.should.have.property("email", "testEmail2");
        res.body.should.have.property("firstName", "testFirstName2");
        res.body.should.have.property("lastName", "testLastName2");
        res.body.should.have.property("driver_verification_status", false);
        res.body.should.have.property("identity_verification_status", true);
        res.body.should.have.property("password", "testPassword2");
        res.body.should.have.property("phoneNumber", "0123456789");
        res.body.should.have.property("reports", []);
        res.body.should.have.property("username", "testUSername2");
        done();
      });
  });
  it("GET:404 returns not found when non existant username is sent", (done) => {
    supertest(sails.hooks.http.app).get("/users/barry").expect(404, done);
  });
});
describe("POST /users", () => {
  it("200 return the newly posted user", (done) => {
    const newUser = {
      username: "testUSername5",
      firstName: "testFirstName5",
      lastName: "testLastName5",
      email: "testEmail5",
      password: "testPassword5",
      phoneNumber: "0123456789",
      bio: "testBio testBio5",
      car: {
        reg: "AB25 AAA",
        make: "testMAke5",
        colour: "testColour5",
        tax_due_date: "2025-01-01",
      },
      identity_verification_status: false,
      driver_verification_status: true,
      license_expiry_date: "",
      reports: [],
      __v: 0,
    };
    supertest(sails.hooks.http.app)
      .post("/users")
      .send(newUser)
      .expect(200)
      .end((err, res) => {
        if (err) return done(err);
        res.body.should.have.property("username", "testUSername5");
        res.body.should.have.property("firstName", "testFirstName5");
        res.body.should.have.property("lastName", "testLastName5");
        res.body.should.have.property("email", "testEmail5");
        res.body.should.have.property("password", "testPassword5");
        res.body.should.have.property("phoneNumber", "0123456789");
        res.body.should.have.property("bio", "testBio testBio5");
        res.body.should.have.property("car", {
          reg: "AB25 AAA",
          make: "testMAke5",
          colour: "testColour5",
          tax_due_date: "2025-01-01",
        });
        res.body.should.have.property("identity_verification_status", false);
        res.body.should.have.property("driver_verification_status", true);
        res.body.should.have.property("licence_expiry_date", "");
        res.body.should.have.property("reports", []);
        done();
      });
  });
});
