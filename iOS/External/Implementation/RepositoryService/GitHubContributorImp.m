//
//  GitHubContributorImp.m
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/15/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import "GitHubContributorImp.h"

@implementation GitHubContributorImp

#pragma mark -
#pragma mark Memory and member management

//Copy
@synthesize name;

//Assign
@synthesize contributions;

-(void)dealloc {
  
  self.name = nil;
  [super dealloc];
}

#pragma mark -
#pragma mark Super override implementation

-(NSString *)description {
  
  return [NSString
          stringWithFormat:@"\nSTART - GitHubContributor\n"
          "Name:%@\n"
          "Contributions:%i\n"
          "END - GitHubContributor\n",
          self.name,
          self.contributions
          ];
}

-(NSComparisonResult)compare:(id<GitHubContributor>)otherContributor {
  
  return otherContributor.contributions - self.contributions;
}

#pragma mark -
#pragma mark Interface implementation
#pragma mark - Class

+(id<GitHubContributor>)contributor {
  
  return [[[GitHubContributorImp alloc] init] autorelease]; 
}

@end
