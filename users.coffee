class User extends Model
  
class @Users extends Minimongoid
  @_collection = Meteor.users
  Meteor.users._transform = (doc) -> new User(doc)