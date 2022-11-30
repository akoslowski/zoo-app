import SwiftUI
import Combine

final class DetailViewModel: ObservableObject {

    enum UserInterfaceEvent {
        case animalsYouMayLikeTapped
    }

    let animal: Animal
    @Published var navigationPath: NavigationPath
    let eventSubject = PassthroughSubject<UserInterfaceEvent, Never>()
    private var subscriptions = Set<AnyCancellable>()

    init(animal: Animal, navigationPath: NavigationPath?) {
        self.navigationPath = navigationPath ?? .init()
        self.animal = animal

        $navigationPath
            .sink { print("DetailViewModel:$navigationPath: \($0)") }
            .store(in: &subscriptions)

        eventSubject
            .sink { print("DetailViewModel:received: \($0)") }
            .store(in: &subscriptions)

        eventSubject
            .sink { [weak self] in self?.handleEvent($0) }
            .store(in: &subscriptions)
    }

    func handleEvent(_ event: UserInterfaceEvent) {
        navigationPath.append(event)
    }
}

struct DetailView: View {

    @ObservedObject var viewModel: DetailViewModel

    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            VStack {
                Text(viewModel.animal.icon).font(.system(size: 200)).padding()
                Spacer()
                Button {
                    viewModel.eventSubject.send(.animalsYouMayLikeTapped)
                } label: {
                    Text("Other animals you may like")
                }
                .padding()
            }
            .navigationDestination(for: DetailViewModel.UserInterfaceEvent.self) {
                Text(String(describing: $0))
            }
            .navigationBarTitle(viewModel.animal.name)
        }
    }
}


struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(viewModel: .init(animal: .makeRandomAnimal(), navigationPath: .init()))
        }
    }
}
