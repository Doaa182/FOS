
obj/user/tst_sharing_5_slaveB2:     file format elf32-i386


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
  800031:	e8 44 01 00 00       	call   80017a <libmain>
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
  80008c:	68 00 33 80 00       	push   $0x803300
  800091:	6a 12                	push   $0x12
  800093:	68 1c 33 80 00       	push   $0x80331c
  800098:	e8 19 02 00 00       	call   8002b6 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009d:	83 ec 0c             	sub    $0xc,%esp
  8000a0:	6a 00                	push   $0x0
  8000a2:	e8 3c 14 00 00       	call   8014e3 <malloc>
  8000a7:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	uint32 *z;
	z = sget(sys_getparentenvid(),"z");
  8000aa:	e8 6c 1b 00 00       	call   801c1b <sys_getparentenvid>
  8000af:	83 ec 08             	sub    $0x8,%esp
  8000b2:	68 39 33 80 00       	push   $0x803339
  8000b7:	50                   	push   %eax
  8000b8:	e8 40 16 00 00       	call   8016fd <sget>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B2 env used z (getSharedObject)\n");
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	68 3c 33 80 00       	push   $0x80333c
  8000cb:	e8 9a 04 00 00       	call   80056a <cprintf>
  8000d0:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's successfully got z
	inctst();
  8000d3:	e8 68 1c 00 00       	call   801d40 <inctst>

	cprintf("Slave B2 please be patient ...\n");
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	68 64 33 80 00       	push   $0x803364
  8000e0:	e8 85 04 00 00       	call   80056a <cprintf>
  8000e5:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z
	env_sleep(9000);
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	68 28 23 00 00       	push   $0x2328
  8000f0:	e8 e4 2e 00 00       	call   802fd9 <env_sleep>
  8000f5:	83 c4 10             	add    $0x10,%esp
	//to ensure that the other environments completed successfully
	while (gettst()!=2) ;// panic("test failed");
  8000f8:	90                   	nop
  8000f9:	e8 5c 1c 00 00       	call   801d5a <gettst>
  8000fe:	83 f8 02             	cmp    $0x2,%eax
  800101:	75 f6                	jne    8000f9 <_main+0xc1>

	int freeFrames = sys_calculate_free_frames() ;
  800103:	e8 1a 18 00 00       	call   801922 <sys_calculate_free_frames>
  800108:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(z);
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	ff 75 ec             	pushl  -0x14(%ebp)
  800111:	e8 ac 16 00 00       	call   8017c2 <sfree>
  800116:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B2 env removed z\n");
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	68 84 33 80 00       	push   $0x803384
  800121:	e8 44 04 00 00       	call   80056a <cprintf>
  800126:	83 c4 10             	add    $0x10,%esp
	int expected = (1+1) + (1+1);
  800129:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
	if ((sys_calculate_free_frames() - freeFrames) !=  expected) panic("wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table + 1 frame for z\nframes_storage of z: should be cleared now\n");
  800130:	e8 ed 17 00 00       	call   801922 <sys_calculate_free_frames>
  800135:	89 c2                	mov    %eax,%edx
  800137:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80013a:	29 c2                	sub    %eax,%edx
  80013c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80013f:	39 c2                	cmp    %eax,%edx
  800141:	74 14                	je     800157 <_main+0x11f>
  800143:	83 ec 04             	sub    $0x4,%esp
  800146:	68 9c 33 80 00       	push   $0x80339c
  80014b:	6a 2a                	push   $0x2a
  80014d:	68 1c 33 80 00       	push   $0x80331c
  800152:	e8 5f 01 00 00       	call   8002b6 <_panic>


	cprintf("Step B completed successfully!!\n\n\n");
  800157:	83 ec 0c             	sub    $0xc,%esp
  80015a:	68 3c 34 80 00       	push   $0x80343c
  80015f:	e8 06 04 00 00       	call   80056a <cprintf>
  800164:	83 c4 10             	add    $0x10,%esp
	cprintf("Congratulations!! Test of freeSharedObjects [5] completed successfully!!\n\n\n");
  800167:	83 ec 0c             	sub    $0xc,%esp
  80016a:	68 60 34 80 00       	push   $0x803460
  80016f:	e8 f6 03 00 00       	call   80056a <cprintf>
  800174:	83 c4 10             	add    $0x10,%esp

	return;
  800177:	90                   	nop
}
  800178:	c9                   	leave  
  800179:	c3                   	ret    

0080017a <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80017a:	55                   	push   %ebp
  80017b:	89 e5                	mov    %esp,%ebp
  80017d:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800180:	e8 7d 1a 00 00       	call   801c02 <sys_getenvindex>
  800185:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800188:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80018b:	89 d0                	mov    %edx,%eax
  80018d:	c1 e0 03             	shl    $0x3,%eax
  800190:	01 d0                	add    %edx,%eax
  800192:	01 c0                	add    %eax,%eax
  800194:	01 d0                	add    %edx,%eax
  800196:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80019d:	01 d0                	add    %edx,%eax
  80019f:	c1 e0 04             	shl    $0x4,%eax
  8001a2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001a7:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001ac:	a1 20 40 80 00       	mov    0x804020,%eax
  8001b1:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001b7:	84 c0                	test   %al,%al
  8001b9:	74 0f                	je     8001ca <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001bb:	a1 20 40 80 00       	mov    0x804020,%eax
  8001c0:	05 5c 05 00 00       	add    $0x55c,%eax
  8001c5:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001ce:	7e 0a                	jle    8001da <libmain+0x60>
		binaryname = argv[0];
  8001d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d3:	8b 00                	mov    (%eax),%eax
  8001d5:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001da:	83 ec 08             	sub    $0x8,%esp
  8001dd:	ff 75 0c             	pushl  0xc(%ebp)
  8001e0:	ff 75 08             	pushl  0x8(%ebp)
  8001e3:	e8 50 fe ff ff       	call   800038 <_main>
  8001e8:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001eb:	e8 1f 18 00 00       	call   801a0f <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001f0:	83 ec 0c             	sub    $0xc,%esp
  8001f3:	68 c4 34 80 00       	push   $0x8034c4
  8001f8:	e8 6d 03 00 00       	call   80056a <cprintf>
  8001fd:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800200:	a1 20 40 80 00       	mov    0x804020,%eax
  800205:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80020b:	a1 20 40 80 00       	mov    0x804020,%eax
  800210:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800216:	83 ec 04             	sub    $0x4,%esp
  800219:	52                   	push   %edx
  80021a:	50                   	push   %eax
  80021b:	68 ec 34 80 00       	push   $0x8034ec
  800220:	e8 45 03 00 00       	call   80056a <cprintf>
  800225:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800228:	a1 20 40 80 00       	mov    0x804020,%eax
  80022d:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800233:	a1 20 40 80 00       	mov    0x804020,%eax
  800238:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80023e:	a1 20 40 80 00       	mov    0x804020,%eax
  800243:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800249:	51                   	push   %ecx
  80024a:	52                   	push   %edx
  80024b:	50                   	push   %eax
  80024c:	68 14 35 80 00       	push   $0x803514
  800251:	e8 14 03 00 00       	call   80056a <cprintf>
  800256:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800259:	a1 20 40 80 00       	mov    0x804020,%eax
  80025e:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800264:	83 ec 08             	sub    $0x8,%esp
  800267:	50                   	push   %eax
  800268:	68 6c 35 80 00       	push   $0x80356c
  80026d:	e8 f8 02 00 00       	call   80056a <cprintf>
  800272:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800275:	83 ec 0c             	sub    $0xc,%esp
  800278:	68 c4 34 80 00       	push   $0x8034c4
  80027d:	e8 e8 02 00 00       	call   80056a <cprintf>
  800282:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800285:	e8 9f 17 00 00       	call   801a29 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80028a:	e8 19 00 00 00       	call   8002a8 <exit>
}
  80028f:	90                   	nop
  800290:	c9                   	leave  
  800291:	c3                   	ret    

00800292 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800292:	55                   	push   %ebp
  800293:	89 e5                	mov    %esp,%ebp
  800295:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800298:	83 ec 0c             	sub    $0xc,%esp
  80029b:	6a 00                	push   $0x0
  80029d:	e8 2c 19 00 00       	call   801bce <sys_destroy_env>
  8002a2:	83 c4 10             	add    $0x10,%esp
}
  8002a5:	90                   	nop
  8002a6:	c9                   	leave  
  8002a7:	c3                   	ret    

008002a8 <exit>:

void
exit(void)
{
  8002a8:	55                   	push   %ebp
  8002a9:	89 e5                	mov    %esp,%ebp
  8002ab:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002ae:	e8 81 19 00 00       	call   801c34 <sys_exit_env>
}
  8002b3:	90                   	nop
  8002b4:	c9                   	leave  
  8002b5:	c3                   	ret    

008002b6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002b6:	55                   	push   %ebp
  8002b7:	89 e5                	mov    %esp,%ebp
  8002b9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002bc:	8d 45 10             	lea    0x10(%ebp),%eax
  8002bf:	83 c0 04             	add    $0x4,%eax
  8002c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002c5:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002ca:	85 c0                	test   %eax,%eax
  8002cc:	74 16                	je     8002e4 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002ce:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002d3:	83 ec 08             	sub    $0x8,%esp
  8002d6:	50                   	push   %eax
  8002d7:	68 80 35 80 00       	push   $0x803580
  8002dc:	e8 89 02 00 00       	call   80056a <cprintf>
  8002e1:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002e4:	a1 00 40 80 00       	mov    0x804000,%eax
  8002e9:	ff 75 0c             	pushl  0xc(%ebp)
  8002ec:	ff 75 08             	pushl  0x8(%ebp)
  8002ef:	50                   	push   %eax
  8002f0:	68 85 35 80 00       	push   $0x803585
  8002f5:	e8 70 02 00 00       	call   80056a <cprintf>
  8002fa:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002fd:	8b 45 10             	mov    0x10(%ebp),%eax
  800300:	83 ec 08             	sub    $0x8,%esp
  800303:	ff 75 f4             	pushl  -0xc(%ebp)
  800306:	50                   	push   %eax
  800307:	e8 f3 01 00 00       	call   8004ff <vcprintf>
  80030c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80030f:	83 ec 08             	sub    $0x8,%esp
  800312:	6a 00                	push   $0x0
  800314:	68 a1 35 80 00       	push   $0x8035a1
  800319:	e8 e1 01 00 00       	call   8004ff <vcprintf>
  80031e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800321:	e8 82 ff ff ff       	call   8002a8 <exit>

	// should not return here
	while (1) ;
  800326:	eb fe                	jmp    800326 <_panic+0x70>

00800328 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800328:	55                   	push   %ebp
  800329:	89 e5                	mov    %esp,%ebp
  80032b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80032e:	a1 20 40 80 00       	mov    0x804020,%eax
  800333:	8b 50 74             	mov    0x74(%eax),%edx
  800336:	8b 45 0c             	mov    0xc(%ebp),%eax
  800339:	39 c2                	cmp    %eax,%edx
  80033b:	74 14                	je     800351 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80033d:	83 ec 04             	sub    $0x4,%esp
  800340:	68 a4 35 80 00       	push   $0x8035a4
  800345:	6a 26                	push   $0x26
  800347:	68 f0 35 80 00       	push   $0x8035f0
  80034c:	e8 65 ff ff ff       	call   8002b6 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800351:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800358:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80035f:	e9 c2 00 00 00       	jmp    800426 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800364:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800367:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80036e:	8b 45 08             	mov    0x8(%ebp),%eax
  800371:	01 d0                	add    %edx,%eax
  800373:	8b 00                	mov    (%eax),%eax
  800375:	85 c0                	test   %eax,%eax
  800377:	75 08                	jne    800381 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800379:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80037c:	e9 a2 00 00 00       	jmp    800423 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800381:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800388:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80038f:	eb 69                	jmp    8003fa <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800391:	a1 20 40 80 00       	mov    0x804020,%eax
  800396:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80039c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80039f:	89 d0                	mov    %edx,%eax
  8003a1:	01 c0                	add    %eax,%eax
  8003a3:	01 d0                	add    %edx,%eax
  8003a5:	c1 e0 03             	shl    $0x3,%eax
  8003a8:	01 c8                	add    %ecx,%eax
  8003aa:	8a 40 04             	mov    0x4(%eax),%al
  8003ad:	84 c0                	test   %al,%al
  8003af:	75 46                	jne    8003f7 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003b1:	a1 20 40 80 00       	mov    0x804020,%eax
  8003b6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003bc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003bf:	89 d0                	mov    %edx,%eax
  8003c1:	01 c0                	add    %eax,%eax
  8003c3:	01 d0                	add    %edx,%eax
  8003c5:	c1 e0 03             	shl    $0x3,%eax
  8003c8:	01 c8                	add    %ecx,%eax
  8003ca:	8b 00                	mov    (%eax),%eax
  8003cc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003d7:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003dc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e6:	01 c8                	add    %ecx,%eax
  8003e8:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003ea:	39 c2                	cmp    %eax,%edx
  8003ec:	75 09                	jne    8003f7 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003ee:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003f5:	eb 12                	jmp    800409 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003f7:	ff 45 e8             	incl   -0x18(%ebp)
  8003fa:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ff:	8b 50 74             	mov    0x74(%eax),%edx
  800402:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800405:	39 c2                	cmp    %eax,%edx
  800407:	77 88                	ja     800391 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800409:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80040d:	75 14                	jne    800423 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80040f:	83 ec 04             	sub    $0x4,%esp
  800412:	68 fc 35 80 00       	push   $0x8035fc
  800417:	6a 3a                	push   $0x3a
  800419:	68 f0 35 80 00       	push   $0x8035f0
  80041e:	e8 93 fe ff ff       	call   8002b6 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800423:	ff 45 f0             	incl   -0x10(%ebp)
  800426:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800429:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80042c:	0f 8c 32 ff ff ff    	jl     800364 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800432:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800439:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800440:	eb 26                	jmp    800468 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800442:	a1 20 40 80 00       	mov    0x804020,%eax
  800447:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80044d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800450:	89 d0                	mov    %edx,%eax
  800452:	01 c0                	add    %eax,%eax
  800454:	01 d0                	add    %edx,%eax
  800456:	c1 e0 03             	shl    $0x3,%eax
  800459:	01 c8                	add    %ecx,%eax
  80045b:	8a 40 04             	mov    0x4(%eax),%al
  80045e:	3c 01                	cmp    $0x1,%al
  800460:	75 03                	jne    800465 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800462:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800465:	ff 45 e0             	incl   -0x20(%ebp)
  800468:	a1 20 40 80 00       	mov    0x804020,%eax
  80046d:	8b 50 74             	mov    0x74(%eax),%edx
  800470:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800473:	39 c2                	cmp    %eax,%edx
  800475:	77 cb                	ja     800442 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800477:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80047a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80047d:	74 14                	je     800493 <CheckWSWithoutLastIndex+0x16b>
		panic(
  80047f:	83 ec 04             	sub    $0x4,%esp
  800482:	68 50 36 80 00       	push   $0x803650
  800487:	6a 44                	push   $0x44
  800489:	68 f0 35 80 00       	push   $0x8035f0
  80048e:	e8 23 fe ff ff       	call   8002b6 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800493:	90                   	nop
  800494:	c9                   	leave  
  800495:	c3                   	ret    

00800496 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800496:	55                   	push   %ebp
  800497:	89 e5                	mov    %esp,%ebp
  800499:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80049c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049f:	8b 00                	mov    (%eax),%eax
  8004a1:	8d 48 01             	lea    0x1(%eax),%ecx
  8004a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a7:	89 0a                	mov    %ecx,(%edx)
  8004a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8004ac:	88 d1                	mov    %dl,%cl
  8004ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b8:	8b 00                	mov    (%eax),%eax
  8004ba:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004bf:	75 2c                	jne    8004ed <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004c1:	a0 24 40 80 00       	mov    0x804024,%al
  8004c6:	0f b6 c0             	movzbl %al,%eax
  8004c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004cc:	8b 12                	mov    (%edx),%edx
  8004ce:	89 d1                	mov    %edx,%ecx
  8004d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004d3:	83 c2 08             	add    $0x8,%edx
  8004d6:	83 ec 04             	sub    $0x4,%esp
  8004d9:	50                   	push   %eax
  8004da:	51                   	push   %ecx
  8004db:	52                   	push   %edx
  8004dc:	e8 80 13 00 00       	call   801861 <sys_cputs>
  8004e1:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f0:	8b 40 04             	mov    0x4(%eax),%eax
  8004f3:	8d 50 01             	lea    0x1(%eax),%edx
  8004f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f9:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004fc:	90                   	nop
  8004fd:	c9                   	leave  
  8004fe:	c3                   	ret    

008004ff <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004ff:	55                   	push   %ebp
  800500:	89 e5                	mov    %esp,%ebp
  800502:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800508:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80050f:	00 00 00 
	b.cnt = 0;
  800512:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800519:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80051c:	ff 75 0c             	pushl  0xc(%ebp)
  80051f:	ff 75 08             	pushl  0x8(%ebp)
  800522:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800528:	50                   	push   %eax
  800529:	68 96 04 80 00       	push   $0x800496
  80052e:	e8 11 02 00 00       	call   800744 <vprintfmt>
  800533:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800536:	a0 24 40 80 00       	mov    0x804024,%al
  80053b:	0f b6 c0             	movzbl %al,%eax
  80053e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800544:	83 ec 04             	sub    $0x4,%esp
  800547:	50                   	push   %eax
  800548:	52                   	push   %edx
  800549:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80054f:	83 c0 08             	add    $0x8,%eax
  800552:	50                   	push   %eax
  800553:	e8 09 13 00 00       	call   801861 <sys_cputs>
  800558:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80055b:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800562:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800568:	c9                   	leave  
  800569:	c3                   	ret    

0080056a <cprintf>:

int cprintf(const char *fmt, ...) {
  80056a:	55                   	push   %ebp
  80056b:	89 e5                	mov    %esp,%ebp
  80056d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800570:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800577:	8d 45 0c             	lea    0xc(%ebp),%eax
  80057a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80057d:	8b 45 08             	mov    0x8(%ebp),%eax
  800580:	83 ec 08             	sub    $0x8,%esp
  800583:	ff 75 f4             	pushl  -0xc(%ebp)
  800586:	50                   	push   %eax
  800587:	e8 73 ff ff ff       	call   8004ff <vcprintf>
  80058c:	83 c4 10             	add    $0x10,%esp
  80058f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800592:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800595:	c9                   	leave  
  800596:	c3                   	ret    

00800597 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800597:	55                   	push   %ebp
  800598:	89 e5                	mov    %esp,%ebp
  80059a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80059d:	e8 6d 14 00 00       	call   801a0f <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005a2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ab:	83 ec 08             	sub    $0x8,%esp
  8005ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8005b1:	50                   	push   %eax
  8005b2:	e8 48 ff ff ff       	call   8004ff <vcprintf>
  8005b7:	83 c4 10             	add    $0x10,%esp
  8005ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005bd:	e8 67 14 00 00       	call   801a29 <sys_enable_interrupt>
	return cnt;
  8005c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005c5:	c9                   	leave  
  8005c6:	c3                   	ret    

008005c7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005c7:	55                   	push   %ebp
  8005c8:	89 e5                	mov    %esp,%ebp
  8005ca:	53                   	push   %ebx
  8005cb:	83 ec 14             	sub    $0x14,%esp
  8005ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8005d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005da:	8b 45 18             	mov    0x18(%ebp),%eax
  8005dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005e5:	77 55                	ja     80063c <printnum+0x75>
  8005e7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ea:	72 05                	jb     8005f1 <printnum+0x2a>
  8005ec:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005ef:	77 4b                	ja     80063c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005f1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005f4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005f7:	8b 45 18             	mov    0x18(%ebp),%eax
  8005fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ff:	52                   	push   %edx
  800600:	50                   	push   %eax
  800601:	ff 75 f4             	pushl  -0xc(%ebp)
  800604:	ff 75 f0             	pushl  -0x10(%ebp)
  800607:	e8 84 2a 00 00       	call   803090 <__udivdi3>
  80060c:	83 c4 10             	add    $0x10,%esp
  80060f:	83 ec 04             	sub    $0x4,%esp
  800612:	ff 75 20             	pushl  0x20(%ebp)
  800615:	53                   	push   %ebx
  800616:	ff 75 18             	pushl  0x18(%ebp)
  800619:	52                   	push   %edx
  80061a:	50                   	push   %eax
  80061b:	ff 75 0c             	pushl  0xc(%ebp)
  80061e:	ff 75 08             	pushl  0x8(%ebp)
  800621:	e8 a1 ff ff ff       	call   8005c7 <printnum>
  800626:	83 c4 20             	add    $0x20,%esp
  800629:	eb 1a                	jmp    800645 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80062b:	83 ec 08             	sub    $0x8,%esp
  80062e:	ff 75 0c             	pushl  0xc(%ebp)
  800631:	ff 75 20             	pushl  0x20(%ebp)
  800634:	8b 45 08             	mov    0x8(%ebp),%eax
  800637:	ff d0                	call   *%eax
  800639:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80063c:	ff 4d 1c             	decl   0x1c(%ebp)
  80063f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800643:	7f e6                	jg     80062b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800645:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800648:	bb 00 00 00 00       	mov    $0x0,%ebx
  80064d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800650:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800653:	53                   	push   %ebx
  800654:	51                   	push   %ecx
  800655:	52                   	push   %edx
  800656:	50                   	push   %eax
  800657:	e8 44 2b 00 00       	call   8031a0 <__umoddi3>
  80065c:	83 c4 10             	add    $0x10,%esp
  80065f:	05 b4 38 80 00       	add    $0x8038b4,%eax
  800664:	8a 00                	mov    (%eax),%al
  800666:	0f be c0             	movsbl %al,%eax
  800669:	83 ec 08             	sub    $0x8,%esp
  80066c:	ff 75 0c             	pushl  0xc(%ebp)
  80066f:	50                   	push   %eax
  800670:	8b 45 08             	mov    0x8(%ebp),%eax
  800673:	ff d0                	call   *%eax
  800675:	83 c4 10             	add    $0x10,%esp
}
  800678:	90                   	nop
  800679:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80067c:	c9                   	leave  
  80067d:	c3                   	ret    

0080067e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80067e:	55                   	push   %ebp
  80067f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800681:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800685:	7e 1c                	jle    8006a3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800687:	8b 45 08             	mov    0x8(%ebp),%eax
  80068a:	8b 00                	mov    (%eax),%eax
  80068c:	8d 50 08             	lea    0x8(%eax),%edx
  80068f:	8b 45 08             	mov    0x8(%ebp),%eax
  800692:	89 10                	mov    %edx,(%eax)
  800694:	8b 45 08             	mov    0x8(%ebp),%eax
  800697:	8b 00                	mov    (%eax),%eax
  800699:	83 e8 08             	sub    $0x8,%eax
  80069c:	8b 50 04             	mov    0x4(%eax),%edx
  80069f:	8b 00                	mov    (%eax),%eax
  8006a1:	eb 40                	jmp    8006e3 <getuint+0x65>
	else if (lflag)
  8006a3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006a7:	74 1e                	je     8006c7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ac:	8b 00                	mov    (%eax),%eax
  8006ae:	8d 50 04             	lea    0x4(%eax),%edx
  8006b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b4:	89 10                	mov    %edx,(%eax)
  8006b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b9:	8b 00                	mov    (%eax),%eax
  8006bb:	83 e8 04             	sub    $0x4,%eax
  8006be:	8b 00                	mov    (%eax),%eax
  8006c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c5:	eb 1c                	jmp    8006e3 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ca:	8b 00                	mov    (%eax),%eax
  8006cc:	8d 50 04             	lea    0x4(%eax),%edx
  8006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d2:	89 10                	mov    %edx,(%eax)
  8006d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d7:	8b 00                	mov    (%eax),%eax
  8006d9:	83 e8 04             	sub    $0x4,%eax
  8006dc:	8b 00                	mov    (%eax),%eax
  8006de:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006e3:	5d                   	pop    %ebp
  8006e4:	c3                   	ret    

008006e5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006e5:	55                   	push   %ebp
  8006e6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006e8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006ec:	7e 1c                	jle    80070a <getint+0x25>
		return va_arg(*ap, long long);
  8006ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	8d 50 08             	lea    0x8(%eax),%edx
  8006f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f9:	89 10                	mov    %edx,(%eax)
  8006fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fe:	8b 00                	mov    (%eax),%eax
  800700:	83 e8 08             	sub    $0x8,%eax
  800703:	8b 50 04             	mov    0x4(%eax),%edx
  800706:	8b 00                	mov    (%eax),%eax
  800708:	eb 38                	jmp    800742 <getint+0x5d>
	else if (lflag)
  80070a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80070e:	74 1a                	je     80072a <getint+0x45>
		return va_arg(*ap, long);
  800710:	8b 45 08             	mov    0x8(%ebp),%eax
  800713:	8b 00                	mov    (%eax),%eax
  800715:	8d 50 04             	lea    0x4(%eax),%edx
  800718:	8b 45 08             	mov    0x8(%ebp),%eax
  80071b:	89 10                	mov    %edx,(%eax)
  80071d:	8b 45 08             	mov    0x8(%ebp),%eax
  800720:	8b 00                	mov    (%eax),%eax
  800722:	83 e8 04             	sub    $0x4,%eax
  800725:	8b 00                	mov    (%eax),%eax
  800727:	99                   	cltd   
  800728:	eb 18                	jmp    800742 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80072a:	8b 45 08             	mov    0x8(%ebp),%eax
  80072d:	8b 00                	mov    (%eax),%eax
  80072f:	8d 50 04             	lea    0x4(%eax),%edx
  800732:	8b 45 08             	mov    0x8(%ebp),%eax
  800735:	89 10                	mov    %edx,(%eax)
  800737:	8b 45 08             	mov    0x8(%ebp),%eax
  80073a:	8b 00                	mov    (%eax),%eax
  80073c:	83 e8 04             	sub    $0x4,%eax
  80073f:	8b 00                	mov    (%eax),%eax
  800741:	99                   	cltd   
}
  800742:	5d                   	pop    %ebp
  800743:	c3                   	ret    

00800744 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800744:	55                   	push   %ebp
  800745:	89 e5                	mov    %esp,%ebp
  800747:	56                   	push   %esi
  800748:	53                   	push   %ebx
  800749:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80074c:	eb 17                	jmp    800765 <vprintfmt+0x21>
			if (ch == '\0')
  80074e:	85 db                	test   %ebx,%ebx
  800750:	0f 84 af 03 00 00    	je     800b05 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800756:	83 ec 08             	sub    $0x8,%esp
  800759:	ff 75 0c             	pushl  0xc(%ebp)
  80075c:	53                   	push   %ebx
  80075d:	8b 45 08             	mov    0x8(%ebp),%eax
  800760:	ff d0                	call   *%eax
  800762:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800765:	8b 45 10             	mov    0x10(%ebp),%eax
  800768:	8d 50 01             	lea    0x1(%eax),%edx
  80076b:	89 55 10             	mov    %edx,0x10(%ebp)
  80076e:	8a 00                	mov    (%eax),%al
  800770:	0f b6 d8             	movzbl %al,%ebx
  800773:	83 fb 25             	cmp    $0x25,%ebx
  800776:	75 d6                	jne    80074e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800778:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80077c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800783:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80078a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800791:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800798:	8b 45 10             	mov    0x10(%ebp),%eax
  80079b:	8d 50 01             	lea    0x1(%eax),%edx
  80079e:	89 55 10             	mov    %edx,0x10(%ebp)
  8007a1:	8a 00                	mov    (%eax),%al
  8007a3:	0f b6 d8             	movzbl %al,%ebx
  8007a6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007a9:	83 f8 55             	cmp    $0x55,%eax
  8007ac:	0f 87 2b 03 00 00    	ja     800add <vprintfmt+0x399>
  8007b2:	8b 04 85 d8 38 80 00 	mov    0x8038d8(,%eax,4),%eax
  8007b9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007bb:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007bf:	eb d7                	jmp    800798 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007c1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007c5:	eb d1                	jmp    800798 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007ce:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007d1:	89 d0                	mov    %edx,%eax
  8007d3:	c1 e0 02             	shl    $0x2,%eax
  8007d6:	01 d0                	add    %edx,%eax
  8007d8:	01 c0                	add    %eax,%eax
  8007da:	01 d8                	add    %ebx,%eax
  8007dc:	83 e8 30             	sub    $0x30,%eax
  8007df:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e5:	8a 00                	mov    (%eax),%al
  8007e7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007ea:	83 fb 2f             	cmp    $0x2f,%ebx
  8007ed:	7e 3e                	jle    80082d <vprintfmt+0xe9>
  8007ef:	83 fb 39             	cmp    $0x39,%ebx
  8007f2:	7f 39                	jg     80082d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007f4:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007f7:	eb d5                	jmp    8007ce <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fc:	83 c0 04             	add    $0x4,%eax
  8007ff:	89 45 14             	mov    %eax,0x14(%ebp)
  800802:	8b 45 14             	mov    0x14(%ebp),%eax
  800805:	83 e8 04             	sub    $0x4,%eax
  800808:	8b 00                	mov    (%eax),%eax
  80080a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80080d:	eb 1f                	jmp    80082e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80080f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800813:	79 83                	jns    800798 <vprintfmt+0x54>
				width = 0;
  800815:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80081c:	e9 77 ff ff ff       	jmp    800798 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800821:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800828:	e9 6b ff ff ff       	jmp    800798 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80082d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80082e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800832:	0f 89 60 ff ff ff    	jns    800798 <vprintfmt+0x54>
				width = precision, precision = -1;
  800838:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80083b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80083e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800845:	e9 4e ff ff ff       	jmp    800798 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80084a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80084d:	e9 46 ff ff ff       	jmp    800798 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800852:	8b 45 14             	mov    0x14(%ebp),%eax
  800855:	83 c0 04             	add    $0x4,%eax
  800858:	89 45 14             	mov    %eax,0x14(%ebp)
  80085b:	8b 45 14             	mov    0x14(%ebp),%eax
  80085e:	83 e8 04             	sub    $0x4,%eax
  800861:	8b 00                	mov    (%eax),%eax
  800863:	83 ec 08             	sub    $0x8,%esp
  800866:	ff 75 0c             	pushl  0xc(%ebp)
  800869:	50                   	push   %eax
  80086a:	8b 45 08             	mov    0x8(%ebp),%eax
  80086d:	ff d0                	call   *%eax
  80086f:	83 c4 10             	add    $0x10,%esp
			break;
  800872:	e9 89 02 00 00       	jmp    800b00 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800877:	8b 45 14             	mov    0x14(%ebp),%eax
  80087a:	83 c0 04             	add    $0x4,%eax
  80087d:	89 45 14             	mov    %eax,0x14(%ebp)
  800880:	8b 45 14             	mov    0x14(%ebp),%eax
  800883:	83 e8 04             	sub    $0x4,%eax
  800886:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800888:	85 db                	test   %ebx,%ebx
  80088a:	79 02                	jns    80088e <vprintfmt+0x14a>
				err = -err;
  80088c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80088e:	83 fb 64             	cmp    $0x64,%ebx
  800891:	7f 0b                	jg     80089e <vprintfmt+0x15a>
  800893:	8b 34 9d 20 37 80 00 	mov    0x803720(,%ebx,4),%esi
  80089a:	85 f6                	test   %esi,%esi
  80089c:	75 19                	jne    8008b7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80089e:	53                   	push   %ebx
  80089f:	68 c5 38 80 00       	push   $0x8038c5
  8008a4:	ff 75 0c             	pushl  0xc(%ebp)
  8008a7:	ff 75 08             	pushl  0x8(%ebp)
  8008aa:	e8 5e 02 00 00       	call   800b0d <printfmt>
  8008af:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008b2:	e9 49 02 00 00       	jmp    800b00 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008b7:	56                   	push   %esi
  8008b8:	68 ce 38 80 00       	push   $0x8038ce
  8008bd:	ff 75 0c             	pushl  0xc(%ebp)
  8008c0:	ff 75 08             	pushl  0x8(%ebp)
  8008c3:	e8 45 02 00 00       	call   800b0d <printfmt>
  8008c8:	83 c4 10             	add    $0x10,%esp
			break;
  8008cb:	e9 30 02 00 00       	jmp    800b00 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d3:	83 c0 04             	add    $0x4,%eax
  8008d6:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008dc:	83 e8 04             	sub    $0x4,%eax
  8008df:	8b 30                	mov    (%eax),%esi
  8008e1:	85 f6                	test   %esi,%esi
  8008e3:	75 05                	jne    8008ea <vprintfmt+0x1a6>
				p = "(null)";
  8008e5:	be d1 38 80 00       	mov    $0x8038d1,%esi
			if (width > 0 && padc != '-')
  8008ea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ee:	7e 6d                	jle    80095d <vprintfmt+0x219>
  8008f0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008f4:	74 67                	je     80095d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f9:	83 ec 08             	sub    $0x8,%esp
  8008fc:	50                   	push   %eax
  8008fd:	56                   	push   %esi
  8008fe:	e8 0c 03 00 00       	call   800c0f <strnlen>
  800903:	83 c4 10             	add    $0x10,%esp
  800906:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800909:	eb 16                	jmp    800921 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80090b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80090f:	83 ec 08             	sub    $0x8,%esp
  800912:	ff 75 0c             	pushl  0xc(%ebp)
  800915:	50                   	push   %eax
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	ff d0                	call   *%eax
  80091b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80091e:	ff 4d e4             	decl   -0x1c(%ebp)
  800921:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800925:	7f e4                	jg     80090b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800927:	eb 34                	jmp    80095d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800929:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80092d:	74 1c                	je     80094b <vprintfmt+0x207>
  80092f:	83 fb 1f             	cmp    $0x1f,%ebx
  800932:	7e 05                	jle    800939 <vprintfmt+0x1f5>
  800934:	83 fb 7e             	cmp    $0x7e,%ebx
  800937:	7e 12                	jle    80094b <vprintfmt+0x207>
					putch('?', putdat);
  800939:	83 ec 08             	sub    $0x8,%esp
  80093c:	ff 75 0c             	pushl  0xc(%ebp)
  80093f:	6a 3f                	push   $0x3f
  800941:	8b 45 08             	mov    0x8(%ebp),%eax
  800944:	ff d0                	call   *%eax
  800946:	83 c4 10             	add    $0x10,%esp
  800949:	eb 0f                	jmp    80095a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80094b:	83 ec 08             	sub    $0x8,%esp
  80094e:	ff 75 0c             	pushl  0xc(%ebp)
  800951:	53                   	push   %ebx
  800952:	8b 45 08             	mov    0x8(%ebp),%eax
  800955:	ff d0                	call   *%eax
  800957:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80095a:	ff 4d e4             	decl   -0x1c(%ebp)
  80095d:	89 f0                	mov    %esi,%eax
  80095f:	8d 70 01             	lea    0x1(%eax),%esi
  800962:	8a 00                	mov    (%eax),%al
  800964:	0f be d8             	movsbl %al,%ebx
  800967:	85 db                	test   %ebx,%ebx
  800969:	74 24                	je     80098f <vprintfmt+0x24b>
  80096b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80096f:	78 b8                	js     800929 <vprintfmt+0x1e5>
  800971:	ff 4d e0             	decl   -0x20(%ebp)
  800974:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800978:	79 af                	jns    800929 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80097a:	eb 13                	jmp    80098f <vprintfmt+0x24b>
				putch(' ', putdat);
  80097c:	83 ec 08             	sub    $0x8,%esp
  80097f:	ff 75 0c             	pushl  0xc(%ebp)
  800982:	6a 20                	push   $0x20
  800984:	8b 45 08             	mov    0x8(%ebp),%eax
  800987:	ff d0                	call   *%eax
  800989:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80098c:	ff 4d e4             	decl   -0x1c(%ebp)
  80098f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800993:	7f e7                	jg     80097c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800995:	e9 66 01 00 00       	jmp    800b00 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80099a:	83 ec 08             	sub    $0x8,%esp
  80099d:	ff 75 e8             	pushl  -0x18(%ebp)
  8009a0:	8d 45 14             	lea    0x14(%ebp),%eax
  8009a3:	50                   	push   %eax
  8009a4:	e8 3c fd ff ff       	call   8006e5 <getint>
  8009a9:	83 c4 10             	add    $0x10,%esp
  8009ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009af:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009b8:	85 d2                	test   %edx,%edx
  8009ba:	79 23                	jns    8009df <vprintfmt+0x29b>
				putch('-', putdat);
  8009bc:	83 ec 08             	sub    $0x8,%esp
  8009bf:	ff 75 0c             	pushl  0xc(%ebp)
  8009c2:	6a 2d                	push   $0x2d
  8009c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c7:	ff d0                	call   *%eax
  8009c9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009d2:	f7 d8                	neg    %eax
  8009d4:	83 d2 00             	adc    $0x0,%edx
  8009d7:	f7 da                	neg    %edx
  8009d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009dc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009df:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009e6:	e9 bc 00 00 00       	jmp    800aa7 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009eb:	83 ec 08             	sub    $0x8,%esp
  8009ee:	ff 75 e8             	pushl  -0x18(%ebp)
  8009f1:	8d 45 14             	lea    0x14(%ebp),%eax
  8009f4:	50                   	push   %eax
  8009f5:	e8 84 fc ff ff       	call   80067e <getuint>
  8009fa:	83 c4 10             	add    $0x10,%esp
  8009fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a00:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a03:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a0a:	e9 98 00 00 00       	jmp    800aa7 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a0f:	83 ec 08             	sub    $0x8,%esp
  800a12:	ff 75 0c             	pushl  0xc(%ebp)
  800a15:	6a 58                	push   $0x58
  800a17:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1a:	ff d0                	call   *%eax
  800a1c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a1f:	83 ec 08             	sub    $0x8,%esp
  800a22:	ff 75 0c             	pushl  0xc(%ebp)
  800a25:	6a 58                	push   $0x58
  800a27:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2a:	ff d0                	call   *%eax
  800a2c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a2f:	83 ec 08             	sub    $0x8,%esp
  800a32:	ff 75 0c             	pushl  0xc(%ebp)
  800a35:	6a 58                	push   $0x58
  800a37:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3a:	ff d0                	call   *%eax
  800a3c:	83 c4 10             	add    $0x10,%esp
			break;
  800a3f:	e9 bc 00 00 00       	jmp    800b00 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a44:	83 ec 08             	sub    $0x8,%esp
  800a47:	ff 75 0c             	pushl  0xc(%ebp)
  800a4a:	6a 30                	push   $0x30
  800a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4f:	ff d0                	call   *%eax
  800a51:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a54:	83 ec 08             	sub    $0x8,%esp
  800a57:	ff 75 0c             	pushl  0xc(%ebp)
  800a5a:	6a 78                	push   $0x78
  800a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5f:	ff d0                	call   *%eax
  800a61:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a64:	8b 45 14             	mov    0x14(%ebp),%eax
  800a67:	83 c0 04             	add    $0x4,%eax
  800a6a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a6d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a70:	83 e8 04             	sub    $0x4,%eax
  800a73:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a75:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a7f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a86:	eb 1f                	jmp    800aa7 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a88:	83 ec 08             	sub    $0x8,%esp
  800a8b:	ff 75 e8             	pushl  -0x18(%ebp)
  800a8e:	8d 45 14             	lea    0x14(%ebp),%eax
  800a91:	50                   	push   %eax
  800a92:	e8 e7 fb ff ff       	call   80067e <getuint>
  800a97:	83 c4 10             	add    $0x10,%esp
  800a9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a9d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800aa0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aa7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800aab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aae:	83 ec 04             	sub    $0x4,%esp
  800ab1:	52                   	push   %edx
  800ab2:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ab5:	50                   	push   %eax
  800ab6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab9:	ff 75 f0             	pushl  -0x10(%ebp)
  800abc:	ff 75 0c             	pushl  0xc(%ebp)
  800abf:	ff 75 08             	pushl  0x8(%ebp)
  800ac2:	e8 00 fb ff ff       	call   8005c7 <printnum>
  800ac7:	83 c4 20             	add    $0x20,%esp
			break;
  800aca:	eb 34                	jmp    800b00 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800acc:	83 ec 08             	sub    $0x8,%esp
  800acf:	ff 75 0c             	pushl  0xc(%ebp)
  800ad2:	53                   	push   %ebx
  800ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad6:	ff d0                	call   *%eax
  800ad8:	83 c4 10             	add    $0x10,%esp
			break;
  800adb:	eb 23                	jmp    800b00 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800add:	83 ec 08             	sub    $0x8,%esp
  800ae0:	ff 75 0c             	pushl  0xc(%ebp)
  800ae3:	6a 25                	push   $0x25
  800ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae8:	ff d0                	call   *%eax
  800aea:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aed:	ff 4d 10             	decl   0x10(%ebp)
  800af0:	eb 03                	jmp    800af5 <vprintfmt+0x3b1>
  800af2:	ff 4d 10             	decl   0x10(%ebp)
  800af5:	8b 45 10             	mov    0x10(%ebp),%eax
  800af8:	48                   	dec    %eax
  800af9:	8a 00                	mov    (%eax),%al
  800afb:	3c 25                	cmp    $0x25,%al
  800afd:	75 f3                	jne    800af2 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800aff:	90                   	nop
		}
	}
  800b00:	e9 47 fc ff ff       	jmp    80074c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b05:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b06:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b09:	5b                   	pop    %ebx
  800b0a:	5e                   	pop    %esi
  800b0b:	5d                   	pop    %ebp
  800b0c:	c3                   	ret    

00800b0d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b0d:	55                   	push   %ebp
  800b0e:	89 e5                	mov    %esp,%ebp
  800b10:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b13:	8d 45 10             	lea    0x10(%ebp),%eax
  800b16:	83 c0 04             	add    $0x4,%eax
  800b19:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b1c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b1f:	ff 75 f4             	pushl  -0xc(%ebp)
  800b22:	50                   	push   %eax
  800b23:	ff 75 0c             	pushl  0xc(%ebp)
  800b26:	ff 75 08             	pushl  0x8(%ebp)
  800b29:	e8 16 fc ff ff       	call   800744 <vprintfmt>
  800b2e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b31:	90                   	nop
  800b32:	c9                   	leave  
  800b33:	c3                   	ret    

00800b34 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b34:	55                   	push   %ebp
  800b35:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3a:	8b 40 08             	mov    0x8(%eax),%eax
  800b3d:	8d 50 01             	lea    0x1(%eax),%edx
  800b40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b43:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b49:	8b 10                	mov    (%eax),%edx
  800b4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4e:	8b 40 04             	mov    0x4(%eax),%eax
  800b51:	39 c2                	cmp    %eax,%edx
  800b53:	73 12                	jae    800b67 <sprintputch+0x33>
		*b->buf++ = ch;
  800b55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b58:	8b 00                	mov    (%eax),%eax
  800b5a:	8d 48 01             	lea    0x1(%eax),%ecx
  800b5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b60:	89 0a                	mov    %ecx,(%edx)
  800b62:	8b 55 08             	mov    0x8(%ebp),%edx
  800b65:	88 10                	mov    %dl,(%eax)
}
  800b67:	90                   	nop
  800b68:	5d                   	pop    %ebp
  800b69:	c3                   	ret    

00800b6a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b6a:	55                   	push   %ebp
  800b6b:	89 e5                	mov    %esp,%ebp
  800b6d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b70:	8b 45 08             	mov    0x8(%ebp),%eax
  800b73:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b79:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7f:	01 d0                	add    %edx,%eax
  800b81:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b84:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b8b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b8f:	74 06                	je     800b97 <vsnprintf+0x2d>
  800b91:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b95:	7f 07                	jg     800b9e <vsnprintf+0x34>
		return -E_INVAL;
  800b97:	b8 03 00 00 00       	mov    $0x3,%eax
  800b9c:	eb 20                	jmp    800bbe <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b9e:	ff 75 14             	pushl  0x14(%ebp)
  800ba1:	ff 75 10             	pushl  0x10(%ebp)
  800ba4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ba7:	50                   	push   %eax
  800ba8:	68 34 0b 80 00       	push   $0x800b34
  800bad:	e8 92 fb ff ff       	call   800744 <vprintfmt>
  800bb2:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bb8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bbe:	c9                   	leave  
  800bbf:	c3                   	ret    

00800bc0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
  800bc3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bc6:	8d 45 10             	lea    0x10(%ebp),%eax
  800bc9:	83 c0 04             	add    $0x4,%eax
  800bcc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bcf:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd2:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd5:	50                   	push   %eax
  800bd6:	ff 75 0c             	pushl  0xc(%ebp)
  800bd9:	ff 75 08             	pushl  0x8(%ebp)
  800bdc:	e8 89 ff ff ff       	call   800b6a <vsnprintf>
  800be1:	83 c4 10             	add    $0x10,%esp
  800be4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800be7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bea:	c9                   	leave  
  800beb:	c3                   	ret    

00800bec <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bf2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bf9:	eb 06                	jmp    800c01 <strlen+0x15>
		n++;
  800bfb:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bfe:	ff 45 08             	incl   0x8(%ebp)
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	8a 00                	mov    (%eax),%al
  800c06:	84 c0                	test   %al,%al
  800c08:	75 f1                	jne    800bfb <strlen+0xf>
		n++;
	return n;
  800c0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c0d:	c9                   	leave  
  800c0e:	c3                   	ret    

00800c0f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c0f:	55                   	push   %ebp
  800c10:	89 e5                	mov    %esp,%ebp
  800c12:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c15:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c1c:	eb 09                	jmp    800c27 <strnlen+0x18>
		n++;
  800c1e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c21:	ff 45 08             	incl   0x8(%ebp)
  800c24:	ff 4d 0c             	decl   0xc(%ebp)
  800c27:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c2b:	74 09                	je     800c36 <strnlen+0x27>
  800c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c30:	8a 00                	mov    (%eax),%al
  800c32:	84 c0                	test   %al,%al
  800c34:	75 e8                	jne    800c1e <strnlen+0xf>
		n++;
	return n;
  800c36:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c39:	c9                   	leave  
  800c3a:	c3                   	ret    

00800c3b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c3b:	55                   	push   %ebp
  800c3c:	89 e5                	mov    %esp,%ebp
  800c3e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c41:	8b 45 08             	mov    0x8(%ebp),%eax
  800c44:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c47:	90                   	nop
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	8d 50 01             	lea    0x1(%eax),%edx
  800c4e:	89 55 08             	mov    %edx,0x8(%ebp)
  800c51:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c54:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c57:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c5a:	8a 12                	mov    (%edx),%dl
  800c5c:	88 10                	mov    %dl,(%eax)
  800c5e:	8a 00                	mov    (%eax),%al
  800c60:	84 c0                	test   %al,%al
  800c62:	75 e4                	jne    800c48 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c64:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c67:	c9                   	leave  
  800c68:	c3                   	ret    

00800c69 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c69:	55                   	push   %ebp
  800c6a:	89 e5                	mov    %esp,%ebp
  800c6c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c72:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c75:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c7c:	eb 1f                	jmp    800c9d <strncpy+0x34>
		*dst++ = *src;
  800c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c81:	8d 50 01             	lea    0x1(%eax),%edx
  800c84:	89 55 08             	mov    %edx,0x8(%ebp)
  800c87:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c8a:	8a 12                	mov    (%edx),%dl
  800c8c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c91:	8a 00                	mov    (%eax),%al
  800c93:	84 c0                	test   %al,%al
  800c95:	74 03                	je     800c9a <strncpy+0x31>
			src++;
  800c97:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c9a:	ff 45 fc             	incl   -0x4(%ebp)
  800c9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ca0:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ca3:	72 d9                	jb     800c7e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ca5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ca8:	c9                   	leave  
  800ca9:	c3                   	ret    

00800caa <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800caa:	55                   	push   %ebp
  800cab:	89 e5                	mov    %esp,%ebp
  800cad:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cb6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cba:	74 30                	je     800cec <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cbc:	eb 16                	jmp    800cd4 <strlcpy+0x2a>
			*dst++ = *src++;
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	8d 50 01             	lea    0x1(%eax),%edx
  800cc4:	89 55 08             	mov    %edx,0x8(%ebp)
  800cc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cca:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ccd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cd0:	8a 12                	mov    (%edx),%dl
  800cd2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cd4:	ff 4d 10             	decl   0x10(%ebp)
  800cd7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cdb:	74 09                	je     800ce6 <strlcpy+0x3c>
  800cdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce0:	8a 00                	mov    (%eax),%al
  800ce2:	84 c0                	test   %al,%al
  800ce4:	75 d8                	jne    800cbe <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cec:	8b 55 08             	mov    0x8(%ebp),%edx
  800cef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf2:	29 c2                	sub    %eax,%edx
  800cf4:	89 d0                	mov    %edx,%eax
}
  800cf6:	c9                   	leave  
  800cf7:	c3                   	ret    

00800cf8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cf8:	55                   	push   %ebp
  800cf9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cfb:	eb 06                	jmp    800d03 <strcmp+0xb>
		p++, q++;
  800cfd:	ff 45 08             	incl   0x8(%ebp)
  800d00:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d03:	8b 45 08             	mov    0x8(%ebp),%eax
  800d06:	8a 00                	mov    (%eax),%al
  800d08:	84 c0                	test   %al,%al
  800d0a:	74 0e                	je     800d1a <strcmp+0x22>
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	8a 10                	mov    (%eax),%dl
  800d11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d14:	8a 00                	mov    (%eax),%al
  800d16:	38 c2                	cmp    %al,%dl
  800d18:	74 e3                	je     800cfd <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	8a 00                	mov    (%eax),%al
  800d1f:	0f b6 d0             	movzbl %al,%edx
  800d22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d25:	8a 00                	mov    (%eax),%al
  800d27:	0f b6 c0             	movzbl %al,%eax
  800d2a:	29 c2                	sub    %eax,%edx
  800d2c:	89 d0                	mov    %edx,%eax
}
  800d2e:	5d                   	pop    %ebp
  800d2f:	c3                   	ret    

00800d30 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d33:	eb 09                	jmp    800d3e <strncmp+0xe>
		n--, p++, q++;
  800d35:	ff 4d 10             	decl   0x10(%ebp)
  800d38:	ff 45 08             	incl   0x8(%ebp)
  800d3b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d3e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d42:	74 17                	je     800d5b <strncmp+0x2b>
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	8a 00                	mov    (%eax),%al
  800d49:	84 c0                	test   %al,%al
  800d4b:	74 0e                	je     800d5b <strncmp+0x2b>
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	8a 10                	mov    (%eax),%dl
  800d52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d55:	8a 00                	mov    (%eax),%al
  800d57:	38 c2                	cmp    %al,%dl
  800d59:	74 da                	je     800d35 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d5b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5f:	75 07                	jne    800d68 <strncmp+0x38>
		return 0;
  800d61:	b8 00 00 00 00       	mov    $0x0,%eax
  800d66:	eb 14                	jmp    800d7c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	8a 00                	mov    (%eax),%al
  800d6d:	0f b6 d0             	movzbl %al,%edx
  800d70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d73:	8a 00                	mov    (%eax),%al
  800d75:	0f b6 c0             	movzbl %al,%eax
  800d78:	29 c2                	sub    %eax,%edx
  800d7a:	89 d0                	mov    %edx,%eax
}
  800d7c:	5d                   	pop    %ebp
  800d7d:	c3                   	ret    

00800d7e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d7e:	55                   	push   %ebp
  800d7f:	89 e5                	mov    %esp,%ebp
  800d81:	83 ec 04             	sub    $0x4,%esp
  800d84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d87:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d8a:	eb 12                	jmp    800d9e <strchr+0x20>
		if (*s == c)
  800d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8f:	8a 00                	mov    (%eax),%al
  800d91:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d94:	75 05                	jne    800d9b <strchr+0x1d>
			return (char *) s;
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
  800d99:	eb 11                	jmp    800dac <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d9b:	ff 45 08             	incl   0x8(%ebp)
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	8a 00                	mov    (%eax),%al
  800da3:	84 c0                	test   %al,%al
  800da5:	75 e5                	jne    800d8c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800da7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dac:	c9                   	leave  
  800dad:	c3                   	ret    

00800dae <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dae:	55                   	push   %ebp
  800daf:	89 e5                	mov    %esp,%ebp
  800db1:	83 ec 04             	sub    $0x4,%esp
  800db4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dba:	eb 0d                	jmp    800dc9 <strfind+0x1b>
		if (*s == c)
  800dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbf:	8a 00                	mov    (%eax),%al
  800dc1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dc4:	74 0e                	je     800dd4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dc6:	ff 45 08             	incl   0x8(%ebp)
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcc:	8a 00                	mov    (%eax),%al
  800dce:	84 c0                	test   %al,%al
  800dd0:	75 ea                	jne    800dbc <strfind+0xe>
  800dd2:	eb 01                	jmp    800dd5 <strfind+0x27>
		if (*s == c)
			break;
  800dd4:	90                   	nop
	return (char *) s;
  800dd5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd8:	c9                   	leave  
  800dd9:	c3                   	ret    

00800dda <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800dda:	55                   	push   %ebp
  800ddb:	89 e5                	mov    %esp,%ebp
  800ddd:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800de6:	8b 45 10             	mov    0x10(%ebp),%eax
  800de9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dec:	eb 0e                	jmp    800dfc <memset+0x22>
		*p++ = c;
  800dee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df1:	8d 50 01             	lea    0x1(%eax),%edx
  800df4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800df7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dfa:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dfc:	ff 4d f8             	decl   -0x8(%ebp)
  800dff:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e03:	79 e9                	jns    800dee <memset+0x14>
		*p++ = c;

	return v;
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e08:	c9                   	leave  
  800e09:	c3                   	ret    

00800e0a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
  800e0d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e13:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e16:	8b 45 08             	mov    0x8(%ebp),%eax
  800e19:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e1c:	eb 16                	jmp    800e34 <memcpy+0x2a>
		*d++ = *s++;
  800e1e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e21:	8d 50 01             	lea    0x1(%eax),%edx
  800e24:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e27:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e2a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e2d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e30:	8a 12                	mov    (%edx),%dl
  800e32:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e34:	8b 45 10             	mov    0x10(%ebp),%eax
  800e37:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e3a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e3d:	85 c0                	test   %eax,%eax
  800e3f:	75 dd                	jne    800e1e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e44:	c9                   	leave  
  800e45:	c3                   	ret    

00800e46 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
  800e49:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e58:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e5b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e5e:	73 50                	jae    800eb0 <memmove+0x6a>
  800e60:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e63:	8b 45 10             	mov    0x10(%ebp),%eax
  800e66:	01 d0                	add    %edx,%eax
  800e68:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e6b:	76 43                	jbe    800eb0 <memmove+0x6a>
		s += n;
  800e6d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e70:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e73:	8b 45 10             	mov    0x10(%ebp),%eax
  800e76:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e79:	eb 10                	jmp    800e8b <memmove+0x45>
			*--d = *--s;
  800e7b:	ff 4d f8             	decl   -0x8(%ebp)
  800e7e:	ff 4d fc             	decl   -0x4(%ebp)
  800e81:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e84:	8a 10                	mov    (%eax),%dl
  800e86:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e89:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e91:	89 55 10             	mov    %edx,0x10(%ebp)
  800e94:	85 c0                	test   %eax,%eax
  800e96:	75 e3                	jne    800e7b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e98:	eb 23                	jmp    800ebd <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e9a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9d:	8d 50 01             	lea    0x1(%eax),%edx
  800ea0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ea3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ea6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ea9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800eac:	8a 12                	mov    (%edx),%dl
  800eae:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800eb0:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eb6:	89 55 10             	mov    %edx,0x10(%ebp)
  800eb9:	85 c0                	test   %eax,%eax
  800ebb:	75 dd                	jne    800e9a <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ebd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec0:	c9                   	leave  
  800ec1:	c3                   	ret    

00800ec2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ec2:	55                   	push   %ebp
  800ec3:	89 e5                	mov    %esp,%ebp
  800ec5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ece:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ed4:	eb 2a                	jmp    800f00 <memcmp+0x3e>
		if (*s1 != *s2)
  800ed6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed9:	8a 10                	mov    (%eax),%dl
  800edb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ede:	8a 00                	mov    (%eax),%al
  800ee0:	38 c2                	cmp    %al,%dl
  800ee2:	74 16                	je     800efa <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ee4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee7:	8a 00                	mov    (%eax),%al
  800ee9:	0f b6 d0             	movzbl %al,%edx
  800eec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eef:	8a 00                	mov    (%eax),%al
  800ef1:	0f b6 c0             	movzbl %al,%eax
  800ef4:	29 c2                	sub    %eax,%edx
  800ef6:	89 d0                	mov    %edx,%eax
  800ef8:	eb 18                	jmp    800f12 <memcmp+0x50>
		s1++, s2++;
  800efa:	ff 45 fc             	incl   -0x4(%ebp)
  800efd:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f00:	8b 45 10             	mov    0x10(%ebp),%eax
  800f03:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f06:	89 55 10             	mov    %edx,0x10(%ebp)
  800f09:	85 c0                	test   %eax,%eax
  800f0b:	75 c9                	jne    800ed6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f12:	c9                   	leave  
  800f13:	c3                   	ret    

00800f14 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f14:	55                   	push   %ebp
  800f15:	89 e5                	mov    %esp,%ebp
  800f17:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f20:	01 d0                	add    %edx,%eax
  800f22:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f25:	eb 15                	jmp    800f3c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	8a 00                	mov    (%eax),%al
  800f2c:	0f b6 d0             	movzbl %al,%edx
  800f2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f32:	0f b6 c0             	movzbl %al,%eax
  800f35:	39 c2                	cmp    %eax,%edx
  800f37:	74 0d                	je     800f46 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f39:	ff 45 08             	incl   0x8(%ebp)
  800f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f42:	72 e3                	jb     800f27 <memfind+0x13>
  800f44:	eb 01                	jmp    800f47 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f46:	90                   	nop
	return (void *) s;
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f4a:	c9                   	leave  
  800f4b:	c3                   	ret    

00800f4c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f4c:	55                   	push   %ebp
  800f4d:	89 e5                	mov    %esp,%ebp
  800f4f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f52:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f59:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f60:	eb 03                	jmp    800f65 <strtol+0x19>
		s++;
  800f62:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f65:	8b 45 08             	mov    0x8(%ebp),%eax
  800f68:	8a 00                	mov    (%eax),%al
  800f6a:	3c 20                	cmp    $0x20,%al
  800f6c:	74 f4                	je     800f62 <strtol+0x16>
  800f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f71:	8a 00                	mov    (%eax),%al
  800f73:	3c 09                	cmp    $0x9,%al
  800f75:	74 eb                	je     800f62 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	8a 00                	mov    (%eax),%al
  800f7c:	3c 2b                	cmp    $0x2b,%al
  800f7e:	75 05                	jne    800f85 <strtol+0x39>
		s++;
  800f80:	ff 45 08             	incl   0x8(%ebp)
  800f83:	eb 13                	jmp    800f98 <strtol+0x4c>
	else if (*s == '-')
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
  800f88:	8a 00                	mov    (%eax),%al
  800f8a:	3c 2d                	cmp    $0x2d,%al
  800f8c:	75 0a                	jne    800f98 <strtol+0x4c>
		s++, neg = 1;
  800f8e:	ff 45 08             	incl   0x8(%ebp)
  800f91:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f98:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9c:	74 06                	je     800fa4 <strtol+0x58>
  800f9e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fa2:	75 20                	jne    800fc4 <strtol+0x78>
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	3c 30                	cmp    $0x30,%al
  800fab:	75 17                	jne    800fc4 <strtol+0x78>
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	40                   	inc    %eax
  800fb1:	8a 00                	mov    (%eax),%al
  800fb3:	3c 78                	cmp    $0x78,%al
  800fb5:	75 0d                	jne    800fc4 <strtol+0x78>
		s += 2, base = 16;
  800fb7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fbb:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fc2:	eb 28                	jmp    800fec <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fc4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc8:	75 15                	jne    800fdf <strtol+0x93>
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	8a 00                	mov    (%eax),%al
  800fcf:	3c 30                	cmp    $0x30,%al
  800fd1:	75 0c                	jne    800fdf <strtol+0x93>
		s++, base = 8;
  800fd3:	ff 45 08             	incl   0x8(%ebp)
  800fd6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fdd:	eb 0d                	jmp    800fec <strtol+0xa0>
	else if (base == 0)
  800fdf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fe3:	75 07                	jne    800fec <strtol+0xa0>
		base = 10;
  800fe5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fec:	8b 45 08             	mov    0x8(%ebp),%eax
  800fef:	8a 00                	mov    (%eax),%al
  800ff1:	3c 2f                	cmp    $0x2f,%al
  800ff3:	7e 19                	jle    80100e <strtol+0xc2>
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff8:	8a 00                	mov    (%eax),%al
  800ffa:	3c 39                	cmp    $0x39,%al
  800ffc:	7f 10                	jg     80100e <strtol+0xc2>
			dig = *s - '0';
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	8a 00                	mov    (%eax),%al
  801003:	0f be c0             	movsbl %al,%eax
  801006:	83 e8 30             	sub    $0x30,%eax
  801009:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80100c:	eb 42                	jmp    801050 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	8a 00                	mov    (%eax),%al
  801013:	3c 60                	cmp    $0x60,%al
  801015:	7e 19                	jle    801030 <strtol+0xe4>
  801017:	8b 45 08             	mov    0x8(%ebp),%eax
  80101a:	8a 00                	mov    (%eax),%al
  80101c:	3c 7a                	cmp    $0x7a,%al
  80101e:	7f 10                	jg     801030 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801020:	8b 45 08             	mov    0x8(%ebp),%eax
  801023:	8a 00                	mov    (%eax),%al
  801025:	0f be c0             	movsbl %al,%eax
  801028:	83 e8 57             	sub    $0x57,%eax
  80102b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80102e:	eb 20                	jmp    801050 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801030:	8b 45 08             	mov    0x8(%ebp),%eax
  801033:	8a 00                	mov    (%eax),%al
  801035:	3c 40                	cmp    $0x40,%al
  801037:	7e 39                	jle    801072 <strtol+0x126>
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
  80103c:	8a 00                	mov    (%eax),%al
  80103e:	3c 5a                	cmp    $0x5a,%al
  801040:	7f 30                	jg     801072 <strtol+0x126>
			dig = *s - 'A' + 10;
  801042:	8b 45 08             	mov    0x8(%ebp),%eax
  801045:	8a 00                	mov    (%eax),%al
  801047:	0f be c0             	movsbl %al,%eax
  80104a:	83 e8 37             	sub    $0x37,%eax
  80104d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801050:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801053:	3b 45 10             	cmp    0x10(%ebp),%eax
  801056:	7d 19                	jge    801071 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801058:	ff 45 08             	incl   0x8(%ebp)
  80105b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801062:	89 c2                	mov    %eax,%edx
  801064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801067:	01 d0                	add    %edx,%eax
  801069:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80106c:	e9 7b ff ff ff       	jmp    800fec <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801071:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801072:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801076:	74 08                	je     801080 <strtol+0x134>
		*endptr = (char *) s;
  801078:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107b:	8b 55 08             	mov    0x8(%ebp),%edx
  80107e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801080:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801084:	74 07                	je     80108d <strtol+0x141>
  801086:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801089:	f7 d8                	neg    %eax
  80108b:	eb 03                	jmp    801090 <strtol+0x144>
  80108d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801090:	c9                   	leave  
  801091:	c3                   	ret    

00801092 <ltostr>:

void
ltostr(long value, char *str)
{
  801092:	55                   	push   %ebp
  801093:	89 e5                	mov    %esp,%ebp
  801095:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801098:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80109f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010aa:	79 13                	jns    8010bf <ltostr+0x2d>
	{
		neg = 1;
  8010ac:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010b9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010bc:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010c7:	99                   	cltd   
  8010c8:	f7 f9                	idiv   %ecx
  8010ca:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d0:	8d 50 01             	lea    0x1(%eax),%edx
  8010d3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010d6:	89 c2                	mov    %eax,%edx
  8010d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010db:	01 d0                	add    %edx,%eax
  8010dd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010e0:	83 c2 30             	add    $0x30,%edx
  8010e3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010e8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010ed:	f7 e9                	imul   %ecx
  8010ef:	c1 fa 02             	sar    $0x2,%edx
  8010f2:	89 c8                	mov    %ecx,%eax
  8010f4:	c1 f8 1f             	sar    $0x1f,%eax
  8010f7:	29 c2                	sub    %eax,%edx
  8010f9:	89 d0                	mov    %edx,%eax
  8010fb:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801101:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801106:	f7 e9                	imul   %ecx
  801108:	c1 fa 02             	sar    $0x2,%edx
  80110b:	89 c8                	mov    %ecx,%eax
  80110d:	c1 f8 1f             	sar    $0x1f,%eax
  801110:	29 c2                	sub    %eax,%edx
  801112:	89 d0                	mov    %edx,%eax
  801114:	c1 e0 02             	shl    $0x2,%eax
  801117:	01 d0                	add    %edx,%eax
  801119:	01 c0                	add    %eax,%eax
  80111b:	29 c1                	sub    %eax,%ecx
  80111d:	89 ca                	mov    %ecx,%edx
  80111f:	85 d2                	test   %edx,%edx
  801121:	75 9c                	jne    8010bf <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801123:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80112a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80112d:	48                   	dec    %eax
  80112e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801131:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801135:	74 3d                	je     801174 <ltostr+0xe2>
		start = 1 ;
  801137:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80113e:	eb 34                	jmp    801174 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801140:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801143:	8b 45 0c             	mov    0xc(%ebp),%eax
  801146:	01 d0                	add    %edx,%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80114d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801150:	8b 45 0c             	mov    0xc(%ebp),%eax
  801153:	01 c2                	add    %eax,%edx
  801155:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801158:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115b:	01 c8                	add    %ecx,%eax
  80115d:	8a 00                	mov    (%eax),%al
  80115f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801161:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801164:	8b 45 0c             	mov    0xc(%ebp),%eax
  801167:	01 c2                	add    %eax,%edx
  801169:	8a 45 eb             	mov    -0x15(%ebp),%al
  80116c:	88 02                	mov    %al,(%edx)
		start++ ;
  80116e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801171:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801174:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801177:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80117a:	7c c4                	jl     801140 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80117c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80117f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801182:	01 d0                	add    %edx,%eax
  801184:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801187:	90                   	nop
  801188:	c9                   	leave  
  801189:	c3                   	ret    

0080118a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80118a:	55                   	push   %ebp
  80118b:	89 e5                	mov    %esp,%ebp
  80118d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801190:	ff 75 08             	pushl  0x8(%ebp)
  801193:	e8 54 fa ff ff       	call   800bec <strlen>
  801198:	83 c4 04             	add    $0x4,%esp
  80119b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80119e:	ff 75 0c             	pushl  0xc(%ebp)
  8011a1:	e8 46 fa ff ff       	call   800bec <strlen>
  8011a6:	83 c4 04             	add    $0x4,%esp
  8011a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011ba:	eb 17                	jmp    8011d3 <strcconcat+0x49>
		final[s] = str1[s] ;
  8011bc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c2:	01 c2                	add    %eax,%edx
  8011c4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ca:	01 c8                	add    %ecx,%eax
  8011cc:	8a 00                	mov    (%eax),%al
  8011ce:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011d0:	ff 45 fc             	incl   -0x4(%ebp)
  8011d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011d9:	7c e1                	jl     8011bc <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011db:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011e2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011e9:	eb 1f                	jmp    80120a <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ee:	8d 50 01             	lea    0x1(%eax),%edx
  8011f1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011f4:	89 c2                	mov    %eax,%edx
  8011f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f9:	01 c2                	add    %eax,%edx
  8011fb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801201:	01 c8                	add    %ecx,%eax
  801203:	8a 00                	mov    (%eax),%al
  801205:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801207:	ff 45 f8             	incl   -0x8(%ebp)
  80120a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80120d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801210:	7c d9                	jl     8011eb <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801212:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801215:	8b 45 10             	mov    0x10(%ebp),%eax
  801218:	01 d0                	add    %edx,%eax
  80121a:	c6 00 00             	movb   $0x0,(%eax)
}
  80121d:	90                   	nop
  80121e:	c9                   	leave  
  80121f:	c3                   	ret    

00801220 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801223:	8b 45 14             	mov    0x14(%ebp),%eax
  801226:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80122c:	8b 45 14             	mov    0x14(%ebp),%eax
  80122f:	8b 00                	mov    (%eax),%eax
  801231:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801238:	8b 45 10             	mov    0x10(%ebp),%eax
  80123b:	01 d0                	add    %edx,%eax
  80123d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801243:	eb 0c                	jmp    801251 <strsplit+0x31>
			*string++ = 0;
  801245:	8b 45 08             	mov    0x8(%ebp),%eax
  801248:	8d 50 01             	lea    0x1(%eax),%edx
  80124b:	89 55 08             	mov    %edx,0x8(%ebp)
  80124e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801251:	8b 45 08             	mov    0x8(%ebp),%eax
  801254:	8a 00                	mov    (%eax),%al
  801256:	84 c0                	test   %al,%al
  801258:	74 18                	je     801272 <strsplit+0x52>
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
  80125d:	8a 00                	mov    (%eax),%al
  80125f:	0f be c0             	movsbl %al,%eax
  801262:	50                   	push   %eax
  801263:	ff 75 0c             	pushl  0xc(%ebp)
  801266:	e8 13 fb ff ff       	call   800d7e <strchr>
  80126b:	83 c4 08             	add    $0x8,%esp
  80126e:	85 c0                	test   %eax,%eax
  801270:	75 d3                	jne    801245 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801272:	8b 45 08             	mov    0x8(%ebp),%eax
  801275:	8a 00                	mov    (%eax),%al
  801277:	84 c0                	test   %al,%al
  801279:	74 5a                	je     8012d5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80127b:	8b 45 14             	mov    0x14(%ebp),%eax
  80127e:	8b 00                	mov    (%eax),%eax
  801280:	83 f8 0f             	cmp    $0xf,%eax
  801283:	75 07                	jne    80128c <strsplit+0x6c>
		{
			return 0;
  801285:	b8 00 00 00 00       	mov    $0x0,%eax
  80128a:	eb 66                	jmp    8012f2 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80128c:	8b 45 14             	mov    0x14(%ebp),%eax
  80128f:	8b 00                	mov    (%eax),%eax
  801291:	8d 48 01             	lea    0x1(%eax),%ecx
  801294:	8b 55 14             	mov    0x14(%ebp),%edx
  801297:	89 0a                	mov    %ecx,(%edx)
  801299:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a3:	01 c2                	add    %eax,%edx
  8012a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a8:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012aa:	eb 03                	jmp    8012af <strsplit+0x8f>
			string++;
  8012ac:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012af:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b2:	8a 00                	mov    (%eax),%al
  8012b4:	84 c0                	test   %al,%al
  8012b6:	74 8b                	je     801243 <strsplit+0x23>
  8012b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bb:	8a 00                	mov    (%eax),%al
  8012bd:	0f be c0             	movsbl %al,%eax
  8012c0:	50                   	push   %eax
  8012c1:	ff 75 0c             	pushl  0xc(%ebp)
  8012c4:	e8 b5 fa ff ff       	call   800d7e <strchr>
  8012c9:	83 c4 08             	add    $0x8,%esp
  8012cc:	85 c0                	test   %eax,%eax
  8012ce:	74 dc                	je     8012ac <strsplit+0x8c>
			string++;
	}
  8012d0:	e9 6e ff ff ff       	jmp    801243 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012d5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d9:	8b 00                	mov    (%eax),%eax
  8012db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e5:	01 d0                	add    %edx,%eax
  8012e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012ed:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012f2:	c9                   	leave  
  8012f3:	c3                   	ret    

008012f4 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012f4:	55                   	push   %ebp
  8012f5:	89 e5                	mov    %esp,%ebp
  8012f7:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012fa:	a1 04 40 80 00       	mov    0x804004,%eax
  8012ff:	85 c0                	test   %eax,%eax
  801301:	74 1f                	je     801322 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801303:	e8 1d 00 00 00       	call   801325 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801308:	83 ec 0c             	sub    $0xc,%esp
  80130b:	68 30 3a 80 00       	push   $0x803a30
  801310:	e8 55 f2 ff ff       	call   80056a <cprintf>
  801315:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801318:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80131f:	00 00 00 
	}
}
  801322:	90                   	nop
  801323:	c9                   	leave  
  801324:	c3                   	ret    

00801325 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801325:	55                   	push   %ebp
  801326:	89 e5                	mov    %esp,%ebp
  801328:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  80132b:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801332:	00 00 00 
  801335:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80133c:	00 00 00 
  80133f:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801346:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  801349:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801350:	00 00 00 
  801353:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80135a:	00 00 00 
  80135d:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801364:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  801367:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80136e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801371:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801376:	2d 00 10 00 00       	sub    $0x1000,%eax
  80137b:	a3 50 40 80 00       	mov    %eax,0x804050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801380:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801387:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  80138a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801391:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801394:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  801399:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80139c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80139f:	ba 00 00 00 00       	mov    $0x0,%edx
  8013a4:	f7 75 f0             	divl   -0x10(%ebp)
  8013a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013aa:	29 d0                	sub    %edx,%eax
  8013ac:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  8013af:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8013b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013b9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013be:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013c3:	83 ec 04             	sub    $0x4,%esp
  8013c6:	6a 06                	push   $0x6
  8013c8:	ff 75 e8             	pushl  -0x18(%ebp)
  8013cb:	50                   	push   %eax
  8013cc:	e8 d4 05 00 00       	call   8019a5 <sys_allocate_chunk>
  8013d1:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013d4:	a1 20 41 80 00       	mov    0x804120,%eax
  8013d9:	83 ec 0c             	sub    $0xc,%esp
  8013dc:	50                   	push   %eax
  8013dd:	e8 49 0c 00 00       	call   80202b <initialize_MemBlocksList>
  8013e2:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  8013e5:	a1 48 41 80 00       	mov    0x804148,%eax
  8013ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  8013ed:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013f1:	75 14                	jne    801407 <initialize_dyn_block_system+0xe2>
  8013f3:	83 ec 04             	sub    $0x4,%esp
  8013f6:	68 55 3a 80 00       	push   $0x803a55
  8013fb:	6a 39                	push   $0x39
  8013fd:	68 73 3a 80 00       	push   $0x803a73
  801402:	e8 af ee ff ff       	call   8002b6 <_panic>
  801407:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80140a:	8b 00                	mov    (%eax),%eax
  80140c:	85 c0                	test   %eax,%eax
  80140e:	74 10                	je     801420 <initialize_dyn_block_system+0xfb>
  801410:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801413:	8b 00                	mov    (%eax),%eax
  801415:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801418:	8b 52 04             	mov    0x4(%edx),%edx
  80141b:	89 50 04             	mov    %edx,0x4(%eax)
  80141e:	eb 0b                	jmp    80142b <initialize_dyn_block_system+0x106>
  801420:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801423:	8b 40 04             	mov    0x4(%eax),%eax
  801426:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80142b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80142e:	8b 40 04             	mov    0x4(%eax),%eax
  801431:	85 c0                	test   %eax,%eax
  801433:	74 0f                	je     801444 <initialize_dyn_block_system+0x11f>
  801435:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801438:	8b 40 04             	mov    0x4(%eax),%eax
  80143b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80143e:	8b 12                	mov    (%edx),%edx
  801440:	89 10                	mov    %edx,(%eax)
  801442:	eb 0a                	jmp    80144e <initialize_dyn_block_system+0x129>
  801444:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801447:	8b 00                	mov    (%eax),%eax
  801449:	a3 48 41 80 00       	mov    %eax,0x804148
  80144e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801451:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801457:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80145a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801461:	a1 54 41 80 00       	mov    0x804154,%eax
  801466:	48                   	dec    %eax
  801467:	a3 54 41 80 00       	mov    %eax,0x804154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  80146c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80146f:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  801476:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801479:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  801480:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801484:	75 14                	jne    80149a <initialize_dyn_block_system+0x175>
  801486:	83 ec 04             	sub    $0x4,%esp
  801489:	68 80 3a 80 00       	push   $0x803a80
  80148e:	6a 3f                	push   $0x3f
  801490:	68 73 3a 80 00       	push   $0x803a73
  801495:	e8 1c ee ff ff       	call   8002b6 <_panic>
  80149a:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8014a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014a3:	89 10                	mov    %edx,(%eax)
  8014a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014a8:	8b 00                	mov    (%eax),%eax
  8014aa:	85 c0                	test   %eax,%eax
  8014ac:	74 0d                	je     8014bb <initialize_dyn_block_system+0x196>
  8014ae:	a1 38 41 80 00       	mov    0x804138,%eax
  8014b3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014b6:	89 50 04             	mov    %edx,0x4(%eax)
  8014b9:	eb 08                	jmp    8014c3 <initialize_dyn_block_system+0x19e>
  8014bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014be:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8014c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014c6:	a3 38 41 80 00       	mov    %eax,0x804138
  8014cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014d5:	a1 44 41 80 00       	mov    0x804144,%eax
  8014da:	40                   	inc    %eax
  8014db:	a3 44 41 80 00       	mov    %eax,0x804144

}
  8014e0:	90                   	nop
  8014e1:	c9                   	leave  
  8014e2:	c3                   	ret    

008014e3 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8014e3:	55                   	push   %ebp
  8014e4:	89 e5                	mov    %esp,%ebp
  8014e6:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014e9:	e8 06 fe ff ff       	call   8012f4 <InitializeUHeap>
	if (size == 0) return NULL ;
  8014ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014f2:	75 07                	jne    8014fb <malloc+0x18>
  8014f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8014f9:	eb 7d                	jmp    801578 <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  8014fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801502:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801509:	8b 55 08             	mov    0x8(%ebp),%edx
  80150c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80150f:	01 d0                	add    %edx,%eax
  801511:	48                   	dec    %eax
  801512:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801515:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801518:	ba 00 00 00 00       	mov    $0x0,%edx
  80151d:	f7 75 f0             	divl   -0x10(%ebp)
  801520:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801523:	29 d0                	sub    %edx,%eax
  801525:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  801528:	e8 46 08 00 00       	call   801d73 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80152d:	83 f8 01             	cmp    $0x1,%eax
  801530:	75 07                	jne    801539 <malloc+0x56>
  801532:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  801539:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  80153d:	75 34                	jne    801573 <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  80153f:	83 ec 0c             	sub    $0xc,%esp
  801542:	ff 75 e8             	pushl  -0x18(%ebp)
  801545:	e8 73 0e 00 00       	call   8023bd <alloc_block_FF>
  80154a:	83 c4 10             	add    $0x10,%esp
  80154d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  801550:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801554:	74 16                	je     80156c <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  801556:	83 ec 0c             	sub    $0xc,%esp
  801559:	ff 75 e4             	pushl  -0x1c(%ebp)
  80155c:	e8 ff 0b 00 00       	call   802160 <insert_sorted_allocList>
  801561:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  801564:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801567:	8b 40 08             	mov    0x8(%eax),%eax
  80156a:	eb 0c                	jmp    801578 <malloc+0x95>
	             }
	             else
	             	return NULL;
  80156c:	b8 00 00 00 00       	mov    $0x0,%eax
  801571:	eb 05                	jmp    801578 <malloc+0x95>
	      	  }
	          else
	               return NULL;
  801573:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  801578:	c9                   	leave  
  801579:	c3                   	ret    

0080157a <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80157a:	55                   	push   %ebp
  80157b:	89 e5                	mov    %esp,%ebp
  80157d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  801580:	8b 45 08             	mov    0x8(%ebp),%eax
  801583:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  801586:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801589:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80158c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80158f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801594:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  801597:	83 ec 08             	sub    $0x8,%esp
  80159a:	ff 75 f4             	pushl  -0xc(%ebp)
  80159d:	68 40 40 80 00       	push   $0x804040
  8015a2:	e8 61 0b 00 00       	call   802108 <find_block>
  8015a7:	83 c4 10             	add    $0x10,%esp
  8015aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  8015ad:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015b1:	0f 84 a5 00 00 00    	je     80165c <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  8015b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8015bd:	83 ec 08             	sub    $0x8,%esp
  8015c0:	50                   	push   %eax
  8015c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8015c4:	e8 a4 03 00 00       	call   80196d <sys_free_user_mem>
  8015c9:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  8015cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015d0:	75 17                	jne    8015e9 <free+0x6f>
  8015d2:	83 ec 04             	sub    $0x4,%esp
  8015d5:	68 55 3a 80 00       	push   $0x803a55
  8015da:	68 87 00 00 00       	push   $0x87
  8015df:	68 73 3a 80 00       	push   $0x803a73
  8015e4:	e8 cd ec ff ff       	call   8002b6 <_panic>
  8015e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ec:	8b 00                	mov    (%eax),%eax
  8015ee:	85 c0                	test   %eax,%eax
  8015f0:	74 10                	je     801602 <free+0x88>
  8015f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015f5:	8b 00                	mov    (%eax),%eax
  8015f7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015fa:	8b 52 04             	mov    0x4(%edx),%edx
  8015fd:	89 50 04             	mov    %edx,0x4(%eax)
  801600:	eb 0b                	jmp    80160d <free+0x93>
  801602:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801605:	8b 40 04             	mov    0x4(%eax),%eax
  801608:	a3 44 40 80 00       	mov    %eax,0x804044
  80160d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801610:	8b 40 04             	mov    0x4(%eax),%eax
  801613:	85 c0                	test   %eax,%eax
  801615:	74 0f                	je     801626 <free+0xac>
  801617:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80161a:	8b 40 04             	mov    0x4(%eax),%eax
  80161d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801620:	8b 12                	mov    (%edx),%edx
  801622:	89 10                	mov    %edx,(%eax)
  801624:	eb 0a                	jmp    801630 <free+0xb6>
  801626:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801629:	8b 00                	mov    (%eax),%eax
  80162b:	a3 40 40 80 00       	mov    %eax,0x804040
  801630:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801633:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801639:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80163c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801643:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801648:	48                   	dec    %eax
  801649:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(theBlock);
  80164e:	83 ec 0c             	sub    $0xc,%esp
  801651:	ff 75 ec             	pushl  -0x14(%ebp)
  801654:	e8 37 12 00 00       	call   802890 <insert_sorted_with_merge_freeList>
  801659:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  80165c:	90                   	nop
  80165d:	c9                   	leave  
  80165e:	c3                   	ret    

0080165f <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80165f:	55                   	push   %ebp
  801660:	89 e5                	mov    %esp,%ebp
  801662:	83 ec 38             	sub    $0x38,%esp
  801665:	8b 45 10             	mov    0x10(%ebp),%eax
  801668:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80166b:	e8 84 fc ff ff       	call   8012f4 <InitializeUHeap>
	if (size == 0) return NULL ;
  801670:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801674:	75 07                	jne    80167d <smalloc+0x1e>
  801676:	b8 00 00 00 00       	mov    $0x0,%eax
  80167b:	eb 7e                	jmp    8016fb <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  80167d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801684:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80168b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80168e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801691:	01 d0                	add    %edx,%eax
  801693:	48                   	dec    %eax
  801694:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801697:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80169a:	ba 00 00 00 00       	mov    $0x0,%edx
  80169f:	f7 75 f0             	divl   -0x10(%ebp)
  8016a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016a5:	29 d0                	sub    %edx,%eax
  8016a7:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  8016aa:	e8 c4 06 00 00       	call   801d73 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016af:	83 f8 01             	cmp    $0x1,%eax
  8016b2:	75 42                	jne    8016f6 <smalloc+0x97>

		  va = malloc(newsize) ;
  8016b4:	83 ec 0c             	sub    $0xc,%esp
  8016b7:	ff 75 e8             	pushl  -0x18(%ebp)
  8016ba:	e8 24 fe ff ff       	call   8014e3 <malloc>
  8016bf:	83 c4 10             	add    $0x10,%esp
  8016c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  8016c5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8016c9:	74 24                	je     8016ef <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  8016cb:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8016cf:	ff 75 e4             	pushl  -0x1c(%ebp)
  8016d2:	50                   	push   %eax
  8016d3:	ff 75 e8             	pushl  -0x18(%ebp)
  8016d6:	ff 75 08             	pushl  0x8(%ebp)
  8016d9:	e8 1a 04 00 00       	call   801af8 <sys_createSharedObject>
  8016de:	83 c4 10             	add    $0x10,%esp
  8016e1:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  8016e4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8016e8:	78 0c                	js     8016f6 <smalloc+0x97>
					  return va ;
  8016ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016ed:	eb 0c                	jmp    8016fb <smalloc+0x9c>
				 }
				 else
					return NULL;
  8016ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f4:	eb 05                	jmp    8016fb <smalloc+0x9c>
	  }
		  return NULL ;
  8016f6:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016fb:	c9                   	leave  
  8016fc:	c3                   	ret    

008016fd <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016fd:	55                   	push   %ebp
  8016fe:	89 e5                	mov    %esp,%ebp
  801700:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801703:	e8 ec fb ff ff       	call   8012f4 <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  801708:	83 ec 08             	sub    $0x8,%esp
  80170b:	ff 75 0c             	pushl  0xc(%ebp)
  80170e:	ff 75 08             	pushl  0x8(%ebp)
  801711:	e8 0c 04 00 00       	call   801b22 <sys_getSizeOfSharedObject>
  801716:	83 c4 10             	add    $0x10,%esp
  801719:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  80171c:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801720:	75 07                	jne    801729 <sget+0x2c>
  801722:	b8 00 00 00 00       	mov    $0x0,%eax
  801727:	eb 75                	jmp    80179e <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801729:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801730:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801733:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801736:	01 d0                	add    %edx,%eax
  801738:	48                   	dec    %eax
  801739:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80173c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80173f:	ba 00 00 00 00       	mov    $0x0,%edx
  801744:	f7 75 f0             	divl   -0x10(%ebp)
  801747:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80174a:	29 d0                	sub    %edx,%eax
  80174c:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  80174f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801756:	e8 18 06 00 00       	call   801d73 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80175b:	83 f8 01             	cmp    $0x1,%eax
  80175e:	75 39                	jne    801799 <sget+0x9c>

		  va = malloc(newsize) ;
  801760:	83 ec 0c             	sub    $0xc,%esp
  801763:	ff 75 e8             	pushl  -0x18(%ebp)
  801766:	e8 78 fd ff ff       	call   8014e3 <malloc>
  80176b:	83 c4 10             	add    $0x10,%esp
  80176e:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  801771:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801775:	74 22                	je     801799 <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  801777:	83 ec 04             	sub    $0x4,%esp
  80177a:	ff 75 e0             	pushl  -0x20(%ebp)
  80177d:	ff 75 0c             	pushl  0xc(%ebp)
  801780:	ff 75 08             	pushl  0x8(%ebp)
  801783:	e8 b7 03 00 00       	call   801b3f <sys_getSharedObject>
  801788:	83 c4 10             	add    $0x10,%esp
  80178b:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  80178e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801792:	78 05                	js     801799 <sget+0x9c>
					  return va;
  801794:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801797:	eb 05                	jmp    80179e <sget+0xa1>
				  }
			  }
     }
         return NULL;
  801799:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  80179e:	c9                   	leave  
  80179f:	c3                   	ret    

008017a0 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
  8017a3:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017a6:	e8 49 fb ff ff       	call   8012f4 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017ab:	83 ec 04             	sub    $0x4,%esp
  8017ae:	68 a4 3a 80 00       	push   $0x803aa4
  8017b3:	68 1e 01 00 00       	push   $0x11e
  8017b8:	68 73 3a 80 00       	push   $0x803a73
  8017bd:	e8 f4 ea ff ff       	call   8002b6 <_panic>

008017c2 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
  8017c5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017c8:	83 ec 04             	sub    $0x4,%esp
  8017cb:	68 cc 3a 80 00       	push   $0x803acc
  8017d0:	68 32 01 00 00       	push   $0x132
  8017d5:	68 73 3a 80 00       	push   $0x803a73
  8017da:	e8 d7 ea ff ff       	call   8002b6 <_panic>

008017df <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017df:	55                   	push   %ebp
  8017e0:	89 e5                	mov    %esp,%ebp
  8017e2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017e5:	83 ec 04             	sub    $0x4,%esp
  8017e8:	68 f0 3a 80 00       	push   $0x803af0
  8017ed:	68 3d 01 00 00       	push   $0x13d
  8017f2:	68 73 3a 80 00       	push   $0x803a73
  8017f7:	e8 ba ea ff ff       	call   8002b6 <_panic>

008017fc <shrink>:

}
void shrink(uint32 newSize)
{
  8017fc:	55                   	push   %ebp
  8017fd:	89 e5                	mov    %esp,%ebp
  8017ff:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801802:	83 ec 04             	sub    $0x4,%esp
  801805:	68 f0 3a 80 00       	push   $0x803af0
  80180a:	68 42 01 00 00       	push   $0x142
  80180f:	68 73 3a 80 00       	push   $0x803a73
  801814:	e8 9d ea ff ff       	call   8002b6 <_panic>

00801819 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801819:	55                   	push   %ebp
  80181a:	89 e5                	mov    %esp,%ebp
  80181c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80181f:	83 ec 04             	sub    $0x4,%esp
  801822:	68 f0 3a 80 00       	push   $0x803af0
  801827:	68 47 01 00 00       	push   $0x147
  80182c:	68 73 3a 80 00       	push   $0x803a73
  801831:	e8 80 ea ff ff       	call   8002b6 <_panic>

00801836 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801836:	55                   	push   %ebp
  801837:	89 e5                	mov    %esp,%ebp
  801839:	57                   	push   %edi
  80183a:	56                   	push   %esi
  80183b:	53                   	push   %ebx
  80183c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80183f:	8b 45 08             	mov    0x8(%ebp),%eax
  801842:	8b 55 0c             	mov    0xc(%ebp),%edx
  801845:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801848:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80184b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80184e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801851:	cd 30                	int    $0x30
  801853:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801856:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801859:	83 c4 10             	add    $0x10,%esp
  80185c:	5b                   	pop    %ebx
  80185d:	5e                   	pop    %esi
  80185e:	5f                   	pop    %edi
  80185f:	5d                   	pop    %ebp
  801860:	c3                   	ret    

00801861 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
  801864:	83 ec 04             	sub    $0x4,%esp
  801867:	8b 45 10             	mov    0x10(%ebp),%eax
  80186a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80186d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801871:	8b 45 08             	mov    0x8(%ebp),%eax
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	52                   	push   %edx
  801879:	ff 75 0c             	pushl  0xc(%ebp)
  80187c:	50                   	push   %eax
  80187d:	6a 00                	push   $0x0
  80187f:	e8 b2 ff ff ff       	call   801836 <syscall>
  801884:	83 c4 18             	add    $0x18,%esp
}
  801887:	90                   	nop
  801888:	c9                   	leave  
  801889:	c3                   	ret    

0080188a <sys_cgetc>:

int
sys_cgetc(void)
{
  80188a:	55                   	push   %ebp
  80188b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 01                	push   $0x1
  801899:	e8 98 ff ff ff       	call   801836 <syscall>
  80189e:	83 c4 18             	add    $0x18,%esp
}
  8018a1:	c9                   	leave  
  8018a2:	c3                   	ret    

008018a3 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018a3:	55                   	push   %ebp
  8018a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	52                   	push   %edx
  8018b3:	50                   	push   %eax
  8018b4:	6a 05                	push   $0x5
  8018b6:	e8 7b ff ff ff       	call   801836 <syscall>
  8018bb:	83 c4 18             	add    $0x18,%esp
}
  8018be:	c9                   	leave  
  8018bf:	c3                   	ret    

008018c0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
  8018c3:	56                   	push   %esi
  8018c4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018c5:	8b 75 18             	mov    0x18(%ebp),%esi
  8018c8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d4:	56                   	push   %esi
  8018d5:	53                   	push   %ebx
  8018d6:	51                   	push   %ecx
  8018d7:	52                   	push   %edx
  8018d8:	50                   	push   %eax
  8018d9:	6a 06                	push   $0x6
  8018db:	e8 56 ff ff ff       	call   801836 <syscall>
  8018e0:	83 c4 18             	add    $0x18,%esp
}
  8018e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018e6:	5b                   	pop    %ebx
  8018e7:	5e                   	pop    %esi
  8018e8:	5d                   	pop    %ebp
  8018e9:	c3                   	ret    

008018ea <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	52                   	push   %edx
  8018fa:	50                   	push   %eax
  8018fb:	6a 07                	push   $0x7
  8018fd:	e8 34 ff ff ff       	call   801836 <syscall>
  801902:	83 c4 18             	add    $0x18,%esp
}
  801905:	c9                   	leave  
  801906:	c3                   	ret    

00801907 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801907:	55                   	push   %ebp
  801908:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	ff 75 0c             	pushl  0xc(%ebp)
  801913:	ff 75 08             	pushl  0x8(%ebp)
  801916:	6a 08                	push   $0x8
  801918:	e8 19 ff ff ff       	call   801836 <syscall>
  80191d:	83 c4 18             	add    $0x18,%esp
}
  801920:	c9                   	leave  
  801921:	c3                   	ret    

00801922 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801922:	55                   	push   %ebp
  801923:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 09                	push   $0x9
  801931:	e8 00 ff ff ff       	call   801836 <syscall>
  801936:	83 c4 18             	add    $0x18,%esp
}
  801939:	c9                   	leave  
  80193a:	c3                   	ret    

0080193b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 0a                	push   $0xa
  80194a:	e8 e7 fe ff ff       	call   801836 <syscall>
  80194f:	83 c4 18             	add    $0x18,%esp
}
  801952:	c9                   	leave  
  801953:	c3                   	ret    

00801954 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801954:	55                   	push   %ebp
  801955:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 0b                	push   $0xb
  801963:	e8 ce fe ff ff       	call   801836 <syscall>
  801968:	83 c4 18             	add    $0x18,%esp
}
  80196b:	c9                   	leave  
  80196c:	c3                   	ret    

0080196d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80196d:	55                   	push   %ebp
  80196e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	ff 75 0c             	pushl  0xc(%ebp)
  801979:	ff 75 08             	pushl  0x8(%ebp)
  80197c:	6a 0f                	push   $0xf
  80197e:	e8 b3 fe ff ff       	call   801836 <syscall>
  801983:	83 c4 18             	add    $0x18,%esp
	return;
  801986:	90                   	nop
}
  801987:	c9                   	leave  
  801988:	c3                   	ret    

00801989 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	ff 75 0c             	pushl  0xc(%ebp)
  801995:	ff 75 08             	pushl  0x8(%ebp)
  801998:	6a 10                	push   $0x10
  80199a:	e8 97 fe ff ff       	call   801836 <syscall>
  80199f:	83 c4 18             	add    $0x18,%esp
	return ;
  8019a2:	90                   	nop
}
  8019a3:	c9                   	leave  
  8019a4:	c3                   	ret    

008019a5 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019a5:	55                   	push   %ebp
  8019a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	ff 75 10             	pushl  0x10(%ebp)
  8019af:	ff 75 0c             	pushl  0xc(%ebp)
  8019b2:	ff 75 08             	pushl  0x8(%ebp)
  8019b5:	6a 11                	push   $0x11
  8019b7:	e8 7a fe ff ff       	call   801836 <syscall>
  8019bc:	83 c4 18             	add    $0x18,%esp
	return ;
  8019bf:	90                   	nop
}
  8019c0:	c9                   	leave  
  8019c1:	c3                   	ret    

008019c2 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019c2:	55                   	push   %ebp
  8019c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 0c                	push   $0xc
  8019d1:	e8 60 fe ff ff       	call   801836 <syscall>
  8019d6:	83 c4 18             	add    $0x18,%esp
}
  8019d9:	c9                   	leave  
  8019da:	c3                   	ret    

008019db <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	ff 75 08             	pushl  0x8(%ebp)
  8019e9:	6a 0d                	push   $0xd
  8019eb:	e8 46 fe ff ff       	call   801836 <syscall>
  8019f0:	83 c4 18             	add    $0x18,%esp
}
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    

008019f5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 0e                	push   $0xe
  801a04:	e8 2d fe ff ff       	call   801836 <syscall>
  801a09:	83 c4 18             	add    $0x18,%esp
}
  801a0c:	90                   	nop
  801a0d:	c9                   	leave  
  801a0e:	c3                   	ret    

00801a0f <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 13                	push   $0x13
  801a1e:	e8 13 fe ff ff       	call   801836 <syscall>
  801a23:	83 c4 18             	add    $0x18,%esp
}
  801a26:	90                   	nop
  801a27:	c9                   	leave  
  801a28:	c3                   	ret    

00801a29 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 14                	push   $0x14
  801a38:	e8 f9 fd ff ff       	call   801836 <syscall>
  801a3d:	83 c4 18             	add    $0x18,%esp
}
  801a40:	90                   	nop
  801a41:	c9                   	leave  
  801a42:	c3                   	ret    

00801a43 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a43:	55                   	push   %ebp
  801a44:	89 e5                	mov    %esp,%ebp
  801a46:	83 ec 04             	sub    $0x4,%esp
  801a49:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a4f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	50                   	push   %eax
  801a5c:	6a 15                	push   $0x15
  801a5e:	e8 d3 fd ff ff       	call   801836 <syscall>
  801a63:	83 c4 18             	add    $0x18,%esp
}
  801a66:	90                   	nop
  801a67:	c9                   	leave  
  801a68:	c3                   	ret    

00801a69 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a69:	55                   	push   %ebp
  801a6a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 16                	push   $0x16
  801a78:	e8 b9 fd ff ff       	call   801836 <syscall>
  801a7d:	83 c4 18             	add    $0x18,%esp
}
  801a80:	90                   	nop
  801a81:	c9                   	leave  
  801a82:	c3                   	ret    

00801a83 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a86:	8b 45 08             	mov    0x8(%ebp),%eax
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	ff 75 0c             	pushl  0xc(%ebp)
  801a92:	50                   	push   %eax
  801a93:	6a 17                	push   $0x17
  801a95:	e8 9c fd ff ff       	call   801836 <syscall>
  801a9a:	83 c4 18             	add    $0x18,%esp
}
  801a9d:	c9                   	leave  
  801a9e:	c3                   	ret    

00801a9f <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a9f:	55                   	push   %ebp
  801aa0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801aa2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	52                   	push   %edx
  801aaf:	50                   	push   %eax
  801ab0:	6a 1a                	push   $0x1a
  801ab2:	e8 7f fd ff ff       	call   801836 <syscall>
  801ab7:	83 c4 18             	add    $0x18,%esp
}
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

00801abc <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801abf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	52                   	push   %edx
  801acc:	50                   	push   %eax
  801acd:	6a 18                	push   $0x18
  801acf:	e8 62 fd ff ff       	call   801836 <syscall>
  801ad4:	83 c4 18             	add    $0x18,%esp
}
  801ad7:	90                   	nop
  801ad8:	c9                   	leave  
  801ad9:	c3                   	ret    

00801ada <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ada:	55                   	push   %ebp
  801adb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801add:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	52                   	push   %edx
  801aea:	50                   	push   %eax
  801aeb:	6a 19                	push   $0x19
  801aed:	e8 44 fd ff ff       	call   801836 <syscall>
  801af2:	83 c4 18             	add    $0x18,%esp
}
  801af5:	90                   	nop
  801af6:	c9                   	leave  
  801af7:	c3                   	ret    

00801af8 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
  801afb:	83 ec 04             	sub    $0x4,%esp
  801afe:	8b 45 10             	mov    0x10(%ebp),%eax
  801b01:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b04:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b07:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0e:	6a 00                	push   $0x0
  801b10:	51                   	push   %ecx
  801b11:	52                   	push   %edx
  801b12:	ff 75 0c             	pushl  0xc(%ebp)
  801b15:	50                   	push   %eax
  801b16:	6a 1b                	push   $0x1b
  801b18:	e8 19 fd ff ff       	call   801836 <syscall>
  801b1d:	83 c4 18             	add    $0x18,%esp
}
  801b20:	c9                   	leave  
  801b21:	c3                   	ret    

00801b22 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b22:	55                   	push   %ebp
  801b23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b25:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b28:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	52                   	push   %edx
  801b32:	50                   	push   %eax
  801b33:	6a 1c                	push   $0x1c
  801b35:	e8 fc fc ff ff       	call   801836 <syscall>
  801b3a:	83 c4 18             	add    $0x18,%esp
}
  801b3d:	c9                   	leave  
  801b3e:	c3                   	ret    

00801b3f <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b3f:	55                   	push   %ebp
  801b40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b42:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b48:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	51                   	push   %ecx
  801b50:	52                   	push   %edx
  801b51:	50                   	push   %eax
  801b52:	6a 1d                	push   $0x1d
  801b54:	e8 dd fc ff ff       	call   801836 <syscall>
  801b59:	83 c4 18             	add    $0x18,%esp
}
  801b5c:	c9                   	leave  
  801b5d:	c3                   	ret    

00801b5e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b5e:	55                   	push   %ebp
  801b5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b61:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b64:	8b 45 08             	mov    0x8(%ebp),%eax
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	52                   	push   %edx
  801b6e:	50                   	push   %eax
  801b6f:	6a 1e                	push   $0x1e
  801b71:	e8 c0 fc ff ff       	call   801836 <syscall>
  801b76:	83 c4 18             	add    $0x18,%esp
}
  801b79:	c9                   	leave  
  801b7a:	c3                   	ret    

00801b7b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b7b:	55                   	push   %ebp
  801b7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	6a 1f                	push   $0x1f
  801b8a:	e8 a7 fc ff ff       	call   801836 <syscall>
  801b8f:	83 c4 18             	add    $0x18,%esp
}
  801b92:	c9                   	leave  
  801b93:	c3                   	ret    

00801b94 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b94:	55                   	push   %ebp
  801b95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b97:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9a:	6a 00                	push   $0x0
  801b9c:	ff 75 14             	pushl  0x14(%ebp)
  801b9f:	ff 75 10             	pushl  0x10(%ebp)
  801ba2:	ff 75 0c             	pushl  0xc(%ebp)
  801ba5:	50                   	push   %eax
  801ba6:	6a 20                	push   $0x20
  801ba8:	e8 89 fc ff ff       	call   801836 <syscall>
  801bad:	83 c4 18             	add    $0x18,%esp
}
  801bb0:	c9                   	leave  
  801bb1:	c3                   	ret    

00801bb2 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801bb2:	55                   	push   %ebp
  801bb3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	50                   	push   %eax
  801bc1:	6a 21                	push   $0x21
  801bc3:	e8 6e fc ff ff       	call   801836 <syscall>
  801bc8:	83 c4 18             	add    $0x18,%esp
}
  801bcb:	90                   	nop
  801bcc:	c9                   	leave  
  801bcd:	c3                   	ret    

00801bce <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bce:	55                   	push   %ebp
  801bcf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	50                   	push   %eax
  801bdd:	6a 22                	push   $0x22
  801bdf:	e8 52 fc ff ff       	call   801836 <syscall>
  801be4:	83 c4 18             	add    $0x18,%esp
}
  801be7:	c9                   	leave  
  801be8:	c3                   	ret    

00801be9 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801be9:	55                   	push   %ebp
  801bea:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 02                	push   $0x2
  801bf8:	e8 39 fc ff ff       	call   801836 <syscall>
  801bfd:	83 c4 18             	add    $0x18,%esp
}
  801c00:	c9                   	leave  
  801c01:	c3                   	ret    

00801c02 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c02:	55                   	push   %ebp
  801c03:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 03                	push   $0x3
  801c11:	e8 20 fc ff ff       	call   801836 <syscall>
  801c16:	83 c4 18             	add    $0x18,%esp
}
  801c19:	c9                   	leave  
  801c1a:	c3                   	ret    

00801c1b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 04                	push   $0x4
  801c2a:	e8 07 fc ff ff       	call   801836 <syscall>
  801c2f:	83 c4 18             	add    $0x18,%esp
}
  801c32:	c9                   	leave  
  801c33:	c3                   	ret    

00801c34 <sys_exit_env>:


void sys_exit_env(void)
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 23                	push   $0x23
  801c43:	e8 ee fb ff ff       	call   801836 <syscall>
  801c48:	83 c4 18             	add    $0x18,%esp
}
  801c4b:	90                   	nop
  801c4c:	c9                   	leave  
  801c4d:	c3                   	ret    

00801c4e <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c4e:	55                   	push   %ebp
  801c4f:	89 e5                	mov    %esp,%ebp
  801c51:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c54:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c57:	8d 50 04             	lea    0x4(%eax),%edx
  801c5a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	52                   	push   %edx
  801c64:	50                   	push   %eax
  801c65:	6a 24                	push   $0x24
  801c67:	e8 ca fb ff ff       	call   801836 <syscall>
  801c6c:	83 c4 18             	add    $0x18,%esp
	return result;
  801c6f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c72:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c75:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c78:	89 01                	mov    %eax,(%ecx)
  801c7a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c80:	c9                   	leave  
  801c81:	c2 04 00             	ret    $0x4

00801c84 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c84:	55                   	push   %ebp
  801c85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	ff 75 10             	pushl  0x10(%ebp)
  801c8e:	ff 75 0c             	pushl  0xc(%ebp)
  801c91:	ff 75 08             	pushl  0x8(%ebp)
  801c94:	6a 12                	push   $0x12
  801c96:	e8 9b fb ff ff       	call   801836 <syscall>
  801c9b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c9e:	90                   	nop
}
  801c9f:	c9                   	leave  
  801ca0:	c3                   	ret    

00801ca1 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ca1:	55                   	push   %ebp
  801ca2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 25                	push   $0x25
  801cb0:	e8 81 fb ff ff       	call   801836 <syscall>
  801cb5:	83 c4 18             	add    $0x18,%esp
}
  801cb8:	c9                   	leave  
  801cb9:	c3                   	ret    

00801cba <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801cba:	55                   	push   %ebp
  801cbb:	89 e5                	mov    %esp,%ebp
  801cbd:	83 ec 04             	sub    $0x4,%esp
  801cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cc6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	50                   	push   %eax
  801cd3:	6a 26                	push   $0x26
  801cd5:	e8 5c fb ff ff       	call   801836 <syscall>
  801cda:	83 c4 18             	add    $0x18,%esp
	return ;
  801cdd:	90                   	nop
}
  801cde:	c9                   	leave  
  801cdf:	c3                   	ret    

00801ce0 <rsttst>:
void rsttst()
{
  801ce0:	55                   	push   %ebp
  801ce1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 28                	push   $0x28
  801cef:	e8 42 fb ff ff       	call   801836 <syscall>
  801cf4:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf7:	90                   	nop
}
  801cf8:	c9                   	leave  
  801cf9:	c3                   	ret    

00801cfa <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cfa:	55                   	push   %ebp
  801cfb:	89 e5                	mov    %esp,%ebp
  801cfd:	83 ec 04             	sub    $0x4,%esp
  801d00:	8b 45 14             	mov    0x14(%ebp),%eax
  801d03:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d06:	8b 55 18             	mov    0x18(%ebp),%edx
  801d09:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d0d:	52                   	push   %edx
  801d0e:	50                   	push   %eax
  801d0f:	ff 75 10             	pushl  0x10(%ebp)
  801d12:	ff 75 0c             	pushl  0xc(%ebp)
  801d15:	ff 75 08             	pushl  0x8(%ebp)
  801d18:	6a 27                	push   $0x27
  801d1a:	e8 17 fb ff ff       	call   801836 <syscall>
  801d1f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d22:	90                   	nop
}
  801d23:	c9                   	leave  
  801d24:	c3                   	ret    

00801d25 <chktst>:
void chktst(uint32 n)
{
  801d25:	55                   	push   %ebp
  801d26:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	ff 75 08             	pushl  0x8(%ebp)
  801d33:	6a 29                	push   $0x29
  801d35:	e8 fc fa ff ff       	call   801836 <syscall>
  801d3a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d3d:	90                   	nop
}
  801d3e:	c9                   	leave  
  801d3f:	c3                   	ret    

00801d40 <inctst>:

void inctst()
{
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 2a                	push   $0x2a
  801d4f:	e8 e2 fa ff ff       	call   801836 <syscall>
  801d54:	83 c4 18             	add    $0x18,%esp
	return ;
  801d57:	90                   	nop
}
  801d58:	c9                   	leave  
  801d59:	c3                   	ret    

00801d5a <gettst>:
uint32 gettst()
{
  801d5a:	55                   	push   %ebp
  801d5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	6a 2b                	push   $0x2b
  801d69:	e8 c8 fa ff ff       	call   801836 <syscall>
  801d6e:	83 c4 18             	add    $0x18,%esp
}
  801d71:	c9                   	leave  
  801d72:	c3                   	ret    

00801d73 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d73:	55                   	push   %ebp
  801d74:	89 e5                	mov    %esp,%ebp
  801d76:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 2c                	push   $0x2c
  801d85:	e8 ac fa ff ff       	call   801836 <syscall>
  801d8a:	83 c4 18             	add    $0x18,%esp
  801d8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d90:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d94:	75 07                	jne    801d9d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d96:	b8 01 00 00 00       	mov    $0x1,%eax
  801d9b:	eb 05                	jmp    801da2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da2:	c9                   	leave  
  801da3:	c3                   	ret    

00801da4 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801da4:	55                   	push   %ebp
  801da5:	89 e5                	mov    %esp,%ebp
  801da7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 2c                	push   $0x2c
  801db6:	e8 7b fa ff ff       	call   801836 <syscall>
  801dbb:	83 c4 18             	add    $0x18,%esp
  801dbe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801dc1:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801dc5:	75 07                	jne    801dce <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801dc7:	b8 01 00 00 00       	mov    $0x1,%eax
  801dcc:	eb 05                	jmp    801dd3 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801dce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dd3:	c9                   	leave  
  801dd4:	c3                   	ret    

00801dd5 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801dd5:	55                   	push   %ebp
  801dd6:	89 e5                	mov    %esp,%ebp
  801dd8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 2c                	push   $0x2c
  801de7:	e8 4a fa ff ff       	call   801836 <syscall>
  801dec:	83 c4 18             	add    $0x18,%esp
  801def:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801df2:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801df6:	75 07                	jne    801dff <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801df8:	b8 01 00 00 00       	mov    $0x1,%eax
  801dfd:	eb 05                	jmp    801e04 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801dff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e04:	c9                   	leave  
  801e05:	c3                   	ret    

00801e06 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e06:	55                   	push   %ebp
  801e07:	89 e5                	mov    %esp,%ebp
  801e09:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	6a 2c                	push   $0x2c
  801e18:	e8 19 fa ff ff       	call   801836 <syscall>
  801e1d:	83 c4 18             	add    $0x18,%esp
  801e20:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e23:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e27:	75 07                	jne    801e30 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e29:	b8 01 00 00 00       	mov    $0x1,%eax
  801e2e:	eb 05                	jmp    801e35 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e30:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e35:	c9                   	leave  
  801e36:	c3                   	ret    

00801e37 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e37:	55                   	push   %ebp
  801e38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	ff 75 08             	pushl  0x8(%ebp)
  801e45:	6a 2d                	push   $0x2d
  801e47:	e8 ea f9 ff ff       	call   801836 <syscall>
  801e4c:	83 c4 18             	add    $0x18,%esp
	return ;
  801e4f:	90                   	nop
}
  801e50:	c9                   	leave  
  801e51:	c3                   	ret    

00801e52 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
  801e55:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e56:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e59:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e62:	6a 00                	push   $0x0
  801e64:	53                   	push   %ebx
  801e65:	51                   	push   %ecx
  801e66:	52                   	push   %edx
  801e67:	50                   	push   %eax
  801e68:	6a 2e                	push   $0x2e
  801e6a:	e8 c7 f9 ff ff       	call   801836 <syscall>
  801e6f:	83 c4 18             	add    $0x18,%esp
}
  801e72:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e75:	c9                   	leave  
  801e76:	c3                   	ret    

00801e77 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e77:	55                   	push   %ebp
  801e78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	52                   	push   %edx
  801e87:	50                   	push   %eax
  801e88:	6a 2f                	push   $0x2f
  801e8a:	e8 a7 f9 ff ff       	call   801836 <syscall>
  801e8f:	83 c4 18             	add    $0x18,%esp
}
  801e92:	c9                   	leave  
  801e93:	c3                   	ret    

00801e94 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e94:	55                   	push   %ebp
  801e95:	89 e5                	mov    %esp,%ebp
  801e97:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e9a:	83 ec 0c             	sub    $0xc,%esp
  801e9d:	68 00 3b 80 00       	push   $0x803b00
  801ea2:	e8 c3 e6 ff ff       	call   80056a <cprintf>
  801ea7:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801eaa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801eb1:	83 ec 0c             	sub    $0xc,%esp
  801eb4:	68 2c 3b 80 00       	push   $0x803b2c
  801eb9:	e8 ac e6 ff ff       	call   80056a <cprintf>
  801ebe:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801ec1:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ec5:	a1 38 41 80 00       	mov    0x804138,%eax
  801eca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ecd:	eb 56                	jmp    801f25 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ecf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ed3:	74 1c                	je     801ef1 <print_mem_block_lists+0x5d>
  801ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed8:	8b 50 08             	mov    0x8(%eax),%edx
  801edb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ede:	8b 48 08             	mov    0x8(%eax),%ecx
  801ee1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ee4:	8b 40 0c             	mov    0xc(%eax),%eax
  801ee7:	01 c8                	add    %ecx,%eax
  801ee9:	39 c2                	cmp    %eax,%edx
  801eeb:	73 04                	jae    801ef1 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801eed:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ef1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef4:	8b 50 08             	mov    0x8(%eax),%edx
  801ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efa:	8b 40 0c             	mov    0xc(%eax),%eax
  801efd:	01 c2                	add    %eax,%edx
  801eff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f02:	8b 40 08             	mov    0x8(%eax),%eax
  801f05:	83 ec 04             	sub    $0x4,%esp
  801f08:	52                   	push   %edx
  801f09:	50                   	push   %eax
  801f0a:	68 41 3b 80 00       	push   $0x803b41
  801f0f:	e8 56 e6 ff ff       	call   80056a <cprintf>
  801f14:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f1d:	a1 40 41 80 00       	mov    0x804140,%eax
  801f22:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f29:	74 07                	je     801f32 <print_mem_block_lists+0x9e>
  801f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2e:	8b 00                	mov    (%eax),%eax
  801f30:	eb 05                	jmp    801f37 <print_mem_block_lists+0xa3>
  801f32:	b8 00 00 00 00       	mov    $0x0,%eax
  801f37:	a3 40 41 80 00       	mov    %eax,0x804140
  801f3c:	a1 40 41 80 00       	mov    0x804140,%eax
  801f41:	85 c0                	test   %eax,%eax
  801f43:	75 8a                	jne    801ecf <print_mem_block_lists+0x3b>
  801f45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f49:	75 84                	jne    801ecf <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f4b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f4f:	75 10                	jne    801f61 <print_mem_block_lists+0xcd>
  801f51:	83 ec 0c             	sub    $0xc,%esp
  801f54:	68 50 3b 80 00       	push   $0x803b50
  801f59:	e8 0c e6 ff ff       	call   80056a <cprintf>
  801f5e:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f61:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f68:	83 ec 0c             	sub    $0xc,%esp
  801f6b:	68 74 3b 80 00       	push   $0x803b74
  801f70:	e8 f5 e5 ff ff       	call   80056a <cprintf>
  801f75:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f78:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f7c:	a1 40 40 80 00       	mov    0x804040,%eax
  801f81:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f84:	eb 56                	jmp    801fdc <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f86:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f8a:	74 1c                	je     801fa8 <print_mem_block_lists+0x114>
  801f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8f:	8b 50 08             	mov    0x8(%eax),%edx
  801f92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f95:	8b 48 08             	mov    0x8(%eax),%ecx
  801f98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f9b:	8b 40 0c             	mov    0xc(%eax),%eax
  801f9e:	01 c8                	add    %ecx,%eax
  801fa0:	39 c2                	cmp    %eax,%edx
  801fa2:	73 04                	jae    801fa8 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801fa4:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fab:	8b 50 08             	mov    0x8(%eax),%edx
  801fae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb1:	8b 40 0c             	mov    0xc(%eax),%eax
  801fb4:	01 c2                	add    %eax,%edx
  801fb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb9:	8b 40 08             	mov    0x8(%eax),%eax
  801fbc:	83 ec 04             	sub    $0x4,%esp
  801fbf:	52                   	push   %edx
  801fc0:	50                   	push   %eax
  801fc1:	68 41 3b 80 00       	push   $0x803b41
  801fc6:	e8 9f e5 ff ff       	call   80056a <cprintf>
  801fcb:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fd4:	a1 48 40 80 00       	mov    0x804048,%eax
  801fd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fdc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fe0:	74 07                	je     801fe9 <print_mem_block_lists+0x155>
  801fe2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe5:	8b 00                	mov    (%eax),%eax
  801fe7:	eb 05                	jmp    801fee <print_mem_block_lists+0x15a>
  801fe9:	b8 00 00 00 00       	mov    $0x0,%eax
  801fee:	a3 48 40 80 00       	mov    %eax,0x804048
  801ff3:	a1 48 40 80 00       	mov    0x804048,%eax
  801ff8:	85 c0                	test   %eax,%eax
  801ffa:	75 8a                	jne    801f86 <print_mem_block_lists+0xf2>
  801ffc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802000:	75 84                	jne    801f86 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802002:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802006:	75 10                	jne    802018 <print_mem_block_lists+0x184>
  802008:	83 ec 0c             	sub    $0xc,%esp
  80200b:	68 8c 3b 80 00       	push   $0x803b8c
  802010:	e8 55 e5 ff ff       	call   80056a <cprintf>
  802015:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802018:	83 ec 0c             	sub    $0xc,%esp
  80201b:	68 00 3b 80 00       	push   $0x803b00
  802020:	e8 45 e5 ff ff       	call   80056a <cprintf>
  802025:	83 c4 10             	add    $0x10,%esp

}
  802028:	90                   	nop
  802029:	c9                   	leave  
  80202a:	c3                   	ret    

0080202b <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80202b:	55                   	push   %ebp
  80202c:	89 e5                	mov    %esp,%ebp
  80202e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  802031:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802038:	00 00 00 
  80203b:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802042:	00 00 00 
  802045:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  80204c:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  80204f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802056:	e9 9e 00 00 00       	jmp    8020f9 <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  80205b:	a1 50 40 80 00       	mov    0x804050,%eax
  802060:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802063:	c1 e2 04             	shl    $0x4,%edx
  802066:	01 d0                	add    %edx,%eax
  802068:	85 c0                	test   %eax,%eax
  80206a:	75 14                	jne    802080 <initialize_MemBlocksList+0x55>
  80206c:	83 ec 04             	sub    $0x4,%esp
  80206f:	68 b4 3b 80 00       	push   $0x803bb4
  802074:	6a 47                	push   $0x47
  802076:	68 d7 3b 80 00       	push   $0x803bd7
  80207b:	e8 36 e2 ff ff       	call   8002b6 <_panic>
  802080:	a1 50 40 80 00       	mov    0x804050,%eax
  802085:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802088:	c1 e2 04             	shl    $0x4,%edx
  80208b:	01 d0                	add    %edx,%eax
  80208d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802093:	89 10                	mov    %edx,(%eax)
  802095:	8b 00                	mov    (%eax),%eax
  802097:	85 c0                	test   %eax,%eax
  802099:	74 18                	je     8020b3 <initialize_MemBlocksList+0x88>
  80209b:	a1 48 41 80 00       	mov    0x804148,%eax
  8020a0:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8020a6:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8020a9:	c1 e1 04             	shl    $0x4,%ecx
  8020ac:	01 ca                	add    %ecx,%edx
  8020ae:	89 50 04             	mov    %edx,0x4(%eax)
  8020b1:	eb 12                	jmp    8020c5 <initialize_MemBlocksList+0x9a>
  8020b3:	a1 50 40 80 00       	mov    0x804050,%eax
  8020b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020bb:	c1 e2 04             	shl    $0x4,%edx
  8020be:	01 d0                	add    %edx,%eax
  8020c0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8020c5:	a1 50 40 80 00       	mov    0x804050,%eax
  8020ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020cd:	c1 e2 04             	shl    $0x4,%edx
  8020d0:	01 d0                	add    %edx,%eax
  8020d2:	a3 48 41 80 00       	mov    %eax,0x804148
  8020d7:	a1 50 40 80 00       	mov    0x804050,%eax
  8020dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020df:	c1 e2 04             	shl    $0x4,%edx
  8020e2:	01 d0                	add    %edx,%eax
  8020e4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020eb:	a1 54 41 80 00       	mov    0x804154,%eax
  8020f0:	40                   	inc    %eax
  8020f1:	a3 54 41 80 00       	mov    %eax,0x804154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  8020f6:	ff 45 f4             	incl   -0xc(%ebp)
  8020f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020ff:	0f 82 56 ff ff ff    	jb     80205b <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  802105:	90                   	nop
  802106:	c9                   	leave  
  802107:	c3                   	ret    

00802108 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802108:	55                   	push   %ebp
  802109:	89 e5                	mov    %esp,%ebp
  80210b:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  80210e:	8b 45 08             	mov    0x8(%ebp),%eax
  802111:	8b 00                	mov    (%eax),%eax
  802113:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802116:	eb 19                	jmp    802131 <find_block+0x29>
	{
		if(element->sva == va){
  802118:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80211b:	8b 40 08             	mov    0x8(%eax),%eax
  80211e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802121:	75 05                	jne    802128 <find_block+0x20>
			 		return element;
  802123:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802126:	eb 36                	jmp    80215e <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802128:	8b 45 08             	mov    0x8(%ebp),%eax
  80212b:	8b 40 08             	mov    0x8(%eax),%eax
  80212e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802131:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802135:	74 07                	je     80213e <find_block+0x36>
  802137:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80213a:	8b 00                	mov    (%eax),%eax
  80213c:	eb 05                	jmp    802143 <find_block+0x3b>
  80213e:	b8 00 00 00 00       	mov    $0x0,%eax
  802143:	8b 55 08             	mov    0x8(%ebp),%edx
  802146:	89 42 08             	mov    %eax,0x8(%edx)
  802149:	8b 45 08             	mov    0x8(%ebp),%eax
  80214c:	8b 40 08             	mov    0x8(%eax),%eax
  80214f:	85 c0                	test   %eax,%eax
  802151:	75 c5                	jne    802118 <find_block+0x10>
  802153:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802157:	75 bf                	jne    802118 <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  802159:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80215e:	c9                   	leave  
  80215f:	c3                   	ret    

00802160 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802160:	55                   	push   %ebp
  802161:	89 e5                	mov    %esp,%ebp
  802163:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  802166:	a1 44 40 80 00       	mov    0x804044,%eax
  80216b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  80216e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802173:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  802176:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80217a:	74 0a                	je     802186 <insert_sorted_allocList+0x26>
  80217c:	8b 45 08             	mov    0x8(%ebp),%eax
  80217f:	8b 40 08             	mov    0x8(%eax),%eax
  802182:	85 c0                	test   %eax,%eax
  802184:	75 65                	jne    8021eb <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802186:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80218a:	75 14                	jne    8021a0 <insert_sorted_allocList+0x40>
  80218c:	83 ec 04             	sub    $0x4,%esp
  80218f:	68 b4 3b 80 00       	push   $0x803bb4
  802194:	6a 6e                	push   $0x6e
  802196:	68 d7 3b 80 00       	push   $0x803bd7
  80219b:	e8 16 e1 ff ff       	call   8002b6 <_panic>
  8021a0:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8021a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a9:	89 10                	mov    %edx,(%eax)
  8021ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ae:	8b 00                	mov    (%eax),%eax
  8021b0:	85 c0                	test   %eax,%eax
  8021b2:	74 0d                	je     8021c1 <insert_sorted_allocList+0x61>
  8021b4:	a1 40 40 80 00       	mov    0x804040,%eax
  8021b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8021bc:	89 50 04             	mov    %edx,0x4(%eax)
  8021bf:	eb 08                	jmp    8021c9 <insert_sorted_allocList+0x69>
  8021c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c4:	a3 44 40 80 00       	mov    %eax,0x804044
  8021c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cc:	a3 40 40 80 00       	mov    %eax,0x804040
  8021d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021db:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021e0:	40                   	inc    %eax
  8021e1:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8021e6:	e9 cf 01 00 00       	jmp    8023ba <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  8021eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ee:	8b 50 08             	mov    0x8(%eax),%edx
  8021f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f4:	8b 40 08             	mov    0x8(%eax),%eax
  8021f7:	39 c2                	cmp    %eax,%edx
  8021f9:	73 65                	jae    802260 <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8021fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021ff:	75 14                	jne    802215 <insert_sorted_allocList+0xb5>
  802201:	83 ec 04             	sub    $0x4,%esp
  802204:	68 f0 3b 80 00       	push   $0x803bf0
  802209:	6a 72                	push   $0x72
  80220b:	68 d7 3b 80 00       	push   $0x803bd7
  802210:	e8 a1 e0 ff ff       	call   8002b6 <_panic>
  802215:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80221b:	8b 45 08             	mov    0x8(%ebp),%eax
  80221e:	89 50 04             	mov    %edx,0x4(%eax)
  802221:	8b 45 08             	mov    0x8(%ebp),%eax
  802224:	8b 40 04             	mov    0x4(%eax),%eax
  802227:	85 c0                	test   %eax,%eax
  802229:	74 0c                	je     802237 <insert_sorted_allocList+0xd7>
  80222b:	a1 44 40 80 00       	mov    0x804044,%eax
  802230:	8b 55 08             	mov    0x8(%ebp),%edx
  802233:	89 10                	mov    %edx,(%eax)
  802235:	eb 08                	jmp    80223f <insert_sorted_allocList+0xdf>
  802237:	8b 45 08             	mov    0x8(%ebp),%eax
  80223a:	a3 40 40 80 00       	mov    %eax,0x804040
  80223f:	8b 45 08             	mov    0x8(%ebp),%eax
  802242:	a3 44 40 80 00       	mov    %eax,0x804044
  802247:	8b 45 08             	mov    0x8(%ebp),%eax
  80224a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802250:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802255:	40                   	inc    %eax
  802256:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  80225b:	e9 5a 01 00 00       	jmp    8023ba <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  802260:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802263:	8b 50 08             	mov    0x8(%eax),%edx
  802266:	8b 45 08             	mov    0x8(%ebp),%eax
  802269:	8b 40 08             	mov    0x8(%eax),%eax
  80226c:	39 c2                	cmp    %eax,%edx
  80226e:	75 70                	jne    8022e0 <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  802270:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802274:	74 06                	je     80227c <insert_sorted_allocList+0x11c>
  802276:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80227a:	75 14                	jne    802290 <insert_sorted_allocList+0x130>
  80227c:	83 ec 04             	sub    $0x4,%esp
  80227f:	68 14 3c 80 00       	push   $0x803c14
  802284:	6a 75                	push   $0x75
  802286:	68 d7 3b 80 00       	push   $0x803bd7
  80228b:	e8 26 e0 ff ff       	call   8002b6 <_panic>
  802290:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802293:	8b 10                	mov    (%eax),%edx
  802295:	8b 45 08             	mov    0x8(%ebp),%eax
  802298:	89 10                	mov    %edx,(%eax)
  80229a:	8b 45 08             	mov    0x8(%ebp),%eax
  80229d:	8b 00                	mov    (%eax),%eax
  80229f:	85 c0                	test   %eax,%eax
  8022a1:	74 0b                	je     8022ae <insert_sorted_allocList+0x14e>
  8022a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a6:	8b 00                	mov    (%eax),%eax
  8022a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8022ab:	89 50 04             	mov    %edx,0x4(%eax)
  8022ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8022b4:	89 10                	mov    %edx,(%eax)
  8022b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022bc:	89 50 04             	mov    %edx,0x4(%eax)
  8022bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c2:	8b 00                	mov    (%eax),%eax
  8022c4:	85 c0                	test   %eax,%eax
  8022c6:	75 08                	jne    8022d0 <insert_sorted_allocList+0x170>
  8022c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cb:	a3 44 40 80 00       	mov    %eax,0x804044
  8022d0:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022d5:	40                   	inc    %eax
  8022d6:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  8022db:	e9 da 00 00 00       	jmp    8023ba <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  8022e0:	a1 40 40 80 00       	mov    0x804040,%eax
  8022e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022e8:	e9 9d 00 00 00       	jmp    80238a <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  8022ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f0:	8b 00                	mov    (%eax),%eax
  8022f2:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  8022f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f8:	8b 50 08             	mov    0x8(%eax),%edx
  8022fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fe:	8b 40 08             	mov    0x8(%eax),%eax
  802301:	39 c2                	cmp    %eax,%edx
  802303:	76 7d                	jbe    802382 <insert_sorted_allocList+0x222>
  802305:	8b 45 08             	mov    0x8(%ebp),%eax
  802308:	8b 50 08             	mov    0x8(%eax),%edx
  80230b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80230e:	8b 40 08             	mov    0x8(%eax),%eax
  802311:	39 c2                	cmp    %eax,%edx
  802313:	73 6d                	jae    802382 <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802315:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802319:	74 06                	je     802321 <insert_sorted_allocList+0x1c1>
  80231b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80231f:	75 14                	jne    802335 <insert_sorted_allocList+0x1d5>
  802321:	83 ec 04             	sub    $0x4,%esp
  802324:	68 14 3c 80 00       	push   $0x803c14
  802329:	6a 7c                	push   $0x7c
  80232b:	68 d7 3b 80 00       	push   $0x803bd7
  802330:	e8 81 df ff ff       	call   8002b6 <_panic>
  802335:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802338:	8b 10                	mov    (%eax),%edx
  80233a:	8b 45 08             	mov    0x8(%ebp),%eax
  80233d:	89 10                	mov    %edx,(%eax)
  80233f:	8b 45 08             	mov    0x8(%ebp),%eax
  802342:	8b 00                	mov    (%eax),%eax
  802344:	85 c0                	test   %eax,%eax
  802346:	74 0b                	je     802353 <insert_sorted_allocList+0x1f3>
  802348:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234b:	8b 00                	mov    (%eax),%eax
  80234d:	8b 55 08             	mov    0x8(%ebp),%edx
  802350:	89 50 04             	mov    %edx,0x4(%eax)
  802353:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802356:	8b 55 08             	mov    0x8(%ebp),%edx
  802359:	89 10                	mov    %edx,(%eax)
  80235b:	8b 45 08             	mov    0x8(%ebp),%eax
  80235e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802361:	89 50 04             	mov    %edx,0x4(%eax)
  802364:	8b 45 08             	mov    0x8(%ebp),%eax
  802367:	8b 00                	mov    (%eax),%eax
  802369:	85 c0                	test   %eax,%eax
  80236b:	75 08                	jne    802375 <insert_sorted_allocList+0x215>
  80236d:	8b 45 08             	mov    0x8(%ebp),%eax
  802370:	a3 44 40 80 00       	mov    %eax,0x804044
  802375:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80237a:	40                   	inc    %eax
  80237b:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802380:	eb 38                	jmp    8023ba <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802382:	a1 48 40 80 00       	mov    0x804048,%eax
  802387:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80238a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80238e:	74 07                	je     802397 <insert_sorted_allocList+0x237>
  802390:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802393:	8b 00                	mov    (%eax),%eax
  802395:	eb 05                	jmp    80239c <insert_sorted_allocList+0x23c>
  802397:	b8 00 00 00 00       	mov    $0x0,%eax
  80239c:	a3 48 40 80 00       	mov    %eax,0x804048
  8023a1:	a1 48 40 80 00       	mov    0x804048,%eax
  8023a6:	85 c0                	test   %eax,%eax
  8023a8:	0f 85 3f ff ff ff    	jne    8022ed <insert_sorted_allocList+0x18d>
  8023ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023b2:	0f 85 35 ff ff ff    	jne    8022ed <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  8023b8:	eb 00                	jmp    8023ba <insert_sorted_allocList+0x25a>
  8023ba:	90                   	nop
  8023bb:	c9                   	leave  
  8023bc:	c3                   	ret    

008023bd <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8023bd:	55                   	push   %ebp
  8023be:	89 e5                	mov    %esp,%ebp
  8023c0:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  8023c3:	a1 38 41 80 00       	mov    0x804138,%eax
  8023c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023cb:	e9 6b 02 00 00       	jmp    80263b <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  8023d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8023d6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023d9:	0f 85 90 00 00 00    	jne    80246f <alloc_block_FF+0xb2>
			  temp=element;
  8023df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e2:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  8023e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023e9:	75 17                	jne    802402 <alloc_block_FF+0x45>
  8023eb:	83 ec 04             	sub    $0x4,%esp
  8023ee:	68 48 3c 80 00       	push   $0x803c48
  8023f3:	68 92 00 00 00       	push   $0x92
  8023f8:	68 d7 3b 80 00       	push   $0x803bd7
  8023fd:	e8 b4 de ff ff       	call   8002b6 <_panic>
  802402:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802405:	8b 00                	mov    (%eax),%eax
  802407:	85 c0                	test   %eax,%eax
  802409:	74 10                	je     80241b <alloc_block_FF+0x5e>
  80240b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240e:	8b 00                	mov    (%eax),%eax
  802410:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802413:	8b 52 04             	mov    0x4(%edx),%edx
  802416:	89 50 04             	mov    %edx,0x4(%eax)
  802419:	eb 0b                	jmp    802426 <alloc_block_FF+0x69>
  80241b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241e:	8b 40 04             	mov    0x4(%eax),%eax
  802421:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802426:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802429:	8b 40 04             	mov    0x4(%eax),%eax
  80242c:	85 c0                	test   %eax,%eax
  80242e:	74 0f                	je     80243f <alloc_block_FF+0x82>
  802430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802433:	8b 40 04             	mov    0x4(%eax),%eax
  802436:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802439:	8b 12                	mov    (%edx),%edx
  80243b:	89 10                	mov    %edx,(%eax)
  80243d:	eb 0a                	jmp    802449 <alloc_block_FF+0x8c>
  80243f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802442:	8b 00                	mov    (%eax),%eax
  802444:	a3 38 41 80 00       	mov    %eax,0x804138
  802449:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802452:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802455:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80245c:	a1 44 41 80 00       	mov    0x804144,%eax
  802461:	48                   	dec    %eax
  802462:	a3 44 41 80 00       	mov    %eax,0x804144
			  return temp;
  802467:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80246a:	e9 ff 01 00 00       	jmp    80266e <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  80246f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802472:	8b 40 0c             	mov    0xc(%eax),%eax
  802475:	3b 45 08             	cmp    0x8(%ebp),%eax
  802478:	0f 86 b5 01 00 00    	jbe    802633 <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  80247e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802481:	8b 40 0c             	mov    0xc(%eax),%eax
  802484:	2b 45 08             	sub    0x8(%ebp),%eax
  802487:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  80248a:	a1 48 41 80 00       	mov    0x804148,%eax
  80248f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  802492:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802496:	75 17                	jne    8024af <alloc_block_FF+0xf2>
  802498:	83 ec 04             	sub    $0x4,%esp
  80249b:	68 48 3c 80 00       	push   $0x803c48
  8024a0:	68 99 00 00 00       	push   $0x99
  8024a5:	68 d7 3b 80 00       	push   $0x803bd7
  8024aa:	e8 07 de ff ff       	call   8002b6 <_panic>
  8024af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024b2:	8b 00                	mov    (%eax),%eax
  8024b4:	85 c0                	test   %eax,%eax
  8024b6:	74 10                	je     8024c8 <alloc_block_FF+0x10b>
  8024b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024bb:	8b 00                	mov    (%eax),%eax
  8024bd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024c0:	8b 52 04             	mov    0x4(%edx),%edx
  8024c3:	89 50 04             	mov    %edx,0x4(%eax)
  8024c6:	eb 0b                	jmp    8024d3 <alloc_block_FF+0x116>
  8024c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024cb:	8b 40 04             	mov    0x4(%eax),%eax
  8024ce:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8024d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024d6:	8b 40 04             	mov    0x4(%eax),%eax
  8024d9:	85 c0                	test   %eax,%eax
  8024db:	74 0f                	je     8024ec <alloc_block_FF+0x12f>
  8024dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024e0:	8b 40 04             	mov    0x4(%eax),%eax
  8024e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024e6:	8b 12                	mov    (%edx),%edx
  8024e8:	89 10                	mov    %edx,(%eax)
  8024ea:	eb 0a                	jmp    8024f6 <alloc_block_FF+0x139>
  8024ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024ef:	8b 00                	mov    (%eax),%eax
  8024f1:	a3 48 41 80 00       	mov    %eax,0x804148
  8024f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802502:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802509:	a1 54 41 80 00       	mov    0x804154,%eax
  80250e:	48                   	dec    %eax
  80250f:	a3 54 41 80 00       	mov    %eax,0x804154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  802514:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802518:	75 17                	jne    802531 <alloc_block_FF+0x174>
  80251a:	83 ec 04             	sub    $0x4,%esp
  80251d:	68 f0 3b 80 00       	push   $0x803bf0
  802522:	68 9a 00 00 00       	push   $0x9a
  802527:	68 d7 3b 80 00       	push   $0x803bd7
  80252c:	e8 85 dd ff ff       	call   8002b6 <_panic>
  802531:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802537:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80253a:	89 50 04             	mov    %edx,0x4(%eax)
  80253d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802540:	8b 40 04             	mov    0x4(%eax),%eax
  802543:	85 c0                	test   %eax,%eax
  802545:	74 0c                	je     802553 <alloc_block_FF+0x196>
  802547:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80254c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80254f:	89 10                	mov    %edx,(%eax)
  802551:	eb 08                	jmp    80255b <alloc_block_FF+0x19e>
  802553:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802556:	a3 38 41 80 00       	mov    %eax,0x804138
  80255b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80255e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802563:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802566:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80256c:	a1 44 41 80 00       	mov    0x804144,%eax
  802571:	40                   	inc    %eax
  802572:	a3 44 41 80 00       	mov    %eax,0x804144
		  // setting the size & sva
		  new_block->size=size;
  802577:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80257a:	8b 55 08             	mov    0x8(%ebp),%edx
  80257d:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  802580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802583:	8b 50 08             	mov    0x8(%eax),%edx
  802586:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802589:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  80258c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802592:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  802595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802598:	8b 50 08             	mov    0x8(%eax),%edx
  80259b:	8b 45 08             	mov    0x8(%ebp),%eax
  80259e:	01 c2                	add    %eax,%edx
  8025a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a3:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  8025a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025a9:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  8025ac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025b0:	75 17                	jne    8025c9 <alloc_block_FF+0x20c>
  8025b2:	83 ec 04             	sub    $0x4,%esp
  8025b5:	68 48 3c 80 00       	push   $0x803c48
  8025ba:	68 a2 00 00 00       	push   $0xa2
  8025bf:	68 d7 3b 80 00       	push   $0x803bd7
  8025c4:	e8 ed dc ff ff       	call   8002b6 <_panic>
  8025c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025cc:	8b 00                	mov    (%eax),%eax
  8025ce:	85 c0                	test   %eax,%eax
  8025d0:	74 10                	je     8025e2 <alloc_block_FF+0x225>
  8025d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d5:	8b 00                	mov    (%eax),%eax
  8025d7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025da:	8b 52 04             	mov    0x4(%edx),%edx
  8025dd:	89 50 04             	mov    %edx,0x4(%eax)
  8025e0:	eb 0b                	jmp    8025ed <alloc_block_FF+0x230>
  8025e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e5:	8b 40 04             	mov    0x4(%eax),%eax
  8025e8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f0:	8b 40 04             	mov    0x4(%eax),%eax
  8025f3:	85 c0                	test   %eax,%eax
  8025f5:	74 0f                	je     802606 <alloc_block_FF+0x249>
  8025f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025fa:	8b 40 04             	mov    0x4(%eax),%eax
  8025fd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802600:	8b 12                	mov    (%edx),%edx
  802602:	89 10                	mov    %edx,(%eax)
  802604:	eb 0a                	jmp    802610 <alloc_block_FF+0x253>
  802606:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802609:	8b 00                	mov    (%eax),%eax
  80260b:	a3 38 41 80 00       	mov    %eax,0x804138
  802610:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802613:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802619:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80261c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802623:	a1 44 41 80 00       	mov    0x804144,%eax
  802628:	48                   	dec    %eax
  802629:	a3 44 41 80 00       	mov    %eax,0x804144
		  return temp;
  80262e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802631:	eb 3b                	jmp    80266e <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802633:	a1 40 41 80 00       	mov    0x804140,%eax
  802638:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80263b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80263f:	74 07                	je     802648 <alloc_block_FF+0x28b>
  802641:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802644:	8b 00                	mov    (%eax),%eax
  802646:	eb 05                	jmp    80264d <alloc_block_FF+0x290>
  802648:	b8 00 00 00 00       	mov    $0x0,%eax
  80264d:	a3 40 41 80 00       	mov    %eax,0x804140
  802652:	a1 40 41 80 00       	mov    0x804140,%eax
  802657:	85 c0                	test   %eax,%eax
  802659:	0f 85 71 fd ff ff    	jne    8023d0 <alloc_block_FF+0x13>
  80265f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802663:	0f 85 67 fd ff ff    	jne    8023d0 <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  802669:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80266e:	c9                   	leave  
  80266f:	c3                   	ret    

00802670 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802670:	55                   	push   %ebp
  802671:	89 e5                	mov    %esp,%ebp
  802673:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  802676:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  80267d:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802684:	a1 38 41 80 00       	mov    0x804138,%eax
  802689:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80268c:	e9 d3 00 00 00       	jmp    802764 <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  802691:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802694:	8b 40 0c             	mov    0xc(%eax),%eax
  802697:	3b 45 08             	cmp    0x8(%ebp),%eax
  80269a:	0f 85 90 00 00 00    	jne    802730 <alloc_block_BF+0xc0>
	   temp = element;
  8026a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  8026a6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026aa:	75 17                	jne    8026c3 <alloc_block_BF+0x53>
  8026ac:	83 ec 04             	sub    $0x4,%esp
  8026af:	68 48 3c 80 00       	push   $0x803c48
  8026b4:	68 bd 00 00 00       	push   $0xbd
  8026b9:	68 d7 3b 80 00       	push   $0x803bd7
  8026be:	e8 f3 db ff ff       	call   8002b6 <_panic>
  8026c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026c6:	8b 00                	mov    (%eax),%eax
  8026c8:	85 c0                	test   %eax,%eax
  8026ca:	74 10                	je     8026dc <alloc_block_BF+0x6c>
  8026cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026cf:	8b 00                	mov    (%eax),%eax
  8026d1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026d4:	8b 52 04             	mov    0x4(%edx),%edx
  8026d7:	89 50 04             	mov    %edx,0x4(%eax)
  8026da:	eb 0b                	jmp    8026e7 <alloc_block_BF+0x77>
  8026dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026df:	8b 40 04             	mov    0x4(%eax),%eax
  8026e2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026ea:	8b 40 04             	mov    0x4(%eax),%eax
  8026ed:	85 c0                	test   %eax,%eax
  8026ef:	74 0f                	je     802700 <alloc_block_BF+0x90>
  8026f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026f4:	8b 40 04             	mov    0x4(%eax),%eax
  8026f7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026fa:	8b 12                	mov    (%edx),%edx
  8026fc:	89 10                	mov    %edx,(%eax)
  8026fe:	eb 0a                	jmp    80270a <alloc_block_BF+0x9a>
  802700:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802703:	8b 00                	mov    (%eax),%eax
  802705:	a3 38 41 80 00       	mov    %eax,0x804138
  80270a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80270d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802713:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802716:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80271d:	a1 44 41 80 00       	mov    0x804144,%eax
  802722:	48                   	dec    %eax
  802723:	a3 44 41 80 00       	mov    %eax,0x804144
	   return temp;
  802728:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80272b:	e9 41 01 00 00       	jmp    802871 <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  802730:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802733:	8b 40 0c             	mov    0xc(%eax),%eax
  802736:	3b 45 08             	cmp    0x8(%ebp),%eax
  802739:	76 21                	jbe    80275c <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  80273b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80273e:	8b 40 0c             	mov    0xc(%eax),%eax
  802741:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802744:	73 16                	jae    80275c <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  802746:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802749:	8b 40 0c             	mov    0xc(%eax),%eax
  80274c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  80274f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802752:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  802755:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  80275c:	a1 40 41 80 00       	mov    0x804140,%eax
  802761:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802764:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802768:	74 07                	je     802771 <alloc_block_BF+0x101>
  80276a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80276d:	8b 00                	mov    (%eax),%eax
  80276f:	eb 05                	jmp    802776 <alloc_block_BF+0x106>
  802771:	b8 00 00 00 00       	mov    $0x0,%eax
  802776:	a3 40 41 80 00       	mov    %eax,0x804140
  80277b:	a1 40 41 80 00       	mov    0x804140,%eax
  802780:	85 c0                	test   %eax,%eax
  802782:	0f 85 09 ff ff ff    	jne    802691 <alloc_block_BF+0x21>
  802788:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80278c:	0f 85 ff fe ff ff    	jne    802691 <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  802792:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  802796:	0f 85 d0 00 00 00    	jne    80286c <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  80279c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80279f:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a2:	2b 45 08             	sub    0x8(%ebp),%eax
  8027a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  8027a8:	a1 48 41 80 00       	mov    0x804148,%eax
  8027ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  8027b0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8027b4:	75 17                	jne    8027cd <alloc_block_BF+0x15d>
  8027b6:	83 ec 04             	sub    $0x4,%esp
  8027b9:	68 48 3c 80 00       	push   $0x803c48
  8027be:	68 d1 00 00 00       	push   $0xd1
  8027c3:	68 d7 3b 80 00       	push   $0x803bd7
  8027c8:	e8 e9 da ff ff       	call   8002b6 <_panic>
  8027cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027d0:	8b 00                	mov    (%eax),%eax
  8027d2:	85 c0                	test   %eax,%eax
  8027d4:	74 10                	je     8027e6 <alloc_block_BF+0x176>
  8027d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027d9:	8b 00                	mov    (%eax),%eax
  8027db:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027de:	8b 52 04             	mov    0x4(%edx),%edx
  8027e1:	89 50 04             	mov    %edx,0x4(%eax)
  8027e4:	eb 0b                	jmp    8027f1 <alloc_block_BF+0x181>
  8027e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027e9:	8b 40 04             	mov    0x4(%eax),%eax
  8027ec:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8027f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027f4:	8b 40 04             	mov    0x4(%eax),%eax
  8027f7:	85 c0                	test   %eax,%eax
  8027f9:	74 0f                	je     80280a <alloc_block_BF+0x19a>
  8027fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027fe:	8b 40 04             	mov    0x4(%eax),%eax
  802801:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802804:	8b 12                	mov    (%edx),%edx
  802806:	89 10                	mov    %edx,(%eax)
  802808:	eb 0a                	jmp    802814 <alloc_block_BF+0x1a4>
  80280a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80280d:	8b 00                	mov    (%eax),%eax
  80280f:	a3 48 41 80 00       	mov    %eax,0x804148
  802814:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802817:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80281d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802820:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802827:	a1 54 41 80 00       	mov    0x804154,%eax
  80282c:	48                   	dec    %eax
  80282d:	a3 54 41 80 00       	mov    %eax,0x804154
	  // setting the size & sva
	  new_block->size = size;
  802832:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802835:	8b 55 08             	mov    0x8(%ebp),%edx
  802838:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  80283b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80283e:	8b 50 08             	mov    0x8(%eax),%edx
  802841:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802844:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  802847:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80284a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80284d:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  802850:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802853:	8b 50 08             	mov    0x8(%eax),%edx
  802856:	8b 45 08             	mov    0x8(%ebp),%eax
  802859:	01 c2                	add    %eax,%edx
  80285b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80285e:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  802861:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802864:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  802867:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80286a:	eb 05                	jmp    802871 <alloc_block_BF+0x201>
	 }
	 return NULL;
  80286c:	b8 00 00 00 00       	mov    $0x0,%eax


}
  802871:	c9                   	leave  
  802872:	c3                   	ret    

00802873 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802873:	55                   	push   %ebp
  802874:	89 e5                	mov    %esp,%ebp
  802876:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802879:	83 ec 04             	sub    $0x4,%esp
  80287c:	68 68 3c 80 00       	push   $0x803c68
  802881:	68 e8 00 00 00       	push   $0xe8
  802886:	68 d7 3b 80 00       	push   $0x803bd7
  80288b:	e8 26 da ff ff       	call   8002b6 <_panic>

00802890 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802890:	55                   	push   %ebp
  802891:	89 e5                	mov    %esp,%ebp
  802893:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  802896:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80289b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  80289e:	a1 38 41 80 00       	mov    0x804138,%eax
  8028a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  8028a6:	a1 44 41 80 00       	mov    0x804144,%eax
  8028ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  8028ae:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028b2:	75 68                	jne    80291c <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8028b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028b8:	75 17                	jne    8028d1 <insert_sorted_with_merge_freeList+0x41>
  8028ba:	83 ec 04             	sub    $0x4,%esp
  8028bd:	68 b4 3b 80 00       	push   $0x803bb4
  8028c2:	68 36 01 00 00       	push   $0x136
  8028c7:	68 d7 3b 80 00       	push   $0x803bd7
  8028cc:	e8 e5 d9 ff ff       	call   8002b6 <_panic>
  8028d1:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8028d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028da:	89 10                	mov    %edx,(%eax)
  8028dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028df:	8b 00                	mov    (%eax),%eax
  8028e1:	85 c0                	test   %eax,%eax
  8028e3:	74 0d                	je     8028f2 <insert_sorted_with_merge_freeList+0x62>
  8028e5:	a1 38 41 80 00       	mov    0x804138,%eax
  8028ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8028ed:	89 50 04             	mov    %edx,0x4(%eax)
  8028f0:	eb 08                	jmp    8028fa <insert_sorted_with_merge_freeList+0x6a>
  8028f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fd:	a3 38 41 80 00       	mov    %eax,0x804138
  802902:	8b 45 08             	mov    0x8(%ebp),%eax
  802905:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80290c:	a1 44 41 80 00       	mov    0x804144,%eax
  802911:	40                   	inc    %eax
  802912:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802917:	e9 ba 06 00 00       	jmp    802fd6 <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  80291c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291f:	8b 50 08             	mov    0x8(%eax),%edx
  802922:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802925:	8b 40 0c             	mov    0xc(%eax),%eax
  802928:	01 c2                	add    %eax,%edx
  80292a:	8b 45 08             	mov    0x8(%ebp),%eax
  80292d:	8b 40 08             	mov    0x8(%eax),%eax
  802930:	39 c2                	cmp    %eax,%edx
  802932:	73 68                	jae    80299c <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802934:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802938:	75 17                	jne    802951 <insert_sorted_with_merge_freeList+0xc1>
  80293a:	83 ec 04             	sub    $0x4,%esp
  80293d:	68 f0 3b 80 00       	push   $0x803bf0
  802942:	68 3a 01 00 00       	push   $0x13a
  802947:	68 d7 3b 80 00       	push   $0x803bd7
  80294c:	e8 65 d9 ff ff       	call   8002b6 <_panic>
  802951:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802957:	8b 45 08             	mov    0x8(%ebp),%eax
  80295a:	89 50 04             	mov    %edx,0x4(%eax)
  80295d:	8b 45 08             	mov    0x8(%ebp),%eax
  802960:	8b 40 04             	mov    0x4(%eax),%eax
  802963:	85 c0                	test   %eax,%eax
  802965:	74 0c                	je     802973 <insert_sorted_with_merge_freeList+0xe3>
  802967:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80296c:	8b 55 08             	mov    0x8(%ebp),%edx
  80296f:	89 10                	mov    %edx,(%eax)
  802971:	eb 08                	jmp    80297b <insert_sorted_with_merge_freeList+0xeb>
  802973:	8b 45 08             	mov    0x8(%ebp),%eax
  802976:	a3 38 41 80 00       	mov    %eax,0x804138
  80297b:	8b 45 08             	mov    0x8(%ebp),%eax
  80297e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802983:	8b 45 08             	mov    0x8(%ebp),%eax
  802986:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80298c:	a1 44 41 80 00       	mov    0x804144,%eax
  802991:	40                   	inc    %eax
  802992:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802997:	e9 3a 06 00 00       	jmp    802fd6 <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  80299c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80299f:	8b 50 08             	mov    0x8(%eax),%edx
  8029a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8029a8:	01 c2                	add    %eax,%edx
  8029aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ad:	8b 40 08             	mov    0x8(%eax),%eax
  8029b0:	39 c2                	cmp    %eax,%edx
  8029b2:	0f 85 90 00 00 00    	jne    802a48 <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  8029b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029bb:	8b 50 0c             	mov    0xc(%eax),%edx
  8029be:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8029c4:	01 c2                	add    %eax,%edx
  8029c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c9:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  8029cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  8029d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8029e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029e4:	75 17                	jne    8029fd <insert_sorted_with_merge_freeList+0x16d>
  8029e6:	83 ec 04             	sub    $0x4,%esp
  8029e9:	68 b4 3b 80 00       	push   $0x803bb4
  8029ee:	68 41 01 00 00       	push   $0x141
  8029f3:	68 d7 3b 80 00       	push   $0x803bd7
  8029f8:	e8 b9 d8 ff ff       	call   8002b6 <_panic>
  8029fd:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a03:	8b 45 08             	mov    0x8(%ebp),%eax
  802a06:	89 10                	mov    %edx,(%eax)
  802a08:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0b:	8b 00                	mov    (%eax),%eax
  802a0d:	85 c0                	test   %eax,%eax
  802a0f:	74 0d                	je     802a1e <insert_sorted_with_merge_freeList+0x18e>
  802a11:	a1 48 41 80 00       	mov    0x804148,%eax
  802a16:	8b 55 08             	mov    0x8(%ebp),%edx
  802a19:	89 50 04             	mov    %edx,0x4(%eax)
  802a1c:	eb 08                	jmp    802a26 <insert_sorted_with_merge_freeList+0x196>
  802a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a21:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a26:	8b 45 08             	mov    0x8(%ebp),%eax
  802a29:	a3 48 41 80 00       	mov    %eax,0x804148
  802a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a31:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a38:	a1 54 41 80 00       	mov    0x804154,%eax
  802a3d:	40                   	inc    %eax
  802a3e:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802a43:	e9 8e 05 00 00       	jmp    802fd6 <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  802a48:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4b:	8b 50 08             	mov    0x8(%eax),%edx
  802a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a51:	8b 40 0c             	mov    0xc(%eax),%eax
  802a54:	01 c2                	add    %eax,%edx
  802a56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a59:	8b 40 08             	mov    0x8(%eax),%eax
  802a5c:	39 c2                	cmp    %eax,%edx
  802a5e:	73 68                	jae    802ac8 <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802a60:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a64:	75 17                	jne    802a7d <insert_sorted_with_merge_freeList+0x1ed>
  802a66:	83 ec 04             	sub    $0x4,%esp
  802a69:	68 b4 3b 80 00       	push   $0x803bb4
  802a6e:	68 45 01 00 00       	push   $0x145
  802a73:	68 d7 3b 80 00       	push   $0x803bd7
  802a78:	e8 39 d8 ff ff       	call   8002b6 <_panic>
  802a7d:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a83:	8b 45 08             	mov    0x8(%ebp),%eax
  802a86:	89 10                	mov    %edx,(%eax)
  802a88:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8b:	8b 00                	mov    (%eax),%eax
  802a8d:	85 c0                	test   %eax,%eax
  802a8f:	74 0d                	je     802a9e <insert_sorted_with_merge_freeList+0x20e>
  802a91:	a1 38 41 80 00       	mov    0x804138,%eax
  802a96:	8b 55 08             	mov    0x8(%ebp),%edx
  802a99:	89 50 04             	mov    %edx,0x4(%eax)
  802a9c:	eb 08                	jmp    802aa6 <insert_sorted_with_merge_freeList+0x216>
  802a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa1:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa9:	a3 38 41 80 00       	mov    %eax,0x804138
  802aae:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ab8:	a1 44 41 80 00       	mov    0x804144,%eax
  802abd:	40                   	inc    %eax
  802abe:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802ac3:	e9 0e 05 00 00       	jmp    802fd6 <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  802ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  802acb:	8b 50 08             	mov    0x8(%eax),%edx
  802ace:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ad4:	01 c2                	add    %eax,%edx
  802ad6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad9:	8b 40 08             	mov    0x8(%eax),%eax
  802adc:	39 c2                	cmp    %eax,%edx
  802ade:	0f 85 9c 00 00 00    	jne    802b80 <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  802ae4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae7:	8b 50 0c             	mov    0xc(%eax),%edx
  802aea:	8b 45 08             	mov    0x8(%ebp),%eax
  802aed:	8b 40 0c             	mov    0xc(%eax),%eax
  802af0:	01 c2                	add    %eax,%edx
  802af2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af5:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  802af8:	8b 45 08             	mov    0x8(%ebp),%eax
  802afb:	8b 50 08             	mov    0x8(%eax),%edx
  802afe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b01:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  802b04:	8b 45 08             	mov    0x8(%ebp),%eax
  802b07:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  802b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b11:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802b18:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b1c:	75 17                	jne    802b35 <insert_sorted_with_merge_freeList+0x2a5>
  802b1e:	83 ec 04             	sub    $0x4,%esp
  802b21:	68 b4 3b 80 00       	push   $0x803bb4
  802b26:	68 4d 01 00 00       	push   $0x14d
  802b2b:	68 d7 3b 80 00       	push   $0x803bd7
  802b30:	e8 81 d7 ff ff       	call   8002b6 <_panic>
  802b35:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3e:	89 10                	mov    %edx,(%eax)
  802b40:	8b 45 08             	mov    0x8(%ebp),%eax
  802b43:	8b 00                	mov    (%eax),%eax
  802b45:	85 c0                	test   %eax,%eax
  802b47:	74 0d                	je     802b56 <insert_sorted_with_merge_freeList+0x2c6>
  802b49:	a1 48 41 80 00       	mov    0x804148,%eax
  802b4e:	8b 55 08             	mov    0x8(%ebp),%edx
  802b51:	89 50 04             	mov    %edx,0x4(%eax)
  802b54:	eb 08                	jmp    802b5e <insert_sorted_with_merge_freeList+0x2ce>
  802b56:	8b 45 08             	mov    0x8(%ebp),%eax
  802b59:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b61:	a3 48 41 80 00       	mov    %eax,0x804148
  802b66:	8b 45 08             	mov    0x8(%ebp),%eax
  802b69:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b70:	a1 54 41 80 00       	mov    0x804154,%eax
  802b75:	40                   	inc    %eax
  802b76:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802b7b:	e9 56 04 00 00       	jmp    802fd6 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802b80:	a1 38 41 80 00       	mov    0x804138,%eax
  802b85:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b88:	e9 19 04 00 00       	jmp    802fa6 <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  802b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b90:	8b 00                	mov    (%eax),%eax
  802b92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b98:	8b 50 08             	mov    0x8(%eax),%edx
  802b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9e:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba1:	01 c2                	add    %eax,%edx
  802ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba6:	8b 40 08             	mov    0x8(%eax),%eax
  802ba9:	39 c2                	cmp    %eax,%edx
  802bab:	0f 85 ad 01 00 00    	jne    802d5e <insert_sorted_with_merge_freeList+0x4ce>
  802bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb4:	8b 50 08             	mov    0x8(%eax),%edx
  802bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bba:	8b 40 0c             	mov    0xc(%eax),%eax
  802bbd:	01 c2                	add    %eax,%edx
  802bbf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bc2:	8b 40 08             	mov    0x8(%eax),%eax
  802bc5:	39 c2                	cmp    %eax,%edx
  802bc7:	0f 85 91 01 00 00    	jne    802d5e <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  802bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd0:	8b 50 0c             	mov    0xc(%eax),%edx
  802bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd6:	8b 48 0c             	mov    0xc(%eax),%ecx
  802bd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bdc:	8b 40 0c             	mov    0xc(%eax),%eax
  802bdf:	01 c8                	add    %ecx,%eax
  802be1:	01 c2                	add    %eax,%edx
  802be3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be6:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  802be9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bec:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  802bfd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c00:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  802c07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c0a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  802c11:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802c15:	75 17                	jne    802c2e <insert_sorted_with_merge_freeList+0x39e>
  802c17:	83 ec 04             	sub    $0x4,%esp
  802c1a:	68 48 3c 80 00       	push   $0x803c48
  802c1f:	68 5b 01 00 00       	push   $0x15b
  802c24:	68 d7 3b 80 00       	push   $0x803bd7
  802c29:	e8 88 d6 ff ff       	call   8002b6 <_panic>
  802c2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c31:	8b 00                	mov    (%eax),%eax
  802c33:	85 c0                	test   %eax,%eax
  802c35:	74 10                	je     802c47 <insert_sorted_with_merge_freeList+0x3b7>
  802c37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c3a:	8b 00                	mov    (%eax),%eax
  802c3c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c3f:	8b 52 04             	mov    0x4(%edx),%edx
  802c42:	89 50 04             	mov    %edx,0x4(%eax)
  802c45:	eb 0b                	jmp    802c52 <insert_sorted_with_merge_freeList+0x3c2>
  802c47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c4a:	8b 40 04             	mov    0x4(%eax),%eax
  802c4d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c55:	8b 40 04             	mov    0x4(%eax),%eax
  802c58:	85 c0                	test   %eax,%eax
  802c5a:	74 0f                	je     802c6b <insert_sorted_with_merge_freeList+0x3db>
  802c5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c5f:	8b 40 04             	mov    0x4(%eax),%eax
  802c62:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c65:	8b 12                	mov    (%edx),%edx
  802c67:	89 10                	mov    %edx,(%eax)
  802c69:	eb 0a                	jmp    802c75 <insert_sorted_with_merge_freeList+0x3e5>
  802c6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c6e:	8b 00                	mov    (%eax),%eax
  802c70:	a3 38 41 80 00       	mov    %eax,0x804138
  802c75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c78:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c81:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c88:	a1 44 41 80 00       	mov    0x804144,%eax
  802c8d:	48                   	dec    %eax
  802c8e:	a3 44 41 80 00       	mov    %eax,0x804144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802c93:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c97:	75 17                	jne    802cb0 <insert_sorted_with_merge_freeList+0x420>
  802c99:	83 ec 04             	sub    $0x4,%esp
  802c9c:	68 b4 3b 80 00       	push   $0x803bb4
  802ca1:	68 5c 01 00 00       	push   $0x15c
  802ca6:	68 d7 3b 80 00       	push   $0x803bd7
  802cab:	e8 06 d6 ff ff       	call   8002b6 <_panic>
  802cb0:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb9:	89 10                	mov    %edx,(%eax)
  802cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbe:	8b 00                	mov    (%eax),%eax
  802cc0:	85 c0                	test   %eax,%eax
  802cc2:	74 0d                	je     802cd1 <insert_sorted_with_merge_freeList+0x441>
  802cc4:	a1 48 41 80 00       	mov    0x804148,%eax
  802cc9:	8b 55 08             	mov    0x8(%ebp),%edx
  802ccc:	89 50 04             	mov    %edx,0x4(%eax)
  802ccf:	eb 08                	jmp    802cd9 <insert_sorted_with_merge_freeList+0x449>
  802cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdc:	a3 48 41 80 00       	mov    %eax,0x804148
  802ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ceb:	a1 54 41 80 00       	mov    0x804154,%eax
  802cf0:	40                   	inc    %eax
  802cf1:	a3 54 41 80 00       	mov    %eax,0x804154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  802cf6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802cfa:	75 17                	jne    802d13 <insert_sorted_with_merge_freeList+0x483>
  802cfc:	83 ec 04             	sub    $0x4,%esp
  802cff:	68 b4 3b 80 00       	push   $0x803bb4
  802d04:	68 5d 01 00 00       	push   $0x15d
  802d09:	68 d7 3b 80 00       	push   $0x803bd7
  802d0e:	e8 a3 d5 ff ff       	call   8002b6 <_panic>
  802d13:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d1c:	89 10                	mov    %edx,(%eax)
  802d1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d21:	8b 00                	mov    (%eax),%eax
  802d23:	85 c0                	test   %eax,%eax
  802d25:	74 0d                	je     802d34 <insert_sorted_with_merge_freeList+0x4a4>
  802d27:	a1 48 41 80 00       	mov    0x804148,%eax
  802d2c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d2f:	89 50 04             	mov    %edx,0x4(%eax)
  802d32:	eb 08                	jmp    802d3c <insert_sorted_with_merge_freeList+0x4ac>
  802d34:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d37:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d3f:	a3 48 41 80 00       	mov    %eax,0x804148
  802d44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d47:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d4e:	a1 54 41 80 00       	mov    0x804154,%eax
  802d53:	40                   	inc    %eax
  802d54:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802d59:	e9 78 02 00 00       	jmp    802fd6 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d61:	8b 50 08             	mov    0x8(%eax),%edx
  802d64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d67:	8b 40 0c             	mov    0xc(%eax),%eax
  802d6a:	01 c2                	add    %eax,%edx
  802d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6f:	8b 40 08             	mov    0x8(%eax),%eax
  802d72:	39 c2                	cmp    %eax,%edx
  802d74:	0f 83 b8 00 00 00    	jae    802e32 <insert_sorted_with_merge_freeList+0x5a2>
  802d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7d:	8b 50 08             	mov    0x8(%eax),%edx
  802d80:	8b 45 08             	mov    0x8(%ebp),%eax
  802d83:	8b 40 0c             	mov    0xc(%eax),%eax
  802d86:	01 c2                	add    %eax,%edx
  802d88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d8b:	8b 40 08             	mov    0x8(%eax),%eax
  802d8e:	39 c2                	cmp    %eax,%edx
  802d90:	0f 85 9c 00 00 00    	jne    802e32 <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  802d96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d99:	8b 50 0c             	mov    0xc(%eax),%edx
  802d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9f:	8b 40 0c             	mov    0xc(%eax),%eax
  802da2:	01 c2                	add    %eax,%edx
  802da4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802da7:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  802daa:	8b 45 08             	mov    0x8(%ebp),%eax
  802dad:	8b 50 08             	mov    0x8(%eax),%edx
  802db0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802db3:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  802db6:	8b 45 08             	mov    0x8(%ebp),%eax
  802db9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802dca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dce:	75 17                	jne    802de7 <insert_sorted_with_merge_freeList+0x557>
  802dd0:	83 ec 04             	sub    $0x4,%esp
  802dd3:	68 b4 3b 80 00       	push   $0x803bb4
  802dd8:	68 67 01 00 00       	push   $0x167
  802ddd:	68 d7 3b 80 00       	push   $0x803bd7
  802de2:	e8 cf d4 ff ff       	call   8002b6 <_panic>
  802de7:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ded:	8b 45 08             	mov    0x8(%ebp),%eax
  802df0:	89 10                	mov    %edx,(%eax)
  802df2:	8b 45 08             	mov    0x8(%ebp),%eax
  802df5:	8b 00                	mov    (%eax),%eax
  802df7:	85 c0                	test   %eax,%eax
  802df9:	74 0d                	je     802e08 <insert_sorted_with_merge_freeList+0x578>
  802dfb:	a1 48 41 80 00       	mov    0x804148,%eax
  802e00:	8b 55 08             	mov    0x8(%ebp),%edx
  802e03:	89 50 04             	mov    %edx,0x4(%eax)
  802e06:	eb 08                	jmp    802e10 <insert_sorted_with_merge_freeList+0x580>
  802e08:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e10:	8b 45 08             	mov    0x8(%ebp),%eax
  802e13:	a3 48 41 80 00       	mov    %eax,0x804148
  802e18:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e22:	a1 54 41 80 00       	mov    0x804154,%eax
  802e27:	40                   	inc    %eax
  802e28:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802e2d:	e9 a4 01 00 00       	jmp    802fd6 <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802e32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e35:	8b 50 08             	mov    0x8(%eax),%edx
  802e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e3e:	01 c2                	add    %eax,%edx
  802e40:	8b 45 08             	mov    0x8(%ebp),%eax
  802e43:	8b 40 08             	mov    0x8(%eax),%eax
  802e46:	39 c2                	cmp    %eax,%edx
  802e48:	0f 85 ac 00 00 00    	jne    802efa <insert_sorted_with_merge_freeList+0x66a>
  802e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e51:	8b 50 08             	mov    0x8(%eax),%edx
  802e54:	8b 45 08             	mov    0x8(%ebp),%eax
  802e57:	8b 40 0c             	mov    0xc(%eax),%eax
  802e5a:	01 c2                	add    %eax,%edx
  802e5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e5f:	8b 40 08             	mov    0x8(%eax),%eax
  802e62:	39 c2                	cmp    %eax,%edx
  802e64:	0f 83 90 00 00 00    	jae    802efa <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  802e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6d:	8b 50 0c             	mov    0xc(%eax),%edx
  802e70:	8b 45 08             	mov    0x8(%ebp),%eax
  802e73:	8b 40 0c             	mov    0xc(%eax),%eax
  802e76:	01 c2                	add    %eax,%edx
  802e78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7b:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  802e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e81:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  802e88:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e92:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e96:	75 17                	jne    802eaf <insert_sorted_with_merge_freeList+0x61f>
  802e98:	83 ec 04             	sub    $0x4,%esp
  802e9b:	68 b4 3b 80 00       	push   $0x803bb4
  802ea0:	68 70 01 00 00       	push   $0x170
  802ea5:	68 d7 3b 80 00       	push   $0x803bd7
  802eaa:	e8 07 d4 ff ff       	call   8002b6 <_panic>
  802eaf:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb8:	89 10                	mov    %edx,(%eax)
  802eba:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebd:	8b 00                	mov    (%eax),%eax
  802ebf:	85 c0                	test   %eax,%eax
  802ec1:	74 0d                	je     802ed0 <insert_sorted_with_merge_freeList+0x640>
  802ec3:	a1 48 41 80 00       	mov    0x804148,%eax
  802ec8:	8b 55 08             	mov    0x8(%ebp),%edx
  802ecb:	89 50 04             	mov    %edx,0x4(%eax)
  802ece:	eb 08                	jmp    802ed8 <insert_sorted_with_merge_freeList+0x648>
  802ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  802edb:	a3 48 41 80 00       	mov    %eax,0x804148
  802ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eea:	a1 54 41 80 00       	mov    0x804154,%eax
  802eef:	40                   	inc    %eax
  802ef0:	a3 54 41 80 00       	mov    %eax,0x804154
	      break;
  802ef5:	e9 dc 00 00 00       	jmp    802fd6 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efd:	8b 50 08             	mov    0x8(%eax),%edx
  802f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f03:	8b 40 0c             	mov    0xc(%eax),%eax
  802f06:	01 c2                	add    %eax,%edx
  802f08:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0b:	8b 40 08             	mov    0x8(%eax),%eax
  802f0e:	39 c2                	cmp    %eax,%edx
  802f10:	0f 83 88 00 00 00    	jae    802f9e <insert_sorted_with_merge_freeList+0x70e>
  802f16:	8b 45 08             	mov    0x8(%ebp),%eax
  802f19:	8b 50 08             	mov    0x8(%eax),%edx
  802f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1f:	8b 40 0c             	mov    0xc(%eax),%eax
  802f22:	01 c2                	add    %eax,%edx
  802f24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f27:	8b 40 08             	mov    0x8(%eax),%eax
  802f2a:	39 c2                	cmp    %eax,%edx
  802f2c:	73 70                	jae    802f9e <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  802f2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f32:	74 06                	je     802f3a <insert_sorted_with_merge_freeList+0x6aa>
  802f34:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f38:	75 17                	jne    802f51 <insert_sorted_with_merge_freeList+0x6c1>
  802f3a:	83 ec 04             	sub    $0x4,%esp
  802f3d:	68 14 3c 80 00       	push   $0x803c14
  802f42:	68 75 01 00 00       	push   $0x175
  802f47:	68 d7 3b 80 00       	push   $0x803bd7
  802f4c:	e8 65 d3 ff ff       	call   8002b6 <_panic>
  802f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f54:	8b 10                	mov    (%eax),%edx
  802f56:	8b 45 08             	mov    0x8(%ebp),%eax
  802f59:	89 10                	mov    %edx,(%eax)
  802f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5e:	8b 00                	mov    (%eax),%eax
  802f60:	85 c0                	test   %eax,%eax
  802f62:	74 0b                	je     802f6f <insert_sorted_with_merge_freeList+0x6df>
  802f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f67:	8b 00                	mov    (%eax),%eax
  802f69:	8b 55 08             	mov    0x8(%ebp),%edx
  802f6c:	89 50 04             	mov    %edx,0x4(%eax)
  802f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f72:	8b 55 08             	mov    0x8(%ebp),%edx
  802f75:	89 10                	mov    %edx,(%eax)
  802f77:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f7d:	89 50 04             	mov    %edx,0x4(%eax)
  802f80:	8b 45 08             	mov    0x8(%ebp),%eax
  802f83:	8b 00                	mov    (%eax),%eax
  802f85:	85 c0                	test   %eax,%eax
  802f87:	75 08                	jne    802f91 <insert_sorted_with_merge_freeList+0x701>
  802f89:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f91:	a1 44 41 80 00       	mov    0x804144,%eax
  802f96:	40                   	inc    %eax
  802f97:	a3 44 41 80 00       	mov    %eax,0x804144
	      break;
  802f9c:	eb 38                	jmp    802fd6 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802f9e:	a1 40 41 80 00       	mov    0x804140,%eax
  802fa3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fa6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802faa:	74 07                	je     802fb3 <insert_sorted_with_merge_freeList+0x723>
  802fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802faf:	8b 00                	mov    (%eax),%eax
  802fb1:	eb 05                	jmp    802fb8 <insert_sorted_with_merge_freeList+0x728>
  802fb3:	b8 00 00 00 00       	mov    $0x0,%eax
  802fb8:	a3 40 41 80 00       	mov    %eax,0x804140
  802fbd:	a1 40 41 80 00       	mov    0x804140,%eax
  802fc2:	85 c0                	test   %eax,%eax
  802fc4:	0f 85 c3 fb ff ff    	jne    802b8d <insert_sorted_with_merge_freeList+0x2fd>
  802fca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fce:	0f 85 b9 fb ff ff    	jne    802b8d <insert_sorted_with_merge_freeList+0x2fd>





}
  802fd4:	eb 00                	jmp    802fd6 <insert_sorted_with_merge_freeList+0x746>
  802fd6:	90                   	nop
  802fd7:	c9                   	leave  
  802fd8:	c3                   	ret    

00802fd9 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802fd9:	55                   	push   %ebp
  802fda:	89 e5                	mov    %esp,%ebp
  802fdc:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  802fdf:	8b 55 08             	mov    0x8(%ebp),%edx
  802fe2:	89 d0                	mov    %edx,%eax
  802fe4:	c1 e0 02             	shl    $0x2,%eax
  802fe7:	01 d0                	add    %edx,%eax
  802fe9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802ff0:	01 d0                	add    %edx,%eax
  802ff2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802ff9:	01 d0                	add    %edx,%eax
  802ffb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803002:	01 d0                	add    %edx,%eax
  803004:	c1 e0 04             	shl    $0x4,%eax
  803007:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80300a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803011:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803014:	83 ec 0c             	sub    $0xc,%esp
  803017:	50                   	push   %eax
  803018:	e8 31 ec ff ff       	call   801c4e <sys_get_virtual_time>
  80301d:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803020:	eb 41                	jmp    803063 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803022:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803025:	83 ec 0c             	sub    $0xc,%esp
  803028:	50                   	push   %eax
  803029:	e8 20 ec ff ff       	call   801c4e <sys_get_virtual_time>
  80302e:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803031:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803034:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803037:	29 c2                	sub    %eax,%edx
  803039:	89 d0                	mov    %edx,%eax
  80303b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80303e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803041:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803044:	89 d1                	mov    %edx,%ecx
  803046:	29 c1                	sub    %eax,%ecx
  803048:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80304b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80304e:	39 c2                	cmp    %eax,%edx
  803050:	0f 97 c0             	seta   %al
  803053:	0f b6 c0             	movzbl %al,%eax
  803056:	29 c1                	sub    %eax,%ecx
  803058:	89 c8                	mov    %ecx,%eax
  80305a:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80305d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803060:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803063:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803066:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803069:	72 b7                	jb     803022 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80306b:	90                   	nop
  80306c:	c9                   	leave  
  80306d:	c3                   	ret    

0080306e <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80306e:	55                   	push   %ebp
  80306f:	89 e5                	mov    %esp,%ebp
  803071:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803074:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80307b:	eb 03                	jmp    803080 <busy_wait+0x12>
  80307d:	ff 45 fc             	incl   -0x4(%ebp)
  803080:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803083:	3b 45 08             	cmp    0x8(%ebp),%eax
  803086:	72 f5                	jb     80307d <busy_wait+0xf>
	return i;
  803088:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80308b:	c9                   	leave  
  80308c:	c3                   	ret    
  80308d:	66 90                	xchg   %ax,%ax
  80308f:	90                   	nop

00803090 <__udivdi3>:
  803090:	55                   	push   %ebp
  803091:	57                   	push   %edi
  803092:	56                   	push   %esi
  803093:	53                   	push   %ebx
  803094:	83 ec 1c             	sub    $0x1c,%esp
  803097:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80309b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80309f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8030a3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8030a7:	89 ca                	mov    %ecx,%edx
  8030a9:	89 f8                	mov    %edi,%eax
  8030ab:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8030af:	85 f6                	test   %esi,%esi
  8030b1:	75 2d                	jne    8030e0 <__udivdi3+0x50>
  8030b3:	39 cf                	cmp    %ecx,%edi
  8030b5:	77 65                	ja     80311c <__udivdi3+0x8c>
  8030b7:	89 fd                	mov    %edi,%ebp
  8030b9:	85 ff                	test   %edi,%edi
  8030bb:	75 0b                	jne    8030c8 <__udivdi3+0x38>
  8030bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8030c2:	31 d2                	xor    %edx,%edx
  8030c4:	f7 f7                	div    %edi
  8030c6:	89 c5                	mov    %eax,%ebp
  8030c8:	31 d2                	xor    %edx,%edx
  8030ca:	89 c8                	mov    %ecx,%eax
  8030cc:	f7 f5                	div    %ebp
  8030ce:	89 c1                	mov    %eax,%ecx
  8030d0:	89 d8                	mov    %ebx,%eax
  8030d2:	f7 f5                	div    %ebp
  8030d4:	89 cf                	mov    %ecx,%edi
  8030d6:	89 fa                	mov    %edi,%edx
  8030d8:	83 c4 1c             	add    $0x1c,%esp
  8030db:	5b                   	pop    %ebx
  8030dc:	5e                   	pop    %esi
  8030dd:	5f                   	pop    %edi
  8030de:	5d                   	pop    %ebp
  8030df:	c3                   	ret    
  8030e0:	39 ce                	cmp    %ecx,%esi
  8030e2:	77 28                	ja     80310c <__udivdi3+0x7c>
  8030e4:	0f bd fe             	bsr    %esi,%edi
  8030e7:	83 f7 1f             	xor    $0x1f,%edi
  8030ea:	75 40                	jne    80312c <__udivdi3+0x9c>
  8030ec:	39 ce                	cmp    %ecx,%esi
  8030ee:	72 0a                	jb     8030fa <__udivdi3+0x6a>
  8030f0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8030f4:	0f 87 9e 00 00 00    	ja     803198 <__udivdi3+0x108>
  8030fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8030ff:	89 fa                	mov    %edi,%edx
  803101:	83 c4 1c             	add    $0x1c,%esp
  803104:	5b                   	pop    %ebx
  803105:	5e                   	pop    %esi
  803106:	5f                   	pop    %edi
  803107:	5d                   	pop    %ebp
  803108:	c3                   	ret    
  803109:	8d 76 00             	lea    0x0(%esi),%esi
  80310c:	31 ff                	xor    %edi,%edi
  80310e:	31 c0                	xor    %eax,%eax
  803110:	89 fa                	mov    %edi,%edx
  803112:	83 c4 1c             	add    $0x1c,%esp
  803115:	5b                   	pop    %ebx
  803116:	5e                   	pop    %esi
  803117:	5f                   	pop    %edi
  803118:	5d                   	pop    %ebp
  803119:	c3                   	ret    
  80311a:	66 90                	xchg   %ax,%ax
  80311c:	89 d8                	mov    %ebx,%eax
  80311e:	f7 f7                	div    %edi
  803120:	31 ff                	xor    %edi,%edi
  803122:	89 fa                	mov    %edi,%edx
  803124:	83 c4 1c             	add    $0x1c,%esp
  803127:	5b                   	pop    %ebx
  803128:	5e                   	pop    %esi
  803129:	5f                   	pop    %edi
  80312a:	5d                   	pop    %ebp
  80312b:	c3                   	ret    
  80312c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803131:	89 eb                	mov    %ebp,%ebx
  803133:	29 fb                	sub    %edi,%ebx
  803135:	89 f9                	mov    %edi,%ecx
  803137:	d3 e6                	shl    %cl,%esi
  803139:	89 c5                	mov    %eax,%ebp
  80313b:	88 d9                	mov    %bl,%cl
  80313d:	d3 ed                	shr    %cl,%ebp
  80313f:	89 e9                	mov    %ebp,%ecx
  803141:	09 f1                	or     %esi,%ecx
  803143:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803147:	89 f9                	mov    %edi,%ecx
  803149:	d3 e0                	shl    %cl,%eax
  80314b:	89 c5                	mov    %eax,%ebp
  80314d:	89 d6                	mov    %edx,%esi
  80314f:	88 d9                	mov    %bl,%cl
  803151:	d3 ee                	shr    %cl,%esi
  803153:	89 f9                	mov    %edi,%ecx
  803155:	d3 e2                	shl    %cl,%edx
  803157:	8b 44 24 08          	mov    0x8(%esp),%eax
  80315b:	88 d9                	mov    %bl,%cl
  80315d:	d3 e8                	shr    %cl,%eax
  80315f:	09 c2                	or     %eax,%edx
  803161:	89 d0                	mov    %edx,%eax
  803163:	89 f2                	mov    %esi,%edx
  803165:	f7 74 24 0c          	divl   0xc(%esp)
  803169:	89 d6                	mov    %edx,%esi
  80316b:	89 c3                	mov    %eax,%ebx
  80316d:	f7 e5                	mul    %ebp
  80316f:	39 d6                	cmp    %edx,%esi
  803171:	72 19                	jb     80318c <__udivdi3+0xfc>
  803173:	74 0b                	je     803180 <__udivdi3+0xf0>
  803175:	89 d8                	mov    %ebx,%eax
  803177:	31 ff                	xor    %edi,%edi
  803179:	e9 58 ff ff ff       	jmp    8030d6 <__udivdi3+0x46>
  80317e:	66 90                	xchg   %ax,%ax
  803180:	8b 54 24 08          	mov    0x8(%esp),%edx
  803184:	89 f9                	mov    %edi,%ecx
  803186:	d3 e2                	shl    %cl,%edx
  803188:	39 c2                	cmp    %eax,%edx
  80318a:	73 e9                	jae    803175 <__udivdi3+0xe5>
  80318c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80318f:	31 ff                	xor    %edi,%edi
  803191:	e9 40 ff ff ff       	jmp    8030d6 <__udivdi3+0x46>
  803196:	66 90                	xchg   %ax,%ax
  803198:	31 c0                	xor    %eax,%eax
  80319a:	e9 37 ff ff ff       	jmp    8030d6 <__udivdi3+0x46>
  80319f:	90                   	nop

008031a0 <__umoddi3>:
  8031a0:	55                   	push   %ebp
  8031a1:	57                   	push   %edi
  8031a2:	56                   	push   %esi
  8031a3:	53                   	push   %ebx
  8031a4:	83 ec 1c             	sub    $0x1c,%esp
  8031a7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8031ab:	8b 74 24 34          	mov    0x34(%esp),%esi
  8031af:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8031b3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8031b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8031bb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8031bf:	89 f3                	mov    %esi,%ebx
  8031c1:	89 fa                	mov    %edi,%edx
  8031c3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8031c7:	89 34 24             	mov    %esi,(%esp)
  8031ca:	85 c0                	test   %eax,%eax
  8031cc:	75 1a                	jne    8031e8 <__umoddi3+0x48>
  8031ce:	39 f7                	cmp    %esi,%edi
  8031d0:	0f 86 a2 00 00 00    	jbe    803278 <__umoddi3+0xd8>
  8031d6:	89 c8                	mov    %ecx,%eax
  8031d8:	89 f2                	mov    %esi,%edx
  8031da:	f7 f7                	div    %edi
  8031dc:	89 d0                	mov    %edx,%eax
  8031de:	31 d2                	xor    %edx,%edx
  8031e0:	83 c4 1c             	add    $0x1c,%esp
  8031e3:	5b                   	pop    %ebx
  8031e4:	5e                   	pop    %esi
  8031e5:	5f                   	pop    %edi
  8031e6:	5d                   	pop    %ebp
  8031e7:	c3                   	ret    
  8031e8:	39 f0                	cmp    %esi,%eax
  8031ea:	0f 87 ac 00 00 00    	ja     80329c <__umoddi3+0xfc>
  8031f0:	0f bd e8             	bsr    %eax,%ebp
  8031f3:	83 f5 1f             	xor    $0x1f,%ebp
  8031f6:	0f 84 ac 00 00 00    	je     8032a8 <__umoddi3+0x108>
  8031fc:	bf 20 00 00 00       	mov    $0x20,%edi
  803201:	29 ef                	sub    %ebp,%edi
  803203:	89 fe                	mov    %edi,%esi
  803205:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803209:	89 e9                	mov    %ebp,%ecx
  80320b:	d3 e0                	shl    %cl,%eax
  80320d:	89 d7                	mov    %edx,%edi
  80320f:	89 f1                	mov    %esi,%ecx
  803211:	d3 ef                	shr    %cl,%edi
  803213:	09 c7                	or     %eax,%edi
  803215:	89 e9                	mov    %ebp,%ecx
  803217:	d3 e2                	shl    %cl,%edx
  803219:	89 14 24             	mov    %edx,(%esp)
  80321c:	89 d8                	mov    %ebx,%eax
  80321e:	d3 e0                	shl    %cl,%eax
  803220:	89 c2                	mov    %eax,%edx
  803222:	8b 44 24 08          	mov    0x8(%esp),%eax
  803226:	d3 e0                	shl    %cl,%eax
  803228:	89 44 24 04          	mov    %eax,0x4(%esp)
  80322c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803230:	89 f1                	mov    %esi,%ecx
  803232:	d3 e8                	shr    %cl,%eax
  803234:	09 d0                	or     %edx,%eax
  803236:	d3 eb                	shr    %cl,%ebx
  803238:	89 da                	mov    %ebx,%edx
  80323a:	f7 f7                	div    %edi
  80323c:	89 d3                	mov    %edx,%ebx
  80323e:	f7 24 24             	mull   (%esp)
  803241:	89 c6                	mov    %eax,%esi
  803243:	89 d1                	mov    %edx,%ecx
  803245:	39 d3                	cmp    %edx,%ebx
  803247:	0f 82 87 00 00 00    	jb     8032d4 <__umoddi3+0x134>
  80324d:	0f 84 91 00 00 00    	je     8032e4 <__umoddi3+0x144>
  803253:	8b 54 24 04          	mov    0x4(%esp),%edx
  803257:	29 f2                	sub    %esi,%edx
  803259:	19 cb                	sbb    %ecx,%ebx
  80325b:	89 d8                	mov    %ebx,%eax
  80325d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803261:	d3 e0                	shl    %cl,%eax
  803263:	89 e9                	mov    %ebp,%ecx
  803265:	d3 ea                	shr    %cl,%edx
  803267:	09 d0                	or     %edx,%eax
  803269:	89 e9                	mov    %ebp,%ecx
  80326b:	d3 eb                	shr    %cl,%ebx
  80326d:	89 da                	mov    %ebx,%edx
  80326f:	83 c4 1c             	add    $0x1c,%esp
  803272:	5b                   	pop    %ebx
  803273:	5e                   	pop    %esi
  803274:	5f                   	pop    %edi
  803275:	5d                   	pop    %ebp
  803276:	c3                   	ret    
  803277:	90                   	nop
  803278:	89 fd                	mov    %edi,%ebp
  80327a:	85 ff                	test   %edi,%edi
  80327c:	75 0b                	jne    803289 <__umoddi3+0xe9>
  80327e:	b8 01 00 00 00       	mov    $0x1,%eax
  803283:	31 d2                	xor    %edx,%edx
  803285:	f7 f7                	div    %edi
  803287:	89 c5                	mov    %eax,%ebp
  803289:	89 f0                	mov    %esi,%eax
  80328b:	31 d2                	xor    %edx,%edx
  80328d:	f7 f5                	div    %ebp
  80328f:	89 c8                	mov    %ecx,%eax
  803291:	f7 f5                	div    %ebp
  803293:	89 d0                	mov    %edx,%eax
  803295:	e9 44 ff ff ff       	jmp    8031de <__umoddi3+0x3e>
  80329a:	66 90                	xchg   %ax,%ax
  80329c:	89 c8                	mov    %ecx,%eax
  80329e:	89 f2                	mov    %esi,%edx
  8032a0:	83 c4 1c             	add    $0x1c,%esp
  8032a3:	5b                   	pop    %ebx
  8032a4:	5e                   	pop    %esi
  8032a5:	5f                   	pop    %edi
  8032a6:	5d                   	pop    %ebp
  8032a7:	c3                   	ret    
  8032a8:	3b 04 24             	cmp    (%esp),%eax
  8032ab:	72 06                	jb     8032b3 <__umoddi3+0x113>
  8032ad:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8032b1:	77 0f                	ja     8032c2 <__umoddi3+0x122>
  8032b3:	89 f2                	mov    %esi,%edx
  8032b5:	29 f9                	sub    %edi,%ecx
  8032b7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8032bb:	89 14 24             	mov    %edx,(%esp)
  8032be:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8032c2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8032c6:	8b 14 24             	mov    (%esp),%edx
  8032c9:	83 c4 1c             	add    $0x1c,%esp
  8032cc:	5b                   	pop    %ebx
  8032cd:	5e                   	pop    %esi
  8032ce:	5f                   	pop    %edi
  8032cf:	5d                   	pop    %ebp
  8032d0:	c3                   	ret    
  8032d1:	8d 76 00             	lea    0x0(%esi),%esi
  8032d4:	2b 04 24             	sub    (%esp),%eax
  8032d7:	19 fa                	sbb    %edi,%edx
  8032d9:	89 d1                	mov    %edx,%ecx
  8032db:	89 c6                	mov    %eax,%esi
  8032dd:	e9 71 ff ff ff       	jmp    803253 <__umoddi3+0xb3>
  8032e2:	66 90                	xchg   %ax,%ax
  8032e4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8032e8:	72 ea                	jb     8032d4 <__umoddi3+0x134>
  8032ea:	89 d9                	mov    %ebx,%ecx
  8032ec:	e9 62 ff ff ff       	jmp    803253 <__umoddi3+0xb3>
