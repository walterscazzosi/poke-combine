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
    var loading = false
    var pokemons: [Pokemon] = []
    
    private let pokemonsPublisher = CurrentValueSubject<[Pokemon], Never>([])
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        pokemonsPublisher
            .debounce(for: .seconds(3), scheduler: RunLoop.main)
            .sink {
                self.pokemons = $0
                self.loading = false
            }
            .store(in: &cancellables)
    }
    
    func loadPokemon() {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=100") else { return }
        
        loading = true
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: PokemonResponse.self, decoder: JSONDecoder())
            .sink(
                receiveCompletion: {
                    print ("Received completion: \($0).")
                },
                receiveValue: {
                    self.pokemonsPublisher.send(
                        $0.results.map { Pokemon(name: $0.name, url: $0.url) }
                    )
                }
            )
            .store(in: &cancellables)
    }
}
