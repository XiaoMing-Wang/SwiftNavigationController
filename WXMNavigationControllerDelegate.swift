//
//  WXMNavigationControllerDelegate.swift
//  IM_Client_Swift
//
//  Created by wq on 2020/5/30.
//  Copyright © 2020 wq. All rights reserved.
//

import UIKit

class WXMNavigationControllerDelegate: UIScreenEdgePanGestureRecognizer, UINavigationControllerDelegate, UIGestureRecognizerDelegate {

    var proxiedDelegate: UINavigationControllerDelegate!
    var navigation: WXMNavigationViewController!

    init(navigation: WXMNavigationViewController) {
        super.init(target: nil, action: nil)
        self.navigation = navigation
        self.navigation.interactivePopGestureRecognizer?.delegate = self
        self.navigation.interactivePopGestureRecognizer?.isEnabled = false
        self.isEnabled = false
    }

    /// 即将出现
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {

        let coordinator: UIViewControllerTransitionCoordinator? = navigationController.transitionCoordinator
        self.navigation.transitional = true

        if coordinator != nil {
            showController(viewController: viewController, coordinator: coordinator!)
        } else {
            if animated == false && self.navigation.children.count > 1 { return }
            self.navigation.updateNavigationBarForViewController(viewController: viewController)
        }
    }

    /// 完成出现
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {

        self.navigation.transitional = false
        self.navigation.poppingViewController = nil
        self.navigation.updateNavigationBarForViewController(viewController: viewController)
        self.navigation.updateNavigationFinash(viewController: viewController)
        if animated == false { self.navigation.clearFake() }
        if navigationController.viewControllers.count == 1 {
            navigationController.interactivePopGestureRecognizer?.isEnabled = false
        }
    }

    /// 设置导航栏颜色并且设置透明度为0
    func showController(viewController: UIViewController, coordinator: UIViewControllerTransitionCoordinator) {
        let from = coordinator.viewController(forKey: .from)
        let to = coordinator.viewController(forKey: .to)

        if from == nil || to == nil { return }
        coordinator.animate(alongsideTransition: { (context) in

            self.navigation.updateNavigationBarForViewController(viewController: viewController)
            let shouldFake = shouldShowFake(viewController, from!, to!)
            if shouldFake { self.navigation.showFakeBar(from!, to!) }

        }) { (coordinatorContext) in

            self.navigation.clearFake()
            self.navigation.transitional = false
            self.navigation.poppingViewController = nil;
            if coordinatorContext.isCancelled {
                self.navigation.updateNavigationBarForViewController(viewController: from!)
                self.navigation.updateNavigationFinash(viewController: from!)
            } else {
                self.navigation.updateNavigationBarForViewController(viewController: viewController)
                self.navigation.updateNavigationFinash(viewController: viewController)
            }
            
        }
    }
    
}

