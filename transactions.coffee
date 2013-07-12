class Transaction extends Model
  
class @Transactions extends Minimongoid
  @_collection = new Meteor.Collection "transactions", 
    transform: (doc) ->  new Transaction(doc)
