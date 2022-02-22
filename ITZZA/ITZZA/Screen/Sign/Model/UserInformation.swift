//
//  SignInResponse.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/23.
//

class UserInformation {
    var token: String?
    var userId: Int?
    
    static let shared: UserInformation = UserInformation()
    
    private init() { }
}
