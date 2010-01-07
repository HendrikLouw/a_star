// A basic hash table implementation that uses Objective-C objects as keys, and
// either Objective-C objects or floats as values. Unlike NSMutableDictionary,
// these hash tables do not copy their keys, so keys do not have to implement
// the NSCopying protocol. AStarPath uses these tables internally so that it
// can use <AStarNode> objects as keys without imposing NSCopying on them.
//
// As a bonus, foregoing NSMutableDictionary in favor of AStarTable prevents
// AStarPath from accumulating an absurd quantity of NSNumber objects.

#import <Foundation/Foundation.h>


typedef struct {
	void *next;
	id key;
	id objectValue;
	float floatValue;
} AStarTableEntry;

typedef struct {
	NSUInteger capacity;
	AStarTableEntry **table;
} AStarTable;


AStarTable *tblNew(NSUInteger capacity);
void tblFree(AStarTable *table);

void tblSetObject(AStarTable *table, id key, id value);
void tblSetFloat(AStarTable *table, id key, float value);

id tblGetObject(AStarTable *table, id key);
float tblGetFloat(AStarTable *table, id key);
