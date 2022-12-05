import SwiftUI

struct SceneState<Value> {
    @Binding var navigationPath: NavigationPath
    var value: Value

    mutating func update(_ update: (inout SceneState) throws -> Void) throws {
        var mutableState = self
        try update(&mutableState)
        navigationPath = mutableState.navigationPath
        value = mutableState.value
    }
}
