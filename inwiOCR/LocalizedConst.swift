//
//  LocalizedConst.swift
//  inwiOCR
//
//  Created by taha_jadid on 11/4/2022.
//

import Foundation

class LocalizedConst {

    static let reg_rightData = "OYAUM.*|CARTE.*|.*AROC|.*NATIONA|.*ENTITE.*|[a-z].*|.*[ä].*|[à].*|.*[~!@#\\$%^&amp;*()_+'{}\\[\\]:;?-].*"

    static let reg_dob = "[0-9].*[0-9]"
    static let reg_cin = "^[A-Z]+[0-9]+"
    static let reg_mrz = "I[A-Z0-9<\\s]+"    
    static let reg_adress = "Adresse.*"
    static let reg_sexe = "Sex.*"
    
}
