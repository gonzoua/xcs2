//
//  XCProject.m
//  xcs
//
//  Created by Oleksandr Tymoshenko on 2013-04-28.
//  Copyright (c) 2013 Bluezbox Software. All rights reserved.
//

#import "XCProject.h"

@implementation XCProject

- (id)init
{
    self = [super init];
    if (self) {
        projDict = nil;
    }
    return self;
}

- (BOOL)parseFile:(NSString*)path
{

    projDict = [NSDictionary dictionaryWithContentsOfFile:path];
    if (projDict) {
        objects = [projDict objectForKey:@"objects"];
        NSString *rootObjId = [projDict objectForKey:@"rootObject"];
        rootObj = [self objectForId:rootObjId];

        return YES;
    }

    return NO;
}

- (NSDictionary*)objectForId:(NSString*)objId
{
    return [objects valueForKey:objId];
}

- (void)list
{
    NSString *mainFolderId = [rootObj objectForKey:@"mainGroup"];
    NSDictionary *mainFolder = [self objectForId:mainFolderId];
    [self listFolder:mainFolder indent:0];
}

- (void)listFolder:(NSDictionary*)folder indent:(NSUInteger)indent
{
    for (NSUInteger i = 0; i < indent; i ++)
        printf(" ");
    NSString *name = [folder objectForKey:@"name"];
    if (name == nil)
        name = [folder objectForKey:@"path"];
    printf("%s", 
            [name UTF8String]);
    BOOL isGroup = NO;
    if ([[folder objectForKey:@"isa"] caseInsensitiveCompare:@"PBXGroup"] == NSOrderedSame)
        isGroup = YES;
    if ([[folder objectForKey:@"isa"] caseInsensitiveCompare:@"PBXVariantGroup"] == NSOrderedSame)
        isGroup = YES;

    if (isGroup) {
        printf("/\n");
        NSArray *children = [folder objectForKey:@"children"];
        for (NSString *idString in children) {
            NSDictionary *obj = [self objectForId:idString];
            if (obj)
                [self listFolder:obj indent:indent+2];
        }
    }
    else
        printf("\n");
}
@end
