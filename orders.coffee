# single order logic
class Order extends Model
  constructor: (doc)->
    super(doc)
    # @quantity = 20
    
  dateString: -> 
    new Date(@date)
    

  match: (order) ->
    order.ticker is @ticker and order.type is @opposite() and @priceMatch order.price
  
    
class Bid extends Order
  opposite: -> 'ask'
  priceMatch: (askPrice) -> askPrice <= @price
  
class Ask extends Order
  opposite: -> 'bid'
  priceMatch: (bidPrice) -> bidPrice >= @price

# multiple orders collection logic
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
    
  @bestBid: (ticker) ->
    @bids(ticker, 1)[0]
    
  @bestAsk: (ticker) ->
    @asks(ticker, 1)[0]
    
  @tradeBid
  #to do, what happens if the bid gets traded twice,, transactions
  
    
  @match: (ticker) ->
    isMatch = @bestBid(ticker)?.match @bestAsk(ticker)
    if isMatch
      console.log "it's a match! we should pop the bids and create a transaction here"
    else
      console.log "it is not a match, leave brittany alone!"
    console.log "match for #{ticker} is #{isMatch}"
      
  @book: (ticker, limit = 20) ->
    bids = (b.price for b in @bids ticker, limit)
    asks = (a.price for a in @asks ticker, limit)
    console.log 'bids', bids
    [bids, asks]
    
  @generateTestData: -> # Remove this later for production
    console.log "There are #{@count()} orders in database right now"
    if Meteor.isServer and @count() is 0
      console.log "seeding orders with dummy data"
      for ticker, index in ["pinterest", "tokbox", "meteor", "twitter"]
        for i in [1..4]
          Orders.create ticker: ticker, type: 'bid', price: 100 + i - (index+1)*2, quantity: 1, date: Date.now()
          Orders.create ticker: ticker, type: 'ask', price: 100 - i + (index+1)*2, quantity: 1, date: Date.now()
      
    
if Meteor.isServer
  Orders.generateTestData()
  
  
if Meteor.isClient
  # Orders = Meteor.subscribe "orders"
  
  Template.orders.helpers
    all: (something, options)-> #Orders.all() # Orders.find()
      console.log something, options
      console.log @
      Orders.bids 'twitter'
    bids: (ticker) -> Oders.bids(ticker)
    
