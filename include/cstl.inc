#if defined _cstl_inc
	#endinput
#endif
#define _cstl_inc
#pragma library cstl

#define VEC_ENTRY_TYPE_CELL 1
#define VEC_ENTRY_TYPE_ARRAY 2
#define VEC_ENTRY_TYPE_FLOAT 3

// VECTOR

native vector_push_back(vecid, element); // push element
native vector_push_back_float(vecid, Float:element); // push element
native vector_push_back_arr(vecid, element[]); // push array

native vector_size(vecid); // get vector size

native vector_get(vecid, id); // get element
native Float:vector_get_float(vecid, id); // get floating point number
native vector_get_arr(vecid, id, buffer[], buflen); // get array element to buffer

native vector_set(vecid, id, element); // set cell
native vector_set_float(vecid, id, Float:element); // set cell
native vector_set_arr(vecid, id, element[]); // set array

native vector_clear(vecid); // clear vector
native vector_resize(vecid, newsize); // attention!: reducing size causes memory leaks if array pointers are removed

native vector_entry_type(vecid, id); // get element type
native vector_remove(vecid, id); // remove element by ID

native vector_find(vecid, element);  // find ID of int element
native vector_find_float(vecid, Float:element); // find ID of float element
native vector_find_arr(vecid, element[]); // find ID of array

native vector_globalize(vecid); // makes vector visible to all scripts
native vector_deglobalize(vecid); // deglobalizes vector (vector removed from all scripts except calling script)
native vector_is_globalized(vecid); // is vector ID globalized

native vector_index_exists(vecid, index); // does index exist

#define INVALID_VECTOR_ID	0

stock vector_create(size = 0)
{
	static VECTORS_ID_COUNT = 1; // Vectors Id's are never repeated

	if(size > 0) {
		vector_resize(VECTORS_ID_COUNT, size);
	}
	return (VECTORS_ID_COUNT++);
}

stock vector_pop_front(vecid)
{
	if(vector_size(vecid))
	{
		new value = vector_get(vecid, 0);
		vector_remove(vecid, 0);
		return value;
	}
	return 0;
}

stock Float:vector_pop_front_float(vecid)
{
	if(vector_size(vecid))
	{
		new Float:value = vector_get_float(vecid, 0);
		vector_remove(vecid, 0);
		return value;
	}
	return 0.0;
}

stock vector_pop_front_arr(vecid, buffer[], buflen)
{
	if(vector_size(vecid))
	{
		vector_get_arr(vecid, 0, buffer, buflen);
		vector_remove(vecid, 0);
		return 1;
	}
	return 0;
}

stock vector_pop_back(vecid)
{
	new size = vector_size(vecid);
	if(size)
	{
		new value = vector_get(vecid, size-1);
		vector_remove(vecid, size-1);
		return value;
	}
	return 0;
}

stock Float:vector_pop_back_float(vecid)
{
	new size = vector_size(vecid);
	if(size)
	{
		new Float:value = vector_get_float(vecid, size-1);
		vector_remove(vecid, size-1);
		return value;
	}
	return 0.0;
}

stock vector_pop_back_arr(vecid, buffer[], buflen)
{
	new size = vector_size(vecid);
	if(size)
	{
		vector_get_arr(vecid, size-1, buffer, buflen);
		vector_remove(vecid, size-1);
		return 1;
	}
	return 0;
}

stock vector_print_for_player(vecid, playerid)
{
	if(vecid < 1 || !vector_size(vecid))
		return 0;

	new str[512];
	format(str, sizeof(str), "[ =============================== Vector ID %i =============================== ]", vecid);
	SendClientMessage(playerid, -1, str);

	for(new i = 0, size = vector_size(vecid); i < size; i++)
	{
		switch(vector_entry_type(vecid, i))
		{
			case VEC_ENTRY_TYPE_CELL:
			{
				format(str, sizeof(str), "[%i] - Cell: %i", i, vector_get(vecid, i));
				SendClientMessage(playerid, -1, str);
			}
			case VEC_ENTRY_TYPE_ARRAY:
			{
				vector_get_arr(vecid, i, str, sizeof(str));
				format(str, sizeof(str), "[%i] - Array: %s", i, str);
				SendClientMessage(playerid, -1, str);
			}
			case VEC_ENTRY_TYPE_FLOAT:
			{
				format(str, sizeof(str), "[%i] - Float: %f", i, vector_get_float(vecid, i));
				SendClientMessage(playerid, -1, str);
			}
		}
	}

	SendClientMessage(playerid, -1, "[ ========================================================================== ]");
	return 1;
}

/*

// MAP

native map_insert(mapid, key[], value);
native map_insert_float(mapid, key[], Float:value);
native map_insert_arr(mapid, key[], value[]);

native map_get(mapid, key[]);
native Float:map_get_float(mapid, key[]);
native map_get_arr(mapid, key[], buffer[], buflen);

native map_size(mapid);
native map_remove(mapid, key[]);
native map_contains(mapid, key[]);
native map_entry_type(mapid, key[]);

native map_clear(mapid);

native map_globalize(mapid); // makes map visible to all scripts
native map_deglobalize(mapid); // deglobalizes map (map removed from all scripts except calling script)
native map_is_globalized(mapid); // is map ID globalized

#define INVALID_MAP_ID	0
#define MAP_SYSTEM_ID	0 // Dont use ID 0, LEAVE IT ALWAYS IN 0 SIZE

static MAPS_ID_COUNT = 1; // Maps Id's are never repeated

stock map_create() {
	printf("creating map id %i", MAPS_ID_COUNT);
	return (MAPS_ID_COUNT++);
}
*/
