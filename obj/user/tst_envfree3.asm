
obj/user/tst_envfree3:     file format elf32-i386


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
  800031:	e8 5f 01 00 00       	call   800195 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests the usage of shared variables
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	// Testing scenario 3: Freeing the allocated shared variables [covers: smalloc (1 env) & sget (multiple envs)]
	// Testing removing the shared variables
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 20 33 80 00       	push   $0x803320
  80004a:	e8 2b 16 00 00       	call   80167a <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 da 18 00 00       	call   80193d <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 72 19 00 00       	call   8019dd <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 30 33 80 00       	push   $0x803330
  800079:	e8 07 05 00 00       	call   800585 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr1", 2000,(myEnv->SecondListSize), 50);
  800081:	a1 20 40 80 00       	mov    0x804020,%eax
  800086:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	68 d0 07 00 00       	push   $0x7d0
  800094:	68 63 33 80 00       	push   $0x803363
  800099:	e8 11 1b 00 00       	call   801baf <sys_create_env>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int32 envIdProcessB = sys_create_env("ef_tshr2", 2000,(myEnv->SecondListSize), 50);
  8000a4:	a1 20 40 80 00       	mov    0x804020,%eax
  8000a9:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000af:	6a 32                	push   $0x32
  8000b1:	50                   	push   %eax
  8000b2:	68 d0 07 00 00       	push   $0x7d0
  8000b7:	68 6c 33 80 00       	push   $0x80336c
  8000bc:	e8 ee 1a 00 00       	call   801baf <sys_create_env>
  8000c1:	83 c4 10             	add    $0x10,%esp
  8000c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	sys_run_env(envIdProcessA);
  8000c7:	83 ec 0c             	sub    $0xc,%esp
  8000ca:	ff 75 e8             	pushl  -0x18(%ebp)
  8000cd:	e8 fb 1a 00 00       	call   801bcd <sys_run_env>
  8000d2:	83 c4 10             	add    $0x10,%esp
	env_sleep(5000) ;
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	68 88 13 00 00       	push   $0x1388
  8000dd:	e8 12 2f 00 00       	call   802ff4 <env_sleep>
  8000e2:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000eb:	e8 dd 1a 00 00       	call   801bcd <sys_run_env>
  8000f0:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  8000f3:	90                   	nop
  8000f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000f7:	8b 00                	mov    (%eax),%eax
  8000f9:	83 f8 02             	cmp    $0x2,%eax
  8000fc:	75 f6                	jne    8000f4 <_main+0xbc>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000fe:	e8 3a 18 00 00       	call   80193d <sys_calculate_free_frames>
  800103:	83 ec 08             	sub    $0x8,%esp
  800106:	50                   	push   %eax
  800107:	68 78 33 80 00       	push   $0x803378
  80010c:	e8 74 04 00 00       	call   800585 <cprintf>
  800111:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	ff 75 e8             	pushl  -0x18(%ebp)
  80011a:	e8 ca 1a 00 00       	call   801be9 <sys_destroy_env>
  80011f:	83 c4 10             	add    $0x10,%esp
	sys_destroy_env(envIdProcessB);
  800122:	83 ec 0c             	sub    $0xc,%esp
  800125:	ff 75 e4             	pushl  -0x1c(%ebp)
  800128:	e8 bc 1a 00 00       	call   801be9 <sys_destroy_env>
  80012d:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  800130:	e8 08 18 00 00       	call   80193d <sys_calculate_free_frames>
  800135:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800138:	e8 a0 18 00 00       	call   8019dd <sys_pf_calculate_allocated_pages>
  80013d:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  800140:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800143:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800146:	74 27                	je     80016f <_main+0x137>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  800148:	83 ec 08             	sub    $0x8,%esp
  80014b:	ff 75 e0             	pushl  -0x20(%ebp)
  80014e:	68 ac 33 80 00       	push   $0x8033ac
  800153:	e8 2d 04 00 00       	call   800585 <cprintf>
  800158:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  80015b:	83 ec 04             	sub    $0x4,%esp
  80015e:	68 fc 33 80 00       	push   $0x8033fc
  800163:	6a 23                	push   $0x23
  800165:	68 32 34 80 00       	push   $0x803432
  80016a:	e8 62 01 00 00       	call   8002d1 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80016f:	83 ec 08             	sub    $0x8,%esp
  800172:	ff 75 e0             	pushl  -0x20(%ebp)
  800175:	68 48 34 80 00       	push   $0x803448
  80017a:	e8 06 04 00 00       	call   800585 <cprintf>
  80017f:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 3 for envfree completed successfully.\n");
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	68 a8 34 80 00       	push   $0x8034a8
  80018a:	e8 f6 03 00 00       	call   800585 <cprintf>
  80018f:	83 c4 10             	add    $0x10,%esp
	return;
  800192:	90                   	nop
}
  800193:	c9                   	leave  
  800194:	c3                   	ret    

00800195 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800195:	55                   	push   %ebp
  800196:	89 e5                	mov    %esp,%ebp
  800198:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80019b:	e8 7d 1a 00 00       	call   801c1d <sys_getenvindex>
  8001a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001a6:	89 d0                	mov    %edx,%eax
  8001a8:	c1 e0 03             	shl    $0x3,%eax
  8001ab:	01 d0                	add    %edx,%eax
  8001ad:	01 c0                	add    %eax,%eax
  8001af:	01 d0                	add    %edx,%eax
  8001b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001b8:	01 d0                	add    %edx,%eax
  8001ba:	c1 e0 04             	shl    $0x4,%eax
  8001bd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001c2:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001c7:	a1 20 40 80 00       	mov    0x804020,%eax
  8001cc:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001d2:	84 c0                	test   %al,%al
  8001d4:	74 0f                	je     8001e5 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001d6:	a1 20 40 80 00       	mov    0x804020,%eax
  8001db:	05 5c 05 00 00       	add    $0x55c,%eax
  8001e0:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001e5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001e9:	7e 0a                	jle    8001f5 <libmain+0x60>
		binaryname = argv[0];
  8001eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ee:	8b 00                	mov    (%eax),%eax
  8001f0:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001f5:	83 ec 08             	sub    $0x8,%esp
  8001f8:	ff 75 0c             	pushl  0xc(%ebp)
  8001fb:	ff 75 08             	pushl  0x8(%ebp)
  8001fe:	e8 35 fe ff ff       	call   800038 <_main>
  800203:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800206:	e8 1f 18 00 00       	call   801a2a <sys_disable_interrupt>
	cprintf("**************************************\n");
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	68 0c 35 80 00       	push   $0x80350c
  800213:	e8 6d 03 00 00       	call   800585 <cprintf>
  800218:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80021b:	a1 20 40 80 00       	mov    0x804020,%eax
  800220:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800226:	a1 20 40 80 00       	mov    0x804020,%eax
  80022b:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800231:	83 ec 04             	sub    $0x4,%esp
  800234:	52                   	push   %edx
  800235:	50                   	push   %eax
  800236:	68 34 35 80 00       	push   $0x803534
  80023b:	e8 45 03 00 00       	call   800585 <cprintf>
  800240:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800243:	a1 20 40 80 00       	mov    0x804020,%eax
  800248:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80024e:	a1 20 40 80 00       	mov    0x804020,%eax
  800253:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800259:	a1 20 40 80 00       	mov    0x804020,%eax
  80025e:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800264:	51                   	push   %ecx
  800265:	52                   	push   %edx
  800266:	50                   	push   %eax
  800267:	68 5c 35 80 00       	push   $0x80355c
  80026c:	e8 14 03 00 00       	call   800585 <cprintf>
  800271:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800274:	a1 20 40 80 00       	mov    0x804020,%eax
  800279:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80027f:	83 ec 08             	sub    $0x8,%esp
  800282:	50                   	push   %eax
  800283:	68 b4 35 80 00       	push   $0x8035b4
  800288:	e8 f8 02 00 00       	call   800585 <cprintf>
  80028d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800290:	83 ec 0c             	sub    $0xc,%esp
  800293:	68 0c 35 80 00       	push   $0x80350c
  800298:	e8 e8 02 00 00       	call   800585 <cprintf>
  80029d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002a0:	e8 9f 17 00 00       	call   801a44 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002a5:	e8 19 00 00 00       	call   8002c3 <exit>
}
  8002aa:	90                   	nop
  8002ab:	c9                   	leave  
  8002ac:	c3                   	ret    

008002ad <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002ad:	55                   	push   %ebp
  8002ae:	89 e5                	mov    %esp,%ebp
  8002b0:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002b3:	83 ec 0c             	sub    $0xc,%esp
  8002b6:	6a 00                	push   $0x0
  8002b8:	e8 2c 19 00 00       	call   801be9 <sys_destroy_env>
  8002bd:	83 c4 10             	add    $0x10,%esp
}
  8002c0:	90                   	nop
  8002c1:	c9                   	leave  
  8002c2:	c3                   	ret    

008002c3 <exit>:

void
exit(void)
{
  8002c3:	55                   	push   %ebp
  8002c4:	89 e5                	mov    %esp,%ebp
  8002c6:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002c9:	e8 81 19 00 00       	call   801c4f <sys_exit_env>
}
  8002ce:	90                   	nop
  8002cf:	c9                   	leave  
  8002d0:	c3                   	ret    

008002d1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002d1:	55                   	push   %ebp
  8002d2:	89 e5                	mov    %esp,%ebp
  8002d4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002d7:	8d 45 10             	lea    0x10(%ebp),%eax
  8002da:	83 c0 04             	add    $0x4,%eax
  8002dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002e0:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002e5:	85 c0                	test   %eax,%eax
  8002e7:	74 16                	je     8002ff <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002e9:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002ee:	83 ec 08             	sub    $0x8,%esp
  8002f1:	50                   	push   %eax
  8002f2:	68 c8 35 80 00       	push   $0x8035c8
  8002f7:	e8 89 02 00 00       	call   800585 <cprintf>
  8002fc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002ff:	a1 00 40 80 00       	mov    0x804000,%eax
  800304:	ff 75 0c             	pushl  0xc(%ebp)
  800307:	ff 75 08             	pushl  0x8(%ebp)
  80030a:	50                   	push   %eax
  80030b:	68 cd 35 80 00       	push   $0x8035cd
  800310:	e8 70 02 00 00       	call   800585 <cprintf>
  800315:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800318:	8b 45 10             	mov    0x10(%ebp),%eax
  80031b:	83 ec 08             	sub    $0x8,%esp
  80031e:	ff 75 f4             	pushl  -0xc(%ebp)
  800321:	50                   	push   %eax
  800322:	e8 f3 01 00 00       	call   80051a <vcprintf>
  800327:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80032a:	83 ec 08             	sub    $0x8,%esp
  80032d:	6a 00                	push   $0x0
  80032f:	68 e9 35 80 00       	push   $0x8035e9
  800334:	e8 e1 01 00 00       	call   80051a <vcprintf>
  800339:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80033c:	e8 82 ff ff ff       	call   8002c3 <exit>

	// should not return here
	while (1) ;
  800341:	eb fe                	jmp    800341 <_panic+0x70>

00800343 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800343:	55                   	push   %ebp
  800344:	89 e5                	mov    %esp,%ebp
  800346:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800349:	a1 20 40 80 00       	mov    0x804020,%eax
  80034e:	8b 50 74             	mov    0x74(%eax),%edx
  800351:	8b 45 0c             	mov    0xc(%ebp),%eax
  800354:	39 c2                	cmp    %eax,%edx
  800356:	74 14                	je     80036c <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800358:	83 ec 04             	sub    $0x4,%esp
  80035b:	68 ec 35 80 00       	push   $0x8035ec
  800360:	6a 26                	push   $0x26
  800362:	68 38 36 80 00       	push   $0x803638
  800367:	e8 65 ff ff ff       	call   8002d1 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80036c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800373:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80037a:	e9 c2 00 00 00       	jmp    800441 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80037f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800382:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800389:	8b 45 08             	mov    0x8(%ebp),%eax
  80038c:	01 d0                	add    %edx,%eax
  80038e:	8b 00                	mov    (%eax),%eax
  800390:	85 c0                	test   %eax,%eax
  800392:	75 08                	jne    80039c <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800394:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800397:	e9 a2 00 00 00       	jmp    80043e <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80039c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003a3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003aa:	eb 69                	jmp    800415 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003ac:	a1 20 40 80 00       	mov    0x804020,%eax
  8003b1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003b7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003ba:	89 d0                	mov    %edx,%eax
  8003bc:	01 c0                	add    %eax,%eax
  8003be:	01 d0                	add    %edx,%eax
  8003c0:	c1 e0 03             	shl    $0x3,%eax
  8003c3:	01 c8                	add    %ecx,%eax
  8003c5:	8a 40 04             	mov    0x4(%eax),%al
  8003c8:	84 c0                	test   %al,%al
  8003ca:	75 46                	jne    800412 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003cc:	a1 20 40 80 00       	mov    0x804020,%eax
  8003d1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003d7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003da:	89 d0                	mov    %edx,%eax
  8003dc:	01 c0                	add    %eax,%eax
  8003de:	01 d0                	add    %edx,%eax
  8003e0:	c1 e0 03             	shl    $0x3,%eax
  8003e3:	01 c8                	add    %ecx,%eax
  8003e5:	8b 00                	mov    (%eax),%eax
  8003e7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003ed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003f2:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f7:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800401:	01 c8                	add    %ecx,%eax
  800403:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800405:	39 c2                	cmp    %eax,%edx
  800407:	75 09                	jne    800412 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800409:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800410:	eb 12                	jmp    800424 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800412:	ff 45 e8             	incl   -0x18(%ebp)
  800415:	a1 20 40 80 00       	mov    0x804020,%eax
  80041a:	8b 50 74             	mov    0x74(%eax),%edx
  80041d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800420:	39 c2                	cmp    %eax,%edx
  800422:	77 88                	ja     8003ac <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800424:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800428:	75 14                	jne    80043e <CheckWSWithoutLastIndex+0xfb>
			panic(
  80042a:	83 ec 04             	sub    $0x4,%esp
  80042d:	68 44 36 80 00       	push   $0x803644
  800432:	6a 3a                	push   $0x3a
  800434:	68 38 36 80 00       	push   $0x803638
  800439:	e8 93 fe ff ff       	call   8002d1 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80043e:	ff 45 f0             	incl   -0x10(%ebp)
  800441:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800444:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800447:	0f 8c 32 ff ff ff    	jl     80037f <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80044d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800454:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80045b:	eb 26                	jmp    800483 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80045d:	a1 20 40 80 00       	mov    0x804020,%eax
  800462:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800468:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80046b:	89 d0                	mov    %edx,%eax
  80046d:	01 c0                	add    %eax,%eax
  80046f:	01 d0                	add    %edx,%eax
  800471:	c1 e0 03             	shl    $0x3,%eax
  800474:	01 c8                	add    %ecx,%eax
  800476:	8a 40 04             	mov    0x4(%eax),%al
  800479:	3c 01                	cmp    $0x1,%al
  80047b:	75 03                	jne    800480 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80047d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800480:	ff 45 e0             	incl   -0x20(%ebp)
  800483:	a1 20 40 80 00       	mov    0x804020,%eax
  800488:	8b 50 74             	mov    0x74(%eax),%edx
  80048b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80048e:	39 c2                	cmp    %eax,%edx
  800490:	77 cb                	ja     80045d <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800492:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800495:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800498:	74 14                	je     8004ae <CheckWSWithoutLastIndex+0x16b>
		panic(
  80049a:	83 ec 04             	sub    $0x4,%esp
  80049d:	68 98 36 80 00       	push   $0x803698
  8004a2:	6a 44                	push   $0x44
  8004a4:	68 38 36 80 00       	push   $0x803638
  8004a9:	e8 23 fe ff ff       	call   8002d1 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004ae:	90                   	nop
  8004af:	c9                   	leave  
  8004b0:	c3                   	ret    

008004b1 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8004b1:	55                   	push   %ebp
  8004b2:	89 e5                	mov    %esp,%ebp
  8004b4:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ba:	8b 00                	mov    (%eax),%eax
  8004bc:	8d 48 01             	lea    0x1(%eax),%ecx
  8004bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c2:	89 0a                	mov    %ecx,(%edx)
  8004c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8004c7:	88 d1                	mov    %dl,%cl
  8004c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004cc:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d3:	8b 00                	mov    (%eax),%eax
  8004d5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004da:	75 2c                	jne    800508 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004dc:	a0 24 40 80 00       	mov    0x804024,%al
  8004e1:	0f b6 c0             	movzbl %al,%eax
  8004e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004e7:	8b 12                	mov    (%edx),%edx
  8004e9:	89 d1                	mov    %edx,%ecx
  8004eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ee:	83 c2 08             	add    $0x8,%edx
  8004f1:	83 ec 04             	sub    $0x4,%esp
  8004f4:	50                   	push   %eax
  8004f5:	51                   	push   %ecx
  8004f6:	52                   	push   %edx
  8004f7:	e8 80 13 00 00       	call   80187c <sys_cputs>
  8004fc:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800502:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800508:	8b 45 0c             	mov    0xc(%ebp),%eax
  80050b:	8b 40 04             	mov    0x4(%eax),%eax
  80050e:	8d 50 01             	lea    0x1(%eax),%edx
  800511:	8b 45 0c             	mov    0xc(%ebp),%eax
  800514:	89 50 04             	mov    %edx,0x4(%eax)
}
  800517:	90                   	nop
  800518:	c9                   	leave  
  800519:	c3                   	ret    

0080051a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80051a:	55                   	push   %ebp
  80051b:	89 e5                	mov    %esp,%ebp
  80051d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800523:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80052a:	00 00 00 
	b.cnt = 0;
  80052d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800534:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800537:	ff 75 0c             	pushl  0xc(%ebp)
  80053a:	ff 75 08             	pushl  0x8(%ebp)
  80053d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800543:	50                   	push   %eax
  800544:	68 b1 04 80 00       	push   $0x8004b1
  800549:	e8 11 02 00 00       	call   80075f <vprintfmt>
  80054e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800551:	a0 24 40 80 00       	mov    0x804024,%al
  800556:	0f b6 c0             	movzbl %al,%eax
  800559:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80055f:	83 ec 04             	sub    $0x4,%esp
  800562:	50                   	push   %eax
  800563:	52                   	push   %edx
  800564:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80056a:	83 c0 08             	add    $0x8,%eax
  80056d:	50                   	push   %eax
  80056e:	e8 09 13 00 00       	call   80187c <sys_cputs>
  800573:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800576:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80057d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800583:	c9                   	leave  
  800584:	c3                   	ret    

00800585 <cprintf>:

int cprintf(const char *fmt, ...) {
  800585:	55                   	push   %ebp
  800586:	89 e5                	mov    %esp,%ebp
  800588:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80058b:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800592:	8d 45 0c             	lea    0xc(%ebp),%eax
  800595:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800598:	8b 45 08             	mov    0x8(%ebp),%eax
  80059b:	83 ec 08             	sub    $0x8,%esp
  80059e:	ff 75 f4             	pushl  -0xc(%ebp)
  8005a1:	50                   	push   %eax
  8005a2:	e8 73 ff ff ff       	call   80051a <vcprintf>
  8005a7:	83 c4 10             	add    $0x10,%esp
  8005aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005b0:	c9                   	leave  
  8005b1:	c3                   	ret    

008005b2 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8005b2:	55                   	push   %ebp
  8005b3:	89 e5                	mov    %esp,%ebp
  8005b5:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005b8:	e8 6d 14 00 00       	call   801a2a <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005bd:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c6:	83 ec 08             	sub    $0x8,%esp
  8005c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8005cc:	50                   	push   %eax
  8005cd:	e8 48 ff ff ff       	call   80051a <vcprintf>
  8005d2:	83 c4 10             	add    $0x10,%esp
  8005d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005d8:	e8 67 14 00 00       	call   801a44 <sys_enable_interrupt>
	return cnt;
  8005dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005e0:	c9                   	leave  
  8005e1:	c3                   	ret    

008005e2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005e2:	55                   	push   %ebp
  8005e3:	89 e5                	mov    %esp,%ebp
  8005e5:	53                   	push   %ebx
  8005e6:	83 ec 14             	sub    $0x14,%esp
  8005e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005f5:	8b 45 18             	mov    0x18(%ebp),%eax
  8005f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fd:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800600:	77 55                	ja     800657 <printnum+0x75>
  800602:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800605:	72 05                	jb     80060c <printnum+0x2a>
  800607:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80060a:	77 4b                	ja     800657 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80060c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80060f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800612:	8b 45 18             	mov    0x18(%ebp),%eax
  800615:	ba 00 00 00 00       	mov    $0x0,%edx
  80061a:	52                   	push   %edx
  80061b:	50                   	push   %eax
  80061c:	ff 75 f4             	pushl  -0xc(%ebp)
  80061f:	ff 75 f0             	pushl  -0x10(%ebp)
  800622:	e8 81 2a 00 00       	call   8030a8 <__udivdi3>
  800627:	83 c4 10             	add    $0x10,%esp
  80062a:	83 ec 04             	sub    $0x4,%esp
  80062d:	ff 75 20             	pushl  0x20(%ebp)
  800630:	53                   	push   %ebx
  800631:	ff 75 18             	pushl  0x18(%ebp)
  800634:	52                   	push   %edx
  800635:	50                   	push   %eax
  800636:	ff 75 0c             	pushl  0xc(%ebp)
  800639:	ff 75 08             	pushl  0x8(%ebp)
  80063c:	e8 a1 ff ff ff       	call   8005e2 <printnum>
  800641:	83 c4 20             	add    $0x20,%esp
  800644:	eb 1a                	jmp    800660 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800646:	83 ec 08             	sub    $0x8,%esp
  800649:	ff 75 0c             	pushl  0xc(%ebp)
  80064c:	ff 75 20             	pushl  0x20(%ebp)
  80064f:	8b 45 08             	mov    0x8(%ebp),%eax
  800652:	ff d0                	call   *%eax
  800654:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800657:	ff 4d 1c             	decl   0x1c(%ebp)
  80065a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80065e:	7f e6                	jg     800646 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800660:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800663:	bb 00 00 00 00       	mov    $0x0,%ebx
  800668:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80066b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80066e:	53                   	push   %ebx
  80066f:	51                   	push   %ecx
  800670:	52                   	push   %edx
  800671:	50                   	push   %eax
  800672:	e8 41 2b 00 00       	call   8031b8 <__umoddi3>
  800677:	83 c4 10             	add    $0x10,%esp
  80067a:	05 14 39 80 00       	add    $0x803914,%eax
  80067f:	8a 00                	mov    (%eax),%al
  800681:	0f be c0             	movsbl %al,%eax
  800684:	83 ec 08             	sub    $0x8,%esp
  800687:	ff 75 0c             	pushl  0xc(%ebp)
  80068a:	50                   	push   %eax
  80068b:	8b 45 08             	mov    0x8(%ebp),%eax
  80068e:	ff d0                	call   *%eax
  800690:	83 c4 10             	add    $0x10,%esp
}
  800693:	90                   	nop
  800694:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800697:	c9                   	leave  
  800698:	c3                   	ret    

00800699 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800699:	55                   	push   %ebp
  80069a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80069c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006a0:	7e 1c                	jle    8006be <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a5:	8b 00                	mov    (%eax),%eax
  8006a7:	8d 50 08             	lea    0x8(%eax),%edx
  8006aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ad:	89 10                	mov    %edx,(%eax)
  8006af:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b2:	8b 00                	mov    (%eax),%eax
  8006b4:	83 e8 08             	sub    $0x8,%eax
  8006b7:	8b 50 04             	mov    0x4(%eax),%edx
  8006ba:	8b 00                	mov    (%eax),%eax
  8006bc:	eb 40                	jmp    8006fe <getuint+0x65>
	else if (lflag)
  8006be:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006c2:	74 1e                	je     8006e2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c7:	8b 00                	mov    (%eax),%eax
  8006c9:	8d 50 04             	lea    0x4(%eax),%edx
  8006cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cf:	89 10                	mov    %edx,(%eax)
  8006d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d4:	8b 00                	mov    (%eax),%eax
  8006d6:	83 e8 04             	sub    $0x4,%eax
  8006d9:	8b 00                	mov    (%eax),%eax
  8006db:	ba 00 00 00 00       	mov    $0x0,%edx
  8006e0:	eb 1c                	jmp    8006fe <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e5:	8b 00                	mov    (%eax),%eax
  8006e7:	8d 50 04             	lea    0x4(%eax),%edx
  8006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ed:	89 10                	mov    %edx,(%eax)
  8006ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f2:	8b 00                	mov    (%eax),%eax
  8006f4:	83 e8 04             	sub    $0x4,%eax
  8006f7:	8b 00                	mov    (%eax),%eax
  8006f9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006fe:	5d                   	pop    %ebp
  8006ff:	c3                   	ret    

00800700 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800700:	55                   	push   %ebp
  800701:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800703:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800707:	7e 1c                	jle    800725 <getint+0x25>
		return va_arg(*ap, long long);
  800709:	8b 45 08             	mov    0x8(%ebp),%eax
  80070c:	8b 00                	mov    (%eax),%eax
  80070e:	8d 50 08             	lea    0x8(%eax),%edx
  800711:	8b 45 08             	mov    0x8(%ebp),%eax
  800714:	89 10                	mov    %edx,(%eax)
  800716:	8b 45 08             	mov    0x8(%ebp),%eax
  800719:	8b 00                	mov    (%eax),%eax
  80071b:	83 e8 08             	sub    $0x8,%eax
  80071e:	8b 50 04             	mov    0x4(%eax),%edx
  800721:	8b 00                	mov    (%eax),%eax
  800723:	eb 38                	jmp    80075d <getint+0x5d>
	else if (lflag)
  800725:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800729:	74 1a                	je     800745 <getint+0x45>
		return va_arg(*ap, long);
  80072b:	8b 45 08             	mov    0x8(%ebp),%eax
  80072e:	8b 00                	mov    (%eax),%eax
  800730:	8d 50 04             	lea    0x4(%eax),%edx
  800733:	8b 45 08             	mov    0x8(%ebp),%eax
  800736:	89 10                	mov    %edx,(%eax)
  800738:	8b 45 08             	mov    0x8(%ebp),%eax
  80073b:	8b 00                	mov    (%eax),%eax
  80073d:	83 e8 04             	sub    $0x4,%eax
  800740:	8b 00                	mov    (%eax),%eax
  800742:	99                   	cltd   
  800743:	eb 18                	jmp    80075d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800745:	8b 45 08             	mov    0x8(%ebp),%eax
  800748:	8b 00                	mov    (%eax),%eax
  80074a:	8d 50 04             	lea    0x4(%eax),%edx
  80074d:	8b 45 08             	mov    0x8(%ebp),%eax
  800750:	89 10                	mov    %edx,(%eax)
  800752:	8b 45 08             	mov    0x8(%ebp),%eax
  800755:	8b 00                	mov    (%eax),%eax
  800757:	83 e8 04             	sub    $0x4,%eax
  80075a:	8b 00                	mov    (%eax),%eax
  80075c:	99                   	cltd   
}
  80075d:	5d                   	pop    %ebp
  80075e:	c3                   	ret    

0080075f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80075f:	55                   	push   %ebp
  800760:	89 e5                	mov    %esp,%ebp
  800762:	56                   	push   %esi
  800763:	53                   	push   %ebx
  800764:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800767:	eb 17                	jmp    800780 <vprintfmt+0x21>
			if (ch == '\0')
  800769:	85 db                	test   %ebx,%ebx
  80076b:	0f 84 af 03 00 00    	je     800b20 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800771:	83 ec 08             	sub    $0x8,%esp
  800774:	ff 75 0c             	pushl  0xc(%ebp)
  800777:	53                   	push   %ebx
  800778:	8b 45 08             	mov    0x8(%ebp),%eax
  80077b:	ff d0                	call   *%eax
  80077d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800780:	8b 45 10             	mov    0x10(%ebp),%eax
  800783:	8d 50 01             	lea    0x1(%eax),%edx
  800786:	89 55 10             	mov    %edx,0x10(%ebp)
  800789:	8a 00                	mov    (%eax),%al
  80078b:	0f b6 d8             	movzbl %al,%ebx
  80078e:	83 fb 25             	cmp    $0x25,%ebx
  800791:	75 d6                	jne    800769 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800793:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800797:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80079e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007a5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007ac:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b6:	8d 50 01             	lea    0x1(%eax),%edx
  8007b9:	89 55 10             	mov    %edx,0x10(%ebp)
  8007bc:	8a 00                	mov    (%eax),%al
  8007be:	0f b6 d8             	movzbl %al,%ebx
  8007c1:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007c4:	83 f8 55             	cmp    $0x55,%eax
  8007c7:	0f 87 2b 03 00 00    	ja     800af8 <vprintfmt+0x399>
  8007cd:	8b 04 85 38 39 80 00 	mov    0x803938(,%eax,4),%eax
  8007d4:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007d6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007da:	eb d7                	jmp    8007b3 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007dc:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007e0:	eb d1                	jmp    8007b3 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007e2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007e9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007ec:	89 d0                	mov    %edx,%eax
  8007ee:	c1 e0 02             	shl    $0x2,%eax
  8007f1:	01 d0                	add    %edx,%eax
  8007f3:	01 c0                	add    %eax,%eax
  8007f5:	01 d8                	add    %ebx,%eax
  8007f7:	83 e8 30             	sub    $0x30,%eax
  8007fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007fd:	8b 45 10             	mov    0x10(%ebp),%eax
  800800:	8a 00                	mov    (%eax),%al
  800802:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800805:	83 fb 2f             	cmp    $0x2f,%ebx
  800808:	7e 3e                	jle    800848 <vprintfmt+0xe9>
  80080a:	83 fb 39             	cmp    $0x39,%ebx
  80080d:	7f 39                	jg     800848 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80080f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800812:	eb d5                	jmp    8007e9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800814:	8b 45 14             	mov    0x14(%ebp),%eax
  800817:	83 c0 04             	add    $0x4,%eax
  80081a:	89 45 14             	mov    %eax,0x14(%ebp)
  80081d:	8b 45 14             	mov    0x14(%ebp),%eax
  800820:	83 e8 04             	sub    $0x4,%eax
  800823:	8b 00                	mov    (%eax),%eax
  800825:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800828:	eb 1f                	jmp    800849 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80082a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80082e:	79 83                	jns    8007b3 <vprintfmt+0x54>
				width = 0;
  800830:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800837:	e9 77 ff ff ff       	jmp    8007b3 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80083c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800843:	e9 6b ff ff ff       	jmp    8007b3 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800848:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800849:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80084d:	0f 89 60 ff ff ff    	jns    8007b3 <vprintfmt+0x54>
				width = precision, precision = -1;
  800853:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800856:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800859:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800860:	e9 4e ff ff ff       	jmp    8007b3 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800865:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800868:	e9 46 ff ff ff       	jmp    8007b3 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80086d:	8b 45 14             	mov    0x14(%ebp),%eax
  800870:	83 c0 04             	add    $0x4,%eax
  800873:	89 45 14             	mov    %eax,0x14(%ebp)
  800876:	8b 45 14             	mov    0x14(%ebp),%eax
  800879:	83 e8 04             	sub    $0x4,%eax
  80087c:	8b 00                	mov    (%eax),%eax
  80087e:	83 ec 08             	sub    $0x8,%esp
  800881:	ff 75 0c             	pushl  0xc(%ebp)
  800884:	50                   	push   %eax
  800885:	8b 45 08             	mov    0x8(%ebp),%eax
  800888:	ff d0                	call   *%eax
  80088a:	83 c4 10             	add    $0x10,%esp
			break;
  80088d:	e9 89 02 00 00       	jmp    800b1b <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800892:	8b 45 14             	mov    0x14(%ebp),%eax
  800895:	83 c0 04             	add    $0x4,%eax
  800898:	89 45 14             	mov    %eax,0x14(%ebp)
  80089b:	8b 45 14             	mov    0x14(%ebp),%eax
  80089e:	83 e8 04             	sub    $0x4,%eax
  8008a1:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008a3:	85 db                	test   %ebx,%ebx
  8008a5:	79 02                	jns    8008a9 <vprintfmt+0x14a>
				err = -err;
  8008a7:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008a9:	83 fb 64             	cmp    $0x64,%ebx
  8008ac:	7f 0b                	jg     8008b9 <vprintfmt+0x15a>
  8008ae:	8b 34 9d 80 37 80 00 	mov    0x803780(,%ebx,4),%esi
  8008b5:	85 f6                	test   %esi,%esi
  8008b7:	75 19                	jne    8008d2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008b9:	53                   	push   %ebx
  8008ba:	68 25 39 80 00       	push   $0x803925
  8008bf:	ff 75 0c             	pushl  0xc(%ebp)
  8008c2:	ff 75 08             	pushl  0x8(%ebp)
  8008c5:	e8 5e 02 00 00       	call   800b28 <printfmt>
  8008ca:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008cd:	e9 49 02 00 00       	jmp    800b1b <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008d2:	56                   	push   %esi
  8008d3:	68 2e 39 80 00       	push   $0x80392e
  8008d8:	ff 75 0c             	pushl  0xc(%ebp)
  8008db:	ff 75 08             	pushl  0x8(%ebp)
  8008de:	e8 45 02 00 00       	call   800b28 <printfmt>
  8008e3:	83 c4 10             	add    $0x10,%esp
			break;
  8008e6:	e9 30 02 00 00       	jmp    800b1b <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ee:	83 c0 04             	add    $0x4,%eax
  8008f1:	89 45 14             	mov    %eax,0x14(%ebp)
  8008f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f7:	83 e8 04             	sub    $0x4,%eax
  8008fa:	8b 30                	mov    (%eax),%esi
  8008fc:	85 f6                	test   %esi,%esi
  8008fe:	75 05                	jne    800905 <vprintfmt+0x1a6>
				p = "(null)";
  800900:	be 31 39 80 00       	mov    $0x803931,%esi
			if (width > 0 && padc != '-')
  800905:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800909:	7e 6d                	jle    800978 <vprintfmt+0x219>
  80090b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80090f:	74 67                	je     800978 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800911:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800914:	83 ec 08             	sub    $0x8,%esp
  800917:	50                   	push   %eax
  800918:	56                   	push   %esi
  800919:	e8 0c 03 00 00       	call   800c2a <strnlen>
  80091e:	83 c4 10             	add    $0x10,%esp
  800921:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800924:	eb 16                	jmp    80093c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800926:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80092a:	83 ec 08             	sub    $0x8,%esp
  80092d:	ff 75 0c             	pushl  0xc(%ebp)
  800930:	50                   	push   %eax
  800931:	8b 45 08             	mov    0x8(%ebp),%eax
  800934:	ff d0                	call   *%eax
  800936:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800939:	ff 4d e4             	decl   -0x1c(%ebp)
  80093c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800940:	7f e4                	jg     800926 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800942:	eb 34                	jmp    800978 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800944:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800948:	74 1c                	je     800966 <vprintfmt+0x207>
  80094a:	83 fb 1f             	cmp    $0x1f,%ebx
  80094d:	7e 05                	jle    800954 <vprintfmt+0x1f5>
  80094f:	83 fb 7e             	cmp    $0x7e,%ebx
  800952:	7e 12                	jle    800966 <vprintfmt+0x207>
					putch('?', putdat);
  800954:	83 ec 08             	sub    $0x8,%esp
  800957:	ff 75 0c             	pushl  0xc(%ebp)
  80095a:	6a 3f                	push   $0x3f
  80095c:	8b 45 08             	mov    0x8(%ebp),%eax
  80095f:	ff d0                	call   *%eax
  800961:	83 c4 10             	add    $0x10,%esp
  800964:	eb 0f                	jmp    800975 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800966:	83 ec 08             	sub    $0x8,%esp
  800969:	ff 75 0c             	pushl  0xc(%ebp)
  80096c:	53                   	push   %ebx
  80096d:	8b 45 08             	mov    0x8(%ebp),%eax
  800970:	ff d0                	call   *%eax
  800972:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800975:	ff 4d e4             	decl   -0x1c(%ebp)
  800978:	89 f0                	mov    %esi,%eax
  80097a:	8d 70 01             	lea    0x1(%eax),%esi
  80097d:	8a 00                	mov    (%eax),%al
  80097f:	0f be d8             	movsbl %al,%ebx
  800982:	85 db                	test   %ebx,%ebx
  800984:	74 24                	je     8009aa <vprintfmt+0x24b>
  800986:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80098a:	78 b8                	js     800944 <vprintfmt+0x1e5>
  80098c:	ff 4d e0             	decl   -0x20(%ebp)
  80098f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800993:	79 af                	jns    800944 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800995:	eb 13                	jmp    8009aa <vprintfmt+0x24b>
				putch(' ', putdat);
  800997:	83 ec 08             	sub    $0x8,%esp
  80099a:	ff 75 0c             	pushl  0xc(%ebp)
  80099d:	6a 20                	push   $0x20
  80099f:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a2:	ff d0                	call   *%eax
  8009a4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009a7:	ff 4d e4             	decl   -0x1c(%ebp)
  8009aa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ae:	7f e7                	jg     800997 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009b0:	e9 66 01 00 00       	jmp    800b1b <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009b5:	83 ec 08             	sub    $0x8,%esp
  8009b8:	ff 75 e8             	pushl  -0x18(%ebp)
  8009bb:	8d 45 14             	lea    0x14(%ebp),%eax
  8009be:	50                   	push   %eax
  8009bf:	e8 3c fd ff ff       	call   800700 <getint>
  8009c4:	83 c4 10             	add    $0x10,%esp
  8009c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ca:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009d3:	85 d2                	test   %edx,%edx
  8009d5:	79 23                	jns    8009fa <vprintfmt+0x29b>
				putch('-', putdat);
  8009d7:	83 ec 08             	sub    $0x8,%esp
  8009da:	ff 75 0c             	pushl  0xc(%ebp)
  8009dd:	6a 2d                	push   $0x2d
  8009df:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e2:	ff d0                	call   *%eax
  8009e4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009ed:	f7 d8                	neg    %eax
  8009ef:	83 d2 00             	adc    $0x0,%edx
  8009f2:	f7 da                	neg    %edx
  8009f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009f7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009fa:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a01:	e9 bc 00 00 00       	jmp    800ac2 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a06:	83 ec 08             	sub    $0x8,%esp
  800a09:	ff 75 e8             	pushl  -0x18(%ebp)
  800a0c:	8d 45 14             	lea    0x14(%ebp),%eax
  800a0f:	50                   	push   %eax
  800a10:	e8 84 fc ff ff       	call   800699 <getuint>
  800a15:	83 c4 10             	add    $0x10,%esp
  800a18:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a1b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a1e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a25:	e9 98 00 00 00       	jmp    800ac2 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a2a:	83 ec 08             	sub    $0x8,%esp
  800a2d:	ff 75 0c             	pushl  0xc(%ebp)
  800a30:	6a 58                	push   $0x58
  800a32:	8b 45 08             	mov    0x8(%ebp),%eax
  800a35:	ff d0                	call   *%eax
  800a37:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a3a:	83 ec 08             	sub    $0x8,%esp
  800a3d:	ff 75 0c             	pushl  0xc(%ebp)
  800a40:	6a 58                	push   $0x58
  800a42:	8b 45 08             	mov    0x8(%ebp),%eax
  800a45:	ff d0                	call   *%eax
  800a47:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a4a:	83 ec 08             	sub    $0x8,%esp
  800a4d:	ff 75 0c             	pushl  0xc(%ebp)
  800a50:	6a 58                	push   $0x58
  800a52:	8b 45 08             	mov    0x8(%ebp),%eax
  800a55:	ff d0                	call   *%eax
  800a57:	83 c4 10             	add    $0x10,%esp
			break;
  800a5a:	e9 bc 00 00 00       	jmp    800b1b <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a5f:	83 ec 08             	sub    $0x8,%esp
  800a62:	ff 75 0c             	pushl  0xc(%ebp)
  800a65:	6a 30                	push   $0x30
  800a67:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6a:	ff d0                	call   *%eax
  800a6c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a6f:	83 ec 08             	sub    $0x8,%esp
  800a72:	ff 75 0c             	pushl  0xc(%ebp)
  800a75:	6a 78                	push   $0x78
  800a77:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7a:	ff d0                	call   *%eax
  800a7c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a7f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a82:	83 c0 04             	add    $0x4,%eax
  800a85:	89 45 14             	mov    %eax,0x14(%ebp)
  800a88:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8b:	83 e8 04             	sub    $0x4,%eax
  800a8e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a90:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a93:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a9a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800aa1:	eb 1f                	jmp    800ac2 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800aa3:	83 ec 08             	sub    $0x8,%esp
  800aa6:	ff 75 e8             	pushl  -0x18(%ebp)
  800aa9:	8d 45 14             	lea    0x14(%ebp),%eax
  800aac:	50                   	push   %eax
  800aad:	e8 e7 fb ff ff       	call   800699 <getuint>
  800ab2:	83 c4 10             	add    $0x10,%esp
  800ab5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800abb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ac2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ac6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ac9:	83 ec 04             	sub    $0x4,%esp
  800acc:	52                   	push   %edx
  800acd:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ad0:	50                   	push   %eax
  800ad1:	ff 75 f4             	pushl  -0xc(%ebp)
  800ad4:	ff 75 f0             	pushl  -0x10(%ebp)
  800ad7:	ff 75 0c             	pushl  0xc(%ebp)
  800ada:	ff 75 08             	pushl  0x8(%ebp)
  800add:	e8 00 fb ff ff       	call   8005e2 <printnum>
  800ae2:	83 c4 20             	add    $0x20,%esp
			break;
  800ae5:	eb 34                	jmp    800b1b <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ae7:	83 ec 08             	sub    $0x8,%esp
  800aea:	ff 75 0c             	pushl  0xc(%ebp)
  800aed:	53                   	push   %ebx
  800aee:	8b 45 08             	mov    0x8(%ebp),%eax
  800af1:	ff d0                	call   *%eax
  800af3:	83 c4 10             	add    $0x10,%esp
			break;
  800af6:	eb 23                	jmp    800b1b <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800af8:	83 ec 08             	sub    $0x8,%esp
  800afb:	ff 75 0c             	pushl  0xc(%ebp)
  800afe:	6a 25                	push   $0x25
  800b00:	8b 45 08             	mov    0x8(%ebp),%eax
  800b03:	ff d0                	call   *%eax
  800b05:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b08:	ff 4d 10             	decl   0x10(%ebp)
  800b0b:	eb 03                	jmp    800b10 <vprintfmt+0x3b1>
  800b0d:	ff 4d 10             	decl   0x10(%ebp)
  800b10:	8b 45 10             	mov    0x10(%ebp),%eax
  800b13:	48                   	dec    %eax
  800b14:	8a 00                	mov    (%eax),%al
  800b16:	3c 25                	cmp    $0x25,%al
  800b18:	75 f3                	jne    800b0d <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b1a:	90                   	nop
		}
	}
  800b1b:	e9 47 fc ff ff       	jmp    800767 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b20:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b21:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b24:	5b                   	pop    %ebx
  800b25:	5e                   	pop    %esi
  800b26:	5d                   	pop    %ebp
  800b27:	c3                   	ret    

00800b28 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b28:	55                   	push   %ebp
  800b29:	89 e5                	mov    %esp,%ebp
  800b2b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b2e:	8d 45 10             	lea    0x10(%ebp),%eax
  800b31:	83 c0 04             	add    $0x4,%eax
  800b34:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b37:	8b 45 10             	mov    0x10(%ebp),%eax
  800b3a:	ff 75 f4             	pushl  -0xc(%ebp)
  800b3d:	50                   	push   %eax
  800b3e:	ff 75 0c             	pushl  0xc(%ebp)
  800b41:	ff 75 08             	pushl  0x8(%ebp)
  800b44:	e8 16 fc ff ff       	call   80075f <vprintfmt>
  800b49:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b4c:	90                   	nop
  800b4d:	c9                   	leave  
  800b4e:	c3                   	ret    

00800b4f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b4f:	55                   	push   %ebp
  800b50:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b55:	8b 40 08             	mov    0x8(%eax),%eax
  800b58:	8d 50 01             	lea    0x1(%eax),%edx
  800b5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b64:	8b 10                	mov    (%eax),%edx
  800b66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b69:	8b 40 04             	mov    0x4(%eax),%eax
  800b6c:	39 c2                	cmp    %eax,%edx
  800b6e:	73 12                	jae    800b82 <sprintputch+0x33>
		*b->buf++ = ch;
  800b70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b73:	8b 00                	mov    (%eax),%eax
  800b75:	8d 48 01             	lea    0x1(%eax),%ecx
  800b78:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b7b:	89 0a                	mov    %ecx,(%edx)
  800b7d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b80:	88 10                	mov    %dl,(%eax)
}
  800b82:	90                   	nop
  800b83:	5d                   	pop    %ebp
  800b84:	c3                   	ret    

00800b85 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b85:	55                   	push   %ebp
  800b86:	89 e5                	mov    %esp,%ebp
  800b88:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b94:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	01 d0                	add    %edx,%eax
  800b9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b9f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ba6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800baa:	74 06                	je     800bb2 <vsnprintf+0x2d>
  800bac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb0:	7f 07                	jg     800bb9 <vsnprintf+0x34>
		return -E_INVAL;
  800bb2:	b8 03 00 00 00       	mov    $0x3,%eax
  800bb7:	eb 20                	jmp    800bd9 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bb9:	ff 75 14             	pushl  0x14(%ebp)
  800bbc:	ff 75 10             	pushl  0x10(%ebp)
  800bbf:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bc2:	50                   	push   %eax
  800bc3:	68 4f 0b 80 00       	push   $0x800b4f
  800bc8:	e8 92 fb ff ff       	call   80075f <vprintfmt>
  800bcd:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bd3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bd9:	c9                   	leave  
  800bda:	c3                   	ret    

00800bdb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bdb:	55                   	push   %ebp
  800bdc:	89 e5                	mov    %esp,%ebp
  800bde:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800be1:	8d 45 10             	lea    0x10(%ebp),%eax
  800be4:	83 c0 04             	add    $0x4,%eax
  800be7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bea:	8b 45 10             	mov    0x10(%ebp),%eax
  800bed:	ff 75 f4             	pushl  -0xc(%ebp)
  800bf0:	50                   	push   %eax
  800bf1:	ff 75 0c             	pushl  0xc(%ebp)
  800bf4:	ff 75 08             	pushl  0x8(%ebp)
  800bf7:	e8 89 ff ff ff       	call   800b85 <vsnprintf>
  800bfc:	83 c4 10             	add    $0x10,%esp
  800bff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c02:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c05:	c9                   	leave  
  800c06:	c3                   	ret    

00800c07 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c0d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c14:	eb 06                	jmp    800c1c <strlen+0x15>
		n++;
  800c16:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c19:	ff 45 08             	incl   0x8(%ebp)
  800c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1f:	8a 00                	mov    (%eax),%al
  800c21:	84 c0                	test   %al,%al
  800c23:	75 f1                	jne    800c16 <strlen+0xf>
		n++;
	return n;
  800c25:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c28:	c9                   	leave  
  800c29:	c3                   	ret    

00800c2a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c2a:	55                   	push   %ebp
  800c2b:	89 e5                	mov    %esp,%ebp
  800c2d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c37:	eb 09                	jmp    800c42 <strnlen+0x18>
		n++;
  800c39:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c3c:	ff 45 08             	incl   0x8(%ebp)
  800c3f:	ff 4d 0c             	decl   0xc(%ebp)
  800c42:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c46:	74 09                	je     800c51 <strnlen+0x27>
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	8a 00                	mov    (%eax),%al
  800c4d:	84 c0                	test   %al,%al
  800c4f:	75 e8                	jne    800c39 <strnlen+0xf>
		n++;
	return n;
  800c51:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c54:	c9                   	leave  
  800c55:	c3                   	ret    

00800c56 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c56:	55                   	push   %ebp
  800c57:	89 e5                	mov    %esp,%ebp
  800c59:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c62:	90                   	nop
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	8d 50 01             	lea    0x1(%eax),%edx
  800c69:	89 55 08             	mov    %edx,0x8(%ebp)
  800c6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c72:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c75:	8a 12                	mov    (%edx),%dl
  800c77:	88 10                	mov    %dl,(%eax)
  800c79:	8a 00                	mov    (%eax),%al
  800c7b:	84 c0                	test   %al,%al
  800c7d:	75 e4                	jne    800c63 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c82:	c9                   	leave  
  800c83:	c3                   	ret    

00800c84 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c84:	55                   	push   %ebp
  800c85:	89 e5                	mov    %esp,%ebp
  800c87:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c90:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c97:	eb 1f                	jmp    800cb8 <strncpy+0x34>
		*dst++ = *src;
  800c99:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9c:	8d 50 01             	lea    0x1(%eax),%edx
  800c9f:	89 55 08             	mov    %edx,0x8(%ebp)
  800ca2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca5:	8a 12                	mov    (%edx),%dl
  800ca7:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ca9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cac:	8a 00                	mov    (%eax),%al
  800cae:	84 c0                	test   %al,%al
  800cb0:	74 03                	je     800cb5 <strncpy+0x31>
			src++;
  800cb2:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cb5:	ff 45 fc             	incl   -0x4(%ebp)
  800cb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cbb:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cbe:	72 d9                	jb     800c99 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cc0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cc3:	c9                   	leave  
  800cc4:	c3                   	ret    

00800cc5 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cc5:	55                   	push   %ebp
  800cc6:	89 e5                	mov    %esp,%ebp
  800cc8:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cd1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd5:	74 30                	je     800d07 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cd7:	eb 16                	jmp    800cef <strlcpy+0x2a>
			*dst++ = *src++;
  800cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdc:	8d 50 01             	lea    0x1(%eax),%edx
  800cdf:	89 55 08             	mov    %edx,0x8(%ebp)
  800ce2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ce8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ceb:	8a 12                	mov    (%edx),%dl
  800ced:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cef:	ff 4d 10             	decl   0x10(%ebp)
  800cf2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf6:	74 09                	je     800d01 <strlcpy+0x3c>
  800cf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfb:	8a 00                	mov    (%eax),%al
  800cfd:	84 c0                	test   %al,%al
  800cff:	75 d8                	jne    800cd9 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d01:	8b 45 08             	mov    0x8(%ebp),%eax
  800d04:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d07:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d0d:	29 c2                	sub    %eax,%edx
  800d0f:	89 d0                	mov    %edx,%eax
}
  800d11:	c9                   	leave  
  800d12:	c3                   	ret    

00800d13 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d13:	55                   	push   %ebp
  800d14:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d16:	eb 06                	jmp    800d1e <strcmp+0xb>
		p++, q++;
  800d18:	ff 45 08             	incl   0x8(%ebp)
  800d1b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	8a 00                	mov    (%eax),%al
  800d23:	84 c0                	test   %al,%al
  800d25:	74 0e                	je     800d35 <strcmp+0x22>
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	8a 10                	mov    (%eax),%dl
  800d2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2f:	8a 00                	mov    (%eax),%al
  800d31:	38 c2                	cmp    %al,%dl
  800d33:	74 e3                	je     800d18 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d35:	8b 45 08             	mov    0x8(%ebp),%eax
  800d38:	8a 00                	mov    (%eax),%al
  800d3a:	0f b6 d0             	movzbl %al,%edx
  800d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d40:	8a 00                	mov    (%eax),%al
  800d42:	0f b6 c0             	movzbl %al,%eax
  800d45:	29 c2                	sub    %eax,%edx
  800d47:	89 d0                	mov    %edx,%eax
}
  800d49:	5d                   	pop    %ebp
  800d4a:	c3                   	ret    

00800d4b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d4b:	55                   	push   %ebp
  800d4c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d4e:	eb 09                	jmp    800d59 <strncmp+0xe>
		n--, p++, q++;
  800d50:	ff 4d 10             	decl   0x10(%ebp)
  800d53:	ff 45 08             	incl   0x8(%ebp)
  800d56:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d59:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5d:	74 17                	je     800d76 <strncmp+0x2b>
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	8a 00                	mov    (%eax),%al
  800d64:	84 c0                	test   %al,%al
  800d66:	74 0e                	je     800d76 <strncmp+0x2b>
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	8a 10                	mov    (%eax),%dl
  800d6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d70:	8a 00                	mov    (%eax),%al
  800d72:	38 c2                	cmp    %al,%dl
  800d74:	74 da                	je     800d50 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d76:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d7a:	75 07                	jne    800d83 <strncmp+0x38>
		return 0;
  800d7c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d81:	eb 14                	jmp    800d97 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d83:	8b 45 08             	mov    0x8(%ebp),%eax
  800d86:	8a 00                	mov    (%eax),%al
  800d88:	0f b6 d0             	movzbl %al,%edx
  800d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8e:	8a 00                	mov    (%eax),%al
  800d90:	0f b6 c0             	movzbl %al,%eax
  800d93:	29 c2                	sub    %eax,%edx
  800d95:	89 d0                	mov    %edx,%eax
}
  800d97:	5d                   	pop    %ebp
  800d98:	c3                   	ret    

00800d99 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d99:	55                   	push   %ebp
  800d9a:	89 e5                	mov    %esp,%ebp
  800d9c:	83 ec 04             	sub    $0x4,%esp
  800d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800da5:	eb 12                	jmp    800db9 <strchr+0x20>
		if (*s == c)
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	8a 00                	mov    (%eax),%al
  800dac:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800daf:	75 05                	jne    800db6 <strchr+0x1d>
			return (char *) s;
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
  800db4:	eb 11                	jmp    800dc7 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800db6:	ff 45 08             	incl   0x8(%ebp)
  800db9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbc:	8a 00                	mov    (%eax),%al
  800dbe:	84 c0                	test   %al,%al
  800dc0:	75 e5                	jne    800da7 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800dc2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dc7:	c9                   	leave  
  800dc8:	c3                   	ret    

00800dc9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dc9:	55                   	push   %ebp
  800dca:	89 e5                	mov    %esp,%ebp
  800dcc:	83 ec 04             	sub    $0x4,%esp
  800dcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dd5:	eb 0d                	jmp    800de4 <strfind+0x1b>
		if (*s == c)
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	8a 00                	mov    (%eax),%al
  800ddc:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ddf:	74 0e                	je     800def <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800de1:	ff 45 08             	incl   0x8(%ebp)
  800de4:	8b 45 08             	mov    0x8(%ebp),%eax
  800de7:	8a 00                	mov    (%eax),%al
  800de9:	84 c0                	test   %al,%al
  800deb:	75 ea                	jne    800dd7 <strfind+0xe>
  800ded:	eb 01                	jmp    800df0 <strfind+0x27>
		if (*s == c)
			break;
  800def:	90                   	nop
	return (char *) s;
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800df3:	c9                   	leave  
  800df4:	c3                   	ret    

00800df5 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800df5:	55                   	push   %ebp
  800df6:	89 e5                	mov    %esp,%ebp
  800df8:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e01:	8b 45 10             	mov    0x10(%ebp),%eax
  800e04:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e07:	eb 0e                	jmp    800e17 <memset+0x22>
		*p++ = c;
  800e09:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e0c:	8d 50 01             	lea    0x1(%eax),%edx
  800e0f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e12:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e15:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e17:	ff 4d f8             	decl   -0x8(%ebp)
  800e1a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e1e:	79 e9                	jns    800e09 <memset+0x14>
		*p++ = c;

	return v;
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e23:	c9                   	leave  
  800e24:	c3                   	ret    

00800e25 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e25:	55                   	push   %ebp
  800e26:	89 e5                	mov    %esp,%ebp
  800e28:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
  800e34:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e37:	eb 16                	jmp    800e4f <memcpy+0x2a>
		*d++ = *s++;
  800e39:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e3c:	8d 50 01             	lea    0x1(%eax),%edx
  800e3f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e42:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e45:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e48:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e4b:	8a 12                	mov    (%edx),%dl
  800e4d:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e52:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e55:	89 55 10             	mov    %edx,0x10(%ebp)
  800e58:	85 c0                	test   %eax,%eax
  800e5a:	75 dd                	jne    800e39 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e5c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e5f:	c9                   	leave  
  800e60:	c3                   	ret    

00800e61 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e61:	55                   	push   %ebp
  800e62:	89 e5                	mov    %esp,%ebp
  800e64:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e70:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e73:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e76:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e79:	73 50                	jae    800ecb <memmove+0x6a>
  800e7b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e81:	01 d0                	add    %edx,%eax
  800e83:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e86:	76 43                	jbe    800ecb <memmove+0x6a>
		s += n;
  800e88:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e8e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e91:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e94:	eb 10                	jmp    800ea6 <memmove+0x45>
			*--d = *--s;
  800e96:	ff 4d f8             	decl   -0x8(%ebp)
  800e99:	ff 4d fc             	decl   -0x4(%ebp)
  800e9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e9f:	8a 10                	mov    (%eax),%dl
  800ea1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea4:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ea6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eac:	89 55 10             	mov    %edx,0x10(%ebp)
  800eaf:	85 c0                	test   %eax,%eax
  800eb1:	75 e3                	jne    800e96 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800eb3:	eb 23                	jmp    800ed8 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800eb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb8:	8d 50 01             	lea    0x1(%eax),%edx
  800ebb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ebe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ec1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ec4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ec7:	8a 12                	mov    (%edx),%dl
  800ec9:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ecb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ece:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ed1:	89 55 10             	mov    %edx,0x10(%ebp)
  800ed4:	85 c0                	test   %eax,%eax
  800ed6:	75 dd                	jne    800eb5 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ed8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800edb:	c9                   	leave  
  800edc:	c3                   	ret    

00800edd <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800edd:	55                   	push   %ebp
  800ede:	89 e5                	mov    %esp,%ebp
  800ee0:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ee9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eec:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800eef:	eb 2a                	jmp    800f1b <memcmp+0x3e>
		if (*s1 != *s2)
  800ef1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef4:	8a 10                	mov    (%eax),%dl
  800ef6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef9:	8a 00                	mov    (%eax),%al
  800efb:	38 c2                	cmp    %al,%dl
  800efd:	74 16                	je     800f15 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800eff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f02:	8a 00                	mov    (%eax),%al
  800f04:	0f b6 d0             	movzbl %al,%edx
  800f07:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f0a:	8a 00                	mov    (%eax),%al
  800f0c:	0f b6 c0             	movzbl %al,%eax
  800f0f:	29 c2                	sub    %eax,%edx
  800f11:	89 d0                	mov    %edx,%eax
  800f13:	eb 18                	jmp    800f2d <memcmp+0x50>
		s1++, s2++;
  800f15:	ff 45 fc             	incl   -0x4(%ebp)
  800f18:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f21:	89 55 10             	mov    %edx,0x10(%ebp)
  800f24:	85 c0                	test   %eax,%eax
  800f26:	75 c9                	jne    800ef1 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f2d:	c9                   	leave  
  800f2e:	c3                   	ret    

00800f2f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f2f:	55                   	push   %ebp
  800f30:	89 e5                	mov    %esp,%ebp
  800f32:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f35:	8b 55 08             	mov    0x8(%ebp),%edx
  800f38:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3b:	01 d0                	add    %edx,%eax
  800f3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f40:	eb 15                	jmp    800f57 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f42:	8b 45 08             	mov    0x8(%ebp),%eax
  800f45:	8a 00                	mov    (%eax),%al
  800f47:	0f b6 d0             	movzbl %al,%edx
  800f4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4d:	0f b6 c0             	movzbl %al,%eax
  800f50:	39 c2                	cmp    %eax,%edx
  800f52:	74 0d                	je     800f61 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f54:	ff 45 08             	incl   0x8(%ebp)
  800f57:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f5d:	72 e3                	jb     800f42 <memfind+0x13>
  800f5f:	eb 01                	jmp    800f62 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f61:	90                   	nop
	return (void *) s;
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f65:	c9                   	leave  
  800f66:	c3                   	ret    

00800f67 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f67:	55                   	push   %ebp
  800f68:	89 e5                	mov    %esp,%ebp
  800f6a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f6d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f74:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f7b:	eb 03                	jmp    800f80 <strtol+0x19>
		s++;
  800f7d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	8a 00                	mov    (%eax),%al
  800f85:	3c 20                	cmp    $0x20,%al
  800f87:	74 f4                	je     800f7d <strtol+0x16>
  800f89:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8c:	8a 00                	mov    (%eax),%al
  800f8e:	3c 09                	cmp    $0x9,%al
  800f90:	74 eb                	je     800f7d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f92:	8b 45 08             	mov    0x8(%ebp),%eax
  800f95:	8a 00                	mov    (%eax),%al
  800f97:	3c 2b                	cmp    $0x2b,%al
  800f99:	75 05                	jne    800fa0 <strtol+0x39>
		s++;
  800f9b:	ff 45 08             	incl   0x8(%ebp)
  800f9e:	eb 13                	jmp    800fb3 <strtol+0x4c>
	else if (*s == '-')
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	8a 00                	mov    (%eax),%al
  800fa5:	3c 2d                	cmp    $0x2d,%al
  800fa7:	75 0a                	jne    800fb3 <strtol+0x4c>
		s++, neg = 1;
  800fa9:	ff 45 08             	incl   0x8(%ebp)
  800fac:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fb3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb7:	74 06                	je     800fbf <strtol+0x58>
  800fb9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fbd:	75 20                	jne    800fdf <strtol+0x78>
  800fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc2:	8a 00                	mov    (%eax),%al
  800fc4:	3c 30                	cmp    $0x30,%al
  800fc6:	75 17                	jne    800fdf <strtol+0x78>
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	40                   	inc    %eax
  800fcc:	8a 00                	mov    (%eax),%al
  800fce:	3c 78                	cmp    $0x78,%al
  800fd0:	75 0d                	jne    800fdf <strtol+0x78>
		s += 2, base = 16;
  800fd2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fd6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fdd:	eb 28                	jmp    801007 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fdf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fe3:	75 15                	jne    800ffa <strtol+0x93>
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	8a 00                	mov    (%eax),%al
  800fea:	3c 30                	cmp    $0x30,%al
  800fec:	75 0c                	jne    800ffa <strtol+0x93>
		s++, base = 8;
  800fee:	ff 45 08             	incl   0x8(%ebp)
  800ff1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ff8:	eb 0d                	jmp    801007 <strtol+0xa0>
	else if (base == 0)
  800ffa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ffe:	75 07                	jne    801007 <strtol+0xa0>
		base = 10;
  801000:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801007:	8b 45 08             	mov    0x8(%ebp),%eax
  80100a:	8a 00                	mov    (%eax),%al
  80100c:	3c 2f                	cmp    $0x2f,%al
  80100e:	7e 19                	jle    801029 <strtol+0xc2>
  801010:	8b 45 08             	mov    0x8(%ebp),%eax
  801013:	8a 00                	mov    (%eax),%al
  801015:	3c 39                	cmp    $0x39,%al
  801017:	7f 10                	jg     801029 <strtol+0xc2>
			dig = *s - '0';
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
  80101c:	8a 00                	mov    (%eax),%al
  80101e:	0f be c0             	movsbl %al,%eax
  801021:	83 e8 30             	sub    $0x30,%eax
  801024:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801027:	eb 42                	jmp    80106b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801029:	8b 45 08             	mov    0x8(%ebp),%eax
  80102c:	8a 00                	mov    (%eax),%al
  80102e:	3c 60                	cmp    $0x60,%al
  801030:	7e 19                	jle    80104b <strtol+0xe4>
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
  801035:	8a 00                	mov    (%eax),%al
  801037:	3c 7a                	cmp    $0x7a,%al
  801039:	7f 10                	jg     80104b <strtol+0xe4>
			dig = *s - 'a' + 10;
  80103b:	8b 45 08             	mov    0x8(%ebp),%eax
  80103e:	8a 00                	mov    (%eax),%al
  801040:	0f be c0             	movsbl %al,%eax
  801043:	83 e8 57             	sub    $0x57,%eax
  801046:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801049:	eb 20                	jmp    80106b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	8a 00                	mov    (%eax),%al
  801050:	3c 40                	cmp    $0x40,%al
  801052:	7e 39                	jle    80108d <strtol+0x126>
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	8a 00                	mov    (%eax),%al
  801059:	3c 5a                	cmp    $0x5a,%al
  80105b:	7f 30                	jg     80108d <strtol+0x126>
			dig = *s - 'A' + 10;
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	8a 00                	mov    (%eax),%al
  801062:	0f be c0             	movsbl %al,%eax
  801065:	83 e8 37             	sub    $0x37,%eax
  801068:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80106b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80106e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801071:	7d 19                	jge    80108c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801073:	ff 45 08             	incl   0x8(%ebp)
  801076:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801079:	0f af 45 10          	imul   0x10(%ebp),%eax
  80107d:	89 c2                	mov    %eax,%edx
  80107f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801082:	01 d0                	add    %edx,%eax
  801084:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801087:	e9 7b ff ff ff       	jmp    801007 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80108c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80108d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801091:	74 08                	je     80109b <strtol+0x134>
		*endptr = (char *) s;
  801093:	8b 45 0c             	mov    0xc(%ebp),%eax
  801096:	8b 55 08             	mov    0x8(%ebp),%edx
  801099:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80109b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80109f:	74 07                	je     8010a8 <strtol+0x141>
  8010a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a4:	f7 d8                	neg    %eax
  8010a6:	eb 03                	jmp    8010ab <strtol+0x144>
  8010a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010ab:	c9                   	leave  
  8010ac:	c3                   	ret    

008010ad <ltostr>:

void
ltostr(long value, char *str)
{
  8010ad:	55                   	push   %ebp
  8010ae:	89 e5                	mov    %esp,%ebp
  8010b0:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010ba:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010c5:	79 13                	jns    8010da <ltostr+0x2d>
	{
		neg = 1;
  8010c7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d1:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010d4:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010d7:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010da:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010e2:	99                   	cltd   
  8010e3:	f7 f9                	idiv   %ecx
  8010e5:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010eb:	8d 50 01             	lea    0x1(%eax),%edx
  8010ee:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010f1:	89 c2                	mov    %eax,%edx
  8010f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f6:	01 d0                	add    %edx,%eax
  8010f8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010fb:	83 c2 30             	add    $0x30,%edx
  8010fe:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801100:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801103:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801108:	f7 e9                	imul   %ecx
  80110a:	c1 fa 02             	sar    $0x2,%edx
  80110d:	89 c8                	mov    %ecx,%eax
  80110f:	c1 f8 1f             	sar    $0x1f,%eax
  801112:	29 c2                	sub    %eax,%edx
  801114:	89 d0                	mov    %edx,%eax
  801116:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801119:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80111c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801121:	f7 e9                	imul   %ecx
  801123:	c1 fa 02             	sar    $0x2,%edx
  801126:	89 c8                	mov    %ecx,%eax
  801128:	c1 f8 1f             	sar    $0x1f,%eax
  80112b:	29 c2                	sub    %eax,%edx
  80112d:	89 d0                	mov    %edx,%eax
  80112f:	c1 e0 02             	shl    $0x2,%eax
  801132:	01 d0                	add    %edx,%eax
  801134:	01 c0                	add    %eax,%eax
  801136:	29 c1                	sub    %eax,%ecx
  801138:	89 ca                	mov    %ecx,%edx
  80113a:	85 d2                	test   %edx,%edx
  80113c:	75 9c                	jne    8010da <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80113e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801145:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801148:	48                   	dec    %eax
  801149:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80114c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801150:	74 3d                	je     80118f <ltostr+0xe2>
		start = 1 ;
  801152:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801159:	eb 34                	jmp    80118f <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80115b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80115e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801161:	01 d0                	add    %edx,%eax
  801163:	8a 00                	mov    (%eax),%al
  801165:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801168:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80116b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116e:	01 c2                	add    %eax,%edx
  801170:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801173:	8b 45 0c             	mov    0xc(%ebp),%eax
  801176:	01 c8                	add    %ecx,%eax
  801178:	8a 00                	mov    (%eax),%al
  80117a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80117c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80117f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801182:	01 c2                	add    %eax,%edx
  801184:	8a 45 eb             	mov    -0x15(%ebp),%al
  801187:	88 02                	mov    %al,(%edx)
		start++ ;
  801189:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80118c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80118f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801192:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801195:	7c c4                	jl     80115b <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801197:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80119a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119d:	01 d0                	add    %edx,%eax
  80119f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011a2:	90                   	nop
  8011a3:	c9                   	leave  
  8011a4:	c3                   	ret    

008011a5 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011a5:	55                   	push   %ebp
  8011a6:	89 e5                	mov    %esp,%ebp
  8011a8:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011ab:	ff 75 08             	pushl  0x8(%ebp)
  8011ae:	e8 54 fa ff ff       	call   800c07 <strlen>
  8011b3:	83 c4 04             	add    $0x4,%esp
  8011b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011b9:	ff 75 0c             	pushl  0xc(%ebp)
  8011bc:	e8 46 fa ff ff       	call   800c07 <strlen>
  8011c1:	83 c4 04             	add    $0x4,%esp
  8011c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011d5:	eb 17                	jmp    8011ee <strcconcat+0x49>
		final[s] = str1[s] ;
  8011d7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011da:	8b 45 10             	mov    0x10(%ebp),%eax
  8011dd:	01 c2                	add    %eax,%edx
  8011df:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e5:	01 c8                	add    %ecx,%eax
  8011e7:	8a 00                	mov    (%eax),%al
  8011e9:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011eb:	ff 45 fc             	incl   -0x4(%ebp)
  8011ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011f1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011f4:	7c e1                	jl     8011d7 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011f6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011fd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801204:	eb 1f                	jmp    801225 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801206:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801209:	8d 50 01             	lea    0x1(%eax),%edx
  80120c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80120f:	89 c2                	mov    %eax,%edx
  801211:	8b 45 10             	mov    0x10(%ebp),%eax
  801214:	01 c2                	add    %eax,%edx
  801216:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801219:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121c:	01 c8                	add    %ecx,%eax
  80121e:	8a 00                	mov    (%eax),%al
  801220:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801222:	ff 45 f8             	incl   -0x8(%ebp)
  801225:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801228:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80122b:	7c d9                	jl     801206 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80122d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801230:	8b 45 10             	mov    0x10(%ebp),%eax
  801233:	01 d0                	add    %edx,%eax
  801235:	c6 00 00             	movb   $0x0,(%eax)
}
  801238:	90                   	nop
  801239:	c9                   	leave  
  80123a:	c3                   	ret    

0080123b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80123b:	55                   	push   %ebp
  80123c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80123e:	8b 45 14             	mov    0x14(%ebp),%eax
  801241:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801247:	8b 45 14             	mov    0x14(%ebp),%eax
  80124a:	8b 00                	mov    (%eax),%eax
  80124c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801253:	8b 45 10             	mov    0x10(%ebp),%eax
  801256:	01 d0                	add    %edx,%eax
  801258:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80125e:	eb 0c                	jmp    80126c <strsplit+0x31>
			*string++ = 0;
  801260:	8b 45 08             	mov    0x8(%ebp),%eax
  801263:	8d 50 01             	lea    0x1(%eax),%edx
  801266:	89 55 08             	mov    %edx,0x8(%ebp)
  801269:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	8a 00                	mov    (%eax),%al
  801271:	84 c0                	test   %al,%al
  801273:	74 18                	je     80128d <strsplit+0x52>
  801275:	8b 45 08             	mov    0x8(%ebp),%eax
  801278:	8a 00                	mov    (%eax),%al
  80127a:	0f be c0             	movsbl %al,%eax
  80127d:	50                   	push   %eax
  80127e:	ff 75 0c             	pushl  0xc(%ebp)
  801281:	e8 13 fb ff ff       	call   800d99 <strchr>
  801286:	83 c4 08             	add    $0x8,%esp
  801289:	85 c0                	test   %eax,%eax
  80128b:	75 d3                	jne    801260 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80128d:	8b 45 08             	mov    0x8(%ebp),%eax
  801290:	8a 00                	mov    (%eax),%al
  801292:	84 c0                	test   %al,%al
  801294:	74 5a                	je     8012f0 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801296:	8b 45 14             	mov    0x14(%ebp),%eax
  801299:	8b 00                	mov    (%eax),%eax
  80129b:	83 f8 0f             	cmp    $0xf,%eax
  80129e:	75 07                	jne    8012a7 <strsplit+0x6c>
		{
			return 0;
  8012a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8012a5:	eb 66                	jmp    80130d <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8012aa:	8b 00                	mov    (%eax),%eax
  8012ac:	8d 48 01             	lea    0x1(%eax),%ecx
  8012af:	8b 55 14             	mov    0x14(%ebp),%edx
  8012b2:	89 0a                	mov    %ecx,(%edx)
  8012b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012be:	01 c2                	add    %eax,%edx
  8012c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c3:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012c5:	eb 03                	jmp    8012ca <strsplit+0x8f>
			string++;
  8012c7:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cd:	8a 00                	mov    (%eax),%al
  8012cf:	84 c0                	test   %al,%al
  8012d1:	74 8b                	je     80125e <strsplit+0x23>
  8012d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d6:	8a 00                	mov    (%eax),%al
  8012d8:	0f be c0             	movsbl %al,%eax
  8012db:	50                   	push   %eax
  8012dc:	ff 75 0c             	pushl  0xc(%ebp)
  8012df:	e8 b5 fa ff ff       	call   800d99 <strchr>
  8012e4:	83 c4 08             	add    $0x8,%esp
  8012e7:	85 c0                	test   %eax,%eax
  8012e9:	74 dc                	je     8012c7 <strsplit+0x8c>
			string++;
	}
  8012eb:	e9 6e ff ff ff       	jmp    80125e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012f0:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f4:	8b 00                	mov    (%eax),%eax
  8012f6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801300:	01 d0                	add    %edx,%eax
  801302:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801308:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80130d:	c9                   	leave  
  80130e:	c3                   	ret    

0080130f <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80130f:	55                   	push   %ebp
  801310:	89 e5                	mov    %esp,%ebp
  801312:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801315:	a1 04 40 80 00       	mov    0x804004,%eax
  80131a:	85 c0                	test   %eax,%eax
  80131c:	74 1f                	je     80133d <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80131e:	e8 1d 00 00 00       	call   801340 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801323:	83 ec 0c             	sub    $0xc,%esp
  801326:	68 90 3a 80 00       	push   $0x803a90
  80132b:	e8 55 f2 ff ff       	call   800585 <cprintf>
  801330:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801333:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80133a:	00 00 00 
	}
}
  80133d:	90                   	nop
  80133e:	c9                   	leave  
  80133f:	c3                   	ret    

00801340 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801340:	55                   	push   %ebp
  801341:	89 e5                	mov    %esp,%ebp
  801343:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  801346:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80134d:	00 00 00 
  801350:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801357:	00 00 00 
  80135a:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801361:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  801364:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80136b:	00 00 00 
  80136e:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801375:	00 00 00 
  801378:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80137f:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  801382:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801389:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80138c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801391:	2d 00 10 00 00       	sub    $0x1000,%eax
  801396:	a3 50 40 80 00       	mov    %eax,0x804050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  80139b:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  8013a2:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  8013a5:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8013ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013af:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  8013b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8013b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8013bf:	f7 75 f0             	divl   -0x10(%ebp)
  8013c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013c5:	29 d0                	sub    %edx,%eax
  8013c7:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  8013ca:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8013d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013d4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013d9:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013de:	83 ec 04             	sub    $0x4,%esp
  8013e1:	6a 06                	push   $0x6
  8013e3:	ff 75 e8             	pushl  -0x18(%ebp)
  8013e6:	50                   	push   %eax
  8013e7:	e8 d4 05 00 00       	call   8019c0 <sys_allocate_chunk>
  8013ec:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013ef:	a1 20 41 80 00       	mov    0x804120,%eax
  8013f4:	83 ec 0c             	sub    $0xc,%esp
  8013f7:	50                   	push   %eax
  8013f8:	e8 49 0c 00 00       	call   802046 <initialize_MemBlocksList>
  8013fd:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  801400:	a1 48 41 80 00       	mov    0x804148,%eax
  801405:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  801408:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80140c:	75 14                	jne    801422 <initialize_dyn_block_system+0xe2>
  80140e:	83 ec 04             	sub    $0x4,%esp
  801411:	68 b5 3a 80 00       	push   $0x803ab5
  801416:	6a 39                	push   $0x39
  801418:	68 d3 3a 80 00       	push   $0x803ad3
  80141d:	e8 af ee ff ff       	call   8002d1 <_panic>
  801422:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801425:	8b 00                	mov    (%eax),%eax
  801427:	85 c0                	test   %eax,%eax
  801429:	74 10                	je     80143b <initialize_dyn_block_system+0xfb>
  80142b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80142e:	8b 00                	mov    (%eax),%eax
  801430:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801433:	8b 52 04             	mov    0x4(%edx),%edx
  801436:	89 50 04             	mov    %edx,0x4(%eax)
  801439:	eb 0b                	jmp    801446 <initialize_dyn_block_system+0x106>
  80143b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80143e:	8b 40 04             	mov    0x4(%eax),%eax
  801441:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801446:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801449:	8b 40 04             	mov    0x4(%eax),%eax
  80144c:	85 c0                	test   %eax,%eax
  80144e:	74 0f                	je     80145f <initialize_dyn_block_system+0x11f>
  801450:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801453:	8b 40 04             	mov    0x4(%eax),%eax
  801456:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801459:	8b 12                	mov    (%edx),%edx
  80145b:	89 10                	mov    %edx,(%eax)
  80145d:	eb 0a                	jmp    801469 <initialize_dyn_block_system+0x129>
  80145f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801462:	8b 00                	mov    (%eax),%eax
  801464:	a3 48 41 80 00       	mov    %eax,0x804148
  801469:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80146c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801472:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801475:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80147c:	a1 54 41 80 00       	mov    0x804154,%eax
  801481:	48                   	dec    %eax
  801482:	a3 54 41 80 00       	mov    %eax,0x804154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  801487:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80148a:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  801491:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801494:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  80149b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80149f:	75 14                	jne    8014b5 <initialize_dyn_block_system+0x175>
  8014a1:	83 ec 04             	sub    $0x4,%esp
  8014a4:	68 e0 3a 80 00       	push   $0x803ae0
  8014a9:	6a 3f                	push   $0x3f
  8014ab:	68 d3 3a 80 00       	push   $0x803ad3
  8014b0:	e8 1c ee ff ff       	call   8002d1 <_panic>
  8014b5:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8014bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014be:	89 10                	mov    %edx,(%eax)
  8014c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014c3:	8b 00                	mov    (%eax),%eax
  8014c5:	85 c0                	test   %eax,%eax
  8014c7:	74 0d                	je     8014d6 <initialize_dyn_block_system+0x196>
  8014c9:	a1 38 41 80 00       	mov    0x804138,%eax
  8014ce:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014d1:	89 50 04             	mov    %edx,0x4(%eax)
  8014d4:	eb 08                	jmp    8014de <initialize_dyn_block_system+0x19e>
  8014d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014d9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8014de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014e1:	a3 38 41 80 00       	mov    %eax,0x804138
  8014e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014f0:	a1 44 41 80 00       	mov    0x804144,%eax
  8014f5:	40                   	inc    %eax
  8014f6:	a3 44 41 80 00       	mov    %eax,0x804144

}
  8014fb:	90                   	nop
  8014fc:	c9                   	leave  
  8014fd:	c3                   	ret    

008014fe <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8014fe:	55                   	push   %ebp
  8014ff:	89 e5                	mov    %esp,%ebp
  801501:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801504:	e8 06 fe ff ff       	call   80130f <InitializeUHeap>
	if (size == 0) return NULL ;
  801509:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80150d:	75 07                	jne    801516 <malloc+0x18>
  80150f:	b8 00 00 00 00       	mov    $0x0,%eax
  801514:	eb 7d                	jmp    801593 <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  801516:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  80151d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801524:	8b 55 08             	mov    0x8(%ebp),%edx
  801527:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80152a:	01 d0                	add    %edx,%eax
  80152c:	48                   	dec    %eax
  80152d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801530:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801533:	ba 00 00 00 00       	mov    $0x0,%edx
  801538:	f7 75 f0             	divl   -0x10(%ebp)
  80153b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80153e:	29 d0                	sub    %edx,%eax
  801540:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  801543:	e8 46 08 00 00       	call   801d8e <sys_isUHeapPlacementStrategyFIRSTFIT>
  801548:	83 f8 01             	cmp    $0x1,%eax
  80154b:	75 07                	jne    801554 <malloc+0x56>
  80154d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  801554:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  801558:	75 34                	jne    80158e <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  80155a:	83 ec 0c             	sub    $0xc,%esp
  80155d:	ff 75 e8             	pushl  -0x18(%ebp)
  801560:	e8 73 0e 00 00       	call   8023d8 <alloc_block_FF>
  801565:	83 c4 10             	add    $0x10,%esp
  801568:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  80156b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80156f:	74 16                	je     801587 <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  801571:	83 ec 0c             	sub    $0xc,%esp
  801574:	ff 75 e4             	pushl  -0x1c(%ebp)
  801577:	e8 ff 0b 00 00       	call   80217b <insert_sorted_allocList>
  80157c:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  80157f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801582:	8b 40 08             	mov    0x8(%eax),%eax
  801585:	eb 0c                	jmp    801593 <malloc+0x95>
	             }
	             else
	             	return NULL;
  801587:	b8 00 00 00 00       	mov    $0x0,%eax
  80158c:	eb 05                	jmp    801593 <malloc+0x95>
	      	  }
	          else
	               return NULL;
  80158e:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  801593:	c9                   	leave  
  801594:	c3                   	ret    

00801595 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801595:	55                   	push   %ebp
  801596:	89 e5                	mov    %esp,%ebp
  801598:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  80159b:	8b 45 08             	mov    0x8(%ebp),%eax
  80159e:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  8015a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015aa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015af:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  8015b2:	83 ec 08             	sub    $0x8,%esp
  8015b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8015b8:	68 40 40 80 00       	push   $0x804040
  8015bd:	e8 61 0b 00 00       	call   802123 <find_block>
  8015c2:	83 c4 10             	add    $0x10,%esp
  8015c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  8015c8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015cc:	0f 84 a5 00 00 00    	je     801677 <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  8015d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8015d8:	83 ec 08             	sub    $0x8,%esp
  8015db:	50                   	push   %eax
  8015dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8015df:	e8 a4 03 00 00       	call   801988 <sys_free_user_mem>
  8015e4:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  8015e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015eb:	75 17                	jne    801604 <free+0x6f>
  8015ed:	83 ec 04             	sub    $0x4,%esp
  8015f0:	68 b5 3a 80 00       	push   $0x803ab5
  8015f5:	68 87 00 00 00       	push   $0x87
  8015fa:	68 d3 3a 80 00       	push   $0x803ad3
  8015ff:	e8 cd ec ff ff       	call   8002d1 <_panic>
  801604:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801607:	8b 00                	mov    (%eax),%eax
  801609:	85 c0                	test   %eax,%eax
  80160b:	74 10                	je     80161d <free+0x88>
  80160d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801610:	8b 00                	mov    (%eax),%eax
  801612:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801615:	8b 52 04             	mov    0x4(%edx),%edx
  801618:	89 50 04             	mov    %edx,0x4(%eax)
  80161b:	eb 0b                	jmp    801628 <free+0x93>
  80161d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801620:	8b 40 04             	mov    0x4(%eax),%eax
  801623:	a3 44 40 80 00       	mov    %eax,0x804044
  801628:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80162b:	8b 40 04             	mov    0x4(%eax),%eax
  80162e:	85 c0                	test   %eax,%eax
  801630:	74 0f                	je     801641 <free+0xac>
  801632:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801635:	8b 40 04             	mov    0x4(%eax),%eax
  801638:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80163b:	8b 12                	mov    (%edx),%edx
  80163d:	89 10                	mov    %edx,(%eax)
  80163f:	eb 0a                	jmp    80164b <free+0xb6>
  801641:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801644:	8b 00                	mov    (%eax),%eax
  801646:	a3 40 40 80 00       	mov    %eax,0x804040
  80164b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80164e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801654:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801657:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80165e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801663:	48                   	dec    %eax
  801664:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(theBlock);
  801669:	83 ec 0c             	sub    $0xc,%esp
  80166c:	ff 75 ec             	pushl  -0x14(%ebp)
  80166f:	e8 37 12 00 00       	call   8028ab <insert_sorted_with_merge_freeList>
  801674:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  801677:	90                   	nop
  801678:	c9                   	leave  
  801679:	c3                   	ret    

0080167a <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80167a:	55                   	push   %ebp
  80167b:	89 e5                	mov    %esp,%ebp
  80167d:	83 ec 38             	sub    $0x38,%esp
  801680:	8b 45 10             	mov    0x10(%ebp),%eax
  801683:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801686:	e8 84 fc ff ff       	call   80130f <InitializeUHeap>
	if (size == 0) return NULL ;
  80168b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80168f:	75 07                	jne    801698 <smalloc+0x1e>
  801691:	b8 00 00 00 00       	mov    $0x0,%eax
  801696:	eb 7e                	jmp    801716 <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  801698:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  80169f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8016a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ac:	01 d0                	add    %edx,%eax
  8016ae:	48                   	dec    %eax
  8016af:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ba:	f7 75 f0             	divl   -0x10(%ebp)
  8016bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016c0:	29 d0                	sub    %edx,%eax
  8016c2:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  8016c5:	e8 c4 06 00 00       	call   801d8e <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016ca:	83 f8 01             	cmp    $0x1,%eax
  8016cd:	75 42                	jne    801711 <smalloc+0x97>

		  va = malloc(newsize) ;
  8016cf:	83 ec 0c             	sub    $0xc,%esp
  8016d2:	ff 75 e8             	pushl  -0x18(%ebp)
  8016d5:	e8 24 fe ff ff       	call   8014fe <malloc>
  8016da:	83 c4 10             	add    $0x10,%esp
  8016dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  8016e0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8016e4:	74 24                	je     80170a <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  8016e6:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8016ea:	ff 75 e4             	pushl  -0x1c(%ebp)
  8016ed:	50                   	push   %eax
  8016ee:	ff 75 e8             	pushl  -0x18(%ebp)
  8016f1:	ff 75 08             	pushl  0x8(%ebp)
  8016f4:	e8 1a 04 00 00       	call   801b13 <sys_createSharedObject>
  8016f9:	83 c4 10             	add    $0x10,%esp
  8016fc:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  8016ff:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801703:	78 0c                	js     801711 <smalloc+0x97>
					  return va ;
  801705:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801708:	eb 0c                	jmp    801716 <smalloc+0x9c>
				 }
				 else
					return NULL;
  80170a:	b8 00 00 00 00       	mov    $0x0,%eax
  80170f:	eb 05                	jmp    801716 <smalloc+0x9c>
	  }
		  return NULL ;
  801711:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801716:	c9                   	leave  
  801717:	c3                   	ret    

00801718 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801718:	55                   	push   %ebp
  801719:	89 e5                	mov    %esp,%ebp
  80171b:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80171e:	e8 ec fb ff ff       	call   80130f <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  801723:	83 ec 08             	sub    $0x8,%esp
  801726:	ff 75 0c             	pushl  0xc(%ebp)
  801729:	ff 75 08             	pushl  0x8(%ebp)
  80172c:	e8 0c 04 00 00       	call   801b3d <sys_getSizeOfSharedObject>
  801731:	83 c4 10             	add    $0x10,%esp
  801734:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  801737:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  80173b:	75 07                	jne    801744 <sget+0x2c>
  80173d:	b8 00 00 00 00       	mov    $0x0,%eax
  801742:	eb 75                	jmp    8017b9 <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801744:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80174b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80174e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801751:	01 d0                	add    %edx,%eax
  801753:	48                   	dec    %eax
  801754:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801757:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80175a:	ba 00 00 00 00       	mov    $0x0,%edx
  80175f:	f7 75 f0             	divl   -0x10(%ebp)
  801762:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801765:	29 d0                	sub    %edx,%eax
  801767:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  80176a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801771:	e8 18 06 00 00       	call   801d8e <sys_isUHeapPlacementStrategyFIRSTFIT>
  801776:	83 f8 01             	cmp    $0x1,%eax
  801779:	75 39                	jne    8017b4 <sget+0x9c>

		  va = malloc(newsize) ;
  80177b:	83 ec 0c             	sub    $0xc,%esp
  80177e:	ff 75 e8             	pushl  -0x18(%ebp)
  801781:	e8 78 fd ff ff       	call   8014fe <malloc>
  801786:	83 c4 10             	add    $0x10,%esp
  801789:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  80178c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801790:	74 22                	je     8017b4 <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  801792:	83 ec 04             	sub    $0x4,%esp
  801795:	ff 75 e0             	pushl  -0x20(%ebp)
  801798:	ff 75 0c             	pushl  0xc(%ebp)
  80179b:	ff 75 08             	pushl  0x8(%ebp)
  80179e:	e8 b7 03 00 00       	call   801b5a <sys_getSharedObject>
  8017a3:	83 c4 10             	add    $0x10,%esp
  8017a6:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  8017a9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8017ad:	78 05                	js     8017b4 <sget+0x9c>
					  return va;
  8017af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017b2:	eb 05                	jmp    8017b9 <sget+0xa1>
				  }
			  }
     }
         return NULL;
  8017b4:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  8017b9:	c9                   	leave  
  8017ba:	c3                   	ret    

008017bb <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017bb:	55                   	push   %ebp
  8017bc:	89 e5                	mov    %esp,%ebp
  8017be:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017c1:	e8 49 fb ff ff       	call   80130f <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017c6:	83 ec 04             	sub    $0x4,%esp
  8017c9:	68 04 3b 80 00       	push   $0x803b04
  8017ce:	68 1e 01 00 00       	push   $0x11e
  8017d3:	68 d3 3a 80 00       	push   $0x803ad3
  8017d8:	e8 f4 ea ff ff       	call   8002d1 <_panic>

008017dd <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017dd:	55                   	push   %ebp
  8017de:	89 e5                	mov    %esp,%ebp
  8017e0:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017e3:	83 ec 04             	sub    $0x4,%esp
  8017e6:	68 2c 3b 80 00       	push   $0x803b2c
  8017eb:	68 32 01 00 00       	push   $0x132
  8017f0:	68 d3 3a 80 00       	push   $0x803ad3
  8017f5:	e8 d7 ea ff ff       	call   8002d1 <_panic>

008017fa <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
  8017fd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801800:	83 ec 04             	sub    $0x4,%esp
  801803:	68 50 3b 80 00       	push   $0x803b50
  801808:	68 3d 01 00 00       	push   $0x13d
  80180d:	68 d3 3a 80 00       	push   $0x803ad3
  801812:	e8 ba ea ff ff       	call   8002d1 <_panic>

00801817 <shrink>:

}
void shrink(uint32 newSize)
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
  80181a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80181d:	83 ec 04             	sub    $0x4,%esp
  801820:	68 50 3b 80 00       	push   $0x803b50
  801825:	68 42 01 00 00       	push   $0x142
  80182a:	68 d3 3a 80 00       	push   $0x803ad3
  80182f:	e8 9d ea ff ff       	call   8002d1 <_panic>

00801834 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801834:	55                   	push   %ebp
  801835:	89 e5                	mov    %esp,%ebp
  801837:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80183a:	83 ec 04             	sub    $0x4,%esp
  80183d:	68 50 3b 80 00       	push   $0x803b50
  801842:	68 47 01 00 00       	push   $0x147
  801847:	68 d3 3a 80 00       	push   $0x803ad3
  80184c:	e8 80 ea ff ff       	call   8002d1 <_panic>

00801851 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801851:	55                   	push   %ebp
  801852:	89 e5                	mov    %esp,%ebp
  801854:	57                   	push   %edi
  801855:	56                   	push   %esi
  801856:	53                   	push   %ebx
  801857:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80185a:	8b 45 08             	mov    0x8(%ebp),%eax
  80185d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801860:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801863:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801866:	8b 7d 18             	mov    0x18(%ebp),%edi
  801869:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80186c:	cd 30                	int    $0x30
  80186e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801871:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801874:	83 c4 10             	add    $0x10,%esp
  801877:	5b                   	pop    %ebx
  801878:	5e                   	pop    %esi
  801879:	5f                   	pop    %edi
  80187a:	5d                   	pop    %ebp
  80187b:	c3                   	ret    

0080187c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
  80187f:	83 ec 04             	sub    $0x4,%esp
  801882:	8b 45 10             	mov    0x10(%ebp),%eax
  801885:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801888:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80188c:	8b 45 08             	mov    0x8(%ebp),%eax
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	52                   	push   %edx
  801894:	ff 75 0c             	pushl  0xc(%ebp)
  801897:	50                   	push   %eax
  801898:	6a 00                	push   $0x0
  80189a:	e8 b2 ff ff ff       	call   801851 <syscall>
  80189f:	83 c4 18             	add    $0x18,%esp
}
  8018a2:	90                   	nop
  8018a3:	c9                   	leave  
  8018a4:	c3                   	ret    

008018a5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018a5:	55                   	push   %ebp
  8018a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 01                	push   $0x1
  8018b4:	e8 98 ff ff ff       	call   801851 <syscall>
  8018b9:	83 c4 18             	add    $0x18,%esp
}
  8018bc:	c9                   	leave  
  8018bd:	c3                   	ret    

008018be <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	52                   	push   %edx
  8018ce:	50                   	push   %eax
  8018cf:	6a 05                	push   $0x5
  8018d1:	e8 7b ff ff ff       	call   801851 <syscall>
  8018d6:	83 c4 18             	add    $0x18,%esp
}
  8018d9:	c9                   	leave  
  8018da:	c3                   	ret    

008018db <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
  8018de:	56                   	push   %esi
  8018df:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018e0:	8b 75 18             	mov    0x18(%ebp),%esi
  8018e3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018e6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ef:	56                   	push   %esi
  8018f0:	53                   	push   %ebx
  8018f1:	51                   	push   %ecx
  8018f2:	52                   	push   %edx
  8018f3:	50                   	push   %eax
  8018f4:	6a 06                	push   $0x6
  8018f6:	e8 56 ff ff ff       	call   801851 <syscall>
  8018fb:	83 c4 18             	add    $0x18,%esp
}
  8018fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801901:	5b                   	pop    %ebx
  801902:	5e                   	pop    %esi
  801903:	5d                   	pop    %ebp
  801904:	c3                   	ret    

00801905 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801905:	55                   	push   %ebp
  801906:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801908:	8b 55 0c             	mov    0xc(%ebp),%edx
  80190b:	8b 45 08             	mov    0x8(%ebp),%eax
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	52                   	push   %edx
  801915:	50                   	push   %eax
  801916:	6a 07                	push   $0x7
  801918:	e8 34 ff ff ff       	call   801851 <syscall>
  80191d:	83 c4 18             	add    $0x18,%esp
}
  801920:	c9                   	leave  
  801921:	c3                   	ret    

00801922 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801922:	55                   	push   %ebp
  801923:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	ff 75 0c             	pushl  0xc(%ebp)
  80192e:	ff 75 08             	pushl  0x8(%ebp)
  801931:	6a 08                	push   $0x8
  801933:	e8 19 ff ff ff       	call   801851 <syscall>
  801938:	83 c4 18             	add    $0x18,%esp
}
  80193b:	c9                   	leave  
  80193c:	c3                   	ret    

0080193d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80193d:	55                   	push   %ebp
  80193e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 09                	push   $0x9
  80194c:	e8 00 ff ff ff       	call   801851 <syscall>
  801951:	83 c4 18             	add    $0x18,%esp
}
  801954:	c9                   	leave  
  801955:	c3                   	ret    

00801956 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801956:	55                   	push   %ebp
  801957:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 0a                	push   $0xa
  801965:	e8 e7 fe ff ff       	call   801851 <syscall>
  80196a:	83 c4 18             	add    $0x18,%esp
}
  80196d:	c9                   	leave  
  80196e:	c3                   	ret    

0080196f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80196f:	55                   	push   %ebp
  801970:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	6a 0b                	push   $0xb
  80197e:	e8 ce fe ff ff       	call   801851 <syscall>
  801983:	83 c4 18             	add    $0x18,%esp
}
  801986:	c9                   	leave  
  801987:	c3                   	ret    

00801988 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801988:	55                   	push   %ebp
  801989:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	ff 75 0c             	pushl  0xc(%ebp)
  801994:	ff 75 08             	pushl  0x8(%ebp)
  801997:	6a 0f                	push   $0xf
  801999:	e8 b3 fe ff ff       	call   801851 <syscall>
  80199e:	83 c4 18             	add    $0x18,%esp
	return;
  8019a1:	90                   	nop
}
  8019a2:	c9                   	leave  
  8019a3:	c3                   	ret    

008019a4 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019a4:	55                   	push   %ebp
  8019a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	ff 75 0c             	pushl  0xc(%ebp)
  8019b0:	ff 75 08             	pushl  0x8(%ebp)
  8019b3:	6a 10                	push   $0x10
  8019b5:	e8 97 fe ff ff       	call   801851 <syscall>
  8019ba:	83 c4 18             	add    $0x18,%esp
	return ;
  8019bd:	90                   	nop
}
  8019be:	c9                   	leave  
  8019bf:	c3                   	ret    

008019c0 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	ff 75 10             	pushl  0x10(%ebp)
  8019ca:	ff 75 0c             	pushl  0xc(%ebp)
  8019cd:	ff 75 08             	pushl  0x8(%ebp)
  8019d0:	6a 11                	push   $0x11
  8019d2:	e8 7a fe ff ff       	call   801851 <syscall>
  8019d7:	83 c4 18             	add    $0x18,%esp
	return ;
  8019da:	90                   	nop
}
  8019db:	c9                   	leave  
  8019dc:	c3                   	ret    

008019dd <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 0c                	push   $0xc
  8019ec:	e8 60 fe ff ff       	call   801851 <syscall>
  8019f1:	83 c4 18             	add    $0x18,%esp
}
  8019f4:	c9                   	leave  
  8019f5:	c3                   	ret    

008019f6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019f6:	55                   	push   %ebp
  8019f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	ff 75 08             	pushl  0x8(%ebp)
  801a04:	6a 0d                	push   $0xd
  801a06:	e8 46 fe ff ff       	call   801851 <syscall>
  801a0b:	83 c4 18             	add    $0x18,%esp
}
  801a0e:	c9                   	leave  
  801a0f:	c3                   	ret    

00801a10 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 0e                	push   $0xe
  801a1f:	e8 2d fe ff ff       	call   801851 <syscall>
  801a24:	83 c4 18             	add    $0x18,%esp
}
  801a27:	90                   	nop
  801a28:	c9                   	leave  
  801a29:	c3                   	ret    

00801a2a <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 13                	push   $0x13
  801a39:	e8 13 fe ff ff       	call   801851 <syscall>
  801a3e:	83 c4 18             	add    $0x18,%esp
}
  801a41:	90                   	nop
  801a42:	c9                   	leave  
  801a43:	c3                   	ret    

00801a44 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a44:	55                   	push   %ebp
  801a45:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 14                	push   $0x14
  801a53:	e8 f9 fd ff ff       	call   801851 <syscall>
  801a58:	83 c4 18             	add    $0x18,%esp
}
  801a5b:	90                   	nop
  801a5c:	c9                   	leave  
  801a5d:	c3                   	ret    

00801a5e <sys_cputc>:


void
sys_cputc(const char c)
{
  801a5e:	55                   	push   %ebp
  801a5f:	89 e5                	mov    %esp,%ebp
  801a61:	83 ec 04             	sub    $0x4,%esp
  801a64:	8b 45 08             	mov    0x8(%ebp),%eax
  801a67:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a6a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	50                   	push   %eax
  801a77:	6a 15                	push   $0x15
  801a79:	e8 d3 fd ff ff       	call   801851 <syscall>
  801a7e:	83 c4 18             	add    $0x18,%esp
}
  801a81:	90                   	nop
  801a82:	c9                   	leave  
  801a83:	c3                   	ret    

00801a84 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a84:	55                   	push   %ebp
  801a85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 16                	push   $0x16
  801a93:	e8 b9 fd ff ff       	call   801851 <syscall>
  801a98:	83 c4 18             	add    $0x18,%esp
}
  801a9b:	90                   	nop
  801a9c:	c9                   	leave  
  801a9d:	c3                   	ret    

00801a9e <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	ff 75 0c             	pushl  0xc(%ebp)
  801aad:	50                   	push   %eax
  801aae:	6a 17                	push   $0x17
  801ab0:	e8 9c fd ff ff       	call   801851 <syscall>
  801ab5:	83 c4 18             	add    $0x18,%esp
}
  801ab8:	c9                   	leave  
  801ab9:	c3                   	ret    

00801aba <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801abd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	52                   	push   %edx
  801aca:	50                   	push   %eax
  801acb:	6a 1a                	push   $0x1a
  801acd:	e8 7f fd ff ff       	call   801851 <syscall>
  801ad2:	83 c4 18             	add    $0x18,%esp
}
  801ad5:	c9                   	leave  
  801ad6:	c3                   	ret    

00801ad7 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ad7:	55                   	push   %ebp
  801ad8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ada:	8b 55 0c             	mov    0xc(%ebp),%edx
  801add:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	52                   	push   %edx
  801ae7:	50                   	push   %eax
  801ae8:	6a 18                	push   $0x18
  801aea:	e8 62 fd ff ff       	call   801851 <syscall>
  801aef:	83 c4 18             	add    $0x18,%esp
}
  801af2:	90                   	nop
  801af3:	c9                   	leave  
  801af4:	c3                   	ret    

00801af5 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801af8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801afb:	8b 45 08             	mov    0x8(%ebp),%eax
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	52                   	push   %edx
  801b05:	50                   	push   %eax
  801b06:	6a 19                	push   $0x19
  801b08:	e8 44 fd ff ff       	call   801851 <syscall>
  801b0d:	83 c4 18             	add    $0x18,%esp
}
  801b10:	90                   	nop
  801b11:	c9                   	leave  
  801b12:	c3                   	ret    

00801b13 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b13:	55                   	push   %ebp
  801b14:	89 e5                	mov    %esp,%ebp
  801b16:	83 ec 04             	sub    $0x4,%esp
  801b19:	8b 45 10             	mov    0x10(%ebp),%eax
  801b1c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b1f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b22:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b26:	8b 45 08             	mov    0x8(%ebp),%eax
  801b29:	6a 00                	push   $0x0
  801b2b:	51                   	push   %ecx
  801b2c:	52                   	push   %edx
  801b2d:	ff 75 0c             	pushl  0xc(%ebp)
  801b30:	50                   	push   %eax
  801b31:	6a 1b                	push   $0x1b
  801b33:	e8 19 fd ff ff       	call   801851 <syscall>
  801b38:	83 c4 18             	add    $0x18,%esp
}
  801b3b:	c9                   	leave  
  801b3c:	c3                   	ret    

00801b3d <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b3d:	55                   	push   %ebp
  801b3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b40:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b43:	8b 45 08             	mov    0x8(%ebp),%eax
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	52                   	push   %edx
  801b4d:	50                   	push   %eax
  801b4e:	6a 1c                	push   $0x1c
  801b50:	e8 fc fc ff ff       	call   801851 <syscall>
  801b55:	83 c4 18             	add    $0x18,%esp
}
  801b58:	c9                   	leave  
  801b59:	c3                   	ret    

00801b5a <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b5d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b63:	8b 45 08             	mov    0x8(%ebp),%eax
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	51                   	push   %ecx
  801b6b:	52                   	push   %edx
  801b6c:	50                   	push   %eax
  801b6d:	6a 1d                	push   $0x1d
  801b6f:	e8 dd fc ff ff       	call   801851 <syscall>
  801b74:	83 c4 18             	add    $0x18,%esp
}
  801b77:	c9                   	leave  
  801b78:	c3                   	ret    

00801b79 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b79:	55                   	push   %ebp
  801b7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	52                   	push   %edx
  801b89:	50                   	push   %eax
  801b8a:	6a 1e                	push   $0x1e
  801b8c:	e8 c0 fc ff ff       	call   801851 <syscall>
  801b91:	83 c4 18             	add    $0x18,%esp
}
  801b94:	c9                   	leave  
  801b95:	c3                   	ret    

00801b96 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b96:	55                   	push   %ebp
  801b97:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 1f                	push   $0x1f
  801ba5:	e8 a7 fc ff ff       	call   801851 <syscall>
  801baa:	83 c4 18             	add    $0x18,%esp
}
  801bad:	c9                   	leave  
  801bae:	c3                   	ret    

00801baf <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801baf:	55                   	push   %ebp
  801bb0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb5:	6a 00                	push   $0x0
  801bb7:	ff 75 14             	pushl  0x14(%ebp)
  801bba:	ff 75 10             	pushl  0x10(%ebp)
  801bbd:	ff 75 0c             	pushl  0xc(%ebp)
  801bc0:	50                   	push   %eax
  801bc1:	6a 20                	push   $0x20
  801bc3:	e8 89 fc ff ff       	call   801851 <syscall>
  801bc8:	83 c4 18             	add    $0x18,%esp
}
  801bcb:	c9                   	leave  
  801bcc:	c3                   	ret    

00801bcd <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801bcd:	55                   	push   %ebp
  801bce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	50                   	push   %eax
  801bdc:	6a 21                	push   $0x21
  801bde:	e8 6e fc ff ff       	call   801851 <syscall>
  801be3:	83 c4 18             	add    $0x18,%esp
}
  801be6:	90                   	nop
  801be7:	c9                   	leave  
  801be8:	c3                   	ret    

00801be9 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801be9:	55                   	push   %ebp
  801bea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bec:	8b 45 08             	mov    0x8(%ebp),%eax
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	50                   	push   %eax
  801bf8:	6a 22                	push   $0x22
  801bfa:	e8 52 fc ff ff       	call   801851 <syscall>
  801bff:	83 c4 18             	add    $0x18,%esp
}
  801c02:	c9                   	leave  
  801c03:	c3                   	ret    

00801c04 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c04:	55                   	push   %ebp
  801c05:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 02                	push   $0x2
  801c13:	e8 39 fc ff ff       	call   801851 <syscall>
  801c18:	83 c4 18             	add    $0x18,%esp
}
  801c1b:	c9                   	leave  
  801c1c:	c3                   	ret    

00801c1d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c1d:	55                   	push   %ebp
  801c1e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 03                	push   $0x3
  801c2c:	e8 20 fc ff ff       	call   801851 <syscall>
  801c31:	83 c4 18             	add    $0x18,%esp
}
  801c34:	c9                   	leave  
  801c35:	c3                   	ret    

00801c36 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c36:	55                   	push   %ebp
  801c37:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 04                	push   $0x4
  801c45:	e8 07 fc ff ff       	call   801851 <syscall>
  801c4a:	83 c4 18             	add    $0x18,%esp
}
  801c4d:	c9                   	leave  
  801c4e:	c3                   	ret    

00801c4f <sys_exit_env>:


void sys_exit_env(void)
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 23                	push   $0x23
  801c5e:	e8 ee fb ff ff       	call   801851 <syscall>
  801c63:	83 c4 18             	add    $0x18,%esp
}
  801c66:	90                   	nop
  801c67:	c9                   	leave  
  801c68:	c3                   	ret    

00801c69 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c69:	55                   	push   %ebp
  801c6a:	89 e5                	mov    %esp,%ebp
  801c6c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c6f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c72:	8d 50 04             	lea    0x4(%eax),%edx
  801c75:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	52                   	push   %edx
  801c7f:	50                   	push   %eax
  801c80:	6a 24                	push   $0x24
  801c82:	e8 ca fb ff ff       	call   801851 <syscall>
  801c87:	83 c4 18             	add    $0x18,%esp
	return result;
  801c8a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c90:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c93:	89 01                	mov    %eax,(%ecx)
  801c95:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c98:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9b:	c9                   	leave  
  801c9c:	c2 04 00             	ret    $0x4

00801c9f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	ff 75 10             	pushl  0x10(%ebp)
  801ca9:	ff 75 0c             	pushl  0xc(%ebp)
  801cac:	ff 75 08             	pushl  0x8(%ebp)
  801caf:	6a 12                	push   $0x12
  801cb1:	e8 9b fb ff ff       	call   801851 <syscall>
  801cb6:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb9:	90                   	nop
}
  801cba:	c9                   	leave  
  801cbb:	c3                   	ret    

00801cbc <sys_rcr2>:
uint32 sys_rcr2()
{
  801cbc:	55                   	push   %ebp
  801cbd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 25                	push   $0x25
  801ccb:	e8 81 fb ff ff       	call   801851 <syscall>
  801cd0:	83 c4 18             	add    $0x18,%esp
}
  801cd3:	c9                   	leave  
  801cd4:	c3                   	ret    

00801cd5 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801cd5:	55                   	push   %ebp
  801cd6:	89 e5                	mov    %esp,%ebp
  801cd8:	83 ec 04             	sub    $0x4,%esp
  801cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cde:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ce1:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	50                   	push   %eax
  801cee:	6a 26                	push   $0x26
  801cf0:	e8 5c fb ff ff       	call   801851 <syscall>
  801cf5:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf8:	90                   	nop
}
  801cf9:	c9                   	leave  
  801cfa:	c3                   	ret    

00801cfb <rsttst>:
void rsttst()
{
  801cfb:	55                   	push   %ebp
  801cfc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 28                	push   $0x28
  801d0a:	e8 42 fb ff ff       	call   801851 <syscall>
  801d0f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d12:	90                   	nop
}
  801d13:	c9                   	leave  
  801d14:	c3                   	ret    

00801d15 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
  801d18:	83 ec 04             	sub    $0x4,%esp
  801d1b:	8b 45 14             	mov    0x14(%ebp),%eax
  801d1e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d21:	8b 55 18             	mov    0x18(%ebp),%edx
  801d24:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d28:	52                   	push   %edx
  801d29:	50                   	push   %eax
  801d2a:	ff 75 10             	pushl  0x10(%ebp)
  801d2d:	ff 75 0c             	pushl  0xc(%ebp)
  801d30:	ff 75 08             	pushl  0x8(%ebp)
  801d33:	6a 27                	push   $0x27
  801d35:	e8 17 fb ff ff       	call   801851 <syscall>
  801d3a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d3d:	90                   	nop
}
  801d3e:	c9                   	leave  
  801d3f:	c3                   	ret    

00801d40 <chktst>:
void chktst(uint32 n)
{
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	ff 75 08             	pushl  0x8(%ebp)
  801d4e:	6a 29                	push   $0x29
  801d50:	e8 fc fa ff ff       	call   801851 <syscall>
  801d55:	83 c4 18             	add    $0x18,%esp
	return ;
  801d58:	90                   	nop
}
  801d59:	c9                   	leave  
  801d5a:	c3                   	ret    

00801d5b <inctst>:

void inctst()
{
  801d5b:	55                   	push   %ebp
  801d5c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 2a                	push   $0x2a
  801d6a:	e8 e2 fa ff ff       	call   801851 <syscall>
  801d6f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d72:	90                   	nop
}
  801d73:	c9                   	leave  
  801d74:	c3                   	ret    

00801d75 <gettst>:
uint32 gettst()
{
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	6a 2b                	push   $0x2b
  801d84:	e8 c8 fa ff ff       	call   801851 <syscall>
  801d89:	83 c4 18             	add    $0x18,%esp
}
  801d8c:	c9                   	leave  
  801d8d:	c3                   	ret    

00801d8e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d8e:	55                   	push   %ebp
  801d8f:	89 e5                	mov    %esp,%ebp
  801d91:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 2c                	push   $0x2c
  801da0:	e8 ac fa ff ff       	call   801851 <syscall>
  801da5:	83 c4 18             	add    $0x18,%esp
  801da8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801dab:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801daf:	75 07                	jne    801db8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801db1:	b8 01 00 00 00       	mov    $0x1,%eax
  801db6:	eb 05                	jmp    801dbd <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801db8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dbd:	c9                   	leave  
  801dbe:	c3                   	ret    

00801dbf <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801dbf:	55                   	push   %ebp
  801dc0:	89 e5                	mov    %esp,%ebp
  801dc2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 2c                	push   $0x2c
  801dd1:	e8 7b fa ff ff       	call   801851 <syscall>
  801dd6:	83 c4 18             	add    $0x18,%esp
  801dd9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ddc:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801de0:	75 07                	jne    801de9 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801de2:	b8 01 00 00 00       	mov    $0x1,%eax
  801de7:	eb 05                	jmp    801dee <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801de9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dee:	c9                   	leave  
  801def:	c3                   	ret    

00801df0 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
  801df3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 2c                	push   $0x2c
  801e02:	e8 4a fa ff ff       	call   801851 <syscall>
  801e07:	83 c4 18             	add    $0x18,%esp
  801e0a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e0d:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e11:	75 07                	jne    801e1a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e13:	b8 01 00 00 00       	mov    $0x1,%eax
  801e18:	eb 05                	jmp    801e1f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e1f:	c9                   	leave  
  801e20:	c3                   	ret    

00801e21 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e21:	55                   	push   %ebp
  801e22:	89 e5                	mov    %esp,%ebp
  801e24:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 2c                	push   $0x2c
  801e33:	e8 19 fa ff ff       	call   801851 <syscall>
  801e38:	83 c4 18             	add    $0x18,%esp
  801e3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e3e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e42:	75 07                	jne    801e4b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e44:	b8 01 00 00 00       	mov    $0x1,%eax
  801e49:	eb 05                	jmp    801e50 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e50:	c9                   	leave  
  801e51:	c3                   	ret    

00801e52 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	ff 75 08             	pushl  0x8(%ebp)
  801e60:	6a 2d                	push   $0x2d
  801e62:	e8 ea f9 ff ff       	call   801851 <syscall>
  801e67:	83 c4 18             	add    $0x18,%esp
	return ;
  801e6a:	90                   	nop
}
  801e6b:	c9                   	leave  
  801e6c:	c3                   	ret    

00801e6d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e6d:	55                   	push   %ebp
  801e6e:	89 e5                	mov    %esp,%ebp
  801e70:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e71:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e74:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e77:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7d:	6a 00                	push   $0x0
  801e7f:	53                   	push   %ebx
  801e80:	51                   	push   %ecx
  801e81:	52                   	push   %edx
  801e82:	50                   	push   %eax
  801e83:	6a 2e                	push   $0x2e
  801e85:	e8 c7 f9 ff ff       	call   801851 <syscall>
  801e8a:	83 c4 18             	add    $0x18,%esp
}
  801e8d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e90:	c9                   	leave  
  801e91:	c3                   	ret    

00801e92 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e92:	55                   	push   %ebp
  801e93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e95:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e98:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	52                   	push   %edx
  801ea2:	50                   	push   %eax
  801ea3:	6a 2f                	push   $0x2f
  801ea5:	e8 a7 f9 ff ff       	call   801851 <syscall>
  801eaa:	83 c4 18             	add    $0x18,%esp
}
  801ead:	c9                   	leave  
  801eae:	c3                   	ret    

00801eaf <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801eaf:	55                   	push   %ebp
  801eb0:	89 e5                	mov    %esp,%ebp
  801eb2:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801eb5:	83 ec 0c             	sub    $0xc,%esp
  801eb8:	68 60 3b 80 00       	push   $0x803b60
  801ebd:	e8 c3 e6 ff ff       	call   800585 <cprintf>
  801ec2:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801ec5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801ecc:	83 ec 0c             	sub    $0xc,%esp
  801ecf:	68 8c 3b 80 00       	push   $0x803b8c
  801ed4:	e8 ac e6 ff ff       	call   800585 <cprintf>
  801ed9:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801edc:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ee0:	a1 38 41 80 00       	mov    0x804138,%eax
  801ee5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ee8:	eb 56                	jmp    801f40 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801eea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801eee:	74 1c                	je     801f0c <print_mem_block_lists+0x5d>
  801ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef3:	8b 50 08             	mov    0x8(%eax),%edx
  801ef6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ef9:	8b 48 08             	mov    0x8(%eax),%ecx
  801efc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eff:	8b 40 0c             	mov    0xc(%eax),%eax
  801f02:	01 c8                	add    %ecx,%eax
  801f04:	39 c2                	cmp    %eax,%edx
  801f06:	73 04                	jae    801f0c <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f08:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0f:	8b 50 08             	mov    0x8(%eax),%edx
  801f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f15:	8b 40 0c             	mov    0xc(%eax),%eax
  801f18:	01 c2                	add    %eax,%edx
  801f1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1d:	8b 40 08             	mov    0x8(%eax),%eax
  801f20:	83 ec 04             	sub    $0x4,%esp
  801f23:	52                   	push   %edx
  801f24:	50                   	push   %eax
  801f25:	68 a1 3b 80 00       	push   $0x803ba1
  801f2a:	e8 56 e6 ff ff       	call   800585 <cprintf>
  801f2f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f35:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f38:	a1 40 41 80 00       	mov    0x804140,%eax
  801f3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f40:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f44:	74 07                	je     801f4d <print_mem_block_lists+0x9e>
  801f46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f49:	8b 00                	mov    (%eax),%eax
  801f4b:	eb 05                	jmp    801f52 <print_mem_block_lists+0xa3>
  801f4d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f52:	a3 40 41 80 00       	mov    %eax,0x804140
  801f57:	a1 40 41 80 00       	mov    0x804140,%eax
  801f5c:	85 c0                	test   %eax,%eax
  801f5e:	75 8a                	jne    801eea <print_mem_block_lists+0x3b>
  801f60:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f64:	75 84                	jne    801eea <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f66:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f6a:	75 10                	jne    801f7c <print_mem_block_lists+0xcd>
  801f6c:	83 ec 0c             	sub    $0xc,%esp
  801f6f:	68 b0 3b 80 00       	push   $0x803bb0
  801f74:	e8 0c e6 ff ff       	call   800585 <cprintf>
  801f79:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f7c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f83:	83 ec 0c             	sub    $0xc,%esp
  801f86:	68 d4 3b 80 00       	push   $0x803bd4
  801f8b:	e8 f5 e5 ff ff       	call   800585 <cprintf>
  801f90:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f93:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f97:	a1 40 40 80 00       	mov    0x804040,%eax
  801f9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f9f:	eb 56                	jmp    801ff7 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fa1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fa5:	74 1c                	je     801fc3 <print_mem_block_lists+0x114>
  801fa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801faa:	8b 50 08             	mov    0x8(%eax),%edx
  801fad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fb0:	8b 48 08             	mov    0x8(%eax),%ecx
  801fb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fb6:	8b 40 0c             	mov    0xc(%eax),%eax
  801fb9:	01 c8                	add    %ecx,%eax
  801fbb:	39 c2                	cmp    %eax,%edx
  801fbd:	73 04                	jae    801fc3 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801fbf:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc6:	8b 50 08             	mov    0x8(%eax),%edx
  801fc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fcc:	8b 40 0c             	mov    0xc(%eax),%eax
  801fcf:	01 c2                	add    %eax,%edx
  801fd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd4:	8b 40 08             	mov    0x8(%eax),%eax
  801fd7:	83 ec 04             	sub    $0x4,%esp
  801fda:	52                   	push   %edx
  801fdb:	50                   	push   %eax
  801fdc:	68 a1 3b 80 00       	push   $0x803ba1
  801fe1:	e8 9f e5 ff ff       	call   800585 <cprintf>
  801fe6:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fef:	a1 48 40 80 00       	mov    0x804048,%eax
  801ff4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ff7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ffb:	74 07                	je     802004 <print_mem_block_lists+0x155>
  801ffd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802000:	8b 00                	mov    (%eax),%eax
  802002:	eb 05                	jmp    802009 <print_mem_block_lists+0x15a>
  802004:	b8 00 00 00 00       	mov    $0x0,%eax
  802009:	a3 48 40 80 00       	mov    %eax,0x804048
  80200e:	a1 48 40 80 00       	mov    0x804048,%eax
  802013:	85 c0                	test   %eax,%eax
  802015:	75 8a                	jne    801fa1 <print_mem_block_lists+0xf2>
  802017:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80201b:	75 84                	jne    801fa1 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80201d:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802021:	75 10                	jne    802033 <print_mem_block_lists+0x184>
  802023:	83 ec 0c             	sub    $0xc,%esp
  802026:	68 ec 3b 80 00       	push   $0x803bec
  80202b:	e8 55 e5 ff ff       	call   800585 <cprintf>
  802030:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802033:	83 ec 0c             	sub    $0xc,%esp
  802036:	68 60 3b 80 00       	push   $0x803b60
  80203b:	e8 45 e5 ff ff       	call   800585 <cprintf>
  802040:	83 c4 10             	add    $0x10,%esp

}
  802043:	90                   	nop
  802044:	c9                   	leave  
  802045:	c3                   	ret    

00802046 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802046:	55                   	push   %ebp
  802047:	89 e5                	mov    %esp,%ebp
  802049:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  80204c:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802053:	00 00 00 
  802056:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  80205d:	00 00 00 
  802060:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802067:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  80206a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802071:	e9 9e 00 00 00       	jmp    802114 <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802076:	a1 50 40 80 00       	mov    0x804050,%eax
  80207b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80207e:	c1 e2 04             	shl    $0x4,%edx
  802081:	01 d0                	add    %edx,%eax
  802083:	85 c0                	test   %eax,%eax
  802085:	75 14                	jne    80209b <initialize_MemBlocksList+0x55>
  802087:	83 ec 04             	sub    $0x4,%esp
  80208a:	68 14 3c 80 00       	push   $0x803c14
  80208f:	6a 47                	push   $0x47
  802091:	68 37 3c 80 00       	push   $0x803c37
  802096:	e8 36 e2 ff ff       	call   8002d1 <_panic>
  80209b:	a1 50 40 80 00       	mov    0x804050,%eax
  8020a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020a3:	c1 e2 04             	shl    $0x4,%edx
  8020a6:	01 d0                	add    %edx,%eax
  8020a8:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8020ae:	89 10                	mov    %edx,(%eax)
  8020b0:	8b 00                	mov    (%eax),%eax
  8020b2:	85 c0                	test   %eax,%eax
  8020b4:	74 18                	je     8020ce <initialize_MemBlocksList+0x88>
  8020b6:	a1 48 41 80 00       	mov    0x804148,%eax
  8020bb:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8020c1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8020c4:	c1 e1 04             	shl    $0x4,%ecx
  8020c7:	01 ca                	add    %ecx,%edx
  8020c9:	89 50 04             	mov    %edx,0x4(%eax)
  8020cc:	eb 12                	jmp    8020e0 <initialize_MemBlocksList+0x9a>
  8020ce:	a1 50 40 80 00       	mov    0x804050,%eax
  8020d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020d6:	c1 e2 04             	shl    $0x4,%edx
  8020d9:	01 d0                	add    %edx,%eax
  8020db:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8020e0:	a1 50 40 80 00       	mov    0x804050,%eax
  8020e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020e8:	c1 e2 04             	shl    $0x4,%edx
  8020eb:	01 d0                	add    %edx,%eax
  8020ed:	a3 48 41 80 00       	mov    %eax,0x804148
  8020f2:	a1 50 40 80 00       	mov    0x804050,%eax
  8020f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020fa:	c1 e2 04             	shl    $0x4,%edx
  8020fd:	01 d0                	add    %edx,%eax
  8020ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802106:	a1 54 41 80 00       	mov    0x804154,%eax
  80210b:	40                   	inc    %eax
  80210c:	a3 54 41 80 00       	mov    %eax,0x804154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802111:	ff 45 f4             	incl   -0xc(%ebp)
  802114:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802117:	3b 45 08             	cmp    0x8(%ebp),%eax
  80211a:	0f 82 56 ff ff ff    	jb     802076 <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  802120:	90                   	nop
  802121:	c9                   	leave  
  802122:	c3                   	ret    

00802123 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802123:	55                   	push   %ebp
  802124:	89 e5                	mov    %esp,%ebp
  802126:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802129:	8b 45 08             	mov    0x8(%ebp),%eax
  80212c:	8b 00                	mov    (%eax),%eax
  80212e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802131:	eb 19                	jmp    80214c <find_block+0x29>
	{
		if(element->sva == va){
  802133:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802136:	8b 40 08             	mov    0x8(%eax),%eax
  802139:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80213c:	75 05                	jne    802143 <find_block+0x20>
			 		return element;
  80213e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802141:	eb 36                	jmp    802179 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802143:	8b 45 08             	mov    0x8(%ebp),%eax
  802146:	8b 40 08             	mov    0x8(%eax),%eax
  802149:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80214c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802150:	74 07                	je     802159 <find_block+0x36>
  802152:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802155:	8b 00                	mov    (%eax),%eax
  802157:	eb 05                	jmp    80215e <find_block+0x3b>
  802159:	b8 00 00 00 00       	mov    $0x0,%eax
  80215e:	8b 55 08             	mov    0x8(%ebp),%edx
  802161:	89 42 08             	mov    %eax,0x8(%edx)
  802164:	8b 45 08             	mov    0x8(%ebp),%eax
  802167:	8b 40 08             	mov    0x8(%eax),%eax
  80216a:	85 c0                	test   %eax,%eax
  80216c:	75 c5                	jne    802133 <find_block+0x10>
  80216e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802172:	75 bf                	jne    802133 <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  802174:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802179:	c9                   	leave  
  80217a:	c3                   	ret    

0080217b <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80217b:	55                   	push   %ebp
  80217c:	89 e5                	mov    %esp,%ebp
  80217e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  802181:	a1 44 40 80 00       	mov    0x804044,%eax
  802186:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  802189:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80218e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  802191:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802195:	74 0a                	je     8021a1 <insert_sorted_allocList+0x26>
  802197:	8b 45 08             	mov    0x8(%ebp),%eax
  80219a:	8b 40 08             	mov    0x8(%eax),%eax
  80219d:	85 c0                	test   %eax,%eax
  80219f:	75 65                	jne    802206 <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8021a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021a5:	75 14                	jne    8021bb <insert_sorted_allocList+0x40>
  8021a7:	83 ec 04             	sub    $0x4,%esp
  8021aa:	68 14 3c 80 00       	push   $0x803c14
  8021af:	6a 6e                	push   $0x6e
  8021b1:	68 37 3c 80 00       	push   $0x803c37
  8021b6:	e8 16 e1 ff ff       	call   8002d1 <_panic>
  8021bb:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8021c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c4:	89 10                	mov    %edx,(%eax)
  8021c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c9:	8b 00                	mov    (%eax),%eax
  8021cb:	85 c0                	test   %eax,%eax
  8021cd:	74 0d                	je     8021dc <insert_sorted_allocList+0x61>
  8021cf:	a1 40 40 80 00       	mov    0x804040,%eax
  8021d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8021d7:	89 50 04             	mov    %edx,0x4(%eax)
  8021da:	eb 08                	jmp    8021e4 <insert_sorted_allocList+0x69>
  8021dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021df:	a3 44 40 80 00       	mov    %eax,0x804044
  8021e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e7:	a3 40 40 80 00       	mov    %eax,0x804040
  8021ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021f6:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021fb:	40                   	inc    %eax
  8021fc:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802201:	e9 cf 01 00 00       	jmp    8023d5 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  802206:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802209:	8b 50 08             	mov    0x8(%eax),%edx
  80220c:	8b 45 08             	mov    0x8(%ebp),%eax
  80220f:	8b 40 08             	mov    0x8(%eax),%eax
  802212:	39 c2                	cmp    %eax,%edx
  802214:	73 65                	jae    80227b <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802216:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80221a:	75 14                	jne    802230 <insert_sorted_allocList+0xb5>
  80221c:	83 ec 04             	sub    $0x4,%esp
  80221f:	68 50 3c 80 00       	push   $0x803c50
  802224:	6a 72                	push   $0x72
  802226:	68 37 3c 80 00       	push   $0x803c37
  80222b:	e8 a1 e0 ff ff       	call   8002d1 <_panic>
  802230:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802236:	8b 45 08             	mov    0x8(%ebp),%eax
  802239:	89 50 04             	mov    %edx,0x4(%eax)
  80223c:	8b 45 08             	mov    0x8(%ebp),%eax
  80223f:	8b 40 04             	mov    0x4(%eax),%eax
  802242:	85 c0                	test   %eax,%eax
  802244:	74 0c                	je     802252 <insert_sorted_allocList+0xd7>
  802246:	a1 44 40 80 00       	mov    0x804044,%eax
  80224b:	8b 55 08             	mov    0x8(%ebp),%edx
  80224e:	89 10                	mov    %edx,(%eax)
  802250:	eb 08                	jmp    80225a <insert_sorted_allocList+0xdf>
  802252:	8b 45 08             	mov    0x8(%ebp),%eax
  802255:	a3 40 40 80 00       	mov    %eax,0x804040
  80225a:	8b 45 08             	mov    0x8(%ebp),%eax
  80225d:	a3 44 40 80 00       	mov    %eax,0x804044
  802262:	8b 45 08             	mov    0x8(%ebp),%eax
  802265:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80226b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802270:	40                   	inc    %eax
  802271:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  802276:	e9 5a 01 00 00       	jmp    8023d5 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  80227b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80227e:	8b 50 08             	mov    0x8(%eax),%edx
  802281:	8b 45 08             	mov    0x8(%ebp),%eax
  802284:	8b 40 08             	mov    0x8(%eax),%eax
  802287:	39 c2                	cmp    %eax,%edx
  802289:	75 70                	jne    8022fb <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  80228b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80228f:	74 06                	je     802297 <insert_sorted_allocList+0x11c>
  802291:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802295:	75 14                	jne    8022ab <insert_sorted_allocList+0x130>
  802297:	83 ec 04             	sub    $0x4,%esp
  80229a:	68 74 3c 80 00       	push   $0x803c74
  80229f:	6a 75                	push   $0x75
  8022a1:	68 37 3c 80 00       	push   $0x803c37
  8022a6:	e8 26 e0 ff ff       	call   8002d1 <_panic>
  8022ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ae:	8b 10                	mov    (%eax),%edx
  8022b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b3:	89 10                	mov    %edx,(%eax)
  8022b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b8:	8b 00                	mov    (%eax),%eax
  8022ba:	85 c0                	test   %eax,%eax
  8022bc:	74 0b                	je     8022c9 <insert_sorted_allocList+0x14e>
  8022be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c1:	8b 00                	mov    (%eax),%eax
  8022c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8022c6:	89 50 04             	mov    %edx,0x4(%eax)
  8022c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8022cf:	89 10                	mov    %edx,(%eax)
  8022d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022d7:	89 50 04             	mov    %edx,0x4(%eax)
  8022da:	8b 45 08             	mov    0x8(%ebp),%eax
  8022dd:	8b 00                	mov    (%eax),%eax
  8022df:	85 c0                	test   %eax,%eax
  8022e1:	75 08                	jne    8022eb <insert_sorted_allocList+0x170>
  8022e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e6:	a3 44 40 80 00       	mov    %eax,0x804044
  8022eb:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022f0:	40                   	inc    %eax
  8022f1:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  8022f6:	e9 da 00 00 00       	jmp    8023d5 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  8022fb:	a1 40 40 80 00       	mov    0x804040,%eax
  802300:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802303:	e9 9d 00 00 00       	jmp    8023a5 <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  802308:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230b:	8b 00                	mov    (%eax),%eax
  80230d:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  802310:	8b 45 08             	mov    0x8(%ebp),%eax
  802313:	8b 50 08             	mov    0x8(%eax),%edx
  802316:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802319:	8b 40 08             	mov    0x8(%eax),%eax
  80231c:	39 c2                	cmp    %eax,%edx
  80231e:	76 7d                	jbe    80239d <insert_sorted_allocList+0x222>
  802320:	8b 45 08             	mov    0x8(%ebp),%eax
  802323:	8b 50 08             	mov    0x8(%eax),%edx
  802326:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802329:	8b 40 08             	mov    0x8(%eax),%eax
  80232c:	39 c2                	cmp    %eax,%edx
  80232e:	73 6d                	jae    80239d <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802330:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802334:	74 06                	je     80233c <insert_sorted_allocList+0x1c1>
  802336:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80233a:	75 14                	jne    802350 <insert_sorted_allocList+0x1d5>
  80233c:	83 ec 04             	sub    $0x4,%esp
  80233f:	68 74 3c 80 00       	push   $0x803c74
  802344:	6a 7c                	push   $0x7c
  802346:	68 37 3c 80 00       	push   $0x803c37
  80234b:	e8 81 df ff ff       	call   8002d1 <_panic>
  802350:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802353:	8b 10                	mov    (%eax),%edx
  802355:	8b 45 08             	mov    0x8(%ebp),%eax
  802358:	89 10                	mov    %edx,(%eax)
  80235a:	8b 45 08             	mov    0x8(%ebp),%eax
  80235d:	8b 00                	mov    (%eax),%eax
  80235f:	85 c0                	test   %eax,%eax
  802361:	74 0b                	je     80236e <insert_sorted_allocList+0x1f3>
  802363:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802366:	8b 00                	mov    (%eax),%eax
  802368:	8b 55 08             	mov    0x8(%ebp),%edx
  80236b:	89 50 04             	mov    %edx,0x4(%eax)
  80236e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802371:	8b 55 08             	mov    0x8(%ebp),%edx
  802374:	89 10                	mov    %edx,(%eax)
  802376:	8b 45 08             	mov    0x8(%ebp),%eax
  802379:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80237c:	89 50 04             	mov    %edx,0x4(%eax)
  80237f:	8b 45 08             	mov    0x8(%ebp),%eax
  802382:	8b 00                	mov    (%eax),%eax
  802384:	85 c0                	test   %eax,%eax
  802386:	75 08                	jne    802390 <insert_sorted_allocList+0x215>
  802388:	8b 45 08             	mov    0x8(%ebp),%eax
  80238b:	a3 44 40 80 00       	mov    %eax,0x804044
  802390:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802395:	40                   	inc    %eax
  802396:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  80239b:	eb 38                	jmp    8023d5 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  80239d:	a1 48 40 80 00       	mov    0x804048,%eax
  8023a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023a9:	74 07                	je     8023b2 <insert_sorted_allocList+0x237>
  8023ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ae:	8b 00                	mov    (%eax),%eax
  8023b0:	eb 05                	jmp    8023b7 <insert_sorted_allocList+0x23c>
  8023b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b7:	a3 48 40 80 00       	mov    %eax,0x804048
  8023bc:	a1 48 40 80 00       	mov    0x804048,%eax
  8023c1:	85 c0                	test   %eax,%eax
  8023c3:	0f 85 3f ff ff ff    	jne    802308 <insert_sorted_allocList+0x18d>
  8023c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023cd:	0f 85 35 ff ff ff    	jne    802308 <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  8023d3:	eb 00                	jmp    8023d5 <insert_sorted_allocList+0x25a>
  8023d5:	90                   	nop
  8023d6:	c9                   	leave  
  8023d7:	c3                   	ret    

008023d8 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8023d8:	55                   	push   %ebp
  8023d9:	89 e5                	mov    %esp,%ebp
  8023db:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  8023de:	a1 38 41 80 00       	mov    0x804138,%eax
  8023e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023e6:	e9 6b 02 00 00       	jmp    802656 <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  8023eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8023f1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023f4:	0f 85 90 00 00 00    	jne    80248a <alloc_block_FF+0xb2>
			  temp=element;
  8023fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fd:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  802400:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802404:	75 17                	jne    80241d <alloc_block_FF+0x45>
  802406:	83 ec 04             	sub    $0x4,%esp
  802409:	68 a8 3c 80 00       	push   $0x803ca8
  80240e:	68 92 00 00 00       	push   $0x92
  802413:	68 37 3c 80 00       	push   $0x803c37
  802418:	e8 b4 de ff ff       	call   8002d1 <_panic>
  80241d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802420:	8b 00                	mov    (%eax),%eax
  802422:	85 c0                	test   %eax,%eax
  802424:	74 10                	je     802436 <alloc_block_FF+0x5e>
  802426:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802429:	8b 00                	mov    (%eax),%eax
  80242b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80242e:	8b 52 04             	mov    0x4(%edx),%edx
  802431:	89 50 04             	mov    %edx,0x4(%eax)
  802434:	eb 0b                	jmp    802441 <alloc_block_FF+0x69>
  802436:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802439:	8b 40 04             	mov    0x4(%eax),%eax
  80243c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802441:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802444:	8b 40 04             	mov    0x4(%eax),%eax
  802447:	85 c0                	test   %eax,%eax
  802449:	74 0f                	je     80245a <alloc_block_FF+0x82>
  80244b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244e:	8b 40 04             	mov    0x4(%eax),%eax
  802451:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802454:	8b 12                	mov    (%edx),%edx
  802456:	89 10                	mov    %edx,(%eax)
  802458:	eb 0a                	jmp    802464 <alloc_block_FF+0x8c>
  80245a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245d:	8b 00                	mov    (%eax),%eax
  80245f:	a3 38 41 80 00       	mov    %eax,0x804138
  802464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802467:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80246d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802470:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802477:	a1 44 41 80 00       	mov    0x804144,%eax
  80247c:	48                   	dec    %eax
  80247d:	a3 44 41 80 00       	mov    %eax,0x804144
			  return temp;
  802482:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802485:	e9 ff 01 00 00       	jmp    802689 <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  80248a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248d:	8b 40 0c             	mov    0xc(%eax),%eax
  802490:	3b 45 08             	cmp    0x8(%ebp),%eax
  802493:	0f 86 b5 01 00 00    	jbe    80264e <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  802499:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249c:	8b 40 0c             	mov    0xc(%eax),%eax
  80249f:	2b 45 08             	sub    0x8(%ebp),%eax
  8024a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  8024a5:	a1 48 41 80 00       	mov    0x804148,%eax
  8024aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  8024ad:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8024b1:	75 17                	jne    8024ca <alloc_block_FF+0xf2>
  8024b3:	83 ec 04             	sub    $0x4,%esp
  8024b6:	68 a8 3c 80 00       	push   $0x803ca8
  8024bb:	68 99 00 00 00       	push   $0x99
  8024c0:	68 37 3c 80 00       	push   $0x803c37
  8024c5:	e8 07 de ff ff       	call   8002d1 <_panic>
  8024ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024cd:	8b 00                	mov    (%eax),%eax
  8024cf:	85 c0                	test   %eax,%eax
  8024d1:	74 10                	je     8024e3 <alloc_block_FF+0x10b>
  8024d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024d6:	8b 00                	mov    (%eax),%eax
  8024d8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024db:	8b 52 04             	mov    0x4(%edx),%edx
  8024de:	89 50 04             	mov    %edx,0x4(%eax)
  8024e1:	eb 0b                	jmp    8024ee <alloc_block_FF+0x116>
  8024e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024e6:	8b 40 04             	mov    0x4(%eax),%eax
  8024e9:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8024ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024f1:	8b 40 04             	mov    0x4(%eax),%eax
  8024f4:	85 c0                	test   %eax,%eax
  8024f6:	74 0f                	je     802507 <alloc_block_FF+0x12f>
  8024f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024fb:	8b 40 04             	mov    0x4(%eax),%eax
  8024fe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802501:	8b 12                	mov    (%edx),%edx
  802503:	89 10                	mov    %edx,(%eax)
  802505:	eb 0a                	jmp    802511 <alloc_block_FF+0x139>
  802507:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80250a:	8b 00                	mov    (%eax),%eax
  80250c:	a3 48 41 80 00       	mov    %eax,0x804148
  802511:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802514:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80251a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80251d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802524:	a1 54 41 80 00       	mov    0x804154,%eax
  802529:	48                   	dec    %eax
  80252a:	a3 54 41 80 00       	mov    %eax,0x804154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  80252f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802533:	75 17                	jne    80254c <alloc_block_FF+0x174>
  802535:	83 ec 04             	sub    $0x4,%esp
  802538:	68 50 3c 80 00       	push   $0x803c50
  80253d:	68 9a 00 00 00       	push   $0x9a
  802542:	68 37 3c 80 00       	push   $0x803c37
  802547:	e8 85 dd ff ff       	call   8002d1 <_panic>
  80254c:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802552:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802555:	89 50 04             	mov    %edx,0x4(%eax)
  802558:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80255b:	8b 40 04             	mov    0x4(%eax),%eax
  80255e:	85 c0                	test   %eax,%eax
  802560:	74 0c                	je     80256e <alloc_block_FF+0x196>
  802562:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802567:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80256a:	89 10                	mov    %edx,(%eax)
  80256c:	eb 08                	jmp    802576 <alloc_block_FF+0x19e>
  80256e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802571:	a3 38 41 80 00       	mov    %eax,0x804138
  802576:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802579:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80257e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802581:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802587:	a1 44 41 80 00       	mov    0x804144,%eax
  80258c:	40                   	inc    %eax
  80258d:	a3 44 41 80 00       	mov    %eax,0x804144
		  // setting the size & sva
		  new_block->size=size;
  802592:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802595:	8b 55 08             	mov    0x8(%ebp),%edx
  802598:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  80259b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259e:	8b 50 08             	mov    0x8(%eax),%edx
  8025a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025a4:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  8025a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025ad:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  8025b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b3:	8b 50 08             	mov    0x8(%eax),%edx
  8025b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b9:	01 c2                	add    %eax,%edx
  8025bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025be:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  8025c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025c4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  8025c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025cb:	75 17                	jne    8025e4 <alloc_block_FF+0x20c>
  8025cd:	83 ec 04             	sub    $0x4,%esp
  8025d0:	68 a8 3c 80 00       	push   $0x803ca8
  8025d5:	68 a2 00 00 00       	push   $0xa2
  8025da:	68 37 3c 80 00       	push   $0x803c37
  8025df:	e8 ed dc ff ff       	call   8002d1 <_panic>
  8025e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e7:	8b 00                	mov    (%eax),%eax
  8025e9:	85 c0                	test   %eax,%eax
  8025eb:	74 10                	je     8025fd <alloc_block_FF+0x225>
  8025ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f0:	8b 00                	mov    (%eax),%eax
  8025f2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025f5:	8b 52 04             	mov    0x4(%edx),%edx
  8025f8:	89 50 04             	mov    %edx,0x4(%eax)
  8025fb:	eb 0b                	jmp    802608 <alloc_block_FF+0x230>
  8025fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802600:	8b 40 04             	mov    0x4(%eax),%eax
  802603:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802608:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80260b:	8b 40 04             	mov    0x4(%eax),%eax
  80260e:	85 c0                	test   %eax,%eax
  802610:	74 0f                	je     802621 <alloc_block_FF+0x249>
  802612:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802615:	8b 40 04             	mov    0x4(%eax),%eax
  802618:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80261b:	8b 12                	mov    (%edx),%edx
  80261d:	89 10                	mov    %edx,(%eax)
  80261f:	eb 0a                	jmp    80262b <alloc_block_FF+0x253>
  802621:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802624:	8b 00                	mov    (%eax),%eax
  802626:	a3 38 41 80 00       	mov    %eax,0x804138
  80262b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80262e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802634:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802637:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80263e:	a1 44 41 80 00       	mov    0x804144,%eax
  802643:	48                   	dec    %eax
  802644:	a3 44 41 80 00       	mov    %eax,0x804144
		  return temp;
  802649:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80264c:	eb 3b                	jmp    802689 <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  80264e:	a1 40 41 80 00       	mov    0x804140,%eax
  802653:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802656:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80265a:	74 07                	je     802663 <alloc_block_FF+0x28b>
  80265c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265f:	8b 00                	mov    (%eax),%eax
  802661:	eb 05                	jmp    802668 <alloc_block_FF+0x290>
  802663:	b8 00 00 00 00       	mov    $0x0,%eax
  802668:	a3 40 41 80 00       	mov    %eax,0x804140
  80266d:	a1 40 41 80 00       	mov    0x804140,%eax
  802672:	85 c0                	test   %eax,%eax
  802674:	0f 85 71 fd ff ff    	jne    8023eb <alloc_block_FF+0x13>
  80267a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80267e:	0f 85 67 fd ff ff    	jne    8023eb <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  802684:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802689:	c9                   	leave  
  80268a:	c3                   	ret    

0080268b <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80268b:	55                   	push   %ebp
  80268c:	89 e5                	mov    %esp,%ebp
  80268e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  802691:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  802698:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  80269f:	a1 38 41 80 00       	mov    0x804138,%eax
  8026a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8026a7:	e9 d3 00 00 00       	jmp    80277f <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  8026ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026af:	8b 40 0c             	mov    0xc(%eax),%eax
  8026b2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026b5:	0f 85 90 00 00 00    	jne    80274b <alloc_block_BF+0xc0>
	   temp = element;
  8026bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026be:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  8026c1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026c5:	75 17                	jne    8026de <alloc_block_BF+0x53>
  8026c7:	83 ec 04             	sub    $0x4,%esp
  8026ca:	68 a8 3c 80 00       	push   $0x803ca8
  8026cf:	68 bd 00 00 00       	push   $0xbd
  8026d4:	68 37 3c 80 00       	push   $0x803c37
  8026d9:	e8 f3 db ff ff       	call   8002d1 <_panic>
  8026de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026e1:	8b 00                	mov    (%eax),%eax
  8026e3:	85 c0                	test   %eax,%eax
  8026e5:	74 10                	je     8026f7 <alloc_block_BF+0x6c>
  8026e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026ea:	8b 00                	mov    (%eax),%eax
  8026ec:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026ef:	8b 52 04             	mov    0x4(%edx),%edx
  8026f2:	89 50 04             	mov    %edx,0x4(%eax)
  8026f5:	eb 0b                	jmp    802702 <alloc_block_BF+0x77>
  8026f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026fa:	8b 40 04             	mov    0x4(%eax),%eax
  8026fd:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802702:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802705:	8b 40 04             	mov    0x4(%eax),%eax
  802708:	85 c0                	test   %eax,%eax
  80270a:	74 0f                	je     80271b <alloc_block_BF+0x90>
  80270c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80270f:	8b 40 04             	mov    0x4(%eax),%eax
  802712:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802715:	8b 12                	mov    (%edx),%edx
  802717:	89 10                	mov    %edx,(%eax)
  802719:	eb 0a                	jmp    802725 <alloc_block_BF+0x9a>
  80271b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80271e:	8b 00                	mov    (%eax),%eax
  802720:	a3 38 41 80 00       	mov    %eax,0x804138
  802725:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802728:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80272e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802731:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802738:	a1 44 41 80 00       	mov    0x804144,%eax
  80273d:	48                   	dec    %eax
  80273e:	a3 44 41 80 00       	mov    %eax,0x804144
	   return temp;
  802743:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802746:	e9 41 01 00 00       	jmp    80288c <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  80274b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80274e:	8b 40 0c             	mov    0xc(%eax),%eax
  802751:	3b 45 08             	cmp    0x8(%ebp),%eax
  802754:	76 21                	jbe    802777 <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  802756:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802759:	8b 40 0c             	mov    0xc(%eax),%eax
  80275c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80275f:	73 16                	jae    802777 <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  802761:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802764:	8b 40 0c             	mov    0xc(%eax),%eax
  802767:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  80276a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80276d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  802770:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802777:	a1 40 41 80 00       	mov    0x804140,%eax
  80277c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80277f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802783:	74 07                	je     80278c <alloc_block_BF+0x101>
  802785:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802788:	8b 00                	mov    (%eax),%eax
  80278a:	eb 05                	jmp    802791 <alloc_block_BF+0x106>
  80278c:	b8 00 00 00 00       	mov    $0x0,%eax
  802791:	a3 40 41 80 00       	mov    %eax,0x804140
  802796:	a1 40 41 80 00       	mov    0x804140,%eax
  80279b:	85 c0                	test   %eax,%eax
  80279d:	0f 85 09 ff ff ff    	jne    8026ac <alloc_block_BF+0x21>
  8027a3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8027a7:	0f 85 ff fe ff ff    	jne    8026ac <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  8027ad:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  8027b1:	0f 85 d0 00 00 00    	jne    802887 <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  8027b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8027bd:	2b 45 08             	sub    0x8(%ebp),%eax
  8027c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  8027c3:	a1 48 41 80 00       	mov    0x804148,%eax
  8027c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  8027cb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8027cf:	75 17                	jne    8027e8 <alloc_block_BF+0x15d>
  8027d1:	83 ec 04             	sub    $0x4,%esp
  8027d4:	68 a8 3c 80 00       	push   $0x803ca8
  8027d9:	68 d1 00 00 00       	push   $0xd1
  8027de:	68 37 3c 80 00       	push   $0x803c37
  8027e3:	e8 e9 da ff ff       	call   8002d1 <_panic>
  8027e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027eb:	8b 00                	mov    (%eax),%eax
  8027ed:	85 c0                	test   %eax,%eax
  8027ef:	74 10                	je     802801 <alloc_block_BF+0x176>
  8027f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027f4:	8b 00                	mov    (%eax),%eax
  8027f6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027f9:	8b 52 04             	mov    0x4(%edx),%edx
  8027fc:	89 50 04             	mov    %edx,0x4(%eax)
  8027ff:	eb 0b                	jmp    80280c <alloc_block_BF+0x181>
  802801:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802804:	8b 40 04             	mov    0x4(%eax),%eax
  802807:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80280c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80280f:	8b 40 04             	mov    0x4(%eax),%eax
  802812:	85 c0                	test   %eax,%eax
  802814:	74 0f                	je     802825 <alloc_block_BF+0x19a>
  802816:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802819:	8b 40 04             	mov    0x4(%eax),%eax
  80281c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80281f:	8b 12                	mov    (%edx),%edx
  802821:	89 10                	mov    %edx,(%eax)
  802823:	eb 0a                	jmp    80282f <alloc_block_BF+0x1a4>
  802825:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802828:	8b 00                	mov    (%eax),%eax
  80282a:	a3 48 41 80 00       	mov    %eax,0x804148
  80282f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802832:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802838:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80283b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802842:	a1 54 41 80 00       	mov    0x804154,%eax
  802847:	48                   	dec    %eax
  802848:	a3 54 41 80 00       	mov    %eax,0x804154
	  // setting the size & sva
	  new_block->size = size;
  80284d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802850:	8b 55 08             	mov    0x8(%ebp),%edx
  802853:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  802856:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802859:	8b 50 08             	mov    0x8(%eax),%edx
  80285c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80285f:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  802862:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802865:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802868:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  80286b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80286e:	8b 50 08             	mov    0x8(%eax),%edx
  802871:	8b 45 08             	mov    0x8(%ebp),%eax
  802874:	01 c2                	add    %eax,%edx
  802876:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802879:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  80287c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80287f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  802882:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802885:	eb 05                	jmp    80288c <alloc_block_BF+0x201>
	 }
	 return NULL;
  802887:	b8 00 00 00 00       	mov    $0x0,%eax


}
  80288c:	c9                   	leave  
  80288d:	c3                   	ret    

0080288e <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80288e:	55                   	push   %ebp
  80288f:	89 e5                	mov    %esp,%ebp
  802891:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802894:	83 ec 04             	sub    $0x4,%esp
  802897:	68 c8 3c 80 00       	push   $0x803cc8
  80289c:	68 e8 00 00 00       	push   $0xe8
  8028a1:	68 37 3c 80 00       	push   $0x803c37
  8028a6:	e8 26 da ff ff       	call   8002d1 <_panic>

008028ab <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8028ab:	55                   	push   %ebp
  8028ac:	89 e5                	mov    %esp,%ebp
  8028ae:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  8028b1:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8028b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  8028b9:	a1 38 41 80 00       	mov    0x804138,%eax
  8028be:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  8028c1:	a1 44 41 80 00       	mov    0x804144,%eax
  8028c6:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  8028c9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028cd:	75 68                	jne    802937 <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8028cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028d3:	75 17                	jne    8028ec <insert_sorted_with_merge_freeList+0x41>
  8028d5:	83 ec 04             	sub    $0x4,%esp
  8028d8:	68 14 3c 80 00       	push   $0x803c14
  8028dd:	68 36 01 00 00       	push   $0x136
  8028e2:	68 37 3c 80 00       	push   $0x803c37
  8028e7:	e8 e5 d9 ff ff       	call   8002d1 <_panic>
  8028ec:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8028f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f5:	89 10                	mov    %edx,(%eax)
  8028f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fa:	8b 00                	mov    (%eax),%eax
  8028fc:	85 c0                	test   %eax,%eax
  8028fe:	74 0d                	je     80290d <insert_sorted_with_merge_freeList+0x62>
  802900:	a1 38 41 80 00       	mov    0x804138,%eax
  802905:	8b 55 08             	mov    0x8(%ebp),%edx
  802908:	89 50 04             	mov    %edx,0x4(%eax)
  80290b:	eb 08                	jmp    802915 <insert_sorted_with_merge_freeList+0x6a>
  80290d:	8b 45 08             	mov    0x8(%ebp),%eax
  802910:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802915:	8b 45 08             	mov    0x8(%ebp),%eax
  802918:	a3 38 41 80 00       	mov    %eax,0x804138
  80291d:	8b 45 08             	mov    0x8(%ebp),%eax
  802920:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802927:	a1 44 41 80 00       	mov    0x804144,%eax
  80292c:	40                   	inc    %eax
  80292d:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802932:	e9 ba 06 00 00       	jmp    802ff1 <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  802937:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293a:	8b 50 08             	mov    0x8(%eax),%edx
  80293d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802940:	8b 40 0c             	mov    0xc(%eax),%eax
  802943:	01 c2                	add    %eax,%edx
  802945:	8b 45 08             	mov    0x8(%ebp),%eax
  802948:	8b 40 08             	mov    0x8(%eax),%eax
  80294b:	39 c2                	cmp    %eax,%edx
  80294d:	73 68                	jae    8029b7 <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80294f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802953:	75 17                	jne    80296c <insert_sorted_with_merge_freeList+0xc1>
  802955:	83 ec 04             	sub    $0x4,%esp
  802958:	68 50 3c 80 00       	push   $0x803c50
  80295d:	68 3a 01 00 00       	push   $0x13a
  802962:	68 37 3c 80 00       	push   $0x803c37
  802967:	e8 65 d9 ff ff       	call   8002d1 <_panic>
  80296c:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802972:	8b 45 08             	mov    0x8(%ebp),%eax
  802975:	89 50 04             	mov    %edx,0x4(%eax)
  802978:	8b 45 08             	mov    0x8(%ebp),%eax
  80297b:	8b 40 04             	mov    0x4(%eax),%eax
  80297e:	85 c0                	test   %eax,%eax
  802980:	74 0c                	je     80298e <insert_sorted_with_merge_freeList+0xe3>
  802982:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802987:	8b 55 08             	mov    0x8(%ebp),%edx
  80298a:	89 10                	mov    %edx,(%eax)
  80298c:	eb 08                	jmp    802996 <insert_sorted_with_merge_freeList+0xeb>
  80298e:	8b 45 08             	mov    0x8(%ebp),%eax
  802991:	a3 38 41 80 00       	mov    %eax,0x804138
  802996:	8b 45 08             	mov    0x8(%ebp),%eax
  802999:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80299e:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029a7:	a1 44 41 80 00       	mov    0x804144,%eax
  8029ac:	40                   	inc    %eax
  8029ad:	a3 44 41 80 00       	mov    %eax,0x804144





}
  8029b2:	e9 3a 06 00 00       	jmp    802ff1 <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  8029b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ba:	8b 50 08             	mov    0x8(%eax),%edx
  8029bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8029c3:	01 c2                	add    %eax,%edx
  8029c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c8:	8b 40 08             	mov    0x8(%eax),%eax
  8029cb:	39 c2                	cmp    %eax,%edx
  8029cd:	0f 85 90 00 00 00    	jne    802a63 <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  8029d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d6:	8b 50 0c             	mov    0xc(%eax),%edx
  8029d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8029df:	01 c2                	add    %eax,%edx
  8029e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e4:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  8029e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ea:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  8029f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8029fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029ff:	75 17                	jne    802a18 <insert_sorted_with_merge_freeList+0x16d>
  802a01:	83 ec 04             	sub    $0x4,%esp
  802a04:	68 14 3c 80 00       	push   $0x803c14
  802a09:	68 41 01 00 00       	push   $0x141
  802a0e:	68 37 3c 80 00       	push   $0x803c37
  802a13:	e8 b9 d8 ff ff       	call   8002d1 <_panic>
  802a18:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a21:	89 10                	mov    %edx,(%eax)
  802a23:	8b 45 08             	mov    0x8(%ebp),%eax
  802a26:	8b 00                	mov    (%eax),%eax
  802a28:	85 c0                	test   %eax,%eax
  802a2a:	74 0d                	je     802a39 <insert_sorted_with_merge_freeList+0x18e>
  802a2c:	a1 48 41 80 00       	mov    0x804148,%eax
  802a31:	8b 55 08             	mov    0x8(%ebp),%edx
  802a34:	89 50 04             	mov    %edx,0x4(%eax)
  802a37:	eb 08                	jmp    802a41 <insert_sorted_with_merge_freeList+0x196>
  802a39:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a41:	8b 45 08             	mov    0x8(%ebp),%eax
  802a44:	a3 48 41 80 00       	mov    %eax,0x804148
  802a49:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a53:	a1 54 41 80 00       	mov    0x804154,%eax
  802a58:	40                   	inc    %eax
  802a59:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802a5e:	e9 8e 05 00 00       	jmp    802ff1 <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  802a63:	8b 45 08             	mov    0x8(%ebp),%eax
  802a66:	8b 50 08             	mov    0x8(%eax),%edx
  802a69:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a6f:	01 c2                	add    %eax,%edx
  802a71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a74:	8b 40 08             	mov    0x8(%eax),%eax
  802a77:	39 c2                	cmp    %eax,%edx
  802a79:	73 68                	jae    802ae3 <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802a7b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a7f:	75 17                	jne    802a98 <insert_sorted_with_merge_freeList+0x1ed>
  802a81:	83 ec 04             	sub    $0x4,%esp
  802a84:	68 14 3c 80 00       	push   $0x803c14
  802a89:	68 45 01 00 00       	push   $0x145
  802a8e:	68 37 3c 80 00       	push   $0x803c37
  802a93:	e8 39 d8 ff ff       	call   8002d1 <_panic>
  802a98:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa1:	89 10                	mov    %edx,(%eax)
  802aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa6:	8b 00                	mov    (%eax),%eax
  802aa8:	85 c0                	test   %eax,%eax
  802aaa:	74 0d                	je     802ab9 <insert_sorted_with_merge_freeList+0x20e>
  802aac:	a1 38 41 80 00       	mov    0x804138,%eax
  802ab1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ab4:	89 50 04             	mov    %edx,0x4(%eax)
  802ab7:	eb 08                	jmp    802ac1 <insert_sorted_with_merge_freeList+0x216>
  802ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  802abc:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac4:	a3 38 41 80 00       	mov    %eax,0x804138
  802ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  802acc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ad3:	a1 44 41 80 00       	mov    0x804144,%eax
  802ad8:	40                   	inc    %eax
  802ad9:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802ade:	e9 0e 05 00 00       	jmp    802ff1 <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  802ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae6:	8b 50 08             	mov    0x8(%eax),%edx
  802ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  802aec:	8b 40 0c             	mov    0xc(%eax),%eax
  802aef:	01 c2                	add    %eax,%edx
  802af1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af4:	8b 40 08             	mov    0x8(%eax),%eax
  802af7:	39 c2                	cmp    %eax,%edx
  802af9:	0f 85 9c 00 00 00    	jne    802b9b <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  802aff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b02:	8b 50 0c             	mov    0xc(%eax),%edx
  802b05:	8b 45 08             	mov    0x8(%ebp),%eax
  802b08:	8b 40 0c             	mov    0xc(%eax),%eax
  802b0b:	01 c2                	add    %eax,%edx
  802b0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b10:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  802b13:	8b 45 08             	mov    0x8(%ebp),%eax
  802b16:	8b 50 08             	mov    0x8(%eax),%edx
  802b19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b1c:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  802b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b22:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  802b29:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802b33:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b37:	75 17                	jne    802b50 <insert_sorted_with_merge_freeList+0x2a5>
  802b39:	83 ec 04             	sub    $0x4,%esp
  802b3c:	68 14 3c 80 00       	push   $0x803c14
  802b41:	68 4d 01 00 00       	push   $0x14d
  802b46:	68 37 3c 80 00       	push   $0x803c37
  802b4b:	e8 81 d7 ff ff       	call   8002d1 <_panic>
  802b50:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b56:	8b 45 08             	mov    0x8(%ebp),%eax
  802b59:	89 10                	mov    %edx,(%eax)
  802b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5e:	8b 00                	mov    (%eax),%eax
  802b60:	85 c0                	test   %eax,%eax
  802b62:	74 0d                	je     802b71 <insert_sorted_with_merge_freeList+0x2c6>
  802b64:	a1 48 41 80 00       	mov    0x804148,%eax
  802b69:	8b 55 08             	mov    0x8(%ebp),%edx
  802b6c:	89 50 04             	mov    %edx,0x4(%eax)
  802b6f:	eb 08                	jmp    802b79 <insert_sorted_with_merge_freeList+0x2ce>
  802b71:	8b 45 08             	mov    0x8(%ebp),%eax
  802b74:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b79:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7c:	a3 48 41 80 00       	mov    %eax,0x804148
  802b81:	8b 45 08             	mov    0x8(%ebp),%eax
  802b84:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b8b:	a1 54 41 80 00       	mov    0x804154,%eax
  802b90:	40                   	inc    %eax
  802b91:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802b96:	e9 56 04 00 00       	jmp    802ff1 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802b9b:	a1 38 41 80 00       	mov    0x804138,%eax
  802ba0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ba3:	e9 19 04 00 00       	jmp    802fc1 <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  802ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bab:	8b 00                	mov    (%eax),%eax
  802bad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb3:	8b 50 08             	mov    0x8(%eax),%edx
  802bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb9:	8b 40 0c             	mov    0xc(%eax),%eax
  802bbc:	01 c2                	add    %eax,%edx
  802bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc1:	8b 40 08             	mov    0x8(%eax),%eax
  802bc4:	39 c2                	cmp    %eax,%edx
  802bc6:	0f 85 ad 01 00 00    	jne    802d79 <insert_sorted_with_merge_freeList+0x4ce>
  802bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcf:	8b 50 08             	mov    0x8(%eax),%edx
  802bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd5:	8b 40 0c             	mov    0xc(%eax),%eax
  802bd8:	01 c2                	add    %eax,%edx
  802bda:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bdd:	8b 40 08             	mov    0x8(%eax),%eax
  802be0:	39 c2                	cmp    %eax,%edx
  802be2:	0f 85 91 01 00 00    	jne    802d79 <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  802be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802beb:	8b 50 0c             	mov    0xc(%eax),%edx
  802bee:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf1:	8b 48 0c             	mov    0xc(%eax),%ecx
  802bf4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bf7:	8b 40 0c             	mov    0xc(%eax),%eax
  802bfa:	01 c8                	add    %ecx,%eax
  802bfc:	01 c2                	add    %eax,%edx
  802bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c01:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  802c04:	8b 45 08             	mov    0x8(%ebp),%eax
  802c07:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c11:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  802c18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c1b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  802c22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c25:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  802c2c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802c30:	75 17                	jne    802c49 <insert_sorted_with_merge_freeList+0x39e>
  802c32:	83 ec 04             	sub    $0x4,%esp
  802c35:	68 a8 3c 80 00       	push   $0x803ca8
  802c3a:	68 5b 01 00 00       	push   $0x15b
  802c3f:	68 37 3c 80 00       	push   $0x803c37
  802c44:	e8 88 d6 ff ff       	call   8002d1 <_panic>
  802c49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c4c:	8b 00                	mov    (%eax),%eax
  802c4e:	85 c0                	test   %eax,%eax
  802c50:	74 10                	je     802c62 <insert_sorted_with_merge_freeList+0x3b7>
  802c52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c55:	8b 00                	mov    (%eax),%eax
  802c57:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c5a:	8b 52 04             	mov    0x4(%edx),%edx
  802c5d:	89 50 04             	mov    %edx,0x4(%eax)
  802c60:	eb 0b                	jmp    802c6d <insert_sorted_with_merge_freeList+0x3c2>
  802c62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c65:	8b 40 04             	mov    0x4(%eax),%eax
  802c68:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c70:	8b 40 04             	mov    0x4(%eax),%eax
  802c73:	85 c0                	test   %eax,%eax
  802c75:	74 0f                	je     802c86 <insert_sorted_with_merge_freeList+0x3db>
  802c77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c7a:	8b 40 04             	mov    0x4(%eax),%eax
  802c7d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c80:	8b 12                	mov    (%edx),%edx
  802c82:	89 10                	mov    %edx,(%eax)
  802c84:	eb 0a                	jmp    802c90 <insert_sorted_with_merge_freeList+0x3e5>
  802c86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c89:	8b 00                	mov    (%eax),%eax
  802c8b:	a3 38 41 80 00       	mov    %eax,0x804138
  802c90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c93:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c9c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ca3:	a1 44 41 80 00       	mov    0x804144,%eax
  802ca8:	48                   	dec    %eax
  802ca9:	a3 44 41 80 00       	mov    %eax,0x804144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802cae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cb2:	75 17                	jne    802ccb <insert_sorted_with_merge_freeList+0x420>
  802cb4:	83 ec 04             	sub    $0x4,%esp
  802cb7:	68 14 3c 80 00       	push   $0x803c14
  802cbc:	68 5c 01 00 00       	push   $0x15c
  802cc1:	68 37 3c 80 00       	push   $0x803c37
  802cc6:	e8 06 d6 ff ff       	call   8002d1 <_panic>
  802ccb:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd4:	89 10                	mov    %edx,(%eax)
  802cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd9:	8b 00                	mov    (%eax),%eax
  802cdb:	85 c0                	test   %eax,%eax
  802cdd:	74 0d                	je     802cec <insert_sorted_with_merge_freeList+0x441>
  802cdf:	a1 48 41 80 00       	mov    0x804148,%eax
  802ce4:	8b 55 08             	mov    0x8(%ebp),%edx
  802ce7:	89 50 04             	mov    %edx,0x4(%eax)
  802cea:	eb 08                	jmp    802cf4 <insert_sorted_with_merge_freeList+0x449>
  802cec:	8b 45 08             	mov    0x8(%ebp),%eax
  802cef:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf7:	a3 48 41 80 00       	mov    %eax,0x804148
  802cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d06:	a1 54 41 80 00       	mov    0x804154,%eax
  802d0b:	40                   	inc    %eax
  802d0c:	a3 54 41 80 00       	mov    %eax,0x804154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  802d11:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802d15:	75 17                	jne    802d2e <insert_sorted_with_merge_freeList+0x483>
  802d17:	83 ec 04             	sub    $0x4,%esp
  802d1a:	68 14 3c 80 00       	push   $0x803c14
  802d1f:	68 5d 01 00 00       	push   $0x15d
  802d24:	68 37 3c 80 00       	push   $0x803c37
  802d29:	e8 a3 d5 ff ff       	call   8002d1 <_panic>
  802d2e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d34:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d37:	89 10                	mov    %edx,(%eax)
  802d39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d3c:	8b 00                	mov    (%eax),%eax
  802d3e:	85 c0                	test   %eax,%eax
  802d40:	74 0d                	je     802d4f <insert_sorted_with_merge_freeList+0x4a4>
  802d42:	a1 48 41 80 00       	mov    0x804148,%eax
  802d47:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d4a:	89 50 04             	mov    %edx,0x4(%eax)
  802d4d:	eb 08                	jmp    802d57 <insert_sorted_with_merge_freeList+0x4ac>
  802d4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d52:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d5a:	a3 48 41 80 00       	mov    %eax,0x804148
  802d5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d62:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d69:	a1 54 41 80 00       	mov    0x804154,%eax
  802d6e:	40                   	inc    %eax
  802d6f:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802d74:	e9 78 02 00 00       	jmp    802ff1 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802d79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7c:	8b 50 08             	mov    0x8(%eax),%edx
  802d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d82:	8b 40 0c             	mov    0xc(%eax),%eax
  802d85:	01 c2                	add    %eax,%edx
  802d87:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8a:	8b 40 08             	mov    0x8(%eax),%eax
  802d8d:	39 c2                	cmp    %eax,%edx
  802d8f:	0f 83 b8 00 00 00    	jae    802e4d <insert_sorted_with_merge_freeList+0x5a2>
  802d95:	8b 45 08             	mov    0x8(%ebp),%eax
  802d98:	8b 50 08             	mov    0x8(%eax),%edx
  802d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9e:	8b 40 0c             	mov    0xc(%eax),%eax
  802da1:	01 c2                	add    %eax,%edx
  802da3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802da6:	8b 40 08             	mov    0x8(%eax),%eax
  802da9:	39 c2                	cmp    %eax,%edx
  802dab:	0f 85 9c 00 00 00    	jne    802e4d <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  802db1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802db4:	8b 50 0c             	mov    0xc(%eax),%edx
  802db7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dba:	8b 40 0c             	mov    0xc(%eax),%eax
  802dbd:	01 c2                	add    %eax,%edx
  802dbf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dc2:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  802dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc8:	8b 50 08             	mov    0x8(%eax),%edx
  802dcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dce:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  802dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dde:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802de5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802de9:	75 17                	jne    802e02 <insert_sorted_with_merge_freeList+0x557>
  802deb:	83 ec 04             	sub    $0x4,%esp
  802dee:	68 14 3c 80 00       	push   $0x803c14
  802df3:	68 67 01 00 00       	push   $0x167
  802df8:	68 37 3c 80 00       	push   $0x803c37
  802dfd:	e8 cf d4 ff ff       	call   8002d1 <_panic>
  802e02:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e08:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0b:	89 10                	mov    %edx,(%eax)
  802e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e10:	8b 00                	mov    (%eax),%eax
  802e12:	85 c0                	test   %eax,%eax
  802e14:	74 0d                	je     802e23 <insert_sorted_with_merge_freeList+0x578>
  802e16:	a1 48 41 80 00       	mov    0x804148,%eax
  802e1b:	8b 55 08             	mov    0x8(%ebp),%edx
  802e1e:	89 50 04             	mov    %edx,0x4(%eax)
  802e21:	eb 08                	jmp    802e2b <insert_sorted_with_merge_freeList+0x580>
  802e23:	8b 45 08             	mov    0x8(%ebp),%eax
  802e26:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2e:	a3 48 41 80 00       	mov    %eax,0x804148
  802e33:	8b 45 08             	mov    0x8(%ebp),%eax
  802e36:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e3d:	a1 54 41 80 00       	mov    0x804154,%eax
  802e42:	40                   	inc    %eax
  802e43:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802e48:	e9 a4 01 00 00       	jmp    802ff1 <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e50:	8b 50 08             	mov    0x8(%eax),%edx
  802e53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e56:	8b 40 0c             	mov    0xc(%eax),%eax
  802e59:	01 c2                	add    %eax,%edx
  802e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5e:	8b 40 08             	mov    0x8(%eax),%eax
  802e61:	39 c2                	cmp    %eax,%edx
  802e63:	0f 85 ac 00 00 00    	jne    802f15 <insert_sorted_with_merge_freeList+0x66a>
  802e69:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6c:	8b 50 08             	mov    0x8(%eax),%edx
  802e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e72:	8b 40 0c             	mov    0xc(%eax),%eax
  802e75:	01 c2                	add    %eax,%edx
  802e77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e7a:	8b 40 08             	mov    0x8(%eax),%eax
  802e7d:	39 c2                	cmp    %eax,%edx
  802e7f:	0f 83 90 00 00 00    	jae    802f15 <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  802e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e88:	8b 50 0c             	mov    0xc(%eax),%edx
  802e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8e:	8b 40 0c             	mov    0xc(%eax),%eax
  802e91:	01 c2                	add    %eax,%edx
  802e93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e96:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  802e99:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  802ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802ead:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eb1:	75 17                	jne    802eca <insert_sorted_with_merge_freeList+0x61f>
  802eb3:	83 ec 04             	sub    $0x4,%esp
  802eb6:	68 14 3c 80 00       	push   $0x803c14
  802ebb:	68 70 01 00 00       	push   $0x170
  802ec0:	68 37 3c 80 00       	push   $0x803c37
  802ec5:	e8 07 d4 ff ff       	call   8002d1 <_panic>
  802eca:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed3:	89 10                	mov    %edx,(%eax)
  802ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed8:	8b 00                	mov    (%eax),%eax
  802eda:	85 c0                	test   %eax,%eax
  802edc:	74 0d                	je     802eeb <insert_sorted_with_merge_freeList+0x640>
  802ede:	a1 48 41 80 00       	mov    0x804148,%eax
  802ee3:	8b 55 08             	mov    0x8(%ebp),%edx
  802ee6:	89 50 04             	mov    %edx,0x4(%eax)
  802ee9:	eb 08                	jmp    802ef3 <insert_sorted_with_merge_freeList+0x648>
  802eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  802eee:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef6:	a3 48 41 80 00       	mov    %eax,0x804148
  802efb:	8b 45 08             	mov    0x8(%ebp),%eax
  802efe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f05:	a1 54 41 80 00       	mov    0x804154,%eax
  802f0a:	40                   	inc    %eax
  802f0b:	a3 54 41 80 00       	mov    %eax,0x804154
	      break;
  802f10:	e9 dc 00 00 00       	jmp    802ff1 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f18:	8b 50 08             	mov    0x8(%eax),%edx
  802f1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1e:	8b 40 0c             	mov    0xc(%eax),%eax
  802f21:	01 c2                	add    %eax,%edx
  802f23:	8b 45 08             	mov    0x8(%ebp),%eax
  802f26:	8b 40 08             	mov    0x8(%eax),%eax
  802f29:	39 c2                	cmp    %eax,%edx
  802f2b:	0f 83 88 00 00 00    	jae    802fb9 <insert_sorted_with_merge_freeList+0x70e>
  802f31:	8b 45 08             	mov    0x8(%ebp),%eax
  802f34:	8b 50 08             	mov    0x8(%eax),%edx
  802f37:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3a:	8b 40 0c             	mov    0xc(%eax),%eax
  802f3d:	01 c2                	add    %eax,%edx
  802f3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f42:	8b 40 08             	mov    0x8(%eax),%eax
  802f45:	39 c2                	cmp    %eax,%edx
  802f47:	73 70                	jae    802fb9 <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  802f49:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f4d:	74 06                	je     802f55 <insert_sorted_with_merge_freeList+0x6aa>
  802f4f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f53:	75 17                	jne    802f6c <insert_sorted_with_merge_freeList+0x6c1>
  802f55:	83 ec 04             	sub    $0x4,%esp
  802f58:	68 74 3c 80 00       	push   $0x803c74
  802f5d:	68 75 01 00 00       	push   $0x175
  802f62:	68 37 3c 80 00       	push   $0x803c37
  802f67:	e8 65 d3 ff ff       	call   8002d1 <_panic>
  802f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6f:	8b 10                	mov    (%eax),%edx
  802f71:	8b 45 08             	mov    0x8(%ebp),%eax
  802f74:	89 10                	mov    %edx,(%eax)
  802f76:	8b 45 08             	mov    0x8(%ebp),%eax
  802f79:	8b 00                	mov    (%eax),%eax
  802f7b:	85 c0                	test   %eax,%eax
  802f7d:	74 0b                	je     802f8a <insert_sorted_with_merge_freeList+0x6df>
  802f7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f82:	8b 00                	mov    (%eax),%eax
  802f84:	8b 55 08             	mov    0x8(%ebp),%edx
  802f87:	89 50 04             	mov    %edx,0x4(%eax)
  802f8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8d:	8b 55 08             	mov    0x8(%ebp),%edx
  802f90:	89 10                	mov    %edx,(%eax)
  802f92:	8b 45 08             	mov    0x8(%ebp),%eax
  802f95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f98:	89 50 04             	mov    %edx,0x4(%eax)
  802f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9e:	8b 00                	mov    (%eax),%eax
  802fa0:	85 c0                	test   %eax,%eax
  802fa2:	75 08                	jne    802fac <insert_sorted_with_merge_freeList+0x701>
  802fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802fac:	a1 44 41 80 00       	mov    0x804144,%eax
  802fb1:	40                   	inc    %eax
  802fb2:	a3 44 41 80 00       	mov    %eax,0x804144
	      break;
  802fb7:	eb 38                	jmp    802ff1 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802fb9:	a1 40 41 80 00       	mov    0x804140,%eax
  802fbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fc1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fc5:	74 07                	je     802fce <insert_sorted_with_merge_freeList+0x723>
  802fc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fca:	8b 00                	mov    (%eax),%eax
  802fcc:	eb 05                	jmp    802fd3 <insert_sorted_with_merge_freeList+0x728>
  802fce:	b8 00 00 00 00       	mov    $0x0,%eax
  802fd3:	a3 40 41 80 00       	mov    %eax,0x804140
  802fd8:	a1 40 41 80 00       	mov    0x804140,%eax
  802fdd:	85 c0                	test   %eax,%eax
  802fdf:	0f 85 c3 fb ff ff    	jne    802ba8 <insert_sorted_with_merge_freeList+0x2fd>
  802fe5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fe9:	0f 85 b9 fb ff ff    	jne    802ba8 <insert_sorted_with_merge_freeList+0x2fd>





}
  802fef:	eb 00                	jmp    802ff1 <insert_sorted_with_merge_freeList+0x746>
  802ff1:	90                   	nop
  802ff2:	c9                   	leave  
  802ff3:	c3                   	ret    

00802ff4 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802ff4:	55                   	push   %ebp
  802ff5:	89 e5                	mov    %esp,%ebp
  802ff7:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  802ffa:	8b 55 08             	mov    0x8(%ebp),%edx
  802ffd:	89 d0                	mov    %edx,%eax
  802fff:	c1 e0 02             	shl    $0x2,%eax
  803002:	01 d0                	add    %edx,%eax
  803004:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80300b:	01 d0                	add    %edx,%eax
  80300d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803014:	01 d0                	add    %edx,%eax
  803016:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80301d:	01 d0                	add    %edx,%eax
  80301f:	c1 e0 04             	shl    $0x4,%eax
  803022:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803025:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80302c:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80302f:	83 ec 0c             	sub    $0xc,%esp
  803032:	50                   	push   %eax
  803033:	e8 31 ec ff ff       	call   801c69 <sys_get_virtual_time>
  803038:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80303b:	eb 41                	jmp    80307e <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80303d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803040:	83 ec 0c             	sub    $0xc,%esp
  803043:	50                   	push   %eax
  803044:	e8 20 ec ff ff       	call   801c69 <sys_get_virtual_time>
  803049:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80304c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80304f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803052:	29 c2                	sub    %eax,%edx
  803054:	89 d0                	mov    %edx,%eax
  803056:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803059:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80305c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80305f:	89 d1                	mov    %edx,%ecx
  803061:	29 c1                	sub    %eax,%ecx
  803063:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803066:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803069:	39 c2                	cmp    %eax,%edx
  80306b:	0f 97 c0             	seta   %al
  80306e:	0f b6 c0             	movzbl %al,%eax
  803071:	29 c1                	sub    %eax,%ecx
  803073:	89 c8                	mov    %ecx,%eax
  803075:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803078:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80307b:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80307e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803081:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803084:	72 b7                	jb     80303d <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803086:	90                   	nop
  803087:	c9                   	leave  
  803088:	c3                   	ret    

00803089 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803089:	55                   	push   %ebp
  80308a:	89 e5                	mov    %esp,%ebp
  80308c:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80308f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803096:	eb 03                	jmp    80309b <busy_wait+0x12>
  803098:	ff 45 fc             	incl   -0x4(%ebp)
  80309b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80309e:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030a1:	72 f5                	jb     803098 <busy_wait+0xf>
	return i;
  8030a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8030a6:	c9                   	leave  
  8030a7:	c3                   	ret    

008030a8 <__udivdi3>:
  8030a8:	55                   	push   %ebp
  8030a9:	57                   	push   %edi
  8030aa:	56                   	push   %esi
  8030ab:	53                   	push   %ebx
  8030ac:	83 ec 1c             	sub    $0x1c,%esp
  8030af:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8030b3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8030b7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8030bb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8030bf:	89 ca                	mov    %ecx,%edx
  8030c1:	89 f8                	mov    %edi,%eax
  8030c3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8030c7:	85 f6                	test   %esi,%esi
  8030c9:	75 2d                	jne    8030f8 <__udivdi3+0x50>
  8030cb:	39 cf                	cmp    %ecx,%edi
  8030cd:	77 65                	ja     803134 <__udivdi3+0x8c>
  8030cf:	89 fd                	mov    %edi,%ebp
  8030d1:	85 ff                	test   %edi,%edi
  8030d3:	75 0b                	jne    8030e0 <__udivdi3+0x38>
  8030d5:	b8 01 00 00 00       	mov    $0x1,%eax
  8030da:	31 d2                	xor    %edx,%edx
  8030dc:	f7 f7                	div    %edi
  8030de:	89 c5                	mov    %eax,%ebp
  8030e0:	31 d2                	xor    %edx,%edx
  8030e2:	89 c8                	mov    %ecx,%eax
  8030e4:	f7 f5                	div    %ebp
  8030e6:	89 c1                	mov    %eax,%ecx
  8030e8:	89 d8                	mov    %ebx,%eax
  8030ea:	f7 f5                	div    %ebp
  8030ec:	89 cf                	mov    %ecx,%edi
  8030ee:	89 fa                	mov    %edi,%edx
  8030f0:	83 c4 1c             	add    $0x1c,%esp
  8030f3:	5b                   	pop    %ebx
  8030f4:	5e                   	pop    %esi
  8030f5:	5f                   	pop    %edi
  8030f6:	5d                   	pop    %ebp
  8030f7:	c3                   	ret    
  8030f8:	39 ce                	cmp    %ecx,%esi
  8030fa:	77 28                	ja     803124 <__udivdi3+0x7c>
  8030fc:	0f bd fe             	bsr    %esi,%edi
  8030ff:	83 f7 1f             	xor    $0x1f,%edi
  803102:	75 40                	jne    803144 <__udivdi3+0x9c>
  803104:	39 ce                	cmp    %ecx,%esi
  803106:	72 0a                	jb     803112 <__udivdi3+0x6a>
  803108:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80310c:	0f 87 9e 00 00 00    	ja     8031b0 <__udivdi3+0x108>
  803112:	b8 01 00 00 00       	mov    $0x1,%eax
  803117:	89 fa                	mov    %edi,%edx
  803119:	83 c4 1c             	add    $0x1c,%esp
  80311c:	5b                   	pop    %ebx
  80311d:	5e                   	pop    %esi
  80311e:	5f                   	pop    %edi
  80311f:	5d                   	pop    %ebp
  803120:	c3                   	ret    
  803121:	8d 76 00             	lea    0x0(%esi),%esi
  803124:	31 ff                	xor    %edi,%edi
  803126:	31 c0                	xor    %eax,%eax
  803128:	89 fa                	mov    %edi,%edx
  80312a:	83 c4 1c             	add    $0x1c,%esp
  80312d:	5b                   	pop    %ebx
  80312e:	5e                   	pop    %esi
  80312f:	5f                   	pop    %edi
  803130:	5d                   	pop    %ebp
  803131:	c3                   	ret    
  803132:	66 90                	xchg   %ax,%ax
  803134:	89 d8                	mov    %ebx,%eax
  803136:	f7 f7                	div    %edi
  803138:	31 ff                	xor    %edi,%edi
  80313a:	89 fa                	mov    %edi,%edx
  80313c:	83 c4 1c             	add    $0x1c,%esp
  80313f:	5b                   	pop    %ebx
  803140:	5e                   	pop    %esi
  803141:	5f                   	pop    %edi
  803142:	5d                   	pop    %ebp
  803143:	c3                   	ret    
  803144:	bd 20 00 00 00       	mov    $0x20,%ebp
  803149:	89 eb                	mov    %ebp,%ebx
  80314b:	29 fb                	sub    %edi,%ebx
  80314d:	89 f9                	mov    %edi,%ecx
  80314f:	d3 e6                	shl    %cl,%esi
  803151:	89 c5                	mov    %eax,%ebp
  803153:	88 d9                	mov    %bl,%cl
  803155:	d3 ed                	shr    %cl,%ebp
  803157:	89 e9                	mov    %ebp,%ecx
  803159:	09 f1                	or     %esi,%ecx
  80315b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80315f:	89 f9                	mov    %edi,%ecx
  803161:	d3 e0                	shl    %cl,%eax
  803163:	89 c5                	mov    %eax,%ebp
  803165:	89 d6                	mov    %edx,%esi
  803167:	88 d9                	mov    %bl,%cl
  803169:	d3 ee                	shr    %cl,%esi
  80316b:	89 f9                	mov    %edi,%ecx
  80316d:	d3 e2                	shl    %cl,%edx
  80316f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803173:	88 d9                	mov    %bl,%cl
  803175:	d3 e8                	shr    %cl,%eax
  803177:	09 c2                	or     %eax,%edx
  803179:	89 d0                	mov    %edx,%eax
  80317b:	89 f2                	mov    %esi,%edx
  80317d:	f7 74 24 0c          	divl   0xc(%esp)
  803181:	89 d6                	mov    %edx,%esi
  803183:	89 c3                	mov    %eax,%ebx
  803185:	f7 e5                	mul    %ebp
  803187:	39 d6                	cmp    %edx,%esi
  803189:	72 19                	jb     8031a4 <__udivdi3+0xfc>
  80318b:	74 0b                	je     803198 <__udivdi3+0xf0>
  80318d:	89 d8                	mov    %ebx,%eax
  80318f:	31 ff                	xor    %edi,%edi
  803191:	e9 58 ff ff ff       	jmp    8030ee <__udivdi3+0x46>
  803196:	66 90                	xchg   %ax,%ax
  803198:	8b 54 24 08          	mov    0x8(%esp),%edx
  80319c:	89 f9                	mov    %edi,%ecx
  80319e:	d3 e2                	shl    %cl,%edx
  8031a0:	39 c2                	cmp    %eax,%edx
  8031a2:	73 e9                	jae    80318d <__udivdi3+0xe5>
  8031a4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8031a7:	31 ff                	xor    %edi,%edi
  8031a9:	e9 40 ff ff ff       	jmp    8030ee <__udivdi3+0x46>
  8031ae:	66 90                	xchg   %ax,%ax
  8031b0:	31 c0                	xor    %eax,%eax
  8031b2:	e9 37 ff ff ff       	jmp    8030ee <__udivdi3+0x46>
  8031b7:	90                   	nop

008031b8 <__umoddi3>:
  8031b8:	55                   	push   %ebp
  8031b9:	57                   	push   %edi
  8031ba:	56                   	push   %esi
  8031bb:	53                   	push   %ebx
  8031bc:	83 ec 1c             	sub    $0x1c,%esp
  8031bf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8031c3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8031c7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8031cb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8031cf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8031d3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8031d7:	89 f3                	mov    %esi,%ebx
  8031d9:	89 fa                	mov    %edi,%edx
  8031db:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8031df:	89 34 24             	mov    %esi,(%esp)
  8031e2:	85 c0                	test   %eax,%eax
  8031e4:	75 1a                	jne    803200 <__umoddi3+0x48>
  8031e6:	39 f7                	cmp    %esi,%edi
  8031e8:	0f 86 a2 00 00 00    	jbe    803290 <__umoddi3+0xd8>
  8031ee:	89 c8                	mov    %ecx,%eax
  8031f0:	89 f2                	mov    %esi,%edx
  8031f2:	f7 f7                	div    %edi
  8031f4:	89 d0                	mov    %edx,%eax
  8031f6:	31 d2                	xor    %edx,%edx
  8031f8:	83 c4 1c             	add    $0x1c,%esp
  8031fb:	5b                   	pop    %ebx
  8031fc:	5e                   	pop    %esi
  8031fd:	5f                   	pop    %edi
  8031fe:	5d                   	pop    %ebp
  8031ff:	c3                   	ret    
  803200:	39 f0                	cmp    %esi,%eax
  803202:	0f 87 ac 00 00 00    	ja     8032b4 <__umoddi3+0xfc>
  803208:	0f bd e8             	bsr    %eax,%ebp
  80320b:	83 f5 1f             	xor    $0x1f,%ebp
  80320e:	0f 84 ac 00 00 00    	je     8032c0 <__umoddi3+0x108>
  803214:	bf 20 00 00 00       	mov    $0x20,%edi
  803219:	29 ef                	sub    %ebp,%edi
  80321b:	89 fe                	mov    %edi,%esi
  80321d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803221:	89 e9                	mov    %ebp,%ecx
  803223:	d3 e0                	shl    %cl,%eax
  803225:	89 d7                	mov    %edx,%edi
  803227:	89 f1                	mov    %esi,%ecx
  803229:	d3 ef                	shr    %cl,%edi
  80322b:	09 c7                	or     %eax,%edi
  80322d:	89 e9                	mov    %ebp,%ecx
  80322f:	d3 e2                	shl    %cl,%edx
  803231:	89 14 24             	mov    %edx,(%esp)
  803234:	89 d8                	mov    %ebx,%eax
  803236:	d3 e0                	shl    %cl,%eax
  803238:	89 c2                	mov    %eax,%edx
  80323a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80323e:	d3 e0                	shl    %cl,%eax
  803240:	89 44 24 04          	mov    %eax,0x4(%esp)
  803244:	8b 44 24 08          	mov    0x8(%esp),%eax
  803248:	89 f1                	mov    %esi,%ecx
  80324a:	d3 e8                	shr    %cl,%eax
  80324c:	09 d0                	or     %edx,%eax
  80324e:	d3 eb                	shr    %cl,%ebx
  803250:	89 da                	mov    %ebx,%edx
  803252:	f7 f7                	div    %edi
  803254:	89 d3                	mov    %edx,%ebx
  803256:	f7 24 24             	mull   (%esp)
  803259:	89 c6                	mov    %eax,%esi
  80325b:	89 d1                	mov    %edx,%ecx
  80325d:	39 d3                	cmp    %edx,%ebx
  80325f:	0f 82 87 00 00 00    	jb     8032ec <__umoddi3+0x134>
  803265:	0f 84 91 00 00 00    	je     8032fc <__umoddi3+0x144>
  80326b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80326f:	29 f2                	sub    %esi,%edx
  803271:	19 cb                	sbb    %ecx,%ebx
  803273:	89 d8                	mov    %ebx,%eax
  803275:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803279:	d3 e0                	shl    %cl,%eax
  80327b:	89 e9                	mov    %ebp,%ecx
  80327d:	d3 ea                	shr    %cl,%edx
  80327f:	09 d0                	or     %edx,%eax
  803281:	89 e9                	mov    %ebp,%ecx
  803283:	d3 eb                	shr    %cl,%ebx
  803285:	89 da                	mov    %ebx,%edx
  803287:	83 c4 1c             	add    $0x1c,%esp
  80328a:	5b                   	pop    %ebx
  80328b:	5e                   	pop    %esi
  80328c:	5f                   	pop    %edi
  80328d:	5d                   	pop    %ebp
  80328e:	c3                   	ret    
  80328f:	90                   	nop
  803290:	89 fd                	mov    %edi,%ebp
  803292:	85 ff                	test   %edi,%edi
  803294:	75 0b                	jne    8032a1 <__umoddi3+0xe9>
  803296:	b8 01 00 00 00       	mov    $0x1,%eax
  80329b:	31 d2                	xor    %edx,%edx
  80329d:	f7 f7                	div    %edi
  80329f:	89 c5                	mov    %eax,%ebp
  8032a1:	89 f0                	mov    %esi,%eax
  8032a3:	31 d2                	xor    %edx,%edx
  8032a5:	f7 f5                	div    %ebp
  8032a7:	89 c8                	mov    %ecx,%eax
  8032a9:	f7 f5                	div    %ebp
  8032ab:	89 d0                	mov    %edx,%eax
  8032ad:	e9 44 ff ff ff       	jmp    8031f6 <__umoddi3+0x3e>
  8032b2:	66 90                	xchg   %ax,%ax
  8032b4:	89 c8                	mov    %ecx,%eax
  8032b6:	89 f2                	mov    %esi,%edx
  8032b8:	83 c4 1c             	add    $0x1c,%esp
  8032bb:	5b                   	pop    %ebx
  8032bc:	5e                   	pop    %esi
  8032bd:	5f                   	pop    %edi
  8032be:	5d                   	pop    %ebp
  8032bf:	c3                   	ret    
  8032c0:	3b 04 24             	cmp    (%esp),%eax
  8032c3:	72 06                	jb     8032cb <__umoddi3+0x113>
  8032c5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8032c9:	77 0f                	ja     8032da <__umoddi3+0x122>
  8032cb:	89 f2                	mov    %esi,%edx
  8032cd:	29 f9                	sub    %edi,%ecx
  8032cf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8032d3:	89 14 24             	mov    %edx,(%esp)
  8032d6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8032da:	8b 44 24 04          	mov    0x4(%esp),%eax
  8032de:	8b 14 24             	mov    (%esp),%edx
  8032e1:	83 c4 1c             	add    $0x1c,%esp
  8032e4:	5b                   	pop    %ebx
  8032e5:	5e                   	pop    %esi
  8032e6:	5f                   	pop    %edi
  8032e7:	5d                   	pop    %ebp
  8032e8:	c3                   	ret    
  8032e9:	8d 76 00             	lea    0x0(%esi),%esi
  8032ec:	2b 04 24             	sub    (%esp),%eax
  8032ef:	19 fa                	sbb    %edi,%edx
  8032f1:	89 d1                	mov    %edx,%ecx
  8032f3:	89 c6                	mov    %eax,%esi
  8032f5:	e9 71 ff ff ff       	jmp    80326b <__umoddi3+0xb3>
  8032fa:	66 90                	xchg   %ax,%ax
  8032fc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803300:	72 ea                	jb     8032ec <__umoddi3+0x134>
  803302:	89 d9                	mov    %ebx,%ecx
  803304:	e9 62 ff ff ff       	jmp    80326b <__umoddi3+0xb3>
