//
//  FlickrManager.swift
//  WhoopProject
//
//  Created by Robbie Pritchard on 6/14/18.
//  Copyright © 2018 Robbie Pritchard. All rights reserved.
//

import Foundation

struct FlickrMediaItem: Codable{
    var m: String
}
struct FlickrItem: Codable{
    var media: FlickrMediaItem
    var published: String
    var tags: String
    var title: String
}
struct Flickr: Codable {
    var items: [FlickrItem]
}


enum CompletionResult{
    case Success(items: [FlickrItem])
    case Failure(errorMessage: String)
}

class FlickrManager{
    
    static let shared = FlickrManager()
    private var internetError = "Check internet connection and try later."
    
    private func getURL(withTag tag: String?) -> URL?{
        //get url
        var url: URL?
        if let tag = tag{
            let urlString = "https://api.flickr.com/services/feeds/photos_public.gne?tags=\(tag)&;tagmode=any&format=json&nojsoncallback=1"
            url = URL(string: urlString)
        }
        else{
            url = URL(string: "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1")
        }
        return url
    }

    
    func getImages(withTag tag: String?, completion: @escaping (CompletionResult)->()){
        // make sure url is valid
        guard let flickrURL = getURL(withTag: tag) else{
            completion(.Failure(errorMessage: self.internetError))
            return
        }
        
        URLSession.shared.dataTask(with: flickrURL) { (data, response, error) in
            guard error == nil else {
                completion(.Failure(errorMessage: self.internetError))
                return
            }
            //make sure we have data
            guard let data = data else {
                completion(.Failure(errorMessage: self.internetError))
                return
            }
            
            //decode json
            do {
                let flickr = try JSONDecoder().decode(Flickr.self, from: data)
                completion(.Success(items: flickr.items))
                
            } catch let error {
                print(error)
                completion(.Failure(errorMessage: error.localizedDescription))
            }
        }.resume()
    }
}

//Sample JSON Response
//{
//    author = "nobody@flickr.com (\"computersreborn\")";
//    "author_id" = "142151212@N03";
//    "date_taken" = "2018-06-14T15:12:09-08:00";
//    description = " <p><a href=\"https://www.flickr.com/people/computersreborn/\">computersreborn</a> posted a photo:</p> <p><a href=\"https://www.flickr.com/photos/computersreborn/41899979115/\" title=\"20180614_151209\"><img src=\"https://farm1.staticflickr.com/879/41899979115_e9ff763284_m.jpg\" width=\"240\" height=\"155\" alt=\"20180614_151209\" /></a></p> <p>We repair Macs! Call for more information!</p>";
//    link = "https://www.flickr.com/photos/computersreborn/41899979115/";
//    media =     {
//        m = "https://farm1.staticflickr.com/879/41899979115_e9ff763284_m.jpg";
//    };
//    published = "2018-06-14T19:18:28Z";
//    tags = "computer repair apple macbook macrepair desktop laptop memory upgrade cracked screen water damage";
//    title = "20180614_151209";
//}
