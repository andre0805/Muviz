//
//  DRUMRE LAB1
//  UserInfoRouter.swift
//
//  Andre Flego
//

import Foundation

enum UserInfoPushDestination: PushDestination {
    case movieDetails(Movie)
}

enum UserInfoSheetDestination: SheetDestination {
    var id: String {
//        UUID().uuidString
        ""
    }
}

enum UserInfoSwitchDestination: SwitchDestination {
    case home
}

class UserInfoRouter: Router<UserInfoPushDestination, UserInfoSheetDestination, UserInfoSwitchDestination> {

}
