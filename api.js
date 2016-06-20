'use strict'

const PORT = 4000
const jsonServer = require('json-server')

// an expressjs server
const server = jsonServer.create()

// set the default middlewares
server.use(jsonServer.defaults())

const router = jsonServer.router('db.json')
server.use(router)

console.log('server running on ', PORT)
server.listen(PORT)
