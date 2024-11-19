import Combine
import SwiftUI
import SDWebImageSwiftUI

struct ContentView: View {
    @State private var pokemonID: String = ""
    @State private var frontSpriteURL: String?
    @State private var backSpriteURL: String?
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            // Campo de texto para ingresar el ID del Pokémon
            TextField("Enter Pokémon ID", text: $pokemonID)
                .keyboardType(.numberPad)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            // Botón para buscar el Pokémon
            Button("Fetch Pokémon Sprites") {
                if let id = Int(pokemonID) {
                    fetchPokemonSprites(pokemonID: id)
                } else {
                    errorMessage = "Please enter a valid Pokémon ID."
                }
            }
            .padding()

            // Mostrar el mensaje de error si lo hay
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            // Mostrar las imágenes del Pokémon si existen
            if let frontSpriteURL = frontSpriteURL, let backSpriteURL = backSpriteURL {
                VStack {
                    Text("Front Sprite")
                    if let url = URL(string: frontSpriteURL) {
                        // Mostrar el GIF (Front) usando SDWebImageSwiftUI
                        WebImage(url: url)
                            .resizable()
                            .indicator(.activity) // Indicador de carga
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .padding()
                    }

                    Text("Back Sprite")
                    if let url = URL(string: backSpriteURL) {
                        // Mostrar el GIF (Back) usando SDWebImageSwiftUI
                        WebImage(url: url)
                            .resizable()
                            .indicator(.activity) // Indicador de carga
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .padding()
                    }
                }
            }
        }
        .padding()
    }

    // Función para obtener los sprites (frontal y trasero) del Pokémon
    func fetchPokemonSprites(pokemonID: Int) {
        // Resetear cualquier mensaje de error previo
        errorMessage = nil
        
        // Obtener el sprite frontal
        fetchPokemonFrontGif(pokemonID: pokemonID) { result in
            switch result {
            case .success(let frontURL):
                self.frontSpriteURL = frontURL
            case .failure(let error):
                self.errorMessage = "Error fetching front sprite: \(error.localizedDescription)"
            }
        }

        // Obtener el sprite trasero
        fetchPokemonBackGif(pokemonID: pokemonID) { result in
            switch result {
            case .success(let backURL):
                self.backSpriteURL = backURL
            case .failure(let error):
                self.errorMessage = "Error fetching back sprite: \(error.localizedDescription)"
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
