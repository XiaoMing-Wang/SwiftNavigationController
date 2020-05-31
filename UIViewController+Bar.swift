//
//  UIViewController+Bar.swift
//  IM_Client_Swift
//
//  Created by wq on 2020/5/30.
//  Copyright © 2020 wq. All rights reserved.
//
import UIKit
import Foundation

fileprivate var barColorKey :Void?
fileprivate var barTitleColorKey :Void?
fileprivate var barAlphaKey :Void?
fileprivate var barHiddenKey :Void?
fileprivate var barSwipeEnabledKey :Void?

extension UIViewController {
    
    /// 导航栏颜色
    var barColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, &barColorKey) as? UIColor
        }
        
        set {
            objc_setAssociatedObject(self, &barColorKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// title颜色
    var barTitleColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, &barTitleColorKey) as? UIColor
        }
        
        set {
            objc_setAssociatedObject(self, &barTitleColorKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
        
    /// 导航栏透明度
    var barAlpha: CGFloat {
        get {
            return objc_getAssociatedObject(self, &barAlphaKey) as? CGFloat ?? 1.0
        }
        
        set {
            objc_setAssociatedObject(self, &barAlphaKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// 导航栏透明度
    var barHidden: Bool {
        get {
            return objc_getAssociatedObject(self, &barHiddenKey) as? Bool ?? false
        }
        
        set {
            self.barColor = UIColor.white.withAlphaComponent(0.0)
            objc_setAssociatedObject(self, &barHiddenKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// 导航栏滑动返回
    var barSwipeEnabled: Bool {
        get {
            return (objc_getAssociatedObject(self, &barSwipeEnabledKey) as? Bool) ?? true
        }
        
        set {
            objc_setAssociatedObject(self, &barSwipeEnabledKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    
    
}

