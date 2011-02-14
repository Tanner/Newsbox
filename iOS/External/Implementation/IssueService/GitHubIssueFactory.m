//
//  GitHubIssueFactory.m
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/30/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import "GitHubIssueFactory.h"

@implementation GitHubIssueFactory

#pragma mark -
#pragma mark Internal implementation declaration

static NSDictionary *localEndElement;

static NSDictionary *localStartElement;

#pragma mark -
#pragma mark Memory and member management

//Retain
@synthesize issue, labels;

//Assign
@synthesize inLabel;

-(void)cleanUp {
  
  self.issue = nil;
  self.labels = nil;
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

-(void)startElementIssue {
  
  self.issue = [GitHubIssueImp issue];
}

-(void)startElementLabels {
  
  self.labels = [NSMutableArray arrayWithCapacity:5];
}

-(void)startElementLabel {
  
  self.inLabel = YES;
}

-(void)endElementIssue {
  
  [(id<GitHubServiceGotIssueDelegate>)self.delegate
   gitHubService:self
   gotIssue:self.issue];
}

-(void)endElementGravatarId {
  
  self.issue.gravatar = self.currentStringValue;
} 

-(void)endElementPosition {
  
  self.issue.position = [self.currentStringValue floatValue];
} 

-(void)endElementNumber {
  
  self.issue.number = [self.currentStringValue intValue];
} 

-(void)endElementVotes {
  
  self.issue.votes = [self.currentStringValue intValue];
} 

-(void)endElementCreatedAt {
  
  self.issue.created =
  [self createDateFromString:self.currentStringValue];
 } 

-(void)endElementComments {
  
  self.issue.comments = [self.currentStringValue intValue];
} 

-(void)endElementBody {
  
  self.issue.body = self.currentStringValue;
} 

-(void)endElementTitle {
  
  self.issue.title = self.currentStringValue;
} 

-(void)endElementUpdatedAt {
    
  self.issue.updated =
  [self createDateFromString:self.currentStringValue];
} 

-(void)endElementClosedAt {
  
  self.issue.updated =
  [self createDateFromString:self.currentStringValue];
} 

-(void)endElementUser {
  
  self.issue.user = self.currentStringValue;
} 

-(void)endElementLabels {
  
  self.issue.labels = [NSArray arrayWithArray:self.labels];
  self.labels = nil;
} 

-(void)endElementLabel {
  
  self.inLabel = NO;
} 

-(void)endElementName {
  
  if (self.inLabel) {
    
    [self.labels addObject:self.currentStringValue];
  }  
} 

#pragma mark -
#pragma mark Super override implementation

+(void)initialize {
  
  localStartElement =
  [[NSDictionary dictionaryWithObjectsAndKeys:
    [NSValue valueWithPointer:@selector
     (startElementIssue)], @"issue",
    [NSValue valueWithPointer:@selector
     (startElementLabels)], @"labels",
    [NSValue valueWithPointer:@selector
     (startElementLabel)], @"label",
    nil] retain];
  
  localEndElement =
  [[NSDictionary dictionaryWithObjectsAndKeys:
    [NSValue valueWithPointer:@selector
     (endElementIssue)], @"issue",
    [NSValue valueWithPointer:@selector
     (endElementGravatarId)], @"gravatar-id",
    [NSValue valueWithPointer:@selector
     (endElementPosition)], @"position",
    [NSValue valueWithPointer:@selector
     (endElementNumber)], @"number",
    [NSValue valueWithPointer:@selector
     (endElementVotes)], @"votes",
    [NSValue valueWithPointer:@selector
     (endElementCreatedAt)], @"created-at",
    [NSValue valueWithPointer:@selector
     (endElementComments)], @"comments",
    [NSValue valueWithPointer:@selector
     (endElementBody)], @"body",
    [NSValue valueWithPointer:@selector
     (endElementTitle)], @"title",
    [NSValue valueWithPointer:@selector
     (endElementUpdatedAt)], @"updated-at",
    [NSValue valueWithPointer:@selector
     (endElementClosedAt)], @"closed-at",
    [NSValue valueWithPointer:@selector
     (endElementUser)], @"user",
    [NSValue valueWithPointer:@selector
     (endElementLabels)], @"labels",
    [NSValue valueWithPointer:@selector
     (endElementLabel)], @"label",
    [NSValue valueWithPointer:@selector
     (endElementName)], @"name",
    [NSValue valueWithPointer:@selector
     (endElementError)], @"body",
    nil] retain];
}

#pragma mark -
#pragma mark Interface implementation
#pragma mark - Class

+(GitHubIssueFactory *)issueFactoryWithDelegate:
(id<GitHubServiceGotIssueDelegate>)delegate {

    return [[[GitHubIssueFactory alloc] initWithDelegate:delegate] autorelease];
}

#pragma mark - Instance

-(void)searchIssuesForTerm:(NSString *)term
                     state:(GitHubIssueState)state
                      user:(NSString *)user
                repository:(NSString *)repository {

  NSString *stateStr;
  
  if (state == GitHubIssueOpen) {
    
    stateStr = @"open";
    
  } else {
    
    stateStr = @"closed";  
  }
  [self makeRequest:[NSString
                     stringWithFormat:
                     @"%@/api/v2/xml/issues/search/%@/%@/%@/%@",
                     [GitHubBaseFactory serverAddress],
                     user, repository, stateStr, term]];
}

-(void)requestIssuesForState:(GitHubIssueState)state
                        user:(NSString *)user
                  repository:(NSString *)repository {
  
  NSString *stateStr;
  
  if (state == GitHubIssueOpen) {
    
    stateStr = @"open";
    
  } else {
    
    stateStr = @"closed";  
  }
  
  [self makeRequest:[NSString
                     stringWithFormat:
                     @"/api/v2/xml/issues/list/%@/%@/%@",
                     user, repository, stateStr]];
}

-(void)requestIssuesForLabel:(NSString *)label
                        user:(NSString *)user
                  repository:(NSString *)repository {
  
  [self makeRequest:[NSString
                     stringWithFormat:
                     @"/api/v2/xml/issues/list/%@/%@/label/%@",
                     user, repository, label]];
}

-(void)requestIssueForNumber:(NSUInteger)number
                        user:(NSString *)user
                  repository:(NSString *)repository {

  [self makeRequest:[NSString
                     stringWithFormat:
                     @"/api/v2/xml/issues/show/%@/%@/%i",
                     user, repository, number]];
}

@end
