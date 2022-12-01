import SwiftUI
import Combine

final class ContentViewModel: ObservableObject {
    enum UserInterfaceEvent {
        case itemTapped(Animal)
        case refreshTapped
    }

    @Published var state: State<[Animal]>

    let eventSubject = PassthroughSubject<UserInterfaceEvent, Never>()
    private var subscriptions = Set<AnyCancellable>()
    
    init(navigationPath: Binding<NavigationPath>) {
        state = .init(
            navigationPath: navigationPath,
            element: Animal.makeRandomAnimals()
        )

        eventSubject
            .sink { print("ContentViewModel:received: \($0)") }
            .store(in: &subscriptions)

        eventSubject
            .sink { [weak self] in self?.handleEvent($0) }
            .store(in: &subscriptions)
    }

    func handleEvent(_ event: UserInterfaceEvent) {
        switch event {
        case .itemTapped(let animal):
            try? state.update {
                $0.navigationPath.append(animal)
            }

        case .refreshTapped:
            try? state.update {
                $0.navigationPath = .init()
                $0.element = Animal.makeRandomAnimals()
            }
        }
    }
}

struct ContentView: View {

    // When using an @ObservedObject here, when going back the view is re-rendered and the viewModel recreated.
    // @ObservedObject var viewModel: ContentViewModel
    @StateObject var viewModel: ContentViewModel
    @Environment(\.detailView) var detailView

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.state.element) { item in
                    AnimalView(animal: item)
                        .onTapGesture {
                            viewModel.eventSubject.send(.itemTapped(item))
                        }
                }
            }
            .navigationDestination(
                for: Animal.self,
                destination: { detailView(animal: $0, navigationPath: $viewModel.state.navigationPath) }
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationTitle("Animals")
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

struct ContentView_Previews: PreviewProvider {
    @ObservedObject private static var navigator: Navigator = .init()

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
