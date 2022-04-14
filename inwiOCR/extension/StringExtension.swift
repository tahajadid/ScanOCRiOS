//
//  StringExtension.swift
//  inwiOCR
//
//  Created by taha_jadid on 12/4/2022.
//

import Foundation

public extension String {
    
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
        
}
