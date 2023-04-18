//
//  Common.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 31/01/2023.
//

import Foundation
import CryptoSwift

public class Common {
    
    static func md5(_ string: String) -> String {
        let inputData = Data(string.utf8)
        let md5Data = inputData.md5()
        let md5String = md5Data.map { String(format: "%02hhx", $0) }.joined()
        return md5String
    }
    
    static func encrypt(message: String, key: String) -> String {
        let keyData = Data(md5(key).utf8)
        let messageData = Data(message.utf8)
        
        do {
            let encryption = try AES(key: keyData.bytes, blockMode: ECB(), padding: .noPadding)
            let blockSize = 16
            let paddingLength = blockSize - messageData.count % blockSize
            let paddingData = Data(count: paddingLength)
            let paddedData = messageData + paddingData
            let encryptedData = try encryption.encrypt(paddedData.bytes)
            return encryptedData.toHexString()
        } catch {
            print("Error encrypting: \(error)")
            return ""
        }
    }
    
    static func decrypt(encrypted: String, key: String) -> String {
        do {
            let keyData = Data(md5(key).utf8)
            let keyBytes = keyData.bytes
            
            let cipherData = Data(hex: encrypted)
            
            let decryption = try AES(key: keyBytes, blockMode: ECB(), padding: Padding.noPadding)
            let decryptedData = try decryption.decrypt(cipherData.bytes)
            
            let decryptedString = String(bytes: decryptedData, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "\0", with: "") ?? ""
            return decryptedString
        } catch {
            print("error \(error)")
            return ""
        }
    }
}
