/**
 * HomeController
 *
 * @description :: Server-side actions for handling incoming requests.
 * @help        :: See https://sailsjs.com/docs/concepts/actions
 */

const { createReadStream } = require('fs')

module.exports = {
    endpoints: async (req, res) => {
        createReadStream('./endpoints.json').pipe(res);
     }
};
