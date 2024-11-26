//
//  datosPokemon.swift
//  pokedex
//
//  Created by Antonio Ordóñez on 16/11/24.
//

import SwiftUI

struct Pokemon: Identifiable {
    let id = UUID()
    var nombre: String
    var tipo: String
    var tipoS: String
    var numero: String
    var imagen: String
}
