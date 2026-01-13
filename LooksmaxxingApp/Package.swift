// swift-tools-version: 5.9
// Package.swift for LooksmaxxingApp
// This file is for documentation - actual dependencies are added in Xcode

/*
 Required Dependencies (Add via Xcode > File > Add Package Dependencies):
 
 1. RevenueCat SDK
    URL: https://github.com/RevenueCat/purchases-ios
    Version: Latest (5.x)
    Purpose: Subscription and IAP management
    
 2. Firebase iOS SDK (Optional)
    URL: https://github.com/firebase/firebase-ios-sdk
    Version: Latest (10.x)
    Purpose: Analytics and push notifications (optional for MVP)
    
 After adding RevenueCat:
 1. Go to SubscriptionViewModel.swift
 2. Uncomment the `import RevenueCat` line
 3. Replace "YOUR_REVENUECAT_API_KEY" with your actual API key
 4. Uncomment the RevenueCat implementation code
*/

import PackageDescription

let package = Package(
    name: "LooksmaxxingApp",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "LooksmaxxingApp",
            targets: ["LooksmaxxingApp"]),
    ],
    dependencies: [
        // RevenueCat for subscriptions
        .package(url: "https://github.com/RevenueCat/purchases-ios", from: "5.0.0"),
        // Firebase for analytics (optional)
        // .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "10.0.0"),
    ],
    targets: [
        .target(
            name: "LooksmaxxingApp",
            dependencies: [
                .product(name: "RevenueCat", package: "purchases-ios"),
                // .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
            ]),
    ]
)
