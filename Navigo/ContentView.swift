import SwiftUI
import Combine

final class ContentViewModel: ObservableObject {
    enum UserInterfaceEvent {
        case itemTapped(Animal)
        case refreshTapped
    }

    @Binding var navigationPath: NavigationPath
    @Published var items = Animal.makeRandomAnimals()

    let eventSubject = PassthroughSubject<UserInterfaceEvent, Never>()
    private var subscriptions = Set<AnyCancellable>()
    
    init(navigationPath: Binding<NavigationPath>) {
        _navigationPath = navigationPath

        eventSubject
            .sink { print("ContentViewModel:received: \($0)") }
            .store(in: &subscriptions)

        eventSubject
            .sink { [weak self] in self?.handleEvent($0) }
            .store(in: &subscriptions)
    }

    func handleEvent(_ event: UserInterfaceEvent) {
        switch event {
        case .itemTapped(let item):
            navigationPath.append(item)
        case .refreshTapped:
            items = Animal.makeRandomAnimals()
        }
    }
}

struct ContentView: View {

    @StateObject var viewModel: ContentViewModel
    @Environment(\.detailView) var detailView

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.items) { item in
                    AnimalView(animal: item)
                        .onTapGesture {
                            viewModel.eventSubject.send(.itemTapped(item))
                        }
                }
            }
            .navigationDestination(
                for: Animal.self,
                destination: { detailView(animal: $0, navigationPath: $viewModel.navigationPath) }
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationTitle("Home")
        .toolbar {
            Button {
                viewModel.eventSubject.send(.refreshTapped)
            } label: {
                Image(systemName: "arrow.clockwise")
            }
            .toolbar(.automatic, for: .navigationBar)
        }
    }
}

// FIXME: Navigation in previews is broken. It works when running the app in simulator though.
struct ContentView_Previews: PreviewProvider {
    @StateObject private static var navigator: Navigator = .init()
    @State private static var navigationPath: NavigationPath = .init()

    static var previews: some View {
        TabView {
            NavigationStack(path: $navigator.navigationPath) {
                ContentView(viewModel: .init(navigationPath: $navigator.navigationPath))
            }
            .tabItem {
                Label { Text("Animals") } icon: { Image(systemName: "circle") }
            }
        }
    }
}
