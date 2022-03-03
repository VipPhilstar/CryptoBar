//
//  AppDelegate.swift
//  CryptoBar
//
//  Created by Philipp Starchenko on 19.02.2022.
//

import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    let popover = NSPopover()

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupMenuBar()
        setupPopover()
    }
}

// MARK: - MENU BAR

extension AppDelegate {
    func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: 60)
        guard let menuButton = statusItem?.button else { return }

        let hostingView = NSHostingView(rootView: MenuBarCoinView().frame(maxWidth: .infinity, maxHeight: .infinity))

        hostingView.translatesAutoresizingMaskIntoConstraints = false
        menuButton.addSubview(hostingView)
        NSLayoutConstraint.activate([
            hostingView.topAnchor.constraint(equalTo: menuButton.topAnchor),
            hostingView.rightAnchor.constraint(equalTo: menuButton.rightAnchor),
            hostingView.bottomAnchor.constraint(equalTo: menuButton.bottomAnchor),
            hostingView.leftAnchor.constraint(equalTo: menuButton.leftAnchor)
        ])
        menuButton.action = #selector(menuButtonClick)
    }

    @objc func menuButtonClick() {
        if popover.isShown {
            popover.performClose(nil)
            return
        }

        guard let menuButton = statusItem?.button else { return }
        let positioningView = NSView(frame: menuButton.bounds)
        positioningView.identifier = NSUserInterfaceItemIdentifier(rawValue: "positioningView")
        menuButton.addSubview(positioningView)

        popover.show(relativeTo: positioningView.bounds, of: positioningView, preferredEdge: .maxY)
        positioningView.bounds = positioningView.bounds.offsetBy(dx: 0, dy: positioningView.bounds.height)
        popover.contentViewController?.view.window?.makeKey()
    }
}

// MARK: - POPOVER

extension AppDelegate {
    func setupPopover() {
        let hostingView = NSHostingView(rootView: PopoverView().frame(maxWidth: .infinity, maxHeight: .infinity))
        popover.behavior = .transient
        popover.animates = true
        popover.contentSize = .init(width: 248, height: 98)
        popover.contentViewController = NSViewController()
        popover.contentViewController?.view = hostingView
    }
}
