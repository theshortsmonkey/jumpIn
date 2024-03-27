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
    'GET /distance/:id': 'Rides.distance',
    'GET /users/:username/image': 'Users.imageDownload',
    'POST /users/:username/image': 'Users.imageUpload'
};
