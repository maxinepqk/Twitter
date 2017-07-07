//
//  EditProfileViewController.swift
//  twitter_alamofire_demo
//
//  Created by Maxine Kwan on 7/6/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import RSKPlaceholderTextView
import AlamofireImage

class EditProfileViewController: UIViewController {
    
    let user = User.current

    @IBOutlet weak var profilePicView: UIImageView!
    @IBOutlet weak var coverPicView: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var websiteText: UITextField!
    @IBOutlet weak var bioText: RSKPlaceholderTextView!
    
    
    @IBAction func onCamera(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePicView.layer.borderWidth = 1
        profilePicView.layer.masksToBounds = false
        profilePicView.layer.borderColor = UIColor.white.cgColor
        profilePicView.layer.cornerRadius = profilePicView.frame.height/2
        profilePicView.clipsToBounds = true
        
        profilePicView.af_setImage(withURL: (user?.profilePicURL)!)
        if let url = user?.coverPicURL {
            coverPicView.af_setImage(withURL: url)
        }
        
        nameText.text = user?.name
        locationText.text = user?.location
        bioText.text = user?.description
        //websiteText.text = user?.url
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSave(_ sender: Any) {
        user?.name = nameText.text!
        user?.location = locationText.text!
        user?.description = bioText.text!
        //user?.url = websiteText.text!
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
