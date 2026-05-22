//
//  ContentView.swift
//  PokeCombine
//
//  Created by Scazzosi Walter on 22/05/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = PokemonListViewModel()
    
    var body: some View {
        NavigationStack {
            if viewModel.pokemons.isEmpty {
                VStack(spacing: 16) {
                    Text("No Pokémon loaded")
                        .foregroundStyle(.secondary)
                    
                    Button {
                        viewModel.loadPokemon()
                    } label: {
                        Text("Load Pokémon")
                            .fontWeight(.semibold)
                            .padding()
                            .glassEffect(.regular.interactive(), in: .capsule)
                    }
                }
            } else {
                ScrollView {
                    ForEach(Array(viewModel.pokemons.enumerated()), id: \.element.id) { idx, pokemon in
                        HStack(spacing: 20) {
                            AsyncImage(url: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(idx+1).png")) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .scaledToFit()
                                } else if phase.error != nil {
                                    Color.red.opacity(0.2)
                                } else {
                                    ProgressView()
                                }
                            }
                            .frame(width: 64, height: 64)
                            .background(Color(.systemGray6))
                            .clipShape(.circle)
                            
                            Text(pokemon.name.capitalized)
                                .font(.headline)
                                .foregroundStyle(.primary)
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                }
                .navigationTitle("Pokèdex")
            }
        }
        .overlay {
            if viewModel.loading {
                ProgressView()
            }
        }
    }
}

#Preview {
    ContentView()
}
