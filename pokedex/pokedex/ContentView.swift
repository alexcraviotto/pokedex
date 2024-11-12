//
//  ContentView.swift
//  pokedex
//
//  Created by Antonio Ordóñez on 5/11/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            VStack {
                Image("carga")
                    .resizable()
                    .scaledToFill()
                
            }
            Image("logoPokemon").resizable().scaledToFit().padding(.top, -300.0
            )
            Text("Pulsa para continuar").padding(.top, 620.0).foregroundColor(.white)
            
        }
    }
}

#Preview {
    ContentView()
}
