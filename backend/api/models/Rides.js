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
    driver_username: {type: 'string', required: true },
    rider_usernames: {type: 'string', required: true },
    available_seats: {type: 'string', required: true },
    carbon_emissions: {type: 'string', required: true },
    distance: {type: 'string', required: true },
    price: {type: 'string', required: true },
    map: {type: 'boolean', required: true },
    driver_rating: {type: 'boolean', required: true },
    rider_rating: {type: 'string', required: true },
    date_and_time: {type: 'string', required: true },
    chats: {type: 'string', required: true },
    __v: {type: 'string', required: true },

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

