//
//  LoginViewModel.swift
//  TDDDemo
//
//  Created by Ahmed Ramy on 24/12/2021.
//

import Foundation

class NetworkError: Error {
    var text: String
    
    init(networkCase: NetworkCase) {
        self.text = networkCase.text
    }
}

extension NetworkError: Equatable {
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        return lhs.text == rhs.text
    }
}

enum NetworkCase {
    case userNotVerified
    
    var text: String {
        switch self {
        case .userNotVerified:
            return "You need to confirm your email"
        }
    }
}

class LoginViewModel {
    
    let network: NetworkProtocol
    
    var errors: [NetworkError] = []
    var isLoading: Bool = false
    var email: String = ""
    var password: String = ""
    
    init(network: NetworkProtocol = Network()) {
        self.network = network
    }
    
    func login() {
        isLoading = true
        network.callLogin(email: email, password: password) { results in
            self.isLoading = false
            switch results {
            case .success:
                break
            case .failure(let error):
                self.errors.append(error)
            }
        }
    }
}

protocol NetworkProtocol {
    func callLogin(email: String, password: String, onComplete: @escaping (Result<Void, NetworkError>) -> Void)
}

class Network: NetworkProtocol {
    func callLogin(email: String, password: String, onComplete: @escaping (Result<Void, NetworkError>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            onComplete(.success(()))
        }
    }
}
