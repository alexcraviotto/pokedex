//
//  VistaDetalle.swift
//  pokedex
//
//  Created by Aula03 on 26/11/24.
//

import SwiftUI

struct VistaDetalle: View {
    var pokemon : Pokemon
    var body: some View {
        PokemonTarjeta2(pokemon: pokemon)
    }
}

struct NavegacionVistaDetalle: View {
    var pokemon : Pokemon
    var body: some View {
        VistaDetalle(pokemon: pokemon)
    }
}

