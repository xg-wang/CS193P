//
//  TweetImageTableViewCell.swift
//  Smashtag
//
//  Created by Xingan Wang on 8/16/16.
//  Copyright © 2016 Xingan Wang. All rights reserved.
//

import UIKit

class TweetImageTableViewCell: UITableViewCell {
    
    // MARK - Model
    var imageUrl: NSURL? { didSet { updateUI() } }
    var imageData: UIImage? { return tweetImage.image }
    
    @IBOutlet weak var tweetImage: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private func updateUI() {
        tweetImage.image = nil
        if let url = imageUrl {
            spinner.startAnimating()
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                let imageData = NSData(contentsOfURL: url)
                dispatch_async(dispatch_get_main_queue()) { [weak weakSelf = self] in
                    if url == weakSelf?.imageUrl {
                        if let image = imageData {
                            weakSelf?.tweetImage.image = UIImage(data: image)
                        }
                        weakSelf?.spinner.stopAnimating()
                    }
                }
            }
        }
    }
    
}
