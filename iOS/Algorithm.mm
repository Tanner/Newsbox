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

static NSArray *stopWords = [[NSArray alloc] initWithObjects:@"a", @"able", @"about", @"above", @"abroad", @"according", @"accordingly", @"across", @"actually", @"adj", @"after", @"afterwards", @"again", @"against", @"ago", @"ahead", @"ain't", @"all", @"allow", @"allows", @"almost", @"alone", @"along", @"alongside", @"already", @"also", @"although", @"always", @"am", @"amid", @"amidst", @"among", @"amongst", @"an", @"and", @"another", @"any", @"anybody", @"anyhow", @"anyone", @"anything", @"anyway", @"anyways", @"anywhere", @"apart", @"appear", @"appreciate", @"appropriate", @"are", @"aren't", @"around", @"as", @"a's", @"aside", @"ask", @"asking", @"associated", @"at", @"available", @"away", @"awfully", @"back", @"backward", @"backwards", @"be", @"became", @"because", @"become", @"becomes", @"becoming", @"been", @"before", @"beforehand", @"begin", @"behind", @"being", @"believe", @"below", @"beside", @"besides", @"best", @"better", @"between", @"beyond", @"both", @"brief", @"but", @"by", @"came", @"can", @"cannot", @"cant", @"can't", @"caption", @"cause", @"causes", @"certain", @"certainly", @"changes", @"clearly", @"c'mon", @"co", @"co.", @"com", @"come", @"comes", @"concerning", @"consequently", @"consider", @"considering", @"contain", @"containing", @"contains", @"corresponding", @"could", @"couldn't", @"course", @"c's", @"currently", @"dare", @"daren't", @"definitely", @"described", @"despite", @"did", @"didn't", @"different", @"directly", @"do", @"does", @"doesn't", @"doing", @"done", @"don't", @"down", @"downwards", @"during", @"each", @"edu", @"eg", @"eight", @"eighty", @"either", @"else", @"elsewhere", @"end", @"ending", @"enough", @"entirely", @"especially", @"et", @"etc", @"even", @"ever", @"evermore", @"every", @"everybody", @"everyone", @"everything", @"everywhere", @"ex", @"exactly", @"example", @"except", @"fairly", @"far", @"farther", @"few", @"fewer", @"fifth", @"first", @"five", @"followed", @"following", @"follows", @"for", @"forever", @"former", @"formerly", @"forth", @"forward", @"found", @"four", @"from", @"further", @"furthermore", @"get", @"gets", @"getting", @"given", @"gives", @"go", @"goes", @"going", @"gone", @"got", @"gotten", @"greetings", @"had", @"hadn't", @"half", @"happens", @"hardly", @"has", @"hasn't", @"have", @"haven't", @"having", @"he", @"he'd", @"he'll", @"hello", @"help", @"hence", @"her", @"here", @"hereafter", @"hereby", @"herein", @"here's", @"hereupon", @"hers", @"herself", @"he's", @"hi", @"him", @"himself", @"his", @"hither", @"hopefully", @"how", @"howbeit", @"however", @"hundred", @"i'd", @"ie", @"if", @"ignored", @"i'll", @"i'm", @"immediate", @"in", @"inasmuch", @"inc", @"inc.", @"indeed", @"indicate", @"indicated", @"indicates", @"inner", @"inside", @"insofar", @"instead", @"into", @"inward", @"is", @"isn't", @"it", @"it'd", @"it'll", @"its", @"it's", @"itself", @"i've", @"just", @"k", @"keep", @"keeps", @"kept", @"know", @"known", @"knows", @"last", @"lately", @"later", @"latter", @"latterly", @"least", @"less", @"lest", @"let", @"let's", @"like", @"liked", @"likely", @"likewise", @"little", @"look", @"looking", @"looks", @"low", @"lower", @"ltd", @"made", @"mainly", @"make", @"makes", @"many", @"may", @"maybe", @"mayn't", @"me", @"mean", @"meantime", @"meanwhile", @"merely", @"might", @"mightn't", @"mine", @"minus", @"miss", @"more", @"moreover", @"most", @"mostly", @"mr", @"mrs", @"much", @"must", @"mustn't", @"my", @"myself", @"name", @"namely", @"nd", @"near", @"nearly", @"necessary", @"need", @"needn't", @"needs", @"neither", @"never", @"neverf", @"neverless", @"nevertheless", @"new", @"next", @"nine", @"ninety", @"no", @"nobody", @"non", @"none", @"nonetheless", @"noone", @"no-one", @"nor", @"normally", @"not", @"nothing", @"notwithstanding", @"novel", @"now", @"nowhere", @"obviously", @"of", @"off", @"often", @"oh", @"ok", @"okay", @"old", @"on", @"once", @"one", @"ones", @"one's", @"only", @"onto", @"opposite", @"or", @"other", @"others", @"otherwise", @"ought", @"oughtn't", @"our", @"ours", @"ourselves", @"out", @"outside", @"over", @"overall", @"own", @"particular", @"particularly", @"past", @"per", @"perhaps", @"placed", @"please", @"plus", @"possible", @"presumably", @"probably", @"provided", @"provides", @"que", @"quite", @"qv", @"rather", @"rd", @"re", @"really", @"reasonably", @"recent", @"recently", @"regarding", @"regardless", @"regards", @"relatively", @"respectively", @"right", @"round", @"said", @"same", @"saw", @"say", @"saying", @"says", @"second", @"secondly", @"see", @"seeing", @"seem", @"seemed", @"seeming", @"seems", @"seen", @"self", @"selves", @"sensible", @"sent", @"serious", @"seriously", @"seven", @"several", @"shall", @"shan't", @"she", @"she'd", @"she'll", @"she's", @"should", @"shouldn't", @"since", @"six", @"so", @"some", @"somebody", @"someday", @"somehow", @"someone", @"something", @"sometime", @"sometimes", @"somewhat", @"somewhere", @"soon", @"sorry", @"specified", @"specify", @"specifying", @"still", @"sub", @"such", @"sup", @"sure", @"take", @"taken", @"taking", @"tell", @"tends", @"th", @"than", @"thank", @"thanks", @"thanx", @"that", @"that'll", @"thats", @"that's", @"that've", @"the", @"their", @"theirs", @"them", @"themselves", @"then", @"thence", @"there", @"thereafter", @"thereby", @"there'd", @"therefore", @"therein", @"there'll", @"there're", @"theres", @"there's", @"thereupon", @"there've", @"these", @"they", @"they'd", @"they'll", @"they're", @"they've", @"thing", @"things", @"think", @"third", @"thirty", @"this", @"thorough", @"thoroughly", @"those", @"though", @"three", @"through", @"throughout", @"thru", @"thus", @"till", @"to", @"together", @"too", @"took", @"toward", @"towards", @"tried", @"tries", @"truly", @"try", @"trying", @"t's", @"twice", @"two", @"un", @"under", @"underneath", @"undoing", @"unfortunately", @"unless", @"unlike", @"unlikely", @"until", @"unto", @"up", @"upon", @"upwards", @"us", @"use", @"used", @"useful", @"uses", @"using", @"usually", @"v", @"value", @"various", @"versus", @"very", @"via", @"viz", @"vs", @"want", @"wants", @"was", @"wasn't", @"way", @"we", @"we'd", @"welcome", @"well", @"we'll", @"went", @"were", @"we're", @"weren't", @"we've", @"what", @"whatever", @"what'll", @"what's", @"what've", @"when", @"whence", @"whenever", @"where", @"whereafter", @"whereas", @"whereby", @"wherein", @"where's", @"whereupon", @"wherever", @"whether", @"which", @"whichever", @"while", @"whilst", @"whither", @"who", @"who'd", @"whoever", @"whole", @"who'll", @"whom", @"whomever", @"who's", @"whose", @"why", @"will", @"willing", @"wish", @"with", @"within", @"without", @"wonder", @"won't", @"would", @"wouldn't", @"yes", @"yet", @"you", @"you'd", @"you'll", @"your", @"you're", @"yours", @"yourself", @"yourselves", @"you've", @"zero", nil];

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
    
    int articleIterator = 0;
    for (Item *item in items) {
        articleIterator++;
        
        NSString *title = [item title];
        /*NSMutableArray *titleWords = [NSMutableArray arrayWithArray:[title componentsSeparatedByCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]];
        
        title = @"";
        for (NSString *titleWord in titleWords) {
            NSCharacterSet *nonAlphaNumeric = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
            titleWord = [[titleWord componentsSeparatedByCharactersInSet: nonAlphaNumeric] componentsJoinedByString: @""];
            if (titleWord != nil || ![titleWord isEqualToString:@""]) {
                [title stringByAppendingString: titleWord];
            }
        }*/
        
        NSArray *words = [self splitStringIntoWords:item.content];
        
        NSLog(@"Adding \"%@\" - %d / %d -  with %d words", title, articleIterator, [items count], [words count]);
        string name = [title UTF8String];
        api.addDocument(name);
        
        int articleWordIterator = 0;
        for (NSString *word in words) {
            articleWordIterator++;
            NSLog(@"Adding word \"%@\" - %d / %d", word, articleWordIterator, [words count]);
            string wordString = [word UTF8String];
            api.addDescriptorInCurrentDocument(wordString);
        }
    }
    
    NSLog(@"Clustering begun...");
    
    const Clustering::Results &res = api.startAlgorithm();
    
    NSLog(@"Clustering done!");
    
    Clustering::DocClusterIterator it = res.begin();
    Clustering::DocClusterIterator eit = res.end();
    unsigned clusterCnt = 0;
    while (it != eit)
    {
        NSLog(@"Cluster[%d]", clusterCnt++);
        
        // Get Documents of this cluster
        const std::vector<Clustering::DocId> &documents = it->getDocs();
        // Get decriptors of this cluster
        //const std::vector<Clustering::DescId> &descriptors = it->getDescs();
        
        unsigned int i = 0;
        // We must use api to convert DocId and DescId in string
        // Display documents in cluster
                
        for (i = 0; i < documents.size(); ++i) {
            const char *doc = api.getDocument(documents[i]);
            NSLog(@"\tDocument[%d]: %@", i + 1, [NSString stringWithUTF8String:doc]);
        }
        /*
        // We can display all descriptors present in this cluster
        for (i = 0; i < descriptors.size(); ++i) {
            NSLog(@"\tDescriptor[%d]: Freq[%d]: %@", i+1, descriptors[i].getFrequency(), [NSString stringWithUTF8String:api.getDescriptor(descriptors[i])]);
        }
         */
        // We can also choose to display only the N best descriptors
        std::vector<Clustering::DescId> bestDescriptors = api.getBestDesc(*it, 2, 0.1);
        for (i = 0; i < bestDescriptors.size(); ++i) {
            NSLog(@"\tBest Descriptor[%d] Freq[%d]: %@", i+1, bestDescriptors[i].getFrequency(), [NSString stringWithUTF8String:api.getDescriptor(bestDescriptors[i])]);
        }
        ++it;
    }
}

+ (NSArray *)splitStringIntoWords:(NSString *)string {
    NSMutableArray *words = [NSMutableArray arrayWithArray:[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    
    for (int i = 0; i < [words count]; i++) {
        NSString *word = [words objectAtIndex:i];
        
        if ([word isEqualToString:@""] || word == nil || [Algorithm isStopWord: word]) {
            [words removeObjectAtIndex:i];
            i--;
        } else {
            NSString *newWord = [word stringByTrimmingCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]];
            if ([newWord isEqualToString:@""] || newWord == nil) {
                [words removeObjectAtIndex:i];
                i--;
            } else if (![word isEqualToString:newWord]) {
                [words replaceObjectAtIndex:i withObject:newWord];
            }
        }
    }
    
    return words;
}

+ (BOOL)isStopWord:(NSString *)aString {
    for (NSString *stopWord in stopWords) {
        if ([aString caseInsensitiveCompare:stopWord] == NSOrderedSame) {
            return YES;
        }
    }
    
    return NO;
}

@end