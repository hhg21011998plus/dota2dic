//
//  RegisterUseCaseDomain.swift
//  Dota2Dictionary
//
//  Created by MacOS on 17/11/2021.
//

import Foundation
import RxSwift

// MARK: - Register
public protocol RegisterUseCaseDomain {
    func register(avatar: UIImage?,
                  firstName: String,
                  lastName: String,
                  email: String,
                  password: String) -> Observable<String>
}
