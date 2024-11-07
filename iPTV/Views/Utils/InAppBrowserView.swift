//
//  InAppBrowserView.swift
//  iPTV
//
//  Created by Gaurav Kumar on 11/7/24.
//

import SwiftUI
import SafariServices

struct InAppBrowserView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

