const mysql = require('mysql2/promise');
const { ApiError } = require('../utils/ApiError');

let connection;

const dbConnection = async () => {
    try {
        connection = await mysql.createConnection({
            host: process.env.DB_HOST,
            user: process.env.DB_USERNAME,
            password: process.env.DB_PASSWORD,
            database: process.env.DB_DATABASE
        })
        console.log('connected to mysql')
    } catch (error) {
        console.log(`Error while connecting to db ${error}`)
    }
}

const executeQuery = async (query) => {
    try {
        const result = await connection.query(query)
        return result[0]
    } catch (error) {
        throw new ApiError(400, error.sqlMessage)
    }
}

module.exports = {
    dbConnection, executeQuery
}
