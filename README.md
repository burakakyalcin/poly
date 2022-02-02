# poly

Poly is an app that allows its users to draw polygons on the map and calculates their areas and displays to the user.

## Known issues
- The app is not able calculate the center point of the drawn shape, it's just doing a point area calculation but the shape of the earth should also be taken into account.
- After launching the app, saved polygons are fetched from CoreData but since the coordinates of the perimeter of the polygon is not in order the app cannot draw them properly.
- We only request a user location once and then center the map to the user's location, however if user starts drawing the shape and then the location info is received, the app will change the region to user's location.
