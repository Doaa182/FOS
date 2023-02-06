
obj/user/tst_envfree5_1:     file format elf32-i386


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
  800031:	e8 10 01 00 00       	call   800146 <libmain>
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
	// Testing scenario 5_1: Kill ONE program has shared variables and it free it
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 20 32 80 00       	push   $0x803220
  80004a:	e8 dc 15 00 00       	call   80162b <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 8b 18 00 00       	call   8018ee <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 23 19 00 00       	call   80198e <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 30 32 80 00       	push   $0x803230
  800079:	e8 b8 04 00 00       	call   800536 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr4", 2000,(myEnv->SecondListSize), 50);
  800081:	a1 20 40 80 00       	mov    0x804020,%eax
  800086:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	68 d0 07 00 00       	push   $0x7d0
  800094:	68 63 32 80 00       	push   $0x803263
  800099:	e8 c2 1a 00 00       	call   801b60 <sys_create_env>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sys_run_env(envIdProcessA);
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8000aa:	e8 cf 1a 00 00       	call   801b7e <sys_run_env>
  8000af:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 1) ;
  8000b2:	90                   	nop
  8000b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000b6:	8b 00                	mov    (%eax),%eax
  8000b8:	83 f8 01             	cmp    $0x1,%eax
  8000bb:	75 f6                	jne    8000b3 <_main+0x7b>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000bd:	e8 2c 18 00 00       	call   8018ee <sys_calculate_free_frames>
  8000c2:	83 ec 08             	sub    $0x8,%esp
  8000c5:	50                   	push   %eax
  8000c6:	68 6c 32 80 00       	push   $0x80326c
  8000cb:	e8 66 04 00 00       	call   800536 <cprintf>
  8000d0:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  8000d3:	83 ec 0c             	sub    $0xc,%esp
  8000d6:	ff 75 e8             	pushl  -0x18(%ebp)
  8000d9:	e8 bc 1a 00 00       	call   801b9a <sys_destroy_env>
  8000de:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8000e1:	e8 08 18 00 00       	call   8018ee <sys_calculate_free_frames>
  8000e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8000e9:	e8 a0 18 00 00       	call   80198e <sys_pf_calculate_allocated_pages>
  8000ee:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  8000f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000f7:	74 27                	je     800120 <_main+0xe8>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n", freeFrames_after);
  8000f9:	83 ec 08             	sub    $0x8,%esp
  8000fc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000ff:	68 a0 32 80 00       	push   $0x8032a0
  800104:	e8 2d 04 00 00       	call   800536 <cprintf>
  800109:	83 c4 10             	add    $0x10,%esp
		panic("env_free() does not work correctly... check it again.");
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	68 f0 32 80 00       	push   $0x8032f0
  800114:	6a 1e                	push   $0x1e
  800116:	68 26 33 80 00       	push   $0x803326
  80011b:	e8 62 01 00 00       	call   800282 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  800120:	83 ec 08             	sub    $0x8,%esp
  800123:	ff 75 e4             	pushl  -0x1c(%ebp)
  800126:	68 3c 33 80 00       	push   $0x80333c
  80012b:	e8 06 04 00 00       	call   800536 <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 5_1 for envfree completed successfully.\n");
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	68 9c 33 80 00       	push   $0x80339c
  80013b:	e8 f6 03 00 00       	call   800536 <cprintf>
  800140:	83 c4 10             	add    $0x10,%esp
	return;
  800143:	90                   	nop
}
  800144:	c9                   	leave  
  800145:	c3                   	ret    

00800146 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800146:	55                   	push   %ebp
  800147:	89 e5                	mov    %esp,%ebp
  800149:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80014c:	e8 7d 1a 00 00       	call   801bce <sys_getenvindex>
  800151:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800154:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800157:	89 d0                	mov    %edx,%eax
  800159:	c1 e0 03             	shl    $0x3,%eax
  80015c:	01 d0                	add    %edx,%eax
  80015e:	01 c0                	add    %eax,%eax
  800160:	01 d0                	add    %edx,%eax
  800162:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800169:	01 d0                	add    %edx,%eax
  80016b:	c1 e0 04             	shl    $0x4,%eax
  80016e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800173:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800178:	a1 20 40 80 00       	mov    0x804020,%eax
  80017d:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800183:	84 c0                	test   %al,%al
  800185:	74 0f                	je     800196 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800187:	a1 20 40 80 00       	mov    0x804020,%eax
  80018c:	05 5c 05 00 00       	add    $0x55c,%eax
  800191:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800196:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80019a:	7e 0a                	jle    8001a6 <libmain+0x60>
		binaryname = argv[0];
  80019c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80019f:	8b 00                	mov    (%eax),%eax
  8001a1:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001a6:	83 ec 08             	sub    $0x8,%esp
  8001a9:	ff 75 0c             	pushl  0xc(%ebp)
  8001ac:	ff 75 08             	pushl  0x8(%ebp)
  8001af:	e8 84 fe ff ff       	call   800038 <_main>
  8001b4:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001b7:	e8 1f 18 00 00       	call   8019db <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001bc:	83 ec 0c             	sub    $0xc,%esp
  8001bf:	68 00 34 80 00       	push   $0x803400
  8001c4:	e8 6d 03 00 00       	call   800536 <cprintf>
  8001c9:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001cc:	a1 20 40 80 00       	mov    0x804020,%eax
  8001d1:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001d7:	a1 20 40 80 00       	mov    0x804020,%eax
  8001dc:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001e2:	83 ec 04             	sub    $0x4,%esp
  8001e5:	52                   	push   %edx
  8001e6:	50                   	push   %eax
  8001e7:	68 28 34 80 00       	push   $0x803428
  8001ec:	e8 45 03 00 00       	call   800536 <cprintf>
  8001f1:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001f4:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f9:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8001ff:	a1 20 40 80 00       	mov    0x804020,%eax
  800204:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80020a:	a1 20 40 80 00       	mov    0x804020,%eax
  80020f:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800215:	51                   	push   %ecx
  800216:	52                   	push   %edx
  800217:	50                   	push   %eax
  800218:	68 50 34 80 00       	push   $0x803450
  80021d:	e8 14 03 00 00       	call   800536 <cprintf>
  800222:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800225:	a1 20 40 80 00       	mov    0x804020,%eax
  80022a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800230:	83 ec 08             	sub    $0x8,%esp
  800233:	50                   	push   %eax
  800234:	68 a8 34 80 00       	push   $0x8034a8
  800239:	e8 f8 02 00 00       	call   800536 <cprintf>
  80023e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800241:	83 ec 0c             	sub    $0xc,%esp
  800244:	68 00 34 80 00       	push   $0x803400
  800249:	e8 e8 02 00 00       	call   800536 <cprintf>
  80024e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800251:	e8 9f 17 00 00       	call   8019f5 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800256:	e8 19 00 00 00       	call   800274 <exit>
}
  80025b:	90                   	nop
  80025c:	c9                   	leave  
  80025d:	c3                   	ret    

0080025e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80025e:	55                   	push   %ebp
  80025f:	89 e5                	mov    %esp,%ebp
  800261:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	6a 00                	push   $0x0
  800269:	e8 2c 19 00 00       	call   801b9a <sys_destroy_env>
  80026e:	83 c4 10             	add    $0x10,%esp
}
  800271:	90                   	nop
  800272:	c9                   	leave  
  800273:	c3                   	ret    

00800274 <exit>:

void
exit(void)
{
  800274:	55                   	push   %ebp
  800275:	89 e5                	mov    %esp,%ebp
  800277:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80027a:	e8 81 19 00 00       	call   801c00 <sys_exit_env>
}
  80027f:	90                   	nop
  800280:	c9                   	leave  
  800281:	c3                   	ret    

00800282 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800282:	55                   	push   %ebp
  800283:	89 e5                	mov    %esp,%ebp
  800285:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800288:	8d 45 10             	lea    0x10(%ebp),%eax
  80028b:	83 c0 04             	add    $0x4,%eax
  80028e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800291:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800296:	85 c0                	test   %eax,%eax
  800298:	74 16                	je     8002b0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80029a:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80029f:	83 ec 08             	sub    $0x8,%esp
  8002a2:	50                   	push   %eax
  8002a3:	68 bc 34 80 00       	push   $0x8034bc
  8002a8:	e8 89 02 00 00       	call   800536 <cprintf>
  8002ad:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002b0:	a1 00 40 80 00       	mov    0x804000,%eax
  8002b5:	ff 75 0c             	pushl  0xc(%ebp)
  8002b8:	ff 75 08             	pushl  0x8(%ebp)
  8002bb:	50                   	push   %eax
  8002bc:	68 c1 34 80 00       	push   $0x8034c1
  8002c1:	e8 70 02 00 00       	call   800536 <cprintf>
  8002c6:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8002cc:	83 ec 08             	sub    $0x8,%esp
  8002cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8002d2:	50                   	push   %eax
  8002d3:	e8 f3 01 00 00       	call   8004cb <vcprintf>
  8002d8:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002db:	83 ec 08             	sub    $0x8,%esp
  8002de:	6a 00                	push   $0x0
  8002e0:	68 dd 34 80 00       	push   $0x8034dd
  8002e5:	e8 e1 01 00 00       	call   8004cb <vcprintf>
  8002ea:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002ed:	e8 82 ff ff ff       	call   800274 <exit>

	// should not return here
	while (1) ;
  8002f2:	eb fe                	jmp    8002f2 <_panic+0x70>

008002f4 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002f4:	55                   	push   %ebp
  8002f5:	89 e5                	mov    %esp,%ebp
  8002f7:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002fa:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ff:	8b 50 74             	mov    0x74(%eax),%edx
  800302:	8b 45 0c             	mov    0xc(%ebp),%eax
  800305:	39 c2                	cmp    %eax,%edx
  800307:	74 14                	je     80031d <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800309:	83 ec 04             	sub    $0x4,%esp
  80030c:	68 e0 34 80 00       	push   $0x8034e0
  800311:	6a 26                	push   $0x26
  800313:	68 2c 35 80 00       	push   $0x80352c
  800318:	e8 65 ff ff ff       	call   800282 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80031d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800324:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80032b:	e9 c2 00 00 00       	jmp    8003f2 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800330:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800333:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033a:	8b 45 08             	mov    0x8(%ebp),%eax
  80033d:	01 d0                	add    %edx,%eax
  80033f:	8b 00                	mov    (%eax),%eax
  800341:	85 c0                	test   %eax,%eax
  800343:	75 08                	jne    80034d <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800345:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800348:	e9 a2 00 00 00       	jmp    8003ef <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80034d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800354:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80035b:	eb 69                	jmp    8003c6 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80035d:	a1 20 40 80 00       	mov    0x804020,%eax
  800362:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800368:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80036b:	89 d0                	mov    %edx,%eax
  80036d:	01 c0                	add    %eax,%eax
  80036f:	01 d0                	add    %edx,%eax
  800371:	c1 e0 03             	shl    $0x3,%eax
  800374:	01 c8                	add    %ecx,%eax
  800376:	8a 40 04             	mov    0x4(%eax),%al
  800379:	84 c0                	test   %al,%al
  80037b:	75 46                	jne    8003c3 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80037d:	a1 20 40 80 00       	mov    0x804020,%eax
  800382:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800388:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80038b:	89 d0                	mov    %edx,%eax
  80038d:	01 c0                	add    %eax,%eax
  80038f:	01 d0                	add    %edx,%eax
  800391:	c1 e0 03             	shl    $0x3,%eax
  800394:	01 c8                	add    %ecx,%eax
  800396:	8b 00                	mov    (%eax),%eax
  800398:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80039b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80039e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003a3:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003af:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b2:	01 c8                	add    %ecx,%eax
  8003b4:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003b6:	39 c2                	cmp    %eax,%edx
  8003b8:	75 09                	jne    8003c3 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003ba:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003c1:	eb 12                	jmp    8003d5 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003c3:	ff 45 e8             	incl   -0x18(%ebp)
  8003c6:	a1 20 40 80 00       	mov    0x804020,%eax
  8003cb:	8b 50 74             	mov    0x74(%eax),%edx
  8003ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003d1:	39 c2                	cmp    %eax,%edx
  8003d3:	77 88                	ja     80035d <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003d9:	75 14                	jne    8003ef <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003db:	83 ec 04             	sub    $0x4,%esp
  8003de:	68 38 35 80 00       	push   $0x803538
  8003e3:	6a 3a                	push   $0x3a
  8003e5:	68 2c 35 80 00       	push   $0x80352c
  8003ea:	e8 93 fe ff ff       	call   800282 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003ef:	ff 45 f0             	incl   -0x10(%ebp)
  8003f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003f8:	0f 8c 32 ff ff ff    	jl     800330 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003fe:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800405:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80040c:	eb 26                	jmp    800434 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80040e:	a1 20 40 80 00       	mov    0x804020,%eax
  800413:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800419:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80041c:	89 d0                	mov    %edx,%eax
  80041e:	01 c0                	add    %eax,%eax
  800420:	01 d0                	add    %edx,%eax
  800422:	c1 e0 03             	shl    $0x3,%eax
  800425:	01 c8                	add    %ecx,%eax
  800427:	8a 40 04             	mov    0x4(%eax),%al
  80042a:	3c 01                	cmp    $0x1,%al
  80042c:	75 03                	jne    800431 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80042e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800431:	ff 45 e0             	incl   -0x20(%ebp)
  800434:	a1 20 40 80 00       	mov    0x804020,%eax
  800439:	8b 50 74             	mov    0x74(%eax),%edx
  80043c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80043f:	39 c2                	cmp    %eax,%edx
  800441:	77 cb                	ja     80040e <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800446:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800449:	74 14                	je     80045f <CheckWSWithoutLastIndex+0x16b>
		panic(
  80044b:	83 ec 04             	sub    $0x4,%esp
  80044e:	68 8c 35 80 00       	push   $0x80358c
  800453:	6a 44                	push   $0x44
  800455:	68 2c 35 80 00       	push   $0x80352c
  80045a:	e8 23 fe ff ff       	call   800282 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80045f:	90                   	nop
  800460:	c9                   	leave  
  800461:	c3                   	ret    

00800462 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800462:	55                   	push   %ebp
  800463:	89 e5                	mov    %esp,%ebp
  800465:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800468:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046b:	8b 00                	mov    (%eax),%eax
  80046d:	8d 48 01             	lea    0x1(%eax),%ecx
  800470:	8b 55 0c             	mov    0xc(%ebp),%edx
  800473:	89 0a                	mov    %ecx,(%edx)
  800475:	8b 55 08             	mov    0x8(%ebp),%edx
  800478:	88 d1                	mov    %dl,%cl
  80047a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80047d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800481:	8b 45 0c             	mov    0xc(%ebp),%eax
  800484:	8b 00                	mov    (%eax),%eax
  800486:	3d ff 00 00 00       	cmp    $0xff,%eax
  80048b:	75 2c                	jne    8004b9 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80048d:	a0 24 40 80 00       	mov    0x804024,%al
  800492:	0f b6 c0             	movzbl %al,%eax
  800495:	8b 55 0c             	mov    0xc(%ebp),%edx
  800498:	8b 12                	mov    (%edx),%edx
  80049a:	89 d1                	mov    %edx,%ecx
  80049c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80049f:	83 c2 08             	add    $0x8,%edx
  8004a2:	83 ec 04             	sub    $0x4,%esp
  8004a5:	50                   	push   %eax
  8004a6:	51                   	push   %ecx
  8004a7:	52                   	push   %edx
  8004a8:	e8 80 13 00 00       	call   80182d <sys_cputs>
  8004ad:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004bc:	8b 40 04             	mov    0x4(%eax),%eax
  8004bf:	8d 50 01             	lea    0x1(%eax),%edx
  8004c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c5:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004c8:	90                   	nop
  8004c9:	c9                   	leave  
  8004ca:	c3                   	ret    

008004cb <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004cb:	55                   	push   %ebp
  8004cc:	89 e5                	mov    %esp,%ebp
  8004ce:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004d4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004db:	00 00 00 
	b.cnt = 0;
  8004de:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004e5:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004e8:	ff 75 0c             	pushl  0xc(%ebp)
  8004eb:	ff 75 08             	pushl  0x8(%ebp)
  8004ee:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004f4:	50                   	push   %eax
  8004f5:	68 62 04 80 00       	push   $0x800462
  8004fa:	e8 11 02 00 00       	call   800710 <vprintfmt>
  8004ff:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800502:	a0 24 40 80 00       	mov    0x804024,%al
  800507:	0f b6 c0             	movzbl %al,%eax
  80050a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800510:	83 ec 04             	sub    $0x4,%esp
  800513:	50                   	push   %eax
  800514:	52                   	push   %edx
  800515:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80051b:	83 c0 08             	add    $0x8,%eax
  80051e:	50                   	push   %eax
  80051f:	e8 09 13 00 00       	call   80182d <sys_cputs>
  800524:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800527:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80052e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800534:	c9                   	leave  
  800535:	c3                   	ret    

00800536 <cprintf>:

int cprintf(const char *fmt, ...) {
  800536:	55                   	push   %ebp
  800537:	89 e5                	mov    %esp,%ebp
  800539:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80053c:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800543:	8d 45 0c             	lea    0xc(%ebp),%eax
  800546:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800549:	8b 45 08             	mov    0x8(%ebp),%eax
  80054c:	83 ec 08             	sub    $0x8,%esp
  80054f:	ff 75 f4             	pushl  -0xc(%ebp)
  800552:	50                   	push   %eax
  800553:	e8 73 ff ff ff       	call   8004cb <vcprintf>
  800558:	83 c4 10             	add    $0x10,%esp
  80055b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80055e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800561:	c9                   	leave  
  800562:	c3                   	ret    

00800563 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800563:	55                   	push   %ebp
  800564:	89 e5                	mov    %esp,%ebp
  800566:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800569:	e8 6d 14 00 00       	call   8019db <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80056e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800571:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800574:	8b 45 08             	mov    0x8(%ebp),%eax
  800577:	83 ec 08             	sub    $0x8,%esp
  80057a:	ff 75 f4             	pushl  -0xc(%ebp)
  80057d:	50                   	push   %eax
  80057e:	e8 48 ff ff ff       	call   8004cb <vcprintf>
  800583:	83 c4 10             	add    $0x10,%esp
  800586:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800589:	e8 67 14 00 00       	call   8019f5 <sys_enable_interrupt>
	return cnt;
  80058e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800591:	c9                   	leave  
  800592:	c3                   	ret    

00800593 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800593:	55                   	push   %ebp
  800594:	89 e5                	mov    %esp,%ebp
  800596:	53                   	push   %ebx
  800597:	83 ec 14             	sub    $0x14,%esp
  80059a:	8b 45 10             	mov    0x10(%ebp),%eax
  80059d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005a6:	8b 45 18             	mov    0x18(%ebp),%eax
  8005a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ae:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005b1:	77 55                	ja     800608 <printnum+0x75>
  8005b3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005b6:	72 05                	jb     8005bd <printnum+0x2a>
  8005b8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005bb:	77 4b                	ja     800608 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005bd:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005c0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005c3:	8b 45 18             	mov    0x18(%ebp),%eax
  8005c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8005cb:	52                   	push   %edx
  8005cc:	50                   	push   %eax
  8005cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8005d0:	ff 75 f0             	pushl  -0x10(%ebp)
  8005d3:	e8 d0 29 00 00       	call   802fa8 <__udivdi3>
  8005d8:	83 c4 10             	add    $0x10,%esp
  8005db:	83 ec 04             	sub    $0x4,%esp
  8005de:	ff 75 20             	pushl  0x20(%ebp)
  8005e1:	53                   	push   %ebx
  8005e2:	ff 75 18             	pushl  0x18(%ebp)
  8005e5:	52                   	push   %edx
  8005e6:	50                   	push   %eax
  8005e7:	ff 75 0c             	pushl  0xc(%ebp)
  8005ea:	ff 75 08             	pushl  0x8(%ebp)
  8005ed:	e8 a1 ff ff ff       	call   800593 <printnum>
  8005f2:	83 c4 20             	add    $0x20,%esp
  8005f5:	eb 1a                	jmp    800611 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005f7:	83 ec 08             	sub    $0x8,%esp
  8005fa:	ff 75 0c             	pushl  0xc(%ebp)
  8005fd:	ff 75 20             	pushl  0x20(%ebp)
  800600:	8b 45 08             	mov    0x8(%ebp),%eax
  800603:	ff d0                	call   *%eax
  800605:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800608:	ff 4d 1c             	decl   0x1c(%ebp)
  80060b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80060f:	7f e6                	jg     8005f7 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800611:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800614:	bb 00 00 00 00       	mov    $0x0,%ebx
  800619:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80061c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80061f:	53                   	push   %ebx
  800620:	51                   	push   %ecx
  800621:	52                   	push   %edx
  800622:	50                   	push   %eax
  800623:	e8 90 2a 00 00       	call   8030b8 <__umoddi3>
  800628:	83 c4 10             	add    $0x10,%esp
  80062b:	05 f4 37 80 00       	add    $0x8037f4,%eax
  800630:	8a 00                	mov    (%eax),%al
  800632:	0f be c0             	movsbl %al,%eax
  800635:	83 ec 08             	sub    $0x8,%esp
  800638:	ff 75 0c             	pushl  0xc(%ebp)
  80063b:	50                   	push   %eax
  80063c:	8b 45 08             	mov    0x8(%ebp),%eax
  80063f:	ff d0                	call   *%eax
  800641:	83 c4 10             	add    $0x10,%esp
}
  800644:	90                   	nop
  800645:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800648:	c9                   	leave  
  800649:	c3                   	ret    

0080064a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80064a:	55                   	push   %ebp
  80064b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80064d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800651:	7e 1c                	jle    80066f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800653:	8b 45 08             	mov    0x8(%ebp),%eax
  800656:	8b 00                	mov    (%eax),%eax
  800658:	8d 50 08             	lea    0x8(%eax),%edx
  80065b:	8b 45 08             	mov    0x8(%ebp),%eax
  80065e:	89 10                	mov    %edx,(%eax)
  800660:	8b 45 08             	mov    0x8(%ebp),%eax
  800663:	8b 00                	mov    (%eax),%eax
  800665:	83 e8 08             	sub    $0x8,%eax
  800668:	8b 50 04             	mov    0x4(%eax),%edx
  80066b:	8b 00                	mov    (%eax),%eax
  80066d:	eb 40                	jmp    8006af <getuint+0x65>
	else if (lflag)
  80066f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800673:	74 1e                	je     800693 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800675:	8b 45 08             	mov    0x8(%ebp),%eax
  800678:	8b 00                	mov    (%eax),%eax
  80067a:	8d 50 04             	lea    0x4(%eax),%edx
  80067d:	8b 45 08             	mov    0x8(%ebp),%eax
  800680:	89 10                	mov    %edx,(%eax)
  800682:	8b 45 08             	mov    0x8(%ebp),%eax
  800685:	8b 00                	mov    (%eax),%eax
  800687:	83 e8 04             	sub    $0x4,%eax
  80068a:	8b 00                	mov    (%eax),%eax
  80068c:	ba 00 00 00 00       	mov    $0x0,%edx
  800691:	eb 1c                	jmp    8006af <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800693:	8b 45 08             	mov    0x8(%ebp),%eax
  800696:	8b 00                	mov    (%eax),%eax
  800698:	8d 50 04             	lea    0x4(%eax),%edx
  80069b:	8b 45 08             	mov    0x8(%ebp),%eax
  80069e:	89 10                	mov    %edx,(%eax)
  8006a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a3:	8b 00                	mov    (%eax),%eax
  8006a5:	83 e8 04             	sub    $0x4,%eax
  8006a8:	8b 00                	mov    (%eax),%eax
  8006aa:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006af:	5d                   	pop    %ebp
  8006b0:	c3                   	ret    

008006b1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006b1:	55                   	push   %ebp
  8006b2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006b4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006b8:	7e 1c                	jle    8006d6 <getint+0x25>
		return va_arg(*ap, long long);
  8006ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bd:	8b 00                	mov    (%eax),%eax
  8006bf:	8d 50 08             	lea    0x8(%eax),%edx
  8006c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c5:	89 10                	mov    %edx,(%eax)
  8006c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ca:	8b 00                	mov    (%eax),%eax
  8006cc:	83 e8 08             	sub    $0x8,%eax
  8006cf:	8b 50 04             	mov    0x4(%eax),%edx
  8006d2:	8b 00                	mov    (%eax),%eax
  8006d4:	eb 38                	jmp    80070e <getint+0x5d>
	else if (lflag)
  8006d6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006da:	74 1a                	je     8006f6 <getint+0x45>
		return va_arg(*ap, long);
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	8b 00                	mov    (%eax),%eax
  8006e1:	8d 50 04             	lea    0x4(%eax),%edx
  8006e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e7:	89 10                	mov    %edx,(%eax)
  8006e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ec:	8b 00                	mov    (%eax),%eax
  8006ee:	83 e8 04             	sub    $0x4,%eax
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	99                   	cltd   
  8006f4:	eb 18                	jmp    80070e <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f9:	8b 00                	mov    (%eax),%eax
  8006fb:	8d 50 04             	lea    0x4(%eax),%edx
  8006fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800701:	89 10                	mov    %edx,(%eax)
  800703:	8b 45 08             	mov    0x8(%ebp),%eax
  800706:	8b 00                	mov    (%eax),%eax
  800708:	83 e8 04             	sub    $0x4,%eax
  80070b:	8b 00                	mov    (%eax),%eax
  80070d:	99                   	cltd   
}
  80070e:	5d                   	pop    %ebp
  80070f:	c3                   	ret    

00800710 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800710:	55                   	push   %ebp
  800711:	89 e5                	mov    %esp,%ebp
  800713:	56                   	push   %esi
  800714:	53                   	push   %ebx
  800715:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800718:	eb 17                	jmp    800731 <vprintfmt+0x21>
			if (ch == '\0')
  80071a:	85 db                	test   %ebx,%ebx
  80071c:	0f 84 af 03 00 00    	je     800ad1 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800722:	83 ec 08             	sub    $0x8,%esp
  800725:	ff 75 0c             	pushl  0xc(%ebp)
  800728:	53                   	push   %ebx
  800729:	8b 45 08             	mov    0x8(%ebp),%eax
  80072c:	ff d0                	call   *%eax
  80072e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800731:	8b 45 10             	mov    0x10(%ebp),%eax
  800734:	8d 50 01             	lea    0x1(%eax),%edx
  800737:	89 55 10             	mov    %edx,0x10(%ebp)
  80073a:	8a 00                	mov    (%eax),%al
  80073c:	0f b6 d8             	movzbl %al,%ebx
  80073f:	83 fb 25             	cmp    $0x25,%ebx
  800742:	75 d6                	jne    80071a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800744:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800748:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80074f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800756:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80075d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800764:	8b 45 10             	mov    0x10(%ebp),%eax
  800767:	8d 50 01             	lea    0x1(%eax),%edx
  80076a:	89 55 10             	mov    %edx,0x10(%ebp)
  80076d:	8a 00                	mov    (%eax),%al
  80076f:	0f b6 d8             	movzbl %al,%ebx
  800772:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800775:	83 f8 55             	cmp    $0x55,%eax
  800778:	0f 87 2b 03 00 00    	ja     800aa9 <vprintfmt+0x399>
  80077e:	8b 04 85 18 38 80 00 	mov    0x803818(,%eax,4),%eax
  800785:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800787:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80078b:	eb d7                	jmp    800764 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80078d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800791:	eb d1                	jmp    800764 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800793:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80079a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80079d:	89 d0                	mov    %edx,%eax
  80079f:	c1 e0 02             	shl    $0x2,%eax
  8007a2:	01 d0                	add    %edx,%eax
  8007a4:	01 c0                	add    %eax,%eax
  8007a6:	01 d8                	add    %ebx,%eax
  8007a8:	83 e8 30             	sub    $0x30,%eax
  8007ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b1:	8a 00                	mov    (%eax),%al
  8007b3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007b6:	83 fb 2f             	cmp    $0x2f,%ebx
  8007b9:	7e 3e                	jle    8007f9 <vprintfmt+0xe9>
  8007bb:	83 fb 39             	cmp    $0x39,%ebx
  8007be:	7f 39                	jg     8007f9 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007c3:	eb d5                	jmp    80079a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c8:	83 c0 04             	add    $0x4,%eax
  8007cb:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d1:	83 e8 04             	sub    $0x4,%eax
  8007d4:	8b 00                	mov    (%eax),%eax
  8007d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007d9:	eb 1f                	jmp    8007fa <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007db:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007df:	79 83                	jns    800764 <vprintfmt+0x54>
				width = 0;
  8007e1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007e8:	e9 77 ff ff ff       	jmp    800764 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007ed:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007f4:	e9 6b ff ff ff       	jmp    800764 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007f9:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007fe:	0f 89 60 ff ff ff    	jns    800764 <vprintfmt+0x54>
				width = precision, precision = -1;
  800804:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800807:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80080a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800811:	e9 4e ff ff ff       	jmp    800764 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800816:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800819:	e9 46 ff ff ff       	jmp    800764 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80081e:	8b 45 14             	mov    0x14(%ebp),%eax
  800821:	83 c0 04             	add    $0x4,%eax
  800824:	89 45 14             	mov    %eax,0x14(%ebp)
  800827:	8b 45 14             	mov    0x14(%ebp),%eax
  80082a:	83 e8 04             	sub    $0x4,%eax
  80082d:	8b 00                	mov    (%eax),%eax
  80082f:	83 ec 08             	sub    $0x8,%esp
  800832:	ff 75 0c             	pushl  0xc(%ebp)
  800835:	50                   	push   %eax
  800836:	8b 45 08             	mov    0x8(%ebp),%eax
  800839:	ff d0                	call   *%eax
  80083b:	83 c4 10             	add    $0x10,%esp
			break;
  80083e:	e9 89 02 00 00       	jmp    800acc <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800843:	8b 45 14             	mov    0x14(%ebp),%eax
  800846:	83 c0 04             	add    $0x4,%eax
  800849:	89 45 14             	mov    %eax,0x14(%ebp)
  80084c:	8b 45 14             	mov    0x14(%ebp),%eax
  80084f:	83 e8 04             	sub    $0x4,%eax
  800852:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800854:	85 db                	test   %ebx,%ebx
  800856:	79 02                	jns    80085a <vprintfmt+0x14a>
				err = -err;
  800858:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80085a:	83 fb 64             	cmp    $0x64,%ebx
  80085d:	7f 0b                	jg     80086a <vprintfmt+0x15a>
  80085f:	8b 34 9d 60 36 80 00 	mov    0x803660(,%ebx,4),%esi
  800866:	85 f6                	test   %esi,%esi
  800868:	75 19                	jne    800883 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80086a:	53                   	push   %ebx
  80086b:	68 05 38 80 00       	push   $0x803805
  800870:	ff 75 0c             	pushl  0xc(%ebp)
  800873:	ff 75 08             	pushl  0x8(%ebp)
  800876:	e8 5e 02 00 00       	call   800ad9 <printfmt>
  80087b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80087e:	e9 49 02 00 00       	jmp    800acc <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800883:	56                   	push   %esi
  800884:	68 0e 38 80 00       	push   $0x80380e
  800889:	ff 75 0c             	pushl  0xc(%ebp)
  80088c:	ff 75 08             	pushl  0x8(%ebp)
  80088f:	e8 45 02 00 00       	call   800ad9 <printfmt>
  800894:	83 c4 10             	add    $0x10,%esp
			break;
  800897:	e9 30 02 00 00       	jmp    800acc <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80089c:	8b 45 14             	mov    0x14(%ebp),%eax
  80089f:	83 c0 04             	add    $0x4,%eax
  8008a2:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a8:	83 e8 04             	sub    $0x4,%eax
  8008ab:	8b 30                	mov    (%eax),%esi
  8008ad:	85 f6                	test   %esi,%esi
  8008af:	75 05                	jne    8008b6 <vprintfmt+0x1a6>
				p = "(null)";
  8008b1:	be 11 38 80 00       	mov    $0x803811,%esi
			if (width > 0 && padc != '-')
  8008b6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ba:	7e 6d                	jle    800929 <vprintfmt+0x219>
  8008bc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008c0:	74 67                	je     800929 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c5:	83 ec 08             	sub    $0x8,%esp
  8008c8:	50                   	push   %eax
  8008c9:	56                   	push   %esi
  8008ca:	e8 0c 03 00 00       	call   800bdb <strnlen>
  8008cf:	83 c4 10             	add    $0x10,%esp
  8008d2:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008d5:	eb 16                	jmp    8008ed <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008d7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008db:	83 ec 08             	sub    $0x8,%esp
  8008de:	ff 75 0c             	pushl  0xc(%ebp)
  8008e1:	50                   	push   %eax
  8008e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e5:	ff d0                	call   *%eax
  8008e7:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008ea:	ff 4d e4             	decl   -0x1c(%ebp)
  8008ed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008f1:	7f e4                	jg     8008d7 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008f3:	eb 34                	jmp    800929 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008f5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008f9:	74 1c                	je     800917 <vprintfmt+0x207>
  8008fb:	83 fb 1f             	cmp    $0x1f,%ebx
  8008fe:	7e 05                	jle    800905 <vprintfmt+0x1f5>
  800900:	83 fb 7e             	cmp    $0x7e,%ebx
  800903:	7e 12                	jle    800917 <vprintfmt+0x207>
					putch('?', putdat);
  800905:	83 ec 08             	sub    $0x8,%esp
  800908:	ff 75 0c             	pushl  0xc(%ebp)
  80090b:	6a 3f                	push   $0x3f
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	ff d0                	call   *%eax
  800912:	83 c4 10             	add    $0x10,%esp
  800915:	eb 0f                	jmp    800926 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800917:	83 ec 08             	sub    $0x8,%esp
  80091a:	ff 75 0c             	pushl  0xc(%ebp)
  80091d:	53                   	push   %ebx
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	ff d0                	call   *%eax
  800923:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800926:	ff 4d e4             	decl   -0x1c(%ebp)
  800929:	89 f0                	mov    %esi,%eax
  80092b:	8d 70 01             	lea    0x1(%eax),%esi
  80092e:	8a 00                	mov    (%eax),%al
  800930:	0f be d8             	movsbl %al,%ebx
  800933:	85 db                	test   %ebx,%ebx
  800935:	74 24                	je     80095b <vprintfmt+0x24b>
  800937:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80093b:	78 b8                	js     8008f5 <vprintfmt+0x1e5>
  80093d:	ff 4d e0             	decl   -0x20(%ebp)
  800940:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800944:	79 af                	jns    8008f5 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800946:	eb 13                	jmp    80095b <vprintfmt+0x24b>
				putch(' ', putdat);
  800948:	83 ec 08             	sub    $0x8,%esp
  80094b:	ff 75 0c             	pushl  0xc(%ebp)
  80094e:	6a 20                	push   $0x20
  800950:	8b 45 08             	mov    0x8(%ebp),%eax
  800953:	ff d0                	call   *%eax
  800955:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800958:	ff 4d e4             	decl   -0x1c(%ebp)
  80095b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80095f:	7f e7                	jg     800948 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800961:	e9 66 01 00 00       	jmp    800acc <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800966:	83 ec 08             	sub    $0x8,%esp
  800969:	ff 75 e8             	pushl  -0x18(%ebp)
  80096c:	8d 45 14             	lea    0x14(%ebp),%eax
  80096f:	50                   	push   %eax
  800970:	e8 3c fd ff ff       	call   8006b1 <getint>
  800975:	83 c4 10             	add    $0x10,%esp
  800978:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80097b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80097e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800981:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800984:	85 d2                	test   %edx,%edx
  800986:	79 23                	jns    8009ab <vprintfmt+0x29b>
				putch('-', putdat);
  800988:	83 ec 08             	sub    $0x8,%esp
  80098b:	ff 75 0c             	pushl  0xc(%ebp)
  80098e:	6a 2d                	push   $0x2d
  800990:	8b 45 08             	mov    0x8(%ebp),%eax
  800993:	ff d0                	call   *%eax
  800995:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800998:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80099b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80099e:	f7 d8                	neg    %eax
  8009a0:	83 d2 00             	adc    $0x0,%edx
  8009a3:	f7 da                	neg    %edx
  8009a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009ab:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009b2:	e9 bc 00 00 00       	jmp    800a73 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009b7:	83 ec 08             	sub    $0x8,%esp
  8009ba:	ff 75 e8             	pushl  -0x18(%ebp)
  8009bd:	8d 45 14             	lea    0x14(%ebp),%eax
  8009c0:	50                   	push   %eax
  8009c1:	e8 84 fc ff ff       	call   80064a <getuint>
  8009c6:	83 c4 10             	add    $0x10,%esp
  8009c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009cc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009cf:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009d6:	e9 98 00 00 00       	jmp    800a73 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009db:	83 ec 08             	sub    $0x8,%esp
  8009de:	ff 75 0c             	pushl  0xc(%ebp)
  8009e1:	6a 58                	push   $0x58
  8009e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e6:	ff d0                	call   *%eax
  8009e8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009eb:	83 ec 08             	sub    $0x8,%esp
  8009ee:	ff 75 0c             	pushl  0xc(%ebp)
  8009f1:	6a 58                	push   $0x58
  8009f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f6:	ff d0                	call   *%eax
  8009f8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009fb:	83 ec 08             	sub    $0x8,%esp
  8009fe:	ff 75 0c             	pushl  0xc(%ebp)
  800a01:	6a 58                	push   $0x58
  800a03:	8b 45 08             	mov    0x8(%ebp),%eax
  800a06:	ff d0                	call   *%eax
  800a08:	83 c4 10             	add    $0x10,%esp
			break;
  800a0b:	e9 bc 00 00 00       	jmp    800acc <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a10:	83 ec 08             	sub    $0x8,%esp
  800a13:	ff 75 0c             	pushl  0xc(%ebp)
  800a16:	6a 30                	push   $0x30
  800a18:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1b:	ff d0                	call   *%eax
  800a1d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a20:	83 ec 08             	sub    $0x8,%esp
  800a23:	ff 75 0c             	pushl  0xc(%ebp)
  800a26:	6a 78                	push   $0x78
  800a28:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2b:	ff d0                	call   *%eax
  800a2d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a30:	8b 45 14             	mov    0x14(%ebp),%eax
  800a33:	83 c0 04             	add    $0x4,%eax
  800a36:	89 45 14             	mov    %eax,0x14(%ebp)
  800a39:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3c:	83 e8 04             	sub    $0x4,%eax
  800a3f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a44:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a4b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a52:	eb 1f                	jmp    800a73 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a54:	83 ec 08             	sub    $0x8,%esp
  800a57:	ff 75 e8             	pushl  -0x18(%ebp)
  800a5a:	8d 45 14             	lea    0x14(%ebp),%eax
  800a5d:	50                   	push   %eax
  800a5e:	e8 e7 fb ff ff       	call   80064a <getuint>
  800a63:	83 c4 10             	add    $0x10,%esp
  800a66:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a69:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a6c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a73:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a7a:	83 ec 04             	sub    $0x4,%esp
  800a7d:	52                   	push   %edx
  800a7e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a81:	50                   	push   %eax
  800a82:	ff 75 f4             	pushl  -0xc(%ebp)
  800a85:	ff 75 f0             	pushl  -0x10(%ebp)
  800a88:	ff 75 0c             	pushl  0xc(%ebp)
  800a8b:	ff 75 08             	pushl  0x8(%ebp)
  800a8e:	e8 00 fb ff ff       	call   800593 <printnum>
  800a93:	83 c4 20             	add    $0x20,%esp
			break;
  800a96:	eb 34                	jmp    800acc <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a98:	83 ec 08             	sub    $0x8,%esp
  800a9b:	ff 75 0c             	pushl  0xc(%ebp)
  800a9e:	53                   	push   %ebx
  800a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa2:	ff d0                	call   *%eax
  800aa4:	83 c4 10             	add    $0x10,%esp
			break;
  800aa7:	eb 23                	jmp    800acc <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800aa9:	83 ec 08             	sub    $0x8,%esp
  800aac:	ff 75 0c             	pushl  0xc(%ebp)
  800aaf:	6a 25                	push   $0x25
  800ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab4:	ff d0                	call   *%eax
  800ab6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ab9:	ff 4d 10             	decl   0x10(%ebp)
  800abc:	eb 03                	jmp    800ac1 <vprintfmt+0x3b1>
  800abe:	ff 4d 10             	decl   0x10(%ebp)
  800ac1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac4:	48                   	dec    %eax
  800ac5:	8a 00                	mov    (%eax),%al
  800ac7:	3c 25                	cmp    $0x25,%al
  800ac9:	75 f3                	jne    800abe <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800acb:	90                   	nop
		}
	}
  800acc:	e9 47 fc ff ff       	jmp    800718 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ad1:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ad2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ad5:	5b                   	pop    %ebx
  800ad6:	5e                   	pop    %esi
  800ad7:	5d                   	pop    %ebp
  800ad8:	c3                   	ret    

00800ad9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ad9:	55                   	push   %ebp
  800ada:	89 e5                	mov    %esp,%ebp
  800adc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800adf:	8d 45 10             	lea    0x10(%ebp),%eax
  800ae2:	83 c0 04             	add    $0x4,%eax
  800ae5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ae8:	8b 45 10             	mov    0x10(%ebp),%eax
  800aeb:	ff 75 f4             	pushl  -0xc(%ebp)
  800aee:	50                   	push   %eax
  800aef:	ff 75 0c             	pushl  0xc(%ebp)
  800af2:	ff 75 08             	pushl  0x8(%ebp)
  800af5:	e8 16 fc ff ff       	call   800710 <vprintfmt>
  800afa:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800afd:	90                   	nop
  800afe:	c9                   	leave  
  800aff:	c3                   	ret    

00800b00 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b00:	55                   	push   %ebp
  800b01:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b06:	8b 40 08             	mov    0x8(%eax),%eax
  800b09:	8d 50 01             	lea    0x1(%eax),%edx
  800b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b15:	8b 10                	mov    (%eax),%edx
  800b17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1a:	8b 40 04             	mov    0x4(%eax),%eax
  800b1d:	39 c2                	cmp    %eax,%edx
  800b1f:	73 12                	jae    800b33 <sprintputch+0x33>
		*b->buf++ = ch;
  800b21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b24:	8b 00                	mov    (%eax),%eax
  800b26:	8d 48 01             	lea    0x1(%eax),%ecx
  800b29:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b2c:	89 0a                	mov    %ecx,(%edx)
  800b2e:	8b 55 08             	mov    0x8(%ebp),%edx
  800b31:	88 10                	mov    %dl,(%eax)
}
  800b33:	90                   	nop
  800b34:	5d                   	pop    %ebp
  800b35:	c3                   	ret    

00800b36 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b36:	55                   	push   %ebp
  800b37:	89 e5                	mov    %esp,%ebp
  800b39:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b45:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4b:	01 d0                	add    %edx,%eax
  800b4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b50:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b57:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b5b:	74 06                	je     800b63 <vsnprintf+0x2d>
  800b5d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b61:	7f 07                	jg     800b6a <vsnprintf+0x34>
		return -E_INVAL;
  800b63:	b8 03 00 00 00       	mov    $0x3,%eax
  800b68:	eb 20                	jmp    800b8a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b6a:	ff 75 14             	pushl  0x14(%ebp)
  800b6d:	ff 75 10             	pushl  0x10(%ebp)
  800b70:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b73:	50                   	push   %eax
  800b74:	68 00 0b 80 00       	push   $0x800b00
  800b79:	e8 92 fb ff ff       	call   800710 <vprintfmt>
  800b7e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b84:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b8a:	c9                   	leave  
  800b8b:	c3                   	ret    

00800b8c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b92:	8d 45 10             	lea    0x10(%ebp),%eax
  800b95:	83 c0 04             	add    $0x4,%eax
  800b98:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9e:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba1:	50                   	push   %eax
  800ba2:	ff 75 0c             	pushl  0xc(%ebp)
  800ba5:	ff 75 08             	pushl  0x8(%ebp)
  800ba8:	e8 89 ff ff ff       	call   800b36 <vsnprintf>
  800bad:	83 c4 10             	add    $0x10,%esp
  800bb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bb6:	c9                   	leave  
  800bb7:	c3                   	ret    

00800bb8 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bb8:	55                   	push   %ebp
  800bb9:	89 e5                	mov    %esp,%ebp
  800bbb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bbe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bc5:	eb 06                	jmp    800bcd <strlen+0x15>
		n++;
  800bc7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bca:	ff 45 08             	incl   0x8(%ebp)
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	8a 00                	mov    (%eax),%al
  800bd2:	84 c0                	test   %al,%al
  800bd4:	75 f1                	jne    800bc7 <strlen+0xf>
		n++;
	return n;
  800bd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bd9:	c9                   	leave  
  800bda:	c3                   	ret    

00800bdb <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bdb:	55                   	push   %ebp
  800bdc:	89 e5                	mov    %esp,%ebp
  800bde:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800be1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800be8:	eb 09                	jmp    800bf3 <strnlen+0x18>
		n++;
  800bea:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bed:	ff 45 08             	incl   0x8(%ebp)
  800bf0:	ff 4d 0c             	decl   0xc(%ebp)
  800bf3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf7:	74 09                	je     800c02 <strnlen+0x27>
  800bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfc:	8a 00                	mov    (%eax),%al
  800bfe:	84 c0                	test   %al,%al
  800c00:	75 e8                	jne    800bea <strnlen+0xf>
		n++;
	return n;
  800c02:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c05:	c9                   	leave  
  800c06:	c3                   	ret    

00800c07 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c10:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c13:	90                   	nop
  800c14:	8b 45 08             	mov    0x8(%ebp),%eax
  800c17:	8d 50 01             	lea    0x1(%eax),%edx
  800c1a:	89 55 08             	mov    %edx,0x8(%ebp)
  800c1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c20:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c23:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c26:	8a 12                	mov    (%edx),%dl
  800c28:	88 10                	mov    %dl,(%eax)
  800c2a:	8a 00                	mov    (%eax),%al
  800c2c:	84 c0                	test   %al,%al
  800c2e:	75 e4                	jne    800c14 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c30:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c33:	c9                   	leave  
  800c34:	c3                   	ret    

00800c35 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c35:	55                   	push   %ebp
  800c36:	89 e5                	mov    %esp,%ebp
  800c38:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c41:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c48:	eb 1f                	jmp    800c69 <strncpy+0x34>
		*dst++ = *src;
  800c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4d:	8d 50 01             	lea    0x1(%eax),%edx
  800c50:	89 55 08             	mov    %edx,0x8(%ebp)
  800c53:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c56:	8a 12                	mov    (%edx),%dl
  800c58:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5d:	8a 00                	mov    (%eax),%al
  800c5f:	84 c0                	test   %al,%al
  800c61:	74 03                	je     800c66 <strncpy+0x31>
			src++;
  800c63:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c66:	ff 45 fc             	incl   -0x4(%ebp)
  800c69:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c6c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c6f:	72 d9                	jb     800c4a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c71:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c74:	c9                   	leave  
  800c75:	c3                   	ret    

00800c76 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c76:	55                   	push   %ebp
  800c77:	89 e5                	mov    %esp,%ebp
  800c79:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c82:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c86:	74 30                	je     800cb8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c88:	eb 16                	jmp    800ca0 <strlcpy+0x2a>
			*dst++ = *src++;
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	8d 50 01             	lea    0x1(%eax),%edx
  800c90:	89 55 08             	mov    %edx,0x8(%ebp)
  800c93:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c96:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c99:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c9c:	8a 12                	mov    (%edx),%dl
  800c9e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ca0:	ff 4d 10             	decl   0x10(%ebp)
  800ca3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ca7:	74 09                	je     800cb2 <strlcpy+0x3c>
  800ca9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cac:	8a 00                	mov    (%eax),%al
  800cae:	84 c0                	test   %al,%al
  800cb0:	75 d8                	jne    800c8a <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cb8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cbe:	29 c2                	sub    %eax,%edx
  800cc0:	89 d0                	mov    %edx,%eax
}
  800cc2:	c9                   	leave  
  800cc3:	c3                   	ret    

00800cc4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cc4:	55                   	push   %ebp
  800cc5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cc7:	eb 06                	jmp    800ccf <strcmp+0xb>
		p++, q++;
  800cc9:	ff 45 08             	incl   0x8(%ebp)
  800ccc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	8a 00                	mov    (%eax),%al
  800cd4:	84 c0                	test   %al,%al
  800cd6:	74 0e                	je     800ce6 <strcmp+0x22>
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdb:	8a 10                	mov    (%eax),%dl
  800cdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce0:	8a 00                	mov    (%eax),%al
  800ce2:	38 c2                	cmp    %al,%dl
  800ce4:	74 e3                	je     800cc9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	8a 00                	mov    (%eax),%al
  800ceb:	0f b6 d0             	movzbl %al,%edx
  800cee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf1:	8a 00                	mov    (%eax),%al
  800cf3:	0f b6 c0             	movzbl %al,%eax
  800cf6:	29 c2                	sub    %eax,%edx
  800cf8:	89 d0                	mov    %edx,%eax
}
  800cfa:	5d                   	pop    %ebp
  800cfb:	c3                   	ret    

00800cfc <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cfc:	55                   	push   %ebp
  800cfd:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cff:	eb 09                	jmp    800d0a <strncmp+0xe>
		n--, p++, q++;
  800d01:	ff 4d 10             	decl   0x10(%ebp)
  800d04:	ff 45 08             	incl   0x8(%ebp)
  800d07:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d0e:	74 17                	je     800d27 <strncmp+0x2b>
  800d10:	8b 45 08             	mov    0x8(%ebp),%eax
  800d13:	8a 00                	mov    (%eax),%al
  800d15:	84 c0                	test   %al,%al
  800d17:	74 0e                	je     800d27 <strncmp+0x2b>
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	8a 10                	mov    (%eax),%dl
  800d1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d21:	8a 00                	mov    (%eax),%al
  800d23:	38 c2                	cmp    %al,%dl
  800d25:	74 da                	je     800d01 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d27:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d2b:	75 07                	jne    800d34 <strncmp+0x38>
		return 0;
  800d2d:	b8 00 00 00 00       	mov    $0x0,%eax
  800d32:	eb 14                	jmp    800d48 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	8a 00                	mov    (%eax),%al
  800d39:	0f b6 d0             	movzbl %al,%edx
  800d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3f:	8a 00                	mov    (%eax),%al
  800d41:	0f b6 c0             	movzbl %al,%eax
  800d44:	29 c2                	sub    %eax,%edx
  800d46:	89 d0                	mov    %edx,%eax
}
  800d48:	5d                   	pop    %ebp
  800d49:	c3                   	ret    

00800d4a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	83 ec 04             	sub    $0x4,%esp
  800d50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d53:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d56:	eb 12                	jmp    800d6a <strchr+0x20>
		if (*s == c)
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	8a 00                	mov    (%eax),%al
  800d5d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d60:	75 05                	jne    800d67 <strchr+0x1d>
			return (char *) s;
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	eb 11                	jmp    800d78 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d67:	ff 45 08             	incl   0x8(%ebp)
  800d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6d:	8a 00                	mov    (%eax),%al
  800d6f:	84 c0                	test   %al,%al
  800d71:	75 e5                	jne    800d58 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d78:	c9                   	leave  
  800d79:	c3                   	ret    

00800d7a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d7a:	55                   	push   %ebp
  800d7b:	89 e5                	mov    %esp,%ebp
  800d7d:	83 ec 04             	sub    $0x4,%esp
  800d80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d83:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d86:	eb 0d                	jmp    800d95 <strfind+0x1b>
		if (*s == c)
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	8a 00                	mov    (%eax),%al
  800d8d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d90:	74 0e                	je     800da0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d92:	ff 45 08             	incl   0x8(%ebp)
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
  800d98:	8a 00                	mov    (%eax),%al
  800d9a:	84 c0                	test   %al,%al
  800d9c:	75 ea                	jne    800d88 <strfind+0xe>
  800d9e:	eb 01                	jmp    800da1 <strfind+0x27>
		if (*s == c)
			break;
  800da0:	90                   	nop
	return (char *) s;
  800da1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800da4:	c9                   	leave  
  800da5:	c3                   	ret    

00800da6 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800da6:	55                   	push   %ebp
  800da7:	89 e5                	mov    %esp,%ebp
  800da9:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800db2:	8b 45 10             	mov    0x10(%ebp),%eax
  800db5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800db8:	eb 0e                	jmp    800dc8 <memset+0x22>
		*p++ = c;
  800dba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dbd:	8d 50 01             	lea    0x1(%eax),%edx
  800dc0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc6:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dc8:	ff 4d f8             	decl   -0x8(%ebp)
  800dcb:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dcf:	79 e9                	jns    800dba <memset+0x14>
		*p++ = c;

	return v;
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd4:	c9                   	leave  
  800dd5:	c3                   	ret    

00800dd6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dd6:	55                   	push   %ebp
  800dd7:	89 e5                	mov    %esp,%ebp
  800dd9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ddc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800de8:	eb 16                	jmp    800e00 <memcpy+0x2a>
		*d++ = *s++;
  800dea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ded:	8d 50 01             	lea    0x1(%eax),%edx
  800df0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800df3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800df6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800df9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dfc:	8a 12                	mov    (%edx),%dl
  800dfe:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e00:	8b 45 10             	mov    0x10(%ebp),%eax
  800e03:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e06:	89 55 10             	mov    %edx,0x10(%ebp)
  800e09:	85 c0                	test   %eax,%eax
  800e0b:	75 dd                	jne    800dea <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e0d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e10:	c9                   	leave  
  800e11:	c3                   	ret    

00800e12 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e12:	55                   	push   %ebp
  800e13:	89 e5                	mov    %esp,%ebp
  800e15:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e24:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e27:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e2a:	73 50                	jae    800e7c <memmove+0x6a>
  800e2c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e32:	01 d0                	add    %edx,%eax
  800e34:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e37:	76 43                	jbe    800e7c <memmove+0x6a>
		s += n;
  800e39:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e3f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e42:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e45:	eb 10                	jmp    800e57 <memmove+0x45>
			*--d = *--s;
  800e47:	ff 4d f8             	decl   -0x8(%ebp)
  800e4a:	ff 4d fc             	decl   -0x4(%ebp)
  800e4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e50:	8a 10                	mov    (%eax),%dl
  800e52:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e55:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e57:	8b 45 10             	mov    0x10(%ebp),%eax
  800e5a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e5d:	89 55 10             	mov    %edx,0x10(%ebp)
  800e60:	85 c0                	test   %eax,%eax
  800e62:	75 e3                	jne    800e47 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e64:	eb 23                	jmp    800e89 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e66:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e69:	8d 50 01             	lea    0x1(%eax),%edx
  800e6c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e6f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e72:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e75:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e78:	8a 12                	mov    (%edx),%dl
  800e7a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e82:	89 55 10             	mov    %edx,0x10(%ebp)
  800e85:	85 c0                	test   %eax,%eax
  800e87:	75 dd                	jne    800e66 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e8c:	c9                   	leave  
  800e8d:	c3                   	ret    

00800e8e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e8e:	55                   	push   %ebp
  800e8f:	89 e5                	mov    %esp,%ebp
  800e91:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ea0:	eb 2a                	jmp    800ecc <memcmp+0x3e>
		if (*s1 != *s2)
  800ea2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea5:	8a 10                	mov    (%eax),%dl
  800ea7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eaa:	8a 00                	mov    (%eax),%al
  800eac:	38 c2                	cmp    %al,%dl
  800eae:	74 16                	je     800ec6 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800eb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb3:	8a 00                	mov    (%eax),%al
  800eb5:	0f b6 d0             	movzbl %al,%edx
  800eb8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ebb:	8a 00                	mov    (%eax),%al
  800ebd:	0f b6 c0             	movzbl %al,%eax
  800ec0:	29 c2                	sub    %eax,%edx
  800ec2:	89 d0                	mov    %edx,%eax
  800ec4:	eb 18                	jmp    800ede <memcmp+0x50>
		s1++, s2++;
  800ec6:	ff 45 fc             	incl   -0x4(%ebp)
  800ec9:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ecc:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ed2:	89 55 10             	mov    %edx,0x10(%ebp)
  800ed5:	85 c0                	test   %eax,%eax
  800ed7:	75 c9                	jne    800ea2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ed9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ede:	c9                   	leave  
  800edf:	c3                   	ret    

00800ee0 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ee0:	55                   	push   %ebp
  800ee1:	89 e5                	mov    %esp,%ebp
  800ee3:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ee6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee9:	8b 45 10             	mov    0x10(%ebp),%eax
  800eec:	01 d0                	add    %edx,%eax
  800eee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ef1:	eb 15                	jmp    800f08 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef6:	8a 00                	mov    (%eax),%al
  800ef8:	0f b6 d0             	movzbl %al,%edx
  800efb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efe:	0f b6 c0             	movzbl %al,%eax
  800f01:	39 c2                	cmp    %eax,%edx
  800f03:	74 0d                	je     800f12 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f05:	ff 45 08             	incl   0x8(%ebp)
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f0e:	72 e3                	jb     800ef3 <memfind+0x13>
  800f10:	eb 01                	jmp    800f13 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f12:	90                   	nop
	return (void *) s;
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f16:	c9                   	leave  
  800f17:	c3                   	ret    

00800f18 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
  800f1b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f1e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f25:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f2c:	eb 03                	jmp    800f31 <strtol+0x19>
		s++;
  800f2e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	8a 00                	mov    (%eax),%al
  800f36:	3c 20                	cmp    $0x20,%al
  800f38:	74 f4                	je     800f2e <strtol+0x16>
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	8a 00                	mov    (%eax),%al
  800f3f:	3c 09                	cmp    $0x9,%al
  800f41:	74 eb                	je     800f2e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	3c 2b                	cmp    $0x2b,%al
  800f4a:	75 05                	jne    800f51 <strtol+0x39>
		s++;
  800f4c:	ff 45 08             	incl   0x8(%ebp)
  800f4f:	eb 13                	jmp    800f64 <strtol+0x4c>
	else if (*s == '-')
  800f51:	8b 45 08             	mov    0x8(%ebp),%eax
  800f54:	8a 00                	mov    (%eax),%al
  800f56:	3c 2d                	cmp    $0x2d,%al
  800f58:	75 0a                	jne    800f64 <strtol+0x4c>
		s++, neg = 1;
  800f5a:	ff 45 08             	incl   0x8(%ebp)
  800f5d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f64:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f68:	74 06                	je     800f70 <strtol+0x58>
  800f6a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f6e:	75 20                	jne    800f90 <strtol+0x78>
  800f70:	8b 45 08             	mov    0x8(%ebp),%eax
  800f73:	8a 00                	mov    (%eax),%al
  800f75:	3c 30                	cmp    $0x30,%al
  800f77:	75 17                	jne    800f90 <strtol+0x78>
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	40                   	inc    %eax
  800f7d:	8a 00                	mov    (%eax),%al
  800f7f:	3c 78                	cmp    $0x78,%al
  800f81:	75 0d                	jne    800f90 <strtol+0x78>
		s += 2, base = 16;
  800f83:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f87:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f8e:	eb 28                	jmp    800fb8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f90:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f94:	75 15                	jne    800fab <strtol+0x93>
  800f96:	8b 45 08             	mov    0x8(%ebp),%eax
  800f99:	8a 00                	mov    (%eax),%al
  800f9b:	3c 30                	cmp    $0x30,%al
  800f9d:	75 0c                	jne    800fab <strtol+0x93>
		s++, base = 8;
  800f9f:	ff 45 08             	incl   0x8(%ebp)
  800fa2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fa9:	eb 0d                	jmp    800fb8 <strtol+0xa0>
	else if (base == 0)
  800fab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800faf:	75 07                	jne    800fb8 <strtol+0xa0>
		base = 10;
  800fb1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	8a 00                	mov    (%eax),%al
  800fbd:	3c 2f                	cmp    $0x2f,%al
  800fbf:	7e 19                	jle    800fda <strtol+0xc2>
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc4:	8a 00                	mov    (%eax),%al
  800fc6:	3c 39                	cmp    $0x39,%al
  800fc8:	7f 10                	jg     800fda <strtol+0xc2>
			dig = *s - '0';
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	8a 00                	mov    (%eax),%al
  800fcf:	0f be c0             	movsbl %al,%eax
  800fd2:	83 e8 30             	sub    $0x30,%eax
  800fd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fd8:	eb 42                	jmp    80101c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	3c 60                	cmp    $0x60,%al
  800fe1:	7e 19                	jle    800ffc <strtol+0xe4>
  800fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe6:	8a 00                	mov    (%eax),%al
  800fe8:	3c 7a                	cmp    $0x7a,%al
  800fea:	7f 10                	jg     800ffc <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fec:	8b 45 08             	mov    0x8(%ebp),%eax
  800fef:	8a 00                	mov    (%eax),%al
  800ff1:	0f be c0             	movsbl %al,%eax
  800ff4:	83 e8 57             	sub    $0x57,%eax
  800ff7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ffa:	eb 20                	jmp    80101c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	3c 40                	cmp    $0x40,%al
  801003:	7e 39                	jle    80103e <strtol+0x126>
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	8a 00                	mov    (%eax),%al
  80100a:	3c 5a                	cmp    $0x5a,%al
  80100c:	7f 30                	jg     80103e <strtol+0x126>
			dig = *s - 'A' + 10;
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	8a 00                	mov    (%eax),%al
  801013:	0f be c0             	movsbl %al,%eax
  801016:	83 e8 37             	sub    $0x37,%eax
  801019:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80101c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80101f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801022:	7d 19                	jge    80103d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801024:	ff 45 08             	incl   0x8(%ebp)
  801027:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80102e:	89 c2                	mov    %eax,%edx
  801030:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801033:	01 d0                	add    %edx,%eax
  801035:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801038:	e9 7b ff ff ff       	jmp    800fb8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80103d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80103e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801042:	74 08                	je     80104c <strtol+0x134>
		*endptr = (char *) s;
  801044:	8b 45 0c             	mov    0xc(%ebp),%eax
  801047:	8b 55 08             	mov    0x8(%ebp),%edx
  80104a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80104c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801050:	74 07                	je     801059 <strtol+0x141>
  801052:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801055:	f7 d8                	neg    %eax
  801057:	eb 03                	jmp    80105c <strtol+0x144>
  801059:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80105c:	c9                   	leave  
  80105d:	c3                   	ret    

0080105e <ltostr>:

void
ltostr(long value, char *str)
{
  80105e:	55                   	push   %ebp
  80105f:	89 e5                	mov    %esp,%ebp
  801061:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801064:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80106b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801072:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801076:	79 13                	jns    80108b <ltostr+0x2d>
	{
		neg = 1;
  801078:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80107f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801082:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801085:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801088:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80108b:	8b 45 08             	mov    0x8(%ebp),%eax
  80108e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801093:	99                   	cltd   
  801094:	f7 f9                	idiv   %ecx
  801096:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801099:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80109c:	8d 50 01             	lea    0x1(%eax),%edx
  80109f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010a2:	89 c2                	mov    %eax,%edx
  8010a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a7:	01 d0                	add    %edx,%eax
  8010a9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010ac:	83 c2 30             	add    $0x30,%edx
  8010af:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010b4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010b9:	f7 e9                	imul   %ecx
  8010bb:	c1 fa 02             	sar    $0x2,%edx
  8010be:	89 c8                	mov    %ecx,%eax
  8010c0:	c1 f8 1f             	sar    $0x1f,%eax
  8010c3:	29 c2                	sub    %eax,%edx
  8010c5:	89 d0                	mov    %edx,%eax
  8010c7:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010cd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010d2:	f7 e9                	imul   %ecx
  8010d4:	c1 fa 02             	sar    $0x2,%edx
  8010d7:	89 c8                	mov    %ecx,%eax
  8010d9:	c1 f8 1f             	sar    $0x1f,%eax
  8010dc:	29 c2                	sub    %eax,%edx
  8010de:	89 d0                	mov    %edx,%eax
  8010e0:	c1 e0 02             	shl    $0x2,%eax
  8010e3:	01 d0                	add    %edx,%eax
  8010e5:	01 c0                	add    %eax,%eax
  8010e7:	29 c1                	sub    %eax,%ecx
  8010e9:	89 ca                	mov    %ecx,%edx
  8010eb:	85 d2                	test   %edx,%edx
  8010ed:	75 9c                	jne    80108b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f9:	48                   	dec    %eax
  8010fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801101:	74 3d                	je     801140 <ltostr+0xe2>
		start = 1 ;
  801103:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80110a:	eb 34                	jmp    801140 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80110c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80110f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801112:	01 d0                	add    %edx,%eax
  801114:	8a 00                	mov    (%eax),%al
  801116:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801119:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80111c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111f:	01 c2                	add    %eax,%edx
  801121:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801124:	8b 45 0c             	mov    0xc(%ebp),%eax
  801127:	01 c8                	add    %ecx,%eax
  801129:	8a 00                	mov    (%eax),%al
  80112b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80112d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801130:	8b 45 0c             	mov    0xc(%ebp),%eax
  801133:	01 c2                	add    %eax,%edx
  801135:	8a 45 eb             	mov    -0x15(%ebp),%al
  801138:	88 02                	mov    %al,(%edx)
		start++ ;
  80113a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80113d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801140:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801143:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801146:	7c c4                	jl     80110c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801148:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80114b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114e:	01 d0                	add    %edx,%eax
  801150:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801153:	90                   	nop
  801154:	c9                   	leave  
  801155:	c3                   	ret    

00801156 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801156:	55                   	push   %ebp
  801157:	89 e5                	mov    %esp,%ebp
  801159:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80115c:	ff 75 08             	pushl  0x8(%ebp)
  80115f:	e8 54 fa ff ff       	call   800bb8 <strlen>
  801164:	83 c4 04             	add    $0x4,%esp
  801167:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80116a:	ff 75 0c             	pushl  0xc(%ebp)
  80116d:	e8 46 fa ff ff       	call   800bb8 <strlen>
  801172:	83 c4 04             	add    $0x4,%esp
  801175:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801178:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80117f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801186:	eb 17                	jmp    80119f <strcconcat+0x49>
		final[s] = str1[s] ;
  801188:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80118b:	8b 45 10             	mov    0x10(%ebp),%eax
  80118e:	01 c2                	add    %eax,%edx
  801190:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	01 c8                	add    %ecx,%eax
  801198:	8a 00                	mov    (%eax),%al
  80119a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80119c:	ff 45 fc             	incl   -0x4(%ebp)
  80119f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011a5:	7c e1                	jl     801188 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011a7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011ae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011b5:	eb 1f                	jmp    8011d6 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ba:	8d 50 01             	lea    0x1(%eax),%edx
  8011bd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011c0:	89 c2                	mov    %eax,%edx
  8011c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c5:	01 c2                	add    %eax,%edx
  8011c7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cd:	01 c8                	add    %ecx,%eax
  8011cf:	8a 00                	mov    (%eax),%al
  8011d1:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011d3:	ff 45 f8             	incl   -0x8(%ebp)
  8011d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011dc:	7c d9                	jl     8011b7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011de:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e4:	01 d0                	add    %edx,%eax
  8011e6:	c6 00 00             	movb   $0x0,(%eax)
}
  8011e9:	90                   	nop
  8011ea:	c9                   	leave  
  8011eb:	c3                   	ret    

008011ec <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011ec:	55                   	push   %ebp
  8011ed:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8011fb:	8b 00                	mov    (%eax),%eax
  8011fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801204:	8b 45 10             	mov    0x10(%ebp),%eax
  801207:	01 d0                	add    %edx,%eax
  801209:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80120f:	eb 0c                	jmp    80121d <strsplit+0x31>
			*string++ = 0;
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	8d 50 01             	lea    0x1(%eax),%edx
  801217:	89 55 08             	mov    %edx,0x8(%ebp)
  80121a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80121d:	8b 45 08             	mov    0x8(%ebp),%eax
  801220:	8a 00                	mov    (%eax),%al
  801222:	84 c0                	test   %al,%al
  801224:	74 18                	je     80123e <strsplit+0x52>
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	8a 00                	mov    (%eax),%al
  80122b:	0f be c0             	movsbl %al,%eax
  80122e:	50                   	push   %eax
  80122f:	ff 75 0c             	pushl  0xc(%ebp)
  801232:	e8 13 fb ff ff       	call   800d4a <strchr>
  801237:	83 c4 08             	add    $0x8,%esp
  80123a:	85 c0                	test   %eax,%eax
  80123c:	75 d3                	jne    801211 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	8a 00                	mov    (%eax),%al
  801243:	84 c0                	test   %al,%al
  801245:	74 5a                	je     8012a1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801247:	8b 45 14             	mov    0x14(%ebp),%eax
  80124a:	8b 00                	mov    (%eax),%eax
  80124c:	83 f8 0f             	cmp    $0xf,%eax
  80124f:	75 07                	jne    801258 <strsplit+0x6c>
		{
			return 0;
  801251:	b8 00 00 00 00       	mov    $0x0,%eax
  801256:	eb 66                	jmp    8012be <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801258:	8b 45 14             	mov    0x14(%ebp),%eax
  80125b:	8b 00                	mov    (%eax),%eax
  80125d:	8d 48 01             	lea    0x1(%eax),%ecx
  801260:	8b 55 14             	mov    0x14(%ebp),%edx
  801263:	89 0a                	mov    %ecx,(%edx)
  801265:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80126c:	8b 45 10             	mov    0x10(%ebp),%eax
  80126f:	01 c2                	add    %eax,%edx
  801271:	8b 45 08             	mov    0x8(%ebp),%eax
  801274:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801276:	eb 03                	jmp    80127b <strsplit+0x8f>
			string++;
  801278:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80127b:	8b 45 08             	mov    0x8(%ebp),%eax
  80127e:	8a 00                	mov    (%eax),%al
  801280:	84 c0                	test   %al,%al
  801282:	74 8b                	je     80120f <strsplit+0x23>
  801284:	8b 45 08             	mov    0x8(%ebp),%eax
  801287:	8a 00                	mov    (%eax),%al
  801289:	0f be c0             	movsbl %al,%eax
  80128c:	50                   	push   %eax
  80128d:	ff 75 0c             	pushl  0xc(%ebp)
  801290:	e8 b5 fa ff ff       	call   800d4a <strchr>
  801295:	83 c4 08             	add    $0x8,%esp
  801298:	85 c0                	test   %eax,%eax
  80129a:	74 dc                	je     801278 <strsplit+0x8c>
			string++;
	}
  80129c:	e9 6e ff ff ff       	jmp    80120f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012a1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a5:	8b 00                	mov    (%eax),%eax
  8012a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b1:	01 d0                	add    %edx,%eax
  8012b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012b9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012be:	c9                   	leave  
  8012bf:	c3                   	ret    

008012c0 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
  8012c3:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012c6:	a1 04 40 80 00       	mov    0x804004,%eax
  8012cb:	85 c0                	test   %eax,%eax
  8012cd:	74 1f                	je     8012ee <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012cf:	e8 1d 00 00 00       	call   8012f1 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8012d4:	83 ec 0c             	sub    $0xc,%esp
  8012d7:	68 70 39 80 00       	push   $0x803970
  8012dc:	e8 55 f2 ff ff       	call   800536 <cprintf>
  8012e1:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012e4:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8012eb:	00 00 00 
	}
}
  8012ee:	90                   	nop
  8012ef:	c9                   	leave  
  8012f0:	c3                   	ret    

008012f1 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8012f1:	55                   	push   %ebp
  8012f2:	89 e5                	mov    %esp,%ebp
  8012f4:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  8012f7:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8012fe:	00 00 00 
  801301:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801308:	00 00 00 
  80130b:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801312:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  801315:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80131c:	00 00 00 
  80131f:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801326:	00 00 00 
  801329:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801330:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  801333:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80133a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80133d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801342:	2d 00 10 00 00       	sub    $0x1000,%eax
  801347:	a3 50 40 80 00       	mov    %eax,0x804050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  80134c:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801353:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  801356:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80135d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801360:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  801365:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801368:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80136b:	ba 00 00 00 00       	mov    $0x0,%edx
  801370:	f7 75 f0             	divl   -0x10(%ebp)
  801373:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801376:	29 d0                	sub    %edx,%eax
  801378:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  80137b:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801382:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801385:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80138a:	2d 00 10 00 00       	sub    $0x1000,%eax
  80138f:	83 ec 04             	sub    $0x4,%esp
  801392:	6a 06                	push   $0x6
  801394:	ff 75 e8             	pushl  -0x18(%ebp)
  801397:	50                   	push   %eax
  801398:	e8 d4 05 00 00       	call   801971 <sys_allocate_chunk>
  80139d:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013a0:	a1 20 41 80 00       	mov    0x804120,%eax
  8013a5:	83 ec 0c             	sub    $0xc,%esp
  8013a8:	50                   	push   %eax
  8013a9:	e8 49 0c 00 00       	call   801ff7 <initialize_MemBlocksList>
  8013ae:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  8013b1:	a1 48 41 80 00       	mov    0x804148,%eax
  8013b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  8013b9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013bd:	75 14                	jne    8013d3 <initialize_dyn_block_system+0xe2>
  8013bf:	83 ec 04             	sub    $0x4,%esp
  8013c2:	68 95 39 80 00       	push   $0x803995
  8013c7:	6a 39                	push   $0x39
  8013c9:	68 b3 39 80 00       	push   $0x8039b3
  8013ce:	e8 af ee ff ff       	call   800282 <_panic>
  8013d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013d6:	8b 00                	mov    (%eax),%eax
  8013d8:	85 c0                	test   %eax,%eax
  8013da:	74 10                	je     8013ec <initialize_dyn_block_system+0xfb>
  8013dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013df:	8b 00                	mov    (%eax),%eax
  8013e1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8013e4:	8b 52 04             	mov    0x4(%edx),%edx
  8013e7:	89 50 04             	mov    %edx,0x4(%eax)
  8013ea:	eb 0b                	jmp    8013f7 <initialize_dyn_block_system+0x106>
  8013ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013ef:	8b 40 04             	mov    0x4(%eax),%eax
  8013f2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8013f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013fa:	8b 40 04             	mov    0x4(%eax),%eax
  8013fd:	85 c0                	test   %eax,%eax
  8013ff:	74 0f                	je     801410 <initialize_dyn_block_system+0x11f>
  801401:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801404:	8b 40 04             	mov    0x4(%eax),%eax
  801407:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80140a:	8b 12                	mov    (%edx),%edx
  80140c:	89 10                	mov    %edx,(%eax)
  80140e:	eb 0a                	jmp    80141a <initialize_dyn_block_system+0x129>
  801410:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801413:	8b 00                	mov    (%eax),%eax
  801415:	a3 48 41 80 00       	mov    %eax,0x804148
  80141a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80141d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801423:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801426:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80142d:	a1 54 41 80 00       	mov    0x804154,%eax
  801432:	48                   	dec    %eax
  801433:	a3 54 41 80 00       	mov    %eax,0x804154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  801438:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80143b:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  801442:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801445:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  80144c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801450:	75 14                	jne    801466 <initialize_dyn_block_system+0x175>
  801452:	83 ec 04             	sub    $0x4,%esp
  801455:	68 c0 39 80 00       	push   $0x8039c0
  80145a:	6a 3f                	push   $0x3f
  80145c:	68 b3 39 80 00       	push   $0x8039b3
  801461:	e8 1c ee ff ff       	call   800282 <_panic>
  801466:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80146c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80146f:	89 10                	mov    %edx,(%eax)
  801471:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801474:	8b 00                	mov    (%eax),%eax
  801476:	85 c0                	test   %eax,%eax
  801478:	74 0d                	je     801487 <initialize_dyn_block_system+0x196>
  80147a:	a1 38 41 80 00       	mov    0x804138,%eax
  80147f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801482:	89 50 04             	mov    %edx,0x4(%eax)
  801485:	eb 08                	jmp    80148f <initialize_dyn_block_system+0x19e>
  801487:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80148a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80148f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801492:	a3 38 41 80 00       	mov    %eax,0x804138
  801497:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80149a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014a1:	a1 44 41 80 00       	mov    0x804144,%eax
  8014a6:	40                   	inc    %eax
  8014a7:	a3 44 41 80 00       	mov    %eax,0x804144

}
  8014ac:	90                   	nop
  8014ad:	c9                   	leave  
  8014ae:	c3                   	ret    

008014af <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8014af:	55                   	push   %ebp
  8014b0:	89 e5                	mov    %esp,%ebp
  8014b2:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014b5:	e8 06 fe ff ff       	call   8012c0 <InitializeUHeap>
	if (size == 0) return NULL ;
  8014ba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014be:	75 07                	jne    8014c7 <malloc+0x18>
  8014c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c5:	eb 7d                	jmp    801544 <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  8014c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8014ce:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8014d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8014d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014db:	01 d0                	add    %edx,%eax
  8014dd:	48                   	dec    %eax
  8014de:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8014e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8014e9:	f7 75 f0             	divl   -0x10(%ebp)
  8014ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014ef:	29 d0                	sub    %edx,%eax
  8014f1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  8014f4:	e8 46 08 00 00       	call   801d3f <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014f9:	83 f8 01             	cmp    $0x1,%eax
  8014fc:	75 07                	jne    801505 <malloc+0x56>
  8014fe:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  801505:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  801509:	75 34                	jne    80153f <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  80150b:	83 ec 0c             	sub    $0xc,%esp
  80150e:	ff 75 e8             	pushl  -0x18(%ebp)
  801511:	e8 73 0e 00 00       	call   802389 <alloc_block_FF>
  801516:	83 c4 10             	add    $0x10,%esp
  801519:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  80151c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801520:	74 16                	je     801538 <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  801522:	83 ec 0c             	sub    $0xc,%esp
  801525:	ff 75 e4             	pushl  -0x1c(%ebp)
  801528:	e8 ff 0b 00 00       	call   80212c <insert_sorted_allocList>
  80152d:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  801530:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801533:	8b 40 08             	mov    0x8(%eax),%eax
  801536:	eb 0c                	jmp    801544 <malloc+0x95>
	             }
	             else
	             	return NULL;
  801538:	b8 00 00 00 00       	mov    $0x0,%eax
  80153d:	eb 05                	jmp    801544 <malloc+0x95>
	      	  }
	          else
	               return NULL;
  80153f:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  801544:	c9                   	leave  
  801545:	c3                   	ret    

00801546 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801546:	55                   	push   %ebp
  801547:	89 e5                	mov    %esp,%ebp
  801549:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  80154c:	8b 45 08             	mov    0x8(%ebp),%eax
  80154f:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  801552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801555:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801558:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80155b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801560:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  801563:	83 ec 08             	sub    $0x8,%esp
  801566:	ff 75 f4             	pushl  -0xc(%ebp)
  801569:	68 40 40 80 00       	push   $0x804040
  80156e:	e8 61 0b 00 00       	call   8020d4 <find_block>
  801573:	83 c4 10             	add    $0x10,%esp
  801576:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  801579:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80157d:	0f 84 a5 00 00 00    	je     801628 <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  801583:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801586:	8b 40 0c             	mov    0xc(%eax),%eax
  801589:	83 ec 08             	sub    $0x8,%esp
  80158c:	50                   	push   %eax
  80158d:	ff 75 f4             	pushl  -0xc(%ebp)
  801590:	e8 a4 03 00 00       	call   801939 <sys_free_user_mem>
  801595:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  801598:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80159c:	75 17                	jne    8015b5 <free+0x6f>
  80159e:	83 ec 04             	sub    $0x4,%esp
  8015a1:	68 95 39 80 00       	push   $0x803995
  8015a6:	68 87 00 00 00       	push   $0x87
  8015ab:	68 b3 39 80 00       	push   $0x8039b3
  8015b0:	e8 cd ec ff ff       	call   800282 <_panic>
  8015b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015b8:	8b 00                	mov    (%eax),%eax
  8015ba:	85 c0                	test   %eax,%eax
  8015bc:	74 10                	je     8015ce <free+0x88>
  8015be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015c1:	8b 00                	mov    (%eax),%eax
  8015c3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015c6:	8b 52 04             	mov    0x4(%edx),%edx
  8015c9:	89 50 04             	mov    %edx,0x4(%eax)
  8015cc:	eb 0b                	jmp    8015d9 <free+0x93>
  8015ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015d1:	8b 40 04             	mov    0x4(%eax),%eax
  8015d4:	a3 44 40 80 00       	mov    %eax,0x804044
  8015d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015dc:	8b 40 04             	mov    0x4(%eax),%eax
  8015df:	85 c0                	test   %eax,%eax
  8015e1:	74 0f                	je     8015f2 <free+0xac>
  8015e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015e6:	8b 40 04             	mov    0x4(%eax),%eax
  8015e9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015ec:	8b 12                	mov    (%edx),%edx
  8015ee:	89 10                	mov    %edx,(%eax)
  8015f0:	eb 0a                	jmp    8015fc <free+0xb6>
  8015f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015f5:	8b 00                	mov    (%eax),%eax
  8015f7:	a3 40 40 80 00       	mov    %eax,0x804040
  8015fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801605:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801608:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80160f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801614:	48                   	dec    %eax
  801615:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(theBlock);
  80161a:	83 ec 0c             	sub    $0xc,%esp
  80161d:	ff 75 ec             	pushl  -0x14(%ebp)
  801620:	e8 37 12 00 00       	call   80285c <insert_sorted_with_merge_freeList>
  801625:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  801628:	90                   	nop
  801629:	c9                   	leave  
  80162a:	c3                   	ret    

0080162b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80162b:	55                   	push   %ebp
  80162c:	89 e5                	mov    %esp,%ebp
  80162e:	83 ec 38             	sub    $0x38,%esp
  801631:	8b 45 10             	mov    0x10(%ebp),%eax
  801634:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801637:	e8 84 fc ff ff       	call   8012c0 <InitializeUHeap>
	if (size == 0) return NULL ;
  80163c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801640:	75 07                	jne    801649 <smalloc+0x1e>
  801642:	b8 00 00 00 00       	mov    $0x0,%eax
  801647:	eb 7e                	jmp    8016c7 <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  801649:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801650:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801657:	8b 55 0c             	mov    0xc(%ebp),%edx
  80165a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80165d:	01 d0                	add    %edx,%eax
  80165f:	48                   	dec    %eax
  801660:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801663:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801666:	ba 00 00 00 00       	mov    $0x0,%edx
  80166b:	f7 75 f0             	divl   -0x10(%ebp)
  80166e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801671:	29 d0                	sub    %edx,%eax
  801673:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801676:	e8 c4 06 00 00       	call   801d3f <sys_isUHeapPlacementStrategyFIRSTFIT>
  80167b:	83 f8 01             	cmp    $0x1,%eax
  80167e:	75 42                	jne    8016c2 <smalloc+0x97>

		  va = malloc(newsize) ;
  801680:	83 ec 0c             	sub    $0xc,%esp
  801683:	ff 75 e8             	pushl  -0x18(%ebp)
  801686:	e8 24 fe ff ff       	call   8014af <malloc>
  80168b:	83 c4 10             	add    $0x10,%esp
  80168e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  801691:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801695:	74 24                	je     8016bb <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  801697:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80169b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80169e:	50                   	push   %eax
  80169f:	ff 75 e8             	pushl  -0x18(%ebp)
  8016a2:	ff 75 08             	pushl  0x8(%ebp)
  8016a5:	e8 1a 04 00 00       	call   801ac4 <sys_createSharedObject>
  8016aa:	83 c4 10             	add    $0x10,%esp
  8016ad:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  8016b0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8016b4:	78 0c                	js     8016c2 <smalloc+0x97>
					  return va ;
  8016b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016b9:	eb 0c                	jmp    8016c7 <smalloc+0x9c>
				 }
				 else
					return NULL;
  8016bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c0:	eb 05                	jmp    8016c7 <smalloc+0x9c>
	  }
		  return NULL ;
  8016c2:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016c7:	c9                   	leave  
  8016c8:	c3                   	ret    

008016c9 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
  8016cc:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016cf:	e8 ec fb ff ff       	call   8012c0 <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  8016d4:	83 ec 08             	sub    $0x8,%esp
  8016d7:	ff 75 0c             	pushl  0xc(%ebp)
  8016da:	ff 75 08             	pushl  0x8(%ebp)
  8016dd:	e8 0c 04 00 00       	call   801aee <sys_getSizeOfSharedObject>
  8016e2:	83 c4 10             	add    $0x10,%esp
  8016e5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  8016e8:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8016ec:	75 07                	jne    8016f5 <sget+0x2c>
  8016ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f3:	eb 75                	jmp    80176a <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8016f5:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8016fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801702:	01 d0                	add    %edx,%eax
  801704:	48                   	dec    %eax
  801705:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801708:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80170b:	ba 00 00 00 00       	mov    $0x0,%edx
  801710:	f7 75 f0             	divl   -0x10(%ebp)
  801713:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801716:	29 d0                	sub    %edx,%eax
  801718:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  80171b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801722:	e8 18 06 00 00       	call   801d3f <sys_isUHeapPlacementStrategyFIRSTFIT>
  801727:	83 f8 01             	cmp    $0x1,%eax
  80172a:	75 39                	jne    801765 <sget+0x9c>

		  va = malloc(newsize) ;
  80172c:	83 ec 0c             	sub    $0xc,%esp
  80172f:	ff 75 e8             	pushl  -0x18(%ebp)
  801732:	e8 78 fd ff ff       	call   8014af <malloc>
  801737:	83 c4 10             	add    $0x10,%esp
  80173a:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  80173d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801741:	74 22                	je     801765 <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  801743:	83 ec 04             	sub    $0x4,%esp
  801746:	ff 75 e0             	pushl  -0x20(%ebp)
  801749:	ff 75 0c             	pushl  0xc(%ebp)
  80174c:	ff 75 08             	pushl  0x8(%ebp)
  80174f:	e8 b7 03 00 00       	call   801b0b <sys_getSharedObject>
  801754:	83 c4 10             	add    $0x10,%esp
  801757:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  80175a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80175e:	78 05                	js     801765 <sget+0x9c>
					  return va;
  801760:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801763:	eb 05                	jmp    80176a <sget+0xa1>
				  }
			  }
     }
         return NULL;
  801765:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  80176a:	c9                   	leave  
  80176b:	c3                   	ret    

0080176c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
  80176f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801772:	e8 49 fb ff ff       	call   8012c0 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801777:	83 ec 04             	sub    $0x4,%esp
  80177a:	68 e4 39 80 00       	push   $0x8039e4
  80177f:	68 1e 01 00 00       	push   $0x11e
  801784:	68 b3 39 80 00       	push   $0x8039b3
  801789:	e8 f4 ea ff ff       	call   800282 <_panic>

0080178e <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80178e:	55                   	push   %ebp
  80178f:	89 e5                	mov    %esp,%ebp
  801791:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801794:	83 ec 04             	sub    $0x4,%esp
  801797:	68 0c 3a 80 00       	push   $0x803a0c
  80179c:	68 32 01 00 00       	push   $0x132
  8017a1:	68 b3 39 80 00       	push   $0x8039b3
  8017a6:	e8 d7 ea ff ff       	call   800282 <_panic>

008017ab <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017ab:	55                   	push   %ebp
  8017ac:	89 e5                	mov    %esp,%ebp
  8017ae:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017b1:	83 ec 04             	sub    $0x4,%esp
  8017b4:	68 30 3a 80 00       	push   $0x803a30
  8017b9:	68 3d 01 00 00       	push   $0x13d
  8017be:	68 b3 39 80 00       	push   $0x8039b3
  8017c3:	e8 ba ea ff ff       	call   800282 <_panic>

008017c8 <shrink>:

}
void shrink(uint32 newSize)
{
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
  8017cb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017ce:	83 ec 04             	sub    $0x4,%esp
  8017d1:	68 30 3a 80 00       	push   $0x803a30
  8017d6:	68 42 01 00 00       	push   $0x142
  8017db:	68 b3 39 80 00       	push   $0x8039b3
  8017e0:	e8 9d ea ff ff       	call   800282 <_panic>

008017e5 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017e5:	55                   	push   %ebp
  8017e6:	89 e5                	mov    %esp,%ebp
  8017e8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017eb:	83 ec 04             	sub    $0x4,%esp
  8017ee:	68 30 3a 80 00       	push   $0x803a30
  8017f3:	68 47 01 00 00       	push   $0x147
  8017f8:	68 b3 39 80 00       	push   $0x8039b3
  8017fd:	e8 80 ea ff ff       	call   800282 <_panic>

00801802 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801802:	55                   	push   %ebp
  801803:	89 e5                	mov    %esp,%ebp
  801805:	57                   	push   %edi
  801806:	56                   	push   %esi
  801807:	53                   	push   %ebx
  801808:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80180b:	8b 45 08             	mov    0x8(%ebp),%eax
  80180e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801811:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801814:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801817:	8b 7d 18             	mov    0x18(%ebp),%edi
  80181a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80181d:	cd 30                	int    $0x30
  80181f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801822:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801825:	83 c4 10             	add    $0x10,%esp
  801828:	5b                   	pop    %ebx
  801829:	5e                   	pop    %esi
  80182a:	5f                   	pop    %edi
  80182b:	5d                   	pop    %ebp
  80182c:	c3                   	ret    

0080182d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80182d:	55                   	push   %ebp
  80182e:	89 e5                	mov    %esp,%ebp
  801830:	83 ec 04             	sub    $0x4,%esp
  801833:	8b 45 10             	mov    0x10(%ebp),%eax
  801836:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801839:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80183d:	8b 45 08             	mov    0x8(%ebp),%eax
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	52                   	push   %edx
  801845:	ff 75 0c             	pushl  0xc(%ebp)
  801848:	50                   	push   %eax
  801849:	6a 00                	push   $0x0
  80184b:	e8 b2 ff ff ff       	call   801802 <syscall>
  801850:	83 c4 18             	add    $0x18,%esp
}
  801853:	90                   	nop
  801854:	c9                   	leave  
  801855:	c3                   	ret    

00801856 <sys_cgetc>:

int
sys_cgetc(void)
{
  801856:	55                   	push   %ebp
  801857:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	6a 01                	push   $0x1
  801865:	e8 98 ff ff ff       	call   801802 <syscall>
  80186a:	83 c4 18             	add    $0x18,%esp
}
  80186d:	c9                   	leave  
  80186e:	c3                   	ret    

0080186f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801872:	8b 55 0c             	mov    0xc(%ebp),%edx
  801875:	8b 45 08             	mov    0x8(%ebp),%eax
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	52                   	push   %edx
  80187f:	50                   	push   %eax
  801880:	6a 05                	push   $0x5
  801882:	e8 7b ff ff ff       	call   801802 <syscall>
  801887:	83 c4 18             	add    $0x18,%esp
}
  80188a:	c9                   	leave  
  80188b:	c3                   	ret    

0080188c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
  80188f:	56                   	push   %esi
  801890:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801891:	8b 75 18             	mov    0x18(%ebp),%esi
  801894:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801897:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80189a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189d:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a0:	56                   	push   %esi
  8018a1:	53                   	push   %ebx
  8018a2:	51                   	push   %ecx
  8018a3:	52                   	push   %edx
  8018a4:	50                   	push   %eax
  8018a5:	6a 06                	push   $0x6
  8018a7:	e8 56 ff ff ff       	call   801802 <syscall>
  8018ac:	83 c4 18             	add    $0x18,%esp
}
  8018af:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018b2:	5b                   	pop    %ebx
  8018b3:	5e                   	pop    %esi
  8018b4:	5d                   	pop    %ebp
  8018b5:	c3                   	ret    

008018b6 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	52                   	push   %edx
  8018c6:	50                   	push   %eax
  8018c7:	6a 07                	push   $0x7
  8018c9:	e8 34 ff ff ff       	call   801802 <syscall>
  8018ce:	83 c4 18             	add    $0x18,%esp
}
  8018d1:	c9                   	leave  
  8018d2:	c3                   	ret    

008018d3 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018d3:	55                   	push   %ebp
  8018d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	ff 75 0c             	pushl  0xc(%ebp)
  8018df:	ff 75 08             	pushl  0x8(%ebp)
  8018e2:	6a 08                	push   $0x8
  8018e4:	e8 19 ff ff ff       	call   801802 <syscall>
  8018e9:	83 c4 18             	add    $0x18,%esp
}
  8018ec:	c9                   	leave  
  8018ed:	c3                   	ret    

008018ee <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018ee:	55                   	push   %ebp
  8018ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 09                	push   $0x9
  8018fd:	e8 00 ff ff ff       	call   801802 <syscall>
  801902:	83 c4 18             	add    $0x18,%esp
}
  801905:	c9                   	leave  
  801906:	c3                   	ret    

00801907 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801907:	55                   	push   %ebp
  801908:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 0a                	push   $0xa
  801916:	e8 e7 fe ff ff       	call   801802 <syscall>
  80191b:	83 c4 18             	add    $0x18,%esp
}
  80191e:	c9                   	leave  
  80191f:	c3                   	ret    

00801920 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 0b                	push   $0xb
  80192f:	e8 ce fe ff ff       	call   801802 <syscall>
  801934:	83 c4 18             	add    $0x18,%esp
}
  801937:	c9                   	leave  
  801938:	c3                   	ret    

00801939 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801939:	55                   	push   %ebp
  80193a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	ff 75 0c             	pushl  0xc(%ebp)
  801945:	ff 75 08             	pushl  0x8(%ebp)
  801948:	6a 0f                	push   $0xf
  80194a:	e8 b3 fe ff ff       	call   801802 <syscall>
  80194f:	83 c4 18             	add    $0x18,%esp
	return;
  801952:	90                   	nop
}
  801953:	c9                   	leave  
  801954:	c3                   	ret    

00801955 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801955:	55                   	push   %ebp
  801956:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	ff 75 0c             	pushl  0xc(%ebp)
  801961:	ff 75 08             	pushl  0x8(%ebp)
  801964:	6a 10                	push   $0x10
  801966:	e8 97 fe ff ff       	call   801802 <syscall>
  80196b:	83 c4 18             	add    $0x18,%esp
	return ;
  80196e:	90                   	nop
}
  80196f:	c9                   	leave  
  801970:	c3                   	ret    

00801971 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801971:	55                   	push   %ebp
  801972:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	ff 75 10             	pushl  0x10(%ebp)
  80197b:	ff 75 0c             	pushl  0xc(%ebp)
  80197e:	ff 75 08             	pushl  0x8(%ebp)
  801981:	6a 11                	push   $0x11
  801983:	e8 7a fe ff ff       	call   801802 <syscall>
  801988:	83 c4 18             	add    $0x18,%esp
	return ;
  80198b:	90                   	nop
}
  80198c:	c9                   	leave  
  80198d:	c3                   	ret    

0080198e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80198e:	55                   	push   %ebp
  80198f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 0c                	push   $0xc
  80199d:	e8 60 fe ff ff       	call   801802 <syscall>
  8019a2:	83 c4 18             	add    $0x18,%esp
}
  8019a5:	c9                   	leave  
  8019a6:	c3                   	ret    

008019a7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019a7:	55                   	push   %ebp
  8019a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	ff 75 08             	pushl  0x8(%ebp)
  8019b5:	6a 0d                	push   $0xd
  8019b7:	e8 46 fe ff ff       	call   801802 <syscall>
  8019bc:	83 c4 18             	add    $0x18,%esp
}
  8019bf:	c9                   	leave  
  8019c0:	c3                   	ret    

008019c1 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019c1:	55                   	push   %ebp
  8019c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 0e                	push   $0xe
  8019d0:	e8 2d fe ff ff       	call   801802 <syscall>
  8019d5:	83 c4 18             	add    $0x18,%esp
}
  8019d8:	90                   	nop
  8019d9:	c9                   	leave  
  8019da:	c3                   	ret    

008019db <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 13                	push   $0x13
  8019ea:	e8 13 fe ff ff       	call   801802 <syscall>
  8019ef:	83 c4 18             	add    $0x18,%esp
}
  8019f2:	90                   	nop
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    

008019f5 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 14                	push   $0x14
  801a04:	e8 f9 fd ff ff       	call   801802 <syscall>
  801a09:	83 c4 18             	add    $0x18,%esp
}
  801a0c:	90                   	nop
  801a0d:	c9                   	leave  
  801a0e:	c3                   	ret    

00801a0f <sys_cputc>:


void
sys_cputc(const char c)
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
  801a12:	83 ec 04             	sub    $0x4,%esp
  801a15:	8b 45 08             	mov    0x8(%ebp),%eax
  801a18:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a1b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	50                   	push   %eax
  801a28:	6a 15                	push   $0x15
  801a2a:	e8 d3 fd ff ff       	call   801802 <syscall>
  801a2f:	83 c4 18             	add    $0x18,%esp
}
  801a32:	90                   	nop
  801a33:	c9                   	leave  
  801a34:	c3                   	ret    

00801a35 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a35:	55                   	push   %ebp
  801a36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	6a 16                	push   $0x16
  801a44:	e8 b9 fd ff ff       	call   801802 <syscall>
  801a49:	83 c4 18             	add    $0x18,%esp
}
  801a4c:	90                   	nop
  801a4d:	c9                   	leave  
  801a4e:	c3                   	ret    

00801a4f <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a4f:	55                   	push   %ebp
  801a50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a52:	8b 45 08             	mov    0x8(%ebp),%eax
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	ff 75 0c             	pushl  0xc(%ebp)
  801a5e:	50                   	push   %eax
  801a5f:	6a 17                	push   $0x17
  801a61:	e8 9c fd ff ff       	call   801802 <syscall>
  801a66:	83 c4 18             	add    $0x18,%esp
}
  801a69:	c9                   	leave  
  801a6a:	c3                   	ret    

00801a6b <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a6b:	55                   	push   %ebp
  801a6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a71:	8b 45 08             	mov    0x8(%ebp),%eax
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	52                   	push   %edx
  801a7b:	50                   	push   %eax
  801a7c:	6a 1a                	push   $0x1a
  801a7e:	e8 7f fd ff ff       	call   801802 <syscall>
  801a83:	83 c4 18             	add    $0x18,%esp
}
  801a86:	c9                   	leave  
  801a87:	c3                   	ret    

00801a88 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	52                   	push   %edx
  801a98:	50                   	push   %eax
  801a99:	6a 18                	push   $0x18
  801a9b:	e8 62 fd ff ff       	call   801802 <syscall>
  801aa0:	83 c4 18             	add    $0x18,%esp
}
  801aa3:	90                   	nop
  801aa4:	c9                   	leave  
  801aa5:	c3                   	ret    

00801aa6 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801aa9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aac:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	52                   	push   %edx
  801ab6:	50                   	push   %eax
  801ab7:	6a 19                	push   $0x19
  801ab9:	e8 44 fd ff ff       	call   801802 <syscall>
  801abe:	83 c4 18             	add    $0x18,%esp
}
  801ac1:	90                   	nop
  801ac2:	c9                   	leave  
  801ac3:	c3                   	ret    

00801ac4 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ac4:	55                   	push   %ebp
  801ac5:	89 e5                	mov    %esp,%ebp
  801ac7:	83 ec 04             	sub    $0x4,%esp
  801aca:	8b 45 10             	mov    0x10(%ebp),%eax
  801acd:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ad0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ad3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ada:	6a 00                	push   $0x0
  801adc:	51                   	push   %ecx
  801add:	52                   	push   %edx
  801ade:	ff 75 0c             	pushl  0xc(%ebp)
  801ae1:	50                   	push   %eax
  801ae2:	6a 1b                	push   $0x1b
  801ae4:	e8 19 fd ff ff       	call   801802 <syscall>
  801ae9:	83 c4 18             	add    $0x18,%esp
}
  801aec:	c9                   	leave  
  801aed:	c3                   	ret    

00801aee <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801af1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af4:	8b 45 08             	mov    0x8(%ebp),%eax
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	52                   	push   %edx
  801afe:	50                   	push   %eax
  801aff:	6a 1c                	push   $0x1c
  801b01:	e8 fc fc ff ff       	call   801802 <syscall>
  801b06:	83 c4 18             	add    $0x18,%esp
}
  801b09:	c9                   	leave  
  801b0a:	c3                   	ret    

00801b0b <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b0e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b11:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b14:	8b 45 08             	mov    0x8(%ebp),%eax
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	51                   	push   %ecx
  801b1c:	52                   	push   %edx
  801b1d:	50                   	push   %eax
  801b1e:	6a 1d                	push   $0x1d
  801b20:	e8 dd fc ff ff       	call   801802 <syscall>
  801b25:	83 c4 18             	add    $0x18,%esp
}
  801b28:	c9                   	leave  
  801b29:	c3                   	ret    

00801b2a <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b2a:	55                   	push   %ebp
  801b2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b30:	8b 45 08             	mov    0x8(%ebp),%eax
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	52                   	push   %edx
  801b3a:	50                   	push   %eax
  801b3b:	6a 1e                	push   $0x1e
  801b3d:	e8 c0 fc ff ff       	call   801802 <syscall>
  801b42:	83 c4 18             	add    $0x18,%esp
}
  801b45:	c9                   	leave  
  801b46:	c3                   	ret    

00801b47 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b47:	55                   	push   %ebp
  801b48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 1f                	push   $0x1f
  801b56:	e8 a7 fc ff ff       	call   801802 <syscall>
  801b5b:	83 c4 18             	add    $0x18,%esp
}
  801b5e:	c9                   	leave  
  801b5f:	c3                   	ret    

00801b60 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b63:	8b 45 08             	mov    0x8(%ebp),%eax
  801b66:	6a 00                	push   $0x0
  801b68:	ff 75 14             	pushl  0x14(%ebp)
  801b6b:	ff 75 10             	pushl  0x10(%ebp)
  801b6e:	ff 75 0c             	pushl  0xc(%ebp)
  801b71:	50                   	push   %eax
  801b72:	6a 20                	push   $0x20
  801b74:	e8 89 fc ff ff       	call   801802 <syscall>
  801b79:	83 c4 18             	add    $0x18,%esp
}
  801b7c:	c9                   	leave  
  801b7d:	c3                   	ret    

00801b7e <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b81:	8b 45 08             	mov    0x8(%ebp),%eax
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	50                   	push   %eax
  801b8d:	6a 21                	push   $0x21
  801b8f:	e8 6e fc ff ff       	call   801802 <syscall>
  801b94:	83 c4 18             	add    $0x18,%esp
}
  801b97:	90                   	nop
  801b98:	c9                   	leave  
  801b99:	c3                   	ret    

00801b9a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b9a:	55                   	push   %ebp
  801b9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	50                   	push   %eax
  801ba9:	6a 22                	push   $0x22
  801bab:	e8 52 fc ff ff       	call   801802 <syscall>
  801bb0:	83 c4 18             	add    $0x18,%esp
}
  801bb3:	c9                   	leave  
  801bb4:	c3                   	ret    

00801bb5 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bb5:	55                   	push   %ebp
  801bb6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 02                	push   $0x2
  801bc4:	e8 39 fc ff ff       	call   801802 <syscall>
  801bc9:	83 c4 18             	add    $0x18,%esp
}
  801bcc:	c9                   	leave  
  801bcd:	c3                   	ret    

00801bce <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bce:	55                   	push   %ebp
  801bcf:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 03                	push   $0x3
  801bdd:	e8 20 fc ff ff       	call   801802 <syscall>
  801be2:	83 c4 18             	add    $0x18,%esp
}
  801be5:	c9                   	leave  
  801be6:	c3                   	ret    

00801be7 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801be7:	55                   	push   %ebp
  801be8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 04                	push   $0x4
  801bf6:	e8 07 fc ff ff       	call   801802 <syscall>
  801bfb:	83 c4 18             	add    $0x18,%esp
}
  801bfe:	c9                   	leave  
  801bff:	c3                   	ret    

00801c00 <sys_exit_env>:


void sys_exit_env(void)
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 23                	push   $0x23
  801c0f:	e8 ee fb ff ff       	call   801802 <syscall>
  801c14:	83 c4 18             	add    $0x18,%esp
}
  801c17:	90                   	nop
  801c18:	c9                   	leave  
  801c19:	c3                   	ret    

00801c1a <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c1a:	55                   	push   %ebp
  801c1b:	89 e5                	mov    %esp,%ebp
  801c1d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c20:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c23:	8d 50 04             	lea    0x4(%eax),%edx
  801c26:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	52                   	push   %edx
  801c30:	50                   	push   %eax
  801c31:	6a 24                	push   $0x24
  801c33:	e8 ca fb ff ff       	call   801802 <syscall>
  801c38:	83 c4 18             	add    $0x18,%esp
	return result;
  801c3b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c3e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c41:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c44:	89 01                	mov    %eax,(%ecx)
  801c46:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c49:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4c:	c9                   	leave  
  801c4d:	c2 04 00             	ret    $0x4

00801c50 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	ff 75 10             	pushl  0x10(%ebp)
  801c5a:	ff 75 0c             	pushl  0xc(%ebp)
  801c5d:	ff 75 08             	pushl  0x8(%ebp)
  801c60:	6a 12                	push   $0x12
  801c62:	e8 9b fb ff ff       	call   801802 <syscall>
  801c67:	83 c4 18             	add    $0x18,%esp
	return ;
  801c6a:	90                   	nop
}
  801c6b:	c9                   	leave  
  801c6c:	c3                   	ret    

00801c6d <sys_rcr2>:
uint32 sys_rcr2()
{
  801c6d:	55                   	push   %ebp
  801c6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 25                	push   $0x25
  801c7c:	e8 81 fb ff ff       	call   801802 <syscall>
  801c81:	83 c4 18             	add    $0x18,%esp
}
  801c84:	c9                   	leave  
  801c85:	c3                   	ret    

00801c86 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c86:	55                   	push   %ebp
  801c87:	89 e5                	mov    %esp,%ebp
  801c89:	83 ec 04             	sub    $0x4,%esp
  801c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c92:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	50                   	push   %eax
  801c9f:	6a 26                	push   $0x26
  801ca1:	e8 5c fb ff ff       	call   801802 <syscall>
  801ca6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca9:	90                   	nop
}
  801caa:	c9                   	leave  
  801cab:	c3                   	ret    

00801cac <rsttst>:
void rsttst()
{
  801cac:	55                   	push   %ebp
  801cad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 28                	push   $0x28
  801cbb:	e8 42 fb ff ff       	call   801802 <syscall>
  801cc0:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc3:	90                   	nop
}
  801cc4:	c9                   	leave  
  801cc5:	c3                   	ret    

00801cc6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cc6:	55                   	push   %ebp
  801cc7:	89 e5                	mov    %esp,%ebp
  801cc9:	83 ec 04             	sub    $0x4,%esp
  801ccc:	8b 45 14             	mov    0x14(%ebp),%eax
  801ccf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cd2:	8b 55 18             	mov    0x18(%ebp),%edx
  801cd5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cd9:	52                   	push   %edx
  801cda:	50                   	push   %eax
  801cdb:	ff 75 10             	pushl  0x10(%ebp)
  801cde:	ff 75 0c             	pushl  0xc(%ebp)
  801ce1:	ff 75 08             	pushl  0x8(%ebp)
  801ce4:	6a 27                	push   $0x27
  801ce6:	e8 17 fb ff ff       	call   801802 <syscall>
  801ceb:	83 c4 18             	add    $0x18,%esp
	return ;
  801cee:	90                   	nop
}
  801cef:	c9                   	leave  
  801cf0:	c3                   	ret    

00801cf1 <chktst>:
void chktst(uint32 n)
{
  801cf1:	55                   	push   %ebp
  801cf2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	ff 75 08             	pushl  0x8(%ebp)
  801cff:	6a 29                	push   $0x29
  801d01:	e8 fc fa ff ff       	call   801802 <syscall>
  801d06:	83 c4 18             	add    $0x18,%esp
	return ;
  801d09:	90                   	nop
}
  801d0a:	c9                   	leave  
  801d0b:	c3                   	ret    

00801d0c <inctst>:

void inctst()
{
  801d0c:	55                   	push   %ebp
  801d0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 2a                	push   $0x2a
  801d1b:	e8 e2 fa ff ff       	call   801802 <syscall>
  801d20:	83 c4 18             	add    $0x18,%esp
	return ;
  801d23:	90                   	nop
}
  801d24:	c9                   	leave  
  801d25:	c3                   	ret    

00801d26 <gettst>:
uint32 gettst()
{
  801d26:	55                   	push   %ebp
  801d27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	6a 2b                	push   $0x2b
  801d35:	e8 c8 fa ff ff       	call   801802 <syscall>
  801d3a:	83 c4 18             	add    $0x18,%esp
}
  801d3d:	c9                   	leave  
  801d3e:	c3                   	ret    

00801d3f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
  801d42:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 2c                	push   $0x2c
  801d51:	e8 ac fa ff ff       	call   801802 <syscall>
  801d56:	83 c4 18             	add    $0x18,%esp
  801d59:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d5c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d60:	75 07                	jne    801d69 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d62:	b8 01 00 00 00       	mov    $0x1,%eax
  801d67:	eb 05                	jmp    801d6e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d69:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d6e:	c9                   	leave  
  801d6f:	c3                   	ret    

00801d70 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d70:	55                   	push   %ebp
  801d71:	89 e5                	mov    %esp,%ebp
  801d73:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 2c                	push   $0x2c
  801d82:	e8 7b fa ff ff       	call   801802 <syscall>
  801d87:	83 c4 18             	add    $0x18,%esp
  801d8a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d8d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d91:	75 07                	jne    801d9a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d93:	b8 01 00 00 00       	mov    $0x1,%eax
  801d98:	eb 05                	jmp    801d9f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d9f:	c9                   	leave  
  801da0:	c3                   	ret    

00801da1 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801da1:	55                   	push   %ebp
  801da2:	89 e5                	mov    %esp,%ebp
  801da4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 2c                	push   $0x2c
  801db3:	e8 4a fa ff ff       	call   801802 <syscall>
  801db8:	83 c4 18             	add    $0x18,%esp
  801dbb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801dbe:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801dc2:	75 07                	jne    801dcb <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801dc4:	b8 01 00 00 00       	mov    $0x1,%eax
  801dc9:	eb 05                	jmp    801dd0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801dcb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dd0:	c9                   	leave  
  801dd1:	c3                   	ret    

00801dd2 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801dd2:	55                   	push   %ebp
  801dd3:	89 e5                	mov    %esp,%ebp
  801dd5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 2c                	push   $0x2c
  801de4:	e8 19 fa ff ff       	call   801802 <syscall>
  801de9:	83 c4 18             	add    $0x18,%esp
  801dec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801def:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801df3:	75 07                	jne    801dfc <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801df5:	b8 01 00 00 00       	mov    $0x1,%eax
  801dfa:	eb 05                	jmp    801e01 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801dfc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e01:	c9                   	leave  
  801e02:	c3                   	ret    

00801e03 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e03:	55                   	push   %ebp
  801e04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	ff 75 08             	pushl  0x8(%ebp)
  801e11:	6a 2d                	push   $0x2d
  801e13:	e8 ea f9 ff ff       	call   801802 <syscall>
  801e18:	83 c4 18             	add    $0x18,%esp
	return ;
  801e1b:	90                   	nop
}
  801e1c:	c9                   	leave  
  801e1d:	c3                   	ret    

00801e1e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e1e:	55                   	push   %ebp
  801e1f:	89 e5                	mov    %esp,%ebp
  801e21:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e22:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e25:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e28:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2e:	6a 00                	push   $0x0
  801e30:	53                   	push   %ebx
  801e31:	51                   	push   %ecx
  801e32:	52                   	push   %edx
  801e33:	50                   	push   %eax
  801e34:	6a 2e                	push   $0x2e
  801e36:	e8 c7 f9 ff ff       	call   801802 <syscall>
  801e3b:	83 c4 18             	add    $0x18,%esp
}
  801e3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e41:	c9                   	leave  
  801e42:	c3                   	ret    

00801e43 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e43:	55                   	push   %ebp
  801e44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e46:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e49:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 00                	push   $0x0
  801e52:	52                   	push   %edx
  801e53:	50                   	push   %eax
  801e54:	6a 2f                	push   $0x2f
  801e56:	e8 a7 f9 ff ff       	call   801802 <syscall>
  801e5b:	83 c4 18             	add    $0x18,%esp
}
  801e5e:	c9                   	leave  
  801e5f:	c3                   	ret    

00801e60 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e60:	55                   	push   %ebp
  801e61:	89 e5                	mov    %esp,%ebp
  801e63:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e66:	83 ec 0c             	sub    $0xc,%esp
  801e69:	68 40 3a 80 00       	push   $0x803a40
  801e6e:	e8 c3 e6 ff ff       	call   800536 <cprintf>
  801e73:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e76:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e7d:	83 ec 0c             	sub    $0xc,%esp
  801e80:	68 6c 3a 80 00       	push   $0x803a6c
  801e85:	e8 ac e6 ff ff       	call   800536 <cprintf>
  801e8a:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e8d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e91:	a1 38 41 80 00       	mov    0x804138,%eax
  801e96:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e99:	eb 56                	jmp    801ef1 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e9b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e9f:	74 1c                	je     801ebd <print_mem_block_lists+0x5d>
  801ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea4:	8b 50 08             	mov    0x8(%eax),%edx
  801ea7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eaa:	8b 48 08             	mov    0x8(%eax),%ecx
  801ead:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eb0:	8b 40 0c             	mov    0xc(%eax),%eax
  801eb3:	01 c8                	add    %ecx,%eax
  801eb5:	39 c2                	cmp    %eax,%edx
  801eb7:	73 04                	jae    801ebd <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801eb9:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec0:	8b 50 08             	mov    0x8(%eax),%edx
  801ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec6:	8b 40 0c             	mov    0xc(%eax),%eax
  801ec9:	01 c2                	add    %eax,%edx
  801ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ece:	8b 40 08             	mov    0x8(%eax),%eax
  801ed1:	83 ec 04             	sub    $0x4,%esp
  801ed4:	52                   	push   %edx
  801ed5:	50                   	push   %eax
  801ed6:	68 81 3a 80 00       	push   $0x803a81
  801edb:	e8 56 e6 ff ff       	call   800536 <cprintf>
  801ee0:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ee9:	a1 40 41 80 00       	mov    0x804140,%eax
  801eee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ef1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ef5:	74 07                	je     801efe <print_mem_block_lists+0x9e>
  801ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efa:	8b 00                	mov    (%eax),%eax
  801efc:	eb 05                	jmp    801f03 <print_mem_block_lists+0xa3>
  801efe:	b8 00 00 00 00       	mov    $0x0,%eax
  801f03:	a3 40 41 80 00       	mov    %eax,0x804140
  801f08:	a1 40 41 80 00       	mov    0x804140,%eax
  801f0d:	85 c0                	test   %eax,%eax
  801f0f:	75 8a                	jne    801e9b <print_mem_block_lists+0x3b>
  801f11:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f15:	75 84                	jne    801e9b <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f17:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f1b:	75 10                	jne    801f2d <print_mem_block_lists+0xcd>
  801f1d:	83 ec 0c             	sub    $0xc,%esp
  801f20:	68 90 3a 80 00       	push   $0x803a90
  801f25:	e8 0c e6 ff ff       	call   800536 <cprintf>
  801f2a:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f2d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f34:	83 ec 0c             	sub    $0xc,%esp
  801f37:	68 b4 3a 80 00       	push   $0x803ab4
  801f3c:	e8 f5 e5 ff ff       	call   800536 <cprintf>
  801f41:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f44:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f48:	a1 40 40 80 00       	mov    0x804040,%eax
  801f4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f50:	eb 56                	jmp    801fa8 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f52:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f56:	74 1c                	je     801f74 <print_mem_block_lists+0x114>
  801f58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5b:	8b 50 08             	mov    0x8(%eax),%edx
  801f5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f61:	8b 48 08             	mov    0x8(%eax),%ecx
  801f64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f67:	8b 40 0c             	mov    0xc(%eax),%eax
  801f6a:	01 c8                	add    %ecx,%eax
  801f6c:	39 c2                	cmp    %eax,%edx
  801f6e:	73 04                	jae    801f74 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f70:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f77:	8b 50 08             	mov    0x8(%eax),%edx
  801f7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7d:	8b 40 0c             	mov    0xc(%eax),%eax
  801f80:	01 c2                	add    %eax,%edx
  801f82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f85:	8b 40 08             	mov    0x8(%eax),%eax
  801f88:	83 ec 04             	sub    $0x4,%esp
  801f8b:	52                   	push   %edx
  801f8c:	50                   	push   %eax
  801f8d:	68 81 3a 80 00       	push   $0x803a81
  801f92:	e8 9f e5 ff ff       	call   800536 <cprintf>
  801f97:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fa0:	a1 48 40 80 00       	mov    0x804048,%eax
  801fa5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fa8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fac:	74 07                	je     801fb5 <print_mem_block_lists+0x155>
  801fae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb1:	8b 00                	mov    (%eax),%eax
  801fb3:	eb 05                	jmp    801fba <print_mem_block_lists+0x15a>
  801fb5:	b8 00 00 00 00       	mov    $0x0,%eax
  801fba:	a3 48 40 80 00       	mov    %eax,0x804048
  801fbf:	a1 48 40 80 00       	mov    0x804048,%eax
  801fc4:	85 c0                	test   %eax,%eax
  801fc6:	75 8a                	jne    801f52 <print_mem_block_lists+0xf2>
  801fc8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fcc:	75 84                	jne    801f52 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fce:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fd2:	75 10                	jne    801fe4 <print_mem_block_lists+0x184>
  801fd4:	83 ec 0c             	sub    $0xc,%esp
  801fd7:	68 cc 3a 80 00       	push   $0x803acc
  801fdc:	e8 55 e5 ff ff       	call   800536 <cprintf>
  801fe1:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801fe4:	83 ec 0c             	sub    $0xc,%esp
  801fe7:	68 40 3a 80 00       	push   $0x803a40
  801fec:	e8 45 e5 ff ff       	call   800536 <cprintf>
  801ff1:	83 c4 10             	add    $0x10,%esp

}
  801ff4:	90                   	nop
  801ff5:	c9                   	leave  
  801ff6:	c3                   	ret    

00801ff7 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801ff7:	55                   	push   %ebp
  801ff8:	89 e5                	mov    %esp,%ebp
  801ffa:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  801ffd:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802004:	00 00 00 
  802007:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  80200e:	00 00 00 
  802011:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802018:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  80201b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802022:	e9 9e 00 00 00       	jmp    8020c5 <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802027:	a1 50 40 80 00       	mov    0x804050,%eax
  80202c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80202f:	c1 e2 04             	shl    $0x4,%edx
  802032:	01 d0                	add    %edx,%eax
  802034:	85 c0                	test   %eax,%eax
  802036:	75 14                	jne    80204c <initialize_MemBlocksList+0x55>
  802038:	83 ec 04             	sub    $0x4,%esp
  80203b:	68 f4 3a 80 00       	push   $0x803af4
  802040:	6a 47                	push   $0x47
  802042:	68 17 3b 80 00       	push   $0x803b17
  802047:	e8 36 e2 ff ff       	call   800282 <_panic>
  80204c:	a1 50 40 80 00       	mov    0x804050,%eax
  802051:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802054:	c1 e2 04             	shl    $0x4,%edx
  802057:	01 d0                	add    %edx,%eax
  802059:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80205f:	89 10                	mov    %edx,(%eax)
  802061:	8b 00                	mov    (%eax),%eax
  802063:	85 c0                	test   %eax,%eax
  802065:	74 18                	je     80207f <initialize_MemBlocksList+0x88>
  802067:	a1 48 41 80 00       	mov    0x804148,%eax
  80206c:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802072:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802075:	c1 e1 04             	shl    $0x4,%ecx
  802078:	01 ca                	add    %ecx,%edx
  80207a:	89 50 04             	mov    %edx,0x4(%eax)
  80207d:	eb 12                	jmp    802091 <initialize_MemBlocksList+0x9a>
  80207f:	a1 50 40 80 00       	mov    0x804050,%eax
  802084:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802087:	c1 e2 04             	shl    $0x4,%edx
  80208a:	01 d0                	add    %edx,%eax
  80208c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802091:	a1 50 40 80 00       	mov    0x804050,%eax
  802096:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802099:	c1 e2 04             	shl    $0x4,%edx
  80209c:	01 d0                	add    %edx,%eax
  80209e:	a3 48 41 80 00       	mov    %eax,0x804148
  8020a3:	a1 50 40 80 00       	mov    0x804050,%eax
  8020a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020ab:	c1 e2 04             	shl    $0x4,%edx
  8020ae:	01 d0                	add    %edx,%eax
  8020b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020b7:	a1 54 41 80 00       	mov    0x804154,%eax
  8020bc:	40                   	inc    %eax
  8020bd:	a3 54 41 80 00       	mov    %eax,0x804154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  8020c2:	ff 45 f4             	incl   -0xc(%ebp)
  8020c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020cb:	0f 82 56 ff ff ff    	jb     802027 <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  8020d1:	90                   	nop
  8020d2:	c9                   	leave  
  8020d3:	c3                   	ret    

008020d4 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020d4:	55                   	push   %ebp
  8020d5:	89 e5                	mov    %esp,%ebp
  8020d7:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  8020da:	8b 45 08             	mov    0x8(%ebp),%eax
  8020dd:	8b 00                	mov    (%eax),%eax
  8020df:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020e2:	eb 19                	jmp    8020fd <find_block+0x29>
	{
		if(element->sva == va){
  8020e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020e7:	8b 40 08             	mov    0x8(%eax),%eax
  8020ea:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8020ed:	75 05                	jne    8020f4 <find_block+0x20>
			 		return element;
  8020ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020f2:	eb 36                	jmp    80212a <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  8020f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f7:	8b 40 08             	mov    0x8(%eax),%eax
  8020fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802101:	74 07                	je     80210a <find_block+0x36>
  802103:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802106:	8b 00                	mov    (%eax),%eax
  802108:	eb 05                	jmp    80210f <find_block+0x3b>
  80210a:	b8 00 00 00 00       	mov    $0x0,%eax
  80210f:	8b 55 08             	mov    0x8(%ebp),%edx
  802112:	89 42 08             	mov    %eax,0x8(%edx)
  802115:	8b 45 08             	mov    0x8(%ebp),%eax
  802118:	8b 40 08             	mov    0x8(%eax),%eax
  80211b:	85 c0                	test   %eax,%eax
  80211d:	75 c5                	jne    8020e4 <find_block+0x10>
  80211f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802123:	75 bf                	jne    8020e4 <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  802125:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80212a:	c9                   	leave  
  80212b:	c3                   	ret    

0080212c <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80212c:	55                   	push   %ebp
  80212d:	89 e5                	mov    %esp,%ebp
  80212f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  802132:	a1 44 40 80 00       	mov    0x804044,%eax
  802137:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  80213a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80213f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  802142:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802146:	74 0a                	je     802152 <insert_sorted_allocList+0x26>
  802148:	8b 45 08             	mov    0x8(%ebp),%eax
  80214b:	8b 40 08             	mov    0x8(%eax),%eax
  80214e:	85 c0                	test   %eax,%eax
  802150:	75 65                	jne    8021b7 <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802152:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802156:	75 14                	jne    80216c <insert_sorted_allocList+0x40>
  802158:	83 ec 04             	sub    $0x4,%esp
  80215b:	68 f4 3a 80 00       	push   $0x803af4
  802160:	6a 6e                	push   $0x6e
  802162:	68 17 3b 80 00       	push   $0x803b17
  802167:	e8 16 e1 ff ff       	call   800282 <_panic>
  80216c:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802172:	8b 45 08             	mov    0x8(%ebp),%eax
  802175:	89 10                	mov    %edx,(%eax)
  802177:	8b 45 08             	mov    0x8(%ebp),%eax
  80217a:	8b 00                	mov    (%eax),%eax
  80217c:	85 c0                	test   %eax,%eax
  80217e:	74 0d                	je     80218d <insert_sorted_allocList+0x61>
  802180:	a1 40 40 80 00       	mov    0x804040,%eax
  802185:	8b 55 08             	mov    0x8(%ebp),%edx
  802188:	89 50 04             	mov    %edx,0x4(%eax)
  80218b:	eb 08                	jmp    802195 <insert_sorted_allocList+0x69>
  80218d:	8b 45 08             	mov    0x8(%ebp),%eax
  802190:	a3 44 40 80 00       	mov    %eax,0x804044
  802195:	8b 45 08             	mov    0x8(%ebp),%eax
  802198:	a3 40 40 80 00       	mov    %eax,0x804040
  80219d:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021a7:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021ac:	40                   	inc    %eax
  8021ad:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8021b2:	e9 cf 01 00 00       	jmp    802386 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  8021b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ba:	8b 50 08             	mov    0x8(%eax),%edx
  8021bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c0:	8b 40 08             	mov    0x8(%eax),%eax
  8021c3:	39 c2                	cmp    %eax,%edx
  8021c5:	73 65                	jae    80222c <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8021c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021cb:	75 14                	jne    8021e1 <insert_sorted_allocList+0xb5>
  8021cd:	83 ec 04             	sub    $0x4,%esp
  8021d0:	68 30 3b 80 00       	push   $0x803b30
  8021d5:	6a 72                	push   $0x72
  8021d7:	68 17 3b 80 00       	push   $0x803b17
  8021dc:	e8 a1 e0 ff ff       	call   800282 <_panic>
  8021e1:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8021e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ea:	89 50 04             	mov    %edx,0x4(%eax)
  8021ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f0:	8b 40 04             	mov    0x4(%eax),%eax
  8021f3:	85 c0                	test   %eax,%eax
  8021f5:	74 0c                	je     802203 <insert_sorted_allocList+0xd7>
  8021f7:	a1 44 40 80 00       	mov    0x804044,%eax
  8021fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8021ff:	89 10                	mov    %edx,(%eax)
  802201:	eb 08                	jmp    80220b <insert_sorted_allocList+0xdf>
  802203:	8b 45 08             	mov    0x8(%ebp),%eax
  802206:	a3 40 40 80 00       	mov    %eax,0x804040
  80220b:	8b 45 08             	mov    0x8(%ebp),%eax
  80220e:	a3 44 40 80 00       	mov    %eax,0x804044
  802213:	8b 45 08             	mov    0x8(%ebp),%eax
  802216:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80221c:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802221:	40                   	inc    %eax
  802222:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  802227:	e9 5a 01 00 00       	jmp    802386 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  80222c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80222f:	8b 50 08             	mov    0x8(%eax),%edx
  802232:	8b 45 08             	mov    0x8(%ebp),%eax
  802235:	8b 40 08             	mov    0x8(%eax),%eax
  802238:	39 c2                	cmp    %eax,%edx
  80223a:	75 70                	jne    8022ac <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  80223c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802240:	74 06                	je     802248 <insert_sorted_allocList+0x11c>
  802242:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802246:	75 14                	jne    80225c <insert_sorted_allocList+0x130>
  802248:	83 ec 04             	sub    $0x4,%esp
  80224b:	68 54 3b 80 00       	push   $0x803b54
  802250:	6a 75                	push   $0x75
  802252:	68 17 3b 80 00       	push   $0x803b17
  802257:	e8 26 e0 ff ff       	call   800282 <_panic>
  80225c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80225f:	8b 10                	mov    (%eax),%edx
  802261:	8b 45 08             	mov    0x8(%ebp),%eax
  802264:	89 10                	mov    %edx,(%eax)
  802266:	8b 45 08             	mov    0x8(%ebp),%eax
  802269:	8b 00                	mov    (%eax),%eax
  80226b:	85 c0                	test   %eax,%eax
  80226d:	74 0b                	je     80227a <insert_sorted_allocList+0x14e>
  80226f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802272:	8b 00                	mov    (%eax),%eax
  802274:	8b 55 08             	mov    0x8(%ebp),%edx
  802277:	89 50 04             	mov    %edx,0x4(%eax)
  80227a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80227d:	8b 55 08             	mov    0x8(%ebp),%edx
  802280:	89 10                	mov    %edx,(%eax)
  802282:	8b 45 08             	mov    0x8(%ebp),%eax
  802285:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802288:	89 50 04             	mov    %edx,0x4(%eax)
  80228b:	8b 45 08             	mov    0x8(%ebp),%eax
  80228e:	8b 00                	mov    (%eax),%eax
  802290:	85 c0                	test   %eax,%eax
  802292:	75 08                	jne    80229c <insert_sorted_allocList+0x170>
  802294:	8b 45 08             	mov    0x8(%ebp),%eax
  802297:	a3 44 40 80 00       	mov    %eax,0x804044
  80229c:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022a1:	40                   	inc    %eax
  8022a2:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  8022a7:	e9 da 00 00 00       	jmp    802386 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  8022ac:	a1 40 40 80 00       	mov    0x804040,%eax
  8022b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022b4:	e9 9d 00 00 00       	jmp    802356 <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  8022b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bc:	8b 00                	mov    (%eax),%eax
  8022be:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  8022c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c4:	8b 50 08             	mov    0x8(%eax),%edx
  8022c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ca:	8b 40 08             	mov    0x8(%eax),%eax
  8022cd:	39 c2                	cmp    %eax,%edx
  8022cf:	76 7d                	jbe    80234e <insert_sorted_allocList+0x222>
  8022d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d4:	8b 50 08             	mov    0x8(%eax),%edx
  8022d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022da:	8b 40 08             	mov    0x8(%eax),%eax
  8022dd:	39 c2                	cmp    %eax,%edx
  8022df:	73 6d                	jae    80234e <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  8022e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022e5:	74 06                	je     8022ed <insert_sorted_allocList+0x1c1>
  8022e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022eb:	75 14                	jne    802301 <insert_sorted_allocList+0x1d5>
  8022ed:	83 ec 04             	sub    $0x4,%esp
  8022f0:	68 54 3b 80 00       	push   $0x803b54
  8022f5:	6a 7c                	push   $0x7c
  8022f7:	68 17 3b 80 00       	push   $0x803b17
  8022fc:	e8 81 df ff ff       	call   800282 <_panic>
  802301:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802304:	8b 10                	mov    (%eax),%edx
  802306:	8b 45 08             	mov    0x8(%ebp),%eax
  802309:	89 10                	mov    %edx,(%eax)
  80230b:	8b 45 08             	mov    0x8(%ebp),%eax
  80230e:	8b 00                	mov    (%eax),%eax
  802310:	85 c0                	test   %eax,%eax
  802312:	74 0b                	je     80231f <insert_sorted_allocList+0x1f3>
  802314:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802317:	8b 00                	mov    (%eax),%eax
  802319:	8b 55 08             	mov    0x8(%ebp),%edx
  80231c:	89 50 04             	mov    %edx,0x4(%eax)
  80231f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802322:	8b 55 08             	mov    0x8(%ebp),%edx
  802325:	89 10                	mov    %edx,(%eax)
  802327:	8b 45 08             	mov    0x8(%ebp),%eax
  80232a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80232d:	89 50 04             	mov    %edx,0x4(%eax)
  802330:	8b 45 08             	mov    0x8(%ebp),%eax
  802333:	8b 00                	mov    (%eax),%eax
  802335:	85 c0                	test   %eax,%eax
  802337:	75 08                	jne    802341 <insert_sorted_allocList+0x215>
  802339:	8b 45 08             	mov    0x8(%ebp),%eax
  80233c:	a3 44 40 80 00       	mov    %eax,0x804044
  802341:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802346:	40                   	inc    %eax
  802347:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  80234c:	eb 38                	jmp    802386 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  80234e:	a1 48 40 80 00       	mov    0x804048,%eax
  802353:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802356:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80235a:	74 07                	je     802363 <insert_sorted_allocList+0x237>
  80235c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235f:	8b 00                	mov    (%eax),%eax
  802361:	eb 05                	jmp    802368 <insert_sorted_allocList+0x23c>
  802363:	b8 00 00 00 00       	mov    $0x0,%eax
  802368:	a3 48 40 80 00       	mov    %eax,0x804048
  80236d:	a1 48 40 80 00       	mov    0x804048,%eax
  802372:	85 c0                	test   %eax,%eax
  802374:	0f 85 3f ff ff ff    	jne    8022b9 <insert_sorted_allocList+0x18d>
  80237a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80237e:	0f 85 35 ff ff ff    	jne    8022b9 <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  802384:	eb 00                	jmp    802386 <insert_sorted_allocList+0x25a>
  802386:	90                   	nop
  802387:	c9                   	leave  
  802388:	c3                   	ret    

00802389 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802389:	55                   	push   %ebp
  80238a:	89 e5                	mov    %esp,%ebp
  80238c:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  80238f:	a1 38 41 80 00       	mov    0x804138,%eax
  802394:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802397:	e9 6b 02 00 00       	jmp    802607 <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  80239c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239f:	8b 40 0c             	mov    0xc(%eax),%eax
  8023a2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023a5:	0f 85 90 00 00 00    	jne    80243b <alloc_block_FF+0xb2>
			  temp=element;
  8023ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ae:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  8023b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023b5:	75 17                	jne    8023ce <alloc_block_FF+0x45>
  8023b7:	83 ec 04             	sub    $0x4,%esp
  8023ba:	68 88 3b 80 00       	push   $0x803b88
  8023bf:	68 92 00 00 00       	push   $0x92
  8023c4:	68 17 3b 80 00       	push   $0x803b17
  8023c9:	e8 b4 de ff ff       	call   800282 <_panic>
  8023ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d1:	8b 00                	mov    (%eax),%eax
  8023d3:	85 c0                	test   %eax,%eax
  8023d5:	74 10                	je     8023e7 <alloc_block_FF+0x5e>
  8023d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023da:	8b 00                	mov    (%eax),%eax
  8023dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023df:	8b 52 04             	mov    0x4(%edx),%edx
  8023e2:	89 50 04             	mov    %edx,0x4(%eax)
  8023e5:	eb 0b                	jmp    8023f2 <alloc_block_FF+0x69>
  8023e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ea:	8b 40 04             	mov    0x4(%eax),%eax
  8023ed:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8023f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f5:	8b 40 04             	mov    0x4(%eax),%eax
  8023f8:	85 c0                	test   %eax,%eax
  8023fa:	74 0f                	je     80240b <alloc_block_FF+0x82>
  8023fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ff:	8b 40 04             	mov    0x4(%eax),%eax
  802402:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802405:	8b 12                	mov    (%edx),%edx
  802407:	89 10                	mov    %edx,(%eax)
  802409:	eb 0a                	jmp    802415 <alloc_block_FF+0x8c>
  80240b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240e:	8b 00                	mov    (%eax),%eax
  802410:	a3 38 41 80 00       	mov    %eax,0x804138
  802415:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802418:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80241e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802421:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802428:	a1 44 41 80 00       	mov    0x804144,%eax
  80242d:	48                   	dec    %eax
  80242e:	a3 44 41 80 00       	mov    %eax,0x804144
			  return temp;
  802433:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802436:	e9 ff 01 00 00       	jmp    80263a <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  80243b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243e:	8b 40 0c             	mov    0xc(%eax),%eax
  802441:	3b 45 08             	cmp    0x8(%ebp),%eax
  802444:	0f 86 b5 01 00 00    	jbe    8025ff <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  80244a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244d:	8b 40 0c             	mov    0xc(%eax),%eax
  802450:	2b 45 08             	sub    0x8(%ebp),%eax
  802453:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  802456:	a1 48 41 80 00       	mov    0x804148,%eax
  80245b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  80245e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802462:	75 17                	jne    80247b <alloc_block_FF+0xf2>
  802464:	83 ec 04             	sub    $0x4,%esp
  802467:	68 88 3b 80 00       	push   $0x803b88
  80246c:	68 99 00 00 00       	push   $0x99
  802471:	68 17 3b 80 00       	push   $0x803b17
  802476:	e8 07 de ff ff       	call   800282 <_panic>
  80247b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80247e:	8b 00                	mov    (%eax),%eax
  802480:	85 c0                	test   %eax,%eax
  802482:	74 10                	je     802494 <alloc_block_FF+0x10b>
  802484:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802487:	8b 00                	mov    (%eax),%eax
  802489:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80248c:	8b 52 04             	mov    0x4(%edx),%edx
  80248f:	89 50 04             	mov    %edx,0x4(%eax)
  802492:	eb 0b                	jmp    80249f <alloc_block_FF+0x116>
  802494:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802497:	8b 40 04             	mov    0x4(%eax),%eax
  80249a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80249f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024a2:	8b 40 04             	mov    0x4(%eax),%eax
  8024a5:	85 c0                	test   %eax,%eax
  8024a7:	74 0f                	je     8024b8 <alloc_block_FF+0x12f>
  8024a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024ac:	8b 40 04             	mov    0x4(%eax),%eax
  8024af:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024b2:	8b 12                	mov    (%edx),%edx
  8024b4:	89 10                	mov    %edx,(%eax)
  8024b6:	eb 0a                	jmp    8024c2 <alloc_block_FF+0x139>
  8024b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024bb:	8b 00                	mov    (%eax),%eax
  8024bd:	a3 48 41 80 00       	mov    %eax,0x804148
  8024c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024d5:	a1 54 41 80 00       	mov    0x804154,%eax
  8024da:	48                   	dec    %eax
  8024db:	a3 54 41 80 00       	mov    %eax,0x804154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  8024e0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8024e4:	75 17                	jne    8024fd <alloc_block_FF+0x174>
  8024e6:	83 ec 04             	sub    $0x4,%esp
  8024e9:	68 30 3b 80 00       	push   $0x803b30
  8024ee:	68 9a 00 00 00       	push   $0x9a
  8024f3:	68 17 3b 80 00       	push   $0x803b17
  8024f8:	e8 85 dd ff ff       	call   800282 <_panic>
  8024fd:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802503:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802506:	89 50 04             	mov    %edx,0x4(%eax)
  802509:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80250c:	8b 40 04             	mov    0x4(%eax),%eax
  80250f:	85 c0                	test   %eax,%eax
  802511:	74 0c                	je     80251f <alloc_block_FF+0x196>
  802513:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802518:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80251b:	89 10                	mov    %edx,(%eax)
  80251d:	eb 08                	jmp    802527 <alloc_block_FF+0x19e>
  80251f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802522:	a3 38 41 80 00       	mov    %eax,0x804138
  802527:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80252a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80252f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802532:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802538:	a1 44 41 80 00       	mov    0x804144,%eax
  80253d:	40                   	inc    %eax
  80253e:	a3 44 41 80 00       	mov    %eax,0x804144
		  // setting the size & sva
		  new_block->size=size;
  802543:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802546:	8b 55 08             	mov    0x8(%ebp),%edx
  802549:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  80254c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254f:	8b 50 08             	mov    0x8(%eax),%edx
  802552:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802555:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  802558:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80255e:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  802561:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802564:	8b 50 08             	mov    0x8(%eax),%edx
  802567:	8b 45 08             	mov    0x8(%ebp),%eax
  80256a:	01 c2                	add    %eax,%edx
  80256c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256f:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  802572:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802575:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  802578:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80257c:	75 17                	jne    802595 <alloc_block_FF+0x20c>
  80257e:	83 ec 04             	sub    $0x4,%esp
  802581:	68 88 3b 80 00       	push   $0x803b88
  802586:	68 a2 00 00 00       	push   $0xa2
  80258b:	68 17 3b 80 00       	push   $0x803b17
  802590:	e8 ed dc ff ff       	call   800282 <_panic>
  802595:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802598:	8b 00                	mov    (%eax),%eax
  80259a:	85 c0                	test   %eax,%eax
  80259c:	74 10                	je     8025ae <alloc_block_FF+0x225>
  80259e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025a1:	8b 00                	mov    (%eax),%eax
  8025a3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025a6:	8b 52 04             	mov    0x4(%edx),%edx
  8025a9:	89 50 04             	mov    %edx,0x4(%eax)
  8025ac:	eb 0b                	jmp    8025b9 <alloc_block_FF+0x230>
  8025ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025b1:	8b 40 04             	mov    0x4(%eax),%eax
  8025b4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025bc:	8b 40 04             	mov    0x4(%eax),%eax
  8025bf:	85 c0                	test   %eax,%eax
  8025c1:	74 0f                	je     8025d2 <alloc_block_FF+0x249>
  8025c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025c6:	8b 40 04             	mov    0x4(%eax),%eax
  8025c9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025cc:	8b 12                	mov    (%edx),%edx
  8025ce:	89 10                	mov    %edx,(%eax)
  8025d0:	eb 0a                	jmp    8025dc <alloc_block_FF+0x253>
  8025d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d5:	8b 00                	mov    (%eax),%eax
  8025d7:	a3 38 41 80 00       	mov    %eax,0x804138
  8025dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025ef:	a1 44 41 80 00       	mov    0x804144,%eax
  8025f4:	48                   	dec    %eax
  8025f5:	a3 44 41 80 00       	mov    %eax,0x804144
		  return temp;
  8025fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025fd:	eb 3b                	jmp    80263a <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  8025ff:	a1 40 41 80 00       	mov    0x804140,%eax
  802604:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802607:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80260b:	74 07                	je     802614 <alloc_block_FF+0x28b>
  80260d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802610:	8b 00                	mov    (%eax),%eax
  802612:	eb 05                	jmp    802619 <alloc_block_FF+0x290>
  802614:	b8 00 00 00 00       	mov    $0x0,%eax
  802619:	a3 40 41 80 00       	mov    %eax,0x804140
  80261e:	a1 40 41 80 00       	mov    0x804140,%eax
  802623:	85 c0                	test   %eax,%eax
  802625:	0f 85 71 fd ff ff    	jne    80239c <alloc_block_FF+0x13>
  80262b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80262f:	0f 85 67 fd ff ff    	jne    80239c <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  802635:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80263a:	c9                   	leave  
  80263b:	c3                   	ret    

0080263c <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80263c:	55                   	push   %ebp
  80263d:	89 e5                	mov    %esp,%ebp
  80263f:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  802642:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  802649:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802650:	a1 38 41 80 00       	mov    0x804138,%eax
  802655:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802658:	e9 d3 00 00 00       	jmp    802730 <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  80265d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802660:	8b 40 0c             	mov    0xc(%eax),%eax
  802663:	3b 45 08             	cmp    0x8(%ebp),%eax
  802666:	0f 85 90 00 00 00    	jne    8026fc <alloc_block_BF+0xc0>
	   temp = element;
  80266c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80266f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  802672:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802676:	75 17                	jne    80268f <alloc_block_BF+0x53>
  802678:	83 ec 04             	sub    $0x4,%esp
  80267b:	68 88 3b 80 00       	push   $0x803b88
  802680:	68 bd 00 00 00       	push   $0xbd
  802685:	68 17 3b 80 00       	push   $0x803b17
  80268a:	e8 f3 db ff ff       	call   800282 <_panic>
  80268f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802692:	8b 00                	mov    (%eax),%eax
  802694:	85 c0                	test   %eax,%eax
  802696:	74 10                	je     8026a8 <alloc_block_BF+0x6c>
  802698:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80269b:	8b 00                	mov    (%eax),%eax
  80269d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026a0:	8b 52 04             	mov    0x4(%edx),%edx
  8026a3:	89 50 04             	mov    %edx,0x4(%eax)
  8026a6:	eb 0b                	jmp    8026b3 <alloc_block_BF+0x77>
  8026a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026ab:	8b 40 04             	mov    0x4(%eax),%eax
  8026ae:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026b6:	8b 40 04             	mov    0x4(%eax),%eax
  8026b9:	85 c0                	test   %eax,%eax
  8026bb:	74 0f                	je     8026cc <alloc_block_BF+0x90>
  8026bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026c0:	8b 40 04             	mov    0x4(%eax),%eax
  8026c3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026c6:	8b 12                	mov    (%edx),%edx
  8026c8:	89 10                	mov    %edx,(%eax)
  8026ca:	eb 0a                	jmp    8026d6 <alloc_block_BF+0x9a>
  8026cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026cf:	8b 00                	mov    (%eax),%eax
  8026d1:	a3 38 41 80 00       	mov    %eax,0x804138
  8026d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026e9:	a1 44 41 80 00       	mov    0x804144,%eax
  8026ee:	48                   	dec    %eax
  8026ef:	a3 44 41 80 00       	mov    %eax,0x804144
	   return temp;
  8026f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026f7:	e9 41 01 00 00       	jmp    80283d <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  8026fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802702:	3b 45 08             	cmp    0x8(%ebp),%eax
  802705:	76 21                	jbe    802728 <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  802707:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80270a:	8b 40 0c             	mov    0xc(%eax),%eax
  80270d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802710:	73 16                	jae    802728 <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  802712:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802715:	8b 40 0c             	mov    0xc(%eax),%eax
  802718:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  80271b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80271e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  802721:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802728:	a1 40 41 80 00       	mov    0x804140,%eax
  80272d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802730:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802734:	74 07                	je     80273d <alloc_block_BF+0x101>
  802736:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802739:	8b 00                	mov    (%eax),%eax
  80273b:	eb 05                	jmp    802742 <alloc_block_BF+0x106>
  80273d:	b8 00 00 00 00       	mov    $0x0,%eax
  802742:	a3 40 41 80 00       	mov    %eax,0x804140
  802747:	a1 40 41 80 00       	mov    0x804140,%eax
  80274c:	85 c0                	test   %eax,%eax
  80274e:	0f 85 09 ff ff ff    	jne    80265d <alloc_block_BF+0x21>
  802754:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802758:	0f 85 ff fe ff ff    	jne    80265d <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  80275e:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  802762:	0f 85 d0 00 00 00    	jne    802838 <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  802768:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80276b:	8b 40 0c             	mov    0xc(%eax),%eax
  80276e:	2b 45 08             	sub    0x8(%ebp),%eax
  802771:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  802774:	a1 48 41 80 00       	mov    0x804148,%eax
  802779:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  80277c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802780:	75 17                	jne    802799 <alloc_block_BF+0x15d>
  802782:	83 ec 04             	sub    $0x4,%esp
  802785:	68 88 3b 80 00       	push   $0x803b88
  80278a:	68 d1 00 00 00       	push   $0xd1
  80278f:	68 17 3b 80 00       	push   $0x803b17
  802794:	e8 e9 da ff ff       	call   800282 <_panic>
  802799:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80279c:	8b 00                	mov    (%eax),%eax
  80279e:	85 c0                	test   %eax,%eax
  8027a0:	74 10                	je     8027b2 <alloc_block_BF+0x176>
  8027a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027a5:	8b 00                	mov    (%eax),%eax
  8027a7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027aa:	8b 52 04             	mov    0x4(%edx),%edx
  8027ad:	89 50 04             	mov    %edx,0x4(%eax)
  8027b0:	eb 0b                	jmp    8027bd <alloc_block_BF+0x181>
  8027b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027b5:	8b 40 04             	mov    0x4(%eax),%eax
  8027b8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8027bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027c0:	8b 40 04             	mov    0x4(%eax),%eax
  8027c3:	85 c0                	test   %eax,%eax
  8027c5:	74 0f                	je     8027d6 <alloc_block_BF+0x19a>
  8027c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027ca:	8b 40 04             	mov    0x4(%eax),%eax
  8027cd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027d0:	8b 12                	mov    (%edx),%edx
  8027d2:	89 10                	mov    %edx,(%eax)
  8027d4:	eb 0a                	jmp    8027e0 <alloc_block_BF+0x1a4>
  8027d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027d9:	8b 00                	mov    (%eax),%eax
  8027db:	a3 48 41 80 00       	mov    %eax,0x804148
  8027e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027f3:	a1 54 41 80 00       	mov    0x804154,%eax
  8027f8:	48                   	dec    %eax
  8027f9:	a3 54 41 80 00       	mov    %eax,0x804154
	  // setting the size & sva
	  new_block->size = size;
  8027fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802801:	8b 55 08             	mov    0x8(%ebp),%edx
  802804:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  802807:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80280a:	8b 50 08             	mov    0x8(%eax),%edx
  80280d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802810:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  802813:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802816:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802819:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  80281c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80281f:	8b 50 08             	mov    0x8(%eax),%edx
  802822:	8b 45 08             	mov    0x8(%ebp),%eax
  802825:	01 c2                	add    %eax,%edx
  802827:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80282a:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  80282d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802830:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  802833:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802836:	eb 05                	jmp    80283d <alloc_block_BF+0x201>
	 }
	 return NULL;
  802838:	b8 00 00 00 00       	mov    $0x0,%eax


}
  80283d:	c9                   	leave  
  80283e:	c3                   	ret    

0080283f <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80283f:	55                   	push   %ebp
  802840:	89 e5                	mov    %esp,%ebp
  802842:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802845:	83 ec 04             	sub    $0x4,%esp
  802848:	68 a8 3b 80 00       	push   $0x803ba8
  80284d:	68 e8 00 00 00       	push   $0xe8
  802852:	68 17 3b 80 00       	push   $0x803b17
  802857:	e8 26 da ff ff       	call   800282 <_panic>

0080285c <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80285c:	55                   	push   %ebp
  80285d:	89 e5                	mov    %esp,%ebp
  80285f:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  802862:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802867:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  80286a:	a1 38 41 80 00       	mov    0x804138,%eax
  80286f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  802872:	a1 44 41 80 00       	mov    0x804144,%eax
  802877:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  80287a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80287e:	75 68                	jne    8028e8 <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802880:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802884:	75 17                	jne    80289d <insert_sorted_with_merge_freeList+0x41>
  802886:	83 ec 04             	sub    $0x4,%esp
  802889:	68 f4 3a 80 00       	push   $0x803af4
  80288e:	68 36 01 00 00       	push   $0x136
  802893:	68 17 3b 80 00       	push   $0x803b17
  802898:	e8 e5 d9 ff ff       	call   800282 <_panic>
  80289d:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8028a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a6:	89 10                	mov    %edx,(%eax)
  8028a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ab:	8b 00                	mov    (%eax),%eax
  8028ad:	85 c0                	test   %eax,%eax
  8028af:	74 0d                	je     8028be <insert_sorted_with_merge_freeList+0x62>
  8028b1:	a1 38 41 80 00       	mov    0x804138,%eax
  8028b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8028b9:	89 50 04             	mov    %edx,0x4(%eax)
  8028bc:	eb 08                	jmp    8028c6 <insert_sorted_with_merge_freeList+0x6a>
  8028be:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c1:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c9:	a3 38 41 80 00       	mov    %eax,0x804138
  8028ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028d8:	a1 44 41 80 00       	mov    0x804144,%eax
  8028dd:	40                   	inc    %eax
  8028de:	a3 44 41 80 00       	mov    %eax,0x804144





}
  8028e3:	e9 ba 06 00 00       	jmp    802fa2 <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  8028e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028eb:	8b 50 08             	mov    0x8(%eax),%edx
  8028ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8028f4:	01 c2                	add    %eax,%edx
  8028f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f9:	8b 40 08             	mov    0x8(%eax),%eax
  8028fc:	39 c2                	cmp    %eax,%edx
  8028fe:	73 68                	jae    802968 <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802900:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802904:	75 17                	jne    80291d <insert_sorted_with_merge_freeList+0xc1>
  802906:	83 ec 04             	sub    $0x4,%esp
  802909:	68 30 3b 80 00       	push   $0x803b30
  80290e:	68 3a 01 00 00       	push   $0x13a
  802913:	68 17 3b 80 00       	push   $0x803b17
  802918:	e8 65 d9 ff ff       	call   800282 <_panic>
  80291d:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802923:	8b 45 08             	mov    0x8(%ebp),%eax
  802926:	89 50 04             	mov    %edx,0x4(%eax)
  802929:	8b 45 08             	mov    0x8(%ebp),%eax
  80292c:	8b 40 04             	mov    0x4(%eax),%eax
  80292f:	85 c0                	test   %eax,%eax
  802931:	74 0c                	je     80293f <insert_sorted_with_merge_freeList+0xe3>
  802933:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802938:	8b 55 08             	mov    0x8(%ebp),%edx
  80293b:	89 10                	mov    %edx,(%eax)
  80293d:	eb 08                	jmp    802947 <insert_sorted_with_merge_freeList+0xeb>
  80293f:	8b 45 08             	mov    0x8(%ebp),%eax
  802942:	a3 38 41 80 00       	mov    %eax,0x804138
  802947:	8b 45 08             	mov    0x8(%ebp),%eax
  80294a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80294f:	8b 45 08             	mov    0x8(%ebp),%eax
  802952:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802958:	a1 44 41 80 00       	mov    0x804144,%eax
  80295d:	40                   	inc    %eax
  80295e:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802963:	e9 3a 06 00 00       	jmp    802fa2 <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  802968:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80296b:	8b 50 08             	mov    0x8(%eax),%edx
  80296e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802971:	8b 40 0c             	mov    0xc(%eax),%eax
  802974:	01 c2                	add    %eax,%edx
  802976:	8b 45 08             	mov    0x8(%ebp),%eax
  802979:	8b 40 08             	mov    0x8(%eax),%eax
  80297c:	39 c2                	cmp    %eax,%edx
  80297e:	0f 85 90 00 00 00    	jne    802a14 <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  802984:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802987:	8b 50 0c             	mov    0xc(%eax),%edx
  80298a:	8b 45 08             	mov    0x8(%ebp),%eax
  80298d:	8b 40 0c             	mov    0xc(%eax),%eax
  802990:	01 c2                	add    %eax,%edx
  802992:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802995:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  802998:	8b 45 08             	mov    0x8(%ebp),%eax
  80299b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  8029a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8029ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029b0:	75 17                	jne    8029c9 <insert_sorted_with_merge_freeList+0x16d>
  8029b2:	83 ec 04             	sub    $0x4,%esp
  8029b5:	68 f4 3a 80 00       	push   $0x803af4
  8029ba:	68 41 01 00 00       	push   $0x141
  8029bf:	68 17 3b 80 00       	push   $0x803b17
  8029c4:	e8 b9 d8 ff ff       	call   800282 <_panic>
  8029c9:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8029cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d2:	89 10                	mov    %edx,(%eax)
  8029d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d7:	8b 00                	mov    (%eax),%eax
  8029d9:	85 c0                	test   %eax,%eax
  8029db:	74 0d                	je     8029ea <insert_sorted_with_merge_freeList+0x18e>
  8029dd:	a1 48 41 80 00       	mov    0x804148,%eax
  8029e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8029e5:	89 50 04             	mov    %edx,0x4(%eax)
  8029e8:	eb 08                	jmp    8029f2 <insert_sorted_with_merge_freeList+0x196>
  8029ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ed:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8029f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f5:	a3 48 41 80 00       	mov    %eax,0x804148
  8029fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a04:	a1 54 41 80 00       	mov    0x804154,%eax
  802a09:	40                   	inc    %eax
  802a0a:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802a0f:	e9 8e 05 00 00       	jmp    802fa2 <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  802a14:	8b 45 08             	mov    0x8(%ebp),%eax
  802a17:	8b 50 08             	mov    0x8(%eax),%edx
  802a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1d:	8b 40 0c             	mov    0xc(%eax),%eax
  802a20:	01 c2                	add    %eax,%edx
  802a22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a25:	8b 40 08             	mov    0x8(%eax),%eax
  802a28:	39 c2                	cmp    %eax,%edx
  802a2a:	73 68                	jae    802a94 <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802a2c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a30:	75 17                	jne    802a49 <insert_sorted_with_merge_freeList+0x1ed>
  802a32:	83 ec 04             	sub    $0x4,%esp
  802a35:	68 f4 3a 80 00       	push   $0x803af4
  802a3a:	68 45 01 00 00       	push   $0x145
  802a3f:	68 17 3b 80 00       	push   $0x803b17
  802a44:	e8 39 d8 ff ff       	call   800282 <_panic>
  802a49:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a52:	89 10                	mov    %edx,(%eax)
  802a54:	8b 45 08             	mov    0x8(%ebp),%eax
  802a57:	8b 00                	mov    (%eax),%eax
  802a59:	85 c0                	test   %eax,%eax
  802a5b:	74 0d                	je     802a6a <insert_sorted_with_merge_freeList+0x20e>
  802a5d:	a1 38 41 80 00       	mov    0x804138,%eax
  802a62:	8b 55 08             	mov    0x8(%ebp),%edx
  802a65:	89 50 04             	mov    %edx,0x4(%eax)
  802a68:	eb 08                	jmp    802a72 <insert_sorted_with_merge_freeList+0x216>
  802a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a72:	8b 45 08             	mov    0x8(%ebp),%eax
  802a75:	a3 38 41 80 00       	mov    %eax,0x804138
  802a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a84:	a1 44 41 80 00       	mov    0x804144,%eax
  802a89:	40                   	inc    %eax
  802a8a:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802a8f:	e9 0e 05 00 00       	jmp    802fa2 <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  802a94:	8b 45 08             	mov    0x8(%ebp),%eax
  802a97:	8b 50 08             	mov    0x8(%eax),%edx
  802a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9d:	8b 40 0c             	mov    0xc(%eax),%eax
  802aa0:	01 c2                	add    %eax,%edx
  802aa2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa5:	8b 40 08             	mov    0x8(%eax),%eax
  802aa8:	39 c2                	cmp    %eax,%edx
  802aaa:	0f 85 9c 00 00 00    	jne    802b4c <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  802ab0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ab3:	8b 50 0c             	mov    0xc(%eax),%edx
  802ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab9:	8b 40 0c             	mov    0xc(%eax),%eax
  802abc:	01 c2                	add    %eax,%edx
  802abe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac1:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  802ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac7:	8b 50 08             	mov    0x8(%eax),%edx
  802aca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802acd:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  802ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  802ada:	8b 45 08             	mov    0x8(%ebp),%eax
  802add:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802ae4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ae8:	75 17                	jne    802b01 <insert_sorted_with_merge_freeList+0x2a5>
  802aea:	83 ec 04             	sub    $0x4,%esp
  802aed:	68 f4 3a 80 00       	push   $0x803af4
  802af2:	68 4d 01 00 00       	push   $0x14d
  802af7:	68 17 3b 80 00       	push   $0x803b17
  802afc:	e8 81 d7 ff ff       	call   800282 <_panic>
  802b01:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b07:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0a:	89 10                	mov    %edx,(%eax)
  802b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0f:	8b 00                	mov    (%eax),%eax
  802b11:	85 c0                	test   %eax,%eax
  802b13:	74 0d                	je     802b22 <insert_sorted_with_merge_freeList+0x2c6>
  802b15:	a1 48 41 80 00       	mov    0x804148,%eax
  802b1a:	8b 55 08             	mov    0x8(%ebp),%edx
  802b1d:	89 50 04             	mov    %edx,0x4(%eax)
  802b20:	eb 08                	jmp    802b2a <insert_sorted_with_merge_freeList+0x2ce>
  802b22:	8b 45 08             	mov    0x8(%ebp),%eax
  802b25:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2d:	a3 48 41 80 00       	mov    %eax,0x804148
  802b32:	8b 45 08             	mov    0x8(%ebp),%eax
  802b35:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b3c:	a1 54 41 80 00       	mov    0x804154,%eax
  802b41:	40                   	inc    %eax
  802b42:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802b47:	e9 56 04 00 00       	jmp    802fa2 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802b4c:	a1 38 41 80 00       	mov    0x804138,%eax
  802b51:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b54:	e9 19 04 00 00       	jmp    802f72 <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  802b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5c:	8b 00                	mov    (%eax),%eax
  802b5e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b64:	8b 50 08             	mov    0x8(%eax),%edx
  802b67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b6d:	01 c2                	add    %eax,%edx
  802b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b72:	8b 40 08             	mov    0x8(%eax),%eax
  802b75:	39 c2                	cmp    %eax,%edx
  802b77:	0f 85 ad 01 00 00    	jne    802d2a <insert_sorted_with_merge_freeList+0x4ce>
  802b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b80:	8b 50 08             	mov    0x8(%eax),%edx
  802b83:	8b 45 08             	mov    0x8(%ebp),%eax
  802b86:	8b 40 0c             	mov    0xc(%eax),%eax
  802b89:	01 c2                	add    %eax,%edx
  802b8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b8e:	8b 40 08             	mov    0x8(%eax),%eax
  802b91:	39 c2                	cmp    %eax,%edx
  802b93:	0f 85 91 01 00 00    	jne    802d2a <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  802b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9c:	8b 50 0c             	mov    0xc(%eax),%edx
  802b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba2:	8b 48 0c             	mov    0xc(%eax),%ecx
  802ba5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ba8:	8b 40 0c             	mov    0xc(%eax),%eax
  802bab:	01 c8                	add    %ecx,%eax
  802bad:	01 c2                	add    %eax,%edx
  802baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb2:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  802bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  802bc9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bcc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  802bd3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bd6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  802bdd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802be1:	75 17                	jne    802bfa <insert_sorted_with_merge_freeList+0x39e>
  802be3:	83 ec 04             	sub    $0x4,%esp
  802be6:	68 88 3b 80 00       	push   $0x803b88
  802beb:	68 5b 01 00 00       	push   $0x15b
  802bf0:	68 17 3b 80 00       	push   $0x803b17
  802bf5:	e8 88 d6 ff ff       	call   800282 <_panic>
  802bfa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bfd:	8b 00                	mov    (%eax),%eax
  802bff:	85 c0                	test   %eax,%eax
  802c01:	74 10                	je     802c13 <insert_sorted_with_merge_freeList+0x3b7>
  802c03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c06:	8b 00                	mov    (%eax),%eax
  802c08:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c0b:	8b 52 04             	mov    0x4(%edx),%edx
  802c0e:	89 50 04             	mov    %edx,0x4(%eax)
  802c11:	eb 0b                	jmp    802c1e <insert_sorted_with_merge_freeList+0x3c2>
  802c13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c16:	8b 40 04             	mov    0x4(%eax),%eax
  802c19:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c21:	8b 40 04             	mov    0x4(%eax),%eax
  802c24:	85 c0                	test   %eax,%eax
  802c26:	74 0f                	je     802c37 <insert_sorted_with_merge_freeList+0x3db>
  802c28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c2b:	8b 40 04             	mov    0x4(%eax),%eax
  802c2e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c31:	8b 12                	mov    (%edx),%edx
  802c33:	89 10                	mov    %edx,(%eax)
  802c35:	eb 0a                	jmp    802c41 <insert_sorted_with_merge_freeList+0x3e5>
  802c37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c3a:	8b 00                	mov    (%eax),%eax
  802c3c:	a3 38 41 80 00       	mov    %eax,0x804138
  802c41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c44:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c4d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c54:	a1 44 41 80 00       	mov    0x804144,%eax
  802c59:	48                   	dec    %eax
  802c5a:	a3 44 41 80 00       	mov    %eax,0x804144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802c5f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c63:	75 17                	jne    802c7c <insert_sorted_with_merge_freeList+0x420>
  802c65:	83 ec 04             	sub    $0x4,%esp
  802c68:	68 f4 3a 80 00       	push   $0x803af4
  802c6d:	68 5c 01 00 00       	push   $0x15c
  802c72:	68 17 3b 80 00       	push   $0x803b17
  802c77:	e8 06 d6 ff ff       	call   800282 <_panic>
  802c7c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c82:	8b 45 08             	mov    0x8(%ebp),%eax
  802c85:	89 10                	mov    %edx,(%eax)
  802c87:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8a:	8b 00                	mov    (%eax),%eax
  802c8c:	85 c0                	test   %eax,%eax
  802c8e:	74 0d                	je     802c9d <insert_sorted_with_merge_freeList+0x441>
  802c90:	a1 48 41 80 00       	mov    0x804148,%eax
  802c95:	8b 55 08             	mov    0x8(%ebp),%edx
  802c98:	89 50 04             	mov    %edx,0x4(%eax)
  802c9b:	eb 08                	jmp    802ca5 <insert_sorted_with_merge_freeList+0x449>
  802c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca8:	a3 48 41 80 00       	mov    %eax,0x804148
  802cad:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cb7:	a1 54 41 80 00       	mov    0x804154,%eax
  802cbc:	40                   	inc    %eax
  802cbd:	a3 54 41 80 00       	mov    %eax,0x804154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  802cc2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802cc6:	75 17                	jne    802cdf <insert_sorted_with_merge_freeList+0x483>
  802cc8:	83 ec 04             	sub    $0x4,%esp
  802ccb:	68 f4 3a 80 00       	push   $0x803af4
  802cd0:	68 5d 01 00 00       	push   $0x15d
  802cd5:	68 17 3b 80 00       	push   $0x803b17
  802cda:	e8 a3 d5 ff ff       	call   800282 <_panic>
  802cdf:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ce5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ce8:	89 10                	mov    %edx,(%eax)
  802cea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ced:	8b 00                	mov    (%eax),%eax
  802cef:	85 c0                	test   %eax,%eax
  802cf1:	74 0d                	je     802d00 <insert_sorted_with_merge_freeList+0x4a4>
  802cf3:	a1 48 41 80 00       	mov    0x804148,%eax
  802cf8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802cfb:	89 50 04             	mov    %edx,0x4(%eax)
  802cfe:	eb 08                	jmp    802d08 <insert_sorted_with_merge_freeList+0x4ac>
  802d00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d03:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d0b:	a3 48 41 80 00       	mov    %eax,0x804148
  802d10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d13:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d1a:	a1 54 41 80 00       	mov    0x804154,%eax
  802d1f:	40                   	inc    %eax
  802d20:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802d25:	e9 78 02 00 00       	jmp    802fa2 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2d:	8b 50 08             	mov    0x8(%eax),%edx
  802d30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d33:	8b 40 0c             	mov    0xc(%eax),%eax
  802d36:	01 c2                	add    %eax,%edx
  802d38:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3b:	8b 40 08             	mov    0x8(%eax),%eax
  802d3e:	39 c2                	cmp    %eax,%edx
  802d40:	0f 83 b8 00 00 00    	jae    802dfe <insert_sorted_with_merge_freeList+0x5a2>
  802d46:	8b 45 08             	mov    0x8(%ebp),%eax
  802d49:	8b 50 08             	mov    0x8(%eax),%edx
  802d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4f:	8b 40 0c             	mov    0xc(%eax),%eax
  802d52:	01 c2                	add    %eax,%edx
  802d54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d57:	8b 40 08             	mov    0x8(%eax),%eax
  802d5a:	39 c2                	cmp    %eax,%edx
  802d5c:	0f 85 9c 00 00 00    	jne    802dfe <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  802d62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d65:	8b 50 0c             	mov    0xc(%eax),%edx
  802d68:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d6e:	01 c2                	add    %eax,%edx
  802d70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d73:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  802d76:	8b 45 08             	mov    0x8(%ebp),%eax
  802d79:	8b 50 08             	mov    0x8(%eax),%edx
  802d7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d7f:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  802d82:	8b 45 08             	mov    0x8(%ebp),%eax
  802d85:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802d96:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d9a:	75 17                	jne    802db3 <insert_sorted_with_merge_freeList+0x557>
  802d9c:	83 ec 04             	sub    $0x4,%esp
  802d9f:	68 f4 3a 80 00       	push   $0x803af4
  802da4:	68 67 01 00 00       	push   $0x167
  802da9:	68 17 3b 80 00       	push   $0x803b17
  802dae:	e8 cf d4 ff ff       	call   800282 <_panic>
  802db3:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802db9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbc:	89 10                	mov    %edx,(%eax)
  802dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc1:	8b 00                	mov    (%eax),%eax
  802dc3:	85 c0                	test   %eax,%eax
  802dc5:	74 0d                	je     802dd4 <insert_sorted_with_merge_freeList+0x578>
  802dc7:	a1 48 41 80 00       	mov    0x804148,%eax
  802dcc:	8b 55 08             	mov    0x8(%ebp),%edx
  802dcf:	89 50 04             	mov    %edx,0x4(%eax)
  802dd2:	eb 08                	jmp    802ddc <insert_sorted_with_merge_freeList+0x580>
  802dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddf:	a3 48 41 80 00       	mov    %eax,0x804148
  802de4:	8b 45 08             	mov    0x8(%ebp),%eax
  802de7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dee:	a1 54 41 80 00       	mov    0x804154,%eax
  802df3:	40                   	inc    %eax
  802df4:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802df9:	e9 a4 01 00 00       	jmp    802fa2 <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802dfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e01:	8b 50 08             	mov    0x8(%eax),%edx
  802e04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e07:	8b 40 0c             	mov    0xc(%eax),%eax
  802e0a:	01 c2                	add    %eax,%edx
  802e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0f:	8b 40 08             	mov    0x8(%eax),%eax
  802e12:	39 c2                	cmp    %eax,%edx
  802e14:	0f 85 ac 00 00 00    	jne    802ec6 <insert_sorted_with_merge_freeList+0x66a>
  802e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1d:	8b 50 08             	mov    0x8(%eax),%edx
  802e20:	8b 45 08             	mov    0x8(%ebp),%eax
  802e23:	8b 40 0c             	mov    0xc(%eax),%eax
  802e26:	01 c2                	add    %eax,%edx
  802e28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e2b:	8b 40 08             	mov    0x8(%eax),%eax
  802e2e:	39 c2                	cmp    %eax,%edx
  802e30:	0f 83 90 00 00 00    	jae    802ec6 <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  802e36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e39:	8b 50 0c             	mov    0xc(%eax),%edx
  802e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e42:	01 c2                	add    %eax,%edx
  802e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e47:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  802e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  802e54:	8b 45 08             	mov    0x8(%ebp),%eax
  802e57:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e5e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e62:	75 17                	jne    802e7b <insert_sorted_with_merge_freeList+0x61f>
  802e64:	83 ec 04             	sub    $0x4,%esp
  802e67:	68 f4 3a 80 00       	push   $0x803af4
  802e6c:	68 70 01 00 00       	push   $0x170
  802e71:	68 17 3b 80 00       	push   $0x803b17
  802e76:	e8 07 d4 ff ff       	call   800282 <_panic>
  802e7b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e81:	8b 45 08             	mov    0x8(%ebp),%eax
  802e84:	89 10                	mov    %edx,(%eax)
  802e86:	8b 45 08             	mov    0x8(%ebp),%eax
  802e89:	8b 00                	mov    (%eax),%eax
  802e8b:	85 c0                	test   %eax,%eax
  802e8d:	74 0d                	je     802e9c <insert_sorted_with_merge_freeList+0x640>
  802e8f:	a1 48 41 80 00       	mov    0x804148,%eax
  802e94:	8b 55 08             	mov    0x8(%ebp),%edx
  802e97:	89 50 04             	mov    %edx,0x4(%eax)
  802e9a:	eb 08                	jmp    802ea4 <insert_sorted_with_merge_freeList+0x648>
  802e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea7:	a3 48 41 80 00       	mov    %eax,0x804148
  802eac:	8b 45 08             	mov    0x8(%ebp),%eax
  802eaf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eb6:	a1 54 41 80 00       	mov    0x804154,%eax
  802ebb:	40                   	inc    %eax
  802ebc:	a3 54 41 80 00       	mov    %eax,0x804154
	      break;
  802ec1:	e9 dc 00 00 00       	jmp    802fa2 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec9:	8b 50 08             	mov    0x8(%eax),%edx
  802ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecf:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed2:	01 c2                	add    %eax,%edx
  802ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed7:	8b 40 08             	mov    0x8(%eax),%eax
  802eda:	39 c2                	cmp    %eax,%edx
  802edc:	0f 83 88 00 00 00    	jae    802f6a <insert_sorted_with_merge_freeList+0x70e>
  802ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee5:	8b 50 08             	mov    0x8(%eax),%edx
  802ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  802eeb:	8b 40 0c             	mov    0xc(%eax),%eax
  802eee:	01 c2                	add    %eax,%edx
  802ef0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ef3:	8b 40 08             	mov    0x8(%eax),%eax
  802ef6:	39 c2                	cmp    %eax,%edx
  802ef8:	73 70                	jae    802f6a <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  802efa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802efe:	74 06                	je     802f06 <insert_sorted_with_merge_freeList+0x6aa>
  802f00:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f04:	75 17                	jne    802f1d <insert_sorted_with_merge_freeList+0x6c1>
  802f06:	83 ec 04             	sub    $0x4,%esp
  802f09:	68 54 3b 80 00       	push   $0x803b54
  802f0e:	68 75 01 00 00       	push   $0x175
  802f13:	68 17 3b 80 00       	push   $0x803b17
  802f18:	e8 65 d3 ff ff       	call   800282 <_panic>
  802f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f20:	8b 10                	mov    (%eax),%edx
  802f22:	8b 45 08             	mov    0x8(%ebp),%eax
  802f25:	89 10                	mov    %edx,(%eax)
  802f27:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2a:	8b 00                	mov    (%eax),%eax
  802f2c:	85 c0                	test   %eax,%eax
  802f2e:	74 0b                	je     802f3b <insert_sorted_with_merge_freeList+0x6df>
  802f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f33:	8b 00                	mov    (%eax),%eax
  802f35:	8b 55 08             	mov    0x8(%ebp),%edx
  802f38:	89 50 04             	mov    %edx,0x4(%eax)
  802f3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3e:	8b 55 08             	mov    0x8(%ebp),%edx
  802f41:	89 10                	mov    %edx,(%eax)
  802f43:	8b 45 08             	mov    0x8(%ebp),%eax
  802f46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f49:	89 50 04             	mov    %edx,0x4(%eax)
  802f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4f:	8b 00                	mov    (%eax),%eax
  802f51:	85 c0                	test   %eax,%eax
  802f53:	75 08                	jne    802f5d <insert_sorted_with_merge_freeList+0x701>
  802f55:	8b 45 08             	mov    0x8(%ebp),%eax
  802f58:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f5d:	a1 44 41 80 00       	mov    0x804144,%eax
  802f62:	40                   	inc    %eax
  802f63:	a3 44 41 80 00       	mov    %eax,0x804144
	      break;
  802f68:	eb 38                	jmp    802fa2 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802f6a:	a1 40 41 80 00       	mov    0x804140,%eax
  802f6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f76:	74 07                	je     802f7f <insert_sorted_with_merge_freeList+0x723>
  802f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7b:	8b 00                	mov    (%eax),%eax
  802f7d:	eb 05                	jmp    802f84 <insert_sorted_with_merge_freeList+0x728>
  802f7f:	b8 00 00 00 00       	mov    $0x0,%eax
  802f84:	a3 40 41 80 00       	mov    %eax,0x804140
  802f89:	a1 40 41 80 00       	mov    0x804140,%eax
  802f8e:	85 c0                	test   %eax,%eax
  802f90:	0f 85 c3 fb ff ff    	jne    802b59 <insert_sorted_with_merge_freeList+0x2fd>
  802f96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f9a:	0f 85 b9 fb ff ff    	jne    802b59 <insert_sorted_with_merge_freeList+0x2fd>





}
  802fa0:	eb 00                	jmp    802fa2 <insert_sorted_with_merge_freeList+0x746>
  802fa2:	90                   	nop
  802fa3:	c9                   	leave  
  802fa4:	c3                   	ret    
  802fa5:	66 90                	xchg   %ax,%ax
  802fa7:	90                   	nop

00802fa8 <__udivdi3>:
  802fa8:	55                   	push   %ebp
  802fa9:	57                   	push   %edi
  802faa:	56                   	push   %esi
  802fab:	53                   	push   %ebx
  802fac:	83 ec 1c             	sub    $0x1c,%esp
  802faf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802fb3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802fb7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802fbb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802fbf:	89 ca                	mov    %ecx,%edx
  802fc1:	89 f8                	mov    %edi,%eax
  802fc3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802fc7:	85 f6                	test   %esi,%esi
  802fc9:	75 2d                	jne    802ff8 <__udivdi3+0x50>
  802fcb:	39 cf                	cmp    %ecx,%edi
  802fcd:	77 65                	ja     803034 <__udivdi3+0x8c>
  802fcf:	89 fd                	mov    %edi,%ebp
  802fd1:	85 ff                	test   %edi,%edi
  802fd3:	75 0b                	jne    802fe0 <__udivdi3+0x38>
  802fd5:	b8 01 00 00 00       	mov    $0x1,%eax
  802fda:	31 d2                	xor    %edx,%edx
  802fdc:	f7 f7                	div    %edi
  802fde:	89 c5                	mov    %eax,%ebp
  802fe0:	31 d2                	xor    %edx,%edx
  802fe2:	89 c8                	mov    %ecx,%eax
  802fe4:	f7 f5                	div    %ebp
  802fe6:	89 c1                	mov    %eax,%ecx
  802fe8:	89 d8                	mov    %ebx,%eax
  802fea:	f7 f5                	div    %ebp
  802fec:	89 cf                	mov    %ecx,%edi
  802fee:	89 fa                	mov    %edi,%edx
  802ff0:	83 c4 1c             	add    $0x1c,%esp
  802ff3:	5b                   	pop    %ebx
  802ff4:	5e                   	pop    %esi
  802ff5:	5f                   	pop    %edi
  802ff6:	5d                   	pop    %ebp
  802ff7:	c3                   	ret    
  802ff8:	39 ce                	cmp    %ecx,%esi
  802ffa:	77 28                	ja     803024 <__udivdi3+0x7c>
  802ffc:	0f bd fe             	bsr    %esi,%edi
  802fff:	83 f7 1f             	xor    $0x1f,%edi
  803002:	75 40                	jne    803044 <__udivdi3+0x9c>
  803004:	39 ce                	cmp    %ecx,%esi
  803006:	72 0a                	jb     803012 <__udivdi3+0x6a>
  803008:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80300c:	0f 87 9e 00 00 00    	ja     8030b0 <__udivdi3+0x108>
  803012:	b8 01 00 00 00       	mov    $0x1,%eax
  803017:	89 fa                	mov    %edi,%edx
  803019:	83 c4 1c             	add    $0x1c,%esp
  80301c:	5b                   	pop    %ebx
  80301d:	5e                   	pop    %esi
  80301e:	5f                   	pop    %edi
  80301f:	5d                   	pop    %ebp
  803020:	c3                   	ret    
  803021:	8d 76 00             	lea    0x0(%esi),%esi
  803024:	31 ff                	xor    %edi,%edi
  803026:	31 c0                	xor    %eax,%eax
  803028:	89 fa                	mov    %edi,%edx
  80302a:	83 c4 1c             	add    $0x1c,%esp
  80302d:	5b                   	pop    %ebx
  80302e:	5e                   	pop    %esi
  80302f:	5f                   	pop    %edi
  803030:	5d                   	pop    %ebp
  803031:	c3                   	ret    
  803032:	66 90                	xchg   %ax,%ax
  803034:	89 d8                	mov    %ebx,%eax
  803036:	f7 f7                	div    %edi
  803038:	31 ff                	xor    %edi,%edi
  80303a:	89 fa                	mov    %edi,%edx
  80303c:	83 c4 1c             	add    $0x1c,%esp
  80303f:	5b                   	pop    %ebx
  803040:	5e                   	pop    %esi
  803041:	5f                   	pop    %edi
  803042:	5d                   	pop    %ebp
  803043:	c3                   	ret    
  803044:	bd 20 00 00 00       	mov    $0x20,%ebp
  803049:	89 eb                	mov    %ebp,%ebx
  80304b:	29 fb                	sub    %edi,%ebx
  80304d:	89 f9                	mov    %edi,%ecx
  80304f:	d3 e6                	shl    %cl,%esi
  803051:	89 c5                	mov    %eax,%ebp
  803053:	88 d9                	mov    %bl,%cl
  803055:	d3 ed                	shr    %cl,%ebp
  803057:	89 e9                	mov    %ebp,%ecx
  803059:	09 f1                	or     %esi,%ecx
  80305b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80305f:	89 f9                	mov    %edi,%ecx
  803061:	d3 e0                	shl    %cl,%eax
  803063:	89 c5                	mov    %eax,%ebp
  803065:	89 d6                	mov    %edx,%esi
  803067:	88 d9                	mov    %bl,%cl
  803069:	d3 ee                	shr    %cl,%esi
  80306b:	89 f9                	mov    %edi,%ecx
  80306d:	d3 e2                	shl    %cl,%edx
  80306f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803073:	88 d9                	mov    %bl,%cl
  803075:	d3 e8                	shr    %cl,%eax
  803077:	09 c2                	or     %eax,%edx
  803079:	89 d0                	mov    %edx,%eax
  80307b:	89 f2                	mov    %esi,%edx
  80307d:	f7 74 24 0c          	divl   0xc(%esp)
  803081:	89 d6                	mov    %edx,%esi
  803083:	89 c3                	mov    %eax,%ebx
  803085:	f7 e5                	mul    %ebp
  803087:	39 d6                	cmp    %edx,%esi
  803089:	72 19                	jb     8030a4 <__udivdi3+0xfc>
  80308b:	74 0b                	je     803098 <__udivdi3+0xf0>
  80308d:	89 d8                	mov    %ebx,%eax
  80308f:	31 ff                	xor    %edi,%edi
  803091:	e9 58 ff ff ff       	jmp    802fee <__udivdi3+0x46>
  803096:	66 90                	xchg   %ax,%ax
  803098:	8b 54 24 08          	mov    0x8(%esp),%edx
  80309c:	89 f9                	mov    %edi,%ecx
  80309e:	d3 e2                	shl    %cl,%edx
  8030a0:	39 c2                	cmp    %eax,%edx
  8030a2:	73 e9                	jae    80308d <__udivdi3+0xe5>
  8030a4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8030a7:	31 ff                	xor    %edi,%edi
  8030a9:	e9 40 ff ff ff       	jmp    802fee <__udivdi3+0x46>
  8030ae:	66 90                	xchg   %ax,%ax
  8030b0:	31 c0                	xor    %eax,%eax
  8030b2:	e9 37 ff ff ff       	jmp    802fee <__udivdi3+0x46>
  8030b7:	90                   	nop

008030b8 <__umoddi3>:
  8030b8:	55                   	push   %ebp
  8030b9:	57                   	push   %edi
  8030ba:	56                   	push   %esi
  8030bb:	53                   	push   %ebx
  8030bc:	83 ec 1c             	sub    $0x1c,%esp
  8030bf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8030c3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8030c7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8030cb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8030cf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8030d3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8030d7:	89 f3                	mov    %esi,%ebx
  8030d9:	89 fa                	mov    %edi,%edx
  8030db:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8030df:	89 34 24             	mov    %esi,(%esp)
  8030e2:	85 c0                	test   %eax,%eax
  8030e4:	75 1a                	jne    803100 <__umoddi3+0x48>
  8030e6:	39 f7                	cmp    %esi,%edi
  8030e8:	0f 86 a2 00 00 00    	jbe    803190 <__umoddi3+0xd8>
  8030ee:	89 c8                	mov    %ecx,%eax
  8030f0:	89 f2                	mov    %esi,%edx
  8030f2:	f7 f7                	div    %edi
  8030f4:	89 d0                	mov    %edx,%eax
  8030f6:	31 d2                	xor    %edx,%edx
  8030f8:	83 c4 1c             	add    $0x1c,%esp
  8030fb:	5b                   	pop    %ebx
  8030fc:	5e                   	pop    %esi
  8030fd:	5f                   	pop    %edi
  8030fe:	5d                   	pop    %ebp
  8030ff:	c3                   	ret    
  803100:	39 f0                	cmp    %esi,%eax
  803102:	0f 87 ac 00 00 00    	ja     8031b4 <__umoddi3+0xfc>
  803108:	0f bd e8             	bsr    %eax,%ebp
  80310b:	83 f5 1f             	xor    $0x1f,%ebp
  80310e:	0f 84 ac 00 00 00    	je     8031c0 <__umoddi3+0x108>
  803114:	bf 20 00 00 00       	mov    $0x20,%edi
  803119:	29 ef                	sub    %ebp,%edi
  80311b:	89 fe                	mov    %edi,%esi
  80311d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803121:	89 e9                	mov    %ebp,%ecx
  803123:	d3 e0                	shl    %cl,%eax
  803125:	89 d7                	mov    %edx,%edi
  803127:	89 f1                	mov    %esi,%ecx
  803129:	d3 ef                	shr    %cl,%edi
  80312b:	09 c7                	or     %eax,%edi
  80312d:	89 e9                	mov    %ebp,%ecx
  80312f:	d3 e2                	shl    %cl,%edx
  803131:	89 14 24             	mov    %edx,(%esp)
  803134:	89 d8                	mov    %ebx,%eax
  803136:	d3 e0                	shl    %cl,%eax
  803138:	89 c2                	mov    %eax,%edx
  80313a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80313e:	d3 e0                	shl    %cl,%eax
  803140:	89 44 24 04          	mov    %eax,0x4(%esp)
  803144:	8b 44 24 08          	mov    0x8(%esp),%eax
  803148:	89 f1                	mov    %esi,%ecx
  80314a:	d3 e8                	shr    %cl,%eax
  80314c:	09 d0                	or     %edx,%eax
  80314e:	d3 eb                	shr    %cl,%ebx
  803150:	89 da                	mov    %ebx,%edx
  803152:	f7 f7                	div    %edi
  803154:	89 d3                	mov    %edx,%ebx
  803156:	f7 24 24             	mull   (%esp)
  803159:	89 c6                	mov    %eax,%esi
  80315b:	89 d1                	mov    %edx,%ecx
  80315d:	39 d3                	cmp    %edx,%ebx
  80315f:	0f 82 87 00 00 00    	jb     8031ec <__umoddi3+0x134>
  803165:	0f 84 91 00 00 00    	je     8031fc <__umoddi3+0x144>
  80316b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80316f:	29 f2                	sub    %esi,%edx
  803171:	19 cb                	sbb    %ecx,%ebx
  803173:	89 d8                	mov    %ebx,%eax
  803175:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803179:	d3 e0                	shl    %cl,%eax
  80317b:	89 e9                	mov    %ebp,%ecx
  80317d:	d3 ea                	shr    %cl,%edx
  80317f:	09 d0                	or     %edx,%eax
  803181:	89 e9                	mov    %ebp,%ecx
  803183:	d3 eb                	shr    %cl,%ebx
  803185:	89 da                	mov    %ebx,%edx
  803187:	83 c4 1c             	add    $0x1c,%esp
  80318a:	5b                   	pop    %ebx
  80318b:	5e                   	pop    %esi
  80318c:	5f                   	pop    %edi
  80318d:	5d                   	pop    %ebp
  80318e:	c3                   	ret    
  80318f:	90                   	nop
  803190:	89 fd                	mov    %edi,%ebp
  803192:	85 ff                	test   %edi,%edi
  803194:	75 0b                	jne    8031a1 <__umoddi3+0xe9>
  803196:	b8 01 00 00 00       	mov    $0x1,%eax
  80319b:	31 d2                	xor    %edx,%edx
  80319d:	f7 f7                	div    %edi
  80319f:	89 c5                	mov    %eax,%ebp
  8031a1:	89 f0                	mov    %esi,%eax
  8031a3:	31 d2                	xor    %edx,%edx
  8031a5:	f7 f5                	div    %ebp
  8031a7:	89 c8                	mov    %ecx,%eax
  8031a9:	f7 f5                	div    %ebp
  8031ab:	89 d0                	mov    %edx,%eax
  8031ad:	e9 44 ff ff ff       	jmp    8030f6 <__umoddi3+0x3e>
  8031b2:	66 90                	xchg   %ax,%ax
  8031b4:	89 c8                	mov    %ecx,%eax
  8031b6:	89 f2                	mov    %esi,%edx
  8031b8:	83 c4 1c             	add    $0x1c,%esp
  8031bb:	5b                   	pop    %ebx
  8031bc:	5e                   	pop    %esi
  8031bd:	5f                   	pop    %edi
  8031be:	5d                   	pop    %ebp
  8031bf:	c3                   	ret    
  8031c0:	3b 04 24             	cmp    (%esp),%eax
  8031c3:	72 06                	jb     8031cb <__umoddi3+0x113>
  8031c5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8031c9:	77 0f                	ja     8031da <__umoddi3+0x122>
  8031cb:	89 f2                	mov    %esi,%edx
  8031cd:	29 f9                	sub    %edi,%ecx
  8031cf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8031d3:	89 14 24             	mov    %edx,(%esp)
  8031d6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8031da:	8b 44 24 04          	mov    0x4(%esp),%eax
  8031de:	8b 14 24             	mov    (%esp),%edx
  8031e1:	83 c4 1c             	add    $0x1c,%esp
  8031e4:	5b                   	pop    %ebx
  8031e5:	5e                   	pop    %esi
  8031e6:	5f                   	pop    %edi
  8031e7:	5d                   	pop    %ebp
  8031e8:	c3                   	ret    
  8031e9:	8d 76 00             	lea    0x0(%esi),%esi
  8031ec:	2b 04 24             	sub    (%esp),%eax
  8031ef:	19 fa                	sbb    %edi,%edx
  8031f1:	89 d1                	mov    %edx,%ecx
  8031f3:	89 c6                	mov    %eax,%esi
  8031f5:	e9 71 ff ff ff       	jmp    80316b <__umoddi3+0xb3>
  8031fa:	66 90                	xchg   %ax,%ax
  8031fc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803200:	72 ea                	jb     8031ec <__umoddi3+0x134>
  803202:	89 d9                	mov    %ebx,%ecx
  803204:	e9 62 ff ff ff       	jmp    80316b <__umoddi3+0xb3>
