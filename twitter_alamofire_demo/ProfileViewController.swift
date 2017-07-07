//
//  ProfileViewController.swift
//  twitter_alamofire_demo
//
//  Created by Maxine Kwan on 7/5/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tweets: [Tweet] = []
    var user: User!
    let currentUser = User.current
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profilePicView: UIImageView!
    @IBOutlet weak var coverPicView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var followersCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if user == nil {
            user = User.current
        }
        
        profilePicView.af_setImage(withURL: user.profilePicURL)
        if let url = user.coverPicURL {
            coverPicView.af_setImage(withURL: url)
        }
        nameLabel.text = user.name
        screenNameLabel.text = "@"+user.screenName
        bioLabel.text = user.description
        followersCount.text = user.followersCount
        followingCount.text = user.followingCount
        
        if let currentUser = currentUser {
            if user.screenName != currentUser.screenName {
                editProfileButton.isHidden = true
            }
        }
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        refresh()
        
        // Do any additional setup after loading the view.
    }
    
    func setCurrentUser(){
        user = User.current
    }
    
    func refresh() {
        APIManager.shared.getUserTimeLine(user!) { (tweets, error) in
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
            } else if let error = error {
                print("Error getting user timeline: " + error.localizedDescription)
            }
        }
    }

    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        refresh()
        refreshControl.endRefreshing()
    }
    

    @IBAction func onLike(_ sender: Any) {
        let cellRow = (sender as! UIButton).tag
        let tweet = tweets[cellRow]
        if tweet.favorited! {
            tweet.favorited = false
            tweet.favoriteCount -= 1
            (sender as! UIButton).isSelected = false
            APIManager.shared.unfavorite(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error unfavoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully unfavorited the following Tweet: \n\(tweet.text)")
                    self.refresh()
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
                    self.refresh()
                }
            }
        }
    }
    
    @IBAction func onRetweet(_ sender: Any) {
        let cellRow = (sender as! UIButton).tag
        let tweet = tweets[cellRow]
        if tweet.retweeted! {
            tweet.retweeted = false
            tweet.retweetCount -= 1
            (sender as! UIButton).isSelected = false
            APIManager.shared.unretweet(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error unretweeting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully unretweeted the following Tweet: \n\(tweet.text)")
                    self.refresh()
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
                    self.refresh()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTweetCell", for: indexPath) as! TweetCell
        
        cell.tweet = tweets[indexPath.row]
        cell.retweetButton.tag = indexPath.row
        cell.likeButton.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileToDetails"{
            let cell = sender as! UITableViewCell
            if let indexPath = tableView.indexPath(for: cell) {
                let tweet = tweets[indexPath.row]
                let detailsViewController = segue.destination as! DetailsViewController
                detailsViewController.tweet = tweet
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
