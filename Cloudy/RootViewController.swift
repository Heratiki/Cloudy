// Copyright (c) 2020 Nomad5. All rights reserved.

import UIKit
import WebKit

class FullScreenWKWebView: WKWebView {
    override var safeAreaInsets: UIEdgeInsets {
        .zero
    }
}

protocol OnScreenControllerUpdater {
    func updateOnScreenController(with value: OnScreenControlsLevel)
}

class RootViewController: UIViewController, OnScreenControllerUpdater {

    /// Containers
    @IBOutlet var containerWebView:            UIView!
    @IBOutlet var containerOnScreenController: UIView!

    /// The hacked webView
    private var webView:   FullScreenWKWebView!
    private let navigator: Navigator       = Navigator()

    /// The menu controller
    private var menu:      MenuController? = nil

    /// The bridge between controller and web view
    private let webViewControllerBridge    = WebViewControllerBridge()

    private var  streamView:                     StreamView?

    /// By default hide the status bar
    override var prefersStatusBarHidden:         Bool {
        true
    }

    /// Hide bottom bar on x devices
    override var prefersHomeIndicatorAutoHidden: Bool {
        true
    }

    /// The configuration used for the wk webView
    private lazy var webViewConfig: WKWebViewConfiguration = {
        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = true
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = UserDefaults.standard.allowInlineMedia
        config.allowsAirPlayForMediaPlayback = false
        config.allowsPictureInPictureMediaPlayback = false
        config.mediaTypesRequiringUserActionForPlayback = []
        config.applicationNameForUserAgent = "Version/13.0.1 Safari/605.1.15"
        config.userContentController.addScriptMessageHandler(webViewControllerBridge, contentWorld: WKContentWorld.page, name: "controller")
        config.preferences = preferences
        return config
    }()

    /// View will be shown shortly
    override func viewDidLoad() {
        super.viewDidLoad()
        // configure webView
        webView = FullScreenWKWebView(frame: view.bounds, configuration: webViewConfig)
        webView.translatesAutoresizingMaskIntoConstraints = false
        containerWebView.addSubview(webView)
        webView.fillParent()
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = false
        // initial
        if let lastVisitedUrl = UserDefaults.standard.lastVisitedUrl {
            webView.navigateTo(url: lastVisitedUrl)
        } else {
            webView.navigateTo(url: Navigator.Config.Url.googleStadia)
        }
        // menu view controller
        let menuViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu = menuViewController
        menuViewController.view.alpha = 0
        menuViewController.webController = webView
        menuViewController.overlayController = self
        menuViewController.onScreenControllerUpdater = self
        menuViewController.view.frame = view.bounds
        menuViewController.willMove(toParent: self)
        addChild(menuViewController)
        view.addSubview(menuViewController.view)
        menuViewController.didMove(toParent: self)
    }

    /// View layout already done
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // stream config
        let streamConfig      = StreamConfiguration()
        // Controller support
        let controllerSupport = ControllerSupport(config: streamConfig,
                                                  presenceDelegate: self,
                                                  controllerDataReceiver: webViewControllerBridge)
        // stream view
        let streamView        = StreamView(frame: containerOnScreenController.bounds)
        streamView.setupStreamView(controllerSupport, interactionDelegate: self, config: streamConfig)
        streamView.showOnScreenControls()
        containerOnScreenController.addSubview(streamView)
        streamView.fillParent()
        self.streamView = streamView
        updateOnScreenController(with: UserDefaults.standard.onScreenControlsLevel)
    }

    /// Update visibility of onscreen controller
    func updateOnScreenController(with value: OnScreenControlsLevel) {
        containerOnScreenController.alpha = value == .off ? 0 : 1
        webViewControllerBridge.controlsSource = value == .off ? .external : .onScreen
        streamView?.updateOnScreenControls()
    }

    /// Tapped on the menu item
    @IBAction func onMenuButtonPressed(_ sender: Any) {
        menu?.show()
    }
}

extension RootViewController: UserInteractionDelegate {
    open func userInteractionBegan() {
        Log.d("userInteractionBegan")
    }

    open func userInteractionEnded() {
        Log.d("userInteractionEnded")
    }
}

extension RootViewController: InputPresenceDelegate {
    open func gamepadPresenceChanged() {
        Log.d("gamepadPresenceChanged")
    }

    open func mousePresenceChanged() {
        Log.d("gamepadPresenceChanged")
    }
}

/// Show an web overlay
extension RootViewController: OverlayController {

    /// Show an overlay
    func showOverlay(for address: String?) {
        // early exit
        guard let address = address,
              let url = URL(string: address) else {
            return
        }
        // forward
        _ = createModalWebView(for: URLRequest(url: url), configuration: webViewConfig)
    }

    /// Internally we create a modal web view and present it
    private func createModalWebView(for urlRequest: URLRequest, configuration: WKWebViewConfiguration) -> WKWebView? {
        // create modal web view
        let modalViewController = UIViewController()
        let modalWebView        = WKWebView(frame: .zero, configuration: configuration)
        modalViewController.view = modalWebView
        modalWebView.customUserAgent = Navigator.Config.UserAgent.chromeDesktop
        modalWebView.load(urlRequest)
        // the navigation view controller with its close button
        let modalNavigationController = UINavigationController(rootViewController: modalViewController)
        modalViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close",
                                                                                style: .done,
                                                                                target: self,
                                                                                action: #selector(self.onOverlayClosePressed))
        present(modalNavigationController, animated: true)
        return modalWebView
    }

    /// Close the overlay
    @objc func onOverlayClosePressed(sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

/// WebView delegates
/// TODO extract this to a separate module with proper abstraction
extension RootViewController: WKNavigationDelegate, WKUIDelegate {

    /// When a page finished loading, inject the controller override script
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // inject the script
        webView.injectControllerScript()
        // update address
        menu?.updateAddressBar(with: AddressBarInfo(url: webView.url?.absoluteString,
                                                    canGoBack: webView.canGoBack,
                                                    canGoForward: webView.canGoForward))
        // save last visited url
        UserDefaults.standard.lastVisitedUrl = webView.url
        // set user agent to iphone
        // DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
        //     webView.customUserAgent = Navigator.Config.UserAgent.iPhone
        // }
    }

    /// Handle popups
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            if navigator.shouldOpenPopup(for: navigationAction.request.url?.absoluteString) {
                let modalWebView = createModalWebView(for: navigationAction.request, configuration: configuration)
                return modalWebView
            } else {
                webView.load(navigationAction.request)
                return nil
            }
        }
        return nil
    }

    /// After successfully logging in, forward user to stadia
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let navigation = navigator.getNavigation(for: navigationAction.request.url?.absoluteString)
        print("navigation -> \(navigationAction.request.url?.absoluteString ?? "nil") -> \(navigation)")
        webViewControllerBridge.exportType = navigation.bridgeType
        webView.customUserAgent = navigation.userAgent
        if let forwardUrl = navigation.forwardToUrl {
            decisionHandler(.cancel)
            webView.navigateTo(url: forwardUrl)
            return
        }
        decisionHandler(.allow)
    }

}
