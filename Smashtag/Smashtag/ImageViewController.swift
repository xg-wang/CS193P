//
//  ImageViewController.swift
//  Smashtag
//
//  Created by Xingan Wang on 8/31/16.
//  Copyright © 2016 Xingan Wang. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    var imageURL: NSURL? {
        didSet {
            image = nil
            // we'll postpone our (expensive) fetch
            // until we know we're going to appear on screen
            // (we know this below in viewWillAppear)
            // otherwise why waste the resources?
            if view.window != nil {
                fetchImage()
            }
        }
    }
    
    private func fetchImage() {
        if let url = imageURL {
            // fire up the spinner
            // because we're about to fork something off on another thread
            spinner?.startAnimating()
            // put a closure on the "user initiated" system queue
            // this closure does NSData(contentsOfURL:) which blocks
            // waiting for network response
            // it's fine for it to block the "user initiated" queue
            // because that's a concurrent queue
            // (so other closures on that queue can run concurrently even as this one's blocked)
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                let contentsOfURL = NSData(contentsOfURL: url) // blocks! can't be on main queue!
                // now that we got the data from the network
                // we want to put it up in the UI
                // but we can only do that on the main queue
                // so we queue up a closure here to do that
                dispatch_async(dispatch_get_main_queue()) {
                    // since it could take a long time to fetch the image data
                    // we make sure here that the image we fetched
                    // is still the one this ImageViewController wants to display!
                    // you must always think of these sorts of things
                    // when programming asynchronously
                    if url == self.imageURL {
                        if let imageData = contentsOfURL {
                            self.image = UIImage(data: imageData)
                            // image's set will stop the spinner animating
                        } else {
                            self.spinner?.stopAnimating()
                        }
                    }
                }
            }
        }
    }
    
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size
            // all three of the next lines of code
            // are necessary to make zooming work
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 5.0
        }
    }
    
    // zooming will not work if you don't implement
    // this UIScrollViewDelegate method
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    private var imageView = UIImageView()
    
    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
            spinner?.stopAnimating()
            autoScale()
        }
    }
    
    private var scrollViewDidScrollOrZoom = false
    func scrollViewDidScroll(scrollView: UIScrollView) {
        scrollViewDidScrollOrZoom = true
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        scrollViewDidScrollOrZoom = true
    }
    private func autoScale() {
        if scrollViewDidScrollOrZoom {
            return
        }
        if let sv = scrollView {
            if image != nil {
                sv.zoomScale = max(sv.bounds.size.height / image!.size.height,
                                   sv.bounds.size.width / image!.size.width)
                sv.contentOffset = CGPoint(x: (imageView.frame.size.width - sv.frame.size.width) / 2,
                                           y: (imageView.frame.size.height - sv.frame.size.height) / 2)
                scrollViewDidScrollOrZoom = false
            }
        }
    }
    
    // MARK: View Controller Lifecycle
    
    // we know we're going to go on screen in this method
    // so we can no longer wait to fire off our (expensive) image fetch
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil {
            fetchImage()
        }
    }
    
    // note that we build some of our UI in the storyboard
    // by dragging a UIScrollView out into our scene
    // and we build some of it here by adding our UIImageView
    // as a subview of the UIScrollView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        autoScale()
    }
}
