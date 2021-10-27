#if defined _marp_bitflags_included
	#endinput
#endif
#define _marp_bitflags_included

#define BitFlag_Get(%0,%1)			((%0) & (%1))   // Returns zero (false) if the flag isn't set.
#define BitFlag_On(%0,%1)          	((%0) |= (%1))  // Turn on a flag.
#define BitFlag_Off(%0,%1)         	((%0) &= ~(%1)) // Turn off a flag.
#define BitFlag_Toggle(%0,%1)      	((%0) ^= (%1))  // Toggle a flag (swap true/false).


/*============================ USAGE ==============================

	- To define flags:

		// Up to 32 in one enum (N <= 32):
		// First flag in enum must always be initialized to = 1

		enum e_MyFlags:(<<= 1) { 
		    FLAG_1 = 1,				// 00000000000000000000000000000001
		    FLAG_2,					// 00000000000000000000000000000010
		    FLAG_3,					// 00000000000000000000000000000100
		    FLAG_4,					// 00000000000000000000000000001000
		    ...
		    ...
		    FLAG_N 					// 32 bits variable, so N <= 32 
		};

		new e_MyFlags:MyFlagVar;


	- To set all flags ON (1):

		//Hexadecimal for all 32 bits in 1

		MyFlagVar = e_MyFlags:0xFFFFFFFF;


	- To set all flags OFF (0):

		MyFlagVar = e_MyFlags:0;

==================================================================*/