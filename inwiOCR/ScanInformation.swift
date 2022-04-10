//
//  ScanInformation.swift
//  inwiOCR
//
//  Created by taha_jadid on 9/4/2022.
//

import Foundation
import CoreMedia

class ScanInformation {
    
    let vall = "ROYAUM.*|CARTE.*|.*MAROC|.*NATIONA.*|[a-z].*|.*[ä].*|[à].*|.*[~!@#\\$%^&amp;*()_+'{}\\[\\]:;?-].*"
    let reg_dob = "[0-9].*[0-9]"
    let reg_cin = "^[A-Z]+[0-9]+"

    var resultToShow = ""

    func filterResultCinRecto(result : [String]) -> String {
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
                break
            }
        }
        
    }
    
    func getDOB(result : [String]){
        
        for element in result {
            if(element.matches(reg_dob)) {
                print ("+++++ date of birth is : \(element)")
                resultToShow += "date of birth is : \(element)" + "\n"
                break
                
            }
        }
        
    }
    
    func getCIN(result : [String]){
        
        for element in result {
            if(element.matches(reg_cin)) {
                print ("+++++ cin is : \(element)")
                resultToShow += "cin is : \(element)" + "\n"

                break
                
            }
        }
        
    }
    
    func respond(invitation: String) {
        
      if let range = invitation.range(of: #"\bClue(do)?™?\b"#, options: .regularExpression) {
        switch invitation[range] {
        case "Cluedo":
            print("I'd be delighted to play!")
        case "Clue":
            print("Did you mean Cluedo? If so, then yes!")
        default:
            fatalError("(Wait... did I mess up my regular expression?)")
        }
      } else {
        print("Still waiting for an invitation to play Cluedo.")
      }
    }
    
    func checkNumbers(for regex : String, in text: String) -> Bool {
    
        return text.matches(regex)
    }

}

extension String {
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}
