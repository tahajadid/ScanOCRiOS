//
//  StringExtension.swift
//  inwiOCR
//
//  Created by taha_jadid on 12/4/2022.
//

import Foundation
import UIKit

public extension String {
    
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    func makeNamedImage() -> UIImage? {
        return UIImage(named: self)
    }
    
    func makeNamedColor() -> UIColor? {
        return UIColor(named: self)
    }
}
