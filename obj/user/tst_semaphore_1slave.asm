
obj/user/tst_semaphore_1slave:     file format elf32-i386


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
  800031:	e8 e0 00 00 00       	call   800116 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Slave program: enter critical section, print it's ID, exit and signal the master program
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	int32 parentenvID = sys_getparentenvid();
  80003e:	e8 32 16 00 00       	call   801675 <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int id = sys_getenvindex();
  800046:	e8 11 16 00 00       	call   80165c <sys_getenvindex>
  80004b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("%d: before the critical section\n", id);
  80004e:	83 ec 08             	sub    $0x8,%esp
  800051:	ff 75 f0             	pushl  -0x10(%ebp)
  800054:	68 20 1c 80 00       	push   $0x801c20
  800059:	e8 a8 04 00 00       	call   800506 <cprintf>
  80005e:	83 c4 10             	add    $0x10,%esp

	sys_waitSemaphore(parentenvID, "cs1") ;
  800061:	83 ec 08             	sub    $0x8,%esp
  800064:	68 41 1c 80 00       	push   $0x801c41
  800069:	ff 75 f4             	pushl  -0xc(%ebp)
  80006c:	e8 a5 14 00 00       	call   801516 <sys_waitSemaphore>
  800071:	83 c4 10             	add    $0x10,%esp
		cprintf("%d: inside the critical section\n", id) ;
  800074:	83 ec 08             	sub    $0x8,%esp
  800077:	ff 75 f0             	pushl  -0x10(%ebp)
  80007a:	68 48 1c 80 00       	push   $0x801c48
  80007f:	e8 82 04 00 00       	call   800506 <cprintf>
  800084:	83 c4 10             	add    $0x10,%esp
		cprintf("my ID is %d\n", id);
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	ff 75 f0             	pushl  -0x10(%ebp)
  80008d:	68 69 1c 80 00       	push   $0x801c69
  800092:	e8 6f 04 00 00       	call   800506 <cprintf>
  800097:	83 c4 10             	add    $0x10,%esp
		int sem1val = sys_getSemaphoreValue(parentenvID, "cs1");
  80009a:	83 ec 08             	sub    $0x8,%esp
  80009d:	68 41 1c 80 00       	push   $0x801c41
  8000a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8000a5:	e8 4f 14 00 00       	call   8014f9 <sys_getSemaphoreValue>
  8000aa:	83 c4 10             	add    $0x10,%esp
  8000ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (sem1val > 0)
  8000b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8000b4:	7e 14                	jle    8000ca <_main+0x92>
			panic("Error: more than 1 process inside the CS... please review your semaphore code again...");
  8000b6:	83 ec 04             	sub    $0x4,%esp
  8000b9:	68 78 1c 80 00       	push   $0x801c78
  8000be:	6a 11                	push   $0x11
  8000c0:	68 cf 1c 80 00       	push   $0x801ccf
  8000c5:	e8 88 01 00 00       	call   800252 <_panic>
		env_sleep(1000) ;
  8000ca:	83 ec 0c             	sub    $0xc,%esp
  8000cd:	68 e8 03 00 00       	push   $0x3e8
  8000d2:	e8 17 18 00 00       	call   8018ee <env_sleep>
  8000d7:	83 c4 10             	add    $0x10,%esp
	sys_signalSemaphore(parentenvID, "cs1") ;
  8000da:	83 ec 08             	sub    $0x8,%esp
  8000dd:	68 41 1c 80 00       	push   $0x801c41
  8000e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8000e5:	e8 4a 14 00 00       	call   801534 <sys_signalSemaphore>
  8000ea:	83 c4 10             	add    $0x10,%esp

	cprintf("%d: after the critical section\n", id);
  8000ed:	83 ec 08             	sub    $0x8,%esp
  8000f0:	ff 75 f0             	pushl  -0x10(%ebp)
  8000f3:	68 ec 1c 80 00       	push   $0x801cec
  8000f8:	e8 09 04 00 00       	call   800506 <cprintf>
  8000fd:	83 c4 10             	add    $0x10,%esp
	sys_signalSemaphore(parentenvID, "depend1") ;
  800100:	83 ec 08             	sub    $0x8,%esp
  800103:	68 0c 1d 80 00       	push   $0x801d0c
  800108:	ff 75 f4             	pushl  -0xc(%ebp)
  80010b:	e8 24 14 00 00       	call   801534 <sys_signalSemaphore>
  800110:	83 c4 10             	add    $0x10,%esp
	return;
  800113:	90                   	nop
}
  800114:	c9                   	leave  
  800115:	c3                   	ret    

00800116 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800116:	55                   	push   %ebp
  800117:	89 e5                	mov    %esp,%ebp
  800119:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80011c:	e8 3b 15 00 00       	call   80165c <sys_getenvindex>
  800121:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800124:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800127:	89 d0                	mov    %edx,%eax
  800129:	c1 e0 03             	shl    $0x3,%eax
  80012c:	01 d0                	add    %edx,%eax
  80012e:	01 c0                	add    %eax,%eax
  800130:	01 d0                	add    %edx,%eax
  800132:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800139:	01 d0                	add    %edx,%eax
  80013b:	c1 e0 04             	shl    $0x4,%eax
  80013e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800143:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800148:	a1 20 30 80 00       	mov    0x803020,%eax
  80014d:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800153:	84 c0                	test   %al,%al
  800155:	74 0f                	je     800166 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800157:	a1 20 30 80 00       	mov    0x803020,%eax
  80015c:	05 5c 05 00 00       	add    $0x55c,%eax
  800161:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800166:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80016a:	7e 0a                	jle    800176 <libmain+0x60>
		binaryname = argv[0];
  80016c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80016f:	8b 00                	mov    (%eax),%eax
  800171:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800176:	83 ec 08             	sub    $0x8,%esp
  800179:	ff 75 0c             	pushl  0xc(%ebp)
  80017c:	ff 75 08             	pushl  0x8(%ebp)
  80017f:	e8 b4 fe ff ff       	call   800038 <_main>
  800184:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800187:	e8 dd 12 00 00       	call   801469 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80018c:	83 ec 0c             	sub    $0xc,%esp
  80018f:	68 2c 1d 80 00       	push   $0x801d2c
  800194:	e8 6d 03 00 00       	call   800506 <cprintf>
  800199:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80019c:	a1 20 30 80 00       	mov    0x803020,%eax
  8001a1:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001a7:	a1 20 30 80 00       	mov    0x803020,%eax
  8001ac:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001b2:	83 ec 04             	sub    $0x4,%esp
  8001b5:	52                   	push   %edx
  8001b6:	50                   	push   %eax
  8001b7:	68 54 1d 80 00       	push   $0x801d54
  8001bc:	e8 45 03 00 00       	call   800506 <cprintf>
  8001c1:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001c4:	a1 20 30 80 00       	mov    0x803020,%eax
  8001c9:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8001cf:	a1 20 30 80 00       	mov    0x803020,%eax
  8001d4:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8001da:	a1 20 30 80 00       	mov    0x803020,%eax
  8001df:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8001e5:	51                   	push   %ecx
  8001e6:	52                   	push   %edx
  8001e7:	50                   	push   %eax
  8001e8:	68 7c 1d 80 00       	push   $0x801d7c
  8001ed:	e8 14 03 00 00       	call   800506 <cprintf>
  8001f2:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001f5:	a1 20 30 80 00       	mov    0x803020,%eax
  8001fa:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800200:	83 ec 08             	sub    $0x8,%esp
  800203:	50                   	push   %eax
  800204:	68 d4 1d 80 00       	push   $0x801dd4
  800209:	e8 f8 02 00 00       	call   800506 <cprintf>
  80020e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800211:	83 ec 0c             	sub    $0xc,%esp
  800214:	68 2c 1d 80 00       	push   $0x801d2c
  800219:	e8 e8 02 00 00       	call   800506 <cprintf>
  80021e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800221:	e8 5d 12 00 00       	call   801483 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800226:	e8 19 00 00 00       	call   800244 <exit>
}
  80022b:	90                   	nop
  80022c:	c9                   	leave  
  80022d:	c3                   	ret    

0080022e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80022e:	55                   	push   %ebp
  80022f:	89 e5                	mov    %esp,%ebp
  800231:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	6a 00                	push   $0x0
  800239:	e8 ea 13 00 00       	call   801628 <sys_destroy_env>
  80023e:	83 c4 10             	add    $0x10,%esp
}
  800241:	90                   	nop
  800242:	c9                   	leave  
  800243:	c3                   	ret    

00800244 <exit>:

void
exit(void)
{
  800244:	55                   	push   %ebp
  800245:	89 e5                	mov    %esp,%ebp
  800247:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80024a:	e8 3f 14 00 00       	call   80168e <sys_exit_env>
}
  80024f:	90                   	nop
  800250:	c9                   	leave  
  800251:	c3                   	ret    

00800252 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800252:	55                   	push   %ebp
  800253:	89 e5                	mov    %esp,%ebp
  800255:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800258:	8d 45 10             	lea    0x10(%ebp),%eax
  80025b:	83 c0 04             	add    $0x4,%eax
  80025e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800261:	a1 5c 31 80 00       	mov    0x80315c,%eax
  800266:	85 c0                	test   %eax,%eax
  800268:	74 16                	je     800280 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80026a:	a1 5c 31 80 00       	mov    0x80315c,%eax
  80026f:	83 ec 08             	sub    $0x8,%esp
  800272:	50                   	push   %eax
  800273:	68 e8 1d 80 00       	push   $0x801de8
  800278:	e8 89 02 00 00       	call   800506 <cprintf>
  80027d:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800280:	a1 00 30 80 00       	mov    0x803000,%eax
  800285:	ff 75 0c             	pushl  0xc(%ebp)
  800288:	ff 75 08             	pushl  0x8(%ebp)
  80028b:	50                   	push   %eax
  80028c:	68 ed 1d 80 00       	push   $0x801ded
  800291:	e8 70 02 00 00       	call   800506 <cprintf>
  800296:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800299:	8b 45 10             	mov    0x10(%ebp),%eax
  80029c:	83 ec 08             	sub    $0x8,%esp
  80029f:	ff 75 f4             	pushl  -0xc(%ebp)
  8002a2:	50                   	push   %eax
  8002a3:	e8 f3 01 00 00       	call   80049b <vcprintf>
  8002a8:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002ab:	83 ec 08             	sub    $0x8,%esp
  8002ae:	6a 00                	push   $0x0
  8002b0:	68 09 1e 80 00       	push   $0x801e09
  8002b5:	e8 e1 01 00 00       	call   80049b <vcprintf>
  8002ba:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002bd:	e8 82 ff ff ff       	call   800244 <exit>

	// should not return here
	while (1) ;
  8002c2:	eb fe                	jmp    8002c2 <_panic+0x70>

008002c4 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002c4:	55                   	push   %ebp
  8002c5:	89 e5                	mov    %esp,%ebp
  8002c7:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002ca:	a1 20 30 80 00       	mov    0x803020,%eax
  8002cf:	8b 50 74             	mov    0x74(%eax),%edx
  8002d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d5:	39 c2                	cmp    %eax,%edx
  8002d7:	74 14                	je     8002ed <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002d9:	83 ec 04             	sub    $0x4,%esp
  8002dc:	68 0c 1e 80 00       	push   $0x801e0c
  8002e1:	6a 26                	push   $0x26
  8002e3:	68 58 1e 80 00       	push   $0x801e58
  8002e8:	e8 65 ff ff ff       	call   800252 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8002ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8002f4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8002fb:	e9 c2 00 00 00       	jmp    8003c2 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800300:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800303:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80030a:	8b 45 08             	mov    0x8(%ebp),%eax
  80030d:	01 d0                	add    %edx,%eax
  80030f:	8b 00                	mov    (%eax),%eax
  800311:	85 c0                	test   %eax,%eax
  800313:	75 08                	jne    80031d <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800315:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800318:	e9 a2 00 00 00       	jmp    8003bf <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80031d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800324:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80032b:	eb 69                	jmp    800396 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80032d:	a1 20 30 80 00       	mov    0x803020,%eax
  800332:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800338:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80033b:	89 d0                	mov    %edx,%eax
  80033d:	01 c0                	add    %eax,%eax
  80033f:	01 d0                	add    %edx,%eax
  800341:	c1 e0 03             	shl    $0x3,%eax
  800344:	01 c8                	add    %ecx,%eax
  800346:	8a 40 04             	mov    0x4(%eax),%al
  800349:	84 c0                	test   %al,%al
  80034b:	75 46                	jne    800393 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80034d:	a1 20 30 80 00       	mov    0x803020,%eax
  800352:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800358:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80035b:	89 d0                	mov    %edx,%eax
  80035d:	01 c0                	add    %eax,%eax
  80035f:	01 d0                	add    %edx,%eax
  800361:	c1 e0 03             	shl    $0x3,%eax
  800364:	01 c8                	add    %ecx,%eax
  800366:	8b 00                	mov    (%eax),%eax
  800368:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80036b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80036e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800373:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800375:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800378:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80037f:	8b 45 08             	mov    0x8(%ebp),%eax
  800382:	01 c8                	add    %ecx,%eax
  800384:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800386:	39 c2                	cmp    %eax,%edx
  800388:	75 09                	jne    800393 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80038a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800391:	eb 12                	jmp    8003a5 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800393:	ff 45 e8             	incl   -0x18(%ebp)
  800396:	a1 20 30 80 00       	mov    0x803020,%eax
  80039b:	8b 50 74             	mov    0x74(%eax),%edx
  80039e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003a1:	39 c2                	cmp    %eax,%edx
  8003a3:	77 88                	ja     80032d <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003a5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003a9:	75 14                	jne    8003bf <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003ab:	83 ec 04             	sub    $0x4,%esp
  8003ae:	68 64 1e 80 00       	push   $0x801e64
  8003b3:	6a 3a                	push   $0x3a
  8003b5:	68 58 1e 80 00       	push   $0x801e58
  8003ba:	e8 93 fe ff ff       	call   800252 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003bf:	ff 45 f0             	incl   -0x10(%ebp)
  8003c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003c5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003c8:	0f 8c 32 ff ff ff    	jl     800300 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003ce:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003d5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003dc:	eb 26                	jmp    800404 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8003de:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e3:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003e9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003ec:	89 d0                	mov    %edx,%eax
  8003ee:	01 c0                	add    %eax,%eax
  8003f0:	01 d0                	add    %edx,%eax
  8003f2:	c1 e0 03             	shl    $0x3,%eax
  8003f5:	01 c8                	add    %ecx,%eax
  8003f7:	8a 40 04             	mov    0x4(%eax),%al
  8003fa:	3c 01                	cmp    $0x1,%al
  8003fc:	75 03                	jne    800401 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8003fe:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800401:	ff 45 e0             	incl   -0x20(%ebp)
  800404:	a1 20 30 80 00       	mov    0x803020,%eax
  800409:	8b 50 74             	mov    0x74(%eax),%edx
  80040c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80040f:	39 c2                	cmp    %eax,%edx
  800411:	77 cb                	ja     8003de <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800413:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800416:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800419:	74 14                	je     80042f <CheckWSWithoutLastIndex+0x16b>
		panic(
  80041b:	83 ec 04             	sub    $0x4,%esp
  80041e:	68 b8 1e 80 00       	push   $0x801eb8
  800423:	6a 44                	push   $0x44
  800425:	68 58 1e 80 00       	push   $0x801e58
  80042a:	e8 23 fe ff ff       	call   800252 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80042f:	90                   	nop
  800430:	c9                   	leave  
  800431:	c3                   	ret    

00800432 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800432:	55                   	push   %ebp
  800433:	89 e5                	mov    %esp,%ebp
  800435:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800438:	8b 45 0c             	mov    0xc(%ebp),%eax
  80043b:	8b 00                	mov    (%eax),%eax
  80043d:	8d 48 01             	lea    0x1(%eax),%ecx
  800440:	8b 55 0c             	mov    0xc(%ebp),%edx
  800443:	89 0a                	mov    %ecx,(%edx)
  800445:	8b 55 08             	mov    0x8(%ebp),%edx
  800448:	88 d1                	mov    %dl,%cl
  80044a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80044d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800451:	8b 45 0c             	mov    0xc(%ebp),%eax
  800454:	8b 00                	mov    (%eax),%eax
  800456:	3d ff 00 00 00       	cmp    $0xff,%eax
  80045b:	75 2c                	jne    800489 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80045d:	a0 24 30 80 00       	mov    0x803024,%al
  800462:	0f b6 c0             	movzbl %al,%eax
  800465:	8b 55 0c             	mov    0xc(%ebp),%edx
  800468:	8b 12                	mov    (%edx),%edx
  80046a:	89 d1                	mov    %edx,%ecx
  80046c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80046f:	83 c2 08             	add    $0x8,%edx
  800472:	83 ec 04             	sub    $0x4,%esp
  800475:	50                   	push   %eax
  800476:	51                   	push   %ecx
  800477:	52                   	push   %edx
  800478:	e8 3e 0e 00 00       	call   8012bb <sys_cputs>
  80047d:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800480:	8b 45 0c             	mov    0xc(%ebp),%eax
  800483:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800489:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048c:	8b 40 04             	mov    0x4(%eax),%eax
  80048f:	8d 50 01             	lea    0x1(%eax),%edx
  800492:	8b 45 0c             	mov    0xc(%ebp),%eax
  800495:	89 50 04             	mov    %edx,0x4(%eax)
}
  800498:	90                   	nop
  800499:	c9                   	leave  
  80049a:	c3                   	ret    

0080049b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80049b:	55                   	push   %ebp
  80049c:	89 e5                	mov    %esp,%ebp
  80049e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004a4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004ab:	00 00 00 
	b.cnt = 0;
  8004ae:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004b5:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004b8:	ff 75 0c             	pushl  0xc(%ebp)
  8004bb:	ff 75 08             	pushl  0x8(%ebp)
  8004be:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004c4:	50                   	push   %eax
  8004c5:	68 32 04 80 00       	push   $0x800432
  8004ca:	e8 11 02 00 00       	call   8006e0 <vprintfmt>
  8004cf:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004d2:	a0 24 30 80 00       	mov    0x803024,%al
  8004d7:	0f b6 c0             	movzbl %al,%eax
  8004da:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8004e0:	83 ec 04             	sub    $0x4,%esp
  8004e3:	50                   	push   %eax
  8004e4:	52                   	push   %edx
  8004e5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004eb:	83 c0 08             	add    $0x8,%eax
  8004ee:	50                   	push   %eax
  8004ef:	e8 c7 0d 00 00       	call   8012bb <sys_cputs>
  8004f4:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8004f7:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8004fe:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800504:	c9                   	leave  
  800505:	c3                   	ret    

00800506 <cprintf>:

int cprintf(const char *fmt, ...) {
  800506:	55                   	push   %ebp
  800507:	89 e5                	mov    %esp,%ebp
  800509:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80050c:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800513:	8d 45 0c             	lea    0xc(%ebp),%eax
  800516:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800519:	8b 45 08             	mov    0x8(%ebp),%eax
  80051c:	83 ec 08             	sub    $0x8,%esp
  80051f:	ff 75 f4             	pushl  -0xc(%ebp)
  800522:	50                   	push   %eax
  800523:	e8 73 ff ff ff       	call   80049b <vcprintf>
  800528:	83 c4 10             	add    $0x10,%esp
  80052b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80052e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800531:	c9                   	leave  
  800532:	c3                   	ret    

00800533 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800533:	55                   	push   %ebp
  800534:	89 e5                	mov    %esp,%ebp
  800536:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800539:	e8 2b 0f 00 00       	call   801469 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80053e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800541:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800544:	8b 45 08             	mov    0x8(%ebp),%eax
  800547:	83 ec 08             	sub    $0x8,%esp
  80054a:	ff 75 f4             	pushl  -0xc(%ebp)
  80054d:	50                   	push   %eax
  80054e:	e8 48 ff ff ff       	call   80049b <vcprintf>
  800553:	83 c4 10             	add    $0x10,%esp
  800556:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800559:	e8 25 0f 00 00       	call   801483 <sys_enable_interrupt>
	return cnt;
  80055e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800561:	c9                   	leave  
  800562:	c3                   	ret    

00800563 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800563:	55                   	push   %ebp
  800564:	89 e5                	mov    %esp,%ebp
  800566:	53                   	push   %ebx
  800567:	83 ec 14             	sub    $0x14,%esp
  80056a:	8b 45 10             	mov    0x10(%ebp),%eax
  80056d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800570:	8b 45 14             	mov    0x14(%ebp),%eax
  800573:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800576:	8b 45 18             	mov    0x18(%ebp),%eax
  800579:	ba 00 00 00 00       	mov    $0x0,%edx
  80057e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800581:	77 55                	ja     8005d8 <printnum+0x75>
  800583:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800586:	72 05                	jb     80058d <printnum+0x2a>
  800588:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80058b:	77 4b                	ja     8005d8 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80058d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800590:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800593:	8b 45 18             	mov    0x18(%ebp),%eax
  800596:	ba 00 00 00 00       	mov    $0x0,%edx
  80059b:	52                   	push   %edx
  80059c:	50                   	push   %eax
  80059d:	ff 75 f4             	pushl  -0xc(%ebp)
  8005a0:	ff 75 f0             	pushl  -0x10(%ebp)
  8005a3:	e8 fc 13 00 00       	call   8019a4 <__udivdi3>
  8005a8:	83 c4 10             	add    $0x10,%esp
  8005ab:	83 ec 04             	sub    $0x4,%esp
  8005ae:	ff 75 20             	pushl  0x20(%ebp)
  8005b1:	53                   	push   %ebx
  8005b2:	ff 75 18             	pushl  0x18(%ebp)
  8005b5:	52                   	push   %edx
  8005b6:	50                   	push   %eax
  8005b7:	ff 75 0c             	pushl  0xc(%ebp)
  8005ba:	ff 75 08             	pushl  0x8(%ebp)
  8005bd:	e8 a1 ff ff ff       	call   800563 <printnum>
  8005c2:	83 c4 20             	add    $0x20,%esp
  8005c5:	eb 1a                	jmp    8005e1 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005c7:	83 ec 08             	sub    $0x8,%esp
  8005ca:	ff 75 0c             	pushl  0xc(%ebp)
  8005cd:	ff 75 20             	pushl  0x20(%ebp)
  8005d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d3:	ff d0                	call   *%eax
  8005d5:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005d8:	ff 4d 1c             	decl   0x1c(%ebp)
  8005db:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8005df:	7f e6                	jg     8005c7 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005e1:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8005e4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005ef:	53                   	push   %ebx
  8005f0:	51                   	push   %ecx
  8005f1:	52                   	push   %edx
  8005f2:	50                   	push   %eax
  8005f3:	e8 bc 14 00 00       	call   801ab4 <__umoddi3>
  8005f8:	83 c4 10             	add    $0x10,%esp
  8005fb:	05 34 21 80 00       	add    $0x802134,%eax
  800600:	8a 00                	mov    (%eax),%al
  800602:	0f be c0             	movsbl %al,%eax
  800605:	83 ec 08             	sub    $0x8,%esp
  800608:	ff 75 0c             	pushl  0xc(%ebp)
  80060b:	50                   	push   %eax
  80060c:	8b 45 08             	mov    0x8(%ebp),%eax
  80060f:	ff d0                	call   *%eax
  800611:	83 c4 10             	add    $0x10,%esp
}
  800614:	90                   	nop
  800615:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800618:	c9                   	leave  
  800619:	c3                   	ret    

0080061a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80061a:	55                   	push   %ebp
  80061b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80061d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800621:	7e 1c                	jle    80063f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800623:	8b 45 08             	mov    0x8(%ebp),%eax
  800626:	8b 00                	mov    (%eax),%eax
  800628:	8d 50 08             	lea    0x8(%eax),%edx
  80062b:	8b 45 08             	mov    0x8(%ebp),%eax
  80062e:	89 10                	mov    %edx,(%eax)
  800630:	8b 45 08             	mov    0x8(%ebp),%eax
  800633:	8b 00                	mov    (%eax),%eax
  800635:	83 e8 08             	sub    $0x8,%eax
  800638:	8b 50 04             	mov    0x4(%eax),%edx
  80063b:	8b 00                	mov    (%eax),%eax
  80063d:	eb 40                	jmp    80067f <getuint+0x65>
	else if (lflag)
  80063f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800643:	74 1e                	je     800663 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800645:	8b 45 08             	mov    0x8(%ebp),%eax
  800648:	8b 00                	mov    (%eax),%eax
  80064a:	8d 50 04             	lea    0x4(%eax),%edx
  80064d:	8b 45 08             	mov    0x8(%ebp),%eax
  800650:	89 10                	mov    %edx,(%eax)
  800652:	8b 45 08             	mov    0x8(%ebp),%eax
  800655:	8b 00                	mov    (%eax),%eax
  800657:	83 e8 04             	sub    $0x4,%eax
  80065a:	8b 00                	mov    (%eax),%eax
  80065c:	ba 00 00 00 00       	mov    $0x0,%edx
  800661:	eb 1c                	jmp    80067f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800663:	8b 45 08             	mov    0x8(%ebp),%eax
  800666:	8b 00                	mov    (%eax),%eax
  800668:	8d 50 04             	lea    0x4(%eax),%edx
  80066b:	8b 45 08             	mov    0x8(%ebp),%eax
  80066e:	89 10                	mov    %edx,(%eax)
  800670:	8b 45 08             	mov    0x8(%ebp),%eax
  800673:	8b 00                	mov    (%eax),%eax
  800675:	83 e8 04             	sub    $0x4,%eax
  800678:	8b 00                	mov    (%eax),%eax
  80067a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80067f:	5d                   	pop    %ebp
  800680:	c3                   	ret    

00800681 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800681:	55                   	push   %ebp
  800682:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800684:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800688:	7e 1c                	jle    8006a6 <getint+0x25>
		return va_arg(*ap, long long);
  80068a:	8b 45 08             	mov    0x8(%ebp),%eax
  80068d:	8b 00                	mov    (%eax),%eax
  80068f:	8d 50 08             	lea    0x8(%eax),%edx
  800692:	8b 45 08             	mov    0x8(%ebp),%eax
  800695:	89 10                	mov    %edx,(%eax)
  800697:	8b 45 08             	mov    0x8(%ebp),%eax
  80069a:	8b 00                	mov    (%eax),%eax
  80069c:	83 e8 08             	sub    $0x8,%eax
  80069f:	8b 50 04             	mov    0x4(%eax),%edx
  8006a2:	8b 00                	mov    (%eax),%eax
  8006a4:	eb 38                	jmp    8006de <getint+0x5d>
	else if (lflag)
  8006a6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006aa:	74 1a                	je     8006c6 <getint+0x45>
		return va_arg(*ap, long);
  8006ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8006af:	8b 00                	mov    (%eax),%eax
  8006b1:	8d 50 04             	lea    0x4(%eax),%edx
  8006b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b7:	89 10                	mov    %edx,(%eax)
  8006b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bc:	8b 00                	mov    (%eax),%eax
  8006be:	83 e8 04             	sub    $0x4,%eax
  8006c1:	8b 00                	mov    (%eax),%eax
  8006c3:	99                   	cltd   
  8006c4:	eb 18                	jmp    8006de <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c9:	8b 00                	mov    (%eax),%eax
  8006cb:	8d 50 04             	lea    0x4(%eax),%edx
  8006ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d1:	89 10                	mov    %edx,(%eax)
  8006d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d6:	8b 00                	mov    (%eax),%eax
  8006d8:	83 e8 04             	sub    $0x4,%eax
  8006db:	8b 00                	mov    (%eax),%eax
  8006dd:	99                   	cltd   
}
  8006de:	5d                   	pop    %ebp
  8006df:	c3                   	ret    

008006e0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006e0:	55                   	push   %ebp
  8006e1:	89 e5                	mov    %esp,%ebp
  8006e3:	56                   	push   %esi
  8006e4:	53                   	push   %ebx
  8006e5:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006e8:	eb 17                	jmp    800701 <vprintfmt+0x21>
			if (ch == '\0')
  8006ea:	85 db                	test   %ebx,%ebx
  8006ec:	0f 84 af 03 00 00    	je     800aa1 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8006f2:	83 ec 08             	sub    $0x8,%esp
  8006f5:	ff 75 0c             	pushl  0xc(%ebp)
  8006f8:	53                   	push   %ebx
  8006f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fc:	ff d0                	call   *%eax
  8006fe:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800701:	8b 45 10             	mov    0x10(%ebp),%eax
  800704:	8d 50 01             	lea    0x1(%eax),%edx
  800707:	89 55 10             	mov    %edx,0x10(%ebp)
  80070a:	8a 00                	mov    (%eax),%al
  80070c:	0f b6 d8             	movzbl %al,%ebx
  80070f:	83 fb 25             	cmp    $0x25,%ebx
  800712:	75 d6                	jne    8006ea <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800714:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800718:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80071f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800726:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80072d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800734:	8b 45 10             	mov    0x10(%ebp),%eax
  800737:	8d 50 01             	lea    0x1(%eax),%edx
  80073a:	89 55 10             	mov    %edx,0x10(%ebp)
  80073d:	8a 00                	mov    (%eax),%al
  80073f:	0f b6 d8             	movzbl %al,%ebx
  800742:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800745:	83 f8 55             	cmp    $0x55,%eax
  800748:	0f 87 2b 03 00 00    	ja     800a79 <vprintfmt+0x399>
  80074e:	8b 04 85 58 21 80 00 	mov    0x802158(,%eax,4),%eax
  800755:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800757:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80075b:	eb d7                	jmp    800734 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80075d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800761:	eb d1                	jmp    800734 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800763:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80076a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80076d:	89 d0                	mov    %edx,%eax
  80076f:	c1 e0 02             	shl    $0x2,%eax
  800772:	01 d0                	add    %edx,%eax
  800774:	01 c0                	add    %eax,%eax
  800776:	01 d8                	add    %ebx,%eax
  800778:	83 e8 30             	sub    $0x30,%eax
  80077b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80077e:	8b 45 10             	mov    0x10(%ebp),%eax
  800781:	8a 00                	mov    (%eax),%al
  800783:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800786:	83 fb 2f             	cmp    $0x2f,%ebx
  800789:	7e 3e                	jle    8007c9 <vprintfmt+0xe9>
  80078b:	83 fb 39             	cmp    $0x39,%ebx
  80078e:	7f 39                	jg     8007c9 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800790:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800793:	eb d5                	jmp    80076a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800795:	8b 45 14             	mov    0x14(%ebp),%eax
  800798:	83 c0 04             	add    $0x4,%eax
  80079b:	89 45 14             	mov    %eax,0x14(%ebp)
  80079e:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a1:	83 e8 04             	sub    $0x4,%eax
  8007a4:	8b 00                	mov    (%eax),%eax
  8007a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007a9:	eb 1f                	jmp    8007ca <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007ab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007af:	79 83                	jns    800734 <vprintfmt+0x54>
				width = 0;
  8007b1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007b8:	e9 77 ff ff ff       	jmp    800734 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007bd:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007c4:	e9 6b ff ff ff       	jmp    800734 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007c9:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ce:	0f 89 60 ff ff ff    	jns    800734 <vprintfmt+0x54>
				width = precision, precision = -1;
  8007d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007da:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8007e1:	e9 4e ff ff ff       	jmp    800734 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007e6:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8007e9:	e9 46 ff ff ff       	jmp    800734 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8007ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f1:	83 c0 04             	add    $0x4,%eax
  8007f4:	89 45 14             	mov    %eax,0x14(%ebp)
  8007f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fa:	83 e8 04             	sub    $0x4,%eax
  8007fd:	8b 00                	mov    (%eax),%eax
  8007ff:	83 ec 08             	sub    $0x8,%esp
  800802:	ff 75 0c             	pushl  0xc(%ebp)
  800805:	50                   	push   %eax
  800806:	8b 45 08             	mov    0x8(%ebp),%eax
  800809:	ff d0                	call   *%eax
  80080b:	83 c4 10             	add    $0x10,%esp
			break;
  80080e:	e9 89 02 00 00       	jmp    800a9c <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800813:	8b 45 14             	mov    0x14(%ebp),%eax
  800816:	83 c0 04             	add    $0x4,%eax
  800819:	89 45 14             	mov    %eax,0x14(%ebp)
  80081c:	8b 45 14             	mov    0x14(%ebp),%eax
  80081f:	83 e8 04             	sub    $0x4,%eax
  800822:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800824:	85 db                	test   %ebx,%ebx
  800826:	79 02                	jns    80082a <vprintfmt+0x14a>
				err = -err;
  800828:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80082a:	83 fb 64             	cmp    $0x64,%ebx
  80082d:	7f 0b                	jg     80083a <vprintfmt+0x15a>
  80082f:	8b 34 9d a0 1f 80 00 	mov    0x801fa0(,%ebx,4),%esi
  800836:	85 f6                	test   %esi,%esi
  800838:	75 19                	jne    800853 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80083a:	53                   	push   %ebx
  80083b:	68 45 21 80 00       	push   $0x802145
  800840:	ff 75 0c             	pushl  0xc(%ebp)
  800843:	ff 75 08             	pushl  0x8(%ebp)
  800846:	e8 5e 02 00 00       	call   800aa9 <printfmt>
  80084b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80084e:	e9 49 02 00 00       	jmp    800a9c <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800853:	56                   	push   %esi
  800854:	68 4e 21 80 00       	push   $0x80214e
  800859:	ff 75 0c             	pushl  0xc(%ebp)
  80085c:	ff 75 08             	pushl  0x8(%ebp)
  80085f:	e8 45 02 00 00       	call   800aa9 <printfmt>
  800864:	83 c4 10             	add    $0x10,%esp
			break;
  800867:	e9 30 02 00 00       	jmp    800a9c <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80086c:	8b 45 14             	mov    0x14(%ebp),%eax
  80086f:	83 c0 04             	add    $0x4,%eax
  800872:	89 45 14             	mov    %eax,0x14(%ebp)
  800875:	8b 45 14             	mov    0x14(%ebp),%eax
  800878:	83 e8 04             	sub    $0x4,%eax
  80087b:	8b 30                	mov    (%eax),%esi
  80087d:	85 f6                	test   %esi,%esi
  80087f:	75 05                	jne    800886 <vprintfmt+0x1a6>
				p = "(null)";
  800881:	be 51 21 80 00       	mov    $0x802151,%esi
			if (width > 0 && padc != '-')
  800886:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80088a:	7e 6d                	jle    8008f9 <vprintfmt+0x219>
  80088c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800890:	74 67                	je     8008f9 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800892:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800895:	83 ec 08             	sub    $0x8,%esp
  800898:	50                   	push   %eax
  800899:	56                   	push   %esi
  80089a:	e8 0c 03 00 00       	call   800bab <strnlen>
  80089f:	83 c4 10             	add    $0x10,%esp
  8008a2:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008a5:	eb 16                	jmp    8008bd <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008a7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008ab:	83 ec 08             	sub    $0x8,%esp
  8008ae:	ff 75 0c             	pushl  0xc(%ebp)
  8008b1:	50                   	push   %eax
  8008b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b5:	ff d0                	call   *%eax
  8008b7:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008ba:	ff 4d e4             	decl   -0x1c(%ebp)
  8008bd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008c1:	7f e4                	jg     8008a7 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008c3:	eb 34                	jmp    8008f9 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008c5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008c9:	74 1c                	je     8008e7 <vprintfmt+0x207>
  8008cb:	83 fb 1f             	cmp    $0x1f,%ebx
  8008ce:	7e 05                	jle    8008d5 <vprintfmt+0x1f5>
  8008d0:	83 fb 7e             	cmp    $0x7e,%ebx
  8008d3:	7e 12                	jle    8008e7 <vprintfmt+0x207>
					putch('?', putdat);
  8008d5:	83 ec 08             	sub    $0x8,%esp
  8008d8:	ff 75 0c             	pushl  0xc(%ebp)
  8008db:	6a 3f                	push   $0x3f
  8008dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e0:	ff d0                	call   *%eax
  8008e2:	83 c4 10             	add    $0x10,%esp
  8008e5:	eb 0f                	jmp    8008f6 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8008e7:	83 ec 08             	sub    $0x8,%esp
  8008ea:	ff 75 0c             	pushl  0xc(%ebp)
  8008ed:	53                   	push   %ebx
  8008ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f1:	ff d0                	call   *%eax
  8008f3:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008f6:	ff 4d e4             	decl   -0x1c(%ebp)
  8008f9:	89 f0                	mov    %esi,%eax
  8008fb:	8d 70 01             	lea    0x1(%eax),%esi
  8008fe:	8a 00                	mov    (%eax),%al
  800900:	0f be d8             	movsbl %al,%ebx
  800903:	85 db                	test   %ebx,%ebx
  800905:	74 24                	je     80092b <vprintfmt+0x24b>
  800907:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80090b:	78 b8                	js     8008c5 <vprintfmt+0x1e5>
  80090d:	ff 4d e0             	decl   -0x20(%ebp)
  800910:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800914:	79 af                	jns    8008c5 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800916:	eb 13                	jmp    80092b <vprintfmt+0x24b>
				putch(' ', putdat);
  800918:	83 ec 08             	sub    $0x8,%esp
  80091b:	ff 75 0c             	pushl  0xc(%ebp)
  80091e:	6a 20                	push   $0x20
  800920:	8b 45 08             	mov    0x8(%ebp),%eax
  800923:	ff d0                	call   *%eax
  800925:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800928:	ff 4d e4             	decl   -0x1c(%ebp)
  80092b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80092f:	7f e7                	jg     800918 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800931:	e9 66 01 00 00       	jmp    800a9c <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800936:	83 ec 08             	sub    $0x8,%esp
  800939:	ff 75 e8             	pushl  -0x18(%ebp)
  80093c:	8d 45 14             	lea    0x14(%ebp),%eax
  80093f:	50                   	push   %eax
  800940:	e8 3c fd ff ff       	call   800681 <getint>
  800945:	83 c4 10             	add    $0x10,%esp
  800948:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80094b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80094e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800951:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800954:	85 d2                	test   %edx,%edx
  800956:	79 23                	jns    80097b <vprintfmt+0x29b>
				putch('-', putdat);
  800958:	83 ec 08             	sub    $0x8,%esp
  80095b:	ff 75 0c             	pushl  0xc(%ebp)
  80095e:	6a 2d                	push   $0x2d
  800960:	8b 45 08             	mov    0x8(%ebp),%eax
  800963:	ff d0                	call   *%eax
  800965:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800968:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80096b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80096e:	f7 d8                	neg    %eax
  800970:	83 d2 00             	adc    $0x0,%edx
  800973:	f7 da                	neg    %edx
  800975:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800978:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80097b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800982:	e9 bc 00 00 00       	jmp    800a43 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800987:	83 ec 08             	sub    $0x8,%esp
  80098a:	ff 75 e8             	pushl  -0x18(%ebp)
  80098d:	8d 45 14             	lea    0x14(%ebp),%eax
  800990:	50                   	push   %eax
  800991:	e8 84 fc ff ff       	call   80061a <getuint>
  800996:	83 c4 10             	add    $0x10,%esp
  800999:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80099c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80099f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009a6:	e9 98 00 00 00       	jmp    800a43 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009ab:	83 ec 08             	sub    $0x8,%esp
  8009ae:	ff 75 0c             	pushl  0xc(%ebp)
  8009b1:	6a 58                	push   $0x58
  8009b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b6:	ff d0                	call   *%eax
  8009b8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009bb:	83 ec 08             	sub    $0x8,%esp
  8009be:	ff 75 0c             	pushl  0xc(%ebp)
  8009c1:	6a 58                	push   $0x58
  8009c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c6:	ff d0                	call   *%eax
  8009c8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009cb:	83 ec 08             	sub    $0x8,%esp
  8009ce:	ff 75 0c             	pushl  0xc(%ebp)
  8009d1:	6a 58                	push   $0x58
  8009d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d6:	ff d0                	call   *%eax
  8009d8:	83 c4 10             	add    $0x10,%esp
			break;
  8009db:	e9 bc 00 00 00       	jmp    800a9c <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8009e0:	83 ec 08             	sub    $0x8,%esp
  8009e3:	ff 75 0c             	pushl  0xc(%ebp)
  8009e6:	6a 30                	push   $0x30
  8009e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009eb:	ff d0                	call   *%eax
  8009ed:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8009f0:	83 ec 08             	sub    $0x8,%esp
  8009f3:	ff 75 0c             	pushl  0xc(%ebp)
  8009f6:	6a 78                	push   $0x78
  8009f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fb:	ff d0                	call   *%eax
  8009fd:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a00:	8b 45 14             	mov    0x14(%ebp),%eax
  800a03:	83 c0 04             	add    $0x4,%eax
  800a06:	89 45 14             	mov    %eax,0x14(%ebp)
  800a09:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0c:	83 e8 04             	sub    $0x4,%eax
  800a0f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a11:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a14:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a1b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a22:	eb 1f                	jmp    800a43 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a24:	83 ec 08             	sub    $0x8,%esp
  800a27:	ff 75 e8             	pushl  -0x18(%ebp)
  800a2a:	8d 45 14             	lea    0x14(%ebp),%eax
  800a2d:	50                   	push   %eax
  800a2e:	e8 e7 fb ff ff       	call   80061a <getuint>
  800a33:	83 c4 10             	add    $0x10,%esp
  800a36:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a39:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a3c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a43:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a4a:	83 ec 04             	sub    $0x4,%esp
  800a4d:	52                   	push   %edx
  800a4e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a51:	50                   	push   %eax
  800a52:	ff 75 f4             	pushl  -0xc(%ebp)
  800a55:	ff 75 f0             	pushl  -0x10(%ebp)
  800a58:	ff 75 0c             	pushl  0xc(%ebp)
  800a5b:	ff 75 08             	pushl  0x8(%ebp)
  800a5e:	e8 00 fb ff ff       	call   800563 <printnum>
  800a63:	83 c4 20             	add    $0x20,%esp
			break;
  800a66:	eb 34                	jmp    800a9c <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a68:	83 ec 08             	sub    $0x8,%esp
  800a6b:	ff 75 0c             	pushl  0xc(%ebp)
  800a6e:	53                   	push   %ebx
  800a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a72:	ff d0                	call   *%eax
  800a74:	83 c4 10             	add    $0x10,%esp
			break;
  800a77:	eb 23                	jmp    800a9c <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a79:	83 ec 08             	sub    $0x8,%esp
  800a7c:	ff 75 0c             	pushl  0xc(%ebp)
  800a7f:	6a 25                	push   $0x25
  800a81:	8b 45 08             	mov    0x8(%ebp),%eax
  800a84:	ff d0                	call   *%eax
  800a86:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a89:	ff 4d 10             	decl   0x10(%ebp)
  800a8c:	eb 03                	jmp    800a91 <vprintfmt+0x3b1>
  800a8e:	ff 4d 10             	decl   0x10(%ebp)
  800a91:	8b 45 10             	mov    0x10(%ebp),%eax
  800a94:	48                   	dec    %eax
  800a95:	8a 00                	mov    (%eax),%al
  800a97:	3c 25                	cmp    $0x25,%al
  800a99:	75 f3                	jne    800a8e <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800a9b:	90                   	nop
		}
	}
  800a9c:	e9 47 fc ff ff       	jmp    8006e8 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800aa1:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800aa2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800aa5:	5b                   	pop    %ebx
  800aa6:	5e                   	pop    %esi
  800aa7:	5d                   	pop    %ebp
  800aa8:	c3                   	ret    

00800aa9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800aa9:	55                   	push   %ebp
  800aaa:	89 e5                	mov    %esp,%ebp
  800aac:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800aaf:	8d 45 10             	lea    0x10(%ebp),%eax
  800ab2:	83 c0 04             	add    $0x4,%eax
  800ab5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ab8:	8b 45 10             	mov    0x10(%ebp),%eax
  800abb:	ff 75 f4             	pushl  -0xc(%ebp)
  800abe:	50                   	push   %eax
  800abf:	ff 75 0c             	pushl  0xc(%ebp)
  800ac2:	ff 75 08             	pushl  0x8(%ebp)
  800ac5:	e8 16 fc ff ff       	call   8006e0 <vprintfmt>
  800aca:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800acd:	90                   	nop
  800ace:	c9                   	leave  
  800acf:	c3                   	ret    

00800ad0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ad0:	55                   	push   %ebp
  800ad1:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800ad3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad6:	8b 40 08             	mov    0x8(%eax),%eax
  800ad9:	8d 50 01             	lea    0x1(%eax),%edx
  800adc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800adf:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800ae2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae5:	8b 10                	mov    (%eax),%edx
  800ae7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aea:	8b 40 04             	mov    0x4(%eax),%eax
  800aed:	39 c2                	cmp    %eax,%edx
  800aef:	73 12                	jae    800b03 <sprintputch+0x33>
		*b->buf++ = ch;
  800af1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af4:	8b 00                	mov    (%eax),%eax
  800af6:	8d 48 01             	lea    0x1(%eax),%ecx
  800af9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800afc:	89 0a                	mov    %ecx,(%edx)
  800afe:	8b 55 08             	mov    0x8(%ebp),%edx
  800b01:	88 10                	mov    %dl,(%eax)
}
  800b03:	90                   	nop
  800b04:	5d                   	pop    %ebp
  800b05:	c3                   	ret    

00800b06 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b06:	55                   	push   %ebp
  800b07:	89 e5                	mov    %esp,%ebp
  800b09:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b15:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b18:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1b:	01 d0                	add    %edx,%eax
  800b1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b20:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b27:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b2b:	74 06                	je     800b33 <vsnprintf+0x2d>
  800b2d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b31:	7f 07                	jg     800b3a <vsnprintf+0x34>
		return -E_INVAL;
  800b33:	b8 03 00 00 00       	mov    $0x3,%eax
  800b38:	eb 20                	jmp    800b5a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b3a:	ff 75 14             	pushl  0x14(%ebp)
  800b3d:	ff 75 10             	pushl  0x10(%ebp)
  800b40:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b43:	50                   	push   %eax
  800b44:	68 d0 0a 80 00       	push   $0x800ad0
  800b49:	e8 92 fb ff ff       	call   8006e0 <vprintfmt>
  800b4e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b54:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b57:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b5a:	c9                   	leave  
  800b5b:	c3                   	ret    

00800b5c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b5c:	55                   	push   %ebp
  800b5d:	89 e5                	mov    %esp,%ebp
  800b5f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b62:	8d 45 10             	lea    0x10(%ebp),%eax
  800b65:	83 c0 04             	add    $0x4,%eax
  800b68:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b6b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b6e:	ff 75 f4             	pushl  -0xc(%ebp)
  800b71:	50                   	push   %eax
  800b72:	ff 75 0c             	pushl  0xc(%ebp)
  800b75:	ff 75 08             	pushl  0x8(%ebp)
  800b78:	e8 89 ff ff ff       	call   800b06 <vsnprintf>
  800b7d:	83 c4 10             	add    $0x10,%esp
  800b80:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800b83:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b86:	c9                   	leave  
  800b87:	c3                   	ret    

00800b88 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800b88:	55                   	push   %ebp
  800b89:	89 e5                	mov    %esp,%ebp
  800b8b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b8e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b95:	eb 06                	jmp    800b9d <strlen+0x15>
		n++;
  800b97:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b9a:	ff 45 08             	incl   0x8(%ebp)
  800b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba0:	8a 00                	mov    (%eax),%al
  800ba2:	84 c0                	test   %al,%al
  800ba4:	75 f1                	jne    800b97 <strlen+0xf>
		n++;
	return n;
  800ba6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ba9:	c9                   	leave  
  800baa:	c3                   	ret    

00800bab <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bab:	55                   	push   %ebp
  800bac:	89 e5                	mov    %esp,%ebp
  800bae:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bb1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bb8:	eb 09                	jmp    800bc3 <strnlen+0x18>
		n++;
  800bba:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bbd:	ff 45 08             	incl   0x8(%ebp)
  800bc0:	ff 4d 0c             	decl   0xc(%ebp)
  800bc3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bc7:	74 09                	je     800bd2 <strnlen+0x27>
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	8a 00                	mov    (%eax),%al
  800bce:	84 c0                	test   %al,%al
  800bd0:	75 e8                	jne    800bba <strnlen+0xf>
		n++;
	return n;
  800bd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bd5:	c9                   	leave  
  800bd6:	c3                   	ret    

00800bd7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bd7:	55                   	push   %ebp
  800bd8:	89 e5                	mov    %esp,%ebp
  800bda:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800be0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800be3:	90                   	nop
  800be4:	8b 45 08             	mov    0x8(%ebp),%eax
  800be7:	8d 50 01             	lea    0x1(%eax),%edx
  800bea:	89 55 08             	mov    %edx,0x8(%ebp)
  800bed:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bf0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bf3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bf6:	8a 12                	mov    (%edx),%dl
  800bf8:	88 10                	mov    %dl,(%eax)
  800bfa:	8a 00                	mov    (%eax),%al
  800bfc:	84 c0                	test   %al,%al
  800bfe:	75 e4                	jne    800be4 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c00:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c03:	c9                   	leave  
  800c04:	c3                   	ret    

00800c05 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c05:	55                   	push   %ebp
  800c06:	89 e5                	mov    %esp,%ebp
  800c08:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c11:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c18:	eb 1f                	jmp    800c39 <strncpy+0x34>
		*dst++ = *src;
  800c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1d:	8d 50 01             	lea    0x1(%eax),%edx
  800c20:	89 55 08             	mov    %edx,0x8(%ebp)
  800c23:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c26:	8a 12                	mov    (%edx),%dl
  800c28:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2d:	8a 00                	mov    (%eax),%al
  800c2f:	84 c0                	test   %al,%al
  800c31:	74 03                	je     800c36 <strncpy+0x31>
			src++;
  800c33:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c36:	ff 45 fc             	incl   -0x4(%ebp)
  800c39:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c3c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c3f:	72 d9                	jb     800c1a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c41:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c44:	c9                   	leave  
  800c45:	c3                   	ret    

00800c46 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c46:	55                   	push   %ebp
  800c47:	89 e5                	mov    %esp,%ebp
  800c49:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c52:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c56:	74 30                	je     800c88 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c58:	eb 16                	jmp    800c70 <strlcpy+0x2a>
			*dst++ = *src++;
  800c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5d:	8d 50 01             	lea    0x1(%eax),%edx
  800c60:	89 55 08             	mov    %edx,0x8(%ebp)
  800c63:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c66:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c69:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c6c:	8a 12                	mov    (%edx),%dl
  800c6e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c70:	ff 4d 10             	decl   0x10(%ebp)
  800c73:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c77:	74 09                	je     800c82 <strlcpy+0x3c>
  800c79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7c:	8a 00                	mov    (%eax),%al
  800c7e:	84 c0                	test   %al,%al
  800c80:	75 d8                	jne    800c5a <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c82:	8b 45 08             	mov    0x8(%ebp),%eax
  800c85:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c88:	8b 55 08             	mov    0x8(%ebp),%edx
  800c8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c8e:	29 c2                	sub    %eax,%edx
  800c90:	89 d0                	mov    %edx,%eax
}
  800c92:	c9                   	leave  
  800c93:	c3                   	ret    

00800c94 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c94:	55                   	push   %ebp
  800c95:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c97:	eb 06                	jmp    800c9f <strcmp+0xb>
		p++, q++;
  800c99:	ff 45 08             	incl   0x8(%ebp)
  800c9c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca2:	8a 00                	mov    (%eax),%al
  800ca4:	84 c0                	test   %al,%al
  800ca6:	74 0e                	je     800cb6 <strcmp+0x22>
  800ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cab:	8a 10                	mov    (%eax),%dl
  800cad:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb0:	8a 00                	mov    (%eax),%al
  800cb2:	38 c2                	cmp    %al,%dl
  800cb4:	74 e3                	je     800c99 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	8a 00                	mov    (%eax),%al
  800cbb:	0f b6 d0             	movzbl %al,%edx
  800cbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc1:	8a 00                	mov    (%eax),%al
  800cc3:	0f b6 c0             	movzbl %al,%eax
  800cc6:	29 c2                	sub    %eax,%edx
  800cc8:	89 d0                	mov    %edx,%eax
}
  800cca:	5d                   	pop    %ebp
  800ccb:	c3                   	ret    

00800ccc <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ccc:	55                   	push   %ebp
  800ccd:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800ccf:	eb 09                	jmp    800cda <strncmp+0xe>
		n--, p++, q++;
  800cd1:	ff 4d 10             	decl   0x10(%ebp)
  800cd4:	ff 45 08             	incl   0x8(%ebp)
  800cd7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cda:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cde:	74 17                	je     800cf7 <strncmp+0x2b>
  800ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce3:	8a 00                	mov    (%eax),%al
  800ce5:	84 c0                	test   %al,%al
  800ce7:	74 0e                	je     800cf7 <strncmp+0x2b>
  800ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cec:	8a 10                	mov    (%eax),%dl
  800cee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf1:	8a 00                	mov    (%eax),%al
  800cf3:	38 c2                	cmp    %al,%dl
  800cf5:	74 da                	je     800cd1 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800cf7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cfb:	75 07                	jne    800d04 <strncmp+0x38>
		return 0;
  800cfd:	b8 00 00 00 00       	mov    $0x0,%eax
  800d02:	eb 14                	jmp    800d18 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d04:	8b 45 08             	mov    0x8(%ebp),%eax
  800d07:	8a 00                	mov    (%eax),%al
  800d09:	0f b6 d0             	movzbl %al,%edx
  800d0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0f:	8a 00                	mov    (%eax),%al
  800d11:	0f b6 c0             	movzbl %al,%eax
  800d14:	29 c2                	sub    %eax,%edx
  800d16:	89 d0                	mov    %edx,%eax
}
  800d18:	5d                   	pop    %ebp
  800d19:	c3                   	ret    

00800d1a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d1a:	55                   	push   %ebp
  800d1b:	89 e5                	mov    %esp,%ebp
  800d1d:	83 ec 04             	sub    $0x4,%esp
  800d20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d23:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d26:	eb 12                	jmp    800d3a <strchr+0x20>
		if (*s == c)
  800d28:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2b:	8a 00                	mov    (%eax),%al
  800d2d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d30:	75 05                	jne    800d37 <strchr+0x1d>
			return (char *) s;
  800d32:	8b 45 08             	mov    0x8(%ebp),%eax
  800d35:	eb 11                	jmp    800d48 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d37:	ff 45 08             	incl   0x8(%ebp)
  800d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3d:	8a 00                	mov    (%eax),%al
  800d3f:	84 c0                	test   %al,%al
  800d41:	75 e5                	jne    800d28 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d43:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d48:	c9                   	leave  
  800d49:	c3                   	ret    

00800d4a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	83 ec 04             	sub    $0x4,%esp
  800d50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d53:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d56:	eb 0d                	jmp    800d65 <strfind+0x1b>
		if (*s == c)
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	8a 00                	mov    (%eax),%al
  800d5d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d60:	74 0e                	je     800d70 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d62:	ff 45 08             	incl   0x8(%ebp)
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	8a 00                	mov    (%eax),%al
  800d6a:	84 c0                	test   %al,%al
  800d6c:	75 ea                	jne    800d58 <strfind+0xe>
  800d6e:	eb 01                	jmp    800d71 <strfind+0x27>
		if (*s == c)
			break;
  800d70:	90                   	nop
	return (char *) s;
  800d71:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d74:	c9                   	leave  
  800d75:	c3                   	ret    

00800d76 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d76:	55                   	push   %ebp
  800d77:	89 e5                	mov    %esp,%ebp
  800d79:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d82:	8b 45 10             	mov    0x10(%ebp),%eax
  800d85:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d88:	eb 0e                	jmp    800d98 <memset+0x22>
		*p++ = c;
  800d8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d8d:	8d 50 01             	lea    0x1(%eax),%edx
  800d90:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d93:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d96:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d98:	ff 4d f8             	decl   -0x8(%ebp)
  800d9b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d9f:	79 e9                	jns    800d8a <memset+0x14>
		*p++ = c;

	return v;
  800da1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800da4:	c9                   	leave  
  800da5:	c3                   	ret    

00800da6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800da6:	55                   	push   %ebp
  800da7:	89 e5                	mov    %esp,%ebp
  800da9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800daf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800db2:	8b 45 08             	mov    0x8(%ebp),%eax
  800db5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800db8:	eb 16                	jmp    800dd0 <memcpy+0x2a>
		*d++ = *s++;
  800dba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dbd:	8d 50 01             	lea    0x1(%eax),%edx
  800dc0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dc3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dc6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dc9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dcc:	8a 12                	mov    (%edx),%dl
  800dce:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800dd0:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dd6:	89 55 10             	mov    %edx,0x10(%ebp)
  800dd9:	85 c0                	test   %eax,%eax
  800ddb:	75 dd                	jne    800dba <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800de0:	c9                   	leave  
  800de1:	c3                   	ret    

00800de2 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800de2:	55                   	push   %ebp
  800de3:	89 e5                	mov    %esp,%ebp
  800de5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800de8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800deb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dee:	8b 45 08             	mov    0x8(%ebp),%eax
  800df1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800df4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800dfa:	73 50                	jae    800e4c <memmove+0x6a>
  800dfc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dff:	8b 45 10             	mov    0x10(%ebp),%eax
  800e02:	01 d0                	add    %edx,%eax
  800e04:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e07:	76 43                	jbe    800e4c <memmove+0x6a>
		s += n;
  800e09:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e0f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e12:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e15:	eb 10                	jmp    800e27 <memmove+0x45>
			*--d = *--s;
  800e17:	ff 4d f8             	decl   -0x8(%ebp)
  800e1a:	ff 4d fc             	decl   -0x4(%ebp)
  800e1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e20:	8a 10                	mov    (%eax),%dl
  800e22:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e25:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e27:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e2d:	89 55 10             	mov    %edx,0x10(%ebp)
  800e30:	85 c0                	test   %eax,%eax
  800e32:	75 e3                	jne    800e17 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e34:	eb 23                	jmp    800e59 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e36:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e39:	8d 50 01             	lea    0x1(%eax),%edx
  800e3c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e3f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e42:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e45:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e48:	8a 12                	mov    (%edx),%dl
  800e4a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e4c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e52:	89 55 10             	mov    %edx,0x10(%ebp)
  800e55:	85 c0                	test   %eax,%eax
  800e57:	75 dd                	jne    800e36 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e5c:	c9                   	leave  
  800e5d:	c3                   	ret    

00800e5e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e5e:	55                   	push   %ebp
  800e5f:	89 e5                	mov    %esp,%ebp
  800e61:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e64:	8b 45 08             	mov    0x8(%ebp),%eax
  800e67:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e70:	eb 2a                	jmp    800e9c <memcmp+0x3e>
		if (*s1 != *s2)
  800e72:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e75:	8a 10                	mov    (%eax),%dl
  800e77:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e7a:	8a 00                	mov    (%eax),%al
  800e7c:	38 c2                	cmp    %al,%dl
  800e7e:	74 16                	je     800e96 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e80:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e83:	8a 00                	mov    (%eax),%al
  800e85:	0f b6 d0             	movzbl %al,%edx
  800e88:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e8b:	8a 00                	mov    (%eax),%al
  800e8d:	0f b6 c0             	movzbl %al,%eax
  800e90:	29 c2                	sub    %eax,%edx
  800e92:	89 d0                	mov    %edx,%eax
  800e94:	eb 18                	jmp    800eae <memcmp+0x50>
		s1++, s2++;
  800e96:	ff 45 fc             	incl   -0x4(%ebp)
  800e99:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e9c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e9f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ea2:	89 55 10             	mov    %edx,0x10(%ebp)
  800ea5:	85 c0                	test   %eax,%eax
  800ea7:	75 c9                	jne    800e72 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ea9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eae:	c9                   	leave  
  800eaf:	c3                   	ret    

00800eb0 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800eb0:	55                   	push   %ebp
  800eb1:	89 e5                	mov    %esp,%ebp
  800eb3:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800eb6:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb9:	8b 45 10             	mov    0x10(%ebp),%eax
  800ebc:	01 d0                	add    %edx,%eax
  800ebe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ec1:	eb 15                	jmp    800ed8 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec6:	8a 00                	mov    (%eax),%al
  800ec8:	0f b6 d0             	movzbl %al,%edx
  800ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ece:	0f b6 c0             	movzbl %al,%eax
  800ed1:	39 c2                	cmp    %eax,%edx
  800ed3:	74 0d                	je     800ee2 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ed5:	ff 45 08             	incl   0x8(%ebp)
  800ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  800edb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ede:	72 e3                	jb     800ec3 <memfind+0x13>
  800ee0:	eb 01                	jmp    800ee3 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ee2:	90                   	nop
	return (void *) s;
  800ee3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ee6:	c9                   	leave  
  800ee7:	c3                   	ret    

00800ee8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ee8:	55                   	push   %ebp
  800ee9:	89 e5                	mov    %esp,%ebp
  800eeb:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800eee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800ef5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800efc:	eb 03                	jmp    800f01 <strtol+0x19>
		s++;
  800efe:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f01:	8b 45 08             	mov    0x8(%ebp),%eax
  800f04:	8a 00                	mov    (%eax),%al
  800f06:	3c 20                	cmp    $0x20,%al
  800f08:	74 f4                	je     800efe <strtol+0x16>
  800f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0d:	8a 00                	mov    (%eax),%al
  800f0f:	3c 09                	cmp    $0x9,%al
  800f11:	74 eb                	je     800efe <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
  800f16:	8a 00                	mov    (%eax),%al
  800f18:	3c 2b                	cmp    $0x2b,%al
  800f1a:	75 05                	jne    800f21 <strtol+0x39>
		s++;
  800f1c:	ff 45 08             	incl   0x8(%ebp)
  800f1f:	eb 13                	jmp    800f34 <strtol+0x4c>
	else if (*s == '-')
  800f21:	8b 45 08             	mov    0x8(%ebp),%eax
  800f24:	8a 00                	mov    (%eax),%al
  800f26:	3c 2d                	cmp    $0x2d,%al
  800f28:	75 0a                	jne    800f34 <strtol+0x4c>
		s++, neg = 1;
  800f2a:	ff 45 08             	incl   0x8(%ebp)
  800f2d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f34:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f38:	74 06                	je     800f40 <strtol+0x58>
  800f3a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f3e:	75 20                	jne    800f60 <strtol+0x78>
  800f40:	8b 45 08             	mov    0x8(%ebp),%eax
  800f43:	8a 00                	mov    (%eax),%al
  800f45:	3c 30                	cmp    $0x30,%al
  800f47:	75 17                	jne    800f60 <strtol+0x78>
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	40                   	inc    %eax
  800f4d:	8a 00                	mov    (%eax),%al
  800f4f:	3c 78                	cmp    $0x78,%al
  800f51:	75 0d                	jne    800f60 <strtol+0x78>
		s += 2, base = 16;
  800f53:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f57:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f5e:	eb 28                	jmp    800f88 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f60:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f64:	75 15                	jne    800f7b <strtol+0x93>
  800f66:	8b 45 08             	mov    0x8(%ebp),%eax
  800f69:	8a 00                	mov    (%eax),%al
  800f6b:	3c 30                	cmp    $0x30,%al
  800f6d:	75 0c                	jne    800f7b <strtol+0x93>
		s++, base = 8;
  800f6f:	ff 45 08             	incl   0x8(%ebp)
  800f72:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f79:	eb 0d                	jmp    800f88 <strtol+0xa0>
	else if (base == 0)
  800f7b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7f:	75 07                	jne    800f88 <strtol+0xa0>
		base = 10;
  800f81:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f88:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8b:	8a 00                	mov    (%eax),%al
  800f8d:	3c 2f                	cmp    $0x2f,%al
  800f8f:	7e 19                	jle    800faa <strtol+0xc2>
  800f91:	8b 45 08             	mov    0x8(%ebp),%eax
  800f94:	8a 00                	mov    (%eax),%al
  800f96:	3c 39                	cmp    $0x39,%al
  800f98:	7f 10                	jg     800faa <strtol+0xc2>
			dig = *s - '0';
  800f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9d:	8a 00                	mov    (%eax),%al
  800f9f:	0f be c0             	movsbl %al,%eax
  800fa2:	83 e8 30             	sub    $0x30,%eax
  800fa5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fa8:	eb 42                	jmp    800fec <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800faa:	8b 45 08             	mov    0x8(%ebp),%eax
  800fad:	8a 00                	mov    (%eax),%al
  800faf:	3c 60                	cmp    $0x60,%al
  800fb1:	7e 19                	jle    800fcc <strtol+0xe4>
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	8a 00                	mov    (%eax),%al
  800fb8:	3c 7a                	cmp    $0x7a,%al
  800fba:	7f 10                	jg     800fcc <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbf:	8a 00                	mov    (%eax),%al
  800fc1:	0f be c0             	movsbl %al,%eax
  800fc4:	83 e8 57             	sub    $0x57,%eax
  800fc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fca:	eb 20                	jmp    800fec <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcf:	8a 00                	mov    (%eax),%al
  800fd1:	3c 40                	cmp    $0x40,%al
  800fd3:	7e 39                	jle    80100e <strtol+0x126>
  800fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd8:	8a 00                	mov    (%eax),%al
  800fda:	3c 5a                	cmp    $0x5a,%al
  800fdc:	7f 30                	jg     80100e <strtol+0x126>
			dig = *s - 'A' + 10;
  800fde:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe1:	8a 00                	mov    (%eax),%al
  800fe3:	0f be c0             	movsbl %al,%eax
  800fe6:	83 e8 37             	sub    $0x37,%eax
  800fe9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800fec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fef:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ff2:	7d 19                	jge    80100d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800ff4:	ff 45 08             	incl   0x8(%ebp)
  800ff7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ffa:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ffe:	89 c2                	mov    %eax,%edx
  801000:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801003:	01 d0                	add    %edx,%eax
  801005:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801008:	e9 7b ff ff ff       	jmp    800f88 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80100d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80100e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801012:	74 08                	je     80101c <strtol+0x134>
		*endptr = (char *) s;
  801014:	8b 45 0c             	mov    0xc(%ebp),%eax
  801017:	8b 55 08             	mov    0x8(%ebp),%edx
  80101a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80101c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801020:	74 07                	je     801029 <strtol+0x141>
  801022:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801025:	f7 d8                	neg    %eax
  801027:	eb 03                	jmp    80102c <strtol+0x144>
  801029:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80102c:	c9                   	leave  
  80102d:	c3                   	ret    

0080102e <ltostr>:

void
ltostr(long value, char *str)
{
  80102e:	55                   	push   %ebp
  80102f:	89 e5                	mov    %esp,%ebp
  801031:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801034:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80103b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801042:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801046:	79 13                	jns    80105b <ltostr+0x2d>
	{
		neg = 1;
  801048:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80104f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801052:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801055:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801058:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80105b:	8b 45 08             	mov    0x8(%ebp),%eax
  80105e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801063:	99                   	cltd   
  801064:	f7 f9                	idiv   %ecx
  801066:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801069:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80106c:	8d 50 01             	lea    0x1(%eax),%edx
  80106f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801072:	89 c2                	mov    %eax,%edx
  801074:	8b 45 0c             	mov    0xc(%ebp),%eax
  801077:	01 d0                	add    %edx,%eax
  801079:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80107c:	83 c2 30             	add    $0x30,%edx
  80107f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801081:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801084:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801089:	f7 e9                	imul   %ecx
  80108b:	c1 fa 02             	sar    $0x2,%edx
  80108e:	89 c8                	mov    %ecx,%eax
  801090:	c1 f8 1f             	sar    $0x1f,%eax
  801093:	29 c2                	sub    %eax,%edx
  801095:	89 d0                	mov    %edx,%eax
  801097:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80109a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80109d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010a2:	f7 e9                	imul   %ecx
  8010a4:	c1 fa 02             	sar    $0x2,%edx
  8010a7:	89 c8                	mov    %ecx,%eax
  8010a9:	c1 f8 1f             	sar    $0x1f,%eax
  8010ac:	29 c2                	sub    %eax,%edx
  8010ae:	89 d0                	mov    %edx,%eax
  8010b0:	c1 e0 02             	shl    $0x2,%eax
  8010b3:	01 d0                	add    %edx,%eax
  8010b5:	01 c0                	add    %eax,%eax
  8010b7:	29 c1                	sub    %eax,%ecx
  8010b9:	89 ca                	mov    %ecx,%edx
  8010bb:	85 d2                	test   %edx,%edx
  8010bd:	75 9c                	jne    80105b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c9:	48                   	dec    %eax
  8010ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010d1:	74 3d                	je     801110 <ltostr+0xe2>
		start = 1 ;
  8010d3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010da:	eb 34                	jmp    801110 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8010dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e2:	01 d0                	add    %edx,%eax
  8010e4:	8a 00                	mov    (%eax),%al
  8010e6:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ef:	01 c2                	add    %eax,%edx
  8010f1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f7:	01 c8                	add    %ecx,%eax
  8010f9:	8a 00                	mov    (%eax),%al
  8010fb:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8010fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801100:	8b 45 0c             	mov    0xc(%ebp),%eax
  801103:	01 c2                	add    %eax,%edx
  801105:	8a 45 eb             	mov    -0x15(%ebp),%al
  801108:	88 02                	mov    %al,(%edx)
		start++ ;
  80110a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80110d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801110:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801113:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801116:	7c c4                	jl     8010dc <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801118:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80111b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111e:	01 d0                	add    %edx,%eax
  801120:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801123:	90                   	nop
  801124:	c9                   	leave  
  801125:	c3                   	ret    

00801126 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801126:	55                   	push   %ebp
  801127:	89 e5                	mov    %esp,%ebp
  801129:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80112c:	ff 75 08             	pushl  0x8(%ebp)
  80112f:	e8 54 fa ff ff       	call   800b88 <strlen>
  801134:	83 c4 04             	add    $0x4,%esp
  801137:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80113a:	ff 75 0c             	pushl  0xc(%ebp)
  80113d:	e8 46 fa ff ff       	call   800b88 <strlen>
  801142:	83 c4 04             	add    $0x4,%esp
  801145:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801148:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80114f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801156:	eb 17                	jmp    80116f <strcconcat+0x49>
		final[s] = str1[s] ;
  801158:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80115b:	8b 45 10             	mov    0x10(%ebp),%eax
  80115e:	01 c2                	add    %eax,%edx
  801160:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
  801166:	01 c8                	add    %ecx,%eax
  801168:	8a 00                	mov    (%eax),%al
  80116a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80116c:	ff 45 fc             	incl   -0x4(%ebp)
  80116f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801172:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801175:	7c e1                	jl     801158 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801177:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80117e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801185:	eb 1f                	jmp    8011a6 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801187:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80118a:	8d 50 01             	lea    0x1(%eax),%edx
  80118d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801190:	89 c2                	mov    %eax,%edx
  801192:	8b 45 10             	mov    0x10(%ebp),%eax
  801195:	01 c2                	add    %eax,%edx
  801197:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80119a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119d:	01 c8                	add    %ecx,%eax
  80119f:	8a 00                	mov    (%eax),%al
  8011a1:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011a3:	ff 45 f8             	incl   -0x8(%ebp)
  8011a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011ac:	7c d9                	jl     801187 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011ae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b4:	01 d0                	add    %edx,%eax
  8011b6:	c6 00 00             	movb   $0x0,(%eax)
}
  8011b9:	90                   	nop
  8011ba:	c9                   	leave  
  8011bb:	c3                   	ret    

008011bc <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011bc:	55                   	push   %ebp
  8011bd:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8011cb:	8b 00                	mov    (%eax),%eax
  8011cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d7:	01 d0                	add    %edx,%eax
  8011d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011df:	eb 0c                	jmp    8011ed <strsplit+0x31>
			*string++ = 0;
  8011e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e4:	8d 50 01             	lea    0x1(%eax),%edx
  8011e7:	89 55 08             	mov    %edx,0x8(%ebp)
  8011ea:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f0:	8a 00                	mov    (%eax),%al
  8011f2:	84 c0                	test   %al,%al
  8011f4:	74 18                	je     80120e <strsplit+0x52>
  8011f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f9:	8a 00                	mov    (%eax),%al
  8011fb:	0f be c0             	movsbl %al,%eax
  8011fe:	50                   	push   %eax
  8011ff:	ff 75 0c             	pushl  0xc(%ebp)
  801202:	e8 13 fb ff ff       	call   800d1a <strchr>
  801207:	83 c4 08             	add    $0x8,%esp
  80120a:	85 c0                	test   %eax,%eax
  80120c:	75 d3                	jne    8011e1 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80120e:	8b 45 08             	mov    0x8(%ebp),%eax
  801211:	8a 00                	mov    (%eax),%al
  801213:	84 c0                	test   %al,%al
  801215:	74 5a                	je     801271 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801217:	8b 45 14             	mov    0x14(%ebp),%eax
  80121a:	8b 00                	mov    (%eax),%eax
  80121c:	83 f8 0f             	cmp    $0xf,%eax
  80121f:	75 07                	jne    801228 <strsplit+0x6c>
		{
			return 0;
  801221:	b8 00 00 00 00       	mov    $0x0,%eax
  801226:	eb 66                	jmp    80128e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801228:	8b 45 14             	mov    0x14(%ebp),%eax
  80122b:	8b 00                	mov    (%eax),%eax
  80122d:	8d 48 01             	lea    0x1(%eax),%ecx
  801230:	8b 55 14             	mov    0x14(%ebp),%edx
  801233:	89 0a                	mov    %ecx,(%edx)
  801235:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80123c:	8b 45 10             	mov    0x10(%ebp),%eax
  80123f:	01 c2                	add    %eax,%edx
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
  801244:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801246:	eb 03                	jmp    80124b <strsplit+0x8f>
			string++;
  801248:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80124b:	8b 45 08             	mov    0x8(%ebp),%eax
  80124e:	8a 00                	mov    (%eax),%al
  801250:	84 c0                	test   %al,%al
  801252:	74 8b                	je     8011df <strsplit+0x23>
  801254:	8b 45 08             	mov    0x8(%ebp),%eax
  801257:	8a 00                	mov    (%eax),%al
  801259:	0f be c0             	movsbl %al,%eax
  80125c:	50                   	push   %eax
  80125d:	ff 75 0c             	pushl  0xc(%ebp)
  801260:	e8 b5 fa ff ff       	call   800d1a <strchr>
  801265:	83 c4 08             	add    $0x8,%esp
  801268:	85 c0                	test   %eax,%eax
  80126a:	74 dc                	je     801248 <strsplit+0x8c>
			string++;
	}
  80126c:	e9 6e ff ff ff       	jmp    8011df <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801271:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801272:	8b 45 14             	mov    0x14(%ebp),%eax
  801275:	8b 00                	mov    (%eax),%eax
  801277:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80127e:	8b 45 10             	mov    0x10(%ebp),%eax
  801281:	01 d0                	add    %edx,%eax
  801283:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801289:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80128e:	c9                   	leave  
  80128f:	c3                   	ret    

00801290 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801290:	55                   	push   %ebp
  801291:	89 e5                	mov    %esp,%ebp
  801293:	57                   	push   %edi
  801294:	56                   	push   %esi
  801295:	53                   	push   %ebx
  801296:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801299:	8b 45 08             	mov    0x8(%ebp),%eax
  80129c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80129f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012a2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012a5:	8b 7d 18             	mov    0x18(%ebp),%edi
  8012a8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8012ab:	cd 30                	int    $0x30
  8012ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8012b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012b3:	83 c4 10             	add    $0x10,%esp
  8012b6:	5b                   	pop    %ebx
  8012b7:	5e                   	pop    %esi
  8012b8:	5f                   	pop    %edi
  8012b9:	5d                   	pop    %ebp
  8012ba:	c3                   	ret    

008012bb <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8012bb:	55                   	push   %ebp
  8012bc:	89 e5                	mov    %esp,%ebp
  8012be:	83 ec 04             	sub    $0x4,%esp
  8012c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8012c7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ce:	6a 00                	push   $0x0
  8012d0:	6a 00                	push   $0x0
  8012d2:	52                   	push   %edx
  8012d3:	ff 75 0c             	pushl  0xc(%ebp)
  8012d6:	50                   	push   %eax
  8012d7:	6a 00                	push   $0x0
  8012d9:	e8 b2 ff ff ff       	call   801290 <syscall>
  8012de:	83 c4 18             	add    $0x18,%esp
}
  8012e1:	90                   	nop
  8012e2:	c9                   	leave  
  8012e3:	c3                   	ret    

008012e4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8012e4:	55                   	push   %ebp
  8012e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8012e7:	6a 00                	push   $0x0
  8012e9:	6a 00                	push   $0x0
  8012eb:	6a 00                	push   $0x0
  8012ed:	6a 00                	push   $0x0
  8012ef:	6a 00                	push   $0x0
  8012f1:	6a 01                	push   $0x1
  8012f3:	e8 98 ff ff ff       	call   801290 <syscall>
  8012f8:	83 c4 18             	add    $0x18,%esp
}
  8012fb:	c9                   	leave  
  8012fc:	c3                   	ret    

008012fd <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8012fd:	55                   	push   %ebp
  8012fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801300:	8b 55 0c             	mov    0xc(%ebp),%edx
  801303:	8b 45 08             	mov    0x8(%ebp),%eax
  801306:	6a 00                	push   $0x0
  801308:	6a 00                	push   $0x0
  80130a:	6a 00                	push   $0x0
  80130c:	52                   	push   %edx
  80130d:	50                   	push   %eax
  80130e:	6a 05                	push   $0x5
  801310:	e8 7b ff ff ff       	call   801290 <syscall>
  801315:	83 c4 18             	add    $0x18,%esp
}
  801318:	c9                   	leave  
  801319:	c3                   	ret    

0080131a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80131a:	55                   	push   %ebp
  80131b:	89 e5                	mov    %esp,%ebp
  80131d:	56                   	push   %esi
  80131e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80131f:	8b 75 18             	mov    0x18(%ebp),%esi
  801322:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801325:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801328:	8b 55 0c             	mov    0xc(%ebp),%edx
  80132b:	8b 45 08             	mov    0x8(%ebp),%eax
  80132e:	56                   	push   %esi
  80132f:	53                   	push   %ebx
  801330:	51                   	push   %ecx
  801331:	52                   	push   %edx
  801332:	50                   	push   %eax
  801333:	6a 06                	push   $0x6
  801335:	e8 56 ff ff ff       	call   801290 <syscall>
  80133a:	83 c4 18             	add    $0x18,%esp
}
  80133d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801340:	5b                   	pop    %ebx
  801341:	5e                   	pop    %esi
  801342:	5d                   	pop    %ebp
  801343:	c3                   	ret    

00801344 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801344:	55                   	push   %ebp
  801345:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801347:	8b 55 0c             	mov    0xc(%ebp),%edx
  80134a:	8b 45 08             	mov    0x8(%ebp),%eax
  80134d:	6a 00                	push   $0x0
  80134f:	6a 00                	push   $0x0
  801351:	6a 00                	push   $0x0
  801353:	52                   	push   %edx
  801354:	50                   	push   %eax
  801355:	6a 07                	push   $0x7
  801357:	e8 34 ff ff ff       	call   801290 <syscall>
  80135c:	83 c4 18             	add    $0x18,%esp
}
  80135f:	c9                   	leave  
  801360:	c3                   	ret    

00801361 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801361:	55                   	push   %ebp
  801362:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801364:	6a 00                	push   $0x0
  801366:	6a 00                	push   $0x0
  801368:	6a 00                	push   $0x0
  80136a:	ff 75 0c             	pushl  0xc(%ebp)
  80136d:	ff 75 08             	pushl  0x8(%ebp)
  801370:	6a 08                	push   $0x8
  801372:	e8 19 ff ff ff       	call   801290 <syscall>
  801377:	83 c4 18             	add    $0x18,%esp
}
  80137a:	c9                   	leave  
  80137b:	c3                   	ret    

0080137c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80137c:	55                   	push   %ebp
  80137d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80137f:	6a 00                	push   $0x0
  801381:	6a 00                	push   $0x0
  801383:	6a 00                	push   $0x0
  801385:	6a 00                	push   $0x0
  801387:	6a 00                	push   $0x0
  801389:	6a 09                	push   $0x9
  80138b:	e8 00 ff ff ff       	call   801290 <syscall>
  801390:	83 c4 18             	add    $0x18,%esp
}
  801393:	c9                   	leave  
  801394:	c3                   	ret    

00801395 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801395:	55                   	push   %ebp
  801396:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801398:	6a 00                	push   $0x0
  80139a:	6a 00                	push   $0x0
  80139c:	6a 00                	push   $0x0
  80139e:	6a 00                	push   $0x0
  8013a0:	6a 00                	push   $0x0
  8013a2:	6a 0a                	push   $0xa
  8013a4:	e8 e7 fe ff ff       	call   801290 <syscall>
  8013a9:	83 c4 18             	add    $0x18,%esp
}
  8013ac:	c9                   	leave  
  8013ad:	c3                   	ret    

008013ae <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8013ae:	55                   	push   %ebp
  8013af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8013b1:	6a 00                	push   $0x0
  8013b3:	6a 00                	push   $0x0
  8013b5:	6a 00                	push   $0x0
  8013b7:	6a 00                	push   $0x0
  8013b9:	6a 00                	push   $0x0
  8013bb:	6a 0b                	push   $0xb
  8013bd:	e8 ce fe ff ff       	call   801290 <syscall>
  8013c2:	83 c4 18             	add    $0x18,%esp
}
  8013c5:	c9                   	leave  
  8013c6:	c3                   	ret    

008013c7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8013c7:	55                   	push   %ebp
  8013c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8013ca:	6a 00                	push   $0x0
  8013cc:	6a 00                	push   $0x0
  8013ce:	6a 00                	push   $0x0
  8013d0:	ff 75 0c             	pushl  0xc(%ebp)
  8013d3:	ff 75 08             	pushl  0x8(%ebp)
  8013d6:	6a 0f                	push   $0xf
  8013d8:	e8 b3 fe ff ff       	call   801290 <syscall>
  8013dd:	83 c4 18             	add    $0x18,%esp
	return;
  8013e0:	90                   	nop
}
  8013e1:	c9                   	leave  
  8013e2:	c3                   	ret    

008013e3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8013e3:	55                   	push   %ebp
  8013e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8013e6:	6a 00                	push   $0x0
  8013e8:	6a 00                	push   $0x0
  8013ea:	6a 00                	push   $0x0
  8013ec:	ff 75 0c             	pushl  0xc(%ebp)
  8013ef:	ff 75 08             	pushl  0x8(%ebp)
  8013f2:	6a 10                	push   $0x10
  8013f4:	e8 97 fe ff ff       	call   801290 <syscall>
  8013f9:	83 c4 18             	add    $0x18,%esp
	return ;
  8013fc:	90                   	nop
}
  8013fd:	c9                   	leave  
  8013fe:	c3                   	ret    

008013ff <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8013ff:	55                   	push   %ebp
  801400:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801402:	6a 00                	push   $0x0
  801404:	6a 00                	push   $0x0
  801406:	ff 75 10             	pushl  0x10(%ebp)
  801409:	ff 75 0c             	pushl  0xc(%ebp)
  80140c:	ff 75 08             	pushl  0x8(%ebp)
  80140f:	6a 11                	push   $0x11
  801411:	e8 7a fe ff ff       	call   801290 <syscall>
  801416:	83 c4 18             	add    $0x18,%esp
	return ;
  801419:	90                   	nop
}
  80141a:	c9                   	leave  
  80141b:	c3                   	ret    

0080141c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80141c:	55                   	push   %ebp
  80141d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80141f:	6a 00                	push   $0x0
  801421:	6a 00                	push   $0x0
  801423:	6a 00                	push   $0x0
  801425:	6a 00                	push   $0x0
  801427:	6a 00                	push   $0x0
  801429:	6a 0c                	push   $0xc
  80142b:	e8 60 fe ff ff       	call   801290 <syscall>
  801430:	83 c4 18             	add    $0x18,%esp
}
  801433:	c9                   	leave  
  801434:	c3                   	ret    

00801435 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801435:	55                   	push   %ebp
  801436:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801438:	6a 00                	push   $0x0
  80143a:	6a 00                	push   $0x0
  80143c:	6a 00                	push   $0x0
  80143e:	6a 00                	push   $0x0
  801440:	ff 75 08             	pushl  0x8(%ebp)
  801443:	6a 0d                	push   $0xd
  801445:	e8 46 fe ff ff       	call   801290 <syscall>
  80144a:	83 c4 18             	add    $0x18,%esp
}
  80144d:	c9                   	leave  
  80144e:	c3                   	ret    

0080144f <sys_scarce_memory>:

void sys_scarce_memory()
{
  80144f:	55                   	push   %ebp
  801450:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801452:	6a 00                	push   $0x0
  801454:	6a 00                	push   $0x0
  801456:	6a 00                	push   $0x0
  801458:	6a 00                	push   $0x0
  80145a:	6a 00                	push   $0x0
  80145c:	6a 0e                	push   $0xe
  80145e:	e8 2d fe ff ff       	call   801290 <syscall>
  801463:	83 c4 18             	add    $0x18,%esp
}
  801466:	90                   	nop
  801467:	c9                   	leave  
  801468:	c3                   	ret    

00801469 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801469:	55                   	push   %ebp
  80146a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80146c:	6a 00                	push   $0x0
  80146e:	6a 00                	push   $0x0
  801470:	6a 00                	push   $0x0
  801472:	6a 00                	push   $0x0
  801474:	6a 00                	push   $0x0
  801476:	6a 13                	push   $0x13
  801478:	e8 13 fe ff ff       	call   801290 <syscall>
  80147d:	83 c4 18             	add    $0x18,%esp
}
  801480:	90                   	nop
  801481:	c9                   	leave  
  801482:	c3                   	ret    

00801483 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801483:	55                   	push   %ebp
  801484:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801486:	6a 00                	push   $0x0
  801488:	6a 00                	push   $0x0
  80148a:	6a 00                	push   $0x0
  80148c:	6a 00                	push   $0x0
  80148e:	6a 00                	push   $0x0
  801490:	6a 14                	push   $0x14
  801492:	e8 f9 fd ff ff       	call   801290 <syscall>
  801497:	83 c4 18             	add    $0x18,%esp
}
  80149a:	90                   	nop
  80149b:	c9                   	leave  
  80149c:	c3                   	ret    

0080149d <sys_cputc>:


void
sys_cputc(const char c)
{
  80149d:	55                   	push   %ebp
  80149e:	89 e5                	mov    %esp,%ebp
  8014a0:	83 ec 04             	sub    $0x4,%esp
  8014a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8014a9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8014ad:	6a 00                	push   $0x0
  8014af:	6a 00                	push   $0x0
  8014b1:	6a 00                	push   $0x0
  8014b3:	6a 00                	push   $0x0
  8014b5:	50                   	push   %eax
  8014b6:	6a 15                	push   $0x15
  8014b8:	e8 d3 fd ff ff       	call   801290 <syscall>
  8014bd:	83 c4 18             	add    $0x18,%esp
}
  8014c0:	90                   	nop
  8014c1:	c9                   	leave  
  8014c2:	c3                   	ret    

008014c3 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8014c3:	55                   	push   %ebp
  8014c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8014c6:	6a 00                	push   $0x0
  8014c8:	6a 00                	push   $0x0
  8014ca:	6a 00                	push   $0x0
  8014cc:	6a 00                	push   $0x0
  8014ce:	6a 00                	push   $0x0
  8014d0:	6a 16                	push   $0x16
  8014d2:	e8 b9 fd ff ff       	call   801290 <syscall>
  8014d7:	83 c4 18             	add    $0x18,%esp
}
  8014da:	90                   	nop
  8014db:	c9                   	leave  
  8014dc:	c3                   	ret    

008014dd <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8014dd:	55                   	push   %ebp
  8014de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8014e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e3:	6a 00                	push   $0x0
  8014e5:	6a 00                	push   $0x0
  8014e7:	6a 00                	push   $0x0
  8014e9:	ff 75 0c             	pushl  0xc(%ebp)
  8014ec:	50                   	push   %eax
  8014ed:	6a 17                	push   $0x17
  8014ef:	e8 9c fd ff ff       	call   801290 <syscall>
  8014f4:	83 c4 18             	add    $0x18,%esp
}
  8014f7:	c9                   	leave  
  8014f8:	c3                   	ret    

008014f9 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8014f9:	55                   	push   %ebp
  8014fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801502:	6a 00                	push   $0x0
  801504:	6a 00                	push   $0x0
  801506:	6a 00                	push   $0x0
  801508:	52                   	push   %edx
  801509:	50                   	push   %eax
  80150a:	6a 1a                	push   $0x1a
  80150c:	e8 7f fd ff ff       	call   801290 <syscall>
  801511:	83 c4 18             	add    $0x18,%esp
}
  801514:	c9                   	leave  
  801515:	c3                   	ret    

00801516 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801516:	55                   	push   %ebp
  801517:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801519:	8b 55 0c             	mov    0xc(%ebp),%edx
  80151c:	8b 45 08             	mov    0x8(%ebp),%eax
  80151f:	6a 00                	push   $0x0
  801521:	6a 00                	push   $0x0
  801523:	6a 00                	push   $0x0
  801525:	52                   	push   %edx
  801526:	50                   	push   %eax
  801527:	6a 18                	push   $0x18
  801529:	e8 62 fd ff ff       	call   801290 <syscall>
  80152e:	83 c4 18             	add    $0x18,%esp
}
  801531:	90                   	nop
  801532:	c9                   	leave  
  801533:	c3                   	ret    

00801534 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801534:	55                   	push   %ebp
  801535:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801537:	8b 55 0c             	mov    0xc(%ebp),%edx
  80153a:	8b 45 08             	mov    0x8(%ebp),%eax
  80153d:	6a 00                	push   $0x0
  80153f:	6a 00                	push   $0x0
  801541:	6a 00                	push   $0x0
  801543:	52                   	push   %edx
  801544:	50                   	push   %eax
  801545:	6a 19                	push   $0x19
  801547:	e8 44 fd ff ff       	call   801290 <syscall>
  80154c:	83 c4 18             	add    $0x18,%esp
}
  80154f:	90                   	nop
  801550:	c9                   	leave  
  801551:	c3                   	ret    

00801552 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801552:	55                   	push   %ebp
  801553:	89 e5                	mov    %esp,%ebp
  801555:	83 ec 04             	sub    $0x4,%esp
  801558:	8b 45 10             	mov    0x10(%ebp),%eax
  80155b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80155e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801561:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801565:	8b 45 08             	mov    0x8(%ebp),%eax
  801568:	6a 00                	push   $0x0
  80156a:	51                   	push   %ecx
  80156b:	52                   	push   %edx
  80156c:	ff 75 0c             	pushl  0xc(%ebp)
  80156f:	50                   	push   %eax
  801570:	6a 1b                	push   $0x1b
  801572:	e8 19 fd ff ff       	call   801290 <syscall>
  801577:	83 c4 18             	add    $0x18,%esp
}
  80157a:	c9                   	leave  
  80157b:	c3                   	ret    

0080157c <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80157c:	55                   	push   %ebp
  80157d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80157f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801582:	8b 45 08             	mov    0x8(%ebp),%eax
  801585:	6a 00                	push   $0x0
  801587:	6a 00                	push   $0x0
  801589:	6a 00                	push   $0x0
  80158b:	52                   	push   %edx
  80158c:	50                   	push   %eax
  80158d:	6a 1c                	push   $0x1c
  80158f:	e8 fc fc ff ff       	call   801290 <syscall>
  801594:	83 c4 18             	add    $0x18,%esp
}
  801597:	c9                   	leave  
  801598:	c3                   	ret    

00801599 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801599:	55                   	push   %ebp
  80159a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80159c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80159f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a5:	6a 00                	push   $0x0
  8015a7:	6a 00                	push   $0x0
  8015a9:	51                   	push   %ecx
  8015aa:	52                   	push   %edx
  8015ab:	50                   	push   %eax
  8015ac:	6a 1d                	push   $0x1d
  8015ae:	e8 dd fc ff ff       	call   801290 <syscall>
  8015b3:	83 c4 18             	add    $0x18,%esp
}
  8015b6:	c9                   	leave  
  8015b7:	c3                   	ret    

008015b8 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8015b8:	55                   	push   %ebp
  8015b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8015bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015be:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c1:	6a 00                	push   $0x0
  8015c3:	6a 00                	push   $0x0
  8015c5:	6a 00                	push   $0x0
  8015c7:	52                   	push   %edx
  8015c8:	50                   	push   %eax
  8015c9:	6a 1e                	push   $0x1e
  8015cb:	e8 c0 fc ff ff       	call   801290 <syscall>
  8015d0:	83 c4 18             	add    $0x18,%esp
}
  8015d3:	c9                   	leave  
  8015d4:	c3                   	ret    

008015d5 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8015d8:	6a 00                	push   $0x0
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 00                	push   $0x0
  8015e0:	6a 00                	push   $0x0
  8015e2:	6a 1f                	push   $0x1f
  8015e4:	e8 a7 fc ff ff       	call   801290 <syscall>
  8015e9:	83 c4 18             	add    $0x18,%esp
}
  8015ec:	c9                   	leave  
  8015ed:	c3                   	ret    

008015ee <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8015ee:	55                   	push   %ebp
  8015ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8015f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f4:	6a 00                	push   $0x0
  8015f6:	ff 75 14             	pushl  0x14(%ebp)
  8015f9:	ff 75 10             	pushl  0x10(%ebp)
  8015fc:	ff 75 0c             	pushl  0xc(%ebp)
  8015ff:	50                   	push   %eax
  801600:	6a 20                	push   $0x20
  801602:	e8 89 fc ff ff       	call   801290 <syscall>
  801607:	83 c4 18             	add    $0x18,%esp
}
  80160a:	c9                   	leave  
  80160b:	c3                   	ret    

0080160c <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80160c:	55                   	push   %ebp
  80160d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80160f:	8b 45 08             	mov    0x8(%ebp),%eax
  801612:	6a 00                	push   $0x0
  801614:	6a 00                	push   $0x0
  801616:	6a 00                	push   $0x0
  801618:	6a 00                	push   $0x0
  80161a:	50                   	push   %eax
  80161b:	6a 21                	push   $0x21
  80161d:	e8 6e fc ff ff       	call   801290 <syscall>
  801622:	83 c4 18             	add    $0x18,%esp
}
  801625:	90                   	nop
  801626:	c9                   	leave  
  801627:	c3                   	ret    

00801628 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801628:	55                   	push   %ebp
  801629:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80162b:	8b 45 08             	mov    0x8(%ebp),%eax
  80162e:	6a 00                	push   $0x0
  801630:	6a 00                	push   $0x0
  801632:	6a 00                	push   $0x0
  801634:	6a 00                	push   $0x0
  801636:	50                   	push   %eax
  801637:	6a 22                	push   $0x22
  801639:	e8 52 fc ff ff       	call   801290 <syscall>
  80163e:	83 c4 18             	add    $0x18,%esp
}
  801641:	c9                   	leave  
  801642:	c3                   	ret    

00801643 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801643:	55                   	push   %ebp
  801644:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801646:	6a 00                	push   $0x0
  801648:	6a 00                	push   $0x0
  80164a:	6a 00                	push   $0x0
  80164c:	6a 00                	push   $0x0
  80164e:	6a 00                	push   $0x0
  801650:	6a 02                	push   $0x2
  801652:	e8 39 fc ff ff       	call   801290 <syscall>
  801657:	83 c4 18             	add    $0x18,%esp
}
  80165a:	c9                   	leave  
  80165b:	c3                   	ret    

0080165c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80165c:	55                   	push   %ebp
  80165d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80165f:	6a 00                	push   $0x0
  801661:	6a 00                	push   $0x0
  801663:	6a 00                	push   $0x0
  801665:	6a 00                	push   $0x0
  801667:	6a 00                	push   $0x0
  801669:	6a 03                	push   $0x3
  80166b:	e8 20 fc ff ff       	call   801290 <syscall>
  801670:	83 c4 18             	add    $0x18,%esp
}
  801673:	c9                   	leave  
  801674:	c3                   	ret    

00801675 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801675:	55                   	push   %ebp
  801676:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801678:	6a 00                	push   $0x0
  80167a:	6a 00                	push   $0x0
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	6a 04                	push   $0x4
  801684:	e8 07 fc ff ff       	call   801290 <syscall>
  801689:	83 c4 18             	add    $0x18,%esp
}
  80168c:	c9                   	leave  
  80168d:	c3                   	ret    

0080168e <sys_exit_env>:


void sys_exit_env(void)
{
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801691:	6a 00                	push   $0x0
  801693:	6a 00                	push   $0x0
  801695:	6a 00                	push   $0x0
  801697:	6a 00                	push   $0x0
  801699:	6a 00                	push   $0x0
  80169b:	6a 23                	push   $0x23
  80169d:	e8 ee fb ff ff       	call   801290 <syscall>
  8016a2:	83 c4 18             	add    $0x18,%esp
}
  8016a5:	90                   	nop
  8016a6:	c9                   	leave  
  8016a7:	c3                   	ret    

008016a8 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8016a8:	55                   	push   %ebp
  8016a9:	89 e5                	mov    %esp,%ebp
  8016ab:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8016ae:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016b1:	8d 50 04             	lea    0x4(%eax),%edx
  8016b4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 00                	push   $0x0
  8016bb:	6a 00                	push   $0x0
  8016bd:	52                   	push   %edx
  8016be:	50                   	push   %eax
  8016bf:	6a 24                	push   $0x24
  8016c1:	e8 ca fb ff ff       	call   801290 <syscall>
  8016c6:	83 c4 18             	add    $0x18,%esp
	return result;
  8016c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016cf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016d2:	89 01                	mov    %eax,(%ecx)
  8016d4:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8016d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016da:	c9                   	leave  
  8016db:	c2 04 00             	ret    $0x4

008016de <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 00                	push   $0x0
  8016e5:	ff 75 10             	pushl  0x10(%ebp)
  8016e8:	ff 75 0c             	pushl  0xc(%ebp)
  8016eb:	ff 75 08             	pushl  0x8(%ebp)
  8016ee:	6a 12                	push   $0x12
  8016f0:	e8 9b fb ff ff       	call   801290 <syscall>
  8016f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8016f8:	90                   	nop
}
  8016f9:	c9                   	leave  
  8016fa:	c3                   	ret    

008016fb <sys_rcr2>:
uint32 sys_rcr2()
{
  8016fb:	55                   	push   %ebp
  8016fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	6a 00                	push   $0x0
  801708:	6a 25                	push   $0x25
  80170a:	e8 81 fb ff ff       	call   801290 <syscall>
  80170f:	83 c4 18             	add    $0x18,%esp
}
  801712:	c9                   	leave  
  801713:	c3                   	ret    

00801714 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801714:	55                   	push   %ebp
  801715:	89 e5                	mov    %esp,%ebp
  801717:	83 ec 04             	sub    $0x4,%esp
  80171a:	8b 45 08             	mov    0x8(%ebp),%eax
  80171d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801720:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	50                   	push   %eax
  80172d:	6a 26                	push   $0x26
  80172f:	e8 5c fb ff ff       	call   801290 <syscall>
  801734:	83 c4 18             	add    $0x18,%esp
	return ;
  801737:	90                   	nop
}
  801738:	c9                   	leave  
  801739:	c3                   	ret    

0080173a <rsttst>:
void rsttst()
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	6a 28                	push   $0x28
  801749:	e8 42 fb ff ff       	call   801290 <syscall>
  80174e:	83 c4 18             	add    $0x18,%esp
	return ;
  801751:	90                   	nop
}
  801752:	c9                   	leave  
  801753:	c3                   	ret    

00801754 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801754:	55                   	push   %ebp
  801755:	89 e5                	mov    %esp,%ebp
  801757:	83 ec 04             	sub    $0x4,%esp
  80175a:	8b 45 14             	mov    0x14(%ebp),%eax
  80175d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801760:	8b 55 18             	mov    0x18(%ebp),%edx
  801763:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801767:	52                   	push   %edx
  801768:	50                   	push   %eax
  801769:	ff 75 10             	pushl  0x10(%ebp)
  80176c:	ff 75 0c             	pushl  0xc(%ebp)
  80176f:	ff 75 08             	pushl  0x8(%ebp)
  801772:	6a 27                	push   $0x27
  801774:	e8 17 fb ff ff       	call   801290 <syscall>
  801779:	83 c4 18             	add    $0x18,%esp
	return ;
  80177c:	90                   	nop
}
  80177d:	c9                   	leave  
  80177e:	c3                   	ret    

0080177f <chktst>:
void chktst(uint32 n)
{
  80177f:	55                   	push   %ebp
  801780:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801782:	6a 00                	push   $0x0
  801784:	6a 00                	push   $0x0
  801786:	6a 00                	push   $0x0
  801788:	6a 00                	push   $0x0
  80178a:	ff 75 08             	pushl  0x8(%ebp)
  80178d:	6a 29                	push   $0x29
  80178f:	e8 fc fa ff ff       	call   801290 <syscall>
  801794:	83 c4 18             	add    $0x18,%esp
	return ;
  801797:	90                   	nop
}
  801798:	c9                   	leave  
  801799:	c3                   	ret    

0080179a <inctst>:

void inctst()
{
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 2a                	push   $0x2a
  8017a9:	e8 e2 fa ff ff       	call   801290 <syscall>
  8017ae:	83 c4 18             	add    $0x18,%esp
	return ;
  8017b1:	90                   	nop
}
  8017b2:	c9                   	leave  
  8017b3:	c3                   	ret    

008017b4 <gettst>:
uint32 gettst()
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 2b                	push   $0x2b
  8017c3:	e8 c8 fa ff ff       	call   801290 <syscall>
  8017c8:	83 c4 18             	add    $0x18,%esp
}
  8017cb:	c9                   	leave  
  8017cc:	c3                   	ret    

008017cd <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8017cd:	55                   	push   %ebp
  8017ce:	89 e5                	mov    %esp,%ebp
  8017d0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	6a 00                	push   $0x0
  8017dd:	6a 2c                	push   $0x2c
  8017df:	e8 ac fa ff ff       	call   801290 <syscall>
  8017e4:	83 c4 18             	add    $0x18,%esp
  8017e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8017ea:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8017ee:	75 07                	jne    8017f7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8017f0:	b8 01 00 00 00       	mov    $0x1,%eax
  8017f5:	eb 05                	jmp    8017fc <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8017f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017fc:	c9                   	leave  
  8017fd:	c3                   	ret    

008017fe <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
  801801:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	6a 2c                	push   $0x2c
  801810:	e8 7b fa ff ff       	call   801290 <syscall>
  801815:	83 c4 18             	add    $0x18,%esp
  801818:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80181b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80181f:	75 07                	jne    801828 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801821:	b8 01 00 00 00       	mov    $0x1,%eax
  801826:	eb 05                	jmp    80182d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801828:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80182d:	c9                   	leave  
  80182e:	c3                   	ret    

0080182f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80182f:	55                   	push   %ebp
  801830:	89 e5                	mov    %esp,%ebp
  801832:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	6a 2c                	push   $0x2c
  801841:	e8 4a fa ff ff       	call   801290 <syscall>
  801846:	83 c4 18             	add    $0x18,%esp
  801849:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80184c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801850:	75 07                	jne    801859 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801852:	b8 01 00 00 00       	mov    $0x1,%eax
  801857:	eb 05                	jmp    80185e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801859:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80185e:	c9                   	leave  
  80185f:	c3                   	ret    

00801860 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
  801863:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 2c                	push   $0x2c
  801872:	e8 19 fa ff ff       	call   801290 <syscall>
  801877:	83 c4 18             	add    $0x18,%esp
  80187a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80187d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801881:	75 07                	jne    80188a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801883:	b8 01 00 00 00       	mov    $0x1,%eax
  801888:	eb 05                	jmp    80188f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80188a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80188f:	c9                   	leave  
  801890:	c3                   	ret    

00801891 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	ff 75 08             	pushl  0x8(%ebp)
  80189f:	6a 2d                	push   $0x2d
  8018a1:	e8 ea f9 ff ff       	call   801290 <syscall>
  8018a6:	83 c4 18             	add    $0x18,%esp
	return ;
  8018a9:	90                   	nop
}
  8018aa:	c9                   	leave  
  8018ab:	c3                   	ret    

008018ac <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
  8018af:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8018b0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018b3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bc:	6a 00                	push   $0x0
  8018be:	53                   	push   %ebx
  8018bf:	51                   	push   %ecx
  8018c0:	52                   	push   %edx
  8018c1:	50                   	push   %eax
  8018c2:	6a 2e                	push   $0x2e
  8018c4:	e8 c7 f9 ff ff       	call   801290 <syscall>
  8018c9:	83 c4 18             	add    $0x18,%esp
}
  8018cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018cf:	c9                   	leave  
  8018d0:	c3                   	ret    

008018d1 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8018d1:	55                   	push   %ebp
  8018d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8018d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	52                   	push   %edx
  8018e1:	50                   	push   %eax
  8018e2:	6a 2f                	push   $0x2f
  8018e4:	e8 a7 f9 ff ff       	call   801290 <syscall>
  8018e9:	83 c4 18             	add    $0x18,%esp
}
  8018ec:	c9                   	leave  
  8018ed:	c3                   	ret    

008018ee <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8018ee:	55                   	push   %ebp
  8018ef:	89 e5                	mov    %esp,%ebp
  8018f1:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8018f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8018f7:	89 d0                	mov    %edx,%eax
  8018f9:	c1 e0 02             	shl    $0x2,%eax
  8018fc:	01 d0                	add    %edx,%eax
  8018fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801905:	01 d0                	add    %edx,%eax
  801907:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80190e:	01 d0                	add    %edx,%eax
  801910:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801917:	01 d0                	add    %edx,%eax
  801919:	c1 e0 04             	shl    $0x4,%eax
  80191c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80191f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801926:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801929:	83 ec 0c             	sub    $0xc,%esp
  80192c:	50                   	push   %eax
  80192d:	e8 76 fd ff ff       	call   8016a8 <sys_get_virtual_time>
  801932:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801935:	eb 41                	jmp    801978 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801937:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80193a:	83 ec 0c             	sub    $0xc,%esp
  80193d:	50                   	push   %eax
  80193e:	e8 65 fd ff ff       	call   8016a8 <sys_get_virtual_time>
  801943:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801946:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801949:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80194c:	29 c2                	sub    %eax,%edx
  80194e:	89 d0                	mov    %edx,%eax
  801950:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801953:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801956:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801959:	89 d1                	mov    %edx,%ecx
  80195b:	29 c1                	sub    %eax,%ecx
  80195d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801960:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801963:	39 c2                	cmp    %eax,%edx
  801965:	0f 97 c0             	seta   %al
  801968:	0f b6 c0             	movzbl %al,%eax
  80196b:	29 c1                	sub    %eax,%ecx
  80196d:	89 c8                	mov    %ecx,%eax
  80196f:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801972:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801975:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801978:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80197b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80197e:	72 b7                	jb     801937 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801980:	90                   	nop
  801981:	c9                   	leave  
  801982:	c3                   	ret    

00801983 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
  801986:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801989:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801990:	eb 03                	jmp    801995 <busy_wait+0x12>
  801992:	ff 45 fc             	incl   -0x4(%ebp)
  801995:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801998:	3b 45 08             	cmp    0x8(%ebp),%eax
  80199b:	72 f5                	jb     801992 <busy_wait+0xf>
	return i;
  80199d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8019a0:	c9                   	leave  
  8019a1:	c3                   	ret    
  8019a2:	66 90                	xchg   %ax,%ax

008019a4 <__udivdi3>:
  8019a4:	55                   	push   %ebp
  8019a5:	57                   	push   %edi
  8019a6:	56                   	push   %esi
  8019a7:	53                   	push   %ebx
  8019a8:	83 ec 1c             	sub    $0x1c,%esp
  8019ab:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8019af:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8019b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019b7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019bb:	89 ca                	mov    %ecx,%edx
  8019bd:	89 f8                	mov    %edi,%eax
  8019bf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8019c3:	85 f6                	test   %esi,%esi
  8019c5:	75 2d                	jne    8019f4 <__udivdi3+0x50>
  8019c7:	39 cf                	cmp    %ecx,%edi
  8019c9:	77 65                	ja     801a30 <__udivdi3+0x8c>
  8019cb:	89 fd                	mov    %edi,%ebp
  8019cd:	85 ff                	test   %edi,%edi
  8019cf:	75 0b                	jne    8019dc <__udivdi3+0x38>
  8019d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8019d6:	31 d2                	xor    %edx,%edx
  8019d8:	f7 f7                	div    %edi
  8019da:	89 c5                	mov    %eax,%ebp
  8019dc:	31 d2                	xor    %edx,%edx
  8019de:	89 c8                	mov    %ecx,%eax
  8019e0:	f7 f5                	div    %ebp
  8019e2:	89 c1                	mov    %eax,%ecx
  8019e4:	89 d8                	mov    %ebx,%eax
  8019e6:	f7 f5                	div    %ebp
  8019e8:	89 cf                	mov    %ecx,%edi
  8019ea:	89 fa                	mov    %edi,%edx
  8019ec:	83 c4 1c             	add    $0x1c,%esp
  8019ef:	5b                   	pop    %ebx
  8019f0:	5e                   	pop    %esi
  8019f1:	5f                   	pop    %edi
  8019f2:	5d                   	pop    %ebp
  8019f3:	c3                   	ret    
  8019f4:	39 ce                	cmp    %ecx,%esi
  8019f6:	77 28                	ja     801a20 <__udivdi3+0x7c>
  8019f8:	0f bd fe             	bsr    %esi,%edi
  8019fb:	83 f7 1f             	xor    $0x1f,%edi
  8019fe:	75 40                	jne    801a40 <__udivdi3+0x9c>
  801a00:	39 ce                	cmp    %ecx,%esi
  801a02:	72 0a                	jb     801a0e <__udivdi3+0x6a>
  801a04:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a08:	0f 87 9e 00 00 00    	ja     801aac <__udivdi3+0x108>
  801a0e:	b8 01 00 00 00       	mov    $0x1,%eax
  801a13:	89 fa                	mov    %edi,%edx
  801a15:	83 c4 1c             	add    $0x1c,%esp
  801a18:	5b                   	pop    %ebx
  801a19:	5e                   	pop    %esi
  801a1a:	5f                   	pop    %edi
  801a1b:	5d                   	pop    %ebp
  801a1c:	c3                   	ret    
  801a1d:	8d 76 00             	lea    0x0(%esi),%esi
  801a20:	31 ff                	xor    %edi,%edi
  801a22:	31 c0                	xor    %eax,%eax
  801a24:	89 fa                	mov    %edi,%edx
  801a26:	83 c4 1c             	add    $0x1c,%esp
  801a29:	5b                   	pop    %ebx
  801a2a:	5e                   	pop    %esi
  801a2b:	5f                   	pop    %edi
  801a2c:	5d                   	pop    %ebp
  801a2d:	c3                   	ret    
  801a2e:	66 90                	xchg   %ax,%ax
  801a30:	89 d8                	mov    %ebx,%eax
  801a32:	f7 f7                	div    %edi
  801a34:	31 ff                	xor    %edi,%edi
  801a36:	89 fa                	mov    %edi,%edx
  801a38:	83 c4 1c             	add    $0x1c,%esp
  801a3b:	5b                   	pop    %ebx
  801a3c:	5e                   	pop    %esi
  801a3d:	5f                   	pop    %edi
  801a3e:	5d                   	pop    %ebp
  801a3f:	c3                   	ret    
  801a40:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a45:	89 eb                	mov    %ebp,%ebx
  801a47:	29 fb                	sub    %edi,%ebx
  801a49:	89 f9                	mov    %edi,%ecx
  801a4b:	d3 e6                	shl    %cl,%esi
  801a4d:	89 c5                	mov    %eax,%ebp
  801a4f:	88 d9                	mov    %bl,%cl
  801a51:	d3 ed                	shr    %cl,%ebp
  801a53:	89 e9                	mov    %ebp,%ecx
  801a55:	09 f1                	or     %esi,%ecx
  801a57:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a5b:	89 f9                	mov    %edi,%ecx
  801a5d:	d3 e0                	shl    %cl,%eax
  801a5f:	89 c5                	mov    %eax,%ebp
  801a61:	89 d6                	mov    %edx,%esi
  801a63:	88 d9                	mov    %bl,%cl
  801a65:	d3 ee                	shr    %cl,%esi
  801a67:	89 f9                	mov    %edi,%ecx
  801a69:	d3 e2                	shl    %cl,%edx
  801a6b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a6f:	88 d9                	mov    %bl,%cl
  801a71:	d3 e8                	shr    %cl,%eax
  801a73:	09 c2                	or     %eax,%edx
  801a75:	89 d0                	mov    %edx,%eax
  801a77:	89 f2                	mov    %esi,%edx
  801a79:	f7 74 24 0c          	divl   0xc(%esp)
  801a7d:	89 d6                	mov    %edx,%esi
  801a7f:	89 c3                	mov    %eax,%ebx
  801a81:	f7 e5                	mul    %ebp
  801a83:	39 d6                	cmp    %edx,%esi
  801a85:	72 19                	jb     801aa0 <__udivdi3+0xfc>
  801a87:	74 0b                	je     801a94 <__udivdi3+0xf0>
  801a89:	89 d8                	mov    %ebx,%eax
  801a8b:	31 ff                	xor    %edi,%edi
  801a8d:	e9 58 ff ff ff       	jmp    8019ea <__udivdi3+0x46>
  801a92:	66 90                	xchg   %ax,%ax
  801a94:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a98:	89 f9                	mov    %edi,%ecx
  801a9a:	d3 e2                	shl    %cl,%edx
  801a9c:	39 c2                	cmp    %eax,%edx
  801a9e:	73 e9                	jae    801a89 <__udivdi3+0xe5>
  801aa0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801aa3:	31 ff                	xor    %edi,%edi
  801aa5:	e9 40 ff ff ff       	jmp    8019ea <__udivdi3+0x46>
  801aaa:	66 90                	xchg   %ax,%ax
  801aac:	31 c0                	xor    %eax,%eax
  801aae:	e9 37 ff ff ff       	jmp    8019ea <__udivdi3+0x46>
  801ab3:	90                   	nop

00801ab4 <__umoddi3>:
  801ab4:	55                   	push   %ebp
  801ab5:	57                   	push   %edi
  801ab6:	56                   	push   %esi
  801ab7:	53                   	push   %ebx
  801ab8:	83 ec 1c             	sub    $0x1c,%esp
  801abb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801abf:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ac3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ac7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801acb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801acf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ad3:	89 f3                	mov    %esi,%ebx
  801ad5:	89 fa                	mov    %edi,%edx
  801ad7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801adb:	89 34 24             	mov    %esi,(%esp)
  801ade:	85 c0                	test   %eax,%eax
  801ae0:	75 1a                	jne    801afc <__umoddi3+0x48>
  801ae2:	39 f7                	cmp    %esi,%edi
  801ae4:	0f 86 a2 00 00 00    	jbe    801b8c <__umoddi3+0xd8>
  801aea:	89 c8                	mov    %ecx,%eax
  801aec:	89 f2                	mov    %esi,%edx
  801aee:	f7 f7                	div    %edi
  801af0:	89 d0                	mov    %edx,%eax
  801af2:	31 d2                	xor    %edx,%edx
  801af4:	83 c4 1c             	add    $0x1c,%esp
  801af7:	5b                   	pop    %ebx
  801af8:	5e                   	pop    %esi
  801af9:	5f                   	pop    %edi
  801afa:	5d                   	pop    %ebp
  801afb:	c3                   	ret    
  801afc:	39 f0                	cmp    %esi,%eax
  801afe:	0f 87 ac 00 00 00    	ja     801bb0 <__umoddi3+0xfc>
  801b04:	0f bd e8             	bsr    %eax,%ebp
  801b07:	83 f5 1f             	xor    $0x1f,%ebp
  801b0a:	0f 84 ac 00 00 00    	je     801bbc <__umoddi3+0x108>
  801b10:	bf 20 00 00 00       	mov    $0x20,%edi
  801b15:	29 ef                	sub    %ebp,%edi
  801b17:	89 fe                	mov    %edi,%esi
  801b19:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b1d:	89 e9                	mov    %ebp,%ecx
  801b1f:	d3 e0                	shl    %cl,%eax
  801b21:	89 d7                	mov    %edx,%edi
  801b23:	89 f1                	mov    %esi,%ecx
  801b25:	d3 ef                	shr    %cl,%edi
  801b27:	09 c7                	or     %eax,%edi
  801b29:	89 e9                	mov    %ebp,%ecx
  801b2b:	d3 e2                	shl    %cl,%edx
  801b2d:	89 14 24             	mov    %edx,(%esp)
  801b30:	89 d8                	mov    %ebx,%eax
  801b32:	d3 e0                	shl    %cl,%eax
  801b34:	89 c2                	mov    %eax,%edx
  801b36:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b3a:	d3 e0                	shl    %cl,%eax
  801b3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b40:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b44:	89 f1                	mov    %esi,%ecx
  801b46:	d3 e8                	shr    %cl,%eax
  801b48:	09 d0                	or     %edx,%eax
  801b4a:	d3 eb                	shr    %cl,%ebx
  801b4c:	89 da                	mov    %ebx,%edx
  801b4e:	f7 f7                	div    %edi
  801b50:	89 d3                	mov    %edx,%ebx
  801b52:	f7 24 24             	mull   (%esp)
  801b55:	89 c6                	mov    %eax,%esi
  801b57:	89 d1                	mov    %edx,%ecx
  801b59:	39 d3                	cmp    %edx,%ebx
  801b5b:	0f 82 87 00 00 00    	jb     801be8 <__umoddi3+0x134>
  801b61:	0f 84 91 00 00 00    	je     801bf8 <__umoddi3+0x144>
  801b67:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b6b:	29 f2                	sub    %esi,%edx
  801b6d:	19 cb                	sbb    %ecx,%ebx
  801b6f:	89 d8                	mov    %ebx,%eax
  801b71:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b75:	d3 e0                	shl    %cl,%eax
  801b77:	89 e9                	mov    %ebp,%ecx
  801b79:	d3 ea                	shr    %cl,%edx
  801b7b:	09 d0                	or     %edx,%eax
  801b7d:	89 e9                	mov    %ebp,%ecx
  801b7f:	d3 eb                	shr    %cl,%ebx
  801b81:	89 da                	mov    %ebx,%edx
  801b83:	83 c4 1c             	add    $0x1c,%esp
  801b86:	5b                   	pop    %ebx
  801b87:	5e                   	pop    %esi
  801b88:	5f                   	pop    %edi
  801b89:	5d                   	pop    %ebp
  801b8a:	c3                   	ret    
  801b8b:	90                   	nop
  801b8c:	89 fd                	mov    %edi,%ebp
  801b8e:	85 ff                	test   %edi,%edi
  801b90:	75 0b                	jne    801b9d <__umoddi3+0xe9>
  801b92:	b8 01 00 00 00       	mov    $0x1,%eax
  801b97:	31 d2                	xor    %edx,%edx
  801b99:	f7 f7                	div    %edi
  801b9b:	89 c5                	mov    %eax,%ebp
  801b9d:	89 f0                	mov    %esi,%eax
  801b9f:	31 d2                	xor    %edx,%edx
  801ba1:	f7 f5                	div    %ebp
  801ba3:	89 c8                	mov    %ecx,%eax
  801ba5:	f7 f5                	div    %ebp
  801ba7:	89 d0                	mov    %edx,%eax
  801ba9:	e9 44 ff ff ff       	jmp    801af2 <__umoddi3+0x3e>
  801bae:	66 90                	xchg   %ax,%ax
  801bb0:	89 c8                	mov    %ecx,%eax
  801bb2:	89 f2                	mov    %esi,%edx
  801bb4:	83 c4 1c             	add    $0x1c,%esp
  801bb7:	5b                   	pop    %ebx
  801bb8:	5e                   	pop    %esi
  801bb9:	5f                   	pop    %edi
  801bba:	5d                   	pop    %ebp
  801bbb:	c3                   	ret    
  801bbc:	3b 04 24             	cmp    (%esp),%eax
  801bbf:	72 06                	jb     801bc7 <__umoddi3+0x113>
  801bc1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801bc5:	77 0f                	ja     801bd6 <__umoddi3+0x122>
  801bc7:	89 f2                	mov    %esi,%edx
  801bc9:	29 f9                	sub    %edi,%ecx
  801bcb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801bcf:	89 14 24             	mov    %edx,(%esp)
  801bd2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bd6:	8b 44 24 04          	mov    0x4(%esp),%eax
  801bda:	8b 14 24             	mov    (%esp),%edx
  801bdd:	83 c4 1c             	add    $0x1c,%esp
  801be0:	5b                   	pop    %ebx
  801be1:	5e                   	pop    %esi
  801be2:	5f                   	pop    %edi
  801be3:	5d                   	pop    %ebp
  801be4:	c3                   	ret    
  801be5:	8d 76 00             	lea    0x0(%esi),%esi
  801be8:	2b 04 24             	sub    (%esp),%eax
  801beb:	19 fa                	sbb    %edi,%edx
  801bed:	89 d1                	mov    %edx,%ecx
  801bef:	89 c6                	mov    %eax,%esi
  801bf1:	e9 71 ff ff ff       	jmp    801b67 <__umoddi3+0xb3>
  801bf6:	66 90                	xchg   %ax,%ax
  801bf8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801bfc:	72 ea                	jb     801be8 <__umoddi3+0x134>
  801bfe:	89 d9                	mov    %ebx,%ecx
  801c00:	e9 62 ff ff ff       	jmp    801b67 <__umoddi3+0xb3>
