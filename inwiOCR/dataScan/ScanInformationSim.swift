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
    
    func filterResultSim(result : [String]) -> String {
        resultForSim = ""
        print(result)
        var newResult = [String]()
        
        for element in result {
            if(!element.matches(LocalizedConst.reg_rightData)) {
                newResult.append(element)
            }
        }
        
        // Filter to get all the numbers detected
        for element in result {
            if(element.matches(LocalizedConst.reg_sim)) {
                numberScanSim.append(element)
            }
        }
        
        getMdn(result : newResult)
        getICC(result : newResult)

        return resultForSim

    }
    
    
    func getMdn(result : [String]){
        
        for element in result {
            if(element.count == 10){
                resultForSim += "MDN est : \(element) \n"
                break
            }
        }
    }
    
    func getICC(result : [String]){
        
        for element in result {
            if(element.count == 18){
                resultForSim += "ICC est : \(element)"
                break
            }
        }
    }
    



}
