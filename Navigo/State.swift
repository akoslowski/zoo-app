import SwiftUI

struct State<Element> {
    @Binding var navigationPath: NavigationPath
    var element: Element

    mutating func update(_ update: (inout State) throws -> Void) throws {
        var mutableState = self
        try update(&mutableState)
        navigationPath = mutableState.navigationPath
        element = mutableState.element
    }
}
