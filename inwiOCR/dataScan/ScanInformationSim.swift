//
//  ScanInformationSim.swift
//  inwiOCR
//
//  Created by taha_jadid on 14/4/2022.
//

import Foundation
import CoreMedia

class ScanInformationSim {

    var resultForSim = ""
    var numberScanSim = [String]()

    // MARK - Recto Face
    
    func filterResultCinRecto(result : [String]) -> String {
        resultForSim = ""
        print(result)
        var newResult = [String]()
        
        for element in result {
            if(!element.matches(LocalizedConst.reg_rightData)) {
                newResult.append(element)
            }
        }
        
        let resultFinal = getSim(result : newResult)
        print("[Result sim] :  \(resultFinal)")
        
        return resultForSim

    }
    
    
    func getSim(result : [String]) -> [String]{
        
        for element in result {
            if(element.matches(LocalizedConst.reg_sim)) {
                numberScanSim.append(element)
                print ("+++++ date of birth is : \(element)")
                resultForSim += "date of birth is : \(element)" + "\n"
            }
        }
        
        return numberScanSim
        
    }



}
