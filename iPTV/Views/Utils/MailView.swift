//
//  MailView.swift
//  iPTV
//
//  Created by Gaurav Kumar on 11/7/24.
//

import SwiftUI
import MessageUI

struct MailView: UIViewControllerRepresentable {
    var recipients: [String]
    var subject: String
    var messageBody: String

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailView

        init(parent: MailView) {
            self.parent = parent
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = context.coordinator
        mailComposeVC.setToRecipients(recipients)
        mailComposeVC.setSubject(subject)
        mailComposeVC.setMessageBody(messageBody, isHTML: false)
        return mailComposeVC
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
}


//#Preview {
//    MailView()
//}
