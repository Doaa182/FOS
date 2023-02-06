
obj/user/tst_sharing_5_slave:     file format elf32-i386


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
  800031:	e8 ff 00 00 00       	call   800135 <libmain>
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
  800098:	e8 d4 01 00 00       	call   800271 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009d:	83 ec 0c             	sub    $0xc,%esp
  8000a0:	6a 00                	push   $0x0
  8000a2:	e8 f7 13 00 00       	call   80149e <malloc>
  8000a7:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int expected;
	uint32 *x;
	x = sget(sys_getparentenvid(),"x");
  8000aa:	e8 27 1b 00 00       	call   801bd6 <sys_getparentenvid>
  8000af:	83 ec 08             	sub    $0x8,%esp
  8000b2:	68 37 32 80 00       	push   $0x803237
  8000b7:	50                   	push   %eax
  8000b8:	e8 fb 15 00 00       	call   8016b8 <sget>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  8000c3:	e8 15 18 00 00       	call   8018dd <sys_calculate_free_frames>
  8000c8:	89 45 e8             	mov    %eax,-0x18(%ebp)

	cprintf("Slave env used x (getSharedObject)\n");
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	68 3c 32 80 00       	push   $0x80323c
  8000d3:	e8 4d 04 00 00       	call   800525 <cprintf>
  8000d8:	83 c4 10             	add    $0x10,%esp

	sfree(x);
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	ff 75 ec             	pushl  -0x14(%ebp)
  8000e1:	e8 97 16 00 00       	call   80177d <sfree>
  8000e6:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave env removed x\n");
  8000e9:	83 ec 0c             	sub    $0xc,%esp
  8000ec:	68 60 32 80 00       	push   $0x803260
  8000f1:	e8 2f 04 00 00       	call   800525 <cprintf>
  8000f6:	83 c4 10             	add    $0x10,%esp

	int diff = (sys_calculate_free_frames() - freeFrames);
  8000f9:	e8 df 17 00 00       	call   8018dd <sys_calculate_free_frames>
  8000fe:	89 c2                	mov    %eax,%edx
  800100:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800103:	29 c2                	sub    %eax,%edx
  800105:	89 d0                	mov    %edx,%eax
  800107:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	expected = 1;
  80010a:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
	if (diff != expected) panic("wrong free: frames removed not equal 1 !, correct frames to be removed is 1:\nfrom the env: 1 table for x\nframes_storage: not cleared yet\n");
  800111:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800114:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800117:	74 14                	je     80012d <_main+0xf5>
  800119:	83 ec 04             	sub    $0x4,%esp
  80011c:	68 78 32 80 00       	push   $0x803278
  800121:	6a 24                	push   $0x24
  800123:	68 1c 32 80 00       	push   $0x80321c
  800128:	e8 44 01 00 00       	call   800271 <_panic>

	//to ensure that this environment is completed successfully
	inctst();
  80012d:	e8 c9 1b 00 00       	call   801cfb <inctst>

	return;
  800132:	90                   	nop
}
  800133:	c9                   	leave  
  800134:	c3                   	ret    

00800135 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800135:	55                   	push   %ebp
  800136:	89 e5                	mov    %esp,%ebp
  800138:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80013b:	e8 7d 1a 00 00       	call   801bbd <sys_getenvindex>
  800140:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800143:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800146:	89 d0                	mov    %edx,%eax
  800148:	c1 e0 03             	shl    $0x3,%eax
  80014b:	01 d0                	add    %edx,%eax
  80014d:	01 c0                	add    %eax,%eax
  80014f:	01 d0                	add    %edx,%eax
  800151:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800158:	01 d0                	add    %edx,%eax
  80015a:	c1 e0 04             	shl    $0x4,%eax
  80015d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800162:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800167:	a1 20 40 80 00       	mov    0x804020,%eax
  80016c:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800172:	84 c0                	test   %al,%al
  800174:	74 0f                	je     800185 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800176:	a1 20 40 80 00       	mov    0x804020,%eax
  80017b:	05 5c 05 00 00       	add    $0x55c,%eax
  800180:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800185:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800189:	7e 0a                	jle    800195 <libmain+0x60>
		binaryname = argv[0];
  80018b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80018e:	8b 00                	mov    (%eax),%eax
  800190:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800195:	83 ec 08             	sub    $0x8,%esp
  800198:	ff 75 0c             	pushl  0xc(%ebp)
  80019b:	ff 75 08             	pushl  0x8(%ebp)
  80019e:	e8 95 fe ff ff       	call   800038 <_main>
  8001a3:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001a6:	e8 1f 18 00 00       	call   8019ca <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	68 1c 33 80 00       	push   $0x80331c
  8001b3:	e8 6d 03 00 00       	call   800525 <cprintf>
  8001b8:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001bb:	a1 20 40 80 00       	mov    0x804020,%eax
  8001c0:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001c6:	a1 20 40 80 00       	mov    0x804020,%eax
  8001cb:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001d1:	83 ec 04             	sub    $0x4,%esp
  8001d4:	52                   	push   %edx
  8001d5:	50                   	push   %eax
  8001d6:	68 44 33 80 00       	push   $0x803344
  8001db:	e8 45 03 00 00       	call   800525 <cprintf>
  8001e0:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001e3:	a1 20 40 80 00       	mov    0x804020,%eax
  8001e8:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8001ee:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f3:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8001f9:	a1 20 40 80 00       	mov    0x804020,%eax
  8001fe:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800204:	51                   	push   %ecx
  800205:	52                   	push   %edx
  800206:	50                   	push   %eax
  800207:	68 6c 33 80 00       	push   $0x80336c
  80020c:	e8 14 03 00 00       	call   800525 <cprintf>
  800211:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800214:	a1 20 40 80 00       	mov    0x804020,%eax
  800219:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80021f:	83 ec 08             	sub    $0x8,%esp
  800222:	50                   	push   %eax
  800223:	68 c4 33 80 00       	push   $0x8033c4
  800228:	e8 f8 02 00 00       	call   800525 <cprintf>
  80022d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800230:	83 ec 0c             	sub    $0xc,%esp
  800233:	68 1c 33 80 00       	push   $0x80331c
  800238:	e8 e8 02 00 00       	call   800525 <cprintf>
  80023d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800240:	e8 9f 17 00 00       	call   8019e4 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800245:	e8 19 00 00 00       	call   800263 <exit>
}
  80024a:	90                   	nop
  80024b:	c9                   	leave  
  80024c:	c3                   	ret    

0080024d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80024d:	55                   	push   %ebp
  80024e:	89 e5                	mov    %esp,%ebp
  800250:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800253:	83 ec 0c             	sub    $0xc,%esp
  800256:	6a 00                	push   $0x0
  800258:	e8 2c 19 00 00       	call   801b89 <sys_destroy_env>
  80025d:	83 c4 10             	add    $0x10,%esp
}
  800260:	90                   	nop
  800261:	c9                   	leave  
  800262:	c3                   	ret    

00800263 <exit>:

void
exit(void)
{
  800263:	55                   	push   %ebp
  800264:	89 e5                	mov    %esp,%ebp
  800266:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800269:	e8 81 19 00 00       	call   801bef <sys_exit_env>
}
  80026e:	90                   	nop
  80026f:	c9                   	leave  
  800270:	c3                   	ret    

00800271 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800271:	55                   	push   %ebp
  800272:	89 e5                	mov    %esp,%ebp
  800274:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800277:	8d 45 10             	lea    0x10(%ebp),%eax
  80027a:	83 c0 04             	add    $0x4,%eax
  80027d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800280:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800285:	85 c0                	test   %eax,%eax
  800287:	74 16                	je     80029f <_panic+0x2e>
		cprintf("%s: ", argv0);
  800289:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80028e:	83 ec 08             	sub    $0x8,%esp
  800291:	50                   	push   %eax
  800292:	68 d8 33 80 00       	push   $0x8033d8
  800297:	e8 89 02 00 00       	call   800525 <cprintf>
  80029c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80029f:	a1 00 40 80 00       	mov    0x804000,%eax
  8002a4:	ff 75 0c             	pushl  0xc(%ebp)
  8002a7:	ff 75 08             	pushl  0x8(%ebp)
  8002aa:	50                   	push   %eax
  8002ab:	68 dd 33 80 00       	push   $0x8033dd
  8002b0:	e8 70 02 00 00       	call   800525 <cprintf>
  8002b5:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8002bb:	83 ec 08             	sub    $0x8,%esp
  8002be:	ff 75 f4             	pushl  -0xc(%ebp)
  8002c1:	50                   	push   %eax
  8002c2:	e8 f3 01 00 00       	call   8004ba <vcprintf>
  8002c7:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002ca:	83 ec 08             	sub    $0x8,%esp
  8002cd:	6a 00                	push   $0x0
  8002cf:	68 f9 33 80 00       	push   $0x8033f9
  8002d4:	e8 e1 01 00 00       	call   8004ba <vcprintf>
  8002d9:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002dc:	e8 82 ff ff ff       	call   800263 <exit>

	// should not return here
	while (1) ;
  8002e1:	eb fe                	jmp    8002e1 <_panic+0x70>

008002e3 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002e3:	55                   	push   %ebp
  8002e4:	89 e5                	mov    %esp,%ebp
  8002e6:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002e9:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ee:	8b 50 74             	mov    0x74(%eax),%edx
  8002f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f4:	39 c2                	cmp    %eax,%edx
  8002f6:	74 14                	je     80030c <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002f8:	83 ec 04             	sub    $0x4,%esp
  8002fb:	68 fc 33 80 00       	push   $0x8033fc
  800300:	6a 26                	push   $0x26
  800302:	68 48 34 80 00       	push   $0x803448
  800307:	e8 65 ff ff ff       	call   800271 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80030c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800313:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80031a:	e9 c2 00 00 00       	jmp    8003e1 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80031f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800322:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800329:	8b 45 08             	mov    0x8(%ebp),%eax
  80032c:	01 d0                	add    %edx,%eax
  80032e:	8b 00                	mov    (%eax),%eax
  800330:	85 c0                	test   %eax,%eax
  800332:	75 08                	jne    80033c <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800334:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800337:	e9 a2 00 00 00       	jmp    8003de <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80033c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800343:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80034a:	eb 69                	jmp    8003b5 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80034c:	a1 20 40 80 00       	mov    0x804020,%eax
  800351:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800357:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80035a:	89 d0                	mov    %edx,%eax
  80035c:	01 c0                	add    %eax,%eax
  80035e:	01 d0                	add    %edx,%eax
  800360:	c1 e0 03             	shl    $0x3,%eax
  800363:	01 c8                	add    %ecx,%eax
  800365:	8a 40 04             	mov    0x4(%eax),%al
  800368:	84 c0                	test   %al,%al
  80036a:	75 46                	jne    8003b2 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80036c:	a1 20 40 80 00       	mov    0x804020,%eax
  800371:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800377:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80037a:	89 d0                	mov    %edx,%eax
  80037c:	01 c0                	add    %eax,%eax
  80037e:	01 d0                	add    %edx,%eax
  800380:	c1 e0 03             	shl    $0x3,%eax
  800383:	01 c8                	add    %ecx,%eax
  800385:	8b 00                	mov    (%eax),%eax
  800387:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80038a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80038d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800392:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800394:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800397:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80039e:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a1:	01 c8                	add    %ecx,%eax
  8003a3:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003a5:	39 c2                	cmp    %eax,%edx
  8003a7:	75 09                	jne    8003b2 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003a9:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003b0:	eb 12                	jmp    8003c4 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003b2:	ff 45 e8             	incl   -0x18(%ebp)
  8003b5:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ba:	8b 50 74             	mov    0x74(%eax),%edx
  8003bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003c0:	39 c2                	cmp    %eax,%edx
  8003c2:	77 88                	ja     80034c <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003c8:	75 14                	jne    8003de <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003ca:	83 ec 04             	sub    $0x4,%esp
  8003cd:	68 54 34 80 00       	push   $0x803454
  8003d2:	6a 3a                	push   $0x3a
  8003d4:	68 48 34 80 00       	push   $0x803448
  8003d9:	e8 93 fe ff ff       	call   800271 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003de:	ff 45 f0             	incl   -0x10(%ebp)
  8003e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003e7:	0f 8c 32 ff ff ff    	jl     80031f <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003ed:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003f4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003fb:	eb 26                	jmp    800423 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8003fd:	a1 20 40 80 00       	mov    0x804020,%eax
  800402:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800408:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80040b:	89 d0                	mov    %edx,%eax
  80040d:	01 c0                	add    %eax,%eax
  80040f:	01 d0                	add    %edx,%eax
  800411:	c1 e0 03             	shl    $0x3,%eax
  800414:	01 c8                	add    %ecx,%eax
  800416:	8a 40 04             	mov    0x4(%eax),%al
  800419:	3c 01                	cmp    $0x1,%al
  80041b:	75 03                	jne    800420 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80041d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800420:	ff 45 e0             	incl   -0x20(%ebp)
  800423:	a1 20 40 80 00       	mov    0x804020,%eax
  800428:	8b 50 74             	mov    0x74(%eax),%edx
  80042b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80042e:	39 c2                	cmp    %eax,%edx
  800430:	77 cb                	ja     8003fd <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800432:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800435:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800438:	74 14                	je     80044e <CheckWSWithoutLastIndex+0x16b>
		panic(
  80043a:	83 ec 04             	sub    $0x4,%esp
  80043d:	68 a8 34 80 00       	push   $0x8034a8
  800442:	6a 44                	push   $0x44
  800444:	68 48 34 80 00       	push   $0x803448
  800449:	e8 23 fe ff ff       	call   800271 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80044e:	90                   	nop
  80044f:	c9                   	leave  
  800450:	c3                   	ret    

00800451 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800451:	55                   	push   %ebp
  800452:	89 e5                	mov    %esp,%ebp
  800454:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800457:	8b 45 0c             	mov    0xc(%ebp),%eax
  80045a:	8b 00                	mov    (%eax),%eax
  80045c:	8d 48 01             	lea    0x1(%eax),%ecx
  80045f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800462:	89 0a                	mov    %ecx,(%edx)
  800464:	8b 55 08             	mov    0x8(%ebp),%edx
  800467:	88 d1                	mov    %dl,%cl
  800469:	8b 55 0c             	mov    0xc(%ebp),%edx
  80046c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800470:	8b 45 0c             	mov    0xc(%ebp),%eax
  800473:	8b 00                	mov    (%eax),%eax
  800475:	3d ff 00 00 00       	cmp    $0xff,%eax
  80047a:	75 2c                	jne    8004a8 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80047c:	a0 24 40 80 00       	mov    0x804024,%al
  800481:	0f b6 c0             	movzbl %al,%eax
  800484:	8b 55 0c             	mov    0xc(%ebp),%edx
  800487:	8b 12                	mov    (%edx),%edx
  800489:	89 d1                	mov    %edx,%ecx
  80048b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80048e:	83 c2 08             	add    $0x8,%edx
  800491:	83 ec 04             	sub    $0x4,%esp
  800494:	50                   	push   %eax
  800495:	51                   	push   %ecx
  800496:	52                   	push   %edx
  800497:	e8 80 13 00 00       	call   80181c <sys_cputs>
  80049c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80049f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ab:	8b 40 04             	mov    0x4(%eax),%eax
  8004ae:	8d 50 01             	lea    0x1(%eax),%edx
  8004b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b4:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004b7:	90                   	nop
  8004b8:	c9                   	leave  
  8004b9:	c3                   	ret    

008004ba <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004ba:	55                   	push   %ebp
  8004bb:	89 e5                	mov    %esp,%ebp
  8004bd:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004c3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004ca:	00 00 00 
	b.cnt = 0;
  8004cd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004d4:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004d7:	ff 75 0c             	pushl  0xc(%ebp)
  8004da:	ff 75 08             	pushl  0x8(%ebp)
  8004dd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004e3:	50                   	push   %eax
  8004e4:	68 51 04 80 00       	push   $0x800451
  8004e9:	e8 11 02 00 00       	call   8006ff <vprintfmt>
  8004ee:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004f1:	a0 24 40 80 00       	mov    0x804024,%al
  8004f6:	0f b6 c0             	movzbl %al,%eax
  8004f9:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8004ff:	83 ec 04             	sub    $0x4,%esp
  800502:	50                   	push   %eax
  800503:	52                   	push   %edx
  800504:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80050a:	83 c0 08             	add    $0x8,%eax
  80050d:	50                   	push   %eax
  80050e:	e8 09 13 00 00       	call   80181c <sys_cputs>
  800513:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800516:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80051d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800523:	c9                   	leave  
  800524:	c3                   	ret    

00800525 <cprintf>:

int cprintf(const char *fmt, ...) {
  800525:	55                   	push   %ebp
  800526:	89 e5                	mov    %esp,%ebp
  800528:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80052b:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800532:	8d 45 0c             	lea    0xc(%ebp),%eax
  800535:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800538:	8b 45 08             	mov    0x8(%ebp),%eax
  80053b:	83 ec 08             	sub    $0x8,%esp
  80053e:	ff 75 f4             	pushl  -0xc(%ebp)
  800541:	50                   	push   %eax
  800542:	e8 73 ff ff ff       	call   8004ba <vcprintf>
  800547:	83 c4 10             	add    $0x10,%esp
  80054a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80054d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800550:	c9                   	leave  
  800551:	c3                   	ret    

00800552 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800552:	55                   	push   %ebp
  800553:	89 e5                	mov    %esp,%ebp
  800555:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800558:	e8 6d 14 00 00       	call   8019ca <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80055d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800560:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800563:	8b 45 08             	mov    0x8(%ebp),%eax
  800566:	83 ec 08             	sub    $0x8,%esp
  800569:	ff 75 f4             	pushl  -0xc(%ebp)
  80056c:	50                   	push   %eax
  80056d:	e8 48 ff ff ff       	call   8004ba <vcprintf>
  800572:	83 c4 10             	add    $0x10,%esp
  800575:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800578:	e8 67 14 00 00       	call   8019e4 <sys_enable_interrupt>
	return cnt;
  80057d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800580:	c9                   	leave  
  800581:	c3                   	ret    

00800582 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800582:	55                   	push   %ebp
  800583:	89 e5                	mov    %esp,%ebp
  800585:	53                   	push   %ebx
  800586:	83 ec 14             	sub    $0x14,%esp
  800589:	8b 45 10             	mov    0x10(%ebp),%eax
  80058c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80058f:	8b 45 14             	mov    0x14(%ebp),%eax
  800592:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800595:	8b 45 18             	mov    0x18(%ebp),%eax
  800598:	ba 00 00 00 00       	mov    $0x0,%edx
  80059d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005a0:	77 55                	ja     8005f7 <printnum+0x75>
  8005a2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005a5:	72 05                	jb     8005ac <printnum+0x2a>
  8005a7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005aa:	77 4b                	ja     8005f7 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005ac:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005af:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005b2:	8b 45 18             	mov    0x18(%ebp),%eax
  8005b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ba:	52                   	push   %edx
  8005bb:	50                   	push   %eax
  8005bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8005bf:	ff 75 f0             	pushl  -0x10(%ebp)
  8005c2:	e8 cd 29 00 00       	call   802f94 <__udivdi3>
  8005c7:	83 c4 10             	add    $0x10,%esp
  8005ca:	83 ec 04             	sub    $0x4,%esp
  8005cd:	ff 75 20             	pushl  0x20(%ebp)
  8005d0:	53                   	push   %ebx
  8005d1:	ff 75 18             	pushl  0x18(%ebp)
  8005d4:	52                   	push   %edx
  8005d5:	50                   	push   %eax
  8005d6:	ff 75 0c             	pushl  0xc(%ebp)
  8005d9:	ff 75 08             	pushl  0x8(%ebp)
  8005dc:	e8 a1 ff ff ff       	call   800582 <printnum>
  8005e1:	83 c4 20             	add    $0x20,%esp
  8005e4:	eb 1a                	jmp    800600 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005e6:	83 ec 08             	sub    $0x8,%esp
  8005e9:	ff 75 0c             	pushl  0xc(%ebp)
  8005ec:	ff 75 20             	pushl  0x20(%ebp)
  8005ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f2:	ff d0                	call   *%eax
  8005f4:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005f7:	ff 4d 1c             	decl   0x1c(%ebp)
  8005fa:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8005fe:	7f e6                	jg     8005e6 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800600:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800603:	bb 00 00 00 00       	mov    $0x0,%ebx
  800608:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80060b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80060e:	53                   	push   %ebx
  80060f:	51                   	push   %ecx
  800610:	52                   	push   %edx
  800611:	50                   	push   %eax
  800612:	e8 8d 2a 00 00       	call   8030a4 <__umoddi3>
  800617:	83 c4 10             	add    $0x10,%esp
  80061a:	05 14 37 80 00       	add    $0x803714,%eax
  80061f:	8a 00                	mov    (%eax),%al
  800621:	0f be c0             	movsbl %al,%eax
  800624:	83 ec 08             	sub    $0x8,%esp
  800627:	ff 75 0c             	pushl  0xc(%ebp)
  80062a:	50                   	push   %eax
  80062b:	8b 45 08             	mov    0x8(%ebp),%eax
  80062e:	ff d0                	call   *%eax
  800630:	83 c4 10             	add    $0x10,%esp
}
  800633:	90                   	nop
  800634:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800637:	c9                   	leave  
  800638:	c3                   	ret    

00800639 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800639:	55                   	push   %ebp
  80063a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80063c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800640:	7e 1c                	jle    80065e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800642:	8b 45 08             	mov    0x8(%ebp),%eax
  800645:	8b 00                	mov    (%eax),%eax
  800647:	8d 50 08             	lea    0x8(%eax),%edx
  80064a:	8b 45 08             	mov    0x8(%ebp),%eax
  80064d:	89 10                	mov    %edx,(%eax)
  80064f:	8b 45 08             	mov    0x8(%ebp),%eax
  800652:	8b 00                	mov    (%eax),%eax
  800654:	83 e8 08             	sub    $0x8,%eax
  800657:	8b 50 04             	mov    0x4(%eax),%edx
  80065a:	8b 00                	mov    (%eax),%eax
  80065c:	eb 40                	jmp    80069e <getuint+0x65>
	else if (lflag)
  80065e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800662:	74 1e                	je     800682 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800664:	8b 45 08             	mov    0x8(%ebp),%eax
  800667:	8b 00                	mov    (%eax),%eax
  800669:	8d 50 04             	lea    0x4(%eax),%edx
  80066c:	8b 45 08             	mov    0x8(%ebp),%eax
  80066f:	89 10                	mov    %edx,(%eax)
  800671:	8b 45 08             	mov    0x8(%ebp),%eax
  800674:	8b 00                	mov    (%eax),%eax
  800676:	83 e8 04             	sub    $0x4,%eax
  800679:	8b 00                	mov    (%eax),%eax
  80067b:	ba 00 00 00 00       	mov    $0x0,%edx
  800680:	eb 1c                	jmp    80069e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800682:	8b 45 08             	mov    0x8(%ebp),%eax
  800685:	8b 00                	mov    (%eax),%eax
  800687:	8d 50 04             	lea    0x4(%eax),%edx
  80068a:	8b 45 08             	mov    0x8(%ebp),%eax
  80068d:	89 10                	mov    %edx,(%eax)
  80068f:	8b 45 08             	mov    0x8(%ebp),%eax
  800692:	8b 00                	mov    (%eax),%eax
  800694:	83 e8 04             	sub    $0x4,%eax
  800697:	8b 00                	mov    (%eax),%eax
  800699:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80069e:	5d                   	pop    %ebp
  80069f:	c3                   	ret    

008006a0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006a0:	55                   	push   %ebp
  8006a1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006a3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006a7:	7e 1c                	jle    8006c5 <getint+0x25>
		return va_arg(*ap, long long);
  8006a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ac:	8b 00                	mov    (%eax),%eax
  8006ae:	8d 50 08             	lea    0x8(%eax),%edx
  8006b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b4:	89 10                	mov    %edx,(%eax)
  8006b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b9:	8b 00                	mov    (%eax),%eax
  8006bb:	83 e8 08             	sub    $0x8,%eax
  8006be:	8b 50 04             	mov    0x4(%eax),%edx
  8006c1:	8b 00                	mov    (%eax),%eax
  8006c3:	eb 38                	jmp    8006fd <getint+0x5d>
	else if (lflag)
  8006c5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006c9:	74 1a                	je     8006e5 <getint+0x45>
		return va_arg(*ap, long);
  8006cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ce:	8b 00                	mov    (%eax),%eax
  8006d0:	8d 50 04             	lea    0x4(%eax),%edx
  8006d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d6:	89 10                	mov    %edx,(%eax)
  8006d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006db:	8b 00                	mov    (%eax),%eax
  8006dd:	83 e8 04             	sub    $0x4,%eax
  8006e0:	8b 00                	mov    (%eax),%eax
  8006e2:	99                   	cltd   
  8006e3:	eb 18                	jmp    8006fd <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e8:	8b 00                	mov    (%eax),%eax
  8006ea:	8d 50 04             	lea    0x4(%eax),%edx
  8006ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f0:	89 10                	mov    %edx,(%eax)
  8006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f5:	8b 00                	mov    (%eax),%eax
  8006f7:	83 e8 04             	sub    $0x4,%eax
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	99                   	cltd   
}
  8006fd:	5d                   	pop    %ebp
  8006fe:	c3                   	ret    

008006ff <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006ff:	55                   	push   %ebp
  800700:	89 e5                	mov    %esp,%ebp
  800702:	56                   	push   %esi
  800703:	53                   	push   %ebx
  800704:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800707:	eb 17                	jmp    800720 <vprintfmt+0x21>
			if (ch == '\0')
  800709:	85 db                	test   %ebx,%ebx
  80070b:	0f 84 af 03 00 00    	je     800ac0 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800711:	83 ec 08             	sub    $0x8,%esp
  800714:	ff 75 0c             	pushl  0xc(%ebp)
  800717:	53                   	push   %ebx
  800718:	8b 45 08             	mov    0x8(%ebp),%eax
  80071b:	ff d0                	call   *%eax
  80071d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800720:	8b 45 10             	mov    0x10(%ebp),%eax
  800723:	8d 50 01             	lea    0x1(%eax),%edx
  800726:	89 55 10             	mov    %edx,0x10(%ebp)
  800729:	8a 00                	mov    (%eax),%al
  80072b:	0f b6 d8             	movzbl %al,%ebx
  80072e:	83 fb 25             	cmp    $0x25,%ebx
  800731:	75 d6                	jne    800709 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800733:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800737:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80073e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800745:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80074c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800753:	8b 45 10             	mov    0x10(%ebp),%eax
  800756:	8d 50 01             	lea    0x1(%eax),%edx
  800759:	89 55 10             	mov    %edx,0x10(%ebp)
  80075c:	8a 00                	mov    (%eax),%al
  80075e:	0f b6 d8             	movzbl %al,%ebx
  800761:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800764:	83 f8 55             	cmp    $0x55,%eax
  800767:	0f 87 2b 03 00 00    	ja     800a98 <vprintfmt+0x399>
  80076d:	8b 04 85 38 37 80 00 	mov    0x803738(,%eax,4),%eax
  800774:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800776:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80077a:	eb d7                	jmp    800753 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80077c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800780:	eb d1                	jmp    800753 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800782:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800789:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80078c:	89 d0                	mov    %edx,%eax
  80078e:	c1 e0 02             	shl    $0x2,%eax
  800791:	01 d0                	add    %edx,%eax
  800793:	01 c0                	add    %eax,%eax
  800795:	01 d8                	add    %ebx,%eax
  800797:	83 e8 30             	sub    $0x30,%eax
  80079a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80079d:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a0:	8a 00                	mov    (%eax),%al
  8007a2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007a5:	83 fb 2f             	cmp    $0x2f,%ebx
  8007a8:	7e 3e                	jle    8007e8 <vprintfmt+0xe9>
  8007aa:	83 fb 39             	cmp    $0x39,%ebx
  8007ad:	7f 39                	jg     8007e8 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007af:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007b2:	eb d5                	jmp    800789 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b7:	83 c0 04             	add    $0x4,%eax
  8007ba:	89 45 14             	mov    %eax,0x14(%ebp)
  8007bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c0:	83 e8 04             	sub    $0x4,%eax
  8007c3:	8b 00                	mov    (%eax),%eax
  8007c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007c8:	eb 1f                	jmp    8007e9 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ce:	79 83                	jns    800753 <vprintfmt+0x54>
				width = 0;
  8007d0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007d7:	e9 77 ff ff ff       	jmp    800753 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007dc:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007e3:	e9 6b ff ff ff       	jmp    800753 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007e8:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ed:	0f 89 60 ff ff ff    	jns    800753 <vprintfmt+0x54>
				width = precision, precision = -1;
  8007f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007f9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800800:	e9 4e ff ff ff       	jmp    800753 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800805:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800808:	e9 46 ff ff ff       	jmp    800753 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80080d:	8b 45 14             	mov    0x14(%ebp),%eax
  800810:	83 c0 04             	add    $0x4,%eax
  800813:	89 45 14             	mov    %eax,0x14(%ebp)
  800816:	8b 45 14             	mov    0x14(%ebp),%eax
  800819:	83 e8 04             	sub    $0x4,%eax
  80081c:	8b 00                	mov    (%eax),%eax
  80081e:	83 ec 08             	sub    $0x8,%esp
  800821:	ff 75 0c             	pushl  0xc(%ebp)
  800824:	50                   	push   %eax
  800825:	8b 45 08             	mov    0x8(%ebp),%eax
  800828:	ff d0                	call   *%eax
  80082a:	83 c4 10             	add    $0x10,%esp
			break;
  80082d:	e9 89 02 00 00       	jmp    800abb <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800832:	8b 45 14             	mov    0x14(%ebp),%eax
  800835:	83 c0 04             	add    $0x4,%eax
  800838:	89 45 14             	mov    %eax,0x14(%ebp)
  80083b:	8b 45 14             	mov    0x14(%ebp),%eax
  80083e:	83 e8 04             	sub    $0x4,%eax
  800841:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800843:	85 db                	test   %ebx,%ebx
  800845:	79 02                	jns    800849 <vprintfmt+0x14a>
				err = -err;
  800847:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800849:	83 fb 64             	cmp    $0x64,%ebx
  80084c:	7f 0b                	jg     800859 <vprintfmt+0x15a>
  80084e:	8b 34 9d 80 35 80 00 	mov    0x803580(,%ebx,4),%esi
  800855:	85 f6                	test   %esi,%esi
  800857:	75 19                	jne    800872 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800859:	53                   	push   %ebx
  80085a:	68 25 37 80 00       	push   $0x803725
  80085f:	ff 75 0c             	pushl  0xc(%ebp)
  800862:	ff 75 08             	pushl  0x8(%ebp)
  800865:	e8 5e 02 00 00       	call   800ac8 <printfmt>
  80086a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80086d:	e9 49 02 00 00       	jmp    800abb <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800872:	56                   	push   %esi
  800873:	68 2e 37 80 00       	push   $0x80372e
  800878:	ff 75 0c             	pushl  0xc(%ebp)
  80087b:	ff 75 08             	pushl  0x8(%ebp)
  80087e:	e8 45 02 00 00       	call   800ac8 <printfmt>
  800883:	83 c4 10             	add    $0x10,%esp
			break;
  800886:	e9 30 02 00 00       	jmp    800abb <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80088b:	8b 45 14             	mov    0x14(%ebp),%eax
  80088e:	83 c0 04             	add    $0x4,%eax
  800891:	89 45 14             	mov    %eax,0x14(%ebp)
  800894:	8b 45 14             	mov    0x14(%ebp),%eax
  800897:	83 e8 04             	sub    $0x4,%eax
  80089a:	8b 30                	mov    (%eax),%esi
  80089c:	85 f6                	test   %esi,%esi
  80089e:	75 05                	jne    8008a5 <vprintfmt+0x1a6>
				p = "(null)";
  8008a0:	be 31 37 80 00       	mov    $0x803731,%esi
			if (width > 0 && padc != '-')
  8008a5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008a9:	7e 6d                	jle    800918 <vprintfmt+0x219>
  8008ab:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008af:	74 67                	je     800918 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008b4:	83 ec 08             	sub    $0x8,%esp
  8008b7:	50                   	push   %eax
  8008b8:	56                   	push   %esi
  8008b9:	e8 0c 03 00 00       	call   800bca <strnlen>
  8008be:	83 c4 10             	add    $0x10,%esp
  8008c1:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008c4:	eb 16                	jmp    8008dc <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008c6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008ca:	83 ec 08             	sub    $0x8,%esp
  8008cd:	ff 75 0c             	pushl  0xc(%ebp)
  8008d0:	50                   	push   %eax
  8008d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d4:	ff d0                	call   *%eax
  8008d6:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008d9:	ff 4d e4             	decl   -0x1c(%ebp)
  8008dc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008e0:	7f e4                	jg     8008c6 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008e2:	eb 34                	jmp    800918 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008e4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008e8:	74 1c                	je     800906 <vprintfmt+0x207>
  8008ea:	83 fb 1f             	cmp    $0x1f,%ebx
  8008ed:	7e 05                	jle    8008f4 <vprintfmt+0x1f5>
  8008ef:	83 fb 7e             	cmp    $0x7e,%ebx
  8008f2:	7e 12                	jle    800906 <vprintfmt+0x207>
					putch('?', putdat);
  8008f4:	83 ec 08             	sub    $0x8,%esp
  8008f7:	ff 75 0c             	pushl  0xc(%ebp)
  8008fa:	6a 3f                	push   $0x3f
  8008fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ff:	ff d0                	call   *%eax
  800901:	83 c4 10             	add    $0x10,%esp
  800904:	eb 0f                	jmp    800915 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800906:	83 ec 08             	sub    $0x8,%esp
  800909:	ff 75 0c             	pushl  0xc(%ebp)
  80090c:	53                   	push   %ebx
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	ff d0                	call   *%eax
  800912:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800915:	ff 4d e4             	decl   -0x1c(%ebp)
  800918:	89 f0                	mov    %esi,%eax
  80091a:	8d 70 01             	lea    0x1(%eax),%esi
  80091d:	8a 00                	mov    (%eax),%al
  80091f:	0f be d8             	movsbl %al,%ebx
  800922:	85 db                	test   %ebx,%ebx
  800924:	74 24                	je     80094a <vprintfmt+0x24b>
  800926:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80092a:	78 b8                	js     8008e4 <vprintfmt+0x1e5>
  80092c:	ff 4d e0             	decl   -0x20(%ebp)
  80092f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800933:	79 af                	jns    8008e4 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800935:	eb 13                	jmp    80094a <vprintfmt+0x24b>
				putch(' ', putdat);
  800937:	83 ec 08             	sub    $0x8,%esp
  80093a:	ff 75 0c             	pushl  0xc(%ebp)
  80093d:	6a 20                	push   $0x20
  80093f:	8b 45 08             	mov    0x8(%ebp),%eax
  800942:	ff d0                	call   *%eax
  800944:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800947:	ff 4d e4             	decl   -0x1c(%ebp)
  80094a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80094e:	7f e7                	jg     800937 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800950:	e9 66 01 00 00       	jmp    800abb <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800955:	83 ec 08             	sub    $0x8,%esp
  800958:	ff 75 e8             	pushl  -0x18(%ebp)
  80095b:	8d 45 14             	lea    0x14(%ebp),%eax
  80095e:	50                   	push   %eax
  80095f:	e8 3c fd ff ff       	call   8006a0 <getint>
  800964:	83 c4 10             	add    $0x10,%esp
  800967:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80096a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80096d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800970:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800973:	85 d2                	test   %edx,%edx
  800975:	79 23                	jns    80099a <vprintfmt+0x29b>
				putch('-', putdat);
  800977:	83 ec 08             	sub    $0x8,%esp
  80097a:	ff 75 0c             	pushl  0xc(%ebp)
  80097d:	6a 2d                	push   $0x2d
  80097f:	8b 45 08             	mov    0x8(%ebp),%eax
  800982:	ff d0                	call   *%eax
  800984:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800987:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80098a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80098d:	f7 d8                	neg    %eax
  80098f:	83 d2 00             	adc    $0x0,%edx
  800992:	f7 da                	neg    %edx
  800994:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800997:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80099a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009a1:	e9 bc 00 00 00       	jmp    800a62 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009a6:	83 ec 08             	sub    $0x8,%esp
  8009a9:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ac:	8d 45 14             	lea    0x14(%ebp),%eax
  8009af:	50                   	push   %eax
  8009b0:	e8 84 fc ff ff       	call   800639 <getuint>
  8009b5:	83 c4 10             	add    $0x10,%esp
  8009b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009bb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009be:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009c5:	e9 98 00 00 00       	jmp    800a62 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009ca:	83 ec 08             	sub    $0x8,%esp
  8009cd:	ff 75 0c             	pushl  0xc(%ebp)
  8009d0:	6a 58                	push   $0x58
  8009d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d5:	ff d0                	call   *%eax
  8009d7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009da:	83 ec 08             	sub    $0x8,%esp
  8009dd:	ff 75 0c             	pushl  0xc(%ebp)
  8009e0:	6a 58                	push   $0x58
  8009e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e5:	ff d0                	call   *%eax
  8009e7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009ea:	83 ec 08             	sub    $0x8,%esp
  8009ed:	ff 75 0c             	pushl  0xc(%ebp)
  8009f0:	6a 58                	push   $0x58
  8009f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f5:	ff d0                	call   *%eax
  8009f7:	83 c4 10             	add    $0x10,%esp
			break;
  8009fa:	e9 bc 00 00 00       	jmp    800abb <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8009ff:	83 ec 08             	sub    $0x8,%esp
  800a02:	ff 75 0c             	pushl  0xc(%ebp)
  800a05:	6a 30                	push   $0x30
  800a07:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0a:	ff d0                	call   *%eax
  800a0c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a0f:	83 ec 08             	sub    $0x8,%esp
  800a12:	ff 75 0c             	pushl  0xc(%ebp)
  800a15:	6a 78                	push   $0x78
  800a17:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1a:	ff d0                	call   *%eax
  800a1c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a22:	83 c0 04             	add    $0x4,%eax
  800a25:	89 45 14             	mov    %eax,0x14(%ebp)
  800a28:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2b:	83 e8 04             	sub    $0x4,%eax
  800a2e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a33:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a3a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a41:	eb 1f                	jmp    800a62 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a43:	83 ec 08             	sub    $0x8,%esp
  800a46:	ff 75 e8             	pushl  -0x18(%ebp)
  800a49:	8d 45 14             	lea    0x14(%ebp),%eax
  800a4c:	50                   	push   %eax
  800a4d:	e8 e7 fb ff ff       	call   800639 <getuint>
  800a52:	83 c4 10             	add    $0x10,%esp
  800a55:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a58:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a5b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a62:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a69:	83 ec 04             	sub    $0x4,%esp
  800a6c:	52                   	push   %edx
  800a6d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a70:	50                   	push   %eax
  800a71:	ff 75 f4             	pushl  -0xc(%ebp)
  800a74:	ff 75 f0             	pushl  -0x10(%ebp)
  800a77:	ff 75 0c             	pushl  0xc(%ebp)
  800a7a:	ff 75 08             	pushl  0x8(%ebp)
  800a7d:	e8 00 fb ff ff       	call   800582 <printnum>
  800a82:	83 c4 20             	add    $0x20,%esp
			break;
  800a85:	eb 34                	jmp    800abb <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a87:	83 ec 08             	sub    $0x8,%esp
  800a8a:	ff 75 0c             	pushl  0xc(%ebp)
  800a8d:	53                   	push   %ebx
  800a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a91:	ff d0                	call   *%eax
  800a93:	83 c4 10             	add    $0x10,%esp
			break;
  800a96:	eb 23                	jmp    800abb <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a98:	83 ec 08             	sub    $0x8,%esp
  800a9b:	ff 75 0c             	pushl  0xc(%ebp)
  800a9e:	6a 25                	push   $0x25
  800aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa3:	ff d0                	call   *%eax
  800aa5:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aa8:	ff 4d 10             	decl   0x10(%ebp)
  800aab:	eb 03                	jmp    800ab0 <vprintfmt+0x3b1>
  800aad:	ff 4d 10             	decl   0x10(%ebp)
  800ab0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ab3:	48                   	dec    %eax
  800ab4:	8a 00                	mov    (%eax),%al
  800ab6:	3c 25                	cmp    $0x25,%al
  800ab8:	75 f3                	jne    800aad <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800aba:	90                   	nop
		}
	}
  800abb:	e9 47 fc ff ff       	jmp    800707 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ac0:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ac1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ac4:	5b                   	pop    %ebx
  800ac5:	5e                   	pop    %esi
  800ac6:	5d                   	pop    %ebp
  800ac7:	c3                   	ret    

00800ac8 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ac8:	55                   	push   %ebp
  800ac9:	89 e5                	mov    %esp,%ebp
  800acb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ace:	8d 45 10             	lea    0x10(%ebp),%eax
  800ad1:	83 c0 04             	add    $0x4,%eax
  800ad4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ad7:	8b 45 10             	mov    0x10(%ebp),%eax
  800ada:	ff 75 f4             	pushl  -0xc(%ebp)
  800add:	50                   	push   %eax
  800ade:	ff 75 0c             	pushl  0xc(%ebp)
  800ae1:	ff 75 08             	pushl  0x8(%ebp)
  800ae4:	e8 16 fc ff ff       	call   8006ff <vprintfmt>
  800ae9:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800aec:	90                   	nop
  800aed:	c9                   	leave  
  800aee:	c3                   	ret    

00800aef <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800aef:	55                   	push   %ebp
  800af0:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800af2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af5:	8b 40 08             	mov    0x8(%eax),%eax
  800af8:	8d 50 01             	lea    0x1(%eax),%edx
  800afb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afe:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b04:	8b 10                	mov    (%eax),%edx
  800b06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b09:	8b 40 04             	mov    0x4(%eax),%eax
  800b0c:	39 c2                	cmp    %eax,%edx
  800b0e:	73 12                	jae    800b22 <sprintputch+0x33>
		*b->buf++ = ch;
  800b10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b13:	8b 00                	mov    (%eax),%eax
  800b15:	8d 48 01             	lea    0x1(%eax),%ecx
  800b18:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1b:	89 0a                	mov    %ecx,(%edx)
  800b1d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b20:	88 10                	mov    %dl,(%eax)
}
  800b22:	90                   	nop
  800b23:	5d                   	pop    %ebp
  800b24:	c3                   	ret    

00800b25 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b25:	55                   	push   %ebp
  800b26:	89 e5                	mov    %esp,%ebp
  800b28:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b34:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	01 d0                	add    %edx,%eax
  800b3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b3f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b46:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b4a:	74 06                	je     800b52 <vsnprintf+0x2d>
  800b4c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b50:	7f 07                	jg     800b59 <vsnprintf+0x34>
		return -E_INVAL;
  800b52:	b8 03 00 00 00       	mov    $0x3,%eax
  800b57:	eb 20                	jmp    800b79 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b59:	ff 75 14             	pushl  0x14(%ebp)
  800b5c:	ff 75 10             	pushl  0x10(%ebp)
  800b5f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b62:	50                   	push   %eax
  800b63:	68 ef 0a 80 00       	push   $0x800aef
  800b68:	e8 92 fb ff ff       	call   8006ff <vprintfmt>
  800b6d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b73:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b79:	c9                   	leave  
  800b7a:	c3                   	ret    

00800b7b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b7b:	55                   	push   %ebp
  800b7c:	89 e5                	mov    %esp,%ebp
  800b7e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b81:	8d 45 10             	lea    0x10(%ebp),%eax
  800b84:	83 c0 04             	add    $0x4,%eax
  800b87:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b8a:	8b 45 10             	mov    0x10(%ebp),%eax
  800b8d:	ff 75 f4             	pushl  -0xc(%ebp)
  800b90:	50                   	push   %eax
  800b91:	ff 75 0c             	pushl  0xc(%ebp)
  800b94:	ff 75 08             	pushl  0x8(%ebp)
  800b97:	e8 89 ff ff ff       	call   800b25 <vsnprintf>
  800b9c:	83 c4 10             	add    $0x10,%esp
  800b9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ba2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ba5:	c9                   	leave  
  800ba6:	c3                   	ret    

00800ba7 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ba7:	55                   	push   %ebp
  800ba8:	89 e5                	mov    %esp,%ebp
  800baa:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bb4:	eb 06                	jmp    800bbc <strlen+0x15>
		n++;
  800bb6:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bb9:	ff 45 08             	incl   0x8(%ebp)
  800bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbf:	8a 00                	mov    (%eax),%al
  800bc1:	84 c0                	test   %al,%al
  800bc3:	75 f1                	jne    800bb6 <strlen+0xf>
		n++;
	return n;
  800bc5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bc8:	c9                   	leave  
  800bc9:	c3                   	ret    

00800bca <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bca:	55                   	push   %ebp
  800bcb:	89 e5                	mov    %esp,%ebp
  800bcd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bd0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bd7:	eb 09                	jmp    800be2 <strnlen+0x18>
		n++;
  800bd9:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bdc:	ff 45 08             	incl   0x8(%ebp)
  800bdf:	ff 4d 0c             	decl   0xc(%ebp)
  800be2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800be6:	74 09                	je     800bf1 <strnlen+0x27>
  800be8:	8b 45 08             	mov    0x8(%ebp),%eax
  800beb:	8a 00                	mov    (%eax),%al
  800bed:	84 c0                	test   %al,%al
  800bef:	75 e8                	jne    800bd9 <strnlen+0xf>
		n++;
	return n;
  800bf1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bf4:	c9                   	leave  
  800bf5:	c3                   	ret    

00800bf6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bf6:	55                   	push   %ebp
  800bf7:	89 e5                	mov    %esp,%ebp
  800bf9:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c02:	90                   	nop
  800c03:	8b 45 08             	mov    0x8(%ebp),%eax
  800c06:	8d 50 01             	lea    0x1(%eax),%edx
  800c09:	89 55 08             	mov    %edx,0x8(%ebp)
  800c0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c0f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c12:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c15:	8a 12                	mov    (%edx),%dl
  800c17:	88 10                	mov    %dl,(%eax)
  800c19:	8a 00                	mov    (%eax),%al
  800c1b:	84 c0                	test   %al,%al
  800c1d:	75 e4                	jne    800c03 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c22:	c9                   	leave  
  800c23:	c3                   	ret    

00800c24 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
  800c27:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c37:	eb 1f                	jmp    800c58 <strncpy+0x34>
		*dst++ = *src;
  800c39:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3c:	8d 50 01             	lea    0x1(%eax),%edx
  800c3f:	89 55 08             	mov    %edx,0x8(%ebp)
  800c42:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c45:	8a 12                	mov    (%edx),%dl
  800c47:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4c:	8a 00                	mov    (%eax),%al
  800c4e:	84 c0                	test   %al,%al
  800c50:	74 03                	je     800c55 <strncpy+0x31>
			src++;
  800c52:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c55:	ff 45 fc             	incl   -0x4(%ebp)
  800c58:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c5b:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c5e:	72 d9                	jb     800c39 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c60:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c63:	c9                   	leave  
  800c64:	c3                   	ret    

00800c65 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c65:	55                   	push   %ebp
  800c66:	89 e5                	mov    %esp,%ebp
  800c68:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c71:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c75:	74 30                	je     800ca7 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c77:	eb 16                	jmp    800c8f <strlcpy+0x2a>
			*dst++ = *src++;
  800c79:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7c:	8d 50 01             	lea    0x1(%eax),%edx
  800c7f:	89 55 08             	mov    %edx,0x8(%ebp)
  800c82:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c85:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c88:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c8b:	8a 12                	mov    (%edx),%dl
  800c8d:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c8f:	ff 4d 10             	decl   0x10(%ebp)
  800c92:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c96:	74 09                	je     800ca1 <strlcpy+0x3c>
  800c98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9b:	8a 00                	mov    (%eax),%al
  800c9d:	84 c0                	test   %al,%al
  800c9f:	75 d8                	jne    800c79 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ca7:	8b 55 08             	mov    0x8(%ebp),%edx
  800caa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cad:	29 c2                	sub    %eax,%edx
  800caf:	89 d0                	mov    %edx,%eax
}
  800cb1:	c9                   	leave  
  800cb2:	c3                   	ret    

00800cb3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cb3:	55                   	push   %ebp
  800cb4:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cb6:	eb 06                	jmp    800cbe <strcmp+0xb>
		p++, q++;
  800cb8:	ff 45 08             	incl   0x8(%ebp)
  800cbb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	8a 00                	mov    (%eax),%al
  800cc3:	84 c0                	test   %al,%al
  800cc5:	74 0e                	je     800cd5 <strcmp+0x22>
  800cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cca:	8a 10                	mov    (%eax),%dl
  800ccc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccf:	8a 00                	mov    (%eax),%al
  800cd1:	38 c2                	cmp    %al,%dl
  800cd3:	74 e3                	je     800cb8 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd8:	8a 00                	mov    (%eax),%al
  800cda:	0f b6 d0             	movzbl %al,%edx
  800cdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce0:	8a 00                	mov    (%eax),%al
  800ce2:	0f b6 c0             	movzbl %al,%eax
  800ce5:	29 c2                	sub    %eax,%edx
  800ce7:	89 d0                	mov    %edx,%eax
}
  800ce9:	5d                   	pop    %ebp
  800cea:	c3                   	ret    

00800ceb <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ceb:	55                   	push   %ebp
  800cec:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cee:	eb 09                	jmp    800cf9 <strncmp+0xe>
		n--, p++, q++;
  800cf0:	ff 4d 10             	decl   0x10(%ebp)
  800cf3:	ff 45 08             	incl   0x8(%ebp)
  800cf6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cf9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cfd:	74 17                	je     800d16 <strncmp+0x2b>
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	8a 00                	mov    (%eax),%al
  800d04:	84 c0                	test   %al,%al
  800d06:	74 0e                	je     800d16 <strncmp+0x2b>
  800d08:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0b:	8a 10                	mov    (%eax),%dl
  800d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	38 c2                	cmp    %al,%dl
  800d14:	74 da                	je     800cf0 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d16:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d1a:	75 07                	jne    800d23 <strncmp+0x38>
		return 0;
  800d1c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d21:	eb 14                	jmp    800d37 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d23:	8b 45 08             	mov    0x8(%ebp),%eax
  800d26:	8a 00                	mov    (%eax),%al
  800d28:	0f b6 d0             	movzbl %al,%edx
  800d2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2e:	8a 00                	mov    (%eax),%al
  800d30:	0f b6 c0             	movzbl %al,%eax
  800d33:	29 c2                	sub    %eax,%edx
  800d35:	89 d0                	mov    %edx,%eax
}
  800d37:	5d                   	pop    %ebp
  800d38:	c3                   	ret    

00800d39 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
  800d3c:	83 ec 04             	sub    $0x4,%esp
  800d3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d42:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d45:	eb 12                	jmp    800d59 <strchr+0x20>
		if (*s == c)
  800d47:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4a:	8a 00                	mov    (%eax),%al
  800d4c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d4f:	75 05                	jne    800d56 <strchr+0x1d>
			return (char *) s;
  800d51:	8b 45 08             	mov    0x8(%ebp),%eax
  800d54:	eb 11                	jmp    800d67 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d56:	ff 45 08             	incl   0x8(%ebp)
  800d59:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5c:	8a 00                	mov    (%eax),%al
  800d5e:	84 c0                	test   %al,%al
  800d60:	75 e5                	jne    800d47 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d67:	c9                   	leave  
  800d68:	c3                   	ret    

00800d69 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d69:	55                   	push   %ebp
  800d6a:	89 e5                	mov    %esp,%ebp
  800d6c:	83 ec 04             	sub    $0x4,%esp
  800d6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d72:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d75:	eb 0d                	jmp    800d84 <strfind+0x1b>
		if (*s == c)
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d7f:	74 0e                	je     800d8f <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d81:	ff 45 08             	incl   0x8(%ebp)
  800d84:	8b 45 08             	mov    0x8(%ebp),%eax
  800d87:	8a 00                	mov    (%eax),%al
  800d89:	84 c0                	test   %al,%al
  800d8b:	75 ea                	jne    800d77 <strfind+0xe>
  800d8d:	eb 01                	jmp    800d90 <strfind+0x27>
		if (*s == c)
			break;
  800d8f:	90                   	nop
	return (char *) s;
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d93:	c9                   	leave  
  800d94:	c3                   	ret    

00800d95 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d95:	55                   	push   %ebp
  800d96:	89 e5                	mov    %esp,%ebp
  800d98:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800da1:	8b 45 10             	mov    0x10(%ebp),%eax
  800da4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800da7:	eb 0e                	jmp    800db7 <memset+0x22>
		*p++ = c;
  800da9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dac:	8d 50 01             	lea    0x1(%eax),%edx
  800daf:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800db2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db5:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800db7:	ff 4d f8             	decl   -0x8(%ebp)
  800dba:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dbe:	79 e9                	jns    800da9 <memset+0x14>
		*p++ = c;

	return v;
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dc3:	c9                   	leave  
  800dc4:	c3                   	ret    

00800dc5 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dc5:	55                   	push   %ebp
  800dc6:	89 e5                	mov    %esp,%ebp
  800dc8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800dd7:	eb 16                	jmp    800def <memcpy+0x2a>
		*d++ = *s++;
  800dd9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ddc:	8d 50 01             	lea    0x1(%eax),%edx
  800ddf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800de2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800de5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800de8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800deb:	8a 12                	mov    (%edx),%dl
  800ded:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800def:	8b 45 10             	mov    0x10(%ebp),%eax
  800df2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800df5:	89 55 10             	mov    %edx,0x10(%ebp)
  800df8:	85 c0                	test   %eax,%eax
  800dfa:	75 dd                	jne    800dd9 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dff:	c9                   	leave  
  800e00:	c3                   	ret    

00800e01 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e01:	55                   	push   %ebp
  800e02:	89 e5                	mov    %esp,%ebp
  800e04:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e10:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e13:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e16:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e19:	73 50                	jae    800e6b <memmove+0x6a>
  800e1b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e21:	01 d0                	add    %edx,%eax
  800e23:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e26:	76 43                	jbe    800e6b <memmove+0x6a>
		s += n;
  800e28:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e31:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e34:	eb 10                	jmp    800e46 <memmove+0x45>
			*--d = *--s;
  800e36:	ff 4d f8             	decl   -0x8(%ebp)
  800e39:	ff 4d fc             	decl   -0x4(%ebp)
  800e3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e3f:	8a 10                	mov    (%eax),%dl
  800e41:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e44:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e46:	8b 45 10             	mov    0x10(%ebp),%eax
  800e49:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e4c:	89 55 10             	mov    %edx,0x10(%ebp)
  800e4f:	85 c0                	test   %eax,%eax
  800e51:	75 e3                	jne    800e36 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e53:	eb 23                	jmp    800e78 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e55:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e58:	8d 50 01             	lea    0x1(%eax),%edx
  800e5b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e5e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e61:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e64:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e67:	8a 12                	mov    (%edx),%dl
  800e69:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e6b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e71:	89 55 10             	mov    %edx,0x10(%ebp)
  800e74:	85 c0                	test   %eax,%eax
  800e76:	75 dd                	jne    800e55 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e78:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e7b:	c9                   	leave  
  800e7c:	c3                   	ret    

00800e7d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
  800e80:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e8f:	eb 2a                	jmp    800ebb <memcmp+0x3e>
		if (*s1 != *s2)
  800e91:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e94:	8a 10                	mov    (%eax),%dl
  800e96:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e99:	8a 00                	mov    (%eax),%al
  800e9b:	38 c2                	cmp    %al,%dl
  800e9d:	74 16                	je     800eb5 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea2:	8a 00                	mov    (%eax),%al
  800ea4:	0f b6 d0             	movzbl %al,%edx
  800ea7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eaa:	8a 00                	mov    (%eax),%al
  800eac:	0f b6 c0             	movzbl %al,%eax
  800eaf:	29 c2                	sub    %eax,%edx
  800eb1:	89 d0                	mov    %edx,%eax
  800eb3:	eb 18                	jmp    800ecd <memcmp+0x50>
		s1++, s2++;
  800eb5:	ff 45 fc             	incl   -0x4(%ebp)
  800eb8:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ebb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ebe:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ec1:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec4:	85 c0                	test   %eax,%eax
  800ec6:	75 c9                	jne    800e91 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ec8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ecd:	c9                   	leave  
  800ece:	c3                   	ret    

00800ecf <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ecf:	55                   	push   %ebp
  800ed0:	89 e5                	mov    %esp,%ebp
  800ed2:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ed5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed8:	8b 45 10             	mov    0x10(%ebp),%eax
  800edb:	01 d0                	add    %edx,%eax
  800edd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ee0:	eb 15                	jmp    800ef7 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	8a 00                	mov    (%eax),%al
  800ee7:	0f b6 d0             	movzbl %al,%edx
  800eea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eed:	0f b6 c0             	movzbl %al,%eax
  800ef0:	39 c2                	cmp    %eax,%edx
  800ef2:	74 0d                	je     800f01 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ef4:	ff 45 08             	incl   0x8(%ebp)
  800ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  800efa:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800efd:	72 e3                	jb     800ee2 <memfind+0x13>
  800eff:	eb 01                	jmp    800f02 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f01:	90                   	nop
	return (void *) s;
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f05:	c9                   	leave  
  800f06:	c3                   	ret    

00800f07 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f07:	55                   	push   %ebp
  800f08:	89 e5                	mov    %esp,%ebp
  800f0a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f0d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f14:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f1b:	eb 03                	jmp    800f20 <strtol+0x19>
		s++;
  800f1d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	8a 00                	mov    (%eax),%al
  800f25:	3c 20                	cmp    $0x20,%al
  800f27:	74 f4                	je     800f1d <strtol+0x16>
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	8a 00                	mov    (%eax),%al
  800f2e:	3c 09                	cmp    $0x9,%al
  800f30:	74 eb                	je     800f1d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
  800f35:	8a 00                	mov    (%eax),%al
  800f37:	3c 2b                	cmp    $0x2b,%al
  800f39:	75 05                	jne    800f40 <strtol+0x39>
		s++;
  800f3b:	ff 45 08             	incl   0x8(%ebp)
  800f3e:	eb 13                	jmp    800f53 <strtol+0x4c>
	else if (*s == '-')
  800f40:	8b 45 08             	mov    0x8(%ebp),%eax
  800f43:	8a 00                	mov    (%eax),%al
  800f45:	3c 2d                	cmp    $0x2d,%al
  800f47:	75 0a                	jne    800f53 <strtol+0x4c>
		s++, neg = 1;
  800f49:	ff 45 08             	incl   0x8(%ebp)
  800f4c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f53:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f57:	74 06                	je     800f5f <strtol+0x58>
  800f59:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f5d:	75 20                	jne    800f7f <strtol+0x78>
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f62:	8a 00                	mov    (%eax),%al
  800f64:	3c 30                	cmp    $0x30,%al
  800f66:	75 17                	jne    800f7f <strtol+0x78>
  800f68:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6b:	40                   	inc    %eax
  800f6c:	8a 00                	mov    (%eax),%al
  800f6e:	3c 78                	cmp    $0x78,%al
  800f70:	75 0d                	jne    800f7f <strtol+0x78>
		s += 2, base = 16;
  800f72:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f76:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f7d:	eb 28                	jmp    800fa7 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f7f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f83:	75 15                	jne    800f9a <strtol+0x93>
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
  800f88:	8a 00                	mov    (%eax),%al
  800f8a:	3c 30                	cmp    $0x30,%al
  800f8c:	75 0c                	jne    800f9a <strtol+0x93>
		s++, base = 8;
  800f8e:	ff 45 08             	incl   0x8(%ebp)
  800f91:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f98:	eb 0d                	jmp    800fa7 <strtol+0xa0>
	else if (base == 0)
  800f9a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9e:	75 07                	jne    800fa7 <strtol+0xa0>
		base = 10;
  800fa0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800faa:	8a 00                	mov    (%eax),%al
  800fac:	3c 2f                	cmp    $0x2f,%al
  800fae:	7e 19                	jle    800fc9 <strtol+0xc2>
  800fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb3:	8a 00                	mov    (%eax),%al
  800fb5:	3c 39                	cmp    $0x39,%al
  800fb7:	7f 10                	jg     800fc9 <strtol+0xc2>
			dig = *s - '0';
  800fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbc:	8a 00                	mov    (%eax),%al
  800fbe:	0f be c0             	movsbl %al,%eax
  800fc1:	83 e8 30             	sub    $0x30,%eax
  800fc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fc7:	eb 42                	jmp    80100b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcc:	8a 00                	mov    (%eax),%al
  800fce:	3c 60                	cmp    $0x60,%al
  800fd0:	7e 19                	jle    800feb <strtol+0xe4>
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd5:	8a 00                	mov    (%eax),%al
  800fd7:	3c 7a                	cmp    $0x7a,%al
  800fd9:	7f 10                	jg     800feb <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fde:	8a 00                	mov    (%eax),%al
  800fe0:	0f be c0             	movsbl %al,%eax
  800fe3:	83 e8 57             	sub    $0x57,%eax
  800fe6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fe9:	eb 20                	jmp    80100b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800feb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fee:	8a 00                	mov    (%eax),%al
  800ff0:	3c 40                	cmp    $0x40,%al
  800ff2:	7e 39                	jle    80102d <strtol+0x126>
  800ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff7:	8a 00                	mov    (%eax),%al
  800ff9:	3c 5a                	cmp    $0x5a,%al
  800ffb:	7f 30                	jg     80102d <strtol+0x126>
			dig = *s - 'A' + 10;
  800ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  801000:	8a 00                	mov    (%eax),%al
  801002:	0f be c0             	movsbl %al,%eax
  801005:	83 e8 37             	sub    $0x37,%eax
  801008:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80100b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80100e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801011:	7d 19                	jge    80102c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801013:	ff 45 08             	incl   0x8(%ebp)
  801016:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801019:	0f af 45 10          	imul   0x10(%ebp),%eax
  80101d:	89 c2                	mov    %eax,%edx
  80101f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801022:	01 d0                	add    %edx,%eax
  801024:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801027:	e9 7b ff ff ff       	jmp    800fa7 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80102c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80102d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801031:	74 08                	je     80103b <strtol+0x134>
		*endptr = (char *) s;
  801033:	8b 45 0c             	mov    0xc(%ebp),%eax
  801036:	8b 55 08             	mov    0x8(%ebp),%edx
  801039:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80103b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80103f:	74 07                	je     801048 <strtol+0x141>
  801041:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801044:	f7 d8                	neg    %eax
  801046:	eb 03                	jmp    80104b <strtol+0x144>
  801048:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80104b:	c9                   	leave  
  80104c:	c3                   	ret    

0080104d <ltostr>:

void
ltostr(long value, char *str)
{
  80104d:	55                   	push   %ebp
  80104e:	89 e5                	mov    %esp,%ebp
  801050:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801053:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80105a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801061:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801065:	79 13                	jns    80107a <ltostr+0x2d>
	{
		neg = 1;
  801067:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80106e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801071:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801074:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801077:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801082:	99                   	cltd   
  801083:	f7 f9                	idiv   %ecx
  801085:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801088:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80108b:	8d 50 01             	lea    0x1(%eax),%edx
  80108e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801091:	89 c2                	mov    %eax,%edx
  801093:	8b 45 0c             	mov    0xc(%ebp),%eax
  801096:	01 d0                	add    %edx,%eax
  801098:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80109b:	83 c2 30             	add    $0x30,%edx
  80109e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010a3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010a8:	f7 e9                	imul   %ecx
  8010aa:	c1 fa 02             	sar    $0x2,%edx
  8010ad:	89 c8                	mov    %ecx,%eax
  8010af:	c1 f8 1f             	sar    $0x1f,%eax
  8010b2:	29 c2                	sub    %eax,%edx
  8010b4:	89 d0                	mov    %edx,%eax
  8010b6:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010bc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010c1:	f7 e9                	imul   %ecx
  8010c3:	c1 fa 02             	sar    $0x2,%edx
  8010c6:	89 c8                	mov    %ecx,%eax
  8010c8:	c1 f8 1f             	sar    $0x1f,%eax
  8010cb:	29 c2                	sub    %eax,%edx
  8010cd:	89 d0                	mov    %edx,%eax
  8010cf:	c1 e0 02             	shl    $0x2,%eax
  8010d2:	01 d0                	add    %edx,%eax
  8010d4:	01 c0                	add    %eax,%eax
  8010d6:	29 c1                	sub    %eax,%ecx
  8010d8:	89 ca                	mov    %ecx,%edx
  8010da:	85 d2                	test   %edx,%edx
  8010dc:	75 9c                	jne    80107a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e8:	48                   	dec    %eax
  8010e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010f0:	74 3d                	je     80112f <ltostr+0xe2>
		start = 1 ;
  8010f2:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010f9:	eb 34                	jmp    80112f <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8010fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801101:	01 d0                	add    %edx,%eax
  801103:	8a 00                	mov    (%eax),%al
  801105:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801108:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80110b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110e:	01 c2                	add    %eax,%edx
  801110:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801113:	8b 45 0c             	mov    0xc(%ebp),%eax
  801116:	01 c8                	add    %ecx,%eax
  801118:	8a 00                	mov    (%eax),%al
  80111a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80111c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80111f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801122:	01 c2                	add    %eax,%edx
  801124:	8a 45 eb             	mov    -0x15(%ebp),%al
  801127:	88 02                	mov    %al,(%edx)
		start++ ;
  801129:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80112c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80112f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801132:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801135:	7c c4                	jl     8010fb <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801137:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80113a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113d:	01 d0                	add    %edx,%eax
  80113f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801142:	90                   	nop
  801143:	c9                   	leave  
  801144:	c3                   	ret    

00801145 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801145:	55                   	push   %ebp
  801146:	89 e5                	mov    %esp,%ebp
  801148:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80114b:	ff 75 08             	pushl  0x8(%ebp)
  80114e:	e8 54 fa ff ff       	call   800ba7 <strlen>
  801153:	83 c4 04             	add    $0x4,%esp
  801156:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801159:	ff 75 0c             	pushl  0xc(%ebp)
  80115c:	e8 46 fa ff ff       	call   800ba7 <strlen>
  801161:	83 c4 04             	add    $0x4,%esp
  801164:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801167:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80116e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801175:	eb 17                	jmp    80118e <strcconcat+0x49>
		final[s] = str1[s] ;
  801177:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80117a:	8b 45 10             	mov    0x10(%ebp),%eax
  80117d:	01 c2                	add    %eax,%edx
  80117f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	01 c8                	add    %ecx,%eax
  801187:	8a 00                	mov    (%eax),%al
  801189:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80118b:	ff 45 fc             	incl   -0x4(%ebp)
  80118e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801191:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801194:	7c e1                	jl     801177 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801196:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80119d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011a4:	eb 1f                	jmp    8011c5 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a9:	8d 50 01             	lea    0x1(%eax),%edx
  8011ac:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011af:	89 c2                	mov    %eax,%edx
  8011b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b4:	01 c2                	add    %eax,%edx
  8011b6:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bc:	01 c8                	add    %ecx,%eax
  8011be:	8a 00                	mov    (%eax),%al
  8011c0:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011c2:	ff 45 f8             	incl   -0x8(%ebp)
  8011c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011cb:	7c d9                	jl     8011a6 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011cd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d3:	01 d0                	add    %edx,%eax
  8011d5:	c6 00 00             	movb   $0x0,(%eax)
}
  8011d8:	90                   	nop
  8011d9:	c9                   	leave  
  8011da:	c3                   	ret    

008011db <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011db:	55                   	push   %ebp
  8011dc:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011de:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ea:	8b 00                	mov    (%eax),%eax
  8011ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f6:	01 d0                	add    %edx,%eax
  8011f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011fe:	eb 0c                	jmp    80120c <strsplit+0x31>
			*string++ = 0;
  801200:	8b 45 08             	mov    0x8(%ebp),%eax
  801203:	8d 50 01             	lea    0x1(%eax),%edx
  801206:	89 55 08             	mov    %edx,0x8(%ebp)
  801209:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	8a 00                	mov    (%eax),%al
  801211:	84 c0                	test   %al,%al
  801213:	74 18                	je     80122d <strsplit+0x52>
  801215:	8b 45 08             	mov    0x8(%ebp),%eax
  801218:	8a 00                	mov    (%eax),%al
  80121a:	0f be c0             	movsbl %al,%eax
  80121d:	50                   	push   %eax
  80121e:	ff 75 0c             	pushl  0xc(%ebp)
  801221:	e8 13 fb ff ff       	call   800d39 <strchr>
  801226:	83 c4 08             	add    $0x8,%esp
  801229:	85 c0                	test   %eax,%eax
  80122b:	75 d3                	jne    801200 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80122d:	8b 45 08             	mov    0x8(%ebp),%eax
  801230:	8a 00                	mov    (%eax),%al
  801232:	84 c0                	test   %al,%al
  801234:	74 5a                	je     801290 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801236:	8b 45 14             	mov    0x14(%ebp),%eax
  801239:	8b 00                	mov    (%eax),%eax
  80123b:	83 f8 0f             	cmp    $0xf,%eax
  80123e:	75 07                	jne    801247 <strsplit+0x6c>
		{
			return 0;
  801240:	b8 00 00 00 00       	mov    $0x0,%eax
  801245:	eb 66                	jmp    8012ad <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801247:	8b 45 14             	mov    0x14(%ebp),%eax
  80124a:	8b 00                	mov    (%eax),%eax
  80124c:	8d 48 01             	lea    0x1(%eax),%ecx
  80124f:	8b 55 14             	mov    0x14(%ebp),%edx
  801252:	89 0a                	mov    %ecx,(%edx)
  801254:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80125b:	8b 45 10             	mov    0x10(%ebp),%eax
  80125e:	01 c2                	add    %eax,%edx
  801260:	8b 45 08             	mov    0x8(%ebp),%eax
  801263:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801265:	eb 03                	jmp    80126a <strsplit+0x8f>
			string++;
  801267:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80126a:	8b 45 08             	mov    0x8(%ebp),%eax
  80126d:	8a 00                	mov    (%eax),%al
  80126f:	84 c0                	test   %al,%al
  801271:	74 8b                	je     8011fe <strsplit+0x23>
  801273:	8b 45 08             	mov    0x8(%ebp),%eax
  801276:	8a 00                	mov    (%eax),%al
  801278:	0f be c0             	movsbl %al,%eax
  80127b:	50                   	push   %eax
  80127c:	ff 75 0c             	pushl  0xc(%ebp)
  80127f:	e8 b5 fa ff ff       	call   800d39 <strchr>
  801284:	83 c4 08             	add    $0x8,%esp
  801287:	85 c0                	test   %eax,%eax
  801289:	74 dc                	je     801267 <strsplit+0x8c>
			string++;
	}
  80128b:	e9 6e ff ff ff       	jmp    8011fe <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801290:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801291:	8b 45 14             	mov    0x14(%ebp),%eax
  801294:	8b 00                	mov    (%eax),%eax
  801296:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80129d:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a0:	01 d0                	add    %edx,%eax
  8012a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012a8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012ad:	c9                   	leave  
  8012ae:	c3                   	ret    

008012af <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012af:	55                   	push   %ebp
  8012b0:	89 e5                	mov    %esp,%ebp
  8012b2:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012b5:	a1 04 40 80 00       	mov    0x804004,%eax
  8012ba:	85 c0                	test   %eax,%eax
  8012bc:	74 1f                	je     8012dd <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012be:	e8 1d 00 00 00       	call   8012e0 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8012c3:	83 ec 0c             	sub    $0xc,%esp
  8012c6:	68 90 38 80 00       	push   $0x803890
  8012cb:	e8 55 f2 ff ff       	call   800525 <cprintf>
  8012d0:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012d3:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8012da:	00 00 00 
	}
}
  8012dd:	90                   	nop
  8012de:	c9                   	leave  
  8012df:	c3                   	ret    

008012e0 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8012e0:	55                   	push   %ebp
  8012e1:	89 e5                	mov    %esp,%ebp
  8012e3:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  8012e6:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8012ed:	00 00 00 
  8012f0:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  8012f7:	00 00 00 
  8012fa:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801301:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  801304:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80130b:	00 00 00 
  80130e:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801315:	00 00 00 
  801318:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80131f:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  801322:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801329:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80132c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801331:	2d 00 10 00 00       	sub    $0x1000,%eax
  801336:	a3 50 40 80 00       	mov    %eax,0x804050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  80133b:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801342:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  801345:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80134c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80134f:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  801354:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801357:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80135a:	ba 00 00 00 00       	mov    $0x0,%edx
  80135f:	f7 75 f0             	divl   -0x10(%ebp)
  801362:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801365:	29 d0                	sub    %edx,%eax
  801367:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  80136a:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801371:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801374:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801379:	2d 00 10 00 00       	sub    $0x1000,%eax
  80137e:	83 ec 04             	sub    $0x4,%esp
  801381:	6a 06                	push   $0x6
  801383:	ff 75 e8             	pushl  -0x18(%ebp)
  801386:	50                   	push   %eax
  801387:	e8 d4 05 00 00       	call   801960 <sys_allocate_chunk>
  80138c:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80138f:	a1 20 41 80 00       	mov    0x804120,%eax
  801394:	83 ec 0c             	sub    $0xc,%esp
  801397:	50                   	push   %eax
  801398:	e8 49 0c 00 00       	call   801fe6 <initialize_MemBlocksList>
  80139d:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  8013a0:	a1 48 41 80 00       	mov    0x804148,%eax
  8013a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  8013a8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013ac:	75 14                	jne    8013c2 <initialize_dyn_block_system+0xe2>
  8013ae:	83 ec 04             	sub    $0x4,%esp
  8013b1:	68 b5 38 80 00       	push   $0x8038b5
  8013b6:	6a 39                	push   $0x39
  8013b8:	68 d3 38 80 00       	push   $0x8038d3
  8013bd:	e8 af ee ff ff       	call   800271 <_panic>
  8013c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013c5:	8b 00                	mov    (%eax),%eax
  8013c7:	85 c0                	test   %eax,%eax
  8013c9:	74 10                	je     8013db <initialize_dyn_block_system+0xfb>
  8013cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013ce:	8b 00                	mov    (%eax),%eax
  8013d0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8013d3:	8b 52 04             	mov    0x4(%edx),%edx
  8013d6:	89 50 04             	mov    %edx,0x4(%eax)
  8013d9:	eb 0b                	jmp    8013e6 <initialize_dyn_block_system+0x106>
  8013db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013de:	8b 40 04             	mov    0x4(%eax),%eax
  8013e1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8013e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013e9:	8b 40 04             	mov    0x4(%eax),%eax
  8013ec:	85 c0                	test   %eax,%eax
  8013ee:	74 0f                	je     8013ff <initialize_dyn_block_system+0x11f>
  8013f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013f3:	8b 40 04             	mov    0x4(%eax),%eax
  8013f6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8013f9:	8b 12                	mov    (%edx),%edx
  8013fb:	89 10                	mov    %edx,(%eax)
  8013fd:	eb 0a                	jmp    801409 <initialize_dyn_block_system+0x129>
  8013ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801402:	8b 00                	mov    (%eax),%eax
  801404:	a3 48 41 80 00       	mov    %eax,0x804148
  801409:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80140c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801412:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801415:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80141c:	a1 54 41 80 00       	mov    0x804154,%eax
  801421:	48                   	dec    %eax
  801422:	a3 54 41 80 00       	mov    %eax,0x804154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  801427:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80142a:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  801431:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801434:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  80143b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80143f:	75 14                	jne    801455 <initialize_dyn_block_system+0x175>
  801441:	83 ec 04             	sub    $0x4,%esp
  801444:	68 e0 38 80 00       	push   $0x8038e0
  801449:	6a 3f                	push   $0x3f
  80144b:	68 d3 38 80 00       	push   $0x8038d3
  801450:	e8 1c ee ff ff       	call   800271 <_panic>
  801455:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80145b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80145e:	89 10                	mov    %edx,(%eax)
  801460:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801463:	8b 00                	mov    (%eax),%eax
  801465:	85 c0                	test   %eax,%eax
  801467:	74 0d                	je     801476 <initialize_dyn_block_system+0x196>
  801469:	a1 38 41 80 00       	mov    0x804138,%eax
  80146e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801471:	89 50 04             	mov    %edx,0x4(%eax)
  801474:	eb 08                	jmp    80147e <initialize_dyn_block_system+0x19e>
  801476:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801479:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80147e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801481:	a3 38 41 80 00       	mov    %eax,0x804138
  801486:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801489:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801490:	a1 44 41 80 00       	mov    0x804144,%eax
  801495:	40                   	inc    %eax
  801496:	a3 44 41 80 00       	mov    %eax,0x804144

}
  80149b:	90                   	nop
  80149c:	c9                   	leave  
  80149d:	c3                   	ret    

0080149e <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80149e:	55                   	push   %ebp
  80149f:	89 e5                	mov    %esp,%ebp
  8014a1:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014a4:	e8 06 fe ff ff       	call   8012af <InitializeUHeap>
	if (size == 0) return NULL ;
  8014a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014ad:	75 07                	jne    8014b6 <malloc+0x18>
  8014af:	b8 00 00 00 00       	mov    $0x0,%eax
  8014b4:	eb 7d                	jmp    801533 <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  8014b6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8014bd:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8014c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8014c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ca:	01 d0                	add    %edx,%eax
  8014cc:	48                   	dec    %eax
  8014cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8014d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8014d8:	f7 75 f0             	divl   -0x10(%ebp)
  8014db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014de:	29 d0                	sub    %edx,%eax
  8014e0:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  8014e3:	e8 46 08 00 00       	call   801d2e <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014e8:	83 f8 01             	cmp    $0x1,%eax
  8014eb:	75 07                	jne    8014f4 <malloc+0x56>
  8014ed:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  8014f4:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  8014f8:	75 34                	jne    80152e <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  8014fa:	83 ec 0c             	sub    $0xc,%esp
  8014fd:	ff 75 e8             	pushl  -0x18(%ebp)
  801500:	e8 73 0e 00 00       	call   802378 <alloc_block_FF>
  801505:	83 c4 10             	add    $0x10,%esp
  801508:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  80150b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80150f:	74 16                	je     801527 <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  801511:	83 ec 0c             	sub    $0xc,%esp
  801514:	ff 75 e4             	pushl  -0x1c(%ebp)
  801517:	e8 ff 0b 00 00       	call   80211b <insert_sorted_allocList>
  80151c:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  80151f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801522:	8b 40 08             	mov    0x8(%eax),%eax
  801525:	eb 0c                	jmp    801533 <malloc+0x95>
	             }
	             else
	             	return NULL;
  801527:	b8 00 00 00 00       	mov    $0x0,%eax
  80152c:	eb 05                	jmp    801533 <malloc+0x95>
	      	  }
	          else
	               return NULL;
  80152e:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  801533:	c9                   	leave  
  801534:	c3                   	ret    

00801535 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801535:	55                   	push   %ebp
  801536:	89 e5                	mov    %esp,%ebp
  801538:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  80153b:	8b 45 08             	mov    0x8(%ebp),%eax
  80153e:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  801541:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801544:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801547:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80154a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80154f:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  801552:	83 ec 08             	sub    $0x8,%esp
  801555:	ff 75 f4             	pushl  -0xc(%ebp)
  801558:	68 40 40 80 00       	push   $0x804040
  80155d:	e8 61 0b 00 00       	call   8020c3 <find_block>
  801562:	83 c4 10             	add    $0x10,%esp
  801565:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  801568:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80156c:	0f 84 a5 00 00 00    	je     801617 <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  801572:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801575:	8b 40 0c             	mov    0xc(%eax),%eax
  801578:	83 ec 08             	sub    $0x8,%esp
  80157b:	50                   	push   %eax
  80157c:	ff 75 f4             	pushl  -0xc(%ebp)
  80157f:	e8 a4 03 00 00       	call   801928 <sys_free_user_mem>
  801584:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  801587:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80158b:	75 17                	jne    8015a4 <free+0x6f>
  80158d:	83 ec 04             	sub    $0x4,%esp
  801590:	68 b5 38 80 00       	push   $0x8038b5
  801595:	68 87 00 00 00       	push   $0x87
  80159a:	68 d3 38 80 00       	push   $0x8038d3
  80159f:	e8 cd ec ff ff       	call   800271 <_panic>
  8015a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015a7:	8b 00                	mov    (%eax),%eax
  8015a9:	85 c0                	test   %eax,%eax
  8015ab:	74 10                	je     8015bd <free+0x88>
  8015ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015b0:	8b 00                	mov    (%eax),%eax
  8015b2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015b5:	8b 52 04             	mov    0x4(%edx),%edx
  8015b8:	89 50 04             	mov    %edx,0x4(%eax)
  8015bb:	eb 0b                	jmp    8015c8 <free+0x93>
  8015bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015c0:	8b 40 04             	mov    0x4(%eax),%eax
  8015c3:	a3 44 40 80 00       	mov    %eax,0x804044
  8015c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015cb:	8b 40 04             	mov    0x4(%eax),%eax
  8015ce:	85 c0                	test   %eax,%eax
  8015d0:	74 0f                	je     8015e1 <free+0xac>
  8015d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015d5:	8b 40 04             	mov    0x4(%eax),%eax
  8015d8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015db:	8b 12                	mov    (%edx),%edx
  8015dd:	89 10                	mov    %edx,(%eax)
  8015df:	eb 0a                	jmp    8015eb <free+0xb6>
  8015e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015e4:	8b 00                	mov    (%eax),%eax
  8015e6:	a3 40 40 80 00       	mov    %eax,0x804040
  8015eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015f7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015fe:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801603:	48                   	dec    %eax
  801604:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(theBlock);
  801609:	83 ec 0c             	sub    $0xc,%esp
  80160c:	ff 75 ec             	pushl  -0x14(%ebp)
  80160f:	e8 37 12 00 00       	call   80284b <insert_sorted_with_merge_freeList>
  801614:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  801617:	90                   	nop
  801618:	c9                   	leave  
  801619:	c3                   	ret    

0080161a <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80161a:	55                   	push   %ebp
  80161b:	89 e5                	mov    %esp,%ebp
  80161d:	83 ec 38             	sub    $0x38,%esp
  801620:	8b 45 10             	mov    0x10(%ebp),%eax
  801623:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801626:	e8 84 fc ff ff       	call   8012af <InitializeUHeap>
	if (size == 0) return NULL ;
  80162b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80162f:	75 07                	jne    801638 <smalloc+0x1e>
  801631:	b8 00 00 00 00       	mov    $0x0,%eax
  801636:	eb 7e                	jmp    8016b6 <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  801638:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  80163f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801646:	8b 55 0c             	mov    0xc(%ebp),%edx
  801649:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80164c:	01 d0                	add    %edx,%eax
  80164e:	48                   	dec    %eax
  80164f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801652:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801655:	ba 00 00 00 00       	mov    $0x0,%edx
  80165a:	f7 75 f0             	divl   -0x10(%ebp)
  80165d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801660:	29 d0                	sub    %edx,%eax
  801662:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801665:	e8 c4 06 00 00       	call   801d2e <sys_isUHeapPlacementStrategyFIRSTFIT>
  80166a:	83 f8 01             	cmp    $0x1,%eax
  80166d:	75 42                	jne    8016b1 <smalloc+0x97>

		  va = malloc(newsize) ;
  80166f:	83 ec 0c             	sub    $0xc,%esp
  801672:	ff 75 e8             	pushl  -0x18(%ebp)
  801675:	e8 24 fe ff ff       	call   80149e <malloc>
  80167a:	83 c4 10             	add    $0x10,%esp
  80167d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  801680:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801684:	74 24                	je     8016aa <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  801686:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80168a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80168d:	50                   	push   %eax
  80168e:	ff 75 e8             	pushl  -0x18(%ebp)
  801691:	ff 75 08             	pushl  0x8(%ebp)
  801694:	e8 1a 04 00 00       	call   801ab3 <sys_createSharedObject>
  801699:	83 c4 10             	add    $0x10,%esp
  80169c:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  80169f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8016a3:	78 0c                	js     8016b1 <smalloc+0x97>
					  return va ;
  8016a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016a8:	eb 0c                	jmp    8016b6 <smalloc+0x9c>
				 }
				 else
					return NULL;
  8016aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8016af:	eb 05                	jmp    8016b6 <smalloc+0x9c>
	  }
		  return NULL ;
  8016b1:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016b6:	c9                   	leave  
  8016b7:	c3                   	ret    

008016b8 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016b8:	55                   	push   %ebp
  8016b9:	89 e5                	mov    %esp,%ebp
  8016bb:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016be:	e8 ec fb ff ff       	call   8012af <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  8016c3:	83 ec 08             	sub    $0x8,%esp
  8016c6:	ff 75 0c             	pushl  0xc(%ebp)
  8016c9:	ff 75 08             	pushl  0x8(%ebp)
  8016cc:	e8 0c 04 00 00       	call   801add <sys_getSizeOfSharedObject>
  8016d1:	83 c4 10             	add    $0x10,%esp
  8016d4:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  8016d7:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8016db:	75 07                	jne    8016e4 <sget+0x2c>
  8016dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e2:	eb 75                	jmp    801759 <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8016e4:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8016eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f1:	01 d0                	add    %edx,%eax
  8016f3:	48                   	dec    %eax
  8016f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ff:	f7 75 f0             	divl   -0x10(%ebp)
  801702:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801705:	29 d0                	sub    %edx,%eax
  801707:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  80170a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801711:	e8 18 06 00 00       	call   801d2e <sys_isUHeapPlacementStrategyFIRSTFIT>
  801716:	83 f8 01             	cmp    $0x1,%eax
  801719:	75 39                	jne    801754 <sget+0x9c>

		  va = malloc(newsize) ;
  80171b:	83 ec 0c             	sub    $0xc,%esp
  80171e:	ff 75 e8             	pushl  -0x18(%ebp)
  801721:	e8 78 fd ff ff       	call   80149e <malloc>
  801726:	83 c4 10             	add    $0x10,%esp
  801729:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  80172c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801730:	74 22                	je     801754 <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  801732:	83 ec 04             	sub    $0x4,%esp
  801735:	ff 75 e0             	pushl  -0x20(%ebp)
  801738:	ff 75 0c             	pushl  0xc(%ebp)
  80173b:	ff 75 08             	pushl  0x8(%ebp)
  80173e:	e8 b7 03 00 00       	call   801afa <sys_getSharedObject>
  801743:	83 c4 10             	add    $0x10,%esp
  801746:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  801749:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80174d:	78 05                	js     801754 <sget+0x9c>
					  return va;
  80174f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801752:	eb 05                	jmp    801759 <sget+0xa1>
				  }
			  }
     }
         return NULL;
  801754:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  801759:	c9                   	leave  
  80175a:	c3                   	ret    

0080175b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80175b:	55                   	push   %ebp
  80175c:	89 e5                	mov    %esp,%ebp
  80175e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801761:	e8 49 fb ff ff       	call   8012af <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801766:	83 ec 04             	sub    $0x4,%esp
  801769:	68 04 39 80 00       	push   $0x803904
  80176e:	68 1e 01 00 00       	push   $0x11e
  801773:	68 d3 38 80 00       	push   $0x8038d3
  801778:	e8 f4 ea ff ff       	call   800271 <_panic>

0080177d <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80177d:	55                   	push   %ebp
  80177e:	89 e5                	mov    %esp,%ebp
  801780:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801783:	83 ec 04             	sub    $0x4,%esp
  801786:	68 2c 39 80 00       	push   $0x80392c
  80178b:	68 32 01 00 00       	push   $0x132
  801790:	68 d3 38 80 00       	push   $0x8038d3
  801795:	e8 d7 ea ff ff       	call   800271 <_panic>

0080179a <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
  80179d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017a0:	83 ec 04             	sub    $0x4,%esp
  8017a3:	68 50 39 80 00       	push   $0x803950
  8017a8:	68 3d 01 00 00       	push   $0x13d
  8017ad:	68 d3 38 80 00       	push   $0x8038d3
  8017b2:	e8 ba ea ff ff       	call   800271 <_panic>

008017b7 <shrink>:

}
void shrink(uint32 newSize)
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
  8017ba:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017bd:	83 ec 04             	sub    $0x4,%esp
  8017c0:	68 50 39 80 00       	push   $0x803950
  8017c5:	68 42 01 00 00       	push   $0x142
  8017ca:	68 d3 38 80 00       	push   $0x8038d3
  8017cf:	e8 9d ea ff ff       	call   800271 <_panic>

008017d4 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017d4:	55                   	push   %ebp
  8017d5:	89 e5                	mov    %esp,%ebp
  8017d7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017da:	83 ec 04             	sub    $0x4,%esp
  8017dd:	68 50 39 80 00       	push   $0x803950
  8017e2:	68 47 01 00 00       	push   $0x147
  8017e7:	68 d3 38 80 00       	push   $0x8038d3
  8017ec:	e8 80 ea ff ff       	call   800271 <_panic>

008017f1 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017f1:	55                   	push   %ebp
  8017f2:	89 e5                	mov    %esp,%ebp
  8017f4:	57                   	push   %edi
  8017f5:	56                   	push   %esi
  8017f6:	53                   	push   %ebx
  8017f7:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801800:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801803:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801806:	8b 7d 18             	mov    0x18(%ebp),%edi
  801809:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80180c:	cd 30                	int    $0x30
  80180e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801811:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801814:	83 c4 10             	add    $0x10,%esp
  801817:	5b                   	pop    %ebx
  801818:	5e                   	pop    %esi
  801819:	5f                   	pop    %edi
  80181a:	5d                   	pop    %ebp
  80181b:	c3                   	ret    

0080181c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
  80181f:	83 ec 04             	sub    $0x4,%esp
  801822:	8b 45 10             	mov    0x10(%ebp),%eax
  801825:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801828:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80182c:	8b 45 08             	mov    0x8(%ebp),%eax
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	52                   	push   %edx
  801834:	ff 75 0c             	pushl  0xc(%ebp)
  801837:	50                   	push   %eax
  801838:	6a 00                	push   $0x0
  80183a:	e8 b2 ff ff ff       	call   8017f1 <syscall>
  80183f:	83 c4 18             	add    $0x18,%esp
}
  801842:	90                   	nop
  801843:	c9                   	leave  
  801844:	c3                   	ret    

00801845 <sys_cgetc>:

int
sys_cgetc(void)
{
  801845:	55                   	push   %ebp
  801846:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	6a 01                	push   $0x1
  801854:	e8 98 ff ff ff       	call   8017f1 <syscall>
  801859:	83 c4 18             	add    $0x18,%esp
}
  80185c:	c9                   	leave  
  80185d:	c3                   	ret    

0080185e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80185e:	55                   	push   %ebp
  80185f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801861:	8b 55 0c             	mov    0xc(%ebp),%edx
  801864:	8b 45 08             	mov    0x8(%ebp),%eax
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	52                   	push   %edx
  80186e:	50                   	push   %eax
  80186f:	6a 05                	push   $0x5
  801871:	e8 7b ff ff ff       	call   8017f1 <syscall>
  801876:	83 c4 18             	add    $0x18,%esp
}
  801879:	c9                   	leave  
  80187a:	c3                   	ret    

0080187b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80187b:	55                   	push   %ebp
  80187c:	89 e5                	mov    %esp,%ebp
  80187e:	56                   	push   %esi
  80187f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801880:	8b 75 18             	mov    0x18(%ebp),%esi
  801883:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801886:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801889:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188c:	8b 45 08             	mov    0x8(%ebp),%eax
  80188f:	56                   	push   %esi
  801890:	53                   	push   %ebx
  801891:	51                   	push   %ecx
  801892:	52                   	push   %edx
  801893:	50                   	push   %eax
  801894:	6a 06                	push   $0x6
  801896:	e8 56 ff ff ff       	call   8017f1 <syscall>
  80189b:	83 c4 18             	add    $0x18,%esp
}
  80189e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018a1:	5b                   	pop    %ebx
  8018a2:	5e                   	pop    %esi
  8018a3:	5d                   	pop    %ebp
  8018a4:	c3                   	ret    

008018a5 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018a5:	55                   	push   %ebp
  8018a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	52                   	push   %edx
  8018b5:	50                   	push   %eax
  8018b6:	6a 07                	push   $0x7
  8018b8:	e8 34 ff ff ff       	call   8017f1 <syscall>
  8018bd:	83 c4 18             	add    $0x18,%esp
}
  8018c0:	c9                   	leave  
  8018c1:	c3                   	ret    

008018c2 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018c2:	55                   	push   %ebp
  8018c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	ff 75 0c             	pushl  0xc(%ebp)
  8018ce:	ff 75 08             	pushl  0x8(%ebp)
  8018d1:	6a 08                	push   $0x8
  8018d3:	e8 19 ff ff ff       	call   8017f1 <syscall>
  8018d8:	83 c4 18             	add    $0x18,%esp
}
  8018db:	c9                   	leave  
  8018dc:	c3                   	ret    

008018dd <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 09                	push   $0x9
  8018ec:	e8 00 ff ff ff       	call   8017f1 <syscall>
  8018f1:	83 c4 18             	add    $0x18,%esp
}
  8018f4:	c9                   	leave  
  8018f5:	c3                   	ret    

008018f6 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018f6:	55                   	push   %ebp
  8018f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	6a 0a                	push   $0xa
  801905:	e8 e7 fe ff ff       	call   8017f1 <syscall>
  80190a:	83 c4 18             	add    $0x18,%esp
}
  80190d:	c9                   	leave  
  80190e:	c3                   	ret    

0080190f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 0b                	push   $0xb
  80191e:	e8 ce fe ff ff       	call   8017f1 <syscall>
  801923:	83 c4 18             	add    $0x18,%esp
}
  801926:	c9                   	leave  
  801927:	c3                   	ret    

00801928 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801928:	55                   	push   %ebp
  801929:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	ff 75 0c             	pushl  0xc(%ebp)
  801934:	ff 75 08             	pushl  0x8(%ebp)
  801937:	6a 0f                	push   $0xf
  801939:	e8 b3 fe ff ff       	call   8017f1 <syscall>
  80193e:	83 c4 18             	add    $0x18,%esp
	return;
  801941:	90                   	nop
}
  801942:	c9                   	leave  
  801943:	c3                   	ret    

00801944 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801944:	55                   	push   %ebp
  801945:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	ff 75 0c             	pushl  0xc(%ebp)
  801950:	ff 75 08             	pushl  0x8(%ebp)
  801953:	6a 10                	push   $0x10
  801955:	e8 97 fe ff ff       	call   8017f1 <syscall>
  80195a:	83 c4 18             	add    $0x18,%esp
	return ;
  80195d:	90                   	nop
}
  80195e:	c9                   	leave  
  80195f:	c3                   	ret    

00801960 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	ff 75 10             	pushl  0x10(%ebp)
  80196a:	ff 75 0c             	pushl  0xc(%ebp)
  80196d:	ff 75 08             	pushl  0x8(%ebp)
  801970:	6a 11                	push   $0x11
  801972:	e8 7a fe ff ff       	call   8017f1 <syscall>
  801977:	83 c4 18             	add    $0x18,%esp
	return ;
  80197a:	90                   	nop
}
  80197b:	c9                   	leave  
  80197c:	c3                   	ret    

0080197d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 0c                	push   $0xc
  80198c:	e8 60 fe ff ff       	call   8017f1 <syscall>
  801991:	83 c4 18             	add    $0x18,%esp
}
  801994:	c9                   	leave  
  801995:	c3                   	ret    

00801996 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	ff 75 08             	pushl  0x8(%ebp)
  8019a4:	6a 0d                	push   $0xd
  8019a6:	e8 46 fe ff ff       	call   8017f1 <syscall>
  8019ab:	83 c4 18             	add    $0x18,%esp
}
  8019ae:	c9                   	leave  
  8019af:	c3                   	ret    

008019b0 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019b0:	55                   	push   %ebp
  8019b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 0e                	push   $0xe
  8019bf:	e8 2d fe ff ff       	call   8017f1 <syscall>
  8019c4:	83 c4 18             	add    $0x18,%esp
}
  8019c7:	90                   	nop
  8019c8:	c9                   	leave  
  8019c9:	c3                   	ret    

008019ca <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 13                	push   $0x13
  8019d9:	e8 13 fe ff ff       	call   8017f1 <syscall>
  8019de:	83 c4 18             	add    $0x18,%esp
}
  8019e1:	90                   	nop
  8019e2:	c9                   	leave  
  8019e3:	c3                   	ret    

008019e4 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 14                	push   $0x14
  8019f3:	e8 f9 fd ff ff       	call   8017f1 <syscall>
  8019f8:	83 c4 18             	add    $0x18,%esp
}
  8019fb:	90                   	nop
  8019fc:	c9                   	leave  
  8019fd:	c3                   	ret    

008019fe <sys_cputc>:


void
sys_cputc(const char c)
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
  801a01:	83 ec 04             	sub    $0x4,%esp
  801a04:	8b 45 08             	mov    0x8(%ebp),%eax
  801a07:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a0a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	50                   	push   %eax
  801a17:	6a 15                	push   $0x15
  801a19:	e8 d3 fd ff ff       	call   8017f1 <syscall>
  801a1e:	83 c4 18             	add    $0x18,%esp
}
  801a21:	90                   	nop
  801a22:	c9                   	leave  
  801a23:	c3                   	ret    

00801a24 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a24:	55                   	push   %ebp
  801a25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 16                	push   $0x16
  801a33:	e8 b9 fd ff ff       	call   8017f1 <syscall>
  801a38:	83 c4 18             	add    $0x18,%esp
}
  801a3b:	90                   	nop
  801a3c:	c9                   	leave  
  801a3d:	c3                   	ret    

00801a3e <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a3e:	55                   	push   %ebp
  801a3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a41:	8b 45 08             	mov    0x8(%ebp),%eax
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	ff 75 0c             	pushl  0xc(%ebp)
  801a4d:	50                   	push   %eax
  801a4e:	6a 17                	push   $0x17
  801a50:	e8 9c fd ff ff       	call   8017f1 <syscall>
  801a55:	83 c4 18             	add    $0x18,%esp
}
  801a58:	c9                   	leave  
  801a59:	c3                   	ret    

00801a5a <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a60:	8b 45 08             	mov    0x8(%ebp),%eax
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	52                   	push   %edx
  801a6a:	50                   	push   %eax
  801a6b:	6a 1a                	push   $0x1a
  801a6d:	e8 7f fd ff ff       	call   8017f1 <syscall>
  801a72:	83 c4 18             	add    $0x18,%esp
}
  801a75:	c9                   	leave  
  801a76:	c3                   	ret    

00801a77 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a77:	55                   	push   %ebp
  801a78:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	52                   	push   %edx
  801a87:	50                   	push   %eax
  801a88:	6a 18                	push   $0x18
  801a8a:	e8 62 fd ff ff       	call   8017f1 <syscall>
  801a8f:	83 c4 18             	add    $0x18,%esp
}
  801a92:	90                   	nop
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    

00801a95 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a98:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	52                   	push   %edx
  801aa5:	50                   	push   %eax
  801aa6:	6a 19                	push   $0x19
  801aa8:	e8 44 fd ff ff       	call   8017f1 <syscall>
  801aad:	83 c4 18             	add    $0x18,%esp
}
  801ab0:	90                   	nop
  801ab1:	c9                   	leave  
  801ab2:	c3                   	ret    

00801ab3 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ab3:	55                   	push   %ebp
  801ab4:	89 e5                	mov    %esp,%ebp
  801ab6:	83 ec 04             	sub    $0x4,%esp
  801ab9:	8b 45 10             	mov    0x10(%ebp),%eax
  801abc:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801abf:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ac2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac9:	6a 00                	push   $0x0
  801acb:	51                   	push   %ecx
  801acc:	52                   	push   %edx
  801acd:	ff 75 0c             	pushl  0xc(%ebp)
  801ad0:	50                   	push   %eax
  801ad1:	6a 1b                	push   $0x1b
  801ad3:	e8 19 fd ff ff       	call   8017f1 <syscall>
  801ad8:	83 c4 18             	add    $0x18,%esp
}
  801adb:	c9                   	leave  
  801adc:	c3                   	ret    

00801add <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ae0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	52                   	push   %edx
  801aed:	50                   	push   %eax
  801aee:	6a 1c                	push   $0x1c
  801af0:	e8 fc fc ff ff       	call   8017f1 <syscall>
  801af5:	83 c4 18             	add    $0x18,%esp
}
  801af8:	c9                   	leave  
  801af9:	c3                   	ret    

00801afa <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801afa:	55                   	push   %ebp
  801afb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801afd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b00:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b03:	8b 45 08             	mov    0x8(%ebp),%eax
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	51                   	push   %ecx
  801b0b:	52                   	push   %edx
  801b0c:	50                   	push   %eax
  801b0d:	6a 1d                	push   $0x1d
  801b0f:	e8 dd fc ff ff       	call   8017f1 <syscall>
  801b14:	83 c4 18             	add    $0x18,%esp
}
  801b17:	c9                   	leave  
  801b18:	c3                   	ret    

00801b19 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	52                   	push   %edx
  801b29:	50                   	push   %eax
  801b2a:	6a 1e                	push   $0x1e
  801b2c:	e8 c0 fc ff ff       	call   8017f1 <syscall>
  801b31:	83 c4 18             	add    $0x18,%esp
}
  801b34:	c9                   	leave  
  801b35:	c3                   	ret    

00801b36 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b36:	55                   	push   %ebp
  801b37:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	6a 1f                	push   $0x1f
  801b45:	e8 a7 fc ff ff       	call   8017f1 <syscall>
  801b4a:	83 c4 18             	add    $0x18,%esp
}
  801b4d:	c9                   	leave  
  801b4e:	c3                   	ret    

00801b4f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b4f:	55                   	push   %ebp
  801b50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b52:	8b 45 08             	mov    0x8(%ebp),%eax
  801b55:	6a 00                	push   $0x0
  801b57:	ff 75 14             	pushl  0x14(%ebp)
  801b5a:	ff 75 10             	pushl  0x10(%ebp)
  801b5d:	ff 75 0c             	pushl  0xc(%ebp)
  801b60:	50                   	push   %eax
  801b61:	6a 20                	push   $0x20
  801b63:	e8 89 fc ff ff       	call   8017f1 <syscall>
  801b68:	83 c4 18             	add    $0x18,%esp
}
  801b6b:	c9                   	leave  
  801b6c:	c3                   	ret    

00801b6d <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b6d:	55                   	push   %ebp
  801b6e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b70:	8b 45 08             	mov    0x8(%ebp),%eax
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	50                   	push   %eax
  801b7c:	6a 21                	push   $0x21
  801b7e:	e8 6e fc ff ff       	call   8017f1 <syscall>
  801b83:	83 c4 18             	add    $0x18,%esp
}
  801b86:	90                   	nop
  801b87:	c9                   	leave  
  801b88:	c3                   	ret    

00801b89 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b89:	55                   	push   %ebp
  801b8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	50                   	push   %eax
  801b98:	6a 22                	push   $0x22
  801b9a:	e8 52 fc ff ff       	call   8017f1 <syscall>
  801b9f:	83 c4 18             	add    $0x18,%esp
}
  801ba2:	c9                   	leave  
  801ba3:	c3                   	ret    

00801ba4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 02                	push   $0x2
  801bb3:	e8 39 fc ff ff       	call   8017f1 <syscall>
  801bb8:	83 c4 18             	add    $0x18,%esp
}
  801bbb:	c9                   	leave  
  801bbc:	c3                   	ret    

00801bbd <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 03                	push   $0x3
  801bcc:	e8 20 fc ff ff       	call   8017f1 <syscall>
  801bd1:	83 c4 18             	add    $0x18,%esp
}
  801bd4:	c9                   	leave  
  801bd5:	c3                   	ret    

00801bd6 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 04                	push   $0x4
  801be5:	e8 07 fc ff ff       	call   8017f1 <syscall>
  801bea:	83 c4 18             	add    $0x18,%esp
}
  801bed:	c9                   	leave  
  801bee:	c3                   	ret    

00801bef <sys_exit_env>:


void sys_exit_env(void)
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 23                	push   $0x23
  801bfe:	e8 ee fb ff ff       	call   8017f1 <syscall>
  801c03:	83 c4 18             	add    $0x18,%esp
}
  801c06:	90                   	nop
  801c07:	c9                   	leave  
  801c08:	c3                   	ret    

00801c09 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c09:	55                   	push   %ebp
  801c0a:	89 e5                	mov    %esp,%ebp
  801c0c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c0f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c12:	8d 50 04             	lea    0x4(%eax),%edx
  801c15:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	52                   	push   %edx
  801c1f:	50                   	push   %eax
  801c20:	6a 24                	push   $0x24
  801c22:	e8 ca fb ff ff       	call   8017f1 <syscall>
  801c27:	83 c4 18             	add    $0x18,%esp
	return result;
  801c2a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c2d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c30:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c33:	89 01                	mov    %eax,(%ecx)
  801c35:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c38:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3b:	c9                   	leave  
  801c3c:	c2 04 00             	ret    $0x4

00801c3f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c3f:	55                   	push   %ebp
  801c40:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	ff 75 10             	pushl  0x10(%ebp)
  801c49:	ff 75 0c             	pushl  0xc(%ebp)
  801c4c:	ff 75 08             	pushl  0x8(%ebp)
  801c4f:	6a 12                	push   $0x12
  801c51:	e8 9b fb ff ff       	call   8017f1 <syscall>
  801c56:	83 c4 18             	add    $0x18,%esp
	return ;
  801c59:	90                   	nop
}
  801c5a:	c9                   	leave  
  801c5b:	c3                   	ret    

00801c5c <sys_rcr2>:
uint32 sys_rcr2()
{
  801c5c:	55                   	push   %ebp
  801c5d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 25                	push   $0x25
  801c6b:	e8 81 fb ff ff       	call   8017f1 <syscall>
  801c70:	83 c4 18             	add    $0x18,%esp
}
  801c73:	c9                   	leave  
  801c74:	c3                   	ret    

00801c75 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c75:	55                   	push   %ebp
  801c76:	89 e5                	mov    %esp,%ebp
  801c78:	83 ec 04             	sub    $0x4,%esp
  801c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c81:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	50                   	push   %eax
  801c8e:	6a 26                	push   $0x26
  801c90:	e8 5c fb ff ff       	call   8017f1 <syscall>
  801c95:	83 c4 18             	add    $0x18,%esp
	return ;
  801c98:	90                   	nop
}
  801c99:	c9                   	leave  
  801c9a:	c3                   	ret    

00801c9b <rsttst>:
void rsttst()
{
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 28                	push   $0x28
  801caa:	e8 42 fb ff ff       	call   8017f1 <syscall>
  801caf:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb2:	90                   	nop
}
  801cb3:	c9                   	leave  
  801cb4:	c3                   	ret    

00801cb5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cb5:	55                   	push   %ebp
  801cb6:	89 e5                	mov    %esp,%ebp
  801cb8:	83 ec 04             	sub    $0x4,%esp
  801cbb:	8b 45 14             	mov    0x14(%ebp),%eax
  801cbe:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cc1:	8b 55 18             	mov    0x18(%ebp),%edx
  801cc4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cc8:	52                   	push   %edx
  801cc9:	50                   	push   %eax
  801cca:	ff 75 10             	pushl  0x10(%ebp)
  801ccd:	ff 75 0c             	pushl  0xc(%ebp)
  801cd0:	ff 75 08             	pushl  0x8(%ebp)
  801cd3:	6a 27                	push   $0x27
  801cd5:	e8 17 fb ff ff       	call   8017f1 <syscall>
  801cda:	83 c4 18             	add    $0x18,%esp
	return ;
  801cdd:	90                   	nop
}
  801cde:	c9                   	leave  
  801cdf:	c3                   	ret    

00801ce0 <chktst>:
void chktst(uint32 n)
{
  801ce0:	55                   	push   %ebp
  801ce1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	ff 75 08             	pushl  0x8(%ebp)
  801cee:	6a 29                	push   $0x29
  801cf0:	e8 fc fa ff ff       	call   8017f1 <syscall>
  801cf5:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf8:	90                   	nop
}
  801cf9:	c9                   	leave  
  801cfa:	c3                   	ret    

00801cfb <inctst>:

void inctst()
{
  801cfb:	55                   	push   %ebp
  801cfc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 2a                	push   $0x2a
  801d0a:	e8 e2 fa ff ff       	call   8017f1 <syscall>
  801d0f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d12:	90                   	nop
}
  801d13:	c9                   	leave  
  801d14:	c3                   	ret    

00801d15 <gettst>:
uint32 gettst()
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 2b                	push   $0x2b
  801d24:	e8 c8 fa ff ff       	call   8017f1 <syscall>
  801d29:	83 c4 18             	add    $0x18,%esp
}
  801d2c:	c9                   	leave  
  801d2d:	c3                   	ret    

00801d2e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
  801d31:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 2c                	push   $0x2c
  801d40:	e8 ac fa ff ff       	call   8017f1 <syscall>
  801d45:	83 c4 18             	add    $0x18,%esp
  801d48:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d4b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d4f:	75 07                	jne    801d58 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d51:	b8 01 00 00 00       	mov    $0x1,%eax
  801d56:	eb 05                	jmp    801d5d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d58:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d5d:	c9                   	leave  
  801d5e:	c3                   	ret    

00801d5f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
  801d62:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 2c                	push   $0x2c
  801d71:	e8 7b fa ff ff       	call   8017f1 <syscall>
  801d76:	83 c4 18             	add    $0x18,%esp
  801d79:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d7c:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d80:	75 07                	jne    801d89 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d82:	b8 01 00 00 00       	mov    $0x1,%eax
  801d87:	eb 05                	jmp    801d8e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d89:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d8e:	c9                   	leave  
  801d8f:	c3                   	ret    

00801d90 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
  801d93:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 2c                	push   $0x2c
  801da2:	e8 4a fa ff ff       	call   8017f1 <syscall>
  801da7:	83 c4 18             	add    $0x18,%esp
  801daa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801dad:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801db1:	75 07                	jne    801dba <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801db3:	b8 01 00 00 00       	mov    $0x1,%eax
  801db8:	eb 05                	jmp    801dbf <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801dba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dbf:	c9                   	leave  
  801dc0:	c3                   	ret    

00801dc1 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801dc1:	55                   	push   %ebp
  801dc2:	89 e5                	mov    %esp,%ebp
  801dc4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 2c                	push   $0x2c
  801dd3:	e8 19 fa ff ff       	call   8017f1 <syscall>
  801dd8:	83 c4 18             	add    $0x18,%esp
  801ddb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801dde:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801de2:	75 07                	jne    801deb <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801de4:	b8 01 00 00 00       	mov    $0x1,%eax
  801de9:	eb 05                	jmp    801df0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801deb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801df0:	c9                   	leave  
  801df1:	c3                   	ret    

00801df2 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801df2:	55                   	push   %ebp
  801df3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	ff 75 08             	pushl  0x8(%ebp)
  801e00:	6a 2d                	push   $0x2d
  801e02:	e8 ea f9 ff ff       	call   8017f1 <syscall>
  801e07:	83 c4 18             	add    $0x18,%esp
	return ;
  801e0a:	90                   	nop
}
  801e0b:	c9                   	leave  
  801e0c:	c3                   	ret    

00801e0d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
  801e10:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e11:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e14:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e17:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1d:	6a 00                	push   $0x0
  801e1f:	53                   	push   %ebx
  801e20:	51                   	push   %ecx
  801e21:	52                   	push   %edx
  801e22:	50                   	push   %eax
  801e23:	6a 2e                	push   $0x2e
  801e25:	e8 c7 f9 ff ff       	call   8017f1 <syscall>
  801e2a:	83 c4 18             	add    $0x18,%esp
}
  801e2d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e30:	c9                   	leave  
  801e31:	c3                   	ret    

00801e32 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e32:	55                   	push   %ebp
  801e33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e35:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e38:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	52                   	push   %edx
  801e42:	50                   	push   %eax
  801e43:	6a 2f                	push   $0x2f
  801e45:	e8 a7 f9 ff ff       	call   8017f1 <syscall>
  801e4a:	83 c4 18             	add    $0x18,%esp
}
  801e4d:	c9                   	leave  
  801e4e:	c3                   	ret    

00801e4f <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e4f:	55                   	push   %ebp
  801e50:	89 e5                	mov    %esp,%ebp
  801e52:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e55:	83 ec 0c             	sub    $0xc,%esp
  801e58:	68 60 39 80 00       	push   $0x803960
  801e5d:	e8 c3 e6 ff ff       	call   800525 <cprintf>
  801e62:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e65:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e6c:	83 ec 0c             	sub    $0xc,%esp
  801e6f:	68 8c 39 80 00       	push   $0x80398c
  801e74:	e8 ac e6 ff ff       	call   800525 <cprintf>
  801e79:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e7c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e80:	a1 38 41 80 00       	mov    0x804138,%eax
  801e85:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e88:	eb 56                	jmp    801ee0 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e8a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e8e:	74 1c                	je     801eac <print_mem_block_lists+0x5d>
  801e90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e93:	8b 50 08             	mov    0x8(%eax),%edx
  801e96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e99:	8b 48 08             	mov    0x8(%eax),%ecx
  801e9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e9f:	8b 40 0c             	mov    0xc(%eax),%eax
  801ea2:	01 c8                	add    %ecx,%eax
  801ea4:	39 c2                	cmp    %eax,%edx
  801ea6:	73 04                	jae    801eac <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ea8:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801eac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eaf:	8b 50 08             	mov    0x8(%eax),%edx
  801eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb5:	8b 40 0c             	mov    0xc(%eax),%eax
  801eb8:	01 c2                	add    %eax,%edx
  801eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebd:	8b 40 08             	mov    0x8(%eax),%eax
  801ec0:	83 ec 04             	sub    $0x4,%esp
  801ec3:	52                   	push   %edx
  801ec4:	50                   	push   %eax
  801ec5:	68 a1 39 80 00       	push   $0x8039a1
  801eca:	e8 56 e6 ff ff       	call   800525 <cprintf>
  801ecf:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ed8:	a1 40 41 80 00       	mov    0x804140,%eax
  801edd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ee0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ee4:	74 07                	je     801eed <print_mem_block_lists+0x9e>
  801ee6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee9:	8b 00                	mov    (%eax),%eax
  801eeb:	eb 05                	jmp    801ef2 <print_mem_block_lists+0xa3>
  801eed:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef2:	a3 40 41 80 00       	mov    %eax,0x804140
  801ef7:	a1 40 41 80 00       	mov    0x804140,%eax
  801efc:	85 c0                	test   %eax,%eax
  801efe:	75 8a                	jne    801e8a <print_mem_block_lists+0x3b>
  801f00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f04:	75 84                	jne    801e8a <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f06:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f0a:	75 10                	jne    801f1c <print_mem_block_lists+0xcd>
  801f0c:	83 ec 0c             	sub    $0xc,%esp
  801f0f:	68 b0 39 80 00       	push   $0x8039b0
  801f14:	e8 0c e6 ff ff       	call   800525 <cprintf>
  801f19:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f1c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f23:	83 ec 0c             	sub    $0xc,%esp
  801f26:	68 d4 39 80 00       	push   $0x8039d4
  801f2b:	e8 f5 e5 ff ff       	call   800525 <cprintf>
  801f30:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f33:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f37:	a1 40 40 80 00       	mov    0x804040,%eax
  801f3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f3f:	eb 56                	jmp    801f97 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f41:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f45:	74 1c                	je     801f63 <print_mem_block_lists+0x114>
  801f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4a:	8b 50 08             	mov    0x8(%eax),%edx
  801f4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f50:	8b 48 08             	mov    0x8(%eax),%ecx
  801f53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f56:	8b 40 0c             	mov    0xc(%eax),%eax
  801f59:	01 c8                	add    %ecx,%eax
  801f5b:	39 c2                	cmp    %eax,%edx
  801f5d:	73 04                	jae    801f63 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f5f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f66:	8b 50 08             	mov    0x8(%eax),%edx
  801f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6c:	8b 40 0c             	mov    0xc(%eax),%eax
  801f6f:	01 c2                	add    %eax,%edx
  801f71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f74:	8b 40 08             	mov    0x8(%eax),%eax
  801f77:	83 ec 04             	sub    $0x4,%esp
  801f7a:	52                   	push   %edx
  801f7b:	50                   	push   %eax
  801f7c:	68 a1 39 80 00       	push   $0x8039a1
  801f81:	e8 9f e5 ff ff       	call   800525 <cprintf>
  801f86:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f8f:	a1 48 40 80 00       	mov    0x804048,%eax
  801f94:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f97:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f9b:	74 07                	je     801fa4 <print_mem_block_lists+0x155>
  801f9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa0:	8b 00                	mov    (%eax),%eax
  801fa2:	eb 05                	jmp    801fa9 <print_mem_block_lists+0x15a>
  801fa4:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa9:	a3 48 40 80 00       	mov    %eax,0x804048
  801fae:	a1 48 40 80 00       	mov    0x804048,%eax
  801fb3:	85 c0                	test   %eax,%eax
  801fb5:	75 8a                	jne    801f41 <print_mem_block_lists+0xf2>
  801fb7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fbb:	75 84                	jne    801f41 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fbd:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fc1:	75 10                	jne    801fd3 <print_mem_block_lists+0x184>
  801fc3:	83 ec 0c             	sub    $0xc,%esp
  801fc6:	68 ec 39 80 00       	push   $0x8039ec
  801fcb:	e8 55 e5 ff ff       	call   800525 <cprintf>
  801fd0:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801fd3:	83 ec 0c             	sub    $0xc,%esp
  801fd6:	68 60 39 80 00       	push   $0x803960
  801fdb:	e8 45 e5 ff ff       	call   800525 <cprintf>
  801fe0:	83 c4 10             	add    $0x10,%esp

}
  801fe3:	90                   	nop
  801fe4:	c9                   	leave  
  801fe5:	c3                   	ret    

00801fe6 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801fe6:	55                   	push   %ebp
  801fe7:	89 e5                	mov    %esp,%ebp
  801fe9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  801fec:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801ff3:	00 00 00 
  801ff6:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801ffd:	00 00 00 
  802000:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802007:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  80200a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802011:	e9 9e 00 00 00       	jmp    8020b4 <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802016:	a1 50 40 80 00       	mov    0x804050,%eax
  80201b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80201e:	c1 e2 04             	shl    $0x4,%edx
  802021:	01 d0                	add    %edx,%eax
  802023:	85 c0                	test   %eax,%eax
  802025:	75 14                	jne    80203b <initialize_MemBlocksList+0x55>
  802027:	83 ec 04             	sub    $0x4,%esp
  80202a:	68 14 3a 80 00       	push   $0x803a14
  80202f:	6a 47                	push   $0x47
  802031:	68 37 3a 80 00       	push   $0x803a37
  802036:	e8 36 e2 ff ff       	call   800271 <_panic>
  80203b:	a1 50 40 80 00       	mov    0x804050,%eax
  802040:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802043:	c1 e2 04             	shl    $0x4,%edx
  802046:	01 d0                	add    %edx,%eax
  802048:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80204e:	89 10                	mov    %edx,(%eax)
  802050:	8b 00                	mov    (%eax),%eax
  802052:	85 c0                	test   %eax,%eax
  802054:	74 18                	je     80206e <initialize_MemBlocksList+0x88>
  802056:	a1 48 41 80 00       	mov    0x804148,%eax
  80205b:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802061:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802064:	c1 e1 04             	shl    $0x4,%ecx
  802067:	01 ca                	add    %ecx,%edx
  802069:	89 50 04             	mov    %edx,0x4(%eax)
  80206c:	eb 12                	jmp    802080 <initialize_MemBlocksList+0x9a>
  80206e:	a1 50 40 80 00       	mov    0x804050,%eax
  802073:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802076:	c1 e2 04             	shl    $0x4,%edx
  802079:	01 d0                	add    %edx,%eax
  80207b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802080:	a1 50 40 80 00       	mov    0x804050,%eax
  802085:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802088:	c1 e2 04             	shl    $0x4,%edx
  80208b:	01 d0                	add    %edx,%eax
  80208d:	a3 48 41 80 00       	mov    %eax,0x804148
  802092:	a1 50 40 80 00       	mov    0x804050,%eax
  802097:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80209a:	c1 e2 04             	shl    $0x4,%edx
  80209d:	01 d0                	add    %edx,%eax
  80209f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020a6:	a1 54 41 80 00       	mov    0x804154,%eax
  8020ab:	40                   	inc    %eax
  8020ac:	a3 54 41 80 00       	mov    %eax,0x804154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  8020b1:	ff 45 f4             	incl   -0xc(%ebp)
  8020b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020ba:	0f 82 56 ff ff ff    	jb     802016 <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  8020c0:	90                   	nop
  8020c1:	c9                   	leave  
  8020c2:	c3                   	ret    

008020c3 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020c3:	55                   	push   %ebp
  8020c4:	89 e5                	mov    %esp,%ebp
  8020c6:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  8020c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cc:	8b 00                	mov    (%eax),%eax
  8020ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020d1:	eb 19                	jmp    8020ec <find_block+0x29>
	{
		if(element->sva == va){
  8020d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020d6:	8b 40 08             	mov    0x8(%eax),%eax
  8020d9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8020dc:	75 05                	jne    8020e3 <find_block+0x20>
			 		return element;
  8020de:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020e1:	eb 36                	jmp    802119 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  8020e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e6:	8b 40 08             	mov    0x8(%eax),%eax
  8020e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020f0:	74 07                	je     8020f9 <find_block+0x36>
  8020f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020f5:	8b 00                	mov    (%eax),%eax
  8020f7:	eb 05                	jmp    8020fe <find_block+0x3b>
  8020f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020fe:	8b 55 08             	mov    0x8(%ebp),%edx
  802101:	89 42 08             	mov    %eax,0x8(%edx)
  802104:	8b 45 08             	mov    0x8(%ebp),%eax
  802107:	8b 40 08             	mov    0x8(%eax),%eax
  80210a:	85 c0                	test   %eax,%eax
  80210c:	75 c5                	jne    8020d3 <find_block+0x10>
  80210e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802112:	75 bf                	jne    8020d3 <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  802114:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802119:	c9                   	leave  
  80211a:	c3                   	ret    

0080211b <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80211b:	55                   	push   %ebp
  80211c:	89 e5                	mov    %esp,%ebp
  80211e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  802121:	a1 44 40 80 00       	mov    0x804044,%eax
  802126:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  802129:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80212e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  802131:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802135:	74 0a                	je     802141 <insert_sorted_allocList+0x26>
  802137:	8b 45 08             	mov    0x8(%ebp),%eax
  80213a:	8b 40 08             	mov    0x8(%eax),%eax
  80213d:	85 c0                	test   %eax,%eax
  80213f:	75 65                	jne    8021a6 <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802141:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802145:	75 14                	jne    80215b <insert_sorted_allocList+0x40>
  802147:	83 ec 04             	sub    $0x4,%esp
  80214a:	68 14 3a 80 00       	push   $0x803a14
  80214f:	6a 6e                	push   $0x6e
  802151:	68 37 3a 80 00       	push   $0x803a37
  802156:	e8 16 e1 ff ff       	call   800271 <_panic>
  80215b:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802161:	8b 45 08             	mov    0x8(%ebp),%eax
  802164:	89 10                	mov    %edx,(%eax)
  802166:	8b 45 08             	mov    0x8(%ebp),%eax
  802169:	8b 00                	mov    (%eax),%eax
  80216b:	85 c0                	test   %eax,%eax
  80216d:	74 0d                	je     80217c <insert_sorted_allocList+0x61>
  80216f:	a1 40 40 80 00       	mov    0x804040,%eax
  802174:	8b 55 08             	mov    0x8(%ebp),%edx
  802177:	89 50 04             	mov    %edx,0x4(%eax)
  80217a:	eb 08                	jmp    802184 <insert_sorted_allocList+0x69>
  80217c:	8b 45 08             	mov    0x8(%ebp),%eax
  80217f:	a3 44 40 80 00       	mov    %eax,0x804044
  802184:	8b 45 08             	mov    0x8(%ebp),%eax
  802187:	a3 40 40 80 00       	mov    %eax,0x804040
  80218c:	8b 45 08             	mov    0x8(%ebp),%eax
  80218f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802196:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80219b:	40                   	inc    %eax
  80219c:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8021a1:	e9 cf 01 00 00       	jmp    802375 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  8021a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a9:	8b 50 08             	mov    0x8(%eax),%edx
  8021ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8021af:	8b 40 08             	mov    0x8(%eax),%eax
  8021b2:	39 c2                	cmp    %eax,%edx
  8021b4:	73 65                	jae    80221b <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8021b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021ba:	75 14                	jne    8021d0 <insert_sorted_allocList+0xb5>
  8021bc:	83 ec 04             	sub    $0x4,%esp
  8021bf:	68 50 3a 80 00       	push   $0x803a50
  8021c4:	6a 72                	push   $0x72
  8021c6:	68 37 3a 80 00       	push   $0x803a37
  8021cb:	e8 a1 e0 ff ff       	call   800271 <_panic>
  8021d0:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8021d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d9:	89 50 04             	mov    %edx,0x4(%eax)
  8021dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021df:	8b 40 04             	mov    0x4(%eax),%eax
  8021e2:	85 c0                	test   %eax,%eax
  8021e4:	74 0c                	je     8021f2 <insert_sorted_allocList+0xd7>
  8021e6:	a1 44 40 80 00       	mov    0x804044,%eax
  8021eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8021ee:	89 10                	mov    %edx,(%eax)
  8021f0:	eb 08                	jmp    8021fa <insert_sorted_allocList+0xdf>
  8021f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f5:	a3 40 40 80 00       	mov    %eax,0x804040
  8021fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fd:	a3 44 40 80 00       	mov    %eax,0x804044
  802202:	8b 45 08             	mov    0x8(%ebp),%eax
  802205:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80220b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802210:	40                   	inc    %eax
  802211:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  802216:	e9 5a 01 00 00       	jmp    802375 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  80221b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80221e:	8b 50 08             	mov    0x8(%eax),%edx
  802221:	8b 45 08             	mov    0x8(%ebp),%eax
  802224:	8b 40 08             	mov    0x8(%eax),%eax
  802227:	39 c2                	cmp    %eax,%edx
  802229:	75 70                	jne    80229b <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  80222b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80222f:	74 06                	je     802237 <insert_sorted_allocList+0x11c>
  802231:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802235:	75 14                	jne    80224b <insert_sorted_allocList+0x130>
  802237:	83 ec 04             	sub    $0x4,%esp
  80223a:	68 74 3a 80 00       	push   $0x803a74
  80223f:	6a 75                	push   $0x75
  802241:	68 37 3a 80 00       	push   $0x803a37
  802246:	e8 26 e0 ff ff       	call   800271 <_panic>
  80224b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80224e:	8b 10                	mov    (%eax),%edx
  802250:	8b 45 08             	mov    0x8(%ebp),%eax
  802253:	89 10                	mov    %edx,(%eax)
  802255:	8b 45 08             	mov    0x8(%ebp),%eax
  802258:	8b 00                	mov    (%eax),%eax
  80225a:	85 c0                	test   %eax,%eax
  80225c:	74 0b                	je     802269 <insert_sorted_allocList+0x14e>
  80225e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802261:	8b 00                	mov    (%eax),%eax
  802263:	8b 55 08             	mov    0x8(%ebp),%edx
  802266:	89 50 04             	mov    %edx,0x4(%eax)
  802269:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80226c:	8b 55 08             	mov    0x8(%ebp),%edx
  80226f:	89 10                	mov    %edx,(%eax)
  802271:	8b 45 08             	mov    0x8(%ebp),%eax
  802274:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802277:	89 50 04             	mov    %edx,0x4(%eax)
  80227a:	8b 45 08             	mov    0x8(%ebp),%eax
  80227d:	8b 00                	mov    (%eax),%eax
  80227f:	85 c0                	test   %eax,%eax
  802281:	75 08                	jne    80228b <insert_sorted_allocList+0x170>
  802283:	8b 45 08             	mov    0x8(%ebp),%eax
  802286:	a3 44 40 80 00       	mov    %eax,0x804044
  80228b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802290:	40                   	inc    %eax
  802291:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  802296:	e9 da 00 00 00       	jmp    802375 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  80229b:	a1 40 40 80 00       	mov    0x804040,%eax
  8022a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022a3:	e9 9d 00 00 00       	jmp    802345 <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  8022a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ab:	8b 00                	mov    (%eax),%eax
  8022ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  8022b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b3:	8b 50 08             	mov    0x8(%eax),%edx
  8022b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b9:	8b 40 08             	mov    0x8(%eax),%eax
  8022bc:	39 c2                	cmp    %eax,%edx
  8022be:	76 7d                	jbe    80233d <insert_sorted_allocList+0x222>
  8022c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c3:	8b 50 08             	mov    0x8(%eax),%edx
  8022c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022c9:	8b 40 08             	mov    0x8(%eax),%eax
  8022cc:	39 c2                	cmp    %eax,%edx
  8022ce:	73 6d                	jae    80233d <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  8022d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022d4:	74 06                	je     8022dc <insert_sorted_allocList+0x1c1>
  8022d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022da:	75 14                	jne    8022f0 <insert_sorted_allocList+0x1d5>
  8022dc:	83 ec 04             	sub    $0x4,%esp
  8022df:	68 74 3a 80 00       	push   $0x803a74
  8022e4:	6a 7c                	push   $0x7c
  8022e6:	68 37 3a 80 00       	push   $0x803a37
  8022eb:	e8 81 df ff ff       	call   800271 <_panic>
  8022f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f3:	8b 10                	mov    (%eax),%edx
  8022f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f8:	89 10                	mov    %edx,(%eax)
  8022fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fd:	8b 00                	mov    (%eax),%eax
  8022ff:	85 c0                	test   %eax,%eax
  802301:	74 0b                	je     80230e <insert_sorted_allocList+0x1f3>
  802303:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802306:	8b 00                	mov    (%eax),%eax
  802308:	8b 55 08             	mov    0x8(%ebp),%edx
  80230b:	89 50 04             	mov    %edx,0x4(%eax)
  80230e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802311:	8b 55 08             	mov    0x8(%ebp),%edx
  802314:	89 10                	mov    %edx,(%eax)
  802316:	8b 45 08             	mov    0x8(%ebp),%eax
  802319:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80231c:	89 50 04             	mov    %edx,0x4(%eax)
  80231f:	8b 45 08             	mov    0x8(%ebp),%eax
  802322:	8b 00                	mov    (%eax),%eax
  802324:	85 c0                	test   %eax,%eax
  802326:	75 08                	jne    802330 <insert_sorted_allocList+0x215>
  802328:	8b 45 08             	mov    0x8(%ebp),%eax
  80232b:	a3 44 40 80 00       	mov    %eax,0x804044
  802330:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802335:	40                   	inc    %eax
  802336:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  80233b:	eb 38                	jmp    802375 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  80233d:	a1 48 40 80 00       	mov    0x804048,%eax
  802342:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802345:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802349:	74 07                	je     802352 <insert_sorted_allocList+0x237>
  80234b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234e:	8b 00                	mov    (%eax),%eax
  802350:	eb 05                	jmp    802357 <insert_sorted_allocList+0x23c>
  802352:	b8 00 00 00 00       	mov    $0x0,%eax
  802357:	a3 48 40 80 00       	mov    %eax,0x804048
  80235c:	a1 48 40 80 00       	mov    0x804048,%eax
  802361:	85 c0                	test   %eax,%eax
  802363:	0f 85 3f ff ff ff    	jne    8022a8 <insert_sorted_allocList+0x18d>
  802369:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80236d:	0f 85 35 ff ff ff    	jne    8022a8 <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  802373:	eb 00                	jmp    802375 <insert_sorted_allocList+0x25a>
  802375:	90                   	nop
  802376:	c9                   	leave  
  802377:	c3                   	ret    

00802378 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802378:	55                   	push   %ebp
  802379:	89 e5                	mov    %esp,%ebp
  80237b:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  80237e:	a1 38 41 80 00       	mov    0x804138,%eax
  802383:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802386:	e9 6b 02 00 00       	jmp    8025f6 <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  80238b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238e:	8b 40 0c             	mov    0xc(%eax),%eax
  802391:	3b 45 08             	cmp    0x8(%ebp),%eax
  802394:	0f 85 90 00 00 00    	jne    80242a <alloc_block_FF+0xb2>
			  temp=element;
  80239a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239d:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  8023a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023a4:	75 17                	jne    8023bd <alloc_block_FF+0x45>
  8023a6:	83 ec 04             	sub    $0x4,%esp
  8023a9:	68 a8 3a 80 00       	push   $0x803aa8
  8023ae:	68 92 00 00 00       	push   $0x92
  8023b3:	68 37 3a 80 00       	push   $0x803a37
  8023b8:	e8 b4 de ff ff       	call   800271 <_panic>
  8023bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c0:	8b 00                	mov    (%eax),%eax
  8023c2:	85 c0                	test   %eax,%eax
  8023c4:	74 10                	je     8023d6 <alloc_block_FF+0x5e>
  8023c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c9:	8b 00                	mov    (%eax),%eax
  8023cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023ce:	8b 52 04             	mov    0x4(%edx),%edx
  8023d1:	89 50 04             	mov    %edx,0x4(%eax)
  8023d4:	eb 0b                	jmp    8023e1 <alloc_block_FF+0x69>
  8023d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d9:	8b 40 04             	mov    0x4(%eax),%eax
  8023dc:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8023e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e4:	8b 40 04             	mov    0x4(%eax),%eax
  8023e7:	85 c0                	test   %eax,%eax
  8023e9:	74 0f                	je     8023fa <alloc_block_FF+0x82>
  8023eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ee:	8b 40 04             	mov    0x4(%eax),%eax
  8023f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023f4:	8b 12                	mov    (%edx),%edx
  8023f6:	89 10                	mov    %edx,(%eax)
  8023f8:	eb 0a                	jmp    802404 <alloc_block_FF+0x8c>
  8023fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fd:	8b 00                	mov    (%eax),%eax
  8023ff:	a3 38 41 80 00       	mov    %eax,0x804138
  802404:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802407:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80240d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802410:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802417:	a1 44 41 80 00       	mov    0x804144,%eax
  80241c:	48                   	dec    %eax
  80241d:	a3 44 41 80 00       	mov    %eax,0x804144
			  return temp;
  802422:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802425:	e9 ff 01 00 00       	jmp    802629 <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  80242a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242d:	8b 40 0c             	mov    0xc(%eax),%eax
  802430:	3b 45 08             	cmp    0x8(%ebp),%eax
  802433:	0f 86 b5 01 00 00    	jbe    8025ee <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  802439:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243c:	8b 40 0c             	mov    0xc(%eax),%eax
  80243f:	2b 45 08             	sub    0x8(%ebp),%eax
  802442:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  802445:	a1 48 41 80 00       	mov    0x804148,%eax
  80244a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  80244d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802451:	75 17                	jne    80246a <alloc_block_FF+0xf2>
  802453:	83 ec 04             	sub    $0x4,%esp
  802456:	68 a8 3a 80 00       	push   $0x803aa8
  80245b:	68 99 00 00 00       	push   $0x99
  802460:	68 37 3a 80 00       	push   $0x803a37
  802465:	e8 07 de ff ff       	call   800271 <_panic>
  80246a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80246d:	8b 00                	mov    (%eax),%eax
  80246f:	85 c0                	test   %eax,%eax
  802471:	74 10                	je     802483 <alloc_block_FF+0x10b>
  802473:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802476:	8b 00                	mov    (%eax),%eax
  802478:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80247b:	8b 52 04             	mov    0x4(%edx),%edx
  80247e:	89 50 04             	mov    %edx,0x4(%eax)
  802481:	eb 0b                	jmp    80248e <alloc_block_FF+0x116>
  802483:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802486:	8b 40 04             	mov    0x4(%eax),%eax
  802489:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80248e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802491:	8b 40 04             	mov    0x4(%eax),%eax
  802494:	85 c0                	test   %eax,%eax
  802496:	74 0f                	je     8024a7 <alloc_block_FF+0x12f>
  802498:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80249b:	8b 40 04             	mov    0x4(%eax),%eax
  80249e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024a1:	8b 12                	mov    (%edx),%edx
  8024a3:	89 10                	mov    %edx,(%eax)
  8024a5:	eb 0a                	jmp    8024b1 <alloc_block_FF+0x139>
  8024a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024aa:	8b 00                	mov    (%eax),%eax
  8024ac:	a3 48 41 80 00       	mov    %eax,0x804148
  8024b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024bd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024c4:	a1 54 41 80 00       	mov    0x804154,%eax
  8024c9:	48                   	dec    %eax
  8024ca:	a3 54 41 80 00       	mov    %eax,0x804154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  8024cf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8024d3:	75 17                	jne    8024ec <alloc_block_FF+0x174>
  8024d5:	83 ec 04             	sub    $0x4,%esp
  8024d8:	68 50 3a 80 00       	push   $0x803a50
  8024dd:	68 9a 00 00 00       	push   $0x9a
  8024e2:	68 37 3a 80 00       	push   $0x803a37
  8024e7:	e8 85 dd ff ff       	call   800271 <_panic>
  8024ec:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8024f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024f5:	89 50 04             	mov    %edx,0x4(%eax)
  8024f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024fb:	8b 40 04             	mov    0x4(%eax),%eax
  8024fe:	85 c0                	test   %eax,%eax
  802500:	74 0c                	je     80250e <alloc_block_FF+0x196>
  802502:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802507:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80250a:	89 10                	mov    %edx,(%eax)
  80250c:	eb 08                	jmp    802516 <alloc_block_FF+0x19e>
  80250e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802511:	a3 38 41 80 00       	mov    %eax,0x804138
  802516:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802519:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80251e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802521:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802527:	a1 44 41 80 00       	mov    0x804144,%eax
  80252c:	40                   	inc    %eax
  80252d:	a3 44 41 80 00       	mov    %eax,0x804144
		  // setting the size & sva
		  new_block->size=size;
  802532:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802535:	8b 55 08             	mov    0x8(%ebp),%edx
  802538:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  80253b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253e:	8b 50 08             	mov    0x8(%eax),%edx
  802541:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802544:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  802547:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80254d:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  802550:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802553:	8b 50 08             	mov    0x8(%eax),%edx
  802556:	8b 45 08             	mov    0x8(%ebp),%eax
  802559:	01 c2                	add    %eax,%edx
  80255b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255e:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  802561:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802564:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  802567:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80256b:	75 17                	jne    802584 <alloc_block_FF+0x20c>
  80256d:	83 ec 04             	sub    $0x4,%esp
  802570:	68 a8 3a 80 00       	push   $0x803aa8
  802575:	68 a2 00 00 00       	push   $0xa2
  80257a:	68 37 3a 80 00       	push   $0x803a37
  80257f:	e8 ed dc ff ff       	call   800271 <_panic>
  802584:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802587:	8b 00                	mov    (%eax),%eax
  802589:	85 c0                	test   %eax,%eax
  80258b:	74 10                	je     80259d <alloc_block_FF+0x225>
  80258d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802590:	8b 00                	mov    (%eax),%eax
  802592:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802595:	8b 52 04             	mov    0x4(%edx),%edx
  802598:	89 50 04             	mov    %edx,0x4(%eax)
  80259b:	eb 0b                	jmp    8025a8 <alloc_block_FF+0x230>
  80259d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025a0:	8b 40 04             	mov    0x4(%eax),%eax
  8025a3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ab:	8b 40 04             	mov    0x4(%eax),%eax
  8025ae:	85 c0                	test   %eax,%eax
  8025b0:	74 0f                	je     8025c1 <alloc_block_FF+0x249>
  8025b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025b5:	8b 40 04             	mov    0x4(%eax),%eax
  8025b8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025bb:	8b 12                	mov    (%edx),%edx
  8025bd:	89 10                	mov    %edx,(%eax)
  8025bf:	eb 0a                	jmp    8025cb <alloc_block_FF+0x253>
  8025c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025c4:	8b 00                	mov    (%eax),%eax
  8025c6:	a3 38 41 80 00       	mov    %eax,0x804138
  8025cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025de:	a1 44 41 80 00       	mov    0x804144,%eax
  8025e3:	48                   	dec    %eax
  8025e4:	a3 44 41 80 00       	mov    %eax,0x804144
		  return temp;
  8025e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025ec:	eb 3b                	jmp    802629 <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  8025ee:	a1 40 41 80 00       	mov    0x804140,%eax
  8025f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025fa:	74 07                	je     802603 <alloc_block_FF+0x28b>
  8025fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ff:	8b 00                	mov    (%eax),%eax
  802601:	eb 05                	jmp    802608 <alloc_block_FF+0x290>
  802603:	b8 00 00 00 00       	mov    $0x0,%eax
  802608:	a3 40 41 80 00       	mov    %eax,0x804140
  80260d:	a1 40 41 80 00       	mov    0x804140,%eax
  802612:	85 c0                	test   %eax,%eax
  802614:	0f 85 71 fd ff ff    	jne    80238b <alloc_block_FF+0x13>
  80261a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80261e:	0f 85 67 fd ff ff    	jne    80238b <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  802624:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802629:	c9                   	leave  
  80262a:	c3                   	ret    

0080262b <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80262b:	55                   	push   %ebp
  80262c:	89 e5                	mov    %esp,%ebp
  80262e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  802631:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  802638:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  80263f:	a1 38 41 80 00       	mov    0x804138,%eax
  802644:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802647:	e9 d3 00 00 00       	jmp    80271f <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  80264c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80264f:	8b 40 0c             	mov    0xc(%eax),%eax
  802652:	3b 45 08             	cmp    0x8(%ebp),%eax
  802655:	0f 85 90 00 00 00    	jne    8026eb <alloc_block_BF+0xc0>
	   temp = element;
  80265b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80265e:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  802661:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802665:	75 17                	jne    80267e <alloc_block_BF+0x53>
  802667:	83 ec 04             	sub    $0x4,%esp
  80266a:	68 a8 3a 80 00       	push   $0x803aa8
  80266f:	68 bd 00 00 00       	push   $0xbd
  802674:	68 37 3a 80 00       	push   $0x803a37
  802679:	e8 f3 db ff ff       	call   800271 <_panic>
  80267e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802681:	8b 00                	mov    (%eax),%eax
  802683:	85 c0                	test   %eax,%eax
  802685:	74 10                	je     802697 <alloc_block_BF+0x6c>
  802687:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80268a:	8b 00                	mov    (%eax),%eax
  80268c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80268f:	8b 52 04             	mov    0x4(%edx),%edx
  802692:	89 50 04             	mov    %edx,0x4(%eax)
  802695:	eb 0b                	jmp    8026a2 <alloc_block_BF+0x77>
  802697:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80269a:	8b 40 04             	mov    0x4(%eax),%eax
  80269d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026a5:	8b 40 04             	mov    0x4(%eax),%eax
  8026a8:	85 c0                	test   %eax,%eax
  8026aa:	74 0f                	je     8026bb <alloc_block_BF+0x90>
  8026ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026af:	8b 40 04             	mov    0x4(%eax),%eax
  8026b2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026b5:	8b 12                	mov    (%edx),%edx
  8026b7:	89 10                	mov    %edx,(%eax)
  8026b9:	eb 0a                	jmp    8026c5 <alloc_block_BF+0x9a>
  8026bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026be:	8b 00                	mov    (%eax),%eax
  8026c0:	a3 38 41 80 00       	mov    %eax,0x804138
  8026c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026d8:	a1 44 41 80 00       	mov    0x804144,%eax
  8026dd:	48                   	dec    %eax
  8026de:	a3 44 41 80 00       	mov    %eax,0x804144
	   return temp;
  8026e3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026e6:	e9 41 01 00 00       	jmp    80282c <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  8026eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026f4:	76 21                	jbe    802717 <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  8026f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8026fc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8026ff:	73 16                	jae    802717 <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  802701:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802704:	8b 40 0c             	mov    0xc(%eax),%eax
  802707:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  80270a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80270d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  802710:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802717:	a1 40 41 80 00       	mov    0x804140,%eax
  80271c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80271f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802723:	74 07                	je     80272c <alloc_block_BF+0x101>
  802725:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802728:	8b 00                	mov    (%eax),%eax
  80272a:	eb 05                	jmp    802731 <alloc_block_BF+0x106>
  80272c:	b8 00 00 00 00       	mov    $0x0,%eax
  802731:	a3 40 41 80 00       	mov    %eax,0x804140
  802736:	a1 40 41 80 00       	mov    0x804140,%eax
  80273b:	85 c0                	test   %eax,%eax
  80273d:	0f 85 09 ff ff ff    	jne    80264c <alloc_block_BF+0x21>
  802743:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802747:	0f 85 ff fe ff ff    	jne    80264c <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  80274d:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  802751:	0f 85 d0 00 00 00    	jne    802827 <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  802757:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80275a:	8b 40 0c             	mov    0xc(%eax),%eax
  80275d:	2b 45 08             	sub    0x8(%ebp),%eax
  802760:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  802763:	a1 48 41 80 00       	mov    0x804148,%eax
  802768:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  80276b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80276f:	75 17                	jne    802788 <alloc_block_BF+0x15d>
  802771:	83 ec 04             	sub    $0x4,%esp
  802774:	68 a8 3a 80 00       	push   $0x803aa8
  802779:	68 d1 00 00 00       	push   $0xd1
  80277e:	68 37 3a 80 00       	push   $0x803a37
  802783:	e8 e9 da ff ff       	call   800271 <_panic>
  802788:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80278b:	8b 00                	mov    (%eax),%eax
  80278d:	85 c0                	test   %eax,%eax
  80278f:	74 10                	je     8027a1 <alloc_block_BF+0x176>
  802791:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802794:	8b 00                	mov    (%eax),%eax
  802796:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802799:	8b 52 04             	mov    0x4(%edx),%edx
  80279c:	89 50 04             	mov    %edx,0x4(%eax)
  80279f:	eb 0b                	jmp    8027ac <alloc_block_BF+0x181>
  8027a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027a4:	8b 40 04             	mov    0x4(%eax),%eax
  8027a7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8027ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027af:	8b 40 04             	mov    0x4(%eax),%eax
  8027b2:	85 c0                	test   %eax,%eax
  8027b4:	74 0f                	je     8027c5 <alloc_block_BF+0x19a>
  8027b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027b9:	8b 40 04             	mov    0x4(%eax),%eax
  8027bc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027bf:	8b 12                	mov    (%edx),%edx
  8027c1:	89 10                	mov    %edx,(%eax)
  8027c3:	eb 0a                	jmp    8027cf <alloc_block_BF+0x1a4>
  8027c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027c8:	8b 00                	mov    (%eax),%eax
  8027ca:	a3 48 41 80 00       	mov    %eax,0x804148
  8027cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027e2:	a1 54 41 80 00       	mov    0x804154,%eax
  8027e7:	48                   	dec    %eax
  8027e8:	a3 54 41 80 00       	mov    %eax,0x804154
	  // setting the size & sva
	  new_block->size = size;
  8027ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8027f3:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  8027f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f9:	8b 50 08             	mov    0x8(%eax),%edx
  8027fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027ff:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  802802:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802805:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802808:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  80280b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80280e:	8b 50 08             	mov    0x8(%eax),%edx
  802811:	8b 45 08             	mov    0x8(%ebp),%eax
  802814:	01 c2                	add    %eax,%edx
  802816:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802819:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  80281c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80281f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  802822:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802825:	eb 05                	jmp    80282c <alloc_block_BF+0x201>
	 }
	 return NULL;
  802827:	b8 00 00 00 00       	mov    $0x0,%eax


}
  80282c:	c9                   	leave  
  80282d:	c3                   	ret    

0080282e <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80282e:	55                   	push   %ebp
  80282f:	89 e5                	mov    %esp,%ebp
  802831:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802834:	83 ec 04             	sub    $0x4,%esp
  802837:	68 c8 3a 80 00       	push   $0x803ac8
  80283c:	68 e8 00 00 00       	push   $0xe8
  802841:	68 37 3a 80 00       	push   $0x803a37
  802846:	e8 26 da ff ff       	call   800271 <_panic>

0080284b <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80284b:	55                   	push   %ebp
  80284c:	89 e5                	mov    %esp,%ebp
  80284e:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  802851:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802856:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  802859:	a1 38 41 80 00       	mov    0x804138,%eax
  80285e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  802861:	a1 44 41 80 00       	mov    0x804144,%eax
  802866:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  802869:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80286d:	75 68                	jne    8028d7 <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80286f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802873:	75 17                	jne    80288c <insert_sorted_with_merge_freeList+0x41>
  802875:	83 ec 04             	sub    $0x4,%esp
  802878:	68 14 3a 80 00       	push   $0x803a14
  80287d:	68 36 01 00 00       	push   $0x136
  802882:	68 37 3a 80 00       	push   $0x803a37
  802887:	e8 e5 d9 ff ff       	call   800271 <_panic>
  80288c:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802892:	8b 45 08             	mov    0x8(%ebp),%eax
  802895:	89 10                	mov    %edx,(%eax)
  802897:	8b 45 08             	mov    0x8(%ebp),%eax
  80289a:	8b 00                	mov    (%eax),%eax
  80289c:	85 c0                	test   %eax,%eax
  80289e:	74 0d                	je     8028ad <insert_sorted_with_merge_freeList+0x62>
  8028a0:	a1 38 41 80 00       	mov    0x804138,%eax
  8028a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8028a8:	89 50 04             	mov    %edx,0x4(%eax)
  8028ab:	eb 08                	jmp    8028b5 <insert_sorted_with_merge_freeList+0x6a>
  8028ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b8:	a3 38 41 80 00       	mov    %eax,0x804138
  8028bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028c7:	a1 44 41 80 00       	mov    0x804144,%eax
  8028cc:	40                   	inc    %eax
  8028cd:	a3 44 41 80 00       	mov    %eax,0x804144





}
  8028d2:	e9 ba 06 00 00       	jmp    802f91 <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  8028d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028da:	8b 50 08             	mov    0x8(%eax),%edx
  8028dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8028e3:	01 c2                	add    %eax,%edx
  8028e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e8:	8b 40 08             	mov    0x8(%eax),%eax
  8028eb:	39 c2                	cmp    %eax,%edx
  8028ed:	73 68                	jae    802957 <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8028ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028f3:	75 17                	jne    80290c <insert_sorted_with_merge_freeList+0xc1>
  8028f5:	83 ec 04             	sub    $0x4,%esp
  8028f8:	68 50 3a 80 00       	push   $0x803a50
  8028fd:	68 3a 01 00 00       	push   $0x13a
  802902:	68 37 3a 80 00       	push   $0x803a37
  802907:	e8 65 d9 ff ff       	call   800271 <_panic>
  80290c:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802912:	8b 45 08             	mov    0x8(%ebp),%eax
  802915:	89 50 04             	mov    %edx,0x4(%eax)
  802918:	8b 45 08             	mov    0x8(%ebp),%eax
  80291b:	8b 40 04             	mov    0x4(%eax),%eax
  80291e:	85 c0                	test   %eax,%eax
  802920:	74 0c                	je     80292e <insert_sorted_with_merge_freeList+0xe3>
  802922:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802927:	8b 55 08             	mov    0x8(%ebp),%edx
  80292a:	89 10                	mov    %edx,(%eax)
  80292c:	eb 08                	jmp    802936 <insert_sorted_with_merge_freeList+0xeb>
  80292e:	8b 45 08             	mov    0x8(%ebp),%eax
  802931:	a3 38 41 80 00       	mov    %eax,0x804138
  802936:	8b 45 08             	mov    0x8(%ebp),%eax
  802939:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80293e:	8b 45 08             	mov    0x8(%ebp),%eax
  802941:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802947:	a1 44 41 80 00       	mov    0x804144,%eax
  80294c:	40                   	inc    %eax
  80294d:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802952:	e9 3a 06 00 00       	jmp    802f91 <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  802957:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295a:	8b 50 08             	mov    0x8(%eax),%edx
  80295d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802960:	8b 40 0c             	mov    0xc(%eax),%eax
  802963:	01 c2                	add    %eax,%edx
  802965:	8b 45 08             	mov    0x8(%ebp),%eax
  802968:	8b 40 08             	mov    0x8(%eax),%eax
  80296b:	39 c2                	cmp    %eax,%edx
  80296d:	0f 85 90 00 00 00    	jne    802a03 <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  802973:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802976:	8b 50 0c             	mov    0xc(%eax),%edx
  802979:	8b 45 08             	mov    0x8(%ebp),%eax
  80297c:	8b 40 0c             	mov    0xc(%eax),%eax
  80297f:	01 c2                	add    %eax,%edx
  802981:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802984:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  802987:	8b 45 08             	mov    0x8(%ebp),%eax
  80298a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  802991:	8b 45 08             	mov    0x8(%ebp),%eax
  802994:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80299b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80299f:	75 17                	jne    8029b8 <insert_sorted_with_merge_freeList+0x16d>
  8029a1:	83 ec 04             	sub    $0x4,%esp
  8029a4:	68 14 3a 80 00       	push   $0x803a14
  8029a9:	68 41 01 00 00       	push   $0x141
  8029ae:	68 37 3a 80 00       	push   $0x803a37
  8029b3:	e8 b9 d8 ff ff       	call   800271 <_panic>
  8029b8:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8029be:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c1:	89 10                	mov    %edx,(%eax)
  8029c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c6:	8b 00                	mov    (%eax),%eax
  8029c8:	85 c0                	test   %eax,%eax
  8029ca:	74 0d                	je     8029d9 <insert_sorted_with_merge_freeList+0x18e>
  8029cc:	a1 48 41 80 00       	mov    0x804148,%eax
  8029d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8029d4:	89 50 04             	mov    %edx,0x4(%eax)
  8029d7:	eb 08                	jmp    8029e1 <insert_sorted_with_merge_freeList+0x196>
  8029d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029dc:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8029e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e4:	a3 48 41 80 00       	mov    %eax,0x804148
  8029e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029f3:	a1 54 41 80 00       	mov    0x804154,%eax
  8029f8:	40                   	inc    %eax
  8029f9:	a3 54 41 80 00       	mov    %eax,0x804154





}
  8029fe:	e9 8e 05 00 00       	jmp    802f91 <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  802a03:	8b 45 08             	mov    0x8(%ebp),%eax
  802a06:	8b 50 08             	mov    0x8(%eax),%edx
  802a09:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a0f:	01 c2                	add    %eax,%edx
  802a11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a14:	8b 40 08             	mov    0x8(%eax),%eax
  802a17:	39 c2                	cmp    %eax,%edx
  802a19:	73 68                	jae    802a83 <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802a1b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a1f:	75 17                	jne    802a38 <insert_sorted_with_merge_freeList+0x1ed>
  802a21:	83 ec 04             	sub    $0x4,%esp
  802a24:	68 14 3a 80 00       	push   $0x803a14
  802a29:	68 45 01 00 00       	push   $0x145
  802a2e:	68 37 3a 80 00       	push   $0x803a37
  802a33:	e8 39 d8 ff ff       	call   800271 <_panic>
  802a38:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a41:	89 10                	mov    %edx,(%eax)
  802a43:	8b 45 08             	mov    0x8(%ebp),%eax
  802a46:	8b 00                	mov    (%eax),%eax
  802a48:	85 c0                	test   %eax,%eax
  802a4a:	74 0d                	je     802a59 <insert_sorted_with_merge_freeList+0x20e>
  802a4c:	a1 38 41 80 00       	mov    0x804138,%eax
  802a51:	8b 55 08             	mov    0x8(%ebp),%edx
  802a54:	89 50 04             	mov    %edx,0x4(%eax)
  802a57:	eb 08                	jmp    802a61 <insert_sorted_with_merge_freeList+0x216>
  802a59:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a61:	8b 45 08             	mov    0x8(%ebp),%eax
  802a64:	a3 38 41 80 00       	mov    %eax,0x804138
  802a69:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a73:	a1 44 41 80 00       	mov    0x804144,%eax
  802a78:	40                   	inc    %eax
  802a79:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802a7e:	e9 0e 05 00 00       	jmp    802f91 <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  802a83:	8b 45 08             	mov    0x8(%ebp),%eax
  802a86:	8b 50 08             	mov    0x8(%eax),%edx
  802a89:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a8f:	01 c2                	add    %eax,%edx
  802a91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a94:	8b 40 08             	mov    0x8(%eax),%eax
  802a97:	39 c2                	cmp    %eax,%edx
  802a99:	0f 85 9c 00 00 00    	jne    802b3b <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  802a9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa2:	8b 50 0c             	mov    0xc(%eax),%edx
  802aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa8:	8b 40 0c             	mov    0xc(%eax),%eax
  802aab:	01 c2                	add    %eax,%edx
  802aad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ab0:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  802ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab6:	8b 50 08             	mov    0x8(%eax),%edx
  802ab9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802abc:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  802abf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  802ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  802acc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802ad3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ad7:	75 17                	jne    802af0 <insert_sorted_with_merge_freeList+0x2a5>
  802ad9:	83 ec 04             	sub    $0x4,%esp
  802adc:	68 14 3a 80 00       	push   $0x803a14
  802ae1:	68 4d 01 00 00       	push   $0x14d
  802ae6:	68 37 3a 80 00       	push   $0x803a37
  802aeb:	e8 81 d7 ff ff       	call   800271 <_panic>
  802af0:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802af6:	8b 45 08             	mov    0x8(%ebp),%eax
  802af9:	89 10                	mov    %edx,(%eax)
  802afb:	8b 45 08             	mov    0x8(%ebp),%eax
  802afe:	8b 00                	mov    (%eax),%eax
  802b00:	85 c0                	test   %eax,%eax
  802b02:	74 0d                	je     802b11 <insert_sorted_with_merge_freeList+0x2c6>
  802b04:	a1 48 41 80 00       	mov    0x804148,%eax
  802b09:	8b 55 08             	mov    0x8(%ebp),%edx
  802b0c:	89 50 04             	mov    %edx,0x4(%eax)
  802b0f:	eb 08                	jmp    802b19 <insert_sorted_with_merge_freeList+0x2ce>
  802b11:	8b 45 08             	mov    0x8(%ebp),%eax
  802b14:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b19:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1c:	a3 48 41 80 00       	mov    %eax,0x804148
  802b21:	8b 45 08             	mov    0x8(%ebp),%eax
  802b24:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b2b:	a1 54 41 80 00       	mov    0x804154,%eax
  802b30:	40                   	inc    %eax
  802b31:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802b36:	e9 56 04 00 00       	jmp    802f91 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802b3b:	a1 38 41 80 00       	mov    0x804138,%eax
  802b40:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b43:	e9 19 04 00 00       	jmp    802f61 <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  802b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4b:	8b 00                	mov    (%eax),%eax
  802b4d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b53:	8b 50 08             	mov    0x8(%eax),%edx
  802b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b59:	8b 40 0c             	mov    0xc(%eax),%eax
  802b5c:	01 c2                	add    %eax,%edx
  802b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b61:	8b 40 08             	mov    0x8(%eax),%eax
  802b64:	39 c2                	cmp    %eax,%edx
  802b66:	0f 85 ad 01 00 00    	jne    802d19 <insert_sorted_with_merge_freeList+0x4ce>
  802b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6f:	8b 50 08             	mov    0x8(%eax),%edx
  802b72:	8b 45 08             	mov    0x8(%ebp),%eax
  802b75:	8b 40 0c             	mov    0xc(%eax),%eax
  802b78:	01 c2                	add    %eax,%edx
  802b7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b7d:	8b 40 08             	mov    0x8(%eax),%eax
  802b80:	39 c2                	cmp    %eax,%edx
  802b82:	0f 85 91 01 00 00    	jne    802d19 <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  802b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8b:	8b 50 0c             	mov    0xc(%eax),%edx
  802b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b91:	8b 48 0c             	mov    0xc(%eax),%ecx
  802b94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b97:	8b 40 0c             	mov    0xc(%eax),%eax
  802b9a:	01 c8                	add    %ecx,%eax
  802b9c:	01 c2                	add    %eax,%edx
  802b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba1:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  802ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802bae:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  802bb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bbb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  802bc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bc5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  802bcc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802bd0:	75 17                	jne    802be9 <insert_sorted_with_merge_freeList+0x39e>
  802bd2:	83 ec 04             	sub    $0x4,%esp
  802bd5:	68 a8 3a 80 00       	push   $0x803aa8
  802bda:	68 5b 01 00 00       	push   $0x15b
  802bdf:	68 37 3a 80 00       	push   $0x803a37
  802be4:	e8 88 d6 ff ff       	call   800271 <_panic>
  802be9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bec:	8b 00                	mov    (%eax),%eax
  802bee:	85 c0                	test   %eax,%eax
  802bf0:	74 10                	je     802c02 <insert_sorted_with_merge_freeList+0x3b7>
  802bf2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bf5:	8b 00                	mov    (%eax),%eax
  802bf7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802bfa:	8b 52 04             	mov    0x4(%edx),%edx
  802bfd:	89 50 04             	mov    %edx,0x4(%eax)
  802c00:	eb 0b                	jmp    802c0d <insert_sorted_with_merge_freeList+0x3c2>
  802c02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c05:	8b 40 04             	mov    0x4(%eax),%eax
  802c08:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c10:	8b 40 04             	mov    0x4(%eax),%eax
  802c13:	85 c0                	test   %eax,%eax
  802c15:	74 0f                	je     802c26 <insert_sorted_with_merge_freeList+0x3db>
  802c17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c1a:	8b 40 04             	mov    0x4(%eax),%eax
  802c1d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c20:	8b 12                	mov    (%edx),%edx
  802c22:	89 10                	mov    %edx,(%eax)
  802c24:	eb 0a                	jmp    802c30 <insert_sorted_with_merge_freeList+0x3e5>
  802c26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c29:	8b 00                	mov    (%eax),%eax
  802c2b:	a3 38 41 80 00       	mov    %eax,0x804138
  802c30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c33:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c3c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c43:	a1 44 41 80 00       	mov    0x804144,%eax
  802c48:	48                   	dec    %eax
  802c49:	a3 44 41 80 00       	mov    %eax,0x804144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802c4e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c52:	75 17                	jne    802c6b <insert_sorted_with_merge_freeList+0x420>
  802c54:	83 ec 04             	sub    $0x4,%esp
  802c57:	68 14 3a 80 00       	push   $0x803a14
  802c5c:	68 5c 01 00 00       	push   $0x15c
  802c61:	68 37 3a 80 00       	push   $0x803a37
  802c66:	e8 06 d6 ff ff       	call   800271 <_panic>
  802c6b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c71:	8b 45 08             	mov    0x8(%ebp),%eax
  802c74:	89 10                	mov    %edx,(%eax)
  802c76:	8b 45 08             	mov    0x8(%ebp),%eax
  802c79:	8b 00                	mov    (%eax),%eax
  802c7b:	85 c0                	test   %eax,%eax
  802c7d:	74 0d                	je     802c8c <insert_sorted_with_merge_freeList+0x441>
  802c7f:	a1 48 41 80 00       	mov    0x804148,%eax
  802c84:	8b 55 08             	mov    0x8(%ebp),%edx
  802c87:	89 50 04             	mov    %edx,0x4(%eax)
  802c8a:	eb 08                	jmp    802c94 <insert_sorted_with_merge_freeList+0x449>
  802c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c94:	8b 45 08             	mov    0x8(%ebp),%eax
  802c97:	a3 48 41 80 00       	mov    %eax,0x804148
  802c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ca6:	a1 54 41 80 00       	mov    0x804154,%eax
  802cab:	40                   	inc    %eax
  802cac:	a3 54 41 80 00       	mov    %eax,0x804154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  802cb1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802cb5:	75 17                	jne    802cce <insert_sorted_with_merge_freeList+0x483>
  802cb7:	83 ec 04             	sub    $0x4,%esp
  802cba:	68 14 3a 80 00       	push   $0x803a14
  802cbf:	68 5d 01 00 00       	push   $0x15d
  802cc4:	68 37 3a 80 00       	push   $0x803a37
  802cc9:	e8 a3 d5 ff ff       	call   800271 <_panic>
  802cce:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802cd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cd7:	89 10                	mov    %edx,(%eax)
  802cd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cdc:	8b 00                	mov    (%eax),%eax
  802cde:	85 c0                	test   %eax,%eax
  802ce0:	74 0d                	je     802cef <insert_sorted_with_merge_freeList+0x4a4>
  802ce2:	a1 48 41 80 00       	mov    0x804148,%eax
  802ce7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802cea:	89 50 04             	mov    %edx,0x4(%eax)
  802ced:	eb 08                	jmp    802cf7 <insert_sorted_with_merge_freeList+0x4ac>
  802cef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cf2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802cf7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cfa:	a3 48 41 80 00       	mov    %eax,0x804148
  802cff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d02:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d09:	a1 54 41 80 00       	mov    0x804154,%eax
  802d0e:	40                   	inc    %eax
  802d0f:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802d14:	e9 78 02 00 00       	jmp    802f91 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1c:	8b 50 08             	mov    0x8(%eax),%edx
  802d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d22:	8b 40 0c             	mov    0xc(%eax),%eax
  802d25:	01 c2                	add    %eax,%edx
  802d27:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2a:	8b 40 08             	mov    0x8(%eax),%eax
  802d2d:	39 c2                	cmp    %eax,%edx
  802d2f:	0f 83 b8 00 00 00    	jae    802ded <insert_sorted_with_merge_freeList+0x5a2>
  802d35:	8b 45 08             	mov    0x8(%ebp),%eax
  802d38:	8b 50 08             	mov    0x8(%eax),%edx
  802d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d41:	01 c2                	add    %eax,%edx
  802d43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d46:	8b 40 08             	mov    0x8(%eax),%eax
  802d49:	39 c2                	cmp    %eax,%edx
  802d4b:	0f 85 9c 00 00 00    	jne    802ded <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  802d51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d54:	8b 50 0c             	mov    0xc(%eax),%edx
  802d57:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d5d:	01 c2                	add    %eax,%edx
  802d5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d62:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  802d65:	8b 45 08             	mov    0x8(%ebp),%eax
  802d68:	8b 50 08             	mov    0x8(%eax),%edx
  802d6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d6e:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  802d71:	8b 45 08             	mov    0x8(%ebp),%eax
  802d74:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802d85:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d89:	75 17                	jne    802da2 <insert_sorted_with_merge_freeList+0x557>
  802d8b:	83 ec 04             	sub    $0x4,%esp
  802d8e:	68 14 3a 80 00       	push   $0x803a14
  802d93:	68 67 01 00 00       	push   $0x167
  802d98:	68 37 3a 80 00       	push   $0x803a37
  802d9d:	e8 cf d4 ff ff       	call   800271 <_panic>
  802da2:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802da8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dab:	89 10                	mov    %edx,(%eax)
  802dad:	8b 45 08             	mov    0x8(%ebp),%eax
  802db0:	8b 00                	mov    (%eax),%eax
  802db2:	85 c0                	test   %eax,%eax
  802db4:	74 0d                	je     802dc3 <insert_sorted_with_merge_freeList+0x578>
  802db6:	a1 48 41 80 00       	mov    0x804148,%eax
  802dbb:	8b 55 08             	mov    0x8(%ebp),%edx
  802dbe:	89 50 04             	mov    %edx,0x4(%eax)
  802dc1:	eb 08                	jmp    802dcb <insert_sorted_with_merge_freeList+0x580>
  802dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dce:	a3 48 41 80 00       	mov    %eax,0x804148
  802dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ddd:	a1 54 41 80 00       	mov    0x804154,%eax
  802de2:	40                   	inc    %eax
  802de3:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802de8:	e9 a4 01 00 00       	jmp    802f91 <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df0:	8b 50 08             	mov    0x8(%eax),%edx
  802df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df6:	8b 40 0c             	mov    0xc(%eax),%eax
  802df9:	01 c2                	add    %eax,%edx
  802dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfe:	8b 40 08             	mov    0x8(%eax),%eax
  802e01:	39 c2                	cmp    %eax,%edx
  802e03:	0f 85 ac 00 00 00    	jne    802eb5 <insert_sorted_with_merge_freeList+0x66a>
  802e09:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0c:	8b 50 08             	mov    0x8(%eax),%edx
  802e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e12:	8b 40 0c             	mov    0xc(%eax),%eax
  802e15:	01 c2                	add    %eax,%edx
  802e17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e1a:	8b 40 08             	mov    0x8(%eax),%eax
  802e1d:	39 c2                	cmp    %eax,%edx
  802e1f:	0f 83 90 00 00 00    	jae    802eb5 <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  802e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e28:	8b 50 0c             	mov    0xc(%eax),%edx
  802e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2e:	8b 40 0c             	mov    0xc(%eax),%eax
  802e31:	01 c2                	add    %eax,%edx
  802e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e36:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  802e39:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  802e43:	8b 45 08             	mov    0x8(%ebp),%eax
  802e46:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e4d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e51:	75 17                	jne    802e6a <insert_sorted_with_merge_freeList+0x61f>
  802e53:	83 ec 04             	sub    $0x4,%esp
  802e56:	68 14 3a 80 00       	push   $0x803a14
  802e5b:	68 70 01 00 00       	push   $0x170
  802e60:	68 37 3a 80 00       	push   $0x803a37
  802e65:	e8 07 d4 ff ff       	call   800271 <_panic>
  802e6a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e70:	8b 45 08             	mov    0x8(%ebp),%eax
  802e73:	89 10                	mov    %edx,(%eax)
  802e75:	8b 45 08             	mov    0x8(%ebp),%eax
  802e78:	8b 00                	mov    (%eax),%eax
  802e7a:	85 c0                	test   %eax,%eax
  802e7c:	74 0d                	je     802e8b <insert_sorted_with_merge_freeList+0x640>
  802e7e:	a1 48 41 80 00       	mov    0x804148,%eax
  802e83:	8b 55 08             	mov    0x8(%ebp),%edx
  802e86:	89 50 04             	mov    %edx,0x4(%eax)
  802e89:	eb 08                	jmp    802e93 <insert_sorted_with_merge_freeList+0x648>
  802e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e93:	8b 45 08             	mov    0x8(%ebp),%eax
  802e96:	a3 48 41 80 00       	mov    %eax,0x804148
  802e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ea5:	a1 54 41 80 00       	mov    0x804154,%eax
  802eaa:	40                   	inc    %eax
  802eab:	a3 54 41 80 00       	mov    %eax,0x804154
	      break;
  802eb0:	e9 dc 00 00 00       	jmp    802f91 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb8:	8b 50 08             	mov    0x8(%eax),%edx
  802ebb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebe:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec1:	01 c2                	add    %eax,%edx
  802ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec6:	8b 40 08             	mov    0x8(%eax),%eax
  802ec9:	39 c2                	cmp    %eax,%edx
  802ecb:	0f 83 88 00 00 00    	jae    802f59 <insert_sorted_with_merge_freeList+0x70e>
  802ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed4:	8b 50 08             	mov    0x8(%eax),%edx
  802ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eda:	8b 40 0c             	mov    0xc(%eax),%eax
  802edd:	01 c2                	add    %eax,%edx
  802edf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ee2:	8b 40 08             	mov    0x8(%eax),%eax
  802ee5:	39 c2                	cmp    %eax,%edx
  802ee7:	73 70                	jae    802f59 <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  802ee9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eed:	74 06                	je     802ef5 <insert_sorted_with_merge_freeList+0x6aa>
  802eef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ef3:	75 17                	jne    802f0c <insert_sorted_with_merge_freeList+0x6c1>
  802ef5:	83 ec 04             	sub    $0x4,%esp
  802ef8:	68 74 3a 80 00       	push   $0x803a74
  802efd:	68 75 01 00 00       	push   $0x175
  802f02:	68 37 3a 80 00       	push   $0x803a37
  802f07:	e8 65 d3 ff ff       	call   800271 <_panic>
  802f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0f:	8b 10                	mov    (%eax),%edx
  802f11:	8b 45 08             	mov    0x8(%ebp),%eax
  802f14:	89 10                	mov    %edx,(%eax)
  802f16:	8b 45 08             	mov    0x8(%ebp),%eax
  802f19:	8b 00                	mov    (%eax),%eax
  802f1b:	85 c0                	test   %eax,%eax
  802f1d:	74 0b                	je     802f2a <insert_sorted_with_merge_freeList+0x6df>
  802f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f22:	8b 00                	mov    (%eax),%eax
  802f24:	8b 55 08             	mov    0x8(%ebp),%edx
  802f27:	89 50 04             	mov    %edx,0x4(%eax)
  802f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2d:	8b 55 08             	mov    0x8(%ebp),%edx
  802f30:	89 10                	mov    %edx,(%eax)
  802f32:	8b 45 08             	mov    0x8(%ebp),%eax
  802f35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f38:	89 50 04             	mov    %edx,0x4(%eax)
  802f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3e:	8b 00                	mov    (%eax),%eax
  802f40:	85 c0                	test   %eax,%eax
  802f42:	75 08                	jne    802f4c <insert_sorted_with_merge_freeList+0x701>
  802f44:	8b 45 08             	mov    0x8(%ebp),%eax
  802f47:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f4c:	a1 44 41 80 00       	mov    0x804144,%eax
  802f51:	40                   	inc    %eax
  802f52:	a3 44 41 80 00       	mov    %eax,0x804144
	      break;
  802f57:	eb 38                	jmp    802f91 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802f59:	a1 40 41 80 00       	mov    0x804140,%eax
  802f5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f61:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f65:	74 07                	je     802f6e <insert_sorted_with_merge_freeList+0x723>
  802f67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6a:	8b 00                	mov    (%eax),%eax
  802f6c:	eb 05                	jmp    802f73 <insert_sorted_with_merge_freeList+0x728>
  802f6e:	b8 00 00 00 00       	mov    $0x0,%eax
  802f73:	a3 40 41 80 00       	mov    %eax,0x804140
  802f78:	a1 40 41 80 00       	mov    0x804140,%eax
  802f7d:	85 c0                	test   %eax,%eax
  802f7f:	0f 85 c3 fb ff ff    	jne    802b48 <insert_sorted_with_merge_freeList+0x2fd>
  802f85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f89:	0f 85 b9 fb ff ff    	jne    802b48 <insert_sorted_with_merge_freeList+0x2fd>





}
  802f8f:	eb 00                	jmp    802f91 <insert_sorted_with_merge_freeList+0x746>
  802f91:	90                   	nop
  802f92:	c9                   	leave  
  802f93:	c3                   	ret    

00802f94 <__udivdi3>:
  802f94:	55                   	push   %ebp
  802f95:	57                   	push   %edi
  802f96:	56                   	push   %esi
  802f97:	53                   	push   %ebx
  802f98:	83 ec 1c             	sub    $0x1c,%esp
  802f9b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802f9f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802fa3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802fa7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802fab:	89 ca                	mov    %ecx,%edx
  802fad:	89 f8                	mov    %edi,%eax
  802faf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802fb3:	85 f6                	test   %esi,%esi
  802fb5:	75 2d                	jne    802fe4 <__udivdi3+0x50>
  802fb7:	39 cf                	cmp    %ecx,%edi
  802fb9:	77 65                	ja     803020 <__udivdi3+0x8c>
  802fbb:	89 fd                	mov    %edi,%ebp
  802fbd:	85 ff                	test   %edi,%edi
  802fbf:	75 0b                	jne    802fcc <__udivdi3+0x38>
  802fc1:	b8 01 00 00 00       	mov    $0x1,%eax
  802fc6:	31 d2                	xor    %edx,%edx
  802fc8:	f7 f7                	div    %edi
  802fca:	89 c5                	mov    %eax,%ebp
  802fcc:	31 d2                	xor    %edx,%edx
  802fce:	89 c8                	mov    %ecx,%eax
  802fd0:	f7 f5                	div    %ebp
  802fd2:	89 c1                	mov    %eax,%ecx
  802fd4:	89 d8                	mov    %ebx,%eax
  802fd6:	f7 f5                	div    %ebp
  802fd8:	89 cf                	mov    %ecx,%edi
  802fda:	89 fa                	mov    %edi,%edx
  802fdc:	83 c4 1c             	add    $0x1c,%esp
  802fdf:	5b                   	pop    %ebx
  802fe0:	5e                   	pop    %esi
  802fe1:	5f                   	pop    %edi
  802fe2:	5d                   	pop    %ebp
  802fe3:	c3                   	ret    
  802fe4:	39 ce                	cmp    %ecx,%esi
  802fe6:	77 28                	ja     803010 <__udivdi3+0x7c>
  802fe8:	0f bd fe             	bsr    %esi,%edi
  802feb:	83 f7 1f             	xor    $0x1f,%edi
  802fee:	75 40                	jne    803030 <__udivdi3+0x9c>
  802ff0:	39 ce                	cmp    %ecx,%esi
  802ff2:	72 0a                	jb     802ffe <__udivdi3+0x6a>
  802ff4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802ff8:	0f 87 9e 00 00 00    	ja     80309c <__udivdi3+0x108>
  802ffe:	b8 01 00 00 00       	mov    $0x1,%eax
  803003:	89 fa                	mov    %edi,%edx
  803005:	83 c4 1c             	add    $0x1c,%esp
  803008:	5b                   	pop    %ebx
  803009:	5e                   	pop    %esi
  80300a:	5f                   	pop    %edi
  80300b:	5d                   	pop    %ebp
  80300c:	c3                   	ret    
  80300d:	8d 76 00             	lea    0x0(%esi),%esi
  803010:	31 ff                	xor    %edi,%edi
  803012:	31 c0                	xor    %eax,%eax
  803014:	89 fa                	mov    %edi,%edx
  803016:	83 c4 1c             	add    $0x1c,%esp
  803019:	5b                   	pop    %ebx
  80301a:	5e                   	pop    %esi
  80301b:	5f                   	pop    %edi
  80301c:	5d                   	pop    %ebp
  80301d:	c3                   	ret    
  80301e:	66 90                	xchg   %ax,%ax
  803020:	89 d8                	mov    %ebx,%eax
  803022:	f7 f7                	div    %edi
  803024:	31 ff                	xor    %edi,%edi
  803026:	89 fa                	mov    %edi,%edx
  803028:	83 c4 1c             	add    $0x1c,%esp
  80302b:	5b                   	pop    %ebx
  80302c:	5e                   	pop    %esi
  80302d:	5f                   	pop    %edi
  80302e:	5d                   	pop    %ebp
  80302f:	c3                   	ret    
  803030:	bd 20 00 00 00       	mov    $0x20,%ebp
  803035:	89 eb                	mov    %ebp,%ebx
  803037:	29 fb                	sub    %edi,%ebx
  803039:	89 f9                	mov    %edi,%ecx
  80303b:	d3 e6                	shl    %cl,%esi
  80303d:	89 c5                	mov    %eax,%ebp
  80303f:	88 d9                	mov    %bl,%cl
  803041:	d3 ed                	shr    %cl,%ebp
  803043:	89 e9                	mov    %ebp,%ecx
  803045:	09 f1                	or     %esi,%ecx
  803047:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80304b:	89 f9                	mov    %edi,%ecx
  80304d:	d3 e0                	shl    %cl,%eax
  80304f:	89 c5                	mov    %eax,%ebp
  803051:	89 d6                	mov    %edx,%esi
  803053:	88 d9                	mov    %bl,%cl
  803055:	d3 ee                	shr    %cl,%esi
  803057:	89 f9                	mov    %edi,%ecx
  803059:	d3 e2                	shl    %cl,%edx
  80305b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80305f:	88 d9                	mov    %bl,%cl
  803061:	d3 e8                	shr    %cl,%eax
  803063:	09 c2                	or     %eax,%edx
  803065:	89 d0                	mov    %edx,%eax
  803067:	89 f2                	mov    %esi,%edx
  803069:	f7 74 24 0c          	divl   0xc(%esp)
  80306d:	89 d6                	mov    %edx,%esi
  80306f:	89 c3                	mov    %eax,%ebx
  803071:	f7 e5                	mul    %ebp
  803073:	39 d6                	cmp    %edx,%esi
  803075:	72 19                	jb     803090 <__udivdi3+0xfc>
  803077:	74 0b                	je     803084 <__udivdi3+0xf0>
  803079:	89 d8                	mov    %ebx,%eax
  80307b:	31 ff                	xor    %edi,%edi
  80307d:	e9 58 ff ff ff       	jmp    802fda <__udivdi3+0x46>
  803082:	66 90                	xchg   %ax,%ax
  803084:	8b 54 24 08          	mov    0x8(%esp),%edx
  803088:	89 f9                	mov    %edi,%ecx
  80308a:	d3 e2                	shl    %cl,%edx
  80308c:	39 c2                	cmp    %eax,%edx
  80308e:	73 e9                	jae    803079 <__udivdi3+0xe5>
  803090:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803093:	31 ff                	xor    %edi,%edi
  803095:	e9 40 ff ff ff       	jmp    802fda <__udivdi3+0x46>
  80309a:	66 90                	xchg   %ax,%ax
  80309c:	31 c0                	xor    %eax,%eax
  80309e:	e9 37 ff ff ff       	jmp    802fda <__udivdi3+0x46>
  8030a3:	90                   	nop

008030a4 <__umoddi3>:
  8030a4:	55                   	push   %ebp
  8030a5:	57                   	push   %edi
  8030a6:	56                   	push   %esi
  8030a7:	53                   	push   %ebx
  8030a8:	83 ec 1c             	sub    $0x1c,%esp
  8030ab:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8030af:	8b 74 24 34          	mov    0x34(%esp),%esi
  8030b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8030b7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8030bb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8030bf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8030c3:	89 f3                	mov    %esi,%ebx
  8030c5:	89 fa                	mov    %edi,%edx
  8030c7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8030cb:	89 34 24             	mov    %esi,(%esp)
  8030ce:	85 c0                	test   %eax,%eax
  8030d0:	75 1a                	jne    8030ec <__umoddi3+0x48>
  8030d2:	39 f7                	cmp    %esi,%edi
  8030d4:	0f 86 a2 00 00 00    	jbe    80317c <__umoddi3+0xd8>
  8030da:	89 c8                	mov    %ecx,%eax
  8030dc:	89 f2                	mov    %esi,%edx
  8030de:	f7 f7                	div    %edi
  8030e0:	89 d0                	mov    %edx,%eax
  8030e2:	31 d2                	xor    %edx,%edx
  8030e4:	83 c4 1c             	add    $0x1c,%esp
  8030e7:	5b                   	pop    %ebx
  8030e8:	5e                   	pop    %esi
  8030e9:	5f                   	pop    %edi
  8030ea:	5d                   	pop    %ebp
  8030eb:	c3                   	ret    
  8030ec:	39 f0                	cmp    %esi,%eax
  8030ee:	0f 87 ac 00 00 00    	ja     8031a0 <__umoddi3+0xfc>
  8030f4:	0f bd e8             	bsr    %eax,%ebp
  8030f7:	83 f5 1f             	xor    $0x1f,%ebp
  8030fa:	0f 84 ac 00 00 00    	je     8031ac <__umoddi3+0x108>
  803100:	bf 20 00 00 00       	mov    $0x20,%edi
  803105:	29 ef                	sub    %ebp,%edi
  803107:	89 fe                	mov    %edi,%esi
  803109:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80310d:	89 e9                	mov    %ebp,%ecx
  80310f:	d3 e0                	shl    %cl,%eax
  803111:	89 d7                	mov    %edx,%edi
  803113:	89 f1                	mov    %esi,%ecx
  803115:	d3 ef                	shr    %cl,%edi
  803117:	09 c7                	or     %eax,%edi
  803119:	89 e9                	mov    %ebp,%ecx
  80311b:	d3 e2                	shl    %cl,%edx
  80311d:	89 14 24             	mov    %edx,(%esp)
  803120:	89 d8                	mov    %ebx,%eax
  803122:	d3 e0                	shl    %cl,%eax
  803124:	89 c2                	mov    %eax,%edx
  803126:	8b 44 24 08          	mov    0x8(%esp),%eax
  80312a:	d3 e0                	shl    %cl,%eax
  80312c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803130:	8b 44 24 08          	mov    0x8(%esp),%eax
  803134:	89 f1                	mov    %esi,%ecx
  803136:	d3 e8                	shr    %cl,%eax
  803138:	09 d0                	or     %edx,%eax
  80313a:	d3 eb                	shr    %cl,%ebx
  80313c:	89 da                	mov    %ebx,%edx
  80313e:	f7 f7                	div    %edi
  803140:	89 d3                	mov    %edx,%ebx
  803142:	f7 24 24             	mull   (%esp)
  803145:	89 c6                	mov    %eax,%esi
  803147:	89 d1                	mov    %edx,%ecx
  803149:	39 d3                	cmp    %edx,%ebx
  80314b:	0f 82 87 00 00 00    	jb     8031d8 <__umoddi3+0x134>
  803151:	0f 84 91 00 00 00    	je     8031e8 <__umoddi3+0x144>
  803157:	8b 54 24 04          	mov    0x4(%esp),%edx
  80315b:	29 f2                	sub    %esi,%edx
  80315d:	19 cb                	sbb    %ecx,%ebx
  80315f:	89 d8                	mov    %ebx,%eax
  803161:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803165:	d3 e0                	shl    %cl,%eax
  803167:	89 e9                	mov    %ebp,%ecx
  803169:	d3 ea                	shr    %cl,%edx
  80316b:	09 d0                	or     %edx,%eax
  80316d:	89 e9                	mov    %ebp,%ecx
  80316f:	d3 eb                	shr    %cl,%ebx
  803171:	89 da                	mov    %ebx,%edx
  803173:	83 c4 1c             	add    $0x1c,%esp
  803176:	5b                   	pop    %ebx
  803177:	5e                   	pop    %esi
  803178:	5f                   	pop    %edi
  803179:	5d                   	pop    %ebp
  80317a:	c3                   	ret    
  80317b:	90                   	nop
  80317c:	89 fd                	mov    %edi,%ebp
  80317e:	85 ff                	test   %edi,%edi
  803180:	75 0b                	jne    80318d <__umoddi3+0xe9>
  803182:	b8 01 00 00 00       	mov    $0x1,%eax
  803187:	31 d2                	xor    %edx,%edx
  803189:	f7 f7                	div    %edi
  80318b:	89 c5                	mov    %eax,%ebp
  80318d:	89 f0                	mov    %esi,%eax
  80318f:	31 d2                	xor    %edx,%edx
  803191:	f7 f5                	div    %ebp
  803193:	89 c8                	mov    %ecx,%eax
  803195:	f7 f5                	div    %ebp
  803197:	89 d0                	mov    %edx,%eax
  803199:	e9 44 ff ff ff       	jmp    8030e2 <__umoddi3+0x3e>
  80319e:	66 90                	xchg   %ax,%ax
  8031a0:	89 c8                	mov    %ecx,%eax
  8031a2:	89 f2                	mov    %esi,%edx
  8031a4:	83 c4 1c             	add    $0x1c,%esp
  8031a7:	5b                   	pop    %ebx
  8031a8:	5e                   	pop    %esi
  8031a9:	5f                   	pop    %edi
  8031aa:	5d                   	pop    %ebp
  8031ab:	c3                   	ret    
  8031ac:	3b 04 24             	cmp    (%esp),%eax
  8031af:	72 06                	jb     8031b7 <__umoddi3+0x113>
  8031b1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8031b5:	77 0f                	ja     8031c6 <__umoddi3+0x122>
  8031b7:	89 f2                	mov    %esi,%edx
  8031b9:	29 f9                	sub    %edi,%ecx
  8031bb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8031bf:	89 14 24             	mov    %edx,(%esp)
  8031c2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8031c6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8031ca:	8b 14 24             	mov    (%esp),%edx
  8031cd:	83 c4 1c             	add    $0x1c,%esp
  8031d0:	5b                   	pop    %ebx
  8031d1:	5e                   	pop    %esi
  8031d2:	5f                   	pop    %edi
  8031d3:	5d                   	pop    %ebp
  8031d4:	c3                   	ret    
  8031d5:	8d 76 00             	lea    0x0(%esi),%esi
  8031d8:	2b 04 24             	sub    (%esp),%eax
  8031db:	19 fa                	sbb    %edi,%edx
  8031dd:	89 d1                	mov    %edx,%ecx
  8031df:	89 c6                	mov    %eax,%esi
  8031e1:	e9 71 ff ff ff       	jmp    803157 <__umoddi3+0xb3>
  8031e6:	66 90                	xchg   %ax,%ax
  8031e8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8031ec:	72 ea                	jb     8031d8 <__umoddi3+0x134>
  8031ee:	89 d9                	mov    %ebx,%ecx
  8031f0:	e9 62 ff ff ff       	jmp    803157 <__umoddi3+0xb3>
