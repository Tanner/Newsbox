//
//  GitHubRepositoryFactory.m
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/19/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import "GitHubRepositoryFactory.h"

@implementation GitHubRepositoryFactory

#pragma mark -
#pragma mark Internal implementation declaration

static NSDictionary *localEndElement;

static NSDictionary *localStartElement;

static BOOL localHidePrivateRepositories = NO;

#pragma mark -
#pragma mark Memory and member management

//Retain
@synthesize repository;

//Assign
@synthesize networkElement;

-(void)cleanUp {
  
  self.repository = nil;
  [super cleanUp];
}

-(void)dealloc {
  
  [self cleanUp];
  [super dealloc];
}

-(NSDictionary *)startElement {
  
  return localStartElement;
}

-(NSDictionary *)endElement {
  
  return localEndElement;
}

#pragma mark -
#pragma mark Internal implementation declaration

-(void)startElementRepository {
  
  self.repository = [GitHubRepositoryImp repository];
}

-(void)startElementNetwork:(NSString *)elementName
                attributes:(NSDictionary *)attributeDict {
  
  if (![attributeDict count]) {
    
    self.networkElement++;
    self.repository = [GitHubRepositoryImp repository];
  }
}

-(void)endElementRepository {
  if (!(localHidePrivateRepositories && self.repository.private)) {
    
    [(id<GitHubServiceGotRepositoryDelegate>)self.delegate
     gitHubService:self
     gotRepository:self.repository];
  }
}

-(void)endElementNetwork {
  
  if (self.networkElement) {
    
    [(id<GitHubServiceGotRepositoryDelegate>)self.delegate
     gitHubService:self
     gotRepository:self.repository];
    
    self.networkElement--;
  }
}

-(void)endElementHomepage {
  
  self.repository.homepage = [self createURLFromString:self.currentStringValue];
}

-(void)endElementHasIssues {
  
   self.repository.hasIssues = [self.currentStringValue boolValue];
}

-(void)endElementCreatedAt {
      
    self.repository.creationDate =
    [self createDateFromString:self.currentStringValue];
}

-(void)endElementPushedAt {
    
    self.repository.pushDate = 
    [self createDateFromString:self.currentStringValue];
}

-(void)endElementWatchers {
  
  self.repository.watchers  = [self.currentStringValue intValue];
}

-(void)endElementForks {
  
  self.repository.forks = [self.currentStringValue intValue];
}

-(void)endElementFork {
  
  self.repository.fork = [self.currentStringValue boolValue];
}

-(void)endElementHasDownloads {
  
  self.repository.hasDownloads = [self.currentStringValue boolValue];
}

-(void)endElementDescription {
  
  self.repository.desc = self.currentStringValue;  
}

-(void)endElementPrivate {
  
  self.repository.private = [self.currentStringValue boolValue];
}

-(void)endElementHasWiki {
  
  self.repository.hasWiki = [self.currentStringValue boolValue];
}

-(void)endElementName {
  
  self.repository.name = self.currentStringValue;
}

-(void)endElementOwner {
  
  self.repository.owner = self.currentStringValue;
}

-(void)endElementUrl {
  
  self.repository.url = [self createURLFromString:self.currentStringValue];
}

-(void)endElementOpenIssues {
  
  self.repository.openIssues = [self.currentStringValue intValue];
}

#pragma mark -
#pragma mark Super override implementation

+(void)initialize {
  
  localStartElement =
  [[NSDictionary dictionaryWithObjectsAndKeys:
    [NSValue valueWithPointer:@selector
     (startElementRepository)], @"repository",
    [NSValue valueWithPointer:@selector
     (startElementNetwork:attributes:)], @"network",
    nil] retain];
  
  localEndElement =
  [[NSDictionary dictionaryWithObjectsAndKeys:
    [NSValue valueWithPointer:@selector
     (endElementRepository)], @"repository",
    [NSValue valueWithPointer:@selector
     (endElementNetwork)], @"network",
    [NSValue valueWithPointer:@selector
     (endElementHomepage)], @"homepage",
    [NSValue valueWithPointer:@selector
     (endElementHasIssues)], @"has-issues",
    [NSValue valueWithPointer:@selector
     (endElementCreatedAt)], @"created-at",
    [NSValue valueWithPointer:@selector
     (endElementPushedAt)], @"pushed-at",
    [NSValue valueWithPointer:@selector
     (endElementWatchers)], @"watchers",
    [NSValue valueWithPointer:@selector
     (endElementWatchers)], @"watcher-count",
    [NSValue valueWithPointer:@selector
     (endElementForks)], @"forks",
    [NSValue valueWithPointer:@selector
     (endElementFork)], @"fork",
    [NSValue valueWithPointer:@selector
     (endElementHasDownloads)], @"has-downloads",
    [NSValue valueWithPointer:@selector
     (endElementDescription)], @"description",
    [NSValue valueWithPointer:@selector
     (endElementPrivate)], @"private",
    [NSValue valueWithPointer:@selector
     (endElementHasWiki)], @"has-wiki",
    [NSValue valueWithPointer:@selector
     (endElementName)], @"name",
    [NSValue valueWithPointer:@selector
     (endElementOwner)], @"owner",
    [NSValue valueWithPointer:@selector
     (endElementOwner)], @"username",
    [NSValue valueWithPointer:@selector
     (endElementUrl)], @"url",
    [NSValue valueWithPointer:@selector
     (endElementOpenIssues)], @"open-issues",
    [NSValue valueWithPointer:@selector
     (endElementError)], @"error",
    nil] retain];
}

#pragma mark -
#pragma mark Interface implementation
#pragma mark - Class

+(GitHubRepositoryFactory *)repositoryFactoryWithDelegate:
(id<GitHubServiceGotRepositoryDelegate>)delegate {
  
  return [[[GitHubRepositoryFactory alloc]
           initWithDelegate:delegate] autorelease]; 
}

+(void)hidePrivateRepositories:(BOOL)hidePrivateRepositories {
  
  localHidePrivateRepositories = hidePrivateRepositories;
}

#pragma mark - Instance

-(void)searchRepositoriesByName:(NSString *)name {
  
  [self makeRequest:[NSString
                     stringWithFormat:@"/api/v2/xml/repos/search/%@", name]];
}

-(void)requestRepositoriesInNetworkByName:(NSString *)name
                                     user:(NSString *)user {
  
  [self makeRequest:[NSString
                     stringWithFormat:@"/api/v2/xml/repos/show/%@/%@/network",
                     user ,name]];
}

-(void)requestRepositoryByName:(NSString *)name
                          user:(NSString *)user {
  
  [self makeRequest:[NSString
                     stringWithFormat:@"/api/v2/xml/repos/show/%@/%@",
                     user, name]];
}

-(void)requestRepositoriesWatchedByUser:(NSString *)name {
  
  [self makeRequest:[NSString
                     stringWithFormat:@"/api/v2/xml/repos/watched/%@", name]];
}

-(void)requestRepositoriesOwnedByUser:(NSString *)name {
  
  [self makeRequest:[NSString stringWithFormat:@"/api/v2/xml/repos/show/%@",
                     name]];
}

@end
