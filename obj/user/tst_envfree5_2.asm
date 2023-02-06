
obj/user/tst_envfree5_2:     file format elf32-i386


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
  800031:	e8 4b 01 00 00       	call   800181 <libmain>
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
	// Testing removing the shared variables
	// Testing scenario 5_2: Kill programs have already shared variables and they free it [include scenario 5_1]
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 00 33 80 00       	push   $0x803300
  80004a:	e8 17 16 00 00       	call   801666 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 c6 18 00 00       	call   801929 <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 5e 19 00 00       	call   8019c9 <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 10 33 80 00       	push   $0x803310
  800079:	e8 f3 04 00 00       	call   800571 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr4", 2000,100, 50);
  800081:	6a 32                	push   $0x32
  800083:	6a 64                	push   $0x64
  800085:	68 d0 07 00 00       	push   $0x7d0
  80008a:	68 43 33 80 00       	push   $0x803343
  80008f:	e8 07 1b 00 00       	call   801b9b <sys_create_env>
  800094:	83 c4 10             	add    $0x10,%esp
  800097:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int32 envIdProcessB = sys_create_env("ef_tshr5", 2000,100, 50);
  80009a:	6a 32                	push   $0x32
  80009c:	6a 64                	push   $0x64
  80009e:	68 d0 07 00 00       	push   $0x7d0
  8000a3:	68 4c 33 80 00       	push   $0x80334c
  8000a8:	e8 ee 1a 00 00       	call   801b9b <sys_create_env>
  8000ad:	83 c4 10             	add    $0x10,%esp
  8000b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	sys_run_env(envIdProcessA);
  8000b3:	83 ec 0c             	sub    $0xc,%esp
  8000b6:	ff 75 e8             	pushl  -0x18(%ebp)
  8000b9:	e8 fb 1a 00 00       	call   801bb9 <sys_run_env>
  8000be:	83 c4 10             	add    $0x10,%esp
	env_sleep(15000);
  8000c1:	83 ec 0c             	sub    $0xc,%esp
  8000c4:	68 98 3a 00 00       	push   $0x3a98
  8000c9:	e8 12 2f 00 00       	call   802fe0 <env_sleep>
  8000ce:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000d7:	e8 dd 1a 00 00       	call   801bb9 <sys_run_env>
  8000dc:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  8000df:	90                   	nop
  8000e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000e3:	8b 00                	mov    (%eax),%eax
  8000e5:	83 f8 02             	cmp    $0x2,%eax
  8000e8:	75 f6                	jne    8000e0 <_main+0xa8>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000ea:	e8 3a 18 00 00       	call   801929 <sys_calculate_free_frames>
  8000ef:	83 ec 08             	sub    $0x8,%esp
  8000f2:	50                   	push   %eax
  8000f3:	68 58 33 80 00       	push   $0x803358
  8000f8:	e8 74 04 00 00       	call   800571 <cprintf>
  8000fd:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  800100:	83 ec 0c             	sub    $0xc,%esp
  800103:	ff 75 e8             	pushl  -0x18(%ebp)
  800106:	e8 ca 1a 00 00       	call   801bd5 <sys_destroy_env>
  80010b:	83 c4 10             	add    $0x10,%esp
	sys_destroy_env(envIdProcessB);
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	ff 75 e4             	pushl  -0x1c(%ebp)
  800114:	e8 bc 1a 00 00       	call   801bd5 <sys_destroy_env>
  800119:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  80011c:	e8 08 18 00 00       	call   801929 <sys_calculate_free_frames>
  800121:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800124:	e8 a0 18 00 00       	call   8019c9 <sys_pf_calculate_allocated_pages>
  800129:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  80012c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80012f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800132:	74 27                	je     80015b <_main+0x123>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  800134:	83 ec 08             	sub    $0x8,%esp
  800137:	ff 75 e0             	pushl  -0x20(%ebp)
  80013a:	68 8c 33 80 00       	push   $0x80338c
  80013f:	e8 2d 04 00 00       	call   800571 <cprintf>
  800144:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  800147:	83 ec 04             	sub    $0x4,%esp
  80014a:	68 dc 33 80 00       	push   $0x8033dc
  80014f:	6a 23                	push   $0x23
  800151:	68 12 34 80 00       	push   $0x803412
  800156:	e8 62 01 00 00       	call   8002bd <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80015b:	83 ec 08             	sub    $0x8,%esp
  80015e:	ff 75 e0             	pushl  -0x20(%ebp)
  800161:	68 28 34 80 00       	push   $0x803428
  800166:	e8 06 04 00 00       	call   800571 <cprintf>
  80016b:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 5_2 for envfree completed successfully.\n");
  80016e:	83 ec 0c             	sub    $0xc,%esp
  800171:	68 88 34 80 00       	push   $0x803488
  800176:	e8 f6 03 00 00       	call   800571 <cprintf>
  80017b:	83 c4 10             	add    $0x10,%esp
	return;
  80017e:	90                   	nop
}
  80017f:	c9                   	leave  
  800180:	c3                   	ret    

00800181 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800181:	55                   	push   %ebp
  800182:	89 e5                	mov    %esp,%ebp
  800184:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800187:	e8 7d 1a 00 00       	call   801c09 <sys_getenvindex>
  80018c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80018f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800192:	89 d0                	mov    %edx,%eax
  800194:	c1 e0 03             	shl    $0x3,%eax
  800197:	01 d0                	add    %edx,%eax
  800199:	01 c0                	add    %eax,%eax
  80019b:	01 d0                	add    %edx,%eax
  80019d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001a4:	01 d0                	add    %edx,%eax
  8001a6:	c1 e0 04             	shl    $0x4,%eax
  8001a9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001ae:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001b3:	a1 20 40 80 00       	mov    0x804020,%eax
  8001b8:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001be:	84 c0                	test   %al,%al
  8001c0:	74 0f                	je     8001d1 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001c2:	a1 20 40 80 00       	mov    0x804020,%eax
  8001c7:	05 5c 05 00 00       	add    $0x55c,%eax
  8001cc:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001d5:	7e 0a                	jle    8001e1 <libmain+0x60>
		binaryname = argv[0];
  8001d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001da:	8b 00                	mov    (%eax),%eax
  8001dc:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001e1:	83 ec 08             	sub    $0x8,%esp
  8001e4:	ff 75 0c             	pushl  0xc(%ebp)
  8001e7:	ff 75 08             	pushl  0x8(%ebp)
  8001ea:	e8 49 fe ff ff       	call   800038 <_main>
  8001ef:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001f2:	e8 1f 18 00 00       	call   801a16 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001f7:	83 ec 0c             	sub    $0xc,%esp
  8001fa:	68 ec 34 80 00       	push   $0x8034ec
  8001ff:	e8 6d 03 00 00       	call   800571 <cprintf>
  800204:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800207:	a1 20 40 80 00       	mov    0x804020,%eax
  80020c:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800212:	a1 20 40 80 00       	mov    0x804020,%eax
  800217:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80021d:	83 ec 04             	sub    $0x4,%esp
  800220:	52                   	push   %edx
  800221:	50                   	push   %eax
  800222:	68 14 35 80 00       	push   $0x803514
  800227:	e8 45 03 00 00       	call   800571 <cprintf>
  80022c:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80022f:	a1 20 40 80 00       	mov    0x804020,%eax
  800234:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80023a:	a1 20 40 80 00       	mov    0x804020,%eax
  80023f:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800245:	a1 20 40 80 00       	mov    0x804020,%eax
  80024a:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800250:	51                   	push   %ecx
  800251:	52                   	push   %edx
  800252:	50                   	push   %eax
  800253:	68 3c 35 80 00       	push   $0x80353c
  800258:	e8 14 03 00 00       	call   800571 <cprintf>
  80025d:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800260:	a1 20 40 80 00       	mov    0x804020,%eax
  800265:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80026b:	83 ec 08             	sub    $0x8,%esp
  80026e:	50                   	push   %eax
  80026f:	68 94 35 80 00       	push   $0x803594
  800274:	e8 f8 02 00 00       	call   800571 <cprintf>
  800279:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80027c:	83 ec 0c             	sub    $0xc,%esp
  80027f:	68 ec 34 80 00       	push   $0x8034ec
  800284:	e8 e8 02 00 00       	call   800571 <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80028c:	e8 9f 17 00 00       	call   801a30 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800291:	e8 19 00 00 00       	call   8002af <exit>
}
  800296:	90                   	nop
  800297:	c9                   	leave  
  800298:	c3                   	ret    

00800299 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800299:	55                   	push   %ebp
  80029a:	89 e5                	mov    %esp,%ebp
  80029c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80029f:	83 ec 0c             	sub    $0xc,%esp
  8002a2:	6a 00                	push   $0x0
  8002a4:	e8 2c 19 00 00       	call   801bd5 <sys_destroy_env>
  8002a9:	83 c4 10             	add    $0x10,%esp
}
  8002ac:	90                   	nop
  8002ad:	c9                   	leave  
  8002ae:	c3                   	ret    

008002af <exit>:

void
exit(void)
{
  8002af:	55                   	push   %ebp
  8002b0:	89 e5                	mov    %esp,%ebp
  8002b2:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002b5:	e8 81 19 00 00       	call   801c3b <sys_exit_env>
}
  8002ba:	90                   	nop
  8002bb:	c9                   	leave  
  8002bc:	c3                   	ret    

008002bd <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002bd:	55                   	push   %ebp
  8002be:	89 e5                	mov    %esp,%ebp
  8002c0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002c3:	8d 45 10             	lea    0x10(%ebp),%eax
  8002c6:	83 c0 04             	add    $0x4,%eax
  8002c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002cc:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002d1:	85 c0                	test   %eax,%eax
  8002d3:	74 16                	je     8002eb <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002d5:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002da:	83 ec 08             	sub    $0x8,%esp
  8002dd:	50                   	push   %eax
  8002de:	68 a8 35 80 00       	push   $0x8035a8
  8002e3:	e8 89 02 00 00       	call   800571 <cprintf>
  8002e8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002eb:	a1 00 40 80 00       	mov    0x804000,%eax
  8002f0:	ff 75 0c             	pushl  0xc(%ebp)
  8002f3:	ff 75 08             	pushl  0x8(%ebp)
  8002f6:	50                   	push   %eax
  8002f7:	68 ad 35 80 00       	push   $0x8035ad
  8002fc:	e8 70 02 00 00       	call   800571 <cprintf>
  800301:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800304:	8b 45 10             	mov    0x10(%ebp),%eax
  800307:	83 ec 08             	sub    $0x8,%esp
  80030a:	ff 75 f4             	pushl  -0xc(%ebp)
  80030d:	50                   	push   %eax
  80030e:	e8 f3 01 00 00       	call   800506 <vcprintf>
  800313:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800316:	83 ec 08             	sub    $0x8,%esp
  800319:	6a 00                	push   $0x0
  80031b:	68 c9 35 80 00       	push   $0x8035c9
  800320:	e8 e1 01 00 00       	call   800506 <vcprintf>
  800325:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800328:	e8 82 ff ff ff       	call   8002af <exit>

	// should not return here
	while (1) ;
  80032d:	eb fe                	jmp    80032d <_panic+0x70>

0080032f <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80032f:	55                   	push   %ebp
  800330:	89 e5                	mov    %esp,%ebp
  800332:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800335:	a1 20 40 80 00       	mov    0x804020,%eax
  80033a:	8b 50 74             	mov    0x74(%eax),%edx
  80033d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800340:	39 c2                	cmp    %eax,%edx
  800342:	74 14                	je     800358 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800344:	83 ec 04             	sub    $0x4,%esp
  800347:	68 cc 35 80 00       	push   $0x8035cc
  80034c:	6a 26                	push   $0x26
  80034e:	68 18 36 80 00       	push   $0x803618
  800353:	e8 65 ff ff ff       	call   8002bd <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800358:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80035f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800366:	e9 c2 00 00 00       	jmp    80042d <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80036b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80036e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800375:	8b 45 08             	mov    0x8(%ebp),%eax
  800378:	01 d0                	add    %edx,%eax
  80037a:	8b 00                	mov    (%eax),%eax
  80037c:	85 c0                	test   %eax,%eax
  80037e:	75 08                	jne    800388 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800380:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800383:	e9 a2 00 00 00       	jmp    80042a <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800388:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80038f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800396:	eb 69                	jmp    800401 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800398:	a1 20 40 80 00       	mov    0x804020,%eax
  80039d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003a3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003a6:	89 d0                	mov    %edx,%eax
  8003a8:	01 c0                	add    %eax,%eax
  8003aa:	01 d0                	add    %edx,%eax
  8003ac:	c1 e0 03             	shl    $0x3,%eax
  8003af:	01 c8                	add    %ecx,%eax
  8003b1:	8a 40 04             	mov    0x4(%eax),%al
  8003b4:	84 c0                	test   %al,%al
  8003b6:	75 46                	jne    8003fe <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003b8:	a1 20 40 80 00       	mov    0x804020,%eax
  8003bd:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003c3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003c6:	89 d0                	mov    %edx,%eax
  8003c8:	01 c0                	add    %eax,%eax
  8003ca:	01 d0                	add    %edx,%eax
  8003cc:	c1 e0 03             	shl    $0x3,%eax
  8003cf:	01 c8                	add    %ecx,%eax
  8003d1:	8b 00                	mov    (%eax),%eax
  8003d3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003d9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003de:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ed:	01 c8                	add    %ecx,%eax
  8003ef:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003f1:	39 c2                	cmp    %eax,%edx
  8003f3:	75 09                	jne    8003fe <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003f5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003fc:	eb 12                	jmp    800410 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003fe:	ff 45 e8             	incl   -0x18(%ebp)
  800401:	a1 20 40 80 00       	mov    0x804020,%eax
  800406:	8b 50 74             	mov    0x74(%eax),%edx
  800409:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80040c:	39 c2                	cmp    %eax,%edx
  80040e:	77 88                	ja     800398 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800410:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800414:	75 14                	jne    80042a <CheckWSWithoutLastIndex+0xfb>
			panic(
  800416:	83 ec 04             	sub    $0x4,%esp
  800419:	68 24 36 80 00       	push   $0x803624
  80041e:	6a 3a                	push   $0x3a
  800420:	68 18 36 80 00       	push   $0x803618
  800425:	e8 93 fe ff ff       	call   8002bd <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80042a:	ff 45 f0             	incl   -0x10(%ebp)
  80042d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800430:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800433:	0f 8c 32 ff ff ff    	jl     80036b <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800439:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800440:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800447:	eb 26                	jmp    80046f <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800449:	a1 20 40 80 00       	mov    0x804020,%eax
  80044e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800454:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800457:	89 d0                	mov    %edx,%eax
  800459:	01 c0                	add    %eax,%eax
  80045b:	01 d0                	add    %edx,%eax
  80045d:	c1 e0 03             	shl    $0x3,%eax
  800460:	01 c8                	add    %ecx,%eax
  800462:	8a 40 04             	mov    0x4(%eax),%al
  800465:	3c 01                	cmp    $0x1,%al
  800467:	75 03                	jne    80046c <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800469:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80046c:	ff 45 e0             	incl   -0x20(%ebp)
  80046f:	a1 20 40 80 00       	mov    0x804020,%eax
  800474:	8b 50 74             	mov    0x74(%eax),%edx
  800477:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80047a:	39 c2                	cmp    %eax,%edx
  80047c:	77 cb                	ja     800449 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80047e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800481:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800484:	74 14                	je     80049a <CheckWSWithoutLastIndex+0x16b>
		panic(
  800486:	83 ec 04             	sub    $0x4,%esp
  800489:	68 78 36 80 00       	push   $0x803678
  80048e:	6a 44                	push   $0x44
  800490:	68 18 36 80 00       	push   $0x803618
  800495:	e8 23 fe ff ff       	call   8002bd <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80049a:	90                   	nop
  80049b:	c9                   	leave  
  80049c:	c3                   	ret    

0080049d <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80049d:	55                   	push   %ebp
  80049e:	89 e5                	mov    %esp,%ebp
  8004a0:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a6:	8b 00                	mov    (%eax),%eax
  8004a8:	8d 48 01             	lea    0x1(%eax),%ecx
  8004ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ae:	89 0a                	mov    %ecx,(%edx)
  8004b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8004b3:	88 d1                	mov    %dl,%cl
  8004b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b8:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004bf:	8b 00                	mov    (%eax),%eax
  8004c1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004c6:	75 2c                	jne    8004f4 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004c8:	a0 24 40 80 00       	mov    0x804024,%al
  8004cd:	0f b6 c0             	movzbl %al,%eax
  8004d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004d3:	8b 12                	mov    (%edx),%edx
  8004d5:	89 d1                	mov    %edx,%ecx
  8004d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004da:	83 c2 08             	add    $0x8,%edx
  8004dd:	83 ec 04             	sub    $0x4,%esp
  8004e0:	50                   	push   %eax
  8004e1:	51                   	push   %ecx
  8004e2:	52                   	push   %edx
  8004e3:	e8 80 13 00 00       	call   801868 <sys_cputs>
  8004e8:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f7:	8b 40 04             	mov    0x4(%eax),%eax
  8004fa:	8d 50 01             	lea    0x1(%eax),%edx
  8004fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800500:	89 50 04             	mov    %edx,0x4(%eax)
}
  800503:	90                   	nop
  800504:	c9                   	leave  
  800505:	c3                   	ret    

00800506 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800506:	55                   	push   %ebp
  800507:	89 e5                	mov    %esp,%ebp
  800509:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80050f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800516:	00 00 00 
	b.cnt = 0;
  800519:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800520:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800523:	ff 75 0c             	pushl  0xc(%ebp)
  800526:	ff 75 08             	pushl  0x8(%ebp)
  800529:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80052f:	50                   	push   %eax
  800530:	68 9d 04 80 00       	push   $0x80049d
  800535:	e8 11 02 00 00       	call   80074b <vprintfmt>
  80053a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80053d:	a0 24 40 80 00       	mov    0x804024,%al
  800542:	0f b6 c0             	movzbl %al,%eax
  800545:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80054b:	83 ec 04             	sub    $0x4,%esp
  80054e:	50                   	push   %eax
  80054f:	52                   	push   %edx
  800550:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800556:	83 c0 08             	add    $0x8,%eax
  800559:	50                   	push   %eax
  80055a:	e8 09 13 00 00       	call   801868 <sys_cputs>
  80055f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800562:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800569:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80056f:	c9                   	leave  
  800570:	c3                   	ret    

00800571 <cprintf>:

int cprintf(const char *fmt, ...) {
  800571:	55                   	push   %ebp
  800572:	89 e5                	mov    %esp,%ebp
  800574:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800577:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80057e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800581:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800584:	8b 45 08             	mov    0x8(%ebp),%eax
  800587:	83 ec 08             	sub    $0x8,%esp
  80058a:	ff 75 f4             	pushl  -0xc(%ebp)
  80058d:	50                   	push   %eax
  80058e:	e8 73 ff ff ff       	call   800506 <vcprintf>
  800593:	83 c4 10             	add    $0x10,%esp
  800596:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800599:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80059c:	c9                   	leave  
  80059d:	c3                   	ret    

0080059e <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80059e:	55                   	push   %ebp
  80059f:	89 e5                	mov    %esp,%ebp
  8005a1:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005a4:	e8 6d 14 00 00       	call   801a16 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005a9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005af:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b2:	83 ec 08             	sub    $0x8,%esp
  8005b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8005b8:	50                   	push   %eax
  8005b9:	e8 48 ff ff ff       	call   800506 <vcprintf>
  8005be:	83 c4 10             	add    $0x10,%esp
  8005c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005c4:	e8 67 14 00 00       	call   801a30 <sys_enable_interrupt>
	return cnt;
  8005c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005cc:	c9                   	leave  
  8005cd:	c3                   	ret    

008005ce <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005ce:	55                   	push   %ebp
  8005cf:	89 e5                	mov    %esp,%ebp
  8005d1:	53                   	push   %ebx
  8005d2:	83 ec 14             	sub    $0x14,%esp
  8005d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8005d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005db:	8b 45 14             	mov    0x14(%ebp),%eax
  8005de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005e1:	8b 45 18             	mov    0x18(%ebp),%eax
  8005e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ec:	77 55                	ja     800643 <printnum+0x75>
  8005ee:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005f1:	72 05                	jb     8005f8 <printnum+0x2a>
  8005f3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005f6:	77 4b                	ja     800643 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005f8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005fb:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005fe:	8b 45 18             	mov    0x18(%ebp),%eax
  800601:	ba 00 00 00 00       	mov    $0x0,%edx
  800606:	52                   	push   %edx
  800607:	50                   	push   %eax
  800608:	ff 75 f4             	pushl  -0xc(%ebp)
  80060b:	ff 75 f0             	pushl  -0x10(%ebp)
  80060e:	e8 81 2a 00 00       	call   803094 <__udivdi3>
  800613:	83 c4 10             	add    $0x10,%esp
  800616:	83 ec 04             	sub    $0x4,%esp
  800619:	ff 75 20             	pushl  0x20(%ebp)
  80061c:	53                   	push   %ebx
  80061d:	ff 75 18             	pushl  0x18(%ebp)
  800620:	52                   	push   %edx
  800621:	50                   	push   %eax
  800622:	ff 75 0c             	pushl  0xc(%ebp)
  800625:	ff 75 08             	pushl  0x8(%ebp)
  800628:	e8 a1 ff ff ff       	call   8005ce <printnum>
  80062d:	83 c4 20             	add    $0x20,%esp
  800630:	eb 1a                	jmp    80064c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800632:	83 ec 08             	sub    $0x8,%esp
  800635:	ff 75 0c             	pushl  0xc(%ebp)
  800638:	ff 75 20             	pushl  0x20(%ebp)
  80063b:	8b 45 08             	mov    0x8(%ebp),%eax
  80063e:	ff d0                	call   *%eax
  800640:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800643:	ff 4d 1c             	decl   0x1c(%ebp)
  800646:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80064a:	7f e6                	jg     800632 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80064c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80064f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800654:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800657:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80065a:	53                   	push   %ebx
  80065b:	51                   	push   %ecx
  80065c:	52                   	push   %edx
  80065d:	50                   	push   %eax
  80065e:	e8 41 2b 00 00       	call   8031a4 <__umoddi3>
  800663:	83 c4 10             	add    $0x10,%esp
  800666:	05 f4 38 80 00       	add    $0x8038f4,%eax
  80066b:	8a 00                	mov    (%eax),%al
  80066d:	0f be c0             	movsbl %al,%eax
  800670:	83 ec 08             	sub    $0x8,%esp
  800673:	ff 75 0c             	pushl  0xc(%ebp)
  800676:	50                   	push   %eax
  800677:	8b 45 08             	mov    0x8(%ebp),%eax
  80067a:	ff d0                	call   *%eax
  80067c:	83 c4 10             	add    $0x10,%esp
}
  80067f:	90                   	nop
  800680:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800683:	c9                   	leave  
  800684:	c3                   	ret    

00800685 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800685:	55                   	push   %ebp
  800686:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800688:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80068c:	7e 1c                	jle    8006aa <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80068e:	8b 45 08             	mov    0x8(%ebp),%eax
  800691:	8b 00                	mov    (%eax),%eax
  800693:	8d 50 08             	lea    0x8(%eax),%edx
  800696:	8b 45 08             	mov    0x8(%ebp),%eax
  800699:	89 10                	mov    %edx,(%eax)
  80069b:	8b 45 08             	mov    0x8(%ebp),%eax
  80069e:	8b 00                	mov    (%eax),%eax
  8006a0:	83 e8 08             	sub    $0x8,%eax
  8006a3:	8b 50 04             	mov    0x4(%eax),%edx
  8006a6:	8b 00                	mov    (%eax),%eax
  8006a8:	eb 40                	jmp    8006ea <getuint+0x65>
	else if (lflag)
  8006aa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006ae:	74 1e                	je     8006ce <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b3:	8b 00                	mov    (%eax),%eax
  8006b5:	8d 50 04             	lea    0x4(%eax),%edx
  8006b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bb:	89 10                	mov    %edx,(%eax)
  8006bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c0:	8b 00                	mov    (%eax),%eax
  8006c2:	83 e8 04             	sub    $0x4,%eax
  8006c5:	8b 00                	mov    (%eax),%eax
  8006c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8006cc:	eb 1c                	jmp    8006ea <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d1:	8b 00                	mov    (%eax),%eax
  8006d3:	8d 50 04             	lea    0x4(%eax),%edx
  8006d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d9:	89 10                	mov    %edx,(%eax)
  8006db:	8b 45 08             	mov    0x8(%ebp),%eax
  8006de:	8b 00                	mov    (%eax),%eax
  8006e0:	83 e8 04             	sub    $0x4,%eax
  8006e3:	8b 00                	mov    (%eax),%eax
  8006e5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006ea:	5d                   	pop    %ebp
  8006eb:	c3                   	ret    

008006ec <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006ec:	55                   	push   %ebp
  8006ed:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006ef:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006f3:	7e 1c                	jle    800711 <getint+0x25>
		return va_arg(*ap, long long);
  8006f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f8:	8b 00                	mov    (%eax),%eax
  8006fa:	8d 50 08             	lea    0x8(%eax),%edx
  8006fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800700:	89 10                	mov    %edx,(%eax)
  800702:	8b 45 08             	mov    0x8(%ebp),%eax
  800705:	8b 00                	mov    (%eax),%eax
  800707:	83 e8 08             	sub    $0x8,%eax
  80070a:	8b 50 04             	mov    0x4(%eax),%edx
  80070d:	8b 00                	mov    (%eax),%eax
  80070f:	eb 38                	jmp    800749 <getint+0x5d>
	else if (lflag)
  800711:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800715:	74 1a                	je     800731 <getint+0x45>
		return va_arg(*ap, long);
  800717:	8b 45 08             	mov    0x8(%ebp),%eax
  80071a:	8b 00                	mov    (%eax),%eax
  80071c:	8d 50 04             	lea    0x4(%eax),%edx
  80071f:	8b 45 08             	mov    0x8(%ebp),%eax
  800722:	89 10                	mov    %edx,(%eax)
  800724:	8b 45 08             	mov    0x8(%ebp),%eax
  800727:	8b 00                	mov    (%eax),%eax
  800729:	83 e8 04             	sub    $0x4,%eax
  80072c:	8b 00                	mov    (%eax),%eax
  80072e:	99                   	cltd   
  80072f:	eb 18                	jmp    800749 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800731:	8b 45 08             	mov    0x8(%ebp),%eax
  800734:	8b 00                	mov    (%eax),%eax
  800736:	8d 50 04             	lea    0x4(%eax),%edx
  800739:	8b 45 08             	mov    0x8(%ebp),%eax
  80073c:	89 10                	mov    %edx,(%eax)
  80073e:	8b 45 08             	mov    0x8(%ebp),%eax
  800741:	8b 00                	mov    (%eax),%eax
  800743:	83 e8 04             	sub    $0x4,%eax
  800746:	8b 00                	mov    (%eax),%eax
  800748:	99                   	cltd   
}
  800749:	5d                   	pop    %ebp
  80074a:	c3                   	ret    

0080074b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80074b:	55                   	push   %ebp
  80074c:	89 e5                	mov    %esp,%ebp
  80074e:	56                   	push   %esi
  80074f:	53                   	push   %ebx
  800750:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800753:	eb 17                	jmp    80076c <vprintfmt+0x21>
			if (ch == '\0')
  800755:	85 db                	test   %ebx,%ebx
  800757:	0f 84 af 03 00 00    	je     800b0c <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80075d:	83 ec 08             	sub    $0x8,%esp
  800760:	ff 75 0c             	pushl  0xc(%ebp)
  800763:	53                   	push   %ebx
  800764:	8b 45 08             	mov    0x8(%ebp),%eax
  800767:	ff d0                	call   *%eax
  800769:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80076c:	8b 45 10             	mov    0x10(%ebp),%eax
  80076f:	8d 50 01             	lea    0x1(%eax),%edx
  800772:	89 55 10             	mov    %edx,0x10(%ebp)
  800775:	8a 00                	mov    (%eax),%al
  800777:	0f b6 d8             	movzbl %al,%ebx
  80077a:	83 fb 25             	cmp    $0x25,%ebx
  80077d:	75 d6                	jne    800755 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80077f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800783:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80078a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800791:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800798:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80079f:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a2:	8d 50 01             	lea    0x1(%eax),%edx
  8007a5:	89 55 10             	mov    %edx,0x10(%ebp)
  8007a8:	8a 00                	mov    (%eax),%al
  8007aa:	0f b6 d8             	movzbl %al,%ebx
  8007ad:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007b0:	83 f8 55             	cmp    $0x55,%eax
  8007b3:	0f 87 2b 03 00 00    	ja     800ae4 <vprintfmt+0x399>
  8007b9:	8b 04 85 18 39 80 00 	mov    0x803918(,%eax,4),%eax
  8007c0:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007c2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007c6:	eb d7                	jmp    80079f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007c8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007cc:	eb d1                	jmp    80079f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007ce:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007d5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007d8:	89 d0                	mov    %edx,%eax
  8007da:	c1 e0 02             	shl    $0x2,%eax
  8007dd:	01 d0                	add    %edx,%eax
  8007df:	01 c0                	add    %eax,%eax
  8007e1:	01 d8                	add    %ebx,%eax
  8007e3:	83 e8 30             	sub    $0x30,%eax
  8007e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ec:	8a 00                	mov    (%eax),%al
  8007ee:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007f1:	83 fb 2f             	cmp    $0x2f,%ebx
  8007f4:	7e 3e                	jle    800834 <vprintfmt+0xe9>
  8007f6:	83 fb 39             	cmp    $0x39,%ebx
  8007f9:	7f 39                	jg     800834 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007fb:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007fe:	eb d5                	jmp    8007d5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800800:	8b 45 14             	mov    0x14(%ebp),%eax
  800803:	83 c0 04             	add    $0x4,%eax
  800806:	89 45 14             	mov    %eax,0x14(%ebp)
  800809:	8b 45 14             	mov    0x14(%ebp),%eax
  80080c:	83 e8 04             	sub    $0x4,%eax
  80080f:	8b 00                	mov    (%eax),%eax
  800811:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800814:	eb 1f                	jmp    800835 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800816:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80081a:	79 83                	jns    80079f <vprintfmt+0x54>
				width = 0;
  80081c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800823:	e9 77 ff ff ff       	jmp    80079f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800828:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80082f:	e9 6b ff ff ff       	jmp    80079f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800834:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800835:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800839:	0f 89 60 ff ff ff    	jns    80079f <vprintfmt+0x54>
				width = precision, precision = -1;
  80083f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800842:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800845:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80084c:	e9 4e ff ff ff       	jmp    80079f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800851:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800854:	e9 46 ff ff ff       	jmp    80079f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800859:	8b 45 14             	mov    0x14(%ebp),%eax
  80085c:	83 c0 04             	add    $0x4,%eax
  80085f:	89 45 14             	mov    %eax,0x14(%ebp)
  800862:	8b 45 14             	mov    0x14(%ebp),%eax
  800865:	83 e8 04             	sub    $0x4,%eax
  800868:	8b 00                	mov    (%eax),%eax
  80086a:	83 ec 08             	sub    $0x8,%esp
  80086d:	ff 75 0c             	pushl  0xc(%ebp)
  800870:	50                   	push   %eax
  800871:	8b 45 08             	mov    0x8(%ebp),%eax
  800874:	ff d0                	call   *%eax
  800876:	83 c4 10             	add    $0x10,%esp
			break;
  800879:	e9 89 02 00 00       	jmp    800b07 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80087e:	8b 45 14             	mov    0x14(%ebp),%eax
  800881:	83 c0 04             	add    $0x4,%eax
  800884:	89 45 14             	mov    %eax,0x14(%ebp)
  800887:	8b 45 14             	mov    0x14(%ebp),%eax
  80088a:	83 e8 04             	sub    $0x4,%eax
  80088d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80088f:	85 db                	test   %ebx,%ebx
  800891:	79 02                	jns    800895 <vprintfmt+0x14a>
				err = -err;
  800893:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800895:	83 fb 64             	cmp    $0x64,%ebx
  800898:	7f 0b                	jg     8008a5 <vprintfmt+0x15a>
  80089a:	8b 34 9d 60 37 80 00 	mov    0x803760(,%ebx,4),%esi
  8008a1:	85 f6                	test   %esi,%esi
  8008a3:	75 19                	jne    8008be <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008a5:	53                   	push   %ebx
  8008a6:	68 05 39 80 00       	push   $0x803905
  8008ab:	ff 75 0c             	pushl  0xc(%ebp)
  8008ae:	ff 75 08             	pushl  0x8(%ebp)
  8008b1:	e8 5e 02 00 00       	call   800b14 <printfmt>
  8008b6:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008b9:	e9 49 02 00 00       	jmp    800b07 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008be:	56                   	push   %esi
  8008bf:	68 0e 39 80 00       	push   $0x80390e
  8008c4:	ff 75 0c             	pushl  0xc(%ebp)
  8008c7:	ff 75 08             	pushl  0x8(%ebp)
  8008ca:	e8 45 02 00 00       	call   800b14 <printfmt>
  8008cf:	83 c4 10             	add    $0x10,%esp
			break;
  8008d2:	e9 30 02 00 00       	jmp    800b07 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008da:	83 c0 04             	add    $0x4,%eax
  8008dd:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e3:	83 e8 04             	sub    $0x4,%eax
  8008e6:	8b 30                	mov    (%eax),%esi
  8008e8:	85 f6                	test   %esi,%esi
  8008ea:	75 05                	jne    8008f1 <vprintfmt+0x1a6>
				p = "(null)";
  8008ec:	be 11 39 80 00       	mov    $0x803911,%esi
			if (width > 0 && padc != '-')
  8008f1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008f5:	7e 6d                	jle    800964 <vprintfmt+0x219>
  8008f7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008fb:	74 67                	je     800964 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800900:	83 ec 08             	sub    $0x8,%esp
  800903:	50                   	push   %eax
  800904:	56                   	push   %esi
  800905:	e8 0c 03 00 00       	call   800c16 <strnlen>
  80090a:	83 c4 10             	add    $0x10,%esp
  80090d:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800910:	eb 16                	jmp    800928 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800912:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800916:	83 ec 08             	sub    $0x8,%esp
  800919:	ff 75 0c             	pushl  0xc(%ebp)
  80091c:	50                   	push   %eax
  80091d:	8b 45 08             	mov    0x8(%ebp),%eax
  800920:	ff d0                	call   *%eax
  800922:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800925:	ff 4d e4             	decl   -0x1c(%ebp)
  800928:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80092c:	7f e4                	jg     800912 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80092e:	eb 34                	jmp    800964 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800930:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800934:	74 1c                	je     800952 <vprintfmt+0x207>
  800936:	83 fb 1f             	cmp    $0x1f,%ebx
  800939:	7e 05                	jle    800940 <vprintfmt+0x1f5>
  80093b:	83 fb 7e             	cmp    $0x7e,%ebx
  80093e:	7e 12                	jle    800952 <vprintfmt+0x207>
					putch('?', putdat);
  800940:	83 ec 08             	sub    $0x8,%esp
  800943:	ff 75 0c             	pushl  0xc(%ebp)
  800946:	6a 3f                	push   $0x3f
  800948:	8b 45 08             	mov    0x8(%ebp),%eax
  80094b:	ff d0                	call   *%eax
  80094d:	83 c4 10             	add    $0x10,%esp
  800950:	eb 0f                	jmp    800961 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800952:	83 ec 08             	sub    $0x8,%esp
  800955:	ff 75 0c             	pushl  0xc(%ebp)
  800958:	53                   	push   %ebx
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	ff d0                	call   *%eax
  80095e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800961:	ff 4d e4             	decl   -0x1c(%ebp)
  800964:	89 f0                	mov    %esi,%eax
  800966:	8d 70 01             	lea    0x1(%eax),%esi
  800969:	8a 00                	mov    (%eax),%al
  80096b:	0f be d8             	movsbl %al,%ebx
  80096e:	85 db                	test   %ebx,%ebx
  800970:	74 24                	je     800996 <vprintfmt+0x24b>
  800972:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800976:	78 b8                	js     800930 <vprintfmt+0x1e5>
  800978:	ff 4d e0             	decl   -0x20(%ebp)
  80097b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80097f:	79 af                	jns    800930 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800981:	eb 13                	jmp    800996 <vprintfmt+0x24b>
				putch(' ', putdat);
  800983:	83 ec 08             	sub    $0x8,%esp
  800986:	ff 75 0c             	pushl  0xc(%ebp)
  800989:	6a 20                	push   $0x20
  80098b:	8b 45 08             	mov    0x8(%ebp),%eax
  80098e:	ff d0                	call   *%eax
  800990:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800993:	ff 4d e4             	decl   -0x1c(%ebp)
  800996:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80099a:	7f e7                	jg     800983 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80099c:	e9 66 01 00 00       	jmp    800b07 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009a1:	83 ec 08             	sub    $0x8,%esp
  8009a4:	ff 75 e8             	pushl  -0x18(%ebp)
  8009a7:	8d 45 14             	lea    0x14(%ebp),%eax
  8009aa:	50                   	push   %eax
  8009ab:	e8 3c fd ff ff       	call   8006ec <getint>
  8009b0:	83 c4 10             	add    $0x10,%esp
  8009b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009b6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009bf:	85 d2                	test   %edx,%edx
  8009c1:	79 23                	jns    8009e6 <vprintfmt+0x29b>
				putch('-', putdat);
  8009c3:	83 ec 08             	sub    $0x8,%esp
  8009c6:	ff 75 0c             	pushl  0xc(%ebp)
  8009c9:	6a 2d                	push   $0x2d
  8009cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ce:	ff d0                	call   *%eax
  8009d0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009d9:	f7 d8                	neg    %eax
  8009db:	83 d2 00             	adc    $0x0,%edx
  8009de:	f7 da                	neg    %edx
  8009e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009e3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009e6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009ed:	e9 bc 00 00 00       	jmp    800aae <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009f2:	83 ec 08             	sub    $0x8,%esp
  8009f5:	ff 75 e8             	pushl  -0x18(%ebp)
  8009f8:	8d 45 14             	lea    0x14(%ebp),%eax
  8009fb:	50                   	push   %eax
  8009fc:	e8 84 fc ff ff       	call   800685 <getuint>
  800a01:	83 c4 10             	add    $0x10,%esp
  800a04:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a07:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a0a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a11:	e9 98 00 00 00       	jmp    800aae <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a16:	83 ec 08             	sub    $0x8,%esp
  800a19:	ff 75 0c             	pushl  0xc(%ebp)
  800a1c:	6a 58                	push   $0x58
  800a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a21:	ff d0                	call   *%eax
  800a23:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a26:	83 ec 08             	sub    $0x8,%esp
  800a29:	ff 75 0c             	pushl  0xc(%ebp)
  800a2c:	6a 58                	push   $0x58
  800a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a31:	ff d0                	call   *%eax
  800a33:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a36:	83 ec 08             	sub    $0x8,%esp
  800a39:	ff 75 0c             	pushl  0xc(%ebp)
  800a3c:	6a 58                	push   $0x58
  800a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a41:	ff d0                	call   *%eax
  800a43:	83 c4 10             	add    $0x10,%esp
			break;
  800a46:	e9 bc 00 00 00       	jmp    800b07 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a4b:	83 ec 08             	sub    $0x8,%esp
  800a4e:	ff 75 0c             	pushl  0xc(%ebp)
  800a51:	6a 30                	push   $0x30
  800a53:	8b 45 08             	mov    0x8(%ebp),%eax
  800a56:	ff d0                	call   *%eax
  800a58:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a5b:	83 ec 08             	sub    $0x8,%esp
  800a5e:	ff 75 0c             	pushl  0xc(%ebp)
  800a61:	6a 78                	push   $0x78
  800a63:	8b 45 08             	mov    0x8(%ebp),%eax
  800a66:	ff d0                	call   *%eax
  800a68:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6e:	83 c0 04             	add    $0x4,%eax
  800a71:	89 45 14             	mov    %eax,0x14(%ebp)
  800a74:	8b 45 14             	mov    0x14(%ebp),%eax
  800a77:	83 e8 04             	sub    $0x4,%eax
  800a7a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a86:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a8d:	eb 1f                	jmp    800aae <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a8f:	83 ec 08             	sub    $0x8,%esp
  800a92:	ff 75 e8             	pushl  -0x18(%ebp)
  800a95:	8d 45 14             	lea    0x14(%ebp),%eax
  800a98:	50                   	push   %eax
  800a99:	e8 e7 fb ff ff       	call   800685 <getuint>
  800a9e:	83 c4 10             	add    $0x10,%esp
  800aa1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aa4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800aa7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aae:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ab2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ab5:	83 ec 04             	sub    $0x4,%esp
  800ab8:	52                   	push   %edx
  800ab9:	ff 75 e4             	pushl  -0x1c(%ebp)
  800abc:	50                   	push   %eax
  800abd:	ff 75 f4             	pushl  -0xc(%ebp)
  800ac0:	ff 75 f0             	pushl  -0x10(%ebp)
  800ac3:	ff 75 0c             	pushl  0xc(%ebp)
  800ac6:	ff 75 08             	pushl  0x8(%ebp)
  800ac9:	e8 00 fb ff ff       	call   8005ce <printnum>
  800ace:	83 c4 20             	add    $0x20,%esp
			break;
  800ad1:	eb 34                	jmp    800b07 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ad3:	83 ec 08             	sub    $0x8,%esp
  800ad6:	ff 75 0c             	pushl  0xc(%ebp)
  800ad9:	53                   	push   %ebx
  800ada:	8b 45 08             	mov    0x8(%ebp),%eax
  800add:	ff d0                	call   *%eax
  800adf:	83 c4 10             	add    $0x10,%esp
			break;
  800ae2:	eb 23                	jmp    800b07 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ae4:	83 ec 08             	sub    $0x8,%esp
  800ae7:	ff 75 0c             	pushl  0xc(%ebp)
  800aea:	6a 25                	push   $0x25
  800aec:	8b 45 08             	mov    0x8(%ebp),%eax
  800aef:	ff d0                	call   *%eax
  800af1:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800af4:	ff 4d 10             	decl   0x10(%ebp)
  800af7:	eb 03                	jmp    800afc <vprintfmt+0x3b1>
  800af9:	ff 4d 10             	decl   0x10(%ebp)
  800afc:	8b 45 10             	mov    0x10(%ebp),%eax
  800aff:	48                   	dec    %eax
  800b00:	8a 00                	mov    (%eax),%al
  800b02:	3c 25                	cmp    $0x25,%al
  800b04:	75 f3                	jne    800af9 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b06:	90                   	nop
		}
	}
  800b07:	e9 47 fc ff ff       	jmp    800753 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b0c:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b0d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b10:	5b                   	pop    %ebx
  800b11:	5e                   	pop    %esi
  800b12:	5d                   	pop    %ebp
  800b13:	c3                   	ret    

00800b14 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b14:	55                   	push   %ebp
  800b15:	89 e5                	mov    %esp,%ebp
  800b17:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b1a:	8d 45 10             	lea    0x10(%ebp),%eax
  800b1d:	83 c0 04             	add    $0x4,%eax
  800b20:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b23:	8b 45 10             	mov    0x10(%ebp),%eax
  800b26:	ff 75 f4             	pushl  -0xc(%ebp)
  800b29:	50                   	push   %eax
  800b2a:	ff 75 0c             	pushl  0xc(%ebp)
  800b2d:	ff 75 08             	pushl  0x8(%ebp)
  800b30:	e8 16 fc ff ff       	call   80074b <vprintfmt>
  800b35:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b38:	90                   	nop
  800b39:	c9                   	leave  
  800b3a:	c3                   	ret    

00800b3b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b3b:	55                   	push   %ebp
  800b3c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b41:	8b 40 08             	mov    0x8(%eax),%eax
  800b44:	8d 50 01             	lea    0x1(%eax),%edx
  800b47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b50:	8b 10                	mov    (%eax),%edx
  800b52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b55:	8b 40 04             	mov    0x4(%eax),%eax
  800b58:	39 c2                	cmp    %eax,%edx
  800b5a:	73 12                	jae    800b6e <sprintputch+0x33>
		*b->buf++ = ch;
  800b5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5f:	8b 00                	mov    (%eax),%eax
  800b61:	8d 48 01             	lea    0x1(%eax),%ecx
  800b64:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b67:	89 0a                	mov    %ecx,(%edx)
  800b69:	8b 55 08             	mov    0x8(%ebp),%edx
  800b6c:	88 10                	mov    %dl,(%eax)
}
  800b6e:	90                   	nop
  800b6f:	5d                   	pop    %ebp
  800b70:	c3                   	ret    

00800b71 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b71:	55                   	push   %ebp
  800b72:	89 e5                	mov    %esp,%ebp
  800b74:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b77:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b80:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b83:	8b 45 08             	mov    0x8(%ebp),%eax
  800b86:	01 d0                	add    %edx,%eax
  800b88:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b8b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b92:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b96:	74 06                	je     800b9e <vsnprintf+0x2d>
  800b98:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b9c:	7f 07                	jg     800ba5 <vsnprintf+0x34>
		return -E_INVAL;
  800b9e:	b8 03 00 00 00       	mov    $0x3,%eax
  800ba3:	eb 20                	jmp    800bc5 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ba5:	ff 75 14             	pushl  0x14(%ebp)
  800ba8:	ff 75 10             	pushl  0x10(%ebp)
  800bab:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bae:	50                   	push   %eax
  800baf:	68 3b 0b 80 00       	push   $0x800b3b
  800bb4:	e8 92 fb ff ff       	call   80074b <vprintfmt>
  800bb9:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bbf:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bc5:	c9                   	leave  
  800bc6:	c3                   	ret    

00800bc7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bc7:	55                   	push   %ebp
  800bc8:	89 e5                	mov    %esp,%ebp
  800bca:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bcd:	8d 45 10             	lea    0x10(%ebp),%eax
  800bd0:	83 c0 04             	add    $0x4,%eax
  800bd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bd6:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd9:	ff 75 f4             	pushl  -0xc(%ebp)
  800bdc:	50                   	push   %eax
  800bdd:	ff 75 0c             	pushl  0xc(%ebp)
  800be0:	ff 75 08             	pushl  0x8(%ebp)
  800be3:	e8 89 ff ff ff       	call   800b71 <vsnprintf>
  800be8:	83 c4 10             	add    $0x10,%esp
  800beb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bee:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bf1:	c9                   	leave  
  800bf2:	c3                   	ret    

00800bf3 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bf3:	55                   	push   %ebp
  800bf4:	89 e5                	mov    %esp,%ebp
  800bf6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bf9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c00:	eb 06                	jmp    800c08 <strlen+0x15>
		n++;
  800c02:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c05:	ff 45 08             	incl   0x8(%ebp)
  800c08:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0b:	8a 00                	mov    (%eax),%al
  800c0d:	84 c0                	test   %al,%al
  800c0f:	75 f1                	jne    800c02 <strlen+0xf>
		n++;
	return n;
  800c11:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c14:	c9                   	leave  
  800c15:	c3                   	ret    

00800c16 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c16:	55                   	push   %ebp
  800c17:	89 e5                	mov    %esp,%ebp
  800c19:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c1c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c23:	eb 09                	jmp    800c2e <strnlen+0x18>
		n++;
  800c25:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c28:	ff 45 08             	incl   0x8(%ebp)
  800c2b:	ff 4d 0c             	decl   0xc(%ebp)
  800c2e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c32:	74 09                	je     800c3d <strnlen+0x27>
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	8a 00                	mov    (%eax),%al
  800c39:	84 c0                	test   %al,%al
  800c3b:	75 e8                	jne    800c25 <strnlen+0xf>
		n++;
	return n;
  800c3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c40:	c9                   	leave  
  800c41:	c3                   	ret    

00800c42 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c42:	55                   	push   %ebp
  800c43:	89 e5                	mov    %esp,%ebp
  800c45:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c4e:	90                   	nop
  800c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c52:	8d 50 01             	lea    0x1(%eax),%edx
  800c55:	89 55 08             	mov    %edx,0x8(%ebp)
  800c58:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c5b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c5e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c61:	8a 12                	mov    (%edx),%dl
  800c63:	88 10                	mov    %dl,(%eax)
  800c65:	8a 00                	mov    (%eax),%al
  800c67:	84 c0                	test   %al,%al
  800c69:	75 e4                	jne    800c4f <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c6e:	c9                   	leave  
  800c6f:	c3                   	ret    

00800c70 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c70:	55                   	push   %ebp
  800c71:	89 e5                	mov    %esp,%ebp
  800c73:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c7c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c83:	eb 1f                	jmp    800ca4 <strncpy+0x34>
		*dst++ = *src;
  800c85:	8b 45 08             	mov    0x8(%ebp),%eax
  800c88:	8d 50 01             	lea    0x1(%eax),%edx
  800c8b:	89 55 08             	mov    %edx,0x8(%ebp)
  800c8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c91:	8a 12                	mov    (%edx),%dl
  800c93:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c98:	8a 00                	mov    (%eax),%al
  800c9a:	84 c0                	test   %al,%al
  800c9c:	74 03                	je     800ca1 <strncpy+0x31>
			src++;
  800c9e:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ca1:	ff 45 fc             	incl   -0x4(%ebp)
  800ca4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ca7:	3b 45 10             	cmp    0x10(%ebp),%eax
  800caa:	72 d9                	jb     800c85 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cac:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800caf:	c9                   	leave  
  800cb0:	c3                   	ret    

00800cb1 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cb1:	55                   	push   %ebp
  800cb2:	89 e5                	mov    %esp,%ebp
  800cb4:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cbd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cc1:	74 30                	je     800cf3 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cc3:	eb 16                	jmp    800cdb <strlcpy+0x2a>
			*dst++ = *src++;
  800cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc8:	8d 50 01             	lea    0x1(%eax),%edx
  800ccb:	89 55 08             	mov    %edx,0x8(%ebp)
  800cce:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cd1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cd4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cd7:	8a 12                	mov    (%edx),%dl
  800cd9:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cdb:	ff 4d 10             	decl   0x10(%ebp)
  800cde:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ce2:	74 09                	je     800ced <strlcpy+0x3c>
  800ce4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce7:	8a 00                	mov    (%eax),%al
  800ce9:	84 c0                	test   %al,%al
  800ceb:	75 d8                	jne    800cc5 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ced:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cf3:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf9:	29 c2                	sub    %eax,%edx
  800cfb:	89 d0                	mov    %edx,%eax
}
  800cfd:	c9                   	leave  
  800cfe:	c3                   	ret    

00800cff <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cff:	55                   	push   %ebp
  800d00:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d02:	eb 06                	jmp    800d0a <strcmp+0xb>
		p++, q++;
  800d04:	ff 45 08             	incl   0x8(%ebp)
  800d07:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0d:	8a 00                	mov    (%eax),%al
  800d0f:	84 c0                	test   %al,%al
  800d11:	74 0e                	je     800d21 <strcmp+0x22>
  800d13:	8b 45 08             	mov    0x8(%ebp),%eax
  800d16:	8a 10                	mov    (%eax),%dl
  800d18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1b:	8a 00                	mov    (%eax),%al
  800d1d:	38 c2                	cmp    %al,%dl
  800d1f:	74 e3                	je     800d04 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	8a 00                	mov    (%eax),%al
  800d26:	0f b6 d0             	movzbl %al,%edx
  800d29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2c:	8a 00                	mov    (%eax),%al
  800d2e:	0f b6 c0             	movzbl %al,%eax
  800d31:	29 c2                	sub    %eax,%edx
  800d33:	89 d0                	mov    %edx,%eax
}
  800d35:	5d                   	pop    %ebp
  800d36:	c3                   	ret    

00800d37 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d37:	55                   	push   %ebp
  800d38:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d3a:	eb 09                	jmp    800d45 <strncmp+0xe>
		n--, p++, q++;
  800d3c:	ff 4d 10             	decl   0x10(%ebp)
  800d3f:	ff 45 08             	incl   0x8(%ebp)
  800d42:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d45:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d49:	74 17                	je     800d62 <strncmp+0x2b>
  800d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4e:	8a 00                	mov    (%eax),%al
  800d50:	84 c0                	test   %al,%al
  800d52:	74 0e                	je     800d62 <strncmp+0x2b>
  800d54:	8b 45 08             	mov    0x8(%ebp),%eax
  800d57:	8a 10                	mov    (%eax),%dl
  800d59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5c:	8a 00                	mov    (%eax),%al
  800d5e:	38 c2                	cmp    %al,%dl
  800d60:	74 da                	je     800d3c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d62:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d66:	75 07                	jne    800d6f <strncmp+0x38>
		return 0;
  800d68:	b8 00 00 00 00       	mov    $0x0,%eax
  800d6d:	eb 14                	jmp    800d83 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d72:	8a 00                	mov    (%eax),%al
  800d74:	0f b6 d0             	movzbl %al,%edx
  800d77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	0f b6 c0             	movzbl %al,%eax
  800d7f:	29 c2                	sub    %eax,%edx
  800d81:	89 d0                	mov    %edx,%eax
}
  800d83:	5d                   	pop    %ebp
  800d84:	c3                   	ret    

00800d85 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d85:	55                   	push   %ebp
  800d86:	89 e5                	mov    %esp,%ebp
  800d88:	83 ec 04             	sub    $0x4,%esp
  800d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d91:	eb 12                	jmp    800da5 <strchr+0x20>
		if (*s == c)
  800d93:	8b 45 08             	mov    0x8(%ebp),%eax
  800d96:	8a 00                	mov    (%eax),%al
  800d98:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d9b:	75 05                	jne    800da2 <strchr+0x1d>
			return (char *) s;
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	eb 11                	jmp    800db3 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800da2:	ff 45 08             	incl   0x8(%ebp)
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
  800da8:	8a 00                	mov    (%eax),%al
  800daa:	84 c0                	test   %al,%al
  800dac:	75 e5                	jne    800d93 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800dae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800db3:	c9                   	leave  
  800db4:	c3                   	ret    

00800db5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800db5:	55                   	push   %ebp
  800db6:	89 e5                	mov    %esp,%ebp
  800db8:	83 ec 04             	sub    $0x4,%esp
  800dbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbe:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dc1:	eb 0d                	jmp    800dd0 <strfind+0x1b>
		if (*s == c)
  800dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc6:	8a 00                	mov    (%eax),%al
  800dc8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dcb:	74 0e                	je     800ddb <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dcd:	ff 45 08             	incl   0x8(%ebp)
  800dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd3:	8a 00                	mov    (%eax),%al
  800dd5:	84 c0                	test   %al,%al
  800dd7:	75 ea                	jne    800dc3 <strfind+0xe>
  800dd9:	eb 01                	jmp    800ddc <strfind+0x27>
		if (*s == c)
			break;
  800ddb:	90                   	nop
	return (char *) s;
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ddf:	c9                   	leave  
  800de0:	c3                   	ret    

00800de1 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800de1:	55                   	push   %ebp
  800de2:	89 e5                	mov    %esp,%ebp
  800de4:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ded:	8b 45 10             	mov    0x10(%ebp),%eax
  800df0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800df3:	eb 0e                	jmp    800e03 <memset+0x22>
		*p++ = c;
  800df5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df8:	8d 50 01             	lea    0x1(%eax),%edx
  800dfb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dfe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e01:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e03:	ff 4d f8             	decl   -0x8(%ebp)
  800e06:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e0a:	79 e9                	jns    800df5 <memset+0x14>
		*p++ = c;

	return v;
  800e0c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e0f:	c9                   	leave  
  800e10:	c3                   	ret    

00800e11 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e11:	55                   	push   %ebp
  800e12:	89 e5                	mov    %esp,%ebp
  800e14:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e23:	eb 16                	jmp    800e3b <memcpy+0x2a>
		*d++ = *s++;
  800e25:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e28:	8d 50 01             	lea    0x1(%eax),%edx
  800e2b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e2e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e31:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e34:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e37:	8a 12                	mov    (%edx),%dl
  800e39:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e41:	89 55 10             	mov    %edx,0x10(%ebp)
  800e44:	85 c0                	test   %eax,%eax
  800e46:	75 dd                	jne    800e25 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e48:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e4b:	c9                   	leave  
  800e4c:	c3                   	ret    

00800e4d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e4d:	55                   	push   %ebp
  800e4e:	89 e5                	mov    %esp,%ebp
  800e50:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e62:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e65:	73 50                	jae    800eb7 <memmove+0x6a>
  800e67:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e6a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6d:	01 d0                	add    %edx,%eax
  800e6f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e72:	76 43                	jbe    800eb7 <memmove+0x6a>
		s += n;
  800e74:	8b 45 10             	mov    0x10(%ebp),%eax
  800e77:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e7a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e80:	eb 10                	jmp    800e92 <memmove+0x45>
			*--d = *--s;
  800e82:	ff 4d f8             	decl   -0x8(%ebp)
  800e85:	ff 4d fc             	decl   -0x4(%ebp)
  800e88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e8b:	8a 10                	mov    (%eax),%dl
  800e8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e90:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e92:	8b 45 10             	mov    0x10(%ebp),%eax
  800e95:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e98:	89 55 10             	mov    %edx,0x10(%ebp)
  800e9b:	85 c0                	test   %eax,%eax
  800e9d:	75 e3                	jne    800e82 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e9f:	eb 23                	jmp    800ec4 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ea1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea4:	8d 50 01             	lea    0x1(%eax),%edx
  800ea7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800eaa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ead:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eb0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800eb3:	8a 12                	mov    (%edx),%dl
  800eb5:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800eb7:	8b 45 10             	mov    0x10(%ebp),%eax
  800eba:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ebd:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec0:	85 c0                	test   %eax,%eax
  800ec2:	75 dd                	jne    800ea1 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec7:	c9                   	leave  
  800ec8:	c3                   	ret    

00800ec9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ec9:	55                   	push   %ebp
  800eca:	89 e5                	mov    %esp,%ebp
  800ecc:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ed5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed8:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800edb:	eb 2a                	jmp    800f07 <memcmp+0x3e>
		if (*s1 != *s2)
  800edd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee0:	8a 10                	mov    (%eax),%dl
  800ee2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee5:	8a 00                	mov    (%eax),%al
  800ee7:	38 c2                	cmp    %al,%dl
  800ee9:	74 16                	je     800f01 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800eeb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eee:	8a 00                	mov    (%eax),%al
  800ef0:	0f b6 d0             	movzbl %al,%edx
  800ef3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef6:	8a 00                	mov    (%eax),%al
  800ef8:	0f b6 c0             	movzbl %al,%eax
  800efb:	29 c2                	sub    %eax,%edx
  800efd:	89 d0                	mov    %edx,%eax
  800eff:	eb 18                	jmp    800f19 <memcmp+0x50>
		s1++, s2++;
  800f01:	ff 45 fc             	incl   -0x4(%ebp)
  800f04:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f07:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f0d:	89 55 10             	mov    %edx,0x10(%ebp)
  800f10:	85 c0                	test   %eax,%eax
  800f12:	75 c9                	jne    800edd <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f19:	c9                   	leave  
  800f1a:	c3                   	ret    

00800f1b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f1b:	55                   	push   %ebp
  800f1c:	89 e5                	mov    %esp,%ebp
  800f1e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f21:	8b 55 08             	mov    0x8(%ebp),%edx
  800f24:	8b 45 10             	mov    0x10(%ebp),%eax
  800f27:	01 d0                	add    %edx,%eax
  800f29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f2c:	eb 15                	jmp    800f43 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f31:	8a 00                	mov    (%eax),%al
  800f33:	0f b6 d0             	movzbl %al,%edx
  800f36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f39:	0f b6 c0             	movzbl %al,%eax
  800f3c:	39 c2                	cmp    %eax,%edx
  800f3e:	74 0d                	je     800f4d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f40:	ff 45 08             	incl   0x8(%ebp)
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f49:	72 e3                	jb     800f2e <memfind+0x13>
  800f4b:	eb 01                	jmp    800f4e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f4d:	90                   	nop
	return (void *) s;
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f51:	c9                   	leave  
  800f52:	c3                   	ret    

00800f53 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f53:	55                   	push   %ebp
  800f54:	89 e5                	mov    %esp,%ebp
  800f56:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f59:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f60:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f67:	eb 03                	jmp    800f6c <strtol+0x19>
		s++;
  800f69:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6f:	8a 00                	mov    (%eax),%al
  800f71:	3c 20                	cmp    $0x20,%al
  800f73:	74 f4                	je     800f69 <strtol+0x16>
  800f75:	8b 45 08             	mov    0x8(%ebp),%eax
  800f78:	8a 00                	mov    (%eax),%al
  800f7a:	3c 09                	cmp    $0x9,%al
  800f7c:	74 eb                	je     800f69 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f81:	8a 00                	mov    (%eax),%al
  800f83:	3c 2b                	cmp    $0x2b,%al
  800f85:	75 05                	jne    800f8c <strtol+0x39>
		s++;
  800f87:	ff 45 08             	incl   0x8(%ebp)
  800f8a:	eb 13                	jmp    800f9f <strtol+0x4c>
	else if (*s == '-')
  800f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8f:	8a 00                	mov    (%eax),%al
  800f91:	3c 2d                	cmp    $0x2d,%al
  800f93:	75 0a                	jne    800f9f <strtol+0x4c>
		s++, neg = 1;
  800f95:	ff 45 08             	incl   0x8(%ebp)
  800f98:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f9f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa3:	74 06                	je     800fab <strtol+0x58>
  800fa5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fa9:	75 20                	jne    800fcb <strtol+0x78>
  800fab:	8b 45 08             	mov    0x8(%ebp),%eax
  800fae:	8a 00                	mov    (%eax),%al
  800fb0:	3c 30                	cmp    $0x30,%al
  800fb2:	75 17                	jne    800fcb <strtol+0x78>
  800fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb7:	40                   	inc    %eax
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	3c 78                	cmp    $0x78,%al
  800fbc:	75 0d                	jne    800fcb <strtol+0x78>
		s += 2, base = 16;
  800fbe:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fc2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fc9:	eb 28                	jmp    800ff3 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fcb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fcf:	75 15                	jne    800fe6 <strtol+0x93>
  800fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd4:	8a 00                	mov    (%eax),%al
  800fd6:	3c 30                	cmp    $0x30,%al
  800fd8:	75 0c                	jne    800fe6 <strtol+0x93>
		s++, base = 8;
  800fda:	ff 45 08             	incl   0x8(%ebp)
  800fdd:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fe4:	eb 0d                	jmp    800ff3 <strtol+0xa0>
	else if (base == 0)
  800fe6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fea:	75 07                	jne    800ff3 <strtol+0xa0>
		base = 10;
  800fec:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff6:	8a 00                	mov    (%eax),%al
  800ff8:	3c 2f                	cmp    $0x2f,%al
  800ffa:	7e 19                	jle    801015 <strtol+0xc2>
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	3c 39                	cmp    $0x39,%al
  801003:	7f 10                	jg     801015 <strtol+0xc2>
			dig = *s - '0';
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	8a 00                	mov    (%eax),%al
  80100a:	0f be c0             	movsbl %al,%eax
  80100d:	83 e8 30             	sub    $0x30,%eax
  801010:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801013:	eb 42                	jmp    801057 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801015:	8b 45 08             	mov    0x8(%ebp),%eax
  801018:	8a 00                	mov    (%eax),%al
  80101a:	3c 60                	cmp    $0x60,%al
  80101c:	7e 19                	jle    801037 <strtol+0xe4>
  80101e:	8b 45 08             	mov    0x8(%ebp),%eax
  801021:	8a 00                	mov    (%eax),%al
  801023:	3c 7a                	cmp    $0x7a,%al
  801025:	7f 10                	jg     801037 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801027:	8b 45 08             	mov    0x8(%ebp),%eax
  80102a:	8a 00                	mov    (%eax),%al
  80102c:	0f be c0             	movsbl %al,%eax
  80102f:	83 e8 57             	sub    $0x57,%eax
  801032:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801035:	eb 20                	jmp    801057 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
  80103a:	8a 00                	mov    (%eax),%al
  80103c:	3c 40                	cmp    $0x40,%al
  80103e:	7e 39                	jle    801079 <strtol+0x126>
  801040:	8b 45 08             	mov    0x8(%ebp),%eax
  801043:	8a 00                	mov    (%eax),%al
  801045:	3c 5a                	cmp    $0x5a,%al
  801047:	7f 30                	jg     801079 <strtol+0x126>
			dig = *s - 'A' + 10;
  801049:	8b 45 08             	mov    0x8(%ebp),%eax
  80104c:	8a 00                	mov    (%eax),%al
  80104e:	0f be c0             	movsbl %al,%eax
  801051:	83 e8 37             	sub    $0x37,%eax
  801054:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801057:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80105a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80105d:	7d 19                	jge    801078 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80105f:	ff 45 08             	incl   0x8(%ebp)
  801062:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801065:	0f af 45 10          	imul   0x10(%ebp),%eax
  801069:	89 c2                	mov    %eax,%edx
  80106b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80106e:	01 d0                	add    %edx,%eax
  801070:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801073:	e9 7b ff ff ff       	jmp    800ff3 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801078:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801079:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80107d:	74 08                	je     801087 <strtol+0x134>
		*endptr = (char *) s;
  80107f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801082:	8b 55 08             	mov    0x8(%ebp),%edx
  801085:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801087:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80108b:	74 07                	je     801094 <strtol+0x141>
  80108d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801090:	f7 d8                	neg    %eax
  801092:	eb 03                	jmp    801097 <strtol+0x144>
  801094:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801097:	c9                   	leave  
  801098:	c3                   	ret    

00801099 <ltostr>:

void
ltostr(long value, char *str)
{
  801099:	55                   	push   %ebp
  80109a:	89 e5                	mov    %esp,%ebp
  80109c:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80109f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010a6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010b1:	79 13                	jns    8010c6 <ltostr+0x2d>
	{
		neg = 1;
  8010b3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bd:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010c0:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010c3:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010ce:	99                   	cltd   
  8010cf:	f7 f9                	idiv   %ecx
  8010d1:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d7:	8d 50 01             	lea    0x1(%eax),%edx
  8010da:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010dd:	89 c2                	mov    %eax,%edx
  8010df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e2:	01 d0                	add    %edx,%eax
  8010e4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010e7:	83 c2 30             	add    $0x30,%edx
  8010ea:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010ef:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010f4:	f7 e9                	imul   %ecx
  8010f6:	c1 fa 02             	sar    $0x2,%edx
  8010f9:	89 c8                	mov    %ecx,%eax
  8010fb:	c1 f8 1f             	sar    $0x1f,%eax
  8010fe:	29 c2                	sub    %eax,%edx
  801100:	89 d0                	mov    %edx,%eax
  801102:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801105:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801108:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80110d:	f7 e9                	imul   %ecx
  80110f:	c1 fa 02             	sar    $0x2,%edx
  801112:	89 c8                	mov    %ecx,%eax
  801114:	c1 f8 1f             	sar    $0x1f,%eax
  801117:	29 c2                	sub    %eax,%edx
  801119:	89 d0                	mov    %edx,%eax
  80111b:	c1 e0 02             	shl    $0x2,%eax
  80111e:	01 d0                	add    %edx,%eax
  801120:	01 c0                	add    %eax,%eax
  801122:	29 c1                	sub    %eax,%ecx
  801124:	89 ca                	mov    %ecx,%edx
  801126:	85 d2                	test   %edx,%edx
  801128:	75 9c                	jne    8010c6 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80112a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801131:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801134:	48                   	dec    %eax
  801135:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801138:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80113c:	74 3d                	je     80117b <ltostr+0xe2>
		start = 1 ;
  80113e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801145:	eb 34                	jmp    80117b <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801147:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80114a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114d:	01 d0                	add    %edx,%eax
  80114f:	8a 00                	mov    (%eax),%al
  801151:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801154:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801157:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115a:	01 c2                	add    %eax,%edx
  80115c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80115f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801162:	01 c8                	add    %ecx,%eax
  801164:	8a 00                	mov    (%eax),%al
  801166:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801168:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80116b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116e:	01 c2                	add    %eax,%edx
  801170:	8a 45 eb             	mov    -0x15(%ebp),%al
  801173:	88 02                	mov    %al,(%edx)
		start++ ;
  801175:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801178:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80117b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80117e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801181:	7c c4                	jl     801147 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801183:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801186:	8b 45 0c             	mov    0xc(%ebp),%eax
  801189:	01 d0                	add    %edx,%eax
  80118b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80118e:	90                   	nop
  80118f:	c9                   	leave  
  801190:	c3                   	ret    

00801191 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801191:	55                   	push   %ebp
  801192:	89 e5                	mov    %esp,%ebp
  801194:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801197:	ff 75 08             	pushl  0x8(%ebp)
  80119a:	e8 54 fa ff ff       	call   800bf3 <strlen>
  80119f:	83 c4 04             	add    $0x4,%esp
  8011a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011a5:	ff 75 0c             	pushl  0xc(%ebp)
  8011a8:	e8 46 fa ff ff       	call   800bf3 <strlen>
  8011ad:	83 c4 04             	add    $0x4,%esp
  8011b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011c1:	eb 17                	jmp    8011da <strcconcat+0x49>
		final[s] = str1[s] ;
  8011c3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c9:	01 c2                	add    %eax,%edx
  8011cb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d1:	01 c8                	add    %ecx,%eax
  8011d3:	8a 00                	mov    (%eax),%al
  8011d5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011d7:	ff 45 fc             	incl   -0x4(%ebp)
  8011da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011dd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011e0:	7c e1                	jl     8011c3 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011e2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011e9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011f0:	eb 1f                	jmp    801211 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011f5:	8d 50 01             	lea    0x1(%eax),%edx
  8011f8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011fb:	89 c2                	mov    %eax,%edx
  8011fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801200:	01 c2                	add    %eax,%edx
  801202:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801205:	8b 45 0c             	mov    0xc(%ebp),%eax
  801208:	01 c8                	add    %ecx,%eax
  80120a:	8a 00                	mov    (%eax),%al
  80120c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80120e:	ff 45 f8             	incl   -0x8(%ebp)
  801211:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801214:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801217:	7c d9                	jl     8011f2 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801219:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80121c:	8b 45 10             	mov    0x10(%ebp),%eax
  80121f:	01 d0                	add    %edx,%eax
  801221:	c6 00 00             	movb   $0x0,(%eax)
}
  801224:	90                   	nop
  801225:	c9                   	leave  
  801226:	c3                   	ret    

00801227 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801227:	55                   	push   %ebp
  801228:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80122a:	8b 45 14             	mov    0x14(%ebp),%eax
  80122d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801233:	8b 45 14             	mov    0x14(%ebp),%eax
  801236:	8b 00                	mov    (%eax),%eax
  801238:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80123f:	8b 45 10             	mov    0x10(%ebp),%eax
  801242:	01 d0                	add    %edx,%eax
  801244:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80124a:	eb 0c                	jmp    801258 <strsplit+0x31>
			*string++ = 0;
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
  80124f:	8d 50 01             	lea    0x1(%eax),%edx
  801252:	89 55 08             	mov    %edx,0x8(%ebp)
  801255:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801258:	8b 45 08             	mov    0x8(%ebp),%eax
  80125b:	8a 00                	mov    (%eax),%al
  80125d:	84 c0                	test   %al,%al
  80125f:	74 18                	je     801279 <strsplit+0x52>
  801261:	8b 45 08             	mov    0x8(%ebp),%eax
  801264:	8a 00                	mov    (%eax),%al
  801266:	0f be c0             	movsbl %al,%eax
  801269:	50                   	push   %eax
  80126a:	ff 75 0c             	pushl  0xc(%ebp)
  80126d:	e8 13 fb ff ff       	call   800d85 <strchr>
  801272:	83 c4 08             	add    $0x8,%esp
  801275:	85 c0                	test   %eax,%eax
  801277:	75 d3                	jne    80124c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801279:	8b 45 08             	mov    0x8(%ebp),%eax
  80127c:	8a 00                	mov    (%eax),%al
  80127e:	84 c0                	test   %al,%al
  801280:	74 5a                	je     8012dc <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801282:	8b 45 14             	mov    0x14(%ebp),%eax
  801285:	8b 00                	mov    (%eax),%eax
  801287:	83 f8 0f             	cmp    $0xf,%eax
  80128a:	75 07                	jne    801293 <strsplit+0x6c>
		{
			return 0;
  80128c:	b8 00 00 00 00       	mov    $0x0,%eax
  801291:	eb 66                	jmp    8012f9 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801293:	8b 45 14             	mov    0x14(%ebp),%eax
  801296:	8b 00                	mov    (%eax),%eax
  801298:	8d 48 01             	lea    0x1(%eax),%ecx
  80129b:	8b 55 14             	mov    0x14(%ebp),%edx
  80129e:	89 0a                	mov    %ecx,(%edx)
  8012a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012aa:	01 c2                	add    %eax,%edx
  8012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8012af:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012b1:	eb 03                	jmp    8012b6 <strsplit+0x8f>
			string++;
  8012b3:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b9:	8a 00                	mov    (%eax),%al
  8012bb:	84 c0                	test   %al,%al
  8012bd:	74 8b                	je     80124a <strsplit+0x23>
  8012bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c2:	8a 00                	mov    (%eax),%al
  8012c4:	0f be c0             	movsbl %al,%eax
  8012c7:	50                   	push   %eax
  8012c8:	ff 75 0c             	pushl  0xc(%ebp)
  8012cb:	e8 b5 fa ff ff       	call   800d85 <strchr>
  8012d0:	83 c4 08             	add    $0x8,%esp
  8012d3:	85 c0                	test   %eax,%eax
  8012d5:	74 dc                	je     8012b3 <strsplit+0x8c>
			string++;
	}
  8012d7:	e9 6e ff ff ff       	jmp    80124a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012dc:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e0:	8b 00                	mov    (%eax),%eax
  8012e2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ec:	01 d0                	add    %edx,%eax
  8012ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012f4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012f9:	c9                   	leave  
  8012fa:	c3                   	ret    

008012fb <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012fb:	55                   	push   %ebp
  8012fc:	89 e5                	mov    %esp,%ebp
  8012fe:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801301:	a1 04 40 80 00       	mov    0x804004,%eax
  801306:	85 c0                	test   %eax,%eax
  801308:	74 1f                	je     801329 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80130a:	e8 1d 00 00 00       	call   80132c <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80130f:	83 ec 0c             	sub    $0xc,%esp
  801312:	68 70 3a 80 00       	push   $0x803a70
  801317:	e8 55 f2 ff ff       	call   800571 <cprintf>
  80131c:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80131f:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801326:	00 00 00 
	}
}
  801329:	90                   	nop
  80132a:	c9                   	leave  
  80132b:	c3                   	ret    

0080132c <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80132c:	55                   	push   %ebp
  80132d:	89 e5                	mov    %esp,%ebp
  80132f:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  801332:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801339:	00 00 00 
  80133c:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801343:	00 00 00 
  801346:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80134d:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  801350:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801357:	00 00 00 
  80135a:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801361:	00 00 00 
  801364:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80136b:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  80136e:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801375:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801378:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80137d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801382:	a3 50 40 80 00       	mov    %eax,0x804050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801387:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80138e:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  801391:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801398:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80139b:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  8013a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8013a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8013ab:	f7 75 f0             	divl   -0x10(%ebp)
  8013ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013b1:	29 d0                	sub    %edx,%eax
  8013b3:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  8013b6:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8013bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013c0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013c5:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013ca:	83 ec 04             	sub    $0x4,%esp
  8013cd:	6a 06                	push   $0x6
  8013cf:	ff 75 e8             	pushl  -0x18(%ebp)
  8013d2:	50                   	push   %eax
  8013d3:	e8 d4 05 00 00       	call   8019ac <sys_allocate_chunk>
  8013d8:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013db:	a1 20 41 80 00       	mov    0x804120,%eax
  8013e0:	83 ec 0c             	sub    $0xc,%esp
  8013e3:	50                   	push   %eax
  8013e4:	e8 49 0c 00 00       	call   802032 <initialize_MemBlocksList>
  8013e9:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  8013ec:	a1 48 41 80 00       	mov    0x804148,%eax
  8013f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  8013f4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013f8:	75 14                	jne    80140e <initialize_dyn_block_system+0xe2>
  8013fa:	83 ec 04             	sub    $0x4,%esp
  8013fd:	68 95 3a 80 00       	push   $0x803a95
  801402:	6a 39                	push   $0x39
  801404:	68 b3 3a 80 00       	push   $0x803ab3
  801409:	e8 af ee ff ff       	call   8002bd <_panic>
  80140e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801411:	8b 00                	mov    (%eax),%eax
  801413:	85 c0                	test   %eax,%eax
  801415:	74 10                	je     801427 <initialize_dyn_block_system+0xfb>
  801417:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80141a:	8b 00                	mov    (%eax),%eax
  80141c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80141f:	8b 52 04             	mov    0x4(%edx),%edx
  801422:	89 50 04             	mov    %edx,0x4(%eax)
  801425:	eb 0b                	jmp    801432 <initialize_dyn_block_system+0x106>
  801427:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80142a:	8b 40 04             	mov    0x4(%eax),%eax
  80142d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801432:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801435:	8b 40 04             	mov    0x4(%eax),%eax
  801438:	85 c0                	test   %eax,%eax
  80143a:	74 0f                	je     80144b <initialize_dyn_block_system+0x11f>
  80143c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80143f:	8b 40 04             	mov    0x4(%eax),%eax
  801442:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801445:	8b 12                	mov    (%edx),%edx
  801447:	89 10                	mov    %edx,(%eax)
  801449:	eb 0a                	jmp    801455 <initialize_dyn_block_system+0x129>
  80144b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80144e:	8b 00                	mov    (%eax),%eax
  801450:	a3 48 41 80 00       	mov    %eax,0x804148
  801455:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801458:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80145e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801461:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801468:	a1 54 41 80 00       	mov    0x804154,%eax
  80146d:	48                   	dec    %eax
  80146e:	a3 54 41 80 00       	mov    %eax,0x804154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  801473:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801476:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  80147d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801480:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  801487:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80148b:	75 14                	jne    8014a1 <initialize_dyn_block_system+0x175>
  80148d:	83 ec 04             	sub    $0x4,%esp
  801490:	68 c0 3a 80 00       	push   $0x803ac0
  801495:	6a 3f                	push   $0x3f
  801497:	68 b3 3a 80 00       	push   $0x803ab3
  80149c:	e8 1c ee ff ff       	call   8002bd <_panic>
  8014a1:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8014a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014aa:	89 10                	mov    %edx,(%eax)
  8014ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014af:	8b 00                	mov    (%eax),%eax
  8014b1:	85 c0                	test   %eax,%eax
  8014b3:	74 0d                	je     8014c2 <initialize_dyn_block_system+0x196>
  8014b5:	a1 38 41 80 00       	mov    0x804138,%eax
  8014ba:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014bd:	89 50 04             	mov    %edx,0x4(%eax)
  8014c0:	eb 08                	jmp    8014ca <initialize_dyn_block_system+0x19e>
  8014c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014c5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8014ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014cd:	a3 38 41 80 00       	mov    %eax,0x804138
  8014d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014dc:	a1 44 41 80 00       	mov    0x804144,%eax
  8014e1:	40                   	inc    %eax
  8014e2:	a3 44 41 80 00       	mov    %eax,0x804144

}
  8014e7:	90                   	nop
  8014e8:	c9                   	leave  
  8014e9:	c3                   	ret    

008014ea <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8014ea:	55                   	push   %ebp
  8014eb:	89 e5                	mov    %esp,%ebp
  8014ed:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014f0:	e8 06 fe ff ff       	call   8012fb <InitializeUHeap>
	if (size == 0) return NULL ;
  8014f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014f9:	75 07                	jne    801502 <malloc+0x18>
  8014fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801500:	eb 7d                	jmp    80157f <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  801502:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801509:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801510:	8b 55 08             	mov    0x8(%ebp),%edx
  801513:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801516:	01 d0                	add    %edx,%eax
  801518:	48                   	dec    %eax
  801519:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80151c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80151f:	ba 00 00 00 00       	mov    $0x0,%edx
  801524:	f7 75 f0             	divl   -0x10(%ebp)
  801527:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80152a:	29 d0                	sub    %edx,%eax
  80152c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  80152f:	e8 46 08 00 00       	call   801d7a <sys_isUHeapPlacementStrategyFIRSTFIT>
  801534:	83 f8 01             	cmp    $0x1,%eax
  801537:	75 07                	jne    801540 <malloc+0x56>
  801539:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  801540:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  801544:	75 34                	jne    80157a <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  801546:	83 ec 0c             	sub    $0xc,%esp
  801549:	ff 75 e8             	pushl  -0x18(%ebp)
  80154c:	e8 73 0e 00 00       	call   8023c4 <alloc_block_FF>
  801551:	83 c4 10             	add    $0x10,%esp
  801554:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  801557:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80155b:	74 16                	je     801573 <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  80155d:	83 ec 0c             	sub    $0xc,%esp
  801560:	ff 75 e4             	pushl  -0x1c(%ebp)
  801563:	e8 ff 0b 00 00       	call   802167 <insert_sorted_allocList>
  801568:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  80156b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80156e:	8b 40 08             	mov    0x8(%eax),%eax
  801571:	eb 0c                	jmp    80157f <malloc+0x95>
	             }
	             else
	             	return NULL;
  801573:	b8 00 00 00 00       	mov    $0x0,%eax
  801578:	eb 05                	jmp    80157f <malloc+0x95>
	      	  }
	          else
	               return NULL;
  80157a:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  80157f:	c9                   	leave  
  801580:	c3                   	ret    

00801581 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801581:	55                   	push   %ebp
  801582:	89 e5                	mov    %esp,%ebp
  801584:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  801587:	8b 45 08             	mov    0x8(%ebp),%eax
  80158a:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  80158d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801590:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801593:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801596:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80159b:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  80159e:	83 ec 08             	sub    $0x8,%esp
  8015a1:	ff 75 f4             	pushl  -0xc(%ebp)
  8015a4:	68 40 40 80 00       	push   $0x804040
  8015a9:	e8 61 0b 00 00       	call   80210f <find_block>
  8015ae:	83 c4 10             	add    $0x10,%esp
  8015b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  8015b4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015b8:	0f 84 a5 00 00 00    	je     801663 <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  8015be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8015c4:	83 ec 08             	sub    $0x8,%esp
  8015c7:	50                   	push   %eax
  8015c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8015cb:	e8 a4 03 00 00       	call   801974 <sys_free_user_mem>
  8015d0:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  8015d3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015d7:	75 17                	jne    8015f0 <free+0x6f>
  8015d9:	83 ec 04             	sub    $0x4,%esp
  8015dc:	68 95 3a 80 00       	push   $0x803a95
  8015e1:	68 87 00 00 00       	push   $0x87
  8015e6:	68 b3 3a 80 00       	push   $0x803ab3
  8015eb:	e8 cd ec ff ff       	call   8002bd <_panic>
  8015f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015f3:	8b 00                	mov    (%eax),%eax
  8015f5:	85 c0                	test   %eax,%eax
  8015f7:	74 10                	je     801609 <free+0x88>
  8015f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015fc:	8b 00                	mov    (%eax),%eax
  8015fe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801601:	8b 52 04             	mov    0x4(%edx),%edx
  801604:	89 50 04             	mov    %edx,0x4(%eax)
  801607:	eb 0b                	jmp    801614 <free+0x93>
  801609:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80160c:	8b 40 04             	mov    0x4(%eax),%eax
  80160f:	a3 44 40 80 00       	mov    %eax,0x804044
  801614:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801617:	8b 40 04             	mov    0x4(%eax),%eax
  80161a:	85 c0                	test   %eax,%eax
  80161c:	74 0f                	je     80162d <free+0xac>
  80161e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801621:	8b 40 04             	mov    0x4(%eax),%eax
  801624:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801627:	8b 12                	mov    (%edx),%edx
  801629:	89 10                	mov    %edx,(%eax)
  80162b:	eb 0a                	jmp    801637 <free+0xb6>
  80162d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801630:	8b 00                	mov    (%eax),%eax
  801632:	a3 40 40 80 00       	mov    %eax,0x804040
  801637:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80163a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801640:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801643:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80164a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80164f:	48                   	dec    %eax
  801650:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(theBlock);
  801655:	83 ec 0c             	sub    $0xc,%esp
  801658:	ff 75 ec             	pushl  -0x14(%ebp)
  80165b:	e8 37 12 00 00       	call   802897 <insert_sorted_with_merge_freeList>
  801660:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  801663:	90                   	nop
  801664:	c9                   	leave  
  801665:	c3                   	ret    

00801666 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801666:	55                   	push   %ebp
  801667:	89 e5                	mov    %esp,%ebp
  801669:	83 ec 38             	sub    $0x38,%esp
  80166c:	8b 45 10             	mov    0x10(%ebp),%eax
  80166f:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801672:	e8 84 fc ff ff       	call   8012fb <InitializeUHeap>
	if (size == 0) return NULL ;
  801677:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80167b:	75 07                	jne    801684 <smalloc+0x1e>
  80167d:	b8 00 00 00 00       	mov    $0x0,%eax
  801682:	eb 7e                	jmp    801702 <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  801684:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  80168b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801692:	8b 55 0c             	mov    0xc(%ebp),%edx
  801695:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801698:	01 d0                	add    %edx,%eax
  80169a:	48                   	dec    %eax
  80169b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80169e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a6:	f7 75 f0             	divl   -0x10(%ebp)
  8016a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016ac:	29 d0                	sub    %edx,%eax
  8016ae:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  8016b1:	e8 c4 06 00 00       	call   801d7a <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016b6:	83 f8 01             	cmp    $0x1,%eax
  8016b9:	75 42                	jne    8016fd <smalloc+0x97>

		  va = malloc(newsize) ;
  8016bb:	83 ec 0c             	sub    $0xc,%esp
  8016be:	ff 75 e8             	pushl  -0x18(%ebp)
  8016c1:	e8 24 fe ff ff       	call   8014ea <malloc>
  8016c6:	83 c4 10             	add    $0x10,%esp
  8016c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  8016cc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8016d0:	74 24                	je     8016f6 <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  8016d2:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8016d6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8016d9:	50                   	push   %eax
  8016da:	ff 75 e8             	pushl  -0x18(%ebp)
  8016dd:	ff 75 08             	pushl  0x8(%ebp)
  8016e0:	e8 1a 04 00 00       	call   801aff <sys_createSharedObject>
  8016e5:	83 c4 10             	add    $0x10,%esp
  8016e8:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  8016eb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8016ef:	78 0c                	js     8016fd <smalloc+0x97>
					  return va ;
  8016f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016f4:	eb 0c                	jmp    801702 <smalloc+0x9c>
				 }
				 else
					return NULL;
  8016f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8016fb:	eb 05                	jmp    801702 <smalloc+0x9c>
	  }
		  return NULL ;
  8016fd:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801702:	c9                   	leave  
  801703:	c3                   	ret    

00801704 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801704:	55                   	push   %ebp
  801705:	89 e5                	mov    %esp,%ebp
  801707:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80170a:	e8 ec fb ff ff       	call   8012fb <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  80170f:	83 ec 08             	sub    $0x8,%esp
  801712:	ff 75 0c             	pushl  0xc(%ebp)
  801715:	ff 75 08             	pushl  0x8(%ebp)
  801718:	e8 0c 04 00 00       	call   801b29 <sys_getSizeOfSharedObject>
  80171d:	83 c4 10             	add    $0x10,%esp
  801720:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  801723:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801727:	75 07                	jne    801730 <sget+0x2c>
  801729:	b8 00 00 00 00       	mov    $0x0,%eax
  80172e:	eb 75                	jmp    8017a5 <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801730:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801737:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80173a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80173d:	01 d0                	add    %edx,%eax
  80173f:	48                   	dec    %eax
  801740:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801743:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801746:	ba 00 00 00 00       	mov    $0x0,%edx
  80174b:	f7 75 f0             	divl   -0x10(%ebp)
  80174e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801751:	29 d0                	sub    %edx,%eax
  801753:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  801756:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  80175d:	e8 18 06 00 00       	call   801d7a <sys_isUHeapPlacementStrategyFIRSTFIT>
  801762:	83 f8 01             	cmp    $0x1,%eax
  801765:	75 39                	jne    8017a0 <sget+0x9c>

		  va = malloc(newsize) ;
  801767:	83 ec 0c             	sub    $0xc,%esp
  80176a:	ff 75 e8             	pushl  -0x18(%ebp)
  80176d:	e8 78 fd ff ff       	call   8014ea <malloc>
  801772:	83 c4 10             	add    $0x10,%esp
  801775:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  801778:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80177c:	74 22                	je     8017a0 <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  80177e:	83 ec 04             	sub    $0x4,%esp
  801781:	ff 75 e0             	pushl  -0x20(%ebp)
  801784:	ff 75 0c             	pushl  0xc(%ebp)
  801787:	ff 75 08             	pushl  0x8(%ebp)
  80178a:	e8 b7 03 00 00       	call   801b46 <sys_getSharedObject>
  80178f:	83 c4 10             	add    $0x10,%esp
  801792:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  801795:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801799:	78 05                	js     8017a0 <sget+0x9c>
					  return va;
  80179b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80179e:	eb 05                	jmp    8017a5 <sget+0xa1>
				  }
			  }
     }
         return NULL;
  8017a0:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  8017a5:	c9                   	leave  
  8017a6:	c3                   	ret    

008017a7 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017a7:	55                   	push   %ebp
  8017a8:	89 e5                	mov    %esp,%ebp
  8017aa:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017ad:	e8 49 fb ff ff       	call   8012fb <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017b2:	83 ec 04             	sub    $0x4,%esp
  8017b5:	68 e4 3a 80 00       	push   $0x803ae4
  8017ba:	68 1e 01 00 00       	push   $0x11e
  8017bf:	68 b3 3a 80 00       	push   $0x803ab3
  8017c4:	e8 f4 ea ff ff       	call   8002bd <_panic>

008017c9 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017c9:	55                   	push   %ebp
  8017ca:	89 e5                	mov    %esp,%ebp
  8017cc:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017cf:	83 ec 04             	sub    $0x4,%esp
  8017d2:	68 0c 3b 80 00       	push   $0x803b0c
  8017d7:	68 32 01 00 00       	push   $0x132
  8017dc:	68 b3 3a 80 00       	push   $0x803ab3
  8017e1:	e8 d7 ea ff ff       	call   8002bd <_panic>

008017e6 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
  8017e9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017ec:	83 ec 04             	sub    $0x4,%esp
  8017ef:	68 30 3b 80 00       	push   $0x803b30
  8017f4:	68 3d 01 00 00       	push   $0x13d
  8017f9:	68 b3 3a 80 00       	push   $0x803ab3
  8017fe:	e8 ba ea ff ff       	call   8002bd <_panic>

00801803 <shrink>:

}
void shrink(uint32 newSize)
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
  801806:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801809:	83 ec 04             	sub    $0x4,%esp
  80180c:	68 30 3b 80 00       	push   $0x803b30
  801811:	68 42 01 00 00       	push   $0x142
  801816:	68 b3 3a 80 00       	push   $0x803ab3
  80181b:	e8 9d ea ff ff       	call   8002bd <_panic>

00801820 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801820:	55                   	push   %ebp
  801821:	89 e5                	mov    %esp,%ebp
  801823:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801826:	83 ec 04             	sub    $0x4,%esp
  801829:	68 30 3b 80 00       	push   $0x803b30
  80182e:	68 47 01 00 00       	push   $0x147
  801833:	68 b3 3a 80 00       	push   $0x803ab3
  801838:	e8 80 ea ff ff       	call   8002bd <_panic>

0080183d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80183d:	55                   	push   %ebp
  80183e:	89 e5                	mov    %esp,%ebp
  801840:	57                   	push   %edi
  801841:	56                   	push   %esi
  801842:	53                   	push   %ebx
  801843:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801846:	8b 45 08             	mov    0x8(%ebp),%eax
  801849:	8b 55 0c             	mov    0xc(%ebp),%edx
  80184c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80184f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801852:	8b 7d 18             	mov    0x18(%ebp),%edi
  801855:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801858:	cd 30                	int    $0x30
  80185a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80185d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801860:	83 c4 10             	add    $0x10,%esp
  801863:	5b                   	pop    %ebx
  801864:	5e                   	pop    %esi
  801865:	5f                   	pop    %edi
  801866:	5d                   	pop    %ebp
  801867:	c3                   	ret    

00801868 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801868:	55                   	push   %ebp
  801869:	89 e5                	mov    %esp,%ebp
  80186b:	83 ec 04             	sub    $0x4,%esp
  80186e:	8b 45 10             	mov    0x10(%ebp),%eax
  801871:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801874:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801878:	8b 45 08             	mov    0x8(%ebp),%eax
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	52                   	push   %edx
  801880:	ff 75 0c             	pushl  0xc(%ebp)
  801883:	50                   	push   %eax
  801884:	6a 00                	push   $0x0
  801886:	e8 b2 ff ff ff       	call   80183d <syscall>
  80188b:	83 c4 18             	add    $0x18,%esp
}
  80188e:	90                   	nop
  80188f:	c9                   	leave  
  801890:	c3                   	ret    

00801891 <sys_cgetc>:

int
sys_cgetc(void)
{
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	6a 01                	push   $0x1
  8018a0:	e8 98 ff ff ff       	call   80183d <syscall>
  8018a5:	83 c4 18             	add    $0x18,%esp
}
  8018a8:	c9                   	leave  
  8018a9:	c3                   	ret    

008018aa <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	52                   	push   %edx
  8018ba:	50                   	push   %eax
  8018bb:	6a 05                	push   $0x5
  8018bd:	e8 7b ff ff ff       	call   80183d <syscall>
  8018c2:	83 c4 18             	add    $0x18,%esp
}
  8018c5:	c9                   	leave  
  8018c6:	c3                   	ret    

008018c7 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018c7:	55                   	push   %ebp
  8018c8:	89 e5                	mov    %esp,%ebp
  8018ca:	56                   	push   %esi
  8018cb:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018cc:	8b 75 18             	mov    0x18(%ebp),%esi
  8018cf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018d2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018db:	56                   	push   %esi
  8018dc:	53                   	push   %ebx
  8018dd:	51                   	push   %ecx
  8018de:	52                   	push   %edx
  8018df:	50                   	push   %eax
  8018e0:	6a 06                	push   $0x6
  8018e2:	e8 56 ff ff ff       	call   80183d <syscall>
  8018e7:	83 c4 18             	add    $0x18,%esp
}
  8018ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018ed:	5b                   	pop    %ebx
  8018ee:	5e                   	pop    %esi
  8018ef:	5d                   	pop    %ebp
  8018f0:	c3                   	ret    

008018f1 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018f1:	55                   	push   %ebp
  8018f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	52                   	push   %edx
  801901:	50                   	push   %eax
  801902:	6a 07                	push   $0x7
  801904:	e8 34 ff ff ff       	call   80183d <syscall>
  801909:	83 c4 18             	add    $0x18,%esp
}
  80190c:	c9                   	leave  
  80190d:	c3                   	ret    

0080190e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	ff 75 0c             	pushl  0xc(%ebp)
  80191a:	ff 75 08             	pushl  0x8(%ebp)
  80191d:	6a 08                	push   $0x8
  80191f:	e8 19 ff ff ff       	call   80183d <syscall>
  801924:	83 c4 18             	add    $0x18,%esp
}
  801927:	c9                   	leave  
  801928:	c3                   	ret    

00801929 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801929:	55                   	push   %ebp
  80192a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 09                	push   $0x9
  801938:	e8 00 ff ff ff       	call   80183d <syscall>
  80193d:	83 c4 18             	add    $0x18,%esp
}
  801940:	c9                   	leave  
  801941:	c3                   	ret    

00801942 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 0a                	push   $0xa
  801951:	e8 e7 fe ff ff       	call   80183d <syscall>
  801956:	83 c4 18             	add    $0x18,%esp
}
  801959:	c9                   	leave  
  80195a:	c3                   	ret    

0080195b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 0b                	push   $0xb
  80196a:	e8 ce fe ff ff       	call   80183d <syscall>
  80196f:	83 c4 18             	add    $0x18,%esp
}
  801972:	c9                   	leave  
  801973:	c3                   	ret    

00801974 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	ff 75 0c             	pushl  0xc(%ebp)
  801980:	ff 75 08             	pushl  0x8(%ebp)
  801983:	6a 0f                	push   $0xf
  801985:	e8 b3 fe ff ff       	call   80183d <syscall>
  80198a:	83 c4 18             	add    $0x18,%esp
	return;
  80198d:	90                   	nop
}
  80198e:	c9                   	leave  
  80198f:	c3                   	ret    

00801990 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	ff 75 0c             	pushl  0xc(%ebp)
  80199c:	ff 75 08             	pushl  0x8(%ebp)
  80199f:	6a 10                	push   $0x10
  8019a1:	e8 97 fe ff ff       	call   80183d <syscall>
  8019a6:	83 c4 18             	add    $0x18,%esp
	return ;
  8019a9:	90                   	nop
}
  8019aa:	c9                   	leave  
  8019ab:	c3                   	ret    

008019ac <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019ac:	55                   	push   %ebp
  8019ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	ff 75 10             	pushl  0x10(%ebp)
  8019b6:	ff 75 0c             	pushl  0xc(%ebp)
  8019b9:	ff 75 08             	pushl  0x8(%ebp)
  8019bc:	6a 11                	push   $0x11
  8019be:	e8 7a fe ff ff       	call   80183d <syscall>
  8019c3:	83 c4 18             	add    $0x18,%esp
	return ;
  8019c6:	90                   	nop
}
  8019c7:	c9                   	leave  
  8019c8:	c3                   	ret    

008019c9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019c9:	55                   	push   %ebp
  8019ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 0c                	push   $0xc
  8019d8:	e8 60 fe ff ff       	call   80183d <syscall>
  8019dd:	83 c4 18             	add    $0x18,%esp
}
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	ff 75 08             	pushl  0x8(%ebp)
  8019f0:	6a 0d                	push   $0xd
  8019f2:	e8 46 fe ff ff       	call   80183d <syscall>
  8019f7:	83 c4 18             	add    $0x18,%esp
}
  8019fa:	c9                   	leave  
  8019fb:	c3                   	ret    

008019fc <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019fc:	55                   	push   %ebp
  8019fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 0e                	push   $0xe
  801a0b:	e8 2d fe ff ff       	call   80183d <syscall>
  801a10:	83 c4 18             	add    $0x18,%esp
}
  801a13:	90                   	nop
  801a14:	c9                   	leave  
  801a15:	c3                   	ret    

00801a16 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a16:	55                   	push   %ebp
  801a17:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 13                	push   $0x13
  801a25:	e8 13 fe ff ff       	call   80183d <syscall>
  801a2a:	83 c4 18             	add    $0x18,%esp
}
  801a2d:	90                   	nop
  801a2e:	c9                   	leave  
  801a2f:	c3                   	ret    

00801a30 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 14                	push   $0x14
  801a3f:	e8 f9 fd ff ff       	call   80183d <syscall>
  801a44:	83 c4 18             	add    $0x18,%esp
}
  801a47:	90                   	nop
  801a48:	c9                   	leave  
  801a49:	c3                   	ret    

00801a4a <sys_cputc>:


void
sys_cputc(const char c)
{
  801a4a:	55                   	push   %ebp
  801a4b:	89 e5                	mov    %esp,%ebp
  801a4d:	83 ec 04             	sub    $0x4,%esp
  801a50:	8b 45 08             	mov    0x8(%ebp),%eax
  801a53:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a56:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	50                   	push   %eax
  801a63:	6a 15                	push   $0x15
  801a65:	e8 d3 fd ff ff       	call   80183d <syscall>
  801a6a:	83 c4 18             	add    $0x18,%esp
}
  801a6d:	90                   	nop
  801a6e:	c9                   	leave  
  801a6f:	c3                   	ret    

00801a70 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a70:	55                   	push   %ebp
  801a71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 16                	push   $0x16
  801a7f:	e8 b9 fd ff ff       	call   80183d <syscall>
  801a84:	83 c4 18             	add    $0x18,%esp
}
  801a87:	90                   	nop
  801a88:	c9                   	leave  
  801a89:	c3                   	ret    

00801a8a <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a8a:	55                   	push   %ebp
  801a8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	ff 75 0c             	pushl  0xc(%ebp)
  801a99:	50                   	push   %eax
  801a9a:	6a 17                	push   $0x17
  801a9c:	e8 9c fd ff ff       	call   80183d <syscall>
  801aa1:	83 c4 18             	add    $0x18,%esp
}
  801aa4:	c9                   	leave  
  801aa5:	c3                   	ret    

00801aa6 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801aa9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aac:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	52                   	push   %edx
  801ab6:	50                   	push   %eax
  801ab7:	6a 1a                	push   $0x1a
  801ab9:	e8 7f fd ff ff       	call   80183d <syscall>
  801abe:	83 c4 18             	add    $0x18,%esp
}
  801ac1:	c9                   	leave  
  801ac2:	c3                   	ret    

00801ac3 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ac6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	52                   	push   %edx
  801ad3:	50                   	push   %eax
  801ad4:	6a 18                	push   $0x18
  801ad6:	e8 62 fd ff ff       	call   80183d <syscall>
  801adb:	83 c4 18             	add    $0x18,%esp
}
  801ade:	90                   	nop
  801adf:	c9                   	leave  
  801ae0:	c3                   	ret    

00801ae1 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ae4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	52                   	push   %edx
  801af1:	50                   	push   %eax
  801af2:	6a 19                	push   $0x19
  801af4:	e8 44 fd ff ff       	call   80183d <syscall>
  801af9:	83 c4 18             	add    $0x18,%esp
}
  801afc:	90                   	nop
  801afd:	c9                   	leave  
  801afe:	c3                   	ret    

00801aff <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801aff:	55                   	push   %ebp
  801b00:	89 e5                	mov    %esp,%ebp
  801b02:	83 ec 04             	sub    $0x4,%esp
  801b05:	8b 45 10             	mov    0x10(%ebp),%eax
  801b08:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b0b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b0e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b12:	8b 45 08             	mov    0x8(%ebp),%eax
  801b15:	6a 00                	push   $0x0
  801b17:	51                   	push   %ecx
  801b18:	52                   	push   %edx
  801b19:	ff 75 0c             	pushl  0xc(%ebp)
  801b1c:	50                   	push   %eax
  801b1d:	6a 1b                	push   $0x1b
  801b1f:	e8 19 fd ff ff       	call   80183d <syscall>
  801b24:	83 c4 18             	add    $0x18,%esp
}
  801b27:	c9                   	leave  
  801b28:	c3                   	ret    

00801b29 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b29:	55                   	push   %ebp
  801b2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	52                   	push   %edx
  801b39:	50                   	push   %eax
  801b3a:	6a 1c                	push   $0x1c
  801b3c:	e8 fc fc ff ff       	call   80183d <syscall>
  801b41:	83 c4 18             	add    $0x18,%esp
}
  801b44:	c9                   	leave  
  801b45:	c3                   	ret    

00801b46 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b46:	55                   	push   %ebp
  801b47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b49:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	51                   	push   %ecx
  801b57:	52                   	push   %edx
  801b58:	50                   	push   %eax
  801b59:	6a 1d                	push   $0x1d
  801b5b:	e8 dd fc ff ff       	call   80183d <syscall>
  801b60:	83 c4 18             	add    $0x18,%esp
}
  801b63:	c9                   	leave  
  801b64:	c3                   	ret    

00801b65 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b65:	55                   	push   %ebp
  801b66:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b68:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	52                   	push   %edx
  801b75:	50                   	push   %eax
  801b76:	6a 1e                	push   $0x1e
  801b78:	e8 c0 fc ff ff       	call   80183d <syscall>
  801b7d:	83 c4 18             	add    $0x18,%esp
}
  801b80:	c9                   	leave  
  801b81:	c3                   	ret    

00801b82 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b82:	55                   	push   %ebp
  801b83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 1f                	push   $0x1f
  801b91:	e8 a7 fc ff ff       	call   80183d <syscall>
  801b96:	83 c4 18             	add    $0x18,%esp
}
  801b99:	c9                   	leave  
  801b9a:	c3                   	ret    

00801b9b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b9b:	55                   	push   %ebp
  801b9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba1:	6a 00                	push   $0x0
  801ba3:	ff 75 14             	pushl  0x14(%ebp)
  801ba6:	ff 75 10             	pushl  0x10(%ebp)
  801ba9:	ff 75 0c             	pushl  0xc(%ebp)
  801bac:	50                   	push   %eax
  801bad:	6a 20                	push   $0x20
  801baf:	e8 89 fc ff ff       	call   80183d <syscall>
  801bb4:	83 c4 18             	add    $0x18,%esp
}
  801bb7:	c9                   	leave  
  801bb8:	c3                   	ret    

00801bb9 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	50                   	push   %eax
  801bc8:	6a 21                	push   $0x21
  801bca:	e8 6e fc ff ff       	call   80183d <syscall>
  801bcf:	83 c4 18             	add    $0x18,%esp
}
  801bd2:	90                   	nop
  801bd3:	c9                   	leave  
  801bd4:	c3                   	ret    

00801bd5 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bd5:	55                   	push   %ebp
  801bd6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	50                   	push   %eax
  801be4:	6a 22                	push   $0x22
  801be6:	e8 52 fc ff ff       	call   80183d <syscall>
  801beb:	83 c4 18             	add    $0x18,%esp
}
  801bee:	c9                   	leave  
  801bef:	c3                   	ret    

00801bf0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 02                	push   $0x2
  801bff:	e8 39 fc ff ff       	call   80183d <syscall>
  801c04:	83 c4 18             	add    $0x18,%esp
}
  801c07:	c9                   	leave  
  801c08:	c3                   	ret    

00801c09 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c09:	55                   	push   %ebp
  801c0a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	6a 03                	push   $0x3
  801c18:	e8 20 fc ff ff       	call   80183d <syscall>
  801c1d:	83 c4 18             	add    $0x18,%esp
}
  801c20:	c9                   	leave  
  801c21:	c3                   	ret    

00801c22 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 04                	push   $0x4
  801c31:	e8 07 fc ff ff       	call   80183d <syscall>
  801c36:	83 c4 18             	add    $0x18,%esp
}
  801c39:	c9                   	leave  
  801c3a:	c3                   	ret    

00801c3b <sys_exit_env>:


void sys_exit_env(void)
{
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 23                	push   $0x23
  801c4a:	e8 ee fb ff ff       	call   80183d <syscall>
  801c4f:	83 c4 18             	add    $0x18,%esp
}
  801c52:	90                   	nop
  801c53:	c9                   	leave  
  801c54:	c3                   	ret    

00801c55 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c55:	55                   	push   %ebp
  801c56:	89 e5                	mov    %esp,%ebp
  801c58:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c5b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c5e:	8d 50 04             	lea    0x4(%eax),%edx
  801c61:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	52                   	push   %edx
  801c6b:	50                   	push   %eax
  801c6c:	6a 24                	push   $0x24
  801c6e:	e8 ca fb ff ff       	call   80183d <syscall>
  801c73:	83 c4 18             	add    $0x18,%esp
	return result;
  801c76:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c79:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c7c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c7f:	89 01                	mov    %eax,(%ecx)
  801c81:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c84:	8b 45 08             	mov    0x8(%ebp),%eax
  801c87:	c9                   	leave  
  801c88:	c2 04 00             	ret    $0x4

00801c8b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c8b:	55                   	push   %ebp
  801c8c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	ff 75 10             	pushl  0x10(%ebp)
  801c95:	ff 75 0c             	pushl  0xc(%ebp)
  801c98:	ff 75 08             	pushl  0x8(%ebp)
  801c9b:	6a 12                	push   $0x12
  801c9d:	e8 9b fb ff ff       	call   80183d <syscall>
  801ca2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca5:	90                   	nop
}
  801ca6:	c9                   	leave  
  801ca7:	c3                   	ret    

00801ca8 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 25                	push   $0x25
  801cb7:	e8 81 fb ff ff       	call   80183d <syscall>
  801cbc:	83 c4 18             	add    $0x18,%esp
}
  801cbf:	c9                   	leave  
  801cc0:	c3                   	ret    

00801cc1 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801cc1:	55                   	push   %ebp
  801cc2:	89 e5                	mov    %esp,%ebp
  801cc4:	83 ec 04             	sub    $0x4,%esp
  801cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cca:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ccd:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	50                   	push   %eax
  801cda:	6a 26                	push   $0x26
  801cdc:	e8 5c fb ff ff       	call   80183d <syscall>
  801ce1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce4:	90                   	nop
}
  801ce5:	c9                   	leave  
  801ce6:	c3                   	ret    

00801ce7 <rsttst>:
void rsttst()
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 28                	push   $0x28
  801cf6:	e8 42 fb ff ff       	call   80183d <syscall>
  801cfb:	83 c4 18             	add    $0x18,%esp
	return ;
  801cfe:	90                   	nop
}
  801cff:	c9                   	leave  
  801d00:	c3                   	ret    

00801d01 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d01:	55                   	push   %ebp
  801d02:	89 e5                	mov    %esp,%ebp
  801d04:	83 ec 04             	sub    $0x4,%esp
  801d07:	8b 45 14             	mov    0x14(%ebp),%eax
  801d0a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d0d:	8b 55 18             	mov    0x18(%ebp),%edx
  801d10:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d14:	52                   	push   %edx
  801d15:	50                   	push   %eax
  801d16:	ff 75 10             	pushl  0x10(%ebp)
  801d19:	ff 75 0c             	pushl  0xc(%ebp)
  801d1c:	ff 75 08             	pushl  0x8(%ebp)
  801d1f:	6a 27                	push   $0x27
  801d21:	e8 17 fb ff ff       	call   80183d <syscall>
  801d26:	83 c4 18             	add    $0x18,%esp
	return ;
  801d29:	90                   	nop
}
  801d2a:	c9                   	leave  
  801d2b:	c3                   	ret    

00801d2c <chktst>:
void chktst(uint32 n)
{
  801d2c:	55                   	push   %ebp
  801d2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	ff 75 08             	pushl  0x8(%ebp)
  801d3a:	6a 29                	push   $0x29
  801d3c:	e8 fc fa ff ff       	call   80183d <syscall>
  801d41:	83 c4 18             	add    $0x18,%esp
	return ;
  801d44:	90                   	nop
}
  801d45:	c9                   	leave  
  801d46:	c3                   	ret    

00801d47 <inctst>:

void inctst()
{
  801d47:	55                   	push   %ebp
  801d48:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 2a                	push   $0x2a
  801d56:	e8 e2 fa ff ff       	call   80183d <syscall>
  801d5b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d5e:	90                   	nop
}
  801d5f:	c9                   	leave  
  801d60:	c3                   	ret    

00801d61 <gettst>:
uint32 gettst()
{
  801d61:	55                   	push   %ebp
  801d62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 2b                	push   $0x2b
  801d70:	e8 c8 fa ff ff       	call   80183d <syscall>
  801d75:	83 c4 18             	add    $0x18,%esp
}
  801d78:	c9                   	leave  
  801d79:	c3                   	ret    

00801d7a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
  801d7d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 2c                	push   $0x2c
  801d8c:	e8 ac fa ff ff       	call   80183d <syscall>
  801d91:	83 c4 18             	add    $0x18,%esp
  801d94:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d97:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d9b:	75 07                	jne    801da4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d9d:	b8 01 00 00 00       	mov    $0x1,%eax
  801da2:	eb 05                	jmp    801da9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801da4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da9:	c9                   	leave  
  801daa:	c3                   	ret    

00801dab <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801dab:	55                   	push   %ebp
  801dac:	89 e5                	mov    %esp,%ebp
  801dae:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 2c                	push   $0x2c
  801dbd:	e8 7b fa ff ff       	call   80183d <syscall>
  801dc2:	83 c4 18             	add    $0x18,%esp
  801dc5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801dc8:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801dcc:	75 07                	jne    801dd5 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801dce:	b8 01 00 00 00       	mov    $0x1,%eax
  801dd3:	eb 05                	jmp    801dda <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801dd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dda:	c9                   	leave  
  801ddb:	c3                   	ret    

00801ddc <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ddc:	55                   	push   %ebp
  801ddd:	89 e5                	mov    %esp,%ebp
  801ddf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	6a 2c                	push   $0x2c
  801dee:	e8 4a fa ff ff       	call   80183d <syscall>
  801df3:	83 c4 18             	add    $0x18,%esp
  801df6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801df9:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801dfd:	75 07                	jne    801e06 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801dff:	b8 01 00 00 00       	mov    $0x1,%eax
  801e04:	eb 05                	jmp    801e0b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e0b:	c9                   	leave  
  801e0c:	c3                   	ret    

00801e0d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
  801e10:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 2c                	push   $0x2c
  801e1f:	e8 19 fa ff ff       	call   80183d <syscall>
  801e24:	83 c4 18             	add    $0x18,%esp
  801e27:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e2a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e2e:	75 07                	jne    801e37 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e30:	b8 01 00 00 00       	mov    $0x1,%eax
  801e35:	eb 05                	jmp    801e3c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e37:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e3c:	c9                   	leave  
  801e3d:	c3                   	ret    

00801e3e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e3e:	55                   	push   %ebp
  801e3f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	6a 00                	push   $0x0
  801e47:	6a 00                	push   $0x0
  801e49:	ff 75 08             	pushl  0x8(%ebp)
  801e4c:	6a 2d                	push   $0x2d
  801e4e:	e8 ea f9 ff ff       	call   80183d <syscall>
  801e53:	83 c4 18             	add    $0x18,%esp
	return ;
  801e56:	90                   	nop
}
  801e57:	c9                   	leave  
  801e58:	c3                   	ret    

00801e59 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e59:	55                   	push   %ebp
  801e5a:	89 e5                	mov    %esp,%ebp
  801e5c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e5d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e60:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e63:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e66:	8b 45 08             	mov    0x8(%ebp),%eax
  801e69:	6a 00                	push   $0x0
  801e6b:	53                   	push   %ebx
  801e6c:	51                   	push   %ecx
  801e6d:	52                   	push   %edx
  801e6e:	50                   	push   %eax
  801e6f:	6a 2e                	push   $0x2e
  801e71:	e8 c7 f9 ff ff       	call   80183d <syscall>
  801e76:	83 c4 18             	add    $0x18,%esp
}
  801e79:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e7c:	c9                   	leave  
  801e7d:	c3                   	ret    

00801e7e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e7e:	55                   	push   %ebp
  801e7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e81:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e84:	8b 45 08             	mov    0x8(%ebp),%eax
  801e87:	6a 00                	push   $0x0
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 00                	push   $0x0
  801e8d:	52                   	push   %edx
  801e8e:	50                   	push   %eax
  801e8f:	6a 2f                	push   $0x2f
  801e91:	e8 a7 f9 ff ff       	call   80183d <syscall>
  801e96:	83 c4 18             	add    $0x18,%esp
}
  801e99:	c9                   	leave  
  801e9a:	c3                   	ret    

00801e9b <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e9b:	55                   	push   %ebp
  801e9c:	89 e5                	mov    %esp,%ebp
  801e9e:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801ea1:	83 ec 0c             	sub    $0xc,%esp
  801ea4:	68 40 3b 80 00       	push   $0x803b40
  801ea9:	e8 c3 e6 ff ff       	call   800571 <cprintf>
  801eae:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801eb1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801eb8:	83 ec 0c             	sub    $0xc,%esp
  801ebb:	68 6c 3b 80 00       	push   $0x803b6c
  801ec0:	e8 ac e6 ff ff       	call   800571 <cprintf>
  801ec5:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801ec8:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ecc:	a1 38 41 80 00       	mov    0x804138,%eax
  801ed1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ed4:	eb 56                	jmp    801f2c <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ed6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801eda:	74 1c                	je     801ef8 <print_mem_block_lists+0x5d>
  801edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801edf:	8b 50 08             	mov    0x8(%eax),%edx
  801ee2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ee5:	8b 48 08             	mov    0x8(%eax),%ecx
  801ee8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eeb:	8b 40 0c             	mov    0xc(%eax),%eax
  801eee:	01 c8                	add    %ecx,%eax
  801ef0:	39 c2                	cmp    %eax,%edx
  801ef2:	73 04                	jae    801ef8 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ef4:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efb:	8b 50 08             	mov    0x8(%eax),%edx
  801efe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f01:	8b 40 0c             	mov    0xc(%eax),%eax
  801f04:	01 c2                	add    %eax,%edx
  801f06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f09:	8b 40 08             	mov    0x8(%eax),%eax
  801f0c:	83 ec 04             	sub    $0x4,%esp
  801f0f:	52                   	push   %edx
  801f10:	50                   	push   %eax
  801f11:	68 81 3b 80 00       	push   $0x803b81
  801f16:	e8 56 e6 ff ff       	call   800571 <cprintf>
  801f1b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f21:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f24:	a1 40 41 80 00       	mov    0x804140,%eax
  801f29:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f30:	74 07                	je     801f39 <print_mem_block_lists+0x9e>
  801f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f35:	8b 00                	mov    (%eax),%eax
  801f37:	eb 05                	jmp    801f3e <print_mem_block_lists+0xa3>
  801f39:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3e:	a3 40 41 80 00       	mov    %eax,0x804140
  801f43:	a1 40 41 80 00       	mov    0x804140,%eax
  801f48:	85 c0                	test   %eax,%eax
  801f4a:	75 8a                	jne    801ed6 <print_mem_block_lists+0x3b>
  801f4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f50:	75 84                	jne    801ed6 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f52:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f56:	75 10                	jne    801f68 <print_mem_block_lists+0xcd>
  801f58:	83 ec 0c             	sub    $0xc,%esp
  801f5b:	68 90 3b 80 00       	push   $0x803b90
  801f60:	e8 0c e6 ff ff       	call   800571 <cprintf>
  801f65:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f68:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f6f:	83 ec 0c             	sub    $0xc,%esp
  801f72:	68 b4 3b 80 00       	push   $0x803bb4
  801f77:	e8 f5 e5 ff ff       	call   800571 <cprintf>
  801f7c:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f7f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f83:	a1 40 40 80 00       	mov    0x804040,%eax
  801f88:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f8b:	eb 56                	jmp    801fe3 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f8d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f91:	74 1c                	je     801faf <print_mem_block_lists+0x114>
  801f93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f96:	8b 50 08             	mov    0x8(%eax),%edx
  801f99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f9c:	8b 48 08             	mov    0x8(%eax),%ecx
  801f9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa2:	8b 40 0c             	mov    0xc(%eax),%eax
  801fa5:	01 c8                	add    %ecx,%eax
  801fa7:	39 c2                	cmp    %eax,%edx
  801fa9:	73 04                	jae    801faf <print_mem_block_lists+0x114>
			sorted = 0 ;
  801fab:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb2:	8b 50 08             	mov    0x8(%eax),%edx
  801fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb8:	8b 40 0c             	mov    0xc(%eax),%eax
  801fbb:	01 c2                	add    %eax,%edx
  801fbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc0:	8b 40 08             	mov    0x8(%eax),%eax
  801fc3:	83 ec 04             	sub    $0x4,%esp
  801fc6:	52                   	push   %edx
  801fc7:	50                   	push   %eax
  801fc8:	68 81 3b 80 00       	push   $0x803b81
  801fcd:	e8 9f e5 ff ff       	call   800571 <cprintf>
  801fd2:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fdb:	a1 48 40 80 00       	mov    0x804048,%eax
  801fe0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fe3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fe7:	74 07                	je     801ff0 <print_mem_block_lists+0x155>
  801fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fec:	8b 00                	mov    (%eax),%eax
  801fee:	eb 05                	jmp    801ff5 <print_mem_block_lists+0x15a>
  801ff0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff5:	a3 48 40 80 00       	mov    %eax,0x804048
  801ffa:	a1 48 40 80 00       	mov    0x804048,%eax
  801fff:	85 c0                	test   %eax,%eax
  802001:	75 8a                	jne    801f8d <print_mem_block_lists+0xf2>
  802003:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802007:	75 84                	jne    801f8d <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802009:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80200d:	75 10                	jne    80201f <print_mem_block_lists+0x184>
  80200f:	83 ec 0c             	sub    $0xc,%esp
  802012:	68 cc 3b 80 00       	push   $0x803bcc
  802017:	e8 55 e5 ff ff       	call   800571 <cprintf>
  80201c:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80201f:	83 ec 0c             	sub    $0xc,%esp
  802022:	68 40 3b 80 00       	push   $0x803b40
  802027:	e8 45 e5 ff ff       	call   800571 <cprintf>
  80202c:	83 c4 10             	add    $0x10,%esp

}
  80202f:	90                   	nop
  802030:	c9                   	leave  
  802031:	c3                   	ret    

00802032 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802032:	55                   	push   %ebp
  802033:	89 e5                	mov    %esp,%ebp
  802035:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  802038:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  80203f:	00 00 00 
  802042:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802049:	00 00 00 
  80204c:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802053:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802056:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80205d:	e9 9e 00 00 00       	jmp    802100 <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802062:	a1 50 40 80 00       	mov    0x804050,%eax
  802067:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80206a:	c1 e2 04             	shl    $0x4,%edx
  80206d:	01 d0                	add    %edx,%eax
  80206f:	85 c0                	test   %eax,%eax
  802071:	75 14                	jne    802087 <initialize_MemBlocksList+0x55>
  802073:	83 ec 04             	sub    $0x4,%esp
  802076:	68 f4 3b 80 00       	push   $0x803bf4
  80207b:	6a 47                	push   $0x47
  80207d:	68 17 3c 80 00       	push   $0x803c17
  802082:	e8 36 e2 ff ff       	call   8002bd <_panic>
  802087:	a1 50 40 80 00       	mov    0x804050,%eax
  80208c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80208f:	c1 e2 04             	shl    $0x4,%edx
  802092:	01 d0                	add    %edx,%eax
  802094:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80209a:	89 10                	mov    %edx,(%eax)
  80209c:	8b 00                	mov    (%eax),%eax
  80209e:	85 c0                	test   %eax,%eax
  8020a0:	74 18                	je     8020ba <initialize_MemBlocksList+0x88>
  8020a2:	a1 48 41 80 00       	mov    0x804148,%eax
  8020a7:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8020ad:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8020b0:	c1 e1 04             	shl    $0x4,%ecx
  8020b3:	01 ca                	add    %ecx,%edx
  8020b5:	89 50 04             	mov    %edx,0x4(%eax)
  8020b8:	eb 12                	jmp    8020cc <initialize_MemBlocksList+0x9a>
  8020ba:	a1 50 40 80 00       	mov    0x804050,%eax
  8020bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020c2:	c1 e2 04             	shl    $0x4,%edx
  8020c5:	01 d0                	add    %edx,%eax
  8020c7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8020cc:	a1 50 40 80 00       	mov    0x804050,%eax
  8020d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020d4:	c1 e2 04             	shl    $0x4,%edx
  8020d7:	01 d0                	add    %edx,%eax
  8020d9:	a3 48 41 80 00       	mov    %eax,0x804148
  8020de:	a1 50 40 80 00       	mov    0x804050,%eax
  8020e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020e6:	c1 e2 04             	shl    $0x4,%edx
  8020e9:	01 d0                	add    %edx,%eax
  8020eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020f2:	a1 54 41 80 00       	mov    0x804154,%eax
  8020f7:	40                   	inc    %eax
  8020f8:	a3 54 41 80 00       	mov    %eax,0x804154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  8020fd:	ff 45 f4             	incl   -0xc(%ebp)
  802100:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802103:	3b 45 08             	cmp    0x8(%ebp),%eax
  802106:	0f 82 56 ff ff ff    	jb     802062 <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  80210c:	90                   	nop
  80210d:	c9                   	leave  
  80210e:	c3                   	ret    

0080210f <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80210f:	55                   	push   %ebp
  802110:	89 e5                	mov    %esp,%ebp
  802112:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802115:	8b 45 08             	mov    0x8(%ebp),%eax
  802118:	8b 00                	mov    (%eax),%eax
  80211a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80211d:	eb 19                	jmp    802138 <find_block+0x29>
	{
		if(element->sva == va){
  80211f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802122:	8b 40 08             	mov    0x8(%eax),%eax
  802125:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802128:	75 05                	jne    80212f <find_block+0x20>
			 		return element;
  80212a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80212d:	eb 36                	jmp    802165 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  80212f:	8b 45 08             	mov    0x8(%ebp),%eax
  802132:	8b 40 08             	mov    0x8(%eax),%eax
  802135:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802138:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80213c:	74 07                	je     802145 <find_block+0x36>
  80213e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802141:	8b 00                	mov    (%eax),%eax
  802143:	eb 05                	jmp    80214a <find_block+0x3b>
  802145:	b8 00 00 00 00       	mov    $0x0,%eax
  80214a:	8b 55 08             	mov    0x8(%ebp),%edx
  80214d:	89 42 08             	mov    %eax,0x8(%edx)
  802150:	8b 45 08             	mov    0x8(%ebp),%eax
  802153:	8b 40 08             	mov    0x8(%eax),%eax
  802156:	85 c0                	test   %eax,%eax
  802158:	75 c5                	jne    80211f <find_block+0x10>
  80215a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80215e:	75 bf                	jne    80211f <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  802160:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802165:	c9                   	leave  
  802166:	c3                   	ret    

00802167 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802167:	55                   	push   %ebp
  802168:	89 e5                	mov    %esp,%ebp
  80216a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  80216d:	a1 44 40 80 00       	mov    0x804044,%eax
  802172:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  802175:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80217a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  80217d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802181:	74 0a                	je     80218d <insert_sorted_allocList+0x26>
  802183:	8b 45 08             	mov    0x8(%ebp),%eax
  802186:	8b 40 08             	mov    0x8(%eax),%eax
  802189:	85 c0                	test   %eax,%eax
  80218b:	75 65                	jne    8021f2 <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80218d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802191:	75 14                	jne    8021a7 <insert_sorted_allocList+0x40>
  802193:	83 ec 04             	sub    $0x4,%esp
  802196:	68 f4 3b 80 00       	push   $0x803bf4
  80219b:	6a 6e                	push   $0x6e
  80219d:	68 17 3c 80 00       	push   $0x803c17
  8021a2:	e8 16 e1 ff ff       	call   8002bd <_panic>
  8021a7:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8021ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b0:	89 10                	mov    %edx,(%eax)
  8021b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b5:	8b 00                	mov    (%eax),%eax
  8021b7:	85 c0                	test   %eax,%eax
  8021b9:	74 0d                	je     8021c8 <insert_sorted_allocList+0x61>
  8021bb:	a1 40 40 80 00       	mov    0x804040,%eax
  8021c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8021c3:	89 50 04             	mov    %edx,0x4(%eax)
  8021c6:	eb 08                	jmp    8021d0 <insert_sorted_allocList+0x69>
  8021c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cb:	a3 44 40 80 00       	mov    %eax,0x804044
  8021d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d3:	a3 40 40 80 00       	mov    %eax,0x804040
  8021d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021e2:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021e7:	40                   	inc    %eax
  8021e8:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8021ed:	e9 cf 01 00 00       	jmp    8023c1 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  8021f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f5:	8b 50 08             	mov    0x8(%eax),%edx
  8021f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fb:	8b 40 08             	mov    0x8(%eax),%eax
  8021fe:	39 c2                	cmp    %eax,%edx
  802200:	73 65                	jae    802267 <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802202:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802206:	75 14                	jne    80221c <insert_sorted_allocList+0xb5>
  802208:	83 ec 04             	sub    $0x4,%esp
  80220b:	68 30 3c 80 00       	push   $0x803c30
  802210:	6a 72                	push   $0x72
  802212:	68 17 3c 80 00       	push   $0x803c17
  802217:	e8 a1 e0 ff ff       	call   8002bd <_panic>
  80221c:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802222:	8b 45 08             	mov    0x8(%ebp),%eax
  802225:	89 50 04             	mov    %edx,0x4(%eax)
  802228:	8b 45 08             	mov    0x8(%ebp),%eax
  80222b:	8b 40 04             	mov    0x4(%eax),%eax
  80222e:	85 c0                	test   %eax,%eax
  802230:	74 0c                	je     80223e <insert_sorted_allocList+0xd7>
  802232:	a1 44 40 80 00       	mov    0x804044,%eax
  802237:	8b 55 08             	mov    0x8(%ebp),%edx
  80223a:	89 10                	mov    %edx,(%eax)
  80223c:	eb 08                	jmp    802246 <insert_sorted_allocList+0xdf>
  80223e:	8b 45 08             	mov    0x8(%ebp),%eax
  802241:	a3 40 40 80 00       	mov    %eax,0x804040
  802246:	8b 45 08             	mov    0x8(%ebp),%eax
  802249:	a3 44 40 80 00       	mov    %eax,0x804044
  80224e:	8b 45 08             	mov    0x8(%ebp),%eax
  802251:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802257:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80225c:	40                   	inc    %eax
  80225d:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  802262:	e9 5a 01 00 00       	jmp    8023c1 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  802267:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80226a:	8b 50 08             	mov    0x8(%eax),%edx
  80226d:	8b 45 08             	mov    0x8(%ebp),%eax
  802270:	8b 40 08             	mov    0x8(%eax),%eax
  802273:	39 c2                	cmp    %eax,%edx
  802275:	75 70                	jne    8022e7 <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  802277:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80227b:	74 06                	je     802283 <insert_sorted_allocList+0x11c>
  80227d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802281:	75 14                	jne    802297 <insert_sorted_allocList+0x130>
  802283:	83 ec 04             	sub    $0x4,%esp
  802286:	68 54 3c 80 00       	push   $0x803c54
  80228b:	6a 75                	push   $0x75
  80228d:	68 17 3c 80 00       	push   $0x803c17
  802292:	e8 26 e0 ff ff       	call   8002bd <_panic>
  802297:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80229a:	8b 10                	mov    (%eax),%edx
  80229c:	8b 45 08             	mov    0x8(%ebp),%eax
  80229f:	89 10                	mov    %edx,(%eax)
  8022a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a4:	8b 00                	mov    (%eax),%eax
  8022a6:	85 c0                	test   %eax,%eax
  8022a8:	74 0b                	je     8022b5 <insert_sorted_allocList+0x14e>
  8022aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ad:	8b 00                	mov    (%eax),%eax
  8022af:	8b 55 08             	mov    0x8(%ebp),%edx
  8022b2:	89 50 04             	mov    %edx,0x4(%eax)
  8022b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8022bb:	89 10                	mov    %edx,(%eax)
  8022bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022c3:	89 50 04             	mov    %edx,0x4(%eax)
  8022c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c9:	8b 00                	mov    (%eax),%eax
  8022cb:	85 c0                	test   %eax,%eax
  8022cd:	75 08                	jne    8022d7 <insert_sorted_allocList+0x170>
  8022cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d2:	a3 44 40 80 00       	mov    %eax,0x804044
  8022d7:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022dc:	40                   	inc    %eax
  8022dd:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  8022e2:	e9 da 00 00 00       	jmp    8023c1 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  8022e7:	a1 40 40 80 00       	mov    0x804040,%eax
  8022ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022ef:	e9 9d 00 00 00       	jmp    802391 <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  8022f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f7:	8b 00                	mov    (%eax),%eax
  8022f9:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  8022fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ff:	8b 50 08             	mov    0x8(%eax),%edx
  802302:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802305:	8b 40 08             	mov    0x8(%eax),%eax
  802308:	39 c2                	cmp    %eax,%edx
  80230a:	76 7d                	jbe    802389 <insert_sorted_allocList+0x222>
  80230c:	8b 45 08             	mov    0x8(%ebp),%eax
  80230f:	8b 50 08             	mov    0x8(%eax),%edx
  802312:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802315:	8b 40 08             	mov    0x8(%eax),%eax
  802318:	39 c2                	cmp    %eax,%edx
  80231a:	73 6d                	jae    802389 <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  80231c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802320:	74 06                	je     802328 <insert_sorted_allocList+0x1c1>
  802322:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802326:	75 14                	jne    80233c <insert_sorted_allocList+0x1d5>
  802328:	83 ec 04             	sub    $0x4,%esp
  80232b:	68 54 3c 80 00       	push   $0x803c54
  802330:	6a 7c                	push   $0x7c
  802332:	68 17 3c 80 00       	push   $0x803c17
  802337:	e8 81 df ff ff       	call   8002bd <_panic>
  80233c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233f:	8b 10                	mov    (%eax),%edx
  802341:	8b 45 08             	mov    0x8(%ebp),%eax
  802344:	89 10                	mov    %edx,(%eax)
  802346:	8b 45 08             	mov    0x8(%ebp),%eax
  802349:	8b 00                	mov    (%eax),%eax
  80234b:	85 c0                	test   %eax,%eax
  80234d:	74 0b                	je     80235a <insert_sorted_allocList+0x1f3>
  80234f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802352:	8b 00                	mov    (%eax),%eax
  802354:	8b 55 08             	mov    0x8(%ebp),%edx
  802357:	89 50 04             	mov    %edx,0x4(%eax)
  80235a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235d:	8b 55 08             	mov    0x8(%ebp),%edx
  802360:	89 10                	mov    %edx,(%eax)
  802362:	8b 45 08             	mov    0x8(%ebp),%eax
  802365:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802368:	89 50 04             	mov    %edx,0x4(%eax)
  80236b:	8b 45 08             	mov    0x8(%ebp),%eax
  80236e:	8b 00                	mov    (%eax),%eax
  802370:	85 c0                	test   %eax,%eax
  802372:	75 08                	jne    80237c <insert_sorted_allocList+0x215>
  802374:	8b 45 08             	mov    0x8(%ebp),%eax
  802377:	a3 44 40 80 00       	mov    %eax,0x804044
  80237c:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802381:	40                   	inc    %eax
  802382:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802387:	eb 38                	jmp    8023c1 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802389:	a1 48 40 80 00       	mov    0x804048,%eax
  80238e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802391:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802395:	74 07                	je     80239e <insert_sorted_allocList+0x237>
  802397:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239a:	8b 00                	mov    (%eax),%eax
  80239c:	eb 05                	jmp    8023a3 <insert_sorted_allocList+0x23c>
  80239e:	b8 00 00 00 00       	mov    $0x0,%eax
  8023a3:	a3 48 40 80 00       	mov    %eax,0x804048
  8023a8:	a1 48 40 80 00       	mov    0x804048,%eax
  8023ad:	85 c0                	test   %eax,%eax
  8023af:	0f 85 3f ff ff ff    	jne    8022f4 <insert_sorted_allocList+0x18d>
  8023b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023b9:	0f 85 35 ff ff ff    	jne    8022f4 <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  8023bf:	eb 00                	jmp    8023c1 <insert_sorted_allocList+0x25a>
  8023c1:	90                   	nop
  8023c2:	c9                   	leave  
  8023c3:	c3                   	ret    

008023c4 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8023c4:	55                   	push   %ebp
  8023c5:	89 e5                	mov    %esp,%ebp
  8023c7:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  8023ca:	a1 38 41 80 00       	mov    0x804138,%eax
  8023cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023d2:	e9 6b 02 00 00       	jmp    802642 <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  8023d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023da:	8b 40 0c             	mov    0xc(%eax),%eax
  8023dd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023e0:	0f 85 90 00 00 00    	jne    802476 <alloc_block_FF+0xb2>
			  temp=element;
  8023e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e9:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  8023ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023f0:	75 17                	jne    802409 <alloc_block_FF+0x45>
  8023f2:	83 ec 04             	sub    $0x4,%esp
  8023f5:	68 88 3c 80 00       	push   $0x803c88
  8023fa:	68 92 00 00 00       	push   $0x92
  8023ff:	68 17 3c 80 00       	push   $0x803c17
  802404:	e8 b4 de ff ff       	call   8002bd <_panic>
  802409:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240c:	8b 00                	mov    (%eax),%eax
  80240e:	85 c0                	test   %eax,%eax
  802410:	74 10                	je     802422 <alloc_block_FF+0x5e>
  802412:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802415:	8b 00                	mov    (%eax),%eax
  802417:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80241a:	8b 52 04             	mov    0x4(%edx),%edx
  80241d:	89 50 04             	mov    %edx,0x4(%eax)
  802420:	eb 0b                	jmp    80242d <alloc_block_FF+0x69>
  802422:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802425:	8b 40 04             	mov    0x4(%eax),%eax
  802428:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80242d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802430:	8b 40 04             	mov    0x4(%eax),%eax
  802433:	85 c0                	test   %eax,%eax
  802435:	74 0f                	je     802446 <alloc_block_FF+0x82>
  802437:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243a:	8b 40 04             	mov    0x4(%eax),%eax
  80243d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802440:	8b 12                	mov    (%edx),%edx
  802442:	89 10                	mov    %edx,(%eax)
  802444:	eb 0a                	jmp    802450 <alloc_block_FF+0x8c>
  802446:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802449:	8b 00                	mov    (%eax),%eax
  80244b:	a3 38 41 80 00       	mov    %eax,0x804138
  802450:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802453:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802459:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802463:	a1 44 41 80 00       	mov    0x804144,%eax
  802468:	48                   	dec    %eax
  802469:	a3 44 41 80 00       	mov    %eax,0x804144
			  return temp;
  80246e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802471:	e9 ff 01 00 00       	jmp    802675 <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  802476:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802479:	8b 40 0c             	mov    0xc(%eax),%eax
  80247c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80247f:	0f 86 b5 01 00 00    	jbe    80263a <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  802485:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802488:	8b 40 0c             	mov    0xc(%eax),%eax
  80248b:	2b 45 08             	sub    0x8(%ebp),%eax
  80248e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  802491:	a1 48 41 80 00       	mov    0x804148,%eax
  802496:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  802499:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80249d:	75 17                	jne    8024b6 <alloc_block_FF+0xf2>
  80249f:	83 ec 04             	sub    $0x4,%esp
  8024a2:	68 88 3c 80 00       	push   $0x803c88
  8024a7:	68 99 00 00 00       	push   $0x99
  8024ac:	68 17 3c 80 00       	push   $0x803c17
  8024b1:	e8 07 de ff ff       	call   8002bd <_panic>
  8024b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024b9:	8b 00                	mov    (%eax),%eax
  8024bb:	85 c0                	test   %eax,%eax
  8024bd:	74 10                	je     8024cf <alloc_block_FF+0x10b>
  8024bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024c2:	8b 00                	mov    (%eax),%eax
  8024c4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024c7:	8b 52 04             	mov    0x4(%edx),%edx
  8024ca:	89 50 04             	mov    %edx,0x4(%eax)
  8024cd:	eb 0b                	jmp    8024da <alloc_block_FF+0x116>
  8024cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024d2:	8b 40 04             	mov    0x4(%eax),%eax
  8024d5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8024da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024dd:	8b 40 04             	mov    0x4(%eax),%eax
  8024e0:	85 c0                	test   %eax,%eax
  8024e2:	74 0f                	je     8024f3 <alloc_block_FF+0x12f>
  8024e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024e7:	8b 40 04             	mov    0x4(%eax),%eax
  8024ea:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024ed:	8b 12                	mov    (%edx),%edx
  8024ef:	89 10                	mov    %edx,(%eax)
  8024f1:	eb 0a                	jmp    8024fd <alloc_block_FF+0x139>
  8024f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024f6:	8b 00                	mov    (%eax),%eax
  8024f8:	a3 48 41 80 00       	mov    %eax,0x804148
  8024fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802500:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802506:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802509:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802510:	a1 54 41 80 00       	mov    0x804154,%eax
  802515:	48                   	dec    %eax
  802516:	a3 54 41 80 00       	mov    %eax,0x804154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  80251b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80251f:	75 17                	jne    802538 <alloc_block_FF+0x174>
  802521:	83 ec 04             	sub    $0x4,%esp
  802524:	68 30 3c 80 00       	push   $0x803c30
  802529:	68 9a 00 00 00       	push   $0x9a
  80252e:	68 17 3c 80 00       	push   $0x803c17
  802533:	e8 85 dd ff ff       	call   8002bd <_panic>
  802538:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  80253e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802541:	89 50 04             	mov    %edx,0x4(%eax)
  802544:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802547:	8b 40 04             	mov    0x4(%eax),%eax
  80254a:	85 c0                	test   %eax,%eax
  80254c:	74 0c                	je     80255a <alloc_block_FF+0x196>
  80254e:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802553:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802556:	89 10                	mov    %edx,(%eax)
  802558:	eb 08                	jmp    802562 <alloc_block_FF+0x19e>
  80255a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80255d:	a3 38 41 80 00       	mov    %eax,0x804138
  802562:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802565:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80256a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80256d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802573:	a1 44 41 80 00       	mov    0x804144,%eax
  802578:	40                   	inc    %eax
  802579:	a3 44 41 80 00       	mov    %eax,0x804144
		  // setting the size & sva
		  new_block->size=size;
  80257e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802581:	8b 55 08             	mov    0x8(%ebp),%edx
  802584:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  802587:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258a:	8b 50 08             	mov    0x8(%eax),%edx
  80258d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802590:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  802593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802596:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802599:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  80259c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259f:	8b 50 08             	mov    0x8(%eax),%edx
  8025a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a5:	01 c2                	add    %eax,%edx
  8025a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025aa:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  8025ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025b0:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  8025b3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025b7:	75 17                	jne    8025d0 <alloc_block_FF+0x20c>
  8025b9:	83 ec 04             	sub    $0x4,%esp
  8025bc:	68 88 3c 80 00       	push   $0x803c88
  8025c1:	68 a2 00 00 00       	push   $0xa2
  8025c6:	68 17 3c 80 00       	push   $0x803c17
  8025cb:	e8 ed dc ff ff       	call   8002bd <_panic>
  8025d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d3:	8b 00                	mov    (%eax),%eax
  8025d5:	85 c0                	test   %eax,%eax
  8025d7:	74 10                	je     8025e9 <alloc_block_FF+0x225>
  8025d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025dc:	8b 00                	mov    (%eax),%eax
  8025de:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025e1:	8b 52 04             	mov    0x4(%edx),%edx
  8025e4:	89 50 04             	mov    %edx,0x4(%eax)
  8025e7:	eb 0b                	jmp    8025f4 <alloc_block_FF+0x230>
  8025e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ec:	8b 40 04             	mov    0x4(%eax),%eax
  8025ef:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f7:	8b 40 04             	mov    0x4(%eax),%eax
  8025fa:	85 c0                	test   %eax,%eax
  8025fc:	74 0f                	je     80260d <alloc_block_FF+0x249>
  8025fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802601:	8b 40 04             	mov    0x4(%eax),%eax
  802604:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802607:	8b 12                	mov    (%edx),%edx
  802609:	89 10                	mov    %edx,(%eax)
  80260b:	eb 0a                	jmp    802617 <alloc_block_FF+0x253>
  80260d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802610:	8b 00                	mov    (%eax),%eax
  802612:	a3 38 41 80 00       	mov    %eax,0x804138
  802617:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80261a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802620:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802623:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80262a:	a1 44 41 80 00       	mov    0x804144,%eax
  80262f:	48                   	dec    %eax
  802630:	a3 44 41 80 00       	mov    %eax,0x804144
		  return temp;
  802635:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802638:	eb 3b                	jmp    802675 <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  80263a:	a1 40 41 80 00       	mov    0x804140,%eax
  80263f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802642:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802646:	74 07                	je     80264f <alloc_block_FF+0x28b>
  802648:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264b:	8b 00                	mov    (%eax),%eax
  80264d:	eb 05                	jmp    802654 <alloc_block_FF+0x290>
  80264f:	b8 00 00 00 00       	mov    $0x0,%eax
  802654:	a3 40 41 80 00       	mov    %eax,0x804140
  802659:	a1 40 41 80 00       	mov    0x804140,%eax
  80265e:	85 c0                	test   %eax,%eax
  802660:	0f 85 71 fd ff ff    	jne    8023d7 <alloc_block_FF+0x13>
  802666:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80266a:	0f 85 67 fd ff ff    	jne    8023d7 <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  802670:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802675:	c9                   	leave  
  802676:	c3                   	ret    

00802677 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802677:	55                   	push   %ebp
  802678:	89 e5                	mov    %esp,%ebp
  80267a:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  80267d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  802684:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  80268b:	a1 38 41 80 00       	mov    0x804138,%eax
  802690:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802693:	e9 d3 00 00 00       	jmp    80276b <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  802698:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80269b:	8b 40 0c             	mov    0xc(%eax),%eax
  80269e:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026a1:	0f 85 90 00 00 00    	jne    802737 <alloc_block_BF+0xc0>
	   temp = element;
  8026a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026aa:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  8026ad:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026b1:	75 17                	jne    8026ca <alloc_block_BF+0x53>
  8026b3:	83 ec 04             	sub    $0x4,%esp
  8026b6:	68 88 3c 80 00       	push   $0x803c88
  8026bb:	68 bd 00 00 00       	push   $0xbd
  8026c0:	68 17 3c 80 00       	push   $0x803c17
  8026c5:	e8 f3 db ff ff       	call   8002bd <_panic>
  8026ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026cd:	8b 00                	mov    (%eax),%eax
  8026cf:	85 c0                	test   %eax,%eax
  8026d1:	74 10                	je     8026e3 <alloc_block_BF+0x6c>
  8026d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026d6:	8b 00                	mov    (%eax),%eax
  8026d8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026db:	8b 52 04             	mov    0x4(%edx),%edx
  8026de:	89 50 04             	mov    %edx,0x4(%eax)
  8026e1:	eb 0b                	jmp    8026ee <alloc_block_BF+0x77>
  8026e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026e6:	8b 40 04             	mov    0x4(%eax),%eax
  8026e9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026f1:	8b 40 04             	mov    0x4(%eax),%eax
  8026f4:	85 c0                	test   %eax,%eax
  8026f6:	74 0f                	je     802707 <alloc_block_BF+0x90>
  8026f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026fb:	8b 40 04             	mov    0x4(%eax),%eax
  8026fe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802701:	8b 12                	mov    (%edx),%edx
  802703:	89 10                	mov    %edx,(%eax)
  802705:	eb 0a                	jmp    802711 <alloc_block_BF+0x9a>
  802707:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80270a:	8b 00                	mov    (%eax),%eax
  80270c:	a3 38 41 80 00       	mov    %eax,0x804138
  802711:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802714:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80271a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80271d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802724:	a1 44 41 80 00       	mov    0x804144,%eax
  802729:	48                   	dec    %eax
  80272a:	a3 44 41 80 00       	mov    %eax,0x804144
	   return temp;
  80272f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802732:	e9 41 01 00 00       	jmp    802878 <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  802737:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80273a:	8b 40 0c             	mov    0xc(%eax),%eax
  80273d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802740:	76 21                	jbe    802763 <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  802742:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802745:	8b 40 0c             	mov    0xc(%eax),%eax
  802748:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80274b:	73 16                	jae    802763 <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  80274d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802750:	8b 40 0c             	mov    0xc(%eax),%eax
  802753:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  802756:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802759:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  80275c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802763:	a1 40 41 80 00       	mov    0x804140,%eax
  802768:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80276b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80276f:	74 07                	je     802778 <alloc_block_BF+0x101>
  802771:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802774:	8b 00                	mov    (%eax),%eax
  802776:	eb 05                	jmp    80277d <alloc_block_BF+0x106>
  802778:	b8 00 00 00 00       	mov    $0x0,%eax
  80277d:	a3 40 41 80 00       	mov    %eax,0x804140
  802782:	a1 40 41 80 00       	mov    0x804140,%eax
  802787:	85 c0                	test   %eax,%eax
  802789:	0f 85 09 ff ff ff    	jne    802698 <alloc_block_BF+0x21>
  80278f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802793:	0f 85 ff fe ff ff    	jne    802698 <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  802799:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  80279d:	0f 85 d0 00 00 00    	jne    802873 <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  8027a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a9:	2b 45 08             	sub    0x8(%ebp),%eax
  8027ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  8027af:	a1 48 41 80 00       	mov    0x804148,%eax
  8027b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  8027b7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8027bb:	75 17                	jne    8027d4 <alloc_block_BF+0x15d>
  8027bd:	83 ec 04             	sub    $0x4,%esp
  8027c0:	68 88 3c 80 00       	push   $0x803c88
  8027c5:	68 d1 00 00 00       	push   $0xd1
  8027ca:	68 17 3c 80 00       	push   $0x803c17
  8027cf:	e8 e9 da ff ff       	call   8002bd <_panic>
  8027d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027d7:	8b 00                	mov    (%eax),%eax
  8027d9:	85 c0                	test   %eax,%eax
  8027db:	74 10                	je     8027ed <alloc_block_BF+0x176>
  8027dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027e0:	8b 00                	mov    (%eax),%eax
  8027e2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027e5:	8b 52 04             	mov    0x4(%edx),%edx
  8027e8:	89 50 04             	mov    %edx,0x4(%eax)
  8027eb:	eb 0b                	jmp    8027f8 <alloc_block_BF+0x181>
  8027ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027f0:	8b 40 04             	mov    0x4(%eax),%eax
  8027f3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8027f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027fb:	8b 40 04             	mov    0x4(%eax),%eax
  8027fe:	85 c0                	test   %eax,%eax
  802800:	74 0f                	je     802811 <alloc_block_BF+0x19a>
  802802:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802805:	8b 40 04             	mov    0x4(%eax),%eax
  802808:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80280b:	8b 12                	mov    (%edx),%edx
  80280d:	89 10                	mov    %edx,(%eax)
  80280f:	eb 0a                	jmp    80281b <alloc_block_BF+0x1a4>
  802811:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802814:	8b 00                	mov    (%eax),%eax
  802816:	a3 48 41 80 00       	mov    %eax,0x804148
  80281b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80281e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802824:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802827:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80282e:	a1 54 41 80 00       	mov    0x804154,%eax
  802833:	48                   	dec    %eax
  802834:	a3 54 41 80 00       	mov    %eax,0x804154
	  // setting the size & sva
	  new_block->size = size;
  802839:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80283c:	8b 55 08             	mov    0x8(%ebp),%edx
  80283f:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  802842:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802845:	8b 50 08             	mov    0x8(%eax),%edx
  802848:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80284b:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  80284e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802851:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802854:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  802857:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80285a:	8b 50 08             	mov    0x8(%eax),%edx
  80285d:	8b 45 08             	mov    0x8(%ebp),%eax
  802860:	01 c2                	add    %eax,%edx
  802862:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802865:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  802868:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80286b:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  80286e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802871:	eb 05                	jmp    802878 <alloc_block_BF+0x201>
	 }
	 return NULL;
  802873:	b8 00 00 00 00       	mov    $0x0,%eax


}
  802878:	c9                   	leave  
  802879:	c3                   	ret    

0080287a <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80287a:	55                   	push   %ebp
  80287b:	89 e5                	mov    %esp,%ebp
  80287d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802880:	83 ec 04             	sub    $0x4,%esp
  802883:	68 a8 3c 80 00       	push   $0x803ca8
  802888:	68 e8 00 00 00       	push   $0xe8
  80288d:	68 17 3c 80 00       	push   $0x803c17
  802892:	e8 26 da ff ff       	call   8002bd <_panic>

00802897 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802897:	55                   	push   %ebp
  802898:	89 e5                	mov    %esp,%ebp
  80289a:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  80289d:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8028a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  8028a5:	a1 38 41 80 00       	mov    0x804138,%eax
  8028aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  8028ad:	a1 44 41 80 00       	mov    0x804144,%eax
  8028b2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  8028b5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028b9:	75 68                	jne    802923 <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8028bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028bf:	75 17                	jne    8028d8 <insert_sorted_with_merge_freeList+0x41>
  8028c1:	83 ec 04             	sub    $0x4,%esp
  8028c4:	68 f4 3b 80 00       	push   $0x803bf4
  8028c9:	68 36 01 00 00       	push   $0x136
  8028ce:	68 17 3c 80 00       	push   $0x803c17
  8028d3:	e8 e5 d9 ff ff       	call   8002bd <_panic>
  8028d8:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8028de:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e1:	89 10                	mov    %edx,(%eax)
  8028e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e6:	8b 00                	mov    (%eax),%eax
  8028e8:	85 c0                	test   %eax,%eax
  8028ea:	74 0d                	je     8028f9 <insert_sorted_with_merge_freeList+0x62>
  8028ec:	a1 38 41 80 00       	mov    0x804138,%eax
  8028f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8028f4:	89 50 04             	mov    %edx,0x4(%eax)
  8028f7:	eb 08                	jmp    802901 <insert_sorted_with_merge_freeList+0x6a>
  8028f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fc:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802901:	8b 45 08             	mov    0x8(%ebp),%eax
  802904:	a3 38 41 80 00       	mov    %eax,0x804138
  802909:	8b 45 08             	mov    0x8(%ebp),%eax
  80290c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802913:	a1 44 41 80 00       	mov    0x804144,%eax
  802918:	40                   	inc    %eax
  802919:	a3 44 41 80 00       	mov    %eax,0x804144





}
  80291e:	e9 ba 06 00 00       	jmp    802fdd <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  802923:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802926:	8b 50 08             	mov    0x8(%eax),%edx
  802929:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292c:	8b 40 0c             	mov    0xc(%eax),%eax
  80292f:	01 c2                	add    %eax,%edx
  802931:	8b 45 08             	mov    0x8(%ebp),%eax
  802934:	8b 40 08             	mov    0x8(%eax),%eax
  802937:	39 c2                	cmp    %eax,%edx
  802939:	73 68                	jae    8029a3 <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80293b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80293f:	75 17                	jne    802958 <insert_sorted_with_merge_freeList+0xc1>
  802941:	83 ec 04             	sub    $0x4,%esp
  802944:	68 30 3c 80 00       	push   $0x803c30
  802949:	68 3a 01 00 00       	push   $0x13a
  80294e:	68 17 3c 80 00       	push   $0x803c17
  802953:	e8 65 d9 ff ff       	call   8002bd <_panic>
  802958:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  80295e:	8b 45 08             	mov    0x8(%ebp),%eax
  802961:	89 50 04             	mov    %edx,0x4(%eax)
  802964:	8b 45 08             	mov    0x8(%ebp),%eax
  802967:	8b 40 04             	mov    0x4(%eax),%eax
  80296a:	85 c0                	test   %eax,%eax
  80296c:	74 0c                	je     80297a <insert_sorted_with_merge_freeList+0xe3>
  80296e:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802973:	8b 55 08             	mov    0x8(%ebp),%edx
  802976:	89 10                	mov    %edx,(%eax)
  802978:	eb 08                	jmp    802982 <insert_sorted_with_merge_freeList+0xeb>
  80297a:	8b 45 08             	mov    0x8(%ebp),%eax
  80297d:	a3 38 41 80 00       	mov    %eax,0x804138
  802982:	8b 45 08             	mov    0x8(%ebp),%eax
  802985:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80298a:	8b 45 08             	mov    0x8(%ebp),%eax
  80298d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802993:	a1 44 41 80 00       	mov    0x804144,%eax
  802998:	40                   	inc    %eax
  802999:	a3 44 41 80 00       	mov    %eax,0x804144





}
  80299e:	e9 3a 06 00 00       	jmp    802fdd <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  8029a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a6:	8b 50 08             	mov    0x8(%eax),%edx
  8029a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8029af:	01 c2                	add    %eax,%edx
  8029b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b4:	8b 40 08             	mov    0x8(%eax),%eax
  8029b7:	39 c2                	cmp    %eax,%edx
  8029b9:	0f 85 90 00 00 00    	jne    802a4f <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  8029bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c2:	8b 50 0c             	mov    0xc(%eax),%edx
  8029c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8029cb:	01 c2                	add    %eax,%edx
  8029cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d0:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  8029d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  8029dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8029e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029eb:	75 17                	jne    802a04 <insert_sorted_with_merge_freeList+0x16d>
  8029ed:	83 ec 04             	sub    $0x4,%esp
  8029f0:	68 f4 3b 80 00       	push   $0x803bf4
  8029f5:	68 41 01 00 00       	push   $0x141
  8029fa:	68 17 3c 80 00       	push   $0x803c17
  8029ff:	e8 b9 d8 ff ff       	call   8002bd <_panic>
  802a04:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0d:	89 10                	mov    %edx,(%eax)
  802a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a12:	8b 00                	mov    (%eax),%eax
  802a14:	85 c0                	test   %eax,%eax
  802a16:	74 0d                	je     802a25 <insert_sorted_with_merge_freeList+0x18e>
  802a18:	a1 48 41 80 00       	mov    0x804148,%eax
  802a1d:	8b 55 08             	mov    0x8(%ebp),%edx
  802a20:	89 50 04             	mov    %edx,0x4(%eax)
  802a23:	eb 08                	jmp    802a2d <insert_sorted_with_merge_freeList+0x196>
  802a25:	8b 45 08             	mov    0x8(%ebp),%eax
  802a28:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a30:	a3 48 41 80 00       	mov    %eax,0x804148
  802a35:	8b 45 08             	mov    0x8(%ebp),%eax
  802a38:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a3f:	a1 54 41 80 00       	mov    0x804154,%eax
  802a44:	40                   	inc    %eax
  802a45:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802a4a:	e9 8e 05 00 00       	jmp    802fdd <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  802a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a52:	8b 50 08             	mov    0x8(%eax),%edx
  802a55:	8b 45 08             	mov    0x8(%ebp),%eax
  802a58:	8b 40 0c             	mov    0xc(%eax),%eax
  802a5b:	01 c2                	add    %eax,%edx
  802a5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a60:	8b 40 08             	mov    0x8(%eax),%eax
  802a63:	39 c2                	cmp    %eax,%edx
  802a65:	73 68                	jae    802acf <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802a67:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a6b:	75 17                	jne    802a84 <insert_sorted_with_merge_freeList+0x1ed>
  802a6d:	83 ec 04             	sub    $0x4,%esp
  802a70:	68 f4 3b 80 00       	push   $0x803bf4
  802a75:	68 45 01 00 00       	push   $0x145
  802a7a:	68 17 3c 80 00       	push   $0x803c17
  802a7f:	e8 39 d8 ff ff       	call   8002bd <_panic>
  802a84:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8d:	89 10                	mov    %edx,(%eax)
  802a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a92:	8b 00                	mov    (%eax),%eax
  802a94:	85 c0                	test   %eax,%eax
  802a96:	74 0d                	je     802aa5 <insert_sorted_with_merge_freeList+0x20e>
  802a98:	a1 38 41 80 00       	mov    0x804138,%eax
  802a9d:	8b 55 08             	mov    0x8(%ebp),%edx
  802aa0:	89 50 04             	mov    %edx,0x4(%eax)
  802aa3:	eb 08                	jmp    802aad <insert_sorted_with_merge_freeList+0x216>
  802aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802aad:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab0:	a3 38 41 80 00       	mov    %eax,0x804138
  802ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802abf:	a1 44 41 80 00       	mov    0x804144,%eax
  802ac4:	40                   	inc    %eax
  802ac5:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802aca:	e9 0e 05 00 00       	jmp    802fdd <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  802acf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad2:	8b 50 08             	mov    0x8(%eax),%edx
  802ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad8:	8b 40 0c             	mov    0xc(%eax),%eax
  802adb:	01 c2                	add    %eax,%edx
  802add:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae0:	8b 40 08             	mov    0x8(%eax),%eax
  802ae3:	39 c2                	cmp    %eax,%edx
  802ae5:	0f 85 9c 00 00 00    	jne    802b87 <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  802aeb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aee:	8b 50 0c             	mov    0xc(%eax),%edx
  802af1:	8b 45 08             	mov    0x8(%ebp),%eax
  802af4:	8b 40 0c             	mov    0xc(%eax),%eax
  802af7:	01 c2                	add    %eax,%edx
  802af9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802afc:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  802aff:	8b 45 08             	mov    0x8(%ebp),%eax
  802b02:	8b 50 08             	mov    0x8(%eax),%edx
  802b05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b08:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  802b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  802b15:	8b 45 08             	mov    0x8(%ebp),%eax
  802b18:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802b1f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b23:	75 17                	jne    802b3c <insert_sorted_with_merge_freeList+0x2a5>
  802b25:	83 ec 04             	sub    $0x4,%esp
  802b28:	68 f4 3b 80 00       	push   $0x803bf4
  802b2d:	68 4d 01 00 00       	push   $0x14d
  802b32:	68 17 3c 80 00       	push   $0x803c17
  802b37:	e8 81 d7 ff ff       	call   8002bd <_panic>
  802b3c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b42:	8b 45 08             	mov    0x8(%ebp),%eax
  802b45:	89 10                	mov    %edx,(%eax)
  802b47:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4a:	8b 00                	mov    (%eax),%eax
  802b4c:	85 c0                	test   %eax,%eax
  802b4e:	74 0d                	je     802b5d <insert_sorted_with_merge_freeList+0x2c6>
  802b50:	a1 48 41 80 00       	mov    0x804148,%eax
  802b55:	8b 55 08             	mov    0x8(%ebp),%edx
  802b58:	89 50 04             	mov    %edx,0x4(%eax)
  802b5b:	eb 08                	jmp    802b65 <insert_sorted_with_merge_freeList+0x2ce>
  802b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b60:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b65:	8b 45 08             	mov    0x8(%ebp),%eax
  802b68:	a3 48 41 80 00       	mov    %eax,0x804148
  802b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b70:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b77:	a1 54 41 80 00       	mov    0x804154,%eax
  802b7c:	40                   	inc    %eax
  802b7d:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802b82:	e9 56 04 00 00       	jmp    802fdd <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802b87:	a1 38 41 80 00       	mov    0x804138,%eax
  802b8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b8f:	e9 19 04 00 00       	jmp    802fad <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  802b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b97:	8b 00                	mov    (%eax),%eax
  802b99:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9f:	8b 50 08             	mov    0x8(%eax),%edx
  802ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba8:	01 c2                	add    %eax,%edx
  802baa:	8b 45 08             	mov    0x8(%ebp),%eax
  802bad:	8b 40 08             	mov    0x8(%eax),%eax
  802bb0:	39 c2                	cmp    %eax,%edx
  802bb2:	0f 85 ad 01 00 00    	jne    802d65 <insert_sorted_with_merge_freeList+0x4ce>
  802bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbb:	8b 50 08             	mov    0x8(%eax),%edx
  802bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc1:	8b 40 0c             	mov    0xc(%eax),%eax
  802bc4:	01 c2                	add    %eax,%edx
  802bc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bc9:	8b 40 08             	mov    0x8(%eax),%eax
  802bcc:	39 c2                	cmp    %eax,%edx
  802bce:	0f 85 91 01 00 00    	jne    802d65 <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  802bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd7:	8b 50 0c             	mov    0xc(%eax),%edx
  802bda:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdd:	8b 48 0c             	mov    0xc(%eax),%ecx
  802be0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802be3:	8b 40 0c             	mov    0xc(%eax),%eax
  802be6:	01 c8                	add    %ecx,%eax
  802be8:	01 c2                	add    %eax,%edx
  802bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bed:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  802bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  802c04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c07:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  802c0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c11:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  802c18:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802c1c:	75 17                	jne    802c35 <insert_sorted_with_merge_freeList+0x39e>
  802c1e:	83 ec 04             	sub    $0x4,%esp
  802c21:	68 88 3c 80 00       	push   $0x803c88
  802c26:	68 5b 01 00 00       	push   $0x15b
  802c2b:	68 17 3c 80 00       	push   $0x803c17
  802c30:	e8 88 d6 ff ff       	call   8002bd <_panic>
  802c35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c38:	8b 00                	mov    (%eax),%eax
  802c3a:	85 c0                	test   %eax,%eax
  802c3c:	74 10                	je     802c4e <insert_sorted_with_merge_freeList+0x3b7>
  802c3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c41:	8b 00                	mov    (%eax),%eax
  802c43:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c46:	8b 52 04             	mov    0x4(%edx),%edx
  802c49:	89 50 04             	mov    %edx,0x4(%eax)
  802c4c:	eb 0b                	jmp    802c59 <insert_sorted_with_merge_freeList+0x3c2>
  802c4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c51:	8b 40 04             	mov    0x4(%eax),%eax
  802c54:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c5c:	8b 40 04             	mov    0x4(%eax),%eax
  802c5f:	85 c0                	test   %eax,%eax
  802c61:	74 0f                	je     802c72 <insert_sorted_with_merge_freeList+0x3db>
  802c63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c66:	8b 40 04             	mov    0x4(%eax),%eax
  802c69:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c6c:	8b 12                	mov    (%edx),%edx
  802c6e:	89 10                	mov    %edx,(%eax)
  802c70:	eb 0a                	jmp    802c7c <insert_sorted_with_merge_freeList+0x3e5>
  802c72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c75:	8b 00                	mov    (%eax),%eax
  802c77:	a3 38 41 80 00       	mov    %eax,0x804138
  802c7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c7f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c88:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c8f:	a1 44 41 80 00       	mov    0x804144,%eax
  802c94:	48                   	dec    %eax
  802c95:	a3 44 41 80 00       	mov    %eax,0x804144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802c9a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c9e:	75 17                	jne    802cb7 <insert_sorted_with_merge_freeList+0x420>
  802ca0:	83 ec 04             	sub    $0x4,%esp
  802ca3:	68 f4 3b 80 00       	push   $0x803bf4
  802ca8:	68 5c 01 00 00       	push   $0x15c
  802cad:	68 17 3c 80 00       	push   $0x803c17
  802cb2:	e8 06 d6 ff ff       	call   8002bd <_panic>
  802cb7:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc0:	89 10                	mov    %edx,(%eax)
  802cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc5:	8b 00                	mov    (%eax),%eax
  802cc7:	85 c0                	test   %eax,%eax
  802cc9:	74 0d                	je     802cd8 <insert_sorted_with_merge_freeList+0x441>
  802ccb:	a1 48 41 80 00       	mov    0x804148,%eax
  802cd0:	8b 55 08             	mov    0x8(%ebp),%edx
  802cd3:	89 50 04             	mov    %edx,0x4(%eax)
  802cd6:	eb 08                	jmp    802ce0 <insert_sorted_with_merge_freeList+0x449>
  802cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdb:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce3:	a3 48 41 80 00       	mov    %eax,0x804148
  802ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ceb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cf2:	a1 54 41 80 00       	mov    0x804154,%eax
  802cf7:	40                   	inc    %eax
  802cf8:	a3 54 41 80 00       	mov    %eax,0x804154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  802cfd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802d01:	75 17                	jne    802d1a <insert_sorted_with_merge_freeList+0x483>
  802d03:	83 ec 04             	sub    $0x4,%esp
  802d06:	68 f4 3b 80 00       	push   $0x803bf4
  802d0b:	68 5d 01 00 00       	push   $0x15d
  802d10:	68 17 3c 80 00       	push   $0x803c17
  802d15:	e8 a3 d5 ff ff       	call   8002bd <_panic>
  802d1a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d23:	89 10                	mov    %edx,(%eax)
  802d25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d28:	8b 00                	mov    (%eax),%eax
  802d2a:	85 c0                	test   %eax,%eax
  802d2c:	74 0d                	je     802d3b <insert_sorted_with_merge_freeList+0x4a4>
  802d2e:	a1 48 41 80 00       	mov    0x804148,%eax
  802d33:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d36:	89 50 04             	mov    %edx,0x4(%eax)
  802d39:	eb 08                	jmp    802d43 <insert_sorted_with_merge_freeList+0x4ac>
  802d3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d3e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d46:	a3 48 41 80 00       	mov    %eax,0x804148
  802d4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d4e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d55:	a1 54 41 80 00       	mov    0x804154,%eax
  802d5a:	40                   	inc    %eax
  802d5b:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802d60:	e9 78 02 00 00       	jmp    802fdd <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802d65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d68:	8b 50 08             	mov    0x8(%eax),%edx
  802d6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d71:	01 c2                	add    %eax,%edx
  802d73:	8b 45 08             	mov    0x8(%ebp),%eax
  802d76:	8b 40 08             	mov    0x8(%eax),%eax
  802d79:	39 c2                	cmp    %eax,%edx
  802d7b:	0f 83 b8 00 00 00    	jae    802e39 <insert_sorted_with_merge_freeList+0x5a2>
  802d81:	8b 45 08             	mov    0x8(%ebp),%eax
  802d84:	8b 50 08             	mov    0x8(%eax),%edx
  802d87:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d8d:	01 c2                	add    %eax,%edx
  802d8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d92:	8b 40 08             	mov    0x8(%eax),%eax
  802d95:	39 c2                	cmp    %eax,%edx
  802d97:	0f 85 9c 00 00 00    	jne    802e39 <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  802d9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802da0:	8b 50 0c             	mov    0xc(%eax),%edx
  802da3:	8b 45 08             	mov    0x8(%ebp),%eax
  802da6:	8b 40 0c             	mov    0xc(%eax),%eax
  802da9:	01 c2                	add    %eax,%edx
  802dab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dae:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  802db1:	8b 45 08             	mov    0x8(%ebp),%eax
  802db4:	8b 50 08             	mov    0x8(%eax),%edx
  802db7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dba:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  802dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dca:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802dd1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dd5:	75 17                	jne    802dee <insert_sorted_with_merge_freeList+0x557>
  802dd7:	83 ec 04             	sub    $0x4,%esp
  802dda:	68 f4 3b 80 00       	push   $0x803bf4
  802ddf:	68 67 01 00 00       	push   $0x167
  802de4:	68 17 3c 80 00       	push   $0x803c17
  802de9:	e8 cf d4 ff ff       	call   8002bd <_panic>
  802dee:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802df4:	8b 45 08             	mov    0x8(%ebp),%eax
  802df7:	89 10                	mov    %edx,(%eax)
  802df9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfc:	8b 00                	mov    (%eax),%eax
  802dfe:	85 c0                	test   %eax,%eax
  802e00:	74 0d                	je     802e0f <insert_sorted_with_merge_freeList+0x578>
  802e02:	a1 48 41 80 00       	mov    0x804148,%eax
  802e07:	8b 55 08             	mov    0x8(%ebp),%edx
  802e0a:	89 50 04             	mov    %edx,0x4(%eax)
  802e0d:	eb 08                	jmp    802e17 <insert_sorted_with_merge_freeList+0x580>
  802e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e12:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e17:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1a:	a3 48 41 80 00       	mov    %eax,0x804148
  802e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e22:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e29:	a1 54 41 80 00       	mov    0x804154,%eax
  802e2e:	40                   	inc    %eax
  802e2f:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802e34:	e9 a4 01 00 00       	jmp    802fdd <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3c:	8b 50 08             	mov    0x8(%eax),%edx
  802e3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e42:	8b 40 0c             	mov    0xc(%eax),%eax
  802e45:	01 c2                	add    %eax,%edx
  802e47:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4a:	8b 40 08             	mov    0x8(%eax),%eax
  802e4d:	39 c2                	cmp    %eax,%edx
  802e4f:	0f 85 ac 00 00 00    	jne    802f01 <insert_sorted_with_merge_freeList+0x66a>
  802e55:	8b 45 08             	mov    0x8(%ebp),%eax
  802e58:	8b 50 08             	mov    0x8(%eax),%edx
  802e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5e:	8b 40 0c             	mov    0xc(%eax),%eax
  802e61:	01 c2                	add    %eax,%edx
  802e63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e66:	8b 40 08             	mov    0x8(%eax),%eax
  802e69:	39 c2                	cmp    %eax,%edx
  802e6b:	0f 83 90 00 00 00    	jae    802f01 <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  802e71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e74:	8b 50 0c             	mov    0xc(%eax),%edx
  802e77:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e7d:	01 c2                	add    %eax,%edx
  802e7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e82:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  802e85:	8b 45 08             	mov    0x8(%ebp),%eax
  802e88:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  802e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e92:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e99:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e9d:	75 17                	jne    802eb6 <insert_sorted_with_merge_freeList+0x61f>
  802e9f:	83 ec 04             	sub    $0x4,%esp
  802ea2:	68 f4 3b 80 00       	push   $0x803bf4
  802ea7:	68 70 01 00 00       	push   $0x170
  802eac:	68 17 3c 80 00       	push   $0x803c17
  802eb1:	e8 07 d4 ff ff       	call   8002bd <_panic>
  802eb6:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebf:	89 10                	mov    %edx,(%eax)
  802ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec4:	8b 00                	mov    (%eax),%eax
  802ec6:	85 c0                	test   %eax,%eax
  802ec8:	74 0d                	je     802ed7 <insert_sorted_with_merge_freeList+0x640>
  802eca:	a1 48 41 80 00       	mov    0x804148,%eax
  802ecf:	8b 55 08             	mov    0x8(%ebp),%edx
  802ed2:	89 50 04             	mov    %edx,0x4(%eax)
  802ed5:	eb 08                	jmp    802edf <insert_sorted_with_merge_freeList+0x648>
  802ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eda:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802edf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee2:	a3 48 41 80 00       	mov    %eax,0x804148
  802ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ef1:	a1 54 41 80 00       	mov    0x804154,%eax
  802ef6:	40                   	inc    %eax
  802ef7:	a3 54 41 80 00       	mov    %eax,0x804154
	      break;
  802efc:	e9 dc 00 00 00       	jmp    802fdd <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f04:	8b 50 08             	mov    0x8(%eax),%edx
  802f07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0a:	8b 40 0c             	mov    0xc(%eax),%eax
  802f0d:	01 c2                	add    %eax,%edx
  802f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f12:	8b 40 08             	mov    0x8(%eax),%eax
  802f15:	39 c2                	cmp    %eax,%edx
  802f17:	0f 83 88 00 00 00    	jae    802fa5 <insert_sorted_with_merge_freeList+0x70e>
  802f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f20:	8b 50 08             	mov    0x8(%eax),%edx
  802f23:	8b 45 08             	mov    0x8(%ebp),%eax
  802f26:	8b 40 0c             	mov    0xc(%eax),%eax
  802f29:	01 c2                	add    %eax,%edx
  802f2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f2e:	8b 40 08             	mov    0x8(%eax),%eax
  802f31:	39 c2                	cmp    %eax,%edx
  802f33:	73 70                	jae    802fa5 <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  802f35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f39:	74 06                	je     802f41 <insert_sorted_with_merge_freeList+0x6aa>
  802f3b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f3f:	75 17                	jne    802f58 <insert_sorted_with_merge_freeList+0x6c1>
  802f41:	83 ec 04             	sub    $0x4,%esp
  802f44:	68 54 3c 80 00       	push   $0x803c54
  802f49:	68 75 01 00 00       	push   $0x175
  802f4e:	68 17 3c 80 00       	push   $0x803c17
  802f53:	e8 65 d3 ff ff       	call   8002bd <_panic>
  802f58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5b:	8b 10                	mov    (%eax),%edx
  802f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f60:	89 10                	mov    %edx,(%eax)
  802f62:	8b 45 08             	mov    0x8(%ebp),%eax
  802f65:	8b 00                	mov    (%eax),%eax
  802f67:	85 c0                	test   %eax,%eax
  802f69:	74 0b                	je     802f76 <insert_sorted_with_merge_freeList+0x6df>
  802f6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6e:	8b 00                	mov    (%eax),%eax
  802f70:	8b 55 08             	mov    0x8(%ebp),%edx
  802f73:	89 50 04             	mov    %edx,0x4(%eax)
  802f76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f79:	8b 55 08             	mov    0x8(%ebp),%edx
  802f7c:	89 10                	mov    %edx,(%eax)
  802f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f84:	89 50 04             	mov    %edx,0x4(%eax)
  802f87:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8a:	8b 00                	mov    (%eax),%eax
  802f8c:	85 c0                	test   %eax,%eax
  802f8e:	75 08                	jne    802f98 <insert_sorted_with_merge_freeList+0x701>
  802f90:	8b 45 08             	mov    0x8(%ebp),%eax
  802f93:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f98:	a1 44 41 80 00       	mov    0x804144,%eax
  802f9d:	40                   	inc    %eax
  802f9e:	a3 44 41 80 00       	mov    %eax,0x804144
	      break;
  802fa3:	eb 38                	jmp    802fdd <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802fa5:	a1 40 41 80 00       	mov    0x804140,%eax
  802faa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fb1:	74 07                	je     802fba <insert_sorted_with_merge_freeList+0x723>
  802fb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb6:	8b 00                	mov    (%eax),%eax
  802fb8:	eb 05                	jmp    802fbf <insert_sorted_with_merge_freeList+0x728>
  802fba:	b8 00 00 00 00       	mov    $0x0,%eax
  802fbf:	a3 40 41 80 00       	mov    %eax,0x804140
  802fc4:	a1 40 41 80 00       	mov    0x804140,%eax
  802fc9:	85 c0                	test   %eax,%eax
  802fcb:	0f 85 c3 fb ff ff    	jne    802b94 <insert_sorted_with_merge_freeList+0x2fd>
  802fd1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fd5:	0f 85 b9 fb ff ff    	jne    802b94 <insert_sorted_with_merge_freeList+0x2fd>





}
  802fdb:	eb 00                	jmp    802fdd <insert_sorted_with_merge_freeList+0x746>
  802fdd:	90                   	nop
  802fde:	c9                   	leave  
  802fdf:	c3                   	ret    

00802fe0 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802fe0:	55                   	push   %ebp
  802fe1:	89 e5                	mov    %esp,%ebp
  802fe3:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  802fe6:	8b 55 08             	mov    0x8(%ebp),%edx
  802fe9:	89 d0                	mov    %edx,%eax
  802feb:	c1 e0 02             	shl    $0x2,%eax
  802fee:	01 d0                	add    %edx,%eax
  802ff0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802ff7:	01 d0                	add    %edx,%eax
  802ff9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803000:	01 d0                	add    %edx,%eax
  803002:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803009:	01 d0                	add    %edx,%eax
  80300b:	c1 e0 04             	shl    $0x4,%eax
  80300e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803011:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803018:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80301b:	83 ec 0c             	sub    $0xc,%esp
  80301e:	50                   	push   %eax
  80301f:	e8 31 ec ff ff       	call   801c55 <sys_get_virtual_time>
  803024:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803027:	eb 41                	jmp    80306a <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803029:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80302c:	83 ec 0c             	sub    $0xc,%esp
  80302f:	50                   	push   %eax
  803030:	e8 20 ec ff ff       	call   801c55 <sys_get_virtual_time>
  803035:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803038:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80303b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303e:	29 c2                	sub    %eax,%edx
  803040:	89 d0                	mov    %edx,%eax
  803042:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803045:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803048:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80304b:	89 d1                	mov    %edx,%ecx
  80304d:	29 c1                	sub    %eax,%ecx
  80304f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803052:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803055:	39 c2                	cmp    %eax,%edx
  803057:	0f 97 c0             	seta   %al
  80305a:	0f b6 c0             	movzbl %al,%eax
  80305d:	29 c1                	sub    %eax,%ecx
  80305f:	89 c8                	mov    %ecx,%eax
  803061:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803064:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803067:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80306a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803070:	72 b7                	jb     803029 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803072:	90                   	nop
  803073:	c9                   	leave  
  803074:	c3                   	ret    

00803075 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803075:	55                   	push   %ebp
  803076:	89 e5                	mov    %esp,%ebp
  803078:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80307b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803082:	eb 03                	jmp    803087 <busy_wait+0x12>
  803084:	ff 45 fc             	incl   -0x4(%ebp)
  803087:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80308a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80308d:	72 f5                	jb     803084 <busy_wait+0xf>
	return i;
  80308f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803092:	c9                   	leave  
  803093:	c3                   	ret    

00803094 <__udivdi3>:
  803094:	55                   	push   %ebp
  803095:	57                   	push   %edi
  803096:	56                   	push   %esi
  803097:	53                   	push   %ebx
  803098:	83 ec 1c             	sub    $0x1c,%esp
  80309b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80309f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8030a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8030a7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8030ab:	89 ca                	mov    %ecx,%edx
  8030ad:	89 f8                	mov    %edi,%eax
  8030af:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8030b3:	85 f6                	test   %esi,%esi
  8030b5:	75 2d                	jne    8030e4 <__udivdi3+0x50>
  8030b7:	39 cf                	cmp    %ecx,%edi
  8030b9:	77 65                	ja     803120 <__udivdi3+0x8c>
  8030bb:	89 fd                	mov    %edi,%ebp
  8030bd:	85 ff                	test   %edi,%edi
  8030bf:	75 0b                	jne    8030cc <__udivdi3+0x38>
  8030c1:	b8 01 00 00 00       	mov    $0x1,%eax
  8030c6:	31 d2                	xor    %edx,%edx
  8030c8:	f7 f7                	div    %edi
  8030ca:	89 c5                	mov    %eax,%ebp
  8030cc:	31 d2                	xor    %edx,%edx
  8030ce:	89 c8                	mov    %ecx,%eax
  8030d0:	f7 f5                	div    %ebp
  8030d2:	89 c1                	mov    %eax,%ecx
  8030d4:	89 d8                	mov    %ebx,%eax
  8030d6:	f7 f5                	div    %ebp
  8030d8:	89 cf                	mov    %ecx,%edi
  8030da:	89 fa                	mov    %edi,%edx
  8030dc:	83 c4 1c             	add    $0x1c,%esp
  8030df:	5b                   	pop    %ebx
  8030e0:	5e                   	pop    %esi
  8030e1:	5f                   	pop    %edi
  8030e2:	5d                   	pop    %ebp
  8030e3:	c3                   	ret    
  8030e4:	39 ce                	cmp    %ecx,%esi
  8030e6:	77 28                	ja     803110 <__udivdi3+0x7c>
  8030e8:	0f bd fe             	bsr    %esi,%edi
  8030eb:	83 f7 1f             	xor    $0x1f,%edi
  8030ee:	75 40                	jne    803130 <__udivdi3+0x9c>
  8030f0:	39 ce                	cmp    %ecx,%esi
  8030f2:	72 0a                	jb     8030fe <__udivdi3+0x6a>
  8030f4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8030f8:	0f 87 9e 00 00 00    	ja     80319c <__udivdi3+0x108>
  8030fe:	b8 01 00 00 00       	mov    $0x1,%eax
  803103:	89 fa                	mov    %edi,%edx
  803105:	83 c4 1c             	add    $0x1c,%esp
  803108:	5b                   	pop    %ebx
  803109:	5e                   	pop    %esi
  80310a:	5f                   	pop    %edi
  80310b:	5d                   	pop    %ebp
  80310c:	c3                   	ret    
  80310d:	8d 76 00             	lea    0x0(%esi),%esi
  803110:	31 ff                	xor    %edi,%edi
  803112:	31 c0                	xor    %eax,%eax
  803114:	89 fa                	mov    %edi,%edx
  803116:	83 c4 1c             	add    $0x1c,%esp
  803119:	5b                   	pop    %ebx
  80311a:	5e                   	pop    %esi
  80311b:	5f                   	pop    %edi
  80311c:	5d                   	pop    %ebp
  80311d:	c3                   	ret    
  80311e:	66 90                	xchg   %ax,%ax
  803120:	89 d8                	mov    %ebx,%eax
  803122:	f7 f7                	div    %edi
  803124:	31 ff                	xor    %edi,%edi
  803126:	89 fa                	mov    %edi,%edx
  803128:	83 c4 1c             	add    $0x1c,%esp
  80312b:	5b                   	pop    %ebx
  80312c:	5e                   	pop    %esi
  80312d:	5f                   	pop    %edi
  80312e:	5d                   	pop    %ebp
  80312f:	c3                   	ret    
  803130:	bd 20 00 00 00       	mov    $0x20,%ebp
  803135:	89 eb                	mov    %ebp,%ebx
  803137:	29 fb                	sub    %edi,%ebx
  803139:	89 f9                	mov    %edi,%ecx
  80313b:	d3 e6                	shl    %cl,%esi
  80313d:	89 c5                	mov    %eax,%ebp
  80313f:	88 d9                	mov    %bl,%cl
  803141:	d3 ed                	shr    %cl,%ebp
  803143:	89 e9                	mov    %ebp,%ecx
  803145:	09 f1                	or     %esi,%ecx
  803147:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80314b:	89 f9                	mov    %edi,%ecx
  80314d:	d3 e0                	shl    %cl,%eax
  80314f:	89 c5                	mov    %eax,%ebp
  803151:	89 d6                	mov    %edx,%esi
  803153:	88 d9                	mov    %bl,%cl
  803155:	d3 ee                	shr    %cl,%esi
  803157:	89 f9                	mov    %edi,%ecx
  803159:	d3 e2                	shl    %cl,%edx
  80315b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80315f:	88 d9                	mov    %bl,%cl
  803161:	d3 e8                	shr    %cl,%eax
  803163:	09 c2                	or     %eax,%edx
  803165:	89 d0                	mov    %edx,%eax
  803167:	89 f2                	mov    %esi,%edx
  803169:	f7 74 24 0c          	divl   0xc(%esp)
  80316d:	89 d6                	mov    %edx,%esi
  80316f:	89 c3                	mov    %eax,%ebx
  803171:	f7 e5                	mul    %ebp
  803173:	39 d6                	cmp    %edx,%esi
  803175:	72 19                	jb     803190 <__udivdi3+0xfc>
  803177:	74 0b                	je     803184 <__udivdi3+0xf0>
  803179:	89 d8                	mov    %ebx,%eax
  80317b:	31 ff                	xor    %edi,%edi
  80317d:	e9 58 ff ff ff       	jmp    8030da <__udivdi3+0x46>
  803182:	66 90                	xchg   %ax,%ax
  803184:	8b 54 24 08          	mov    0x8(%esp),%edx
  803188:	89 f9                	mov    %edi,%ecx
  80318a:	d3 e2                	shl    %cl,%edx
  80318c:	39 c2                	cmp    %eax,%edx
  80318e:	73 e9                	jae    803179 <__udivdi3+0xe5>
  803190:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803193:	31 ff                	xor    %edi,%edi
  803195:	e9 40 ff ff ff       	jmp    8030da <__udivdi3+0x46>
  80319a:	66 90                	xchg   %ax,%ax
  80319c:	31 c0                	xor    %eax,%eax
  80319e:	e9 37 ff ff ff       	jmp    8030da <__udivdi3+0x46>
  8031a3:	90                   	nop

008031a4 <__umoddi3>:
  8031a4:	55                   	push   %ebp
  8031a5:	57                   	push   %edi
  8031a6:	56                   	push   %esi
  8031a7:	53                   	push   %ebx
  8031a8:	83 ec 1c             	sub    $0x1c,%esp
  8031ab:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8031af:	8b 74 24 34          	mov    0x34(%esp),%esi
  8031b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8031b7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8031bb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8031bf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8031c3:	89 f3                	mov    %esi,%ebx
  8031c5:	89 fa                	mov    %edi,%edx
  8031c7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8031cb:	89 34 24             	mov    %esi,(%esp)
  8031ce:	85 c0                	test   %eax,%eax
  8031d0:	75 1a                	jne    8031ec <__umoddi3+0x48>
  8031d2:	39 f7                	cmp    %esi,%edi
  8031d4:	0f 86 a2 00 00 00    	jbe    80327c <__umoddi3+0xd8>
  8031da:	89 c8                	mov    %ecx,%eax
  8031dc:	89 f2                	mov    %esi,%edx
  8031de:	f7 f7                	div    %edi
  8031e0:	89 d0                	mov    %edx,%eax
  8031e2:	31 d2                	xor    %edx,%edx
  8031e4:	83 c4 1c             	add    $0x1c,%esp
  8031e7:	5b                   	pop    %ebx
  8031e8:	5e                   	pop    %esi
  8031e9:	5f                   	pop    %edi
  8031ea:	5d                   	pop    %ebp
  8031eb:	c3                   	ret    
  8031ec:	39 f0                	cmp    %esi,%eax
  8031ee:	0f 87 ac 00 00 00    	ja     8032a0 <__umoddi3+0xfc>
  8031f4:	0f bd e8             	bsr    %eax,%ebp
  8031f7:	83 f5 1f             	xor    $0x1f,%ebp
  8031fa:	0f 84 ac 00 00 00    	je     8032ac <__umoddi3+0x108>
  803200:	bf 20 00 00 00       	mov    $0x20,%edi
  803205:	29 ef                	sub    %ebp,%edi
  803207:	89 fe                	mov    %edi,%esi
  803209:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80320d:	89 e9                	mov    %ebp,%ecx
  80320f:	d3 e0                	shl    %cl,%eax
  803211:	89 d7                	mov    %edx,%edi
  803213:	89 f1                	mov    %esi,%ecx
  803215:	d3 ef                	shr    %cl,%edi
  803217:	09 c7                	or     %eax,%edi
  803219:	89 e9                	mov    %ebp,%ecx
  80321b:	d3 e2                	shl    %cl,%edx
  80321d:	89 14 24             	mov    %edx,(%esp)
  803220:	89 d8                	mov    %ebx,%eax
  803222:	d3 e0                	shl    %cl,%eax
  803224:	89 c2                	mov    %eax,%edx
  803226:	8b 44 24 08          	mov    0x8(%esp),%eax
  80322a:	d3 e0                	shl    %cl,%eax
  80322c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803230:	8b 44 24 08          	mov    0x8(%esp),%eax
  803234:	89 f1                	mov    %esi,%ecx
  803236:	d3 e8                	shr    %cl,%eax
  803238:	09 d0                	or     %edx,%eax
  80323a:	d3 eb                	shr    %cl,%ebx
  80323c:	89 da                	mov    %ebx,%edx
  80323e:	f7 f7                	div    %edi
  803240:	89 d3                	mov    %edx,%ebx
  803242:	f7 24 24             	mull   (%esp)
  803245:	89 c6                	mov    %eax,%esi
  803247:	89 d1                	mov    %edx,%ecx
  803249:	39 d3                	cmp    %edx,%ebx
  80324b:	0f 82 87 00 00 00    	jb     8032d8 <__umoddi3+0x134>
  803251:	0f 84 91 00 00 00    	je     8032e8 <__umoddi3+0x144>
  803257:	8b 54 24 04          	mov    0x4(%esp),%edx
  80325b:	29 f2                	sub    %esi,%edx
  80325d:	19 cb                	sbb    %ecx,%ebx
  80325f:	89 d8                	mov    %ebx,%eax
  803261:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803265:	d3 e0                	shl    %cl,%eax
  803267:	89 e9                	mov    %ebp,%ecx
  803269:	d3 ea                	shr    %cl,%edx
  80326b:	09 d0                	or     %edx,%eax
  80326d:	89 e9                	mov    %ebp,%ecx
  80326f:	d3 eb                	shr    %cl,%ebx
  803271:	89 da                	mov    %ebx,%edx
  803273:	83 c4 1c             	add    $0x1c,%esp
  803276:	5b                   	pop    %ebx
  803277:	5e                   	pop    %esi
  803278:	5f                   	pop    %edi
  803279:	5d                   	pop    %ebp
  80327a:	c3                   	ret    
  80327b:	90                   	nop
  80327c:	89 fd                	mov    %edi,%ebp
  80327e:	85 ff                	test   %edi,%edi
  803280:	75 0b                	jne    80328d <__umoddi3+0xe9>
  803282:	b8 01 00 00 00       	mov    $0x1,%eax
  803287:	31 d2                	xor    %edx,%edx
  803289:	f7 f7                	div    %edi
  80328b:	89 c5                	mov    %eax,%ebp
  80328d:	89 f0                	mov    %esi,%eax
  80328f:	31 d2                	xor    %edx,%edx
  803291:	f7 f5                	div    %ebp
  803293:	89 c8                	mov    %ecx,%eax
  803295:	f7 f5                	div    %ebp
  803297:	89 d0                	mov    %edx,%eax
  803299:	e9 44 ff ff ff       	jmp    8031e2 <__umoddi3+0x3e>
  80329e:	66 90                	xchg   %ax,%ax
  8032a0:	89 c8                	mov    %ecx,%eax
  8032a2:	89 f2                	mov    %esi,%edx
  8032a4:	83 c4 1c             	add    $0x1c,%esp
  8032a7:	5b                   	pop    %ebx
  8032a8:	5e                   	pop    %esi
  8032a9:	5f                   	pop    %edi
  8032aa:	5d                   	pop    %ebp
  8032ab:	c3                   	ret    
  8032ac:	3b 04 24             	cmp    (%esp),%eax
  8032af:	72 06                	jb     8032b7 <__umoddi3+0x113>
  8032b1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8032b5:	77 0f                	ja     8032c6 <__umoddi3+0x122>
  8032b7:	89 f2                	mov    %esi,%edx
  8032b9:	29 f9                	sub    %edi,%ecx
  8032bb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8032bf:	89 14 24             	mov    %edx,(%esp)
  8032c2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8032c6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8032ca:	8b 14 24             	mov    (%esp),%edx
  8032cd:	83 c4 1c             	add    $0x1c,%esp
  8032d0:	5b                   	pop    %ebx
  8032d1:	5e                   	pop    %esi
  8032d2:	5f                   	pop    %edi
  8032d3:	5d                   	pop    %ebp
  8032d4:	c3                   	ret    
  8032d5:	8d 76 00             	lea    0x0(%esi),%esi
  8032d8:	2b 04 24             	sub    (%esp),%eax
  8032db:	19 fa                	sbb    %edi,%edx
  8032dd:	89 d1                	mov    %edx,%ecx
  8032df:	89 c6                	mov    %eax,%esi
  8032e1:	e9 71 ff ff ff       	jmp    803257 <__umoddi3+0xb3>
  8032e6:	66 90                	xchg   %ax,%ax
  8032e8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8032ec:	72 ea                	jb     8032d8 <__umoddi3+0x134>
  8032ee:	89 d9                	mov    %ebx,%ecx
  8032f0:	e9 62 ff ff ff       	jmp    803257 <__umoddi3+0xb3>
