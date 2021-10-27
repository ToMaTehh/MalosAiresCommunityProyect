# Malos Aires Community Project

Este proyecto se trata de una rama Open Source del proyecto Malos Aires Roleplay. Aquí se podrá encontrar una Gamemode de tipo Roleplay, con funcionalidades básicas para desarrollar sistemas menores que quieran ser aportados al proyecto.

# Instalacion y ejecucion del gamemode para desarrollo

## Utilidades necesarias

Para poder ejecutar un servidor con esta gamemode, se necesitará un servidor **mysql**, en el caso de usar windows, la mejor opción es **[WAMP Server](https://sourceforge.net/projects/wampserver/)**, este programa presenta un servidor *apache*, *mysql* y *php*, el cual permite la creación y manejo de base de datos a través de una interfaz de navegador conocida como **phpmyadmin**.
 
Además se necesitará **sampctl**, la cual es una utilidad de consola desarrollada por la comunidad de samp para la gestión y manejo de paquetes, esta permite una instalación simple de plugins, además de facilitar el despliegue del servidor en diferentes plataformas. **[Aquí](https://github.com/Southclaws/sampctl/wiki/Windows)** puede encontrar un tutorial de instalación, si usted utiliza Windows 10 es recomendable que utilice la herramienta *scoop*.

## Despliegue de la gamemode

Una vez instaladas las utilidades, debemos proceder a abrir una terminal (CMD o PowerShell) en la carpeta del proyecto, allí debemos utilizar el siguiente comando:

```bash
sampctl p ensure
```

A partir de este comando, lo que hacemos es descargar todos los paquetes de sampctl necesarios para la ejecución del servidor.

Una vez descargados los paquetes, se deberá compilar la gamemode, para eso, se debe hacer uso del comando:

```bash
sampctl p build
```

Una vez compilada la gamemode, ya podemos correr el servidor para **iniciarlo** se deberá hacer uso del comando:

```bash
sampctl p run test
```

Cabe destacar que para poder correr, se deberá previamente importar en el servidor mysql la base de datos de pruebas que puede encontrarse en:

```bash
./resources/database/marp_db.sql
```

> Puede que al ejecutar el servidor la primera vez diga que faltan plugins, para solucionar esto, se debe copiar los plugins presentes en la carpeta ./resources/plugins/ a la carpeta ./plugins/

# Project Guidelines (Pautas de pawn del proyecto)

En esta sección se tratara las reglas a seguir a la hora de desarrollar sus propios módulos para el proyecto, se debe destacar que cualquier interés de agregar código al proyecto que no siga estas normas será rechazado sin revisar las funcionalidades.

## Variables

Para el caso de las variables:

* Todas se deben encontrar en **INGLES**. Ejemplo:

```c
//Forma incorrecta:
 
new Nombre_Jugador[playerid] = "Raul_Perez";
 
// Forma correcta
 
new Player_Name[playerid] = "Miguel_Casas";
```

* Estas deben empezar inequívocamente con el identificador del sistema, separado de un _ y el nombre real de la variable. Ejemplo:

```c
// Si tomamos como referencia un sistema de tuneo:
 
//Forma incorrecta:
 
new VehicleToTune[playerid] = 900;
 
// Forma correcta
 
new Tuning_VehicleTo[playerid] = 900;
```

* Las constantes deben encontrarse completamente en mayúsculas. Ejemplo:

```c
//Forma incorrecta:
 
#define afk_time 10
const max_houses = 10;
 
// Forma correcta
 
#define AFK_TIME 10
const MAX_HOUSES = 10;
```

* Constantes que tengan alcance global, o sean requeridas por otro sistema deben ser colocadas con #define.

* Las variables no deben ser utilizadas en otro lugar que no sea su sistema, para mover hacer uso entre diferentes sistemas, se debe hacer uso de una función que extraiga el valor.

### Arrays

* Todo array de sistema, debe tener un enum que facilite la lectura de código, para saber que valor del sistema se está modificando. Ejemplo:

```c
//Forma incorrecta:
 
new Float:Player_Pos[MAX_PLAYERS][3] = {{0.0, ...}, ...};
 
// Para setear la posición seria:
 
Player_Pos[playerid][0] = 1000; // x
Player_Pos[playerid][1] = 1000; // y
Player_Pos[playerid][2] = 1000; // z
 
// Forma correcta
 
enum e_PLAYER_POS
{
    playerPosX,
    playerPosY,
    playerPosZ
};
 
new Float:Player_Pos[MAX_PLAYERS][e_PLAYER_POS] = {{0.0, ...}, ...};
 
// Para setear la posición seria:
 
Player_Pos[playerid][playerPosX] = 1000; // x
Player_Pos[playerid][playerPosY] = 1000; // y
Player_Pos[playerid][playerPosZ] = 1000; // z
```

* Los enums deben iniciar con e_ y ser seguidos del identificador de sistema e identificador de función. Ejemplo:

```c
//Forma incorrecta:
 
enum jobdata
{
    skin,
    pay,
    time
};
 
// Forma correcta
 
enum e_JOB_DATA
{
    jobSkin,
    jobPay,
    jobTime
};
```

## Funciones

Para el caso de funciones:

* Las funciones deberán iniciar con el identificador de sistema, seguidas de guión bajo y su nombre. Ejemplo:

```c
//Forma incorrecta:
 
GetPlayerLevel(playerid) {
    return Player_Level[playerid];
};
 
// Forma correcta
 
Player_GetLevel(playerid) {
    return Player_Level[playerid];
};
```

## Callbacks

Para el caso de callbacks:

* Todos los callbacks nativos deben ser definidos en la gamemode y ser llamados con *hooks* desde cada uno de los modulos. (Unica exepcion ambos callbacks nativos de daño: **OnPlayerGiveDamage** y **OnPlayerTakeDamage**. Estos son solamente manejados por el sistem de heridas)

* Los callbacks personalizados de cada sistema, deben serguir la misma nomenclatura que las funciones, iniciar con el identificador de sistema, guion bajo y su nombre. Ejemplo:

```c
//Forma incorrecta:
 
forward OnPlayerPayPlayer(playerid, targetid, money);
public OnPlayerPayPlayer(playerid, targetid, money)
{
    Player_Money[playerid]-=money;
    Player_Money[targetid]+=money;
    return 1;
};
 
// Forma correcta
 
forward Money_OnPlayerPayToPlayer(playerid, targetid, money);
public Money_OnPlayerPayToPlayer(playerid, targetid, money)
{
    Player_Money[playerid]-=money;
    Player_Money[targetid]+=money;
    return 1;
};
```

## Manejo de módulos

* Los módulos de sistemas genéricos deben colocarse en la carpeta ./gamemodes/system/.

* Los módulos deben iniciar con el identificador marp_ y ser seguidos de su nombre en **Inglés**. Ejemplo:

```c
//Forma incorrecta:
 
marp_sistema_pesca.pwn
 
// Forma correcta
 
marp_fishing.pwn
```

* En caso de tratarse de un sistema mas complejo, se debe crear una carpeta particular para el sistema. Ejemplo:

```text
./
└───gamemodes
    │   marp_core.pwn
    │  
    └───houses
        │   marp_houses_core.pwn
        │   marp_houses.pwn
        │   ...
 
```

* Las funciones generales de un sistema deben colocarse en un archivo nombrado como marp_(nombre sistema)_core.pwn mientras que la estructura de datos debe colocarse en marp_(nombre sistema).pwn

> Este documento está en constante actualizacion
