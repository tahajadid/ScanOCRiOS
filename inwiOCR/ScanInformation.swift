//
//  ScanInformation.swift
//  inwiOCR
//
//  Created by taha_jadid on 9/4/2022.
//

import Foundation
import CoreMedia

class ScanInformation {

    var resultForRecto = ""
    var resultForVerso = ""

    // MARK - Recto Face
    
    func filterResultCinRecto(result : [String]) -> String {
        resultForRecto = ""
        print(result)
        var newResult = [String]()
        
        for element in result {
            if(!element.matches(LocalizedConst.reg_rightData)) {
                newResult.append(element)
            }
        }
        
        getNames(result : newResult)
        getDOB(result : newResult)
        getCIN(result : newResult)
        
        return resultForRecto

    }
    
    func getNames(result : [String]) {
        var getFirst = false
        for element in result {
            if(!getFirst && element.count>2) {
                print ("+++++ first name is : \(element)")
                resultForRecto += "first name is : \(element)" + "\n"
                getFirst = true
                
            } else if(getFirst){
                print ("+++++ last name is : \(element)")
                resultForRecto += "last name is : \(element)" + "\n"
                return
            }
        }
        
    }
    
    func getDOB(result : [String]){
        
        for element in result {
            if(element.matches(LocalizedConst.reg_dob)) {
                print ("+++++ date of birth is : \(element)")
                resultForRecto += "date of birth is : \(element)" + "\n"
                return
                
            }
        }
        
    }
    
    func getCIN(result : [String]){
        
        for element in result {
            if(element.matches(LocalizedConst.reg_cin)) {
                print ("+++++ cin is : \(element)")
                resultForRecto += "cin is : \(element)" + "\n"

                return
                
            }
        }
        
    }
    
    // MARK - Verso Face

    func filterResultCinVerso(result : [String]) -> String {
        resultForVerso = ""
        print(result)
        var newResult = [String]()
        
        for element in result {

            newResult.append(element)
            
        }
        
        // getMRZ(result : newResult)
        getAdress(result : newResult)
        getSexe(result : newResult)
        
        return resultForVerso

    }
    
    func getMRZ(result : [String]){
        for element in result {
            if(element.matches(LocalizedConst.reg_mrz)) {
                print ("+++++ mrz is : \(element)")
                resultForVerso += "mrz is : \(element)" + "\n"
                return
                
            }
        }
    }
    
    func getAdress(result : [String]){
        for element in result {
            print("to show --- .\(result)")
            if(element.matches(LocalizedConst.reg_adress)) {
                print ("+++++ adress is : \(element)")
                resultForVerso += "adress is : \(element.replacingOccurrences(of: "Adresse", with: ""))" + "\n"
                break
                
            }
        }
    }
    
    func getSexe(result : [String]){
        var tempSexe : String
        for element in result {
            tempSexe = element
            if(element.matches(LocalizedConst.reg_sexe)) {
                print("§ First element \(element) && second \(result[result.firstIndex(of: element)!+1])")
                if(tempSexe == "M" || result[result.firstIndex(of: element)!+1] == "M"){
                    print ("+++++ sexe is : \(element)")
                    resultForVerso += "sexe is : Male" + "\n"
                    break
                }else if(tempSexe == "F" || result[result.firstIndex(of: element)!+1] == "F") {
                    print ("+++++ sexe is : \(element)")
                    resultForVerso += "sexe is : Female" + "\n"
                    break
                } else {
                    break
                }
            }
        }
    }
    

}

extension String {
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}
