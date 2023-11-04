//
//  DRUMRE LAB1
//  MoviesRouter.swift
//
//  Andre Flego
//

import Foundation

enum MoviesPushDestination: PushDestination {
    case movieDetails(Movie)
}

enum MoviesSheetDestination: SheetDestination {
    case userInfo

    var id: String {
//        UUID().uuidString
        ""
    }
}

enum MoviesSwitchDestination: SwitchDestination {
}

class MoviesRouter: Router<MoviesPushDestination, MoviesSheetDestination, MoviesSwitchDestination> {

}
