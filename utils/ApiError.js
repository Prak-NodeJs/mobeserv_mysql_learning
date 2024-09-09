class ApiError extends Error{
    constructor(statusCode, msg){
        super(msg)
        this.statusCode = statusCode
        Error.captureStackTrace(this, this.constructor)
    }
}


module.exports = {ApiError}