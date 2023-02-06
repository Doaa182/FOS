
obj/user/tst_envfree2:     file format elf32-i386


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
  800031:	e8 43 01 00 00       	call   800179 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests environment free run tef2 10 5
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	// Testing scenario 2: using dynamic allocation and free
	// Testing removing the allocated pages (static & dynamic) in mem, WS, mapped page tables, env's directory and env's page file

	int freeFrames_before = sys_calculate_free_frames() ;
  80003e:	e8 9c 13 00 00       	call   8013df <sys_calculate_free_frames>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800046:	e8 34 14 00 00       	call   80147f <sys_pf_calculate_allocated_pages>
  80004b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80004e:	83 ec 08             	sub    $0x8,%esp
  800051:	ff 75 f4             	pushl  -0xc(%ebp)
  800054:	68 80 1c 80 00       	push   $0x801c80
  800059:	e8 0b 05 00 00       	call   800569 <cprintf>
  80005e:	83 c4 10             	add    $0x10,%esp

	/*[4] CREATE AND RUN ProcessA & ProcessB*/
	//Create 3 processes
	int32 envIdProcessA = sys_create_env("ef_ms1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800061:	a1 20 30 80 00       	mov    0x803020,%eax
  800066:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80006c:	89 c2                	mov    %eax,%edx
  80006e:	a1 20 30 80 00       	mov    0x803020,%eax
  800073:	8b 40 74             	mov    0x74(%eax),%eax
  800076:	6a 32                	push   $0x32
  800078:	52                   	push   %edx
  800079:	50                   	push   %eax
  80007a:	68 b3 1c 80 00       	push   $0x801cb3
  80007f:	e8 cd 15 00 00       	call   801651 <sys_create_env>
  800084:	83 c4 10             	add    $0x10,%esp
  800087:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int32 envIdProcessB = sys_create_env("ef_ms2", (myEnv->page_WS_max_size)-3,(myEnv->SecondListSize), 50);
  80008a:	a1 20 30 80 00       	mov    0x803020,%eax
  80008f:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800095:	89 c2                	mov    %eax,%edx
  800097:	a1 20 30 80 00       	mov    0x803020,%eax
  80009c:	8b 40 74             	mov    0x74(%eax),%eax
  80009f:	83 e8 03             	sub    $0x3,%eax
  8000a2:	6a 32                	push   $0x32
  8000a4:	52                   	push   %edx
  8000a5:	50                   	push   %eax
  8000a6:	68 ba 1c 80 00       	push   $0x801cba
  8000ab:	e8 a1 15 00 00       	call   801651 <sys_create_env>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//Run 3 processes
	sys_run_env(envIdProcessA);
  8000b6:	83 ec 0c             	sub    $0xc,%esp
  8000b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8000bc:	e8 ae 15 00 00       	call   80166f <sys_run_env>
  8000c1:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000c4:	83 ec 0c             	sub    $0xc,%esp
  8000c7:	ff 75 e8             	pushl  -0x18(%ebp)
  8000ca:	e8 a0 15 00 00       	call   80166f <sys_run_env>
  8000cf:	83 c4 10             	add    $0x10,%esp

	env_sleep(30000);
  8000d2:	83 ec 0c             	sub    $0xc,%esp
  8000d5:	68 30 75 00 00       	push   $0x7530
  8000da:	e8 72 18 00 00       	call   801951 <env_sleep>
  8000df:	83 c4 10             	add    $0x10,%esp
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000e2:	e8 f8 12 00 00       	call   8013df <sys_calculate_free_frames>
  8000e7:	83 ec 08             	sub    $0x8,%esp
  8000ea:	50                   	push   %eax
  8000eb:	68 c4 1c 80 00       	push   $0x801cc4
  8000f0:	e8 74 04 00 00       	call   800569 <cprintf>
  8000f5:	83 c4 10             	add    $0x10,%esp

	//Kill the 3 processes
	sys_destroy_env(envIdProcessA);
  8000f8:	83 ec 0c             	sub    $0xc,%esp
  8000fb:	ff 75 ec             	pushl  -0x14(%ebp)
  8000fe:	e8 88 15 00 00       	call   80168b <sys_destroy_env>
  800103:	83 c4 10             	add    $0x10,%esp
	sys_destroy_env(envIdProcessB);
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	ff 75 e8             	pushl  -0x18(%ebp)
  80010c:	e8 7a 15 00 00       	call   80168b <sys_destroy_env>
  800111:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  800114:	e8 c6 12 00 00       	call   8013df <sys_calculate_free_frames>
  800119:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  80011c:	e8 5e 13 00 00       	call   80147f <sys_pf_calculate_allocated_pages>
  800121:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  800124:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800127:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80012a:	74 27                	je     800153 <_main+0x11b>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  80012c:	83 ec 08             	sub    $0x8,%esp
  80012f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800132:	68 f8 1c 80 00       	push   $0x801cf8
  800137:	e8 2d 04 00 00       	call   800569 <cprintf>
  80013c:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  80013f:	83 ec 04             	sub    $0x4,%esp
  800142:	68 48 1d 80 00       	push   $0x801d48
  800147:	6a 24                	push   $0x24
  800149:	68 7e 1d 80 00       	push   $0x801d7e
  80014e:	e8 62 01 00 00       	call   8002b5 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  800153:	83 ec 08             	sub    $0x8,%esp
  800156:	ff 75 e4             	pushl  -0x1c(%ebp)
  800159:	68 94 1d 80 00       	push   $0x801d94
  80015e:	e8 06 04 00 00       	call   800569 <cprintf>
  800163:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 2 for envfree completed successfully.\n");
  800166:	83 ec 0c             	sub    $0xc,%esp
  800169:	68 f4 1d 80 00       	push   $0x801df4
  80016e:	e8 f6 03 00 00       	call   800569 <cprintf>
  800173:	83 c4 10             	add    $0x10,%esp
	return;
  800176:	90                   	nop
}
  800177:	c9                   	leave  
  800178:	c3                   	ret    

00800179 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800179:	55                   	push   %ebp
  80017a:	89 e5                	mov    %esp,%ebp
  80017c:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80017f:	e8 3b 15 00 00       	call   8016bf <sys_getenvindex>
  800184:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800187:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80018a:	89 d0                	mov    %edx,%eax
  80018c:	c1 e0 03             	shl    $0x3,%eax
  80018f:	01 d0                	add    %edx,%eax
  800191:	01 c0                	add    %eax,%eax
  800193:	01 d0                	add    %edx,%eax
  800195:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80019c:	01 d0                	add    %edx,%eax
  80019e:	c1 e0 04             	shl    $0x4,%eax
  8001a1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001a6:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001ab:	a1 20 30 80 00       	mov    0x803020,%eax
  8001b0:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001b6:	84 c0                	test   %al,%al
  8001b8:	74 0f                	je     8001c9 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001ba:	a1 20 30 80 00       	mov    0x803020,%eax
  8001bf:	05 5c 05 00 00       	add    $0x55c,%eax
  8001c4:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001cd:	7e 0a                	jle    8001d9 <libmain+0x60>
		binaryname = argv[0];
  8001cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d2:	8b 00                	mov    (%eax),%eax
  8001d4:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8001d9:	83 ec 08             	sub    $0x8,%esp
  8001dc:	ff 75 0c             	pushl  0xc(%ebp)
  8001df:	ff 75 08             	pushl  0x8(%ebp)
  8001e2:	e8 51 fe ff ff       	call   800038 <_main>
  8001e7:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001ea:	e8 dd 12 00 00       	call   8014cc <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001ef:	83 ec 0c             	sub    $0xc,%esp
  8001f2:	68 58 1e 80 00       	push   $0x801e58
  8001f7:	e8 6d 03 00 00       	call   800569 <cprintf>
  8001fc:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001ff:	a1 20 30 80 00       	mov    0x803020,%eax
  800204:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80020a:	a1 20 30 80 00       	mov    0x803020,%eax
  80020f:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800215:	83 ec 04             	sub    $0x4,%esp
  800218:	52                   	push   %edx
  800219:	50                   	push   %eax
  80021a:	68 80 1e 80 00       	push   $0x801e80
  80021f:	e8 45 03 00 00       	call   800569 <cprintf>
  800224:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800227:	a1 20 30 80 00       	mov    0x803020,%eax
  80022c:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800232:	a1 20 30 80 00       	mov    0x803020,%eax
  800237:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80023d:	a1 20 30 80 00       	mov    0x803020,%eax
  800242:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800248:	51                   	push   %ecx
  800249:	52                   	push   %edx
  80024a:	50                   	push   %eax
  80024b:	68 a8 1e 80 00       	push   $0x801ea8
  800250:	e8 14 03 00 00       	call   800569 <cprintf>
  800255:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800258:	a1 20 30 80 00       	mov    0x803020,%eax
  80025d:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800263:	83 ec 08             	sub    $0x8,%esp
  800266:	50                   	push   %eax
  800267:	68 00 1f 80 00       	push   $0x801f00
  80026c:	e8 f8 02 00 00       	call   800569 <cprintf>
  800271:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800274:	83 ec 0c             	sub    $0xc,%esp
  800277:	68 58 1e 80 00       	push   $0x801e58
  80027c:	e8 e8 02 00 00       	call   800569 <cprintf>
  800281:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800284:	e8 5d 12 00 00       	call   8014e6 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800289:	e8 19 00 00 00       	call   8002a7 <exit>
}
  80028e:	90                   	nop
  80028f:	c9                   	leave  
  800290:	c3                   	ret    

00800291 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800291:	55                   	push   %ebp
  800292:	89 e5                	mov    %esp,%ebp
  800294:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800297:	83 ec 0c             	sub    $0xc,%esp
  80029a:	6a 00                	push   $0x0
  80029c:	e8 ea 13 00 00       	call   80168b <sys_destroy_env>
  8002a1:	83 c4 10             	add    $0x10,%esp
}
  8002a4:	90                   	nop
  8002a5:	c9                   	leave  
  8002a6:	c3                   	ret    

008002a7 <exit>:

void
exit(void)
{
  8002a7:	55                   	push   %ebp
  8002a8:	89 e5                	mov    %esp,%ebp
  8002aa:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002ad:	e8 3f 14 00 00       	call   8016f1 <sys_exit_env>
}
  8002b2:	90                   	nop
  8002b3:	c9                   	leave  
  8002b4:	c3                   	ret    

008002b5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002b5:	55                   	push   %ebp
  8002b6:	89 e5                	mov    %esp,%ebp
  8002b8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002bb:	8d 45 10             	lea    0x10(%ebp),%eax
  8002be:	83 c0 04             	add    $0x4,%eax
  8002c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002c4:	a1 5c 31 80 00       	mov    0x80315c,%eax
  8002c9:	85 c0                	test   %eax,%eax
  8002cb:	74 16                	je     8002e3 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002cd:	a1 5c 31 80 00       	mov    0x80315c,%eax
  8002d2:	83 ec 08             	sub    $0x8,%esp
  8002d5:	50                   	push   %eax
  8002d6:	68 14 1f 80 00       	push   $0x801f14
  8002db:	e8 89 02 00 00       	call   800569 <cprintf>
  8002e0:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002e3:	a1 00 30 80 00       	mov    0x803000,%eax
  8002e8:	ff 75 0c             	pushl  0xc(%ebp)
  8002eb:	ff 75 08             	pushl  0x8(%ebp)
  8002ee:	50                   	push   %eax
  8002ef:	68 19 1f 80 00       	push   $0x801f19
  8002f4:	e8 70 02 00 00       	call   800569 <cprintf>
  8002f9:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8002ff:	83 ec 08             	sub    $0x8,%esp
  800302:	ff 75 f4             	pushl  -0xc(%ebp)
  800305:	50                   	push   %eax
  800306:	e8 f3 01 00 00       	call   8004fe <vcprintf>
  80030b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80030e:	83 ec 08             	sub    $0x8,%esp
  800311:	6a 00                	push   $0x0
  800313:	68 35 1f 80 00       	push   $0x801f35
  800318:	e8 e1 01 00 00       	call   8004fe <vcprintf>
  80031d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800320:	e8 82 ff ff ff       	call   8002a7 <exit>

	// should not return here
	while (1) ;
  800325:	eb fe                	jmp    800325 <_panic+0x70>

00800327 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800327:	55                   	push   %ebp
  800328:	89 e5                	mov    %esp,%ebp
  80032a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80032d:	a1 20 30 80 00       	mov    0x803020,%eax
  800332:	8b 50 74             	mov    0x74(%eax),%edx
  800335:	8b 45 0c             	mov    0xc(%ebp),%eax
  800338:	39 c2                	cmp    %eax,%edx
  80033a:	74 14                	je     800350 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80033c:	83 ec 04             	sub    $0x4,%esp
  80033f:	68 38 1f 80 00       	push   $0x801f38
  800344:	6a 26                	push   $0x26
  800346:	68 84 1f 80 00       	push   $0x801f84
  80034b:	e8 65 ff ff ff       	call   8002b5 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800350:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800357:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80035e:	e9 c2 00 00 00       	jmp    800425 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800363:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800366:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80036d:	8b 45 08             	mov    0x8(%ebp),%eax
  800370:	01 d0                	add    %edx,%eax
  800372:	8b 00                	mov    (%eax),%eax
  800374:	85 c0                	test   %eax,%eax
  800376:	75 08                	jne    800380 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800378:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80037b:	e9 a2 00 00 00       	jmp    800422 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800380:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800387:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80038e:	eb 69                	jmp    8003f9 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800390:	a1 20 30 80 00       	mov    0x803020,%eax
  800395:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80039b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80039e:	89 d0                	mov    %edx,%eax
  8003a0:	01 c0                	add    %eax,%eax
  8003a2:	01 d0                	add    %edx,%eax
  8003a4:	c1 e0 03             	shl    $0x3,%eax
  8003a7:	01 c8                	add    %ecx,%eax
  8003a9:	8a 40 04             	mov    0x4(%eax),%al
  8003ac:	84 c0                	test   %al,%al
  8003ae:	75 46                	jne    8003f6 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003b0:	a1 20 30 80 00       	mov    0x803020,%eax
  8003b5:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003bb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003be:	89 d0                	mov    %edx,%eax
  8003c0:	01 c0                	add    %eax,%eax
  8003c2:	01 d0                	add    %edx,%eax
  8003c4:	c1 e0 03             	shl    $0x3,%eax
  8003c7:	01 c8                	add    %ecx,%eax
  8003c9:	8b 00                	mov    (%eax),%eax
  8003cb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003d1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003d6:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003db:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e5:	01 c8                	add    %ecx,%eax
  8003e7:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003e9:	39 c2                	cmp    %eax,%edx
  8003eb:	75 09                	jne    8003f6 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003ed:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003f4:	eb 12                	jmp    800408 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003f6:	ff 45 e8             	incl   -0x18(%ebp)
  8003f9:	a1 20 30 80 00       	mov    0x803020,%eax
  8003fe:	8b 50 74             	mov    0x74(%eax),%edx
  800401:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800404:	39 c2                	cmp    %eax,%edx
  800406:	77 88                	ja     800390 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800408:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80040c:	75 14                	jne    800422 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80040e:	83 ec 04             	sub    $0x4,%esp
  800411:	68 90 1f 80 00       	push   $0x801f90
  800416:	6a 3a                	push   $0x3a
  800418:	68 84 1f 80 00       	push   $0x801f84
  80041d:	e8 93 fe ff ff       	call   8002b5 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800422:	ff 45 f0             	incl   -0x10(%ebp)
  800425:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800428:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80042b:	0f 8c 32 ff ff ff    	jl     800363 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800431:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800438:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80043f:	eb 26                	jmp    800467 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800441:	a1 20 30 80 00       	mov    0x803020,%eax
  800446:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80044c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80044f:	89 d0                	mov    %edx,%eax
  800451:	01 c0                	add    %eax,%eax
  800453:	01 d0                	add    %edx,%eax
  800455:	c1 e0 03             	shl    $0x3,%eax
  800458:	01 c8                	add    %ecx,%eax
  80045a:	8a 40 04             	mov    0x4(%eax),%al
  80045d:	3c 01                	cmp    $0x1,%al
  80045f:	75 03                	jne    800464 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800461:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800464:	ff 45 e0             	incl   -0x20(%ebp)
  800467:	a1 20 30 80 00       	mov    0x803020,%eax
  80046c:	8b 50 74             	mov    0x74(%eax),%edx
  80046f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800472:	39 c2                	cmp    %eax,%edx
  800474:	77 cb                	ja     800441 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800476:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800479:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80047c:	74 14                	je     800492 <CheckWSWithoutLastIndex+0x16b>
		panic(
  80047e:	83 ec 04             	sub    $0x4,%esp
  800481:	68 e4 1f 80 00       	push   $0x801fe4
  800486:	6a 44                	push   $0x44
  800488:	68 84 1f 80 00       	push   $0x801f84
  80048d:	e8 23 fe ff ff       	call   8002b5 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800492:	90                   	nop
  800493:	c9                   	leave  
  800494:	c3                   	ret    

00800495 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800495:	55                   	push   %ebp
  800496:	89 e5                	mov    %esp,%ebp
  800498:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80049b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049e:	8b 00                	mov    (%eax),%eax
  8004a0:	8d 48 01             	lea    0x1(%eax),%ecx
  8004a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a6:	89 0a                	mov    %ecx,(%edx)
  8004a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8004ab:	88 d1                	mov    %dl,%cl
  8004ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b0:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b7:	8b 00                	mov    (%eax),%eax
  8004b9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004be:	75 2c                	jne    8004ec <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004c0:	a0 24 30 80 00       	mov    0x803024,%al
  8004c5:	0f b6 c0             	movzbl %al,%eax
  8004c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004cb:	8b 12                	mov    (%edx),%edx
  8004cd:	89 d1                	mov    %edx,%ecx
  8004cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004d2:	83 c2 08             	add    $0x8,%edx
  8004d5:	83 ec 04             	sub    $0x4,%esp
  8004d8:	50                   	push   %eax
  8004d9:	51                   	push   %ecx
  8004da:	52                   	push   %edx
  8004db:	e8 3e 0e 00 00       	call   80131e <sys_cputs>
  8004e0:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ef:	8b 40 04             	mov    0x4(%eax),%eax
  8004f2:	8d 50 01             	lea    0x1(%eax),%edx
  8004f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f8:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004fb:	90                   	nop
  8004fc:	c9                   	leave  
  8004fd:	c3                   	ret    

008004fe <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004fe:	55                   	push   %ebp
  8004ff:	89 e5                	mov    %esp,%ebp
  800501:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800507:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80050e:	00 00 00 
	b.cnt = 0;
  800511:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800518:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80051b:	ff 75 0c             	pushl  0xc(%ebp)
  80051e:	ff 75 08             	pushl  0x8(%ebp)
  800521:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800527:	50                   	push   %eax
  800528:	68 95 04 80 00       	push   $0x800495
  80052d:	e8 11 02 00 00       	call   800743 <vprintfmt>
  800532:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800535:	a0 24 30 80 00       	mov    0x803024,%al
  80053a:	0f b6 c0             	movzbl %al,%eax
  80053d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800543:	83 ec 04             	sub    $0x4,%esp
  800546:	50                   	push   %eax
  800547:	52                   	push   %edx
  800548:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80054e:	83 c0 08             	add    $0x8,%eax
  800551:	50                   	push   %eax
  800552:	e8 c7 0d 00 00       	call   80131e <sys_cputs>
  800557:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80055a:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800561:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800567:	c9                   	leave  
  800568:	c3                   	ret    

00800569 <cprintf>:

int cprintf(const char *fmt, ...) {
  800569:	55                   	push   %ebp
  80056a:	89 e5                	mov    %esp,%ebp
  80056c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80056f:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800576:	8d 45 0c             	lea    0xc(%ebp),%eax
  800579:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80057c:	8b 45 08             	mov    0x8(%ebp),%eax
  80057f:	83 ec 08             	sub    $0x8,%esp
  800582:	ff 75 f4             	pushl  -0xc(%ebp)
  800585:	50                   	push   %eax
  800586:	e8 73 ff ff ff       	call   8004fe <vcprintf>
  80058b:	83 c4 10             	add    $0x10,%esp
  80058e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800591:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800594:	c9                   	leave  
  800595:	c3                   	ret    

00800596 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800596:	55                   	push   %ebp
  800597:	89 e5                	mov    %esp,%ebp
  800599:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80059c:	e8 2b 0f 00 00       	call   8014cc <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005a1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005aa:	83 ec 08             	sub    $0x8,%esp
  8005ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8005b0:	50                   	push   %eax
  8005b1:	e8 48 ff ff ff       	call   8004fe <vcprintf>
  8005b6:	83 c4 10             	add    $0x10,%esp
  8005b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005bc:	e8 25 0f 00 00       	call   8014e6 <sys_enable_interrupt>
	return cnt;
  8005c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005c4:	c9                   	leave  
  8005c5:	c3                   	ret    

008005c6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005c6:	55                   	push   %ebp
  8005c7:	89 e5                	mov    %esp,%ebp
  8005c9:	53                   	push   %ebx
  8005ca:	83 ec 14             	sub    $0x14,%esp
  8005cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8005d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005d9:	8b 45 18             	mov    0x18(%ebp),%eax
  8005dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005e4:	77 55                	ja     80063b <printnum+0x75>
  8005e6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005e9:	72 05                	jb     8005f0 <printnum+0x2a>
  8005eb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005ee:	77 4b                	ja     80063b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005f0:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005f3:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005f6:	8b 45 18             	mov    0x18(%ebp),%eax
  8005f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fe:	52                   	push   %edx
  8005ff:	50                   	push   %eax
  800600:	ff 75 f4             	pushl  -0xc(%ebp)
  800603:	ff 75 f0             	pushl  -0x10(%ebp)
  800606:	e8 fd 13 00 00       	call   801a08 <__udivdi3>
  80060b:	83 c4 10             	add    $0x10,%esp
  80060e:	83 ec 04             	sub    $0x4,%esp
  800611:	ff 75 20             	pushl  0x20(%ebp)
  800614:	53                   	push   %ebx
  800615:	ff 75 18             	pushl  0x18(%ebp)
  800618:	52                   	push   %edx
  800619:	50                   	push   %eax
  80061a:	ff 75 0c             	pushl  0xc(%ebp)
  80061d:	ff 75 08             	pushl  0x8(%ebp)
  800620:	e8 a1 ff ff ff       	call   8005c6 <printnum>
  800625:	83 c4 20             	add    $0x20,%esp
  800628:	eb 1a                	jmp    800644 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80062a:	83 ec 08             	sub    $0x8,%esp
  80062d:	ff 75 0c             	pushl  0xc(%ebp)
  800630:	ff 75 20             	pushl  0x20(%ebp)
  800633:	8b 45 08             	mov    0x8(%ebp),%eax
  800636:	ff d0                	call   *%eax
  800638:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80063b:	ff 4d 1c             	decl   0x1c(%ebp)
  80063e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800642:	7f e6                	jg     80062a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800644:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800647:	bb 00 00 00 00       	mov    $0x0,%ebx
  80064c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80064f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800652:	53                   	push   %ebx
  800653:	51                   	push   %ecx
  800654:	52                   	push   %edx
  800655:	50                   	push   %eax
  800656:	e8 bd 14 00 00       	call   801b18 <__umoddi3>
  80065b:	83 c4 10             	add    $0x10,%esp
  80065e:	05 54 22 80 00       	add    $0x802254,%eax
  800663:	8a 00                	mov    (%eax),%al
  800665:	0f be c0             	movsbl %al,%eax
  800668:	83 ec 08             	sub    $0x8,%esp
  80066b:	ff 75 0c             	pushl  0xc(%ebp)
  80066e:	50                   	push   %eax
  80066f:	8b 45 08             	mov    0x8(%ebp),%eax
  800672:	ff d0                	call   *%eax
  800674:	83 c4 10             	add    $0x10,%esp
}
  800677:	90                   	nop
  800678:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80067b:	c9                   	leave  
  80067c:	c3                   	ret    

0080067d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80067d:	55                   	push   %ebp
  80067e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800680:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800684:	7e 1c                	jle    8006a2 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800686:	8b 45 08             	mov    0x8(%ebp),%eax
  800689:	8b 00                	mov    (%eax),%eax
  80068b:	8d 50 08             	lea    0x8(%eax),%edx
  80068e:	8b 45 08             	mov    0x8(%ebp),%eax
  800691:	89 10                	mov    %edx,(%eax)
  800693:	8b 45 08             	mov    0x8(%ebp),%eax
  800696:	8b 00                	mov    (%eax),%eax
  800698:	83 e8 08             	sub    $0x8,%eax
  80069b:	8b 50 04             	mov    0x4(%eax),%edx
  80069e:	8b 00                	mov    (%eax),%eax
  8006a0:	eb 40                	jmp    8006e2 <getuint+0x65>
	else if (lflag)
  8006a2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006a6:	74 1e                	je     8006c6 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ab:	8b 00                	mov    (%eax),%eax
  8006ad:	8d 50 04             	lea    0x4(%eax),%edx
  8006b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b3:	89 10                	mov    %edx,(%eax)
  8006b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b8:	8b 00                	mov    (%eax),%eax
  8006ba:	83 e8 04             	sub    $0x4,%eax
  8006bd:	8b 00                	mov    (%eax),%eax
  8006bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c4:	eb 1c                	jmp    8006e2 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c9:	8b 00                	mov    (%eax),%eax
  8006cb:	8d 50 04             	lea    0x4(%eax),%edx
  8006ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d1:	89 10                	mov    %edx,(%eax)
  8006d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d6:	8b 00                	mov    (%eax),%eax
  8006d8:	83 e8 04             	sub    $0x4,%eax
  8006db:	8b 00                	mov    (%eax),%eax
  8006dd:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006e2:	5d                   	pop    %ebp
  8006e3:	c3                   	ret    

008006e4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006e4:	55                   	push   %ebp
  8006e5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006e7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006eb:	7e 1c                	jle    800709 <getint+0x25>
		return va_arg(*ap, long long);
  8006ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f0:	8b 00                	mov    (%eax),%eax
  8006f2:	8d 50 08             	lea    0x8(%eax),%edx
  8006f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f8:	89 10                	mov    %edx,(%eax)
  8006fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fd:	8b 00                	mov    (%eax),%eax
  8006ff:	83 e8 08             	sub    $0x8,%eax
  800702:	8b 50 04             	mov    0x4(%eax),%edx
  800705:	8b 00                	mov    (%eax),%eax
  800707:	eb 38                	jmp    800741 <getint+0x5d>
	else if (lflag)
  800709:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80070d:	74 1a                	je     800729 <getint+0x45>
		return va_arg(*ap, long);
  80070f:	8b 45 08             	mov    0x8(%ebp),%eax
  800712:	8b 00                	mov    (%eax),%eax
  800714:	8d 50 04             	lea    0x4(%eax),%edx
  800717:	8b 45 08             	mov    0x8(%ebp),%eax
  80071a:	89 10                	mov    %edx,(%eax)
  80071c:	8b 45 08             	mov    0x8(%ebp),%eax
  80071f:	8b 00                	mov    (%eax),%eax
  800721:	83 e8 04             	sub    $0x4,%eax
  800724:	8b 00                	mov    (%eax),%eax
  800726:	99                   	cltd   
  800727:	eb 18                	jmp    800741 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800729:	8b 45 08             	mov    0x8(%ebp),%eax
  80072c:	8b 00                	mov    (%eax),%eax
  80072e:	8d 50 04             	lea    0x4(%eax),%edx
  800731:	8b 45 08             	mov    0x8(%ebp),%eax
  800734:	89 10                	mov    %edx,(%eax)
  800736:	8b 45 08             	mov    0x8(%ebp),%eax
  800739:	8b 00                	mov    (%eax),%eax
  80073b:	83 e8 04             	sub    $0x4,%eax
  80073e:	8b 00                	mov    (%eax),%eax
  800740:	99                   	cltd   
}
  800741:	5d                   	pop    %ebp
  800742:	c3                   	ret    

00800743 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800743:	55                   	push   %ebp
  800744:	89 e5                	mov    %esp,%ebp
  800746:	56                   	push   %esi
  800747:	53                   	push   %ebx
  800748:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80074b:	eb 17                	jmp    800764 <vprintfmt+0x21>
			if (ch == '\0')
  80074d:	85 db                	test   %ebx,%ebx
  80074f:	0f 84 af 03 00 00    	je     800b04 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800755:	83 ec 08             	sub    $0x8,%esp
  800758:	ff 75 0c             	pushl  0xc(%ebp)
  80075b:	53                   	push   %ebx
  80075c:	8b 45 08             	mov    0x8(%ebp),%eax
  80075f:	ff d0                	call   *%eax
  800761:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800764:	8b 45 10             	mov    0x10(%ebp),%eax
  800767:	8d 50 01             	lea    0x1(%eax),%edx
  80076a:	89 55 10             	mov    %edx,0x10(%ebp)
  80076d:	8a 00                	mov    (%eax),%al
  80076f:	0f b6 d8             	movzbl %al,%ebx
  800772:	83 fb 25             	cmp    $0x25,%ebx
  800775:	75 d6                	jne    80074d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800777:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80077b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800782:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800789:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800790:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800797:	8b 45 10             	mov    0x10(%ebp),%eax
  80079a:	8d 50 01             	lea    0x1(%eax),%edx
  80079d:	89 55 10             	mov    %edx,0x10(%ebp)
  8007a0:	8a 00                	mov    (%eax),%al
  8007a2:	0f b6 d8             	movzbl %al,%ebx
  8007a5:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007a8:	83 f8 55             	cmp    $0x55,%eax
  8007ab:	0f 87 2b 03 00 00    	ja     800adc <vprintfmt+0x399>
  8007b1:	8b 04 85 78 22 80 00 	mov    0x802278(,%eax,4),%eax
  8007b8:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007ba:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007be:	eb d7                	jmp    800797 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007c0:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007c4:	eb d1                	jmp    800797 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007cd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007d0:	89 d0                	mov    %edx,%eax
  8007d2:	c1 e0 02             	shl    $0x2,%eax
  8007d5:	01 d0                	add    %edx,%eax
  8007d7:	01 c0                	add    %eax,%eax
  8007d9:	01 d8                	add    %ebx,%eax
  8007db:	83 e8 30             	sub    $0x30,%eax
  8007de:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e4:	8a 00                	mov    (%eax),%al
  8007e6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007e9:	83 fb 2f             	cmp    $0x2f,%ebx
  8007ec:	7e 3e                	jle    80082c <vprintfmt+0xe9>
  8007ee:	83 fb 39             	cmp    $0x39,%ebx
  8007f1:	7f 39                	jg     80082c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007f3:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007f6:	eb d5                	jmp    8007cd <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fb:	83 c0 04             	add    $0x4,%eax
  8007fe:	89 45 14             	mov    %eax,0x14(%ebp)
  800801:	8b 45 14             	mov    0x14(%ebp),%eax
  800804:	83 e8 04             	sub    $0x4,%eax
  800807:	8b 00                	mov    (%eax),%eax
  800809:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80080c:	eb 1f                	jmp    80082d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80080e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800812:	79 83                	jns    800797 <vprintfmt+0x54>
				width = 0;
  800814:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80081b:	e9 77 ff ff ff       	jmp    800797 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800820:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800827:	e9 6b ff ff ff       	jmp    800797 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80082c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80082d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800831:	0f 89 60 ff ff ff    	jns    800797 <vprintfmt+0x54>
				width = precision, precision = -1;
  800837:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80083a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80083d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800844:	e9 4e ff ff ff       	jmp    800797 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800849:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80084c:	e9 46 ff ff ff       	jmp    800797 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800851:	8b 45 14             	mov    0x14(%ebp),%eax
  800854:	83 c0 04             	add    $0x4,%eax
  800857:	89 45 14             	mov    %eax,0x14(%ebp)
  80085a:	8b 45 14             	mov    0x14(%ebp),%eax
  80085d:	83 e8 04             	sub    $0x4,%eax
  800860:	8b 00                	mov    (%eax),%eax
  800862:	83 ec 08             	sub    $0x8,%esp
  800865:	ff 75 0c             	pushl  0xc(%ebp)
  800868:	50                   	push   %eax
  800869:	8b 45 08             	mov    0x8(%ebp),%eax
  80086c:	ff d0                	call   *%eax
  80086e:	83 c4 10             	add    $0x10,%esp
			break;
  800871:	e9 89 02 00 00       	jmp    800aff <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800876:	8b 45 14             	mov    0x14(%ebp),%eax
  800879:	83 c0 04             	add    $0x4,%eax
  80087c:	89 45 14             	mov    %eax,0x14(%ebp)
  80087f:	8b 45 14             	mov    0x14(%ebp),%eax
  800882:	83 e8 04             	sub    $0x4,%eax
  800885:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800887:	85 db                	test   %ebx,%ebx
  800889:	79 02                	jns    80088d <vprintfmt+0x14a>
				err = -err;
  80088b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80088d:	83 fb 64             	cmp    $0x64,%ebx
  800890:	7f 0b                	jg     80089d <vprintfmt+0x15a>
  800892:	8b 34 9d c0 20 80 00 	mov    0x8020c0(,%ebx,4),%esi
  800899:	85 f6                	test   %esi,%esi
  80089b:	75 19                	jne    8008b6 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80089d:	53                   	push   %ebx
  80089e:	68 65 22 80 00       	push   $0x802265
  8008a3:	ff 75 0c             	pushl  0xc(%ebp)
  8008a6:	ff 75 08             	pushl  0x8(%ebp)
  8008a9:	e8 5e 02 00 00       	call   800b0c <printfmt>
  8008ae:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008b1:	e9 49 02 00 00       	jmp    800aff <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008b6:	56                   	push   %esi
  8008b7:	68 6e 22 80 00       	push   $0x80226e
  8008bc:	ff 75 0c             	pushl  0xc(%ebp)
  8008bf:	ff 75 08             	pushl  0x8(%ebp)
  8008c2:	e8 45 02 00 00       	call   800b0c <printfmt>
  8008c7:	83 c4 10             	add    $0x10,%esp
			break;
  8008ca:	e9 30 02 00 00       	jmp    800aff <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d2:	83 c0 04             	add    $0x4,%eax
  8008d5:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008db:	83 e8 04             	sub    $0x4,%eax
  8008de:	8b 30                	mov    (%eax),%esi
  8008e0:	85 f6                	test   %esi,%esi
  8008e2:	75 05                	jne    8008e9 <vprintfmt+0x1a6>
				p = "(null)";
  8008e4:	be 71 22 80 00       	mov    $0x802271,%esi
			if (width > 0 && padc != '-')
  8008e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ed:	7e 6d                	jle    80095c <vprintfmt+0x219>
  8008ef:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008f3:	74 67                	je     80095c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f8:	83 ec 08             	sub    $0x8,%esp
  8008fb:	50                   	push   %eax
  8008fc:	56                   	push   %esi
  8008fd:	e8 0c 03 00 00       	call   800c0e <strnlen>
  800902:	83 c4 10             	add    $0x10,%esp
  800905:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800908:	eb 16                	jmp    800920 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80090a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80090e:	83 ec 08             	sub    $0x8,%esp
  800911:	ff 75 0c             	pushl  0xc(%ebp)
  800914:	50                   	push   %eax
  800915:	8b 45 08             	mov    0x8(%ebp),%eax
  800918:	ff d0                	call   *%eax
  80091a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80091d:	ff 4d e4             	decl   -0x1c(%ebp)
  800920:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800924:	7f e4                	jg     80090a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800926:	eb 34                	jmp    80095c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800928:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80092c:	74 1c                	je     80094a <vprintfmt+0x207>
  80092e:	83 fb 1f             	cmp    $0x1f,%ebx
  800931:	7e 05                	jle    800938 <vprintfmt+0x1f5>
  800933:	83 fb 7e             	cmp    $0x7e,%ebx
  800936:	7e 12                	jle    80094a <vprintfmt+0x207>
					putch('?', putdat);
  800938:	83 ec 08             	sub    $0x8,%esp
  80093b:	ff 75 0c             	pushl  0xc(%ebp)
  80093e:	6a 3f                	push   $0x3f
  800940:	8b 45 08             	mov    0x8(%ebp),%eax
  800943:	ff d0                	call   *%eax
  800945:	83 c4 10             	add    $0x10,%esp
  800948:	eb 0f                	jmp    800959 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80094a:	83 ec 08             	sub    $0x8,%esp
  80094d:	ff 75 0c             	pushl  0xc(%ebp)
  800950:	53                   	push   %ebx
  800951:	8b 45 08             	mov    0x8(%ebp),%eax
  800954:	ff d0                	call   *%eax
  800956:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800959:	ff 4d e4             	decl   -0x1c(%ebp)
  80095c:	89 f0                	mov    %esi,%eax
  80095e:	8d 70 01             	lea    0x1(%eax),%esi
  800961:	8a 00                	mov    (%eax),%al
  800963:	0f be d8             	movsbl %al,%ebx
  800966:	85 db                	test   %ebx,%ebx
  800968:	74 24                	je     80098e <vprintfmt+0x24b>
  80096a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80096e:	78 b8                	js     800928 <vprintfmt+0x1e5>
  800970:	ff 4d e0             	decl   -0x20(%ebp)
  800973:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800977:	79 af                	jns    800928 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800979:	eb 13                	jmp    80098e <vprintfmt+0x24b>
				putch(' ', putdat);
  80097b:	83 ec 08             	sub    $0x8,%esp
  80097e:	ff 75 0c             	pushl  0xc(%ebp)
  800981:	6a 20                	push   $0x20
  800983:	8b 45 08             	mov    0x8(%ebp),%eax
  800986:	ff d0                	call   *%eax
  800988:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80098b:	ff 4d e4             	decl   -0x1c(%ebp)
  80098e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800992:	7f e7                	jg     80097b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800994:	e9 66 01 00 00       	jmp    800aff <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800999:	83 ec 08             	sub    $0x8,%esp
  80099c:	ff 75 e8             	pushl  -0x18(%ebp)
  80099f:	8d 45 14             	lea    0x14(%ebp),%eax
  8009a2:	50                   	push   %eax
  8009a3:	e8 3c fd ff ff       	call   8006e4 <getint>
  8009a8:	83 c4 10             	add    $0x10,%esp
  8009ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009b7:	85 d2                	test   %edx,%edx
  8009b9:	79 23                	jns    8009de <vprintfmt+0x29b>
				putch('-', putdat);
  8009bb:	83 ec 08             	sub    $0x8,%esp
  8009be:	ff 75 0c             	pushl  0xc(%ebp)
  8009c1:	6a 2d                	push   $0x2d
  8009c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c6:	ff d0                	call   *%eax
  8009c8:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009d1:	f7 d8                	neg    %eax
  8009d3:	83 d2 00             	adc    $0x0,%edx
  8009d6:	f7 da                	neg    %edx
  8009d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009db:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009de:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009e5:	e9 bc 00 00 00       	jmp    800aa6 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009ea:	83 ec 08             	sub    $0x8,%esp
  8009ed:	ff 75 e8             	pushl  -0x18(%ebp)
  8009f0:	8d 45 14             	lea    0x14(%ebp),%eax
  8009f3:	50                   	push   %eax
  8009f4:	e8 84 fc ff ff       	call   80067d <getuint>
  8009f9:	83 c4 10             	add    $0x10,%esp
  8009fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ff:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a02:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a09:	e9 98 00 00 00       	jmp    800aa6 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a0e:	83 ec 08             	sub    $0x8,%esp
  800a11:	ff 75 0c             	pushl  0xc(%ebp)
  800a14:	6a 58                	push   $0x58
  800a16:	8b 45 08             	mov    0x8(%ebp),%eax
  800a19:	ff d0                	call   *%eax
  800a1b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a1e:	83 ec 08             	sub    $0x8,%esp
  800a21:	ff 75 0c             	pushl  0xc(%ebp)
  800a24:	6a 58                	push   $0x58
  800a26:	8b 45 08             	mov    0x8(%ebp),%eax
  800a29:	ff d0                	call   *%eax
  800a2b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a2e:	83 ec 08             	sub    $0x8,%esp
  800a31:	ff 75 0c             	pushl  0xc(%ebp)
  800a34:	6a 58                	push   $0x58
  800a36:	8b 45 08             	mov    0x8(%ebp),%eax
  800a39:	ff d0                	call   *%eax
  800a3b:	83 c4 10             	add    $0x10,%esp
			break;
  800a3e:	e9 bc 00 00 00       	jmp    800aff <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a43:	83 ec 08             	sub    $0x8,%esp
  800a46:	ff 75 0c             	pushl  0xc(%ebp)
  800a49:	6a 30                	push   $0x30
  800a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4e:	ff d0                	call   *%eax
  800a50:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a53:	83 ec 08             	sub    $0x8,%esp
  800a56:	ff 75 0c             	pushl  0xc(%ebp)
  800a59:	6a 78                	push   $0x78
  800a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5e:	ff d0                	call   *%eax
  800a60:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a63:	8b 45 14             	mov    0x14(%ebp),%eax
  800a66:	83 c0 04             	add    $0x4,%eax
  800a69:	89 45 14             	mov    %eax,0x14(%ebp)
  800a6c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6f:	83 e8 04             	sub    $0x4,%eax
  800a72:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a77:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a7e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a85:	eb 1f                	jmp    800aa6 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a87:	83 ec 08             	sub    $0x8,%esp
  800a8a:	ff 75 e8             	pushl  -0x18(%ebp)
  800a8d:	8d 45 14             	lea    0x14(%ebp),%eax
  800a90:	50                   	push   %eax
  800a91:	e8 e7 fb ff ff       	call   80067d <getuint>
  800a96:	83 c4 10             	add    $0x10,%esp
  800a99:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a9c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a9f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aa6:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800aaa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aad:	83 ec 04             	sub    $0x4,%esp
  800ab0:	52                   	push   %edx
  800ab1:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ab4:	50                   	push   %eax
  800ab5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab8:	ff 75 f0             	pushl  -0x10(%ebp)
  800abb:	ff 75 0c             	pushl  0xc(%ebp)
  800abe:	ff 75 08             	pushl  0x8(%ebp)
  800ac1:	e8 00 fb ff ff       	call   8005c6 <printnum>
  800ac6:	83 c4 20             	add    $0x20,%esp
			break;
  800ac9:	eb 34                	jmp    800aff <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800acb:	83 ec 08             	sub    $0x8,%esp
  800ace:	ff 75 0c             	pushl  0xc(%ebp)
  800ad1:	53                   	push   %ebx
  800ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad5:	ff d0                	call   *%eax
  800ad7:	83 c4 10             	add    $0x10,%esp
			break;
  800ada:	eb 23                	jmp    800aff <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800adc:	83 ec 08             	sub    $0x8,%esp
  800adf:	ff 75 0c             	pushl  0xc(%ebp)
  800ae2:	6a 25                	push   $0x25
  800ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae7:	ff d0                	call   *%eax
  800ae9:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aec:	ff 4d 10             	decl   0x10(%ebp)
  800aef:	eb 03                	jmp    800af4 <vprintfmt+0x3b1>
  800af1:	ff 4d 10             	decl   0x10(%ebp)
  800af4:	8b 45 10             	mov    0x10(%ebp),%eax
  800af7:	48                   	dec    %eax
  800af8:	8a 00                	mov    (%eax),%al
  800afa:	3c 25                	cmp    $0x25,%al
  800afc:	75 f3                	jne    800af1 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800afe:	90                   	nop
		}
	}
  800aff:	e9 47 fc ff ff       	jmp    80074b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b04:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b05:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b08:	5b                   	pop    %ebx
  800b09:	5e                   	pop    %esi
  800b0a:	5d                   	pop    %ebp
  800b0b:	c3                   	ret    

00800b0c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b0c:	55                   	push   %ebp
  800b0d:	89 e5                	mov    %esp,%ebp
  800b0f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b12:	8d 45 10             	lea    0x10(%ebp),%eax
  800b15:	83 c0 04             	add    $0x4,%eax
  800b18:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b1e:	ff 75 f4             	pushl  -0xc(%ebp)
  800b21:	50                   	push   %eax
  800b22:	ff 75 0c             	pushl  0xc(%ebp)
  800b25:	ff 75 08             	pushl  0x8(%ebp)
  800b28:	e8 16 fc ff ff       	call   800743 <vprintfmt>
  800b2d:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b30:	90                   	nop
  800b31:	c9                   	leave  
  800b32:	c3                   	ret    

00800b33 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b33:	55                   	push   %ebp
  800b34:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b39:	8b 40 08             	mov    0x8(%eax),%eax
  800b3c:	8d 50 01             	lea    0x1(%eax),%edx
  800b3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b42:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b48:	8b 10                	mov    (%eax),%edx
  800b4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4d:	8b 40 04             	mov    0x4(%eax),%eax
  800b50:	39 c2                	cmp    %eax,%edx
  800b52:	73 12                	jae    800b66 <sprintputch+0x33>
		*b->buf++ = ch;
  800b54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b57:	8b 00                	mov    (%eax),%eax
  800b59:	8d 48 01             	lea    0x1(%eax),%ecx
  800b5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b5f:	89 0a                	mov    %ecx,(%edx)
  800b61:	8b 55 08             	mov    0x8(%ebp),%edx
  800b64:	88 10                	mov    %dl,(%eax)
}
  800b66:	90                   	nop
  800b67:	5d                   	pop    %ebp
  800b68:	c3                   	ret    

00800b69 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b69:	55                   	push   %ebp
  800b6a:	89 e5                	mov    %esp,%ebp
  800b6c:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b72:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b78:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7e:	01 d0                	add    %edx,%eax
  800b80:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b83:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b8a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b8e:	74 06                	je     800b96 <vsnprintf+0x2d>
  800b90:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b94:	7f 07                	jg     800b9d <vsnprintf+0x34>
		return -E_INVAL;
  800b96:	b8 03 00 00 00       	mov    $0x3,%eax
  800b9b:	eb 20                	jmp    800bbd <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b9d:	ff 75 14             	pushl  0x14(%ebp)
  800ba0:	ff 75 10             	pushl  0x10(%ebp)
  800ba3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ba6:	50                   	push   %eax
  800ba7:	68 33 0b 80 00       	push   $0x800b33
  800bac:	e8 92 fb ff ff       	call   800743 <vprintfmt>
  800bb1:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bb4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bb7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bba:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bbd:	c9                   	leave  
  800bbe:	c3                   	ret    

00800bbf <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bbf:	55                   	push   %ebp
  800bc0:	89 e5                	mov    %esp,%ebp
  800bc2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bc5:	8d 45 10             	lea    0x10(%ebp),%eax
  800bc8:	83 c0 04             	add    $0x4,%eax
  800bcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bce:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd1:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd4:	50                   	push   %eax
  800bd5:	ff 75 0c             	pushl  0xc(%ebp)
  800bd8:	ff 75 08             	pushl  0x8(%ebp)
  800bdb:	e8 89 ff ff ff       	call   800b69 <vsnprintf>
  800be0:	83 c4 10             	add    $0x10,%esp
  800be3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800be6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800be9:	c9                   	leave  
  800bea:	c3                   	ret    

00800beb <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bf1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bf8:	eb 06                	jmp    800c00 <strlen+0x15>
		n++;
  800bfa:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bfd:	ff 45 08             	incl   0x8(%ebp)
  800c00:	8b 45 08             	mov    0x8(%ebp),%eax
  800c03:	8a 00                	mov    (%eax),%al
  800c05:	84 c0                	test   %al,%al
  800c07:	75 f1                	jne    800bfa <strlen+0xf>
		n++;
	return n;
  800c09:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c0c:	c9                   	leave  
  800c0d:	c3                   	ret    

00800c0e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
  800c11:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c14:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c1b:	eb 09                	jmp    800c26 <strnlen+0x18>
		n++;
  800c1d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c20:	ff 45 08             	incl   0x8(%ebp)
  800c23:	ff 4d 0c             	decl   0xc(%ebp)
  800c26:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c2a:	74 09                	je     800c35 <strnlen+0x27>
  800c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2f:	8a 00                	mov    (%eax),%al
  800c31:	84 c0                	test   %al,%al
  800c33:	75 e8                	jne    800c1d <strnlen+0xf>
		n++;
	return n;
  800c35:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c38:	c9                   	leave  
  800c39:	c3                   	ret    

00800c3a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c3a:	55                   	push   %ebp
  800c3b:	89 e5                	mov    %esp,%ebp
  800c3d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c40:	8b 45 08             	mov    0x8(%ebp),%eax
  800c43:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c46:	90                   	nop
  800c47:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4a:	8d 50 01             	lea    0x1(%eax),%edx
  800c4d:	89 55 08             	mov    %edx,0x8(%ebp)
  800c50:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c53:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c56:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c59:	8a 12                	mov    (%edx),%dl
  800c5b:	88 10                	mov    %dl,(%eax)
  800c5d:	8a 00                	mov    (%eax),%al
  800c5f:	84 c0                	test   %al,%al
  800c61:	75 e4                	jne    800c47 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c63:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c66:	c9                   	leave  
  800c67:	c3                   	ret    

00800c68 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c68:	55                   	push   %ebp
  800c69:	89 e5                	mov    %esp,%ebp
  800c6b:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c71:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c74:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c7b:	eb 1f                	jmp    800c9c <strncpy+0x34>
		*dst++ = *src;
  800c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c80:	8d 50 01             	lea    0x1(%eax),%edx
  800c83:	89 55 08             	mov    %edx,0x8(%ebp)
  800c86:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c89:	8a 12                	mov    (%edx),%dl
  800c8b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c90:	8a 00                	mov    (%eax),%al
  800c92:	84 c0                	test   %al,%al
  800c94:	74 03                	je     800c99 <strncpy+0x31>
			src++;
  800c96:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c99:	ff 45 fc             	incl   -0x4(%ebp)
  800c9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c9f:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ca2:	72 d9                	jb     800c7d <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ca4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ca7:	c9                   	leave  
  800ca8:	c3                   	ret    

00800ca9 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ca9:	55                   	push   %ebp
  800caa:	89 e5                	mov    %esp,%ebp
  800cac:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cb5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cb9:	74 30                	je     800ceb <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cbb:	eb 16                	jmp    800cd3 <strlcpy+0x2a>
			*dst++ = *src++;
  800cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc0:	8d 50 01             	lea    0x1(%eax),%edx
  800cc3:	89 55 08             	mov    %edx,0x8(%ebp)
  800cc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cc9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ccc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ccf:	8a 12                	mov    (%edx),%dl
  800cd1:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cd3:	ff 4d 10             	decl   0x10(%ebp)
  800cd6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cda:	74 09                	je     800ce5 <strlcpy+0x3c>
  800cdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdf:	8a 00                	mov    (%eax),%al
  800ce1:	84 c0                	test   %al,%al
  800ce3:	75 d8                	jne    800cbd <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ceb:	8b 55 08             	mov    0x8(%ebp),%edx
  800cee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf1:	29 c2                	sub    %eax,%edx
  800cf3:	89 d0                	mov    %edx,%eax
}
  800cf5:	c9                   	leave  
  800cf6:	c3                   	ret    

00800cf7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cf7:	55                   	push   %ebp
  800cf8:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cfa:	eb 06                	jmp    800d02 <strcmp+0xb>
		p++, q++;
  800cfc:	ff 45 08             	incl   0x8(%ebp)
  800cff:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d02:	8b 45 08             	mov    0x8(%ebp),%eax
  800d05:	8a 00                	mov    (%eax),%al
  800d07:	84 c0                	test   %al,%al
  800d09:	74 0e                	je     800d19 <strcmp+0x22>
  800d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0e:	8a 10                	mov    (%eax),%dl
  800d10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d13:	8a 00                	mov    (%eax),%al
  800d15:	38 c2                	cmp    %al,%dl
  800d17:	74 e3                	je     800cfc <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	8a 00                	mov    (%eax),%al
  800d1e:	0f b6 d0             	movzbl %al,%edx
  800d21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d24:	8a 00                	mov    (%eax),%al
  800d26:	0f b6 c0             	movzbl %al,%eax
  800d29:	29 c2                	sub    %eax,%edx
  800d2b:	89 d0                	mov    %edx,%eax
}
  800d2d:	5d                   	pop    %ebp
  800d2e:	c3                   	ret    

00800d2f <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d2f:	55                   	push   %ebp
  800d30:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d32:	eb 09                	jmp    800d3d <strncmp+0xe>
		n--, p++, q++;
  800d34:	ff 4d 10             	decl   0x10(%ebp)
  800d37:	ff 45 08             	incl   0x8(%ebp)
  800d3a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d3d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d41:	74 17                	je     800d5a <strncmp+0x2b>
  800d43:	8b 45 08             	mov    0x8(%ebp),%eax
  800d46:	8a 00                	mov    (%eax),%al
  800d48:	84 c0                	test   %al,%al
  800d4a:	74 0e                	je     800d5a <strncmp+0x2b>
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	8a 10                	mov    (%eax),%dl
  800d51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d54:	8a 00                	mov    (%eax),%al
  800d56:	38 c2                	cmp    %al,%dl
  800d58:	74 da                	je     800d34 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d5a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5e:	75 07                	jne    800d67 <strncmp+0x38>
		return 0;
  800d60:	b8 00 00 00 00       	mov    $0x0,%eax
  800d65:	eb 14                	jmp    800d7b <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	8a 00                	mov    (%eax),%al
  800d6c:	0f b6 d0             	movzbl %al,%edx
  800d6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d72:	8a 00                	mov    (%eax),%al
  800d74:	0f b6 c0             	movzbl %al,%eax
  800d77:	29 c2                	sub    %eax,%edx
  800d79:	89 d0                	mov    %edx,%eax
}
  800d7b:	5d                   	pop    %ebp
  800d7c:	c3                   	ret    

00800d7d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d7d:	55                   	push   %ebp
  800d7e:	89 e5                	mov    %esp,%ebp
  800d80:	83 ec 04             	sub    $0x4,%esp
  800d83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d86:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d89:	eb 12                	jmp    800d9d <strchr+0x20>
		if (*s == c)
  800d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8e:	8a 00                	mov    (%eax),%al
  800d90:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d93:	75 05                	jne    800d9a <strchr+0x1d>
			return (char *) s;
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
  800d98:	eb 11                	jmp    800dab <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d9a:	ff 45 08             	incl   0x8(%ebp)
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	8a 00                	mov    (%eax),%al
  800da2:	84 c0                	test   %al,%al
  800da4:	75 e5                	jne    800d8b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800da6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dab:	c9                   	leave  
  800dac:	c3                   	ret    

00800dad <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dad:	55                   	push   %ebp
  800dae:	89 e5                	mov    %esp,%ebp
  800db0:	83 ec 04             	sub    $0x4,%esp
  800db3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800db9:	eb 0d                	jmp    800dc8 <strfind+0x1b>
		if (*s == c)
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	8a 00                	mov    (%eax),%al
  800dc0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dc3:	74 0e                	je     800dd3 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dc5:	ff 45 08             	incl   0x8(%ebp)
  800dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcb:	8a 00                	mov    (%eax),%al
  800dcd:	84 c0                	test   %al,%al
  800dcf:	75 ea                	jne    800dbb <strfind+0xe>
  800dd1:	eb 01                	jmp    800dd4 <strfind+0x27>
		if (*s == c)
			break;
  800dd3:	90                   	nop
	return (char *) s;
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd7:	c9                   	leave  
  800dd8:	c3                   	ret    

00800dd9 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800dd9:	55                   	push   %ebp
  800dda:	89 e5                	mov    %esp,%ebp
  800ddc:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  800de2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800de5:	8b 45 10             	mov    0x10(%ebp),%eax
  800de8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800deb:	eb 0e                	jmp    800dfb <memset+0x22>
		*p++ = c;
  800ded:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df0:	8d 50 01             	lea    0x1(%eax),%edx
  800df3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800df6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800df9:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dfb:	ff 4d f8             	decl   -0x8(%ebp)
  800dfe:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e02:	79 e9                	jns    800ded <memset+0x14>
		*p++ = c;

	return v;
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e07:	c9                   	leave  
  800e08:	c3                   	ret    

00800e09 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e09:	55                   	push   %ebp
  800e0a:	89 e5                	mov    %esp,%ebp
  800e0c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e12:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e15:	8b 45 08             	mov    0x8(%ebp),%eax
  800e18:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e1b:	eb 16                	jmp    800e33 <memcpy+0x2a>
		*d++ = *s++;
  800e1d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e20:	8d 50 01             	lea    0x1(%eax),%edx
  800e23:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e26:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e29:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e2c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e2f:	8a 12                	mov    (%edx),%dl
  800e31:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e33:	8b 45 10             	mov    0x10(%ebp),%eax
  800e36:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e39:	89 55 10             	mov    %edx,0x10(%ebp)
  800e3c:	85 c0                	test   %eax,%eax
  800e3e:	75 dd                	jne    800e1d <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e43:	c9                   	leave  
  800e44:	c3                   	ret    

00800e45 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e45:	55                   	push   %ebp
  800e46:	89 e5                	mov    %esp,%ebp
  800e48:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e51:	8b 45 08             	mov    0x8(%ebp),%eax
  800e54:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e57:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e5a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e5d:	73 50                	jae    800eaf <memmove+0x6a>
  800e5f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e62:	8b 45 10             	mov    0x10(%ebp),%eax
  800e65:	01 d0                	add    %edx,%eax
  800e67:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e6a:	76 43                	jbe    800eaf <memmove+0x6a>
		s += n;
  800e6c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6f:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e72:	8b 45 10             	mov    0x10(%ebp),%eax
  800e75:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e78:	eb 10                	jmp    800e8a <memmove+0x45>
			*--d = *--s;
  800e7a:	ff 4d f8             	decl   -0x8(%ebp)
  800e7d:	ff 4d fc             	decl   -0x4(%ebp)
  800e80:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e83:	8a 10                	mov    (%eax),%dl
  800e85:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e88:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e8a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e90:	89 55 10             	mov    %edx,0x10(%ebp)
  800e93:	85 c0                	test   %eax,%eax
  800e95:	75 e3                	jne    800e7a <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e97:	eb 23                	jmp    800ebc <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e99:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9c:	8d 50 01             	lea    0x1(%eax),%edx
  800e9f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ea2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ea5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ea8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800eab:	8a 12                	mov    (%edx),%dl
  800ead:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800eaf:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eb5:	89 55 10             	mov    %edx,0x10(%ebp)
  800eb8:	85 c0                	test   %eax,%eax
  800eba:	75 dd                	jne    800e99 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ebc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ebf:	c9                   	leave  
  800ec0:	c3                   	ret    

00800ec1 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ec1:	55                   	push   %ebp
  800ec2:	89 e5                	mov    %esp,%ebp
  800ec4:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ecd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed0:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ed3:	eb 2a                	jmp    800eff <memcmp+0x3e>
		if (*s1 != *s2)
  800ed5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed8:	8a 10                	mov    (%eax),%dl
  800eda:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800edd:	8a 00                	mov    (%eax),%al
  800edf:	38 c2                	cmp    %al,%dl
  800ee1:	74 16                	je     800ef9 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ee3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee6:	8a 00                	mov    (%eax),%al
  800ee8:	0f b6 d0             	movzbl %al,%edx
  800eeb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eee:	8a 00                	mov    (%eax),%al
  800ef0:	0f b6 c0             	movzbl %al,%eax
  800ef3:	29 c2                	sub    %eax,%edx
  800ef5:	89 d0                	mov    %edx,%eax
  800ef7:	eb 18                	jmp    800f11 <memcmp+0x50>
		s1++, s2++;
  800ef9:	ff 45 fc             	incl   -0x4(%ebp)
  800efc:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800eff:	8b 45 10             	mov    0x10(%ebp),%eax
  800f02:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f05:	89 55 10             	mov    %edx,0x10(%ebp)
  800f08:	85 c0                	test   %eax,%eax
  800f0a:	75 c9                	jne    800ed5 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f11:	c9                   	leave  
  800f12:	c3                   	ret    

00800f13 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f13:	55                   	push   %ebp
  800f14:	89 e5                	mov    %esp,%ebp
  800f16:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f19:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1f:	01 d0                	add    %edx,%eax
  800f21:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f24:	eb 15                	jmp    800f3b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	8a 00                	mov    (%eax),%al
  800f2b:	0f b6 d0             	movzbl %al,%edx
  800f2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f31:	0f b6 c0             	movzbl %al,%eax
  800f34:	39 c2                	cmp    %eax,%edx
  800f36:	74 0d                	je     800f45 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f38:	ff 45 08             	incl   0x8(%ebp)
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f41:	72 e3                	jb     800f26 <memfind+0x13>
  800f43:	eb 01                	jmp    800f46 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f45:	90                   	nop
	return (void *) s;
  800f46:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f49:	c9                   	leave  
  800f4a:	c3                   	ret    

00800f4b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f4b:	55                   	push   %ebp
  800f4c:	89 e5                	mov    %esp,%ebp
  800f4e:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f58:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f5f:	eb 03                	jmp    800f64 <strtol+0x19>
		s++;
  800f61:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f64:	8b 45 08             	mov    0x8(%ebp),%eax
  800f67:	8a 00                	mov    (%eax),%al
  800f69:	3c 20                	cmp    $0x20,%al
  800f6b:	74 f4                	je     800f61 <strtol+0x16>
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	8a 00                	mov    (%eax),%al
  800f72:	3c 09                	cmp    $0x9,%al
  800f74:	74 eb                	je     800f61 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f76:	8b 45 08             	mov    0x8(%ebp),%eax
  800f79:	8a 00                	mov    (%eax),%al
  800f7b:	3c 2b                	cmp    $0x2b,%al
  800f7d:	75 05                	jne    800f84 <strtol+0x39>
		s++;
  800f7f:	ff 45 08             	incl   0x8(%ebp)
  800f82:	eb 13                	jmp    800f97 <strtol+0x4c>
	else if (*s == '-')
  800f84:	8b 45 08             	mov    0x8(%ebp),%eax
  800f87:	8a 00                	mov    (%eax),%al
  800f89:	3c 2d                	cmp    $0x2d,%al
  800f8b:	75 0a                	jne    800f97 <strtol+0x4c>
		s++, neg = 1;
  800f8d:	ff 45 08             	incl   0x8(%ebp)
  800f90:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f97:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9b:	74 06                	je     800fa3 <strtol+0x58>
  800f9d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fa1:	75 20                	jne    800fc3 <strtol+0x78>
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	8a 00                	mov    (%eax),%al
  800fa8:	3c 30                	cmp    $0x30,%al
  800faa:	75 17                	jne    800fc3 <strtol+0x78>
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	40                   	inc    %eax
  800fb0:	8a 00                	mov    (%eax),%al
  800fb2:	3c 78                	cmp    $0x78,%al
  800fb4:	75 0d                	jne    800fc3 <strtol+0x78>
		s += 2, base = 16;
  800fb6:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fba:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fc1:	eb 28                	jmp    800feb <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fc3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc7:	75 15                	jne    800fde <strtol+0x93>
  800fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcc:	8a 00                	mov    (%eax),%al
  800fce:	3c 30                	cmp    $0x30,%al
  800fd0:	75 0c                	jne    800fde <strtol+0x93>
		s++, base = 8;
  800fd2:	ff 45 08             	incl   0x8(%ebp)
  800fd5:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fdc:	eb 0d                	jmp    800feb <strtol+0xa0>
	else if (base == 0)
  800fde:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fe2:	75 07                	jne    800feb <strtol+0xa0>
		base = 10;
  800fe4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800feb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fee:	8a 00                	mov    (%eax),%al
  800ff0:	3c 2f                	cmp    $0x2f,%al
  800ff2:	7e 19                	jle    80100d <strtol+0xc2>
  800ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff7:	8a 00                	mov    (%eax),%al
  800ff9:	3c 39                	cmp    $0x39,%al
  800ffb:	7f 10                	jg     80100d <strtol+0xc2>
			dig = *s - '0';
  800ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  801000:	8a 00                	mov    (%eax),%al
  801002:	0f be c0             	movsbl %al,%eax
  801005:	83 e8 30             	sub    $0x30,%eax
  801008:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80100b:	eb 42                	jmp    80104f <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80100d:	8b 45 08             	mov    0x8(%ebp),%eax
  801010:	8a 00                	mov    (%eax),%al
  801012:	3c 60                	cmp    $0x60,%al
  801014:	7e 19                	jle    80102f <strtol+0xe4>
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
  801019:	8a 00                	mov    (%eax),%al
  80101b:	3c 7a                	cmp    $0x7a,%al
  80101d:	7f 10                	jg     80102f <strtol+0xe4>
			dig = *s - 'a' + 10;
  80101f:	8b 45 08             	mov    0x8(%ebp),%eax
  801022:	8a 00                	mov    (%eax),%al
  801024:	0f be c0             	movsbl %al,%eax
  801027:	83 e8 57             	sub    $0x57,%eax
  80102a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80102d:	eb 20                	jmp    80104f <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	8a 00                	mov    (%eax),%al
  801034:	3c 40                	cmp    $0x40,%al
  801036:	7e 39                	jle    801071 <strtol+0x126>
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	8a 00                	mov    (%eax),%al
  80103d:	3c 5a                	cmp    $0x5a,%al
  80103f:	7f 30                	jg     801071 <strtol+0x126>
			dig = *s - 'A' + 10;
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
  801044:	8a 00                	mov    (%eax),%al
  801046:	0f be c0             	movsbl %al,%eax
  801049:	83 e8 37             	sub    $0x37,%eax
  80104c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80104f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801052:	3b 45 10             	cmp    0x10(%ebp),%eax
  801055:	7d 19                	jge    801070 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801057:	ff 45 08             	incl   0x8(%ebp)
  80105a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105d:	0f af 45 10          	imul   0x10(%ebp),%eax
  801061:	89 c2                	mov    %eax,%edx
  801063:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801066:	01 d0                	add    %edx,%eax
  801068:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80106b:	e9 7b ff ff ff       	jmp    800feb <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801070:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801071:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801075:	74 08                	je     80107f <strtol+0x134>
		*endptr = (char *) s;
  801077:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107a:	8b 55 08             	mov    0x8(%ebp),%edx
  80107d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80107f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801083:	74 07                	je     80108c <strtol+0x141>
  801085:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801088:	f7 d8                	neg    %eax
  80108a:	eb 03                	jmp    80108f <strtol+0x144>
  80108c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80108f:	c9                   	leave  
  801090:	c3                   	ret    

00801091 <ltostr>:

void
ltostr(long value, char *str)
{
  801091:	55                   	push   %ebp
  801092:	89 e5                	mov    %esp,%ebp
  801094:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801097:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80109e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010a9:	79 13                	jns    8010be <ltostr+0x2d>
	{
		neg = 1;
  8010ab:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b5:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010b8:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010bb:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010be:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c1:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010c6:	99                   	cltd   
  8010c7:	f7 f9                	idiv   %ecx
  8010c9:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010cf:	8d 50 01             	lea    0x1(%eax),%edx
  8010d2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010d5:	89 c2                	mov    %eax,%edx
  8010d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010da:	01 d0                	add    %edx,%eax
  8010dc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010df:	83 c2 30             	add    $0x30,%edx
  8010e2:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010e7:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010ec:	f7 e9                	imul   %ecx
  8010ee:	c1 fa 02             	sar    $0x2,%edx
  8010f1:	89 c8                	mov    %ecx,%eax
  8010f3:	c1 f8 1f             	sar    $0x1f,%eax
  8010f6:	29 c2                	sub    %eax,%edx
  8010f8:	89 d0                	mov    %edx,%eax
  8010fa:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801100:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801105:	f7 e9                	imul   %ecx
  801107:	c1 fa 02             	sar    $0x2,%edx
  80110a:	89 c8                	mov    %ecx,%eax
  80110c:	c1 f8 1f             	sar    $0x1f,%eax
  80110f:	29 c2                	sub    %eax,%edx
  801111:	89 d0                	mov    %edx,%eax
  801113:	c1 e0 02             	shl    $0x2,%eax
  801116:	01 d0                	add    %edx,%eax
  801118:	01 c0                	add    %eax,%eax
  80111a:	29 c1                	sub    %eax,%ecx
  80111c:	89 ca                	mov    %ecx,%edx
  80111e:	85 d2                	test   %edx,%edx
  801120:	75 9c                	jne    8010be <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801122:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801129:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80112c:	48                   	dec    %eax
  80112d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801130:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801134:	74 3d                	je     801173 <ltostr+0xe2>
		start = 1 ;
  801136:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80113d:	eb 34                	jmp    801173 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80113f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801142:	8b 45 0c             	mov    0xc(%ebp),%eax
  801145:	01 d0                	add    %edx,%eax
  801147:	8a 00                	mov    (%eax),%al
  801149:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80114c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80114f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801152:	01 c2                	add    %eax,%edx
  801154:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801157:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115a:	01 c8                	add    %ecx,%eax
  80115c:	8a 00                	mov    (%eax),%al
  80115e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801160:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801163:	8b 45 0c             	mov    0xc(%ebp),%eax
  801166:	01 c2                	add    %eax,%edx
  801168:	8a 45 eb             	mov    -0x15(%ebp),%al
  80116b:	88 02                	mov    %al,(%edx)
		start++ ;
  80116d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801170:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801173:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801176:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801179:	7c c4                	jl     80113f <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80117b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80117e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801181:	01 d0                	add    %edx,%eax
  801183:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801186:	90                   	nop
  801187:	c9                   	leave  
  801188:	c3                   	ret    

00801189 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801189:	55                   	push   %ebp
  80118a:	89 e5                	mov    %esp,%ebp
  80118c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80118f:	ff 75 08             	pushl  0x8(%ebp)
  801192:	e8 54 fa ff ff       	call   800beb <strlen>
  801197:	83 c4 04             	add    $0x4,%esp
  80119a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80119d:	ff 75 0c             	pushl  0xc(%ebp)
  8011a0:	e8 46 fa ff ff       	call   800beb <strlen>
  8011a5:	83 c4 04             	add    $0x4,%esp
  8011a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011b9:	eb 17                	jmp    8011d2 <strcconcat+0x49>
		final[s] = str1[s] ;
  8011bb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011be:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c1:	01 c2                	add    %eax,%edx
  8011c3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c9:	01 c8                	add    %ecx,%eax
  8011cb:	8a 00                	mov    (%eax),%al
  8011cd:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011cf:	ff 45 fc             	incl   -0x4(%ebp)
  8011d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011d8:	7c e1                	jl     8011bb <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011da:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011e1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011e8:	eb 1f                	jmp    801209 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ed:	8d 50 01             	lea    0x1(%eax),%edx
  8011f0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011f3:	89 c2                	mov    %eax,%edx
  8011f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f8:	01 c2                	add    %eax,%edx
  8011fa:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801200:	01 c8                	add    %ecx,%eax
  801202:	8a 00                	mov    (%eax),%al
  801204:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801206:	ff 45 f8             	incl   -0x8(%ebp)
  801209:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80120c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80120f:	7c d9                	jl     8011ea <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801211:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801214:	8b 45 10             	mov    0x10(%ebp),%eax
  801217:	01 d0                	add    %edx,%eax
  801219:	c6 00 00             	movb   $0x0,(%eax)
}
  80121c:	90                   	nop
  80121d:	c9                   	leave  
  80121e:	c3                   	ret    

0080121f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80121f:	55                   	push   %ebp
  801220:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801222:	8b 45 14             	mov    0x14(%ebp),%eax
  801225:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80122b:	8b 45 14             	mov    0x14(%ebp),%eax
  80122e:	8b 00                	mov    (%eax),%eax
  801230:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801237:	8b 45 10             	mov    0x10(%ebp),%eax
  80123a:	01 d0                	add    %edx,%eax
  80123c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801242:	eb 0c                	jmp    801250 <strsplit+0x31>
			*string++ = 0;
  801244:	8b 45 08             	mov    0x8(%ebp),%eax
  801247:	8d 50 01             	lea    0x1(%eax),%edx
  80124a:	89 55 08             	mov    %edx,0x8(%ebp)
  80124d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801250:	8b 45 08             	mov    0x8(%ebp),%eax
  801253:	8a 00                	mov    (%eax),%al
  801255:	84 c0                	test   %al,%al
  801257:	74 18                	je     801271 <strsplit+0x52>
  801259:	8b 45 08             	mov    0x8(%ebp),%eax
  80125c:	8a 00                	mov    (%eax),%al
  80125e:	0f be c0             	movsbl %al,%eax
  801261:	50                   	push   %eax
  801262:	ff 75 0c             	pushl  0xc(%ebp)
  801265:	e8 13 fb ff ff       	call   800d7d <strchr>
  80126a:	83 c4 08             	add    $0x8,%esp
  80126d:	85 c0                	test   %eax,%eax
  80126f:	75 d3                	jne    801244 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801271:	8b 45 08             	mov    0x8(%ebp),%eax
  801274:	8a 00                	mov    (%eax),%al
  801276:	84 c0                	test   %al,%al
  801278:	74 5a                	je     8012d4 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80127a:	8b 45 14             	mov    0x14(%ebp),%eax
  80127d:	8b 00                	mov    (%eax),%eax
  80127f:	83 f8 0f             	cmp    $0xf,%eax
  801282:	75 07                	jne    80128b <strsplit+0x6c>
		{
			return 0;
  801284:	b8 00 00 00 00       	mov    $0x0,%eax
  801289:	eb 66                	jmp    8012f1 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80128b:	8b 45 14             	mov    0x14(%ebp),%eax
  80128e:	8b 00                	mov    (%eax),%eax
  801290:	8d 48 01             	lea    0x1(%eax),%ecx
  801293:	8b 55 14             	mov    0x14(%ebp),%edx
  801296:	89 0a                	mov    %ecx,(%edx)
  801298:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80129f:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a2:	01 c2                	add    %eax,%edx
  8012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a7:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012a9:	eb 03                	jmp    8012ae <strsplit+0x8f>
			string++;
  8012ab:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b1:	8a 00                	mov    (%eax),%al
  8012b3:	84 c0                	test   %al,%al
  8012b5:	74 8b                	je     801242 <strsplit+0x23>
  8012b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ba:	8a 00                	mov    (%eax),%al
  8012bc:	0f be c0             	movsbl %al,%eax
  8012bf:	50                   	push   %eax
  8012c0:	ff 75 0c             	pushl  0xc(%ebp)
  8012c3:	e8 b5 fa ff ff       	call   800d7d <strchr>
  8012c8:	83 c4 08             	add    $0x8,%esp
  8012cb:	85 c0                	test   %eax,%eax
  8012cd:	74 dc                	je     8012ab <strsplit+0x8c>
			string++;
	}
  8012cf:	e9 6e ff ff ff       	jmp    801242 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012d4:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d8:	8b 00                	mov    (%eax),%eax
  8012da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e4:	01 d0                	add    %edx,%eax
  8012e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012ec:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012f1:	c9                   	leave  
  8012f2:	c3                   	ret    

008012f3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8012f3:	55                   	push   %ebp
  8012f4:	89 e5                	mov    %esp,%ebp
  8012f6:	57                   	push   %edi
  8012f7:	56                   	push   %esi
  8012f8:	53                   	push   %ebx
  8012f9:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801302:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801305:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801308:	8b 7d 18             	mov    0x18(%ebp),%edi
  80130b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80130e:	cd 30                	int    $0x30
  801310:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801313:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801316:	83 c4 10             	add    $0x10,%esp
  801319:	5b                   	pop    %ebx
  80131a:	5e                   	pop    %esi
  80131b:	5f                   	pop    %edi
  80131c:	5d                   	pop    %ebp
  80131d:	c3                   	ret    

0080131e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80131e:	55                   	push   %ebp
  80131f:	89 e5                	mov    %esp,%ebp
  801321:	83 ec 04             	sub    $0x4,%esp
  801324:	8b 45 10             	mov    0x10(%ebp),%eax
  801327:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80132a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80132e:	8b 45 08             	mov    0x8(%ebp),%eax
  801331:	6a 00                	push   $0x0
  801333:	6a 00                	push   $0x0
  801335:	52                   	push   %edx
  801336:	ff 75 0c             	pushl  0xc(%ebp)
  801339:	50                   	push   %eax
  80133a:	6a 00                	push   $0x0
  80133c:	e8 b2 ff ff ff       	call   8012f3 <syscall>
  801341:	83 c4 18             	add    $0x18,%esp
}
  801344:	90                   	nop
  801345:	c9                   	leave  
  801346:	c3                   	ret    

00801347 <sys_cgetc>:

int
sys_cgetc(void)
{
  801347:	55                   	push   %ebp
  801348:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80134a:	6a 00                	push   $0x0
  80134c:	6a 00                	push   $0x0
  80134e:	6a 00                	push   $0x0
  801350:	6a 00                	push   $0x0
  801352:	6a 00                	push   $0x0
  801354:	6a 01                	push   $0x1
  801356:	e8 98 ff ff ff       	call   8012f3 <syscall>
  80135b:	83 c4 18             	add    $0x18,%esp
}
  80135e:	c9                   	leave  
  80135f:	c3                   	ret    

00801360 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801360:	55                   	push   %ebp
  801361:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801363:	8b 55 0c             	mov    0xc(%ebp),%edx
  801366:	8b 45 08             	mov    0x8(%ebp),%eax
  801369:	6a 00                	push   $0x0
  80136b:	6a 00                	push   $0x0
  80136d:	6a 00                	push   $0x0
  80136f:	52                   	push   %edx
  801370:	50                   	push   %eax
  801371:	6a 05                	push   $0x5
  801373:	e8 7b ff ff ff       	call   8012f3 <syscall>
  801378:	83 c4 18             	add    $0x18,%esp
}
  80137b:	c9                   	leave  
  80137c:	c3                   	ret    

0080137d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80137d:	55                   	push   %ebp
  80137e:	89 e5                	mov    %esp,%ebp
  801380:	56                   	push   %esi
  801381:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801382:	8b 75 18             	mov    0x18(%ebp),%esi
  801385:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801388:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80138b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80138e:	8b 45 08             	mov    0x8(%ebp),%eax
  801391:	56                   	push   %esi
  801392:	53                   	push   %ebx
  801393:	51                   	push   %ecx
  801394:	52                   	push   %edx
  801395:	50                   	push   %eax
  801396:	6a 06                	push   $0x6
  801398:	e8 56 ff ff ff       	call   8012f3 <syscall>
  80139d:	83 c4 18             	add    $0x18,%esp
}
  8013a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013a3:	5b                   	pop    %ebx
  8013a4:	5e                   	pop    %esi
  8013a5:	5d                   	pop    %ebp
  8013a6:	c3                   	ret    

008013a7 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8013a7:	55                   	push   %ebp
  8013a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8013aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b0:	6a 00                	push   $0x0
  8013b2:	6a 00                	push   $0x0
  8013b4:	6a 00                	push   $0x0
  8013b6:	52                   	push   %edx
  8013b7:	50                   	push   %eax
  8013b8:	6a 07                	push   $0x7
  8013ba:	e8 34 ff ff ff       	call   8012f3 <syscall>
  8013bf:	83 c4 18             	add    $0x18,%esp
}
  8013c2:	c9                   	leave  
  8013c3:	c3                   	ret    

008013c4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8013c4:	55                   	push   %ebp
  8013c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8013c7:	6a 00                	push   $0x0
  8013c9:	6a 00                	push   $0x0
  8013cb:	6a 00                	push   $0x0
  8013cd:	ff 75 0c             	pushl  0xc(%ebp)
  8013d0:	ff 75 08             	pushl  0x8(%ebp)
  8013d3:	6a 08                	push   $0x8
  8013d5:	e8 19 ff ff ff       	call   8012f3 <syscall>
  8013da:	83 c4 18             	add    $0x18,%esp
}
  8013dd:	c9                   	leave  
  8013de:	c3                   	ret    

008013df <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8013df:	55                   	push   %ebp
  8013e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8013e2:	6a 00                	push   $0x0
  8013e4:	6a 00                	push   $0x0
  8013e6:	6a 00                	push   $0x0
  8013e8:	6a 00                	push   $0x0
  8013ea:	6a 00                	push   $0x0
  8013ec:	6a 09                	push   $0x9
  8013ee:	e8 00 ff ff ff       	call   8012f3 <syscall>
  8013f3:	83 c4 18             	add    $0x18,%esp
}
  8013f6:	c9                   	leave  
  8013f7:	c3                   	ret    

008013f8 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8013f8:	55                   	push   %ebp
  8013f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8013fb:	6a 00                	push   $0x0
  8013fd:	6a 00                	push   $0x0
  8013ff:	6a 00                	push   $0x0
  801401:	6a 00                	push   $0x0
  801403:	6a 00                	push   $0x0
  801405:	6a 0a                	push   $0xa
  801407:	e8 e7 fe ff ff       	call   8012f3 <syscall>
  80140c:	83 c4 18             	add    $0x18,%esp
}
  80140f:	c9                   	leave  
  801410:	c3                   	ret    

00801411 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801411:	55                   	push   %ebp
  801412:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801414:	6a 00                	push   $0x0
  801416:	6a 00                	push   $0x0
  801418:	6a 00                	push   $0x0
  80141a:	6a 00                	push   $0x0
  80141c:	6a 00                	push   $0x0
  80141e:	6a 0b                	push   $0xb
  801420:	e8 ce fe ff ff       	call   8012f3 <syscall>
  801425:	83 c4 18             	add    $0x18,%esp
}
  801428:	c9                   	leave  
  801429:	c3                   	ret    

0080142a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80142a:	55                   	push   %ebp
  80142b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80142d:	6a 00                	push   $0x0
  80142f:	6a 00                	push   $0x0
  801431:	6a 00                	push   $0x0
  801433:	ff 75 0c             	pushl  0xc(%ebp)
  801436:	ff 75 08             	pushl  0x8(%ebp)
  801439:	6a 0f                	push   $0xf
  80143b:	e8 b3 fe ff ff       	call   8012f3 <syscall>
  801440:	83 c4 18             	add    $0x18,%esp
	return;
  801443:	90                   	nop
}
  801444:	c9                   	leave  
  801445:	c3                   	ret    

00801446 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801446:	55                   	push   %ebp
  801447:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801449:	6a 00                	push   $0x0
  80144b:	6a 00                	push   $0x0
  80144d:	6a 00                	push   $0x0
  80144f:	ff 75 0c             	pushl  0xc(%ebp)
  801452:	ff 75 08             	pushl  0x8(%ebp)
  801455:	6a 10                	push   $0x10
  801457:	e8 97 fe ff ff       	call   8012f3 <syscall>
  80145c:	83 c4 18             	add    $0x18,%esp
	return ;
  80145f:	90                   	nop
}
  801460:	c9                   	leave  
  801461:	c3                   	ret    

00801462 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801462:	55                   	push   %ebp
  801463:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801465:	6a 00                	push   $0x0
  801467:	6a 00                	push   $0x0
  801469:	ff 75 10             	pushl  0x10(%ebp)
  80146c:	ff 75 0c             	pushl  0xc(%ebp)
  80146f:	ff 75 08             	pushl  0x8(%ebp)
  801472:	6a 11                	push   $0x11
  801474:	e8 7a fe ff ff       	call   8012f3 <syscall>
  801479:	83 c4 18             	add    $0x18,%esp
	return ;
  80147c:	90                   	nop
}
  80147d:	c9                   	leave  
  80147e:	c3                   	ret    

0080147f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80147f:	55                   	push   %ebp
  801480:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801482:	6a 00                	push   $0x0
  801484:	6a 00                	push   $0x0
  801486:	6a 00                	push   $0x0
  801488:	6a 00                	push   $0x0
  80148a:	6a 00                	push   $0x0
  80148c:	6a 0c                	push   $0xc
  80148e:	e8 60 fe ff ff       	call   8012f3 <syscall>
  801493:	83 c4 18             	add    $0x18,%esp
}
  801496:	c9                   	leave  
  801497:	c3                   	ret    

00801498 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801498:	55                   	push   %ebp
  801499:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80149b:	6a 00                	push   $0x0
  80149d:	6a 00                	push   $0x0
  80149f:	6a 00                	push   $0x0
  8014a1:	6a 00                	push   $0x0
  8014a3:	ff 75 08             	pushl  0x8(%ebp)
  8014a6:	6a 0d                	push   $0xd
  8014a8:	e8 46 fe ff ff       	call   8012f3 <syscall>
  8014ad:	83 c4 18             	add    $0x18,%esp
}
  8014b0:	c9                   	leave  
  8014b1:	c3                   	ret    

008014b2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8014b2:	55                   	push   %ebp
  8014b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8014b5:	6a 00                	push   $0x0
  8014b7:	6a 00                	push   $0x0
  8014b9:	6a 00                	push   $0x0
  8014bb:	6a 00                	push   $0x0
  8014bd:	6a 00                	push   $0x0
  8014bf:	6a 0e                	push   $0xe
  8014c1:	e8 2d fe ff ff       	call   8012f3 <syscall>
  8014c6:	83 c4 18             	add    $0x18,%esp
}
  8014c9:	90                   	nop
  8014ca:	c9                   	leave  
  8014cb:	c3                   	ret    

008014cc <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8014cc:	55                   	push   %ebp
  8014cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8014cf:	6a 00                	push   $0x0
  8014d1:	6a 00                	push   $0x0
  8014d3:	6a 00                	push   $0x0
  8014d5:	6a 00                	push   $0x0
  8014d7:	6a 00                	push   $0x0
  8014d9:	6a 13                	push   $0x13
  8014db:	e8 13 fe ff ff       	call   8012f3 <syscall>
  8014e0:	83 c4 18             	add    $0x18,%esp
}
  8014e3:	90                   	nop
  8014e4:	c9                   	leave  
  8014e5:	c3                   	ret    

008014e6 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8014e6:	55                   	push   %ebp
  8014e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8014e9:	6a 00                	push   $0x0
  8014eb:	6a 00                	push   $0x0
  8014ed:	6a 00                	push   $0x0
  8014ef:	6a 00                	push   $0x0
  8014f1:	6a 00                	push   $0x0
  8014f3:	6a 14                	push   $0x14
  8014f5:	e8 f9 fd ff ff       	call   8012f3 <syscall>
  8014fa:	83 c4 18             	add    $0x18,%esp
}
  8014fd:	90                   	nop
  8014fe:	c9                   	leave  
  8014ff:	c3                   	ret    

00801500 <sys_cputc>:


void
sys_cputc(const char c)
{
  801500:	55                   	push   %ebp
  801501:	89 e5                	mov    %esp,%ebp
  801503:	83 ec 04             	sub    $0x4,%esp
  801506:	8b 45 08             	mov    0x8(%ebp),%eax
  801509:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80150c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801510:	6a 00                	push   $0x0
  801512:	6a 00                	push   $0x0
  801514:	6a 00                	push   $0x0
  801516:	6a 00                	push   $0x0
  801518:	50                   	push   %eax
  801519:	6a 15                	push   $0x15
  80151b:	e8 d3 fd ff ff       	call   8012f3 <syscall>
  801520:	83 c4 18             	add    $0x18,%esp
}
  801523:	90                   	nop
  801524:	c9                   	leave  
  801525:	c3                   	ret    

00801526 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801526:	55                   	push   %ebp
  801527:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801529:	6a 00                	push   $0x0
  80152b:	6a 00                	push   $0x0
  80152d:	6a 00                	push   $0x0
  80152f:	6a 00                	push   $0x0
  801531:	6a 00                	push   $0x0
  801533:	6a 16                	push   $0x16
  801535:	e8 b9 fd ff ff       	call   8012f3 <syscall>
  80153a:	83 c4 18             	add    $0x18,%esp
}
  80153d:	90                   	nop
  80153e:	c9                   	leave  
  80153f:	c3                   	ret    

00801540 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801540:	55                   	push   %ebp
  801541:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801543:	8b 45 08             	mov    0x8(%ebp),%eax
  801546:	6a 00                	push   $0x0
  801548:	6a 00                	push   $0x0
  80154a:	6a 00                	push   $0x0
  80154c:	ff 75 0c             	pushl  0xc(%ebp)
  80154f:	50                   	push   %eax
  801550:	6a 17                	push   $0x17
  801552:	e8 9c fd ff ff       	call   8012f3 <syscall>
  801557:	83 c4 18             	add    $0x18,%esp
}
  80155a:	c9                   	leave  
  80155b:	c3                   	ret    

0080155c <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80155c:	55                   	push   %ebp
  80155d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80155f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801562:	8b 45 08             	mov    0x8(%ebp),%eax
  801565:	6a 00                	push   $0x0
  801567:	6a 00                	push   $0x0
  801569:	6a 00                	push   $0x0
  80156b:	52                   	push   %edx
  80156c:	50                   	push   %eax
  80156d:	6a 1a                	push   $0x1a
  80156f:	e8 7f fd ff ff       	call   8012f3 <syscall>
  801574:	83 c4 18             	add    $0x18,%esp
}
  801577:	c9                   	leave  
  801578:	c3                   	ret    

00801579 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801579:	55                   	push   %ebp
  80157a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80157c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80157f:	8b 45 08             	mov    0x8(%ebp),%eax
  801582:	6a 00                	push   $0x0
  801584:	6a 00                	push   $0x0
  801586:	6a 00                	push   $0x0
  801588:	52                   	push   %edx
  801589:	50                   	push   %eax
  80158a:	6a 18                	push   $0x18
  80158c:	e8 62 fd ff ff       	call   8012f3 <syscall>
  801591:	83 c4 18             	add    $0x18,%esp
}
  801594:	90                   	nop
  801595:	c9                   	leave  
  801596:	c3                   	ret    

00801597 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801597:	55                   	push   %ebp
  801598:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80159a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80159d:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a0:	6a 00                	push   $0x0
  8015a2:	6a 00                	push   $0x0
  8015a4:	6a 00                	push   $0x0
  8015a6:	52                   	push   %edx
  8015a7:	50                   	push   %eax
  8015a8:	6a 19                	push   $0x19
  8015aa:	e8 44 fd ff ff       	call   8012f3 <syscall>
  8015af:	83 c4 18             	add    $0x18,%esp
}
  8015b2:	90                   	nop
  8015b3:	c9                   	leave  
  8015b4:	c3                   	ret    

008015b5 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8015b5:	55                   	push   %ebp
  8015b6:	89 e5                	mov    %esp,%ebp
  8015b8:	83 ec 04             	sub    $0x4,%esp
  8015bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8015be:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8015c1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8015c4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cb:	6a 00                	push   $0x0
  8015cd:	51                   	push   %ecx
  8015ce:	52                   	push   %edx
  8015cf:	ff 75 0c             	pushl  0xc(%ebp)
  8015d2:	50                   	push   %eax
  8015d3:	6a 1b                	push   $0x1b
  8015d5:	e8 19 fd ff ff       	call   8012f3 <syscall>
  8015da:	83 c4 18             	add    $0x18,%esp
}
  8015dd:	c9                   	leave  
  8015de:	c3                   	ret    

008015df <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8015df:	55                   	push   %ebp
  8015e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8015e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 00                	push   $0x0
  8015ee:	52                   	push   %edx
  8015ef:	50                   	push   %eax
  8015f0:	6a 1c                	push   $0x1c
  8015f2:	e8 fc fc ff ff       	call   8012f3 <syscall>
  8015f7:	83 c4 18             	add    $0x18,%esp
}
  8015fa:	c9                   	leave  
  8015fb:	c3                   	ret    

008015fc <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8015fc:	55                   	push   %ebp
  8015fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8015ff:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801602:	8b 55 0c             	mov    0xc(%ebp),%edx
  801605:	8b 45 08             	mov    0x8(%ebp),%eax
  801608:	6a 00                	push   $0x0
  80160a:	6a 00                	push   $0x0
  80160c:	51                   	push   %ecx
  80160d:	52                   	push   %edx
  80160e:	50                   	push   %eax
  80160f:	6a 1d                	push   $0x1d
  801611:	e8 dd fc ff ff       	call   8012f3 <syscall>
  801616:	83 c4 18             	add    $0x18,%esp
}
  801619:	c9                   	leave  
  80161a:	c3                   	ret    

0080161b <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80161b:	55                   	push   %ebp
  80161c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80161e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801621:	8b 45 08             	mov    0x8(%ebp),%eax
  801624:	6a 00                	push   $0x0
  801626:	6a 00                	push   $0x0
  801628:	6a 00                	push   $0x0
  80162a:	52                   	push   %edx
  80162b:	50                   	push   %eax
  80162c:	6a 1e                	push   $0x1e
  80162e:	e8 c0 fc ff ff       	call   8012f3 <syscall>
  801633:	83 c4 18             	add    $0x18,%esp
}
  801636:	c9                   	leave  
  801637:	c3                   	ret    

00801638 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801638:	55                   	push   %ebp
  801639:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80163b:	6a 00                	push   $0x0
  80163d:	6a 00                	push   $0x0
  80163f:	6a 00                	push   $0x0
  801641:	6a 00                	push   $0x0
  801643:	6a 00                	push   $0x0
  801645:	6a 1f                	push   $0x1f
  801647:	e8 a7 fc ff ff       	call   8012f3 <syscall>
  80164c:	83 c4 18             	add    $0x18,%esp
}
  80164f:	c9                   	leave  
  801650:	c3                   	ret    

00801651 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801651:	55                   	push   %ebp
  801652:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801654:	8b 45 08             	mov    0x8(%ebp),%eax
  801657:	6a 00                	push   $0x0
  801659:	ff 75 14             	pushl  0x14(%ebp)
  80165c:	ff 75 10             	pushl  0x10(%ebp)
  80165f:	ff 75 0c             	pushl  0xc(%ebp)
  801662:	50                   	push   %eax
  801663:	6a 20                	push   $0x20
  801665:	e8 89 fc ff ff       	call   8012f3 <syscall>
  80166a:	83 c4 18             	add    $0x18,%esp
}
  80166d:	c9                   	leave  
  80166e:	c3                   	ret    

0080166f <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801672:	8b 45 08             	mov    0x8(%ebp),%eax
  801675:	6a 00                	push   $0x0
  801677:	6a 00                	push   $0x0
  801679:	6a 00                	push   $0x0
  80167b:	6a 00                	push   $0x0
  80167d:	50                   	push   %eax
  80167e:	6a 21                	push   $0x21
  801680:	e8 6e fc ff ff       	call   8012f3 <syscall>
  801685:	83 c4 18             	add    $0x18,%esp
}
  801688:	90                   	nop
  801689:	c9                   	leave  
  80168a:	c3                   	ret    

0080168b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80168b:	55                   	push   %ebp
  80168c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80168e:	8b 45 08             	mov    0x8(%ebp),%eax
  801691:	6a 00                	push   $0x0
  801693:	6a 00                	push   $0x0
  801695:	6a 00                	push   $0x0
  801697:	6a 00                	push   $0x0
  801699:	50                   	push   %eax
  80169a:	6a 22                	push   $0x22
  80169c:	e8 52 fc ff ff       	call   8012f3 <syscall>
  8016a1:	83 c4 18             	add    $0x18,%esp
}
  8016a4:	c9                   	leave  
  8016a5:	c3                   	ret    

008016a6 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8016a6:	55                   	push   %ebp
  8016a7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8016a9:	6a 00                	push   $0x0
  8016ab:	6a 00                	push   $0x0
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 00                	push   $0x0
  8016b1:	6a 00                	push   $0x0
  8016b3:	6a 02                	push   $0x2
  8016b5:	e8 39 fc ff ff       	call   8012f3 <syscall>
  8016ba:	83 c4 18             	add    $0x18,%esp
}
  8016bd:	c9                   	leave  
  8016be:	c3                   	ret    

008016bf <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8016bf:	55                   	push   %ebp
  8016c0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 03                	push   $0x3
  8016ce:	e8 20 fc ff ff       	call   8012f3 <syscall>
  8016d3:	83 c4 18             	add    $0x18,%esp
}
  8016d6:	c9                   	leave  
  8016d7:	c3                   	ret    

008016d8 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8016d8:	55                   	push   %ebp
  8016d9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 04                	push   $0x4
  8016e7:	e8 07 fc ff ff       	call   8012f3 <syscall>
  8016ec:	83 c4 18             	add    $0x18,%esp
}
  8016ef:	c9                   	leave  
  8016f0:	c3                   	ret    

008016f1 <sys_exit_env>:


void sys_exit_env(void)
{
  8016f1:	55                   	push   %ebp
  8016f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 23                	push   $0x23
  801700:	e8 ee fb ff ff       	call   8012f3 <syscall>
  801705:	83 c4 18             	add    $0x18,%esp
}
  801708:	90                   	nop
  801709:	c9                   	leave  
  80170a:	c3                   	ret    

0080170b <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80170b:	55                   	push   %ebp
  80170c:	89 e5                	mov    %esp,%ebp
  80170e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801711:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801714:	8d 50 04             	lea    0x4(%eax),%edx
  801717:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	52                   	push   %edx
  801721:	50                   	push   %eax
  801722:	6a 24                	push   $0x24
  801724:	e8 ca fb ff ff       	call   8012f3 <syscall>
  801729:	83 c4 18             	add    $0x18,%esp
	return result;
  80172c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80172f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801732:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801735:	89 01                	mov    %eax,(%ecx)
  801737:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80173a:	8b 45 08             	mov    0x8(%ebp),%eax
  80173d:	c9                   	leave  
  80173e:	c2 04 00             	ret    $0x4

00801741 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801741:	55                   	push   %ebp
  801742:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801744:	6a 00                	push   $0x0
  801746:	6a 00                	push   $0x0
  801748:	ff 75 10             	pushl  0x10(%ebp)
  80174b:	ff 75 0c             	pushl  0xc(%ebp)
  80174e:	ff 75 08             	pushl  0x8(%ebp)
  801751:	6a 12                	push   $0x12
  801753:	e8 9b fb ff ff       	call   8012f3 <syscall>
  801758:	83 c4 18             	add    $0x18,%esp
	return ;
  80175b:	90                   	nop
}
  80175c:	c9                   	leave  
  80175d:	c3                   	ret    

0080175e <sys_rcr2>:
uint32 sys_rcr2()
{
  80175e:	55                   	push   %ebp
  80175f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	6a 25                	push   $0x25
  80176d:	e8 81 fb ff ff       	call   8012f3 <syscall>
  801772:	83 c4 18             	add    $0x18,%esp
}
  801775:	c9                   	leave  
  801776:	c3                   	ret    

00801777 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801777:	55                   	push   %ebp
  801778:	89 e5                	mov    %esp,%ebp
  80177a:	83 ec 04             	sub    $0x4,%esp
  80177d:	8b 45 08             	mov    0x8(%ebp),%eax
  801780:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801783:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	50                   	push   %eax
  801790:	6a 26                	push   $0x26
  801792:	e8 5c fb ff ff       	call   8012f3 <syscall>
  801797:	83 c4 18             	add    $0x18,%esp
	return ;
  80179a:	90                   	nop
}
  80179b:	c9                   	leave  
  80179c:	c3                   	ret    

0080179d <rsttst>:
void rsttst()
{
  80179d:	55                   	push   %ebp
  80179e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 28                	push   $0x28
  8017ac:	e8 42 fb ff ff       	call   8012f3 <syscall>
  8017b1:	83 c4 18             	add    $0x18,%esp
	return ;
  8017b4:	90                   	nop
}
  8017b5:	c9                   	leave  
  8017b6:	c3                   	ret    

008017b7 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
  8017ba:	83 ec 04             	sub    $0x4,%esp
  8017bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8017c0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8017c3:	8b 55 18             	mov    0x18(%ebp),%edx
  8017c6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017ca:	52                   	push   %edx
  8017cb:	50                   	push   %eax
  8017cc:	ff 75 10             	pushl  0x10(%ebp)
  8017cf:	ff 75 0c             	pushl  0xc(%ebp)
  8017d2:	ff 75 08             	pushl  0x8(%ebp)
  8017d5:	6a 27                	push   $0x27
  8017d7:	e8 17 fb ff ff       	call   8012f3 <syscall>
  8017dc:	83 c4 18             	add    $0x18,%esp
	return ;
  8017df:	90                   	nop
}
  8017e0:	c9                   	leave  
  8017e1:	c3                   	ret    

008017e2 <chktst>:
void chktst(uint32 n)
{
  8017e2:	55                   	push   %ebp
  8017e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	ff 75 08             	pushl  0x8(%ebp)
  8017f0:	6a 29                	push   $0x29
  8017f2:	e8 fc fa ff ff       	call   8012f3 <syscall>
  8017f7:	83 c4 18             	add    $0x18,%esp
	return ;
  8017fa:	90                   	nop
}
  8017fb:	c9                   	leave  
  8017fc:	c3                   	ret    

008017fd <inctst>:

void inctst()
{
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	6a 2a                	push   $0x2a
  80180c:	e8 e2 fa ff ff       	call   8012f3 <syscall>
  801811:	83 c4 18             	add    $0x18,%esp
	return ;
  801814:	90                   	nop
}
  801815:	c9                   	leave  
  801816:	c3                   	ret    

00801817 <gettst>:
uint32 gettst()
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	6a 2b                	push   $0x2b
  801826:	e8 c8 fa ff ff       	call   8012f3 <syscall>
  80182b:	83 c4 18             	add    $0x18,%esp
}
  80182e:	c9                   	leave  
  80182f:	c3                   	ret    

00801830 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
  801833:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	6a 2c                	push   $0x2c
  801842:	e8 ac fa ff ff       	call   8012f3 <syscall>
  801847:	83 c4 18             	add    $0x18,%esp
  80184a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80184d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801851:	75 07                	jne    80185a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801853:	b8 01 00 00 00       	mov    $0x1,%eax
  801858:	eb 05                	jmp    80185f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80185a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80185f:	c9                   	leave  
  801860:	c3                   	ret    

00801861 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
  801864:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	6a 00                	push   $0x0
  801871:	6a 2c                	push   $0x2c
  801873:	e8 7b fa ff ff       	call   8012f3 <syscall>
  801878:	83 c4 18             	add    $0x18,%esp
  80187b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80187e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801882:	75 07                	jne    80188b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801884:	b8 01 00 00 00       	mov    $0x1,%eax
  801889:	eb 05                	jmp    801890 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80188b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801890:	c9                   	leave  
  801891:	c3                   	ret    

00801892 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801892:	55                   	push   %ebp
  801893:	89 e5                	mov    %esp,%ebp
  801895:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 2c                	push   $0x2c
  8018a4:	e8 4a fa ff ff       	call   8012f3 <syscall>
  8018a9:	83 c4 18             	add    $0x18,%esp
  8018ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8018af:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8018b3:	75 07                	jne    8018bc <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8018b5:	b8 01 00 00 00       	mov    $0x1,%eax
  8018ba:	eb 05                	jmp    8018c1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8018bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018c1:	c9                   	leave  
  8018c2:	c3                   	ret    

008018c3 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8018c3:	55                   	push   %ebp
  8018c4:	89 e5                	mov    %esp,%ebp
  8018c6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 2c                	push   $0x2c
  8018d5:	e8 19 fa ff ff       	call   8012f3 <syscall>
  8018da:	83 c4 18             	add    $0x18,%esp
  8018dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8018e0:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8018e4:	75 07                	jne    8018ed <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8018e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8018eb:	eb 05                	jmp    8018f2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8018ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018f2:	c9                   	leave  
  8018f3:	c3                   	ret    

008018f4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	ff 75 08             	pushl  0x8(%ebp)
  801902:	6a 2d                	push   $0x2d
  801904:	e8 ea f9 ff ff       	call   8012f3 <syscall>
  801909:	83 c4 18             	add    $0x18,%esp
	return ;
  80190c:	90                   	nop
}
  80190d:	c9                   	leave  
  80190e:	c3                   	ret    

0080190f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
  801912:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801913:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801916:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801919:	8b 55 0c             	mov    0xc(%ebp),%edx
  80191c:	8b 45 08             	mov    0x8(%ebp),%eax
  80191f:	6a 00                	push   $0x0
  801921:	53                   	push   %ebx
  801922:	51                   	push   %ecx
  801923:	52                   	push   %edx
  801924:	50                   	push   %eax
  801925:	6a 2e                	push   $0x2e
  801927:	e8 c7 f9 ff ff       	call   8012f3 <syscall>
  80192c:	83 c4 18             	add    $0x18,%esp
}
  80192f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801932:	c9                   	leave  
  801933:	c3                   	ret    

00801934 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801937:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193a:	8b 45 08             	mov    0x8(%ebp),%eax
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	52                   	push   %edx
  801944:	50                   	push   %eax
  801945:	6a 2f                	push   $0x2f
  801947:	e8 a7 f9 ff ff       	call   8012f3 <syscall>
  80194c:	83 c4 18             	add    $0x18,%esp
}
  80194f:	c9                   	leave  
  801950:	c3                   	ret    

00801951 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801951:	55                   	push   %ebp
  801952:	89 e5                	mov    %esp,%ebp
  801954:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801957:	8b 55 08             	mov    0x8(%ebp),%edx
  80195a:	89 d0                	mov    %edx,%eax
  80195c:	c1 e0 02             	shl    $0x2,%eax
  80195f:	01 d0                	add    %edx,%eax
  801961:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801968:	01 d0                	add    %edx,%eax
  80196a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801971:	01 d0                	add    %edx,%eax
  801973:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80197a:	01 d0                	add    %edx,%eax
  80197c:	c1 e0 04             	shl    $0x4,%eax
  80197f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801982:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801989:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80198c:	83 ec 0c             	sub    $0xc,%esp
  80198f:	50                   	push   %eax
  801990:	e8 76 fd ff ff       	call   80170b <sys_get_virtual_time>
  801995:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801998:	eb 41                	jmp    8019db <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80199a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80199d:	83 ec 0c             	sub    $0xc,%esp
  8019a0:	50                   	push   %eax
  8019a1:	e8 65 fd ff ff       	call   80170b <sys_get_virtual_time>
  8019a6:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8019a9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019af:	29 c2                	sub    %eax,%edx
  8019b1:	89 d0                	mov    %edx,%eax
  8019b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8019b6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8019b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019bc:	89 d1                	mov    %edx,%ecx
  8019be:	29 c1                	sub    %eax,%ecx
  8019c0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8019c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019c6:	39 c2                	cmp    %eax,%edx
  8019c8:	0f 97 c0             	seta   %al
  8019cb:	0f b6 c0             	movzbl %al,%eax
  8019ce:	29 c1                	sub    %eax,%ecx
  8019d0:	89 c8                	mov    %ecx,%eax
  8019d2:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8019d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8019db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019de:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019e1:	72 b7                	jb     80199a <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8019e3:	90                   	nop
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
  8019e9:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8019ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8019f3:	eb 03                	jmp    8019f8 <busy_wait+0x12>
  8019f5:	ff 45 fc             	incl   -0x4(%ebp)
  8019f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019fb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8019fe:	72 f5                	jb     8019f5 <busy_wait+0xf>
	return i;
  801a00:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801a03:	c9                   	leave  
  801a04:	c3                   	ret    
  801a05:	66 90                	xchg   %ax,%ax
  801a07:	90                   	nop

00801a08 <__udivdi3>:
  801a08:	55                   	push   %ebp
  801a09:	57                   	push   %edi
  801a0a:	56                   	push   %esi
  801a0b:	53                   	push   %ebx
  801a0c:	83 ec 1c             	sub    $0x1c,%esp
  801a0f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a13:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a17:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a1b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a1f:	89 ca                	mov    %ecx,%edx
  801a21:	89 f8                	mov    %edi,%eax
  801a23:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a27:	85 f6                	test   %esi,%esi
  801a29:	75 2d                	jne    801a58 <__udivdi3+0x50>
  801a2b:	39 cf                	cmp    %ecx,%edi
  801a2d:	77 65                	ja     801a94 <__udivdi3+0x8c>
  801a2f:	89 fd                	mov    %edi,%ebp
  801a31:	85 ff                	test   %edi,%edi
  801a33:	75 0b                	jne    801a40 <__udivdi3+0x38>
  801a35:	b8 01 00 00 00       	mov    $0x1,%eax
  801a3a:	31 d2                	xor    %edx,%edx
  801a3c:	f7 f7                	div    %edi
  801a3e:	89 c5                	mov    %eax,%ebp
  801a40:	31 d2                	xor    %edx,%edx
  801a42:	89 c8                	mov    %ecx,%eax
  801a44:	f7 f5                	div    %ebp
  801a46:	89 c1                	mov    %eax,%ecx
  801a48:	89 d8                	mov    %ebx,%eax
  801a4a:	f7 f5                	div    %ebp
  801a4c:	89 cf                	mov    %ecx,%edi
  801a4e:	89 fa                	mov    %edi,%edx
  801a50:	83 c4 1c             	add    $0x1c,%esp
  801a53:	5b                   	pop    %ebx
  801a54:	5e                   	pop    %esi
  801a55:	5f                   	pop    %edi
  801a56:	5d                   	pop    %ebp
  801a57:	c3                   	ret    
  801a58:	39 ce                	cmp    %ecx,%esi
  801a5a:	77 28                	ja     801a84 <__udivdi3+0x7c>
  801a5c:	0f bd fe             	bsr    %esi,%edi
  801a5f:	83 f7 1f             	xor    $0x1f,%edi
  801a62:	75 40                	jne    801aa4 <__udivdi3+0x9c>
  801a64:	39 ce                	cmp    %ecx,%esi
  801a66:	72 0a                	jb     801a72 <__udivdi3+0x6a>
  801a68:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a6c:	0f 87 9e 00 00 00    	ja     801b10 <__udivdi3+0x108>
  801a72:	b8 01 00 00 00       	mov    $0x1,%eax
  801a77:	89 fa                	mov    %edi,%edx
  801a79:	83 c4 1c             	add    $0x1c,%esp
  801a7c:	5b                   	pop    %ebx
  801a7d:	5e                   	pop    %esi
  801a7e:	5f                   	pop    %edi
  801a7f:	5d                   	pop    %ebp
  801a80:	c3                   	ret    
  801a81:	8d 76 00             	lea    0x0(%esi),%esi
  801a84:	31 ff                	xor    %edi,%edi
  801a86:	31 c0                	xor    %eax,%eax
  801a88:	89 fa                	mov    %edi,%edx
  801a8a:	83 c4 1c             	add    $0x1c,%esp
  801a8d:	5b                   	pop    %ebx
  801a8e:	5e                   	pop    %esi
  801a8f:	5f                   	pop    %edi
  801a90:	5d                   	pop    %ebp
  801a91:	c3                   	ret    
  801a92:	66 90                	xchg   %ax,%ax
  801a94:	89 d8                	mov    %ebx,%eax
  801a96:	f7 f7                	div    %edi
  801a98:	31 ff                	xor    %edi,%edi
  801a9a:	89 fa                	mov    %edi,%edx
  801a9c:	83 c4 1c             	add    $0x1c,%esp
  801a9f:	5b                   	pop    %ebx
  801aa0:	5e                   	pop    %esi
  801aa1:	5f                   	pop    %edi
  801aa2:	5d                   	pop    %ebp
  801aa3:	c3                   	ret    
  801aa4:	bd 20 00 00 00       	mov    $0x20,%ebp
  801aa9:	89 eb                	mov    %ebp,%ebx
  801aab:	29 fb                	sub    %edi,%ebx
  801aad:	89 f9                	mov    %edi,%ecx
  801aaf:	d3 e6                	shl    %cl,%esi
  801ab1:	89 c5                	mov    %eax,%ebp
  801ab3:	88 d9                	mov    %bl,%cl
  801ab5:	d3 ed                	shr    %cl,%ebp
  801ab7:	89 e9                	mov    %ebp,%ecx
  801ab9:	09 f1                	or     %esi,%ecx
  801abb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801abf:	89 f9                	mov    %edi,%ecx
  801ac1:	d3 e0                	shl    %cl,%eax
  801ac3:	89 c5                	mov    %eax,%ebp
  801ac5:	89 d6                	mov    %edx,%esi
  801ac7:	88 d9                	mov    %bl,%cl
  801ac9:	d3 ee                	shr    %cl,%esi
  801acb:	89 f9                	mov    %edi,%ecx
  801acd:	d3 e2                	shl    %cl,%edx
  801acf:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ad3:	88 d9                	mov    %bl,%cl
  801ad5:	d3 e8                	shr    %cl,%eax
  801ad7:	09 c2                	or     %eax,%edx
  801ad9:	89 d0                	mov    %edx,%eax
  801adb:	89 f2                	mov    %esi,%edx
  801add:	f7 74 24 0c          	divl   0xc(%esp)
  801ae1:	89 d6                	mov    %edx,%esi
  801ae3:	89 c3                	mov    %eax,%ebx
  801ae5:	f7 e5                	mul    %ebp
  801ae7:	39 d6                	cmp    %edx,%esi
  801ae9:	72 19                	jb     801b04 <__udivdi3+0xfc>
  801aeb:	74 0b                	je     801af8 <__udivdi3+0xf0>
  801aed:	89 d8                	mov    %ebx,%eax
  801aef:	31 ff                	xor    %edi,%edi
  801af1:	e9 58 ff ff ff       	jmp    801a4e <__udivdi3+0x46>
  801af6:	66 90                	xchg   %ax,%ax
  801af8:	8b 54 24 08          	mov    0x8(%esp),%edx
  801afc:	89 f9                	mov    %edi,%ecx
  801afe:	d3 e2                	shl    %cl,%edx
  801b00:	39 c2                	cmp    %eax,%edx
  801b02:	73 e9                	jae    801aed <__udivdi3+0xe5>
  801b04:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b07:	31 ff                	xor    %edi,%edi
  801b09:	e9 40 ff ff ff       	jmp    801a4e <__udivdi3+0x46>
  801b0e:	66 90                	xchg   %ax,%ax
  801b10:	31 c0                	xor    %eax,%eax
  801b12:	e9 37 ff ff ff       	jmp    801a4e <__udivdi3+0x46>
  801b17:	90                   	nop

00801b18 <__umoddi3>:
  801b18:	55                   	push   %ebp
  801b19:	57                   	push   %edi
  801b1a:	56                   	push   %esi
  801b1b:	53                   	push   %ebx
  801b1c:	83 ec 1c             	sub    $0x1c,%esp
  801b1f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b23:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b27:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b2b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b2f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b33:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b37:	89 f3                	mov    %esi,%ebx
  801b39:	89 fa                	mov    %edi,%edx
  801b3b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b3f:	89 34 24             	mov    %esi,(%esp)
  801b42:	85 c0                	test   %eax,%eax
  801b44:	75 1a                	jne    801b60 <__umoddi3+0x48>
  801b46:	39 f7                	cmp    %esi,%edi
  801b48:	0f 86 a2 00 00 00    	jbe    801bf0 <__umoddi3+0xd8>
  801b4e:	89 c8                	mov    %ecx,%eax
  801b50:	89 f2                	mov    %esi,%edx
  801b52:	f7 f7                	div    %edi
  801b54:	89 d0                	mov    %edx,%eax
  801b56:	31 d2                	xor    %edx,%edx
  801b58:	83 c4 1c             	add    $0x1c,%esp
  801b5b:	5b                   	pop    %ebx
  801b5c:	5e                   	pop    %esi
  801b5d:	5f                   	pop    %edi
  801b5e:	5d                   	pop    %ebp
  801b5f:	c3                   	ret    
  801b60:	39 f0                	cmp    %esi,%eax
  801b62:	0f 87 ac 00 00 00    	ja     801c14 <__umoddi3+0xfc>
  801b68:	0f bd e8             	bsr    %eax,%ebp
  801b6b:	83 f5 1f             	xor    $0x1f,%ebp
  801b6e:	0f 84 ac 00 00 00    	je     801c20 <__umoddi3+0x108>
  801b74:	bf 20 00 00 00       	mov    $0x20,%edi
  801b79:	29 ef                	sub    %ebp,%edi
  801b7b:	89 fe                	mov    %edi,%esi
  801b7d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b81:	89 e9                	mov    %ebp,%ecx
  801b83:	d3 e0                	shl    %cl,%eax
  801b85:	89 d7                	mov    %edx,%edi
  801b87:	89 f1                	mov    %esi,%ecx
  801b89:	d3 ef                	shr    %cl,%edi
  801b8b:	09 c7                	or     %eax,%edi
  801b8d:	89 e9                	mov    %ebp,%ecx
  801b8f:	d3 e2                	shl    %cl,%edx
  801b91:	89 14 24             	mov    %edx,(%esp)
  801b94:	89 d8                	mov    %ebx,%eax
  801b96:	d3 e0                	shl    %cl,%eax
  801b98:	89 c2                	mov    %eax,%edx
  801b9a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b9e:	d3 e0                	shl    %cl,%eax
  801ba0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ba4:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ba8:	89 f1                	mov    %esi,%ecx
  801baa:	d3 e8                	shr    %cl,%eax
  801bac:	09 d0                	or     %edx,%eax
  801bae:	d3 eb                	shr    %cl,%ebx
  801bb0:	89 da                	mov    %ebx,%edx
  801bb2:	f7 f7                	div    %edi
  801bb4:	89 d3                	mov    %edx,%ebx
  801bb6:	f7 24 24             	mull   (%esp)
  801bb9:	89 c6                	mov    %eax,%esi
  801bbb:	89 d1                	mov    %edx,%ecx
  801bbd:	39 d3                	cmp    %edx,%ebx
  801bbf:	0f 82 87 00 00 00    	jb     801c4c <__umoddi3+0x134>
  801bc5:	0f 84 91 00 00 00    	je     801c5c <__umoddi3+0x144>
  801bcb:	8b 54 24 04          	mov    0x4(%esp),%edx
  801bcf:	29 f2                	sub    %esi,%edx
  801bd1:	19 cb                	sbb    %ecx,%ebx
  801bd3:	89 d8                	mov    %ebx,%eax
  801bd5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801bd9:	d3 e0                	shl    %cl,%eax
  801bdb:	89 e9                	mov    %ebp,%ecx
  801bdd:	d3 ea                	shr    %cl,%edx
  801bdf:	09 d0                	or     %edx,%eax
  801be1:	89 e9                	mov    %ebp,%ecx
  801be3:	d3 eb                	shr    %cl,%ebx
  801be5:	89 da                	mov    %ebx,%edx
  801be7:	83 c4 1c             	add    $0x1c,%esp
  801bea:	5b                   	pop    %ebx
  801beb:	5e                   	pop    %esi
  801bec:	5f                   	pop    %edi
  801bed:	5d                   	pop    %ebp
  801bee:	c3                   	ret    
  801bef:	90                   	nop
  801bf0:	89 fd                	mov    %edi,%ebp
  801bf2:	85 ff                	test   %edi,%edi
  801bf4:	75 0b                	jne    801c01 <__umoddi3+0xe9>
  801bf6:	b8 01 00 00 00       	mov    $0x1,%eax
  801bfb:	31 d2                	xor    %edx,%edx
  801bfd:	f7 f7                	div    %edi
  801bff:	89 c5                	mov    %eax,%ebp
  801c01:	89 f0                	mov    %esi,%eax
  801c03:	31 d2                	xor    %edx,%edx
  801c05:	f7 f5                	div    %ebp
  801c07:	89 c8                	mov    %ecx,%eax
  801c09:	f7 f5                	div    %ebp
  801c0b:	89 d0                	mov    %edx,%eax
  801c0d:	e9 44 ff ff ff       	jmp    801b56 <__umoddi3+0x3e>
  801c12:	66 90                	xchg   %ax,%ax
  801c14:	89 c8                	mov    %ecx,%eax
  801c16:	89 f2                	mov    %esi,%edx
  801c18:	83 c4 1c             	add    $0x1c,%esp
  801c1b:	5b                   	pop    %ebx
  801c1c:	5e                   	pop    %esi
  801c1d:	5f                   	pop    %edi
  801c1e:	5d                   	pop    %ebp
  801c1f:	c3                   	ret    
  801c20:	3b 04 24             	cmp    (%esp),%eax
  801c23:	72 06                	jb     801c2b <__umoddi3+0x113>
  801c25:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c29:	77 0f                	ja     801c3a <__umoddi3+0x122>
  801c2b:	89 f2                	mov    %esi,%edx
  801c2d:	29 f9                	sub    %edi,%ecx
  801c2f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c33:	89 14 24             	mov    %edx,(%esp)
  801c36:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c3a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c3e:	8b 14 24             	mov    (%esp),%edx
  801c41:	83 c4 1c             	add    $0x1c,%esp
  801c44:	5b                   	pop    %ebx
  801c45:	5e                   	pop    %esi
  801c46:	5f                   	pop    %edi
  801c47:	5d                   	pop    %ebp
  801c48:	c3                   	ret    
  801c49:	8d 76 00             	lea    0x0(%esi),%esi
  801c4c:	2b 04 24             	sub    (%esp),%eax
  801c4f:	19 fa                	sbb    %edi,%edx
  801c51:	89 d1                	mov    %edx,%ecx
  801c53:	89 c6                	mov    %eax,%esi
  801c55:	e9 71 ff ff ff       	jmp    801bcb <__umoddi3+0xb3>
  801c5a:	66 90                	xchg   %ax,%ax
  801c5c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c60:	72 ea                	jb     801c4c <__umoddi3+0x134>
  801c62:	89 d9                	mov    %ebx,%ecx
  801c64:	e9 62 ff ff ff       	jmp    801bcb <__umoddi3+0xb3>
