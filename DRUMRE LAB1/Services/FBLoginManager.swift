//
//  DRUMRE LAB1
//  FBLoginManager.swift
//
//  Andre Flego
//

import Foundation
import FacebookLogin

class FBLoginManager: ObservableObject {
    let loginManager = LoginManager()
    
    static let shared = FBLoginManager()

    private init() {
    }
}
