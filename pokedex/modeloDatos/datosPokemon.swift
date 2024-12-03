//
//  datosPokemon.swift
//  pokedex
//
//  Created by Antonio Ordóñez on 16/11/24.
//

import SwiftUI

/*struct Pokemon: Identifiable {
    let id = UUID()
    var nombre: String
    var tipo: String
    var tipoS: String
    var numero: String
    var imagen: String
}*/

struct Pokemon: Decodable, Identifiable {
    let id: Int
    let name: String
    let types: [Types]
    let sprites: Sprites
    
    struct Types: Decodable {
        let type: PokemonType
    }
    
    struct PokemonType: Decodable {
        let name: String
    }
    
    struct Sprites: Decodable {
        let other: OtherSprites
    }
    
    struct OtherSprites: Decodable {
        let officialArtwork: OfficialArtwork
        
        enum CodingKeys: String, CodingKey {
            case officialArtwork = "official-artwork"
        }
    }
    
    struct OfficialArtwork: Decodable  {
        let frontDefault: String
        
        
        enum CodingKeys: String, CodingKey {
            case frontDefault = "front_default"
        }
    }
}

struct Pokemon2: Identifiable {
        let id: Int
        let name: String
        let description: String
        let types: [String]
        let weight: Float
        let height: Float
        let stats: [String: Int]
        let image: Image
        let image_shiny: Image
        let evolution_chain_id: Int
    }

