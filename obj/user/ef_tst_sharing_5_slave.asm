
obj/user/ef_tst_sharing_5_slave:     file format elf32-i386


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
  800031:	e8 e9 00 00 00       	call   80011f <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003e:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800042:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800049:	eb 29                	jmp    800074 <_main+0x3c>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004b:	a1 20 40 80 00       	mov    0x804020,%eax
  800050:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800056:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800059:	89 d0                	mov    %edx,%eax
  80005b:	01 c0                	add    %eax,%eax
  80005d:	01 d0                	add    %edx,%eax
  80005f:	c1 e0 03             	shl    $0x3,%eax
  800062:	01 c8                	add    %ecx,%eax
  800064:	8a 40 04             	mov    0x4(%eax),%al
  800067:	84 c0                	test   %al,%al
  800069:	74 06                	je     800071 <_main+0x39>
			{
				fullWS = 0;
  80006b:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80006f:	eb 12                	jmp    800083 <_main+0x4b>
_main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800071:	ff 45 f0             	incl   -0x10(%ebp)
  800074:	a1 20 40 80 00       	mov    0x804020,%eax
  800079:	8b 50 74             	mov    0x74(%eax),%edx
  80007c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80007f:	39 c2                	cmp    %eax,%edx
  800081:	77 c8                	ja     80004b <_main+0x13>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800083:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800087:	74 14                	je     80009d <_main+0x65>
  800089:	83 ec 04             	sub    $0x4,%esp
  80008c:	68 00 32 80 00       	push   $0x803200
  800091:	6a 12                	push   $0x12
  800093:	68 1c 32 80 00       	push   $0x80321c
  800098:	e8 be 01 00 00       	call   80025b <_panic>
	}

	uint32 *x;
	x = sget(sys_getparentenvid(),"x");
  80009d:	e8 1e 1b 00 00       	call   801bc0 <sys_getparentenvid>
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	68 3a 32 80 00       	push   $0x80323a
  8000aa:	50                   	push   %eax
  8000ab:	e8 f2 15 00 00       	call   8016a2 <sget>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  8000b6:	e8 0c 18 00 00       	call   8018c7 <sys_calculate_free_frames>
  8000bb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	cprintf("Slave env used x (getSharedObject)\n");
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	68 3c 32 80 00       	push   $0x80323c
  8000c6:	e8 44 04 00 00       	call   80050f <cprintf>
  8000cb:	83 c4 10             	add    $0x10,%esp

	sfree(x);
  8000ce:	83 ec 0c             	sub    $0xc,%esp
  8000d1:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d4:	e8 8e 16 00 00       	call   801767 <sfree>
  8000d9:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave env removed x\n");
  8000dc:	83 ec 0c             	sub    $0xc,%esp
  8000df:	68 60 32 80 00       	push   $0x803260
  8000e4:	e8 26 04 00 00       	call   80050f <cprintf>
  8000e9:	83 c4 10             	add    $0x10,%esp

	int diff = (sys_calculate_free_frames() - freeFrames);
  8000ec:	e8 d6 17 00 00       	call   8018c7 <sys_calculate_free_frames>
  8000f1:	89 c2                	mov    %eax,%edx
  8000f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f6:	29 c2                	sub    %eax,%edx
  8000f8:	89 d0                	mov    %edx,%eax
  8000fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (diff != 1) panic("wrong free: frames removed not equal 1 !, correct frames to be removed is 1:\nfrom the env: 1 table for x\nframes_storage: not cleared yet\n");
  8000fd:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  800101:	74 14                	je     800117 <_main+0xdf>
  800103:	83 ec 04             	sub    $0x4,%esp
  800106:	68 78 32 80 00       	push   $0x803278
  80010b:	6a 1f                	push   $0x1f
  80010d:	68 1c 32 80 00       	push   $0x80321c
  800112:	e8 44 01 00 00       	call   80025b <_panic>

	//to ensure that this environment is completed successfully
	inctst();
  800117:	e8 c9 1b 00 00       	call   801ce5 <inctst>

	return;
  80011c:	90                   	nop
}
  80011d:	c9                   	leave  
  80011e:	c3                   	ret    

0080011f <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80011f:	55                   	push   %ebp
  800120:	89 e5                	mov    %esp,%ebp
  800122:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800125:	e8 7d 1a 00 00       	call   801ba7 <sys_getenvindex>
  80012a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80012d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800130:	89 d0                	mov    %edx,%eax
  800132:	c1 e0 03             	shl    $0x3,%eax
  800135:	01 d0                	add    %edx,%eax
  800137:	01 c0                	add    %eax,%eax
  800139:	01 d0                	add    %edx,%eax
  80013b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800142:	01 d0                	add    %edx,%eax
  800144:	c1 e0 04             	shl    $0x4,%eax
  800147:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80014c:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800151:	a1 20 40 80 00       	mov    0x804020,%eax
  800156:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80015c:	84 c0                	test   %al,%al
  80015e:	74 0f                	je     80016f <libmain+0x50>
		binaryname = myEnv->prog_name;
  800160:	a1 20 40 80 00       	mov    0x804020,%eax
  800165:	05 5c 05 00 00       	add    $0x55c,%eax
  80016a:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80016f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800173:	7e 0a                	jle    80017f <libmain+0x60>
		binaryname = argv[0];
  800175:	8b 45 0c             	mov    0xc(%ebp),%eax
  800178:	8b 00                	mov    (%eax),%eax
  80017a:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80017f:	83 ec 08             	sub    $0x8,%esp
  800182:	ff 75 0c             	pushl  0xc(%ebp)
  800185:	ff 75 08             	pushl  0x8(%ebp)
  800188:	e8 ab fe ff ff       	call   800038 <_main>
  80018d:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800190:	e8 1f 18 00 00       	call   8019b4 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800195:	83 ec 0c             	sub    $0xc,%esp
  800198:	68 1c 33 80 00       	push   $0x80331c
  80019d:	e8 6d 03 00 00       	call   80050f <cprintf>
  8001a2:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001a5:	a1 20 40 80 00       	mov    0x804020,%eax
  8001aa:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001b0:	a1 20 40 80 00       	mov    0x804020,%eax
  8001b5:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001bb:	83 ec 04             	sub    $0x4,%esp
  8001be:	52                   	push   %edx
  8001bf:	50                   	push   %eax
  8001c0:	68 44 33 80 00       	push   $0x803344
  8001c5:	e8 45 03 00 00       	call   80050f <cprintf>
  8001ca:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001cd:	a1 20 40 80 00       	mov    0x804020,%eax
  8001d2:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8001d8:	a1 20 40 80 00       	mov    0x804020,%eax
  8001dd:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8001e3:	a1 20 40 80 00       	mov    0x804020,%eax
  8001e8:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8001ee:	51                   	push   %ecx
  8001ef:	52                   	push   %edx
  8001f0:	50                   	push   %eax
  8001f1:	68 6c 33 80 00       	push   $0x80336c
  8001f6:	e8 14 03 00 00       	call   80050f <cprintf>
  8001fb:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001fe:	a1 20 40 80 00       	mov    0x804020,%eax
  800203:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800209:	83 ec 08             	sub    $0x8,%esp
  80020c:	50                   	push   %eax
  80020d:	68 c4 33 80 00       	push   $0x8033c4
  800212:	e8 f8 02 00 00       	call   80050f <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	68 1c 33 80 00       	push   $0x80331c
  800222:	e8 e8 02 00 00       	call   80050f <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80022a:	e8 9f 17 00 00       	call   8019ce <sys_enable_interrupt>

	// exit gracefully
	exit();
  80022f:	e8 19 00 00 00       	call   80024d <exit>
}
  800234:	90                   	nop
  800235:	c9                   	leave  
  800236:	c3                   	ret    

00800237 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800237:	55                   	push   %ebp
  800238:	89 e5                	mov    %esp,%ebp
  80023a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80023d:	83 ec 0c             	sub    $0xc,%esp
  800240:	6a 00                	push   $0x0
  800242:	e8 2c 19 00 00       	call   801b73 <sys_destroy_env>
  800247:	83 c4 10             	add    $0x10,%esp
}
  80024a:	90                   	nop
  80024b:	c9                   	leave  
  80024c:	c3                   	ret    

0080024d <exit>:

void
exit(void)
{
  80024d:	55                   	push   %ebp
  80024e:	89 e5                	mov    %esp,%ebp
  800250:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800253:	e8 81 19 00 00       	call   801bd9 <sys_exit_env>
}
  800258:	90                   	nop
  800259:	c9                   	leave  
  80025a:	c3                   	ret    

0080025b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80025b:	55                   	push   %ebp
  80025c:	89 e5                	mov    %esp,%ebp
  80025e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800261:	8d 45 10             	lea    0x10(%ebp),%eax
  800264:	83 c0 04             	add    $0x4,%eax
  800267:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80026a:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80026f:	85 c0                	test   %eax,%eax
  800271:	74 16                	je     800289 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800273:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800278:	83 ec 08             	sub    $0x8,%esp
  80027b:	50                   	push   %eax
  80027c:	68 d8 33 80 00       	push   $0x8033d8
  800281:	e8 89 02 00 00       	call   80050f <cprintf>
  800286:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800289:	a1 00 40 80 00       	mov    0x804000,%eax
  80028e:	ff 75 0c             	pushl  0xc(%ebp)
  800291:	ff 75 08             	pushl  0x8(%ebp)
  800294:	50                   	push   %eax
  800295:	68 dd 33 80 00       	push   $0x8033dd
  80029a:	e8 70 02 00 00       	call   80050f <cprintf>
  80029f:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a5:	83 ec 08             	sub    $0x8,%esp
  8002a8:	ff 75 f4             	pushl  -0xc(%ebp)
  8002ab:	50                   	push   %eax
  8002ac:	e8 f3 01 00 00       	call   8004a4 <vcprintf>
  8002b1:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002b4:	83 ec 08             	sub    $0x8,%esp
  8002b7:	6a 00                	push   $0x0
  8002b9:	68 f9 33 80 00       	push   $0x8033f9
  8002be:	e8 e1 01 00 00       	call   8004a4 <vcprintf>
  8002c3:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002c6:	e8 82 ff ff ff       	call   80024d <exit>

	// should not return here
	while (1) ;
  8002cb:	eb fe                	jmp    8002cb <_panic+0x70>

008002cd <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002cd:	55                   	push   %ebp
  8002ce:	89 e5                	mov    %esp,%ebp
  8002d0:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002d3:	a1 20 40 80 00       	mov    0x804020,%eax
  8002d8:	8b 50 74             	mov    0x74(%eax),%edx
  8002db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002de:	39 c2                	cmp    %eax,%edx
  8002e0:	74 14                	je     8002f6 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002e2:	83 ec 04             	sub    $0x4,%esp
  8002e5:	68 fc 33 80 00       	push   $0x8033fc
  8002ea:	6a 26                	push   $0x26
  8002ec:	68 48 34 80 00       	push   $0x803448
  8002f1:	e8 65 ff ff ff       	call   80025b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8002f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8002fd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800304:	e9 c2 00 00 00       	jmp    8003cb <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800309:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80030c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800313:	8b 45 08             	mov    0x8(%ebp),%eax
  800316:	01 d0                	add    %edx,%eax
  800318:	8b 00                	mov    (%eax),%eax
  80031a:	85 c0                	test   %eax,%eax
  80031c:	75 08                	jne    800326 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80031e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800321:	e9 a2 00 00 00       	jmp    8003c8 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800326:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80032d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800334:	eb 69                	jmp    80039f <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800336:	a1 20 40 80 00       	mov    0x804020,%eax
  80033b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800341:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800344:	89 d0                	mov    %edx,%eax
  800346:	01 c0                	add    %eax,%eax
  800348:	01 d0                	add    %edx,%eax
  80034a:	c1 e0 03             	shl    $0x3,%eax
  80034d:	01 c8                	add    %ecx,%eax
  80034f:	8a 40 04             	mov    0x4(%eax),%al
  800352:	84 c0                	test   %al,%al
  800354:	75 46                	jne    80039c <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800356:	a1 20 40 80 00       	mov    0x804020,%eax
  80035b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800361:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800364:	89 d0                	mov    %edx,%eax
  800366:	01 c0                	add    %eax,%eax
  800368:	01 d0                	add    %edx,%eax
  80036a:	c1 e0 03             	shl    $0x3,%eax
  80036d:	01 c8                	add    %ecx,%eax
  80036f:	8b 00                	mov    (%eax),%eax
  800371:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800374:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800377:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80037c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80037e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800381:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800388:	8b 45 08             	mov    0x8(%ebp),%eax
  80038b:	01 c8                	add    %ecx,%eax
  80038d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80038f:	39 c2                	cmp    %eax,%edx
  800391:	75 09                	jne    80039c <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800393:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80039a:	eb 12                	jmp    8003ae <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80039c:	ff 45 e8             	incl   -0x18(%ebp)
  80039f:	a1 20 40 80 00       	mov    0x804020,%eax
  8003a4:	8b 50 74             	mov    0x74(%eax),%edx
  8003a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003aa:	39 c2                	cmp    %eax,%edx
  8003ac:	77 88                	ja     800336 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003ae:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003b2:	75 14                	jne    8003c8 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003b4:	83 ec 04             	sub    $0x4,%esp
  8003b7:	68 54 34 80 00       	push   $0x803454
  8003bc:	6a 3a                	push   $0x3a
  8003be:	68 48 34 80 00       	push   $0x803448
  8003c3:	e8 93 fe ff ff       	call   80025b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003c8:	ff 45 f0             	incl   -0x10(%ebp)
  8003cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ce:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003d1:	0f 8c 32 ff ff ff    	jl     800309 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003d7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003de:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003e5:	eb 26                	jmp    80040d <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8003e7:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ec:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003f2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003f5:	89 d0                	mov    %edx,%eax
  8003f7:	01 c0                	add    %eax,%eax
  8003f9:	01 d0                	add    %edx,%eax
  8003fb:	c1 e0 03             	shl    $0x3,%eax
  8003fe:	01 c8                	add    %ecx,%eax
  800400:	8a 40 04             	mov    0x4(%eax),%al
  800403:	3c 01                	cmp    $0x1,%al
  800405:	75 03                	jne    80040a <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800407:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80040a:	ff 45 e0             	incl   -0x20(%ebp)
  80040d:	a1 20 40 80 00       	mov    0x804020,%eax
  800412:	8b 50 74             	mov    0x74(%eax),%edx
  800415:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800418:	39 c2                	cmp    %eax,%edx
  80041a:	77 cb                	ja     8003e7 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80041c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80041f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800422:	74 14                	je     800438 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800424:	83 ec 04             	sub    $0x4,%esp
  800427:	68 a8 34 80 00       	push   $0x8034a8
  80042c:	6a 44                	push   $0x44
  80042e:	68 48 34 80 00       	push   $0x803448
  800433:	e8 23 fe ff ff       	call   80025b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800438:	90                   	nop
  800439:	c9                   	leave  
  80043a:	c3                   	ret    

0080043b <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80043b:	55                   	push   %ebp
  80043c:	89 e5                	mov    %esp,%ebp
  80043e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800441:	8b 45 0c             	mov    0xc(%ebp),%eax
  800444:	8b 00                	mov    (%eax),%eax
  800446:	8d 48 01             	lea    0x1(%eax),%ecx
  800449:	8b 55 0c             	mov    0xc(%ebp),%edx
  80044c:	89 0a                	mov    %ecx,(%edx)
  80044e:	8b 55 08             	mov    0x8(%ebp),%edx
  800451:	88 d1                	mov    %dl,%cl
  800453:	8b 55 0c             	mov    0xc(%ebp),%edx
  800456:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80045a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80045d:	8b 00                	mov    (%eax),%eax
  80045f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800464:	75 2c                	jne    800492 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800466:	a0 24 40 80 00       	mov    0x804024,%al
  80046b:	0f b6 c0             	movzbl %al,%eax
  80046e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800471:	8b 12                	mov    (%edx),%edx
  800473:	89 d1                	mov    %edx,%ecx
  800475:	8b 55 0c             	mov    0xc(%ebp),%edx
  800478:	83 c2 08             	add    $0x8,%edx
  80047b:	83 ec 04             	sub    $0x4,%esp
  80047e:	50                   	push   %eax
  80047f:	51                   	push   %ecx
  800480:	52                   	push   %edx
  800481:	e8 80 13 00 00       	call   801806 <sys_cputs>
  800486:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800489:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800492:	8b 45 0c             	mov    0xc(%ebp),%eax
  800495:	8b 40 04             	mov    0x4(%eax),%eax
  800498:	8d 50 01             	lea    0x1(%eax),%edx
  80049b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049e:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004a1:	90                   	nop
  8004a2:	c9                   	leave  
  8004a3:	c3                   	ret    

008004a4 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004a4:	55                   	push   %ebp
  8004a5:	89 e5                	mov    %esp,%ebp
  8004a7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004ad:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004b4:	00 00 00 
	b.cnt = 0;
  8004b7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004be:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004c1:	ff 75 0c             	pushl  0xc(%ebp)
  8004c4:	ff 75 08             	pushl  0x8(%ebp)
  8004c7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004cd:	50                   	push   %eax
  8004ce:	68 3b 04 80 00       	push   $0x80043b
  8004d3:	e8 11 02 00 00       	call   8006e9 <vprintfmt>
  8004d8:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004db:	a0 24 40 80 00       	mov    0x804024,%al
  8004e0:	0f b6 c0             	movzbl %al,%eax
  8004e3:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8004e9:	83 ec 04             	sub    $0x4,%esp
  8004ec:	50                   	push   %eax
  8004ed:	52                   	push   %edx
  8004ee:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004f4:	83 c0 08             	add    $0x8,%eax
  8004f7:	50                   	push   %eax
  8004f8:	e8 09 13 00 00       	call   801806 <sys_cputs>
  8004fd:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800500:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800507:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80050d:	c9                   	leave  
  80050e:	c3                   	ret    

0080050f <cprintf>:

int cprintf(const char *fmt, ...) {
  80050f:	55                   	push   %ebp
  800510:	89 e5                	mov    %esp,%ebp
  800512:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800515:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80051c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80051f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800522:	8b 45 08             	mov    0x8(%ebp),%eax
  800525:	83 ec 08             	sub    $0x8,%esp
  800528:	ff 75 f4             	pushl  -0xc(%ebp)
  80052b:	50                   	push   %eax
  80052c:	e8 73 ff ff ff       	call   8004a4 <vcprintf>
  800531:	83 c4 10             	add    $0x10,%esp
  800534:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800537:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80053a:	c9                   	leave  
  80053b:	c3                   	ret    

0080053c <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80053c:	55                   	push   %ebp
  80053d:	89 e5                	mov    %esp,%ebp
  80053f:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800542:	e8 6d 14 00 00       	call   8019b4 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800547:	8d 45 0c             	lea    0xc(%ebp),%eax
  80054a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80054d:	8b 45 08             	mov    0x8(%ebp),%eax
  800550:	83 ec 08             	sub    $0x8,%esp
  800553:	ff 75 f4             	pushl  -0xc(%ebp)
  800556:	50                   	push   %eax
  800557:	e8 48 ff ff ff       	call   8004a4 <vcprintf>
  80055c:	83 c4 10             	add    $0x10,%esp
  80055f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800562:	e8 67 14 00 00       	call   8019ce <sys_enable_interrupt>
	return cnt;
  800567:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80056a:	c9                   	leave  
  80056b:	c3                   	ret    

0080056c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80056c:	55                   	push   %ebp
  80056d:	89 e5                	mov    %esp,%ebp
  80056f:	53                   	push   %ebx
  800570:	83 ec 14             	sub    $0x14,%esp
  800573:	8b 45 10             	mov    0x10(%ebp),%eax
  800576:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800579:	8b 45 14             	mov    0x14(%ebp),%eax
  80057c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80057f:	8b 45 18             	mov    0x18(%ebp),%eax
  800582:	ba 00 00 00 00       	mov    $0x0,%edx
  800587:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80058a:	77 55                	ja     8005e1 <printnum+0x75>
  80058c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80058f:	72 05                	jb     800596 <printnum+0x2a>
  800591:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800594:	77 4b                	ja     8005e1 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800596:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800599:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80059c:	8b 45 18             	mov    0x18(%ebp),%eax
  80059f:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a4:	52                   	push   %edx
  8005a5:	50                   	push   %eax
  8005a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8005a9:	ff 75 f0             	pushl  -0x10(%ebp)
  8005ac:	e8 cf 29 00 00       	call   802f80 <__udivdi3>
  8005b1:	83 c4 10             	add    $0x10,%esp
  8005b4:	83 ec 04             	sub    $0x4,%esp
  8005b7:	ff 75 20             	pushl  0x20(%ebp)
  8005ba:	53                   	push   %ebx
  8005bb:	ff 75 18             	pushl  0x18(%ebp)
  8005be:	52                   	push   %edx
  8005bf:	50                   	push   %eax
  8005c0:	ff 75 0c             	pushl  0xc(%ebp)
  8005c3:	ff 75 08             	pushl  0x8(%ebp)
  8005c6:	e8 a1 ff ff ff       	call   80056c <printnum>
  8005cb:	83 c4 20             	add    $0x20,%esp
  8005ce:	eb 1a                	jmp    8005ea <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005d0:	83 ec 08             	sub    $0x8,%esp
  8005d3:	ff 75 0c             	pushl  0xc(%ebp)
  8005d6:	ff 75 20             	pushl  0x20(%ebp)
  8005d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005dc:	ff d0                	call   *%eax
  8005de:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005e1:	ff 4d 1c             	decl   0x1c(%ebp)
  8005e4:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8005e8:	7f e6                	jg     8005d0 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005ea:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8005ed:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005f8:	53                   	push   %ebx
  8005f9:	51                   	push   %ecx
  8005fa:	52                   	push   %edx
  8005fb:	50                   	push   %eax
  8005fc:	e8 8f 2a 00 00       	call   803090 <__umoddi3>
  800601:	83 c4 10             	add    $0x10,%esp
  800604:	05 14 37 80 00       	add    $0x803714,%eax
  800609:	8a 00                	mov    (%eax),%al
  80060b:	0f be c0             	movsbl %al,%eax
  80060e:	83 ec 08             	sub    $0x8,%esp
  800611:	ff 75 0c             	pushl  0xc(%ebp)
  800614:	50                   	push   %eax
  800615:	8b 45 08             	mov    0x8(%ebp),%eax
  800618:	ff d0                	call   *%eax
  80061a:	83 c4 10             	add    $0x10,%esp
}
  80061d:	90                   	nop
  80061e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800621:	c9                   	leave  
  800622:	c3                   	ret    

00800623 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800623:	55                   	push   %ebp
  800624:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800626:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80062a:	7e 1c                	jle    800648 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80062c:	8b 45 08             	mov    0x8(%ebp),%eax
  80062f:	8b 00                	mov    (%eax),%eax
  800631:	8d 50 08             	lea    0x8(%eax),%edx
  800634:	8b 45 08             	mov    0x8(%ebp),%eax
  800637:	89 10                	mov    %edx,(%eax)
  800639:	8b 45 08             	mov    0x8(%ebp),%eax
  80063c:	8b 00                	mov    (%eax),%eax
  80063e:	83 e8 08             	sub    $0x8,%eax
  800641:	8b 50 04             	mov    0x4(%eax),%edx
  800644:	8b 00                	mov    (%eax),%eax
  800646:	eb 40                	jmp    800688 <getuint+0x65>
	else if (lflag)
  800648:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80064c:	74 1e                	je     80066c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80064e:	8b 45 08             	mov    0x8(%ebp),%eax
  800651:	8b 00                	mov    (%eax),%eax
  800653:	8d 50 04             	lea    0x4(%eax),%edx
  800656:	8b 45 08             	mov    0x8(%ebp),%eax
  800659:	89 10                	mov    %edx,(%eax)
  80065b:	8b 45 08             	mov    0x8(%ebp),%eax
  80065e:	8b 00                	mov    (%eax),%eax
  800660:	83 e8 04             	sub    $0x4,%eax
  800663:	8b 00                	mov    (%eax),%eax
  800665:	ba 00 00 00 00       	mov    $0x0,%edx
  80066a:	eb 1c                	jmp    800688 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80066c:	8b 45 08             	mov    0x8(%ebp),%eax
  80066f:	8b 00                	mov    (%eax),%eax
  800671:	8d 50 04             	lea    0x4(%eax),%edx
  800674:	8b 45 08             	mov    0x8(%ebp),%eax
  800677:	89 10                	mov    %edx,(%eax)
  800679:	8b 45 08             	mov    0x8(%ebp),%eax
  80067c:	8b 00                	mov    (%eax),%eax
  80067e:	83 e8 04             	sub    $0x4,%eax
  800681:	8b 00                	mov    (%eax),%eax
  800683:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800688:	5d                   	pop    %ebp
  800689:	c3                   	ret    

0080068a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80068a:	55                   	push   %ebp
  80068b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80068d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800691:	7e 1c                	jle    8006af <getint+0x25>
		return va_arg(*ap, long long);
  800693:	8b 45 08             	mov    0x8(%ebp),%eax
  800696:	8b 00                	mov    (%eax),%eax
  800698:	8d 50 08             	lea    0x8(%eax),%edx
  80069b:	8b 45 08             	mov    0x8(%ebp),%eax
  80069e:	89 10                	mov    %edx,(%eax)
  8006a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a3:	8b 00                	mov    (%eax),%eax
  8006a5:	83 e8 08             	sub    $0x8,%eax
  8006a8:	8b 50 04             	mov    0x4(%eax),%edx
  8006ab:	8b 00                	mov    (%eax),%eax
  8006ad:	eb 38                	jmp    8006e7 <getint+0x5d>
	else if (lflag)
  8006af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006b3:	74 1a                	je     8006cf <getint+0x45>
		return va_arg(*ap, long);
  8006b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b8:	8b 00                	mov    (%eax),%eax
  8006ba:	8d 50 04             	lea    0x4(%eax),%edx
  8006bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c0:	89 10                	mov    %edx,(%eax)
  8006c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c5:	8b 00                	mov    (%eax),%eax
  8006c7:	83 e8 04             	sub    $0x4,%eax
  8006ca:	8b 00                	mov    (%eax),%eax
  8006cc:	99                   	cltd   
  8006cd:	eb 18                	jmp    8006e7 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d2:	8b 00                	mov    (%eax),%eax
  8006d4:	8d 50 04             	lea    0x4(%eax),%edx
  8006d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006da:	89 10                	mov    %edx,(%eax)
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	8b 00                	mov    (%eax),%eax
  8006e1:	83 e8 04             	sub    $0x4,%eax
  8006e4:	8b 00                	mov    (%eax),%eax
  8006e6:	99                   	cltd   
}
  8006e7:	5d                   	pop    %ebp
  8006e8:	c3                   	ret    

008006e9 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006e9:	55                   	push   %ebp
  8006ea:	89 e5                	mov    %esp,%ebp
  8006ec:	56                   	push   %esi
  8006ed:	53                   	push   %ebx
  8006ee:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006f1:	eb 17                	jmp    80070a <vprintfmt+0x21>
			if (ch == '\0')
  8006f3:	85 db                	test   %ebx,%ebx
  8006f5:	0f 84 af 03 00 00    	je     800aaa <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8006fb:	83 ec 08             	sub    $0x8,%esp
  8006fe:	ff 75 0c             	pushl  0xc(%ebp)
  800701:	53                   	push   %ebx
  800702:	8b 45 08             	mov    0x8(%ebp),%eax
  800705:	ff d0                	call   *%eax
  800707:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80070a:	8b 45 10             	mov    0x10(%ebp),%eax
  80070d:	8d 50 01             	lea    0x1(%eax),%edx
  800710:	89 55 10             	mov    %edx,0x10(%ebp)
  800713:	8a 00                	mov    (%eax),%al
  800715:	0f b6 d8             	movzbl %al,%ebx
  800718:	83 fb 25             	cmp    $0x25,%ebx
  80071b:	75 d6                	jne    8006f3 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80071d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800721:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800728:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80072f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800736:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80073d:	8b 45 10             	mov    0x10(%ebp),%eax
  800740:	8d 50 01             	lea    0x1(%eax),%edx
  800743:	89 55 10             	mov    %edx,0x10(%ebp)
  800746:	8a 00                	mov    (%eax),%al
  800748:	0f b6 d8             	movzbl %al,%ebx
  80074b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80074e:	83 f8 55             	cmp    $0x55,%eax
  800751:	0f 87 2b 03 00 00    	ja     800a82 <vprintfmt+0x399>
  800757:	8b 04 85 38 37 80 00 	mov    0x803738(,%eax,4),%eax
  80075e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800760:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800764:	eb d7                	jmp    80073d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800766:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80076a:	eb d1                	jmp    80073d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80076c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800773:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800776:	89 d0                	mov    %edx,%eax
  800778:	c1 e0 02             	shl    $0x2,%eax
  80077b:	01 d0                	add    %edx,%eax
  80077d:	01 c0                	add    %eax,%eax
  80077f:	01 d8                	add    %ebx,%eax
  800781:	83 e8 30             	sub    $0x30,%eax
  800784:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800787:	8b 45 10             	mov    0x10(%ebp),%eax
  80078a:	8a 00                	mov    (%eax),%al
  80078c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80078f:	83 fb 2f             	cmp    $0x2f,%ebx
  800792:	7e 3e                	jle    8007d2 <vprintfmt+0xe9>
  800794:	83 fb 39             	cmp    $0x39,%ebx
  800797:	7f 39                	jg     8007d2 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800799:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80079c:	eb d5                	jmp    800773 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80079e:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a1:	83 c0 04             	add    $0x4,%eax
  8007a4:	89 45 14             	mov    %eax,0x14(%ebp)
  8007a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007aa:	83 e8 04             	sub    $0x4,%eax
  8007ad:	8b 00                	mov    (%eax),%eax
  8007af:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007b2:	eb 1f                	jmp    8007d3 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007b4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007b8:	79 83                	jns    80073d <vprintfmt+0x54>
				width = 0;
  8007ba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007c1:	e9 77 ff ff ff       	jmp    80073d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007c6:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007cd:	e9 6b ff ff ff       	jmp    80073d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007d2:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007d3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007d7:	0f 89 60 ff ff ff    	jns    80073d <vprintfmt+0x54>
				width = precision, precision = -1;
  8007dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007e3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8007ea:	e9 4e ff ff ff       	jmp    80073d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007ef:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8007f2:	e9 46 ff ff ff       	jmp    80073d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8007f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fa:	83 c0 04             	add    $0x4,%eax
  8007fd:	89 45 14             	mov    %eax,0x14(%ebp)
  800800:	8b 45 14             	mov    0x14(%ebp),%eax
  800803:	83 e8 04             	sub    $0x4,%eax
  800806:	8b 00                	mov    (%eax),%eax
  800808:	83 ec 08             	sub    $0x8,%esp
  80080b:	ff 75 0c             	pushl  0xc(%ebp)
  80080e:	50                   	push   %eax
  80080f:	8b 45 08             	mov    0x8(%ebp),%eax
  800812:	ff d0                	call   *%eax
  800814:	83 c4 10             	add    $0x10,%esp
			break;
  800817:	e9 89 02 00 00       	jmp    800aa5 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80081c:	8b 45 14             	mov    0x14(%ebp),%eax
  80081f:	83 c0 04             	add    $0x4,%eax
  800822:	89 45 14             	mov    %eax,0x14(%ebp)
  800825:	8b 45 14             	mov    0x14(%ebp),%eax
  800828:	83 e8 04             	sub    $0x4,%eax
  80082b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80082d:	85 db                	test   %ebx,%ebx
  80082f:	79 02                	jns    800833 <vprintfmt+0x14a>
				err = -err;
  800831:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800833:	83 fb 64             	cmp    $0x64,%ebx
  800836:	7f 0b                	jg     800843 <vprintfmt+0x15a>
  800838:	8b 34 9d 80 35 80 00 	mov    0x803580(,%ebx,4),%esi
  80083f:	85 f6                	test   %esi,%esi
  800841:	75 19                	jne    80085c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800843:	53                   	push   %ebx
  800844:	68 25 37 80 00       	push   $0x803725
  800849:	ff 75 0c             	pushl  0xc(%ebp)
  80084c:	ff 75 08             	pushl  0x8(%ebp)
  80084f:	e8 5e 02 00 00       	call   800ab2 <printfmt>
  800854:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800857:	e9 49 02 00 00       	jmp    800aa5 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80085c:	56                   	push   %esi
  80085d:	68 2e 37 80 00       	push   $0x80372e
  800862:	ff 75 0c             	pushl  0xc(%ebp)
  800865:	ff 75 08             	pushl  0x8(%ebp)
  800868:	e8 45 02 00 00       	call   800ab2 <printfmt>
  80086d:	83 c4 10             	add    $0x10,%esp
			break;
  800870:	e9 30 02 00 00       	jmp    800aa5 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800875:	8b 45 14             	mov    0x14(%ebp),%eax
  800878:	83 c0 04             	add    $0x4,%eax
  80087b:	89 45 14             	mov    %eax,0x14(%ebp)
  80087e:	8b 45 14             	mov    0x14(%ebp),%eax
  800881:	83 e8 04             	sub    $0x4,%eax
  800884:	8b 30                	mov    (%eax),%esi
  800886:	85 f6                	test   %esi,%esi
  800888:	75 05                	jne    80088f <vprintfmt+0x1a6>
				p = "(null)";
  80088a:	be 31 37 80 00       	mov    $0x803731,%esi
			if (width > 0 && padc != '-')
  80088f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800893:	7e 6d                	jle    800902 <vprintfmt+0x219>
  800895:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800899:	74 67                	je     800902 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80089b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80089e:	83 ec 08             	sub    $0x8,%esp
  8008a1:	50                   	push   %eax
  8008a2:	56                   	push   %esi
  8008a3:	e8 0c 03 00 00       	call   800bb4 <strnlen>
  8008a8:	83 c4 10             	add    $0x10,%esp
  8008ab:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008ae:	eb 16                	jmp    8008c6 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008b0:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008b4:	83 ec 08             	sub    $0x8,%esp
  8008b7:	ff 75 0c             	pushl  0xc(%ebp)
  8008ba:	50                   	push   %eax
  8008bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008be:	ff d0                	call   *%eax
  8008c0:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008c3:	ff 4d e4             	decl   -0x1c(%ebp)
  8008c6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ca:	7f e4                	jg     8008b0 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008cc:	eb 34                	jmp    800902 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008ce:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008d2:	74 1c                	je     8008f0 <vprintfmt+0x207>
  8008d4:	83 fb 1f             	cmp    $0x1f,%ebx
  8008d7:	7e 05                	jle    8008de <vprintfmt+0x1f5>
  8008d9:	83 fb 7e             	cmp    $0x7e,%ebx
  8008dc:	7e 12                	jle    8008f0 <vprintfmt+0x207>
					putch('?', putdat);
  8008de:	83 ec 08             	sub    $0x8,%esp
  8008e1:	ff 75 0c             	pushl  0xc(%ebp)
  8008e4:	6a 3f                	push   $0x3f
  8008e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e9:	ff d0                	call   *%eax
  8008eb:	83 c4 10             	add    $0x10,%esp
  8008ee:	eb 0f                	jmp    8008ff <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8008f0:	83 ec 08             	sub    $0x8,%esp
  8008f3:	ff 75 0c             	pushl  0xc(%ebp)
  8008f6:	53                   	push   %ebx
  8008f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fa:	ff d0                	call   *%eax
  8008fc:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008ff:	ff 4d e4             	decl   -0x1c(%ebp)
  800902:	89 f0                	mov    %esi,%eax
  800904:	8d 70 01             	lea    0x1(%eax),%esi
  800907:	8a 00                	mov    (%eax),%al
  800909:	0f be d8             	movsbl %al,%ebx
  80090c:	85 db                	test   %ebx,%ebx
  80090e:	74 24                	je     800934 <vprintfmt+0x24b>
  800910:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800914:	78 b8                	js     8008ce <vprintfmt+0x1e5>
  800916:	ff 4d e0             	decl   -0x20(%ebp)
  800919:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80091d:	79 af                	jns    8008ce <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80091f:	eb 13                	jmp    800934 <vprintfmt+0x24b>
				putch(' ', putdat);
  800921:	83 ec 08             	sub    $0x8,%esp
  800924:	ff 75 0c             	pushl  0xc(%ebp)
  800927:	6a 20                	push   $0x20
  800929:	8b 45 08             	mov    0x8(%ebp),%eax
  80092c:	ff d0                	call   *%eax
  80092e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800931:	ff 4d e4             	decl   -0x1c(%ebp)
  800934:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800938:	7f e7                	jg     800921 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80093a:	e9 66 01 00 00       	jmp    800aa5 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80093f:	83 ec 08             	sub    $0x8,%esp
  800942:	ff 75 e8             	pushl  -0x18(%ebp)
  800945:	8d 45 14             	lea    0x14(%ebp),%eax
  800948:	50                   	push   %eax
  800949:	e8 3c fd ff ff       	call   80068a <getint>
  80094e:	83 c4 10             	add    $0x10,%esp
  800951:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800954:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800957:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80095a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80095d:	85 d2                	test   %edx,%edx
  80095f:	79 23                	jns    800984 <vprintfmt+0x29b>
				putch('-', putdat);
  800961:	83 ec 08             	sub    $0x8,%esp
  800964:	ff 75 0c             	pushl  0xc(%ebp)
  800967:	6a 2d                	push   $0x2d
  800969:	8b 45 08             	mov    0x8(%ebp),%eax
  80096c:	ff d0                	call   *%eax
  80096e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800971:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800974:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800977:	f7 d8                	neg    %eax
  800979:	83 d2 00             	adc    $0x0,%edx
  80097c:	f7 da                	neg    %edx
  80097e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800981:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800984:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80098b:	e9 bc 00 00 00       	jmp    800a4c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800990:	83 ec 08             	sub    $0x8,%esp
  800993:	ff 75 e8             	pushl  -0x18(%ebp)
  800996:	8d 45 14             	lea    0x14(%ebp),%eax
  800999:	50                   	push   %eax
  80099a:	e8 84 fc ff ff       	call   800623 <getuint>
  80099f:	83 c4 10             	add    $0x10,%esp
  8009a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009a8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009af:	e9 98 00 00 00       	jmp    800a4c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009b4:	83 ec 08             	sub    $0x8,%esp
  8009b7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ba:	6a 58                	push   $0x58
  8009bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bf:	ff d0                	call   *%eax
  8009c1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009c4:	83 ec 08             	sub    $0x8,%esp
  8009c7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ca:	6a 58                	push   $0x58
  8009cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cf:	ff d0                	call   *%eax
  8009d1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009d4:	83 ec 08             	sub    $0x8,%esp
  8009d7:	ff 75 0c             	pushl  0xc(%ebp)
  8009da:	6a 58                	push   $0x58
  8009dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009df:	ff d0                	call   *%eax
  8009e1:	83 c4 10             	add    $0x10,%esp
			break;
  8009e4:	e9 bc 00 00 00       	jmp    800aa5 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8009e9:	83 ec 08             	sub    $0x8,%esp
  8009ec:	ff 75 0c             	pushl  0xc(%ebp)
  8009ef:	6a 30                	push   $0x30
  8009f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f4:	ff d0                	call   *%eax
  8009f6:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8009f9:	83 ec 08             	sub    $0x8,%esp
  8009fc:	ff 75 0c             	pushl  0xc(%ebp)
  8009ff:	6a 78                	push   $0x78
  800a01:	8b 45 08             	mov    0x8(%ebp),%eax
  800a04:	ff d0                	call   *%eax
  800a06:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a09:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0c:	83 c0 04             	add    $0x4,%eax
  800a0f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a12:	8b 45 14             	mov    0x14(%ebp),%eax
  800a15:	83 e8 04             	sub    $0x4,%eax
  800a18:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a1d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a24:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a2b:	eb 1f                	jmp    800a4c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a2d:	83 ec 08             	sub    $0x8,%esp
  800a30:	ff 75 e8             	pushl  -0x18(%ebp)
  800a33:	8d 45 14             	lea    0x14(%ebp),%eax
  800a36:	50                   	push   %eax
  800a37:	e8 e7 fb ff ff       	call   800623 <getuint>
  800a3c:	83 c4 10             	add    $0x10,%esp
  800a3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a42:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a45:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a4c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a53:	83 ec 04             	sub    $0x4,%esp
  800a56:	52                   	push   %edx
  800a57:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a5a:	50                   	push   %eax
  800a5b:	ff 75 f4             	pushl  -0xc(%ebp)
  800a5e:	ff 75 f0             	pushl  -0x10(%ebp)
  800a61:	ff 75 0c             	pushl  0xc(%ebp)
  800a64:	ff 75 08             	pushl  0x8(%ebp)
  800a67:	e8 00 fb ff ff       	call   80056c <printnum>
  800a6c:	83 c4 20             	add    $0x20,%esp
			break;
  800a6f:	eb 34                	jmp    800aa5 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a71:	83 ec 08             	sub    $0x8,%esp
  800a74:	ff 75 0c             	pushl  0xc(%ebp)
  800a77:	53                   	push   %ebx
  800a78:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7b:	ff d0                	call   *%eax
  800a7d:	83 c4 10             	add    $0x10,%esp
			break;
  800a80:	eb 23                	jmp    800aa5 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a82:	83 ec 08             	sub    $0x8,%esp
  800a85:	ff 75 0c             	pushl  0xc(%ebp)
  800a88:	6a 25                	push   $0x25
  800a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8d:	ff d0                	call   *%eax
  800a8f:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a92:	ff 4d 10             	decl   0x10(%ebp)
  800a95:	eb 03                	jmp    800a9a <vprintfmt+0x3b1>
  800a97:	ff 4d 10             	decl   0x10(%ebp)
  800a9a:	8b 45 10             	mov    0x10(%ebp),%eax
  800a9d:	48                   	dec    %eax
  800a9e:	8a 00                	mov    (%eax),%al
  800aa0:	3c 25                	cmp    $0x25,%al
  800aa2:	75 f3                	jne    800a97 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800aa4:	90                   	nop
		}
	}
  800aa5:	e9 47 fc ff ff       	jmp    8006f1 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800aaa:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800aab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800aae:	5b                   	pop    %ebx
  800aaf:	5e                   	pop    %esi
  800ab0:	5d                   	pop    %ebp
  800ab1:	c3                   	ret    

00800ab2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ab2:	55                   	push   %ebp
  800ab3:	89 e5                	mov    %esp,%ebp
  800ab5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ab8:	8d 45 10             	lea    0x10(%ebp),%eax
  800abb:	83 c0 04             	add    $0x4,%eax
  800abe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ac1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac4:	ff 75 f4             	pushl  -0xc(%ebp)
  800ac7:	50                   	push   %eax
  800ac8:	ff 75 0c             	pushl  0xc(%ebp)
  800acb:	ff 75 08             	pushl  0x8(%ebp)
  800ace:	e8 16 fc ff ff       	call   8006e9 <vprintfmt>
  800ad3:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ad6:	90                   	nop
  800ad7:	c9                   	leave  
  800ad8:	c3                   	ret    

00800ad9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ad9:	55                   	push   %ebp
  800ada:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800adc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800adf:	8b 40 08             	mov    0x8(%eax),%eax
  800ae2:	8d 50 01             	lea    0x1(%eax),%edx
  800ae5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae8:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800aeb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aee:	8b 10                	mov    (%eax),%edx
  800af0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af3:	8b 40 04             	mov    0x4(%eax),%eax
  800af6:	39 c2                	cmp    %eax,%edx
  800af8:	73 12                	jae    800b0c <sprintputch+0x33>
		*b->buf++ = ch;
  800afa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afd:	8b 00                	mov    (%eax),%eax
  800aff:	8d 48 01             	lea    0x1(%eax),%ecx
  800b02:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b05:	89 0a                	mov    %ecx,(%edx)
  800b07:	8b 55 08             	mov    0x8(%ebp),%edx
  800b0a:	88 10                	mov    %dl,(%eax)
}
  800b0c:	90                   	nop
  800b0d:	5d                   	pop    %ebp
  800b0e:	c3                   	ret    

00800b0f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b0f:	55                   	push   %ebp
  800b10:	89 e5                	mov    %esp,%ebp
  800b12:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b15:	8b 45 08             	mov    0x8(%ebp),%eax
  800b18:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	01 d0                	add    %edx,%eax
  800b26:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b29:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b30:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b34:	74 06                	je     800b3c <vsnprintf+0x2d>
  800b36:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b3a:	7f 07                	jg     800b43 <vsnprintf+0x34>
		return -E_INVAL;
  800b3c:	b8 03 00 00 00       	mov    $0x3,%eax
  800b41:	eb 20                	jmp    800b63 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b43:	ff 75 14             	pushl  0x14(%ebp)
  800b46:	ff 75 10             	pushl  0x10(%ebp)
  800b49:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b4c:	50                   	push   %eax
  800b4d:	68 d9 0a 80 00       	push   $0x800ad9
  800b52:	e8 92 fb ff ff       	call   8006e9 <vprintfmt>
  800b57:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b5d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b63:	c9                   	leave  
  800b64:	c3                   	ret    

00800b65 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b65:	55                   	push   %ebp
  800b66:	89 e5                	mov    %esp,%ebp
  800b68:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b6b:	8d 45 10             	lea    0x10(%ebp),%eax
  800b6e:	83 c0 04             	add    $0x4,%eax
  800b71:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b74:	8b 45 10             	mov    0x10(%ebp),%eax
  800b77:	ff 75 f4             	pushl  -0xc(%ebp)
  800b7a:	50                   	push   %eax
  800b7b:	ff 75 0c             	pushl  0xc(%ebp)
  800b7e:	ff 75 08             	pushl  0x8(%ebp)
  800b81:	e8 89 ff ff ff       	call   800b0f <vsnprintf>
  800b86:	83 c4 10             	add    $0x10,%esp
  800b89:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800b8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b8f:	c9                   	leave  
  800b90:	c3                   	ret    

00800b91 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800b91:	55                   	push   %ebp
  800b92:	89 e5                	mov    %esp,%ebp
  800b94:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b97:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b9e:	eb 06                	jmp    800ba6 <strlen+0x15>
		n++;
  800ba0:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ba3:	ff 45 08             	incl   0x8(%ebp)
  800ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba9:	8a 00                	mov    (%eax),%al
  800bab:	84 c0                	test   %al,%al
  800bad:	75 f1                	jne    800ba0 <strlen+0xf>
		n++;
	return n;
  800baf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bb2:	c9                   	leave  
  800bb3:	c3                   	ret    

00800bb4 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bb4:	55                   	push   %ebp
  800bb5:	89 e5                	mov    %esp,%ebp
  800bb7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bc1:	eb 09                	jmp    800bcc <strnlen+0x18>
		n++;
  800bc3:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bc6:	ff 45 08             	incl   0x8(%ebp)
  800bc9:	ff 4d 0c             	decl   0xc(%ebp)
  800bcc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bd0:	74 09                	je     800bdb <strnlen+0x27>
  800bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd5:	8a 00                	mov    (%eax),%al
  800bd7:	84 c0                	test   %al,%al
  800bd9:	75 e8                	jne    800bc3 <strnlen+0xf>
		n++;
	return n;
  800bdb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bde:	c9                   	leave  
  800bdf:	c3                   	ret    

00800be0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800be0:	55                   	push   %ebp
  800be1:	89 e5                	mov    %esp,%ebp
  800be3:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
  800be9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800bec:	90                   	nop
  800bed:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf0:	8d 50 01             	lea    0x1(%eax),%edx
  800bf3:	89 55 08             	mov    %edx,0x8(%ebp)
  800bf6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bf9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bfc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bff:	8a 12                	mov    (%edx),%dl
  800c01:	88 10                	mov    %dl,(%eax)
  800c03:	8a 00                	mov    (%eax),%al
  800c05:	84 c0                	test   %al,%al
  800c07:	75 e4                	jne    800bed <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c09:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c0c:	c9                   	leave  
  800c0d:	c3                   	ret    

00800c0e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
  800c11:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c14:	8b 45 08             	mov    0x8(%ebp),%eax
  800c17:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c1a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c21:	eb 1f                	jmp    800c42 <strncpy+0x34>
		*dst++ = *src;
  800c23:	8b 45 08             	mov    0x8(%ebp),%eax
  800c26:	8d 50 01             	lea    0x1(%eax),%edx
  800c29:	89 55 08             	mov    %edx,0x8(%ebp)
  800c2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c2f:	8a 12                	mov    (%edx),%dl
  800c31:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c36:	8a 00                	mov    (%eax),%al
  800c38:	84 c0                	test   %al,%al
  800c3a:	74 03                	je     800c3f <strncpy+0x31>
			src++;
  800c3c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c3f:	ff 45 fc             	incl   -0x4(%ebp)
  800c42:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c45:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c48:	72 d9                	jb     800c23 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c4a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c4d:	c9                   	leave  
  800c4e:	c3                   	ret    

00800c4f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c4f:	55                   	push   %ebp
  800c50:	89 e5                	mov    %esp,%ebp
  800c52:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c55:	8b 45 08             	mov    0x8(%ebp),%eax
  800c58:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c5b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c5f:	74 30                	je     800c91 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c61:	eb 16                	jmp    800c79 <strlcpy+0x2a>
			*dst++ = *src++;
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	8d 50 01             	lea    0x1(%eax),%edx
  800c69:	89 55 08             	mov    %edx,0x8(%ebp)
  800c6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c72:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c75:	8a 12                	mov    (%edx),%dl
  800c77:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c79:	ff 4d 10             	decl   0x10(%ebp)
  800c7c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c80:	74 09                	je     800c8b <strlcpy+0x3c>
  800c82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c85:	8a 00                	mov    (%eax),%al
  800c87:	84 c0                	test   %al,%al
  800c89:	75 d8                	jne    800c63 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c91:	8b 55 08             	mov    0x8(%ebp),%edx
  800c94:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c97:	29 c2                	sub    %eax,%edx
  800c99:	89 d0                	mov    %edx,%eax
}
  800c9b:	c9                   	leave  
  800c9c:	c3                   	ret    

00800c9d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c9d:	55                   	push   %ebp
  800c9e:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ca0:	eb 06                	jmp    800ca8 <strcmp+0xb>
		p++, q++;
  800ca2:	ff 45 08             	incl   0x8(%ebp)
  800ca5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cab:	8a 00                	mov    (%eax),%al
  800cad:	84 c0                	test   %al,%al
  800caf:	74 0e                	je     800cbf <strcmp+0x22>
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	8a 10                	mov    (%eax),%dl
  800cb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb9:	8a 00                	mov    (%eax),%al
  800cbb:	38 c2                	cmp    %al,%dl
  800cbd:	74 e3                	je     800ca2 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc2:	8a 00                	mov    (%eax),%al
  800cc4:	0f b6 d0             	movzbl %al,%edx
  800cc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cca:	8a 00                	mov    (%eax),%al
  800ccc:	0f b6 c0             	movzbl %al,%eax
  800ccf:	29 c2                	sub    %eax,%edx
  800cd1:	89 d0                	mov    %edx,%eax
}
  800cd3:	5d                   	pop    %ebp
  800cd4:	c3                   	ret    

00800cd5 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cd5:	55                   	push   %ebp
  800cd6:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cd8:	eb 09                	jmp    800ce3 <strncmp+0xe>
		n--, p++, q++;
  800cda:	ff 4d 10             	decl   0x10(%ebp)
  800cdd:	ff 45 08             	incl   0x8(%ebp)
  800ce0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ce3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ce7:	74 17                	je     800d00 <strncmp+0x2b>
  800ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cec:	8a 00                	mov    (%eax),%al
  800cee:	84 c0                	test   %al,%al
  800cf0:	74 0e                	je     800d00 <strncmp+0x2b>
  800cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf5:	8a 10                	mov    (%eax),%dl
  800cf7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfa:	8a 00                	mov    (%eax),%al
  800cfc:	38 c2                	cmp    %al,%dl
  800cfe:	74 da                	je     800cda <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d00:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d04:	75 07                	jne    800d0d <strncmp+0x38>
		return 0;
  800d06:	b8 00 00 00 00       	mov    $0x0,%eax
  800d0b:	eb 14                	jmp    800d21 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	0f b6 d0             	movzbl %al,%edx
  800d15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d18:	8a 00                	mov    (%eax),%al
  800d1a:	0f b6 c0             	movzbl %al,%eax
  800d1d:	29 c2                	sub    %eax,%edx
  800d1f:	89 d0                	mov    %edx,%eax
}
  800d21:	5d                   	pop    %ebp
  800d22:	c3                   	ret    

00800d23 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d23:	55                   	push   %ebp
  800d24:	89 e5                	mov    %esp,%ebp
  800d26:	83 ec 04             	sub    $0x4,%esp
  800d29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d2f:	eb 12                	jmp    800d43 <strchr+0x20>
		if (*s == c)
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
  800d34:	8a 00                	mov    (%eax),%al
  800d36:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d39:	75 05                	jne    800d40 <strchr+0x1d>
			return (char *) s;
  800d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3e:	eb 11                	jmp    800d51 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d40:	ff 45 08             	incl   0x8(%ebp)
  800d43:	8b 45 08             	mov    0x8(%ebp),%eax
  800d46:	8a 00                	mov    (%eax),%al
  800d48:	84 c0                	test   %al,%al
  800d4a:	75 e5                	jne    800d31 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d51:	c9                   	leave  
  800d52:	c3                   	ret    

00800d53 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d53:	55                   	push   %ebp
  800d54:	89 e5                	mov    %esp,%ebp
  800d56:	83 ec 04             	sub    $0x4,%esp
  800d59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d5f:	eb 0d                	jmp    800d6e <strfind+0x1b>
		if (*s == c)
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	8a 00                	mov    (%eax),%al
  800d66:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d69:	74 0e                	je     800d79 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d6b:	ff 45 08             	incl   0x8(%ebp)
  800d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d71:	8a 00                	mov    (%eax),%al
  800d73:	84 c0                	test   %al,%al
  800d75:	75 ea                	jne    800d61 <strfind+0xe>
  800d77:	eb 01                	jmp    800d7a <strfind+0x27>
		if (*s == c)
			break;
  800d79:	90                   	nop
	return (char *) s;
  800d7a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d7d:	c9                   	leave  
  800d7e:	c3                   	ret    

00800d7f <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d7f:	55                   	push   %ebp
  800d80:	89 e5                	mov    %esp,%ebp
  800d82:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d85:	8b 45 08             	mov    0x8(%ebp),%eax
  800d88:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d8e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d91:	eb 0e                	jmp    800da1 <memset+0x22>
		*p++ = c;
  800d93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d96:	8d 50 01             	lea    0x1(%eax),%edx
  800d99:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d9f:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800da1:	ff 4d f8             	decl   -0x8(%ebp)
  800da4:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800da8:	79 e9                	jns    800d93 <memset+0x14>
		*p++ = c;

	return v;
  800daa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dad:	c9                   	leave  
  800dae:	c3                   	ret    

00800daf <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800daf:	55                   	push   %ebp
  800db0:	89 e5                	mov    %esp,%ebp
  800db2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800db5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800dc1:	eb 16                	jmp    800dd9 <memcpy+0x2a>
		*d++ = *s++;
  800dc3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dc6:	8d 50 01             	lea    0x1(%eax),%edx
  800dc9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dcc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dcf:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dd2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dd5:	8a 12                	mov    (%edx),%dl
  800dd7:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800dd9:	8b 45 10             	mov    0x10(%ebp),%eax
  800ddc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ddf:	89 55 10             	mov    %edx,0x10(%ebp)
  800de2:	85 c0                	test   %eax,%eax
  800de4:	75 dd                	jne    800dc3 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800de6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800de9:	c9                   	leave  
  800dea:	c3                   	ret    

00800deb <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800deb:	55                   	push   %ebp
  800dec:	89 e5                	mov    %esp,%ebp
  800dee:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800df1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800df7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800dfd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e00:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e03:	73 50                	jae    800e55 <memmove+0x6a>
  800e05:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e08:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0b:	01 d0                	add    %edx,%eax
  800e0d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e10:	76 43                	jbe    800e55 <memmove+0x6a>
		s += n;
  800e12:	8b 45 10             	mov    0x10(%ebp),%eax
  800e15:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e18:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e1e:	eb 10                	jmp    800e30 <memmove+0x45>
			*--d = *--s;
  800e20:	ff 4d f8             	decl   -0x8(%ebp)
  800e23:	ff 4d fc             	decl   -0x4(%ebp)
  800e26:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e29:	8a 10                	mov    (%eax),%dl
  800e2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e2e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e30:	8b 45 10             	mov    0x10(%ebp),%eax
  800e33:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e36:	89 55 10             	mov    %edx,0x10(%ebp)
  800e39:	85 c0                	test   %eax,%eax
  800e3b:	75 e3                	jne    800e20 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e3d:	eb 23                	jmp    800e62 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e42:	8d 50 01             	lea    0x1(%eax),%edx
  800e45:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e48:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e4b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e4e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e51:	8a 12                	mov    (%edx),%dl
  800e53:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e55:	8b 45 10             	mov    0x10(%ebp),%eax
  800e58:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e5b:	89 55 10             	mov    %edx,0x10(%ebp)
  800e5e:	85 c0                	test   %eax,%eax
  800e60:	75 dd                	jne    800e3f <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e62:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e65:	c9                   	leave  
  800e66:	c3                   	ret    

00800e67 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e67:	55                   	push   %ebp
  800e68:	89 e5                	mov    %esp,%ebp
  800e6a:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e70:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e76:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e79:	eb 2a                	jmp    800ea5 <memcmp+0x3e>
		if (*s1 != *s2)
  800e7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e7e:	8a 10                	mov    (%eax),%dl
  800e80:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e83:	8a 00                	mov    (%eax),%al
  800e85:	38 c2                	cmp    %al,%dl
  800e87:	74 16                	je     800e9f <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e89:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e8c:	8a 00                	mov    (%eax),%al
  800e8e:	0f b6 d0             	movzbl %al,%edx
  800e91:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e94:	8a 00                	mov    (%eax),%al
  800e96:	0f b6 c0             	movzbl %al,%eax
  800e99:	29 c2                	sub    %eax,%edx
  800e9b:	89 d0                	mov    %edx,%eax
  800e9d:	eb 18                	jmp    800eb7 <memcmp+0x50>
		s1++, s2++;
  800e9f:	ff 45 fc             	incl   -0x4(%ebp)
  800ea2:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ea5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eab:	89 55 10             	mov    %edx,0x10(%ebp)
  800eae:	85 c0                	test   %eax,%eax
  800eb0:	75 c9                	jne    800e7b <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800eb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eb7:	c9                   	leave  
  800eb8:	c3                   	ret    

00800eb9 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800eb9:	55                   	push   %ebp
  800eba:	89 e5                	mov    %esp,%ebp
  800ebc:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ebf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec5:	01 d0                	add    %edx,%eax
  800ec7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800eca:	eb 15                	jmp    800ee1 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	8a 00                	mov    (%eax),%al
  800ed1:	0f b6 d0             	movzbl %al,%edx
  800ed4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed7:	0f b6 c0             	movzbl %al,%eax
  800eda:	39 c2                	cmp    %eax,%edx
  800edc:	74 0d                	je     800eeb <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ede:	ff 45 08             	incl   0x8(%ebp)
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ee7:	72 e3                	jb     800ecc <memfind+0x13>
  800ee9:	eb 01                	jmp    800eec <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800eeb:	90                   	nop
	return (void *) s;
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eef:	c9                   	leave  
  800ef0:	c3                   	ret    

00800ef1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ef1:	55                   	push   %ebp
  800ef2:	89 e5                	mov    %esp,%ebp
  800ef4:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800ef7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800efe:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f05:	eb 03                	jmp    800f0a <strtol+0x19>
		s++;
  800f07:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0d:	8a 00                	mov    (%eax),%al
  800f0f:	3c 20                	cmp    $0x20,%al
  800f11:	74 f4                	je     800f07 <strtol+0x16>
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
  800f16:	8a 00                	mov    (%eax),%al
  800f18:	3c 09                	cmp    $0x9,%al
  800f1a:	74 eb                	je     800f07 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1f:	8a 00                	mov    (%eax),%al
  800f21:	3c 2b                	cmp    $0x2b,%al
  800f23:	75 05                	jne    800f2a <strtol+0x39>
		s++;
  800f25:	ff 45 08             	incl   0x8(%ebp)
  800f28:	eb 13                	jmp    800f3d <strtol+0x4c>
	else if (*s == '-')
  800f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2d:	8a 00                	mov    (%eax),%al
  800f2f:	3c 2d                	cmp    $0x2d,%al
  800f31:	75 0a                	jne    800f3d <strtol+0x4c>
		s++, neg = 1;
  800f33:	ff 45 08             	incl   0x8(%ebp)
  800f36:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f3d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f41:	74 06                	je     800f49 <strtol+0x58>
  800f43:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f47:	75 20                	jne    800f69 <strtol+0x78>
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	8a 00                	mov    (%eax),%al
  800f4e:	3c 30                	cmp    $0x30,%al
  800f50:	75 17                	jne    800f69 <strtol+0x78>
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	40                   	inc    %eax
  800f56:	8a 00                	mov    (%eax),%al
  800f58:	3c 78                	cmp    $0x78,%al
  800f5a:	75 0d                	jne    800f69 <strtol+0x78>
		s += 2, base = 16;
  800f5c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f60:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f67:	eb 28                	jmp    800f91 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f69:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f6d:	75 15                	jne    800f84 <strtol+0x93>
  800f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f72:	8a 00                	mov    (%eax),%al
  800f74:	3c 30                	cmp    $0x30,%al
  800f76:	75 0c                	jne    800f84 <strtol+0x93>
		s++, base = 8;
  800f78:	ff 45 08             	incl   0x8(%ebp)
  800f7b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f82:	eb 0d                	jmp    800f91 <strtol+0xa0>
	else if (base == 0)
  800f84:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f88:	75 07                	jne    800f91 <strtol+0xa0>
		base = 10;
  800f8a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f91:	8b 45 08             	mov    0x8(%ebp),%eax
  800f94:	8a 00                	mov    (%eax),%al
  800f96:	3c 2f                	cmp    $0x2f,%al
  800f98:	7e 19                	jle    800fb3 <strtol+0xc2>
  800f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9d:	8a 00                	mov    (%eax),%al
  800f9f:	3c 39                	cmp    $0x39,%al
  800fa1:	7f 10                	jg     800fb3 <strtol+0xc2>
			dig = *s - '0';
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	8a 00                	mov    (%eax),%al
  800fa8:	0f be c0             	movsbl %al,%eax
  800fab:	83 e8 30             	sub    $0x30,%eax
  800fae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fb1:	eb 42                	jmp    800ff5 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	8a 00                	mov    (%eax),%al
  800fb8:	3c 60                	cmp    $0x60,%al
  800fba:	7e 19                	jle    800fd5 <strtol+0xe4>
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbf:	8a 00                	mov    (%eax),%al
  800fc1:	3c 7a                	cmp    $0x7a,%al
  800fc3:	7f 10                	jg     800fd5 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc8:	8a 00                	mov    (%eax),%al
  800fca:	0f be c0             	movsbl %al,%eax
  800fcd:	83 e8 57             	sub    $0x57,%eax
  800fd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fd3:	eb 20                	jmp    800ff5 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd8:	8a 00                	mov    (%eax),%al
  800fda:	3c 40                	cmp    $0x40,%al
  800fdc:	7e 39                	jle    801017 <strtol+0x126>
  800fde:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe1:	8a 00                	mov    (%eax),%al
  800fe3:	3c 5a                	cmp    $0x5a,%al
  800fe5:	7f 30                	jg     801017 <strtol+0x126>
			dig = *s - 'A' + 10;
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	8a 00                	mov    (%eax),%al
  800fec:	0f be c0             	movsbl %al,%eax
  800fef:	83 e8 37             	sub    $0x37,%eax
  800ff2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800ff5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ff8:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ffb:	7d 19                	jge    801016 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800ffd:	ff 45 08             	incl   0x8(%ebp)
  801000:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801003:	0f af 45 10          	imul   0x10(%ebp),%eax
  801007:	89 c2                	mov    %eax,%edx
  801009:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80100c:	01 d0                	add    %edx,%eax
  80100e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801011:	e9 7b ff ff ff       	jmp    800f91 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801016:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801017:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80101b:	74 08                	je     801025 <strtol+0x134>
		*endptr = (char *) s;
  80101d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801020:	8b 55 08             	mov    0x8(%ebp),%edx
  801023:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801025:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801029:	74 07                	je     801032 <strtol+0x141>
  80102b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102e:	f7 d8                	neg    %eax
  801030:	eb 03                	jmp    801035 <strtol+0x144>
  801032:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801035:	c9                   	leave  
  801036:	c3                   	ret    

00801037 <ltostr>:

void
ltostr(long value, char *str)
{
  801037:	55                   	push   %ebp
  801038:	89 e5                	mov    %esp,%ebp
  80103a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80103d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801044:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80104b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80104f:	79 13                	jns    801064 <ltostr+0x2d>
	{
		neg = 1;
  801051:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801058:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80105e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801061:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801064:	8b 45 08             	mov    0x8(%ebp),%eax
  801067:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80106c:	99                   	cltd   
  80106d:	f7 f9                	idiv   %ecx
  80106f:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801072:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801075:	8d 50 01             	lea    0x1(%eax),%edx
  801078:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80107b:	89 c2                	mov    %eax,%edx
  80107d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801080:	01 d0                	add    %edx,%eax
  801082:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801085:	83 c2 30             	add    $0x30,%edx
  801088:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80108a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80108d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801092:	f7 e9                	imul   %ecx
  801094:	c1 fa 02             	sar    $0x2,%edx
  801097:	89 c8                	mov    %ecx,%eax
  801099:	c1 f8 1f             	sar    $0x1f,%eax
  80109c:	29 c2                	sub    %eax,%edx
  80109e:	89 d0                	mov    %edx,%eax
  8010a0:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010a6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010ab:	f7 e9                	imul   %ecx
  8010ad:	c1 fa 02             	sar    $0x2,%edx
  8010b0:	89 c8                	mov    %ecx,%eax
  8010b2:	c1 f8 1f             	sar    $0x1f,%eax
  8010b5:	29 c2                	sub    %eax,%edx
  8010b7:	89 d0                	mov    %edx,%eax
  8010b9:	c1 e0 02             	shl    $0x2,%eax
  8010bc:	01 d0                	add    %edx,%eax
  8010be:	01 c0                	add    %eax,%eax
  8010c0:	29 c1                	sub    %eax,%ecx
  8010c2:	89 ca                	mov    %ecx,%edx
  8010c4:	85 d2                	test   %edx,%edx
  8010c6:	75 9c                	jne    801064 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d2:	48                   	dec    %eax
  8010d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010da:	74 3d                	je     801119 <ltostr+0xe2>
		start = 1 ;
  8010dc:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010e3:	eb 34                	jmp    801119 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8010e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010eb:	01 d0                	add    %edx,%eax
  8010ed:	8a 00                	mov    (%eax),%al
  8010ef:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f8:	01 c2                	add    %eax,%edx
  8010fa:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801100:	01 c8                	add    %ecx,%eax
  801102:	8a 00                	mov    (%eax),%al
  801104:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801106:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801109:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110c:	01 c2                	add    %eax,%edx
  80110e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801111:	88 02                	mov    %al,(%edx)
		start++ ;
  801113:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801116:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801119:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80111c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80111f:	7c c4                	jl     8010e5 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801121:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801124:	8b 45 0c             	mov    0xc(%ebp),%eax
  801127:	01 d0                	add    %edx,%eax
  801129:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80112c:	90                   	nop
  80112d:	c9                   	leave  
  80112e:	c3                   	ret    

0080112f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80112f:	55                   	push   %ebp
  801130:	89 e5                	mov    %esp,%ebp
  801132:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801135:	ff 75 08             	pushl  0x8(%ebp)
  801138:	e8 54 fa ff ff       	call   800b91 <strlen>
  80113d:	83 c4 04             	add    $0x4,%esp
  801140:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801143:	ff 75 0c             	pushl  0xc(%ebp)
  801146:	e8 46 fa ff ff       	call   800b91 <strlen>
  80114b:	83 c4 04             	add    $0x4,%esp
  80114e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801151:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801158:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80115f:	eb 17                	jmp    801178 <strcconcat+0x49>
		final[s] = str1[s] ;
  801161:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801164:	8b 45 10             	mov    0x10(%ebp),%eax
  801167:	01 c2                	add    %eax,%edx
  801169:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80116c:	8b 45 08             	mov    0x8(%ebp),%eax
  80116f:	01 c8                	add    %ecx,%eax
  801171:	8a 00                	mov    (%eax),%al
  801173:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801175:	ff 45 fc             	incl   -0x4(%ebp)
  801178:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80117b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80117e:	7c e1                	jl     801161 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801180:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801187:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80118e:	eb 1f                	jmp    8011af <strcconcat+0x80>
		final[s++] = str2[i] ;
  801190:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801193:	8d 50 01             	lea    0x1(%eax),%edx
  801196:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801199:	89 c2                	mov    %eax,%edx
  80119b:	8b 45 10             	mov    0x10(%ebp),%eax
  80119e:	01 c2                	add    %eax,%edx
  8011a0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a6:	01 c8                	add    %ecx,%eax
  8011a8:	8a 00                	mov    (%eax),%al
  8011aa:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011ac:	ff 45 f8             	incl   -0x8(%ebp)
  8011af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011b5:	7c d9                	jl     801190 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8011bd:	01 d0                	add    %edx,%eax
  8011bf:	c6 00 00             	movb   $0x0,(%eax)
}
  8011c2:	90                   	nop
  8011c3:	c9                   	leave  
  8011c4:	c3                   	ret    

008011c5 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011c5:	55                   	push   %ebp
  8011c6:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8011cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d4:	8b 00                	mov    (%eax),%eax
  8011d6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e0:	01 d0                	add    %edx,%eax
  8011e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011e8:	eb 0c                	jmp    8011f6 <strsplit+0x31>
			*string++ = 0;
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	8d 50 01             	lea    0x1(%eax),%edx
  8011f0:	89 55 08             	mov    %edx,0x8(%ebp)
  8011f3:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f9:	8a 00                	mov    (%eax),%al
  8011fb:	84 c0                	test   %al,%al
  8011fd:	74 18                	je     801217 <strsplit+0x52>
  8011ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801202:	8a 00                	mov    (%eax),%al
  801204:	0f be c0             	movsbl %al,%eax
  801207:	50                   	push   %eax
  801208:	ff 75 0c             	pushl  0xc(%ebp)
  80120b:	e8 13 fb ff ff       	call   800d23 <strchr>
  801210:	83 c4 08             	add    $0x8,%esp
  801213:	85 c0                	test   %eax,%eax
  801215:	75 d3                	jne    8011ea <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801217:	8b 45 08             	mov    0x8(%ebp),%eax
  80121a:	8a 00                	mov    (%eax),%al
  80121c:	84 c0                	test   %al,%al
  80121e:	74 5a                	je     80127a <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801220:	8b 45 14             	mov    0x14(%ebp),%eax
  801223:	8b 00                	mov    (%eax),%eax
  801225:	83 f8 0f             	cmp    $0xf,%eax
  801228:	75 07                	jne    801231 <strsplit+0x6c>
		{
			return 0;
  80122a:	b8 00 00 00 00       	mov    $0x0,%eax
  80122f:	eb 66                	jmp    801297 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801231:	8b 45 14             	mov    0x14(%ebp),%eax
  801234:	8b 00                	mov    (%eax),%eax
  801236:	8d 48 01             	lea    0x1(%eax),%ecx
  801239:	8b 55 14             	mov    0x14(%ebp),%edx
  80123c:	89 0a                	mov    %ecx,(%edx)
  80123e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801245:	8b 45 10             	mov    0x10(%ebp),%eax
  801248:	01 c2                	add    %eax,%edx
  80124a:	8b 45 08             	mov    0x8(%ebp),%eax
  80124d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80124f:	eb 03                	jmp    801254 <strsplit+0x8f>
			string++;
  801251:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801254:	8b 45 08             	mov    0x8(%ebp),%eax
  801257:	8a 00                	mov    (%eax),%al
  801259:	84 c0                	test   %al,%al
  80125b:	74 8b                	je     8011e8 <strsplit+0x23>
  80125d:	8b 45 08             	mov    0x8(%ebp),%eax
  801260:	8a 00                	mov    (%eax),%al
  801262:	0f be c0             	movsbl %al,%eax
  801265:	50                   	push   %eax
  801266:	ff 75 0c             	pushl  0xc(%ebp)
  801269:	e8 b5 fa ff ff       	call   800d23 <strchr>
  80126e:	83 c4 08             	add    $0x8,%esp
  801271:	85 c0                	test   %eax,%eax
  801273:	74 dc                	je     801251 <strsplit+0x8c>
			string++;
	}
  801275:	e9 6e ff ff ff       	jmp    8011e8 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80127a:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80127b:	8b 45 14             	mov    0x14(%ebp),%eax
  80127e:	8b 00                	mov    (%eax),%eax
  801280:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801287:	8b 45 10             	mov    0x10(%ebp),%eax
  80128a:	01 d0                	add    %edx,%eax
  80128c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801292:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801297:	c9                   	leave  
  801298:	c3                   	ret    

00801299 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801299:	55                   	push   %ebp
  80129a:	89 e5                	mov    %esp,%ebp
  80129c:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80129f:	a1 04 40 80 00       	mov    0x804004,%eax
  8012a4:	85 c0                	test   %eax,%eax
  8012a6:	74 1f                	je     8012c7 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012a8:	e8 1d 00 00 00       	call   8012ca <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8012ad:	83 ec 0c             	sub    $0xc,%esp
  8012b0:	68 90 38 80 00       	push   $0x803890
  8012b5:	e8 55 f2 ff ff       	call   80050f <cprintf>
  8012ba:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012bd:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8012c4:	00 00 00 
	}
}
  8012c7:	90                   	nop
  8012c8:	c9                   	leave  
  8012c9:	c3                   	ret    

008012ca <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8012ca:	55                   	push   %ebp
  8012cb:	89 e5                	mov    %esp,%ebp
  8012cd:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  8012d0:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8012d7:	00 00 00 
  8012da:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  8012e1:	00 00 00 
  8012e4:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  8012eb:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  8012ee:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8012f5:	00 00 00 
  8012f8:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  8012ff:	00 00 00 
  801302:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801309:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  80130c:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801313:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801316:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80131b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801320:	a3 50 40 80 00       	mov    %eax,0x804050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801325:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80132c:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  80132f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801336:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801339:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  80133e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801341:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801344:	ba 00 00 00 00       	mov    $0x0,%edx
  801349:	f7 75 f0             	divl   -0x10(%ebp)
  80134c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80134f:	29 d0                	sub    %edx,%eax
  801351:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  801354:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  80135b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80135e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801363:	2d 00 10 00 00       	sub    $0x1000,%eax
  801368:	83 ec 04             	sub    $0x4,%esp
  80136b:	6a 06                	push   $0x6
  80136d:	ff 75 e8             	pushl  -0x18(%ebp)
  801370:	50                   	push   %eax
  801371:	e8 d4 05 00 00       	call   80194a <sys_allocate_chunk>
  801376:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801379:	a1 20 41 80 00       	mov    0x804120,%eax
  80137e:	83 ec 0c             	sub    $0xc,%esp
  801381:	50                   	push   %eax
  801382:	e8 49 0c 00 00       	call   801fd0 <initialize_MemBlocksList>
  801387:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  80138a:	a1 48 41 80 00       	mov    0x804148,%eax
  80138f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  801392:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801396:	75 14                	jne    8013ac <initialize_dyn_block_system+0xe2>
  801398:	83 ec 04             	sub    $0x4,%esp
  80139b:	68 b5 38 80 00       	push   $0x8038b5
  8013a0:	6a 39                	push   $0x39
  8013a2:	68 d3 38 80 00       	push   $0x8038d3
  8013a7:	e8 af ee ff ff       	call   80025b <_panic>
  8013ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013af:	8b 00                	mov    (%eax),%eax
  8013b1:	85 c0                	test   %eax,%eax
  8013b3:	74 10                	je     8013c5 <initialize_dyn_block_system+0xfb>
  8013b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013b8:	8b 00                	mov    (%eax),%eax
  8013ba:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8013bd:	8b 52 04             	mov    0x4(%edx),%edx
  8013c0:	89 50 04             	mov    %edx,0x4(%eax)
  8013c3:	eb 0b                	jmp    8013d0 <initialize_dyn_block_system+0x106>
  8013c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013c8:	8b 40 04             	mov    0x4(%eax),%eax
  8013cb:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8013d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013d3:	8b 40 04             	mov    0x4(%eax),%eax
  8013d6:	85 c0                	test   %eax,%eax
  8013d8:	74 0f                	je     8013e9 <initialize_dyn_block_system+0x11f>
  8013da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013dd:	8b 40 04             	mov    0x4(%eax),%eax
  8013e0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8013e3:	8b 12                	mov    (%edx),%edx
  8013e5:	89 10                	mov    %edx,(%eax)
  8013e7:	eb 0a                	jmp    8013f3 <initialize_dyn_block_system+0x129>
  8013e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013ec:	8b 00                	mov    (%eax),%eax
  8013ee:	a3 48 41 80 00       	mov    %eax,0x804148
  8013f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8013fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801406:	a1 54 41 80 00       	mov    0x804154,%eax
  80140b:	48                   	dec    %eax
  80140c:	a3 54 41 80 00       	mov    %eax,0x804154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  801411:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801414:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  80141b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80141e:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  801425:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801429:	75 14                	jne    80143f <initialize_dyn_block_system+0x175>
  80142b:	83 ec 04             	sub    $0x4,%esp
  80142e:	68 e0 38 80 00       	push   $0x8038e0
  801433:	6a 3f                	push   $0x3f
  801435:	68 d3 38 80 00       	push   $0x8038d3
  80143a:	e8 1c ee ff ff       	call   80025b <_panic>
  80143f:	8b 15 38 41 80 00    	mov    0x804138,%edx
  801445:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801448:	89 10                	mov    %edx,(%eax)
  80144a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80144d:	8b 00                	mov    (%eax),%eax
  80144f:	85 c0                	test   %eax,%eax
  801451:	74 0d                	je     801460 <initialize_dyn_block_system+0x196>
  801453:	a1 38 41 80 00       	mov    0x804138,%eax
  801458:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80145b:	89 50 04             	mov    %edx,0x4(%eax)
  80145e:	eb 08                	jmp    801468 <initialize_dyn_block_system+0x19e>
  801460:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801463:	a3 3c 41 80 00       	mov    %eax,0x80413c
  801468:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80146b:	a3 38 41 80 00       	mov    %eax,0x804138
  801470:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801473:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80147a:	a1 44 41 80 00       	mov    0x804144,%eax
  80147f:	40                   	inc    %eax
  801480:	a3 44 41 80 00       	mov    %eax,0x804144

}
  801485:	90                   	nop
  801486:	c9                   	leave  
  801487:	c3                   	ret    

00801488 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801488:	55                   	push   %ebp
  801489:	89 e5                	mov    %esp,%ebp
  80148b:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80148e:	e8 06 fe ff ff       	call   801299 <InitializeUHeap>
	if (size == 0) return NULL ;
  801493:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801497:	75 07                	jne    8014a0 <malloc+0x18>
  801499:	b8 00 00 00 00       	mov    $0x0,%eax
  80149e:	eb 7d                	jmp    80151d <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  8014a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8014a7:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8014ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8014b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b4:	01 d0                	add    %edx,%eax
  8014b6:	48                   	dec    %eax
  8014b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8014ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8014c2:	f7 75 f0             	divl   -0x10(%ebp)
  8014c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014c8:	29 d0                	sub    %edx,%eax
  8014ca:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  8014cd:	e8 46 08 00 00       	call   801d18 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014d2:	83 f8 01             	cmp    $0x1,%eax
  8014d5:	75 07                	jne    8014de <malloc+0x56>
  8014d7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  8014de:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  8014e2:	75 34                	jne    801518 <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  8014e4:	83 ec 0c             	sub    $0xc,%esp
  8014e7:	ff 75 e8             	pushl  -0x18(%ebp)
  8014ea:	e8 73 0e 00 00       	call   802362 <alloc_block_FF>
  8014ef:	83 c4 10             	add    $0x10,%esp
  8014f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  8014f5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014f9:	74 16                	je     801511 <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  8014fb:	83 ec 0c             	sub    $0xc,%esp
  8014fe:	ff 75 e4             	pushl  -0x1c(%ebp)
  801501:	e8 ff 0b 00 00       	call   802105 <insert_sorted_allocList>
  801506:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  801509:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80150c:	8b 40 08             	mov    0x8(%eax),%eax
  80150f:	eb 0c                	jmp    80151d <malloc+0x95>
	             }
	             else
	             	return NULL;
  801511:	b8 00 00 00 00       	mov    $0x0,%eax
  801516:	eb 05                	jmp    80151d <malloc+0x95>
	      	  }
	          else
	               return NULL;
  801518:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  80151d:	c9                   	leave  
  80151e:	c3                   	ret    

0080151f <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80151f:	55                   	push   %ebp
  801520:	89 e5                	mov    %esp,%ebp
  801522:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  801525:	8b 45 08             	mov    0x8(%ebp),%eax
  801528:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  80152b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80152e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801531:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801534:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801539:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  80153c:	83 ec 08             	sub    $0x8,%esp
  80153f:	ff 75 f4             	pushl  -0xc(%ebp)
  801542:	68 40 40 80 00       	push   $0x804040
  801547:	e8 61 0b 00 00       	call   8020ad <find_block>
  80154c:	83 c4 10             	add    $0x10,%esp
  80154f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  801552:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801556:	0f 84 a5 00 00 00    	je     801601 <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  80155c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80155f:	8b 40 0c             	mov    0xc(%eax),%eax
  801562:	83 ec 08             	sub    $0x8,%esp
  801565:	50                   	push   %eax
  801566:	ff 75 f4             	pushl  -0xc(%ebp)
  801569:	e8 a4 03 00 00       	call   801912 <sys_free_user_mem>
  80156e:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  801571:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801575:	75 17                	jne    80158e <free+0x6f>
  801577:	83 ec 04             	sub    $0x4,%esp
  80157a:	68 b5 38 80 00       	push   $0x8038b5
  80157f:	68 87 00 00 00       	push   $0x87
  801584:	68 d3 38 80 00       	push   $0x8038d3
  801589:	e8 cd ec ff ff       	call   80025b <_panic>
  80158e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801591:	8b 00                	mov    (%eax),%eax
  801593:	85 c0                	test   %eax,%eax
  801595:	74 10                	je     8015a7 <free+0x88>
  801597:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80159a:	8b 00                	mov    (%eax),%eax
  80159c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80159f:	8b 52 04             	mov    0x4(%edx),%edx
  8015a2:	89 50 04             	mov    %edx,0x4(%eax)
  8015a5:	eb 0b                	jmp    8015b2 <free+0x93>
  8015a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015aa:	8b 40 04             	mov    0x4(%eax),%eax
  8015ad:	a3 44 40 80 00       	mov    %eax,0x804044
  8015b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015b5:	8b 40 04             	mov    0x4(%eax),%eax
  8015b8:	85 c0                	test   %eax,%eax
  8015ba:	74 0f                	je     8015cb <free+0xac>
  8015bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015bf:	8b 40 04             	mov    0x4(%eax),%eax
  8015c2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015c5:	8b 12                	mov    (%edx),%edx
  8015c7:	89 10                	mov    %edx,(%eax)
  8015c9:	eb 0a                	jmp    8015d5 <free+0xb6>
  8015cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ce:	8b 00                	mov    (%eax),%eax
  8015d0:	a3 40 40 80 00       	mov    %eax,0x804040
  8015d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015e8:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8015ed:	48                   	dec    %eax
  8015ee:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(theBlock);
  8015f3:	83 ec 0c             	sub    $0xc,%esp
  8015f6:	ff 75 ec             	pushl  -0x14(%ebp)
  8015f9:	e8 37 12 00 00       	call   802835 <insert_sorted_with_merge_freeList>
  8015fe:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  801601:	90                   	nop
  801602:	c9                   	leave  
  801603:	c3                   	ret    

00801604 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801604:	55                   	push   %ebp
  801605:	89 e5                	mov    %esp,%ebp
  801607:	83 ec 38             	sub    $0x38,%esp
  80160a:	8b 45 10             	mov    0x10(%ebp),%eax
  80160d:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801610:	e8 84 fc ff ff       	call   801299 <InitializeUHeap>
	if (size == 0) return NULL ;
  801615:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801619:	75 07                	jne    801622 <smalloc+0x1e>
  80161b:	b8 00 00 00 00       	mov    $0x0,%eax
  801620:	eb 7e                	jmp    8016a0 <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  801622:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801629:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801630:	8b 55 0c             	mov    0xc(%ebp),%edx
  801633:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801636:	01 d0                	add    %edx,%eax
  801638:	48                   	dec    %eax
  801639:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80163c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80163f:	ba 00 00 00 00       	mov    $0x0,%edx
  801644:	f7 75 f0             	divl   -0x10(%ebp)
  801647:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80164a:	29 d0                	sub    %edx,%eax
  80164c:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  80164f:	e8 c4 06 00 00       	call   801d18 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801654:	83 f8 01             	cmp    $0x1,%eax
  801657:	75 42                	jne    80169b <smalloc+0x97>

		  va = malloc(newsize) ;
  801659:	83 ec 0c             	sub    $0xc,%esp
  80165c:	ff 75 e8             	pushl  -0x18(%ebp)
  80165f:	e8 24 fe ff ff       	call   801488 <malloc>
  801664:	83 c4 10             	add    $0x10,%esp
  801667:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  80166a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80166e:	74 24                	je     801694 <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  801670:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801674:	ff 75 e4             	pushl  -0x1c(%ebp)
  801677:	50                   	push   %eax
  801678:	ff 75 e8             	pushl  -0x18(%ebp)
  80167b:	ff 75 08             	pushl  0x8(%ebp)
  80167e:	e8 1a 04 00 00       	call   801a9d <sys_createSharedObject>
  801683:	83 c4 10             	add    $0x10,%esp
  801686:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  801689:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80168d:	78 0c                	js     80169b <smalloc+0x97>
					  return va ;
  80168f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801692:	eb 0c                	jmp    8016a0 <smalloc+0x9c>
				 }
				 else
					return NULL;
  801694:	b8 00 00 00 00       	mov    $0x0,%eax
  801699:	eb 05                	jmp    8016a0 <smalloc+0x9c>
	  }
		  return NULL ;
  80169b:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016a0:	c9                   	leave  
  8016a1:	c3                   	ret    

008016a2 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016a2:	55                   	push   %ebp
  8016a3:	89 e5                	mov    %esp,%ebp
  8016a5:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016a8:	e8 ec fb ff ff       	call   801299 <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  8016ad:	83 ec 08             	sub    $0x8,%esp
  8016b0:	ff 75 0c             	pushl  0xc(%ebp)
  8016b3:	ff 75 08             	pushl  0x8(%ebp)
  8016b6:	e8 0c 04 00 00       	call   801ac7 <sys_getSizeOfSharedObject>
  8016bb:	83 c4 10             	add    $0x10,%esp
  8016be:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  8016c1:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8016c5:	75 07                	jne    8016ce <sget+0x2c>
  8016c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8016cc:	eb 75                	jmp    801743 <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8016ce:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8016d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016db:	01 d0                	add    %edx,%eax
  8016dd:	48                   	dec    %eax
  8016de:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e9:	f7 75 f0             	divl   -0x10(%ebp)
  8016ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016ef:	29 d0                	sub    %edx,%eax
  8016f1:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  8016f4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  8016fb:	e8 18 06 00 00       	call   801d18 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801700:	83 f8 01             	cmp    $0x1,%eax
  801703:	75 39                	jne    80173e <sget+0x9c>

		  va = malloc(newsize) ;
  801705:	83 ec 0c             	sub    $0xc,%esp
  801708:	ff 75 e8             	pushl  -0x18(%ebp)
  80170b:	e8 78 fd ff ff       	call   801488 <malloc>
  801710:	83 c4 10             	add    $0x10,%esp
  801713:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  801716:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80171a:	74 22                	je     80173e <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  80171c:	83 ec 04             	sub    $0x4,%esp
  80171f:	ff 75 e0             	pushl  -0x20(%ebp)
  801722:	ff 75 0c             	pushl  0xc(%ebp)
  801725:	ff 75 08             	pushl  0x8(%ebp)
  801728:	e8 b7 03 00 00       	call   801ae4 <sys_getSharedObject>
  80172d:	83 c4 10             	add    $0x10,%esp
  801730:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  801733:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801737:	78 05                	js     80173e <sget+0x9c>
					  return va;
  801739:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80173c:	eb 05                	jmp    801743 <sget+0xa1>
				  }
			  }
     }
         return NULL;
  80173e:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  801743:	c9                   	leave  
  801744:	c3                   	ret    

00801745 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801745:	55                   	push   %ebp
  801746:	89 e5                	mov    %esp,%ebp
  801748:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80174b:	e8 49 fb ff ff       	call   801299 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801750:	83 ec 04             	sub    $0x4,%esp
  801753:	68 04 39 80 00       	push   $0x803904
  801758:	68 1e 01 00 00       	push   $0x11e
  80175d:	68 d3 38 80 00       	push   $0x8038d3
  801762:	e8 f4 ea ff ff       	call   80025b <_panic>

00801767 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801767:	55                   	push   %ebp
  801768:	89 e5                	mov    %esp,%ebp
  80176a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80176d:	83 ec 04             	sub    $0x4,%esp
  801770:	68 2c 39 80 00       	push   $0x80392c
  801775:	68 32 01 00 00       	push   $0x132
  80177a:	68 d3 38 80 00       	push   $0x8038d3
  80177f:	e8 d7 ea ff ff       	call   80025b <_panic>

00801784 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801784:	55                   	push   %ebp
  801785:	89 e5                	mov    %esp,%ebp
  801787:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80178a:	83 ec 04             	sub    $0x4,%esp
  80178d:	68 50 39 80 00       	push   $0x803950
  801792:	68 3d 01 00 00       	push   $0x13d
  801797:	68 d3 38 80 00       	push   $0x8038d3
  80179c:	e8 ba ea ff ff       	call   80025b <_panic>

008017a1 <shrink>:

}
void shrink(uint32 newSize)
{
  8017a1:	55                   	push   %ebp
  8017a2:	89 e5                	mov    %esp,%ebp
  8017a4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017a7:	83 ec 04             	sub    $0x4,%esp
  8017aa:	68 50 39 80 00       	push   $0x803950
  8017af:	68 42 01 00 00       	push   $0x142
  8017b4:	68 d3 38 80 00       	push   $0x8038d3
  8017b9:	e8 9d ea ff ff       	call   80025b <_panic>

008017be <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017be:	55                   	push   %ebp
  8017bf:	89 e5                	mov    %esp,%ebp
  8017c1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017c4:	83 ec 04             	sub    $0x4,%esp
  8017c7:	68 50 39 80 00       	push   $0x803950
  8017cc:	68 47 01 00 00       	push   $0x147
  8017d1:	68 d3 38 80 00       	push   $0x8038d3
  8017d6:	e8 80 ea ff ff       	call   80025b <_panic>

008017db <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
  8017de:	57                   	push   %edi
  8017df:	56                   	push   %esi
  8017e0:	53                   	push   %ebx
  8017e1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ea:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017ed:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017f0:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017f3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017f6:	cd 30                	int    $0x30
  8017f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8017fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017fe:	83 c4 10             	add    $0x10,%esp
  801801:	5b                   	pop    %ebx
  801802:	5e                   	pop    %esi
  801803:	5f                   	pop    %edi
  801804:	5d                   	pop    %ebp
  801805:	c3                   	ret    

00801806 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
  801809:	83 ec 04             	sub    $0x4,%esp
  80180c:	8b 45 10             	mov    0x10(%ebp),%eax
  80180f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801812:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801816:	8b 45 08             	mov    0x8(%ebp),%eax
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	52                   	push   %edx
  80181e:	ff 75 0c             	pushl  0xc(%ebp)
  801821:	50                   	push   %eax
  801822:	6a 00                	push   $0x0
  801824:	e8 b2 ff ff ff       	call   8017db <syscall>
  801829:	83 c4 18             	add    $0x18,%esp
}
  80182c:	90                   	nop
  80182d:	c9                   	leave  
  80182e:	c3                   	ret    

0080182f <sys_cgetc>:

int
sys_cgetc(void)
{
  80182f:	55                   	push   %ebp
  801830:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 01                	push   $0x1
  80183e:	e8 98 ff ff ff       	call   8017db <syscall>
  801843:	83 c4 18             	add    $0x18,%esp
}
  801846:	c9                   	leave  
  801847:	c3                   	ret    

00801848 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80184b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80184e:	8b 45 08             	mov    0x8(%ebp),%eax
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	52                   	push   %edx
  801858:	50                   	push   %eax
  801859:	6a 05                	push   $0x5
  80185b:	e8 7b ff ff ff       	call   8017db <syscall>
  801860:	83 c4 18             	add    $0x18,%esp
}
  801863:	c9                   	leave  
  801864:	c3                   	ret    

00801865 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801865:	55                   	push   %ebp
  801866:	89 e5                	mov    %esp,%ebp
  801868:	56                   	push   %esi
  801869:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80186a:	8b 75 18             	mov    0x18(%ebp),%esi
  80186d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801870:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801873:	8b 55 0c             	mov    0xc(%ebp),%edx
  801876:	8b 45 08             	mov    0x8(%ebp),%eax
  801879:	56                   	push   %esi
  80187a:	53                   	push   %ebx
  80187b:	51                   	push   %ecx
  80187c:	52                   	push   %edx
  80187d:	50                   	push   %eax
  80187e:	6a 06                	push   $0x6
  801880:	e8 56 ff ff ff       	call   8017db <syscall>
  801885:	83 c4 18             	add    $0x18,%esp
}
  801888:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80188b:	5b                   	pop    %ebx
  80188c:	5e                   	pop    %esi
  80188d:	5d                   	pop    %ebp
  80188e:	c3                   	ret    

0080188f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80188f:	55                   	push   %ebp
  801890:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801892:	8b 55 0c             	mov    0xc(%ebp),%edx
  801895:	8b 45 08             	mov    0x8(%ebp),%eax
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	52                   	push   %edx
  80189f:	50                   	push   %eax
  8018a0:	6a 07                	push   $0x7
  8018a2:	e8 34 ff ff ff       	call   8017db <syscall>
  8018a7:	83 c4 18             	add    $0x18,%esp
}
  8018aa:	c9                   	leave  
  8018ab:	c3                   	ret    

008018ac <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	ff 75 0c             	pushl  0xc(%ebp)
  8018b8:	ff 75 08             	pushl  0x8(%ebp)
  8018bb:	6a 08                	push   $0x8
  8018bd:	e8 19 ff ff ff       	call   8017db <syscall>
  8018c2:	83 c4 18             	add    $0x18,%esp
}
  8018c5:	c9                   	leave  
  8018c6:	c3                   	ret    

008018c7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018c7:	55                   	push   %ebp
  8018c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 09                	push   $0x9
  8018d6:	e8 00 ff ff ff       	call   8017db <syscall>
  8018db:	83 c4 18             	add    $0x18,%esp
}
  8018de:	c9                   	leave  
  8018df:	c3                   	ret    

008018e0 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 0a                	push   $0xa
  8018ef:	e8 e7 fe ff ff       	call   8017db <syscall>
  8018f4:	83 c4 18             	add    $0x18,%esp
}
  8018f7:	c9                   	leave  
  8018f8:	c3                   	ret    

008018f9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8018f9:	55                   	push   %ebp
  8018fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 0b                	push   $0xb
  801908:	e8 ce fe ff ff       	call   8017db <syscall>
  80190d:	83 c4 18             	add    $0x18,%esp
}
  801910:	c9                   	leave  
  801911:	c3                   	ret    

00801912 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801912:	55                   	push   %ebp
  801913:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	ff 75 0c             	pushl  0xc(%ebp)
  80191e:	ff 75 08             	pushl  0x8(%ebp)
  801921:	6a 0f                	push   $0xf
  801923:	e8 b3 fe ff ff       	call   8017db <syscall>
  801928:	83 c4 18             	add    $0x18,%esp
	return;
  80192b:	90                   	nop
}
  80192c:	c9                   	leave  
  80192d:	c3                   	ret    

0080192e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	ff 75 0c             	pushl  0xc(%ebp)
  80193a:	ff 75 08             	pushl  0x8(%ebp)
  80193d:	6a 10                	push   $0x10
  80193f:	e8 97 fe ff ff       	call   8017db <syscall>
  801944:	83 c4 18             	add    $0x18,%esp
	return ;
  801947:	90                   	nop
}
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	ff 75 10             	pushl  0x10(%ebp)
  801954:	ff 75 0c             	pushl  0xc(%ebp)
  801957:	ff 75 08             	pushl  0x8(%ebp)
  80195a:	6a 11                	push   $0x11
  80195c:	e8 7a fe ff ff       	call   8017db <syscall>
  801961:	83 c4 18             	add    $0x18,%esp
	return ;
  801964:	90                   	nop
}
  801965:	c9                   	leave  
  801966:	c3                   	ret    

00801967 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801967:	55                   	push   %ebp
  801968:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 0c                	push   $0xc
  801976:	e8 60 fe ff ff       	call   8017db <syscall>
  80197b:	83 c4 18             	add    $0x18,%esp
}
  80197e:	c9                   	leave  
  80197f:	c3                   	ret    

00801980 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	ff 75 08             	pushl  0x8(%ebp)
  80198e:	6a 0d                	push   $0xd
  801990:	e8 46 fe ff ff       	call   8017db <syscall>
  801995:	83 c4 18             	add    $0x18,%esp
}
  801998:	c9                   	leave  
  801999:	c3                   	ret    

0080199a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 0e                	push   $0xe
  8019a9:	e8 2d fe ff ff       	call   8017db <syscall>
  8019ae:	83 c4 18             	add    $0x18,%esp
}
  8019b1:	90                   	nop
  8019b2:	c9                   	leave  
  8019b3:	c3                   	ret    

008019b4 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019b4:	55                   	push   %ebp
  8019b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 13                	push   $0x13
  8019c3:	e8 13 fe ff ff       	call   8017db <syscall>
  8019c8:	83 c4 18             	add    $0x18,%esp
}
  8019cb:	90                   	nop
  8019cc:	c9                   	leave  
  8019cd:	c3                   	ret    

008019ce <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019ce:	55                   	push   %ebp
  8019cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 14                	push   $0x14
  8019dd:	e8 f9 fd ff ff       	call   8017db <syscall>
  8019e2:	83 c4 18             	add    $0x18,%esp
}
  8019e5:	90                   	nop
  8019e6:	c9                   	leave  
  8019e7:	c3                   	ret    

008019e8 <sys_cputc>:


void
sys_cputc(const char c)
{
  8019e8:	55                   	push   %ebp
  8019e9:	89 e5                	mov    %esp,%ebp
  8019eb:	83 ec 04             	sub    $0x4,%esp
  8019ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019f4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	50                   	push   %eax
  801a01:	6a 15                	push   $0x15
  801a03:	e8 d3 fd ff ff       	call   8017db <syscall>
  801a08:	83 c4 18             	add    $0x18,%esp
}
  801a0b:	90                   	nop
  801a0c:	c9                   	leave  
  801a0d:	c3                   	ret    

00801a0e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a0e:	55                   	push   %ebp
  801a0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 16                	push   $0x16
  801a1d:	e8 b9 fd ff ff       	call   8017db <syscall>
  801a22:	83 c4 18             	add    $0x18,%esp
}
  801a25:	90                   	nop
  801a26:	c9                   	leave  
  801a27:	c3                   	ret    

00801a28 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a28:	55                   	push   %ebp
  801a29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	ff 75 0c             	pushl  0xc(%ebp)
  801a37:	50                   	push   %eax
  801a38:	6a 17                	push   $0x17
  801a3a:	e8 9c fd ff ff       	call   8017db <syscall>
  801a3f:	83 c4 18             	add    $0x18,%esp
}
  801a42:	c9                   	leave  
  801a43:	c3                   	ret    

00801a44 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a44:	55                   	push   %ebp
  801a45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a47:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	52                   	push   %edx
  801a54:	50                   	push   %eax
  801a55:	6a 1a                	push   $0x1a
  801a57:	e8 7f fd ff ff       	call   8017db <syscall>
  801a5c:	83 c4 18             	add    $0x18,%esp
}
  801a5f:	c9                   	leave  
  801a60:	c3                   	ret    

00801a61 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a64:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a67:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	52                   	push   %edx
  801a71:	50                   	push   %eax
  801a72:	6a 18                	push   $0x18
  801a74:	e8 62 fd ff ff       	call   8017db <syscall>
  801a79:	83 c4 18             	add    $0x18,%esp
}
  801a7c:	90                   	nop
  801a7d:	c9                   	leave  
  801a7e:	c3                   	ret    

00801a7f <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a82:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a85:	8b 45 08             	mov    0x8(%ebp),%eax
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	52                   	push   %edx
  801a8f:	50                   	push   %eax
  801a90:	6a 19                	push   $0x19
  801a92:	e8 44 fd ff ff       	call   8017db <syscall>
  801a97:	83 c4 18             	add    $0x18,%esp
}
  801a9a:	90                   	nop
  801a9b:	c9                   	leave  
  801a9c:	c3                   	ret    

00801a9d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a9d:	55                   	push   %ebp
  801a9e:	89 e5                	mov    %esp,%ebp
  801aa0:	83 ec 04             	sub    $0x4,%esp
  801aa3:	8b 45 10             	mov    0x10(%ebp),%eax
  801aa6:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801aa9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801aac:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab3:	6a 00                	push   $0x0
  801ab5:	51                   	push   %ecx
  801ab6:	52                   	push   %edx
  801ab7:	ff 75 0c             	pushl  0xc(%ebp)
  801aba:	50                   	push   %eax
  801abb:	6a 1b                	push   $0x1b
  801abd:	e8 19 fd ff ff       	call   8017db <syscall>
  801ac2:	83 c4 18             	add    $0x18,%esp
}
  801ac5:	c9                   	leave  
  801ac6:	c3                   	ret    

00801ac7 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801aca:	8b 55 0c             	mov    0xc(%ebp),%edx
  801acd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	52                   	push   %edx
  801ad7:	50                   	push   %eax
  801ad8:	6a 1c                	push   $0x1c
  801ada:	e8 fc fc ff ff       	call   8017db <syscall>
  801adf:	83 c4 18             	add    $0x18,%esp
}
  801ae2:	c9                   	leave  
  801ae3:	c3                   	ret    

00801ae4 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ae4:	55                   	push   %ebp
  801ae5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ae7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801aea:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aed:	8b 45 08             	mov    0x8(%ebp),%eax
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	51                   	push   %ecx
  801af5:	52                   	push   %edx
  801af6:	50                   	push   %eax
  801af7:	6a 1d                	push   $0x1d
  801af9:	e8 dd fc ff ff       	call   8017db <syscall>
  801afe:	83 c4 18             	add    $0x18,%esp
}
  801b01:	c9                   	leave  
  801b02:	c3                   	ret    

00801b03 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b03:	55                   	push   %ebp
  801b04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b06:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b09:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	52                   	push   %edx
  801b13:	50                   	push   %eax
  801b14:	6a 1e                	push   $0x1e
  801b16:	e8 c0 fc ff ff       	call   8017db <syscall>
  801b1b:	83 c4 18             	add    $0x18,%esp
}
  801b1e:	c9                   	leave  
  801b1f:	c3                   	ret    

00801b20 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 1f                	push   $0x1f
  801b2f:	e8 a7 fc ff ff       	call   8017db <syscall>
  801b34:	83 c4 18             	add    $0x18,%esp
}
  801b37:	c9                   	leave  
  801b38:	c3                   	ret    

00801b39 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3f:	6a 00                	push   $0x0
  801b41:	ff 75 14             	pushl  0x14(%ebp)
  801b44:	ff 75 10             	pushl  0x10(%ebp)
  801b47:	ff 75 0c             	pushl  0xc(%ebp)
  801b4a:	50                   	push   %eax
  801b4b:	6a 20                	push   $0x20
  801b4d:	e8 89 fc ff ff       	call   8017db <syscall>
  801b52:	83 c4 18             	add    $0x18,%esp
}
  801b55:	c9                   	leave  
  801b56:	c3                   	ret    

00801b57 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	50                   	push   %eax
  801b66:	6a 21                	push   $0x21
  801b68:	e8 6e fc ff ff       	call   8017db <syscall>
  801b6d:	83 c4 18             	add    $0x18,%esp
}
  801b70:	90                   	nop
  801b71:	c9                   	leave  
  801b72:	c3                   	ret    

00801b73 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b73:	55                   	push   %ebp
  801b74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b76:	8b 45 08             	mov    0x8(%ebp),%eax
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	50                   	push   %eax
  801b82:	6a 22                	push   $0x22
  801b84:	e8 52 fc ff ff       	call   8017db <syscall>
  801b89:	83 c4 18             	add    $0x18,%esp
}
  801b8c:	c9                   	leave  
  801b8d:	c3                   	ret    

00801b8e <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b8e:	55                   	push   %ebp
  801b8f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 02                	push   $0x2
  801b9d:	e8 39 fc ff ff       	call   8017db <syscall>
  801ba2:	83 c4 18             	add    $0x18,%esp
}
  801ba5:	c9                   	leave  
  801ba6:	c3                   	ret    

00801ba7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ba7:	55                   	push   %ebp
  801ba8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 03                	push   $0x3
  801bb6:	e8 20 fc ff ff       	call   8017db <syscall>
  801bbb:	83 c4 18             	add    $0x18,%esp
}
  801bbe:	c9                   	leave  
  801bbf:	c3                   	ret    

00801bc0 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 04                	push   $0x4
  801bcf:	e8 07 fc ff ff       	call   8017db <syscall>
  801bd4:	83 c4 18             	add    $0x18,%esp
}
  801bd7:	c9                   	leave  
  801bd8:	c3                   	ret    

00801bd9 <sys_exit_env>:


void sys_exit_env(void)
{
  801bd9:	55                   	push   %ebp
  801bda:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 23                	push   $0x23
  801be8:	e8 ee fb ff ff       	call   8017db <syscall>
  801bed:	83 c4 18             	add    $0x18,%esp
}
  801bf0:	90                   	nop
  801bf1:	c9                   	leave  
  801bf2:	c3                   	ret    

00801bf3 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
  801bf6:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801bf9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bfc:	8d 50 04             	lea    0x4(%eax),%edx
  801bff:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	52                   	push   %edx
  801c09:	50                   	push   %eax
  801c0a:	6a 24                	push   $0x24
  801c0c:	e8 ca fb ff ff       	call   8017db <syscall>
  801c11:	83 c4 18             	add    $0x18,%esp
	return result;
  801c14:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c17:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c1a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c1d:	89 01                	mov    %eax,(%ecx)
  801c1f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c22:	8b 45 08             	mov    0x8(%ebp),%eax
  801c25:	c9                   	leave  
  801c26:	c2 04 00             	ret    $0x4

00801c29 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	ff 75 10             	pushl  0x10(%ebp)
  801c33:	ff 75 0c             	pushl  0xc(%ebp)
  801c36:	ff 75 08             	pushl  0x8(%ebp)
  801c39:	6a 12                	push   $0x12
  801c3b:	e8 9b fb ff ff       	call   8017db <syscall>
  801c40:	83 c4 18             	add    $0x18,%esp
	return ;
  801c43:	90                   	nop
}
  801c44:	c9                   	leave  
  801c45:	c3                   	ret    

00801c46 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 25                	push   $0x25
  801c55:	e8 81 fb ff ff       	call   8017db <syscall>
  801c5a:	83 c4 18             	add    $0x18,%esp
}
  801c5d:	c9                   	leave  
  801c5e:	c3                   	ret    

00801c5f <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
  801c62:	83 ec 04             	sub    $0x4,%esp
  801c65:	8b 45 08             	mov    0x8(%ebp),%eax
  801c68:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c6b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	50                   	push   %eax
  801c78:	6a 26                	push   $0x26
  801c7a:	e8 5c fb ff ff       	call   8017db <syscall>
  801c7f:	83 c4 18             	add    $0x18,%esp
	return ;
  801c82:	90                   	nop
}
  801c83:	c9                   	leave  
  801c84:	c3                   	ret    

00801c85 <rsttst>:
void rsttst()
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 28                	push   $0x28
  801c94:	e8 42 fb ff ff       	call   8017db <syscall>
  801c99:	83 c4 18             	add    $0x18,%esp
	return ;
  801c9c:	90                   	nop
}
  801c9d:	c9                   	leave  
  801c9e:	c3                   	ret    

00801c9f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
  801ca2:	83 ec 04             	sub    $0x4,%esp
  801ca5:	8b 45 14             	mov    0x14(%ebp),%eax
  801ca8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cab:	8b 55 18             	mov    0x18(%ebp),%edx
  801cae:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cb2:	52                   	push   %edx
  801cb3:	50                   	push   %eax
  801cb4:	ff 75 10             	pushl  0x10(%ebp)
  801cb7:	ff 75 0c             	pushl  0xc(%ebp)
  801cba:	ff 75 08             	pushl  0x8(%ebp)
  801cbd:	6a 27                	push   $0x27
  801cbf:	e8 17 fb ff ff       	call   8017db <syscall>
  801cc4:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc7:	90                   	nop
}
  801cc8:	c9                   	leave  
  801cc9:	c3                   	ret    

00801cca <chktst>:
void chktst(uint32 n)
{
  801cca:	55                   	push   %ebp
  801ccb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	ff 75 08             	pushl  0x8(%ebp)
  801cd8:	6a 29                	push   $0x29
  801cda:	e8 fc fa ff ff       	call   8017db <syscall>
  801cdf:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce2:	90                   	nop
}
  801ce3:	c9                   	leave  
  801ce4:	c3                   	ret    

00801ce5 <inctst>:

void inctst()
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 2a                	push   $0x2a
  801cf4:	e8 e2 fa ff ff       	call   8017db <syscall>
  801cf9:	83 c4 18             	add    $0x18,%esp
	return ;
  801cfc:	90                   	nop
}
  801cfd:	c9                   	leave  
  801cfe:	c3                   	ret    

00801cff <gettst>:
uint32 gettst()
{
  801cff:	55                   	push   %ebp
  801d00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 2b                	push   $0x2b
  801d0e:	e8 c8 fa ff ff       	call   8017db <syscall>
  801d13:	83 c4 18             	add    $0x18,%esp
}
  801d16:	c9                   	leave  
  801d17:	c3                   	ret    

00801d18 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d18:	55                   	push   %ebp
  801d19:	89 e5                	mov    %esp,%ebp
  801d1b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 2c                	push   $0x2c
  801d2a:	e8 ac fa ff ff       	call   8017db <syscall>
  801d2f:	83 c4 18             	add    $0x18,%esp
  801d32:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d35:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d39:	75 07                	jne    801d42 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d3b:	b8 01 00 00 00       	mov    $0x1,%eax
  801d40:	eb 05                	jmp    801d47 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d47:	c9                   	leave  
  801d48:	c3                   	ret    

00801d49 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d49:	55                   	push   %ebp
  801d4a:	89 e5                	mov    %esp,%ebp
  801d4c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 2c                	push   $0x2c
  801d5b:	e8 7b fa ff ff       	call   8017db <syscall>
  801d60:	83 c4 18             	add    $0x18,%esp
  801d63:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d66:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d6a:	75 07                	jne    801d73 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d6c:	b8 01 00 00 00       	mov    $0x1,%eax
  801d71:	eb 05                	jmp    801d78 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d78:	c9                   	leave  
  801d79:	c3                   	ret    

00801d7a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
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
  801d8c:	e8 4a fa ff ff       	call   8017db <syscall>
  801d91:	83 c4 18             	add    $0x18,%esp
  801d94:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d97:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d9b:	75 07                	jne    801da4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d9d:	b8 01 00 00 00       	mov    $0x1,%eax
  801da2:	eb 05                	jmp    801da9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801da4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da9:	c9                   	leave  
  801daa:	c3                   	ret    

00801dab <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
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
  801dbd:	e8 19 fa ff ff       	call   8017db <syscall>
  801dc2:	83 c4 18             	add    $0x18,%esp
  801dc5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801dc8:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801dcc:	75 07                	jne    801dd5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801dce:	b8 01 00 00 00       	mov    $0x1,%eax
  801dd3:	eb 05                	jmp    801dda <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801dd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dda:	c9                   	leave  
  801ddb:	c3                   	ret    

00801ddc <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ddc:	55                   	push   %ebp
  801ddd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	ff 75 08             	pushl  0x8(%ebp)
  801dea:	6a 2d                	push   $0x2d
  801dec:	e8 ea f9 ff ff       	call   8017db <syscall>
  801df1:	83 c4 18             	add    $0x18,%esp
	return ;
  801df4:	90                   	nop
}
  801df5:	c9                   	leave  
  801df6:	c3                   	ret    

00801df7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801df7:	55                   	push   %ebp
  801df8:	89 e5                	mov    %esp,%ebp
  801dfa:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801dfb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801dfe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e01:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e04:	8b 45 08             	mov    0x8(%ebp),%eax
  801e07:	6a 00                	push   $0x0
  801e09:	53                   	push   %ebx
  801e0a:	51                   	push   %ecx
  801e0b:	52                   	push   %edx
  801e0c:	50                   	push   %eax
  801e0d:	6a 2e                	push   $0x2e
  801e0f:	e8 c7 f9 ff ff       	call   8017db <syscall>
  801e14:	83 c4 18             	add    $0x18,%esp
}
  801e17:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e1a:	c9                   	leave  
  801e1b:	c3                   	ret    

00801e1c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e1c:	55                   	push   %ebp
  801e1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e22:	8b 45 08             	mov    0x8(%ebp),%eax
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	52                   	push   %edx
  801e2c:	50                   	push   %eax
  801e2d:	6a 2f                	push   $0x2f
  801e2f:	e8 a7 f9 ff ff       	call   8017db <syscall>
  801e34:	83 c4 18             	add    $0x18,%esp
}
  801e37:	c9                   	leave  
  801e38:	c3                   	ret    

00801e39 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e39:	55                   	push   %ebp
  801e3a:	89 e5                	mov    %esp,%ebp
  801e3c:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e3f:	83 ec 0c             	sub    $0xc,%esp
  801e42:	68 60 39 80 00       	push   $0x803960
  801e47:	e8 c3 e6 ff ff       	call   80050f <cprintf>
  801e4c:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e4f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e56:	83 ec 0c             	sub    $0xc,%esp
  801e59:	68 8c 39 80 00       	push   $0x80398c
  801e5e:	e8 ac e6 ff ff       	call   80050f <cprintf>
  801e63:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e66:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e6a:	a1 38 41 80 00       	mov    0x804138,%eax
  801e6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e72:	eb 56                	jmp    801eca <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e74:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e78:	74 1c                	je     801e96 <print_mem_block_lists+0x5d>
  801e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e7d:	8b 50 08             	mov    0x8(%eax),%edx
  801e80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e83:	8b 48 08             	mov    0x8(%eax),%ecx
  801e86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e89:	8b 40 0c             	mov    0xc(%eax),%eax
  801e8c:	01 c8                	add    %ecx,%eax
  801e8e:	39 c2                	cmp    %eax,%edx
  801e90:	73 04                	jae    801e96 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e92:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e99:	8b 50 08             	mov    0x8(%eax),%edx
  801e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9f:	8b 40 0c             	mov    0xc(%eax),%eax
  801ea2:	01 c2                	add    %eax,%edx
  801ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea7:	8b 40 08             	mov    0x8(%eax),%eax
  801eaa:	83 ec 04             	sub    $0x4,%esp
  801ead:	52                   	push   %edx
  801eae:	50                   	push   %eax
  801eaf:	68 a1 39 80 00       	push   $0x8039a1
  801eb4:	e8 56 e6 ff ff       	call   80050f <cprintf>
  801eb9:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ec2:	a1 40 41 80 00       	mov    0x804140,%eax
  801ec7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ece:	74 07                	je     801ed7 <print_mem_block_lists+0x9e>
  801ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed3:	8b 00                	mov    (%eax),%eax
  801ed5:	eb 05                	jmp    801edc <print_mem_block_lists+0xa3>
  801ed7:	b8 00 00 00 00       	mov    $0x0,%eax
  801edc:	a3 40 41 80 00       	mov    %eax,0x804140
  801ee1:	a1 40 41 80 00       	mov    0x804140,%eax
  801ee6:	85 c0                	test   %eax,%eax
  801ee8:	75 8a                	jne    801e74 <print_mem_block_lists+0x3b>
  801eea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eee:	75 84                	jne    801e74 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801ef0:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ef4:	75 10                	jne    801f06 <print_mem_block_lists+0xcd>
  801ef6:	83 ec 0c             	sub    $0xc,%esp
  801ef9:	68 b0 39 80 00       	push   $0x8039b0
  801efe:	e8 0c e6 ff ff       	call   80050f <cprintf>
  801f03:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f06:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f0d:	83 ec 0c             	sub    $0xc,%esp
  801f10:	68 d4 39 80 00       	push   $0x8039d4
  801f15:	e8 f5 e5 ff ff       	call   80050f <cprintf>
  801f1a:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f1d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f21:	a1 40 40 80 00       	mov    0x804040,%eax
  801f26:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f29:	eb 56                	jmp    801f81 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f2b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f2f:	74 1c                	je     801f4d <print_mem_block_lists+0x114>
  801f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f34:	8b 50 08             	mov    0x8(%eax),%edx
  801f37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f3a:	8b 48 08             	mov    0x8(%eax),%ecx
  801f3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f40:	8b 40 0c             	mov    0xc(%eax),%eax
  801f43:	01 c8                	add    %ecx,%eax
  801f45:	39 c2                	cmp    %eax,%edx
  801f47:	73 04                	jae    801f4d <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f49:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f50:	8b 50 08             	mov    0x8(%eax),%edx
  801f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f56:	8b 40 0c             	mov    0xc(%eax),%eax
  801f59:	01 c2                	add    %eax,%edx
  801f5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5e:	8b 40 08             	mov    0x8(%eax),%eax
  801f61:	83 ec 04             	sub    $0x4,%esp
  801f64:	52                   	push   %edx
  801f65:	50                   	push   %eax
  801f66:	68 a1 39 80 00       	push   $0x8039a1
  801f6b:	e8 9f e5 ff ff       	call   80050f <cprintf>
  801f70:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f76:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f79:	a1 48 40 80 00       	mov    0x804048,%eax
  801f7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f85:	74 07                	je     801f8e <print_mem_block_lists+0x155>
  801f87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8a:	8b 00                	mov    (%eax),%eax
  801f8c:	eb 05                	jmp    801f93 <print_mem_block_lists+0x15a>
  801f8e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f93:	a3 48 40 80 00       	mov    %eax,0x804048
  801f98:	a1 48 40 80 00       	mov    0x804048,%eax
  801f9d:	85 c0                	test   %eax,%eax
  801f9f:	75 8a                	jne    801f2b <print_mem_block_lists+0xf2>
  801fa1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fa5:	75 84                	jne    801f2b <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fa7:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fab:	75 10                	jne    801fbd <print_mem_block_lists+0x184>
  801fad:	83 ec 0c             	sub    $0xc,%esp
  801fb0:	68 ec 39 80 00       	push   $0x8039ec
  801fb5:	e8 55 e5 ff ff       	call   80050f <cprintf>
  801fba:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801fbd:	83 ec 0c             	sub    $0xc,%esp
  801fc0:	68 60 39 80 00       	push   $0x803960
  801fc5:	e8 45 e5 ff ff       	call   80050f <cprintf>
  801fca:	83 c4 10             	add    $0x10,%esp

}
  801fcd:	90                   	nop
  801fce:	c9                   	leave  
  801fcf:	c3                   	ret    

00801fd0 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801fd0:	55                   	push   %ebp
  801fd1:	89 e5                	mov    %esp,%ebp
  801fd3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  801fd6:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801fdd:	00 00 00 
  801fe0:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801fe7:	00 00 00 
  801fea:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801ff1:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  801ff4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801ffb:	e9 9e 00 00 00       	jmp    80209e <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802000:	a1 50 40 80 00       	mov    0x804050,%eax
  802005:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802008:	c1 e2 04             	shl    $0x4,%edx
  80200b:	01 d0                	add    %edx,%eax
  80200d:	85 c0                	test   %eax,%eax
  80200f:	75 14                	jne    802025 <initialize_MemBlocksList+0x55>
  802011:	83 ec 04             	sub    $0x4,%esp
  802014:	68 14 3a 80 00       	push   $0x803a14
  802019:	6a 47                	push   $0x47
  80201b:	68 37 3a 80 00       	push   $0x803a37
  802020:	e8 36 e2 ff ff       	call   80025b <_panic>
  802025:	a1 50 40 80 00       	mov    0x804050,%eax
  80202a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80202d:	c1 e2 04             	shl    $0x4,%edx
  802030:	01 d0                	add    %edx,%eax
  802032:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802038:	89 10                	mov    %edx,(%eax)
  80203a:	8b 00                	mov    (%eax),%eax
  80203c:	85 c0                	test   %eax,%eax
  80203e:	74 18                	je     802058 <initialize_MemBlocksList+0x88>
  802040:	a1 48 41 80 00       	mov    0x804148,%eax
  802045:	8b 15 50 40 80 00    	mov    0x804050,%edx
  80204b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80204e:	c1 e1 04             	shl    $0x4,%ecx
  802051:	01 ca                	add    %ecx,%edx
  802053:	89 50 04             	mov    %edx,0x4(%eax)
  802056:	eb 12                	jmp    80206a <initialize_MemBlocksList+0x9a>
  802058:	a1 50 40 80 00       	mov    0x804050,%eax
  80205d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802060:	c1 e2 04             	shl    $0x4,%edx
  802063:	01 d0                	add    %edx,%eax
  802065:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80206a:	a1 50 40 80 00       	mov    0x804050,%eax
  80206f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802072:	c1 e2 04             	shl    $0x4,%edx
  802075:	01 d0                	add    %edx,%eax
  802077:	a3 48 41 80 00       	mov    %eax,0x804148
  80207c:	a1 50 40 80 00       	mov    0x804050,%eax
  802081:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802084:	c1 e2 04             	shl    $0x4,%edx
  802087:	01 d0                	add    %edx,%eax
  802089:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802090:	a1 54 41 80 00       	mov    0x804154,%eax
  802095:	40                   	inc    %eax
  802096:	a3 54 41 80 00       	mov    %eax,0x804154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  80209b:	ff 45 f4             	incl   -0xc(%ebp)
  80209e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020a4:	0f 82 56 ff ff ff    	jb     802000 <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  8020aa:	90                   	nop
  8020ab:	c9                   	leave  
  8020ac:	c3                   	ret    

008020ad <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020ad:	55                   	push   %ebp
  8020ae:	89 e5                	mov    %esp,%ebp
  8020b0:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  8020b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b6:	8b 00                	mov    (%eax),%eax
  8020b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020bb:	eb 19                	jmp    8020d6 <find_block+0x29>
	{
		if(element->sva == va){
  8020bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020c0:	8b 40 08             	mov    0x8(%eax),%eax
  8020c3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8020c6:	75 05                	jne    8020cd <find_block+0x20>
			 		return element;
  8020c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020cb:	eb 36                	jmp    802103 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  8020cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d0:	8b 40 08             	mov    0x8(%eax),%eax
  8020d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020da:	74 07                	je     8020e3 <find_block+0x36>
  8020dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020df:	8b 00                	mov    (%eax),%eax
  8020e1:	eb 05                	jmp    8020e8 <find_block+0x3b>
  8020e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8020eb:	89 42 08             	mov    %eax,0x8(%edx)
  8020ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f1:	8b 40 08             	mov    0x8(%eax),%eax
  8020f4:	85 c0                	test   %eax,%eax
  8020f6:	75 c5                	jne    8020bd <find_block+0x10>
  8020f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020fc:	75 bf                	jne    8020bd <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  8020fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802103:	c9                   	leave  
  802104:	c3                   	ret    

00802105 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802105:	55                   	push   %ebp
  802106:	89 e5                	mov    %esp,%ebp
  802108:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  80210b:	a1 44 40 80 00       	mov    0x804044,%eax
  802110:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  802113:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802118:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  80211b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80211f:	74 0a                	je     80212b <insert_sorted_allocList+0x26>
  802121:	8b 45 08             	mov    0x8(%ebp),%eax
  802124:	8b 40 08             	mov    0x8(%eax),%eax
  802127:	85 c0                	test   %eax,%eax
  802129:	75 65                	jne    802190 <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80212b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80212f:	75 14                	jne    802145 <insert_sorted_allocList+0x40>
  802131:	83 ec 04             	sub    $0x4,%esp
  802134:	68 14 3a 80 00       	push   $0x803a14
  802139:	6a 6e                	push   $0x6e
  80213b:	68 37 3a 80 00       	push   $0x803a37
  802140:	e8 16 e1 ff ff       	call   80025b <_panic>
  802145:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80214b:	8b 45 08             	mov    0x8(%ebp),%eax
  80214e:	89 10                	mov    %edx,(%eax)
  802150:	8b 45 08             	mov    0x8(%ebp),%eax
  802153:	8b 00                	mov    (%eax),%eax
  802155:	85 c0                	test   %eax,%eax
  802157:	74 0d                	je     802166 <insert_sorted_allocList+0x61>
  802159:	a1 40 40 80 00       	mov    0x804040,%eax
  80215e:	8b 55 08             	mov    0x8(%ebp),%edx
  802161:	89 50 04             	mov    %edx,0x4(%eax)
  802164:	eb 08                	jmp    80216e <insert_sorted_allocList+0x69>
  802166:	8b 45 08             	mov    0x8(%ebp),%eax
  802169:	a3 44 40 80 00       	mov    %eax,0x804044
  80216e:	8b 45 08             	mov    0x8(%ebp),%eax
  802171:	a3 40 40 80 00       	mov    %eax,0x804040
  802176:	8b 45 08             	mov    0x8(%ebp),%eax
  802179:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802180:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802185:	40                   	inc    %eax
  802186:	a3 4c 40 80 00       	mov    %eax,0x80404c
  80218b:	e9 cf 01 00 00       	jmp    80235f <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  802190:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802193:	8b 50 08             	mov    0x8(%eax),%edx
  802196:	8b 45 08             	mov    0x8(%ebp),%eax
  802199:	8b 40 08             	mov    0x8(%eax),%eax
  80219c:	39 c2                	cmp    %eax,%edx
  80219e:	73 65                	jae    802205 <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8021a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021a4:	75 14                	jne    8021ba <insert_sorted_allocList+0xb5>
  8021a6:	83 ec 04             	sub    $0x4,%esp
  8021a9:	68 50 3a 80 00       	push   $0x803a50
  8021ae:	6a 72                	push   $0x72
  8021b0:	68 37 3a 80 00       	push   $0x803a37
  8021b5:	e8 a1 e0 ff ff       	call   80025b <_panic>
  8021ba:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8021c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c3:	89 50 04             	mov    %edx,0x4(%eax)
  8021c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c9:	8b 40 04             	mov    0x4(%eax),%eax
  8021cc:	85 c0                	test   %eax,%eax
  8021ce:	74 0c                	je     8021dc <insert_sorted_allocList+0xd7>
  8021d0:	a1 44 40 80 00       	mov    0x804044,%eax
  8021d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8021d8:	89 10                	mov    %edx,(%eax)
  8021da:	eb 08                	jmp    8021e4 <insert_sorted_allocList+0xdf>
  8021dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021df:	a3 40 40 80 00       	mov    %eax,0x804040
  8021e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e7:	a3 44 40 80 00       	mov    %eax,0x804044
  8021ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021f5:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021fa:	40                   	inc    %eax
  8021fb:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  802200:	e9 5a 01 00 00       	jmp    80235f <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  802205:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802208:	8b 50 08             	mov    0x8(%eax),%edx
  80220b:	8b 45 08             	mov    0x8(%ebp),%eax
  80220e:	8b 40 08             	mov    0x8(%eax),%eax
  802211:	39 c2                	cmp    %eax,%edx
  802213:	75 70                	jne    802285 <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  802215:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802219:	74 06                	je     802221 <insert_sorted_allocList+0x11c>
  80221b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80221f:	75 14                	jne    802235 <insert_sorted_allocList+0x130>
  802221:	83 ec 04             	sub    $0x4,%esp
  802224:	68 74 3a 80 00       	push   $0x803a74
  802229:	6a 75                	push   $0x75
  80222b:	68 37 3a 80 00       	push   $0x803a37
  802230:	e8 26 e0 ff ff       	call   80025b <_panic>
  802235:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802238:	8b 10                	mov    (%eax),%edx
  80223a:	8b 45 08             	mov    0x8(%ebp),%eax
  80223d:	89 10                	mov    %edx,(%eax)
  80223f:	8b 45 08             	mov    0x8(%ebp),%eax
  802242:	8b 00                	mov    (%eax),%eax
  802244:	85 c0                	test   %eax,%eax
  802246:	74 0b                	je     802253 <insert_sorted_allocList+0x14e>
  802248:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80224b:	8b 00                	mov    (%eax),%eax
  80224d:	8b 55 08             	mov    0x8(%ebp),%edx
  802250:	89 50 04             	mov    %edx,0x4(%eax)
  802253:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802256:	8b 55 08             	mov    0x8(%ebp),%edx
  802259:	89 10                	mov    %edx,(%eax)
  80225b:	8b 45 08             	mov    0x8(%ebp),%eax
  80225e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802261:	89 50 04             	mov    %edx,0x4(%eax)
  802264:	8b 45 08             	mov    0x8(%ebp),%eax
  802267:	8b 00                	mov    (%eax),%eax
  802269:	85 c0                	test   %eax,%eax
  80226b:	75 08                	jne    802275 <insert_sorted_allocList+0x170>
  80226d:	8b 45 08             	mov    0x8(%ebp),%eax
  802270:	a3 44 40 80 00       	mov    %eax,0x804044
  802275:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80227a:	40                   	inc    %eax
  80227b:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  802280:	e9 da 00 00 00       	jmp    80235f <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802285:	a1 40 40 80 00       	mov    0x804040,%eax
  80228a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80228d:	e9 9d 00 00 00       	jmp    80232f <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  802292:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802295:	8b 00                	mov    (%eax),%eax
  802297:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  80229a:	8b 45 08             	mov    0x8(%ebp),%eax
  80229d:	8b 50 08             	mov    0x8(%eax),%edx
  8022a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a3:	8b 40 08             	mov    0x8(%eax),%eax
  8022a6:	39 c2                	cmp    %eax,%edx
  8022a8:	76 7d                	jbe    802327 <insert_sorted_allocList+0x222>
  8022aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ad:	8b 50 08             	mov    0x8(%eax),%edx
  8022b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022b3:	8b 40 08             	mov    0x8(%eax),%eax
  8022b6:	39 c2                	cmp    %eax,%edx
  8022b8:	73 6d                	jae    802327 <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  8022ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022be:	74 06                	je     8022c6 <insert_sorted_allocList+0x1c1>
  8022c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022c4:	75 14                	jne    8022da <insert_sorted_allocList+0x1d5>
  8022c6:	83 ec 04             	sub    $0x4,%esp
  8022c9:	68 74 3a 80 00       	push   $0x803a74
  8022ce:	6a 7c                	push   $0x7c
  8022d0:	68 37 3a 80 00       	push   $0x803a37
  8022d5:	e8 81 df ff ff       	call   80025b <_panic>
  8022da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022dd:	8b 10                	mov    (%eax),%edx
  8022df:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e2:	89 10                	mov    %edx,(%eax)
  8022e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e7:	8b 00                	mov    (%eax),%eax
  8022e9:	85 c0                	test   %eax,%eax
  8022eb:	74 0b                	je     8022f8 <insert_sorted_allocList+0x1f3>
  8022ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f0:	8b 00                	mov    (%eax),%eax
  8022f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8022f5:	89 50 04             	mov    %edx,0x4(%eax)
  8022f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8022fe:	89 10                	mov    %edx,(%eax)
  802300:	8b 45 08             	mov    0x8(%ebp),%eax
  802303:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802306:	89 50 04             	mov    %edx,0x4(%eax)
  802309:	8b 45 08             	mov    0x8(%ebp),%eax
  80230c:	8b 00                	mov    (%eax),%eax
  80230e:	85 c0                	test   %eax,%eax
  802310:	75 08                	jne    80231a <insert_sorted_allocList+0x215>
  802312:	8b 45 08             	mov    0x8(%ebp),%eax
  802315:	a3 44 40 80 00       	mov    %eax,0x804044
  80231a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80231f:	40                   	inc    %eax
  802320:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802325:	eb 38                	jmp    80235f <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802327:	a1 48 40 80 00       	mov    0x804048,%eax
  80232c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80232f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802333:	74 07                	je     80233c <insert_sorted_allocList+0x237>
  802335:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802338:	8b 00                	mov    (%eax),%eax
  80233a:	eb 05                	jmp    802341 <insert_sorted_allocList+0x23c>
  80233c:	b8 00 00 00 00       	mov    $0x0,%eax
  802341:	a3 48 40 80 00       	mov    %eax,0x804048
  802346:	a1 48 40 80 00       	mov    0x804048,%eax
  80234b:	85 c0                	test   %eax,%eax
  80234d:	0f 85 3f ff ff ff    	jne    802292 <insert_sorted_allocList+0x18d>
  802353:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802357:	0f 85 35 ff ff ff    	jne    802292 <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  80235d:	eb 00                	jmp    80235f <insert_sorted_allocList+0x25a>
  80235f:	90                   	nop
  802360:	c9                   	leave  
  802361:	c3                   	ret    

00802362 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802362:	55                   	push   %ebp
  802363:	89 e5                	mov    %esp,%ebp
  802365:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802368:	a1 38 41 80 00       	mov    0x804138,%eax
  80236d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802370:	e9 6b 02 00 00       	jmp    8025e0 <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  802375:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802378:	8b 40 0c             	mov    0xc(%eax),%eax
  80237b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80237e:	0f 85 90 00 00 00    	jne    802414 <alloc_block_FF+0xb2>
			  temp=element;
  802384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802387:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  80238a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80238e:	75 17                	jne    8023a7 <alloc_block_FF+0x45>
  802390:	83 ec 04             	sub    $0x4,%esp
  802393:	68 a8 3a 80 00       	push   $0x803aa8
  802398:	68 92 00 00 00       	push   $0x92
  80239d:	68 37 3a 80 00       	push   $0x803a37
  8023a2:	e8 b4 de ff ff       	call   80025b <_panic>
  8023a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023aa:	8b 00                	mov    (%eax),%eax
  8023ac:	85 c0                	test   %eax,%eax
  8023ae:	74 10                	je     8023c0 <alloc_block_FF+0x5e>
  8023b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b3:	8b 00                	mov    (%eax),%eax
  8023b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023b8:	8b 52 04             	mov    0x4(%edx),%edx
  8023bb:	89 50 04             	mov    %edx,0x4(%eax)
  8023be:	eb 0b                	jmp    8023cb <alloc_block_FF+0x69>
  8023c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c3:	8b 40 04             	mov    0x4(%eax),%eax
  8023c6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8023cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ce:	8b 40 04             	mov    0x4(%eax),%eax
  8023d1:	85 c0                	test   %eax,%eax
  8023d3:	74 0f                	je     8023e4 <alloc_block_FF+0x82>
  8023d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d8:	8b 40 04             	mov    0x4(%eax),%eax
  8023db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023de:	8b 12                	mov    (%edx),%edx
  8023e0:	89 10                	mov    %edx,(%eax)
  8023e2:	eb 0a                	jmp    8023ee <alloc_block_FF+0x8c>
  8023e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e7:	8b 00                	mov    (%eax),%eax
  8023e9:	a3 38 41 80 00       	mov    %eax,0x804138
  8023ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802401:	a1 44 41 80 00       	mov    0x804144,%eax
  802406:	48                   	dec    %eax
  802407:	a3 44 41 80 00       	mov    %eax,0x804144
			  return temp;
  80240c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80240f:	e9 ff 01 00 00       	jmp    802613 <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  802414:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802417:	8b 40 0c             	mov    0xc(%eax),%eax
  80241a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80241d:	0f 86 b5 01 00 00    	jbe    8025d8 <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  802423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802426:	8b 40 0c             	mov    0xc(%eax),%eax
  802429:	2b 45 08             	sub    0x8(%ebp),%eax
  80242c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  80242f:	a1 48 41 80 00       	mov    0x804148,%eax
  802434:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  802437:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80243b:	75 17                	jne    802454 <alloc_block_FF+0xf2>
  80243d:	83 ec 04             	sub    $0x4,%esp
  802440:	68 a8 3a 80 00       	push   $0x803aa8
  802445:	68 99 00 00 00       	push   $0x99
  80244a:	68 37 3a 80 00       	push   $0x803a37
  80244f:	e8 07 de ff ff       	call   80025b <_panic>
  802454:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802457:	8b 00                	mov    (%eax),%eax
  802459:	85 c0                	test   %eax,%eax
  80245b:	74 10                	je     80246d <alloc_block_FF+0x10b>
  80245d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802460:	8b 00                	mov    (%eax),%eax
  802462:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802465:	8b 52 04             	mov    0x4(%edx),%edx
  802468:	89 50 04             	mov    %edx,0x4(%eax)
  80246b:	eb 0b                	jmp    802478 <alloc_block_FF+0x116>
  80246d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802470:	8b 40 04             	mov    0x4(%eax),%eax
  802473:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802478:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80247b:	8b 40 04             	mov    0x4(%eax),%eax
  80247e:	85 c0                	test   %eax,%eax
  802480:	74 0f                	je     802491 <alloc_block_FF+0x12f>
  802482:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802485:	8b 40 04             	mov    0x4(%eax),%eax
  802488:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80248b:	8b 12                	mov    (%edx),%edx
  80248d:	89 10                	mov    %edx,(%eax)
  80248f:	eb 0a                	jmp    80249b <alloc_block_FF+0x139>
  802491:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802494:	8b 00                	mov    (%eax),%eax
  802496:	a3 48 41 80 00       	mov    %eax,0x804148
  80249b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80249e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024ae:	a1 54 41 80 00       	mov    0x804154,%eax
  8024b3:	48                   	dec    %eax
  8024b4:	a3 54 41 80 00       	mov    %eax,0x804154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  8024b9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8024bd:	75 17                	jne    8024d6 <alloc_block_FF+0x174>
  8024bf:	83 ec 04             	sub    $0x4,%esp
  8024c2:	68 50 3a 80 00       	push   $0x803a50
  8024c7:	68 9a 00 00 00       	push   $0x9a
  8024cc:	68 37 3a 80 00       	push   $0x803a37
  8024d1:	e8 85 dd ff ff       	call   80025b <_panic>
  8024d6:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8024dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024df:	89 50 04             	mov    %edx,0x4(%eax)
  8024e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024e5:	8b 40 04             	mov    0x4(%eax),%eax
  8024e8:	85 c0                	test   %eax,%eax
  8024ea:	74 0c                	je     8024f8 <alloc_block_FF+0x196>
  8024ec:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8024f1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024f4:	89 10                	mov    %edx,(%eax)
  8024f6:	eb 08                	jmp    802500 <alloc_block_FF+0x19e>
  8024f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024fb:	a3 38 41 80 00       	mov    %eax,0x804138
  802500:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802503:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802508:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80250b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802511:	a1 44 41 80 00       	mov    0x804144,%eax
  802516:	40                   	inc    %eax
  802517:	a3 44 41 80 00       	mov    %eax,0x804144
		  // setting the size & sva
		  new_block->size=size;
  80251c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80251f:	8b 55 08             	mov    0x8(%ebp),%edx
  802522:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  802525:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802528:	8b 50 08             	mov    0x8(%eax),%edx
  80252b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80252e:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  802531:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802534:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802537:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  80253a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253d:	8b 50 08             	mov    0x8(%eax),%edx
  802540:	8b 45 08             	mov    0x8(%ebp),%eax
  802543:	01 c2                	add    %eax,%edx
  802545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802548:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  80254b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80254e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  802551:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802555:	75 17                	jne    80256e <alloc_block_FF+0x20c>
  802557:	83 ec 04             	sub    $0x4,%esp
  80255a:	68 a8 3a 80 00       	push   $0x803aa8
  80255f:	68 a2 00 00 00       	push   $0xa2
  802564:	68 37 3a 80 00       	push   $0x803a37
  802569:	e8 ed dc ff ff       	call   80025b <_panic>
  80256e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802571:	8b 00                	mov    (%eax),%eax
  802573:	85 c0                	test   %eax,%eax
  802575:	74 10                	je     802587 <alloc_block_FF+0x225>
  802577:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80257a:	8b 00                	mov    (%eax),%eax
  80257c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80257f:	8b 52 04             	mov    0x4(%edx),%edx
  802582:	89 50 04             	mov    %edx,0x4(%eax)
  802585:	eb 0b                	jmp    802592 <alloc_block_FF+0x230>
  802587:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80258a:	8b 40 04             	mov    0x4(%eax),%eax
  80258d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802592:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802595:	8b 40 04             	mov    0x4(%eax),%eax
  802598:	85 c0                	test   %eax,%eax
  80259a:	74 0f                	je     8025ab <alloc_block_FF+0x249>
  80259c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80259f:	8b 40 04             	mov    0x4(%eax),%eax
  8025a2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025a5:	8b 12                	mov    (%edx),%edx
  8025a7:	89 10                	mov    %edx,(%eax)
  8025a9:	eb 0a                	jmp    8025b5 <alloc_block_FF+0x253>
  8025ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ae:	8b 00                	mov    (%eax),%eax
  8025b0:	a3 38 41 80 00       	mov    %eax,0x804138
  8025b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025c8:	a1 44 41 80 00       	mov    0x804144,%eax
  8025cd:	48                   	dec    %eax
  8025ce:	a3 44 41 80 00       	mov    %eax,0x804144
		  return temp;
  8025d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025d6:	eb 3b                	jmp    802613 <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  8025d8:	a1 40 41 80 00       	mov    0x804140,%eax
  8025dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025e4:	74 07                	je     8025ed <alloc_block_FF+0x28b>
  8025e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e9:	8b 00                	mov    (%eax),%eax
  8025eb:	eb 05                	jmp    8025f2 <alloc_block_FF+0x290>
  8025ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f2:	a3 40 41 80 00       	mov    %eax,0x804140
  8025f7:	a1 40 41 80 00       	mov    0x804140,%eax
  8025fc:	85 c0                	test   %eax,%eax
  8025fe:	0f 85 71 fd ff ff    	jne    802375 <alloc_block_FF+0x13>
  802604:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802608:	0f 85 67 fd ff ff    	jne    802375 <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  80260e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802613:	c9                   	leave  
  802614:	c3                   	ret    

00802615 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802615:	55                   	push   %ebp
  802616:	89 e5                	mov    %esp,%ebp
  802618:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  80261b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  802622:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802629:	a1 38 41 80 00       	mov    0x804138,%eax
  80262e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802631:	e9 d3 00 00 00       	jmp    802709 <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  802636:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802639:	8b 40 0c             	mov    0xc(%eax),%eax
  80263c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80263f:	0f 85 90 00 00 00    	jne    8026d5 <alloc_block_BF+0xc0>
	   temp = element;
  802645:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802648:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  80264b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80264f:	75 17                	jne    802668 <alloc_block_BF+0x53>
  802651:	83 ec 04             	sub    $0x4,%esp
  802654:	68 a8 3a 80 00       	push   $0x803aa8
  802659:	68 bd 00 00 00       	push   $0xbd
  80265e:	68 37 3a 80 00       	push   $0x803a37
  802663:	e8 f3 db ff ff       	call   80025b <_panic>
  802668:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80266b:	8b 00                	mov    (%eax),%eax
  80266d:	85 c0                	test   %eax,%eax
  80266f:	74 10                	je     802681 <alloc_block_BF+0x6c>
  802671:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802674:	8b 00                	mov    (%eax),%eax
  802676:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802679:	8b 52 04             	mov    0x4(%edx),%edx
  80267c:	89 50 04             	mov    %edx,0x4(%eax)
  80267f:	eb 0b                	jmp    80268c <alloc_block_BF+0x77>
  802681:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802684:	8b 40 04             	mov    0x4(%eax),%eax
  802687:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80268c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80268f:	8b 40 04             	mov    0x4(%eax),%eax
  802692:	85 c0                	test   %eax,%eax
  802694:	74 0f                	je     8026a5 <alloc_block_BF+0x90>
  802696:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802699:	8b 40 04             	mov    0x4(%eax),%eax
  80269c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80269f:	8b 12                	mov    (%edx),%edx
  8026a1:	89 10                	mov    %edx,(%eax)
  8026a3:	eb 0a                	jmp    8026af <alloc_block_BF+0x9a>
  8026a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026a8:	8b 00                	mov    (%eax),%eax
  8026aa:	a3 38 41 80 00       	mov    %eax,0x804138
  8026af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026c2:	a1 44 41 80 00       	mov    0x804144,%eax
  8026c7:	48                   	dec    %eax
  8026c8:	a3 44 41 80 00       	mov    %eax,0x804144
	   return temp;
  8026cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026d0:	e9 41 01 00 00       	jmp    802816 <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  8026d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8026db:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026de:	76 21                	jbe    802701 <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  8026e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8026e6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8026e9:	73 16                	jae    802701 <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  8026eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  8026f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  8026fa:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802701:	a1 40 41 80 00       	mov    0x804140,%eax
  802706:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802709:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80270d:	74 07                	je     802716 <alloc_block_BF+0x101>
  80270f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802712:	8b 00                	mov    (%eax),%eax
  802714:	eb 05                	jmp    80271b <alloc_block_BF+0x106>
  802716:	b8 00 00 00 00       	mov    $0x0,%eax
  80271b:	a3 40 41 80 00       	mov    %eax,0x804140
  802720:	a1 40 41 80 00       	mov    0x804140,%eax
  802725:	85 c0                	test   %eax,%eax
  802727:	0f 85 09 ff ff ff    	jne    802636 <alloc_block_BF+0x21>
  80272d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802731:	0f 85 ff fe ff ff    	jne    802636 <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  802737:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  80273b:	0f 85 d0 00 00 00    	jne    802811 <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  802741:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802744:	8b 40 0c             	mov    0xc(%eax),%eax
  802747:	2b 45 08             	sub    0x8(%ebp),%eax
  80274a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  80274d:	a1 48 41 80 00       	mov    0x804148,%eax
  802752:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  802755:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802759:	75 17                	jne    802772 <alloc_block_BF+0x15d>
  80275b:	83 ec 04             	sub    $0x4,%esp
  80275e:	68 a8 3a 80 00       	push   $0x803aa8
  802763:	68 d1 00 00 00       	push   $0xd1
  802768:	68 37 3a 80 00       	push   $0x803a37
  80276d:	e8 e9 da ff ff       	call   80025b <_panic>
  802772:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802775:	8b 00                	mov    (%eax),%eax
  802777:	85 c0                	test   %eax,%eax
  802779:	74 10                	je     80278b <alloc_block_BF+0x176>
  80277b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80277e:	8b 00                	mov    (%eax),%eax
  802780:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802783:	8b 52 04             	mov    0x4(%edx),%edx
  802786:	89 50 04             	mov    %edx,0x4(%eax)
  802789:	eb 0b                	jmp    802796 <alloc_block_BF+0x181>
  80278b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80278e:	8b 40 04             	mov    0x4(%eax),%eax
  802791:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802796:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802799:	8b 40 04             	mov    0x4(%eax),%eax
  80279c:	85 c0                	test   %eax,%eax
  80279e:	74 0f                	je     8027af <alloc_block_BF+0x19a>
  8027a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027a3:	8b 40 04             	mov    0x4(%eax),%eax
  8027a6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027a9:	8b 12                	mov    (%edx),%edx
  8027ab:	89 10                	mov    %edx,(%eax)
  8027ad:	eb 0a                	jmp    8027b9 <alloc_block_BF+0x1a4>
  8027af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027b2:	8b 00                	mov    (%eax),%eax
  8027b4:	a3 48 41 80 00       	mov    %eax,0x804148
  8027b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027cc:	a1 54 41 80 00       	mov    0x804154,%eax
  8027d1:	48                   	dec    %eax
  8027d2:	a3 54 41 80 00       	mov    %eax,0x804154
	  // setting the size & sva
	  new_block->size = size;
  8027d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027da:	8b 55 08             	mov    0x8(%ebp),%edx
  8027dd:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  8027e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e3:	8b 50 08             	mov    0x8(%eax),%edx
  8027e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027e9:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  8027ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027f2:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  8027f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f8:	8b 50 08             	mov    0x8(%eax),%edx
  8027fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fe:	01 c2                	add    %eax,%edx
  802800:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802803:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  802806:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802809:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  80280c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80280f:	eb 05                	jmp    802816 <alloc_block_BF+0x201>
	 }
	 return NULL;
  802811:	b8 00 00 00 00       	mov    $0x0,%eax


}
  802816:	c9                   	leave  
  802817:	c3                   	ret    

00802818 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802818:	55                   	push   %ebp
  802819:	89 e5                	mov    %esp,%ebp
  80281b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  80281e:	83 ec 04             	sub    $0x4,%esp
  802821:	68 c8 3a 80 00       	push   $0x803ac8
  802826:	68 e8 00 00 00       	push   $0xe8
  80282b:	68 37 3a 80 00       	push   $0x803a37
  802830:	e8 26 da ff ff       	call   80025b <_panic>

00802835 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802835:	55                   	push   %ebp
  802836:	89 e5                	mov    %esp,%ebp
  802838:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  80283b:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802840:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  802843:	a1 38 41 80 00       	mov    0x804138,%eax
  802848:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  80284b:	a1 44 41 80 00       	mov    0x804144,%eax
  802850:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  802853:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802857:	75 68                	jne    8028c1 <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802859:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80285d:	75 17                	jne    802876 <insert_sorted_with_merge_freeList+0x41>
  80285f:	83 ec 04             	sub    $0x4,%esp
  802862:	68 14 3a 80 00       	push   $0x803a14
  802867:	68 36 01 00 00       	push   $0x136
  80286c:	68 37 3a 80 00       	push   $0x803a37
  802871:	e8 e5 d9 ff ff       	call   80025b <_panic>
  802876:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80287c:	8b 45 08             	mov    0x8(%ebp),%eax
  80287f:	89 10                	mov    %edx,(%eax)
  802881:	8b 45 08             	mov    0x8(%ebp),%eax
  802884:	8b 00                	mov    (%eax),%eax
  802886:	85 c0                	test   %eax,%eax
  802888:	74 0d                	je     802897 <insert_sorted_with_merge_freeList+0x62>
  80288a:	a1 38 41 80 00       	mov    0x804138,%eax
  80288f:	8b 55 08             	mov    0x8(%ebp),%edx
  802892:	89 50 04             	mov    %edx,0x4(%eax)
  802895:	eb 08                	jmp    80289f <insert_sorted_with_merge_freeList+0x6a>
  802897:	8b 45 08             	mov    0x8(%ebp),%eax
  80289a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80289f:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a2:	a3 38 41 80 00       	mov    %eax,0x804138
  8028a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028aa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028b1:	a1 44 41 80 00       	mov    0x804144,%eax
  8028b6:	40                   	inc    %eax
  8028b7:	a3 44 41 80 00       	mov    %eax,0x804144





}
  8028bc:	e9 ba 06 00 00       	jmp    802f7b <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  8028c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c4:	8b 50 08             	mov    0x8(%eax),%edx
  8028c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8028cd:	01 c2                	add    %eax,%edx
  8028cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d2:	8b 40 08             	mov    0x8(%eax),%eax
  8028d5:	39 c2                	cmp    %eax,%edx
  8028d7:	73 68                	jae    802941 <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8028d9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028dd:	75 17                	jne    8028f6 <insert_sorted_with_merge_freeList+0xc1>
  8028df:	83 ec 04             	sub    $0x4,%esp
  8028e2:	68 50 3a 80 00       	push   $0x803a50
  8028e7:	68 3a 01 00 00       	push   $0x13a
  8028ec:	68 37 3a 80 00       	push   $0x803a37
  8028f1:	e8 65 d9 ff ff       	call   80025b <_panic>
  8028f6:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8028fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ff:	89 50 04             	mov    %edx,0x4(%eax)
  802902:	8b 45 08             	mov    0x8(%ebp),%eax
  802905:	8b 40 04             	mov    0x4(%eax),%eax
  802908:	85 c0                	test   %eax,%eax
  80290a:	74 0c                	je     802918 <insert_sorted_with_merge_freeList+0xe3>
  80290c:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802911:	8b 55 08             	mov    0x8(%ebp),%edx
  802914:	89 10                	mov    %edx,(%eax)
  802916:	eb 08                	jmp    802920 <insert_sorted_with_merge_freeList+0xeb>
  802918:	8b 45 08             	mov    0x8(%ebp),%eax
  80291b:	a3 38 41 80 00       	mov    %eax,0x804138
  802920:	8b 45 08             	mov    0x8(%ebp),%eax
  802923:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802928:	8b 45 08             	mov    0x8(%ebp),%eax
  80292b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802931:	a1 44 41 80 00       	mov    0x804144,%eax
  802936:	40                   	inc    %eax
  802937:	a3 44 41 80 00       	mov    %eax,0x804144





}
  80293c:	e9 3a 06 00 00       	jmp    802f7b <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  802941:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802944:	8b 50 08             	mov    0x8(%eax),%edx
  802947:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80294a:	8b 40 0c             	mov    0xc(%eax),%eax
  80294d:	01 c2                	add    %eax,%edx
  80294f:	8b 45 08             	mov    0x8(%ebp),%eax
  802952:	8b 40 08             	mov    0x8(%eax),%eax
  802955:	39 c2                	cmp    %eax,%edx
  802957:	0f 85 90 00 00 00    	jne    8029ed <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  80295d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802960:	8b 50 0c             	mov    0xc(%eax),%edx
  802963:	8b 45 08             	mov    0x8(%ebp),%eax
  802966:	8b 40 0c             	mov    0xc(%eax),%eax
  802969:	01 c2                	add    %eax,%edx
  80296b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80296e:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  802971:	8b 45 08             	mov    0x8(%ebp),%eax
  802974:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  80297b:	8b 45 08             	mov    0x8(%ebp),%eax
  80297e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802985:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802989:	75 17                	jne    8029a2 <insert_sorted_with_merge_freeList+0x16d>
  80298b:	83 ec 04             	sub    $0x4,%esp
  80298e:	68 14 3a 80 00       	push   $0x803a14
  802993:	68 41 01 00 00       	push   $0x141
  802998:	68 37 3a 80 00       	push   $0x803a37
  80299d:	e8 b9 d8 ff ff       	call   80025b <_panic>
  8029a2:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8029a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ab:	89 10                	mov    %edx,(%eax)
  8029ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b0:	8b 00                	mov    (%eax),%eax
  8029b2:	85 c0                	test   %eax,%eax
  8029b4:	74 0d                	je     8029c3 <insert_sorted_with_merge_freeList+0x18e>
  8029b6:	a1 48 41 80 00       	mov    0x804148,%eax
  8029bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8029be:	89 50 04             	mov    %edx,0x4(%eax)
  8029c1:	eb 08                	jmp    8029cb <insert_sorted_with_merge_freeList+0x196>
  8029c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8029cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ce:	a3 48 41 80 00       	mov    %eax,0x804148
  8029d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029dd:	a1 54 41 80 00       	mov    0x804154,%eax
  8029e2:	40                   	inc    %eax
  8029e3:	a3 54 41 80 00       	mov    %eax,0x804154





}
  8029e8:	e9 8e 05 00 00       	jmp    802f7b <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  8029ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f0:	8b 50 08             	mov    0x8(%eax),%edx
  8029f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f9:	01 c2                	add    %eax,%edx
  8029fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029fe:	8b 40 08             	mov    0x8(%eax),%eax
  802a01:	39 c2                	cmp    %eax,%edx
  802a03:	73 68                	jae    802a6d <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802a05:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a09:	75 17                	jne    802a22 <insert_sorted_with_merge_freeList+0x1ed>
  802a0b:	83 ec 04             	sub    $0x4,%esp
  802a0e:	68 14 3a 80 00       	push   $0x803a14
  802a13:	68 45 01 00 00       	push   $0x145
  802a18:	68 37 3a 80 00       	push   $0x803a37
  802a1d:	e8 39 d8 ff ff       	call   80025b <_panic>
  802a22:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a28:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2b:	89 10                	mov    %edx,(%eax)
  802a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a30:	8b 00                	mov    (%eax),%eax
  802a32:	85 c0                	test   %eax,%eax
  802a34:	74 0d                	je     802a43 <insert_sorted_with_merge_freeList+0x20e>
  802a36:	a1 38 41 80 00       	mov    0x804138,%eax
  802a3b:	8b 55 08             	mov    0x8(%ebp),%edx
  802a3e:	89 50 04             	mov    %edx,0x4(%eax)
  802a41:	eb 08                	jmp    802a4b <insert_sorted_with_merge_freeList+0x216>
  802a43:	8b 45 08             	mov    0x8(%ebp),%eax
  802a46:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4e:	a3 38 41 80 00       	mov    %eax,0x804138
  802a53:	8b 45 08             	mov    0x8(%ebp),%eax
  802a56:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a5d:	a1 44 41 80 00       	mov    0x804144,%eax
  802a62:	40                   	inc    %eax
  802a63:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802a68:	e9 0e 05 00 00       	jmp    802f7b <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  802a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a70:	8b 50 08             	mov    0x8(%eax),%edx
  802a73:	8b 45 08             	mov    0x8(%ebp),%eax
  802a76:	8b 40 0c             	mov    0xc(%eax),%eax
  802a79:	01 c2                	add    %eax,%edx
  802a7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a7e:	8b 40 08             	mov    0x8(%eax),%eax
  802a81:	39 c2                	cmp    %eax,%edx
  802a83:	0f 85 9c 00 00 00    	jne    802b25 <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  802a89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a8c:	8b 50 0c             	mov    0xc(%eax),%edx
  802a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a92:	8b 40 0c             	mov    0xc(%eax),%eax
  802a95:	01 c2                	add    %eax,%edx
  802a97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a9a:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  802a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa0:	8b 50 08             	mov    0x8(%eax),%edx
  802aa3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa6:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  802aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  802aac:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  802ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802abd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ac1:	75 17                	jne    802ada <insert_sorted_with_merge_freeList+0x2a5>
  802ac3:	83 ec 04             	sub    $0x4,%esp
  802ac6:	68 14 3a 80 00       	push   $0x803a14
  802acb:	68 4d 01 00 00       	push   $0x14d
  802ad0:	68 37 3a 80 00       	push   $0x803a37
  802ad5:	e8 81 d7 ff ff       	call   80025b <_panic>
  802ada:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae3:	89 10                	mov    %edx,(%eax)
  802ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae8:	8b 00                	mov    (%eax),%eax
  802aea:	85 c0                	test   %eax,%eax
  802aec:	74 0d                	je     802afb <insert_sorted_with_merge_freeList+0x2c6>
  802aee:	a1 48 41 80 00       	mov    0x804148,%eax
  802af3:	8b 55 08             	mov    0x8(%ebp),%edx
  802af6:	89 50 04             	mov    %edx,0x4(%eax)
  802af9:	eb 08                	jmp    802b03 <insert_sorted_with_merge_freeList+0x2ce>
  802afb:	8b 45 08             	mov    0x8(%ebp),%eax
  802afe:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b03:	8b 45 08             	mov    0x8(%ebp),%eax
  802b06:	a3 48 41 80 00       	mov    %eax,0x804148
  802b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b15:	a1 54 41 80 00       	mov    0x804154,%eax
  802b1a:	40                   	inc    %eax
  802b1b:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802b20:	e9 56 04 00 00       	jmp    802f7b <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802b25:	a1 38 41 80 00       	mov    0x804138,%eax
  802b2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b2d:	e9 19 04 00 00       	jmp    802f4b <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  802b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b35:	8b 00                	mov    (%eax),%eax
  802b37:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3d:	8b 50 08             	mov    0x8(%eax),%edx
  802b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b43:	8b 40 0c             	mov    0xc(%eax),%eax
  802b46:	01 c2                	add    %eax,%edx
  802b48:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4b:	8b 40 08             	mov    0x8(%eax),%eax
  802b4e:	39 c2                	cmp    %eax,%edx
  802b50:	0f 85 ad 01 00 00    	jne    802d03 <insert_sorted_with_merge_freeList+0x4ce>
  802b56:	8b 45 08             	mov    0x8(%ebp),%eax
  802b59:	8b 50 08             	mov    0x8(%eax),%edx
  802b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5f:	8b 40 0c             	mov    0xc(%eax),%eax
  802b62:	01 c2                	add    %eax,%edx
  802b64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b67:	8b 40 08             	mov    0x8(%eax),%eax
  802b6a:	39 c2                	cmp    %eax,%edx
  802b6c:	0f 85 91 01 00 00    	jne    802d03 <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  802b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b75:	8b 50 0c             	mov    0xc(%eax),%edx
  802b78:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7b:	8b 48 0c             	mov    0xc(%eax),%ecx
  802b7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b81:	8b 40 0c             	mov    0xc(%eax),%eax
  802b84:	01 c8                	add    %ecx,%eax
  802b86:	01 c2                	add    %eax,%edx
  802b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8b:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  802b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b91:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802b98:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  802ba2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ba5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  802bac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802baf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  802bb6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802bba:	75 17                	jne    802bd3 <insert_sorted_with_merge_freeList+0x39e>
  802bbc:	83 ec 04             	sub    $0x4,%esp
  802bbf:	68 a8 3a 80 00       	push   $0x803aa8
  802bc4:	68 5b 01 00 00       	push   $0x15b
  802bc9:	68 37 3a 80 00       	push   $0x803a37
  802bce:	e8 88 d6 ff ff       	call   80025b <_panic>
  802bd3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bd6:	8b 00                	mov    (%eax),%eax
  802bd8:	85 c0                	test   %eax,%eax
  802bda:	74 10                	je     802bec <insert_sorted_with_merge_freeList+0x3b7>
  802bdc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bdf:	8b 00                	mov    (%eax),%eax
  802be1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802be4:	8b 52 04             	mov    0x4(%edx),%edx
  802be7:	89 50 04             	mov    %edx,0x4(%eax)
  802bea:	eb 0b                	jmp    802bf7 <insert_sorted_with_merge_freeList+0x3c2>
  802bec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bef:	8b 40 04             	mov    0x4(%eax),%eax
  802bf2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bf7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bfa:	8b 40 04             	mov    0x4(%eax),%eax
  802bfd:	85 c0                	test   %eax,%eax
  802bff:	74 0f                	je     802c10 <insert_sorted_with_merge_freeList+0x3db>
  802c01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c04:	8b 40 04             	mov    0x4(%eax),%eax
  802c07:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c0a:	8b 12                	mov    (%edx),%edx
  802c0c:	89 10                	mov    %edx,(%eax)
  802c0e:	eb 0a                	jmp    802c1a <insert_sorted_with_merge_freeList+0x3e5>
  802c10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c13:	8b 00                	mov    (%eax),%eax
  802c15:	a3 38 41 80 00       	mov    %eax,0x804138
  802c1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c1d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c26:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c2d:	a1 44 41 80 00       	mov    0x804144,%eax
  802c32:	48                   	dec    %eax
  802c33:	a3 44 41 80 00       	mov    %eax,0x804144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802c38:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c3c:	75 17                	jne    802c55 <insert_sorted_with_merge_freeList+0x420>
  802c3e:	83 ec 04             	sub    $0x4,%esp
  802c41:	68 14 3a 80 00       	push   $0x803a14
  802c46:	68 5c 01 00 00       	push   $0x15c
  802c4b:	68 37 3a 80 00       	push   $0x803a37
  802c50:	e8 06 d6 ff ff       	call   80025b <_panic>
  802c55:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5e:	89 10                	mov    %edx,(%eax)
  802c60:	8b 45 08             	mov    0x8(%ebp),%eax
  802c63:	8b 00                	mov    (%eax),%eax
  802c65:	85 c0                	test   %eax,%eax
  802c67:	74 0d                	je     802c76 <insert_sorted_with_merge_freeList+0x441>
  802c69:	a1 48 41 80 00       	mov    0x804148,%eax
  802c6e:	8b 55 08             	mov    0x8(%ebp),%edx
  802c71:	89 50 04             	mov    %edx,0x4(%eax)
  802c74:	eb 08                	jmp    802c7e <insert_sorted_with_merge_freeList+0x449>
  802c76:	8b 45 08             	mov    0x8(%ebp),%eax
  802c79:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c81:	a3 48 41 80 00       	mov    %eax,0x804148
  802c86:	8b 45 08             	mov    0x8(%ebp),%eax
  802c89:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c90:	a1 54 41 80 00       	mov    0x804154,%eax
  802c95:	40                   	inc    %eax
  802c96:	a3 54 41 80 00       	mov    %eax,0x804154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  802c9b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802c9f:	75 17                	jne    802cb8 <insert_sorted_with_merge_freeList+0x483>
  802ca1:	83 ec 04             	sub    $0x4,%esp
  802ca4:	68 14 3a 80 00       	push   $0x803a14
  802ca9:	68 5d 01 00 00       	push   $0x15d
  802cae:	68 37 3a 80 00       	push   $0x803a37
  802cb3:	e8 a3 d5 ff ff       	call   80025b <_panic>
  802cb8:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802cbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cc1:	89 10                	mov    %edx,(%eax)
  802cc3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cc6:	8b 00                	mov    (%eax),%eax
  802cc8:	85 c0                	test   %eax,%eax
  802cca:	74 0d                	je     802cd9 <insert_sorted_with_merge_freeList+0x4a4>
  802ccc:	a1 48 41 80 00       	mov    0x804148,%eax
  802cd1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802cd4:	89 50 04             	mov    %edx,0x4(%eax)
  802cd7:	eb 08                	jmp    802ce1 <insert_sorted_with_merge_freeList+0x4ac>
  802cd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cdc:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ce1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ce4:	a3 48 41 80 00       	mov    %eax,0x804148
  802ce9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cf3:	a1 54 41 80 00       	mov    0x804154,%eax
  802cf8:	40                   	inc    %eax
  802cf9:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802cfe:	e9 78 02 00 00       	jmp    802f7b <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d06:	8b 50 08             	mov    0x8(%eax),%edx
  802d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d0f:	01 c2                	add    %eax,%edx
  802d11:	8b 45 08             	mov    0x8(%ebp),%eax
  802d14:	8b 40 08             	mov    0x8(%eax),%eax
  802d17:	39 c2                	cmp    %eax,%edx
  802d19:	0f 83 b8 00 00 00    	jae    802dd7 <insert_sorted_with_merge_freeList+0x5a2>
  802d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d22:	8b 50 08             	mov    0x8(%eax),%edx
  802d25:	8b 45 08             	mov    0x8(%ebp),%eax
  802d28:	8b 40 0c             	mov    0xc(%eax),%eax
  802d2b:	01 c2                	add    %eax,%edx
  802d2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d30:	8b 40 08             	mov    0x8(%eax),%eax
  802d33:	39 c2                	cmp    %eax,%edx
  802d35:	0f 85 9c 00 00 00    	jne    802dd7 <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  802d3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d3e:	8b 50 0c             	mov    0xc(%eax),%edx
  802d41:	8b 45 08             	mov    0x8(%ebp),%eax
  802d44:	8b 40 0c             	mov    0xc(%eax),%eax
  802d47:	01 c2                	add    %eax,%edx
  802d49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d4c:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  802d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d52:	8b 50 08             	mov    0x8(%eax),%edx
  802d55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d58:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  802d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802d65:	8b 45 08             	mov    0x8(%ebp),%eax
  802d68:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802d6f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d73:	75 17                	jne    802d8c <insert_sorted_with_merge_freeList+0x557>
  802d75:	83 ec 04             	sub    $0x4,%esp
  802d78:	68 14 3a 80 00       	push   $0x803a14
  802d7d:	68 67 01 00 00       	push   $0x167
  802d82:	68 37 3a 80 00       	push   $0x803a37
  802d87:	e8 cf d4 ff ff       	call   80025b <_panic>
  802d8c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d92:	8b 45 08             	mov    0x8(%ebp),%eax
  802d95:	89 10                	mov    %edx,(%eax)
  802d97:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9a:	8b 00                	mov    (%eax),%eax
  802d9c:	85 c0                	test   %eax,%eax
  802d9e:	74 0d                	je     802dad <insert_sorted_with_merge_freeList+0x578>
  802da0:	a1 48 41 80 00       	mov    0x804148,%eax
  802da5:	8b 55 08             	mov    0x8(%ebp),%edx
  802da8:	89 50 04             	mov    %edx,0x4(%eax)
  802dab:	eb 08                	jmp    802db5 <insert_sorted_with_merge_freeList+0x580>
  802dad:	8b 45 08             	mov    0x8(%ebp),%eax
  802db0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802db5:	8b 45 08             	mov    0x8(%ebp),%eax
  802db8:	a3 48 41 80 00       	mov    %eax,0x804148
  802dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dc7:	a1 54 41 80 00       	mov    0x804154,%eax
  802dcc:	40                   	inc    %eax
  802dcd:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802dd2:	e9 a4 01 00 00       	jmp    802f7b <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dda:	8b 50 08             	mov    0x8(%eax),%edx
  802ddd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de0:	8b 40 0c             	mov    0xc(%eax),%eax
  802de3:	01 c2                	add    %eax,%edx
  802de5:	8b 45 08             	mov    0x8(%ebp),%eax
  802de8:	8b 40 08             	mov    0x8(%eax),%eax
  802deb:	39 c2                	cmp    %eax,%edx
  802ded:	0f 85 ac 00 00 00    	jne    802e9f <insert_sorted_with_merge_freeList+0x66a>
  802df3:	8b 45 08             	mov    0x8(%ebp),%eax
  802df6:	8b 50 08             	mov    0x8(%eax),%edx
  802df9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfc:	8b 40 0c             	mov    0xc(%eax),%eax
  802dff:	01 c2                	add    %eax,%edx
  802e01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e04:	8b 40 08             	mov    0x8(%eax),%eax
  802e07:	39 c2                	cmp    %eax,%edx
  802e09:	0f 83 90 00 00 00    	jae    802e9f <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  802e0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e12:	8b 50 0c             	mov    0xc(%eax),%edx
  802e15:	8b 45 08             	mov    0x8(%ebp),%eax
  802e18:	8b 40 0c             	mov    0xc(%eax),%eax
  802e1b:	01 c2                	add    %eax,%edx
  802e1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e20:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  802e23:	8b 45 08             	mov    0x8(%ebp),%eax
  802e26:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  802e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e30:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e37:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e3b:	75 17                	jne    802e54 <insert_sorted_with_merge_freeList+0x61f>
  802e3d:	83 ec 04             	sub    $0x4,%esp
  802e40:	68 14 3a 80 00       	push   $0x803a14
  802e45:	68 70 01 00 00       	push   $0x170
  802e4a:	68 37 3a 80 00       	push   $0x803a37
  802e4f:	e8 07 d4 ff ff       	call   80025b <_panic>
  802e54:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5d:	89 10                	mov    %edx,(%eax)
  802e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e62:	8b 00                	mov    (%eax),%eax
  802e64:	85 c0                	test   %eax,%eax
  802e66:	74 0d                	je     802e75 <insert_sorted_with_merge_freeList+0x640>
  802e68:	a1 48 41 80 00       	mov    0x804148,%eax
  802e6d:	8b 55 08             	mov    0x8(%ebp),%edx
  802e70:	89 50 04             	mov    %edx,0x4(%eax)
  802e73:	eb 08                	jmp    802e7d <insert_sorted_with_merge_freeList+0x648>
  802e75:	8b 45 08             	mov    0x8(%ebp),%eax
  802e78:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e80:	a3 48 41 80 00       	mov    %eax,0x804148
  802e85:	8b 45 08             	mov    0x8(%ebp),%eax
  802e88:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e8f:	a1 54 41 80 00       	mov    0x804154,%eax
  802e94:	40                   	inc    %eax
  802e95:	a3 54 41 80 00       	mov    %eax,0x804154
	      break;
  802e9a:	e9 dc 00 00 00       	jmp    802f7b <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802e9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea2:	8b 50 08             	mov    0x8(%eax),%edx
  802ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea8:	8b 40 0c             	mov    0xc(%eax),%eax
  802eab:	01 c2                	add    %eax,%edx
  802ead:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb0:	8b 40 08             	mov    0x8(%eax),%eax
  802eb3:	39 c2                	cmp    %eax,%edx
  802eb5:	0f 83 88 00 00 00    	jae    802f43 <insert_sorted_with_merge_freeList+0x70e>
  802ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebe:	8b 50 08             	mov    0x8(%eax),%edx
  802ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec7:	01 c2                	add    %eax,%edx
  802ec9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ecc:	8b 40 08             	mov    0x8(%eax),%eax
  802ecf:	39 c2                	cmp    %eax,%edx
  802ed1:	73 70                	jae    802f43 <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  802ed3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ed7:	74 06                	je     802edf <insert_sorted_with_merge_freeList+0x6aa>
  802ed9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802edd:	75 17                	jne    802ef6 <insert_sorted_with_merge_freeList+0x6c1>
  802edf:	83 ec 04             	sub    $0x4,%esp
  802ee2:	68 74 3a 80 00       	push   $0x803a74
  802ee7:	68 75 01 00 00       	push   $0x175
  802eec:	68 37 3a 80 00       	push   $0x803a37
  802ef1:	e8 65 d3 ff ff       	call   80025b <_panic>
  802ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef9:	8b 10                	mov    (%eax),%edx
  802efb:	8b 45 08             	mov    0x8(%ebp),%eax
  802efe:	89 10                	mov    %edx,(%eax)
  802f00:	8b 45 08             	mov    0x8(%ebp),%eax
  802f03:	8b 00                	mov    (%eax),%eax
  802f05:	85 c0                	test   %eax,%eax
  802f07:	74 0b                	je     802f14 <insert_sorted_with_merge_freeList+0x6df>
  802f09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0c:	8b 00                	mov    (%eax),%eax
  802f0e:	8b 55 08             	mov    0x8(%ebp),%edx
  802f11:	89 50 04             	mov    %edx,0x4(%eax)
  802f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f17:	8b 55 08             	mov    0x8(%ebp),%edx
  802f1a:	89 10                	mov    %edx,(%eax)
  802f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f22:	89 50 04             	mov    %edx,0x4(%eax)
  802f25:	8b 45 08             	mov    0x8(%ebp),%eax
  802f28:	8b 00                	mov    (%eax),%eax
  802f2a:	85 c0                	test   %eax,%eax
  802f2c:	75 08                	jne    802f36 <insert_sorted_with_merge_freeList+0x701>
  802f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f31:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f36:	a1 44 41 80 00       	mov    0x804144,%eax
  802f3b:	40                   	inc    %eax
  802f3c:	a3 44 41 80 00       	mov    %eax,0x804144
	      break;
  802f41:	eb 38                	jmp    802f7b <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802f43:	a1 40 41 80 00       	mov    0x804140,%eax
  802f48:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f4b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f4f:	74 07                	je     802f58 <insert_sorted_with_merge_freeList+0x723>
  802f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f54:	8b 00                	mov    (%eax),%eax
  802f56:	eb 05                	jmp    802f5d <insert_sorted_with_merge_freeList+0x728>
  802f58:	b8 00 00 00 00       	mov    $0x0,%eax
  802f5d:	a3 40 41 80 00       	mov    %eax,0x804140
  802f62:	a1 40 41 80 00       	mov    0x804140,%eax
  802f67:	85 c0                	test   %eax,%eax
  802f69:	0f 85 c3 fb ff ff    	jne    802b32 <insert_sorted_with_merge_freeList+0x2fd>
  802f6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f73:	0f 85 b9 fb ff ff    	jne    802b32 <insert_sorted_with_merge_freeList+0x2fd>





}
  802f79:	eb 00                	jmp    802f7b <insert_sorted_with_merge_freeList+0x746>
  802f7b:	90                   	nop
  802f7c:	c9                   	leave  
  802f7d:	c3                   	ret    
  802f7e:	66 90                	xchg   %ax,%ax

00802f80 <__udivdi3>:
  802f80:	55                   	push   %ebp
  802f81:	57                   	push   %edi
  802f82:	56                   	push   %esi
  802f83:	53                   	push   %ebx
  802f84:	83 ec 1c             	sub    $0x1c,%esp
  802f87:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802f8b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802f8f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802f93:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802f97:	89 ca                	mov    %ecx,%edx
  802f99:	89 f8                	mov    %edi,%eax
  802f9b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802f9f:	85 f6                	test   %esi,%esi
  802fa1:	75 2d                	jne    802fd0 <__udivdi3+0x50>
  802fa3:	39 cf                	cmp    %ecx,%edi
  802fa5:	77 65                	ja     80300c <__udivdi3+0x8c>
  802fa7:	89 fd                	mov    %edi,%ebp
  802fa9:	85 ff                	test   %edi,%edi
  802fab:	75 0b                	jne    802fb8 <__udivdi3+0x38>
  802fad:	b8 01 00 00 00       	mov    $0x1,%eax
  802fb2:	31 d2                	xor    %edx,%edx
  802fb4:	f7 f7                	div    %edi
  802fb6:	89 c5                	mov    %eax,%ebp
  802fb8:	31 d2                	xor    %edx,%edx
  802fba:	89 c8                	mov    %ecx,%eax
  802fbc:	f7 f5                	div    %ebp
  802fbe:	89 c1                	mov    %eax,%ecx
  802fc0:	89 d8                	mov    %ebx,%eax
  802fc2:	f7 f5                	div    %ebp
  802fc4:	89 cf                	mov    %ecx,%edi
  802fc6:	89 fa                	mov    %edi,%edx
  802fc8:	83 c4 1c             	add    $0x1c,%esp
  802fcb:	5b                   	pop    %ebx
  802fcc:	5e                   	pop    %esi
  802fcd:	5f                   	pop    %edi
  802fce:	5d                   	pop    %ebp
  802fcf:	c3                   	ret    
  802fd0:	39 ce                	cmp    %ecx,%esi
  802fd2:	77 28                	ja     802ffc <__udivdi3+0x7c>
  802fd4:	0f bd fe             	bsr    %esi,%edi
  802fd7:	83 f7 1f             	xor    $0x1f,%edi
  802fda:	75 40                	jne    80301c <__udivdi3+0x9c>
  802fdc:	39 ce                	cmp    %ecx,%esi
  802fde:	72 0a                	jb     802fea <__udivdi3+0x6a>
  802fe0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802fe4:	0f 87 9e 00 00 00    	ja     803088 <__udivdi3+0x108>
  802fea:	b8 01 00 00 00       	mov    $0x1,%eax
  802fef:	89 fa                	mov    %edi,%edx
  802ff1:	83 c4 1c             	add    $0x1c,%esp
  802ff4:	5b                   	pop    %ebx
  802ff5:	5e                   	pop    %esi
  802ff6:	5f                   	pop    %edi
  802ff7:	5d                   	pop    %ebp
  802ff8:	c3                   	ret    
  802ff9:	8d 76 00             	lea    0x0(%esi),%esi
  802ffc:	31 ff                	xor    %edi,%edi
  802ffe:	31 c0                	xor    %eax,%eax
  803000:	89 fa                	mov    %edi,%edx
  803002:	83 c4 1c             	add    $0x1c,%esp
  803005:	5b                   	pop    %ebx
  803006:	5e                   	pop    %esi
  803007:	5f                   	pop    %edi
  803008:	5d                   	pop    %ebp
  803009:	c3                   	ret    
  80300a:	66 90                	xchg   %ax,%ax
  80300c:	89 d8                	mov    %ebx,%eax
  80300e:	f7 f7                	div    %edi
  803010:	31 ff                	xor    %edi,%edi
  803012:	89 fa                	mov    %edi,%edx
  803014:	83 c4 1c             	add    $0x1c,%esp
  803017:	5b                   	pop    %ebx
  803018:	5e                   	pop    %esi
  803019:	5f                   	pop    %edi
  80301a:	5d                   	pop    %ebp
  80301b:	c3                   	ret    
  80301c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803021:	89 eb                	mov    %ebp,%ebx
  803023:	29 fb                	sub    %edi,%ebx
  803025:	89 f9                	mov    %edi,%ecx
  803027:	d3 e6                	shl    %cl,%esi
  803029:	89 c5                	mov    %eax,%ebp
  80302b:	88 d9                	mov    %bl,%cl
  80302d:	d3 ed                	shr    %cl,%ebp
  80302f:	89 e9                	mov    %ebp,%ecx
  803031:	09 f1                	or     %esi,%ecx
  803033:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803037:	89 f9                	mov    %edi,%ecx
  803039:	d3 e0                	shl    %cl,%eax
  80303b:	89 c5                	mov    %eax,%ebp
  80303d:	89 d6                	mov    %edx,%esi
  80303f:	88 d9                	mov    %bl,%cl
  803041:	d3 ee                	shr    %cl,%esi
  803043:	89 f9                	mov    %edi,%ecx
  803045:	d3 e2                	shl    %cl,%edx
  803047:	8b 44 24 08          	mov    0x8(%esp),%eax
  80304b:	88 d9                	mov    %bl,%cl
  80304d:	d3 e8                	shr    %cl,%eax
  80304f:	09 c2                	or     %eax,%edx
  803051:	89 d0                	mov    %edx,%eax
  803053:	89 f2                	mov    %esi,%edx
  803055:	f7 74 24 0c          	divl   0xc(%esp)
  803059:	89 d6                	mov    %edx,%esi
  80305b:	89 c3                	mov    %eax,%ebx
  80305d:	f7 e5                	mul    %ebp
  80305f:	39 d6                	cmp    %edx,%esi
  803061:	72 19                	jb     80307c <__udivdi3+0xfc>
  803063:	74 0b                	je     803070 <__udivdi3+0xf0>
  803065:	89 d8                	mov    %ebx,%eax
  803067:	31 ff                	xor    %edi,%edi
  803069:	e9 58 ff ff ff       	jmp    802fc6 <__udivdi3+0x46>
  80306e:	66 90                	xchg   %ax,%ax
  803070:	8b 54 24 08          	mov    0x8(%esp),%edx
  803074:	89 f9                	mov    %edi,%ecx
  803076:	d3 e2                	shl    %cl,%edx
  803078:	39 c2                	cmp    %eax,%edx
  80307a:	73 e9                	jae    803065 <__udivdi3+0xe5>
  80307c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80307f:	31 ff                	xor    %edi,%edi
  803081:	e9 40 ff ff ff       	jmp    802fc6 <__udivdi3+0x46>
  803086:	66 90                	xchg   %ax,%ax
  803088:	31 c0                	xor    %eax,%eax
  80308a:	e9 37 ff ff ff       	jmp    802fc6 <__udivdi3+0x46>
  80308f:	90                   	nop

00803090 <__umoddi3>:
  803090:	55                   	push   %ebp
  803091:	57                   	push   %edi
  803092:	56                   	push   %esi
  803093:	53                   	push   %ebx
  803094:	83 ec 1c             	sub    $0x1c,%esp
  803097:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80309b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80309f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8030a3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8030a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8030ab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8030af:	89 f3                	mov    %esi,%ebx
  8030b1:	89 fa                	mov    %edi,%edx
  8030b3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8030b7:	89 34 24             	mov    %esi,(%esp)
  8030ba:	85 c0                	test   %eax,%eax
  8030bc:	75 1a                	jne    8030d8 <__umoddi3+0x48>
  8030be:	39 f7                	cmp    %esi,%edi
  8030c0:	0f 86 a2 00 00 00    	jbe    803168 <__umoddi3+0xd8>
  8030c6:	89 c8                	mov    %ecx,%eax
  8030c8:	89 f2                	mov    %esi,%edx
  8030ca:	f7 f7                	div    %edi
  8030cc:	89 d0                	mov    %edx,%eax
  8030ce:	31 d2                	xor    %edx,%edx
  8030d0:	83 c4 1c             	add    $0x1c,%esp
  8030d3:	5b                   	pop    %ebx
  8030d4:	5e                   	pop    %esi
  8030d5:	5f                   	pop    %edi
  8030d6:	5d                   	pop    %ebp
  8030d7:	c3                   	ret    
  8030d8:	39 f0                	cmp    %esi,%eax
  8030da:	0f 87 ac 00 00 00    	ja     80318c <__umoddi3+0xfc>
  8030e0:	0f bd e8             	bsr    %eax,%ebp
  8030e3:	83 f5 1f             	xor    $0x1f,%ebp
  8030e6:	0f 84 ac 00 00 00    	je     803198 <__umoddi3+0x108>
  8030ec:	bf 20 00 00 00       	mov    $0x20,%edi
  8030f1:	29 ef                	sub    %ebp,%edi
  8030f3:	89 fe                	mov    %edi,%esi
  8030f5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8030f9:	89 e9                	mov    %ebp,%ecx
  8030fb:	d3 e0                	shl    %cl,%eax
  8030fd:	89 d7                	mov    %edx,%edi
  8030ff:	89 f1                	mov    %esi,%ecx
  803101:	d3 ef                	shr    %cl,%edi
  803103:	09 c7                	or     %eax,%edi
  803105:	89 e9                	mov    %ebp,%ecx
  803107:	d3 e2                	shl    %cl,%edx
  803109:	89 14 24             	mov    %edx,(%esp)
  80310c:	89 d8                	mov    %ebx,%eax
  80310e:	d3 e0                	shl    %cl,%eax
  803110:	89 c2                	mov    %eax,%edx
  803112:	8b 44 24 08          	mov    0x8(%esp),%eax
  803116:	d3 e0                	shl    %cl,%eax
  803118:	89 44 24 04          	mov    %eax,0x4(%esp)
  80311c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803120:	89 f1                	mov    %esi,%ecx
  803122:	d3 e8                	shr    %cl,%eax
  803124:	09 d0                	or     %edx,%eax
  803126:	d3 eb                	shr    %cl,%ebx
  803128:	89 da                	mov    %ebx,%edx
  80312a:	f7 f7                	div    %edi
  80312c:	89 d3                	mov    %edx,%ebx
  80312e:	f7 24 24             	mull   (%esp)
  803131:	89 c6                	mov    %eax,%esi
  803133:	89 d1                	mov    %edx,%ecx
  803135:	39 d3                	cmp    %edx,%ebx
  803137:	0f 82 87 00 00 00    	jb     8031c4 <__umoddi3+0x134>
  80313d:	0f 84 91 00 00 00    	je     8031d4 <__umoddi3+0x144>
  803143:	8b 54 24 04          	mov    0x4(%esp),%edx
  803147:	29 f2                	sub    %esi,%edx
  803149:	19 cb                	sbb    %ecx,%ebx
  80314b:	89 d8                	mov    %ebx,%eax
  80314d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803151:	d3 e0                	shl    %cl,%eax
  803153:	89 e9                	mov    %ebp,%ecx
  803155:	d3 ea                	shr    %cl,%edx
  803157:	09 d0                	or     %edx,%eax
  803159:	89 e9                	mov    %ebp,%ecx
  80315b:	d3 eb                	shr    %cl,%ebx
  80315d:	89 da                	mov    %ebx,%edx
  80315f:	83 c4 1c             	add    $0x1c,%esp
  803162:	5b                   	pop    %ebx
  803163:	5e                   	pop    %esi
  803164:	5f                   	pop    %edi
  803165:	5d                   	pop    %ebp
  803166:	c3                   	ret    
  803167:	90                   	nop
  803168:	89 fd                	mov    %edi,%ebp
  80316a:	85 ff                	test   %edi,%edi
  80316c:	75 0b                	jne    803179 <__umoddi3+0xe9>
  80316e:	b8 01 00 00 00       	mov    $0x1,%eax
  803173:	31 d2                	xor    %edx,%edx
  803175:	f7 f7                	div    %edi
  803177:	89 c5                	mov    %eax,%ebp
  803179:	89 f0                	mov    %esi,%eax
  80317b:	31 d2                	xor    %edx,%edx
  80317d:	f7 f5                	div    %ebp
  80317f:	89 c8                	mov    %ecx,%eax
  803181:	f7 f5                	div    %ebp
  803183:	89 d0                	mov    %edx,%eax
  803185:	e9 44 ff ff ff       	jmp    8030ce <__umoddi3+0x3e>
  80318a:	66 90                	xchg   %ax,%ax
  80318c:	89 c8                	mov    %ecx,%eax
  80318e:	89 f2                	mov    %esi,%edx
  803190:	83 c4 1c             	add    $0x1c,%esp
  803193:	5b                   	pop    %ebx
  803194:	5e                   	pop    %esi
  803195:	5f                   	pop    %edi
  803196:	5d                   	pop    %ebp
  803197:	c3                   	ret    
  803198:	3b 04 24             	cmp    (%esp),%eax
  80319b:	72 06                	jb     8031a3 <__umoddi3+0x113>
  80319d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8031a1:	77 0f                	ja     8031b2 <__umoddi3+0x122>
  8031a3:	89 f2                	mov    %esi,%edx
  8031a5:	29 f9                	sub    %edi,%ecx
  8031a7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8031ab:	89 14 24             	mov    %edx,(%esp)
  8031ae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8031b2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8031b6:	8b 14 24             	mov    (%esp),%edx
  8031b9:	83 c4 1c             	add    $0x1c,%esp
  8031bc:	5b                   	pop    %ebx
  8031bd:	5e                   	pop    %esi
  8031be:	5f                   	pop    %edi
  8031bf:	5d                   	pop    %ebp
  8031c0:	c3                   	ret    
  8031c1:	8d 76 00             	lea    0x0(%esi),%esi
  8031c4:	2b 04 24             	sub    (%esp),%eax
  8031c7:	19 fa                	sbb    %edi,%edx
  8031c9:	89 d1                	mov    %edx,%ecx
  8031cb:	89 c6                	mov    %eax,%esi
  8031cd:	e9 71 ff ff ff       	jmp    803143 <__umoddi3+0xb3>
  8031d2:	66 90                	xchg   %ax,%ax
  8031d4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8031d8:	72 ea                	jb     8031c4 <__umoddi3+0x134>
  8031da:	89 d9                	mov    %ebx,%ecx
  8031dc:	e9 62 ff ff ff       	jmp    803143 <__umoddi3+0xb3>
