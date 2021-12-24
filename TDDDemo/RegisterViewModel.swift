//
//  RegisterViewModel.swift
//  TDDDemo
//
//  Created by Ahmed Ramy on 24/12/2021.
//

import Foundation

struct LocalError: Error {
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    init(_ validationCase: ValidationCase) {
        self.text = validationCase.text
    }
}

extension LocalError: Equatable {
    static func ==(lhs: LocalError, rhs: LocalError) -> Bool {
        return lhs.text == rhs.text
    }
}

enum ValidationCase {
    case isEmpty(Field)
    case isInvalid(Field)
    var text: String {
        switch self {
        case .isEmpty(let field):
            return "\(field) can't be empty."
        case .isInvalid(let field):
            return "\(field) is invalid."
        }
    }
}

enum Field {
    case email
    case password
}

class RegisterViewModel {
    var email: String = ""
    var password: String = ""
    var errors = [LocalError]()
    
    func register() {
        validate()
    }
    
    func validate() {
        let rules: [ValidationRule] = [
            EmailValidationRule(email: email),
            PasswordValidationRule(password: password)
        ]
        
        
        rules.forEach {
            do {
                try $0.validate()
            } catch let error as LocalError {
                errors.append(error)
            } catch {
                assertionFailure()
            }
        }
        
    }
}

protocol ValidationRule {
    func validate() throws
}

struct EmailValidationRule: ValidationRule {
    let email: String
    
    func validate() throws {
        guard !email.isEmpty else { throw LocalError(.isEmpty(.email)) }
        guard email.isValidEmail else { throw LocalError(.isInvalid(.email)) }
    }
}

struct PasswordValidationRule: ValidationRule {
    let password: String
    
    func validate() throws {
        guard !password.isEmpty else { throw LocalError(.isEmpty(.password)) }
    }
}

extension String {
    var isValidEmail: Bool {
        return self.contains("@")
    }
}
