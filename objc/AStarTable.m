#import "AStarTable.h"

AStarTable *tblNew(NSUInteger capacity) {
	AStarTable *table = malloc(sizeof(AStarTable));
	if (table) {
		table->capacity = capacity;
		table->table = calloc(sizeof(AStarTableEntry*), capacity);
		if (table->table)
			return table;
		free(table);
	}
	return NULL;
}

void tblFree(AStarTable *table) {
	NSUInteger i;
	AStarTableEntry *entry;
	
	for (i = 0; i < table->capacity; i++) {
		entry = table->table[i];
		while (entry) {
			AStarTableEntry *next = entry->next;
			free(entry);
			entry = next;
		}
	}
	
	free(table);
}

void tblAddEntry(AStarTable *table, AStarTableEntry *entry) {
	NSUInteger index = [entry->key hash] % table->capacity;
	AStarTableEntry *bucket = table->table[index];
	
	if (bucket) {
		while (bucket->next) bucket = bucket->next;
		bucket->next = entry;
	} else
		table->table[index] = entry;
}

void tblSetObject(AStarTable *table, id key, id value) {
	AStarTableEntry *entry = malloc(sizeof(AStarTableEntry));
	if (!entry) return;
	
	entry->next = NULL;
	entry->key = key;
	entry->objectValue = value;
	
	tblAddEntry(table, entry);
}

void tblSetFloat(AStarTable *table, id key, float value) {
	AStarTableEntry *entry = malloc(sizeof(AStarTableEntry));
	if (!entry) return;
	
	entry->next = NULL;
	entry->key = key;
	entry->objectValue = nil;
	entry->floatValue = value;
	
	tblAddEntry(table, entry);
}

AStarTableEntry *tblGetEntry(AStarTable *table, id key) {
	NSUInteger index = [key hash] % table->capacity;
	AStarTableEntry *entry = table->table[index];
	
	while (entry) {
		if ([entry->key isEqual:key])
			return entry;
		entry = entry->next;
	}
	
	return NULL;
}

id tblGetObject(AStarTable *table, id key) {
	AStarTableEntry *entry = tblGetEntry(table, key);
	return entry ? entry->objectValue : nil;
}

float tblGetFloat(AStarTable *table, id key) {
	AStarTableEntry *entry = tblGetEntry(table, key);
	return entry ? entry->floatValue : 0;
}
