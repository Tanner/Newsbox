//
//  Algorithm.m
//  NewsBox
//
//  Created by Tanner Smith on 2/11/11.
//  Copyright 2011 TS Software. All rights reserved.
//

#import "Algorithm.h"
#import "ItemLoader.h"
#import "ItemSupport.h"
#import "AppDelegate_Shared.h"

#import "API.h"
#import "Parameters.h"
#include <string>

using namespace std;

@implementation Algorithm

+ (void)clusterItems {
    Clustering::Parameters params(Clustering::Jaccard, 0.02);
    params.setTemporaryPath([NSTemporaryDirectory() UTF8String]);
    //params.useMemoryForPairsSort();
    params.setMainIndexInMemory();
    params.setRevertIndexInMemory();
    params.setNumberOfThread(1);
    Clustering::API api(params);
    
    NSLog(@"Adding items to clustering algorithm...");
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    NSFetchRequest *fetchRequest = [[(AppDelegate_Shared *)[[UIApplication sharedApplication] delegate] managedObjectModel] fetchRequestTemplateForName:@"allItems"];
    NSArray *executedRequest = [[(AppDelegate_Shared *)[[UIApplication sharedApplication] delegate] managedObjectContext] executeFetchRequest:fetchRequest error:nil];
    
    if (executedRequest) {
        [items addObjectsFromArray:executedRequest];
    }
    
//    int j = 0;
//    for (MWFeedItem *item in items) {
//        j++;
//        
//        NSString *title = [item title];
//        /*NSMutableArray *titleWords = [NSMutableArray arrayWithArray:[title componentsSeparatedByCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]];
//        
//        title = @"";
//        for (NSString *titleWord in titleWords) {
//            NSCharacterSet *nonAlphaNumeric = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
//            titleWord = [[titleWord componentsSeparatedByCharactersInSet: nonAlphaNumeric] componentsJoinedByString: @""];
//            if (titleWord != nil || ![titleWord isEqualToString:@""]) {
//                [title stringByAppendingString: titleWord];
//            }
//        }*/
//        
//        NSLog(@"Adding \"%@\" - %d / %d -  with %d words", title, j, [items count], [[item splitIntoWords] count]);
//        string name = [title UTF8String];
//        api.addDocument(name);
//        
//        NSArray *words = [item splitIntoWords];
//        
//        int i = 0;
//        for (NSString *word in words) {
//            i++;
//            NSLog(@"Adding word \"%@\" - %d / %d", word, i, [words count]);
//            string wordString = [word UTF8String];
//            api.addDescriptorInCurrentDocument(wordString);
//        }
//    }
//    
//    NSLog(@"Clustering begun...");
//    
//    const Clustering::Results &res = api.startAlgorithm();
//    
//    NSLog(@"Clustering done!");
//    
//    Clustering::DocClusterIterator it = res.begin();
//    Clustering::DocClusterIterator eit = res.end();
//    unsigned clusterCnt = 0;
//    while (it != eit)
//    {
//        NSLog(@"Cluster[%d]", clusterCnt++);
//        
//        // Get Documents of this cluster
//        const std::vector<Clustering::DocId> &documents = it->getDocs();
//        // Get decriptors of this cluster
//        //const std::vector<Clustering::DescId> &descriptors = it->getDescs();
//        
//        unsigned int i = 0;
//        // We must use api to convert DocId and DescId in string
//        // Display documents in cluster
//                
//        for (i = 0; i < documents.size(); ++i) {
//            const char *doc = api.getDocument(documents[i]);
//            NSLog(@"\tDocument[%d]: %@", i + 1, [NSString stringWithUTF8String:doc]);
//        }
//        /*
//        // We can display all descriptors present in this cluster
//        for (i = 0; i < descriptors.size(); ++i) {
//            NSLog(@"\tDescriptor[%d]: Freq[%d]: %@", i+1, descriptors[i].getFrequency(), [NSString stringWithUTF8String:api.getDescriptor(descriptors[i])]);
//        }
//         */
//        // We can also choose to display only the N best descriptors
//        std::vector<Clustering::DescId> bestDescriptors = api.getBestDesc(*it, 2, 0.1);
//        for (i = 0; i < bestDescriptors.size(); ++i) {
//            NSLog(@"\tBest Descriptor[%d] Freq[%d]: %@", i+1, bestDescriptors[i].getFrequency(), [NSString stringWithUTF8String:api.getDescriptor(bestDescriptors[i])]);
//        }
//        ++it;
//    }
}

@end