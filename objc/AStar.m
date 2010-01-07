#import "AStar.h"
#import "AStarTable.h"


@interface AStarPath ()
- (void)findPathFrom:(id<AStarNode>)start to:(id<AStarNode>)goal;
@end

@implementation AStarPath

+ (AStarPath*)pathFrom:(id<AStarNode>)start to:(id<AStarNode>)goal {
	return [[[AStarPath alloc] initWithStart:start goal:goal] autorelease];
}

- (id)initWithStart:(id<AStarNode>)start goal:(id<AStarNode>)goal {
	if (self = [super init]) {
		nodes = nil;
		cost = 0;
		[self findPathFrom:start to:goal];
	}
	return self;
}

- (BOOL)pathExists {
	return (nodes != nil);
}

@synthesize nodes;
@synthesize cost;

- (NSUInteger)length {
	return [nodes count];
}

- (id)nodeAtIndex:(NSUInteger)index {
	return [nodes objectAtIndex:index];
}

- (void)findPathFrom:(id<AStarNode>)start to:(id<AStarNode>)goal {
	NSMutableSet *openNodes = [NSMutableSet set];
	NSMutableSet *closedNodes = [NSMutableSet set];
	AStarTable *gScores = tblNew(1024);
	AStarTable *hScores = tblNew(1024);
	AStarTable *fScores = tblNew(1024);
	AStarTable *cameFrom = tblNew(1024);
	
	[openNodes addObject:start];
	tblSetFloat(gScores, start, 0);
	tblSetFloat(hScores, start, [start guessDistance:goal]);
	tblSetFloat(fScores, start, [start guessDistance:goal]);
	
	while ([openNodes count]) {
		id fMinNode = nil;
		float fMin = 0;
		NSEnumerator *openNodesEnum = [openNodes objectEnumerator];
		id node;
		
		while (node = [openNodesEnum nextObject]) {
			float thisFScore = tblGetFloat(fScores, node);
			if (!fMinNode || thisFScore < fMin) {
				fMinNode = node;
				fMin = thisFScore;
			}
		}
		
		if ([fMinNode isEqual:goal]) {
			NSMutableArray *path = [NSMutableArray array];
			node = fMinNode;
			while (node) {
				[path insertObject:node atIndex:0];
				node = tblGetObject(cameFrom, node);
			}
			nodes = [[NSArray alloc] initWithArray:path];
			cost = tblGetFloat(gScores, goal);
			break;
		}
		
		[openNodes removeObject:fMinNode];
		[closedNodes addObject:fMinNode];
		
		NSEnumerator *neighborsEnum = [[fMinNode neighbors] objectEnumerator];
		while (node = [neighborsEnum nextObject]) {
			if ([closedNodes containsObject:node]) continue;
			
			float thisGScore = tblGetFloat(gScores, node);
			float tmpGScore = thisGScore;
			BOOL tmpIsBetter;
			
			if ([fMinNode respondsToSelector:@selector(movementCost:)])
				tmpGScore += [fMinNode movementCost:node];
			
			if (![openNodes containsObject:node]) {
				[openNodes addObject:node];
				tmpIsBetter = YES;
			} else {
				tmpIsBetter = (tmpGScore < thisGScore);
			}
			
			if (tmpIsBetter) {
				tblSetObject(cameFrom, node, fMinNode);
				tblSetFloat(gScores, node, tmpGScore);
				tblSetFloat(hScores, node, [node guessDistance:goal]);
				tblSetFloat(fScores, node, thisGScore + [node guessDistance:goal]);
			}
		}
	}
	
	tblFree(gScores);
	tblFree(hScores);
	tblFree(fScores);
	tblFree(cameFrom);
}

@end
