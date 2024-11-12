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
            Text("Hola")
        }
    }
}

#Preview {
    ContentView()
}
