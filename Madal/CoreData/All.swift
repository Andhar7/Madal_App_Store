//
//  All.swift
//  Madal
//
//  Created by Solver on 14.04.2022.
//

import Foundation
import CoreData

public class All : NSManagedObject {
    
}


extension All {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<All> {
         
        return NSFetchRequest<All>(entityName: "Oneness")
    }
    
    @NSManaged public var id : String
    @NSManaged public var url : String
    @NSManaged public var image : String
    
}

extension All : Identifiable {
    
}
