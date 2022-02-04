//
//  APIService.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/01/30.
//

import Foundation
import RxSwift

protocol APIService {
    func signInRequest(with url: URL, info: SignInModel) -> Observable<Result<SignInResponse, APIError>>
}

