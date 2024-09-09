const express = require('express')
const dotenv = require('dotenv')
dotenv.config({})
const {dbConnection} = require('./config/db')

const { userRoute } = require('./routes/user.route')
 
const app = express()


app.use(express.json())

//db connection
dbConnection()

//routes
app.use('/api/user', userRoute)


//error
// app.use((error, req, res)=>{
//   const message = error.message || 'Internal Server Error'
//   const statusCode = error.statusCode || 500
//   res.status(statusCode).json({
//     success:false,
//     message
//   })
// })

// Error handling middleware for other errors
app.use((err, req, res, next) => {
  const statusCode = err.statusCode || 500;
  const message = err.message || 'Internal server error';
  res.status(statusCode).json({ success: false, message });
  next();
});

const PORT = process.env.PORT || 3000

app.listen(PORT, ()=>{
    console.log(`Server is running on port ${PORT}`)
})