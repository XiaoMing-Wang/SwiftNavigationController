//
//  WDNavigationViewController.swift
//  IM_Client_Swift
//
//  Created by wq on 2020/5/30.
//  Copyright © 2020 wq. All rights reserved.
//

import UIKit

fileprivate var barTinFont: UIFont = .boldSystemFont(ofSize: 17)
fileprivate var barTinColor: UIColor = .black
class WDWrapNavigationViewController: UINavigationController {

    weak var poppingViewController: UIViewController?
    var transitional: Bool = false
    var navigationDelegate: WDWrapNavigationControllerDelegate?

    override required init(rootViewController: UIViewController) {
        super.init(navigationBarClass: WDNavigationBar.self, toolbarClass: nil)
        self.viewControllers = [rootViewController]
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
      
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.isTranslucent = true
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationDelegate = WDWrapNavigationControllerDelegate(navigation: self)
        
        /** 原来的代理 */
        self.navigationDelegate?.proxiedDelegate = self.delegate
        self.delegate = self.navigationDelegate
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let coordinator: UIViewControllerTransitionCoordinator? = self.transitionCoordinator
        if (coordinator != nil) {
            self.updateNavigationBarForViewController(viewController: self.topViewController!)
        }
    }

    override func popViewController(animated: Bool) -> UIViewController? {
        self.poppingViewController = self.topViewController
        return super.popViewController(animated: animated)
    }

    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        self.poppingViewController = self.topViewController
        return super.popToViewController(viewController, animated: animated)
    }

    @discardableResult
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        self.poppingViewController = self.topViewController
        return super.popToRootViewController(animated: animated)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
    }

    public func updateNavigationBarForViewController(viewController: UIViewController) {
        self.updateNavigationBarColorOrImageForViewController(viewController: viewController)
        self.updateNavigationBarAnimatedForViewController(viewController: viewController)
    }
    
    //MARK: 回调
    /// 设置属性
    public func updateNavigationBarColorOrImageForViewController(viewController: UIViewController) {
        let color = viewController.barTitleColor ?? barTinColor
        let attributes = [.font: barTinFont, NSAttributedString.Key.foregroundColor: color]
        self.navigationbar().titleTextAttributes = attributes
        self.interactivePopGestureRecognizer?.isEnabled = viewController.barSwipeEnabled
    }

    ///  设置导航栏为顶部的vc的属性
    func updateNavigationBarAnimatedForViewController(viewController: UIViewController) {
        if viewController.barHidden {
            self.navigationbar().hidenFakeView()
        } else if !viewController.barHidden && viewController.barColor != nil {
            self.navigationbar().uptebarColor(color: viewController.barColor!)
        }
    }

    /// 转场动画完成结束
    public func updateNavigationFinash(viewController: UIViewController) {
        if viewController.barHidden {
            self.navigationbar().hidenFakeView()
        }
        
        if self.viewControllers.count == 1 {
            self.interactivePopGestureRecognizer?.isEnabled = false
        }
    }

    public func showFakeBar(_ from: UIViewController, _ to: UIViewController) {
        UIView.setAnimationsEnabled(false)
        self.navigationbar().fakeView.alpha = 0
        self.navigationbar().shadowImageView.alpha = 0
        self.navigationbar().backgroundImageView.alpha = 0
        self.showFakeBarFrom(from)
        self.showFakeBarTo(to)
        UIView.setAnimationsEnabled(true)
    }

    public func showFakeBarFrom(_ from: UIViewController) {
        self.fromFakeImageView?.frame = self.fakeBarFrameForViewController(controller: from)
        self.fromFakeImageView?.backgroundColor = from.barColor
        self.fromFakeShadow?.frame = self.fakeShadowFrameWithBarFrame(frame: self.fromFakeImageView!.frame)
        from.view.addSubview(self.fromFakeShadow!)
        from.view.addSubview(self.fromFakeImageView!)
    }

    public func showFakeBarTo(_ to: UIViewController) {
        self.toFakeImageView?.frame = self.fakeBarFrameForViewController(controller: to)
        self.toFakeImageView?.backgroundColor = to.barColor
        self.toFakeShadow?.frame = self.fakeShadowFrameWithBarFrame(frame: self.toFakeImageView!.frame)
        to.view.addSubview(self.toFakeImageView!)
        to.view.addSubview(self.toFakeShadow!)
    }

    public func clearFake() {
        fromFakeShadow?.removeFromSuperview()
        toFakeShadow?.removeFromSuperview()
        fromFakeImageView?.removeFromSuperview()
        toFakeImageView?.removeFromSuperview()
    }

    public lazy var fromFakeImageView: UIImageView? = {
        var fromFakeImageView = UIImageView()
        return fromFakeImageView
    }()

    public lazy var toFakeImageView: UIImageView? = {
        var toFakeImageView = UIImageView()
        return toFakeImageView
    }()

    public lazy var fromFakeShadow: UIImageView? = {
        var fromFakeShadow = UIImageView()
        fromFakeShadow.image = self.navigationbar().shadowImageView.image
        fromFakeShadow.backgroundColor = self.navigationbar().shadowImageView.backgroundColor
        return fromFakeShadow
    }()

    public lazy var toFakeShadow: UIImageView? = {
        var toFakeShadow = UIImageView()
        toFakeShadow.image = self.navigationbar().shadowImageView.image
        toFakeShadow.backgroundColor = self.navigationbar().shadowImageView.backgroundColor
        return toFakeShadow
    }()

    func fakeBarFrameForViewController(controller: UIViewController) -> CGRect {
        guard let back = self.navigationbar().subviews.first else { return .zero }
        var frame = self.navigationbar().convert(back.frame, from: controller.view)
        frame.origin = .zero
        return frame
    }

    func fakeShadowFrameWithBarFrame(frame: CGRect) -> CGRect {
        let y = frame.size.height + frame.origin.y - 0.5
        return CGRect(x: frame.origin.x, y: y, width: frame.size.width, height: 0.5);
    }

    func navigationbar() -> WDNavigationBar {
        return self.navigationBar as! WDNavigationBar
    }
}

/// 判断是否需要显示warp导航栏
func shouldShowFake(_ vc: UIViewController, _ from: UIViewController, _ to: UIViewController) -> Bool {
    if vc != to { return false }
    if from.barHidden != to.barHidden { return true }
    if from.barColor == nil || to.barColor == nil { return false }
    if from.barColor!.isEqual(to.barColor!) { return false }
    return true
}

