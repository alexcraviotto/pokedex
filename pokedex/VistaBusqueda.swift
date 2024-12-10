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
                        .onChange(of: query) { oldValue, newValue in
                            print(pokemons)
                            filtrado = []
                            if query.count >= 1 {
                                for nombre in filterPokemonByName(pokemonArray: pokemons, searchTerm: query) {
                                    print(nombre)
                                    fetchPokemonData(pokemonId: nombre) { result in
                                        switch result {
                                        case .success(let newpokemon):
                                            filtrado.append(newpokemon)
                                        case .failure(let error):
                                            print("Error: \(error)")
                                        }
                                    }
                                }
                            }
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
                        Spacer()
                    }
                    
                    ScrollView {
                        if !filtrado.isEmpty {
                            LazyVGrid(columns: columnas, spacing: 20) {
                                ForEach(filtrado.sorted(by: {$0.id < $1.id}), id: \.id) { pokemon in
                                    if tipoSeleccionado.isEmpty && tipoSeleccionado.lowercased().contains( pokemon.types[0].type.name){
                                        NavigationLink(
                                            destination: VistaDetalle(id: pokemon.id)
                                        ) {
                                            PokemonTarjeta2(
                                                pokemon: pokemon
                                            )
                                            .scaleEffect(0.9)
                                            .foregroundColor(.black)
                                            
                                        }
                                    } else {
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
                            }
                        } else if query.count >= 3 {
                            Text("No se encontraron resultados").padding()
                        }
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
                            
                            Toggle("Bicho", isOn: $filterManager.bicho)
                                .font(.custom("Press Start 2P Regular", size: 12))
                                .foregroundColor(.black)
                                .onChange(of: filterManager.bicho) {
                                    filterManager.resetExcluding(tipo: "bug")
                                    seleccionado = "bug"
                                    withAnimation(.easeInOut.speed(0.4)) {
                                        isShowing = false
                                    }

                                }
                            Toggle("Siniestro", isOn: $filterManager.siniestro)
                                .font(.custom("Press Start 2P Regular", size: 12))
                                .foregroundColor(.black)
                                .onTapGesture {
                                    filterManager.resetExcluding(tipo: "dark")
                                    seleccionado = "dark"
                                    withAnimation(.easeInOut.speed(0.4)) {
                                        isShowing = false
                                    }
                                }
                            Toggle("Dragon", isOn: $filterManager.dragon)
                                .font(.custom("Press Start 2P Regular", size: 12))
                                .foregroundColor(.black)
                                .onChange(of: filterManager.dragon) {
                                    filterManager.resetExcluding(tipo: "dragon")
                                    seleccionado = "dragon"
                                    withAnimation(.easeInOut.speed(0.4)) {
                                        isShowing = false
                                    }
                                }
                            Toggle("Electrico", isOn: $filterManager.electrico)
                                .font(.custom("Press Start 2P Regular", size: 12))
                                .foregroundColor(.black)
                                .onChange(of: filterManager.electrico) {
                                    filterManager.resetExcluding(tipo: "electric")
                                    seleccionado = "electric"
                                    withAnimation(.easeInOut.speed(0.4)) {
                                        isShowing = false
                                    }
                                }
                            Toggle("Hada", isOn: $filterManager.hada)
                                .font(.custom("Press Start 2P Regular", size: 12))
                                .foregroundColor(.black)
                                .onChange(of: filterManager.hada) {
                                    filterManager.resetExcluding(tipo: "fairy")
                                    seleccionado = "fairy"
                                    withAnimation(.easeInOut.speed(0.4)) {
                                        isShowing = false
                                    }
                                }
                            Toggle("Lucha", isOn: $filterManager.lucha)
                                .font(.custom("Press Start 2P Regular", size: 12))
                                .foregroundColor(.black)
                                .onChange(of: filterManager.lucha) {
                                    filterManager.resetExcluding(tipo: "fighting")
                                    seleccionado = "fighting"
                                    withAnimation(.easeInOut.speed(0.4)) {
                                        isShowing = false
                                    }
                                }
                            Toggle("Fuego", isOn: $filterManager.fuego)
                                .font(.custom("Press Start 2P Regular", size: 12))
                                .foregroundColor(.black)
                                .onChange(of: filterManager.fuego) {
                                    filterManager.resetExcluding(tipo: "fire")
                                    seleccionado = "fire"
                                    withAnimation(.easeInOut.speed(0.4)) {
                                        isShowing = false
                                    }
                                }
                            Toggle("Volador", isOn: $filterManager.volador)
                                .font(.custom("Press Start 2P Regular", size: 12))
                                .foregroundColor(.black)
                                .onChange(of: filterManager.volador) {
                                    filterManager.resetExcluding(tipo: "flying")
                                    seleccionado = "flying"
                                    withAnimation(.easeInOut.speed(0.4)) {
                                        isShowing = false
                                    }
                                }
                            Toggle("Fantasma", isOn: $filterManager.fantasma)
                                .font(.custom("Press Start 2P Regular", size: 12))
                                .foregroundColor(.black)
                                .onChange(of: filterManager.fantasma) {
                                    filterManager.resetExcluding(tipo: "ghost")
                                    seleccionado = "ghost"
                                    withAnimation(.easeInOut.speed(0.4)) {
                                        isShowing = false
                                    }
                                }
                            Toggle("Planta", isOn: $filterManager.planta)
                                .font(.custom("Press Start 2P Regular", size: 12))
                                .foregroundColor(.black)
                                .onChange(of: filterManager.planta) {
                                    filterManager.resetExcluding(tipo: "grass")
                                    seleccionado = "grass"
                                    withAnimation(.easeInOut.speed(0.4)) {
                                        isShowing = false
                                    }
                                }
                            Toggle("Hielo", isOn: $filterManager.hielo)
                                .font(.custom("Press Start 2P Regular", size: 12))
                                .foregroundColor(.black)
                                .onChange(of: filterManager.hielo) {
                                    filterManager.resetExcluding(tipo: "ice")
                                    seleccionado = "ice"
                                    withAnimation(.easeInOut.speed(0.4)) {
                                        isShowing = false
                                    }
                                }
                            Toggle("Veneno", isOn: $filterManager.veneno)
                                .font(.custom("Press Start 2P Regular", size: 12))
                                .foregroundColor(.black)
                                .onChange(of: filterManager.veneno) {
                                    filterManager.resetExcluding(tipo: "poison")
                                    seleccionado = "poison"
                                    withAnimation(.easeInOut.speed(0.4)) {
                                        isShowing = false
                                    }
                                }
                            Toggle("Psiquico", isOn: $filterManager.psiquico)
                                .font(.custom("Press Start 2P Regular", size: 12))
                                .foregroundColor(.black)
                                .onChange(of: filterManager.psiquico) {
                                    filterManager.resetExcluding(tipo: "psychic")
                                    seleccionado = "psychic"
                                    withAnimation(.easeInOut.speed(0.4)) {
                                        isShowing = false
                                    }
                                }
                            Toggle("Roca", isOn: $filterManager.roca)
                                .font(.custom("Press Start 2P Regular", size: 12))
                                .foregroundColor(.black)
                                .onChange(of: filterManager.roca) {
                                    filterManager.resetExcluding(tipo: "rock")
                                    seleccionado = "rock"
                                    withAnimation(.easeInOut.speed(0.4)) {
                                        isShowing = false
                                    }
                                }
                            Toggle("Metal", isOn: $filterManager.metal)
                                .font(.custom("Press Start 2P Regular", size: 12))
                                .foregroundColor(.black)
                                .onChange(of: filterManager.metal) {
                                    filterManager.resetExcluding(tipo: "steel")
                                    seleccionado = "steel"
                                    withAnimation(.easeInOut.speed(0.4)) {
                                        isShowing = false
                                    }
                                }
                            Toggle("Agua", isOn: $filterManager.agua)
                                .font(.custom("Press Start 2P Regular", size: 12))
                                .foregroundColor(.black)
                                .onChange(of: filterManager.agua) {
                                    filterManager.resetExcluding(tipo: "water")
                                    seleccionado = "water"
                                    withAnimation(.easeInOut.speed(0.4)) {
                                        isShowing = false
                                    }
                                }
                            Toggle("Normal", isOn: $filterManager.normal)
                                .font(.custom("Press Start 2P Regular", size: 12))
                                .foregroundColor(.black)
                                .onChange(of: filterManager.normal) {
                                    filterManager.resetExcluding(tipo: "normal")
                                    seleccionado = "normal"
                                    withAnimation(.easeInOut.speed(0.4)) {
                                        isShowing = false
                                    }
                                }
                            Toggle("Tierra", isOn: $filterManager.tierra)
                                .font(.custom("Press Start 2P Regular", size: 12))
                                .foregroundColor(.black)
                                .onChange(of: filterManager.tierra) {
                                    filterManager.resetExcluding(tipo: "ground")
                                    seleccionado = "ground"
                                    withAnimation(.easeInOut.speed(0.4)) {
                                        isShowing = false
                                    }
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
