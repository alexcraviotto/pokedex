//
//  batalla.swift
//  pokedex
//
//  Created by Antonio Ordóñez on 4/1/25.
//

import SwiftUI

struct combate: View {
    // Placeholder para los Pokémon de los equipos
    @State private var team1: [Pokemon2] = [
          Pokemon2(id: 1, name: "Pikachu", description: "Electric mouse", types: ["Electric"], weakTypes: ["Ground"], weight: 6.0, height: 0.4, stats: ["HP": 35, "Speed": 90], image: Image("pikachu"), image_shiny: Image("pikachu_shiny"), evolution_chain_id: 1),
          Pokemon2(id: 2, name: "Bulbasaur", description: "Grass/Poison", types: ["Grass", "Poison"], weakTypes: ["Fire", "Flying", "Ice"], weight: 6.9, height: 0.7, stats: ["HP": 45, "Speed": 45], image: Image("bulbasaur"), image_shiny: Image("bulbasaur_shiny"), evolution_chain_id: 2),
          Pokemon2(id: 3, name: "Charmander", description: "Fire lizard", types: ["Fire"], weakTypes: ["Water", "Ground", "Rock"], weight: 8.5, height: 0.6, stats: ["HP": 39, "Speed": 65], image: Image("charmander"), image_shiny: Image("charmander_shiny"), evolution_chain_id: 3)
      ]
        
    @State private var team2: [Pokemon2] = [
        Pokemon2(id: 4, name: "Squirtle", description: "Water turtle", types: ["Water"], weakTypes: ["Electric", "Grass"], weight: 9.0, height: 0.5, stats: ["HP": 44, "Speed": 43], image: Image("squirtle"), image_shiny: Image("squirtle_shiny"), evolution_chain_id: 4),
        Pokemon2(id: 5, name: "Jigglypuff", description: "Fairy/Normal", types: ["Fairy", "Normal"], weakTypes: ["Steel", "Poison"], weight: 5.5, height: 0.5, stats: ["HP": 115, "Speed": 20], image: Image("jigglypuff"), image_shiny: Image("jigglypuff_shiny"), evolution_chain_id: 5),
        Pokemon2(id: 6, name: "Meowth", description: "Cat Pokémon", types: ["Normal"], weakTypes: ["Fighting"], weight: 4.2, height: 0.4, stats: ["HP": 40, "Speed": 90], image: Image("meowth"), image_shiny: Image("meowth_shiny"), evolution_chain_id: 6)
    ]
    
    @State private var log: [String] = []
    @State private var currentTurn: Int = 1
    @State private var hpTeam1: Int = 0
    @State private var hpTeam2: Int = 0
    @State private var attacker: Int = 0
    @State private var damageTeam1: Int = 0
    @State private var damageTeam2: Int = 0

    
    func calcularVida(team: [Pokemon2]) -> Int {
        var totalHP = 0
        for pokemon in team {
            totalHP += pokemon.stats["HP"] ?? 0
        }
        return totalHP
    }
    
    func calcularPrimerAtacante() {
        let velocidadTeam1 = team1.reduce(0) { $0 + ($1.stats["Speed"] ?? 0) }
        let velocidadTeam2 = team2.reduce(0) { $0 + ($1.stats["Speed"] ?? 0) }
        
        if velocidadTeam1 > velocidadTeam2 {
            attacker = 1 // Equipo 1 ataca primero
        } else {
            attacker = 2 // Equipo 2 ataca primero
        }
    }
    
    var body: some View {
        ZStack {
            Image("fondoCombateHierba")
                .scaledToFit()
                .ignoresSafeArea()
            VStack {
                Text("\n\n\nHP del Equipo 1: \(hpTeam1)")
                         Text("HP del Equipo 2: \(hpTeam2)")
                         
                         Spacer()
                
                if(attacker == 1){
                    
                }else{
                    
                }
            }
            .padding()
            .onAppear {
             hpTeam1 = calcularVida(team: team1)
             hpTeam2 = calcularVida(team: team2)
            calcularPrimerAtacante()
            }
        }
    }
}

#Preview {
    combate()
}
