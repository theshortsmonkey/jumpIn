/**
 * Route Mappings
 * (sails.config.routes)
 *
 * Your routes tell Sails what to do each time it receives a request.
 *
 * For more information on configuring custom routes, check out:
 * https://sailsjs.com/anatomy/config/routes-js
 */

module.exports.routes = {
  "GET /distance/:username": "Rides.getUserDistance",
  "GET /carbon/:username": "Rides.getUserCarbon",
  "GET /spend/:username": "Rides.getUserSpend",

  "GET /users/:username": "Users.getUser",
  "PATCH /users/:username": "Users.patchUser",
  "DELETE /users/:username": "Users.deleteUser",

  "GET /users/:username/image": "Users.imageDownload",
  "POST /users/:username/image": "Users.imageUpload",
  "DELETE /users/:username/image": "Users.imageDelete",

  "GET /": "Home.endpoints",
  "POST /rides/:ride_id/messages": "Rides.postMessage",
  "GET /rides/:ride_id/:username/messages": "Rides.getMessages",
};
