
obj/user/tst_envfree6:     file format elf32-i386


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
  800031:	e8 5c 01 00 00       	call   800192 <libmain>
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
	// Testing scenario 6: Semaphores & shared variables
	// Testing removing the shared variables and semaphores
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 20 33 80 00       	push   $0x803320
  80004a:	e8 28 16 00 00       	call   801677 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 d7 18 00 00       	call   80193a <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 6f 19 00 00       	call   8019da <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 30 33 80 00       	push   $0x803330
  800079:	e8 04 05 00 00       	call   800582 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr1", 2000, (myEnv->SecondListSize),50);
  800081:	a1 20 40 80 00       	mov    0x804020,%eax
  800086:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	68 d0 07 00 00       	push   $0x7d0
  800094:	68 63 33 80 00       	push   $0x803363
  800099:	e8 0e 1b 00 00       	call   801bac <sys_create_env>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int32 envIdProcessB = sys_create_env("ef_midterm", 20,(myEnv->SecondListSize), 50);
  8000a4:	a1 20 40 80 00       	mov    0x804020,%eax
  8000a9:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000af:	6a 32                	push   $0x32
  8000b1:	50                   	push   %eax
  8000b2:	6a 14                	push   $0x14
  8000b4:	68 6c 33 80 00       	push   $0x80336c
  8000b9:	e8 ee 1a 00 00       	call   801bac <sys_create_env>
  8000be:	83 c4 10             	add    $0x10,%esp
  8000c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	sys_run_env(envIdProcessA);
  8000c4:	83 ec 0c             	sub    $0xc,%esp
  8000c7:	ff 75 e8             	pushl  -0x18(%ebp)
  8000ca:	e8 fb 1a 00 00       	call   801bca <sys_run_env>
  8000cf:	83 c4 10             	add    $0x10,%esp
	env_sleep(10000);
  8000d2:	83 ec 0c             	sub    $0xc,%esp
  8000d5:	68 10 27 00 00       	push   $0x2710
  8000da:	e8 12 2f 00 00       	call   802ff1 <env_sleep>
  8000df:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000e8:	e8 dd 1a 00 00       	call   801bca <sys_run_env>
  8000ed:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  8000f0:	90                   	nop
  8000f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000f4:	8b 00                	mov    (%eax),%eax
  8000f6:	83 f8 02             	cmp    $0x2,%eax
  8000f9:	75 f6                	jne    8000f1 <_main+0xb9>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000fb:	e8 3a 18 00 00       	call   80193a <sys_calculate_free_frames>
  800100:	83 ec 08             	sub    $0x8,%esp
  800103:	50                   	push   %eax
  800104:	68 78 33 80 00       	push   $0x803378
  800109:	e8 74 04 00 00       	call   800582 <cprintf>
  80010e:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  800111:	83 ec 0c             	sub    $0xc,%esp
  800114:	ff 75 e8             	pushl  -0x18(%ebp)
  800117:	e8 ca 1a 00 00       	call   801be6 <sys_destroy_env>
  80011c:	83 c4 10             	add    $0x10,%esp
	sys_destroy_env(envIdProcessB);
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	ff 75 e4             	pushl  -0x1c(%ebp)
  800125:	e8 bc 1a 00 00       	call   801be6 <sys_destroy_env>
  80012a:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  80012d:	e8 08 18 00 00       	call   80193a <sys_calculate_free_frames>
  800132:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800135:	e8 a0 18 00 00       	call   8019da <sys_pf_calculate_allocated_pages>
  80013a:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  80013d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800140:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800143:	74 27                	je     80016c <_main+0x134>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  800145:	83 ec 08             	sub    $0x8,%esp
  800148:	ff 75 e0             	pushl  -0x20(%ebp)
  80014b:	68 ac 33 80 00       	push   $0x8033ac
  800150:	e8 2d 04 00 00       	call   800582 <cprintf>
  800155:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  800158:	83 ec 04             	sub    $0x4,%esp
  80015b:	68 fc 33 80 00       	push   $0x8033fc
  800160:	6a 23                	push   $0x23
  800162:	68 32 34 80 00       	push   $0x803432
  800167:	e8 62 01 00 00       	call   8002ce <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80016c:	83 ec 08             	sub    $0x8,%esp
  80016f:	ff 75 e0             	pushl  -0x20(%ebp)
  800172:	68 48 34 80 00       	push   $0x803448
  800177:	e8 06 04 00 00       	call   800582 <cprintf>
  80017c:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 6 for envfree completed successfully.\n");
  80017f:	83 ec 0c             	sub    $0xc,%esp
  800182:	68 a8 34 80 00       	push   $0x8034a8
  800187:	e8 f6 03 00 00       	call   800582 <cprintf>
  80018c:	83 c4 10             	add    $0x10,%esp
	return;
  80018f:	90                   	nop
}
  800190:	c9                   	leave  
  800191:	c3                   	ret    

00800192 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800192:	55                   	push   %ebp
  800193:	89 e5                	mov    %esp,%ebp
  800195:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800198:	e8 7d 1a 00 00       	call   801c1a <sys_getenvindex>
  80019d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001a3:	89 d0                	mov    %edx,%eax
  8001a5:	c1 e0 03             	shl    $0x3,%eax
  8001a8:	01 d0                	add    %edx,%eax
  8001aa:	01 c0                	add    %eax,%eax
  8001ac:	01 d0                	add    %edx,%eax
  8001ae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001b5:	01 d0                	add    %edx,%eax
  8001b7:	c1 e0 04             	shl    $0x4,%eax
  8001ba:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001bf:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001c4:	a1 20 40 80 00       	mov    0x804020,%eax
  8001c9:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001cf:	84 c0                	test   %al,%al
  8001d1:	74 0f                	je     8001e2 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001d3:	a1 20 40 80 00       	mov    0x804020,%eax
  8001d8:	05 5c 05 00 00       	add    $0x55c,%eax
  8001dd:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001e6:	7e 0a                	jle    8001f2 <libmain+0x60>
		binaryname = argv[0];
  8001e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001eb:	8b 00                	mov    (%eax),%eax
  8001ed:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001f2:	83 ec 08             	sub    $0x8,%esp
  8001f5:	ff 75 0c             	pushl  0xc(%ebp)
  8001f8:	ff 75 08             	pushl  0x8(%ebp)
  8001fb:	e8 38 fe ff ff       	call   800038 <_main>
  800200:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800203:	e8 1f 18 00 00       	call   801a27 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800208:	83 ec 0c             	sub    $0xc,%esp
  80020b:	68 0c 35 80 00       	push   $0x80350c
  800210:	e8 6d 03 00 00       	call   800582 <cprintf>
  800215:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800218:	a1 20 40 80 00       	mov    0x804020,%eax
  80021d:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800223:	a1 20 40 80 00       	mov    0x804020,%eax
  800228:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80022e:	83 ec 04             	sub    $0x4,%esp
  800231:	52                   	push   %edx
  800232:	50                   	push   %eax
  800233:	68 34 35 80 00       	push   $0x803534
  800238:	e8 45 03 00 00       	call   800582 <cprintf>
  80023d:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800240:	a1 20 40 80 00       	mov    0x804020,%eax
  800245:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80024b:	a1 20 40 80 00       	mov    0x804020,%eax
  800250:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800256:	a1 20 40 80 00       	mov    0x804020,%eax
  80025b:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800261:	51                   	push   %ecx
  800262:	52                   	push   %edx
  800263:	50                   	push   %eax
  800264:	68 5c 35 80 00       	push   $0x80355c
  800269:	e8 14 03 00 00       	call   800582 <cprintf>
  80026e:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800271:	a1 20 40 80 00       	mov    0x804020,%eax
  800276:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80027c:	83 ec 08             	sub    $0x8,%esp
  80027f:	50                   	push   %eax
  800280:	68 b4 35 80 00       	push   $0x8035b4
  800285:	e8 f8 02 00 00       	call   800582 <cprintf>
  80028a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80028d:	83 ec 0c             	sub    $0xc,%esp
  800290:	68 0c 35 80 00       	push   $0x80350c
  800295:	e8 e8 02 00 00       	call   800582 <cprintf>
  80029a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80029d:	e8 9f 17 00 00       	call   801a41 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002a2:	e8 19 00 00 00       	call   8002c0 <exit>
}
  8002a7:	90                   	nop
  8002a8:	c9                   	leave  
  8002a9:	c3                   	ret    

008002aa <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002aa:	55                   	push   %ebp
  8002ab:	89 e5                	mov    %esp,%ebp
  8002ad:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002b0:	83 ec 0c             	sub    $0xc,%esp
  8002b3:	6a 00                	push   $0x0
  8002b5:	e8 2c 19 00 00       	call   801be6 <sys_destroy_env>
  8002ba:	83 c4 10             	add    $0x10,%esp
}
  8002bd:	90                   	nop
  8002be:	c9                   	leave  
  8002bf:	c3                   	ret    

008002c0 <exit>:

void
exit(void)
{
  8002c0:	55                   	push   %ebp
  8002c1:	89 e5                	mov    %esp,%ebp
  8002c3:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002c6:	e8 81 19 00 00       	call   801c4c <sys_exit_env>
}
  8002cb:	90                   	nop
  8002cc:	c9                   	leave  
  8002cd:	c3                   	ret    

008002ce <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002ce:	55                   	push   %ebp
  8002cf:	89 e5                	mov    %esp,%ebp
  8002d1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002d4:	8d 45 10             	lea    0x10(%ebp),%eax
  8002d7:	83 c0 04             	add    $0x4,%eax
  8002da:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002dd:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002e2:	85 c0                	test   %eax,%eax
  8002e4:	74 16                	je     8002fc <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002e6:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002eb:	83 ec 08             	sub    $0x8,%esp
  8002ee:	50                   	push   %eax
  8002ef:	68 c8 35 80 00       	push   $0x8035c8
  8002f4:	e8 89 02 00 00       	call   800582 <cprintf>
  8002f9:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002fc:	a1 00 40 80 00       	mov    0x804000,%eax
  800301:	ff 75 0c             	pushl  0xc(%ebp)
  800304:	ff 75 08             	pushl  0x8(%ebp)
  800307:	50                   	push   %eax
  800308:	68 cd 35 80 00       	push   $0x8035cd
  80030d:	e8 70 02 00 00       	call   800582 <cprintf>
  800312:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800315:	8b 45 10             	mov    0x10(%ebp),%eax
  800318:	83 ec 08             	sub    $0x8,%esp
  80031b:	ff 75 f4             	pushl  -0xc(%ebp)
  80031e:	50                   	push   %eax
  80031f:	e8 f3 01 00 00       	call   800517 <vcprintf>
  800324:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800327:	83 ec 08             	sub    $0x8,%esp
  80032a:	6a 00                	push   $0x0
  80032c:	68 e9 35 80 00       	push   $0x8035e9
  800331:	e8 e1 01 00 00       	call   800517 <vcprintf>
  800336:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800339:	e8 82 ff ff ff       	call   8002c0 <exit>

	// should not return here
	while (1) ;
  80033e:	eb fe                	jmp    80033e <_panic+0x70>

00800340 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800340:	55                   	push   %ebp
  800341:	89 e5                	mov    %esp,%ebp
  800343:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800346:	a1 20 40 80 00       	mov    0x804020,%eax
  80034b:	8b 50 74             	mov    0x74(%eax),%edx
  80034e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800351:	39 c2                	cmp    %eax,%edx
  800353:	74 14                	je     800369 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800355:	83 ec 04             	sub    $0x4,%esp
  800358:	68 ec 35 80 00       	push   $0x8035ec
  80035d:	6a 26                	push   $0x26
  80035f:	68 38 36 80 00       	push   $0x803638
  800364:	e8 65 ff ff ff       	call   8002ce <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800369:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800370:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800377:	e9 c2 00 00 00       	jmp    80043e <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80037c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80037f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800386:	8b 45 08             	mov    0x8(%ebp),%eax
  800389:	01 d0                	add    %edx,%eax
  80038b:	8b 00                	mov    (%eax),%eax
  80038d:	85 c0                	test   %eax,%eax
  80038f:	75 08                	jne    800399 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800391:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800394:	e9 a2 00 00 00       	jmp    80043b <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800399:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003a0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003a7:	eb 69                	jmp    800412 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003a9:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ae:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003b4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003b7:	89 d0                	mov    %edx,%eax
  8003b9:	01 c0                	add    %eax,%eax
  8003bb:	01 d0                	add    %edx,%eax
  8003bd:	c1 e0 03             	shl    $0x3,%eax
  8003c0:	01 c8                	add    %ecx,%eax
  8003c2:	8a 40 04             	mov    0x4(%eax),%al
  8003c5:	84 c0                	test   %al,%al
  8003c7:	75 46                	jne    80040f <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003c9:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ce:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003d4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003d7:	89 d0                	mov    %edx,%eax
  8003d9:	01 c0                	add    %eax,%eax
  8003db:	01 d0                	add    %edx,%eax
  8003dd:	c1 e0 03             	shl    $0x3,%eax
  8003e0:	01 c8                	add    %ecx,%eax
  8003e2:	8b 00                	mov    (%eax),%eax
  8003e4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003ea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003ef:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fe:	01 c8                	add    %ecx,%eax
  800400:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800402:	39 c2                	cmp    %eax,%edx
  800404:	75 09                	jne    80040f <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800406:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80040d:	eb 12                	jmp    800421 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80040f:	ff 45 e8             	incl   -0x18(%ebp)
  800412:	a1 20 40 80 00       	mov    0x804020,%eax
  800417:	8b 50 74             	mov    0x74(%eax),%edx
  80041a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80041d:	39 c2                	cmp    %eax,%edx
  80041f:	77 88                	ja     8003a9 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800421:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800425:	75 14                	jne    80043b <CheckWSWithoutLastIndex+0xfb>
			panic(
  800427:	83 ec 04             	sub    $0x4,%esp
  80042a:	68 44 36 80 00       	push   $0x803644
  80042f:	6a 3a                	push   $0x3a
  800431:	68 38 36 80 00       	push   $0x803638
  800436:	e8 93 fe ff ff       	call   8002ce <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80043b:	ff 45 f0             	incl   -0x10(%ebp)
  80043e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800441:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800444:	0f 8c 32 ff ff ff    	jl     80037c <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80044a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800451:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800458:	eb 26                	jmp    800480 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80045a:	a1 20 40 80 00       	mov    0x804020,%eax
  80045f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800465:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800468:	89 d0                	mov    %edx,%eax
  80046a:	01 c0                	add    %eax,%eax
  80046c:	01 d0                	add    %edx,%eax
  80046e:	c1 e0 03             	shl    $0x3,%eax
  800471:	01 c8                	add    %ecx,%eax
  800473:	8a 40 04             	mov    0x4(%eax),%al
  800476:	3c 01                	cmp    $0x1,%al
  800478:	75 03                	jne    80047d <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80047a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80047d:	ff 45 e0             	incl   -0x20(%ebp)
  800480:	a1 20 40 80 00       	mov    0x804020,%eax
  800485:	8b 50 74             	mov    0x74(%eax),%edx
  800488:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80048b:	39 c2                	cmp    %eax,%edx
  80048d:	77 cb                	ja     80045a <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80048f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800492:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800495:	74 14                	je     8004ab <CheckWSWithoutLastIndex+0x16b>
		panic(
  800497:	83 ec 04             	sub    $0x4,%esp
  80049a:	68 98 36 80 00       	push   $0x803698
  80049f:	6a 44                	push   $0x44
  8004a1:	68 38 36 80 00       	push   $0x803638
  8004a6:	e8 23 fe ff ff       	call   8002ce <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004ab:	90                   	nop
  8004ac:	c9                   	leave  
  8004ad:	c3                   	ret    

008004ae <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8004ae:	55                   	push   %ebp
  8004af:	89 e5                	mov    %esp,%ebp
  8004b1:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b7:	8b 00                	mov    (%eax),%eax
  8004b9:	8d 48 01             	lea    0x1(%eax),%ecx
  8004bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004bf:	89 0a                	mov    %ecx,(%edx)
  8004c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8004c4:	88 d1                	mov    %dl,%cl
  8004c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c9:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d0:	8b 00                	mov    (%eax),%eax
  8004d2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004d7:	75 2c                	jne    800505 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004d9:	a0 24 40 80 00       	mov    0x804024,%al
  8004de:	0f b6 c0             	movzbl %al,%eax
  8004e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004e4:	8b 12                	mov    (%edx),%edx
  8004e6:	89 d1                	mov    %edx,%ecx
  8004e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004eb:	83 c2 08             	add    $0x8,%edx
  8004ee:	83 ec 04             	sub    $0x4,%esp
  8004f1:	50                   	push   %eax
  8004f2:	51                   	push   %ecx
  8004f3:	52                   	push   %edx
  8004f4:	e8 80 13 00 00       	call   801879 <sys_cputs>
  8004f9:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800505:	8b 45 0c             	mov    0xc(%ebp),%eax
  800508:	8b 40 04             	mov    0x4(%eax),%eax
  80050b:	8d 50 01             	lea    0x1(%eax),%edx
  80050e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800511:	89 50 04             	mov    %edx,0x4(%eax)
}
  800514:	90                   	nop
  800515:	c9                   	leave  
  800516:	c3                   	ret    

00800517 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800517:	55                   	push   %ebp
  800518:	89 e5                	mov    %esp,%ebp
  80051a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800520:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800527:	00 00 00 
	b.cnt = 0;
  80052a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800531:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800534:	ff 75 0c             	pushl  0xc(%ebp)
  800537:	ff 75 08             	pushl  0x8(%ebp)
  80053a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800540:	50                   	push   %eax
  800541:	68 ae 04 80 00       	push   $0x8004ae
  800546:	e8 11 02 00 00       	call   80075c <vprintfmt>
  80054b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80054e:	a0 24 40 80 00       	mov    0x804024,%al
  800553:	0f b6 c0             	movzbl %al,%eax
  800556:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80055c:	83 ec 04             	sub    $0x4,%esp
  80055f:	50                   	push   %eax
  800560:	52                   	push   %edx
  800561:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800567:	83 c0 08             	add    $0x8,%eax
  80056a:	50                   	push   %eax
  80056b:	e8 09 13 00 00       	call   801879 <sys_cputs>
  800570:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800573:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80057a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800580:	c9                   	leave  
  800581:	c3                   	ret    

00800582 <cprintf>:

int cprintf(const char *fmt, ...) {
  800582:	55                   	push   %ebp
  800583:	89 e5                	mov    %esp,%ebp
  800585:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800588:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80058f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800592:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800595:	8b 45 08             	mov    0x8(%ebp),%eax
  800598:	83 ec 08             	sub    $0x8,%esp
  80059b:	ff 75 f4             	pushl  -0xc(%ebp)
  80059e:	50                   	push   %eax
  80059f:	e8 73 ff ff ff       	call   800517 <vcprintf>
  8005a4:	83 c4 10             	add    $0x10,%esp
  8005a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005ad:	c9                   	leave  
  8005ae:	c3                   	ret    

008005af <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8005af:	55                   	push   %ebp
  8005b0:	89 e5                	mov    %esp,%ebp
  8005b2:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005b5:	e8 6d 14 00 00       	call   801a27 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005ba:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c3:	83 ec 08             	sub    $0x8,%esp
  8005c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8005c9:	50                   	push   %eax
  8005ca:	e8 48 ff ff ff       	call   800517 <vcprintf>
  8005cf:	83 c4 10             	add    $0x10,%esp
  8005d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005d5:	e8 67 14 00 00       	call   801a41 <sys_enable_interrupt>
	return cnt;
  8005da:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005dd:	c9                   	leave  
  8005de:	c3                   	ret    

008005df <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005df:	55                   	push   %ebp
  8005e0:	89 e5                	mov    %esp,%ebp
  8005e2:	53                   	push   %ebx
  8005e3:	83 ec 14             	sub    $0x14,%esp
  8005e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8005e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005f2:	8b 45 18             	mov    0x18(%ebp),%eax
  8005f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fa:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005fd:	77 55                	ja     800654 <printnum+0x75>
  8005ff:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800602:	72 05                	jb     800609 <printnum+0x2a>
  800604:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800607:	77 4b                	ja     800654 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800609:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80060c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80060f:	8b 45 18             	mov    0x18(%ebp),%eax
  800612:	ba 00 00 00 00       	mov    $0x0,%edx
  800617:	52                   	push   %edx
  800618:	50                   	push   %eax
  800619:	ff 75 f4             	pushl  -0xc(%ebp)
  80061c:	ff 75 f0             	pushl  -0x10(%ebp)
  80061f:	e8 84 2a 00 00       	call   8030a8 <__udivdi3>
  800624:	83 c4 10             	add    $0x10,%esp
  800627:	83 ec 04             	sub    $0x4,%esp
  80062a:	ff 75 20             	pushl  0x20(%ebp)
  80062d:	53                   	push   %ebx
  80062e:	ff 75 18             	pushl  0x18(%ebp)
  800631:	52                   	push   %edx
  800632:	50                   	push   %eax
  800633:	ff 75 0c             	pushl  0xc(%ebp)
  800636:	ff 75 08             	pushl  0x8(%ebp)
  800639:	e8 a1 ff ff ff       	call   8005df <printnum>
  80063e:	83 c4 20             	add    $0x20,%esp
  800641:	eb 1a                	jmp    80065d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800643:	83 ec 08             	sub    $0x8,%esp
  800646:	ff 75 0c             	pushl  0xc(%ebp)
  800649:	ff 75 20             	pushl  0x20(%ebp)
  80064c:	8b 45 08             	mov    0x8(%ebp),%eax
  80064f:	ff d0                	call   *%eax
  800651:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800654:	ff 4d 1c             	decl   0x1c(%ebp)
  800657:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80065b:	7f e6                	jg     800643 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80065d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800660:	bb 00 00 00 00       	mov    $0x0,%ebx
  800665:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800668:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80066b:	53                   	push   %ebx
  80066c:	51                   	push   %ecx
  80066d:	52                   	push   %edx
  80066e:	50                   	push   %eax
  80066f:	e8 44 2b 00 00       	call   8031b8 <__umoddi3>
  800674:	83 c4 10             	add    $0x10,%esp
  800677:	05 14 39 80 00       	add    $0x803914,%eax
  80067c:	8a 00                	mov    (%eax),%al
  80067e:	0f be c0             	movsbl %al,%eax
  800681:	83 ec 08             	sub    $0x8,%esp
  800684:	ff 75 0c             	pushl  0xc(%ebp)
  800687:	50                   	push   %eax
  800688:	8b 45 08             	mov    0x8(%ebp),%eax
  80068b:	ff d0                	call   *%eax
  80068d:	83 c4 10             	add    $0x10,%esp
}
  800690:	90                   	nop
  800691:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800694:	c9                   	leave  
  800695:	c3                   	ret    

00800696 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800696:	55                   	push   %ebp
  800697:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800699:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80069d:	7e 1c                	jle    8006bb <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80069f:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a2:	8b 00                	mov    (%eax),%eax
  8006a4:	8d 50 08             	lea    0x8(%eax),%edx
  8006a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006aa:	89 10                	mov    %edx,(%eax)
  8006ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8006af:	8b 00                	mov    (%eax),%eax
  8006b1:	83 e8 08             	sub    $0x8,%eax
  8006b4:	8b 50 04             	mov    0x4(%eax),%edx
  8006b7:	8b 00                	mov    (%eax),%eax
  8006b9:	eb 40                	jmp    8006fb <getuint+0x65>
	else if (lflag)
  8006bb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006bf:	74 1e                	je     8006df <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c4:	8b 00                	mov    (%eax),%eax
  8006c6:	8d 50 04             	lea    0x4(%eax),%edx
  8006c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cc:	89 10                	mov    %edx,(%eax)
  8006ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d1:	8b 00                	mov    (%eax),%eax
  8006d3:	83 e8 04             	sub    $0x4,%eax
  8006d6:	8b 00                	mov    (%eax),%eax
  8006d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8006dd:	eb 1c                	jmp    8006fb <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006df:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e2:	8b 00                	mov    (%eax),%eax
  8006e4:	8d 50 04             	lea    0x4(%eax),%edx
  8006e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ea:	89 10                	mov    %edx,(%eax)
  8006ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ef:	8b 00                	mov    (%eax),%eax
  8006f1:	83 e8 04             	sub    $0x4,%eax
  8006f4:	8b 00                	mov    (%eax),%eax
  8006f6:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006fb:	5d                   	pop    %ebp
  8006fc:	c3                   	ret    

008006fd <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006fd:	55                   	push   %ebp
  8006fe:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800700:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800704:	7e 1c                	jle    800722 <getint+0x25>
		return va_arg(*ap, long long);
  800706:	8b 45 08             	mov    0x8(%ebp),%eax
  800709:	8b 00                	mov    (%eax),%eax
  80070b:	8d 50 08             	lea    0x8(%eax),%edx
  80070e:	8b 45 08             	mov    0x8(%ebp),%eax
  800711:	89 10                	mov    %edx,(%eax)
  800713:	8b 45 08             	mov    0x8(%ebp),%eax
  800716:	8b 00                	mov    (%eax),%eax
  800718:	83 e8 08             	sub    $0x8,%eax
  80071b:	8b 50 04             	mov    0x4(%eax),%edx
  80071e:	8b 00                	mov    (%eax),%eax
  800720:	eb 38                	jmp    80075a <getint+0x5d>
	else if (lflag)
  800722:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800726:	74 1a                	je     800742 <getint+0x45>
		return va_arg(*ap, long);
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	8b 00                	mov    (%eax),%eax
  80072d:	8d 50 04             	lea    0x4(%eax),%edx
  800730:	8b 45 08             	mov    0x8(%ebp),%eax
  800733:	89 10                	mov    %edx,(%eax)
  800735:	8b 45 08             	mov    0x8(%ebp),%eax
  800738:	8b 00                	mov    (%eax),%eax
  80073a:	83 e8 04             	sub    $0x4,%eax
  80073d:	8b 00                	mov    (%eax),%eax
  80073f:	99                   	cltd   
  800740:	eb 18                	jmp    80075a <getint+0x5d>
	else
		return va_arg(*ap, int);
  800742:	8b 45 08             	mov    0x8(%ebp),%eax
  800745:	8b 00                	mov    (%eax),%eax
  800747:	8d 50 04             	lea    0x4(%eax),%edx
  80074a:	8b 45 08             	mov    0x8(%ebp),%eax
  80074d:	89 10                	mov    %edx,(%eax)
  80074f:	8b 45 08             	mov    0x8(%ebp),%eax
  800752:	8b 00                	mov    (%eax),%eax
  800754:	83 e8 04             	sub    $0x4,%eax
  800757:	8b 00                	mov    (%eax),%eax
  800759:	99                   	cltd   
}
  80075a:	5d                   	pop    %ebp
  80075b:	c3                   	ret    

0080075c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80075c:	55                   	push   %ebp
  80075d:	89 e5                	mov    %esp,%ebp
  80075f:	56                   	push   %esi
  800760:	53                   	push   %ebx
  800761:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800764:	eb 17                	jmp    80077d <vprintfmt+0x21>
			if (ch == '\0')
  800766:	85 db                	test   %ebx,%ebx
  800768:	0f 84 af 03 00 00    	je     800b1d <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80076e:	83 ec 08             	sub    $0x8,%esp
  800771:	ff 75 0c             	pushl  0xc(%ebp)
  800774:	53                   	push   %ebx
  800775:	8b 45 08             	mov    0x8(%ebp),%eax
  800778:	ff d0                	call   *%eax
  80077a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80077d:	8b 45 10             	mov    0x10(%ebp),%eax
  800780:	8d 50 01             	lea    0x1(%eax),%edx
  800783:	89 55 10             	mov    %edx,0x10(%ebp)
  800786:	8a 00                	mov    (%eax),%al
  800788:	0f b6 d8             	movzbl %al,%ebx
  80078b:	83 fb 25             	cmp    $0x25,%ebx
  80078e:	75 d6                	jne    800766 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800790:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800794:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80079b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007a2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007a9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b3:	8d 50 01             	lea    0x1(%eax),%edx
  8007b6:	89 55 10             	mov    %edx,0x10(%ebp)
  8007b9:	8a 00                	mov    (%eax),%al
  8007bb:	0f b6 d8             	movzbl %al,%ebx
  8007be:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007c1:	83 f8 55             	cmp    $0x55,%eax
  8007c4:	0f 87 2b 03 00 00    	ja     800af5 <vprintfmt+0x399>
  8007ca:	8b 04 85 38 39 80 00 	mov    0x803938(,%eax,4),%eax
  8007d1:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007d3:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007d7:	eb d7                	jmp    8007b0 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007d9:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007dd:	eb d1                	jmp    8007b0 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007df:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007e6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007e9:	89 d0                	mov    %edx,%eax
  8007eb:	c1 e0 02             	shl    $0x2,%eax
  8007ee:	01 d0                	add    %edx,%eax
  8007f0:	01 c0                	add    %eax,%eax
  8007f2:	01 d8                	add    %ebx,%eax
  8007f4:	83 e8 30             	sub    $0x30,%eax
  8007f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8007fd:	8a 00                	mov    (%eax),%al
  8007ff:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800802:	83 fb 2f             	cmp    $0x2f,%ebx
  800805:	7e 3e                	jle    800845 <vprintfmt+0xe9>
  800807:	83 fb 39             	cmp    $0x39,%ebx
  80080a:	7f 39                	jg     800845 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80080c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80080f:	eb d5                	jmp    8007e6 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800811:	8b 45 14             	mov    0x14(%ebp),%eax
  800814:	83 c0 04             	add    $0x4,%eax
  800817:	89 45 14             	mov    %eax,0x14(%ebp)
  80081a:	8b 45 14             	mov    0x14(%ebp),%eax
  80081d:	83 e8 04             	sub    $0x4,%eax
  800820:	8b 00                	mov    (%eax),%eax
  800822:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800825:	eb 1f                	jmp    800846 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800827:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80082b:	79 83                	jns    8007b0 <vprintfmt+0x54>
				width = 0;
  80082d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800834:	e9 77 ff ff ff       	jmp    8007b0 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800839:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800840:	e9 6b ff ff ff       	jmp    8007b0 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800845:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800846:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80084a:	0f 89 60 ff ff ff    	jns    8007b0 <vprintfmt+0x54>
				width = precision, precision = -1;
  800850:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800853:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800856:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80085d:	e9 4e ff ff ff       	jmp    8007b0 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800862:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800865:	e9 46 ff ff ff       	jmp    8007b0 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80086a:	8b 45 14             	mov    0x14(%ebp),%eax
  80086d:	83 c0 04             	add    $0x4,%eax
  800870:	89 45 14             	mov    %eax,0x14(%ebp)
  800873:	8b 45 14             	mov    0x14(%ebp),%eax
  800876:	83 e8 04             	sub    $0x4,%eax
  800879:	8b 00                	mov    (%eax),%eax
  80087b:	83 ec 08             	sub    $0x8,%esp
  80087e:	ff 75 0c             	pushl  0xc(%ebp)
  800881:	50                   	push   %eax
  800882:	8b 45 08             	mov    0x8(%ebp),%eax
  800885:	ff d0                	call   *%eax
  800887:	83 c4 10             	add    $0x10,%esp
			break;
  80088a:	e9 89 02 00 00       	jmp    800b18 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80088f:	8b 45 14             	mov    0x14(%ebp),%eax
  800892:	83 c0 04             	add    $0x4,%eax
  800895:	89 45 14             	mov    %eax,0x14(%ebp)
  800898:	8b 45 14             	mov    0x14(%ebp),%eax
  80089b:	83 e8 04             	sub    $0x4,%eax
  80089e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008a0:	85 db                	test   %ebx,%ebx
  8008a2:	79 02                	jns    8008a6 <vprintfmt+0x14a>
				err = -err;
  8008a4:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008a6:	83 fb 64             	cmp    $0x64,%ebx
  8008a9:	7f 0b                	jg     8008b6 <vprintfmt+0x15a>
  8008ab:	8b 34 9d 80 37 80 00 	mov    0x803780(,%ebx,4),%esi
  8008b2:	85 f6                	test   %esi,%esi
  8008b4:	75 19                	jne    8008cf <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008b6:	53                   	push   %ebx
  8008b7:	68 25 39 80 00       	push   $0x803925
  8008bc:	ff 75 0c             	pushl  0xc(%ebp)
  8008bf:	ff 75 08             	pushl  0x8(%ebp)
  8008c2:	e8 5e 02 00 00       	call   800b25 <printfmt>
  8008c7:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008ca:	e9 49 02 00 00       	jmp    800b18 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008cf:	56                   	push   %esi
  8008d0:	68 2e 39 80 00       	push   $0x80392e
  8008d5:	ff 75 0c             	pushl  0xc(%ebp)
  8008d8:	ff 75 08             	pushl  0x8(%ebp)
  8008db:	e8 45 02 00 00       	call   800b25 <printfmt>
  8008e0:	83 c4 10             	add    $0x10,%esp
			break;
  8008e3:	e9 30 02 00 00       	jmp    800b18 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008eb:	83 c0 04             	add    $0x4,%eax
  8008ee:	89 45 14             	mov    %eax,0x14(%ebp)
  8008f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f4:	83 e8 04             	sub    $0x4,%eax
  8008f7:	8b 30                	mov    (%eax),%esi
  8008f9:	85 f6                	test   %esi,%esi
  8008fb:	75 05                	jne    800902 <vprintfmt+0x1a6>
				p = "(null)";
  8008fd:	be 31 39 80 00       	mov    $0x803931,%esi
			if (width > 0 && padc != '-')
  800902:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800906:	7e 6d                	jle    800975 <vprintfmt+0x219>
  800908:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80090c:	74 67                	je     800975 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80090e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800911:	83 ec 08             	sub    $0x8,%esp
  800914:	50                   	push   %eax
  800915:	56                   	push   %esi
  800916:	e8 0c 03 00 00       	call   800c27 <strnlen>
  80091b:	83 c4 10             	add    $0x10,%esp
  80091e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800921:	eb 16                	jmp    800939 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800923:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800927:	83 ec 08             	sub    $0x8,%esp
  80092a:	ff 75 0c             	pushl  0xc(%ebp)
  80092d:	50                   	push   %eax
  80092e:	8b 45 08             	mov    0x8(%ebp),%eax
  800931:	ff d0                	call   *%eax
  800933:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800936:	ff 4d e4             	decl   -0x1c(%ebp)
  800939:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80093d:	7f e4                	jg     800923 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80093f:	eb 34                	jmp    800975 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800941:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800945:	74 1c                	je     800963 <vprintfmt+0x207>
  800947:	83 fb 1f             	cmp    $0x1f,%ebx
  80094a:	7e 05                	jle    800951 <vprintfmt+0x1f5>
  80094c:	83 fb 7e             	cmp    $0x7e,%ebx
  80094f:	7e 12                	jle    800963 <vprintfmt+0x207>
					putch('?', putdat);
  800951:	83 ec 08             	sub    $0x8,%esp
  800954:	ff 75 0c             	pushl  0xc(%ebp)
  800957:	6a 3f                	push   $0x3f
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	ff d0                	call   *%eax
  80095e:	83 c4 10             	add    $0x10,%esp
  800961:	eb 0f                	jmp    800972 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800963:	83 ec 08             	sub    $0x8,%esp
  800966:	ff 75 0c             	pushl  0xc(%ebp)
  800969:	53                   	push   %ebx
  80096a:	8b 45 08             	mov    0x8(%ebp),%eax
  80096d:	ff d0                	call   *%eax
  80096f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800972:	ff 4d e4             	decl   -0x1c(%ebp)
  800975:	89 f0                	mov    %esi,%eax
  800977:	8d 70 01             	lea    0x1(%eax),%esi
  80097a:	8a 00                	mov    (%eax),%al
  80097c:	0f be d8             	movsbl %al,%ebx
  80097f:	85 db                	test   %ebx,%ebx
  800981:	74 24                	je     8009a7 <vprintfmt+0x24b>
  800983:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800987:	78 b8                	js     800941 <vprintfmt+0x1e5>
  800989:	ff 4d e0             	decl   -0x20(%ebp)
  80098c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800990:	79 af                	jns    800941 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800992:	eb 13                	jmp    8009a7 <vprintfmt+0x24b>
				putch(' ', putdat);
  800994:	83 ec 08             	sub    $0x8,%esp
  800997:	ff 75 0c             	pushl  0xc(%ebp)
  80099a:	6a 20                	push   $0x20
  80099c:	8b 45 08             	mov    0x8(%ebp),%eax
  80099f:	ff d0                	call   *%eax
  8009a1:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009a4:	ff 4d e4             	decl   -0x1c(%ebp)
  8009a7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ab:	7f e7                	jg     800994 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009ad:	e9 66 01 00 00       	jmp    800b18 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009b2:	83 ec 08             	sub    $0x8,%esp
  8009b5:	ff 75 e8             	pushl  -0x18(%ebp)
  8009b8:	8d 45 14             	lea    0x14(%ebp),%eax
  8009bb:	50                   	push   %eax
  8009bc:	e8 3c fd ff ff       	call   8006fd <getint>
  8009c1:	83 c4 10             	add    $0x10,%esp
  8009c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009d0:	85 d2                	test   %edx,%edx
  8009d2:	79 23                	jns    8009f7 <vprintfmt+0x29b>
				putch('-', putdat);
  8009d4:	83 ec 08             	sub    $0x8,%esp
  8009d7:	ff 75 0c             	pushl  0xc(%ebp)
  8009da:	6a 2d                	push   $0x2d
  8009dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009df:	ff d0                	call   *%eax
  8009e1:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009ea:	f7 d8                	neg    %eax
  8009ec:	83 d2 00             	adc    $0x0,%edx
  8009ef:	f7 da                	neg    %edx
  8009f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009f4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009f7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009fe:	e9 bc 00 00 00       	jmp    800abf <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a03:	83 ec 08             	sub    $0x8,%esp
  800a06:	ff 75 e8             	pushl  -0x18(%ebp)
  800a09:	8d 45 14             	lea    0x14(%ebp),%eax
  800a0c:	50                   	push   %eax
  800a0d:	e8 84 fc ff ff       	call   800696 <getuint>
  800a12:	83 c4 10             	add    $0x10,%esp
  800a15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a18:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a1b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a22:	e9 98 00 00 00       	jmp    800abf <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a27:	83 ec 08             	sub    $0x8,%esp
  800a2a:	ff 75 0c             	pushl  0xc(%ebp)
  800a2d:	6a 58                	push   $0x58
  800a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a32:	ff d0                	call   *%eax
  800a34:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a37:	83 ec 08             	sub    $0x8,%esp
  800a3a:	ff 75 0c             	pushl  0xc(%ebp)
  800a3d:	6a 58                	push   $0x58
  800a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a42:	ff d0                	call   *%eax
  800a44:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a47:	83 ec 08             	sub    $0x8,%esp
  800a4a:	ff 75 0c             	pushl  0xc(%ebp)
  800a4d:	6a 58                	push   $0x58
  800a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a52:	ff d0                	call   *%eax
  800a54:	83 c4 10             	add    $0x10,%esp
			break;
  800a57:	e9 bc 00 00 00       	jmp    800b18 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a5c:	83 ec 08             	sub    $0x8,%esp
  800a5f:	ff 75 0c             	pushl  0xc(%ebp)
  800a62:	6a 30                	push   $0x30
  800a64:	8b 45 08             	mov    0x8(%ebp),%eax
  800a67:	ff d0                	call   *%eax
  800a69:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a6c:	83 ec 08             	sub    $0x8,%esp
  800a6f:	ff 75 0c             	pushl  0xc(%ebp)
  800a72:	6a 78                	push   $0x78
  800a74:	8b 45 08             	mov    0x8(%ebp),%eax
  800a77:	ff d0                	call   *%eax
  800a79:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7f:	83 c0 04             	add    $0x4,%eax
  800a82:	89 45 14             	mov    %eax,0x14(%ebp)
  800a85:	8b 45 14             	mov    0x14(%ebp),%eax
  800a88:	83 e8 04             	sub    $0x4,%eax
  800a8b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a90:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a97:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a9e:	eb 1f                	jmp    800abf <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800aa0:	83 ec 08             	sub    $0x8,%esp
  800aa3:	ff 75 e8             	pushl  -0x18(%ebp)
  800aa6:	8d 45 14             	lea    0x14(%ebp),%eax
  800aa9:	50                   	push   %eax
  800aaa:	e8 e7 fb ff ff       	call   800696 <getuint>
  800aaf:	83 c4 10             	add    $0x10,%esp
  800ab2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ab8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800abf:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ac3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ac6:	83 ec 04             	sub    $0x4,%esp
  800ac9:	52                   	push   %edx
  800aca:	ff 75 e4             	pushl  -0x1c(%ebp)
  800acd:	50                   	push   %eax
  800ace:	ff 75 f4             	pushl  -0xc(%ebp)
  800ad1:	ff 75 f0             	pushl  -0x10(%ebp)
  800ad4:	ff 75 0c             	pushl  0xc(%ebp)
  800ad7:	ff 75 08             	pushl  0x8(%ebp)
  800ada:	e8 00 fb ff ff       	call   8005df <printnum>
  800adf:	83 c4 20             	add    $0x20,%esp
			break;
  800ae2:	eb 34                	jmp    800b18 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ae4:	83 ec 08             	sub    $0x8,%esp
  800ae7:	ff 75 0c             	pushl  0xc(%ebp)
  800aea:	53                   	push   %ebx
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	ff d0                	call   *%eax
  800af0:	83 c4 10             	add    $0x10,%esp
			break;
  800af3:	eb 23                	jmp    800b18 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800af5:	83 ec 08             	sub    $0x8,%esp
  800af8:	ff 75 0c             	pushl  0xc(%ebp)
  800afb:	6a 25                	push   $0x25
  800afd:	8b 45 08             	mov    0x8(%ebp),%eax
  800b00:	ff d0                	call   *%eax
  800b02:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b05:	ff 4d 10             	decl   0x10(%ebp)
  800b08:	eb 03                	jmp    800b0d <vprintfmt+0x3b1>
  800b0a:	ff 4d 10             	decl   0x10(%ebp)
  800b0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800b10:	48                   	dec    %eax
  800b11:	8a 00                	mov    (%eax),%al
  800b13:	3c 25                	cmp    $0x25,%al
  800b15:	75 f3                	jne    800b0a <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b17:	90                   	nop
		}
	}
  800b18:	e9 47 fc ff ff       	jmp    800764 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b1d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b1e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b21:	5b                   	pop    %ebx
  800b22:	5e                   	pop    %esi
  800b23:	5d                   	pop    %ebp
  800b24:	c3                   	ret    

00800b25 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b25:	55                   	push   %ebp
  800b26:	89 e5                	mov    %esp,%ebp
  800b28:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b2b:	8d 45 10             	lea    0x10(%ebp),%eax
  800b2e:	83 c0 04             	add    $0x4,%eax
  800b31:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b34:	8b 45 10             	mov    0x10(%ebp),%eax
  800b37:	ff 75 f4             	pushl  -0xc(%ebp)
  800b3a:	50                   	push   %eax
  800b3b:	ff 75 0c             	pushl  0xc(%ebp)
  800b3e:	ff 75 08             	pushl  0x8(%ebp)
  800b41:	e8 16 fc ff ff       	call   80075c <vprintfmt>
  800b46:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b49:	90                   	nop
  800b4a:	c9                   	leave  
  800b4b:	c3                   	ret    

00800b4c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b52:	8b 40 08             	mov    0x8(%eax),%eax
  800b55:	8d 50 01             	lea    0x1(%eax),%edx
  800b58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b61:	8b 10                	mov    (%eax),%edx
  800b63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b66:	8b 40 04             	mov    0x4(%eax),%eax
  800b69:	39 c2                	cmp    %eax,%edx
  800b6b:	73 12                	jae    800b7f <sprintputch+0x33>
		*b->buf++ = ch;
  800b6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b70:	8b 00                	mov    (%eax),%eax
  800b72:	8d 48 01             	lea    0x1(%eax),%ecx
  800b75:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b78:	89 0a                	mov    %ecx,(%edx)
  800b7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800b7d:	88 10                	mov    %dl,(%eax)
}
  800b7f:	90                   	nop
  800b80:	5d                   	pop    %ebp
  800b81:	c3                   	ret    

00800b82 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b82:	55                   	push   %ebp
  800b83:	89 e5                	mov    %esp,%ebp
  800b85:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b91:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b94:	8b 45 08             	mov    0x8(%ebp),%eax
  800b97:	01 d0                	add    %edx,%eax
  800b99:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b9c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ba3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ba7:	74 06                	je     800baf <vsnprintf+0x2d>
  800ba9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bad:	7f 07                	jg     800bb6 <vsnprintf+0x34>
		return -E_INVAL;
  800baf:	b8 03 00 00 00       	mov    $0x3,%eax
  800bb4:	eb 20                	jmp    800bd6 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bb6:	ff 75 14             	pushl  0x14(%ebp)
  800bb9:	ff 75 10             	pushl  0x10(%ebp)
  800bbc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bbf:	50                   	push   %eax
  800bc0:	68 4c 0b 80 00       	push   $0x800b4c
  800bc5:	e8 92 fb ff ff       	call   80075c <vprintfmt>
  800bca:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bcd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bd0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bd6:	c9                   	leave  
  800bd7:	c3                   	ret    

00800bd8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bd8:	55                   	push   %ebp
  800bd9:	89 e5                	mov    %esp,%ebp
  800bdb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bde:	8d 45 10             	lea    0x10(%ebp),%eax
  800be1:	83 c0 04             	add    $0x4,%eax
  800be4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800be7:	8b 45 10             	mov    0x10(%ebp),%eax
  800bea:	ff 75 f4             	pushl  -0xc(%ebp)
  800bed:	50                   	push   %eax
  800bee:	ff 75 0c             	pushl  0xc(%ebp)
  800bf1:	ff 75 08             	pushl  0x8(%ebp)
  800bf4:	e8 89 ff ff ff       	call   800b82 <vsnprintf>
  800bf9:	83 c4 10             	add    $0x10,%esp
  800bfc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c02:	c9                   	leave  
  800c03:	c3                   	ret    

00800c04 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
  800c07:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c0a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c11:	eb 06                	jmp    800c19 <strlen+0x15>
		n++;
  800c13:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c16:	ff 45 08             	incl   0x8(%ebp)
  800c19:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1c:	8a 00                	mov    (%eax),%al
  800c1e:	84 c0                	test   %al,%al
  800c20:	75 f1                	jne    800c13 <strlen+0xf>
		n++;
	return n;
  800c22:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c25:	c9                   	leave  
  800c26:	c3                   	ret    

00800c27 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c27:	55                   	push   %ebp
  800c28:	89 e5                	mov    %esp,%ebp
  800c2a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c2d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c34:	eb 09                	jmp    800c3f <strnlen+0x18>
		n++;
  800c36:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c39:	ff 45 08             	incl   0x8(%ebp)
  800c3c:	ff 4d 0c             	decl   0xc(%ebp)
  800c3f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c43:	74 09                	je     800c4e <strnlen+0x27>
  800c45:	8b 45 08             	mov    0x8(%ebp),%eax
  800c48:	8a 00                	mov    (%eax),%al
  800c4a:	84 c0                	test   %al,%al
  800c4c:	75 e8                	jne    800c36 <strnlen+0xf>
		n++;
	return n;
  800c4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c51:	c9                   	leave  
  800c52:	c3                   	ret    

00800c53 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c5f:	90                   	nop
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	8d 50 01             	lea    0x1(%eax),%edx
  800c66:	89 55 08             	mov    %edx,0x8(%ebp)
  800c69:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c6f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c72:	8a 12                	mov    (%edx),%dl
  800c74:	88 10                	mov    %dl,(%eax)
  800c76:	8a 00                	mov    (%eax),%al
  800c78:	84 c0                	test   %al,%al
  800c7a:	75 e4                	jne    800c60 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c7f:	c9                   	leave  
  800c80:	c3                   	ret    

00800c81 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c81:	55                   	push   %ebp
  800c82:	89 e5                	mov    %esp,%ebp
  800c84:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c87:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c8d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c94:	eb 1f                	jmp    800cb5 <strncpy+0x34>
		*dst++ = *src;
  800c96:	8b 45 08             	mov    0x8(%ebp),%eax
  800c99:	8d 50 01             	lea    0x1(%eax),%edx
  800c9c:	89 55 08             	mov    %edx,0x8(%ebp)
  800c9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca2:	8a 12                	mov    (%edx),%dl
  800ca4:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ca6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca9:	8a 00                	mov    (%eax),%al
  800cab:	84 c0                	test   %al,%al
  800cad:	74 03                	je     800cb2 <strncpy+0x31>
			src++;
  800caf:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cb2:	ff 45 fc             	incl   -0x4(%ebp)
  800cb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cb8:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cbb:	72 d9                	jb     800c96 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cbd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cc0:	c9                   	leave  
  800cc1:	c3                   	ret    

00800cc2 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cc2:	55                   	push   %ebp
  800cc3:	89 e5                	mov    %esp,%ebp
  800cc5:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd2:	74 30                	je     800d04 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cd4:	eb 16                	jmp    800cec <strlcpy+0x2a>
			*dst++ = *src++;
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd9:	8d 50 01             	lea    0x1(%eax),%edx
  800cdc:	89 55 08             	mov    %edx,0x8(%ebp)
  800cdf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ce5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ce8:	8a 12                	mov    (%edx),%dl
  800cea:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cec:	ff 4d 10             	decl   0x10(%ebp)
  800cef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf3:	74 09                	je     800cfe <strlcpy+0x3c>
  800cf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf8:	8a 00                	mov    (%eax),%al
  800cfa:	84 c0                	test   %al,%al
  800cfc:	75 d8                	jne    800cd6 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800d01:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d04:	8b 55 08             	mov    0x8(%ebp),%edx
  800d07:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d0a:	29 c2                	sub    %eax,%edx
  800d0c:	89 d0                	mov    %edx,%eax
}
  800d0e:	c9                   	leave  
  800d0f:	c3                   	ret    

00800d10 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d10:	55                   	push   %ebp
  800d11:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d13:	eb 06                	jmp    800d1b <strcmp+0xb>
		p++, q++;
  800d15:	ff 45 08             	incl   0x8(%ebp)
  800d18:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1e:	8a 00                	mov    (%eax),%al
  800d20:	84 c0                	test   %al,%al
  800d22:	74 0e                	je     800d32 <strcmp+0x22>
  800d24:	8b 45 08             	mov    0x8(%ebp),%eax
  800d27:	8a 10                	mov    (%eax),%dl
  800d29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2c:	8a 00                	mov    (%eax),%al
  800d2e:	38 c2                	cmp    %al,%dl
  800d30:	74 e3                	je     800d15 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d32:	8b 45 08             	mov    0x8(%ebp),%eax
  800d35:	8a 00                	mov    (%eax),%al
  800d37:	0f b6 d0             	movzbl %al,%edx
  800d3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3d:	8a 00                	mov    (%eax),%al
  800d3f:	0f b6 c0             	movzbl %al,%eax
  800d42:	29 c2                	sub    %eax,%edx
  800d44:	89 d0                	mov    %edx,%eax
}
  800d46:	5d                   	pop    %ebp
  800d47:	c3                   	ret    

00800d48 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d48:	55                   	push   %ebp
  800d49:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d4b:	eb 09                	jmp    800d56 <strncmp+0xe>
		n--, p++, q++;
  800d4d:	ff 4d 10             	decl   0x10(%ebp)
  800d50:	ff 45 08             	incl   0x8(%ebp)
  800d53:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d56:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5a:	74 17                	je     800d73 <strncmp+0x2b>
  800d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5f:	8a 00                	mov    (%eax),%al
  800d61:	84 c0                	test   %al,%al
  800d63:	74 0e                	je     800d73 <strncmp+0x2b>
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	8a 10                	mov    (%eax),%dl
  800d6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6d:	8a 00                	mov    (%eax),%al
  800d6f:	38 c2                	cmp    %al,%dl
  800d71:	74 da                	je     800d4d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d73:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d77:	75 07                	jne    800d80 <strncmp+0x38>
		return 0;
  800d79:	b8 00 00 00 00       	mov    $0x0,%eax
  800d7e:	eb 14                	jmp    800d94 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8a 00                	mov    (%eax),%al
  800d85:	0f b6 d0             	movzbl %al,%edx
  800d88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8b:	8a 00                	mov    (%eax),%al
  800d8d:	0f b6 c0             	movzbl %al,%eax
  800d90:	29 c2                	sub    %eax,%edx
  800d92:	89 d0                	mov    %edx,%eax
}
  800d94:	5d                   	pop    %ebp
  800d95:	c3                   	ret    

00800d96 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d96:	55                   	push   %ebp
  800d97:	89 e5                	mov    %esp,%ebp
  800d99:	83 ec 04             	sub    $0x4,%esp
  800d9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800da2:	eb 12                	jmp    800db6 <strchr+0x20>
		if (*s == c)
  800da4:	8b 45 08             	mov    0x8(%ebp),%eax
  800da7:	8a 00                	mov    (%eax),%al
  800da9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dac:	75 05                	jne    800db3 <strchr+0x1d>
			return (char *) s;
  800dae:	8b 45 08             	mov    0x8(%ebp),%eax
  800db1:	eb 11                	jmp    800dc4 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800db3:	ff 45 08             	incl   0x8(%ebp)
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	8a 00                	mov    (%eax),%al
  800dbb:	84 c0                	test   %al,%al
  800dbd:	75 e5                	jne    800da4 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800dbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dc4:	c9                   	leave  
  800dc5:	c3                   	ret    

00800dc6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dc6:	55                   	push   %ebp
  800dc7:	89 e5                	mov    %esp,%ebp
  800dc9:	83 ec 04             	sub    $0x4,%esp
  800dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcf:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dd2:	eb 0d                	jmp    800de1 <strfind+0x1b>
		if (*s == c)
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	8a 00                	mov    (%eax),%al
  800dd9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ddc:	74 0e                	je     800dec <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dde:	ff 45 08             	incl   0x8(%ebp)
  800de1:	8b 45 08             	mov    0x8(%ebp),%eax
  800de4:	8a 00                	mov    (%eax),%al
  800de6:	84 c0                	test   %al,%al
  800de8:	75 ea                	jne    800dd4 <strfind+0xe>
  800dea:	eb 01                	jmp    800ded <strfind+0x27>
		if (*s == c)
			break;
  800dec:	90                   	nop
	return (char *) s;
  800ded:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800df0:	c9                   	leave  
  800df1:	c3                   	ret    

00800df2 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800df2:	55                   	push   %ebp
  800df3:	89 e5                	mov    %esp,%ebp
  800df5:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800dfe:	8b 45 10             	mov    0x10(%ebp),%eax
  800e01:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e04:	eb 0e                	jmp    800e14 <memset+0x22>
		*p++ = c;
  800e06:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e09:	8d 50 01             	lea    0x1(%eax),%edx
  800e0c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e12:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e14:	ff 4d f8             	decl   -0x8(%ebp)
  800e17:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e1b:	79 e9                	jns    800e06 <memset+0x14>
		*p++ = c;

	return v;
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e20:	c9                   	leave  
  800e21:	c3                   	ret    

00800e22 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e22:	55                   	push   %ebp
  800e23:	89 e5                	mov    %esp,%ebp
  800e25:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e31:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e34:	eb 16                	jmp    800e4c <memcpy+0x2a>
		*d++ = *s++;
  800e36:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e39:	8d 50 01             	lea    0x1(%eax),%edx
  800e3c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e3f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e42:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e45:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e48:	8a 12                	mov    (%edx),%dl
  800e4a:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e4c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e52:	89 55 10             	mov    %edx,0x10(%ebp)
  800e55:	85 c0                	test   %eax,%eax
  800e57:	75 dd                	jne    800e36 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e5c:	c9                   	leave  
  800e5d:	c3                   	ret    

00800e5e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e5e:	55                   	push   %ebp
  800e5f:	89 e5                	mov    %esp,%ebp
  800e61:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e67:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e70:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e73:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e76:	73 50                	jae    800ec8 <memmove+0x6a>
  800e78:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7e:	01 d0                	add    %edx,%eax
  800e80:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e83:	76 43                	jbe    800ec8 <memmove+0x6a>
		s += n;
  800e85:	8b 45 10             	mov    0x10(%ebp),%eax
  800e88:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e91:	eb 10                	jmp    800ea3 <memmove+0x45>
			*--d = *--s;
  800e93:	ff 4d f8             	decl   -0x8(%ebp)
  800e96:	ff 4d fc             	decl   -0x4(%ebp)
  800e99:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e9c:	8a 10                	mov    (%eax),%dl
  800e9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea1:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ea3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ea9:	89 55 10             	mov    %edx,0x10(%ebp)
  800eac:	85 c0                	test   %eax,%eax
  800eae:	75 e3                	jne    800e93 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800eb0:	eb 23                	jmp    800ed5 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800eb2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb5:	8d 50 01             	lea    0x1(%eax),%edx
  800eb8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ebb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ebe:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ec1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ec4:	8a 12                	mov    (%edx),%dl
  800ec6:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ec8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ece:	89 55 10             	mov    %edx,0x10(%ebp)
  800ed1:	85 c0                	test   %eax,%eax
  800ed3:	75 dd                	jne    800eb2 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ed8:	c9                   	leave  
  800ed9:	c3                   	ret    

00800eda <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800eda:	55                   	push   %ebp
  800edb:	89 e5                	mov    %esp,%ebp
  800edd:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ee6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee9:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800eec:	eb 2a                	jmp    800f18 <memcmp+0x3e>
		if (*s1 != *s2)
  800eee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef1:	8a 10                	mov    (%eax),%dl
  800ef3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef6:	8a 00                	mov    (%eax),%al
  800ef8:	38 c2                	cmp    %al,%dl
  800efa:	74 16                	je     800f12 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800efc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eff:	8a 00                	mov    (%eax),%al
  800f01:	0f b6 d0             	movzbl %al,%edx
  800f04:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f07:	8a 00                	mov    (%eax),%al
  800f09:	0f b6 c0             	movzbl %al,%eax
  800f0c:	29 c2                	sub    %eax,%edx
  800f0e:	89 d0                	mov    %edx,%eax
  800f10:	eb 18                	jmp    800f2a <memcmp+0x50>
		s1++, s2++;
  800f12:	ff 45 fc             	incl   -0x4(%ebp)
  800f15:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f18:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f1e:	89 55 10             	mov    %edx,0x10(%ebp)
  800f21:	85 c0                	test   %eax,%eax
  800f23:	75 c9                	jne    800eee <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f2a:	c9                   	leave  
  800f2b:	c3                   	ret    

00800f2c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f2c:	55                   	push   %ebp
  800f2d:	89 e5                	mov    %esp,%ebp
  800f2f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f32:	8b 55 08             	mov    0x8(%ebp),%edx
  800f35:	8b 45 10             	mov    0x10(%ebp),%eax
  800f38:	01 d0                	add    %edx,%eax
  800f3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f3d:	eb 15                	jmp    800f54 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	8a 00                	mov    (%eax),%al
  800f44:	0f b6 d0             	movzbl %al,%edx
  800f47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4a:	0f b6 c0             	movzbl %al,%eax
  800f4d:	39 c2                	cmp    %eax,%edx
  800f4f:	74 0d                	je     800f5e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f51:	ff 45 08             	incl   0x8(%ebp)
  800f54:	8b 45 08             	mov    0x8(%ebp),%eax
  800f57:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f5a:	72 e3                	jb     800f3f <memfind+0x13>
  800f5c:	eb 01                	jmp    800f5f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f5e:	90                   	nop
	return (void *) s;
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f62:	c9                   	leave  
  800f63:	c3                   	ret    

00800f64 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f64:	55                   	push   %ebp
  800f65:	89 e5                	mov    %esp,%ebp
  800f67:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f6a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f71:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f78:	eb 03                	jmp    800f7d <strtol+0x19>
		s++;
  800f7a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f80:	8a 00                	mov    (%eax),%al
  800f82:	3c 20                	cmp    $0x20,%al
  800f84:	74 f4                	je     800f7a <strtol+0x16>
  800f86:	8b 45 08             	mov    0x8(%ebp),%eax
  800f89:	8a 00                	mov    (%eax),%al
  800f8b:	3c 09                	cmp    $0x9,%al
  800f8d:	74 eb                	je     800f7a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	8a 00                	mov    (%eax),%al
  800f94:	3c 2b                	cmp    $0x2b,%al
  800f96:	75 05                	jne    800f9d <strtol+0x39>
		s++;
  800f98:	ff 45 08             	incl   0x8(%ebp)
  800f9b:	eb 13                	jmp    800fb0 <strtol+0x4c>
	else if (*s == '-')
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa0:	8a 00                	mov    (%eax),%al
  800fa2:	3c 2d                	cmp    $0x2d,%al
  800fa4:	75 0a                	jne    800fb0 <strtol+0x4c>
		s++, neg = 1;
  800fa6:	ff 45 08             	incl   0x8(%ebp)
  800fa9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fb0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb4:	74 06                	je     800fbc <strtol+0x58>
  800fb6:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fba:	75 20                	jne    800fdc <strtol+0x78>
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbf:	8a 00                	mov    (%eax),%al
  800fc1:	3c 30                	cmp    $0x30,%al
  800fc3:	75 17                	jne    800fdc <strtol+0x78>
  800fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc8:	40                   	inc    %eax
  800fc9:	8a 00                	mov    (%eax),%al
  800fcb:	3c 78                	cmp    $0x78,%al
  800fcd:	75 0d                	jne    800fdc <strtol+0x78>
		s += 2, base = 16;
  800fcf:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fd3:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fda:	eb 28                	jmp    801004 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fdc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fe0:	75 15                	jne    800ff7 <strtol+0x93>
  800fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe5:	8a 00                	mov    (%eax),%al
  800fe7:	3c 30                	cmp    $0x30,%al
  800fe9:	75 0c                	jne    800ff7 <strtol+0x93>
		s++, base = 8;
  800feb:	ff 45 08             	incl   0x8(%ebp)
  800fee:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ff5:	eb 0d                	jmp    801004 <strtol+0xa0>
	else if (base == 0)
  800ff7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ffb:	75 07                	jne    801004 <strtol+0xa0>
		base = 10;
  800ffd:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801004:	8b 45 08             	mov    0x8(%ebp),%eax
  801007:	8a 00                	mov    (%eax),%al
  801009:	3c 2f                	cmp    $0x2f,%al
  80100b:	7e 19                	jle    801026 <strtol+0xc2>
  80100d:	8b 45 08             	mov    0x8(%ebp),%eax
  801010:	8a 00                	mov    (%eax),%al
  801012:	3c 39                	cmp    $0x39,%al
  801014:	7f 10                	jg     801026 <strtol+0xc2>
			dig = *s - '0';
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
  801019:	8a 00                	mov    (%eax),%al
  80101b:	0f be c0             	movsbl %al,%eax
  80101e:	83 e8 30             	sub    $0x30,%eax
  801021:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801024:	eb 42                	jmp    801068 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	8a 00                	mov    (%eax),%al
  80102b:	3c 60                	cmp    $0x60,%al
  80102d:	7e 19                	jle    801048 <strtol+0xe4>
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	8a 00                	mov    (%eax),%al
  801034:	3c 7a                	cmp    $0x7a,%al
  801036:	7f 10                	jg     801048 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	8a 00                	mov    (%eax),%al
  80103d:	0f be c0             	movsbl %al,%eax
  801040:	83 e8 57             	sub    $0x57,%eax
  801043:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801046:	eb 20                	jmp    801068 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
  80104b:	8a 00                	mov    (%eax),%al
  80104d:	3c 40                	cmp    $0x40,%al
  80104f:	7e 39                	jle    80108a <strtol+0x126>
  801051:	8b 45 08             	mov    0x8(%ebp),%eax
  801054:	8a 00                	mov    (%eax),%al
  801056:	3c 5a                	cmp    $0x5a,%al
  801058:	7f 30                	jg     80108a <strtol+0x126>
			dig = *s - 'A' + 10;
  80105a:	8b 45 08             	mov    0x8(%ebp),%eax
  80105d:	8a 00                	mov    (%eax),%al
  80105f:	0f be c0             	movsbl %al,%eax
  801062:	83 e8 37             	sub    $0x37,%eax
  801065:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801068:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80106b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80106e:	7d 19                	jge    801089 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801070:	ff 45 08             	incl   0x8(%ebp)
  801073:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801076:	0f af 45 10          	imul   0x10(%ebp),%eax
  80107a:	89 c2                	mov    %eax,%edx
  80107c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80107f:	01 d0                	add    %edx,%eax
  801081:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801084:	e9 7b ff ff ff       	jmp    801004 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801089:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80108a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80108e:	74 08                	je     801098 <strtol+0x134>
		*endptr = (char *) s;
  801090:	8b 45 0c             	mov    0xc(%ebp),%eax
  801093:	8b 55 08             	mov    0x8(%ebp),%edx
  801096:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801098:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80109c:	74 07                	je     8010a5 <strtol+0x141>
  80109e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a1:	f7 d8                	neg    %eax
  8010a3:	eb 03                	jmp    8010a8 <strtol+0x144>
  8010a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010a8:	c9                   	leave  
  8010a9:	c3                   	ret    

008010aa <ltostr>:

void
ltostr(long value, char *str)
{
  8010aa:	55                   	push   %ebp
  8010ab:	89 e5                	mov    %esp,%ebp
  8010ad:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010b7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010c2:	79 13                	jns    8010d7 <ltostr+0x2d>
	{
		neg = 1;
  8010c4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ce:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010d1:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010d4:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010df:	99                   	cltd   
  8010e0:	f7 f9                	idiv   %ecx
  8010e2:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e8:	8d 50 01             	lea    0x1(%eax),%edx
  8010eb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010ee:	89 c2                	mov    %eax,%edx
  8010f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f3:	01 d0                	add    %edx,%eax
  8010f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010f8:	83 c2 30             	add    $0x30,%edx
  8010fb:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801100:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801105:	f7 e9                	imul   %ecx
  801107:	c1 fa 02             	sar    $0x2,%edx
  80110a:	89 c8                	mov    %ecx,%eax
  80110c:	c1 f8 1f             	sar    $0x1f,%eax
  80110f:	29 c2                	sub    %eax,%edx
  801111:	89 d0                	mov    %edx,%eax
  801113:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801116:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801119:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80111e:	f7 e9                	imul   %ecx
  801120:	c1 fa 02             	sar    $0x2,%edx
  801123:	89 c8                	mov    %ecx,%eax
  801125:	c1 f8 1f             	sar    $0x1f,%eax
  801128:	29 c2                	sub    %eax,%edx
  80112a:	89 d0                	mov    %edx,%eax
  80112c:	c1 e0 02             	shl    $0x2,%eax
  80112f:	01 d0                	add    %edx,%eax
  801131:	01 c0                	add    %eax,%eax
  801133:	29 c1                	sub    %eax,%ecx
  801135:	89 ca                	mov    %ecx,%edx
  801137:	85 d2                	test   %edx,%edx
  801139:	75 9c                	jne    8010d7 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80113b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801142:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801145:	48                   	dec    %eax
  801146:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801149:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80114d:	74 3d                	je     80118c <ltostr+0xe2>
		start = 1 ;
  80114f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801156:	eb 34                	jmp    80118c <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801158:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80115b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115e:	01 d0                	add    %edx,%eax
  801160:	8a 00                	mov    (%eax),%al
  801162:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801165:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801168:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116b:	01 c2                	add    %eax,%edx
  80116d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801170:	8b 45 0c             	mov    0xc(%ebp),%eax
  801173:	01 c8                	add    %ecx,%eax
  801175:	8a 00                	mov    (%eax),%al
  801177:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801179:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80117c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117f:	01 c2                	add    %eax,%edx
  801181:	8a 45 eb             	mov    -0x15(%ebp),%al
  801184:	88 02                	mov    %al,(%edx)
		start++ ;
  801186:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801189:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80118c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80118f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801192:	7c c4                	jl     801158 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801194:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119a:	01 d0                	add    %edx,%eax
  80119c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80119f:	90                   	nop
  8011a0:	c9                   	leave  
  8011a1:	c3                   	ret    

008011a2 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011a2:	55                   	push   %ebp
  8011a3:	89 e5                	mov    %esp,%ebp
  8011a5:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011a8:	ff 75 08             	pushl  0x8(%ebp)
  8011ab:	e8 54 fa ff ff       	call   800c04 <strlen>
  8011b0:	83 c4 04             	add    $0x4,%esp
  8011b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011b6:	ff 75 0c             	pushl  0xc(%ebp)
  8011b9:	e8 46 fa ff ff       	call   800c04 <strlen>
  8011be:	83 c4 04             	add    $0x4,%esp
  8011c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011d2:	eb 17                	jmp    8011eb <strcconcat+0x49>
		final[s] = str1[s] ;
  8011d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011da:	01 c2                	add    %eax,%edx
  8011dc:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011df:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e2:	01 c8                	add    %ecx,%eax
  8011e4:	8a 00                	mov    (%eax),%al
  8011e6:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011e8:	ff 45 fc             	incl   -0x4(%ebp)
  8011eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ee:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011f1:	7c e1                	jl     8011d4 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011f3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011fa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801201:	eb 1f                	jmp    801222 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801203:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801206:	8d 50 01             	lea    0x1(%eax),%edx
  801209:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80120c:	89 c2                	mov    %eax,%edx
  80120e:	8b 45 10             	mov    0x10(%ebp),%eax
  801211:	01 c2                	add    %eax,%edx
  801213:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801216:	8b 45 0c             	mov    0xc(%ebp),%eax
  801219:	01 c8                	add    %ecx,%eax
  80121b:	8a 00                	mov    (%eax),%al
  80121d:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80121f:	ff 45 f8             	incl   -0x8(%ebp)
  801222:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801225:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801228:	7c d9                	jl     801203 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80122a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80122d:	8b 45 10             	mov    0x10(%ebp),%eax
  801230:	01 d0                	add    %edx,%eax
  801232:	c6 00 00             	movb   $0x0,(%eax)
}
  801235:	90                   	nop
  801236:	c9                   	leave  
  801237:	c3                   	ret    

00801238 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801238:	55                   	push   %ebp
  801239:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80123b:	8b 45 14             	mov    0x14(%ebp),%eax
  80123e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801244:	8b 45 14             	mov    0x14(%ebp),%eax
  801247:	8b 00                	mov    (%eax),%eax
  801249:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801250:	8b 45 10             	mov    0x10(%ebp),%eax
  801253:	01 d0                	add    %edx,%eax
  801255:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80125b:	eb 0c                	jmp    801269 <strsplit+0x31>
			*string++ = 0;
  80125d:	8b 45 08             	mov    0x8(%ebp),%eax
  801260:	8d 50 01             	lea    0x1(%eax),%edx
  801263:	89 55 08             	mov    %edx,0x8(%ebp)
  801266:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801269:	8b 45 08             	mov    0x8(%ebp),%eax
  80126c:	8a 00                	mov    (%eax),%al
  80126e:	84 c0                	test   %al,%al
  801270:	74 18                	je     80128a <strsplit+0x52>
  801272:	8b 45 08             	mov    0x8(%ebp),%eax
  801275:	8a 00                	mov    (%eax),%al
  801277:	0f be c0             	movsbl %al,%eax
  80127a:	50                   	push   %eax
  80127b:	ff 75 0c             	pushl  0xc(%ebp)
  80127e:	e8 13 fb ff ff       	call   800d96 <strchr>
  801283:	83 c4 08             	add    $0x8,%esp
  801286:	85 c0                	test   %eax,%eax
  801288:	75 d3                	jne    80125d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80128a:	8b 45 08             	mov    0x8(%ebp),%eax
  80128d:	8a 00                	mov    (%eax),%al
  80128f:	84 c0                	test   %al,%al
  801291:	74 5a                	je     8012ed <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801293:	8b 45 14             	mov    0x14(%ebp),%eax
  801296:	8b 00                	mov    (%eax),%eax
  801298:	83 f8 0f             	cmp    $0xf,%eax
  80129b:	75 07                	jne    8012a4 <strsplit+0x6c>
		{
			return 0;
  80129d:	b8 00 00 00 00       	mov    $0x0,%eax
  8012a2:	eb 66                	jmp    80130a <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a7:	8b 00                	mov    (%eax),%eax
  8012a9:	8d 48 01             	lea    0x1(%eax),%ecx
  8012ac:	8b 55 14             	mov    0x14(%ebp),%edx
  8012af:	89 0a                	mov    %ecx,(%edx)
  8012b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012bb:	01 c2                	add    %eax,%edx
  8012bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c0:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012c2:	eb 03                	jmp    8012c7 <strsplit+0x8f>
			string++;
  8012c4:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ca:	8a 00                	mov    (%eax),%al
  8012cc:	84 c0                	test   %al,%al
  8012ce:	74 8b                	je     80125b <strsplit+0x23>
  8012d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d3:	8a 00                	mov    (%eax),%al
  8012d5:	0f be c0             	movsbl %al,%eax
  8012d8:	50                   	push   %eax
  8012d9:	ff 75 0c             	pushl  0xc(%ebp)
  8012dc:	e8 b5 fa ff ff       	call   800d96 <strchr>
  8012e1:	83 c4 08             	add    $0x8,%esp
  8012e4:	85 c0                	test   %eax,%eax
  8012e6:	74 dc                	je     8012c4 <strsplit+0x8c>
			string++;
	}
  8012e8:	e9 6e ff ff ff       	jmp    80125b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012ed:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f1:	8b 00                	mov    (%eax),%eax
  8012f3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8012fd:	01 d0                	add    %edx,%eax
  8012ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801305:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80130a:	c9                   	leave  
  80130b:	c3                   	ret    

0080130c <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80130c:	55                   	push   %ebp
  80130d:	89 e5                	mov    %esp,%ebp
  80130f:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801312:	a1 04 40 80 00       	mov    0x804004,%eax
  801317:	85 c0                	test   %eax,%eax
  801319:	74 1f                	je     80133a <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80131b:	e8 1d 00 00 00       	call   80133d <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801320:	83 ec 0c             	sub    $0xc,%esp
  801323:	68 90 3a 80 00       	push   $0x803a90
  801328:	e8 55 f2 ff ff       	call   800582 <cprintf>
  80132d:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801330:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801337:	00 00 00 
	}
}
  80133a:	90                   	nop
  80133b:	c9                   	leave  
  80133c:	c3                   	ret    

0080133d <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80133d:	55                   	push   %ebp
  80133e:	89 e5                	mov    %esp,%ebp
  801340:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  801343:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80134a:	00 00 00 
  80134d:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801354:	00 00 00 
  801357:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80135e:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  801361:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801368:	00 00 00 
  80136b:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801372:	00 00 00 
  801375:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80137c:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  80137f:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801386:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801389:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80138e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801393:	a3 50 40 80 00       	mov    %eax,0x804050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801398:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80139f:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  8013a2:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8013a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013ac:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  8013b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8013b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8013bc:	f7 75 f0             	divl   -0x10(%ebp)
  8013bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013c2:	29 d0                	sub    %edx,%eax
  8013c4:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  8013c7:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8013ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013d1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013d6:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013db:	83 ec 04             	sub    $0x4,%esp
  8013de:	6a 06                	push   $0x6
  8013e0:	ff 75 e8             	pushl  -0x18(%ebp)
  8013e3:	50                   	push   %eax
  8013e4:	e8 d4 05 00 00       	call   8019bd <sys_allocate_chunk>
  8013e9:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013ec:	a1 20 41 80 00       	mov    0x804120,%eax
  8013f1:	83 ec 0c             	sub    $0xc,%esp
  8013f4:	50                   	push   %eax
  8013f5:	e8 49 0c 00 00       	call   802043 <initialize_MemBlocksList>
  8013fa:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  8013fd:	a1 48 41 80 00       	mov    0x804148,%eax
  801402:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  801405:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801409:	75 14                	jne    80141f <initialize_dyn_block_system+0xe2>
  80140b:	83 ec 04             	sub    $0x4,%esp
  80140e:	68 b5 3a 80 00       	push   $0x803ab5
  801413:	6a 39                	push   $0x39
  801415:	68 d3 3a 80 00       	push   $0x803ad3
  80141a:	e8 af ee ff ff       	call   8002ce <_panic>
  80141f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801422:	8b 00                	mov    (%eax),%eax
  801424:	85 c0                	test   %eax,%eax
  801426:	74 10                	je     801438 <initialize_dyn_block_system+0xfb>
  801428:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80142b:	8b 00                	mov    (%eax),%eax
  80142d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801430:	8b 52 04             	mov    0x4(%edx),%edx
  801433:	89 50 04             	mov    %edx,0x4(%eax)
  801436:	eb 0b                	jmp    801443 <initialize_dyn_block_system+0x106>
  801438:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80143b:	8b 40 04             	mov    0x4(%eax),%eax
  80143e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801443:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801446:	8b 40 04             	mov    0x4(%eax),%eax
  801449:	85 c0                	test   %eax,%eax
  80144b:	74 0f                	je     80145c <initialize_dyn_block_system+0x11f>
  80144d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801450:	8b 40 04             	mov    0x4(%eax),%eax
  801453:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801456:	8b 12                	mov    (%edx),%edx
  801458:	89 10                	mov    %edx,(%eax)
  80145a:	eb 0a                	jmp    801466 <initialize_dyn_block_system+0x129>
  80145c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80145f:	8b 00                	mov    (%eax),%eax
  801461:	a3 48 41 80 00       	mov    %eax,0x804148
  801466:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801469:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80146f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801472:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801479:	a1 54 41 80 00       	mov    0x804154,%eax
  80147e:	48                   	dec    %eax
  80147f:	a3 54 41 80 00       	mov    %eax,0x804154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  801484:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801487:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  80148e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801491:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  801498:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80149c:	75 14                	jne    8014b2 <initialize_dyn_block_system+0x175>
  80149e:	83 ec 04             	sub    $0x4,%esp
  8014a1:	68 e0 3a 80 00       	push   $0x803ae0
  8014a6:	6a 3f                	push   $0x3f
  8014a8:	68 d3 3a 80 00       	push   $0x803ad3
  8014ad:	e8 1c ee ff ff       	call   8002ce <_panic>
  8014b2:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8014b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014bb:	89 10                	mov    %edx,(%eax)
  8014bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014c0:	8b 00                	mov    (%eax),%eax
  8014c2:	85 c0                	test   %eax,%eax
  8014c4:	74 0d                	je     8014d3 <initialize_dyn_block_system+0x196>
  8014c6:	a1 38 41 80 00       	mov    0x804138,%eax
  8014cb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014ce:	89 50 04             	mov    %edx,0x4(%eax)
  8014d1:	eb 08                	jmp    8014db <initialize_dyn_block_system+0x19e>
  8014d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014d6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8014db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014de:	a3 38 41 80 00       	mov    %eax,0x804138
  8014e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014ed:	a1 44 41 80 00       	mov    0x804144,%eax
  8014f2:	40                   	inc    %eax
  8014f3:	a3 44 41 80 00       	mov    %eax,0x804144

}
  8014f8:	90                   	nop
  8014f9:	c9                   	leave  
  8014fa:	c3                   	ret    

008014fb <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8014fb:	55                   	push   %ebp
  8014fc:	89 e5                	mov    %esp,%ebp
  8014fe:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801501:	e8 06 fe ff ff       	call   80130c <InitializeUHeap>
	if (size == 0) return NULL ;
  801506:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80150a:	75 07                	jne    801513 <malloc+0x18>
  80150c:	b8 00 00 00 00       	mov    $0x0,%eax
  801511:	eb 7d                	jmp    801590 <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  801513:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  80151a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801521:	8b 55 08             	mov    0x8(%ebp),%edx
  801524:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801527:	01 d0                	add    %edx,%eax
  801529:	48                   	dec    %eax
  80152a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80152d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801530:	ba 00 00 00 00       	mov    $0x0,%edx
  801535:	f7 75 f0             	divl   -0x10(%ebp)
  801538:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80153b:	29 d0                	sub    %edx,%eax
  80153d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  801540:	e8 46 08 00 00       	call   801d8b <sys_isUHeapPlacementStrategyFIRSTFIT>
  801545:	83 f8 01             	cmp    $0x1,%eax
  801548:	75 07                	jne    801551 <malloc+0x56>
  80154a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  801551:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  801555:	75 34                	jne    80158b <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  801557:	83 ec 0c             	sub    $0xc,%esp
  80155a:	ff 75 e8             	pushl  -0x18(%ebp)
  80155d:	e8 73 0e 00 00       	call   8023d5 <alloc_block_FF>
  801562:	83 c4 10             	add    $0x10,%esp
  801565:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  801568:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80156c:	74 16                	je     801584 <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  80156e:	83 ec 0c             	sub    $0xc,%esp
  801571:	ff 75 e4             	pushl  -0x1c(%ebp)
  801574:	e8 ff 0b 00 00       	call   802178 <insert_sorted_allocList>
  801579:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  80157c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80157f:	8b 40 08             	mov    0x8(%eax),%eax
  801582:	eb 0c                	jmp    801590 <malloc+0x95>
	             }
	             else
	             	return NULL;
  801584:	b8 00 00 00 00       	mov    $0x0,%eax
  801589:	eb 05                	jmp    801590 <malloc+0x95>
	      	  }
	          else
	               return NULL;
  80158b:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  801590:	c9                   	leave  
  801591:	c3                   	ret    

00801592 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801592:	55                   	push   %ebp
  801593:	89 e5                	mov    %esp,%ebp
  801595:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  801598:	8b 45 08             	mov    0x8(%ebp),%eax
  80159b:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  80159e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015ac:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  8015af:	83 ec 08             	sub    $0x8,%esp
  8015b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8015b5:	68 40 40 80 00       	push   $0x804040
  8015ba:	e8 61 0b 00 00       	call   802120 <find_block>
  8015bf:	83 c4 10             	add    $0x10,%esp
  8015c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  8015c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015c9:	0f 84 a5 00 00 00    	je     801674 <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  8015cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8015d5:	83 ec 08             	sub    $0x8,%esp
  8015d8:	50                   	push   %eax
  8015d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8015dc:	e8 a4 03 00 00       	call   801985 <sys_free_user_mem>
  8015e1:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  8015e4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015e8:	75 17                	jne    801601 <free+0x6f>
  8015ea:	83 ec 04             	sub    $0x4,%esp
  8015ed:	68 b5 3a 80 00       	push   $0x803ab5
  8015f2:	68 87 00 00 00       	push   $0x87
  8015f7:	68 d3 3a 80 00       	push   $0x803ad3
  8015fc:	e8 cd ec ff ff       	call   8002ce <_panic>
  801601:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801604:	8b 00                	mov    (%eax),%eax
  801606:	85 c0                	test   %eax,%eax
  801608:	74 10                	je     80161a <free+0x88>
  80160a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80160d:	8b 00                	mov    (%eax),%eax
  80160f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801612:	8b 52 04             	mov    0x4(%edx),%edx
  801615:	89 50 04             	mov    %edx,0x4(%eax)
  801618:	eb 0b                	jmp    801625 <free+0x93>
  80161a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80161d:	8b 40 04             	mov    0x4(%eax),%eax
  801620:	a3 44 40 80 00       	mov    %eax,0x804044
  801625:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801628:	8b 40 04             	mov    0x4(%eax),%eax
  80162b:	85 c0                	test   %eax,%eax
  80162d:	74 0f                	je     80163e <free+0xac>
  80162f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801632:	8b 40 04             	mov    0x4(%eax),%eax
  801635:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801638:	8b 12                	mov    (%edx),%edx
  80163a:	89 10                	mov    %edx,(%eax)
  80163c:	eb 0a                	jmp    801648 <free+0xb6>
  80163e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801641:	8b 00                	mov    (%eax),%eax
  801643:	a3 40 40 80 00       	mov    %eax,0x804040
  801648:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80164b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801651:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801654:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80165b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801660:	48                   	dec    %eax
  801661:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(theBlock);
  801666:	83 ec 0c             	sub    $0xc,%esp
  801669:	ff 75 ec             	pushl  -0x14(%ebp)
  80166c:	e8 37 12 00 00       	call   8028a8 <insert_sorted_with_merge_freeList>
  801671:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  801674:	90                   	nop
  801675:	c9                   	leave  
  801676:	c3                   	ret    

00801677 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801677:	55                   	push   %ebp
  801678:	89 e5                	mov    %esp,%ebp
  80167a:	83 ec 38             	sub    $0x38,%esp
  80167d:	8b 45 10             	mov    0x10(%ebp),%eax
  801680:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801683:	e8 84 fc ff ff       	call   80130c <InitializeUHeap>
	if (size == 0) return NULL ;
  801688:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80168c:	75 07                	jne    801695 <smalloc+0x1e>
  80168e:	b8 00 00 00 00       	mov    $0x0,%eax
  801693:	eb 7e                	jmp    801713 <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  801695:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  80169c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8016a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a9:	01 d0                	add    %edx,%eax
  8016ab:	48                   	dec    %eax
  8016ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b7:	f7 75 f0             	divl   -0x10(%ebp)
  8016ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016bd:	29 d0                	sub    %edx,%eax
  8016bf:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  8016c2:	e8 c4 06 00 00       	call   801d8b <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016c7:	83 f8 01             	cmp    $0x1,%eax
  8016ca:	75 42                	jne    80170e <smalloc+0x97>

		  va = malloc(newsize) ;
  8016cc:	83 ec 0c             	sub    $0xc,%esp
  8016cf:	ff 75 e8             	pushl  -0x18(%ebp)
  8016d2:	e8 24 fe ff ff       	call   8014fb <malloc>
  8016d7:	83 c4 10             	add    $0x10,%esp
  8016da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  8016dd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8016e1:	74 24                	je     801707 <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  8016e3:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8016e7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8016ea:	50                   	push   %eax
  8016eb:	ff 75 e8             	pushl  -0x18(%ebp)
  8016ee:	ff 75 08             	pushl  0x8(%ebp)
  8016f1:	e8 1a 04 00 00       	call   801b10 <sys_createSharedObject>
  8016f6:	83 c4 10             	add    $0x10,%esp
  8016f9:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  8016fc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801700:	78 0c                	js     80170e <smalloc+0x97>
					  return va ;
  801702:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801705:	eb 0c                	jmp    801713 <smalloc+0x9c>
				 }
				 else
					return NULL;
  801707:	b8 00 00 00 00       	mov    $0x0,%eax
  80170c:	eb 05                	jmp    801713 <smalloc+0x9c>
	  }
		  return NULL ;
  80170e:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801713:	c9                   	leave  
  801714:	c3                   	ret    

00801715 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801715:	55                   	push   %ebp
  801716:	89 e5                	mov    %esp,%ebp
  801718:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80171b:	e8 ec fb ff ff       	call   80130c <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  801720:	83 ec 08             	sub    $0x8,%esp
  801723:	ff 75 0c             	pushl  0xc(%ebp)
  801726:	ff 75 08             	pushl  0x8(%ebp)
  801729:	e8 0c 04 00 00       	call   801b3a <sys_getSizeOfSharedObject>
  80172e:	83 c4 10             	add    $0x10,%esp
  801731:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  801734:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801738:	75 07                	jne    801741 <sget+0x2c>
  80173a:	b8 00 00 00 00       	mov    $0x0,%eax
  80173f:	eb 75                	jmp    8017b6 <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801741:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801748:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80174b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80174e:	01 d0                	add    %edx,%eax
  801750:	48                   	dec    %eax
  801751:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801754:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801757:	ba 00 00 00 00       	mov    $0x0,%edx
  80175c:	f7 75 f0             	divl   -0x10(%ebp)
  80175f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801762:	29 d0                	sub    %edx,%eax
  801764:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  801767:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  80176e:	e8 18 06 00 00       	call   801d8b <sys_isUHeapPlacementStrategyFIRSTFIT>
  801773:	83 f8 01             	cmp    $0x1,%eax
  801776:	75 39                	jne    8017b1 <sget+0x9c>

		  va = malloc(newsize) ;
  801778:	83 ec 0c             	sub    $0xc,%esp
  80177b:	ff 75 e8             	pushl  -0x18(%ebp)
  80177e:	e8 78 fd ff ff       	call   8014fb <malloc>
  801783:	83 c4 10             	add    $0x10,%esp
  801786:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  801789:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80178d:	74 22                	je     8017b1 <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  80178f:	83 ec 04             	sub    $0x4,%esp
  801792:	ff 75 e0             	pushl  -0x20(%ebp)
  801795:	ff 75 0c             	pushl  0xc(%ebp)
  801798:	ff 75 08             	pushl  0x8(%ebp)
  80179b:	e8 b7 03 00 00       	call   801b57 <sys_getSharedObject>
  8017a0:	83 c4 10             	add    $0x10,%esp
  8017a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  8017a6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8017aa:	78 05                	js     8017b1 <sget+0x9c>
					  return va;
  8017ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017af:	eb 05                	jmp    8017b6 <sget+0xa1>
				  }
			  }
     }
         return NULL;
  8017b1:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  8017b6:	c9                   	leave  
  8017b7:	c3                   	ret    

008017b8 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017b8:	55                   	push   %ebp
  8017b9:	89 e5                	mov    %esp,%ebp
  8017bb:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017be:	e8 49 fb ff ff       	call   80130c <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017c3:	83 ec 04             	sub    $0x4,%esp
  8017c6:	68 04 3b 80 00       	push   $0x803b04
  8017cb:	68 1e 01 00 00       	push   $0x11e
  8017d0:	68 d3 3a 80 00       	push   $0x803ad3
  8017d5:	e8 f4 ea ff ff       	call   8002ce <_panic>

008017da <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017da:	55                   	push   %ebp
  8017db:	89 e5                	mov    %esp,%ebp
  8017dd:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017e0:	83 ec 04             	sub    $0x4,%esp
  8017e3:	68 2c 3b 80 00       	push   $0x803b2c
  8017e8:	68 32 01 00 00       	push   $0x132
  8017ed:	68 d3 3a 80 00       	push   $0x803ad3
  8017f2:	e8 d7 ea ff ff       	call   8002ce <_panic>

008017f7 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017f7:	55                   	push   %ebp
  8017f8:	89 e5                	mov    %esp,%ebp
  8017fa:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017fd:	83 ec 04             	sub    $0x4,%esp
  801800:	68 50 3b 80 00       	push   $0x803b50
  801805:	68 3d 01 00 00       	push   $0x13d
  80180a:	68 d3 3a 80 00       	push   $0x803ad3
  80180f:	e8 ba ea ff ff       	call   8002ce <_panic>

00801814 <shrink>:

}
void shrink(uint32 newSize)
{
  801814:	55                   	push   %ebp
  801815:	89 e5                	mov    %esp,%ebp
  801817:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80181a:	83 ec 04             	sub    $0x4,%esp
  80181d:	68 50 3b 80 00       	push   $0x803b50
  801822:	68 42 01 00 00       	push   $0x142
  801827:	68 d3 3a 80 00       	push   $0x803ad3
  80182c:	e8 9d ea ff ff       	call   8002ce <_panic>

00801831 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
  801834:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801837:	83 ec 04             	sub    $0x4,%esp
  80183a:	68 50 3b 80 00       	push   $0x803b50
  80183f:	68 47 01 00 00       	push   $0x147
  801844:	68 d3 3a 80 00       	push   $0x803ad3
  801849:	e8 80 ea ff ff       	call   8002ce <_panic>

0080184e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80184e:	55                   	push   %ebp
  80184f:	89 e5                	mov    %esp,%ebp
  801851:	57                   	push   %edi
  801852:	56                   	push   %esi
  801853:	53                   	push   %ebx
  801854:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801857:	8b 45 08             	mov    0x8(%ebp),%eax
  80185a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80185d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801860:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801863:	8b 7d 18             	mov    0x18(%ebp),%edi
  801866:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801869:	cd 30                	int    $0x30
  80186b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80186e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801871:	83 c4 10             	add    $0x10,%esp
  801874:	5b                   	pop    %ebx
  801875:	5e                   	pop    %esi
  801876:	5f                   	pop    %edi
  801877:	5d                   	pop    %ebp
  801878:	c3                   	ret    

00801879 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
  80187c:	83 ec 04             	sub    $0x4,%esp
  80187f:	8b 45 10             	mov    0x10(%ebp),%eax
  801882:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801885:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801889:	8b 45 08             	mov    0x8(%ebp),%eax
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	52                   	push   %edx
  801891:	ff 75 0c             	pushl  0xc(%ebp)
  801894:	50                   	push   %eax
  801895:	6a 00                	push   $0x0
  801897:	e8 b2 ff ff ff       	call   80184e <syscall>
  80189c:	83 c4 18             	add    $0x18,%esp
}
  80189f:	90                   	nop
  8018a0:	c9                   	leave  
  8018a1:	c3                   	ret    

008018a2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 01                	push   $0x1
  8018b1:	e8 98 ff ff ff       	call   80184e <syscall>
  8018b6:	83 c4 18             	add    $0x18,%esp
}
  8018b9:	c9                   	leave  
  8018ba:	c3                   	ret    

008018bb <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	52                   	push   %edx
  8018cb:	50                   	push   %eax
  8018cc:	6a 05                	push   $0x5
  8018ce:	e8 7b ff ff ff       	call   80184e <syscall>
  8018d3:	83 c4 18             	add    $0x18,%esp
}
  8018d6:	c9                   	leave  
  8018d7:	c3                   	ret    

008018d8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
  8018db:	56                   	push   %esi
  8018dc:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018dd:	8b 75 18             	mov    0x18(%ebp),%esi
  8018e0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ec:	56                   	push   %esi
  8018ed:	53                   	push   %ebx
  8018ee:	51                   	push   %ecx
  8018ef:	52                   	push   %edx
  8018f0:	50                   	push   %eax
  8018f1:	6a 06                	push   $0x6
  8018f3:	e8 56 ff ff ff       	call   80184e <syscall>
  8018f8:	83 c4 18             	add    $0x18,%esp
}
  8018fb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018fe:	5b                   	pop    %ebx
  8018ff:	5e                   	pop    %esi
  801900:	5d                   	pop    %ebp
  801901:	c3                   	ret    

00801902 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801905:	8b 55 0c             	mov    0xc(%ebp),%edx
  801908:	8b 45 08             	mov    0x8(%ebp),%eax
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	52                   	push   %edx
  801912:	50                   	push   %eax
  801913:	6a 07                	push   $0x7
  801915:	e8 34 ff ff ff       	call   80184e <syscall>
  80191a:	83 c4 18             	add    $0x18,%esp
}
  80191d:	c9                   	leave  
  80191e:	c3                   	ret    

0080191f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80191f:	55                   	push   %ebp
  801920:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	ff 75 0c             	pushl  0xc(%ebp)
  80192b:	ff 75 08             	pushl  0x8(%ebp)
  80192e:	6a 08                	push   $0x8
  801930:	e8 19 ff ff ff       	call   80184e <syscall>
  801935:	83 c4 18             	add    $0x18,%esp
}
  801938:	c9                   	leave  
  801939:	c3                   	ret    

0080193a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 09                	push   $0x9
  801949:	e8 00 ff ff ff       	call   80184e <syscall>
  80194e:	83 c4 18             	add    $0x18,%esp
}
  801951:	c9                   	leave  
  801952:	c3                   	ret    

00801953 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801953:	55                   	push   %ebp
  801954:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 0a                	push   $0xa
  801962:	e8 e7 fe ff ff       	call   80184e <syscall>
  801967:	83 c4 18             	add    $0x18,%esp
}
  80196a:	c9                   	leave  
  80196b:	c3                   	ret    

0080196c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 0b                	push   $0xb
  80197b:	e8 ce fe ff ff       	call   80184e <syscall>
  801980:	83 c4 18             	add    $0x18,%esp
}
  801983:	c9                   	leave  
  801984:	c3                   	ret    

00801985 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	ff 75 0c             	pushl  0xc(%ebp)
  801991:	ff 75 08             	pushl  0x8(%ebp)
  801994:	6a 0f                	push   $0xf
  801996:	e8 b3 fe ff ff       	call   80184e <syscall>
  80199b:	83 c4 18             	add    $0x18,%esp
	return;
  80199e:	90                   	nop
}
  80199f:	c9                   	leave  
  8019a0:	c3                   	ret    

008019a1 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019a1:	55                   	push   %ebp
  8019a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	ff 75 0c             	pushl  0xc(%ebp)
  8019ad:	ff 75 08             	pushl  0x8(%ebp)
  8019b0:	6a 10                	push   $0x10
  8019b2:	e8 97 fe ff ff       	call   80184e <syscall>
  8019b7:	83 c4 18             	add    $0x18,%esp
	return ;
  8019ba:	90                   	nop
}
  8019bb:	c9                   	leave  
  8019bc:	c3                   	ret    

008019bd <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	ff 75 10             	pushl  0x10(%ebp)
  8019c7:	ff 75 0c             	pushl  0xc(%ebp)
  8019ca:	ff 75 08             	pushl  0x8(%ebp)
  8019cd:	6a 11                	push   $0x11
  8019cf:	e8 7a fe ff ff       	call   80184e <syscall>
  8019d4:	83 c4 18             	add    $0x18,%esp
	return ;
  8019d7:	90                   	nop
}
  8019d8:	c9                   	leave  
  8019d9:	c3                   	ret    

008019da <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019da:	55                   	push   %ebp
  8019db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 0c                	push   $0xc
  8019e9:	e8 60 fe ff ff       	call   80184e <syscall>
  8019ee:	83 c4 18             	add    $0x18,%esp
}
  8019f1:	c9                   	leave  
  8019f2:	c3                   	ret    

008019f3 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	ff 75 08             	pushl  0x8(%ebp)
  801a01:	6a 0d                	push   $0xd
  801a03:	e8 46 fe ff ff       	call   80184e <syscall>
  801a08:	83 c4 18             	add    $0x18,%esp
}
  801a0b:	c9                   	leave  
  801a0c:	c3                   	ret    

00801a0d <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 0e                	push   $0xe
  801a1c:	e8 2d fe ff ff       	call   80184e <syscall>
  801a21:	83 c4 18             	add    $0x18,%esp
}
  801a24:	90                   	nop
  801a25:	c9                   	leave  
  801a26:	c3                   	ret    

00801a27 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a27:	55                   	push   %ebp
  801a28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 13                	push   $0x13
  801a36:	e8 13 fe ff ff       	call   80184e <syscall>
  801a3b:	83 c4 18             	add    $0x18,%esp
}
  801a3e:	90                   	nop
  801a3f:	c9                   	leave  
  801a40:	c3                   	ret    

00801a41 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a41:	55                   	push   %ebp
  801a42:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 14                	push   $0x14
  801a50:	e8 f9 fd ff ff       	call   80184e <syscall>
  801a55:	83 c4 18             	add    $0x18,%esp
}
  801a58:	90                   	nop
  801a59:	c9                   	leave  
  801a5a:	c3                   	ret    

00801a5b <sys_cputc>:


void
sys_cputc(const char c)
{
  801a5b:	55                   	push   %ebp
  801a5c:	89 e5                	mov    %esp,%ebp
  801a5e:	83 ec 04             	sub    $0x4,%esp
  801a61:	8b 45 08             	mov    0x8(%ebp),%eax
  801a64:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a67:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	50                   	push   %eax
  801a74:	6a 15                	push   $0x15
  801a76:	e8 d3 fd ff ff       	call   80184e <syscall>
  801a7b:	83 c4 18             	add    $0x18,%esp
}
  801a7e:	90                   	nop
  801a7f:	c9                   	leave  
  801a80:	c3                   	ret    

00801a81 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a81:	55                   	push   %ebp
  801a82:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 16                	push   $0x16
  801a90:	e8 b9 fd ff ff       	call   80184e <syscall>
  801a95:	83 c4 18             	add    $0x18,%esp
}
  801a98:	90                   	nop
  801a99:	c9                   	leave  
  801a9a:	c3                   	ret    

00801a9b <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a9b:	55                   	push   %ebp
  801a9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	ff 75 0c             	pushl  0xc(%ebp)
  801aaa:	50                   	push   %eax
  801aab:	6a 17                	push   $0x17
  801aad:	e8 9c fd ff ff       	call   80184e <syscall>
  801ab2:	83 c4 18             	add    $0x18,%esp
}
  801ab5:	c9                   	leave  
  801ab6:	c3                   	ret    

00801ab7 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801ab7:	55                   	push   %ebp
  801ab8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801aba:	8b 55 0c             	mov    0xc(%ebp),%edx
  801abd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	52                   	push   %edx
  801ac7:	50                   	push   %eax
  801ac8:	6a 1a                	push   $0x1a
  801aca:	e8 7f fd ff ff       	call   80184e <syscall>
  801acf:	83 c4 18             	add    $0x18,%esp
}
  801ad2:	c9                   	leave  
  801ad3:	c3                   	ret    

00801ad4 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ad4:	55                   	push   %ebp
  801ad5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ad7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ada:	8b 45 08             	mov    0x8(%ebp),%eax
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	52                   	push   %edx
  801ae4:	50                   	push   %eax
  801ae5:	6a 18                	push   $0x18
  801ae7:	e8 62 fd ff ff       	call   80184e <syscall>
  801aec:	83 c4 18             	add    $0x18,%esp
}
  801aef:	90                   	nop
  801af0:	c9                   	leave  
  801af1:	c3                   	ret    

00801af2 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801af5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af8:	8b 45 08             	mov    0x8(%ebp),%eax
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	6a 00                	push   $0x0
  801b01:	52                   	push   %edx
  801b02:	50                   	push   %eax
  801b03:	6a 19                	push   $0x19
  801b05:	e8 44 fd ff ff       	call   80184e <syscall>
  801b0a:	83 c4 18             	add    $0x18,%esp
}
  801b0d:	90                   	nop
  801b0e:	c9                   	leave  
  801b0f:	c3                   	ret    

00801b10 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b10:	55                   	push   %ebp
  801b11:	89 e5                	mov    %esp,%ebp
  801b13:	83 ec 04             	sub    $0x4,%esp
  801b16:	8b 45 10             	mov    0x10(%ebp),%eax
  801b19:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b1c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b1f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b23:	8b 45 08             	mov    0x8(%ebp),%eax
  801b26:	6a 00                	push   $0x0
  801b28:	51                   	push   %ecx
  801b29:	52                   	push   %edx
  801b2a:	ff 75 0c             	pushl  0xc(%ebp)
  801b2d:	50                   	push   %eax
  801b2e:	6a 1b                	push   $0x1b
  801b30:	e8 19 fd ff ff       	call   80184e <syscall>
  801b35:	83 c4 18             	add    $0x18,%esp
}
  801b38:	c9                   	leave  
  801b39:	c3                   	ret    

00801b3a <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b3a:	55                   	push   %ebp
  801b3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b40:	8b 45 08             	mov    0x8(%ebp),%eax
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	52                   	push   %edx
  801b4a:	50                   	push   %eax
  801b4b:	6a 1c                	push   $0x1c
  801b4d:	e8 fc fc ff ff       	call   80184e <syscall>
  801b52:	83 c4 18             	add    $0x18,%esp
}
  801b55:	c9                   	leave  
  801b56:	c3                   	ret    

00801b57 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b5a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b60:	8b 45 08             	mov    0x8(%ebp),%eax
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	51                   	push   %ecx
  801b68:	52                   	push   %edx
  801b69:	50                   	push   %eax
  801b6a:	6a 1d                	push   $0x1d
  801b6c:	e8 dd fc ff ff       	call   80184e <syscall>
  801b71:	83 c4 18             	add    $0x18,%esp
}
  801b74:	c9                   	leave  
  801b75:	c3                   	ret    

00801b76 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b76:	55                   	push   %ebp
  801b77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b79:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	52                   	push   %edx
  801b86:	50                   	push   %eax
  801b87:	6a 1e                	push   $0x1e
  801b89:	e8 c0 fc ff ff       	call   80184e <syscall>
  801b8e:	83 c4 18             	add    $0x18,%esp
}
  801b91:	c9                   	leave  
  801b92:	c3                   	ret    

00801b93 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 1f                	push   $0x1f
  801ba2:	e8 a7 fc ff ff       	call   80184e <syscall>
  801ba7:	83 c4 18             	add    $0x18,%esp
}
  801baa:	c9                   	leave  
  801bab:	c3                   	ret    

00801bac <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801baf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb2:	6a 00                	push   $0x0
  801bb4:	ff 75 14             	pushl  0x14(%ebp)
  801bb7:	ff 75 10             	pushl  0x10(%ebp)
  801bba:	ff 75 0c             	pushl  0xc(%ebp)
  801bbd:	50                   	push   %eax
  801bbe:	6a 20                	push   $0x20
  801bc0:	e8 89 fc ff ff       	call   80184e <syscall>
  801bc5:	83 c4 18             	add    $0x18,%esp
}
  801bc8:	c9                   	leave  
  801bc9:	c3                   	ret    

00801bca <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801bca:	55                   	push   %ebp
  801bcb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	50                   	push   %eax
  801bd9:	6a 21                	push   $0x21
  801bdb:	e8 6e fc ff ff       	call   80184e <syscall>
  801be0:	83 c4 18             	add    $0x18,%esp
}
  801be3:	90                   	nop
  801be4:	c9                   	leave  
  801be5:	c3                   	ret    

00801be6 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801be6:	55                   	push   %ebp
  801be7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801be9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	50                   	push   %eax
  801bf5:	6a 22                	push   $0x22
  801bf7:	e8 52 fc ff ff       	call   80184e <syscall>
  801bfc:	83 c4 18             	add    $0x18,%esp
}
  801bff:	c9                   	leave  
  801c00:	c3                   	ret    

00801c01 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c01:	55                   	push   %ebp
  801c02:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 02                	push   $0x2
  801c10:	e8 39 fc ff ff       	call   80184e <syscall>
  801c15:	83 c4 18             	add    $0x18,%esp
}
  801c18:	c9                   	leave  
  801c19:	c3                   	ret    

00801c1a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c1a:	55                   	push   %ebp
  801c1b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 03                	push   $0x3
  801c29:	e8 20 fc ff ff       	call   80184e <syscall>
  801c2e:	83 c4 18             	add    $0x18,%esp
}
  801c31:	c9                   	leave  
  801c32:	c3                   	ret    

00801c33 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 04                	push   $0x4
  801c42:	e8 07 fc ff ff       	call   80184e <syscall>
  801c47:	83 c4 18             	add    $0x18,%esp
}
  801c4a:	c9                   	leave  
  801c4b:	c3                   	ret    

00801c4c <sys_exit_env>:


void sys_exit_env(void)
{
  801c4c:	55                   	push   %ebp
  801c4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 23                	push   $0x23
  801c5b:	e8 ee fb ff ff       	call   80184e <syscall>
  801c60:	83 c4 18             	add    $0x18,%esp
}
  801c63:	90                   	nop
  801c64:	c9                   	leave  
  801c65:	c3                   	ret    

00801c66 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c66:	55                   	push   %ebp
  801c67:	89 e5                	mov    %esp,%ebp
  801c69:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c6c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c6f:	8d 50 04             	lea    0x4(%eax),%edx
  801c72:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	52                   	push   %edx
  801c7c:	50                   	push   %eax
  801c7d:	6a 24                	push   $0x24
  801c7f:	e8 ca fb ff ff       	call   80184e <syscall>
  801c84:	83 c4 18             	add    $0x18,%esp
	return result;
  801c87:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c8a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c8d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c90:	89 01                	mov    %eax,(%ecx)
  801c92:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c95:	8b 45 08             	mov    0x8(%ebp),%eax
  801c98:	c9                   	leave  
  801c99:	c2 04 00             	ret    $0x4

00801c9c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c9c:	55                   	push   %ebp
  801c9d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	ff 75 10             	pushl  0x10(%ebp)
  801ca6:	ff 75 0c             	pushl  0xc(%ebp)
  801ca9:	ff 75 08             	pushl  0x8(%ebp)
  801cac:	6a 12                	push   $0x12
  801cae:	e8 9b fb ff ff       	call   80184e <syscall>
  801cb3:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb6:	90                   	nop
}
  801cb7:	c9                   	leave  
  801cb8:	c3                   	ret    

00801cb9 <sys_rcr2>:
uint32 sys_rcr2()
{
  801cb9:	55                   	push   %ebp
  801cba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 25                	push   $0x25
  801cc8:	e8 81 fb ff ff       	call   80184e <syscall>
  801ccd:	83 c4 18             	add    $0x18,%esp
}
  801cd0:	c9                   	leave  
  801cd1:	c3                   	ret    

00801cd2 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801cd2:	55                   	push   %ebp
  801cd3:	89 e5                	mov    %esp,%ebp
  801cd5:	83 ec 04             	sub    $0x4,%esp
  801cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cde:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	50                   	push   %eax
  801ceb:	6a 26                	push   $0x26
  801ced:	e8 5c fb ff ff       	call   80184e <syscall>
  801cf2:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf5:	90                   	nop
}
  801cf6:	c9                   	leave  
  801cf7:	c3                   	ret    

00801cf8 <rsttst>:
void rsttst()
{
  801cf8:	55                   	push   %ebp
  801cf9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 28                	push   $0x28
  801d07:	e8 42 fb ff ff       	call   80184e <syscall>
  801d0c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d0f:	90                   	nop
}
  801d10:	c9                   	leave  
  801d11:	c3                   	ret    

00801d12 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d12:	55                   	push   %ebp
  801d13:	89 e5                	mov    %esp,%ebp
  801d15:	83 ec 04             	sub    $0x4,%esp
  801d18:	8b 45 14             	mov    0x14(%ebp),%eax
  801d1b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d1e:	8b 55 18             	mov    0x18(%ebp),%edx
  801d21:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d25:	52                   	push   %edx
  801d26:	50                   	push   %eax
  801d27:	ff 75 10             	pushl  0x10(%ebp)
  801d2a:	ff 75 0c             	pushl  0xc(%ebp)
  801d2d:	ff 75 08             	pushl  0x8(%ebp)
  801d30:	6a 27                	push   $0x27
  801d32:	e8 17 fb ff ff       	call   80184e <syscall>
  801d37:	83 c4 18             	add    $0x18,%esp
	return ;
  801d3a:	90                   	nop
}
  801d3b:	c9                   	leave  
  801d3c:	c3                   	ret    

00801d3d <chktst>:
void chktst(uint32 n)
{
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	ff 75 08             	pushl  0x8(%ebp)
  801d4b:	6a 29                	push   $0x29
  801d4d:	e8 fc fa ff ff       	call   80184e <syscall>
  801d52:	83 c4 18             	add    $0x18,%esp
	return ;
  801d55:	90                   	nop
}
  801d56:	c9                   	leave  
  801d57:	c3                   	ret    

00801d58 <inctst>:

void inctst()
{
  801d58:	55                   	push   %ebp
  801d59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	6a 2a                	push   $0x2a
  801d67:	e8 e2 fa ff ff       	call   80184e <syscall>
  801d6c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d6f:	90                   	nop
}
  801d70:	c9                   	leave  
  801d71:	c3                   	ret    

00801d72 <gettst>:
uint32 gettst()
{
  801d72:	55                   	push   %ebp
  801d73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 2b                	push   $0x2b
  801d81:	e8 c8 fa ff ff       	call   80184e <syscall>
  801d86:	83 c4 18             	add    $0x18,%esp
}
  801d89:	c9                   	leave  
  801d8a:	c3                   	ret    

00801d8b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d8b:	55                   	push   %ebp
  801d8c:	89 e5                	mov    %esp,%ebp
  801d8e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 2c                	push   $0x2c
  801d9d:	e8 ac fa ff ff       	call   80184e <syscall>
  801da2:	83 c4 18             	add    $0x18,%esp
  801da5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801da8:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801dac:	75 07                	jne    801db5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801dae:	b8 01 00 00 00       	mov    $0x1,%eax
  801db3:	eb 05                	jmp    801dba <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801db5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dba:	c9                   	leave  
  801dbb:	c3                   	ret    

00801dbc <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801dbc:	55                   	push   %ebp
  801dbd:	89 e5                	mov    %esp,%ebp
  801dbf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 2c                	push   $0x2c
  801dce:	e8 7b fa ff ff       	call   80184e <syscall>
  801dd3:	83 c4 18             	add    $0x18,%esp
  801dd6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801dd9:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ddd:	75 07                	jne    801de6 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ddf:	b8 01 00 00 00       	mov    $0x1,%eax
  801de4:	eb 05                	jmp    801deb <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801de6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801deb:	c9                   	leave  
  801dec:	c3                   	ret    

00801ded <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
  801df0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 2c                	push   $0x2c
  801dff:	e8 4a fa ff ff       	call   80184e <syscall>
  801e04:	83 c4 18             	add    $0x18,%esp
  801e07:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e0a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e0e:	75 07                	jne    801e17 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e10:	b8 01 00 00 00       	mov    $0x1,%eax
  801e15:	eb 05                	jmp    801e1c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e1c:	c9                   	leave  
  801e1d:	c3                   	ret    

00801e1e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e1e:	55                   	push   %ebp
  801e1f:	89 e5                	mov    %esp,%ebp
  801e21:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 2c                	push   $0x2c
  801e30:	e8 19 fa ff ff       	call   80184e <syscall>
  801e35:	83 c4 18             	add    $0x18,%esp
  801e38:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e3b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e3f:	75 07                	jne    801e48 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e41:	b8 01 00 00 00       	mov    $0x1,%eax
  801e46:	eb 05                	jmp    801e4d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e48:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e4d:	c9                   	leave  
  801e4e:	c3                   	ret    

00801e4f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e4f:	55                   	push   %ebp
  801e50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	ff 75 08             	pushl  0x8(%ebp)
  801e5d:	6a 2d                	push   $0x2d
  801e5f:	e8 ea f9 ff ff       	call   80184e <syscall>
  801e64:	83 c4 18             	add    $0x18,%esp
	return ;
  801e67:	90                   	nop
}
  801e68:	c9                   	leave  
  801e69:	c3                   	ret    

00801e6a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
  801e6d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e6e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e71:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e74:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e77:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7a:	6a 00                	push   $0x0
  801e7c:	53                   	push   %ebx
  801e7d:	51                   	push   %ecx
  801e7e:	52                   	push   %edx
  801e7f:	50                   	push   %eax
  801e80:	6a 2e                	push   $0x2e
  801e82:	e8 c7 f9 ff ff       	call   80184e <syscall>
  801e87:	83 c4 18             	add    $0x18,%esp
}
  801e8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e8d:	c9                   	leave  
  801e8e:	c3                   	ret    

00801e8f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e8f:	55                   	push   %ebp
  801e90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e92:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e95:	8b 45 08             	mov    0x8(%ebp),%eax
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	52                   	push   %edx
  801e9f:	50                   	push   %eax
  801ea0:	6a 2f                	push   $0x2f
  801ea2:	e8 a7 f9 ff ff       	call   80184e <syscall>
  801ea7:	83 c4 18             	add    $0x18,%esp
}
  801eaa:	c9                   	leave  
  801eab:	c3                   	ret    

00801eac <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
  801eaf:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801eb2:	83 ec 0c             	sub    $0xc,%esp
  801eb5:	68 60 3b 80 00       	push   $0x803b60
  801eba:	e8 c3 e6 ff ff       	call   800582 <cprintf>
  801ebf:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801ec2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801ec9:	83 ec 0c             	sub    $0xc,%esp
  801ecc:	68 8c 3b 80 00       	push   $0x803b8c
  801ed1:	e8 ac e6 ff ff       	call   800582 <cprintf>
  801ed6:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801ed9:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801edd:	a1 38 41 80 00       	mov    0x804138,%eax
  801ee2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ee5:	eb 56                	jmp    801f3d <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ee7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801eeb:	74 1c                	je     801f09 <print_mem_block_lists+0x5d>
  801eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef0:	8b 50 08             	mov    0x8(%eax),%edx
  801ef3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ef6:	8b 48 08             	mov    0x8(%eax),%ecx
  801ef9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801efc:	8b 40 0c             	mov    0xc(%eax),%eax
  801eff:	01 c8                	add    %ecx,%eax
  801f01:	39 c2                	cmp    %eax,%edx
  801f03:	73 04                	jae    801f09 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f05:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0c:	8b 50 08             	mov    0x8(%eax),%edx
  801f0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f12:	8b 40 0c             	mov    0xc(%eax),%eax
  801f15:	01 c2                	add    %eax,%edx
  801f17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1a:	8b 40 08             	mov    0x8(%eax),%eax
  801f1d:	83 ec 04             	sub    $0x4,%esp
  801f20:	52                   	push   %edx
  801f21:	50                   	push   %eax
  801f22:	68 a1 3b 80 00       	push   $0x803ba1
  801f27:	e8 56 e6 ff ff       	call   800582 <cprintf>
  801f2c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f32:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f35:	a1 40 41 80 00       	mov    0x804140,%eax
  801f3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f41:	74 07                	je     801f4a <print_mem_block_lists+0x9e>
  801f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f46:	8b 00                	mov    (%eax),%eax
  801f48:	eb 05                	jmp    801f4f <print_mem_block_lists+0xa3>
  801f4a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4f:	a3 40 41 80 00       	mov    %eax,0x804140
  801f54:	a1 40 41 80 00       	mov    0x804140,%eax
  801f59:	85 c0                	test   %eax,%eax
  801f5b:	75 8a                	jne    801ee7 <print_mem_block_lists+0x3b>
  801f5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f61:	75 84                	jne    801ee7 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f63:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f67:	75 10                	jne    801f79 <print_mem_block_lists+0xcd>
  801f69:	83 ec 0c             	sub    $0xc,%esp
  801f6c:	68 b0 3b 80 00       	push   $0x803bb0
  801f71:	e8 0c e6 ff ff       	call   800582 <cprintf>
  801f76:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f79:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f80:	83 ec 0c             	sub    $0xc,%esp
  801f83:	68 d4 3b 80 00       	push   $0x803bd4
  801f88:	e8 f5 e5 ff ff       	call   800582 <cprintf>
  801f8d:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f90:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f94:	a1 40 40 80 00       	mov    0x804040,%eax
  801f99:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f9c:	eb 56                	jmp    801ff4 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f9e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fa2:	74 1c                	je     801fc0 <print_mem_block_lists+0x114>
  801fa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa7:	8b 50 08             	mov    0x8(%eax),%edx
  801faa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fad:	8b 48 08             	mov    0x8(%eax),%ecx
  801fb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fb3:	8b 40 0c             	mov    0xc(%eax),%eax
  801fb6:	01 c8                	add    %ecx,%eax
  801fb8:	39 c2                	cmp    %eax,%edx
  801fba:	73 04                	jae    801fc0 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801fbc:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc3:	8b 50 08             	mov    0x8(%eax),%edx
  801fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc9:	8b 40 0c             	mov    0xc(%eax),%eax
  801fcc:	01 c2                	add    %eax,%edx
  801fce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd1:	8b 40 08             	mov    0x8(%eax),%eax
  801fd4:	83 ec 04             	sub    $0x4,%esp
  801fd7:	52                   	push   %edx
  801fd8:	50                   	push   %eax
  801fd9:	68 a1 3b 80 00       	push   $0x803ba1
  801fde:	e8 9f e5 ff ff       	call   800582 <cprintf>
  801fe3:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fec:	a1 48 40 80 00       	mov    0x804048,%eax
  801ff1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ff4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ff8:	74 07                	je     802001 <print_mem_block_lists+0x155>
  801ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffd:	8b 00                	mov    (%eax),%eax
  801fff:	eb 05                	jmp    802006 <print_mem_block_lists+0x15a>
  802001:	b8 00 00 00 00       	mov    $0x0,%eax
  802006:	a3 48 40 80 00       	mov    %eax,0x804048
  80200b:	a1 48 40 80 00       	mov    0x804048,%eax
  802010:	85 c0                	test   %eax,%eax
  802012:	75 8a                	jne    801f9e <print_mem_block_lists+0xf2>
  802014:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802018:	75 84                	jne    801f9e <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80201a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80201e:	75 10                	jne    802030 <print_mem_block_lists+0x184>
  802020:	83 ec 0c             	sub    $0xc,%esp
  802023:	68 ec 3b 80 00       	push   $0x803bec
  802028:	e8 55 e5 ff ff       	call   800582 <cprintf>
  80202d:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802030:	83 ec 0c             	sub    $0xc,%esp
  802033:	68 60 3b 80 00       	push   $0x803b60
  802038:	e8 45 e5 ff ff       	call   800582 <cprintf>
  80203d:	83 c4 10             	add    $0x10,%esp

}
  802040:	90                   	nop
  802041:	c9                   	leave  
  802042:	c3                   	ret    

00802043 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802043:	55                   	push   %ebp
  802044:	89 e5                	mov    %esp,%ebp
  802046:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  802049:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802050:	00 00 00 
  802053:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  80205a:	00 00 00 
  80205d:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802064:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802067:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80206e:	e9 9e 00 00 00       	jmp    802111 <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802073:	a1 50 40 80 00       	mov    0x804050,%eax
  802078:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80207b:	c1 e2 04             	shl    $0x4,%edx
  80207e:	01 d0                	add    %edx,%eax
  802080:	85 c0                	test   %eax,%eax
  802082:	75 14                	jne    802098 <initialize_MemBlocksList+0x55>
  802084:	83 ec 04             	sub    $0x4,%esp
  802087:	68 14 3c 80 00       	push   $0x803c14
  80208c:	6a 47                	push   $0x47
  80208e:	68 37 3c 80 00       	push   $0x803c37
  802093:	e8 36 e2 ff ff       	call   8002ce <_panic>
  802098:	a1 50 40 80 00       	mov    0x804050,%eax
  80209d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020a0:	c1 e2 04             	shl    $0x4,%edx
  8020a3:	01 d0                	add    %edx,%eax
  8020a5:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8020ab:	89 10                	mov    %edx,(%eax)
  8020ad:	8b 00                	mov    (%eax),%eax
  8020af:	85 c0                	test   %eax,%eax
  8020b1:	74 18                	je     8020cb <initialize_MemBlocksList+0x88>
  8020b3:	a1 48 41 80 00       	mov    0x804148,%eax
  8020b8:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8020be:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8020c1:	c1 e1 04             	shl    $0x4,%ecx
  8020c4:	01 ca                	add    %ecx,%edx
  8020c6:	89 50 04             	mov    %edx,0x4(%eax)
  8020c9:	eb 12                	jmp    8020dd <initialize_MemBlocksList+0x9a>
  8020cb:	a1 50 40 80 00       	mov    0x804050,%eax
  8020d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020d3:	c1 e2 04             	shl    $0x4,%edx
  8020d6:	01 d0                	add    %edx,%eax
  8020d8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8020dd:	a1 50 40 80 00       	mov    0x804050,%eax
  8020e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020e5:	c1 e2 04             	shl    $0x4,%edx
  8020e8:	01 d0                	add    %edx,%eax
  8020ea:	a3 48 41 80 00       	mov    %eax,0x804148
  8020ef:	a1 50 40 80 00       	mov    0x804050,%eax
  8020f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020f7:	c1 e2 04             	shl    $0x4,%edx
  8020fa:	01 d0                	add    %edx,%eax
  8020fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802103:	a1 54 41 80 00       	mov    0x804154,%eax
  802108:	40                   	inc    %eax
  802109:	a3 54 41 80 00       	mov    %eax,0x804154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  80210e:	ff 45 f4             	incl   -0xc(%ebp)
  802111:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802114:	3b 45 08             	cmp    0x8(%ebp),%eax
  802117:	0f 82 56 ff ff ff    	jb     802073 <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  80211d:	90                   	nop
  80211e:	c9                   	leave  
  80211f:	c3                   	ret    

00802120 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802120:	55                   	push   %ebp
  802121:	89 e5                	mov    %esp,%ebp
  802123:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802126:	8b 45 08             	mov    0x8(%ebp),%eax
  802129:	8b 00                	mov    (%eax),%eax
  80212b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80212e:	eb 19                	jmp    802149 <find_block+0x29>
	{
		if(element->sva == va){
  802130:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802133:	8b 40 08             	mov    0x8(%eax),%eax
  802136:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802139:	75 05                	jne    802140 <find_block+0x20>
			 		return element;
  80213b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80213e:	eb 36                	jmp    802176 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802140:	8b 45 08             	mov    0x8(%ebp),%eax
  802143:	8b 40 08             	mov    0x8(%eax),%eax
  802146:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802149:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80214d:	74 07                	je     802156 <find_block+0x36>
  80214f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802152:	8b 00                	mov    (%eax),%eax
  802154:	eb 05                	jmp    80215b <find_block+0x3b>
  802156:	b8 00 00 00 00       	mov    $0x0,%eax
  80215b:	8b 55 08             	mov    0x8(%ebp),%edx
  80215e:	89 42 08             	mov    %eax,0x8(%edx)
  802161:	8b 45 08             	mov    0x8(%ebp),%eax
  802164:	8b 40 08             	mov    0x8(%eax),%eax
  802167:	85 c0                	test   %eax,%eax
  802169:	75 c5                	jne    802130 <find_block+0x10>
  80216b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80216f:	75 bf                	jne    802130 <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  802171:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802176:	c9                   	leave  
  802177:	c3                   	ret    

00802178 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802178:	55                   	push   %ebp
  802179:	89 e5                	mov    %esp,%ebp
  80217b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  80217e:	a1 44 40 80 00       	mov    0x804044,%eax
  802183:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  802186:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80218b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  80218e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802192:	74 0a                	je     80219e <insert_sorted_allocList+0x26>
  802194:	8b 45 08             	mov    0x8(%ebp),%eax
  802197:	8b 40 08             	mov    0x8(%eax),%eax
  80219a:	85 c0                	test   %eax,%eax
  80219c:	75 65                	jne    802203 <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80219e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021a2:	75 14                	jne    8021b8 <insert_sorted_allocList+0x40>
  8021a4:	83 ec 04             	sub    $0x4,%esp
  8021a7:	68 14 3c 80 00       	push   $0x803c14
  8021ac:	6a 6e                	push   $0x6e
  8021ae:	68 37 3c 80 00       	push   $0x803c37
  8021b3:	e8 16 e1 ff ff       	call   8002ce <_panic>
  8021b8:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8021be:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c1:	89 10                	mov    %edx,(%eax)
  8021c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c6:	8b 00                	mov    (%eax),%eax
  8021c8:	85 c0                	test   %eax,%eax
  8021ca:	74 0d                	je     8021d9 <insert_sorted_allocList+0x61>
  8021cc:	a1 40 40 80 00       	mov    0x804040,%eax
  8021d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8021d4:	89 50 04             	mov    %edx,0x4(%eax)
  8021d7:	eb 08                	jmp    8021e1 <insert_sorted_allocList+0x69>
  8021d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021dc:	a3 44 40 80 00       	mov    %eax,0x804044
  8021e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e4:	a3 40 40 80 00       	mov    %eax,0x804040
  8021e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021f3:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021f8:	40                   	inc    %eax
  8021f9:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8021fe:	e9 cf 01 00 00       	jmp    8023d2 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  802203:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802206:	8b 50 08             	mov    0x8(%eax),%edx
  802209:	8b 45 08             	mov    0x8(%ebp),%eax
  80220c:	8b 40 08             	mov    0x8(%eax),%eax
  80220f:	39 c2                	cmp    %eax,%edx
  802211:	73 65                	jae    802278 <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802213:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802217:	75 14                	jne    80222d <insert_sorted_allocList+0xb5>
  802219:	83 ec 04             	sub    $0x4,%esp
  80221c:	68 50 3c 80 00       	push   $0x803c50
  802221:	6a 72                	push   $0x72
  802223:	68 37 3c 80 00       	push   $0x803c37
  802228:	e8 a1 e0 ff ff       	call   8002ce <_panic>
  80222d:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802233:	8b 45 08             	mov    0x8(%ebp),%eax
  802236:	89 50 04             	mov    %edx,0x4(%eax)
  802239:	8b 45 08             	mov    0x8(%ebp),%eax
  80223c:	8b 40 04             	mov    0x4(%eax),%eax
  80223f:	85 c0                	test   %eax,%eax
  802241:	74 0c                	je     80224f <insert_sorted_allocList+0xd7>
  802243:	a1 44 40 80 00       	mov    0x804044,%eax
  802248:	8b 55 08             	mov    0x8(%ebp),%edx
  80224b:	89 10                	mov    %edx,(%eax)
  80224d:	eb 08                	jmp    802257 <insert_sorted_allocList+0xdf>
  80224f:	8b 45 08             	mov    0x8(%ebp),%eax
  802252:	a3 40 40 80 00       	mov    %eax,0x804040
  802257:	8b 45 08             	mov    0x8(%ebp),%eax
  80225a:	a3 44 40 80 00       	mov    %eax,0x804044
  80225f:	8b 45 08             	mov    0x8(%ebp),%eax
  802262:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802268:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80226d:	40                   	inc    %eax
  80226e:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  802273:	e9 5a 01 00 00       	jmp    8023d2 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  802278:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80227b:	8b 50 08             	mov    0x8(%eax),%edx
  80227e:	8b 45 08             	mov    0x8(%ebp),%eax
  802281:	8b 40 08             	mov    0x8(%eax),%eax
  802284:	39 c2                	cmp    %eax,%edx
  802286:	75 70                	jne    8022f8 <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  802288:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80228c:	74 06                	je     802294 <insert_sorted_allocList+0x11c>
  80228e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802292:	75 14                	jne    8022a8 <insert_sorted_allocList+0x130>
  802294:	83 ec 04             	sub    $0x4,%esp
  802297:	68 74 3c 80 00       	push   $0x803c74
  80229c:	6a 75                	push   $0x75
  80229e:	68 37 3c 80 00       	push   $0x803c37
  8022a3:	e8 26 e0 ff ff       	call   8002ce <_panic>
  8022a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ab:	8b 10                	mov    (%eax),%edx
  8022ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b0:	89 10                	mov    %edx,(%eax)
  8022b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b5:	8b 00                	mov    (%eax),%eax
  8022b7:	85 c0                	test   %eax,%eax
  8022b9:	74 0b                	je     8022c6 <insert_sorted_allocList+0x14e>
  8022bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022be:	8b 00                	mov    (%eax),%eax
  8022c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8022c3:	89 50 04             	mov    %edx,0x4(%eax)
  8022c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8022cc:	89 10                	mov    %edx,(%eax)
  8022ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022d4:	89 50 04             	mov    %edx,0x4(%eax)
  8022d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022da:	8b 00                	mov    (%eax),%eax
  8022dc:	85 c0                	test   %eax,%eax
  8022de:	75 08                	jne    8022e8 <insert_sorted_allocList+0x170>
  8022e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e3:	a3 44 40 80 00       	mov    %eax,0x804044
  8022e8:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022ed:	40                   	inc    %eax
  8022ee:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  8022f3:	e9 da 00 00 00       	jmp    8023d2 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  8022f8:	a1 40 40 80 00       	mov    0x804040,%eax
  8022fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802300:	e9 9d 00 00 00       	jmp    8023a2 <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  802305:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802308:	8b 00                	mov    (%eax),%eax
  80230a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  80230d:	8b 45 08             	mov    0x8(%ebp),%eax
  802310:	8b 50 08             	mov    0x8(%eax),%edx
  802313:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802316:	8b 40 08             	mov    0x8(%eax),%eax
  802319:	39 c2                	cmp    %eax,%edx
  80231b:	76 7d                	jbe    80239a <insert_sorted_allocList+0x222>
  80231d:	8b 45 08             	mov    0x8(%ebp),%eax
  802320:	8b 50 08             	mov    0x8(%eax),%edx
  802323:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802326:	8b 40 08             	mov    0x8(%eax),%eax
  802329:	39 c2                	cmp    %eax,%edx
  80232b:	73 6d                	jae    80239a <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  80232d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802331:	74 06                	je     802339 <insert_sorted_allocList+0x1c1>
  802333:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802337:	75 14                	jne    80234d <insert_sorted_allocList+0x1d5>
  802339:	83 ec 04             	sub    $0x4,%esp
  80233c:	68 74 3c 80 00       	push   $0x803c74
  802341:	6a 7c                	push   $0x7c
  802343:	68 37 3c 80 00       	push   $0x803c37
  802348:	e8 81 df ff ff       	call   8002ce <_panic>
  80234d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802350:	8b 10                	mov    (%eax),%edx
  802352:	8b 45 08             	mov    0x8(%ebp),%eax
  802355:	89 10                	mov    %edx,(%eax)
  802357:	8b 45 08             	mov    0x8(%ebp),%eax
  80235a:	8b 00                	mov    (%eax),%eax
  80235c:	85 c0                	test   %eax,%eax
  80235e:	74 0b                	je     80236b <insert_sorted_allocList+0x1f3>
  802360:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802363:	8b 00                	mov    (%eax),%eax
  802365:	8b 55 08             	mov    0x8(%ebp),%edx
  802368:	89 50 04             	mov    %edx,0x4(%eax)
  80236b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236e:	8b 55 08             	mov    0x8(%ebp),%edx
  802371:	89 10                	mov    %edx,(%eax)
  802373:	8b 45 08             	mov    0x8(%ebp),%eax
  802376:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802379:	89 50 04             	mov    %edx,0x4(%eax)
  80237c:	8b 45 08             	mov    0x8(%ebp),%eax
  80237f:	8b 00                	mov    (%eax),%eax
  802381:	85 c0                	test   %eax,%eax
  802383:	75 08                	jne    80238d <insert_sorted_allocList+0x215>
  802385:	8b 45 08             	mov    0x8(%ebp),%eax
  802388:	a3 44 40 80 00       	mov    %eax,0x804044
  80238d:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802392:	40                   	inc    %eax
  802393:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802398:	eb 38                	jmp    8023d2 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  80239a:	a1 48 40 80 00       	mov    0x804048,%eax
  80239f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023a6:	74 07                	je     8023af <insert_sorted_allocList+0x237>
  8023a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ab:	8b 00                	mov    (%eax),%eax
  8023ad:	eb 05                	jmp    8023b4 <insert_sorted_allocList+0x23c>
  8023af:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b4:	a3 48 40 80 00       	mov    %eax,0x804048
  8023b9:	a1 48 40 80 00       	mov    0x804048,%eax
  8023be:	85 c0                	test   %eax,%eax
  8023c0:	0f 85 3f ff ff ff    	jne    802305 <insert_sorted_allocList+0x18d>
  8023c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ca:	0f 85 35 ff ff ff    	jne    802305 <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  8023d0:	eb 00                	jmp    8023d2 <insert_sorted_allocList+0x25a>
  8023d2:	90                   	nop
  8023d3:	c9                   	leave  
  8023d4:	c3                   	ret    

008023d5 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8023d5:	55                   	push   %ebp
  8023d6:	89 e5                	mov    %esp,%ebp
  8023d8:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  8023db:	a1 38 41 80 00       	mov    0x804138,%eax
  8023e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023e3:	e9 6b 02 00 00       	jmp    802653 <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  8023e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8023ee:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023f1:	0f 85 90 00 00 00    	jne    802487 <alloc_block_FF+0xb2>
			  temp=element;
  8023f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  8023fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802401:	75 17                	jne    80241a <alloc_block_FF+0x45>
  802403:	83 ec 04             	sub    $0x4,%esp
  802406:	68 a8 3c 80 00       	push   $0x803ca8
  80240b:	68 92 00 00 00       	push   $0x92
  802410:	68 37 3c 80 00       	push   $0x803c37
  802415:	e8 b4 de ff ff       	call   8002ce <_panic>
  80241a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241d:	8b 00                	mov    (%eax),%eax
  80241f:	85 c0                	test   %eax,%eax
  802421:	74 10                	je     802433 <alloc_block_FF+0x5e>
  802423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802426:	8b 00                	mov    (%eax),%eax
  802428:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80242b:	8b 52 04             	mov    0x4(%edx),%edx
  80242e:	89 50 04             	mov    %edx,0x4(%eax)
  802431:	eb 0b                	jmp    80243e <alloc_block_FF+0x69>
  802433:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802436:	8b 40 04             	mov    0x4(%eax),%eax
  802439:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80243e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802441:	8b 40 04             	mov    0x4(%eax),%eax
  802444:	85 c0                	test   %eax,%eax
  802446:	74 0f                	je     802457 <alloc_block_FF+0x82>
  802448:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244b:	8b 40 04             	mov    0x4(%eax),%eax
  80244e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802451:	8b 12                	mov    (%edx),%edx
  802453:	89 10                	mov    %edx,(%eax)
  802455:	eb 0a                	jmp    802461 <alloc_block_FF+0x8c>
  802457:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245a:	8b 00                	mov    (%eax),%eax
  80245c:	a3 38 41 80 00       	mov    %eax,0x804138
  802461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802464:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80246a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802474:	a1 44 41 80 00       	mov    0x804144,%eax
  802479:	48                   	dec    %eax
  80247a:	a3 44 41 80 00       	mov    %eax,0x804144
			  return temp;
  80247f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802482:	e9 ff 01 00 00       	jmp    802686 <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  802487:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248a:	8b 40 0c             	mov    0xc(%eax),%eax
  80248d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802490:	0f 86 b5 01 00 00    	jbe    80264b <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  802496:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802499:	8b 40 0c             	mov    0xc(%eax),%eax
  80249c:	2b 45 08             	sub    0x8(%ebp),%eax
  80249f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  8024a2:	a1 48 41 80 00       	mov    0x804148,%eax
  8024a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  8024aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8024ae:	75 17                	jne    8024c7 <alloc_block_FF+0xf2>
  8024b0:	83 ec 04             	sub    $0x4,%esp
  8024b3:	68 a8 3c 80 00       	push   $0x803ca8
  8024b8:	68 99 00 00 00       	push   $0x99
  8024bd:	68 37 3c 80 00       	push   $0x803c37
  8024c2:	e8 07 de ff ff       	call   8002ce <_panic>
  8024c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024ca:	8b 00                	mov    (%eax),%eax
  8024cc:	85 c0                	test   %eax,%eax
  8024ce:	74 10                	je     8024e0 <alloc_block_FF+0x10b>
  8024d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024d3:	8b 00                	mov    (%eax),%eax
  8024d5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024d8:	8b 52 04             	mov    0x4(%edx),%edx
  8024db:	89 50 04             	mov    %edx,0x4(%eax)
  8024de:	eb 0b                	jmp    8024eb <alloc_block_FF+0x116>
  8024e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024e3:	8b 40 04             	mov    0x4(%eax),%eax
  8024e6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8024eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024ee:	8b 40 04             	mov    0x4(%eax),%eax
  8024f1:	85 c0                	test   %eax,%eax
  8024f3:	74 0f                	je     802504 <alloc_block_FF+0x12f>
  8024f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024f8:	8b 40 04             	mov    0x4(%eax),%eax
  8024fb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024fe:	8b 12                	mov    (%edx),%edx
  802500:	89 10                	mov    %edx,(%eax)
  802502:	eb 0a                	jmp    80250e <alloc_block_FF+0x139>
  802504:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802507:	8b 00                	mov    (%eax),%eax
  802509:	a3 48 41 80 00       	mov    %eax,0x804148
  80250e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802511:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802517:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80251a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802521:	a1 54 41 80 00       	mov    0x804154,%eax
  802526:	48                   	dec    %eax
  802527:	a3 54 41 80 00       	mov    %eax,0x804154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  80252c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802530:	75 17                	jne    802549 <alloc_block_FF+0x174>
  802532:	83 ec 04             	sub    $0x4,%esp
  802535:	68 50 3c 80 00       	push   $0x803c50
  80253a:	68 9a 00 00 00       	push   $0x9a
  80253f:	68 37 3c 80 00       	push   $0x803c37
  802544:	e8 85 dd ff ff       	call   8002ce <_panic>
  802549:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  80254f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802552:	89 50 04             	mov    %edx,0x4(%eax)
  802555:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802558:	8b 40 04             	mov    0x4(%eax),%eax
  80255b:	85 c0                	test   %eax,%eax
  80255d:	74 0c                	je     80256b <alloc_block_FF+0x196>
  80255f:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802564:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802567:	89 10                	mov    %edx,(%eax)
  802569:	eb 08                	jmp    802573 <alloc_block_FF+0x19e>
  80256b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80256e:	a3 38 41 80 00       	mov    %eax,0x804138
  802573:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802576:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80257b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80257e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802584:	a1 44 41 80 00       	mov    0x804144,%eax
  802589:	40                   	inc    %eax
  80258a:	a3 44 41 80 00       	mov    %eax,0x804144
		  // setting the size & sva
		  new_block->size=size;
  80258f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802592:	8b 55 08             	mov    0x8(%ebp),%edx
  802595:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  802598:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259b:	8b 50 08             	mov    0x8(%eax),%edx
  80259e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025a1:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  8025a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025aa:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  8025ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b0:	8b 50 08             	mov    0x8(%eax),%edx
  8025b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b6:	01 c2                	add    %eax,%edx
  8025b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bb:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  8025be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025c1:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  8025c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025c8:	75 17                	jne    8025e1 <alloc_block_FF+0x20c>
  8025ca:	83 ec 04             	sub    $0x4,%esp
  8025cd:	68 a8 3c 80 00       	push   $0x803ca8
  8025d2:	68 a2 00 00 00       	push   $0xa2
  8025d7:	68 37 3c 80 00       	push   $0x803c37
  8025dc:	e8 ed dc ff ff       	call   8002ce <_panic>
  8025e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e4:	8b 00                	mov    (%eax),%eax
  8025e6:	85 c0                	test   %eax,%eax
  8025e8:	74 10                	je     8025fa <alloc_block_FF+0x225>
  8025ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ed:	8b 00                	mov    (%eax),%eax
  8025ef:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025f2:	8b 52 04             	mov    0x4(%edx),%edx
  8025f5:	89 50 04             	mov    %edx,0x4(%eax)
  8025f8:	eb 0b                	jmp    802605 <alloc_block_FF+0x230>
  8025fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025fd:	8b 40 04             	mov    0x4(%eax),%eax
  802600:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802605:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802608:	8b 40 04             	mov    0x4(%eax),%eax
  80260b:	85 c0                	test   %eax,%eax
  80260d:	74 0f                	je     80261e <alloc_block_FF+0x249>
  80260f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802612:	8b 40 04             	mov    0x4(%eax),%eax
  802615:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802618:	8b 12                	mov    (%edx),%edx
  80261a:	89 10                	mov    %edx,(%eax)
  80261c:	eb 0a                	jmp    802628 <alloc_block_FF+0x253>
  80261e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802621:	8b 00                	mov    (%eax),%eax
  802623:	a3 38 41 80 00       	mov    %eax,0x804138
  802628:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80262b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802631:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802634:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80263b:	a1 44 41 80 00       	mov    0x804144,%eax
  802640:	48                   	dec    %eax
  802641:	a3 44 41 80 00       	mov    %eax,0x804144
		  return temp;
  802646:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802649:	eb 3b                	jmp    802686 <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  80264b:	a1 40 41 80 00       	mov    0x804140,%eax
  802650:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802653:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802657:	74 07                	je     802660 <alloc_block_FF+0x28b>
  802659:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265c:	8b 00                	mov    (%eax),%eax
  80265e:	eb 05                	jmp    802665 <alloc_block_FF+0x290>
  802660:	b8 00 00 00 00       	mov    $0x0,%eax
  802665:	a3 40 41 80 00       	mov    %eax,0x804140
  80266a:	a1 40 41 80 00       	mov    0x804140,%eax
  80266f:	85 c0                	test   %eax,%eax
  802671:	0f 85 71 fd ff ff    	jne    8023e8 <alloc_block_FF+0x13>
  802677:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80267b:	0f 85 67 fd ff ff    	jne    8023e8 <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  802681:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802686:	c9                   	leave  
  802687:	c3                   	ret    

00802688 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802688:	55                   	push   %ebp
  802689:	89 e5                	mov    %esp,%ebp
  80268b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  80268e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  802695:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  80269c:	a1 38 41 80 00       	mov    0x804138,%eax
  8026a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8026a4:	e9 d3 00 00 00       	jmp    80277c <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  8026a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8026af:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026b2:	0f 85 90 00 00 00    	jne    802748 <alloc_block_BF+0xc0>
	   temp = element;
  8026b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026bb:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  8026be:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026c2:	75 17                	jne    8026db <alloc_block_BF+0x53>
  8026c4:	83 ec 04             	sub    $0x4,%esp
  8026c7:	68 a8 3c 80 00       	push   $0x803ca8
  8026cc:	68 bd 00 00 00       	push   $0xbd
  8026d1:	68 37 3c 80 00       	push   $0x803c37
  8026d6:	e8 f3 db ff ff       	call   8002ce <_panic>
  8026db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026de:	8b 00                	mov    (%eax),%eax
  8026e0:	85 c0                	test   %eax,%eax
  8026e2:	74 10                	je     8026f4 <alloc_block_BF+0x6c>
  8026e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026e7:	8b 00                	mov    (%eax),%eax
  8026e9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026ec:	8b 52 04             	mov    0x4(%edx),%edx
  8026ef:	89 50 04             	mov    %edx,0x4(%eax)
  8026f2:	eb 0b                	jmp    8026ff <alloc_block_BF+0x77>
  8026f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026f7:	8b 40 04             	mov    0x4(%eax),%eax
  8026fa:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802702:	8b 40 04             	mov    0x4(%eax),%eax
  802705:	85 c0                	test   %eax,%eax
  802707:	74 0f                	je     802718 <alloc_block_BF+0x90>
  802709:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80270c:	8b 40 04             	mov    0x4(%eax),%eax
  80270f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802712:	8b 12                	mov    (%edx),%edx
  802714:	89 10                	mov    %edx,(%eax)
  802716:	eb 0a                	jmp    802722 <alloc_block_BF+0x9a>
  802718:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80271b:	8b 00                	mov    (%eax),%eax
  80271d:	a3 38 41 80 00       	mov    %eax,0x804138
  802722:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802725:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80272b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80272e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802735:	a1 44 41 80 00       	mov    0x804144,%eax
  80273a:	48                   	dec    %eax
  80273b:	a3 44 41 80 00       	mov    %eax,0x804144
	   return temp;
  802740:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802743:	e9 41 01 00 00       	jmp    802889 <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  802748:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80274b:	8b 40 0c             	mov    0xc(%eax),%eax
  80274e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802751:	76 21                	jbe    802774 <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  802753:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802756:	8b 40 0c             	mov    0xc(%eax),%eax
  802759:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80275c:	73 16                	jae    802774 <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  80275e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802761:	8b 40 0c             	mov    0xc(%eax),%eax
  802764:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  802767:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80276a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  80276d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802774:	a1 40 41 80 00       	mov    0x804140,%eax
  802779:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80277c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802780:	74 07                	je     802789 <alloc_block_BF+0x101>
  802782:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802785:	8b 00                	mov    (%eax),%eax
  802787:	eb 05                	jmp    80278e <alloc_block_BF+0x106>
  802789:	b8 00 00 00 00       	mov    $0x0,%eax
  80278e:	a3 40 41 80 00       	mov    %eax,0x804140
  802793:	a1 40 41 80 00       	mov    0x804140,%eax
  802798:	85 c0                	test   %eax,%eax
  80279a:	0f 85 09 ff ff ff    	jne    8026a9 <alloc_block_BF+0x21>
  8027a0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8027a4:	0f 85 ff fe ff ff    	jne    8026a9 <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  8027aa:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  8027ae:	0f 85 d0 00 00 00    	jne    802884 <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  8027b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ba:	2b 45 08             	sub    0x8(%ebp),%eax
  8027bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  8027c0:	a1 48 41 80 00       	mov    0x804148,%eax
  8027c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  8027c8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8027cc:	75 17                	jne    8027e5 <alloc_block_BF+0x15d>
  8027ce:	83 ec 04             	sub    $0x4,%esp
  8027d1:	68 a8 3c 80 00       	push   $0x803ca8
  8027d6:	68 d1 00 00 00       	push   $0xd1
  8027db:	68 37 3c 80 00       	push   $0x803c37
  8027e0:	e8 e9 da ff ff       	call   8002ce <_panic>
  8027e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027e8:	8b 00                	mov    (%eax),%eax
  8027ea:	85 c0                	test   %eax,%eax
  8027ec:	74 10                	je     8027fe <alloc_block_BF+0x176>
  8027ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027f1:	8b 00                	mov    (%eax),%eax
  8027f3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027f6:	8b 52 04             	mov    0x4(%edx),%edx
  8027f9:	89 50 04             	mov    %edx,0x4(%eax)
  8027fc:	eb 0b                	jmp    802809 <alloc_block_BF+0x181>
  8027fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802801:	8b 40 04             	mov    0x4(%eax),%eax
  802804:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802809:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80280c:	8b 40 04             	mov    0x4(%eax),%eax
  80280f:	85 c0                	test   %eax,%eax
  802811:	74 0f                	je     802822 <alloc_block_BF+0x19a>
  802813:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802816:	8b 40 04             	mov    0x4(%eax),%eax
  802819:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80281c:	8b 12                	mov    (%edx),%edx
  80281e:	89 10                	mov    %edx,(%eax)
  802820:	eb 0a                	jmp    80282c <alloc_block_BF+0x1a4>
  802822:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802825:	8b 00                	mov    (%eax),%eax
  802827:	a3 48 41 80 00       	mov    %eax,0x804148
  80282c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80282f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802835:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802838:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80283f:	a1 54 41 80 00       	mov    0x804154,%eax
  802844:	48                   	dec    %eax
  802845:	a3 54 41 80 00       	mov    %eax,0x804154
	  // setting the size & sva
	  new_block->size = size;
  80284a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80284d:	8b 55 08             	mov    0x8(%ebp),%edx
  802850:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  802853:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802856:	8b 50 08             	mov    0x8(%eax),%edx
  802859:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80285c:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  80285f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802862:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802865:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  802868:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80286b:	8b 50 08             	mov    0x8(%eax),%edx
  80286e:	8b 45 08             	mov    0x8(%ebp),%eax
  802871:	01 c2                	add    %eax,%edx
  802873:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802876:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  802879:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80287c:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  80287f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802882:	eb 05                	jmp    802889 <alloc_block_BF+0x201>
	 }
	 return NULL;
  802884:	b8 00 00 00 00       	mov    $0x0,%eax


}
  802889:	c9                   	leave  
  80288a:	c3                   	ret    

0080288b <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80288b:	55                   	push   %ebp
  80288c:	89 e5                	mov    %esp,%ebp
  80288e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802891:	83 ec 04             	sub    $0x4,%esp
  802894:	68 c8 3c 80 00       	push   $0x803cc8
  802899:	68 e8 00 00 00       	push   $0xe8
  80289e:	68 37 3c 80 00       	push   $0x803c37
  8028a3:	e8 26 da ff ff       	call   8002ce <_panic>

008028a8 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8028a8:	55                   	push   %ebp
  8028a9:	89 e5                	mov    %esp,%ebp
  8028ab:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  8028ae:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8028b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  8028b6:	a1 38 41 80 00       	mov    0x804138,%eax
  8028bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  8028be:	a1 44 41 80 00       	mov    0x804144,%eax
  8028c3:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  8028c6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028ca:	75 68                	jne    802934 <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8028cc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028d0:	75 17                	jne    8028e9 <insert_sorted_with_merge_freeList+0x41>
  8028d2:	83 ec 04             	sub    $0x4,%esp
  8028d5:	68 14 3c 80 00       	push   $0x803c14
  8028da:	68 36 01 00 00       	push   $0x136
  8028df:	68 37 3c 80 00       	push   $0x803c37
  8028e4:	e8 e5 d9 ff ff       	call   8002ce <_panic>
  8028e9:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8028ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f2:	89 10                	mov    %edx,(%eax)
  8028f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f7:	8b 00                	mov    (%eax),%eax
  8028f9:	85 c0                	test   %eax,%eax
  8028fb:	74 0d                	je     80290a <insert_sorted_with_merge_freeList+0x62>
  8028fd:	a1 38 41 80 00       	mov    0x804138,%eax
  802902:	8b 55 08             	mov    0x8(%ebp),%edx
  802905:	89 50 04             	mov    %edx,0x4(%eax)
  802908:	eb 08                	jmp    802912 <insert_sorted_with_merge_freeList+0x6a>
  80290a:	8b 45 08             	mov    0x8(%ebp),%eax
  80290d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802912:	8b 45 08             	mov    0x8(%ebp),%eax
  802915:	a3 38 41 80 00       	mov    %eax,0x804138
  80291a:	8b 45 08             	mov    0x8(%ebp),%eax
  80291d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802924:	a1 44 41 80 00       	mov    0x804144,%eax
  802929:	40                   	inc    %eax
  80292a:	a3 44 41 80 00       	mov    %eax,0x804144





}
  80292f:	e9 ba 06 00 00       	jmp    802fee <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  802934:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802937:	8b 50 08             	mov    0x8(%eax),%edx
  80293a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293d:	8b 40 0c             	mov    0xc(%eax),%eax
  802940:	01 c2                	add    %eax,%edx
  802942:	8b 45 08             	mov    0x8(%ebp),%eax
  802945:	8b 40 08             	mov    0x8(%eax),%eax
  802948:	39 c2                	cmp    %eax,%edx
  80294a:	73 68                	jae    8029b4 <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80294c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802950:	75 17                	jne    802969 <insert_sorted_with_merge_freeList+0xc1>
  802952:	83 ec 04             	sub    $0x4,%esp
  802955:	68 50 3c 80 00       	push   $0x803c50
  80295a:	68 3a 01 00 00       	push   $0x13a
  80295f:	68 37 3c 80 00       	push   $0x803c37
  802964:	e8 65 d9 ff ff       	call   8002ce <_panic>
  802969:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  80296f:	8b 45 08             	mov    0x8(%ebp),%eax
  802972:	89 50 04             	mov    %edx,0x4(%eax)
  802975:	8b 45 08             	mov    0x8(%ebp),%eax
  802978:	8b 40 04             	mov    0x4(%eax),%eax
  80297b:	85 c0                	test   %eax,%eax
  80297d:	74 0c                	je     80298b <insert_sorted_with_merge_freeList+0xe3>
  80297f:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802984:	8b 55 08             	mov    0x8(%ebp),%edx
  802987:	89 10                	mov    %edx,(%eax)
  802989:	eb 08                	jmp    802993 <insert_sorted_with_merge_freeList+0xeb>
  80298b:	8b 45 08             	mov    0x8(%ebp),%eax
  80298e:	a3 38 41 80 00       	mov    %eax,0x804138
  802993:	8b 45 08             	mov    0x8(%ebp),%eax
  802996:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80299b:	8b 45 08             	mov    0x8(%ebp),%eax
  80299e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029a4:	a1 44 41 80 00       	mov    0x804144,%eax
  8029a9:	40                   	inc    %eax
  8029aa:	a3 44 41 80 00       	mov    %eax,0x804144





}
  8029af:	e9 3a 06 00 00       	jmp    802fee <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  8029b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b7:	8b 50 08             	mov    0x8(%eax),%edx
  8029ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8029c0:	01 c2                	add    %eax,%edx
  8029c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c5:	8b 40 08             	mov    0x8(%eax),%eax
  8029c8:	39 c2                	cmp    %eax,%edx
  8029ca:	0f 85 90 00 00 00    	jne    802a60 <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  8029d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d3:	8b 50 0c             	mov    0xc(%eax),%edx
  8029d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8029dc:	01 c2                	add    %eax,%edx
  8029de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e1:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  8029e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  8029ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8029f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029fc:	75 17                	jne    802a15 <insert_sorted_with_merge_freeList+0x16d>
  8029fe:	83 ec 04             	sub    $0x4,%esp
  802a01:	68 14 3c 80 00       	push   $0x803c14
  802a06:	68 41 01 00 00       	push   $0x141
  802a0b:	68 37 3c 80 00       	push   $0x803c37
  802a10:	e8 b9 d8 ff ff       	call   8002ce <_panic>
  802a15:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1e:	89 10                	mov    %edx,(%eax)
  802a20:	8b 45 08             	mov    0x8(%ebp),%eax
  802a23:	8b 00                	mov    (%eax),%eax
  802a25:	85 c0                	test   %eax,%eax
  802a27:	74 0d                	je     802a36 <insert_sorted_with_merge_freeList+0x18e>
  802a29:	a1 48 41 80 00       	mov    0x804148,%eax
  802a2e:	8b 55 08             	mov    0x8(%ebp),%edx
  802a31:	89 50 04             	mov    %edx,0x4(%eax)
  802a34:	eb 08                	jmp    802a3e <insert_sorted_with_merge_freeList+0x196>
  802a36:	8b 45 08             	mov    0x8(%ebp),%eax
  802a39:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a41:	a3 48 41 80 00       	mov    %eax,0x804148
  802a46:	8b 45 08             	mov    0x8(%ebp),%eax
  802a49:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a50:	a1 54 41 80 00       	mov    0x804154,%eax
  802a55:	40                   	inc    %eax
  802a56:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802a5b:	e9 8e 05 00 00       	jmp    802fee <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  802a60:	8b 45 08             	mov    0x8(%ebp),%eax
  802a63:	8b 50 08             	mov    0x8(%eax),%edx
  802a66:	8b 45 08             	mov    0x8(%ebp),%eax
  802a69:	8b 40 0c             	mov    0xc(%eax),%eax
  802a6c:	01 c2                	add    %eax,%edx
  802a6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a71:	8b 40 08             	mov    0x8(%eax),%eax
  802a74:	39 c2                	cmp    %eax,%edx
  802a76:	73 68                	jae    802ae0 <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802a78:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a7c:	75 17                	jne    802a95 <insert_sorted_with_merge_freeList+0x1ed>
  802a7e:	83 ec 04             	sub    $0x4,%esp
  802a81:	68 14 3c 80 00       	push   $0x803c14
  802a86:	68 45 01 00 00       	push   $0x145
  802a8b:	68 37 3c 80 00       	push   $0x803c37
  802a90:	e8 39 d8 ff ff       	call   8002ce <_panic>
  802a95:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9e:	89 10                	mov    %edx,(%eax)
  802aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa3:	8b 00                	mov    (%eax),%eax
  802aa5:	85 c0                	test   %eax,%eax
  802aa7:	74 0d                	je     802ab6 <insert_sorted_with_merge_freeList+0x20e>
  802aa9:	a1 38 41 80 00       	mov    0x804138,%eax
  802aae:	8b 55 08             	mov    0x8(%ebp),%edx
  802ab1:	89 50 04             	mov    %edx,0x4(%eax)
  802ab4:	eb 08                	jmp    802abe <insert_sorted_with_merge_freeList+0x216>
  802ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802abe:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac1:	a3 38 41 80 00       	mov    %eax,0x804138
  802ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ad0:	a1 44 41 80 00       	mov    0x804144,%eax
  802ad5:	40                   	inc    %eax
  802ad6:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802adb:	e9 0e 05 00 00       	jmp    802fee <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  802ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae3:	8b 50 08             	mov    0x8(%eax),%edx
  802ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae9:	8b 40 0c             	mov    0xc(%eax),%eax
  802aec:	01 c2                	add    %eax,%edx
  802aee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af1:	8b 40 08             	mov    0x8(%eax),%eax
  802af4:	39 c2                	cmp    %eax,%edx
  802af6:	0f 85 9c 00 00 00    	jne    802b98 <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  802afc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aff:	8b 50 0c             	mov    0xc(%eax),%edx
  802b02:	8b 45 08             	mov    0x8(%ebp),%eax
  802b05:	8b 40 0c             	mov    0xc(%eax),%eax
  802b08:	01 c2                	add    %eax,%edx
  802b0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0d:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  802b10:	8b 45 08             	mov    0x8(%ebp),%eax
  802b13:	8b 50 08             	mov    0x8(%eax),%edx
  802b16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b19:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  802b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  802b26:	8b 45 08             	mov    0x8(%ebp),%eax
  802b29:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802b30:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b34:	75 17                	jne    802b4d <insert_sorted_with_merge_freeList+0x2a5>
  802b36:	83 ec 04             	sub    $0x4,%esp
  802b39:	68 14 3c 80 00       	push   $0x803c14
  802b3e:	68 4d 01 00 00       	push   $0x14d
  802b43:	68 37 3c 80 00       	push   $0x803c37
  802b48:	e8 81 d7 ff ff       	call   8002ce <_panic>
  802b4d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b53:	8b 45 08             	mov    0x8(%ebp),%eax
  802b56:	89 10                	mov    %edx,(%eax)
  802b58:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5b:	8b 00                	mov    (%eax),%eax
  802b5d:	85 c0                	test   %eax,%eax
  802b5f:	74 0d                	je     802b6e <insert_sorted_with_merge_freeList+0x2c6>
  802b61:	a1 48 41 80 00       	mov    0x804148,%eax
  802b66:	8b 55 08             	mov    0x8(%ebp),%edx
  802b69:	89 50 04             	mov    %edx,0x4(%eax)
  802b6c:	eb 08                	jmp    802b76 <insert_sorted_with_merge_freeList+0x2ce>
  802b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b71:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b76:	8b 45 08             	mov    0x8(%ebp),%eax
  802b79:	a3 48 41 80 00       	mov    %eax,0x804148
  802b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b81:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b88:	a1 54 41 80 00       	mov    0x804154,%eax
  802b8d:	40                   	inc    %eax
  802b8e:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802b93:	e9 56 04 00 00       	jmp    802fee <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802b98:	a1 38 41 80 00       	mov    0x804138,%eax
  802b9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ba0:	e9 19 04 00 00       	jmp    802fbe <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  802ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba8:	8b 00                	mov    (%eax),%eax
  802baa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb0:	8b 50 08             	mov    0x8(%eax),%edx
  802bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb6:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb9:	01 c2                	add    %eax,%edx
  802bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbe:	8b 40 08             	mov    0x8(%eax),%eax
  802bc1:	39 c2                	cmp    %eax,%edx
  802bc3:	0f 85 ad 01 00 00    	jne    802d76 <insert_sorted_with_merge_freeList+0x4ce>
  802bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcc:	8b 50 08             	mov    0x8(%eax),%edx
  802bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd2:	8b 40 0c             	mov    0xc(%eax),%eax
  802bd5:	01 c2                	add    %eax,%edx
  802bd7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bda:	8b 40 08             	mov    0x8(%eax),%eax
  802bdd:	39 c2                	cmp    %eax,%edx
  802bdf:	0f 85 91 01 00 00    	jne    802d76 <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  802be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be8:	8b 50 0c             	mov    0xc(%eax),%edx
  802beb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bee:	8b 48 0c             	mov    0xc(%eax),%ecx
  802bf1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bf4:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf7:	01 c8                	add    %ecx,%eax
  802bf9:	01 c2                	add    %eax,%edx
  802bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfe:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  802c01:	8b 45 08             	mov    0x8(%ebp),%eax
  802c04:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  802c15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c18:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  802c1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c22:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  802c29:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802c2d:	75 17                	jne    802c46 <insert_sorted_with_merge_freeList+0x39e>
  802c2f:	83 ec 04             	sub    $0x4,%esp
  802c32:	68 a8 3c 80 00       	push   $0x803ca8
  802c37:	68 5b 01 00 00       	push   $0x15b
  802c3c:	68 37 3c 80 00       	push   $0x803c37
  802c41:	e8 88 d6 ff ff       	call   8002ce <_panic>
  802c46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c49:	8b 00                	mov    (%eax),%eax
  802c4b:	85 c0                	test   %eax,%eax
  802c4d:	74 10                	je     802c5f <insert_sorted_with_merge_freeList+0x3b7>
  802c4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c52:	8b 00                	mov    (%eax),%eax
  802c54:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c57:	8b 52 04             	mov    0x4(%edx),%edx
  802c5a:	89 50 04             	mov    %edx,0x4(%eax)
  802c5d:	eb 0b                	jmp    802c6a <insert_sorted_with_merge_freeList+0x3c2>
  802c5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c62:	8b 40 04             	mov    0x4(%eax),%eax
  802c65:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c6d:	8b 40 04             	mov    0x4(%eax),%eax
  802c70:	85 c0                	test   %eax,%eax
  802c72:	74 0f                	je     802c83 <insert_sorted_with_merge_freeList+0x3db>
  802c74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c77:	8b 40 04             	mov    0x4(%eax),%eax
  802c7a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c7d:	8b 12                	mov    (%edx),%edx
  802c7f:	89 10                	mov    %edx,(%eax)
  802c81:	eb 0a                	jmp    802c8d <insert_sorted_with_merge_freeList+0x3e5>
  802c83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c86:	8b 00                	mov    (%eax),%eax
  802c88:	a3 38 41 80 00       	mov    %eax,0x804138
  802c8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c99:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ca0:	a1 44 41 80 00       	mov    0x804144,%eax
  802ca5:	48                   	dec    %eax
  802ca6:	a3 44 41 80 00       	mov    %eax,0x804144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802cab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802caf:	75 17                	jne    802cc8 <insert_sorted_with_merge_freeList+0x420>
  802cb1:	83 ec 04             	sub    $0x4,%esp
  802cb4:	68 14 3c 80 00       	push   $0x803c14
  802cb9:	68 5c 01 00 00       	push   $0x15c
  802cbe:	68 37 3c 80 00       	push   $0x803c37
  802cc3:	e8 06 d6 ff ff       	call   8002ce <_panic>
  802cc8:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802cce:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd1:	89 10                	mov    %edx,(%eax)
  802cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd6:	8b 00                	mov    (%eax),%eax
  802cd8:	85 c0                	test   %eax,%eax
  802cda:	74 0d                	je     802ce9 <insert_sorted_with_merge_freeList+0x441>
  802cdc:	a1 48 41 80 00       	mov    0x804148,%eax
  802ce1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ce4:	89 50 04             	mov    %edx,0x4(%eax)
  802ce7:	eb 08                	jmp    802cf1 <insert_sorted_with_merge_freeList+0x449>
  802ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cec:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf4:	a3 48 41 80 00       	mov    %eax,0x804148
  802cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d03:	a1 54 41 80 00       	mov    0x804154,%eax
  802d08:	40                   	inc    %eax
  802d09:	a3 54 41 80 00       	mov    %eax,0x804154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  802d0e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802d12:	75 17                	jne    802d2b <insert_sorted_with_merge_freeList+0x483>
  802d14:	83 ec 04             	sub    $0x4,%esp
  802d17:	68 14 3c 80 00       	push   $0x803c14
  802d1c:	68 5d 01 00 00       	push   $0x15d
  802d21:	68 37 3c 80 00       	push   $0x803c37
  802d26:	e8 a3 d5 ff ff       	call   8002ce <_panic>
  802d2b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d34:	89 10                	mov    %edx,(%eax)
  802d36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d39:	8b 00                	mov    (%eax),%eax
  802d3b:	85 c0                	test   %eax,%eax
  802d3d:	74 0d                	je     802d4c <insert_sorted_with_merge_freeList+0x4a4>
  802d3f:	a1 48 41 80 00       	mov    0x804148,%eax
  802d44:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d47:	89 50 04             	mov    %edx,0x4(%eax)
  802d4a:	eb 08                	jmp    802d54 <insert_sorted_with_merge_freeList+0x4ac>
  802d4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d4f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d57:	a3 48 41 80 00       	mov    %eax,0x804148
  802d5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d5f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d66:	a1 54 41 80 00       	mov    0x804154,%eax
  802d6b:	40                   	inc    %eax
  802d6c:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802d71:	e9 78 02 00 00       	jmp    802fee <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802d76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d79:	8b 50 08             	mov    0x8(%eax),%edx
  802d7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7f:	8b 40 0c             	mov    0xc(%eax),%eax
  802d82:	01 c2                	add    %eax,%edx
  802d84:	8b 45 08             	mov    0x8(%ebp),%eax
  802d87:	8b 40 08             	mov    0x8(%eax),%eax
  802d8a:	39 c2                	cmp    %eax,%edx
  802d8c:	0f 83 b8 00 00 00    	jae    802e4a <insert_sorted_with_merge_freeList+0x5a2>
  802d92:	8b 45 08             	mov    0x8(%ebp),%eax
  802d95:	8b 50 08             	mov    0x8(%eax),%edx
  802d98:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d9e:	01 c2                	add    %eax,%edx
  802da0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802da3:	8b 40 08             	mov    0x8(%eax),%eax
  802da6:	39 c2                	cmp    %eax,%edx
  802da8:	0f 85 9c 00 00 00    	jne    802e4a <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  802dae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802db1:	8b 50 0c             	mov    0xc(%eax),%edx
  802db4:	8b 45 08             	mov    0x8(%ebp),%eax
  802db7:	8b 40 0c             	mov    0xc(%eax),%eax
  802dba:	01 c2                	add    %eax,%edx
  802dbc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dbf:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  802dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc5:	8b 50 08             	mov    0x8(%eax),%edx
  802dc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dcb:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  802dce:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802de2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802de6:	75 17                	jne    802dff <insert_sorted_with_merge_freeList+0x557>
  802de8:	83 ec 04             	sub    $0x4,%esp
  802deb:	68 14 3c 80 00       	push   $0x803c14
  802df0:	68 67 01 00 00       	push   $0x167
  802df5:	68 37 3c 80 00       	push   $0x803c37
  802dfa:	e8 cf d4 ff ff       	call   8002ce <_panic>
  802dff:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e05:	8b 45 08             	mov    0x8(%ebp),%eax
  802e08:	89 10                	mov    %edx,(%eax)
  802e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0d:	8b 00                	mov    (%eax),%eax
  802e0f:	85 c0                	test   %eax,%eax
  802e11:	74 0d                	je     802e20 <insert_sorted_with_merge_freeList+0x578>
  802e13:	a1 48 41 80 00       	mov    0x804148,%eax
  802e18:	8b 55 08             	mov    0x8(%ebp),%edx
  802e1b:	89 50 04             	mov    %edx,0x4(%eax)
  802e1e:	eb 08                	jmp    802e28 <insert_sorted_with_merge_freeList+0x580>
  802e20:	8b 45 08             	mov    0x8(%ebp),%eax
  802e23:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e28:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2b:	a3 48 41 80 00       	mov    %eax,0x804148
  802e30:	8b 45 08             	mov    0x8(%ebp),%eax
  802e33:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e3a:	a1 54 41 80 00       	mov    0x804154,%eax
  802e3f:	40                   	inc    %eax
  802e40:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802e45:	e9 a4 01 00 00       	jmp    802fee <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4d:	8b 50 08             	mov    0x8(%eax),%edx
  802e50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e53:	8b 40 0c             	mov    0xc(%eax),%eax
  802e56:	01 c2                	add    %eax,%edx
  802e58:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5b:	8b 40 08             	mov    0x8(%eax),%eax
  802e5e:	39 c2                	cmp    %eax,%edx
  802e60:	0f 85 ac 00 00 00    	jne    802f12 <insert_sorted_with_merge_freeList+0x66a>
  802e66:	8b 45 08             	mov    0x8(%ebp),%eax
  802e69:	8b 50 08             	mov    0x8(%eax),%edx
  802e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e72:	01 c2                	add    %eax,%edx
  802e74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e77:	8b 40 08             	mov    0x8(%eax),%eax
  802e7a:	39 c2                	cmp    %eax,%edx
  802e7c:	0f 83 90 00 00 00    	jae    802f12 <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  802e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e85:	8b 50 0c             	mov    0xc(%eax),%edx
  802e88:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e8e:	01 c2                	add    %eax,%edx
  802e90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e93:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  802e96:	8b 45 08             	mov    0x8(%ebp),%eax
  802e99:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  802ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802eaa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eae:	75 17                	jne    802ec7 <insert_sorted_with_merge_freeList+0x61f>
  802eb0:	83 ec 04             	sub    $0x4,%esp
  802eb3:	68 14 3c 80 00       	push   $0x803c14
  802eb8:	68 70 01 00 00       	push   $0x170
  802ebd:	68 37 3c 80 00       	push   $0x803c37
  802ec2:	e8 07 d4 ff ff       	call   8002ce <_panic>
  802ec7:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed0:	89 10                	mov    %edx,(%eax)
  802ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed5:	8b 00                	mov    (%eax),%eax
  802ed7:	85 c0                	test   %eax,%eax
  802ed9:	74 0d                	je     802ee8 <insert_sorted_with_merge_freeList+0x640>
  802edb:	a1 48 41 80 00       	mov    0x804148,%eax
  802ee0:	8b 55 08             	mov    0x8(%ebp),%edx
  802ee3:	89 50 04             	mov    %edx,0x4(%eax)
  802ee6:	eb 08                	jmp    802ef0 <insert_sorted_with_merge_freeList+0x648>
  802ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  802eeb:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef3:	a3 48 41 80 00       	mov    %eax,0x804148
  802ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  802efb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f02:	a1 54 41 80 00       	mov    0x804154,%eax
  802f07:	40                   	inc    %eax
  802f08:	a3 54 41 80 00       	mov    %eax,0x804154
	      break;
  802f0d:	e9 dc 00 00 00       	jmp    802fee <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f15:	8b 50 08             	mov    0x8(%eax),%edx
  802f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f1e:	01 c2                	add    %eax,%edx
  802f20:	8b 45 08             	mov    0x8(%ebp),%eax
  802f23:	8b 40 08             	mov    0x8(%eax),%eax
  802f26:	39 c2                	cmp    %eax,%edx
  802f28:	0f 83 88 00 00 00    	jae    802fb6 <insert_sorted_with_merge_freeList+0x70e>
  802f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f31:	8b 50 08             	mov    0x8(%eax),%edx
  802f34:	8b 45 08             	mov    0x8(%ebp),%eax
  802f37:	8b 40 0c             	mov    0xc(%eax),%eax
  802f3a:	01 c2                	add    %eax,%edx
  802f3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f3f:	8b 40 08             	mov    0x8(%eax),%eax
  802f42:	39 c2                	cmp    %eax,%edx
  802f44:	73 70                	jae    802fb6 <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  802f46:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f4a:	74 06                	je     802f52 <insert_sorted_with_merge_freeList+0x6aa>
  802f4c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f50:	75 17                	jne    802f69 <insert_sorted_with_merge_freeList+0x6c1>
  802f52:	83 ec 04             	sub    $0x4,%esp
  802f55:	68 74 3c 80 00       	push   $0x803c74
  802f5a:	68 75 01 00 00       	push   $0x175
  802f5f:	68 37 3c 80 00       	push   $0x803c37
  802f64:	e8 65 d3 ff ff       	call   8002ce <_panic>
  802f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6c:	8b 10                	mov    (%eax),%edx
  802f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f71:	89 10                	mov    %edx,(%eax)
  802f73:	8b 45 08             	mov    0x8(%ebp),%eax
  802f76:	8b 00                	mov    (%eax),%eax
  802f78:	85 c0                	test   %eax,%eax
  802f7a:	74 0b                	je     802f87 <insert_sorted_with_merge_freeList+0x6df>
  802f7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7f:	8b 00                	mov    (%eax),%eax
  802f81:	8b 55 08             	mov    0x8(%ebp),%edx
  802f84:	89 50 04             	mov    %edx,0x4(%eax)
  802f87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8a:	8b 55 08             	mov    0x8(%ebp),%edx
  802f8d:	89 10                	mov    %edx,(%eax)
  802f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f92:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f95:	89 50 04             	mov    %edx,0x4(%eax)
  802f98:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9b:	8b 00                	mov    (%eax),%eax
  802f9d:	85 c0                	test   %eax,%eax
  802f9f:	75 08                	jne    802fa9 <insert_sorted_with_merge_freeList+0x701>
  802fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802fa9:	a1 44 41 80 00       	mov    0x804144,%eax
  802fae:	40                   	inc    %eax
  802faf:	a3 44 41 80 00       	mov    %eax,0x804144
	      break;
  802fb4:	eb 38                	jmp    802fee <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802fb6:	a1 40 41 80 00       	mov    0x804140,%eax
  802fbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fbe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fc2:	74 07                	je     802fcb <insert_sorted_with_merge_freeList+0x723>
  802fc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc7:	8b 00                	mov    (%eax),%eax
  802fc9:	eb 05                	jmp    802fd0 <insert_sorted_with_merge_freeList+0x728>
  802fcb:	b8 00 00 00 00       	mov    $0x0,%eax
  802fd0:	a3 40 41 80 00       	mov    %eax,0x804140
  802fd5:	a1 40 41 80 00       	mov    0x804140,%eax
  802fda:	85 c0                	test   %eax,%eax
  802fdc:	0f 85 c3 fb ff ff    	jne    802ba5 <insert_sorted_with_merge_freeList+0x2fd>
  802fe2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fe6:	0f 85 b9 fb ff ff    	jne    802ba5 <insert_sorted_with_merge_freeList+0x2fd>





}
  802fec:	eb 00                	jmp    802fee <insert_sorted_with_merge_freeList+0x746>
  802fee:	90                   	nop
  802fef:	c9                   	leave  
  802ff0:	c3                   	ret    

00802ff1 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802ff1:	55                   	push   %ebp
  802ff2:	89 e5                	mov    %esp,%ebp
  802ff4:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  802ff7:	8b 55 08             	mov    0x8(%ebp),%edx
  802ffa:	89 d0                	mov    %edx,%eax
  802ffc:	c1 e0 02             	shl    $0x2,%eax
  802fff:	01 d0                	add    %edx,%eax
  803001:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803008:	01 d0                	add    %edx,%eax
  80300a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803011:	01 d0                	add    %edx,%eax
  803013:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80301a:	01 d0                	add    %edx,%eax
  80301c:	c1 e0 04             	shl    $0x4,%eax
  80301f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803022:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803029:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80302c:	83 ec 0c             	sub    $0xc,%esp
  80302f:	50                   	push   %eax
  803030:	e8 31 ec ff ff       	call   801c66 <sys_get_virtual_time>
  803035:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803038:	eb 41                	jmp    80307b <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80303a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80303d:	83 ec 0c             	sub    $0xc,%esp
  803040:	50                   	push   %eax
  803041:	e8 20 ec ff ff       	call   801c66 <sys_get_virtual_time>
  803046:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803049:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80304c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80304f:	29 c2                	sub    %eax,%edx
  803051:	89 d0                	mov    %edx,%eax
  803053:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803056:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803059:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80305c:	89 d1                	mov    %edx,%ecx
  80305e:	29 c1                	sub    %eax,%ecx
  803060:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803063:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803066:	39 c2                	cmp    %eax,%edx
  803068:	0f 97 c0             	seta   %al
  80306b:	0f b6 c0             	movzbl %al,%eax
  80306e:	29 c1                	sub    %eax,%ecx
  803070:	89 c8                	mov    %ecx,%eax
  803072:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803075:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803078:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80307b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803081:	72 b7                	jb     80303a <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803083:	90                   	nop
  803084:	c9                   	leave  
  803085:	c3                   	ret    

00803086 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803086:	55                   	push   %ebp
  803087:	89 e5                	mov    %esp,%ebp
  803089:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80308c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803093:	eb 03                	jmp    803098 <busy_wait+0x12>
  803095:	ff 45 fc             	incl   -0x4(%ebp)
  803098:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80309b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80309e:	72 f5                	jb     803095 <busy_wait+0xf>
	return i;
  8030a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8030a3:	c9                   	leave  
  8030a4:	c3                   	ret    
  8030a5:	66 90                	xchg   %ax,%ax
  8030a7:	90                   	nop

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
