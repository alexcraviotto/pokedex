//
//  VistaBusqueda.swift
//  pokedex
//
//  Created by Antonio Ordóñez on 16/11/24.
//

import SwiftUI

struct VistaBusqueda: View {
    
    @State var pokemons: [PokemonPair] = []
    @State private var showFilters = false
    @StateObject private var filterManager = FilterManager()
    @State private var tipoSeleccionado:String = ""
    @State private var log : String = ""

    
    let columnas = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @State var query: String = ""
    @State var filtrado: [Pokemon] = []

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        Text("Búsqueda")
                            .font(.custom("Press Start 2P Regular", size: 24))
                            .foregroundColor(.black)
                        Spacer()
                    }.padding()

                    BusquedaView(text: $query)
                        .padding(.leading,-50)
                        .onChange(of: query) { newValue in
                                log = newValue // Actualizamos la variable de estado `log`
                                buscar()       // Llamamos al método buscar
                            }
                    HStack {
                        Button{
                            withAnimation {
                                showFilters = true
                            }
                        }label: {
                            Image("filtro")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                            Text("Tipos")
                                .font(.custom("Press Start 2P Regular", size: 12))
                                .foregroundColor(.black)
                        }
                        .frame(width: 120, height: 30)
                        .shadow(radius: 9)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.gray.opacity(0.1))
                        )
                        .offset(CGSize(width: 40, height: 0))
                        .padding(.leading,-25)
                        Spacer()
                        
                    }
                    
                    ScrollView {
                        if !filtrado.isEmpty {
                            LazyVGrid(columns: columnas, spacing: 20) {
                                ForEach(filtrado.sorted(by: {$0.id < $1.id}), id: \.id) { pokemon in
                                        NavigationLink(
                                            destination: VistaDetalle(id: pokemon.id)
                                        ) {
                                            PokemonTarjeta2(
                                                pokemon: pokemon
                                            )
                                            .scaleEffect(0.9)
                                            .foregroundColor(.black)
                                        }
                                }
                            }
                        } else if query.count >= 3 {
                            Text("No se encontraron resultados").padding()
                        }
                    }
                    .onChange(of: tipoSeleccionado) { newValue in
                        if filtrado.isEmpty {
                            return
                        }
                        buscar()

                    }
                }
                .onAppear {
                    fetchPokemonNames { result in
                        switch result {
                        case .success(let pokemons):
                            self.pokemons.append(contentsOf: pokemons)
                        case .failure(let error):
                            print("Error: \(error)")
                        }
                    }
                }
                if showFilters {
                    FilterView(isShowing: $showFilters, filterManager: filterManager, seleccionado: $tipoSeleccionado)
                        .transition(.move(edge: .leading))
                }
            }
        }
    }
    
    func filterPokemonByName(pokemonArray: [PokemonPair], searchTerm: String) -> [String] {
        let filtros = pokemonArray.filter { $0.name.lowercased().contains(searchTerm.lowercased()) }
        return filtros.map { PokemonPair in
            PokemonPair.name
        }
    }
    func buscar() {
        let currentLog = log // Capturamos el valor actual de log al inicio

        // Reiniciamos el filtro antes de realizar la búsqueda
        filtrado = []

        // Si la barra de búsqueda está vacía, no hacemos nada
        if currentLog.isEmpty {
            return
        }

        // Obtener nombres coincidentes
        let nombres = filterPokemonByName(pokemonArray: pokemons, searchTerm: currentLog)

        // Si no hay nombres coincidentes, no hacemos llamadas adicionales
        if nombres.isEmpty {
            return
        }

        // Consultar datos para los nombres encontrados
        var pokemonTemp: [Pokemon] = []
        let group = DispatchGroup()

        for nombre in nombres {
            group.enter()
            fetchPokemonData(pokemonId: nombre) { result in
                defer { group.leave() } // Asegura que se salga del grupo después de cada solicitud
                if currentLog != log {
                    return // Salimos si el contenido de log ha cambiado
                }
                switch result {
                case .success(let newpokemon):
                    pokemonTemp.append(newpokemon)
                case .failure(let error):
                    print("Error al buscar \(nombre): \(error)")
                }
            }
        }

        // Una vez completadas todas las consultas, actualizamos `filtrado`
        group.notify(queue: .main) {
            if currentLog != log {
                return // Salimos si el contenido de log ha cambiado
            }
            self.filtrado = pokemonTemp.filter { pokemon in
                // Aplicar el filtro por tipo solo después de obtener todos los resultados
                guard !tipoSeleccionado.isEmpty else {
                    return true
                }
                let types = pokemon.types.map { $0.type.name.lowercased() }
                return types.contains(tipoSeleccionado.lowercased())
            }
        }
    }

}

struct BusquedaView: View {
    @Binding var text: String
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(text.isEmpty
                    ? Color(UIColor.gray).opacity(0.6)
                    : Color(UIColor.gray).opacity(0.9))
            TextField("Buscar…", text: $text)
            Button {
                text = ""
            } label: {
                Image(systemName: "x.circle")
            }.opacity(text.isEmpty ? 0.0 : 1.0)
        }
        .frame(width: 320, height: 30)
        .shadow(radius: 20)
        .background(
            RoundedRectangle(cornerRadius: 9)
                .fill(Color.gray.opacity(0.1))
        )
    }
}

struct FilterView: View {
    @Binding var isShowing: Bool
    @ObservedObject var filterManager: FilterManager
    @Binding var seleccionado:String
    let tipos = ["bug", "dark", "dragon", "electric", "fairy", "fighting", "fire", "flying", "ghost", "grass", "ground", "ice", "poison", "psychic", "rock", "steel", "water", "normal"]

    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                VStack {
                    Text("Tipos")
                        .font(.custom("Press Start 2P Regular", size: 24))
                        .foregroundColor(.black)
                    
                    // ScrollView para los filtros
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(tipos, id: \.self){ tipo in                                Toggle(tipo.capitalized, isOn: Binding(
                                    get: {
                                        seleccionado == tipo
                                    },
                                    set: { newValue in
                                        if seleccionado == tipo {
                                            seleccionado = ""
                                        } else {
                                            filterManager.resetExcluding(tipo: tipo)
                                            seleccionado = tipo
                                        }
                                        withAnimation(.easeInOut.speed(0.4)) {
                                            isShowing = false
                                        }
                                    }
                                ))
                                .font(.custom("Press Start 2P Regular", size: 12))
                                .foregroundColor(.black)
                            }
                        }
                        .padding()
                    }
                    
                    Spacer()
                    
                    // Botones de acción
                    /*HStack {
                        Button("Resetear") {
                            filterManager.resetFilters()
                        }
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(10)
                        
                        Button("Cerrar") {
                            withAnimation {
                                isShowing = false
                            }
                        }
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                    }
                    .padding(.bottom)*/
                }
                .frame(width: geometry.size.width * 0.6)
                .background(Color.white)
                
                Color.black.opacity(0.3)
                    .onTapGesture {
                        withAnimation {
                            isShowing = false
                        }
                    }
            }
            .offset(x: isShowing ? 0 : -geometry.size.width)
        }
    }
}

class FilterManager: ObservableObject {
    @Published var bicho = false
    @Published var siniestro = false
    @Published var dragon = false
    @Published var electrico = false
    @Published var hada = false
    @Published var lucha = false
    @Published var fuego = false
    @Published var volador = false
    @Published var fantasma = false
    @Published var planta = false
    @Published var tierra = false
    @Published var hielo = false
    @Published var veneno = false
    @Published var psiquico = false
    @Published var roca = false
    @Published var metal = false
    @Published var agua = false
    @Published var normal = false

    // Función para resetear todos los toggles excepto el que corresponde al tipo
    func resetExcluding(tipo: String) {
        // Desactivamos todos los toggles
        bicho = false
        siniestro = false
        dragon = false
        electrico = false
        hada = false
        lucha = false
        fuego = false
        volador = false
        fantasma = false
        planta = false
        tierra = false
        hielo = false
        veneno = false
        psiquico = false
        roca = false
        metal = false
        agua = false
        normal = false

        // Activamos el toggle correspondiente al tipo seleccionado
        switch tipo {
        case "bug": bicho = true
        case "dark": siniestro = true
        case "dragon": dragon = true
        case "electric": electrico = true
        case "fairy": hada = true
        case "fighting": lucha = true
        case "fire": fuego = true
        case "flying": volador = true
        case "ghost": fantasma = true
        case "grass": planta = true
        case "ground": tierra = true
        case "ice": hielo = true
        case "poison": veneno = true
        case "psychic": psiquico = true
        case "rock": roca = true
        case "steel": metal = true
        case "water": agua = true
        case "normal": normal = true
        default: break
        }
    }
}



#Preview(){
    VistaBusqueda()
}
