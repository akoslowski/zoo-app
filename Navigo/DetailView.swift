import SwiftUI
import Combine

final class DetailViewModel: ObservableObject {

    enum UserInterfaceEvent {
        case animalsYouMayLikeTapped
    }

    let animal: Animal
    @Binding var navigationPath: NavigationPath
    let eventSubject = PassthroughSubject<UserInterfaceEvent, Never>()
    private var subscriptions = Set<AnyCancellable>()

    init(animal: Animal, navigationPath: Binding<NavigationPath>) {
        _navigationPath = navigationPath
        self.animal = animal

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

    @StateObject var viewModel: DetailViewModel

    var body: some View {
        VStack {
            Text(viewModel.animal.icon)
                .font(.system(size: 200))
                .padding()

            Spacer()

            Button {
                viewModel.eventSubject.send(.animalsYouMayLikeTapped)
            } label: {
                Text("Other animals you may like")
            }
            .buttonStyle(.bordered)
            .padding()
        }
        .navigationBarTitle(viewModel.animal.name)
        .navigationDestination(for: DetailViewModel.UserInterfaceEvent.self) {
            Text(String(describing: $0))
        }
    }
}


struct DetailView_Previews: PreviewProvider {
    @State private static var navigationPath: NavigationPath = .init()

    static var previews: some View {
        NavigationStack(path: $navigationPath) {
            DetailView(viewModel: .init(animal: .makeRandomAnimal(), navigationPath: $navigationPath))
        }
    }
}
