
obj/user/tst_envfree4:     file format elf32-i386


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
  800031:	e8 0d 01 00 00       	call   800143 <libmain>
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
	// Testing scenario 4: Freeing the allocated semaphores
	// Testing removing the shared variables
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 20 32 80 00       	push   $0x803220
  80004a:	e8 d9 15 00 00       	call   801628 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 88 18 00 00       	call   8018eb <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 20 19 00 00       	call   80198b <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 30 32 80 00       	push   $0x803230
  800079:	e8 b5 04 00 00       	call   800533 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tsem1", 100,(myEnv->SecondListSize), 50);
  800081:	a1 20 40 80 00       	mov    0x804020,%eax
  800086:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	6a 64                	push   $0x64
  800091:	68 63 32 80 00       	push   $0x803263
  800096:	e8 c2 1a 00 00       	call   801b5d <sys_create_env>
  80009b:	83 c4 10             	add    $0x10,%esp
  80009e:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sys_run_env(envIdProcessA);
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	ff 75 e8             	pushl  -0x18(%ebp)
  8000a7:	e8 cf 1a 00 00       	call   801b7b <sys_run_env>
  8000ac:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 1) ;
  8000af:	90                   	nop
  8000b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000b3:	8b 00                	mov    (%eax),%eax
  8000b5:	83 f8 01             	cmp    $0x1,%eax
  8000b8:	75 f6                	jne    8000b0 <_main+0x78>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000ba:	e8 2c 18 00 00       	call   8018eb <sys_calculate_free_frames>
  8000bf:	83 ec 08             	sub    $0x8,%esp
  8000c2:	50                   	push   %eax
  8000c3:	68 6c 32 80 00       	push   $0x80326c
  8000c8:	e8 66 04 00 00       	call   800533 <cprintf>
  8000cd:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	ff 75 e8             	pushl  -0x18(%ebp)
  8000d6:	e8 bc 1a 00 00       	call   801b97 <sys_destroy_env>
  8000db:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8000de:	e8 08 18 00 00       	call   8018eb <sys_calculate_free_frames>
  8000e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8000e6:	e8 a0 18 00 00       	call   80198b <sys_pf_calculate_allocated_pages>
  8000eb:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  8000ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000f4:	74 27                	je     80011d <_main+0xe5>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  8000f6:	83 ec 08             	sub    $0x8,%esp
  8000f9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000fc:	68 a0 32 80 00       	push   $0x8032a0
  800101:	e8 2d 04 00 00       	call   800533 <cprintf>
  800106:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  800109:	83 ec 04             	sub    $0x4,%esp
  80010c:	68 f0 32 80 00       	push   $0x8032f0
  800111:	6a 1f                	push   $0x1f
  800113:	68 26 33 80 00       	push   $0x803326
  800118:	e8 62 01 00 00       	call   80027f <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80011d:	83 ec 08             	sub    $0x8,%esp
  800120:	ff 75 e4             	pushl  -0x1c(%ebp)
  800123:	68 3c 33 80 00       	push   $0x80333c
  800128:	e8 06 04 00 00       	call   800533 <cprintf>
  80012d:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 4 for envfree completed successfully.\n");
  800130:	83 ec 0c             	sub    $0xc,%esp
  800133:	68 9c 33 80 00       	push   $0x80339c
  800138:	e8 f6 03 00 00       	call   800533 <cprintf>
  80013d:	83 c4 10             	add    $0x10,%esp
	return;
  800140:	90                   	nop
}
  800141:	c9                   	leave  
  800142:	c3                   	ret    

00800143 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800143:	55                   	push   %ebp
  800144:	89 e5                	mov    %esp,%ebp
  800146:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800149:	e8 7d 1a 00 00       	call   801bcb <sys_getenvindex>
  80014e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800151:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800154:	89 d0                	mov    %edx,%eax
  800156:	c1 e0 03             	shl    $0x3,%eax
  800159:	01 d0                	add    %edx,%eax
  80015b:	01 c0                	add    %eax,%eax
  80015d:	01 d0                	add    %edx,%eax
  80015f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800166:	01 d0                	add    %edx,%eax
  800168:	c1 e0 04             	shl    $0x4,%eax
  80016b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800170:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800175:	a1 20 40 80 00       	mov    0x804020,%eax
  80017a:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800180:	84 c0                	test   %al,%al
  800182:	74 0f                	je     800193 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800184:	a1 20 40 80 00       	mov    0x804020,%eax
  800189:	05 5c 05 00 00       	add    $0x55c,%eax
  80018e:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800193:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800197:	7e 0a                	jle    8001a3 <libmain+0x60>
		binaryname = argv[0];
  800199:	8b 45 0c             	mov    0xc(%ebp),%eax
  80019c:	8b 00                	mov    (%eax),%eax
  80019e:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001a3:	83 ec 08             	sub    $0x8,%esp
  8001a6:	ff 75 0c             	pushl  0xc(%ebp)
  8001a9:	ff 75 08             	pushl  0x8(%ebp)
  8001ac:	e8 87 fe ff ff       	call   800038 <_main>
  8001b1:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001b4:	e8 1f 18 00 00       	call   8019d8 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001b9:	83 ec 0c             	sub    $0xc,%esp
  8001bc:	68 00 34 80 00       	push   $0x803400
  8001c1:	e8 6d 03 00 00       	call   800533 <cprintf>
  8001c6:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001c9:	a1 20 40 80 00       	mov    0x804020,%eax
  8001ce:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001d4:	a1 20 40 80 00       	mov    0x804020,%eax
  8001d9:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001df:	83 ec 04             	sub    $0x4,%esp
  8001e2:	52                   	push   %edx
  8001e3:	50                   	push   %eax
  8001e4:	68 28 34 80 00       	push   $0x803428
  8001e9:	e8 45 03 00 00       	call   800533 <cprintf>
  8001ee:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001f1:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f6:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8001fc:	a1 20 40 80 00       	mov    0x804020,%eax
  800201:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800207:	a1 20 40 80 00       	mov    0x804020,%eax
  80020c:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800212:	51                   	push   %ecx
  800213:	52                   	push   %edx
  800214:	50                   	push   %eax
  800215:	68 50 34 80 00       	push   $0x803450
  80021a:	e8 14 03 00 00       	call   800533 <cprintf>
  80021f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800222:	a1 20 40 80 00       	mov    0x804020,%eax
  800227:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80022d:	83 ec 08             	sub    $0x8,%esp
  800230:	50                   	push   %eax
  800231:	68 a8 34 80 00       	push   $0x8034a8
  800236:	e8 f8 02 00 00       	call   800533 <cprintf>
  80023b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80023e:	83 ec 0c             	sub    $0xc,%esp
  800241:	68 00 34 80 00       	push   $0x803400
  800246:	e8 e8 02 00 00       	call   800533 <cprintf>
  80024b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80024e:	e8 9f 17 00 00       	call   8019f2 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800253:	e8 19 00 00 00       	call   800271 <exit>
}
  800258:	90                   	nop
  800259:	c9                   	leave  
  80025a:	c3                   	ret    

0080025b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80025b:	55                   	push   %ebp
  80025c:	89 e5                	mov    %esp,%ebp
  80025e:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800261:	83 ec 0c             	sub    $0xc,%esp
  800264:	6a 00                	push   $0x0
  800266:	e8 2c 19 00 00       	call   801b97 <sys_destroy_env>
  80026b:	83 c4 10             	add    $0x10,%esp
}
  80026e:	90                   	nop
  80026f:	c9                   	leave  
  800270:	c3                   	ret    

00800271 <exit>:

void
exit(void)
{
  800271:	55                   	push   %ebp
  800272:	89 e5                	mov    %esp,%ebp
  800274:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800277:	e8 81 19 00 00       	call   801bfd <sys_exit_env>
}
  80027c:	90                   	nop
  80027d:	c9                   	leave  
  80027e:	c3                   	ret    

0080027f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80027f:	55                   	push   %ebp
  800280:	89 e5                	mov    %esp,%ebp
  800282:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800285:	8d 45 10             	lea    0x10(%ebp),%eax
  800288:	83 c0 04             	add    $0x4,%eax
  80028b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80028e:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800293:	85 c0                	test   %eax,%eax
  800295:	74 16                	je     8002ad <_panic+0x2e>
		cprintf("%s: ", argv0);
  800297:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80029c:	83 ec 08             	sub    $0x8,%esp
  80029f:	50                   	push   %eax
  8002a0:	68 bc 34 80 00       	push   $0x8034bc
  8002a5:	e8 89 02 00 00       	call   800533 <cprintf>
  8002aa:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002ad:	a1 00 40 80 00       	mov    0x804000,%eax
  8002b2:	ff 75 0c             	pushl  0xc(%ebp)
  8002b5:	ff 75 08             	pushl  0x8(%ebp)
  8002b8:	50                   	push   %eax
  8002b9:	68 c1 34 80 00       	push   $0x8034c1
  8002be:	e8 70 02 00 00       	call   800533 <cprintf>
  8002c3:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c9:	83 ec 08             	sub    $0x8,%esp
  8002cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8002cf:	50                   	push   %eax
  8002d0:	e8 f3 01 00 00       	call   8004c8 <vcprintf>
  8002d5:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002d8:	83 ec 08             	sub    $0x8,%esp
  8002db:	6a 00                	push   $0x0
  8002dd:	68 dd 34 80 00       	push   $0x8034dd
  8002e2:	e8 e1 01 00 00       	call   8004c8 <vcprintf>
  8002e7:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002ea:	e8 82 ff ff ff       	call   800271 <exit>

	// should not return here
	while (1) ;
  8002ef:	eb fe                	jmp    8002ef <_panic+0x70>

008002f1 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002f1:	55                   	push   %ebp
  8002f2:	89 e5                	mov    %esp,%ebp
  8002f4:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002f7:	a1 20 40 80 00       	mov    0x804020,%eax
  8002fc:	8b 50 74             	mov    0x74(%eax),%edx
  8002ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800302:	39 c2                	cmp    %eax,%edx
  800304:	74 14                	je     80031a <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800306:	83 ec 04             	sub    $0x4,%esp
  800309:	68 e0 34 80 00       	push   $0x8034e0
  80030e:	6a 26                	push   $0x26
  800310:	68 2c 35 80 00       	push   $0x80352c
  800315:	e8 65 ff ff ff       	call   80027f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80031a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800321:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800328:	e9 c2 00 00 00       	jmp    8003ef <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80032d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800330:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800337:	8b 45 08             	mov    0x8(%ebp),%eax
  80033a:	01 d0                	add    %edx,%eax
  80033c:	8b 00                	mov    (%eax),%eax
  80033e:	85 c0                	test   %eax,%eax
  800340:	75 08                	jne    80034a <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800342:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800345:	e9 a2 00 00 00       	jmp    8003ec <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80034a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800351:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800358:	eb 69                	jmp    8003c3 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80035a:	a1 20 40 80 00       	mov    0x804020,%eax
  80035f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800365:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800368:	89 d0                	mov    %edx,%eax
  80036a:	01 c0                	add    %eax,%eax
  80036c:	01 d0                	add    %edx,%eax
  80036e:	c1 e0 03             	shl    $0x3,%eax
  800371:	01 c8                	add    %ecx,%eax
  800373:	8a 40 04             	mov    0x4(%eax),%al
  800376:	84 c0                	test   %al,%al
  800378:	75 46                	jne    8003c0 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80037a:	a1 20 40 80 00       	mov    0x804020,%eax
  80037f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800385:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800388:	89 d0                	mov    %edx,%eax
  80038a:	01 c0                	add    %eax,%eax
  80038c:	01 d0                	add    %edx,%eax
  80038e:	c1 e0 03             	shl    $0x3,%eax
  800391:	01 c8                	add    %ecx,%eax
  800393:	8b 00                	mov    (%eax),%eax
  800395:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800398:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80039b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003a0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8003af:	01 c8                	add    %ecx,%eax
  8003b1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003b3:	39 c2                	cmp    %eax,%edx
  8003b5:	75 09                	jne    8003c0 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003b7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003be:	eb 12                	jmp    8003d2 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003c0:	ff 45 e8             	incl   -0x18(%ebp)
  8003c3:	a1 20 40 80 00       	mov    0x804020,%eax
  8003c8:	8b 50 74             	mov    0x74(%eax),%edx
  8003cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003ce:	39 c2                	cmp    %eax,%edx
  8003d0:	77 88                	ja     80035a <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003d2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003d6:	75 14                	jne    8003ec <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003d8:	83 ec 04             	sub    $0x4,%esp
  8003db:	68 38 35 80 00       	push   $0x803538
  8003e0:	6a 3a                	push   $0x3a
  8003e2:	68 2c 35 80 00       	push   $0x80352c
  8003e7:	e8 93 fe ff ff       	call   80027f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003ec:	ff 45 f0             	incl   -0x10(%ebp)
  8003ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003f5:	0f 8c 32 ff ff ff    	jl     80032d <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003fb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800402:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800409:	eb 26                	jmp    800431 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80040b:	a1 20 40 80 00       	mov    0x804020,%eax
  800410:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800416:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800419:	89 d0                	mov    %edx,%eax
  80041b:	01 c0                	add    %eax,%eax
  80041d:	01 d0                	add    %edx,%eax
  80041f:	c1 e0 03             	shl    $0x3,%eax
  800422:	01 c8                	add    %ecx,%eax
  800424:	8a 40 04             	mov    0x4(%eax),%al
  800427:	3c 01                	cmp    $0x1,%al
  800429:	75 03                	jne    80042e <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80042b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80042e:	ff 45 e0             	incl   -0x20(%ebp)
  800431:	a1 20 40 80 00       	mov    0x804020,%eax
  800436:	8b 50 74             	mov    0x74(%eax),%edx
  800439:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80043c:	39 c2                	cmp    %eax,%edx
  80043e:	77 cb                	ja     80040b <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800440:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800443:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800446:	74 14                	je     80045c <CheckWSWithoutLastIndex+0x16b>
		panic(
  800448:	83 ec 04             	sub    $0x4,%esp
  80044b:	68 8c 35 80 00       	push   $0x80358c
  800450:	6a 44                	push   $0x44
  800452:	68 2c 35 80 00       	push   $0x80352c
  800457:	e8 23 fe ff ff       	call   80027f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80045c:	90                   	nop
  80045d:	c9                   	leave  
  80045e:	c3                   	ret    

0080045f <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80045f:	55                   	push   %ebp
  800460:	89 e5                	mov    %esp,%ebp
  800462:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800465:	8b 45 0c             	mov    0xc(%ebp),%eax
  800468:	8b 00                	mov    (%eax),%eax
  80046a:	8d 48 01             	lea    0x1(%eax),%ecx
  80046d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800470:	89 0a                	mov    %ecx,(%edx)
  800472:	8b 55 08             	mov    0x8(%ebp),%edx
  800475:	88 d1                	mov    %dl,%cl
  800477:	8b 55 0c             	mov    0xc(%ebp),%edx
  80047a:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80047e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800481:	8b 00                	mov    (%eax),%eax
  800483:	3d ff 00 00 00       	cmp    $0xff,%eax
  800488:	75 2c                	jne    8004b6 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80048a:	a0 24 40 80 00       	mov    0x804024,%al
  80048f:	0f b6 c0             	movzbl %al,%eax
  800492:	8b 55 0c             	mov    0xc(%ebp),%edx
  800495:	8b 12                	mov    (%edx),%edx
  800497:	89 d1                	mov    %edx,%ecx
  800499:	8b 55 0c             	mov    0xc(%ebp),%edx
  80049c:	83 c2 08             	add    $0x8,%edx
  80049f:	83 ec 04             	sub    $0x4,%esp
  8004a2:	50                   	push   %eax
  8004a3:	51                   	push   %ecx
  8004a4:	52                   	push   %edx
  8004a5:	e8 80 13 00 00       	call   80182a <sys_cputs>
  8004aa:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b9:	8b 40 04             	mov    0x4(%eax),%eax
  8004bc:	8d 50 01             	lea    0x1(%eax),%edx
  8004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c2:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004c5:	90                   	nop
  8004c6:	c9                   	leave  
  8004c7:	c3                   	ret    

008004c8 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004c8:	55                   	push   %ebp
  8004c9:	89 e5                	mov    %esp,%ebp
  8004cb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004d1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004d8:	00 00 00 
	b.cnt = 0;
  8004db:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004e2:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004e5:	ff 75 0c             	pushl  0xc(%ebp)
  8004e8:	ff 75 08             	pushl  0x8(%ebp)
  8004eb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004f1:	50                   	push   %eax
  8004f2:	68 5f 04 80 00       	push   $0x80045f
  8004f7:	e8 11 02 00 00       	call   80070d <vprintfmt>
  8004fc:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004ff:	a0 24 40 80 00       	mov    0x804024,%al
  800504:	0f b6 c0             	movzbl %al,%eax
  800507:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80050d:	83 ec 04             	sub    $0x4,%esp
  800510:	50                   	push   %eax
  800511:	52                   	push   %edx
  800512:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800518:	83 c0 08             	add    $0x8,%eax
  80051b:	50                   	push   %eax
  80051c:	e8 09 13 00 00       	call   80182a <sys_cputs>
  800521:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800524:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80052b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800531:	c9                   	leave  
  800532:	c3                   	ret    

00800533 <cprintf>:

int cprintf(const char *fmt, ...) {
  800533:	55                   	push   %ebp
  800534:	89 e5                	mov    %esp,%ebp
  800536:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800539:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800540:	8d 45 0c             	lea    0xc(%ebp),%eax
  800543:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800546:	8b 45 08             	mov    0x8(%ebp),%eax
  800549:	83 ec 08             	sub    $0x8,%esp
  80054c:	ff 75 f4             	pushl  -0xc(%ebp)
  80054f:	50                   	push   %eax
  800550:	e8 73 ff ff ff       	call   8004c8 <vcprintf>
  800555:	83 c4 10             	add    $0x10,%esp
  800558:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80055b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80055e:	c9                   	leave  
  80055f:	c3                   	ret    

00800560 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800560:	55                   	push   %ebp
  800561:	89 e5                	mov    %esp,%ebp
  800563:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800566:	e8 6d 14 00 00       	call   8019d8 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80056b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80056e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800571:	8b 45 08             	mov    0x8(%ebp),%eax
  800574:	83 ec 08             	sub    $0x8,%esp
  800577:	ff 75 f4             	pushl  -0xc(%ebp)
  80057a:	50                   	push   %eax
  80057b:	e8 48 ff ff ff       	call   8004c8 <vcprintf>
  800580:	83 c4 10             	add    $0x10,%esp
  800583:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800586:	e8 67 14 00 00       	call   8019f2 <sys_enable_interrupt>
	return cnt;
  80058b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80058e:	c9                   	leave  
  80058f:	c3                   	ret    

00800590 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800590:	55                   	push   %ebp
  800591:	89 e5                	mov    %esp,%ebp
  800593:	53                   	push   %ebx
  800594:	83 ec 14             	sub    $0x14,%esp
  800597:	8b 45 10             	mov    0x10(%ebp),%eax
  80059a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80059d:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005a3:	8b 45 18             	mov    0x18(%ebp),%eax
  8005a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ab:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ae:	77 55                	ja     800605 <printnum+0x75>
  8005b0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005b3:	72 05                	jb     8005ba <printnum+0x2a>
  8005b5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005b8:	77 4b                	ja     800605 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005ba:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005bd:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005c0:	8b 45 18             	mov    0x18(%ebp),%eax
  8005c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c8:	52                   	push   %edx
  8005c9:	50                   	push   %eax
  8005ca:	ff 75 f4             	pushl  -0xc(%ebp)
  8005cd:	ff 75 f0             	pushl  -0x10(%ebp)
  8005d0:	e8 cf 29 00 00       	call   802fa4 <__udivdi3>
  8005d5:	83 c4 10             	add    $0x10,%esp
  8005d8:	83 ec 04             	sub    $0x4,%esp
  8005db:	ff 75 20             	pushl  0x20(%ebp)
  8005de:	53                   	push   %ebx
  8005df:	ff 75 18             	pushl  0x18(%ebp)
  8005e2:	52                   	push   %edx
  8005e3:	50                   	push   %eax
  8005e4:	ff 75 0c             	pushl  0xc(%ebp)
  8005e7:	ff 75 08             	pushl  0x8(%ebp)
  8005ea:	e8 a1 ff ff ff       	call   800590 <printnum>
  8005ef:	83 c4 20             	add    $0x20,%esp
  8005f2:	eb 1a                	jmp    80060e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005f4:	83 ec 08             	sub    $0x8,%esp
  8005f7:	ff 75 0c             	pushl  0xc(%ebp)
  8005fa:	ff 75 20             	pushl  0x20(%ebp)
  8005fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800600:	ff d0                	call   *%eax
  800602:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800605:	ff 4d 1c             	decl   0x1c(%ebp)
  800608:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80060c:	7f e6                	jg     8005f4 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80060e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800611:	bb 00 00 00 00       	mov    $0x0,%ebx
  800616:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800619:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80061c:	53                   	push   %ebx
  80061d:	51                   	push   %ecx
  80061e:	52                   	push   %edx
  80061f:	50                   	push   %eax
  800620:	e8 8f 2a 00 00       	call   8030b4 <__umoddi3>
  800625:	83 c4 10             	add    $0x10,%esp
  800628:	05 f4 37 80 00       	add    $0x8037f4,%eax
  80062d:	8a 00                	mov    (%eax),%al
  80062f:	0f be c0             	movsbl %al,%eax
  800632:	83 ec 08             	sub    $0x8,%esp
  800635:	ff 75 0c             	pushl  0xc(%ebp)
  800638:	50                   	push   %eax
  800639:	8b 45 08             	mov    0x8(%ebp),%eax
  80063c:	ff d0                	call   *%eax
  80063e:	83 c4 10             	add    $0x10,%esp
}
  800641:	90                   	nop
  800642:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800645:	c9                   	leave  
  800646:	c3                   	ret    

00800647 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800647:	55                   	push   %ebp
  800648:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80064a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80064e:	7e 1c                	jle    80066c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800650:	8b 45 08             	mov    0x8(%ebp),%eax
  800653:	8b 00                	mov    (%eax),%eax
  800655:	8d 50 08             	lea    0x8(%eax),%edx
  800658:	8b 45 08             	mov    0x8(%ebp),%eax
  80065b:	89 10                	mov    %edx,(%eax)
  80065d:	8b 45 08             	mov    0x8(%ebp),%eax
  800660:	8b 00                	mov    (%eax),%eax
  800662:	83 e8 08             	sub    $0x8,%eax
  800665:	8b 50 04             	mov    0x4(%eax),%edx
  800668:	8b 00                	mov    (%eax),%eax
  80066a:	eb 40                	jmp    8006ac <getuint+0x65>
	else if (lflag)
  80066c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800670:	74 1e                	je     800690 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800672:	8b 45 08             	mov    0x8(%ebp),%eax
  800675:	8b 00                	mov    (%eax),%eax
  800677:	8d 50 04             	lea    0x4(%eax),%edx
  80067a:	8b 45 08             	mov    0x8(%ebp),%eax
  80067d:	89 10                	mov    %edx,(%eax)
  80067f:	8b 45 08             	mov    0x8(%ebp),%eax
  800682:	8b 00                	mov    (%eax),%eax
  800684:	83 e8 04             	sub    $0x4,%eax
  800687:	8b 00                	mov    (%eax),%eax
  800689:	ba 00 00 00 00       	mov    $0x0,%edx
  80068e:	eb 1c                	jmp    8006ac <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800690:	8b 45 08             	mov    0x8(%ebp),%eax
  800693:	8b 00                	mov    (%eax),%eax
  800695:	8d 50 04             	lea    0x4(%eax),%edx
  800698:	8b 45 08             	mov    0x8(%ebp),%eax
  80069b:	89 10                	mov    %edx,(%eax)
  80069d:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a0:	8b 00                	mov    (%eax),%eax
  8006a2:	83 e8 04             	sub    $0x4,%eax
  8006a5:	8b 00                	mov    (%eax),%eax
  8006a7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006ac:	5d                   	pop    %ebp
  8006ad:	c3                   	ret    

008006ae <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006ae:	55                   	push   %ebp
  8006af:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006b1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006b5:	7e 1c                	jle    8006d3 <getint+0x25>
		return va_arg(*ap, long long);
  8006b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ba:	8b 00                	mov    (%eax),%eax
  8006bc:	8d 50 08             	lea    0x8(%eax),%edx
  8006bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c2:	89 10                	mov    %edx,(%eax)
  8006c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c7:	8b 00                	mov    (%eax),%eax
  8006c9:	83 e8 08             	sub    $0x8,%eax
  8006cc:	8b 50 04             	mov    0x4(%eax),%edx
  8006cf:	8b 00                	mov    (%eax),%eax
  8006d1:	eb 38                	jmp    80070b <getint+0x5d>
	else if (lflag)
  8006d3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006d7:	74 1a                	je     8006f3 <getint+0x45>
		return va_arg(*ap, long);
  8006d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dc:	8b 00                	mov    (%eax),%eax
  8006de:	8d 50 04             	lea    0x4(%eax),%edx
  8006e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e4:	89 10                	mov    %edx,(%eax)
  8006e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e9:	8b 00                	mov    (%eax),%eax
  8006eb:	83 e8 04             	sub    $0x4,%eax
  8006ee:	8b 00                	mov    (%eax),%eax
  8006f0:	99                   	cltd   
  8006f1:	eb 18                	jmp    80070b <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f6:	8b 00                	mov    (%eax),%eax
  8006f8:	8d 50 04             	lea    0x4(%eax),%edx
  8006fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fe:	89 10                	mov    %edx,(%eax)
  800700:	8b 45 08             	mov    0x8(%ebp),%eax
  800703:	8b 00                	mov    (%eax),%eax
  800705:	83 e8 04             	sub    $0x4,%eax
  800708:	8b 00                	mov    (%eax),%eax
  80070a:	99                   	cltd   
}
  80070b:	5d                   	pop    %ebp
  80070c:	c3                   	ret    

0080070d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80070d:	55                   	push   %ebp
  80070e:	89 e5                	mov    %esp,%ebp
  800710:	56                   	push   %esi
  800711:	53                   	push   %ebx
  800712:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800715:	eb 17                	jmp    80072e <vprintfmt+0x21>
			if (ch == '\0')
  800717:	85 db                	test   %ebx,%ebx
  800719:	0f 84 af 03 00 00    	je     800ace <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80071f:	83 ec 08             	sub    $0x8,%esp
  800722:	ff 75 0c             	pushl  0xc(%ebp)
  800725:	53                   	push   %ebx
  800726:	8b 45 08             	mov    0x8(%ebp),%eax
  800729:	ff d0                	call   *%eax
  80072b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80072e:	8b 45 10             	mov    0x10(%ebp),%eax
  800731:	8d 50 01             	lea    0x1(%eax),%edx
  800734:	89 55 10             	mov    %edx,0x10(%ebp)
  800737:	8a 00                	mov    (%eax),%al
  800739:	0f b6 d8             	movzbl %al,%ebx
  80073c:	83 fb 25             	cmp    $0x25,%ebx
  80073f:	75 d6                	jne    800717 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800741:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800745:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80074c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800753:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80075a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800761:	8b 45 10             	mov    0x10(%ebp),%eax
  800764:	8d 50 01             	lea    0x1(%eax),%edx
  800767:	89 55 10             	mov    %edx,0x10(%ebp)
  80076a:	8a 00                	mov    (%eax),%al
  80076c:	0f b6 d8             	movzbl %al,%ebx
  80076f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800772:	83 f8 55             	cmp    $0x55,%eax
  800775:	0f 87 2b 03 00 00    	ja     800aa6 <vprintfmt+0x399>
  80077b:	8b 04 85 18 38 80 00 	mov    0x803818(,%eax,4),%eax
  800782:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800784:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800788:	eb d7                	jmp    800761 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80078a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80078e:	eb d1                	jmp    800761 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800790:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800797:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80079a:	89 d0                	mov    %edx,%eax
  80079c:	c1 e0 02             	shl    $0x2,%eax
  80079f:	01 d0                	add    %edx,%eax
  8007a1:	01 c0                	add    %eax,%eax
  8007a3:	01 d8                	add    %ebx,%eax
  8007a5:	83 e8 30             	sub    $0x30,%eax
  8007a8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ae:	8a 00                	mov    (%eax),%al
  8007b0:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007b3:	83 fb 2f             	cmp    $0x2f,%ebx
  8007b6:	7e 3e                	jle    8007f6 <vprintfmt+0xe9>
  8007b8:	83 fb 39             	cmp    $0x39,%ebx
  8007bb:	7f 39                	jg     8007f6 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007bd:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007c0:	eb d5                	jmp    800797 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c5:	83 c0 04             	add    $0x4,%eax
  8007c8:	89 45 14             	mov    %eax,0x14(%ebp)
  8007cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ce:	83 e8 04             	sub    $0x4,%eax
  8007d1:	8b 00                	mov    (%eax),%eax
  8007d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007d6:	eb 1f                	jmp    8007f7 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007d8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007dc:	79 83                	jns    800761 <vprintfmt+0x54>
				width = 0;
  8007de:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007e5:	e9 77 ff ff ff       	jmp    800761 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007ea:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007f1:	e9 6b ff ff ff       	jmp    800761 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007f6:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007fb:	0f 89 60 ff ff ff    	jns    800761 <vprintfmt+0x54>
				width = precision, precision = -1;
  800801:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800804:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800807:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80080e:	e9 4e ff ff ff       	jmp    800761 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800813:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800816:	e9 46 ff ff ff       	jmp    800761 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80081b:	8b 45 14             	mov    0x14(%ebp),%eax
  80081e:	83 c0 04             	add    $0x4,%eax
  800821:	89 45 14             	mov    %eax,0x14(%ebp)
  800824:	8b 45 14             	mov    0x14(%ebp),%eax
  800827:	83 e8 04             	sub    $0x4,%eax
  80082a:	8b 00                	mov    (%eax),%eax
  80082c:	83 ec 08             	sub    $0x8,%esp
  80082f:	ff 75 0c             	pushl  0xc(%ebp)
  800832:	50                   	push   %eax
  800833:	8b 45 08             	mov    0x8(%ebp),%eax
  800836:	ff d0                	call   *%eax
  800838:	83 c4 10             	add    $0x10,%esp
			break;
  80083b:	e9 89 02 00 00       	jmp    800ac9 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800840:	8b 45 14             	mov    0x14(%ebp),%eax
  800843:	83 c0 04             	add    $0x4,%eax
  800846:	89 45 14             	mov    %eax,0x14(%ebp)
  800849:	8b 45 14             	mov    0x14(%ebp),%eax
  80084c:	83 e8 04             	sub    $0x4,%eax
  80084f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800851:	85 db                	test   %ebx,%ebx
  800853:	79 02                	jns    800857 <vprintfmt+0x14a>
				err = -err;
  800855:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800857:	83 fb 64             	cmp    $0x64,%ebx
  80085a:	7f 0b                	jg     800867 <vprintfmt+0x15a>
  80085c:	8b 34 9d 60 36 80 00 	mov    0x803660(,%ebx,4),%esi
  800863:	85 f6                	test   %esi,%esi
  800865:	75 19                	jne    800880 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800867:	53                   	push   %ebx
  800868:	68 05 38 80 00       	push   $0x803805
  80086d:	ff 75 0c             	pushl  0xc(%ebp)
  800870:	ff 75 08             	pushl  0x8(%ebp)
  800873:	e8 5e 02 00 00       	call   800ad6 <printfmt>
  800878:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80087b:	e9 49 02 00 00       	jmp    800ac9 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800880:	56                   	push   %esi
  800881:	68 0e 38 80 00       	push   $0x80380e
  800886:	ff 75 0c             	pushl  0xc(%ebp)
  800889:	ff 75 08             	pushl  0x8(%ebp)
  80088c:	e8 45 02 00 00       	call   800ad6 <printfmt>
  800891:	83 c4 10             	add    $0x10,%esp
			break;
  800894:	e9 30 02 00 00       	jmp    800ac9 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800899:	8b 45 14             	mov    0x14(%ebp),%eax
  80089c:	83 c0 04             	add    $0x4,%eax
  80089f:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a5:	83 e8 04             	sub    $0x4,%eax
  8008a8:	8b 30                	mov    (%eax),%esi
  8008aa:	85 f6                	test   %esi,%esi
  8008ac:	75 05                	jne    8008b3 <vprintfmt+0x1a6>
				p = "(null)";
  8008ae:	be 11 38 80 00       	mov    $0x803811,%esi
			if (width > 0 && padc != '-')
  8008b3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008b7:	7e 6d                	jle    800926 <vprintfmt+0x219>
  8008b9:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008bd:	74 67                	je     800926 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c2:	83 ec 08             	sub    $0x8,%esp
  8008c5:	50                   	push   %eax
  8008c6:	56                   	push   %esi
  8008c7:	e8 0c 03 00 00       	call   800bd8 <strnlen>
  8008cc:	83 c4 10             	add    $0x10,%esp
  8008cf:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008d2:	eb 16                	jmp    8008ea <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008d4:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008d8:	83 ec 08             	sub    $0x8,%esp
  8008db:	ff 75 0c             	pushl  0xc(%ebp)
  8008de:	50                   	push   %eax
  8008df:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e2:	ff d0                	call   *%eax
  8008e4:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008e7:	ff 4d e4             	decl   -0x1c(%ebp)
  8008ea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ee:	7f e4                	jg     8008d4 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008f0:	eb 34                	jmp    800926 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008f2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008f6:	74 1c                	je     800914 <vprintfmt+0x207>
  8008f8:	83 fb 1f             	cmp    $0x1f,%ebx
  8008fb:	7e 05                	jle    800902 <vprintfmt+0x1f5>
  8008fd:	83 fb 7e             	cmp    $0x7e,%ebx
  800900:	7e 12                	jle    800914 <vprintfmt+0x207>
					putch('?', putdat);
  800902:	83 ec 08             	sub    $0x8,%esp
  800905:	ff 75 0c             	pushl  0xc(%ebp)
  800908:	6a 3f                	push   $0x3f
  80090a:	8b 45 08             	mov    0x8(%ebp),%eax
  80090d:	ff d0                	call   *%eax
  80090f:	83 c4 10             	add    $0x10,%esp
  800912:	eb 0f                	jmp    800923 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800914:	83 ec 08             	sub    $0x8,%esp
  800917:	ff 75 0c             	pushl  0xc(%ebp)
  80091a:	53                   	push   %ebx
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	ff d0                	call   *%eax
  800920:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800923:	ff 4d e4             	decl   -0x1c(%ebp)
  800926:	89 f0                	mov    %esi,%eax
  800928:	8d 70 01             	lea    0x1(%eax),%esi
  80092b:	8a 00                	mov    (%eax),%al
  80092d:	0f be d8             	movsbl %al,%ebx
  800930:	85 db                	test   %ebx,%ebx
  800932:	74 24                	je     800958 <vprintfmt+0x24b>
  800934:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800938:	78 b8                	js     8008f2 <vprintfmt+0x1e5>
  80093a:	ff 4d e0             	decl   -0x20(%ebp)
  80093d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800941:	79 af                	jns    8008f2 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800943:	eb 13                	jmp    800958 <vprintfmt+0x24b>
				putch(' ', putdat);
  800945:	83 ec 08             	sub    $0x8,%esp
  800948:	ff 75 0c             	pushl  0xc(%ebp)
  80094b:	6a 20                	push   $0x20
  80094d:	8b 45 08             	mov    0x8(%ebp),%eax
  800950:	ff d0                	call   *%eax
  800952:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800955:	ff 4d e4             	decl   -0x1c(%ebp)
  800958:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80095c:	7f e7                	jg     800945 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80095e:	e9 66 01 00 00       	jmp    800ac9 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800963:	83 ec 08             	sub    $0x8,%esp
  800966:	ff 75 e8             	pushl  -0x18(%ebp)
  800969:	8d 45 14             	lea    0x14(%ebp),%eax
  80096c:	50                   	push   %eax
  80096d:	e8 3c fd ff ff       	call   8006ae <getint>
  800972:	83 c4 10             	add    $0x10,%esp
  800975:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800978:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80097b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80097e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800981:	85 d2                	test   %edx,%edx
  800983:	79 23                	jns    8009a8 <vprintfmt+0x29b>
				putch('-', putdat);
  800985:	83 ec 08             	sub    $0x8,%esp
  800988:	ff 75 0c             	pushl  0xc(%ebp)
  80098b:	6a 2d                	push   $0x2d
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	ff d0                	call   *%eax
  800992:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800995:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800998:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80099b:	f7 d8                	neg    %eax
  80099d:	83 d2 00             	adc    $0x0,%edx
  8009a0:	f7 da                	neg    %edx
  8009a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009a8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009af:	e9 bc 00 00 00       	jmp    800a70 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009b4:	83 ec 08             	sub    $0x8,%esp
  8009b7:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ba:	8d 45 14             	lea    0x14(%ebp),%eax
  8009bd:	50                   	push   %eax
  8009be:	e8 84 fc ff ff       	call   800647 <getuint>
  8009c3:	83 c4 10             	add    $0x10,%esp
  8009c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009cc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009d3:	e9 98 00 00 00       	jmp    800a70 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009d8:	83 ec 08             	sub    $0x8,%esp
  8009db:	ff 75 0c             	pushl  0xc(%ebp)
  8009de:	6a 58                	push   $0x58
  8009e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e3:	ff d0                	call   *%eax
  8009e5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009e8:	83 ec 08             	sub    $0x8,%esp
  8009eb:	ff 75 0c             	pushl  0xc(%ebp)
  8009ee:	6a 58                	push   $0x58
  8009f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f3:	ff d0                	call   *%eax
  8009f5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009f8:	83 ec 08             	sub    $0x8,%esp
  8009fb:	ff 75 0c             	pushl  0xc(%ebp)
  8009fe:	6a 58                	push   $0x58
  800a00:	8b 45 08             	mov    0x8(%ebp),%eax
  800a03:	ff d0                	call   *%eax
  800a05:	83 c4 10             	add    $0x10,%esp
			break;
  800a08:	e9 bc 00 00 00       	jmp    800ac9 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a0d:	83 ec 08             	sub    $0x8,%esp
  800a10:	ff 75 0c             	pushl  0xc(%ebp)
  800a13:	6a 30                	push   $0x30
  800a15:	8b 45 08             	mov    0x8(%ebp),%eax
  800a18:	ff d0                	call   *%eax
  800a1a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a1d:	83 ec 08             	sub    $0x8,%esp
  800a20:	ff 75 0c             	pushl  0xc(%ebp)
  800a23:	6a 78                	push   $0x78
  800a25:	8b 45 08             	mov    0x8(%ebp),%eax
  800a28:	ff d0                	call   *%eax
  800a2a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a30:	83 c0 04             	add    $0x4,%eax
  800a33:	89 45 14             	mov    %eax,0x14(%ebp)
  800a36:	8b 45 14             	mov    0x14(%ebp),%eax
  800a39:	83 e8 04             	sub    $0x4,%eax
  800a3c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a41:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a48:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a4f:	eb 1f                	jmp    800a70 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a51:	83 ec 08             	sub    $0x8,%esp
  800a54:	ff 75 e8             	pushl  -0x18(%ebp)
  800a57:	8d 45 14             	lea    0x14(%ebp),%eax
  800a5a:	50                   	push   %eax
  800a5b:	e8 e7 fb ff ff       	call   800647 <getuint>
  800a60:	83 c4 10             	add    $0x10,%esp
  800a63:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a66:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a69:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a70:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a77:	83 ec 04             	sub    $0x4,%esp
  800a7a:	52                   	push   %edx
  800a7b:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a7e:	50                   	push   %eax
  800a7f:	ff 75 f4             	pushl  -0xc(%ebp)
  800a82:	ff 75 f0             	pushl  -0x10(%ebp)
  800a85:	ff 75 0c             	pushl  0xc(%ebp)
  800a88:	ff 75 08             	pushl  0x8(%ebp)
  800a8b:	e8 00 fb ff ff       	call   800590 <printnum>
  800a90:	83 c4 20             	add    $0x20,%esp
			break;
  800a93:	eb 34                	jmp    800ac9 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a95:	83 ec 08             	sub    $0x8,%esp
  800a98:	ff 75 0c             	pushl  0xc(%ebp)
  800a9b:	53                   	push   %ebx
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	ff d0                	call   *%eax
  800aa1:	83 c4 10             	add    $0x10,%esp
			break;
  800aa4:	eb 23                	jmp    800ac9 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800aa6:	83 ec 08             	sub    $0x8,%esp
  800aa9:	ff 75 0c             	pushl  0xc(%ebp)
  800aac:	6a 25                	push   $0x25
  800aae:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab1:	ff d0                	call   *%eax
  800ab3:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ab6:	ff 4d 10             	decl   0x10(%ebp)
  800ab9:	eb 03                	jmp    800abe <vprintfmt+0x3b1>
  800abb:	ff 4d 10             	decl   0x10(%ebp)
  800abe:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac1:	48                   	dec    %eax
  800ac2:	8a 00                	mov    (%eax),%al
  800ac4:	3c 25                	cmp    $0x25,%al
  800ac6:	75 f3                	jne    800abb <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800ac8:	90                   	nop
		}
	}
  800ac9:	e9 47 fc ff ff       	jmp    800715 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ace:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800acf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ad2:	5b                   	pop    %ebx
  800ad3:	5e                   	pop    %esi
  800ad4:	5d                   	pop    %ebp
  800ad5:	c3                   	ret    

00800ad6 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ad6:	55                   	push   %ebp
  800ad7:	89 e5                	mov    %esp,%ebp
  800ad9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800adc:	8d 45 10             	lea    0x10(%ebp),%eax
  800adf:	83 c0 04             	add    $0x4,%eax
  800ae2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ae5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae8:	ff 75 f4             	pushl  -0xc(%ebp)
  800aeb:	50                   	push   %eax
  800aec:	ff 75 0c             	pushl  0xc(%ebp)
  800aef:	ff 75 08             	pushl  0x8(%ebp)
  800af2:	e8 16 fc ff ff       	call   80070d <vprintfmt>
  800af7:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800afa:	90                   	nop
  800afb:	c9                   	leave  
  800afc:	c3                   	ret    

00800afd <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800afd:	55                   	push   %ebp
  800afe:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b03:	8b 40 08             	mov    0x8(%eax),%eax
  800b06:	8d 50 01             	lea    0x1(%eax),%edx
  800b09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b12:	8b 10                	mov    (%eax),%edx
  800b14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b17:	8b 40 04             	mov    0x4(%eax),%eax
  800b1a:	39 c2                	cmp    %eax,%edx
  800b1c:	73 12                	jae    800b30 <sprintputch+0x33>
		*b->buf++ = ch;
  800b1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b21:	8b 00                	mov    (%eax),%eax
  800b23:	8d 48 01             	lea    0x1(%eax),%ecx
  800b26:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b29:	89 0a                	mov    %ecx,(%edx)
  800b2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800b2e:	88 10                	mov    %dl,(%eax)
}
  800b30:	90                   	nop
  800b31:	5d                   	pop    %ebp
  800b32:	c3                   	ret    

00800b33 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b33:	55                   	push   %ebp
  800b34:	89 e5                	mov    %esp,%ebp
  800b36:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b39:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b42:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b45:	8b 45 08             	mov    0x8(%ebp),%eax
  800b48:	01 d0                	add    %edx,%eax
  800b4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b4d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b54:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b58:	74 06                	je     800b60 <vsnprintf+0x2d>
  800b5a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b5e:	7f 07                	jg     800b67 <vsnprintf+0x34>
		return -E_INVAL;
  800b60:	b8 03 00 00 00       	mov    $0x3,%eax
  800b65:	eb 20                	jmp    800b87 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b67:	ff 75 14             	pushl  0x14(%ebp)
  800b6a:	ff 75 10             	pushl  0x10(%ebp)
  800b6d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b70:	50                   	push   %eax
  800b71:	68 fd 0a 80 00       	push   $0x800afd
  800b76:	e8 92 fb ff ff       	call   80070d <vprintfmt>
  800b7b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b81:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b87:	c9                   	leave  
  800b88:	c3                   	ret    

00800b89 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b89:	55                   	push   %ebp
  800b8a:	89 e5                	mov    %esp,%ebp
  800b8c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b8f:	8d 45 10             	lea    0x10(%ebp),%eax
  800b92:	83 c0 04             	add    $0x4,%eax
  800b95:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b98:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9b:	ff 75 f4             	pushl  -0xc(%ebp)
  800b9e:	50                   	push   %eax
  800b9f:	ff 75 0c             	pushl  0xc(%ebp)
  800ba2:	ff 75 08             	pushl  0x8(%ebp)
  800ba5:	e8 89 ff ff ff       	call   800b33 <vsnprintf>
  800baa:	83 c4 10             	add    $0x10,%esp
  800bad:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bb3:	c9                   	leave  
  800bb4:	c3                   	ret    

00800bb5 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bb5:	55                   	push   %ebp
  800bb6:	89 e5                	mov    %esp,%ebp
  800bb8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bbb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bc2:	eb 06                	jmp    800bca <strlen+0x15>
		n++;
  800bc4:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bc7:	ff 45 08             	incl   0x8(%ebp)
  800bca:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcd:	8a 00                	mov    (%eax),%al
  800bcf:	84 c0                	test   %al,%al
  800bd1:	75 f1                	jne    800bc4 <strlen+0xf>
		n++;
	return n;
  800bd3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bd6:	c9                   	leave  
  800bd7:	c3                   	ret    

00800bd8 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bd8:	55                   	push   %ebp
  800bd9:	89 e5                	mov    %esp,%ebp
  800bdb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bde:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800be5:	eb 09                	jmp    800bf0 <strnlen+0x18>
		n++;
  800be7:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bea:	ff 45 08             	incl   0x8(%ebp)
  800bed:	ff 4d 0c             	decl   0xc(%ebp)
  800bf0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf4:	74 09                	je     800bff <strnlen+0x27>
  800bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf9:	8a 00                	mov    (%eax),%al
  800bfb:	84 c0                	test   %al,%al
  800bfd:	75 e8                	jne    800be7 <strnlen+0xf>
		n++;
	return n;
  800bff:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c02:	c9                   	leave  
  800c03:	c3                   	ret    

00800c04 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
  800c07:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c10:	90                   	nop
  800c11:	8b 45 08             	mov    0x8(%ebp),%eax
  800c14:	8d 50 01             	lea    0x1(%eax),%edx
  800c17:	89 55 08             	mov    %edx,0x8(%ebp)
  800c1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c1d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c20:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c23:	8a 12                	mov    (%edx),%dl
  800c25:	88 10                	mov    %dl,(%eax)
  800c27:	8a 00                	mov    (%eax),%al
  800c29:	84 c0                	test   %al,%al
  800c2b:	75 e4                	jne    800c11 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c30:	c9                   	leave  
  800c31:	c3                   	ret    

00800c32 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c32:	55                   	push   %ebp
  800c33:	89 e5                	mov    %esp,%ebp
  800c35:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c3e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c45:	eb 1f                	jmp    800c66 <strncpy+0x34>
		*dst++ = *src;
  800c47:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4a:	8d 50 01             	lea    0x1(%eax),%edx
  800c4d:	89 55 08             	mov    %edx,0x8(%ebp)
  800c50:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c53:	8a 12                	mov    (%edx),%dl
  800c55:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5a:	8a 00                	mov    (%eax),%al
  800c5c:	84 c0                	test   %al,%al
  800c5e:	74 03                	je     800c63 <strncpy+0x31>
			src++;
  800c60:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c63:	ff 45 fc             	incl   -0x4(%ebp)
  800c66:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c69:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c6c:	72 d9                	jb     800c47 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c71:	c9                   	leave  
  800c72:	c3                   	ret    

00800c73 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c73:	55                   	push   %ebp
  800c74:	89 e5                	mov    %esp,%ebp
  800c76:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c79:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c7f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c83:	74 30                	je     800cb5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c85:	eb 16                	jmp    800c9d <strlcpy+0x2a>
			*dst++ = *src++;
  800c87:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8a:	8d 50 01             	lea    0x1(%eax),%edx
  800c8d:	89 55 08             	mov    %edx,0x8(%ebp)
  800c90:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c93:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c96:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c99:	8a 12                	mov    (%edx),%dl
  800c9b:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c9d:	ff 4d 10             	decl   0x10(%ebp)
  800ca0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ca4:	74 09                	je     800caf <strlcpy+0x3c>
  800ca6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca9:	8a 00                	mov    (%eax),%al
  800cab:	84 c0                	test   %al,%al
  800cad:	75 d8                	jne    800c87 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cb5:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cbb:	29 c2                	sub    %eax,%edx
  800cbd:	89 d0                	mov    %edx,%eax
}
  800cbf:	c9                   	leave  
  800cc0:	c3                   	ret    

00800cc1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cc1:	55                   	push   %ebp
  800cc2:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cc4:	eb 06                	jmp    800ccc <strcmp+0xb>
		p++, q++;
  800cc6:	ff 45 08             	incl   0x8(%ebp)
  800cc9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccf:	8a 00                	mov    (%eax),%al
  800cd1:	84 c0                	test   %al,%al
  800cd3:	74 0e                	je     800ce3 <strcmp+0x22>
  800cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd8:	8a 10                	mov    (%eax),%dl
  800cda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdd:	8a 00                	mov    (%eax),%al
  800cdf:	38 c2                	cmp    %al,%dl
  800ce1:	74 e3                	je     800cc6 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce6:	8a 00                	mov    (%eax),%al
  800ce8:	0f b6 d0             	movzbl %al,%edx
  800ceb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cee:	8a 00                	mov    (%eax),%al
  800cf0:	0f b6 c0             	movzbl %al,%eax
  800cf3:	29 c2                	sub    %eax,%edx
  800cf5:	89 d0                	mov    %edx,%eax
}
  800cf7:	5d                   	pop    %ebp
  800cf8:	c3                   	ret    

00800cf9 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cf9:	55                   	push   %ebp
  800cfa:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cfc:	eb 09                	jmp    800d07 <strncmp+0xe>
		n--, p++, q++;
  800cfe:	ff 4d 10             	decl   0x10(%ebp)
  800d01:	ff 45 08             	incl   0x8(%ebp)
  800d04:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d07:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d0b:	74 17                	je     800d24 <strncmp+0x2b>
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	84 c0                	test   %al,%al
  800d14:	74 0e                	je     800d24 <strncmp+0x2b>
  800d16:	8b 45 08             	mov    0x8(%ebp),%eax
  800d19:	8a 10                	mov    (%eax),%dl
  800d1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1e:	8a 00                	mov    (%eax),%al
  800d20:	38 c2                	cmp    %al,%dl
  800d22:	74 da                	je     800cfe <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d24:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d28:	75 07                	jne    800d31 <strncmp+0x38>
		return 0;
  800d2a:	b8 00 00 00 00       	mov    $0x0,%eax
  800d2f:	eb 14                	jmp    800d45 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
  800d34:	8a 00                	mov    (%eax),%al
  800d36:	0f b6 d0             	movzbl %al,%edx
  800d39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3c:	8a 00                	mov    (%eax),%al
  800d3e:	0f b6 c0             	movzbl %al,%eax
  800d41:	29 c2                	sub    %eax,%edx
  800d43:	89 d0                	mov    %edx,%eax
}
  800d45:	5d                   	pop    %ebp
  800d46:	c3                   	ret    

00800d47 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d47:	55                   	push   %ebp
  800d48:	89 e5                	mov    %esp,%ebp
  800d4a:	83 ec 04             	sub    $0x4,%esp
  800d4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d50:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d53:	eb 12                	jmp    800d67 <strchr+0x20>
		if (*s == c)
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	8a 00                	mov    (%eax),%al
  800d5a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d5d:	75 05                	jne    800d64 <strchr+0x1d>
			return (char *) s;
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	eb 11                	jmp    800d75 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d64:	ff 45 08             	incl   0x8(%ebp)
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	8a 00                	mov    (%eax),%al
  800d6c:	84 c0                	test   %al,%al
  800d6e:	75 e5                	jne    800d55 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d75:	c9                   	leave  
  800d76:	c3                   	ret    

00800d77 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d77:	55                   	push   %ebp
  800d78:	89 e5                	mov    %esp,%ebp
  800d7a:	83 ec 04             	sub    $0x4,%esp
  800d7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d80:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d83:	eb 0d                	jmp    800d92 <strfind+0x1b>
		if (*s == c)
  800d85:	8b 45 08             	mov    0x8(%ebp),%eax
  800d88:	8a 00                	mov    (%eax),%al
  800d8a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d8d:	74 0e                	je     800d9d <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d8f:	ff 45 08             	incl   0x8(%ebp)
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	8a 00                	mov    (%eax),%al
  800d97:	84 c0                	test   %al,%al
  800d99:	75 ea                	jne    800d85 <strfind+0xe>
  800d9b:	eb 01                	jmp    800d9e <strfind+0x27>
		if (*s == c)
			break;
  800d9d:	90                   	nop
	return (char *) s;
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800da1:	c9                   	leave  
  800da2:	c3                   	ret    

00800da3 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800da3:	55                   	push   %ebp
  800da4:	89 e5                	mov    %esp,%ebp
  800da6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800da9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800daf:	8b 45 10             	mov    0x10(%ebp),%eax
  800db2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800db5:	eb 0e                	jmp    800dc5 <memset+0x22>
		*p++ = c;
  800db7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dba:	8d 50 01             	lea    0x1(%eax),%edx
  800dbd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc3:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dc5:	ff 4d f8             	decl   -0x8(%ebp)
  800dc8:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dcc:	79 e9                	jns    800db7 <memset+0x14>
		*p++ = c;

	return v;
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd1:	c9                   	leave  
  800dd2:	c3                   	ret    

00800dd3 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dd3:	55                   	push   %ebp
  800dd4:	89 e5                	mov    %esp,%ebp
  800dd6:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  800de2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800de5:	eb 16                	jmp    800dfd <memcpy+0x2a>
		*d++ = *s++;
  800de7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dea:	8d 50 01             	lea    0x1(%eax),%edx
  800ded:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800df0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800df3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800df6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800df9:	8a 12                	mov    (%edx),%dl
  800dfb:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800dfd:	8b 45 10             	mov    0x10(%ebp),%eax
  800e00:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e03:	89 55 10             	mov    %edx,0x10(%ebp)
  800e06:	85 c0                	test   %eax,%eax
  800e08:	75 dd                	jne    800de7 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e0a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e0d:	c9                   	leave  
  800e0e:	c3                   	ret    

00800e0f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e0f:	55                   	push   %ebp
  800e10:	89 e5                	mov    %esp,%ebp
  800e12:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e18:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e21:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e24:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e27:	73 50                	jae    800e79 <memmove+0x6a>
  800e29:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2f:	01 d0                	add    %edx,%eax
  800e31:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e34:	76 43                	jbe    800e79 <memmove+0x6a>
		s += n;
  800e36:	8b 45 10             	mov    0x10(%ebp),%eax
  800e39:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e3c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e42:	eb 10                	jmp    800e54 <memmove+0x45>
			*--d = *--s;
  800e44:	ff 4d f8             	decl   -0x8(%ebp)
  800e47:	ff 4d fc             	decl   -0x4(%ebp)
  800e4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e4d:	8a 10                	mov    (%eax),%dl
  800e4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e52:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e54:	8b 45 10             	mov    0x10(%ebp),%eax
  800e57:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e5a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e5d:	85 c0                	test   %eax,%eax
  800e5f:	75 e3                	jne    800e44 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e61:	eb 23                	jmp    800e86 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e63:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e66:	8d 50 01             	lea    0x1(%eax),%edx
  800e69:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e6c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e6f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e72:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e75:	8a 12                	mov    (%edx),%dl
  800e77:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e79:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e7f:	89 55 10             	mov    %edx,0x10(%ebp)
  800e82:	85 c0                	test   %eax,%eax
  800e84:	75 dd                	jne    800e63 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e86:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e89:	c9                   	leave  
  800e8a:	c3                   	ret    

00800e8b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e8b:	55                   	push   %ebp
  800e8c:	89 e5                	mov    %esp,%ebp
  800e8e:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
  800e94:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9a:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e9d:	eb 2a                	jmp    800ec9 <memcmp+0x3e>
		if (*s1 != *s2)
  800e9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea2:	8a 10                	mov    (%eax),%dl
  800ea4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea7:	8a 00                	mov    (%eax),%al
  800ea9:	38 c2                	cmp    %al,%dl
  800eab:	74 16                	je     800ec3 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ead:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb0:	8a 00                	mov    (%eax),%al
  800eb2:	0f b6 d0             	movzbl %al,%edx
  800eb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb8:	8a 00                	mov    (%eax),%al
  800eba:	0f b6 c0             	movzbl %al,%eax
  800ebd:	29 c2                	sub    %eax,%edx
  800ebf:	89 d0                	mov    %edx,%eax
  800ec1:	eb 18                	jmp    800edb <memcmp+0x50>
		s1++, s2++;
  800ec3:	ff 45 fc             	incl   -0x4(%ebp)
  800ec6:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ec9:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ecf:	89 55 10             	mov    %edx,0x10(%ebp)
  800ed2:	85 c0                	test   %eax,%eax
  800ed4:	75 c9                	jne    800e9f <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ed6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800edb:	c9                   	leave  
  800edc:	c3                   	ret    

00800edd <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800edd:	55                   	push   %ebp
  800ede:	89 e5                	mov    %esp,%ebp
  800ee0:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ee3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee9:	01 d0                	add    %edx,%eax
  800eeb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800eee:	eb 15                	jmp    800f05 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef3:	8a 00                	mov    (%eax),%al
  800ef5:	0f b6 d0             	movzbl %al,%edx
  800ef8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efb:	0f b6 c0             	movzbl %al,%eax
  800efe:	39 c2                	cmp    %eax,%edx
  800f00:	74 0d                	je     800f0f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f02:	ff 45 08             	incl   0x8(%ebp)
  800f05:	8b 45 08             	mov    0x8(%ebp),%eax
  800f08:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f0b:	72 e3                	jb     800ef0 <memfind+0x13>
  800f0d:	eb 01                	jmp    800f10 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f0f:	90                   	nop
	return (void *) s;
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f13:	c9                   	leave  
  800f14:	c3                   	ret    

00800f15 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f15:	55                   	push   %ebp
  800f16:	89 e5                	mov    %esp,%ebp
  800f18:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f1b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f22:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f29:	eb 03                	jmp    800f2e <strtol+0x19>
		s++;
  800f2b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f31:	8a 00                	mov    (%eax),%al
  800f33:	3c 20                	cmp    $0x20,%al
  800f35:	74 f4                	je     800f2b <strtol+0x16>
  800f37:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3a:	8a 00                	mov    (%eax),%al
  800f3c:	3c 09                	cmp    $0x9,%al
  800f3e:	74 eb                	je     800f2b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f40:	8b 45 08             	mov    0x8(%ebp),%eax
  800f43:	8a 00                	mov    (%eax),%al
  800f45:	3c 2b                	cmp    $0x2b,%al
  800f47:	75 05                	jne    800f4e <strtol+0x39>
		s++;
  800f49:	ff 45 08             	incl   0x8(%ebp)
  800f4c:	eb 13                	jmp    800f61 <strtol+0x4c>
	else if (*s == '-')
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f51:	8a 00                	mov    (%eax),%al
  800f53:	3c 2d                	cmp    $0x2d,%al
  800f55:	75 0a                	jne    800f61 <strtol+0x4c>
		s++, neg = 1;
  800f57:	ff 45 08             	incl   0x8(%ebp)
  800f5a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f61:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f65:	74 06                	je     800f6d <strtol+0x58>
  800f67:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f6b:	75 20                	jne    800f8d <strtol+0x78>
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	8a 00                	mov    (%eax),%al
  800f72:	3c 30                	cmp    $0x30,%al
  800f74:	75 17                	jne    800f8d <strtol+0x78>
  800f76:	8b 45 08             	mov    0x8(%ebp),%eax
  800f79:	40                   	inc    %eax
  800f7a:	8a 00                	mov    (%eax),%al
  800f7c:	3c 78                	cmp    $0x78,%al
  800f7e:	75 0d                	jne    800f8d <strtol+0x78>
		s += 2, base = 16;
  800f80:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f84:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f8b:	eb 28                	jmp    800fb5 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f8d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f91:	75 15                	jne    800fa8 <strtol+0x93>
  800f93:	8b 45 08             	mov    0x8(%ebp),%eax
  800f96:	8a 00                	mov    (%eax),%al
  800f98:	3c 30                	cmp    $0x30,%al
  800f9a:	75 0c                	jne    800fa8 <strtol+0x93>
		s++, base = 8;
  800f9c:	ff 45 08             	incl   0x8(%ebp)
  800f9f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fa6:	eb 0d                	jmp    800fb5 <strtol+0xa0>
	else if (base == 0)
  800fa8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fac:	75 07                	jne    800fb5 <strtol+0xa0>
		base = 10;
  800fae:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	3c 2f                	cmp    $0x2f,%al
  800fbc:	7e 19                	jle    800fd7 <strtol+0xc2>
  800fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc1:	8a 00                	mov    (%eax),%al
  800fc3:	3c 39                	cmp    $0x39,%al
  800fc5:	7f 10                	jg     800fd7 <strtol+0xc2>
			dig = *s - '0';
  800fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fca:	8a 00                	mov    (%eax),%al
  800fcc:	0f be c0             	movsbl %al,%eax
  800fcf:	83 e8 30             	sub    $0x30,%eax
  800fd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fd5:	eb 42                	jmp    801019 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	8a 00                	mov    (%eax),%al
  800fdc:	3c 60                	cmp    $0x60,%al
  800fde:	7e 19                	jle    800ff9 <strtol+0xe4>
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	8a 00                	mov    (%eax),%al
  800fe5:	3c 7a                	cmp    $0x7a,%al
  800fe7:	7f 10                	jg     800ff9 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	8a 00                	mov    (%eax),%al
  800fee:	0f be c0             	movsbl %al,%eax
  800ff1:	83 e8 57             	sub    $0x57,%eax
  800ff4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ff7:	eb 20                	jmp    801019 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffc:	8a 00                	mov    (%eax),%al
  800ffe:	3c 40                	cmp    $0x40,%al
  801000:	7e 39                	jle    80103b <strtol+0x126>
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	8a 00                	mov    (%eax),%al
  801007:	3c 5a                	cmp    $0x5a,%al
  801009:	7f 30                	jg     80103b <strtol+0x126>
			dig = *s - 'A' + 10;
  80100b:	8b 45 08             	mov    0x8(%ebp),%eax
  80100e:	8a 00                	mov    (%eax),%al
  801010:	0f be c0             	movsbl %al,%eax
  801013:	83 e8 37             	sub    $0x37,%eax
  801016:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801019:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80101c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80101f:	7d 19                	jge    80103a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801021:	ff 45 08             	incl   0x8(%ebp)
  801024:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801027:	0f af 45 10          	imul   0x10(%ebp),%eax
  80102b:	89 c2                	mov    %eax,%edx
  80102d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801030:	01 d0                	add    %edx,%eax
  801032:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801035:	e9 7b ff ff ff       	jmp    800fb5 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80103a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80103b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80103f:	74 08                	je     801049 <strtol+0x134>
		*endptr = (char *) s;
  801041:	8b 45 0c             	mov    0xc(%ebp),%eax
  801044:	8b 55 08             	mov    0x8(%ebp),%edx
  801047:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801049:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80104d:	74 07                	je     801056 <strtol+0x141>
  80104f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801052:	f7 d8                	neg    %eax
  801054:	eb 03                	jmp    801059 <strtol+0x144>
  801056:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801059:	c9                   	leave  
  80105a:	c3                   	ret    

0080105b <ltostr>:

void
ltostr(long value, char *str)
{
  80105b:	55                   	push   %ebp
  80105c:	89 e5                	mov    %esp,%ebp
  80105e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801061:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801068:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80106f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801073:	79 13                	jns    801088 <ltostr+0x2d>
	{
		neg = 1;
  801075:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80107c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801082:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801085:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
  80108b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801090:	99                   	cltd   
  801091:	f7 f9                	idiv   %ecx
  801093:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801096:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801099:	8d 50 01             	lea    0x1(%eax),%edx
  80109c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80109f:	89 c2                	mov    %eax,%edx
  8010a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a4:	01 d0                	add    %edx,%eax
  8010a6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010a9:	83 c2 30             	add    $0x30,%edx
  8010ac:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010b1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010b6:	f7 e9                	imul   %ecx
  8010b8:	c1 fa 02             	sar    $0x2,%edx
  8010bb:	89 c8                	mov    %ecx,%eax
  8010bd:	c1 f8 1f             	sar    $0x1f,%eax
  8010c0:	29 c2                	sub    %eax,%edx
  8010c2:	89 d0                	mov    %edx,%eax
  8010c4:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010ca:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010cf:	f7 e9                	imul   %ecx
  8010d1:	c1 fa 02             	sar    $0x2,%edx
  8010d4:	89 c8                	mov    %ecx,%eax
  8010d6:	c1 f8 1f             	sar    $0x1f,%eax
  8010d9:	29 c2                	sub    %eax,%edx
  8010db:	89 d0                	mov    %edx,%eax
  8010dd:	c1 e0 02             	shl    $0x2,%eax
  8010e0:	01 d0                	add    %edx,%eax
  8010e2:	01 c0                	add    %eax,%eax
  8010e4:	29 c1                	sub    %eax,%ecx
  8010e6:	89 ca                	mov    %ecx,%edx
  8010e8:	85 d2                	test   %edx,%edx
  8010ea:	75 9c                	jne    801088 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f6:	48                   	dec    %eax
  8010f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010fe:	74 3d                	je     80113d <ltostr+0xe2>
		start = 1 ;
  801100:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801107:	eb 34                	jmp    80113d <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801109:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80110c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110f:	01 d0                	add    %edx,%eax
  801111:	8a 00                	mov    (%eax),%al
  801113:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801116:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801119:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111c:	01 c2                	add    %eax,%edx
  80111e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801121:	8b 45 0c             	mov    0xc(%ebp),%eax
  801124:	01 c8                	add    %ecx,%eax
  801126:	8a 00                	mov    (%eax),%al
  801128:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80112a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80112d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801130:	01 c2                	add    %eax,%edx
  801132:	8a 45 eb             	mov    -0x15(%ebp),%al
  801135:	88 02                	mov    %al,(%edx)
		start++ ;
  801137:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80113a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80113d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801140:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801143:	7c c4                	jl     801109 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801145:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801148:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114b:	01 d0                	add    %edx,%eax
  80114d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801150:	90                   	nop
  801151:	c9                   	leave  
  801152:	c3                   	ret    

00801153 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801153:	55                   	push   %ebp
  801154:	89 e5                	mov    %esp,%ebp
  801156:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801159:	ff 75 08             	pushl  0x8(%ebp)
  80115c:	e8 54 fa ff ff       	call   800bb5 <strlen>
  801161:	83 c4 04             	add    $0x4,%esp
  801164:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801167:	ff 75 0c             	pushl  0xc(%ebp)
  80116a:	e8 46 fa ff ff       	call   800bb5 <strlen>
  80116f:	83 c4 04             	add    $0x4,%esp
  801172:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801175:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80117c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801183:	eb 17                	jmp    80119c <strcconcat+0x49>
		final[s] = str1[s] ;
  801185:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801188:	8b 45 10             	mov    0x10(%ebp),%eax
  80118b:	01 c2                	add    %eax,%edx
  80118d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801190:	8b 45 08             	mov    0x8(%ebp),%eax
  801193:	01 c8                	add    %ecx,%eax
  801195:	8a 00                	mov    (%eax),%al
  801197:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801199:	ff 45 fc             	incl   -0x4(%ebp)
  80119c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80119f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011a2:	7c e1                	jl     801185 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011a4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011ab:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011b2:	eb 1f                	jmp    8011d3 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011b7:	8d 50 01             	lea    0x1(%eax),%edx
  8011ba:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011bd:	89 c2                	mov    %eax,%edx
  8011bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c2:	01 c2                	add    %eax,%edx
  8011c4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ca:	01 c8                	add    %ecx,%eax
  8011cc:	8a 00                	mov    (%eax),%al
  8011ce:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011d0:	ff 45 f8             	incl   -0x8(%ebp)
  8011d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011d9:	7c d9                	jl     8011b4 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011db:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011de:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e1:	01 d0                	add    %edx,%eax
  8011e3:	c6 00 00             	movb   $0x0,(%eax)
}
  8011e6:	90                   	nop
  8011e7:	c9                   	leave  
  8011e8:	c3                   	ret    

008011e9 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011e9:	55                   	push   %ebp
  8011ea:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f8:	8b 00                	mov    (%eax),%eax
  8011fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801201:	8b 45 10             	mov    0x10(%ebp),%eax
  801204:	01 d0                	add    %edx,%eax
  801206:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80120c:	eb 0c                	jmp    80121a <strsplit+0x31>
			*string++ = 0;
  80120e:	8b 45 08             	mov    0x8(%ebp),%eax
  801211:	8d 50 01             	lea    0x1(%eax),%edx
  801214:	89 55 08             	mov    %edx,0x8(%ebp)
  801217:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80121a:	8b 45 08             	mov    0x8(%ebp),%eax
  80121d:	8a 00                	mov    (%eax),%al
  80121f:	84 c0                	test   %al,%al
  801221:	74 18                	je     80123b <strsplit+0x52>
  801223:	8b 45 08             	mov    0x8(%ebp),%eax
  801226:	8a 00                	mov    (%eax),%al
  801228:	0f be c0             	movsbl %al,%eax
  80122b:	50                   	push   %eax
  80122c:	ff 75 0c             	pushl  0xc(%ebp)
  80122f:	e8 13 fb ff ff       	call   800d47 <strchr>
  801234:	83 c4 08             	add    $0x8,%esp
  801237:	85 c0                	test   %eax,%eax
  801239:	75 d3                	jne    80120e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80123b:	8b 45 08             	mov    0x8(%ebp),%eax
  80123e:	8a 00                	mov    (%eax),%al
  801240:	84 c0                	test   %al,%al
  801242:	74 5a                	je     80129e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801244:	8b 45 14             	mov    0x14(%ebp),%eax
  801247:	8b 00                	mov    (%eax),%eax
  801249:	83 f8 0f             	cmp    $0xf,%eax
  80124c:	75 07                	jne    801255 <strsplit+0x6c>
		{
			return 0;
  80124e:	b8 00 00 00 00       	mov    $0x0,%eax
  801253:	eb 66                	jmp    8012bb <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801255:	8b 45 14             	mov    0x14(%ebp),%eax
  801258:	8b 00                	mov    (%eax),%eax
  80125a:	8d 48 01             	lea    0x1(%eax),%ecx
  80125d:	8b 55 14             	mov    0x14(%ebp),%edx
  801260:	89 0a                	mov    %ecx,(%edx)
  801262:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801269:	8b 45 10             	mov    0x10(%ebp),%eax
  80126c:	01 c2                	add    %eax,%edx
  80126e:	8b 45 08             	mov    0x8(%ebp),%eax
  801271:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801273:	eb 03                	jmp    801278 <strsplit+0x8f>
			string++;
  801275:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801278:	8b 45 08             	mov    0x8(%ebp),%eax
  80127b:	8a 00                	mov    (%eax),%al
  80127d:	84 c0                	test   %al,%al
  80127f:	74 8b                	je     80120c <strsplit+0x23>
  801281:	8b 45 08             	mov    0x8(%ebp),%eax
  801284:	8a 00                	mov    (%eax),%al
  801286:	0f be c0             	movsbl %al,%eax
  801289:	50                   	push   %eax
  80128a:	ff 75 0c             	pushl  0xc(%ebp)
  80128d:	e8 b5 fa ff ff       	call   800d47 <strchr>
  801292:	83 c4 08             	add    $0x8,%esp
  801295:	85 c0                	test   %eax,%eax
  801297:	74 dc                	je     801275 <strsplit+0x8c>
			string++;
	}
  801299:	e9 6e ff ff ff       	jmp    80120c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80129e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80129f:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a2:	8b 00                	mov    (%eax),%eax
  8012a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ae:	01 d0                	add    %edx,%eax
  8012b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012b6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012bb:	c9                   	leave  
  8012bc:	c3                   	ret    

008012bd <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012bd:	55                   	push   %ebp
  8012be:	89 e5                	mov    %esp,%ebp
  8012c0:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012c3:	a1 04 40 80 00       	mov    0x804004,%eax
  8012c8:	85 c0                	test   %eax,%eax
  8012ca:	74 1f                	je     8012eb <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012cc:	e8 1d 00 00 00       	call   8012ee <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8012d1:	83 ec 0c             	sub    $0xc,%esp
  8012d4:	68 70 39 80 00       	push   $0x803970
  8012d9:	e8 55 f2 ff ff       	call   800533 <cprintf>
  8012de:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012e1:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8012e8:	00 00 00 
	}
}
  8012eb:	90                   	nop
  8012ec:	c9                   	leave  
  8012ed:	c3                   	ret    

008012ee <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8012ee:	55                   	push   %ebp
  8012ef:	89 e5                	mov    %esp,%ebp
  8012f1:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  8012f4:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8012fb:	00 00 00 
  8012fe:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801305:	00 00 00 
  801308:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80130f:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  801312:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801319:	00 00 00 
  80131c:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801323:	00 00 00 
  801326:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80132d:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  801330:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801337:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80133a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80133f:	2d 00 10 00 00       	sub    $0x1000,%eax
  801344:	a3 50 40 80 00       	mov    %eax,0x804050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801349:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801350:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  801353:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80135a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80135d:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  801362:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801365:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801368:	ba 00 00 00 00       	mov    $0x0,%edx
  80136d:	f7 75 f0             	divl   -0x10(%ebp)
  801370:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801373:	29 d0                	sub    %edx,%eax
  801375:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  801378:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  80137f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801382:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801387:	2d 00 10 00 00       	sub    $0x1000,%eax
  80138c:	83 ec 04             	sub    $0x4,%esp
  80138f:	6a 06                	push   $0x6
  801391:	ff 75 e8             	pushl  -0x18(%ebp)
  801394:	50                   	push   %eax
  801395:	e8 d4 05 00 00       	call   80196e <sys_allocate_chunk>
  80139a:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80139d:	a1 20 41 80 00       	mov    0x804120,%eax
  8013a2:	83 ec 0c             	sub    $0xc,%esp
  8013a5:	50                   	push   %eax
  8013a6:	e8 49 0c 00 00       	call   801ff4 <initialize_MemBlocksList>
  8013ab:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  8013ae:	a1 48 41 80 00       	mov    0x804148,%eax
  8013b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  8013b6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013ba:	75 14                	jne    8013d0 <initialize_dyn_block_system+0xe2>
  8013bc:	83 ec 04             	sub    $0x4,%esp
  8013bf:	68 95 39 80 00       	push   $0x803995
  8013c4:	6a 39                	push   $0x39
  8013c6:	68 b3 39 80 00       	push   $0x8039b3
  8013cb:	e8 af ee ff ff       	call   80027f <_panic>
  8013d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013d3:	8b 00                	mov    (%eax),%eax
  8013d5:	85 c0                	test   %eax,%eax
  8013d7:	74 10                	je     8013e9 <initialize_dyn_block_system+0xfb>
  8013d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013dc:	8b 00                	mov    (%eax),%eax
  8013de:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8013e1:	8b 52 04             	mov    0x4(%edx),%edx
  8013e4:	89 50 04             	mov    %edx,0x4(%eax)
  8013e7:	eb 0b                	jmp    8013f4 <initialize_dyn_block_system+0x106>
  8013e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013ec:	8b 40 04             	mov    0x4(%eax),%eax
  8013ef:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8013f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013f7:	8b 40 04             	mov    0x4(%eax),%eax
  8013fa:	85 c0                	test   %eax,%eax
  8013fc:	74 0f                	je     80140d <initialize_dyn_block_system+0x11f>
  8013fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801401:	8b 40 04             	mov    0x4(%eax),%eax
  801404:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801407:	8b 12                	mov    (%edx),%edx
  801409:	89 10                	mov    %edx,(%eax)
  80140b:	eb 0a                	jmp    801417 <initialize_dyn_block_system+0x129>
  80140d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801410:	8b 00                	mov    (%eax),%eax
  801412:	a3 48 41 80 00       	mov    %eax,0x804148
  801417:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80141a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801420:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801423:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80142a:	a1 54 41 80 00       	mov    0x804154,%eax
  80142f:	48                   	dec    %eax
  801430:	a3 54 41 80 00       	mov    %eax,0x804154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  801435:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801438:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  80143f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801442:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  801449:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80144d:	75 14                	jne    801463 <initialize_dyn_block_system+0x175>
  80144f:	83 ec 04             	sub    $0x4,%esp
  801452:	68 c0 39 80 00       	push   $0x8039c0
  801457:	6a 3f                	push   $0x3f
  801459:	68 b3 39 80 00       	push   $0x8039b3
  80145e:	e8 1c ee ff ff       	call   80027f <_panic>
  801463:	8b 15 38 41 80 00    	mov    0x804138,%edx
  801469:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80146c:	89 10                	mov    %edx,(%eax)
  80146e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801471:	8b 00                	mov    (%eax),%eax
  801473:	85 c0                	test   %eax,%eax
  801475:	74 0d                	je     801484 <initialize_dyn_block_system+0x196>
  801477:	a1 38 41 80 00       	mov    0x804138,%eax
  80147c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80147f:	89 50 04             	mov    %edx,0x4(%eax)
  801482:	eb 08                	jmp    80148c <initialize_dyn_block_system+0x19e>
  801484:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801487:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80148c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80148f:	a3 38 41 80 00       	mov    %eax,0x804138
  801494:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801497:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80149e:	a1 44 41 80 00       	mov    0x804144,%eax
  8014a3:	40                   	inc    %eax
  8014a4:	a3 44 41 80 00       	mov    %eax,0x804144

}
  8014a9:	90                   	nop
  8014aa:	c9                   	leave  
  8014ab:	c3                   	ret    

008014ac <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8014ac:	55                   	push   %ebp
  8014ad:	89 e5                	mov    %esp,%ebp
  8014af:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014b2:	e8 06 fe ff ff       	call   8012bd <InitializeUHeap>
	if (size == 0) return NULL ;
  8014b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014bb:	75 07                	jne    8014c4 <malloc+0x18>
  8014bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c2:	eb 7d                	jmp    801541 <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  8014c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8014cb:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8014d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8014d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d8:	01 d0                	add    %edx,%eax
  8014da:	48                   	dec    %eax
  8014db:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8014de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8014e6:	f7 75 f0             	divl   -0x10(%ebp)
  8014e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014ec:	29 d0                	sub    %edx,%eax
  8014ee:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  8014f1:	e8 46 08 00 00       	call   801d3c <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014f6:	83 f8 01             	cmp    $0x1,%eax
  8014f9:	75 07                	jne    801502 <malloc+0x56>
  8014fb:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  801502:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  801506:	75 34                	jne    80153c <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  801508:	83 ec 0c             	sub    $0xc,%esp
  80150b:	ff 75 e8             	pushl  -0x18(%ebp)
  80150e:	e8 73 0e 00 00       	call   802386 <alloc_block_FF>
  801513:	83 c4 10             	add    $0x10,%esp
  801516:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  801519:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80151d:	74 16                	je     801535 <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  80151f:	83 ec 0c             	sub    $0xc,%esp
  801522:	ff 75 e4             	pushl  -0x1c(%ebp)
  801525:	e8 ff 0b 00 00       	call   802129 <insert_sorted_allocList>
  80152a:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  80152d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801530:	8b 40 08             	mov    0x8(%eax),%eax
  801533:	eb 0c                	jmp    801541 <malloc+0x95>
	             }
	             else
	             	return NULL;
  801535:	b8 00 00 00 00       	mov    $0x0,%eax
  80153a:	eb 05                	jmp    801541 <malloc+0x95>
	      	  }
	          else
	               return NULL;
  80153c:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  801541:	c9                   	leave  
  801542:	c3                   	ret    

00801543 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801543:	55                   	push   %ebp
  801544:	89 e5                	mov    %esp,%ebp
  801546:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  801549:	8b 45 08             	mov    0x8(%ebp),%eax
  80154c:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  80154f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801552:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801555:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801558:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80155d:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  801560:	83 ec 08             	sub    $0x8,%esp
  801563:	ff 75 f4             	pushl  -0xc(%ebp)
  801566:	68 40 40 80 00       	push   $0x804040
  80156b:	e8 61 0b 00 00       	call   8020d1 <find_block>
  801570:	83 c4 10             	add    $0x10,%esp
  801573:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  801576:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80157a:	0f 84 a5 00 00 00    	je     801625 <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  801580:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801583:	8b 40 0c             	mov    0xc(%eax),%eax
  801586:	83 ec 08             	sub    $0x8,%esp
  801589:	50                   	push   %eax
  80158a:	ff 75 f4             	pushl  -0xc(%ebp)
  80158d:	e8 a4 03 00 00       	call   801936 <sys_free_user_mem>
  801592:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  801595:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801599:	75 17                	jne    8015b2 <free+0x6f>
  80159b:	83 ec 04             	sub    $0x4,%esp
  80159e:	68 95 39 80 00       	push   $0x803995
  8015a3:	68 87 00 00 00       	push   $0x87
  8015a8:	68 b3 39 80 00       	push   $0x8039b3
  8015ad:	e8 cd ec ff ff       	call   80027f <_panic>
  8015b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015b5:	8b 00                	mov    (%eax),%eax
  8015b7:	85 c0                	test   %eax,%eax
  8015b9:	74 10                	je     8015cb <free+0x88>
  8015bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015be:	8b 00                	mov    (%eax),%eax
  8015c0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015c3:	8b 52 04             	mov    0x4(%edx),%edx
  8015c6:	89 50 04             	mov    %edx,0x4(%eax)
  8015c9:	eb 0b                	jmp    8015d6 <free+0x93>
  8015cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ce:	8b 40 04             	mov    0x4(%eax),%eax
  8015d1:	a3 44 40 80 00       	mov    %eax,0x804044
  8015d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015d9:	8b 40 04             	mov    0x4(%eax),%eax
  8015dc:	85 c0                	test   %eax,%eax
  8015de:	74 0f                	je     8015ef <free+0xac>
  8015e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015e3:	8b 40 04             	mov    0x4(%eax),%eax
  8015e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015e9:	8b 12                	mov    (%edx),%edx
  8015eb:	89 10                	mov    %edx,(%eax)
  8015ed:	eb 0a                	jmp    8015f9 <free+0xb6>
  8015ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015f2:	8b 00                	mov    (%eax),%eax
  8015f4:	a3 40 40 80 00       	mov    %eax,0x804040
  8015f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801602:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801605:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80160c:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801611:	48                   	dec    %eax
  801612:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(theBlock);
  801617:	83 ec 0c             	sub    $0xc,%esp
  80161a:	ff 75 ec             	pushl  -0x14(%ebp)
  80161d:	e8 37 12 00 00       	call   802859 <insert_sorted_with_merge_freeList>
  801622:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  801625:	90                   	nop
  801626:	c9                   	leave  
  801627:	c3                   	ret    

00801628 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801628:	55                   	push   %ebp
  801629:	89 e5                	mov    %esp,%ebp
  80162b:	83 ec 38             	sub    $0x38,%esp
  80162e:	8b 45 10             	mov    0x10(%ebp),%eax
  801631:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801634:	e8 84 fc ff ff       	call   8012bd <InitializeUHeap>
	if (size == 0) return NULL ;
  801639:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80163d:	75 07                	jne    801646 <smalloc+0x1e>
  80163f:	b8 00 00 00 00       	mov    $0x0,%eax
  801644:	eb 7e                	jmp    8016c4 <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  801646:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  80164d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801654:	8b 55 0c             	mov    0xc(%ebp),%edx
  801657:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80165a:	01 d0                	add    %edx,%eax
  80165c:	48                   	dec    %eax
  80165d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801660:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801663:	ba 00 00 00 00       	mov    $0x0,%edx
  801668:	f7 75 f0             	divl   -0x10(%ebp)
  80166b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80166e:	29 d0                	sub    %edx,%eax
  801670:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801673:	e8 c4 06 00 00       	call   801d3c <sys_isUHeapPlacementStrategyFIRSTFIT>
  801678:	83 f8 01             	cmp    $0x1,%eax
  80167b:	75 42                	jne    8016bf <smalloc+0x97>

		  va = malloc(newsize) ;
  80167d:	83 ec 0c             	sub    $0xc,%esp
  801680:	ff 75 e8             	pushl  -0x18(%ebp)
  801683:	e8 24 fe ff ff       	call   8014ac <malloc>
  801688:	83 c4 10             	add    $0x10,%esp
  80168b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  80168e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801692:	74 24                	je     8016b8 <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  801694:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801698:	ff 75 e4             	pushl  -0x1c(%ebp)
  80169b:	50                   	push   %eax
  80169c:	ff 75 e8             	pushl  -0x18(%ebp)
  80169f:	ff 75 08             	pushl  0x8(%ebp)
  8016a2:	e8 1a 04 00 00       	call   801ac1 <sys_createSharedObject>
  8016a7:	83 c4 10             	add    $0x10,%esp
  8016aa:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  8016ad:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8016b1:	78 0c                	js     8016bf <smalloc+0x97>
					  return va ;
  8016b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016b6:	eb 0c                	jmp    8016c4 <smalloc+0x9c>
				 }
				 else
					return NULL;
  8016b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8016bd:	eb 05                	jmp    8016c4 <smalloc+0x9c>
	  }
		  return NULL ;
  8016bf:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016c4:	c9                   	leave  
  8016c5:	c3                   	ret    

008016c6 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016c6:	55                   	push   %ebp
  8016c7:	89 e5                	mov    %esp,%ebp
  8016c9:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016cc:	e8 ec fb ff ff       	call   8012bd <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  8016d1:	83 ec 08             	sub    $0x8,%esp
  8016d4:	ff 75 0c             	pushl  0xc(%ebp)
  8016d7:	ff 75 08             	pushl  0x8(%ebp)
  8016da:	e8 0c 04 00 00       	call   801aeb <sys_getSizeOfSharedObject>
  8016df:	83 c4 10             	add    $0x10,%esp
  8016e2:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  8016e5:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8016e9:	75 07                	jne    8016f2 <sget+0x2c>
  8016eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f0:	eb 75                	jmp    801767 <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8016f2:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8016f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ff:	01 d0                	add    %edx,%eax
  801701:	48                   	dec    %eax
  801702:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801705:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801708:	ba 00 00 00 00       	mov    $0x0,%edx
  80170d:	f7 75 f0             	divl   -0x10(%ebp)
  801710:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801713:	29 d0                	sub    %edx,%eax
  801715:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  801718:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  80171f:	e8 18 06 00 00       	call   801d3c <sys_isUHeapPlacementStrategyFIRSTFIT>
  801724:	83 f8 01             	cmp    $0x1,%eax
  801727:	75 39                	jne    801762 <sget+0x9c>

		  va = malloc(newsize) ;
  801729:	83 ec 0c             	sub    $0xc,%esp
  80172c:	ff 75 e8             	pushl  -0x18(%ebp)
  80172f:	e8 78 fd ff ff       	call   8014ac <malloc>
  801734:	83 c4 10             	add    $0x10,%esp
  801737:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  80173a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80173e:	74 22                	je     801762 <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  801740:	83 ec 04             	sub    $0x4,%esp
  801743:	ff 75 e0             	pushl  -0x20(%ebp)
  801746:	ff 75 0c             	pushl  0xc(%ebp)
  801749:	ff 75 08             	pushl  0x8(%ebp)
  80174c:	e8 b7 03 00 00       	call   801b08 <sys_getSharedObject>
  801751:	83 c4 10             	add    $0x10,%esp
  801754:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  801757:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80175b:	78 05                	js     801762 <sget+0x9c>
					  return va;
  80175d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801760:	eb 05                	jmp    801767 <sget+0xa1>
				  }
			  }
     }
         return NULL;
  801762:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  801767:	c9                   	leave  
  801768:	c3                   	ret    

00801769 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801769:	55                   	push   %ebp
  80176a:	89 e5                	mov    %esp,%ebp
  80176c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80176f:	e8 49 fb ff ff       	call   8012bd <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801774:	83 ec 04             	sub    $0x4,%esp
  801777:	68 e4 39 80 00       	push   $0x8039e4
  80177c:	68 1e 01 00 00       	push   $0x11e
  801781:	68 b3 39 80 00       	push   $0x8039b3
  801786:	e8 f4 ea ff ff       	call   80027f <_panic>

0080178b <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80178b:	55                   	push   %ebp
  80178c:	89 e5                	mov    %esp,%ebp
  80178e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801791:	83 ec 04             	sub    $0x4,%esp
  801794:	68 0c 3a 80 00       	push   $0x803a0c
  801799:	68 32 01 00 00       	push   $0x132
  80179e:	68 b3 39 80 00       	push   $0x8039b3
  8017a3:	e8 d7 ea ff ff       	call   80027f <_panic>

008017a8 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017a8:	55                   	push   %ebp
  8017a9:	89 e5                	mov    %esp,%ebp
  8017ab:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017ae:	83 ec 04             	sub    $0x4,%esp
  8017b1:	68 30 3a 80 00       	push   $0x803a30
  8017b6:	68 3d 01 00 00       	push   $0x13d
  8017bb:	68 b3 39 80 00       	push   $0x8039b3
  8017c0:	e8 ba ea ff ff       	call   80027f <_panic>

008017c5 <shrink>:

}
void shrink(uint32 newSize)
{
  8017c5:	55                   	push   %ebp
  8017c6:	89 e5                	mov    %esp,%ebp
  8017c8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017cb:	83 ec 04             	sub    $0x4,%esp
  8017ce:	68 30 3a 80 00       	push   $0x803a30
  8017d3:	68 42 01 00 00       	push   $0x142
  8017d8:	68 b3 39 80 00       	push   $0x8039b3
  8017dd:	e8 9d ea ff ff       	call   80027f <_panic>

008017e2 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017e2:	55                   	push   %ebp
  8017e3:	89 e5                	mov    %esp,%ebp
  8017e5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017e8:	83 ec 04             	sub    $0x4,%esp
  8017eb:	68 30 3a 80 00       	push   $0x803a30
  8017f0:	68 47 01 00 00       	push   $0x147
  8017f5:	68 b3 39 80 00       	push   $0x8039b3
  8017fa:	e8 80 ea ff ff       	call   80027f <_panic>

008017ff <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
  801802:	57                   	push   %edi
  801803:	56                   	push   %esi
  801804:	53                   	push   %ebx
  801805:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801808:	8b 45 08             	mov    0x8(%ebp),%eax
  80180b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80180e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801811:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801814:	8b 7d 18             	mov    0x18(%ebp),%edi
  801817:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80181a:	cd 30                	int    $0x30
  80181c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80181f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801822:	83 c4 10             	add    $0x10,%esp
  801825:	5b                   	pop    %ebx
  801826:	5e                   	pop    %esi
  801827:	5f                   	pop    %edi
  801828:	5d                   	pop    %ebp
  801829:	c3                   	ret    

0080182a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
  80182d:	83 ec 04             	sub    $0x4,%esp
  801830:	8b 45 10             	mov    0x10(%ebp),%eax
  801833:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801836:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80183a:	8b 45 08             	mov    0x8(%ebp),%eax
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	52                   	push   %edx
  801842:	ff 75 0c             	pushl  0xc(%ebp)
  801845:	50                   	push   %eax
  801846:	6a 00                	push   $0x0
  801848:	e8 b2 ff ff ff       	call   8017ff <syscall>
  80184d:	83 c4 18             	add    $0x18,%esp
}
  801850:	90                   	nop
  801851:	c9                   	leave  
  801852:	c3                   	ret    

00801853 <sys_cgetc>:

int
sys_cgetc(void)
{
  801853:	55                   	push   %ebp
  801854:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 01                	push   $0x1
  801862:	e8 98 ff ff ff       	call   8017ff <syscall>
  801867:	83 c4 18             	add    $0x18,%esp
}
  80186a:	c9                   	leave  
  80186b:	c3                   	ret    

0080186c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80186c:	55                   	push   %ebp
  80186d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80186f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801872:	8b 45 08             	mov    0x8(%ebp),%eax
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	52                   	push   %edx
  80187c:	50                   	push   %eax
  80187d:	6a 05                	push   $0x5
  80187f:	e8 7b ff ff ff       	call   8017ff <syscall>
  801884:	83 c4 18             	add    $0x18,%esp
}
  801887:	c9                   	leave  
  801888:	c3                   	ret    

00801889 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
  80188c:	56                   	push   %esi
  80188d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80188e:	8b 75 18             	mov    0x18(%ebp),%esi
  801891:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801894:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801897:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189a:	8b 45 08             	mov    0x8(%ebp),%eax
  80189d:	56                   	push   %esi
  80189e:	53                   	push   %ebx
  80189f:	51                   	push   %ecx
  8018a0:	52                   	push   %edx
  8018a1:	50                   	push   %eax
  8018a2:	6a 06                	push   $0x6
  8018a4:	e8 56 ff ff ff       	call   8017ff <syscall>
  8018a9:	83 c4 18             	add    $0x18,%esp
}
  8018ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018af:	5b                   	pop    %ebx
  8018b0:	5e                   	pop    %esi
  8018b1:	5d                   	pop    %ebp
  8018b2:	c3                   	ret    

008018b3 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018b3:	55                   	push   %ebp
  8018b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	52                   	push   %edx
  8018c3:	50                   	push   %eax
  8018c4:	6a 07                	push   $0x7
  8018c6:	e8 34 ff ff ff       	call   8017ff <syscall>
  8018cb:	83 c4 18             	add    $0x18,%esp
}
  8018ce:	c9                   	leave  
  8018cf:	c3                   	ret    

008018d0 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018d0:	55                   	push   %ebp
  8018d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	ff 75 0c             	pushl  0xc(%ebp)
  8018dc:	ff 75 08             	pushl  0x8(%ebp)
  8018df:	6a 08                	push   $0x8
  8018e1:	e8 19 ff ff ff       	call   8017ff <syscall>
  8018e6:	83 c4 18             	add    $0x18,%esp
}
  8018e9:	c9                   	leave  
  8018ea:	c3                   	ret    

008018eb <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 09                	push   $0x9
  8018fa:	e8 00 ff ff ff       	call   8017ff <syscall>
  8018ff:	83 c4 18             	add    $0x18,%esp
}
  801902:	c9                   	leave  
  801903:	c3                   	ret    

00801904 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801904:	55                   	push   %ebp
  801905:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 0a                	push   $0xa
  801913:	e8 e7 fe ff ff       	call   8017ff <syscall>
  801918:	83 c4 18             	add    $0x18,%esp
}
  80191b:	c9                   	leave  
  80191c:	c3                   	ret    

0080191d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80191d:	55                   	push   %ebp
  80191e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 0b                	push   $0xb
  80192c:	e8 ce fe ff ff       	call   8017ff <syscall>
  801931:	83 c4 18             	add    $0x18,%esp
}
  801934:	c9                   	leave  
  801935:	c3                   	ret    

00801936 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	ff 75 0c             	pushl  0xc(%ebp)
  801942:	ff 75 08             	pushl  0x8(%ebp)
  801945:	6a 0f                	push   $0xf
  801947:	e8 b3 fe ff ff       	call   8017ff <syscall>
  80194c:	83 c4 18             	add    $0x18,%esp
	return;
  80194f:	90                   	nop
}
  801950:	c9                   	leave  
  801951:	c3                   	ret    

00801952 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	ff 75 0c             	pushl  0xc(%ebp)
  80195e:	ff 75 08             	pushl  0x8(%ebp)
  801961:	6a 10                	push   $0x10
  801963:	e8 97 fe ff ff       	call   8017ff <syscall>
  801968:	83 c4 18             	add    $0x18,%esp
	return ;
  80196b:	90                   	nop
}
  80196c:	c9                   	leave  
  80196d:	c3                   	ret    

0080196e <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	ff 75 10             	pushl  0x10(%ebp)
  801978:	ff 75 0c             	pushl  0xc(%ebp)
  80197b:	ff 75 08             	pushl  0x8(%ebp)
  80197e:	6a 11                	push   $0x11
  801980:	e8 7a fe ff ff       	call   8017ff <syscall>
  801985:	83 c4 18             	add    $0x18,%esp
	return ;
  801988:	90                   	nop
}
  801989:	c9                   	leave  
  80198a:	c3                   	ret    

0080198b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 0c                	push   $0xc
  80199a:	e8 60 fe ff ff       	call   8017ff <syscall>
  80199f:	83 c4 18             	add    $0x18,%esp
}
  8019a2:	c9                   	leave  
  8019a3:	c3                   	ret    

008019a4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019a4:	55                   	push   %ebp
  8019a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	ff 75 08             	pushl  0x8(%ebp)
  8019b2:	6a 0d                	push   $0xd
  8019b4:	e8 46 fe ff ff       	call   8017ff <syscall>
  8019b9:	83 c4 18             	add    $0x18,%esp
}
  8019bc:	c9                   	leave  
  8019bd:	c3                   	ret    

008019be <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 0e                	push   $0xe
  8019cd:	e8 2d fe ff ff       	call   8017ff <syscall>
  8019d2:	83 c4 18             	add    $0x18,%esp
}
  8019d5:	90                   	nop
  8019d6:	c9                   	leave  
  8019d7:	c3                   	ret    

008019d8 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019d8:	55                   	push   %ebp
  8019d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 13                	push   $0x13
  8019e7:	e8 13 fe ff ff       	call   8017ff <syscall>
  8019ec:	83 c4 18             	add    $0x18,%esp
}
  8019ef:	90                   	nop
  8019f0:	c9                   	leave  
  8019f1:	c3                   	ret    

008019f2 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 14                	push   $0x14
  801a01:	e8 f9 fd ff ff       	call   8017ff <syscall>
  801a06:	83 c4 18             	add    $0x18,%esp
}
  801a09:	90                   	nop
  801a0a:	c9                   	leave  
  801a0b:	c3                   	ret    

00801a0c <sys_cputc>:


void
sys_cputc(const char c)
{
  801a0c:	55                   	push   %ebp
  801a0d:	89 e5                	mov    %esp,%ebp
  801a0f:	83 ec 04             	sub    $0x4,%esp
  801a12:	8b 45 08             	mov    0x8(%ebp),%eax
  801a15:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a18:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	50                   	push   %eax
  801a25:	6a 15                	push   $0x15
  801a27:	e8 d3 fd ff ff       	call   8017ff <syscall>
  801a2c:	83 c4 18             	add    $0x18,%esp
}
  801a2f:	90                   	nop
  801a30:	c9                   	leave  
  801a31:	c3                   	ret    

00801a32 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a32:	55                   	push   %ebp
  801a33:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 16                	push   $0x16
  801a41:	e8 b9 fd ff ff       	call   8017ff <syscall>
  801a46:	83 c4 18             	add    $0x18,%esp
}
  801a49:	90                   	nop
  801a4a:	c9                   	leave  
  801a4b:	c3                   	ret    

00801a4c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a4c:	55                   	push   %ebp
  801a4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	ff 75 0c             	pushl  0xc(%ebp)
  801a5b:	50                   	push   %eax
  801a5c:	6a 17                	push   $0x17
  801a5e:	e8 9c fd ff ff       	call   8017ff <syscall>
  801a63:	83 c4 18             	add    $0x18,%esp
}
  801a66:	c9                   	leave  
  801a67:	c3                   	ret    

00801a68 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a68:	55                   	push   %ebp
  801a69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	52                   	push   %edx
  801a78:	50                   	push   %eax
  801a79:	6a 1a                	push   $0x1a
  801a7b:	e8 7f fd ff ff       	call   8017ff <syscall>
  801a80:	83 c4 18             	add    $0x18,%esp
}
  801a83:	c9                   	leave  
  801a84:	c3                   	ret    

00801a85 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a85:	55                   	push   %ebp
  801a86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a88:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	52                   	push   %edx
  801a95:	50                   	push   %eax
  801a96:	6a 18                	push   $0x18
  801a98:	e8 62 fd ff ff       	call   8017ff <syscall>
  801a9d:	83 c4 18             	add    $0x18,%esp
}
  801aa0:	90                   	nop
  801aa1:	c9                   	leave  
  801aa2:	c3                   	ret    

00801aa3 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801aa6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	52                   	push   %edx
  801ab3:	50                   	push   %eax
  801ab4:	6a 19                	push   $0x19
  801ab6:	e8 44 fd ff ff       	call   8017ff <syscall>
  801abb:	83 c4 18             	add    $0x18,%esp
}
  801abe:	90                   	nop
  801abf:	c9                   	leave  
  801ac0:	c3                   	ret    

00801ac1 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ac1:	55                   	push   %ebp
  801ac2:	89 e5                	mov    %esp,%ebp
  801ac4:	83 ec 04             	sub    $0x4,%esp
  801ac7:	8b 45 10             	mov    0x10(%ebp),%eax
  801aca:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801acd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ad0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad7:	6a 00                	push   $0x0
  801ad9:	51                   	push   %ecx
  801ada:	52                   	push   %edx
  801adb:	ff 75 0c             	pushl  0xc(%ebp)
  801ade:	50                   	push   %eax
  801adf:	6a 1b                	push   $0x1b
  801ae1:	e8 19 fd ff ff       	call   8017ff <syscall>
  801ae6:	83 c4 18             	add    $0x18,%esp
}
  801ae9:	c9                   	leave  
  801aea:	c3                   	ret    

00801aeb <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801aee:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af1:	8b 45 08             	mov    0x8(%ebp),%eax
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	52                   	push   %edx
  801afb:	50                   	push   %eax
  801afc:	6a 1c                	push   $0x1c
  801afe:	e8 fc fc ff ff       	call   8017ff <syscall>
  801b03:	83 c4 18             	add    $0x18,%esp
}
  801b06:	c9                   	leave  
  801b07:	c3                   	ret    

00801b08 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b08:	55                   	push   %ebp
  801b09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b0b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b11:	8b 45 08             	mov    0x8(%ebp),%eax
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	51                   	push   %ecx
  801b19:	52                   	push   %edx
  801b1a:	50                   	push   %eax
  801b1b:	6a 1d                	push   $0x1d
  801b1d:	e8 dd fc ff ff       	call   8017ff <syscall>
  801b22:	83 c4 18             	add    $0x18,%esp
}
  801b25:	c9                   	leave  
  801b26:	c3                   	ret    

00801b27 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b27:	55                   	push   %ebp
  801b28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	52                   	push   %edx
  801b37:	50                   	push   %eax
  801b38:	6a 1e                	push   $0x1e
  801b3a:	e8 c0 fc ff ff       	call   8017ff <syscall>
  801b3f:	83 c4 18             	add    $0x18,%esp
}
  801b42:	c9                   	leave  
  801b43:	c3                   	ret    

00801b44 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 1f                	push   $0x1f
  801b53:	e8 a7 fc ff ff       	call   8017ff <syscall>
  801b58:	83 c4 18             	add    $0x18,%esp
}
  801b5b:	c9                   	leave  
  801b5c:	c3                   	ret    

00801b5d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b60:	8b 45 08             	mov    0x8(%ebp),%eax
  801b63:	6a 00                	push   $0x0
  801b65:	ff 75 14             	pushl  0x14(%ebp)
  801b68:	ff 75 10             	pushl  0x10(%ebp)
  801b6b:	ff 75 0c             	pushl  0xc(%ebp)
  801b6e:	50                   	push   %eax
  801b6f:	6a 20                	push   $0x20
  801b71:	e8 89 fc ff ff       	call   8017ff <syscall>
  801b76:	83 c4 18             	add    $0x18,%esp
}
  801b79:	c9                   	leave  
  801b7a:	c3                   	ret    

00801b7b <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b7b:	55                   	push   %ebp
  801b7c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	50                   	push   %eax
  801b8a:	6a 21                	push   $0x21
  801b8c:	e8 6e fc ff ff       	call   8017ff <syscall>
  801b91:	83 c4 18             	add    $0x18,%esp
}
  801b94:	90                   	nop
  801b95:	c9                   	leave  
  801b96:	c3                   	ret    

00801b97 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b97:	55                   	push   %ebp
  801b98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	50                   	push   %eax
  801ba6:	6a 22                	push   $0x22
  801ba8:	e8 52 fc ff ff       	call   8017ff <syscall>
  801bad:	83 c4 18             	add    $0x18,%esp
}
  801bb0:	c9                   	leave  
  801bb1:	c3                   	ret    

00801bb2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bb2:	55                   	push   %ebp
  801bb3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 02                	push   $0x2
  801bc1:	e8 39 fc ff ff       	call   8017ff <syscall>
  801bc6:	83 c4 18             	add    $0x18,%esp
}
  801bc9:	c9                   	leave  
  801bca:	c3                   	ret    

00801bcb <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bcb:	55                   	push   %ebp
  801bcc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 03                	push   $0x3
  801bda:	e8 20 fc ff ff       	call   8017ff <syscall>
  801bdf:	83 c4 18             	add    $0x18,%esp
}
  801be2:	c9                   	leave  
  801be3:	c3                   	ret    

00801be4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 04                	push   $0x4
  801bf3:	e8 07 fc ff ff       	call   8017ff <syscall>
  801bf8:	83 c4 18             	add    $0x18,%esp
}
  801bfb:	c9                   	leave  
  801bfc:	c3                   	ret    

00801bfd <sys_exit_env>:


void sys_exit_env(void)
{
  801bfd:	55                   	push   %ebp
  801bfe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 23                	push   $0x23
  801c0c:	e8 ee fb ff ff       	call   8017ff <syscall>
  801c11:	83 c4 18             	add    $0x18,%esp
}
  801c14:	90                   	nop
  801c15:	c9                   	leave  
  801c16:	c3                   	ret    

00801c17 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
  801c1a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c1d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c20:	8d 50 04             	lea    0x4(%eax),%edx
  801c23:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	52                   	push   %edx
  801c2d:	50                   	push   %eax
  801c2e:	6a 24                	push   $0x24
  801c30:	e8 ca fb ff ff       	call   8017ff <syscall>
  801c35:	83 c4 18             	add    $0x18,%esp
	return result;
  801c38:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c3e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c41:	89 01                	mov    %eax,(%ecx)
  801c43:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c46:	8b 45 08             	mov    0x8(%ebp),%eax
  801c49:	c9                   	leave  
  801c4a:	c2 04 00             	ret    $0x4

00801c4d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c4d:	55                   	push   %ebp
  801c4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	ff 75 10             	pushl  0x10(%ebp)
  801c57:	ff 75 0c             	pushl  0xc(%ebp)
  801c5a:	ff 75 08             	pushl  0x8(%ebp)
  801c5d:	6a 12                	push   $0x12
  801c5f:	e8 9b fb ff ff       	call   8017ff <syscall>
  801c64:	83 c4 18             	add    $0x18,%esp
	return ;
  801c67:	90                   	nop
}
  801c68:	c9                   	leave  
  801c69:	c3                   	ret    

00801c6a <sys_rcr2>:
uint32 sys_rcr2()
{
  801c6a:	55                   	push   %ebp
  801c6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 25                	push   $0x25
  801c79:	e8 81 fb ff ff       	call   8017ff <syscall>
  801c7e:	83 c4 18             	add    $0x18,%esp
}
  801c81:	c9                   	leave  
  801c82:	c3                   	ret    

00801c83 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
  801c86:	83 ec 04             	sub    $0x4,%esp
  801c89:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c8f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	50                   	push   %eax
  801c9c:	6a 26                	push   $0x26
  801c9e:	e8 5c fb ff ff       	call   8017ff <syscall>
  801ca3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca6:	90                   	nop
}
  801ca7:	c9                   	leave  
  801ca8:	c3                   	ret    

00801ca9 <rsttst>:
void rsttst()
{
  801ca9:	55                   	push   %ebp
  801caa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 28                	push   $0x28
  801cb8:	e8 42 fb ff ff       	call   8017ff <syscall>
  801cbd:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc0:	90                   	nop
}
  801cc1:	c9                   	leave  
  801cc2:	c3                   	ret    

00801cc3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cc3:	55                   	push   %ebp
  801cc4:	89 e5                	mov    %esp,%ebp
  801cc6:	83 ec 04             	sub    $0x4,%esp
  801cc9:	8b 45 14             	mov    0x14(%ebp),%eax
  801ccc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ccf:	8b 55 18             	mov    0x18(%ebp),%edx
  801cd2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cd6:	52                   	push   %edx
  801cd7:	50                   	push   %eax
  801cd8:	ff 75 10             	pushl  0x10(%ebp)
  801cdb:	ff 75 0c             	pushl  0xc(%ebp)
  801cde:	ff 75 08             	pushl  0x8(%ebp)
  801ce1:	6a 27                	push   $0x27
  801ce3:	e8 17 fb ff ff       	call   8017ff <syscall>
  801ce8:	83 c4 18             	add    $0x18,%esp
	return ;
  801ceb:	90                   	nop
}
  801cec:	c9                   	leave  
  801ced:	c3                   	ret    

00801cee <chktst>:
void chktst(uint32 n)
{
  801cee:	55                   	push   %ebp
  801cef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	ff 75 08             	pushl  0x8(%ebp)
  801cfc:	6a 29                	push   $0x29
  801cfe:	e8 fc fa ff ff       	call   8017ff <syscall>
  801d03:	83 c4 18             	add    $0x18,%esp
	return ;
  801d06:	90                   	nop
}
  801d07:	c9                   	leave  
  801d08:	c3                   	ret    

00801d09 <inctst>:

void inctst()
{
  801d09:	55                   	push   %ebp
  801d0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 2a                	push   $0x2a
  801d18:	e8 e2 fa ff ff       	call   8017ff <syscall>
  801d1d:	83 c4 18             	add    $0x18,%esp
	return ;
  801d20:	90                   	nop
}
  801d21:	c9                   	leave  
  801d22:	c3                   	ret    

00801d23 <gettst>:
uint32 gettst()
{
  801d23:	55                   	push   %ebp
  801d24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 2b                	push   $0x2b
  801d32:	e8 c8 fa ff ff       	call   8017ff <syscall>
  801d37:	83 c4 18             	add    $0x18,%esp
}
  801d3a:	c9                   	leave  
  801d3b:	c3                   	ret    

00801d3c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d3c:	55                   	push   %ebp
  801d3d:	89 e5                	mov    %esp,%ebp
  801d3f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 2c                	push   $0x2c
  801d4e:	e8 ac fa ff ff       	call   8017ff <syscall>
  801d53:	83 c4 18             	add    $0x18,%esp
  801d56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d59:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d5d:	75 07                	jne    801d66 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d5f:	b8 01 00 00 00       	mov    $0x1,%eax
  801d64:	eb 05                	jmp    801d6b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d66:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d6b:	c9                   	leave  
  801d6c:	c3                   	ret    

00801d6d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d6d:	55                   	push   %ebp
  801d6e:	89 e5                	mov    %esp,%ebp
  801d70:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 2c                	push   $0x2c
  801d7f:	e8 7b fa ff ff       	call   8017ff <syscall>
  801d84:	83 c4 18             	add    $0x18,%esp
  801d87:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d8a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d8e:	75 07                	jne    801d97 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d90:	b8 01 00 00 00       	mov    $0x1,%eax
  801d95:	eb 05                	jmp    801d9c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d9c:	c9                   	leave  
  801d9d:	c3                   	ret    

00801d9e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d9e:	55                   	push   %ebp
  801d9f:	89 e5                	mov    %esp,%ebp
  801da1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 2c                	push   $0x2c
  801db0:	e8 4a fa ff ff       	call   8017ff <syscall>
  801db5:	83 c4 18             	add    $0x18,%esp
  801db8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801dbb:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801dbf:	75 07                	jne    801dc8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801dc1:	b8 01 00 00 00       	mov    $0x1,%eax
  801dc6:	eb 05                	jmp    801dcd <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801dc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dcd:	c9                   	leave  
  801dce:	c3                   	ret    

00801dcf <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801dcf:	55                   	push   %ebp
  801dd0:	89 e5                	mov    %esp,%ebp
  801dd2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 2c                	push   $0x2c
  801de1:	e8 19 fa ff ff       	call   8017ff <syscall>
  801de6:	83 c4 18             	add    $0x18,%esp
  801de9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801dec:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801df0:	75 07                	jne    801df9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801df2:	b8 01 00 00 00       	mov    $0x1,%eax
  801df7:	eb 05                	jmp    801dfe <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801df9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dfe:	c9                   	leave  
  801dff:	c3                   	ret    

00801e00 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e00:	55                   	push   %ebp
  801e01:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e03:	6a 00                	push   $0x0
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	ff 75 08             	pushl  0x8(%ebp)
  801e0e:	6a 2d                	push   $0x2d
  801e10:	e8 ea f9 ff ff       	call   8017ff <syscall>
  801e15:	83 c4 18             	add    $0x18,%esp
	return ;
  801e18:	90                   	nop
}
  801e19:	c9                   	leave  
  801e1a:	c3                   	ret    

00801e1b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e1b:	55                   	push   %ebp
  801e1c:	89 e5                	mov    %esp,%ebp
  801e1e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e1f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e22:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e25:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e28:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2b:	6a 00                	push   $0x0
  801e2d:	53                   	push   %ebx
  801e2e:	51                   	push   %ecx
  801e2f:	52                   	push   %edx
  801e30:	50                   	push   %eax
  801e31:	6a 2e                	push   $0x2e
  801e33:	e8 c7 f9 ff ff       	call   8017ff <syscall>
  801e38:	83 c4 18             	add    $0x18,%esp
}
  801e3b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e3e:	c9                   	leave  
  801e3f:	c3                   	ret    

00801e40 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e40:	55                   	push   %ebp
  801e41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e43:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e46:	8b 45 08             	mov    0x8(%ebp),%eax
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 00                	push   $0x0
  801e4f:	52                   	push   %edx
  801e50:	50                   	push   %eax
  801e51:	6a 2f                	push   $0x2f
  801e53:	e8 a7 f9 ff ff       	call   8017ff <syscall>
  801e58:	83 c4 18             	add    $0x18,%esp
}
  801e5b:	c9                   	leave  
  801e5c:	c3                   	ret    

00801e5d <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e5d:	55                   	push   %ebp
  801e5e:	89 e5                	mov    %esp,%ebp
  801e60:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e63:	83 ec 0c             	sub    $0xc,%esp
  801e66:	68 40 3a 80 00       	push   $0x803a40
  801e6b:	e8 c3 e6 ff ff       	call   800533 <cprintf>
  801e70:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e73:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e7a:	83 ec 0c             	sub    $0xc,%esp
  801e7d:	68 6c 3a 80 00       	push   $0x803a6c
  801e82:	e8 ac e6 ff ff       	call   800533 <cprintf>
  801e87:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e8a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e8e:	a1 38 41 80 00       	mov    0x804138,%eax
  801e93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e96:	eb 56                	jmp    801eee <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e98:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e9c:	74 1c                	je     801eba <print_mem_block_lists+0x5d>
  801e9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea1:	8b 50 08             	mov    0x8(%eax),%edx
  801ea4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ea7:	8b 48 08             	mov    0x8(%eax),%ecx
  801eaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ead:	8b 40 0c             	mov    0xc(%eax),%eax
  801eb0:	01 c8                	add    %ecx,%eax
  801eb2:	39 c2                	cmp    %eax,%edx
  801eb4:	73 04                	jae    801eba <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801eb6:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebd:	8b 50 08             	mov    0x8(%eax),%edx
  801ec0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec3:	8b 40 0c             	mov    0xc(%eax),%eax
  801ec6:	01 c2                	add    %eax,%edx
  801ec8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ecb:	8b 40 08             	mov    0x8(%eax),%eax
  801ece:	83 ec 04             	sub    $0x4,%esp
  801ed1:	52                   	push   %edx
  801ed2:	50                   	push   %eax
  801ed3:	68 81 3a 80 00       	push   $0x803a81
  801ed8:	e8 56 e6 ff ff       	call   800533 <cprintf>
  801edd:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ee6:	a1 40 41 80 00       	mov    0x804140,%eax
  801eeb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ef2:	74 07                	je     801efb <print_mem_block_lists+0x9e>
  801ef4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef7:	8b 00                	mov    (%eax),%eax
  801ef9:	eb 05                	jmp    801f00 <print_mem_block_lists+0xa3>
  801efb:	b8 00 00 00 00       	mov    $0x0,%eax
  801f00:	a3 40 41 80 00       	mov    %eax,0x804140
  801f05:	a1 40 41 80 00       	mov    0x804140,%eax
  801f0a:	85 c0                	test   %eax,%eax
  801f0c:	75 8a                	jne    801e98 <print_mem_block_lists+0x3b>
  801f0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f12:	75 84                	jne    801e98 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f14:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f18:	75 10                	jne    801f2a <print_mem_block_lists+0xcd>
  801f1a:	83 ec 0c             	sub    $0xc,%esp
  801f1d:	68 90 3a 80 00       	push   $0x803a90
  801f22:	e8 0c e6 ff ff       	call   800533 <cprintf>
  801f27:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f2a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f31:	83 ec 0c             	sub    $0xc,%esp
  801f34:	68 b4 3a 80 00       	push   $0x803ab4
  801f39:	e8 f5 e5 ff ff       	call   800533 <cprintf>
  801f3e:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f41:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f45:	a1 40 40 80 00       	mov    0x804040,%eax
  801f4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f4d:	eb 56                	jmp    801fa5 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f4f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f53:	74 1c                	je     801f71 <print_mem_block_lists+0x114>
  801f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f58:	8b 50 08             	mov    0x8(%eax),%edx
  801f5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f5e:	8b 48 08             	mov    0x8(%eax),%ecx
  801f61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f64:	8b 40 0c             	mov    0xc(%eax),%eax
  801f67:	01 c8                	add    %ecx,%eax
  801f69:	39 c2                	cmp    %eax,%edx
  801f6b:	73 04                	jae    801f71 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f6d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f74:	8b 50 08             	mov    0x8(%eax),%edx
  801f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7a:	8b 40 0c             	mov    0xc(%eax),%eax
  801f7d:	01 c2                	add    %eax,%edx
  801f7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f82:	8b 40 08             	mov    0x8(%eax),%eax
  801f85:	83 ec 04             	sub    $0x4,%esp
  801f88:	52                   	push   %edx
  801f89:	50                   	push   %eax
  801f8a:	68 81 3a 80 00       	push   $0x803a81
  801f8f:	e8 9f e5 ff ff       	call   800533 <cprintf>
  801f94:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f9d:	a1 48 40 80 00       	mov    0x804048,%eax
  801fa2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fa5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fa9:	74 07                	je     801fb2 <print_mem_block_lists+0x155>
  801fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fae:	8b 00                	mov    (%eax),%eax
  801fb0:	eb 05                	jmp    801fb7 <print_mem_block_lists+0x15a>
  801fb2:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb7:	a3 48 40 80 00       	mov    %eax,0x804048
  801fbc:	a1 48 40 80 00       	mov    0x804048,%eax
  801fc1:	85 c0                	test   %eax,%eax
  801fc3:	75 8a                	jne    801f4f <print_mem_block_lists+0xf2>
  801fc5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fc9:	75 84                	jne    801f4f <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fcb:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fcf:	75 10                	jne    801fe1 <print_mem_block_lists+0x184>
  801fd1:	83 ec 0c             	sub    $0xc,%esp
  801fd4:	68 cc 3a 80 00       	push   $0x803acc
  801fd9:	e8 55 e5 ff ff       	call   800533 <cprintf>
  801fde:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801fe1:	83 ec 0c             	sub    $0xc,%esp
  801fe4:	68 40 3a 80 00       	push   $0x803a40
  801fe9:	e8 45 e5 ff ff       	call   800533 <cprintf>
  801fee:	83 c4 10             	add    $0x10,%esp

}
  801ff1:	90                   	nop
  801ff2:	c9                   	leave  
  801ff3:	c3                   	ret    

00801ff4 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801ff4:	55                   	push   %ebp
  801ff5:	89 e5                	mov    %esp,%ebp
  801ff7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  801ffa:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802001:	00 00 00 
  802004:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  80200b:	00 00 00 
  80200e:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802015:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802018:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80201f:	e9 9e 00 00 00       	jmp    8020c2 <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802024:	a1 50 40 80 00       	mov    0x804050,%eax
  802029:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80202c:	c1 e2 04             	shl    $0x4,%edx
  80202f:	01 d0                	add    %edx,%eax
  802031:	85 c0                	test   %eax,%eax
  802033:	75 14                	jne    802049 <initialize_MemBlocksList+0x55>
  802035:	83 ec 04             	sub    $0x4,%esp
  802038:	68 f4 3a 80 00       	push   $0x803af4
  80203d:	6a 47                	push   $0x47
  80203f:	68 17 3b 80 00       	push   $0x803b17
  802044:	e8 36 e2 ff ff       	call   80027f <_panic>
  802049:	a1 50 40 80 00       	mov    0x804050,%eax
  80204e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802051:	c1 e2 04             	shl    $0x4,%edx
  802054:	01 d0                	add    %edx,%eax
  802056:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80205c:	89 10                	mov    %edx,(%eax)
  80205e:	8b 00                	mov    (%eax),%eax
  802060:	85 c0                	test   %eax,%eax
  802062:	74 18                	je     80207c <initialize_MemBlocksList+0x88>
  802064:	a1 48 41 80 00       	mov    0x804148,%eax
  802069:	8b 15 50 40 80 00    	mov    0x804050,%edx
  80206f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802072:	c1 e1 04             	shl    $0x4,%ecx
  802075:	01 ca                	add    %ecx,%edx
  802077:	89 50 04             	mov    %edx,0x4(%eax)
  80207a:	eb 12                	jmp    80208e <initialize_MemBlocksList+0x9a>
  80207c:	a1 50 40 80 00       	mov    0x804050,%eax
  802081:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802084:	c1 e2 04             	shl    $0x4,%edx
  802087:	01 d0                	add    %edx,%eax
  802089:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80208e:	a1 50 40 80 00       	mov    0x804050,%eax
  802093:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802096:	c1 e2 04             	shl    $0x4,%edx
  802099:	01 d0                	add    %edx,%eax
  80209b:	a3 48 41 80 00       	mov    %eax,0x804148
  8020a0:	a1 50 40 80 00       	mov    0x804050,%eax
  8020a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020a8:	c1 e2 04             	shl    $0x4,%edx
  8020ab:	01 d0                	add    %edx,%eax
  8020ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020b4:	a1 54 41 80 00       	mov    0x804154,%eax
  8020b9:	40                   	inc    %eax
  8020ba:	a3 54 41 80 00       	mov    %eax,0x804154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  8020bf:	ff 45 f4             	incl   -0xc(%ebp)
  8020c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020c8:	0f 82 56 ff ff ff    	jb     802024 <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  8020ce:	90                   	nop
  8020cf:	c9                   	leave  
  8020d0:	c3                   	ret    

008020d1 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020d1:	55                   	push   %ebp
  8020d2:	89 e5                	mov    %esp,%ebp
  8020d4:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  8020d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020da:	8b 00                	mov    (%eax),%eax
  8020dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020df:	eb 19                	jmp    8020fa <find_block+0x29>
	{
		if(element->sva == va){
  8020e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020e4:	8b 40 08             	mov    0x8(%eax),%eax
  8020e7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8020ea:	75 05                	jne    8020f1 <find_block+0x20>
			 		return element;
  8020ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020ef:	eb 36                	jmp    802127 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  8020f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f4:	8b 40 08             	mov    0x8(%eax),%eax
  8020f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020fe:	74 07                	je     802107 <find_block+0x36>
  802100:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802103:	8b 00                	mov    (%eax),%eax
  802105:	eb 05                	jmp    80210c <find_block+0x3b>
  802107:	b8 00 00 00 00       	mov    $0x0,%eax
  80210c:	8b 55 08             	mov    0x8(%ebp),%edx
  80210f:	89 42 08             	mov    %eax,0x8(%edx)
  802112:	8b 45 08             	mov    0x8(%ebp),%eax
  802115:	8b 40 08             	mov    0x8(%eax),%eax
  802118:	85 c0                	test   %eax,%eax
  80211a:	75 c5                	jne    8020e1 <find_block+0x10>
  80211c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802120:	75 bf                	jne    8020e1 <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  802122:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802127:	c9                   	leave  
  802128:	c3                   	ret    

00802129 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802129:	55                   	push   %ebp
  80212a:	89 e5                	mov    %esp,%ebp
  80212c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  80212f:	a1 44 40 80 00       	mov    0x804044,%eax
  802134:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  802137:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80213c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  80213f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802143:	74 0a                	je     80214f <insert_sorted_allocList+0x26>
  802145:	8b 45 08             	mov    0x8(%ebp),%eax
  802148:	8b 40 08             	mov    0x8(%eax),%eax
  80214b:	85 c0                	test   %eax,%eax
  80214d:	75 65                	jne    8021b4 <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80214f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802153:	75 14                	jne    802169 <insert_sorted_allocList+0x40>
  802155:	83 ec 04             	sub    $0x4,%esp
  802158:	68 f4 3a 80 00       	push   $0x803af4
  80215d:	6a 6e                	push   $0x6e
  80215f:	68 17 3b 80 00       	push   $0x803b17
  802164:	e8 16 e1 ff ff       	call   80027f <_panic>
  802169:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80216f:	8b 45 08             	mov    0x8(%ebp),%eax
  802172:	89 10                	mov    %edx,(%eax)
  802174:	8b 45 08             	mov    0x8(%ebp),%eax
  802177:	8b 00                	mov    (%eax),%eax
  802179:	85 c0                	test   %eax,%eax
  80217b:	74 0d                	je     80218a <insert_sorted_allocList+0x61>
  80217d:	a1 40 40 80 00       	mov    0x804040,%eax
  802182:	8b 55 08             	mov    0x8(%ebp),%edx
  802185:	89 50 04             	mov    %edx,0x4(%eax)
  802188:	eb 08                	jmp    802192 <insert_sorted_allocList+0x69>
  80218a:	8b 45 08             	mov    0x8(%ebp),%eax
  80218d:	a3 44 40 80 00       	mov    %eax,0x804044
  802192:	8b 45 08             	mov    0x8(%ebp),%eax
  802195:	a3 40 40 80 00       	mov    %eax,0x804040
  80219a:	8b 45 08             	mov    0x8(%ebp),%eax
  80219d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021a4:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021a9:	40                   	inc    %eax
  8021aa:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8021af:	e9 cf 01 00 00       	jmp    802383 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  8021b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b7:	8b 50 08             	mov    0x8(%eax),%edx
  8021ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bd:	8b 40 08             	mov    0x8(%eax),%eax
  8021c0:	39 c2                	cmp    %eax,%edx
  8021c2:	73 65                	jae    802229 <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8021c4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021c8:	75 14                	jne    8021de <insert_sorted_allocList+0xb5>
  8021ca:	83 ec 04             	sub    $0x4,%esp
  8021cd:	68 30 3b 80 00       	push   $0x803b30
  8021d2:	6a 72                	push   $0x72
  8021d4:	68 17 3b 80 00       	push   $0x803b17
  8021d9:	e8 a1 e0 ff ff       	call   80027f <_panic>
  8021de:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8021e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e7:	89 50 04             	mov    %edx,0x4(%eax)
  8021ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ed:	8b 40 04             	mov    0x4(%eax),%eax
  8021f0:	85 c0                	test   %eax,%eax
  8021f2:	74 0c                	je     802200 <insert_sorted_allocList+0xd7>
  8021f4:	a1 44 40 80 00       	mov    0x804044,%eax
  8021f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8021fc:	89 10                	mov    %edx,(%eax)
  8021fe:	eb 08                	jmp    802208 <insert_sorted_allocList+0xdf>
  802200:	8b 45 08             	mov    0x8(%ebp),%eax
  802203:	a3 40 40 80 00       	mov    %eax,0x804040
  802208:	8b 45 08             	mov    0x8(%ebp),%eax
  80220b:	a3 44 40 80 00       	mov    %eax,0x804044
  802210:	8b 45 08             	mov    0x8(%ebp),%eax
  802213:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802219:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80221e:	40                   	inc    %eax
  80221f:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  802224:	e9 5a 01 00 00       	jmp    802383 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  802229:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80222c:	8b 50 08             	mov    0x8(%eax),%edx
  80222f:	8b 45 08             	mov    0x8(%ebp),%eax
  802232:	8b 40 08             	mov    0x8(%eax),%eax
  802235:	39 c2                	cmp    %eax,%edx
  802237:	75 70                	jne    8022a9 <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  802239:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80223d:	74 06                	je     802245 <insert_sorted_allocList+0x11c>
  80223f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802243:	75 14                	jne    802259 <insert_sorted_allocList+0x130>
  802245:	83 ec 04             	sub    $0x4,%esp
  802248:	68 54 3b 80 00       	push   $0x803b54
  80224d:	6a 75                	push   $0x75
  80224f:	68 17 3b 80 00       	push   $0x803b17
  802254:	e8 26 e0 ff ff       	call   80027f <_panic>
  802259:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80225c:	8b 10                	mov    (%eax),%edx
  80225e:	8b 45 08             	mov    0x8(%ebp),%eax
  802261:	89 10                	mov    %edx,(%eax)
  802263:	8b 45 08             	mov    0x8(%ebp),%eax
  802266:	8b 00                	mov    (%eax),%eax
  802268:	85 c0                	test   %eax,%eax
  80226a:	74 0b                	je     802277 <insert_sorted_allocList+0x14e>
  80226c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80226f:	8b 00                	mov    (%eax),%eax
  802271:	8b 55 08             	mov    0x8(%ebp),%edx
  802274:	89 50 04             	mov    %edx,0x4(%eax)
  802277:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80227a:	8b 55 08             	mov    0x8(%ebp),%edx
  80227d:	89 10                	mov    %edx,(%eax)
  80227f:	8b 45 08             	mov    0x8(%ebp),%eax
  802282:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802285:	89 50 04             	mov    %edx,0x4(%eax)
  802288:	8b 45 08             	mov    0x8(%ebp),%eax
  80228b:	8b 00                	mov    (%eax),%eax
  80228d:	85 c0                	test   %eax,%eax
  80228f:	75 08                	jne    802299 <insert_sorted_allocList+0x170>
  802291:	8b 45 08             	mov    0x8(%ebp),%eax
  802294:	a3 44 40 80 00       	mov    %eax,0x804044
  802299:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80229e:	40                   	inc    %eax
  80229f:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  8022a4:	e9 da 00 00 00       	jmp    802383 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  8022a9:	a1 40 40 80 00       	mov    0x804040,%eax
  8022ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022b1:	e9 9d 00 00 00       	jmp    802353 <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  8022b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b9:	8b 00                	mov    (%eax),%eax
  8022bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  8022be:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c1:	8b 50 08             	mov    0x8(%eax),%edx
  8022c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c7:	8b 40 08             	mov    0x8(%eax),%eax
  8022ca:	39 c2                	cmp    %eax,%edx
  8022cc:	76 7d                	jbe    80234b <insert_sorted_allocList+0x222>
  8022ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d1:	8b 50 08             	mov    0x8(%eax),%edx
  8022d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022d7:	8b 40 08             	mov    0x8(%eax),%eax
  8022da:	39 c2                	cmp    %eax,%edx
  8022dc:	73 6d                	jae    80234b <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  8022de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022e2:	74 06                	je     8022ea <insert_sorted_allocList+0x1c1>
  8022e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022e8:	75 14                	jne    8022fe <insert_sorted_allocList+0x1d5>
  8022ea:	83 ec 04             	sub    $0x4,%esp
  8022ed:	68 54 3b 80 00       	push   $0x803b54
  8022f2:	6a 7c                	push   $0x7c
  8022f4:	68 17 3b 80 00       	push   $0x803b17
  8022f9:	e8 81 df ff ff       	call   80027f <_panic>
  8022fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802301:	8b 10                	mov    (%eax),%edx
  802303:	8b 45 08             	mov    0x8(%ebp),%eax
  802306:	89 10                	mov    %edx,(%eax)
  802308:	8b 45 08             	mov    0x8(%ebp),%eax
  80230b:	8b 00                	mov    (%eax),%eax
  80230d:	85 c0                	test   %eax,%eax
  80230f:	74 0b                	je     80231c <insert_sorted_allocList+0x1f3>
  802311:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802314:	8b 00                	mov    (%eax),%eax
  802316:	8b 55 08             	mov    0x8(%ebp),%edx
  802319:	89 50 04             	mov    %edx,0x4(%eax)
  80231c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231f:	8b 55 08             	mov    0x8(%ebp),%edx
  802322:	89 10                	mov    %edx,(%eax)
  802324:	8b 45 08             	mov    0x8(%ebp),%eax
  802327:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80232a:	89 50 04             	mov    %edx,0x4(%eax)
  80232d:	8b 45 08             	mov    0x8(%ebp),%eax
  802330:	8b 00                	mov    (%eax),%eax
  802332:	85 c0                	test   %eax,%eax
  802334:	75 08                	jne    80233e <insert_sorted_allocList+0x215>
  802336:	8b 45 08             	mov    0x8(%ebp),%eax
  802339:	a3 44 40 80 00       	mov    %eax,0x804044
  80233e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802343:	40                   	inc    %eax
  802344:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802349:	eb 38                	jmp    802383 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  80234b:	a1 48 40 80 00       	mov    0x804048,%eax
  802350:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802353:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802357:	74 07                	je     802360 <insert_sorted_allocList+0x237>
  802359:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235c:	8b 00                	mov    (%eax),%eax
  80235e:	eb 05                	jmp    802365 <insert_sorted_allocList+0x23c>
  802360:	b8 00 00 00 00       	mov    $0x0,%eax
  802365:	a3 48 40 80 00       	mov    %eax,0x804048
  80236a:	a1 48 40 80 00       	mov    0x804048,%eax
  80236f:	85 c0                	test   %eax,%eax
  802371:	0f 85 3f ff ff ff    	jne    8022b6 <insert_sorted_allocList+0x18d>
  802377:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80237b:	0f 85 35 ff ff ff    	jne    8022b6 <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  802381:	eb 00                	jmp    802383 <insert_sorted_allocList+0x25a>
  802383:	90                   	nop
  802384:	c9                   	leave  
  802385:	c3                   	ret    

00802386 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802386:	55                   	push   %ebp
  802387:	89 e5                	mov    %esp,%ebp
  802389:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  80238c:	a1 38 41 80 00       	mov    0x804138,%eax
  802391:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802394:	e9 6b 02 00 00       	jmp    802604 <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  802399:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239c:	8b 40 0c             	mov    0xc(%eax),%eax
  80239f:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023a2:	0f 85 90 00 00 00    	jne    802438 <alloc_block_FF+0xb2>
			  temp=element;
  8023a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  8023ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023b2:	75 17                	jne    8023cb <alloc_block_FF+0x45>
  8023b4:	83 ec 04             	sub    $0x4,%esp
  8023b7:	68 88 3b 80 00       	push   $0x803b88
  8023bc:	68 92 00 00 00       	push   $0x92
  8023c1:	68 17 3b 80 00       	push   $0x803b17
  8023c6:	e8 b4 de ff ff       	call   80027f <_panic>
  8023cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ce:	8b 00                	mov    (%eax),%eax
  8023d0:	85 c0                	test   %eax,%eax
  8023d2:	74 10                	je     8023e4 <alloc_block_FF+0x5e>
  8023d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d7:	8b 00                	mov    (%eax),%eax
  8023d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023dc:	8b 52 04             	mov    0x4(%edx),%edx
  8023df:	89 50 04             	mov    %edx,0x4(%eax)
  8023e2:	eb 0b                	jmp    8023ef <alloc_block_FF+0x69>
  8023e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e7:	8b 40 04             	mov    0x4(%eax),%eax
  8023ea:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8023ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f2:	8b 40 04             	mov    0x4(%eax),%eax
  8023f5:	85 c0                	test   %eax,%eax
  8023f7:	74 0f                	je     802408 <alloc_block_FF+0x82>
  8023f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fc:	8b 40 04             	mov    0x4(%eax),%eax
  8023ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802402:	8b 12                	mov    (%edx),%edx
  802404:	89 10                	mov    %edx,(%eax)
  802406:	eb 0a                	jmp    802412 <alloc_block_FF+0x8c>
  802408:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240b:	8b 00                	mov    (%eax),%eax
  80240d:	a3 38 41 80 00       	mov    %eax,0x804138
  802412:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802415:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80241b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802425:	a1 44 41 80 00       	mov    0x804144,%eax
  80242a:	48                   	dec    %eax
  80242b:	a3 44 41 80 00       	mov    %eax,0x804144
			  return temp;
  802430:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802433:	e9 ff 01 00 00       	jmp    802637 <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  802438:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243b:	8b 40 0c             	mov    0xc(%eax),%eax
  80243e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802441:	0f 86 b5 01 00 00    	jbe    8025fc <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  802447:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244a:	8b 40 0c             	mov    0xc(%eax),%eax
  80244d:	2b 45 08             	sub    0x8(%ebp),%eax
  802450:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  802453:	a1 48 41 80 00       	mov    0x804148,%eax
  802458:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  80245b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80245f:	75 17                	jne    802478 <alloc_block_FF+0xf2>
  802461:	83 ec 04             	sub    $0x4,%esp
  802464:	68 88 3b 80 00       	push   $0x803b88
  802469:	68 99 00 00 00       	push   $0x99
  80246e:	68 17 3b 80 00       	push   $0x803b17
  802473:	e8 07 de ff ff       	call   80027f <_panic>
  802478:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80247b:	8b 00                	mov    (%eax),%eax
  80247d:	85 c0                	test   %eax,%eax
  80247f:	74 10                	je     802491 <alloc_block_FF+0x10b>
  802481:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802484:	8b 00                	mov    (%eax),%eax
  802486:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802489:	8b 52 04             	mov    0x4(%edx),%edx
  80248c:	89 50 04             	mov    %edx,0x4(%eax)
  80248f:	eb 0b                	jmp    80249c <alloc_block_FF+0x116>
  802491:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802494:	8b 40 04             	mov    0x4(%eax),%eax
  802497:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80249c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80249f:	8b 40 04             	mov    0x4(%eax),%eax
  8024a2:	85 c0                	test   %eax,%eax
  8024a4:	74 0f                	je     8024b5 <alloc_block_FF+0x12f>
  8024a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024a9:	8b 40 04             	mov    0x4(%eax),%eax
  8024ac:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024af:	8b 12                	mov    (%edx),%edx
  8024b1:	89 10                	mov    %edx,(%eax)
  8024b3:	eb 0a                	jmp    8024bf <alloc_block_FF+0x139>
  8024b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024b8:	8b 00                	mov    (%eax),%eax
  8024ba:	a3 48 41 80 00       	mov    %eax,0x804148
  8024bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024cb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024d2:	a1 54 41 80 00       	mov    0x804154,%eax
  8024d7:	48                   	dec    %eax
  8024d8:	a3 54 41 80 00       	mov    %eax,0x804154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  8024dd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8024e1:	75 17                	jne    8024fa <alloc_block_FF+0x174>
  8024e3:	83 ec 04             	sub    $0x4,%esp
  8024e6:	68 30 3b 80 00       	push   $0x803b30
  8024eb:	68 9a 00 00 00       	push   $0x9a
  8024f0:	68 17 3b 80 00       	push   $0x803b17
  8024f5:	e8 85 dd ff ff       	call   80027f <_panic>
  8024fa:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802500:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802503:	89 50 04             	mov    %edx,0x4(%eax)
  802506:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802509:	8b 40 04             	mov    0x4(%eax),%eax
  80250c:	85 c0                	test   %eax,%eax
  80250e:	74 0c                	je     80251c <alloc_block_FF+0x196>
  802510:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802515:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802518:	89 10                	mov    %edx,(%eax)
  80251a:	eb 08                	jmp    802524 <alloc_block_FF+0x19e>
  80251c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80251f:	a3 38 41 80 00       	mov    %eax,0x804138
  802524:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802527:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80252c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80252f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802535:	a1 44 41 80 00       	mov    0x804144,%eax
  80253a:	40                   	inc    %eax
  80253b:	a3 44 41 80 00       	mov    %eax,0x804144
		  // setting the size & sva
		  new_block->size=size;
  802540:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802543:	8b 55 08             	mov    0x8(%ebp),%edx
  802546:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  802549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254c:	8b 50 08             	mov    0x8(%eax),%edx
  80254f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802552:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  802555:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802558:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80255b:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  80255e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802561:	8b 50 08             	mov    0x8(%eax),%edx
  802564:	8b 45 08             	mov    0x8(%ebp),%eax
  802567:	01 c2                	add    %eax,%edx
  802569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256c:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  80256f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802572:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  802575:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802579:	75 17                	jne    802592 <alloc_block_FF+0x20c>
  80257b:	83 ec 04             	sub    $0x4,%esp
  80257e:	68 88 3b 80 00       	push   $0x803b88
  802583:	68 a2 00 00 00       	push   $0xa2
  802588:	68 17 3b 80 00       	push   $0x803b17
  80258d:	e8 ed dc ff ff       	call   80027f <_panic>
  802592:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802595:	8b 00                	mov    (%eax),%eax
  802597:	85 c0                	test   %eax,%eax
  802599:	74 10                	je     8025ab <alloc_block_FF+0x225>
  80259b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80259e:	8b 00                	mov    (%eax),%eax
  8025a0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025a3:	8b 52 04             	mov    0x4(%edx),%edx
  8025a6:	89 50 04             	mov    %edx,0x4(%eax)
  8025a9:	eb 0b                	jmp    8025b6 <alloc_block_FF+0x230>
  8025ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ae:	8b 40 04             	mov    0x4(%eax),%eax
  8025b1:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025b9:	8b 40 04             	mov    0x4(%eax),%eax
  8025bc:	85 c0                	test   %eax,%eax
  8025be:	74 0f                	je     8025cf <alloc_block_FF+0x249>
  8025c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025c3:	8b 40 04             	mov    0x4(%eax),%eax
  8025c6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025c9:	8b 12                	mov    (%edx),%edx
  8025cb:	89 10                	mov    %edx,(%eax)
  8025cd:	eb 0a                	jmp    8025d9 <alloc_block_FF+0x253>
  8025cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d2:	8b 00                	mov    (%eax),%eax
  8025d4:	a3 38 41 80 00       	mov    %eax,0x804138
  8025d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025ec:	a1 44 41 80 00       	mov    0x804144,%eax
  8025f1:	48                   	dec    %eax
  8025f2:	a3 44 41 80 00       	mov    %eax,0x804144
		  return temp;
  8025f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025fa:	eb 3b                	jmp    802637 <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  8025fc:	a1 40 41 80 00       	mov    0x804140,%eax
  802601:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802604:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802608:	74 07                	je     802611 <alloc_block_FF+0x28b>
  80260a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260d:	8b 00                	mov    (%eax),%eax
  80260f:	eb 05                	jmp    802616 <alloc_block_FF+0x290>
  802611:	b8 00 00 00 00       	mov    $0x0,%eax
  802616:	a3 40 41 80 00       	mov    %eax,0x804140
  80261b:	a1 40 41 80 00       	mov    0x804140,%eax
  802620:	85 c0                	test   %eax,%eax
  802622:	0f 85 71 fd ff ff    	jne    802399 <alloc_block_FF+0x13>
  802628:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80262c:	0f 85 67 fd ff ff    	jne    802399 <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  802632:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802637:	c9                   	leave  
  802638:	c3                   	ret    

00802639 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802639:	55                   	push   %ebp
  80263a:	89 e5                	mov    %esp,%ebp
  80263c:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  80263f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  802646:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  80264d:	a1 38 41 80 00       	mov    0x804138,%eax
  802652:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802655:	e9 d3 00 00 00       	jmp    80272d <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  80265a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80265d:	8b 40 0c             	mov    0xc(%eax),%eax
  802660:	3b 45 08             	cmp    0x8(%ebp),%eax
  802663:	0f 85 90 00 00 00    	jne    8026f9 <alloc_block_BF+0xc0>
	   temp = element;
  802669:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80266c:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  80266f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802673:	75 17                	jne    80268c <alloc_block_BF+0x53>
  802675:	83 ec 04             	sub    $0x4,%esp
  802678:	68 88 3b 80 00       	push   $0x803b88
  80267d:	68 bd 00 00 00       	push   $0xbd
  802682:	68 17 3b 80 00       	push   $0x803b17
  802687:	e8 f3 db ff ff       	call   80027f <_panic>
  80268c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80268f:	8b 00                	mov    (%eax),%eax
  802691:	85 c0                	test   %eax,%eax
  802693:	74 10                	je     8026a5 <alloc_block_BF+0x6c>
  802695:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802698:	8b 00                	mov    (%eax),%eax
  80269a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80269d:	8b 52 04             	mov    0x4(%edx),%edx
  8026a0:	89 50 04             	mov    %edx,0x4(%eax)
  8026a3:	eb 0b                	jmp    8026b0 <alloc_block_BF+0x77>
  8026a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026a8:	8b 40 04             	mov    0x4(%eax),%eax
  8026ab:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026b3:	8b 40 04             	mov    0x4(%eax),%eax
  8026b6:	85 c0                	test   %eax,%eax
  8026b8:	74 0f                	je     8026c9 <alloc_block_BF+0x90>
  8026ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026bd:	8b 40 04             	mov    0x4(%eax),%eax
  8026c0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026c3:	8b 12                	mov    (%edx),%edx
  8026c5:	89 10                	mov    %edx,(%eax)
  8026c7:	eb 0a                	jmp    8026d3 <alloc_block_BF+0x9a>
  8026c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026cc:	8b 00                	mov    (%eax),%eax
  8026ce:	a3 38 41 80 00       	mov    %eax,0x804138
  8026d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026e6:	a1 44 41 80 00       	mov    0x804144,%eax
  8026eb:	48                   	dec    %eax
  8026ec:	a3 44 41 80 00       	mov    %eax,0x804144
	   return temp;
  8026f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026f4:	e9 41 01 00 00       	jmp    80283a <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  8026f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ff:	3b 45 08             	cmp    0x8(%ebp),%eax
  802702:	76 21                	jbe    802725 <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  802704:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802707:	8b 40 0c             	mov    0xc(%eax),%eax
  80270a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80270d:	73 16                	jae    802725 <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  80270f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802712:	8b 40 0c             	mov    0xc(%eax),%eax
  802715:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  802718:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80271b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  80271e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802725:	a1 40 41 80 00       	mov    0x804140,%eax
  80272a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80272d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802731:	74 07                	je     80273a <alloc_block_BF+0x101>
  802733:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802736:	8b 00                	mov    (%eax),%eax
  802738:	eb 05                	jmp    80273f <alloc_block_BF+0x106>
  80273a:	b8 00 00 00 00       	mov    $0x0,%eax
  80273f:	a3 40 41 80 00       	mov    %eax,0x804140
  802744:	a1 40 41 80 00       	mov    0x804140,%eax
  802749:	85 c0                	test   %eax,%eax
  80274b:	0f 85 09 ff ff ff    	jne    80265a <alloc_block_BF+0x21>
  802751:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802755:	0f 85 ff fe ff ff    	jne    80265a <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  80275b:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  80275f:	0f 85 d0 00 00 00    	jne    802835 <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  802765:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802768:	8b 40 0c             	mov    0xc(%eax),%eax
  80276b:	2b 45 08             	sub    0x8(%ebp),%eax
  80276e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  802771:	a1 48 41 80 00       	mov    0x804148,%eax
  802776:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  802779:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80277d:	75 17                	jne    802796 <alloc_block_BF+0x15d>
  80277f:	83 ec 04             	sub    $0x4,%esp
  802782:	68 88 3b 80 00       	push   $0x803b88
  802787:	68 d1 00 00 00       	push   $0xd1
  80278c:	68 17 3b 80 00       	push   $0x803b17
  802791:	e8 e9 da ff ff       	call   80027f <_panic>
  802796:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802799:	8b 00                	mov    (%eax),%eax
  80279b:	85 c0                	test   %eax,%eax
  80279d:	74 10                	je     8027af <alloc_block_BF+0x176>
  80279f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027a2:	8b 00                	mov    (%eax),%eax
  8027a4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027a7:	8b 52 04             	mov    0x4(%edx),%edx
  8027aa:	89 50 04             	mov    %edx,0x4(%eax)
  8027ad:	eb 0b                	jmp    8027ba <alloc_block_BF+0x181>
  8027af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027b2:	8b 40 04             	mov    0x4(%eax),%eax
  8027b5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8027ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027bd:	8b 40 04             	mov    0x4(%eax),%eax
  8027c0:	85 c0                	test   %eax,%eax
  8027c2:	74 0f                	je     8027d3 <alloc_block_BF+0x19a>
  8027c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027c7:	8b 40 04             	mov    0x4(%eax),%eax
  8027ca:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027cd:	8b 12                	mov    (%edx),%edx
  8027cf:	89 10                	mov    %edx,(%eax)
  8027d1:	eb 0a                	jmp    8027dd <alloc_block_BF+0x1a4>
  8027d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027d6:	8b 00                	mov    (%eax),%eax
  8027d8:	a3 48 41 80 00       	mov    %eax,0x804148
  8027dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027f0:	a1 54 41 80 00       	mov    0x804154,%eax
  8027f5:	48                   	dec    %eax
  8027f6:	a3 54 41 80 00       	mov    %eax,0x804154
	  // setting the size & sva
	  new_block->size = size;
  8027fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027fe:	8b 55 08             	mov    0x8(%ebp),%edx
  802801:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  802804:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802807:	8b 50 08             	mov    0x8(%eax),%edx
  80280a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80280d:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  802810:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802813:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802816:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  802819:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80281c:	8b 50 08             	mov    0x8(%eax),%edx
  80281f:	8b 45 08             	mov    0x8(%ebp),%eax
  802822:	01 c2                	add    %eax,%edx
  802824:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802827:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  80282a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80282d:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  802830:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802833:	eb 05                	jmp    80283a <alloc_block_BF+0x201>
	 }
	 return NULL;
  802835:	b8 00 00 00 00       	mov    $0x0,%eax


}
  80283a:	c9                   	leave  
  80283b:	c3                   	ret    

0080283c <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80283c:	55                   	push   %ebp
  80283d:	89 e5                	mov    %esp,%ebp
  80283f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802842:	83 ec 04             	sub    $0x4,%esp
  802845:	68 a8 3b 80 00       	push   $0x803ba8
  80284a:	68 e8 00 00 00       	push   $0xe8
  80284f:	68 17 3b 80 00       	push   $0x803b17
  802854:	e8 26 da ff ff       	call   80027f <_panic>

00802859 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802859:	55                   	push   %ebp
  80285a:	89 e5                	mov    %esp,%ebp
  80285c:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  80285f:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802864:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  802867:	a1 38 41 80 00       	mov    0x804138,%eax
  80286c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  80286f:	a1 44 41 80 00       	mov    0x804144,%eax
  802874:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  802877:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80287b:	75 68                	jne    8028e5 <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80287d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802881:	75 17                	jne    80289a <insert_sorted_with_merge_freeList+0x41>
  802883:	83 ec 04             	sub    $0x4,%esp
  802886:	68 f4 3a 80 00       	push   $0x803af4
  80288b:	68 36 01 00 00       	push   $0x136
  802890:	68 17 3b 80 00       	push   $0x803b17
  802895:	e8 e5 d9 ff ff       	call   80027f <_panic>
  80289a:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8028a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a3:	89 10                	mov    %edx,(%eax)
  8028a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a8:	8b 00                	mov    (%eax),%eax
  8028aa:	85 c0                	test   %eax,%eax
  8028ac:	74 0d                	je     8028bb <insert_sorted_with_merge_freeList+0x62>
  8028ae:	a1 38 41 80 00       	mov    0x804138,%eax
  8028b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8028b6:	89 50 04             	mov    %edx,0x4(%eax)
  8028b9:	eb 08                	jmp    8028c3 <insert_sorted_with_merge_freeList+0x6a>
  8028bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028be:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c6:	a3 38 41 80 00       	mov    %eax,0x804138
  8028cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028d5:	a1 44 41 80 00       	mov    0x804144,%eax
  8028da:	40                   	inc    %eax
  8028db:	a3 44 41 80 00       	mov    %eax,0x804144





}
  8028e0:	e9 ba 06 00 00       	jmp    802f9f <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  8028e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e8:	8b 50 08             	mov    0x8(%eax),%edx
  8028eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8028f1:	01 c2                	add    %eax,%edx
  8028f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f6:	8b 40 08             	mov    0x8(%eax),%eax
  8028f9:	39 c2                	cmp    %eax,%edx
  8028fb:	73 68                	jae    802965 <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8028fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802901:	75 17                	jne    80291a <insert_sorted_with_merge_freeList+0xc1>
  802903:	83 ec 04             	sub    $0x4,%esp
  802906:	68 30 3b 80 00       	push   $0x803b30
  80290b:	68 3a 01 00 00       	push   $0x13a
  802910:	68 17 3b 80 00       	push   $0x803b17
  802915:	e8 65 d9 ff ff       	call   80027f <_panic>
  80291a:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802920:	8b 45 08             	mov    0x8(%ebp),%eax
  802923:	89 50 04             	mov    %edx,0x4(%eax)
  802926:	8b 45 08             	mov    0x8(%ebp),%eax
  802929:	8b 40 04             	mov    0x4(%eax),%eax
  80292c:	85 c0                	test   %eax,%eax
  80292e:	74 0c                	je     80293c <insert_sorted_with_merge_freeList+0xe3>
  802930:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802935:	8b 55 08             	mov    0x8(%ebp),%edx
  802938:	89 10                	mov    %edx,(%eax)
  80293a:	eb 08                	jmp    802944 <insert_sorted_with_merge_freeList+0xeb>
  80293c:	8b 45 08             	mov    0x8(%ebp),%eax
  80293f:	a3 38 41 80 00       	mov    %eax,0x804138
  802944:	8b 45 08             	mov    0x8(%ebp),%eax
  802947:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80294c:	8b 45 08             	mov    0x8(%ebp),%eax
  80294f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802955:	a1 44 41 80 00       	mov    0x804144,%eax
  80295a:	40                   	inc    %eax
  80295b:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802960:	e9 3a 06 00 00       	jmp    802f9f <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  802965:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802968:	8b 50 08             	mov    0x8(%eax),%edx
  80296b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80296e:	8b 40 0c             	mov    0xc(%eax),%eax
  802971:	01 c2                	add    %eax,%edx
  802973:	8b 45 08             	mov    0x8(%ebp),%eax
  802976:	8b 40 08             	mov    0x8(%eax),%eax
  802979:	39 c2                	cmp    %eax,%edx
  80297b:	0f 85 90 00 00 00    	jne    802a11 <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  802981:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802984:	8b 50 0c             	mov    0xc(%eax),%edx
  802987:	8b 45 08             	mov    0x8(%ebp),%eax
  80298a:	8b 40 0c             	mov    0xc(%eax),%eax
  80298d:	01 c2                	add    %eax,%edx
  80298f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802992:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  802995:	8b 45 08             	mov    0x8(%ebp),%eax
  802998:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  80299f:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8029a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029ad:	75 17                	jne    8029c6 <insert_sorted_with_merge_freeList+0x16d>
  8029af:	83 ec 04             	sub    $0x4,%esp
  8029b2:	68 f4 3a 80 00       	push   $0x803af4
  8029b7:	68 41 01 00 00       	push   $0x141
  8029bc:	68 17 3b 80 00       	push   $0x803b17
  8029c1:	e8 b9 d8 ff ff       	call   80027f <_panic>
  8029c6:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8029cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cf:	89 10                	mov    %edx,(%eax)
  8029d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d4:	8b 00                	mov    (%eax),%eax
  8029d6:	85 c0                	test   %eax,%eax
  8029d8:	74 0d                	je     8029e7 <insert_sorted_with_merge_freeList+0x18e>
  8029da:	a1 48 41 80 00       	mov    0x804148,%eax
  8029df:	8b 55 08             	mov    0x8(%ebp),%edx
  8029e2:	89 50 04             	mov    %edx,0x4(%eax)
  8029e5:	eb 08                	jmp    8029ef <insert_sorted_with_merge_freeList+0x196>
  8029e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ea:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8029ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f2:	a3 48 41 80 00       	mov    %eax,0x804148
  8029f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a01:	a1 54 41 80 00       	mov    0x804154,%eax
  802a06:	40                   	inc    %eax
  802a07:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802a0c:	e9 8e 05 00 00       	jmp    802f9f <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  802a11:	8b 45 08             	mov    0x8(%ebp),%eax
  802a14:	8b 50 08             	mov    0x8(%eax),%edx
  802a17:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1a:	8b 40 0c             	mov    0xc(%eax),%eax
  802a1d:	01 c2                	add    %eax,%edx
  802a1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a22:	8b 40 08             	mov    0x8(%eax),%eax
  802a25:	39 c2                	cmp    %eax,%edx
  802a27:	73 68                	jae    802a91 <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802a29:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a2d:	75 17                	jne    802a46 <insert_sorted_with_merge_freeList+0x1ed>
  802a2f:	83 ec 04             	sub    $0x4,%esp
  802a32:	68 f4 3a 80 00       	push   $0x803af4
  802a37:	68 45 01 00 00       	push   $0x145
  802a3c:	68 17 3b 80 00       	push   $0x803b17
  802a41:	e8 39 d8 ff ff       	call   80027f <_panic>
  802a46:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4f:	89 10                	mov    %edx,(%eax)
  802a51:	8b 45 08             	mov    0x8(%ebp),%eax
  802a54:	8b 00                	mov    (%eax),%eax
  802a56:	85 c0                	test   %eax,%eax
  802a58:	74 0d                	je     802a67 <insert_sorted_with_merge_freeList+0x20e>
  802a5a:	a1 38 41 80 00       	mov    0x804138,%eax
  802a5f:	8b 55 08             	mov    0x8(%ebp),%edx
  802a62:	89 50 04             	mov    %edx,0x4(%eax)
  802a65:	eb 08                	jmp    802a6f <insert_sorted_with_merge_freeList+0x216>
  802a67:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a72:	a3 38 41 80 00       	mov    %eax,0x804138
  802a77:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a81:	a1 44 41 80 00       	mov    0x804144,%eax
  802a86:	40                   	inc    %eax
  802a87:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802a8c:	e9 0e 05 00 00       	jmp    802f9f <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  802a91:	8b 45 08             	mov    0x8(%ebp),%eax
  802a94:	8b 50 08             	mov    0x8(%eax),%edx
  802a97:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9a:	8b 40 0c             	mov    0xc(%eax),%eax
  802a9d:	01 c2                	add    %eax,%edx
  802a9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa2:	8b 40 08             	mov    0x8(%eax),%eax
  802aa5:	39 c2                	cmp    %eax,%edx
  802aa7:	0f 85 9c 00 00 00    	jne    802b49 <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  802aad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ab0:	8b 50 0c             	mov    0xc(%eax),%edx
  802ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ab9:	01 c2                	add    %eax,%edx
  802abb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802abe:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  802ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac4:	8b 50 08             	mov    0x8(%eax),%edx
  802ac7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aca:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  802acd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  802ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  802ada:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802ae1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ae5:	75 17                	jne    802afe <insert_sorted_with_merge_freeList+0x2a5>
  802ae7:	83 ec 04             	sub    $0x4,%esp
  802aea:	68 f4 3a 80 00       	push   $0x803af4
  802aef:	68 4d 01 00 00       	push   $0x14d
  802af4:	68 17 3b 80 00       	push   $0x803b17
  802af9:	e8 81 d7 ff ff       	call   80027f <_panic>
  802afe:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b04:	8b 45 08             	mov    0x8(%ebp),%eax
  802b07:	89 10                	mov    %edx,(%eax)
  802b09:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0c:	8b 00                	mov    (%eax),%eax
  802b0e:	85 c0                	test   %eax,%eax
  802b10:	74 0d                	je     802b1f <insert_sorted_with_merge_freeList+0x2c6>
  802b12:	a1 48 41 80 00       	mov    0x804148,%eax
  802b17:	8b 55 08             	mov    0x8(%ebp),%edx
  802b1a:	89 50 04             	mov    %edx,0x4(%eax)
  802b1d:	eb 08                	jmp    802b27 <insert_sorted_with_merge_freeList+0x2ce>
  802b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b22:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b27:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2a:	a3 48 41 80 00       	mov    %eax,0x804148
  802b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b32:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b39:	a1 54 41 80 00       	mov    0x804154,%eax
  802b3e:	40                   	inc    %eax
  802b3f:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802b44:	e9 56 04 00 00       	jmp    802f9f <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802b49:	a1 38 41 80 00       	mov    0x804138,%eax
  802b4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b51:	e9 19 04 00 00       	jmp    802f6f <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  802b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b59:	8b 00                	mov    (%eax),%eax
  802b5b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b61:	8b 50 08             	mov    0x8(%eax),%edx
  802b64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b67:	8b 40 0c             	mov    0xc(%eax),%eax
  802b6a:	01 c2                	add    %eax,%edx
  802b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6f:	8b 40 08             	mov    0x8(%eax),%eax
  802b72:	39 c2                	cmp    %eax,%edx
  802b74:	0f 85 ad 01 00 00    	jne    802d27 <insert_sorted_with_merge_freeList+0x4ce>
  802b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7d:	8b 50 08             	mov    0x8(%eax),%edx
  802b80:	8b 45 08             	mov    0x8(%ebp),%eax
  802b83:	8b 40 0c             	mov    0xc(%eax),%eax
  802b86:	01 c2                	add    %eax,%edx
  802b88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b8b:	8b 40 08             	mov    0x8(%eax),%eax
  802b8e:	39 c2                	cmp    %eax,%edx
  802b90:	0f 85 91 01 00 00    	jne    802d27 <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  802b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b99:	8b 50 0c             	mov    0xc(%eax),%edx
  802b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9f:	8b 48 0c             	mov    0xc(%eax),%ecx
  802ba2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ba5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba8:	01 c8                	add    %ecx,%eax
  802baa:	01 c2                	add    %eax,%edx
  802bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baf:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  802bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  802bc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bc9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  802bd0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bd3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  802bda:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802bde:	75 17                	jne    802bf7 <insert_sorted_with_merge_freeList+0x39e>
  802be0:	83 ec 04             	sub    $0x4,%esp
  802be3:	68 88 3b 80 00       	push   $0x803b88
  802be8:	68 5b 01 00 00       	push   $0x15b
  802bed:	68 17 3b 80 00       	push   $0x803b17
  802bf2:	e8 88 d6 ff ff       	call   80027f <_panic>
  802bf7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bfa:	8b 00                	mov    (%eax),%eax
  802bfc:	85 c0                	test   %eax,%eax
  802bfe:	74 10                	je     802c10 <insert_sorted_with_merge_freeList+0x3b7>
  802c00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c03:	8b 00                	mov    (%eax),%eax
  802c05:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c08:	8b 52 04             	mov    0x4(%edx),%edx
  802c0b:	89 50 04             	mov    %edx,0x4(%eax)
  802c0e:	eb 0b                	jmp    802c1b <insert_sorted_with_merge_freeList+0x3c2>
  802c10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c13:	8b 40 04             	mov    0x4(%eax),%eax
  802c16:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c1e:	8b 40 04             	mov    0x4(%eax),%eax
  802c21:	85 c0                	test   %eax,%eax
  802c23:	74 0f                	je     802c34 <insert_sorted_with_merge_freeList+0x3db>
  802c25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c28:	8b 40 04             	mov    0x4(%eax),%eax
  802c2b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c2e:	8b 12                	mov    (%edx),%edx
  802c30:	89 10                	mov    %edx,(%eax)
  802c32:	eb 0a                	jmp    802c3e <insert_sorted_with_merge_freeList+0x3e5>
  802c34:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c37:	8b 00                	mov    (%eax),%eax
  802c39:	a3 38 41 80 00       	mov    %eax,0x804138
  802c3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c41:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c4a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c51:	a1 44 41 80 00       	mov    0x804144,%eax
  802c56:	48                   	dec    %eax
  802c57:	a3 44 41 80 00       	mov    %eax,0x804144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802c5c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c60:	75 17                	jne    802c79 <insert_sorted_with_merge_freeList+0x420>
  802c62:	83 ec 04             	sub    $0x4,%esp
  802c65:	68 f4 3a 80 00       	push   $0x803af4
  802c6a:	68 5c 01 00 00       	push   $0x15c
  802c6f:	68 17 3b 80 00       	push   $0x803b17
  802c74:	e8 06 d6 ff ff       	call   80027f <_panic>
  802c79:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c82:	89 10                	mov    %edx,(%eax)
  802c84:	8b 45 08             	mov    0x8(%ebp),%eax
  802c87:	8b 00                	mov    (%eax),%eax
  802c89:	85 c0                	test   %eax,%eax
  802c8b:	74 0d                	je     802c9a <insert_sorted_with_merge_freeList+0x441>
  802c8d:	a1 48 41 80 00       	mov    0x804148,%eax
  802c92:	8b 55 08             	mov    0x8(%ebp),%edx
  802c95:	89 50 04             	mov    %edx,0x4(%eax)
  802c98:	eb 08                	jmp    802ca2 <insert_sorted_with_merge_freeList+0x449>
  802c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca5:	a3 48 41 80 00       	mov    %eax,0x804148
  802caa:	8b 45 08             	mov    0x8(%ebp),%eax
  802cad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cb4:	a1 54 41 80 00       	mov    0x804154,%eax
  802cb9:	40                   	inc    %eax
  802cba:	a3 54 41 80 00       	mov    %eax,0x804154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  802cbf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802cc3:	75 17                	jne    802cdc <insert_sorted_with_merge_freeList+0x483>
  802cc5:	83 ec 04             	sub    $0x4,%esp
  802cc8:	68 f4 3a 80 00       	push   $0x803af4
  802ccd:	68 5d 01 00 00       	push   $0x15d
  802cd2:	68 17 3b 80 00       	push   $0x803b17
  802cd7:	e8 a3 d5 ff ff       	call   80027f <_panic>
  802cdc:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ce2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ce5:	89 10                	mov    %edx,(%eax)
  802ce7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cea:	8b 00                	mov    (%eax),%eax
  802cec:	85 c0                	test   %eax,%eax
  802cee:	74 0d                	je     802cfd <insert_sorted_with_merge_freeList+0x4a4>
  802cf0:	a1 48 41 80 00       	mov    0x804148,%eax
  802cf5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802cf8:	89 50 04             	mov    %edx,0x4(%eax)
  802cfb:	eb 08                	jmp    802d05 <insert_sorted_with_merge_freeList+0x4ac>
  802cfd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d00:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d08:	a3 48 41 80 00       	mov    %eax,0x804148
  802d0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d10:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d17:	a1 54 41 80 00       	mov    0x804154,%eax
  802d1c:	40                   	inc    %eax
  802d1d:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802d22:	e9 78 02 00 00       	jmp    802f9f <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802d27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2a:	8b 50 08             	mov    0x8(%eax),%edx
  802d2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d30:	8b 40 0c             	mov    0xc(%eax),%eax
  802d33:	01 c2                	add    %eax,%edx
  802d35:	8b 45 08             	mov    0x8(%ebp),%eax
  802d38:	8b 40 08             	mov    0x8(%eax),%eax
  802d3b:	39 c2                	cmp    %eax,%edx
  802d3d:	0f 83 b8 00 00 00    	jae    802dfb <insert_sorted_with_merge_freeList+0x5a2>
  802d43:	8b 45 08             	mov    0x8(%ebp),%eax
  802d46:	8b 50 08             	mov    0x8(%eax),%edx
  802d49:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d4f:	01 c2                	add    %eax,%edx
  802d51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d54:	8b 40 08             	mov    0x8(%eax),%eax
  802d57:	39 c2                	cmp    %eax,%edx
  802d59:	0f 85 9c 00 00 00    	jne    802dfb <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  802d5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d62:	8b 50 0c             	mov    0xc(%eax),%edx
  802d65:	8b 45 08             	mov    0x8(%ebp),%eax
  802d68:	8b 40 0c             	mov    0xc(%eax),%eax
  802d6b:	01 c2                	add    %eax,%edx
  802d6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d70:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  802d73:	8b 45 08             	mov    0x8(%ebp),%eax
  802d76:	8b 50 08             	mov    0x8(%eax),%edx
  802d79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d7c:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  802d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d82:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802d89:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802d93:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d97:	75 17                	jne    802db0 <insert_sorted_with_merge_freeList+0x557>
  802d99:	83 ec 04             	sub    $0x4,%esp
  802d9c:	68 f4 3a 80 00       	push   $0x803af4
  802da1:	68 67 01 00 00       	push   $0x167
  802da6:	68 17 3b 80 00       	push   $0x803b17
  802dab:	e8 cf d4 ff ff       	call   80027f <_panic>
  802db0:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802db6:	8b 45 08             	mov    0x8(%ebp),%eax
  802db9:	89 10                	mov    %edx,(%eax)
  802dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbe:	8b 00                	mov    (%eax),%eax
  802dc0:	85 c0                	test   %eax,%eax
  802dc2:	74 0d                	je     802dd1 <insert_sorted_with_merge_freeList+0x578>
  802dc4:	a1 48 41 80 00       	mov    0x804148,%eax
  802dc9:	8b 55 08             	mov    0x8(%ebp),%edx
  802dcc:	89 50 04             	mov    %edx,0x4(%eax)
  802dcf:	eb 08                	jmp    802dd9 <insert_sorted_with_merge_freeList+0x580>
  802dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddc:	a3 48 41 80 00       	mov    %eax,0x804148
  802de1:	8b 45 08             	mov    0x8(%ebp),%eax
  802de4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802deb:	a1 54 41 80 00       	mov    0x804154,%eax
  802df0:	40                   	inc    %eax
  802df1:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802df6:	e9 a4 01 00 00       	jmp    802f9f <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfe:	8b 50 08             	mov    0x8(%eax),%edx
  802e01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e04:	8b 40 0c             	mov    0xc(%eax),%eax
  802e07:	01 c2                	add    %eax,%edx
  802e09:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0c:	8b 40 08             	mov    0x8(%eax),%eax
  802e0f:	39 c2                	cmp    %eax,%edx
  802e11:	0f 85 ac 00 00 00    	jne    802ec3 <insert_sorted_with_merge_freeList+0x66a>
  802e17:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1a:	8b 50 08             	mov    0x8(%eax),%edx
  802e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e20:	8b 40 0c             	mov    0xc(%eax),%eax
  802e23:	01 c2                	add    %eax,%edx
  802e25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e28:	8b 40 08             	mov    0x8(%eax),%eax
  802e2b:	39 c2                	cmp    %eax,%edx
  802e2d:	0f 83 90 00 00 00    	jae    802ec3 <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  802e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e36:	8b 50 0c             	mov    0xc(%eax),%edx
  802e39:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e3f:	01 c2                	add    %eax,%edx
  802e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e44:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  802e47:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  802e51:	8b 45 08             	mov    0x8(%ebp),%eax
  802e54:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e5b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e5f:	75 17                	jne    802e78 <insert_sorted_with_merge_freeList+0x61f>
  802e61:	83 ec 04             	sub    $0x4,%esp
  802e64:	68 f4 3a 80 00       	push   $0x803af4
  802e69:	68 70 01 00 00       	push   $0x170
  802e6e:	68 17 3b 80 00       	push   $0x803b17
  802e73:	e8 07 d4 ff ff       	call   80027f <_panic>
  802e78:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e81:	89 10                	mov    %edx,(%eax)
  802e83:	8b 45 08             	mov    0x8(%ebp),%eax
  802e86:	8b 00                	mov    (%eax),%eax
  802e88:	85 c0                	test   %eax,%eax
  802e8a:	74 0d                	je     802e99 <insert_sorted_with_merge_freeList+0x640>
  802e8c:	a1 48 41 80 00       	mov    0x804148,%eax
  802e91:	8b 55 08             	mov    0x8(%ebp),%edx
  802e94:	89 50 04             	mov    %edx,0x4(%eax)
  802e97:	eb 08                	jmp    802ea1 <insert_sorted_with_merge_freeList+0x648>
  802e99:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea4:	a3 48 41 80 00       	mov    %eax,0x804148
  802ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  802eac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eb3:	a1 54 41 80 00       	mov    0x804154,%eax
  802eb8:	40                   	inc    %eax
  802eb9:	a3 54 41 80 00       	mov    %eax,0x804154
	      break;
  802ebe:	e9 dc 00 00 00       	jmp    802f9f <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec6:	8b 50 08             	mov    0x8(%eax),%edx
  802ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecc:	8b 40 0c             	mov    0xc(%eax),%eax
  802ecf:	01 c2                	add    %eax,%edx
  802ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed4:	8b 40 08             	mov    0x8(%eax),%eax
  802ed7:	39 c2                	cmp    %eax,%edx
  802ed9:	0f 83 88 00 00 00    	jae    802f67 <insert_sorted_with_merge_freeList+0x70e>
  802edf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee2:	8b 50 08             	mov    0x8(%eax),%edx
  802ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee8:	8b 40 0c             	mov    0xc(%eax),%eax
  802eeb:	01 c2                	add    %eax,%edx
  802eed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ef0:	8b 40 08             	mov    0x8(%eax),%eax
  802ef3:	39 c2                	cmp    %eax,%edx
  802ef5:	73 70                	jae    802f67 <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  802ef7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802efb:	74 06                	je     802f03 <insert_sorted_with_merge_freeList+0x6aa>
  802efd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f01:	75 17                	jne    802f1a <insert_sorted_with_merge_freeList+0x6c1>
  802f03:	83 ec 04             	sub    $0x4,%esp
  802f06:	68 54 3b 80 00       	push   $0x803b54
  802f0b:	68 75 01 00 00       	push   $0x175
  802f10:	68 17 3b 80 00       	push   $0x803b17
  802f15:	e8 65 d3 ff ff       	call   80027f <_panic>
  802f1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1d:	8b 10                	mov    (%eax),%edx
  802f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f22:	89 10                	mov    %edx,(%eax)
  802f24:	8b 45 08             	mov    0x8(%ebp),%eax
  802f27:	8b 00                	mov    (%eax),%eax
  802f29:	85 c0                	test   %eax,%eax
  802f2b:	74 0b                	je     802f38 <insert_sorted_with_merge_freeList+0x6df>
  802f2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f30:	8b 00                	mov    (%eax),%eax
  802f32:	8b 55 08             	mov    0x8(%ebp),%edx
  802f35:	89 50 04             	mov    %edx,0x4(%eax)
  802f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3b:	8b 55 08             	mov    0x8(%ebp),%edx
  802f3e:	89 10                	mov    %edx,(%eax)
  802f40:	8b 45 08             	mov    0x8(%ebp),%eax
  802f43:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f46:	89 50 04             	mov    %edx,0x4(%eax)
  802f49:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4c:	8b 00                	mov    (%eax),%eax
  802f4e:	85 c0                	test   %eax,%eax
  802f50:	75 08                	jne    802f5a <insert_sorted_with_merge_freeList+0x701>
  802f52:	8b 45 08             	mov    0x8(%ebp),%eax
  802f55:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f5a:	a1 44 41 80 00       	mov    0x804144,%eax
  802f5f:	40                   	inc    %eax
  802f60:	a3 44 41 80 00       	mov    %eax,0x804144
	      break;
  802f65:	eb 38                	jmp    802f9f <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802f67:	a1 40 41 80 00       	mov    0x804140,%eax
  802f6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f73:	74 07                	je     802f7c <insert_sorted_with_merge_freeList+0x723>
  802f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f78:	8b 00                	mov    (%eax),%eax
  802f7a:	eb 05                	jmp    802f81 <insert_sorted_with_merge_freeList+0x728>
  802f7c:	b8 00 00 00 00       	mov    $0x0,%eax
  802f81:	a3 40 41 80 00       	mov    %eax,0x804140
  802f86:	a1 40 41 80 00       	mov    0x804140,%eax
  802f8b:	85 c0                	test   %eax,%eax
  802f8d:	0f 85 c3 fb ff ff    	jne    802b56 <insert_sorted_with_merge_freeList+0x2fd>
  802f93:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f97:	0f 85 b9 fb ff ff    	jne    802b56 <insert_sorted_with_merge_freeList+0x2fd>





}
  802f9d:	eb 00                	jmp    802f9f <insert_sorted_with_merge_freeList+0x746>
  802f9f:	90                   	nop
  802fa0:	c9                   	leave  
  802fa1:	c3                   	ret    
  802fa2:	66 90                	xchg   %ax,%ax

00802fa4 <__udivdi3>:
  802fa4:	55                   	push   %ebp
  802fa5:	57                   	push   %edi
  802fa6:	56                   	push   %esi
  802fa7:	53                   	push   %ebx
  802fa8:	83 ec 1c             	sub    $0x1c,%esp
  802fab:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802faf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802fb3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802fb7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802fbb:	89 ca                	mov    %ecx,%edx
  802fbd:	89 f8                	mov    %edi,%eax
  802fbf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802fc3:	85 f6                	test   %esi,%esi
  802fc5:	75 2d                	jne    802ff4 <__udivdi3+0x50>
  802fc7:	39 cf                	cmp    %ecx,%edi
  802fc9:	77 65                	ja     803030 <__udivdi3+0x8c>
  802fcb:	89 fd                	mov    %edi,%ebp
  802fcd:	85 ff                	test   %edi,%edi
  802fcf:	75 0b                	jne    802fdc <__udivdi3+0x38>
  802fd1:	b8 01 00 00 00       	mov    $0x1,%eax
  802fd6:	31 d2                	xor    %edx,%edx
  802fd8:	f7 f7                	div    %edi
  802fda:	89 c5                	mov    %eax,%ebp
  802fdc:	31 d2                	xor    %edx,%edx
  802fde:	89 c8                	mov    %ecx,%eax
  802fe0:	f7 f5                	div    %ebp
  802fe2:	89 c1                	mov    %eax,%ecx
  802fe4:	89 d8                	mov    %ebx,%eax
  802fe6:	f7 f5                	div    %ebp
  802fe8:	89 cf                	mov    %ecx,%edi
  802fea:	89 fa                	mov    %edi,%edx
  802fec:	83 c4 1c             	add    $0x1c,%esp
  802fef:	5b                   	pop    %ebx
  802ff0:	5e                   	pop    %esi
  802ff1:	5f                   	pop    %edi
  802ff2:	5d                   	pop    %ebp
  802ff3:	c3                   	ret    
  802ff4:	39 ce                	cmp    %ecx,%esi
  802ff6:	77 28                	ja     803020 <__udivdi3+0x7c>
  802ff8:	0f bd fe             	bsr    %esi,%edi
  802ffb:	83 f7 1f             	xor    $0x1f,%edi
  802ffe:	75 40                	jne    803040 <__udivdi3+0x9c>
  803000:	39 ce                	cmp    %ecx,%esi
  803002:	72 0a                	jb     80300e <__udivdi3+0x6a>
  803004:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803008:	0f 87 9e 00 00 00    	ja     8030ac <__udivdi3+0x108>
  80300e:	b8 01 00 00 00       	mov    $0x1,%eax
  803013:	89 fa                	mov    %edi,%edx
  803015:	83 c4 1c             	add    $0x1c,%esp
  803018:	5b                   	pop    %ebx
  803019:	5e                   	pop    %esi
  80301a:	5f                   	pop    %edi
  80301b:	5d                   	pop    %ebp
  80301c:	c3                   	ret    
  80301d:	8d 76 00             	lea    0x0(%esi),%esi
  803020:	31 ff                	xor    %edi,%edi
  803022:	31 c0                	xor    %eax,%eax
  803024:	89 fa                	mov    %edi,%edx
  803026:	83 c4 1c             	add    $0x1c,%esp
  803029:	5b                   	pop    %ebx
  80302a:	5e                   	pop    %esi
  80302b:	5f                   	pop    %edi
  80302c:	5d                   	pop    %ebp
  80302d:	c3                   	ret    
  80302e:	66 90                	xchg   %ax,%ax
  803030:	89 d8                	mov    %ebx,%eax
  803032:	f7 f7                	div    %edi
  803034:	31 ff                	xor    %edi,%edi
  803036:	89 fa                	mov    %edi,%edx
  803038:	83 c4 1c             	add    $0x1c,%esp
  80303b:	5b                   	pop    %ebx
  80303c:	5e                   	pop    %esi
  80303d:	5f                   	pop    %edi
  80303e:	5d                   	pop    %ebp
  80303f:	c3                   	ret    
  803040:	bd 20 00 00 00       	mov    $0x20,%ebp
  803045:	89 eb                	mov    %ebp,%ebx
  803047:	29 fb                	sub    %edi,%ebx
  803049:	89 f9                	mov    %edi,%ecx
  80304b:	d3 e6                	shl    %cl,%esi
  80304d:	89 c5                	mov    %eax,%ebp
  80304f:	88 d9                	mov    %bl,%cl
  803051:	d3 ed                	shr    %cl,%ebp
  803053:	89 e9                	mov    %ebp,%ecx
  803055:	09 f1                	or     %esi,%ecx
  803057:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80305b:	89 f9                	mov    %edi,%ecx
  80305d:	d3 e0                	shl    %cl,%eax
  80305f:	89 c5                	mov    %eax,%ebp
  803061:	89 d6                	mov    %edx,%esi
  803063:	88 d9                	mov    %bl,%cl
  803065:	d3 ee                	shr    %cl,%esi
  803067:	89 f9                	mov    %edi,%ecx
  803069:	d3 e2                	shl    %cl,%edx
  80306b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80306f:	88 d9                	mov    %bl,%cl
  803071:	d3 e8                	shr    %cl,%eax
  803073:	09 c2                	or     %eax,%edx
  803075:	89 d0                	mov    %edx,%eax
  803077:	89 f2                	mov    %esi,%edx
  803079:	f7 74 24 0c          	divl   0xc(%esp)
  80307d:	89 d6                	mov    %edx,%esi
  80307f:	89 c3                	mov    %eax,%ebx
  803081:	f7 e5                	mul    %ebp
  803083:	39 d6                	cmp    %edx,%esi
  803085:	72 19                	jb     8030a0 <__udivdi3+0xfc>
  803087:	74 0b                	je     803094 <__udivdi3+0xf0>
  803089:	89 d8                	mov    %ebx,%eax
  80308b:	31 ff                	xor    %edi,%edi
  80308d:	e9 58 ff ff ff       	jmp    802fea <__udivdi3+0x46>
  803092:	66 90                	xchg   %ax,%ax
  803094:	8b 54 24 08          	mov    0x8(%esp),%edx
  803098:	89 f9                	mov    %edi,%ecx
  80309a:	d3 e2                	shl    %cl,%edx
  80309c:	39 c2                	cmp    %eax,%edx
  80309e:	73 e9                	jae    803089 <__udivdi3+0xe5>
  8030a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8030a3:	31 ff                	xor    %edi,%edi
  8030a5:	e9 40 ff ff ff       	jmp    802fea <__udivdi3+0x46>
  8030aa:	66 90                	xchg   %ax,%ax
  8030ac:	31 c0                	xor    %eax,%eax
  8030ae:	e9 37 ff ff ff       	jmp    802fea <__udivdi3+0x46>
  8030b3:	90                   	nop

008030b4 <__umoddi3>:
  8030b4:	55                   	push   %ebp
  8030b5:	57                   	push   %edi
  8030b6:	56                   	push   %esi
  8030b7:	53                   	push   %ebx
  8030b8:	83 ec 1c             	sub    $0x1c,%esp
  8030bb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8030bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8030c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8030c7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8030cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8030cf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8030d3:	89 f3                	mov    %esi,%ebx
  8030d5:	89 fa                	mov    %edi,%edx
  8030d7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8030db:	89 34 24             	mov    %esi,(%esp)
  8030de:	85 c0                	test   %eax,%eax
  8030e0:	75 1a                	jne    8030fc <__umoddi3+0x48>
  8030e2:	39 f7                	cmp    %esi,%edi
  8030e4:	0f 86 a2 00 00 00    	jbe    80318c <__umoddi3+0xd8>
  8030ea:	89 c8                	mov    %ecx,%eax
  8030ec:	89 f2                	mov    %esi,%edx
  8030ee:	f7 f7                	div    %edi
  8030f0:	89 d0                	mov    %edx,%eax
  8030f2:	31 d2                	xor    %edx,%edx
  8030f4:	83 c4 1c             	add    $0x1c,%esp
  8030f7:	5b                   	pop    %ebx
  8030f8:	5e                   	pop    %esi
  8030f9:	5f                   	pop    %edi
  8030fa:	5d                   	pop    %ebp
  8030fb:	c3                   	ret    
  8030fc:	39 f0                	cmp    %esi,%eax
  8030fe:	0f 87 ac 00 00 00    	ja     8031b0 <__umoddi3+0xfc>
  803104:	0f bd e8             	bsr    %eax,%ebp
  803107:	83 f5 1f             	xor    $0x1f,%ebp
  80310a:	0f 84 ac 00 00 00    	je     8031bc <__umoddi3+0x108>
  803110:	bf 20 00 00 00       	mov    $0x20,%edi
  803115:	29 ef                	sub    %ebp,%edi
  803117:	89 fe                	mov    %edi,%esi
  803119:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80311d:	89 e9                	mov    %ebp,%ecx
  80311f:	d3 e0                	shl    %cl,%eax
  803121:	89 d7                	mov    %edx,%edi
  803123:	89 f1                	mov    %esi,%ecx
  803125:	d3 ef                	shr    %cl,%edi
  803127:	09 c7                	or     %eax,%edi
  803129:	89 e9                	mov    %ebp,%ecx
  80312b:	d3 e2                	shl    %cl,%edx
  80312d:	89 14 24             	mov    %edx,(%esp)
  803130:	89 d8                	mov    %ebx,%eax
  803132:	d3 e0                	shl    %cl,%eax
  803134:	89 c2                	mov    %eax,%edx
  803136:	8b 44 24 08          	mov    0x8(%esp),%eax
  80313a:	d3 e0                	shl    %cl,%eax
  80313c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803140:	8b 44 24 08          	mov    0x8(%esp),%eax
  803144:	89 f1                	mov    %esi,%ecx
  803146:	d3 e8                	shr    %cl,%eax
  803148:	09 d0                	or     %edx,%eax
  80314a:	d3 eb                	shr    %cl,%ebx
  80314c:	89 da                	mov    %ebx,%edx
  80314e:	f7 f7                	div    %edi
  803150:	89 d3                	mov    %edx,%ebx
  803152:	f7 24 24             	mull   (%esp)
  803155:	89 c6                	mov    %eax,%esi
  803157:	89 d1                	mov    %edx,%ecx
  803159:	39 d3                	cmp    %edx,%ebx
  80315b:	0f 82 87 00 00 00    	jb     8031e8 <__umoddi3+0x134>
  803161:	0f 84 91 00 00 00    	je     8031f8 <__umoddi3+0x144>
  803167:	8b 54 24 04          	mov    0x4(%esp),%edx
  80316b:	29 f2                	sub    %esi,%edx
  80316d:	19 cb                	sbb    %ecx,%ebx
  80316f:	89 d8                	mov    %ebx,%eax
  803171:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803175:	d3 e0                	shl    %cl,%eax
  803177:	89 e9                	mov    %ebp,%ecx
  803179:	d3 ea                	shr    %cl,%edx
  80317b:	09 d0                	or     %edx,%eax
  80317d:	89 e9                	mov    %ebp,%ecx
  80317f:	d3 eb                	shr    %cl,%ebx
  803181:	89 da                	mov    %ebx,%edx
  803183:	83 c4 1c             	add    $0x1c,%esp
  803186:	5b                   	pop    %ebx
  803187:	5e                   	pop    %esi
  803188:	5f                   	pop    %edi
  803189:	5d                   	pop    %ebp
  80318a:	c3                   	ret    
  80318b:	90                   	nop
  80318c:	89 fd                	mov    %edi,%ebp
  80318e:	85 ff                	test   %edi,%edi
  803190:	75 0b                	jne    80319d <__umoddi3+0xe9>
  803192:	b8 01 00 00 00       	mov    $0x1,%eax
  803197:	31 d2                	xor    %edx,%edx
  803199:	f7 f7                	div    %edi
  80319b:	89 c5                	mov    %eax,%ebp
  80319d:	89 f0                	mov    %esi,%eax
  80319f:	31 d2                	xor    %edx,%edx
  8031a1:	f7 f5                	div    %ebp
  8031a3:	89 c8                	mov    %ecx,%eax
  8031a5:	f7 f5                	div    %ebp
  8031a7:	89 d0                	mov    %edx,%eax
  8031a9:	e9 44 ff ff ff       	jmp    8030f2 <__umoddi3+0x3e>
  8031ae:	66 90                	xchg   %ax,%ax
  8031b0:	89 c8                	mov    %ecx,%eax
  8031b2:	89 f2                	mov    %esi,%edx
  8031b4:	83 c4 1c             	add    $0x1c,%esp
  8031b7:	5b                   	pop    %ebx
  8031b8:	5e                   	pop    %esi
  8031b9:	5f                   	pop    %edi
  8031ba:	5d                   	pop    %ebp
  8031bb:	c3                   	ret    
  8031bc:	3b 04 24             	cmp    (%esp),%eax
  8031bf:	72 06                	jb     8031c7 <__umoddi3+0x113>
  8031c1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8031c5:	77 0f                	ja     8031d6 <__umoddi3+0x122>
  8031c7:	89 f2                	mov    %esi,%edx
  8031c9:	29 f9                	sub    %edi,%ecx
  8031cb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8031cf:	89 14 24             	mov    %edx,(%esp)
  8031d2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8031d6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8031da:	8b 14 24             	mov    (%esp),%edx
  8031dd:	83 c4 1c             	add    $0x1c,%esp
  8031e0:	5b                   	pop    %ebx
  8031e1:	5e                   	pop    %esi
  8031e2:	5f                   	pop    %edi
  8031e3:	5d                   	pop    %ebp
  8031e4:	c3                   	ret    
  8031e5:	8d 76 00             	lea    0x0(%esi),%esi
  8031e8:	2b 04 24             	sub    (%esp),%eax
  8031eb:	19 fa                	sbb    %edi,%edx
  8031ed:	89 d1                	mov    %edx,%ecx
  8031ef:	89 c6                	mov    %eax,%esi
  8031f1:	e9 71 ff ff ff       	jmp    803167 <__umoddi3+0xb3>
  8031f6:	66 90                	xchg   %ax,%ax
  8031f8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8031fc:	72 ea                	jb     8031e8 <__umoddi3+0x134>
  8031fe:	89 d9                	mov    %ebx,%ecx
  803200:	e9 62 ff ff ff       	jmp    803167 <__umoddi3+0xb3>
