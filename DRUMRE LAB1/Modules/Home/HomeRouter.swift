//
//  DRUMRE LAB1
//  HomeRouter.swift
//
//  Andre Flego
//

import Foundation

enum HomePushDestination: PushDestination {
    case movieDetails(Movie)
}

enum HomeSheetDestination: SheetDestination {
    case userInfo(User)
    
    var id: String {
        UUID().uuidString
    }
}

enum HomeSwitchDestination: SwitchDestination {
}

class HomeRouter: Router<HomePushDestination, HomeSheetDestination, HomeSwitchDestination> {
    
}
