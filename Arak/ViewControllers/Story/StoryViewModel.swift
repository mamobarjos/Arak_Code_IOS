//
//  StoryViewModel.swift
//  Arak
//
//  Created by Abed Qassim on 25/02/2021.
//

import Foundation

class StoryViewModel {

    // MARK: - Properties
    private(set) var adsList:[Adverisment] = []
    private(set) var index: Int = 0
    
    // MARK: - Exposed Methods
    init(adsList:[Adverisment] , index: Int) {
      self.adsList = adsList
      self.index = index
    }
    


    
    

}
