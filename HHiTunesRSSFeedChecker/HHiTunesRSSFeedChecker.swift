//
//  HHiTunesRSSFeedChecker.swift
//  HHiTunesRSSFeedChecker
//
//  Created by Donald Angelillo on 8/24/17.
//  Copyright © 2017 Donald Angelillo. All rights reserved.
//

import Foundation
import Alamofire

enum HHiTunesRSSFeedCheckerFeedType: String {
    case newReleases = "new-music-heavy-metal"
    case recentReleases = "recent-releases-heavy-metal"
    case hotTracks = "hot-tracks-heavy-metal"
}

struct HHiTunesRSSFeedChecker {
    func findElegibleStoreFrontsForNewItunesFeeds(simultaneously: Bool, completion: @escaping (_ results: [String: [String]]) -> ()) {
        if (simultaneously) {
            self.runSimultaneously(completion: completion)
        } else {
            self.runInBatches(completion: completion)
        }
    }
    
    private func runInBatches(completion: @escaping (_ results: [String: [String]]) -> ()) {
        let feedTypes: [HHiTunesRSSFeedCheckerFeedType] = [.newReleases, .recentReleases, .hotTracks]
        
        var results: [String: [String]] = Dictionary()
        
        self.checkStoreFrontsFor(feedType: feedTypes[0]) { (feedType, eligibleCountryCodes) in
            results[feedType.rawValue] = eligibleCountryCodes
            
            self.checkStoreFrontsFor(feedType: feedTypes[1]) { (feedType, eligibleCountryCodes) in
                results[feedType.rawValue] = eligibleCountryCodes
                
                self.checkStoreFrontsFor(feedType: feedTypes[2]) { (feedType, eligibleCountryCodes) in
                    results[feedType.rawValue] = eligibleCountryCodes
                    
                    completion(results)
                }
            }
        }
    }
    
    private func runSimultaneously(completion: @escaping (_ results: [String: [String]]) -> ()) {
        let feedTypes: [HHiTunesRSSFeedCheckerFeedType] = [.newReleases, .recentReleases, .hotTracks]
        var totalComplete = 0
        
        var results: [String: [String]] = Dictionary()
        
        for feedType in feedTypes {
            self.checkStoreFrontsFor(feedType: feedType, completion: { (feedType, eligibleCountryCodes) in
                results[feedType.rawValue] = eligibleCountryCodes
                
                totalComplete+=1
                
                if (totalComplete == feedTypes.count) {
                    completion(results)
                }
            })
        }
    }
    
    private func checkStoreFrontsFor(feedType: HHiTunesRSSFeedCheckerFeedType, completion: @escaping (_ feedType: HHiTunesRSSFeedCheckerFeedType, _ eligibleCountryCodes: [String]) -> ()) {
        var eligibleCountryCodes: [String] = Array()
        var totalComplete = 0
        
        let countryCodes = self.getAllCountryCodes(lowercase: true)
        
        for countryCode in countryCodes {
            if let url = URL(string: String(format: "https://rss.itunes.apple.com/api/v1/%@/itunes-music/%@/10/explicit.json", countryCode, feedType.rawValue)) {
                Alamofire.request(url).validate().responseJSON(completionHandler: { (response) in
                    if (response.result.isFailure) {
                        totalComplete+=1
                        
                        print(totalComplete, "of", countryCodes.count, "for", feedType.rawValue, "FAILURE for", countryCode, "ERROR:", response.error!.localizedDescription)

                        if (totalComplete == countryCodes.count) {
                            completion(feedType, eligibleCountryCodes.sorted())
                        }
                    } else {
                    
                        if let json = response.result.value as? [String: Any], let feed = json["feed"] as? [String: Any], let _ = feed["results"] as? [[String: Any]] {
                            
                            eligibleCountryCodes.append(countryCode)
                            totalComplete+=1
                            
                            print(totalComplete, "of", countryCodes.count, "for", feedType.rawValue, "SUCCESS for", countryCode)
                            
                            if (totalComplete == countryCodes.count) {
                                completion(feedType, eligibleCountryCodes.sorted())
                            }
                        } else {
                            totalComplete+=1
                            
                            print(totalComplete, "of", countryCodes.count, "for", feedType.rawValue, "FEED NOT AVAILABLE for", countryCode)
                            
                            if (totalComplete == countryCodes.count) {
                                completion(feedType, eligibleCountryCodes.sorted())
                            }
                        }
                    }
                })
            }
        }
    }
    
    private func getAllCountryCodes(lowercase: Bool) -> [String] {
        var countryCodes: [String] = Array()
        
        for country in HHiTunesStorefrontFinder.countryData {
            if let countryCode = country["countryCode"] {
                if (lowercase) {
                    countryCodes.append(countryCode.lowercased())
                } else {
                    countryCodes.append(countryCode)
                }
            }
        }
        
        return countryCodes
    }
    
    private func printResults(results: [String: [String]]) {
        
    }
}
