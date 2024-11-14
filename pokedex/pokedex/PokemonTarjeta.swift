//
//  PokemonTarjeta.swift
//  pokedex
//
//  Created by Aula03 on 12/11/24.
//

import SwiftUI

struct PokemonTarjeta: View {
    var nombre:String = "Charizard"
    var tipo:String = "fire"
    var tipoS:String = "flying"
    var numero:String = "0006"
    var imagen:String = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/6.png"
    var body: some View {
        let color:Color = colorPicker(tipo: tipo)
        ZStack(){
            VStack(spacing: 0){
                ParteArriba(tipo: tipo, color: color, numero: numero).frame(height: 500)
                ParteAbajo(nombre: nombre, tipo: tipo, tipoS: tipoS, color: color)
                    .clipShape(
                        .rect(
                            topLeadingRadius: 20,
                            topTrailingRadius: 20
                        )
                    )
                    .offset(CGSize(width: 0, height: -160))
            }.frame(width: .infinity, height: .infinity, alignment: .top)
            AsyncImage(url: URL(string: imagen)){ image in
                image
                    .image?.resizable()
                    .scaledToFit()
            }
            .frame(width: 300, height: 300)
            .offset(CGSize(width: 0, height: -100))
        }
    }
}

#Preview {
    PokemonTarjeta()
}

struct ParteArriba: View {
    var tipo:String
    var color:Color
    var numero:String
    var body: some View {
        ZStack{
            color
            VStack(){
                HStack(){
                    Text("#"+numero).padding(.leading)
                        .font(.custom("Press Start 2P Regular", size: 32))
                        .foregroundColor(.white)
                        .offset(CGSize(width: 0, height: 50))
                    Spacer()
                }
                HStack(){
                    Spacer()
                    ZStack{
                        Circle()
                            .stroke(Color.white, lineWidth: 5)
                            .frame(width: 190, height: 190)
                        Image(tipo)
                            .resizable()
                            .frame(width: 170, height: 170)
                    }
                }.padding(.trailing)
                    .offset(CGSize(width: 0, height: -20))
                Spacer()
            }.frame(height: .infinity, alignment: .top)
        }
    }
}

struct ParteAbajo: View {
    var nombre:String
    var tipo:String
    var tipoS:String
    var color:Color
    var body: some View {
        ZStack{
            Color.white
            VStack(spacing: 0){
                Text(nombre)
                    .font(.custom("Press Start 2P Regular", size: 32))
                HStack(){
                    Spacer()
                    VStack(){
                        ZStack(){
                            Circle()
                                .fill(color)
                                .frame(width: 70, height: 70)
                            Image(tipo)
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
                        Text(espanolizador(tipo: tipo))
                            .font(.custom("Press Start 2P Regular", size: 16))
                    }
                    Spacer()
                    VStack(){
                        ZStack(){
                            Circle()
                                .fill(colorPicker(tipo: tipoS))
                                .frame(width: 70, height: 70)
                            Image(tipoS)
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
                        Text(espanolizador(tipo: tipoS))
                            .font(.custom("Press Start 2P Regular", size: 16))
                    }
                    Spacer()
                }.offset(CGSize(width: 0, height: 80))
            }.frame(width: .infinity, alignment: .top)
        }
    }
}

func colorPicker(tipo: String) -> Color{
    switch tipo {
    case "fire":
        return Color(CGColor(red: 230/250, green: 109/250, blue: 62/250, alpha: 1))
    case "grass":
        return Color(CGColor(red: 102/255, green: 168/255, blue: 69/255, alpha: 1))
    case "water":
        return Color(CGColor(red: 81/255, green: 133/255, blue: 196/255, alpha: 1))
    case "ice":
        return Color(CGColor(red: 108/255, green: 199/255, blue: 235/255, alpha: 1))
    case "ground":
        return Color(CGColor(red: 156/255, green: 119/255, blue: 67/255, alpha: 1))
    case "electric":
        return Color(CGColor(red: 245/255, green: 215/255, blue: 81/255, alpha: 1))
    case "fighting":
        return Color(CGColor(red: 224/255, green: 158/255, blue: 65/255, alpha: 1))
    case "poison":
        return Color(CGColor(red: 116/255, green: 81/255, blue: 153/255, alpha: 1))
    case "flying":
        return Color(CGColor(red: 162/255, green: 196/255, blue: 232/255, alpha: 1))
    case "psychic":
        return Color(CGColor(red: 222/255, green: 106/255, blue: 122/255, alpha: 1))
    case "bug":
        return Color(CGColor(red: 160/255, green: 163/255, blue: 69/255, alpha: 1))
    case "rock":
        return Color(CGColor(red: 191/255, green: 184/255, blue: 138/255, alpha: 1))
    case "ghost":
        return Color(CGColor(red: 104/255, green: 72/255, blue: 112/255, alpha: 1))
    case "dragon":
        return Color(CGColor(red: 82/255, green: 91/255, blue: 168/255, alpha: 1))
    case "dark":
        return Color(CGColor(red: 77/255, green: 74/255, blue: 73/255, alpha: 1))
    case "steel":
        return Color(CGColor(red: 105/255, green: 169/255, blue: 199/255, alpha: 1))
    case "fairy":
        return Color(CGColor(red: 116/255, green: 81/255, blue: 153/255, alpha: 1))
    default:
        return Color(CGColor(red: 217/255, green: 180/255, blue: 211/255, alpha: 1))
    }
}

func espanolizador(tipo:String) -> String {
    switch tipo{
    case "bug":
        return "bicho"
    case "dark":
        return "siniestro"
    case "dragon":
        return "dragon"
    case "electric":
        return "electrico"
    case "fairy":
        return "hada"
    case "fighting":
        return "lucha"
    case "fire":
        return "fuego"
    case "flying":
        return "volador"
    case "ghost":
        return "fantasma"
    case "grass":
        return "planta"
    case "ground":
        return "tierra"
    case "ice":
        return "hielo"
    case "poison":
        return "veneno"
    case "psychic":
        return "psiquico"
    case "rock":
        return "roca"
    case "steel":
        return "metal"
    case "water":
        return "agua"
    default:
        return "normal"
    }
}
