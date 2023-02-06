
obj/user/ef_tst_sharing_5_slaveB1:     file format elf32-i386


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
  800031:	e8 05 01 00 00       	call   80013b <libmain>
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
  80003b:	83 ec 18             	sub    $0x18,%esp
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
  80008c:	68 c0 32 80 00       	push   $0x8032c0
  800091:	6a 12                	push   $0x12
  800093:	68 dc 32 80 00       	push   $0x8032dc
  800098:	e8 da 01 00 00       	call   800277 <_panic>
	}
	uint32 *x;
	x = sget(sys_getparentenvid(),"x");
  80009d:	e8 3a 1b 00 00       	call   801bdc <sys_getparentenvid>
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	68 fc 32 80 00       	push   $0x8032fc
  8000aa:	50                   	push   %eax
  8000ab:	e8 0e 16 00 00       	call   8016be <sget>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B1 env used x (getSharedObject)\n");
  8000b6:	83 ec 0c             	sub    $0xc,%esp
  8000b9:	68 00 33 80 00       	push   $0x803300
  8000be:	e8 68 04 00 00       	call   80052b <cprintf>
  8000c3:	83 c4 10             	add    $0x10,%esp

	cprintf("Slave B1 please be patient ...\n");
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	68 28 33 80 00       	push   $0x803328
  8000ce:	e8 58 04 00 00       	call   80052b <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp

	env_sleep(6000);
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 70 17 00 00       	push   $0x1770
  8000de:	e8 b7 2e 00 00       	call   802f9a <env_sleep>
  8000e3:	83 c4 10             	add    $0x10,%esp
	int freeFrames = sys_calculate_free_frames() ;
  8000e6:	e8 f8 17 00 00       	call   8018e3 <sys_calculate_free_frames>
  8000eb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(x);
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	ff 75 ec             	pushl  -0x14(%ebp)
  8000f4:	e8 8a 16 00 00       	call   801783 <sfree>
  8000f9:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B1 env removed x\n");
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	68 48 33 80 00       	push   $0x803348
  800104:	e8 22 04 00 00       	call   80052b <cprintf>
  800109:	83 c4 10             	add    $0x10,%esp

	if ((sys_calculate_free_frames() - freeFrames) !=  4) panic("B1 wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table and 1 for frame of x\nframes_storage of x: should be cleared now\n");
  80010c:	e8 d2 17 00 00       	call   8018e3 <sys_calculate_free_frames>
  800111:	89 c2                	mov    %eax,%edx
  800113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800116:	29 c2                	sub    %eax,%edx
  800118:	89 d0                	mov    %edx,%eax
  80011a:	83 f8 04             	cmp    $0x4,%eax
  80011d:	74 14                	je     800133 <_main+0xfb>
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	68 60 33 80 00       	push   $0x803360
  800127:	6a 20                	push   $0x20
  800129:	68 dc 32 80 00       	push   $0x8032dc
  80012e:	e8 44 01 00 00       	call   800277 <_panic>

	//To indicate that it's completed successfully
	inctst();
  800133:	e8 c9 1b 00 00       	call   801d01 <inctst>
	return;
  800138:	90                   	nop
}
  800139:	c9                   	leave  
  80013a:	c3                   	ret    

0080013b <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80013b:	55                   	push   %ebp
  80013c:	89 e5                	mov    %esp,%ebp
  80013e:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800141:	e8 7d 1a 00 00       	call   801bc3 <sys_getenvindex>
  800146:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800149:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80014c:	89 d0                	mov    %edx,%eax
  80014e:	c1 e0 03             	shl    $0x3,%eax
  800151:	01 d0                	add    %edx,%eax
  800153:	01 c0                	add    %eax,%eax
  800155:	01 d0                	add    %edx,%eax
  800157:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80015e:	01 d0                	add    %edx,%eax
  800160:	c1 e0 04             	shl    $0x4,%eax
  800163:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800168:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80016d:	a1 20 40 80 00       	mov    0x804020,%eax
  800172:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800178:	84 c0                	test   %al,%al
  80017a:	74 0f                	je     80018b <libmain+0x50>
		binaryname = myEnv->prog_name;
  80017c:	a1 20 40 80 00       	mov    0x804020,%eax
  800181:	05 5c 05 00 00       	add    $0x55c,%eax
  800186:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80018b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80018f:	7e 0a                	jle    80019b <libmain+0x60>
		binaryname = argv[0];
  800191:	8b 45 0c             	mov    0xc(%ebp),%eax
  800194:	8b 00                	mov    (%eax),%eax
  800196:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80019b:	83 ec 08             	sub    $0x8,%esp
  80019e:	ff 75 0c             	pushl  0xc(%ebp)
  8001a1:	ff 75 08             	pushl  0x8(%ebp)
  8001a4:	e8 8f fe ff ff       	call   800038 <_main>
  8001a9:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001ac:	e8 1f 18 00 00       	call   8019d0 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	68 20 34 80 00       	push   $0x803420
  8001b9:	e8 6d 03 00 00       	call   80052b <cprintf>
  8001be:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001c1:	a1 20 40 80 00       	mov    0x804020,%eax
  8001c6:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001cc:	a1 20 40 80 00       	mov    0x804020,%eax
  8001d1:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001d7:	83 ec 04             	sub    $0x4,%esp
  8001da:	52                   	push   %edx
  8001db:	50                   	push   %eax
  8001dc:	68 48 34 80 00       	push   $0x803448
  8001e1:	e8 45 03 00 00       	call   80052b <cprintf>
  8001e6:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001e9:	a1 20 40 80 00       	mov    0x804020,%eax
  8001ee:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8001f4:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f9:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8001ff:	a1 20 40 80 00       	mov    0x804020,%eax
  800204:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80020a:	51                   	push   %ecx
  80020b:	52                   	push   %edx
  80020c:	50                   	push   %eax
  80020d:	68 70 34 80 00       	push   $0x803470
  800212:	e8 14 03 00 00       	call   80052b <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80021a:	a1 20 40 80 00       	mov    0x804020,%eax
  80021f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800225:	83 ec 08             	sub    $0x8,%esp
  800228:	50                   	push   %eax
  800229:	68 c8 34 80 00       	push   $0x8034c8
  80022e:	e8 f8 02 00 00       	call   80052b <cprintf>
  800233:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800236:	83 ec 0c             	sub    $0xc,%esp
  800239:	68 20 34 80 00       	push   $0x803420
  80023e:	e8 e8 02 00 00       	call   80052b <cprintf>
  800243:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800246:	e8 9f 17 00 00       	call   8019ea <sys_enable_interrupt>

	// exit gracefully
	exit();
  80024b:	e8 19 00 00 00       	call   800269 <exit>
}
  800250:	90                   	nop
  800251:	c9                   	leave  
  800252:	c3                   	ret    

00800253 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800253:	55                   	push   %ebp
  800254:	89 e5                	mov    %esp,%ebp
  800256:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800259:	83 ec 0c             	sub    $0xc,%esp
  80025c:	6a 00                	push   $0x0
  80025e:	e8 2c 19 00 00       	call   801b8f <sys_destroy_env>
  800263:	83 c4 10             	add    $0x10,%esp
}
  800266:	90                   	nop
  800267:	c9                   	leave  
  800268:	c3                   	ret    

00800269 <exit>:

void
exit(void)
{
  800269:	55                   	push   %ebp
  80026a:	89 e5                	mov    %esp,%ebp
  80026c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80026f:	e8 81 19 00 00       	call   801bf5 <sys_exit_env>
}
  800274:	90                   	nop
  800275:	c9                   	leave  
  800276:	c3                   	ret    

00800277 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800277:	55                   	push   %ebp
  800278:	89 e5                	mov    %esp,%ebp
  80027a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80027d:	8d 45 10             	lea    0x10(%ebp),%eax
  800280:	83 c0 04             	add    $0x4,%eax
  800283:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800286:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80028b:	85 c0                	test   %eax,%eax
  80028d:	74 16                	je     8002a5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80028f:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800294:	83 ec 08             	sub    $0x8,%esp
  800297:	50                   	push   %eax
  800298:	68 dc 34 80 00       	push   $0x8034dc
  80029d:	e8 89 02 00 00       	call   80052b <cprintf>
  8002a2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002a5:	a1 00 40 80 00       	mov    0x804000,%eax
  8002aa:	ff 75 0c             	pushl  0xc(%ebp)
  8002ad:	ff 75 08             	pushl  0x8(%ebp)
  8002b0:	50                   	push   %eax
  8002b1:	68 e1 34 80 00       	push   $0x8034e1
  8002b6:	e8 70 02 00 00       	call   80052b <cprintf>
  8002bb:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002be:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c1:	83 ec 08             	sub    $0x8,%esp
  8002c4:	ff 75 f4             	pushl  -0xc(%ebp)
  8002c7:	50                   	push   %eax
  8002c8:	e8 f3 01 00 00       	call   8004c0 <vcprintf>
  8002cd:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002d0:	83 ec 08             	sub    $0x8,%esp
  8002d3:	6a 00                	push   $0x0
  8002d5:	68 fd 34 80 00       	push   $0x8034fd
  8002da:	e8 e1 01 00 00       	call   8004c0 <vcprintf>
  8002df:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002e2:	e8 82 ff ff ff       	call   800269 <exit>

	// should not return here
	while (1) ;
  8002e7:	eb fe                	jmp    8002e7 <_panic+0x70>

008002e9 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002e9:	55                   	push   %ebp
  8002ea:	89 e5                	mov    %esp,%ebp
  8002ec:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002ef:	a1 20 40 80 00       	mov    0x804020,%eax
  8002f4:	8b 50 74             	mov    0x74(%eax),%edx
  8002f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002fa:	39 c2                	cmp    %eax,%edx
  8002fc:	74 14                	je     800312 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002fe:	83 ec 04             	sub    $0x4,%esp
  800301:	68 00 35 80 00       	push   $0x803500
  800306:	6a 26                	push   $0x26
  800308:	68 4c 35 80 00       	push   $0x80354c
  80030d:	e8 65 ff ff ff       	call   800277 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800312:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800319:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800320:	e9 c2 00 00 00       	jmp    8003e7 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800325:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800328:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032f:	8b 45 08             	mov    0x8(%ebp),%eax
  800332:	01 d0                	add    %edx,%eax
  800334:	8b 00                	mov    (%eax),%eax
  800336:	85 c0                	test   %eax,%eax
  800338:	75 08                	jne    800342 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80033a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80033d:	e9 a2 00 00 00       	jmp    8003e4 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800342:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800349:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800350:	eb 69                	jmp    8003bb <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800352:	a1 20 40 80 00       	mov    0x804020,%eax
  800357:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80035d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800360:	89 d0                	mov    %edx,%eax
  800362:	01 c0                	add    %eax,%eax
  800364:	01 d0                	add    %edx,%eax
  800366:	c1 e0 03             	shl    $0x3,%eax
  800369:	01 c8                	add    %ecx,%eax
  80036b:	8a 40 04             	mov    0x4(%eax),%al
  80036e:	84 c0                	test   %al,%al
  800370:	75 46                	jne    8003b8 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800372:	a1 20 40 80 00       	mov    0x804020,%eax
  800377:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80037d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800380:	89 d0                	mov    %edx,%eax
  800382:	01 c0                	add    %eax,%eax
  800384:	01 d0                	add    %edx,%eax
  800386:	c1 e0 03             	shl    $0x3,%eax
  800389:	01 c8                	add    %ecx,%eax
  80038b:	8b 00                	mov    (%eax),%eax
  80038d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800390:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800393:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800398:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80039a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80039d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a7:	01 c8                	add    %ecx,%eax
  8003a9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003ab:	39 c2                	cmp    %eax,%edx
  8003ad:	75 09                	jne    8003b8 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003af:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003b6:	eb 12                	jmp    8003ca <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003b8:	ff 45 e8             	incl   -0x18(%ebp)
  8003bb:	a1 20 40 80 00       	mov    0x804020,%eax
  8003c0:	8b 50 74             	mov    0x74(%eax),%edx
  8003c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003c6:	39 c2                	cmp    %eax,%edx
  8003c8:	77 88                	ja     800352 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003ce:	75 14                	jne    8003e4 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003d0:	83 ec 04             	sub    $0x4,%esp
  8003d3:	68 58 35 80 00       	push   $0x803558
  8003d8:	6a 3a                	push   $0x3a
  8003da:	68 4c 35 80 00       	push   $0x80354c
  8003df:	e8 93 fe ff ff       	call   800277 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003e4:	ff 45 f0             	incl   -0x10(%ebp)
  8003e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ea:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003ed:	0f 8c 32 ff ff ff    	jl     800325 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003f3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003fa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800401:	eb 26                	jmp    800429 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800403:	a1 20 40 80 00       	mov    0x804020,%eax
  800408:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80040e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800411:	89 d0                	mov    %edx,%eax
  800413:	01 c0                	add    %eax,%eax
  800415:	01 d0                	add    %edx,%eax
  800417:	c1 e0 03             	shl    $0x3,%eax
  80041a:	01 c8                	add    %ecx,%eax
  80041c:	8a 40 04             	mov    0x4(%eax),%al
  80041f:	3c 01                	cmp    $0x1,%al
  800421:	75 03                	jne    800426 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800423:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800426:	ff 45 e0             	incl   -0x20(%ebp)
  800429:	a1 20 40 80 00       	mov    0x804020,%eax
  80042e:	8b 50 74             	mov    0x74(%eax),%edx
  800431:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800434:	39 c2                	cmp    %eax,%edx
  800436:	77 cb                	ja     800403 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800438:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80043b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80043e:	74 14                	je     800454 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800440:	83 ec 04             	sub    $0x4,%esp
  800443:	68 ac 35 80 00       	push   $0x8035ac
  800448:	6a 44                	push   $0x44
  80044a:	68 4c 35 80 00       	push   $0x80354c
  80044f:	e8 23 fe ff ff       	call   800277 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800454:	90                   	nop
  800455:	c9                   	leave  
  800456:	c3                   	ret    

00800457 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800457:	55                   	push   %ebp
  800458:	89 e5                	mov    %esp,%ebp
  80045a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80045d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800460:	8b 00                	mov    (%eax),%eax
  800462:	8d 48 01             	lea    0x1(%eax),%ecx
  800465:	8b 55 0c             	mov    0xc(%ebp),%edx
  800468:	89 0a                	mov    %ecx,(%edx)
  80046a:	8b 55 08             	mov    0x8(%ebp),%edx
  80046d:	88 d1                	mov    %dl,%cl
  80046f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800472:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800476:	8b 45 0c             	mov    0xc(%ebp),%eax
  800479:	8b 00                	mov    (%eax),%eax
  80047b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800480:	75 2c                	jne    8004ae <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800482:	a0 24 40 80 00       	mov    0x804024,%al
  800487:	0f b6 c0             	movzbl %al,%eax
  80048a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80048d:	8b 12                	mov    (%edx),%edx
  80048f:	89 d1                	mov    %edx,%ecx
  800491:	8b 55 0c             	mov    0xc(%ebp),%edx
  800494:	83 c2 08             	add    $0x8,%edx
  800497:	83 ec 04             	sub    $0x4,%esp
  80049a:	50                   	push   %eax
  80049b:	51                   	push   %ecx
  80049c:	52                   	push   %edx
  80049d:	e8 80 13 00 00       	call   801822 <sys_cputs>
  8004a2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b1:	8b 40 04             	mov    0x4(%eax),%eax
  8004b4:	8d 50 01             	lea    0x1(%eax),%edx
  8004b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ba:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004bd:	90                   	nop
  8004be:	c9                   	leave  
  8004bf:	c3                   	ret    

008004c0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004c0:	55                   	push   %ebp
  8004c1:	89 e5                	mov    %esp,%ebp
  8004c3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004c9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004d0:	00 00 00 
	b.cnt = 0;
  8004d3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004da:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004dd:	ff 75 0c             	pushl  0xc(%ebp)
  8004e0:	ff 75 08             	pushl  0x8(%ebp)
  8004e3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004e9:	50                   	push   %eax
  8004ea:	68 57 04 80 00       	push   $0x800457
  8004ef:	e8 11 02 00 00       	call   800705 <vprintfmt>
  8004f4:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004f7:	a0 24 40 80 00       	mov    0x804024,%al
  8004fc:	0f b6 c0             	movzbl %al,%eax
  8004ff:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800505:	83 ec 04             	sub    $0x4,%esp
  800508:	50                   	push   %eax
  800509:	52                   	push   %edx
  80050a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800510:	83 c0 08             	add    $0x8,%eax
  800513:	50                   	push   %eax
  800514:	e8 09 13 00 00       	call   801822 <sys_cputs>
  800519:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80051c:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800523:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800529:	c9                   	leave  
  80052a:	c3                   	ret    

0080052b <cprintf>:

int cprintf(const char *fmt, ...) {
  80052b:	55                   	push   %ebp
  80052c:	89 e5                	mov    %esp,%ebp
  80052e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800531:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800538:	8d 45 0c             	lea    0xc(%ebp),%eax
  80053b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80053e:	8b 45 08             	mov    0x8(%ebp),%eax
  800541:	83 ec 08             	sub    $0x8,%esp
  800544:	ff 75 f4             	pushl  -0xc(%ebp)
  800547:	50                   	push   %eax
  800548:	e8 73 ff ff ff       	call   8004c0 <vcprintf>
  80054d:	83 c4 10             	add    $0x10,%esp
  800550:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800553:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800556:	c9                   	leave  
  800557:	c3                   	ret    

00800558 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800558:	55                   	push   %ebp
  800559:	89 e5                	mov    %esp,%ebp
  80055b:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80055e:	e8 6d 14 00 00       	call   8019d0 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800563:	8d 45 0c             	lea    0xc(%ebp),%eax
  800566:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800569:	8b 45 08             	mov    0x8(%ebp),%eax
  80056c:	83 ec 08             	sub    $0x8,%esp
  80056f:	ff 75 f4             	pushl  -0xc(%ebp)
  800572:	50                   	push   %eax
  800573:	e8 48 ff ff ff       	call   8004c0 <vcprintf>
  800578:	83 c4 10             	add    $0x10,%esp
  80057b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80057e:	e8 67 14 00 00       	call   8019ea <sys_enable_interrupt>
	return cnt;
  800583:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800586:	c9                   	leave  
  800587:	c3                   	ret    

00800588 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800588:	55                   	push   %ebp
  800589:	89 e5                	mov    %esp,%ebp
  80058b:	53                   	push   %ebx
  80058c:	83 ec 14             	sub    $0x14,%esp
  80058f:	8b 45 10             	mov    0x10(%ebp),%eax
  800592:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800595:	8b 45 14             	mov    0x14(%ebp),%eax
  800598:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80059b:	8b 45 18             	mov    0x18(%ebp),%eax
  80059e:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005a6:	77 55                	ja     8005fd <printnum+0x75>
  8005a8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ab:	72 05                	jb     8005b2 <printnum+0x2a>
  8005ad:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005b0:	77 4b                	ja     8005fd <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005b2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005b5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005b8:	8b 45 18             	mov    0x18(%ebp),%eax
  8005bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c0:	52                   	push   %edx
  8005c1:	50                   	push   %eax
  8005c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8005c5:	ff 75 f0             	pushl  -0x10(%ebp)
  8005c8:	e8 83 2a 00 00       	call   803050 <__udivdi3>
  8005cd:	83 c4 10             	add    $0x10,%esp
  8005d0:	83 ec 04             	sub    $0x4,%esp
  8005d3:	ff 75 20             	pushl  0x20(%ebp)
  8005d6:	53                   	push   %ebx
  8005d7:	ff 75 18             	pushl  0x18(%ebp)
  8005da:	52                   	push   %edx
  8005db:	50                   	push   %eax
  8005dc:	ff 75 0c             	pushl  0xc(%ebp)
  8005df:	ff 75 08             	pushl  0x8(%ebp)
  8005e2:	e8 a1 ff ff ff       	call   800588 <printnum>
  8005e7:	83 c4 20             	add    $0x20,%esp
  8005ea:	eb 1a                	jmp    800606 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005ec:	83 ec 08             	sub    $0x8,%esp
  8005ef:	ff 75 0c             	pushl  0xc(%ebp)
  8005f2:	ff 75 20             	pushl  0x20(%ebp)
  8005f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f8:	ff d0                	call   *%eax
  8005fa:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005fd:	ff 4d 1c             	decl   0x1c(%ebp)
  800600:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800604:	7f e6                	jg     8005ec <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800606:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800609:	bb 00 00 00 00       	mov    $0x0,%ebx
  80060e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800611:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800614:	53                   	push   %ebx
  800615:	51                   	push   %ecx
  800616:	52                   	push   %edx
  800617:	50                   	push   %eax
  800618:	e8 43 2b 00 00       	call   803160 <__umoddi3>
  80061d:	83 c4 10             	add    $0x10,%esp
  800620:	05 14 38 80 00       	add    $0x803814,%eax
  800625:	8a 00                	mov    (%eax),%al
  800627:	0f be c0             	movsbl %al,%eax
  80062a:	83 ec 08             	sub    $0x8,%esp
  80062d:	ff 75 0c             	pushl  0xc(%ebp)
  800630:	50                   	push   %eax
  800631:	8b 45 08             	mov    0x8(%ebp),%eax
  800634:	ff d0                	call   *%eax
  800636:	83 c4 10             	add    $0x10,%esp
}
  800639:	90                   	nop
  80063a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80063d:	c9                   	leave  
  80063e:	c3                   	ret    

0080063f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80063f:	55                   	push   %ebp
  800640:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800642:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800646:	7e 1c                	jle    800664 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800648:	8b 45 08             	mov    0x8(%ebp),%eax
  80064b:	8b 00                	mov    (%eax),%eax
  80064d:	8d 50 08             	lea    0x8(%eax),%edx
  800650:	8b 45 08             	mov    0x8(%ebp),%eax
  800653:	89 10                	mov    %edx,(%eax)
  800655:	8b 45 08             	mov    0x8(%ebp),%eax
  800658:	8b 00                	mov    (%eax),%eax
  80065a:	83 e8 08             	sub    $0x8,%eax
  80065d:	8b 50 04             	mov    0x4(%eax),%edx
  800660:	8b 00                	mov    (%eax),%eax
  800662:	eb 40                	jmp    8006a4 <getuint+0x65>
	else if (lflag)
  800664:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800668:	74 1e                	je     800688 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80066a:	8b 45 08             	mov    0x8(%ebp),%eax
  80066d:	8b 00                	mov    (%eax),%eax
  80066f:	8d 50 04             	lea    0x4(%eax),%edx
  800672:	8b 45 08             	mov    0x8(%ebp),%eax
  800675:	89 10                	mov    %edx,(%eax)
  800677:	8b 45 08             	mov    0x8(%ebp),%eax
  80067a:	8b 00                	mov    (%eax),%eax
  80067c:	83 e8 04             	sub    $0x4,%eax
  80067f:	8b 00                	mov    (%eax),%eax
  800681:	ba 00 00 00 00       	mov    $0x0,%edx
  800686:	eb 1c                	jmp    8006a4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800688:	8b 45 08             	mov    0x8(%ebp),%eax
  80068b:	8b 00                	mov    (%eax),%eax
  80068d:	8d 50 04             	lea    0x4(%eax),%edx
  800690:	8b 45 08             	mov    0x8(%ebp),%eax
  800693:	89 10                	mov    %edx,(%eax)
  800695:	8b 45 08             	mov    0x8(%ebp),%eax
  800698:	8b 00                	mov    (%eax),%eax
  80069a:	83 e8 04             	sub    $0x4,%eax
  80069d:	8b 00                	mov    (%eax),%eax
  80069f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006a4:	5d                   	pop    %ebp
  8006a5:	c3                   	ret    

008006a6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006a6:	55                   	push   %ebp
  8006a7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006a9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006ad:	7e 1c                	jle    8006cb <getint+0x25>
		return va_arg(*ap, long long);
  8006af:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b2:	8b 00                	mov    (%eax),%eax
  8006b4:	8d 50 08             	lea    0x8(%eax),%edx
  8006b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ba:	89 10                	mov    %edx,(%eax)
  8006bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bf:	8b 00                	mov    (%eax),%eax
  8006c1:	83 e8 08             	sub    $0x8,%eax
  8006c4:	8b 50 04             	mov    0x4(%eax),%edx
  8006c7:	8b 00                	mov    (%eax),%eax
  8006c9:	eb 38                	jmp    800703 <getint+0x5d>
	else if (lflag)
  8006cb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006cf:	74 1a                	je     8006eb <getint+0x45>
		return va_arg(*ap, long);
  8006d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d4:	8b 00                	mov    (%eax),%eax
  8006d6:	8d 50 04             	lea    0x4(%eax),%edx
  8006d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dc:	89 10                	mov    %edx,(%eax)
  8006de:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e1:	8b 00                	mov    (%eax),%eax
  8006e3:	83 e8 04             	sub    $0x4,%eax
  8006e6:	8b 00                	mov    (%eax),%eax
  8006e8:	99                   	cltd   
  8006e9:	eb 18                	jmp    800703 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ee:	8b 00                	mov    (%eax),%eax
  8006f0:	8d 50 04             	lea    0x4(%eax),%edx
  8006f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f6:	89 10                	mov    %edx,(%eax)
  8006f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fb:	8b 00                	mov    (%eax),%eax
  8006fd:	83 e8 04             	sub    $0x4,%eax
  800700:	8b 00                	mov    (%eax),%eax
  800702:	99                   	cltd   
}
  800703:	5d                   	pop    %ebp
  800704:	c3                   	ret    

00800705 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800705:	55                   	push   %ebp
  800706:	89 e5                	mov    %esp,%ebp
  800708:	56                   	push   %esi
  800709:	53                   	push   %ebx
  80070a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80070d:	eb 17                	jmp    800726 <vprintfmt+0x21>
			if (ch == '\0')
  80070f:	85 db                	test   %ebx,%ebx
  800711:	0f 84 af 03 00 00    	je     800ac6 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800717:	83 ec 08             	sub    $0x8,%esp
  80071a:	ff 75 0c             	pushl  0xc(%ebp)
  80071d:	53                   	push   %ebx
  80071e:	8b 45 08             	mov    0x8(%ebp),%eax
  800721:	ff d0                	call   *%eax
  800723:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800726:	8b 45 10             	mov    0x10(%ebp),%eax
  800729:	8d 50 01             	lea    0x1(%eax),%edx
  80072c:	89 55 10             	mov    %edx,0x10(%ebp)
  80072f:	8a 00                	mov    (%eax),%al
  800731:	0f b6 d8             	movzbl %al,%ebx
  800734:	83 fb 25             	cmp    $0x25,%ebx
  800737:	75 d6                	jne    80070f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800739:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80073d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800744:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80074b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800752:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800759:	8b 45 10             	mov    0x10(%ebp),%eax
  80075c:	8d 50 01             	lea    0x1(%eax),%edx
  80075f:	89 55 10             	mov    %edx,0x10(%ebp)
  800762:	8a 00                	mov    (%eax),%al
  800764:	0f b6 d8             	movzbl %al,%ebx
  800767:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80076a:	83 f8 55             	cmp    $0x55,%eax
  80076d:	0f 87 2b 03 00 00    	ja     800a9e <vprintfmt+0x399>
  800773:	8b 04 85 38 38 80 00 	mov    0x803838(,%eax,4),%eax
  80077a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80077c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800780:	eb d7                	jmp    800759 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800782:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800786:	eb d1                	jmp    800759 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800788:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80078f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800792:	89 d0                	mov    %edx,%eax
  800794:	c1 e0 02             	shl    $0x2,%eax
  800797:	01 d0                	add    %edx,%eax
  800799:	01 c0                	add    %eax,%eax
  80079b:	01 d8                	add    %ebx,%eax
  80079d:	83 e8 30             	sub    $0x30,%eax
  8007a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a6:	8a 00                	mov    (%eax),%al
  8007a8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007ab:	83 fb 2f             	cmp    $0x2f,%ebx
  8007ae:	7e 3e                	jle    8007ee <vprintfmt+0xe9>
  8007b0:	83 fb 39             	cmp    $0x39,%ebx
  8007b3:	7f 39                	jg     8007ee <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007b5:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007b8:	eb d5                	jmp    80078f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bd:	83 c0 04             	add    $0x4,%eax
  8007c0:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c6:	83 e8 04             	sub    $0x4,%eax
  8007c9:	8b 00                	mov    (%eax),%eax
  8007cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007ce:	eb 1f                	jmp    8007ef <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007d0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007d4:	79 83                	jns    800759 <vprintfmt+0x54>
				width = 0;
  8007d6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007dd:	e9 77 ff ff ff       	jmp    800759 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007e2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007e9:	e9 6b ff ff ff       	jmp    800759 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007ee:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007ef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007f3:	0f 89 60 ff ff ff    	jns    800759 <vprintfmt+0x54>
				width = precision, precision = -1;
  8007f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007ff:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800806:	e9 4e ff ff ff       	jmp    800759 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80080b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80080e:	e9 46 ff ff ff       	jmp    800759 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800813:	8b 45 14             	mov    0x14(%ebp),%eax
  800816:	83 c0 04             	add    $0x4,%eax
  800819:	89 45 14             	mov    %eax,0x14(%ebp)
  80081c:	8b 45 14             	mov    0x14(%ebp),%eax
  80081f:	83 e8 04             	sub    $0x4,%eax
  800822:	8b 00                	mov    (%eax),%eax
  800824:	83 ec 08             	sub    $0x8,%esp
  800827:	ff 75 0c             	pushl  0xc(%ebp)
  80082a:	50                   	push   %eax
  80082b:	8b 45 08             	mov    0x8(%ebp),%eax
  80082e:	ff d0                	call   *%eax
  800830:	83 c4 10             	add    $0x10,%esp
			break;
  800833:	e9 89 02 00 00       	jmp    800ac1 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800838:	8b 45 14             	mov    0x14(%ebp),%eax
  80083b:	83 c0 04             	add    $0x4,%eax
  80083e:	89 45 14             	mov    %eax,0x14(%ebp)
  800841:	8b 45 14             	mov    0x14(%ebp),%eax
  800844:	83 e8 04             	sub    $0x4,%eax
  800847:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800849:	85 db                	test   %ebx,%ebx
  80084b:	79 02                	jns    80084f <vprintfmt+0x14a>
				err = -err;
  80084d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80084f:	83 fb 64             	cmp    $0x64,%ebx
  800852:	7f 0b                	jg     80085f <vprintfmt+0x15a>
  800854:	8b 34 9d 80 36 80 00 	mov    0x803680(,%ebx,4),%esi
  80085b:	85 f6                	test   %esi,%esi
  80085d:	75 19                	jne    800878 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80085f:	53                   	push   %ebx
  800860:	68 25 38 80 00       	push   $0x803825
  800865:	ff 75 0c             	pushl  0xc(%ebp)
  800868:	ff 75 08             	pushl  0x8(%ebp)
  80086b:	e8 5e 02 00 00       	call   800ace <printfmt>
  800870:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800873:	e9 49 02 00 00       	jmp    800ac1 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800878:	56                   	push   %esi
  800879:	68 2e 38 80 00       	push   $0x80382e
  80087e:	ff 75 0c             	pushl  0xc(%ebp)
  800881:	ff 75 08             	pushl  0x8(%ebp)
  800884:	e8 45 02 00 00       	call   800ace <printfmt>
  800889:	83 c4 10             	add    $0x10,%esp
			break;
  80088c:	e9 30 02 00 00       	jmp    800ac1 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800891:	8b 45 14             	mov    0x14(%ebp),%eax
  800894:	83 c0 04             	add    $0x4,%eax
  800897:	89 45 14             	mov    %eax,0x14(%ebp)
  80089a:	8b 45 14             	mov    0x14(%ebp),%eax
  80089d:	83 e8 04             	sub    $0x4,%eax
  8008a0:	8b 30                	mov    (%eax),%esi
  8008a2:	85 f6                	test   %esi,%esi
  8008a4:	75 05                	jne    8008ab <vprintfmt+0x1a6>
				p = "(null)";
  8008a6:	be 31 38 80 00       	mov    $0x803831,%esi
			if (width > 0 && padc != '-')
  8008ab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008af:	7e 6d                	jle    80091e <vprintfmt+0x219>
  8008b1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008b5:	74 67                	je     80091e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ba:	83 ec 08             	sub    $0x8,%esp
  8008bd:	50                   	push   %eax
  8008be:	56                   	push   %esi
  8008bf:	e8 0c 03 00 00       	call   800bd0 <strnlen>
  8008c4:	83 c4 10             	add    $0x10,%esp
  8008c7:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008ca:	eb 16                	jmp    8008e2 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008cc:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008d0:	83 ec 08             	sub    $0x8,%esp
  8008d3:	ff 75 0c             	pushl  0xc(%ebp)
  8008d6:	50                   	push   %eax
  8008d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008da:	ff d0                	call   *%eax
  8008dc:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008df:	ff 4d e4             	decl   -0x1c(%ebp)
  8008e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008e6:	7f e4                	jg     8008cc <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008e8:	eb 34                	jmp    80091e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008ea:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008ee:	74 1c                	je     80090c <vprintfmt+0x207>
  8008f0:	83 fb 1f             	cmp    $0x1f,%ebx
  8008f3:	7e 05                	jle    8008fa <vprintfmt+0x1f5>
  8008f5:	83 fb 7e             	cmp    $0x7e,%ebx
  8008f8:	7e 12                	jle    80090c <vprintfmt+0x207>
					putch('?', putdat);
  8008fa:	83 ec 08             	sub    $0x8,%esp
  8008fd:	ff 75 0c             	pushl  0xc(%ebp)
  800900:	6a 3f                	push   $0x3f
  800902:	8b 45 08             	mov    0x8(%ebp),%eax
  800905:	ff d0                	call   *%eax
  800907:	83 c4 10             	add    $0x10,%esp
  80090a:	eb 0f                	jmp    80091b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80090c:	83 ec 08             	sub    $0x8,%esp
  80090f:	ff 75 0c             	pushl  0xc(%ebp)
  800912:	53                   	push   %ebx
  800913:	8b 45 08             	mov    0x8(%ebp),%eax
  800916:	ff d0                	call   *%eax
  800918:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80091b:	ff 4d e4             	decl   -0x1c(%ebp)
  80091e:	89 f0                	mov    %esi,%eax
  800920:	8d 70 01             	lea    0x1(%eax),%esi
  800923:	8a 00                	mov    (%eax),%al
  800925:	0f be d8             	movsbl %al,%ebx
  800928:	85 db                	test   %ebx,%ebx
  80092a:	74 24                	je     800950 <vprintfmt+0x24b>
  80092c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800930:	78 b8                	js     8008ea <vprintfmt+0x1e5>
  800932:	ff 4d e0             	decl   -0x20(%ebp)
  800935:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800939:	79 af                	jns    8008ea <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80093b:	eb 13                	jmp    800950 <vprintfmt+0x24b>
				putch(' ', putdat);
  80093d:	83 ec 08             	sub    $0x8,%esp
  800940:	ff 75 0c             	pushl  0xc(%ebp)
  800943:	6a 20                	push   $0x20
  800945:	8b 45 08             	mov    0x8(%ebp),%eax
  800948:	ff d0                	call   *%eax
  80094a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80094d:	ff 4d e4             	decl   -0x1c(%ebp)
  800950:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800954:	7f e7                	jg     80093d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800956:	e9 66 01 00 00       	jmp    800ac1 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80095b:	83 ec 08             	sub    $0x8,%esp
  80095e:	ff 75 e8             	pushl  -0x18(%ebp)
  800961:	8d 45 14             	lea    0x14(%ebp),%eax
  800964:	50                   	push   %eax
  800965:	e8 3c fd ff ff       	call   8006a6 <getint>
  80096a:	83 c4 10             	add    $0x10,%esp
  80096d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800970:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800973:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800976:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800979:	85 d2                	test   %edx,%edx
  80097b:	79 23                	jns    8009a0 <vprintfmt+0x29b>
				putch('-', putdat);
  80097d:	83 ec 08             	sub    $0x8,%esp
  800980:	ff 75 0c             	pushl  0xc(%ebp)
  800983:	6a 2d                	push   $0x2d
  800985:	8b 45 08             	mov    0x8(%ebp),%eax
  800988:	ff d0                	call   *%eax
  80098a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80098d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800990:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800993:	f7 d8                	neg    %eax
  800995:	83 d2 00             	adc    $0x0,%edx
  800998:	f7 da                	neg    %edx
  80099a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80099d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009a0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009a7:	e9 bc 00 00 00       	jmp    800a68 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009ac:	83 ec 08             	sub    $0x8,%esp
  8009af:	ff 75 e8             	pushl  -0x18(%ebp)
  8009b2:	8d 45 14             	lea    0x14(%ebp),%eax
  8009b5:	50                   	push   %eax
  8009b6:	e8 84 fc ff ff       	call   80063f <getuint>
  8009bb:	83 c4 10             	add    $0x10,%esp
  8009be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009c4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009cb:	e9 98 00 00 00       	jmp    800a68 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009d0:	83 ec 08             	sub    $0x8,%esp
  8009d3:	ff 75 0c             	pushl  0xc(%ebp)
  8009d6:	6a 58                	push   $0x58
  8009d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009db:	ff d0                	call   *%eax
  8009dd:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009e0:	83 ec 08             	sub    $0x8,%esp
  8009e3:	ff 75 0c             	pushl  0xc(%ebp)
  8009e6:	6a 58                	push   $0x58
  8009e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009eb:	ff d0                	call   *%eax
  8009ed:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009f0:	83 ec 08             	sub    $0x8,%esp
  8009f3:	ff 75 0c             	pushl  0xc(%ebp)
  8009f6:	6a 58                	push   $0x58
  8009f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fb:	ff d0                	call   *%eax
  8009fd:	83 c4 10             	add    $0x10,%esp
			break;
  800a00:	e9 bc 00 00 00       	jmp    800ac1 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a05:	83 ec 08             	sub    $0x8,%esp
  800a08:	ff 75 0c             	pushl  0xc(%ebp)
  800a0b:	6a 30                	push   $0x30
  800a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a10:	ff d0                	call   *%eax
  800a12:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a15:	83 ec 08             	sub    $0x8,%esp
  800a18:	ff 75 0c             	pushl  0xc(%ebp)
  800a1b:	6a 78                	push   $0x78
  800a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a20:	ff d0                	call   *%eax
  800a22:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a25:	8b 45 14             	mov    0x14(%ebp),%eax
  800a28:	83 c0 04             	add    $0x4,%eax
  800a2b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a31:	83 e8 04             	sub    $0x4,%eax
  800a34:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a36:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a39:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a40:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a47:	eb 1f                	jmp    800a68 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a49:	83 ec 08             	sub    $0x8,%esp
  800a4c:	ff 75 e8             	pushl  -0x18(%ebp)
  800a4f:	8d 45 14             	lea    0x14(%ebp),%eax
  800a52:	50                   	push   %eax
  800a53:	e8 e7 fb ff ff       	call   80063f <getuint>
  800a58:	83 c4 10             	add    $0x10,%esp
  800a5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a5e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a61:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a68:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a6f:	83 ec 04             	sub    $0x4,%esp
  800a72:	52                   	push   %edx
  800a73:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a76:	50                   	push   %eax
  800a77:	ff 75 f4             	pushl  -0xc(%ebp)
  800a7a:	ff 75 f0             	pushl  -0x10(%ebp)
  800a7d:	ff 75 0c             	pushl  0xc(%ebp)
  800a80:	ff 75 08             	pushl  0x8(%ebp)
  800a83:	e8 00 fb ff ff       	call   800588 <printnum>
  800a88:	83 c4 20             	add    $0x20,%esp
			break;
  800a8b:	eb 34                	jmp    800ac1 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a8d:	83 ec 08             	sub    $0x8,%esp
  800a90:	ff 75 0c             	pushl  0xc(%ebp)
  800a93:	53                   	push   %ebx
  800a94:	8b 45 08             	mov    0x8(%ebp),%eax
  800a97:	ff d0                	call   *%eax
  800a99:	83 c4 10             	add    $0x10,%esp
			break;
  800a9c:	eb 23                	jmp    800ac1 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a9e:	83 ec 08             	sub    $0x8,%esp
  800aa1:	ff 75 0c             	pushl  0xc(%ebp)
  800aa4:	6a 25                	push   $0x25
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	ff d0                	call   *%eax
  800aab:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aae:	ff 4d 10             	decl   0x10(%ebp)
  800ab1:	eb 03                	jmp    800ab6 <vprintfmt+0x3b1>
  800ab3:	ff 4d 10             	decl   0x10(%ebp)
  800ab6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ab9:	48                   	dec    %eax
  800aba:	8a 00                	mov    (%eax),%al
  800abc:	3c 25                	cmp    $0x25,%al
  800abe:	75 f3                	jne    800ab3 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800ac0:	90                   	nop
		}
	}
  800ac1:	e9 47 fc ff ff       	jmp    80070d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ac6:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ac7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800aca:	5b                   	pop    %ebx
  800acb:	5e                   	pop    %esi
  800acc:	5d                   	pop    %ebp
  800acd:	c3                   	ret    

00800ace <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ace:	55                   	push   %ebp
  800acf:	89 e5                	mov    %esp,%ebp
  800ad1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ad4:	8d 45 10             	lea    0x10(%ebp),%eax
  800ad7:	83 c0 04             	add    $0x4,%eax
  800ada:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800add:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae0:	ff 75 f4             	pushl  -0xc(%ebp)
  800ae3:	50                   	push   %eax
  800ae4:	ff 75 0c             	pushl  0xc(%ebp)
  800ae7:	ff 75 08             	pushl  0x8(%ebp)
  800aea:	e8 16 fc ff ff       	call   800705 <vprintfmt>
  800aef:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800af2:	90                   	nop
  800af3:	c9                   	leave  
  800af4:	c3                   	ret    

00800af5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800af5:	55                   	push   %ebp
  800af6:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800af8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afb:	8b 40 08             	mov    0x8(%eax),%eax
  800afe:	8d 50 01             	lea    0x1(%eax),%edx
  800b01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b04:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0a:	8b 10                	mov    (%eax),%edx
  800b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0f:	8b 40 04             	mov    0x4(%eax),%eax
  800b12:	39 c2                	cmp    %eax,%edx
  800b14:	73 12                	jae    800b28 <sprintputch+0x33>
		*b->buf++ = ch;
  800b16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b19:	8b 00                	mov    (%eax),%eax
  800b1b:	8d 48 01             	lea    0x1(%eax),%ecx
  800b1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b21:	89 0a                	mov    %ecx,(%edx)
  800b23:	8b 55 08             	mov    0x8(%ebp),%edx
  800b26:	88 10                	mov    %dl,(%eax)
}
  800b28:	90                   	nop
  800b29:	5d                   	pop    %ebp
  800b2a:	c3                   	ret    

00800b2b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b2b:	55                   	push   %ebp
  800b2c:	89 e5                	mov    %esp,%ebp
  800b2e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b40:	01 d0                	add    %edx,%eax
  800b42:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b45:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b4c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b50:	74 06                	je     800b58 <vsnprintf+0x2d>
  800b52:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b56:	7f 07                	jg     800b5f <vsnprintf+0x34>
		return -E_INVAL;
  800b58:	b8 03 00 00 00       	mov    $0x3,%eax
  800b5d:	eb 20                	jmp    800b7f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b5f:	ff 75 14             	pushl  0x14(%ebp)
  800b62:	ff 75 10             	pushl  0x10(%ebp)
  800b65:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b68:	50                   	push   %eax
  800b69:	68 f5 0a 80 00       	push   $0x800af5
  800b6e:	e8 92 fb ff ff       	call   800705 <vprintfmt>
  800b73:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b79:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b7f:	c9                   	leave  
  800b80:	c3                   	ret    

00800b81 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b81:	55                   	push   %ebp
  800b82:	89 e5                	mov    %esp,%ebp
  800b84:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b87:	8d 45 10             	lea    0x10(%ebp),%eax
  800b8a:	83 c0 04             	add    $0x4,%eax
  800b8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b90:	8b 45 10             	mov    0x10(%ebp),%eax
  800b93:	ff 75 f4             	pushl  -0xc(%ebp)
  800b96:	50                   	push   %eax
  800b97:	ff 75 0c             	pushl  0xc(%ebp)
  800b9a:	ff 75 08             	pushl  0x8(%ebp)
  800b9d:	e8 89 ff ff ff       	call   800b2b <vsnprintf>
  800ba2:	83 c4 10             	add    $0x10,%esp
  800ba5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ba8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bab:	c9                   	leave  
  800bac:	c3                   	ret    

00800bad <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bad:	55                   	push   %ebp
  800bae:	89 e5                	mov    %esp,%ebp
  800bb0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bb3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bba:	eb 06                	jmp    800bc2 <strlen+0x15>
		n++;
  800bbc:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bbf:	ff 45 08             	incl   0x8(%ebp)
  800bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc5:	8a 00                	mov    (%eax),%al
  800bc7:	84 c0                	test   %al,%al
  800bc9:	75 f1                	jne    800bbc <strlen+0xf>
		n++;
	return n;
  800bcb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bce:	c9                   	leave  
  800bcf:	c3                   	ret    

00800bd0 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bd0:	55                   	push   %ebp
  800bd1:	89 e5                	mov    %esp,%ebp
  800bd3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bd6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bdd:	eb 09                	jmp    800be8 <strnlen+0x18>
		n++;
  800bdf:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800be2:	ff 45 08             	incl   0x8(%ebp)
  800be5:	ff 4d 0c             	decl   0xc(%ebp)
  800be8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bec:	74 09                	je     800bf7 <strnlen+0x27>
  800bee:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf1:	8a 00                	mov    (%eax),%al
  800bf3:	84 c0                	test   %al,%al
  800bf5:	75 e8                	jne    800bdf <strnlen+0xf>
		n++;
	return n;
  800bf7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bfa:	c9                   	leave  
  800bfb:	c3                   	ret    

00800bfc <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bfc:	55                   	push   %ebp
  800bfd:	89 e5                	mov    %esp,%ebp
  800bff:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c02:	8b 45 08             	mov    0x8(%ebp),%eax
  800c05:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c08:	90                   	nop
  800c09:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0c:	8d 50 01             	lea    0x1(%eax),%edx
  800c0f:	89 55 08             	mov    %edx,0x8(%ebp)
  800c12:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c15:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c18:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c1b:	8a 12                	mov    (%edx),%dl
  800c1d:	88 10                	mov    %dl,(%eax)
  800c1f:	8a 00                	mov    (%eax),%al
  800c21:	84 c0                	test   %al,%al
  800c23:	75 e4                	jne    800c09 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c25:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c28:	c9                   	leave  
  800c29:	c3                   	ret    

00800c2a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c2a:	55                   	push   %ebp
  800c2b:	89 e5                	mov    %esp,%ebp
  800c2d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c36:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c3d:	eb 1f                	jmp    800c5e <strncpy+0x34>
		*dst++ = *src;
  800c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c42:	8d 50 01             	lea    0x1(%eax),%edx
  800c45:	89 55 08             	mov    %edx,0x8(%ebp)
  800c48:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c4b:	8a 12                	mov    (%edx),%dl
  800c4d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c52:	8a 00                	mov    (%eax),%al
  800c54:	84 c0                	test   %al,%al
  800c56:	74 03                	je     800c5b <strncpy+0x31>
			src++;
  800c58:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c5b:	ff 45 fc             	incl   -0x4(%ebp)
  800c5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c61:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c64:	72 d9                	jb     800c3f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c66:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c69:	c9                   	leave  
  800c6a:	c3                   	ret    

00800c6b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c6b:	55                   	push   %ebp
  800c6c:	89 e5                	mov    %esp,%ebp
  800c6e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
  800c74:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c77:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c7b:	74 30                	je     800cad <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c7d:	eb 16                	jmp    800c95 <strlcpy+0x2a>
			*dst++ = *src++;
  800c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c82:	8d 50 01             	lea    0x1(%eax),%edx
  800c85:	89 55 08             	mov    %edx,0x8(%ebp)
  800c88:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c8b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c8e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c91:	8a 12                	mov    (%edx),%dl
  800c93:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c95:	ff 4d 10             	decl   0x10(%ebp)
  800c98:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c9c:	74 09                	je     800ca7 <strlcpy+0x3c>
  800c9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca1:	8a 00                	mov    (%eax),%al
  800ca3:	84 c0                	test   %al,%al
  800ca5:	75 d8                	jne    800c7f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  800caa:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cad:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cb3:	29 c2                	sub    %eax,%edx
  800cb5:	89 d0                	mov    %edx,%eax
}
  800cb7:	c9                   	leave  
  800cb8:	c3                   	ret    

00800cb9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cb9:	55                   	push   %ebp
  800cba:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cbc:	eb 06                	jmp    800cc4 <strcmp+0xb>
		p++, q++;
  800cbe:	ff 45 08             	incl   0x8(%ebp)
  800cc1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc7:	8a 00                	mov    (%eax),%al
  800cc9:	84 c0                	test   %al,%al
  800ccb:	74 0e                	je     800cdb <strcmp+0x22>
  800ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd0:	8a 10                	mov    (%eax),%dl
  800cd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd5:	8a 00                	mov    (%eax),%al
  800cd7:	38 c2                	cmp    %al,%dl
  800cd9:	74 e3                	je     800cbe <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cde:	8a 00                	mov    (%eax),%al
  800ce0:	0f b6 d0             	movzbl %al,%edx
  800ce3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce6:	8a 00                	mov    (%eax),%al
  800ce8:	0f b6 c0             	movzbl %al,%eax
  800ceb:	29 c2                	sub    %eax,%edx
  800ced:	89 d0                	mov    %edx,%eax
}
  800cef:	5d                   	pop    %ebp
  800cf0:	c3                   	ret    

00800cf1 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cf1:	55                   	push   %ebp
  800cf2:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cf4:	eb 09                	jmp    800cff <strncmp+0xe>
		n--, p++, q++;
  800cf6:	ff 4d 10             	decl   0x10(%ebp)
  800cf9:	ff 45 08             	incl   0x8(%ebp)
  800cfc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d03:	74 17                	je     800d1c <strncmp+0x2b>
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	8a 00                	mov    (%eax),%al
  800d0a:	84 c0                	test   %al,%al
  800d0c:	74 0e                	je     800d1c <strncmp+0x2b>
  800d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d11:	8a 10                	mov    (%eax),%dl
  800d13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d16:	8a 00                	mov    (%eax),%al
  800d18:	38 c2                	cmp    %al,%dl
  800d1a:	74 da                	je     800cf6 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d1c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d20:	75 07                	jne    800d29 <strncmp+0x38>
		return 0;
  800d22:	b8 00 00 00 00       	mov    $0x0,%eax
  800d27:	eb 14                	jmp    800d3d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d29:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2c:	8a 00                	mov    (%eax),%al
  800d2e:	0f b6 d0             	movzbl %al,%edx
  800d31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d34:	8a 00                	mov    (%eax),%al
  800d36:	0f b6 c0             	movzbl %al,%eax
  800d39:	29 c2                	sub    %eax,%edx
  800d3b:	89 d0                	mov    %edx,%eax
}
  800d3d:	5d                   	pop    %ebp
  800d3e:	c3                   	ret    

00800d3f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d3f:	55                   	push   %ebp
  800d40:	89 e5                	mov    %esp,%ebp
  800d42:	83 ec 04             	sub    $0x4,%esp
  800d45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d48:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d4b:	eb 12                	jmp    800d5f <strchr+0x20>
		if (*s == c)
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	8a 00                	mov    (%eax),%al
  800d52:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d55:	75 05                	jne    800d5c <strchr+0x1d>
			return (char *) s;
  800d57:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5a:	eb 11                	jmp    800d6d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d5c:	ff 45 08             	incl   0x8(%ebp)
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	8a 00                	mov    (%eax),%al
  800d64:	84 c0                	test   %al,%al
  800d66:	75 e5                	jne    800d4d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d6d:	c9                   	leave  
  800d6e:	c3                   	ret    

00800d6f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d6f:	55                   	push   %ebp
  800d70:	89 e5                	mov    %esp,%ebp
  800d72:	83 ec 04             	sub    $0x4,%esp
  800d75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d78:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d7b:	eb 0d                	jmp    800d8a <strfind+0x1b>
		if (*s == c)
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	8a 00                	mov    (%eax),%al
  800d82:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d85:	74 0e                	je     800d95 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d87:	ff 45 08             	incl   0x8(%ebp)
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8d:	8a 00                	mov    (%eax),%al
  800d8f:	84 c0                	test   %al,%al
  800d91:	75 ea                	jne    800d7d <strfind+0xe>
  800d93:	eb 01                	jmp    800d96 <strfind+0x27>
		if (*s == c)
			break;
  800d95:	90                   	nop
	return (char *) s;
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d99:	c9                   	leave  
  800d9a:	c3                   	ret    

00800d9b <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d9b:	55                   	push   %ebp
  800d9c:	89 e5                	mov    %esp,%ebp
  800d9e:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800da1:	8b 45 08             	mov    0x8(%ebp),%eax
  800da4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800da7:	8b 45 10             	mov    0x10(%ebp),%eax
  800daa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dad:	eb 0e                	jmp    800dbd <memset+0x22>
		*p++ = c;
  800daf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800db2:	8d 50 01             	lea    0x1(%eax),%edx
  800db5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800db8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dbb:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dbd:	ff 4d f8             	decl   -0x8(%ebp)
  800dc0:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dc4:	79 e9                	jns    800daf <memset+0x14>
		*p++ = c;

	return v;
  800dc6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dc9:	c9                   	leave  
  800dca:	c3                   	ret    

00800dcb <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dcb:	55                   	push   %ebp
  800dcc:	89 e5                	mov    %esp,%ebp
  800dce:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ddd:	eb 16                	jmp    800df5 <memcpy+0x2a>
		*d++ = *s++;
  800ddf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800de2:	8d 50 01             	lea    0x1(%eax),%edx
  800de5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800de8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800deb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dee:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800df1:	8a 12                	mov    (%edx),%dl
  800df3:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800df5:	8b 45 10             	mov    0x10(%ebp),%eax
  800df8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dfb:	89 55 10             	mov    %edx,0x10(%ebp)
  800dfe:	85 c0                	test   %eax,%eax
  800e00:	75 dd                	jne    800ddf <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e02:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e05:	c9                   	leave  
  800e06:	c3                   	ret    

00800e07 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e07:	55                   	push   %ebp
  800e08:	89 e5                	mov    %esp,%ebp
  800e0a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e10:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e13:	8b 45 08             	mov    0x8(%ebp),%eax
  800e16:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e19:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e1c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e1f:	73 50                	jae    800e71 <memmove+0x6a>
  800e21:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e24:	8b 45 10             	mov    0x10(%ebp),%eax
  800e27:	01 d0                	add    %edx,%eax
  800e29:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e2c:	76 43                	jbe    800e71 <memmove+0x6a>
		s += n;
  800e2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e31:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e34:	8b 45 10             	mov    0x10(%ebp),%eax
  800e37:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e3a:	eb 10                	jmp    800e4c <memmove+0x45>
			*--d = *--s;
  800e3c:	ff 4d f8             	decl   -0x8(%ebp)
  800e3f:	ff 4d fc             	decl   -0x4(%ebp)
  800e42:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e45:	8a 10                	mov    (%eax),%dl
  800e47:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e4a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e4c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e52:	89 55 10             	mov    %edx,0x10(%ebp)
  800e55:	85 c0                	test   %eax,%eax
  800e57:	75 e3                	jne    800e3c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e59:	eb 23                	jmp    800e7e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e5e:	8d 50 01             	lea    0x1(%eax),%edx
  800e61:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e64:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e67:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e6a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e6d:	8a 12                	mov    (%edx),%dl
  800e6f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e71:	8b 45 10             	mov    0x10(%ebp),%eax
  800e74:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e77:	89 55 10             	mov    %edx,0x10(%ebp)
  800e7a:	85 c0                	test   %eax,%eax
  800e7c:	75 dd                	jne    800e5b <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e7e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e81:	c9                   	leave  
  800e82:	c3                   	ret    

00800e83 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e83:	55                   	push   %ebp
  800e84:	89 e5                	mov    %esp,%ebp
  800e86:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e92:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e95:	eb 2a                	jmp    800ec1 <memcmp+0x3e>
		if (*s1 != *s2)
  800e97:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e9a:	8a 10                	mov    (%eax),%dl
  800e9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9f:	8a 00                	mov    (%eax),%al
  800ea1:	38 c2                	cmp    %al,%dl
  800ea3:	74 16                	je     800ebb <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ea5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea8:	8a 00                	mov    (%eax),%al
  800eaa:	0f b6 d0             	movzbl %al,%edx
  800ead:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb0:	8a 00                	mov    (%eax),%al
  800eb2:	0f b6 c0             	movzbl %al,%eax
  800eb5:	29 c2                	sub    %eax,%edx
  800eb7:	89 d0                	mov    %edx,%eax
  800eb9:	eb 18                	jmp    800ed3 <memcmp+0x50>
		s1++, s2++;
  800ebb:	ff 45 fc             	incl   -0x4(%ebp)
  800ebe:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ec1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ec7:	89 55 10             	mov    %edx,0x10(%ebp)
  800eca:	85 c0                	test   %eax,%eax
  800ecc:	75 c9                	jne    800e97 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ece:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ed3:	c9                   	leave  
  800ed4:	c3                   	ret    

00800ed5 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ed5:	55                   	push   %ebp
  800ed6:	89 e5                	mov    %esp,%ebp
  800ed8:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800edb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ede:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee1:	01 d0                	add    %edx,%eax
  800ee3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ee6:	eb 15                	jmp    800efd <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eeb:	8a 00                	mov    (%eax),%al
  800eed:	0f b6 d0             	movzbl %al,%edx
  800ef0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef3:	0f b6 c0             	movzbl %al,%eax
  800ef6:	39 c2                	cmp    %eax,%edx
  800ef8:	74 0d                	je     800f07 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800efa:	ff 45 08             	incl   0x8(%ebp)
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f03:	72 e3                	jb     800ee8 <memfind+0x13>
  800f05:	eb 01                	jmp    800f08 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f07:	90                   	nop
	return (void *) s;
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f0b:	c9                   	leave  
  800f0c:	c3                   	ret    

00800f0d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f0d:	55                   	push   %ebp
  800f0e:	89 e5                	mov    %esp,%ebp
  800f10:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f13:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f1a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f21:	eb 03                	jmp    800f26 <strtol+0x19>
		s++;
  800f23:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	8a 00                	mov    (%eax),%al
  800f2b:	3c 20                	cmp    $0x20,%al
  800f2d:	74 f4                	je     800f23 <strtol+0x16>
  800f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f32:	8a 00                	mov    (%eax),%al
  800f34:	3c 09                	cmp    $0x9,%al
  800f36:	74 eb                	je     800f23 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	8a 00                	mov    (%eax),%al
  800f3d:	3c 2b                	cmp    $0x2b,%al
  800f3f:	75 05                	jne    800f46 <strtol+0x39>
		s++;
  800f41:	ff 45 08             	incl   0x8(%ebp)
  800f44:	eb 13                	jmp    800f59 <strtol+0x4c>
	else if (*s == '-')
  800f46:	8b 45 08             	mov    0x8(%ebp),%eax
  800f49:	8a 00                	mov    (%eax),%al
  800f4b:	3c 2d                	cmp    $0x2d,%al
  800f4d:	75 0a                	jne    800f59 <strtol+0x4c>
		s++, neg = 1;
  800f4f:	ff 45 08             	incl   0x8(%ebp)
  800f52:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f59:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f5d:	74 06                	je     800f65 <strtol+0x58>
  800f5f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f63:	75 20                	jne    800f85 <strtol+0x78>
  800f65:	8b 45 08             	mov    0x8(%ebp),%eax
  800f68:	8a 00                	mov    (%eax),%al
  800f6a:	3c 30                	cmp    $0x30,%al
  800f6c:	75 17                	jne    800f85 <strtol+0x78>
  800f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f71:	40                   	inc    %eax
  800f72:	8a 00                	mov    (%eax),%al
  800f74:	3c 78                	cmp    $0x78,%al
  800f76:	75 0d                	jne    800f85 <strtol+0x78>
		s += 2, base = 16;
  800f78:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f7c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f83:	eb 28                	jmp    800fad <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f85:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f89:	75 15                	jne    800fa0 <strtol+0x93>
  800f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8e:	8a 00                	mov    (%eax),%al
  800f90:	3c 30                	cmp    $0x30,%al
  800f92:	75 0c                	jne    800fa0 <strtol+0x93>
		s++, base = 8;
  800f94:	ff 45 08             	incl   0x8(%ebp)
  800f97:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f9e:	eb 0d                	jmp    800fad <strtol+0xa0>
	else if (base == 0)
  800fa0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa4:	75 07                	jne    800fad <strtol+0xa0>
		base = 10;
  800fa6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	8a 00                	mov    (%eax),%al
  800fb2:	3c 2f                	cmp    $0x2f,%al
  800fb4:	7e 19                	jle    800fcf <strtol+0xc2>
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	8a 00                	mov    (%eax),%al
  800fbb:	3c 39                	cmp    $0x39,%al
  800fbd:	7f 10                	jg     800fcf <strtol+0xc2>
			dig = *s - '0';
  800fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc2:	8a 00                	mov    (%eax),%al
  800fc4:	0f be c0             	movsbl %al,%eax
  800fc7:	83 e8 30             	sub    $0x30,%eax
  800fca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fcd:	eb 42                	jmp    801011 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd2:	8a 00                	mov    (%eax),%al
  800fd4:	3c 60                	cmp    $0x60,%al
  800fd6:	7e 19                	jle    800ff1 <strtol+0xe4>
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	8a 00                	mov    (%eax),%al
  800fdd:	3c 7a                	cmp    $0x7a,%al
  800fdf:	7f 10                	jg     800ff1 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	8a 00                	mov    (%eax),%al
  800fe6:	0f be c0             	movsbl %al,%eax
  800fe9:	83 e8 57             	sub    $0x57,%eax
  800fec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fef:	eb 20                	jmp    801011 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	8a 00                	mov    (%eax),%al
  800ff6:	3c 40                	cmp    $0x40,%al
  800ff8:	7e 39                	jle    801033 <strtol+0x126>
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	8a 00                	mov    (%eax),%al
  800fff:	3c 5a                	cmp    $0x5a,%al
  801001:	7f 30                	jg     801033 <strtol+0x126>
			dig = *s - 'A' + 10;
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
  801006:	8a 00                	mov    (%eax),%al
  801008:	0f be c0             	movsbl %al,%eax
  80100b:	83 e8 37             	sub    $0x37,%eax
  80100e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801011:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801014:	3b 45 10             	cmp    0x10(%ebp),%eax
  801017:	7d 19                	jge    801032 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801019:	ff 45 08             	incl   0x8(%ebp)
  80101c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801023:	89 c2                	mov    %eax,%edx
  801025:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801028:	01 d0                	add    %edx,%eax
  80102a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80102d:	e9 7b ff ff ff       	jmp    800fad <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801032:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801033:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801037:	74 08                	je     801041 <strtol+0x134>
		*endptr = (char *) s;
  801039:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103c:	8b 55 08             	mov    0x8(%ebp),%edx
  80103f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801041:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801045:	74 07                	je     80104e <strtol+0x141>
  801047:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80104a:	f7 d8                	neg    %eax
  80104c:	eb 03                	jmp    801051 <strtol+0x144>
  80104e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801051:	c9                   	leave  
  801052:	c3                   	ret    

00801053 <ltostr>:

void
ltostr(long value, char *str)
{
  801053:	55                   	push   %ebp
  801054:	89 e5                	mov    %esp,%ebp
  801056:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801059:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801060:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801067:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80106b:	79 13                	jns    801080 <ltostr+0x2d>
	{
		neg = 1;
  80106d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801074:	8b 45 0c             	mov    0xc(%ebp),%eax
  801077:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80107a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80107d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801080:	8b 45 08             	mov    0x8(%ebp),%eax
  801083:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801088:	99                   	cltd   
  801089:	f7 f9                	idiv   %ecx
  80108b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80108e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801091:	8d 50 01             	lea    0x1(%eax),%edx
  801094:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801097:	89 c2                	mov    %eax,%edx
  801099:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109c:	01 d0                	add    %edx,%eax
  80109e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010a1:	83 c2 30             	add    $0x30,%edx
  8010a4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010a9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010ae:	f7 e9                	imul   %ecx
  8010b0:	c1 fa 02             	sar    $0x2,%edx
  8010b3:	89 c8                	mov    %ecx,%eax
  8010b5:	c1 f8 1f             	sar    $0x1f,%eax
  8010b8:	29 c2                	sub    %eax,%edx
  8010ba:	89 d0                	mov    %edx,%eax
  8010bc:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010c2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010c7:	f7 e9                	imul   %ecx
  8010c9:	c1 fa 02             	sar    $0x2,%edx
  8010cc:	89 c8                	mov    %ecx,%eax
  8010ce:	c1 f8 1f             	sar    $0x1f,%eax
  8010d1:	29 c2                	sub    %eax,%edx
  8010d3:	89 d0                	mov    %edx,%eax
  8010d5:	c1 e0 02             	shl    $0x2,%eax
  8010d8:	01 d0                	add    %edx,%eax
  8010da:	01 c0                	add    %eax,%eax
  8010dc:	29 c1                	sub    %eax,%ecx
  8010de:	89 ca                	mov    %ecx,%edx
  8010e0:	85 d2                	test   %edx,%edx
  8010e2:	75 9c                	jne    801080 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ee:	48                   	dec    %eax
  8010ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010f6:	74 3d                	je     801135 <ltostr+0xe2>
		start = 1 ;
  8010f8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010ff:	eb 34                	jmp    801135 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801101:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801104:	8b 45 0c             	mov    0xc(%ebp),%eax
  801107:	01 d0                	add    %edx,%eax
  801109:	8a 00                	mov    (%eax),%al
  80110b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80110e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801111:	8b 45 0c             	mov    0xc(%ebp),%eax
  801114:	01 c2                	add    %eax,%edx
  801116:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801119:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111c:	01 c8                	add    %ecx,%eax
  80111e:	8a 00                	mov    (%eax),%al
  801120:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801122:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801125:	8b 45 0c             	mov    0xc(%ebp),%eax
  801128:	01 c2                	add    %eax,%edx
  80112a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80112d:	88 02                	mov    %al,(%edx)
		start++ ;
  80112f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801132:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801135:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801138:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80113b:	7c c4                	jl     801101 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80113d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801140:	8b 45 0c             	mov    0xc(%ebp),%eax
  801143:	01 d0                	add    %edx,%eax
  801145:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801148:	90                   	nop
  801149:	c9                   	leave  
  80114a:	c3                   	ret    

0080114b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80114b:	55                   	push   %ebp
  80114c:	89 e5                	mov    %esp,%ebp
  80114e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801151:	ff 75 08             	pushl  0x8(%ebp)
  801154:	e8 54 fa ff ff       	call   800bad <strlen>
  801159:	83 c4 04             	add    $0x4,%esp
  80115c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80115f:	ff 75 0c             	pushl  0xc(%ebp)
  801162:	e8 46 fa ff ff       	call   800bad <strlen>
  801167:	83 c4 04             	add    $0x4,%esp
  80116a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80116d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801174:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80117b:	eb 17                	jmp    801194 <strcconcat+0x49>
		final[s] = str1[s] ;
  80117d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801180:	8b 45 10             	mov    0x10(%ebp),%eax
  801183:	01 c2                	add    %eax,%edx
  801185:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801188:	8b 45 08             	mov    0x8(%ebp),%eax
  80118b:	01 c8                	add    %ecx,%eax
  80118d:	8a 00                	mov    (%eax),%al
  80118f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801191:	ff 45 fc             	incl   -0x4(%ebp)
  801194:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801197:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80119a:	7c e1                	jl     80117d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80119c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011a3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011aa:	eb 1f                	jmp    8011cb <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011af:	8d 50 01             	lea    0x1(%eax),%edx
  8011b2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011b5:	89 c2                	mov    %eax,%edx
  8011b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ba:	01 c2                	add    %eax,%edx
  8011bc:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c2:	01 c8                	add    %ecx,%eax
  8011c4:	8a 00                	mov    (%eax),%al
  8011c6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011c8:	ff 45 f8             	incl   -0x8(%ebp)
  8011cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ce:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011d1:	7c d9                	jl     8011ac <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d9:	01 d0                	add    %edx,%eax
  8011db:	c6 00 00             	movb   $0x0,(%eax)
}
  8011de:	90                   	nop
  8011df:	c9                   	leave  
  8011e0:	c3                   	ret    

008011e1 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011e1:	55                   	push   %ebp
  8011e2:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f0:	8b 00                	mov    (%eax),%eax
  8011f2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fc:	01 d0                	add    %edx,%eax
  8011fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801204:	eb 0c                	jmp    801212 <strsplit+0x31>
			*string++ = 0;
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	8d 50 01             	lea    0x1(%eax),%edx
  80120c:	89 55 08             	mov    %edx,0x8(%ebp)
  80120f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801212:	8b 45 08             	mov    0x8(%ebp),%eax
  801215:	8a 00                	mov    (%eax),%al
  801217:	84 c0                	test   %al,%al
  801219:	74 18                	je     801233 <strsplit+0x52>
  80121b:	8b 45 08             	mov    0x8(%ebp),%eax
  80121e:	8a 00                	mov    (%eax),%al
  801220:	0f be c0             	movsbl %al,%eax
  801223:	50                   	push   %eax
  801224:	ff 75 0c             	pushl  0xc(%ebp)
  801227:	e8 13 fb ff ff       	call   800d3f <strchr>
  80122c:	83 c4 08             	add    $0x8,%esp
  80122f:	85 c0                	test   %eax,%eax
  801231:	75 d3                	jne    801206 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801233:	8b 45 08             	mov    0x8(%ebp),%eax
  801236:	8a 00                	mov    (%eax),%al
  801238:	84 c0                	test   %al,%al
  80123a:	74 5a                	je     801296 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80123c:	8b 45 14             	mov    0x14(%ebp),%eax
  80123f:	8b 00                	mov    (%eax),%eax
  801241:	83 f8 0f             	cmp    $0xf,%eax
  801244:	75 07                	jne    80124d <strsplit+0x6c>
		{
			return 0;
  801246:	b8 00 00 00 00       	mov    $0x0,%eax
  80124b:	eb 66                	jmp    8012b3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80124d:	8b 45 14             	mov    0x14(%ebp),%eax
  801250:	8b 00                	mov    (%eax),%eax
  801252:	8d 48 01             	lea    0x1(%eax),%ecx
  801255:	8b 55 14             	mov    0x14(%ebp),%edx
  801258:	89 0a                	mov    %ecx,(%edx)
  80125a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801261:	8b 45 10             	mov    0x10(%ebp),%eax
  801264:	01 c2                	add    %eax,%edx
  801266:	8b 45 08             	mov    0x8(%ebp),%eax
  801269:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80126b:	eb 03                	jmp    801270 <strsplit+0x8f>
			string++;
  80126d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801270:	8b 45 08             	mov    0x8(%ebp),%eax
  801273:	8a 00                	mov    (%eax),%al
  801275:	84 c0                	test   %al,%al
  801277:	74 8b                	je     801204 <strsplit+0x23>
  801279:	8b 45 08             	mov    0x8(%ebp),%eax
  80127c:	8a 00                	mov    (%eax),%al
  80127e:	0f be c0             	movsbl %al,%eax
  801281:	50                   	push   %eax
  801282:	ff 75 0c             	pushl  0xc(%ebp)
  801285:	e8 b5 fa ff ff       	call   800d3f <strchr>
  80128a:	83 c4 08             	add    $0x8,%esp
  80128d:	85 c0                	test   %eax,%eax
  80128f:	74 dc                	je     80126d <strsplit+0x8c>
			string++;
	}
  801291:	e9 6e ff ff ff       	jmp    801204 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801296:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801297:	8b 45 14             	mov    0x14(%ebp),%eax
  80129a:	8b 00                	mov    (%eax),%eax
  80129c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a6:	01 d0                	add    %edx,%eax
  8012a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012ae:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012b3:	c9                   	leave  
  8012b4:	c3                   	ret    

008012b5 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012b5:	55                   	push   %ebp
  8012b6:	89 e5                	mov    %esp,%ebp
  8012b8:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012bb:	a1 04 40 80 00       	mov    0x804004,%eax
  8012c0:	85 c0                	test   %eax,%eax
  8012c2:	74 1f                	je     8012e3 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012c4:	e8 1d 00 00 00       	call   8012e6 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8012c9:	83 ec 0c             	sub    $0xc,%esp
  8012cc:	68 90 39 80 00       	push   $0x803990
  8012d1:	e8 55 f2 ff ff       	call   80052b <cprintf>
  8012d6:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012d9:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8012e0:	00 00 00 
	}
}
  8012e3:	90                   	nop
  8012e4:	c9                   	leave  
  8012e5:	c3                   	ret    

008012e6 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8012e6:	55                   	push   %ebp
  8012e7:	89 e5                	mov    %esp,%ebp
  8012e9:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  8012ec:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8012f3:	00 00 00 
  8012f6:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  8012fd:	00 00 00 
  801300:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801307:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  80130a:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801311:	00 00 00 
  801314:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80131b:	00 00 00 
  80131e:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801325:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  801328:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80132f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801332:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801337:	2d 00 10 00 00       	sub    $0x1000,%eax
  80133c:	a3 50 40 80 00       	mov    %eax,0x804050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801341:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801348:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  80134b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801352:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801355:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  80135a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80135d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801360:	ba 00 00 00 00       	mov    $0x0,%edx
  801365:	f7 75 f0             	divl   -0x10(%ebp)
  801368:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80136b:	29 d0                	sub    %edx,%eax
  80136d:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  801370:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801377:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80137a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80137f:	2d 00 10 00 00       	sub    $0x1000,%eax
  801384:	83 ec 04             	sub    $0x4,%esp
  801387:	6a 06                	push   $0x6
  801389:	ff 75 e8             	pushl  -0x18(%ebp)
  80138c:	50                   	push   %eax
  80138d:	e8 d4 05 00 00       	call   801966 <sys_allocate_chunk>
  801392:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801395:	a1 20 41 80 00       	mov    0x804120,%eax
  80139a:	83 ec 0c             	sub    $0xc,%esp
  80139d:	50                   	push   %eax
  80139e:	e8 49 0c 00 00       	call   801fec <initialize_MemBlocksList>
  8013a3:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  8013a6:	a1 48 41 80 00       	mov    0x804148,%eax
  8013ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  8013ae:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013b2:	75 14                	jne    8013c8 <initialize_dyn_block_system+0xe2>
  8013b4:	83 ec 04             	sub    $0x4,%esp
  8013b7:	68 b5 39 80 00       	push   $0x8039b5
  8013bc:	6a 39                	push   $0x39
  8013be:	68 d3 39 80 00       	push   $0x8039d3
  8013c3:	e8 af ee ff ff       	call   800277 <_panic>
  8013c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013cb:	8b 00                	mov    (%eax),%eax
  8013cd:	85 c0                	test   %eax,%eax
  8013cf:	74 10                	je     8013e1 <initialize_dyn_block_system+0xfb>
  8013d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013d4:	8b 00                	mov    (%eax),%eax
  8013d6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8013d9:	8b 52 04             	mov    0x4(%edx),%edx
  8013dc:	89 50 04             	mov    %edx,0x4(%eax)
  8013df:	eb 0b                	jmp    8013ec <initialize_dyn_block_system+0x106>
  8013e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013e4:	8b 40 04             	mov    0x4(%eax),%eax
  8013e7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8013ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013ef:	8b 40 04             	mov    0x4(%eax),%eax
  8013f2:	85 c0                	test   %eax,%eax
  8013f4:	74 0f                	je     801405 <initialize_dyn_block_system+0x11f>
  8013f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013f9:	8b 40 04             	mov    0x4(%eax),%eax
  8013fc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8013ff:	8b 12                	mov    (%edx),%edx
  801401:	89 10                	mov    %edx,(%eax)
  801403:	eb 0a                	jmp    80140f <initialize_dyn_block_system+0x129>
  801405:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801408:	8b 00                	mov    (%eax),%eax
  80140a:	a3 48 41 80 00       	mov    %eax,0x804148
  80140f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801412:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801418:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80141b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801422:	a1 54 41 80 00       	mov    0x804154,%eax
  801427:	48                   	dec    %eax
  801428:	a3 54 41 80 00       	mov    %eax,0x804154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  80142d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801430:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  801437:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80143a:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  801441:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801445:	75 14                	jne    80145b <initialize_dyn_block_system+0x175>
  801447:	83 ec 04             	sub    $0x4,%esp
  80144a:	68 e0 39 80 00       	push   $0x8039e0
  80144f:	6a 3f                	push   $0x3f
  801451:	68 d3 39 80 00       	push   $0x8039d3
  801456:	e8 1c ee ff ff       	call   800277 <_panic>
  80145b:	8b 15 38 41 80 00    	mov    0x804138,%edx
  801461:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801464:	89 10                	mov    %edx,(%eax)
  801466:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801469:	8b 00                	mov    (%eax),%eax
  80146b:	85 c0                	test   %eax,%eax
  80146d:	74 0d                	je     80147c <initialize_dyn_block_system+0x196>
  80146f:	a1 38 41 80 00       	mov    0x804138,%eax
  801474:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801477:	89 50 04             	mov    %edx,0x4(%eax)
  80147a:	eb 08                	jmp    801484 <initialize_dyn_block_system+0x19e>
  80147c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80147f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  801484:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801487:	a3 38 41 80 00       	mov    %eax,0x804138
  80148c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80148f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801496:	a1 44 41 80 00       	mov    0x804144,%eax
  80149b:	40                   	inc    %eax
  80149c:	a3 44 41 80 00       	mov    %eax,0x804144

}
  8014a1:	90                   	nop
  8014a2:	c9                   	leave  
  8014a3:	c3                   	ret    

008014a4 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8014a4:	55                   	push   %ebp
  8014a5:	89 e5                	mov    %esp,%ebp
  8014a7:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014aa:	e8 06 fe ff ff       	call   8012b5 <InitializeUHeap>
	if (size == 0) return NULL ;
  8014af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014b3:	75 07                	jne    8014bc <malloc+0x18>
  8014b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ba:	eb 7d                	jmp    801539 <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  8014bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8014c3:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8014ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8014cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d0:	01 d0                	add    %edx,%eax
  8014d2:	48                   	dec    %eax
  8014d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8014d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8014de:	f7 75 f0             	divl   -0x10(%ebp)
  8014e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014e4:	29 d0                	sub    %edx,%eax
  8014e6:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  8014e9:	e8 46 08 00 00       	call   801d34 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014ee:	83 f8 01             	cmp    $0x1,%eax
  8014f1:	75 07                	jne    8014fa <malloc+0x56>
  8014f3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  8014fa:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  8014fe:	75 34                	jne    801534 <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  801500:	83 ec 0c             	sub    $0xc,%esp
  801503:	ff 75 e8             	pushl  -0x18(%ebp)
  801506:	e8 73 0e 00 00       	call   80237e <alloc_block_FF>
  80150b:	83 c4 10             	add    $0x10,%esp
  80150e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  801511:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801515:	74 16                	je     80152d <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  801517:	83 ec 0c             	sub    $0xc,%esp
  80151a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80151d:	e8 ff 0b 00 00       	call   802121 <insert_sorted_allocList>
  801522:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  801525:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801528:	8b 40 08             	mov    0x8(%eax),%eax
  80152b:	eb 0c                	jmp    801539 <malloc+0x95>
	             }
	             else
	             	return NULL;
  80152d:	b8 00 00 00 00       	mov    $0x0,%eax
  801532:	eb 05                	jmp    801539 <malloc+0x95>
	      	  }
	          else
	               return NULL;
  801534:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  801539:	c9                   	leave  
  80153a:	c3                   	ret    

0080153b <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80153b:	55                   	push   %ebp
  80153c:	89 e5                	mov    %esp,%ebp
  80153e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  801541:	8b 45 08             	mov    0x8(%ebp),%eax
  801544:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  801547:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80154a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80154d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801550:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801555:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  801558:	83 ec 08             	sub    $0x8,%esp
  80155b:	ff 75 f4             	pushl  -0xc(%ebp)
  80155e:	68 40 40 80 00       	push   $0x804040
  801563:	e8 61 0b 00 00       	call   8020c9 <find_block>
  801568:	83 c4 10             	add    $0x10,%esp
  80156b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  80156e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801572:	0f 84 a5 00 00 00    	je     80161d <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  801578:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80157b:	8b 40 0c             	mov    0xc(%eax),%eax
  80157e:	83 ec 08             	sub    $0x8,%esp
  801581:	50                   	push   %eax
  801582:	ff 75 f4             	pushl  -0xc(%ebp)
  801585:	e8 a4 03 00 00       	call   80192e <sys_free_user_mem>
  80158a:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  80158d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801591:	75 17                	jne    8015aa <free+0x6f>
  801593:	83 ec 04             	sub    $0x4,%esp
  801596:	68 b5 39 80 00       	push   $0x8039b5
  80159b:	68 87 00 00 00       	push   $0x87
  8015a0:	68 d3 39 80 00       	push   $0x8039d3
  8015a5:	e8 cd ec ff ff       	call   800277 <_panic>
  8015aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ad:	8b 00                	mov    (%eax),%eax
  8015af:	85 c0                	test   %eax,%eax
  8015b1:	74 10                	je     8015c3 <free+0x88>
  8015b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015b6:	8b 00                	mov    (%eax),%eax
  8015b8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015bb:	8b 52 04             	mov    0x4(%edx),%edx
  8015be:	89 50 04             	mov    %edx,0x4(%eax)
  8015c1:	eb 0b                	jmp    8015ce <free+0x93>
  8015c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015c6:	8b 40 04             	mov    0x4(%eax),%eax
  8015c9:	a3 44 40 80 00       	mov    %eax,0x804044
  8015ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015d1:	8b 40 04             	mov    0x4(%eax),%eax
  8015d4:	85 c0                	test   %eax,%eax
  8015d6:	74 0f                	je     8015e7 <free+0xac>
  8015d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015db:	8b 40 04             	mov    0x4(%eax),%eax
  8015de:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015e1:	8b 12                	mov    (%edx),%edx
  8015e3:	89 10                	mov    %edx,(%eax)
  8015e5:	eb 0a                	jmp    8015f1 <free+0xb6>
  8015e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ea:	8b 00                	mov    (%eax),%eax
  8015ec:	a3 40 40 80 00       	mov    %eax,0x804040
  8015f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801604:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801609:	48                   	dec    %eax
  80160a:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(theBlock);
  80160f:	83 ec 0c             	sub    $0xc,%esp
  801612:	ff 75 ec             	pushl  -0x14(%ebp)
  801615:	e8 37 12 00 00       	call   802851 <insert_sorted_with_merge_freeList>
  80161a:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  80161d:	90                   	nop
  80161e:	c9                   	leave  
  80161f:	c3                   	ret    

00801620 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801620:	55                   	push   %ebp
  801621:	89 e5                	mov    %esp,%ebp
  801623:	83 ec 38             	sub    $0x38,%esp
  801626:	8b 45 10             	mov    0x10(%ebp),%eax
  801629:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80162c:	e8 84 fc ff ff       	call   8012b5 <InitializeUHeap>
	if (size == 0) return NULL ;
  801631:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801635:	75 07                	jne    80163e <smalloc+0x1e>
  801637:	b8 00 00 00 00       	mov    $0x0,%eax
  80163c:	eb 7e                	jmp    8016bc <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  80163e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801645:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80164c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80164f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801652:	01 d0                	add    %edx,%eax
  801654:	48                   	dec    %eax
  801655:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801658:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80165b:	ba 00 00 00 00       	mov    $0x0,%edx
  801660:	f7 75 f0             	divl   -0x10(%ebp)
  801663:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801666:	29 d0                	sub    %edx,%eax
  801668:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  80166b:	e8 c4 06 00 00       	call   801d34 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801670:	83 f8 01             	cmp    $0x1,%eax
  801673:	75 42                	jne    8016b7 <smalloc+0x97>

		  va = malloc(newsize) ;
  801675:	83 ec 0c             	sub    $0xc,%esp
  801678:	ff 75 e8             	pushl  -0x18(%ebp)
  80167b:	e8 24 fe ff ff       	call   8014a4 <malloc>
  801680:	83 c4 10             	add    $0x10,%esp
  801683:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  801686:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80168a:	74 24                	je     8016b0 <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  80168c:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801690:	ff 75 e4             	pushl  -0x1c(%ebp)
  801693:	50                   	push   %eax
  801694:	ff 75 e8             	pushl  -0x18(%ebp)
  801697:	ff 75 08             	pushl  0x8(%ebp)
  80169a:	e8 1a 04 00 00       	call   801ab9 <sys_createSharedObject>
  80169f:	83 c4 10             	add    $0x10,%esp
  8016a2:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  8016a5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8016a9:	78 0c                	js     8016b7 <smalloc+0x97>
					  return va ;
  8016ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016ae:	eb 0c                	jmp    8016bc <smalloc+0x9c>
				 }
				 else
					return NULL;
  8016b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b5:	eb 05                	jmp    8016bc <smalloc+0x9c>
	  }
		  return NULL ;
  8016b7:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016bc:	c9                   	leave  
  8016bd:	c3                   	ret    

008016be <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
  8016c1:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016c4:	e8 ec fb ff ff       	call   8012b5 <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  8016c9:	83 ec 08             	sub    $0x8,%esp
  8016cc:	ff 75 0c             	pushl  0xc(%ebp)
  8016cf:	ff 75 08             	pushl  0x8(%ebp)
  8016d2:	e8 0c 04 00 00       	call   801ae3 <sys_getSizeOfSharedObject>
  8016d7:	83 c4 10             	add    $0x10,%esp
  8016da:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  8016dd:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8016e1:	75 07                	jne    8016ea <sget+0x2c>
  8016e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e8:	eb 75                	jmp    80175f <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8016ea:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8016f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f7:	01 d0                	add    %edx,%eax
  8016f9:	48                   	dec    %eax
  8016fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801700:	ba 00 00 00 00       	mov    $0x0,%edx
  801705:	f7 75 f0             	divl   -0x10(%ebp)
  801708:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80170b:	29 d0                	sub    %edx,%eax
  80170d:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  801710:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801717:	e8 18 06 00 00       	call   801d34 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80171c:	83 f8 01             	cmp    $0x1,%eax
  80171f:	75 39                	jne    80175a <sget+0x9c>

		  va = malloc(newsize) ;
  801721:	83 ec 0c             	sub    $0xc,%esp
  801724:	ff 75 e8             	pushl  -0x18(%ebp)
  801727:	e8 78 fd ff ff       	call   8014a4 <malloc>
  80172c:	83 c4 10             	add    $0x10,%esp
  80172f:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  801732:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801736:	74 22                	je     80175a <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  801738:	83 ec 04             	sub    $0x4,%esp
  80173b:	ff 75 e0             	pushl  -0x20(%ebp)
  80173e:	ff 75 0c             	pushl  0xc(%ebp)
  801741:	ff 75 08             	pushl  0x8(%ebp)
  801744:	e8 b7 03 00 00       	call   801b00 <sys_getSharedObject>
  801749:	83 c4 10             	add    $0x10,%esp
  80174c:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  80174f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801753:	78 05                	js     80175a <sget+0x9c>
					  return va;
  801755:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801758:	eb 05                	jmp    80175f <sget+0xa1>
				  }
			  }
     }
         return NULL;
  80175a:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  80175f:	c9                   	leave  
  801760:	c3                   	ret    

00801761 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801761:	55                   	push   %ebp
  801762:	89 e5                	mov    %esp,%ebp
  801764:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801767:	e8 49 fb ff ff       	call   8012b5 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80176c:	83 ec 04             	sub    $0x4,%esp
  80176f:	68 04 3a 80 00       	push   $0x803a04
  801774:	68 1e 01 00 00       	push   $0x11e
  801779:	68 d3 39 80 00       	push   $0x8039d3
  80177e:	e8 f4 ea ff ff       	call   800277 <_panic>

00801783 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801783:	55                   	push   %ebp
  801784:	89 e5                	mov    %esp,%ebp
  801786:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801789:	83 ec 04             	sub    $0x4,%esp
  80178c:	68 2c 3a 80 00       	push   $0x803a2c
  801791:	68 32 01 00 00       	push   $0x132
  801796:	68 d3 39 80 00       	push   $0x8039d3
  80179b:	e8 d7 ea ff ff       	call   800277 <_panic>

008017a0 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
  8017a3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017a6:	83 ec 04             	sub    $0x4,%esp
  8017a9:	68 50 3a 80 00       	push   $0x803a50
  8017ae:	68 3d 01 00 00       	push   $0x13d
  8017b3:	68 d3 39 80 00       	push   $0x8039d3
  8017b8:	e8 ba ea ff ff       	call   800277 <_panic>

008017bd <shrink>:

}
void shrink(uint32 newSize)
{
  8017bd:	55                   	push   %ebp
  8017be:	89 e5                	mov    %esp,%ebp
  8017c0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017c3:	83 ec 04             	sub    $0x4,%esp
  8017c6:	68 50 3a 80 00       	push   $0x803a50
  8017cb:	68 42 01 00 00       	push   $0x142
  8017d0:	68 d3 39 80 00       	push   $0x8039d3
  8017d5:	e8 9d ea ff ff       	call   800277 <_panic>

008017da <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017da:	55                   	push   %ebp
  8017db:	89 e5                	mov    %esp,%ebp
  8017dd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017e0:	83 ec 04             	sub    $0x4,%esp
  8017e3:	68 50 3a 80 00       	push   $0x803a50
  8017e8:	68 47 01 00 00       	push   $0x147
  8017ed:	68 d3 39 80 00       	push   $0x8039d3
  8017f2:	e8 80 ea ff ff       	call   800277 <_panic>

008017f7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017f7:	55                   	push   %ebp
  8017f8:	89 e5                	mov    %esp,%ebp
  8017fa:	57                   	push   %edi
  8017fb:	56                   	push   %esi
  8017fc:	53                   	push   %ebx
  8017fd:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801800:	8b 45 08             	mov    0x8(%ebp),%eax
  801803:	8b 55 0c             	mov    0xc(%ebp),%edx
  801806:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801809:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80180c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80180f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801812:	cd 30                	int    $0x30
  801814:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801817:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80181a:	83 c4 10             	add    $0x10,%esp
  80181d:	5b                   	pop    %ebx
  80181e:	5e                   	pop    %esi
  80181f:	5f                   	pop    %edi
  801820:	5d                   	pop    %ebp
  801821:	c3                   	ret    

00801822 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801822:	55                   	push   %ebp
  801823:	89 e5                	mov    %esp,%ebp
  801825:	83 ec 04             	sub    $0x4,%esp
  801828:	8b 45 10             	mov    0x10(%ebp),%eax
  80182b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80182e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801832:	8b 45 08             	mov    0x8(%ebp),%eax
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	52                   	push   %edx
  80183a:	ff 75 0c             	pushl  0xc(%ebp)
  80183d:	50                   	push   %eax
  80183e:	6a 00                	push   $0x0
  801840:	e8 b2 ff ff ff       	call   8017f7 <syscall>
  801845:	83 c4 18             	add    $0x18,%esp
}
  801848:	90                   	nop
  801849:	c9                   	leave  
  80184a:	c3                   	ret    

0080184b <sys_cgetc>:

int
sys_cgetc(void)
{
  80184b:	55                   	push   %ebp
  80184c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	6a 01                	push   $0x1
  80185a:	e8 98 ff ff ff       	call   8017f7 <syscall>
  80185f:	83 c4 18             	add    $0x18,%esp
}
  801862:	c9                   	leave  
  801863:	c3                   	ret    

00801864 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801864:	55                   	push   %ebp
  801865:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801867:	8b 55 0c             	mov    0xc(%ebp),%edx
  80186a:	8b 45 08             	mov    0x8(%ebp),%eax
  80186d:	6a 00                	push   $0x0
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	52                   	push   %edx
  801874:	50                   	push   %eax
  801875:	6a 05                	push   $0x5
  801877:	e8 7b ff ff ff       	call   8017f7 <syscall>
  80187c:	83 c4 18             	add    $0x18,%esp
}
  80187f:	c9                   	leave  
  801880:	c3                   	ret    

00801881 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801881:	55                   	push   %ebp
  801882:	89 e5                	mov    %esp,%ebp
  801884:	56                   	push   %esi
  801885:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801886:	8b 75 18             	mov    0x18(%ebp),%esi
  801889:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80188c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80188f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801892:	8b 45 08             	mov    0x8(%ebp),%eax
  801895:	56                   	push   %esi
  801896:	53                   	push   %ebx
  801897:	51                   	push   %ecx
  801898:	52                   	push   %edx
  801899:	50                   	push   %eax
  80189a:	6a 06                	push   $0x6
  80189c:	e8 56 ff ff ff       	call   8017f7 <syscall>
  8018a1:	83 c4 18             	add    $0x18,%esp
}
  8018a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018a7:	5b                   	pop    %ebx
  8018a8:	5e                   	pop    %esi
  8018a9:	5d                   	pop    %ebp
  8018aa:	c3                   	ret    

008018ab <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	52                   	push   %edx
  8018bb:	50                   	push   %eax
  8018bc:	6a 07                	push   $0x7
  8018be:	e8 34 ff ff ff       	call   8017f7 <syscall>
  8018c3:	83 c4 18             	add    $0x18,%esp
}
  8018c6:	c9                   	leave  
  8018c7:	c3                   	ret    

008018c8 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018c8:	55                   	push   %ebp
  8018c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	ff 75 0c             	pushl  0xc(%ebp)
  8018d4:	ff 75 08             	pushl  0x8(%ebp)
  8018d7:	6a 08                	push   $0x8
  8018d9:	e8 19 ff ff ff       	call   8017f7 <syscall>
  8018de:	83 c4 18             	add    $0x18,%esp
}
  8018e1:	c9                   	leave  
  8018e2:	c3                   	ret    

008018e3 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 09                	push   $0x9
  8018f2:	e8 00 ff ff ff       	call   8017f7 <syscall>
  8018f7:	83 c4 18             	add    $0x18,%esp
}
  8018fa:	c9                   	leave  
  8018fb:	c3                   	ret    

008018fc <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018fc:	55                   	push   %ebp
  8018fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 0a                	push   $0xa
  80190b:	e8 e7 fe ff ff       	call   8017f7 <syscall>
  801910:	83 c4 18             	add    $0x18,%esp
}
  801913:	c9                   	leave  
  801914:	c3                   	ret    

00801915 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801915:	55                   	push   %ebp
  801916:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 0b                	push   $0xb
  801924:	e8 ce fe ff ff       	call   8017f7 <syscall>
  801929:	83 c4 18             	add    $0x18,%esp
}
  80192c:	c9                   	leave  
  80192d:	c3                   	ret    

0080192e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	ff 75 0c             	pushl  0xc(%ebp)
  80193a:	ff 75 08             	pushl  0x8(%ebp)
  80193d:	6a 0f                	push   $0xf
  80193f:	e8 b3 fe ff ff       	call   8017f7 <syscall>
  801944:	83 c4 18             	add    $0x18,%esp
	return;
  801947:	90                   	nop
}
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	ff 75 0c             	pushl  0xc(%ebp)
  801956:	ff 75 08             	pushl  0x8(%ebp)
  801959:	6a 10                	push   $0x10
  80195b:	e8 97 fe ff ff       	call   8017f7 <syscall>
  801960:	83 c4 18             	add    $0x18,%esp
	return ;
  801963:	90                   	nop
}
  801964:	c9                   	leave  
  801965:	c3                   	ret    

00801966 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801966:	55                   	push   %ebp
  801967:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	ff 75 10             	pushl  0x10(%ebp)
  801970:	ff 75 0c             	pushl  0xc(%ebp)
  801973:	ff 75 08             	pushl  0x8(%ebp)
  801976:	6a 11                	push   $0x11
  801978:	e8 7a fe ff ff       	call   8017f7 <syscall>
  80197d:	83 c4 18             	add    $0x18,%esp
	return ;
  801980:	90                   	nop
}
  801981:	c9                   	leave  
  801982:	c3                   	ret    

00801983 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 0c                	push   $0xc
  801992:	e8 60 fe ff ff       	call   8017f7 <syscall>
  801997:	83 c4 18             	add    $0x18,%esp
}
  80199a:	c9                   	leave  
  80199b:	c3                   	ret    

0080199c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	ff 75 08             	pushl  0x8(%ebp)
  8019aa:	6a 0d                	push   $0xd
  8019ac:	e8 46 fe ff ff       	call   8017f7 <syscall>
  8019b1:	83 c4 18             	add    $0x18,%esp
}
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    

008019b6 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 0e                	push   $0xe
  8019c5:	e8 2d fe ff ff       	call   8017f7 <syscall>
  8019ca:	83 c4 18             	add    $0x18,%esp
}
  8019cd:	90                   	nop
  8019ce:	c9                   	leave  
  8019cf:	c3                   	ret    

008019d0 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 13                	push   $0x13
  8019df:	e8 13 fe ff ff       	call   8017f7 <syscall>
  8019e4:	83 c4 18             	add    $0x18,%esp
}
  8019e7:	90                   	nop
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    

008019ea <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 14                	push   $0x14
  8019f9:	e8 f9 fd ff ff       	call   8017f7 <syscall>
  8019fe:	83 c4 18             	add    $0x18,%esp
}
  801a01:	90                   	nop
  801a02:	c9                   	leave  
  801a03:	c3                   	ret    

00801a04 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a04:	55                   	push   %ebp
  801a05:	89 e5                	mov    %esp,%ebp
  801a07:	83 ec 04             	sub    $0x4,%esp
  801a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a10:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	50                   	push   %eax
  801a1d:	6a 15                	push   $0x15
  801a1f:	e8 d3 fd ff ff       	call   8017f7 <syscall>
  801a24:	83 c4 18             	add    $0x18,%esp
}
  801a27:	90                   	nop
  801a28:	c9                   	leave  
  801a29:	c3                   	ret    

00801a2a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 16                	push   $0x16
  801a39:	e8 b9 fd ff ff       	call   8017f7 <syscall>
  801a3e:	83 c4 18             	add    $0x18,%esp
}
  801a41:	90                   	nop
  801a42:	c9                   	leave  
  801a43:	c3                   	ret    

00801a44 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a44:	55                   	push   %ebp
  801a45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a47:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	ff 75 0c             	pushl  0xc(%ebp)
  801a53:	50                   	push   %eax
  801a54:	6a 17                	push   $0x17
  801a56:	e8 9c fd ff ff       	call   8017f7 <syscall>
  801a5b:	83 c4 18             	add    $0x18,%esp
}
  801a5e:	c9                   	leave  
  801a5f:	c3                   	ret    

00801a60 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a63:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a66:	8b 45 08             	mov    0x8(%ebp),%eax
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	52                   	push   %edx
  801a70:	50                   	push   %eax
  801a71:	6a 1a                	push   $0x1a
  801a73:	e8 7f fd ff ff       	call   8017f7 <syscall>
  801a78:	83 c4 18             	add    $0x18,%esp
}
  801a7b:	c9                   	leave  
  801a7c:	c3                   	ret    

00801a7d <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a7d:	55                   	push   %ebp
  801a7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a80:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a83:	8b 45 08             	mov    0x8(%ebp),%eax
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	52                   	push   %edx
  801a8d:	50                   	push   %eax
  801a8e:	6a 18                	push   $0x18
  801a90:	e8 62 fd ff ff       	call   8017f7 <syscall>
  801a95:	83 c4 18             	add    $0x18,%esp
}
  801a98:	90                   	nop
  801a99:	c9                   	leave  
  801a9a:	c3                   	ret    

00801a9b <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a9b:	55                   	push   %ebp
  801a9c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	52                   	push   %edx
  801aab:	50                   	push   %eax
  801aac:	6a 19                	push   $0x19
  801aae:	e8 44 fd ff ff       	call   8017f7 <syscall>
  801ab3:	83 c4 18             	add    $0x18,%esp
}
  801ab6:	90                   	nop
  801ab7:	c9                   	leave  
  801ab8:	c3                   	ret    

00801ab9 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ab9:	55                   	push   %ebp
  801aba:	89 e5                	mov    %esp,%ebp
  801abc:	83 ec 04             	sub    $0x4,%esp
  801abf:	8b 45 10             	mov    0x10(%ebp),%eax
  801ac2:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ac5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ac8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801acc:	8b 45 08             	mov    0x8(%ebp),%eax
  801acf:	6a 00                	push   $0x0
  801ad1:	51                   	push   %ecx
  801ad2:	52                   	push   %edx
  801ad3:	ff 75 0c             	pushl  0xc(%ebp)
  801ad6:	50                   	push   %eax
  801ad7:	6a 1b                	push   $0x1b
  801ad9:	e8 19 fd ff ff       	call   8017f7 <syscall>
  801ade:	83 c4 18             	add    $0x18,%esp
}
  801ae1:	c9                   	leave  
  801ae2:	c3                   	ret    

00801ae3 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ae3:	55                   	push   %ebp
  801ae4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ae6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	52                   	push   %edx
  801af3:	50                   	push   %eax
  801af4:	6a 1c                	push   $0x1c
  801af6:	e8 fc fc ff ff       	call   8017f7 <syscall>
  801afb:	83 c4 18             	add    $0x18,%esp
}
  801afe:	c9                   	leave  
  801aff:	c3                   	ret    

00801b00 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b03:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b06:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b09:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	51                   	push   %ecx
  801b11:	52                   	push   %edx
  801b12:	50                   	push   %eax
  801b13:	6a 1d                	push   $0x1d
  801b15:	e8 dd fc ff ff       	call   8017f7 <syscall>
  801b1a:	83 c4 18             	add    $0x18,%esp
}
  801b1d:	c9                   	leave  
  801b1e:	c3                   	ret    

00801b1f <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b22:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b25:	8b 45 08             	mov    0x8(%ebp),%eax
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	52                   	push   %edx
  801b2f:	50                   	push   %eax
  801b30:	6a 1e                	push   $0x1e
  801b32:	e8 c0 fc ff ff       	call   8017f7 <syscall>
  801b37:	83 c4 18             	add    $0x18,%esp
}
  801b3a:	c9                   	leave  
  801b3b:	c3                   	ret    

00801b3c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b3c:	55                   	push   %ebp
  801b3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 1f                	push   $0x1f
  801b4b:	e8 a7 fc ff ff       	call   8017f7 <syscall>
  801b50:	83 c4 18             	add    $0x18,%esp
}
  801b53:	c9                   	leave  
  801b54:	c3                   	ret    

00801b55 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b55:	55                   	push   %ebp
  801b56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b58:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5b:	6a 00                	push   $0x0
  801b5d:	ff 75 14             	pushl  0x14(%ebp)
  801b60:	ff 75 10             	pushl  0x10(%ebp)
  801b63:	ff 75 0c             	pushl  0xc(%ebp)
  801b66:	50                   	push   %eax
  801b67:	6a 20                	push   $0x20
  801b69:	e8 89 fc ff ff       	call   8017f7 <syscall>
  801b6e:	83 c4 18             	add    $0x18,%esp
}
  801b71:	c9                   	leave  
  801b72:	c3                   	ret    

00801b73 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b73:	55                   	push   %ebp
  801b74:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b76:	8b 45 08             	mov    0x8(%ebp),%eax
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	50                   	push   %eax
  801b82:	6a 21                	push   $0x21
  801b84:	e8 6e fc ff ff       	call   8017f7 <syscall>
  801b89:	83 c4 18             	add    $0x18,%esp
}
  801b8c:	90                   	nop
  801b8d:	c9                   	leave  
  801b8e:	c3                   	ret    

00801b8f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b8f:	55                   	push   %ebp
  801b90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b92:	8b 45 08             	mov    0x8(%ebp),%eax
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	50                   	push   %eax
  801b9e:	6a 22                	push   $0x22
  801ba0:	e8 52 fc ff ff       	call   8017f7 <syscall>
  801ba5:	83 c4 18             	add    $0x18,%esp
}
  801ba8:	c9                   	leave  
  801ba9:	c3                   	ret    

00801baa <sys_getenvid>:

int32 sys_getenvid(void)
{
  801baa:	55                   	push   %ebp
  801bab:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 02                	push   $0x2
  801bb9:	e8 39 fc ff ff       	call   8017f7 <syscall>
  801bbe:	83 c4 18             	add    $0x18,%esp
}
  801bc1:	c9                   	leave  
  801bc2:	c3                   	ret    

00801bc3 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 03                	push   $0x3
  801bd2:	e8 20 fc ff ff       	call   8017f7 <syscall>
  801bd7:	83 c4 18             	add    $0x18,%esp
}
  801bda:	c9                   	leave  
  801bdb:	c3                   	ret    

00801bdc <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 04                	push   $0x4
  801beb:	e8 07 fc ff ff       	call   8017f7 <syscall>
  801bf0:	83 c4 18             	add    $0x18,%esp
}
  801bf3:	c9                   	leave  
  801bf4:	c3                   	ret    

00801bf5 <sys_exit_env>:


void sys_exit_env(void)
{
  801bf5:	55                   	push   %ebp
  801bf6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 23                	push   $0x23
  801c04:	e8 ee fb ff ff       	call   8017f7 <syscall>
  801c09:	83 c4 18             	add    $0x18,%esp
}
  801c0c:	90                   	nop
  801c0d:	c9                   	leave  
  801c0e:	c3                   	ret    

00801c0f <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c0f:	55                   	push   %ebp
  801c10:	89 e5                	mov    %esp,%ebp
  801c12:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c15:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c18:	8d 50 04             	lea    0x4(%eax),%edx
  801c1b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	52                   	push   %edx
  801c25:	50                   	push   %eax
  801c26:	6a 24                	push   $0x24
  801c28:	e8 ca fb ff ff       	call   8017f7 <syscall>
  801c2d:	83 c4 18             	add    $0x18,%esp
	return result;
  801c30:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c33:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c36:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c39:	89 01                	mov    %eax,(%ecx)
  801c3b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c41:	c9                   	leave  
  801c42:	c2 04 00             	ret    $0x4

00801c45 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	ff 75 10             	pushl  0x10(%ebp)
  801c4f:	ff 75 0c             	pushl  0xc(%ebp)
  801c52:	ff 75 08             	pushl  0x8(%ebp)
  801c55:	6a 12                	push   $0x12
  801c57:	e8 9b fb ff ff       	call   8017f7 <syscall>
  801c5c:	83 c4 18             	add    $0x18,%esp
	return ;
  801c5f:	90                   	nop
}
  801c60:	c9                   	leave  
  801c61:	c3                   	ret    

00801c62 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c62:	55                   	push   %ebp
  801c63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 25                	push   $0x25
  801c71:	e8 81 fb ff ff       	call   8017f7 <syscall>
  801c76:	83 c4 18             	add    $0x18,%esp
}
  801c79:	c9                   	leave  
  801c7a:	c3                   	ret    

00801c7b <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c7b:	55                   	push   %ebp
  801c7c:	89 e5                	mov    %esp,%ebp
  801c7e:	83 ec 04             	sub    $0x4,%esp
  801c81:	8b 45 08             	mov    0x8(%ebp),%eax
  801c84:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c87:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	50                   	push   %eax
  801c94:	6a 26                	push   $0x26
  801c96:	e8 5c fb ff ff       	call   8017f7 <syscall>
  801c9b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c9e:	90                   	nop
}
  801c9f:	c9                   	leave  
  801ca0:	c3                   	ret    

00801ca1 <rsttst>:
void rsttst()
{
  801ca1:	55                   	push   %ebp
  801ca2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 28                	push   $0x28
  801cb0:	e8 42 fb ff ff       	call   8017f7 <syscall>
  801cb5:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb8:	90                   	nop
}
  801cb9:	c9                   	leave  
  801cba:	c3                   	ret    

00801cbb <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cbb:	55                   	push   %ebp
  801cbc:	89 e5                	mov    %esp,%ebp
  801cbe:	83 ec 04             	sub    $0x4,%esp
  801cc1:	8b 45 14             	mov    0x14(%ebp),%eax
  801cc4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cc7:	8b 55 18             	mov    0x18(%ebp),%edx
  801cca:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cce:	52                   	push   %edx
  801ccf:	50                   	push   %eax
  801cd0:	ff 75 10             	pushl  0x10(%ebp)
  801cd3:	ff 75 0c             	pushl  0xc(%ebp)
  801cd6:	ff 75 08             	pushl  0x8(%ebp)
  801cd9:	6a 27                	push   $0x27
  801cdb:	e8 17 fb ff ff       	call   8017f7 <syscall>
  801ce0:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce3:	90                   	nop
}
  801ce4:	c9                   	leave  
  801ce5:	c3                   	ret    

00801ce6 <chktst>:
void chktst(uint32 n)
{
  801ce6:	55                   	push   %ebp
  801ce7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	ff 75 08             	pushl  0x8(%ebp)
  801cf4:	6a 29                	push   $0x29
  801cf6:	e8 fc fa ff ff       	call   8017f7 <syscall>
  801cfb:	83 c4 18             	add    $0x18,%esp
	return ;
  801cfe:	90                   	nop
}
  801cff:	c9                   	leave  
  801d00:	c3                   	ret    

00801d01 <inctst>:

void inctst()
{
  801d01:	55                   	push   %ebp
  801d02:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 2a                	push   $0x2a
  801d10:	e8 e2 fa ff ff       	call   8017f7 <syscall>
  801d15:	83 c4 18             	add    $0x18,%esp
	return ;
  801d18:	90                   	nop
}
  801d19:	c9                   	leave  
  801d1a:	c3                   	ret    

00801d1b <gettst>:
uint32 gettst()
{
  801d1b:	55                   	push   %ebp
  801d1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 2b                	push   $0x2b
  801d2a:	e8 c8 fa ff ff       	call   8017f7 <syscall>
  801d2f:	83 c4 18             	add    $0x18,%esp
}
  801d32:	c9                   	leave  
  801d33:	c3                   	ret    

00801d34 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d34:	55                   	push   %ebp
  801d35:	89 e5                	mov    %esp,%ebp
  801d37:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 2c                	push   $0x2c
  801d46:	e8 ac fa ff ff       	call   8017f7 <syscall>
  801d4b:	83 c4 18             	add    $0x18,%esp
  801d4e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d51:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d55:	75 07                	jne    801d5e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d57:	b8 01 00 00 00       	mov    $0x1,%eax
  801d5c:	eb 05                	jmp    801d63 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d63:	c9                   	leave  
  801d64:	c3                   	ret    

00801d65 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d65:	55                   	push   %ebp
  801d66:	89 e5                	mov    %esp,%ebp
  801d68:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 2c                	push   $0x2c
  801d77:	e8 7b fa ff ff       	call   8017f7 <syscall>
  801d7c:	83 c4 18             	add    $0x18,%esp
  801d7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d82:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d86:	75 07                	jne    801d8f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d88:	b8 01 00 00 00       	mov    $0x1,%eax
  801d8d:	eb 05                	jmp    801d94 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d94:	c9                   	leave  
  801d95:	c3                   	ret    

00801d96 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d96:	55                   	push   %ebp
  801d97:	89 e5                	mov    %esp,%ebp
  801d99:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 2c                	push   $0x2c
  801da8:	e8 4a fa ff ff       	call   8017f7 <syscall>
  801dad:	83 c4 18             	add    $0x18,%esp
  801db0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801db3:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801db7:	75 07                	jne    801dc0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801db9:	b8 01 00 00 00       	mov    $0x1,%eax
  801dbe:	eb 05                	jmp    801dc5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801dc0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc5:	c9                   	leave  
  801dc6:	c3                   	ret    

00801dc7 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801dc7:	55                   	push   %ebp
  801dc8:	89 e5                	mov    %esp,%ebp
  801dca:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 2c                	push   $0x2c
  801dd9:	e8 19 fa ff ff       	call   8017f7 <syscall>
  801dde:	83 c4 18             	add    $0x18,%esp
  801de1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801de4:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801de8:	75 07                	jne    801df1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801dea:	b8 01 00 00 00       	mov    $0x1,%eax
  801def:	eb 05                	jmp    801df6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801df1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801df6:	c9                   	leave  
  801df7:	c3                   	ret    

00801df8 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801df8:	55                   	push   %ebp
  801df9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	6a 00                	push   $0x0
  801e03:	ff 75 08             	pushl  0x8(%ebp)
  801e06:	6a 2d                	push   $0x2d
  801e08:	e8 ea f9 ff ff       	call   8017f7 <syscall>
  801e0d:	83 c4 18             	add    $0x18,%esp
	return ;
  801e10:	90                   	nop
}
  801e11:	c9                   	leave  
  801e12:	c3                   	ret    

00801e13 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e13:	55                   	push   %ebp
  801e14:	89 e5                	mov    %esp,%ebp
  801e16:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e17:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e1a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e20:	8b 45 08             	mov    0x8(%ebp),%eax
  801e23:	6a 00                	push   $0x0
  801e25:	53                   	push   %ebx
  801e26:	51                   	push   %ecx
  801e27:	52                   	push   %edx
  801e28:	50                   	push   %eax
  801e29:	6a 2e                	push   $0x2e
  801e2b:	e8 c7 f9 ff ff       	call   8017f7 <syscall>
  801e30:	83 c4 18             	add    $0x18,%esp
}
  801e33:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e36:	c9                   	leave  
  801e37:	c3                   	ret    

00801e38 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e38:	55                   	push   %ebp
  801e39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	6a 00                	push   $0x0
  801e47:	52                   	push   %edx
  801e48:	50                   	push   %eax
  801e49:	6a 2f                	push   $0x2f
  801e4b:	e8 a7 f9 ff ff       	call   8017f7 <syscall>
  801e50:	83 c4 18             	add    $0x18,%esp
}
  801e53:	c9                   	leave  
  801e54:	c3                   	ret    

00801e55 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e55:	55                   	push   %ebp
  801e56:	89 e5                	mov    %esp,%ebp
  801e58:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e5b:	83 ec 0c             	sub    $0xc,%esp
  801e5e:	68 60 3a 80 00       	push   $0x803a60
  801e63:	e8 c3 e6 ff ff       	call   80052b <cprintf>
  801e68:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e6b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e72:	83 ec 0c             	sub    $0xc,%esp
  801e75:	68 8c 3a 80 00       	push   $0x803a8c
  801e7a:	e8 ac e6 ff ff       	call   80052b <cprintf>
  801e7f:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e82:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e86:	a1 38 41 80 00       	mov    0x804138,%eax
  801e8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e8e:	eb 56                	jmp    801ee6 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e90:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e94:	74 1c                	je     801eb2 <print_mem_block_lists+0x5d>
  801e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e99:	8b 50 08             	mov    0x8(%eax),%edx
  801e9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e9f:	8b 48 08             	mov    0x8(%eax),%ecx
  801ea2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ea5:	8b 40 0c             	mov    0xc(%eax),%eax
  801ea8:	01 c8                	add    %ecx,%eax
  801eaa:	39 c2                	cmp    %eax,%edx
  801eac:	73 04                	jae    801eb2 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801eae:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb5:	8b 50 08             	mov    0x8(%eax),%edx
  801eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebb:	8b 40 0c             	mov    0xc(%eax),%eax
  801ebe:	01 c2                	add    %eax,%edx
  801ec0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec3:	8b 40 08             	mov    0x8(%eax),%eax
  801ec6:	83 ec 04             	sub    $0x4,%esp
  801ec9:	52                   	push   %edx
  801eca:	50                   	push   %eax
  801ecb:	68 a1 3a 80 00       	push   $0x803aa1
  801ed0:	e8 56 e6 ff ff       	call   80052b <cprintf>
  801ed5:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ed8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801edb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ede:	a1 40 41 80 00       	mov    0x804140,%eax
  801ee3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ee6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eea:	74 07                	je     801ef3 <print_mem_block_lists+0x9e>
  801eec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eef:	8b 00                	mov    (%eax),%eax
  801ef1:	eb 05                	jmp    801ef8 <print_mem_block_lists+0xa3>
  801ef3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef8:	a3 40 41 80 00       	mov    %eax,0x804140
  801efd:	a1 40 41 80 00       	mov    0x804140,%eax
  801f02:	85 c0                	test   %eax,%eax
  801f04:	75 8a                	jne    801e90 <print_mem_block_lists+0x3b>
  801f06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f0a:	75 84                	jne    801e90 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f0c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f10:	75 10                	jne    801f22 <print_mem_block_lists+0xcd>
  801f12:	83 ec 0c             	sub    $0xc,%esp
  801f15:	68 b0 3a 80 00       	push   $0x803ab0
  801f1a:	e8 0c e6 ff ff       	call   80052b <cprintf>
  801f1f:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f22:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f29:	83 ec 0c             	sub    $0xc,%esp
  801f2c:	68 d4 3a 80 00       	push   $0x803ad4
  801f31:	e8 f5 e5 ff ff       	call   80052b <cprintf>
  801f36:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f39:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f3d:	a1 40 40 80 00       	mov    0x804040,%eax
  801f42:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f45:	eb 56                	jmp    801f9d <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f47:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f4b:	74 1c                	je     801f69 <print_mem_block_lists+0x114>
  801f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f50:	8b 50 08             	mov    0x8(%eax),%edx
  801f53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f56:	8b 48 08             	mov    0x8(%eax),%ecx
  801f59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f5c:	8b 40 0c             	mov    0xc(%eax),%eax
  801f5f:	01 c8                	add    %ecx,%eax
  801f61:	39 c2                	cmp    %eax,%edx
  801f63:	73 04                	jae    801f69 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f65:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6c:	8b 50 08             	mov    0x8(%eax),%edx
  801f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f72:	8b 40 0c             	mov    0xc(%eax),%eax
  801f75:	01 c2                	add    %eax,%edx
  801f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7a:	8b 40 08             	mov    0x8(%eax),%eax
  801f7d:	83 ec 04             	sub    $0x4,%esp
  801f80:	52                   	push   %edx
  801f81:	50                   	push   %eax
  801f82:	68 a1 3a 80 00       	push   $0x803aa1
  801f87:	e8 9f e5 ff ff       	call   80052b <cprintf>
  801f8c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f92:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f95:	a1 48 40 80 00       	mov    0x804048,%eax
  801f9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f9d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fa1:	74 07                	je     801faa <print_mem_block_lists+0x155>
  801fa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa6:	8b 00                	mov    (%eax),%eax
  801fa8:	eb 05                	jmp    801faf <print_mem_block_lists+0x15a>
  801faa:	b8 00 00 00 00       	mov    $0x0,%eax
  801faf:	a3 48 40 80 00       	mov    %eax,0x804048
  801fb4:	a1 48 40 80 00       	mov    0x804048,%eax
  801fb9:	85 c0                	test   %eax,%eax
  801fbb:	75 8a                	jne    801f47 <print_mem_block_lists+0xf2>
  801fbd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fc1:	75 84                	jne    801f47 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fc3:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fc7:	75 10                	jne    801fd9 <print_mem_block_lists+0x184>
  801fc9:	83 ec 0c             	sub    $0xc,%esp
  801fcc:	68 ec 3a 80 00       	push   $0x803aec
  801fd1:	e8 55 e5 ff ff       	call   80052b <cprintf>
  801fd6:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801fd9:	83 ec 0c             	sub    $0xc,%esp
  801fdc:	68 60 3a 80 00       	push   $0x803a60
  801fe1:	e8 45 e5 ff ff       	call   80052b <cprintf>
  801fe6:	83 c4 10             	add    $0x10,%esp

}
  801fe9:	90                   	nop
  801fea:	c9                   	leave  
  801feb:	c3                   	ret    

00801fec <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801fec:	55                   	push   %ebp
  801fed:	89 e5                	mov    %esp,%ebp
  801fef:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  801ff2:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801ff9:	00 00 00 
  801ffc:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802003:	00 00 00 
  802006:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  80200d:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802010:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802017:	e9 9e 00 00 00       	jmp    8020ba <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  80201c:	a1 50 40 80 00       	mov    0x804050,%eax
  802021:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802024:	c1 e2 04             	shl    $0x4,%edx
  802027:	01 d0                	add    %edx,%eax
  802029:	85 c0                	test   %eax,%eax
  80202b:	75 14                	jne    802041 <initialize_MemBlocksList+0x55>
  80202d:	83 ec 04             	sub    $0x4,%esp
  802030:	68 14 3b 80 00       	push   $0x803b14
  802035:	6a 47                	push   $0x47
  802037:	68 37 3b 80 00       	push   $0x803b37
  80203c:	e8 36 e2 ff ff       	call   800277 <_panic>
  802041:	a1 50 40 80 00       	mov    0x804050,%eax
  802046:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802049:	c1 e2 04             	shl    $0x4,%edx
  80204c:	01 d0                	add    %edx,%eax
  80204e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802054:	89 10                	mov    %edx,(%eax)
  802056:	8b 00                	mov    (%eax),%eax
  802058:	85 c0                	test   %eax,%eax
  80205a:	74 18                	je     802074 <initialize_MemBlocksList+0x88>
  80205c:	a1 48 41 80 00       	mov    0x804148,%eax
  802061:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802067:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80206a:	c1 e1 04             	shl    $0x4,%ecx
  80206d:	01 ca                	add    %ecx,%edx
  80206f:	89 50 04             	mov    %edx,0x4(%eax)
  802072:	eb 12                	jmp    802086 <initialize_MemBlocksList+0x9a>
  802074:	a1 50 40 80 00       	mov    0x804050,%eax
  802079:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80207c:	c1 e2 04             	shl    $0x4,%edx
  80207f:	01 d0                	add    %edx,%eax
  802081:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802086:	a1 50 40 80 00       	mov    0x804050,%eax
  80208b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80208e:	c1 e2 04             	shl    $0x4,%edx
  802091:	01 d0                	add    %edx,%eax
  802093:	a3 48 41 80 00       	mov    %eax,0x804148
  802098:	a1 50 40 80 00       	mov    0x804050,%eax
  80209d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020a0:	c1 e2 04             	shl    $0x4,%edx
  8020a3:	01 d0                	add    %edx,%eax
  8020a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020ac:	a1 54 41 80 00       	mov    0x804154,%eax
  8020b1:	40                   	inc    %eax
  8020b2:	a3 54 41 80 00       	mov    %eax,0x804154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  8020b7:	ff 45 f4             	incl   -0xc(%ebp)
  8020ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020bd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020c0:	0f 82 56 ff ff ff    	jb     80201c <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  8020c6:	90                   	nop
  8020c7:	c9                   	leave  
  8020c8:	c3                   	ret    

008020c9 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020c9:	55                   	push   %ebp
  8020ca:	89 e5                	mov    %esp,%ebp
  8020cc:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  8020cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d2:	8b 00                	mov    (%eax),%eax
  8020d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020d7:	eb 19                	jmp    8020f2 <find_block+0x29>
	{
		if(element->sva == va){
  8020d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020dc:	8b 40 08             	mov    0x8(%eax),%eax
  8020df:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8020e2:	75 05                	jne    8020e9 <find_block+0x20>
			 		return element;
  8020e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020e7:	eb 36                	jmp    80211f <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  8020e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ec:	8b 40 08             	mov    0x8(%eax),%eax
  8020ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020f6:	74 07                	je     8020ff <find_block+0x36>
  8020f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020fb:	8b 00                	mov    (%eax),%eax
  8020fd:	eb 05                	jmp    802104 <find_block+0x3b>
  8020ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802104:	8b 55 08             	mov    0x8(%ebp),%edx
  802107:	89 42 08             	mov    %eax,0x8(%edx)
  80210a:	8b 45 08             	mov    0x8(%ebp),%eax
  80210d:	8b 40 08             	mov    0x8(%eax),%eax
  802110:	85 c0                	test   %eax,%eax
  802112:	75 c5                	jne    8020d9 <find_block+0x10>
  802114:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802118:	75 bf                	jne    8020d9 <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  80211a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80211f:	c9                   	leave  
  802120:	c3                   	ret    

00802121 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802121:	55                   	push   %ebp
  802122:	89 e5                	mov    %esp,%ebp
  802124:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  802127:	a1 44 40 80 00       	mov    0x804044,%eax
  80212c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  80212f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802134:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  802137:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80213b:	74 0a                	je     802147 <insert_sorted_allocList+0x26>
  80213d:	8b 45 08             	mov    0x8(%ebp),%eax
  802140:	8b 40 08             	mov    0x8(%eax),%eax
  802143:	85 c0                	test   %eax,%eax
  802145:	75 65                	jne    8021ac <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802147:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80214b:	75 14                	jne    802161 <insert_sorted_allocList+0x40>
  80214d:	83 ec 04             	sub    $0x4,%esp
  802150:	68 14 3b 80 00       	push   $0x803b14
  802155:	6a 6e                	push   $0x6e
  802157:	68 37 3b 80 00       	push   $0x803b37
  80215c:	e8 16 e1 ff ff       	call   800277 <_panic>
  802161:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802167:	8b 45 08             	mov    0x8(%ebp),%eax
  80216a:	89 10                	mov    %edx,(%eax)
  80216c:	8b 45 08             	mov    0x8(%ebp),%eax
  80216f:	8b 00                	mov    (%eax),%eax
  802171:	85 c0                	test   %eax,%eax
  802173:	74 0d                	je     802182 <insert_sorted_allocList+0x61>
  802175:	a1 40 40 80 00       	mov    0x804040,%eax
  80217a:	8b 55 08             	mov    0x8(%ebp),%edx
  80217d:	89 50 04             	mov    %edx,0x4(%eax)
  802180:	eb 08                	jmp    80218a <insert_sorted_allocList+0x69>
  802182:	8b 45 08             	mov    0x8(%ebp),%eax
  802185:	a3 44 40 80 00       	mov    %eax,0x804044
  80218a:	8b 45 08             	mov    0x8(%ebp),%eax
  80218d:	a3 40 40 80 00       	mov    %eax,0x804040
  802192:	8b 45 08             	mov    0x8(%ebp),%eax
  802195:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80219c:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021a1:	40                   	inc    %eax
  8021a2:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8021a7:	e9 cf 01 00 00       	jmp    80237b <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  8021ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021af:	8b 50 08             	mov    0x8(%eax),%edx
  8021b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b5:	8b 40 08             	mov    0x8(%eax),%eax
  8021b8:	39 c2                	cmp    %eax,%edx
  8021ba:	73 65                	jae    802221 <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8021bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021c0:	75 14                	jne    8021d6 <insert_sorted_allocList+0xb5>
  8021c2:	83 ec 04             	sub    $0x4,%esp
  8021c5:	68 50 3b 80 00       	push   $0x803b50
  8021ca:	6a 72                	push   $0x72
  8021cc:	68 37 3b 80 00       	push   $0x803b37
  8021d1:	e8 a1 e0 ff ff       	call   800277 <_panic>
  8021d6:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8021dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021df:	89 50 04             	mov    %edx,0x4(%eax)
  8021e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e5:	8b 40 04             	mov    0x4(%eax),%eax
  8021e8:	85 c0                	test   %eax,%eax
  8021ea:	74 0c                	je     8021f8 <insert_sorted_allocList+0xd7>
  8021ec:	a1 44 40 80 00       	mov    0x804044,%eax
  8021f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8021f4:	89 10                	mov    %edx,(%eax)
  8021f6:	eb 08                	jmp    802200 <insert_sorted_allocList+0xdf>
  8021f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fb:	a3 40 40 80 00       	mov    %eax,0x804040
  802200:	8b 45 08             	mov    0x8(%ebp),%eax
  802203:	a3 44 40 80 00       	mov    %eax,0x804044
  802208:	8b 45 08             	mov    0x8(%ebp),%eax
  80220b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802211:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802216:	40                   	inc    %eax
  802217:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  80221c:	e9 5a 01 00 00       	jmp    80237b <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  802221:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802224:	8b 50 08             	mov    0x8(%eax),%edx
  802227:	8b 45 08             	mov    0x8(%ebp),%eax
  80222a:	8b 40 08             	mov    0x8(%eax),%eax
  80222d:	39 c2                	cmp    %eax,%edx
  80222f:	75 70                	jne    8022a1 <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  802231:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802235:	74 06                	je     80223d <insert_sorted_allocList+0x11c>
  802237:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80223b:	75 14                	jne    802251 <insert_sorted_allocList+0x130>
  80223d:	83 ec 04             	sub    $0x4,%esp
  802240:	68 74 3b 80 00       	push   $0x803b74
  802245:	6a 75                	push   $0x75
  802247:	68 37 3b 80 00       	push   $0x803b37
  80224c:	e8 26 e0 ff ff       	call   800277 <_panic>
  802251:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802254:	8b 10                	mov    (%eax),%edx
  802256:	8b 45 08             	mov    0x8(%ebp),%eax
  802259:	89 10                	mov    %edx,(%eax)
  80225b:	8b 45 08             	mov    0x8(%ebp),%eax
  80225e:	8b 00                	mov    (%eax),%eax
  802260:	85 c0                	test   %eax,%eax
  802262:	74 0b                	je     80226f <insert_sorted_allocList+0x14e>
  802264:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802267:	8b 00                	mov    (%eax),%eax
  802269:	8b 55 08             	mov    0x8(%ebp),%edx
  80226c:	89 50 04             	mov    %edx,0x4(%eax)
  80226f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802272:	8b 55 08             	mov    0x8(%ebp),%edx
  802275:	89 10                	mov    %edx,(%eax)
  802277:	8b 45 08             	mov    0x8(%ebp),%eax
  80227a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80227d:	89 50 04             	mov    %edx,0x4(%eax)
  802280:	8b 45 08             	mov    0x8(%ebp),%eax
  802283:	8b 00                	mov    (%eax),%eax
  802285:	85 c0                	test   %eax,%eax
  802287:	75 08                	jne    802291 <insert_sorted_allocList+0x170>
  802289:	8b 45 08             	mov    0x8(%ebp),%eax
  80228c:	a3 44 40 80 00       	mov    %eax,0x804044
  802291:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802296:	40                   	inc    %eax
  802297:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  80229c:	e9 da 00 00 00       	jmp    80237b <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  8022a1:	a1 40 40 80 00       	mov    0x804040,%eax
  8022a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022a9:	e9 9d 00 00 00       	jmp    80234b <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  8022ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b1:	8b 00                	mov    (%eax),%eax
  8022b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  8022b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b9:	8b 50 08             	mov    0x8(%eax),%edx
  8022bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bf:	8b 40 08             	mov    0x8(%eax),%eax
  8022c2:	39 c2                	cmp    %eax,%edx
  8022c4:	76 7d                	jbe    802343 <insert_sorted_allocList+0x222>
  8022c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c9:	8b 50 08             	mov    0x8(%eax),%edx
  8022cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022cf:	8b 40 08             	mov    0x8(%eax),%eax
  8022d2:	39 c2                	cmp    %eax,%edx
  8022d4:	73 6d                	jae    802343 <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  8022d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022da:	74 06                	je     8022e2 <insert_sorted_allocList+0x1c1>
  8022dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022e0:	75 14                	jne    8022f6 <insert_sorted_allocList+0x1d5>
  8022e2:	83 ec 04             	sub    $0x4,%esp
  8022e5:	68 74 3b 80 00       	push   $0x803b74
  8022ea:	6a 7c                	push   $0x7c
  8022ec:	68 37 3b 80 00       	push   $0x803b37
  8022f1:	e8 81 df ff ff       	call   800277 <_panic>
  8022f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f9:	8b 10                	mov    (%eax),%edx
  8022fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fe:	89 10                	mov    %edx,(%eax)
  802300:	8b 45 08             	mov    0x8(%ebp),%eax
  802303:	8b 00                	mov    (%eax),%eax
  802305:	85 c0                	test   %eax,%eax
  802307:	74 0b                	je     802314 <insert_sorted_allocList+0x1f3>
  802309:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230c:	8b 00                	mov    (%eax),%eax
  80230e:	8b 55 08             	mov    0x8(%ebp),%edx
  802311:	89 50 04             	mov    %edx,0x4(%eax)
  802314:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802317:	8b 55 08             	mov    0x8(%ebp),%edx
  80231a:	89 10                	mov    %edx,(%eax)
  80231c:	8b 45 08             	mov    0x8(%ebp),%eax
  80231f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802322:	89 50 04             	mov    %edx,0x4(%eax)
  802325:	8b 45 08             	mov    0x8(%ebp),%eax
  802328:	8b 00                	mov    (%eax),%eax
  80232a:	85 c0                	test   %eax,%eax
  80232c:	75 08                	jne    802336 <insert_sorted_allocList+0x215>
  80232e:	8b 45 08             	mov    0x8(%ebp),%eax
  802331:	a3 44 40 80 00       	mov    %eax,0x804044
  802336:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80233b:	40                   	inc    %eax
  80233c:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802341:	eb 38                	jmp    80237b <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802343:	a1 48 40 80 00       	mov    0x804048,%eax
  802348:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80234b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80234f:	74 07                	je     802358 <insert_sorted_allocList+0x237>
  802351:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802354:	8b 00                	mov    (%eax),%eax
  802356:	eb 05                	jmp    80235d <insert_sorted_allocList+0x23c>
  802358:	b8 00 00 00 00       	mov    $0x0,%eax
  80235d:	a3 48 40 80 00       	mov    %eax,0x804048
  802362:	a1 48 40 80 00       	mov    0x804048,%eax
  802367:	85 c0                	test   %eax,%eax
  802369:	0f 85 3f ff ff ff    	jne    8022ae <insert_sorted_allocList+0x18d>
  80236f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802373:	0f 85 35 ff ff ff    	jne    8022ae <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  802379:	eb 00                	jmp    80237b <insert_sorted_allocList+0x25a>
  80237b:	90                   	nop
  80237c:	c9                   	leave  
  80237d:	c3                   	ret    

0080237e <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80237e:	55                   	push   %ebp
  80237f:	89 e5                	mov    %esp,%ebp
  802381:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802384:	a1 38 41 80 00       	mov    0x804138,%eax
  802389:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80238c:	e9 6b 02 00 00       	jmp    8025fc <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  802391:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802394:	8b 40 0c             	mov    0xc(%eax),%eax
  802397:	3b 45 08             	cmp    0x8(%ebp),%eax
  80239a:	0f 85 90 00 00 00    	jne    802430 <alloc_block_FF+0xb2>
			  temp=element;
  8023a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  8023a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023aa:	75 17                	jne    8023c3 <alloc_block_FF+0x45>
  8023ac:	83 ec 04             	sub    $0x4,%esp
  8023af:	68 a8 3b 80 00       	push   $0x803ba8
  8023b4:	68 92 00 00 00       	push   $0x92
  8023b9:	68 37 3b 80 00       	push   $0x803b37
  8023be:	e8 b4 de ff ff       	call   800277 <_panic>
  8023c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c6:	8b 00                	mov    (%eax),%eax
  8023c8:	85 c0                	test   %eax,%eax
  8023ca:	74 10                	je     8023dc <alloc_block_FF+0x5e>
  8023cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cf:	8b 00                	mov    (%eax),%eax
  8023d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023d4:	8b 52 04             	mov    0x4(%edx),%edx
  8023d7:	89 50 04             	mov    %edx,0x4(%eax)
  8023da:	eb 0b                	jmp    8023e7 <alloc_block_FF+0x69>
  8023dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023df:	8b 40 04             	mov    0x4(%eax),%eax
  8023e2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8023e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ea:	8b 40 04             	mov    0x4(%eax),%eax
  8023ed:	85 c0                	test   %eax,%eax
  8023ef:	74 0f                	je     802400 <alloc_block_FF+0x82>
  8023f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f4:	8b 40 04             	mov    0x4(%eax),%eax
  8023f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023fa:	8b 12                	mov    (%edx),%edx
  8023fc:	89 10                	mov    %edx,(%eax)
  8023fe:	eb 0a                	jmp    80240a <alloc_block_FF+0x8c>
  802400:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802403:	8b 00                	mov    (%eax),%eax
  802405:	a3 38 41 80 00       	mov    %eax,0x804138
  80240a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802413:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802416:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80241d:	a1 44 41 80 00       	mov    0x804144,%eax
  802422:	48                   	dec    %eax
  802423:	a3 44 41 80 00       	mov    %eax,0x804144
			  return temp;
  802428:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80242b:	e9 ff 01 00 00       	jmp    80262f <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  802430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802433:	8b 40 0c             	mov    0xc(%eax),%eax
  802436:	3b 45 08             	cmp    0x8(%ebp),%eax
  802439:	0f 86 b5 01 00 00    	jbe    8025f4 <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  80243f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802442:	8b 40 0c             	mov    0xc(%eax),%eax
  802445:	2b 45 08             	sub    0x8(%ebp),%eax
  802448:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  80244b:	a1 48 41 80 00       	mov    0x804148,%eax
  802450:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  802453:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802457:	75 17                	jne    802470 <alloc_block_FF+0xf2>
  802459:	83 ec 04             	sub    $0x4,%esp
  80245c:	68 a8 3b 80 00       	push   $0x803ba8
  802461:	68 99 00 00 00       	push   $0x99
  802466:	68 37 3b 80 00       	push   $0x803b37
  80246b:	e8 07 de ff ff       	call   800277 <_panic>
  802470:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802473:	8b 00                	mov    (%eax),%eax
  802475:	85 c0                	test   %eax,%eax
  802477:	74 10                	je     802489 <alloc_block_FF+0x10b>
  802479:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80247c:	8b 00                	mov    (%eax),%eax
  80247e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802481:	8b 52 04             	mov    0x4(%edx),%edx
  802484:	89 50 04             	mov    %edx,0x4(%eax)
  802487:	eb 0b                	jmp    802494 <alloc_block_FF+0x116>
  802489:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80248c:	8b 40 04             	mov    0x4(%eax),%eax
  80248f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802494:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802497:	8b 40 04             	mov    0x4(%eax),%eax
  80249a:	85 c0                	test   %eax,%eax
  80249c:	74 0f                	je     8024ad <alloc_block_FF+0x12f>
  80249e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024a1:	8b 40 04             	mov    0x4(%eax),%eax
  8024a4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024a7:	8b 12                	mov    (%edx),%edx
  8024a9:	89 10                	mov    %edx,(%eax)
  8024ab:	eb 0a                	jmp    8024b7 <alloc_block_FF+0x139>
  8024ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024b0:	8b 00                	mov    (%eax),%eax
  8024b2:	a3 48 41 80 00       	mov    %eax,0x804148
  8024b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024ca:	a1 54 41 80 00       	mov    0x804154,%eax
  8024cf:	48                   	dec    %eax
  8024d0:	a3 54 41 80 00       	mov    %eax,0x804154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  8024d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8024d9:	75 17                	jne    8024f2 <alloc_block_FF+0x174>
  8024db:	83 ec 04             	sub    $0x4,%esp
  8024de:	68 50 3b 80 00       	push   $0x803b50
  8024e3:	68 9a 00 00 00       	push   $0x9a
  8024e8:	68 37 3b 80 00       	push   $0x803b37
  8024ed:	e8 85 dd ff ff       	call   800277 <_panic>
  8024f2:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8024f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024fb:	89 50 04             	mov    %edx,0x4(%eax)
  8024fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802501:	8b 40 04             	mov    0x4(%eax),%eax
  802504:	85 c0                	test   %eax,%eax
  802506:	74 0c                	je     802514 <alloc_block_FF+0x196>
  802508:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80250d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802510:	89 10                	mov    %edx,(%eax)
  802512:	eb 08                	jmp    80251c <alloc_block_FF+0x19e>
  802514:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802517:	a3 38 41 80 00       	mov    %eax,0x804138
  80251c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80251f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802524:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802527:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80252d:	a1 44 41 80 00       	mov    0x804144,%eax
  802532:	40                   	inc    %eax
  802533:	a3 44 41 80 00       	mov    %eax,0x804144
		  // setting the size & sva
		  new_block->size=size;
  802538:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80253b:	8b 55 08             	mov    0x8(%ebp),%edx
  80253e:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  802541:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802544:	8b 50 08             	mov    0x8(%eax),%edx
  802547:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80254a:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  80254d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802550:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802553:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  802556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802559:	8b 50 08             	mov    0x8(%eax),%edx
  80255c:	8b 45 08             	mov    0x8(%ebp),%eax
  80255f:	01 c2                	add    %eax,%edx
  802561:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802564:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  802567:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80256a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  80256d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802571:	75 17                	jne    80258a <alloc_block_FF+0x20c>
  802573:	83 ec 04             	sub    $0x4,%esp
  802576:	68 a8 3b 80 00       	push   $0x803ba8
  80257b:	68 a2 00 00 00       	push   $0xa2
  802580:	68 37 3b 80 00       	push   $0x803b37
  802585:	e8 ed dc ff ff       	call   800277 <_panic>
  80258a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80258d:	8b 00                	mov    (%eax),%eax
  80258f:	85 c0                	test   %eax,%eax
  802591:	74 10                	je     8025a3 <alloc_block_FF+0x225>
  802593:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802596:	8b 00                	mov    (%eax),%eax
  802598:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80259b:	8b 52 04             	mov    0x4(%edx),%edx
  80259e:	89 50 04             	mov    %edx,0x4(%eax)
  8025a1:	eb 0b                	jmp    8025ae <alloc_block_FF+0x230>
  8025a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025a6:	8b 40 04             	mov    0x4(%eax),%eax
  8025a9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025b1:	8b 40 04             	mov    0x4(%eax),%eax
  8025b4:	85 c0                	test   %eax,%eax
  8025b6:	74 0f                	je     8025c7 <alloc_block_FF+0x249>
  8025b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025bb:	8b 40 04             	mov    0x4(%eax),%eax
  8025be:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025c1:	8b 12                	mov    (%edx),%edx
  8025c3:	89 10                	mov    %edx,(%eax)
  8025c5:	eb 0a                	jmp    8025d1 <alloc_block_FF+0x253>
  8025c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ca:	8b 00                	mov    (%eax),%eax
  8025cc:	a3 38 41 80 00       	mov    %eax,0x804138
  8025d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025dd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025e4:	a1 44 41 80 00       	mov    0x804144,%eax
  8025e9:	48                   	dec    %eax
  8025ea:	a3 44 41 80 00       	mov    %eax,0x804144
		  return temp;
  8025ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025f2:	eb 3b                	jmp    80262f <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  8025f4:	a1 40 41 80 00       	mov    0x804140,%eax
  8025f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802600:	74 07                	je     802609 <alloc_block_FF+0x28b>
  802602:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802605:	8b 00                	mov    (%eax),%eax
  802607:	eb 05                	jmp    80260e <alloc_block_FF+0x290>
  802609:	b8 00 00 00 00       	mov    $0x0,%eax
  80260e:	a3 40 41 80 00       	mov    %eax,0x804140
  802613:	a1 40 41 80 00       	mov    0x804140,%eax
  802618:	85 c0                	test   %eax,%eax
  80261a:	0f 85 71 fd ff ff    	jne    802391 <alloc_block_FF+0x13>
  802620:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802624:	0f 85 67 fd ff ff    	jne    802391 <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  80262a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80262f:	c9                   	leave  
  802630:	c3                   	ret    

00802631 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802631:	55                   	push   %ebp
  802632:	89 e5                	mov    %esp,%ebp
  802634:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  802637:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  80263e:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802645:	a1 38 41 80 00       	mov    0x804138,%eax
  80264a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80264d:	e9 d3 00 00 00       	jmp    802725 <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  802652:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802655:	8b 40 0c             	mov    0xc(%eax),%eax
  802658:	3b 45 08             	cmp    0x8(%ebp),%eax
  80265b:	0f 85 90 00 00 00    	jne    8026f1 <alloc_block_BF+0xc0>
	   temp = element;
  802661:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802664:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  802667:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80266b:	75 17                	jne    802684 <alloc_block_BF+0x53>
  80266d:	83 ec 04             	sub    $0x4,%esp
  802670:	68 a8 3b 80 00       	push   $0x803ba8
  802675:	68 bd 00 00 00       	push   $0xbd
  80267a:	68 37 3b 80 00       	push   $0x803b37
  80267f:	e8 f3 db ff ff       	call   800277 <_panic>
  802684:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802687:	8b 00                	mov    (%eax),%eax
  802689:	85 c0                	test   %eax,%eax
  80268b:	74 10                	je     80269d <alloc_block_BF+0x6c>
  80268d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802690:	8b 00                	mov    (%eax),%eax
  802692:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802695:	8b 52 04             	mov    0x4(%edx),%edx
  802698:	89 50 04             	mov    %edx,0x4(%eax)
  80269b:	eb 0b                	jmp    8026a8 <alloc_block_BF+0x77>
  80269d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026a0:	8b 40 04             	mov    0x4(%eax),%eax
  8026a3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026ab:	8b 40 04             	mov    0x4(%eax),%eax
  8026ae:	85 c0                	test   %eax,%eax
  8026b0:	74 0f                	je     8026c1 <alloc_block_BF+0x90>
  8026b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026b5:	8b 40 04             	mov    0x4(%eax),%eax
  8026b8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026bb:	8b 12                	mov    (%edx),%edx
  8026bd:	89 10                	mov    %edx,(%eax)
  8026bf:	eb 0a                	jmp    8026cb <alloc_block_BF+0x9a>
  8026c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026c4:	8b 00                	mov    (%eax),%eax
  8026c6:	a3 38 41 80 00       	mov    %eax,0x804138
  8026cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026de:	a1 44 41 80 00       	mov    0x804144,%eax
  8026e3:	48                   	dec    %eax
  8026e4:	a3 44 41 80 00       	mov    %eax,0x804144
	   return temp;
  8026e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026ec:	e9 41 01 00 00       	jmp    802832 <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  8026f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026fa:	76 21                	jbe    80271d <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  8026fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802702:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802705:	73 16                	jae    80271d <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  802707:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80270a:	8b 40 0c             	mov    0xc(%eax),%eax
  80270d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  802710:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802713:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  802716:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  80271d:	a1 40 41 80 00       	mov    0x804140,%eax
  802722:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802725:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802729:	74 07                	je     802732 <alloc_block_BF+0x101>
  80272b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80272e:	8b 00                	mov    (%eax),%eax
  802730:	eb 05                	jmp    802737 <alloc_block_BF+0x106>
  802732:	b8 00 00 00 00       	mov    $0x0,%eax
  802737:	a3 40 41 80 00       	mov    %eax,0x804140
  80273c:	a1 40 41 80 00       	mov    0x804140,%eax
  802741:	85 c0                	test   %eax,%eax
  802743:	0f 85 09 ff ff ff    	jne    802652 <alloc_block_BF+0x21>
  802749:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80274d:	0f 85 ff fe ff ff    	jne    802652 <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  802753:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  802757:	0f 85 d0 00 00 00    	jne    80282d <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  80275d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802760:	8b 40 0c             	mov    0xc(%eax),%eax
  802763:	2b 45 08             	sub    0x8(%ebp),%eax
  802766:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  802769:	a1 48 41 80 00       	mov    0x804148,%eax
  80276e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  802771:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802775:	75 17                	jne    80278e <alloc_block_BF+0x15d>
  802777:	83 ec 04             	sub    $0x4,%esp
  80277a:	68 a8 3b 80 00       	push   $0x803ba8
  80277f:	68 d1 00 00 00       	push   $0xd1
  802784:	68 37 3b 80 00       	push   $0x803b37
  802789:	e8 e9 da ff ff       	call   800277 <_panic>
  80278e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802791:	8b 00                	mov    (%eax),%eax
  802793:	85 c0                	test   %eax,%eax
  802795:	74 10                	je     8027a7 <alloc_block_BF+0x176>
  802797:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80279a:	8b 00                	mov    (%eax),%eax
  80279c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80279f:	8b 52 04             	mov    0x4(%edx),%edx
  8027a2:	89 50 04             	mov    %edx,0x4(%eax)
  8027a5:	eb 0b                	jmp    8027b2 <alloc_block_BF+0x181>
  8027a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027aa:	8b 40 04             	mov    0x4(%eax),%eax
  8027ad:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8027b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027b5:	8b 40 04             	mov    0x4(%eax),%eax
  8027b8:	85 c0                	test   %eax,%eax
  8027ba:	74 0f                	je     8027cb <alloc_block_BF+0x19a>
  8027bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027bf:	8b 40 04             	mov    0x4(%eax),%eax
  8027c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027c5:	8b 12                	mov    (%edx),%edx
  8027c7:	89 10                	mov    %edx,(%eax)
  8027c9:	eb 0a                	jmp    8027d5 <alloc_block_BF+0x1a4>
  8027cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027ce:	8b 00                	mov    (%eax),%eax
  8027d0:	a3 48 41 80 00       	mov    %eax,0x804148
  8027d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027e8:	a1 54 41 80 00       	mov    0x804154,%eax
  8027ed:	48                   	dec    %eax
  8027ee:	a3 54 41 80 00       	mov    %eax,0x804154
	  // setting the size & sva
	  new_block->size = size;
  8027f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8027f9:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  8027fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ff:	8b 50 08             	mov    0x8(%eax),%edx
  802802:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802805:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  802808:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80280b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80280e:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  802811:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802814:	8b 50 08             	mov    0x8(%eax),%edx
  802817:	8b 45 08             	mov    0x8(%ebp),%eax
  80281a:	01 c2                	add    %eax,%edx
  80281c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80281f:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  802822:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802825:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  802828:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80282b:	eb 05                	jmp    802832 <alloc_block_BF+0x201>
	 }
	 return NULL;
  80282d:	b8 00 00 00 00       	mov    $0x0,%eax


}
  802832:	c9                   	leave  
  802833:	c3                   	ret    

00802834 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802834:	55                   	push   %ebp
  802835:	89 e5                	mov    %esp,%ebp
  802837:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  80283a:	83 ec 04             	sub    $0x4,%esp
  80283d:	68 c8 3b 80 00       	push   $0x803bc8
  802842:	68 e8 00 00 00       	push   $0xe8
  802847:	68 37 3b 80 00       	push   $0x803b37
  80284c:	e8 26 da ff ff       	call   800277 <_panic>

00802851 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802851:	55                   	push   %ebp
  802852:	89 e5                	mov    %esp,%ebp
  802854:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  802857:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80285c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  80285f:	a1 38 41 80 00       	mov    0x804138,%eax
  802864:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  802867:	a1 44 41 80 00       	mov    0x804144,%eax
  80286c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  80286f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802873:	75 68                	jne    8028dd <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802875:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802879:	75 17                	jne    802892 <insert_sorted_with_merge_freeList+0x41>
  80287b:	83 ec 04             	sub    $0x4,%esp
  80287e:	68 14 3b 80 00       	push   $0x803b14
  802883:	68 36 01 00 00       	push   $0x136
  802888:	68 37 3b 80 00       	push   $0x803b37
  80288d:	e8 e5 d9 ff ff       	call   800277 <_panic>
  802892:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802898:	8b 45 08             	mov    0x8(%ebp),%eax
  80289b:	89 10                	mov    %edx,(%eax)
  80289d:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a0:	8b 00                	mov    (%eax),%eax
  8028a2:	85 c0                	test   %eax,%eax
  8028a4:	74 0d                	je     8028b3 <insert_sorted_with_merge_freeList+0x62>
  8028a6:	a1 38 41 80 00       	mov    0x804138,%eax
  8028ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8028ae:	89 50 04             	mov    %edx,0x4(%eax)
  8028b1:	eb 08                	jmp    8028bb <insert_sorted_with_merge_freeList+0x6a>
  8028b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028be:	a3 38 41 80 00       	mov    %eax,0x804138
  8028c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028cd:	a1 44 41 80 00       	mov    0x804144,%eax
  8028d2:	40                   	inc    %eax
  8028d3:	a3 44 41 80 00       	mov    %eax,0x804144





}
  8028d8:	e9 ba 06 00 00       	jmp    802f97 <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  8028dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e0:	8b 50 08             	mov    0x8(%eax),%edx
  8028e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8028e9:	01 c2                	add    %eax,%edx
  8028eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ee:	8b 40 08             	mov    0x8(%eax),%eax
  8028f1:	39 c2                	cmp    %eax,%edx
  8028f3:	73 68                	jae    80295d <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8028f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028f9:	75 17                	jne    802912 <insert_sorted_with_merge_freeList+0xc1>
  8028fb:	83 ec 04             	sub    $0x4,%esp
  8028fe:	68 50 3b 80 00       	push   $0x803b50
  802903:	68 3a 01 00 00       	push   $0x13a
  802908:	68 37 3b 80 00       	push   $0x803b37
  80290d:	e8 65 d9 ff ff       	call   800277 <_panic>
  802912:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802918:	8b 45 08             	mov    0x8(%ebp),%eax
  80291b:	89 50 04             	mov    %edx,0x4(%eax)
  80291e:	8b 45 08             	mov    0x8(%ebp),%eax
  802921:	8b 40 04             	mov    0x4(%eax),%eax
  802924:	85 c0                	test   %eax,%eax
  802926:	74 0c                	je     802934 <insert_sorted_with_merge_freeList+0xe3>
  802928:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80292d:	8b 55 08             	mov    0x8(%ebp),%edx
  802930:	89 10                	mov    %edx,(%eax)
  802932:	eb 08                	jmp    80293c <insert_sorted_with_merge_freeList+0xeb>
  802934:	8b 45 08             	mov    0x8(%ebp),%eax
  802937:	a3 38 41 80 00       	mov    %eax,0x804138
  80293c:	8b 45 08             	mov    0x8(%ebp),%eax
  80293f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802944:	8b 45 08             	mov    0x8(%ebp),%eax
  802947:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80294d:	a1 44 41 80 00       	mov    0x804144,%eax
  802952:	40                   	inc    %eax
  802953:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802958:	e9 3a 06 00 00       	jmp    802f97 <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  80295d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802960:	8b 50 08             	mov    0x8(%eax),%edx
  802963:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802966:	8b 40 0c             	mov    0xc(%eax),%eax
  802969:	01 c2                	add    %eax,%edx
  80296b:	8b 45 08             	mov    0x8(%ebp),%eax
  80296e:	8b 40 08             	mov    0x8(%eax),%eax
  802971:	39 c2                	cmp    %eax,%edx
  802973:	0f 85 90 00 00 00    	jne    802a09 <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  802979:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80297c:	8b 50 0c             	mov    0xc(%eax),%edx
  80297f:	8b 45 08             	mov    0x8(%ebp),%eax
  802982:	8b 40 0c             	mov    0xc(%eax),%eax
  802985:	01 c2                	add    %eax,%edx
  802987:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80298a:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  80298d:	8b 45 08             	mov    0x8(%ebp),%eax
  802990:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  802997:	8b 45 08             	mov    0x8(%ebp),%eax
  80299a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8029a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029a5:	75 17                	jne    8029be <insert_sorted_with_merge_freeList+0x16d>
  8029a7:	83 ec 04             	sub    $0x4,%esp
  8029aa:	68 14 3b 80 00       	push   $0x803b14
  8029af:	68 41 01 00 00       	push   $0x141
  8029b4:	68 37 3b 80 00       	push   $0x803b37
  8029b9:	e8 b9 d8 ff ff       	call   800277 <_panic>
  8029be:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8029c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c7:	89 10                	mov    %edx,(%eax)
  8029c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cc:	8b 00                	mov    (%eax),%eax
  8029ce:	85 c0                	test   %eax,%eax
  8029d0:	74 0d                	je     8029df <insert_sorted_with_merge_freeList+0x18e>
  8029d2:	a1 48 41 80 00       	mov    0x804148,%eax
  8029d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8029da:	89 50 04             	mov    %edx,0x4(%eax)
  8029dd:	eb 08                	jmp    8029e7 <insert_sorted_with_merge_freeList+0x196>
  8029df:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8029e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ea:	a3 48 41 80 00       	mov    %eax,0x804148
  8029ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029f9:	a1 54 41 80 00       	mov    0x804154,%eax
  8029fe:	40                   	inc    %eax
  8029ff:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802a04:	e9 8e 05 00 00       	jmp    802f97 <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  802a09:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0c:	8b 50 08             	mov    0x8(%eax),%edx
  802a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a12:	8b 40 0c             	mov    0xc(%eax),%eax
  802a15:	01 c2                	add    %eax,%edx
  802a17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a1a:	8b 40 08             	mov    0x8(%eax),%eax
  802a1d:	39 c2                	cmp    %eax,%edx
  802a1f:	73 68                	jae    802a89 <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802a21:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a25:	75 17                	jne    802a3e <insert_sorted_with_merge_freeList+0x1ed>
  802a27:	83 ec 04             	sub    $0x4,%esp
  802a2a:	68 14 3b 80 00       	push   $0x803b14
  802a2f:	68 45 01 00 00       	push   $0x145
  802a34:	68 37 3b 80 00       	push   $0x803b37
  802a39:	e8 39 d8 ff ff       	call   800277 <_panic>
  802a3e:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a44:	8b 45 08             	mov    0x8(%ebp),%eax
  802a47:	89 10                	mov    %edx,(%eax)
  802a49:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4c:	8b 00                	mov    (%eax),%eax
  802a4e:	85 c0                	test   %eax,%eax
  802a50:	74 0d                	je     802a5f <insert_sorted_with_merge_freeList+0x20e>
  802a52:	a1 38 41 80 00       	mov    0x804138,%eax
  802a57:	8b 55 08             	mov    0x8(%ebp),%edx
  802a5a:	89 50 04             	mov    %edx,0x4(%eax)
  802a5d:	eb 08                	jmp    802a67 <insert_sorted_with_merge_freeList+0x216>
  802a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a62:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a67:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6a:	a3 38 41 80 00       	mov    %eax,0x804138
  802a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a72:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a79:	a1 44 41 80 00       	mov    0x804144,%eax
  802a7e:	40                   	inc    %eax
  802a7f:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802a84:	e9 0e 05 00 00       	jmp    802f97 <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  802a89:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8c:	8b 50 08             	mov    0x8(%eax),%edx
  802a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a92:	8b 40 0c             	mov    0xc(%eax),%eax
  802a95:	01 c2                	add    %eax,%edx
  802a97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a9a:	8b 40 08             	mov    0x8(%eax),%eax
  802a9d:	39 c2                	cmp    %eax,%edx
  802a9f:	0f 85 9c 00 00 00    	jne    802b41 <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  802aa5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa8:	8b 50 0c             	mov    0xc(%eax),%edx
  802aab:	8b 45 08             	mov    0x8(%ebp),%eax
  802aae:	8b 40 0c             	mov    0xc(%eax),%eax
  802ab1:	01 c2                	add    %eax,%edx
  802ab3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ab6:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  802ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  802abc:	8b 50 08             	mov    0x8(%eax),%edx
  802abf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac2:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  802ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  802acf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802ad9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802add:	75 17                	jne    802af6 <insert_sorted_with_merge_freeList+0x2a5>
  802adf:	83 ec 04             	sub    $0x4,%esp
  802ae2:	68 14 3b 80 00       	push   $0x803b14
  802ae7:	68 4d 01 00 00       	push   $0x14d
  802aec:	68 37 3b 80 00       	push   $0x803b37
  802af1:	e8 81 d7 ff ff       	call   800277 <_panic>
  802af6:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802afc:	8b 45 08             	mov    0x8(%ebp),%eax
  802aff:	89 10                	mov    %edx,(%eax)
  802b01:	8b 45 08             	mov    0x8(%ebp),%eax
  802b04:	8b 00                	mov    (%eax),%eax
  802b06:	85 c0                	test   %eax,%eax
  802b08:	74 0d                	je     802b17 <insert_sorted_with_merge_freeList+0x2c6>
  802b0a:	a1 48 41 80 00       	mov    0x804148,%eax
  802b0f:	8b 55 08             	mov    0x8(%ebp),%edx
  802b12:	89 50 04             	mov    %edx,0x4(%eax)
  802b15:	eb 08                	jmp    802b1f <insert_sorted_with_merge_freeList+0x2ce>
  802b17:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b22:	a3 48 41 80 00       	mov    %eax,0x804148
  802b27:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b31:	a1 54 41 80 00       	mov    0x804154,%eax
  802b36:	40                   	inc    %eax
  802b37:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802b3c:	e9 56 04 00 00       	jmp    802f97 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802b41:	a1 38 41 80 00       	mov    0x804138,%eax
  802b46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b49:	e9 19 04 00 00       	jmp    802f67 <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  802b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b51:	8b 00                	mov    (%eax),%eax
  802b53:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b59:	8b 50 08             	mov    0x8(%eax),%edx
  802b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5f:	8b 40 0c             	mov    0xc(%eax),%eax
  802b62:	01 c2                	add    %eax,%edx
  802b64:	8b 45 08             	mov    0x8(%ebp),%eax
  802b67:	8b 40 08             	mov    0x8(%eax),%eax
  802b6a:	39 c2                	cmp    %eax,%edx
  802b6c:	0f 85 ad 01 00 00    	jne    802d1f <insert_sorted_with_merge_freeList+0x4ce>
  802b72:	8b 45 08             	mov    0x8(%ebp),%eax
  802b75:	8b 50 08             	mov    0x8(%eax),%edx
  802b78:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b7e:	01 c2                	add    %eax,%edx
  802b80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b83:	8b 40 08             	mov    0x8(%eax),%eax
  802b86:	39 c2                	cmp    %eax,%edx
  802b88:	0f 85 91 01 00 00    	jne    802d1f <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  802b8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b91:	8b 50 0c             	mov    0xc(%eax),%edx
  802b94:	8b 45 08             	mov    0x8(%ebp),%eax
  802b97:	8b 48 0c             	mov    0xc(%eax),%ecx
  802b9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b9d:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba0:	01 c8                	add    %ecx,%eax
  802ba2:	01 c2                	add    %eax,%edx
  802ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba7:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  802baa:	8b 45 08             	mov    0x8(%ebp),%eax
  802bad:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  802bbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bc1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  802bc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bcb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  802bd2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802bd6:	75 17                	jne    802bef <insert_sorted_with_merge_freeList+0x39e>
  802bd8:	83 ec 04             	sub    $0x4,%esp
  802bdb:	68 a8 3b 80 00       	push   $0x803ba8
  802be0:	68 5b 01 00 00       	push   $0x15b
  802be5:	68 37 3b 80 00       	push   $0x803b37
  802bea:	e8 88 d6 ff ff       	call   800277 <_panic>
  802bef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bf2:	8b 00                	mov    (%eax),%eax
  802bf4:	85 c0                	test   %eax,%eax
  802bf6:	74 10                	je     802c08 <insert_sorted_with_merge_freeList+0x3b7>
  802bf8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bfb:	8b 00                	mov    (%eax),%eax
  802bfd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c00:	8b 52 04             	mov    0x4(%edx),%edx
  802c03:	89 50 04             	mov    %edx,0x4(%eax)
  802c06:	eb 0b                	jmp    802c13 <insert_sorted_with_merge_freeList+0x3c2>
  802c08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c0b:	8b 40 04             	mov    0x4(%eax),%eax
  802c0e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c16:	8b 40 04             	mov    0x4(%eax),%eax
  802c19:	85 c0                	test   %eax,%eax
  802c1b:	74 0f                	je     802c2c <insert_sorted_with_merge_freeList+0x3db>
  802c1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c20:	8b 40 04             	mov    0x4(%eax),%eax
  802c23:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c26:	8b 12                	mov    (%edx),%edx
  802c28:	89 10                	mov    %edx,(%eax)
  802c2a:	eb 0a                	jmp    802c36 <insert_sorted_with_merge_freeList+0x3e5>
  802c2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c2f:	8b 00                	mov    (%eax),%eax
  802c31:	a3 38 41 80 00       	mov    %eax,0x804138
  802c36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c39:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c42:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c49:	a1 44 41 80 00       	mov    0x804144,%eax
  802c4e:	48                   	dec    %eax
  802c4f:	a3 44 41 80 00       	mov    %eax,0x804144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802c54:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c58:	75 17                	jne    802c71 <insert_sorted_with_merge_freeList+0x420>
  802c5a:	83 ec 04             	sub    $0x4,%esp
  802c5d:	68 14 3b 80 00       	push   $0x803b14
  802c62:	68 5c 01 00 00       	push   $0x15c
  802c67:	68 37 3b 80 00       	push   $0x803b37
  802c6c:	e8 06 d6 ff ff       	call   800277 <_panic>
  802c71:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c77:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7a:	89 10                	mov    %edx,(%eax)
  802c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7f:	8b 00                	mov    (%eax),%eax
  802c81:	85 c0                	test   %eax,%eax
  802c83:	74 0d                	je     802c92 <insert_sorted_with_merge_freeList+0x441>
  802c85:	a1 48 41 80 00       	mov    0x804148,%eax
  802c8a:	8b 55 08             	mov    0x8(%ebp),%edx
  802c8d:	89 50 04             	mov    %edx,0x4(%eax)
  802c90:	eb 08                	jmp    802c9a <insert_sorted_with_merge_freeList+0x449>
  802c92:	8b 45 08             	mov    0x8(%ebp),%eax
  802c95:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9d:	a3 48 41 80 00       	mov    %eax,0x804148
  802ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cac:	a1 54 41 80 00       	mov    0x804154,%eax
  802cb1:	40                   	inc    %eax
  802cb2:	a3 54 41 80 00       	mov    %eax,0x804154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  802cb7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802cbb:	75 17                	jne    802cd4 <insert_sorted_with_merge_freeList+0x483>
  802cbd:	83 ec 04             	sub    $0x4,%esp
  802cc0:	68 14 3b 80 00       	push   $0x803b14
  802cc5:	68 5d 01 00 00       	push   $0x15d
  802cca:	68 37 3b 80 00       	push   $0x803b37
  802ccf:	e8 a3 d5 ff ff       	call   800277 <_panic>
  802cd4:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802cda:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cdd:	89 10                	mov    %edx,(%eax)
  802cdf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ce2:	8b 00                	mov    (%eax),%eax
  802ce4:	85 c0                	test   %eax,%eax
  802ce6:	74 0d                	je     802cf5 <insert_sorted_with_merge_freeList+0x4a4>
  802ce8:	a1 48 41 80 00       	mov    0x804148,%eax
  802ced:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802cf0:	89 50 04             	mov    %edx,0x4(%eax)
  802cf3:	eb 08                	jmp    802cfd <insert_sorted_with_merge_freeList+0x4ac>
  802cf5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cf8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802cfd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d00:	a3 48 41 80 00       	mov    %eax,0x804148
  802d05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d08:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d0f:	a1 54 41 80 00       	mov    0x804154,%eax
  802d14:	40                   	inc    %eax
  802d15:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802d1a:	e9 78 02 00 00       	jmp    802f97 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d22:	8b 50 08             	mov    0x8(%eax),%edx
  802d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d28:	8b 40 0c             	mov    0xc(%eax),%eax
  802d2b:	01 c2                	add    %eax,%edx
  802d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d30:	8b 40 08             	mov    0x8(%eax),%eax
  802d33:	39 c2                	cmp    %eax,%edx
  802d35:	0f 83 b8 00 00 00    	jae    802df3 <insert_sorted_with_merge_freeList+0x5a2>
  802d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3e:	8b 50 08             	mov    0x8(%eax),%edx
  802d41:	8b 45 08             	mov    0x8(%ebp),%eax
  802d44:	8b 40 0c             	mov    0xc(%eax),%eax
  802d47:	01 c2                	add    %eax,%edx
  802d49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d4c:	8b 40 08             	mov    0x8(%eax),%eax
  802d4f:	39 c2                	cmp    %eax,%edx
  802d51:	0f 85 9c 00 00 00    	jne    802df3 <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  802d57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d5a:	8b 50 0c             	mov    0xc(%eax),%edx
  802d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d60:	8b 40 0c             	mov    0xc(%eax),%eax
  802d63:	01 c2                	add    %eax,%edx
  802d65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d68:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  802d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6e:	8b 50 08             	mov    0x8(%eax),%edx
  802d71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d74:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  802d77:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802d81:	8b 45 08             	mov    0x8(%ebp),%eax
  802d84:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802d8b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d8f:	75 17                	jne    802da8 <insert_sorted_with_merge_freeList+0x557>
  802d91:	83 ec 04             	sub    $0x4,%esp
  802d94:	68 14 3b 80 00       	push   $0x803b14
  802d99:	68 67 01 00 00       	push   $0x167
  802d9e:	68 37 3b 80 00       	push   $0x803b37
  802da3:	e8 cf d4 ff ff       	call   800277 <_panic>
  802da8:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802dae:	8b 45 08             	mov    0x8(%ebp),%eax
  802db1:	89 10                	mov    %edx,(%eax)
  802db3:	8b 45 08             	mov    0x8(%ebp),%eax
  802db6:	8b 00                	mov    (%eax),%eax
  802db8:	85 c0                	test   %eax,%eax
  802dba:	74 0d                	je     802dc9 <insert_sorted_with_merge_freeList+0x578>
  802dbc:	a1 48 41 80 00       	mov    0x804148,%eax
  802dc1:	8b 55 08             	mov    0x8(%ebp),%edx
  802dc4:	89 50 04             	mov    %edx,0x4(%eax)
  802dc7:	eb 08                	jmp    802dd1 <insert_sorted_with_merge_freeList+0x580>
  802dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcc:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd4:	a3 48 41 80 00       	mov    %eax,0x804148
  802dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802de3:	a1 54 41 80 00       	mov    0x804154,%eax
  802de8:	40                   	inc    %eax
  802de9:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802dee:	e9 a4 01 00 00       	jmp    802f97 <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df6:	8b 50 08             	mov    0x8(%eax),%edx
  802df9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfc:	8b 40 0c             	mov    0xc(%eax),%eax
  802dff:	01 c2                	add    %eax,%edx
  802e01:	8b 45 08             	mov    0x8(%ebp),%eax
  802e04:	8b 40 08             	mov    0x8(%eax),%eax
  802e07:	39 c2                	cmp    %eax,%edx
  802e09:	0f 85 ac 00 00 00    	jne    802ebb <insert_sorted_with_merge_freeList+0x66a>
  802e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e12:	8b 50 08             	mov    0x8(%eax),%edx
  802e15:	8b 45 08             	mov    0x8(%ebp),%eax
  802e18:	8b 40 0c             	mov    0xc(%eax),%eax
  802e1b:	01 c2                	add    %eax,%edx
  802e1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e20:	8b 40 08             	mov    0x8(%eax),%eax
  802e23:	39 c2                	cmp    %eax,%edx
  802e25:	0f 83 90 00 00 00    	jae    802ebb <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  802e2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2e:	8b 50 0c             	mov    0xc(%eax),%edx
  802e31:	8b 45 08             	mov    0x8(%ebp),%eax
  802e34:	8b 40 0c             	mov    0xc(%eax),%eax
  802e37:	01 c2                	add    %eax,%edx
  802e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3c:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  802e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e42:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  802e49:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e53:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e57:	75 17                	jne    802e70 <insert_sorted_with_merge_freeList+0x61f>
  802e59:	83 ec 04             	sub    $0x4,%esp
  802e5c:	68 14 3b 80 00       	push   $0x803b14
  802e61:	68 70 01 00 00       	push   $0x170
  802e66:	68 37 3b 80 00       	push   $0x803b37
  802e6b:	e8 07 d4 ff ff       	call   800277 <_panic>
  802e70:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e76:	8b 45 08             	mov    0x8(%ebp),%eax
  802e79:	89 10                	mov    %edx,(%eax)
  802e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7e:	8b 00                	mov    (%eax),%eax
  802e80:	85 c0                	test   %eax,%eax
  802e82:	74 0d                	je     802e91 <insert_sorted_with_merge_freeList+0x640>
  802e84:	a1 48 41 80 00       	mov    0x804148,%eax
  802e89:	8b 55 08             	mov    0x8(%ebp),%edx
  802e8c:	89 50 04             	mov    %edx,0x4(%eax)
  802e8f:	eb 08                	jmp    802e99 <insert_sorted_with_merge_freeList+0x648>
  802e91:	8b 45 08             	mov    0x8(%ebp),%eax
  802e94:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e99:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9c:	a3 48 41 80 00       	mov    %eax,0x804148
  802ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eab:	a1 54 41 80 00       	mov    0x804154,%eax
  802eb0:	40                   	inc    %eax
  802eb1:	a3 54 41 80 00       	mov    %eax,0x804154
	      break;
  802eb6:	e9 dc 00 00 00       	jmp    802f97 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802ebb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebe:	8b 50 08             	mov    0x8(%eax),%edx
  802ec1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec7:	01 c2                	add    %eax,%edx
  802ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecc:	8b 40 08             	mov    0x8(%eax),%eax
  802ecf:	39 c2                	cmp    %eax,%edx
  802ed1:	0f 83 88 00 00 00    	jae    802f5f <insert_sorted_with_merge_freeList+0x70e>
  802ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eda:	8b 50 08             	mov    0x8(%eax),%edx
  802edd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee3:	01 c2                	add    %eax,%edx
  802ee5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ee8:	8b 40 08             	mov    0x8(%eax),%eax
  802eeb:	39 c2                	cmp    %eax,%edx
  802eed:	73 70                	jae    802f5f <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  802eef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ef3:	74 06                	je     802efb <insert_sorted_with_merge_freeList+0x6aa>
  802ef5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ef9:	75 17                	jne    802f12 <insert_sorted_with_merge_freeList+0x6c1>
  802efb:	83 ec 04             	sub    $0x4,%esp
  802efe:	68 74 3b 80 00       	push   $0x803b74
  802f03:	68 75 01 00 00       	push   $0x175
  802f08:	68 37 3b 80 00       	push   $0x803b37
  802f0d:	e8 65 d3 ff ff       	call   800277 <_panic>
  802f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f15:	8b 10                	mov    (%eax),%edx
  802f17:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1a:	89 10                	mov    %edx,(%eax)
  802f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1f:	8b 00                	mov    (%eax),%eax
  802f21:	85 c0                	test   %eax,%eax
  802f23:	74 0b                	je     802f30 <insert_sorted_with_merge_freeList+0x6df>
  802f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f28:	8b 00                	mov    (%eax),%eax
  802f2a:	8b 55 08             	mov    0x8(%ebp),%edx
  802f2d:	89 50 04             	mov    %edx,0x4(%eax)
  802f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f33:	8b 55 08             	mov    0x8(%ebp),%edx
  802f36:	89 10                	mov    %edx,(%eax)
  802f38:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f3e:	89 50 04             	mov    %edx,0x4(%eax)
  802f41:	8b 45 08             	mov    0x8(%ebp),%eax
  802f44:	8b 00                	mov    (%eax),%eax
  802f46:	85 c0                	test   %eax,%eax
  802f48:	75 08                	jne    802f52 <insert_sorted_with_merge_freeList+0x701>
  802f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f52:	a1 44 41 80 00       	mov    0x804144,%eax
  802f57:	40                   	inc    %eax
  802f58:	a3 44 41 80 00       	mov    %eax,0x804144
	      break;
  802f5d:	eb 38                	jmp    802f97 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802f5f:	a1 40 41 80 00       	mov    0x804140,%eax
  802f64:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f6b:	74 07                	je     802f74 <insert_sorted_with_merge_freeList+0x723>
  802f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f70:	8b 00                	mov    (%eax),%eax
  802f72:	eb 05                	jmp    802f79 <insert_sorted_with_merge_freeList+0x728>
  802f74:	b8 00 00 00 00       	mov    $0x0,%eax
  802f79:	a3 40 41 80 00       	mov    %eax,0x804140
  802f7e:	a1 40 41 80 00       	mov    0x804140,%eax
  802f83:	85 c0                	test   %eax,%eax
  802f85:	0f 85 c3 fb ff ff    	jne    802b4e <insert_sorted_with_merge_freeList+0x2fd>
  802f8b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f8f:	0f 85 b9 fb ff ff    	jne    802b4e <insert_sorted_with_merge_freeList+0x2fd>





}
  802f95:	eb 00                	jmp    802f97 <insert_sorted_with_merge_freeList+0x746>
  802f97:	90                   	nop
  802f98:	c9                   	leave  
  802f99:	c3                   	ret    

00802f9a <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802f9a:	55                   	push   %ebp
  802f9b:	89 e5                	mov    %esp,%ebp
  802f9d:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  802fa0:	8b 55 08             	mov    0x8(%ebp),%edx
  802fa3:	89 d0                	mov    %edx,%eax
  802fa5:	c1 e0 02             	shl    $0x2,%eax
  802fa8:	01 d0                	add    %edx,%eax
  802faa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802fb1:	01 d0                	add    %edx,%eax
  802fb3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802fba:	01 d0                	add    %edx,%eax
  802fbc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802fc3:	01 d0                	add    %edx,%eax
  802fc5:	c1 e0 04             	shl    $0x4,%eax
  802fc8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  802fcb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  802fd2:	8d 45 e8             	lea    -0x18(%ebp),%eax
  802fd5:	83 ec 0c             	sub    $0xc,%esp
  802fd8:	50                   	push   %eax
  802fd9:	e8 31 ec ff ff       	call   801c0f <sys_get_virtual_time>
  802fde:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  802fe1:	eb 41                	jmp    803024 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  802fe3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802fe6:	83 ec 0c             	sub    $0xc,%esp
  802fe9:	50                   	push   %eax
  802fea:	e8 20 ec ff ff       	call   801c0f <sys_get_virtual_time>
  802fef:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  802ff2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ff5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff8:	29 c2                	sub    %eax,%edx
  802ffa:	89 d0                	mov    %edx,%eax
  802ffc:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  802fff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803002:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803005:	89 d1                	mov    %edx,%ecx
  803007:	29 c1                	sub    %eax,%ecx
  803009:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80300c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80300f:	39 c2                	cmp    %eax,%edx
  803011:	0f 97 c0             	seta   %al
  803014:	0f b6 c0             	movzbl %al,%eax
  803017:	29 c1                	sub    %eax,%ecx
  803019:	89 c8                	mov    %ecx,%eax
  80301b:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80301e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803021:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803024:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803027:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80302a:	72 b7                	jb     802fe3 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80302c:	90                   	nop
  80302d:	c9                   	leave  
  80302e:	c3                   	ret    

0080302f <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80302f:	55                   	push   %ebp
  803030:	89 e5                	mov    %esp,%ebp
  803032:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803035:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80303c:	eb 03                	jmp    803041 <busy_wait+0x12>
  80303e:	ff 45 fc             	incl   -0x4(%ebp)
  803041:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803044:	3b 45 08             	cmp    0x8(%ebp),%eax
  803047:	72 f5                	jb     80303e <busy_wait+0xf>
	return i;
  803049:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80304c:	c9                   	leave  
  80304d:	c3                   	ret    
  80304e:	66 90                	xchg   %ax,%ax

00803050 <__udivdi3>:
  803050:	55                   	push   %ebp
  803051:	57                   	push   %edi
  803052:	56                   	push   %esi
  803053:	53                   	push   %ebx
  803054:	83 ec 1c             	sub    $0x1c,%esp
  803057:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80305b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80305f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803063:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803067:	89 ca                	mov    %ecx,%edx
  803069:	89 f8                	mov    %edi,%eax
  80306b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80306f:	85 f6                	test   %esi,%esi
  803071:	75 2d                	jne    8030a0 <__udivdi3+0x50>
  803073:	39 cf                	cmp    %ecx,%edi
  803075:	77 65                	ja     8030dc <__udivdi3+0x8c>
  803077:	89 fd                	mov    %edi,%ebp
  803079:	85 ff                	test   %edi,%edi
  80307b:	75 0b                	jne    803088 <__udivdi3+0x38>
  80307d:	b8 01 00 00 00       	mov    $0x1,%eax
  803082:	31 d2                	xor    %edx,%edx
  803084:	f7 f7                	div    %edi
  803086:	89 c5                	mov    %eax,%ebp
  803088:	31 d2                	xor    %edx,%edx
  80308a:	89 c8                	mov    %ecx,%eax
  80308c:	f7 f5                	div    %ebp
  80308e:	89 c1                	mov    %eax,%ecx
  803090:	89 d8                	mov    %ebx,%eax
  803092:	f7 f5                	div    %ebp
  803094:	89 cf                	mov    %ecx,%edi
  803096:	89 fa                	mov    %edi,%edx
  803098:	83 c4 1c             	add    $0x1c,%esp
  80309b:	5b                   	pop    %ebx
  80309c:	5e                   	pop    %esi
  80309d:	5f                   	pop    %edi
  80309e:	5d                   	pop    %ebp
  80309f:	c3                   	ret    
  8030a0:	39 ce                	cmp    %ecx,%esi
  8030a2:	77 28                	ja     8030cc <__udivdi3+0x7c>
  8030a4:	0f bd fe             	bsr    %esi,%edi
  8030a7:	83 f7 1f             	xor    $0x1f,%edi
  8030aa:	75 40                	jne    8030ec <__udivdi3+0x9c>
  8030ac:	39 ce                	cmp    %ecx,%esi
  8030ae:	72 0a                	jb     8030ba <__udivdi3+0x6a>
  8030b0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8030b4:	0f 87 9e 00 00 00    	ja     803158 <__udivdi3+0x108>
  8030ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8030bf:	89 fa                	mov    %edi,%edx
  8030c1:	83 c4 1c             	add    $0x1c,%esp
  8030c4:	5b                   	pop    %ebx
  8030c5:	5e                   	pop    %esi
  8030c6:	5f                   	pop    %edi
  8030c7:	5d                   	pop    %ebp
  8030c8:	c3                   	ret    
  8030c9:	8d 76 00             	lea    0x0(%esi),%esi
  8030cc:	31 ff                	xor    %edi,%edi
  8030ce:	31 c0                	xor    %eax,%eax
  8030d0:	89 fa                	mov    %edi,%edx
  8030d2:	83 c4 1c             	add    $0x1c,%esp
  8030d5:	5b                   	pop    %ebx
  8030d6:	5e                   	pop    %esi
  8030d7:	5f                   	pop    %edi
  8030d8:	5d                   	pop    %ebp
  8030d9:	c3                   	ret    
  8030da:	66 90                	xchg   %ax,%ax
  8030dc:	89 d8                	mov    %ebx,%eax
  8030de:	f7 f7                	div    %edi
  8030e0:	31 ff                	xor    %edi,%edi
  8030e2:	89 fa                	mov    %edi,%edx
  8030e4:	83 c4 1c             	add    $0x1c,%esp
  8030e7:	5b                   	pop    %ebx
  8030e8:	5e                   	pop    %esi
  8030e9:	5f                   	pop    %edi
  8030ea:	5d                   	pop    %ebp
  8030eb:	c3                   	ret    
  8030ec:	bd 20 00 00 00       	mov    $0x20,%ebp
  8030f1:	89 eb                	mov    %ebp,%ebx
  8030f3:	29 fb                	sub    %edi,%ebx
  8030f5:	89 f9                	mov    %edi,%ecx
  8030f7:	d3 e6                	shl    %cl,%esi
  8030f9:	89 c5                	mov    %eax,%ebp
  8030fb:	88 d9                	mov    %bl,%cl
  8030fd:	d3 ed                	shr    %cl,%ebp
  8030ff:	89 e9                	mov    %ebp,%ecx
  803101:	09 f1                	or     %esi,%ecx
  803103:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803107:	89 f9                	mov    %edi,%ecx
  803109:	d3 e0                	shl    %cl,%eax
  80310b:	89 c5                	mov    %eax,%ebp
  80310d:	89 d6                	mov    %edx,%esi
  80310f:	88 d9                	mov    %bl,%cl
  803111:	d3 ee                	shr    %cl,%esi
  803113:	89 f9                	mov    %edi,%ecx
  803115:	d3 e2                	shl    %cl,%edx
  803117:	8b 44 24 08          	mov    0x8(%esp),%eax
  80311b:	88 d9                	mov    %bl,%cl
  80311d:	d3 e8                	shr    %cl,%eax
  80311f:	09 c2                	or     %eax,%edx
  803121:	89 d0                	mov    %edx,%eax
  803123:	89 f2                	mov    %esi,%edx
  803125:	f7 74 24 0c          	divl   0xc(%esp)
  803129:	89 d6                	mov    %edx,%esi
  80312b:	89 c3                	mov    %eax,%ebx
  80312d:	f7 e5                	mul    %ebp
  80312f:	39 d6                	cmp    %edx,%esi
  803131:	72 19                	jb     80314c <__udivdi3+0xfc>
  803133:	74 0b                	je     803140 <__udivdi3+0xf0>
  803135:	89 d8                	mov    %ebx,%eax
  803137:	31 ff                	xor    %edi,%edi
  803139:	e9 58 ff ff ff       	jmp    803096 <__udivdi3+0x46>
  80313e:	66 90                	xchg   %ax,%ax
  803140:	8b 54 24 08          	mov    0x8(%esp),%edx
  803144:	89 f9                	mov    %edi,%ecx
  803146:	d3 e2                	shl    %cl,%edx
  803148:	39 c2                	cmp    %eax,%edx
  80314a:	73 e9                	jae    803135 <__udivdi3+0xe5>
  80314c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80314f:	31 ff                	xor    %edi,%edi
  803151:	e9 40 ff ff ff       	jmp    803096 <__udivdi3+0x46>
  803156:	66 90                	xchg   %ax,%ax
  803158:	31 c0                	xor    %eax,%eax
  80315a:	e9 37 ff ff ff       	jmp    803096 <__udivdi3+0x46>
  80315f:	90                   	nop

00803160 <__umoddi3>:
  803160:	55                   	push   %ebp
  803161:	57                   	push   %edi
  803162:	56                   	push   %esi
  803163:	53                   	push   %ebx
  803164:	83 ec 1c             	sub    $0x1c,%esp
  803167:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80316b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80316f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803173:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803177:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80317b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80317f:	89 f3                	mov    %esi,%ebx
  803181:	89 fa                	mov    %edi,%edx
  803183:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803187:	89 34 24             	mov    %esi,(%esp)
  80318a:	85 c0                	test   %eax,%eax
  80318c:	75 1a                	jne    8031a8 <__umoddi3+0x48>
  80318e:	39 f7                	cmp    %esi,%edi
  803190:	0f 86 a2 00 00 00    	jbe    803238 <__umoddi3+0xd8>
  803196:	89 c8                	mov    %ecx,%eax
  803198:	89 f2                	mov    %esi,%edx
  80319a:	f7 f7                	div    %edi
  80319c:	89 d0                	mov    %edx,%eax
  80319e:	31 d2                	xor    %edx,%edx
  8031a0:	83 c4 1c             	add    $0x1c,%esp
  8031a3:	5b                   	pop    %ebx
  8031a4:	5e                   	pop    %esi
  8031a5:	5f                   	pop    %edi
  8031a6:	5d                   	pop    %ebp
  8031a7:	c3                   	ret    
  8031a8:	39 f0                	cmp    %esi,%eax
  8031aa:	0f 87 ac 00 00 00    	ja     80325c <__umoddi3+0xfc>
  8031b0:	0f bd e8             	bsr    %eax,%ebp
  8031b3:	83 f5 1f             	xor    $0x1f,%ebp
  8031b6:	0f 84 ac 00 00 00    	je     803268 <__umoddi3+0x108>
  8031bc:	bf 20 00 00 00       	mov    $0x20,%edi
  8031c1:	29 ef                	sub    %ebp,%edi
  8031c3:	89 fe                	mov    %edi,%esi
  8031c5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8031c9:	89 e9                	mov    %ebp,%ecx
  8031cb:	d3 e0                	shl    %cl,%eax
  8031cd:	89 d7                	mov    %edx,%edi
  8031cf:	89 f1                	mov    %esi,%ecx
  8031d1:	d3 ef                	shr    %cl,%edi
  8031d3:	09 c7                	or     %eax,%edi
  8031d5:	89 e9                	mov    %ebp,%ecx
  8031d7:	d3 e2                	shl    %cl,%edx
  8031d9:	89 14 24             	mov    %edx,(%esp)
  8031dc:	89 d8                	mov    %ebx,%eax
  8031de:	d3 e0                	shl    %cl,%eax
  8031e0:	89 c2                	mov    %eax,%edx
  8031e2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031e6:	d3 e0                	shl    %cl,%eax
  8031e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031ec:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031f0:	89 f1                	mov    %esi,%ecx
  8031f2:	d3 e8                	shr    %cl,%eax
  8031f4:	09 d0                	or     %edx,%eax
  8031f6:	d3 eb                	shr    %cl,%ebx
  8031f8:	89 da                	mov    %ebx,%edx
  8031fa:	f7 f7                	div    %edi
  8031fc:	89 d3                	mov    %edx,%ebx
  8031fe:	f7 24 24             	mull   (%esp)
  803201:	89 c6                	mov    %eax,%esi
  803203:	89 d1                	mov    %edx,%ecx
  803205:	39 d3                	cmp    %edx,%ebx
  803207:	0f 82 87 00 00 00    	jb     803294 <__umoddi3+0x134>
  80320d:	0f 84 91 00 00 00    	je     8032a4 <__umoddi3+0x144>
  803213:	8b 54 24 04          	mov    0x4(%esp),%edx
  803217:	29 f2                	sub    %esi,%edx
  803219:	19 cb                	sbb    %ecx,%ebx
  80321b:	89 d8                	mov    %ebx,%eax
  80321d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803221:	d3 e0                	shl    %cl,%eax
  803223:	89 e9                	mov    %ebp,%ecx
  803225:	d3 ea                	shr    %cl,%edx
  803227:	09 d0                	or     %edx,%eax
  803229:	89 e9                	mov    %ebp,%ecx
  80322b:	d3 eb                	shr    %cl,%ebx
  80322d:	89 da                	mov    %ebx,%edx
  80322f:	83 c4 1c             	add    $0x1c,%esp
  803232:	5b                   	pop    %ebx
  803233:	5e                   	pop    %esi
  803234:	5f                   	pop    %edi
  803235:	5d                   	pop    %ebp
  803236:	c3                   	ret    
  803237:	90                   	nop
  803238:	89 fd                	mov    %edi,%ebp
  80323a:	85 ff                	test   %edi,%edi
  80323c:	75 0b                	jne    803249 <__umoddi3+0xe9>
  80323e:	b8 01 00 00 00       	mov    $0x1,%eax
  803243:	31 d2                	xor    %edx,%edx
  803245:	f7 f7                	div    %edi
  803247:	89 c5                	mov    %eax,%ebp
  803249:	89 f0                	mov    %esi,%eax
  80324b:	31 d2                	xor    %edx,%edx
  80324d:	f7 f5                	div    %ebp
  80324f:	89 c8                	mov    %ecx,%eax
  803251:	f7 f5                	div    %ebp
  803253:	89 d0                	mov    %edx,%eax
  803255:	e9 44 ff ff ff       	jmp    80319e <__umoddi3+0x3e>
  80325a:	66 90                	xchg   %ax,%ax
  80325c:	89 c8                	mov    %ecx,%eax
  80325e:	89 f2                	mov    %esi,%edx
  803260:	83 c4 1c             	add    $0x1c,%esp
  803263:	5b                   	pop    %ebx
  803264:	5e                   	pop    %esi
  803265:	5f                   	pop    %edi
  803266:	5d                   	pop    %ebp
  803267:	c3                   	ret    
  803268:	3b 04 24             	cmp    (%esp),%eax
  80326b:	72 06                	jb     803273 <__umoddi3+0x113>
  80326d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803271:	77 0f                	ja     803282 <__umoddi3+0x122>
  803273:	89 f2                	mov    %esi,%edx
  803275:	29 f9                	sub    %edi,%ecx
  803277:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80327b:	89 14 24             	mov    %edx,(%esp)
  80327e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803282:	8b 44 24 04          	mov    0x4(%esp),%eax
  803286:	8b 14 24             	mov    (%esp),%edx
  803289:	83 c4 1c             	add    $0x1c,%esp
  80328c:	5b                   	pop    %ebx
  80328d:	5e                   	pop    %esi
  80328e:	5f                   	pop    %edi
  80328f:	5d                   	pop    %ebp
  803290:	c3                   	ret    
  803291:	8d 76 00             	lea    0x0(%esi),%esi
  803294:	2b 04 24             	sub    (%esp),%eax
  803297:	19 fa                	sbb    %edi,%edx
  803299:	89 d1                	mov    %edx,%ecx
  80329b:	89 c6                	mov    %eax,%esi
  80329d:	e9 71 ff ff ff       	jmp    803213 <__umoddi3+0xb3>
  8032a2:	66 90                	xchg   %ax,%ax
  8032a4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8032a8:	72 ea                	jb     803294 <__umoddi3+0x134>
  8032aa:	89 d9                	mov    %ebx,%ecx
  8032ac:	e9 62 ff ff ff       	jmp    803213 <__umoddi3+0xb3>
