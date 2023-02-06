
obj/user/tst_sharing_2slave1:     file format elf32-i386


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
  800031:	e8 3e 02 00 00       	call   800274 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Slave program1: Read the 2 shared variables, edit the 3rd one, and exit
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 24             	sub    $0x24,%esp
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
  80008d:	68 40 33 80 00       	push   $0x803340
  800092:	6a 13                	push   $0x13
  800094:	68 5c 33 80 00       	push   $0x80335c
  800099:	e8 12 03 00 00       	call   8003b0 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 35 15 00 00       	call   8015dd <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	uint32 *x,*y,*z;
	int32 parentenvID = sys_getparentenvid();
  8000ab:	e8 65 1c 00 00       	call   801d15 <sys_getparentenvid>
  8000b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//GET: z then y then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	sys_disable_interrupt();
  8000b3:	e8 51 1a 00 00       	call   801b09 <sys_disable_interrupt>
	int freeFrames = sys_calculate_free_frames() ;
  8000b8:	e8 5f 19 00 00       	call   801a1c <sys_calculate_free_frames>
  8000bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = sget(parentenvID,"z");
  8000c0:	83 ec 08             	sub    $0x8,%esp
  8000c3:	68 77 33 80 00       	push   $0x803377
  8000c8:	ff 75 ec             	pushl  -0x14(%ebp)
  8000cb:	e8 27 17 00 00       	call   8017f7 <sget>
  8000d0:	83 c4 10             	add    $0x10,%esp
  8000d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	cprintf("THE ADDRESS RETURNED FROM FUNCTION IS :   %x \n " , z) ;
  8000d6:	83 ec 08             	sub    $0x8,%esp
  8000d9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000dc:	68 7c 33 80 00       	push   $0x80337c
  8000e1:	e8 7e 05 00 00       	call   800664 <cprintf>
  8000e6:	83 c4 10             	add    $0x10,%esp
	if (z != (uint32*)(USER_HEAP_START + 0 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000e9:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000f0:	74 14                	je     800106 <_main+0xce>
  8000f2:	83 ec 04             	sub    $0x4,%esp
  8000f5:	68 ac 33 80 00       	push   $0x8033ac
  8000fa:	6a 21                	push   $0x21
  8000fc:	68 5c 33 80 00       	push   $0x80335c
  800101:	e8 aa 02 00 00       	call   8003b0 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  800106:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800109:	e8 0e 19 00 00       	call   801a1c <sys_calculate_free_frames>
  80010e:	29 c3                	sub    %eax,%ebx
  800110:	89 d8                	mov    %ebx,%eax
  800112:	83 f8 01             	cmp    $0x1,%eax
  800115:	74 14                	je     80012b <_main+0xf3>
  800117:	83 ec 04             	sub    $0x4,%esp
  80011a:	68 0c 34 80 00       	push   $0x80340c
  80011f:	6a 22                	push   $0x22
  800121:	68 5c 33 80 00       	push   $0x80335c
  800126:	e8 85 02 00 00       	call   8003b0 <_panic>
	sys_enable_interrupt();
  80012b:	e8 f3 19 00 00       	call   801b23 <sys_enable_interrupt>

	sys_disable_interrupt();
  800130:	e8 d4 19 00 00       	call   801b09 <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  800135:	e8 e2 18 00 00       	call   801a1c <sys_calculate_free_frames>
  80013a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	y = sget(parentenvID,"y");
  80013d:	83 ec 08             	sub    $0x8,%esp
  800140:	68 9d 34 80 00       	push   $0x80349d
  800145:	ff 75 ec             	pushl  -0x14(%ebp)
  800148:	e8 aa 16 00 00       	call   8017f7 <sget>
  80014d:	83 c4 10             	add    $0x10,%esp
  800150:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800153:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  80015a:	74 14                	je     800170 <_main+0x138>
  80015c:	83 ec 04             	sub    $0x4,%esp
  80015f:	68 ac 33 80 00       	push   $0x8033ac
  800164:	6a 28                	push   $0x28
  800166:	68 5c 33 80 00       	push   $0x80335c
  80016b:	e8 40 02 00 00       	call   8003b0 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  800170:	e8 a7 18 00 00       	call   801a1c <sys_calculate_free_frames>
  800175:	89 c2                	mov    %eax,%edx
  800177:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80017a:	39 c2                	cmp    %eax,%edx
  80017c:	74 14                	je     800192 <_main+0x15a>
  80017e:	83 ec 04             	sub    $0x4,%esp
  800181:	68 0c 34 80 00       	push   $0x80340c
  800186:	6a 29                	push   $0x29
  800188:	68 5c 33 80 00       	push   $0x80335c
  80018d:	e8 1e 02 00 00       	call   8003b0 <_panic>
	sys_enable_interrupt();
  800192:	e8 8c 19 00 00       	call   801b23 <sys_enable_interrupt>

	if (*y != 20) panic("Get(): Shared Variable is not created or got correctly") ;
  800197:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80019a:	8b 00                	mov    (%eax),%eax
  80019c:	83 f8 14             	cmp    $0x14,%eax
  80019f:	74 14                	je     8001b5 <_main+0x17d>
  8001a1:	83 ec 04             	sub    $0x4,%esp
  8001a4:	68 a0 34 80 00       	push   $0x8034a0
  8001a9:	6a 2c                	push   $0x2c
  8001ab:	68 5c 33 80 00       	push   $0x80335c
  8001b0:	e8 fb 01 00 00       	call   8003b0 <_panic>

	sys_disable_interrupt();
  8001b5:	e8 4f 19 00 00       	call   801b09 <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  8001ba:	e8 5d 18 00 00       	call   801a1c <sys_calculate_free_frames>
  8001bf:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = sget(parentenvID,"x");
  8001c2:	83 ec 08             	sub    $0x8,%esp
  8001c5:	68 d7 34 80 00       	push   $0x8034d7
  8001ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cd:	e8 25 16 00 00       	call   8017f7 <sget>
  8001d2:	83 c4 10             	add    $0x10,%esp
  8001d5:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (x != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8001d8:	81 7d dc 00 20 00 80 	cmpl   $0x80002000,-0x24(%ebp)
  8001df:	74 14                	je     8001f5 <_main+0x1bd>
  8001e1:	83 ec 04             	sub    $0x4,%esp
  8001e4:	68 ac 33 80 00       	push   $0x8033ac
  8001e9:	6a 31                	push   $0x31
  8001eb:	68 5c 33 80 00       	push   $0x80335c
  8001f0:	e8 bb 01 00 00       	call   8003b0 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8001f5:	e8 22 18 00 00       	call   801a1c <sys_calculate_free_frames>
  8001fa:	89 c2                	mov    %eax,%edx
  8001fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001ff:	39 c2                	cmp    %eax,%edx
  800201:	74 14                	je     800217 <_main+0x1df>
  800203:	83 ec 04             	sub    $0x4,%esp
  800206:	68 0c 34 80 00       	push   $0x80340c
  80020b:	6a 32                	push   $0x32
  80020d:	68 5c 33 80 00       	push   $0x80335c
  800212:	e8 99 01 00 00       	call   8003b0 <_panic>
	sys_enable_interrupt();
  800217:	e8 07 19 00 00       	call   801b23 <sys_enable_interrupt>

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  80021c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80021f:	8b 00                	mov    (%eax),%eax
  800221:	83 f8 0a             	cmp    $0xa,%eax
  800224:	74 14                	je     80023a <_main+0x202>
  800226:	83 ec 04             	sub    $0x4,%esp
  800229:	68 a0 34 80 00       	push   $0x8034a0
  80022e:	6a 35                	push   $0x35
  800230:	68 5c 33 80 00       	push   $0x80335c
  800235:	e8 76 01 00 00       	call   8003b0 <_panic>

	*z = *x + *y ;
  80023a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80023d:	8b 10                	mov    (%eax),%edx
  80023f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800242:	8b 00                	mov    (%eax),%eax
  800244:	01 c2                	add    %eax,%edx
  800246:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800249:	89 10                	mov    %edx,(%eax)
	if (*z != 30) panic("Get(): Shared Variable is not created or got correctly") ;
  80024b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80024e:	8b 00                	mov    (%eax),%eax
  800250:	83 f8 1e             	cmp    $0x1e,%eax
  800253:	74 14                	je     800269 <_main+0x231>
  800255:	83 ec 04             	sub    $0x4,%esp
  800258:	68 a0 34 80 00       	push   $0x8034a0
  80025d:	6a 38                	push   $0x38
  80025f:	68 5c 33 80 00       	push   $0x80335c
  800264:	e8 47 01 00 00       	call   8003b0 <_panic>

	//To indicate that it's completed successfully
	inctst();
  800269:	e8 cc 1b 00 00       	call   801e3a <inctst>

	return;
  80026e:	90                   	nop
}
  80026f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800272:	c9                   	leave  
  800273:	c3                   	ret    

00800274 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800274:	55                   	push   %ebp
  800275:	89 e5                	mov    %esp,%ebp
  800277:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80027a:	e8 7d 1a 00 00       	call   801cfc <sys_getenvindex>
  80027f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800282:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800285:	89 d0                	mov    %edx,%eax
  800287:	c1 e0 03             	shl    $0x3,%eax
  80028a:	01 d0                	add    %edx,%eax
  80028c:	01 c0                	add    %eax,%eax
  80028e:	01 d0                	add    %edx,%eax
  800290:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800297:	01 d0                	add    %edx,%eax
  800299:	c1 e0 04             	shl    $0x4,%eax
  80029c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002a1:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002a6:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ab:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8002b1:	84 c0                	test   %al,%al
  8002b3:	74 0f                	je     8002c4 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8002b5:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ba:	05 5c 05 00 00       	add    $0x55c,%eax
  8002bf:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002c4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002c8:	7e 0a                	jle    8002d4 <libmain+0x60>
		binaryname = argv[0];
  8002ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002cd:	8b 00                	mov    (%eax),%eax
  8002cf:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8002d4:	83 ec 08             	sub    $0x8,%esp
  8002d7:	ff 75 0c             	pushl  0xc(%ebp)
  8002da:	ff 75 08             	pushl  0x8(%ebp)
  8002dd:	e8 56 fd ff ff       	call   800038 <_main>
  8002e2:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8002e5:	e8 1f 18 00 00       	call   801b09 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002ea:	83 ec 0c             	sub    $0xc,%esp
  8002ed:	68 f4 34 80 00       	push   $0x8034f4
  8002f2:	e8 6d 03 00 00       	call   800664 <cprintf>
  8002f7:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002fa:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ff:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800305:	a1 20 40 80 00       	mov    0x804020,%eax
  80030a:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800310:	83 ec 04             	sub    $0x4,%esp
  800313:	52                   	push   %edx
  800314:	50                   	push   %eax
  800315:	68 1c 35 80 00       	push   $0x80351c
  80031a:	e8 45 03 00 00       	call   800664 <cprintf>
  80031f:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800322:	a1 20 40 80 00       	mov    0x804020,%eax
  800327:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80032d:	a1 20 40 80 00       	mov    0x804020,%eax
  800332:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800338:	a1 20 40 80 00       	mov    0x804020,%eax
  80033d:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800343:	51                   	push   %ecx
  800344:	52                   	push   %edx
  800345:	50                   	push   %eax
  800346:	68 44 35 80 00       	push   $0x803544
  80034b:	e8 14 03 00 00       	call   800664 <cprintf>
  800350:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800353:	a1 20 40 80 00       	mov    0x804020,%eax
  800358:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80035e:	83 ec 08             	sub    $0x8,%esp
  800361:	50                   	push   %eax
  800362:	68 9c 35 80 00       	push   $0x80359c
  800367:	e8 f8 02 00 00       	call   800664 <cprintf>
  80036c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80036f:	83 ec 0c             	sub    $0xc,%esp
  800372:	68 f4 34 80 00       	push   $0x8034f4
  800377:	e8 e8 02 00 00       	call   800664 <cprintf>
  80037c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80037f:	e8 9f 17 00 00       	call   801b23 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800384:	e8 19 00 00 00       	call   8003a2 <exit>
}
  800389:	90                   	nop
  80038a:	c9                   	leave  
  80038b:	c3                   	ret    

0080038c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80038c:	55                   	push   %ebp
  80038d:	89 e5                	mov    %esp,%ebp
  80038f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800392:	83 ec 0c             	sub    $0xc,%esp
  800395:	6a 00                	push   $0x0
  800397:	e8 2c 19 00 00       	call   801cc8 <sys_destroy_env>
  80039c:	83 c4 10             	add    $0x10,%esp
}
  80039f:	90                   	nop
  8003a0:	c9                   	leave  
  8003a1:	c3                   	ret    

008003a2 <exit>:

void
exit(void)
{
  8003a2:	55                   	push   %ebp
  8003a3:	89 e5                	mov    %esp,%ebp
  8003a5:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8003a8:	e8 81 19 00 00       	call   801d2e <sys_exit_env>
}
  8003ad:	90                   	nop
  8003ae:	c9                   	leave  
  8003af:	c3                   	ret    

008003b0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8003b0:	55                   	push   %ebp
  8003b1:	89 e5                	mov    %esp,%ebp
  8003b3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8003b6:	8d 45 10             	lea    0x10(%ebp),%eax
  8003b9:	83 c0 04             	add    $0x4,%eax
  8003bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8003bf:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8003c4:	85 c0                	test   %eax,%eax
  8003c6:	74 16                	je     8003de <_panic+0x2e>
		cprintf("%s: ", argv0);
  8003c8:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8003cd:	83 ec 08             	sub    $0x8,%esp
  8003d0:	50                   	push   %eax
  8003d1:	68 b0 35 80 00       	push   $0x8035b0
  8003d6:	e8 89 02 00 00       	call   800664 <cprintf>
  8003db:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003de:	a1 00 40 80 00       	mov    0x804000,%eax
  8003e3:	ff 75 0c             	pushl  0xc(%ebp)
  8003e6:	ff 75 08             	pushl  0x8(%ebp)
  8003e9:	50                   	push   %eax
  8003ea:	68 b5 35 80 00       	push   $0x8035b5
  8003ef:	e8 70 02 00 00       	call   800664 <cprintf>
  8003f4:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8003f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8003fa:	83 ec 08             	sub    $0x8,%esp
  8003fd:	ff 75 f4             	pushl  -0xc(%ebp)
  800400:	50                   	push   %eax
  800401:	e8 f3 01 00 00       	call   8005f9 <vcprintf>
  800406:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800409:	83 ec 08             	sub    $0x8,%esp
  80040c:	6a 00                	push   $0x0
  80040e:	68 d1 35 80 00       	push   $0x8035d1
  800413:	e8 e1 01 00 00       	call   8005f9 <vcprintf>
  800418:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80041b:	e8 82 ff ff ff       	call   8003a2 <exit>

	// should not return here
	while (1) ;
  800420:	eb fe                	jmp    800420 <_panic+0x70>

00800422 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800422:	55                   	push   %ebp
  800423:	89 e5                	mov    %esp,%ebp
  800425:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800428:	a1 20 40 80 00       	mov    0x804020,%eax
  80042d:	8b 50 74             	mov    0x74(%eax),%edx
  800430:	8b 45 0c             	mov    0xc(%ebp),%eax
  800433:	39 c2                	cmp    %eax,%edx
  800435:	74 14                	je     80044b <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800437:	83 ec 04             	sub    $0x4,%esp
  80043a:	68 d4 35 80 00       	push   $0x8035d4
  80043f:	6a 26                	push   $0x26
  800441:	68 20 36 80 00       	push   $0x803620
  800446:	e8 65 ff ff ff       	call   8003b0 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80044b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800452:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800459:	e9 c2 00 00 00       	jmp    800520 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80045e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800461:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800468:	8b 45 08             	mov    0x8(%ebp),%eax
  80046b:	01 d0                	add    %edx,%eax
  80046d:	8b 00                	mov    (%eax),%eax
  80046f:	85 c0                	test   %eax,%eax
  800471:	75 08                	jne    80047b <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800473:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800476:	e9 a2 00 00 00       	jmp    80051d <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80047b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800482:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800489:	eb 69                	jmp    8004f4 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80048b:	a1 20 40 80 00       	mov    0x804020,%eax
  800490:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800496:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800499:	89 d0                	mov    %edx,%eax
  80049b:	01 c0                	add    %eax,%eax
  80049d:	01 d0                	add    %edx,%eax
  80049f:	c1 e0 03             	shl    $0x3,%eax
  8004a2:	01 c8                	add    %ecx,%eax
  8004a4:	8a 40 04             	mov    0x4(%eax),%al
  8004a7:	84 c0                	test   %al,%al
  8004a9:	75 46                	jne    8004f1 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004ab:	a1 20 40 80 00       	mov    0x804020,%eax
  8004b0:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004b6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004b9:	89 d0                	mov    %edx,%eax
  8004bb:	01 c0                	add    %eax,%eax
  8004bd:	01 d0                	add    %edx,%eax
  8004bf:	c1 e0 03             	shl    $0x3,%eax
  8004c2:	01 c8                	add    %ecx,%eax
  8004c4:	8b 00                	mov    (%eax),%eax
  8004c6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004cc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004d1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004d6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e0:	01 c8                	add    %ecx,%eax
  8004e2:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004e4:	39 c2                	cmp    %eax,%edx
  8004e6:	75 09                	jne    8004f1 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8004e8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004ef:	eb 12                	jmp    800503 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004f1:	ff 45 e8             	incl   -0x18(%ebp)
  8004f4:	a1 20 40 80 00       	mov    0x804020,%eax
  8004f9:	8b 50 74             	mov    0x74(%eax),%edx
  8004fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004ff:	39 c2                	cmp    %eax,%edx
  800501:	77 88                	ja     80048b <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800503:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800507:	75 14                	jne    80051d <CheckWSWithoutLastIndex+0xfb>
			panic(
  800509:	83 ec 04             	sub    $0x4,%esp
  80050c:	68 2c 36 80 00       	push   $0x80362c
  800511:	6a 3a                	push   $0x3a
  800513:	68 20 36 80 00       	push   $0x803620
  800518:	e8 93 fe ff ff       	call   8003b0 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80051d:	ff 45 f0             	incl   -0x10(%ebp)
  800520:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800523:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800526:	0f 8c 32 ff ff ff    	jl     80045e <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80052c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800533:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80053a:	eb 26                	jmp    800562 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80053c:	a1 20 40 80 00       	mov    0x804020,%eax
  800541:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800547:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80054a:	89 d0                	mov    %edx,%eax
  80054c:	01 c0                	add    %eax,%eax
  80054e:	01 d0                	add    %edx,%eax
  800550:	c1 e0 03             	shl    $0x3,%eax
  800553:	01 c8                	add    %ecx,%eax
  800555:	8a 40 04             	mov    0x4(%eax),%al
  800558:	3c 01                	cmp    $0x1,%al
  80055a:	75 03                	jne    80055f <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80055c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80055f:	ff 45 e0             	incl   -0x20(%ebp)
  800562:	a1 20 40 80 00       	mov    0x804020,%eax
  800567:	8b 50 74             	mov    0x74(%eax),%edx
  80056a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80056d:	39 c2                	cmp    %eax,%edx
  80056f:	77 cb                	ja     80053c <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800574:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800577:	74 14                	je     80058d <CheckWSWithoutLastIndex+0x16b>
		panic(
  800579:	83 ec 04             	sub    $0x4,%esp
  80057c:	68 80 36 80 00       	push   $0x803680
  800581:	6a 44                	push   $0x44
  800583:	68 20 36 80 00       	push   $0x803620
  800588:	e8 23 fe ff ff       	call   8003b0 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80058d:	90                   	nop
  80058e:	c9                   	leave  
  80058f:	c3                   	ret    

00800590 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800590:	55                   	push   %ebp
  800591:	89 e5                	mov    %esp,%ebp
  800593:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800596:	8b 45 0c             	mov    0xc(%ebp),%eax
  800599:	8b 00                	mov    (%eax),%eax
  80059b:	8d 48 01             	lea    0x1(%eax),%ecx
  80059e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005a1:	89 0a                	mov    %ecx,(%edx)
  8005a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8005a6:	88 d1                	mov    %dl,%cl
  8005a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ab:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005b2:	8b 00                	mov    (%eax),%eax
  8005b4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005b9:	75 2c                	jne    8005e7 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8005bb:	a0 24 40 80 00       	mov    0x804024,%al
  8005c0:	0f b6 c0             	movzbl %al,%eax
  8005c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005c6:	8b 12                	mov    (%edx),%edx
  8005c8:	89 d1                	mov    %edx,%ecx
  8005ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005cd:	83 c2 08             	add    $0x8,%edx
  8005d0:	83 ec 04             	sub    $0x4,%esp
  8005d3:	50                   	push   %eax
  8005d4:	51                   	push   %ecx
  8005d5:	52                   	push   %edx
  8005d6:	e8 80 13 00 00       	call   80195b <sys_cputs>
  8005db:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ea:	8b 40 04             	mov    0x4(%eax),%eax
  8005ed:	8d 50 01             	lea    0x1(%eax),%edx
  8005f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005f6:	90                   	nop
  8005f7:	c9                   	leave  
  8005f8:	c3                   	ret    

008005f9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005f9:	55                   	push   %ebp
  8005fa:	89 e5                	mov    %esp,%ebp
  8005fc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800602:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800609:	00 00 00 
	b.cnt = 0;
  80060c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800613:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800616:	ff 75 0c             	pushl  0xc(%ebp)
  800619:	ff 75 08             	pushl  0x8(%ebp)
  80061c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800622:	50                   	push   %eax
  800623:	68 90 05 80 00       	push   $0x800590
  800628:	e8 11 02 00 00       	call   80083e <vprintfmt>
  80062d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800630:	a0 24 40 80 00       	mov    0x804024,%al
  800635:	0f b6 c0             	movzbl %al,%eax
  800638:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80063e:	83 ec 04             	sub    $0x4,%esp
  800641:	50                   	push   %eax
  800642:	52                   	push   %edx
  800643:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800649:	83 c0 08             	add    $0x8,%eax
  80064c:	50                   	push   %eax
  80064d:	e8 09 13 00 00       	call   80195b <sys_cputs>
  800652:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800655:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80065c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800662:	c9                   	leave  
  800663:	c3                   	ret    

00800664 <cprintf>:

int cprintf(const char *fmt, ...) {
  800664:	55                   	push   %ebp
  800665:	89 e5                	mov    %esp,%ebp
  800667:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80066a:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800671:	8d 45 0c             	lea    0xc(%ebp),%eax
  800674:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800677:	8b 45 08             	mov    0x8(%ebp),%eax
  80067a:	83 ec 08             	sub    $0x8,%esp
  80067d:	ff 75 f4             	pushl  -0xc(%ebp)
  800680:	50                   	push   %eax
  800681:	e8 73 ff ff ff       	call   8005f9 <vcprintf>
  800686:	83 c4 10             	add    $0x10,%esp
  800689:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80068c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80068f:	c9                   	leave  
  800690:	c3                   	ret    

00800691 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800691:	55                   	push   %ebp
  800692:	89 e5                	mov    %esp,%ebp
  800694:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800697:	e8 6d 14 00 00       	call   801b09 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80069c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80069f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a5:	83 ec 08             	sub    $0x8,%esp
  8006a8:	ff 75 f4             	pushl  -0xc(%ebp)
  8006ab:	50                   	push   %eax
  8006ac:	e8 48 ff ff ff       	call   8005f9 <vcprintf>
  8006b1:	83 c4 10             	add    $0x10,%esp
  8006b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8006b7:	e8 67 14 00 00       	call   801b23 <sys_enable_interrupt>
	return cnt;
  8006bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006bf:	c9                   	leave  
  8006c0:	c3                   	ret    

008006c1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006c1:	55                   	push   %ebp
  8006c2:	89 e5                	mov    %esp,%ebp
  8006c4:	53                   	push   %ebx
  8006c5:	83 ec 14             	sub    $0x14,%esp
  8006c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8006cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006d4:	8b 45 18             	mov    0x18(%ebp),%eax
  8006d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8006dc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006df:	77 55                	ja     800736 <printnum+0x75>
  8006e1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006e4:	72 05                	jb     8006eb <printnum+0x2a>
  8006e6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006e9:	77 4b                	ja     800736 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006eb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006ee:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006f1:	8b 45 18             	mov    0x18(%ebp),%eax
  8006f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f9:	52                   	push   %edx
  8006fa:	50                   	push   %eax
  8006fb:	ff 75 f4             	pushl  -0xc(%ebp)
  8006fe:	ff 75 f0             	pushl  -0x10(%ebp)
  800701:	e8 ce 29 00 00       	call   8030d4 <__udivdi3>
  800706:	83 c4 10             	add    $0x10,%esp
  800709:	83 ec 04             	sub    $0x4,%esp
  80070c:	ff 75 20             	pushl  0x20(%ebp)
  80070f:	53                   	push   %ebx
  800710:	ff 75 18             	pushl  0x18(%ebp)
  800713:	52                   	push   %edx
  800714:	50                   	push   %eax
  800715:	ff 75 0c             	pushl  0xc(%ebp)
  800718:	ff 75 08             	pushl  0x8(%ebp)
  80071b:	e8 a1 ff ff ff       	call   8006c1 <printnum>
  800720:	83 c4 20             	add    $0x20,%esp
  800723:	eb 1a                	jmp    80073f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800725:	83 ec 08             	sub    $0x8,%esp
  800728:	ff 75 0c             	pushl  0xc(%ebp)
  80072b:	ff 75 20             	pushl  0x20(%ebp)
  80072e:	8b 45 08             	mov    0x8(%ebp),%eax
  800731:	ff d0                	call   *%eax
  800733:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800736:	ff 4d 1c             	decl   0x1c(%ebp)
  800739:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80073d:	7f e6                	jg     800725 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80073f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800742:	bb 00 00 00 00       	mov    $0x0,%ebx
  800747:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80074a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80074d:	53                   	push   %ebx
  80074e:	51                   	push   %ecx
  80074f:	52                   	push   %edx
  800750:	50                   	push   %eax
  800751:	e8 8e 2a 00 00       	call   8031e4 <__umoddi3>
  800756:	83 c4 10             	add    $0x10,%esp
  800759:	05 f4 38 80 00       	add    $0x8038f4,%eax
  80075e:	8a 00                	mov    (%eax),%al
  800760:	0f be c0             	movsbl %al,%eax
  800763:	83 ec 08             	sub    $0x8,%esp
  800766:	ff 75 0c             	pushl  0xc(%ebp)
  800769:	50                   	push   %eax
  80076a:	8b 45 08             	mov    0x8(%ebp),%eax
  80076d:	ff d0                	call   *%eax
  80076f:	83 c4 10             	add    $0x10,%esp
}
  800772:	90                   	nop
  800773:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800776:	c9                   	leave  
  800777:	c3                   	ret    

00800778 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800778:	55                   	push   %ebp
  800779:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80077b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80077f:	7e 1c                	jle    80079d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800781:	8b 45 08             	mov    0x8(%ebp),%eax
  800784:	8b 00                	mov    (%eax),%eax
  800786:	8d 50 08             	lea    0x8(%eax),%edx
  800789:	8b 45 08             	mov    0x8(%ebp),%eax
  80078c:	89 10                	mov    %edx,(%eax)
  80078e:	8b 45 08             	mov    0x8(%ebp),%eax
  800791:	8b 00                	mov    (%eax),%eax
  800793:	83 e8 08             	sub    $0x8,%eax
  800796:	8b 50 04             	mov    0x4(%eax),%edx
  800799:	8b 00                	mov    (%eax),%eax
  80079b:	eb 40                	jmp    8007dd <getuint+0x65>
	else if (lflag)
  80079d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007a1:	74 1e                	je     8007c1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a6:	8b 00                	mov    (%eax),%eax
  8007a8:	8d 50 04             	lea    0x4(%eax),%edx
  8007ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ae:	89 10                	mov    %edx,(%eax)
  8007b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b3:	8b 00                	mov    (%eax),%eax
  8007b5:	83 e8 04             	sub    $0x4,%eax
  8007b8:	8b 00                	mov    (%eax),%eax
  8007ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8007bf:	eb 1c                	jmp    8007dd <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c4:	8b 00                	mov    (%eax),%eax
  8007c6:	8d 50 04             	lea    0x4(%eax),%edx
  8007c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cc:	89 10                	mov    %edx,(%eax)
  8007ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d1:	8b 00                	mov    (%eax),%eax
  8007d3:	83 e8 04             	sub    $0x4,%eax
  8007d6:	8b 00                	mov    (%eax),%eax
  8007d8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007dd:	5d                   	pop    %ebp
  8007de:	c3                   	ret    

008007df <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007df:	55                   	push   %ebp
  8007e0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007e2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007e6:	7e 1c                	jle    800804 <getint+0x25>
		return va_arg(*ap, long long);
  8007e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007eb:	8b 00                	mov    (%eax),%eax
  8007ed:	8d 50 08             	lea    0x8(%eax),%edx
  8007f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f3:	89 10                	mov    %edx,(%eax)
  8007f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f8:	8b 00                	mov    (%eax),%eax
  8007fa:	83 e8 08             	sub    $0x8,%eax
  8007fd:	8b 50 04             	mov    0x4(%eax),%edx
  800800:	8b 00                	mov    (%eax),%eax
  800802:	eb 38                	jmp    80083c <getint+0x5d>
	else if (lflag)
  800804:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800808:	74 1a                	je     800824 <getint+0x45>
		return va_arg(*ap, long);
  80080a:	8b 45 08             	mov    0x8(%ebp),%eax
  80080d:	8b 00                	mov    (%eax),%eax
  80080f:	8d 50 04             	lea    0x4(%eax),%edx
  800812:	8b 45 08             	mov    0x8(%ebp),%eax
  800815:	89 10                	mov    %edx,(%eax)
  800817:	8b 45 08             	mov    0x8(%ebp),%eax
  80081a:	8b 00                	mov    (%eax),%eax
  80081c:	83 e8 04             	sub    $0x4,%eax
  80081f:	8b 00                	mov    (%eax),%eax
  800821:	99                   	cltd   
  800822:	eb 18                	jmp    80083c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800824:	8b 45 08             	mov    0x8(%ebp),%eax
  800827:	8b 00                	mov    (%eax),%eax
  800829:	8d 50 04             	lea    0x4(%eax),%edx
  80082c:	8b 45 08             	mov    0x8(%ebp),%eax
  80082f:	89 10                	mov    %edx,(%eax)
  800831:	8b 45 08             	mov    0x8(%ebp),%eax
  800834:	8b 00                	mov    (%eax),%eax
  800836:	83 e8 04             	sub    $0x4,%eax
  800839:	8b 00                	mov    (%eax),%eax
  80083b:	99                   	cltd   
}
  80083c:	5d                   	pop    %ebp
  80083d:	c3                   	ret    

0080083e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80083e:	55                   	push   %ebp
  80083f:	89 e5                	mov    %esp,%ebp
  800841:	56                   	push   %esi
  800842:	53                   	push   %ebx
  800843:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800846:	eb 17                	jmp    80085f <vprintfmt+0x21>
			if (ch == '\0')
  800848:	85 db                	test   %ebx,%ebx
  80084a:	0f 84 af 03 00 00    	je     800bff <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800850:	83 ec 08             	sub    $0x8,%esp
  800853:	ff 75 0c             	pushl  0xc(%ebp)
  800856:	53                   	push   %ebx
  800857:	8b 45 08             	mov    0x8(%ebp),%eax
  80085a:	ff d0                	call   *%eax
  80085c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80085f:	8b 45 10             	mov    0x10(%ebp),%eax
  800862:	8d 50 01             	lea    0x1(%eax),%edx
  800865:	89 55 10             	mov    %edx,0x10(%ebp)
  800868:	8a 00                	mov    (%eax),%al
  80086a:	0f b6 d8             	movzbl %al,%ebx
  80086d:	83 fb 25             	cmp    $0x25,%ebx
  800870:	75 d6                	jne    800848 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800872:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800876:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80087d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800884:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80088b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800892:	8b 45 10             	mov    0x10(%ebp),%eax
  800895:	8d 50 01             	lea    0x1(%eax),%edx
  800898:	89 55 10             	mov    %edx,0x10(%ebp)
  80089b:	8a 00                	mov    (%eax),%al
  80089d:	0f b6 d8             	movzbl %al,%ebx
  8008a0:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008a3:	83 f8 55             	cmp    $0x55,%eax
  8008a6:	0f 87 2b 03 00 00    	ja     800bd7 <vprintfmt+0x399>
  8008ac:	8b 04 85 18 39 80 00 	mov    0x803918(,%eax,4),%eax
  8008b3:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008b5:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008b9:	eb d7                	jmp    800892 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008bb:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8008bf:	eb d1                	jmp    800892 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008c1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008c8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008cb:	89 d0                	mov    %edx,%eax
  8008cd:	c1 e0 02             	shl    $0x2,%eax
  8008d0:	01 d0                	add    %edx,%eax
  8008d2:	01 c0                	add    %eax,%eax
  8008d4:	01 d8                	add    %ebx,%eax
  8008d6:	83 e8 30             	sub    $0x30,%eax
  8008d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8008df:	8a 00                	mov    (%eax),%al
  8008e1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008e4:	83 fb 2f             	cmp    $0x2f,%ebx
  8008e7:	7e 3e                	jle    800927 <vprintfmt+0xe9>
  8008e9:	83 fb 39             	cmp    $0x39,%ebx
  8008ec:	7f 39                	jg     800927 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008ee:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008f1:	eb d5                	jmp    8008c8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f6:	83 c0 04             	add    $0x4,%eax
  8008f9:	89 45 14             	mov    %eax,0x14(%ebp)
  8008fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ff:	83 e8 04             	sub    $0x4,%eax
  800902:	8b 00                	mov    (%eax),%eax
  800904:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800907:	eb 1f                	jmp    800928 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800909:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80090d:	79 83                	jns    800892 <vprintfmt+0x54>
				width = 0;
  80090f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800916:	e9 77 ff ff ff       	jmp    800892 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80091b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800922:	e9 6b ff ff ff       	jmp    800892 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800927:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800928:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80092c:	0f 89 60 ff ff ff    	jns    800892 <vprintfmt+0x54>
				width = precision, precision = -1;
  800932:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800935:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800938:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80093f:	e9 4e ff ff ff       	jmp    800892 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800944:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800947:	e9 46 ff ff ff       	jmp    800892 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80094c:	8b 45 14             	mov    0x14(%ebp),%eax
  80094f:	83 c0 04             	add    $0x4,%eax
  800952:	89 45 14             	mov    %eax,0x14(%ebp)
  800955:	8b 45 14             	mov    0x14(%ebp),%eax
  800958:	83 e8 04             	sub    $0x4,%eax
  80095b:	8b 00                	mov    (%eax),%eax
  80095d:	83 ec 08             	sub    $0x8,%esp
  800960:	ff 75 0c             	pushl  0xc(%ebp)
  800963:	50                   	push   %eax
  800964:	8b 45 08             	mov    0x8(%ebp),%eax
  800967:	ff d0                	call   *%eax
  800969:	83 c4 10             	add    $0x10,%esp
			break;
  80096c:	e9 89 02 00 00       	jmp    800bfa <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800971:	8b 45 14             	mov    0x14(%ebp),%eax
  800974:	83 c0 04             	add    $0x4,%eax
  800977:	89 45 14             	mov    %eax,0x14(%ebp)
  80097a:	8b 45 14             	mov    0x14(%ebp),%eax
  80097d:	83 e8 04             	sub    $0x4,%eax
  800980:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800982:	85 db                	test   %ebx,%ebx
  800984:	79 02                	jns    800988 <vprintfmt+0x14a>
				err = -err;
  800986:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800988:	83 fb 64             	cmp    $0x64,%ebx
  80098b:	7f 0b                	jg     800998 <vprintfmt+0x15a>
  80098d:	8b 34 9d 60 37 80 00 	mov    0x803760(,%ebx,4),%esi
  800994:	85 f6                	test   %esi,%esi
  800996:	75 19                	jne    8009b1 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800998:	53                   	push   %ebx
  800999:	68 05 39 80 00       	push   $0x803905
  80099e:	ff 75 0c             	pushl  0xc(%ebp)
  8009a1:	ff 75 08             	pushl  0x8(%ebp)
  8009a4:	e8 5e 02 00 00       	call   800c07 <printfmt>
  8009a9:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009ac:	e9 49 02 00 00       	jmp    800bfa <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009b1:	56                   	push   %esi
  8009b2:	68 0e 39 80 00       	push   $0x80390e
  8009b7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ba:	ff 75 08             	pushl  0x8(%ebp)
  8009bd:	e8 45 02 00 00       	call   800c07 <printfmt>
  8009c2:	83 c4 10             	add    $0x10,%esp
			break;
  8009c5:	e9 30 02 00 00       	jmp    800bfa <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cd:	83 c0 04             	add    $0x4,%eax
  8009d0:	89 45 14             	mov    %eax,0x14(%ebp)
  8009d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d6:	83 e8 04             	sub    $0x4,%eax
  8009d9:	8b 30                	mov    (%eax),%esi
  8009db:	85 f6                	test   %esi,%esi
  8009dd:	75 05                	jne    8009e4 <vprintfmt+0x1a6>
				p = "(null)";
  8009df:	be 11 39 80 00       	mov    $0x803911,%esi
			if (width > 0 && padc != '-')
  8009e4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009e8:	7e 6d                	jle    800a57 <vprintfmt+0x219>
  8009ea:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009ee:	74 67                	je     800a57 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009f3:	83 ec 08             	sub    $0x8,%esp
  8009f6:	50                   	push   %eax
  8009f7:	56                   	push   %esi
  8009f8:	e8 0c 03 00 00       	call   800d09 <strnlen>
  8009fd:	83 c4 10             	add    $0x10,%esp
  800a00:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a03:	eb 16                	jmp    800a1b <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a05:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a09:	83 ec 08             	sub    $0x8,%esp
  800a0c:	ff 75 0c             	pushl  0xc(%ebp)
  800a0f:	50                   	push   %eax
  800a10:	8b 45 08             	mov    0x8(%ebp),%eax
  800a13:	ff d0                	call   *%eax
  800a15:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a18:	ff 4d e4             	decl   -0x1c(%ebp)
  800a1b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a1f:	7f e4                	jg     800a05 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a21:	eb 34                	jmp    800a57 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a23:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a27:	74 1c                	je     800a45 <vprintfmt+0x207>
  800a29:	83 fb 1f             	cmp    $0x1f,%ebx
  800a2c:	7e 05                	jle    800a33 <vprintfmt+0x1f5>
  800a2e:	83 fb 7e             	cmp    $0x7e,%ebx
  800a31:	7e 12                	jle    800a45 <vprintfmt+0x207>
					putch('?', putdat);
  800a33:	83 ec 08             	sub    $0x8,%esp
  800a36:	ff 75 0c             	pushl  0xc(%ebp)
  800a39:	6a 3f                	push   $0x3f
  800a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3e:	ff d0                	call   *%eax
  800a40:	83 c4 10             	add    $0x10,%esp
  800a43:	eb 0f                	jmp    800a54 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a45:	83 ec 08             	sub    $0x8,%esp
  800a48:	ff 75 0c             	pushl  0xc(%ebp)
  800a4b:	53                   	push   %ebx
  800a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4f:	ff d0                	call   *%eax
  800a51:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a54:	ff 4d e4             	decl   -0x1c(%ebp)
  800a57:	89 f0                	mov    %esi,%eax
  800a59:	8d 70 01             	lea    0x1(%eax),%esi
  800a5c:	8a 00                	mov    (%eax),%al
  800a5e:	0f be d8             	movsbl %al,%ebx
  800a61:	85 db                	test   %ebx,%ebx
  800a63:	74 24                	je     800a89 <vprintfmt+0x24b>
  800a65:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a69:	78 b8                	js     800a23 <vprintfmt+0x1e5>
  800a6b:	ff 4d e0             	decl   -0x20(%ebp)
  800a6e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a72:	79 af                	jns    800a23 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a74:	eb 13                	jmp    800a89 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a76:	83 ec 08             	sub    $0x8,%esp
  800a79:	ff 75 0c             	pushl  0xc(%ebp)
  800a7c:	6a 20                	push   $0x20
  800a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a81:	ff d0                	call   *%eax
  800a83:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a86:	ff 4d e4             	decl   -0x1c(%ebp)
  800a89:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a8d:	7f e7                	jg     800a76 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a8f:	e9 66 01 00 00       	jmp    800bfa <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a94:	83 ec 08             	sub    $0x8,%esp
  800a97:	ff 75 e8             	pushl  -0x18(%ebp)
  800a9a:	8d 45 14             	lea    0x14(%ebp),%eax
  800a9d:	50                   	push   %eax
  800a9e:	e8 3c fd ff ff       	call   8007df <getint>
  800aa3:	83 c4 10             	add    $0x10,%esp
  800aa6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aa9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800aac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aaf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ab2:	85 d2                	test   %edx,%edx
  800ab4:	79 23                	jns    800ad9 <vprintfmt+0x29b>
				putch('-', putdat);
  800ab6:	83 ec 08             	sub    $0x8,%esp
  800ab9:	ff 75 0c             	pushl  0xc(%ebp)
  800abc:	6a 2d                	push   $0x2d
  800abe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac1:	ff d0                	call   *%eax
  800ac3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ac6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ac9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800acc:	f7 d8                	neg    %eax
  800ace:	83 d2 00             	adc    $0x0,%edx
  800ad1:	f7 da                	neg    %edx
  800ad3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ad6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ad9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ae0:	e9 bc 00 00 00       	jmp    800ba1 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ae5:	83 ec 08             	sub    $0x8,%esp
  800ae8:	ff 75 e8             	pushl  -0x18(%ebp)
  800aeb:	8d 45 14             	lea    0x14(%ebp),%eax
  800aee:	50                   	push   %eax
  800aef:	e8 84 fc ff ff       	call   800778 <getuint>
  800af4:	83 c4 10             	add    $0x10,%esp
  800af7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800afa:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800afd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b04:	e9 98 00 00 00       	jmp    800ba1 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b09:	83 ec 08             	sub    $0x8,%esp
  800b0c:	ff 75 0c             	pushl  0xc(%ebp)
  800b0f:	6a 58                	push   $0x58
  800b11:	8b 45 08             	mov    0x8(%ebp),%eax
  800b14:	ff d0                	call   *%eax
  800b16:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b19:	83 ec 08             	sub    $0x8,%esp
  800b1c:	ff 75 0c             	pushl  0xc(%ebp)
  800b1f:	6a 58                	push   $0x58
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	ff d0                	call   *%eax
  800b26:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b29:	83 ec 08             	sub    $0x8,%esp
  800b2c:	ff 75 0c             	pushl  0xc(%ebp)
  800b2f:	6a 58                	push   $0x58
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	ff d0                	call   *%eax
  800b36:	83 c4 10             	add    $0x10,%esp
			break;
  800b39:	e9 bc 00 00 00       	jmp    800bfa <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b3e:	83 ec 08             	sub    $0x8,%esp
  800b41:	ff 75 0c             	pushl  0xc(%ebp)
  800b44:	6a 30                	push   $0x30
  800b46:	8b 45 08             	mov    0x8(%ebp),%eax
  800b49:	ff d0                	call   *%eax
  800b4b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b4e:	83 ec 08             	sub    $0x8,%esp
  800b51:	ff 75 0c             	pushl  0xc(%ebp)
  800b54:	6a 78                	push   $0x78
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	ff d0                	call   *%eax
  800b5b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b61:	83 c0 04             	add    $0x4,%eax
  800b64:	89 45 14             	mov    %eax,0x14(%ebp)
  800b67:	8b 45 14             	mov    0x14(%ebp),%eax
  800b6a:	83 e8 04             	sub    $0x4,%eax
  800b6d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b72:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b79:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b80:	eb 1f                	jmp    800ba1 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b82:	83 ec 08             	sub    $0x8,%esp
  800b85:	ff 75 e8             	pushl  -0x18(%ebp)
  800b88:	8d 45 14             	lea    0x14(%ebp),%eax
  800b8b:	50                   	push   %eax
  800b8c:	e8 e7 fb ff ff       	call   800778 <getuint>
  800b91:	83 c4 10             	add    $0x10,%esp
  800b94:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b97:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b9a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ba1:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ba5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ba8:	83 ec 04             	sub    $0x4,%esp
  800bab:	52                   	push   %edx
  800bac:	ff 75 e4             	pushl  -0x1c(%ebp)
  800baf:	50                   	push   %eax
  800bb0:	ff 75 f4             	pushl  -0xc(%ebp)
  800bb3:	ff 75 f0             	pushl  -0x10(%ebp)
  800bb6:	ff 75 0c             	pushl  0xc(%ebp)
  800bb9:	ff 75 08             	pushl  0x8(%ebp)
  800bbc:	e8 00 fb ff ff       	call   8006c1 <printnum>
  800bc1:	83 c4 20             	add    $0x20,%esp
			break;
  800bc4:	eb 34                	jmp    800bfa <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bc6:	83 ec 08             	sub    $0x8,%esp
  800bc9:	ff 75 0c             	pushl  0xc(%ebp)
  800bcc:	53                   	push   %ebx
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	ff d0                	call   *%eax
  800bd2:	83 c4 10             	add    $0x10,%esp
			break;
  800bd5:	eb 23                	jmp    800bfa <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bd7:	83 ec 08             	sub    $0x8,%esp
  800bda:	ff 75 0c             	pushl  0xc(%ebp)
  800bdd:	6a 25                	push   $0x25
  800bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800be2:	ff d0                	call   *%eax
  800be4:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800be7:	ff 4d 10             	decl   0x10(%ebp)
  800bea:	eb 03                	jmp    800bef <vprintfmt+0x3b1>
  800bec:	ff 4d 10             	decl   0x10(%ebp)
  800bef:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf2:	48                   	dec    %eax
  800bf3:	8a 00                	mov    (%eax),%al
  800bf5:	3c 25                	cmp    $0x25,%al
  800bf7:	75 f3                	jne    800bec <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800bf9:	90                   	nop
		}
	}
  800bfa:	e9 47 fc ff ff       	jmp    800846 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bff:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c00:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c03:	5b                   	pop    %ebx
  800c04:	5e                   	pop    %esi
  800c05:	5d                   	pop    %ebp
  800c06:	c3                   	ret    

00800c07 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c0d:	8d 45 10             	lea    0x10(%ebp),%eax
  800c10:	83 c0 04             	add    $0x4,%eax
  800c13:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c16:	8b 45 10             	mov    0x10(%ebp),%eax
  800c19:	ff 75 f4             	pushl  -0xc(%ebp)
  800c1c:	50                   	push   %eax
  800c1d:	ff 75 0c             	pushl  0xc(%ebp)
  800c20:	ff 75 08             	pushl  0x8(%ebp)
  800c23:	e8 16 fc ff ff       	call   80083e <vprintfmt>
  800c28:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c2b:	90                   	nop
  800c2c:	c9                   	leave  
  800c2d:	c3                   	ret    

00800c2e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c2e:	55                   	push   %ebp
  800c2f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c34:	8b 40 08             	mov    0x8(%eax),%eax
  800c37:	8d 50 01             	lea    0x1(%eax),%edx
  800c3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c43:	8b 10                	mov    (%eax),%edx
  800c45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c48:	8b 40 04             	mov    0x4(%eax),%eax
  800c4b:	39 c2                	cmp    %eax,%edx
  800c4d:	73 12                	jae    800c61 <sprintputch+0x33>
		*b->buf++ = ch;
  800c4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c52:	8b 00                	mov    (%eax),%eax
  800c54:	8d 48 01             	lea    0x1(%eax),%ecx
  800c57:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c5a:	89 0a                	mov    %ecx,(%edx)
  800c5c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c5f:	88 10                	mov    %dl,(%eax)
}
  800c61:	90                   	nop
  800c62:	5d                   	pop    %ebp
  800c63:	c3                   	ret    

00800c64 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c64:	55                   	push   %ebp
  800c65:	89 e5                	mov    %esp,%ebp
  800c67:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c73:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	01 d0                	add    %edx,%eax
  800c7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c7e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c85:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c89:	74 06                	je     800c91 <vsnprintf+0x2d>
  800c8b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c8f:	7f 07                	jg     800c98 <vsnprintf+0x34>
		return -E_INVAL;
  800c91:	b8 03 00 00 00       	mov    $0x3,%eax
  800c96:	eb 20                	jmp    800cb8 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c98:	ff 75 14             	pushl  0x14(%ebp)
  800c9b:	ff 75 10             	pushl  0x10(%ebp)
  800c9e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ca1:	50                   	push   %eax
  800ca2:	68 2e 0c 80 00       	push   $0x800c2e
  800ca7:	e8 92 fb ff ff       	call   80083e <vprintfmt>
  800cac:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800caf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cb2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800cb8:	c9                   	leave  
  800cb9:	c3                   	ret    

00800cba <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cba:	55                   	push   %ebp
  800cbb:	89 e5                	mov    %esp,%ebp
  800cbd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800cc0:	8d 45 10             	lea    0x10(%ebp),%eax
  800cc3:	83 c0 04             	add    $0x4,%eax
  800cc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800cc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800ccc:	ff 75 f4             	pushl  -0xc(%ebp)
  800ccf:	50                   	push   %eax
  800cd0:	ff 75 0c             	pushl  0xc(%ebp)
  800cd3:	ff 75 08             	pushl  0x8(%ebp)
  800cd6:	e8 89 ff ff ff       	call   800c64 <vsnprintf>
  800cdb:	83 c4 10             	add    $0x10,%esp
  800cde:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ce1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ce4:	c9                   	leave  
  800ce5:	c3                   	ret    

00800ce6 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ce6:	55                   	push   %ebp
  800ce7:	89 e5                	mov    %esp,%ebp
  800ce9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800cec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cf3:	eb 06                	jmp    800cfb <strlen+0x15>
		n++;
  800cf5:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cf8:	ff 45 08             	incl   0x8(%ebp)
  800cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfe:	8a 00                	mov    (%eax),%al
  800d00:	84 c0                	test   %al,%al
  800d02:	75 f1                	jne    800cf5 <strlen+0xf>
		n++;
	return n;
  800d04:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d07:	c9                   	leave  
  800d08:	c3                   	ret    

00800d09 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d09:	55                   	push   %ebp
  800d0a:	89 e5                	mov    %esp,%ebp
  800d0c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d0f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d16:	eb 09                	jmp    800d21 <strnlen+0x18>
		n++;
  800d18:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d1b:	ff 45 08             	incl   0x8(%ebp)
  800d1e:	ff 4d 0c             	decl   0xc(%ebp)
  800d21:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d25:	74 09                	je     800d30 <strnlen+0x27>
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	8a 00                	mov    (%eax),%al
  800d2c:	84 c0                	test   %al,%al
  800d2e:	75 e8                	jne    800d18 <strnlen+0xf>
		n++;
	return n;
  800d30:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d33:	c9                   	leave  
  800d34:	c3                   	ret    

00800d35 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d35:	55                   	push   %ebp
  800d36:	89 e5                	mov    %esp,%ebp
  800d38:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d41:	90                   	nop
  800d42:	8b 45 08             	mov    0x8(%ebp),%eax
  800d45:	8d 50 01             	lea    0x1(%eax),%edx
  800d48:	89 55 08             	mov    %edx,0x8(%ebp)
  800d4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d4e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d51:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d54:	8a 12                	mov    (%edx),%dl
  800d56:	88 10                	mov    %dl,(%eax)
  800d58:	8a 00                	mov    (%eax),%al
  800d5a:	84 c0                	test   %al,%al
  800d5c:	75 e4                	jne    800d42 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d61:	c9                   	leave  
  800d62:	c3                   	ret    

00800d63 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d63:	55                   	push   %ebp
  800d64:	89 e5                	mov    %esp,%ebp
  800d66:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d69:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d6f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d76:	eb 1f                	jmp    800d97 <strncpy+0x34>
		*dst++ = *src;
  800d78:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7b:	8d 50 01             	lea    0x1(%eax),%edx
  800d7e:	89 55 08             	mov    %edx,0x8(%ebp)
  800d81:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d84:	8a 12                	mov    (%edx),%dl
  800d86:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8b:	8a 00                	mov    (%eax),%al
  800d8d:	84 c0                	test   %al,%al
  800d8f:	74 03                	je     800d94 <strncpy+0x31>
			src++;
  800d91:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d94:	ff 45 fc             	incl   -0x4(%ebp)
  800d97:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d9a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d9d:	72 d9                	jb     800d78 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d9f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800da2:	c9                   	leave  
  800da3:	c3                   	ret    

00800da4 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800da4:	55                   	push   %ebp
  800da5:	89 e5                	mov    %esp,%ebp
  800da7:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800daa:	8b 45 08             	mov    0x8(%ebp),%eax
  800dad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800db0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800db4:	74 30                	je     800de6 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800db6:	eb 16                	jmp    800dce <strlcpy+0x2a>
			*dst++ = *src++;
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	8d 50 01             	lea    0x1(%eax),%edx
  800dbe:	89 55 08             	mov    %edx,0x8(%ebp)
  800dc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dc7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800dca:	8a 12                	mov    (%edx),%dl
  800dcc:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800dce:	ff 4d 10             	decl   0x10(%ebp)
  800dd1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd5:	74 09                	je     800de0 <strlcpy+0x3c>
  800dd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dda:	8a 00                	mov    (%eax),%al
  800ddc:	84 c0                	test   %al,%al
  800dde:	75 d8                	jne    800db8 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800de6:	8b 55 08             	mov    0x8(%ebp),%edx
  800de9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dec:	29 c2                	sub    %eax,%edx
  800dee:	89 d0                	mov    %edx,%eax
}
  800df0:	c9                   	leave  
  800df1:	c3                   	ret    

00800df2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800df2:	55                   	push   %ebp
  800df3:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800df5:	eb 06                	jmp    800dfd <strcmp+0xb>
		p++, q++;
  800df7:	ff 45 08             	incl   0x8(%ebp)
  800dfa:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800e00:	8a 00                	mov    (%eax),%al
  800e02:	84 c0                	test   %al,%al
  800e04:	74 0e                	je     800e14 <strcmp+0x22>
  800e06:	8b 45 08             	mov    0x8(%ebp),%eax
  800e09:	8a 10                	mov    (%eax),%dl
  800e0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0e:	8a 00                	mov    (%eax),%al
  800e10:	38 c2                	cmp    %al,%dl
  800e12:	74 e3                	je     800df7 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e14:	8b 45 08             	mov    0x8(%ebp),%eax
  800e17:	8a 00                	mov    (%eax),%al
  800e19:	0f b6 d0             	movzbl %al,%edx
  800e1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1f:	8a 00                	mov    (%eax),%al
  800e21:	0f b6 c0             	movzbl %al,%eax
  800e24:	29 c2                	sub    %eax,%edx
  800e26:	89 d0                	mov    %edx,%eax
}
  800e28:	5d                   	pop    %ebp
  800e29:	c3                   	ret    

00800e2a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e2a:	55                   	push   %ebp
  800e2b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e2d:	eb 09                	jmp    800e38 <strncmp+0xe>
		n--, p++, q++;
  800e2f:	ff 4d 10             	decl   0x10(%ebp)
  800e32:	ff 45 08             	incl   0x8(%ebp)
  800e35:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e38:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e3c:	74 17                	je     800e55 <strncmp+0x2b>
  800e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e41:	8a 00                	mov    (%eax),%al
  800e43:	84 c0                	test   %al,%al
  800e45:	74 0e                	je     800e55 <strncmp+0x2b>
  800e47:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4a:	8a 10                	mov    (%eax),%dl
  800e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4f:	8a 00                	mov    (%eax),%al
  800e51:	38 c2                	cmp    %al,%dl
  800e53:	74 da                	je     800e2f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e55:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e59:	75 07                	jne    800e62 <strncmp+0x38>
		return 0;
  800e5b:	b8 00 00 00 00       	mov    $0x0,%eax
  800e60:	eb 14                	jmp    800e76 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e62:	8b 45 08             	mov    0x8(%ebp),%eax
  800e65:	8a 00                	mov    (%eax),%al
  800e67:	0f b6 d0             	movzbl %al,%edx
  800e6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6d:	8a 00                	mov    (%eax),%al
  800e6f:	0f b6 c0             	movzbl %al,%eax
  800e72:	29 c2                	sub    %eax,%edx
  800e74:	89 d0                	mov    %edx,%eax
}
  800e76:	5d                   	pop    %ebp
  800e77:	c3                   	ret    

00800e78 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e78:	55                   	push   %ebp
  800e79:	89 e5                	mov    %esp,%ebp
  800e7b:	83 ec 04             	sub    $0x4,%esp
  800e7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e81:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e84:	eb 12                	jmp    800e98 <strchr+0x20>
		if (*s == c)
  800e86:	8b 45 08             	mov    0x8(%ebp),%eax
  800e89:	8a 00                	mov    (%eax),%al
  800e8b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e8e:	75 05                	jne    800e95 <strchr+0x1d>
			return (char *) s;
  800e90:	8b 45 08             	mov    0x8(%ebp),%eax
  800e93:	eb 11                	jmp    800ea6 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e95:	ff 45 08             	incl   0x8(%ebp)
  800e98:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9b:	8a 00                	mov    (%eax),%al
  800e9d:	84 c0                	test   %al,%al
  800e9f:	75 e5                	jne    800e86 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ea1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ea6:	c9                   	leave  
  800ea7:	c3                   	ret    

00800ea8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ea8:	55                   	push   %ebp
  800ea9:	89 e5                	mov    %esp,%ebp
  800eab:	83 ec 04             	sub    $0x4,%esp
  800eae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800eb4:	eb 0d                	jmp    800ec3 <strfind+0x1b>
		if (*s == c)
  800eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb9:	8a 00                	mov    (%eax),%al
  800ebb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ebe:	74 0e                	je     800ece <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ec0:	ff 45 08             	incl   0x8(%ebp)
  800ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec6:	8a 00                	mov    (%eax),%al
  800ec8:	84 c0                	test   %al,%al
  800eca:	75 ea                	jne    800eb6 <strfind+0xe>
  800ecc:	eb 01                	jmp    800ecf <strfind+0x27>
		if (*s == c)
			break;
  800ece:	90                   	nop
	return (char *) s;
  800ecf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ed2:	c9                   	leave  
  800ed3:	c3                   	ret    

00800ed4 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ed4:	55                   	push   %ebp
  800ed5:	89 e5                	mov    %esp,%ebp
  800ed7:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800eda:	8b 45 08             	mov    0x8(%ebp),%eax
  800edd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ee0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ee6:	eb 0e                	jmp    800ef6 <memset+0x22>
		*p++ = c;
  800ee8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eeb:	8d 50 01             	lea    0x1(%eax),%edx
  800eee:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ef1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ef4:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ef6:	ff 4d f8             	decl   -0x8(%ebp)
  800ef9:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800efd:	79 e9                	jns    800ee8 <memset+0x14>
		*p++ = c;

	return v;
  800eff:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f02:	c9                   	leave  
  800f03:	c3                   	ret    

00800f04 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f04:	55                   	push   %ebp
  800f05:	89 e5                	mov    %esp,%ebp
  800f07:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
  800f13:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f16:	eb 16                	jmp    800f2e <memcpy+0x2a>
		*d++ = *s++;
  800f18:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f1b:	8d 50 01             	lea    0x1(%eax),%edx
  800f1e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f21:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f24:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f27:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f2a:	8a 12                	mov    (%edx),%dl
  800f2c:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f31:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f34:	89 55 10             	mov    %edx,0x10(%ebp)
  800f37:	85 c0                	test   %eax,%eax
  800f39:	75 dd                	jne    800f18 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f3e:	c9                   	leave  
  800f3f:	c3                   	ret    

00800f40 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f40:	55                   	push   %ebp
  800f41:	89 e5                	mov    %esp,%ebp
  800f43:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f49:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f52:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f55:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f58:	73 50                	jae    800faa <memmove+0x6a>
  800f5a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f5d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f60:	01 d0                	add    %edx,%eax
  800f62:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f65:	76 43                	jbe    800faa <memmove+0x6a>
		s += n;
  800f67:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f6d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f70:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f73:	eb 10                	jmp    800f85 <memmove+0x45>
			*--d = *--s;
  800f75:	ff 4d f8             	decl   -0x8(%ebp)
  800f78:	ff 4d fc             	decl   -0x4(%ebp)
  800f7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f7e:	8a 10                	mov    (%eax),%dl
  800f80:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f83:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f85:	8b 45 10             	mov    0x10(%ebp),%eax
  800f88:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f8b:	89 55 10             	mov    %edx,0x10(%ebp)
  800f8e:	85 c0                	test   %eax,%eax
  800f90:	75 e3                	jne    800f75 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f92:	eb 23                	jmp    800fb7 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f94:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f97:	8d 50 01             	lea    0x1(%eax),%edx
  800f9a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f9d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fa0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fa3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fa6:	8a 12                	mov    (%edx),%dl
  800fa8:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800faa:	8b 45 10             	mov    0x10(%ebp),%eax
  800fad:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fb0:	89 55 10             	mov    %edx,0x10(%ebp)
  800fb3:	85 c0                	test   %eax,%eax
  800fb5:	75 dd                	jne    800f94 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fba:	c9                   	leave  
  800fbb:	c3                   	ret    

00800fbc <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fbc:	55                   	push   %ebp
  800fbd:	89 e5                	mov    %esp,%ebp
  800fbf:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcb:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fce:	eb 2a                	jmp    800ffa <memcmp+0x3e>
		if (*s1 != *s2)
  800fd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd3:	8a 10                	mov    (%eax),%dl
  800fd5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd8:	8a 00                	mov    (%eax),%al
  800fda:	38 c2                	cmp    %al,%dl
  800fdc:	74 16                	je     800ff4 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fde:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe1:	8a 00                	mov    (%eax),%al
  800fe3:	0f b6 d0             	movzbl %al,%edx
  800fe6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe9:	8a 00                	mov    (%eax),%al
  800feb:	0f b6 c0             	movzbl %al,%eax
  800fee:	29 c2                	sub    %eax,%edx
  800ff0:	89 d0                	mov    %edx,%eax
  800ff2:	eb 18                	jmp    80100c <memcmp+0x50>
		s1++, s2++;
  800ff4:	ff 45 fc             	incl   -0x4(%ebp)
  800ff7:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ffa:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffd:	8d 50 ff             	lea    -0x1(%eax),%edx
  801000:	89 55 10             	mov    %edx,0x10(%ebp)
  801003:	85 c0                	test   %eax,%eax
  801005:	75 c9                	jne    800fd0 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801007:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80100c:	c9                   	leave  
  80100d:	c3                   	ret    

0080100e <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80100e:	55                   	push   %ebp
  80100f:	89 e5                	mov    %esp,%ebp
  801011:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801014:	8b 55 08             	mov    0x8(%ebp),%edx
  801017:	8b 45 10             	mov    0x10(%ebp),%eax
  80101a:	01 d0                	add    %edx,%eax
  80101c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80101f:	eb 15                	jmp    801036 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801021:	8b 45 08             	mov    0x8(%ebp),%eax
  801024:	8a 00                	mov    (%eax),%al
  801026:	0f b6 d0             	movzbl %al,%edx
  801029:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102c:	0f b6 c0             	movzbl %al,%eax
  80102f:	39 c2                	cmp    %eax,%edx
  801031:	74 0d                	je     801040 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801033:	ff 45 08             	incl   0x8(%ebp)
  801036:	8b 45 08             	mov    0x8(%ebp),%eax
  801039:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80103c:	72 e3                	jb     801021 <memfind+0x13>
  80103e:	eb 01                	jmp    801041 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801040:	90                   	nop
	return (void *) s;
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801044:	c9                   	leave  
  801045:	c3                   	ret    

00801046 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801046:	55                   	push   %ebp
  801047:	89 e5                	mov    %esp,%ebp
  801049:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80104c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801053:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80105a:	eb 03                	jmp    80105f <strtol+0x19>
		s++;
  80105c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80105f:	8b 45 08             	mov    0x8(%ebp),%eax
  801062:	8a 00                	mov    (%eax),%al
  801064:	3c 20                	cmp    $0x20,%al
  801066:	74 f4                	je     80105c <strtol+0x16>
  801068:	8b 45 08             	mov    0x8(%ebp),%eax
  80106b:	8a 00                	mov    (%eax),%al
  80106d:	3c 09                	cmp    $0x9,%al
  80106f:	74 eb                	je     80105c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801071:	8b 45 08             	mov    0x8(%ebp),%eax
  801074:	8a 00                	mov    (%eax),%al
  801076:	3c 2b                	cmp    $0x2b,%al
  801078:	75 05                	jne    80107f <strtol+0x39>
		s++;
  80107a:	ff 45 08             	incl   0x8(%ebp)
  80107d:	eb 13                	jmp    801092 <strtol+0x4c>
	else if (*s == '-')
  80107f:	8b 45 08             	mov    0x8(%ebp),%eax
  801082:	8a 00                	mov    (%eax),%al
  801084:	3c 2d                	cmp    $0x2d,%al
  801086:	75 0a                	jne    801092 <strtol+0x4c>
		s++, neg = 1;
  801088:	ff 45 08             	incl   0x8(%ebp)
  80108b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801092:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801096:	74 06                	je     80109e <strtol+0x58>
  801098:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80109c:	75 20                	jne    8010be <strtol+0x78>
  80109e:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a1:	8a 00                	mov    (%eax),%al
  8010a3:	3c 30                	cmp    $0x30,%al
  8010a5:	75 17                	jne    8010be <strtol+0x78>
  8010a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010aa:	40                   	inc    %eax
  8010ab:	8a 00                	mov    (%eax),%al
  8010ad:	3c 78                	cmp    $0x78,%al
  8010af:	75 0d                	jne    8010be <strtol+0x78>
		s += 2, base = 16;
  8010b1:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010b5:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010bc:	eb 28                	jmp    8010e6 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010be:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010c2:	75 15                	jne    8010d9 <strtol+0x93>
  8010c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c7:	8a 00                	mov    (%eax),%al
  8010c9:	3c 30                	cmp    $0x30,%al
  8010cb:	75 0c                	jne    8010d9 <strtol+0x93>
		s++, base = 8;
  8010cd:	ff 45 08             	incl   0x8(%ebp)
  8010d0:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010d7:	eb 0d                	jmp    8010e6 <strtol+0xa0>
	else if (base == 0)
  8010d9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010dd:	75 07                	jne    8010e6 <strtol+0xa0>
		base = 10;
  8010df:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	8a 00                	mov    (%eax),%al
  8010eb:	3c 2f                	cmp    $0x2f,%al
  8010ed:	7e 19                	jle    801108 <strtol+0xc2>
  8010ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f2:	8a 00                	mov    (%eax),%al
  8010f4:	3c 39                	cmp    $0x39,%al
  8010f6:	7f 10                	jg     801108 <strtol+0xc2>
			dig = *s - '0';
  8010f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fb:	8a 00                	mov    (%eax),%al
  8010fd:	0f be c0             	movsbl %al,%eax
  801100:	83 e8 30             	sub    $0x30,%eax
  801103:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801106:	eb 42                	jmp    80114a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801108:	8b 45 08             	mov    0x8(%ebp),%eax
  80110b:	8a 00                	mov    (%eax),%al
  80110d:	3c 60                	cmp    $0x60,%al
  80110f:	7e 19                	jle    80112a <strtol+0xe4>
  801111:	8b 45 08             	mov    0x8(%ebp),%eax
  801114:	8a 00                	mov    (%eax),%al
  801116:	3c 7a                	cmp    $0x7a,%al
  801118:	7f 10                	jg     80112a <strtol+0xe4>
			dig = *s - 'a' + 10;
  80111a:	8b 45 08             	mov    0x8(%ebp),%eax
  80111d:	8a 00                	mov    (%eax),%al
  80111f:	0f be c0             	movsbl %al,%eax
  801122:	83 e8 57             	sub    $0x57,%eax
  801125:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801128:	eb 20                	jmp    80114a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80112a:	8b 45 08             	mov    0x8(%ebp),%eax
  80112d:	8a 00                	mov    (%eax),%al
  80112f:	3c 40                	cmp    $0x40,%al
  801131:	7e 39                	jle    80116c <strtol+0x126>
  801133:	8b 45 08             	mov    0x8(%ebp),%eax
  801136:	8a 00                	mov    (%eax),%al
  801138:	3c 5a                	cmp    $0x5a,%al
  80113a:	7f 30                	jg     80116c <strtol+0x126>
			dig = *s - 'A' + 10;
  80113c:	8b 45 08             	mov    0x8(%ebp),%eax
  80113f:	8a 00                	mov    (%eax),%al
  801141:	0f be c0             	movsbl %al,%eax
  801144:	83 e8 37             	sub    $0x37,%eax
  801147:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80114a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80114d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801150:	7d 19                	jge    80116b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801152:	ff 45 08             	incl   0x8(%ebp)
  801155:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801158:	0f af 45 10          	imul   0x10(%ebp),%eax
  80115c:	89 c2                	mov    %eax,%edx
  80115e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801161:	01 d0                	add    %edx,%eax
  801163:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801166:	e9 7b ff ff ff       	jmp    8010e6 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80116b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80116c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801170:	74 08                	je     80117a <strtol+0x134>
		*endptr = (char *) s;
  801172:	8b 45 0c             	mov    0xc(%ebp),%eax
  801175:	8b 55 08             	mov    0x8(%ebp),%edx
  801178:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80117a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80117e:	74 07                	je     801187 <strtol+0x141>
  801180:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801183:	f7 d8                	neg    %eax
  801185:	eb 03                	jmp    80118a <strtol+0x144>
  801187:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80118a:	c9                   	leave  
  80118b:	c3                   	ret    

0080118c <ltostr>:

void
ltostr(long value, char *str)
{
  80118c:	55                   	push   %ebp
  80118d:	89 e5                	mov    %esp,%ebp
  80118f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801192:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801199:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011a4:	79 13                	jns    8011b9 <ltostr+0x2d>
	{
		neg = 1;
  8011a6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b0:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011b3:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011b6:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bc:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011c1:	99                   	cltd   
  8011c2:	f7 f9                	idiv   %ecx
  8011c4:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ca:	8d 50 01             	lea    0x1(%eax),%edx
  8011cd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011d0:	89 c2                	mov    %eax,%edx
  8011d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d5:	01 d0                	add    %edx,%eax
  8011d7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011da:	83 c2 30             	add    $0x30,%edx
  8011dd:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011e2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011e7:	f7 e9                	imul   %ecx
  8011e9:	c1 fa 02             	sar    $0x2,%edx
  8011ec:	89 c8                	mov    %ecx,%eax
  8011ee:	c1 f8 1f             	sar    $0x1f,%eax
  8011f1:	29 c2                	sub    %eax,%edx
  8011f3:	89 d0                	mov    %edx,%eax
  8011f5:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011fb:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801200:	f7 e9                	imul   %ecx
  801202:	c1 fa 02             	sar    $0x2,%edx
  801205:	89 c8                	mov    %ecx,%eax
  801207:	c1 f8 1f             	sar    $0x1f,%eax
  80120a:	29 c2                	sub    %eax,%edx
  80120c:	89 d0                	mov    %edx,%eax
  80120e:	c1 e0 02             	shl    $0x2,%eax
  801211:	01 d0                	add    %edx,%eax
  801213:	01 c0                	add    %eax,%eax
  801215:	29 c1                	sub    %eax,%ecx
  801217:	89 ca                	mov    %ecx,%edx
  801219:	85 d2                	test   %edx,%edx
  80121b:	75 9c                	jne    8011b9 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80121d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801224:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801227:	48                   	dec    %eax
  801228:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80122b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80122f:	74 3d                	je     80126e <ltostr+0xe2>
		start = 1 ;
  801231:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801238:	eb 34                	jmp    80126e <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80123a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80123d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801240:	01 d0                	add    %edx,%eax
  801242:	8a 00                	mov    (%eax),%al
  801244:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801247:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80124a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124d:	01 c2                	add    %eax,%edx
  80124f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801252:	8b 45 0c             	mov    0xc(%ebp),%eax
  801255:	01 c8                	add    %ecx,%eax
  801257:	8a 00                	mov    (%eax),%al
  801259:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80125b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80125e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801261:	01 c2                	add    %eax,%edx
  801263:	8a 45 eb             	mov    -0x15(%ebp),%al
  801266:	88 02                	mov    %al,(%edx)
		start++ ;
  801268:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80126b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80126e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801271:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801274:	7c c4                	jl     80123a <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801276:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801279:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127c:	01 d0                	add    %edx,%eax
  80127e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801281:	90                   	nop
  801282:	c9                   	leave  
  801283:	c3                   	ret    

00801284 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801284:	55                   	push   %ebp
  801285:	89 e5                	mov    %esp,%ebp
  801287:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80128a:	ff 75 08             	pushl  0x8(%ebp)
  80128d:	e8 54 fa ff ff       	call   800ce6 <strlen>
  801292:	83 c4 04             	add    $0x4,%esp
  801295:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801298:	ff 75 0c             	pushl  0xc(%ebp)
  80129b:	e8 46 fa ff ff       	call   800ce6 <strlen>
  8012a0:	83 c4 04             	add    $0x4,%esp
  8012a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012a6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012b4:	eb 17                	jmp    8012cd <strcconcat+0x49>
		final[s] = str1[s] ;
  8012b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012bc:	01 c2                	add    %eax,%edx
  8012be:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c4:	01 c8                	add    %ecx,%eax
  8012c6:	8a 00                	mov    (%eax),%al
  8012c8:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012ca:	ff 45 fc             	incl   -0x4(%ebp)
  8012cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012d0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012d3:	7c e1                	jl     8012b6 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012d5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012dc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012e3:	eb 1f                	jmp    801304 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012e8:	8d 50 01             	lea    0x1(%eax),%edx
  8012eb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012ee:	89 c2                	mov    %eax,%edx
  8012f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f3:	01 c2                	add    %eax,%edx
  8012f5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fb:	01 c8                	add    %ecx,%eax
  8012fd:	8a 00                	mov    (%eax),%al
  8012ff:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801301:	ff 45 f8             	incl   -0x8(%ebp)
  801304:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801307:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80130a:	7c d9                	jl     8012e5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80130c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80130f:	8b 45 10             	mov    0x10(%ebp),%eax
  801312:	01 d0                	add    %edx,%eax
  801314:	c6 00 00             	movb   $0x0,(%eax)
}
  801317:	90                   	nop
  801318:	c9                   	leave  
  801319:	c3                   	ret    

0080131a <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80131a:	55                   	push   %ebp
  80131b:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80131d:	8b 45 14             	mov    0x14(%ebp),%eax
  801320:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801326:	8b 45 14             	mov    0x14(%ebp),%eax
  801329:	8b 00                	mov    (%eax),%eax
  80132b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801332:	8b 45 10             	mov    0x10(%ebp),%eax
  801335:	01 d0                	add    %edx,%eax
  801337:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80133d:	eb 0c                	jmp    80134b <strsplit+0x31>
			*string++ = 0;
  80133f:	8b 45 08             	mov    0x8(%ebp),%eax
  801342:	8d 50 01             	lea    0x1(%eax),%edx
  801345:	89 55 08             	mov    %edx,0x8(%ebp)
  801348:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80134b:	8b 45 08             	mov    0x8(%ebp),%eax
  80134e:	8a 00                	mov    (%eax),%al
  801350:	84 c0                	test   %al,%al
  801352:	74 18                	je     80136c <strsplit+0x52>
  801354:	8b 45 08             	mov    0x8(%ebp),%eax
  801357:	8a 00                	mov    (%eax),%al
  801359:	0f be c0             	movsbl %al,%eax
  80135c:	50                   	push   %eax
  80135d:	ff 75 0c             	pushl  0xc(%ebp)
  801360:	e8 13 fb ff ff       	call   800e78 <strchr>
  801365:	83 c4 08             	add    $0x8,%esp
  801368:	85 c0                	test   %eax,%eax
  80136a:	75 d3                	jne    80133f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80136c:	8b 45 08             	mov    0x8(%ebp),%eax
  80136f:	8a 00                	mov    (%eax),%al
  801371:	84 c0                	test   %al,%al
  801373:	74 5a                	je     8013cf <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801375:	8b 45 14             	mov    0x14(%ebp),%eax
  801378:	8b 00                	mov    (%eax),%eax
  80137a:	83 f8 0f             	cmp    $0xf,%eax
  80137d:	75 07                	jne    801386 <strsplit+0x6c>
		{
			return 0;
  80137f:	b8 00 00 00 00       	mov    $0x0,%eax
  801384:	eb 66                	jmp    8013ec <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801386:	8b 45 14             	mov    0x14(%ebp),%eax
  801389:	8b 00                	mov    (%eax),%eax
  80138b:	8d 48 01             	lea    0x1(%eax),%ecx
  80138e:	8b 55 14             	mov    0x14(%ebp),%edx
  801391:	89 0a                	mov    %ecx,(%edx)
  801393:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80139a:	8b 45 10             	mov    0x10(%ebp),%eax
  80139d:	01 c2                	add    %eax,%edx
  80139f:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a2:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013a4:	eb 03                	jmp    8013a9 <strsplit+0x8f>
			string++;
  8013a6:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ac:	8a 00                	mov    (%eax),%al
  8013ae:	84 c0                	test   %al,%al
  8013b0:	74 8b                	je     80133d <strsplit+0x23>
  8013b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b5:	8a 00                	mov    (%eax),%al
  8013b7:	0f be c0             	movsbl %al,%eax
  8013ba:	50                   	push   %eax
  8013bb:	ff 75 0c             	pushl  0xc(%ebp)
  8013be:	e8 b5 fa ff ff       	call   800e78 <strchr>
  8013c3:	83 c4 08             	add    $0x8,%esp
  8013c6:	85 c0                	test   %eax,%eax
  8013c8:	74 dc                	je     8013a6 <strsplit+0x8c>
			string++;
	}
  8013ca:	e9 6e ff ff ff       	jmp    80133d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013cf:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8013d3:	8b 00                	mov    (%eax),%eax
  8013d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8013df:	01 d0                	add    %edx,%eax
  8013e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013e7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013ec:	c9                   	leave  
  8013ed:	c3                   	ret    

008013ee <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8013ee:	55                   	push   %ebp
  8013ef:	89 e5                	mov    %esp,%ebp
  8013f1:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8013f4:	a1 04 40 80 00       	mov    0x804004,%eax
  8013f9:	85 c0                	test   %eax,%eax
  8013fb:	74 1f                	je     80141c <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8013fd:	e8 1d 00 00 00       	call   80141f <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801402:	83 ec 0c             	sub    $0xc,%esp
  801405:	68 70 3a 80 00       	push   $0x803a70
  80140a:	e8 55 f2 ff ff       	call   800664 <cprintf>
  80140f:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801412:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801419:	00 00 00 
	}
}
  80141c:	90                   	nop
  80141d:	c9                   	leave  
  80141e:	c3                   	ret    

0080141f <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80141f:	55                   	push   %ebp
  801420:	89 e5                	mov    %esp,%ebp
  801422:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  801425:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80142c:	00 00 00 
  80142f:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801436:	00 00 00 
  801439:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801440:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  801443:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80144a:	00 00 00 
  80144d:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801454:	00 00 00 
  801457:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80145e:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  801461:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801468:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80146b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801470:	2d 00 10 00 00       	sub    $0x1000,%eax
  801475:	a3 50 40 80 00       	mov    %eax,0x804050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  80147a:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801481:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  801484:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80148b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80148e:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  801493:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801496:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801499:	ba 00 00 00 00       	mov    $0x0,%edx
  80149e:	f7 75 f0             	divl   -0x10(%ebp)
  8014a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014a4:	29 d0                	sub    %edx,%eax
  8014a6:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  8014a9:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8014b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014b3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014b8:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014bd:	83 ec 04             	sub    $0x4,%esp
  8014c0:	6a 06                	push   $0x6
  8014c2:	ff 75 e8             	pushl  -0x18(%ebp)
  8014c5:	50                   	push   %eax
  8014c6:	e8 d4 05 00 00       	call   801a9f <sys_allocate_chunk>
  8014cb:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014ce:	a1 20 41 80 00       	mov    0x804120,%eax
  8014d3:	83 ec 0c             	sub    $0xc,%esp
  8014d6:	50                   	push   %eax
  8014d7:	e8 49 0c 00 00       	call   802125 <initialize_MemBlocksList>
  8014dc:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  8014df:	a1 48 41 80 00       	mov    0x804148,%eax
  8014e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  8014e7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014eb:	75 14                	jne    801501 <initialize_dyn_block_system+0xe2>
  8014ed:	83 ec 04             	sub    $0x4,%esp
  8014f0:	68 95 3a 80 00       	push   $0x803a95
  8014f5:	6a 39                	push   $0x39
  8014f7:	68 b3 3a 80 00       	push   $0x803ab3
  8014fc:	e8 af ee ff ff       	call   8003b0 <_panic>
  801501:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801504:	8b 00                	mov    (%eax),%eax
  801506:	85 c0                	test   %eax,%eax
  801508:	74 10                	je     80151a <initialize_dyn_block_system+0xfb>
  80150a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80150d:	8b 00                	mov    (%eax),%eax
  80150f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801512:	8b 52 04             	mov    0x4(%edx),%edx
  801515:	89 50 04             	mov    %edx,0x4(%eax)
  801518:	eb 0b                	jmp    801525 <initialize_dyn_block_system+0x106>
  80151a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80151d:	8b 40 04             	mov    0x4(%eax),%eax
  801520:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801525:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801528:	8b 40 04             	mov    0x4(%eax),%eax
  80152b:	85 c0                	test   %eax,%eax
  80152d:	74 0f                	je     80153e <initialize_dyn_block_system+0x11f>
  80152f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801532:	8b 40 04             	mov    0x4(%eax),%eax
  801535:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801538:	8b 12                	mov    (%edx),%edx
  80153a:	89 10                	mov    %edx,(%eax)
  80153c:	eb 0a                	jmp    801548 <initialize_dyn_block_system+0x129>
  80153e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801541:	8b 00                	mov    (%eax),%eax
  801543:	a3 48 41 80 00       	mov    %eax,0x804148
  801548:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80154b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801551:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801554:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80155b:	a1 54 41 80 00       	mov    0x804154,%eax
  801560:	48                   	dec    %eax
  801561:	a3 54 41 80 00       	mov    %eax,0x804154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  801566:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801569:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  801570:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801573:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  80157a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80157e:	75 14                	jne    801594 <initialize_dyn_block_system+0x175>
  801580:	83 ec 04             	sub    $0x4,%esp
  801583:	68 c0 3a 80 00       	push   $0x803ac0
  801588:	6a 3f                	push   $0x3f
  80158a:	68 b3 3a 80 00       	push   $0x803ab3
  80158f:	e8 1c ee ff ff       	call   8003b0 <_panic>
  801594:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80159a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80159d:	89 10                	mov    %edx,(%eax)
  80159f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015a2:	8b 00                	mov    (%eax),%eax
  8015a4:	85 c0                	test   %eax,%eax
  8015a6:	74 0d                	je     8015b5 <initialize_dyn_block_system+0x196>
  8015a8:	a1 38 41 80 00       	mov    0x804138,%eax
  8015ad:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8015b0:	89 50 04             	mov    %edx,0x4(%eax)
  8015b3:	eb 08                	jmp    8015bd <initialize_dyn_block_system+0x19e>
  8015b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015b8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8015bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015c0:	a3 38 41 80 00       	mov    %eax,0x804138
  8015c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015c8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015cf:	a1 44 41 80 00       	mov    0x804144,%eax
  8015d4:	40                   	inc    %eax
  8015d5:	a3 44 41 80 00       	mov    %eax,0x804144

}
  8015da:	90                   	nop
  8015db:	c9                   	leave  
  8015dc:	c3                   	ret    

008015dd <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8015dd:	55                   	push   %ebp
  8015de:	89 e5                	mov    %esp,%ebp
  8015e0:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015e3:	e8 06 fe ff ff       	call   8013ee <InitializeUHeap>
	if (size == 0) return NULL ;
  8015e8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015ec:	75 07                	jne    8015f5 <malloc+0x18>
  8015ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8015f3:	eb 7d                	jmp    801672 <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  8015f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8015fc:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801603:	8b 55 08             	mov    0x8(%ebp),%edx
  801606:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801609:	01 d0                	add    %edx,%eax
  80160b:	48                   	dec    %eax
  80160c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80160f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801612:	ba 00 00 00 00       	mov    $0x0,%edx
  801617:	f7 75 f0             	divl   -0x10(%ebp)
  80161a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80161d:	29 d0                	sub    %edx,%eax
  80161f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  801622:	e8 46 08 00 00       	call   801e6d <sys_isUHeapPlacementStrategyFIRSTFIT>
  801627:	83 f8 01             	cmp    $0x1,%eax
  80162a:	75 07                	jne    801633 <malloc+0x56>
  80162c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  801633:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  801637:	75 34                	jne    80166d <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  801639:	83 ec 0c             	sub    $0xc,%esp
  80163c:	ff 75 e8             	pushl  -0x18(%ebp)
  80163f:	e8 73 0e 00 00       	call   8024b7 <alloc_block_FF>
  801644:	83 c4 10             	add    $0x10,%esp
  801647:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  80164a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80164e:	74 16                	je     801666 <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  801650:	83 ec 0c             	sub    $0xc,%esp
  801653:	ff 75 e4             	pushl  -0x1c(%ebp)
  801656:	e8 ff 0b 00 00       	call   80225a <insert_sorted_allocList>
  80165b:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  80165e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801661:	8b 40 08             	mov    0x8(%eax),%eax
  801664:	eb 0c                	jmp    801672 <malloc+0x95>
	             }
	             else
	             	return NULL;
  801666:	b8 00 00 00 00       	mov    $0x0,%eax
  80166b:	eb 05                	jmp    801672 <malloc+0x95>
	      	  }
	          else
	               return NULL;
  80166d:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  801672:	c9                   	leave  
  801673:	c3                   	ret    

00801674 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801674:	55                   	push   %ebp
  801675:	89 e5                	mov    %esp,%ebp
  801677:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  80167a:	8b 45 08             	mov    0x8(%ebp),%eax
  80167d:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  801680:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801683:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801686:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801689:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80168e:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  801691:	83 ec 08             	sub    $0x8,%esp
  801694:	ff 75 f4             	pushl  -0xc(%ebp)
  801697:	68 40 40 80 00       	push   $0x804040
  80169c:	e8 61 0b 00 00       	call   802202 <find_block>
  8016a1:	83 c4 10             	add    $0x10,%esp
  8016a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  8016a7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016ab:	0f 84 a5 00 00 00    	je     801756 <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  8016b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8016b7:	83 ec 08             	sub    $0x8,%esp
  8016ba:	50                   	push   %eax
  8016bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8016be:	e8 a4 03 00 00       	call   801a67 <sys_free_user_mem>
  8016c3:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  8016c6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016ca:	75 17                	jne    8016e3 <free+0x6f>
  8016cc:	83 ec 04             	sub    $0x4,%esp
  8016cf:	68 95 3a 80 00       	push   $0x803a95
  8016d4:	68 87 00 00 00       	push   $0x87
  8016d9:	68 b3 3a 80 00       	push   $0x803ab3
  8016de:	e8 cd ec ff ff       	call   8003b0 <_panic>
  8016e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016e6:	8b 00                	mov    (%eax),%eax
  8016e8:	85 c0                	test   %eax,%eax
  8016ea:	74 10                	je     8016fc <free+0x88>
  8016ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016ef:	8b 00                	mov    (%eax),%eax
  8016f1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016f4:	8b 52 04             	mov    0x4(%edx),%edx
  8016f7:	89 50 04             	mov    %edx,0x4(%eax)
  8016fa:	eb 0b                	jmp    801707 <free+0x93>
  8016fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016ff:	8b 40 04             	mov    0x4(%eax),%eax
  801702:	a3 44 40 80 00       	mov    %eax,0x804044
  801707:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80170a:	8b 40 04             	mov    0x4(%eax),%eax
  80170d:	85 c0                	test   %eax,%eax
  80170f:	74 0f                	je     801720 <free+0xac>
  801711:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801714:	8b 40 04             	mov    0x4(%eax),%eax
  801717:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80171a:	8b 12                	mov    (%edx),%edx
  80171c:	89 10                	mov    %edx,(%eax)
  80171e:	eb 0a                	jmp    80172a <free+0xb6>
  801720:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801723:	8b 00                	mov    (%eax),%eax
  801725:	a3 40 40 80 00       	mov    %eax,0x804040
  80172a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80172d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801733:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801736:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80173d:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801742:	48                   	dec    %eax
  801743:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(theBlock);
  801748:	83 ec 0c             	sub    $0xc,%esp
  80174b:	ff 75 ec             	pushl  -0x14(%ebp)
  80174e:	e8 37 12 00 00       	call   80298a <insert_sorted_with_merge_freeList>
  801753:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  801756:	90                   	nop
  801757:	c9                   	leave  
  801758:	c3                   	ret    

00801759 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801759:	55                   	push   %ebp
  80175a:	89 e5                	mov    %esp,%ebp
  80175c:	83 ec 38             	sub    $0x38,%esp
  80175f:	8b 45 10             	mov    0x10(%ebp),%eax
  801762:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801765:	e8 84 fc ff ff       	call   8013ee <InitializeUHeap>
	if (size == 0) return NULL ;
  80176a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80176e:	75 07                	jne    801777 <smalloc+0x1e>
  801770:	b8 00 00 00 00       	mov    $0x0,%eax
  801775:	eb 7e                	jmp    8017f5 <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  801777:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  80177e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801785:	8b 55 0c             	mov    0xc(%ebp),%edx
  801788:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80178b:	01 d0                	add    %edx,%eax
  80178d:	48                   	dec    %eax
  80178e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801791:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801794:	ba 00 00 00 00       	mov    $0x0,%edx
  801799:	f7 75 f0             	divl   -0x10(%ebp)
  80179c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80179f:	29 d0                	sub    %edx,%eax
  8017a1:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  8017a4:	e8 c4 06 00 00       	call   801e6d <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017a9:	83 f8 01             	cmp    $0x1,%eax
  8017ac:	75 42                	jne    8017f0 <smalloc+0x97>

		  va = malloc(newsize) ;
  8017ae:	83 ec 0c             	sub    $0xc,%esp
  8017b1:	ff 75 e8             	pushl  -0x18(%ebp)
  8017b4:	e8 24 fe ff ff       	call   8015dd <malloc>
  8017b9:	83 c4 10             	add    $0x10,%esp
  8017bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  8017bf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8017c3:	74 24                	je     8017e9 <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  8017c5:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8017c9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017cc:	50                   	push   %eax
  8017cd:	ff 75 e8             	pushl  -0x18(%ebp)
  8017d0:	ff 75 08             	pushl  0x8(%ebp)
  8017d3:	e8 1a 04 00 00       	call   801bf2 <sys_createSharedObject>
  8017d8:	83 c4 10             	add    $0x10,%esp
  8017db:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  8017de:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8017e2:	78 0c                	js     8017f0 <smalloc+0x97>
					  return va ;
  8017e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017e7:	eb 0c                	jmp    8017f5 <smalloc+0x9c>
				 }
				 else
					return NULL;
  8017e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ee:	eb 05                	jmp    8017f5 <smalloc+0x9c>
	  }
		  return NULL ;
  8017f0:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8017f5:	c9                   	leave  
  8017f6:	c3                   	ret    

008017f7 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017f7:	55                   	push   %ebp
  8017f8:	89 e5                	mov    %esp,%ebp
  8017fa:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017fd:	e8 ec fb ff ff       	call   8013ee <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  801802:	83 ec 08             	sub    $0x8,%esp
  801805:	ff 75 0c             	pushl  0xc(%ebp)
  801808:	ff 75 08             	pushl  0x8(%ebp)
  80180b:	e8 0c 04 00 00       	call   801c1c <sys_getSizeOfSharedObject>
  801810:	83 c4 10             	add    $0x10,%esp
  801813:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  801816:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  80181a:	75 07                	jne    801823 <sget+0x2c>
  80181c:	b8 00 00 00 00       	mov    $0x0,%eax
  801821:	eb 75                	jmp    801898 <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801823:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80182a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80182d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801830:	01 d0                	add    %edx,%eax
  801832:	48                   	dec    %eax
  801833:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801836:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801839:	ba 00 00 00 00       	mov    $0x0,%edx
  80183e:	f7 75 f0             	divl   -0x10(%ebp)
  801841:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801844:	29 d0                	sub    %edx,%eax
  801846:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  801849:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801850:	e8 18 06 00 00       	call   801e6d <sys_isUHeapPlacementStrategyFIRSTFIT>
  801855:	83 f8 01             	cmp    $0x1,%eax
  801858:	75 39                	jne    801893 <sget+0x9c>

		  va = malloc(newsize) ;
  80185a:	83 ec 0c             	sub    $0xc,%esp
  80185d:	ff 75 e8             	pushl  -0x18(%ebp)
  801860:	e8 78 fd ff ff       	call   8015dd <malloc>
  801865:	83 c4 10             	add    $0x10,%esp
  801868:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  80186b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80186f:	74 22                	je     801893 <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  801871:	83 ec 04             	sub    $0x4,%esp
  801874:	ff 75 e0             	pushl  -0x20(%ebp)
  801877:	ff 75 0c             	pushl  0xc(%ebp)
  80187a:	ff 75 08             	pushl  0x8(%ebp)
  80187d:	e8 b7 03 00 00       	call   801c39 <sys_getSharedObject>
  801882:	83 c4 10             	add    $0x10,%esp
  801885:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  801888:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80188c:	78 05                	js     801893 <sget+0x9c>
					  return va;
  80188e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801891:	eb 05                	jmp    801898 <sget+0xa1>
				  }
			  }
     }
         return NULL;
  801893:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  801898:	c9                   	leave  
  801899:	c3                   	ret    

0080189a <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80189a:	55                   	push   %ebp
  80189b:	89 e5                	mov    %esp,%ebp
  80189d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018a0:	e8 49 fb ff ff       	call   8013ee <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018a5:	83 ec 04             	sub    $0x4,%esp
  8018a8:	68 e4 3a 80 00       	push   $0x803ae4
  8018ad:	68 1e 01 00 00       	push   $0x11e
  8018b2:	68 b3 3a 80 00       	push   $0x803ab3
  8018b7:	e8 f4 ea ff ff       	call   8003b0 <_panic>

008018bc <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
  8018bf:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8018c2:	83 ec 04             	sub    $0x4,%esp
  8018c5:	68 0c 3b 80 00       	push   $0x803b0c
  8018ca:	68 32 01 00 00       	push   $0x132
  8018cf:	68 b3 3a 80 00       	push   $0x803ab3
  8018d4:	e8 d7 ea ff ff       	call   8003b0 <_panic>

008018d9 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8018d9:	55                   	push   %ebp
  8018da:	89 e5                	mov    %esp,%ebp
  8018dc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018df:	83 ec 04             	sub    $0x4,%esp
  8018e2:	68 30 3b 80 00       	push   $0x803b30
  8018e7:	68 3d 01 00 00       	push   $0x13d
  8018ec:	68 b3 3a 80 00       	push   $0x803ab3
  8018f1:	e8 ba ea ff ff       	call   8003b0 <_panic>

008018f6 <shrink>:

}
void shrink(uint32 newSize)
{
  8018f6:	55                   	push   %ebp
  8018f7:	89 e5                	mov    %esp,%ebp
  8018f9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018fc:	83 ec 04             	sub    $0x4,%esp
  8018ff:	68 30 3b 80 00       	push   $0x803b30
  801904:	68 42 01 00 00       	push   $0x142
  801909:	68 b3 3a 80 00       	push   $0x803ab3
  80190e:	e8 9d ea ff ff       	call   8003b0 <_panic>

00801913 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801913:	55                   	push   %ebp
  801914:	89 e5                	mov    %esp,%ebp
  801916:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801919:	83 ec 04             	sub    $0x4,%esp
  80191c:	68 30 3b 80 00       	push   $0x803b30
  801921:	68 47 01 00 00       	push   $0x147
  801926:	68 b3 3a 80 00       	push   $0x803ab3
  80192b:	e8 80 ea ff ff       	call   8003b0 <_panic>

00801930 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801930:	55                   	push   %ebp
  801931:	89 e5                	mov    %esp,%ebp
  801933:	57                   	push   %edi
  801934:	56                   	push   %esi
  801935:	53                   	push   %ebx
  801936:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801939:	8b 45 08             	mov    0x8(%ebp),%eax
  80193c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801942:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801945:	8b 7d 18             	mov    0x18(%ebp),%edi
  801948:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80194b:	cd 30                	int    $0x30
  80194d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801950:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801953:	83 c4 10             	add    $0x10,%esp
  801956:	5b                   	pop    %ebx
  801957:	5e                   	pop    %esi
  801958:	5f                   	pop    %edi
  801959:	5d                   	pop    %ebp
  80195a:	c3                   	ret    

0080195b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
  80195e:	83 ec 04             	sub    $0x4,%esp
  801961:	8b 45 10             	mov    0x10(%ebp),%eax
  801964:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801967:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80196b:	8b 45 08             	mov    0x8(%ebp),%eax
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	52                   	push   %edx
  801973:	ff 75 0c             	pushl  0xc(%ebp)
  801976:	50                   	push   %eax
  801977:	6a 00                	push   $0x0
  801979:	e8 b2 ff ff ff       	call   801930 <syscall>
  80197e:	83 c4 18             	add    $0x18,%esp
}
  801981:	90                   	nop
  801982:	c9                   	leave  
  801983:	c3                   	ret    

00801984 <sys_cgetc>:

int
sys_cgetc(void)
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	6a 01                	push   $0x1
  801993:	e8 98 ff ff ff       	call   801930 <syscall>
  801998:	83 c4 18             	add    $0x18,%esp
}
  80199b:	c9                   	leave  
  80199c:	c3                   	ret    

0080199d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80199d:	55                   	push   %ebp
  80199e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	52                   	push   %edx
  8019ad:	50                   	push   %eax
  8019ae:	6a 05                	push   $0x5
  8019b0:	e8 7b ff ff ff       	call   801930 <syscall>
  8019b5:	83 c4 18             	add    $0x18,%esp
}
  8019b8:	c9                   	leave  
  8019b9:	c3                   	ret    

008019ba <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
  8019bd:	56                   	push   %esi
  8019be:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019bf:	8b 75 18             	mov    0x18(%ebp),%esi
  8019c2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019c5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ce:	56                   	push   %esi
  8019cf:	53                   	push   %ebx
  8019d0:	51                   	push   %ecx
  8019d1:	52                   	push   %edx
  8019d2:	50                   	push   %eax
  8019d3:	6a 06                	push   $0x6
  8019d5:	e8 56 ff ff ff       	call   801930 <syscall>
  8019da:	83 c4 18             	add    $0x18,%esp
}
  8019dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019e0:	5b                   	pop    %ebx
  8019e1:	5e                   	pop    %esi
  8019e2:	5d                   	pop    %ebp
  8019e3:	c3                   	ret    

008019e4 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	52                   	push   %edx
  8019f4:	50                   	push   %eax
  8019f5:	6a 07                	push   $0x7
  8019f7:	e8 34 ff ff ff       	call   801930 <syscall>
  8019fc:	83 c4 18             	add    $0x18,%esp
}
  8019ff:	c9                   	leave  
  801a00:	c3                   	ret    

00801a01 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	ff 75 0c             	pushl  0xc(%ebp)
  801a0d:	ff 75 08             	pushl  0x8(%ebp)
  801a10:	6a 08                	push   $0x8
  801a12:	e8 19 ff ff ff       	call   801930 <syscall>
  801a17:	83 c4 18             	add    $0x18,%esp
}
  801a1a:	c9                   	leave  
  801a1b:	c3                   	ret    

00801a1c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a1c:	55                   	push   %ebp
  801a1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	6a 09                	push   $0x9
  801a2b:	e8 00 ff ff ff       	call   801930 <syscall>
  801a30:	83 c4 18             	add    $0x18,%esp
}
  801a33:	c9                   	leave  
  801a34:	c3                   	ret    

00801a35 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a35:	55                   	push   %ebp
  801a36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	6a 0a                	push   $0xa
  801a44:	e8 e7 fe ff ff       	call   801930 <syscall>
  801a49:	83 c4 18             	add    $0x18,%esp
}
  801a4c:	c9                   	leave  
  801a4d:	c3                   	ret    

00801a4e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a4e:	55                   	push   %ebp
  801a4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 0b                	push   $0xb
  801a5d:	e8 ce fe ff ff       	call   801930 <syscall>
  801a62:	83 c4 18             	add    $0x18,%esp
}
  801a65:	c9                   	leave  
  801a66:	c3                   	ret    

00801a67 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a67:	55                   	push   %ebp
  801a68:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	ff 75 0c             	pushl  0xc(%ebp)
  801a73:	ff 75 08             	pushl  0x8(%ebp)
  801a76:	6a 0f                	push   $0xf
  801a78:	e8 b3 fe ff ff       	call   801930 <syscall>
  801a7d:	83 c4 18             	add    $0x18,%esp
	return;
  801a80:	90                   	nop
}
  801a81:	c9                   	leave  
  801a82:	c3                   	ret    

00801a83 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	ff 75 0c             	pushl  0xc(%ebp)
  801a8f:	ff 75 08             	pushl  0x8(%ebp)
  801a92:	6a 10                	push   $0x10
  801a94:	e8 97 fe ff ff       	call   801930 <syscall>
  801a99:	83 c4 18             	add    $0x18,%esp
	return ;
  801a9c:	90                   	nop
}
  801a9d:	c9                   	leave  
  801a9e:	c3                   	ret    

00801a9f <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a9f:	55                   	push   %ebp
  801aa0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	ff 75 10             	pushl  0x10(%ebp)
  801aa9:	ff 75 0c             	pushl  0xc(%ebp)
  801aac:	ff 75 08             	pushl  0x8(%ebp)
  801aaf:	6a 11                	push   $0x11
  801ab1:	e8 7a fe ff ff       	call   801930 <syscall>
  801ab6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ab9:	90                   	nop
}
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

00801abc <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 0c                	push   $0xc
  801acb:	e8 60 fe ff ff       	call   801930 <syscall>
  801ad0:	83 c4 18             	add    $0x18,%esp
}
  801ad3:	c9                   	leave  
  801ad4:	c3                   	ret    

00801ad5 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	ff 75 08             	pushl  0x8(%ebp)
  801ae3:	6a 0d                	push   $0xd
  801ae5:	e8 46 fe ff ff       	call   801930 <syscall>
  801aea:	83 c4 18             	add    $0x18,%esp
}
  801aed:	c9                   	leave  
  801aee:	c3                   	ret    

00801aef <sys_scarce_memory>:

void sys_scarce_memory()
{
  801aef:	55                   	push   %ebp
  801af0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 0e                	push   $0xe
  801afe:	e8 2d fe ff ff       	call   801930 <syscall>
  801b03:	83 c4 18             	add    $0x18,%esp
}
  801b06:	90                   	nop
  801b07:	c9                   	leave  
  801b08:	c3                   	ret    

00801b09 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 13                	push   $0x13
  801b18:	e8 13 fe ff ff       	call   801930 <syscall>
  801b1d:	83 c4 18             	add    $0x18,%esp
}
  801b20:	90                   	nop
  801b21:	c9                   	leave  
  801b22:	c3                   	ret    

00801b23 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b23:	55                   	push   %ebp
  801b24:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 14                	push   $0x14
  801b32:	e8 f9 fd ff ff       	call   801930 <syscall>
  801b37:	83 c4 18             	add    $0x18,%esp
}
  801b3a:	90                   	nop
  801b3b:	c9                   	leave  
  801b3c:	c3                   	ret    

00801b3d <sys_cputc>:


void
sys_cputc(const char c)
{
  801b3d:	55                   	push   %ebp
  801b3e:	89 e5                	mov    %esp,%ebp
  801b40:	83 ec 04             	sub    $0x4,%esp
  801b43:	8b 45 08             	mov    0x8(%ebp),%eax
  801b46:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b49:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	50                   	push   %eax
  801b56:	6a 15                	push   $0x15
  801b58:	e8 d3 fd ff ff       	call   801930 <syscall>
  801b5d:	83 c4 18             	add    $0x18,%esp
}
  801b60:	90                   	nop
  801b61:	c9                   	leave  
  801b62:	c3                   	ret    

00801b63 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b63:	55                   	push   %ebp
  801b64:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 16                	push   $0x16
  801b72:	e8 b9 fd ff ff       	call   801930 <syscall>
  801b77:	83 c4 18             	add    $0x18,%esp
}
  801b7a:	90                   	nop
  801b7b:	c9                   	leave  
  801b7c:	c3                   	ret    

00801b7d <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b7d:	55                   	push   %ebp
  801b7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b80:	8b 45 08             	mov    0x8(%ebp),%eax
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	ff 75 0c             	pushl  0xc(%ebp)
  801b8c:	50                   	push   %eax
  801b8d:	6a 17                	push   $0x17
  801b8f:	e8 9c fd ff ff       	call   801930 <syscall>
  801b94:	83 c4 18             	add    $0x18,%esp
}
  801b97:	c9                   	leave  
  801b98:	c3                   	ret    

00801b99 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b99:	55                   	push   %ebp
  801b9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	52                   	push   %edx
  801ba9:	50                   	push   %eax
  801baa:	6a 1a                	push   $0x1a
  801bac:	e8 7f fd ff ff       	call   801930 <syscall>
  801bb1:	83 c4 18             	add    $0x18,%esp
}
  801bb4:	c9                   	leave  
  801bb5:	c3                   	ret    

00801bb6 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bb6:	55                   	push   %ebp
  801bb7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	52                   	push   %edx
  801bc6:	50                   	push   %eax
  801bc7:	6a 18                	push   $0x18
  801bc9:	e8 62 fd ff ff       	call   801930 <syscall>
  801bce:	83 c4 18             	add    $0x18,%esp
}
  801bd1:	90                   	nop
  801bd2:	c9                   	leave  
  801bd3:	c3                   	ret    

00801bd4 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bd4:	55                   	push   %ebp
  801bd5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bd7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bda:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	52                   	push   %edx
  801be4:	50                   	push   %eax
  801be5:	6a 19                	push   $0x19
  801be7:	e8 44 fd ff ff       	call   801930 <syscall>
  801bec:	83 c4 18             	add    $0x18,%esp
}
  801bef:	90                   	nop
  801bf0:	c9                   	leave  
  801bf1:	c3                   	ret    

00801bf2 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801bf2:	55                   	push   %ebp
  801bf3:	89 e5                	mov    %esp,%ebp
  801bf5:	83 ec 04             	sub    $0x4,%esp
  801bf8:	8b 45 10             	mov    0x10(%ebp),%eax
  801bfb:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801bfe:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c01:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c05:	8b 45 08             	mov    0x8(%ebp),%eax
  801c08:	6a 00                	push   $0x0
  801c0a:	51                   	push   %ecx
  801c0b:	52                   	push   %edx
  801c0c:	ff 75 0c             	pushl  0xc(%ebp)
  801c0f:	50                   	push   %eax
  801c10:	6a 1b                	push   $0x1b
  801c12:	e8 19 fd ff ff       	call   801930 <syscall>
  801c17:	83 c4 18             	add    $0x18,%esp
}
  801c1a:	c9                   	leave  
  801c1b:	c3                   	ret    

00801c1c <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c1c:	55                   	push   %ebp
  801c1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c22:	8b 45 08             	mov    0x8(%ebp),%eax
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	52                   	push   %edx
  801c2c:	50                   	push   %eax
  801c2d:	6a 1c                	push   $0x1c
  801c2f:	e8 fc fc ff ff       	call   801930 <syscall>
  801c34:	83 c4 18             	add    $0x18,%esp
}
  801c37:	c9                   	leave  
  801c38:	c3                   	ret    

00801c39 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c39:	55                   	push   %ebp
  801c3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c3c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c42:	8b 45 08             	mov    0x8(%ebp),%eax
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	51                   	push   %ecx
  801c4a:	52                   	push   %edx
  801c4b:	50                   	push   %eax
  801c4c:	6a 1d                	push   $0x1d
  801c4e:	e8 dd fc ff ff       	call   801930 <syscall>
  801c53:	83 c4 18             	add    $0x18,%esp
}
  801c56:	c9                   	leave  
  801c57:	c3                   	ret    

00801c58 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c58:	55                   	push   %ebp
  801c59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	52                   	push   %edx
  801c68:	50                   	push   %eax
  801c69:	6a 1e                	push   $0x1e
  801c6b:	e8 c0 fc ff ff       	call   801930 <syscall>
  801c70:	83 c4 18             	add    $0x18,%esp
}
  801c73:	c9                   	leave  
  801c74:	c3                   	ret    

00801c75 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c75:	55                   	push   %ebp
  801c76:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 1f                	push   $0x1f
  801c84:	e8 a7 fc ff ff       	call   801930 <syscall>
  801c89:	83 c4 18             	add    $0x18,%esp
}
  801c8c:	c9                   	leave  
  801c8d:	c3                   	ret    

00801c8e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c8e:	55                   	push   %ebp
  801c8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c91:	8b 45 08             	mov    0x8(%ebp),%eax
  801c94:	6a 00                	push   $0x0
  801c96:	ff 75 14             	pushl  0x14(%ebp)
  801c99:	ff 75 10             	pushl  0x10(%ebp)
  801c9c:	ff 75 0c             	pushl  0xc(%ebp)
  801c9f:	50                   	push   %eax
  801ca0:	6a 20                	push   $0x20
  801ca2:	e8 89 fc ff ff       	call   801930 <syscall>
  801ca7:	83 c4 18             	add    $0x18,%esp
}
  801caa:	c9                   	leave  
  801cab:	c3                   	ret    

00801cac <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801cac:	55                   	push   %ebp
  801cad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801caf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	50                   	push   %eax
  801cbb:	6a 21                	push   $0x21
  801cbd:	e8 6e fc ff ff       	call   801930 <syscall>
  801cc2:	83 c4 18             	add    $0x18,%esp
}
  801cc5:	90                   	nop
  801cc6:	c9                   	leave  
  801cc7:	c3                   	ret    

00801cc8 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801cc8:	55                   	push   %ebp
  801cc9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	50                   	push   %eax
  801cd7:	6a 22                	push   $0x22
  801cd9:	e8 52 fc ff ff       	call   801930 <syscall>
  801cde:	83 c4 18             	add    $0x18,%esp
}
  801ce1:	c9                   	leave  
  801ce2:	c3                   	ret    

00801ce3 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ce3:	55                   	push   %ebp
  801ce4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 02                	push   $0x2
  801cf2:	e8 39 fc ff ff       	call   801930 <syscall>
  801cf7:	83 c4 18             	add    $0x18,%esp
}
  801cfa:	c9                   	leave  
  801cfb:	c3                   	ret    

00801cfc <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 03                	push   $0x3
  801d0b:	e8 20 fc ff ff       	call   801930 <syscall>
  801d10:	83 c4 18             	add    $0x18,%esp
}
  801d13:	c9                   	leave  
  801d14:	c3                   	ret    

00801d15 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 04                	push   $0x4
  801d24:	e8 07 fc ff ff       	call   801930 <syscall>
  801d29:	83 c4 18             	add    $0x18,%esp
}
  801d2c:	c9                   	leave  
  801d2d:	c3                   	ret    

00801d2e <sys_exit_env>:


void sys_exit_env(void)
{
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 23                	push   $0x23
  801d3d:	e8 ee fb ff ff       	call   801930 <syscall>
  801d42:	83 c4 18             	add    $0x18,%esp
}
  801d45:	90                   	nop
  801d46:	c9                   	leave  
  801d47:	c3                   	ret    

00801d48 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d48:	55                   	push   %ebp
  801d49:	89 e5                	mov    %esp,%ebp
  801d4b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d4e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d51:	8d 50 04             	lea    0x4(%eax),%edx
  801d54:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	52                   	push   %edx
  801d5e:	50                   	push   %eax
  801d5f:	6a 24                	push   $0x24
  801d61:	e8 ca fb ff ff       	call   801930 <syscall>
  801d66:	83 c4 18             	add    $0x18,%esp
	return result;
  801d69:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d6c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d6f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d72:	89 01                	mov    %eax,(%ecx)
  801d74:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d77:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7a:	c9                   	leave  
  801d7b:	c2 04 00             	ret    $0x4

00801d7e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d7e:	55                   	push   %ebp
  801d7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	ff 75 10             	pushl  0x10(%ebp)
  801d88:	ff 75 0c             	pushl  0xc(%ebp)
  801d8b:	ff 75 08             	pushl  0x8(%ebp)
  801d8e:	6a 12                	push   $0x12
  801d90:	e8 9b fb ff ff       	call   801930 <syscall>
  801d95:	83 c4 18             	add    $0x18,%esp
	return ;
  801d98:	90                   	nop
}
  801d99:	c9                   	leave  
  801d9a:	c3                   	ret    

00801d9b <sys_rcr2>:
uint32 sys_rcr2()
{
  801d9b:	55                   	push   %ebp
  801d9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 25                	push   $0x25
  801daa:	e8 81 fb ff ff       	call   801930 <syscall>
  801daf:	83 c4 18             	add    $0x18,%esp
}
  801db2:	c9                   	leave  
  801db3:	c3                   	ret    

00801db4 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801db4:	55                   	push   %ebp
  801db5:	89 e5                	mov    %esp,%ebp
  801db7:	83 ec 04             	sub    $0x4,%esp
  801dba:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801dc0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	50                   	push   %eax
  801dcd:	6a 26                	push   $0x26
  801dcf:	e8 5c fb ff ff       	call   801930 <syscall>
  801dd4:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd7:	90                   	nop
}
  801dd8:	c9                   	leave  
  801dd9:	c3                   	ret    

00801dda <rsttst>:
void rsttst()
{
  801dda:	55                   	push   %ebp
  801ddb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	6a 28                	push   $0x28
  801de9:	e8 42 fb ff ff       	call   801930 <syscall>
  801dee:	83 c4 18             	add    $0x18,%esp
	return ;
  801df1:	90                   	nop
}
  801df2:	c9                   	leave  
  801df3:	c3                   	ret    

00801df4 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801df4:	55                   	push   %ebp
  801df5:	89 e5                	mov    %esp,%ebp
  801df7:	83 ec 04             	sub    $0x4,%esp
  801dfa:	8b 45 14             	mov    0x14(%ebp),%eax
  801dfd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e00:	8b 55 18             	mov    0x18(%ebp),%edx
  801e03:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e07:	52                   	push   %edx
  801e08:	50                   	push   %eax
  801e09:	ff 75 10             	pushl  0x10(%ebp)
  801e0c:	ff 75 0c             	pushl  0xc(%ebp)
  801e0f:	ff 75 08             	pushl  0x8(%ebp)
  801e12:	6a 27                	push   $0x27
  801e14:	e8 17 fb ff ff       	call   801930 <syscall>
  801e19:	83 c4 18             	add    $0x18,%esp
	return ;
  801e1c:	90                   	nop
}
  801e1d:	c9                   	leave  
  801e1e:	c3                   	ret    

00801e1f <chktst>:
void chktst(uint32 n)
{
  801e1f:	55                   	push   %ebp
  801e20:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	ff 75 08             	pushl  0x8(%ebp)
  801e2d:	6a 29                	push   $0x29
  801e2f:	e8 fc fa ff ff       	call   801930 <syscall>
  801e34:	83 c4 18             	add    $0x18,%esp
	return ;
  801e37:	90                   	nop
}
  801e38:	c9                   	leave  
  801e39:	c3                   	ret    

00801e3a <inctst>:

void inctst()
{
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	6a 00                	push   $0x0
  801e47:	6a 2a                	push   $0x2a
  801e49:	e8 e2 fa ff ff       	call   801930 <syscall>
  801e4e:	83 c4 18             	add    $0x18,%esp
	return ;
  801e51:	90                   	nop
}
  801e52:	c9                   	leave  
  801e53:	c3                   	ret    

00801e54 <gettst>:
uint32 gettst()
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e57:	6a 00                	push   $0x0
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 2b                	push   $0x2b
  801e63:	e8 c8 fa ff ff       	call   801930 <syscall>
  801e68:	83 c4 18             	add    $0x18,%esp
}
  801e6b:	c9                   	leave  
  801e6c:	c3                   	ret    

00801e6d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e6d:	55                   	push   %ebp
  801e6e:	89 e5                	mov    %esp,%ebp
  801e70:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 2c                	push   $0x2c
  801e7f:	e8 ac fa ff ff       	call   801930 <syscall>
  801e84:	83 c4 18             	add    $0x18,%esp
  801e87:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e8a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e8e:	75 07                	jne    801e97 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e90:	b8 01 00 00 00       	mov    $0x1,%eax
  801e95:	eb 05                	jmp    801e9c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e9c:	c9                   	leave  
  801e9d:	c3                   	ret    

00801e9e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e9e:	55                   	push   %ebp
  801e9f:	89 e5                	mov    %esp,%ebp
  801ea1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ea4:	6a 00                	push   $0x0
  801ea6:	6a 00                	push   $0x0
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	6a 2c                	push   $0x2c
  801eb0:	e8 7b fa ff ff       	call   801930 <syscall>
  801eb5:	83 c4 18             	add    $0x18,%esp
  801eb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ebb:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ebf:	75 07                	jne    801ec8 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ec1:	b8 01 00 00 00       	mov    $0x1,%eax
  801ec6:	eb 05                	jmp    801ecd <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ec8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ecd:	c9                   	leave  
  801ece:	c3                   	ret    

00801ecf <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ecf:	55                   	push   %ebp
  801ed0:	89 e5                	mov    %esp,%ebp
  801ed2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ed5:	6a 00                	push   $0x0
  801ed7:	6a 00                	push   $0x0
  801ed9:	6a 00                	push   $0x0
  801edb:	6a 00                	push   $0x0
  801edd:	6a 00                	push   $0x0
  801edf:	6a 2c                	push   $0x2c
  801ee1:	e8 4a fa ff ff       	call   801930 <syscall>
  801ee6:	83 c4 18             	add    $0x18,%esp
  801ee9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801eec:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ef0:	75 07                	jne    801ef9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ef2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ef7:	eb 05                	jmp    801efe <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ef9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801efe:	c9                   	leave  
  801eff:	c3                   	ret    

00801f00 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
  801f03:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f06:	6a 00                	push   $0x0
  801f08:	6a 00                	push   $0x0
  801f0a:	6a 00                	push   $0x0
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 00                	push   $0x0
  801f10:	6a 2c                	push   $0x2c
  801f12:	e8 19 fa ff ff       	call   801930 <syscall>
  801f17:	83 c4 18             	add    $0x18,%esp
  801f1a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f1d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f21:	75 07                	jne    801f2a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f23:	b8 01 00 00 00       	mov    $0x1,%eax
  801f28:	eb 05                	jmp    801f2f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f2f:	c9                   	leave  
  801f30:	c3                   	ret    

00801f31 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f31:	55                   	push   %ebp
  801f32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	ff 75 08             	pushl  0x8(%ebp)
  801f3f:	6a 2d                	push   $0x2d
  801f41:	e8 ea f9 ff ff       	call   801930 <syscall>
  801f46:	83 c4 18             	add    $0x18,%esp
	return ;
  801f49:	90                   	nop
}
  801f4a:	c9                   	leave  
  801f4b:	c3                   	ret    

00801f4c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f4c:	55                   	push   %ebp
  801f4d:	89 e5                	mov    %esp,%ebp
  801f4f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f50:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f53:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f56:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f59:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5c:	6a 00                	push   $0x0
  801f5e:	53                   	push   %ebx
  801f5f:	51                   	push   %ecx
  801f60:	52                   	push   %edx
  801f61:	50                   	push   %eax
  801f62:	6a 2e                	push   $0x2e
  801f64:	e8 c7 f9 ff ff       	call   801930 <syscall>
  801f69:	83 c4 18             	add    $0x18,%esp
}
  801f6c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f6f:	c9                   	leave  
  801f70:	c3                   	ret    

00801f71 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f71:	55                   	push   %ebp
  801f72:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f74:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f77:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7a:	6a 00                	push   $0x0
  801f7c:	6a 00                	push   $0x0
  801f7e:	6a 00                	push   $0x0
  801f80:	52                   	push   %edx
  801f81:	50                   	push   %eax
  801f82:	6a 2f                	push   $0x2f
  801f84:	e8 a7 f9 ff ff       	call   801930 <syscall>
  801f89:	83 c4 18             	add    $0x18,%esp
}
  801f8c:	c9                   	leave  
  801f8d:	c3                   	ret    

00801f8e <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f8e:	55                   	push   %ebp
  801f8f:	89 e5                	mov    %esp,%ebp
  801f91:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f94:	83 ec 0c             	sub    $0xc,%esp
  801f97:	68 40 3b 80 00       	push   $0x803b40
  801f9c:	e8 c3 e6 ff ff       	call   800664 <cprintf>
  801fa1:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801fa4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801fab:	83 ec 0c             	sub    $0xc,%esp
  801fae:	68 6c 3b 80 00       	push   $0x803b6c
  801fb3:	e8 ac e6 ff ff       	call   800664 <cprintf>
  801fb8:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801fbb:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fbf:	a1 38 41 80 00       	mov    0x804138,%eax
  801fc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fc7:	eb 56                	jmp    80201f <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fc9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fcd:	74 1c                	je     801feb <print_mem_block_lists+0x5d>
  801fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd2:	8b 50 08             	mov    0x8(%eax),%edx
  801fd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fd8:	8b 48 08             	mov    0x8(%eax),%ecx
  801fdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fde:	8b 40 0c             	mov    0xc(%eax),%eax
  801fe1:	01 c8                	add    %ecx,%eax
  801fe3:	39 c2                	cmp    %eax,%edx
  801fe5:	73 04                	jae    801feb <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801fe7:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fee:	8b 50 08             	mov    0x8(%eax),%edx
  801ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff4:	8b 40 0c             	mov    0xc(%eax),%eax
  801ff7:	01 c2                	add    %eax,%edx
  801ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffc:	8b 40 08             	mov    0x8(%eax),%eax
  801fff:	83 ec 04             	sub    $0x4,%esp
  802002:	52                   	push   %edx
  802003:	50                   	push   %eax
  802004:	68 81 3b 80 00       	push   $0x803b81
  802009:	e8 56 e6 ff ff       	call   800664 <cprintf>
  80200e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802011:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802014:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802017:	a1 40 41 80 00       	mov    0x804140,%eax
  80201c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80201f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802023:	74 07                	je     80202c <print_mem_block_lists+0x9e>
  802025:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802028:	8b 00                	mov    (%eax),%eax
  80202a:	eb 05                	jmp    802031 <print_mem_block_lists+0xa3>
  80202c:	b8 00 00 00 00       	mov    $0x0,%eax
  802031:	a3 40 41 80 00       	mov    %eax,0x804140
  802036:	a1 40 41 80 00       	mov    0x804140,%eax
  80203b:	85 c0                	test   %eax,%eax
  80203d:	75 8a                	jne    801fc9 <print_mem_block_lists+0x3b>
  80203f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802043:	75 84                	jne    801fc9 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802045:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802049:	75 10                	jne    80205b <print_mem_block_lists+0xcd>
  80204b:	83 ec 0c             	sub    $0xc,%esp
  80204e:	68 90 3b 80 00       	push   $0x803b90
  802053:	e8 0c e6 ff ff       	call   800664 <cprintf>
  802058:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80205b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802062:	83 ec 0c             	sub    $0xc,%esp
  802065:	68 b4 3b 80 00       	push   $0x803bb4
  80206a:	e8 f5 e5 ff ff       	call   800664 <cprintf>
  80206f:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802072:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802076:	a1 40 40 80 00       	mov    0x804040,%eax
  80207b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80207e:	eb 56                	jmp    8020d6 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802080:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802084:	74 1c                	je     8020a2 <print_mem_block_lists+0x114>
  802086:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802089:	8b 50 08             	mov    0x8(%eax),%edx
  80208c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80208f:	8b 48 08             	mov    0x8(%eax),%ecx
  802092:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802095:	8b 40 0c             	mov    0xc(%eax),%eax
  802098:	01 c8                	add    %ecx,%eax
  80209a:	39 c2                	cmp    %eax,%edx
  80209c:	73 04                	jae    8020a2 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80209e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a5:	8b 50 08             	mov    0x8(%eax),%edx
  8020a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8020ae:	01 c2                	add    %eax,%edx
  8020b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b3:	8b 40 08             	mov    0x8(%eax),%eax
  8020b6:	83 ec 04             	sub    $0x4,%esp
  8020b9:	52                   	push   %edx
  8020ba:	50                   	push   %eax
  8020bb:	68 81 3b 80 00       	push   $0x803b81
  8020c0:	e8 9f e5 ff ff       	call   800664 <cprintf>
  8020c5:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020ce:	a1 48 40 80 00       	mov    0x804048,%eax
  8020d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020da:	74 07                	je     8020e3 <print_mem_block_lists+0x155>
  8020dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020df:	8b 00                	mov    (%eax),%eax
  8020e1:	eb 05                	jmp    8020e8 <print_mem_block_lists+0x15a>
  8020e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e8:	a3 48 40 80 00       	mov    %eax,0x804048
  8020ed:	a1 48 40 80 00       	mov    0x804048,%eax
  8020f2:	85 c0                	test   %eax,%eax
  8020f4:	75 8a                	jne    802080 <print_mem_block_lists+0xf2>
  8020f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020fa:	75 84                	jne    802080 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8020fc:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802100:	75 10                	jne    802112 <print_mem_block_lists+0x184>
  802102:	83 ec 0c             	sub    $0xc,%esp
  802105:	68 cc 3b 80 00       	push   $0x803bcc
  80210a:	e8 55 e5 ff ff       	call   800664 <cprintf>
  80210f:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802112:	83 ec 0c             	sub    $0xc,%esp
  802115:	68 40 3b 80 00       	push   $0x803b40
  80211a:	e8 45 e5 ff ff       	call   800664 <cprintf>
  80211f:	83 c4 10             	add    $0x10,%esp

}
  802122:	90                   	nop
  802123:	c9                   	leave  
  802124:	c3                   	ret    

00802125 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802125:	55                   	push   %ebp
  802126:	89 e5                	mov    %esp,%ebp
  802128:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  80212b:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802132:	00 00 00 
  802135:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  80213c:	00 00 00 
  80213f:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802146:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802149:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802150:	e9 9e 00 00 00       	jmp    8021f3 <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802155:	a1 50 40 80 00       	mov    0x804050,%eax
  80215a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80215d:	c1 e2 04             	shl    $0x4,%edx
  802160:	01 d0                	add    %edx,%eax
  802162:	85 c0                	test   %eax,%eax
  802164:	75 14                	jne    80217a <initialize_MemBlocksList+0x55>
  802166:	83 ec 04             	sub    $0x4,%esp
  802169:	68 f4 3b 80 00       	push   $0x803bf4
  80216e:	6a 47                	push   $0x47
  802170:	68 17 3c 80 00       	push   $0x803c17
  802175:	e8 36 e2 ff ff       	call   8003b0 <_panic>
  80217a:	a1 50 40 80 00       	mov    0x804050,%eax
  80217f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802182:	c1 e2 04             	shl    $0x4,%edx
  802185:	01 d0                	add    %edx,%eax
  802187:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80218d:	89 10                	mov    %edx,(%eax)
  80218f:	8b 00                	mov    (%eax),%eax
  802191:	85 c0                	test   %eax,%eax
  802193:	74 18                	je     8021ad <initialize_MemBlocksList+0x88>
  802195:	a1 48 41 80 00       	mov    0x804148,%eax
  80219a:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8021a0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8021a3:	c1 e1 04             	shl    $0x4,%ecx
  8021a6:	01 ca                	add    %ecx,%edx
  8021a8:	89 50 04             	mov    %edx,0x4(%eax)
  8021ab:	eb 12                	jmp    8021bf <initialize_MemBlocksList+0x9a>
  8021ad:	a1 50 40 80 00       	mov    0x804050,%eax
  8021b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021b5:	c1 e2 04             	shl    $0x4,%edx
  8021b8:	01 d0                	add    %edx,%eax
  8021ba:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8021bf:	a1 50 40 80 00       	mov    0x804050,%eax
  8021c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021c7:	c1 e2 04             	shl    $0x4,%edx
  8021ca:	01 d0                	add    %edx,%eax
  8021cc:	a3 48 41 80 00       	mov    %eax,0x804148
  8021d1:	a1 50 40 80 00       	mov    0x804050,%eax
  8021d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021d9:	c1 e2 04             	shl    $0x4,%edx
  8021dc:	01 d0                	add    %edx,%eax
  8021de:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021e5:	a1 54 41 80 00       	mov    0x804154,%eax
  8021ea:	40                   	inc    %eax
  8021eb:	a3 54 41 80 00       	mov    %eax,0x804154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  8021f0:	ff 45 f4             	incl   -0xc(%ebp)
  8021f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021f9:	0f 82 56 ff ff ff    	jb     802155 <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  8021ff:	90                   	nop
  802200:	c9                   	leave  
  802201:	c3                   	ret    

00802202 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802202:	55                   	push   %ebp
  802203:	89 e5                	mov    %esp,%ebp
  802205:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802208:	8b 45 08             	mov    0x8(%ebp),%eax
  80220b:	8b 00                	mov    (%eax),%eax
  80220d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802210:	eb 19                	jmp    80222b <find_block+0x29>
	{
		if(element->sva == va){
  802212:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802215:	8b 40 08             	mov    0x8(%eax),%eax
  802218:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80221b:	75 05                	jne    802222 <find_block+0x20>
			 		return element;
  80221d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802220:	eb 36                	jmp    802258 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802222:	8b 45 08             	mov    0x8(%ebp),%eax
  802225:	8b 40 08             	mov    0x8(%eax),%eax
  802228:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80222b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80222f:	74 07                	je     802238 <find_block+0x36>
  802231:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802234:	8b 00                	mov    (%eax),%eax
  802236:	eb 05                	jmp    80223d <find_block+0x3b>
  802238:	b8 00 00 00 00       	mov    $0x0,%eax
  80223d:	8b 55 08             	mov    0x8(%ebp),%edx
  802240:	89 42 08             	mov    %eax,0x8(%edx)
  802243:	8b 45 08             	mov    0x8(%ebp),%eax
  802246:	8b 40 08             	mov    0x8(%eax),%eax
  802249:	85 c0                	test   %eax,%eax
  80224b:	75 c5                	jne    802212 <find_block+0x10>
  80224d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802251:	75 bf                	jne    802212 <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  802253:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802258:	c9                   	leave  
  802259:	c3                   	ret    

0080225a <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80225a:	55                   	push   %ebp
  80225b:	89 e5                	mov    %esp,%ebp
  80225d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  802260:	a1 44 40 80 00       	mov    0x804044,%eax
  802265:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  802268:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80226d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  802270:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802274:	74 0a                	je     802280 <insert_sorted_allocList+0x26>
  802276:	8b 45 08             	mov    0x8(%ebp),%eax
  802279:	8b 40 08             	mov    0x8(%eax),%eax
  80227c:	85 c0                	test   %eax,%eax
  80227e:	75 65                	jne    8022e5 <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802280:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802284:	75 14                	jne    80229a <insert_sorted_allocList+0x40>
  802286:	83 ec 04             	sub    $0x4,%esp
  802289:	68 f4 3b 80 00       	push   $0x803bf4
  80228e:	6a 6e                	push   $0x6e
  802290:	68 17 3c 80 00       	push   $0x803c17
  802295:	e8 16 e1 ff ff       	call   8003b0 <_panic>
  80229a:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8022a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a3:	89 10                	mov    %edx,(%eax)
  8022a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a8:	8b 00                	mov    (%eax),%eax
  8022aa:	85 c0                	test   %eax,%eax
  8022ac:	74 0d                	je     8022bb <insert_sorted_allocList+0x61>
  8022ae:	a1 40 40 80 00       	mov    0x804040,%eax
  8022b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8022b6:	89 50 04             	mov    %edx,0x4(%eax)
  8022b9:	eb 08                	jmp    8022c3 <insert_sorted_allocList+0x69>
  8022bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022be:	a3 44 40 80 00       	mov    %eax,0x804044
  8022c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c6:	a3 40 40 80 00       	mov    %eax,0x804040
  8022cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022d5:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022da:	40                   	inc    %eax
  8022db:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8022e0:	e9 cf 01 00 00       	jmp    8024b4 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  8022e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e8:	8b 50 08             	mov    0x8(%eax),%edx
  8022eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ee:	8b 40 08             	mov    0x8(%eax),%eax
  8022f1:	39 c2                	cmp    %eax,%edx
  8022f3:	73 65                	jae    80235a <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8022f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022f9:	75 14                	jne    80230f <insert_sorted_allocList+0xb5>
  8022fb:	83 ec 04             	sub    $0x4,%esp
  8022fe:	68 30 3c 80 00       	push   $0x803c30
  802303:	6a 72                	push   $0x72
  802305:	68 17 3c 80 00       	push   $0x803c17
  80230a:	e8 a1 e0 ff ff       	call   8003b0 <_panic>
  80230f:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802315:	8b 45 08             	mov    0x8(%ebp),%eax
  802318:	89 50 04             	mov    %edx,0x4(%eax)
  80231b:	8b 45 08             	mov    0x8(%ebp),%eax
  80231e:	8b 40 04             	mov    0x4(%eax),%eax
  802321:	85 c0                	test   %eax,%eax
  802323:	74 0c                	je     802331 <insert_sorted_allocList+0xd7>
  802325:	a1 44 40 80 00       	mov    0x804044,%eax
  80232a:	8b 55 08             	mov    0x8(%ebp),%edx
  80232d:	89 10                	mov    %edx,(%eax)
  80232f:	eb 08                	jmp    802339 <insert_sorted_allocList+0xdf>
  802331:	8b 45 08             	mov    0x8(%ebp),%eax
  802334:	a3 40 40 80 00       	mov    %eax,0x804040
  802339:	8b 45 08             	mov    0x8(%ebp),%eax
  80233c:	a3 44 40 80 00       	mov    %eax,0x804044
  802341:	8b 45 08             	mov    0x8(%ebp),%eax
  802344:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80234a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80234f:	40                   	inc    %eax
  802350:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  802355:	e9 5a 01 00 00       	jmp    8024b4 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  80235a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80235d:	8b 50 08             	mov    0x8(%eax),%edx
  802360:	8b 45 08             	mov    0x8(%ebp),%eax
  802363:	8b 40 08             	mov    0x8(%eax),%eax
  802366:	39 c2                	cmp    %eax,%edx
  802368:	75 70                	jne    8023da <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  80236a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80236e:	74 06                	je     802376 <insert_sorted_allocList+0x11c>
  802370:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802374:	75 14                	jne    80238a <insert_sorted_allocList+0x130>
  802376:	83 ec 04             	sub    $0x4,%esp
  802379:	68 54 3c 80 00       	push   $0x803c54
  80237e:	6a 75                	push   $0x75
  802380:	68 17 3c 80 00       	push   $0x803c17
  802385:	e8 26 e0 ff ff       	call   8003b0 <_panic>
  80238a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80238d:	8b 10                	mov    (%eax),%edx
  80238f:	8b 45 08             	mov    0x8(%ebp),%eax
  802392:	89 10                	mov    %edx,(%eax)
  802394:	8b 45 08             	mov    0x8(%ebp),%eax
  802397:	8b 00                	mov    (%eax),%eax
  802399:	85 c0                	test   %eax,%eax
  80239b:	74 0b                	je     8023a8 <insert_sorted_allocList+0x14e>
  80239d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a0:	8b 00                	mov    (%eax),%eax
  8023a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8023a5:	89 50 04             	mov    %edx,0x4(%eax)
  8023a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8023ae:	89 10                	mov    %edx,(%eax)
  8023b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023b6:	89 50 04             	mov    %edx,0x4(%eax)
  8023b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bc:	8b 00                	mov    (%eax),%eax
  8023be:	85 c0                	test   %eax,%eax
  8023c0:	75 08                	jne    8023ca <insert_sorted_allocList+0x170>
  8023c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c5:	a3 44 40 80 00       	mov    %eax,0x804044
  8023ca:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023cf:	40                   	inc    %eax
  8023d0:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  8023d5:	e9 da 00 00 00       	jmp    8024b4 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  8023da:	a1 40 40 80 00       	mov    0x804040,%eax
  8023df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023e2:	e9 9d 00 00 00       	jmp    802484 <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  8023e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ea:	8b 00                	mov    (%eax),%eax
  8023ec:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  8023ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f2:	8b 50 08             	mov    0x8(%eax),%edx
  8023f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f8:	8b 40 08             	mov    0x8(%eax),%eax
  8023fb:	39 c2                	cmp    %eax,%edx
  8023fd:	76 7d                	jbe    80247c <insert_sorted_allocList+0x222>
  8023ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802402:	8b 50 08             	mov    0x8(%eax),%edx
  802405:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802408:	8b 40 08             	mov    0x8(%eax),%eax
  80240b:	39 c2                	cmp    %eax,%edx
  80240d:	73 6d                	jae    80247c <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  80240f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802413:	74 06                	je     80241b <insert_sorted_allocList+0x1c1>
  802415:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802419:	75 14                	jne    80242f <insert_sorted_allocList+0x1d5>
  80241b:	83 ec 04             	sub    $0x4,%esp
  80241e:	68 54 3c 80 00       	push   $0x803c54
  802423:	6a 7c                	push   $0x7c
  802425:	68 17 3c 80 00       	push   $0x803c17
  80242a:	e8 81 df ff ff       	call   8003b0 <_panic>
  80242f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802432:	8b 10                	mov    (%eax),%edx
  802434:	8b 45 08             	mov    0x8(%ebp),%eax
  802437:	89 10                	mov    %edx,(%eax)
  802439:	8b 45 08             	mov    0x8(%ebp),%eax
  80243c:	8b 00                	mov    (%eax),%eax
  80243e:	85 c0                	test   %eax,%eax
  802440:	74 0b                	je     80244d <insert_sorted_allocList+0x1f3>
  802442:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802445:	8b 00                	mov    (%eax),%eax
  802447:	8b 55 08             	mov    0x8(%ebp),%edx
  80244a:	89 50 04             	mov    %edx,0x4(%eax)
  80244d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802450:	8b 55 08             	mov    0x8(%ebp),%edx
  802453:	89 10                	mov    %edx,(%eax)
  802455:	8b 45 08             	mov    0x8(%ebp),%eax
  802458:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80245b:	89 50 04             	mov    %edx,0x4(%eax)
  80245e:	8b 45 08             	mov    0x8(%ebp),%eax
  802461:	8b 00                	mov    (%eax),%eax
  802463:	85 c0                	test   %eax,%eax
  802465:	75 08                	jne    80246f <insert_sorted_allocList+0x215>
  802467:	8b 45 08             	mov    0x8(%ebp),%eax
  80246a:	a3 44 40 80 00       	mov    %eax,0x804044
  80246f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802474:	40                   	inc    %eax
  802475:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  80247a:	eb 38                	jmp    8024b4 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  80247c:	a1 48 40 80 00       	mov    0x804048,%eax
  802481:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802484:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802488:	74 07                	je     802491 <insert_sorted_allocList+0x237>
  80248a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248d:	8b 00                	mov    (%eax),%eax
  80248f:	eb 05                	jmp    802496 <insert_sorted_allocList+0x23c>
  802491:	b8 00 00 00 00       	mov    $0x0,%eax
  802496:	a3 48 40 80 00       	mov    %eax,0x804048
  80249b:	a1 48 40 80 00       	mov    0x804048,%eax
  8024a0:	85 c0                	test   %eax,%eax
  8024a2:	0f 85 3f ff ff ff    	jne    8023e7 <insert_sorted_allocList+0x18d>
  8024a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ac:	0f 85 35 ff ff ff    	jne    8023e7 <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  8024b2:	eb 00                	jmp    8024b4 <insert_sorted_allocList+0x25a>
  8024b4:	90                   	nop
  8024b5:	c9                   	leave  
  8024b6:	c3                   	ret    

008024b7 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8024b7:	55                   	push   %ebp
  8024b8:	89 e5                	mov    %esp,%ebp
  8024ba:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  8024bd:	a1 38 41 80 00       	mov    0x804138,%eax
  8024c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024c5:	e9 6b 02 00 00       	jmp    802735 <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  8024ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8024d0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024d3:	0f 85 90 00 00 00    	jne    802569 <alloc_block_FF+0xb2>
			  temp=element;
  8024d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024dc:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  8024df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024e3:	75 17                	jne    8024fc <alloc_block_FF+0x45>
  8024e5:	83 ec 04             	sub    $0x4,%esp
  8024e8:	68 88 3c 80 00       	push   $0x803c88
  8024ed:	68 92 00 00 00       	push   $0x92
  8024f2:	68 17 3c 80 00       	push   $0x803c17
  8024f7:	e8 b4 de ff ff       	call   8003b0 <_panic>
  8024fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ff:	8b 00                	mov    (%eax),%eax
  802501:	85 c0                	test   %eax,%eax
  802503:	74 10                	je     802515 <alloc_block_FF+0x5e>
  802505:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802508:	8b 00                	mov    (%eax),%eax
  80250a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80250d:	8b 52 04             	mov    0x4(%edx),%edx
  802510:	89 50 04             	mov    %edx,0x4(%eax)
  802513:	eb 0b                	jmp    802520 <alloc_block_FF+0x69>
  802515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802518:	8b 40 04             	mov    0x4(%eax),%eax
  80251b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802520:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802523:	8b 40 04             	mov    0x4(%eax),%eax
  802526:	85 c0                	test   %eax,%eax
  802528:	74 0f                	je     802539 <alloc_block_FF+0x82>
  80252a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252d:	8b 40 04             	mov    0x4(%eax),%eax
  802530:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802533:	8b 12                	mov    (%edx),%edx
  802535:	89 10                	mov    %edx,(%eax)
  802537:	eb 0a                	jmp    802543 <alloc_block_FF+0x8c>
  802539:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253c:	8b 00                	mov    (%eax),%eax
  80253e:	a3 38 41 80 00       	mov    %eax,0x804138
  802543:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802546:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80254c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802556:	a1 44 41 80 00       	mov    0x804144,%eax
  80255b:	48                   	dec    %eax
  80255c:	a3 44 41 80 00       	mov    %eax,0x804144
			  return temp;
  802561:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802564:	e9 ff 01 00 00       	jmp    802768 <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  802569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256c:	8b 40 0c             	mov    0xc(%eax),%eax
  80256f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802572:	0f 86 b5 01 00 00    	jbe    80272d <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  802578:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257b:	8b 40 0c             	mov    0xc(%eax),%eax
  80257e:	2b 45 08             	sub    0x8(%ebp),%eax
  802581:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  802584:	a1 48 41 80 00       	mov    0x804148,%eax
  802589:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  80258c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802590:	75 17                	jne    8025a9 <alloc_block_FF+0xf2>
  802592:	83 ec 04             	sub    $0x4,%esp
  802595:	68 88 3c 80 00       	push   $0x803c88
  80259a:	68 99 00 00 00       	push   $0x99
  80259f:	68 17 3c 80 00       	push   $0x803c17
  8025a4:	e8 07 de ff ff       	call   8003b0 <_panic>
  8025a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ac:	8b 00                	mov    (%eax),%eax
  8025ae:	85 c0                	test   %eax,%eax
  8025b0:	74 10                	je     8025c2 <alloc_block_FF+0x10b>
  8025b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025b5:	8b 00                	mov    (%eax),%eax
  8025b7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025ba:	8b 52 04             	mov    0x4(%edx),%edx
  8025bd:	89 50 04             	mov    %edx,0x4(%eax)
  8025c0:	eb 0b                	jmp    8025cd <alloc_block_FF+0x116>
  8025c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025c5:	8b 40 04             	mov    0x4(%eax),%eax
  8025c8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8025cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d0:	8b 40 04             	mov    0x4(%eax),%eax
  8025d3:	85 c0                	test   %eax,%eax
  8025d5:	74 0f                	je     8025e6 <alloc_block_FF+0x12f>
  8025d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025da:	8b 40 04             	mov    0x4(%eax),%eax
  8025dd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025e0:	8b 12                	mov    (%edx),%edx
  8025e2:	89 10                	mov    %edx,(%eax)
  8025e4:	eb 0a                	jmp    8025f0 <alloc_block_FF+0x139>
  8025e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e9:	8b 00                	mov    (%eax),%eax
  8025eb:	a3 48 41 80 00       	mov    %eax,0x804148
  8025f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802603:	a1 54 41 80 00       	mov    0x804154,%eax
  802608:	48                   	dec    %eax
  802609:	a3 54 41 80 00       	mov    %eax,0x804154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  80260e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802612:	75 17                	jne    80262b <alloc_block_FF+0x174>
  802614:	83 ec 04             	sub    $0x4,%esp
  802617:	68 30 3c 80 00       	push   $0x803c30
  80261c:	68 9a 00 00 00       	push   $0x9a
  802621:	68 17 3c 80 00       	push   $0x803c17
  802626:	e8 85 dd ff ff       	call   8003b0 <_panic>
  80262b:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802631:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802634:	89 50 04             	mov    %edx,0x4(%eax)
  802637:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80263a:	8b 40 04             	mov    0x4(%eax),%eax
  80263d:	85 c0                	test   %eax,%eax
  80263f:	74 0c                	je     80264d <alloc_block_FF+0x196>
  802641:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802646:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802649:	89 10                	mov    %edx,(%eax)
  80264b:	eb 08                	jmp    802655 <alloc_block_FF+0x19e>
  80264d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802650:	a3 38 41 80 00       	mov    %eax,0x804138
  802655:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802658:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80265d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802660:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802666:	a1 44 41 80 00       	mov    0x804144,%eax
  80266b:	40                   	inc    %eax
  80266c:	a3 44 41 80 00       	mov    %eax,0x804144
		  // setting the size & sva
		  new_block->size=size;
  802671:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802674:	8b 55 08             	mov    0x8(%ebp),%edx
  802677:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  80267a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267d:	8b 50 08             	mov    0x8(%eax),%edx
  802680:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802683:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  802686:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802689:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80268c:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  80268f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802692:	8b 50 08             	mov    0x8(%eax),%edx
  802695:	8b 45 08             	mov    0x8(%ebp),%eax
  802698:	01 c2                	add    %eax,%edx
  80269a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269d:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  8026a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  8026a6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026aa:	75 17                	jne    8026c3 <alloc_block_FF+0x20c>
  8026ac:	83 ec 04             	sub    $0x4,%esp
  8026af:	68 88 3c 80 00       	push   $0x803c88
  8026b4:	68 a2 00 00 00       	push   $0xa2
  8026b9:	68 17 3c 80 00       	push   $0x803c17
  8026be:	e8 ed dc ff ff       	call   8003b0 <_panic>
  8026c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c6:	8b 00                	mov    (%eax),%eax
  8026c8:	85 c0                	test   %eax,%eax
  8026ca:	74 10                	je     8026dc <alloc_block_FF+0x225>
  8026cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026cf:	8b 00                	mov    (%eax),%eax
  8026d1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026d4:	8b 52 04             	mov    0x4(%edx),%edx
  8026d7:	89 50 04             	mov    %edx,0x4(%eax)
  8026da:	eb 0b                	jmp    8026e7 <alloc_block_FF+0x230>
  8026dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026df:	8b 40 04             	mov    0x4(%eax),%eax
  8026e2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ea:	8b 40 04             	mov    0x4(%eax),%eax
  8026ed:	85 c0                	test   %eax,%eax
  8026ef:	74 0f                	je     802700 <alloc_block_FF+0x249>
  8026f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f4:	8b 40 04             	mov    0x4(%eax),%eax
  8026f7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026fa:	8b 12                	mov    (%edx),%edx
  8026fc:	89 10                	mov    %edx,(%eax)
  8026fe:	eb 0a                	jmp    80270a <alloc_block_FF+0x253>
  802700:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802703:	8b 00                	mov    (%eax),%eax
  802705:	a3 38 41 80 00       	mov    %eax,0x804138
  80270a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80270d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802713:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802716:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80271d:	a1 44 41 80 00       	mov    0x804144,%eax
  802722:	48                   	dec    %eax
  802723:	a3 44 41 80 00       	mov    %eax,0x804144
		  return temp;
  802728:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80272b:	eb 3b                	jmp    802768 <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  80272d:	a1 40 41 80 00       	mov    0x804140,%eax
  802732:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802735:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802739:	74 07                	je     802742 <alloc_block_FF+0x28b>
  80273b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273e:	8b 00                	mov    (%eax),%eax
  802740:	eb 05                	jmp    802747 <alloc_block_FF+0x290>
  802742:	b8 00 00 00 00       	mov    $0x0,%eax
  802747:	a3 40 41 80 00       	mov    %eax,0x804140
  80274c:	a1 40 41 80 00       	mov    0x804140,%eax
  802751:	85 c0                	test   %eax,%eax
  802753:	0f 85 71 fd ff ff    	jne    8024ca <alloc_block_FF+0x13>
  802759:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80275d:	0f 85 67 fd ff ff    	jne    8024ca <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  802763:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802768:	c9                   	leave  
  802769:	c3                   	ret    

0080276a <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80276a:	55                   	push   %ebp
  80276b:	89 e5                	mov    %esp,%ebp
  80276d:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  802770:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  802777:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  80277e:	a1 38 41 80 00       	mov    0x804138,%eax
  802783:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802786:	e9 d3 00 00 00       	jmp    80285e <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  80278b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80278e:	8b 40 0c             	mov    0xc(%eax),%eax
  802791:	3b 45 08             	cmp    0x8(%ebp),%eax
  802794:	0f 85 90 00 00 00    	jne    80282a <alloc_block_BF+0xc0>
	   temp = element;
  80279a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80279d:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  8027a0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8027a4:	75 17                	jne    8027bd <alloc_block_BF+0x53>
  8027a6:	83 ec 04             	sub    $0x4,%esp
  8027a9:	68 88 3c 80 00       	push   $0x803c88
  8027ae:	68 bd 00 00 00       	push   $0xbd
  8027b3:	68 17 3c 80 00       	push   $0x803c17
  8027b8:	e8 f3 db ff ff       	call   8003b0 <_panic>
  8027bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027c0:	8b 00                	mov    (%eax),%eax
  8027c2:	85 c0                	test   %eax,%eax
  8027c4:	74 10                	je     8027d6 <alloc_block_BF+0x6c>
  8027c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027c9:	8b 00                	mov    (%eax),%eax
  8027cb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027ce:	8b 52 04             	mov    0x4(%edx),%edx
  8027d1:	89 50 04             	mov    %edx,0x4(%eax)
  8027d4:	eb 0b                	jmp    8027e1 <alloc_block_BF+0x77>
  8027d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027d9:	8b 40 04             	mov    0x4(%eax),%eax
  8027dc:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027e4:	8b 40 04             	mov    0x4(%eax),%eax
  8027e7:	85 c0                	test   %eax,%eax
  8027e9:	74 0f                	je     8027fa <alloc_block_BF+0x90>
  8027eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027ee:	8b 40 04             	mov    0x4(%eax),%eax
  8027f1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027f4:	8b 12                	mov    (%edx),%edx
  8027f6:	89 10                	mov    %edx,(%eax)
  8027f8:	eb 0a                	jmp    802804 <alloc_block_BF+0x9a>
  8027fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027fd:	8b 00                	mov    (%eax),%eax
  8027ff:	a3 38 41 80 00       	mov    %eax,0x804138
  802804:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802807:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80280d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802810:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802817:	a1 44 41 80 00       	mov    0x804144,%eax
  80281c:	48                   	dec    %eax
  80281d:	a3 44 41 80 00       	mov    %eax,0x804144
	   return temp;
  802822:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802825:	e9 41 01 00 00       	jmp    80296b <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  80282a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80282d:	8b 40 0c             	mov    0xc(%eax),%eax
  802830:	3b 45 08             	cmp    0x8(%ebp),%eax
  802833:	76 21                	jbe    802856 <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  802835:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802838:	8b 40 0c             	mov    0xc(%eax),%eax
  80283b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80283e:	73 16                	jae    802856 <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  802840:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802843:	8b 40 0c             	mov    0xc(%eax),%eax
  802846:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  802849:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80284c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  80284f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802856:	a1 40 41 80 00       	mov    0x804140,%eax
  80285b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80285e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802862:	74 07                	je     80286b <alloc_block_BF+0x101>
  802864:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802867:	8b 00                	mov    (%eax),%eax
  802869:	eb 05                	jmp    802870 <alloc_block_BF+0x106>
  80286b:	b8 00 00 00 00       	mov    $0x0,%eax
  802870:	a3 40 41 80 00       	mov    %eax,0x804140
  802875:	a1 40 41 80 00       	mov    0x804140,%eax
  80287a:	85 c0                	test   %eax,%eax
  80287c:	0f 85 09 ff ff ff    	jne    80278b <alloc_block_BF+0x21>
  802882:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802886:	0f 85 ff fe ff ff    	jne    80278b <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  80288c:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  802890:	0f 85 d0 00 00 00    	jne    802966 <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  802896:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802899:	8b 40 0c             	mov    0xc(%eax),%eax
  80289c:	2b 45 08             	sub    0x8(%ebp),%eax
  80289f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  8028a2:	a1 48 41 80 00       	mov    0x804148,%eax
  8028a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  8028aa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8028ae:	75 17                	jne    8028c7 <alloc_block_BF+0x15d>
  8028b0:	83 ec 04             	sub    $0x4,%esp
  8028b3:	68 88 3c 80 00       	push   $0x803c88
  8028b8:	68 d1 00 00 00       	push   $0xd1
  8028bd:	68 17 3c 80 00       	push   $0x803c17
  8028c2:	e8 e9 da ff ff       	call   8003b0 <_panic>
  8028c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028ca:	8b 00                	mov    (%eax),%eax
  8028cc:	85 c0                	test   %eax,%eax
  8028ce:	74 10                	je     8028e0 <alloc_block_BF+0x176>
  8028d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028d3:	8b 00                	mov    (%eax),%eax
  8028d5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028d8:	8b 52 04             	mov    0x4(%edx),%edx
  8028db:	89 50 04             	mov    %edx,0x4(%eax)
  8028de:	eb 0b                	jmp    8028eb <alloc_block_BF+0x181>
  8028e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028e3:	8b 40 04             	mov    0x4(%eax),%eax
  8028e6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8028eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028ee:	8b 40 04             	mov    0x4(%eax),%eax
  8028f1:	85 c0                	test   %eax,%eax
  8028f3:	74 0f                	je     802904 <alloc_block_BF+0x19a>
  8028f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028f8:	8b 40 04             	mov    0x4(%eax),%eax
  8028fb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028fe:	8b 12                	mov    (%edx),%edx
  802900:	89 10                	mov    %edx,(%eax)
  802902:	eb 0a                	jmp    80290e <alloc_block_BF+0x1a4>
  802904:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802907:	8b 00                	mov    (%eax),%eax
  802909:	a3 48 41 80 00       	mov    %eax,0x804148
  80290e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802911:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802917:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80291a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802921:	a1 54 41 80 00       	mov    0x804154,%eax
  802926:	48                   	dec    %eax
  802927:	a3 54 41 80 00       	mov    %eax,0x804154
	  // setting the size & sva
	  new_block->size = size;
  80292c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80292f:	8b 55 08             	mov    0x8(%ebp),%edx
  802932:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  802935:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802938:	8b 50 08             	mov    0x8(%eax),%edx
  80293b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80293e:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  802941:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802944:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802947:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  80294a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80294d:	8b 50 08             	mov    0x8(%eax),%edx
  802950:	8b 45 08             	mov    0x8(%ebp),%eax
  802953:	01 c2                	add    %eax,%edx
  802955:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802958:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  80295b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80295e:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  802961:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802964:	eb 05                	jmp    80296b <alloc_block_BF+0x201>
	 }
	 return NULL;
  802966:	b8 00 00 00 00       	mov    $0x0,%eax


}
  80296b:	c9                   	leave  
  80296c:	c3                   	ret    

0080296d <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80296d:	55                   	push   %ebp
  80296e:	89 e5                	mov    %esp,%ebp
  802970:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802973:	83 ec 04             	sub    $0x4,%esp
  802976:	68 a8 3c 80 00       	push   $0x803ca8
  80297b:	68 e8 00 00 00       	push   $0xe8
  802980:	68 17 3c 80 00       	push   $0x803c17
  802985:	e8 26 da ff ff       	call   8003b0 <_panic>

0080298a <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80298a:	55                   	push   %ebp
  80298b:	89 e5                	mov    %esp,%ebp
  80298d:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  802990:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802995:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  802998:	a1 38 41 80 00       	mov    0x804138,%eax
  80299d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  8029a0:	a1 44 41 80 00       	mov    0x804144,%eax
  8029a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  8029a8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029ac:	75 68                	jne    802a16 <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8029ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029b2:	75 17                	jne    8029cb <insert_sorted_with_merge_freeList+0x41>
  8029b4:	83 ec 04             	sub    $0x4,%esp
  8029b7:	68 f4 3b 80 00       	push   $0x803bf4
  8029bc:	68 36 01 00 00       	push   $0x136
  8029c1:	68 17 3c 80 00       	push   $0x803c17
  8029c6:	e8 e5 d9 ff ff       	call   8003b0 <_panic>
  8029cb:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8029d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d4:	89 10                	mov    %edx,(%eax)
  8029d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d9:	8b 00                	mov    (%eax),%eax
  8029db:	85 c0                	test   %eax,%eax
  8029dd:	74 0d                	je     8029ec <insert_sorted_with_merge_freeList+0x62>
  8029df:	a1 38 41 80 00       	mov    0x804138,%eax
  8029e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8029e7:	89 50 04             	mov    %edx,0x4(%eax)
  8029ea:	eb 08                	jmp    8029f4 <insert_sorted_with_merge_freeList+0x6a>
  8029ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ef:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f7:	a3 38 41 80 00       	mov    %eax,0x804138
  8029fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a06:	a1 44 41 80 00       	mov    0x804144,%eax
  802a0b:	40                   	inc    %eax
  802a0c:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802a11:	e9 ba 06 00 00       	jmp    8030d0 <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  802a16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a19:	8b 50 08             	mov    0x8(%eax),%edx
  802a1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a1f:	8b 40 0c             	mov    0xc(%eax),%eax
  802a22:	01 c2                	add    %eax,%edx
  802a24:	8b 45 08             	mov    0x8(%ebp),%eax
  802a27:	8b 40 08             	mov    0x8(%eax),%eax
  802a2a:	39 c2                	cmp    %eax,%edx
  802a2c:	73 68                	jae    802a96 <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802a2e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a32:	75 17                	jne    802a4b <insert_sorted_with_merge_freeList+0xc1>
  802a34:	83 ec 04             	sub    $0x4,%esp
  802a37:	68 30 3c 80 00       	push   $0x803c30
  802a3c:	68 3a 01 00 00       	push   $0x13a
  802a41:	68 17 3c 80 00       	push   $0x803c17
  802a46:	e8 65 d9 ff ff       	call   8003b0 <_panic>
  802a4b:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802a51:	8b 45 08             	mov    0x8(%ebp),%eax
  802a54:	89 50 04             	mov    %edx,0x4(%eax)
  802a57:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5a:	8b 40 04             	mov    0x4(%eax),%eax
  802a5d:	85 c0                	test   %eax,%eax
  802a5f:	74 0c                	je     802a6d <insert_sorted_with_merge_freeList+0xe3>
  802a61:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a66:	8b 55 08             	mov    0x8(%ebp),%edx
  802a69:	89 10                	mov    %edx,(%eax)
  802a6b:	eb 08                	jmp    802a75 <insert_sorted_with_merge_freeList+0xeb>
  802a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a70:	a3 38 41 80 00       	mov    %eax,0x804138
  802a75:	8b 45 08             	mov    0x8(%ebp),%eax
  802a78:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a86:	a1 44 41 80 00       	mov    0x804144,%eax
  802a8b:	40                   	inc    %eax
  802a8c:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802a91:	e9 3a 06 00 00       	jmp    8030d0 <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  802a96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a99:	8b 50 08             	mov    0x8(%eax),%edx
  802a9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a9f:	8b 40 0c             	mov    0xc(%eax),%eax
  802aa2:	01 c2                	add    %eax,%edx
  802aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa7:	8b 40 08             	mov    0x8(%eax),%eax
  802aaa:	39 c2                	cmp    %eax,%edx
  802aac:	0f 85 90 00 00 00    	jne    802b42 <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  802ab2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab5:	8b 50 0c             	mov    0xc(%eax),%edx
  802ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  802abb:	8b 40 0c             	mov    0xc(%eax),%eax
  802abe:	01 c2                	add    %eax,%edx
  802ac0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac3:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  802ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  802ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802ada:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ade:	75 17                	jne    802af7 <insert_sorted_with_merge_freeList+0x16d>
  802ae0:	83 ec 04             	sub    $0x4,%esp
  802ae3:	68 f4 3b 80 00       	push   $0x803bf4
  802ae8:	68 41 01 00 00       	push   $0x141
  802aed:	68 17 3c 80 00       	push   $0x803c17
  802af2:	e8 b9 d8 ff ff       	call   8003b0 <_panic>
  802af7:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802afd:	8b 45 08             	mov    0x8(%ebp),%eax
  802b00:	89 10                	mov    %edx,(%eax)
  802b02:	8b 45 08             	mov    0x8(%ebp),%eax
  802b05:	8b 00                	mov    (%eax),%eax
  802b07:	85 c0                	test   %eax,%eax
  802b09:	74 0d                	je     802b18 <insert_sorted_with_merge_freeList+0x18e>
  802b0b:	a1 48 41 80 00       	mov    0x804148,%eax
  802b10:	8b 55 08             	mov    0x8(%ebp),%edx
  802b13:	89 50 04             	mov    %edx,0x4(%eax)
  802b16:	eb 08                	jmp    802b20 <insert_sorted_with_merge_freeList+0x196>
  802b18:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b20:	8b 45 08             	mov    0x8(%ebp),%eax
  802b23:	a3 48 41 80 00       	mov    %eax,0x804148
  802b28:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b32:	a1 54 41 80 00       	mov    0x804154,%eax
  802b37:	40                   	inc    %eax
  802b38:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802b3d:	e9 8e 05 00 00       	jmp    8030d0 <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  802b42:	8b 45 08             	mov    0x8(%ebp),%eax
  802b45:	8b 50 08             	mov    0x8(%eax),%edx
  802b48:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b4e:	01 c2                	add    %eax,%edx
  802b50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b53:	8b 40 08             	mov    0x8(%eax),%eax
  802b56:	39 c2                	cmp    %eax,%edx
  802b58:	73 68                	jae    802bc2 <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802b5a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b5e:	75 17                	jne    802b77 <insert_sorted_with_merge_freeList+0x1ed>
  802b60:	83 ec 04             	sub    $0x4,%esp
  802b63:	68 f4 3b 80 00       	push   $0x803bf4
  802b68:	68 45 01 00 00       	push   $0x145
  802b6d:	68 17 3c 80 00       	push   $0x803c17
  802b72:	e8 39 d8 ff ff       	call   8003b0 <_panic>
  802b77:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b80:	89 10                	mov    %edx,(%eax)
  802b82:	8b 45 08             	mov    0x8(%ebp),%eax
  802b85:	8b 00                	mov    (%eax),%eax
  802b87:	85 c0                	test   %eax,%eax
  802b89:	74 0d                	je     802b98 <insert_sorted_with_merge_freeList+0x20e>
  802b8b:	a1 38 41 80 00       	mov    0x804138,%eax
  802b90:	8b 55 08             	mov    0x8(%ebp),%edx
  802b93:	89 50 04             	mov    %edx,0x4(%eax)
  802b96:	eb 08                	jmp    802ba0 <insert_sorted_with_merge_freeList+0x216>
  802b98:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba3:	a3 38 41 80 00       	mov    %eax,0x804138
  802ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bb2:	a1 44 41 80 00       	mov    0x804144,%eax
  802bb7:	40                   	inc    %eax
  802bb8:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802bbd:	e9 0e 05 00 00       	jmp    8030d0 <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  802bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc5:	8b 50 08             	mov    0x8(%eax),%edx
  802bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcb:	8b 40 0c             	mov    0xc(%eax),%eax
  802bce:	01 c2                	add    %eax,%edx
  802bd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd3:	8b 40 08             	mov    0x8(%eax),%eax
  802bd6:	39 c2                	cmp    %eax,%edx
  802bd8:	0f 85 9c 00 00 00    	jne    802c7a <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  802bde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be1:	8b 50 0c             	mov    0xc(%eax),%edx
  802be4:	8b 45 08             	mov    0x8(%ebp),%eax
  802be7:	8b 40 0c             	mov    0xc(%eax),%eax
  802bea:	01 c2                	add    %eax,%edx
  802bec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bef:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  802bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf5:	8b 50 08             	mov    0x8(%eax),%edx
  802bf8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bfb:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  802bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802c01:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  802c08:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802c12:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c16:	75 17                	jne    802c2f <insert_sorted_with_merge_freeList+0x2a5>
  802c18:	83 ec 04             	sub    $0x4,%esp
  802c1b:	68 f4 3b 80 00       	push   $0x803bf4
  802c20:	68 4d 01 00 00       	push   $0x14d
  802c25:	68 17 3c 80 00       	push   $0x803c17
  802c2a:	e8 81 d7 ff ff       	call   8003b0 <_panic>
  802c2f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c35:	8b 45 08             	mov    0x8(%ebp),%eax
  802c38:	89 10                	mov    %edx,(%eax)
  802c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3d:	8b 00                	mov    (%eax),%eax
  802c3f:	85 c0                	test   %eax,%eax
  802c41:	74 0d                	je     802c50 <insert_sorted_with_merge_freeList+0x2c6>
  802c43:	a1 48 41 80 00       	mov    0x804148,%eax
  802c48:	8b 55 08             	mov    0x8(%ebp),%edx
  802c4b:	89 50 04             	mov    %edx,0x4(%eax)
  802c4e:	eb 08                	jmp    802c58 <insert_sorted_with_merge_freeList+0x2ce>
  802c50:	8b 45 08             	mov    0x8(%ebp),%eax
  802c53:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c58:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5b:	a3 48 41 80 00       	mov    %eax,0x804148
  802c60:	8b 45 08             	mov    0x8(%ebp),%eax
  802c63:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c6a:	a1 54 41 80 00       	mov    0x804154,%eax
  802c6f:	40                   	inc    %eax
  802c70:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802c75:	e9 56 04 00 00       	jmp    8030d0 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802c7a:	a1 38 41 80 00       	mov    0x804138,%eax
  802c7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c82:	e9 19 04 00 00       	jmp    8030a0 <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  802c87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8a:	8b 00                	mov    (%eax),%eax
  802c8c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802c8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c92:	8b 50 08             	mov    0x8(%eax),%edx
  802c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c98:	8b 40 0c             	mov    0xc(%eax),%eax
  802c9b:	01 c2                	add    %eax,%edx
  802c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca0:	8b 40 08             	mov    0x8(%eax),%eax
  802ca3:	39 c2                	cmp    %eax,%edx
  802ca5:	0f 85 ad 01 00 00    	jne    802e58 <insert_sorted_with_merge_freeList+0x4ce>
  802cab:	8b 45 08             	mov    0x8(%ebp),%eax
  802cae:	8b 50 08             	mov    0x8(%eax),%edx
  802cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb4:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb7:	01 c2                	add    %eax,%edx
  802cb9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cbc:	8b 40 08             	mov    0x8(%eax),%eax
  802cbf:	39 c2                	cmp    %eax,%edx
  802cc1:	0f 85 91 01 00 00    	jne    802e58 <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  802cc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cca:	8b 50 0c             	mov    0xc(%eax),%edx
  802ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd0:	8b 48 0c             	mov    0xc(%eax),%ecx
  802cd3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cd6:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd9:	01 c8                	add    %ecx,%eax
  802cdb:	01 c2                	add    %eax,%edx
  802cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce0:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  802ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802ced:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  802cf7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cfa:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  802d01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d04:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  802d0b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802d0f:	75 17                	jne    802d28 <insert_sorted_with_merge_freeList+0x39e>
  802d11:	83 ec 04             	sub    $0x4,%esp
  802d14:	68 88 3c 80 00       	push   $0x803c88
  802d19:	68 5b 01 00 00       	push   $0x15b
  802d1e:	68 17 3c 80 00       	push   $0x803c17
  802d23:	e8 88 d6 ff ff       	call   8003b0 <_panic>
  802d28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d2b:	8b 00                	mov    (%eax),%eax
  802d2d:	85 c0                	test   %eax,%eax
  802d2f:	74 10                	je     802d41 <insert_sorted_with_merge_freeList+0x3b7>
  802d31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d34:	8b 00                	mov    (%eax),%eax
  802d36:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d39:	8b 52 04             	mov    0x4(%edx),%edx
  802d3c:	89 50 04             	mov    %edx,0x4(%eax)
  802d3f:	eb 0b                	jmp    802d4c <insert_sorted_with_merge_freeList+0x3c2>
  802d41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d44:	8b 40 04             	mov    0x4(%eax),%eax
  802d47:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d4f:	8b 40 04             	mov    0x4(%eax),%eax
  802d52:	85 c0                	test   %eax,%eax
  802d54:	74 0f                	je     802d65 <insert_sorted_with_merge_freeList+0x3db>
  802d56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d59:	8b 40 04             	mov    0x4(%eax),%eax
  802d5c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d5f:	8b 12                	mov    (%edx),%edx
  802d61:	89 10                	mov    %edx,(%eax)
  802d63:	eb 0a                	jmp    802d6f <insert_sorted_with_merge_freeList+0x3e5>
  802d65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d68:	8b 00                	mov    (%eax),%eax
  802d6a:	a3 38 41 80 00       	mov    %eax,0x804138
  802d6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d72:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d7b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d82:	a1 44 41 80 00       	mov    0x804144,%eax
  802d87:	48                   	dec    %eax
  802d88:	a3 44 41 80 00       	mov    %eax,0x804144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802d8d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d91:	75 17                	jne    802daa <insert_sorted_with_merge_freeList+0x420>
  802d93:	83 ec 04             	sub    $0x4,%esp
  802d96:	68 f4 3b 80 00       	push   $0x803bf4
  802d9b:	68 5c 01 00 00       	push   $0x15c
  802da0:	68 17 3c 80 00       	push   $0x803c17
  802da5:	e8 06 d6 ff ff       	call   8003b0 <_panic>
  802daa:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802db0:	8b 45 08             	mov    0x8(%ebp),%eax
  802db3:	89 10                	mov    %edx,(%eax)
  802db5:	8b 45 08             	mov    0x8(%ebp),%eax
  802db8:	8b 00                	mov    (%eax),%eax
  802dba:	85 c0                	test   %eax,%eax
  802dbc:	74 0d                	je     802dcb <insert_sorted_with_merge_freeList+0x441>
  802dbe:	a1 48 41 80 00       	mov    0x804148,%eax
  802dc3:	8b 55 08             	mov    0x8(%ebp),%edx
  802dc6:	89 50 04             	mov    %edx,0x4(%eax)
  802dc9:	eb 08                	jmp    802dd3 <insert_sorted_with_merge_freeList+0x449>
  802dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dce:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd6:	a3 48 41 80 00       	mov    %eax,0x804148
  802ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dde:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802de5:	a1 54 41 80 00       	mov    0x804154,%eax
  802dea:	40                   	inc    %eax
  802deb:	a3 54 41 80 00       	mov    %eax,0x804154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  802df0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802df4:	75 17                	jne    802e0d <insert_sorted_with_merge_freeList+0x483>
  802df6:	83 ec 04             	sub    $0x4,%esp
  802df9:	68 f4 3b 80 00       	push   $0x803bf4
  802dfe:	68 5d 01 00 00       	push   $0x15d
  802e03:	68 17 3c 80 00       	push   $0x803c17
  802e08:	e8 a3 d5 ff ff       	call   8003b0 <_panic>
  802e0d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e16:	89 10                	mov    %edx,(%eax)
  802e18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e1b:	8b 00                	mov    (%eax),%eax
  802e1d:	85 c0                	test   %eax,%eax
  802e1f:	74 0d                	je     802e2e <insert_sorted_with_merge_freeList+0x4a4>
  802e21:	a1 48 41 80 00       	mov    0x804148,%eax
  802e26:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e29:	89 50 04             	mov    %edx,0x4(%eax)
  802e2c:	eb 08                	jmp    802e36 <insert_sorted_with_merge_freeList+0x4ac>
  802e2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e31:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e39:	a3 48 41 80 00       	mov    %eax,0x804148
  802e3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e41:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e48:	a1 54 41 80 00       	mov    0x804154,%eax
  802e4d:	40                   	inc    %eax
  802e4e:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802e53:	e9 78 02 00 00       	jmp    8030d0 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802e58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5b:	8b 50 08             	mov    0x8(%eax),%edx
  802e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e61:	8b 40 0c             	mov    0xc(%eax),%eax
  802e64:	01 c2                	add    %eax,%edx
  802e66:	8b 45 08             	mov    0x8(%ebp),%eax
  802e69:	8b 40 08             	mov    0x8(%eax),%eax
  802e6c:	39 c2                	cmp    %eax,%edx
  802e6e:	0f 83 b8 00 00 00    	jae    802f2c <insert_sorted_with_merge_freeList+0x5a2>
  802e74:	8b 45 08             	mov    0x8(%ebp),%eax
  802e77:	8b 50 08             	mov    0x8(%eax),%edx
  802e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7d:	8b 40 0c             	mov    0xc(%eax),%eax
  802e80:	01 c2                	add    %eax,%edx
  802e82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e85:	8b 40 08             	mov    0x8(%eax),%eax
  802e88:	39 c2                	cmp    %eax,%edx
  802e8a:	0f 85 9c 00 00 00    	jne    802f2c <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  802e90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e93:	8b 50 0c             	mov    0xc(%eax),%edx
  802e96:	8b 45 08             	mov    0x8(%ebp),%eax
  802e99:	8b 40 0c             	mov    0xc(%eax),%eax
  802e9c:	01 c2                	add    %eax,%edx
  802e9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ea1:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  802ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea7:	8b 50 08             	mov    0x8(%eax),%edx
  802eaa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ead:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  802eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802eba:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802ec4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ec8:	75 17                	jne    802ee1 <insert_sorted_with_merge_freeList+0x557>
  802eca:	83 ec 04             	sub    $0x4,%esp
  802ecd:	68 f4 3b 80 00       	push   $0x803bf4
  802ed2:	68 67 01 00 00       	push   $0x167
  802ed7:	68 17 3c 80 00       	push   $0x803c17
  802edc:	e8 cf d4 ff ff       	call   8003b0 <_panic>
  802ee1:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eea:	89 10                	mov    %edx,(%eax)
  802eec:	8b 45 08             	mov    0x8(%ebp),%eax
  802eef:	8b 00                	mov    (%eax),%eax
  802ef1:	85 c0                	test   %eax,%eax
  802ef3:	74 0d                	je     802f02 <insert_sorted_with_merge_freeList+0x578>
  802ef5:	a1 48 41 80 00       	mov    0x804148,%eax
  802efa:	8b 55 08             	mov    0x8(%ebp),%edx
  802efd:	89 50 04             	mov    %edx,0x4(%eax)
  802f00:	eb 08                	jmp    802f0a <insert_sorted_with_merge_freeList+0x580>
  802f02:	8b 45 08             	mov    0x8(%ebp),%eax
  802f05:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0d:	a3 48 41 80 00       	mov    %eax,0x804148
  802f12:	8b 45 08             	mov    0x8(%ebp),%eax
  802f15:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f1c:	a1 54 41 80 00       	mov    0x804154,%eax
  802f21:	40                   	inc    %eax
  802f22:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802f27:	e9 a4 01 00 00       	jmp    8030d0 <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2f:	8b 50 08             	mov    0x8(%eax),%edx
  802f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f35:	8b 40 0c             	mov    0xc(%eax),%eax
  802f38:	01 c2                	add    %eax,%edx
  802f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3d:	8b 40 08             	mov    0x8(%eax),%eax
  802f40:	39 c2                	cmp    %eax,%edx
  802f42:	0f 85 ac 00 00 00    	jne    802ff4 <insert_sorted_with_merge_freeList+0x66a>
  802f48:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4b:	8b 50 08             	mov    0x8(%eax),%edx
  802f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f51:	8b 40 0c             	mov    0xc(%eax),%eax
  802f54:	01 c2                	add    %eax,%edx
  802f56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f59:	8b 40 08             	mov    0x8(%eax),%eax
  802f5c:	39 c2                	cmp    %eax,%edx
  802f5e:	0f 83 90 00 00 00    	jae    802ff4 <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  802f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f67:	8b 50 0c             	mov    0xc(%eax),%edx
  802f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6d:	8b 40 0c             	mov    0xc(%eax),%eax
  802f70:	01 c2                	add    %eax,%edx
  802f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f75:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  802f78:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  802f82:	8b 45 08             	mov    0x8(%ebp),%eax
  802f85:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802f8c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f90:	75 17                	jne    802fa9 <insert_sorted_with_merge_freeList+0x61f>
  802f92:	83 ec 04             	sub    $0x4,%esp
  802f95:	68 f4 3b 80 00       	push   $0x803bf4
  802f9a:	68 70 01 00 00       	push   $0x170
  802f9f:	68 17 3c 80 00       	push   $0x803c17
  802fa4:	e8 07 d4 ff ff       	call   8003b0 <_panic>
  802fa9:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802faf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb2:	89 10                	mov    %edx,(%eax)
  802fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb7:	8b 00                	mov    (%eax),%eax
  802fb9:	85 c0                	test   %eax,%eax
  802fbb:	74 0d                	je     802fca <insert_sorted_with_merge_freeList+0x640>
  802fbd:	a1 48 41 80 00       	mov    0x804148,%eax
  802fc2:	8b 55 08             	mov    0x8(%ebp),%edx
  802fc5:	89 50 04             	mov    %edx,0x4(%eax)
  802fc8:	eb 08                	jmp    802fd2 <insert_sorted_with_merge_freeList+0x648>
  802fca:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcd:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd5:	a3 48 41 80 00       	mov    %eax,0x804148
  802fda:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fe4:	a1 54 41 80 00       	mov    0x804154,%eax
  802fe9:	40                   	inc    %eax
  802fea:	a3 54 41 80 00       	mov    %eax,0x804154
	      break;
  802fef:	e9 dc 00 00 00       	jmp    8030d0 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff7:	8b 50 08             	mov    0x8(%eax),%edx
  802ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffd:	8b 40 0c             	mov    0xc(%eax),%eax
  803000:	01 c2                	add    %eax,%edx
  803002:	8b 45 08             	mov    0x8(%ebp),%eax
  803005:	8b 40 08             	mov    0x8(%eax),%eax
  803008:	39 c2                	cmp    %eax,%edx
  80300a:	0f 83 88 00 00 00    	jae    803098 <insert_sorted_with_merge_freeList+0x70e>
  803010:	8b 45 08             	mov    0x8(%ebp),%eax
  803013:	8b 50 08             	mov    0x8(%eax),%edx
  803016:	8b 45 08             	mov    0x8(%ebp),%eax
  803019:	8b 40 0c             	mov    0xc(%eax),%eax
  80301c:	01 c2                	add    %eax,%edx
  80301e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803021:	8b 40 08             	mov    0x8(%eax),%eax
  803024:	39 c2                	cmp    %eax,%edx
  803026:	73 70                	jae    803098 <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  803028:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80302c:	74 06                	je     803034 <insert_sorted_with_merge_freeList+0x6aa>
  80302e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803032:	75 17                	jne    80304b <insert_sorted_with_merge_freeList+0x6c1>
  803034:	83 ec 04             	sub    $0x4,%esp
  803037:	68 54 3c 80 00       	push   $0x803c54
  80303c:	68 75 01 00 00       	push   $0x175
  803041:	68 17 3c 80 00       	push   $0x803c17
  803046:	e8 65 d3 ff ff       	call   8003b0 <_panic>
  80304b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304e:	8b 10                	mov    (%eax),%edx
  803050:	8b 45 08             	mov    0x8(%ebp),%eax
  803053:	89 10                	mov    %edx,(%eax)
  803055:	8b 45 08             	mov    0x8(%ebp),%eax
  803058:	8b 00                	mov    (%eax),%eax
  80305a:	85 c0                	test   %eax,%eax
  80305c:	74 0b                	je     803069 <insert_sorted_with_merge_freeList+0x6df>
  80305e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803061:	8b 00                	mov    (%eax),%eax
  803063:	8b 55 08             	mov    0x8(%ebp),%edx
  803066:	89 50 04             	mov    %edx,0x4(%eax)
  803069:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306c:	8b 55 08             	mov    0x8(%ebp),%edx
  80306f:	89 10                	mov    %edx,(%eax)
  803071:	8b 45 08             	mov    0x8(%ebp),%eax
  803074:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803077:	89 50 04             	mov    %edx,0x4(%eax)
  80307a:	8b 45 08             	mov    0x8(%ebp),%eax
  80307d:	8b 00                	mov    (%eax),%eax
  80307f:	85 c0                	test   %eax,%eax
  803081:	75 08                	jne    80308b <insert_sorted_with_merge_freeList+0x701>
  803083:	8b 45 08             	mov    0x8(%ebp),%eax
  803086:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80308b:	a1 44 41 80 00       	mov    0x804144,%eax
  803090:	40                   	inc    %eax
  803091:	a3 44 41 80 00       	mov    %eax,0x804144
	      break;
  803096:	eb 38                	jmp    8030d0 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  803098:	a1 40 41 80 00       	mov    0x804140,%eax
  80309d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030a4:	74 07                	je     8030ad <insert_sorted_with_merge_freeList+0x723>
  8030a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a9:	8b 00                	mov    (%eax),%eax
  8030ab:	eb 05                	jmp    8030b2 <insert_sorted_with_merge_freeList+0x728>
  8030ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8030b2:	a3 40 41 80 00       	mov    %eax,0x804140
  8030b7:	a1 40 41 80 00       	mov    0x804140,%eax
  8030bc:	85 c0                	test   %eax,%eax
  8030be:	0f 85 c3 fb ff ff    	jne    802c87 <insert_sorted_with_merge_freeList+0x2fd>
  8030c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030c8:	0f 85 b9 fb ff ff    	jne    802c87 <insert_sorted_with_merge_freeList+0x2fd>





}
  8030ce:	eb 00                	jmp    8030d0 <insert_sorted_with_merge_freeList+0x746>
  8030d0:	90                   	nop
  8030d1:	c9                   	leave  
  8030d2:	c3                   	ret    
  8030d3:	90                   	nop

008030d4 <__udivdi3>:
  8030d4:	55                   	push   %ebp
  8030d5:	57                   	push   %edi
  8030d6:	56                   	push   %esi
  8030d7:	53                   	push   %ebx
  8030d8:	83 ec 1c             	sub    $0x1c,%esp
  8030db:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8030df:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8030e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8030e7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8030eb:	89 ca                	mov    %ecx,%edx
  8030ed:	89 f8                	mov    %edi,%eax
  8030ef:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8030f3:	85 f6                	test   %esi,%esi
  8030f5:	75 2d                	jne    803124 <__udivdi3+0x50>
  8030f7:	39 cf                	cmp    %ecx,%edi
  8030f9:	77 65                	ja     803160 <__udivdi3+0x8c>
  8030fb:	89 fd                	mov    %edi,%ebp
  8030fd:	85 ff                	test   %edi,%edi
  8030ff:	75 0b                	jne    80310c <__udivdi3+0x38>
  803101:	b8 01 00 00 00       	mov    $0x1,%eax
  803106:	31 d2                	xor    %edx,%edx
  803108:	f7 f7                	div    %edi
  80310a:	89 c5                	mov    %eax,%ebp
  80310c:	31 d2                	xor    %edx,%edx
  80310e:	89 c8                	mov    %ecx,%eax
  803110:	f7 f5                	div    %ebp
  803112:	89 c1                	mov    %eax,%ecx
  803114:	89 d8                	mov    %ebx,%eax
  803116:	f7 f5                	div    %ebp
  803118:	89 cf                	mov    %ecx,%edi
  80311a:	89 fa                	mov    %edi,%edx
  80311c:	83 c4 1c             	add    $0x1c,%esp
  80311f:	5b                   	pop    %ebx
  803120:	5e                   	pop    %esi
  803121:	5f                   	pop    %edi
  803122:	5d                   	pop    %ebp
  803123:	c3                   	ret    
  803124:	39 ce                	cmp    %ecx,%esi
  803126:	77 28                	ja     803150 <__udivdi3+0x7c>
  803128:	0f bd fe             	bsr    %esi,%edi
  80312b:	83 f7 1f             	xor    $0x1f,%edi
  80312e:	75 40                	jne    803170 <__udivdi3+0x9c>
  803130:	39 ce                	cmp    %ecx,%esi
  803132:	72 0a                	jb     80313e <__udivdi3+0x6a>
  803134:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803138:	0f 87 9e 00 00 00    	ja     8031dc <__udivdi3+0x108>
  80313e:	b8 01 00 00 00       	mov    $0x1,%eax
  803143:	89 fa                	mov    %edi,%edx
  803145:	83 c4 1c             	add    $0x1c,%esp
  803148:	5b                   	pop    %ebx
  803149:	5e                   	pop    %esi
  80314a:	5f                   	pop    %edi
  80314b:	5d                   	pop    %ebp
  80314c:	c3                   	ret    
  80314d:	8d 76 00             	lea    0x0(%esi),%esi
  803150:	31 ff                	xor    %edi,%edi
  803152:	31 c0                	xor    %eax,%eax
  803154:	89 fa                	mov    %edi,%edx
  803156:	83 c4 1c             	add    $0x1c,%esp
  803159:	5b                   	pop    %ebx
  80315a:	5e                   	pop    %esi
  80315b:	5f                   	pop    %edi
  80315c:	5d                   	pop    %ebp
  80315d:	c3                   	ret    
  80315e:	66 90                	xchg   %ax,%ax
  803160:	89 d8                	mov    %ebx,%eax
  803162:	f7 f7                	div    %edi
  803164:	31 ff                	xor    %edi,%edi
  803166:	89 fa                	mov    %edi,%edx
  803168:	83 c4 1c             	add    $0x1c,%esp
  80316b:	5b                   	pop    %ebx
  80316c:	5e                   	pop    %esi
  80316d:	5f                   	pop    %edi
  80316e:	5d                   	pop    %ebp
  80316f:	c3                   	ret    
  803170:	bd 20 00 00 00       	mov    $0x20,%ebp
  803175:	89 eb                	mov    %ebp,%ebx
  803177:	29 fb                	sub    %edi,%ebx
  803179:	89 f9                	mov    %edi,%ecx
  80317b:	d3 e6                	shl    %cl,%esi
  80317d:	89 c5                	mov    %eax,%ebp
  80317f:	88 d9                	mov    %bl,%cl
  803181:	d3 ed                	shr    %cl,%ebp
  803183:	89 e9                	mov    %ebp,%ecx
  803185:	09 f1                	or     %esi,%ecx
  803187:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80318b:	89 f9                	mov    %edi,%ecx
  80318d:	d3 e0                	shl    %cl,%eax
  80318f:	89 c5                	mov    %eax,%ebp
  803191:	89 d6                	mov    %edx,%esi
  803193:	88 d9                	mov    %bl,%cl
  803195:	d3 ee                	shr    %cl,%esi
  803197:	89 f9                	mov    %edi,%ecx
  803199:	d3 e2                	shl    %cl,%edx
  80319b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80319f:	88 d9                	mov    %bl,%cl
  8031a1:	d3 e8                	shr    %cl,%eax
  8031a3:	09 c2                	or     %eax,%edx
  8031a5:	89 d0                	mov    %edx,%eax
  8031a7:	89 f2                	mov    %esi,%edx
  8031a9:	f7 74 24 0c          	divl   0xc(%esp)
  8031ad:	89 d6                	mov    %edx,%esi
  8031af:	89 c3                	mov    %eax,%ebx
  8031b1:	f7 e5                	mul    %ebp
  8031b3:	39 d6                	cmp    %edx,%esi
  8031b5:	72 19                	jb     8031d0 <__udivdi3+0xfc>
  8031b7:	74 0b                	je     8031c4 <__udivdi3+0xf0>
  8031b9:	89 d8                	mov    %ebx,%eax
  8031bb:	31 ff                	xor    %edi,%edi
  8031bd:	e9 58 ff ff ff       	jmp    80311a <__udivdi3+0x46>
  8031c2:	66 90                	xchg   %ax,%ax
  8031c4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8031c8:	89 f9                	mov    %edi,%ecx
  8031ca:	d3 e2                	shl    %cl,%edx
  8031cc:	39 c2                	cmp    %eax,%edx
  8031ce:	73 e9                	jae    8031b9 <__udivdi3+0xe5>
  8031d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8031d3:	31 ff                	xor    %edi,%edi
  8031d5:	e9 40 ff ff ff       	jmp    80311a <__udivdi3+0x46>
  8031da:	66 90                	xchg   %ax,%ax
  8031dc:	31 c0                	xor    %eax,%eax
  8031de:	e9 37 ff ff ff       	jmp    80311a <__udivdi3+0x46>
  8031e3:	90                   	nop

008031e4 <__umoddi3>:
  8031e4:	55                   	push   %ebp
  8031e5:	57                   	push   %edi
  8031e6:	56                   	push   %esi
  8031e7:	53                   	push   %ebx
  8031e8:	83 ec 1c             	sub    $0x1c,%esp
  8031eb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8031ef:	8b 74 24 34          	mov    0x34(%esp),%esi
  8031f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8031f7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8031fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8031ff:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803203:	89 f3                	mov    %esi,%ebx
  803205:	89 fa                	mov    %edi,%edx
  803207:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80320b:	89 34 24             	mov    %esi,(%esp)
  80320e:	85 c0                	test   %eax,%eax
  803210:	75 1a                	jne    80322c <__umoddi3+0x48>
  803212:	39 f7                	cmp    %esi,%edi
  803214:	0f 86 a2 00 00 00    	jbe    8032bc <__umoddi3+0xd8>
  80321a:	89 c8                	mov    %ecx,%eax
  80321c:	89 f2                	mov    %esi,%edx
  80321e:	f7 f7                	div    %edi
  803220:	89 d0                	mov    %edx,%eax
  803222:	31 d2                	xor    %edx,%edx
  803224:	83 c4 1c             	add    $0x1c,%esp
  803227:	5b                   	pop    %ebx
  803228:	5e                   	pop    %esi
  803229:	5f                   	pop    %edi
  80322a:	5d                   	pop    %ebp
  80322b:	c3                   	ret    
  80322c:	39 f0                	cmp    %esi,%eax
  80322e:	0f 87 ac 00 00 00    	ja     8032e0 <__umoddi3+0xfc>
  803234:	0f bd e8             	bsr    %eax,%ebp
  803237:	83 f5 1f             	xor    $0x1f,%ebp
  80323a:	0f 84 ac 00 00 00    	je     8032ec <__umoddi3+0x108>
  803240:	bf 20 00 00 00       	mov    $0x20,%edi
  803245:	29 ef                	sub    %ebp,%edi
  803247:	89 fe                	mov    %edi,%esi
  803249:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80324d:	89 e9                	mov    %ebp,%ecx
  80324f:	d3 e0                	shl    %cl,%eax
  803251:	89 d7                	mov    %edx,%edi
  803253:	89 f1                	mov    %esi,%ecx
  803255:	d3 ef                	shr    %cl,%edi
  803257:	09 c7                	or     %eax,%edi
  803259:	89 e9                	mov    %ebp,%ecx
  80325b:	d3 e2                	shl    %cl,%edx
  80325d:	89 14 24             	mov    %edx,(%esp)
  803260:	89 d8                	mov    %ebx,%eax
  803262:	d3 e0                	shl    %cl,%eax
  803264:	89 c2                	mov    %eax,%edx
  803266:	8b 44 24 08          	mov    0x8(%esp),%eax
  80326a:	d3 e0                	shl    %cl,%eax
  80326c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803270:	8b 44 24 08          	mov    0x8(%esp),%eax
  803274:	89 f1                	mov    %esi,%ecx
  803276:	d3 e8                	shr    %cl,%eax
  803278:	09 d0                	or     %edx,%eax
  80327a:	d3 eb                	shr    %cl,%ebx
  80327c:	89 da                	mov    %ebx,%edx
  80327e:	f7 f7                	div    %edi
  803280:	89 d3                	mov    %edx,%ebx
  803282:	f7 24 24             	mull   (%esp)
  803285:	89 c6                	mov    %eax,%esi
  803287:	89 d1                	mov    %edx,%ecx
  803289:	39 d3                	cmp    %edx,%ebx
  80328b:	0f 82 87 00 00 00    	jb     803318 <__umoddi3+0x134>
  803291:	0f 84 91 00 00 00    	je     803328 <__umoddi3+0x144>
  803297:	8b 54 24 04          	mov    0x4(%esp),%edx
  80329b:	29 f2                	sub    %esi,%edx
  80329d:	19 cb                	sbb    %ecx,%ebx
  80329f:	89 d8                	mov    %ebx,%eax
  8032a1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8032a5:	d3 e0                	shl    %cl,%eax
  8032a7:	89 e9                	mov    %ebp,%ecx
  8032a9:	d3 ea                	shr    %cl,%edx
  8032ab:	09 d0                	or     %edx,%eax
  8032ad:	89 e9                	mov    %ebp,%ecx
  8032af:	d3 eb                	shr    %cl,%ebx
  8032b1:	89 da                	mov    %ebx,%edx
  8032b3:	83 c4 1c             	add    $0x1c,%esp
  8032b6:	5b                   	pop    %ebx
  8032b7:	5e                   	pop    %esi
  8032b8:	5f                   	pop    %edi
  8032b9:	5d                   	pop    %ebp
  8032ba:	c3                   	ret    
  8032bb:	90                   	nop
  8032bc:	89 fd                	mov    %edi,%ebp
  8032be:	85 ff                	test   %edi,%edi
  8032c0:	75 0b                	jne    8032cd <__umoddi3+0xe9>
  8032c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8032c7:	31 d2                	xor    %edx,%edx
  8032c9:	f7 f7                	div    %edi
  8032cb:	89 c5                	mov    %eax,%ebp
  8032cd:	89 f0                	mov    %esi,%eax
  8032cf:	31 d2                	xor    %edx,%edx
  8032d1:	f7 f5                	div    %ebp
  8032d3:	89 c8                	mov    %ecx,%eax
  8032d5:	f7 f5                	div    %ebp
  8032d7:	89 d0                	mov    %edx,%eax
  8032d9:	e9 44 ff ff ff       	jmp    803222 <__umoddi3+0x3e>
  8032de:	66 90                	xchg   %ax,%ax
  8032e0:	89 c8                	mov    %ecx,%eax
  8032e2:	89 f2                	mov    %esi,%edx
  8032e4:	83 c4 1c             	add    $0x1c,%esp
  8032e7:	5b                   	pop    %ebx
  8032e8:	5e                   	pop    %esi
  8032e9:	5f                   	pop    %edi
  8032ea:	5d                   	pop    %ebp
  8032eb:	c3                   	ret    
  8032ec:	3b 04 24             	cmp    (%esp),%eax
  8032ef:	72 06                	jb     8032f7 <__umoddi3+0x113>
  8032f1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8032f5:	77 0f                	ja     803306 <__umoddi3+0x122>
  8032f7:	89 f2                	mov    %esi,%edx
  8032f9:	29 f9                	sub    %edi,%ecx
  8032fb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8032ff:	89 14 24             	mov    %edx,(%esp)
  803302:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803306:	8b 44 24 04          	mov    0x4(%esp),%eax
  80330a:	8b 14 24             	mov    (%esp),%edx
  80330d:	83 c4 1c             	add    $0x1c,%esp
  803310:	5b                   	pop    %ebx
  803311:	5e                   	pop    %esi
  803312:	5f                   	pop    %edi
  803313:	5d                   	pop    %ebp
  803314:	c3                   	ret    
  803315:	8d 76 00             	lea    0x0(%esi),%esi
  803318:	2b 04 24             	sub    (%esp),%eax
  80331b:	19 fa                	sbb    %edi,%edx
  80331d:	89 d1                	mov    %edx,%ecx
  80331f:	89 c6                	mov    %eax,%esi
  803321:	e9 71 ff ff ff       	jmp    803297 <__umoddi3+0xb3>
  803326:	66 90                	xchg   %ax,%ax
  803328:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80332c:	72 ea                	jb     803318 <__umoddi3+0x134>
  80332e:	89 d9                	mov    %ebx,%ecx
  803330:	e9 62 ff ff ff       	jmp    803297 <__umoddi3+0xb3>
