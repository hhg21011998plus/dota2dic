//
//  RegisterViewModel.swift
//  Dota2Dictionary
//
//  Created by MacOS on 16/11/2021.
//

import Foundation
import RxSwift
import RxCocoa

class RegisterViewModel: ViewModelType {
    
    private let useCase: RegisterUseCaseDomain
    private let navigator: DefaultRegisterNavigator
    
    init(useCase: RegisterUseCaseDomain,
         navigator: DefaultRegisterNavigator) {
        self.useCase = useCase
        self.navigator = navigator
    }
    
    func transform(input: Input) -> Output {
        
        let enableRegister = Driver
            .combineLatest(input.enteredFirstName,
                           input.enteredLastName,
                           input.enteredEmail,
                           input.enteredPassword,
                           input.imageTrigger) {
                            return !$0.isEmpty
                                && !$1.isEmpty
                                && !$2.isEmpty
                                && !$3.isEmpty
                                && $4 != nil
        }
        
        let mergeText = Driver
            .combineLatest(input.imageTrigger,
                           input.enteredFirstName,
                           input.enteredLastName,
                           input.enteredEmail,
                           input.enteredPassword)
        
        let tappedRegister = input
            .tappedRegister
            .withLatestFrom(mergeText) { _, text -> Observable<String> in
                self.useCase.register(avatar: text.0,
                                      firstName: text.1,
                                      lastName: text.2,
                                      email: text.3,
                                      password: text.4) }
            .asObservable()
            .flatMap {$0}
        
        let goBackOutput = input
            .backTrigger
            .do(onNext: {
                self.navigator.toLogin()
            })
        
        return Output(goBack: goBackOutput,
                      enableRegister: enableRegister,
                      tappedRegister: tappedRegister)
    }
}

extension RegisterViewModel {
    struct Input {
        let backTrigger: Driver<Void>
        let imageTrigger: Driver<UIImage?>
        let enteredFirstName: Driver<String>
        let enteredLastName: Driver<String>
        let enteredEmail: Driver<String>
        let enteredPassword: Driver<String>
        let tappedRegister: Driver<Void>
    }
    
    struct Output {
        let goBack: Driver<Void>
        let enableRegister: Driver<Bool>
        let tappedRegister: Observable<String>
    }
}
