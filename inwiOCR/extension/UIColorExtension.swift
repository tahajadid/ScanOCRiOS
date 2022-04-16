//
//  UIColorExtension.swift
//  inwiOCR
//
//  Created by taha_jadid on 15/4/2022.
//

import UIKit

extension UIColor {
    /*
     With this function, we can convert HexString to UIColor using RGB
     */
    convenience init(hexString: String) {
            let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
            var int = UInt64()
            Scanner(string: hex).scanHexInt64(&int)
            let alpha: UInt64
            let red: UInt64
            let green: UInt64
            let blue: UInt64
            switch hex.count {
            case 3: // RGB (12-bit)
                (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
            case 6: // RGB (24-bit)
                (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
            case 8: // ARGB (32-bit)
                (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
            default:
                (alpha, red, green, blue) = (255, 0, 0, 0)
            }
            self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: CGFloat(alpha) / 255)
        }
    
}