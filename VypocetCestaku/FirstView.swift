//
//  FirstView.swift
//  VypocetCestaku
//
//  Created by Jan Kubín on 17.05.2023.
//
import SwiftUI

struct FirstView: View {
    @StateObject private var viewModel = FirstViewModel()
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea()
            ScrollView{
                VStack {
                    
                    Text("Výpočet cesťáku")
                        .font(.title)
                        .fontWeight(.black)
                    
                    TextField("Start", text: $viewModel.startLocation)
                        .font(.title2)
                        .padding()
                    
                    TextField("Cíl", text: $viewModel.endLocation)
                        .font(.title2)
                        .padding()
                    
                    TextField("Spotřeba (l/100km)", text: $viewModel.spotreba)
                        .font(.title2)
                        .padding()
                    
                    TextField("Cena pohonné hmoty (Kč/l)", text: $viewModel.cenaPohonneHmoty)
                        .font(.title2)
                        .padding()
                    
                    TextField("Amortizace (Kč/km)", text: $viewModel.amortizace)
                        .font(.title2)
                        .padding()
                    
                    Toggle(isOn: $viewModel.isRoundTrip) {
                        Text("Cesta tam a zpět")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    .padding()
                    
                    Text("Vzdálenost: \(String(format: "%.2f", viewModel.distance)) km")
                        .font(.title)
                        .padding()
                        .foregroundColor(Color.primary)
                        .fontWeight(.bold)
                    
                    Text("Celková cena: \(String(format: "%.2f", viewModel.celkovaCena)) Kč")
                        .font(.title)
                        .padding()
                        .foregroundColor(Color.primary)
                        .fontWeight(.bold)
                    
                    Button("Vypočítat") {
                        viewModel.calculate()
                    }
                    .font(.title)
                    .frame(width: 300, height: 20)
                    .padding(20)
                    .foregroundColor(Color.white)
                    .background(Color.black)
                    .cornerRadius(10)
                    
                    Button(action: {
                        viewModel.navigateToDestination()
                    }) {
                        Text("Navigovat")
                            .font(.title)
                            .frame(width: 300)
                            .padding(20)
                            .foregroundColor(Color.white)
                            .background(Color.black)
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
}



struct FirstView_Previews: PreviewProvider {
    static var previews: some View {
        FirstView()
    }
}

