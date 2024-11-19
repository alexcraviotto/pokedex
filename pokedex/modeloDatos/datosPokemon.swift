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
    let id: String
    let name: String
    let types: [Types]
    let sprites: Sprites
    
    struct Types: Decodable {
        let types: PokemonType
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
    
    struct OfficialArtwork: Decodable {
        let frontDefault: String
        
        enum CodingKeys: String, CodingKey {
            case frontDefault = "front_default"
        }
    }
}
