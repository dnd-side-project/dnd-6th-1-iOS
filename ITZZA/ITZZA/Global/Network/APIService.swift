//
//  APIService.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/01/30.
//

import Foundation
import RxSwift

protocol APIService {
    func loginRequest(with url: URL, info: LoginModel) -> Observable<Result<LoginResponse, APIError>>
}

