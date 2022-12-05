import SwiftUI

struct AnimalView: View {
    let animal: Animal
    let action: () -> Void

    var body: some View {
        Label(title: {
            Text(animal.name).font(.largeTitle)
        }, icon: {
            Text(animal.icon).font(.title)
        })
        .padding()
        .contentShape(Rectangle())
        .onTapGesture(perform: action)
    }
}

struct AnimalView_Previews: PreviewProvider {
    static var previews: some View {
        AnimalView(animal: .makeRandomAnimal()) {}
    }
}
