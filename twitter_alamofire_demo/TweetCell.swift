//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage
import ActiveLabel

protocol TweetCellDelegate: class {
    func tweetCell(_ tweetCell: TweetCell, didTap user: User)
}

class TweetCell: UITableViewCell {
    
    weak var delegate: TweetCellDelegate?
    
    @IBOutlet weak var tweetTextLabel: ActiveLabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoriteCount: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    
    var tweet: Tweet! {
        didSet {
            //Configures custom tweet cell
            nameLabel.text = tweet.user.name
            tweetTextLabel.text = tweet.text
            screenNameLabel.text = "@"+tweet.user.screenName
            profileView.af_setImage(withURL: tweet.user.profilePicURL)
            dateLabel.text = "• "+tweet.createdAtString
            retweetCount.text = String(tweet.retweetCount)
            favoriteCount.text = String(tweet.favoriteCount)
            
            tweetTextLabel.enabledTypes = [.mention, .hashtag, .url]
            tweetTextLabel.handleURLTap { (url) in
                UIApplication.shared.openURL(url)
            }
            tweetTextLabel.URLColor = UIColor(red:0.11, green:0.63, blue:0.95, alpha:1.0)
            tweetTextLabel.hashtagColor = UIColor(red:0.11, green:0.63, blue:0.95, alpha:1.0)
            tweetTextLabel.mentionColor = UIColor(red:0.11, green:0.63, blue:0.95, alpha:1.0)
            
            // Check if already favorited or retweeted
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
            
            
        }
    }
    
    func didTapUserProfile(_ sender: UITapGestureRecognizer) {
        delegate?.tweetCell(self, didTap: tweet.user)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Styles profile picture icons
        profileView.layer.borderWidth = 1
        profileView.layer.masksToBounds = false
        profileView.layer.borderColor = UIColor.white.cgColor
        profileView.layer.cornerRadius = profileView.frame.height/2
        profileView.clipsToBounds = true
        
        // Adds tap gesture recogniser to profile picture icons
        let profileTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapUserProfile(_:)))
        profileView.isUserInteractionEnabled = true
        profileView.addGestureRecognizer(profileTapGestureRecognizer)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
