import SwiftUI

@main
struct PokedexApp: App {
    var body: some Scene {
        WindowGroup {
            Combate(pokemonsUsuario: [
                // Equipo modificado
                Pokemon2(
                    id: 1, name: "Zekrom", description: "Dragon/Electric Pokémon", types: ["Dragon", "Electric"],
                    weakTypes: ["Ice", "Fairy", "Dragon", "Ground"], weight: 345.0, height: 2.9,
                    stats: ["hp": 100, "speed": 90], image: Image("Zekrom"),
                    image_shiny: Image("Zekrom"), evolution_chain_id: 1),
                Pokemon2(
                    id: 2, name: "Reshiram", description: "Dragon/Fire Pokémon", types: ["Dragon", "Fire"],
                    weakTypes: ["Rock", "Ground", "Dragon"], weight: 330.0, height: 3.2,
                    stats: ["hp": 100, "speed": 90], image: Image("Reshiram"),
                    image_shiny: Image("Reshiram"), evolution_chain_id: 2),
                Pokemon2(
                    id: 3, name: "Mewtwo", description: "Psychic Pokémon", types: ["Psychic"],
                    weakTypes: ["Bug", "Ghost", "Dark"], weight: 122.0, height: 2.0,
                    stats: ["hp": 106, "speed": 130], image: Image("Mewtwo"),
                    image_shiny: Image("Mewtwo"), evolution_chain_id: 3),
                Pokemon2(
                    id: 1, name: "Zekrom", description: "Dragon/Electric Pokémon", types: ["Dragon", "Electric"],
                    weakTypes: ["Ice", "Fairy", "Dragon", "Ground"], weight: 345.0, height: 2.9,
                    stats: ["hp": 100, "speed": 90], image: Image("Zekrom"),
                    image_shiny: Image("Zekrom"), evolution_chain_id: 1),
                Pokemon2(
                    id: 2, name: "Reshiram", description: "Dragon/Fire Pokémon", types: ["Dragon", "Fire"],
                    weakTypes: ["Rock", "Ground", "Dragon"], weight: 330.0, height: 3.2,
                    stats: ["hp": 100, "speed": 90], image: Image("Reshiram"),
                    image_shiny: Image("Reshiram"), evolution_chain_id: 2),
                Pokemon2(
                    id: 3, name: "Mewtwo", description: "Psychic Pokémon", types: ["Psychic"],
                    weakTypes: ["Bug", "Ghost", "Dark"], weight: 122.0, height: 2.0,
                    stats: ["hp": 106, "speed": 130], image: Image("Mewtwo"),
                    image_shiny: Image("Mewtwo"), evolution_chain_id: 3)
            ]
, campoBatalla: "fondoCombateHierba")
        }
       /* WindowGroup {
              Inicio()
          }*/
    }
}
