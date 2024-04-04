/**
 * Rides.js
 *
 * @description :: A model definition represents a database table/collection.
 * @docs        :: https://sailsjs.com/docs/concepts/models-and-orm/models
 */

module.exports = {

  attributes: {
    id: {type: 'string', columnName: '_id' },
    to: {type: 'string', required: true },
    from: {type: 'string', required: true },
    to_region: {type: 'string', required: true },
    from_region: {type: 'string', required: true },
    driver_username: {type: 'string', required: true },
    rider_usernames: {type: 'json', required: false },
    available_seats: {type: 'number', required: true },
    carbon_emissions: {type: 'number', required: true },
    distance: {type: 'number', required: false },
    price: {type: 'number', required: true },
    map: {type: 'json', required: false },
    driver_rating: {type: 'number', required: false },
    rider_rating: {type: 'number', required: false, },
    date_and_time: {type: 'ref', required: true },
    chats: {type: 'json', required: false },
    __v: {type: 'string', required: false },

    //  ╔═╗╦═╗╦╔╦╗╦╔╦╗╦╦  ╦╔═╗╔═╗
    //  ╠═╝╠╦╝║║║║║ ║ ║╚╗╔╝║╣ ╚═╗
    //  ╩  ╩╚═╩╩ ╩╩ ╩ ╩ ╚╝ ╚═╝╚═╝


    //  ╔═╗╔╦╗╔╗ ╔═╗╔╦╗╔═╗
    //  ║╣ ║║║╠╩╗║╣  ║║╚═╗
    //  ╚═╝╩ ╩╚═╝╚═╝═╩╝╚═╝


    //  ╔═╗╔═╗╔═╗╔═╗╔═╗╦╔═╗╔╦╗╦╔═╗╔╗╔╔═╗
    //  ╠═╣╚═╗╚═╗║ ║║  ║╠═╣ ║ ║║ ║║║║╚═╗
    //  ╩ ╩╚═╝╚═╝╚═╝╚═╝╩╩ ╩ ╩ ╩╚═╝╝╚╝╚═╝

  },

};

