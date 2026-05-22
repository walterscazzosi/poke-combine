//  PokemonListViewModel.swift
//  PokeCombine
//
//  Created by Scazzosi Walter on 22/05/2026.
//

import Combine
import Foundation

struct PokemonResponse: Decodable {
    let results: [PokemonResult]
}

struct PokemonResult: Decodable {
    let name: String
    let url: String
}

struct Pokemon: Identifiable {
    let id = UUID()
    let name: String
    let url: String
}

@Observable
class PokemonListViewModel {
    var pokemons: [Pokemon] = []
    
    var cancellables = Set<AnyCancellable>()
    
    func loadPokemon() {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=100") else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: PokemonResponse.self, decoder: JSONDecoder())
            .sink(
                receiveCompletion: { print ("Received completion: \($0).") },
                receiveValue: { self.pokemons = $0.results.map({ Pokemon(name: $0.name, url: $0.url) }) }
            )
            .store(in: &cancellables)
    }
}
