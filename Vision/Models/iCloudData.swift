//
//  iCloudData.swift
//  Bmore
//
//  Created by Idan Moshe on 02/02/2021.
//

import Foundation
import CloudKit

struct iCloudData {
    var hasiCloudAccount: Bool = false
    var phoneNumber: String?
    var emailAddress: String?
    var nameComponents: PersonNameComponents?
    var userRecordID: CKRecord.ID?
}

class iCloudService {
    
    class func fetchData(_ handler: @escaping (iCloudData?, Error?) -> Void) {
        CKContainer.default().requestApplicationPermission(.userDiscoverability) { (status, error) in
            if let _ = error {
                handler(nil, error)
            } else {
                CKContainer.default().fetchUserRecordID { (record, error) in
                    if let _ = error {
                        handler(nil, error)
                    } else {
                        CKContainer.default().discoverUserIdentity(withUserRecordID: record!, completionHandler: { (userID, error) in
                            if let _ = error {
                                handler(nil, error)
                            } else if userID == nil {
                                handler(nil, nil)
                            } else {
                                if let userID = userID {
                                    var cloudData = iCloudData()
                                    cloudData.hasiCloudAccount = userID.hasiCloudAccount
                                    cloudData.phoneNumber = userID.lookupInfo?.phoneNumber
                                    cloudData.emailAddress = userID.lookupInfo?.emailAddress
                                    cloudData.nameComponents = userID.nameComponents
                                    handler(cloudData, nil)
                                }
                            }
                        })
                    }
                }
            }
        }
    }
    
}
