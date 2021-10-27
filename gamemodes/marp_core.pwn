/*
 				ooo        ooooo           oooo                                               
				`88.       .888'           `888                                               
				 888b     d'888   .oooo.    888   .ooooo.   .oooo.o                           
				 8 Y88. .P  888  `P  )88b   888  d88' `88b d88(  "8                           
				 8  `888'   888   .oP"888   888  888   888 `"Y88b.                            
				 8    Y     888  d8(  888   888  888   888 o.  )88b                           
				o8o        o888o `Y888""8o o888o `Y8bod8P' 8""888P'                           
				      .o.        o8o                                                          
				     .888.       `"'                                                          
				    .8"888.     oooo  oooo d8b  .ooooo.   .oooo.o                             
				   .8' `888.    `888  `888""8P d88' `88b d88(  "8                             
				  .88ooo8888.    888   888     888ooo888 `"Y88b.                              
				 .8'     `888.   888   888     888    .o o.  )88b                             
				o88o     o8888o o888o d888b    `Y8bod8P' 8""888P'                             
      ooooooooo.             oooo                       oooo                        
	  `888   `Y88.           `888                       `888                        
	   888   .d88'  .ooooo.   888   .ooooo.  oo.ooooo.   888   .oooo.   oooo    ooo 
	   888ooo88P'  d88' `88b  888  d88' `88b  888' `88b  888  `P  )88b   `88.  .8'  
	   888`88b.    888   888  888  888ooo888  888   888  888   .oP"888    `88..8'   
	   888  `88b.  888   888  888  888    .o  888   888  888  d8(  888     `888'    
	  o888o  o888o `Y8bod8P' o888o `Y8bod8P'  888bod8P' o888o `Y888""8o     .8'     
	                                          888                       .o..P'      
	                                         o888o                      `Y8P'


 ______ ______ ______ ______ ______ ______ ______ ______ ______ ______ ______ ______ 
|______|______|______|______|______|______|______|______|______|______|______|______|


			  ________     ____                       _       _     _           
			/ / ___\ \   / ___|___  _ __  _   _ _ __(_) __ _| |__ | |_         
		   | | |    | | | |   / _ \| '_ \| | | | '__| |/ _` | '_ \| __|        
		   | | |___ | | | |__| (_) | |_) | |_| | |  | | (_| | | | | |_         
		   | |\____|| |  \____\___/| .__/ \__, |_|  |_|\__, |_| |_|\__|        
			\_\    /_/             |_|    |___/        |___/                   
				  ____   ___  _  ___       ____   ___ ____  _                     
				 |___ \ / _ \/ |/ _ \     |___ \ / _ \___ \/ |                    
				   __) | | | | | | | |_____ __) | | | |__) | |                   
				  / __/| |_| | | |_| |_____/ __/| |_| / __/| |                   
				 |_____|\___/|_|\___/     |_____|\___/_____|_|                    
								  _                                                                  
								 | |__  _   _                                                        
								 | '_ \| | | |                                                       
								 | |_) | |_| |                                                       
								 |_.__/ \__, |                                                                                                         
						  ____  _       |___/   _                                            
						 |  _ \| |__   ___  ___| | __                                        
						 | |_) | '_ \ / _ \/ _ \ |/ /                                        
						 |  __/| | | |  __/  __/   <                                         
						 |_|   |_| |_|\___|\___|_|\_|                                        
					   ____                 _                                            
					  / ___| __ _ _ __ ___ (_)_ __   __ _                                
					 | |  _ / _` | '_ ` _ \| | '_ \ / _` |                               
					 | |_| | (_| | | | | | | | | | | (_| |                               
					  \____|\__,_|_| |_| |_|_|_| |_|\__, |                           
		 _          _   _                           |___/__      _           
		| |    __ _| |_(_)_ __   ___   __ _ _ __ ___   _/_/ _ __(_) ___ __ _ 
		| |   / _` | __| | '_ \ / _ \ / _` | '_ ` _ \ / _ \ '__| |/ __/ _` |
		| |__| (_| | |_| | | | | (_) | (_| | | | | | |  __/ |  | | (_| (_| |
		|_____\__,_|\__|_|_| |_|\___/ \__,_|_| |_| |_|\___|_|  |_|\___\__,_|

*/

/*******************************************************************************
********************************************************************************
***********************                                 ************************
*********************    MALOS AIRES ROLEPLAY GAMEMODE    **********************
**********										 			         ***********
********    (C) Copyright 2010 - 2021 by Pheek Gaming Latinoamérica    *********
**********                                            				 ***********
***********************    @Do not remove this label    ************************
***********************    @No remueva esta etiqueta    ************************
*************************                             **************************
********************************************************************************
*******************************************************************************/

#pragma warning disable 214 // warning 214: possibly a "const" array argument was intended: "array_name". Solo con pawncc ^3.10.4
#pragma warning disable 239 // warning 239: literal array/string passed to a non-const parameter. Solo con pawncc ^3.10.4

#define MAX_PLAYERS (75)

#include <a_samp>
#include <a_mysql>
#include <sscanf2>

#define YSI_NO_VERSION_CHECK
#define YSI_NO_CACHE_MESSAGE
#define YSI_NO_MODE_CACHE
#define CGEN_MEMORY (20000) // Requerido por librería YSI para reservar mayor tamaño de memoria para su código

#define FOREACH_NO_LOCALS
#define FOREACH_NO_ACTORS
#define FOREACH_NO_BOTS

#include <PawnPlus>
#include <YSI_Data\y_iterate> // provides foreach
#include <zcmd>
#include <streamer>
#include <Dini>
#include <cstl>
#include <anti_flood>
#include <easyDialog>
#include <progress2>
#include "util\marp_utils.pwn"					// Siempre antes que los demas modulos de marp.

#include "marp_database.pwn" 					//Funciones varias para acceso a datos


AntiDeAMX() {
    new b;
    #emit load.pri b
    #emit stor.pri b
}

main() {
    AntiDeAMX();
	return 1;
}

public OnGameModeInit()
{
	if(GetMaxPlayers() > MAX_PLAYERS)
    {
        printf("[ERROR] 'maxplayers' (%i) excede MAX_PLAYERS (%i). Arreglar.", GetMaxPlayers(), MAX_PLAYERS);
        SendRconCommand("exit");
    }

    SQLDB_LoadConfig();
    SQLDB_Connect();

	LoadSystemData();
	
	CallLocalFunction("OnGameModeInitEnded", "");
	return 1;
}

LoadSystemData(){
	return 1;
}

forward OnGameModeInitEnded();
public OnGameModeInitEnded() {
	return 1;
}

public OnGameModeExit()
{
	Streamer_DestroyAllItems(STREAMER_TYPE_OBJECT);
	Streamer_DestroyAllItems(STREAMER_TYPE_PICKUP);
	Streamer_DestroyAllItems(STREAMER_TYPE_CP);
	Streamer_DestroyAllItems(STREAMER_TYPE_RACE_CP);
	Streamer_DestroyAllItems(STREAMER_TYPE_MAP_ICON);
	Streamer_DestroyAllItems(STREAMER_TYPE_3D_TEXT_LABEL);
	Streamer_DestroyAllItems(STREAMER_TYPE_AREA);
	Streamer_DestroyAllItems(STREAMER_TYPE_ACTOR);

	SaveSystemData();

	SQLDB_Close();
	return 1;
}

SaveSystemData() {
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid) {
	return 1;
}

public OnPlayerUpdate(playerid) {
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) { // Dont handle dialogs here, use easyDialogs
    return 0;
}

public OnPlayerLeaveCheckpoint(playerid) {
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid) {
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid) {
	return 1;
}

public OnObjectMoved(objectid) {
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid) {
	return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid) {
	return 0;
}

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid) {
	return 0;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source) {
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid) {
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid) {
	return 1;
}

public OnPlayerCommandPerformed(playerid, cmdtext[], success) 
{
	if(!success) {
		SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Comando desconocido. Para ver una lista de comandos usa [/ayuda] o enví­a [/duda] a un administrador.");
	}
	return 1;
}