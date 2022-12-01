import Foundation
import CryptoKit

struct Animal: Identifiable, Hashable, CustomStringConvertible {
    let id: String
    let icon: String
    let name: String
    let description: String

    init(icon: String, name: String) {
        self.id = makeHash(name)
        self.icon = icon
        self.name = name
        self.description = "\(icon) \(name)"
    }
}

extension Animal {
    static func makeRandomAnimals(count: Int = 20) -> [Self] {
        Array(Set((1...count).compactMap { _ in Animal.all.randomElement() }))
    }

    static func makeRandomAnimal() -> Self {
        Animal.all.randomElement() ?? Animal.all.first!
    }

    // Taken from https://emojipedia.org/nature/
    static let all: [Self] = [
        .init(icon: "🐵", name: "Monkey Face"), .init(icon: "🐒", name: "Monkey"), .init(icon: "🦍", name: "Gorilla"), .init(icon: "🦧", name: "Orangutan"), .init(icon: "🐶", name: "Dog Face"), .init(icon: "🐕", name: "Dog"), .init(icon: "🦮", name: "Guide Dog"), .init(icon: "🐕‍🦺", name: "Service Dog"), .init(icon: "🐩", name: "Poodle"), .init(icon: "🐺", name: "Wolf"), .init(icon: "🦊", name: "Fox"), .init(icon: "🦝", name: "Raccoon"), .init(icon: "🐱", name: "Cat Face"), .init(icon: "🐈", name: "Cat"), .init(icon: "🐈‍⬛", name: "Black Cat"), .init(icon: "🦁", name: "Lion"), .init(icon: "🐯", name: "Tiger Face"), .init(icon: "🐅", name: "Tiger"), .init(icon: "🐆", name: "Leopard"), .init(icon: "🐴", name: "Horse Face"), .init(icon: "🐎", name: "Horse"), .init(icon: "🦄", name: "Unicorn"), .init(icon: "🦓", name: "Zebra"), .init(icon: "🦌", name: "Deer"), .init(icon: "🦬", name: "Bison"), .init(icon: "🐮", name: "Cow Face"), .init(icon: "🐂", name: "Ox"), .init(icon: "🐃", name: "Water Buffalo"), .init(icon: "🐄", name: "Cow"), .init(icon: "🐷", name: "Pig Face"), .init(icon: "🐖", name: "Pig"), .init(icon: "🐗", name: "Boar"), .init(icon: "🐽", name: "Pig Nose"), .init(icon: "🐏", name: "Ram"), .init(icon: "🐑", name: "Ewe"), .init(icon: "🐐", name: "Goat"), .init(icon: "🐪", name: "Camel"), .init(icon: "🐫", name: "Two-Hump Camel"), .init(icon: "🦙", name: "Llama"), .init(icon: "🦒", name: "Giraffe"), .init(icon: "🐘", name: "Elephant"), .init(icon: "🦣", name: "Mammoth"), .init(icon: "🦏", name: "Rhinoceros"), .init(icon: "🦛", name: "Hippopotamus"), .init(icon: "🐭", name: "Mouse Face"), .init(icon: "🐁", name: "Mouse"), .init(icon: "🐀", name: "Rat"), .init(icon: "🐹", name: "Hamster"), .init(icon: "🐰", name: "Rabbit Face"), .init(icon: "🐇", name: "Rabbit"), .init(icon: "🐿️", name: "Chipmunk"), .init(icon: "🦫", name: "Beaver"), .init(icon: "🦔", name: "Hedgehog"), .init(icon: "🦇", name: "Bat"), .init(icon: "🐻", name: "Bear"), .init(icon: "🐻‍❄️", name: "Polar Bear"), .init(icon: "🐨", name: "Koala"), .init(icon: "🐼", name: "Panda"), .init(icon: "🦥", name: "Sloth"), .init(icon: "🦦", name: "Otter"), .init(icon: "🦨", name: "Skunk"), .init(icon: "🦘", name: "Kangaroo"), .init(icon: "🦡", name: "Badger"), .init(icon: "🐾", name: "Paw Prints"), .init(icon: "🦃", name: "Turkey"), .init(icon: "🐔", name: "Chicken"), .init(icon: "🐓", name: "Rooster"), .init(icon: "🐣", name: "Hatching Chick"), .init(icon: "🐤", name: "Baby Chick"), .init(icon: "🐥", name: "Front-Facing Baby Chick"), .init(icon: "🐦", name: "Bird"), .init(icon: "🐧", name: "Penguin"), .init(icon: "🕊️", name: "Dove"), .init(icon: "🦅", name: "Eagle"), .init(icon: "🦆", name: "Duck"), .init(icon: "🦢", name: "Swan"), .init(icon: "🦉", name: "Owl"), .init(icon: "🦤", name: "Dodo"), .init(icon: "🦩", name: "Flamingo"), .init(icon: "🦚", name: "Peacock"), .init(icon: "🦜", name: "Parrot"), .init(icon: "🐸", name: "Frog"), .init(icon: "🐊", name: "Crocodile"), .init(icon: "🐢", name: "Turtle"), .init(icon: "🦎", name: "Lizard"), .init(icon: "🐍", name: "Snake"), .init(icon: "🐲", name: "Dragon Face"), .init(icon: "🐉", name: "Dragon"), .init(icon: "🦕", name: "Sauropod"), .init(icon: "🦖", name: "T-Rex"), .init(icon: "🐳", name: "Spouting Whale"), .init(icon: "🐋", name: "Whale"), .init(icon: "🐬", name: "Dolphin"), .init(icon: "🦭", name: "Seal"), .init(icon: "🐟", name: "Fish"), .init(icon: "🐠", name: "Tropical Fish"), .init(icon: "🐡", name: "Blowfish"), .init(icon: "🦈", name: "Shark"), .init(icon: "🐙", name: "Octopus"), .init(icon: "🐚", name: "Spiral Shell"), .init(icon: "🪸", name: "Coral"), .init(icon: "🐌", name: "Snail"), .init(icon: "🦋", name: "Butterfly"), .init(icon: "🐛", name: "Bug"), .init(icon: "🐜", name: "Ant"), .init(icon: "🐝", name: "Honeybee"), .init(icon: "🪲", name: "Beetle"), .init(icon: "🐞", name: "Lady Beetle"), .init(icon: "🦗", name: "Cricket"), .init(icon: "🪳", name: "Cockroach"), .init(icon: "🕷️", name: "Spider"), .init(icon: "🦂", name: "Scorpion"), .init(icon: "🦟", name: "Mosquito"), .init(icon: "🪰", name: "Fly"), .init(icon: "🪱", name: "Worm")]
}


private func makeHash(_ string: String, length: Int = 6) -> String {
    let data = Data(string.utf8)

    return String(
        SHA256.hash(data: data)
            .compactMap { String(format: "%02x", $0) }
            .joined()
            .prefix(length)
    )
}
