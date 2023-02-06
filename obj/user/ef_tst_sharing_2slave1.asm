
obj/user/ef_tst_sharing_2slave1:     file format elf32-i386


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
  800031:	e8 1e 02 00 00       	call   800254 <libmain>
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
  80008d:	68 20 33 80 00       	push   $0x803320
  800092:	6a 13                	push   $0x13
  800094:	68 3c 33 80 00       	push   $0x80333c
  800099:	e8 f2 02 00 00       	call   800390 <_panic>
	}
	uint32 *x,*y,*z;
	int32 parentenvID = sys_getparentenvid();
  80009e:	e8 52 1c 00 00       	call   801cf5 <sys_getparentenvid>
  8000a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//GET: z then y then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	sys_disable_interrupt();
  8000a6:	e8 3e 1a 00 00       	call   801ae9 <sys_disable_interrupt>
	int freeFrames = sys_calculate_free_frames() ;
  8000ab:	e8 4c 19 00 00       	call   8019fc <sys_calculate_free_frames>
  8000b0:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = sget(parentenvID,"z");
  8000b3:	83 ec 08             	sub    $0x8,%esp
  8000b6:	68 5a 33 80 00       	push   $0x80335a
  8000bb:	ff 75 ec             	pushl  -0x14(%ebp)
  8000be:	e8 14 17 00 00       	call   8017d7 <sget>
  8000c3:	83 c4 10             	add    $0x10,%esp
  8000c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 0 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000c9:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000d0:	74 14                	je     8000e6 <_main+0xae>
  8000d2:	83 ec 04             	sub    $0x4,%esp
  8000d5:	68 5c 33 80 00       	push   $0x80335c
  8000da:	6a 1c                	push   $0x1c
  8000dc:	68 3c 33 80 00       	push   $0x80333c
  8000e1:	e8 aa 02 00 00       	call   800390 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8000e6:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000e9:	e8 0e 19 00 00       	call   8019fc <sys_calculate_free_frames>
  8000ee:	29 c3                	sub    %eax,%ebx
  8000f0:	89 d8                	mov    %ebx,%eax
  8000f2:	83 f8 01             	cmp    $0x1,%eax
  8000f5:	74 14                	je     80010b <_main+0xd3>
  8000f7:	83 ec 04             	sub    $0x4,%esp
  8000fa:	68 bc 33 80 00       	push   $0x8033bc
  8000ff:	6a 1d                	push   $0x1d
  800101:	68 3c 33 80 00       	push   $0x80333c
  800106:	e8 85 02 00 00       	call   800390 <_panic>
	sys_enable_interrupt();
  80010b:	e8 f3 19 00 00       	call   801b03 <sys_enable_interrupt>

	sys_disable_interrupt();
  800110:	e8 d4 19 00 00       	call   801ae9 <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  800115:	e8 e2 18 00 00       	call   8019fc <sys_calculate_free_frames>
  80011a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	y = sget(parentenvID,"y");
  80011d:	83 ec 08             	sub    $0x8,%esp
  800120:	68 4d 34 80 00       	push   $0x80344d
  800125:	ff 75 ec             	pushl  -0x14(%ebp)
  800128:	e8 aa 16 00 00       	call   8017d7 <sget>
  80012d:	83 c4 10             	add    $0x10,%esp
  800130:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800133:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  80013a:	74 14                	je     800150 <_main+0x118>
  80013c:	83 ec 04             	sub    $0x4,%esp
  80013f:	68 5c 33 80 00       	push   $0x80335c
  800144:	6a 23                	push   $0x23
  800146:	68 3c 33 80 00       	push   $0x80333c
  80014b:	e8 40 02 00 00       	call   800390 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  800150:	e8 a7 18 00 00       	call   8019fc <sys_calculate_free_frames>
  800155:	89 c2                	mov    %eax,%edx
  800157:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80015a:	39 c2                	cmp    %eax,%edx
  80015c:	74 14                	je     800172 <_main+0x13a>
  80015e:	83 ec 04             	sub    $0x4,%esp
  800161:	68 bc 33 80 00       	push   $0x8033bc
  800166:	6a 24                	push   $0x24
  800168:	68 3c 33 80 00       	push   $0x80333c
  80016d:	e8 1e 02 00 00       	call   800390 <_panic>
	sys_enable_interrupt();
  800172:	e8 8c 19 00 00       	call   801b03 <sys_enable_interrupt>
	
	if (*y != 20) panic("Get(): Shared Variable is not created or got correctly") ;
  800177:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80017a:	8b 00                	mov    (%eax),%eax
  80017c:	83 f8 14             	cmp    $0x14,%eax
  80017f:	74 14                	je     800195 <_main+0x15d>
  800181:	83 ec 04             	sub    $0x4,%esp
  800184:	68 50 34 80 00       	push   $0x803450
  800189:	6a 27                	push   $0x27
  80018b:	68 3c 33 80 00       	push   $0x80333c
  800190:	e8 fb 01 00 00       	call   800390 <_panic>

	sys_disable_interrupt();
  800195:	e8 4f 19 00 00       	call   801ae9 <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  80019a:	e8 5d 18 00 00       	call   8019fc <sys_calculate_free_frames>
  80019f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = sget(parentenvID,"x");
  8001a2:	83 ec 08             	sub    $0x8,%esp
  8001a5:	68 87 34 80 00       	push   $0x803487
  8001aa:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ad:	e8 25 16 00 00       	call   8017d7 <sget>
  8001b2:	83 c4 10             	add    $0x10,%esp
  8001b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (x != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8001b8:	81 7d dc 00 20 00 80 	cmpl   $0x80002000,-0x24(%ebp)
  8001bf:	74 14                	je     8001d5 <_main+0x19d>
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 5c 33 80 00       	push   $0x80335c
  8001c9:	6a 2c                	push   $0x2c
  8001cb:	68 3c 33 80 00       	push   $0x80333c
  8001d0:	e8 bb 01 00 00       	call   800390 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8001d5:	e8 22 18 00 00       	call   8019fc <sys_calculate_free_frames>
  8001da:	89 c2                	mov    %eax,%edx
  8001dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001df:	39 c2                	cmp    %eax,%edx
  8001e1:	74 14                	je     8001f7 <_main+0x1bf>
  8001e3:	83 ec 04             	sub    $0x4,%esp
  8001e6:	68 bc 33 80 00       	push   $0x8033bc
  8001eb:	6a 2d                	push   $0x2d
  8001ed:	68 3c 33 80 00       	push   $0x80333c
  8001f2:	e8 99 01 00 00       	call   800390 <_panic>
	sys_enable_interrupt();
  8001f7:	e8 07 19 00 00       	call   801b03 <sys_enable_interrupt>

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  8001fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001ff:	8b 00                	mov    (%eax),%eax
  800201:	83 f8 0a             	cmp    $0xa,%eax
  800204:	74 14                	je     80021a <_main+0x1e2>
  800206:	83 ec 04             	sub    $0x4,%esp
  800209:	68 50 34 80 00       	push   $0x803450
  80020e:	6a 30                	push   $0x30
  800210:	68 3c 33 80 00       	push   $0x80333c
  800215:	e8 76 01 00 00       	call   800390 <_panic>

	*z = *x + *y ;
  80021a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80021d:	8b 10                	mov    (%eax),%edx
  80021f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800222:	8b 00                	mov    (%eax),%eax
  800224:	01 c2                	add    %eax,%edx
  800226:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800229:	89 10                	mov    %edx,(%eax)
	if (*z != 30) panic("Get(): Shared Variable is not created or got correctly") ;
  80022b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80022e:	8b 00                	mov    (%eax),%eax
  800230:	83 f8 1e             	cmp    $0x1e,%eax
  800233:	74 14                	je     800249 <_main+0x211>
  800235:	83 ec 04             	sub    $0x4,%esp
  800238:	68 50 34 80 00       	push   $0x803450
  80023d:	6a 33                	push   $0x33
  80023f:	68 3c 33 80 00       	push   $0x80333c
  800244:	e8 47 01 00 00       	call   800390 <_panic>

	//To indicate that it's completed successfully
	inctst();
  800249:	e8 cc 1b 00 00       	call   801e1a <inctst>

	return;
  80024e:	90                   	nop
}
  80024f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800252:	c9                   	leave  
  800253:	c3                   	ret    

00800254 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800254:	55                   	push   %ebp
  800255:	89 e5                	mov    %esp,%ebp
  800257:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80025a:	e8 7d 1a 00 00       	call   801cdc <sys_getenvindex>
  80025f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800262:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800265:	89 d0                	mov    %edx,%eax
  800267:	c1 e0 03             	shl    $0x3,%eax
  80026a:	01 d0                	add    %edx,%eax
  80026c:	01 c0                	add    %eax,%eax
  80026e:	01 d0                	add    %edx,%eax
  800270:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800277:	01 d0                	add    %edx,%eax
  800279:	c1 e0 04             	shl    $0x4,%eax
  80027c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800281:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800286:	a1 20 40 80 00       	mov    0x804020,%eax
  80028b:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800291:	84 c0                	test   %al,%al
  800293:	74 0f                	je     8002a4 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800295:	a1 20 40 80 00       	mov    0x804020,%eax
  80029a:	05 5c 05 00 00       	add    $0x55c,%eax
  80029f:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002a8:	7e 0a                	jle    8002b4 <libmain+0x60>
		binaryname = argv[0];
  8002aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ad:	8b 00                	mov    (%eax),%eax
  8002af:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8002b4:	83 ec 08             	sub    $0x8,%esp
  8002b7:	ff 75 0c             	pushl  0xc(%ebp)
  8002ba:	ff 75 08             	pushl  0x8(%ebp)
  8002bd:	e8 76 fd ff ff       	call   800038 <_main>
  8002c2:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8002c5:	e8 1f 18 00 00       	call   801ae9 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002ca:	83 ec 0c             	sub    $0xc,%esp
  8002cd:	68 a4 34 80 00       	push   $0x8034a4
  8002d2:	e8 6d 03 00 00       	call   800644 <cprintf>
  8002d7:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002da:	a1 20 40 80 00       	mov    0x804020,%eax
  8002df:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8002e5:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ea:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8002f0:	83 ec 04             	sub    $0x4,%esp
  8002f3:	52                   	push   %edx
  8002f4:	50                   	push   %eax
  8002f5:	68 cc 34 80 00       	push   $0x8034cc
  8002fa:	e8 45 03 00 00       	call   800644 <cprintf>
  8002ff:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800302:	a1 20 40 80 00       	mov    0x804020,%eax
  800307:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80030d:	a1 20 40 80 00       	mov    0x804020,%eax
  800312:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800318:	a1 20 40 80 00       	mov    0x804020,%eax
  80031d:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800323:	51                   	push   %ecx
  800324:	52                   	push   %edx
  800325:	50                   	push   %eax
  800326:	68 f4 34 80 00       	push   $0x8034f4
  80032b:	e8 14 03 00 00       	call   800644 <cprintf>
  800330:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800333:	a1 20 40 80 00       	mov    0x804020,%eax
  800338:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80033e:	83 ec 08             	sub    $0x8,%esp
  800341:	50                   	push   %eax
  800342:	68 4c 35 80 00       	push   $0x80354c
  800347:	e8 f8 02 00 00       	call   800644 <cprintf>
  80034c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80034f:	83 ec 0c             	sub    $0xc,%esp
  800352:	68 a4 34 80 00       	push   $0x8034a4
  800357:	e8 e8 02 00 00       	call   800644 <cprintf>
  80035c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80035f:	e8 9f 17 00 00       	call   801b03 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800364:	e8 19 00 00 00       	call   800382 <exit>
}
  800369:	90                   	nop
  80036a:	c9                   	leave  
  80036b:	c3                   	ret    

0080036c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80036c:	55                   	push   %ebp
  80036d:	89 e5                	mov    %esp,%ebp
  80036f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800372:	83 ec 0c             	sub    $0xc,%esp
  800375:	6a 00                	push   $0x0
  800377:	e8 2c 19 00 00       	call   801ca8 <sys_destroy_env>
  80037c:	83 c4 10             	add    $0x10,%esp
}
  80037f:	90                   	nop
  800380:	c9                   	leave  
  800381:	c3                   	ret    

00800382 <exit>:

void
exit(void)
{
  800382:	55                   	push   %ebp
  800383:	89 e5                	mov    %esp,%ebp
  800385:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800388:	e8 81 19 00 00       	call   801d0e <sys_exit_env>
}
  80038d:	90                   	nop
  80038e:	c9                   	leave  
  80038f:	c3                   	ret    

00800390 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800390:	55                   	push   %ebp
  800391:	89 e5                	mov    %esp,%ebp
  800393:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800396:	8d 45 10             	lea    0x10(%ebp),%eax
  800399:	83 c0 04             	add    $0x4,%eax
  80039c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80039f:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8003a4:	85 c0                	test   %eax,%eax
  8003a6:	74 16                	je     8003be <_panic+0x2e>
		cprintf("%s: ", argv0);
  8003a8:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8003ad:	83 ec 08             	sub    $0x8,%esp
  8003b0:	50                   	push   %eax
  8003b1:	68 60 35 80 00       	push   $0x803560
  8003b6:	e8 89 02 00 00       	call   800644 <cprintf>
  8003bb:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003be:	a1 00 40 80 00       	mov    0x804000,%eax
  8003c3:	ff 75 0c             	pushl  0xc(%ebp)
  8003c6:	ff 75 08             	pushl  0x8(%ebp)
  8003c9:	50                   	push   %eax
  8003ca:	68 65 35 80 00       	push   $0x803565
  8003cf:	e8 70 02 00 00       	call   800644 <cprintf>
  8003d4:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8003d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8003da:	83 ec 08             	sub    $0x8,%esp
  8003dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8003e0:	50                   	push   %eax
  8003e1:	e8 f3 01 00 00       	call   8005d9 <vcprintf>
  8003e6:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003e9:	83 ec 08             	sub    $0x8,%esp
  8003ec:	6a 00                	push   $0x0
  8003ee:	68 81 35 80 00       	push   $0x803581
  8003f3:	e8 e1 01 00 00       	call   8005d9 <vcprintf>
  8003f8:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003fb:	e8 82 ff ff ff       	call   800382 <exit>

	// should not return here
	while (1) ;
  800400:	eb fe                	jmp    800400 <_panic+0x70>

00800402 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800402:	55                   	push   %ebp
  800403:	89 e5                	mov    %esp,%ebp
  800405:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800408:	a1 20 40 80 00       	mov    0x804020,%eax
  80040d:	8b 50 74             	mov    0x74(%eax),%edx
  800410:	8b 45 0c             	mov    0xc(%ebp),%eax
  800413:	39 c2                	cmp    %eax,%edx
  800415:	74 14                	je     80042b <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800417:	83 ec 04             	sub    $0x4,%esp
  80041a:	68 84 35 80 00       	push   $0x803584
  80041f:	6a 26                	push   $0x26
  800421:	68 d0 35 80 00       	push   $0x8035d0
  800426:	e8 65 ff ff ff       	call   800390 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80042b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800432:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800439:	e9 c2 00 00 00       	jmp    800500 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80043e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800441:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800448:	8b 45 08             	mov    0x8(%ebp),%eax
  80044b:	01 d0                	add    %edx,%eax
  80044d:	8b 00                	mov    (%eax),%eax
  80044f:	85 c0                	test   %eax,%eax
  800451:	75 08                	jne    80045b <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800453:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800456:	e9 a2 00 00 00       	jmp    8004fd <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80045b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800462:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800469:	eb 69                	jmp    8004d4 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80046b:	a1 20 40 80 00       	mov    0x804020,%eax
  800470:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800476:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800479:	89 d0                	mov    %edx,%eax
  80047b:	01 c0                	add    %eax,%eax
  80047d:	01 d0                	add    %edx,%eax
  80047f:	c1 e0 03             	shl    $0x3,%eax
  800482:	01 c8                	add    %ecx,%eax
  800484:	8a 40 04             	mov    0x4(%eax),%al
  800487:	84 c0                	test   %al,%al
  800489:	75 46                	jne    8004d1 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80048b:	a1 20 40 80 00       	mov    0x804020,%eax
  800490:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800496:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800499:	89 d0                	mov    %edx,%eax
  80049b:	01 c0                	add    %eax,%eax
  80049d:	01 d0                	add    %edx,%eax
  80049f:	c1 e0 03             	shl    $0x3,%eax
  8004a2:	01 c8                	add    %ecx,%eax
  8004a4:	8b 00                	mov    (%eax),%eax
  8004a6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004b1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004b6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c0:	01 c8                	add    %ecx,%eax
  8004c2:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004c4:	39 c2                	cmp    %eax,%edx
  8004c6:	75 09                	jne    8004d1 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8004c8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004cf:	eb 12                	jmp    8004e3 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004d1:	ff 45 e8             	incl   -0x18(%ebp)
  8004d4:	a1 20 40 80 00       	mov    0x804020,%eax
  8004d9:	8b 50 74             	mov    0x74(%eax),%edx
  8004dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004df:	39 c2                	cmp    %eax,%edx
  8004e1:	77 88                	ja     80046b <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004e3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004e7:	75 14                	jne    8004fd <CheckWSWithoutLastIndex+0xfb>
			panic(
  8004e9:	83 ec 04             	sub    $0x4,%esp
  8004ec:	68 dc 35 80 00       	push   $0x8035dc
  8004f1:	6a 3a                	push   $0x3a
  8004f3:	68 d0 35 80 00       	push   $0x8035d0
  8004f8:	e8 93 fe ff ff       	call   800390 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004fd:	ff 45 f0             	incl   -0x10(%ebp)
  800500:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800503:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800506:	0f 8c 32 ff ff ff    	jl     80043e <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80050c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800513:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80051a:	eb 26                	jmp    800542 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80051c:	a1 20 40 80 00       	mov    0x804020,%eax
  800521:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800527:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80052a:	89 d0                	mov    %edx,%eax
  80052c:	01 c0                	add    %eax,%eax
  80052e:	01 d0                	add    %edx,%eax
  800530:	c1 e0 03             	shl    $0x3,%eax
  800533:	01 c8                	add    %ecx,%eax
  800535:	8a 40 04             	mov    0x4(%eax),%al
  800538:	3c 01                	cmp    $0x1,%al
  80053a:	75 03                	jne    80053f <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80053c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80053f:	ff 45 e0             	incl   -0x20(%ebp)
  800542:	a1 20 40 80 00       	mov    0x804020,%eax
  800547:	8b 50 74             	mov    0x74(%eax),%edx
  80054a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80054d:	39 c2                	cmp    %eax,%edx
  80054f:	77 cb                	ja     80051c <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800554:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800557:	74 14                	je     80056d <CheckWSWithoutLastIndex+0x16b>
		panic(
  800559:	83 ec 04             	sub    $0x4,%esp
  80055c:	68 30 36 80 00       	push   $0x803630
  800561:	6a 44                	push   $0x44
  800563:	68 d0 35 80 00       	push   $0x8035d0
  800568:	e8 23 fe ff ff       	call   800390 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80056d:	90                   	nop
  80056e:	c9                   	leave  
  80056f:	c3                   	ret    

00800570 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800570:	55                   	push   %ebp
  800571:	89 e5                	mov    %esp,%ebp
  800573:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800576:	8b 45 0c             	mov    0xc(%ebp),%eax
  800579:	8b 00                	mov    (%eax),%eax
  80057b:	8d 48 01             	lea    0x1(%eax),%ecx
  80057e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800581:	89 0a                	mov    %ecx,(%edx)
  800583:	8b 55 08             	mov    0x8(%ebp),%edx
  800586:	88 d1                	mov    %dl,%cl
  800588:	8b 55 0c             	mov    0xc(%ebp),%edx
  80058b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80058f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800592:	8b 00                	mov    (%eax),%eax
  800594:	3d ff 00 00 00       	cmp    $0xff,%eax
  800599:	75 2c                	jne    8005c7 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80059b:	a0 24 40 80 00       	mov    0x804024,%al
  8005a0:	0f b6 c0             	movzbl %al,%eax
  8005a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005a6:	8b 12                	mov    (%edx),%edx
  8005a8:	89 d1                	mov    %edx,%ecx
  8005aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ad:	83 c2 08             	add    $0x8,%edx
  8005b0:	83 ec 04             	sub    $0x4,%esp
  8005b3:	50                   	push   %eax
  8005b4:	51                   	push   %ecx
  8005b5:	52                   	push   %edx
  8005b6:	e8 80 13 00 00       	call   80193b <sys_cputs>
  8005bb:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ca:	8b 40 04             	mov    0x4(%eax),%eax
  8005cd:	8d 50 01             	lea    0x1(%eax),%edx
  8005d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005d6:	90                   	nop
  8005d7:	c9                   	leave  
  8005d8:	c3                   	ret    

008005d9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005d9:	55                   	push   %ebp
  8005da:	89 e5                	mov    %esp,%ebp
  8005dc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005e2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005e9:	00 00 00 
	b.cnt = 0;
  8005ec:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005f3:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005f6:	ff 75 0c             	pushl  0xc(%ebp)
  8005f9:	ff 75 08             	pushl  0x8(%ebp)
  8005fc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800602:	50                   	push   %eax
  800603:	68 70 05 80 00       	push   $0x800570
  800608:	e8 11 02 00 00       	call   80081e <vprintfmt>
  80060d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800610:	a0 24 40 80 00       	mov    0x804024,%al
  800615:	0f b6 c0             	movzbl %al,%eax
  800618:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80061e:	83 ec 04             	sub    $0x4,%esp
  800621:	50                   	push   %eax
  800622:	52                   	push   %edx
  800623:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800629:	83 c0 08             	add    $0x8,%eax
  80062c:	50                   	push   %eax
  80062d:	e8 09 13 00 00       	call   80193b <sys_cputs>
  800632:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800635:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80063c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800642:	c9                   	leave  
  800643:	c3                   	ret    

00800644 <cprintf>:

int cprintf(const char *fmt, ...) {
  800644:	55                   	push   %ebp
  800645:	89 e5                	mov    %esp,%ebp
  800647:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80064a:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800651:	8d 45 0c             	lea    0xc(%ebp),%eax
  800654:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800657:	8b 45 08             	mov    0x8(%ebp),%eax
  80065a:	83 ec 08             	sub    $0x8,%esp
  80065d:	ff 75 f4             	pushl  -0xc(%ebp)
  800660:	50                   	push   %eax
  800661:	e8 73 ff ff ff       	call   8005d9 <vcprintf>
  800666:	83 c4 10             	add    $0x10,%esp
  800669:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80066c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80066f:	c9                   	leave  
  800670:	c3                   	ret    

00800671 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800671:	55                   	push   %ebp
  800672:	89 e5                	mov    %esp,%ebp
  800674:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800677:	e8 6d 14 00 00       	call   801ae9 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80067c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80067f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800682:	8b 45 08             	mov    0x8(%ebp),%eax
  800685:	83 ec 08             	sub    $0x8,%esp
  800688:	ff 75 f4             	pushl  -0xc(%ebp)
  80068b:	50                   	push   %eax
  80068c:	e8 48 ff ff ff       	call   8005d9 <vcprintf>
  800691:	83 c4 10             	add    $0x10,%esp
  800694:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800697:	e8 67 14 00 00       	call   801b03 <sys_enable_interrupt>
	return cnt;
  80069c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80069f:	c9                   	leave  
  8006a0:	c3                   	ret    

008006a1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006a1:	55                   	push   %ebp
  8006a2:	89 e5                	mov    %esp,%ebp
  8006a4:	53                   	push   %ebx
  8006a5:	83 ec 14             	sub    $0x14,%esp
  8006a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8006ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006b4:	8b 45 18             	mov    0x18(%ebp),%eax
  8006b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8006bc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006bf:	77 55                	ja     800716 <printnum+0x75>
  8006c1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006c4:	72 05                	jb     8006cb <printnum+0x2a>
  8006c6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006c9:	77 4b                	ja     800716 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006cb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006ce:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006d1:	8b 45 18             	mov    0x18(%ebp),%eax
  8006d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d9:	52                   	push   %edx
  8006da:	50                   	push   %eax
  8006db:	ff 75 f4             	pushl  -0xc(%ebp)
  8006de:	ff 75 f0             	pushl  -0x10(%ebp)
  8006e1:	e8 ce 29 00 00       	call   8030b4 <__udivdi3>
  8006e6:	83 c4 10             	add    $0x10,%esp
  8006e9:	83 ec 04             	sub    $0x4,%esp
  8006ec:	ff 75 20             	pushl  0x20(%ebp)
  8006ef:	53                   	push   %ebx
  8006f0:	ff 75 18             	pushl  0x18(%ebp)
  8006f3:	52                   	push   %edx
  8006f4:	50                   	push   %eax
  8006f5:	ff 75 0c             	pushl  0xc(%ebp)
  8006f8:	ff 75 08             	pushl  0x8(%ebp)
  8006fb:	e8 a1 ff ff ff       	call   8006a1 <printnum>
  800700:	83 c4 20             	add    $0x20,%esp
  800703:	eb 1a                	jmp    80071f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800705:	83 ec 08             	sub    $0x8,%esp
  800708:	ff 75 0c             	pushl  0xc(%ebp)
  80070b:	ff 75 20             	pushl  0x20(%ebp)
  80070e:	8b 45 08             	mov    0x8(%ebp),%eax
  800711:	ff d0                	call   *%eax
  800713:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800716:	ff 4d 1c             	decl   0x1c(%ebp)
  800719:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80071d:	7f e6                	jg     800705 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80071f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800722:	bb 00 00 00 00       	mov    $0x0,%ebx
  800727:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80072a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80072d:	53                   	push   %ebx
  80072e:	51                   	push   %ecx
  80072f:	52                   	push   %edx
  800730:	50                   	push   %eax
  800731:	e8 8e 2a 00 00       	call   8031c4 <__umoddi3>
  800736:	83 c4 10             	add    $0x10,%esp
  800739:	05 94 38 80 00       	add    $0x803894,%eax
  80073e:	8a 00                	mov    (%eax),%al
  800740:	0f be c0             	movsbl %al,%eax
  800743:	83 ec 08             	sub    $0x8,%esp
  800746:	ff 75 0c             	pushl  0xc(%ebp)
  800749:	50                   	push   %eax
  80074a:	8b 45 08             	mov    0x8(%ebp),%eax
  80074d:	ff d0                	call   *%eax
  80074f:	83 c4 10             	add    $0x10,%esp
}
  800752:	90                   	nop
  800753:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800756:	c9                   	leave  
  800757:	c3                   	ret    

00800758 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800758:	55                   	push   %ebp
  800759:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80075b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80075f:	7e 1c                	jle    80077d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800761:	8b 45 08             	mov    0x8(%ebp),%eax
  800764:	8b 00                	mov    (%eax),%eax
  800766:	8d 50 08             	lea    0x8(%eax),%edx
  800769:	8b 45 08             	mov    0x8(%ebp),%eax
  80076c:	89 10                	mov    %edx,(%eax)
  80076e:	8b 45 08             	mov    0x8(%ebp),%eax
  800771:	8b 00                	mov    (%eax),%eax
  800773:	83 e8 08             	sub    $0x8,%eax
  800776:	8b 50 04             	mov    0x4(%eax),%edx
  800779:	8b 00                	mov    (%eax),%eax
  80077b:	eb 40                	jmp    8007bd <getuint+0x65>
	else if (lflag)
  80077d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800781:	74 1e                	je     8007a1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800783:	8b 45 08             	mov    0x8(%ebp),%eax
  800786:	8b 00                	mov    (%eax),%eax
  800788:	8d 50 04             	lea    0x4(%eax),%edx
  80078b:	8b 45 08             	mov    0x8(%ebp),%eax
  80078e:	89 10                	mov    %edx,(%eax)
  800790:	8b 45 08             	mov    0x8(%ebp),%eax
  800793:	8b 00                	mov    (%eax),%eax
  800795:	83 e8 04             	sub    $0x4,%eax
  800798:	8b 00                	mov    (%eax),%eax
  80079a:	ba 00 00 00 00       	mov    $0x0,%edx
  80079f:	eb 1c                	jmp    8007bd <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a4:	8b 00                	mov    (%eax),%eax
  8007a6:	8d 50 04             	lea    0x4(%eax),%edx
  8007a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ac:	89 10                	mov    %edx,(%eax)
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	8b 00                	mov    (%eax),%eax
  8007b3:	83 e8 04             	sub    $0x4,%eax
  8007b6:	8b 00                	mov    (%eax),%eax
  8007b8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007bd:	5d                   	pop    %ebp
  8007be:	c3                   	ret    

008007bf <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007bf:	55                   	push   %ebp
  8007c0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007c2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007c6:	7e 1c                	jle    8007e4 <getint+0x25>
		return va_arg(*ap, long long);
  8007c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cb:	8b 00                	mov    (%eax),%eax
  8007cd:	8d 50 08             	lea    0x8(%eax),%edx
  8007d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d3:	89 10                	mov    %edx,(%eax)
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	8b 00                	mov    (%eax),%eax
  8007da:	83 e8 08             	sub    $0x8,%eax
  8007dd:	8b 50 04             	mov    0x4(%eax),%edx
  8007e0:	8b 00                	mov    (%eax),%eax
  8007e2:	eb 38                	jmp    80081c <getint+0x5d>
	else if (lflag)
  8007e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007e8:	74 1a                	je     800804 <getint+0x45>
		return va_arg(*ap, long);
  8007ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ed:	8b 00                	mov    (%eax),%eax
  8007ef:	8d 50 04             	lea    0x4(%eax),%edx
  8007f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f5:	89 10                	mov    %edx,(%eax)
  8007f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fa:	8b 00                	mov    (%eax),%eax
  8007fc:	83 e8 04             	sub    $0x4,%eax
  8007ff:	8b 00                	mov    (%eax),%eax
  800801:	99                   	cltd   
  800802:	eb 18                	jmp    80081c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800804:	8b 45 08             	mov    0x8(%ebp),%eax
  800807:	8b 00                	mov    (%eax),%eax
  800809:	8d 50 04             	lea    0x4(%eax),%edx
  80080c:	8b 45 08             	mov    0x8(%ebp),%eax
  80080f:	89 10                	mov    %edx,(%eax)
  800811:	8b 45 08             	mov    0x8(%ebp),%eax
  800814:	8b 00                	mov    (%eax),%eax
  800816:	83 e8 04             	sub    $0x4,%eax
  800819:	8b 00                	mov    (%eax),%eax
  80081b:	99                   	cltd   
}
  80081c:	5d                   	pop    %ebp
  80081d:	c3                   	ret    

0080081e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80081e:	55                   	push   %ebp
  80081f:	89 e5                	mov    %esp,%ebp
  800821:	56                   	push   %esi
  800822:	53                   	push   %ebx
  800823:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800826:	eb 17                	jmp    80083f <vprintfmt+0x21>
			if (ch == '\0')
  800828:	85 db                	test   %ebx,%ebx
  80082a:	0f 84 af 03 00 00    	je     800bdf <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800830:	83 ec 08             	sub    $0x8,%esp
  800833:	ff 75 0c             	pushl  0xc(%ebp)
  800836:	53                   	push   %ebx
  800837:	8b 45 08             	mov    0x8(%ebp),%eax
  80083a:	ff d0                	call   *%eax
  80083c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80083f:	8b 45 10             	mov    0x10(%ebp),%eax
  800842:	8d 50 01             	lea    0x1(%eax),%edx
  800845:	89 55 10             	mov    %edx,0x10(%ebp)
  800848:	8a 00                	mov    (%eax),%al
  80084a:	0f b6 d8             	movzbl %al,%ebx
  80084d:	83 fb 25             	cmp    $0x25,%ebx
  800850:	75 d6                	jne    800828 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800852:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800856:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80085d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800864:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80086b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800872:	8b 45 10             	mov    0x10(%ebp),%eax
  800875:	8d 50 01             	lea    0x1(%eax),%edx
  800878:	89 55 10             	mov    %edx,0x10(%ebp)
  80087b:	8a 00                	mov    (%eax),%al
  80087d:	0f b6 d8             	movzbl %al,%ebx
  800880:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800883:	83 f8 55             	cmp    $0x55,%eax
  800886:	0f 87 2b 03 00 00    	ja     800bb7 <vprintfmt+0x399>
  80088c:	8b 04 85 b8 38 80 00 	mov    0x8038b8(,%eax,4),%eax
  800893:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800895:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800899:	eb d7                	jmp    800872 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80089b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80089f:	eb d1                	jmp    800872 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008a1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008a8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008ab:	89 d0                	mov    %edx,%eax
  8008ad:	c1 e0 02             	shl    $0x2,%eax
  8008b0:	01 d0                	add    %edx,%eax
  8008b2:	01 c0                	add    %eax,%eax
  8008b4:	01 d8                	add    %ebx,%eax
  8008b6:	83 e8 30             	sub    $0x30,%eax
  8008b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8008bf:	8a 00                	mov    (%eax),%al
  8008c1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008c4:	83 fb 2f             	cmp    $0x2f,%ebx
  8008c7:	7e 3e                	jle    800907 <vprintfmt+0xe9>
  8008c9:	83 fb 39             	cmp    $0x39,%ebx
  8008cc:	7f 39                	jg     800907 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008ce:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008d1:	eb d5                	jmp    8008a8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d6:	83 c0 04             	add    $0x4,%eax
  8008d9:	89 45 14             	mov    %eax,0x14(%ebp)
  8008dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008df:	83 e8 04             	sub    $0x4,%eax
  8008e2:	8b 00                	mov    (%eax),%eax
  8008e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008e7:	eb 1f                	jmp    800908 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ed:	79 83                	jns    800872 <vprintfmt+0x54>
				width = 0;
  8008ef:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008f6:	e9 77 ff ff ff       	jmp    800872 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008fb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800902:	e9 6b ff ff ff       	jmp    800872 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800907:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800908:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80090c:	0f 89 60 ff ff ff    	jns    800872 <vprintfmt+0x54>
				width = precision, precision = -1;
  800912:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800915:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800918:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80091f:	e9 4e ff ff ff       	jmp    800872 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800924:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800927:	e9 46 ff ff ff       	jmp    800872 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80092c:	8b 45 14             	mov    0x14(%ebp),%eax
  80092f:	83 c0 04             	add    $0x4,%eax
  800932:	89 45 14             	mov    %eax,0x14(%ebp)
  800935:	8b 45 14             	mov    0x14(%ebp),%eax
  800938:	83 e8 04             	sub    $0x4,%eax
  80093b:	8b 00                	mov    (%eax),%eax
  80093d:	83 ec 08             	sub    $0x8,%esp
  800940:	ff 75 0c             	pushl  0xc(%ebp)
  800943:	50                   	push   %eax
  800944:	8b 45 08             	mov    0x8(%ebp),%eax
  800947:	ff d0                	call   *%eax
  800949:	83 c4 10             	add    $0x10,%esp
			break;
  80094c:	e9 89 02 00 00       	jmp    800bda <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800951:	8b 45 14             	mov    0x14(%ebp),%eax
  800954:	83 c0 04             	add    $0x4,%eax
  800957:	89 45 14             	mov    %eax,0x14(%ebp)
  80095a:	8b 45 14             	mov    0x14(%ebp),%eax
  80095d:	83 e8 04             	sub    $0x4,%eax
  800960:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800962:	85 db                	test   %ebx,%ebx
  800964:	79 02                	jns    800968 <vprintfmt+0x14a>
				err = -err;
  800966:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800968:	83 fb 64             	cmp    $0x64,%ebx
  80096b:	7f 0b                	jg     800978 <vprintfmt+0x15a>
  80096d:	8b 34 9d 00 37 80 00 	mov    0x803700(,%ebx,4),%esi
  800974:	85 f6                	test   %esi,%esi
  800976:	75 19                	jne    800991 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800978:	53                   	push   %ebx
  800979:	68 a5 38 80 00       	push   $0x8038a5
  80097e:	ff 75 0c             	pushl  0xc(%ebp)
  800981:	ff 75 08             	pushl  0x8(%ebp)
  800984:	e8 5e 02 00 00       	call   800be7 <printfmt>
  800989:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80098c:	e9 49 02 00 00       	jmp    800bda <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800991:	56                   	push   %esi
  800992:	68 ae 38 80 00       	push   $0x8038ae
  800997:	ff 75 0c             	pushl  0xc(%ebp)
  80099a:	ff 75 08             	pushl  0x8(%ebp)
  80099d:	e8 45 02 00 00       	call   800be7 <printfmt>
  8009a2:	83 c4 10             	add    $0x10,%esp
			break;
  8009a5:	e9 30 02 00 00       	jmp    800bda <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ad:	83 c0 04             	add    $0x4,%eax
  8009b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8009b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b6:	83 e8 04             	sub    $0x4,%eax
  8009b9:	8b 30                	mov    (%eax),%esi
  8009bb:	85 f6                	test   %esi,%esi
  8009bd:	75 05                	jne    8009c4 <vprintfmt+0x1a6>
				p = "(null)";
  8009bf:	be b1 38 80 00       	mov    $0x8038b1,%esi
			if (width > 0 && padc != '-')
  8009c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009c8:	7e 6d                	jle    800a37 <vprintfmt+0x219>
  8009ca:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009ce:	74 67                	je     800a37 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009d3:	83 ec 08             	sub    $0x8,%esp
  8009d6:	50                   	push   %eax
  8009d7:	56                   	push   %esi
  8009d8:	e8 0c 03 00 00       	call   800ce9 <strnlen>
  8009dd:	83 c4 10             	add    $0x10,%esp
  8009e0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009e3:	eb 16                	jmp    8009fb <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009e5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009e9:	83 ec 08             	sub    $0x8,%esp
  8009ec:	ff 75 0c             	pushl  0xc(%ebp)
  8009ef:	50                   	push   %eax
  8009f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f3:	ff d0                	call   *%eax
  8009f5:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009f8:	ff 4d e4             	decl   -0x1c(%ebp)
  8009fb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ff:	7f e4                	jg     8009e5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a01:	eb 34                	jmp    800a37 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a03:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a07:	74 1c                	je     800a25 <vprintfmt+0x207>
  800a09:	83 fb 1f             	cmp    $0x1f,%ebx
  800a0c:	7e 05                	jle    800a13 <vprintfmt+0x1f5>
  800a0e:	83 fb 7e             	cmp    $0x7e,%ebx
  800a11:	7e 12                	jle    800a25 <vprintfmt+0x207>
					putch('?', putdat);
  800a13:	83 ec 08             	sub    $0x8,%esp
  800a16:	ff 75 0c             	pushl  0xc(%ebp)
  800a19:	6a 3f                	push   $0x3f
  800a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1e:	ff d0                	call   *%eax
  800a20:	83 c4 10             	add    $0x10,%esp
  800a23:	eb 0f                	jmp    800a34 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a25:	83 ec 08             	sub    $0x8,%esp
  800a28:	ff 75 0c             	pushl  0xc(%ebp)
  800a2b:	53                   	push   %ebx
  800a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2f:	ff d0                	call   *%eax
  800a31:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a34:	ff 4d e4             	decl   -0x1c(%ebp)
  800a37:	89 f0                	mov    %esi,%eax
  800a39:	8d 70 01             	lea    0x1(%eax),%esi
  800a3c:	8a 00                	mov    (%eax),%al
  800a3e:	0f be d8             	movsbl %al,%ebx
  800a41:	85 db                	test   %ebx,%ebx
  800a43:	74 24                	je     800a69 <vprintfmt+0x24b>
  800a45:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a49:	78 b8                	js     800a03 <vprintfmt+0x1e5>
  800a4b:	ff 4d e0             	decl   -0x20(%ebp)
  800a4e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a52:	79 af                	jns    800a03 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a54:	eb 13                	jmp    800a69 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a56:	83 ec 08             	sub    $0x8,%esp
  800a59:	ff 75 0c             	pushl  0xc(%ebp)
  800a5c:	6a 20                	push   $0x20
  800a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a61:	ff d0                	call   *%eax
  800a63:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a66:	ff 4d e4             	decl   -0x1c(%ebp)
  800a69:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a6d:	7f e7                	jg     800a56 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a6f:	e9 66 01 00 00       	jmp    800bda <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a74:	83 ec 08             	sub    $0x8,%esp
  800a77:	ff 75 e8             	pushl  -0x18(%ebp)
  800a7a:	8d 45 14             	lea    0x14(%ebp),%eax
  800a7d:	50                   	push   %eax
  800a7e:	e8 3c fd ff ff       	call   8007bf <getint>
  800a83:	83 c4 10             	add    $0x10,%esp
  800a86:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a89:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a92:	85 d2                	test   %edx,%edx
  800a94:	79 23                	jns    800ab9 <vprintfmt+0x29b>
				putch('-', putdat);
  800a96:	83 ec 08             	sub    $0x8,%esp
  800a99:	ff 75 0c             	pushl  0xc(%ebp)
  800a9c:	6a 2d                	push   $0x2d
  800a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa1:	ff d0                	call   *%eax
  800aa3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800aa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aa9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800aac:	f7 d8                	neg    %eax
  800aae:	83 d2 00             	adc    $0x0,%edx
  800ab1:	f7 da                	neg    %edx
  800ab3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ab9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ac0:	e9 bc 00 00 00       	jmp    800b81 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ac5:	83 ec 08             	sub    $0x8,%esp
  800ac8:	ff 75 e8             	pushl  -0x18(%ebp)
  800acb:	8d 45 14             	lea    0x14(%ebp),%eax
  800ace:	50                   	push   %eax
  800acf:	e8 84 fc ff ff       	call   800758 <getuint>
  800ad4:	83 c4 10             	add    $0x10,%esp
  800ad7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ada:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800add:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ae4:	e9 98 00 00 00       	jmp    800b81 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ae9:	83 ec 08             	sub    $0x8,%esp
  800aec:	ff 75 0c             	pushl  0xc(%ebp)
  800aef:	6a 58                	push   $0x58
  800af1:	8b 45 08             	mov    0x8(%ebp),%eax
  800af4:	ff d0                	call   *%eax
  800af6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800af9:	83 ec 08             	sub    $0x8,%esp
  800afc:	ff 75 0c             	pushl  0xc(%ebp)
  800aff:	6a 58                	push   $0x58
  800b01:	8b 45 08             	mov    0x8(%ebp),%eax
  800b04:	ff d0                	call   *%eax
  800b06:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b09:	83 ec 08             	sub    $0x8,%esp
  800b0c:	ff 75 0c             	pushl  0xc(%ebp)
  800b0f:	6a 58                	push   $0x58
  800b11:	8b 45 08             	mov    0x8(%ebp),%eax
  800b14:	ff d0                	call   *%eax
  800b16:	83 c4 10             	add    $0x10,%esp
			break;
  800b19:	e9 bc 00 00 00       	jmp    800bda <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b1e:	83 ec 08             	sub    $0x8,%esp
  800b21:	ff 75 0c             	pushl  0xc(%ebp)
  800b24:	6a 30                	push   $0x30
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	ff d0                	call   *%eax
  800b2b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b2e:	83 ec 08             	sub    $0x8,%esp
  800b31:	ff 75 0c             	pushl  0xc(%ebp)
  800b34:	6a 78                	push   $0x78
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	ff d0                	call   *%eax
  800b3b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b41:	83 c0 04             	add    $0x4,%eax
  800b44:	89 45 14             	mov    %eax,0x14(%ebp)
  800b47:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4a:	83 e8 04             	sub    $0x4,%eax
  800b4d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b52:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b59:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b60:	eb 1f                	jmp    800b81 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b62:	83 ec 08             	sub    $0x8,%esp
  800b65:	ff 75 e8             	pushl  -0x18(%ebp)
  800b68:	8d 45 14             	lea    0x14(%ebp),%eax
  800b6b:	50                   	push   %eax
  800b6c:	e8 e7 fb ff ff       	call   800758 <getuint>
  800b71:	83 c4 10             	add    $0x10,%esp
  800b74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b77:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b7a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b81:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b88:	83 ec 04             	sub    $0x4,%esp
  800b8b:	52                   	push   %edx
  800b8c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b8f:	50                   	push   %eax
  800b90:	ff 75 f4             	pushl  -0xc(%ebp)
  800b93:	ff 75 f0             	pushl  -0x10(%ebp)
  800b96:	ff 75 0c             	pushl  0xc(%ebp)
  800b99:	ff 75 08             	pushl  0x8(%ebp)
  800b9c:	e8 00 fb ff ff       	call   8006a1 <printnum>
  800ba1:	83 c4 20             	add    $0x20,%esp
			break;
  800ba4:	eb 34                	jmp    800bda <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ba6:	83 ec 08             	sub    $0x8,%esp
  800ba9:	ff 75 0c             	pushl  0xc(%ebp)
  800bac:	53                   	push   %ebx
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb0:	ff d0                	call   *%eax
  800bb2:	83 c4 10             	add    $0x10,%esp
			break;
  800bb5:	eb 23                	jmp    800bda <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bb7:	83 ec 08             	sub    $0x8,%esp
  800bba:	ff 75 0c             	pushl  0xc(%ebp)
  800bbd:	6a 25                	push   $0x25
  800bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc2:	ff d0                	call   *%eax
  800bc4:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bc7:	ff 4d 10             	decl   0x10(%ebp)
  800bca:	eb 03                	jmp    800bcf <vprintfmt+0x3b1>
  800bcc:	ff 4d 10             	decl   0x10(%ebp)
  800bcf:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd2:	48                   	dec    %eax
  800bd3:	8a 00                	mov    (%eax),%al
  800bd5:	3c 25                	cmp    $0x25,%al
  800bd7:	75 f3                	jne    800bcc <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800bd9:	90                   	nop
		}
	}
  800bda:	e9 47 fc ff ff       	jmp    800826 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bdf:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800be0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800be3:	5b                   	pop    %ebx
  800be4:	5e                   	pop    %esi
  800be5:	5d                   	pop    %ebp
  800be6:	c3                   	ret    

00800be7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800be7:	55                   	push   %ebp
  800be8:	89 e5                	mov    %esp,%ebp
  800bea:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bed:	8d 45 10             	lea    0x10(%ebp),%eax
  800bf0:	83 c0 04             	add    $0x4,%eax
  800bf3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bf6:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf9:	ff 75 f4             	pushl  -0xc(%ebp)
  800bfc:	50                   	push   %eax
  800bfd:	ff 75 0c             	pushl  0xc(%ebp)
  800c00:	ff 75 08             	pushl  0x8(%ebp)
  800c03:	e8 16 fc ff ff       	call   80081e <vprintfmt>
  800c08:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c0b:	90                   	nop
  800c0c:	c9                   	leave  
  800c0d:	c3                   	ret    

00800c0e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c14:	8b 40 08             	mov    0x8(%eax),%eax
  800c17:	8d 50 01             	lea    0x1(%eax),%edx
  800c1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c23:	8b 10                	mov    (%eax),%edx
  800c25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c28:	8b 40 04             	mov    0x4(%eax),%eax
  800c2b:	39 c2                	cmp    %eax,%edx
  800c2d:	73 12                	jae    800c41 <sprintputch+0x33>
		*b->buf++ = ch;
  800c2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c32:	8b 00                	mov    (%eax),%eax
  800c34:	8d 48 01             	lea    0x1(%eax),%ecx
  800c37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c3a:	89 0a                	mov    %ecx,(%edx)
  800c3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3f:	88 10                	mov    %dl,(%eax)
}
  800c41:	90                   	nop
  800c42:	5d                   	pop    %ebp
  800c43:	c3                   	ret    

00800c44 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c53:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c56:	8b 45 08             	mov    0x8(%ebp),%eax
  800c59:	01 d0                	add    %edx,%eax
  800c5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c65:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c69:	74 06                	je     800c71 <vsnprintf+0x2d>
  800c6b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c6f:	7f 07                	jg     800c78 <vsnprintf+0x34>
		return -E_INVAL;
  800c71:	b8 03 00 00 00       	mov    $0x3,%eax
  800c76:	eb 20                	jmp    800c98 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c78:	ff 75 14             	pushl  0x14(%ebp)
  800c7b:	ff 75 10             	pushl  0x10(%ebp)
  800c7e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c81:	50                   	push   %eax
  800c82:	68 0e 0c 80 00       	push   $0x800c0e
  800c87:	e8 92 fb ff ff       	call   80081e <vprintfmt>
  800c8c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c92:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c98:	c9                   	leave  
  800c99:	c3                   	ret    

00800c9a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c9a:	55                   	push   %ebp
  800c9b:	89 e5                	mov    %esp,%ebp
  800c9d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ca0:	8d 45 10             	lea    0x10(%ebp),%eax
  800ca3:	83 c0 04             	add    $0x4,%eax
  800ca6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ca9:	8b 45 10             	mov    0x10(%ebp),%eax
  800cac:	ff 75 f4             	pushl  -0xc(%ebp)
  800caf:	50                   	push   %eax
  800cb0:	ff 75 0c             	pushl  0xc(%ebp)
  800cb3:	ff 75 08             	pushl  0x8(%ebp)
  800cb6:	e8 89 ff ff ff       	call   800c44 <vsnprintf>
  800cbb:	83 c4 10             	add    $0x10,%esp
  800cbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800cc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cc4:	c9                   	leave  
  800cc5:	c3                   	ret    

00800cc6 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800cc6:	55                   	push   %ebp
  800cc7:	89 e5                	mov    %esp,%ebp
  800cc9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ccc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cd3:	eb 06                	jmp    800cdb <strlen+0x15>
		n++;
  800cd5:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cd8:	ff 45 08             	incl   0x8(%ebp)
  800cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cde:	8a 00                	mov    (%eax),%al
  800ce0:	84 c0                	test   %al,%al
  800ce2:	75 f1                	jne    800cd5 <strlen+0xf>
		n++;
	return n;
  800ce4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ce7:	c9                   	leave  
  800ce8:	c3                   	ret    

00800ce9 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ce9:	55                   	push   %ebp
  800cea:	89 e5                	mov    %esp,%ebp
  800cec:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cf6:	eb 09                	jmp    800d01 <strnlen+0x18>
		n++;
  800cf8:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cfb:	ff 45 08             	incl   0x8(%ebp)
  800cfe:	ff 4d 0c             	decl   0xc(%ebp)
  800d01:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d05:	74 09                	je     800d10 <strnlen+0x27>
  800d07:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0a:	8a 00                	mov    (%eax),%al
  800d0c:	84 c0                	test   %al,%al
  800d0e:	75 e8                	jne    800cf8 <strnlen+0xf>
		n++;
	return n;
  800d10:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d13:	c9                   	leave  
  800d14:	c3                   	ret    

00800d15 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d15:	55                   	push   %ebp
  800d16:	89 e5                	mov    %esp,%ebp
  800d18:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d21:	90                   	nop
  800d22:	8b 45 08             	mov    0x8(%ebp),%eax
  800d25:	8d 50 01             	lea    0x1(%eax),%edx
  800d28:	89 55 08             	mov    %edx,0x8(%ebp)
  800d2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d2e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d31:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d34:	8a 12                	mov    (%edx),%dl
  800d36:	88 10                	mov    %dl,(%eax)
  800d38:	8a 00                	mov    (%eax),%al
  800d3a:	84 c0                	test   %al,%al
  800d3c:	75 e4                	jne    800d22 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d41:	c9                   	leave  
  800d42:	c3                   	ret    

00800d43 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d43:	55                   	push   %ebp
  800d44:	89 e5                	mov    %esp,%ebp
  800d46:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d49:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d4f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d56:	eb 1f                	jmp    800d77 <strncpy+0x34>
		*dst++ = *src;
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	8d 50 01             	lea    0x1(%eax),%edx
  800d5e:	89 55 08             	mov    %edx,0x8(%ebp)
  800d61:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d64:	8a 12                	mov    (%edx),%dl
  800d66:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6b:	8a 00                	mov    (%eax),%al
  800d6d:	84 c0                	test   %al,%al
  800d6f:	74 03                	je     800d74 <strncpy+0x31>
			src++;
  800d71:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d74:	ff 45 fc             	incl   -0x4(%ebp)
  800d77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d7a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d7d:	72 d9                	jb     800d58 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d82:	c9                   	leave  
  800d83:	c3                   	ret    

00800d84 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d84:	55                   	push   %ebp
  800d85:	89 e5                	mov    %esp,%ebp
  800d87:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d90:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d94:	74 30                	je     800dc6 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d96:	eb 16                	jmp    800dae <strlcpy+0x2a>
			*dst++ = *src++;
  800d98:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9b:	8d 50 01             	lea    0x1(%eax),%edx
  800d9e:	89 55 08             	mov    %edx,0x8(%ebp)
  800da1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800da7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800daa:	8a 12                	mov    (%edx),%dl
  800dac:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800dae:	ff 4d 10             	decl   0x10(%ebp)
  800db1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800db5:	74 09                	je     800dc0 <strlcpy+0x3c>
  800db7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dba:	8a 00                	mov    (%eax),%al
  800dbc:	84 c0                	test   %al,%al
  800dbe:	75 d8                	jne    800d98 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800dc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dcc:	29 c2                	sub    %eax,%edx
  800dce:	89 d0                	mov    %edx,%eax
}
  800dd0:	c9                   	leave  
  800dd1:	c3                   	ret    

00800dd2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dd2:	55                   	push   %ebp
  800dd3:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800dd5:	eb 06                	jmp    800ddd <strcmp+0xb>
		p++, q++;
  800dd7:	ff 45 08             	incl   0x8(%ebp)
  800dda:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  800de0:	8a 00                	mov    (%eax),%al
  800de2:	84 c0                	test   %al,%al
  800de4:	74 0e                	je     800df4 <strcmp+0x22>
  800de6:	8b 45 08             	mov    0x8(%ebp),%eax
  800de9:	8a 10                	mov    (%eax),%dl
  800deb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dee:	8a 00                	mov    (%eax),%al
  800df0:	38 c2                	cmp    %al,%dl
  800df2:	74 e3                	je     800dd7 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800df4:	8b 45 08             	mov    0x8(%ebp),%eax
  800df7:	8a 00                	mov    (%eax),%al
  800df9:	0f b6 d0             	movzbl %al,%edx
  800dfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dff:	8a 00                	mov    (%eax),%al
  800e01:	0f b6 c0             	movzbl %al,%eax
  800e04:	29 c2                	sub    %eax,%edx
  800e06:	89 d0                	mov    %edx,%eax
}
  800e08:	5d                   	pop    %ebp
  800e09:	c3                   	ret    

00800e0a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e0d:	eb 09                	jmp    800e18 <strncmp+0xe>
		n--, p++, q++;
  800e0f:	ff 4d 10             	decl   0x10(%ebp)
  800e12:	ff 45 08             	incl   0x8(%ebp)
  800e15:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e18:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e1c:	74 17                	je     800e35 <strncmp+0x2b>
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	8a 00                	mov    (%eax),%al
  800e23:	84 c0                	test   %al,%al
  800e25:	74 0e                	je     800e35 <strncmp+0x2b>
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	8a 10                	mov    (%eax),%dl
  800e2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2f:	8a 00                	mov    (%eax),%al
  800e31:	38 c2                	cmp    %al,%dl
  800e33:	74 da                	je     800e0f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e39:	75 07                	jne    800e42 <strncmp+0x38>
		return 0;
  800e3b:	b8 00 00 00 00       	mov    $0x0,%eax
  800e40:	eb 14                	jmp    800e56 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	8a 00                	mov    (%eax),%al
  800e47:	0f b6 d0             	movzbl %al,%edx
  800e4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4d:	8a 00                	mov    (%eax),%al
  800e4f:	0f b6 c0             	movzbl %al,%eax
  800e52:	29 c2                	sub    %eax,%edx
  800e54:	89 d0                	mov    %edx,%eax
}
  800e56:	5d                   	pop    %ebp
  800e57:	c3                   	ret    

00800e58 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e58:	55                   	push   %ebp
  800e59:	89 e5                	mov    %esp,%ebp
  800e5b:	83 ec 04             	sub    $0x4,%esp
  800e5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e61:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e64:	eb 12                	jmp    800e78 <strchr+0x20>
		if (*s == c)
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	8a 00                	mov    (%eax),%al
  800e6b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e6e:	75 05                	jne    800e75 <strchr+0x1d>
			return (char *) s;
  800e70:	8b 45 08             	mov    0x8(%ebp),%eax
  800e73:	eb 11                	jmp    800e86 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e75:	ff 45 08             	incl   0x8(%ebp)
  800e78:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7b:	8a 00                	mov    (%eax),%al
  800e7d:	84 c0                	test   %al,%al
  800e7f:	75 e5                	jne    800e66 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e86:	c9                   	leave  
  800e87:	c3                   	ret    

00800e88 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e88:	55                   	push   %ebp
  800e89:	89 e5                	mov    %esp,%ebp
  800e8b:	83 ec 04             	sub    $0x4,%esp
  800e8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e91:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e94:	eb 0d                	jmp    800ea3 <strfind+0x1b>
		if (*s == c)
  800e96:	8b 45 08             	mov    0x8(%ebp),%eax
  800e99:	8a 00                	mov    (%eax),%al
  800e9b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e9e:	74 0e                	je     800eae <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ea0:	ff 45 08             	incl   0x8(%ebp)
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	8a 00                	mov    (%eax),%al
  800ea8:	84 c0                	test   %al,%al
  800eaa:	75 ea                	jne    800e96 <strfind+0xe>
  800eac:	eb 01                	jmp    800eaf <strfind+0x27>
		if (*s == c)
			break;
  800eae:	90                   	nop
	return (char *) s;
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eb2:	c9                   	leave  
  800eb3:	c3                   	ret    

00800eb4 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800eb4:	55                   	push   %ebp
  800eb5:	89 e5                	mov    %esp,%ebp
  800eb7:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ec0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ec6:	eb 0e                	jmp    800ed6 <memset+0x22>
		*p++ = c;
  800ec8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ecb:	8d 50 01             	lea    0x1(%eax),%edx
  800ece:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ed1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ed4:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ed6:	ff 4d f8             	decl   -0x8(%ebp)
  800ed9:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800edd:	79 e9                	jns    800ec8 <memset+0x14>
		*p++ = c;

	return v;
  800edf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ee2:	c9                   	leave  
  800ee3:	c3                   	ret    

00800ee4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ee4:	55                   	push   %ebp
  800ee5:	89 e5                	mov    %esp,%ebp
  800ee7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800eea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ef6:	eb 16                	jmp    800f0e <memcpy+0x2a>
		*d++ = *s++;
  800ef8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800efb:	8d 50 01             	lea    0x1(%eax),%edx
  800efe:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f01:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f04:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f07:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f0a:	8a 12                	mov    (%edx),%dl
  800f0c:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f11:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f14:	89 55 10             	mov    %edx,0x10(%ebp)
  800f17:	85 c0                	test   %eax,%eax
  800f19:	75 dd                	jne    800ef8 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f1e:	c9                   	leave  
  800f1f:	c3                   	ret    

00800f20 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f20:	55                   	push   %ebp
  800f21:	89 e5                	mov    %esp,%ebp
  800f23:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f32:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f35:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f38:	73 50                	jae    800f8a <memmove+0x6a>
  800f3a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f3d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f40:	01 d0                	add    %edx,%eax
  800f42:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f45:	76 43                	jbe    800f8a <memmove+0x6a>
		s += n;
  800f47:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f50:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f53:	eb 10                	jmp    800f65 <memmove+0x45>
			*--d = *--s;
  800f55:	ff 4d f8             	decl   -0x8(%ebp)
  800f58:	ff 4d fc             	decl   -0x4(%ebp)
  800f5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f5e:	8a 10                	mov    (%eax),%dl
  800f60:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f63:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f65:	8b 45 10             	mov    0x10(%ebp),%eax
  800f68:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f6b:	89 55 10             	mov    %edx,0x10(%ebp)
  800f6e:	85 c0                	test   %eax,%eax
  800f70:	75 e3                	jne    800f55 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f72:	eb 23                	jmp    800f97 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f74:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f77:	8d 50 01             	lea    0x1(%eax),%edx
  800f7a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f7d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f80:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f83:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f86:	8a 12                	mov    (%edx),%dl
  800f88:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f8a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f90:	89 55 10             	mov    %edx,0x10(%ebp)
  800f93:	85 c0                	test   %eax,%eax
  800f95:	75 dd                	jne    800f74 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f9a:	c9                   	leave  
  800f9b:	c3                   	ret    

00800f9c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
  800f9f:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fab:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fae:	eb 2a                	jmp    800fda <memcmp+0x3e>
		if (*s1 != *s2)
  800fb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb3:	8a 10                	mov    (%eax),%dl
  800fb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	38 c2                	cmp    %al,%dl
  800fbc:	74 16                	je     800fd4 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fbe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc1:	8a 00                	mov    (%eax),%al
  800fc3:	0f b6 d0             	movzbl %al,%edx
  800fc6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc9:	8a 00                	mov    (%eax),%al
  800fcb:	0f b6 c0             	movzbl %al,%eax
  800fce:	29 c2                	sub    %eax,%edx
  800fd0:	89 d0                	mov    %edx,%eax
  800fd2:	eb 18                	jmp    800fec <memcmp+0x50>
		s1++, s2++;
  800fd4:	ff 45 fc             	incl   -0x4(%ebp)
  800fd7:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fda:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fe0:	89 55 10             	mov    %edx,0x10(%ebp)
  800fe3:	85 c0                	test   %eax,%eax
  800fe5:	75 c9                	jne    800fb0 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fe7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fec:	c9                   	leave  
  800fed:	c3                   	ret    

00800fee <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fee:	55                   	push   %ebp
  800fef:	89 e5                	mov    %esp,%ebp
  800ff1:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ff4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff7:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffa:	01 d0                	add    %edx,%eax
  800ffc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fff:	eb 15                	jmp    801016 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801001:	8b 45 08             	mov    0x8(%ebp),%eax
  801004:	8a 00                	mov    (%eax),%al
  801006:	0f b6 d0             	movzbl %al,%edx
  801009:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100c:	0f b6 c0             	movzbl %al,%eax
  80100f:	39 c2                	cmp    %eax,%edx
  801011:	74 0d                	je     801020 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801013:	ff 45 08             	incl   0x8(%ebp)
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
  801019:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80101c:	72 e3                	jb     801001 <memfind+0x13>
  80101e:	eb 01                	jmp    801021 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801020:	90                   	nop
	return (void *) s;
  801021:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801024:	c9                   	leave  
  801025:	c3                   	ret    

00801026 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801026:	55                   	push   %ebp
  801027:	89 e5                	mov    %esp,%ebp
  801029:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80102c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801033:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80103a:	eb 03                	jmp    80103f <strtol+0x19>
		s++;
  80103c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	8a 00                	mov    (%eax),%al
  801044:	3c 20                	cmp    $0x20,%al
  801046:	74 f4                	je     80103c <strtol+0x16>
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
  80104b:	8a 00                	mov    (%eax),%al
  80104d:	3c 09                	cmp    $0x9,%al
  80104f:	74 eb                	je     80103c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801051:	8b 45 08             	mov    0x8(%ebp),%eax
  801054:	8a 00                	mov    (%eax),%al
  801056:	3c 2b                	cmp    $0x2b,%al
  801058:	75 05                	jne    80105f <strtol+0x39>
		s++;
  80105a:	ff 45 08             	incl   0x8(%ebp)
  80105d:	eb 13                	jmp    801072 <strtol+0x4c>
	else if (*s == '-')
  80105f:	8b 45 08             	mov    0x8(%ebp),%eax
  801062:	8a 00                	mov    (%eax),%al
  801064:	3c 2d                	cmp    $0x2d,%al
  801066:	75 0a                	jne    801072 <strtol+0x4c>
		s++, neg = 1;
  801068:	ff 45 08             	incl   0x8(%ebp)
  80106b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801072:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801076:	74 06                	je     80107e <strtol+0x58>
  801078:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80107c:	75 20                	jne    80109e <strtol+0x78>
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	8a 00                	mov    (%eax),%al
  801083:	3c 30                	cmp    $0x30,%al
  801085:	75 17                	jne    80109e <strtol+0x78>
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	40                   	inc    %eax
  80108b:	8a 00                	mov    (%eax),%al
  80108d:	3c 78                	cmp    $0x78,%al
  80108f:	75 0d                	jne    80109e <strtol+0x78>
		s += 2, base = 16;
  801091:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801095:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80109c:	eb 28                	jmp    8010c6 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80109e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010a2:	75 15                	jne    8010b9 <strtol+0x93>
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a7:	8a 00                	mov    (%eax),%al
  8010a9:	3c 30                	cmp    $0x30,%al
  8010ab:	75 0c                	jne    8010b9 <strtol+0x93>
		s++, base = 8;
  8010ad:	ff 45 08             	incl   0x8(%ebp)
  8010b0:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010b7:	eb 0d                	jmp    8010c6 <strtol+0xa0>
	else if (base == 0)
  8010b9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010bd:	75 07                	jne    8010c6 <strtol+0xa0>
		base = 10;
  8010bf:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	8a 00                	mov    (%eax),%al
  8010cb:	3c 2f                	cmp    $0x2f,%al
  8010cd:	7e 19                	jle    8010e8 <strtol+0xc2>
  8010cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d2:	8a 00                	mov    (%eax),%al
  8010d4:	3c 39                	cmp    $0x39,%al
  8010d6:	7f 10                	jg     8010e8 <strtol+0xc2>
			dig = *s - '0';
  8010d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010db:	8a 00                	mov    (%eax),%al
  8010dd:	0f be c0             	movsbl %al,%eax
  8010e0:	83 e8 30             	sub    $0x30,%eax
  8010e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010e6:	eb 42                	jmp    80112a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010eb:	8a 00                	mov    (%eax),%al
  8010ed:	3c 60                	cmp    $0x60,%al
  8010ef:	7e 19                	jle    80110a <strtol+0xe4>
  8010f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f4:	8a 00                	mov    (%eax),%al
  8010f6:	3c 7a                	cmp    $0x7a,%al
  8010f8:	7f 10                	jg     80110a <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fd:	8a 00                	mov    (%eax),%al
  8010ff:	0f be c0             	movsbl %al,%eax
  801102:	83 e8 57             	sub    $0x57,%eax
  801105:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801108:	eb 20                	jmp    80112a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80110a:	8b 45 08             	mov    0x8(%ebp),%eax
  80110d:	8a 00                	mov    (%eax),%al
  80110f:	3c 40                	cmp    $0x40,%al
  801111:	7e 39                	jle    80114c <strtol+0x126>
  801113:	8b 45 08             	mov    0x8(%ebp),%eax
  801116:	8a 00                	mov    (%eax),%al
  801118:	3c 5a                	cmp    $0x5a,%al
  80111a:	7f 30                	jg     80114c <strtol+0x126>
			dig = *s - 'A' + 10;
  80111c:	8b 45 08             	mov    0x8(%ebp),%eax
  80111f:	8a 00                	mov    (%eax),%al
  801121:	0f be c0             	movsbl %al,%eax
  801124:	83 e8 37             	sub    $0x37,%eax
  801127:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80112a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80112d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801130:	7d 19                	jge    80114b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801132:	ff 45 08             	incl   0x8(%ebp)
  801135:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801138:	0f af 45 10          	imul   0x10(%ebp),%eax
  80113c:	89 c2                	mov    %eax,%edx
  80113e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801141:	01 d0                	add    %edx,%eax
  801143:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801146:	e9 7b ff ff ff       	jmp    8010c6 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80114b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80114c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801150:	74 08                	je     80115a <strtol+0x134>
		*endptr = (char *) s;
  801152:	8b 45 0c             	mov    0xc(%ebp),%eax
  801155:	8b 55 08             	mov    0x8(%ebp),%edx
  801158:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80115a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80115e:	74 07                	je     801167 <strtol+0x141>
  801160:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801163:	f7 d8                	neg    %eax
  801165:	eb 03                	jmp    80116a <strtol+0x144>
  801167:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80116a:	c9                   	leave  
  80116b:	c3                   	ret    

0080116c <ltostr>:

void
ltostr(long value, char *str)
{
  80116c:	55                   	push   %ebp
  80116d:	89 e5                	mov    %esp,%ebp
  80116f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801172:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801179:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801180:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801184:	79 13                	jns    801199 <ltostr+0x2d>
	{
		neg = 1;
  801186:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80118d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801190:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801193:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801196:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801199:	8b 45 08             	mov    0x8(%ebp),%eax
  80119c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011a1:	99                   	cltd   
  8011a2:	f7 f9                	idiv   %ecx
  8011a4:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011aa:	8d 50 01             	lea    0x1(%eax),%edx
  8011ad:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011b0:	89 c2                	mov    %eax,%edx
  8011b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b5:	01 d0                	add    %edx,%eax
  8011b7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011ba:	83 c2 30             	add    $0x30,%edx
  8011bd:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011c2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011c7:	f7 e9                	imul   %ecx
  8011c9:	c1 fa 02             	sar    $0x2,%edx
  8011cc:	89 c8                	mov    %ecx,%eax
  8011ce:	c1 f8 1f             	sar    $0x1f,%eax
  8011d1:	29 c2                	sub    %eax,%edx
  8011d3:	89 d0                	mov    %edx,%eax
  8011d5:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011db:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011e0:	f7 e9                	imul   %ecx
  8011e2:	c1 fa 02             	sar    $0x2,%edx
  8011e5:	89 c8                	mov    %ecx,%eax
  8011e7:	c1 f8 1f             	sar    $0x1f,%eax
  8011ea:	29 c2                	sub    %eax,%edx
  8011ec:	89 d0                	mov    %edx,%eax
  8011ee:	c1 e0 02             	shl    $0x2,%eax
  8011f1:	01 d0                	add    %edx,%eax
  8011f3:	01 c0                	add    %eax,%eax
  8011f5:	29 c1                	sub    %eax,%ecx
  8011f7:	89 ca                	mov    %ecx,%edx
  8011f9:	85 d2                	test   %edx,%edx
  8011fb:	75 9c                	jne    801199 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801204:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801207:	48                   	dec    %eax
  801208:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80120b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80120f:	74 3d                	je     80124e <ltostr+0xe2>
		start = 1 ;
  801211:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801218:	eb 34                	jmp    80124e <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80121a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80121d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801220:	01 d0                	add    %edx,%eax
  801222:	8a 00                	mov    (%eax),%al
  801224:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801227:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80122a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122d:	01 c2                	add    %eax,%edx
  80122f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801232:	8b 45 0c             	mov    0xc(%ebp),%eax
  801235:	01 c8                	add    %ecx,%eax
  801237:	8a 00                	mov    (%eax),%al
  801239:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80123b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80123e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801241:	01 c2                	add    %eax,%edx
  801243:	8a 45 eb             	mov    -0x15(%ebp),%al
  801246:	88 02                	mov    %al,(%edx)
		start++ ;
  801248:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80124b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80124e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801251:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801254:	7c c4                	jl     80121a <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801256:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801259:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125c:	01 d0                	add    %edx,%eax
  80125e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801261:	90                   	nop
  801262:	c9                   	leave  
  801263:	c3                   	ret    

00801264 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801264:	55                   	push   %ebp
  801265:	89 e5                	mov    %esp,%ebp
  801267:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80126a:	ff 75 08             	pushl  0x8(%ebp)
  80126d:	e8 54 fa ff ff       	call   800cc6 <strlen>
  801272:	83 c4 04             	add    $0x4,%esp
  801275:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801278:	ff 75 0c             	pushl  0xc(%ebp)
  80127b:	e8 46 fa ff ff       	call   800cc6 <strlen>
  801280:	83 c4 04             	add    $0x4,%esp
  801283:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801286:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80128d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801294:	eb 17                	jmp    8012ad <strcconcat+0x49>
		final[s] = str1[s] ;
  801296:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801299:	8b 45 10             	mov    0x10(%ebp),%eax
  80129c:	01 c2                	add    %eax,%edx
  80129e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a4:	01 c8                	add    %ecx,%eax
  8012a6:	8a 00                	mov    (%eax),%al
  8012a8:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012aa:	ff 45 fc             	incl   -0x4(%ebp)
  8012ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012b0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012b3:	7c e1                	jl     801296 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012b5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012bc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012c3:	eb 1f                	jmp    8012e4 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012c8:	8d 50 01             	lea    0x1(%eax),%edx
  8012cb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012ce:	89 c2                	mov    %eax,%edx
  8012d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d3:	01 c2                	add    %eax,%edx
  8012d5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012db:	01 c8                	add    %ecx,%eax
  8012dd:	8a 00                	mov    (%eax),%al
  8012df:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012e1:	ff 45 f8             	incl   -0x8(%ebp)
  8012e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012ea:	7c d9                	jl     8012c5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012ec:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f2:	01 d0                	add    %edx,%eax
  8012f4:	c6 00 00             	movb   $0x0,(%eax)
}
  8012f7:	90                   	nop
  8012f8:	c9                   	leave  
  8012f9:	c3                   	ret    

008012fa <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012fa:	55                   	push   %ebp
  8012fb:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801300:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801306:	8b 45 14             	mov    0x14(%ebp),%eax
  801309:	8b 00                	mov    (%eax),%eax
  80130b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801312:	8b 45 10             	mov    0x10(%ebp),%eax
  801315:	01 d0                	add    %edx,%eax
  801317:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80131d:	eb 0c                	jmp    80132b <strsplit+0x31>
			*string++ = 0;
  80131f:	8b 45 08             	mov    0x8(%ebp),%eax
  801322:	8d 50 01             	lea    0x1(%eax),%edx
  801325:	89 55 08             	mov    %edx,0x8(%ebp)
  801328:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80132b:	8b 45 08             	mov    0x8(%ebp),%eax
  80132e:	8a 00                	mov    (%eax),%al
  801330:	84 c0                	test   %al,%al
  801332:	74 18                	je     80134c <strsplit+0x52>
  801334:	8b 45 08             	mov    0x8(%ebp),%eax
  801337:	8a 00                	mov    (%eax),%al
  801339:	0f be c0             	movsbl %al,%eax
  80133c:	50                   	push   %eax
  80133d:	ff 75 0c             	pushl  0xc(%ebp)
  801340:	e8 13 fb ff ff       	call   800e58 <strchr>
  801345:	83 c4 08             	add    $0x8,%esp
  801348:	85 c0                	test   %eax,%eax
  80134a:	75 d3                	jne    80131f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80134c:	8b 45 08             	mov    0x8(%ebp),%eax
  80134f:	8a 00                	mov    (%eax),%al
  801351:	84 c0                	test   %al,%al
  801353:	74 5a                	je     8013af <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801355:	8b 45 14             	mov    0x14(%ebp),%eax
  801358:	8b 00                	mov    (%eax),%eax
  80135a:	83 f8 0f             	cmp    $0xf,%eax
  80135d:	75 07                	jne    801366 <strsplit+0x6c>
		{
			return 0;
  80135f:	b8 00 00 00 00       	mov    $0x0,%eax
  801364:	eb 66                	jmp    8013cc <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801366:	8b 45 14             	mov    0x14(%ebp),%eax
  801369:	8b 00                	mov    (%eax),%eax
  80136b:	8d 48 01             	lea    0x1(%eax),%ecx
  80136e:	8b 55 14             	mov    0x14(%ebp),%edx
  801371:	89 0a                	mov    %ecx,(%edx)
  801373:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80137a:	8b 45 10             	mov    0x10(%ebp),%eax
  80137d:	01 c2                	add    %eax,%edx
  80137f:	8b 45 08             	mov    0x8(%ebp),%eax
  801382:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801384:	eb 03                	jmp    801389 <strsplit+0x8f>
			string++;
  801386:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801389:	8b 45 08             	mov    0x8(%ebp),%eax
  80138c:	8a 00                	mov    (%eax),%al
  80138e:	84 c0                	test   %al,%al
  801390:	74 8b                	je     80131d <strsplit+0x23>
  801392:	8b 45 08             	mov    0x8(%ebp),%eax
  801395:	8a 00                	mov    (%eax),%al
  801397:	0f be c0             	movsbl %al,%eax
  80139a:	50                   	push   %eax
  80139b:	ff 75 0c             	pushl  0xc(%ebp)
  80139e:	e8 b5 fa ff ff       	call   800e58 <strchr>
  8013a3:	83 c4 08             	add    $0x8,%esp
  8013a6:	85 c0                	test   %eax,%eax
  8013a8:	74 dc                	je     801386 <strsplit+0x8c>
			string++;
	}
  8013aa:	e9 6e ff ff ff       	jmp    80131d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013af:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8013b3:	8b 00                	mov    (%eax),%eax
  8013b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8013bf:	01 d0                	add    %edx,%eax
  8013c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013c7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013cc:	c9                   	leave  
  8013cd:	c3                   	ret    

008013ce <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8013ce:	55                   	push   %ebp
  8013cf:	89 e5                	mov    %esp,%ebp
  8013d1:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8013d4:	a1 04 40 80 00       	mov    0x804004,%eax
  8013d9:	85 c0                	test   %eax,%eax
  8013db:	74 1f                	je     8013fc <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8013dd:	e8 1d 00 00 00       	call   8013ff <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8013e2:	83 ec 0c             	sub    $0xc,%esp
  8013e5:	68 10 3a 80 00       	push   $0x803a10
  8013ea:	e8 55 f2 ff ff       	call   800644 <cprintf>
  8013ef:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8013f2:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8013f9:	00 00 00 
	}
}
  8013fc:	90                   	nop
  8013fd:	c9                   	leave  
  8013fe:	c3                   	ret    

008013ff <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8013ff:	55                   	push   %ebp
  801400:	89 e5                	mov    %esp,%ebp
  801402:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  801405:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80140c:	00 00 00 
  80140f:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801416:	00 00 00 
  801419:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801420:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  801423:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80142a:	00 00 00 
  80142d:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801434:	00 00 00 
  801437:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80143e:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  801441:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801448:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80144b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801450:	2d 00 10 00 00       	sub    $0x1000,%eax
  801455:	a3 50 40 80 00       	mov    %eax,0x804050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  80145a:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801461:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  801464:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80146b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80146e:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  801473:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801476:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801479:	ba 00 00 00 00       	mov    $0x0,%edx
  80147e:	f7 75 f0             	divl   -0x10(%ebp)
  801481:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801484:	29 d0                	sub    %edx,%eax
  801486:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  801489:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801490:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801493:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801498:	2d 00 10 00 00       	sub    $0x1000,%eax
  80149d:	83 ec 04             	sub    $0x4,%esp
  8014a0:	6a 06                	push   $0x6
  8014a2:	ff 75 e8             	pushl  -0x18(%ebp)
  8014a5:	50                   	push   %eax
  8014a6:	e8 d4 05 00 00       	call   801a7f <sys_allocate_chunk>
  8014ab:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014ae:	a1 20 41 80 00       	mov    0x804120,%eax
  8014b3:	83 ec 0c             	sub    $0xc,%esp
  8014b6:	50                   	push   %eax
  8014b7:	e8 49 0c 00 00       	call   802105 <initialize_MemBlocksList>
  8014bc:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  8014bf:	a1 48 41 80 00       	mov    0x804148,%eax
  8014c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  8014c7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014cb:	75 14                	jne    8014e1 <initialize_dyn_block_system+0xe2>
  8014cd:	83 ec 04             	sub    $0x4,%esp
  8014d0:	68 35 3a 80 00       	push   $0x803a35
  8014d5:	6a 39                	push   $0x39
  8014d7:	68 53 3a 80 00       	push   $0x803a53
  8014dc:	e8 af ee ff ff       	call   800390 <_panic>
  8014e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014e4:	8b 00                	mov    (%eax),%eax
  8014e6:	85 c0                	test   %eax,%eax
  8014e8:	74 10                	je     8014fa <initialize_dyn_block_system+0xfb>
  8014ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014ed:	8b 00                	mov    (%eax),%eax
  8014ef:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014f2:	8b 52 04             	mov    0x4(%edx),%edx
  8014f5:	89 50 04             	mov    %edx,0x4(%eax)
  8014f8:	eb 0b                	jmp    801505 <initialize_dyn_block_system+0x106>
  8014fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014fd:	8b 40 04             	mov    0x4(%eax),%eax
  801500:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801505:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801508:	8b 40 04             	mov    0x4(%eax),%eax
  80150b:	85 c0                	test   %eax,%eax
  80150d:	74 0f                	je     80151e <initialize_dyn_block_system+0x11f>
  80150f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801512:	8b 40 04             	mov    0x4(%eax),%eax
  801515:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801518:	8b 12                	mov    (%edx),%edx
  80151a:	89 10                	mov    %edx,(%eax)
  80151c:	eb 0a                	jmp    801528 <initialize_dyn_block_system+0x129>
  80151e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801521:	8b 00                	mov    (%eax),%eax
  801523:	a3 48 41 80 00       	mov    %eax,0x804148
  801528:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80152b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801531:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801534:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80153b:	a1 54 41 80 00       	mov    0x804154,%eax
  801540:	48                   	dec    %eax
  801541:	a3 54 41 80 00       	mov    %eax,0x804154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  801546:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801549:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  801550:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801553:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  80155a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80155e:	75 14                	jne    801574 <initialize_dyn_block_system+0x175>
  801560:	83 ec 04             	sub    $0x4,%esp
  801563:	68 60 3a 80 00       	push   $0x803a60
  801568:	6a 3f                	push   $0x3f
  80156a:	68 53 3a 80 00       	push   $0x803a53
  80156f:	e8 1c ee ff ff       	call   800390 <_panic>
  801574:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80157a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80157d:	89 10                	mov    %edx,(%eax)
  80157f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801582:	8b 00                	mov    (%eax),%eax
  801584:	85 c0                	test   %eax,%eax
  801586:	74 0d                	je     801595 <initialize_dyn_block_system+0x196>
  801588:	a1 38 41 80 00       	mov    0x804138,%eax
  80158d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801590:	89 50 04             	mov    %edx,0x4(%eax)
  801593:	eb 08                	jmp    80159d <initialize_dyn_block_system+0x19e>
  801595:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801598:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80159d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015a0:	a3 38 41 80 00       	mov    %eax,0x804138
  8015a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015af:	a1 44 41 80 00       	mov    0x804144,%eax
  8015b4:	40                   	inc    %eax
  8015b5:	a3 44 41 80 00       	mov    %eax,0x804144

}
  8015ba:	90                   	nop
  8015bb:	c9                   	leave  
  8015bc:	c3                   	ret    

008015bd <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8015bd:	55                   	push   %ebp
  8015be:	89 e5                	mov    %esp,%ebp
  8015c0:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015c3:	e8 06 fe ff ff       	call   8013ce <InitializeUHeap>
	if (size == 0) return NULL ;
  8015c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015cc:	75 07                	jne    8015d5 <malloc+0x18>
  8015ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d3:	eb 7d                	jmp    801652 <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  8015d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8015dc:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8015e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8015e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e9:	01 d0                	add    %edx,%eax
  8015eb:	48                   	dec    %eax
  8015ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f7:	f7 75 f0             	divl   -0x10(%ebp)
  8015fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015fd:	29 d0                	sub    %edx,%eax
  8015ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  801602:	e8 46 08 00 00       	call   801e4d <sys_isUHeapPlacementStrategyFIRSTFIT>
  801607:	83 f8 01             	cmp    $0x1,%eax
  80160a:	75 07                	jne    801613 <malloc+0x56>
  80160c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  801613:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  801617:	75 34                	jne    80164d <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  801619:	83 ec 0c             	sub    $0xc,%esp
  80161c:	ff 75 e8             	pushl  -0x18(%ebp)
  80161f:	e8 73 0e 00 00       	call   802497 <alloc_block_FF>
  801624:	83 c4 10             	add    $0x10,%esp
  801627:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  80162a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80162e:	74 16                	je     801646 <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  801630:	83 ec 0c             	sub    $0xc,%esp
  801633:	ff 75 e4             	pushl  -0x1c(%ebp)
  801636:	e8 ff 0b 00 00       	call   80223a <insert_sorted_allocList>
  80163b:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  80163e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801641:	8b 40 08             	mov    0x8(%eax),%eax
  801644:	eb 0c                	jmp    801652 <malloc+0x95>
	             }
	             else
	             	return NULL;
  801646:	b8 00 00 00 00       	mov    $0x0,%eax
  80164b:	eb 05                	jmp    801652 <malloc+0x95>
	      	  }
	          else
	               return NULL;
  80164d:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  801652:	c9                   	leave  
  801653:	c3                   	ret    

00801654 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801654:	55                   	push   %ebp
  801655:	89 e5                	mov    %esp,%ebp
  801657:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  80165a:	8b 45 08             	mov    0x8(%ebp),%eax
  80165d:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  801660:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801663:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801666:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801669:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80166e:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  801671:	83 ec 08             	sub    $0x8,%esp
  801674:	ff 75 f4             	pushl  -0xc(%ebp)
  801677:	68 40 40 80 00       	push   $0x804040
  80167c:	e8 61 0b 00 00       	call   8021e2 <find_block>
  801681:	83 c4 10             	add    $0x10,%esp
  801684:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  801687:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80168b:	0f 84 a5 00 00 00    	je     801736 <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  801691:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801694:	8b 40 0c             	mov    0xc(%eax),%eax
  801697:	83 ec 08             	sub    $0x8,%esp
  80169a:	50                   	push   %eax
  80169b:	ff 75 f4             	pushl  -0xc(%ebp)
  80169e:	e8 a4 03 00 00       	call   801a47 <sys_free_user_mem>
  8016a3:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  8016a6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016aa:	75 17                	jne    8016c3 <free+0x6f>
  8016ac:	83 ec 04             	sub    $0x4,%esp
  8016af:	68 35 3a 80 00       	push   $0x803a35
  8016b4:	68 87 00 00 00       	push   $0x87
  8016b9:	68 53 3a 80 00       	push   $0x803a53
  8016be:	e8 cd ec ff ff       	call   800390 <_panic>
  8016c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016c6:	8b 00                	mov    (%eax),%eax
  8016c8:	85 c0                	test   %eax,%eax
  8016ca:	74 10                	je     8016dc <free+0x88>
  8016cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016cf:	8b 00                	mov    (%eax),%eax
  8016d1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016d4:	8b 52 04             	mov    0x4(%edx),%edx
  8016d7:	89 50 04             	mov    %edx,0x4(%eax)
  8016da:	eb 0b                	jmp    8016e7 <free+0x93>
  8016dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016df:	8b 40 04             	mov    0x4(%eax),%eax
  8016e2:	a3 44 40 80 00       	mov    %eax,0x804044
  8016e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016ea:	8b 40 04             	mov    0x4(%eax),%eax
  8016ed:	85 c0                	test   %eax,%eax
  8016ef:	74 0f                	je     801700 <free+0xac>
  8016f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016f4:	8b 40 04             	mov    0x4(%eax),%eax
  8016f7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016fa:	8b 12                	mov    (%edx),%edx
  8016fc:	89 10                	mov    %edx,(%eax)
  8016fe:	eb 0a                	jmp    80170a <free+0xb6>
  801700:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801703:	8b 00                	mov    (%eax),%eax
  801705:	a3 40 40 80 00       	mov    %eax,0x804040
  80170a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80170d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801713:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801716:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80171d:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801722:	48                   	dec    %eax
  801723:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(theBlock);
  801728:	83 ec 0c             	sub    $0xc,%esp
  80172b:	ff 75 ec             	pushl  -0x14(%ebp)
  80172e:	e8 37 12 00 00       	call   80296a <insert_sorted_with_merge_freeList>
  801733:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  801736:	90                   	nop
  801737:	c9                   	leave  
  801738:	c3                   	ret    

00801739 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
  80173c:	83 ec 38             	sub    $0x38,%esp
  80173f:	8b 45 10             	mov    0x10(%ebp),%eax
  801742:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801745:	e8 84 fc ff ff       	call   8013ce <InitializeUHeap>
	if (size == 0) return NULL ;
  80174a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80174e:	75 07                	jne    801757 <smalloc+0x1e>
  801750:	b8 00 00 00 00       	mov    $0x0,%eax
  801755:	eb 7e                	jmp    8017d5 <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  801757:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  80175e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801765:	8b 55 0c             	mov    0xc(%ebp),%edx
  801768:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80176b:	01 d0                	add    %edx,%eax
  80176d:	48                   	dec    %eax
  80176e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801771:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801774:	ba 00 00 00 00       	mov    $0x0,%edx
  801779:	f7 75 f0             	divl   -0x10(%ebp)
  80177c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80177f:	29 d0                	sub    %edx,%eax
  801781:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801784:	e8 c4 06 00 00       	call   801e4d <sys_isUHeapPlacementStrategyFIRSTFIT>
  801789:	83 f8 01             	cmp    $0x1,%eax
  80178c:	75 42                	jne    8017d0 <smalloc+0x97>

		  va = malloc(newsize) ;
  80178e:	83 ec 0c             	sub    $0xc,%esp
  801791:	ff 75 e8             	pushl  -0x18(%ebp)
  801794:	e8 24 fe ff ff       	call   8015bd <malloc>
  801799:	83 c4 10             	add    $0x10,%esp
  80179c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  80179f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8017a3:	74 24                	je     8017c9 <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  8017a5:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8017a9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017ac:	50                   	push   %eax
  8017ad:	ff 75 e8             	pushl  -0x18(%ebp)
  8017b0:	ff 75 08             	pushl  0x8(%ebp)
  8017b3:	e8 1a 04 00 00       	call   801bd2 <sys_createSharedObject>
  8017b8:	83 c4 10             	add    $0x10,%esp
  8017bb:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  8017be:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8017c2:	78 0c                	js     8017d0 <smalloc+0x97>
					  return va ;
  8017c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017c7:	eb 0c                	jmp    8017d5 <smalloc+0x9c>
				 }
				 else
					return NULL;
  8017c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ce:	eb 05                	jmp    8017d5 <smalloc+0x9c>
	  }
		  return NULL ;
  8017d0:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8017d5:	c9                   	leave  
  8017d6:	c3                   	ret    

008017d7 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017d7:	55                   	push   %ebp
  8017d8:	89 e5                	mov    %esp,%ebp
  8017da:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017dd:	e8 ec fb ff ff       	call   8013ce <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  8017e2:	83 ec 08             	sub    $0x8,%esp
  8017e5:	ff 75 0c             	pushl  0xc(%ebp)
  8017e8:	ff 75 08             	pushl  0x8(%ebp)
  8017eb:	e8 0c 04 00 00       	call   801bfc <sys_getSizeOfSharedObject>
  8017f0:	83 c4 10             	add    $0x10,%esp
  8017f3:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  8017f6:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8017fa:	75 07                	jne    801803 <sget+0x2c>
  8017fc:	b8 00 00 00 00       	mov    $0x0,%eax
  801801:	eb 75                	jmp    801878 <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801803:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80180a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80180d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801810:	01 d0                	add    %edx,%eax
  801812:	48                   	dec    %eax
  801813:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801816:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801819:	ba 00 00 00 00       	mov    $0x0,%edx
  80181e:	f7 75 f0             	divl   -0x10(%ebp)
  801821:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801824:	29 d0                	sub    %edx,%eax
  801826:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  801829:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801830:	e8 18 06 00 00       	call   801e4d <sys_isUHeapPlacementStrategyFIRSTFIT>
  801835:	83 f8 01             	cmp    $0x1,%eax
  801838:	75 39                	jne    801873 <sget+0x9c>

		  va = malloc(newsize) ;
  80183a:	83 ec 0c             	sub    $0xc,%esp
  80183d:	ff 75 e8             	pushl  -0x18(%ebp)
  801840:	e8 78 fd ff ff       	call   8015bd <malloc>
  801845:	83 c4 10             	add    $0x10,%esp
  801848:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  80184b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80184f:	74 22                	je     801873 <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  801851:	83 ec 04             	sub    $0x4,%esp
  801854:	ff 75 e0             	pushl  -0x20(%ebp)
  801857:	ff 75 0c             	pushl  0xc(%ebp)
  80185a:	ff 75 08             	pushl  0x8(%ebp)
  80185d:	e8 b7 03 00 00       	call   801c19 <sys_getSharedObject>
  801862:	83 c4 10             	add    $0x10,%esp
  801865:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  801868:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80186c:	78 05                	js     801873 <sget+0x9c>
					  return va;
  80186e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801871:	eb 05                	jmp    801878 <sget+0xa1>
				  }
			  }
     }
         return NULL;
  801873:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  801878:	c9                   	leave  
  801879:	c3                   	ret    

0080187a <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80187a:	55                   	push   %ebp
  80187b:	89 e5                	mov    %esp,%ebp
  80187d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801880:	e8 49 fb ff ff       	call   8013ce <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801885:	83 ec 04             	sub    $0x4,%esp
  801888:	68 84 3a 80 00       	push   $0x803a84
  80188d:	68 1e 01 00 00       	push   $0x11e
  801892:	68 53 3a 80 00       	push   $0x803a53
  801897:	e8 f4 ea ff ff       	call   800390 <_panic>

0080189c <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
  80189f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8018a2:	83 ec 04             	sub    $0x4,%esp
  8018a5:	68 ac 3a 80 00       	push   $0x803aac
  8018aa:	68 32 01 00 00       	push   $0x132
  8018af:	68 53 3a 80 00       	push   $0x803a53
  8018b4:	e8 d7 ea ff ff       	call   800390 <_panic>

008018b9 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
  8018bc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018bf:	83 ec 04             	sub    $0x4,%esp
  8018c2:	68 d0 3a 80 00       	push   $0x803ad0
  8018c7:	68 3d 01 00 00       	push   $0x13d
  8018cc:	68 53 3a 80 00       	push   $0x803a53
  8018d1:	e8 ba ea ff ff       	call   800390 <_panic>

008018d6 <shrink>:

}
void shrink(uint32 newSize)
{
  8018d6:	55                   	push   %ebp
  8018d7:	89 e5                	mov    %esp,%ebp
  8018d9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018dc:	83 ec 04             	sub    $0x4,%esp
  8018df:	68 d0 3a 80 00       	push   $0x803ad0
  8018e4:	68 42 01 00 00       	push   $0x142
  8018e9:	68 53 3a 80 00       	push   $0x803a53
  8018ee:	e8 9d ea ff ff       	call   800390 <_panic>

008018f3 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018f3:	55                   	push   %ebp
  8018f4:	89 e5                	mov    %esp,%ebp
  8018f6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018f9:	83 ec 04             	sub    $0x4,%esp
  8018fc:	68 d0 3a 80 00       	push   $0x803ad0
  801901:	68 47 01 00 00       	push   $0x147
  801906:	68 53 3a 80 00       	push   $0x803a53
  80190b:	e8 80 ea ff ff       	call   800390 <_panic>

00801910 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801910:	55                   	push   %ebp
  801911:	89 e5                	mov    %esp,%ebp
  801913:	57                   	push   %edi
  801914:	56                   	push   %esi
  801915:	53                   	push   %ebx
  801916:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801919:	8b 45 08             	mov    0x8(%ebp),%eax
  80191c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80191f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801922:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801925:	8b 7d 18             	mov    0x18(%ebp),%edi
  801928:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80192b:	cd 30                	int    $0x30
  80192d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801930:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801933:	83 c4 10             	add    $0x10,%esp
  801936:	5b                   	pop    %ebx
  801937:	5e                   	pop    %esi
  801938:	5f                   	pop    %edi
  801939:	5d                   	pop    %ebp
  80193a:	c3                   	ret    

0080193b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
  80193e:	83 ec 04             	sub    $0x4,%esp
  801941:	8b 45 10             	mov    0x10(%ebp),%eax
  801944:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801947:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80194b:	8b 45 08             	mov    0x8(%ebp),%eax
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	52                   	push   %edx
  801953:	ff 75 0c             	pushl  0xc(%ebp)
  801956:	50                   	push   %eax
  801957:	6a 00                	push   $0x0
  801959:	e8 b2 ff ff ff       	call   801910 <syscall>
  80195e:	83 c4 18             	add    $0x18,%esp
}
  801961:	90                   	nop
  801962:	c9                   	leave  
  801963:	c3                   	ret    

00801964 <sys_cgetc>:

int
sys_cgetc(void)
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 01                	push   $0x1
  801973:	e8 98 ff ff ff       	call   801910 <syscall>
  801978:	83 c4 18             	add    $0x18,%esp
}
  80197b:	c9                   	leave  
  80197c:	c3                   	ret    

0080197d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801980:	8b 55 0c             	mov    0xc(%ebp),%edx
  801983:	8b 45 08             	mov    0x8(%ebp),%eax
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	52                   	push   %edx
  80198d:	50                   	push   %eax
  80198e:	6a 05                	push   $0x5
  801990:	e8 7b ff ff ff       	call   801910 <syscall>
  801995:	83 c4 18             	add    $0x18,%esp
}
  801998:	c9                   	leave  
  801999:	c3                   	ret    

0080199a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
  80199d:	56                   	push   %esi
  80199e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80199f:	8b 75 18             	mov    0x18(%ebp),%esi
  8019a2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019a5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ae:	56                   	push   %esi
  8019af:	53                   	push   %ebx
  8019b0:	51                   	push   %ecx
  8019b1:	52                   	push   %edx
  8019b2:	50                   	push   %eax
  8019b3:	6a 06                	push   $0x6
  8019b5:	e8 56 ff ff ff       	call   801910 <syscall>
  8019ba:	83 c4 18             	add    $0x18,%esp
}
  8019bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019c0:	5b                   	pop    %ebx
  8019c1:	5e                   	pop    %esi
  8019c2:	5d                   	pop    %ebp
  8019c3:	c3                   	ret    

008019c4 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8019c4:	55                   	push   %ebp
  8019c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	52                   	push   %edx
  8019d4:	50                   	push   %eax
  8019d5:	6a 07                	push   $0x7
  8019d7:	e8 34 ff ff ff       	call   801910 <syscall>
  8019dc:	83 c4 18             	add    $0x18,%esp
}
  8019df:	c9                   	leave  
  8019e0:	c3                   	ret    

008019e1 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019e1:	55                   	push   %ebp
  8019e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	ff 75 0c             	pushl  0xc(%ebp)
  8019ed:	ff 75 08             	pushl  0x8(%ebp)
  8019f0:	6a 08                	push   $0x8
  8019f2:	e8 19 ff ff ff       	call   801910 <syscall>
  8019f7:	83 c4 18             	add    $0x18,%esp
}
  8019fa:	c9                   	leave  
  8019fb:	c3                   	ret    

008019fc <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019fc:	55                   	push   %ebp
  8019fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 09                	push   $0x9
  801a0b:	e8 00 ff ff ff       	call   801910 <syscall>
  801a10:	83 c4 18             	add    $0x18,%esp
}
  801a13:	c9                   	leave  
  801a14:	c3                   	ret    

00801a15 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a15:	55                   	push   %ebp
  801a16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 0a                	push   $0xa
  801a24:	e8 e7 fe ff ff       	call   801910 <syscall>
  801a29:	83 c4 18             	add    $0x18,%esp
}
  801a2c:	c9                   	leave  
  801a2d:	c3                   	ret    

00801a2e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a2e:	55                   	push   %ebp
  801a2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 0b                	push   $0xb
  801a3d:	e8 ce fe ff ff       	call   801910 <syscall>
  801a42:	83 c4 18             	add    $0x18,%esp
}
  801a45:	c9                   	leave  
  801a46:	c3                   	ret    

00801a47 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	ff 75 0c             	pushl  0xc(%ebp)
  801a53:	ff 75 08             	pushl  0x8(%ebp)
  801a56:	6a 0f                	push   $0xf
  801a58:	e8 b3 fe ff ff       	call   801910 <syscall>
  801a5d:	83 c4 18             	add    $0x18,%esp
	return;
  801a60:	90                   	nop
}
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    

00801a63 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	ff 75 0c             	pushl  0xc(%ebp)
  801a6f:	ff 75 08             	pushl  0x8(%ebp)
  801a72:	6a 10                	push   $0x10
  801a74:	e8 97 fe ff ff       	call   801910 <syscall>
  801a79:	83 c4 18             	add    $0x18,%esp
	return ;
  801a7c:	90                   	nop
}
  801a7d:	c9                   	leave  
  801a7e:	c3                   	ret    

00801a7f <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	ff 75 10             	pushl  0x10(%ebp)
  801a89:	ff 75 0c             	pushl  0xc(%ebp)
  801a8c:	ff 75 08             	pushl  0x8(%ebp)
  801a8f:	6a 11                	push   $0x11
  801a91:	e8 7a fe ff ff       	call   801910 <syscall>
  801a96:	83 c4 18             	add    $0x18,%esp
	return ;
  801a99:	90                   	nop
}
  801a9a:	c9                   	leave  
  801a9b:	c3                   	ret    

00801a9c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a9c:	55                   	push   %ebp
  801a9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 0c                	push   $0xc
  801aab:	e8 60 fe ff ff       	call   801910 <syscall>
  801ab0:	83 c4 18             	add    $0x18,%esp
}
  801ab3:	c9                   	leave  
  801ab4:	c3                   	ret    

00801ab5 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	ff 75 08             	pushl  0x8(%ebp)
  801ac3:	6a 0d                	push   $0xd
  801ac5:	e8 46 fe ff ff       	call   801910 <syscall>
  801aca:	83 c4 18             	add    $0x18,%esp
}
  801acd:	c9                   	leave  
  801ace:	c3                   	ret    

00801acf <sys_scarce_memory>:

void sys_scarce_memory()
{
  801acf:	55                   	push   %ebp
  801ad0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 0e                	push   $0xe
  801ade:	e8 2d fe ff ff       	call   801910 <syscall>
  801ae3:	83 c4 18             	add    $0x18,%esp
}
  801ae6:	90                   	nop
  801ae7:	c9                   	leave  
  801ae8:	c3                   	ret    

00801ae9 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 13                	push   $0x13
  801af8:	e8 13 fe ff ff       	call   801910 <syscall>
  801afd:	83 c4 18             	add    $0x18,%esp
}
  801b00:	90                   	nop
  801b01:	c9                   	leave  
  801b02:	c3                   	ret    

00801b03 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b03:	55                   	push   %ebp
  801b04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 14                	push   $0x14
  801b12:	e8 f9 fd ff ff       	call   801910 <syscall>
  801b17:	83 c4 18             	add    $0x18,%esp
}
  801b1a:	90                   	nop
  801b1b:	c9                   	leave  
  801b1c:	c3                   	ret    

00801b1d <sys_cputc>:


void
sys_cputc(const char c)
{
  801b1d:	55                   	push   %ebp
  801b1e:	89 e5                	mov    %esp,%ebp
  801b20:	83 ec 04             	sub    $0x4,%esp
  801b23:	8b 45 08             	mov    0x8(%ebp),%eax
  801b26:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b29:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	50                   	push   %eax
  801b36:	6a 15                	push   $0x15
  801b38:	e8 d3 fd ff ff       	call   801910 <syscall>
  801b3d:	83 c4 18             	add    $0x18,%esp
}
  801b40:	90                   	nop
  801b41:	c9                   	leave  
  801b42:	c3                   	ret    

00801b43 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 16                	push   $0x16
  801b52:	e8 b9 fd ff ff       	call   801910 <syscall>
  801b57:	83 c4 18             	add    $0x18,%esp
}
  801b5a:	90                   	nop
  801b5b:	c9                   	leave  
  801b5c:	c3                   	ret    

00801b5d <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b60:	8b 45 08             	mov    0x8(%ebp),%eax
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	ff 75 0c             	pushl  0xc(%ebp)
  801b6c:	50                   	push   %eax
  801b6d:	6a 17                	push   $0x17
  801b6f:	e8 9c fd ff ff       	call   801910 <syscall>
  801b74:	83 c4 18             	add    $0x18,%esp
}
  801b77:	c9                   	leave  
  801b78:	c3                   	ret    

00801b79 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b79:	55                   	push   %ebp
  801b7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	52                   	push   %edx
  801b89:	50                   	push   %eax
  801b8a:	6a 1a                	push   $0x1a
  801b8c:	e8 7f fd ff ff       	call   801910 <syscall>
  801b91:	83 c4 18             	add    $0x18,%esp
}
  801b94:	c9                   	leave  
  801b95:	c3                   	ret    

00801b96 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b96:	55                   	push   %ebp
  801b97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b99:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	52                   	push   %edx
  801ba6:	50                   	push   %eax
  801ba7:	6a 18                	push   $0x18
  801ba9:	e8 62 fd ff ff       	call   801910 <syscall>
  801bae:	83 c4 18             	add    $0x18,%esp
}
  801bb1:	90                   	nop
  801bb2:	c9                   	leave  
  801bb3:	c3                   	ret    

00801bb4 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bb4:	55                   	push   %ebp
  801bb5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bba:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	52                   	push   %edx
  801bc4:	50                   	push   %eax
  801bc5:	6a 19                	push   $0x19
  801bc7:	e8 44 fd ff ff       	call   801910 <syscall>
  801bcc:	83 c4 18             	add    $0x18,%esp
}
  801bcf:	90                   	nop
  801bd0:	c9                   	leave  
  801bd1:	c3                   	ret    

00801bd2 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801bd2:	55                   	push   %ebp
  801bd3:	89 e5                	mov    %esp,%ebp
  801bd5:	83 ec 04             	sub    $0x4,%esp
  801bd8:	8b 45 10             	mov    0x10(%ebp),%eax
  801bdb:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801bde:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801be1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801be5:	8b 45 08             	mov    0x8(%ebp),%eax
  801be8:	6a 00                	push   $0x0
  801bea:	51                   	push   %ecx
  801beb:	52                   	push   %edx
  801bec:	ff 75 0c             	pushl  0xc(%ebp)
  801bef:	50                   	push   %eax
  801bf0:	6a 1b                	push   $0x1b
  801bf2:	e8 19 fd ff ff       	call   801910 <syscall>
  801bf7:	83 c4 18             	add    $0x18,%esp
}
  801bfa:	c9                   	leave  
  801bfb:	c3                   	ret    

00801bfc <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801bff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c02:	8b 45 08             	mov    0x8(%ebp),%eax
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	52                   	push   %edx
  801c0c:	50                   	push   %eax
  801c0d:	6a 1c                	push   $0x1c
  801c0f:	e8 fc fc ff ff       	call   801910 <syscall>
  801c14:	83 c4 18             	add    $0x18,%esp
}
  801c17:	c9                   	leave  
  801c18:	c3                   	ret    

00801c19 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c19:	55                   	push   %ebp
  801c1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c1c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c22:	8b 45 08             	mov    0x8(%ebp),%eax
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	51                   	push   %ecx
  801c2a:	52                   	push   %edx
  801c2b:	50                   	push   %eax
  801c2c:	6a 1d                	push   $0x1d
  801c2e:	e8 dd fc ff ff       	call   801910 <syscall>
  801c33:	83 c4 18             	add    $0x18,%esp
}
  801c36:	c9                   	leave  
  801c37:	c3                   	ret    

00801c38 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c38:	55                   	push   %ebp
  801c39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	52                   	push   %edx
  801c48:	50                   	push   %eax
  801c49:	6a 1e                	push   $0x1e
  801c4b:	e8 c0 fc ff ff       	call   801910 <syscall>
  801c50:	83 c4 18             	add    $0x18,%esp
}
  801c53:	c9                   	leave  
  801c54:	c3                   	ret    

00801c55 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c55:	55                   	push   %ebp
  801c56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 1f                	push   $0x1f
  801c64:	e8 a7 fc ff ff       	call   801910 <syscall>
  801c69:	83 c4 18             	add    $0x18,%esp
}
  801c6c:	c9                   	leave  
  801c6d:	c3                   	ret    

00801c6e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c6e:	55                   	push   %ebp
  801c6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c71:	8b 45 08             	mov    0x8(%ebp),%eax
  801c74:	6a 00                	push   $0x0
  801c76:	ff 75 14             	pushl  0x14(%ebp)
  801c79:	ff 75 10             	pushl  0x10(%ebp)
  801c7c:	ff 75 0c             	pushl  0xc(%ebp)
  801c7f:	50                   	push   %eax
  801c80:	6a 20                	push   $0x20
  801c82:	e8 89 fc ff ff       	call   801910 <syscall>
  801c87:	83 c4 18             	add    $0x18,%esp
}
  801c8a:	c9                   	leave  
  801c8b:	c3                   	ret    

00801c8c <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c8c:	55                   	push   %ebp
  801c8d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	50                   	push   %eax
  801c9b:	6a 21                	push   $0x21
  801c9d:	e8 6e fc ff ff       	call   801910 <syscall>
  801ca2:	83 c4 18             	add    $0x18,%esp
}
  801ca5:	90                   	nop
  801ca6:	c9                   	leave  
  801ca7:	c3                   	ret    

00801ca8 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801cab:	8b 45 08             	mov    0x8(%ebp),%eax
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	50                   	push   %eax
  801cb7:	6a 22                	push   $0x22
  801cb9:	e8 52 fc ff ff       	call   801910 <syscall>
  801cbe:	83 c4 18             	add    $0x18,%esp
}
  801cc1:	c9                   	leave  
  801cc2:	c3                   	ret    

00801cc3 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801cc3:	55                   	push   %ebp
  801cc4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 02                	push   $0x2
  801cd2:	e8 39 fc ff ff       	call   801910 <syscall>
  801cd7:	83 c4 18             	add    $0x18,%esp
}
  801cda:	c9                   	leave  
  801cdb:	c3                   	ret    

00801cdc <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801cdc:	55                   	push   %ebp
  801cdd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 03                	push   $0x3
  801ceb:	e8 20 fc ff ff       	call   801910 <syscall>
  801cf0:	83 c4 18             	add    $0x18,%esp
}
  801cf3:	c9                   	leave  
  801cf4:	c3                   	ret    

00801cf5 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801cf5:	55                   	push   %ebp
  801cf6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 04                	push   $0x4
  801d04:	e8 07 fc ff ff       	call   801910 <syscall>
  801d09:	83 c4 18             	add    $0x18,%esp
}
  801d0c:	c9                   	leave  
  801d0d:	c3                   	ret    

00801d0e <sys_exit_env>:


void sys_exit_env(void)
{
  801d0e:	55                   	push   %ebp
  801d0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 23                	push   $0x23
  801d1d:	e8 ee fb ff ff       	call   801910 <syscall>
  801d22:	83 c4 18             	add    $0x18,%esp
}
  801d25:	90                   	nop
  801d26:	c9                   	leave  
  801d27:	c3                   	ret    

00801d28 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d28:	55                   	push   %ebp
  801d29:	89 e5                	mov    %esp,%ebp
  801d2b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d2e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d31:	8d 50 04             	lea    0x4(%eax),%edx
  801d34:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	52                   	push   %edx
  801d3e:	50                   	push   %eax
  801d3f:	6a 24                	push   $0x24
  801d41:	e8 ca fb ff ff       	call   801910 <syscall>
  801d46:	83 c4 18             	add    $0x18,%esp
	return result;
  801d49:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d4c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d4f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d52:	89 01                	mov    %eax,(%ecx)
  801d54:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d57:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5a:	c9                   	leave  
  801d5b:	c2 04 00             	ret    $0x4

00801d5e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d5e:	55                   	push   %ebp
  801d5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	ff 75 10             	pushl  0x10(%ebp)
  801d68:	ff 75 0c             	pushl  0xc(%ebp)
  801d6b:	ff 75 08             	pushl  0x8(%ebp)
  801d6e:	6a 12                	push   $0x12
  801d70:	e8 9b fb ff ff       	call   801910 <syscall>
  801d75:	83 c4 18             	add    $0x18,%esp
	return ;
  801d78:	90                   	nop
}
  801d79:	c9                   	leave  
  801d7a:	c3                   	ret    

00801d7b <sys_rcr2>:
uint32 sys_rcr2()
{
  801d7b:	55                   	push   %ebp
  801d7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 25                	push   $0x25
  801d8a:	e8 81 fb ff ff       	call   801910 <syscall>
  801d8f:	83 c4 18             	add    $0x18,%esp
}
  801d92:	c9                   	leave  
  801d93:	c3                   	ret    

00801d94 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d94:	55                   	push   %ebp
  801d95:	89 e5                	mov    %esp,%ebp
  801d97:	83 ec 04             	sub    $0x4,%esp
  801d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801da0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	50                   	push   %eax
  801dad:	6a 26                	push   $0x26
  801daf:	e8 5c fb ff ff       	call   801910 <syscall>
  801db4:	83 c4 18             	add    $0x18,%esp
	return ;
  801db7:	90                   	nop
}
  801db8:	c9                   	leave  
  801db9:	c3                   	ret    

00801dba <rsttst>:
void rsttst()
{
  801dba:	55                   	push   %ebp
  801dbb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 28                	push   $0x28
  801dc9:	e8 42 fb ff ff       	call   801910 <syscall>
  801dce:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd1:	90                   	nop
}
  801dd2:	c9                   	leave  
  801dd3:	c3                   	ret    

00801dd4 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801dd4:	55                   	push   %ebp
  801dd5:	89 e5                	mov    %esp,%ebp
  801dd7:	83 ec 04             	sub    $0x4,%esp
  801dda:	8b 45 14             	mov    0x14(%ebp),%eax
  801ddd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801de0:	8b 55 18             	mov    0x18(%ebp),%edx
  801de3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801de7:	52                   	push   %edx
  801de8:	50                   	push   %eax
  801de9:	ff 75 10             	pushl  0x10(%ebp)
  801dec:	ff 75 0c             	pushl  0xc(%ebp)
  801def:	ff 75 08             	pushl  0x8(%ebp)
  801df2:	6a 27                	push   $0x27
  801df4:	e8 17 fb ff ff       	call   801910 <syscall>
  801df9:	83 c4 18             	add    $0x18,%esp
	return ;
  801dfc:	90                   	nop
}
  801dfd:	c9                   	leave  
  801dfe:	c3                   	ret    

00801dff <chktst>:
void chktst(uint32 n)
{
  801dff:	55                   	push   %ebp
  801e00:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	ff 75 08             	pushl  0x8(%ebp)
  801e0d:	6a 29                	push   $0x29
  801e0f:	e8 fc fa ff ff       	call   801910 <syscall>
  801e14:	83 c4 18             	add    $0x18,%esp
	return ;
  801e17:	90                   	nop
}
  801e18:	c9                   	leave  
  801e19:	c3                   	ret    

00801e1a <inctst>:

void inctst()
{
  801e1a:	55                   	push   %ebp
  801e1b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	6a 2a                	push   $0x2a
  801e29:	e8 e2 fa ff ff       	call   801910 <syscall>
  801e2e:	83 c4 18             	add    $0x18,%esp
	return ;
  801e31:	90                   	nop
}
  801e32:	c9                   	leave  
  801e33:	c3                   	ret    

00801e34 <gettst>:
uint32 gettst()
{
  801e34:	55                   	push   %ebp
  801e35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e37:	6a 00                	push   $0x0
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 2b                	push   $0x2b
  801e43:	e8 c8 fa ff ff       	call   801910 <syscall>
  801e48:	83 c4 18             	add    $0x18,%esp
}
  801e4b:	c9                   	leave  
  801e4c:	c3                   	ret    

00801e4d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e4d:	55                   	push   %ebp
  801e4e:	89 e5                	mov    %esp,%ebp
  801e50:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e53:	6a 00                	push   $0x0
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 2c                	push   $0x2c
  801e5f:	e8 ac fa ff ff       	call   801910 <syscall>
  801e64:	83 c4 18             	add    $0x18,%esp
  801e67:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e6a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e6e:	75 07                	jne    801e77 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e70:	b8 01 00 00 00       	mov    $0x1,%eax
  801e75:	eb 05                	jmp    801e7c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e7c:	c9                   	leave  
  801e7d:	c3                   	ret    

00801e7e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e7e:	55                   	push   %ebp
  801e7f:	89 e5                	mov    %esp,%ebp
  801e81:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e84:	6a 00                	push   $0x0
  801e86:	6a 00                	push   $0x0
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 00                	push   $0x0
  801e8e:	6a 2c                	push   $0x2c
  801e90:	e8 7b fa ff ff       	call   801910 <syscall>
  801e95:	83 c4 18             	add    $0x18,%esp
  801e98:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e9b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e9f:	75 07                	jne    801ea8 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ea1:	b8 01 00 00 00       	mov    $0x1,%eax
  801ea6:	eb 05                	jmp    801ead <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ea8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ead:	c9                   	leave  
  801eae:	c3                   	ret    

00801eaf <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801eaf:	55                   	push   %ebp
  801eb0:	89 e5                	mov    %esp,%ebp
  801eb2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	6a 2c                	push   $0x2c
  801ec1:	e8 4a fa ff ff       	call   801910 <syscall>
  801ec6:	83 c4 18             	add    $0x18,%esp
  801ec9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ecc:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ed0:	75 07                	jne    801ed9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ed2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ed7:	eb 05                	jmp    801ede <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ed9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ede:	c9                   	leave  
  801edf:	c3                   	ret    

00801ee0 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
  801ee3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 2c                	push   $0x2c
  801ef2:	e8 19 fa ff ff       	call   801910 <syscall>
  801ef7:	83 c4 18             	add    $0x18,%esp
  801efa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801efd:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f01:	75 07                	jne    801f0a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f03:	b8 01 00 00 00       	mov    $0x1,%eax
  801f08:	eb 05                	jmp    801f0f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f0f:	c9                   	leave  
  801f10:	c3                   	ret    

00801f11 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f11:	55                   	push   %ebp
  801f12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f14:	6a 00                	push   $0x0
  801f16:	6a 00                	push   $0x0
  801f18:	6a 00                	push   $0x0
  801f1a:	6a 00                	push   $0x0
  801f1c:	ff 75 08             	pushl  0x8(%ebp)
  801f1f:	6a 2d                	push   $0x2d
  801f21:	e8 ea f9 ff ff       	call   801910 <syscall>
  801f26:	83 c4 18             	add    $0x18,%esp
	return ;
  801f29:	90                   	nop
}
  801f2a:	c9                   	leave  
  801f2b:	c3                   	ret    

00801f2c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f2c:	55                   	push   %ebp
  801f2d:	89 e5                	mov    %esp,%ebp
  801f2f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f30:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f33:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f36:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f39:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3c:	6a 00                	push   $0x0
  801f3e:	53                   	push   %ebx
  801f3f:	51                   	push   %ecx
  801f40:	52                   	push   %edx
  801f41:	50                   	push   %eax
  801f42:	6a 2e                	push   $0x2e
  801f44:	e8 c7 f9 ff ff       	call   801910 <syscall>
  801f49:	83 c4 18             	add    $0x18,%esp
}
  801f4c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f4f:	c9                   	leave  
  801f50:	c3                   	ret    

00801f51 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f51:	55                   	push   %ebp
  801f52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f54:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f57:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 00                	push   $0x0
  801f60:	52                   	push   %edx
  801f61:	50                   	push   %eax
  801f62:	6a 2f                	push   $0x2f
  801f64:	e8 a7 f9 ff ff       	call   801910 <syscall>
  801f69:	83 c4 18             	add    $0x18,%esp
}
  801f6c:	c9                   	leave  
  801f6d:	c3                   	ret    

00801f6e <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f6e:	55                   	push   %ebp
  801f6f:	89 e5                	mov    %esp,%ebp
  801f71:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f74:	83 ec 0c             	sub    $0xc,%esp
  801f77:	68 e0 3a 80 00       	push   $0x803ae0
  801f7c:	e8 c3 e6 ff ff       	call   800644 <cprintf>
  801f81:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f84:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f8b:	83 ec 0c             	sub    $0xc,%esp
  801f8e:	68 0c 3b 80 00       	push   $0x803b0c
  801f93:	e8 ac e6 ff ff       	call   800644 <cprintf>
  801f98:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f9b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f9f:	a1 38 41 80 00       	mov    0x804138,%eax
  801fa4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fa7:	eb 56                	jmp    801fff <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fa9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fad:	74 1c                	je     801fcb <print_mem_block_lists+0x5d>
  801faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb2:	8b 50 08             	mov    0x8(%eax),%edx
  801fb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fb8:	8b 48 08             	mov    0x8(%eax),%ecx
  801fbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fbe:	8b 40 0c             	mov    0xc(%eax),%eax
  801fc1:	01 c8                	add    %ecx,%eax
  801fc3:	39 c2                	cmp    %eax,%edx
  801fc5:	73 04                	jae    801fcb <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801fc7:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fce:	8b 50 08             	mov    0x8(%eax),%edx
  801fd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd4:	8b 40 0c             	mov    0xc(%eax),%eax
  801fd7:	01 c2                	add    %eax,%edx
  801fd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fdc:	8b 40 08             	mov    0x8(%eax),%eax
  801fdf:	83 ec 04             	sub    $0x4,%esp
  801fe2:	52                   	push   %edx
  801fe3:	50                   	push   %eax
  801fe4:	68 21 3b 80 00       	push   $0x803b21
  801fe9:	e8 56 e6 ff ff       	call   800644 <cprintf>
  801fee:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ff7:	a1 40 41 80 00       	mov    0x804140,%eax
  801ffc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802003:	74 07                	je     80200c <print_mem_block_lists+0x9e>
  802005:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802008:	8b 00                	mov    (%eax),%eax
  80200a:	eb 05                	jmp    802011 <print_mem_block_lists+0xa3>
  80200c:	b8 00 00 00 00       	mov    $0x0,%eax
  802011:	a3 40 41 80 00       	mov    %eax,0x804140
  802016:	a1 40 41 80 00       	mov    0x804140,%eax
  80201b:	85 c0                	test   %eax,%eax
  80201d:	75 8a                	jne    801fa9 <print_mem_block_lists+0x3b>
  80201f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802023:	75 84                	jne    801fa9 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802025:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802029:	75 10                	jne    80203b <print_mem_block_lists+0xcd>
  80202b:	83 ec 0c             	sub    $0xc,%esp
  80202e:	68 30 3b 80 00       	push   $0x803b30
  802033:	e8 0c e6 ff ff       	call   800644 <cprintf>
  802038:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80203b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802042:	83 ec 0c             	sub    $0xc,%esp
  802045:	68 54 3b 80 00       	push   $0x803b54
  80204a:	e8 f5 e5 ff ff       	call   800644 <cprintf>
  80204f:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802052:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802056:	a1 40 40 80 00       	mov    0x804040,%eax
  80205b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80205e:	eb 56                	jmp    8020b6 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802060:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802064:	74 1c                	je     802082 <print_mem_block_lists+0x114>
  802066:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802069:	8b 50 08             	mov    0x8(%eax),%edx
  80206c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80206f:	8b 48 08             	mov    0x8(%eax),%ecx
  802072:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802075:	8b 40 0c             	mov    0xc(%eax),%eax
  802078:	01 c8                	add    %ecx,%eax
  80207a:	39 c2                	cmp    %eax,%edx
  80207c:	73 04                	jae    802082 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80207e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802082:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802085:	8b 50 08             	mov    0x8(%eax),%edx
  802088:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208b:	8b 40 0c             	mov    0xc(%eax),%eax
  80208e:	01 c2                	add    %eax,%edx
  802090:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802093:	8b 40 08             	mov    0x8(%eax),%eax
  802096:	83 ec 04             	sub    $0x4,%esp
  802099:	52                   	push   %edx
  80209a:	50                   	push   %eax
  80209b:	68 21 3b 80 00       	push   $0x803b21
  8020a0:	e8 9f e5 ff ff       	call   800644 <cprintf>
  8020a5:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020ae:	a1 48 40 80 00       	mov    0x804048,%eax
  8020b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020ba:	74 07                	je     8020c3 <print_mem_block_lists+0x155>
  8020bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020bf:	8b 00                	mov    (%eax),%eax
  8020c1:	eb 05                	jmp    8020c8 <print_mem_block_lists+0x15a>
  8020c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c8:	a3 48 40 80 00       	mov    %eax,0x804048
  8020cd:	a1 48 40 80 00       	mov    0x804048,%eax
  8020d2:	85 c0                	test   %eax,%eax
  8020d4:	75 8a                	jne    802060 <print_mem_block_lists+0xf2>
  8020d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020da:	75 84                	jne    802060 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8020dc:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020e0:	75 10                	jne    8020f2 <print_mem_block_lists+0x184>
  8020e2:	83 ec 0c             	sub    $0xc,%esp
  8020e5:	68 6c 3b 80 00       	push   $0x803b6c
  8020ea:	e8 55 e5 ff ff       	call   800644 <cprintf>
  8020ef:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8020f2:	83 ec 0c             	sub    $0xc,%esp
  8020f5:	68 e0 3a 80 00       	push   $0x803ae0
  8020fa:	e8 45 e5 ff ff       	call   800644 <cprintf>
  8020ff:	83 c4 10             	add    $0x10,%esp

}
  802102:	90                   	nop
  802103:	c9                   	leave  
  802104:	c3                   	ret    

00802105 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802105:	55                   	push   %ebp
  802106:	89 e5                	mov    %esp,%ebp
  802108:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  80210b:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802112:	00 00 00 
  802115:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  80211c:	00 00 00 
  80211f:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802126:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802129:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802130:	e9 9e 00 00 00       	jmp    8021d3 <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802135:	a1 50 40 80 00       	mov    0x804050,%eax
  80213a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80213d:	c1 e2 04             	shl    $0x4,%edx
  802140:	01 d0                	add    %edx,%eax
  802142:	85 c0                	test   %eax,%eax
  802144:	75 14                	jne    80215a <initialize_MemBlocksList+0x55>
  802146:	83 ec 04             	sub    $0x4,%esp
  802149:	68 94 3b 80 00       	push   $0x803b94
  80214e:	6a 47                	push   $0x47
  802150:	68 b7 3b 80 00       	push   $0x803bb7
  802155:	e8 36 e2 ff ff       	call   800390 <_panic>
  80215a:	a1 50 40 80 00       	mov    0x804050,%eax
  80215f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802162:	c1 e2 04             	shl    $0x4,%edx
  802165:	01 d0                	add    %edx,%eax
  802167:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80216d:	89 10                	mov    %edx,(%eax)
  80216f:	8b 00                	mov    (%eax),%eax
  802171:	85 c0                	test   %eax,%eax
  802173:	74 18                	je     80218d <initialize_MemBlocksList+0x88>
  802175:	a1 48 41 80 00       	mov    0x804148,%eax
  80217a:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802180:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802183:	c1 e1 04             	shl    $0x4,%ecx
  802186:	01 ca                	add    %ecx,%edx
  802188:	89 50 04             	mov    %edx,0x4(%eax)
  80218b:	eb 12                	jmp    80219f <initialize_MemBlocksList+0x9a>
  80218d:	a1 50 40 80 00       	mov    0x804050,%eax
  802192:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802195:	c1 e2 04             	shl    $0x4,%edx
  802198:	01 d0                	add    %edx,%eax
  80219a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80219f:	a1 50 40 80 00       	mov    0x804050,%eax
  8021a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021a7:	c1 e2 04             	shl    $0x4,%edx
  8021aa:	01 d0                	add    %edx,%eax
  8021ac:	a3 48 41 80 00       	mov    %eax,0x804148
  8021b1:	a1 50 40 80 00       	mov    0x804050,%eax
  8021b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021b9:	c1 e2 04             	shl    $0x4,%edx
  8021bc:	01 d0                	add    %edx,%eax
  8021be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021c5:	a1 54 41 80 00       	mov    0x804154,%eax
  8021ca:	40                   	inc    %eax
  8021cb:	a3 54 41 80 00       	mov    %eax,0x804154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  8021d0:	ff 45 f4             	incl   -0xc(%ebp)
  8021d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021d9:	0f 82 56 ff ff ff    	jb     802135 <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  8021df:	90                   	nop
  8021e0:	c9                   	leave  
  8021e1:	c3                   	ret    

008021e2 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8021e2:	55                   	push   %ebp
  8021e3:	89 e5                	mov    %esp,%ebp
  8021e5:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  8021e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021eb:	8b 00                	mov    (%eax),%eax
  8021ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021f0:	eb 19                	jmp    80220b <find_block+0x29>
	{
		if(element->sva == va){
  8021f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021f5:	8b 40 08             	mov    0x8(%eax),%eax
  8021f8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8021fb:	75 05                	jne    802202 <find_block+0x20>
			 		return element;
  8021fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802200:	eb 36                	jmp    802238 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802202:	8b 45 08             	mov    0x8(%ebp),%eax
  802205:	8b 40 08             	mov    0x8(%eax),%eax
  802208:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80220b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80220f:	74 07                	je     802218 <find_block+0x36>
  802211:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802214:	8b 00                	mov    (%eax),%eax
  802216:	eb 05                	jmp    80221d <find_block+0x3b>
  802218:	b8 00 00 00 00       	mov    $0x0,%eax
  80221d:	8b 55 08             	mov    0x8(%ebp),%edx
  802220:	89 42 08             	mov    %eax,0x8(%edx)
  802223:	8b 45 08             	mov    0x8(%ebp),%eax
  802226:	8b 40 08             	mov    0x8(%eax),%eax
  802229:	85 c0                	test   %eax,%eax
  80222b:	75 c5                	jne    8021f2 <find_block+0x10>
  80222d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802231:	75 bf                	jne    8021f2 <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  802233:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802238:	c9                   	leave  
  802239:	c3                   	ret    

0080223a <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80223a:	55                   	push   %ebp
  80223b:	89 e5                	mov    %esp,%ebp
  80223d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  802240:	a1 44 40 80 00       	mov    0x804044,%eax
  802245:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  802248:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80224d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  802250:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802254:	74 0a                	je     802260 <insert_sorted_allocList+0x26>
  802256:	8b 45 08             	mov    0x8(%ebp),%eax
  802259:	8b 40 08             	mov    0x8(%eax),%eax
  80225c:	85 c0                	test   %eax,%eax
  80225e:	75 65                	jne    8022c5 <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802260:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802264:	75 14                	jne    80227a <insert_sorted_allocList+0x40>
  802266:	83 ec 04             	sub    $0x4,%esp
  802269:	68 94 3b 80 00       	push   $0x803b94
  80226e:	6a 6e                	push   $0x6e
  802270:	68 b7 3b 80 00       	push   $0x803bb7
  802275:	e8 16 e1 ff ff       	call   800390 <_panic>
  80227a:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802280:	8b 45 08             	mov    0x8(%ebp),%eax
  802283:	89 10                	mov    %edx,(%eax)
  802285:	8b 45 08             	mov    0x8(%ebp),%eax
  802288:	8b 00                	mov    (%eax),%eax
  80228a:	85 c0                	test   %eax,%eax
  80228c:	74 0d                	je     80229b <insert_sorted_allocList+0x61>
  80228e:	a1 40 40 80 00       	mov    0x804040,%eax
  802293:	8b 55 08             	mov    0x8(%ebp),%edx
  802296:	89 50 04             	mov    %edx,0x4(%eax)
  802299:	eb 08                	jmp    8022a3 <insert_sorted_allocList+0x69>
  80229b:	8b 45 08             	mov    0x8(%ebp),%eax
  80229e:	a3 44 40 80 00       	mov    %eax,0x804044
  8022a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a6:	a3 40 40 80 00       	mov    %eax,0x804040
  8022ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022b5:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022ba:	40                   	inc    %eax
  8022bb:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8022c0:	e9 cf 01 00 00       	jmp    802494 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  8022c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c8:	8b 50 08             	mov    0x8(%eax),%edx
  8022cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ce:	8b 40 08             	mov    0x8(%eax),%eax
  8022d1:	39 c2                	cmp    %eax,%edx
  8022d3:	73 65                	jae    80233a <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8022d5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022d9:	75 14                	jne    8022ef <insert_sorted_allocList+0xb5>
  8022db:	83 ec 04             	sub    $0x4,%esp
  8022de:	68 d0 3b 80 00       	push   $0x803bd0
  8022e3:	6a 72                	push   $0x72
  8022e5:	68 b7 3b 80 00       	push   $0x803bb7
  8022ea:	e8 a1 e0 ff ff       	call   800390 <_panic>
  8022ef:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8022f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f8:	89 50 04             	mov    %edx,0x4(%eax)
  8022fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fe:	8b 40 04             	mov    0x4(%eax),%eax
  802301:	85 c0                	test   %eax,%eax
  802303:	74 0c                	je     802311 <insert_sorted_allocList+0xd7>
  802305:	a1 44 40 80 00       	mov    0x804044,%eax
  80230a:	8b 55 08             	mov    0x8(%ebp),%edx
  80230d:	89 10                	mov    %edx,(%eax)
  80230f:	eb 08                	jmp    802319 <insert_sorted_allocList+0xdf>
  802311:	8b 45 08             	mov    0x8(%ebp),%eax
  802314:	a3 40 40 80 00       	mov    %eax,0x804040
  802319:	8b 45 08             	mov    0x8(%ebp),%eax
  80231c:	a3 44 40 80 00       	mov    %eax,0x804044
  802321:	8b 45 08             	mov    0x8(%ebp),%eax
  802324:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80232a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80232f:	40                   	inc    %eax
  802330:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  802335:	e9 5a 01 00 00       	jmp    802494 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  80233a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80233d:	8b 50 08             	mov    0x8(%eax),%edx
  802340:	8b 45 08             	mov    0x8(%ebp),%eax
  802343:	8b 40 08             	mov    0x8(%eax),%eax
  802346:	39 c2                	cmp    %eax,%edx
  802348:	75 70                	jne    8023ba <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  80234a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80234e:	74 06                	je     802356 <insert_sorted_allocList+0x11c>
  802350:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802354:	75 14                	jne    80236a <insert_sorted_allocList+0x130>
  802356:	83 ec 04             	sub    $0x4,%esp
  802359:	68 f4 3b 80 00       	push   $0x803bf4
  80235e:	6a 75                	push   $0x75
  802360:	68 b7 3b 80 00       	push   $0x803bb7
  802365:	e8 26 e0 ff ff       	call   800390 <_panic>
  80236a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80236d:	8b 10                	mov    (%eax),%edx
  80236f:	8b 45 08             	mov    0x8(%ebp),%eax
  802372:	89 10                	mov    %edx,(%eax)
  802374:	8b 45 08             	mov    0x8(%ebp),%eax
  802377:	8b 00                	mov    (%eax),%eax
  802379:	85 c0                	test   %eax,%eax
  80237b:	74 0b                	je     802388 <insert_sorted_allocList+0x14e>
  80237d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802380:	8b 00                	mov    (%eax),%eax
  802382:	8b 55 08             	mov    0x8(%ebp),%edx
  802385:	89 50 04             	mov    %edx,0x4(%eax)
  802388:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80238b:	8b 55 08             	mov    0x8(%ebp),%edx
  80238e:	89 10                	mov    %edx,(%eax)
  802390:	8b 45 08             	mov    0x8(%ebp),%eax
  802393:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802396:	89 50 04             	mov    %edx,0x4(%eax)
  802399:	8b 45 08             	mov    0x8(%ebp),%eax
  80239c:	8b 00                	mov    (%eax),%eax
  80239e:	85 c0                	test   %eax,%eax
  8023a0:	75 08                	jne    8023aa <insert_sorted_allocList+0x170>
  8023a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a5:	a3 44 40 80 00       	mov    %eax,0x804044
  8023aa:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023af:	40                   	inc    %eax
  8023b0:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  8023b5:	e9 da 00 00 00       	jmp    802494 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  8023ba:	a1 40 40 80 00       	mov    0x804040,%eax
  8023bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023c2:	e9 9d 00 00 00       	jmp    802464 <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  8023c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ca:	8b 00                	mov    (%eax),%eax
  8023cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  8023cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d2:	8b 50 08             	mov    0x8(%eax),%edx
  8023d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d8:	8b 40 08             	mov    0x8(%eax),%eax
  8023db:	39 c2                	cmp    %eax,%edx
  8023dd:	76 7d                	jbe    80245c <insert_sorted_allocList+0x222>
  8023df:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e2:	8b 50 08             	mov    0x8(%eax),%edx
  8023e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023e8:	8b 40 08             	mov    0x8(%eax),%eax
  8023eb:	39 c2                	cmp    %eax,%edx
  8023ed:	73 6d                	jae    80245c <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  8023ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023f3:	74 06                	je     8023fb <insert_sorted_allocList+0x1c1>
  8023f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023f9:	75 14                	jne    80240f <insert_sorted_allocList+0x1d5>
  8023fb:	83 ec 04             	sub    $0x4,%esp
  8023fe:	68 f4 3b 80 00       	push   $0x803bf4
  802403:	6a 7c                	push   $0x7c
  802405:	68 b7 3b 80 00       	push   $0x803bb7
  80240a:	e8 81 df ff ff       	call   800390 <_panic>
  80240f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802412:	8b 10                	mov    (%eax),%edx
  802414:	8b 45 08             	mov    0x8(%ebp),%eax
  802417:	89 10                	mov    %edx,(%eax)
  802419:	8b 45 08             	mov    0x8(%ebp),%eax
  80241c:	8b 00                	mov    (%eax),%eax
  80241e:	85 c0                	test   %eax,%eax
  802420:	74 0b                	je     80242d <insert_sorted_allocList+0x1f3>
  802422:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802425:	8b 00                	mov    (%eax),%eax
  802427:	8b 55 08             	mov    0x8(%ebp),%edx
  80242a:	89 50 04             	mov    %edx,0x4(%eax)
  80242d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802430:	8b 55 08             	mov    0x8(%ebp),%edx
  802433:	89 10                	mov    %edx,(%eax)
  802435:	8b 45 08             	mov    0x8(%ebp),%eax
  802438:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80243b:	89 50 04             	mov    %edx,0x4(%eax)
  80243e:	8b 45 08             	mov    0x8(%ebp),%eax
  802441:	8b 00                	mov    (%eax),%eax
  802443:	85 c0                	test   %eax,%eax
  802445:	75 08                	jne    80244f <insert_sorted_allocList+0x215>
  802447:	8b 45 08             	mov    0x8(%ebp),%eax
  80244a:	a3 44 40 80 00       	mov    %eax,0x804044
  80244f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802454:	40                   	inc    %eax
  802455:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  80245a:	eb 38                	jmp    802494 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  80245c:	a1 48 40 80 00       	mov    0x804048,%eax
  802461:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802464:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802468:	74 07                	je     802471 <insert_sorted_allocList+0x237>
  80246a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246d:	8b 00                	mov    (%eax),%eax
  80246f:	eb 05                	jmp    802476 <insert_sorted_allocList+0x23c>
  802471:	b8 00 00 00 00       	mov    $0x0,%eax
  802476:	a3 48 40 80 00       	mov    %eax,0x804048
  80247b:	a1 48 40 80 00       	mov    0x804048,%eax
  802480:	85 c0                	test   %eax,%eax
  802482:	0f 85 3f ff ff ff    	jne    8023c7 <insert_sorted_allocList+0x18d>
  802488:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80248c:	0f 85 35 ff ff ff    	jne    8023c7 <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  802492:	eb 00                	jmp    802494 <insert_sorted_allocList+0x25a>
  802494:	90                   	nop
  802495:	c9                   	leave  
  802496:	c3                   	ret    

00802497 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802497:	55                   	push   %ebp
  802498:	89 e5                	mov    %esp,%ebp
  80249a:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  80249d:	a1 38 41 80 00       	mov    0x804138,%eax
  8024a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024a5:	e9 6b 02 00 00       	jmp    802715 <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  8024aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8024b0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024b3:	0f 85 90 00 00 00    	jne    802549 <alloc_block_FF+0xb2>
			  temp=element;
  8024b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bc:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  8024bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024c3:	75 17                	jne    8024dc <alloc_block_FF+0x45>
  8024c5:	83 ec 04             	sub    $0x4,%esp
  8024c8:	68 28 3c 80 00       	push   $0x803c28
  8024cd:	68 92 00 00 00       	push   $0x92
  8024d2:	68 b7 3b 80 00       	push   $0x803bb7
  8024d7:	e8 b4 de ff ff       	call   800390 <_panic>
  8024dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024df:	8b 00                	mov    (%eax),%eax
  8024e1:	85 c0                	test   %eax,%eax
  8024e3:	74 10                	je     8024f5 <alloc_block_FF+0x5e>
  8024e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e8:	8b 00                	mov    (%eax),%eax
  8024ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ed:	8b 52 04             	mov    0x4(%edx),%edx
  8024f0:	89 50 04             	mov    %edx,0x4(%eax)
  8024f3:	eb 0b                	jmp    802500 <alloc_block_FF+0x69>
  8024f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f8:	8b 40 04             	mov    0x4(%eax),%eax
  8024fb:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802500:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802503:	8b 40 04             	mov    0x4(%eax),%eax
  802506:	85 c0                	test   %eax,%eax
  802508:	74 0f                	je     802519 <alloc_block_FF+0x82>
  80250a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250d:	8b 40 04             	mov    0x4(%eax),%eax
  802510:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802513:	8b 12                	mov    (%edx),%edx
  802515:	89 10                	mov    %edx,(%eax)
  802517:	eb 0a                	jmp    802523 <alloc_block_FF+0x8c>
  802519:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251c:	8b 00                	mov    (%eax),%eax
  80251e:	a3 38 41 80 00       	mov    %eax,0x804138
  802523:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802526:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80252c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802536:	a1 44 41 80 00       	mov    0x804144,%eax
  80253b:	48                   	dec    %eax
  80253c:	a3 44 41 80 00       	mov    %eax,0x804144
			  return temp;
  802541:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802544:	e9 ff 01 00 00       	jmp    802748 <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  802549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254c:	8b 40 0c             	mov    0xc(%eax),%eax
  80254f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802552:	0f 86 b5 01 00 00    	jbe    80270d <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  802558:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255b:	8b 40 0c             	mov    0xc(%eax),%eax
  80255e:	2b 45 08             	sub    0x8(%ebp),%eax
  802561:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  802564:	a1 48 41 80 00       	mov    0x804148,%eax
  802569:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  80256c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802570:	75 17                	jne    802589 <alloc_block_FF+0xf2>
  802572:	83 ec 04             	sub    $0x4,%esp
  802575:	68 28 3c 80 00       	push   $0x803c28
  80257a:	68 99 00 00 00       	push   $0x99
  80257f:	68 b7 3b 80 00       	push   $0x803bb7
  802584:	e8 07 de ff ff       	call   800390 <_panic>
  802589:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80258c:	8b 00                	mov    (%eax),%eax
  80258e:	85 c0                	test   %eax,%eax
  802590:	74 10                	je     8025a2 <alloc_block_FF+0x10b>
  802592:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802595:	8b 00                	mov    (%eax),%eax
  802597:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80259a:	8b 52 04             	mov    0x4(%edx),%edx
  80259d:	89 50 04             	mov    %edx,0x4(%eax)
  8025a0:	eb 0b                	jmp    8025ad <alloc_block_FF+0x116>
  8025a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025a5:	8b 40 04             	mov    0x4(%eax),%eax
  8025a8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8025ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025b0:	8b 40 04             	mov    0x4(%eax),%eax
  8025b3:	85 c0                	test   %eax,%eax
  8025b5:	74 0f                	je     8025c6 <alloc_block_FF+0x12f>
  8025b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ba:	8b 40 04             	mov    0x4(%eax),%eax
  8025bd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025c0:	8b 12                	mov    (%edx),%edx
  8025c2:	89 10                	mov    %edx,(%eax)
  8025c4:	eb 0a                	jmp    8025d0 <alloc_block_FF+0x139>
  8025c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025c9:	8b 00                	mov    (%eax),%eax
  8025cb:	a3 48 41 80 00       	mov    %eax,0x804148
  8025d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025e3:	a1 54 41 80 00       	mov    0x804154,%eax
  8025e8:	48                   	dec    %eax
  8025e9:	a3 54 41 80 00       	mov    %eax,0x804154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  8025ee:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025f2:	75 17                	jne    80260b <alloc_block_FF+0x174>
  8025f4:	83 ec 04             	sub    $0x4,%esp
  8025f7:	68 d0 3b 80 00       	push   $0x803bd0
  8025fc:	68 9a 00 00 00       	push   $0x9a
  802601:	68 b7 3b 80 00       	push   $0x803bb7
  802606:	e8 85 dd ff ff       	call   800390 <_panic>
  80260b:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802611:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802614:	89 50 04             	mov    %edx,0x4(%eax)
  802617:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80261a:	8b 40 04             	mov    0x4(%eax),%eax
  80261d:	85 c0                	test   %eax,%eax
  80261f:	74 0c                	je     80262d <alloc_block_FF+0x196>
  802621:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802626:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802629:	89 10                	mov    %edx,(%eax)
  80262b:	eb 08                	jmp    802635 <alloc_block_FF+0x19e>
  80262d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802630:	a3 38 41 80 00       	mov    %eax,0x804138
  802635:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802638:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80263d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802640:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802646:	a1 44 41 80 00       	mov    0x804144,%eax
  80264b:	40                   	inc    %eax
  80264c:	a3 44 41 80 00       	mov    %eax,0x804144
		  // setting the size & sva
		  new_block->size=size;
  802651:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802654:	8b 55 08             	mov    0x8(%ebp),%edx
  802657:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  80265a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265d:	8b 50 08             	mov    0x8(%eax),%edx
  802660:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802663:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  802666:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802669:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80266c:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  80266f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802672:	8b 50 08             	mov    0x8(%eax),%edx
  802675:	8b 45 08             	mov    0x8(%ebp),%eax
  802678:	01 c2                	add    %eax,%edx
  80267a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267d:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  802680:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802683:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  802686:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80268a:	75 17                	jne    8026a3 <alloc_block_FF+0x20c>
  80268c:	83 ec 04             	sub    $0x4,%esp
  80268f:	68 28 3c 80 00       	push   $0x803c28
  802694:	68 a2 00 00 00       	push   $0xa2
  802699:	68 b7 3b 80 00       	push   $0x803bb7
  80269e:	e8 ed dc ff ff       	call   800390 <_panic>
  8026a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026a6:	8b 00                	mov    (%eax),%eax
  8026a8:	85 c0                	test   %eax,%eax
  8026aa:	74 10                	je     8026bc <alloc_block_FF+0x225>
  8026ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026af:	8b 00                	mov    (%eax),%eax
  8026b1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026b4:	8b 52 04             	mov    0x4(%edx),%edx
  8026b7:	89 50 04             	mov    %edx,0x4(%eax)
  8026ba:	eb 0b                	jmp    8026c7 <alloc_block_FF+0x230>
  8026bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026bf:	8b 40 04             	mov    0x4(%eax),%eax
  8026c2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ca:	8b 40 04             	mov    0x4(%eax),%eax
  8026cd:	85 c0                	test   %eax,%eax
  8026cf:	74 0f                	je     8026e0 <alloc_block_FF+0x249>
  8026d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d4:	8b 40 04             	mov    0x4(%eax),%eax
  8026d7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026da:	8b 12                	mov    (%edx),%edx
  8026dc:	89 10                	mov    %edx,(%eax)
  8026de:	eb 0a                	jmp    8026ea <alloc_block_FF+0x253>
  8026e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e3:	8b 00                	mov    (%eax),%eax
  8026e5:	a3 38 41 80 00       	mov    %eax,0x804138
  8026ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026fd:	a1 44 41 80 00       	mov    0x804144,%eax
  802702:	48                   	dec    %eax
  802703:	a3 44 41 80 00       	mov    %eax,0x804144
		  return temp;
  802708:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80270b:	eb 3b                	jmp    802748 <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  80270d:	a1 40 41 80 00       	mov    0x804140,%eax
  802712:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802715:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802719:	74 07                	je     802722 <alloc_block_FF+0x28b>
  80271b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271e:	8b 00                	mov    (%eax),%eax
  802720:	eb 05                	jmp    802727 <alloc_block_FF+0x290>
  802722:	b8 00 00 00 00       	mov    $0x0,%eax
  802727:	a3 40 41 80 00       	mov    %eax,0x804140
  80272c:	a1 40 41 80 00       	mov    0x804140,%eax
  802731:	85 c0                	test   %eax,%eax
  802733:	0f 85 71 fd ff ff    	jne    8024aa <alloc_block_FF+0x13>
  802739:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80273d:	0f 85 67 fd ff ff    	jne    8024aa <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  802743:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802748:	c9                   	leave  
  802749:	c3                   	ret    

0080274a <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80274a:	55                   	push   %ebp
  80274b:	89 e5                	mov    %esp,%ebp
  80274d:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  802750:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  802757:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  80275e:	a1 38 41 80 00       	mov    0x804138,%eax
  802763:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802766:	e9 d3 00 00 00       	jmp    80283e <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  80276b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80276e:	8b 40 0c             	mov    0xc(%eax),%eax
  802771:	3b 45 08             	cmp    0x8(%ebp),%eax
  802774:	0f 85 90 00 00 00    	jne    80280a <alloc_block_BF+0xc0>
	   temp = element;
  80277a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80277d:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  802780:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802784:	75 17                	jne    80279d <alloc_block_BF+0x53>
  802786:	83 ec 04             	sub    $0x4,%esp
  802789:	68 28 3c 80 00       	push   $0x803c28
  80278e:	68 bd 00 00 00       	push   $0xbd
  802793:	68 b7 3b 80 00       	push   $0x803bb7
  802798:	e8 f3 db ff ff       	call   800390 <_panic>
  80279d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027a0:	8b 00                	mov    (%eax),%eax
  8027a2:	85 c0                	test   %eax,%eax
  8027a4:	74 10                	je     8027b6 <alloc_block_BF+0x6c>
  8027a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027a9:	8b 00                	mov    (%eax),%eax
  8027ab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027ae:	8b 52 04             	mov    0x4(%edx),%edx
  8027b1:	89 50 04             	mov    %edx,0x4(%eax)
  8027b4:	eb 0b                	jmp    8027c1 <alloc_block_BF+0x77>
  8027b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027b9:	8b 40 04             	mov    0x4(%eax),%eax
  8027bc:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027c4:	8b 40 04             	mov    0x4(%eax),%eax
  8027c7:	85 c0                	test   %eax,%eax
  8027c9:	74 0f                	je     8027da <alloc_block_BF+0x90>
  8027cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027ce:	8b 40 04             	mov    0x4(%eax),%eax
  8027d1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027d4:	8b 12                	mov    (%edx),%edx
  8027d6:	89 10                	mov    %edx,(%eax)
  8027d8:	eb 0a                	jmp    8027e4 <alloc_block_BF+0x9a>
  8027da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027dd:	8b 00                	mov    (%eax),%eax
  8027df:	a3 38 41 80 00       	mov    %eax,0x804138
  8027e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027f7:	a1 44 41 80 00       	mov    0x804144,%eax
  8027fc:	48                   	dec    %eax
  8027fd:	a3 44 41 80 00       	mov    %eax,0x804144
	   return temp;
  802802:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802805:	e9 41 01 00 00       	jmp    80294b <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  80280a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80280d:	8b 40 0c             	mov    0xc(%eax),%eax
  802810:	3b 45 08             	cmp    0x8(%ebp),%eax
  802813:	76 21                	jbe    802836 <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  802815:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802818:	8b 40 0c             	mov    0xc(%eax),%eax
  80281b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80281e:	73 16                	jae    802836 <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  802820:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802823:	8b 40 0c             	mov    0xc(%eax),%eax
  802826:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  802829:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80282c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  80282f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802836:	a1 40 41 80 00       	mov    0x804140,%eax
  80283b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80283e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802842:	74 07                	je     80284b <alloc_block_BF+0x101>
  802844:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802847:	8b 00                	mov    (%eax),%eax
  802849:	eb 05                	jmp    802850 <alloc_block_BF+0x106>
  80284b:	b8 00 00 00 00       	mov    $0x0,%eax
  802850:	a3 40 41 80 00       	mov    %eax,0x804140
  802855:	a1 40 41 80 00       	mov    0x804140,%eax
  80285a:	85 c0                	test   %eax,%eax
  80285c:	0f 85 09 ff ff ff    	jne    80276b <alloc_block_BF+0x21>
  802862:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802866:	0f 85 ff fe ff ff    	jne    80276b <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  80286c:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  802870:	0f 85 d0 00 00 00    	jne    802946 <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  802876:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802879:	8b 40 0c             	mov    0xc(%eax),%eax
  80287c:	2b 45 08             	sub    0x8(%ebp),%eax
  80287f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  802882:	a1 48 41 80 00       	mov    0x804148,%eax
  802887:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  80288a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80288e:	75 17                	jne    8028a7 <alloc_block_BF+0x15d>
  802890:	83 ec 04             	sub    $0x4,%esp
  802893:	68 28 3c 80 00       	push   $0x803c28
  802898:	68 d1 00 00 00       	push   $0xd1
  80289d:	68 b7 3b 80 00       	push   $0x803bb7
  8028a2:	e8 e9 da ff ff       	call   800390 <_panic>
  8028a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028aa:	8b 00                	mov    (%eax),%eax
  8028ac:	85 c0                	test   %eax,%eax
  8028ae:	74 10                	je     8028c0 <alloc_block_BF+0x176>
  8028b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028b3:	8b 00                	mov    (%eax),%eax
  8028b5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028b8:	8b 52 04             	mov    0x4(%edx),%edx
  8028bb:	89 50 04             	mov    %edx,0x4(%eax)
  8028be:	eb 0b                	jmp    8028cb <alloc_block_BF+0x181>
  8028c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028c3:	8b 40 04             	mov    0x4(%eax),%eax
  8028c6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8028cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028ce:	8b 40 04             	mov    0x4(%eax),%eax
  8028d1:	85 c0                	test   %eax,%eax
  8028d3:	74 0f                	je     8028e4 <alloc_block_BF+0x19a>
  8028d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028d8:	8b 40 04             	mov    0x4(%eax),%eax
  8028db:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028de:	8b 12                	mov    (%edx),%edx
  8028e0:	89 10                	mov    %edx,(%eax)
  8028e2:	eb 0a                	jmp    8028ee <alloc_block_BF+0x1a4>
  8028e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028e7:	8b 00                	mov    (%eax),%eax
  8028e9:	a3 48 41 80 00       	mov    %eax,0x804148
  8028ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802901:	a1 54 41 80 00       	mov    0x804154,%eax
  802906:	48                   	dec    %eax
  802907:	a3 54 41 80 00       	mov    %eax,0x804154
	  // setting the size & sva
	  new_block->size = size;
  80290c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80290f:	8b 55 08             	mov    0x8(%ebp),%edx
  802912:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  802915:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802918:	8b 50 08             	mov    0x8(%eax),%edx
  80291b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80291e:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  802921:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802924:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802927:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  80292a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80292d:	8b 50 08             	mov    0x8(%eax),%edx
  802930:	8b 45 08             	mov    0x8(%ebp),%eax
  802933:	01 c2                	add    %eax,%edx
  802935:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802938:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  80293b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80293e:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  802941:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802944:	eb 05                	jmp    80294b <alloc_block_BF+0x201>
	 }
	 return NULL;
  802946:	b8 00 00 00 00       	mov    $0x0,%eax


}
  80294b:	c9                   	leave  
  80294c:	c3                   	ret    

0080294d <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80294d:	55                   	push   %ebp
  80294e:	89 e5                	mov    %esp,%ebp
  802950:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802953:	83 ec 04             	sub    $0x4,%esp
  802956:	68 48 3c 80 00       	push   $0x803c48
  80295b:	68 e8 00 00 00       	push   $0xe8
  802960:	68 b7 3b 80 00       	push   $0x803bb7
  802965:	e8 26 da ff ff       	call   800390 <_panic>

0080296a <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80296a:	55                   	push   %ebp
  80296b:	89 e5                	mov    %esp,%ebp
  80296d:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  802970:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802975:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  802978:	a1 38 41 80 00       	mov    0x804138,%eax
  80297d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  802980:	a1 44 41 80 00       	mov    0x804144,%eax
  802985:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  802988:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80298c:	75 68                	jne    8029f6 <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80298e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802992:	75 17                	jne    8029ab <insert_sorted_with_merge_freeList+0x41>
  802994:	83 ec 04             	sub    $0x4,%esp
  802997:	68 94 3b 80 00       	push   $0x803b94
  80299c:	68 36 01 00 00       	push   $0x136
  8029a1:	68 b7 3b 80 00       	push   $0x803bb7
  8029a6:	e8 e5 d9 ff ff       	call   800390 <_panic>
  8029ab:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8029b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b4:	89 10                	mov    %edx,(%eax)
  8029b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b9:	8b 00                	mov    (%eax),%eax
  8029bb:	85 c0                	test   %eax,%eax
  8029bd:	74 0d                	je     8029cc <insert_sorted_with_merge_freeList+0x62>
  8029bf:	a1 38 41 80 00       	mov    0x804138,%eax
  8029c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8029c7:	89 50 04             	mov    %edx,0x4(%eax)
  8029ca:	eb 08                	jmp    8029d4 <insert_sorted_with_merge_freeList+0x6a>
  8029cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cf:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d7:	a3 38 41 80 00       	mov    %eax,0x804138
  8029dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029e6:	a1 44 41 80 00       	mov    0x804144,%eax
  8029eb:	40                   	inc    %eax
  8029ec:	a3 44 41 80 00       	mov    %eax,0x804144





}
  8029f1:	e9 ba 06 00 00       	jmp    8030b0 <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  8029f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f9:	8b 50 08             	mov    0x8(%eax),%edx
  8029fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802a02:	01 c2                	add    %eax,%edx
  802a04:	8b 45 08             	mov    0x8(%ebp),%eax
  802a07:	8b 40 08             	mov    0x8(%eax),%eax
  802a0a:	39 c2                	cmp    %eax,%edx
  802a0c:	73 68                	jae    802a76 <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802a0e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a12:	75 17                	jne    802a2b <insert_sorted_with_merge_freeList+0xc1>
  802a14:	83 ec 04             	sub    $0x4,%esp
  802a17:	68 d0 3b 80 00       	push   $0x803bd0
  802a1c:	68 3a 01 00 00       	push   $0x13a
  802a21:	68 b7 3b 80 00       	push   $0x803bb7
  802a26:	e8 65 d9 ff ff       	call   800390 <_panic>
  802a2b:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802a31:	8b 45 08             	mov    0x8(%ebp),%eax
  802a34:	89 50 04             	mov    %edx,0x4(%eax)
  802a37:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3a:	8b 40 04             	mov    0x4(%eax),%eax
  802a3d:	85 c0                	test   %eax,%eax
  802a3f:	74 0c                	je     802a4d <insert_sorted_with_merge_freeList+0xe3>
  802a41:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a46:	8b 55 08             	mov    0x8(%ebp),%edx
  802a49:	89 10                	mov    %edx,(%eax)
  802a4b:	eb 08                	jmp    802a55 <insert_sorted_with_merge_freeList+0xeb>
  802a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a50:	a3 38 41 80 00       	mov    %eax,0x804138
  802a55:	8b 45 08             	mov    0x8(%ebp),%eax
  802a58:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a66:	a1 44 41 80 00       	mov    0x804144,%eax
  802a6b:	40                   	inc    %eax
  802a6c:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802a71:	e9 3a 06 00 00       	jmp    8030b0 <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  802a76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a79:	8b 50 08             	mov    0x8(%eax),%edx
  802a7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a7f:	8b 40 0c             	mov    0xc(%eax),%eax
  802a82:	01 c2                	add    %eax,%edx
  802a84:	8b 45 08             	mov    0x8(%ebp),%eax
  802a87:	8b 40 08             	mov    0x8(%eax),%eax
  802a8a:	39 c2                	cmp    %eax,%edx
  802a8c:	0f 85 90 00 00 00    	jne    802b22 <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  802a92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a95:	8b 50 0c             	mov    0xc(%eax),%edx
  802a98:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9b:	8b 40 0c             	mov    0xc(%eax),%eax
  802a9e:	01 c2                	add    %eax,%edx
  802aa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa3:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  802aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  802ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802aba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802abe:	75 17                	jne    802ad7 <insert_sorted_with_merge_freeList+0x16d>
  802ac0:	83 ec 04             	sub    $0x4,%esp
  802ac3:	68 94 3b 80 00       	push   $0x803b94
  802ac8:	68 41 01 00 00       	push   $0x141
  802acd:	68 b7 3b 80 00       	push   $0x803bb7
  802ad2:	e8 b9 d8 ff ff       	call   800390 <_panic>
  802ad7:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802add:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae0:	89 10                	mov    %edx,(%eax)
  802ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae5:	8b 00                	mov    (%eax),%eax
  802ae7:	85 c0                	test   %eax,%eax
  802ae9:	74 0d                	je     802af8 <insert_sorted_with_merge_freeList+0x18e>
  802aeb:	a1 48 41 80 00       	mov    0x804148,%eax
  802af0:	8b 55 08             	mov    0x8(%ebp),%edx
  802af3:	89 50 04             	mov    %edx,0x4(%eax)
  802af6:	eb 08                	jmp    802b00 <insert_sorted_with_merge_freeList+0x196>
  802af8:	8b 45 08             	mov    0x8(%ebp),%eax
  802afb:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b00:	8b 45 08             	mov    0x8(%ebp),%eax
  802b03:	a3 48 41 80 00       	mov    %eax,0x804148
  802b08:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b12:	a1 54 41 80 00       	mov    0x804154,%eax
  802b17:	40                   	inc    %eax
  802b18:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802b1d:	e9 8e 05 00 00       	jmp    8030b0 <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  802b22:	8b 45 08             	mov    0x8(%ebp),%eax
  802b25:	8b 50 08             	mov    0x8(%eax),%edx
  802b28:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b2e:	01 c2                	add    %eax,%edx
  802b30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b33:	8b 40 08             	mov    0x8(%eax),%eax
  802b36:	39 c2                	cmp    %eax,%edx
  802b38:	73 68                	jae    802ba2 <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802b3a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b3e:	75 17                	jne    802b57 <insert_sorted_with_merge_freeList+0x1ed>
  802b40:	83 ec 04             	sub    $0x4,%esp
  802b43:	68 94 3b 80 00       	push   $0x803b94
  802b48:	68 45 01 00 00       	push   $0x145
  802b4d:	68 b7 3b 80 00       	push   $0x803bb7
  802b52:	e8 39 d8 ff ff       	call   800390 <_panic>
  802b57:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b60:	89 10                	mov    %edx,(%eax)
  802b62:	8b 45 08             	mov    0x8(%ebp),%eax
  802b65:	8b 00                	mov    (%eax),%eax
  802b67:	85 c0                	test   %eax,%eax
  802b69:	74 0d                	je     802b78 <insert_sorted_with_merge_freeList+0x20e>
  802b6b:	a1 38 41 80 00       	mov    0x804138,%eax
  802b70:	8b 55 08             	mov    0x8(%ebp),%edx
  802b73:	89 50 04             	mov    %edx,0x4(%eax)
  802b76:	eb 08                	jmp    802b80 <insert_sorted_with_merge_freeList+0x216>
  802b78:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b80:	8b 45 08             	mov    0x8(%ebp),%eax
  802b83:	a3 38 41 80 00       	mov    %eax,0x804138
  802b88:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b92:	a1 44 41 80 00       	mov    0x804144,%eax
  802b97:	40                   	inc    %eax
  802b98:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802b9d:	e9 0e 05 00 00       	jmp    8030b0 <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  802ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba5:	8b 50 08             	mov    0x8(%eax),%edx
  802ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bab:	8b 40 0c             	mov    0xc(%eax),%eax
  802bae:	01 c2                	add    %eax,%edx
  802bb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb3:	8b 40 08             	mov    0x8(%eax),%eax
  802bb6:	39 c2                	cmp    %eax,%edx
  802bb8:	0f 85 9c 00 00 00    	jne    802c5a <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  802bbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bc1:	8b 50 0c             	mov    0xc(%eax),%edx
  802bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc7:	8b 40 0c             	mov    0xc(%eax),%eax
  802bca:	01 c2                	add    %eax,%edx
  802bcc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bcf:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  802bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd5:	8b 50 08             	mov    0x8(%eax),%edx
  802bd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bdb:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  802bde:	8b 45 08             	mov    0x8(%ebp),%eax
  802be1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  802be8:	8b 45 08             	mov    0x8(%ebp),%eax
  802beb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802bf2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bf6:	75 17                	jne    802c0f <insert_sorted_with_merge_freeList+0x2a5>
  802bf8:	83 ec 04             	sub    $0x4,%esp
  802bfb:	68 94 3b 80 00       	push   $0x803b94
  802c00:	68 4d 01 00 00       	push   $0x14d
  802c05:	68 b7 3b 80 00       	push   $0x803bb7
  802c0a:	e8 81 d7 ff ff       	call   800390 <_panic>
  802c0f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c15:	8b 45 08             	mov    0x8(%ebp),%eax
  802c18:	89 10                	mov    %edx,(%eax)
  802c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1d:	8b 00                	mov    (%eax),%eax
  802c1f:	85 c0                	test   %eax,%eax
  802c21:	74 0d                	je     802c30 <insert_sorted_with_merge_freeList+0x2c6>
  802c23:	a1 48 41 80 00       	mov    0x804148,%eax
  802c28:	8b 55 08             	mov    0x8(%ebp),%edx
  802c2b:	89 50 04             	mov    %edx,0x4(%eax)
  802c2e:	eb 08                	jmp    802c38 <insert_sorted_with_merge_freeList+0x2ce>
  802c30:	8b 45 08             	mov    0x8(%ebp),%eax
  802c33:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c38:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3b:	a3 48 41 80 00       	mov    %eax,0x804148
  802c40:	8b 45 08             	mov    0x8(%ebp),%eax
  802c43:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c4a:	a1 54 41 80 00       	mov    0x804154,%eax
  802c4f:	40                   	inc    %eax
  802c50:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802c55:	e9 56 04 00 00       	jmp    8030b0 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802c5a:	a1 38 41 80 00       	mov    0x804138,%eax
  802c5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c62:	e9 19 04 00 00       	jmp    803080 <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  802c67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6a:	8b 00                	mov    (%eax),%eax
  802c6c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c72:	8b 50 08             	mov    0x8(%eax),%edx
  802c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c78:	8b 40 0c             	mov    0xc(%eax),%eax
  802c7b:	01 c2                	add    %eax,%edx
  802c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c80:	8b 40 08             	mov    0x8(%eax),%eax
  802c83:	39 c2                	cmp    %eax,%edx
  802c85:	0f 85 ad 01 00 00    	jne    802e38 <insert_sorted_with_merge_freeList+0x4ce>
  802c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8e:	8b 50 08             	mov    0x8(%eax),%edx
  802c91:	8b 45 08             	mov    0x8(%ebp),%eax
  802c94:	8b 40 0c             	mov    0xc(%eax),%eax
  802c97:	01 c2                	add    %eax,%edx
  802c99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c9c:	8b 40 08             	mov    0x8(%eax),%eax
  802c9f:	39 c2                	cmp    %eax,%edx
  802ca1:	0f 85 91 01 00 00    	jne    802e38 <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  802ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802caa:	8b 50 0c             	mov    0xc(%eax),%edx
  802cad:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb0:	8b 48 0c             	mov    0xc(%eax),%ecx
  802cb3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cb6:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb9:	01 c8                	add    %ecx,%eax
  802cbb:	01 c2                	add    %eax,%edx
  802cbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc0:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  802cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  802cd7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cda:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  802ce1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ce4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  802ceb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802cef:	75 17                	jne    802d08 <insert_sorted_with_merge_freeList+0x39e>
  802cf1:	83 ec 04             	sub    $0x4,%esp
  802cf4:	68 28 3c 80 00       	push   $0x803c28
  802cf9:	68 5b 01 00 00       	push   $0x15b
  802cfe:	68 b7 3b 80 00       	push   $0x803bb7
  802d03:	e8 88 d6 ff ff       	call   800390 <_panic>
  802d08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d0b:	8b 00                	mov    (%eax),%eax
  802d0d:	85 c0                	test   %eax,%eax
  802d0f:	74 10                	je     802d21 <insert_sorted_with_merge_freeList+0x3b7>
  802d11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d14:	8b 00                	mov    (%eax),%eax
  802d16:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d19:	8b 52 04             	mov    0x4(%edx),%edx
  802d1c:	89 50 04             	mov    %edx,0x4(%eax)
  802d1f:	eb 0b                	jmp    802d2c <insert_sorted_with_merge_freeList+0x3c2>
  802d21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d24:	8b 40 04             	mov    0x4(%eax),%eax
  802d27:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d2f:	8b 40 04             	mov    0x4(%eax),%eax
  802d32:	85 c0                	test   %eax,%eax
  802d34:	74 0f                	je     802d45 <insert_sorted_with_merge_freeList+0x3db>
  802d36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d39:	8b 40 04             	mov    0x4(%eax),%eax
  802d3c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d3f:	8b 12                	mov    (%edx),%edx
  802d41:	89 10                	mov    %edx,(%eax)
  802d43:	eb 0a                	jmp    802d4f <insert_sorted_with_merge_freeList+0x3e5>
  802d45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d48:	8b 00                	mov    (%eax),%eax
  802d4a:	a3 38 41 80 00       	mov    %eax,0x804138
  802d4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d52:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d5b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d62:	a1 44 41 80 00       	mov    0x804144,%eax
  802d67:	48                   	dec    %eax
  802d68:	a3 44 41 80 00       	mov    %eax,0x804144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802d6d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d71:	75 17                	jne    802d8a <insert_sorted_with_merge_freeList+0x420>
  802d73:	83 ec 04             	sub    $0x4,%esp
  802d76:	68 94 3b 80 00       	push   $0x803b94
  802d7b:	68 5c 01 00 00       	push   $0x15c
  802d80:	68 b7 3b 80 00       	push   $0x803bb7
  802d85:	e8 06 d6 ff ff       	call   800390 <_panic>
  802d8a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d90:	8b 45 08             	mov    0x8(%ebp),%eax
  802d93:	89 10                	mov    %edx,(%eax)
  802d95:	8b 45 08             	mov    0x8(%ebp),%eax
  802d98:	8b 00                	mov    (%eax),%eax
  802d9a:	85 c0                	test   %eax,%eax
  802d9c:	74 0d                	je     802dab <insert_sorted_with_merge_freeList+0x441>
  802d9e:	a1 48 41 80 00       	mov    0x804148,%eax
  802da3:	8b 55 08             	mov    0x8(%ebp),%edx
  802da6:	89 50 04             	mov    %edx,0x4(%eax)
  802da9:	eb 08                	jmp    802db3 <insert_sorted_with_merge_freeList+0x449>
  802dab:	8b 45 08             	mov    0x8(%ebp),%eax
  802dae:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802db3:	8b 45 08             	mov    0x8(%ebp),%eax
  802db6:	a3 48 41 80 00       	mov    %eax,0x804148
  802dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dc5:	a1 54 41 80 00       	mov    0x804154,%eax
  802dca:	40                   	inc    %eax
  802dcb:	a3 54 41 80 00       	mov    %eax,0x804154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  802dd0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802dd4:	75 17                	jne    802ded <insert_sorted_with_merge_freeList+0x483>
  802dd6:	83 ec 04             	sub    $0x4,%esp
  802dd9:	68 94 3b 80 00       	push   $0x803b94
  802dde:	68 5d 01 00 00       	push   $0x15d
  802de3:	68 b7 3b 80 00       	push   $0x803bb7
  802de8:	e8 a3 d5 ff ff       	call   800390 <_panic>
  802ded:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802df3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802df6:	89 10                	mov    %edx,(%eax)
  802df8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dfb:	8b 00                	mov    (%eax),%eax
  802dfd:	85 c0                	test   %eax,%eax
  802dff:	74 0d                	je     802e0e <insert_sorted_with_merge_freeList+0x4a4>
  802e01:	a1 48 41 80 00       	mov    0x804148,%eax
  802e06:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e09:	89 50 04             	mov    %edx,0x4(%eax)
  802e0c:	eb 08                	jmp    802e16 <insert_sorted_with_merge_freeList+0x4ac>
  802e0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e11:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e19:	a3 48 41 80 00       	mov    %eax,0x804148
  802e1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e21:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e28:	a1 54 41 80 00       	mov    0x804154,%eax
  802e2d:	40                   	inc    %eax
  802e2e:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802e33:	e9 78 02 00 00       	jmp    8030b0 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3b:	8b 50 08             	mov    0x8(%eax),%edx
  802e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e41:	8b 40 0c             	mov    0xc(%eax),%eax
  802e44:	01 c2                	add    %eax,%edx
  802e46:	8b 45 08             	mov    0x8(%ebp),%eax
  802e49:	8b 40 08             	mov    0x8(%eax),%eax
  802e4c:	39 c2                	cmp    %eax,%edx
  802e4e:	0f 83 b8 00 00 00    	jae    802f0c <insert_sorted_with_merge_freeList+0x5a2>
  802e54:	8b 45 08             	mov    0x8(%ebp),%eax
  802e57:	8b 50 08             	mov    0x8(%eax),%edx
  802e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5d:	8b 40 0c             	mov    0xc(%eax),%eax
  802e60:	01 c2                	add    %eax,%edx
  802e62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e65:	8b 40 08             	mov    0x8(%eax),%eax
  802e68:	39 c2                	cmp    %eax,%edx
  802e6a:	0f 85 9c 00 00 00    	jne    802f0c <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  802e70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e73:	8b 50 0c             	mov    0xc(%eax),%edx
  802e76:	8b 45 08             	mov    0x8(%ebp),%eax
  802e79:	8b 40 0c             	mov    0xc(%eax),%eax
  802e7c:	01 c2                	add    %eax,%edx
  802e7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e81:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  802e84:	8b 45 08             	mov    0x8(%ebp),%eax
  802e87:	8b 50 08             	mov    0x8(%eax),%edx
  802e8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e8d:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  802e90:	8b 45 08             	mov    0x8(%ebp),%eax
  802e93:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802ea4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ea8:	75 17                	jne    802ec1 <insert_sorted_with_merge_freeList+0x557>
  802eaa:	83 ec 04             	sub    $0x4,%esp
  802ead:	68 94 3b 80 00       	push   $0x803b94
  802eb2:	68 67 01 00 00       	push   $0x167
  802eb7:	68 b7 3b 80 00       	push   $0x803bb7
  802ebc:	e8 cf d4 ff ff       	call   800390 <_panic>
  802ec1:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eca:	89 10                	mov    %edx,(%eax)
  802ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecf:	8b 00                	mov    (%eax),%eax
  802ed1:	85 c0                	test   %eax,%eax
  802ed3:	74 0d                	je     802ee2 <insert_sorted_with_merge_freeList+0x578>
  802ed5:	a1 48 41 80 00       	mov    0x804148,%eax
  802eda:	8b 55 08             	mov    0x8(%ebp),%edx
  802edd:	89 50 04             	mov    %edx,0x4(%eax)
  802ee0:	eb 08                	jmp    802eea <insert_sorted_with_merge_freeList+0x580>
  802ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802eea:	8b 45 08             	mov    0x8(%ebp),%eax
  802eed:	a3 48 41 80 00       	mov    %eax,0x804148
  802ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802efc:	a1 54 41 80 00       	mov    0x804154,%eax
  802f01:	40                   	inc    %eax
  802f02:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802f07:	e9 a4 01 00 00       	jmp    8030b0 <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0f:	8b 50 08             	mov    0x8(%eax),%edx
  802f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f15:	8b 40 0c             	mov    0xc(%eax),%eax
  802f18:	01 c2                	add    %eax,%edx
  802f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1d:	8b 40 08             	mov    0x8(%eax),%eax
  802f20:	39 c2                	cmp    %eax,%edx
  802f22:	0f 85 ac 00 00 00    	jne    802fd4 <insert_sorted_with_merge_freeList+0x66a>
  802f28:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2b:	8b 50 08             	mov    0x8(%eax),%edx
  802f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f31:	8b 40 0c             	mov    0xc(%eax),%eax
  802f34:	01 c2                	add    %eax,%edx
  802f36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f39:	8b 40 08             	mov    0x8(%eax),%eax
  802f3c:	39 c2                	cmp    %eax,%edx
  802f3e:	0f 83 90 00 00 00    	jae    802fd4 <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  802f44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f47:	8b 50 0c             	mov    0xc(%eax),%edx
  802f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4d:	8b 40 0c             	mov    0xc(%eax),%eax
  802f50:	01 c2                	add    %eax,%edx
  802f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f55:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  802f58:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  802f62:	8b 45 08             	mov    0x8(%ebp),%eax
  802f65:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802f6c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f70:	75 17                	jne    802f89 <insert_sorted_with_merge_freeList+0x61f>
  802f72:	83 ec 04             	sub    $0x4,%esp
  802f75:	68 94 3b 80 00       	push   $0x803b94
  802f7a:	68 70 01 00 00       	push   $0x170
  802f7f:	68 b7 3b 80 00       	push   $0x803bb7
  802f84:	e8 07 d4 ff ff       	call   800390 <_panic>
  802f89:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f92:	89 10                	mov    %edx,(%eax)
  802f94:	8b 45 08             	mov    0x8(%ebp),%eax
  802f97:	8b 00                	mov    (%eax),%eax
  802f99:	85 c0                	test   %eax,%eax
  802f9b:	74 0d                	je     802faa <insert_sorted_with_merge_freeList+0x640>
  802f9d:	a1 48 41 80 00       	mov    0x804148,%eax
  802fa2:	8b 55 08             	mov    0x8(%ebp),%edx
  802fa5:	89 50 04             	mov    %edx,0x4(%eax)
  802fa8:	eb 08                	jmp    802fb2 <insert_sorted_with_merge_freeList+0x648>
  802faa:	8b 45 08             	mov    0x8(%ebp),%eax
  802fad:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb5:	a3 48 41 80 00       	mov    %eax,0x804148
  802fba:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fc4:	a1 54 41 80 00       	mov    0x804154,%eax
  802fc9:	40                   	inc    %eax
  802fca:	a3 54 41 80 00       	mov    %eax,0x804154
	      break;
  802fcf:	e9 dc 00 00 00       	jmp    8030b0 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd7:	8b 50 08             	mov    0x8(%eax),%edx
  802fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdd:	8b 40 0c             	mov    0xc(%eax),%eax
  802fe0:	01 c2                	add    %eax,%edx
  802fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe5:	8b 40 08             	mov    0x8(%eax),%eax
  802fe8:	39 c2                	cmp    %eax,%edx
  802fea:	0f 83 88 00 00 00    	jae    803078 <insert_sorted_with_merge_freeList+0x70e>
  802ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff3:	8b 50 08             	mov    0x8(%eax),%edx
  802ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff9:	8b 40 0c             	mov    0xc(%eax),%eax
  802ffc:	01 c2                	add    %eax,%edx
  802ffe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803001:	8b 40 08             	mov    0x8(%eax),%eax
  803004:	39 c2                	cmp    %eax,%edx
  803006:	73 70                	jae    803078 <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  803008:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80300c:	74 06                	je     803014 <insert_sorted_with_merge_freeList+0x6aa>
  80300e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803012:	75 17                	jne    80302b <insert_sorted_with_merge_freeList+0x6c1>
  803014:	83 ec 04             	sub    $0x4,%esp
  803017:	68 f4 3b 80 00       	push   $0x803bf4
  80301c:	68 75 01 00 00       	push   $0x175
  803021:	68 b7 3b 80 00       	push   $0x803bb7
  803026:	e8 65 d3 ff ff       	call   800390 <_panic>
  80302b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302e:	8b 10                	mov    (%eax),%edx
  803030:	8b 45 08             	mov    0x8(%ebp),%eax
  803033:	89 10                	mov    %edx,(%eax)
  803035:	8b 45 08             	mov    0x8(%ebp),%eax
  803038:	8b 00                	mov    (%eax),%eax
  80303a:	85 c0                	test   %eax,%eax
  80303c:	74 0b                	je     803049 <insert_sorted_with_merge_freeList+0x6df>
  80303e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803041:	8b 00                	mov    (%eax),%eax
  803043:	8b 55 08             	mov    0x8(%ebp),%edx
  803046:	89 50 04             	mov    %edx,0x4(%eax)
  803049:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304c:	8b 55 08             	mov    0x8(%ebp),%edx
  80304f:	89 10                	mov    %edx,(%eax)
  803051:	8b 45 08             	mov    0x8(%ebp),%eax
  803054:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803057:	89 50 04             	mov    %edx,0x4(%eax)
  80305a:	8b 45 08             	mov    0x8(%ebp),%eax
  80305d:	8b 00                	mov    (%eax),%eax
  80305f:	85 c0                	test   %eax,%eax
  803061:	75 08                	jne    80306b <insert_sorted_with_merge_freeList+0x701>
  803063:	8b 45 08             	mov    0x8(%ebp),%eax
  803066:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80306b:	a1 44 41 80 00       	mov    0x804144,%eax
  803070:	40                   	inc    %eax
  803071:	a3 44 41 80 00       	mov    %eax,0x804144
	      break;
  803076:	eb 38                	jmp    8030b0 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  803078:	a1 40 41 80 00       	mov    0x804140,%eax
  80307d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803080:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803084:	74 07                	je     80308d <insert_sorted_with_merge_freeList+0x723>
  803086:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803089:	8b 00                	mov    (%eax),%eax
  80308b:	eb 05                	jmp    803092 <insert_sorted_with_merge_freeList+0x728>
  80308d:	b8 00 00 00 00       	mov    $0x0,%eax
  803092:	a3 40 41 80 00       	mov    %eax,0x804140
  803097:	a1 40 41 80 00       	mov    0x804140,%eax
  80309c:	85 c0                	test   %eax,%eax
  80309e:	0f 85 c3 fb ff ff    	jne    802c67 <insert_sorted_with_merge_freeList+0x2fd>
  8030a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030a8:	0f 85 b9 fb ff ff    	jne    802c67 <insert_sorted_with_merge_freeList+0x2fd>





}
  8030ae:	eb 00                	jmp    8030b0 <insert_sorted_with_merge_freeList+0x746>
  8030b0:	90                   	nop
  8030b1:	c9                   	leave  
  8030b2:	c3                   	ret    
  8030b3:	90                   	nop

008030b4 <__udivdi3>:
  8030b4:	55                   	push   %ebp
  8030b5:	57                   	push   %edi
  8030b6:	56                   	push   %esi
  8030b7:	53                   	push   %ebx
  8030b8:	83 ec 1c             	sub    $0x1c,%esp
  8030bb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8030bf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8030c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8030c7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8030cb:	89 ca                	mov    %ecx,%edx
  8030cd:	89 f8                	mov    %edi,%eax
  8030cf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8030d3:	85 f6                	test   %esi,%esi
  8030d5:	75 2d                	jne    803104 <__udivdi3+0x50>
  8030d7:	39 cf                	cmp    %ecx,%edi
  8030d9:	77 65                	ja     803140 <__udivdi3+0x8c>
  8030db:	89 fd                	mov    %edi,%ebp
  8030dd:	85 ff                	test   %edi,%edi
  8030df:	75 0b                	jne    8030ec <__udivdi3+0x38>
  8030e1:	b8 01 00 00 00       	mov    $0x1,%eax
  8030e6:	31 d2                	xor    %edx,%edx
  8030e8:	f7 f7                	div    %edi
  8030ea:	89 c5                	mov    %eax,%ebp
  8030ec:	31 d2                	xor    %edx,%edx
  8030ee:	89 c8                	mov    %ecx,%eax
  8030f0:	f7 f5                	div    %ebp
  8030f2:	89 c1                	mov    %eax,%ecx
  8030f4:	89 d8                	mov    %ebx,%eax
  8030f6:	f7 f5                	div    %ebp
  8030f8:	89 cf                	mov    %ecx,%edi
  8030fa:	89 fa                	mov    %edi,%edx
  8030fc:	83 c4 1c             	add    $0x1c,%esp
  8030ff:	5b                   	pop    %ebx
  803100:	5e                   	pop    %esi
  803101:	5f                   	pop    %edi
  803102:	5d                   	pop    %ebp
  803103:	c3                   	ret    
  803104:	39 ce                	cmp    %ecx,%esi
  803106:	77 28                	ja     803130 <__udivdi3+0x7c>
  803108:	0f bd fe             	bsr    %esi,%edi
  80310b:	83 f7 1f             	xor    $0x1f,%edi
  80310e:	75 40                	jne    803150 <__udivdi3+0x9c>
  803110:	39 ce                	cmp    %ecx,%esi
  803112:	72 0a                	jb     80311e <__udivdi3+0x6a>
  803114:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803118:	0f 87 9e 00 00 00    	ja     8031bc <__udivdi3+0x108>
  80311e:	b8 01 00 00 00       	mov    $0x1,%eax
  803123:	89 fa                	mov    %edi,%edx
  803125:	83 c4 1c             	add    $0x1c,%esp
  803128:	5b                   	pop    %ebx
  803129:	5e                   	pop    %esi
  80312a:	5f                   	pop    %edi
  80312b:	5d                   	pop    %ebp
  80312c:	c3                   	ret    
  80312d:	8d 76 00             	lea    0x0(%esi),%esi
  803130:	31 ff                	xor    %edi,%edi
  803132:	31 c0                	xor    %eax,%eax
  803134:	89 fa                	mov    %edi,%edx
  803136:	83 c4 1c             	add    $0x1c,%esp
  803139:	5b                   	pop    %ebx
  80313a:	5e                   	pop    %esi
  80313b:	5f                   	pop    %edi
  80313c:	5d                   	pop    %ebp
  80313d:	c3                   	ret    
  80313e:	66 90                	xchg   %ax,%ax
  803140:	89 d8                	mov    %ebx,%eax
  803142:	f7 f7                	div    %edi
  803144:	31 ff                	xor    %edi,%edi
  803146:	89 fa                	mov    %edi,%edx
  803148:	83 c4 1c             	add    $0x1c,%esp
  80314b:	5b                   	pop    %ebx
  80314c:	5e                   	pop    %esi
  80314d:	5f                   	pop    %edi
  80314e:	5d                   	pop    %ebp
  80314f:	c3                   	ret    
  803150:	bd 20 00 00 00       	mov    $0x20,%ebp
  803155:	89 eb                	mov    %ebp,%ebx
  803157:	29 fb                	sub    %edi,%ebx
  803159:	89 f9                	mov    %edi,%ecx
  80315b:	d3 e6                	shl    %cl,%esi
  80315d:	89 c5                	mov    %eax,%ebp
  80315f:	88 d9                	mov    %bl,%cl
  803161:	d3 ed                	shr    %cl,%ebp
  803163:	89 e9                	mov    %ebp,%ecx
  803165:	09 f1                	or     %esi,%ecx
  803167:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80316b:	89 f9                	mov    %edi,%ecx
  80316d:	d3 e0                	shl    %cl,%eax
  80316f:	89 c5                	mov    %eax,%ebp
  803171:	89 d6                	mov    %edx,%esi
  803173:	88 d9                	mov    %bl,%cl
  803175:	d3 ee                	shr    %cl,%esi
  803177:	89 f9                	mov    %edi,%ecx
  803179:	d3 e2                	shl    %cl,%edx
  80317b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80317f:	88 d9                	mov    %bl,%cl
  803181:	d3 e8                	shr    %cl,%eax
  803183:	09 c2                	or     %eax,%edx
  803185:	89 d0                	mov    %edx,%eax
  803187:	89 f2                	mov    %esi,%edx
  803189:	f7 74 24 0c          	divl   0xc(%esp)
  80318d:	89 d6                	mov    %edx,%esi
  80318f:	89 c3                	mov    %eax,%ebx
  803191:	f7 e5                	mul    %ebp
  803193:	39 d6                	cmp    %edx,%esi
  803195:	72 19                	jb     8031b0 <__udivdi3+0xfc>
  803197:	74 0b                	je     8031a4 <__udivdi3+0xf0>
  803199:	89 d8                	mov    %ebx,%eax
  80319b:	31 ff                	xor    %edi,%edi
  80319d:	e9 58 ff ff ff       	jmp    8030fa <__udivdi3+0x46>
  8031a2:	66 90                	xchg   %ax,%ax
  8031a4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8031a8:	89 f9                	mov    %edi,%ecx
  8031aa:	d3 e2                	shl    %cl,%edx
  8031ac:	39 c2                	cmp    %eax,%edx
  8031ae:	73 e9                	jae    803199 <__udivdi3+0xe5>
  8031b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8031b3:	31 ff                	xor    %edi,%edi
  8031b5:	e9 40 ff ff ff       	jmp    8030fa <__udivdi3+0x46>
  8031ba:	66 90                	xchg   %ax,%ax
  8031bc:	31 c0                	xor    %eax,%eax
  8031be:	e9 37 ff ff ff       	jmp    8030fa <__udivdi3+0x46>
  8031c3:	90                   	nop

008031c4 <__umoddi3>:
  8031c4:	55                   	push   %ebp
  8031c5:	57                   	push   %edi
  8031c6:	56                   	push   %esi
  8031c7:	53                   	push   %ebx
  8031c8:	83 ec 1c             	sub    $0x1c,%esp
  8031cb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8031cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8031d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8031d7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8031db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8031df:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8031e3:	89 f3                	mov    %esi,%ebx
  8031e5:	89 fa                	mov    %edi,%edx
  8031e7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8031eb:	89 34 24             	mov    %esi,(%esp)
  8031ee:	85 c0                	test   %eax,%eax
  8031f0:	75 1a                	jne    80320c <__umoddi3+0x48>
  8031f2:	39 f7                	cmp    %esi,%edi
  8031f4:	0f 86 a2 00 00 00    	jbe    80329c <__umoddi3+0xd8>
  8031fa:	89 c8                	mov    %ecx,%eax
  8031fc:	89 f2                	mov    %esi,%edx
  8031fe:	f7 f7                	div    %edi
  803200:	89 d0                	mov    %edx,%eax
  803202:	31 d2                	xor    %edx,%edx
  803204:	83 c4 1c             	add    $0x1c,%esp
  803207:	5b                   	pop    %ebx
  803208:	5e                   	pop    %esi
  803209:	5f                   	pop    %edi
  80320a:	5d                   	pop    %ebp
  80320b:	c3                   	ret    
  80320c:	39 f0                	cmp    %esi,%eax
  80320e:	0f 87 ac 00 00 00    	ja     8032c0 <__umoddi3+0xfc>
  803214:	0f bd e8             	bsr    %eax,%ebp
  803217:	83 f5 1f             	xor    $0x1f,%ebp
  80321a:	0f 84 ac 00 00 00    	je     8032cc <__umoddi3+0x108>
  803220:	bf 20 00 00 00       	mov    $0x20,%edi
  803225:	29 ef                	sub    %ebp,%edi
  803227:	89 fe                	mov    %edi,%esi
  803229:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80322d:	89 e9                	mov    %ebp,%ecx
  80322f:	d3 e0                	shl    %cl,%eax
  803231:	89 d7                	mov    %edx,%edi
  803233:	89 f1                	mov    %esi,%ecx
  803235:	d3 ef                	shr    %cl,%edi
  803237:	09 c7                	or     %eax,%edi
  803239:	89 e9                	mov    %ebp,%ecx
  80323b:	d3 e2                	shl    %cl,%edx
  80323d:	89 14 24             	mov    %edx,(%esp)
  803240:	89 d8                	mov    %ebx,%eax
  803242:	d3 e0                	shl    %cl,%eax
  803244:	89 c2                	mov    %eax,%edx
  803246:	8b 44 24 08          	mov    0x8(%esp),%eax
  80324a:	d3 e0                	shl    %cl,%eax
  80324c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803250:	8b 44 24 08          	mov    0x8(%esp),%eax
  803254:	89 f1                	mov    %esi,%ecx
  803256:	d3 e8                	shr    %cl,%eax
  803258:	09 d0                	or     %edx,%eax
  80325a:	d3 eb                	shr    %cl,%ebx
  80325c:	89 da                	mov    %ebx,%edx
  80325e:	f7 f7                	div    %edi
  803260:	89 d3                	mov    %edx,%ebx
  803262:	f7 24 24             	mull   (%esp)
  803265:	89 c6                	mov    %eax,%esi
  803267:	89 d1                	mov    %edx,%ecx
  803269:	39 d3                	cmp    %edx,%ebx
  80326b:	0f 82 87 00 00 00    	jb     8032f8 <__umoddi3+0x134>
  803271:	0f 84 91 00 00 00    	je     803308 <__umoddi3+0x144>
  803277:	8b 54 24 04          	mov    0x4(%esp),%edx
  80327b:	29 f2                	sub    %esi,%edx
  80327d:	19 cb                	sbb    %ecx,%ebx
  80327f:	89 d8                	mov    %ebx,%eax
  803281:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803285:	d3 e0                	shl    %cl,%eax
  803287:	89 e9                	mov    %ebp,%ecx
  803289:	d3 ea                	shr    %cl,%edx
  80328b:	09 d0                	or     %edx,%eax
  80328d:	89 e9                	mov    %ebp,%ecx
  80328f:	d3 eb                	shr    %cl,%ebx
  803291:	89 da                	mov    %ebx,%edx
  803293:	83 c4 1c             	add    $0x1c,%esp
  803296:	5b                   	pop    %ebx
  803297:	5e                   	pop    %esi
  803298:	5f                   	pop    %edi
  803299:	5d                   	pop    %ebp
  80329a:	c3                   	ret    
  80329b:	90                   	nop
  80329c:	89 fd                	mov    %edi,%ebp
  80329e:	85 ff                	test   %edi,%edi
  8032a0:	75 0b                	jne    8032ad <__umoddi3+0xe9>
  8032a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8032a7:	31 d2                	xor    %edx,%edx
  8032a9:	f7 f7                	div    %edi
  8032ab:	89 c5                	mov    %eax,%ebp
  8032ad:	89 f0                	mov    %esi,%eax
  8032af:	31 d2                	xor    %edx,%edx
  8032b1:	f7 f5                	div    %ebp
  8032b3:	89 c8                	mov    %ecx,%eax
  8032b5:	f7 f5                	div    %ebp
  8032b7:	89 d0                	mov    %edx,%eax
  8032b9:	e9 44 ff ff ff       	jmp    803202 <__umoddi3+0x3e>
  8032be:	66 90                	xchg   %ax,%ax
  8032c0:	89 c8                	mov    %ecx,%eax
  8032c2:	89 f2                	mov    %esi,%edx
  8032c4:	83 c4 1c             	add    $0x1c,%esp
  8032c7:	5b                   	pop    %ebx
  8032c8:	5e                   	pop    %esi
  8032c9:	5f                   	pop    %edi
  8032ca:	5d                   	pop    %ebp
  8032cb:	c3                   	ret    
  8032cc:	3b 04 24             	cmp    (%esp),%eax
  8032cf:	72 06                	jb     8032d7 <__umoddi3+0x113>
  8032d1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8032d5:	77 0f                	ja     8032e6 <__umoddi3+0x122>
  8032d7:	89 f2                	mov    %esi,%edx
  8032d9:	29 f9                	sub    %edi,%ecx
  8032db:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8032df:	89 14 24             	mov    %edx,(%esp)
  8032e2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8032e6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8032ea:	8b 14 24             	mov    (%esp),%edx
  8032ed:	83 c4 1c             	add    $0x1c,%esp
  8032f0:	5b                   	pop    %ebx
  8032f1:	5e                   	pop    %esi
  8032f2:	5f                   	pop    %edi
  8032f3:	5d                   	pop    %ebp
  8032f4:	c3                   	ret    
  8032f5:	8d 76 00             	lea    0x0(%esi),%esi
  8032f8:	2b 04 24             	sub    (%esp),%eax
  8032fb:	19 fa                	sbb    %edi,%edx
  8032fd:	89 d1                	mov    %edx,%ecx
  8032ff:	89 c6                	mov    %eax,%esi
  803301:	e9 71 ff ff ff       	jmp    803277 <__umoddi3+0xb3>
  803306:	66 90                	xchg   %ax,%ax
  803308:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80330c:	72 ea                	jb     8032f8 <__umoddi3+0x134>
  80330e:	89 d9                	mov    %ebx,%ecx
  803310:	e9 62 ff ff ff       	jmp    803277 <__umoddi3+0xb3>
