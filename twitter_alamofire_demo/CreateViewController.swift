//
//  CreateViewController.swift
//  twitter_alamofire_demo
//
//  Created by Maxine Kwan on 7/3/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import RSKPlaceholderTextView

protocol CreateViewControllerDelegate: class {
    func did(post: Tweet)
}

class CreateViewController: UIViewController, UITextViewDelegate
{
    weak var delegate: CreateViewControllerDelegate?
    let charMaxCount = 140
    var count = 0

    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var composeTextView: RSKPlaceholderTextView!
    @IBOutlet weak var charCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        composeTextView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    func textViewDidChange(_ textView: UITextView) {
        count = textView.text.characters.count
        charCount.text = String(charMaxCount-count)
        if count > 120 {
            charCount.textColor = UIColor.red
            if count > 140 {
                shareButton.isEnabled = false
            }
            else {
                shareButton.isEnabled = true
            }
        }
        else {
            charCount.textColor = UIColor(red:0.11, green:0.63, blue:0.95, alpha:1.0)
        }
    }

    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }

    @IBAction func didTapPost(_ sender: Any) {
        APIManager.shared.composeTweet(with: composeTextView.text) { (tweet, error) in
            if let error = error {
                print("Error composing Tweet: \(error.localizedDescription)")
            } else if let tweet = tweet {
                self.delegate?.did(post: tweet)
                print("Compose Tweet Success!")
                self.dismiss(animated: true, completion: nil)
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
