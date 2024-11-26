//
//  PokemonPair.swift
//  pokedex
//
//  Created by Aula03 on 26/11/24.
//

import SwiftUI

struct PokemonTypeResponse: Decodable {
    let results: [PokemonPairResponse]
}

// Estructura para cada entrada de Pokémon
struct PokemonEntry: Decodable {
    let pokemon: PokemonPairResponse
}

// Estructura para cada Pokémon
struct PokemonPairResponse: Decodable {
    let name: String
    let url: String
}

struct PokemonPair: Decodable {
    let name: String
    let id: Int
}
