//
//  LocationVCard.swift
//  ASDPal
//
//  Created by Agustin Balquin on 3/5/18.
//  Copyright © 2018 ASDPal. All rights reserved.
//

import Foundation
import CoreLocation

func locationVCardURLFromCoordinate(coordinate: CLLocationCoordinate2D) -> NSURL?
{
    guard let cachesPathString = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
        print("Error: couldn't find the caches directory.")
        return nil
    }
    
    guard CLLocationCoordinate2DIsValid(coordinate) else {
        print("Error: the supplied coordinate, \(coordinate), is not valid.")
        return nil
    }
    
    let vCardString = [
        "BEGIN:VCARD",
        "VERSION:3.0",
        "N:;Shared Location;;;",
        "FN:Shared Location",
        "item1.URL;type=pref:http://maps.apple.com/?ll=\(coordinate.latitude),\(coordinate.longitude)",
        "item1.X-ABLabel:map url",
        "END:VCARD"
        ].joined(separator: "\n")
    
    let vCardFilePath = (cachesPathString as NSString).appendingPathComponent("vCard.loc.vcf")
    
    do {
        try vCardString.write(toFile: vCardFilePath, atomically: true, encoding: String.Encoding.utf8)
    }
    catch let error {
        print("Error, \(error), saving vCard: \(vCardString) to file path: \(vCardFilePath).")
    }
    
    return NSURL(fileURLWithPath: vCardFilePath)
}
