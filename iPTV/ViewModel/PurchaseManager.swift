//
//  PurchaseManager.swift
//  iPTV
//
//  Created by Gaurav Kumar on 11/4/24.
//

import Foundation
import StoreKit
import Combine

class PurchaseManager: NSObject, ObservableObject, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    // SKProductsRequestDelegate method to handle product request response
        func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
            if let loadedProduct = response.products.first {
                product = loadedProduct
            } else {
                print("Product not found.")
            }
        }
    
    @Published var isPurchased: Bool = false
    @Published var purchaseInProgress: Bool = false
    @Published var showPurchaseScreen: Bool = false
    private var product: SKProduct?
    
    private let productID = "iStreamX"  // Replace with actual Product ID
    private let purchaseStatusKey = "isPurchased"
    private let trialStartDateKey = "trialStartDate"
    private let trialDurationDays = 7

    override init() {
        super.init()
        SKPaymentQueue.default().add(self)  // Register as transaction observer
        loadProduct()
        checkPurchaseStatus()
    }

    deinit {
        SKPaymentQueue.default().remove(self)  // Remove observer when deinitialized
    }

    private func loadProduct() {
        let request = SKProductsRequest(productIdentifiers: [productID])
        request.delegate = self
        request.start()
    }

    // Track if 7-day trial period has ended
    func trackTrialPeriod() {
        if isPurchased {
            showPurchaseScreen = false
            return
        }
        
        // Check if the trial start date exists
        if let startDate = UserDefaults.standard.object(forKey: trialStartDateKey) as? Date {
            let daysPassed = Calendar.current.dateComponents([.day], from: startDate, to: Date()).day ?? 0
            showPurchaseScreen = daysPassed >= trialDurationDays
        } else {
            // Set the start date if not set
            UserDefaults.standard.set(Date(), forKey: trialStartDateKey)
            showPurchaseScreen = false
        }
    }

    private func checkPurchaseStatus() {
        isPurchased = UserDefaults.standard.bool(forKey: purchaseStatusKey)
    }

    func purchase() {
        guard let product = product else { return }
        purchaseInProgress = true
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }

    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }

    // Implement transaction observer method
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                completePurchase(transaction: transaction)
            case .failed:
                handlePurchaseError(transaction: transaction)
            case .restored:
                restorePurchase(transaction: transaction)
            default:
                break
            }
        }
    }

    private func completePurchase(transaction: SKPaymentTransaction) {
        isPurchased = true
        
        UserDefaults.standard.set(true, forKey: purchaseStatusKey)
        showPurchaseScreen = false
        purchaseInProgress = false
        SKPaymentQueue.default().finishTransaction(transaction)
    }

    private func handlePurchaseError(transaction: SKPaymentTransaction) {
        if let error = transaction.error as? SKError {
            print("Purchase failed: \(error.localizedDescription)")
        }
        purchaseInProgress = false
        SKPaymentQueue.default().finishTransaction(transaction)
    }

    private func restorePurchase(transaction: SKPaymentTransaction) {
        isPurchased = true
        UserDefaults.standard.set(true, forKey: purchaseStatusKey)
        showPurchaseScreen = false
        SKPaymentQueue.default().finishTransaction(transaction)
    }
}






