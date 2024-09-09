const express = require('express')
const userRoute = express.Router()
const  {createUser, getUser, deleteUser,updateUser, getUsers} = require('../controller/user.controller')

userRoute.post('/', createUser)
userRoute.get('/', getUsers)
userRoute.get('/:id', getUser)
userRoute.patch('/:id', updateUser)
userRoute.delete('/:id', deleteUser)



module.exports = {userRoute}

