//
//  PokemonTarjeta.swift
//  pokedex
//
//  Created by Aula03 on 12/11/24.
//

import SwiftUI

struct PokemonTarjeta2: View {
    /*var nombre:String = "Charizard"
    var tipo:String = "fire"
    var tipoS:String = "flying"
    var numero:String = "0006"
    var imagen:String = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/6.png"*/
    var pokemon:Pokemon
    var body: some View {
        let color:Color = colorPicker(tipo: pokemon.types[0].type.name)
        ZStack(){
            VStack(spacing: 0){
                ParteArriba2(tipo: pokemon.types[0].type.name, color: color, numero: String(pokemon.id))
                    .clipShape(
                        .rect(
                            topLeadingRadius: 20,
                            topTrailingRadius: 20
                        )
                    )
                ParteAbajo2(nombre: pokemon.name, /*tipo: tipo, tipoS: tipoS,*/ tipos: pokemon.types, color: color)
                    .clipShape(
                        .rect(
                            topLeadingRadius: 20,
                            bottomLeadingRadius: 20,
                            bottomTrailingRadius: 20,
                            topTrailingRadius: 20
                        )
                    )
                    .offset(CGSize(width: 0, height: -17))
                Spacer()
            }
            .shadow(radius: 10)
            AsyncImage(url: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(pokemon.id).png")){ image in
                image
                    .image?.resizable()
                    .scaledToFit()
            }
            .frame(width: 150, height: 150)
            .offset(CGSize(width: 0, height: -50))
        }.frame(width: 200, height: 300)
    }
}

/*#Preview {
    PokemonTarjeta2()
}*/

struct ParteArriba2: View {
    var tipo:String
    var color:Color
    var numero:String
    var body: some View {
        ZStack{
            color
            VStack(){
                HStack(){
                    Text("#"+numero).padding(.leading)
                        .font(.custom("Press Start 2P Regular", size: 16))
                        .foregroundColor(.white)
                        .offset(CGSize(width: -10, height: 10))
                    Spacer()
                }
                HStack(){
                    Spacer()
                    ZStack{
                        Circle()
                            .stroke(Color.white, lineWidth: 3)
                            .frame(width: 70, height: 70)
                        Image(tipo)
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                }.padding(.trailing)
                    .offset(CGSize(width: 10, height: -10))
                Spacer()
            }//.frame(width: 200, height: 150, alignment: .top)
        }.frame(width: 200, height: 150, alignment: .top)
    }
}

struct ParteAbajo2: View {
    var nombre:String
    /*var tipo:String
    var tipoS:String*/
    var tipos:[Pokemon.Types]
    var color:Color
    var body: some View {
        ZStack{
            Color.white
            VStack(spacing: 0){
                Text(nombre)
                    .font(.custom("Press Start 2P Regular", size: 13))
                    .offset(CGSize(width: 0, height: 40))
                Spacer()
                HStack(){
                    Spacer()
                    VStack(){
                        ZStack(){
                            Circle()
                                .fill(color)
                                .frame(width: 50, height: 50)
                            Image(tipos[0].type.name)
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                        Text(espanolizador(tipo: tipos[0].type.name))
                            .font(.custom("Press Start 2P Regular", size: 11))
                    }
                    Spacer()
                    if tipos.count > 1 {
                        VStack(){
                            ZStack(){
                                Circle()
                                    .fill(colorPicker(tipo: tipos[1].type.name))
                                    .frame(width: 50, height: 50)
                                Image(tipos[1].type.name)
                                    .resizable()
                                    .frame(width: 30, height: 30)
                            }
                            Text(espanolizador(tipo: tipos[1].type.name))
                                .font(.custom("Press Start 2P Regular", size: 11))
                        }
                        Spacer()
                    }
                }.offset(CGSize(width: 0, height: 20))
                Spacer()
            }//.frame(width: 200, height: .infinity, alignment: .top)
        }.frame(width: 200, height: 150, alignment: .top)
    }
}
