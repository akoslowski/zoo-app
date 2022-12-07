import SwiftUI

struct SceneState<Value> {
    @Binding var navigationPath: NavigationPath
    var value: Value

    mutating func update(_ update: (inout SceneState) throws -> Void) rethrows {
        var mutableState = self
        try update(&mutableState)
        navigationPath = mutableState.navigationPath
        value = mutableState.value
    }
}

extension SceneState: Equatable where Value: Equatable {
    static func == (lhs: SceneState<Value>, rhs: SceneState<Value>) -> Bool {
        lhs.value == rhs.value
    }
}
