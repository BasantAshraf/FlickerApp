# FlickerApp

An app uses Flickr Api to search for images:

https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=YOURAPIKEY&format=json&nojsoncallback=1&text=cats&extras=url_o

example:
https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=a4f28588b57387edc18282228da39744&format=json&nojsoncallback=1&safe_search=1&per_page=60&text=kittens&page=1


- App build in MVVM.
- Only one library is used (KingFisher)
- Network: URLSession + Codable + Result
- SearchBar
- Infinite loading to search results


# App Structure: 
1- HomeViewController:

   search for an image and return results showns in a grid, it has infinite loading scroll.
   
2- SearchHistory:

   has cached keywords user searched for before.

3- PhotoDetails:

have image in large scale, user can zoom it in or out, using pinch gesture or by double tapping the image.
