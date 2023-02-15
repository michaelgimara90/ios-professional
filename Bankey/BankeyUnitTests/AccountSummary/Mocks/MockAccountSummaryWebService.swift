//
//  MockAccountSummaryWebService.swift
//  BankeyUnitTests
//
//  Created by Michael Gimara on 15/02/2023.
//

import Foundation

@testable import Bankey

class MockAccountSummaryWebService: AccountSummaryWebServiceProtocol {
    var error: NetworkError?
    
    func fetchProfile(forUserId userId: String, completion: @escaping (Result<Profile, NetworkError>) -> Void) {
        guard error == nil else {
            completion(.failure(error!))
            return
        }
        let profile: Profile = Profile(id: "1", firstName: "FirstName", lastName: "LastName")
        completion(.success(profile))
    }
    
    func fetchAccounts(forUserId userId: String, completion: @escaping (Result<[Account], NetworkError>) -> Void) {
        guard error == nil else {
            completion(.failure(error!))
            return
        }
        let accounts: [Account] = [
            Account(id: "1", type: .Banking, name: "Account1", amount: 100, createdDateTime: Date()),
            Account(id: "2", type: .Banking, name: "Account2", amount: 200, createdDateTime: Date())
        ]
        completion(.success(accounts))
    }
}
