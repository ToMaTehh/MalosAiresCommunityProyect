#if defined _marp_streamings_inc
	#endinput
#endif
#define _marp_streamings_inc

//===============================CONSTANTES=====================================

#define RADIO_TYPE_NONE         0
#define RADIO_TYPE_VEH          1
#define RADIO_TYPE_SPEAKER      2
#define RADIO_TYPE_HOUSE        3
#define RADIO_TYPE_BIZ          4
#define RADIO_TYPE_BLD          5

//==================================DATA========================================

new SERVER_RADIOS[][128] = {

/*0*/	"NONE",
/*1*/	"http://mp3.metroaudio1.stream.avstreaming.net:7200/metro", // METRO FM 95.1
/*2*/	"http://provisioning.streamtheworld.com/pls/LOS40_ARGENTINA.pls", // 40 Principales FM 105.5
/*3*/	"http://buecrplb01.cienradios.com.ar/Mitre790.mp3",
/*4*/	"http://buecrplb01.cienradios.com.ar/Palermo_2.mp3",
/*5*/	"http://buecrplb01.cienradios.com.ar/fm979.mp3",
/*6*/	"http://buecrplb01.cienradios.com.ar/la100_mdq.mp3",
/*7*/	"http://200.58.112.154:9055/listen.pls", // Radio FOLKLORE Rosario 128 kbps
/*8*/	"http://188.165.236.90:8314/listen.pls", // Radio CHAMAM� 64 kbps
/*9*/	"http://50.22.218.101:21480/listen.pls", // Radio ROCK NACIONAL 128 kbps
/*10*/	"http://stream.electroradio.ch:26630",
/*11*/	"http://streaming.radionomy.com/MIXLA128KB",
/*12*/	"http://radio.ksolucoes.com.br:9944/listen.pls", // Radio RAP Brasil 128 kbps
/*13*/	"http://uk3.internet-radio.com:8136/listen.pls", // Easy Hits FLORIDA 192kbps
/*14*/	"http://us1.internet-radio.com:11094/listen.pls", // Smooth Jazz FLORIDA 128kbps
/*15*/	"http://us2.internet-radio.com:8443/listen.pls", // Radio BLUES 128 kbps
/*16*/	"http://109.123.116.202:8022/listen.pls", // Radio M�SICA CL�SICA 128 kbps
/*17*/	"http://200.58.116.222:11910", // FUTURO FM 106.3
/*18*/	"http://50.7.56.2:8040/listen.pls" // Radio TROPICAL�SIMA CUMBIA 128 kbps

};

enum e_streaming {
	e_id,
	e_type,
};

new player_streaming[MAX_PLAYERS][e_streaming];

stock Radio_GetId(playerid)
{
	return player_streaming[playerid][e_id];
}
	
stock Radio_GetType(playerid)
{
	return player_streaming[playerid][e_type];
}

Radio_IsOn(playerid)
{
	return (player_streaming[playerid][e_id] && player_streaming[playerid][e_type]);
}

Radio_IsOnType(playerid, type)
{
	return (player_streaming[playerid][e_id] && player_streaming[playerid][e_type] == type);
}

Radio_GetAmount()
{
	return sizeof(SERVER_RADIOS);
}

Radio_Set(playerid, id, type)
{
	player_streaming[playerid][e_id] = id;
	player_streaming[playerid][e_type] = type;
	PlayAudioStreamForPlayer(playerid, SERVER_RADIOS[id]);
}

Radio_SetEx(playerid, id, type, Float:x, Float:y, Float:z, Float:radius)
{
	player_streaming[playerid][e_id] = id;
	player_streaming[playerid][e_type] = type;
	PlayAudioStreamForPlayer(playerid, SERVER_RADIOS[id], x, y, z, radius, 1);
}

Radio_Stop(playerid)
{
	Radio_Reset(playerid);
    StopAudioStreamForPlayer(playerid);
}

Radio_Reset(playerid)
{
	player_streaming[playerid][e_id] = 0;
	player_streaming[playerid][e_type] = 0;
}
