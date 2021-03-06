if Meteor.isClient
  Meteor.Router.add 
    '/'       : 'home'
    '/orders' : 'orders'
    '/bids/:ticker'   : 'bids'

if Meteor.isServer
  Meteor.Router.add
    '/api/orders' : JSON.stringify Orders.all().fetch()
