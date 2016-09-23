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
    let activityIndictor: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
    let label: UILabel = UILabel()
    let blurEffect = UIBlurEffect(style: .dark)
    let vibrancyView: UIVisualEffectView
    
    init(text: String) {
        self.text = text
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(effect: blurEffect)
        self.setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        self.text = ""
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(coder: aDecoder)!
        self.setup()
        
    }
    
    func setup() {
        contentView.addSubview(vibrancyView)
        vibrancyView.contentView.addSubview(activityIndictor)
        vibrancyView.contentView.addSubview(label)
        activityIndictor.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if let superview = self.superview {
            
            let width = superview.frame.size.width / 3.6
            let height: CGFloat = 90.0
            self.frame = CGRect(x: superview.frame.size.width / 2 - width / 2,
                                    y: superview.frame.height / 2 - height / 2,
                                    width: width,
                                    height: height)
            vibrancyView.frame = self.bounds
            
            let activityIndicatorSize: CGFloat = 70
            let deviceType = UIDevice.current.modelName
            if deviceType == "iPhone 5" || deviceType == "iPhone 5s" || deviceType == "iPhone SE" {
                activityIndictor.frame = CGRect(x: 9, y: height / 2 - activityIndicatorSize / 2 - 15,
                                                    width: activityIndicatorSize,
                                                    height: activityIndicatorSize)
            }
            else if deviceType == "iPhone 6" || deviceType == "iPhone 6s" || deviceType == "iPhone 7" {
            activityIndictor.frame = CGRect(x: 17, y: height / 2 - activityIndicatorSize / 2 - 15,
                                                width: activityIndicatorSize,
                                                height: activityIndicatorSize)
            }
            else if deviceType == "iPhone 6 Plus" || deviceType == "iPhone 6s Plus" || deviceType == "iPhone 7 Plus" {
                activityIndictor.frame = CGRect(x: 23, y: height / 2 - activityIndicatorSize / 2 - 15,
                                                    width: activityIndicatorSize,
                                                    height: activityIndicatorSize)
            }
            
            layer.cornerRadius = 8.0
            layer.masksToBounds = true
            label.text = text
            label.textAlignment = NSTextAlignment.center
            label.frame = CGRect(x: 7, y: 20, width: width - 10, height: height)
            label.textColor = UIColor.gray
            label.font = UIFont.boldSystemFont(ofSize: 16)
        }
    }
    
    func show() {
        self.isHidden = false
    }
    
    func hide() {
        self.isHidden = true
        UIApplication.shared.endIgnoringInteractionEvents()
    }

}
