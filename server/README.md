# GyveProto Server

## API

### User info endpoints

* GET /user/[id]
  * Takes a user id associated with a Facebook account and returns user data
  * If user for id does not exist, a new user is created with default data

### Thing info endpoints

* GET /thingIds
  * Returns an array of ids for all items stored in the database
  * This will eventually be responsible for returning ids based on user information (location, karma, etc.)

* GET /thing/[id]
  * Takes an id (acquired by the /thingIds call) and returns the image data for the associated item

* POST /image
  * Takes a post body of image data and saves the image to the database

### Admin endpoints

* GET /admin
  * Renders html page listing the contents of the database; links for individual items use other admin endpoints

* GET /admin/removeUser/[id]
  * Removes user from the database with the specified Facebook id

* GET /admin/removeImage/[id]
  * Removes image from the database with the specified id