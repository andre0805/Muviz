//
//  DRUMRE LAB1
//  SearchRouter.swift
//
//  Andre Flego
//

import Foundation

enum SearchPushDestination: PushDestination {
    case movieDetails(Movie)
}

enum SearchSheetDestination: SheetDestination {
    case userInfo

    var id: String {
//        UUID().uuidString
        ""
    }
}

enum SearchSwitchDestination: SwitchDestination {
}

class SearchRouter: Router<SearchPushDestination, SearchSheetDestination, SearchSwitchDestination> {

}
