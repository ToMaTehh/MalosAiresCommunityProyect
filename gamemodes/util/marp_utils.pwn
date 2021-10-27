#if defined _marp_util_included
	#endinput
#endif
#define _marp_util_included

#include "util\marp_colors.pwn"
#include "util\marp_distances.pwn"
#include "util\marp_bitflags.pwn"
#include "util\marp_streamings.pwn"
#include "util\marp_vehicleutil.pwn"
#include "util\marp_vehicle_colors.pwn"
#include "util\marp_cronometro.pwn"

#define TIMER:%1(%2) forward %1(%2); public %1(%2)

#define KEY_PRESSED_MULTI(%0) (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0))) // Para combinaciones de teclas se debe usar esta.
// Si newkeys es (CTRL+H+F) activas => si quiero detectar H, funciona.
// Si newkeys es (CTRL+H+F) activas => si quiero detectar CTRL+H, funciona.
// Si newkeys es (CTRL+H+F) activas => si quiero detectar que SOLO apreta H, no funciona (da siempre V).

#define KEY_PRESSED_SINGLE(%0) ((newkeys & (%0)) && !(oldkeys & (%0))) // detecta si se aprieta la tecla buscada mientras esta apretando otras
// Si newkeys es (CTRL+H+F) activas => si quiero detectar H, funciona.
// Si newkeys es (CTRL+H+F) activas => si quiero detectar CLTR+H, NO funciona.
// Si newkeys es (CTRL+H+F) activas => si quiero detectar que SOLO apreta H, no funciona (da siempre V).

#define KEY_HOLDING(%0) ((newkeys & (%0)) == (%0))
#define KEY_PRESSING(%0,%1) ((%0 & (%1)) == (%1))
#define KEY_RELEASED_SINGLE(%0) (!(newkeys & (%0)) && (oldkeys & (%0)))
#define KEY_RELEASED_MULTI(%0) (((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))

// Disables.
#define DISABLE_NONE            0
#define DISABLE_FREEZE          1
#define DISABLE_LESS_LETHAL     2
#define DISABLE_DYING           3
#define DISABLE_STEALING        4
#define DISABLE_DEATHBED        5
#define DISABLE_HEALING         6
#define DISABLE_VISITING		7

// Jails
#define JAIL_NONE           	0
#define JAIL_IC_PMA         	1
#define JAIL_OOC            	2
#define JAIL_IC_PRISON     		3
#define JAIL_IC_GOB         	4
#define JAIL_IC_PMA_EAST		5

enum sInfo {
	sVehiclePricePercent,
	sPlayersRecord,
	svLevelExp,
	sDrugRawMats
};
new ServerInfo[sInfo];

new Mobile[MAX_PLAYERS],
	bool:AdminDuty[MAX_PLAYERS];

// valstr fix by Slice
stock FIX_valstr(dest[], value, bool:pack = false)
{
    // format can't handle cellmin properly
    static const cellmin_value[] = !"-2147483648";

    if (value == cellmin) {
        pack && strpack(dest, cellmin_value, 12) || strunpack(dest, cellmin_value, 12);
    }
    else {
        format(dest, 12, "%d", value), pack && strpack(dest, dest, 12);
    }
}
#define valstr FIX_valstr

stock GetDateString() {
	new year, month, day, hour, minute, second, str[32];
	getdate(year, month, day);
	gettime(hour, minute, second);
	format(str, 32, "%02d-%02d-%02d %02d:%02d:%02d", year, month, day, hour, minute, second);
	return str;
}

stock GetHourString() {
	new hour, minute, second, str[16];
	gettime(hour, minute, second);
	format(str, 16, "%02d:%02d:%02d", hour, minute, second);
	return str;
}

GetPlayerSpeed(playerid)
{
	static Float:vx, Float:vy, Float:vz;

	if(IsPlayerInAnyVehicle(playerid)) {
		GetVehicleVelocity(GetPlayerVehicleID(playerid), vx, vy, vz);
	} else {
		GetPlayerVelocity(playerid, vx, vy, vz);
	}

	return floatround(VectorSize(vx, vy, vz) * 180.5);
}

/************** Improved SendClientMessageToAll to support +144 characters **************/

#define ExtractFirstLine(%1,%2); {memcpy(%1,%2,0,556);%1[139]='\0';strcat(%1," ...");}
#define ExtractSecondLine(%1,%2); {%1="... ";strcat(%1,%2[139]);}
static scmex_line[144];

stock SendClientMessageEx(playerid, color, const message[])
{
	if(strlen(message) > 144)
	{
		ExtractFirstLine(scmex_line, message);
		SendClientMessage(playerid, color, scmex_line);
		ExtractSecondLine(scmex_line, message);
		SendClientMessage(playerid, color, scmex_line);
	} else {
	    SendClientMessage(playerid, color, message);
	}
	return 1;
}

#if defined _ALS_SendClientMessage
	#undef SendClientMessage
#else
	#define _ALS_SendClientMessage
#endif
#define SendClientMessage SendClientMessageEx

stock SendClientMessageToAllEx(color, const message[])
{
	if(strlen(message) > 144)
	{
		ExtractFirstLine(scmex_line, message);
		SendClientMessageToAll(color, scmex_line);
		ExtractSecondLine(scmex_line, message);
		SendClientMessageToAll(color, scmex_line);
	} else {
	    SendClientMessageToAll(color, message);
	}
	return 1;
}

#if defined _ALS_SendClientMessageToAll
	#undef SendClientMessageToAll
#else
	#define _ALS_SendClientMessageToAll
#endif
#define SendClientMessageToAll SendClientMessageToAllEx

/************************************* SendFMessage *************************************/

new sfm_msg_str[256]; // Global formatted message string

#define SendFMessage(%0,%1,%2,%3); {format(sfm_msg_str,256,%2,%3);SendClientMessage(%0,%1,sfm_msg_str);}
#define SendFMessageToAll(%1,%2,%3); {format(sfm_msg_str,256,%2,%3);SendClientMessageToAll(%1,sfm_msg_str);}

/************************* Fix and improved SetPlayerCheckpoint *************************/

static SPP_Fix_Id_Count = 1;
static SPP_Fix_Id[MAX_PLAYERS];

GetPlayerActiveCheckpointID(playerid) {
	return SPP_Fix_Id[playerid];
}

stock SetPlayerCheckpointEx(playerid, Float:x, Float:y, Float:z, Float:size)
{
	DisablePlayerCheckpoint(playerid); // Fix new checkpoint with old checkpoint's size if not disabled before.
	SetPlayerCheckpoint(playerid, x, y, z, size);
	SPP_Fix_Id[playerid] = SPP_Fix_Id_Count++;
	return SPP_Fix_Id[playerid]; // Improved: now with ID's
}

#if defined _ALS_SetPlayerCheckpoint
	#undef SetPlayerCheckpoint
#else
	#define _ALS_SetPlayerCheckpoint
#endif
#define SetPlayerCheckpoint SetPlayerCheckpointEx

/****************************************************************************************/

stock strcmpEx(const string1[], const string2[], bool:ignorecase=false, length=cellmax)
{
	if(isnull(string1) || isnull(string2))
		return -1;

	return strcmp(string1, string2, ignorecase, length);
}

#if defined _ALS_strcmp
	#undef strcmp
#else
	#define _ALS_strcmp
#endif
#define strcmp strcmpEx

stock GetObjectCount()
{
	new count;
	for(new o; o < MAX_OBJECTS; o++) {
		if(IsValidObject(o)) {
			count++;
		}
	}
	return count;
}

ClearScreen(playerid)
{
	for(new i = 0; i < 15; i++) {
		SendClientMessage(playerid, COLOR_WHITE, " ");
	}
	return 1;
}

stock GetPlayerIpAddress(playerid) 
{
	new ip[16];
	GetPlayerIp(playerid, ip, sizeof(ip));
	return ip;
}

IsValidSkin(skin) {
	return ((1 <= skin <= 311) && skin != 74);
}

IsNameRoleplayValid(const name[])
{
	new lower_count, _count, _pos, len = strlen(name);

	for(new i = 0; i < len; i++)
	{
		if(name[i] >= 'a' && name[i] <= 'z') {
			lower_count++;
		}
		else if(name[i] == '_') {
			_count++;
			_pos = i;
		}
	}

	if(_count != 1 || \
		(name[0] < 'A' || name[0] > 'Z' || name[_pos+1] < 'A' || name[_pos+1] > 'Z') || \
		(name[len-1] < 'a' || name[len-1] > 'z') || \
		(lower_count + 3) != len) {
		return 0;
	}
	return 1;
}

GetPlayerNameEx(playerid)
{
  new name[MAX_PLAYER_NAME];
  GetPlayerName(playerid, name, MAX_PLAYER_NAME);
  return name;
}

GenerateRandomPassword(passw[10]) {
	format(passw, 10, "%c%i%c%i%c%i%c%i%c", 97+random(26), random(10), 65+random(26), random(10), 97+random(26), random(10), 65+random(26), random(10), 97+random(26));
}

SendPlayerMessageInRange(Float:range, playerid, const string[], col1, col2, col3, col4, col5, show_self = 1)
{
	static Float:x, Float:y, Float:z, vworld;

	GetPlayerPos(playerid, x, y, z);
	vworld = GetPlayerVirtualWorld(playerid);

	foreach(new i : Player)
	{
		if(GetPlayerVirtualWorld(i) == vworld)
		{
			if(i == playerid) {
				if(show_self) {
					SendClientMessage(i, col1, string);
				}
			}
			else if(IsPlayerInRangeOfPoint(i, range, x, y, z))
			{
				if(IsPlayerInRangeOfPoint(i, range / 16.0, x, y, z)) {
					SendClientMessage(i, col1, string);
				} else if(IsPlayerInRangeOfPoint(i, range / 8.0, x, y, z)) {
					SendClientMessage(i, col2, string);
				} else if(IsPlayerInRangeOfPoint(i, range / 4.0, x, y, z)) {
					SendClientMessage(i, col3, string);
				} else if(IsPlayerInRangeOfPoint(i, range / 2.0, x, y, z)) {
					SendClientMessage(i, col4, string);
				} else {
					SendClientMessage(i, col5, string);
				}
			}
		}
	}
	return 1;
}

SendMessageInRange(Float:range, Float:x, Float:y, Float:z, vworld, const string[], col1, col2, col3, col4, col5)
{
	foreach(new i : Player)
	{
		if(GetPlayerVirtualWorld(i) == vworld)
		{
			if(IsPlayerInRangeOfPoint(i, range, x, y, z))
			{
				if(IsPlayerInRangeOfPoint(i, range / 16.0, x, y, z)) {
					SendClientMessage(i, col1, string);
				} else if(IsPlayerInRangeOfPoint(i, range / 8.0, x, y, z)) {
					SendClientMessage(i, col2, string);
				} else if(IsPlayerInRangeOfPoint(i, range / 4.0, x, y, z)) {
					SendClientMessage(i, col3, string);
				} else if(IsPlayerInRangeOfPoint(i, range / 2.0, x, y, z)) {
					SendClientMessage(i, col4, string);
				} else {
					SendClientMessage(i, col5, string);
				}
			}
		}
	}
	return 1;
}

PlaySoundInRangeOfPlayer(playerid, Float:range, sound)
{
	new Float:x, Float:y, Float:z, vworld;

	GetPlayerPos(playerid, x, y, z);
	vworld = GetPlayerVirtualWorld(playerid);

	foreach(new i : Player)
	{
		if(GetPlayerVirtualWorld(i) == vworld && IsPlayerInRangeOfPoint(i, range, x, y, z)) {
			PlayerPlaySound(i, sound, x, y, z);
		}
	}
	return 1;
}

bool:Util_HasInvalidSQLCharacter(const string[]) {
	return (strfind(string, "\"") != -1 || strfind(string, "\'") != -1 || strfind(string, "\\") != -1);
}

Util_PrintInvalidSQLCharacter(playerid) {
	return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" Algún carácter ingresado es inválido ( \' \" \\ ).");
}
