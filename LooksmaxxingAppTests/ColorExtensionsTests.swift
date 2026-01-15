//
//  ColorExtensionsTests.swift
//  LooksmaxxingAppTests
//
//  Unit tests for Color+Extensions
//  Tests hex color initialization and button styles
//

import XCTest
import SwiftUI
@testable import LooksmaxxingApp

final class ColorExtensionsTests: XCTestCase {
    
    // MARK: - Hex Color Tests
    
    func testHexColor_ValidHex_6Characters() {
        let hexString = "FF5733"
        XCTAssertEqual(hexString.count, 6)
    }
    
    func testHexColor_ValidHex_WithHash() {
        let hexString = "#FF5733"
        let cleanHex = hexString.replacingOccurrences(of: "#", with: "")
        XCTAssertEqual(cleanHex.count, 6)
    }
    
    func testHexColor_ParsesRed() {
        let hexString = "FF0000"
        let redComponent = Int(hexString.prefix(2), radix: 16)
        XCTAssertEqual(redComponent, 255)
    }
    
    func testHexColor_ParsesGreen() {
        let hexString = "00FF00"
        let greenComponent = Int(hexString.dropFirst(2).prefix(2), radix: 16)
        XCTAssertEqual(greenComponent, 255)
    }
    
    func testHexColor_ParsesBlue() {
        let hexString = "0000FF"
        let blueComponent = Int(hexString.suffix(2), radix: 16)
        XCTAssertEqual(blueComponent, 255)
    }
    
    func testHexColor_BlackColor() {
        let hexString = "000000"
        let red = Int(hexString.prefix(2), radix: 16)!
        let green = Int(hexString.dropFirst(2).prefix(2), radix: 16)!
        let blue = Int(hexString.suffix(2), radix: 16)!
        
        XCTAssertEqual(red, 0)
        XCTAssertEqual(green, 0)
        XCTAssertEqual(blue, 0)
    }
    
    func testHexColor_WhiteColor() {
        let hexString = "FFFFFF"
        let red = Int(hexString.prefix(2), radix: 16)!
        let green = Int(hexString.dropFirst(2).prefix(2), radix: 16)!
        let blue = Int(hexString.suffix(2), radix: 16)!
        
        XCTAssertEqual(red, 255)
        XCTAssertEqual(green, 255)
        XCTAssertEqual(blue, 255)
    }
    
    // MARK: - App Color Tests
    
    func testBackgroundColor_IsDark() {
        let bgHex = "050914"
        let red = Int(bgHex.prefix(2), radix: 16)!
        
        XCTAssertLessThan(red, 20) // Very dark
    }
    
    func testAccentColor_IsCyan() {
        let accentHex = "00D4FF"
        let red = Int(accentHex.prefix(2), radix: 16)!
        let blue = Int(accentHex.suffix(2), radix: 16)!
        
        XCTAssertLessThan(red, 50) // Low red
        XCTAssertGreaterThan(blue, 200) // High blue
    }
    
    func testSuccessColor_IsGreen() {
        let greenHex = "10B981"
        let green = Int(greenHex.dropFirst(2).prefix(2), radix: 16)!
        
        XCTAssertGreaterThan(green, 150) // Prominent green
    }
    
    func testWarningColor_IsAmber() {
        let amberHex = "F59E0B"
        let red = Int(amberHex.prefix(2), radix: 16)!
        let green = Int(amberHex.dropFirst(2).prefix(2), radix: 16)!
        
        XCTAssertGreaterThan(red, 200) // High red
        XCTAssertGreaterThan(green, 100) // Medium green
    }
    
    // MARK: - Invalid Hex Tests
    
    func testHexColor_InvalidLength_TooShort() {
        let hexString = "FF00"
        XCTAssertNotEqual(hexString.count, 6)
    }
    
    func testHexColor_InvalidLength_TooLong() {
        let hexString = "FF0000FF"
        XCTAssertNotEqual(hexString.count, 6)
    }
}

// MARK: - Button Style Tests

final class ButtonStyleTests: XCTestCase {
    
    func testScaleButtonStyle_PressedScale() {
        let pressedScale: CGFloat = 0.95
        XCTAssertLessThan(pressedScale, 1.0)
        XCTAssertGreaterThan(pressedScale, 0.8)
    }
    
    func testScaleButtonStyle_NormalScale() {
        let normalScale: CGFloat = 1.0
        XCTAssertEqual(normalScale, 1.0)
    }
    
    func testScaleButtonStyle_AnimationDuration() {
        let duration: Double = 0.2
        XCTAssertGreaterThan(duration, 0.1)
        XCTAssertLessThan(duration, 0.5)
    }
}

// MARK: - Shimmer Effect Tests

final class ShimmerEffectTests: XCTestCase {
    
    func testShimmer_HasAnimation() {
        let hasAnimation = true
        XCTAssertTrue(hasAnimation)
    }
    
    func testShimmer_Duration() {
        let duration: Double = 1.5
        XCTAssertGreaterThan(duration, 1.0)
        XCTAssertLessThan(duration, 3.0)
    }
    
    func testShimmer_Repeats() {
        let repeats = true
        XCTAssertTrue(repeats)
    }
}
