//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var tweetTextLabel: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoriteCount: UILabel!
    
    var tweet: Tweet! {
        didSet {
            nameLabel.text = tweet.user.name
            tweetTextLabel.text = tweet.text
            screenNameLabel.text = tweet.user.screenName
            profileView.af_setImage(withURL: tweet.user.profilePicURL)
            dateLabel.text = tweet.createdAtString
            retweetCount.text = String(tweet.retweetCount)
            favoriteCount.text = String(describing: tweet.favoriteCount)
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
