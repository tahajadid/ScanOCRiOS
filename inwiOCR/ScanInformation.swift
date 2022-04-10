//
//  ScanInformation.swift
//  inwiOCR
//
//  Created by taha_jadid on 9/4/2022.
//

import Foundation
import CoreMedia

class ScanInformation {
    
    
    let vall = "OYAUM.*|CARTE.*|.*AROC|.*NATIONA|.*ENTITE.*|[a-z].*|.*[ä].*|[à].*|.*[~!@#\\$%^&amp;*()_+'{}\\[\\]:;?-].*"
    let reg_dob = "[0-9].*[0-9]"
    let reg_cin = "^[A-Z]+[0-9]+"

    var resultToShow = ""

    func filterResultCinRecto(result : [String]) -> String {
        resultToShow = ""
        print(result)
        var newResult = [String]()
        
        for element in result {
            if(!element.matches(vall)) {
                newResult.append(element)
            }
        }
        
        getNames(result : newResult)
        getDOB(result : newResult)
        getCIN(result : newResult)
        
        return resultToShow

    }
    
    func getNames(result : [String]) {
        var getFirst = false
        for element in result {
            if(!getFirst && element.count>2) {
                print ("+++++ first name is : \(element)")
                resultToShow += "first name is : \(element)" + "\n"
                getFirst = true
                
            } else if(getFirst){
                print ("+++++ last name is : \(element)")
                resultToShow += "last name is : \(element)" + "\n"
                return
            }
        }
        
    }
    
    func getDOB(result : [String]){
        
        for element in result {
            if(element.matches(reg_dob)) {
                print ("+++++ date of birth is : \(element)")
                resultToShow += "date of birth is : \(element)" + "\n"
                return
                
            }
        }
        
    }
    
    func getCIN(result : [String]){
        
        for element in result {
            if(element.matches(reg_cin)) {
                print ("+++++ cin is : \(element)")
                resultToShow += "cin is : \(element)" + "\n"

                return
                
            }
        }
        
    }
    

}

extension String {
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}
