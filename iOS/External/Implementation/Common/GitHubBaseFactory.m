//
//  GitHubBaseFactory.m
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/19/10.
//  Copyright (c) 2010 Patchwork Solutions AB. All rights reserved.
//

#import "GitHubBaseFactory.h"

#pragma mark -
#pragma mark Internal implementation declaration

static NSString * localServerAddress = @"http://github.com";

static NSString * localSecureServerAddress = @"https://github.com";

static NSDateFormatter *localFormatter = nil;

static NSURLCredential *localCredential = nil;

static NSString *localAuthorization = nil;

static BOOL localSecureConnection = NO;

@interface GitHubBaseFactory (hidden)

+(NSString *)base64StringFromData:(NSData *)data;

@end

@implementation GitHubBaseFactory

#pragma mark -
#pragma mark Memory and member management

//Copy
@synthesize request;

//Retain
@synthesize receivedData, currentStringValue, parser, connection, delegate,
endElement, startElement;

//Assign
@synthesize failSent, cancelling;

-(void)cleanUp {
  
  self.delegate = nil;
  self.receivedData = nil;
  self.request = nil;
  self.connection = nil;
  self.parser = nil;
  self.currentStringValue = nil;
}

-(void)dealloc {
  
  [self cleanUp];
  [super dealloc];
}

-(void)setParser:(NSXMLParser *)newParser {
  
  @synchronized(self) {
    
    if (parser != newParser) {
      
      [parser abortParsing];
      [parser release];
      parser = [newParser retain];
    }
  }
}

-(void)setConnection:(NSURLConnection *)newConnection {
  
  @synchronized(self) {
   
    if (connection != newConnection) {
      
      [connection cancel];
      [connection release];
      connection = [newConnection retain];
    }
  }
}

+(void)setServerAddress:(NSString *)newServerAddress {
  
  @synchronized(self) {
    
    if (localServerAddress != newServerAddress) {
      
      [localServerAddress release];
      localServerAddress = [newServerAddress copy];
    }
  }
}

+(NSString *)serverAddress {
  
  return localServerAddress;
}

+(void)setSecureServerAddress:(NSString *)newSecureServerAddress {
  
  @synchronized(self) {
    
    if (localSecureServerAddress != newSecureServerAddress) {
      
      [localSecureServerAddress release];
      localSecureServerAddress = [newSecureServerAddress copy];
    }
  }
}

+(NSString *)secureServerAddress {
  
  return localSecureServerAddress;
}

+(void)setCredential:(NSURLCredential *)credential {
  
  @synchronized(self) {
    
    if (localCredential != credential) {
      
      [localCredential release];
      localCredential = [credential retain];
      
      if (localCredential) {
        
        [localAuthorization release];
        localAuthorization = nil;
        
        NSString *tmp = [NSString stringWithFormat:@"%@:%@",
                                        credential.user,
                                        credential.password];
        
        NSData *data = [tmp dataUsingEncoding:NSUTF8StringEncoding];
        
        localAuthorization =
        [[NSString alloc] initWithFormat:@"Basic %@",
         [GitHubBaseFactory base64StringFromData:data]];
        
      } else {
        
        [localAuthorization release];
        localAuthorization = nil;
      }
    }
  }
}

+(NSURLCredential *)credential {
  
  return localCredential;
}

+(void)setSecureConnection:(BOOL)secureConnection {
  
  @synchronized(self) {
    
    localSecureConnection = secureConnection;
  }
}

+(BOOL)secureConnection {
  
  return localSecureConnection;
}

#pragma mark -
#pragma mark Internal implementation
#pragma mark - Instance

static char base64EncodingTable[64] = {
  'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
  'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
  'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
  'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
  'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
  'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
  'w', 'x', 'y', 'z', '0', '1', '2', '3',
  '4', '5', '6', '7', '8', '9', '+', '/'
};


+(NSString *)base64StringFromData:(NSData *)data {
  NSString *retVal= nil;
  
  int lentext = [data length]; 
  
  if (lentext > 0) {
    
    char *outbuf = malloc(lentext*4/3+4);
    
    if (outbuf) {
      
      const unsigned char *raw = [data bytes];
      
      int inp = 0;
      int outp = 0;
      int do_now = lentext - (lentext%3);
      
      for (outp = 0, inp = 0; inp < do_now; inp += 3) {
        
        outbuf[outp++] = base64EncodingTable[(raw[inp] & 0xFC) >> 2];
        
        outbuf[outp++] = 
        base64EncodingTable[((raw[inp] & 0x03) << 4) |
                            ((raw[inp+1] & 0xF0) >> 4)];
        
        outbuf[outp++] =
        base64EncodingTable[((raw[inp+1] & 0x0F) << 2) |
                            ((raw[inp+2] & 0xC0) >> 6)];
        
        outbuf[outp++] = base64EncodingTable[raw[inp+2] & 0x3F];
      }
      
      if (do_now < lentext) {
        
        unsigned char tmpbuf[3] = {0,0,0};
        int left = lentext%3;
        
        for (int i=0; i < left; i++) {
          
          tmpbuf[i] = raw[do_now+i];
        }
        raw = tmpbuf;
        inp = 0;
        outbuf[outp++] = base64EncodingTable[(raw[inp] & 0xFC) >> 2];
        
        outbuf[outp++] = base64EncodingTable[((raw[inp] & 0x03) << 4) |
                                             ((raw[inp+1] & 0xF0) >> 4)];
        
        if (left == 2) {
          
          outbuf[outp++] =
            base64EncodingTable[((raw[inp+1] & 0x0F) << 2) |
                                ((raw[inp+2] & 0xC0) >> 6)];
            
        } else {
          
          outbuf[outp++] = '=';
        }
        outbuf[outp++] = '=';
      }
      
      retVal =
        [[[NSString alloc] initWithBytes:outbuf
                                  length:outp
                                encoding:NSASCIIStringEncoding] autorelease];
      free(outbuf);
    }
  } else {
    
    retVal = @"";
  }

  return retVal;
}

-(id<GitHubService>)initWithDelegate:(id<GitHubServiceDelegate>)newDelegate {
  
  [super init];
  
  if (self) {
    
    self.delegate = newDelegate;
    self.cancelling = NO;
    self.failSent = NO;
  }
  return self;
}

-(void)endElementError {
  [self handleErrorWithCode:GitHubServerServerError
                    message:self.currentStringValue];
}

-(void)handleErrorWithCode:(GitHubServerError)code message:(NSString *)message {

  if (!self.cancelling && !self.failSent) {
    
    self.failSent = YES;
    
    if (!message) {
      
      message = @"";
    }
    
    [self.delegate gitHubService:self
                didFailWithError:[NSError
                                  errorWithDomain:GitHubServerErrorDomain
                                  code:code
                                  userInfo:[NSDictionary
                                            dictionaryWithObject:message
                                            forKey:NSLocalizedDescriptionKey]]];
    
    [self cleanUp];
  }
}

-(void)makeRequest:(NSString *) url {
  
  url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  
  if (localSecureConnection) {

    self.request =
    [NSString stringWithFormat:@"%@%@", localSecureServerAddress, url];
    
  } else {
    
    self.request =
    [NSString stringWithFormat:@"%@%@", localServerAddress, url];
    
  }
  
  NSMutableURLRequest *theRequest= [NSMutableURLRequest
                            requestWithURL:[NSURL URLWithString:self.request]
                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                            timeoutInterval:60.0]; 
  
  if (localAuthorization) {
    
    [theRequest
     addValue:localAuthorization
     forHTTPHeaderField:@"Authorization"];
  }
  
  self.connection = [NSURLConnection connectionWithRequest:theRequest
                                                  delegate:self];
  
  if (self.connection) {
    
    self.receivedData = [NSMutableData data];
  }
}

-(void)makePostRequest:(NSString *)url body:(NSString *)body {

  
  url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  
  if (localSecureConnection) {
    
    self.request =
    [NSString stringWithFormat:@"%@%@", localSecureServerAddress, url];
    
  } else {
    
    self.request =
    [NSString stringWithFormat:@"%@%@", localServerAddress, url];
  }
  
  NSMutableURLRequest *theRequest =
  [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] 
                          cachePolicy:NSURLRequestReloadIgnoringLocalCacheData 
                      timeoutInterval:60.0]; 
  
  [theRequest setHTTPMethod:@"POST"]; 
  
  [theRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
  
  if (localAuthorization) {
    
    [theRequest
     addValue:localAuthorization
     forHTTPHeaderField:@"Authorization"];
  }
  
  self.connection = [NSURLConnection connectionWithRequest:theRequest
                                                  delegate:self];
  if (self.connection) {
    
    self.receivedData = [NSMutableData data];
  }
}

#pragma mark -
#pragma mark Delegate protocol implementation
#pragma mark - NSXMLParserDelegate

-(void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI 
qualifiedName:(NSString *)qName
   attributes:(NSDictionary *)attributeDict {

  SEL aSel = [[self.startElement objectForKey:elementName] pointerValue];
  
  if (aSel || [[self.endElement objectForKey:elementName] pointerValue]) {
    
    self.currentStringValue = [NSMutableString stringWithCapacity:100];
  }
  
  if (aSel) {
    
    [self performSelector:aSel withObject:elementName withObject:attributeDict];
  }
}

-(void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
  
  SEL aSel = [[self.endElement objectForKey:elementName] pointerValue];
  
  if (aSel) {
    
    [self performSelector:aSel withObject:elementName];
    self.currentStringValue = nil;
  }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
  
  [self.currentStringValue appendString:string];
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
  
  [self handleErrorWithCode:GitHubServerParserError message:@""];
}

-(void)parserDidEndDocument:(NSXMLParser *)parser {
  
  if (!self.failSent && !self.cancelling) {
    
    [self.delegate gitHubServiceDone:self];
    [self cleanUp];
  }
}

#pragma mark - NSURLConnection

-(void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response {
  
  [self.receivedData setLength:0];
}

-(void)connection:(NSURLConnection *)connection
   didReceiveData:(NSData *)data {
  
  [self.receivedData appendData:data];
}

-(void)connection:(NSURLConnection *)connection
 didFailWithError:(NSError *)error {
  
  [self handleErrorWithCode:GitHubServerConnectionError message:@""];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
  
  self.parser = [[[NSXMLParser alloc]
                  initWithData:self.receivedData] autorelease];
  
  [self.parser setDelegate:self];
  [self.parser parse];
  self.connection = nil;
  self.receivedData = nil;
}

#pragma mark -
#pragma mark Super override implementation

+(void)initialize {
  
  if (!localFormatter) {
    
    localFormatter = [[NSDateFormatter alloc] init];
    [localFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
  }

}

#pragma mark -
#pragma mark Interface implementation
#pragma mark - Class

NSString * const GitHubServerErrorDomain = @"GitHubServerErrorDomain";

#pragma mark - Instance

-(void)cancelRequest {
  
  self.cancelling = YES;
  [self cleanUp];
}

-(NSURL *)createURLFromString:(NSString *)string {
  
  NSURL *url = [NSURL URLWithString:string];
  
  if (![string isEqual:@""] && !url.scheme) {
    
    url = [NSURL URLWithString:[NSString
                                stringWithFormat:@"http://%@",
                                string]];
    
  }
  return url;
}

-(NSDate *)createDateFromString:(NSString *)string {
  
  NSDate *retVal = nil;
  
  if ([string length] > 18) {
    
    retVal = [localFormatter dateFromString:[string substringToIndex:18]];
  }
  return retVal;
}

@end
