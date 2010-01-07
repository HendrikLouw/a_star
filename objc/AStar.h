#import <Foundation/Foundation.h>


@protocol AStarNode

- (NSArray*)neighbors;
- (float)guessDistance:(id<AStarNode>)node;

@optional
- (float)movementCost:(id<AStarNode>)neighbor;

@end


@interface AStarPath : NSObject {
	NSArray *nodes;
	float cost;
}

+ (AStarPath*)pathFrom:(id<AStarNode>)start to:(id<AStarNode>)goal;
- (id)initWithStart:(id<AStarNode>)start goal:(id<AStarNode>)goal;

- (BOOL)pathExists;

@property (readonly, nonatomic, retain) NSArray *nodes;
@property (readonly, nonatomic) float cost;

- (NSUInteger)length;
- (id)nodeAtIndex:(NSUInteger)index;

@end
