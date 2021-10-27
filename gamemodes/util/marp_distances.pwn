#if defined _marp_distances_included
	#endinput
#endif
#define _marp_distances_included

stock Float:GetDistance2D(Float:x1, Float:y1, Float:x2, Float:y2) {
	return VectorSize(x1 - x2, y1 - y2, 0.0);
}

stock Float:GetDistance3D(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2) {
	return VectorSize(x1 - x2, y1 - y2, z1 - z2);
}

stock GetXYInFrontOfPoint(Float:x, Float:y, Float:a, &Float:xf, &Float:yf, Float:distance)
{
    xf = x + (distance * floatsin(-a, degrees));
    yf = y + (distance * floatcos(-a, degrees));
}

stock GetXYBehindPoint(Float:x, Float:y, Float:a, &Float:xf, &Float:yf, Float:distance)
{
    xf = x + (distance * -floatsin(-a, degrees));
    yf = y + (distance * -floatcos(-a, degrees));
}

stock Float:Veh_GetDistanceFromPlayer(vehicleid, playerid)
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	return GetVehicleDistanceFromPoint(vehicleid, x, y, z);
}

stock GetXYBehindPlayer(playerid, &Float:x, &Float:y, Float:distance)
{
    new Float:a;
    GetPlayerPos(playerid, x, y, a);
    if(!IsPlayerInAnyVehicle(playerid)) {
    	GetPlayerFacingAngle(playerid, a);
    } else {
    	GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
    }
    x += (distance * -floatsin(-a, degrees));
    y += (distance * -floatcos(-a, degrees));
}

stock GetXYInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance)
{
	new Float:a;
	GetPlayerPos(playerid, x, y, a);
    if(!IsPlayerInAnyVehicle(playerid)) {
    	GetPlayerFacingAngle(playerid, a);
    } else {
    	GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
    }
	x += (distance * floatsin(-a, degrees));
	y += (distance * floatcos(-a, degrees));
}

stock Float:GetDistanceBetweenPlayers(p1, p2)
{
	if(!IsPlayerConnected(p1) || !IsPlayerConnected(p2)) {
		return -1.00;
	}
	new Float:x2, Float:y2, Float:z2;
	GetPlayerPos(p2, x2, y2, z2);
	return GetPlayerDistanceFromPoint(p1, x2, y2, z2);
}

stock GetClosestPlayer(p1) {
	new Float:dis = 99999.99, Float:dis2, player = -1;

	foreach(new i : Player) {
		if(i != p1) {
			dis2 = GetDistanceBetweenPlayers(i,p1);

			if(dis2 < dis && dis2 != -1.00) {
				dis = dis2;
				player = i;
			}
		}
	}
	return player;
}

stock GetXYZInFrontVehicle(vehicleid, &Float:x, &Float:y, &Float:z, Float:distance)
{
	new Float:a;
	GetVehiclePos(vehicleid, x, y, z);
	GetVehicleZAngle(vehicleid, a);
	x += (distance * -floatsin(a, degrees));
	y += (distance * -floatcos(a, degrees));
}

// Devuelve las coordenadas del punto (x,y,z) ubicado detrás del vehículo (vehicleid) a una distancia (distance) de su centro de coordenadas.
// Util para conocer, por ejemplo, dado cierto momento del vehículo, las coordenadas del punto del baúl o detrás del baúl.
stock GetXYZBehindVehicle(vehicleid, &Float:x, &Float:y, &Float:z, Float:distance)
{
	new Float:a;
	GetVehiclePos(vehicleid, x, y, z);
	GetVehicleZAngle(vehicleid, a);
	x += (distance * -floatsin(-a, degrees));
	y += (distance * -floatcos(-a, degrees));
}

// Util para normalizar un ángulo o resultados de cuentas entre ángulos al rango (0-360)°.
stock Float:NormalizeAngle(Float:angle)
{
	if(angle < 0.0)
	    return (angle + float(360 * floatround(-angle / 360.0, floatround_ceil)));
	else if(angle > 360.0)
	    return (angle - float(360 * floatround(angle / 360.0, floatround_floor)));
	else
		return angle;
}

// Util para chequear si cierto ángulo (check_angle) es "parecido" a un ángulo de referencia (original_angle), teniendo en cuenta cierta tolerancia (en grados).
// Es decir, mira si se encuentra en el rango del ángulo de referencia (original_angle) +- la tolerancia (en grados).
stock CheckIfAngleIsInRange(Float:original_angle, Float:check_angle, Float:tolerance)
{
	new Float:min_range = NormalizeAngle(original_angle - tolerance), // Si por ejemplo quedase -20°, normalizandolo al intervalo positivo 0-360 nos quedaría 340°.
	    Float:max_range = NormalizeAngle(original_angle + tolerance); // Si por ejemplo quedase 380°, normalizandolo al intervalo 0-360 nos quedaría 20°.
	    
	if(max_range - min_range < 0.0) // Es un rango que me da la vuelta por el 0° / 360°. Ej: > 320° y < 40°, donde min_range se invirtió de -40° a 320°, y max_range es 40°
	    return (check_angle >= min_range || check_angle <= max_range);
	else // No da la vuelta. Ej: > 100° y < 180°, donde min_range es 100° y max_range 180°
	    return (check_angle >= min_range && check_angle <= max_range);
}

GetClosestVehicle(playerid, Float:range)
{
	new Float:x, Float:y, Float:z, Float:distance, Float:mindistance = 99999.0, playervehid, closestvehid = INVALID_VEHICLE_ID;

	playervehid = GetPlayerVehicleID(playerid);
	GetPlayerPos(playerid, x, y, z);

	foreach(new vehid : StreamedVehicle[playerid])
	{
		if(vehid != playervehid)
		{
			distance = GetVehicleDistanceFromPoint(vehid, x, y, z);

			if(distance <= range && distance < mindistance)
			{
				mindistance = distance;
				closestvehid = vehid;
			}
		}
	}

	return closestvehid;
}

IsPlayerInRangeOfPlayer(Float:range, p1, p2)
{
	if(!IsPlayerConnected(p1) || !IsPlayerConnected(p2))
		return 0;
	if(GetPlayerVirtualWorld(p1) != GetPlayerVirtualWorld(p2))
		return 0;

	new Float:x2, Float:y2, Float:z2;
	GetPlayerPos(p2, x2, y2, z2);
	return IsPlayerInRangeOfPoint(p1, range, x2, y2, z2);
}