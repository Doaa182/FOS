
obj/user/tst_envfree1:     file format elf32-i386


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
  800031:	e8 76 01 00 00       	call   8001ac <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests environment free run tef1 5 3
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	// Testing scenario 1: without using dynamic allocation/de-allocation, shared variables and semaphores
	// Testing removing the allocated pages in mem, WS, mapped page tables, env's directory and env's page file

	int freeFrames_before = sys_calculate_free_frames() ;
  80003e:	e8 cf 13 00 00       	call   801412 <sys_calculate_free_frames>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800046:	e8 67 14 00 00       	call   8014b2 <sys_pf_calculate_allocated_pages>
  80004b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80004e:	83 ec 08             	sub    $0x8,%esp
  800051:	ff 75 f4             	pushl  -0xc(%ebp)
  800054:	68 a0 1c 80 00       	push   $0x801ca0
  800059:	e8 3e 05 00 00       	call   80059c <cprintf>
  80005e:	83 c4 10             	add    $0x10,%esp

	/*[4] CREATE AND RUN ProcessA & ProcessB*/
	//Create 3 processes

	int32 envIdProcessA = sys_create_env("ef_fib", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800061:	a1 20 30 80 00       	mov    0x803020,%eax
  800066:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80006c:	89 c2                	mov    %eax,%edx
  80006e:	a1 20 30 80 00       	mov    0x803020,%eax
  800073:	8b 40 74             	mov    0x74(%eax),%eax
  800076:	6a 32                	push   $0x32
  800078:	52                   	push   %edx
  800079:	50                   	push   %eax
  80007a:	68 d3 1c 80 00       	push   $0x801cd3
  80007f:	e8 00 16 00 00       	call   801684 <sys_create_env>
  800084:	83 c4 10             	add    $0x10,%esp
  800087:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int32 envIdProcessB = sys_create_env("ef_fact", (myEnv->page_WS_max_size)-1,(myEnv->SecondListSize), 50);
  80008a:	a1 20 30 80 00       	mov    0x803020,%eax
  80008f:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800095:	89 c2                	mov    %eax,%edx
  800097:	a1 20 30 80 00       	mov    0x803020,%eax
  80009c:	8b 40 74             	mov    0x74(%eax),%eax
  80009f:	48                   	dec    %eax
  8000a0:	6a 32                	push   $0x32
  8000a2:	52                   	push   %edx
  8000a3:	50                   	push   %eax
  8000a4:	68 da 1c 80 00       	push   $0x801cda
  8000a9:	e8 d6 15 00 00       	call   801684 <sys_create_env>
  8000ae:	83 c4 10             	add    $0x10,%esp
  8000b1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int32 envIdProcessC = sys_create_env("ef_fos_add",(myEnv->page_WS_max_size)*4,(myEnv->SecondListSize), 50);
  8000b4:	a1 20 30 80 00       	mov    0x803020,%eax
  8000b9:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000bf:	89 c2                	mov    %eax,%edx
  8000c1:	a1 20 30 80 00       	mov    0x803020,%eax
  8000c6:	8b 40 74             	mov    0x74(%eax),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	6a 32                	push   $0x32
  8000ce:	52                   	push   %edx
  8000cf:	50                   	push   %eax
  8000d0:	68 e2 1c 80 00       	push   $0x801ce2
  8000d5:	e8 aa 15 00 00       	call   801684 <sys_create_env>
  8000da:	83 c4 10             	add    $0x10,%esp
  8000dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	//Run 3 processes
	sys_run_env(envIdProcessA);
  8000e0:	83 ec 0c             	sub    $0xc,%esp
  8000e3:	ff 75 ec             	pushl  -0x14(%ebp)
  8000e6:	e8 b7 15 00 00       	call   8016a2 <sys_run_env>
  8000eb:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	ff 75 e8             	pushl  -0x18(%ebp)
  8000f4:	e8 a9 15 00 00       	call   8016a2 <sys_run_env>
  8000f9:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessC);
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	ff 75 e4             	pushl  -0x1c(%ebp)
  800102:	e8 9b 15 00 00       	call   8016a2 <sys_run_env>
  800107:	83 c4 10             	add    $0x10,%esp

	env_sleep(6000);
  80010a:	83 ec 0c             	sub    $0xc,%esp
  80010d:	68 70 17 00 00       	push   $0x1770
  800112:	e8 6d 18 00 00       	call   801984 <env_sleep>
  800117:	83 c4 10             	add    $0x10,%esp
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  80011a:	e8 f3 12 00 00       	call   801412 <sys_calculate_free_frames>
  80011f:	83 ec 08             	sub    $0x8,%esp
  800122:	50                   	push   %eax
  800123:	68 f0 1c 80 00       	push   $0x801cf0
  800128:	e8 6f 04 00 00       	call   80059c <cprintf>
  80012d:	83 c4 10             	add    $0x10,%esp

	//Kill the 3 processes
	sys_destroy_env(envIdProcessA);
  800130:	83 ec 0c             	sub    $0xc,%esp
  800133:	ff 75 ec             	pushl  -0x14(%ebp)
  800136:	e8 83 15 00 00       	call   8016be <sys_destroy_env>
  80013b:	83 c4 10             	add    $0x10,%esp
	sys_destroy_env(envIdProcessB);
  80013e:	83 ec 0c             	sub    $0xc,%esp
  800141:	ff 75 e8             	pushl  -0x18(%ebp)
  800144:	e8 75 15 00 00       	call   8016be <sys_destroy_env>
  800149:	83 c4 10             	add    $0x10,%esp
	sys_destroy_env(envIdProcessC);
  80014c:	83 ec 0c             	sub    $0xc,%esp
  80014f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800152:	e8 67 15 00 00       	call   8016be <sys_destroy_env>
  800157:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  80015a:	e8 b3 12 00 00       	call   801412 <sys_calculate_free_frames>
  80015f:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800162:	e8 4b 13 00 00       	call   8014b2 <sys_pf_calculate_allocated_pages>
  800167:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if((freeFrames_after - freeFrames_before) !=0)
  80016a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80016d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800170:	74 14                	je     800186 <_main+0x14e>
		panic("env_free() does not work correctly... check it again.") ;
  800172:	83 ec 04             	sub    $0x4,%esp
  800175:	68 24 1d 80 00       	push   $0x801d24
  80017a:	6a 26                	push   $0x26
  80017c:	68 5a 1d 80 00       	push   $0x801d5a
  800181:	e8 62 01 00 00       	call   8002e8 <_panic>

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  800186:	83 ec 08             	sub    $0x8,%esp
  800189:	ff 75 e0             	pushl  -0x20(%ebp)
  80018c:	68 70 1d 80 00       	push   $0x801d70
  800191:	e8 06 04 00 00       	call   80059c <cprintf>
  800196:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 1 for envfree completed successfully.\n");
  800199:	83 ec 0c             	sub    $0xc,%esp
  80019c:	68 d0 1d 80 00       	push   $0x801dd0
  8001a1:	e8 f6 03 00 00       	call   80059c <cprintf>
  8001a6:	83 c4 10             	add    $0x10,%esp
	return;
  8001a9:	90                   	nop
}
  8001aa:	c9                   	leave  
  8001ab:	c3                   	ret    

008001ac <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001ac:	55                   	push   %ebp
  8001ad:	89 e5                	mov    %esp,%ebp
  8001af:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001b2:	e8 3b 15 00 00       	call   8016f2 <sys_getenvindex>
  8001b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001bd:	89 d0                	mov    %edx,%eax
  8001bf:	c1 e0 03             	shl    $0x3,%eax
  8001c2:	01 d0                	add    %edx,%eax
  8001c4:	01 c0                	add    %eax,%eax
  8001c6:	01 d0                	add    %edx,%eax
  8001c8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001cf:	01 d0                	add    %edx,%eax
  8001d1:	c1 e0 04             	shl    $0x4,%eax
  8001d4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001d9:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001de:	a1 20 30 80 00       	mov    0x803020,%eax
  8001e3:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001e9:	84 c0                	test   %al,%al
  8001eb:	74 0f                	je     8001fc <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001ed:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f2:	05 5c 05 00 00       	add    $0x55c,%eax
  8001f7:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800200:	7e 0a                	jle    80020c <libmain+0x60>
		binaryname = argv[0];
  800202:	8b 45 0c             	mov    0xc(%ebp),%eax
  800205:	8b 00                	mov    (%eax),%eax
  800207:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80020c:	83 ec 08             	sub    $0x8,%esp
  80020f:	ff 75 0c             	pushl  0xc(%ebp)
  800212:	ff 75 08             	pushl  0x8(%ebp)
  800215:	e8 1e fe ff ff       	call   800038 <_main>
  80021a:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80021d:	e8 dd 12 00 00       	call   8014ff <sys_disable_interrupt>
	cprintf("**************************************\n");
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 34 1e 80 00       	push   $0x801e34
  80022a:	e8 6d 03 00 00       	call   80059c <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800232:	a1 20 30 80 00       	mov    0x803020,%eax
  800237:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80023d:	a1 20 30 80 00       	mov    0x803020,%eax
  800242:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800248:	83 ec 04             	sub    $0x4,%esp
  80024b:	52                   	push   %edx
  80024c:	50                   	push   %eax
  80024d:	68 5c 1e 80 00       	push   $0x801e5c
  800252:	e8 45 03 00 00       	call   80059c <cprintf>
  800257:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80025a:	a1 20 30 80 00       	mov    0x803020,%eax
  80025f:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800265:	a1 20 30 80 00       	mov    0x803020,%eax
  80026a:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800270:	a1 20 30 80 00       	mov    0x803020,%eax
  800275:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80027b:	51                   	push   %ecx
  80027c:	52                   	push   %edx
  80027d:	50                   	push   %eax
  80027e:	68 84 1e 80 00       	push   $0x801e84
  800283:	e8 14 03 00 00       	call   80059c <cprintf>
  800288:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80028b:	a1 20 30 80 00       	mov    0x803020,%eax
  800290:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800296:	83 ec 08             	sub    $0x8,%esp
  800299:	50                   	push   %eax
  80029a:	68 dc 1e 80 00       	push   $0x801edc
  80029f:	e8 f8 02 00 00       	call   80059c <cprintf>
  8002a4:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002a7:	83 ec 0c             	sub    $0xc,%esp
  8002aa:	68 34 1e 80 00       	push   $0x801e34
  8002af:	e8 e8 02 00 00       	call   80059c <cprintf>
  8002b4:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002b7:	e8 5d 12 00 00       	call   801519 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002bc:	e8 19 00 00 00       	call   8002da <exit>
}
  8002c1:	90                   	nop
  8002c2:	c9                   	leave  
  8002c3:	c3                   	ret    

008002c4 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002c4:	55                   	push   %ebp
  8002c5:	89 e5                	mov    %esp,%ebp
  8002c7:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002ca:	83 ec 0c             	sub    $0xc,%esp
  8002cd:	6a 00                	push   $0x0
  8002cf:	e8 ea 13 00 00       	call   8016be <sys_destroy_env>
  8002d4:	83 c4 10             	add    $0x10,%esp
}
  8002d7:	90                   	nop
  8002d8:	c9                   	leave  
  8002d9:	c3                   	ret    

008002da <exit>:

void
exit(void)
{
  8002da:	55                   	push   %ebp
  8002db:	89 e5                	mov    %esp,%ebp
  8002dd:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002e0:	e8 3f 14 00 00       	call   801724 <sys_exit_env>
}
  8002e5:	90                   	nop
  8002e6:	c9                   	leave  
  8002e7:	c3                   	ret    

008002e8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002e8:	55                   	push   %ebp
  8002e9:	89 e5                	mov    %esp,%ebp
  8002eb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002ee:	8d 45 10             	lea    0x10(%ebp),%eax
  8002f1:	83 c0 04             	add    $0x4,%eax
  8002f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002f7:	a1 5c 31 80 00       	mov    0x80315c,%eax
  8002fc:	85 c0                	test   %eax,%eax
  8002fe:	74 16                	je     800316 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800300:	a1 5c 31 80 00       	mov    0x80315c,%eax
  800305:	83 ec 08             	sub    $0x8,%esp
  800308:	50                   	push   %eax
  800309:	68 f0 1e 80 00       	push   $0x801ef0
  80030e:	e8 89 02 00 00       	call   80059c <cprintf>
  800313:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800316:	a1 00 30 80 00       	mov    0x803000,%eax
  80031b:	ff 75 0c             	pushl  0xc(%ebp)
  80031e:	ff 75 08             	pushl  0x8(%ebp)
  800321:	50                   	push   %eax
  800322:	68 f5 1e 80 00       	push   $0x801ef5
  800327:	e8 70 02 00 00       	call   80059c <cprintf>
  80032c:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80032f:	8b 45 10             	mov    0x10(%ebp),%eax
  800332:	83 ec 08             	sub    $0x8,%esp
  800335:	ff 75 f4             	pushl  -0xc(%ebp)
  800338:	50                   	push   %eax
  800339:	e8 f3 01 00 00       	call   800531 <vcprintf>
  80033e:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800341:	83 ec 08             	sub    $0x8,%esp
  800344:	6a 00                	push   $0x0
  800346:	68 11 1f 80 00       	push   $0x801f11
  80034b:	e8 e1 01 00 00       	call   800531 <vcprintf>
  800350:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800353:	e8 82 ff ff ff       	call   8002da <exit>

	// should not return here
	while (1) ;
  800358:	eb fe                	jmp    800358 <_panic+0x70>

0080035a <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80035a:	55                   	push   %ebp
  80035b:	89 e5                	mov    %esp,%ebp
  80035d:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800360:	a1 20 30 80 00       	mov    0x803020,%eax
  800365:	8b 50 74             	mov    0x74(%eax),%edx
  800368:	8b 45 0c             	mov    0xc(%ebp),%eax
  80036b:	39 c2                	cmp    %eax,%edx
  80036d:	74 14                	je     800383 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80036f:	83 ec 04             	sub    $0x4,%esp
  800372:	68 14 1f 80 00       	push   $0x801f14
  800377:	6a 26                	push   $0x26
  800379:	68 60 1f 80 00       	push   $0x801f60
  80037e:	e8 65 ff ff ff       	call   8002e8 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800383:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80038a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800391:	e9 c2 00 00 00       	jmp    800458 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800396:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800399:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a3:	01 d0                	add    %edx,%eax
  8003a5:	8b 00                	mov    (%eax),%eax
  8003a7:	85 c0                	test   %eax,%eax
  8003a9:	75 08                	jne    8003b3 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8003ab:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003ae:	e9 a2 00 00 00       	jmp    800455 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8003b3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003ba:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003c1:	eb 69                	jmp    80042c <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003c3:	a1 20 30 80 00       	mov    0x803020,%eax
  8003c8:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003ce:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003d1:	89 d0                	mov    %edx,%eax
  8003d3:	01 c0                	add    %eax,%eax
  8003d5:	01 d0                	add    %edx,%eax
  8003d7:	c1 e0 03             	shl    $0x3,%eax
  8003da:	01 c8                	add    %ecx,%eax
  8003dc:	8a 40 04             	mov    0x4(%eax),%al
  8003df:	84 c0                	test   %al,%al
  8003e1:	75 46                	jne    800429 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003e3:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e8:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003ee:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003f1:	89 d0                	mov    %edx,%eax
  8003f3:	01 c0                	add    %eax,%eax
  8003f5:	01 d0                	add    %edx,%eax
  8003f7:	c1 e0 03             	shl    $0x3,%eax
  8003fa:	01 c8                	add    %ecx,%eax
  8003fc:	8b 00                	mov    (%eax),%eax
  8003fe:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800401:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800404:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800409:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80040b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80040e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800415:	8b 45 08             	mov    0x8(%ebp),%eax
  800418:	01 c8                	add    %ecx,%eax
  80041a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80041c:	39 c2                	cmp    %eax,%edx
  80041e:	75 09                	jne    800429 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800420:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800427:	eb 12                	jmp    80043b <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800429:	ff 45 e8             	incl   -0x18(%ebp)
  80042c:	a1 20 30 80 00       	mov    0x803020,%eax
  800431:	8b 50 74             	mov    0x74(%eax),%edx
  800434:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800437:	39 c2                	cmp    %eax,%edx
  800439:	77 88                	ja     8003c3 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80043b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80043f:	75 14                	jne    800455 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800441:	83 ec 04             	sub    $0x4,%esp
  800444:	68 6c 1f 80 00       	push   $0x801f6c
  800449:	6a 3a                	push   $0x3a
  80044b:	68 60 1f 80 00       	push   $0x801f60
  800450:	e8 93 fe ff ff       	call   8002e8 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800455:	ff 45 f0             	incl   -0x10(%ebp)
  800458:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80045b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80045e:	0f 8c 32 ff ff ff    	jl     800396 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800464:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80046b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800472:	eb 26                	jmp    80049a <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800474:	a1 20 30 80 00       	mov    0x803020,%eax
  800479:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80047f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800482:	89 d0                	mov    %edx,%eax
  800484:	01 c0                	add    %eax,%eax
  800486:	01 d0                	add    %edx,%eax
  800488:	c1 e0 03             	shl    $0x3,%eax
  80048b:	01 c8                	add    %ecx,%eax
  80048d:	8a 40 04             	mov    0x4(%eax),%al
  800490:	3c 01                	cmp    $0x1,%al
  800492:	75 03                	jne    800497 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800494:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800497:	ff 45 e0             	incl   -0x20(%ebp)
  80049a:	a1 20 30 80 00       	mov    0x803020,%eax
  80049f:	8b 50 74             	mov    0x74(%eax),%edx
  8004a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004a5:	39 c2                	cmp    %eax,%edx
  8004a7:	77 cb                	ja     800474 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004ac:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004af:	74 14                	je     8004c5 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8004b1:	83 ec 04             	sub    $0x4,%esp
  8004b4:	68 c0 1f 80 00       	push   $0x801fc0
  8004b9:	6a 44                	push   $0x44
  8004bb:	68 60 1f 80 00       	push   $0x801f60
  8004c0:	e8 23 fe ff ff       	call   8002e8 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004c5:	90                   	nop
  8004c6:	c9                   	leave  
  8004c7:	c3                   	ret    

008004c8 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8004c8:	55                   	push   %ebp
  8004c9:	89 e5                	mov    %esp,%ebp
  8004cb:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d1:	8b 00                	mov    (%eax),%eax
  8004d3:	8d 48 01             	lea    0x1(%eax),%ecx
  8004d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004d9:	89 0a                	mov    %ecx,(%edx)
  8004db:	8b 55 08             	mov    0x8(%ebp),%edx
  8004de:	88 d1                	mov    %dl,%cl
  8004e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004e3:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ea:	8b 00                	mov    (%eax),%eax
  8004ec:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004f1:	75 2c                	jne    80051f <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004f3:	a0 24 30 80 00       	mov    0x803024,%al
  8004f8:	0f b6 c0             	movzbl %al,%eax
  8004fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004fe:	8b 12                	mov    (%edx),%edx
  800500:	89 d1                	mov    %edx,%ecx
  800502:	8b 55 0c             	mov    0xc(%ebp),%edx
  800505:	83 c2 08             	add    $0x8,%edx
  800508:	83 ec 04             	sub    $0x4,%esp
  80050b:	50                   	push   %eax
  80050c:	51                   	push   %ecx
  80050d:	52                   	push   %edx
  80050e:	e8 3e 0e 00 00       	call   801351 <sys_cputs>
  800513:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800516:	8b 45 0c             	mov    0xc(%ebp),%eax
  800519:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80051f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800522:	8b 40 04             	mov    0x4(%eax),%eax
  800525:	8d 50 01             	lea    0x1(%eax),%edx
  800528:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052b:	89 50 04             	mov    %edx,0x4(%eax)
}
  80052e:	90                   	nop
  80052f:	c9                   	leave  
  800530:	c3                   	ret    

00800531 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800531:	55                   	push   %ebp
  800532:	89 e5                	mov    %esp,%ebp
  800534:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80053a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800541:	00 00 00 
	b.cnt = 0;
  800544:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80054b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80054e:	ff 75 0c             	pushl  0xc(%ebp)
  800551:	ff 75 08             	pushl  0x8(%ebp)
  800554:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80055a:	50                   	push   %eax
  80055b:	68 c8 04 80 00       	push   $0x8004c8
  800560:	e8 11 02 00 00       	call   800776 <vprintfmt>
  800565:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800568:	a0 24 30 80 00       	mov    0x803024,%al
  80056d:	0f b6 c0             	movzbl %al,%eax
  800570:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800576:	83 ec 04             	sub    $0x4,%esp
  800579:	50                   	push   %eax
  80057a:	52                   	push   %edx
  80057b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800581:	83 c0 08             	add    $0x8,%eax
  800584:	50                   	push   %eax
  800585:	e8 c7 0d 00 00       	call   801351 <sys_cputs>
  80058a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80058d:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800594:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80059a:	c9                   	leave  
  80059b:	c3                   	ret    

0080059c <cprintf>:

int cprintf(const char *fmt, ...) {
  80059c:	55                   	push   %ebp
  80059d:	89 e5                	mov    %esp,%ebp
  80059f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005a2:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8005a9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005af:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b2:	83 ec 08             	sub    $0x8,%esp
  8005b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8005b8:	50                   	push   %eax
  8005b9:	e8 73 ff ff ff       	call   800531 <vcprintf>
  8005be:	83 c4 10             	add    $0x10,%esp
  8005c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005c7:	c9                   	leave  
  8005c8:	c3                   	ret    

008005c9 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8005c9:	55                   	push   %ebp
  8005ca:	89 e5                	mov    %esp,%ebp
  8005cc:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005cf:	e8 2b 0f 00 00       	call   8014ff <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005d4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005da:	8b 45 08             	mov    0x8(%ebp),%eax
  8005dd:	83 ec 08             	sub    $0x8,%esp
  8005e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8005e3:	50                   	push   %eax
  8005e4:	e8 48 ff ff ff       	call   800531 <vcprintf>
  8005e9:	83 c4 10             	add    $0x10,%esp
  8005ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005ef:	e8 25 0f 00 00       	call   801519 <sys_enable_interrupt>
	return cnt;
  8005f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005f7:	c9                   	leave  
  8005f8:	c3                   	ret    

008005f9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005f9:	55                   	push   %ebp
  8005fa:	89 e5                	mov    %esp,%ebp
  8005fc:	53                   	push   %ebx
  8005fd:	83 ec 14             	sub    $0x14,%esp
  800600:	8b 45 10             	mov    0x10(%ebp),%eax
  800603:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800606:	8b 45 14             	mov    0x14(%ebp),%eax
  800609:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80060c:	8b 45 18             	mov    0x18(%ebp),%eax
  80060f:	ba 00 00 00 00       	mov    $0x0,%edx
  800614:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800617:	77 55                	ja     80066e <printnum+0x75>
  800619:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80061c:	72 05                	jb     800623 <printnum+0x2a>
  80061e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800621:	77 4b                	ja     80066e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800623:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800626:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800629:	8b 45 18             	mov    0x18(%ebp),%eax
  80062c:	ba 00 00 00 00       	mov    $0x0,%edx
  800631:	52                   	push   %edx
  800632:	50                   	push   %eax
  800633:	ff 75 f4             	pushl  -0xc(%ebp)
  800636:	ff 75 f0             	pushl  -0x10(%ebp)
  800639:	e8 fa 13 00 00       	call   801a38 <__udivdi3>
  80063e:	83 c4 10             	add    $0x10,%esp
  800641:	83 ec 04             	sub    $0x4,%esp
  800644:	ff 75 20             	pushl  0x20(%ebp)
  800647:	53                   	push   %ebx
  800648:	ff 75 18             	pushl  0x18(%ebp)
  80064b:	52                   	push   %edx
  80064c:	50                   	push   %eax
  80064d:	ff 75 0c             	pushl  0xc(%ebp)
  800650:	ff 75 08             	pushl  0x8(%ebp)
  800653:	e8 a1 ff ff ff       	call   8005f9 <printnum>
  800658:	83 c4 20             	add    $0x20,%esp
  80065b:	eb 1a                	jmp    800677 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80065d:	83 ec 08             	sub    $0x8,%esp
  800660:	ff 75 0c             	pushl  0xc(%ebp)
  800663:	ff 75 20             	pushl  0x20(%ebp)
  800666:	8b 45 08             	mov    0x8(%ebp),%eax
  800669:	ff d0                	call   *%eax
  80066b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80066e:	ff 4d 1c             	decl   0x1c(%ebp)
  800671:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800675:	7f e6                	jg     80065d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800677:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80067a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80067f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800682:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800685:	53                   	push   %ebx
  800686:	51                   	push   %ecx
  800687:	52                   	push   %edx
  800688:	50                   	push   %eax
  800689:	e8 ba 14 00 00       	call   801b48 <__umoddi3>
  80068e:	83 c4 10             	add    $0x10,%esp
  800691:	05 34 22 80 00       	add    $0x802234,%eax
  800696:	8a 00                	mov    (%eax),%al
  800698:	0f be c0             	movsbl %al,%eax
  80069b:	83 ec 08             	sub    $0x8,%esp
  80069e:	ff 75 0c             	pushl  0xc(%ebp)
  8006a1:	50                   	push   %eax
  8006a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a5:	ff d0                	call   *%eax
  8006a7:	83 c4 10             	add    $0x10,%esp
}
  8006aa:	90                   	nop
  8006ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006ae:	c9                   	leave  
  8006af:	c3                   	ret    

008006b0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006b0:	55                   	push   %ebp
  8006b1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006b3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006b7:	7e 1c                	jle    8006d5 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bc:	8b 00                	mov    (%eax),%eax
  8006be:	8d 50 08             	lea    0x8(%eax),%edx
  8006c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c4:	89 10                	mov    %edx,(%eax)
  8006c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c9:	8b 00                	mov    (%eax),%eax
  8006cb:	83 e8 08             	sub    $0x8,%eax
  8006ce:	8b 50 04             	mov    0x4(%eax),%edx
  8006d1:	8b 00                	mov    (%eax),%eax
  8006d3:	eb 40                	jmp    800715 <getuint+0x65>
	else if (lflag)
  8006d5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006d9:	74 1e                	je     8006f9 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006db:	8b 45 08             	mov    0x8(%ebp),%eax
  8006de:	8b 00                	mov    (%eax),%eax
  8006e0:	8d 50 04             	lea    0x4(%eax),%edx
  8006e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e6:	89 10                	mov    %edx,(%eax)
  8006e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006eb:	8b 00                	mov    (%eax),%eax
  8006ed:	83 e8 04             	sub    $0x4,%eax
  8006f0:	8b 00                	mov    (%eax),%eax
  8006f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f7:	eb 1c                	jmp    800715 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fc:	8b 00                	mov    (%eax),%eax
  8006fe:	8d 50 04             	lea    0x4(%eax),%edx
  800701:	8b 45 08             	mov    0x8(%ebp),%eax
  800704:	89 10                	mov    %edx,(%eax)
  800706:	8b 45 08             	mov    0x8(%ebp),%eax
  800709:	8b 00                	mov    (%eax),%eax
  80070b:	83 e8 04             	sub    $0x4,%eax
  80070e:	8b 00                	mov    (%eax),%eax
  800710:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800715:	5d                   	pop    %ebp
  800716:	c3                   	ret    

00800717 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800717:	55                   	push   %ebp
  800718:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80071a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80071e:	7e 1c                	jle    80073c <getint+0x25>
		return va_arg(*ap, long long);
  800720:	8b 45 08             	mov    0x8(%ebp),%eax
  800723:	8b 00                	mov    (%eax),%eax
  800725:	8d 50 08             	lea    0x8(%eax),%edx
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	89 10                	mov    %edx,(%eax)
  80072d:	8b 45 08             	mov    0x8(%ebp),%eax
  800730:	8b 00                	mov    (%eax),%eax
  800732:	83 e8 08             	sub    $0x8,%eax
  800735:	8b 50 04             	mov    0x4(%eax),%edx
  800738:	8b 00                	mov    (%eax),%eax
  80073a:	eb 38                	jmp    800774 <getint+0x5d>
	else if (lflag)
  80073c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800740:	74 1a                	je     80075c <getint+0x45>
		return va_arg(*ap, long);
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
  80075a:	eb 18                	jmp    800774 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80075c:	8b 45 08             	mov    0x8(%ebp),%eax
  80075f:	8b 00                	mov    (%eax),%eax
  800761:	8d 50 04             	lea    0x4(%eax),%edx
  800764:	8b 45 08             	mov    0x8(%ebp),%eax
  800767:	89 10                	mov    %edx,(%eax)
  800769:	8b 45 08             	mov    0x8(%ebp),%eax
  80076c:	8b 00                	mov    (%eax),%eax
  80076e:	83 e8 04             	sub    $0x4,%eax
  800771:	8b 00                	mov    (%eax),%eax
  800773:	99                   	cltd   
}
  800774:	5d                   	pop    %ebp
  800775:	c3                   	ret    

00800776 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800776:	55                   	push   %ebp
  800777:	89 e5                	mov    %esp,%ebp
  800779:	56                   	push   %esi
  80077a:	53                   	push   %ebx
  80077b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80077e:	eb 17                	jmp    800797 <vprintfmt+0x21>
			if (ch == '\0')
  800780:	85 db                	test   %ebx,%ebx
  800782:	0f 84 af 03 00 00    	je     800b37 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800788:	83 ec 08             	sub    $0x8,%esp
  80078b:	ff 75 0c             	pushl  0xc(%ebp)
  80078e:	53                   	push   %ebx
  80078f:	8b 45 08             	mov    0x8(%ebp),%eax
  800792:	ff d0                	call   *%eax
  800794:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800797:	8b 45 10             	mov    0x10(%ebp),%eax
  80079a:	8d 50 01             	lea    0x1(%eax),%edx
  80079d:	89 55 10             	mov    %edx,0x10(%ebp)
  8007a0:	8a 00                	mov    (%eax),%al
  8007a2:	0f b6 d8             	movzbl %al,%ebx
  8007a5:	83 fb 25             	cmp    $0x25,%ebx
  8007a8:	75 d6                	jne    800780 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007aa:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007ae:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007b5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007bc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007c3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8007cd:	8d 50 01             	lea    0x1(%eax),%edx
  8007d0:	89 55 10             	mov    %edx,0x10(%ebp)
  8007d3:	8a 00                	mov    (%eax),%al
  8007d5:	0f b6 d8             	movzbl %al,%ebx
  8007d8:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007db:	83 f8 55             	cmp    $0x55,%eax
  8007de:	0f 87 2b 03 00 00    	ja     800b0f <vprintfmt+0x399>
  8007e4:	8b 04 85 58 22 80 00 	mov    0x802258(,%eax,4),%eax
  8007eb:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007ed:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007f1:	eb d7                	jmp    8007ca <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007f3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007f7:	eb d1                	jmp    8007ca <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007f9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800800:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800803:	89 d0                	mov    %edx,%eax
  800805:	c1 e0 02             	shl    $0x2,%eax
  800808:	01 d0                	add    %edx,%eax
  80080a:	01 c0                	add    %eax,%eax
  80080c:	01 d8                	add    %ebx,%eax
  80080e:	83 e8 30             	sub    $0x30,%eax
  800811:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800814:	8b 45 10             	mov    0x10(%ebp),%eax
  800817:	8a 00                	mov    (%eax),%al
  800819:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80081c:	83 fb 2f             	cmp    $0x2f,%ebx
  80081f:	7e 3e                	jle    80085f <vprintfmt+0xe9>
  800821:	83 fb 39             	cmp    $0x39,%ebx
  800824:	7f 39                	jg     80085f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800826:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800829:	eb d5                	jmp    800800 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80082b:	8b 45 14             	mov    0x14(%ebp),%eax
  80082e:	83 c0 04             	add    $0x4,%eax
  800831:	89 45 14             	mov    %eax,0x14(%ebp)
  800834:	8b 45 14             	mov    0x14(%ebp),%eax
  800837:	83 e8 04             	sub    $0x4,%eax
  80083a:	8b 00                	mov    (%eax),%eax
  80083c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80083f:	eb 1f                	jmp    800860 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800841:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800845:	79 83                	jns    8007ca <vprintfmt+0x54>
				width = 0;
  800847:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80084e:	e9 77 ff ff ff       	jmp    8007ca <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800853:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80085a:	e9 6b ff ff ff       	jmp    8007ca <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80085f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800860:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800864:	0f 89 60 ff ff ff    	jns    8007ca <vprintfmt+0x54>
				width = precision, precision = -1;
  80086a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80086d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800870:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800877:	e9 4e ff ff ff       	jmp    8007ca <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80087c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80087f:	e9 46 ff ff ff       	jmp    8007ca <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800884:	8b 45 14             	mov    0x14(%ebp),%eax
  800887:	83 c0 04             	add    $0x4,%eax
  80088a:	89 45 14             	mov    %eax,0x14(%ebp)
  80088d:	8b 45 14             	mov    0x14(%ebp),%eax
  800890:	83 e8 04             	sub    $0x4,%eax
  800893:	8b 00                	mov    (%eax),%eax
  800895:	83 ec 08             	sub    $0x8,%esp
  800898:	ff 75 0c             	pushl  0xc(%ebp)
  80089b:	50                   	push   %eax
  80089c:	8b 45 08             	mov    0x8(%ebp),%eax
  80089f:	ff d0                	call   *%eax
  8008a1:	83 c4 10             	add    $0x10,%esp
			break;
  8008a4:	e9 89 02 00 00       	jmp    800b32 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ac:	83 c0 04             	add    $0x4,%eax
  8008af:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b5:	83 e8 04             	sub    $0x4,%eax
  8008b8:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008ba:	85 db                	test   %ebx,%ebx
  8008bc:	79 02                	jns    8008c0 <vprintfmt+0x14a>
				err = -err;
  8008be:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008c0:	83 fb 64             	cmp    $0x64,%ebx
  8008c3:	7f 0b                	jg     8008d0 <vprintfmt+0x15a>
  8008c5:	8b 34 9d a0 20 80 00 	mov    0x8020a0(,%ebx,4),%esi
  8008cc:	85 f6                	test   %esi,%esi
  8008ce:	75 19                	jne    8008e9 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008d0:	53                   	push   %ebx
  8008d1:	68 45 22 80 00       	push   $0x802245
  8008d6:	ff 75 0c             	pushl  0xc(%ebp)
  8008d9:	ff 75 08             	pushl  0x8(%ebp)
  8008dc:	e8 5e 02 00 00       	call   800b3f <printfmt>
  8008e1:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008e4:	e9 49 02 00 00       	jmp    800b32 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008e9:	56                   	push   %esi
  8008ea:	68 4e 22 80 00       	push   $0x80224e
  8008ef:	ff 75 0c             	pushl  0xc(%ebp)
  8008f2:	ff 75 08             	pushl  0x8(%ebp)
  8008f5:	e8 45 02 00 00       	call   800b3f <printfmt>
  8008fa:	83 c4 10             	add    $0x10,%esp
			break;
  8008fd:	e9 30 02 00 00       	jmp    800b32 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800902:	8b 45 14             	mov    0x14(%ebp),%eax
  800905:	83 c0 04             	add    $0x4,%eax
  800908:	89 45 14             	mov    %eax,0x14(%ebp)
  80090b:	8b 45 14             	mov    0x14(%ebp),%eax
  80090e:	83 e8 04             	sub    $0x4,%eax
  800911:	8b 30                	mov    (%eax),%esi
  800913:	85 f6                	test   %esi,%esi
  800915:	75 05                	jne    80091c <vprintfmt+0x1a6>
				p = "(null)";
  800917:	be 51 22 80 00       	mov    $0x802251,%esi
			if (width > 0 && padc != '-')
  80091c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800920:	7e 6d                	jle    80098f <vprintfmt+0x219>
  800922:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800926:	74 67                	je     80098f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800928:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80092b:	83 ec 08             	sub    $0x8,%esp
  80092e:	50                   	push   %eax
  80092f:	56                   	push   %esi
  800930:	e8 0c 03 00 00       	call   800c41 <strnlen>
  800935:	83 c4 10             	add    $0x10,%esp
  800938:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80093b:	eb 16                	jmp    800953 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80093d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800941:	83 ec 08             	sub    $0x8,%esp
  800944:	ff 75 0c             	pushl  0xc(%ebp)
  800947:	50                   	push   %eax
  800948:	8b 45 08             	mov    0x8(%ebp),%eax
  80094b:	ff d0                	call   *%eax
  80094d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800950:	ff 4d e4             	decl   -0x1c(%ebp)
  800953:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800957:	7f e4                	jg     80093d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800959:	eb 34                	jmp    80098f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80095b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80095f:	74 1c                	je     80097d <vprintfmt+0x207>
  800961:	83 fb 1f             	cmp    $0x1f,%ebx
  800964:	7e 05                	jle    80096b <vprintfmt+0x1f5>
  800966:	83 fb 7e             	cmp    $0x7e,%ebx
  800969:	7e 12                	jle    80097d <vprintfmt+0x207>
					putch('?', putdat);
  80096b:	83 ec 08             	sub    $0x8,%esp
  80096e:	ff 75 0c             	pushl  0xc(%ebp)
  800971:	6a 3f                	push   $0x3f
  800973:	8b 45 08             	mov    0x8(%ebp),%eax
  800976:	ff d0                	call   *%eax
  800978:	83 c4 10             	add    $0x10,%esp
  80097b:	eb 0f                	jmp    80098c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80097d:	83 ec 08             	sub    $0x8,%esp
  800980:	ff 75 0c             	pushl  0xc(%ebp)
  800983:	53                   	push   %ebx
  800984:	8b 45 08             	mov    0x8(%ebp),%eax
  800987:	ff d0                	call   *%eax
  800989:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80098c:	ff 4d e4             	decl   -0x1c(%ebp)
  80098f:	89 f0                	mov    %esi,%eax
  800991:	8d 70 01             	lea    0x1(%eax),%esi
  800994:	8a 00                	mov    (%eax),%al
  800996:	0f be d8             	movsbl %al,%ebx
  800999:	85 db                	test   %ebx,%ebx
  80099b:	74 24                	je     8009c1 <vprintfmt+0x24b>
  80099d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009a1:	78 b8                	js     80095b <vprintfmt+0x1e5>
  8009a3:	ff 4d e0             	decl   -0x20(%ebp)
  8009a6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009aa:	79 af                	jns    80095b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009ac:	eb 13                	jmp    8009c1 <vprintfmt+0x24b>
				putch(' ', putdat);
  8009ae:	83 ec 08             	sub    $0x8,%esp
  8009b1:	ff 75 0c             	pushl  0xc(%ebp)
  8009b4:	6a 20                	push   $0x20
  8009b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b9:	ff d0                	call   *%eax
  8009bb:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009be:	ff 4d e4             	decl   -0x1c(%ebp)
  8009c1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009c5:	7f e7                	jg     8009ae <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009c7:	e9 66 01 00 00       	jmp    800b32 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009cc:	83 ec 08             	sub    $0x8,%esp
  8009cf:	ff 75 e8             	pushl  -0x18(%ebp)
  8009d2:	8d 45 14             	lea    0x14(%ebp),%eax
  8009d5:	50                   	push   %eax
  8009d6:	e8 3c fd ff ff       	call   800717 <getint>
  8009db:	83 c4 10             	add    $0x10,%esp
  8009de:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009e1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009ea:	85 d2                	test   %edx,%edx
  8009ec:	79 23                	jns    800a11 <vprintfmt+0x29b>
				putch('-', putdat);
  8009ee:	83 ec 08             	sub    $0x8,%esp
  8009f1:	ff 75 0c             	pushl  0xc(%ebp)
  8009f4:	6a 2d                	push   $0x2d
  8009f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f9:	ff d0                	call   *%eax
  8009fb:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a04:	f7 d8                	neg    %eax
  800a06:	83 d2 00             	adc    $0x0,%edx
  800a09:	f7 da                	neg    %edx
  800a0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a0e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a11:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a18:	e9 bc 00 00 00       	jmp    800ad9 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a1d:	83 ec 08             	sub    $0x8,%esp
  800a20:	ff 75 e8             	pushl  -0x18(%ebp)
  800a23:	8d 45 14             	lea    0x14(%ebp),%eax
  800a26:	50                   	push   %eax
  800a27:	e8 84 fc ff ff       	call   8006b0 <getuint>
  800a2c:	83 c4 10             	add    $0x10,%esp
  800a2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a32:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a35:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a3c:	e9 98 00 00 00       	jmp    800ad9 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a41:	83 ec 08             	sub    $0x8,%esp
  800a44:	ff 75 0c             	pushl  0xc(%ebp)
  800a47:	6a 58                	push   $0x58
  800a49:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4c:	ff d0                	call   *%eax
  800a4e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a51:	83 ec 08             	sub    $0x8,%esp
  800a54:	ff 75 0c             	pushl  0xc(%ebp)
  800a57:	6a 58                	push   $0x58
  800a59:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5c:	ff d0                	call   *%eax
  800a5e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a61:	83 ec 08             	sub    $0x8,%esp
  800a64:	ff 75 0c             	pushl  0xc(%ebp)
  800a67:	6a 58                	push   $0x58
  800a69:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6c:	ff d0                	call   *%eax
  800a6e:	83 c4 10             	add    $0x10,%esp
			break;
  800a71:	e9 bc 00 00 00       	jmp    800b32 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a76:	83 ec 08             	sub    $0x8,%esp
  800a79:	ff 75 0c             	pushl  0xc(%ebp)
  800a7c:	6a 30                	push   $0x30
  800a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a81:	ff d0                	call   *%eax
  800a83:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a86:	83 ec 08             	sub    $0x8,%esp
  800a89:	ff 75 0c             	pushl  0xc(%ebp)
  800a8c:	6a 78                	push   $0x78
  800a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a91:	ff d0                	call   *%eax
  800a93:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a96:	8b 45 14             	mov    0x14(%ebp),%eax
  800a99:	83 c0 04             	add    $0x4,%eax
  800a9c:	89 45 14             	mov    %eax,0x14(%ebp)
  800a9f:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa2:	83 e8 04             	sub    $0x4,%eax
  800aa5:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800aa7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aaa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ab1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ab8:	eb 1f                	jmp    800ad9 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800aba:	83 ec 08             	sub    $0x8,%esp
  800abd:	ff 75 e8             	pushl  -0x18(%ebp)
  800ac0:	8d 45 14             	lea    0x14(%ebp),%eax
  800ac3:	50                   	push   %eax
  800ac4:	e8 e7 fb ff ff       	call   8006b0 <getuint>
  800ac9:	83 c4 10             	add    $0x10,%esp
  800acc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800acf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ad2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ad9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800add:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ae0:	83 ec 04             	sub    $0x4,%esp
  800ae3:	52                   	push   %edx
  800ae4:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ae7:	50                   	push   %eax
  800ae8:	ff 75 f4             	pushl  -0xc(%ebp)
  800aeb:	ff 75 f0             	pushl  -0x10(%ebp)
  800aee:	ff 75 0c             	pushl  0xc(%ebp)
  800af1:	ff 75 08             	pushl  0x8(%ebp)
  800af4:	e8 00 fb ff ff       	call   8005f9 <printnum>
  800af9:	83 c4 20             	add    $0x20,%esp
			break;
  800afc:	eb 34                	jmp    800b32 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800afe:	83 ec 08             	sub    $0x8,%esp
  800b01:	ff 75 0c             	pushl  0xc(%ebp)
  800b04:	53                   	push   %ebx
  800b05:	8b 45 08             	mov    0x8(%ebp),%eax
  800b08:	ff d0                	call   *%eax
  800b0a:	83 c4 10             	add    $0x10,%esp
			break;
  800b0d:	eb 23                	jmp    800b32 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b0f:	83 ec 08             	sub    $0x8,%esp
  800b12:	ff 75 0c             	pushl  0xc(%ebp)
  800b15:	6a 25                	push   $0x25
  800b17:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1a:	ff d0                	call   *%eax
  800b1c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b1f:	ff 4d 10             	decl   0x10(%ebp)
  800b22:	eb 03                	jmp    800b27 <vprintfmt+0x3b1>
  800b24:	ff 4d 10             	decl   0x10(%ebp)
  800b27:	8b 45 10             	mov    0x10(%ebp),%eax
  800b2a:	48                   	dec    %eax
  800b2b:	8a 00                	mov    (%eax),%al
  800b2d:	3c 25                	cmp    $0x25,%al
  800b2f:	75 f3                	jne    800b24 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b31:	90                   	nop
		}
	}
  800b32:	e9 47 fc ff ff       	jmp    80077e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b37:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b38:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b3b:	5b                   	pop    %ebx
  800b3c:	5e                   	pop    %esi
  800b3d:	5d                   	pop    %ebp
  800b3e:	c3                   	ret    

00800b3f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b3f:	55                   	push   %ebp
  800b40:	89 e5                	mov    %esp,%ebp
  800b42:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b45:	8d 45 10             	lea    0x10(%ebp),%eax
  800b48:	83 c0 04             	add    $0x4,%eax
  800b4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b4e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b51:	ff 75 f4             	pushl  -0xc(%ebp)
  800b54:	50                   	push   %eax
  800b55:	ff 75 0c             	pushl  0xc(%ebp)
  800b58:	ff 75 08             	pushl  0x8(%ebp)
  800b5b:	e8 16 fc ff ff       	call   800776 <vprintfmt>
  800b60:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b63:	90                   	nop
  800b64:	c9                   	leave  
  800b65:	c3                   	ret    

00800b66 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b66:	55                   	push   %ebp
  800b67:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6c:	8b 40 08             	mov    0x8(%eax),%eax
  800b6f:	8d 50 01             	lea    0x1(%eax),%edx
  800b72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b75:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7b:	8b 10                	mov    (%eax),%edx
  800b7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b80:	8b 40 04             	mov    0x4(%eax),%eax
  800b83:	39 c2                	cmp    %eax,%edx
  800b85:	73 12                	jae    800b99 <sprintputch+0x33>
		*b->buf++ = ch;
  800b87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8a:	8b 00                	mov    (%eax),%eax
  800b8c:	8d 48 01             	lea    0x1(%eax),%ecx
  800b8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b92:	89 0a                	mov    %ecx,(%edx)
  800b94:	8b 55 08             	mov    0x8(%ebp),%edx
  800b97:	88 10                	mov    %dl,(%eax)
}
  800b99:	90                   	nop
  800b9a:	5d                   	pop    %ebp
  800b9b:	c3                   	ret    

00800b9c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b9c:	55                   	push   %ebp
  800b9d:	89 e5                	mov    %esp,%ebp
  800b9f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ba8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bab:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bae:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb1:	01 d0                	add    %edx,%eax
  800bb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bbd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bc1:	74 06                	je     800bc9 <vsnprintf+0x2d>
  800bc3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bc7:	7f 07                	jg     800bd0 <vsnprintf+0x34>
		return -E_INVAL;
  800bc9:	b8 03 00 00 00       	mov    $0x3,%eax
  800bce:	eb 20                	jmp    800bf0 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bd0:	ff 75 14             	pushl  0x14(%ebp)
  800bd3:	ff 75 10             	pushl  0x10(%ebp)
  800bd6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bd9:	50                   	push   %eax
  800bda:	68 66 0b 80 00       	push   $0x800b66
  800bdf:	e8 92 fb ff ff       	call   800776 <vprintfmt>
  800be4:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800be7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bea:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bf0:	c9                   	leave  
  800bf1:	c3                   	ret    

00800bf2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bf2:	55                   	push   %ebp
  800bf3:	89 e5                	mov    %esp,%ebp
  800bf5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bf8:	8d 45 10             	lea    0x10(%ebp),%eax
  800bfb:	83 c0 04             	add    $0x4,%eax
  800bfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c01:	8b 45 10             	mov    0x10(%ebp),%eax
  800c04:	ff 75 f4             	pushl  -0xc(%ebp)
  800c07:	50                   	push   %eax
  800c08:	ff 75 0c             	pushl  0xc(%ebp)
  800c0b:	ff 75 08             	pushl  0x8(%ebp)
  800c0e:	e8 89 ff ff ff       	call   800b9c <vsnprintf>
  800c13:	83 c4 10             	add    $0x10,%esp
  800c16:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c19:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c1c:	c9                   	leave  
  800c1d:	c3                   	ret    

00800c1e <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c1e:	55                   	push   %ebp
  800c1f:	89 e5                	mov    %esp,%ebp
  800c21:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c24:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c2b:	eb 06                	jmp    800c33 <strlen+0x15>
		n++;
  800c2d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c30:	ff 45 08             	incl   0x8(%ebp)
  800c33:	8b 45 08             	mov    0x8(%ebp),%eax
  800c36:	8a 00                	mov    (%eax),%al
  800c38:	84 c0                	test   %al,%al
  800c3a:	75 f1                	jne    800c2d <strlen+0xf>
		n++;
	return n;
  800c3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c3f:	c9                   	leave  
  800c40:	c3                   	ret    

00800c41 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c41:	55                   	push   %ebp
  800c42:	89 e5                	mov    %esp,%ebp
  800c44:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c47:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c4e:	eb 09                	jmp    800c59 <strnlen+0x18>
		n++;
  800c50:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c53:	ff 45 08             	incl   0x8(%ebp)
  800c56:	ff 4d 0c             	decl   0xc(%ebp)
  800c59:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c5d:	74 09                	je     800c68 <strnlen+0x27>
  800c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c62:	8a 00                	mov    (%eax),%al
  800c64:	84 c0                	test   %al,%al
  800c66:	75 e8                	jne    800c50 <strnlen+0xf>
		n++;
	return n;
  800c68:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c6b:	c9                   	leave  
  800c6c:	c3                   	ret    

00800c6d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c6d:	55                   	push   %ebp
  800c6e:	89 e5                	mov    %esp,%ebp
  800c70:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c73:	8b 45 08             	mov    0x8(%ebp),%eax
  800c76:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c79:	90                   	nop
  800c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7d:	8d 50 01             	lea    0x1(%eax),%edx
  800c80:	89 55 08             	mov    %edx,0x8(%ebp)
  800c83:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c86:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c89:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c8c:	8a 12                	mov    (%edx),%dl
  800c8e:	88 10                	mov    %dl,(%eax)
  800c90:	8a 00                	mov    (%eax),%al
  800c92:	84 c0                	test   %al,%al
  800c94:	75 e4                	jne    800c7a <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c96:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c99:	c9                   	leave  
  800c9a:	c3                   	ret    

00800c9b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c9b:	55                   	push   %ebp
  800c9c:	89 e5                	mov    %esp,%ebp
  800c9e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ca7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cae:	eb 1f                	jmp    800ccf <strncpy+0x34>
		*dst++ = *src;
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb3:	8d 50 01             	lea    0x1(%eax),%edx
  800cb6:	89 55 08             	mov    %edx,0x8(%ebp)
  800cb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cbc:	8a 12                	mov    (%edx),%dl
  800cbe:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc3:	8a 00                	mov    (%eax),%al
  800cc5:	84 c0                	test   %al,%al
  800cc7:	74 03                	je     800ccc <strncpy+0x31>
			src++;
  800cc9:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ccc:	ff 45 fc             	incl   -0x4(%ebp)
  800ccf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cd2:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cd5:	72 d9                	jb     800cb0 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cd7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cda:	c9                   	leave  
  800cdb:	c3                   	ret    

00800cdc <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cdc:	55                   	push   %ebp
  800cdd:	89 e5                	mov    %esp,%ebp
  800cdf:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ce8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cec:	74 30                	je     800d1e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cee:	eb 16                	jmp    800d06 <strlcpy+0x2a>
			*dst++ = *src++;
  800cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf3:	8d 50 01             	lea    0x1(%eax),%edx
  800cf6:	89 55 08             	mov    %edx,0x8(%ebp)
  800cf9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cfc:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cff:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d02:	8a 12                	mov    (%edx),%dl
  800d04:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d06:	ff 4d 10             	decl   0x10(%ebp)
  800d09:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d0d:	74 09                	je     800d18 <strlcpy+0x3c>
  800d0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d12:	8a 00                	mov    (%eax),%al
  800d14:	84 c0                	test   %al,%al
  800d16:	75 d8                	jne    800cf0 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d18:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d1e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d21:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d24:	29 c2                	sub    %eax,%edx
  800d26:	89 d0                	mov    %edx,%eax
}
  800d28:	c9                   	leave  
  800d29:	c3                   	ret    

00800d2a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d2d:	eb 06                	jmp    800d35 <strcmp+0xb>
		p++, q++;
  800d2f:	ff 45 08             	incl   0x8(%ebp)
  800d32:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d35:	8b 45 08             	mov    0x8(%ebp),%eax
  800d38:	8a 00                	mov    (%eax),%al
  800d3a:	84 c0                	test   %al,%al
  800d3c:	74 0e                	je     800d4c <strcmp+0x22>
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	8a 10                	mov    (%eax),%dl
  800d43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d46:	8a 00                	mov    (%eax),%al
  800d48:	38 c2                	cmp    %al,%dl
  800d4a:	74 e3                	je     800d2f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	8a 00                	mov    (%eax),%al
  800d51:	0f b6 d0             	movzbl %al,%edx
  800d54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d57:	8a 00                	mov    (%eax),%al
  800d59:	0f b6 c0             	movzbl %al,%eax
  800d5c:	29 c2                	sub    %eax,%edx
  800d5e:	89 d0                	mov    %edx,%eax
}
  800d60:	5d                   	pop    %ebp
  800d61:	c3                   	ret    

00800d62 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d62:	55                   	push   %ebp
  800d63:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d65:	eb 09                	jmp    800d70 <strncmp+0xe>
		n--, p++, q++;
  800d67:	ff 4d 10             	decl   0x10(%ebp)
  800d6a:	ff 45 08             	incl   0x8(%ebp)
  800d6d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d70:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d74:	74 17                	je     800d8d <strncmp+0x2b>
  800d76:	8b 45 08             	mov    0x8(%ebp),%eax
  800d79:	8a 00                	mov    (%eax),%al
  800d7b:	84 c0                	test   %al,%al
  800d7d:	74 0e                	je     800d8d <strncmp+0x2b>
  800d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d82:	8a 10                	mov    (%eax),%dl
  800d84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d87:	8a 00                	mov    (%eax),%al
  800d89:	38 c2                	cmp    %al,%dl
  800d8b:	74 da                	je     800d67 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d8d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d91:	75 07                	jne    800d9a <strncmp+0x38>
		return 0;
  800d93:	b8 00 00 00 00       	mov    $0x0,%eax
  800d98:	eb 14                	jmp    800dae <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9d:	8a 00                	mov    (%eax),%al
  800d9f:	0f b6 d0             	movzbl %al,%edx
  800da2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da5:	8a 00                	mov    (%eax),%al
  800da7:	0f b6 c0             	movzbl %al,%eax
  800daa:	29 c2                	sub    %eax,%edx
  800dac:	89 d0                	mov    %edx,%eax
}
  800dae:	5d                   	pop    %ebp
  800daf:	c3                   	ret    

00800db0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800db0:	55                   	push   %ebp
  800db1:	89 e5                	mov    %esp,%ebp
  800db3:	83 ec 04             	sub    $0x4,%esp
  800db6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dbc:	eb 12                	jmp    800dd0 <strchr+0x20>
		if (*s == c)
  800dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc1:	8a 00                	mov    (%eax),%al
  800dc3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dc6:	75 05                	jne    800dcd <strchr+0x1d>
			return (char *) s;
  800dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcb:	eb 11                	jmp    800dde <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dcd:	ff 45 08             	incl   0x8(%ebp)
  800dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd3:	8a 00                	mov    (%eax),%al
  800dd5:	84 c0                	test   %al,%al
  800dd7:	75 e5                	jne    800dbe <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800dd9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dde:	c9                   	leave  
  800ddf:	c3                   	ret    

00800de0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800de0:	55                   	push   %ebp
  800de1:	89 e5                	mov    %esp,%ebp
  800de3:	83 ec 04             	sub    $0x4,%esp
  800de6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dec:	eb 0d                	jmp    800dfb <strfind+0x1b>
		if (*s == c)
  800dee:	8b 45 08             	mov    0x8(%ebp),%eax
  800df1:	8a 00                	mov    (%eax),%al
  800df3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800df6:	74 0e                	je     800e06 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800df8:	ff 45 08             	incl   0x8(%ebp)
  800dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfe:	8a 00                	mov    (%eax),%al
  800e00:	84 c0                	test   %al,%al
  800e02:	75 ea                	jne    800dee <strfind+0xe>
  800e04:	eb 01                	jmp    800e07 <strfind+0x27>
		if (*s == c)
			break;
  800e06:	90                   	nop
	return (char *) s;
  800e07:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e0a:	c9                   	leave  
  800e0b:	c3                   	ret    

00800e0c <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e0c:	55                   	push   %ebp
  800e0d:	89 e5                	mov    %esp,%ebp
  800e0f:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e12:	8b 45 08             	mov    0x8(%ebp),%eax
  800e15:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e18:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e1e:	eb 0e                	jmp    800e2e <memset+0x22>
		*p++ = c;
  800e20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e23:	8d 50 01             	lea    0x1(%eax),%edx
  800e26:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e29:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e2c:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e2e:	ff 4d f8             	decl   -0x8(%ebp)
  800e31:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e35:	79 e9                	jns    800e20 <memset+0x14>
		*p++ = c;

	return v;
  800e37:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e3a:	c9                   	leave  
  800e3b:	c3                   	ret    

00800e3c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
  800e3f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e45:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e48:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e4e:	eb 16                	jmp    800e66 <memcpy+0x2a>
		*d++ = *s++;
  800e50:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e53:	8d 50 01             	lea    0x1(%eax),%edx
  800e56:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e59:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e5c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e5f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e62:	8a 12                	mov    (%edx),%dl
  800e64:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e66:	8b 45 10             	mov    0x10(%ebp),%eax
  800e69:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e6c:	89 55 10             	mov    %edx,0x10(%ebp)
  800e6f:	85 c0                	test   %eax,%eax
  800e71:	75 dd                	jne    800e50 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e73:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e76:	c9                   	leave  
  800e77:	c3                   	ret    

00800e78 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e78:	55                   	push   %ebp
  800e79:	89 e5                	mov    %esp,%ebp
  800e7b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e81:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
  800e87:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e8d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e90:	73 50                	jae    800ee2 <memmove+0x6a>
  800e92:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e95:	8b 45 10             	mov    0x10(%ebp),%eax
  800e98:	01 d0                	add    %edx,%eax
  800e9a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e9d:	76 43                	jbe    800ee2 <memmove+0x6a>
		s += n;
  800e9f:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea2:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ea5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea8:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800eab:	eb 10                	jmp    800ebd <memmove+0x45>
			*--d = *--s;
  800ead:	ff 4d f8             	decl   -0x8(%ebp)
  800eb0:	ff 4d fc             	decl   -0x4(%ebp)
  800eb3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb6:	8a 10                	mov    (%eax),%dl
  800eb8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ebb:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ebd:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ec3:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec6:	85 c0                	test   %eax,%eax
  800ec8:	75 e3                	jne    800ead <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800eca:	eb 23                	jmp    800eef <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ecc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ecf:	8d 50 01             	lea    0x1(%eax),%edx
  800ed2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ed5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ed8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800edb:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ede:	8a 12                	mov    (%edx),%dl
  800ee0:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ee2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ee8:	89 55 10             	mov    %edx,0x10(%ebp)
  800eeb:	85 c0                	test   %eax,%eax
  800eed:	75 dd                	jne    800ecc <memmove+0x54>
			*d++ = *s++;

	return dst;
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ef2:	c9                   	leave  
  800ef3:	c3                   	ret    

00800ef4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ef4:	55                   	push   %ebp
  800ef5:	89 e5                	mov    %esp,%ebp
  800ef7:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f03:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f06:	eb 2a                	jmp    800f32 <memcmp+0x3e>
		if (*s1 != *s2)
  800f08:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0b:	8a 10                	mov    (%eax),%dl
  800f0d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f10:	8a 00                	mov    (%eax),%al
  800f12:	38 c2                	cmp    %al,%dl
  800f14:	74 16                	je     800f2c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f16:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f19:	8a 00                	mov    (%eax),%al
  800f1b:	0f b6 d0             	movzbl %al,%edx
  800f1e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f21:	8a 00                	mov    (%eax),%al
  800f23:	0f b6 c0             	movzbl %al,%eax
  800f26:	29 c2                	sub    %eax,%edx
  800f28:	89 d0                	mov    %edx,%eax
  800f2a:	eb 18                	jmp    800f44 <memcmp+0x50>
		s1++, s2++;
  800f2c:	ff 45 fc             	incl   -0x4(%ebp)
  800f2f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f32:	8b 45 10             	mov    0x10(%ebp),%eax
  800f35:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f38:	89 55 10             	mov    %edx,0x10(%ebp)
  800f3b:	85 c0                	test   %eax,%eax
  800f3d:	75 c9                	jne    800f08 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f44:	c9                   	leave  
  800f45:	c3                   	ret    

00800f46 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f46:	55                   	push   %ebp
  800f47:	89 e5                	mov    %esp,%ebp
  800f49:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f4c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f52:	01 d0                	add    %edx,%eax
  800f54:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f57:	eb 15                	jmp    800f6e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5c:	8a 00                	mov    (%eax),%al
  800f5e:	0f b6 d0             	movzbl %al,%edx
  800f61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f64:	0f b6 c0             	movzbl %al,%eax
  800f67:	39 c2                	cmp    %eax,%edx
  800f69:	74 0d                	je     800f78 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f6b:	ff 45 08             	incl   0x8(%ebp)
  800f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f71:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f74:	72 e3                	jb     800f59 <memfind+0x13>
  800f76:	eb 01                	jmp    800f79 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f78:	90                   	nop
	return (void *) s;
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f7c:	c9                   	leave  
  800f7d:	c3                   	ret    

00800f7e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f7e:	55                   	push   %ebp
  800f7f:	89 e5                	mov    %esp,%ebp
  800f81:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f84:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f8b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f92:	eb 03                	jmp    800f97 <strtol+0x19>
		s++;
  800f94:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9a:	8a 00                	mov    (%eax),%al
  800f9c:	3c 20                	cmp    $0x20,%al
  800f9e:	74 f4                	je     800f94 <strtol+0x16>
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	8a 00                	mov    (%eax),%al
  800fa5:	3c 09                	cmp    $0x9,%al
  800fa7:	74 eb                	je     800f94 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	8a 00                	mov    (%eax),%al
  800fae:	3c 2b                	cmp    $0x2b,%al
  800fb0:	75 05                	jne    800fb7 <strtol+0x39>
		s++;
  800fb2:	ff 45 08             	incl   0x8(%ebp)
  800fb5:	eb 13                	jmp    800fca <strtol+0x4c>
	else if (*s == '-')
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fba:	8a 00                	mov    (%eax),%al
  800fbc:	3c 2d                	cmp    $0x2d,%al
  800fbe:	75 0a                	jne    800fca <strtol+0x4c>
		s++, neg = 1;
  800fc0:	ff 45 08             	incl   0x8(%ebp)
  800fc3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fce:	74 06                	je     800fd6 <strtol+0x58>
  800fd0:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fd4:	75 20                	jne    800ff6 <strtol+0x78>
  800fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd9:	8a 00                	mov    (%eax),%al
  800fdb:	3c 30                	cmp    $0x30,%al
  800fdd:	75 17                	jne    800ff6 <strtol+0x78>
  800fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe2:	40                   	inc    %eax
  800fe3:	8a 00                	mov    (%eax),%al
  800fe5:	3c 78                	cmp    $0x78,%al
  800fe7:	75 0d                	jne    800ff6 <strtol+0x78>
		s += 2, base = 16;
  800fe9:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fed:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ff4:	eb 28                	jmp    80101e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ff6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ffa:	75 15                	jne    801011 <strtol+0x93>
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	3c 30                	cmp    $0x30,%al
  801003:	75 0c                	jne    801011 <strtol+0x93>
		s++, base = 8;
  801005:	ff 45 08             	incl   0x8(%ebp)
  801008:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80100f:	eb 0d                	jmp    80101e <strtol+0xa0>
	else if (base == 0)
  801011:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801015:	75 07                	jne    80101e <strtol+0xa0>
		base = 10;
  801017:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80101e:	8b 45 08             	mov    0x8(%ebp),%eax
  801021:	8a 00                	mov    (%eax),%al
  801023:	3c 2f                	cmp    $0x2f,%al
  801025:	7e 19                	jle    801040 <strtol+0xc2>
  801027:	8b 45 08             	mov    0x8(%ebp),%eax
  80102a:	8a 00                	mov    (%eax),%al
  80102c:	3c 39                	cmp    $0x39,%al
  80102e:	7f 10                	jg     801040 <strtol+0xc2>
			dig = *s - '0';
  801030:	8b 45 08             	mov    0x8(%ebp),%eax
  801033:	8a 00                	mov    (%eax),%al
  801035:	0f be c0             	movsbl %al,%eax
  801038:	83 e8 30             	sub    $0x30,%eax
  80103b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80103e:	eb 42                	jmp    801082 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801040:	8b 45 08             	mov    0x8(%ebp),%eax
  801043:	8a 00                	mov    (%eax),%al
  801045:	3c 60                	cmp    $0x60,%al
  801047:	7e 19                	jle    801062 <strtol+0xe4>
  801049:	8b 45 08             	mov    0x8(%ebp),%eax
  80104c:	8a 00                	mov    (%eax),%al
  80104e:	3c 7a                	cmp    $0x7a,%al
  801050:	7f 10                	jg     801062 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801052:	8b 45 08             	mov    0x8(%ebp),%eax
  801055:	8a 00                	mov    (%eax),%al
  801057:	0f be c0             	movsbl %al,%eax
  80105a:	83 e8 57             	sub    $0x57,%eax
  80105d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801060:	eb 20                	jmp    801082 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	8a 00                	mov    (%eax),%al
  801067:	3c 40                	cmp    $0x40,%al
  801069:	7e 39                	jle    8010a4 <strtol+0x126>
  80106b:	8b 45 08             	mov    0x8(%ebp),%eax
  80106e:	8a 00                	mov    (%eax),%al
  801070:	3c 5a                	cmp    $0x5a,%al
  801072:	7f 30                	jg     8010a4 <strtol+0x126>
			dig = *s - 'A' + 10;
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	8a 00                	mov    (%eax),%al
  801079:	0f be c0             	movsbl %al,%eax
  80107c:	83 e8 37             	sub    $0x37,%eax
  80107f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801082:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801085:	3b 45 10             	cmp    0x10(%ebp),%eax
  801088:	7d 19                	jge    8010a3 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80108a:	ff 45 08             	incl   0x8(%ebp)
  80108d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801090:	0f af 45 10          	imul   0x10(%ebp),%eax
  801094:	89 c2                	mov    %eax,%edx
  801096:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801099:	01 d0                	add    %edx,%eax
  80109b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80109e:	e9 7b ff ff ff       	jmp    80101e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010a3:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010a4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010a8:	74 08                	je     8010b2 <strtol+0x134>
		*endptr = (char *) s;
  8010aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b0:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010b6:	74 07                	je     8010bf <strtol+0x141>
  8010b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010bb:	f7 d8                	neg    %eax
  8010bd:	eb 03                	jmp    8010c2 <strtol+0x144>
  8010bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010c2:	c9                   	leave  
  8010c3:	c3                   	ret    

008010c4 <ltostr>:

void
ltostr(long value, char *str)
{
  8010c4:	55                   	push   %ebp
  8010c5:	89 e5                	mov    %esp,%ebp
  8010c7:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010d1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010dc:	79 13                	jns    8010f1 <ltostr+0x2d>
	{
		neg = 1;
  8010de:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e8:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010eb:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010ee:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f4:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010f9:	99                   	cltd   
  8010fa:	f7 f9                	idiv   %ecx
  8010fc:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801102:	8d 50 01             	lea    0x1(%eax),%edx
  801105:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801108:	89 c2                	mov    %eax,%edx
  80110a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110d:	01 d0                	add    %edx,%eax
  80110f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801112:	83 c2 30             	add    $0x30,%edx
  801115:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801117:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80111a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80111f:	f7 e9                	imul   %ecx
  801121:	c1 fa 02             	sar    $0x2,%edx
  801124:	89 c8                	mov    %ecx,%eax
  801126:	c1 f8 1f             	sar    $0x1f,%eax
  801129:	29 c2                	sub    %eax,%edx
  80112b:	89 d0                	mov    %edx,%eax
  80112d:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801130:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801133:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801138:	f7 e9                	imul   %ecx
  80113a:	c1 fa 02             	sar    $0x2,%edx
  80113d:	89 c8                	mov    %ecx,%eax
  80113f:	c1 f8 1f             	sar    $0x1f,%eax
  801142:	29 c2                	sub    %eax,%edx
  801144:	89 d0                	mov    %edx,%eax
  801146:	c1 e0 02             	shl    $0x2,%eax
  801149:	01 d0                	add    %edx,%eax
  80114b:	01 c0                	add    %eax,%eax
  80114d:	29 c1                	sub    %eax,%ecx
  80114f:	89 ca                	mov    %ecx,%edx
  801151:	85 d2                	test   %edx,%edx
  801153:	75 9c                	jne    8010f1 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801155:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80115c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80115f:	48                   	dec    %eax
  801160:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801163:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801167:	74 3d                	je     8011a6 <ltostr+0xe2>
		start = 1 ;
  801169:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801170:	eb 34                	jmp    8011a6 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801172:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801175:	8b 45 0c             	mov    0xc(%ebp),%eax
  801178:	01 d0                	add    %edx,%eax
  80117a:	8a 00                	mov    (%eax),%al
  80117c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80117f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801182:	8b 45 0c             	mov    0xc(%ebp),%eax
  801185:	01 c2                	add    %eax,%edx
  801187:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80118a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118d:	01 c8                	add    %ecx,%eax
  80118f:	8a 00                	mov    (%eax),%al
  801191:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801193:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801196:	8b 45 0c             	mov    0xc(%ebp),%eax
  801199:	01 c2                	add    %eax,%edx
  80119b:	8a 45 eb             	mov    -0x15(%ebp),%al
  80119e:	88 02                	mov    %al,(%edx)
		start++ ;
  8011a0:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011a3:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011a9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011ac:	7c c4                	jl     801172 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011ae:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b4:	01 d0                	add    %edx,%eax
  8011b6:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011b9:	90                   	nop
  8011ba:	c9                   	leave  
  8011bb:	c3                   	ret    

008011bc <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011bc:	55                   	push   %ebp
  8011bd:	89 e5                	mov    %esp,%ebp
  8011bf:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011c2:	ff 75 08             	pushl  0x8(%ebp)
  8011c5:	e8 54 fa ff ff       	call   800c1e <strlen>
  8011ca:	83 c4 04             	add    $0x4,%esp
  8011cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011d0:	ff 75 0c             	pushl  0xc(%ebp)
  8011d3:	e8 46 fa ff ff       	call   800c1e <strlen>
  8011d8:	83 c4 04             	add    $0x4,%esp
  8011db:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011ec:	eb 17                	jmp    801205 <strcconcat+0x49>
		final[s] = str1[s] ;
  8011ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f4:	01 c2                	add    %eax,%edx
  8011f6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fc:	01 c8                	add    %ecx,%eax
  8011fe:	8a 00                	mov    (%eax),%al
  801200:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801202:	ff 45 fc             	incl   -0x4(%ebp)
  801205:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801208:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80120b:	7c e1                	jl     8011ee <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80120d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801214:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80121b:	eb 1f                	jmp    80123c <strcconcat+0x80>
		final[s++] = str2[i] ;
  80121d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801220:	8d 50 01             	lea    0x1(%eax),%edx
  801223:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801226:	89 c2                	mov    %eax,%edx
  801228:	8b 45 10             	mov    0x10(%ebp),%eax
  80122b:	01 c2                	add    %eax,%edx
  80122d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801230:	8b 45 0c             	mov    0xc(%ebp),%eax
  801233:	01 c8                	add    %ecx,%eax
  801235:	8a 00                	mov    (%eax),%al
  801237:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801239:	ff 45 f8             	incl   -0x8(%ebp)
  80123c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80123f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801242:	7c d9                	jl     80121d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801244:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801247:	8b 45 10             	mov    0x10(%ebp),%eax
  80124a:	01 d0                	add    %edx,%eax
  80124c:	c6 00 00             	movb   $0x0,(%eax)
}
  80124f:	90                   	nop
  801250:	c9                   	leave  
  801251:	c3                   	ret    

00801252 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801252:	55                   	push   %ebp
  801253:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801255:	8b 45 14             	mov    0x14(%ebp),%eax
  801258:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80125e:	8b 45 14             	mov    0x14(%ebp),%eax
  801261:	8b 00                	mov    (%eax),%eax
  801263:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80126a:	8b 45 10             	mov    0x10(%ebp),%eax
  80126d:	01 d0                	add    %edx,%eax
  80126f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801275:	eb 0c                	jmp    801283 <strsplit+0x31>
			*string++ = 0;
  801277:	8b 45 08             	mov    0x8(%ebp),%eax
  80127a:	8d 50 01             	lea    0x1(%eax),%edx
  80127d:	89 55 08             	mov    %edx,0x8(%ebp)
  801280:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	8a 00                	mov    (%eax),%al
  801288:	84 c0                	test   %al,%al
  80128a:	74 18                	je     8012a4 <strsplit+0x52>
  80128c:	8b 45 08             	mov    0x8(%ebp),%eax
  80128f:	8a 00                	mov    (%eax),%al
  801291:	0f be c0             	movsbl %al,%eax
  801294:	50                   	push   %eax
  801295:	ff 75 0c             	pushl  0xc(%ebp)
  801298:	e8 13 fb ff ff       	call   800db0 <strchr>
  80129d:	83 c4 08             	add    $0x8,%esp
  8012a0:	85 c0                	test   %eax,%eax
  8012a2:	75 d3                	jne    801277 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a7:	8a 00                	mov    (%eax),%al
  8012a9:	84 c0                	test   %al,%al
  8012ab:	74 5a                	je     801307 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8012b0:	8b 00                	mov    (%eax),%eax
  8012b2:	83 f8 0f             	cmp    $0xf,%eax
  8012b5:	75 07                	jne    8012be <strsplit+0x6c>
		{
			return 0;
  8012b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8012bc:	eb 66                	jmp    801324 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012be:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c1:	8b 00                	mov    (%eax),%eax
  8012c3:	8d 48 01             	lea    0x1(%eax),%ecx
  8012c6:	8b 55 14             	mov    0x14(%ebp),%edx
  8012c9:	89 0a                	mov    %ecx,(%edx)
  8012cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d5:	01 c2                	add    %eax,%edx
  8012d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012da:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012dc:	eb 03                	jmp    8012e1 <strsplit+0x8f>
			string++;
  8012de:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e4:	8a 00                	mov    (%eax),%al
  8012e6:	84 c0                	test   %al,%al
  8012e8:	74 8b                	je     801275 <strsplit+0x23>
  8012ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ed:	8a 00                	mov    (%eax),%al
  8012ef:	0f be c0             	movsbl %al,%eax
  8012f2:	50                   	push   %eax
  8012f3:	ff 75 0c             	pushl  0xc(%ebp)
  8012f6:	e8 b5 fa ff ff       	call   800db0 <strchr>
  8012fb:	83 c4 08             	add    $0x8,%esp
  8012fe:	85 c0                	test   %eax,%eax
  801300:	74 dc                	je     8012de <strsplit+0x8c>
			string++;
	}
  801302:	e9 6e ff ff ff       	jmp    801275 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801307:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801308:	8b 45 14             	mov    0x14(%ebp),%eax
  80130b:	8b 00                	mov    (%eax),%eax
  80130d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801314:	8b 45 10             	mov    0x10(%ebp),%eax
  801317:	01 d0                	add    %edx,%eax
  801319:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80131f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801324:	c9                   	leave  
  801325:	c3                   	ret    

00801326 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801326:	55                   	push   %ebp
  801327:	89 e5                	mov    %esp,%ebp
  801329:	57                   	push   %edi
  80132a:	56                   	push   %esi
  80132b:	53                   	push   %ebx
  80132c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80132f:	8b 45 08             	mov    0x8(%ebp),%eax
  801332:	8b 55 0c             	mov    0xc(%ebp),%edx
  801335:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801338:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80133b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80133e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801341:	cd 30                	int    $0x30
  801343:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801346:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801349:	83 c4 10             	add    $0x10,%esp
  80134c:	5b                   	pop    %ebx
  80134d:	5e                   	pop    %esi
  80134e:	5f                   	pop    %edi
  80134f:	5d                   	pop    %ebp
  801350:	c3                   	ret    

00801351 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801351:	55                   	push   %ebp
  801352:	89 e5                	mov    %esp,%ebp
  801354:	83 ec 04             	sub    $0x4,%esp
  801357:	8b 45 10             	mov    0x10(%ebp),%eax
  80135a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80135d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801361:	8b 45 08             	mov    0x8(%ebp),%eax
  801364:	6a 00                	push   $0x0
  801366:	6a 00                	push   $0x0
  801368:	52                   	push   %edx
  801369:	ff 75 0c             	pushl  0xc(%ebp)
  80136c:	50                   	push   %eax
  80136d:	6a 00                	push   $0x0
  80136f:	e8 b2 ff ff ff       	call   801326 <syscall>
  801374:	83 c4 18             	add    $0x18,%esp
}
  801377:	90                   	nop
  801378:	c9                   	leave  
  801379:	c3                   	ret    

0080137a <sys_cgetc>:

int
sys_cgetc(void)
{
  80137a:	55                   	push   %ebp
  80137b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80137d:	6a 00                	push   $0x0
  80137f:	6a 00                	push   $0x0
  801381:	6a 00                	push   $0x0
  801383:	6a 00                	push   $0x0
  801385:	6a 00                	push   $0x0
  801387:	6a 01                	push   $0x1
  801389:	e8 98 ff ff ff       	call   801326 <syscall>
  80138e:	83 c4 18             	add    $0x18,%esp
}
  801391:	c9                   	leave  
  801392:	c3                   	ret    

00801393 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801393:	55                   	push   %ebp
  801394:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801396:	8b 55 0c             	mov    0xc(%ebp),%edx
  801399:	8b 45 08             	mov    0x8(%ebp),%eax
  80139c:	6a 00                	push   $0x0
  80139e:	6a 00                	push   $0x0
  8013a0:	6a 00                	push   $0x0
  8013a2:	52                   	push   %edx
  8013a3:	50                   	push   %eax
  8013a4:	6a 05                	push   $0x5
  8013a6:	e8 7b ff ff ff       	call   801326 <syscall>
  8013ab:	83 c4 18             	add    $0x18,%esp
}
  8013ae:	c9                   	leave  
  8013af:	c3                   	ret    

008013b0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8013b0:	55                   	push   %ebp
  8013b1:	89 e5                	mov    %esp,%ebp
  8013b3:	56                   	push   %esi
  8013b4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8013b5:	8b 75 18             	mov    0x18(%ebp),%esi
  8013b8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8013bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c4:	56                   	push   %esi
  8013c5:	53                   	push   %ebx
  8013c6:	51                   	push   %ecx
  8013c7:	52                   	push   %edx
  8013c8:	50                   	push   %eax
  8013c9:	6a 06                	push   $0x6
  8013cb:	e8 56 ff ff ff       	call   801326 <syscall>
  8013d0:	83 c4 18             	add    $0x18,%esp
}
  8013d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013d6:	5b                   	pop    %ebx
  8013d7:	5e                   	pop    %esi
  8013d8:	5d                   	pop    %ebp
  8013d9:	c3                   	ret    

008013da <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8013da:	55                   	push   %ebp
  8013db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8013dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e3:	6a 00                	push   $0x0
  8013e5:	6a 00                	push   $0x0
  8013e7:	6a 00                	push   $0x0
  8013e9:	52                   	push   %edx
  8013ea:	50                   	push   %eax
  8013eb:	6a 07                	push   $0x7
  8013ed:	e8 34 ff ff ff       	call   801326 <syscall>
  8013f2:	83 c4 18             	add    $0x18,%esp
}
  8013f5:	c9                   	leave  
  8013f6:	c3                   	ret    

008013f7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8013f7:	55                   	push   %ebp
  8013f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8013fa:	6a 00                	push   $0x0
  8013fc:	6a 00                	push   $0x0
  8013fe:	6a 00                	push   $0x0
  801400:	ff 75 0c             	pushl  0xc(%ebp)
  801403:	ff 75 08             	pushl  0x8(%ebp)
  801406:	6a 08                	push   $0x8
  801408:	e8 19 ff ff ff       	call   801326 <syscall>
  80140d:	83 c4 18             	add    $0x18,%esp
}
  801410:	c9                   	leave  
  801411:	c3                   	ret    

00801412 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801412:	55                   	push   %ebp
  801413:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801415:	6a 00                	push   $0x0
  801417:	6a 00                	push   $0x0
  801419:	6a 00                	push   $0x0
  80141b:	6a 00                	push   $0x0
  80141d:	6a 00                	push   $0x0
  80141f:	6a 09                	push   $0x9
  801421:	e8 00 ff ff ff       	call   801326 <syscall>
  801426:	83 c4 18             	add    $0x18,%esp
}
  801429:	c9                   	leave  
  80142a:	c3                   	ret    

0080142b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80142b:	55                   	push   %ebp
  80142c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80142e:	6a 00                	push   $0x0
  801430:	6a 00                	push   $0x0
  801432:	6a 00                	push   $0x0
  801434:	6a 00                	push   $0x0
  801436:	6a 00                	push   $0x0
  801438:	6a 0a                	push   $0xa
  80143a:	e8 e7 fe ff ff       	call   801326 <syscall>
  80143f:	83 c4 18             	add    $0x18,%esp
}
  801442:	c9                   	leave  
  801443:	c3                   	ret    

00801444 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801444:	55                   	push   %ebp
  801445:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801447:	6a 00                	push   $0x0
  801449:	6a 00                	push   $0x0
  80144b:	6a 00                	push   $0x0
  80144d:	6a 00                	push   $0x0
  80144f:	6a 00                	push   $0x0
  801451:	6a 0b                	push   $0xb
  801453:	e8 ce fe ff ff       	call   801326 <syscall>
  801458:	83 c4 18             	add    $0x18,%esp
}
  80145b:	c9                   	leave  
  80145c:	c3                   	ret    

0080145d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80145d:	55                   	push   %ebp
  80145e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801460:	6a 00                	push   $0x0
  801462:	6a 00                	push   $0x0
  801464:	6a 00                	push   $0x0
  801466:	ff 75 0c             	pushl  0xc(%ebp)
  801469:	ff 75 08             	pushl  0x8(%ebp)
  80146c:	6a 0f                	push   $0xf
  80146e:	e8 b3 fe ff ff       	call   801326 <syscall>
  801473:	83 c4 18             	add    $0x18,%esp
	return;
  801476:	90                   	nop
}
  801477:	c9                   	leave  
  801478:	c3                   	ret    

00801479 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801479:	55                   	push   %ebp
  80147a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80147c:	6a 00                	push   $0x0
  80147e:	6a 00                	push   $0x0
  801480:	6a 00                	push   $0x0
  801482:	ff 75 0c             	pushl  0xc(%ebp)
  801485:	ff 75 08             	pushl  0x8(%ebp)
  801488:	6a 10                	push   $0x10
  80148a:	e8 97 fe ff ff       	call   801326 <syscall>
  80148f:	83 c4 18             	add    $0x18,%esp
	return ;
  801492:	90                   	nop
}
  801493:	c9                   	leave  
  801494:	c3                   	ret    

00801495 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801495:	55                   	push   %ebp
  801496:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801498:	6a 00                	push   $0x0
  80149a:	6a 00                	push   $0x0
  80149c:	ff 75 10             	pushl  0x10(%ebp)
  80149f:	ff 75 0c             	pushl  0xc(%ebp)
  8014a2:	ff 75 08             	pushl  0x8(%ebp)
  8014a5:	6a 11                	push   $0x11
  8014a7:	e8 7a fe ff ff       	call   801326 <syscall>
  8014ac:	83 c4 18             	add    $0x18,%esp
	return ;
  8014af:	90                   	nop
}
  8014b0:	c9                   	leave  
  8014b1:	c3                   	ret    

008014b2 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8014b2:	55                   	push   %ebp
  8014b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8014b5:	6a 00                	push   $0x0
  8014b7:	6a 00                	push   $0x0
  8014b9:	6a 00                	push   $0x0
  8014bb:	6a 00                	push   $0x0
  8014bd:	6a 00                	push   $0x0
  8014bf:	6a 0c                	push   $0xc
  8014c1:	e8 60 fe ff ff       	call   801326 <syscall>
  8014c6:	83 c4 18             	add    $0x18,%esp
}
  8014c9:	c9                   	leave  
  8014ca:	c3                   	ret    

008014cb <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8014cb:	55                   	push   %ebp
  8014cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8014ce:	6a 00                	push   $0x0
  8014d0:	6a 00                	push   $0x0
  8014d2:	6a 00                	push   $0x0
  8014d4:	6a 00                	push   $0x0
  8014d6:	ff 75 08             	pushl  0x8(%ebp)
  8014d9:	6a 0d                	push   $0xd
  8014db:	e8 46 fe ff ff       	call   801326 <syscall>
  8014e0:	83 c4 18             	add    $0x18,%esp
}
  8014e3:	c9                   	leave  
  8014e4:	c3                   	ret    

008014e5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8014e5:	55                   	push   %ebp
  8014e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8014e8:	6a 00                	push   $0x0
  8014ea:	6a 00                	push   $0x0
  8014ec:	6a 00                	push   $0x0
  8014ee:	6a 00                	push   $0x0
  8014f0:	6a 00                	push   $0x0
  8014f2:	6a 0e                	push   $0xe
  8014f4:	e8 2d fe ff ff       	call   801326 <syscall>
  8014f9:	83 c4 18             	add    $0x18,%esp
}
  8014fc:	90                   	nop
  8014fd:	c9                   	leave  
  8014fe:	c3                   	ret    

008014ff <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8014ff:	55                   	push   %ebp
  801500:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801502:	6a 00                	push   $0x0
  801504:	6a 00                	push   $0x0
  801506:	6a 00                	push   $0x0
  801508:	6a 00                	push   $0x0
  80150a:	6a 00                	push   $0x0
  80150c:	6a 13                	push   $0x13
  80150e:	e8 13 fe ff ff       	call   801326 <syscall>
  801513:	83 c4 18             	add    $0x18,%esp
}
  801516:	90                   	nop
  801517:	c9                   	leave  
  801518:	c3                   	ret    

00801519 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801519:	55                   	push   %ebp
  80151a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80151c:	6a 00                	push   $0x0
  80151e:	6a 00                	push   $0x0
  801520:	6a 00                	push   $0x0
  801522:	6a 00                	push   $0x0
  801524:	6a 00                	push   $0x0
  801526:	6a 14                	push   $0x14
  801528:	e8 f9 fd ff ff       	call   801326 <syscall>
  80152d:	83 c4 18             	add    $0x18,%esp
}
  801530:	90                   	nop
  801531:	c9                   	leave  
  801532:	c3                   	ret    

00801533 <sys_cputc>:


void
sys_cputc(const char c)
{
  801533:	55                   	push   %ebp
  801534:	89 e5                	mov    %esp,%ebp
  801536:	83 ec 04             	sub    $0x4,%esp
  801539:	8b 45 08             	mov    0x8(%ebp),%eax
  80153c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80153f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801543:	6a 00                	push   $0x0
  801545:	6a 00                	push   $0x0
  801547:	6a 00                	push   $0x0
  801549:	6a 00                	push   $0x0
  80154b:	50                   	push   %eax
  80154c:	6a 15                	push   $0x15
  80154e:	e8 d3 fd ff ff       	call   801326 <syscall>
  801553:	83 c4 18             	add    $0x18,%esp
}
  801556:	90                   	nop
  801557:	c9                   	leave  
  801558:	c3                   	ret    

00801559 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801559:	55                   	push   %ebp
  80155a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80155c:	6a 00                	push   $0x0
  80155e:	6a 00                	push   $0x0
  801560:	6a 00                	push   $0x0
  801562:	6a 00                	push   $0x0
  801564:	6a 00                	push   $0x0
  801566:	6a 16                	push   $0x16
  801568:	e8 b9 fd ff ff       	call   801326 <syscall>
  80156d:	83 c4 18             	add    $0x18,%esp
}
  801570:	90                   	nop
  801571:	c9                   	leave  
  801572:	c3                   	ret    

00801573 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801573:	55                   	push   %ebp
  801574:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801576:	8b 45 08             	mov    0x8(%ebp),%eax
  801579:	6a 00                	push   $0x0
  80157b:	6a 00                	push   $0x0
  80157d:	6a 00                	push   $0x0
  80157f:	ff 75 0c             	pushl  0xc(%ebp)
  801582:	50                   	push   %eax
  801583:	6a 17                	push   $0x17
  801585:	e8 9c fd ff ff       	call   801326 <syscall>
  80158a:	83 c4 18             	add    $0x18,%esp
}
  80158d:	c9                   	leave  
  80158e:	c3                   	ret    

0080158f <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80158f:	55                   	push   %ebp
  801590:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801592:	8b 55 0c             	mov    0xc(%ebp),%edx
  801595:	8b 45 08             	mov    0x8(%ebp),%eax
  801598:	6a 00                	push   $0x0
  80159a:	6a 00                	push   $0x0
  80159c:	6a 00                	push   $0x0
  80159e:	52                   	push   %edx
  80159f:	50                   	push   %eax
  8015a0:	6a 1a                	push   $0x1a
  8015a2:	e8 7f fd ff ff       	call   801326 <syscall>
  8015a7:	83 c4 18             	add    $0x18,%esp
}
  8015aa:	c9                   	leave  
  8015ab:	c3                   	ret    

008015ac <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8015ac:	55                   	push   %ebp
  8015ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8015af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b5:	6a 00                	push   $0x0
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 00                	push   $0x0
  8015bb:	52                   	push   %edx
  8015bc:	50                   	push   %eax
  8015bd:	6a 18                	push   $0x18
  8015bf:	e8 62 fd ff ff       	call   801326 <syscall>
  8015c4:	83 c4 18             	add    $0x18,%esp
}
  8015c7:	90                   	nop
  8015c8:	c9                   	leave  
  8015c9:	c3                   	ret    

008015ca <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8015ca:	55                   	push   %ebp
  8015cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8015cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 00                	push   $0x0
  8015d7:	6a 00                	push   $0x0
  8015d9:	52                   	push   %edx
  8015da:	50                   	push   %eax
  8015db:	6a 19                	push   $0x19
  8015dd:	e8 44 fd ff ff       	call   801326 <syscall>
  8015e2:	83 c4 18             	add    $0x18,%esp
}
  8015e5:	90                   	nop
  8015e6:	c9                   	leave  
  8015e7:	c3                   	ret    

008015e8 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8015e8:	55                   	push   %ebp
  8015e9:	89 e5                	mov    %esp,%ebp
  8015eb:	83 ec 04             	sub    $0x4,%esp
  8015ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8015f4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8015f7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fe:	6a 00                	push   $0x0
  801600:	51                   	push   %ecx
  801601:	52                   	push   %edx
  801602:	ff 75 0c             	pushl  0xc(%ebp)
  801605:	50                   	push   %eax
  801606:	6a 1b                	push   $0x1b
  801608:	e8 19 fd ff ff       	call   801326 <syscall>
  80160d:	83 c4 18             	add    $0x18,%esp
}
  801610:	c9                   	leave  
  801611:	c3                   	ret    

00801612 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801612:	55                   	push   %ebp
  801613:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801615:	8b 55 0c             	mov    0xc(%ebp),%edx
  801618:	8b 45 08             	mov    0x8(%ebp),%eax
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	6a 00                	push   $0x0
  801621:	52                   	push   %edx
  801622:	50                   	push   %eax
  801623:	6a 1c                	push   $0x1c
  801625:	e8 fc fc ff ff       	call   801326 <syscall>
  80162a:	83 c4 18             	add    $0x18,%esp
}
  80162d:	c9                   	leave  
  80162e:	c3                   	ret    

0080162f <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80162f:	55                   	push   %ebp
  801630:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801632:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801635:	8b 55 0c             	mov    0xc(%ebp),%edx
  801638:	8b 45 08             	mov    0x8(%ebp),%eax
  80163b:	6a 00                	push   $0x0
  80163d:	6a 00                	push   $0x0
  80163f:	51                   	push   %ecx
  801640:	52                   	push   %edx
  801641:	50                   	push   %eax
  801642:	6a 1d                	push   $0x1d
  801644:	e8 dd fc ff ff       	call   801326 <syscall>
  801649:	83 c4 18             	add    $0x18,%esp
}
  80164c:	c9                   	leave  
  80164d:	c3                   	ret    

0080164e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80164e:	55                   	push   %ebp
  80164f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801651:	8b 55 0c             	mov    0xc(%ebp),%edx
  801654:	8b 45 08             	mov    0x8(%ebp),%eax
  801657:	6a 00                	push   $0x0
  801659:	6a 00                	push   $0x0
  80165b:	6a 00                	push   $0x0
  80165d:	52                   	push   %edx
  80165e:	50                   	push   %eax
  80165f:	6a 1e                	push   $0x1e
  801661:	e8 c0 fc ff ff       	call   801326 <syscall>
  801666:	83 c4 18             	add    $0x18,%esp
}
  801669:	c9                   	leave  
  80166a:	c3                   	ret    

0080166b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80166b:	55                   	push   %ebp
  80166c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80166e:	6a 00                	push   $0x0
  801670:	6a 00                	push   $0x0
  801672:	6a 00                	push   $0x0
  801674:	6a 00                	push   $0x0
  801676:	6a 00                	push   $0x0
  801678:	6a 1f                	push   $0x1f
  80167a:	e8 a7 fc ff ff       	call   801326 <syscall>
  80167f:	83 c4 18             	add    $0x18,%esp
}
  801682:	c9                   	leave  
  801683:	c3                   	ret    

00801684 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801684:	55                   	push   %ebp
  801685:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801687:	8b 45 08             	mov    0x8(%ebp),%eax
  80168a:	6a 00                	push   $0x0
  80168c:	ff 75 14             	pushl  0x14(%ebp)
  80168f:	ff 75 10             	pushl  0x10(%ebp)
  801692:	ff 75 0c             	pushl  0xc(%ebp)
  801695:	50                   	push   %eax
  801696:	6a 20                	push   $0x20
  801698:	e8 89 fc ff ff       	call   801326 <syscall>
  80169d:	83 c4 18             	add    $0x18,%esp
}
  8016a0:	c9                   	leave  
  8016a1:	c3                   	ret    

008016a2 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8016a2:	55                   	push   %ebp
  8016a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8016a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 00                	push   $0x0
  8016b0:	50                   	push   %eax
  8016b1:	6a 21                	push   $0x21
  8016b3:	e8 6e fc ff ff       	call   801326 <syscall>
  8016b8:	83 c4 18             	add    $0x18,%esp
}
  8016bb:	90                   	nop
  8016bc:	c9                   	leave  
  8016bd:	c3                   	ret    

008016be <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8016c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 00                	push   $0x0
  8016cc:	50                   	push   %eax
  8016cd:	6a 22                	push   $0x22
  8016cf:	e8 52 fc ff ff       	call   801326 <syscall>
  8016d4:	83 c4 18             	add    $0x18,%esp
}
  8016d7:	c9                   	leave  
  8016d8:	c3                   	ret    

008016d9 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8016d9:	55                   	push   %ebp
  8016da:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8016dc:	6a 00                	push   $0x0
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 02                	push   $0x2
  8016e8:	e8 39 fc ff ff       	call   801326 <syscall>
  8016ed:	83 c4 18             	add    $0x18,%esp
}
  8016f0:	c9                   	leave  
  8016f1:	c3                   	ret    

008016f2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8016f2:	55                   	push   %ebp
  8016f3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 03                	push   $0x3
  801701:	e8 20 fc ff ff       	call   801326 <syscall>
  801706:	83 c4 18             	add    $0x18,%esp
}
  801709:	c9                   	leave  
  80170a:	c3                   	ret    

0080170b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80170b:	55                   	push   %ebp
  80170c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	6a 00                	push   $0x0
  801714:	6a 00                	push   $0x0
  801716:	6a 00                	push   $0x0
  801718:	6a 04                	push   $0x4
  80171a:	e8 07 fc ff ff       	call   801326 <syscall>
  80171f:	83 c4 18             	add    $0x18,%esp
}
  801722:	c9                   	leave  
  801723:	c3                   	ret    

00801724 <sys_exit_env>:


void sys_exit_env(void)
{
  801724:	55                   	push   %ebp
  801725:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801727:	6a 00                	push   $0x0
  801729:	6a 00                	push   $0x0
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	6a 00                	push   $0x0
  801731:	6a 23                	push   $0x23
  801733:	e8 ee fb ff ff       	call   801326 <syscall>
  801738:	83 c4 18             	add    $0x18,%esp
}
  80173b:	90                   	nop
  80173c:	c9                   	leave  
  80173d:	c3                   	ret    

0080173e <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
  801741:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801744:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801747:	8d 50 04             	lea    0x4(%eax),%edx
  80174a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	52                   	push   %edx
  801754:	50                   	push   %eax
  801755:	6a 24                	push   $0x24
  801757:	e8 ca fb ff ff       	call   801326 <syscall>
  80175c:	83 c4 18             	add    $0x18,%esp
	return result;
  80175f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801762:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801765:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801768:	89 01                	mov    %eax,(%ecx)
  80176a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80176d:	8b 45 08             	mov    0x8(%ebp),%eax
  801770:	c9                   	leave  
  801771:	c2 04 00             	ret    $0x4

00801774 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801774:	55                   	push   %ebp
  801775:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	ff 75 10             	pushl  0x10(%ebp)
  80177e:	ff 75 0c             	pushl  0xc(%ebp)
  801781:	ff 75 08             	pushl  0x8(%ebp)
  801784:	6a 12                	push   $0x12
  801786:	e8 9b fb ff ff       	call   801326 <syscall>
  80178b:	83 c4 18             	add    $0x18,%esp
	return ;
  80178e:	90                   	nop
}
  80178f:	c9                   	leave  
  801790:	c3                   	ret    

00801791 <sys_rcr2>:
uint32 sys_rcr2()
{
  801791:	55                   	push   %ebp
  801792:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 25                	push   $0x25
  8017a0:	e8 81 fb ff ff       	call   801326 <syscall>
  8017a5:	83 c4 18             	add    $0x18,%esp
}
  8017a8:	c9                   	leave  
  8017a9:	c3                   	ret    

008017aa <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8017aa:	55                   	push   %ebp
  8017ab:	89 e5                	mov    %esp,%ebp
  8017ad:	83 ec 04             	sub    $0x4,%esp
  8017b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8017b6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 00                	push   $0x0
  8017c2:	50                   	push   %eax
  8017c3:	6a 26                	push   $0x26
  8017c5:	e8 5c fb ff ff       	call   801326 <syscall>
  8017ca:	83 c4 18             	add    $0x18,%esp
	return ;
  8017cd:	90                   	nop
}
  8017ce:	c9                   	leave  
  8017cf:	c3                   	ret    

008017d0 <rsttst>:
void rsttst()
{
  8017d0:	55                   	push   %ebp
  8017d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	6a 00                	push   $0x0
  8017dd:	6a 28                	push   $0x28
  8017df:	e8 42 fb ff ff       	call   801326 <syscall>
  8017e4:	83 c4 18             	add    $0x18,%esp
	return ;
  8017e7:	90                   	nop
}
  8017e8:	c9                   	leave  
  8017e9:	c3                   	ret    

008017ea <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
  8017ed:	83 ec 04             	sub    $0x4,%esp
  8017f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8017f3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8017f6:	8b 55 18             	mov    0x18(%ebp),%edx
  8017f9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017fd:	52                   	push   %edx
  8017fe:	50                   	push   %eax
  8017ff:	ff 75 10             	pushl  0x10(%ebp)
  801802:	ff 75 0c             	pushl  0xc(%ebp)
  801805:	ff 75 08             	pushl  0x8(%ebp)
  801808:	6a 27                	push   $0x27
  80180a:	e8 17 fb ff ff       	call   801326 <syscall>
  80180f:	83 c4 18             	add    $0x18,%esp
	return ;
  801812:	90                   	nop
}
  801813:	c9                   	leave  
  801814:	c3                   	ret    

00801815 <chktst>:
void chktst(uint32 n)
{
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	ff 75 08             	pushl  0x8(%ebp)
  801823:	6a 29                	push   $0x29
  801825:	e8 fc fa ff ff       	call   801326 <syscall>
  80182a:	83 c4 18             	add    $0x18,%esp
	return ;
  80182d:	90                   	nop
}
  80182e:	c9                   	leave  
  80182f:	c3                   	ret    

00801830 <inctst>:

void inctst()
{
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 2a                	push   $0x2a
  80183f:	e8 e2 fa ff ff       	call   801326 <syscall>
  801844:	83 c4 18             	add    $0x18,%esp
	return ;
  801847:	90                   	nop
}
  801848:	c9                   	leave  
  801849:	c3                   	ret    

0080184a <gettst>:
uint32 gettst()
{
  80184a:	55                   	push   %ebp
  80184b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	6a 2b                	push   $0x2b
  801859:	e8 c8 fa ff ff       	call   801326 <syscall>
  80185e:	83 c4 18             	add    $0x18,%esp
}
  801861:	c9                   	leave  
  801862:	c3                   	ret    

00801863 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801863:	55                   	push   %ebp
  801864:	89 e5                	mov    %esp,%ebp
  801866:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 2c                	push   $0x2c
  801875:	e8 ac fa ff ff       	call   801326 <syscall>
  80187a:	83 c4 18             	add    $0x18,%esp
  80187d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801880:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801884:	75 07                	jne    80188d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801886:	b8 01 00 00 00       	mov    $0x1,%eax
  80188b:	eb 05                	jmp    801892 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80188d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801892:	c9                   	leave  
  801893:	c3                   	ret    

00801894 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801894:	55                   	push   %ebp
  801895:	89 e5                	mov    %esp,%ebp
  801897:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 2c                	push   $0x2c
  8018a6:	e8 7b fa ff ff       	call   801326 <syscall>
  8018ab:	83 c4 18             	add    $0x18,%esp
  8018ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8018b1:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8018b5:	75 07                	jne    8018be <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8018b7:	b8 01 00 00 00       	mov    $0x1,%eax
  8018bc:	eb 05                	jmp    8018c3 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8018be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018c3:	c9                   	leave  
  8018c4:	c3                   	ret    

008018c5 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8018c5:	55                   	push   %ebp
  8018c6:	89 e5                	mov    %esp,%ebp
  8018c8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 2c                	push   $0x2c
  8018d7:	e8 4a fa ff ff       	call   801326 <syscall>
  8018dc:	83 c4 18             	add    $0x18,%esp
  8018df:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8018e2:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8018e6:	75 07                	jne    8018ef <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8018e8:	b8 01 00 00 00       	mov    $0x1,%eax
  8018ed:	eb 05                	jmp    8018f4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8018ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018f4:	c9                   	leave  
  8018f5:	c3                   	ret    

008018f6 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8018f6:	55                   	push   %ebp
  8018f7:	89 e5                	mov    %esp,%ebp
  8018f9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 2c                	push   $0x2c
  801908:	e8 19 fa ff ff       	call   801326 <syscall>
  80190d:	83 c4 18             	add    $0x18,%esp
  801910:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801913:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801917:	75 07                	jne    801920 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801919:	b8 01 00 00 00       	mov    $0x1,%eax
  80191e:	eb 05                	jmp    801925 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801920:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801925:	c9                   	leave  
  801926:	c3                   	ret    

00801927 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801927:	55                   	push   %ebp
  801928:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	ff 75 08             	pushl  0x8(%ebp)
  801935:	6a 2d                	push   $0x2d
  801937:	e8 ea f9 ff ff       	call   801326 <syscall>
  80193c:	83 c4 18             	add    $0x18,%esp
	return ;
  80193f:	90                   	nop
}
  801940:	c9                   	leave  
  801941:	c3                   	ret    

00801942 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
  801945:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801946:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801949:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80194c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194f:	8b 45 08             	mov    0x8(%ebp),%eax
  801952:	6a 00                	push   $0x0
  801954:	53                   	push   %ebx
  801955:	51                   	push   %ecx
  801956:	52                   	push   %edx
  801957:	50                   	push   %eax
  801958:	6a 2e                	push   $0x2e
  80195a:	e8 c7 f9 ff ff       	call   801326 <syscall>
  80195f:	83 c4 18             	add    $0x18,%esp
}
  801962:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801965:	c9                   	leave  
  801966:	c3                   	ret    

00801967 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801967:	55                   	push   %ebp
  801968:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80196a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196d:	8b 45 08             	mov    0x8(%ebp),%eax
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	52                   	push   %edx
  801977:	50                   	push   %eax
  801978:	6a 2f                	push   $0x2f
  80197a:	e8 a7 f9 ff ff       	call   801326 <syscall>
  80197f:	83 c4 18             	add    $0x18,%esp
}
  801982:	c9                   	leave  
  801983:	c3                   	ret    

00801984 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
  801987:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80198a:	8b 55 08             	mov    0x8(%ebp),%edx
  80198d:	89 d0                	mov    %edx,%eax
  80198f:	c1 e0 02             	shl    $0x2,%eax
  801992:	01 d0                	add    %edx,%eax
  801994:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80199b:	01 d0                	add    %edx,%eax
  80199d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019a4:	01 d0                	add    %edx,%eax
  8019a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019ad:	01 d0                	add    %edx,%eax
  8019af:	c1 e0 04             	shl    $0x4,%eax
  8019b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8019b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8019bc:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8019bf:	83 ec 0c             	sub    $0xc,%esp
  8019c2:	50                   	push   %eax
  8019c3:	e8 76 fd ff ff       	call   80173e <sys_get_virtual_time>
  8019c8:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8019cb:	eb 41                	jmp    801a0e <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8019cd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8019d0:	83 ec 0c             	sub    $0xc,%esp
  8019d3:	50                   	push   %eax
  8019d4:	e8 65 fd ff ff       	call   80173e <sys_get_virtual_time>
  8019d9:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8019dc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019e2:	29 c2                	sub    %eax,%edx
  8019e4:	89 d0                	mov    %edx,%eax
  8019e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8019e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8019ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019ef:	89 d1                	mov    %edx,%ecx
  8019f1:	29 c1                	sub    %eax,%ecx
  8019f3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8019f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019f9:	39 c2                	cmp    %eax,%edx
  8019fb:	0f 97 c0             	seta   %al
  8019fe:	0f b6 c0             	movzbl %al,%eax
  801a01:	29 c1                	sub    %eax,%ecx
  801a03:	89 c8                	mov    %ecx,%eax
  801a05:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801a08:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a11:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a14:	72 b7                	jb     8019cd <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801a16:	90                   	nop
  801a17:	c9                   	leave  
  801a18:	c3                   	ret    

00801a19 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801a19:	55                   	push   %ebp
  801a1a:	89 e5                	mov    %esp,%ebp
  801a1c:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801a1f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801a26:	eb 03                	jmp    801a2b <busy_wait+0x12>
  801a28:	ff 45 fc             	incl   -0x4(%ebp)
  801a2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a2e:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a31:	72 f5                	jb     801a28 <busy_wait+0xf>
	return i;
  801a33:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801a36:	c9                   	leave  
  801a37:	c3                   	ret    

00801a38 <__udivdi3>:
  801a38:	55                   	push   %ebp
  801a39:	57                   	push   %edi
  801a3a:	56                   	push   %esi
  801a3b:	53                   	push   %ebx
  801a3c:	83 ec 1c             	sub    $0x1c,%esp
  801a3f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a43:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a47:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a4b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a4f:	89 ca                	mov    %ecx,%edx
  801a51:	89 f8                	mov    %edi,%eax
  801a53:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a57:	85 f6                	test   %esi,%esi
  801a59:	75 2d                	jne    801a88 <__udivdi3+0x50>
  801a5b:	39 cf                	cmp    %ecx,%edi
  801a5d:	77 65                	ja     801ac4 <__udivdi3+0x8c>
  801a5f:	89 fd                	mov    %edi,%ebp
  801a61:	85 ff                	test   %edi,%edi
  801a63:	75 0b                	jne    801a70 <__udivdi3+0x38>
  801a65:	b8 01 00 00 00       	mov    $0x1,%eax
  801a6a:	31 d2                	xor    %edx,%edx
  801a6c:	f7 f7                	div    %edi
  801a6e:	89 c5                	mov    %eax,%ebp
  801a70:	31 d2                	xor    %edx,%edx
  801a72:	89 c8                	mov    %ecx,%eax
  801a74:	f7 f5                	div    %ebp
  801a76:	89 c1                	mov    %eax,%ecx
  801a78:	89 d8                	mov    %ebx,%eax
  801a7a:	f7 f5                	div    %ebp
  801a7c:	89 cf                	mov    %ecx,%edi
  801a7e:	89 fa                	mov    %edi,%edx
  801a80:	83 c4 1c             	add    $0x1c,%esp
  801a83:	5b                   	pop    %ebx
  801a84:	5e                   	pop    %esi
  801a85:	5f                   	pop    %edi
  801a86:	5d                   	pop    %ebp
  801a87:	c3                   	ret    
  801a88:	39 ce                	cmp    %ecx,%esi
  801a8a:	77 28                	ja     801ab4 <__udivdi3+0x7c>
  801a8c:	0f bd fe             	bsr    %esi,%edi
  801a8f:	83 f7 1f             	xor    $0x1f,%edi
  801a92:	75 40                	jne    801ad4 <__udivdi3+0x9c>
  801a94:	39 ce                	cmp    %ecx,%esi
  801a96:	72 0a                	jb     801aa2 <__udivdi3+0x6a>
  801a98:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a9c:	0f 87 9e 00 00 00    	ja     801b40 <__udivdi3+0x108>
  801aa2:	b8 01 00 00 00       	mov    $0x1,%eax
  801aa7:	89 fa                	mov    %edi,%edx
  801aa9:	83 c4 1c             	add    $0x1c,%esp
  801aac:	5b                   	pop    %ebx
  801aad:	5e                   	pop    %esi
  801aae:	5f                   	pop    %edi
  801aaf:	5d                   	pop    %ebp
  801ab0:	c3                   	ret    
  801ab1:	8d 76 00             	lea    0x0(%esi),%esi
  801ab4:	31 ff                	xor    %edi,%edi
  801ab6:	31 c0                	xor    %eax,%eax
  801ab8:	89 fa                	mov    %edi,%edx
  801aba:	83 c4 1c             	add    $0x1c,%esp
  801abd:	5b                   	pop    %ebx
  801abe:	5e                   	pop    %esi
  801abf:	5f                   	pop    %edi
  801ac0:	5d                   	pop    %ebp
  801ac1:	c3                   	ret    
  801ac2:	66 90                	xchg   %ax,%ax
  801ac4:	89 d8                	mov    %ebx,%eax
  801ac6:	f7 f7                	div    %edi
  801ac8:	31 ff                	xor    %edi,%edi
  801aca:	89 fa                	mov    %edi,%edx
  801acc:	83 c4 1c             	add    $0x1c,%esp
  801acf:	5b                   	pop    %ebx
  801ad0:	5e                   	pop    %esi
  801ad1:	5f                   	pop    %edi
  801ad2:	5d                   	pop    %ebp
  801ad3:	c3                   	ret    
  801ad4:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ad9:	89 eb                	mov    %ebp,%ebx
  801adb:	29 fb                	sub    %edi,%ebx
  801add:	89 f9                	mov    %edi,%ecx
  801adf:	d3 e6                	shl    %cl,%esi
  801ae1:	89 c5                	mov    %eax,%ebp
  801ae3:	88 d9                	mov    %bl,%cl
  801ae5:	d3 ed                	shr    %cl,%ebp
  801ae7:	89 e9                	mov    %ebp,%ecx
  801ae9:	09 f1                	or     %esi,%ecx
  801aeb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801aef:	89 f9                	mov    %edi,%ecx
  801af1:	d3 e0                	shl    %cl,%eax
  801af3:	89 c5                	mov    %eax,%ebp
  801af5:	89 d6                	mov    %edx,%esi
  801af7:	88 d9                	mov    %bl,%cl
  801af9:	d3 ee                	shr    %cl,%esi
  801afb:	89 f9                	mov    %edi,%ecx
  801afd:	d3 e2                	shl    %cl,%edx
  801aff:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b03:	88 d9                	mov    %bl,%cl
  801b05:	d3 e8                	shr    %cl,%eax
  801b07:	09 c2                	or     %eax,%edx
  801b09:	89 d0                	mov    %edx,%eax
  801b0b:	89 f2                	mov    %esi,%edx
  801b0d:	f7 74 24 0c          	divl   0xc(%esp)
  801b11:	89 d6                	mov    %edx,%esi
  801b13:	89 c3                	mov    %eax,%ebx
  801b15:	f7 e5                	mul    %ebp
  801b17:	39 d6                	cmp    %edx,%esi
  801b19:	72 19                	jb     801b34 <__udivdi3+0xfc>
  801b1b:	74 0b                	je     801b28 <__udivdi3+0xf0>
  801b1d:	89 d8                	mov    %ebx,%eax
  801b1f:	31 ff                	xor    %edi,%edi
  801b21:	e9 58 ff ff ff       	jmp    801a7e <__udivdi3+0x46>
  801b26:	66 90                	xchg   %ax,%ax
  801b28:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b2c:	89 f9                	mov    %edi,%ecx
  801b2e:	d3 e2                	shl    %cl,%edx
  801b30:	39 c2                	cmp    %eax,%edx
  801b32:	73 e9                	jae    801b1d <__udivdi3+0xe5>
  801b34:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b37:	31 ff                	xor    %edi,%edi
  801b39:	e9 40 ff ff ff       	jmp    801a7e <__udivdi3+0x46>
  801b3e:	66 90                	xchg   %ax,%ax
  801b40:	31 c0                	xor    %eax,%eax
  801b42:	e9 37 ff ff ff       	jmp    801a7e <__udivdi3+0x46>
  801b47:	90                   	nop

00801b48 <__umoddi3>:
  801b48:	55                   	push   %ebp
  801b49:	57                   	push   %edi
  801b4a:	56                   	push   %esi
  801b4b:	53                   	push   %ebx
  801b4c:	83 ec 1c             	sub    $0x1c,%esp
  801b4f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b53:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b57:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b5b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b5f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b63:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b67:	89 f3                	mov    %esi,%ebx
  801b69:	89 fa                	mov    %edi,%edx
  801b6b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b6f:	89 34 24             	mov    %esi,(%esp)
  801b72:	85 c0                	test   %eax,%eax
  801b74:	75 1a                	jne    801b90 <__umoddi3+0x48>
  801b76:	39 f7                	cmp    %esi,%edi
  801b78:	0f 86 a2 00 00 00    	jbe    801c20 <__umoddi3+0xd8>
  801b7e:	89 c8                	mov    %ecx,%eax
  801b80:	89 f2                	mov    %esi,%edx
  801b82:	f7 f7                	div    %edi
  801b84:	89 d0                	mov    %edx,%eax
  801b86:	31 d2                	xor    %edx,%edx
  801b88:	83 c4 1c             	add    $0x1c,%esp
  801b8b:	5b                   	pop    %ebx
  801b8c:	5e                   	pop    %esi
  801b8d:	5f                   	pop    %edi
  801b8e:	5d                   	pop    %ebp
  801b8f:	c3                   	ret    
  801b90:	39 f0                	cmp    %esi,%eax
  801b92:	0f 87 ac 00 00 00    	ja     801c44 <__umoddi3+0xfc>
  801b98:	0f bd e8             	bsr    %eax,%ebp
  801b9b:	83 f5 1f             	xor    $0x1f,%ebp
  801b9e:	0f 84 ac 00 00 00    	je     801c50 <__umoddi3+0x108>
  801ba4:	bf 20 00 00 00       	mov    $0x20,%edi
  801ba9:	29 ef                	sub    %ebp,%edi
  801bab:	89 fe                	mov    %edi,%esi
  801bad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801bb1:	89 e9                	mov    %ebp,%ecx
  801bb3:	d3 e0                	shl    %cl,%eax
  801bb5:	89 d7                	mov    %edx,%edi
  801bb7:	89 f1                	mov    %esi,%ecx
  801bb9:	d3 ef                	shr    %cl,%edi
  801bbb:	09 c7                	or     %eax,%edi
  801bbd:	89 e9                	mov    %ebp,%ecx
  801bbf:	d3 e2                	shl    %cl,%edx
  801bc1:	89 14 24             	mov    %edx,(%esp)
  801bc4:	89 d8                	mov    %ebx,%eax
  801bc6:	d3 e0                	shl    %cl,%eax
  801bc8:	89 c2                	mov    %eax,%edx
  801bca:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bce:	d3 e0                	shl    %cl,%eax
  801bd0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bd4:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bd8:	89 f1                	mov    %esi,%ecx
  801bda:	d3 e8                	shr    %cl,%eax
  801bdc:	09 d0                	or     %edx,%eax
  801bde:	d3 eb                	shr    %cl,%ebx
  801be0:	89 da                	mov    %ebx,%edx
  801be2:	f7 f7                	div    %edi
  801be4:	89 d3                	mov    %edx,%ebx
  801be6:	f7 24 24             	mull   (%esp)
  801be9:	89 c6                	mov    %eax,%esi
  801beb:	89 d1                	mov    %edx,%ecx
  801bed:	39 d3                	cmp    %edx,%ebx
  801bef:	0f 82 87 00 00 00    	jb     801c7c <__umoddi3+0x134>
  801bf5:	0f 84 91 00 00 00    	je     801c8c <__umoddi3+0x144>
  801bfb:	8b 54 24 04          	mov    0x4(%esp),%edx
  801bff:	29 f2                	sub    %esi,%edx
  801c01:	19 cb                	sbb    %ecx,%ebx
  801c03:	89 d8                	mov    %ebx,%eax
  801c05:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c09:	d3 e0                	shl    %cl,%eax
  801c0b:	89 e9                	mov    %ebp,%ecx
  801c0d:	d3 ea                	shr    %cl,%edx
  801c0f:	09 d0                	or     %edx,%eax
  801c11:	89 e9                	mov    %ebp,%ecx
  801c13:	d3 eb                	shr    %cl,%ebx
  801c15:	89 da                	mov    %ebx,%edx
  801c17:	83 c4 1c             	add    $0x1c,%esp
  801c1a:	5b                   	pop    %ebx
  801c1b:	5e                   	pop    %esi
  801c1c:	5f                   	pop    %edi
  801c1d:	5d                   	pop    %ebp
  801c1e:	c3                   	ret    
  801c1f:	90                   	nop
  801c20:	89 fd                	mov    %edi,%ebp
  801c22:	85 ff                	test   %edi,%edi
  801c24:	75 0b                	jne    801c31 <__umoddi3+0xe9>
  801c26:	b8 01 00 00 00       	mov    $0x1,%eax
  801c2b:	31 d2                	xor    %edx,%edx
  801c2d:	f7 f7                	div    %edi
  801c2f:	89 c5                	mov    %eax,%ebp
  801c31:	89 f0                	mov    %esi,%eax
  801c33:	31 d2                	xor    %edx,%edx
  801c35:	f7 f5                	div    %ebp
  801c37:	89 c8                	mov    %ecx,%eax
  801c39:	f7 f5                	div    %ebp
  801c3b:	89 d0                	mov    %edx,%eax
  801c3d:	e9 44 ff ff ff       	jmp    801b86 <__umoddi3+0x3e>
  801c42:	66 90                	xchg   %ax,%ax
  801c44:	89 c8                	mov    %ecx,%eax
  801c46:	89 f2                	mov    %esi,%edx
  801c48:	83 c4 1c             	add    $0x1c,%esp
  801c4b:	5b                   	pop    %ebx
  801c4c:	5e                   	pop    %esi
  801c4d:	5f                   	pop    %edi
  801c4e:	5d                   	pop    %ebp
  801c4f:	c3                   	ret    
  801c50:	3b 04 24             	cmp    (%esp),%eax
  801c53:	72 06                	jb     801c5b <__umoddi3+0x113>
  801c55:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c59:	77 0f                	ja     801c6a <__umoddi3+0x122>
  801c5b:	89 f2                	mov    %esi,%edx
  801c5d:	29 f9                	sub    %edi,%ecx
  801c5f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c63:	89 14 24             	mov    %edx,(%esp)
  801c66:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c6a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c6e:	8b 14 24             	mov    (%esp),%edx
  801c71:	83 c4 1c             	add    $0x1c,%esp
  801c74:	5b                   	pop    %ebx
  801c75:	5e                   	pop    %esi
  801c76:	5f                   	pop    %edi
  801c77:	5d                   	pop    %ebp
  801c78:	c3                   	ret    
  801c79:	8d 76 00             	lea    0x0(%esi),%esi
  801c7c:	2b 04 24             	sub    (%esp),%eax
  801c7f:	19 fa                	sbb    %edi,%edx
  801c81:	89 d1                	mov    %edx,%ecx
  801c83:	89 c6                	mov    %eax,%esi
  801c85:	e9 71 ff ff ff       	jmp    801bfb <__umoddi3+0xb3>
  801c8a:	66 90                	xchg   %ax,%ax
  801c8c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c90:	72 ea                	jb     801c7c <__umoddi3+0x134>
  801c92:	89 d9                	mov    %ebx,%ecx
  801c94:	e9 62 ff ff ff       	jmp    801bfb <__umoddi3+0xb3>
