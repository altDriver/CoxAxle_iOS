//
//  UIActivityIndicatorView+ActivityClass.swift
//  CoxAxle
//
//  Created by Prudhvi on 27/07/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit
import Foundation

class UIActivityIndicatorView_ActivityClass: UIVisualEffectView {
    
    var text: String? {
        didSet {
            label.text = text
        }
    }
    let activityIndictor: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
    let label: UILabel = UILabel()
    let blurEffect = UIBlurEffect(style: .Dark)
    let vibrancyView: UIVisualEffectView
    
    init(text: String) {
        self.text = text
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(forBlurEffect: blurEffect))
        super.init(effect: blurEffect)
        self.setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        self.text = ""
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(forBlurEffect: blurEffect))
        super.init(coder: aDecoder)!
        self.setup()
        
    }
    
    func setup() {
        contentView.addSubview(vibrancyView)
        vibrancyView.contentView.addSubview(activityIndictor)
        vibrancyView.contentView.addSubview(label)
        activityIndictor.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if let superview = self.superview {
            
            let width = superview.frame.size.width / 3.6
            let height: CGFloat = 90.0
            self.frame = CGRectMake(superview.frame.size.width / 2 - width / 2,
                                    superview.frame.height / 2 - height / 2,
                                    width,
                                    height)
            vibrancyView.frame = self.bounds
            
            let activityIndicatorSize: CGFloat = 70
            let deviceType = UIDevice.currentDevice().modelName
            if deviceType == "iPhone 5" || deviceType == "iPhone 5s" {
                activityIndictor.frame = CGRectMake(17, height / 2 - activityIndicatorSize / 2 - 15,
                                                    activityIndicatorSize,
                                                    activityIndicatorSize)
            }
            else if deviceType == "iPhone 6" || deviceType == "iPhone 6s" {
            activityIndictor.frame = CGRectMake(17, height / 2 - activityIndicatorSize / 2 - 15,
                                                activityIndicatorSize,
                                                activityIndicatorSize)
            }
            else if deviceType == "iPhone 6 Plus" || deviceType == "iPhone 6s Plus" {
                activityIndictor.frame = CGRectMake(23, height / 2 - activityIndicatorSize / 2 - 15,
                                                    activityIndicatorSize,
                                                    activityIndicatorSize)
            }
            
            layer.cornerRadius = 8.0
            layer.masksToBounds = true
            label.text = text
            label.textAlignment = NSTextAlignment.Center
            label.frame = CGRectMake(7, 20, width - 10, height)
            label.textColor = UIColor.grayColor()
            label.font = UIFont.boldSystemFontOfSize(16)
        }
    }
    
    func show() {
        self.hidden = false
    }
    
    func hide() {
        self.hidden = true
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }

}