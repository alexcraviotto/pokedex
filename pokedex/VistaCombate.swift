//
//  VistaCombate.swift
//  pokedex
//
//  Created by Antonio Ordóñez on 3/12/24.
//

import SwiftUI

struct VistaCombate: View {
    @State var contrincante: Bool = false // Si se selecciona IA, es false. Si es multijugador, es true.
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(spacing: 20) {
                    NavigationLink(destination: eleccionPokemon(contrincante: false)) {
                        VStack(spacing: 20) {
                            Image("Mewtwo")
                                .renderingMode(.original)
                            Text("Contra la IA")
                                .font(.custom("Press Start 2P Regular", size: 16))
                                .foregroundColor(.black)
                        }
                        .frame(width: 330, height: 190)
                    }
                    .padding()
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 2)
                    ).shadow(radius: 10)
                    
                    NavigationLink(destination: eleccionPokemon(contrincante: true)) {
                        VStack {
                            HStack(spacing: 10) {
                                Image("Zekrom")
                                    .renderingMode(.original)
                                Image("Reshiram")
                                    .renderingMode(.original)
                            }
                            Text("Multijugador")
                                .font(.custom("Press Start 2P Regular", size: 16))
                                .foregroundColor(.black)
                        }
                        .frame(width: 330, height: 190)
                        .padding()
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 2)
                        )
                    }
                    .shadow(radius: 10)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Combate")
                        .font(.custom("Press Start 2P Regular", size: 24))
                        .foregroundColor(.black)
                }
            }
        }
    }
}

#Preview {
    VistaCombate()
}
