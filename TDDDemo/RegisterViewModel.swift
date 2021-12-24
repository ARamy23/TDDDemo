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
}

class RegisterViewModel {
    var email: String = ""
    var error: LocalError?
    
    func register() {
        validate()
    }
    
    func validate() {
        do {
            try EmailValidationRule().validate(email: email)
            
            
            
            // Register...
        } catch let error as LocalError {
            self.error = error
        } catch {
            assertionFailure()
        }
    }
}

class EmailValidationRule {
    func validate(email: String) throws {
        guard !email.isEmpty else { throw LocalError(.isEmpty(.email)) }
        guard email.isValidEmail else { throw LocalError(.isInvalid(.email)) }
    }
}

extension String {
    var isValidEmail: Bool {
        return self.contains("@")
    }
}
