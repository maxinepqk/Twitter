//
//  User.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/17/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import Foundation

class User {
    
    var dictionary: [String: Any]?
    var name: String
    var screenName: String
    var profilePicURL: URL
    var coverPicURL: URL?
    var description: String
    var followersCount: String
    var followingCount: String
    var location: String
    //var url: String
    
    init(dictionary: [String: Any]) {
        self.dictionary = dictionary
        name = dictionary["name"] as! String
        screenName = dictionary["screen_name"] as! String
        location = dictionary["location"] as! String
        profilePicURL = URL(string: dictionary["profile_image_url_https"] as! String)!
        if let coverURLString = dictionary["profile_banner_url"] as? String {
            let coverPicURL = URL(string: coverURLString)
            self.coverPicURL = coverPicURL
        }
        
        description = dictionary["description"] as! String
        followingCount = String(dictionary["friends_count"] as! Int)
        followersCount = String(dictionary["followers_count"] as! Int)
        //url = String(dictionary["url"])
        
    }
    
    private static var _current: User?
    static var current: User? {
        get {
            if _current == nil {
                let defaults = UserDefaults.standard
                if let userData = defaults.data(forKey: "currentUserData") {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! [String: Any]
                    _current = User(dictionary: dictionary)
                }
            }
            return _current
        }
        set (user) {
            _current = user
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
            }
        }
    }
}
