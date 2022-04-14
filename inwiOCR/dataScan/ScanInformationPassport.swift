//
//  ScanInformationPassport.swift
//  inwiOCR
//
//  Created by taha_jadid on 12/4/2022.
//

import Foundation
import QKMRZParser


class ScanInformationPassport {
    
    var resultPassport = ""
    var resultMRZ = [String]()
    
    //MARK: - Filter Passport
    func filterResultPassport(result : [String]) -> String {
        
        resultPassport = ""
        var firstFilterPassport = [String]()
        
        for element in result {
            if(!element.matches(LocalizedConst.reg_rightData)) {
                firstFilterPassport.append(element)
            }
        }

        getIndexMRZFromData(result : firstFilterPassport)
        
        return resultPassport
    }
    
    //MARK: - Get Only the first index of the MRZ Data
    func getIndexMRZFromData(result : [String]){
        
        for element in result {
            if(element.matches(LocalizedConst.reg_idPass)) {
                self.filterMRZResult(index : result.firstIndex(of: element)!,result :result)
                break
            }
        }
    }
    
    
    //MARK: - Construct our String Array from the index returned
    func filterMRZResult(index : Int,result : [String]){
        var lastList = [String]()

        for i in index...(result.count)-1 {
            lastList.append(result[i])
        }
        
        
        if(lastList.count == 2){
            // result returned are correct 2 lignes of the MRZ
            getMRZResults(lastRresult: lastList)
        }else if(lastList.count == 1){
            // we should split the lines returned from 1 ligne to 2 lignes
        }else {
            // in case of 3 or more lignes we need to construct our 2 lignes of the mrz
            lastList = getTheRightMRZ(lastRresult : lastList)
            getMRZResults(lastRresult: lastList)
        }

    }
    
    //MARK: - In Case of wrong detecting and given an MRZ Array lenght greater than 2
    func getTheRightMRZ(lastRresult : [String])  -> [String] {
        var listToReturn = [String]()
        
        for i in 0...(lastRresult.count)-1{
            
            // to stop adding the last items and be sure of the lenght of the arrat is equal to 2
            if(listToReturn.count<2){
                
                if(lastRresult[i].count<44 && !(i==(lastRresult.count)-1)){
                    listToReturn.append(lastRresult[i]+lastRresult[i+1])
                }else{
                    listToReturn.append(lastRresult[i])
                }
            }

        }
        
        return listToReturn
    }
    
    //MARK: - Use QKMRZParser to get all the Data from MRZ
    func getMRZResults(lastRresult : [String]) {
        
        let mrzParser = QKMRZParser(ocrCorrection: true)
        let result = mrzParser.parse(mrzLines: lastRresult)
        resultPassport += "First Name : " + result!.givenNames + "\n"
        resultPassport += "Second Name : "+result!.surnames + "\n"
        resultPassport += "Nationalité : "+result!.nationalityCountryCode + "\n"
        resultPassport += "Passport Number : "+result!.documentNumber + "\n"
        resultPassport += "Cin : "+result!.personalNumber + "\n"
        resultPassport += "Date of birth : "+(result!.birthdate?.formatted().split(separator: " ")[0])!
        print("lastRresult = \(result!)")
    }

    
}
