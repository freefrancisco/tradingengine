class Order extends Model
  dateString: -> 
    new Date(@date)
    
class Bid extends Order
  
class Ask extends Order

class @Orders extends Minimongoid
  @_collection = new Meteor.Collection "orders", 
    transform: (doc) -> 
      switch doc.type
        when 'ask' then new Ask(doc)
        when 'bid' then new Bid(doc)
        else new Order(doc) 
          
  @bids: (ticker, limit = 20) ->
    bids = @where ticker: ticker, type: 'bid',
      sort: {price: -1}, limit: limit
    bids.fetch()
      
  @asks: (ticker, limit = 20) ->
    asks = @where ticker: ticker, type: 'ask',
      sort: {price: 1}, limit: limit
    asks.fetch()
      
  @book: (ticker, limit = 20) ->
    bids = (b.price for b in @bids ticker, limit)
    asks = (a.price for a in @asks ticker, limit)
    console.log 'bids', bids
    [bids, asks]
    
  

if Meteor.isServer
  console.log "orders: #{Orders.count()}"
  if Orders.count() is 0 
    console.log "seeding orders with dummy data for now"
    for ticker, index in ["pinterest", "tokbox", "meteor", "twitter"]
      for i in [1..4]
        Orders.create ticker: ticker, type: 'bid', price: 100 - i - (index+1)*2, quantity: 1, date: Date.now()
        Orders.create ticker: ticker, type: 'ask', price: 100 + i + (index+1)*2, quantity: 1, date: Date.now()
      
if Meteor.isClient
  console.log "client"
  # Orders = Meteor.subscribe "orders"
  
  Template.orders.helpers
    all: -> Orders.all() # Orders.find()
    
