import SwiftUI
import Combine

final class ContentViewModel: ObservableObject {
    enum UserInterfaceEvent {
        case itemTapped(Animal)
        case refreshTapped
    }

    @Published var navigationPath: NavigationPath = .init() // [Animal] = []
    @Published var items = Animal.makeRandomAnimals()

    let eventSubject = PassthroughSubject<UserInterfaceEvent, Never>()
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        $navigationPath
            .sink { print("ContentViewModel:$navigationPath: \($0)") }
            .store(in: &subscriptions)

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

    @ObservedObject var viewModel: ContentViewModel = .init()

    @Environment(\.detailView) var detailView

    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.items) { item in
                        Text(item.description)
                            .font(.largeTitle)
                            .padding(.vertical)
                            .onTapGesture {
                                viewModel.eventSubject.send(.itemTapped(item))
                            }
                    }
                }
                .navigationDestination(
                    for: Animal.self,
                    destination: { [weak viewModel] in detailView(animal: $0, navigationPath: viewModel?.navigationPath) }
                )
            }
            .navigationTitle("Home")
            .toolbar {
                Button {
                    viewModel.eventSubject.send(.refreshTapped)
                } label: {
                    Image(systemName: "goforward")
                }
                .toolbar(.automatic, for: .navigationBar)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
