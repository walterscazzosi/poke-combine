//  PokemonListViewModel.swift
//  PokeCombine
//
//  Created by Scazzosi Walter on 22/05/2026.
//

import Foundation

struct PokemonResponse: Decodable {
    let results: [Pokemon]
}

struct Pokemon: Identifiable, Decodable {
    var id = UUID()
    let name: String
    let url: String
}

@Observable
class PokemonListViewModel {
    var pokemons: [Pokemon] = []
    
    func loadPokemon() {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=100") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(PokemonResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.pokemons = result.results.map { Pokemon(name: $0.name, url: $0.url) }
                    }
                } catch {
                    print("Failed to decode JSON: \(error)")
                }
            }
        }.resume()
    }
}
