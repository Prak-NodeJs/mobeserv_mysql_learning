const { executeQuery } = require("../config/db")
const { ApiError } = require("../utils/ApiError")

const createUser = async (req, res, next)=>{
    try {
        const {name, email,password,dob} = req.body
        const emailQuery = `SELECT * FROM USERS WHERE email = '${email}';`
        const isEmailExist = await executeQuery(emailQuery)
        if(isEmailExist.length>0){
            throw new ApiError(400, 'Email already exist')
        }
        const insertQuery = `INSERT INTO USERS (name, email, password, dob) values ('${name}','${email}','${password}','${dob}');`
        const data = await executeQuery(insertQuery)
        const userData = await executeQuery(`SELECT * FROM USERS WHERE userId = ${data.insertId}`)
        res.status(200).json({
            success:true,
            message:"User Retrived",
            data:userData
        })
    } catch (error) {
        next(error)
    }
}

const getUser = async (req, res, next)=>{
    try {
        const query = `SELECT * FROM USERS WHERE userId = ${req.params.id}`
        const data = await executeQuery(query)
        if(data.length<1){
            throw new ApiError(404, 'User not found')
        }
        res.status(200).json({
            success:true,
            message:"User Retrived",
            data
        })
    } catch (error) {
        next(error)
    }
}

const updateUser = async (req, res, next)=>{
    try {
        const {id} = req.params;
        const {name} = req.body;
        const query = `SELECT * FROM USERS WHERE userId = ${id}`
        const data = await executeQuery(query)
        if(data.length<1){
            throw new ApiError(404, 'User not found')
        }
        const updateQuery = `UPDATE USERS SET NAME = '${name}' WHERE userId = ${id}`
        await executeQuery(updateQuery)
        res.status(200).json({
            success:true,
            message:"User updated",
            data
        })
    } catch (error) {
        next(error)
    }
}

const deleteUser = async (req, res, next)=>{
    try {
        const {id} = req.params;
        const query = `SELECT * FROM USERS WHERE userId = ${id}`
        const data = await executeQuery(query)
        if(data.length<1){
            throw new ApiError(404, 'User not found')
        }
        const deleteQuery = `DELETE FROM USERS WHERE userId = ${id} `
        await executeQuery(deleteQuery)
        res.status(200).json({
            success:true,
            message:"User Deleted"
        })
    } catch (error) {
        next(error)
    }
}

const getUsers = async (req, res, next)=>{
    try {
        let query = `SELECT * FROM USERS;`
        if(req.query.name){
            query =`SELECT * FROM USERS WHERE name like '%${req.query.name}%'`
        }
        const data = await executeQuery(query)
        res.status(200).json({
            success:true,
            message:"User Retrived",
            data
        })
    } catch (error) {
        next(error)
    }
}


module.exports  = {
    createUser,getUser,updateUser,getUsers, deleteUser
}