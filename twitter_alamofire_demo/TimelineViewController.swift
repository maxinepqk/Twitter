//
//  TimelineViewController.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import ActiveLabel

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CreateViewControllerDelegate, TweetCellDelegate, UIScrollViewDelegate {
    
    var tweets: [Tweet] = []
    var isMoreDataLoading = false

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        
        refresh()
    }
    
//    func loadMoreData() {
//        
//        // ... Create the NSURLRequest (myRequest) ...
//        
//        // Configure session so that completion handler is executed on main UI thread
//        let session = URLSession(configuration: URLSessionConfiguration.default,
//                                 delegate:nil,
//                                 delegateQueue:OperationQueue.main
//        )
//        let task : URLSessionDataTask = session.dataTask(with: myRequest, completionHandler: { (data, response, error) in
//            
//            // Update flag
//            self.isMoreDataLoading = false
//            
//            // ... Use the new data to update the data source ...
//            
//            // Reload the tableView now that there is new data
//            self.myTableView.reloadData()
//        })
//        task.resume()
//    }
//    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if (!isMoreDataLoading) {
//            let scrollViewContentHeight = tableView.contentSize.height
//            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
//            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
//                isMoreDataLoading = true
//                loadMoreData()
//            }
//        }
//    }
    
    
    func tweetCell(_ tweetCell: TweetCell, didTap user: User) {
        performSegue(withIdentifier: "timelineToProfile", sender: user)
    }
    
    func did(post: Tweet) {
        refresh()
    }
    
    
    func refresh() {
        APIManager.shared.getHomeTimeLine { (tweets, error) in
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
            } else if let error = error {
                print("Error getting home timeline: " + error.localizedDescription)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        cell.tweet = tweets[indexPath.row]
        cell.retweetButton.tag = indexPath.row
        cell.likeButton.tag = indexPath.row
        cell.delegate = self
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "timelineToCreate"{
            let navVC = segue.destination as! UINavigationController
            let createViewController = navVC.childViewControllers[0] as! CreateViewController
            createViewController.delegate = self
        }
        else if segue.identifier == "timelineToDetails" {
            let cell = sender as! UITableViewCell
            if let indexPath = tableView.indexPath(for: cell) {
                let tweet = tweets[indexPath.row]
                let detailsViewController = segue.destination as! DetailsViewController
                detailsViewController.tweet = tweet
            }
        }
        else if segue.identifier == "timelineToProfile" {
            let user = sender as! User
            let profileViewController = segue.destination as! ProfileViewController
            profileViewController.user = user
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didTapLogout(_ sender: Any) {
        APIManager.shared.logout()
    }
    
}
