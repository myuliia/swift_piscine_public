//
//  MyScrollView.swift
//  Pictures
//
//  Created by Mishchenko YULIIA on 10/4/19.
//  Copyright © 2019 Mishchenko YULIIA. All rights reserved.
//

import UIKit

class MyScrollView: UIViewController, UIScrollViewDelegate {
 
    @IBOutlet weak var scrollView: UIScrollView!
    var image : UIImage?
    var imageView : UIImageView?
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView = UIImageView(image: image)
        scrollView.addSubview(imageView!)
        scrollView.delegate = self
    }
    func setZoomScale() {
        var zoomMin = min(self.view.bounds.size.width / imageView!.bounds.size.width, self.view.bounds.size.height / imageView!.bounds.size.height);
        if (zoomMin > 1.0) {
            zoomMin = 1.0; }
        scrollView.minimumZoomScale = zoomMin;

    }
    override func viewWillLayoutSubviews() {
        setZoomScale()
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
