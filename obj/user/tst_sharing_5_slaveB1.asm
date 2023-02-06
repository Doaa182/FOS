
obj/user/tst_sharing_5_slaveB1:     file format elf32-i386


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
  800031:	e8 1e 01 00 00       	call   800154 <libmain>
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
  80008c:	68 e0 32 80 00       	push   $0x8032e0
  800091:	6a 12                	push   $0x12
  800093:	68 fc 32 80 00       	push   $0x8032fc
  800098:	e8 f3 01 00 00       	call   800290 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009d:	83 ec 0c             	sub    $0xc,%esp
  8000a0:	6a 00                	push   $0x0
  8000a2:	e8 16 14 00 00       	call   8014bd <malloc>
  8000a7:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	uint32 *x;
	x = sget(sys_getparentenvid(),"x");
  8000aa:	e8 46 1b 00 00       	call   801bf5 <sys_getparentenvid>
  8000af:	83 ec 08             	sub    $0x8,%esp
  8000b2:	68 19 33 80 00       	push   $0x803319
  8000b7:	50                   	push   %eax
  8000b8:	e8 1a 16 00 00       	call   8016d7 <sget>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B1 env used x (getSharedObject)\n");
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	68 1c 33 80 00       	push   $0x80331c
  8000cb:	e8 74 04 00 00       	call   800544 <cprintf>
  8000d0:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's successfully got x
	inctst();
  8000d3:	e8 42 1c 00 00       	call   801d1a <inctst>
	cprintf("Slave B1 please be patient ...\n");
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	68 44 33 80 00       	push   $0x803344
  8000e0:	e8 5f 04 00 00       	call   800544 <cprintf>
  8000e5:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z
	env_sleep(6000);
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	68 70 17 00 00       	push   $0x1770
  8000f0:	e8 be 2e 00 00       	call   802fb3 <env_sleep>
  8000f5:	83 c4 10             	add    $0x10,%esp

	int freeFrames = sys_calculate_free_frames() ;
  8000f8:	e8 ff 17 00 00       	call   8018fc <sys_calculate_free_frames>
  8000fd:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(x);
  800100:	83 ec 0c             	sub    $0xc,%esp
  800103:	ff 75 ec             	pushl  -0x14(%ebp)
  800106:	e8 91 16 00 00       	call   80179c <sfree>
  80010b:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B1 env removed x\n");
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	68 64 33 80 00       	push   $0x803364
  800116:	e8 29 04 00 00       	call   800544 <cprintf>
  80011b:	83 c4 10             	add    $0x10,%esp
	int expected = (1+1) + (1+1);
  80011e:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
	if ((sys_calculate_free_frames() - freeFrames) !=  expected) panic("B1 wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table and 1 for frame of x\nframes_storage of x: should be cleared now\n");
  800125:	e8 d2 17 00 00       	call   8018fc <sys_calculate_free_frames>
  80012a:	89 c2                	mov    %eax,%edx
  80012c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80012f:	29 c2                	sub    %eax,%edx
  800131:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800134:	39 c2                	cmp    %eax,%edx
  800136:	74 14                	je     80014c <_main+0x114>
  800138:	83 ec 04             	sub    $0x4,%esp
  80013b:	68 7c 33 80 00       	push   $0x80337c
  800140:	6a 27                	push   $0x27
  800142:	68 fc 32 80 00       	push   $0x8032fc
  800147:	e8 44 01 00 00       	call   800290 <_panic>

	//To indicate that it's completed successfully
	inctst();
  80014c:	e8 c9 1b 00 00       	call   801d1a <inctst>
	return;
  800151:	90                   	nop
}
  800152:	c9                   	leave  
  800153:	c3                   	ret    

00800154 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800154:	55                   	push   %ebp
  800155:	89 e5                	mov    %esp,%ebp
  800157:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80015a:	e8 7d 1a 00 00       	call   801bdc <sys_getenvindex>
  80015f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800162:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800165:	89 d0                	mov    %edx,%eax
  800167:	c1 e0 03             	shl    $0x3,%eax
  80016a:	01 d0                	add    %edx,%eax
  80016c:	01 c0                	add    %eax,%eax
  80016e:	01 d0                	add    %edx,%eax
  800170:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800177:	01 d0                	add    %edx,%eax
  800179:	c1 e0 04             	shl    $0x4,%eax
  80017c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800181:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800186:	a1 20 40 80 00       	mov    0x804020,%eax
  80018b:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800191:	84 c0                	test   %al,%al
  800193:	74 0f                	je     8001a4 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800195:	a1 20 40 80 00       	mov    0x804020,%eax
  80019a:	05 5c 05 00 00       	add    $0x55c,%eax
  80019f:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001a8:	7e 0a                	jle    8001b4 <libmain+0x60>
		binaryname = argv[0];
  8001aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ad:	8b 00                	mov    (%eax),%eax
  8001af:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001b4:	83 ec 08             	sub    $0x8,%esp
  8001b7:	ff 75 0c             	pushl  0xc(%ebp)
  8001ba:	ff 75 08             	pushl  0x8(%ebp)
  8001bd:	e8 76 fe ff ff       	call   800038 <_main>
  8001c2:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001c5:	e8 1f 18 00 00       	call   8019e9 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001ca:	83 ec 0c             	sub    $0xc,%esp
  8001cd:	68 3c 34 80 00       	push   $0x80343c
  8001d2:	e8 6d 03 00 00       	call   800544 <cprintf>
  8001d7:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001da:	a1 20 40 80 00       	mov    0x804020,%eax
  8001df:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001e5:	a1 20 40 80 00       	mov    0x804020,%eax
  8001ea:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001f0:	83 ec 04             	sub    $0x4,%esp
  8001f3:	52                   	push   %edx
  8001f4:	50                   	push   %eax
  8001f5:	68 64 34 80 00       	push   $0x803464
  8001fa:	e8 45 03 00 00       	call   800544 <cprintf>
  8001ff:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800202:	a1 20 40 80 00       	mov    0x804020,%eax
  800207:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80020d:	a1 20 40 80 00       	mov    0x804020,%eax
  800212:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800218:	a1 20 40 80 00       	mov    0x804020,%eax
  80021d:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800223:	51                   	push   %ecx
  800224:	52                   	push   %edx
  800225:	50                   	push   %eax
  800226:	68 8c 34 80 00       	push   $0x80348c
  80022b:	e8 14 03 00 00       	call   800544 <cprintf>
  800230:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800233:	a1 20 40 80 00       	mov    0x804020,%eax
  800238:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80023e:	83 ec 08             	sub    $0x8,%esp
  800241:	50                   	push   %eax
  800242:	68 e4 34 80 00       	push   $0x8034e4
  800247:	e8 f8 02 00 00       	call   800544 <cprintf>
  80024c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	68 3c 34 80 00       	push   $0x80343c
  800257:	e8 e8 02 00 00       	call   800544 <cprintf>
  80025c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80025f:	e8 9f 17 00 00       	call   801a03 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800264:	e8 19 00 00 00       	call   800282 <exit>
}
  800269:	90                   	nop
  80026a:	c9                   	leave  
  80026b:	c3                   	ret    

0080026c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80026c:	55                   	push   %ebp
  80026d:	89 e5                	mov    %esp,%ebp
  80026f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800272:	83 ec 0c             	sub    $0xc,%esp
  800275:	6a 00                	push   $0x0
  800277:	e8 2c 19 00 00       	call   801ba8 <sys_destroy_env>
  80027c:	83 c4 10             	add    $0x10,%esp
}
  80027f:	90                   	nop
  800280:	c9                   	leave  
  800281:	c3                   	ret    

00800282 <exit>:

void
exit(void)
{
  800282:	55                   	push   %ebp
  800283:	89 e5                	mov    %esp,%ebp
  800285:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800288:	e8 81 19 00 00       	call   801c0e <sys_exit_env>
}
  80028d:	90                   	nop
  80028e:	c9                   	leave  
  80028f:	c3                   	ret    

00800290 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800290:	55                   	push   %ebp
  800291:	89 e5                	mov    %esp,%ebp
  800293:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800296:	8d 45 10             	lea    0x10(%ebp),%eax
  800299:	83 c0 04             	add    $0x4,%eax
  80029c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80029f:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002a4:	85 c0                	test   %eax,%eax
  8002a6:	74 16                	je     8002be <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002a8:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002ad:	83 ec 08             	sub    $0x8,%esp
  8002b0:	50                   	push   %eax
  8002b1:	68 f8 34 80 00       	push   $0x8034f8
  8002b6:	e8 89 02 00 00       	call   800544 <cprintf>
  8002bb:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002be:	a1 00 40 80 00       	mov    0x804000,%eax
  8002c3:	ff 75 0c             	pushl  0xc(%ebp)
  8002c6:	ff 75 08             	pushl  0x8(%ebp)
  8002c9:	50                   	push   %eax
  8002ca:	68 fd 34 80 00       	push   $0x8034fd
  8002cf:	e8 70 02 00 00       	call   800544 <cprintf>
  8002d4:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8002da:	83 ec 08             	sub    $0x8,%esp
  8002dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8002e0:	50                   	push   %eax
  8002e1:	e8 f3 01 00 00       	call   8004d9 <vcprintf>
  8002e6:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002e9:	83 ec 08             	sub    $0x8,%esp
  8002ec:	6a 00                	push   $0x0
  8002ee:	68 19 35 80 00       	push   $0x803519
  8002f3:	e8 e1 01 00 00       	call   8004d9 <vcprintf>
  8002f8:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002fb:	e8 82 ff ff ff       	call   800282 <exit>

	// should not return here
	while (1) ;
  800300:	eb fe                	jmp    800300 <_panic+0x70>

00800302 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800302:	55                   	push   %ebp
  800303:	89 e5                	mov    %esp,%ebp
  800305:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800308:	a1 20 40 80 00       	mov    0x804020,%eax
  80030d:	8b 50 74             	mov    0x74(%eax),%edx
  800310:	8b 45 0c             	mov    0xc(%ebp),%eax
  800313:	39 c2                	cmp    %eax,%edx
  800315:	74 14                	je     80032b <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800317:	83 ec 04             	sub    $0x4,%esp
  80031a:	68 1c 35 80 00       	push   $0x80351c
  80031f:	6a 26                	push   $0x26
  800321:	68 68 35 80 00       	push   $0x803568
  800326:	e8 65 ff ff ff       	call   800290 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80032b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800332:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800339:	e9 c2 00 00 00       	jmp    800400 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80033e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800341:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800348:	8b 45 08             	mov    0x8(%ebp),%eax
  80034b:	01 d0                	add    %edx,%eax
  80034d:	8b 00                	mov    (%eax),%eax
  80034f:	85 c0                	test   %eax,%eax
  800351:	75 08                	jne    80035b <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800353:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800356:	e9 a2 00 00 00       	jmp    8003fd <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80035b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800362:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800369:	eb 69                	jmp    8003d4 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80036b:	a1 20 40 80 00       	mov    0x804020,%eax
  800370:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800376:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800379:	89 d0                	mov    %edx,%eax
  80037b:	01 c0                	add    %eax,%eax
  80037d:	01 d0                	add    %edx,%eax
  80037f:	c1 e0 03             	shl    $0x3,%eax
  800382:	01 c8                	add    %ecx,%eax
  800384:	8a 40 04             	mov    0x4(%eax),%al
  800387:	84 c0                	test   %al,%al
  800389:	75 46                	jne    8003d1 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80038b:	a1 20 40 80 00       	mov    0x804020,%eax
  800390:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800396:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800399:	89 d0                	mov    %edx,%eax
  80039b:	01 c0                	add    %eax,%eax
  80039d:	01 d0                	add    %edx,%eax
  80039f:	c1 e0 03             	shl    $0x3,%eax
  8003a2:	01 c8                	add    %ecx,%eax
  8003a4:	8b 00                	mov    (%eax),%eax
  8003a6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003b1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003b6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c0:	01 c8                	add    %ecx,%eax
  8003c2:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003c4:	39 c2                	cmp    %eax,%edx
  8003c6:	75 09                	jne    8003d1 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003c8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003cf:	eb 12                	jmp    8003e3 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003d1:	ff 45 e8             	incl   -0x18(%ebp)
  8003d4:	a1 20 40 80 00       	mov    0x804020,%eax
  8003d9:	8b 50 74             	mov    0x74(%eax),%edx
  8003dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003df:	39 c2                	cmp    %eax,%edx
  8003e1:	77 88                	ja     80036b <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003e3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003e7:	75 14                	jne    8003fd <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003e9:	83 ec 04             	sub    $0x4,%esp
  8003ec:	68 74 35 80 00       	push   $0x803574
  8003f1:	6a 3a                	push   $0x3a
  8003f3:	68 68 35 80 00       	push   $0x803568
  8003f8:	e8 93 fe ff ff       	call   800290 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003fd:	ff 45 f0             	incl   -0x10(%ebp)
  800400:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800403:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800406:	0f 8c 32 ff ff ff    	jl     80033e <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80040c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800413:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80041a:	eb 26                	jmp    800442 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80041c:	a1 20 40 80 00       	mov    0x804020,%eax
  800421:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800427:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80042a:	89 d0                	mov    %edx,%eax
  80042c:	01 c0                	add    %eax,%eax
  80042e:	01 d0                	add    %edx,%eax
  800430:	c1 e0 03             	shl    $0x3,%eax
  800433:	01 c8                	add    %ecx,%eax
  800435:	8a 40 04             	mov    0x4(%eax),%al
  800438:	3c 01                	cmp    $0x1,%al
  80043a:	75 03                	jne    80043f <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80043c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80043f:	ff 45 e0             	incl   -0x20(%ebp)
  800442:	a1 20 40 80 00       	mov    0x804020,%eax
  800447:	8b 50 74             	mov    0x74(%eax),%edx
  80044a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80044d:	39 c2                	cmp    %eax,%edx
  80044f:	77 cb                	ja     80041c <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800451:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800454:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800457:	74 14                	je     80046d <CheckWSWithoutLastIndex+0x16b>
		panic(
  800459:	83 ec 04             	sub    $0x4,%esp
  80045c:	68 c8 35 80 00       	push   $0x8035c8
  800461:	6a 44                	push   $0x44
  800463:	68 68 35 80 00       	push   $0x803568
  800468:	e8 23 fe ff ff       	call   800290 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80046d:	90                   	nop
  80046e:	c9                   	leave  
  80046f:	c3                   	ret    

00800470 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800470:	55                   	push   %ebp
  800471:	89 e5                	mov    %esp,%ebp
  800473:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800476:	8b 45 0c             	mov    0xc(%ebp),%eax
  800479:	8b 00                	mov    (%eax),%eax
  80047b:	8d 48 01             	lea    0x1(%eax),%ecx
  80047e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800481:	89 0a                	mov    %ecx,(%edx)
  800483:	8b 55 08             	mov    0x8(%ebp),%edx
  800486:	88 d1                	mov    %dl,%cl
  800488:	8b 55 0c             	mov    0xc(%ebp),%edx
  80048b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80048f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800492:	8b 00                	mov    (%eax),%eax
  800494:	3d ff 00 00 00       	cmp    $0xff,%eax
  800499:	75 2c                	jne    8004c7 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80049b:	a0 24 40 80 00       	mov    0x804024,%al
  8004a0:	0f b6 c0             	movzbl %al,%eax
  8004a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a6:	8b 12                	mov    (%edx),%edx
  8004a8:	89 d1                	mov    %edx,%ecx
  8004aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ad:	83 c2 08             	add    $0x8,%edx
  8004b0:	83 ec 04             	sub    $0x4,%esp
  8004b3:	50                   	push   %eax
  8004b4:	51                   	push   %ecx
  8004b5:	52                   	push   %edx
  8004b6:	e8 80 13 00 00       	call   80183b <sys_cputs>
  8004bb:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ca:	8b 40 04             	mov    0x4(%eax),%eax
  8004cd:	8d 50 01             	lea    0x1(%eax),%edx
  8004d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004d6:	90                   	nop
  8004d7:	c9                   	leave  
  8004d8:	c3                   	ret    

008004d9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004d9:	55                   	push   %ebp
  8004da:	89 e5                	mov    %esp,%ebp
  8004dc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004e2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004e9:	00 00 00 
	b.cnt = 0;
  8004ec:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004f3:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004f6:	ff 75 0c             	pushl  0xc(%ebp)
  8004f9:	ff 75 08             	pushl  0x8(%ebp)
  8004fc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800502:	50                   	push   %eax
  800503:	68 70 04 80 00       	push   $0x800470
  800508:	e8 11 02 00 00       	call   80071e <vprintfmt>
  80050d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800510:	a0 24 40 80 00       	mov    0x804024,%al
  800515:	0f b6 c0             	movzbl %al,%eax
  800518:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80051e:	83 ec 04             	sub    $0x4,%esp
  800521:	50                   	push   %eax
  800522:	52                   	push   %edx
  800523:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800529:	83 c0 08             	add    $0x8,%eax
  80052c:	50                   	push   %eax
  80052d:	e8 09 13 00 00       	call   80183b <sys_cputs>
  800532:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800535:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80053c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800542:	c9                   	leave  
  800543:	c3                   	ret    

00800544 <cprintf>:

int cprintf(const char *fmt, ...) {
  800544:	55                   	push   %ebp
  800545:	89 e5                	mov    %esp,%ebp
  800547:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80054a:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800551:	8d 45 0c             	lea    0xc(%ebp),%eax
  800554:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800557:	8b 45 08             	mov    0x8(%ebp),%eax
  80055a:	83 ec 08             	sub    $0x8,%esp
  80055d:	ff 75 f4             	pushl  -0xc(%ebp)
  800560:	50                   	push   %eax
  800561:	e8 73 ff ff ff       	call   8004d9 <vcprintf>
  800566:	83 c4 10             	add    $0x10,%esp
  800569:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80056c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80056f:	c9                   	leave  
  800570:	c3                   	ret    

00800571 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800571:	55                   	push   %ebp
  800572:	89 e5                	mov    %esp,%ebp
  800574:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800577:	e8 6d 14 00 00       	call   8019e9 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80057c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80057f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800582:	8b 45 08             	mov    0x8(%ebp),%eax
  800585:	83 ec 08             	sub    $0x8,%esp
  800588:	ff 75 f4             	pushl  -0xc(%ebp)
  80058b:	50                   	push   %eax
  80058c:	e8 48 ff ff ff       	call   8004d9 <vcprintf>
  800591:	83 c4 10             	add    $0x10,%esp
  800594:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800597:	e8 67 14 00 00       	call   801a03 <sys_enable_interrupt>
	return cnt;
  80059c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80059f:	c9                   	leave  
  8005a0:	c3                   	ret    

008005a1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005a1:	55                   	push   %ebp
  8005a2:	89 e5                	mov    %esp,%ebp
  8005a4:	53                   	push   %ebx
  8005a5:	83 ec 14             	sub    $0x14,%esp
  8005a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005b4:	8b 45 18             	mov    0x18(%ebp),%eax
  8005b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8005bc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005bf:	77 55                	ja     800616 <printnum+0x75>
  8005c1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005c4:	72 05                	jb     8005cb <printnum+0x2a>
  8005c6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005c9:	77 4b                	ja     800616 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005cb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005ce:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005d1:	8b 45 18             	mov    0x18(%ebp),%eax
  8005d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d9:	52                   	push   %edx
  8005da:	50                   	push   %eax
  8005db:	ff 75 f4             	pushl  -0xc(%ebp)
  8005de:	ff 75 f0             	pushl  -0x10(%ebp)
  8005e1:	e8 82 2a 00 00       	call   803068 <__udivdi3>
  8005e6:	83 c4 10             	add    $0x10,%esp
  8005e9:	83 ec 04             	sub    $0x4,%esp
  8005ec:	ff 75 20             	pushl  0x20(%ebp)
  8005ef:	53                   	push   %ebx
  8005f0:	ff 75 18             	pushl  0x18(%ebp)
  8005f3:	52                   	push   %edx
  8005f4:	50                   	push   %eax
  8005f5:	ff 75 0c             	pushl  0xc(%ebp)
  8005f8:	ff 75 08             	pushl  0x8(%ebp)
  8005fb:	e8 a1 ff ff ff       	call   8005a1 <printnum>
  800600:	83 c4 20             	add    $0x20,%esp
  800603:	eb 1a                	jmp    80061f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800605:	83 ec 08             	sub    $0x8,%esp
  800608:	ff 75 0c             	pushl  0xc(%ebp)
  80060b:	ff 75 20             	pushl  0x20(%ebp)
  80060e:	8b 45 08             	mov    0x8(%ebp),%eax
  800611:	ff d0                	call   *%eax
  800613:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800616:	ff 4d 1c             	decl   0x1c(%ebp)
  800619:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80061d:	7f e6                	jg     800605 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80061f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800622:	bb 00 00 00 00       	mov    $0x0,%ebx
  800627:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80062a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80062d:	53                   	push   %ebx
  80062e:	51                   	push   %ecx
  80062f:	52                   	push   %edx
  800630:	50                   	push   %eax
  800631:	e8 42 2b 00 00       	call   803178 <__umoddi3>
  800636:	83 c4 10             	add    $0x10,%esp
  800639:	05 34 38 80 00       	add    $0x803834,%eax
  80063e:	8a 00                	mov    (%eax),%al
  800640:	0f be c0             	movsbl %al,%eax
  800643:	83 ec 08             	sub    $0x8,%esp
  800646:	ff 75 0c             	pushl  0xc(%ebp)
  800649:	50                   	push   %eax
  80064a:	8b 45 08             	mov    0x8(%ebp),%eax
  80064d:	ff d0                	call   *%eax
  80064f:	83 c4 10             	add    $0x10,%esp
}
  800652:	90                   	nop
  800653:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800656:	c9                   	leave  
  800657:	c3                   	ret    

00800658 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800658:	55                   	push   %ebp
  800659:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80065b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80065f:	7e 1c                	jle    80067d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800661:	8b 45 08             	mov    0x8(%ebp),%eax
  800664:	8b 00                	mov    (%eax),%eax
  800666:	8d 50 08             	lea    0x8(%eax),%edx
  800669:	8b 45 08             	mov    0x8(%ebp),%eax
  80066c:	89 10                	mov    %edx,(%eax)
  80066e:	8b 45 08             	mov    0x8(%ebp),%eax
  800671:	8b 00                	mov    (%eax),%eax
  800673:	83 e8 08             	sub    $0x8,%eax
  800676:	8b 50 04             	mov    0x4(%eax),%edx
  800679:	8b 00                	mov    (%eax),%eax
  80067b:	eb 40                	jmp    8006bd <getuint+0x65>
	else if (lflag)
  80067d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800681:	74 1e                	je     8006a1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800683:	8b 45 08             	mov    0x8(%ebp),%eax
  800686:	8b 00                	mov    (%eax),%eax
  800688:	8d 50 04             	lea    0x4(%eax),%edx
  80068b:	8b 45 08             	mov    0x8(%ebp),%eax
  80068e:	89 10                	mov    %edx,(%eax)
  800690:	8b 45 08             	mov    0x8(%ebp),%eax
  800693:	8b 00                	mov    (%eax),%eax
  800695:	83 e8 04             	sub    $0x4,%eax
  800698:	8b 00                	mov    (%eax),%eax
  80069a:	ba 00 00 00 00       	mov    $0x0,%edx
  80069f:	eb 1c                	jmp    8006bd <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a4:	8b 00                	mov    (%eax),%eax
  8006a6:	8d 50 04             	lea    0x4(%eax),%edx
  8006a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ac:	89 10                	mov    %edx,(%eax)
  8006ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b1:	8b 00                	mov    (%eax),%eax
  8006b3:	83 e8 04             	sub    $0x4,%eax
  8006b6:	8b 00                	mov    (%eax),%eax
  8006b8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006bd:	5d                   	pop    %ebp
  8006be:	c3                   	ret    

008006bf <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006bf:	55                   	push   %ebp
  8006c0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006c2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006c6:	7e 1c                	jle    8006e4 <getint+0x25>
		return va_arg(*ap, long long);
  8006c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cb:	8b 00                	mov    (%eax),%eax
  8006cd:	8d 50 08             	lea    0x8(%eax),%edx
  8006d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d3:	89 10                	mov    %edx,(%eax)
  8006d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d8:	8b 00                	mov    (%eax),%eax
  8006da:	83 e8 08             	sub    $0x8,%eax
  8006dd:	8b 50 04             	mov    0x4(%eax),%edx
  8006e0:	8b 00                	mov    (%eax),%eax
  8006e2:	eb 38                	jmp    80071c <getint+0x5d>
	else if (lflag)
  8006e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006e8:	74 1a                	je     800704 <getint+0x45>
		return va_arg(*ap, long);
  8006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ed:	8b 00                	mov    (%eax),%eax
  8006ef:	8d 50 04             	lea    0x4(%eax),%edx
  8006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f5:	89 10                	mov    %edx,(%eax)
  8006f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	83 e8 04             	sub    $0x4,%eax
  8006ff:	8b 00                	mov    (%eax),%eax
  800701:	99                   	cltd   
  800702:	eb 18                	jmp    80071c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800704:	8b 45 08             	mov    0x8(%ebp),%eax
  800707:	8b 00                	mov    (%eax),%eax
  800709:	8d 50 04             	lea    0x4(%eax),%edx
  80070c:	8b 45 08             	mov    0x8(%ebp),%eax
  80070f:	89 10                	mov    %edx,(%eax)
  800711:	8b 45 08             	mov    0x8(%ebp),%eax
  800714:	8b 00                	mov    (%eax),%eax
  800716:	83 e8 04             	sub    $0x4,%eax
  800719:	8b 00                	mov    (%eax),%eax
  80071b:	99                   	cltd   
}
  80071c:	5d                   	pop    %ebp
  80071d:	c3                   	ret    

0080071e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80071e:	55                   	push   %ebp
  80071f:	89 e5                	mov    %esp,%ebp
  800721:	56                   	push   %esi
  800722:	53                   	push   %ebx
  800723:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800726:	eb 17                	jmp    80073f <vprintfmt+0x21>
			if (ch == '\0')
  800728:	85 db                	test   %ebx,%ebx
  80072a:	0f 84 af 03 00 00    	je     800adf <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800730:	83 ec 08             	sub    $0x8,%esp
  800733:	ff 75 0c             	pushl  0xc(%ebp)
  800736:	53                   	push   %ebx
  800737:	8b 45 08             	mov    0x8(%ebp),%eax
  80073a:	ff d0                	call   *%eax
  80073c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80073f:	8b 45 10             	mov    0x10(%ebp),%eax
  800742:	8d 50 01             	lea    0x1(%eax),%edx
  800745:	89 55 10             	mov    %edx,0x10(%ebp)
  800748:	8a 00                	mov    (%eax),%al
  80074a:	0f b6 d8             	movzbl %al,%ebx
  80074d:	83 fb 25             	cmp    $0x25,%ebx
  800750:	75 d6                	jne    800728 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800752:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800756:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80075d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800764:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80076b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800772:	8b 45 10             	mov    0x10(%ebp),%eax
  800775:	8d 50 01             	lea    0x1(%eax),%edx
  800778:	89 55 10             	mov    %edx,0x10(%ebp)
  80077b:	8a 00                	mov    (%eax),%al
  80077d:	0f b6 d8             	movzbl %al,%ebx
  800780:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800783:	83 f8 55             	cmp    $0x55,%eax
  800786:	0f 87 2b 03 00 00    	ja     800ab7 <vprintfmt+0x399>
  80078c:	8b 04 85 58 38 80 00 	mov    0x803858(,%eax,4),%eax
  800793:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800795:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800799:	eb d7                	jmp    800772 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80079b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80079f:	eb d1                	jmp    800772 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007a1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007a8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007ab:	89 d0                	mov    %edx,%eax
  8007ad:	c1 e0 02             	shl    $0x2,%eax
  8007b0:	01 d0                	add    %edx,%eax
  8007b2:	01 c0                	add    %eax,%eax
  8007b4:	01 d8                	add    %ebx,%eax
  8007b6:	83 e8 30             	sub    $0x30,%eax
  8007b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8007bf:	8a 00                	mov    (%eax),%al
  8007c1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007c4:	83 fb 2f             	cmp    $0x2f,%ebx
  8007c7:	7e 3e                	jle    800807 <vprintfmt+0xe9>
  8007c9:	83 fb 39             	cmp    $0x39,%ebx
  8007cc:	7f 39                	jg     800807 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007ce:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007d1:	eb d5                	jmp    8007a8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d6:	83 c0 04             	add    $0x4,%eax
  8007d9:	89 45 14             	mov    %eax,0x14(%ebp)
  8007dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007df:	83 e8 04             	sub    $0x4,%eax
  8007e2:	8b 00                	mov    (%eax),%eax
  8007e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007e7:	eb 1f                	jmp    800808 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ed:	79 83                	jns    800772 <vprintfmt+0x54>
				width = 0;
  8007ef:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007f6:	e9 77 ff ff ff       	jmp    800772 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007fb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800802:	e9 6b ff ff ff       	jmp    800772 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800807:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800808:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80080c:	0f 89 60 ff ff ff    	jns    800772 <vprintfmt+0x54>
				width = precision, precision = -1;
  800812:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800815:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800818:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80081f:	e9 4e ff ff ff       	jmp    800772 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800824:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800827:	e9 46 ff ff ff       	jmp    800772 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80082c:	8b 45 14             	mov    0x14(%ebp),%eax
  80082f:	83 c0 04             	add    $0x4,%eax
  800832:	89 45 14             	mov    %eax,0x14(%ebp)
  800835:	8b 45 14             	mov    0x14(%ebp),%eax
  800838:	83 e8 04             	sub    $0x4,%eax
  80083b:	8b 00                	mov    (%eax),%eax
  80083d:	83 ec 08             	sub    $0x8,%esp
  800840:	ff 75 0c             	pushl  0xc(%ebp)
  800843:	50                   	push   %eax
  800844:	8b 45 08             	mov    0x8(%ebp),%eax
  800847:	ff d0                	call   *%eax
  800849:	83 c4 10             	add    $0x10,%esp
			break;
  80084c:	e9 89 02 00 00       	jmp    800ada <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800851:	8b 45 14             	mov    0x14(%ebp),%eax
  800854:	83 c0 04             	add    $0x4,%eax
  800857:	89 45 14             	mov    %eax,0x14(%ebp)
  80085a:	8b 45 14             	mov    0x14(%ebp),%eax
  80085d:	83 e8 04             	sub    $0x4,%eax
  800860:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800862:	85 db                	test   %ebx,%ebx
  800864:	79 02                	jns    800868 <vprintfmt+0x14a>
				err = -err;
  800866:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800868:	83 fb 64             	cmp    $0x64,%ebx
  80086b:	7f 0b                	jg     800878 <vprintfmt+0x15a>
  80086d:	8b 34 9d a0 36 80 00 	mov    0x8036a0(,%ebx,4),%esi
  800874:	85 f6                	test   %esi,%esi
  800876:	75 19                	jne    800891 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800878:	53                   	push   %ebx
  800879:	68 45 38 80 00       	push   $0x803845
  80087e:	ff 75 0c             	pushl  0xc(%ebp)
  800881:	ff 75 08             	pushl  0x8(%ebp)
  800884:	e8 5e 02 00 00       	call   800ae7 <printfmt>
  800889:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80088c:	e9 49 02 00 00       	jmp    800ada <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800891:	56                   	push   %esi
  800892:	68 4e 38 80 00       	push   $0x80384e
  800897:	ff 75 0c             	pushl  0xc(%ebp)
  80089a:	ff 75 08             	pushl  0x8(%ebp)
  80089d:	e8 45 02 00 00       	call   800ae7 <printfmt>
  8008a2:	83 c4 10             	add    $0x10,%esp
			break;
  8008a5:	e9 30 02 00 00       	jmp    800ada <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ad:	83 c0 04             	add    $0x4,%eax
  8008b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b6:	83 e8 04             	sub    $0x4,%eax
  8008b9:	8b 30                	mov    (%eax),%esi
  8008bb:	85 f6                	test   %esi,%esi
  8008bd:	75 05                	jne    8008c4 <vprintfmt+0x1a6>
				p = "(null)";
  8008bf:	be 51 38 80 00       	mov    $0x803851,%esi
			if (width > 0 && padc != '-')
  8008c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008c8:	7e 6d                	jle    800937 <vprintfmt+0x219>
  8008ca:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008ce:	74 67                	je     800937 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008d3:	83 ec 08             	sub    $0x8,%esp
  8008d6:	50                   	push   %eax
  8008d7:	56                   	push   %esi
  8008d8:	e8 0c 03 00 00       	call   800be9 <strnlen>
  8008dd:	83 c4 10             	add    $0x10,%esp
  8008e0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008e3:	eb 16                	jmp    8008fb <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008e5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008e9:	83 ec 08             	sub    $0x8,%esp
  8008ec:	ff 75 0c             	pushl  0xc(%ebp)
  8008ef:	50                   	push   %eax
  8008f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f3:	ff d0                	call   *%eax
  8008f5:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008f8:	ff 4d e4             	decl   -0x1c(%ebp)
  8008fb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ff:	7f e4                	jg     8008e5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800901:	eb 34                	jmp    800937 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800903:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800907:	74 1c                	je     800925 <vprintfmt+0x207>
  800909:	83 fb 1f             	cmp    $0x1f,%ebx
  80090c:	7e 05                	jle    800913 <vprintfmt+0x1f5>
  80090e:	83 fb 7e             	cmp    $0x7e,%ebx
  800911:	7e 12                	jle    800925 <vprintfmt+0x207>
					putch('?', putdat);
  800913:	83 ec 08             	sub    $0x8,%esp
  800916:	ff 75 0c             	pushl  0xc(%ebp)
  800919:	6a 3f                	push   $0x3f
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	ff d0                	call   *%eax
  800920:	83 c4 10             	add    $0x10,%esp
  800923:	eb 0f                	jmp    800934 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800925:	83 ec 08             	sub    $0x8,%esp
  800928:	ff 75 0c             	pushl  0xc(%ebp)
  80092b:	53                   	push   %ebx
  80092c:	8b 45 08             	mov    0x8(%ebp),%eax
  80092f:	ff d0                	call   *%eax
  800931:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800934:	ff 4d e4             	decl   -0x1c(%ebp)
  800937:	89 f0                	mov    %esi,%eax
  800939:	8d 70 01             	lea    0x1(%eax),%esi
  80093c:	8a 00                	mov    (%eax),%al
  80093e:	0f be d8             	movsbl %al,%ebx
  800941:	85 db                	test   %ebx,%ebx
  800943:	74 24                	je     800969 <vprintfmt+0x24b>
  800945:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800949:	78 b8                	js     800903 <vprintfmt+0x1e5>
  80094b:	ff 4d e0             	decl   -0x20(%ebp)
  80094e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800952:	79 af                	jns    800903 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800954:	eb 13                	jmp    800969 <vprintfmt+0x24b>
				putch(' ', putdat);
  800956:	83 ec 08             	sub    $0x8,%esp
  800959:	ff 75 0c             	pushl  0xc(%ebp)
  80095c:	6a 20                	push   $0x20
  80095e:	8b 45 08             	mov    0x8(%ebp),%eax
  800961:	ff d0                	call   *%eax
  800963:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800966:	ff 4d e4             	decl   -0x1c(%ebp)
  800969:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80096d:	7f e7                	jg     800956 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80096f:	e9 66 01 00 00       	jmp    800ada <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800974:	83 ec 08             	sub    $0x8,%esp
  800977:	ff 75 e8             	pushl  -0x18(%ebp)
  80097a:	8d 45 14             	lea    0x14(%ebp),%eax
  80097d:	50                   	push   %eax
  80097e:	e8 3c fd ff ff       	call   8006bf <getint>
  800983:	83 c4 10             	add    $0x10,%esp
  800986:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800989:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80098c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80098f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800992:	85 d2                	test   %edx,%edx
  800994:	79 23                	jns    8009b9 <vprintfmt+0x29b>
				putch('-', putdat);
  800996:	83 ec 08             	sub    $0x8,%esp
  800999:	ff 75 0c             	pushl  0xc(%ebp)
  80099c:	6a 2d                	push   $0x2d
  80099e:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a1:	ff d0                	call   *%eax
  8009a3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009ac:	f7 d8                	neg    %eax
  8009ae:	83 d2 00             	adc    $0x0,%edx
  8009b1:	f7 da                	neg    %edx
  8009b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009b6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009b9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009c0:	e9 bc 00 00 00       	jmp    800a81 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009c5:	83 ec 08             	sub    $0x8,%esp
  8009c8:	ff 75 e8             	pushl  -0x18(%ebp)
  8009cb:	8d 45 14             	lea    0x14(%ebp),%eax
  8009ce:	50                   	push   %eax
  8009cf:	e8 84 fc ff ff       	call   800658 <getuint>
  8009d4:	83 c4 10             	add    $0x10,%esp
  8009d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009da:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009dd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009e4:	e9 98 00 00 00       	jmp    800a81 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009e9:	83 ec 08             	sub    $0x8,%esp
  8009ec:	ff 75 0c             	pushl  0xc(%ebp)
  8009ef:	6a 58                	push   $0x58
  8009f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f4:	ff d0                	call   *%eax
  8009f6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009f9:	83 ec 08             	sub    $0x8,%esp
  8009fc:	ff 75 0c             	pushl  0xc(%ebp)
  8009ff:	6a 58                	push   $0x58
  800a01:	8b 45 08             	mov    0x8(%ebp),%eax
  800a04:	ff d0                	call   *%eax
  800a06:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a09:	83 ec 08             	sub    $0x8,%esp
  800a0c:	ff 75 0c             	pushl  0xc(%ebp)
  800a0f:	6a 58                	push   $0x58
  800a11:	8b 45 08             	mov    0x8(%ebp),%eax
  800a14:	ff d0                	call   *%eax
  800a16:	83 c4 10             	add    $0x10,%esp
			break;
  800a19:	e9 bc 00 00 00       	jmp    800ada <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a1e:	83 ec 08             	sub    $0x8,%esp
  800a21:	ff 75 0c             	pushl  0xc(%ebp)
  800a24:	6a 30                	push   $0x30
  800a26:	8b 45 08             	mov    0x8(%ebp),%eax
  800a29:	ff d0                	call   *%eax
  800a2b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a2e:	83 ec 08             	sub    $0x8,%esp
  800a31:	ff 75 0c             	pushl  0xc(%ebp)
  800a34:	6a 78                	push   $0x78
  800a36:	8b 45 08             	mov    0x8(%ebp),%eax
  800a39:	ff d0                	call   *%eax
  800a3b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a41:	83 c0 04             	add    $0x4,%eax
  800a44:	89 45 14             	mov    %eax,0x14(%ebp)
  800a47:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4a:	83 e8 04             	sub    $0x4,%eax
  800a4d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a52:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a59:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a60:	eb 1f                	jmp    800a81 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a62:	83 ec 08             	sub    $0x8,%esp
  800a65:	ff 75 e8             	pushl  -0x18(%ebp)
  800a68:	8d 45 14             	lea    0x14(%ebp),%eax
  800a6b:	50                   	push   %eax
  800a6c:	e8 e7 fb ff ff       	call   800658 <getuint>
  800a71:	83 c4 10             	add    $0x10,%esp
  800a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a77:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a7a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a81:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a88:	83 ec 04             	sub    $0x4,%esp
  800a8b:	52                   	push   %edx
  800a8c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a8f:	50                   	push   %eax
  800a90:	ff 75 f4             	pushl  -0xc(%ebp)
  800a93:	ff 75 f0             	pushl  -0x10(%ebp)
  800a96:	ff 75 0c             	pushl  0xc(%ebp)
  800a99:	ff 75 08             	pushl  0x8(%ebp)
  800a9c:	e8 00 fb ff ff       	call   8005a1 <printnum>
  800aa1:	83 c4 20             	add    $0x20,%esp
			break;
  800aa4:	eb 34                	jmp    800ada <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800aa6:	83 ec 08             	sub    $0x8,%esp
  800aa9:	ff 75 0c             	pushl  0xc(%ebp)
  800aac:	53                   	push   %ebx
  800aad:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab0:	ff d0                	call   *%eax
  800ab2:	83 c4 10             	add    $0x10,%esp
			break;
  800ab5:	eb 23                	jmp    800ada <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ab7:	83 ec 08             	sub    $0x8,%esp
  800aba:	ff 75 0c             	pushl  0xc(%ebp)
  800abd:	6a 25                	push   $0x25
  800abf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac2:	ff d0                	call   *%eax
  800ac4:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ac7:	ff 4d 10             	decl   0x10(%ebp)
  800aca:	eb 03                	jmp    800acf <vprintfmt+0x3b1>
  800acc:	ff 4d 10             	decl   0x10(%ebp)
  800acf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad2:	48                   	dec    %eax
  800ad3:	8a 00                	mov    (%eax),%al
  800ad5:	3c 25                	cmp    $0x25,%al
  800ad7:	75 f3                	jne    800acc <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800ad9:	90                   	nop
		}
	}
  800ada:	e9 47 fc ff ff       	jmp    800726 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800adf:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ae0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ae3:	5b                   	pop    %ebx
  800ae4:	5e                   	pop    %esi
  800ae5:	5d                   	pop    %ebp
  800ae6:	c3                   	ret    

00800ae7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ae7:	55                   	push   %ebp
  800ae8:	89 e5                	mov    %esp,%ebp
  800aea:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800aed:	8d 45 10             	lea    0x10(%ebp),%eax
  800af0:	83 c0 04             	add    $0x4,%eax
  800af3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800af6:	8b 45 10             	mov    0x10(%ebp),%eax
  800af9:	ff 75 f4             	pushl  -0xc(%ebp)
  800afc:	50                   	push   %eax
  800afd:	ff 75 0c             	pushl  0xc(%ebp)
  800b00:	ff 75 08             	pushl  0x8(%ebp)
  800b03:	e8 16 fc ff ff       	call   80071e <vprintfmt>
  800b08:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b0b:	90                   	nop
  800b0c:	c9                   	leave  
  800b0d:	c3                   	ret    

00800b0e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b0e:	55                   	push   %ebp
  800b0f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b14:	8b 40 08             	mov    0x8(%eax),%eax
  800b17:	8d 50 01             	lea    0x1(%eax),%edx
  800b1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b23:	8b 10                	mov    (%eax),%edx
  800b25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b28:	8b 40 04             	mov    0x4(%eax),%eax
  800b2b:	39 c2                	cmp    %eax,%edx
  800b2d:	73 12                	jae    800b41 <sprintputch+0x33>
		*b->buf++ = ch;
  800b2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b32:	8b 00                	mov    (%eax),%eax
  800b34:	8d 48 01             	lea    0x1(%eax),%ecx
  800b37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b3a:	89 0a                	mov    %ecx,(%edx)
  800b3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800b3f:	88 10                	mov    %dl,(%eax)
}
  800b41:	90                   	nop
  800b42:	5d                   	pop    %ebp
  800b43:	c3                   	ret    

00800b44 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b44:	55                   	push   %ebp
  800b45:	89 e5                	mov    %esp,%ebp
  800b47:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b53:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	01 d0                	add    %edx,%eax
  800b5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b65:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b69:	74 06                	je     800b71 <vsnprintf+0x2d>
  800b6b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b6f:	7f 07                	jg     800b78 <vsnprintf+0x34>
		return -E_INVAL;
  800b71:	b8 03 00 00 00       	mov    $0x3,%eax
  800b76:	eb 20                	jmp    800b98 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b78:	ff 75 14             	pushl  0x14(%ebp)
  800b7b:	ff 75 10             	pushl  0x10(%ebp)
  800b7e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b81:	50                   	push   %eax
  800b82:	68 0e 0b 80 00       	push   $0x800b0e
  800b87:	e8 92 fb ff ff       	call   80071e <vprintfmt>
  800b8c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b92:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b98:	c9                   	leave  
  800b99:	c3                   	ret    

00800b9a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b9a:	55                   	push   %ebp
  800b9b:	89 e5                	mov    %esp,%ebp
  800b9d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ba0:	8d 45 10             	lea    0x10(%ebp),%eax
  800ba3:	83 c0 04             	add    $0x4,%eax
  800ba6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ba9:	8b 45 10             	mov    0x10(%ebp),%eax
  800bac:	ff 75 f4             	pushl  -0xc(%ebp)
  800baf:	50                   	push   %eax
  800bb0:	ff 75 0c             	pushl  0xc(%ebp)
  800bb3:	ff 75 08             	pushl  0x8(%ebp)
  800bb6:	e8 89 ff ff ff       	call   800b44 <vsnprintf>
  800bbb:	83 c4 10             	add    $0x10,%esp
  800bbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bc4:	c9                   	leave  
  800bc5:	c3                   	ret    

00800bc6 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bc6:	55                   	push   %ebp
  800bc7:	89 e5                	mov    %esp,%ebp
  800bc9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bcc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bd3:	eb 06                	jmp    800bdb <strlen+0x15>
		n++;
  800bd5:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bd8:	ff 45 08             	incl   0x8(%ebp)
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	8a 00                	mov    (%eax),%al
  800be0:	84 c0                	test   %al,%al
  800be2:	75 f1                	jne    800bd5 <strlen+0xf>
		n++;
	return n;
  800be4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800be7:	c9                   	leave  
  800be8:	c3                   	ret    

00800be9 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800be9:	55                   	push   %ebp
  800bea:	89 e5                	mov    %esp,%ebp
  800bec:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bf6:	eb 09                	jmp    800c01 <strnlen+0x18>
		n++;
  800bf8:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bfb:	ff 45 08             	incl   0x8(%ebp)
  800bfe:	ff 4d 0c             	decl   0xc(%ebp)
  800c01:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c05:	74 09                	je     800c10 <strnlen+0x27>
  800c07:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0a:	8a 00                	mov    (%eax),%al
  800c0c:	84 c0                	test   %al,%al
  800c0e:	75 e8                	jne    800bf8 <strnlen+0xf>
		n++;
	return n;
  800c10:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c13:	c9                   	leave  
  800c14:	c3                   	ret    

00800c15 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c15:	55                   	push   %ebp
  800c16:	89 e5                	mov    %esp,%ebp
  800c18:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c21:	90                   	nop
  800c22:	8b 45 08             	mov    0x8(%ebp),%eax
  800c25:	8d 50 01             	lea    0x1(%eax),%edx
  800c28:	89 55 08             	mov    %edx,0x8(%ebp)
  800c2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c2e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c31:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c34:	8a 12                	mov    (%edx),%dl
  800c36:	88 10                	mov    %dl,(%eax)
  800c38:	8a 00                	mov    (%eax),%al
  800c3a:	84 c0                	test   %al,%al
  800c3c:	75 e4                	jne    800c22 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c41:	c9                   	leave  
  800c42:	c3                   	ret    

00800c43 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c43:	55                   	push   %ebp
  800c44:	89 e5                	mov    %esp,%ebp
  800c46:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c4f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c56:	eb 1f                	jmp    800c77 <strncpy+0x34>
		*dst++ = *src;
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	8d 50 01             	lea    0x1(%eax),%edx
  800c5e:	89 55 08             	mov    %edx,0x8(%ebp)
  800c61:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c64:	8a 12                	mov    (%edx),%dl
  800c66:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6b:	8a 00                	mov    (%eax),%al
  800c6d:	84 c0                	test   %al,%al
  800c6f:	74 03                	je     800c74 <strncpy+0x31>
			src++;
  800c71:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c74:	ff 45 fc             	incl   -0x4(%ebp)
  800c77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c7a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c7d:	72 d9                	jb     800c58 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c82:	c9                   	leave  
  800c83:	c3                   	ret    

00800c84 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c84:	55                   	push   %ebp
  800c85:	89 e5                	mov    %esp,%ebp
  800c87:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c90:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c94:	74 30                	je     800cc6 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c96:	eb 16                	jmp    800cae <strlcpy+0x2a>
			*dst++ = *src++;
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	8d 50 01             	lea    0x1(%eax),%edx
  800c9e:	89 55 08             	mov    %edx,0x8(%ebp)
  800ca1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ca7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800caa:	8a 12                	mov    (%edx),%dl
  800cac:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cae:	ff 4d 10             	decl   0x10(%ebp)
  800cb1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cb5:	74 09                	je     800cc0 <strlcpy+0x3c>
  800cb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cba:	8a 00                	mov    (%eax),%al
  800cbc:	84 c0                	test   %al,%al
  800cbe:	75 d8                	jne    800c98 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ccc:	29 c2                	sub    %eax,%edx
  800cce:	89 d0                	mov    %edx,%eax
}
  800cd0:	c9                   	leave  
  800cd1:	c3                   	ret    

00800cd2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cd2:	55                   	push   %ebp
  800cd3:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cd5:	eb 06                	jmp    800cdd <strcmp+0xb>
		p++, q++;
  800cd7:	ff 45 08             	incl   0x8(%ebp)
  800cda:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	8a 00                	mov    (%eax),%al
  800ce2:	84 c0                	test   %al,%al
  800ce4:	74 0e                	je     800cf4 <strcmp+0x22>
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	8a 10                	mov    (%eax),%dl
  800ceb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cee:	8a 00                	mov    (%eax),%al
  800cf0:	38 c2                	cmp    %al,%dl
  800cf2:	74 e3                	je     800cd7 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf7:	8a 00                	mov    (%eax),%al
  800cf9:	0f b6 d0             	movzbl %al,%edx
  800cfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cff:	8a 00                	mov    (%eax),%al
  800d01:	0f b6 c0             	movzbl %al,%eax
  800d04:	29 c2                	sub    %eax,%edx
  800d06:	89 d0                	mov    %edx,%eax
}
  800d08:	5d                   	pop    %ebp
  800d09:	c3                   	ret    

00800d0a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d0a:	55                   	push   %ebp
  800d0b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d0d:	eb 09                	jmp    800d18 <strncmp+0xe>
		n--, p++, q++;
  800d0f:	ff 4d 10             	decl   0x10(%ebp)
  800d12:	ff 45 08             	incl   0x8(%ebp)
  800d15:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d18:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d1c:	74 17                	je     800d35 <strncmp+0x2b>
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	8a 00                	mov    (%eax),%al
  800d23:	84 c0                	test   %al,%al
  800d25:	74 0e                	je     800d35 <strncmp+0x2b>
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	8a 10                	mov    (%eax),%dl
  800d2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2f:	8a 00                	mov    (%eax),%al
  800d31:	38 c2                	cmp    %al,%dl
  800d33:	74 da                	je     800d0f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d39:	75 07                	jne    800d42 <strncmp+0x38>
		return 0;
  800d3b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d40:	eb 14                	jmp    800d56 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d42:	8b 45 08             	mov    0x8(%ebp),%eax
  800d45:	8a 00                	mov    (%eax),%al
  800d47:	0f b6 d0             	movzbl %al,%edx
  800d4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4d:	8a 00                	mov    (%eax),%al
  800d4f:	0f b6 c0             	movzbl %al,%eax
  800d52:	29 c2                	sub    %eax,%edx
  800d54:	89 d0                	mov    %edx,%eax
}
  800d56:	5d                   	pop    %ebp
  800d57:	c3                   	ret    

00800d58 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d58:	55                   	push   %ebp
  800d59:	89 e5                	mov    %esp,%ebp
  800d5b:	83 ec 04             	sub    $0x4,%esp
  800d5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d61:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d64:	eb 12                	jmp    800d78 <strchr+0x20>
		if (*s == c)
  800d66:	8b 45 08             	mov    0x8(%ebp),%eax
  800d69:	8a 00                	mov    (%eax),%al
  800d6b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d6e:	75 05                	jne    800d75 <strchr+0x1d>
			return (char *) s;
  800d70:	8b 45 08             	mov    0x8(%ebp),%eax
  800d73:	eb 11                	jmp    800d86 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d75:	ff 45 08             	incl   0x8(%ebp)
  800d78:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7b:	8a 00                	mov    (%eax),%al
  800d7d:	84 c0                	test   %al,%al
  800d7f:	75 e5                	jne    800d66 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d86:	c9                   	leave  
  800d87:	c3                   	ret    

00800d88 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d88:	55                   	push   %ebp
  800d89:	89 e5                	mov    %esp,%ebp
  800d8b:	83 ec 04             	sub    $0x4,%esp
  800d8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d91:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d94:	eb 0d                	jmp    800da3 <strfind+0x1b>
		if (*s == c)
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
  800d99:	8a 00                	mov    (%eax),%al
  800d9b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d9e:	74 0e                	je     800dae <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800da0:	ff 45 08             	incl   0x8(%ebp)
  800da3:	8b 45 08             	mov    0x8(%ebp),%eax
  800da6:	8a 00                	mov    (%eax),%al
  800da8:	84 c0                	test   %al,%al
  800daa:	75 ea                	jne    800d96 <strfind+0xe>
  800dac:	eb 01                	jmp    800daf <strfind+0x27>
		if (*s == c)
			break;
  800dae:	90                   	nop
	return (char *) s;
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800db2:	c9                   	leave  
  800db3:	c3                   	ret    

00800db4 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800db4:	55                   	push   %ebp
  800db5:	89 e5                	mov    %esp,%ebp
  800db7:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800dc0:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dc6:	eb 0e                	jmp    800dd6 <memset+0x22>
		*p++ = c;
  800dc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dcb:	8d 50 01             	lea    0x1(%eax),%edx
  800dce:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dd4:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dd6:	ff 4d f8             	decl   -0x8(%ebp)
  800dd9:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ddd:	79 e9                	jns    800dc8 <memset+0x14>
		*p++ = c;

	return v;
  800ddf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800de2:	c9                   	leave  
  800de3:	c3                   	ret    

00800de4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800de4:	55                   	push   %ebp
  800de5:	89 e5                	mov    %esp,%ebp
  800de7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ded:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
  800df3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800df6:	eb 16                	jmp    800e0e <memcpy+0x2a>
		*d++ = *s++;
  800df8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dfb:	8d 50 01             	lea    0x1(%eax),%edx
  800dfe:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e01:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e04:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e07:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e0a:	8a 12                	mov    (%edx),%dl
  800e0c:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e11:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e14:	89 55 10             	mov    %edx,0x10(%ebp)
  800e17:	85 c0                	test   %eax,%eax
  800e19:	75 dd                	jne    800df8 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e1e:	c9                   	leave  
  800e1f:	c3                   	ret    

00800e20 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e20:	55                   	push   %ebp
  800e21:	89 e5                	mov    %esp,%ebp
  800e23:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e32:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e35:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e38:	73 50                	jae    800e8a <memmove+0x6a>
  800e3a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e3d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e40:	01 d0                	add    %edx,%eax
  800e42:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e45:	76 43                	jbe    800e8a <memmove+0x6a>
		s += n;
  800e47:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e50:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e53:	eb 10                	jmp    800e65 <memmove+0x45>
			*--d = *--s;
  800e55:	ff 4d f8             	decl   -0x8(%ebp)
  800e58:	ff 4d fc             	decl   -0x4(%ebp)
  800e5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e5e:	8a 10                	mov    (%eax),%dl
  800e60:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e63:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e65:	8b 45 10             	mov    0x10(%ebp),%eax
  800e68:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e6b:	89 55 10             	mov    %edx,0x10(%ebp)
  800e6e:	85 c0                	test   %eax,%eax
  800e70:	75 e3                	jne    800e55 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e72:	eb 23                	jmp    800e97 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e74:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e77:	8d 50 01             	lea    0x1(%eax),%edx
  800e7a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e7d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e80:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e83:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e86:	8a 12                	mov    (%edx),%dl
  800e88:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e8a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e90:	89 55 10             	mov    %edx,0x10(%ebp)
  800e93:	85 c0                	test   %eax,%eax
  800e95:	75 dd                	jne    800e74 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e97:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e9a:	c9                   	leave  
  800e9b:	c3                   	ret    

00800e9c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e9c:	55                   	push   %ebp
  800e9d:	89 e5                	mov    %esp,%ebp
  800e9f:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ea8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eab:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800eae:	eb 2a                	jmp    800eda <memcmp+0x3e>
		if (*s1 != *s2)
  800eb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb3:	8a 10                	mov    (%eax),%dl
  800eb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb8:	8a 00                	mov    (%eax),%al
  800eba:	38 c2                	cmp    %al,%dl
  800ebc:	74 16                	je     800ed4 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ebe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec1:	8a 00                	mov    (%eax),%al
  800ec3:	0f b6 d0             	movzbl %al,%edx
  800ec6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec9:	8a 00                	mov    (%eax),%al
  800ecb:	0f b6 c0             	movzbl %al,%eax
  800ece:	29 c2                	sub    %eax,%edx
  800ed0:	89 d0                	mov    %edx,%eax
  800ed2:	eb 18                	jmp    800eec <memcmp+0x50>
		s1++, s2++;
  800ed4:	ff 45 fc             	incl   -0x4(%ebp)
  800ed7:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800eda:	8b 45 10             	mov    0x10(%ebp),%eax
  800edd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ee0:	89 55 10             	mov    %edx,0x10(%ebp)
  800ee3:	85 c0                	test   %eax,%eax
  800ee5:	75 c9                	jne    800eb0 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ee7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eec:	c9                   	leave  
  800eed:	c3                   	ret    

00800eee <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800eee:	55                   	push   %ebp
  800eef:	89 e5                	mov    %esp,%ebp
  800ef1:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ef4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef7:	8b 45 10             	mov    0x10(%ebp),%eax
  800efa:	01 d0                	add    %edx,%eax
  800efc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800eff:	eb 15                	jmp    800f16 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f01:	8b 45 08             	mov    0x8(%ebp),%eax
  800f04:	8a 00                	mov    (%eax),%al
  800f06:	0f b6 d0             	movzbl %al,%edx
  800f09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0c:	0f b6 c0             	movzbl %al,%eax
  800f0f:	39 c2                	cmp    %eax,%edx
  800f11:	74 0d                	je     800f20 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f13:	ff 45 08             	incl   0x8(%ebp)
  800f16:	8b 45 08             	mov    0x8(%ebp),%eax
  800f19:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f1c:	72 e3                	jb     800f01 <memfind+0x13>
  800f1e:	eb 01                	jmp    800f21 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f20:	90                   	nop
	return (void *) s;
  800f21:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f24:	c9                   	leave  
  800f25:	c3                   	ret    

00800f26 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f26:	55                   	push   %ebp
  800f27:	89 e5                	mov    %esp,%ebp
  800f29:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f2c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f33:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f3a:	eb 03                	jmp    800f3f <strtol+0x19>
		s++;
  800f3c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	8a 00                	mov    (%eax),%al
  800f44:	3c 20                	cmp    $0x20,%al
  800f46:	74 f4                	je     800f3c <strtol+0x16>
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	8a 00                	mov    (%eax),%al
  800f4d:	3c 09                	cmp    $0x9,%al
  800f4f:	74 eb                	je     800f3c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f51:	8b 45 08             	mov    0x8(%ebp),%eax
  800f54:	8a 00                	mov    (%eax),%al
  800f56:	3c 2b                	cmp    $0x2b,%al
  800f58:	75 05                	jne    800f5f <strtol+0x39>
		s++;
  800f5a:	ff 45 08             	incl   0x8(%ebp)
  800f5d:	eb 13                	jmp    800f72 <strtol+0x4c>
	else if (*s == '-')
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f62:	8a 00                	mov    (%eax),%al
  800f64:	3c 2d                	cmp    $0x2d,%al
  800f66:	75 0a                	jne    800f72 <strtol+0x4c>
		s++, neg = 1;
  800f68:	ff 45 08             	incl   0x8(%ebp)
  800f6b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f72:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f76:	74 06                	je     800f7e <strtol+0x58>
  800f78:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f7c:	75 20                	jne    800f9e <strtol+0x78>
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f81:	8a 00                	mov    (%eax),%al
  800f83:	3c 30                	cmp    $0x30,%al
  800f85:	75 17                	jne    800f9e <strtol+0x78>
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8a:	40                   	inc    %eax
  800f8b:	8a 00                	mov    (%eax),%al
  800f8d:	3c 78                	cmp    $0x78,%al
  800f8f:	75 0d                	jne    800f9e <strtol+0x78>
		s += 2, base = 16;
  800f91:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f95:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f9c:	eb 28                	jmp    800fc6 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f9e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa2:	75 15                	jne    800fb9 <strtol+0x93>
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	3c 30                	cmp    $0x30,%al
  800fab:	75 0c                	jne    800fb9 <strtol+0x93>
		s++, base = 8;
  800fad:	ff 45 08             	incl   0x8(%ebp)
  800fb0:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fb7:	eb 0d                	jmp    800fc6 <strtol+0xa0>
	else if (base == 0)
  800fb9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fbd:	75 07                	jne    800fc6 <strtol+0xa0>
		base = 10;
  800fbf:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc9:	8a 00                	mov    (%eax),%al
  800fcb:	3c 2f                	cmp    $0x2f,%al
  800fcd:	7e 19                	jle    800fe8 <strtol+0xc2>
  800fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd2:	8a 00                	mov    (%eax),%al
  800fd4:	3c 39                	cmp    $0x39,%al
  800fd6:	7f 10                	jg     800fe8 <strtol+0xc2>
			dig = *s - '0';
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	8a 00                	mov    (%eax),%al
  800fdd:	0f be c0             	movsbl %al,%eax
  800fe0:	83 e8 30             	sub    $0x30,%eax
  800fe3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fe6:	eb 42                	jmp    80102a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  800feb:	8a 00                	mov    (%eax),%al
  800fed:	3c 60                	cmp    $0x60,%al
  800fef:	7e 19                	jle    80100a <strtol+0xe4>
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	8a 00                	mov    (%eax),%al
  800ff6:	3c 7a                	cmp    $0x7a,%al
  800ff8:	7f 10                	jg     80100a <strtol+0xe4>
			dig = *s - 'a' + 10;
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	8a 00                	mov    (%eax),%al
  800fff:	0f be c0             	movsbl %al,%eax
  801002:	83 e8 57             	sub    $0x57,%eax
  801005:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801008:	eb 20                	jmp    80102a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80100a:	8b 45 08             	mov    0x8(%ebp),%eax
  80100d:	8a 00                	mov    (%eax),%al
  80100f:	3c 40                	cmp    $0x40,%al
  801011:	7e 39                	jle    80104c <strtol+0x126>
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	8a 00                	mov    (%eax),%al
  801018:	3c 5a                	cmp    $0x5a,%al
  80101a:	7f 30                	jg     80104c <strtol+0x126>
			dig = *s - 'A' + 10;
  80101c:	8b 45 08             	mov    0x8(%ebp),%eax
  80101f:	8a 00                	mov    (%eax),%al
  801021:	0f be c0             	movsbl %al,%eax
  801024:	83 e8 37             	sub    $0x37,%eax
  801027:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80102a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80102d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801030:	7d 19                	jge    80104b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801032:	ff 45 08             	incl   0x8(%ebp)
  801035:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801038:	0f af 45 10          	imul   0x10(%ebp),%eax
  80103c:	89 c2                	mov    %eax,%edx
  80103e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801041:	01 d0                	add    %edx,%eax
  801043:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801046:	e9 7b ff ff ff       	jmp    800fc6 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80104b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80104c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801050:	74 08                	je     80105a <strtol+0x134>
		*endptr = (char *) s;
  801052:	8b 45 0c             	mov    0xc(%ebp),%eax
  801055:	8b 55 08             	mov    0x8(%ebp),%edx
  801058:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80105a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80105e:	74 07                	je     801067 <strtol+0x141>
  801060:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801063:	f7 d8                	neg    %eax
  801065:	eb 03                	jmp    80106a <strtol+0x144>
  801067:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80106a:	c9                   	leave  
  80106b:	c3                   	ret    

0080106c <ltostr>:

void
ltostr(long value, char *str)
{
  80106c:	55                   	push   %ebp
  80106d:	89 e5                	mov    %esp,%ebp
  80106f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801072:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801079:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801080:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801084:	79 13                	jns    801099 <ltostr+0x2d>
	{
		neg = 1;
  801086:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80108d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801090:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801093:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801096:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
  80109c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010a1:	99                   	cltd   
  8010a2:	f7 f9                	idiv   %ecx
  8010a4:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010aa:	8d 50 01             	lea    0x1(%eax),%edx
  8010ad:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010b0:	89 c2                	mov    %eax,%edx
  8010b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b5:	01 d0                	add    %edx,%eax
  8010b7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010ba:	83 c2 30             	add    $0x30,%edx
  8010bd:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010c2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010c7:	f7 e9                	imul   %ecx
  8010c9:	c1 fa 02             	sar    $0x2,%edx
  8010cc:	89 c8                	mov    %ecx,%eax
  8010ce:	c1 f8 1f             	sar    $0x1f,%eax
  8010d1:	29 c2                	sub    %eax,%edx
  8010d3:	89 d0                	mov    %edx,%eax
  8010d5:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010db:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010e0:	f7 e9                	imul   %ecx
  8010e2:	c1 fa 02             	sar    $0x2,%edx
  8010e5:	89 c8                	mov    %ecx,%eax
  8010e7:	c1 f8 1f             	sar    $0x1f,%eax
  8010ea:	29 c2                	sub    %eax,%edx
  8010ec:	89 d0                	mov    %edx,%eax
  8010ee:	c1 e0 02             	shl    $0x2,%eax
  8010f1:	01 d0                	add    %edx,%eax
  8010f3:	01 c0                	add    %eax,%eax
  8010f5:	29 c1                	sub    %eax,%ecx
  8010f7:	89 ca                	mov    %ecx,%edx
  8010f9:	85 d2                	test   %edx,%edx
  8010fb:	75 9c                	jne    801099 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801104:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801107:	48                   	dec    %eax
  801108:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80110b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80110f:	74 3d                	je     80114e <ltostr+0xe2>
		start = 1 ;
  801111:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801118:	eb 34                	jmp    80114e <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80111a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80111d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801120:	01 d0                	add    %edx,%eax
  801122:	8a 00                	mov    (%eax),%al
  801124:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801127:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80112a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112d:	01 c2                	add    %eax,%edx
  80112f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801132:	8b 45 0c             	mov    0xc(%ebp),%eax
  801135:	01 c8                	add    %ecx,%eax
  801137:	8a 00                	mov    (%eax),%al
  801139:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80113b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80113e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801141:	01 c2                	add    %eax,%edx
  801143:	8a 45 eb             	mov    -0x15(%ebp),%al
  801146:	88 02                	mov    %al,(%edx)
		start++ ;
  801148:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80114b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80114e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801151:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801154:	7c c4                	jl     80111a <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801156:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801159:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115c:	01 d0                	add    %edx,%eax
  80115e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801161:	90                   	nop
  801162:	c9                   	leave  
  801163:	c3                   	ret    

00801164 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801164:	55                   	push   %ebp
  801165:	89 e5                	mov    %esp,%ebp
  801167:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80116a:	ff 75 08             	pushl  0x8(%ebp)
  80116d:	e8 54 fa ff ff       	call   800bc6 <strlen>
  801172:	83 c4 04             	add    $0x4,%esp
  801175:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801178:	ff 75 0c             	pushl  0xc(%ebp)
  80117b:	e8 46 fa ff ff       	call   800bc6 <strlen>
  801180:	83 c4 04             	add    $0x4,%esp
  801183:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801186:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80118d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801194:	eb 17                	jmp    8011ad <strcconcat+0x49>
		final[s] = str1[s] ;
  801196:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801199:	8b 45 10             	mov    0x10(%ebp),%eax
  80119c:	01 c2                	add    %eax,%edx
  80119e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a4:	01 c8                	add    %ecx,%eax
  8011a6:	8a 00                	mov    (%eax),%al
  8011a8:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011aa:	ff 45 fc             	incl   -0x4(%ebp)
  8011ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011b0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011b3:	7c e1                	jl     801196 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011b5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011bc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011c3:	eb 1f                	jmp    8011e4 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011c8:	8d 50 01             	lea    0x1(%eax),%edx
  8011cb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011ce:	89 c2                	mov    %eax,%edx
  8011d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d3:	01 c2                	add    %eax,%edx
  8011d5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011db:	01 c8                	add    %ecx,%eax
  8011dd:	8a 00                	mov    (%eax),%al
  8011df:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011e1:	ff 45 f8             	incl   -0x8(%ebp)
  8011e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011ea:	7c d9                	jl     8011c5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011ec:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f2:	01 d0                	add    %edx,%eax
  8011f4:	c6 00 00             	movb   $0x0,(%eax)
}
  8011f7:	90                   	nop
  8011f8:	c9                   	leave  
  8011f9:	c3                   	ret    

008011fa <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011fa:	55                   	push   %ebp
  8011fb:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801200:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801206:	8b 45 14             	mov    0x14(%ebp),%eax
  801209:	8b 00                	mov    (%eax),%eax
  80120b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801212:	8b 45 10             	mov    0x10(%ebp),%eax
  801215:	01 d0                	add    %edx,%eax
  801217:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80121d:	eb 0c                	jmp    80122b <strsplit+0x31>
			*string++ = 0;
  80121f:	8b 45 08             	mov    0x8(%ebp),%eax
  801222:	8d 50 01             	lea    0x1(%eax),%edx
  801225:	89 55 08             	mov    %edx,0x8(%ebp)
  801228:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80122b:	8b 45 08             	mov    0x8(%ebp),%eax
  80122e:	8a 00                	mov    (%eax),%al
  801230:	84 c0                	test   %al,%al
  801232:	74 18                	je     80124c <strsplit+0x52>
  801234:	8b 45 08             	mov    0x8(%ebp),%eax
  801237:	8a 00                	mov    (%eax),%al
  801239:	0f be c0             	movsbl %al,%eax
  80123c:	50                   	push   %eax
  80123d:	ff 75 0c             	pushl  0xc(%ebp)
  801240:	e8 13 fb ff ff       	call   800d58 <strchr>
  801245:	83 c4 08             	add    $0x8,%esp
  801248:	85 c0                	test   %eax,%eax
  80124a:	75 d3                	jne    80121f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
  80124f:	8a 00                	mov    (%eax),%al
  801251:	84 c0                	test   %al,%al
  801253:	74 5a                	je     8012af <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801255:	8b 45 14             	mov    0x14(%ebp),%eax
  801258:	8b 00                	mov    (%eax),%eax
  80125a:	83 f8 0f             	cmp    $0xf,%eax
  80125d:	75 07                	jne    801266 <strsplit+0x6c>
		{
			return 0;
  80125f:	b8 00 00 00 00       	mov    $0x0,%eax
  801264:	eb 66                	jmp    8012cc <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801266:	8b 45 14             	mov    0x14(%ebp),%eax
  801269:	8b 00                	mov    (%eax),%eax
  80126b:	8d 48 01             	lea    0x1(%eax),%ecx
  80126e:	8b 55 14             	mov    0x14(%ebp),%edx
  801271:	89 0a                	mov    %ecx,(%edx)
  801273:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80127a:	8b 45 10             	mov    0x10(%ebp),%eax
  80127d:	01 c2                	add    %eax,%edx
  80127f:	8b 45 08             	mov    0x8(%ebp),%eax
  801282:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801284:	eb 03                	jmp    801289 <strsplit+0x8f>
			string++;
  801286:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801289:	8b 45 08             	mov    0x8(%ebp),%eax
  80128c:	8a 00                	mov    (%eax),%al
  80128e:	84 c0                	test   %al,%al
  801290:	74 8b                	je     80121d <strsplit+0x23>
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	8a 00                	mov    (%eax),%al
  801297:	0f be c0             	movsbl %al,%eax
  80129a:	50                   	push   %eax
  80129b:	ff 75 0c             	pushl  0xc(%ebp)
  80129e:	e8 b5 fa ff ff       	call   800d58 <strchr>
  8012a3:	83 c4 08             	add    $0x8,%esp
  8012a6:	85 c0                	test   %eax,%eax
  8012a8:	74 dc                	je     801286 <strsplit+0x8c>
			string++;
	}
  8012aa:	e9 6e ff ff ff       	jmp    80121d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012af:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8012b3:	8b 00                	mov    (%eax),%eax
  8012b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012bf:	01 d0                	add    %edx,%eax
  8012c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012c7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012cc:	c9                   	leave  
  8012cd:	c3                   	ret    

008012ce <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
  8012d1:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012d4:	a1 04 40 80 00       	mov    0x804004,%eax
  8012d9:	85 c0                	test   %eax,%eax
  8012db:	74 1f                	je     8012fc <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012dd:	e8 1d 00 00 00       	call   8012ff <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8012e2:	83 ec 0c             	sub    $0xc,%esp
  8012e5:	68 b0 39 80 00       	push   $0x8039b0
  8012ea:	e8 55 f2 ff ff       	call   800544 <cprintf>
  8012ef:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012f2:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8012f9:	00 00 00 
	}
}
  8012fc:	90                   	nop
  8012fd:	c9                   	leave  
  8012fe:	c3                   	ret    

008012ff <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8012ff:	55                   	push   %ebp
  801300:	89 e5                	mov    %esp,%ebp
  801302:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  801305:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80130c:	00 00 00 
  80130f:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801316:	00 00 00 
  801319:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801320:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  801323:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80132a:	00 00 00 
  80132d:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801334:	00 00 00 
  801337:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80133e:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  801341:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801348:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80134b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801350:	2d 00 10 00 00       	sub    $0x1000,%eax
  801355:	a3 50 40 80 00       	mov    %eax,0x804050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  80135a:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801361:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  801364:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80136b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80136e:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  801373:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801376:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801379:	ba 00 00 00 00       	mov    $0x0,%edx
  80137e:	f7 75 f0             	divl   -0x10(%ebp)
  801381:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801384:	29 d0                	sub    %edx,%eax
  801386:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  801389:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801390:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801393:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801398:	2d 00 10 00 00       	sub    $0x1000,%eax
  80139d:	83 ec 04             	sub    $0x4,%esp
  8013a0:	6a 06                	push   $0x6
  8013a2:	ff 75 e8             	pushl  -0x18(%ebp)
  8013a5:	50                   	push   %eax
  8013a6:	e8 d4 05 00 00       	call   80197f <sys_allocate_chunk>
  8013ab:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013ae:	a1 20 41 80 00       	mov    0x804120,%eax
  8013b3:	83 ec 0c             	sub    $0xc,%esp
  8013b6:	50                   	push   %eax
  8013b7:	e8 49 0c 00 00       	call   802005 <initialize_MemBlocksList>
  8013bc:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  8013bf:	a1 48 41 80 00       	mov    0x804148,%eax
  8013c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  8013c7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013cb:	75 14                	jne    8013e1 <initialize_dyn_block_system+0xe2>
  8013cd:	83 ec 04             	sub    $0x4,%esp
  8013d0:	68 d5 39 80 00       	push   $0x8039d5
  8013d5:	6a 39                	push   $0x39
  8013d7:	68 f3 39 80 00       	push   $0x8039f3
  8013dc:	e8 af ee ff ff       	call   800290 <_panic>
  8013e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013e4:	8b 00                	mov    (%eax),%eax
  8013e6:	85 c0                	test   %eax,%eax
  8013e8:	74 10                	je     8013fa <initialize_dyn_block_system+0xfb>
  8013ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013ed:	8b 00                	mov    (%eax),%eax
  8013ef:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8013f2:	8b 52 04             	mov    0x4(%edx),%edx
  8013f5:	89 50 04             	mov    %edx,0x4(%eax)
  8013f8:	eb 0b                	jmp    801405 <initialize_dyn_block_system+0x106>
  8013fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013fd:	8b 40 04             	mov    0x4(%eax),%eax
  801400:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801405:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801408:	8b 40 04             	mov    0x4(%eax),%eax
  80140b:	85 c0                	test   %eax,%eax
  80140d:	74 0f                	je     80141e <initialize_dyn_block_system+0x11f>
  80140f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801412:	8b 40 04             	mov    0x4(%eax),%eax
  801415:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801418:	8b 12                	mov    (%edx),%edx
  80141a:	89 10                	mov    %edx,(%eax)
  80141c:	eb 0a                	jmp    801428 <initialize_dyn_block_system+0x129>
  80141e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801421:	8b 00                	mov    (%eax),%eax
  801423:	a3 48 41 80 00       	mov    %eax,0x804148
  801428:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80142b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801431:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801434:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80143b:	a1 54 41 80 00       	mov    0x804154,%eax
  801440:	48                   	dec    %eax
  801441:	a3 54 41 80 00       	mov    %eax,0x804154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  801446:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801449:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  801450:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801453:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  80145a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80145e:	75 14                	jne    801474 <initialize_dyn_block_system+0x175>
  801460:	83 ec 04             	sub    $0x4,%esp
  801463:	68 00 3a 80 00       	push   $0x803a00
  801468:	6a 3f                	push   $0x3f
  80146a:	68 f3 39 80 00       	push   $0x8039f3
  80146f:	e8 1c ee ff ff       	call   800290 <_panic>
  801474:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80147a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80147d:	89 10                	mov    %edx,(%eax)
  80147f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801482:	8b 00                	mov    (%eax),%eax
  801484:	85 c0                	test   %eax,%eax
  801486:	74 0d                	je     801495 <initialize_dyn_block_system+0x196>
  801488:	a1 38 41 80 00       	mov    0x804138,%eax
  80148d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801490:	89 50 04             	mov    %edx,0x4(%eax)
  801493:	eb 08                	jmp    80149d <initialize_dyn_block_system+0x19e>
  801495:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801498:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80149d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014a0:	a3 38 41 80 00       	mov    %eax,0x804138
  8014a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014af:	a1 44 41 80 00       	mov    0x804144,%eax
  8014b4:	40                   	inc    %eax
  8014b5:	a3 44 41 80 00       	mov    %eax,0x804144

}
  8014ba:	90                   	nop
  8014bb:	c9                   	leave  
  8014bc:	c3                   	ret    

008014bd <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8014bd:	55                   	push   %ebp
  8014be:	89 e5                	mov    %esp,%ebp
  8014c0:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014c3:	e8 06 fe ff ff       	call   8012ce <InitializeUHeap>
	if (size == 0) return NULL ;
  8014c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014cc:	75 07                	jne    8014d5 <malloc+0x18>
  8014ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d3:	eb 7d                	jmp    801552 <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  8014d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8014dc:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8014e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8014e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e9:	01 d0                	add    %edx,%eax
  8014eb:	48                   	dec    %eax
  8014ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8014ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8014f7:	f7 75 f0             	divl   -0x10(%ebp)
  8014fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014fd:	29 d0                	sub    %edx,%eax
  8014ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  801502:	e8 46 08 00 00       	call   801d4d <sys_isUHeapPlacementStrategyFIRSTFIT>
  801507:	83 f8 01             	cmp    $0x1,%eax
  80150a:	75 07                	jne    801513 <malloc+0x56>
  80150c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  801513:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  801517:	75 34                	jne    80154d <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  801519:	83 ec 0c             	sub    $0xc,%esp
  80151c:	ff 75 e8             	pushl  -0x18(%ebp)
  80151f:	e8 73 0e 00 00       	call   802397 <alloc_block_FF>
  801524:	83 c4 10             	add    $0x10,%esp
  801527:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  80152a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80152e:	74 16                	je     801546 <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  801530:	83 ec 0c             	sub    $0xc,%esp
  801533:	ff 75 e4             	pushl  -0x1c(%ebp)
  801536:	e8 ff 0b 00 00       	call   80213a <insert_sorted_allocList>
  80153b:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  80153e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801541:	8b 40 08             	mov    0x8(%eax),%eax
  801544:	eb 0c                	jmp    801552 <malloc+0x95>
	             }
	             else
	             	return NULL;
  801546:	b8 00 00 00 00       	mov    $0x0,%eax
  80154b:	eb 05                	jmp    801552 <malloc+0x95>
	      	  }
	          else
	               return NULL;
  80154d:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  801552:	c9                   	leave  
  801553:	c3                   	ret    

00801554 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801554:	55                   	push   %ebp
  801555:	89 e5                	mov    %esp,%ebp
  801557:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  80155a:	8b 45 08             	mov    0x8(%ebp),%eax
  80155d:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  801560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801563:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801566:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801569:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80156e:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  801571:	83 ec 08             	sub    $0x8,%esp
  801574:	ff 75 f4             	pushl  -0xc(%ebp)
  801577:	68 40 40 80 00       	push   $0x804040
  80157c:	e8 61 0b 00 00       	call   8020e2 <find_block>
  801581:	83 c4 10             	add    $0x10,%esp
  801584:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  801587:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80158b:	0f 84 a5 00 00 00    	je     801636 <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  801591:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801594:	8b 40 0c             	mov    0xc(%eax),%eax
  801597:	83 ec 08             	sub    $0x8,%esp
  80159a:	50                   	push   %eax
  80159b:	ff 75 f4             	pushl  -0xc(%ebp)
  80159e:	e8 a4 03 00 00       	call   801947 <sys_free_user_mem>
  8015a3:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  8015a6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015aa:	75 17                	jne    8015c3 <free+0x6f>
  8015ac:	83 ec 04             	sub    $0x4,%esp
  8015af:	68 d5 39 80 00       	push   $0x8039d5
  8015b4:	68 87 00 00 00       	push   $0x87
  8015b9:	68 f3 39 80 00       	push   $0x8039f3
  8015be:	e8 cd ec ff ff       	call   800290 <_panic>
  8015c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015c6:	8b 00                	mov    (%eax),%eax
  8015c8:	85 c0                	test   %eax,%eax
  8015ca:	74 10                	je     8015dc <free+0x88>
  8015cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015cf:	8b 00                	mov    (%eax),%eax
  8015d1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015d4:	8b 52 04             	mov    0x4(%edx),%edx
  8015d7:	89 50 04             	mov    %edx,0x4(%eax)
  8015da:	eb 0b                	jmp    8015e7 <free+0x93>
  8015dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015df:	8b 40 04             	mov    0x4(%eax),%eax
  8015e2:	a3 44 40 80 00       	mov    %eax,0x804044
  8015e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ea:	8b 40 04             	mov    0x4(%eax),%eax
  8015ed:	85 c0                	test   %eax,%eax
  8015ef:	74 0f                	je     801600 <free+0xac>
  8015f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015f4:	8b 40 04             	mov    0x4(%eax),%eax
  8015f7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015fa:	8b 12                	mov    (%edx),%edx
  8015fc:	89 10                	mov    %edx,(%eax)
  8015fe:	eb 0a                	jmp    80160a <free+0xb6>
  801600:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801603:	8b 00                	mov    (%eax),%eax
  801605:	a3 40 40 80 00       	mov    %eax,0x804040
  80160a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80160d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801613:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801616:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80161d:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801622:	48                   	dec    %eax
  801623:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(theBlock);
  801628:	83 ec 0c             	sub    $0xc,%esp
  80162b:	ff 75 ec             	pushl  -0x14(%ebp)
  80162e:	e8 37 12 00 00       	call   80286a <insert_sorted_with_merge_freeList>
  801633:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  801636:	90                   	nop
  801637:	c9                   	leave  
  801638:	c3                   	ret    

00801639 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801639:	55                   	push   %ebp
  80163a:	89 e5                	mov    %esp,%ebp
  80163c:	83 ec 38             	sub    $0x38,%esp
  80163f:	8b 45 10             	mov    0x10(%ebp),%eax
  801642:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801645:	e8 84 fc ff ff       	call   8012ce <InitializeUHeap>
	if (size == 0) return NULL ;
  80164a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80164e:	75 07                	jne    801657 <smalloc+0x1e>
  801650:	b8 00 00 00 00       	mov    $0x0,%eax
  801655:	eb 7e                	jmp    8016d5 <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  801657:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  80165e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801665:	8b 55 0c             	mov    0xc(%ebp),%edx
  801668:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80166b:	01 d0                	add    %edx,%eax
  80166d:	48                   	dec    %eax
  80166e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801671:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801674:	ba 00 00 00 00       	mov    $0x0,%edx
  801679:	f7 75 f0             	divl   -0x10(%ebp)
  80167c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80167f:	29 d0                	sub    %edx,%eax
  801681:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801684:	e8 c4 06 00 00       	call   801d4d <sys_isUHeapPlacementStrategyFIRSTFIT>
  801689:	83 f8 01             	cmp    $0x1,%eax
  80168c:	75 42                	jne    8016d0 <smalloc+0x97>

		  va = malloc(newsize) ;
  80168e:	83 ec 0c             	sub    $0xc,%esp
  801691:	ff 75 e8             	pushl  -0x18(%ebp)
  801694:	e8 24 fe ff ff       	call   8014bd <malloc>
  801699:	83 c4 10             	add    $0x10,%esp
  80169c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  80169f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8016a3:	74 24                	je     8016c9 <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  8016a5:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8016a9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8016ac:	50                   	push   %eax
  8016ad:	ff 75 e8             	pushl  -0x18(%ebp)
  8016b0:	ff 75 08             	pushl  0x8(%ebp)
  8016b3:	e8 1a 04 00 00       	call   801ad2 <sys_createSharedObject>
  8016b8:	83 c4 10             	add    $0x10,%esp
  8016bb:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  8016be:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8016c2:	78 0c                	js     8016d0 <smalloc+0x97>
					  return va ;
  8016c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016c7:	eb 0c                	jmp    8016d5 <smalloc+0x9c>
				 }
				 else
					return NULL;
  8016c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ce:	eb 05                	jmp    8016d5 <smalloc+0x9c>
	  }
		  return NULL ;
  8016d0:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016d5:	c9                   	leave  
  8016d6:	c3                   	ret    

008016d7 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
  8016da:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016dd:	e8 ec fb ff ff       	call   8012ce <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  8016e2:	83 ec 08             	sub    $0x8,%esp
  8016e5:	ff 75 0c             	pushl  0xc(%ebp)
  8016e8:	ff 75 08             	pushl  0x8(%ebp)
  8016eb:	e8 0c 04 00 00       	call   801afc <sys_getSizeOfSharedObject>
  8016f0:	83 c4 10             	add    $0x10,%esp
  8016f3:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  8016f6:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8016fa:	75 07                	jne    801703 <sget+0x2c>
  8016fc:	b8 00 00 00 00       	mov    $0x0,%eax
  801701:	eb 75                	jmp    801778 <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801703:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80170a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80170d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801710:	01 d0                	add    %edx,%eax
  801712:	48                   	dec    %eax
  801713:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801716:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801719:	ba 00 00 00 00       	mov    $0x0,%edx
  80171e:	f7 75 f0             	divl   -0x10(%ebp)
  801721:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801724:	29 d0                	sub    %edx,%eax
  801726:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  801729:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801730:	e8 18 06 00 00       	call   801d4d <sys_isUHeapPlacementStrategyFIRSTFIT>
  801735:	83 f8 01             	cmp    $0x1,%eax
  801738:	75 39                	jne    801773 <sget+0x9c>

		  va = malloc(newsize) ;
  80173a:	83 ec 0c             	sub    $0xc,%esp
  80173d:	ff 75 e8             	pushl  -0x18(%ebp)
  801740:	e8 78 fd ff ff       	call   8014bd <malloc>
  801745:	83 c4 10             	add    $0x10,%esp
  801748:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  80174b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80174f:	74 22                	je     801773 <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  801751:	83 ec 04             	sub    $0x4,%esp
  801754:	ff 75 e0             	pushl  -0x20(%ebp)
  801757:	ff 75 0c             	pushl  0xc(%ebp)
  80175a:	ff 75 08             	pushl  0x8(%ebp)
  80175d:	e8 b7 03 00 00       	call   801b19 <sys_getSharedObject>
  801762:	83 c4 10             	add    $0x10,%esp
  801765:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  801768:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80176c:	78 05                	js     801773 <sget+0x9c>
					  return va;
  80176e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801771:	eb 05                	jmp    801778 <sget+0xa1>
				  }
			  }
     }
         return NULL;
  801773:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  801778:	c9                   	leave  
  801779:	c3                   	ret    

0080177a <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80177a:	55                   	push   %ebp
  80177b:	89 e5                	mov    %esp,%ebp
  80177d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801780:	e8 49 fb ff ff       	call   8012ce <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801785:	83 ec 04             	sub    $0x4,%esp
  801788:	68 24 3a 80 00       	push   $0x803a24
  80178d:	68 1e 01 00 00       	push   $0x11e
  801792:	68 f3 39 80 00       	push   $0x8039f3
  801797:	e8 f4 ea ff ff       	call   800290 <_panic>

0080179c <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
  80179f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017a2:	83 ec 04             	sub    $0x4,%esp
  8017a5:	68 4c 3a 80 00       	push   $0x803a4c
  8017aa:	68 32 01 00 00       	push   $0x132
  8017af:	68 f3 39 80 00       	push   $0x8039f3
  8017b4:	e8 d7 ea ff ff       	call   800290 <_panic>

008017b9 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017b9:	55                   	push   %ebp
  8017ba:	89 e5                	mov    %esp,%ebp
  8017bc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017bf:	83 ec 04             	sub    $0x4,%esp
  8017c2:	68 70 3a 80 00       	push   $0x803a70
  8017c7:	68 3d 01 00 00       	push   $0x13d
  8017cc:	68 f3 39 80 00       	push   $0x8039f3
  8017d1:	e8 ba ea ff ff       	call   800290 <_panic>

008017d6 <shrink>:

}
void shrink(uint32 newSize)
{
  8017d6:	55                   	push   %ebp
  8017d7:	89 e5                	mov    %esp,%ebp
  8017d9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017dc:	83 ec 04             	sub    $0x4,%esp
  8017df:	68 70 3a 80 00       	push   $0x803a70
  8017e4:	68 42 01 00 00       	push   $0x142
  8017e9:	68 f3 39 80 00       	push   $0x8039f3
  8017ee:	e8 9d ea ff ff       	call   800290 <_panic>

008017f3 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
  8017f6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017f9:	83 ec 04             	sub    $0x4,%esp
  8017fc:	68 70 3a 80 00       	push   $0x803a70
  801801:	68 47 01 00 00       	push   $0x147
  801806:	68 f3 39 80 00       	push   $0x8039f3
  80180b:	e8 80 ea ff ff       	call   800290 <_panic>

00801810 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
  801813:	57                   	push   %edi
  801814:	56                   	push   %esi
  801815:	53                   	push   %ebx
  801816:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801819:	8b 45 08             	mov    0x8(%ebp),%eax
  80181c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80181f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801822:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801825:	8b 7d 18             	mov    0x18(%ebp),%edi
  801828:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80182b:	cd 30                	int    $0x30
  80182d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801830:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801833:	83 c4 10             	add    $0x10,%esp
  801836:	5b                   	pop    %ebx
  801837:	5e                   	pop    %esi
  801838:	5f                   	pop    %edi
  801839:	5d                   	pop    %ebp
  80183a:	c3                   	ret    

0080183b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
  80183e:	83 ec 04             	sub    $0x4,%esp
  801841:	8b 45 10             	mov    0x10(%ebp),%eax
  801844:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801847:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80184b:	8b 45 08             	mov    0x8(%ebp),%eax
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	52                   	push   %edx
  801853:	ff 75 0c             	pushl  0xc(%ebp)
  801856:	50                   	push   %eax
  801857:	6a 00                	push   $0x0
  801859:	e8 b2 ff ff ff       	call   801810 <syscall>
  80185e:	83 c4 18             	add    $0x18,%esp
}
  801861:	90                   	nop
  801862:	c9                   	leave  
  801863:	c3                   	ret    

00801864 <sys_cgetc>:

int
sys_cgetc(void)
{
  801864:	55                   	push   %ebp
  801865:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	6a 00                	push   $0x0
  801871:	6a 01                	push   $0x1
  801873:	e8 98 ff ff ff       	call   801810 <syscall>
  801878:	83 c4 18             	add    $0x18,%esp
}
  80187b:	c9                   	leave  
  80187c:	c3                   	ret    

0080187d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80187d:	55                   	push   %ebp
  80187e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801880:	8b 55 0c             	mov    0xc(%ebp),%edx
  801883:	8b 45 08             	mov    0x8(%ebp),%eax
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	52                   	push   %edx
  80188d:	50                   	push   %eax
  80188e:	6a 05                	push   $0x5
  801890:	e8 7b ff ff ff       	call   801810 <syscall>
  801895:	83 c4 18             	add    $0x18,%esp
}
  801898:	c9                   	leave  
  801899:	c3                   	ret    

0080189a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80189a:	55                   	push   %ebp
  80189b:	89 e5                	mov    %esp,%ebp
  80189d:	56                   	push   %esi
  80189e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80189f:	8b 75 18             	mov    0x18(%ebp),%esi
  8018a2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018a5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ae:	56                   	push   %esi
  8018af:	53                   	push   %ebx
  8018b0:	51                   	push   %ecx
  8018b1:	52                   	push   %edx
  8018b2:	50                   	push   %eax
  8018b3:	6a 06                	push   $0x6
  8018b5:	e8 56 ff ff ff       	call   801810 <syscall>
  8018ba:	83 c4 18             	add    $0x18,%esp
}
  8018bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018c0:	5b                   	pop    %ebx
  8018c1:	5e                   	pop    %esi
  8018c2:	5d                   	pop    %ebp
  8018c3:	c3                   	ret    

008018c4 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018c4:	55                   	push   %ebp
  8018c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	52                   	push   %edx
  8018d4:	50                   	push   %eax
  8018d5:	6a 07                	push   $0x7
  8018d7:	e8 34 ff ff ff       	call   801810 <syscall>
  8018dc:	83 c4 18             	add    $0x18,%esp
}
  8018df:	c9                   	leave  
  8018e0:	c3                   	ret    

008018e1 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018e1:	55                   	push   %ebp
  8018e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	ff 75 0c             	pushl  0xc(%ebp)
  8018ed:	ff 75 08             	pushl  0x8(%ebp)
  8018f0:	6a 08                	push   $0x8
  8018f2:	e8 19 ff ff ff       	call   801810 <syscall>
  8018f7:	83 c4 18             	add    $0x18,%esp
}
  8018fa:	c9                   	leave  
  8018fb:	c3                   	ret    

008018fc <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018fc:	55                   	push   %ebp
  8018fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 09                	push   $0x9
  80190b:	e8 00 ff ff ff       	call   801810 <syscall>
  801910:	83 c4 18             	add    $0x18,%esp
}
  801913:	c9                   	leave  
  801914:	c3                   	ret    

00801915 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801915:	55                   	push   %ebp
  801916:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 0a                	push   $0xa
  801924:	e8 e7 fe ff ff       	call   801810 <syscall>
  801929:	83 c4 18             	add    $0x18,%esp
}
  80192c:	c9                   	leave  
  80192d:	c3                   	ret    

0080192e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 0b                	push   $0xb
  80193d:	e8 ce fe ff ff       	call   801810 <syscall>
  801942:	83 c4 18             	add    $0x18,%esp
}
  801945:	c9                   	leave  
  801946:	c3                   	ret    

00801947 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	ff 75 0c             	pushl  0xc(%ebp)
  801953:	ff 75 08             	pushl  0x8(%ebp)
  801956:	6a 0f                	push   $0xf
  801958:	e8 b3 fe ff ff       	call   801810 <syscall>
  80195d:	83 c4 18             	add    $0x18,%esp
	return;
  801960:	90                   	nop
}
  801961:	c9                   	leave  
  801962:	c3                   	ret    

00801963 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801963:	55                   	push   %ebp
  801964:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	ff 75 0c             	pushl  0xc(%ebp)
  80196f:	ff 75 08             	pushl  0x8(%ebp)
  801972:	6a 10                	push   $0x10
  801974:	e8 97 fe ff ff       	call   801810 <syscall>
  801979:	83 c4 18             	add    $0x18,%esp
	return ;
  80197c:	90                   	nop
}
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    

0080197f <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	ff 75 10             	pushl  0x10(%ebp)
  801989:	ff 75 0c             	pushl  0xc(%ebp)
  80198c:	ff 75 08             	pushl  0x8(%ebp)
  80198f:	6a 11                	push   $0x11
  801991:	e8 7a fe ff ff       	call   801810 <syscall>
  801996:	83 c4 18             	add    $0x18,%esp
	return ;
  801999:	90                   	nop
}
  80199a:	c9                   	leave  
  80199b:	c3                   	ret    

0080199c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 0c                	push   $0xc
  8019ab:	e8 60 fe ff ff       	call   801810 <syscall>
  8019b0:	83 c4 18             	add    $0x18,%esp
}
  8019b3:	c9                   	leave  
  8019b4:	c3                   	ret    

008019b5 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	ff 75 08             	pushl  0x8(%ebp)
  8019c3:	6a 0d                	push   $0xd
  8019c5:	e8 46 fe ff ff       	call   801810 <syscall>
  8019ca:	83 c4 18             	add    $0x18,%esp
}
  8019cd:	c9                   	leave  
  8019ce:	c3                   	ret    

008019cf <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019cf:	55                   	push   %ebp
  8019d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 0e                	push   $0xe
  8019de:	e8 2d fe ff ff       	call   801810 <syscall>
  8019e3:	83 c4 18             	add    $0x18,%esp
}
  8019e6:	90                   	nop
  8019e7:	c9                   	leave  
  8019e8:	c3                   	ret    

008019e9 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019e9:	55                   	push   %ebp
  8019ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 13                	push   $0x13
  8019f8:	e8 13 fe ff ff       	call   801810 <syscall>
  8019fd:	83 c4 18             	add    $0x18,%esp
}
  801a00:	90                   	nop
  801a01:	c9                   	leave  
  801a02:	c3                   	ret    

00801a03 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a03:	55                   	push   %ebp
  801a04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 14                	push   $0x14
  801a12:	e8 f9 fd ff ff       	call   801810 <syscall>
  801a17:	83 c4 18             	add    $0x18,%esp
}
  801a1a:	90                   	nop
  801a1b:	c9                   	leave  
  801a1c:	c3                   	ret    

00801a1d <sys_cputc>:


void
sys_cputc(const char c)
{
  801a1d:	55                   	push   %ebp
  801a1e:	89 e5                	mov    %esp,%ebp
  801a20:	83 ec 04             	sub    $0x4,%esp
  801a23:	8b 45 08             	mov    0x8(%ebp),%eax
  801a26:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a29:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	50                   	push   %eax
  801a36:	6a 15                	push   $0x15
  801a38:	e8 d3 fd ff ff       	call   801810 <syscall>
  801a3d:	83 c4 18             	add    $0x18,%esp
}
  801a40:	90                   	nop
  801a41:	c9                   	leave  
  801a42:	c3                   	ret    

00801a43 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a43:	55                   	push   %ebp
  801a44:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 16                	push   $0x16
  801a52:	e8 b9 fd ff ff       	call   801810 <syscall>
  801a57:	83 c4 18             	add    $0x18,%esp
}
  801a5a:	90                   	nop
  801a5b:	c9                   	leave  
  801a5c:	c3                   	ret    

00801a5d <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a5d:	55                   	push   %ebp
  801a5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a60:	8b 45 08             	mov    0x8(%ebp),%eax
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	ff 75 0c             	pushl  0xc(%ebp)
  801a6c:	50                   	push   %eax
  801a6d:	6a 17                	push   $0x17
  801a6f:	e8 9c fd ff ff       	call   801810 <syscall>
  801a74:	83 c4 18             	add    $0x18,%esp
}
  801a77:	c9                   	leave  
  801a78:	c3                   	ret    

00801a79 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a79:	55                   	push   %ebp
  801a7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	52                   	push   %edx
  801a89:	50                   	push   %eax
  801a8a:	6a 1a                	push   $0x1a
  801a8c:	e8 7f fd ff ff       	call   801810 <syscall>
  801a91:	83 c4 18             	add    $0x18,%esp
}
  801a94:	c9                   	leave  
  801a95:	c3                   	ret    

00801a96 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a99:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	52                   	push   %edx
  801aa6:	50                   	push   %eax
  801aa7:	6a 18                	push   $0x18
  801aa9:	e8 62 fd ff ff       	call   801810 <syscall>
  801aae:	83 c4 18             	add    $0x18,%esp
}
  801ab1:	90                   	nop
  801ab2:	c9                   	leave  
  801ab3:	c3                   	ret    

00801ab4 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ab4:	55                   	push   %ebp
  801ab5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ab7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aba:	8b 45 08             	mov    0x8(%ebp),%eax
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	52                   	push   %edx
  801ac4:	50                   	push   %eax
  801ac5:	6a 19                	push   $0x19
  801ac7:	e8 44 fd ff ff       	call   801810 <syscall>
  801acc:	83 c4 18             	add    $0x18,%esp
}
  801acf:	90                   	nop
  801ad0:	c9                   	leave  
  801ad1:	c3                   	ret    

00801ad2 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ad2:	55                   	push   %ebp
  801ad3:	89 e5                	mov    %esp,%ebp
  801ad5:	83 ec 04             	sub    $0x4,%esp
  801ad8:	8b 45 10             	mov    0x10(%ebp),%eax
  801adb:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ade:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ae1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae8:	6a 00                	push   $0x0
  801aea:	51                   	push   %ecx
  801aeb:	52                   	push   %edx
  801aec:	ff 75 0c             	pushl  0xc(%ebp)
  801aef:	50                   	push   %eax
  801af0:	6a 1b                	push   $0x1b
  801af2:	e8 19 fd ff ff       	call   801810 <syscall>
  801af7:	83 c4 18             	add    $0x18,%esp
}
  801afa:	c9                   	leave  
  801afb:	c3                   	ret    

00801afc <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801afc:	55                   	push   %ebp
  801afd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801aff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b02:	8b 45 08             	mov    0x8(%ebp),%eax
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	52                   	push   %edx
  801b0c:	50                   	push   %eax
  801b0d:	6a 1c                	push   $0x1c
  801b0f:	e8 fc fc ff ff       	call   801810 <syscall>
  801b14:	83 c4 18             	add    $0x18,%esp
}
  801b17:	c9                   	leave  
  801b18:	c3                   	ret    

00801b19 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b1c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b22:	8b 45 08             	mov    0x8(%ebp),%eax
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	51                   	push   %ecx
  801b2a:	52                   	push   %edx
  801b2b:	50                   	push   %eax
  801b2c:	6a 1d                	push   $0x1d
  801b2e:	e8 dd fc ff ff       	call   801810 <syscall>
  801b33:	83 c4 18             	add    $0x18,%esp
}
  801b36:	c9                   	leave  
  801b37:	c3                   	ret    

00801b38 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b38:	55                   	push   %ebp
  801b39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	52                   	push   %edx
  801b48:	50                   	push   %eax
  801b49:	6a 1e                	push   $0x1e
  801b4b:	e8 c0 fc ff ff       	call   801810 <syscall>
  801b50:	83 c4 18             	add    $0x18,%esp
}
  801b53:	c9                   	leave  
  801b54:	c3                   	ret    

00801b55 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b55:	55                   	push   %ebp
  801b56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	6a 1f                	push   $0x1f
  801b64:	e8 a7 fc ff ff       	call   801810 <syscall>
  801b69:	83 c4 18             	add    $0x18,%esp
}
  801b6c:	c9                   	leave  
  801b6d:	c3                   	ret    

00801b6e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b71:	8b 45 08             	mov    0x8(%ebp),%eax
  801b74:	6a 00                	push   $0x0
  801b76:	ff 75 14             	pushl  0x14(%ebp)
  801b79:	ff 75 10             	pushl  0x10(%ebp)
  801b7c:	ff 75 0c             	pushl  0xc(%ebp)
  801b7f:	50                   	push   %eax
  801b80:	6a 20                	push   $0x20
  801b82:	e8 89 fc ff ff       	call   801810 <syscall>
  801b87:	83 c4 18             	add    $0x18,%esp
}
  801b8a:	c9                   	leave  
  801b8b:	c3                   	ret    

00801b8c <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	50                   	push   %eax
  801b9b:	6a 21                	push   $0x21
  801b9d:	e8 6e fc ff ff       	call   801810 <syscall>
  801ba2:	83 c4 18             	add    $0x18,%esp
}
  801ba5:	90                   	nop
  801ba6:	c9                   	leave  
  801ba7:	c3                   	ret    

00801ba8 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ba8:	55                   	push   %ebp
  801ba9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bab:	8b 45 08             	mov    0x8(%ebp),%eax
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	50                   	push   %eax
  801bb7:	6a 22                	push   $0x22
  801bb9:	e8 52 fc ff ff       	call   801810 <syscall>
  801bbe:	83 c4 18             	add    $0x18,%esp
}
  801bc1:	c9                   	leave  
  801bc2:	c3                   	ret    

00801bc3 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 02                	push   $0x2
  801bd2:	e8 39 fc ff ff       	call   801810 <syscall>
  801bd7:	83 c4 18             	add    $0x18,%esp
}
  801bda:	c9                   	leave  
  801bdb:	c3                   	ret    

00801bdc <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 03                	push   $0x3
  801beb:	e8 20 fc ff ff       	call   801810 <syscall>
  801bf0:	83 c4 18             	add    $0x18,%esp
}
  801bf3:	c9                   	leave  
  801bf4:	c3                   	ret    

00801bf5 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bf5:	55                   	push   %ebp
  801bf6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 04                	push   $0x4
  801c04:	e8 07 fc ff ff       	call   801810 <syscall>
  801c09:	83 c4 18             	add    $0x18,%esp
}
  801c0c:	c9                   	leave  
  801c0d:	c3                   	ret    

00801c0e <sys_exit_env>:


void sys_exit_env(void)
{
  801c0e:	55                   	push   %ebp
  801c0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 23                	push   $0x23
  801c1d:	e8 ee fb ff ff       	call   801810 <syscall>
  801c22:	83 c4 18             	add    $0x18,%esp
}
  801c25:	90                   	nop
  801c26:	c9                   	leave  
  801c27:	c3                   	ret    

00801c28 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
  801c2b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c2e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c31:	8d 50 04             	lea    0x4(%eax),%edx
  801c34:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	52                   	push   %edx
  801c3e:	50                   	push   %eax
  801c3f:	6a 24                	push   $0x24
  801c41:	e8 ca fb ff ff       	call   801810 <syscall>
  801c46:	83 c4 18             	add    $0x18,%esp
	return result;
  801c49:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c4c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c4f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c52:	89 01                	mov    %eax,(%ecx)
  801c54:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c57:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5a:	c9                   	leave  
  801c5b:	c2 04 00             	ret    $0x4

00801c5e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c5e:	55                   	push   %ebp
  801c5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	ff 75 10             	pushl  0x10(%ebp)
  801c68:	ff 75 0c             	pushl  0xc(%ebp)
  801c6b:	ff 75 08             	pushl  0x8(%ebp)
  801c6e:	6a 12                	push   $0x12
  801c70:	e8 9b fb ff ff       	call   801810 <syscall>
  801c75:	83 c4 18             	add    $0x18,%esp
	return ;
  801c78:	90                   	nop
}
  801c79:	c9                   	leave  
  801c7a:	c3                   	ret    

00801c7b <sys_rcr2>:
uint32 sys_rcr2()
{
  801c7b:	55                   	push   %ebp
  801c7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 25                	push   $0x25
  801c8a:	e8 81 fb ff ff       	call   801810 <syscall>
  801c8f:	83 c4 18             	add    $0x18,%esp
}
  801c92:	c9                   	leave  
  801c93:	c3                   	ret    

00801c94 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c94:	55                   	push   %ebp
  801c95:	89 e5                	mov    %esp,%ebp
  801c97:	83 ec 04             	sub    $0x4,%esp
  801c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ca0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	50                   	push   %eax
  801cad:	6a 26                	push   $0x26
  801caf:	e8 5c fb ff ff       	call   801810 <syscall>
  801cb4:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb7:	90                   	nop
}
  801cb8:	c9                   	leave  
  801cb9:	c3                   	ret    

00801cba <rsttst>:
void rsttst()
{
  801cba:	55                   	push   %ebp
  801cbb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 28                	push   $0x28
  801cc9:	e8 42 fb ff ff       	call   801810 <syscall>
  801cce:	83 c4 18             	add    $0x18,%esp
	return ;
  801cd1:	90                   	nop
}
  801cd2:	c9                   	leave  
  801cd3:	c3                   	ret    

00801cd4 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
  801cd7:	83 ec 04             	sub    $0x4,%esp
  801cda:	8b 45 14             	mov    0x14(%ebp),%eax
  801cdd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ce0:	8b 55 18             	mov    0x18(%ebp),%edx
  801ce3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ce7:	52                   	push   %edx
  801ce8:	50                   	push   %eax
  801ce9:	ff 75 10             	pushl  0x10(%ebp)
  801cec:	ff 75 0c             	pushl  0xc(%ebp)
  801cef:	ff 75 08             	pushl  0x8(%ebp)
  801cf2:	6a 27                	push   $0x27
  801cf4:	e8 17 fb ff ff       	call   801810 <syscall>
  801cf9:	83 c4 18             	add    $0x18,%esp
	return ;
  801cfc:	90                   	nop
}
  801cfd:	c9                   	leave  
  801cfe:	c3                   	ret    

00801cff <chktst>:
void chktst(uint32 n)
{
  801cff:	55                   	push   %ebp
  801d00:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	ff 75 08             	pushl  0x8(%ebp)
  801d0d:	6a 29                	push   $0x29
  801d0f:	e8 fc fa ff ff       	call   801810 <syscall>
  801d14:	83 c4 18             	add    $0x18,%esp
	return ;
  801d17:	90                   	nop
}
  801d18:	c9                   	leave  
  801d19:	c3                   	ret    

00801d1a <inctst>:

void inctst()
{
  801d1a:	55                   	push   %ebp
  801d1b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 2a                	push   $0x2a
  801d29:	e8 e2 fa ff ff       	call   801810 <syscall>
  801d2e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d31:	90                   	nop
}
  801d32:	c9                   	leave  
  801d33:	c3                   	ret    

00801d34 <gettst>:
uint32 gettst()
{
  801d34:	55                   	push   %ebp
  801d35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 2b                	push   $0x2b
  801d43:	e8 c8 fa ff ff       	call   801810 <syscall>
  801d48:	83 c4 18             	add    $0x18,%esp
}
  801d4b:	c9                   	leave  
  801d4c:	c3                   	ret    

00801d4d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d4d:	55                   	push   %ebp
  801d4e:	89 e5                	mov    %esp,%ebp
  801d50:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 2c                	push   $0x2c
  801d5f:	e8 ac fa ff ff       	call   801810 <syscall>
  801d64:	83 c4 18             	add    $0x18,%esp
  801d67:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d6a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d6e:	75 07                	jne    801d77 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d70:	b8 01 00 00 00       	mov    $0x1,%eax
  801d75:	eb 05                	jmp    801d7c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d7c:	c9                   	leave  
  801d7d:	c3                   	ret    

00801d7e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d7e:	55                   	push   %ebp
  801d7f:	89 e5                	mov    %esp,%ebp
  801d81:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 2c                	push   $0x2c
  801d90:	e8 7b fa ff ff       	call   801810 <syscall>
  801d95:	83 c4 18             	add    $0x18,%esp
  801d98:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d9b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d9f:	75 07                	jne    801da8 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801da1:	b8 01 00 00 00       	mov    $0x1,%eax
  801da6:	eb 05                	jmp    801dad <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801da8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dad:	c9                   	leave  
  801dae:	c3                   	ret    

00801daf <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801daf:	55                   	push   %ebp
  801db0:	89 e5                	mov    %esp,%ebp
  801db2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 2c                	push   $0x2c
  801dc1:	e8 4a fa ff ff       	call   801810 <syscall>
  801dc6:	83 c4 18             	add    $0x18,%esp
  801dc9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801dcc:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801dd0:	75 07                	jne    801dd9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801dd2:	b8 01 00 00 00       	mov    $0x1,%eax
  801dd7:	eb 05                	jmp    801dde <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801dd9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dde:	c9                   	leave  
  801ddf:	c3                   	ret    

00801de0 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801de0:	55                   	push   %ebp
  801de1:	89 e5                	mov    %esp,%ebp
  801de3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 2c                	push   $0x2c
  801df2:	e8 19 fa ff ff       	call   801810 <syscall>
  801df7:	83 c4 18             	add    $0x18,%esp
  801dfa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801dfd:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e01:	75 07                	jne    801e0a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e03:	b8 01 00 00 00       	mov    $0x1,%eax
  801e08:	eb 05                	jmp    801e0f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e0f:	c9                   	leave  
  801e10:	c3                   	ret    

00801e11 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e11:	55                   	push   %ebp
  801e12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e14:	6a 00                	push   $0x0
  801e16:	6a 00                	push   $0x0
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 00                	push   $0x0
  801e1c:	ff 75 08             	pushl  0x8(%ebp)
  801e1f:	6a 2d                	push   $0x2d
  801e21:	e8 ea f9 ff ff       	call   801810 <syscall>
  801e26:	83 c4 18             	add    $0x18,%esp
	return ;
  801e29:	90                   	nop
}
  801e2a:	c9                   	leave  
  801e2b:	c3                   	ret    

00801e2c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e2c:	55                   	push   %ebp
  801e2d:	89 e5                	mov    %esp,%ebp
  801e2f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e30:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e33:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e36:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e39:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3c:	6a 00                	push   $0x0
  801e3e:	53                   	push   %ebx
  801e3f:	51                   	push   %ecx
  801e40:	52                   	push   %edx
  801e41:	50                   	push   %eax
  801e42:	6a 2e                	push   $0x2e
  801e44:	e8 c7 f9 ff ff       	call   801810 <syscall>
  801e49:	83 c4 18             	add    $0x18,%esp
}
  801e4c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e4f:	c9                   	leave  
  801e50:	c3                   	ret    

00801e51 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e51:	55                   	push   %ebp
  801e52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e54:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e57:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	52                   	push   %edx
  801e61:	50                   	push   %eax
  801e62:	6a 2f                	push   $0x2f
  801e64:	e8 a7 f9 ff ff       	call   801810 <syscall>
  801e69:	83 c4 18             	add    $0x18,%esp
}
  801e6c:	c9                   	leave  
  801e6d:	c3                   	ret    

00801e6e <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e6e:	55                   	push   %ebp
  801e6f:	89 e5                	mov    %esp,%ebp
  801e71:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e74:	83 ec 0c             	sub    $0xc,%esp
  801e77:	68 80 3a 80 00       	push   $0x803a80
  801e7c:	e8 c3 e6 ff ff       	call   800544 <cprintf>
  801e81:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e84:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e8b:	83 ec 0c             	sub    $0xc,%esp
  801e8e:	68 ac 3a 80 00       	push   $0x803aac
  801e93:	e8 ac e6 ff ff       	call   800544 <cprintf>
  801e98:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e9b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e9f:	a1 38 41 80 00       	mov    0x804138,%eax
  801ea4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ea7:	eb 56                	jmp    801eff <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ea9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ead:	74 1c                	je     801ecb <print_mem_block_lists+0x5d>
  801eaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb2:	8b 50 08             	mov    0x8(%eax),%edx
  801eb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eb8:	8b 48 08             	mov    0x8(%eax),%ecx
  801ebb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ebe:	8b 40 0c             	mov    0xc(%eax),%eax
  801ec1:	01 c8                	add    %ecx,%eax
  801ec3:	39 c2                	cmp    %eax,%edx
  801ec5:	73 04                	jae    801ecb <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ec7:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ece:	8b 50 08             	mov    0x8(%eax),%edx
  801ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed4:	8b 40 0c             	mov    0xc(%eax),%eax
  801ed7:	01 c2                	add    %eax,%edx
  801ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801edc:	8b 40 08             	mov    0x8(%eax),%eax
  801edf:	83 ec 04             	sub    $0x4,%esp
  801ee2:	52                   	push   %edx
  801ee3:	50                   	push   %eax
  801ee4:	68 c1 3a 80 00       	push   $0x803ac1
  801ee9:	e8 56 e6 ff ff       	call   800544 <cprintf>
  801eee:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ef1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ef7:	a1 40 41 80 00       	mov    0x804140,%eax
  801efc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f03:	74 07                	je     801f0c <print_mem_block_lists+0x9e>
  801f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f08:	8b 00                	mov    (%eax),%eax
  801f0a:	eb 05                	jmp    801f11 <print_mem_block_lists+0xa3>
  801f0c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f11:	a3 40 41 80 00       	mov    %eax,0x804140
  801f16:	a1 40 41 80 00       	mov    0x804140,%eax
  801f1b:	85 c0                	test   %eax,%eax
  801f1d:	75 8a                	jne    801ea9 <print_mem_block_lists+0x3b>
  801f1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f23:	75 84                	jne    801ea9 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f25:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f29:	75 10                	jne    801f3b <print_mem_block_lists+0xcd>
  801f2b:	83 ec 0c             	sub    $0xc,%esp
  801f2e:	68 d0 3a 80 00       	push   $0x803ad0
  801f33:	e8 0c e6 ff ff       	call   800544 <cprintf>
  801f38:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f3b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f42:	83 ec 0c             	sub    $0xc,%esp
  801f45:	68 f4 3a 80 00       	push   $0x803af4
  801f4a:	e8 f5 e5 ff ff       	call   800544 <cprintf>
  801f4f:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f52:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f56:	a1 40 40 80 00       	mov    0x804040,%eax
  801f5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f5e:	eb 56                	jmp    801fb6 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f60:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f64:	74 1c                	je     801f82 <print_mem_block_lists+0x114>
  801f66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f69:	8b 50 08             	mov    0x8(%eax),%edx
  801f6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f6f:	8b 48 08             	mov    0x8(%eax),%ecx
  801f72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f75:	8b 40 0c             	mov    0xc(%eax),%eax
  801f78:	01 c8                	add    %ecx,%eax
  801f7a:	39 c2                	cmp    %eax,%edx
  801f7c:	73 04                	jae    801f82 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f7e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f85:	8b 50 08             	mov    0x8(%eax),%edx
  801f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8b:	8b 40 0c             	mov    0xc(%eax),%eax
  801f8e:	01 c2                	add    %eax,%edx
  801f90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f93:	8b 40 08             	mov    0x8(%eax),%eax
  801f96:	83 ec 04             	sub    $0x4,%esp
  801f99:	52                   	push   %edx
  801f9a:	50                   	push   %eax
  801f9b:	68 c1 3a 80 00       	push   $0x803ac1
  801fa0:	e8 9f e5 ff ff       	call   800544 <cprintf>
  801fa5:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fab:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fae:	a1 48 40 80 00       	mov    0x804048,%eax
  801fb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fb6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fba:	74 07                	je     801fc3 <print_mem_block_lists+0x155>
  801fbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbf:	8b 00                	mov    (%eax),%eax
  801fc1:	eb 05                	jmp    801fc8 <print_mem_block_lists+0x15a>
  801fc3:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc8:	a3 48 40 80 00       	mov    %eax,0x804048
  801fcd:	a1 48 40 80 00       	mov    0x804048,%eax
  801fd2:	85 c0                	test   %eax,%eax
  801fd4:	75 8a                	jne    801f60 <print_mem_block_lists+0xf2>
  801fd6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fda:	75 84                	jne    801f60 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fdc:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fe0:	75 10                	jne    801ff2 <print_mem_block_lists+0x184>
  801fe2:	83 ec 0c             	sub    $0xc,%esp
  801fe5:	68 0c 3b 80 00       	push   $0x803b0c
  801fea:	e8 55 e5 ff ff       	call   800544 <cprintf>
  801fef:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801ff2:	83 ec 0c             	sub    $0xc,%esp
  801ff5:	68 80 3a 80 00       	push   $0x803a80
  801ffa:	e8 45 e5 ff ff       	call   800544 <cprintf>
  801fff:	83 c4 10             	add    $0x10,%esp

}
  802002:	90                   	nop
  802003:	c9                   	leave  
  802004:	c3                   	ret    

00802005 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802005:	55                   	push   %ebp
  802006:	89 e5                	mov    %esp,%ebp
  802008:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  80200b:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802012:	00 00 00 
  802015:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  80201c:	00 00 00 
  80201f:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802026:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802029:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802030:	e9 9e 00 00 00       	jmp    8020d3 <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802035:	a1 50 40 80 00       	mov    0x804050,%eax
  80203a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80203d:	c1 e2 04             	shl    $0x4,%edx
  802040:	01 d0                	add    %edx,%eax
  802042:	85 c0                	test   %eax,%eax
  802044:	75 14                	jne    80205a <initialize_MemBlocksList+0x55>
  802046:	83 ec 04             	sub    $0x4,%esp
  802049:	68 34 3b 80 00       	push   $0x803b34
  80204e:	6a 47                	push   $0x47
  802050:	68 57 3b 80 00       	push   $0x803b57
  802055:	e8 36 e2 ff ff       	call   800290 <_panic>
  80205a:	a1 50 40 80 00       	mov    0x804050,%eax
  80205f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802062:	c1 e2 04             	shl    $0x4,%edx
  802065:	01 d0                	add    %edx,%eax
  802067:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80206d:	89 10                	mov    %edx,(%eax)
  80206f:	8b 00                	mov    (%eax),%eax
  802071:	85 c0                	test   %eax,%eax
  802073:	74 18                	je     80208d <initialize_MemBlocksList+0x88>
  802075:	a1 48 41 80 00       	mov    0x804148,%eax
  80207a:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802080:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802083:	c1 e1 04             	shl    $0x4,%ecx
  802086:	01 ca                	add    %ecx,%edx
  802088:	89 50 04             	mov    %edx,0x4(%eax)
  80208b:	eb 12                	jmp    80209f <initialize_MemBlocksList+0x9a>
  80208d:	a1 50 40 80 00       	mov    0x804050,%eax
  802092:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802095:	c1 e2 04             	shl    $0x4,%edx
  802098:	01 d0                	add    %edx,%eax
  80209a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80209f:	a1 50 40 80 00       	mov    0x804050,%eax
  8020a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020a7:	c1 e2 04             	shl    $0x4,%edx
  8020aa:	01 d0                	add    %edx,%eax
  8020ac:	a3 48 41 80 00       	mov    %eax,0x804148
  8020b1:	a1 50 40 80 00       	mov    0x804050,%eax
  8020b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020b9:	c1 e2 04             	shl    $0x4,%edx
  8020bc:	01 d0                	add    %edx,%eax
  8020be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020c5:	a1 54 41 80 00       	mov    0x804154,%eax
  8020ca:	40                   	inc    %eax
  8020cb:	a3 54 41 80 00       	mov    %eax,0x804154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  8020d0:	ff 45 f4             	incl   -0xc(%ebp)
  8020d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020d9:	0f 82 56 ff ff ff    	jb     802035 <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  8020df:	90                   	nop
  8020e0:	c9                   	leave  
  8020e1:	c3                   	ret    

008020e2 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020e2:	55                   	push   %ebp
  8020e3:	89 e5                	mov    %esp,%ebp
  8020e5:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  8020e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020eb:	8b 00                	mov    (%eax),%eax
  8020ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020f0:	eb 19                	jmp    80210b <find_block+0x29>
	{
		if(element->sva == va){
  8020f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020f5:	8b 40 08             	mov    0x8(%eax),%eax
  8020f8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8020fb:	75 05                	jne    802102 <find_block+0x20>
			 		return element;
  8020fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802100:	eb 36                	jmp    802138 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802102:	8b 45 08             	mov    0x8(%ebp),%eax
  802105:	8b 40 08             	mov    0x8(%eax),%eax
  802108:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80210b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80210f:	74 07                	je     802118 <find_block+0x36>
  802111:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802114:	8b 00                	mov    (%eax),%eax
  802116:	eb 05                	jmp    80211d <find_block+0x3b>
  802118:	b8 00 00 00 00       	mov    $0x0,%eax
  80211d:	8b 55 08             	mov    0x8(%ebp),%edx
  802120:	89 42 08             	mov    %eax,0x8(%edx)
  802123:	8b 45 08             	mov    0x8(%ebp),%eax
  802126:	8b 40 08             	mov    0x8(%eax),%eax
  802129:	85 c0                	test   %eax,%eax
  80212b:	75 c5                	jne    8020f2 <find_block+0x10>
  80212d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802131:	75 bf                	jne    8020f2 <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  802133:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802138:	c9                   	leave  
  802139:	c3                   	ret    

0080213a <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80213a:	55                   	push   %ebp
  80213b:	89 e5                	mov    %esp,%ebp
  80213d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  802140:	a1 44 40 80 00       	mov    0x804044,%eax
  802145:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  802148:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80214d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  802150:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802154:	74 0a                	je     802160 <insert_sorted_allocList+0x26>
  802156:	8b 45 08             	mov    0x8(%ebp),%eax
  802159:	8b 40 08             	mov    0x8(%eax),%eax
  80215c:	85 c0                	test   %eax,%eax
  80215e:	75 65                	jne    8021c5 <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802160:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802164:	75 14                	jne    80217a <insert_sorted_allocList+0x40>
  802166:	83 ec 04             	sub    $0x4,%esp
  802169:	68 34 3b 80 00       	push   $0x803b34
  80216e:	6a 6e                	push   $0x6e
  802170:	68 57 3b 80 00       	push   $0x803b57
  802175:	e8 16 e1 ff ff       	call   800290 <_panic>
  80217a:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802180:	8b 45 08             	mov    0x8(%ebp),%eax
  802183:	89 10                	mov    %edx,(%eax)
  802185:	8b 45 08             	mov    0x8(%ebp),%eax
  802188:	8b 00                	mov    (%eax),%eax
  80218a:	85 c0                	test   %eax,%eax
  80218c:	74 0d                	je     80219b <insert_sorted_allocList+0x61>
  80218e:	a1 40 40 80 00       	mov    0x804040,%eax
  802193:	8b 55 08             	mov    0x8(%ebp),%edx
  802196:	89 50 04             	mov    %edx,0x4(%eax)
  802199:	eb 08                	jmp    8021a3 <insert_sorted_allocList+0x69>
  80219b:	8b 45 08             	mov    0x8(%ebp),%eax
  80219e:	a3 44 40 80 00       	mov    %eax,0x804044
  8021a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a6:	a3 40 40 80 00       	mov    %eax,0x804040
  8021ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021b5:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021ba:	40                   	inc    %eax
  8021bb:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8021c0:	e9 cf 01 00 00       	jmp    802394 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  8021c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c8:	8b 50 08             	mov    0x8(%eax),%edx
  8021cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ce:	8b 40 08             	mov    0x8(%eax),%eax
  8021d1:	39 c2                	cmp    %eax,%edx
  8021d3:	73 65                	jae    80223a <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8021d5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021d9:	75 14                	jne    8021ef <insert_sorted_allocList+0xb5>
  8021db:	83 ec 04             	sub    $0x4,%esp
  8021de:	68 70 3b 80 00       	push   $0x803b70
  8021e3:	6a 72                	push   $0x72
  8021e5:	68 57 3b 80 00       	push   $0x803b57
  8021ea:	e8 a1 e0 ff ff       	call   800290 <_panic>
  8021ef:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8021f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f8:	89 50 04             	mov    %edx,0x4(%eax)
  8021fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fe:	8b 40 04             	mov    0x4(%eax),%eax
  802201:	85 c0                	test   %eax,%eax
  802203:	74 0c                	je     802211 <insert_sorted_allocList+0xd7>
  802205:	a1 44 40 80 00       	mov    0x804044,%eax
  80220a:	8b 55 08             	mov    0x8(%ebp),%edx
  80220d:	89 10                	mov    %edx,(%eax)
  80220f:	eb 08                	jmp    802219 <insert_sorted_allocList+0xdf>
  802211:	8b 45 08             	mov    0x8(%ebp),%eax
  802214:	a3 40 40 80 00       	mov    %eax,0x804040
  802219:	8b 45 08             	mov    0x8(%ebp),%eax
  80221c:	a3 44 40 80 00       	mov    %eax,0x804044
  802221:	8b 45 08             	mov    0x8(%ebp),%eax
  802224:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80222a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80222f:	40                   	inc    %eax
  802230:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  802235:	e9 5a 01 00 00       	jmp    802394 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  80223a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80223d:	8b 50 08             	mov    0x8(%eax),%edx
  802240:	8b 45 08             	mov    0x8(%ebp),%eax
  802243:	8b 40 08             	mov    0x8(%eax),%eax
  802246:	39 c2                	cmp    %eax,%edx
  802248:	75 70                	jne    8022ba <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  80224a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80224e:	74 06                	je     802256 <insert_sorted_allocList+0x11c>
  802250:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802254:	75 14                	jne    80226a <insert_sorted_allocList+0x130>
  802256:	83 ec 04             	sub    $0x4,%esp
  802259:	68 94 3b 80 00       	push   $0x803b94
  80225e:	6a 75                	push   $0x75
  802260:	68 57 3b 80 00       	push   $0x803b57
  802265:	e8 26 e0 ff ff       	call   800290 <_panic>
  80226a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80226d:	8b 10                	mov    (%eax),%edx
  80226f:	8b 45 08             	mov    0x8(%ebp),%eax
  802272:	89 10                	mov    %edx,(%eax)
  802274:	8b 45 08             	mov    0x8(%ebp),%eax
  802277:	8b 00                	mov    (%eax),%eax
  802279:	85 c0                	test   %eax,%eax
  80227b:	74 0b                	je     802288 <insert_sorted_allocList+0x14e>
  80227d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802280:	8b 00                	mov    (%eax),%eax
  802282:	8b 55 08             	mov    0x8(%ebp),%edx
  802285:	89 50 04             	mov    %edx,0x4(%eax)
  802288:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80228b:	8b 55 08             	mov    0x8(%ebp),%edx
  80228e:	89 10                	mov    %edx,(%eax)
  802290:	8b 45 08             	mov    0x8(%ebp),%eax
  802293:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802296:	89 50 04             	mov    %edx,0x4(%eax)
  802299:	8b 45 08             	mov    0x8(%ebp),%eax
  80229c:	8b 00                	mov    (%eax),%eax
  80229e:	85 c0                	test   %eax,%eax
  8022a0:	75 08                	jne    8022aa <insert_sorted_allocList+0x170>
  8022a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a5:	a3 44 40 80 00       	mov    %eax,0x804044
  8022aa:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022af:	40                   	inc    %eax
  8022b0:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  8022b5:	e9 da 00 00 00       	jmp    802394 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  8022ba:	a1 40 40 80 00       	mov    0x804040,%eax
  8022bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022c2:	e9 9d 00 00 00       	jmp    802364 <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  8022c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ca:	8b 00                	mov    (%eax),%eax
  8022cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  8022cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d2:	8b 50 08             	mov    0x8(%eax),%edx
  8022d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d8:	8b 40 08             	mov    0x8(%eax),%eax
  8022db:	39 c2                	cmp    %eax,%edx
  8022dd:	76 7d                	jbe    80235c <insert_sorted_allocList+0x222>
  8022df:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e2:	8b 50 08             	mov    0x8(%eax),%edx
  8022e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022e8:	8b 40 08             	mov    0x8(%eax),%eax
  8022eb:	39 c2                	cmp    %eax,%edx
  8022ed:	73 6d                	jae    80235c <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  8022ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022f3:	74 06                	je     8022fb <insert_sorted_allocList+0x1c1>
  8022f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022f9:	75 14                	jne    80230f <insert_sorted_allocList+0x1d5>
  8022fb:	83 ec 04             	sub    $0x4,%esp
  8022fe:	68 94 3b 80 00       	push   $0x803b94
  802303:	6a 7c                	push   $0x7c
  802305:	68 57 3b 80 00       	push   $0x803b57
  80230a:	e8 81 df ff ff       	call   800290 <_panic>
  80230f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802312:	8b 10                	mov    (%eax),%edx
  802314:	8b 45 08             	mov    0x8(%ebp),%eax
  802317:	89 10                	mov    %edx,(%eax)
  802319:	8b 45 08             	mov    0x8(%ebp),%eax
  80231c:	8b 00                	mov    (%eax),%eax
  80231e:	85 c0                	test   %eax,%eax
  802320:	74 0b                	je     80232d <insert_sorted_allocList+0x1f3>
  802322:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802325:	8b 00                	mov    (%eax),%eax
  802327:	8b 55 08             	mov    0x8(%ebp),%edx
  80232a:	89 50 04             	mov    %edx,0x4(%eax)
  80232d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802330:	8b 55 08             	mov    0x8(%ebp),%edx
  802333:	89 10                	mov    %edx,(%eax)
  802335:	8b 45 08             	mov    0x8(%ebp),%eax
  802338:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80233b:	89 50 04             	mov    %edx,0x4(%eax)
  80233e:	8b 45 08             	mov    0x8(%ebp),%eax
  802341:	8b 00                	mov    (%eax),%eax
  802343:	85 c0                	test   %eax,%eax
  802345:	75 08                	jne    80234f <insert_sorted_allocList+0x215>
  802347:	8b 45 08             	mov    0x8(%ebp),%eax
  80234a:	a3 44 40 80 00       	mov    %eax,0x804044
  80234f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802354:	40                   	inc    %eax
  802355:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  80235a:	eb 38                	jmp    802394 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  80235c:	a1 48 40 80 00       	mov    0x804048,%eax
  802361:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802364:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802368:	74 07                	je     802371 <insert_sorted_allocList+0x237>
  80236a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236d:	8b 00                	mov    (%eax),%eax
  80236f:	eb 05                	jmp    802376 <insert_sorted_allocList+0x23c>
  802371:	b8 00 00 00 00       	mov    $0x0,%eax
  802376:	a3 48 40 80 00       	mov    %eax,0x804048
  80237b:	a1 48 40 80 00       	mov    0x804048,%eax
  802380:	85 c0                	test   %eax,%eax
  802382:	0f 85 3f ff ff ff    	jne    8022c7 <insert_sorted_allocList+0x18d>
  802388:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80238c:	0f 85 35 ff ff ff    	jne    8022c7 <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  802392:	eb 00                	jmp    802394 <insert_sorted_allocList+0x25a>
  802394:	90                   	nop
  802395:	c9                   	leave  
  802396:	c3                   	ret    

00802397 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802397:	55                   	push   %ebp
  802398:	89 e5                	mov    %esp,%ebp
  80239a:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  80239d:	a1 38 41 80 00       	mov    0x804138,%eax
  8023a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023a5:	e9 6b 02 00 00       	jmp    802615 <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  8023aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8023b0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023b3:	0f 85 90 00 00 00    	jne    802449 <alloc_block_FF+0xb2>
			  temp=element;
  8023b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bc:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  8023bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023c3:	75 17                	jne    8023dc <alloc_block_FF+0x45>
  8023c5:	83 ec 04             	sub    $0x4,%esp
  8023c8:	68 c8 3b 80 00       	push   $0x803bc8
  8023cd:	68 92 00 00 00       	push   $0x92
  8023d2:	68 57 3b 80 00       	push   $0x803b57
  8023d7:	e8 b4 de ff ff       	call   800290 <_panic>
  8023dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023df:	8b 00                	mov    (%eax),%eax
  8023e1:	85 c0                	test   %eax,%eax
  8023e3:	74 10                	je     8023f5 <alloc_block_FF+0x5e>
  8023e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e8:	8b 00                	mov    (%eax),%eax
  8023ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023ed:	8b 52 04             	mov    0x4(%edx),%edx
  8023f0:	89 50 04             	mov    %edx,0x4(%eax)
  8023f3:	eb 0b                	jmp    802400 <alloc_block_FF+0x69>
  8023f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f8:	8b 40 04             	mov    0x4(%eax),%eax
  8023fb:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802400:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802403:	8b 40 04             	mov    0x4(%eax),%eax
  802406:	85 c0                	test   %eax,%eax
  802408:	74 0f                	je     802419 <alloc_block_FF+0x82>
  80240a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240d:	8b 40 04             	mov    0x4(%eax),%eax
  802410:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802413:	8b 12                	mov    (%edx),%edx
  802415:	89 10                	mov    %edx,(%eax)
  802417:	eb 0a                	jmp    802423 <alloc_block_FF+0x8c>
  802419:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241c:	8b 00                	mov    (%eax),%eax
  80241e:	a3 38 41 80 00       	mov    %eax,0x804138
  802423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802426:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80242c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802436:	a1 44 41 80 00       	mov    0x804144,%eax
  80243b:	48                   	dec    %eax
  80243c:	a3 44 41 80 00       	mov    %eax,0x804144
			  return temp;
  802441:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802444:	e9 ff 01 00 00       	jmp    802648 <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  802449:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244c:	8b 40 0c             	mov    0xc(%eax),%eax
  80244f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802452:	0f 86 b5 01 00 00    	jbe    80260d <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  802458:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245b:	8b 40 0c             	mov    0xc(%eax),%eax
  80245e:	2b 45 08             	sub    0x8(%ebp),%eax
  802461:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  802464:	a1 48 41 80 00       	mov    0x804148,%eax
  802469:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  80246c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802470:	75 17                	jne    802489 <alloc_block_FF+0xf2>
  802472:	83 ec 04             	sub    $0x4,%esp
  802475:	68 c8 3b 80 00       	push   $0x803bc8
  80247a:	68 99 00 00 00       	push   $0x99
  80247f:	68 57 3b 80 00       	push   $0x803b57
  802484:	e8 07 de ff ff       	call   800290 <_panic>
  802489:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80248c:	8b 00                	mov    (%eax),%eax
  80248e:	85 c0                	test   %eax,%eax
  802490:	74 10                	je     8024a2 <alloc_block_FF+0x10b>
  802492:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802495:	8b 00                	mov    (%eax),%eax
  802497:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80249a:	8b 52 04             	mov    0x4(%edx),%edx
  80249d:	89 50 04             	mov    %edx,0x4(%eax)
  8024a0:	eb 0b                	jmp    8024ad <alloc_block_FF+0x116>
  8024a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024a5:	8b 40 04             	mov    0x4(%eax),%eax
  8024a8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8024ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024b0:	8b 40 04             	mov    0x4(%eax),%eax
  8024b3:	85 c0                	test   %eax,%eax
  8024b5:	74 0f                	je     8024c6 <alloc_block_FF+0x12f>
  8024b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024ba:	8b 40 04             	mov    0x4(%eax),%eax
  8024bd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024c0:	8b 12                	mov    (%edx),%edx
  8024c2:	89 10                	mov    %edx,(%eax)
  8024c4:	eb 0a                	jmp    8024d0 <alloc_block_FF+0x139>
  8024c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024c9:	8b 00                	mov    (%eax),%eax
  8024cb:	a3 48 41 80 00       	mov    %eax,0x804148
  8024d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024e3:	a1 54 41 80 00       	mov    0x804154,%eax
  8024e8:	48                   	dec    %eax
  8024e9:	a3 54 41 80 00       	mov    %eax,0x804154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  8024ee:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8024f2:	75 17                	jne    80250b <alloc_block_FF+0x174>
  8024f4:	83 ec 04             	sub    $0x4,%esp
  8024f7:	68 70 3b 80 00       	push   $0x803b70
  8024fc:	68 9a 00 00 00       	push   $0x9a
  802501:	68 57 3b 80 00       	push   $0x803b57
  802506:	e8 85 dd ff ff       	call   800290 <_panic>
  80250b:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802511:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802514:	89 50 04             	mov    %edx,0x4(%eax)
  802517:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80251a:	8b 40 04             	mov    0x4(%eax),%eax
  80251d:	85 c0                	test   %eax,%eax
  80251f:	74 0c                	je     80252d <alloc_block_FF+0x196>
  802521:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802526:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802529:	89 10                	mov    %edx,(%eax)
  80252b:	eb 08                	jmp    802535 <alloc_block_FF+0x19e>
  80252d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802530:	a3 38 41 80 00       	mov    %eax,0x804138
  802535:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802538:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80253d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802540:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802546:	a1 44 41 80 00       	mov    0x804144,%eax
  80254b:	40                   	inc    %eax
  80254c:	a3 44 41 80 00       	mov    %eax,0x804144
		  // setting the size & sva
		  new_block->size=size;
  802551:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802554:	8b 55 08             	mov    0x8(%ebp),%edx
  802557:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  80255a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255d:	8b 50 08             	mov    0x8(%eax),%edx
  802560:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802563:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  802566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802569:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80256c:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  80256f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802572:	8b 50 08             	mov    0x8(%eax),%edx
  802575:	8b 45 08             	mov    0x8(%ebp),%eax
  802578:	01 c2                	add    %eax,%edx
  80257a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257d:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  802580:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802583:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  802586:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80258a:	75 17                	jne    8025a3 <alloc_block_FF+0x20c>
  80258c:	83 ec 04             	sub    $0x4,%esp
  80258f:	68 c8 3b 80 00       	push   $0x803bc8
  802594:	68 a2 00 00 00       	push   $0xa2
  802599:	68 57 3b 80 00       	push   $0x803b57
  80259e:	e8 ed dc ff ff       	call   800290 <_panic>
  8025a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025a6:	8b 00                	mov    (%eax),%eax
  8025a8:	85 c0                	test   %eax,%eax
  8025aa:	74 10                	je     8025bc <alloc_block_FF+0x225>
  8025ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025af:	8b 00                	mov    (%eax),%eax
  8025b1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025b4:	8b 52 04             	mov    0x4(%edx),%edx
  8025b7:	89 50 04             	mov    %edx,0x4(%eax)
  8025ba:	eb 0b                	jmp    8025c7 <alloc_block_FF+0x230>
  8025bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025bf:	8b 40 04             	mov    0x4(%eax),%eax
  8025c2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ca:	8b 40 04             	mov    0x4(%eax),%eax
  8025cd:	85 c0                	test   %eax,%eax
  8025cf:	74 0f                	je     8025e0 <alloc_block_FF+0x249>
  8025d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d4:	8b 40 04             	mov    0x4(%eax),%eax
  8025d7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025da:	8b 12                	mov    (%edx),%edx
  8025dc:	89 10                	mov    %edx,(%eax)
  8025de:	eb 0a                	jmp    8025ea <alloc_block_FF+0x253>
  8025e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e3:	8b 00                	mov    (%eax),%eax
  8025e5:	a3 38 41 80 00       	mov    %eax,0x804138
  8025ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025fd:	a1 44 41 80 00       	mov    0x804144,%eax
  802602:	48                   	dec    %eax
  802603:	a3 44 41 80 00       	mov    %eax,0x804144
		  return temp;
  802608:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80260b:	eb 3b                	jmp    802648 <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  80260d:	a1 40 41 80 00       	mov    0x804140,%eax
  802612:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802615:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802619:	74 07                	je     802622 <alloc_block_FF+0x28b>
  80261b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261e:	8b 00                	mov    (%eax),%eax
  802620:	eb 05                	jmp    802627 <alloc_block_FF+0x290>
  802622:	b8 00 00 00 00       	mov    $0x0,%eax
  802627:	a3 40 41 80 00       	mov    %eax,0x804140
  80262c:	a1 40 41 80 00       	mov    0x804140,%eax
  802631:	85 c0                	test   %eax,%eax
  802633:	0f 85 71 fd ff ff    	jne    8023aa <alloc_block_FF+0x13>
  802639:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80263d:	0f 85 67 fd ff ff    	jne    8023aa <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  802643:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802648:	c9                   	leave  
  802649:	c3                   	ret    

0080264a <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80264a:	55                   	push   %ebp
  80264b:	89 e5                	mov    %esp,%ebp
  80264d:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  802650:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  802657:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  80265e:	a1 38 41 80 00       	mov    0x804138,%eax
  802663:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802666:	e9 d3 00 00 00       	jmp    80273e <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  80266b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80266e:	8b 40 0c             	mov    0xc(%eax),%eax
  802671:	3b 45 08             	cmp    0x8(%ebp),%eax
  802674:	0f 85 90 00 00 00    	jne    80270a <alloc_block_BF+0xc0>
	   temp = element;
  80267a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80267d:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  802680:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802684:	75 17                	jne    80269d <alloc_block_BF+0x53>
  802686:	83 ec 04             	sub    $0x4,%esp
  802689:	68 c8 3b 80 00       	push   $0x803bc8
  80268e:	68 bd 00 00 00       	push   $0xbd
  802693:	68 57 3b 80 00       	push   $0x803b57
  802698:	e8 f3 db ff ff       	call   800290 <_panic>
  80269d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026a0:	8b 00                	mov    (%eax),%eax
  8026a2:	85 c0                	test   %eax,%eax
  8026a4:	74 10                	je     8026b6 <alloc_block_BF+0x6c>
  8026a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026a9:	8b 00                	mov    (%eax),%eax
  8026ab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026ae:	8b 52 04             	mov    0x4(%edx),%edx
  8026b1:	89 50 04             	mov    %edx,0x4(%eax)
  8026b4:	eb 0b                	jmp    8026c1 <alloc_block_BF+0x77>
  8026b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026b9:	8b 40 04             	mov    0x4(%eax),%eax
  8026bc:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026c4:	8b 40 04             	mov    0x4(%eax),%eax
  8026c7:	85 c0                	test   %eax,%eax
  8026c9:	74 0f                	je     8026da <alloc_block_BF+0x90>
  8026cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026ce:	8b 40 04             	mov    0x4(%eax),%eax
  8026d1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026d4:	8b 12                	mov    (%edx),%edx
  8026d6:	89 10                	mov    %edx,(%eax)
  8026d8:	eb 0a                	jmp    8026e4 <alloc_block_BF+0x9a>
  8026da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026dd:	8b 00                	mov    (%eax),%eax
  8026df:	a3 38 41 80 00       	mov    %eax,0x804138
  8026e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026f7:	a1 44 41 80 00       	mov    0x804144,%eax
  8026fc:	48                   	dec    %eax
  8026fd:	a3 44 41 80 00       	mov    %eax,0x804144
	   return temp;
  802702:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802705:	e9 41 01 00 00       	jmp    80284b <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  80270a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80270d:	8b 40 0c             	mov    0xc(%eax),%eax
  802710:	3b 45 08             	cmp    0x8(%ebp),%eax
  802713:	76 21                	jbe    802736 <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  802715:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802718:	8b 40 0c             	mov    0xc(%eax),%eax
  80271b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80271e:	73 16                	jae    802736 <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  802720:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802723:	8b 40 0c             	mov    0xc(%eax),%eax
  802726:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  802729:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80272c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  80272f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802736:	a1 40 41 80 00       	mov    0x804140,%eax
  80273b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80273e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802742:	74 07                	je     80274b <alloc_block_BF+0x101>
  802744:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802747:	8b 00                	mov    (%eax),%eax
  802749:	eb 05                	jmp    802750 <alloc_block_BF+0x106>
  80274b:	b8 00 00 00 00       	mov    $0x0,%eax
  802750:	a3 40 41 80 00       	mov    %eax,0x804140
  802755:	a1 40 41 80 00       	mov    0x804140,%eax
  80275a:	85 c0                	test   %eax,%eax
  80275c:	0f 85 09 ff ff ff    	jne    80266b <alloc_block_BF+0x21>
  802762:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802766:	0f 85 ff fe ff ff    	jne    80266b <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  80276c:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  802770:	0f 85 d0 00 00 00    	jne    802846 <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  802776:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802779:	8b 40 0c             	mov    0xc(%eax),%eax
  80277c:	2b 45 08             	sub    0x8(%ebp),%eax
  80277f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  802782:	a1 48 41 80 00       	mov    0x804148,%eax
  802787:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  80278a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80278e:	75 17                	jne    8027a7 <alloc_block_BF+0x15d>
  802790:	83 ec 04             	sub    $0x4,%esp
  802793:	68 c8 3b 80 00       	push   $0x803bc8
  802798:	68 d1 00 00 00       	push   $0xd1
  80279d:	68 57 3b 80 00       	push   $0x803b57
  8027a2:	e8 e9 da ff ff       	call   800290 <_panic>
  8027a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027aa:	8b 00                	mov    (%eax),%eax
  8027ac:	85 c0                	test   %eax,%eax
  8027ae:	74 10                	je     8027c0 <alloc_block_BF+0x176>
  8027b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027b3:	8b 00                	mov    (%eax),%eax
  8027b5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027b8:	8b 52 04             	mov    0x4(%edx),%edx
  8027bb:	89 50 04             	mov    %edx,0x4(%eax)
  8027be:	eb 0b                	jmp    8027cb <alloc_block_BF+0x181>
  8027c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027c3:	8b 40 04             	mov    0x4(%eax),%eax
  8027c6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8027cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027ce:	8b 40 04             	mov    0x4(%eax),%eax
  8027d1:	85 c0                	test   %eax,%eax
  8027d3:	74 0f                	je     8027e4 <alloc_block_BF+0x19a>
  8027d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027d8:	8b 40 04             	mov    0x4(%eax),%eax
  8027db:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027de:	8b 12                	mov    (%edx),%edx
  8027e0:	89 10                	mov    %edx,(%eax)
  8027e2:	eb 0a                	jmp    8027ee <alloc_block_BF+0x1a4>
  8027e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027e7:	8b 00                	mov    (%eax),%eax
  8027e9:	a3 48 41 80 00       	mov    %eax,0x804148
  8027ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802801:	a1 54 41 80 00       	mov    0x804154,%eax
  802806:	48                   	dec    %eax
  802807:	a3 54 41 80 00       	mov    %eax,0x804154
	  // setting the size & sva
	  new_block->size = size;
  80280c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80280f:	8b 55 08             	mov    0x8(%ebp),%edx
  802812:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  802815:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802818:	8b 50 08             	mov    0x8(%eax),%edx
  80281b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80281e:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  802821:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802824:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802827:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  80282a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80282d:	8b 50 08             	mov    0x8(%eax),%edx
  802830:	8b 45 08             	mov    0x8(%ebp),%eax
  802833:	01 c2                	add    %eax,%edx
  802835:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802838:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  80283b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80283e:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  802841:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802844:	eb 05                	jmp    80284b <alloc_block_BF+0x201>
	 }
	 return NULL;
  802846:	b8 00 00 00 00       	mov    $0x0,%eax


}
  80284b:	c9                   	leave  
  80284c:	c3                   	ret    

0080284d <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80284d:	55                   	push   %ebp
  80284e:	89 e5                	mov    %esp,%ebp
  802850:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802853:	83 ec 04             	sub    $0x4,%esp
  802856:	68 e8 3b 80 00       	push   $0x803be8
  80285b:	68 e8 00 00 00       	push   $0xe8
  802860:	68 57 3b 80 00       	push   $0x803b57
  802865:	e8 26 da ff ff       	call   800290 <_panic>

0080286a <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80286a:	55                   	push   %ebp
  80286b:	89 e5                	mov    %esp,%ebp
  80286d:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  802870:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802875:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  802878:	a1 38 41 80 00       	mov    0x804138,%eax
  80287d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  802880:	a1 44 41 80 00       	mov    0x804144,%eax
  802885:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  802888:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80288c:	75 68                	jne    8028f6 <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80288e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802892:	75 17                	jne    8028ab <insert_sorted_with_merge_freeList+0x41>
  802894:	83 ec 04             	sub    $0x4,%esp
  802897:	68 34 3b 80 00       	push   $0x803b34
  80289c:	68 36 01 00 00       	push   $0x136
  8028a1:	68 57 3b 80 00       	push   $0x803b57
  8028a6:	e8 e5 d9 ff ff       	call   800290 <_panic>
  8028ab:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8028b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b4:	89 10                	mov    %edx,(%eax)
  8028b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b9:	8b 00                	mov    (%eax),%eax
  8028bb:	85 c0                	test   %eax,%eax
  8028bd:	74 0d                	je     8028cc <insert_sorted_with_merge_freeList+0x62>
  8028bf:	a1 38 41 80 00       	mov    0x804138,%eax
  8028c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8028c7:	89 50 04             	mov    %edx,0x4(%eax)
  8028ca:	eb 08                	jmp    8028d4 <insert_sorted_with_merge_freeList+0x6a>
  8028cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cf:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d7:	a3 38 41 80 00       	mov    %eax,0x804138
  8028dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028e6:	a1 44 41 80 00       	mov    0x804144,%eax
  8028eb:	40                   	inc    %eax
  8028ec:	a3 44 41 80 00       	mov    %eax,0x804144





}
  8028f1:	e9 ba 06 00 00       	jmp    802fb0 <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  8028f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f9:	8b 50 08             	mov    0x8(%eax),%edx
  8028fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802902:	01 c2                	add    %eax,%edx
  802904:	8b 45 08             	mov    0x8(%ebp),%eax
  802907:	8b 40 08             	mov    0x8(%eax),%eax
  80290a:	39 c2                	cmp    %eax,%edx
  80290c:	73 68                	jae    802976 <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80290e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802912:	75 17                	jne    80292b <insert_sorted_with_merge_freeList+0xc1>
  802914:	83 ec 04             	sub    $0x4,%esp
  802917:	68 70 3b 80 00       	push   $0x803b70
  80291c:	68 3a 01 00 00       	push   $0x13a
  802921:	68 57 3b 80 00       	push   $0x803b57
  802926:	e8 65 d9 ff ff       	call   800290 <_panic>
  80292b:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802931:	8b 45 08             	mov    0x8(%ebp),%eax
  802934:	89 50 04             	mov    %edx,0x4(%eax)
  802937:	8b 45 08             	mov    0x8(%ebp),%eax
  80293a:	8b 40 04             	mov    0x4(%eax),%eax
  80293d:	85 c0                	test   %eax,%eax
  80293f:	74 0c                	je     80294d <insert_sorted_with_merge_freeList+0xe3>
  802941:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802946:	8b 55 08             	mov    0x8(%ebp),%edx
  802949:	89 10                	mov    %edx,(%eax)
  80294b:	eb 08                	jmp    802955 <insert_sorted_with_merge_freeList+0xeb>
  80294d:	8b 45 08             	mov    0x8(%ebp),%eax
  802950:	a3 38 41 80 00       	mov    %eax,0x804138
  802955:	8b 45 08             	mov    0x8(%ebp),%eax
  802958:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80295d:	8b 45 08             	mov    0x8(%ebp),%eax
  802960:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802966:	a1 44 41 80 00       	mov    0x804144,%eax
  80296b:	40                   	inc    %eax
  80296c:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802971:	e9 3a 06 00 00       	jmp    802fb0 <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  802976:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802979:	8b 50 08             	mov    0x8(%eax),%edx
  80297c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80297f:	8b 40 0c             	mov    0xc(%eax),%eax
  802982:	01 c2                	add    %eax,%edx
  802984:	8b 45 08             	mov    0x8(%ebp),%eax
  802987:	8b 40 08             	mov    0x8(%eax),%eax
  80298a:	39 c2                	cmp    %eax,%edx
  80298c:	0f 85 90 00 00 00    	jne    802a22 <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  802992:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802995:	8b 50 0c             	mov    0xc(%eax),%edx
  802998:	8b 45 08             	mov    0x8(%ebp),%eax
  80299b:	8b 40 0c             	mov    0xc(%eax),%eax
  80299e:	01 c2                	add    %eax,%edx
  8029a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a3:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  8029a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  8029b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8029ba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029be:	75 17                	jne    8029d7 <insert_sorted_with_merge_freeList+0x16d>
  8029c0:	83 ec 04             	sub    $0x4,%esp
  8029c3:	68 34 3b 80 00       	push   $0x803b34
  8029c8:	68 41 01 00 00       	push   $0x141
  8029cd:	68 57 3b 80 00       	push   $0x803b57
  8029d2:	e8 b9 d8 ff ff       	call   800290 <_panic>
  8029d7:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8029dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e0:	89 10                	mov    %edx,(%eax)
  8029e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e5:	8b 00                	mov    (%eax),%eax
  8029e7:	85 c0                	test   %eax,%eax
  8029e9:	74 0d                	je     8029f8 <insert_sorted_with_merge_freeList+0x18e>
  8029eb:	a1 48 41 80 00       	mov    0x804148,%eax
  8029f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8029f3:	89 50 04             	mov    %edx,0x4(%eax)
  8029f6:	eb 08                	jmp    802a00 <insert_sorted_with_merge_freeList+0x196>
  8029f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fb:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a00:	8b 45 08             	mov    0x8(%ebp),%eax
  802a03:	a3 48 41 80 00       	mov    %eax,0x804148
  802a08:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a12:	a1 54 41 80 00       	mov    0x804154,%eax
  802a17:	40                   	inc    %eax
  802a18:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802a1d:	e9 8e 05 00 00       	jmp    802fb0 <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  802a22:	8b 45 08             	mov    0x8(%ebp),%eax
  802a25:	8b 50 08             	mov    0x8(%eax),%edx
  802a28:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2b:	8b 40 0c             	mov    0xc(%eax),%eax
  802a2e:	01 c2                	add    %eax,%edx
  802a30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a33:	8b 40 08             	mov    0x8(%eax),%eax
  802a36:	39 c2                	cmp    %eax,%edx
  802a38:	73 68                	jae    802aa2 <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802a3a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a3e:	75 17                	jne    802a57 <insert_sorted_with_merge_freeList+0x1ed>
  802a40:	83 ec 04             	sub    $0x4,%esp
  802a43:	68 34 3b 80 00       	push   $0x803b34
  802a48:	68 45 01 00 00       	push   $0x145
  802a4d:	68 57 3b 80 00       	push   $0x803b57
  802a52:	e8 39 d8 ff ff       	call   800290 <_panic>
  802a57:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a60:	89 10                	mov    %edx,(%eax)
  802a62:	8b 45 08             	mov    0x8(%ebp),%eax
  802a65:	8b 00                	mov    (%eax),%eax
  802a67:	85 c0                	test   %eax,%eax
  802a69:	74 0d                	je     802a78 <insert_sorted_with_merge_freeList+0x20e>
  802a6b:	a1 38 41 80 00       	mov    0x804138,%eax
  802a70:	8b 55 08             	mov    0x8(%ebp),%edx
  802a73:	89 50 04             	mov    %edx,0x4(%eax)
  802a76:	eb 08                	jmp    802a80 <insert_sorted_with_merge_freeList+0x216>
  802a78:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a80:	8b 45 08             	mov    0x8(%ebp),%eax
  802a83:	a3 38 41 80 00       	mov    %eax,0x804138
  802a88:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a92:	a1 44 41 80 00       	mov    0x804144,%eax
  802a97:	40                   	inc    %eax
  802a98:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802a9d:	e9 0e 05 00 00       	jmp    802fb0 <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  802aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa5:	8b 50 08             	mov    0x8(%eax),%edx
  802aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  802aab:	8b 40 0c             	mov    0xc(%eax),%eax
  802aae:	01 c2                	add    %eax,%edx
  802ab0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ab3:	8b 40 08             	mov    0x8(%eax),%eax
  802ab6:	39 c2                	cmp    %eax,%edx
  802ab8:	0f 85 9c 00 00 00    	jne    802b5a <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  802abe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac1:	8b 50 0c             	mov    0xc(%eax),%edx
  802ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac7:	8b 40 0c             	mov    0xc(%eax),%eax
  802aca:	01 c2                	add    %eax,%edx
  802acc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802acf:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  802ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad5:	8b 50 08             	mov    0x8(%eax),%edx
  802ad8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802adb:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  802ade:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  802ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  802aeb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802af2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802af6:	75 17                	jne    802b0f <insert_sorted_with_merge_freeList+0x2a5>
  802af8:	83 ec 04             	sub    $0x4,%esp
  802afb:	68 34 3b 80 00       	push   $0x803b34
  802b00:	68 4d 01 00 00       	push   $0x14d
  802b05:	68 57 3b 80 00       	push   $0x803b57
  802b0a:	e8 81 d7 ff ff       	call   800290 <_panic>
  802b0f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b15:	8b 45 08             	mov    0x8(%ebp),%eax
  802b18:	89 10                	mov    %edx,(%eax)
  802b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1d:	8b 00                	mov    (%eax),%eax
  802b1f:	85 c0                	test   %eax,%eax
  802b21:	74 0d                	je     802b30 <insert_sorted_with_merge_freeList+0x2c6>
  802b23:	a1 48 41 80 00       	mov    0x804148,%eax
  802b28:	8b 55 08             	mov    0x8(%ebp),%edx
  802b2b:	89 50 04             	mov    %edx,0x4(%eax)
  802b2e:	eb 08                	jmp    802b38 <insert_sorted_with_merge_freeList+0x2ce>
  802b30:	8b 45 08             	mov    0x8(%ebp),%eax
  802b33:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b38:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3b:	a3 48 41 80 00       	mov    %eax,0x804148
  802b40:	8b 45 08             	mov    0x8(%ebp),%eax
  802b43:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b4a:	a1 54 41 80 00       	mov    0x804154,%eax
  802b4f:	40                   	inc    %eax
  802b50:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802b55:	e9 56 04 00 00       	jmp    802fb0 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802b5a:	a1 38 41 80 00       	mov    0x804138,%eax
  802b5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b62:	e9 19 04 00 00       	jmp    802f80 <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  802b67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6a:	8b 00                	mov    (%eax),%eax
  802b6c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b72:	8b 50 08             	mov    0x8(%eax),%edx
  802b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b78:	8b 40 0c             	mov    0xc(%eax),%eax
  802b7b:	01 c2                	add    %eax,%edx
  802b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b80:	8b 40 08             	mov    0x8(%eax),%eax
  802b83:	39 c2                	cmp    %eax,%edx
  802b85:	0f 85 ad 01 00 00    	jne    802d38 <insert_sorted_with_merge_freeList+0x4ce>
  802b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8e:	8b 50 08             	mov    0x8(%eax),%edx
  802b91:	8b 45 08             	mov    0x8(%ebp),%eax
  802b94:	8b 40 0c             	mov    0xc(%eax),%eax
  802b97:	01 c2                	add    %eax,%edx
  802b99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b9c:	8b 40 08             	mov    0x8(%eax),%eax
  802b9f:	39 c2                	cmp    %eax,%edx
  802ba1:	0f 85 91 01 00 00    	jne    802d38 <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  802ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baa:	8b 50 0c             	mov    0xc(%eax),%edx
  802bad:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb0:	8b 48 0c             	mov    0xc(%eax),%ecx
  802bb3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bb6:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb9:	01 c8                	add    %ecx,%eax
  802bbb:	01 c2                	add    %eax,%edx
  802bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc0:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  802bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  802bd7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bda:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  802be1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802be4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  802beb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802bef:	75 17                	jne    802c08 <insert_sorted_with_merge_freeList+0x39e>
  802bf1:	83 ec 04             	sub    $0x4,%esp
  802bf4:	68 c8 3b 80 00       	push   $0x803bc8
  802bf9:	68 5b 01 00 00       	push   $0x15b
  802bfe:	68 57 3b 80 00       	push   $0x803b57
  802c03:	e8 88 d6 ff ff       	call   800290 <_panic>
  802c08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c0b:	8b 00                	mov    (%eax),%eax
  802c0d:	85 c0                	test   %eax,%eax
  802c0f:	74 10                	je     802c21 <insert_sorted_with_merge_freeList+0x3b7>
  802c11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c14:	8b 00                	mov    (%eax),%eax
  802c16:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c19:	8b 52 04             	mov    0x4(%edx),%edx
  802c1c:	89 50 04             	mov    %edx,0x4(%eax)
  802c1f:	eb 0b                	jmp    802c2c <insert_sorted_with_merge_freeList+0x3c2>
  802c21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c24:	8b 40 04             	mov    0x4(%eax),%eax
  802c27:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c2f:	8b 40 04             	mov    0x4(%eax),%eax
  802c32:	85 c0                	test   %eax,%eax
  802c34:	74 0f                	je     802c45 <insert_sorted_with_merge_freeList+0x3db>
  802c36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c39:	8b 40 04             	mov    0x4(%eax),%eax
  802c3c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c3f:	8b 12                	mov    (%edx),%edx
  802c41:	89 10                	mov    %edx,(%eax)
  802c43:	eb 0a                	jmp    802c4f <insert_sorted_with_merge_freeList+0x3e5>
  802c45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c48:	8b 00                	mov    (%eax),%eax
  802c4a:	a3 38 41 80 00       	mov    %eax,0x804138
  802c4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c52:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c5b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c62:	a1 44 41 80 00       	mov    0x804144,%eax
  802c67:	48                   	dec    %eax
  802c68:	a3 44 41 80 00       	mov    %eax,0x804144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802c6d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c71:	75 17                	jne    802c8a <insert_sorted_with_merge_freeList+0x420>
  802c73:	83 ec 04             	sub    $0x4,%esp
  802c76:	68 34 3b 80 00       	push   $0x803b34
  802c7b:	68 5c 01 00 00       	push   $0x15c
  802c80:	68 57 3b 80 00       	push   $0x803b57
  802c85:	e8 06 d6 ff ff       	call   800290 <_panic>
  802c8a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c90:	8b 45 08             	mov    0x8(%ebp),%eax
  802c93:	89 10                	mov    %edx,(%eax)
  802c95:	8b 45 08             	mov    0x8(%ebp),%eax
  802c98:	8b 00                	mov    (%eax),%eax
  802c9a:	85 c0                	test   %eax,%eax
  802c9c:	74 0d                	je     802cab <insert_sorted_with_merge_freeList+0x441>
  802c9e:	a1 48 41 80 00       	mov    0x804148,%eax
  802ca3:	8b 55 08             	mov    0x8(%ebp),%edx
  802ca6:	89 50 04             	mov    %edx,0x4(%eax)
  802ca9:	eb 08                	jmp    802cb3 <insert_sorted_with_merge_freeList+0x449>
  802cab:	8b 45 08             	mov    0x8(%ebp),%eax
  802cae:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb6:	a3 48 41 80 00       	mov    %eax,0x804148
  802cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cc5:	a1 54 41 80 00       	mov    0x804154,%eax
  802cca:	40                   	inc    %eax
  802ccb:	a3 54 41 80 00       	mov    %eax,0x804154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  802cd0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802cd4:	75 17                	jne    802ced <insert_sorted_with_merge_freeList+0x483>
  802cd6:	83 ec 04             	sub    $0x4,%esp
  802cd9:	68 34 3b 80 00       	push   $0x803b34
  802cde:	68 5d 01 00 00       	push   $0x15d
  802ce3:	68 57 3b 80 00       	push   $0x803b57
  802ce8:	e8 a3 d5 ff ff       	call   800290 <_panic>
  802ced:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802cf3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cf6:	89 10                	mov    %edx,(%eax)
  802cf8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cfb:	8b 00                	mov    (%eax),%eax
  802cfd:	85 c0                	test   %eax,%eax
  802cff:	74 0d                	je     802d0e <insert_sorted_with_merge_freeList+0x4a4>
  802d01:	a1 48 41 80 00       	mov    0x804148,%eax
  802d06:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d09:	89 50 04             	mov    %edx,0x4(%eax)
  802d0c:	eb 08                	jmp    802d16 <insert_sorted_with_merge_freeList+0x4ac>
  802d0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d11:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d19:	a3 48 41 80 00       	mov    %eax,0x804148
  802d1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d21:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d28:	a1 54 41 80 00       	mov    0x804154,%eax
  802d2d:	40                   	inc    %eax
  802d2e:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802d33:	e9 78 02 00 00       	jmp    802fb0 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3b:	8b 50 08             	mov    0x8(%eax),%edx
  802d3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d41:	8b 40 0c             	mov    0xc(%eax),%eax
  802d44:	01 c2                	add    %eax,%edx
  802d46:	8b 45 08             	mov    0x8(%ebp),%eax
  802d49:	8b 40 08             	mov    0x8(%eax),%eax
  802d4c:	39 c2                	cmp    %eax,%edx
  802d4e:	0f 83 b8 00 00 00    	jae    802e0c <insert_sorted_with_merge_freeList+0x5a2>
  802d54:	8b 45 08             	mov    0x8(%ebp),%eax
  802d57:	8b 50 08             	mov    0x8(%eax),%edx
  802d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d60:	01 c2                	add    %eax,%edx
  802d62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d65:	8b 40 08             	mov    0x8(%eax),%eax
  802d68:	39 c2                	cmp    %eax,%edx
  802d6a:	0f 85 9c 00 00 00    	jne    802e0c <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  802d70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d73:	8b 50 0c             	mov    0xc(%eax),%edx
  802d76:	8b 45 08             	mov    0x8(%ebp),%eax
  802d79:	8b 40 0c             	mov    0xc(%eax),%eax
  802d7c:	01 c2                	add    %eax,%edx
  802d7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d81:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  802d84:	8b 45 08             	mov    0x8(%ebp),%eax
  802d87:	8b 50 08             	mov    0x8(%eax),%edx
  802d8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d8d:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  802d90:	8b 45 08             	mov    0x8(%ebp),%eax
  802d93:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802da4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802da8:	75 17                	jne    802dc1 <insert_sorted_with_merge_freeList+0x557>
  802daa:	83 ec 04             	sub    $0x4,%esp
  802dad:	68 34 3b 80 00       	push   $0x803b34
  802db2:	68 67 01 00 00       	push   $0x167
  802db7:	68 57 3b 80 00       	push   $0x803b57
  802dbc:	e8 cf d4 ff ff       	call   800290 <_panic>
  802dc1:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dca:	89 10                	mov    %edx,(%eax)
  802dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcf:	8b 00                	mov    (%eax),%eax
  802dd1:	85 c0                	test   %eax,%eax
  802dd3:	74 0d                	je     802de2 <insert_sorted_with_merge_freeList+0x578>
  802dd5:	a1 48 41 80 00       	mov    0x804148,%eax
  802dda:	8b 55 08             	mov    0x8(%ebp),%edx
  802ddd:	89 50 04             	mov    %edx,0x4(%eax)
  802de0:	eb 08                	jmp    802dea <insert_sorted_with_merge_freeList+0x580>
  802de2:	8b 45 08             	mov    0x8(%ebp),%eax
  802de5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802dea:	8b 45 08             	mov    0x8(%ebp),%eax
  802ded:	a3 48 41 80 00       	mov    %eax,0x804148
  802df2:	8b 45 08             	mov    0x8(%ebp),%eax
  802df5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dfc:	a1 54 41 80 00       	mov    0x804154,%eax
  802e01:	40                   	inc    %eax
  802e02:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802e07:	e9 a4 01 00 00       	jmp    802fb0 <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802e0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0f:	8b 50 08             	mov    0x8(%eax),%edx
  802e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e15:	8b 40 0c             	mov    0xc(%eax),%eax
  802e18:	01 c2                	add    %eax,%edx
  802e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1d:	8b 40 08             	mov    0x8(%eax),%eax
  802e20:	39 c2                	cmp    %eax,%edx
  802e22:	0f 85 ac 00 00 00    	jne    802ed4 <insert_sorted_with_merge_freeList+0x66a>
  802e28:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2b:	8b 50 08             	mov    0x8(%eax),%edx
  802e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e31:	8b 40 0c             	mov    0xc(%eax),%eax
  802e34:	01 c2                	add    %eax,%edx
  802e36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e39:	8b 40 08             	mov    0x8(%eax),%eax
  802e3c:	39 c2                	cmp    %eax,%edx
  802e3e:	0f 83 90 00 00 00    	jae    802ed4 <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  802e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e47:	8b 50 0c             	mov    0xc(%eax),%edx
  802e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4d:	8b 40 0c             	mov    0xc(%eax),%eax
  802e50:	01 c2                	add    %eax,%edx
  802e52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e55:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  802e58:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  802e62:	8b 45 08             	mov    0x8(%ebp),%eax
  802e65:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e6c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e70:	75 17                	jne    802e89 <insert_sorted_with_merge_freeList+0x61f>
  802e72:	83 ec 04             	sub    $0x4,%esp
  802e75:	68 34 3b 80 00       	push   $0x803b34
  802e7a:	68 70 01 00 00       	push   $0x170
  802e7f:	68 57 3b 80 00       	push   $0x803b57
  802e84:	e8 07 d4 ff ff       	call   800290 <_panic>
  802e89:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e92:	89 10                	mov    %edx,(%eax)
  802e94:	8b 45 08             	mov    0x8(%ebp),%eax
  802e97:	8b 00                	mov    (%eax),%eax
  802e99:	85 c0                	test   %eax,%eax
  802e9b:	74 0d                	je     802eaa <insert_sorted_with_merge_freeList+0x640>
  802e9d:	a1 48 41 80 00       	mov    0x804148,%eax
  802ea2:	8b 55 08             	mov    0x8(%ebp),%edx
  802ea5:	89 50 04             	mov    %edx,0x4(%eax)
  802ea8:	eb 08                	jmp    802eb2 <insert_sorted_with_merge_freeList+0x648>
  802eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  802ead:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb5:	a3 48 41 80 00       	mov    %eax,0x804148
  802eba:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ec4:	a1 54 41 80 00       	mov    0x804154,%eax
  802ec9:	40                   	inc    %eax
  802eca:	a3 54 41 80 00       	mov    %eax,0x804154
	      break;
  802ecf:	e9 dc 00 00 00       	jmp    802fb0 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802ed4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed7:	8b 50 08             	mov    0x8(%eax),%edx
  802eda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edd:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee0:	01 c2                	add    %eax,%edx
  802ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee5:	8b 40 08             	mov    0x8(%eax),%eax
  802ee8:	39 c2                	cmp    %eax,%edx
  802eea:	0f 83 88 00 00 00    	jae    802f78 <insert_sorted_with_merge_freeList+0x70e>
  802ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef3:	8b 50 08             	mov    0x8(%eax),%edx
  802ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef9:	8b 40 0c             	mov    0xc(%eax),%eax
  802efc:	01 c2                	add    %eax,%edx
  802efe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f01:	8b 40 08             	mov    0x8(%eax),%eax
  802f04:	39 c2                	cmp    %eax,%edx
  802f06:	73 70                	jae    802f78 <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  802f08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f0c:	74 06                	je     802f14 <insert_sorted_with_merge_freeList+0x6aa>
  802f0e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f12:	75 17                	jne    802f2b <insert_sorted_with_merge_freeList+0x6c1>
  802f14:	83 ec 04             	sub    $0x4,%esp
  802f17:	68 94 3b 80 00       	push   $0x803b94
  802f1c:	68 75 01 00 00       	push   $0x175
  802f21:	68 57 3b 80 00       	push   $0x803b57
  802f26:	e8 65 d3 ff ff       	call   800290 <_panic>
  802f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2e:	8b 10                	mov    (%eax),%edx
  802f30:	8b 45 08             	mov    0x8(%ebp),%eax
  802f33:	89 10                	mov    %edx,(%eax)
  802f35:	8b 45 08             	mov    0x8(%ebp),%eax
  802f38:	8b 00                	mov    (%eax),%eax
  802f3a:	85 c0                	test   %eax,%eax
  802f3c:	74 0b                	je     802f49 <insert_sorted_with_merge_freeList+0x6df>
  802f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f41:	8b 00                	mov    (%eax),%eax
  802f43:	8b 55 08             	mov    0x8(%ebp),%edx
  802f46:	89 50 04             	mov    %edx,0x4(%eax)
  802f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4c:	8b 55 08             	mov    0x8(%ebp),%edx
  802f4f:	89 10                	mov    %edx,(%eax)
  802f51:	8b 45 08             	mov    0x8(%ebp),%eax
  802f54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f57:	89 50 04             	mov    %edx,0x4(%eax)
  802f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5d:	8b 00                	mov    (%eax),%eax
  802f5f:	85 c0                	test   %eax,%eax
  802f61:	75 08                	jne    802f6b <insert_sorted_with_merge_freeList+0x701>
  802f63:	8b 45 08             	mov    0x8(%ebp),%eax
  802f66:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f6b:	a1 44 41 80 00       	mov    0x804144,%eax
  802f70:	40                   	inc    %eax
  802f71:	a3 44 41 80 00       	mov    %eax,0x804144
	      break;
  802f76:	eb 38                	jmp    802fb0 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802f78:	a1 40 41 80 00       	mov    0x804140,%eax
  802f7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f84:	74 07                	je     802f8d <insert_sorted_with_merge_freeList+0x723>
  802f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f89:	8b 00                	mov    (%eax),%eax
  802f8b:	eb 05                	jmp    802f92 <insert_sorted_with_merge_freeList+0x728>
  802f8d:	b8 00 00 00 00       	mov    $0x0,%eax
  802f92:	a3 40 41 80 00       	mov    %eax,0x804140
  802f97:	a1 40 41 80 00       	mov    0x804140,%eax
  802f9c:	85 c0                	test   %eax,%eax
  802f9e:	0f 85 c3 fb ff ff    	jne    802b67 <insert_sorted_with_merge_freeList+0x2fd>
  802fa4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fa8:	0f 85 b9 fb ff ff    	jne    802b67 <insert_sorted_with_merge_freeList+0x2fd>





}
  802fae:	eb 00                	jmp    802fb0 <insert_sorted_with_merge_freeList+0x746>
  802fb0:	90                   	nop
  802fb1:	c9                   	leave  
  802fb2:	c3                   	ret    

00802fb3 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802fb3:	55                   	push   %ebp
  802fb4:	89 e5                	mov    %esp,%ebp
  802fb6:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  802fb9:	8b 55 08             	mov    0x8(%ebp),%edx
  802fbc:	89 d0                	mov    %edx,%eax
  802fbe:	c1 e0 02             	shl    $0x2,%eax
  802fc1:	01 d0                	add    %edx,%eax
  802fc3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802fca:	01 d0                	add    %edx,%eax
  802fcc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802fd3:	01 d0                	add    %edx,%eax
  802fd5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802fdc:	01 d0                	add    %edx,%eax
  802fde:	c1 e0 04             	shl    $0x4,%eax
  802fe1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  802fe4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  802feb:	8d 45 e8             	lea    -0x18(%ebp),%eax
  802fee:	83 ec 0c             	sub    $0xc,%esp
  802ff1:	50                   	push   %eax
  802ff2:	e8 31 ec ff ff       	call   801c28 <sys_get_virtual_time>
  802ff7:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  802ffa:	eb 41                	jmp    80303d <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  802ffc:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802fff:	83 ec 0c             	sub    $0xc,%esp
  803002:	50                   	push   %eax
  803003:	e8 20 ec ff ff       	call   801c28 <sys_get_virtual_time>
  803008:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80300b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80300e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803011:	29 c2                	sub    %eax,%edx
  803013:	89 d0                	mov    %edx,%eax
  803015:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803018:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80301b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80301e:	89 d1                	mov    %edx,%ecx
  803020:	29 c1                	sub    %eax,%ecx
  803022:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803025:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803028:	39 c2                	cmp    %eax,%edx
  80302a:	0f 97 c0             	seta   %al
  80302d:	0f b6 c0             	movzbl %al,%eax
  803030:	29 c1                	sub    %eax,%ecx
  803032:	89 c8                	mov    %ecx,%eax
  803034:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803037:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80303a:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80303d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803040:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803043:	72 b7                	jb     802ffc <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803045:	90                   	nop
  803046:	c9                   	leave  
  803047:	c3                   	ret    

00803048 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803048:	55                   	push   %ebp
  803049:	89 e5                	mov    %esp,%ebp
  80304b:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80304e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803055:	eb 03                	jmp    80305a <busy_wait+0x12>
  803057:	ff 45 fc             	incl   -0x4(%ebp)
  80305a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80305d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803060:	72 f5                	jb     803057 <busy_wait+0xf>
	return i;
  803062:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803065:	c9                   	leave  
  803066:	c3                   	ret    
  803067:	90                   	nop

00803068 <__udivdi3>:
  803068:	55                   	push   %ebp
  803069:	57                   	push   %edi
  80306a:	56                   	push   %esi
  80306b:	53                   	push   %ebx
  80306c:	83 ec 1c             	sub    $0x1c,%esp
  80306f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803073:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803077:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80307b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80307f:	89 ca                	mov    %ecx,%edx
  803081:	89 f8                	mov    %edi,%eax
  803083:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803087:	85 f6                	test   %esi,%esi
  803089:	75 2d                	jne    8030b8 <__udivdi3+0x50>
  80308b:	39 cf                	cmp    %ecx,%edi
  80308d:	77 65                	ja     8030f4 <__udivdi3+0x8c>
  80308f:	89 fd                	mov    %edi,%ebp
  803091:	85 ff                	test   %edi,%edi
  803093:	75 0b                	jne    8030a0 <__udivdi3+0x38>
  803095:	b8 01 00 00 00       	mov    $0x1,%eax
  80309a:	31 d2                	xor    %edx,%edx
  80309c:	f7 f7                	div    %edi
  80309e:	89 c5                	mov    %eax,%ebp
  8030a0:	31 d2                	xor    %edx,%edx
  8030a2:	89 c8                	mov    %ecx,%eax
  8030a4:	f7 f5                	div    %ebp
  8030a6:	89 c1                	mov    %eax,%ecx
  8030a8:	89 d8                	mov    %ebx,%eax
  8030aa:	f7 f5                	div    %ebp
  8030ac:	89 cf                	mov    %ecx,%edi
  8030ae:	89 fa                	mov    %edi,%edx
  8030b0:	83 c4 1c             	add    $0x1c,%esp
  8030b3:	5b                   	pop    %ebx
  8030b4:	5e                   	pop    %esi
  8030b5:	5f                   	pop    %edi
  8030b6:	5d                   	pop    %ebp
  8030b7:	c3                   	ret    
  8030b8:	39 ce                	cmp    %ecx,%esi
  8030ba:	77 28                	ja     8030e4 <__udivdi3+0x7c>
  8030bc:	0f bd fe             	bsr    %esi,%edi
  8030bf:	83 f7 1f             	xor    $0x1f,%edi
  8030c2:	75 40                	jne    803104 <__udivdi3+0x9c>
  8030c4:	39 ce                	cmp    %ecx,%esi
  8030c6:	72 0a                	jb     8030d2 <__udivdi3+0x6a>
  8030c8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8030cc:	0f 87 9e 00 00 00    	ja     803170 <__udivdi3+0x108>
  8030d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8030d7:	89 fa                	mov    %edi,%edx
  8030d9:	83 c4 1c             	add    $0x1c,%esp
  8030dc:	5b                   	pop    %ebx
  8030dd:	5e                   	pop    %esi
  8030de:	5f                   	pop    %edi
  8030df:	5d                   	pop    %ebp
  8030e0:	c3                   	ret    
  8030e1:	8d 76 00             	lea    0x0(%esi),%esi
  8030e4:	31 ff                	xor    %edi,%edi
  8030e6:	31 c0                	xor    %eax,%eax
  8030e8:	89 fa                	mov    %edi,%edx
  8030ea:	83 c4 1c             	add    $0x1c,%esp
  8030ed:	5b                   	pop    %ebx
  8030ee:	5e                   	pop    %esi
  8030ef:	5f                   	pop    %edi
  8030f0:	5d                   	pop    %ebp
  8030f1:	c3                   	ret    
  8030f2:	66 90                	xchg   %ax,%ax
  8030f4:	89 d8                	mov    %ebx,%eax
  8030f6:	f7 f7                	div    %edi
  8030f8:	31 ff                	xor    %edi,%edi
  8030fa:	89 fa                	mov    %edi,%edx
  8030fc:	83 c4 1c             	add    $0x1c,%esp
  8030ff:	5b                   	pop    %ebx
  803100:	5e                   	pop    %esi
  803101:	5f                   	pop    %edi
  803102:	5d                   	pop    %ebp
  803103:	c3                   	ret    
  803104:	bd 20 00 00 00       	mov    $0x20,%ebp
  803109:	89 eb                	mov    %ebp,%ebx
  80310b:	29 fb                	sub    %edi,%ebx
  80310d:	89 f9                	mov    %edi,%ecx
  80310f:	d3 e6                	shl    %cl,%esi
  803111:	89 c5                	mov    %eax,%ebp
  803113:	88 d9                	mov    %bl,%cl
  803115:	d3 ed                	shr    %cl,%ebp
  803117:	89 e9                	mov    %ebp,%ecx
  803119:	09 f1                	or     %esi,%ecx
  80311b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80311f:	89 f9                	mov    %edi,%ecx
  803121:	d3 e0                	shl    %cl,%eax
  803123:	89 c5                	mov    %eax,%ebp
  803125:	89 d6                	mov    %edx,%esi
  803127:	88 d9                	mov    %bl,%cl
  803129:	d3 ee                	shr    %cl,%esi
  80312b:	89 f9                	mov    %edi,%ecx
  80312d:	d3 e2                	shl    %cl,%edx
  80312f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803133:	88 d9                	mov    %bl,%cl
  803135:	d3 e8                	shr    %cl,%eax
  803137:	09 c2                	or     %eax,%edx
  803139:	89 d0                	mov    %edx,%eax
  80313b:	89 f2                	mov    %esi,%edx
  80313d:	f7 74 24 0c          	divl   0xc(%esp)
  803141:	89 d6                	mov    %edx,%esi
  803143:	89 c3                	mov    %eax,%ebx
  803145:	f7 e5                	mul    %ebp
  803147:	39 d6                	cmp    %edx,%esi
  803149:	72 19                	jb     803164 <__udivdi3+0xfc>
  80314b:	74 0b                	je     803158 <__udivdi3+0xf0>
  80314d:	89 d8                	mov    %ebx,%eax
  80314f:	31 ff                	xor    %edi,%edi
  803151:	e9 58 ff ff ff       	jmp    8030ae <__udivdi3+0x46>
  803156:	66 90                	xchg   %ax,%ax
  803158:	8b 54 24 08          	mov    0x8(%esp),%edx
  80315c:	89 f9                	mov    %edi,%ecx
  80315e:	d3 e2                	shl    %cl,%edx
  803160:	39 c2                	cmp    %eax,%edx
  803162:	73 e9                	jae    80314d <__udivdi3+0xe5>
  803164:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803167:	31 ff                	xor    %edi,%edi
  803169:	e9 40 ff ff ff       	jmp    8030ae <__udivdi3+0x46>
  80316e:	66 90                	xchg   %ax,%ax
  803170:	31 c0                	xor    %eax,%eax
  803172:	e9 37 ff ff ff       	jmp    8030ae <__udivdi3+0x46>
  803177:	90                   	nop

00803178 <__umoddi3>:
  803178:	55                   	push   %ebp
  803179:	57                   	push   %edi
  80317a:	56                   	push   %esi
  80317b:	53                   	push   %ebx
  80317c:	83 ec 1c             	sub    $0x1c,%esp
  80317f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803183:	8b 74 24 34          	mov    0x34(%esp),%esi
  803187:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80318b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80318f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803193:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803197:	89 f3                	mov    %esi,%ebx
  803199:	89 fa                	mov    %edi,%edx
  80319b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80319f:	89 34 24             	mov    %esi,(%esp)
  8031a2:	85 c0                	test   %eax,%eax
  8031a4:	75 1a                	jne    8031c0 <__umoddi3+0x48>
  8031a6:	39 f7                	cmp    %esi,%edi
  8031a8:	0f 86 a2 00 00 00    	jbe    803250 <__umoddi3+0xd8>
  8031ae:	89 c8                	mov    %ecx,%eax
  8031b0:	89 f2                	mov    %esi,%edx
  8031b2:	f7 f7                	div    %edi
  8031b4:	89 d0                	mov    %edx,%eax
  8031b6:	31 d2                	xor    %edx,%edx
  8031b8:	83 c4 1c             	add    $0x1c,%esp
  8031bb:	5b                   	pop    %ebx
  8031bc:	5e                   	pop    %esi
  8031bd:	5f                   	pop    %edi
  8031be:	5d                   	pop    %ebp
  8031bf:	c3                   	ret    
  8031c0:	39 f0                	cmp    %esi,%eax
  8031c2:	0f 87 ac 00 00 00    	ja     803274 <__umoddi3+0xfc>
  8031c8:	0f bd e8             	bsr    %eax,%ebp
  8031cb:	83 f5 1f             	xor    $0x1f,%ebp
  8031ce:	0f 84 ac 00 00 00    	je     803280 <__umoddi3+0x108>
  8031d4:	bf 20 00 00 00       	mov    $0x20,%edi
  8031d9:	29 ef                	sub    %ebp,%edi
  8031db:	89 fe                	mov    %edi,%esi
  8031dd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8031e1:	89 e9                	mov    %ebp,%ecx
  8031e3:	d3 e0                	shl    %cl,%eax
  8031e5:	89 d7                	mov    %edx,%edi
  8031e7:	89 f1                	mov    %esi,%ecx
  8031e9:	d3 ef                	shr    %cl,%edi
  8031eb:	09 c7                	or     %eax,%edi
  8031ed:	89 e9                	mov    %ebp,%ecx
  8031ef:	d3 e2                	shl    %cl,%edx
  8031f1:	89 14 24             	mov    %edx,(%esp)
  8031f4:	89 d8                	mov    %ebx,%eax
  8031f6:	d3 e0                	shl    %cl,%eax
  8031f8:	89 c2                	mov    %eax,%edx
  8031fa:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031fe:	d3 e0                	shl    %cl,%eax
  803200:	89 44 24 04          	mov    %eax,0x4(%esp)
  803204:	8b 44 24 08          	mov    0x8(%esp),%eax
  803208:	89 f1                	mov    %esi,%ecx
  80320a:	d3 e8                	shr    %cl,%eax
  80320c:	09 d0                	or     %edx,%eax
  80320e:	d3 eb                	shr    %cl,%ebx
  803210:	89 da                	mov    %ebx,%edx
  803212:	f7 f7                	div    %edi
  803214:	89 d3                	mov    %edx,%ebx
  803216:	f7 24 24             	mull   (%esp)
  803219:	89 c6                	mov    %eax,%esi
  80321b:	89 d1                	mov    %edx,%ecx
  80321d:	39 d3                	cmp    %edx,%ebx
  80321f:	0f 82 87 00 00 00    	jb     8032ac <__umoddi3+0x134>
  803225:	0f 84 91 00 00 00    	je     8032bc <__umoddi3+0x144>
  80322b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80322f:	29 f2                	sub    %esi,%edx
  803231:	19 cb                	sbb    %ecx,%ebx
  803233:	89 d8                	mov    %ebx,%eax
  803235:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803239:	d3 e0                	shl    %cl,%eax
  80323b:	89 e9                	mov    %ebp,%ecx
  80323d:	d3 ea                	shr    %cl,%edx
  80323f:	09 d0                	or     %edx,%eax
  803241:	89 e9                	mov    %ebp,%ecx
  803243:	d3 eb                	shr    %cl,%ebx
  803245:	89 da                	mov    %ebx,%edx
  803247:	83 c4 1c             	add    $0x1c,%esp
  80324a:	5b                   	pop    %ebx
  80324b:	5e                   	pop    %esi
  80324c:	5f                   	pop    %edi
  80324d:	5d                   	pop    %ebp
  80324e:	c3                   	ret    
  80324f:	90                   	nop
  803250:	89 fd                	mov    %edi,%ebp
  803252:	85 ff                	test   %edi,%edi
  803254:	75 0b                	jne    803261 <__umoddi3+0xe9>
  803256:	b8 01 00 00 00       	mov    $0x1,%eax
  80325b:	31 d2                	xor    %edx,%edx
  80325d:	f7 f7                	div    %edi
  80325f:	89 c5                	mov    %eax,%ebp
  803261:	89 f0                	mov    %esi,%eax
  803263:	31 d2                	xor    %edx,%edx
  803265:	f7 f5                	div    %ebp
  803267:	89 c8                	mov    %ecx,%eax
  803269:	f7 f5                	div    %ebp
  80326b:	89 d0                	mov    %edx,%eax
  80326d:	e9 44 ff ff ff       	jmp    8031b6 <__umoddi3+0x3e>
  803272:	66 90                	xchg   %ax,%ax
  803274:	89 c8                	mov    %ecx,%eax
  803276:	89 f2                	mov    %esi,%edx
  803278:	83 c4 1c             	add    $0x1c,%esp
  80327b:	5b                   	pop    %ebx
  80327c:	5e                   	pop    %esi
  80327d:	5f                   	pop    %edi
  80327e:	5d                   	pop    %ebp
  80327f:	c3                   	ret    
  803280:	3b 04 24             	cmp    (%esp),%eax
  803283:	72 06                	jb     80328b <__umoddi3+0x113>
  803285:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803289:	77 0f                	ja     80329a <__umoddi3+0x122>
  80328b:	89 f2                	mov    %esi,%edx
  80328d:	29 f9                	sub    %edi,%ecx
  80328f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803293:	89 14 24             	mov    %edx,(%esp)
  803296:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80329a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80329e:	8b 14 24             	mov    (%esp),%edx
  8032a1:	83 c4 1c             	add    $0x1c,%esp
  8032a4:	5b                   	pop    %ebx
  8032a5:	5e                   	pop    %esi
  8032a6:	5f                   	pop    %edi
  8032a7:	5d                   	pop    %ebp
  8032a8:	c3                   	ret    
  8032a9:	8d 76 00             	lea    0x0(%esi),%esi
  8032ac:	2b 04 24             	sub    (%esp),%eax
  8032af:	19 fa                	sbb    %edi,%edx
  8032b1:	89 d1                	mov    %edx,%ecx
  8032b3:	89 c6                	mov    %eax,%esi
  8032b5:	e9 71 ff ff ff       	jmp    80322b <__umoddi3+0xb3>
  8032ba:	66 90                	xchg   %ax,%ax
  8032bc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8032c0:	72 ea                	jb     8032ac <__umoddi3+0x134>
  8032c2:	89 d9                	mov    %ebx,%ecx
  8032c4:	e9 62 ff ff ff       	jmp    80322b <__umoddi3+0xb3>
