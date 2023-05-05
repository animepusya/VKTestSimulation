//
//  ContentView.swift
//  VKTest
//
//  Created by Руслан Меланин on 05.05.2023.
//

import SwiftUI

struct ContentView: View {
    @State var isInfected: [Bool] = Array(repeating: false, count: 49)
    
    let infectionProbability = 20
    
    func infectNeighbors(index: Int) {
        let row = index / 7
        let col = index % 7
        var neighborIndices: [Int] = []
        
        if row > 0 { neighborIndices.append(index - 7) }
        if row < 6 { neighborIndices.append(index + 7) }
        if col > 0 { neighborIndices.append(index - 1) }
        if col < 6 { neighborIndices.append(index + 1) }
        
        for neighborIndex in neighborIndices {
            if !isInfected[neighborIndex] && Int.random(in: 0...35) <= infectionProbability {
                isInfected[neighborIndex] = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.infectNeighbors(index: neighborIndex)
                }
            }
        }
    }

    var body: some View {
        VStack {
            
            ForEach(0..<7) { row in
                HStack {
                    ForEach(0..<7) { column in
                        let index = row*7+column
                        Circle()
                            .foregroundColor(isInfected[index] ? .red : .gray)
                            .frame(width: 40, height: 40)
                            .onTapGesture {
                                if !isInfected[index] {
                                    isInfected[index] = true
                                    infectNeighbors(index: index)
                                }
                            }
                    }
                }
            }
            
            Button("Reset") {
                isInfected = Array(repeating: false, count: 49)
            }
            .padding(.top, 50)
            .foregroundColor(.black)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
