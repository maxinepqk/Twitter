//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

protocol TweetCellDelegate: class {
    func tweetCell(_ tweetCell: TweetCell, didTap user: User)
}

class TweetCell: UITableViewCell {
    
    weak var delegate: TweetCellDelegate?
    
    @IBOutlet weak var tweetTextLabel: UITextView!
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
            nameLabel.text = tweet.user.name
            tweetTextLabel.text = tweet.text
            screenNameLabel.text = "@"+tweet.user.screenName
            profileView.af_setImage(withURL: tweet.user.profilePicURL)
            dateLabel.text = "• "+tweet.createdAtString
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
            
            
        }
    }
    
    func didTapUserProfile(_ sender: UITapGestureRecognizer) {
        delegate?.tweetCell(self, didTap: tweet.user)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        profileView.layer.borderWidth = 1
        profileView.layer.masksToBounds = false
        profileView.layer.borderColor = UIColor.white.cgColor
        profileView.layer.cornerRadius = profileView.frame.height/2
        profileView.clipsToBounds = true
        
        let profileTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapUserProfile(_:)))
        profileView.isUserInteractionEnabled = true
        profileView.addGestureRecognizer(profileTapGestureRecognizer)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
