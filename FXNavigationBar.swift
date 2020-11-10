//
//  WXMNavigationBar.swift
//  IM_Client_Swift
//
//  Created by wq on 2020/5/30.
//  Copyright © 2020 wq. All rights reserved.
//

import UIKit

class FXNavigationBar: UINavigationBar {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        UIView.performWithoutAnimation {
            self.subviews.first?.addSubview(self.fakeView)
            self.subviews.first?.insertSubview(backgroundImageView, aboveSubview: fakeView)
            self.subviews.first?.insertSubview(shadowImageView, aboveSubview: backgroundImageView)
            
            let top = (self.shadowImageView.superview?.bounds.size.height ?? 0.5) - 0.5
            let width = self.shadowImageView.superview?.bounds.size.width ?? 0
            
            self.fakeView.frame = self.fakeView.superview?.bounds ?? .zero;
            self.backgroundImageView.frame = self.backgroundImageView.superview?.bounds ?? .zero;
            self.shadowImageView.frame = CGRect(x: 0, y: top, width: width, height: 0.5)
        }
    }

    /// 更新导航栏颜色并显示
    public func uptebarColor(color: UIColor) {
        UIView.performWithoutAnimation {
            self.fakeView.subviews.last?.backgroundColor = color
            self.fakeView.alpha = 1
        }
    }

    /// 隐藏导航栏
    public func hidenFakeView() {
        UIView.performWithoutAnimation {
            self.fakeView.alpha = 0
        }
    }

    public lazy var fakeView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .light)
        var fakeView = UIVisualEffectView(effect: effect)
        fakeView.isUserInteractionEnabled = false
        fakeView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        return fakeView
    }()
    
    public lazy var backgroundImageView: UIImageView = {
        var backgroundImageView = UIImageView()
        backgroundImageView.isUserInteractionEnabled = false
        backgroundImageView.contentScaleFactor = 1.0
        backgroundImageView.contentMode = .scaleToFill
        backgroundImageView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        backgroundImageView.isHidden = true
        return backgroundImageView
    }()

    public lazy var shadowImageView: UIImageView = {
        var shadowImageView = UIImageView()
        shadowImageView.isUserInteractionEnabled = false
        shadowImageView.contentScaleFactor = 1.0
        shadowImageView.isHidden = true
        return shadowImageView
    }()

}
