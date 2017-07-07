//
//  DetailsViewController.swift
//  twitter_alamofire_demo
//
//  Created by Maxine Kwan on 7/5/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import ActiveLabel

class DetailsViewController: UIViewController {
    
    var tweet: Tweet!
    
    @IBOutlet weak var tweetTextLabel: ActiveLabel!
    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var favoriteCount: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tweet = tweet {
            nameLabel.text = tweet.user.name
            tweetTextLabel.text = tweet.text
            screenNameLabel.text = "@"+tweet.user.screenName
            profileView.af_setImage(withURL: tweet.user.profilePicURL)
            dateLabel.text = tweet.createdAtStringLong
            retweetCount.text = String(tweet.retweetCount)
            favoriteCount.text = String(tweet.favoriteCount)
            
            if tweet.favorited! {
                likeButton.isSelected = true
            }
            else {
                likeButton.isSelected = false
            }
            if tweet.retweeted! {
                retweetButton.isSelected = true
            }

            else {
                retweetButton.isSelected = false
            }
            
            tweetTextLabel.enabledTypes = [.mention, .hashtag, .url]
            tweetTextLabel.handleURLTap { (url) in
                UIApplication.shared.openURL(url)
            }
            tweetTextLabel.URLColor = UIColor(red:0.11, green:0.63, blue:0.95, alpha:1.0)
            tweetTextLabel.hashtagColor = UIColor(red:0.11, green:0.63, blue:0.95, alpha:1.0)
            tweetTextLabel.mentionColor = UIColor(red:0.11, green:0.63, blue:0.95, alpha:1.0)
            
            profileView.layer.borderWidth = 1
            profileView.layer.masksToBounds = false
            profileView.layer.borderColor = UIColor.white.cgColor
            profileView.layer.cornerRadius = profileView.frame.height/2
            profileView.clipsToBounds = true
        }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onLike(_ sender: Any) {
        if (tweet.favorited!) {
            tweet.favorited = false
            tweet.favoriteCount -= 1
            (sender as! UIButton).isSelected = false
            APIManager.shared.unfavorite(tweet!) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error unfavoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully unfavorited the following Tweet: \n\(tweet.text)")
                    self.favoriteCount.text = String(Int(self.favoriteCount.text!)!-1)
                }
            }
        }
        else {
            tweet.favorited = true
            tweet.favoriteCount += 1
            (sender as! UIButton).isSelected = true
            APIManager.shared.favorite(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully favorited the following Tweet: \n\(tweet.text)")
                    self.favoriteCount.text = String(Int(self.favoriteCount.text!)!+1)
                }
            }
        }
    }
    
    @IBAction func onRetweet(_ sender: Any) {
        if tweet.retweeted! {
            tweet.retweeted = false
            tweet.retweetCount -= 1
            (sender as! UIButton).isSelected = false
            APIManager.shared.unretweet(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error unretweeting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully unretweeted the following Tweet: \n\(tweet.text)")
                    self.retweetCount.text = String(Int(self.retweetCount.text!)!-1)
                }
            }
        }
        else {
            tweet.retweeted = true
            tweet.retweetCount += 1
            (sender as! UIButton).isSelected = true
            APIManager.shared.retweet(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error retweeting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully retweeted the following Tweet: \n\(tweet.text)")
                    self.retweetCount.text = String(Int(self.retweetCount.text!)!+1)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
