//
//  ContentView.swift
//  VKTest
//
//  Created by Руслан Меланин on 05.05.2023.
//

import SwiftUI

struct ContentView: View {
    
    @State var isInfected: [Bool] = Array(repeating: false, count: 100)
    @State var infectedCount = 0
    let infectionProbability = 20
    var workItem: DispatchWorkItem?
    
    var body: some View {
        VStack {
            
            Text("Corova Virus Online")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Spacer()
            
            Text("Заражённых людей: \(infectedCount)")
                .padding(.bottom, 40)
            
            ForEach(0..<10) { row in
                HStack {
                    ForEach(0..<10) { column in
                        let index = row*7+column
                        Image(systemName: isInfected[index] ? "person.crop.circle.badge.exclamationmark" : "person.crop.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(isInfected[index] ? .red : .gray)
                            .frame(width: 20, height: 20)
                            .onTapGesture {
                                if !isInfected[index] {
                                    isInfected[index] = true
                                    infectedCount += 1
                                    infectNeighbors(index: index, isInfected: $isInfected)
                                }
                            }
                    }
                }
            }
            
            Spacer(minLength: 80)
            
            Button {
                isInfected = Array(repeating: false, count: 100)
                workItem?.cancel()
                infectedCount = 0
            } label: {
                ZStack {
                    Rectangle()
                        .foregroundColor(.white)
                        .cornerRadius(30)
                        .shadow(radius: 4, x: -3, y: 2)
                        .frame(width: 100, height: 50)
                    
                    Text("Reset")
                        .foregroundColor(.black)
                }
            }
            
            Spacer()
            
        }
        .padding()
    }
    
    func infectNeighbors(index: Int, isInfected: Binding<[Bool]>) {
        let row = index / 7
        let col = index % 7
        var neighborIndices: [Int] = []
        
        if row > 0 { neighborIndices.append(index - 7) }
        if row < 6 { neighborIndices.append(index + 7) }
        if col > 0 { neighborIndices.append(index - 1) }
        if col < 6 { neighborIndices.append(index + 1) }
        
        for neighborIndex in neighborIndices {
            if !isInfected.wrappedValue[neighborIndex] && Int.random(in: 0...35) <= infectionProbability {
                isInfected.wrappedValue[neighborIndex] = true
                infectedCount += 1
                let workItem = DispatchWorkItem {
                    infectNeighbors(index: neighborIndex, isInfected: isInfected)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: workItem)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
