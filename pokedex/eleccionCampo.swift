//
//  eleccionCampo.swift
//  pokedex
//
//  Created by Antonio Ordóñez on 4/1/25.
//

import SwiftUI

struct eleccionCampo: View {
    var body: some View {
        VStack {
            Text("Elección de\ncampo de batalla\n")
                .font(.custom("Press Start 2P Regular", size: 24))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.top, 20)
            
            Button(action: {
                print("Hierba alta seleccionada")
            }) {
                Image("seleccionarHierbaAlta")
                    .resizable()
                    .aspectRatio(contentMode: .fit)

                    .overlay(
                        Text("Hierba alta")
                            .font(.custom("Press Start 2P Regular", size: 16))
                            .foregroundColor(.black)
                            .padding(),
                        alignment: .center
                    )
            }
            .padding()

            Button(action: {
                print("Desierto seleccionado")
            }) {
                Image("seleccionarDesierto")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .overlay(
                        Text("Desierto")
                            .font(.custom("Press Start 2P Regular", size: 16))
                            .foregroundColor(.black)
                            .padding(),
                        alignment: .center
                    )
            }
            .padding()

            Button(action: {
                print("Alto mando seleccionado")
            }) {
                Image("seleccionarAltoMando")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .overlay(
                        Text("Alto mando")
                            .font(.custom("Press Start 2P Regular", size: 16))
                            .foregroundColor(.black)
                            .padding(),
                        alignment: .center
                    )
            }
            .padding()
        }
    }
}

#Preview {
    eleccionCampo()
}
