
obj/user/ef_tst_sharing_1:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	mov $0, %eax
  800020:	b8 00 00 00 00       	mov    $0x0,%eax
	cmpl $USTACKTOP, %esp
  800025:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  80002b:	75 04                	jne    800031 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  80002d:	6a 00                	push   $0x0
	pushl $0
  80002f:	6a 00                	push   $0x0

00800031 <args_exist>:

args_exist:
	call libmain
  800031:	e8 64 03 00 00       	call   80039a <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the creation of shared variables (create_shared_memory)
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 34             	sub    $0x34,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003f:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800043:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004a:	eb 29                	jmp    800075 <_main+0x3d>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004c:	a1 20 40 80 00       	mov    0x804020,%eax
  800051:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800057:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005a:	89 d0                	mov    %edx,%eax
  80005c:	01 c0                	add    %eax,%eax
  80005e:	01 d0                	add    %edx,%eax
  800060:	c1 e0 03             	shl    $0x3,%eax
  800063:	01 c8                	add    %ecx,%eax
  800065:	8a 40 04             	mov    0x4(%eax),%al
  800068:	84 c0                	test   %al,%al
  80006a:	74 06                	je     800072 <_main+0x3a>
			{
				fullWS = 0;
  80006c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800070:	eb 12                	jmp    800084 <_main+0x4c>
_main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800072:	ff 45 f0             	incl   -0x10(%ebp)
  800075:	a1 20 40 80 00       	mov    0x804020,%eax
  80007a:	8b 50 74             	mov    0x74(%eax),%edx
  80007d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800080:	39 c2                	cmp    %eax,%edx
  800082:	77 c8                	ja     80004c <_main+0x14>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800084:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800088:	74 14                	je     80009e <_main+0x66>
  80008a:	83 ec 04             	sub    $0x4,%esp
  80008d:	68 60 34 80 00       	push   $0x803460
  800092:	6a 12                	push   $0x12
  800094:	68 7c 34 80 00       	push   $0x80347c
  800099:	e8 38 04 00 00       	call   8004d6 <_panic>
	}

	uint32 *x, *y, *z ;
	cprintf("STEP A: checking the creation of shared variables... \n");
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	68 94 34 80 00       	push   $0x803494
  8000a6:	e8 df 06 00 00       	call   80078a <cprintf>
  8000ab:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000ae:	e8 8f 1a 00 00       	call   801b42 <sys_calculate_free_frames>
  8000b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000b6:	83 ec 04             	sub    $0x4,%esp
  8000b9:	6a 01                	push   $0x1
  8000bb:	68 00 10 00 00       	push   $0x1000
  8000c0:	68 cb 34 80 00       	push   $0x8034cb
  8000c5:	e8 b5 17 00 00       	call   80187f <smalloc>
  8000ca:	83 c4 10             	add    $0x10,%esp
  8000cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8000d0:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000d7:	74 14                	je     8000ed <_main+0xb5>
  8000d9:	83 ec 04             	sub    $0x4,%esp
  8000dc:	68 d0 34 80 00       	push   $0x8034d0
  8000e1:	6a 1a                	push   $0x1a
  8000e3:	68 7c 34 80 00       	push   $0x80347c
  8000e8:	e8 e9 03 00 00       	call   8004d6 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  8000ed:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000f0:	e8 4d 1a 00 00       	call   801b42 <sys_calculate_free_frames>
  8000f5:	29 c3                	sub    %eax,%ebx
  8000f7:	89 d8                	mov    %ebx,%eax
  8000f9:	83 f8 04             	cmp    $0x4,%eax
  8000fc:	74 28                	je     800126 <_main+0xee>
  8000fe:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800101:	e8 3c 1a 00 00       	call   801b42 <sys_calculate_free_frames>
  800106:	29 c3                	sub    %eax,%ebx
  800108:	e8 35 1a 00 00       	call   801b42 <sys_calculate_free_frames>
  80010d:	83 ec 08             	sub    $0x8,%esp
  800110:	53                   	push   %ebx
  800111:	50                   	push   %eax
  800112:	ff 75 e8             	pushl  -0x18(%ebp)
  800115:	68 3c 35 80 00       	push   $0x80353c
  80011a:	6a 1b                	push   $0x1b
  80011c:	68 7c 34 80 00       	push   $0x80347c
  800121:	e8 b0 03 00 00       	call   8004d6 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800126:	e8 17 1a 00 00       	call   801b42 <sys_calculate_free_frames>
  80012b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		z = smalloc("y", PAGE_SIZE + 4, 1);
  80012e:	83 ec 04             	sub    $0x4,%esp
  800131:	6a 01                	push   $0x1
  800133:	68 04 10 00 00       	push   $0x1004
  800138:	68 c3 35 80 00       	push   $0x8035c3
  80013d:	e8 3d 17 00 00       	call   80187f <smalloc>
  800142:	83 c4 10             	add    $0x10,%esp
  800145:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (z != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800148:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  80014f:	74 14                	je     800165 <_main+0x12d>
  800151:	83 ec 04             	sub    $0x4,%esp
  800154:	68 d0 34 80 00       	push   $0x8034d0
  800159:	6a 1f                	push   $0x1f
  80015b:	68 7c 34 80 00       	push   $0x80347c
  800160:	e8 71 03 00 00       	call   8004d6 <_panic>

		if ((freeFrames - sys_calculate_free_frames()) !=  2+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  800165:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800168:	e8 d5 19 00 00       	call   801b42 <sys_calculate_free_frames>
  80016d:	29 c3                	sub    %eax,%ebx
  80016f:	89 d8                	mov    %ebx,%eax
  800171:	83 f8 04             	cmp    $0x4,%eax
  800174:	74 28                	je     80019e <_main+0x166>
  800176:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800179:	e8 c4 19 00 00       	call   801b42 <sys_calculate_free_frames>
  80017e:	29 c3                	sub    %eax,%ebx
  800180:	e8 bd 19 00 00       	call   801b42 <sys_calculate_free_frames>
  800185:	83 ec 08             	sub    $0x8,%esp
  800188:	53                   	push   %ebx
  800189:	50                   	push   %eax
  80018a:	ff 75 e8             	pushl  -0x18(%ebp)
  80018d:	68 3c 35 80 00       	push   $0x80353c
  800192:	6a 21                	push   $0x21
  800194:	68 7c 34 80 00       	push   $0x80347c
  800199:	e8 38 03 00 00       	call   8004d6 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80019e:	e8 9f 19 00 00       	call   801b42 <sys_calculate_free_frames>
  8001a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		y = smalloc("z", 4, 1);
  8001a6:	83 ec 04             	sub    $0x4,%esp
  8001a9:	6a 01                	push   $0x1
  8001ab:	6a 04                	push   $0x4
  8001ad:	68 c5 35 80 00       	push   $0x8035c5
  8001b2:	e8 c8 16 00 00       	call   80187f <smalloc>
  8001b7:	83 c4 10             	add    $0x10,%esp
  8001ba:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (y != (uint32*)(USER_HEAP_START + 3 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8001bd:	81 7d dc 00 30 00 80 	cmpl   $0x80003000,-0x24(%ebp)
  8001c4:	74 14                	je     8001da <_main+0x1a2>
  8001c6:	83 ec 04             	sub    $0x4,%esp
  8001c9:	68 d0 34 80 00       	push   $0x8034d0
  8001ce:	6a 25                	push   $0x25
  8001d0:	68 7c 34 80 00       	push   $0x80347c
  8001d5:	e8 fc 02 00 00       	call   8004d6 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001da:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8001dd:	e8 60 19 00 00       	call   801b42 <sys_calculate_free_frames>
  8001e2:	29 c3                	sub    %eax,%ebx
  8001e4:	89 d8                	mov    %ebx,%eax
  8001e6:	83 f8 03             	cmp    $0x3,%eax
  8001e9:	74 14                	je     8001ff <_main+0x1c7>
  8001eb:	83 ec 04             	sub    $0x4,%esp
  8001ee:	68 c8 35 80 00       	push   $0x8035c8
  8001f3:	6a 26                	push   $0x26
  8001f5:	68 7c 34 80 00       	push   $0x80347c
  8001fa:	e8 d7 02 00 00       	call   8004d6 <_panic>
	}
	cprintf("Step A is completed successfully!!\n\n\n");
  8001ff:	83 ec 0c             	sub    $0xc,%esp
  800202:	68 48 36 80 00       	push   $0x803648
  800207:	e8 7e 05 00 00       	call   80078a <cprintf>
  80020c:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking reading & writing... \n");
  80020f:	83 ec 0c             	sub    $0xc,%esp
  800212:	68 70 36 80 00       	push   $0x803670
  800217:	e8 6e 05 00 00       	call   80078a <cprintf>
  80021c:	83 c4 10             	add    $0x10,%esp
	{
		int i=0;
  80021f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<PAGE_SIZE/4;i++)
  800226:	eb 2d                	jmp    800255 <_main+0x21d>
		{
			x[i] = -1;
  800228:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80022b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800232:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800235:	01 d0                	add    %edx,%eax
  800237:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			y[i] = -1;
  80023d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800240:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800247:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80024a:	01 d0                	add    %edx,%eax
  80024c:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)


	cprintf("STEP B: checking reading & writing... \n");
	{
		int i=0;
		for(;i<PAGE_SIZE/4;i++)
  800252:	ff 45 ec             	incl   -0x14(%ebp)
  800255:	81 7d ec ff 03 00 00 	cmpl   $0x3ff,-0x14(%ebp)
  80025c:	7e ca                	jle    800228 <_main+0x1f0>
		{
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
  80025e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<2*PAGE_SIZE/4;i++)
  800265:	eb 18                	jmp    80027f <_main+0x247>
		{
			z[i] = -1;
  800267:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80026a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800271:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800274:	01 d0                	add    %edx,%eax
  800276:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
		for(;i<2*PAGE_SIZE/4;i++)
  80027c:	ff 45 ec             	incl   -0x14(%ebp)
  80027f:	81 7d ec ff 07 00 00 	cmpl   $0x7ff,-0x14(%ebp)
  800286:	7e df                	jle    800267 <_main+0x22f>
		{
			z[i] = -1;
		}

		if( x[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  800288:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80028b:	8b 00                	mov    (%eax),%eax
  80028d:	83 f8 ff             	cmp    $0xffffffff,%eax
  800290:	74 14                	je     8002a6 <_main+0x26e>
  800292:	83 ec 04             	sub    $0x4,%esp
  800295:	68 98 36 80 00       	push   $0x803698
  80029a:	6a 3a                	push   $0x3a
  80029c:	68 7c 34 80 00       	push   $0x80347c
  8002a1:	e8 30 02 00 00       	call   8004d6 <_panic>
		if( x[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a9:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002ae:	8b 00                	mov    (%eax),%eax
  8002b0:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002b3:	74 14                	je     8002c9 <_main+0x291>
  8002b5:	83 ec 04             	sub    $0x4,%esp
  8002b8:	68 98 36 80 00       	push   $0x803698
  8002bd:	6a 3b                	push   $0x3b
  8002bf:	68 7c 34 80 00       	push   $0x80347c
  8002c4:	e8 0d 02 00 00       	call   8004d6 <_panic>

		if( y[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  8002c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002cc:	8b 00                	mov    (%eax),%eax
  8002ce:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002d1:	74 14                	je     8002e7 <_main+0x2af>
  8002d3:	83 ec 04             	sub    $0x4,%esp
  8002d6:	68 98 36 80 00       	push   $0x803698
  8002db:	6a 3d                	push   $0x3d
  8002dd:	68 7c 34 80 00       	push   $0x80347c
  8002e2:	e8 ef 01 00 00       	call   8004d6 <_panic>
		if( y[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002ea:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002ef:	8b 00                	mov    (%eax),%eax
  8002f1:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002f4:	74 14                	je     80030a <_main+0x2d2>
  8002f6:	83 ec 04             	sub    $0x4,%esp
  8002f9:	68 98 36 80 00       	push   $0x803698
  8002fe:	6a 3e                	push   $0x3e
  800300:	68 7c 34 80 00       	push   $0x80347c
  800305:	e8 cc 01 00 00       	call   8004d6 <_panic>

		if( z[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  80030a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80030d:	8b 00                	mov    (%eax),%eax
  80030f:	83 f8 ff             	cmp    $0xffffffff,%eax
  800312:	74 14                	je     800328 <_main+0x2f0>
  800314:	83 ec 04             	sub    $0x4,%esp
  800317:	68 98 36 80 00       	push   $0x803698
  80031c:	6a 40                	push   $0x40
  80031e:	68 7c 34 80 00       	push   $0x80347c
  800323:	e8 ae 01 00 00       	call   8004d6 <_panic>
		if( z[2*PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  800328:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80032b:	05 fc 1f 00 00       	add    $0x1ffc,%eax
  800330:	8b 00                	mov    (%eax),%eax
  800332:	83 f8 ff             	cmp    $0xffffffff,%eax
  800335:	74 14                	je     80034b <_main+0x313>
  800337:	83 ec 04             	sub    $0x4,%esp
  80033a:	68 98 36 80 00       	push   $0x803698
  80033f:	6a 41                	push   $0x41
  800341:	68 7c 34 80 00       	push   $0x80347c
  800346:	e8 8b 01 00 00       	call   8004d6 <_panic>
	}

	cprintf("Congratulations!! Test of Shared Variables [Create] [1] completed successfully!!\n\n\n");
  80034b:	83 ec 0c             	sub    $0xc,%esp
  80034e:	68 c4 36 80 00       	push   $0x8036c4
  800353:	e8 32 04 00 00       	call   80078a <cprintf>
  800358:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  80035b:	e8 db 1a 00 00       	call   801e3b <sys_getparentenvid>
  800360:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if(parentenvID > 0)
  800363:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800367:	7e 2b                	jle    800394 <_main+0x35c>
	{
		//Get the check-finishing counter
		int *finishedCount = NULL;
  800369:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		finishedCount = sget(parentenvID, "finishedCount") ;
  800370:	83 ec 08             	sub    $0x8,%esp
  800373:	68 18 37 80 00       	push   $0x803718
  800378:	ff 75 d8             	pushl  -0x28(%ebp)
  80037b:	e8 9d 15 00 00       	call   80191d <sget>
  800380:	83 c4 10             	add    $0x10,%esp
  800383:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		(*finishedCount)++ ;
  800386:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800389:	8b 00                	mov    (%eax),%eax
  80038b:	8d 50 01             	lea    0x1(%eax),%edx
  80038e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800391:	89 10                	mov    %edx,(%eax)
	}

	return;
  800393:	90                   	nop
  800394:	90                   	nop
}
  800395:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800398:	c9                   	leave  
  800399:	c3                   	ret    

0080039a <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80039a:	55                   	push   %ebp
  80039b:	89 e5                	mov    %esp,%ebp
  80039d:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8003a0:	e8 7d 1a 00 00       	call   801e22 <sys_getenvindex>
  8003a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8003a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003ab:	89 d0                	mov    %edx,%eax
  8003ad:	c1 e0 03             	shl    $0x3,%eax
  8003b0:	01 d0                	add    %edx,%eax
  8003b2:	01 c0                	add    %eax,%eax
  8003b4:	01 d0                	add    %edx,%eax
  8003b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003bd:	01 d0                	add    %edx,%eax
  8003bf:	c1 e0 04             	shl    $0x4,%eax
  8003c2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003c7:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003cc:	a1 20 40 80 00       	mov    0x804020,%eax
  8003d1:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8003d7:	84 c0                	test   %al,%al
  8003d9:	74 0f                	je     8003ea <libmain+0x50>
		binaryname = myEnv->prog_name;
  8003db:	a1 20 40 80 00       	mov    0x804020,%eax
  8003e0:	05 5c 05 00 00       	add    $0x55c,%eax
  8003e5:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003ee:	7e 0a                	jle    8003fa <libmain+0x60>
		binaryname = argv[0];
  8003f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f3:	8b 00                	mov    (%eax),%eax
  8003f5:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8003fa:	83 ec 08             	sub    $0x8,%esp
  8003fd:	ff 75 0c             	pushl  0xc(%ebp)
  800400:	ff 75 08             	pushl  0x8(%ebp)
  800403:	e8 30 fc ff ff       	call   800038 <_main>
  800408:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80040b:	e8 1f 18 00 00       	call   801c2f <sys_disable_interrupt>
	cprintf("**************************************\n");
  800410:	83 ec 0c             	sub    $0xc,%esp
  800413:	68 40 37 80 00       	push   $0x803740
  800418:	e8 6d 03 00 00       	call   80078a <cprintf>
  80041d:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800420:	a1 20 40 80 00       	mov    0x804020,%eax
  800425:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80042b:	a1 20 40 80 00       	mov    0x804020,%eax
  800430:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800436:	83 ec 04             	sub    $0x4,%esp
  800439:	52                   	push   %edx
  80043a:	50                   	push   %eax
  80043b:	68 68 37 80 00       	push   $0x803768
  800440:	e8 45 03 00 00       	call   80078a <cprintf>
  800445:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800448:	a1 20 40 80 00       	mov    0x804020,%eax
  80044d:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800453:	a1 20 40 80 00       	mov    0x804020,%eax
  800458:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80045e:	a1 20 40 80 00       	mov    0x804020,%eax
  800463:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800469:	51                   	push   %ecx
  80046a:	52                   	push   %edx
  80046b:	50                   	push   %eax
  80046c:	68 90 37 80 00       	push   $0x803790
  800471:	e8 14 03 00 00       	call   80078a <cprintf>
  800476:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800479:	a1 20 40 80 00       	mov    0x804020,%eax
  80047e:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800484:	83 ec 08             	sub    $0x8,%esp
  800487:	50                   	push   %eax
  800488:	68 e8 37 80 00       	push   $0x8037e8
  80048d:	e8 f8 02 00 00       	call   80078a <cprintf>
  800492:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800495:	83 ec 0c             	sub    $0xc,%esp
  800498:	68 40 37 80 00       	push   $0x803740
  80049d:	e8 e8 02 00 00       	call   80078a <cprintf>
  8004a2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8004a5:	e8 9f 17 00 00       	call   801c49 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8004aa:	e8 19 00 00 00       	call   8004c8 <exit>
}
  8004af:	90                   	nop
  8004b0:	c9                   	leave  
  8004b1:	c3                   	ret    

008004b2 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8004b2:	55                   	push   %ebp
  8004b3:	89 e5                	mov    %esp,%ebp
  8004b5:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8004b8:	83 ec 0c             	sub    $0xc,%esp
  8004bb:	6a 00                	push   $0x0
  8004bd:	e8 2c 19 00 00       	call   801dee <sys_destroy_env>
  8004c2:	83 c4 10             	add    $0x10,%esp
}
  8004c5:	90                   	nop
  8004c6:	c9                   	leave  
  8004c7:	c3                   	ret    

008004c8 <exit>:

void
exit(void)
{
  8004c8:	55                   	push   %ebp
  8004c9:	89 e5                	mov    %esp,%ebp
  8004cb:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004ce:	e8 81 19 00 00       	call   801e54 <sys_exit_env>
}
  8004d3:	90                   	nop
  8004d4:	c9                   	leave  
  8004d5:	c3                   	ret    

008004d6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004d6:	55                   	push   %ebp
  8004d7:	89 e5                	mov    %esp,%ebp
  8004d9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004dc:	8d 45 10             	lea    0x10(%ebp),%eax
  8004df:	83 c0 04             	add    $0x4,%eax
  8004e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004e5:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8004ea:	85 c0                	test   %eax,%eax
  8004ec:	74 16                	je     800504 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004ee:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8004f3:	83 ec 08             	sub    $0x8,%esp
  8004f6:	50                   	push   %eax
  8004f7:	68 fc 37 80 00       	push   $0x8037fc
  8004fc:	e8 89 02 00 00       	call   80078a <cprintf>
  800501:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800504:	a1 00 40 80 00       	mov    0x804000,%eax
  800509:	ff 75 0c             	pushl  0xc(%ebp)
  80050c:	ff 75 08             	pushl  0x8(%ebp)
  80050f:	50                   	push   %eax
  800510:	68 01 38 80 00       	push   $0x803801
  800515:	e8 70 02 00 00       	call   80078a <cprintf>
  80051a:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80051d:	8b 45 10             	mov    0x10(%ebp),%eax
  800520:	83 ec 08             	sub    $0x8,%esp
  800523:	ff 75 f4             	pushl  -0xc(%ebp)
  800526:	50                   	push   %eax
  800527:	e8 f3 01 00 00       	call   80071f <vcprintf>
  80052c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80052f:	83 ec 08             	sub    $0x8,%esp
  800532:	6a 00                	push   $0x0
  800534:	68 1d 38 80 00       	push   $0x80381d
  800539:	e8 e1 01 00 00       	call   80071f <vcprintf>
  80053e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800541:	e8 82 ff ff ff       	call   8004c8 <exit>

	// should not return here
	while (1) ;
  800546:	eb fe                	jmp    800546 <_panic+0x70>

00800548 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800548:	55                   	push   %ebp
  800549:	89 e5                	mov    %esp,%ebp
  80054b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80054e:	a1 20 40 80 00       	mov    0x804020,%eax
  800553:	8b 50 74             	mov    0x74(%eax),%edx
  800556:	8b 45 0c             	mov    0xc(%ebp),%eax
  800559:	39 c2                	cmp    %eax,%edx
  80055b:	74 14                	je     800571 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80055d:	83 ec 04             	sub    $0x4,%esp
  800560:	68 20 38 80 00       	push   $0x803820
  800565:	6a 26                	push   $0x26
  800567:	68 6c 38 80 00       	push   $0x80386c
  80056c:	e8 65 ff ff ff       	call   8004d6 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800571:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800578:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80057f:	e9 c2 00 00 00       	jmp    800646 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800584:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800587:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80058e:	8b 45 08             	mov    0x8(%ebp),%eax
  800591:	01 d0                	add    %edx,%eax
  800593:	8b 00                	mov    (%eax),%eax
  800595:	85 c0                	test   %eax,%eax
  800597:	75 08                	jne    8005a1 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800599:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80059c:	e9 a2 00 00 00       	jmp    800643 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8005a1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005a8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005af:	eb 69                	jmp    80061a <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8005b1:	a1 20 40 80 00       	mov    0x804020,%eax
  8005b6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005bc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005bf:	89 d0                	mov    %edx,%eax
  8005c1:	01 c0                	add    %eax,%eax
  8005c3:	01 d0                	add    %edx,%eax
  8005c5:	c1 e0 03             	shl    $0x3,%eax
  8005c8:	01 c8                	add    %ecx,%eax
  8005ca:	8a 40 04             	mov    0x4(%eax),%al
  8005cd:	84 c0                	test   %al,%al
  8005cf:	75 46                	jne    800617 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005d1:	a1 20 40 80 00       	mov    0x804020,%eax
  8005d6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005dc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005df:	89 d0                	mov    %edx,%eax
  8005e1:	01 c0                	add    %eax,%eax
  8005e3:	01 d0                	add    %edx,%eax
  8005e5:	c1 e0 03             	shl    $0x3,%eax
  8005e8:	01 c8                	add    %ecx,%eax
  8005ea:	8b 00                	mov    (%eax),%eax
  8005ec:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005f7:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005fc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800603:	8b 45 08             	mov    0x8(%ebp),%eax
  800606:	01 c8                	add    %ecx,%eax
  800608:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80060a:	39 c2                	cmp    %eax,%edx
  80060c:	75 09                	jne    800617 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80060e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800615:	eb 12                	jmp    800629 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800617:	ff 45 e8             	incl   -0x18(%ebp)
  80061a:	a1 20 40 80 00       	mov    0x804020,%eax
  80061f:	8b 50 74             	mov    0x74(%eax),%edx
  800622:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800625:	39 c2                	cmp    %eax,%edx
  800627:	77 88                	ja     8005b1 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800629:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80062d:	75 14                	jne    800643 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80062f:	83 ec 04             	sub    $0x4,%esp
  800632:	68 78 38 80 00       	push   $0x803878
  800637:	6a 3a                	push   $0x3a
  800639:	68 6c 38 80 00       	push   $0x80386c
  80063e:	e8 93 fe ff ff       	call   8004d6 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800643:	ff 45 f0             	incl   -0x10(%ebp)
  800646:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800649:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80064c:	0f 8c 32 ff ff ff    	jl     800584 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800652:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800659:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800660:	eb 26                	jmp    800688 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800662:	a1 20 40 80 00       	mov    0x804020,%eax
  800667:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80066d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800670:	89 d0                	mov    %edx,%eax
  800672:	01 c0                	add    %eax,%eax
  800674:	01 d0                	add    %edx,%eax
  800676:	c1 e0 03             	shl    $0x3,%eax
  800679:	01 c8                	add    %ecx,%eax
  80067b:	8a 40 04             	mov    0x4(%eax),%al
  80067e:	3c 01                	cmp    $0x1,%al
  800680:	75 03                	jne    800685 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800682:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800685:	ff 45 e0             	incl   -0x20(%ebp)
  800688:	a1 20 40 80 00       	mov    0x804020,%eax
  80068d:	8b 50 74             	mov    0x74(%eax),%edx
  800690:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800693:	39 c2                	cmp    %eax,%edx
  800695:	77 cb                	ja     800662 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80069a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80069d:	74 14                	je     8006b3 <CheckWSWithoutLastIndex+0x16b>
		panic(
  80069f:	83 ec 04             	sub    $0x4,%esp
  8006a2:	68 cc 38 80 00       	push   $0x8038cc
  8006a7:	6a 44                	push   $0x44
  8006a9:	68 6c 38 80 00       	push   $0x80386c
  8006ae:	e8 23 fe ff ff       	call   8004d6 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8006b3:	90                   	nop
  8006b4:	c9                   	leave  
  8006b5:	c3                   	ret    

008006b6 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8006b6:	55                   	push   %ebp
  8006b7:	89 e5                	mov    %esp,%ebp
  8006b9:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006bf:	8b 00                	mov    (%eax),%eax
  8006c1:	8d 48 01             	lea    0x1(%eax),%ecx
  8006c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006c7:	89 0a                	mov    %ecx,(%edx)
  8006c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8006cc:	88 d1                	mov    %dl,%cl
  8006ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006d1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d8:	8b 00                	mov    (%eax),%eax
  8006da:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006df:	75 2c                	jne    80070d <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006e1:	a0 24 40 80 00       	mov    0x804024,%al
  8006e6:	0f b6 c0             	movzbl %al,%eax
  8006e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006ec:	8b 12                	mov    (%edx),%edx
  8006ee:	89 d1                	mov    %edx,%ecx
  8006f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006f3:	83 c2 08             	add    $0x8,%edx
  8006f6:	83 ec 04             	sub    $0x4,%esp
  8006f9:	50                   	push   %eax
  8006fa:	51                   	push   %ecx
  8006fb:	52                   	push   %edx
  8006fc:	e8 80 13 00 00       	call   801a81 <sys_cputs>
  800701:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800704:	8b 45 0c             	mov    0xc(%ebp),%eax
  800707:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80070d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800710:	8b 40 04             	mov    0x4(%eax),%eax
  800713:	8d 50 01             	lea    0x1(%eax),%edx
  800716:	8b 45 0c             	mov    0xc(%ebp),%eax
  800719:	89 50 04             	mov    %edx,0x4(%eax)
}
  80071c:	90                   	nop
  80071d:	c9                   	leave  
  80071e:	c3                   	ret    

0080071f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80071f:	55                   	push   %ebp
  800720:	89 e5                	mov    %esp,%ebp
  800722:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800728:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80072f:	00 00 00 
	b.cnt = 0;
  800732:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800739:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80073c:	ff 75 0c             	pushl  0xc(%ebp)
  80073f:	ff 75 08             	pushl  0x8(%ebp)
  800742:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800748:	50                   	push   %eax
  800749:	68 b6 06 80 00       	push   $0x8006b6
  80074e:	e8 11 02 00 00       	call   800964 <vprintfmt>
  800753:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800756:	a0 24 40 80 00       	mov    0x804024,%al
  80075b:	0f b6 c0             	movzbl %al,%eax
  80075e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800764:	83 ec 04             	sub    $0x4,%esp
  800767:	50                   	push   %eax
  800768:	52                   	push   %edx
  800769:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80076f:	83 c0 08             	add    $0x8,%eax
  800772:	50                   	push   %eax
  800773:	e8 09 13 00 00       	call   801a81 <sys_cputs>
  800778:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80077b:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800782:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800788:	c9                   	leave  
  800789:	c3                   	ret    

0080078a <cprintf>:

int cprintf(const char *fmt, ...) {
  80078a:	55                   	push   %ebp
  80078b:	89 e5                	mov    %esp,%ebp
  80078d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800790:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800797:	8d 45 0c             	lea    0xc(%ebp),%eax
  80079a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80079d:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a0:	83 ec 08             	sub    $0x8,%esp
  8007a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8007a6:	50                   	push   %eax
  8007a7:	e8 73 ff ff ff       	call   80071f <vcprintf>
  8007ac:	83 c4 10             	add    $0x10,%esp
  8007af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007b5:	c9                   	leave  
  8007b6:	c3                   	ret    

008007b7 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8007b7:	55                   	push   %ebp
  8007b8:	89 e5                	mov    %esp,%ebp
  8007ba:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007bd:	e8 6d 14 00 00       	call   801c2f <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007c2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cb:	83 ec 08             	sub    $0x8,%esp
  8007ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8007d1:	50                   	push   %eax
  8007d2:	e8 48 ff ff ff       	call   80071f <vcprintf>
  8007d7:	83 c4 10             	add    $0x10,%esp
  8007da:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007dd:	e8 67 14 00 00       	call   801c49 <sys_enable_interrupt>
	return cnt;
  8007e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007e5:	c9                   	leave  
  8007e6:	c3                   	ret    

008007e7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007e7:	55                   	push   %ebp
  8007e8:	89 e5                	mov    %esp,%ebp
  8007ea:	53                   	push   %ebx
  8007eb:	83 ec 14             	sub    $0x14,%esp
  8007ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007fa:	8b 45 18             	mov    0x18(%ebp),%eax
  8007fd:	ba 00 00 00 00       	mov    $0x0,%edx
  800802:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800805:	77 55                	ja     80085c <printnum+0x75>
  800807:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80080a:	72 05                	jb     800811 <printnum+0x2a>
  80080c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80080f:	77 4b                	ja     80085c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800811:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800814:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800817:	8b 45 18             	mov    0x18(%ebp),%eax
  80081a:	ba 00 00 00 00       	mov    $0x0,%edx
  80081f:	52                   	push   %edx
  800820:	50                   	push   %eax
  800821:	ff 75 f4             	pushl  -0xc(%ebp)
  800824:	ff 75 f0             	pushl  -0x10(%ebp)
  800827:	e8 d0 29 00 00       	call   8031fc <__udivdi3>
  80082c:	83 c4 10             	add    $0x10,%esp
  80082f:	83 ec 04             	sub    $0x4,%esp
  800832:	ff 75 20             	pushl  0x20(%ebp)
  800835:	53                   	push   %ebx
  800836:	ff 75 18             	pushl  0x18(%ebp)
  800839:	52                   	push   %edx
  80083a:	50                   	push   %eax
  80083b:	ff 75 0c             	pushl  0xc(%ebp)
  80083e:	ff 75 08             	pushl  0x8(%ebp)
  800841:	e8 a1 ff ff ff       	call   8007e7 <printnum>
  800846:	83 c4 20             	add    $0x20,%esp
  800849:	eb 1a                	jmp    800865 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80084b:	83 ec 08             	sub    $0x8,%esp
  80084e:	ff 75 0c             	pushl  0xc(%ebp)
  800851:	ff 75 20             	pushl  0x20(%ebp)
  800854:	8b 45 08             	mov    0x8(%ebp),%eax
  800857:	ff d0                	call   *%eax
  800859:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80085c:	ff 4d 1c             	decl   0x1c(%ebp)
  80085f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800863:	7f e6                	jg     80084b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800865:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800868:	bb 00 00 00 00       	mov    $0x0,%ebx
  80086d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800870:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800873:	53                   	push   %ebx
  800874:	51                   	push   %ecx
  800875:	52                   	push   %edx
  800876:	50                   	push   %eax
  800877:	e8 90 2a 00 00       	call   80330c <__umoddi3>
  80087c:	83 c4 10             	add    $0x10,%esp
  80087f:	05 34 3b 80 00       	add    $0x803b34,%eax
  800884:	8a 00                	mov    (%eax),%al
  800886:	0f be c0             	movsbl %al,%eax
  800889:	83 ec 08             	sub    $0x8,%esp
  80088c:	ff 75 0c             	pushl  0xc(%ebp)
  80088f:	50                   	push   %eax
  800890:	8b 45 08             	mov    0x8(%ebp),%eax
  800893:	ff d0                	call   *%eax
  800895:	83 c4 10             	add    $0x10,%esp
}
  800898:	90                   	nop
  800899:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80089c:	c9                   	leave  
  80089d:	c3                   	ret    

0080089e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80089e:	55                   	push   %ebp
  80089f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008a1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008a5:	7e 1c                	jle    8008c3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	8b 00                	mov    (%eax),%eax
  8008ac:	8d 50 08             	lea    0x8(%eax),%edx
  8008af:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b2:	89 10                	mov    %edx,(%eax)
  8008b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b7:	8b 00                	mov    (%eax),%eax
  8008b9:	83 e8 08             	sub    $0x8,%eax
  8008bc:	8b 50 04             	mov    0x4(%eax),%edx
  8008bf:	8b 00                	mov    (%eax),%eax
  8008c1:	eb 40                	jmp    800903 <getuint+0x65>
	else if (lflag)
  8008c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008c7:	74 1e                	je     8008e7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cc:	8b 00                	mov    (%eax),%eax
  8008ce:	8d 50 04             	lea    0x4(%eax),%edx
  8008d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d4:	89 10                	mov    %edx,(%eax)
  8008d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d9:	8b 00                	mov    (%eax),%eax
  8008db:	83 e8 04             	sub    $0x4,%eax
  8008de:	8b 00                	mov    (%eax),%eax
  8008e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e5:	eb 1c                	jmp    800903 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ea:	8b 00                	mov    (%eax),%eax
  8008ec:	8d 50 04             	lea    0x4(%eax),%edx
  8008ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f2:	89 10                	mov    %edx,(%eax)
  8008f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f7:	8b 00                	mov    (%eax),%eax
  8008f9:	83 e8 04             	sub    $0x4,%eax
  8008fc:	8b 00                	mov    (%eax),%eax
  8008fe:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800903:	5d                   	pop    %ebp
  800904:	c3                   	ret    

00800905 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800905:	55                   	push   %ebp
  800906:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800908:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80090c:	7e 1c                	jle    80092a <getint+0x25>
		return va_arg(*ap, long long);
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	8b 00                	mov    (%eax),%eax
  800913:	8d 50 08             	lea    0x8(%eax),%edx
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	89 10                	mov    %edx,(%eax)
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	8b 00                	mov    (%eax),%eax
  800920:	83 e8 08             	sub    $0x8,%eax
  800923:	8b 50 04             	mov    0x4(%eax),%edx
  800926:	8b 00                	mov    (%eax),%eax
  800928:	eb 38                	jmp    800962 <getint+0x5d>
	else if (lflag)
  80092a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80092e:	74 1a                	je     80094a <getint+0x45>
		return va_arg(*ap, long);
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	8b 00                	mov    (%eax),%eax
  800935:	8d 50 04             	lea    0x4(%eax),%edx
  800938:	8b 45 08             	mov    0x8(%ebp),%eax
  80093b:	89 10                	mov    %edx,(%eax)
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	8b 00                	mov    (%eax),%eax
  800942:	83 e8 04             	sub    $0x4,%eax
  800945:	8b 00                	mov    (%eax),%eax
  800947:	99                   	cltd   
  800948:	eb 18                	jmp    800962 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80094a:	8b 45 08             	mov    0x8(%ebp),%eax
  80094d:	8b 00                	mov    (%eax),%eax
  80094f:	8d 50 04             	lea    0x4(%eax),%edx
  800952:	8b 45 08             	mov    0x8(%ebp),%eax
  800955:	89 10                	mov    %edx,(%eax)
  800957:	8b 45 08             	mov    0x8(%ebp),%eax
  80095a:	8b 00                	mov    (%eax),%eax
  80095c:	83 e8 04             	sub    $0x4,%eax
  80095f:	8b 00                	mov    (%eax),%eax
  800961:	99                   	cltd   
}
  800962:	5d                   	pop    %ebp
  800963:	c3                   	ret    

00800964 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800964:	55                   	push   %ebp
  800965:	89 e5                	mov    %esp,%ebp
  800967:	56                   	push   %esi
  800968:	53                   	push   %ebx
  800969:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80096c:	eb 17                	jmp    800985 <vprintfmt+0x21>
			if (ch == '\0')
  80096e:	85 db                	test   %ebx,%ebx
  800970:	0f 84 af 03 00 00    	je     800d25 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800976:	83 ec 08             	sub    $0x8,%esp
  800979:	ff 75 0c             	pushl  0xc(%ebp)
  80097c:	53                   	push   %ebx
  80097d:	8b 45 08             	mov    0x8(%ebp),%eax
  800980:	ff d0                	call   *%eax
  800982:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800985:	8b 45 10             	mov    0x10(%ebp),%eax
  800988:	8d 50 01             	lea    0x1(%eax),%edx
  80098b:	89 55 10             	mov    %edx,0x10(%ebp)
  80098e:	8a 00                	mov    (%eax),%al
  800990:	0f b6 d8             	movzbl %al,%ebx
  800993:	83 fb 25             	cmp    $0x25,%ebx
  800996:	75 d6                	jne    80096e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800998:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80099c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009a3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009aa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009b1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8009bb:	8d 50 01             	lea    0x1(%eax),%edx
  8009be:	89 55 10             	mov    %edx,0x10(%ebp)
  8009c1:	8a 00                	mov    (%eax),%al
  8009c3:	0f b6 d8             	movzbl %al,%ebx
  8009c6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009c9:	83 f8 55             	cmp    $0x55,%eax
  8009cc:	0f 87 2b 03 00 00    	ja     800cfd <vprintfmt+0x399>
  8009d2:	8b 04 85 58 3b 80 00 	mov    0x803b58(,%eax,4),%eax
  8009d9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009db:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009df:	eb d7                	jmp    8009b8 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009e1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009e5:	eb d1                	jmp    8009b8 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009e7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009ee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009f1:	89 d0                	mov    %edx,%eax
  8009f3:	c1 e0 02             	shl    $0x2,%eax
  8009f6:	01 d0                	add    %edx,%eax
  8009f8:	01 c0                	add    %eax,%eax
  8009fa:	01 d8                	add    %ebx,%eax
  8009fc:	83 e8 30             	sub    $0x30,%eax
  8009ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a02:	8b 45 10             	mov    0x10(%ebp),%eax
  800a05:	8a 00                	mov    (%eax),%al
  800a07:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a0a:	83 fb 2f             	cmp    $0x2f,%ebx
  800a0d:	7e 3e                	jle    800a4d <vprintfmt+0xe9>
  800a0f:	83 fb 39             	cmp    $0x39,%ebx
  800a12:	7f 39                	jg     800a4d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a14:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a17:	eb d5                	jmp    8009ee <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a19:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1c:	83 c0 04             	add    $0x4,%eax
  800a1f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a22:	8b 45 14             	mov    0x14(%ebp),%eax
  800a25:	83 e8 04             	sub    $0x4,%eax
  800a28:	8b 00                	mov    (%eax),%eax
  800a2a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a2d:	eb 1f                	jmp    800a4e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a2f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a33:	79 83                	jns    8009b8 <vprintfmt+0x54>
				width = 0;
  800a35:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a3c:	e9 77 ff ff ff       	jmp    8009b8 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a41:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a48:	e9 6b ff ff ff       	jmp    8009b8 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a4d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a4e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a52:	0f 89 60 ff ff ff    	jns    8009b8 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a58:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a5b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a5e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a65:	e9 4e ff ff ff       	jmp    8009b8 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a6a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a6d:	e9 46 ff ff ff       	jmp    8009b8 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a72:	8b 45 14             	mov    0x14(%ebp),%eax
  800a75:	83 c0 04             	add    $0x4,%eax
  800a78:	89 45 14             	mov    %eax,0x14(%ebp)
  800a7b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7e:	83 e8 04             	sub    $0x4,%eax
  800a81:	8b 00                	mov    (%eax),%eax
  800a83:	83 ec 08             	sub    $0x8,%esp
  800a86:	ff 75 0c             	pushl  0xc(%ebp)
  800a89:	50                   	push   %eax
  800a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8d:	ff d0                	call   *%eax
  800a8f:	83 c4 10             	add    $0x10,%esp
			break;
  800a92:	e9 89 02 00 00       	jmp    800d20 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a97:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9a:	83 c0 04             	add    $0x4,%eax
  800a9d:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa0:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa3:	83 e8 04             	sub    $0x4,%eax
  800aa6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800aa8:	85 db                	test   %ebx,%ebx
  800aaa:	79 02                	jns    800aae <vprintfmt+0x14a>
				err = -err;
  800aac:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800aae:	83 fb 64             	cmp    $0x64,%ebx
  800ab1:	7f 0b                	jg     800abe <vprintfmt+0x15a>
  800ab3:	8b 34 9d a0 39 80 00 	mov    0x8039a0(,%ebx,4),%esi
  800aba:	85 f6                	test   %esi,%esi
  800abc:	75 19                	jne    800ad7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800abe:	53                   	push   %ebx
  800abf:	68 45 3b 80 00       	push   $0x803b45
  800ac4:	ff 75 0c             	pushl  0xc(%ebp)
  800ac7:	ff 75 08             	pushl  0x8(%ebp)
  800aca:	e8 5e 02 00 00       	call   800d2d <printfmt>
  800acf:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ad2:	e9 49 02 00 00       	jmp    800d20 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ad7:	56                   	push   %esi
  800ad8:	68 4e 3b 80 00       	push   $0x803b4e
  800add:	ff 75 0c             	pushl  0xc(%ebp)
  800ae0:	ff 75 08             	pushl  0x8(%ebp)
  800ae3:	e8 45 02 00 00       	call   800d2d <printfmt>
  800ae8:	83 c4 10             	add    $0x10,%esp
			break;
  800aeb:	e9 30 02 00 00       	jmp    800d20 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800af0:	8b 45 14             	mov    0x14(%ebp),%eax
  800af3:	83 c0 04             	add    $0x4,%eax
  800af6:	89 45 14             	mov    %eax,0x14(%ebp)
  800af9:	8b 45 14             	mov    0x14(%ebp),%eax
  800afc:	83 e8 04             	sub    $0x4,%eax
  800aff:	8b 30                	mov    (%eax),%esi
  800b01:	85 f6                	test   %esi,%esi
  800b03:	75 05                	jne    800b0a <vprintfmt+0x1a6>
				p = "(null)";
  800b05:	be 51 3b 80 00       	mov    $0x803b51,%esi
			if (width > 0 && padc != '-')
  800b0a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b0e:	7e 6d                	jle    800b7d <vprintfmt+0x219>
  800b10:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b14:	74 67                	je     800b7d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b16:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b19:	83 ec 08             	sub    $0x8,%esp
  800b1c:	50                   	push   %eax
  800b1d:	56                   	push   %esi
  800b1e:	e8 0c 03 00 00       	call   800e2f <strnlen>
  800b23:	83 c4 10             	add    $0x10,%esp
  800b26:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b29:	eb 16                	jmp    800b41 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b2b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b2f:	83 ec 08             	sub    $0x8,%esp
  800b32:	ff 75 0c             	pushl  0xc(%ebp)
  800b35:	50                   	push   %eax
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	ff d0                	call   *%eax
  800b3b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b3e:	ff 4d e4             	decl   -0x1c(%ebp)
  800b41:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b45:	7f e4                	jg     800b2b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b47:	eb 34                	jmp    800b7d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b49:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b4d:	74 1c                	je     800b6b <vprintfmt+0x207>
  800b4f:	83 fb 1f             	cmp    $0x1f,%ebx
  800b52:	7e 05                	jle    800b59 <vprintfmt+0x1f5>
  800b54:	83 fb 7e             	cmp    $0x7e,%ebx
  800b57:	7e 12                	jle    800b6b <vprintfmt+0x207>
					putch('?', putdat);
  800b59:	83 ec 08             	sub    $0x8,%esp
  800b5c:	ff 75 0c             	pushl  0xc(%ebp)
  800b5f:	6a 3f                	push   $0x3f
  800b61:	8b 45 08             	mov    0x8(%ebp),%eax
  800b64:	ff d0                	call   *%eax
  800b66:	83 c4 10             	add    $0x10,%esp
  800b69:	eb 0f                	jmp    800b7a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b6b:	83 ec 08             	sub    $0x8,%esp
  800b6e:	ff 75 0c             	pushl  0xc(%ebp)
  800b71:	53                   	push   %ebx
  800b72:	8b 45 08             	mov    0x8(%ebp),%eax
  800b75:	ff d0                	call   *%eax
  800b77:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b7a:	ff 4d e4             	decl   -0x1c(%ebp)
  800b7d:	89 f0                	mov    %esi,%eax
  800b7f:	8d 70 01             	lea    0x1(%eax),%esi
  800b82:	8a 00                	mov    (%eax),%al
  800b84:	0f be d8             	movsbl %al,%ebx
  800b87:	85 db                	test   %ebx,%ebx
  800b89:	74 24                	je     800baf <vprintfmt+0x24b>
  800b8b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b8f:	78 b8                	js     800b49 <vprintfmt+0x1e5>
  800b91:	ff 4d e0             	decl   -0x20(%ebp)
  800b94:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b98:	79 af                	jns    800b49 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b9a:	eb 13                	jmp    800baf <vprintfmt+0x24b>
				putch(' ', putdat);
  800b9c:	83 ec 08             	sub    $0x8,%esp
  800b9f:	ff 75 0c             	pushl  0xc(%ebp)
  800ba2:	6a 20                	push   $0x20
  800ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba7:	ff d0                	call   *%eax
  800ba9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bac:	ff 4d e4             	decl   -0x1c(%ebp)
  800baf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bb3:	7f e7                	jg     800b9c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bb5:	e9 66 01 00 00       	jmp    800d20 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bba:	83 ec 08             	sub    $0x8,%esp
  800bbd:	ff 75 e8             	pushl  -0x18(%ebp)
  800bc0:	8d 45 14             	lea    0x14(%ebp),%eax
  800bc3:	50                   	push   %eax
  800bc4:	e8 3c fd ff ff       	call   800905 <getint>
  800bc9:	83 c4 10             	add    $0x10,%esp
  800bcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bcf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bd8:	85 d2                	test   %edx,%edx
  800bda:	79 23                	jns    800bff <vprintfmt+0x29b>
				putch('-', putdat);
  800bdc:	83 ec 08             	sub    $0x8,%esp
  800bdf:	ff 75 0c             	pushl  0xc(%ebp)
  800be2:	6a 2d                	push   $0x2d
  800be4:	8b 45 08             	mov    0x8(%ebp),%eax
  800be7:	ff d0                	call   *%eax
  800be9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bf2:	f7 d8                	neg    %eax
  800bf4:	83 d2 00             	adc    $0x0,%edx
  800bf7:	f7 da                	neg    %edx
  800bf9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bfc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bff:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c06:	e9 bc 00 00 00       	jmp    800cc7 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c0b:	83 ec 08             	sub    $0x8,%esp
  800c0e:	ff 75 e8             	pushl  -0x18(%ebp)
  800c11:	8d 45 14             	lea    0x14(%ebp),%eax
  800c14:	50                   	push   %eax
  800c15:	e8 84 fc ff ff       	call   80089e <getuint>
  800c1a:	83 c4 10             	add    $0x10,%esp
  800c1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c20:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c23:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c2a:	e9 98 00 00 00       	jmp    800cc7 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c2f:	83 ec 08             	sub    $0x8,%esp
  800c32:	ff 75 0c             	pushl  0xc(%ebp)
  800c35:	6a 58                	push   $0x58
  800c37:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3a:	ff d0                	call   *%eax
  800c3c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c3f:	83 ec 08             	sub    $0x8,%esp
  800c42:	ff 75 0c             	pushl  0xc(%ebp)
  800c45:	6a 58                	push   $0x58
  800c47:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4a:	ff d0                	call   *%eax
  800c4c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c4f:	83 ec 08             	sub    $0x8,%esp
  800c52:	ff 75 0c             	pushl  0xc(%ebp)
  800c55:	6a 58                	push   $0x58
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	ff d0                	call   *%eax
  800c5c:	83 c4 10             	add    $0x10,%esp
			break;
  800c5f:	e9 bc 00 00 00       	jmp    800d20 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c64:	83 ec 08             	sub    $0x8,%esp
  800c67:	ff 75 0c             	pushl  0xc(%ebp)
  800c6a:	6a 30                	push   $0x30
  800c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6f:	ff d0                	call   *%eax
  800c71:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c74:	83 ec 08             	sub    $0x8,%esp
  800c77:	ff 75 0c             	pushl  0xc(%ebp)
  800c7a:	6a 78                	push   $0x78
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	ff d0                	call   *%eax
  800c81:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c84:	8b 45 14             	mov    0x14(%ebp),%eax
  800c87:	83 c0 04             	add    $0x4,%eax
  800c8a:	89 45 14             	mov    %eax,0x14(%ebp)
  800c8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c90:	83 e8 04             	sub    $0x4,%eax
  800c93:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c95:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c9f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ca6:	eb 1f                	jmp    800cc7 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ca8:	83 ec 08             	sub    $0x8,%esp
  800cab:	ff 75 e8             	pushl  -0x18(%ebp)
  800cae:	8d 45 14             	lea    0x14(%ebp),%eax
  800cb1:	50                   	push   %eax
  800cb2:	e8 e7 fb ff ff       	call   80089e <getuint>
  800cb7:	83 c4 10             	add    $0x10,%esp
  800cba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cbd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cc0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cc7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ccb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cce:	83 ec 04             	sub    $0x4,%esp
  800cd1:	52                   	push   %edx
  800cd2:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cd5:	50                   	push   %eax
  800cd6:	ff 75 f4             	pushl  -0xc(%ebp)
  800cd9:	ff 75 f0             	pushl  -0x10(%ebp)
  800cdc:	ff 75 0c             	pushl  0xc(%ebp)
  800cdf:	ff 75 08             	pushl  0x8(%ebp)
  800ce2:	e8 00 fb ff ff       	call   8007e7 <printnum>
  800ce7:	83 c4 20             	add    $0x20,%esp
			break;
  800cea:	eb 34                	jmp    800d20 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cec:	83 ec 08             	sub    $0x8,%esp
  800cef:	ff 75 0c             	pushl  0xc(%ebp)
  800cf2:	53                   	push   %ebx
  800cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf6:	ff d0                	call   *%eax
  800cf8:	83 c4 10             	add    $0x10,%esp
			break;
  800cfb:	eb 23                	jmp    800d20 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cfd:	83 ec 08             	sub    $0x8,%esp
  800d00:	ff 75 0c             	pushl  0xc(%ebp)
  800d03:	6a 25                	push   $0x25
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	ff d0                	call   *%eax
  800d0a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d0d:	ff 4d 10             	decl   0x10(%ebp)
  800d10:	eb 03                	jmp    800d15 <vprintfmt+0x3b1>
  800d12:	ff 4d 10             	decl   0x10(%ebp)
  800d15:	8b 45 10             	mov    0x10(%ebp),%eax
  800d18:	48                   	dec    %eax
  800d19:	8a 00                	mov    (%eax),%al
  800d1b:	3c 25                	cmp    $0x25,%al
  800d1d:	75 f3                	jne    800d12 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d1f:	90                   	nop
		}
	}
  800d20:	e9 47 fc ff ff       	jmp    80096c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d25:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d26:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d29:	5b                   	pop    %ebx
  800d2a:	5e                   	pop    %esi
  800d2b:	5d                   	pop    %ebp
  800d2c:	c3                   	ret    

00800d2d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d2d:	55                   	push   %ebp
  800d2e:	89 e5                	mov    %esp,%ebp
  800d30:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d33:	8d 45 10             	lea    0x10(%ebp),%eax
  800d36:	83 c0 04             	add    $0x4,%eax
  800d39:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d3c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3f:	ff 75 f4             	pushl  -0xc(%ebp)
  800d42:	50                   	push   %eax
  800d43:	ff 75 0c             	pushl  0xc(%ebp)
  800d46:	ff 75 08             	pushl  0x8(%ebp)
  800d49:	e8 16 fc ff ff       	call   800964 <vprintfmt>
  800d4e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d51:	90                   	nop
  800d52:	c9                   	leave  
  800d53:	c3                   	ret    

00800d54 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d54:	55                   	push   %ebp
  800d55:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5a:	8b 40 08             	mov    0x8(%eax),%eax
  800d5d:	8d 50 01             	lea    0x1(%eax),%edx
  800d60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d63:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d69:	8b 10                	mov    (%eax),%edx
  800d6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6e:	8b 40 04             	mov    0x4(%eax),%eax
  800d71:	39 c2                	cmp    %eax,%edx
  800d73:	73 12                	jae    800d87 <sprintputch+0x33>
		*b->buf++ = ch;
  800d75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d78:	8b 00                	mov    (%eax),%eax
  800d7a:	8d 48 01             	lea    0x1(%eax),%ecx
  800d7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d80:	89 0a                	mov    %ecx,(%edx)
  800d82:	8b 55 08             	mov    0x8(%ebp),%edx
  800d85:	88 10                	mov    %dl,(%eax)
}
  800d87:	90                   	nop
  800d88:	5d                   	pop    %ebp
  800d89:	c3                   	ret    

00800d8a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d8a:	55                   	push   %ebp
  800d8b:	89 e5                	mov    %esp,%ebp
  800d8d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
  800d93:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d99:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9f:	01 d0                	add    %edx,%eax
  800da1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800da4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800daf:	74 06                	je     800db7 <vsnprintf+0x2d>
  800db1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800db5:	7f 07                	jg     800dbe <vsnprintf+0x34>
		return -E_INVAL;
  800db7:	b8 03 00 00 00       	mov    $0x3,%eax
  800dbc:	eb 20                	jmp    800dde <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dbe:	ff 75 14             	pushl  0x14(%ebp)
  800dc1:	ff 75 10             	pushl  0x10(%ebp)
  800dc4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dc7:	50                   	push   %eax
  800dc8:	68 54 0d 80 00       	push   $0x800d54
  800dcd:	e8 92 fb ff ff       	call   800964 <vprintfmt>
  800dd2:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dd8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dde:	c9                   	leave  
  800ddf:	c3                   	ret    

00800de0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800de0:	55                   	push   %ebp
  800de1:	89 e5                	mov    %esp,%ebp
  800de3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800de6:	8d 45 10             	lea    0x10(%ebp),%eax
  800de9:	83 c0 04             	add    $0x4,%eax
  800dec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800def:	8b 45 10             	mov    0x10(%ebp),%eax
  800df2:	ff 75 f4             	pushl  -0xc(%ebp)
  800df5:	50                   	push   %eax
  800df6:	ff 75 0c             	pushl  0xc(%ebp)
  800df9:	ff 75 08             	pushl  0x8(%ebp)
  800dfc:	e8 89 ff ff ff       	call   800d8a <vsnprintf>
  800e01:	83 c4 10             	add    $0x10,%esp
  800e04:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e07:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e0a:	c9                   	leave  
  800e0b:	c3                   	ret    

00800e0c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e0c:	55                   	push   %ebp
  800e0d:	89 e5                	mov    %esp,%ebp
  800e0f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e12:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e19:	eb 06                	jmp    800e21 <strlen+0x15>
		n++;
  800e1b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e1e:	ff 45 08             	incl   0x8(%ebp)
  800e21:	8b 45 08             	mov    0x8(%ebp),%eax
  800e24:	8a 00                	mov    (%eax),%al
  800e26:	84 c0                	test   %al,%al
  800e28:	75 f1                	jne    800e1b <strlen+0xf>
		n++;
	return n;
  800e2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e2d:	c9                   	leave  
  800e2e:	c3                   	ret    

00800e2f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e2f:	55                   	push   %ebp
  800e30:	89 e5                	mov    %esp,%ebp
  800e32:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e35:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e3c:	eb 09                	jmp    800e47 <strnlen+0x18>
		n++;
  800e3e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e41:	ff 45 08             	incl   0x8(%ebp)
  800e44:	ff 4d 0c             	decl   0xc(%ebp)
  800e47:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e4b:	74 09                	je     800e56 <strnlen+0x27>
  800e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e50:	8a 00                	mov    (%eax),%al
  800e52:	84 c0                	test   %al,%al
  800e54:	75 e8                	jne    800e3e <strnlen+0xf>
		n++;
	return n;
  800e56:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e59:	c9                   	leave  
  800e5a:	c3                   	ret    

00800e5b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e5b:	55                   	push   %ebp
  800e5c:	89 e5                	mov    %esp,%ebp
  800e5e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e61:	8b 45 08             	mov    0x8(%ebp),%eax
  800e64:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e67:	90                   	nop
  800e68:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6b:	8d 50 01             	lea    0x1(%eax),%edx
  800e6e:	89 55 08             	mov    %edx,0x8(%ebp)
  800e71:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e74:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e77:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e7a:	8a 12                	mov    (%edx),%dl
  800e7c:	88 10                	mov    %dl,(%eax)
  800e7e:	8a 00                	mov    (%eax),%al
  800e80:	84 c0                	test   %al,%al
  800e82:	75 e4                	jne    800e68 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e84:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e87:	c9                   	leave  
  800e88:	c3                   	ret    

00800e89 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e89:	55                   	push   %ebp
  800e8a:	89 e5                	mov    %esp,%ebp
  800e8c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e92:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e95:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e9c:	eb 1f                	jmp    800ebd <strncpy+0x34>
		*dst++ = *src;
  800e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea1:	8d 50 01             	lea    0x1(%eax),%edx
  800ea4:	89 55 08             	mov    %edx,0x8(%ebp)
  800ea7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eaa:	8a 12                	mov    (%edx),%dl
  800eac:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800eae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb1:	8a 00                	mov    (%eax),%al
  800eb3:	84 c0                	test   %al,%al
  800eb5:	74 03                	je     800eba <strncpy+0x31>
			src++;
  800eb7:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800eba:	ff 45 fc             	incl   -0x4(%ebp)
  800ebd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec0:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ec3:	72 d9                	jb     800e9e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ec5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ec8:	c9                   	leave  
  800ec9:	c3                   	ret    

00800eca <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800eca:	55                   	push   %ebp
  800ecb:	89 e5                	mov    %esp,%ebp
  800ecd:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ed6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eda:	74 30                	je     800f0c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800edc:	eb 16                	jmp    800ef4 <strlcpy+0x2a>
			*dst++ = *src++;
  800ede:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee1:	8d 50 01             	lea    0x1(%eax),%edx
  800ee4:	89 55 08             	mov    %edx,0x8(%ebp)
  800ee7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eea:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eed:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ef0:	8a 12                	mov    (%edx),%dl
  800ef2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ef4:	ff 4d 10             	decl   0x10(%ebp)
  800ef7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800efb:	74 09                	je     800f06 <strlcpy+0x3c>
  800efd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f00:	8a 00                	mov    (%eax),%al
  800f02:	84 c0                	test   %al,%al
  800f04:	75 d8                	jne    800ede <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f06:	8b 45 08             	mov    0x8(%ebp),%eax
  800f09:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f0c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f12:	29 c2                	sub    %eax,%edx
  800f14:	89 d0                	mov    %edx,%eax
}
  800f16:	c9                   	leave  
  800f17:	c3                   	ret    

00800f18 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f1b:	eb 06                	jmp    800f23 <strcmp+0xb>
		p++, q++;
  800f1d:	ff 45 08             	incl   0x8(%ebp)
  800f20:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	8a 00                	mov    (%eax),%al
  800f28:	84 c0                	test   %al,%al
  800f2a:	74 0e                	je     800f3a <strcmp+0x22>
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	8a 10                	mov    (%eax),%dl
  800f31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f34:	8a 00                	mov    (%eax),%al
  800f36:	38 c2                	cmp    %al,%dl
  800f38:	74 e3                	je     800f1d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	8a 00                	mov    (%eax),%al
  800f3f:	0f b6 d0             	movzbl %al,%edx
  800f42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f45:	8a 00                	mov    (%eax),%al
  800f47:	0f b6 c0             	movzbl %al,%eax
  800f4a:	29 c2                	sub    %eax,%edx
  800f4c:	89 d0                	mov    %edx,%eax
}
  800f4e:	5d                   	pop    %ebp
  800f4f:	c3                   	ret    

00800f50 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f50:	55                   	push   %ebp
  800f51:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f53:	eb 09                	jmp    800f5e <strncmp+0xe>
		n--, p++, q++;
  800f55:	ff 4d 10             	decl   0x10(%ebp)
  800f58:	ff 45 08             	incl   0x8(%ebp)
  800f5b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f5e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f62:	74 17                	je     800f7b <strncmp+0x2b>
  800f64:	8b 45 08             	mov    0x8(%ebp),%eax
  800f67:	8a 00                	mov    (%eax),%al
  800f69:	84 c0                	test   %al,%al
  800f6b:	74 0e                	je     800f7b <strncmp+0x2b>
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	8a 10                	mov    (%eax),%dl
  800f72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f75:	8a 00                	mov    (%eax),%al
  800f77:	38 c2                	cmp    %al,%dl
  800f79:	74 da                	je     800f55 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f7b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7f:	75 07                	jne    800f88 <strncmp+0x38>
		return 0;
  800f81:	b8 00 00 00 00       	mov    $0x0,%eax
  800f86:	eb 14                	jmp    800f9c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f88:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8b:	8a 00                	mov    (%eax),%al
  800f8d:	0f b6 d0             	movzbl %al,%edx
  800f90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f93:	8a 00                	mov    (%eax),%al
  800f95:	0f b6 c0             	movzbl %al,%eax
  800f98:	29 c2                	sub    %eax,%edx
  800f9a:	89 d0                	mov    %edx,%eax
}
  800f9c:	5d                   	pop    %ebp
  800f9d:	c3                   	ret    

00800f9e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f9e:	55                   	push   %ebp
  800f9f:	89 e5                	mov    %esp,%ebp
  800fa1:	83 ec 04             	sub    $0x4,%esp
  800fa4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800faa:	eb 12                	jmp    800fbe <strchr+0x20>
		if (*s == c)
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fb4:	75 05                	jne    800fbb <strchr+0x1d>
			return (char *) s;
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	eb 11                	jmp    800fcc <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fbb:	ff 45 08             	incl   0x8(%ebp)
  800fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc1:	8a 00                	mov    (%eax),%al
  800fc3:	84 c0                	test   %al,%al
  800fc5:	75 e5                	jne    800fac <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fcc:	c9                   	leave  
  800fcd:	c3                   	ret    

00800fce <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fce:	55                   	push   %ebp
  800fcf:	89 e5                	mov    %esp,%ebp
  800fd1:	83 ec 04             	sub    $0x4,%esp
  800fd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fda:	eb 0d                	jmp    800fe9 <strfind+0x1b>
		if (*s == c)
  800fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdf:	8a 00                	mov    (%eax),%al
  800fe1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fe4:	74 0e                	je     800ff4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fe6:	ff 45 08             	incl   0x8(%ebp)
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	8a 00                	mov    (%eax),%al
  800fee:	84 c0                	test   %al,%al
  800ff0:	75 ea                	jne    800fdc <strfind+0xe>
  800ff2:	eb 01                	jmp    800ff5 <strfind+0x27>
		if (*s == c)
			break;
  800ff4:	90                   	nop
	return (char *) s;
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ff8:	c9                   	leave  
  800ff9:	c3                   	ret    

00800ffa <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ffa:	55                   	push   %ebp
  800ffb:	89 e5                	mov    %esp,%ebp
  800ffd:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801000:	8b 45 08             	mov    0x8(%ebp),%eax
  801003:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801006:	8b 45 10             	mov    0x10(%ebp),%eax
  801009:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80100c:	eb 0e                	jmp    80101c <memset+0x22>
		*p++ = c;
  80100e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801011:	8d 50 01             	lea    0x1(%eax),%edx
  801014:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801017:	8b 55 0c             	mov    0xc(%ebp),%edx
  80101a:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80101c:	ff 4d f8             	decl   -0x8(%ebp)
  80101f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801023:	79 e9                	jns    80100e <memset+0x14>
		*p++ = c;

	return v;
  801025:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801028:	c9                   	leave  
  801029:	c3                   	ret    

0080102a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80102a:	55                   	push   %ebp
  80102b:	89 e5                	mov    %esp,%ebp
  80102d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801030:	8b 45 0c             	mov    0xc(%ebp),%eax
  801033:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801036:	8b 45 08             	mov    0x8(%ebp),%eax
  801039:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80103c:	eb 16                	jmp    801054 <memcpy+0x2a>
		*d++ = *s++;
  80103e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801041:	8d 50 01             	lea    0x1(%eax),%edx
  801044:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801047:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80104a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80104d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801050:	8a 12                	mov    (%edx),%dl
  801052:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801054:	8b 45 10             	mov    0x10(%ebp),%eax
  801057:	8d 50 ff             	lea    -0x1(%eax),%edx
  80105a:	89 55 10             	mov    %edx,0x10(%ebp)
  80105d:	85 c0                	test   %eax,%eax
  80105f:	75 dd                	jne    80103e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801064:	c9                   	leave  
  801065:	c3                   	ret    

00801066 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
  801069:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80106c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801072:	8b 45 08             	mov    0x8(%ebp),%eax
  801075:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801078:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80107b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80107e:	73 50                	jae    8010d0 <memmove+0x6a>
  801080:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801083:	8b 45 10             	mov    0x10(%ebp),%eax
  801086:	01 d0                	add    %edx,%eax
  801088:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80108b:	76 43                	jbe    8010d0 <memmove+0x6a>
		s += n;
  80108d:	8b 45 10             	mov    0x10(%ebp),%eax
  801090:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801093:	8b 45 10             	mov    0x10(%ebp),%eax
  801096:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801099:	eb 10                	jmp    8010ab <memmove+0x45>
			*--d = *--s;
  80109b:	ff 4d f8             	decl   -0x8(%ebp)
  80109e:	ff 4d fc             	decl   -0x4(%ebp)
  8010a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010a4:	8a 10                	mov    (%eax),%dl
  8010a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a9:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ae:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010b1:	89 55 10             	mov    %edx,0x10(%ebp)
  8010b4:	85 c0                	test   %eax,%eax
  8010b6:	75 e3                	jne    80109b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010b8:	eb 23                	jmp    8010dd <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010bd:	8d 50 01             	lea    0x1(%eax),%edx
  8010c0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010c3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010c6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010c9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010cc:	8a 12                	mov    (%edx),%dl
  8010ce:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010d6:	89 55 10             	mov    %edx,0x10(%ebp)
  8010d9:	85 c0                	test   %eax,%eax
  8010db:	75 dd                	jne    8010ba <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010dd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010e0:	c9                   	leave  
  8010e1:	c3                   	ret    

008010e2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010e2:	55                   	push   %ebp
  8010e3:	89 e5                	mov    %esp,%ebp
  8010e5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010f4:	eb 2a                	jmp    801120 <memcmp+0x3e>
		if (*s1 != *s2)
  8010f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f9:	8a 10                	mov    (%eax),%dl
  8010fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010fe:	8a 00                	mov    (%eax),%al
  801100:	38 c2                	cmp    %al,%dl
  801102:	74 16                	je     80111a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801104:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801107:	8a 00                	mov    (%eax),%al
  801109:	0f b6 d0             	movzbl %al,%edx
  80110c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80110f:	8a 00                	mov    (%eax),%al
  801111:	0f b6 c0             	movzbl %al,%eax
  801114:	29 c2                	sub    %eax,%edx
  801116:	89 d0                	mov    %edx,%eax
  801118:	eb 18                	jmp    801132 <memcmp+0x50>
		s1++, s2++;
  80111a:	ff 45 fc             	incl   -0x4(%ebp)
  80111d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801120:	8b 45 10             	mov    0x10(%ebp),%eax
  801123:	8d 50 ff             	lea    -0x1(%eax),%edx
  801126:	89 55 10             	mov    %edx,0x10(%ebp)
  801129:	85 c0                	test   %eax,%eax
  80112b:	75 c9                	jne    8010f6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80112d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801132:	c9                   	leave  
  801133:	c3                   	ret    

00801134 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801134:	55                   	push   %ebp
  801135:	89 e5                	mov    %esp,%ebp
  801137:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80113a:	8b 55 08             	mov    0x8(%ebp),%edx
  80113d:	8b 45 10             	mov    0x10(%ebp),%eax
  801140:	01 d0                	add    %edx,%eax
  801142:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801145:	eb 15                	jmp    80115c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
  80114a:	8a 00                	mov    (%eax),%al
  80114c:	0f b6 d0             	movzbl %al,%edx
  80114f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801152:	0f b6 c0             	movzbl %al,%eax
  801155:	39 c2                	cmp    %eax,%edx
  801157:	74 0d                	je     801166 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801159:	ff 45 08             	incl   0x8(%ebp)
  80115c:	8b 45 08             	mov    0x8(%ebp),%eax
  80115f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801162:	72 e3                	jb     801147 <memfind+0x13>
  801164:	eb 01                	jmp    801167 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801166:	90                   	nop
	return (void *) s;
  801167:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80116a:	c9                   	leave  
  80116b:	c3                   	ret    

0080116c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80116c:	55                   	push   %ebp
  80116d:	89 e5                	mov    %esp,%ebp
  80116f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801172:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801179:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801180:	eb 03                	jmp    801185 <strtol+0x19>
		s++;
  801182:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801185:	8b 45 08             	mov    0x8(%ebp),%eax
  801188:	8a 00                	mov    (%eax),%al
  80118a:	3c 20                	cmp    $0x20,%al
  80118c:	74 f4                	je     801182 <strtol+0x16>
  80118e:	8b 45 08             	mov    0x8(%ebp),%eax
  801191:	8a 00                	mov    (%eax),%al
  801193:	3c 09                	cmp    $0x9,%al
  801195:	74 eb                	je     801182 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801197:	8b 45 08             	mov    0x8(%ebp),%eax
  80119a:	8a 00                	mov    (%eax),%al
  80119c:	3c 2b                	cmp    $0x2b,%al
  80119e:	75 05                	jne    8011a5 <strtol+0x39>
		s++;
  8011a0:	ff 45 08             	incl   0x8(%ebp)
  8011a3:	eb 13                	jmp    8011b8 <strtol+0x4c>
	else if (*s == '-')
  8011a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a8:	8a 00                	mov    (%eax),%al
  8011aa:	3c 2d                	cmp    $0x2d,%al
  8011ac:	75 0a                	jne    8011b8 <strtol+0x4c>
		s++, neg = 1;
  8011ae:	ff 45 08             	incl   0x8(%ebp)
  8011b1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011bc:	74 06                	je     8011c4 <strtol+0x58>
  8011be:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011c2:	75 20                	jne    8011e4 <strtol+0x78>
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c7:	8a 00                	mov    (%eax),%al
  8011c9:	3c 30                	cmp    $0x30,%al
  8011cb:	75 17                	jne    8011e4 <strtol+0x78>
  8011cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d0:	40                   	inc    %eax
  8011d1:	8a 00                	mov    (%eax),%al
  8011d3:	3c 78                	cmp    $0x78,%al
  8011d5:	75 0d                	jne    8011e4 <strtol+0x78>
		s += 2, base = 16;
  8011d7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011db:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011e2:	eb 28                	jmp    80120c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011e4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011e8:	75 15                	jne    8011ff <strtol+0x93>
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	8a 00                	mov    (%eax),%al
  8011ef:	3c 30                	cmp    $0x30,%al
  8011f1:	75 0c                	jne    8011ff <strtol+0x93>
		s++, base = 8;
  8011f3:	ff 45 08             	incl   0x8(%ebp)
  8011f6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011fd:	eb 0d                	jmp    80120c <strtol+0xa0>
	else if (base == 0)
  8011ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801203:	75 07                	jne    80120c <strtol+0xa0>
		base = 10;
  801205:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	8a 00                	mov    (%eax),%al
  801211:	3c 2f                	cmp    $0x2f,%al
  801213:	7e 19                	jle    80122e <strtol+0xc2>
  801215:	8b 45 08             	mov    0x8(%ebp),%eax
  801218:	8a 00                	mov    (%eax),%al
  80121a:	3c 39                	cmp    $0x39,%al
  80121c:	7f 10                	jg     80122e <strtol+0xc2>
			dig = *s - '0';
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
  801221:	8a 00                	mov    (%eax),%al
  801223:	0f be c0             	movsbl %al,%eax
  801226:	83 e8 30             	sub    $0x30,%eax
  801229:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80122c:	eb 42                	jmp    801270 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80122e:	8b 45 08             	mov    0x8(%ebp),%eax
  801231:	8a 00                	mov    (%eax),%al
  801233:	3c 60                	cmp    $0x60,%al
  801235:	7e 19                	jle    801250 <strtol+0xe4>
  801237:	8b 45 08             	mov    0x8(%ebp),%eax
  80123a:	8a 00                	mov    (%eax),%al
  80123c:	3c 7a                	cmp    $0x7a,%al
  80123e:	7f 10                	jg     801250 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
  801243:	8a 00                	mov    (%eax),%al
  801245:	0f be c0             	movsbl %al,%eax
  801248:	83 e8 57             	sub    $0x57,%eax
  80124b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80124e:	eb 20                	jmp    801270 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801250:	8b 45 08             	mov    0x8(%ebp),%eax
  801253:	8a 00                	mov    (%eax),%al
  801255:	3c 40                	cmp    $0x40,%al
  801257:	7e 39                	jle    801292 <strtol+0x126>
  801259:	8b 45 08             	mov    0x8(%ebp),%eax
  80125c:	8a 00                	mov    (%eax),%al
  80125e:	3c 5a                	cmp    $0x5a,%al
  801260:	7f 30                	jg     801292 <strtol+0x126>
			dig = *s - 'A' + 10;
  801262:	8b 45 08             	mov    0x8(%ebp),%eax
  801265:	8a 00                	mov    (%eax),%al
  801267:	0f be c0             	movsbl %al,%eax
  80126a:	83 e8 37             	sub    $0x37,%eax
  80126d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801270:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801273:	3b 45 10             	cmp    0x10(%ebp),%eax
  801276:	7d 19                	jge    801291 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801278:	ff 45 08             	incl   0x8(%ebp)
  80127b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80127e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801282:	89 c2                	mov    %eax,%edx
  801284:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801287:	01 d0                	add    %edx,%eax
  801289:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80128c:	e9 7b ff ff ff       	jmp    80120c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801291:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801292:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801296:	74 08                	je     8012a0 <strtol+0x134>
		*endptr = (char *) s;
  801298:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129b:	8b 55 08             	mov    0x8(%ebp),%edx
  80129e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012a4:	74 07                	je     8012ad <strtol+0x141>
  8012a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012a9:	f7 d8                	neg    %eax
  8012ab:	eb 03                	jmp    8012b0 <strtol+0x144>
  8012ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012b0:	c9                   	leave  
  8012b1:	c3                   	ret    

008012b2 <ltostr>:

void
ltostr(long value, char *str)
{
  8012b2:	55                   	push   %ebp
  8012b3:	89 e5                	mov    %esp,%ebp
  8012b5:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012bf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012ca:	79 13                	jns    8012df <ltostr+0x2d>
	{
		neg = 1;
  8012cc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012d9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012dc:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012df:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012e7:	99                   	cltd   
  8012e8:	f7 f9                	idiv   %ecx
  8012ea:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f0:	8d 50 01             	lea    0x1(%eax),%edx
  8012f3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012f6:	89 c2                	mov    %eax,%edx
  8012f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fb:	01 d0                	add    %edx,%eax
  8012fd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801300:	83 c2 30             	add    $0x30,%edx
  801303:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801305:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801308:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80130d:	f7 e9                	imul   %ecx
  80130f:	c1 fa 02             	sar    $0x2,%edx
  801312:	89 c8                	mov    %ecx,%eax
  801314:	c1 f8 1f             	sar    $0x1f,%eax
  801317:	29 c2                	sub    %eax,%edx
  801319:	89 d0                	mov    %edx,%eax
  80131b:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80131e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801321:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801326:	f7 e9                	imul   %ecx
  801328:	c1 fa 02             	sar    $0x2,%edx
  80132b:	89 c8                	mov    %ecx,%eax
  80132d:	c1 f8 1f             	sar    $0x1f,%eax
  801330:	29 c2                	sub    %eax,%edx
  801332:	89 d0                	mov    %edx,%eax
  801334:	c1 e0 02             	shl    $0x2,%eax
  801337:	01 d0                	add    %edx,%eax
  801339:	01 c0                	add    %eax,%eax
  80133b:	29 c1                	sub    %eax,%ecx
  80133d:	89 ca                	mov    %ecx,%edx
  80133f:	85 d2                	test   %edx,%edx
  801341:	75 9c                	jne    8012df <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801343:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80134a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80134d:	48                   	dec    %eax
  80134e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801351:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801355:	74 3d                	je     801394 <ltostr+0xe2>
		start = 1 ;
  801357:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80135e:	eb 34                	jmp    801394 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801360:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801363:	8b 45 0c             	mov    0xc(%ebp),%eax
  801366:	01 d0                	add    %edx,%eax
  801368:	8a 00                	mov    (%eax),%al
  80136a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80136d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801370:	8b 45 0c             	mov    0xc(%ebp),%eax
  801373:	01 c2                	add    %eax,%edx
  801375:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801378:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137b:	01 c8                	add    %ecx,%eax
  80137d:	8a 00                	mov    (%eax),%al
  80137f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801381:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801384:	8b 45 0c             	mov    0xc(%ebp),%eax
  801387:	01 c2                	add    %eax,%edx
  801389:	8a 45 eb             	mov    -0x15(%ebp),%al
  80138c:	88 02                	mov    %al,(%edx)
		start++ ;
  80138e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801391:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801397:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80139a:	7c c4                	jl     801360 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80139c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80139f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a2:	01 d0                	add    %edx,%eax
  8013a4:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013a7:	90                   	nop
  8013a8:	c9                   	leave  
  8013a9:	c3                   	ret    

008013aa <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013aa:	55                   	push   %ebp
  8013ab:	89 e5                	mov    %esp,%ebp
  8013ad:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013b0:	ff 75 08             	pushl  0x8(%ebp)
  8013b3:	e8 54 fa ff ff       	call   800e0c <strlen>
  8013b8:	83 c4 04             	add    $0x4,%esp
  8013bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013be:	ff 75 0c             	pushl  0xc(%ebp)
  8013c1:	e8 46 fa ff ff       	call   800e0c <strlen>
  8013c6:	83 c4 04             	add    $0x4,%esp
  8013c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013da:	eb 17                	jmp    8013f3 <strcconcat+0x49>
		final[s] = str1[s] ;
  8013dc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013df:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e2:	01 c2                	add    %eax,%edx
  8013e4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ea:	01 c8                	add    %ecx,%eax
  8013ec:	8a 00                	mov    (%eax),%al
  8013ee:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013f0:	ff 45 fc             	incl   -0x4(%ebp)
  8013f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013f9:	7c e1                	jl     8013dc <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013fb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801402:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801409:	eb 1f                	jmp    80142a <strcconcat+0x80>
		final[s++] = str2[i] ;
  80140b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80140e:	8d 50 01             	lea    0x1(%eax),%edx
  801411:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801414:	89 c2                	mov    %eax,%edx
  801416:	8b 45 10             	mov    0x10(%ebp),%eax
  801419:	01 c2                	add    %eax,%edx
  80141b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80141e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801421:	01 c8                	add    %ecx,%eax
  801423:	8a 00                	mov    (%eax),%al
  801425:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801427:	ff 45 f8             	incl   -0x8(%ebp)
  80142a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80142d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801430:	7c d9                	jl     80140b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801432:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801435:	8b 45 10             	mov    0x10(%ebp),%eax
  801438:	01 d0                	add    %edx,%eax
  80143a:	c6 00 00             	movb   $0x0,(%eax)
}
  80143d:	90                   	nop
  80143e:	c9                   	leave  
  80143f:	c3                   	ret    

00801440 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801440:	55                   	push   %ebp
  801441:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801443:	8b 45 14             	mov    0x14(%ebp),%eax
  801446:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80144c:	8b 45 14             	mov    0x14(%ebp),%eax
  80144f:	8b 00                	mov    (%eax),%eax
  801451:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801458:	8b 45 10             	mov    0x10(%ebp),%eax
  80145b:	01 d0                	add    %edx,%eax
  80145d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801463:	eb 0c                	jmp    801471 <strsplit+0x31>
			*string++ = 0;
  801465:	8b 45 08             	mov    0x8(%ebp),%eax
  801468:	8d 50 01             	lea    0x1(%eax),%edx
  80146b:	89 55 08             	mov    %edx,0x8(%ebp)
  80146e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801471:	8b 45 08             	mov    0x8(%ebp),%eax
  801474:	8a 00                	mov    (%eax),%al
  801476:	84 c0                	test   %al,%al
  801478:	74 18                	je     801492 <strsplit+0x52>
  80147a:	8b 45 08             	mov    0x8(%ebp),%eax
  80147d:	8a 00                	mov    (%eax),%al
  80147f:	0f be c0             	movsbl %al,%eax
  801482:	50                   	push   %eax
  801483:	ff 75 0c             	pushl  0xc(%ebp)
  801486:	e8 13 fb ff ff       	call   800f9e <strchr>
  80148b:	83 c4 08             	add    $0x8,%esp
  80148e:	85 c0                	test   %eax,%eax
  801490:	75 d3                	jne    801465 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	8a 00                	mov    (%eax),%al
  801497:	84 c0                	test   %al,%al
  801499:	74 5a                	je     8014f5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80149b:	8b 45 14             	mov    0x14(%ebp),%eax
  80149e:	8b 00                	mov    (%eax),%eax
  8014a0:	83 f8 0f             	cmp    $0xf,%eax
  8014a3:	75 07                	jne    8014ac <strsplit+0x6c>
		{
			return 0;
  8014a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014aa:	eb 66                	jmp    801512 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8014af:	8b 00                	mov    (%eax),%eax
  8014b1:	8d 48 01             	lea    0x1(%eax),%ecx
  8014b4:	8b 55 14             	mov    0x14(%ebp),%edx
  8014b7:	89 0a                	mov    %ecx,(%edx)
  8014b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c3:	01 c2                	add    %eax,%edx
  8014c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c8:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014ca:	eb 03                	jmp    8014cf <strsplit+0x8f>
			string++;
  8014cc:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d2:	8a 00                	mov    (%eax),%al
  8014d4:	84 c0                	test   %al,%al
  8014d6:	74 8b                	je     801463 <strsplit+0x23>
  8014d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014db:	8a 00                	mov    (%eax),%al
  8014dd:	0f be c0             	movsbl %al,%eax
  8014e0:	50                   	push   %eax
  8014e1:	ff 75 0c             	pushl  0xc(%ebp)
  8014e4:	e8 b5 fa ff ff       	call   800f9e <strchr>
  8014e9:	83 c4 08             	add    $0x8,%esp
  8014ec:	85 c0                	test   %eax,%eax
  8014ee:	74 dc                	je     8014cc <strsplit+0x8c>
			string++;
	}
  8014f0:	e9 6e ff ff ff       	jmp    801463 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014f5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f9:	8b 00                	mov    (%eax),%eax
  8014fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801502:	8b 45 10             	mov    0x10(%ebp),%eax
  801505:	01 d0                	add    %edx,%eax
  801507:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80150d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801512:	c9                   	leave  
  801513:	c3                   	ret    

00801514 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801514:	55                   	push   %ebp
  801515:	89 e5                	mov    %esp,%ebp
  801517:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80151a:	a1 04 40 80 00       	mov    0x804004,%eax
  80151f:	85 c0                	test   %eax,%eax
  801521:	74 1f                	je     801542 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801523:	e8 1d 00 00 00       	call   801545 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801528:	83 ec 0c             	sub    $0xc,%esp
  80152b:	68 b0 3c 80 00       	push   $0x803cb0
  801530:	e8 55 f2 ff ff       	call   80078a <cprintf>
  801535:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801538:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80153f:	00 00 00 
	}
}
  801542:	90                   	nop
  801543:	c9                   	leave  
  801544:	c3                   	ret    

00801545 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801545:	55                   	push   %ebp
  801546:	89 e5                	mov    %esp,%ebp
  801548:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  80154b:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801552:	00 00 00 
  801555:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80155c:	00 00 00 
  80155f:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801566:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  801569:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801570:	00 00 00 
  801573:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80157a:	00 00 00 
  80157d:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801584:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  801587:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80158e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801591:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801596:	2d 00 10 00 00       	sub    $0x1000,%eax
  80159b:	a3 50 40 80 00       	mov    %eax,0x804050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  8015a0:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  8015a7:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  8015aa:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8015b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b4:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  8015b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8015c4:	f7 75 f0             	divl   -0x10(%ebp)
  8015c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ca:	29 d0                	sub    %edx,%eax
  8015cc:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  8015cf:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8015d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015d9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015de:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015e3:	83 ec 04             	sub    $0x4,%esp
  8015e6:	6a 06                	push   $0x6
  8015e8:	ff 75 e8             	pushl  -0x18(%ebp)
  8015eb:	50                   	push   %eax
  8015ec:	e8 d4 05 00 00       	call   801bc5 <sys_allocate_chunk>
  8015f1:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015f4:	a1 20 41 80 00       	mov    0x804120,%eax
  8015f9:	83 ec 0c             	sub    $0xc,%esp
  8015fc:	50                   	push   %eax
  8015fd:	e8 49 0c 00 00       	call   80224b <initialize_MemBlocksList>
  801602:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  801605:	a1 48 41 80 00       	mov    0x804148,%eax
  80160a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  80160d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801611:	75 14                	jne    801627 <initialize_dyn_block_system+0xe2>
  801613:	83 ec 04             	sub    $0x4,%esp
  801616:	68 d5 3c 80 00       	push   $0x803cd5
  80161b:	6a 39                	push   $0x39
  80161d:	68 f3 3c 80 00       	push   $0x803cf3
  801622:	e8 af ee ff ff       	call   8004d6 <_panic>
  801627:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80162a:	8b 00                	mov    (%eax),%eax
  80162c:	85 c0                	test   %eax,%eax
  80162e:	74 10                	je     801640 <initialize_dyn_block_system+0xfb>
  801630:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801633:	8b 00                	mov    (%eax),%eax
  801635:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801638:	8b 52 04             	mov    0x4(%edx),%edx
  80163b:	89 50 04             	mov    %edx,0x4(%eax)
  80163e:	eb 0b                	jmp    80164b <initialize_dyn_block_system+0x106>
  801640:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801643:	8b 40 04             	mov    0x4(%eax),%eax
  801646:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80164b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80164e:	8b 40 04             	mov    0x4(%eax),%eax
  801651:	85 c0                	test   %eax,%eax
  801653:	74 0f                	je     801664 <initialize_dyn_block_system+0x11f>
  801655:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801658:	8b 40 04             	mov    0x4(%eax),%eax
  80165b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80165e:	8b 12                	mov    (%edx),%edx
  801660:	89 10                	mov    %edx,(%eax)
  801662:	eb 0a                	jmp    80166e <initialize_dyn_block_system+0x129>
  801664:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801667:	8b 00                	mov    (%eax),%eax
  801669:	a3 48 41 80 00       	mov    %eax,0x804148
  80166e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801671:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801677:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80167a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801681:	a1 54 41 80 00       	mov    0x804154,%eax
  801686:	48                   	dec    %eax
  801687:	a3 54 41 80 00       	mov    %eax,0x804154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  80168c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80168f:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  801696:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801699:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  8016a0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8016a4:	75 14                	jne    8016ba <initialize_dyn_block_system+0x175>
  8016a6:	83 ec 04             	sub    $0x4,%esp
  8016a9:	68 00 3d 80 00       	push   $0x803d00
  8016ae:	6a 3f                	push   $0x3f
  8016b0:	68 f3 3c 80 00       	push   $0x803cf3
  8016b5:	e8 1c ee ff ff       	call   8004d6 <_panic>
  8016ba:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8016c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016c3:	89 10                	mov    %edx,(%eax)
  8016c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016c8:	8b 00                	mov    (%eax),%eax
  8016ca:	85 c0                	test   %eax,%eax
  8016cc:	74 0d                	je     8016db <initialize_dyn_block_system+0x196>
  8016ce:	a1 38 41 80 00       	mov    0x804138,%eax
  8016d3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8016d6:	89 50 04             	mov    %edx,0x4(%eax)
  8016d9:	eb 08                	jmp    8016e3 <initialize_dyn_block_system+0x19e>
  8016db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016de:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8016e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016e6:	a3 38 41 80 00       	mov    %eax,0x804138
  8016eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016f5:	a1 44 41 80 00       	mov    0x804144,%eax
  8016fa:	40                   	inc    %eax
  8016fb:	a3 44 41 80 00       	mov    %eax,0x804144

}
  801700:	90                   	nop
  801701:	c9                   	leave  
  801702:	c3                   	ret    

00801703 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801703:	55                   	push   %ebp
  801704:	89 e5                	mov    %esp,%ebp
  801706:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801709:	e8 06 fe ff ff       	call   801514 <InitializeUHeap>
	if (size == 0) return NULL ;
  80170e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801712:	75 07                	jne    80171b <malloc+0x18>
  801714:	b8 00 00 00 00       	mov    $0x0,%eax
  801719:	eb 7d                	jmp    801798 <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  80171b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801722:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801729:	8b 55 08             	mov    0x8(%ebp),%edx
  80172c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80172f:	01 d0                	add    %edx,%eax
  801731:	48                   	dec    %eax
  801732:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801735:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801738:	ba 00 00 00 00       	mov    $0x0,%edx
  80173d:	f7 75 f0             	divl   -0x10(%ebp)
  801740:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801743:	29 d0                	sub    %edx,%eax
  801745:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  801748:	e8 46 08 00 00       	call   801f93 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80174d:	83 f8 01             	cmp    $0x1,%eax
  801750:	75 07                	jne    801759 <malloc+0x56>
  801752:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  801759:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  80175d:	75 34                	jne    801793 <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  80175f:	83 ec 0c             	sub    $0xc,%esp
  801762:	ff 75 e8             	pushl  -0x18(%ebp)
  801765:	e8 73 0e 00 00       	call   8025dd <alloc_block_FF>
  80176a:	83 c4 10             	add    $0x10,%esp
  80176d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  801770:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801774:	74 16                	je     80178c <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  801776:	83 ec 0c             	sub    $0xc,%esp
  801779:	ff 75 e4             	pushl  -0x1c(%ebp)
  80177c:	e8 ff 0b 00 00       	call   802380 <insert_sorted_allocList>
  801781:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  801784:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801787:	8b 40 08             	mov    0x8(%eax),%eax
  80178a:	eb 0c                	jmp    801798 <malloc+0x95>
	             }
	             else
	             	return NULL;
  80178c:	b8 00 00 00 00       	mov    $0x0,%eax
  801791:	eb 05                	jmp    801798 <malloc+0x95>
	      	  }
	          else
	               return NULL;
  801793:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  801798:	c9                   	leave  
  801799:	c3                   	ret    

0080179a <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
  80179d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  8017a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a3:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  8017a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8017ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017af:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017b4:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  8017b7:	83 ec 08             	sub    $0x8,%esp
  8017ba:	ff 75 f4             	pushl  -0xc(%ebp)
  8017bd:	68 40 40 80 00       	push   $0x804040
  8017c2:	e8 61 0b 00 00       	call   802328 <find_block>
  8017c7:	83 c4 10             	add    $0x10,%esp
  8017ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  8017cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017d1:	0f 84 a5 00 00 00    	je     80187c <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  8017d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017da:	8b 40 0c             	mov    0xc(%eax),%eax
  8017dd:	83 ec 08             	sub    $0x8,%esp
  8017e0:	50                   	push   %eax
  8017e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8017e4:	e8 a4 03 00 00       	call   801b8d <sys_free_user_mem>
  8017e9:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  8017ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017f0:	75 17                	jne    801809 <free+0x6f>
  8017f2:	83 ec 04             	sub    $0x4,%esp
  8017f5:	68 d5 3c 80 00       	push   $0x803cd5
  8017fa:	68 87 00 00 00       	push   $0x87
  8017ff:	68 f3 3c 80 00       	push   $0x803cf3
  801804:	e8 cd ec ff ff       	call   8004d6 <_panic>
  801809:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80180c:	8b 00                	mov    (%eax),%eax
  80180e:	85 c0                	test   %eax,%eax
  801810:	74 10                	je     801822 <free+0x88>
  801812:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801815:	8b 00                	mov    (%eax),%eax
  801817:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80181a:	8b 52 04             	mov    0x4(%edx),%edx
  80181d:	89 50 04             	mov    %edx,0x4(%eax)
  801820:	eb 0b                	jmp    80182d <free+0x93>
  801822:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801825:	8b 40 04             	mov    0x4(%eax),%eax
  801828:	a3 44 40 80 00       	mov    %eax,0x804044
  80182d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801830:	8b 40 04             	mov    0x4(%eax),%eax
  801833:	85 c0                	test   %eax,%eax
  801835:	74 0f                	je     801846 <free+0xac>
  801837:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80183a:	8b 40 04             	mov    0x4(%eax),%eax
  80183d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801840:	8b 12                	mov    (%edx),%edx
  801842:	89 10                	mov    %edx,(%eax)
  801844:	eb 0a                	jmp    801850 <free+0xb6>
  801846:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801849:	8b 00                	mov    (%eax),%eax
  80184b:	a3 40 40 80 00       	mov    %eax,0x804040
  801850:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801853:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801859:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80185c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801863:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801868:	48                   	dec    %eax
  801869:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(theBlock);
  80186e:	83 ec 0c             	sub    $0xc,%esp
  801871:	ff 75 ec             	pushl  -0x14(%ebp)
  801874:	e8 37 12 00 00       	call   802ab0 <insert_sorted_with_merge_freeList>
  801879:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  80187c:	90                   	nop
  80187d:	c9                   	leave  
  80187e:	c3                   	ret    

0080187f <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80187f:	55                   	push   %ebp
  801880:	89 e5                	mov    %esp,%ebp
  801882:	83 ec 38             	sub    $0x38,%esp
  801885:	8b 45 10             	mov    0x10(%ebp),%eax
  801888:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80188b:	e8 84 fc ff ff       	call   801514 <InitializeUHeap>
	if (size == 0) return NULL ;
  801890:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801894:	75 07                	jne    80189d <smalloc+0x1e>
  801896:	b8 00 00 00 00       	mov    $0x0,%eax
  80189b:	eb 7e                	jmp    80191b <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  80189d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8018a4:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8018ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018b1:	01 d0                	add    %edx,%eax
  8018b3:	48                   	dec    %eax
  8018b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8018b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8018bf:	f7 75 f0             	divl   -0x10(%ebp)
  8018c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018c5:	29 d0                	sub    %edx,%eax
  8018c7:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  8018ca:	e8 c4 06 00 00       	call   801f93 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018cf:	83 f8 01             	cmp    $0x1,%eax
  8018d2:	75 42                	jne    801916 <smalloc+0x97>

		  va = malloc(newsize) ;
  8018d4:	83 ec 0c             	sub    $0xc,%esp
  8018d7:	ff 75 e8             	pushl  -0x18(%ebp)
  8018da:	e8 24 fe ff ff       	call   801703 <malloc>
  8018df:	83 c4 10             	add    $0x10,%esp
  8018e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  8018e5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8018e9:	74 24                	je     80190f <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  8018eb:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8018ef:	ff 75 e4             	pushl  -0x1c(%ebp)
  8018f2:	50                   	push   %eax
  8018f3:	ff 75 e8             	pushl  -0x18(%ebp)
  8018f6:	ff 75 08             	pushl  0x8(%ebp)
  8018f9:	e8 1a 04 00 00       	call   801d18 <sys_createSharedObject>
  8018fe:	83 c4 10             	add    $0x10,%esp
  801901:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  801904:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801908:	78 0c                	js     801916 <smalloc+0x97>
					  return va ;
  80190a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80190d:	eb 0c                	jmp    80191b <smalloc+0x9c>
				 }
				 else
					return NULL;
  80190f:	b8 00 00 00 00       	mov    $0x0,%eax
  801914:	eb 05                	jmp    80191b <smalloc+0x9c>
	  }
		  return NULL ;
  801916:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80191b:	c9                   	leave  
  80191c:	c3                   	ret    

0080191d <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80191d:	55                   	push   %ebp
  80191e:	89 e5                	mov    %esp,%ebp
  801920:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801923:	e8 ec fb ff ff       	call   801514 <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  801928:	83 ec 08             	sub    $0x8,%esp
  80192b:	ff 75 0c             	pushl  0xc(%ebp)
  80192e:	ff 75 08             	pushl  0x8(%ebp)
  801931:	e8 0c 04 00 00       	call   801d42 <sys_getSizeOfSharedObject>
  801936:	83 c4 10             	add    $0x10,%esp
  801939:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  80193c:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801940:	75 07                	jne    801949 <sget+0x2c>
  801942:	b8 00 00 00 00       	mov    $0x0,%eax
  801947:	eb 75                	jmp    8019be <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801949:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801950:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801953:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801956:	01 d0                	add    %edx,%eax
  801958:	48                   	dec    %eax
  801959:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80195c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80195f:	ba 00 00 00 00       	mov    $0x0,%edx
  801964:	f7 75 f0             	divl   -0x10(%ebp)
  801967:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80196a:	29 d0                	sub    %edx,%eax
  80196c:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  80196f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801976:	e8 18 06 00 00       	call   801f93 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80197b:	83 f8 01             	cmp    $0x1,%eax
  80197e:	75 39                	jne    8019b9 <sget+0x9c>

		  va = malloc(newsize) ;
  801980:	83 ec 0c             	sub    $0xc,%esp
  801983:	ff 75 e8             	pushl  -0x18(%ebp)
  801986:	e8 78 fd ff ff       	call   801703 <malloc>
  80198b:	83 c4 10             	add    $0x10,%esp
  80198e:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  801991:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801995:	74 22                	je     8019b9 <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  801997:	83 ec 04             	sub    $0x4,%esp
  80199a:	ff 75 e0             	pushl  -0x20(%ebp)
  80199d:	ff 75 0c             	pushl  0xc(%ebp)
  8019a0:	ff 75 08             	pushl  0x8(%ebp)
  8019a3:	e8 b7 03 00 00       	call   801d5f <sys_getSharedObject>
  8019a8:	83 c4 10             	add    $0x10,%esp
  8019ab:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  8019ae:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8019b2:	78 05                	js     8019b9 <sget+0x9c>
					  return va;
  8019b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019b7:	eb 05                	jmp    8019be <sget+0xa1>
				  }
			  }
     }
         return NULL;
  8019b9:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  8019be:	c9                   	leave  
  8019bf:	c3                   	ret    

008019c0 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
  8019c3:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019c6:	e8 49 fb ff ff       	call   801514 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8019cb:	83 ec 04             	sub    $0x4,%esp
  8019ce:	68 24 3d 80 00       	push   $0x803d24
  8019d3:	68 1e 01 00 00       	push   $0x11e
  8019d8:	68 f3 3c 80 00       	push   $0x803cf3
  8019dd:	e8 f4 ea ff ff       	call   8004d6 <_panic>

008019e2 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
  8019e5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8019e8:	83 ec 04             	sub    $0x4,%esp
  8019eb:	68 4c 3d 80 00       	push   $0x803d4c
  8019f0:	68 32 01 00 00       	push   $0x132
  8019f5:	68 f3 3c 80 00       	push   $0x803cf3
  8019fa:	e8 d7 ea ff ff       	call   8004d6 <_panic>

008019ff <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
  801a02:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a05:	83 ec 04             	sub    $0x4,%esp
  801a08:	68 70 3d 80 00       	push   $0x803d70
  801a0d:	68 3d 01 00 00       	push   $0x13d
  801a12:	68 f3 3c 80 00       	push   $0x803cf3
  801a17:	e8 ba ea ff ff       	call   8004d6 <_panic>

00801a1c <shrink>:

}
void shrink(uint32 newSize)
{
  801a1c:	55                   	push   %ebp
  801a1d:	89 e5                	mov    %esp,%ebp
  801a1f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a22:	83 ec 04             	sub    $0x4,%esp
  801a25:	68 70 3d 80 00       	push   $0x803d70
  801a2a:	68 42 01 00 00       	push   $0x142
  801a2f:	68 f3 3c 80 00       	push   $0x803cf3
  801a34:	e8 9d ea ff ff       	call   8004d6 <_panic>

00801a39 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a39:	55                   	push   %ebp
  801a3a:	89 e5                	mov    %esp,%ebp
  801a3c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a3f:	83 ec 04             	sub    $0x4,%esp
  801a42:	68 70 3d 80 00       	push   $0x803d70
  801a47:	68 47 01 00 00       	push   $0x147
  801a4c:	68 f3 3c 80 00       	push   $0x803cf3
  801a51:	e8 80 ea ff ff       	call   8004d6 <_panic>

00801a56 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
  801a59:	57                   	push   %edi
  801a5a:	56                   	push   %esi
  801a5b:	53                   	push   %ebx
  801a5c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a62:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a65:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a68:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a6b:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a6e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a71:	cd 30                	int    $0x30
  801a73:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a76:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a79:	83 c4 10             	add    $0x10,%esp
  801a7c:	5b                   	pop    %ebx
  801a7d:	5e                   	pop    %esi
  801a7e:	5f                   	pop    %edi
  801a7f:	5d                   	pop    %ebp
  801a80:	c3                   	ret    

00801a81 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a81:	55                   	push   %ebp
  801a82:	89 e5                	mov    %esp,%ebp
  801a84:	83 ec 04             	sub    $0x4,%esp
  801a87:	8b 45 10             	mov    0x10(%ebp),%eax
  801a8a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a8d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a91:	8b 45 08             	mov    0x8(%ebp),%eax
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	52                   	push   %edx
  801a99:	ff 75 0c             	pushl  0xc(%ebp)
  801a9c:	50                   	push   %eax
  801a9d:	6a 00                	push   $0x0
  801a9f:	e8 b2 ff ff ff       	call   801a56 <syscall>
  801aa4:	83 c4 18             	add    $0x18,%esp
}
  801aa7:	90                   	nop
  801aa8:	c9                   	leave  
  801aa9:	c3                   	ret    

00801aaa <sys_cgetc>:

int
sys_cgetc(void)
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 01                	push   $0x1
  801ab9:	e8 98 ff ff ff       	call   801a56 <syscall>
  801abe:	83 c4 18             	add    $0x18,%esp
}
  801ac1:	c9                   	leave  
  801ac2:	c3                   	ret    

00801ac3 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ac6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	52                   	push   %edx
  801ad3:	50                   	push   %eax
  801ad4:	6a 05                	push   $0x5
  801ad6:	e8 7b ff ff ff       	call   801a56 <syscall>
  801adb:	83 c4 18             	add    $0x18,%esp
}
  801ade:	c9                   	leave  
  801adf:	c3                   	ret    

00801ae0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
  801ae3:	56                   	push   %esi
  801ae4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801ae5:	8b 75 18             	mov    0x18(%ebp),%esi
  801ae8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801aeb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801aee:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af1:	8b 45 08             	mov    0x8(%ebp),%eax
  801af4:	56                   	push   %esi
  801af5:	53                   	push   %ebx
  801af6:	51                   	push   %ecx
  801af7:	52                   	push   %edx
  801af8:	50                   	push   %eax
  801af9:	6a 06                	push   $0x6
  801afb:	e8 56 ff ff ff       	call   801a56 <syscall>
  801b00:	83 c4 18             	add    $0x18,%esp
}
  801b03:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b06:	5b                   	pop    %ebx
  801b07:	5e                   	pop    %esi
  801b08:	5d                   	pop    %ebp
  801b09:	c3                   	ret    

00801b0a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b10:	8b 45 08             	mov    0x8(%ebp),%eax
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	52                   	push   %edx
  801b1a:	50                   	push   %eax
  801b1b:	6a 07                	push   $0x7
  801b1d:	e8 34 ff ff ff       	call   801a56 <syscall>
  801b22:	83 c4 18             	add    $0x18,%esp
}
  801b25:	c9                   	leave  
  801b26:	c3                   	ret    

00801b27 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b27:	55                   	push   %ebp
  801b28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	ff 75 0c             	pushl  0xc(%ebp)
  801b33:	ff 75 08             	pushl  0x8(%ebp)
  801b36:	6a 08                	push   $0x8
  801b38:	e8 19 ff ff ff       	call   801a56 <syscall>
  801b3d:	83 c4 18             	add    $0x18,%esp
}
  801b40:	c9                   	leave  
  801b41:	c3                   	ret    

00801b42 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b42:	55                   	push   %ebp
  801b43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 09                	push   $0x9
  801b51:	e8 00 ff ff ff       	call   801a56 <syscall>
  801b56:	83 c4 18             	add    $0x18,%esp
}
  801b59:	c9                   	leave  
  801b5a:	c3                   	ret    

00801b5b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 0a                	push   $0xa
  801b6a:	e8 e7 fe ff ff       	call   801a56 <syscall>
  801b6f:	83 c4 18             	add    $0x18,%esp
}
  801b72:	c9                   	leave  
  801b73:	c3                   	ret    

00801b74 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b74:	55                   	push   %ebp
  801b75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 0b                	push   $0xb
  801b83:	e8 ce fe ff ff       	call   801a56 <syscall>
  801b88:	83 c4 18             	add    $0x18,%esp
}
  801b8b:	c9                   	leave  
  801b8c:	c3                   	ret    

00801b8d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b8d:	55                   	push   %ebp
  801b8e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	ff 75 0c             	pushl  0xc(%ebp)
  801b99:	ff 75 08             	pushl  0x8(%ebp)
  801b9c:	6a 0f                	push   $0xf
  801b9e:	e8 b3 fe ff ff       	call   801a56 <syscall>
  801ba3:	83 c4 18             	add    $0x18,%esp
	return;
  801ba6:	90                   	nop
}
  801ba7:	c9                   	leave  
  801ba8:	c3                   	ret    

00801ba9 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	ff 75 0c             	pushl  0xc(%ebp)
  801bb5:	ff 75 08             	pushl  0x8(%ebp)
  801bb8:	6a 10                	push   $0x10
  801bba:	e8 97 fe ff ff       	call   801a56 <syscall>
  801bbf:	83 c4 18             	add    $0x18,%esp
	return ;
  801bc2:	90                   	nop
}
  801bc3:	c9                   	leave  
  801bc4:	c3                   	ret    

00801bc5 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801bc5:	55                   	push   %ebp
  801bc6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	ff 75 10             	pushl  0x10(%ebp)
  801bcf:	ff 75 0c             	pushl  0xc(%ebp)
  801bd2:	ff 75 08             	pushl  0x8(%ebp)
  801bd5:	6a 11                	push   $0x11
  801bd7:	e8 7a fe ff ff       	call   801a56 <syscall>
  801bdc:	83 c4 18             	add    $0x18,%esp
	return ;
  801bdf:	90                   	nop
}
  801be0:	c9                   	leave  
  801be1:	c3                   	ret    

00801be2 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 0c                	push   $0xc
  801bf1:	e8 60 fe ff ff       	call   801a56 <syscall>
  801bf6:	83 c4 18             	add    $0x18,%esp
}
  801bf9:	c9                   	leave  
  801bfa:	c3                   	ret    

00801bfb <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801bfb:	55                   	push   %ebp
  801bfc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	ff 75 08             	pushl  0x8(%ebp)
  801c09:	6a 0d                	push   $0xd
  801c0b:	e8 46 fe ff ff       	call   801a56 <syscall>
  801c10:	83 c4 18             	add    $0x18,%esp
}
  801c13:	c9                   	leave  
  801c14:	c3                   	ret    

00801c15 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c15:	55                   	push   %ebp
  801c16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 0e                	push   $0xe
  801c24:	e8 2d fe ff ff       	call   801a56 <syscall>
  801c29:	83 c4 18             	add    $0x18,%esp
}
  801c2c:	90                   	nop
  801c2d:	c9                   	leave  
  801c2e:	c3                   	ret    

00801c2f <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801c2f:	55                   	push   %ebp
  801c30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 13                	push   $0x13
  801c3e:	e8 13 fe ff ff       	call   801a56 <syscall>
  801c43:	83 c4 18             	add    $0x18,%esp
}
  801c46:	90                   	nop
  801c47:	c9                   	leave  
  801c48:	c3                   	ret    

00801c49 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801c49:	55                   	push   %ebp
  801c4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 14                	push   $0x14
  801c58:	e8 f9 fd ff ff       	call   801a56 <syscall>
  801c5d:	83 c4 18             	add    $0x18,%esp
}
  801c60:	90                   	nop
  801c61:	c9                   	leave  
  801c62:	c3                   	ret    

00801c63 <sys_cputc>:


void
sys_cputc(const char c)
{
  801c63:	55                   	push   %ebp
  801c64:	89 e5                	mov    %esp,%ebp
  801c66:	83 ec 04             	sub    $0x4,%esp
  801c69:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c6f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	50                   	push   %eax
  801c7c:	6a 15                	push   $0x15
  801c7e:	e8 d3 fd ff ff       	call   801a56 <syscall>
  801c83:	83 c4 18             	add    $0x18,%esp
}
  801c86:	90                   	nop
  801c87:	c9                   	leave  
  801c88:	c3                   	ret    

00801c89 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 16                	push   $0x16
  801c98:	e8 b9 fd ff ff       	call   801a56 <syscall>
  801c9d:	83 c4 18             	add    $0x18,%esp
}
  801ca0:	90                   	nop
  801ca1:	c9                   	leave  
  801ca2:	c3                   	ret    

00801ca3 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801ca3:	55                   	push   %ebp
  801ca4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	ff 75 0c             	pushl  0xc(%ebp)
  801cb2:	50                   	push   %eax
  801cb3:	6a 17                	push   $0x17
  801cb5:	e8 9c fd ff ff       	call   801a56 <syscall>
  801cba:	83 c4 18             	add    $0x18,%esp
}
  801cbd:	c9                   	leave  
  801cbe:	c3                   	ret    

00801cbf <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801cbf:	55                   	push   %ebp
  801cc0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cc2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	52                   	push   %edx
  801ccf:	50                   	push   %eax
  801cd0:	6a 1a                	push   $0x1a
  801cd2:	e8 7f fd ff ff       	call   801a56 <syscall>
  801cd7:	83 c4 18             	add    $0x18,%esp
}
  801cda:	c9                   	leave  
  801cdb:	c3                   	ret    

00801cdc <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801cdc:	55                   	push   %ebp
  801cdd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cdf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	52                   	push   %edx
  801cec:	50                   	push   %eax
  801ced:	6a 18                	push   $0x18
  801cef:	e8 62 fd ff ff       	call   801a56 <syscall>
  801cf4:	83 c4 18             	add    $0x18,%esp
}
  801cf7:	90                   	nop
  801cf8:	c9                   	leave  
  801cf9:	c3                   	ret    

00801cfa <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801cfa:	55                   	push   %ebp
  801cfb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cfd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d00:	8b 45 08             	mov    0x8(%ebp),%eax
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	52                   	push   %edx
  801d0a:	50                   	push   %eax
  801d0b:	6a 19                	push   $0x19
  801d0d:	e8 44 fd ff ff       	call   801a56 <syscall>
  801d12:	83 c4 18             	add    $0x18,%esp
}
  801d15:	90                   	nop
  801d16:	c9                   	leave  
  801d17:	c3                   	ret    

00801d18 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d18:	55                   	push   %ebp
  801d19:	89 e5                	mov    %esp,%ebp
  801d1b:	83 ec 04             	sub    $0x4,%esp
  801d1e:	8b 45 10             	mov    0x10(%ebp),%eax
  801d21:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801d24:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d27:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2e:	6a 00                	push   $0x0
  801d30:	51                   	push   %ecx
  801d31:	52                   	push   %edx
  801d32:	ff 75 0c             	pushl  0xc(%ebp)
  801d35:	50                   	push   %eax
  801d36:	6a 1b                	push   $0x1b
  801d38:	e8 19 fd ff ff       	call   801a56 <syscall>
  801d3d:	83 c4 18             	add    $0x18,%esp
}
  801d40:	c9                   	leave  
  801d41:	c3                   	ret    

00801d42 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d48:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	52                   	push   %edx
  801d52:	50                   	push   %eax
  801d53:	6a 1c                	push   $0x1c
  801d55:	e8 fc fc ff ff       	call   801a56 <syscall>
  801d5a:	83 c4 18             	add    $0x18,%esp
}
  801d5d:	c9                   	leave  
  801d5e:	c3                   	ret    

00801d5f <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d62:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d65:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d68:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	51                   	push   %ecx
  801d70:	52                   	push   %edx
  801d71:	50                   	push   %eax
  801d72:	6a 1d                	push   $0x1d
  801d74:	e8 dd fc ff ff       	call   801a56 <syscall>
  801d79:	83 c4 18             	add    $0x18,%esp
}
  801d7c:	c9                   	leave  
  801d7d:	c3                   	ret    

00801d7e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d7e:	55                   	push   %ebp
  801d7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d81:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d84:	8b 45 08             	mov    0x8(%ebp),%eax
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	52                   	push   %edx
  801d8e:	50                   	push   %eax
  801d8f:	6a 1e                	push   $0x1e
  801d91:	e8 c0 fc ff ff       	call   801a56 <syscall>
  801d96:	83 c4 18             	add    $0x18,%esp
}
  801d99:	c9                   	leave  
  801d9a:	c3                   	ret    

00801d9b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801d9b:	55                   	push   %ebp
  801d9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 1f                	push   $0x1f
  801daa:	e8 a7 fc ff ff       	call   801a56 <syscall>
  801daf:	83 c4 18             	add    $0x18,%esp
}
  801db2:	c9                   	leave  
  801db3:	c3                   	ret    

00801db4 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801db4:	55                   	push   %ebp
  801db5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801db7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dba:	6a 00                	push   $0x0
  801dbc:	ff 75 14             	pushl  0x14(%ebp)
  801dbf:	ff 75 10             	pushl  0x10(%ebp)
  801dc2:	ff 75 0c             	pushl  0xc(%ebp)
  801dc5:	50                   	push   %eax
  801dc6:	6a 20                	push   $0x20
  801dc8:	e8 89 fc ff ff       	call   801a56 <syscall>
  801dcd:	83 c4 18             	add    $0x18,%esp
}
  801dd0:	c9                   	leave  
  801dd1:	c3                   	ret    

00801dd2 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801dd2:	55                   	push   %ebp
  801dd3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	50                   	push   %eax
  801de1:	6a 21                	push   $0x21
  801de3:	e8 6e fc ff ff       	call   801a56 <syscall>
  801de8:	83 c4 18             	add    $0x18,%esp
}
  801deb:	90                   	nop
  801dec:	c9                   	leave  
  801ded:	c3                   	ret    

00801dee <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801dee:	55                   	push   %ebp
  801def:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801df1:	8b 45 08             	mov    0x8(%ebp),%eax
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	50                   	push   %eax
  801dfd:	6a 22                	push   $0x22
  801dff:	e8 52 fc ff ff       	call   801a56 <syscall>
  801e04:	83 c4 18             	add    $0x18,%esp
}
  801e07:	c9                   	leave  
  801e08:	c3                   	ret    

00801e09 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801e09:	55                   	push   %ebp
  801e0a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	6a 02                	push   $0x2
  801e18:	e8 39 fc ff ff       	call   801a56 <syscall>
  801e1d:	83 c4 18             	add    $0x18,%esp
}
  801e20:	c9                   	leave  
  801e21:	c3                   	ret    

00801e22 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 03                	push   $0x3
  801e31:	e8 20 fc ff ff       	call   801a56 <syscall>
  801e36:	83 c4 18             	add    $0x18,%esp
}
  801e39:	c9                   	leave  
  801e3a:	c3                   	ret    

00801e3b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801e3b:	55                   	push   %ebp
  801e3c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 04                	push   $0x4
  801e4a:	e8 07 fc ff ff       	call   801a56 <syscall>
  801e4f:	83 c4 18             	add    $0x18,%esp
}
  801e52:	c9                   	leave  
  801e53:	c3                   	ret    

00801e54 <sys_exit_env>:


void sys_exit_env(void)
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e57:	6a 00                	push   $0x0
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 23                	push   $0x23
  801e63:	e8 ee fb ff ff       	call   801a56 <syscall>
  801e68:	83 c4 18             	add    $0x18,%esp
}
  801e6b:	90                   	nop
  801e6c:	c9                   	leave  
  801e6d:	c3                   	ret    

00801e6e <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801e6e:	55                   	push   %ebp
  801e6f:	89 e5                	mov    %esp,%ebp
  801e71:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e74:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e77:	8d 50 04             	lea    0x4(%eax),%edx
  801e7a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	52                   	push   %edx
  801e84:	50                   	push   %eax
  801e85:	6a 24                	push   $0x24
  801e87:	e8 ca fb ff ff       	call   801a56 <syscall>
  801e8c:	83 c4 18             	add    $0x18,%esp
	return result;
  801e8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e92:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e95:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e98:	89 01                	mov    %eax,(%ecx)
  801e9a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea0:	c9                   	leave  
  801ea1:	c2 04 00             	ret    $0x4

00801ea4 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ea4:	55                   	push   %ebp
  801ea5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 00                	push   $0x0
  801eab:	ff 75 10             	pushl  0x10(%ebp)
  801eae:	ff 75 0c             	pushl  0xc(%ebp)
  801eb1:	ff 75 08             	pushl  0x8(%ebp)
  801eb4:	6a 12                	push   $0x12
  801eb6:	e8 9b fb ff ff       	call   801a56 <syscall>
  801ebb:	83 c4 18             	add    $0x18,%esp
	return ;
  801ebe:	90                   	nop
}
  801ebf:	c9                   	leave  
  801ec0:	c3                   	ret    

00801ec1 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ec1:	55                   	push   %ebp
  801ec2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 25                	push   $0x25
  801ed0:	e8 81 fb ff ff       	call   801a56 <syscall>
  801ed5:	83 c4 18             	add    $0x18,%esp
}
  801ed8:	c9                   	leave  
  801ed9:	c3                   	ret    

00801eda <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801eda:	55                   	push   %ebp
  801edb:	89 e5                	mov    %esp,%ebp
  801edd:	83 ec 04             	sub    $0x4,%esp
  801ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ee6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 00                	push   $0x0
  801ef2:	50                   	push   %eax
  801ef3:	6a 26                	push   $0x26
  801ef5:	e8 5c fb ff ff       	call   801a56 <syscall>
  801efa:	83 c4 18             	add    $0x18,%esp
	return ;
  801efd:	90                   	nop
}
  801efe:	c9                   	leave  
  801eff:	c3                   	ret    

00801f00 <rsttst>:
void rsttst()
{
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f03:	6a 00                	push   $0x0
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 00                	push   $0x0
  801f0d:	6a 28                	push   $0x28
  801f0f:	e8 42 fb ff ff       	call   801a56 <syscall>
  801f14:	83 c4 18             	add    $0x18,%esp
	return ;
  801f17:	90                   	nop
}
  801f18:	c9                   	leave  
  801f19:	c3                   	ret    

00801f1a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801f1a:	55                   	push   %ebp
  801f1b:	89 e5                	mov    %esp,%ebp
  801f1d:	83 ec 04             	sub    $0x4,%esp
  801f20:	8b 45 14             	mov    0x14(%ebp),%eax
  801f23:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f26:	8b 55 18             	mov    0x18(%ebp),%edx
  801f29:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f2d:	52                   	push   %edx
  801f2e:	50                   	push   %eax
  801f2f:	ff 75 10             	pushl  0x10(%ebp)
  801f32:	ff 75 0c             	pushl  0xc(%ebp)
  801f35:	ff 75 08             	pushl  0x8(%ebp)
  801f38:	6a 27                	push   $0x27
  801f3a:	e8 17 fb ff ff       	call   801a56 <syscall>
  801f3f:	83 c4 18             	add    $0x18,%esp
	return ;
  801f42:	90                   	nop
}
  801f43:	c9                   	leave  
  801f44:	c3                   	ret    

00801f45 <chktst>:
void chktst(uint32 n)
{
  801f45:	55                   	push   %ebp
  801f46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	ff 75 08             	pushl  0x8(%ebp)
  801f53:	6a 29                	push   $0x29
  801f55:	e8 fc fa ff ff       	call   801a56 <syscall>
  801f5a:	83 c4 18             	add    $0x18,%esp
	return ;
  801f5d:	90                   	nop
}
  801f5e:	c9                   	leave  
  801f5f:	c3                   	ret    

00801f60 <inctst>:

void inctst()
{
  801f60:	55                   	push   %ebp
  801f61:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f63:	6a 00                	push   $0x0
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	6a 00                	push   $0x0
  801f6b:	6a 00                	push   $0x0
  801f6d:	6a 2a                	push   $0x2a
  801f6f:	e8 e2 fa ff ff       	call   801a56 <syscall>
  801f74:	83 c4 18             	add    $0x18,%esp
	return ;
  801f77:	90                   	nop
}
  801f78:	c9                   	leave  
  801f79:	c3                   	ret    

00801f7a <gettst>:
uint32 gettst()
{
  801f7a:	55                   	push   %ebp
  801f7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	6a 2b                	push   $0x2b
  801f89:	e8 c8 fa ff ff       	call   801a56 <syscall>
  801f8e:	83 c4 18             	add    $0x18,%esp
}
  801f91:	c9                   	leave  
  801f92:	c3                   	ret    

00801f93 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f93:	55                   	push   %ebp
  801f94:	89 e5                	mov    %esp,%ebp
  801f96:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 00                	push   $0x0
  801fa1:	6a 00                	push   $0x0
  801fa3:	6a 2c                	push   $0x2c
  801fa5:	e8 ac fa ff ff       	call   801a56 <syscall>
  801faa:	83 c4 18             	add    $0x18,%esp
  801fad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801fb0:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801fb4:	75 07                	jne    801fbd <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801fb6:	b8 01 00 00 00       	mov    $0x1,%eax
  801fbb:	eb 05                	jmp    801fc2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801fbd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fc2:	c9                   	leave  
  801fc3:	c3                   	ret    

00801fc4 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801fc4:	55                   	push   %ebp
  801fc5:	89 e5                	mov    %esp,%ebp
  801fc7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fca:	6a 00                	push   $0x0
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 2c                	push   $0x2c
  801fd6:	e8 7b fa ff ff       	call   801a56 <syscall>
  801fdb:	83 c4 18             	add    $0x18,%esp
  801fde:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801fe1:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801fe5:	75 07                	jne    801fee <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801fe7:	b8 01 00 00 00       	mov    $0x1,%eax
  801fec:	eb 05                	jmp    801ff3 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801fee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ff3:	c9                   	leave  
  801ff4:	c3                   	ret    

00801ff5 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ff5:	55                   	push   %ebp
  801ff6:	89 e5                	mov    %esp,%ebp
  801ff8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ffb:	6a 00                	push   $0x0
  801ffd:	6a 00                	push   $0x0
  801fff:	6a 00                	push   $0x0
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	6a 2c                	push   $0x2c
  802007:	e8 4a fa ff ff       	call   801a56 <syscall>
  80200c:	83 c4 18             	add    $0x18,%esp
  80200f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802012:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802016:	75 07                	jne    80201f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802018:	b8 01 00 00 00       	mov    $0x1,%eax
  80201d:	eb 05                	jmp    802024 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80201f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802024:	c9                   	leave  
  802025:	c3                   	ret    

00802026 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802026:	55                   	push   %ebp
  802027:	89 e5                	mov    %esp,%ebp
  802029:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80202c:	6a 00                	push   $0x0
  80202e:	6a 00                	push   $0x0
  802030:	6a 00                	push   $0x0
  802032:	6a 00                	push   $0x0
  802034:	6a 00                	push   $0x0
  802036:	6a 2c                	push   $0x2c
  802038:	e8 19 fa ff ff       	call   801a56 <syscall>
  80203d:	83 c4 18             	add    $0x18,%esp
  802040:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802043:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802047:	75 07                	jne    802050 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802049:	b8 01 00 00 00       	mov    $0x1,%eax
  80204e:	eb 05                	jmp    802055 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802050:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802055:	c9                   	leave  
  802056:	c3                   	ret    

00802057 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802057:	55                   	push   %ebp
  802058:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80205a:	6a 00                	push   $0x0
  80205c:	6a 00                	push   $0x0
  80205e:	6a 00                	push   $0x0
  802060:	6a 00                	push   $0x0
  802062:	ff 75 08             	pushl  0x8(%ebp)
  802065:	6a 2d                	push   $0x2d
  802067:	e8 ea f9 ff ff       	call   801a56 <syscall>
  80206c:	83 c4 18             	add    $0x18,%esp
	return ;
  80206f:	90                   	nop
}
  802070:	c9                   	leave  
  802071:	c3                   	ret    

00802072 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802072:	55                   	push   %ebp
  802073:	89 e5                	mov    %esp,%ebp
  802075:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802076:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802079:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80207c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80207f:	8b 45 08             	mov    0x8(%ebp),%eax
  802082:	6a 00                	push   $0x0
  802084:	53                   	push   %ebx
  802085:	51                   	push   %ecx
  802086:	52                   	push   %edx
  802087:	50                   	push   %eax
  802088:	6a 2e                	push   $0x2e
  80208a:	e8 c7 f9 ff ff       	call   801a56 <syscall>
  80208f:	83 c4 18             	add    $0x18,%esp
}
  802092:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802095:	c9                   	leave  
  802096:	c3                   	ret    

00802097 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802097:	55                   	push   %ebp
  802098:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80209a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80209d:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a0:	6a 00                	push   $0x0
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 00                	push   $0x0
  8020a6:	52                   	push   %edx
  8020a7:	50                   	push   %eax
  8020a8:	6a 2f                	push   $0x2f
  8020aa:	e8 a7 f9 ff ff       	call   801a56 <syscall>
  8020af:	83 c4 18             	add    $0x18,%esp
}
  8020b2:	c9                   	leave  
  8020b3:	c3                   	ret    

008020b4 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8020b4:	55                   	push   %ebp
  8020b5:	89 e5                	mov    %esp,%ebp
  8020b7:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8020ba:	83 ec 0c             	sub    $0xc,%esp
  8020bd:	68 80 3d 80 00       	push   $0x803d80
  8020c2:	e8 c3 e6 ff ff       	call   80078a <cprintf>
  8020c7:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8020ca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8020d1:	83 ec 0c             	sub    $0xc,%esp
  8020d4:	68 ac 3d 80 00       	push   $0x803dac
  8020d9:	e8 ac e6 ff ff       	call   80078a <cprintf>
  8020de:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8020e1:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8020e5:	a1 38 41 80 00       	mov    0x804138,%eax
  8020ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020ed:	eb 56                	jmp    802145 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020f3:	74 1c                	je     802111 <print_mem_block_lists+0x5d>
  8020f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f8:	8b 50 08             	mov    0x8(%eax),%edx
  8020fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020fe:	8b 48 08             	mov    0x8(%eax),%ecx
  802101:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802104:	8b 40 0c             	mov    0xc(%eax),%eax
  802107:	01 c8                	add    %ecx,%eax
  802109:	39 c2                	cmp    %eax,%edx
  80210b:	73 04                	jae    802111 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80210d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802111:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802114:	8b 50 08             	mov    0x8(%eax),%edx
  802117:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211a:	8b 40 0c             	mov    0xc(%eax),%eax
  80211d:	01 c2                	add    %eax,%edx
  80211f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802122:	8b 40 08             	mov    0x8(%eax),%eax
  802125:	83 ec 04             	sub    $0x4,%esp
  802128:	52                   	push   %edx
  802129:	50                   	push   %eax
  80212a:	68 c1 3d 80 00       	push   $0x803dc1
  80212f:	e8 56 e6 ff ff       	call   80078a <cprintf>
  802134:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802137:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80213d:	a1 40 41 80 00       	mov    0x804140,%eax
  802142:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802145:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802149:	74 07                	je     802152 <print_mem_block_lists+0x9e>
  80214b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214e:	8b 00                	mov    (%eax),%eax
  802150:	eb 05                	jmp    802157 <print_mem_block_lists+0xa3>
  802152:	b8 00 00 00 00       	mov    $0x0,%eax
  802157:	a3 40 41 80 00       	mov    %eax,0x804140
  80215c:	a1 40 41 80 00       	mov    0x804140,%eax
  802161:	85 c0                	test   %eax,%eax
  802163:	75 8a                	jne    8020ef <print_mem_block_lists+0x3b>
  802165:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802169:	75 84                	jne    8020ef <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80216b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80216f:	75 10                	jne    802181 <print_mem_block_lists+0xcd>
  802171:	83 ec 0c             	sub    $0xc,%esp
  802174:	68 d0 3d 80 00       	push   $0x803dd0
  802179:	e8 0c e6 ff ff       	call   80078a <cprintf>
  80217e:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802181:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802188:	83 ec 0c             	sub    $0xc,%esp
  80218b:	68 f4 3d 80 00       	push   $0x803df4
  802190:	e8 f5 e5 ff ff       	call   80078a <cprintf>
  802195:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802198:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80219c:	a1 40 40 80 00       	mov    0x804040,%eax
  8021a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021a4:	eb 56                	jmp    8021fc <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8021a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021aa:	74 1c                	je     8021c8 <print_mem_block_lists+0x114>
  8021ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021af:	8b 50 08             	mov    0x8(%eax),%edx
  8021b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b5:	8b 48 08             	mov    0x8(%eax),%ecx
  8021b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8021be:	01 c8                	add    %ecx,%eax
  8021c0:	39 c2                	cmp    %eax,%edx
  8021c2:	73 04                	jae    8021c8 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8021c4:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8021c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cb:	8b 50 08             	mov    0x8(%eax),%edx
  8021ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8021d4:	01 c2                	add    %eax,%edx
  8021d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d9:	8b 40 08             	mov    0x8(%eax),%eax
  8021dc:	83 ec 04             	sub    $0x4,%esp
  8021df:	52                   	push   %edx
  8021e0:	50                   	push   %eax
  8021e1:	68 c1 3d 80 00       	push   $0x803dc1
  8021e6:	e8 9f e5 ff ff       	call   80078a <cprintf>
  8021eb:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8021ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8021f4:	a1 48 40 80 00       	mov    0x804048,%eax
  8021f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802200:	74 07                	je     802209 <print_mem_block_lists+0x155>
  802202:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802205:	8b 00                	mov    (%eax),%eax
  802207:	eb 05                	jmp    80220e <print_mem_block_lists+0x15a>
  802209:	b8 00 00 00 00       	mov    $0x0,%eax
  80220e:	a3 48 40 80 00       	mov    %eax,0x804048
  802213:	a1 48 40 80 00       	mov    0x804048,%eax
  802218:	85 c0                	test   %eax,%eax
  80221a:	75 8a                	jne    8021a6 <print_mem_block_lists+0xf2>
  80221c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802220:	75 84                	jne    8021a6 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802222:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802226:	75 10                	jne    802238 <print_mem_block_lists+0x184>
  802228:	83 ec 0c             	sub    $0xc,%esp
  80222b:	68 0c 3e 80 00       	push   $0x803e0c
  802230:	e8 55 e5 ff ff       	call   80078a <cprintf>
  802235:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802238:	83 ec 0c             	sub    $0xc,%esp
  80223b:	68 80 3d 80 00       	push   $0x803d80
  802240:	e8 45 e5 ff ff       	call   80078a <cprintf>
  802245:	83 c4 10             	add    $0x10,%esp

}
  802248:	90                   	nop
  802249:	c9                   	leave  
  80224a:	c3                   	ret    

0080224b <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80224b:	55                   	push   %ebp
  80224c:	89 e5                	mov    %esp,%ebp
  80224e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  802251:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802258:	00 00 00 
  80225b:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802262:	00 00 00 
  802265:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  80226c:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  80226f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802276:	e9 9e 00 00 00       	jmp    802319 <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  80227b:	a1 50 40 80 00       	mov    0x804050,%eax
  802280:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802283:	c1 e2 04             	shl    $0x4,%edx
  802286:	01 d0                	add    %edx,%eax
  802288:	85 c0                	test   %eax,%eax
  80228a:	75 14                	jne    8022a0 <initialize_MemBlocksList+0x55>
  80228c:	83 ec 04             	sub    $0x4,%esp
  80228f:	68 34 3e 80 00       	push   $0x803e34
  802294:	6a 47                	push   $0x47
  802296:	68 57 3e 80 00       	push   $0x803e57
  80229b:	e8 36 e2 ff ff       	call   8004d6 <_panic>
  8022a0:	a1 50 40 80 00       	mov    0x804050,%eax
  8022a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022a8:	c1 e2 04             	shl    $0x4,%edx
  8022ab:	01 d0                	add    %edx,%eax
  8022ad:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8022b3:	89 10                	mov    %edx,(%eax)
  8022b5:	8b 00                	mov    (%eax),%eax
  8022b7:	85 c0                	test   %eax,%eax
  8022b9:	74 18                	je     8022d3 <initialize_MemBlocksList+0x88>
  8022bb:	a1 48 41 80 00       	mov    0x804148,%eax
  8022c0:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8022c6:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8022c9:	c1 e1 04             	shl    $0x4,%ecx
  8022cc:	01 ca                	add    %ecx,%edx
  8022ce:	89 50 04             	mov    %edx,0x4(%eax)
  8022d1:	eb 12                	jmp    8022e5 <initialize_MemBlocksList+0x9a>
  8022d3:	a1 50 40 80 00       	mov    0x804050,%eax
  8022d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022db:	c1 e2 04             	shl    $0x4,%edx
  8022de:	01 d0                	add    %edx,%eax
  8022e0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8022e5:	a1 50 40 80 00       	mov    0x804050,%eax
  8022ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ed:	c1 e2 04             	shl    $0x4,%edx
  8022f0:	01 d0                	add    %edx,%eax
  8022f2:	a3 48 41 80 00       	mov    %eax,0x804148
  8022f7:	a1 50 40 80 00       	mov    0x804050,%eax
  8022fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ff:	c1 e2 04             	shl    $0x4,%edx
  802302:	01 d0                	add    %edx,%eax
  802304:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80230b:	a1 54 41 80 00       	mov    0x804154,%eax
  802310:	40                   	inc    %eax
  802311:	a3 54 41 80 00       	mov    %eax,0x804154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802316:	ff 45 f4             	incl   -0xc(%ebp)
  802319:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80231f:	0f 82 56 ff ff ff    	jb     80227b <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  802325:	90                   	nop
  802326:	c9                   	leave  
  802327:	c3                   	ret    

00802328 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802328:	55                   	push   %ebp
  802329:	89 e5                	mov    %esp,%ebp
  80232b:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  80232e:	8b 45 08             	mov    0x8(%ebp),%eax
  802331:	8b 00                	mov    (%eax),%eax
  802333:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802336:	eb 19                	jmp    802351 <find_block+0x29>
	{
		if(element->sva == va){
  802338:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80233b:	8b 40 08             	mov    0x8(%eax),%eax
  80233e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802341:	75 05                	jne    802348 <find_block+0x20>
			 		return element;
  802343:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802346:	eb 36                	jmp    80237e <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802348:	8b 45 08             	mov    0x8(%ebp),%eax
  80234b:	8b 40 08             	mov    0x8(%eax),%eax
  80234e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802351:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802355:	74 07                	je     80235e <find_block+0x36>
  802357:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80235a:	8b 00                	mov    (%eax),%eax
  80235c:	eb 05                	jmp    802363 <find_block+0x3b>
  80235e:	b8 00 00 00 00       	mov    $0x0,%eax
  802363:	8b 55 08             	mov    0x8(%ebp),%edx
  802366:	89 42 08             	mov    %eax,0x8(%edx)
  802369:	8b 45 08             	mov    0x8(%ebp),%eax
  80236c:	8b 40 08             	mov    0x8(%eax),%eax
  80236f:	85 c0                	test   %eax,%eax
  802371:	75 c5                	jne    802338 <find_block+0x10>
  802373:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802377:	75 bf                	jne    802338 <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  802379:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80237e:	c9                   	leave  
  80237f:	c3                   	ret    

00802380 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802380:	55                   	push   %ebp
  802381:	89 e5                	mov    %esp,%ebp
  802383:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  802386:	a1 44 40 80 00       	mov    0x804044,%eax
  80238b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  80238e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802393:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  802396:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80239a:	74 0a                	je     8023a6 <insert_sorted_allocList+0x26>
  80239c:	8b 45 08             	mov    0x8(%ebp),%eax
  80239f:	8b 40 08             	mov    0x8(%eax),%eax
  8023a2:	85 c0                	test   %eax,%eax
  8023a4:	75 65                	jne    80240b <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8023a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023aa:	75 14                	jne    8023c0 <insert_sorted_allocList+0x40>
  8023ac:	83 ec 04             	sub    $0x4,%esp
  8023af:	68 34 3e 80 00       	push   $0x803e34
  8023b4:	6a 6e                	push   $0x6e
  8023b6:	68 57 3e 80 00       	push   $0x803e57
  8023bb:	e8 16 e1 ff ff       	call   8004d6 <_panic>
  8023c0:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8023c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c9:	89 10                	mov    %edx,(%eax)
  8023cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ce:	8b 00                	mov    (%eax),%eax
  8023d0:	85 c0                	test   %eax,%eax
  8023d2:	74 0d                	je     8023e1 <insert_sorted_allocList+0x61>
  8023d4:	a1 40 40 80 00       	mov    0x804040,%eax
  8023d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8023dc:	89 50 04             	mov    %edx,0x4(%eax)
  8023df:	eb 08                	jmp    8023e9 <insert_sorted_allocList+0x69>
  8023e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e4:	a3 44 40 80 00       	mov    %eax,0x804044
  8023e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ec:	a3 40 40 80 00       	mov    %eax,0x804040
  8023f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023fb:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802400:	40                   	inc    %eax
  802401:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802406:	e9 cf 01 00 00       	jmp    8025da <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  80240b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80240e:	8b 50 08             	mov    0x8(%eax),%edx
  802411:	8b 45 08             	mov    0x8(%ebp),%eax
  802414:	8b 40 08             	mov    0x8(%eax),%eax
  802417:	39 c2                	cmp    %eax,%edx
  802419:	73 65                	jae    802480 <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80241b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80241f:	75 14                	jne    802435 <insert_sorted_allocList+0xb5>
  802421:	83 ec 04             	sub    $0x4,%esp
  802424:	68 70 3e 80 00       	push   $0x803e70
  802429:	6a 72                	push   $0x72
  80242b:	68 57 3e 80 00       	push   $0x803e57
  802430:	e8 a1 e0 ff ff       	call   8004d6 <_panic>
  802435:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80243b:	8b 45 08             	mov    0x8(%ebp),%eax
  80243e:	89 50 04             	mov    %edx,0x4(%eax)
  802441:	8b 45 08             	mov    0x8(%ebp),%eax
  802444:	8b 40 04             	mov    0x4(%eax),%eax
  802447:	85 c0                	test   %eax,%eax
  802449:	74 0c                	je     802457 <insert_sorted_allocList+0xd7>
  80244b:	a1 44 40 80 00       	mov    0x804044,%eax
  802450:	8b 55 08             	mov    0x8(%ebp),%edx
  802453:	89 10                	mov    %edx,(%eax)
  802455:	eb 08                	jmp    80245f <insert_sorted_allocList+0xdf>
  802457:	8b 45 08             	mov    0x8(%ebp),%eax
  80245a:	a3 40 40 80 00       	mov    %eax,0x804040
  80245f:	8b 45 08             	mov    0x8(%ebp),%eax
  802462:	a3 44 40 80 00       	mov    %eax,0x804044
  802467:	8b 45 08             	mov    0x8(%ebp),%eax
  80246a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802470:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802475:	40                   	inc    %eax
  802476:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  80247b:	e9 5a 01 00 00       	jmp    8025da <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  802480:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802483:	8b 50 08             	mov    0x8(%eax),%edx
  802486:	8b 45 08             	mov    0x8(%ebp),%eax
  802489:	8b 40 08             	mov    0x8(%eax),%eax
  80248c:	39 c2                	cmp    %eax,%edx
  80248e:	75 70                	jne    802500 <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  802490:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802494:	74 06                	je     80249c <insert_sorted_allocList+0x11c>
  802496:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80249a:	75 14                	jne    8024b0 <insert_sorted_allocList+0x130>
  80249c:	83 ec 04             	sub    $0x4,%esp
  80249f:	68 94 3e 80 00       	push   $0x803e94
  8024a4:	6a 75                	push   $0x75
  8024a6:	68 57 3e 80 00       	push   $0x803e57
  8024ab:	e8 26 e0 ff ff       	call   8004d6 <_panic>
  8024b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b3:	8b 10                	mov    (%eax),%edx
  8024b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b8:	89 10                	mov    %edx,(%eax)
  8024ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bd:	8b 00                	mov    (%eax),%eax
  8024bf:	85 c0                	test   %eax,%eax
  8024c1:	74 0b                	je     8024ce <insert_sorted_allocList+0x14e>
  8024c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c6:	8b 00                	mov    (%eax),%eax
  8024c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8024cb:	89 50 04             	mov    %edx,0x4(%eax)
  8024ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8024d4:	89 10                	mov    %edx,(%eax)
  8024d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024dc:	89 50 04             	mov    %edx,0x4(%eax)
  8024df:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e2:	8b 00                	mov    (%eax),%eax
  8024e4:	85 c0                	test   %eax,%eax
  8024e6:	75 08                	jne    8024f0 <insert_sorted_allocList+0x170>
  8024e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024eb:	a3 44 40 80 00       	mov    %eax,0x804044
  8024f0:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8024f5:	40                   	inc    %eax
  8024f6:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  8024fb:	e9 da 00 00 00       	jmp    8025da <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802500:	a1 40 40 80 00       	mov    0x804040,%eax
  802505:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802508:	e9 9d 00 00 00       	jmp    8025aa <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  80250d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802510:	8b 00                	mov    (%eax),%eax
  802512:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  802515:	8b 45 08             	mov    0x8(%ebp),%eax
  802518:	8b 50 08             	mov    0x8(%eax),%edx
  80251b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251e:	8b 40 08             	mov    0x8(%eax),%eax
  802521:	39 c2                	cmp    %eax,%edx
  802523:	76 7d                	jbe    8025a2 <insert_sorted_allocList+0x222>
  802525:	8b 45 08             	mov    0x8(%ebp),%eax
  802528:	8b 50 08             	mov    0x8(%eax),%edx
  80252b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80252e:	8b 40 08             	mov    0x8(%eax),%eax
  802531:	39 c2                	cmp    %eax,%edx
  802533:	73 6d                	jae    8025a2 <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802535:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802539:	74 06                	je     802541 <insert_sorted_allocList+0x1c1>
  80253b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80253f:	75 14                	jne    802555 <insert_sorted_allocList+0x1d5>
  802541:	83 ec 04             	sub    $0x4,%esp
  802544:	68 94 3e 80 00       	push   $0x803e94
  802549:	6a 7c                	push   $0x7c
  80254b:	68 57 3e 80 00       	push   $0x803e57
  802550:	e8 81 df ff ff       	call   8004d6 <_panic>
  802555:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802558:	8b 10                	mov    (%eax),%edx
  80255a:	8b 45 08             	mov    0x8(%ebp),%eax
  80255d:	89 10                	mov    %edx,(%eax)
  80255f:	8b 45 08             	mov    0x8(%ebp),%eax
  802562:	8b 00                	mov    (%eax),%eax
  802564:	85 c0                	test   %eax,%eax
  802566:	74 0b                	je     802573 <insert_sorted_allocList+0x1f3>
  802568:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256b:	8b 00                	mov    (%eax),%eax
  80256d:	8b 55 08             	mov    0x8(%ebp),%edx
  802570:	89 50 04             	mov    %edx,0x4(%eax)
  802573:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802576:	8b 55 08             	mov    0x8(%ebp),%edx
  802579:	89 10                	mov    %edx,(%eax)
  80257b:	8b 45 08             	mov    0x8(%ebp),%eax
  80257e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802581:	89 50 04             	mov    %edx,0x4(%eax)
  802584:	8b 45 08             	mov    0x8(%ebp),%eax
  802587:	8b 00                	mov    (%eax),%eax
  802589:	85 c0                	test   %eax,%eax
  80258b:	75 08                	jne    802595 <insert_sorted_allocList+0x215>
  80258d:	8b 45 08             	mov    0x8(%ebp),%eax
  802590:	a3 44 40 80 00       	mov    %eax,0x804044
  802595:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80259a:	40                   	inc    %eax
  80259b:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8025a0:	eb 38                	jmp    8025da <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  8025a2:	a1 48 40 80 00       	mov    0x804048,%eax
  8025a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ae:	74 07                	je     8025b7 <insert_sorted_allocList+0x237>
  8025b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b3:	8b 00                	mov    (%eax),%eax
  8025b5:	eb 05                	jmp    8025bc <insert_sorted_allocList+0x23c>
  8025b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8025bc:	a3 48 40 80 00       	mov    %eax,0x804048
  8025c1:	a1 48 40 80 00       	mov    0x804048,%eax
  8025c6:	85 c0                	test   %eax,%eax
  8025c8:	0f 85 3f ff ff ff    	jne    80250d <insert_sorted_allocList+0x18d>
  8025ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025d2:	0f 85 35 ff ff ff    	jne    80250d <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  8025d8:	eb 00                	jmp    8025da <insert_sorted_allocList+0x25a>
  8025da:	90                   	nop
  8025db:	c9                   	leave  
  8025dc:	c3                   	ret    

008025dd <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8025dd:	55                   	push   %ebp
  8025de:	89 e5                	mov    %esp,%ebp
  8025e0:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  8025e3:	a1 38 41 80 00       	mov    0x804138,%eax
  8025e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025eb:	e9 6b 02 00 00       	jmp    80285b <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  8025f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025f9:	0f 85 90 00 00 00    	jne    80268f <alloc_block_FF+0xb2>
			  temp=element;
  8025ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802602:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  802605:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802609:	75 17                	jne    802622 <alloc_block_FF+0x45>
  80260b:	83 ec 04             	sub    $0x4,%esp
  80260e:	68 c8 3e 80 00       	push   $0x803ec8
  802613:	68 92 00 00 00       	push   $0x92
  802618:	68 57 3e 80 00       	push   $0x803e57
  80261d:	e8 b4 de ff ff       	call   8004d6 <_panic>
  802622:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802625:	8b 00                	mov    (%eax),%eax
  802627:	85 c0                	test   %eax,%eax
  802629:	74 10                	je     80263b <alloc_block_FF+0x5e>
  80262b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262e:	8b 00                	mov    (%eax),%eax
  802630:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802633:	8b 52 04             	mov    0x4(%edx),%edx
  802636:	89 50 04             	mov    %edx,0x4(%eax)
  802639:	eb 0b                	jmp    802646 <alloc_block_FF+0x69>
  80263b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263e:	8b 40 04             	mov    0x4(%eax),%eax
  802641:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802646:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802649:	8b 40 04             	mov    0x4(%eax),%eax
  80264c:	85 c0                	test   %eax,%eax
  80264e:	74 0f                	je     80265f <alloc_block_FF+0x82>
  802650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802653:	8b 40 04             	mov    0x4(%eax),%eax
  802656:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802659:	8b 12                	mov    (%edx),%edx
  80265b:	89 10                	mov    %edx,(%eax)
  80265d:	eb 0a                	jmp    802669 <alloc_block_FF+0x8c>
  80265f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802662:	8b 00                	mov    (%eax),%eax
  802664:	a3 38 41 80 00       	mov    %eax,0x804138
  802669:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802675:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80267c:	a1 44 41 80 00       	mov    0x804144,%eax
  802681:	48                   	dec    %eax
  802682:	a3 44 41 80 00       	mov    %eax,0x804144
			  return temp;
  802687:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80268a:	e9 ff 01 00 00       	jmp    80288e <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  80268f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802692:	8b 40 0c             	mov    0xc(%eax),%eax
  802695:	3b 45 08             	cmp    0x8(%ebp),%eax
  802698:	0f 86 b5 01 00 00    	jbe    802853 <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  80269e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8026a4:	2b 45 08             	sub    0x8(%ebp),%eax
  8026a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  8026aa:	a1 48 41 80 00       	mov    0x804148,%eax
  8026af:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  8026b2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026b6:	75 17                	jne    8026cf <alloc_block_FF+0xf2>
  8026b8:	83 ec 04             	sub    $0x4,%esp
  8026bb:	68 c8 3e 80 00       	push   $0x803ec8
  8026c0:	68 99 00 00 00       	push   $0x99
  8026c5:	68 57 3e 80 00       	push   $0x803e57
  8026ca:	e8 07 de ff ff       	call   8004d6 <_panic>
  8026cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d2:	8b 00                	mov    (%eax),%eax
  8026d4:	85 c0                	test   %eax,%eax
  8026d6:	74 10                	je     8026e8 <alloc_block_FF+0x10b>
  8026d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026db:	8b 00                	mov    (%eax),%eax
  8026dd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026e0:	8b 52 04             	mov    0x4(%edx),%edx
  8026e3:	89 50 04             	mov    %edx,0x4(%eax)
  8026e6:	eb 0b                	jmp    8026f3 <alloc_block_FF+0x116>
  8026e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026eb:	8b 40 04             	mov    0x4(%eax),%eax
  8026ee:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8026f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f6:	8b 40 04             	mov    0x4(%eax),%eax
  8026f9:	85 c0                	test   %eax,%eax
  8026fb:	74 0f                	je     80270c <alloc_block_FF+0x12f>
  8026fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802700:	8b 40 04             	mov    0x4(%eax),%eax
  802703:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802706:	8b 12                	mov    (%edx),%edx
  802708:	89 10                	mov    %edx,(%eax)
  80270a:	eb 0a                	jmp    802716 <alloc_block_FF+0x139>
  80270c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80270f:	8b 00                	mov    (%eax),%eax
  802711:	a3 48 41 80 00       	mov    %eax,0x804148
  802716:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802719:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80271f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802722:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802729:	a1 54 41 80 00       	mov    0x804154,%eax
  80272e:	48                   	dec    %eax
  80272f:	a3 54 41 80 00       	mov    %eax,0x804154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  802734:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802738:	75 17                	jne    802751 <alloc_block_FF+0x174>
  80273a:	83 ec 04             	sub    $0x4,%esp
  80273d:	68 70 3e 80 00       	push   $0x803e70
  802742:	68 9a 00 00 00       	push   $0x9a
  802747:	68 57 3e 80 00       	push   $0x803e57
  80274c:	e8 85 dd ff ff       	call   8004d6 <_panic>
  802751:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802757:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80275a:	89 50 04             	mov    %edx,0x4(%eax)
  80275d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802760:	8b 40 04             	mov    0x4(%eax),%eax
  802763:	85 c0                	test   %eax,%eax
  802765:	74 0c                	je     802773 <alloc_block_FF+0x196>
  802767:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80276c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80276f:	89 10                	mov    %edx,(%eax)
  802771:	eb 08                	jmp    80277b <alloc_block_FF+0x19e>
  802773:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802776:	a3 38 41 80 00       	mov    %eax,0x804138
  80277b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80277e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802783:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802786:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80278c:	a1 44 41 80 00       	mov    0x804144,%eax
  802791:	40                   	inc    %eax
  802792:	a3 44 41 80 00       	mov    %eax,0x804144
		  // setting the size & sva
		  new_block->size=size;
  802797:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80279a:	8b 55 08             	mov    0x8(%ebp),%edx
  80279d:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  8027a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a3:	8b 50 08             	mov    0x8(%eax),%edx
  8027a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027a9:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  8027ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027af:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027b2:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  8027b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b8:	8b 50 08             	mov    0x8(%eax),%edx
  8027bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027be:	01 c2                	add    %eax,%edx
  8027c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c3:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  8027c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c9:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  8027cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027d0:	75 17                	jne    8027e9 <alloc_block_FF+0x20c>
  8027d2:	83 ec 04             	sub    $0x4,%esp
  8027d5:	68 c8 3e 80 00       	push   $0x803ec8
  8027da:	68 a2 00 00 00       	push   $0xa2
  8027df:	68 57 3e 80 00       	push   $0x803e57
  8027e4:	e8 ed dc ff ff       	call   8004d6 <_panic>
  8027e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ec:	8b 00                	mov    (%eax),%eax
  8027ee:	85 c0                	test   %eax,%eax
  8027f0:	74 10                	je     802802 <alloc_block_FF+0x225>
  8027f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f5:	8b 00                	mov    (%eax),%eax
  8027f7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027fa:	8b 52 04             	mov    0x4(%edx),%edx
  8027fd:	89 50 04             	mov    %edx,0x4(%eax)
  802800:	eb 0b                	jmp    80280d <alloc_block_FF+0x230>
  802802:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802805:	8b 40 04             	mov    0x4(%eax),%eax
  802808:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80280d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802810:	8b 40 04             	mov    0x4(%eax),%eax
  802813:	85 c0                	test   %eax,%eax
  802815:	74 0f                	je     802826 <alloc_block_FF+0x249>
  802817:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80281a:	8b 40 04             	mov    0x4(%eax),%eax
  80281d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802820:	8b 12                	mov    (%edx),%edx
  802822:	89 10                	mov    %edx,(%eax)
  802824:	eb 0a                	jmp    802830 <alloc_block_FF+0x253>
  802826:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802829:	8b 00                	mov    (%eax),%eax
  80282b:	a3 38 41 80 00       	mov    %eax,0x804138
  802830:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802833:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802839:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80283c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802843:	a1 44 41 80 00       	mov    0x804144,%eax
  802848:	48                   	dec    %eax
  802849:	a3 44 41 80 00       	mov    %eax,0x804144
		  return temp;
  80284e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802851:	eb 3b                	jmp    80288e <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802853:	a1 40 41 80 00       	mov    0x804140,%eax
  802858:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80285b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80285f:	74 07                	je     802868 <alloc_block_FF+0x28b>
  802861:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802864:	8b 00                	mov    (%eax),%eax
  802866:	eb 05                	jmp    80286d <alloc_block_FF+0x290>
  802868:	b8 00 00 00 00       	mov    $0x0,%eax
  80286d:	a3 40 41 80 00       	mov    %eax,0x804140
  802872:	a1 40 41 80 00       	mov    0x804140,%eax
  802877:	85 c0                	test   %eax,%eax
  802879:	0f 85 71 fd ff ff    	jne    8025f0 <alloc_block_FF+0x13>
  80287f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802883:	0f 85 67 fd ff ff    	jne    8025f0 <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  802889:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80288e:	c9                   	leave  
  80288f:	c3                   	ret    

00802890 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802890:	55                   	push   %ebp
  802891:	89 e5                	mov    %esp,%ebp
  802893:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  802896:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  80289d:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  8028a4:	a1 38 41 80 00       	mov    0x804138,%eax
  8028a9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8028ac:	e9 d3 00 00 00       	jmp    802984 <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  8028b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8028b7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028ba:	0f 85 90 00 00 00    	jne    802950 <alloc_block_BF+0xc0>
	   temp = element;
  8028c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028c3:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  8028c6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028ca:	75 17                	jne    8028e3 <alloc_block_BF+0x53>
  8028cc:	83 ec 04             	sub    $0x4,%esp
  8028cf:	68 c8 3e 80 00       	push   $0x803ec8
  8028d4:	68 bd 00 00 00       	push   $0xbd
  8028d9:	68 57 3e 80 00       	push   $0x803e57
  8028de:	e8 f3 db ff ff       	call   8004d6 <_panic>
  8028e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028e6:	8b 00                	mov    (%eax),%eax
  8028e8:	85 c0                	test   %eax,%eax
  8028ea:	74 10                	je     8028fc <alloc_block_BF+0x6c>
  8028ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028ef:	8b 00                	mov    (%eax),%eax
  8028f1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028f4:	8b 52 04             	mov    0x4(%edx),%edx
  8028f7:	89 50 04             	mov    %edx,0x4(%eax)
  8028fa:	eb 0b                	jmp    802907 <alloc_block_BF+0x77>
  8028fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028ff:	8b 40 04             	mov    0x4(%eax),%eax
  802902:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802907:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80290a:	8b 40 04             	mov    0x4(%eax),%eax
  80290d:	85 c0                	test   %eax,%eax
  80290f:	74 0f                	je     802920 <alloc_block_BF+0x90>
  802911:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802914:	8b 40 04             	mov    0x4(%eax),%eax
  802917:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80291a:	8b 12                	mov    (%edx),%edx
  80291c:	89 10                	mov    %edx,(%eax)
  80291e:	eb 0a                	jmp    80292a <alloc_block_BF+0x9a>
  802920:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802923:	8b 00                	mov    (%eax),%eax
  802925:	a3 38 41 80 00       	mov    %eax,0x804138
  80292a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80292d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802933:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802936:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80293d:	a1 44 41 80 00       	mov    0x804144,%eax
  802942:	48                   	dec    %eax
  802943:	a3 44 41 80 00       	mov    %eax,0x804144
	   return temp;
  802948:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80294b:	e9 41 01 00 00       	jmp    802a91 <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  802950:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802953:	8b 40 0c             	mov    0xc(%eax),%eax
  802956:	3b 45 08             	cmp    0x8(%ebp),%eax
  802959:	76 21                	jbe    80297c <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  80295b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80295e:	8b 40 0c             	mov    0xc(%eax),%eax
  802961:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802964:	73 16                	jae    80297c <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  802966:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802969:	8b 40 0c             	mov    0xc(%eax),%eax
  80296c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  80296f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802972:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  802975:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  80297c:	a1 40 41 80 00       	mov    0x804140,%eax
  802981:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802984:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802988:	74 07                	je     802991 <alloc_block_BF+0x101>
  80298a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80298d:	8b 00                	mov    (%eax),%eax
  80298f:	eb 05                	jmp    802996 <alloc_block_BF+0x106>
  802991:	b8 00 00 00 00       	mov    $0x0,%eax
  802996:	a3 40 41 80 00       	mov    %eax,0x804140
  80299b:	a1 40 41 80 00       	mov    0x804140,%eax
  8029a0:	85 c0                	test   %eax,%eax
  8029a2:	0f 85 09 ff ff ff    	jne    8028b1 <alloc_block_BF+0x21>
  8029a8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029ac:	0f 85 ff fe ff ff    	jne    8028b1 <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  8029b2:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  8029b6:	0f 85 d0 00 00 00    	jne    802a8c <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  8029bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8029c2:	2b 45 08             	sub    0x8(%ebp),%eax
  8029c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  8029c8:	a1 48 41 80 00       	mov    0x804148,%eax
  8029cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  8029d0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8029d4:	75 17                	jne    8029ed <alloc_block_BF+0x15d>
  8029d6:	83 ec 04             	sub    $0x4,%esp
  8029d9:	68 c8 3e 80 00       	push   $0x803ec8
  8029de:	68 d1 00 00 00       	push   $0xd1
  8029e3:	68 57 3e 80 00       	push   $0x803e57
  8029e8:	e8 e9 da ff ff       	call   8004d6 <_panic>
  8029ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029f0:	8b 00                	mov    (%eax),%eax
  8029f2:	85 c0                	test   %eax,%eax
  8029f4:	74 10                	je     802a06 <alloc_block_BF+0x176>
  8029f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029f9:	8b 00                	mov    (%eax),%eax
  8029fb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8029fe:	8b 52 04             	mov    0x4(%edx),%edx
  802a01:	89 50 04             	mov    %edx,0x4(%eax)
  802a04:	eb 0b                	jmp    802a11 <alloc_block_BF+0x181>
  802a06:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a09:	8b 40 04             	mov    0x4(%eax),%eax
  802a0c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a11:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a14:	8b 40 04             	mov    0x4(%eax),%eax
  802a17:	85 c0                	test   %eax,%eax
  802a19:	74 0f                	je     802a2a <alloc_block_BF+0x19a>
  802a1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a1e:	8b 40 04             	mov    0x4(%eax),%eax
  802a21:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a24:	8b 12                	mov    (%edx),%edx
  802a26:	89 10                	mov    %edx,(%eax)
  802a28:	eb 0a                	jmp    802a34 <alloc_block_BF+0x1a4>
  802a2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a2d:	8b 00                	mov    (%eax),%eax
  802a2f:	a3 48 41 80 00       	mov    %eax,0x804148
  802a34:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a37:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a40:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a47:	a1 54 41 80 00       	mov    0x804154,%eax
  802a4c:	48                   	dec    %eax
  802a4d:	a3 54 41 80 00       	mov    %eax,0x804154
	  // setting the size & sva
	  new_block->size = size;
  802a52:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a55:	8b 55 08             	mov    0x8(%ebp),%edx
  802a58:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  802a5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a5e:	8b 50 08             	mov    0x8(%eax),%edx
  802a61:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a64:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  802a67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a6a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a6d:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  802a70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a73:	8b 50 08             	mov    0x8(%eax),%edx
  802a76:	8b 45 08             	mov    0x8(%ebp),%eax
  802a79:	01 c2                	add    %eax,%edx
  802a7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a7e:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  802a81:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a84:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  802a87:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a8a:	eb 05                	jmp    802a91 <alloc_block_BF+0x201>
	 }
	 return NULL;
  802a8c:	b8 00 00 00 00       	mov    $0x0,%eax


}
  802a91:	c9                   	leave  
  802a92:	c3                   	ret    

00802a93 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802a93:	55                   	push   %ebp
  802a94:	89 e5                	mov    %esp,%ebp
  802a96:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802a99:	83 ec 04             	sub    $0x4,%esp
  802a9c:	68 e8 3e 80 00       	push   $0x803ee8
  802aa1:	68 e8 00 00 00       	push   $0xe8
  802aa6:	68 57 3e 80 00       	push   $0x803e57
  802aab:	e8 26 da ff ff       	call   8004d6 <_panic>

00802ab0 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802ab0:	55                   	push   %ebp
  802ab1:	89 e5                	mov    %esp,%ebp
  802ab3:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  802ab6:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802abb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  802abe:	a1 38 41 80 00       	mov    0x804138,%eax
  802ac3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  802ac6:	a1 44 41 80 00       	mov    0x804144,%eax
  802acb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  802ace:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ad2:	75 68                	jne    802b3c <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802ad4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ad8:	75 17                	jne    802af1 <insert_sorted_with_merge_freeList+0x41>
  802ada:	83 ec 04             	sub    $0x4,%esp
  802add:	68 34 3e 80 00       	push   $0x803e34
  802ae2:	68 36 01 00 00       	push   $0x136
  802ae7:	68 57 3e 80 00       	push   $0x803e57
  802aec:	e8 e5 d9 ff ff       	call   8004d6 <_panic>
  802af1:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802af7:	8b 45 08             	mov    0x8(%ebp),%eax
  802afa:	89 10                	mov    %edx,(%eax)
  802afc:	8b 45 08             	mov    0x8(%ebp),%eax
  802aff:	8b 00                	mov    (%eax),%eax
  802b01:	85 c0                	test   %eax,%eax
  802b03:	74 0d                	je     802b12 <insert_sorted_with_merge_freeList+0x62>
  802b05:	a1 38 41 80 00       	mov    0x804138,%eax
  802b0a:	8b 55 08             	mov    0x8(%ebp),%edx
  802b0d:	89 50 04             	mov    %edx,0x4(%eax)
  802b10:	eb 08                	jmp    802b1a <insert_sorted_with_merge_freeList+0x6a>
  802b12:	8b 45 08             	mov    0x8(%ebp),%eax
  802b15:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1d:	a3 38 41 80 00       	mov    %eax,0x804138
  802b22:	8b 45 08             	mov    0x8(%ebp),%eax
  802b25:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b2c:	a1 44 41 80 00       	mov    0x804144,%eax
  802b31:	40                   	inc    %eax
  802b32:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802b37:	e9 ba 06 00 00       	jmp    8031f6 <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  802b3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3f:	8b 50 08             	mov    0x8(%eax),%edx
  802b42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b45:	8b 40 0c             	mov    0xc(%eax),%eax
  802b48:	01 c2                	add    %eax,%edx
  802b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4d:	8b 40 08             	mov    0x8(%eax),%eax
  802b50:	39 c2                	cmp    %eax,%edx
  802b52:	73 68                	jae    802bbc <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802b54:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b58:	75 17                	jne    802b71 <insert_sorted_with_merge_freeList+0xc1>
  802b5a:	83 ec 04             	sub    $0x4,%esp
  802b5d:	68 70 3e 80 00       	push   $0x803e70
  802b62:	68 3a 01 00 00       	push   $0x13a
  802b67:	68 57 3e 80 00       	push   $0x803e57
  802b6c:	e8 65 d9 ff ff       	call   8004d6 <_panic>
  802b71:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802b77:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7a:	89 50 04             	mov    %edx,0x4(%eax)
  802b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b80:	8b 40 04             	mov    0x4(%eax),%eax
  802b83:	85 c0                	test   %eax,%eax
  802b85:	74 0c                	je     802b93 <insert_sorted_with_merge_freeList+0xe3>
  802b87:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b8c:	8b 55 08             	mov    0x8(%ebp),%edx
  802b8f:	89 10                	mov    %edx,(%eax)
  802b91:	eb 08                	jmp    802b9b <insert_sorted_with_merge_freeList+0xeb>
  802b93:	8b 45 08             	mov    0x8(%ebp),%eax
  802b96:	a3 38 41 80 00       	mov    %eax,0x804138
  802b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bac:	a1 44 41 80 00       	mov    0x804144,%eax
  802bb1:	40                   	inc    %eax
  802bb2:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802bb7:	e9 3a 06 00 00       	jmp    8031f6 <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  802bbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbf:	8b 50 08             	mov    0x8(%eax),%edx
  802bc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc5:	8b 40 0c             	mov    0xc(%eax),%eax
  802bc8:	01 c2                	add    %eax,%edx
  802bca:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcd:	8b 40 08             	mov    0x8(%eax),%eax
  802bd0:	39 c2                	cmp    %eax,%edx
  802bd2:	0f 85 90 00 00 00    	jne    802c68 <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  802bd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bdb:	8b 50 0c             	mov    0xc(%eax),%edx
  802bde:	8b 45 08             	mov    0x8(%ebp),%eax
  802be1:	8b 40 0c             	mov    0xc(%eax),%eax
  802be4:	01 c2                	add    %eax,%edx
  802be6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be9:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  802bec:	8b 45 08             	mov    0x8(%ebp),%eax
  802bef:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  802bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802c00:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c04:	75 17                	jne    802c1d <insert_sorted_with_merge_freeList+0x16d>
  802c06:	83 ec 04             	sub    $0x4,%esp
  802c09:	68 34 3e 80 00       	push   $0x803e34
  802c0e:	68 41 01 00 00       	push   $0x141
  802c13:	68 57 3e 80 00       	push   $0x803e57
  802c18:	e8 b9 d8 ff ff       	call   8004d6 <_panic>
  802c1d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c23:	8b 45 08             	mov    0x8(%ebp),%eax
  802c26:	89 10                	mov    %edx,(%eax)
  802c28:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2b:	8b 00                	mov    (%eax),%eax
  802c2d:	85 c0                	test   %eax,%eax
  802c2f:	74 0d                	je     802c3e <insert_sorted_with_merge_freeList+0x18e>
  802c31:	a1 48 41 80 00       	mov    0x804148,%eax
  802c36:	8b 55 08             	mov    0x8(%ebp),%edx
  802c39:	89 50 04             	mov    %edx,0x4(%eax)
  802c3c:	eb 08                	jmp    802c46 <insert_sorted_with_merge_freeList+0x196>
  802c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c41:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c46:	8b 45 08             	mov    0x8(%ebp),%eax
  802c49:	a3 48 41 80 00       	mov    %eax,0x804148
  802c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c51:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c58:	a1 54 41 80 00       	mov    0x804154,%eax
  802c5d:	40                   	inc    %eax
  802c5e:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802c63:	e9 8e 05 00 00       	jmp    8031f6 <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  802c68:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6b:	8b 50 08             	mov    0x8(%eax),%edx
  802c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c71:	8b 40 0c             	mov    0xc(%eax),%eax
  802c74:	01 c2                	add    %eax,%edx
  802c76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c79:	8b 40 08             	mov    0x8(%eax),%eax
  802c7c:	39 c2                	cmp    %eax,%edx
  802c7e:	73 68                	jae    802ce8 <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802c80:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c84:	75 17                	jne    802c9d <insert_sorted_with_merge_freeList+0x1ed>
  802c86:	83 ec 04             	sub    $0x4,%esp
  802c89:	68 34 3e 80 00       	push   $0x803e34
  802c8e:	68 45 01 00 00       	push   $0x145
  802c93:	68 57 3e 80 00       	push   $0x803e57
  802c98:	e8 39 d8 ff ff       	call   8004d6 <_panic>
  802c9d:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca6:	89 10                	mov    %edx,(%eax)
  802ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cab:	8b 00                	mov    (%eax),%eax
  802cad:	85 c0                	test   %eax,%eax
  802caf:	74 0d                	je     802cbe <insert_sorted_with_merge_freeList+0x20e>
  802cb1:	a1 38 41 80 00       	mov    0x804138,%eax
  802cb6:	8b 55 08             	mov    0x8(%ebp),%edx
  802cb9:	89 50 04             	mov    %edx,0x4(%eax)
  802cbc:	eb 08                	jmp    802cc6 <insert_sorted_with_merge_freeList+0x216>
  802cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc1:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc9:	a3 38 41 80 00       	mov    %eax,0x804138
  802cce:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cd8:	a1 44 41 80 00       	mov    0x804144,%eax
  802cdd:	40                   	inc    %eax
  802cde:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802ce3:	e9 0e 05 00 00       	jmp    8031f6 <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  802ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ceb:	8b 50 08             	mov    0x8(%eax),%edx
  802cee:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf1:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf4:	01 c2                	add    %eax,%edx
  802cf6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf9:	8b 40 08             	mov    0x8(%eax),%eax
  802cfc:	39 c2                	cmp    %eax,%edx
  802cfe:	0f 85 9c 00 00 00    	jne    802da0 <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  802d04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d07:	8b 50 0c             	mov    0xc(%eax),%edx
  802d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d10:	01 c2                	add    %eax,%edx
  802d12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d15:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  802d18:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1b:	8b 50 08             	mov    0x8(%eax),%edx
  802d1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d21:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  802d24:	8b 45 08             	mov    0x8(%ebp),%eax
  802d27:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  802d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d31:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802d38:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d3c:	75 17                	jne    802d55 <insert_sorted_with_merge_freeList+0x2a5>
  802d3e:	83 ec 04             	sub    $0x4,%esp
  802d41:	68 34 3e 80 00       	push   $0x803e34
  802d46:	68 4d 01 00 00       	push   $0x14d
  802d4b:	68 57 3e 80 00       	push   $0x803e57
  802d50:	e8 81 d7 ff ff       	call   8004d6 <_panic>
  802d55:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5e:	89 10                	mov    %edx,(%eax)
  802d60:	8b 45 08             	mov    0x8(%ebp),%eax
  802d63:	8b 00                	mov    (%eax),%eax
  802d65:	85 c0                	test   %eax,%eax
  802d67:	74 0d                	je     802d76 <insert_sorted_with_merge_freeList+0x2c6>
  802d69:	a1 48 41 80 00       	mov    0x804148,%eax
  802d6e:	8b 55 08             	mov    0x8(%ebp),%edx
  802d71:	89 50 04             	mov    %edx,0x4(%eax)
  802d74:	eb 08                	jmp    802d7e <insert_sorted_with_merge_freeList+0x2ce>
  802d76:	8b 45 08             	mov    0x8(%ebp),%eax
  802d79:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d81:	a3 48 41 80 00       	mov    %eax,0x804148
  802d86:	8b 45 08             	mov    0x8(%ebp),%eax
  802d89:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d90:	a1 54 41 80 00       	mov    0x804154,%eax
  802d95:	40                   	inc    %eax
  802d96:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802d9b:	e9 56 04 00 00       	jmp    8031f6 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802da0:	a1 38 41 80 00       	mov    0x804138,%eax
  802da5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802da8:	e9 19 04 00 00       	jmp    8031c6 <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  802dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db0:	8b 00                	mov    (%eax),%eax
  802db2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802db5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db8:	8b 50 08             	mov    0x8(%eax),%edx
  802dbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbe:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc1:	01 c2                	add    %eax,%edx
  802dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc6:	8b 40 08             	mov    0x8(%eax),%eax
  802dc9:	39 c2                	cmp    %eax,%edx
  802dcb:	0f 85 ad 01 00 00    	jne    802f7e <insert_sorted_with_merge_freeList+0x4ce>
  802dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd4:	8b 50 08             	mov    0x8(%eax),%edx
  802dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dda:	8b 40 0c             	mov    0xc(%eax),%eax
  802ddd:	01 c2                	add    %eax,%edx
  802ddf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802de2:	8b 40 08             	mov    0x8(%eax),%eax
  802de5:	39 c2                	cmp    %eax,%edx
  802de7:	0f 85 91 01 00 00    	jne    802f7e <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  802ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df0:	8b 50 0c             	mov    0xc(%eax),%edx
  802df3:	8b 45 08             	mov    0x8(%ebp),%eax
  802df6:	8b 48 0c             	mov    0xc(%eax),%ecx
  802df9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dfc:	8b 40 0c             	mov    0xc(%eax),%eax
  802dff:	01 c8                	add    %ecx,%eax
  802e01:	01 c2                	add    %eax,%edx
  802e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e06:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  802e09:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802e13:	8b 45 08             	mov    0x8(%ebp),%eax
  802e16:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  802e1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e20:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  802e27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e2a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  802e31:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802e35:	75 17                	jne    802e4e <insert_sorted_with_merge_freeList+0x39e>
  802e37:	83 ec 04             	sub    $0x4,%esp
  802e3a:	68 c8 3e 80 00       	push   $0x803ec8
  802e3f:	68 5b 01 00 00       	push   $0x15b
  802e44:	68 57 3e 80 00       	push   $0x803e57
  802e49:	e8 88 d6 ff ff       	call   8004d6 <_panic>
  802e4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e51:	8b 00                	mov    (%eax),%eax
  802e53:	85 c0                	test   %eax,%eax
  802e55:	74 10                	je     802e67 <insert_sorted_with_merge_freeList+0x3b7>
  802e57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e5a:	8b 00                	mov    (%eax),%eax
  802e5c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e5f:	8b 52 04             	mov    0x4(%edx),%edx
  802e62:	89 50 04             	mov    %edx,0x4(%eax)
  802e65:	eb 0b                	jmp    802e72 <insert_sorted_with_merge_freeList+0x3c2>
  802e67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e6a:	8b 40 04             	mov    0x4(%eax),%eax
  802e6d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e75:	8b 40 04             	mov    0x4(%eax),%eax
  802e78:	85 c0                	test   %eax,%eax
  802e7a:	74 0f                	je     802e8b <insert_sorted_with_merge_freeList+0x3db>
  802e7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e7f:	8b 40 04             	mov    0x4(%eax),%eax
  802e82:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e85:	8b 12                	mov    (%edx),%edx
  802e87:	89 10                	mov    %edx,(%eax)
  802e89:	eb 0a                	jmp    802e95 <insert_sorted_with_merge_freeList+0x3e5>
  802e8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e8e:	8b 00                	mov    (%eax),%eax
  802e90:	a3 38 41 80 00       	mov    %eax,0x804138
  802e95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e98:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ea1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ea8:	a1 44 41 80 00       	mov    0x804144,%eax
  802ead:	48                   	dec    %eax
  802eae:	a3 44 41 80 00       	mov    %eax,0x804144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802eb3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eb7:	75 17                	jne    802ed0 <insert_sorted_with_merge_freeList+0x420>
  802eb9:	83 ec 04             	sub    $0x4,%esp
  802ebc:	68 34 3e 80 00       	push   $0x803e34
  802ec1:	68 5c 01 00 00       	push   $0x15c
  802ec6:	68 57 3e 80 00       	push   $0x803e57
  802ecb:	e8 06 d6 ff ff       	call   8004d6 <_panic>
  802ed0:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed9:	89 10                	mov    %edx,(%eax)
  802edb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ede:	8b 00                	mov    (%eax),%eax
  802ee0:	85 c0                	test   %eax,%eax
  802ee2:	74 0d                	je     802ef1 <insert_sorted_with_merge_freeList+0x441>
  802ee4:	a1 48 41 80 00       	mov    0x804148,%eax
  802ee9:	8b 55 08             	mov    0x8(%ebp),%edx
  802eec:	89 50 04             	mov    %edx,0x4(%eax)
  802eef:	eb 08                	jmp    802ef9 <insert_sorted_with_merge_freeList+0x449>
  802ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  802efc:	a3 48 41 80 00       	mov    %eax,0x804148
  802f01:	8b 45 08             	mov    0x8(%ebp),%eax
  802f04:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f0b:	a1 54 41 80 00       	mov    0x804154,%eax
  802f10:	40                   	inc    %eax
  802f11:	a3 54 41 80 00       	mov    %eax,0x804154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  802f16:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f1a:	75 17                	jne    802f33 <insert_sorted_with_merge_freeList+0x483>
  802f1c:	83 ec 04             	sub    $0x4,%esp
  802f1f:	68 34 3e 80 00       	push   $0x803e34
  802f24:	68 5d 01 00 00       	push   $0x15d
  802f29:	68 57 3e 80 00       	push   $0x803e57
  802f2e:	e8 a3 d5 ff ff       	call   8004d6 <_panic>
  802f33:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f3c:	89 10                	mov    %edx,(%eax)
  802f3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f41:	8b 00                	mov    (%eax),%eax
  802f43:	85 c0                	test   %eax,%eax
  802f45:	74 0d                	je     802f54 <insert_sorted_with_merge_freeList+0x4a4>
  802f47:	a1 48 41 80 00       	mov    0x804148,%eax
  802f4c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f4f:	89 50 04             	mov    %edx,0x4(%eax)
  802f52:	eb 08                	jmp    802f5c <insert_sorted_with_merge_freeList+0x4ac>
  802f54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f57:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f5f:	a3 48 41 80 00       	mov    %eax,0x804148
  802f64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f67:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f6e:	a1 54 41 80 00       	mov    0x804154,%eax
  802f73:	40                   	inc    %eax
  802f74:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802f79:	e9 78 02 00 00       	jmp    8031f6 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f81:	8b 50 08             	mov    0x8(%eax),%edx
  802f84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f87:	8b 40 0c             	mov    0xc(%eax),%eax
  802f8a:	01 c2                	add    %eax,%edx
  802f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8f:	8b 40 08             	mov    0x8(%eax),%eax
  802f92:	39 c2                	cmp    %eax,%edx
  802f94:	0f 83 b8 00 00 00    	jae    803052 <insert_sorted_with_merge_freeList+0x5a2>
  802f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9d:	8b 50 08             	mov    0x8(%eax),%edx
  802fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa3:	8b 40 0c             	mov    0xc(%eax),%eax
  802fa6:	01 c2                	add    %eax,%edx
  802fa8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fab:	8b 40 08             	mov    0x8(%eax),%eax
  802fae:	39 c2                	cmp    %eax,%edx
  802fb0:	0f 85 9c 00 00 00    	jne    803052 <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  802fb6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fb9:	8b 50 0c             	mov    0xc(%eax),%edx
  802fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbf:	8b 40 0c             	mov    0xc(%eax),%eax
  802fc2:	01 c2                	add    %eax,%edx
  802fc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fc7:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  802fca:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcd:	8b 50 08             	mov    0x8(%eax),%edx
  802fd0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fd3:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  802fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802fea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fee:	75 17                	jne    803007 <insert_sorted_with_merge_freeList+0x557>
  802ff0:	83 ec 04             	sub    $0x4,%esp
  802ff3:	68 34 3e 80 00       	push   $0x803e34
  802ff8:	68 67 01 00 00       	push   $0x167
  802ffd:	68 57 3e 80 00       	push   $0x803e57
  803002:	e8 cf d4 ff ff       	call   8004d6 <_panic>
  803007:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80300d:	8b 45 08             	mov    0x8(%ebp),%eax
  803010:	89 10                	mov    %edx,(%eax)
  803012:	8b 45 08             	mov    0x8(%ebp),%eax
  803015:	8b 00                	mov    (%eax),%eax
  803017:	85 c0                	test   %eax,%eax
  803019:	74 0d                	je     803028 <insert_sorted_with_merge_freeList+0x578>
  80301b:	a1 48 41 80 00       	mov    0x804148,%eax
  803020:	8b 55 08             	mov    0x8(%ebp),%edx
  803023:	89 50 04             	mov    %edx,0x4(%eax)
  803026:	eb 08                	jmp    803030 <insert_sorted_with_merge_freeList+0x580>
  803028:	8b 45 08             	mov    0x8(%ebp),%eax
  80302b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803030:	8b 45 08             	mov    0x8(%ebp),%eax
  803033:	a3 48 41 80 00       	mov    %eax,0x804148
  803038:	8b 45 08             	mov    0x8(%ebp),%eax
  80303b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803042:	a1 54 41 80 00       	mov    0x804154,%eax
  803047:	40                   	inc    %eax
  803048:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  80304d:	e9 a4 01 00 00       	jmp    8031f6 <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  803052:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803055:	8b 50 08             	mov    0x8(%eax),%edx
  803058:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305b:	8b 40 0c             	mov    0xc(%eax),%eax
  80305e:	01 c2                	add    %eax,%edx
  803060:	8b 45 08             	mov    0x8(%ebp),%eax
  803063:	8b 40 08             	mov    0x8(%eax),%eax
  803066:	39 c2                	cmp    %eax,%edx
  803068:	0f 85 ac 00 00 00    	jne    80311a <insert_sorted_with_merge_freeList+0x66a>
  80306e:	8b 45 08             	mov    0x8(%ebp),%eax
  803071:	8b 50 08             	mov    0x8(%eax),%edx
  803074:	8b 45 08             	mov    0x8(%ebp),%eax
  803077:	8b 40 0c             	mov    0xc(%eax),%eax
  80307a:	01 c2                	add    %eax,%edx
  80307c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80307f:	8b 40 08             	mov    0x8(%eax),%eax
  803082:	39 c2                	cmp    %eax,%edx
  803084:	0f 83 90 00 00 00    	jae    80311a <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  80308a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308d:	8b 50 0c             	mov    0xc(%eax),%edx
  803090:	8b 45 08             	mov    0x8(%ebp),%eax
  803093:	8b 40 0c             	mov    0xc(%eax),%eax
  803096:	01 c2                	add    %eax,%edx
  803098:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309b:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  80309e:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  8030a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ab:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8030b2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030b6:	75 17                	jne    8030cf <insert_sorted_with_merge_freeList+0x61f>
  8030b8:	83 ec 04             	sub    $0x4,%esp
  8030bb:	68 34 3e 80 00       	push   $0x803e34
  8030c0:	68 70 01 00 00       	push   $0x170
  8030c5:	68 57 3e 80 00       	push   $0x803e57
  8030ca:	e8 07 d4 ff ff       	call   8004d6 <_panic>
  8030cf:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8030d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d8:	89 10                	mov    %edx,(%eax)
  8030da:	8b 45 08             	mov    0x8(%ebp),%eax
  8030dd:	8b 00                	mov    (%eax),%eax
  8030df:	85 c0                	test   %eax,%eax
  8030e1:	74 0d                	je     8030f0 <insert_sorted_with_merge_freeList+0x640>
  8030e3:	a1 48 41 80 00       	mov    0x804148,%eax
  8030e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8030eb:	89 50 04             	mov    %edx,0x4(%eax)
  8030ee:	eb 08                	jmp    8030f8 <insert_sorted_with_merge_freeList+0x648>
  8030f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fb:	a3 48 41 80 00       	mov    %eax,0x804148
  803100:	8b 45 08             	mov    0x8(%ebp),%eax
  803103:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80310a:	a1 54 41 80 00       	mov    0x804154,%eax
  80310f:	40                   	inc    %eax
  803110:	a3 54 41 80 00       	mov    %eax,0x804154
	      break;
  803115:	e9 dc 00 00 00       	jmp    8031f6 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  80311a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311d:	8b 50 08             	mov    0x8(%eax),%edx
  803120:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803123:	8b 40 0c             	mov    0xc(%eax),%eax
  803126:	01 c2                	add    %eax,%edx
  803128:	8b 45 08             	mov    0x8(%ebp),%eax
  80312b:	8b 40 08             	mov    0x8(%eax),%eax
  80312e:	39 c2                	cmp    %eax,%edx
  803130:	0f 83 88 00 00 00    	jae    8031be <insert_sorted_with_merge_freeList+0x70e>
  803136:	8b 45 08             	mov    0x8(%ebp),%eax
  803139:	8b 50 08             	mov    0x8(%eax),%edx
  80313c:	8b 45 08             	mov    0x8(%ebp),%eax
  80313f:	8b 40 0c             	mov    0xc(%eax),%eax
  803142:	01 c2                	add    %eax,%edx
  803144:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803147:	8b 40 08             	mov    0x8(%eax),%eax
  80314a:	39 c2                	cmp    %eax,%edx
  80314c:	73 70                	jae    8031be <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  80314e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803152:	74 06                	je     80315a <insert_sorted_with_merge_freeList+0x6aa>
  803154:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803158:	75 17                	jne    803171 <insert_sorted_with_merge_freeList+0x6c1>
  80315a:	83 ec 04             	sub    $0x4,%esp
  80315d:	68 94 3e 80 00       	push   $0x803e94
  803162:	68 75 01 00 00       	push   $0x175
  803167:	68 57 3e 80 00       	push   $0x803e57
  80316c:	e8 65 d3 ff ff       	call   8004d6 <_panic>
  803171:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803174:	8b 10                	mov    (%eax),%edx
  803176:	8b 45 08             	mov    0x8(%ebp),%eax
  803179:	89 10                	mov    %edx,(%eax)
  80317b:	8b 45 08             	mov    0x8(%ebp),%eax
  80317e:	8b 00                	mov    (%eax),%eax
  803180:	85 c0                	test   %eax,%eax
  803182:	74 0b                	je     80318f <insert_sorted_with_merge_freeList+0x6df>
  803184:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803187:	8b 00                	mov    (%eax),%eax
  803189:	8b 55 08             	mov    0x8(%ebp),%edx
  80318c:	89 50 04             	mov    %edx,0x4(%eax)
  80318f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803192:	8b 55 08             	mov    0x8(%ebp),%edx
  803195:	89 10                	mov    %edx,(%eax)
  803197:	8b 45 08             	mov    0x8(%ebp),%eax
  80319a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80319d:	89 50 04             	mov    %edx,0x4(%eax)
  8031a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a3:	8b 00                	mov    (%eax),%eax
  8031a5:	85 c0                	test   %eax,%eax
  8031a7:	75 08                	jne    8031b1 <insert_sorted_with_merge_freeList+0x701>
  8031a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ac:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8031b1:	a1 44 41 80 00       	mov    0x804144,%eax
  8031b6:	40                   	inc    %eax
  8031b7:	a3 44 41 80 00       	mov    %eax,0x804144
	      break;
  8031bc:	eb 38                	jmp    8031f6 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  8031be:	a1 40 41 80 00       	mov    0x804140,%eax
  8031c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031ca:	74 07                	je     8031d3 <insert_sorted_with_merge_freeList+0x723>
  8031cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031cf:	8b 00                	mov    (%eax),%eax
  8031d1:	eb 05                	jmp    8031d8 <insert_sorted_with_merge_freeList+0x728>
  8031d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8031d8:	a3 40 41 80 00       	mov    %eax,0x804140
  8031dd:	a1 40 41 80 00       	mov    0x804140,%eax
  8031e2:	85 c0                	test   %eax,%eax
  8031e4:	0f 85 c3 fb ff ff    	jne    802dad <insert_sorted_with_merge_freeList+0x2fd>
  8031ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031ee:	0f 85 b9 fb ff ff    	jne    802dad <insert_sorted_with_merge_freeList+0x2fd>





}
  8031f4:	eb 00                	jmp    8031f6 <insert_sorted_with_merge_freeList+0x746>
  8031f6:	90                   	nop
  8031f7:	c9                   	leave  
  8031f8:	c3                   	ret    
  8031f9:	66 90                	xchg   %ax,%ax
  8031fb:	90                   	nop

008031fc <__udivdi3>:
  8031fc:	55                   	push   %ebp
  8031fd:	57                   	push   %edi
  8031fe:	56                   	push   %esi
  8031ff:	53                   	push   %ebx
  803200:	83 ec 1c             	sub    $0x1c,%esp
  803203:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803207:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80320b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80320f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803213:	89 ca                	mov    %ecx,%edx
  803215:	89 f8                	mov    %edi,%eax
  803217:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80321b:	85 f6                	test   %esi,%esi
  80321d:	75 2d                	jne    80324c <__udivdi3+0x50>
  80321f:	39 cf                	cmp    %ecx,%edi
  803221:	77 65                	ja     803288 <__udivdi3+0x8c>
  803223:	89 fd                	mov    %edi,%ebp
  803225:	85 ff                	test   %edi,%edi
  803227:	75 0b                	jne    803234 <__udivdi3+0x38>
  803229:	b8 01 00 00 00       	mov    $0x1,%eax
  80322e:	31 d2                	xor    %edx,%edx
  803230:	f7 f7                	div    %edi
  803232:	89 c5                	mov    %eax,%ebp
  803234:	31 d2                	xor    %edx,%edx
  803236:	89 c8                	mov    %ecx,%eax
  803238:	f7 f5                	div    %ebp
  80323a:	89 c1                	mov    %eax,%ecx
  80323c:	89 d8                	mov    %ebx,%eax
  80323e:	f7 f5                	div    %ebp
  803240:	89 cf                	mov    %ecx,%edi
  803242:	89 fa                	mov    %edi,%edx
  803244:	83 c4 1c             	add    $0x1c,%esp
  803247:	5b                   	pop    %ebx
  803248:	5e                   	pop    %esi
  803249:	5f                   	pop    %edi
  80324a:	5d                   	pop    %ebp
  80324b:	c3                   	ret    
  80324c:	39 ce                	cmp    %ecx,%esi
  80324e:	77 28                	ja     803278 <__udivdi3+0x7c>
  803250:	0f bd fe             	bsr    %esi,%edi
  803253:	83 f7 1f             	xor    $0x1f,%edi
  803256:	75 40                	jne    803298 <__udivdi3+0x9c>
  803258:	39 ce                	cmp    %ecx,%esi
  80325a:	72 0a                	jb     803266 <__udivdi3+0x6a>
  80325c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803260:	0f 87 9e 00 00 00    	ja     803304 <__udivdi3+0x108>
  803266:	b8 01 00 00 00       	mov    $0x1,%eax
  80326b:	89 fa                	mov    %edi,%edx
  80326d:	83 c4 1c             	add    $0x1c,%esp
  803270:	5b                   	pop    %ebx
  803271:	5e                   	pop    %esi
  803272:	5f                   	pop    %edi
  803273:	5d                   	pop    %ebp
  803274:	c3                   	ret    
  803275:	8d 76 00             	lea    0x0(%esi),%esi
  803278:	31 ff                	xor    %edi,%edi
  80327a:	31 c0                	xor    %eax,%eax
  80327c:	89 fa                	mov    %edi,%edx
  80327e:	83 c4 1c             	add    $0x1c,%esp
  803281:	5b                   	pop    %ebx
  803282:	5e                   	pop    %esi
  803283:	5f                   	pop    %edi
  803284:	5d                   	pop    %ebp
  803285:	c3                   	ret    
  803286:	66 90                	xchg   %ax,%ax
  803288:	89 d8                	mov    %ebx,%eax
  80328a:	f7 f7                	div    %edi
  80328c:	31 ff                	xor    %edi,%edi
  80328e:	89 fa                	mov    %edi,%edx
  803290:	83 c4 1c             	add    $0x1c,%esp
  803293:	5b                   	pop    %ebx
  803294:	5e                   	pop    %esi
  803295:	5f                   	pop    %edi
  803296:	5d                   	pop    %ebp
  803297:	c3                   	ret    
  803298:	bd 20 00 00 00       	mov    $0x20,%ebp
  80329d:	89 eb                	mov    %ebp,%ebx
  80329f:	29 fb                	sub    %edi,%ebx
  8032a1:	89 f9                	mov    %edi,%ecx
  8032a3:	d3 e6                	shl    %cl,%esi
  8032a5:	89 c5                	mov    %eax,%ebp
  8032a7:	88 d9                	mov    %bl,%cl
  8032a9:	d3 ed                	shr    %cl,%ebp
  8032ab:	89 e9                	mov    %ebp,%ecx
  8032ad:	09 f1                	or     %esi,%ecx
  8032af:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8032b3:	89 f9                	mov    %edi,%ecx
  8032b5:	d3 e0                	shl    %cl,%eax
  8032b7:	89 c5                	mov    %eax,%ebp
  8032b9:	89 d6                	mov    %edx,%esi
  8032bb:	88 d9                	mov    %bl,%cl
  8032bd:	d3 ee                	shr    %cl,%esi
  8032bf:	89 f9                	mov    %edi,%ecx
  8032c1:	d3 e2                	shl    %cl,%edx
  8032c3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032c7:	88 d9                	mov    %bl,%cl
  8032c9:	d3 e8                	shr    %cl,%eax
  8032cb:	09 c2                	or     %eax,%edx
  8032cd:	89 d0                	mov    %edx,%eax
  8032cf:	89 f2                	mov    %esi,%edx
  8032d1:	f7 74 24 0c          	divl   0xc(%esp)
  8032d5:	89 d6                	mov    %edx,%esi
  8032d7:	89 c3                	mov    %eax,%ebx
  8032d9:	f7 e5                	mul    %ebp
  8032db:	39 d6                	cmp    %edx,%esi
  8032dd:	72 19                	jb     8032f8 <__udivdi3+0xfc>
  8032df:	74 0b                	je     8032ec <__udivdi3+0xf0>
  8032e1:	89 d8                	mov    %ebx,%eax
  8032e3:	31 ff                	xor    %edi,%edi
  8032e5:	e9 58 ff ff ff       	jmp    803242 <__udivdi3+0x46>
  8032ea:	66 90                	xchg   %ax,%ax
  8032ec:	8b 54 24 08          	mov    0x8(%esp),%edx
  8032f0:	89 f9                	mov    %edi,%ecx
  8032f2:	d3 e2                	shl    %cl,%edx
  8032f4:	39 c2                	cmp    %eax,%edx
  8032f6:	73 e9                	jae    8032e1 <__udivdi3+0xe5>
  8032f8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8032fb:	31 ff                	xor    %edi,%edi
  8032fd:	e9 40 ff ff ff       	jmp    803242 <__udivdi3+0x46>
  803302:	66 90                	xchg   %ax,%ax
  803304:	31 c0                	xor    %eax,%eax
  803306:	e9 37 ff ff ff       	jmp    803242 <__udivdi3+0x46>
  80330b:	90                   	nop

0080330c <__umoddi3>:
  80330c:	55                   	push   %ebp
  80330d:	57                   	push   %edi
  80330e:	56                   	push   %esi
  80330f:	53                   	push   %ebx
  803310:	83 ec 1c             	sub    $0x1c,%esp
  803313:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803317:	8b 74 24 34          	mov    0x34(%esp),%esi
  80331b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80331f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803323:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803327:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80332b:	89 f3                	mov    %esi,%ebx
  80332d:	89 fa                	mov    %edi,%edx
  80332f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803333:	89 34 24             	mov    %esi,(%esp)
  803336:	85 c0                	test   %eax,%eax
  803338:	75 1a                	jne    803354 <__umoddi3+0x48>
  80333a:	39 f7                	cmp    %esi,%edi
  80333c:	0f 86 a2 00 00 00    	jbe    8033e4 <__umoddi3+0xd8>
  803342:	89 c8                	mov    %ecx,%eax
  803344:	89 f2                	mov    %esi,%edx
  803346:	f7 f7                	div    %edi
  803348:	89 d0                	mov    %edx,%eax
  80334a:	31 d2                	xor    %edx,%edx
  80334c:	83 c4 1c             	add    $0x1c,%esp
  80334f:	5b                   	pop    %ebx
  803350:	5e                   	pop    %esi
  803351:	5f                   	pop    %edi
  803352:	5d                   	pop    %ebp
  803353:	c3                   	ret    
  803354:	39 f0                	cmp    %esi,%eax
  803356:	0f 87 ac 00 00 00    	ja     803408 <__umoddi3+0xfc>
  80335c:	0f bd e8             	bsr    %eax,%ebp
  80335f:	83 f5 1f             	xor    $0x1f,%ebp
  803362:	0f 84 ac 00 00 00    	je     803414 <__umoddi3+0x108>
  803368:	bf 20 00 00 00       	mov    $0x20,%edi
  80336d:	29 ef                	sub    %ebp,%edi
  80336f:	89 fe                	mov    %edi,%esi
  803371:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803375:	89 e9                	mov    %ebp,%ecx
  803377:	d3 e0                	shl    %cl,%eax
  803379:	89 d7                	mov    %edx,%edi
  80337b:	89 f1                	mov    %esi,%ecx
  80337d:	d3 ef                	shr    %cl,%edi
  80337f:	09 c7                	or     %eax,%edi
  803381:	89 e9                	mov    %ebp,%ecx
  803383:	d3 e2                	shl    %cl,%edx
  803385:	89 14 24             	mov    %edx,(%esp)
  803388:	89 d8                	mov    %ebx,%eax
  80338a:	d3 e0                	shl    %cl,%eax
  80338c:	89 c2                	mov    %eax,%edx
  80338e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803392:	d3 e0                	shl    %cl,%eax
  803394:	89 44 24 04          	mov    %eax,0x4(%esp)
  803398:	8b 44 24 08          	mov    0x8(%esp),%eax
  80339c:	89 f1                	mov    %esi,%ecx
  80339e:	d3 e8                	shr    %cl,%eax
  8033a0:	09 d0                	or     %edx,%eax
  8033a2:	d3 eb                	shr    %cl,%ebx
  8033a4:	89 da                	mov    %ebx,%edx
  8033a6:	f7 f7                	div    %edi
  8033a8:	89 d3                	mov    %edx,%ebx
  8033aa:	f7 24 24             	mull   (%esp)
  8033ad:	89 c6                	mov    %eax,%esi
  8033af:	89 d1                	mov    %edx,%ecx
  8033b1:	39 d3                	cmp    %edx,%ebx
  8033b3:	0f 82 87 00 00 00    	jb     803440 <__umoddi3+0x134>
  8033b9:	0f 84 91 00 00 00    	je     803450 <__umoddi3+0x144>
  8033bf:	8b 54 24 04          	mov    0x4(%esp),%edx
  8033c3:	29 f2                	sub    %esi,%edx
  8033c5:	19 cb                	sbb    %ecx,%ebx
  8033c7:	89 d8                	mov    %ebx,%eax
  8033c9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8033cd:	d3 e0                	shl    %cl,%eax
  8033cf:	89 e9                	mov    %ebp,%ecx
  8033d1:	d3 ea                	shr    %cl,%edx
  8033d3:	09 d0                	or     %edx,%eax
  8033d5:	89 e9                	mov    %ebp,%ecx
  8033d7:	d3 eb                	shr    %cl,%ebx
  8033d9:	89 da                	mov    %ebx,%edx
  8033db:	83 c4 1c             	add    $0x1c,%esp
  8033de:	5b                   	pop    %ebx
  8033df:	5e                   	pop    %esi
  8033e0:	5f                   	pop    %edi
  8033e1:	5d                   	pop    %ebp
  8033e2:	c3                   	ret    
  8033e3:	90                   	nop
  8033e4:	89 fd                	mov    %edi,%ebp
  8033e6:	85 ff                	test   %edi,%edi
  8033e8:	75 0b                	jne    8033f5 <__umoddi3+0xe9>
  8033ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8033ef:	31 d2                	xor    %edx,%edx
  8033f1:	f7 f7                	div    %edi
  8033f3:	89 c5                	mov    %eax,%ebp
  8033f5:	89 f0                	mov    %esi,%eax
  8033f7:	31 d2                	xor    %edx,%edx
  8033f9:	f7 f5                	div    %ebp
  8033fb:	89 c8                	mov    %ecx,%eax
  8033fd:	f7 f5                	div    %ebp
  8033ff:	89 d0                	mov    %edx,%eax
  803401:	e9 44 ff ff ff       	jmp    80334a <__umoddi3+0x3e>
  803406:	66 90                	xchg   %ax,%ax
  803408:	89 c8                	mov    %ecx,%eax
  80340a:	89 f2                	mov    %esi,%edx
  80340c:	83 c4 1c             	add    $0x1c,%esp
  80340f:	5b                   	pop    %ebx
  803410:	5e                   	pop    %esi
  803411:	5f                   	pop    %edi
  803412:	5d                   	pop    %ebp
  803413:	c3                   	ret    
  803414:	3b 04 24             	cmp    (%esp),%eax
  803417:	72 06                	jb     80341f <__umoddi3+0x113>
  803419:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80341d:	77 0f                	ja     80342e <__umoddi3+0x122>
  80341f:	89 f2                	mov    %esi,%edx
  803421:	29 f9                	sub    %edi,%ecx
  803423:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803427:	89 14 24             	mov    %edx,(%esp)
  80342a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80342e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803432:	8b 14 24             	mov    (%esp),%edx
  803435:	83 c4 1c             	add    $0x1c,%esp
  803438:	5b                   	pop    %ebx
  803439:	5e                   	pop    %esi
  80343a:	5f                   	pop    %edi
  80343b:	5d                   	pop    %ebp
  80343c:	c3                   	ret    
  80343d:	8d 76 00             	lea    0x0(%esi),%esi
  803440:	2b 04 24             	sub    (%esp),%eax
  803443:	19 fa                	sbb    %edi,%edx
  803445:	89 d1                	mov    %edx,%ecx
  803447:	89 c6                	mov    %eax,%esi
  803449:	e9 71 ff ff ff       	jmp    8033bf <__umoddi3+0xb3>
  80344e:	66 90                	xchg   %ax,%ax
  803450:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803454:	72 ea                	jb     803440 <__umoddi3+0x134>
  803456:	89 d9                	mov    %ebx,%ecx
  803458:	e9 62 ff ff ff       	jmp    8033bf <__umoddi3+0xb3>
