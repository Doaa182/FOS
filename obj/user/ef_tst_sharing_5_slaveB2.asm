
obj/user/ef_tst_sharing_5_slaveB2:     file format elf32-i386


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
  800031:	e8 77 01 00 00       	call   8001ad <libmain>
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
  80008c:	68 40 33 80 00       	push   $0x803340
  800091:	6a 12                	push   $0x12
  800093:	68 5c 33 80 00       	push   $0x80335c
  800098:	e8 4c 02 00 00       	call   8002e9 <_panic>
	}
	uint32 *z;
	z = sget(sys_getparentenvid(),"z");
  80009d:	e8 ac 1b 00 00       	call   801c4e <sys_getparentenvid>
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	68 7c 33 80 00       	push   $0x80337c
  8000aa:	50                   	push   %eax
  8000ab:	e8 80 16 00 00       	call   801730 <sget>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B2 env used z (getSharedObject)\n");
  8000b6:	83 ec 0c             	sub    $0xc,%esp
  8000b9:	68 80 33 80 00       	push   $0x803380
  8000be:	e8 da 04 00 00       	call   80059d <cprintf>
  8000c3:	83 c4 10             	add    $0x10,%esp

	cprintf("Slave B2 please be patient ...\n");
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	68 a8 33 80 00       	push   $0x8033a8
  8000ce:	e8 ca 04 00 00       	call   80059d <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp

	env_sleep(9000);
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 28 23 00 00       	push   $0x2328
  8000de:	e8 29 2f 00 00       	call   80300c <env_sleep>
  8000e3:	83 c4 10             	add    $0x10,%esp
	int freeFrames = sys_calculate_free_frames() ;
  8000e6:	e8 6a 18 00 00       	call   801955 <sys_calculate_free_frames>
  8000eb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(z);
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	ff 75 ec             	pushl  -0x14(%ebp)
  8000f4:	e8 fc 16 00 00       	call   8017f5 <sfree>
  8000f9:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B2 env removed z\n");
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	68 c8 33 80 00       	push   $0x8033c8
  800104:	e8 94 04 00 00       	call   80059d <cprintf>
  800109:	83 c4 10             	add    $0x10,%esp

	if ((sys_calculate_free_frames() - freeFrames) !=  4) panic("wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table + 1 frame for z\nframes_storage of z: should be cleared now\n");
  80010c:	e8 44 18 00 00       	call   801955 <sys_calculate_free_frames>
  800111:	89 c2                	mov    %eax,%edx
  800113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800116:	29 c2                	sub    %eax,%edx
  800118:	89 d0                	mov    %edx,%eax
  80011a:	83 f8 04             	cmp    $0x4,%eax
  80011d:	74 14                	je     800133 <_main+0xfb>
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	68 e0 33 80 00       	push   $0x8033e0
  800127:	6a 20                	push   $0x20
  800129:	68 5c 33 80 00       	push   $0x80335c
  80012e:	e8 b6 01 00 00       	call   8002e9 <_panic>

	//to ensure that the other environments completed successfully
	if (gettst()!=2) panic("test failed");
  800133:	e8 55 1c 00 00       	call   801d8d <gettst>
  800138:	83 f8 02             	cmp    $0x2,%eax
  80013b:	74 14                	je     800151 <_main+0x119>
  80013d:	83 ec 04             	sub    $0x4,%esp
  800140:	68 80 34 80 00       	push   $0x803480
  800145:	6a 23                	push   $0x23
  800147:	68 5c 33 80 00       	push   $0x80335c
  80014c:	e8 98 01 00 00       	call   8002e9 <_panic>

	cprintf("Step B completed successfully!!\n\n\n");
  800151:	83 ec 0c             	sub    $0xc,%esp
  800154:	68 8c 34 80 00       	push   $0x80348c
  800159:	e8 3f 04 00 00       	call   80059d <cprintf>
  80015e:	83 c4 10             	add    $0x10,%esp
	cprintf("Congratulations!! Test of freeSharedObjects [5] completed successfully!!\n\n\n");
  800161:	83 ec 0c             	sub    $0xc,%esp
  800164:	68 b0 34 80 00       	push   $0x8034b0
  800169:	e8 2f 04 00 00       	call   80059d <cprintf>
  80016e:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800171:	e8 d8 1a 00 00       	call   801c4e <sys_getparentenvid>
  800176:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(parentenvID > 0)
  800179:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80017d:	7e 2b                	jle    8001aa <_main+0x172>
	{
		//Get the check-finishing counter
		int *finish = NULL;
  80017f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		finish = sget(parentenvID, "finish_children") ;
  800186:	83 ec 08             	sub    $0x8,%esp
  800189:	68 fc 34 80 00       	push   $0x8034fc
  80018e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800191:	e8 9a 15 00 00       	call   801730 <sget>
  800196:	83 c4 10             	add    $0x10,%esp
  800199:	89 45 e0             	mov    %eax,-0x20(%ebp)
		(*finish)++ ;
  80019c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80019f:	8b 00                	mov    (%eax),%eax
  8001a1:	8d 50 01             	lea    0x1(%eax),%edx
  8001a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001a7:	89 10                	mov    %edx,(%eax)
	}
	return;
  8001a9:	90                   	nop
  8001aa:	90                   	nop
}
  8001ab:	c9                   	leave  
  8001ac:	c3                   	ret    

008001ad <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001ad:	55                   	push   %ebp
  8001ae:	89 e5                	mov    %esp,%ebp
  8001b0:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001b3:	e8 7d 1a 00 00       	call   801c35 <sys_getenvindex>
  8001b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001be:	89 d0                	mov    %edx,%eax
  8001c0:	c1 e0 03             	shl    $0x3,%eax
  8001c3:	01 d0                	add    %edx,%eax
  8001c5:	01 c0                	add    %eax,%eax
  8001c7:	01 d0                	add    %edx,%eax
  8001c9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001d0:	01 d0                	add    %edx,%eax
  8001d2:	c1 e0 04             	shl    $0x4,%eax
  8001d5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001da:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001df:	a1 20 40 80 00       	mov    0x804020,%eax
  8001e4:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001ea:	84 c0                	test   %al,%al
  8001ec:	74 0f                	je     8001fd <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001ee:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f3:	05 5c 05 00 00       	add    $0x55c,%eax
  8001f8:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800201:	7e 0a                	jle    80020d <libmain+0x60>
		binaryname = argv[0];
  800203:	8b 45 0c             	mov    0xc(%ebp),%eax
  800206:	8b 00                	mov    (%eax),%eax
  800208:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80020d:	83 ec 08             	sub    $0x8,%esp
  800210:	ff 75 0c             	pushl  0xc(%ebp)
  800213:	ff 75 08             	pushl  0x8(%ebp)
  800216:	e8 1d fe ff ff       	call   800038 <_main>
  80021b:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80021e:	e8 1f 18 00 00       	call   801a42 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800223:	83 ec 0c             	sub    $0xc,%esp
  800226:	68 24 35 80 00       	push   $0x803524
  80022b:	e8 6d 03 00 00       	call   80059d <cprintf>
  800230:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800233:	a1 20 40 80 00       	mov    0x804020,%eax
  800238:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80023e:	a1 20 40 80 00       	mov    0x804020,%eax
  800243:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800249:	83 ec 04             	sub    $0x4,%esp
  80024c:	52                   	push   %edx
  80024d:	50                   	push   %eax
  80024e:	68 4c 35 80 00       	push   $0x80354c
  800253:	e8 45 03 00 00       	call   80059d <cprintf>
  800258:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80025b:	a1 20 40 80 00       	mov    0x804020,%eax
  800260:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800266:	a1 20 40 80 00       	mov    0x804020,%eax
  80026b:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800271:	a1 20 40 80 00       	mov    0x804020,%eax
  800276:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80027c:	51                   	push   %ecx
  80027d:	52                   	push   %edx
  80027e:	50                   	push   %eax
  80027f:	68 74 35 80 00       	push   $0x803574
  800284:	e8 14 03 00 00       	call   80059d <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80028c:	a1 20 40 80 00       	mov    0x804020,%eax
  800291:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800297:	83 ec 08             	sub    $0x8,%esp
  80029a:	50                   	push   %eax
  80029b:	68 cc 35 80 00       	push   $0x8035cc
  8002a0:	e8 f8 02 00 00       	call   80059d <cprintf>
  8002a5:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002a8:	83 ec 0c             	sub    $0xc,%esp
  8002ab:	68 24 35 80 00       	push   $0x803524
  8002b0:	e8 e8 02 00 00       	call   80059d <cprintf>
  8002b5:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002b8:	e8 9f 17 00 00       	call   801a5c <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002bd:	e8 19 00 00 00       	call   8002db <exit>
}
  8002c2:	90                   	nop
  8002c3:	c9                   	leave  
  8002c4:	c3                   	ret    

008002c5 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002c5:	55                   	push   %ebp
  8002c6:	89 e5                	mov    %esp,%ebp
  8002c8:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002cb:	83 ec 0c             	sub    $0xc,%esp
  8002ce:	6a 00                	push   $0x0
  8002d0:	e8 2c 19 00 00       	call   801c01 <sys_destroy_env>
  8002d5:	83 c4 10             	add    $0x10,%esp
}
  8002d8:	90                   	nop
  8002d9:	c9                   	leave  
  8002da:	c3                   	ret    

008002db <exit>:

void
exit(void)
{
  8002db:	55                   	push   %ebp
  8002dc:	89 e5                	mov    %esp,%ebp
  8002de:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002e1:	e8 81 19 00 00       	call   801c67 <sys_exit_env>
}
  8002e6:	90                   	nop
  8002e7:	c9                   	leave  
  8002e8:	c3                   	ret    

008002e9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002e9:	55                   	push   %ebp
  8002ea:	89 e5                	mov    %esp,%ebp
  8002ec:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002ef:	8d 45 10             	lea    0x10(%ebp),%eax
  8002f2:	83 c0 04             	add    $0x4,%eax
  8002f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002f8:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002fd:	85 c0                	test   %eax,%eax
  8002ff:	74 16                	je     800317 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800301:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800306:	83 ec 08             	sub    $0x8,%esp
  800309:	50                   	push   %eax
  80030a:	68 e0 35 80 00       	push   $0x8035e0
  80030f:	e8 89 02 00 00       	call   80059d <cprintf>
  800314:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800317:	a1 00 40 80 00       	mov    0x804000,%eax
  80031c:	ff 75 0c             	pushl  0xc(%ebp)
  80031f:	ff 75 08             	pushl  0x8(%ebp)
  800322:	50                   	push   %eax
  800323:	68 e5 35 80 00       	push   $0x8035e5
  800328:	e8 70 02 00 00       	call   80059d <cprintf>
  80032d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800330:	8b 45 10             	mov    0x10(%ebp),%eax
  800333:	83 ec 08             	sub    $0x8,%esp
  800336:	ff 75 f4             	pushl  -0xc(%ebp)
  800339:	50                   	push   %eax
  80033a:	e8 f3 01 00 00       	call   800532 <vcprintf>
  80033f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800342:	83 ec 08             	sub    $0x8,%esp
  800345:	6a 00                	push   $0x0
  800347:	68 01 36 80 00       	push   $0x803601
  80034c:	e8 e1 01 00 00       	call   800532 <vcprintf>
  800351:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800354:	e8 82 ff ff ff       	call   8002db <exit>

	// should not return here
	while (1) ;
  800359:	eb fe                	jmp    800359 <_panic+0x70>

0080035b <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80035b:	55                   	push   %ebp
  80035c:	89 e5                	mov    %esp,%ebp
  80035e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800361:	a1 20 40 80 00       	mov    0x804020,%eax
  800366:	8b 50 74             	mov    0x74(%eax),%edx
  800369:	8b 45 0c             	mov    0xc(%ebp),%eax
  80036c:	39 c2                	cmp    %eax,%edx
  80036e:	74 14                	je     800384 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800370:	83 ec 04             	sub    $0x4,%esp
  800373:	68 04 36 80 00       	push   $0x803604
  800378:	6a 26                	push   $0x26
  80037a:	68 50 36 80 00       	push   $0x803650
  80037f:	e8 65 ff ff ff       	call   8002e9 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800384:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80038b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800392:	e9 c2 00 00 00       	jmp    800459 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800397:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80039a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a4:	01 d0                	add    %edx,%eax
  8003a6:	8b 00                	mov    (%eax),%eax
  8003a8:	85 c0                	test   %eax,%eax
  8003aa:	75 08                	jne    8003b4 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8003ac:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003af:	e9 a2 00 00 00       	jmp    800456 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8003b4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003bb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003c2:	eb 69                	jmp    80042d <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003c4:	a1 20 40 80 00       	mov    0x804020,%eax
  8003c9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003d2:	89 d0                	mov    %edx,%eax
  8003d4:	01 c0                	add    %eax,%eax
  8003d6:	01 d0                	add    %edx,%eax
  8003d8:	c1 e0 03             	shl    $0x3,%eax
  8003db:	01 c8                	add    %ecx,%eax
  8003dd:	8a 40 04             	mov    0x4(%eax),%al
  8003e0:	84 c0                	test   %al,%al
  8003e2:	75 46                	jne    80042a <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003e4:	a1 20 40 80 00       	mov    0x804020,%eax
  8003e9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003ef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003f2:	89 d0                	mov    %edx,%eax
  8003f4:	01 c0                	add    %eax,%eax
  8003f6:	01 d0                	add    %edx,%eax
  8003f8:	c1 e0 03             	shl    $0x3,%eax
  8003fb:	01 c8                	add    %ecx,%eax
  8003fd:	8b 00                	mov    (%eax),%eax
  8003ff:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800402:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800405:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80040a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80040c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80040f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800416:	8b 45 08             	mov    0x8(%ebp),%eax
  800419:	01 c8                	add    %ecx,%eax
  80041b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80041d:	39 c2                	cmp    %eax,%edx
  80041f:	75 09                	jne    80042a <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800421:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800428:	eb 12                	jmp    80043c <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80042a:	ff 45 e8             	incl   -0x18(%ebp)
  80042d:	a1 20 40 80 00       	mov    0x804020,%eax
  800432:	8b 50 74             	mov    0x74(%eax),%edx
  800435:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800438:	39 c2                	cmp    %eax,%edx
  80043a:	77 88                	ja     8003c4 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80043c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800440:	75 14                	jne    800456 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800442:	83 ec 04             	sub    $0x4,%esp
  800445:	68 5c 36 80 00       	push   $0x80365c
  80044a:	6a 3a                	push   $0x3a
  80044c:	68 50 36 80 00       	push   $0x803650
  800451:	e8 93 fe ff ff       	call   8002e9 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800456:	ff 45 f0             	incl   -0x10(%ebp)
  800459:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80045c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80045f:	0f 8c 32 ff ff ff    	jl     800397 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800465:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80046c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800473:	eb 26                	jmp    80049b <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800475:	a1 20 40 80 00       	mov    0x804020,%eax
  80047a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800480:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800483:	89 d0                	mov    %edx,%eax
  800485:	01 c0                	add    %eax,%eax
  800487:	01 d0                	add    %edx,%eax
  800489:	c1 e0 03             	shl    $0x3,%eax
  80048c:	01 c8                	add    %ecx,%eax
  80048e:	8a 40 04             	mov    0x4(%eax),%al
  800491:	3c 01                	cmp    $0x1,%al
  800493:	75 03                	jne    800498 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800495:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800498:	ff 45 e0             	incl   -0x20(%ebp)
  80049b:	a1 20 40 80 00       	mov    0x804020,%eax
  8004a0:	8b 50 74             	mov    0x74(%eax),%edx
  8004a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004a6:	39 c2                	cmp    %eax,%edx
  8004a8:	77 cb                	ja     800475 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004ad:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004b0:	74 14                	je     8004c6 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8004b2:	83 ec 04             	sub    $0x4,%esp
  8004b5:	68 b0 36 80 00       	push   $0x8036b0
  8004ba:	6a 44                	push   $0x44
  8004bc:	68 50 36 80 00       	push   $0x803650
  8004c1:	e8 23 fe ff ff       	call   8002e9 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004c6:	90                   	nop
  8004c7:	c9                   	leave  
  8004c8:	c3                   	ret    

008004c9 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8004c9:	55                   	push   %ebp
  8004ca:	89 e5                	mov    %esp,%ebp
  8004cc:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d2:	8b 00                	mov    (%eax),%eax
  8004d4:	8d 48 01             	lea    0x1(%eax),%ecx
  8004d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004da:	89 0a                	mov    %ecx,(%edx)
  8004dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8004df:	88 d1                	mov    %dl,%cl
  8004e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004e4:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004eb:	8b 00                	mov    (%eax),%eax
  8004ed:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004f2:	75 2c                	jne    800520 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004f4:	a0 24 40 80 00       	mov    0x804024,%al
  8004f9:	0f b6 c0             	movzbl %al,%eax
  8004fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ff:	8b 12                	mov    (%edx),%edx
  800501:	89 d1                	mov    %edx,%ecx
  800503:	8b 55 0c             	mov    0xc(%ebp),%edx
  800506:	83 c2 08             	add    $0x8,%edx
  800509:	83 ec 04             	sub    $0x4,%esp
  80050c:	50                   	push   %eax
  80050d:	51                   	push   %ecx
  80050e:	52                   	push   %edx
  80050f:	e8 80 13 00 00       	call   801894 <sys_cputs>
  800514:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800517:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800520:	8b 45 0c             	mov    0xc(%ebp),%eax
  800523:	8b 40 04             	mov    0x4(%eax),%eax
  800526:	8d 50 01             	lea    0x1(%eax),%edx
  800529:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80052f:	90                   	nop
  800530:	c9                   	leave  
  800531:	c3                   	ret    

00800532 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800532:	55                   	push   %ebp
  800533:	89 e5                	mov    %esp,%ebp
  800535:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80053b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800542:	00 00 00 
	b.cnt = 0;
  800545:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80054c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80054f:	ff 75 0c             	pushl  0xc(%ebp)
  800552:	ff 75 08             	pushl  0x8(%ebp)
  800555:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80055b:	50                   	push   %eax
  80055c:	68 c9 04 80 00       	push   $0x8004c9
  800561:	e8 11 02 00 00       	call   800777 <vprintfmt>
  800566:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800569:	a0 24 40 80 00       	mov    0x804024,%al
  80056e:	0f b6 c0             	movzbl %al,%eax
  800571:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800577:	83 ec 04             	sub    $0x4,%esp
  80057a:	50                   	push   %eax
  80057b:	52                   	push   %edx
  80057c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800582:	83 c0 08             	add    $0x8,%eax
  800585:	50                   	push   %eax
  800586:	e8 09 13 00 00       	call   801894 <sys_cputs>
  80058b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80058e:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800595:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80059b:	c9                   	leave  
  80059c:	c3                   	ret    

0080059d <cprintf>:

int cprintf(const char *fmt, ...) {
  80059d:	55                   	push   %ebp
  80059e:	89 e5                	mov    %esp,%ebp
  8005a0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005a3:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8005aa:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b3:	83 ec 08             	sub    $0x8,%esp
  8005b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8005b9:	50                   	push   %eax
  8005ba:	e8 73 ff ff ff       	call   800532 <vcprintf>
  8005bf:	83 c4 10             	add    $0x10,%esp
  8005c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005c8:	c9                   	leave  
  8005c9:	c3                   	ret    

008005ca <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8005ca:	55                   	push   %ebp
  8005cb:	89 e5                	mov    %esp,%ebp
  8005cd:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005d0:	e8 6d 14 00 00       	call   801a42 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005d5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005db:	8b 45 08             	mov    0x8(%ebp),%eax
  8005de:	83 ec 08             	sub    $0x8,%esp
  8005e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8005e4:	50                   	push   %eax
  8005e5:	e8 48 ff ff ff       	call   800532 <vcprintf>
  8005ea:	83 c4 10             	add    $0x10,%esp
  8005ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005f0:	e8 67 14 00 00       	call   801a5c <sys_enable_interrupt>
	return cnt;
  8005f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005f8:	c9                   	leave  
  8005f9:	c3                   	ret    

008005fa <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005fa:	55                   	push   %ebp
  8005fb:	89 e5                	mov    %esp,%ebp
  8005fd:	53                   	push   %ebx
  8005fe:	83 ec 14             	sub    $0x14,%esp
  800601:	8b 45 10             	mov    0x10(%ebp),%eax
  800604:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800607:	8b 45 14             	mov    0x14(%ebp),%eax
  80060a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80060d:	8b 45 18             	mov    0x18(%ebp),%eax
  800610:	ba 00 00 00 00       	mov    $0x0,%edx
  800615:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800618:	77 55                	ja     80066f <printnum+0x75>
  80061a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80061d:	72 05                	jb     800624 <printnum+0x2a>
  80061f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800622:	77 4b                	ja     80066f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800624:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800627:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80062a:	8b 45 18             	mov    0x18(%ebp),%eax
  80062d:	ba 00 00 00 00       	mov    $0x0,%edx
  800632:	52                   	push   %edx
  800633:	50                   	push   %eax
  800634:	ff 75 f4             	pushl  -0xc(%ebp)
  800637:	ff 75 f0             	pushl  -0x10(%ebp)
  80063a:	e8 81 2a 00 00       	call   8030c0 <__udivdi3>
  80063f:	83 c4 10             	add    $0x10,%esp
  800642:	83 ec 04             	sub    $0x4,%esp
  800645:	ff 75 20             	pushl  0x20(%ebp)
  800648:	53                   	push   %ebx
  800649:	ff 75 18             	pushl  0x18(%ebp)
  80064c:	52                   	push   %edx
  80064d:	50                   	push   %eax
  80064e:	ff 75 0c             	pushl  0xc(%ebp)
  800651:	ff 75 08             	pushl  0x8(%ebp)
  800654:	e8 a1 ff ff ff       	call   8005fa <printnum>
  800659:	83 c4 20             	add    $0x20,%esp
  80065c:	eb 1a                	jmp    800678 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80065e:	83 ec 08             	sub    $0x8,%esp
  800661:	ff 75 0c             	pushl  0xc(%ebp)
  800664:	ff 75 20             	pushl  0x20(%ebp)
  800667:	8b 45 08             	mov    0x8(%ebp),%eax
  80066a:	ff d0                	call   *%eax
  80066c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80066f:	ff 4d 1c             	decl   0x1c(%ebp)
  800672:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800676:	7f e6                	jg     80065e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800678:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80067b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800680:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800683:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800686:	53                   	push   %ebx
  800687:	51                   	push   %ecx
  800688:	52                   	push   %edx
  800689:	50                   	push   %eax
  80068a:	e8 41 2b 00 00       	call   8031d0 <__umoddi3>
  80068f:	83 c4 10             	add    $0x10,%esp
  800692:	05 14 39 80 00       	add    $0x803914,%eax
  800697:	8a 00                	mov    (%eax),%al
  800699:	0f be c0             	movsbl %al,%eax
  80069c:	83 ec 08             	sub    $0x8,%esp
  80069f:	ff 75 0c             	pushl  0xc(%ebp)
  8006a2:	50                   	push   %eax
  8006a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a6:	ff d0                	call   *%eax
  8006a8:	83 c4 10             	add    $0x10,%esp
}
  8006ab:	90                   	nop
  8006ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006af:	c9                   	leave  
  8006b0:	c3                   	ret    

008006b1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006b1:	55                   	push   %ebp
  8006b2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006b4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006b8:	7e 1c                	jle    8006d6 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
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
  8006d4:	eb 40                	jmp    800716 <getuint+0x65>
	else if (lflag)
  8006d6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006da:	74 1e                	je     8006fa <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	8b 00                	mov    (%eax),%eax
  8006e1:	8d 50 04             	lea    0x4(%eax),%edx
  8006e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e7:	89 10                	mov    %edx,(%eax)
  8006e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ec:	8b 00                	mov    (%eax),%eax
  8006ee:	83 e8 04             	sub    $0x4,%eax
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f8:	eb 1c                	jmp    800716 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fd:	8b 00                	mov    (%eax),%eax
  8006ff:	8d 50 04             	lea    0x4(%eax),%edx
  800702:	8b 45 08             	mov    0x8(%ebp),%eax
  800705:	89 10                	mov    %edx,(%eax)
  800707:	8b 45 08             	mov    0x8(%ebp),%eax
  80070a:	8b 00                	mov    (%eax),%eax
  80070c:	83 e8 04             	sub    $0x4,%eax
  80070f:	8b 00                	mov    (%eax),%eax
  800711:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800716:	5d                   	pop    %ebp
  800717:	c3                   	ret    

00800718 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800718:	55                   	push   %ebp
  800719:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80071b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80071f:	7e 1c                	jle    80073d <getint+0x25>
		return va_arg(*ap, long long);
  800721:	8b 45 08             	mov    0x8(%ebp),%eax
  800724:	8b 00                	mov    (%eax),%eax
  800726:	8d 50 08             	lea    0x8(%eax),%edx
  800729:	8b 45 08             	mov    0x8(%ebp),%eax
  80072c:	89 10                	mov    %edx,(%eax)
  80072e:	8b 45 08             	mov    0x8(%ebp),%eax
  800731:	8b 00                	mov    (%eax),%eax
  800733:	83 e8 08             	sub    $0x8,%eax
  800736:	8b 50 04             	mov    0x4(%eax),%edx
  800739:	8b 00                	mov    (%eax),%eax
  80073b:	eb 38                	jmp    800775 <getint+0x5d>
	else if (lflag)
  80073d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800741:	74 1a                	je     80075d <getint+0x45>
		return va_arg(*ap, long);
  800743:	8b 45 08             	mov    0x8(%ebp),%eax
  800746:	8b 00                	mov    (%eax),%eax
  800748:	8d 50 04             	lea    0x4(%eax),%edx
  80074b:	8b 45 08             	mov    0x8(%ebp),%eax
  80074e:	89 10                	mov    %edx,(%eax)
  800750:	8b 45 08             	mov    0x8(%ebp),%eax
  800753:	8b 00                	mov    (%eax),%eax
  800755:	83 e8 04             	sub    $0x4,%eax
  800758:	8b 00                	mov    (%eax),%eax
  80075a:	99                   	cltd   
  80075b:	eb 18                	jmp    800775 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80075d:	8b 45 08             	mov    0x8(%ebp),%eax
  800760:	8b 00                	mov    (%eax),%eax
  800762:	8d 50 04             	lea    0x4(%eax),%edx
  800765:	8b 45 08             	mov    0x8(%ebp),%eax
  800768:	89 10                	mov    %edx,(%eax)
  80076a:	8b 45 08             	mov    0x8(%ebp),%eax
  80076d:	8b 00                	mov    (%eax),%eax
  80076f:	83 e8 04             	sub    $0x4,%eax
  800772:	8b 00                	mov    (%eax),%eax
  800774:	99                   	cltd   
}
  800775:	5d                   	pop    %ebp
  800776:	c3                   	ret    

00800777 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800777:	55                   	push   %ebp
  800778:	89 e5                	mov    %esp,%ebp
  80077a:	56                   	push   %esi
  80077b:	53                   	push   %ebx
  80077c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80077f:	eb 17                	jmp    800798 <vprintfmt+0x21>
			if (ch == '\0')
  800781:	85 db                	test   %ebx,%ebx
  800783:	0f 84 af 03 00 00    	je     800b38 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800789:	83 ec 08             	sub    $0x8,%esp
  80078c:	ff 75 0c             	pushl  0xc(%ebp)
  80078f:	53                   	push   %ebx
  800790:	8b 45 08             	mov    0x8(%ebp),%eax
  800793:	ff d0                	call   *%eax
  800795:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800798:	8b 45 10             	mov    0x10(%ebp),%eax
  80079b:	8d 50 01             	lea    0x1(%eax),%edx
  80079e:	89 55 10             	mov    %edx,0x10(%ebp)
  8007a1:	8a 00                	mov    (%eax),%al
  8007a3:	0f b6 d8             	movzbl %al,%ebx
  8007a6:	83 fb 25             	cmp    $0x25,%ebx
  8007a9:	75 d6                	jne    800781 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007ab:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007af:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007b6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007bd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007c4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ce:	8d 50 01             	lea    0x1(%eax),%edx
  8007d1:	89 55 10             	mov    %edx,0x10(%ebp)
  8007d4:	8a 00                	mov    (%eax),%al
  8007d6:	0f b6 d8             	movzbl %al,%ebx
  8007d9:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007dc:	83 f8 55             	cmp    $0x55,%eax
  8007df:	0f 87 2b 03 00 00    	ja     800b10 <vprintfmt+0x399>
  8007e5:	8b 04 85 38 39 80 00 	mov    0x803938(,%eax,4),%eax
  8007ec:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007ee:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007f2:	eb d7                	jmp    8007cb <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007f4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007f8:	eb d1                	jmp    8007cb <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007fa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800801:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800804:	89 d0                	mov    %edx,%eax
  800806:	c1 e0 02             	shl    $0x2,%eax
  800809:	01 d0                	add    %edx,%eax
  80080b:	01 c0                	add    %eax,%eax
  80080d:	01 d8                	add    %ebx,%eax
  80080f:	83 e8 30             	sub    $0x30,%eax
  800812:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800815:	8b 45 10             	mov    0x10(%ebp),%eax
  800818:	8a 00                	mov    (%eax),%al
  80081a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80081d:	83 fb 2f             	cmp    $0x2f,%ebx
  800820:	7e 3e                	jle    800860 <vprintfmt+0xe9>
  800822:	83 fb 39             	cmp    $0x39,%ebx
  800825:	7f 39                	jg     800860 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800827:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80082a:	eb d5                	jmp    800801 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80082c:	8b 45 14             	mov    0x14(%ebp),%eax
  80082f:	83 c0 04             	add    $0x4,%eax
  800832:	89 45 14             	mov    %eax,0x14(%ebp)
  800835:	8b 45 14             	mov    0x14(%ebp),%eax
  800838:	83 e8 04             	sub    $0x4,%eax
  80083b:	8b 00                	mov    (%eax),%eax
  80083d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800840:	eb 1f                	jmp    800861 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800842:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800846:	79 83                	jns    8007cb <vprintfmt+0x54>
				width = 0;
  800848:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80084f:	e9 77 ff ff ff       	jmp    8007cb <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800854:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80085b:	e9 6b ff ff ff       	jmp    8007cb <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800860:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800861:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800865:	0f 89 60 ff ff ff    	jns    8007cb <vprintfmt+0x54>
				width = precision, precision = -1;
  80086b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80086e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800871:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800878:	e9 4e ff ff ff       	jmp    8007cb <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80087d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800880:	e9 46 ff ff ff       	jmp    8007cb <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800885:	8b 45 14             	mov    0x14(%ebp),%eax
  800888:	83 c0 04             	add    $0x4,%eax
  80088b:	89 45 14             	mov    %eax,0x14(%ebp)
  80088e:	8b 45 14             	mov    0x14(%ebp),%eax
  800891:	83 e8 04             	sub    $0x4,%eax
  800894:	8b 00                	mov    (%eax),%eax
  800896:	83 ec 08             	sub    $0x8,%esp
  800899:	ff 75 0c             	pushl  0xc(%ebp)
  80089c:	50                   	push   %eax
  80089d:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a0:	ff d0                	call   *%eax
  8008a2:	83 c4 10             	add    $0x10,%esp
			break;
  8008a5:	e9 89 02 00 00       	jmp    800b33 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ad:	83 c0 04             	add    $0x4,%eax
  8008b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b6:	83 e8 04             	sub    $0x4,%eax
  8008b9:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008bb:	85 db                	test   %ebx,%ebx
  8008bd:	79 02                	jns    8008c1 <vprintfmt+0x14a>
				err = -err;
  8008bf:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008c1:	83 fb 64             	cmp    $0x64,%ebx
  8008c4:	7f 0b                	jg     8008d1 <vprintfmt+0x15a>
  8008c6:	8b 34 9d 80 37 80 00 	mov    0x803780(,%ebx,4),%esi
  8008cd:	85 f6                	test   %esi,%esi
  8008cf:	75 19                	jne    8008ea <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008d1:	53                   	push   %ebx
  8008d2:	68 25 39 80 00       	push   $0x803925
  8008d7:	ff 75 0c             	pushl  0xc(%ebp)
  8008da:	ff 75 08             	pushl  0x8(%ebp)
  8008dd:	e8 5e 02 00 00       	call   800b40 <printfmt>
  8008e2:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008e5:	e9 49 02 00 00       	jmp    800b33 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008ea:	56                   	push   %esi
  8008eb:	68 2e 39 80 00       	push   $0x80392e
  8008f0:	ff 75 0c             	pushl  0xc(%ebp)
  8008f3:	ff 75 08             	pushl  0x8(%ebp)
  8008f6:	e8 45 02 00 00       	call   800b40 <printfmt>
  8008fb:	83 c4 10             	add    $0x10,%esp
			break;
  8008fe:	e9 30 02 00 00       	jmp    800b33 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800903:	8b 45 14             	mov    0x14(%ebp),%eax
  800906:	83 c0 04             	add    $0x4,%eax
  800909:	89 45 14             	mov    %eax,0x14(%ebp)
  80090c:	8b 45 14             	mov    0x14(%ebp),%eax
  80090f:	83 e8 04             	sub    $0x4,%eax
  800912:	8b 30                	mov    (%eax),%esi
  800914:	85 f6                	test   %esi,%esi
  800916:	75 05                	jne    80091d <vprintfmt+0x1a6>
				p = "(null)";
  800918:	be 31 39 80 00       	mov    $0x803931,%esi
			if (width > 0 && padc != '-')
  80091d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800921:	7e 6d                	jle    800990 <vprintfmt+0x219>
  800923:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800927:	74 67                	je     800990 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800929:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80092c:	83 ec 08             	sub    $0x8,%esp
  80092f:	50                   	push   %eax
  800930:	56                   	push   %esi
  800931:	e8 0c 03 00 00       	call   800c42 <strnlen>
  800936:	83 c4 10             	add    $0x10,%esp
  800939:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80093c:	eb 16                	jmp    800954 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80093e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800942:	83 ec 08             	sub    $0x8,%esp
  800945:	ff 75 0c             	pushl  0xc(%ebp)
  800948:	50                   	push   %eax
  800949:	8b 45 08             	mov    0x8(%ebp),%eax
  80094c:	ff d0                	call   *%eax
  80094e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800951:	ff 4d e4             	decl   -0x1c(%ebp)
  800954:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800958:	7f e4                	jg     80093e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80095a:	eb 34                	jmp    800990 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80095c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800960:	74 1c                	je     80097e <vprintfmt+0x207>
  800962:	83 fb 1f             	cmp    $0x1f,%ebx
  800965:	7e 05                	jle    80096c <vprintfmt+0x1f5>
  800967:	83 fb 7e             	cmp    $0x7e,%ebx
  80096a:	7e 12                	jle    80097e <vprintfmt+0x207>
					putch('?', putdat);
  80096c:	83 ec 08             	sub    $0x8,%esp
  80096f:	ff 75 0c             	pushl  0xc(%ebp)
  800972:	6a 3f                	push   $0x3f
  800974:	8b 45 08             	mov    0x8(%ebp),%eax
  800977:	ff d0                	call   *%eax
  800979:	83 c4 10             	add    $0x10,%esp
  80097c:	eb 0f                	jmp    80098d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80097e:	83 ec 08             	sub    $0x8,%esp
  800981:	ff 75 0c             	pushl  0xc(%ebp)
  800984:	53                   	push   %ebx
  800985:	8b 45 08             	mov    0x8(%ebp),%eax
  800988:	ff d0                	call   *%eax
  80098a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80098d:	ff 4d e4             	decl   -0x1c(%ebp)
  800990:	89 f0                	mov    %esi,%eax
  800992:	8d 70 01             	lea    0x1(%eax),%esi
  800995:	8a 00                	mov    (%eax),%al
  800997:	0f be d8             	movsbl %al,%ebx
  80099a:	85 db                	test   %ebx,%ebx
  80099c:	74 24                	je     8009c2 <vprintfmt+0x24b>
  80099e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009a2:	78 b8                	js     80095c <vprintfmt+0x1e5>
  8009a4:	ff 4d e0             	decl   -0x20(%ebp)
  8009a7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009ab:	79 af                	jns    80095c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009ad:	eb 13                	jmp    8009c2 <vprintfmt+0x24b>
				putch(' ', putdat);
  8009af:	83 ec 08             	sub    $0x8,%esp
  8009b2:	ff 75 0c             	pushl  0xc(%ebp)
  8009b5:	6a 20                	push   $0x20
  8009b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ba:	ff d0                	call   *%eax
  8009bc:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009bf:	ff 4d e4             	decl   -0x1c(%ebp)
  8009c2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009c6:	7f e7                	jg     8009af <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009c8:	e9 66 01 00 00       	jmp    800b33 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009cd:	83 ec 08             	sub    $0x8,%esp
  8009d0:	ff 75 e8             	pushl  -0x18(%ebp)
  8009d3:	8d 45 14             	lea    0x14(%ebp),%eax
  8009d6:	50                   	push   %eax
  8009d7:	e8 3c fd ff ff       	call   800718 <getint>
  8009dc:	83 c4 10             	add    $0x10,%esp
  8009df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009e2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009eb:	85 d2                	test   %edx,%edx
  8009ed:	79 23                	jns    800a12 <vprintfmt+0x29b>
				putch('-', putdat);
  8009ef:	83 ec 08             	sub    $0x8,%esp
  8009f2:	ff 75 0c             	pushl  0xc(%ebp)
  8009f5:	6a 2d                	push   $0x2d
  8009f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fa:	ff d0                	call   *%eax
  8009fc:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a05:	f7 d8                	neg    %eax
  800a07:	83 d2 00             	adc    $0x0,%edx
  800a0a:	f7 da                	neg    %edx
  800a0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a0f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a12:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a19:	e9 bc 00 00 00       	jmp    800ada <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a1e:	83 ec 08             	sub    $0x8,%esp
  800a21:	ff 75 e8             	pushl  -0x18(%ebp)
  800a24:	8d 45 14             	lea    0x14(%ebp),%eax
  800a27:	50                   	push   %eax
  800a28:	e8 84 fc ff ff       	call   8006b1 <getuint>
  800a2d:	83 c4 10             	add    $0x10,%esp
  800a30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a33:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a36:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a3d:	e9 98 00 00 00       	jmp    800ada <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a42:	83 ec 08             	sub    $0x8,%esp
  800a45:	ff 75 0c             	pushl  0xc(%ebp)
  800a48:	6a 58                	push   $0x58
  800a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4d:	ff d0                	call   *%eax
  800a4f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a52:	83 ec 08             	sub    $0x8,%esp
  800a55:	ff 75 0c             	pushl  0xc(%ebp)
  800a58:	6a 58                	push   $0x58
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	ff d0                	call   *%eax
  800a5f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a62:	83 ec 08             	sub    $0x8,%esp
  800a65:	ff 75 0c             	pushl  0xc(%ebp)
  800a68:	6a 58                	push   $0x58
  800a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6d:	ff d0                	call   *%eax
  800a6f:	83 c4 10             	add    $0x10,%esp
			break;
  800a72:	e9 bc 00 00 00       	jmp    800b33 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a77:	83 ec 08             	sub    $0x8,%esp
  800a7a:	ff 75 0c             	pushl  0xc(%ebp)
  800a7d:	6a 30                	push   $0x30
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	ff d0                	call   *%eax
  800a84:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a87:	83 ec 08             	sub    $0x8,%esp
  800a8a:	ff 75 0c             	pushl  0xc(%ebp)
  800a8d:	6a 78                	push   $0x78
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a92:	ff d0                	call   *%eax
  800a94:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a97:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9a:	83 c0 04             	add    $0x4,%eax
  800a9d:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa0:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa3:	83 e8 04             	sub    $0x4,%eax
  800aa6:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800aa8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ab2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ab9:	eb 1f                	jmp    800ada <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800abb:	83 ec 08             	sub    $0x8,%esp
  800abe:	ff 75 e8             	pushl  -0x18(%ebp)
  800ac1:	8d 45 14             	lea    0x14(%ebp),%eax
  800ac4:	50                   	push   %eax
  800ac5:	e8 e7 fb ff ff       	call   8006b1 <getuint>
  800aca:	83 c4 10             	add    $0x10,%esp
  800acd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ad0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ad3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ada:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ade:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ae1:	83 ec 04             	sub    $0x4,%esp
  800ae4:	52                   	push   %edx
  800ae5:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ae8:	50                   	push   %eax
  800ae9:	ff 75 f4             	pushl  -0xc(%ebp)
  800aec:	ff 75 f0             	pushl  -0x10(%ebp)
  800aef:	ff 75 0c             	pushl  0xc(%ebp)
  800af2:	ff 75 08             	pushl  0x8(%ebp)
  800af5:	e8 00 fb ff ff       	call   8005fa <printnum>
  800afa:	83 c4 20             	add    $0x20,%esp
			break;
  800afd:	eb 34                	jmp    800b33 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800aff:	83 ec 08             	sub    $0x8,%esp
  800b02:	ff 75 0c             	pushl  0xc(%ebp)
  800b05:	53                   	push   %ebx
  800b06:	8b 45 08             	mov    0x8(%ebp),%eax
  800b09:	ff d0                	call   *%eax
  800b0b:	83 c4 10             	add    $0x10,%esp
			break;
  800b0e:	eb 23                	jmp    800b33 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b10:	83 ec 08             	sub    $0x8,%esp
  800b13:	ff 75 0c             	pushl  0xc(%ebp)
  800b16:	6a 25                	push   $0x25
  800b18:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1b:	ff d0                	call   *%eax
  800b1d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b20:	ff 4d 10             	decl   0x10(%ebp)
  800b23:	eb 03                	jmp    800b28 <vprintfmt+0x3b1>
  800b25:	ff 4d 10             	decl   0x10(%ebp)
  800b28:	8b 45 10             	mov    0x10(%ebp),%eax
  800b2b:	48                   	dec    %eax
  800b2c:	8a 00                	mov    (%eax),%al
  800b2e:	3c 25                	cmp    $0x25,%al
  800b30:	75 f3                	jne    800b25 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b32:	90                   	nop
		}
	}
  800b33:	e9 47 fc ff ff       	jmp    80077f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b38:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b39:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b3c:	5b                   	pop    %ebx
  800b3d:	5e                   	pop    %esi
  800b3e:	5d                   	pop    %ebp
  800b3f:	c3                   	ret    

00800b40 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b40:	55                   	push   %ebp
  800b41:	89 e5                	mov    %esp,%ebp
  800b43:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b46:	8d 45 10             	lea    0x10(%ebp),%eax
  800b49:	83 c0 04             	add    $0x4,%eax
  800b4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800b52:	ff 75 f4             	pushl  -0xc(%ebp)
  800b55:	50                   	push   %eax
  800b56:	ff 75 0c             	pushl  0xc(%ebp)
  800b59:	ff 75 08             	pushl  0x8(%ebp)
  800b5c:	e8 16 fc ff ff       	call   800777 <vprintfmt>
  800b61:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b64:	90                   	nop
  800b65:	c9                   	leave  
  800b66:	c3                   	ret    

00800b67 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b67:	55                   	push   %ebp
  800b68:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6d:	8b 40 08             	mov    0x8(%eax),%eax
  800b70:	8d 50 01             	lea    0x1(%eax),%edx
  800b73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b76:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7c:	8b 10                	mov    (%eax),%edx
  800b7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b81:	8b 40 04             	mov    0x4(%eax),%eax
  800b84:	39 c2                	cmp    %eax,%edx
  800b86:	73 12                	jae    800b9a <sprintputch+0x33>
		*b->buf++ = ch;
  800b88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8b:	8b 00                	mov    (%eax),%eax
  800b8d:	8d 48 01             	lea    0x1(%eax),%ecx
  800b90:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b93:	89 0a                	mov    %ecx,(%edx)
  800b95:	8b 55 08             	mov    0x8(%ebp),%edx
  800b98:	88 10                	mov    %dl,(%eax)
}
  800b9a:	90                   	nop
  800b9b:	5d                   	pop    %ebp
  800b9c:	c3                   	ret    

00800b9d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b9d:	55                   	push   %ebp
  800b9e:	89 e5                	mov    %esp,%ebp
  800ba0:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ba9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bac:	8d 50 ff             	lea    -0x1(%eax),%edx
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	01 d0                	add    %edx,%eax
  800bb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bbe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bc2:	74 06                	je     800bca <vsnprintf+0x2d>
  800bc4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bc8:	7f 07                	jg     800bd1 <vsnprintf+0x34>
		return -E_INVAL;
  800bca:	b8 03 00 00 00       	mov    $0x3,%eax
  800bcf:	eb 20                	jmp    800bf1 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bd1:	ff 75 14             	pushl  0x14(%ebp)
  800bd4:	ff 75 10             	pushl  0x10(%ebp)
  800bd7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bda:	50                   	push   %eax
  800bdb:	68 67 0b 80 00       	push   $0x800b67
  800be0:	e8 92 fb ff ff       	call   800777 <vprintfmt>
  800be5:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800be8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800beb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bf1:	c9                   	leave  
  800bf2:	c3                   	ret    

00800bf3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bf3:	55                   	push   %ebp
  800bf4:	89 e5                	mov    %esp,%ebp
  800bf6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bf9:	8d 45 10             	lea    0x10(%ebp),%eax
  800bfc:	83 c0 04             	add    $0x4,%eax
  800bff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c02:	8b 45 10             	mov    0x10(%ebp),%eax
  800c05:	ff 75 f4             	pushl  -0xc(%ebp)
  800c08:	50                   	push   %eax
  800c09:	ff 75 0c             	pushl  0xc(%ebp)
  800c0c:	ff 75 08             	pushl  0x8(%ebp)
  800c0f:	e8 89 ff ff ff       	call   800b9d <vsnprintf>
  800c14:	83 c4 10             	add    $0x10,%esp
  800c17:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c1d:	c9                   	leave  
  800c1e:	c3                   	ret    

00800c1f <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c2c:	eb 06                	jmp    800c34 <strlen+0x15>
		n++;
  800c2e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c31:	ff 45 08             	incl   0x8(%ebp)
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	8a 00                	mov    (%eax),%al
  800c39:	84 c0                	test   %al,%al
  800c3b:	75 f1                	jne    800c2e <strlen+0xf>
		n++;
	return n;
  800c3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c40:	c9                   	leave  
  800c41:	c3                   	ret    

00800c42 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c42:	55                   	push   %ebp
  800c43:	89 e5                	mov    %esp,%ebp
  800c45:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c48:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c4f:	eb 09                	jmp    800c5a <strnlen+0x18>
		n++;
  800c51:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c54:	ff 45 08             	incl   0x8(%ebp)
  800c57:	ff 4d 0c             	decl   0xc(%ebp)
  800c5a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c5e:	74 09                	je     800c69 <strnlen+0x27>
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	8a 00                	mov    (%eax),%al
  800c65:	84 c0                	test   %al,%al
  800c67:	75 e8                	jne    800c51 <strnlen+0xf>
		n++;
	return n;
  800c69:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c6c:	c9                   	leave  
  800c6d:	c3                   	ret    

00800c6e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c74:	8b 45 08             	mov    0x8(%ebp),%eax
  800c77:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c7a:	90                   	nop
  800c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7e:	8d 50 01             	lea    0x1(%eax),%edx
  800c81:	89 55 08             	mov    %edx,0x8(%ebp)
  800c84:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c87:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c8a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c8d:	8a 12                	mov    (%edx),%dl
  800c8f:	88 10                	mov    %dl,(%eax)
  800c91:	8a 00                	mov    (%eax),%al
  800c93:	84 c0                	test   %al,%al
  800c95:	75 e4                	jne    800c7b <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c97:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c9a:	c9                   	leave  
  800c9b:	c3                   	ret    

00800c9c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
  800c9f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ca8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800caf:	eb 1f                	jmp    800cd0 <strncpy+0x34>
		*dst++ = *src;
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	8d 50 01             	lea    0x1(%eax),%edx
  800cb7:	89 55 08             	mov    %edx,0x8(%ebp)
  800cba:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cbd:	8a 12                	mov    (%edx),%dl
  800cbf:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc4:	8a 00                	mov    (%eax),%al
  800cc6:	84 c0                	test   %al,%al
  800cc8:	74 03                	je     800ccd <strncpy+0x31>
			src++;
  800cca:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ccd:	ff 45 fc             	incl   -0x4(%ebp)
  800cd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cd3:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cd6:	72 d9                	jb     800cb1 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cd8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cdb:	c9                   	leave  
  800cdc:	c3                   	ret    

00800cdd <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cdd:	55                   	push   %ebp
  800cde:	89 e5                	mov    %esp,%ebp
  800ce0:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ce9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ced:	74 30                	je     800d1f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cef:	eb 16                	jmp    800d07 <strlcpy+0x2a>
			*dst++ = *src++;
  800cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf4:	8d 50 01             	lea    0x1(%eax),%edx
  800cf7:	89 55 08             	mov    %edx,0x8(%ebp)
  800cfa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cfd:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d00:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d03:	8a 12                	mov    (%edx),%dl
  800d05:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d07:	ff 4d 10             	decl   0x10(%ebp)
  800d0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d0e:	74 09                	je     800d19 <strlcpy+0x3c>
  800d10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d13:	8a 00                	mov    (%eax),%al
  800d15:	84 c0                	test   %al,%al
  800d17:	75 d8                	jne    800cf1 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d1f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d22:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d25:	29 c2                	sub    %eax,%edx
  800d27:	89 d0                	mov    %edx,%eax
}
  800d29:	c9                   	leave  
  800d2a:	c3                   	ret    

00800d2b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d2b:	55                   	push   %ebp
  800d2c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d2e:	eb 06                	jmp    800d36 <strcmp+0xb>
		p++, q++;
  800d30:	ff 45 08             	incl   0x8(%ebp)
  800d33:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d36:	8b 45 08             	mov    0x8(%ebp),%eax
  800d39:	8a 00                	mov    (%eax),%al
  800d3b:	84 c0                	test   %al,%al
  800d3d:	74 0e                	je     800d4d <strcmp+0x22>
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	8a 10                	mov    (%eax),%dl
  800d44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d47:	8a 00                	mov    (%eax),%al
  800d49:	38 c2                	cmp    %al,%dl
  800d4b:	74 e3                	je     800d30 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	8a 00                	mov    (%eax),%al
  800d52:	0f b6 d0             	movzbl %al,%edx
  800d55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d58:	8a 00                	mov    (%eax),%al
  800d5a:	0f b6 c0             	movzbl %al,%eax
  800d5d:	29 c2                	sub    %eax,%edx
  800d5f:	89 d0                	mov    %edx,%eax
}
  800d61:	5d                   	pop    %ebp
  800d62:	c3                   	ret    

00800d63 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d63:	55                   	push   %ebp
  800d64:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d66:	eb 09                	jmp    800d71 <strncmp+0xe>
		n--, p++, q++;
  800d68:	ff 4d 10             	decl   0x10(%ebp)
  800d6b:	ff 45 08             	incl   0x8(%ebp)
  800d6e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d71:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d75:	74 17                	je     800d8e <strncmp+0x2b>
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	84 c0                	test   %al,%al
  800d7e:	74 0e                	je     800d8e <strncmp+0x2b>
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8a 10                	mov    (%eax),%dl
  800d85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d88:	8a 00                	mov    (%eax),%al
  800d8a:	38 c2                	cmp    %al,%dl
  800d8c:	74 da                	je     800d68 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d8e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d92:	75 07                	jne    800d9b <strncmp+0x38>
		return 0;
  800d94:	b8 00 00 00 00       	mov    $0x0,%eax
  800d99:	eb 14                	jmp    800daf <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9e:	8a 00                	mov    (%eax),%al
  800da0:	0f b6 d0             	movzbl %al,%edx
  800da3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da6:	8a 00                	mov    (%eax),%al
  800da8:	0f b6 c0             	movzbl %al,%eax
  800dab:	29 c2                	sub    %eax,%edx
  800dad:	89 d0                	mov    %edx,%eax
}
  800daf:	5d                   	pop    %ebp
  800db0:	c3                   	ret    

00800db1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800db1:	55                   	push   %ebp
  800db2:	89 e5                	mov    %esp,%ebp
  800db4:	83 ec 04             	sub    $0x4,%esp
  800db7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dba:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dbd:	eb 12                	jmp    800dd1 <strchr+0x20>
		if (*s == c)
  800dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc2:	8a 00                	mov    (%eax),%al
  800dc4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dc7:	75 05                	jne    800dce <strchr+0x1d>
			return (char *) s;
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcc:	eb 11                	jmp    800ddf <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dce:	ff 45 08             	incl   0x8(%ebp)
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd4:	8a 00                	mov    (%eax),%al
  800dd6:	84 c0                	test   %al,%al
  800dd8:	75 e5                	jne    800dbf <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800dda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ddf:	c9                   	leave  
  800de0:	c3                   	ret    

00800de1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800de1:	55                   	push   %ebp
  800de2:	89 e5                	mov    %esp,%ebp
  800de4:	83 ec 04             	sub    $0x4,%esp
  800de7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dea:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ded:	eb 0d                	jmp    800dfc <strfind+0x1b>
		if (*s == c)
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	8a 00                	mov    (%eax),%al
  800df4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800df7:	74 0e                	je     800e07 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800df9:	ff 45 08             	incl   0x8(%ebp)
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8a 00                	mov    (%eax),%al
  800e01:	84 c0                	test   %al,%al
  800e03:	75 ea                	jne    800def <strfind+0xe>
  800e05:	eb 01                	jmp    800e08 <strfind+0x27>
		if (*s == c)
			break;
  800e07:	90                   	nop
	return (char *) s;
  800e08:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e0b:	c9                   	leave  
  800e0c:	c3                   	ret    

00800e0d <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e13:	8b 45 08             	mov    0x8(%ebp),%eax
  800e16:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e19:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e1f:	eb 0e                	jmp    800e2f <memset+0x22>
		*p++ = c;
  800e21:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e24:	8d 50 01             	lea    0x1(%eax),%edx
  800e27:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e2d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e2f:	ff 4d f8             	decl   -0x8(%ebp)
  800e32:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e36:	79 e9                	jns    800e21 <memset+0x14>
		*p++ = c;

	return v;
  800e38:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e3b:	c9                   	leave  
  800e3c:	c3                   	ret    

00800e3d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e3d:	55                   	push   %ebp
  800e3e:	89 e5                	mov    %esp,%ebp
  800e40:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e46:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e4f:	eb 16                	jmp    800e67 <memcpy+0x2a>
		*d++ = *s++;
  800e51:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e54:	8d 50 01             	lea    0x1(%eax),%edx
  800e57:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e5a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e5d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e60:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e63:	8a 12                	mov    (%edx),%dl
  800e65:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e67:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e6d:	89 55 10             	mov    %edx,0x10(%ebp)
  800e70:	85 c0                	test   %eax,%eax
  800e72:	75 dd                	jne    800e51 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e77:	c9                   	leave  
  800e78:	c3                   	ret    

00800e79 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e79:	55                   	push   %ebp
  800e7a:	89 e5                	mov    %esp,%ebp
  800e7c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e82:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e85:	8b 45 08             	mov    0x8(%ebp),%eax
  800e88:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e8e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e91:	73 50                	jae    800ee3 <memmove+0x6a>
  800e93:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e96:	8b 45 10             	mov    0x10(%ebp),%eax
  800e99:	01 d0                	add    %edx,%eax
  800e9b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e9e:	76 43                	jbe    800ee3 <memmove+0x6a>
		s += n;
  800ea0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea3:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ea6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea9:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800eac:	eb 10                	jmp    800ebe <memmove+0x45>
			*--d = *--s;
  800eae:	ff 4d f8             	decl   -0x8(%ebp)
  800eb1:	ff 4d fc             	decl   -0x4(%ebp)
  800eb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb7:	8a 10                	mov    (%eax),%dl
  800eb9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ebc:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ebe:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ec4:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec7:	85 c0                	test   %eax,%eax
  800ec9:	75 e3                	jne    800eae <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ecb:	eb 23                	jmp    800ef0 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ecd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed0:	8d 50 01             	lea    0x1(%eax),%edx
  800ed3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ed6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ed9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800edc:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800edf:	8a 12                	mov    (%edx),%dl
  800ee1:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ee3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ee9:	89 55 10             	mov    %edx,0x10(%ebp)
  800eec:	85 c0                	test   %eax,%eax
  800eee:	75 dd                	jne    800ecd <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ef3:	c9                   	leave  
  800ef4:	c3                   	ret    

00800ef5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ef5:	55                   	push   %ebp
  800ef6:	89 e5                	mov    %esp,%ebp
  800ef8:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800efb:	8b 45 08             	mov    0x8(%ebp),%eax
  800efe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f04:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f07:	eb 2a                	jmp    800f33 <memcmp+0x3e>
		if (*s1 != *s2)
  800f09:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0c:	8a 10                	mov    (%eax),%dl
  800f0e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f11:	8a 00                	mov    (%eax),%al
  800f13:	38 c2                	cmp    %al,%dl
  800f15:	74 16                	je     800f2d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f17:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f1a:	8a 00                	mov    (%eax),%al
  800f1c:	0f b6 d0             	movzbl %al,%edx
  800f1f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f22:	8a 00                	mov    (%eax),%al
  800f24:	0f b6 c0             	movzbl %al,%eax
  800f27:	29 c2                	sub    %eax,%edx
  800f29:	89 d0                	mov    %edx,%eax
  800f2b:	eb 18                	jmp    800f45 <memcmp+0x50>
		s1++, s2++;
  800f2d:	ff 45 fc             	incl   -0x4(%ebp)
  800f30:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f33:	8b 45 10             	mov    0x10(%ebp),%eax
  800f36:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f39:	89 55 10             	mov    %edx,0x10(%ebp)
  800f3c:	85 c0                	test   %eax,%eax
  800f3e:	75 c9                	jne    800f09 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f40:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f45:	c9                   	leave  
  800f46:	c3                   	ret    

00800f47 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f47:	55                   	push   %ebp
  800f48:	89 e5                	mov    %esp,%ebp
  800f4a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f50:	8b 45 10             	mov    0x10(%ebp),%eax
  800f53:	01 d0                	add    %edx,%eax
  800f55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f58:	eb 15                	jmp    800f6f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5d:	8a 00                	mov    (%eax),%al
  800f5f:	0f b6 d0             	movzbl %al,%edx
  800f62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f65:	0f b6 c0             	movzbl %al,%eax
  800f68:	39 c2                	cmp    %eax,%edx
  800f6a:	74 0d                	je     800f79 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f6c:	ff 45 08             	incl   0x8(%ebp)
  800f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f72:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f75:	72 e3                	jb     800f5a <memfind+0x13>
  800f77:	eb 01                	jmp    800f7a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f79:	90                   	nop
	return (void *) s;
  800f7a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f7d:	c9                   	leave  
  800f7e:	c3                   	ret    

00800f7f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f7f:	55                   	push   %ebp
  800f80:	89 e5                	mov    %esp,%ebp
  800f82:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f85:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f8c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f93:	eb 03                	jmp    800f98 <strtol+0x19>
		s++;
  800f95:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f98:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9b:	8a 00                	mov    (%eax),%al
  800f9d:	3c 20                	cmp    $0x20,%al
  800f9f:	74 f4                	je     800f95 <strtol+0x16>
  800fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa4:	8a 00                	mov    (%eax),%al
  800fa6:	3c 09                	cmp    $0x9,%al
  800fa8:	74 eb                	je     800f95 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800faa:	8b 45 08             	mov    0x8(%ebp),%eax
  800fad:	8a 00                	mov    (%eax),%al
  800faf:	3c 2b                	cmp    $0x2b,%al
  800fb1:	75 05                	jne    800fb8 <strtol+0x39>
		s++;
  800fb3:	ff 45 08             	incl   0x8(%ebp)
  800fb6:	eb 13                	jmp    800fcb <strtol+0x4c>
	else if (*s == '-')
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	8a 00                	mov    (%eax),%al
  800fbd:	3c 2d                	cmp    $0x2d,%al
  800fbf:	75 0a                	jne    800fcb <strtol+0x4c>
		s++, neg = 1;
  800fc1:	ff 45 08             	incl   0x8(%ebp)
  800fc4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fcb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fcf:	74 06                	je     800fd7 <strtol+0x58>
  800fd1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fd5:	75 20                	jne    800ff7 <strtol+0x78>
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	8a 00                	mov    (%eax),%al
  800fdc:	3c 30                	cmp    $0x30,%al
  800fde:	75 17                	jne    800ff7 <strtol+0x78>
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	40                   	inc    %eax
  800fe4:	8a 00                	mov    (%eax),%al
  800fe6:	3c 78                	cmp    $0x78,%al
  800fe8:	75 0d                	jne    800ff7 <strtol+0x78>
		s += 2, base = 16;
  800fea:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fee:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ff5:	eb 28                	jmp    80101f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ff7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ffb:	75 15                	jne    801012 <strtol+0x93>
  800ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  801000:	8a 00                	mov    (%eax),%al
  801002:	3c 30                	cmp    $0x30,%al
  801004:	75 0c                	jne    801012 <strtol+0x93>
		s++, base = 8;
  801006:	ff 45 08             	incl   0x8(%ebp)
  801009:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801010:	eb 0d                	jmp    80101f <strtol+0xa0>
	else if (base == 0)
  801012:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801016:	75 07                	jne    80101f <strtol+0xa0>
		base = 10;
  801018:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80101f:	8b 45 08             	mov    0x8(%ebp),%eax
  801022:	8a 00                	mov    (%eax),%al
  801024:	3c 2f                	cmp    $0x2f,%al
  801026:	7e 19                	jle    801041 <strtol+0xc2>
  801028:	8b 45 08             	mov    0x8(%ebp),%eax
  80102b:	8a 00                	mov    (%eax),%al
  80102d:	3c 39                	cmp    $0x39,%al
  80102f:	7f 10                	jg     801041 <strtol+0xc2>
			dig = *s - '0';
  801031:	8b 45 08             	mov    0x8(%ebp),%eax
  801034:	8a 00                	mov    (%eax),%al
  801036:	0f be c0             	movsbl %al,%eax
  801039:	83 e8 30             	sub    $0x30,%eax
  80103c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80103f:	eb 42                	jmp    801083 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
  801044:	8a 00                	mov    (%eax),%al
  801046:	3c 60                	cmp    $0x60,%al
  801048:	7e 19                	jle    801063 <strtol+0xe4>
  80104a:	8b 45 08             	mov    0x8(%ebp),%eax
  80104d:	8a 00                	mov    (%eax),%al
  80104f:	3c 7a                	cmp    $0x7a,%al
  801051:	7f 10                	jg     801063 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801053:	8b 45 08             	mov    0x8(%ebp),%eax
  801056:	8a 00                	mov    (%eax),%al
  801058:	0f be c0             	movsbl %al,%eax
  80105b:	83 e8 57             	sub    $0x57,%eax
  80105e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801061:	eb 20                	jmp    801083 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801063:	8b 45 08             	mov    0x8(%ebp),%eax
  801066:	8a 00                	mov    (%eax),%al
  801068:	3c 40                	cmp    $0x40,%al
  80106a:	7e 39                	jle    8010a5 <strtol+0x126>
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	8a 00                	mov    (%eax),%al
  801071:	3c 5a                	cmp    $0x5a,%al
  801073:	7f 30                	jg     8010a5 <strtol+0x126>
			dig = *s - 'A' + 10;
  801075:	8b 45 08             	mov    0x8(%ebp),%eax
  801078:	8a 00                	mov    (%eax),%al
  80107a:	0f be c0             	movsbl %al,%eax
  80107d:	83 e8 37             	sub    $0x37,%eax
  801080:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801083:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801086:	3b 45 10             	cmp    0x10(%ebp),%eax
  801089:	7d 19                	jge    8010a4 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80108b:	ff 45 08             	incl   0x8(%ebp)
  80108e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801091:	0f af 45 10          	imul   0x10(%ebp),%eax
  801095:	89 c2                	mov    %eax,%edx
  801097:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80109a:	01 d0                	add    %edx,%eax
  80109c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80109f:	e9 7b ff ff ff       	jmp    80101f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010a4:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010a5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010a9:	74 08                	je     8010b3 <strtol+0x134>
		*endptr = (char *) s;
  8010ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b1:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010b7:	74 07                	je     8010c0 <strtol+0x141>
  8010b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010bc:	f7 d8                	neg    %eax
  8010be:	eb 03                	jmp    8010c3 <strtol+0x144>
  8010c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010c3:	c9                   	leave  
  8010c4:	c3                   	ret    

008010c5 <ltostr>:

void
ltostr(long value, char *str)
{
  8010c5:	55                   	push   %ebp
  8010c6:	89 e5                	mov    %esp,%ebp
  8010c8:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010d2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010d9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010dd:	79 13                	jns    8010f2 <ltostr+0x2d>
	{
		neg = 1;
  8010df:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e9:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010ec:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010ef:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010fa:	99                   	cltd   
  8010fb:	f7 f9                	idiv   %ecx
  8010fd:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801100:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801103:	8d 50 01             	lea    0x1(%eax),%edx
  801106:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801109:	89 c2                	mov    %eax,%edx
  80110b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110e:	01 d0                	add    %edx,%eax
  801110:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801113:	83 c2 30             	add    $0x30,%edx
  801116:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801118:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80111b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801120:	f7 e9                	imul   %ecx
  801122:	c1 fa 02             	sar    $0x2,%edx
  801125:	89 c8                	mov    %ecx,%eax
  801127:	c1 f8 1f             	sar    $0x1f,%eax
  80112a:	29 c2                	sub    %eax,%edx
  80112c:	89 d0                	mov    %edx,%eax
  80112e:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801131:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801134:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801139:	f7 e9                	imul   %ecx
  80113b:	c1 fa 02             	sar    $0x2,%edx
  80113e:	89 c8                	mov    %ecx,%eax
  801140:	c1 f8 1f             	sar    $0x1f,%eax
  801143:	29 c2                	sub    %eax,%edx
  801145:	89 d0                	mov    %edx,%eax
  801147:	c1 e0 02             	shl    $0x2,%eax
  80114a:	01 d0                	add    %edx,%eax
  80114c:	01 c0                	add    %eax,%eax
  80114e:	29 c1                	sub    %eax,%ecx
  801150:	89 ca                	mov    %ecx,%edx
  801152:	85 d2                	test   %edx,%edx
  801154:	75 9c                	jne    8010f2 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801156:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80115d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801160:	48                   	dec    %eax
  801161:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801164:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801168:	74 3d                	je     8011a7 <ltostr+0xe2>
		start = 1 ;
  80116a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801171:	eb 34                	jmp    8011a7 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801173:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801176:	8b 45 0c             	mov    0xc(%ebp),%eax
  801179:	01 d0                	add    %edx,%eax
  80117b:	8a 00                	mov    (%eax),%al
  80117d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801180:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801183:	8b 45 0c             	mov    0xc(%ebp),%eax
  801186:	01 c2                	add    %eax,%edx
  801188:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80118b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118e:	01 c8                	add    %ecx,%eax
  801190:	8a 00                	mov    (%eax),%al
  801192:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801194:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119a:	01 c2                	add    %eax,%edx
  80119c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80119f:	88 02                	mov    %al,(%edx)
		start++ ;
  8011a1:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011a4:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011aa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011ad:	7c c4                	jl     801173 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011af:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b5:	01 d0                	add    %edx,%eax
  8011b7:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011ba:	90                   	nop
  8011bb:	c9                   	leave  
  8011bc:	c3                   	ret    

008011bd <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011bd:	55                   	push   %ebp
  8011be:	89 e5                	mov    %esp,%ebp
  8011c0:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011c3:	ff 75 08             	pushl  0x8(%ebp)
  8011c6:	e8 54 fa ff ff       	call   800c1f <strlen>
  8011cb:	83 c4 04             	add    $0x4,%esp
  8011ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011d1:	ff 75 0c             	pushl  0xc(%ebp)
  8011d4:	e8 46 fa ff ff       	call   800c1f <strlen>
  8011d9:	83 c4 04             	add    $0x4,%esp
  8011dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011ed:	eb 17                	jmp    801206 <strcconcat+0x49>
		final[s] = str1[s] ;
  8011ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f5:	01 c2                	add    %eax,%edx
  8011f7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fd:	01 c8                	add    %ecx,%eax
  8011ff:	8a 00                	mov    (%eax),%al
  801201:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801203:	ff 45 fc             	incl   -0x4(%ebp)
  801206:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801209:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80120c:	7c e1                	jl     8011ef <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80120e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801215:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80121c:	eb 1f                	jmp    80123d <strcconcat+0x80>
		final[s++] = str2[i] ;
  80121e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801221:	8d 50 01             	lea    0x1(%eax),%edx
  801224:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801227:	89 c2                	mov    %eax,%edx
  801229:	8b 45 10             	mov    0x10(%ebp),%eax
  80122c:	01 c2                	add    %eax,%edx
  80122e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801231:	8b 45 0c             	mov    0xc(%ebp),%eax
  801234:	01 c8                	add    %ecx,%eax
  801236:	8a 00                	mov    (%eax),%al
  801238:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80123a:	ff 45 f8             	incl   -0x8(%ebp)
  80123d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801240:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801243:	7c d9                	jl     80121e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801245:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801248:	8b 45 10             	mov    0x10(%ebp),%eax
  80124b:	01 d0                	add    %edx,%eax
  80124d:	c6 00 00             	movb   $0x0,(%eax)
}
  801250:	90                   	nop
  801251:	c9                   	leave  
  801252:	c3                   	ret    

00801253 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801253:	55                   	push   %ebp
  801254:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801256:	8b 45 14             	mov    0x14(%ebp),%eax
  801259:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80125f:	8b 45 14             	mov    0x14(%ebp),%eax
  801262:	8b 00                	mov    (%eax),%eax
  801264:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80126b:	8b 45 10             	mov    0x10(%ebp),%eax
  80126e:	01 d0                	add    %edx,%eax
  801270:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801276:	eb 0c                	jmp    801284 <strsplit+0x31>
			*string++ = 0;
  801278:	8b 45 08             	mov    0x8(%ebp),%eax
  80127b:	8d 50 01             	lea    0x1(%eax),%edx
  80127e:	89 55 08             	mov    %edx,0x8(%ebp)
  801281:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801284:	8b 45 08             	mov    0x8(%ebp),%eax
  801287:	8a 00                	mov    (%eax),%al
  801289:	84 c0                	test   %al,%al
  80128b:	74 18                	je     8012a5 <strsplit+0x52>
  80128d:	8b 45 08             	mov    0x8(%ebp),%eax
  801290:	8a 00                	mov    (%eax),%al
  801292:	0f be c0             	movsbl %al,%eax
  801295:	50                   	push   %eax
  801296:	ff 75 0c             	pushl  0xc(%ebp)
  801299:	e8 13 fb ff ff       	call   800db1 <strchr>
  80129e:	83 c4 08             	add    $0x8,%esp
  8012a1:	85 c0                	test   %eax,%eax
  8012a3:	75 d3                	jne    801278 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a8:	8a 00                	mov    (%eax),%al
  8012aa:	84 c0                	test   %al,%al
  8012ac:	74 5a                	je     801308 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8012b1:	8b 00                	mov    (%eax),%eax
  8012b3:	83 f8 0f             	cmp    $0xf,%eax
  8012b6:	75 07                	jne    8012bf <strsplit+0x6c>
		{
			return 0;
  8012b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8012bd:	eb 66                	jmp    801325 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c2:	8b 00                	mov    (%eax),%eax
  8012c4:	8d 48 01             	lea    0x1(%eax),%ecx
  8012c7:	8b 55 14             	mov    0x14(%ebp),%edx
  8012ca:	89 0a                	mov    %ecx,(%edx)
  8012cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d6:	01 c2                	add    %eax,%edx
  8012d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012db:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012dd:	eb 03                	jmp    8012e2 <strsplit+0x8f>
			string++;
  8012df:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	8a 00                	mov    (%eax),%al
  8012e7:	84 c0                	test   %al,%al
  8012e9:	74 8b                	je     801276 <strsplit+0x23>
  8012eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ee:	8a 00                	mov    (%eax),%al
  8012f0:	0f be c0             	movsbl %al,%eax
  8012f3:	50                   	push   %eax
  8012f4:	ff 75 0c             	pushl  0xc(%ebp)
  8012f7:	e8 b5 fa ff ff       	call   800db1 <strchr>
  8012fc:	83 c4 08             	add    $0x8,%esp
  8012ff:	85 c0                	test   %eax,%eax
  801301:	74 dc                	je     8012df <strsplit+0x8c>
			string++;
	}
  801303:	e9 6e ff ff ff       	jmp    801276 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801308:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801309:	8b 45 14             	mov    0x14(%ebp),%eax
  80130c:	8b 00                	mov    (%eax),%eax
  80130e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801315:	8b 45 10             	mov    0x10(%ebp),%eax
  801318:	01 d0                	add    %edx,%eax
  80131a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801320:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801325:	c9                   	leave  
  801326:	c3                   	ret    

00801327 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801327:	55                   	push   %ebp
  801328:	89 e5                	mov    %esp,%ebp
  80132a:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80132d:	a1 04 40 80 00       	mov    0x804004,%eax
  801332:	85 c0                	test   %eax,%eax
  801334:	74 1f                	je     801355 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801336:	e8 1d 00 00 00       	call   801358 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80133b:	83 ec 0c             	sub    $0xc,%esp
  80133e:	68 90 3a 80 00       	push   $0x803a90
  801343:	e8 55 f2 ff ff       	call   80059d <cprintf>
  801348:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80134b:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801352:	00 00 00 
	}
}
  801355:	90                   	nop
  801356:	c9                   	leave  
  801357:	c3                   	ret    

00801358 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801358:	55                   	push   %ebp
  801359:	89 e5                	mov    %esp,%ebp
  80135b:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  80135e:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801365:	00 00 00 
  801368:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80136f:	00 00 00 
  801372:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801379:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  80137c:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801383:	00 00 00 
  801386:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80138d:	00 00 00 
  801390:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801397:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  80139a:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8013a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013a4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013a9:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013ae:	a3 50 40 80 00       	mov    %eax,0x804050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  8013b3:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  8013ba:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  8013bd:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8013c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013c7:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  8013cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8013cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8013d7:	f7 75 f0             	divl   -0x10(%ebp)
  8013da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013dd:	29 d0                	sub    %edx,%eax
  8013df:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  8013e2:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8013e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013ec:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013f1:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013f6:	83 ec 04             	sub    $0x4,%esp
  8013f9:	6a 06                	push   $0x6
  8013fb:	ff 75 e8             	pushl  -0x18(%ebp)
  8013fe:	50                   	push   %eax
  8013ff:	e8 d4 05 00 00       	call   8019d8 <sys_allocate_chunk>
  801404:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801407:	a1 20 41 80 00       	mov    0x804120,%eax
  80140c:	83 ec 0c             	sub    $0xc,%esp
  80140f:	50                   	push   %eax
  801410:	e8 49 0c 00 00       	call   80205e <initialize_MemBlocksList>
  801415:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  801418:	a1 48 41 80 00       	mov    0x804148,%eax
  80141d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  801420:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801424:	75 14                	jne    80143a <initialize_dyn_block_system+0xe2>
  801426:	83 ec 04             	sub    $0x4,%esp
  801429:	68 b5 3a 80 00       	push   $0x803ab5
  80142e:	6a 39                	push   $0x39
  801430:	68 d3 3a 80 00       	push   $0x803ad3
  801435:	e8 af ee ff ff       	call   8002e9 <_panic>
  80143a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80143d:	8b 00                	mov    (%eax),%eax
  80143f:	85 c0                	test   %eax,%eax
  801441:	74 10                	je     801453 <initialize_dyn_block_system+0xfb>
  801443:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801446:	8b 00                	mov    (%eax),%eax
  801448:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80144b:	8b 52 04             	mov    0x4(%edx),%edx
  80144e:	89 50 04             	mov    %edx,0x4(%eax)
  801451:	eb 0b                	jmp    80145e <initialize_dyn_block_system+0x106>
  801453:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801456:	8b 40 04             	mov    0x4(%eax),%eax
  801459:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80145e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801461:	8b 40 04             	mov    0x4(%eax),%eax
  801464:	85 c0                	test   %eax,%eax
  801466:	74 0f                	je     801477 <initialize_dyn_block_system+0x11f>
  801468:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80146b:	8b 40 04             	mov    0x4(%eax),%eax
  80146e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801471:	8b 12                	mov    (%edx),%edx
  801473:	89 10                	mov    %edx,(%eax)
  801475:	eb 0a                	jmp    801481 <initialize_dyn_block_system+0x129>
  801477:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80147a:	8b 00                	mov    (%eax),%eax
  80147c:	a3 48 41 80 00       	mov    %eax,0x804148
  801481:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801484:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80148a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80148d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801494:	a1 54 41 80 00       	mov    0x804154,%eax
  801499:	48                   	dec    %eax
  80149a:	a3 54 41 80 00       	mov    %eax,0x804154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  80149f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014a2:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  8014a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014ac:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  8014b3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014b7:	75 14                	jne    8014cd <initialize_dyn_block_system+0x175>
  8014b9:	83 ec 04             	sub    $0x4,%esp
  8014bc:	68 e0 3a 80 00       	push   $0x803ae0
  8014c1:	6a 3f                	push   $0x3f
  8014c3:	68 d3 3a 80 00       	push   $0x803ad3
  8014c8:	e8 1c ee ff ff       	call   8002e9 <_panic>
  8014cd:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8014d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014d6:	89 10                	mov    %edx,(%eax)
  8014d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014db:	8b 00                	mov    (%eax),%eax
  8014dd:	85 c0                	test   %eax,%eax
  8014df:	74 0d                	je     8014ee <initialize_dyn_block_system+0x196>
  8014e1:	a1 38 41 80 00       	mov    0x804138,%eax
  8014e6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014e9:	89 50 04             	mov    %edx,0x4(%eax)
  8014ec:	eb 08                	jmp    8014f6 <initialize_dyn_block_system+0x19e>
  8014ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014f1:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8014f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014f9:	a3 38 41 80 00       	mov    %eax,0x804138
  8014fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801501:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801508:	a1 44 41 80 00       	mov    0x804144,%eax
  80150d:	40                   	inc    %eax
  80150e:	a3 44 41 80 00       	mov    %eax,0x804144

}
  801513:	90                   	nop
  801514:	c9                   	leave  
  801515:	c3                   	ret    

00801516 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801516:	55                   	push   %ebp
  801517:	89 e5                	mov    %esp,%ebp
  801519:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80151c:	e8 06 fe ff ff       	call   801327 <InitializeUHeap>
	if (size == 0) return NULL ;
  801521:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801525:	75 07                	jne    80152e <malloc+0x18>
  801527:	b8 00 00 00 00       	mov    $0x0,%eax
  80152c:	eb 7d                	jmp    8015ab <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  80152e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801535:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80153c:	8b 55 08             	mov    0x8(%ebp),%edx
  80153f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801542:	01 d0                	add    %edx,%eax
  801544:	48                   	dec    %eax
  801545:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801548:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80154b:	ba 00 00 00 00       	mov    $0x0,%edx
  801550:	f7 75 f0             	divl   -0x10(%ebp)
  801553:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801556:	29 d0                	sub    %edx,%eax
  801558:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  80155b:	e8 46 08 00 00       	call   801da6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801560:	83 f8 01             	cmp    $0x1,%eax
  801563:	75 07                	jne    80156c <malloc+0x56>
  801565:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  80156c:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  801570:	75 34                	jne    8015a6 <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  801572:	83 ec 0c             	sub    $0xc,%esp
  801575:	ff 75 e8             	pushl  -0x18(%ebp)
  801578:	e8 73 0e 00 00       	call   8023f0 <alloc_block_FF>
  80157d:	83 c4 10             	add    $0x10,%esp
  801580:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  801583:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801587:	74 16                	je     80159f <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  801589:	83 ec 0c             	sub    $0xc,%esp
  80158c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80158f:	e8 ff 0b 00 00       	call   802193 <insert_sorted_allocList>
  801594:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  801597:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80159a:	8b 40 08             	mov    0x8(%eax),%eax
  80159d:	eb 0c                	jmp    8015ab <malloc+0x95>
	             }
	             else
	             	return NULL;
  80159f:	b8 00 00 00 00       	mov    $0x0,%eax
  8015a4:	eb 05                	jmp    8015ab <malloc+0x95>
	      	  }
	          else
	               return NULL;
  8015a6:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  8015ab:	c9                   	leave  
  8015ac:	c3                   	ret    

008015ad <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8015ad:	55                   	push   %ebp
  8015ae:	89 e5                	mov    %esp,%ebp
  8015b0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  8015b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b6:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  8015b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015c7:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  8015ca:	83 ec 08             	sub    $0x8,%esp
  8015cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8015d0:	68 40 40 80 00       	push   $0x804040
  8015d5:	e8 61 0b 00 00       	call   80213b <find_block>
  8015da:	83 c4 10             	add    $0x10,%esp
  8015dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  8015e0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015e4:	0f 84 a5 00 00 00    	je     80168f <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  8015ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8015f0:	83 ec 08             	sub    $0x8,%esp
  8015f3:	50                   	push   %eax
  8015f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8015f7:	e8 a4 03 00 00       	call   8019a0 <sys_free_user_mem>
  8015fc:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  8015ff:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801603:	75 17                	jne    80161c <free+0x6f>
  801605:	83 ec 04             	sub    $0x4,%esp
  801608:	68 b5 3a 80 00       	push   $0x803ab5
  80160d:	68 87 00 00 00       	push   $0x87
  801612:	68 d3 3a 80 00       	push   $0x803ad3
  801617:	e8 cd ec ff ff       	call   8002e9 <_panic>
  80161c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80161f:	8b 00                	mov    (%eax),%eax
  801621:	85 c0                	test   %eax,%eax
  801623:	74 10                	je     801635 <free+0x88>
  801625:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801628:	8b 00                	mov    (%eax),%eax
  80162a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80162d:	8b 52 04             	mov    0x4(%edx),%edx
  801630:	89 50 04             	mov    %edx,0x4(%eax)
  801633:	eb 0b                	jmp    801640 <free+0x93>
  801635:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801638:	8b 40 04             	mov    0x4(%eax),%eax
  80163b:	a3 44 40 80 00       	mov    %eax,0x804044
  801640:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801643:	8b 40 04             	mov    0x4(%eax),%eax
  801646:	85 c0                	test   %eax,%eax
  801648:	74 0f                	je     801659 <free+0xac>
  80164a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80164d:	8b 40 04             	mov    0x4(%eax),%eax
  801650:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801653:	8b 12                	mov    (%edx),%edx
  801655:	89 10                	mov    %edx,(%eax)
  801657:	eb 0a                	jmp    801663 <free+0xb6>
  801659:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80165c:	8b 00                	mov    (%eax),%eax
  80165e:	a3 40 40 80 00       	mov    %eax,0x804040
  801663:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801666:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80166c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80166f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801676:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80167b:	48                   	dec    %eax
  80167c:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(theBlock);
  801681:	83 ec 0c             	sub    $0xc,%esp
  801684:	ff 75 ec             	pushl  -0x14(%ebp)
  801687:	e8 37 12 00 00       	call   8028c3 <insert_sorted_with_merge_freeList>
  80168c:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  80168f:	90                   	nop
  801690:	c9                   	leave  
  801691:	c3                   	ret    

00801692 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801692:	55                   	push   %ebp
  801693:	89 e5                	mov    %esp,%ebp
  801695:	83 ec 38             	sub    $0x38,%esp
  801698:	8b 45 10             	mov    0x10(%ebp),%eax
  80169b:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80169e:	e8 84 fc ff ff       	call   801327 <InitializeUHeap>
	if (size == 0) return NULL ;
  8016a3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016a7:	75 07                	jne    8016b0 <smalloc+0x1e>
  8016a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ae:	eb 7e                	jmp    80172e <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  8016b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8016b7:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8016be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c4:	01 d0                	add    %edx,%eax
  8016c6:	48                   	dec    %eax
  8016c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d2:	f7 75 f0             	divl   -0x10(%ebp)
  8016d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016d8:	29 d0                	sub    %edx,%eax
  8016da:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  8016dd:	e8 c4 06 00 00       	call   801da6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016e2:	83 f8 01             	cmp    $0x1,%eax
  8016e5:	75 42                	jne    801729 <smalloc+0x97>

		  va = malloc(newsize) ;
  8016e7:	83 ec 0c             	sub    $0xc,%esp
  8016ea:	ff 75 e8             	pushl  -0x18(%ebp)
  8016ed:	e8 24 fe ff ff       	call   801516 <malloc>
  8016f2:	83 c4 10             	add    $0x10,%esp
  8016f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  8016f8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8016fc:	74 24                	je     801722 <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  8016fe:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801702:	ff 75 e4             	pushl  -0x1c(%ebp)
  801705:	50                   	push   %eax
  801706:	ff 75 e8             	pushl  -0x18(%ebp)
  801709:	ff 75 08             	pushl  0x8(%ebp)
  80170c:	e8 1a 04 00 00       	call   801b2b <sys_createSharedObject>
  801711:	83 c4 10             	add    $0x10,%esp
  801714:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  801717:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80171b:	78 0c                	js     801729 <smalloc+0x97>
					  return va ;
  80171d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801720:	eb 0c                	jmp    80172e <smalloc+0x9c>
				 }
				 else
					return NULL;
  801722:	b8 00 00 00 00       	mov    $0x0,%eax
  801727:	eb 05                	jmp    80172e <smalloc+0x9c>
	  }
		  return NULL ;
  801729:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80172e:	c9                   	leave  
  80172f:	c3                   	ret    

00801730 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801730:	55                   	push   %ebp
  801731:	89 e5                	mov    %esp,%ebp
  801733:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801736:	e8 ec fb ff ff       	call   801327 <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  80173b:	83 ec 08             	sub    $0x8,%esp
  80173e:	ff 75 0c             	pushl  0xc(%ebp)
  801741:	ff 75 08             	pushl  0x8(%ebp)
  801744:	e8 0c 04 00 00       	call   801b55 <sys_getSizeOfSharedObject>
  801749:	83 c4 10             	add    $0x10,%esp
  80174c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  80174f:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801753:	75 07                	jne    80175c <sget+0x2c>
  801755:	b8 00 00 00 00       	mov    $0x0,%eax
  80175a:	eb 75                	jmp    8017d1 <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  80175c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801763:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801766:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801769:	01 d0                	add    %edx,%eax
  80176b:	48                   	dec    %eax
  80176c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80176f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801772:	ba 00 00 00 00       	mov    $0x0,%edx
  801777:	f7 75 f0             	divl   -0x10(%ebp)
  80177a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80177d:	29 d0                	sub    %edx,%eax
  80177f:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  801782:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801789:	e8 18 06 00 00       	call   801da6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80178e:	83 f8 01             	cmp    $0x1,%eax
  801791:	75 39                	jne    8017cc <sget+0x9c>

		  va = malloc(newsize) ;
  801793:	83 ec 0c             	sub    $0xc,%esp
  801796:	ff 75 e8             	pushl  -0x18(%ebp)
  801799:	e8 78 fd ff ff       	call   801516 <malloc>
  80179e:	83 c4 10             	add    $0x10,%esp
  8017a1:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  8017a4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8017a8:	74 22                	je     8017cc <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  8017aa:	83 ec 04             	sub    $0x4,%esp
  8017ad:	ff 75 e0             	pushl  -0x20(%ebp)
  8017b0:	ff 75 0c             	pushl  0xc(%ebp)
  8017b3:	ff 75 08             	pushl  0x8(%ebp)
  8017b6:	e8 b7 03 00 00       	call   801b72 <sys_getSharedObject>
  8017bb:	83 c4 10             	add    $0x10,%esp
  8017be:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  8017c1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8017c5:	78 05                	js     8017cc <sget+0x9c>
					  return va;
  8017c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017ca:	eb 05                	jmp    8017d1 <sget+0xa1>
				  }
			  }
     }
         return NULL;
  8017cc:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  8017d1:	c9                   	leave  
  8017d2:	c3                   	ret    

008017d3 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
  8017d6:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017d9:	e8 49 fb ff ff       	call   801327 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017de:	83 ec 04             	sub    $0x4,%esp
  8017e1:	68 04 3b 80 00       	push   $0x803b04
  8017e6:	68 1e 01 00 00       	push   $0x11e
  8017eb:	68 d3 3a 80 00       	push   $0x803ad3
  8017f0:	e8 f4 ea ff ff       	call   8002e9 <_panic>

008017f5 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017f5:	55                   	push   %ebp
  8017f6:	89 e5                	mov    %esp,%ebp
  8017f8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017fb:	83 ec 04             	sub    $0x4,%esp
  8017fe:	68 2c 3b 80 00       	push   $0x803b2c
  801803:	68 32 01 00 00       	push   $0x132
  801808:	68 d3 3a 80 00       	push   $0x803ad3
  80180d:	e8 d7 ea ff ff       	call   8002e9 <_panic>

00801812 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801812:	55                   	push   %ebp
  801813:	89 e5                	mov    %esp,%ebp
  801815:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801818:	83 ec 04             	sub    $0x4,%esp
  80181b:	68 50 3b 80 00       	push   $0x803b50
  801820:	68 3d 01 00 00       	push   $0x13d
  801825:	68 d3 3a 80 00       	push   $0x803ad3
  80182a:	e8 ba ea ff ff       	call   8002e9 <_panic>

0080182f <shrink>:

}
void shrink(uint32 newSize)
{
  80182f:	55                   	push   %ebp
  801830:	89 e5                	mov    %esp,%ebp
  801832:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801835:	83 ec 04             	sub    $0x4,%esp
  801838:	68 50 3b 80 00       	push   $0x803b50
  80183d:	68 42 01 00 00       	push   $0x142
  801842:	68 d3 3a 80 00       	push   $0x803ad3
  801847:	e8 9d ea ff ff       	call   8002e9 <_panic>

0080184c <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
  80184f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801852:	83 ec 04             	sub    $0x4,%esp
  801855:	68 50 3b 80 00       	push   $0x803b50
  80185a:	68 47 01 00 00       	push   $0x147
  80185f:	68 d3 3a 80 00       	push   $0x803ad3
  801864:	e8 80 ea ff ff       	call   8002e9 <_panic>

00801869 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801869:	55                   	push   %ebp
  80186a:	89 e5                	mov    %esp,%ebp
  80186c:	57                   	push   %edi
  80186d:	56                   	push   %esi
  80186e:	53                   	push   %ebx
  80186f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801872:	8b 45 08             	mov    0x8(%ebp),%eax
  801875:	8b 55 0c             	mov    0xc(%ebp),%edx
  801878:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80187b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80187e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801881:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801884:	cd 30                	int    $0x30
  801886:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801889:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80188c:	83 c4 10             	add    $0x10,%esp
  80188f:	5b                   	pop    %ebx
  801890:	5e                   	pop    %esi
  801891:	5f                   	pop    %edi
  801892:	5d                   	pop    %ebp
  801893:	c3                   	ret    

00801894 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801894:	55                   	push   %ebp
  801895:	89 e5                	mov    %esp,%ebp
  801897:	83 ec 04             	sub    $0x4,%esp
  80189a:	8b 45 10             	mov    0x10(%ebp),%eax
  80189d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018a0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	52                   	push   %edx
  8018ac:	ff 75 0c             	pushl  0xc(%ebp)
  8018af:	50                   	push   %eax
  8018b0:	6a 00                	push   $0x0
  8018b2:	e8 b2 ff ff ff       	call   801869 <syscall>
  8018b7:	83 c4 18             	add    $0x18,%esp
}
  8018ba:	90                   	nop
  8018bb:	c9                   	leave  
  8018bc:	c3                   	ret    

008018bd <sys_cgetc>:

int
sys_cgetc(void)
{
  8018bd:	55                   	push   %ebp
  8018be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 01                	push   $0x1
  8018cc:	e8 98 ff ff ff       	call   801869 <syscall>
  8018d1:	83 c4 18             	add    $0x18,%esp
}
  8018d4:	c9                   	leave  
  8018d5:	c3                   	ret    

008018d6 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018d6:	55                   	push   %ebp
  8018d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	52                   	push   %edx
  8018e6:	50                   	push   %eax
  8018e7:	6a 05                	push   $0x5
  8018e9:	e8 7b ff ff ff       	call   801869 <syscall>
  8018ee:	83 c4 18             	add    $0x18,%esp
}
  8018f1:	c9                   	leave  
  8018f2:	c3                   	ret    

008018f3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018f3:	55                   	push   %ebp
  8018f4:	89 e5                	mov    %esp,%ebp
  8018f6:	56                   	push   %esi
  8018f7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018f8:	8b 75 18             	mov    0x18(%ebp),%esi
  8018fb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018fe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801901:	8b 55 0c             	mov    0xc(%ebp),%edx
  801904:	8b 45 08             	mov    0x8(%ebp),%eax
  801907:	56                   	push   %esi
  801908:	53                   	push   %ebx
  801909:	51                   	push   %ecx
  80190a:	52                   	push   %edx
  80190b:	50                   	push   %eax
  80190c:	6a 06                	push   $0x6
  80190e:	e8 56 ff ff ff       	call   801869 <syscall>
  801913:	83 c4 18             	add    $0x18,%esp
}
  801916:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801919:	5b                   	pop    %ebx
  80191a:	5e                   	pop    %esi
  80191b:	5d                   	pop    %ebp
  80191c:	c3                   	ret    

0080191d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80191d:	55                   	push   %ebp
  80191e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801920:	8b 55 0c             	mov    0xc(%ebp),%edx
  801923:	8b 45 08             	mov    0x8(%ebp),%eax
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	52                   	push   %edx
  80192d:	50                   	push   %eax
  80192e:	6a 07                	push   $0x7
  801930:	e8 34 ff ff ff       	call   801869 <syscall>
  801935:	83 c4 18             	add    $0x18,%esp
}
  801938:	c9                   	leave  
  801939:	c3                   	ret    

0080193a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	ff 75 0c             	pushl  0xc(%ebp)
  801946:	ff 75 08             	pushl  0x8(%ebp)
  801949:	6a 08                	push   $0x8
  80194b:	e8 19 ff ff ff       	call   801869 <syscall>
  801950:	83 c4 18             	add    $0x18,%esp
}
  801953:	c9                   	leave  
  801954:	c3                   	ret    

00801955 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801955:	55                   	push   %ebp
  801956:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 09                	push   $0x9
  801964:	e8 00 ff ff ff       	call   801869 <syscall>
  801969:	83 c4 18             	add    $0x18,%esp
}
  80196c:	c9                   	leave  
  80196d:	c3                   	ret    

0080196e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 0a                	push   $0xa
  80197d:	e8 e7 fe ff ff       	call   801869 <syscall>
  801982:	83 c4 18             	add    $0x18,%esp
}
  801985:	c9                   	leave  
  801986:	c3                   	ret    

00801987 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	6a 0b                	push   $0xb
  801996:	e8 ce fe ff ff       	call   801869 <syscall>
  80199b:	83 c4 18             	add    $0x18,%esp
}
  80199e:	c9                   	leave  
  80199f:	c3                   	ret    

008019a0 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	ff 75 0c             	pushl  0xc(%ebp)
  8019ac:	ff 75 08             	pushl  0x8(%ebp)
  8019af:	6a 0f                	push   $0xf
  8019b1:	e8 b3 fe ff ff       	call   801869 <syscall>
  8019b6:	83 c4 18             	add    $0x18,%esp
	return;
  8019b9:	90                   	nop
}
  8019ba:	c9                   	leave  
  8019bb:	c3                   	ret    

008019bc <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019bc:	55                   	push   %ebp
  8019bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	ff 75 0c             	pushl  0xc(%ebp)
  8019c8:	ff 75 08             	pushl  0x8(%ebp)
  8019cb:	6a 10                	push   $0x10
  8019cd:	e8 97 fe ff ff       	call   801869 <syscall>
  8019d2:	83 c4 18             	add    $0x18,%esp
	return ;
  8019d5:	90                   	nop
}
  8019d6:	c9                   	leave  
  8019d7:	c3                   	ret    

008019d8 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019d8:	55                   	push   %ebp
  8019d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	ff 75 10             	pushl  0x10(%ebp)
  8019e2:	ff 75 0c             	pushl  0xc(%ebp)
  8019e5:	ff 75 08             	pushl  0x8(%ebp)
  8019e8:	6a 11                	push   $0x11
  8019ea:	e8 7a fe ff ff       	call   801869 <syscall>
  8019ef:	83 c4 18             	add    $0x18,%esp
	return ;
  8019f2:	90                   	nop
}
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    

008019f5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 0c                	push   $0xc
  801a04:	e8 60 fe ff ff       	call   801869 <syscall>
  801a09:	83 c4 18             	add    $0x18,%esp
}
  801a0c:	c9                   	leave  
  801a0d:	c3                   	ret    

00801a0e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a0e:	55                   	push   %ebp
  801a0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	ff 75 08             	pushl  0x8(%ebp)
  801a1c:	6a 0d                	push   $0xd
  801a1e:	e8 46 fe ff ff       	call   801869 <syscall>
  801a23:	83 c4 18             	add    $0x18,%esp
}
  801a26:	c9                   	leave  
  801a27:	c3                   	ret    

00801a28 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a28:	55                   	push   %ebp
  801a29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 0e                	push   $0xe
  801a37:	e8 2d fe ff ff       	call   801869 <syscall>
  801a3c:	83 c4 18             	add    $0x18,%esp
}
  801a3f:	90                   	nop
  801a40:	c9                   	leave  
  801a41:	c3                   	ret    

00801a42 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a42:	55                   	push   %ebp
  801a43:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 13                	push   $0x13
  801a51:	e8 13 fe ff ff       	call   801869 <syscall>
  801a56:	83 c4 18             	add    $0x18,%esp
}
  801a59:	90                   	nop
  801a5a:	c9                   	leave  
  801a5b:	c3                   	ret    

00801a5c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a5c:	55                   	push   %ebp
  801a5d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 14                	push   $0x14
  801a6b:	e8 f9 fd ff ff       	call   801869 <syscall>
  801a70:	83 c4 18             	add    $0x18,%esp
}
  801a73:	90                   	nop
  801a74:	c9                   	leave  
  801a75:	c3                   	ret    

00801a76 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a76:	55                   	push   %ebp
  801a77:	89 e5                	mov    %esp,%ebp
  801a79:	83 ec 04             	sub    $0x4,%esp
  801a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a82:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	50                   	push   %eax
  801a8f:	6a 15                	push   $0x15
  801a91:	e8 d3 fd ff ff       	call   801869 <syscall>
  801a96:	83 c4 18             	add    $0x18,%esp
}
  801a99:	90                   	nop
  801a9a:	c9                   	leave  
  801a9b:	c3                   	ret    

00801a9c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a9c:	55                   	push   %ebp
  801a9d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 16                	push   $0x16
  801aab:	e8 b9 fd ff ff       	call   801869 <syscall>
  801ab0:	83 c4 18             	add    $0x18,%esp
}
  801ab3:	90                   	nop
  801ab4:	c9                   	leave  
  801ab5:	c3                   	ret    

00801ab6 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801ab6:	55                   	push   %ebp
  801ab7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	ff 75 0c             	pushl  0xc(%ebp)
  801ac5:	50                   	push   %eax
  801ac6:	6a 17                	push   $0x17
  801ac8:	e8 9c fd ff ff       	call   801869 <syscall>
  801acd:	83 c4 18             	add    $0x18,%esp
}
  801ad0:	c9                   	leave  
  801ad1:	c3                   	ret    

00801ad2 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801ad2:	55                   	push   %ebp
  801ad3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ad5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	52                   	push   %edx
  801ae2:	50                   	push   %eax
  801ae3:	6a 1a                	push   $0x1a
  801ae5:	e8 7f fd ff ff       	call   801869 <syscall>
  801aea:	83 c4 18             	add    $0x18,%esp
}
  801aed:	c9                   	leave  
  801aee:	c3                   	ret    

00801aef <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801aef:	55                   	push   %ebp
  801af0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801af2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af5:	8b 45 08             	mov    0x8(%ebp),%eax
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	52                   	push   %edx
  801aff:	50                   	push   %eax
  801b00:	6a 18                	push   $0x18
  801b02:	e8 62 fd ff ff       	call   801869 <syscall>
  801b07:	83 c4 18             	add    $0x18,%esp
}
  801b0a:	90                   	nop
  801b0b:	c9                   	leave  
  801b0c:	c3                   	ret    

00801b0d <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b13:	8b 45 08             	mov    0x8(%ebp),%eax
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	52                   	push   %edx
  801b1d:	50                   	push   %eax
  801b1e:	6a 19                	push   $0x19
  801b20:	e8 44 fd ff ff       	call   801869 <syscall>
  801b25:	83 c4 18             	add    $0x18,%esp
}
  801b28:	90                   	nop
  801b29:	c9                   	leave  
  801b2a:	c3                   	ret    

00801b2b <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b2b:	55                   	push   %ebp
  801b2c:	89 e5                	mov    %esp,%ebp
  801b2e:	83 ec 04             	sub    $0x4,%esp
  801b31:	8b 45 10             	mov    0x10(%ebp),%eax
  801b34:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b37:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b3a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b41:	6a 00                	push   $0x0
  801b43:	51                   	push   %ecx
  801b44:	52                   	push   %edx
  801b45:	ff 75 0c             	pushl  0xc(%ebp)
  801b48:	50                   	push   %eax
  801b49:	6a 1b                	push   $0x1b
  801b4b:	e8 19 fd ff ff       	call   801869 <syscall>
  801b50:	83 c4 18             	add    $0x18,%esp
}
  801b53:	c9                   	leave  
  801b54:	c3                   	ret    

00801b55 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b55:	55                   	push   %ebp
  801b56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b58:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	52                   	push   %edx
  801b65:	50                   	push   %eax
  801b66:	6a 1c                	push   $0x1c
  801b68:	e8 fc fc ff ff       	call   801869 <syscall>
  801b6d:	83 c4 18             	add    $0x18,%esp
}
  801b70:	c9                   	leave  
  801b71:	c3                   	ret    

00801b72 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b75:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b78:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	51                   	push   %ecx
  801b83:	52                   	push   %edx
  801b84:	50                   	push   %eax
  801b85:	6a 1d                	push   $0x1d
  801b87:	e8 dd fc ff ff       	call   801869 <syscall>
  801b8c:	83 c4 18             	add    $0x18,%esp
}
  801b8f:	c9                   	leave  
  801b90:	c3                   	ret    

00801b91 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b91:	55                   	push   %ebp
  801b92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b94:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b97:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	52                   	push   %edx
  801ba1:	50                   	push   %eax
  801ba2:	6a 1e                	push   $0x1e
  801ba4:	e8 c0 fc ff ff       	call   801869 <syscall>
  801ba9:	83 c4 18             	add    $0x18,%esp
}
  801bac:	c9                   	leave  
  801bad:	c3                   	ret    

00801bae <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 1f                	push   $0x1f
  801bbd:	e8 a7 fc ff ff       	call   801869 <syscall>
  801bc2:	83 c4 18             	add    $0x18,%esp
}
  801bc5:	c9                   	leave  
  801bc6:	c3                   	ret    

00801bc7 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bca:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcd:	6a 00                	push   $0x0
  801bcf:	ff 75 14             	pushl  0x14(%ebp)
  801bd2:	ff 75 10             	pushl  0x10(%ebp)
  801bd5:	ff 75 0c             	pushl  0xc(%ebp)
  801bd8:	50                   	push   %eax
  801bd9:	6a 20                	push   $0x20
  801bdb:	e8 89 fc ff ff       	call   801869 <syscall>
  801be0:	83 c4 18             	add    $0x18,%esp
}
  801be3:	c9                   	leave  
  801be4:	c3                   	ret    

00801be5 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801be8:	8b 45 08             	mov    0x8(%ebp),%eax
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	50                   	push   %eax
  801bf4:	6a 21                	push   $0x21
  801bf6:	e8 6e fc ff ff       	call   801869 <syscall>
  801bfb:	83 c4 18             	add    $0x18,%esp
}
  801bfe:	90                   	nop
  801bff:	c9                   	leave  
  801c00:	c3                   	ret    

00801c01 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c01:	55                   	push   %ebp
  801c02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c04:	8b 45 08             	mov    0x8(%ebp),%eax
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	50                   	push   %eax
  801c10:	6a 22                	push   $0x22
  801c12:	e8 52 fc ff ff       	call   801869 <syscall>
  801c17:	83 c4 18             	add    $0x18,%esp
}
  801c1a:	c9                   	leave  
  801c1b:	c3                   	ret    

00801c1c <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c1c:	55                   	push   %ebp
  801c1d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 02                	push   $0x2
  801c2b:	e8 39 fc ff ff       	call   801869 <syscall>
  801c30:	83 c4 18             	add    $0x18,%esp
}
  801c33:	c9                   	leave  
  801c34:	c3                   	ret    

00801c35 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c35:	55                   	push   %ebp
  801c36:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 03                	push   $0x3
  801c44:	e8 20 fc ff ff       	call   801869 <syscall>
  801c49:	83 c4 18             	add    $0x18,%esp
}
  801c4c:	c9                   	leave  
  801c4d:	c3                   	ret    

00801c4e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c4e:	55                   	push   %ebp
  801c4f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 04                	push   $0x4
  801c5d:	e8 07 fc ff ff       	call   801869 <syscall>
  801c62:	83 c4 18             	add    $0x18,%esp
}
  801c65:	c9                   	leave  
  801c66:	c3                   	ret    

00801c67 <sys_exit_env>:


void sys_exit_env(void)
{
  801c67:	55                   	push   %ebp
  801c68:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 23                	push   $0x23
  801c76:	e8 ee fb ff ff       	call   801869 <syscall>
  801c7b:	83 c4 18             	add    $0x18,%esp
}
  801c7e:	90                   	nop
  801c7f:	c9                   	leave  
  801c80:	c3                   	ret    

00801c81 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
  801c84:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c87:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c8a:	8d 50 04             	lea    0x4(%eax),%edx
  801c8d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	52                   	push   %edx
  801c97:	50                   	push   %eax
  801c98:	6a 24                	push   $0x24
  801c9a:	e8 ca fb ff ff       	call   801869 <syscall>
  801c9f:	83 c4 18             	add    $0x18,%esp
	return result;
  801ca2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ca5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ca8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cab:	89 01                	mov    %eax,(%ecx)
  801cad:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb3:	c9                   	leave  
  801cb4:	c2 04 00             	ret    $0x4

00801cb7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cb7:	55                   	push   %ebp
  801cb8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	ff 75 10             	pushl  0x10(%ebp)
  801cc1:	ff 75 0c             	pushl  0xc(%ebp)
  801cc4:	ff 75 08             	pushl  0x8(%ebp)
  801cc7:	6a 12                	push   $0x12
  801cc9:	e8 9b fb ff ff       	call   801869 <syscall>
  801cce:	83 c4 18             	add    $0x18,%esp
	return ;
  801cd1:	90                   	nop
}
  801cd2:	c9                   	leave  
  801cd3:	c3                   	ret    

00801cd4 <sys_rcr2>:
uint32 sys_rcr2()
{
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 25                	push   $0x25
  801ce3:	e8 81 fb ff ff       	call   801869 <syscall>
  801ce8:	83 c4 18             	add    $0x18,%esp
}
  801ceb:	c9                   	leave  
  801cec:	c3                   	ret    

00801ced <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ced:	55                   	push   %ebp
  801cee:	89 e5                	mov    %esp,%ebp
  801cf0:	83 ec 04             	sub    $0x4,%esp
  801cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cf9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	50                   	push   %eax
  801d06:	6a 26                	push   $0x26
  801d08:	e8 5c fb ff ff       	call   801869 <syscall>
  801d0d:	83 c4 18             	add    $0x18,%esp
	return ;
  801d10:	90                   	nop
}
  801d11:	c9                   	leave  
  801d12:	c3                   	ret    

00801d13 <rsttst>:
void rsttst()
{
  801d13:	55                   	push   %ebp
  801d14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 28                	push   $0x28
  801d22:	e8 42 fb ff ff       	call   801869 <syscall>
  801d27:	83 c4 18             	add    $0x18,%esp
	return ;
  801d2a:	90                   	nop
}
  801d2b:	c9                   	leave  
  801d2c:	c3                   	ret    

00801d2d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d2d:	55                   	push   %ebp
  801d2e:	89 e5                	mov    %esp,%ebp
  801d30:	83 ec 04             	sub    $0x4,%esp
  801d33:	8b 45 14             	mov    0x14(%ebp),%eax
  801d36:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d39:	8b 55 18             	mov    0x18(%ebp),%edx
  801d3c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d40:	52                   	push   %edx
  801d41:	50                   	push   %eax
  801d42:	ff 75 10             	pushl  0x10(%ebp)
  801d45:	ff 75 0c             	pushl  0xc(%ebp)
  801d48:	ff 75 08             	pushl  0x8(%ebp)
  801d4b:	6a 27                	push   $0x27
  801d4d:	e8 17 fb ff ff       	call   801869 <syscall>
  801d52:	83 c4 18             	add    $0x18,%esp
	return ;
  801d55:	90                   	nop
}
  801d56:	c9                   	leave  
  801d57:	c3                   	ret    

00801d58 <chktst>:
void chktst(uint32 n)
{
  801d58:	55                   	push   %ebp
  801d59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	ff 75 08             	pushl  0x8(%ebp)
  801d66:	6a 29                	push   $0x29
  801d68:	e8 fc fa ff ff       	call   801869 <syscall>
  801d6d:	83 c4 18             	add    $0x18,%esp
	return ;
  801d70:	90                   	nop
}
  801d71:	c9                   	leave  
  801d72:	c3                   	ret    

00801d73 <inctst>:

void inctst()
{
  801d73:	55                   	push   %ebp
  801d74:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 2a                	push   $0x2a
  801d82:	e8 e2 fa ff ff       	call   801869 <syscall>
  801d87:	83 c4 18             	add    $0x18,%esp
	return ;
  801d8a:	90                   	nop
}
  801d8b:	c9                   	leave  
  801d8c:	c3                   	ret    

00801d8d <gettst>:
uint32 gettst()
{
  801d8d:	55                   	push   %ebp
  801d8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 2b                	push   $0x2b
  801d9c:	e8 c8 fa ff ff       	call   801869 <syscall>
  801da1:	83 c4 18             	add    $0x18,%esp
}
  801da4:	c9                   	leave  
  801da5:	c3                   	ret    

00801da6 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801da6:	55                   	push   %ebp
  801da7:	89 e5                	mov    %esp,%ebp
  801da9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	6a 2c                	push   $0x2c
  801db8:	e8 ac fa ff ff       	call   801869 <syscall>
  801dbd:	83 c4 18             	add    $0x18,%esp
  801dc0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801dc3:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801dc7:	75 07                	jne    801dd0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801dc9:	b8 01 00 00 00       	mov    $0x1,%eax
  801dce:	eb 05                	jmp    801dd5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801dd0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dd5:	c9                   	leave  
  801dd6:	c3                   	ret    

00801dd7 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801dd7:	55                   	push   %ebp
  801dd8:	89 e5                	mov    %esp,%ebp
  801dda:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	6a 2c                	push   $0x2c
  801de9:	e8 7b fa ff ff       	call   801869 <syscall>
  801dee:	83 c4 18             	add    $0x18,%esp
  801df1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801df4:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801df8:	75 07                	jne    801e01 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801dfa:	b8 01 00 00 00       	mov    $0x1,%eax
  801dff:	eb 05                	jmp    801e06 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e06:	c9                   	leave  
  801e07:	c3                   	ret    

00801e08 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e08:	55                   	push   %ebp
  801e09:	89 e5                	mov    %esp,%ebp
  801e0b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	6a 00                	push   $0x0
  801e18:	6a 2c                	push   $0x2c
  801e1a:	e8 4a fa ff ff       	call   801869 <syscall>
  801e1f:	83 c4 18             	add    $0x18,%esp
  801e22:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e25:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e29:	75 07                	jne    801e32 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e2b:	b8 01 00 00 00       	mov    $0x1,%eax
  801e30:	eb 05                	jmp    801e37 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e37:	c9                   	leave  
  801e38:	c3                   	ret    

00801e39 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e39:	55                   	push   %ebp
  801e3a:	89 e5                	mov    %esp,%ebp
  801e3c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	6a 00                	push   $0x0
  801e47:	6a 00                	push   $0x0
  801e49:	6a 2c                	push   $0x2c
  801e4b:	e8 19 fa ff ff       	call   801869 <syscall>
  801e50:	83 c4 18             	add    $0x18,%esp
  801e53:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e56:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e5a:	75 07                	jne    801e63 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e5c:	b8 01 00 00 00       	mov    $0x1,%eax
  801e61:	eb 05                	jmp    801e68 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e63:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e68:	c9                   	leave  
  801e69:	c3                   	ret    

00801e6a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	ff 75 08             	pushl  0x8(%ebp)
  801e78:	6a 2d                	push   $0x2d
  801e7a:	e8 ea f9 ff ff       	call   801869 <syscall>
  801e7f:	83 c4 18             	add    $0x18,%esp
	return ;
  801e82:	90                   	nop
}
  801e83:	c9                   	leave  
  801e84:	c3                   	ret    

00801e85 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e85:	55                   	push   %ebp
  801e86:	89 e5                	mov    %esp,%ebp
  801e88:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e89:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e8c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e92:	8b 45 08             	mov    0x8(%ebp),%eax
  801e95:	6a 00                	push   $0x0
  801e97:	53                   	push   %ebx
  801e98:	51                   	push   %ecx
  801e99:	52                   	push   %edx
  801e9a:	50                   	push   %eax
  801e9b:	6a 2e                	push   $0x2e
  801e9d:	e8 c7 f9 ff ff       	call   801869 <syscall>
  801ea2:	83 c4 18             	add    $0x18,%esp
}
  801ea5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ea8:	c9                   	leave  
  801ea9:	c3                   	ret    

00801eaa <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801eaa:	55                   	push   %ebp
  801eab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ead:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	52                   	push   %edx
  801eba:	50                   	push   %eax
  801ebb:	6a 2f                	push   $0x2f
  801ebd:	e8 a7 f9 ff ff       	call   801869 <syscall>
  801ec2:	83 c4 18             	add    $0x18,%esp
}
  801ec5:	c9                   	leave  
  801ec6:	c3                   	ret    

00801ec7 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801ec7:	55                   	push   %ebp
  801ec8:	89 e5                	mov    %esp,%ebp
  801eca:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801ecd:	83 ec 0c             	sub    $0xc,%esp
  801ed0:	68 60 3b 80 00       	push   $0x803b60
  801ed5:	e8 c3 e6 ff ff       	call   80059d <cprintf>
  801eda:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801edd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801ee4:	83 ec 0c             	sub    $0xc,%esp
  801ee7:	68 8c 3b 80 00       	push   $0x803b8c
  801eec:	e8 ac e6 ff ff       	call   80059d <cprintf>
  801ef1:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801ef4:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ef8:	a1 38 41 80 00       	mov    0x804138,%eax
  801efd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f00:	eb 56                	jmp    801f58 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f02:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f06:	74 1c                	je     801f24 <print_mem_block_lists+0x5d>
  801f08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0b:	8b 50 08             	mov    0x8(%eax),%edx
  801f0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f11:	8b 48 08             	mov    0x8(%eax),%ecx
  801f14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f17:	8b 40 0c             	mov    0xc(%eax),%eax
  801f1a:	01 c8                	add    %ecx,%eax
  801f1c:	39 c2                	cmp    %eax,%edx
  801f1e:	73 04                	jae    801f24 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f20:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f27:	8b 50 08             	mov    0x8(%eax),%edx
  801f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2d:	8b 40 0c             	mov    0xc(%eax),%eax
  801f30:	01 c2                	add    %eax,%edx
  801f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f35:	8b 40 08             	mov    0x8(%eax),%eax
  801f38:	83 ec 04             	sub    $0x4,%esp
  801f3b:	52                   	push   %edx
  801f3c:	50                   	push   %eax
  801f3d:	68 a1 3b 80 00       	push   $0x803ba1
  801f42:	e8 56 e6 ff ff       	call   80059d <cprintf>
  801f47:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f50:	a1 40 41 80 00       	mov    0x804140,%eax
  801f55:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f58:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f5c:	74 07                	je     801f65 <print_mem_block_lists+0x9e>
  801f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f61:	8b 00                	mov    (%eax),%eax
  801f63:	eb 05                	jmp    801f6a <print_mem_block_lists+0xa3>
  801f65:	b8 00 00 00 00       	mov    $0x0,%eax
  801f6a:	a3 40 41 80 00       	mov    %eax,0x804140
  801f6f:	a1 40 41 80 00       	mov    0x804140,%eax
  801f74:	85 c0                	test   %eax,%eax
  801f76:	75 8a                	jne    801f02 <print_mem_block_lists+0x3b>
  801f78:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f7c:	75 84                	jne    801f02 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f7e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f82:	75 10                	jne    801f94 <print_mem_block_lists+0xcd>
  801f84:	83 ec 0c             	sub    $0xc,%esp
  801f87:	68 b0 3b 80 00       	push   $0x803bb0
  801f8c:	e8 0c e6 ff ff       	call   80059d <cprintf>
  801f91:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f94:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f9b:	83 ec 0c             	sub    $0xc,%esp
  801f9e:	68 d4 3b 80 00       	push   $0x803bd4
  801fa3:	e8 f5 e5 ff ff       	call   80059d <cprintf>
  801fa8:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801fab:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801faf:	a1 40 40 80 00       	mov    0x804040,%eax
  801fb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fb7:	eb 56                	jmp    80200f <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fb9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fbd:	74 1c                	je     801fdb <print_mem_block_lists+0x114>
  801fbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc2:	8b 50 08             	mov    0x8(%eax),%edx
  801fc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc8:	8b 48 08             	mov    0x8(%eax),%ecx
  801fcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fce:	8b 40 0c             	mov    0xc(%eax),%eax
  801fd1:	01 c8                	add    %ecx,%eax
  801fd3:	39 c2                	cmp    %eax,%edx
  801fd5:	73 04                	jae    801fdb <print_mem_block_lists+0x114>
			sorted = 0 ;
  801fd7:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fde:	8b 50 08             	mov    0x8(%eax),%edx
  801fe1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe4:	8b 40 0c             	mov    0xc(%eax),%eax
  801fe7:	01 c2                	add    %eax,%edx
  801fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fec:	8b 40 08             	mov    0x8(%eax),%eax
  801fef:	83 ec 04             	sub    $0x4,%esp
  801ff2:	52                   	push   %edx
  801ff3:	50                   	push   %eax
  801ff4:	68 a1 3b 80 00       	push   $0x803ba1
  801ff9:	e8 9f e5 ff ff       	call   80059d <cprintf>
  801ffe:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802001:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802004:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802007:	a1 48 40 80 00       	mov    0x804048,%eax
  80200c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80200f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802013:	74 07                	je     80201c <print_mem_block_lists+0x155>
  802015:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802018:	8b 00                	mov    (%eax),%eax
  80201a:	eb 05                	jmp    802021 <print_mem_block_lists+0x15a>
  80201c:	b8 00 00 00 00       	mov    $0x0,%eax
  802021:	a3 48 40 80 00       	mov    %eax,0x804048
  802026:	a1 48 40 80 00       	mov    0x804048,%eax
  80202b:	85 c0                	test   %eax,%eax
  80202d:	75 8a                	jne    801fb9 <print_mem_block_lists+0xf2>
  80202f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802033:	75 84                	jne    801fb9 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802035:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802039:	75 10                	jne    80204b <print_mem_block_lists+0x184>
  80203b:	83 ec 0c             	sub    $0xc,%esp
  80203e:	68 ec 3b 80 00       	push   $0x803bec
  802043:	e8 55 e5 ff ff       	call   80059d <cprintf>
  802048:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80204b:	83 ec 0c             	sub    $0xc,%esp
  80204e:	68 60 3b 80 00       	push   $0x803b60
  802053:	e8 45 e5 ff ff       	call   80059d <cprintf>
  802058:	83 c4 10             	add    $0x10,%esp

}
  80205b:	90                   	nop
  80205c:	c9                   	leave  
  80205d:	c3                   	ret    

0080205e <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80205e:	55                   	push   %ebp
  80205f:	89 e5                	mov    %esp,%ebp
  802061:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  802064:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  80206b:	00 00 00 
  80206e:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802075:	00 00 00 
  802078:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  80207f:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802082:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802089:	e9 9e 00 00 00       	jmp    80212c <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  80208e:	a1 50 40 80 00       	mov    0x804050,%eax
  802093:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802096:	c1 e2 04             	shl    $0x4,%edx
  802099:	01 d0                	add    %edx,%eax
  80209b:	85 c0                	test   %eax,%eax
  80209d:	75 14                	jne    8020b3 <initialize_MemBlocksList+0x55>
  80209f:	83 ec 04             	sub    $0x4,%esp
  8020a2:	68 14 3c 80 00       	push   $0x803c14
  8020a7:	6a 47                	push   $0x47
  8020a9:	68 37 3c 80 00       	push   $0x803c37
  8020ae:	e8 36 e2 ff ff       	call   8002e9 <_panic>
  8020b3:	a1 50 40 80 00       	mov    0x804050,%eax
  8020b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020bb:	c1 e2 04             	shl    $0x4,%edx
  8020be:	01 d0                	add    %edx,%eax
  8020c0:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8020c6:	89 10                	mov    %edx,(%eax)
  8020c8:	8b 00                	mov    (%eax),%eax
  8020ca:	85 c0                	test   %eax,%eax
  8020cc:	74 18                	je     8020e6 <initialize_MemBlocksList+0x88>
  8020ce:	a1 48 41 80 00       	mov    0x804148,%eax
  8020d3:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8020d9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8020dc:	c1 e1 04             	shl    $0x4,%ecx
  8020df:	01 ca                	add    %ecx,%edx
  8020e1:	89 50 04             	mov    %edx,0x4(%eax)
  8020e4:	eb 12                	jmp    8020f8 <initialize_MemBlocksList+0x9a>
  8020e6:	a1 50 40 80 00       	mov    0x804050,%eax
  8020eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020ee:	c1 e2 04             	shl    $0x4,%edx
  8020f1:	01 d0                	add    %edx,%eax
  8020f3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8020f8:	a1 50 40 80 00       	mov    0x804050,%eax
  8020fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802100:	c1 e2 04             	shl    $0x4,%edx
  802103:	01 d0                	add    %edx,%eax
  802105:	a3 48 41 80 00       	mov    %eax,0x804148
  80210a:	a1 50 40 80 00       	mov    0x804050,%eax
  80210f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802112:	c1 e2 04             	shl    $0x4,%edx
  802115:	01 d0                	add    %edx,%eax
  802117:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80211e:	a1 54 41 80 00       	mov    0x804154,%eax
  802123:	40                   	inc    %eax
  802124:	a3 54 41 80 00       	mov    %eax,0x804154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802129:	ff 45 f4             	incl   -0xc(%ebp)
  80212c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802132:	0f 82 56 ff ff ff    	jb     80208e <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  802138:	90                   	nop
  802139:	c9                   	leave  
  80213a:	c3                   	ret    

0080213b <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80213b:	55                   	push   %ebp
  80213c:	89 e5                	mov    %esp,%ebp
  80213e:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802141:	8b 45 08             	mov    0x8(%ebp),%eax
  802144:	8b 00                	mov    (%eax),%eax
  802146:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802149:	eb 19                	jmp    802164 <find_block+0x29>
	{
		if(element->sva == va){
  80214b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80214e:	8b 40 08             	mov    0x8(%eax),%eax
  802151:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802154:	75 05                	jne    80215b <find_block+0x20>
			 		return element;
  802156:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802159:	eb 36                	jmp    802191 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  80215b:	8b 45 08             	mov    0x8(%ebp),%eax
  80215e:	8b 40 08             	mov    0x8(%eax),%eax
  802161:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802164:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802168:	74 07                	je     802171 <find_block+0x36>
  80216a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80216d:	8b 00                	mov    (%eax),%eax
  80216f:	eb 05                	jmp    802176 <find_block+0x3b>
  802171:	b8 00 00 00 00       	mov    $0x0,%eax
  802176:	8b 55 08             	mov    0x8(%ebp),%edx
  802179:	89 42 08             	mov    %eax,0x8(%edx)
  80217c:	8b 45 08             	mov    0x8(%ebp),%eax
  80217f:	8b 40 08             	mov    0x8(%eax),%eax
  802182:	85 c0                	test   %eax,%eax
  802184:	75 c5                	jne    80214b <find_block+0x10>
  802186:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80218a:	75 bf                	jne    80214b <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  80218c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802191:	c9                   	leave  
  802192:	c3                   	ret    

00802193 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802193:	55                   	push   %ebp
  802194:	89 e5                	mov    %esp,%ebp
  802196:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  802199:	a1 44 40 80 00       	mov    0x804044,%eax
  80219e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  8021a1:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  8021a9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021ad:	74 0a                	je     8021b9 <insert_sorted_allocList+0x26>
  8021af:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b2:	8b 40 08             	mov    0x8(%eax),%eax
  8021b5:	85 c0                	test   %eax,%eax
  8021b7:	75 65                	jne    80221e <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8021b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021bd:	75 14                	jne    8021d3 <insert_sorted_allocList+0x40>
  8021bf:	83 ec 04             	sub    $0x4,%esp
  8021c2:	68 14 3c 80 00       	push   $0x803c14
  8021c7:	6a 6e                	push   $0x6e
  8021c9:	68 37 3c 80 00       	push   $0x803c37
  8021ce:	e8 16 e1 ff ff       	call   8002e9 <_panic>
  8021d3:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8021d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021dc:	89 10                	mov    %edx,(%eax)
  8021de:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e1:	8b 00                	mov    (%eax),%eax
  8021e3:	85 c0                	test   %eax,%eax
  8021e5:	74 0d                	je     8021f4 <insert_sorted_allocList+0x61>
  8021e7:	a1 40 40 80 00       	mov    0x804040,%eax
  8021ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8021ef:	89 50 04             	mov    %edx,0x4(%eax)
  8021f2:	eb 08                	jmp    8021fc <insert_sorted_allocList+0x69>
  8021f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f7:	a3 44 40 80 00       	mov    %eax,0x804044
  8021fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ff:	a3 40 40 80 00       	mov    %eax,0x804040
  802204:	8b 45 08             	mov    0x8(%ebp),%eax
  802207:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80220e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802213:	40                   	inc    %eax
  802214:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802219:	e9 cf 01 00 00       	jmp    8023ed <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  80221e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802221:	8b 50 08             	mov    0x8(%eax),%edx
  802224:	8b 45 08             	mov    0x8(%ebp),%eax
  802227:	8b 40 08             	mov    0x8(%eax),%eax
  80222a:	39 c2                	cmp    %eax,%edx
  80222c:	73 65                	jae    802293 <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80222e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802232:	75 14                	jne    802248 <insert_sorted_allocList+0xb5>
  802234:	83 ec 04             	sub    $0x4,%esp
  802237:	68 50 3c 80 00       	push   $0x803c50
  80223c:	6a 72                	push   $0x72
  80223e:	68 37 3c 80 00       	push   $0x803c37
  802243:	e8 a1 e0 ff ff       	call   8002e9 <_panic>
  802248:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80224e:	8b 45 08             	mov    0x8(%ebp),%eax
  802251:	89 50 04             	mov    %edx,0x4(%eax)
  802254:	8b 45 08             	mov    0x8(%ebp),%eax
  802257:	8b 40 04             	mov    0x4(%eax),%eax
  80225a:	85 c0                	test   %eax,%eax
  80225c:	74 0c                	je     80226a <insert_sorted_allocList+0xd7>
  80225e:	a1 44 40 80 00       	mov    0x804044,%eax
  802263:	8b 55 08             	mov    0x8(%ebp),%edx
  802266:	89 10                	mov    %edx,(%eax)
  802268:	eb 08                	jmp    802272 <insert_sorted_allocList+0xdf>
  80226a:	8b 45 08             	mov    0x8(%ebp),%eax
  80226d:	a3 40 40 80 00       	mov    %eax,0x804040
  802272:	8b 45 08             	mov    0x8(%ebp),%eax
  802275:	a3 44 40 80 00       	mov    %eax,0x804044
  80227a:	8b 45 08             	mov    0x8(%ebp),%eax
  80227d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802283:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802288:	40                   	inc    %eax
  802289:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  80228e:	e9 5a 01 00 00       	jmp    8023ed <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  802293:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802296:	8b 50 08             	mov    0x8(%eax),%edx
  802299:	8b 45 08             	mov    0x8(%ebp),%eax
  80229c:	8b 40 08             	mov    0x8(%eax),%eax
  80229f:	39 c2                	cmp    %eax,%edx
  8022a1:	75 70                	jne    802313 <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  8022a3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022a7:	74 06                	je     8022af <insert_sorted_allocList+0x11c>
  8022a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022ad:	75 14                	jne    8022c3 <insert_sorted_allocList+0x130>
  8022af:	83 ec 04             	sub    $0x4,%esp
  8022b2:	68 74 3c 80 00       	push   $0x803c74
  8022b7:	6a 75                	push   $0x75
  8022b9:	68 37 3c 80 00       	push   $0x803c37
  8022be:	e8 26 e0 ff ff       	call   8002e9 <_panic>
  8022c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c6:	8b 10                	mov    (%eax),%edx
  8022c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cb:	89 10                	mov    %edx,(%eax)
  8022cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d0:	8b 00                	mov    (%eax),%eax
  8022d2:	85 c0                	test   %eax,%eax
  8022d4:	74 0b                	je     8022e1 <insert_sorted_allocList+0x14e>
  8022d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d9:	8b 00                	mov    (%eax),%eax
  8022db:	8b 55 08             	mov    0x8(%ebp),%edx
  8022de:	89 50 04             	mov    %edx,0x4(%eax)
  8022e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8022e7:	89 10                	mov    %edx,(%eax)
  8022e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022ef:	89 50 04             	mov    %edx,0x4(%eax)
  8022f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f5:	8b 00                	mov    (%eax),%eax
  8022f7:	85 c0                	test   %eax,%eax
  8022f9:	75 08                	jne    802303 <insert_sorted_allocList+0x170>
  8022fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fe:	a3 44 40 80 00       	mov    %eax,0x804044
  802303:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802308:	40                   	inc    %eax
  802309:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  80230e:	e9 da 00 00 00       	jmp    8023ed <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802313:	a1 40 40 80 00       	mov    0x804040,%eax
  802318:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80231b:	e9 9d 00 00 00       	jmp    8023bd <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  802320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802323:	8b 00                	mov    (%eax),%eax
  802325:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  802328:	8b 45 08             	mov    0x8(%ebp),%eax
  80232b:	8b 50 08             	mov    0x8(%eax),%edx
  80232e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802331:	8b 40 08             	mov    0x8(%eax),%eax
  802334:	39 c2                	cmp    %eax,%edx
  802336:	76 7d                	jbe    8023b5 <insert_sorted_allocList+0x222>
  802338:	8b 45 08             	mov    0x8(%ebp),%eax
  80233b:	8b 50 08             	mov    0x8(%eax),%edx
  80233e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802341:	8b 40 08             	mov    0x8(%eax),%eax
  802344:	39 c2                	cmp    %eax,%edx
  802346:	73 6d                	jae    8023b5 <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802348:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80234c:	74 06                	je     802354 <insert_sorted_allocList+0x1c1>
  80234e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802352:	75 14                	jne    802368 <insert_sorted_allocList+0x1d5>
  802354:	83 ec 04             	sub    $0x4,%esp
  802357:	68 74 3c 80 00       	push   $0x803c74
  80235c:	6a 7c                	push   $0x7c
  80235e:	68 37 3c 80 00       	push   $0x803c37
  802363:	e8 81 df ff ff       	call   8002e9 <_panic>
  802368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236b:	8b 10                	mov    (%eax),%edx
  80236d:	8b 45 08             	mov    0x8(%ebp),%eax
  802370:	89 10                	mov    %edx,(%eax)
  802372:	8b 45 08             	mov    0x8(%ebp),%eax
  802375:	8b 00                	mov    (%eax),%eax
  802377:	85 c0                	test   %eax,%eax
  802379:	74 0b                	je     802386 <insert_sorted_allocList+0x1f3>
  80237b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237e:	8b 00                	mov    (%eax),%eax
  802380:	8b 55 08             	mov    0x8(%ebp),%edx
  802383:	89 50 04             	mov    %edx,0x4(%eax)
  802386:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802389:	8b 55 08             	mov    0x8(%ebp),%edx
  80238c:	89 10                	mov    %edx,(%eax)
  80238e:	8b 45 08             	mov    0x8(%ebp),%eax
  802391:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802394:	89 50 04             	mov    %edx,0x4(%eax)
  802397:	8b 45 08             	mov    0x8(%ebp),%eax
  80239a:	8b 00                	mov    (%eax),%eax
  80239c:	85 c0                	test   %eax,%eax
  80239e:	75 08                	jne    8023a8 <insert_sorted_allocList+0x215>
  8023a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a3:	a3 44 40 80 00       	mov    %eax,0x804044
  8023a8:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023ad:	40                   	inc    %eax
  8023ae:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8023b3:	eb 38                	jmp    8023ed <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  8023b5:	a1 48 40 80 00       	mov    0x804048,%eax
  8023ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023c1:	74 07                	je     8023ca <insert_sorted_allocList+0x237>
  8023c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c6:	8b 00                	mov    (%eax),%eax
  8023c8:	eb 05                	jmp    8023cf <insert_sorted_allocList+0x23c>
  8023ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8023cf:	a3 48 40 80 00       	mov    %eax,0x804048
  8023d4:	a1 48 40 80 00       	mov    0x804048,%eax
  8023d9:	85 c0                	test   %eax,%eax
  8023db:	0f 85 3f ff ff ff    	jne    802320 <insert_sorted_allocList+0x18d>
  8023e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023e5:	0f 85 35 ff ff ff    	jne    802320 <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  8023eb:	eb 00                	jmp    8023ed <insert_sorted_allocList+0x25a>
  8023ed:	90                   	nop
  8023ee:	c9                   	leave  
  8023ef:	c3                   	ret    

008023f0 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8023f0:	55                   	push   %ebp
  8023f1:	89 e5                	mov    %esp,%ebp
  8023f3:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  8023f6:	a1 38 41 80 00       	mov    0x804138,%eax
  8023fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023fe:	e9 6b 02 00 00       	jmp    80266e <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  802403:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802406:	8b 40 0c             	mov    0xc(%eax),%eax
  802409:	3b 45 08             	cmp    0x8(%ebp),%eax
  80240c:	0f 85 90 00 00 00    	jne    8024a2 <alloc_block_FF+0xb2>
			  temp=element;
  802412:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802415:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  802418:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80241c:	75 17                	jne    802435 <alloc_block_FF+0x45>
  80241e:	83 ec 04             	sub    $0x4,%esp
  802421:	68 a8 3c 80 00       	push   $0x803ca8
  802426:	68 92 00 00 00       	push   $0x92
  80242b:	68 37 3c 80 00       	push   $0x803c37
  802430:	e8 b4 de ff ff       	call   8002e9 <_panic>
  802435:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802438:	8b 00                	mov    (%eax),%eax
  80243a:	85 c0                	test   %eax,%eax
  80243c:	74 10                	je     80244e <alloc_block_FF+0x5e>
  80243e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802441:	8b 00                	mov    (%eax),%eax
  802443:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802446:	8b 52 04             	mov    0x4(%edx),%edx
  802449:	89 50 04             	mov    %edx,0x4(%eax)
  80244c:	eb 0b                	jmp    802459 <alloc_block_FF+0x69>
  80244e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802451:	8b 40 04             	mov    0x4(%eax),%eax
  802454:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802459:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245c:	8b 40 04             	mov    0x4(%eax),%eax
  80245f:	85 c0                	test   %eax,%eax
  802461:	74 0f                	je     802472 <alloc_block_FF+0x82>
  802463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802466:	8b 40 04             	mov    0x4(%eax),%eax
  802469:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80246c:	8b 12                	mov    (%edx),%edx
  80246e:	89 10                	mov    %edx,(%eax)
  802470:	eb 0a                	jmp    80247c <alloc_block_FF+0x8c>
  802472:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802475:	8b 00                	mov    (%eax),%eax
  802477:	a3 38 41 80 00       	mov    %eax,0x804138
  80247c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802485:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802488:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80248f:	a1 44 41 80 00       	mov    0x804144,%eax
  802494:	48                   	dec    %eax
  802495:	a3 44 41 80 00       	mov    %eax,0x804144
			  return temp;
  80249a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80249d:	e9 ff 01 00 00       	jmp    8026a1 <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  8024a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8024a8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024ab:	0f 86 b5 01 00 00    	jbe    802666 <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  8024b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8024b7:	2b 45 08             	sub    0x8(%ebp),%eax
  8024ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  8024bd:	a1 48 41 80 00       	mov    0x804148,%eax
  8024c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  8024c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8024c9:	75 17                	jne    8024e2 <alloc_block_FF+0xf2>
  8024cb:	83 ec 04             	sub    $0x4,%esp
  8024ce:	68 a8 3c 80 00       	push   $0x803ca8
  8024d3:	68 99 00 00 00       	push   $0x99
  8024d8:	68 37 3c 80 00       	push   $0x803c37
  8024dd:	e8 07 de ff ff       	call   8002e9 <_panic>
  8024e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024e5:	8b 00                	mov    (%eax),%eax
  8024e7:	85 c0                	test   %eax,%eax
  8024e9:	74 10                	je     8024fb <alloc_block_FF+0x10b>
  8024eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024ee:	8b 00                	mov    (%eax),%eax
  8024f0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024f3:	8b 52 04             	mov    0x4(%edx),%edx
  8024f6:	89 50 04             	mov    %edx,0x4(%eax)
  8024f9:	eb 0b                	jmp    802506 <alloc_block_FF+0x116>
  8024fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024fe:	8b 40 04             	mov    0x4(%eax),%eax
  802501:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802506:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802509:	8b 40 04             	mov    0x4(%eax),%eax
  80250c:	85 c0                	test   %eax,%eax
  80250e:	74 0f                	je     80251f <alloc_block_FF+0x12f>
  802510:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802513:	8b 40 04             	mov    0x4(%eax),%eax
  802516:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802519:	8b 12                	mov    (%edx),%edx
  80251b:	89 10                	mov    %edx,(%eax)
  80251d:	eb 0a                	jmp    802529 <alloc_block_FF+0x139>
  80251f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802522:	8b 00                	mov    (%eax),%eax
  802524:	a3 48 41 80 00       	mov    %eax,0x804148
  802529:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80252c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802532:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802535:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80253c:	a1 54 41 80 00       	mov    0x804154,%eax
  802541:	48                   	dec    %eax
  802542:	a3 54 41 80 00       	mov    %eax,0x804154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  802547:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80254b:	75 17                	jne    802564 <alloc_block_FF+0x174>
  80254d:	83 ec 04             	sub    $0x4,%esp
  802550:	68 50 3c 80 00       	push   $0x803c50
  802555:	68 9a 00 00 00       	push   $0x9a
  80255a:	68 37 3c 80 00       	push   $0x803c37
  80255f:	e8 85 dd ff ff       	call   8002e9 <_panic>
  802564:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  80256a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80256d:	89 50 04             	mov    %edx,0x4(%eax)
  802570:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802573:	8b 40 04             	mov    0x4(%eax),%eax
  802576:	85 c0                	test   %eax,%eax
  802578:	74 0c                	je     802586 <alloc_block_FF+0x196>
  80257a:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80257f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802582:	89 10                	mov    %edx,(%eax)
  802584:	eb 08                	jmp    80258e <alloc_block_FF+0x19e>
  802586:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802589:	a3 38 41 80 00       	mov    %eax,0x804138
  80258e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802591:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802596:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802599:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80259f:	a1 44 41 80 00       	mov    0x804144,%eax
  8025a4:	40                   	inc    %eax
  8025a5:	a3 44 41 80 00       	mov    %eax,0x804144
		  // setting the size & sva
		  new_block->size=size;
  8025aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8025b0:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  8025b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b6:	8b 50 08             	mov    0x8(%eax),%edx
  8025b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025bc:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  8025bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025c5:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  8025c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cb:	8b 50 08             	mov    0x8(%eax),%edx
  8025ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d1:	01 c2                	add    %eax,%edx
  8025d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d6:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  8025d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025dc:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  8025df:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025e3:	75 17                	jne    8025fc <alloc_block_FF+0x20c>
  8025e5:	83 ec 04             	sub    $0x4,%esp
  8025e8:	68 a8 3c 80 00       	push   $0x803ca8
  8025ed:	68 a2 00 00 00       	push   $0xa2
  8025f2:	68 37 3c 80 00       	push   $0x803c37
  8025f7:	e8 ed dc ff ff       	call   8002e9 <_panic>
  8025fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ff:	8b 00                	mov    (%eax),%eax
  802601:	85 c0                	test   %eax,%eax
  802603:	74 10                	je     802615 <alloc_block_FF+0x225>
  802605:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802608:	8b 00                	mov    (%eax),%eax
  80260a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80260d:	8b 52 04             	mov    0x4(%edx),%edx
  802610:	89 50 04             	mov    %edx,0x4(%eax)
  802613:	eb 0b                	jmp    802620 <alloc_block_FF+0x230>
  802615:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802618:	8b 40 04             	mov    0x4(%eax),%eax
  80261b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802620:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802623:	8b 40 04             	mov    0x4(%eax),%eax
  802626:	85 c0                	test   %eax,%eax
  802628:	74 0f                	je     802639 <alloc_block_FF+0x249>
  80262a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80262d:	8b 40 04             	mov    0x4(%eax),%eax
  802630:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802633:	8b 12                	mov    (%edx),%edx
  802635:	89 10                	mov    %edx,(%eax)
  802637:	eb 0a                	jmp    802643 <alloc_block_FF+0x253>
  802639:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80263c:	8b 00                	mov    (%eax),%eax
  80263e:	a3 38 41 80 00       	mov    %eax,0x804138
  802643:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802646:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80264c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80264f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802656:	a1 44 41 80 00       	mov    0x804144,%eax
  80265b:	48                   	dec    %eax
  80265c:	a3 44 41 80 00       	mov    %eax,0x804144
		  return temp;
  802661:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802664:	eb 3b                	jmp    8026a1 <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802666:	a1 40 41 80 00       	mov    0x804140,%eax
  80266b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80266e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802672:	74 07                	je     80267b <alloc_block_FF+0x28b>
  802674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802677:	8b 00                	mov    (%eax),%eax
  802679:	eb 05                	jmp    802680 <alloc_block_FF+0x290>
  80267b:	b8 00 00 00 00       	mov    $0x0,%eax
  802680:	a3 40 41 80 00       	mov    %eax,0x804140
  802685:	a1 40 41 80 00       	mov    0x804140,%eax
  80268a:	85 c0                	test   %eax,%eax
  80268c:	0f 85 71 fd ff ff    	jne    802403 <alloc_block_FF+0x13>
  802692:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802696:	0f 85 67 fd ff ff    	jne    802403 <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  80269c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026a1:	c9                   	leave  
  8026a2:	c3                   	ret    

008026a3 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8026a3:	55                   	push   %ebp
  8026a4:	89 e5                	mov    %esp,%ebp
  8026a6:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  8026a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  8026b0:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  8026b7:	a1 38 41 80 00       	mov    0x804138,%eax
  8026bc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8026bf:	e9 d3 00 00 00       	jmp    802797 <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  8026c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ca:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026cd:	0f 85 90 00 00 00    	jne    802763 <alloc_block_BF+0xc0>
	   temp = element;
  8026d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026d6:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  8026d9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026dd:	75 17                	jne    8026f6 <alloc_block_BF+0x53>
  8026df:	83 ec 04             	sub    $0x4,%esp
  8026e2:	68 a8 3c 80 00       	push   $0x803ca8
  8026e7:	68 bd 00 00 00       	push   $0xbd
  8026ec:	68 37 3c 80 00       	push   $0x803c37
  8026f1:	e8 f3 db ff ff       	call   8002e9 <_panic>
  8026f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026f9:	8b 00                	mov    (%eax),%eax
  8026fb:	85 c0                	test   %eax,%eax
  8026fd:	74 10                	je     80270f <alloc_block_BF+0x6c>
  8026ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802702:	8b 00                	mov    (%eax),%eax
  802704:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802707:	8b 52 04             	mov    0x4(%edx),%edx
  80270a:	89 50 04             	mov    %edx,0x4(%eax)
  80270d:	eb 0b                	jmp    80271a <alloc_block_BF+0x77>
  80270f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802712:	8b 40 04             	mov    0x4(%eax),%eax
  802715:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80271a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80271d:	8b 40 04             	mov    0x4(%eax),%eax
  802720:	85 c0                	test   %eax,%eax
  802722:	74 0f                	je     802733 <alloc_block_BF+0x90>
  802724:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802727:	8b 40 04             	mov    0x4(%eax),%eax
  80272a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80272d:	8b 12                	mov    (%edx),%edx
  80272f:	89 10                	mov    %edx,(%eax)
  802731:	eb 0a                	jmp    80273d <alloc_block_BF+0x9a>
  802733:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802736:	8b 00                	mov    (%eax),%eax
  802738:	a3 38 41 80 00       	mov    %eax,0x804138
  80273d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802740:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802746:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802749:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802750:	a1 44 41 80 00       	mov    0x804144,%eax
  802755:	48                   	dec    %eax
  802756:	a3 44 41 80 00       	mov    %eax,0x804144
	   return temp;
  80275b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80275e:	e9 41 01 00 00       	jmp    8028a4 <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  802763:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802766:	8b 40 0c             	mov    0xc(%eax),%eax
  802769:	3b 45 08             	cmp    0x8(%ebp),%eax
  80276c:	76 21                	jbe    80278f <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  80276e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802771:	8b 40 0c             	mov    0xc(%eax),%eax
  802774:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802777:	73 16                	jae    80278f <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  802779:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80277c:	8b 40 0c             	mov    0xc(%eax),%eax
  80277f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  802782:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802785:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  802788:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  80278f:	a1 40 41 80 00       	mov    0x804140,%eax
  802794:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802797:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80279b:	74 07                	je     8027a4 <alloc_block_BF+0x101>
  80279d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027a0:	8b 00                	mov    (%eax),%eax
  8027a2:	eb 05                	jmp    8027a9 <alloc_block_BF+0x106>
  8027a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a9:	a3 40 41 80 00       	mov    %eax,0x804140
  8027ae:	a1 40 41 80 00       	mov    0x804140,%eax
  8027b3:	85 c0                	test   %eax,%eax
  8027b5:	0f 85 09 ff ff ff    	jne    8026c4 <alloc_block_BF+0x21>
  8027bb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8027bf:	0f 85 ff fe ff ff    	jne    8026c4 <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  8027c5:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  8027c9:	0f 85 d0 00 00 00    	jne    80289f <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  8027cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d5:	2b 45 08             	sub    0x8(%ebp),%eax
  8027d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  8027db:	a1 48 41 80 00       	mov    0x804148,%eax
  8027e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  8027e3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8027e7:	75 17                	jne    802800 <alloc_block_BF+0x15d>
  8027e9:	83 ec 04             	sub    $0x4,%esp
  8027ec:	68 a8 3c 80 00       	push   $0x803ca8
  8027f1:	68 d1 00 00 00       	push   $0xd1
  8027f6:	68 37 3c 80 00       	push   $0x803c37
  8027fb:	e8 e9 da ff ff       	call   8002e9 <_panic>
  802800:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802803:	8b 00                	mov    (%eax),%eax
  802805:	85 c0                	test   %eax,%eax
  802807:	74 10                	je     802819 <alloc_block_BF+0x176>
  802809:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80280c:	8b 00                	mov    (%eax),%eax
  80280e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802811:	8b 52 04             	mov    0x4(%edx),%edx
  802814:	89 50 04             	mov    %edx,0x4(%eax)
  802817:	eb 0b                	jmp    802824 <alloc_block_BF+0x181>
  802819:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80281c:	8b 40 04             	mov    0x4(%eax),%eax
  80281f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802824:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802827:	8b 40 04             	mov    0x4(%eax),%eax
  80282a:	85 c0                	test   %eax,%eax
  80282c:	74 0f                	je     80283d <alloc_block_BF+0x19a>
  80282e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802831:	8b 40 04             	mov    0x4(%eax),%eax
  802834:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802837:	8b 12                	mov    (%edx),%edx
  802839:	89 10                	mov    %edx,(%eax)
  80283b:	eb 0a                	jmp    802847 <alloc_block_BF+0x1a4>
  80283d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802840:	8b 00                	mov    (%eax),%eax
  802842:	a3 48 41 80 00       	mov    %eax,0x804148
  802847:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80284a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802850:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802853:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80285a:	a1 54 41 80 00       	mov    0x804154,%eax
  80285f:	48                   	dec    %eax
  802860:	a3 54 41 80 00       	mov    %eax,0x804154
	  // setting the size & sva
	  new_block->size = size;
  802865:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802868:	8b 55 08             	mov    0x8(%ebp),%edx
  80286b:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  80286e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802871:	8b 50 08             	mov    0x8(%eax),%edx
  802874:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802877:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  80287a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80287d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802880:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  802883:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802886:	8b 50 08             	mov    0x8(%eax),%edx
  802889:	8b 45 08             	mov    0x8(%ebp),%eax
  80288c:	01 c2                	add    %eax,%edx
  80288e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802891:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  802894:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802897:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  80289a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80289d:	eb 05                	jmp    8028a4 <alloc_block_BF+0x201>
	 }
	 return NULL;
  80289f:	b8 00 00 00 00       	mov    $0x0,%eax


}
  8028a4:	c9                   	leave  
  8028a5:	c3                   	ret    

008028a6 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8028a6:	55                   	push   %ebp
  8028a7:	89 e5                	mov    %esp,%ebp
  8028a9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  8028ac:	83 ec 04             	sub    $0x4,%esp
  8028af:	68 c8 3c 80 00       	push   $0x803cc8
  8028b4:	68 e8 00 00 00       	push   $0xe8
  8028b9:	68 37 3c 80 00       	push   $0x803c37
  8028be:	e8 26 da ff ff       	call   8002e9 <_panic>

008028c3 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8028c3:	55                   	push   %ebp
  8028c4:	89 e5                	mov    %esp,%ebp
  8028c6:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  8028c9:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8028ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  8028d1:	a1 38 41 80 00       	mov    0x804138,%eax
  8028d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  8028d9:	a1 44 41 80 00       	mov    0x804144,%eax
  8028de:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  8028e1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028e5:	75 68                	jne    80294f <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8028e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028eb:	75 17                	jne    802904 <insert_sorted_with_merge_freeList+0x41>
  8028ed:	83 ec 04             	sub    $0x4,%esp
  8028f0:	68 14 3c 80 00       	push   $0x803c14
  8028f5:	68 36 01 00 00       	push   $0x136
  8028fa:	68 37 3c 80 00       	push   $0x803c37
  8028ff:	e8 e5 d9 ff ff       	call   8002e9 <_panic>
  802904:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80290a:	8b 45 08             	mov    0x8(%ebp),%eax
  80290d:	89 10                	mov    %edx,(%eax)
  80290f:	8b 45 08             	mov    0x8(%ebp),%eax
  802912:	8b 00                	mov    (%eax),%eax
  802914:	85 c0                	test   %eax,%eax
  802916:	74 0d                	je     802925 <insert_sorted_with_merge_freeList+0x62>
  802918:	a1 38 41 80 00       	mov    0x804138,%eax
  80291d:	8b 55 08             	mov    0x8(%ebp),%edx
  802920:	89 50 04             	mov    %edx,0x4(%eax)
  802923:	eb 08                	jmp    80292d <insert_sorted_with_merge_freeList+0x6a>
  802925:	8b 45 08             	mov    0x8(%ebp),%eax
  802928:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80292d:	8b 45 08             	mov    0x8(%ebp),%eax
  802930:	a3 38 41 80 00       	mov    %eax,0x804138
  802935:	8b 45 08             	mov    0x8(%ebp),%eax
  802938:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80293f:	a1 44 41 80 00       	mov    0x804144,%eax
  802944:	40                   	inc    %eax
  802945:	a3 44 41 80 00       	mov    %eax,0x804144





}
  80294a:	e9 ba 06 00 00       	jmp    803009 <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  80294f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802952:	8b 50 08             	mov    0x8(%eax),%edx
  802955:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802958:	8b 40 0c             	mov    0xc(%eax),%eax
  80295b:	01 c2                	add    %eax,%edx
  80295d:	8b 45 08             	mov    0x8(%ebp),%eax
  802960:	8b 40 08             	mov    0x8(%eax),%eax
  802963:	39 c2                	cmp    %eax,%edx
  802965:	73 68                	jae    8029cf <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802967:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80296b:	75 17                	jne    802984 <insert_sorted_with_merge_freeList+0xc1>
  80296d:	83 ec 04             	sub    $0x4,%esp
  802970:	68 50 3c 80 00       	push   $0x803c50
  802975:	68 3a 01 00 00       	push   $0x13a
  80297a:	68 37 3c 80 00       	push   $0x803c37
  80297f:	e8 65 d9 ff ff       	call   8002e9 <_panic>
  802984:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  80298a:	8b 45 08             	mov    0x8(%ebp),%eax
  80298d:	89 50 04             	mov    %edx,0x4(%eax)
  802990:	8b 45 08             	mov    0x8(%ebp),%eax
  802993:	8b 40 04             	mov    0x4(%eax),%eax
  802996:	85 c0                	test   %eax,%eax
  802998:	74 0c                	je     8029a6 <insert_sorted_with_merge_freeList+0xe3>
  80299a:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80299f:	8b 55 08             	mov    0x8(%ebp),%edx
  8029a2:	89 10                	mov    %edx,(%eax)
  8029a4:	eb 08                	jmp    8029ae <insert_sorted_with_merge_freeList+0xeb>
  8029a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a9:	a3 38 41 80 00       	mov    %eax,0x804138
  8029ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b1:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029bf:	a1 44 41 80 00       	mov    0x804144,%eax
  8029c4:	40                   	inc    %eax
  8029c5:	a3 44 41 80 00       	mov    %eax,0x804144





}
  8029ca:	e9 3a 06 00 00       	jmp    803009 <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  8029cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d2:	8b 50 08             	mov    0x8(%eax),%edx
  8029d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8029db:	01 c2                	add    %eax,%edx
  8029dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e0:	8b 40 08             	mov    0x8(%eax),%eax
  8029e3:	39 c2                	cmp    %eax,%edx
  8029e5:	0f 85 90 00 00 00    	jne    802a7b <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  8029eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ee:	8b 50 0c             	mov    0xc(%eax),%edx
  8029f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f7:	01 c2                	add    %eax,%edx
  8029f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029fc:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  8029ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802a02:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  802a09:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802a13:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a17:	75 17                	jne    802a30 <insert_sorted_with_merge_freeList+0x16d>
  802a19:	83 ec 04             	sub    $0x4,%esp
  802a1c:	68 14 3c 80 00       	push   $0x803c14
  802a21:	68 41 01 00 00       	push   $0x141
  802a26:	68 37 3c 80 00       	push   $0x803c37
  802a2b:	e8 b9 d8 ff ff       	call   8002e9 <_panic>
  802a30:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a36:	8b 45 08             	mov    0x8(%ebp),%eax
  802a39:	89 10                	mov    %edx,(%eax)
  802a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3e:	8b 00                	mov    (%eax),%eax
  802a40:	85 c0                	test   %eax,%eax
  802a42:	74 0d                	je     802a51 <insert_sorted_with_merge_freeList+0x18e>
  802a44:	a1 48 41 80 00       	mov    0x804148,%eax
  802a49:	8b 55 08             	mov    0x8(%ebp),%edx
  802a4c:	89 50 04             	mov    %edx,0x4(%eax)
  802a4f:	eb 08                	jmp    802a59 <insert_sorted_with_merge_freeList+0x196>
  802a51:	8b 45 08             	mov    0x8(%ebp),%eax
  802a54:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a59:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5c:	a3 48 41 80 00       	mov    %eax,0x804148
  802a61:	8b 45 08             	mov    0x8(%ebp),%eax
  802a64:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a6b:	a1 54 41 80 00       	mov    0x804154,%eax
  802a70:	40                   	inc    %eax
  802a71:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802a76:	e9 8e 05 00 00       	jmp    803009 <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  802a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7e:	8b 50 08             	mov    0x8(%eax),%edx
  802a81:	8b 45 08             	mov    0x8(%ebp),%eax
  802a84:	8b 40 0c             	mov    0xc(%eax),%eax
  802a87:	01 c2                	add    %eax,%edx
  802a89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a8c:	8b 40 08             	mov    0x8(%eax),%eax
  802a8f:	39 c2                	cmp    %eax,%edx
  802a91:	73 68                	jae    802afb <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802a93:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a97:	75 17                	jne    802ab0 <insert_sorted_with_merge_freeList+0x1ed>
  802a99:	83 ec 04             	sub    $0x4,%esp
  802a9c:	68 14 3c 80 00       	push   $0x803c14
  802aa1:	68 45 01 00 00       	push   $0x145
  802aa6:	68 37 3c 80 00       	push   $0x803c37
  802aab:	e8 39 d8 ff ff       	call   8002e9 <_panic>
  802ab0:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab9:	89 10                	mov    %edx,(%eax)
  802abb:	8b 45 08             	mov    0x8(%ebp),%eax
  802abe:	8b 00                	mov    (%eax),%eax
  802ac0:	85 c0                	test   %eax,%eax
  802ac2:	74 0d                	je     802ad1 <insert_sorted_with_merge_freeList+0x20e>
  802ac4:	a1 38 41 80 00       	mov    0x804138,%eax
  802ac9:	8b 55 08             	mov    0x8(%ebp),%edx
  802acc:	89 50 04             	mov    %edx,0x4(%eax)
  802acf:	eb 08                	jmp    802ad9 <insert_sorted_with_merge_freeList+0x216>
  802ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  802adc:	a3 38 41 80 00       	mov    %eax,0x804138
  802ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aeb:	a1 44 41 80 00       	mov    0x804144,%eax
  802af0:	40                   	inc    %eax
  802af1:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802af6:	e9 0e 05 00 00       	jmp    803009 <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  802afb:	8b 45 08             	mov    0x8(%ebp),%eax
  802afe:	8b 50 08             	mov    0x8(%eax),%edx
  802b01:	8b 45 08             	mov    0x8(%ebp),%eax
  802b04:	8b 40 0c             	mov    0xc(%eax),%eax
  802b07:	01 c2                	add    %eax,%edx
  802b09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0c:	8b 40 08             	mov    0x8(%eax),%eax
  802b0f:	39 c2                	cmp    %eax,%edx
  802b11:	0f 85 9c 00 00 00    	jne    802bb3 <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  802b17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b1a:	8b 50 0c             	mov    0xc(%eax),%edx
  802b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b20:	8b 40 0c             	mov    0xc(%eax),%eax
  802b23:	01 c2                	add    %eax,%edx
  802b25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b28:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  802b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2e:	8b 50 08             	mov    0x8(%eax),%edx
  802b31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b34:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  802b37:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  802b41:	8b 45 08             	mov    0x8(%ebp),%eax
  802b44:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802b4b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b4f:	75 17                	jne    802b68 <insert_sorted_with_merge_freeList+0x2a5>
  802b51:	83 ec 04             	sub    $0x4,%esp
  802b54:	68 14 3c 80 00       	push   $0x803c14
  802b59:	68 4d 01 00 00       	push   $0x14d
  802b5e:	68 37 3c 80 00       	push   $0x803c37
  802b63:	e8 81 d7 ff ff       	call   8002e9 <_panic>
  802b68:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b71:	89 10                	mov    %edx,(%eax)
  802b73:	8b 45 08             	mov    0x8(%ebp),%eax
  802b76:	8b 00                	mov    (%eax),%eax
  802b78:	85 c0                	test   %eax,%eax
  802b7a:	74 0d                	je     802b89 <insert_sorted_with_merge_freeList+0x2c6>
  802b7c:	a1 48 41 80 00       	mov    0x804148,%eax
  802b81:	8b 55 08             	mov    0x8(%ebp),%edx
  802b84:	89 50 04             	mov    %edx,0x4(%eax)
  802b87:	eb 08                	jmp    802b91 <insert_sorted_with_merge_freeList+0x2ce>
  802b89:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b91:	8b 45 08             	mov    0x8(%ebp),%eax
  802b94:	a3 48 41 80 00       	mov    %eax,0x804148
  802b99:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ba3:	a1 54 41 80 00       	mov    0x804154,%eax
  802ba8:	40                   	inc    %eax
  802ba9:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802bae:	e9 56 04 00 00       	jmp    803009 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802bb3:	a1 38 41 80 00       	mov    0x804138,%eax
  802bb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bbb:	e9 19 04 00 00       	jmp    802fd9 <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  802bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc3:	8b 00                	mov    (%eax),%eax
  802bc5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802bc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcb:	8b 50 08             	mov    0x8(%eax),%edx
  802bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd1:	8b 40 0c             	mov    0xc(%eax),%eax
  802bd4:	01 c2                	add    %eax,%edx
  802bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd9:	8b 40 08             	mov    0x8(%eax),%eax
  802bdc:	39 c2                	cmp    %eax,%edx
  802bde:	0f 85 ad 01 00 00    	jne    802d91 <insert_sorted_with_merge_freeList+0x4ce>
  802be4:	8b 45 08             	mov    0x8(%ebp),%eax
  802be7:	8b 50 08             	mov    0x8(%eax),%edx
  802bea:	8b 45 08             	mov    0x8(%ebp),%eax
  802bed:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf0:	01 c2                	add    %eax,%edx
  802bf2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bf5:	8b 40 08             	mov    0x8(%eax),%eax
  802bf8:	39 c2                	cmp    %eax,%edx
  802bfa:	0f 85 91 01 00 00    	jne    802d91 <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  802c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c03:	8b 50 0c             	mov    0xc(%eax),%edx
  802c06:	8b 45 08             	mov    0x8(%ebp),%eax
  802c09:	8b 48 0c             	mov    0xc(%eax),%ecx
  802c0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c0f:	8b 40 0c             	mov    0xc(%eax),%eax
  802c12:	01 c8                	add    %ecx,%eax
  802c14:	01 c2                	add    %eax,%edx
  802c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c19:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  802c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802c26:	8b 45 08             	mov    0x8(%ebp),%eax
  802c29:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  802c30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c33:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  802c3a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c3d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  802c44:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802c48:	75 17                	jne    802c61 <insert_sorted_with_merge_freeList+0x39e>
  802c4a:	83 ec 04             	sub    $0x4,%esp
  802c4d:	68 a8 3c 80 00       	push   $0x803ca8
  802c52:	68 5b 01 00 00       	push   $0x15b
  802c57:	68 37 3c 80 00       	push   $0x803c37
  802c5c:	e8 88 d6 ff ff       	call   8002e9 <_panic>
  802c61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c64:	8b 00                	mov    (%eax),%eax
  802c66:	85 c0                	test   %eax,%eax
  802c68:	74 10                	je     802c7a <insert_sorted_with_merge_freeList+0x3b7>
  802c6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c6d:	8b 00                	mov    (%eax),%eax
  802c6f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c72:	8b 52 04             	mov    0x4(%edx),%edx
  802c75:	89 50 04             	mov    %edx,0x4(%eax)
  802c78:	eb 0b                	jmp    802c85 <insert_sorted_with_merge_freeList+0x3c2>
  802c7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c7d:	8b 40 04             	mov    0x4(%eax),%eax
  802c80:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c88:	8b 40 04             	mov    0x4(%eax),%eax
  802c8b:	85 c0                	test   %eax,%eax
  802c8d:	74 0f                	je     802c9e <insert_sorted_with_merge_freeList+0x3db>
  802c8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c92:	8b 40 04             	mov    0x4(%eax),%eax
  802c95:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c98:	8b 12                	mov    (%edx),%edx
  802c9a:	89 10                	mov    %edx,(%eax)
  802c9c:	eb 0a                	jmp    802ca8 <insert_sorted_with_merge_freeList+0x3e5>
  802c9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ca1:	8b 00                	mov    (%eax),%eax
  802ca3:	a3 38 41 80 00       	mov    %eax,0x804138
  802ca8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cb4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cbb:	a1 44 41 80 00       	mov    0x804144,%eax
  802cc0:	48                   	dec    %eax
  802cc1:	a3 44 41 80 00       	mov    %eax,0x804144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802cc6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cca:	75 17                	jne    802ce3 <insert_sorted_with_merge_freeList+0x420>
  802ccc:	83 ec 04             	sub    $0x4,%esp
  802ccf:	68 14 3c 80 00       	push   $0x803c14
  802cd4:	68 5c 01 00 00       	push   $0x15c
  802cd9:	68 37 3c 80 00       	push   $0x803c37
  802cde:	e8 06 d6 ff ff       	call   8002e9 <_panic>
  802ce3:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cec:	89 10                	mov    %edx,(%eax)
  802cee:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf1:	8b 00                	mov    (%eax),%eax
  802cf3:	85 c0                	test   %eax,%eax
  802cf5:	74 0d                	je     802d04 <insert_sorted_with_merge_freeList+0x441>
  802cf7:	a1 48 41 80 00       	mov    0x804148,%eax
  802cfc:	8b 55 08             	mov    0x8(%ebp),%edx
  802cff:	89 50 04             	mov    %edx,0x4(%eax)
  802d02:	eb 08                	jmp    802d0c <insert_sorted_with_merge_freeList+0x449>
  802d04:	8b 45 08             	mov    0x8(%ebp),%eax
  802d07:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0f:	a3 48 41 80 00       	mov    %eax,0x804148
  802d14:	8b 45 08             	mov    0x8(%ebp),%eax
  802d17:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d1e:	a1 54 41 80 00       	mov    0x804154,%eax
  802d23:	40                   	inc    %eax
  802d24:	a3 54 41 80 00       	mov    %eax,0x804154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  802d29:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802d2d:	75 17                	jne    802d46 <insert_sorted_with_merge_freeList+0x483>
  802d2f:	83 ec 04             	sub    $0x4,%esp
  802d32:	68 14 3c 80 00       	push   $0x803c14
  802d37:	68 5d 01 00 00       	push   $0x15d
  802d3c:	68 37 3c 80 00       	push   $0x803c37
  802d41:	e8 a3 d5 ff ff       	call   8002e9 <_panic>
  802d46:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d4f:	89 10                	mov    %edx,(%eax)
  802d51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d54:	8b 00                	mov    (%eax),%eax
  802d56:	85 c0                	test   %eax,%eax
  802d58:	74 0d                	je     802d67 <insert_sorted_with_merge_freeList+0x4a4>
  802d5a:	a1 48 41 80 00       	mov    0x804148,%eax
  802d5f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d62:	89 50 04             	mov    %edx,0x4(%eax)
  802d65:	eb 08                	jmp    802d6f <insert_sorted_with_merge_freeList+0x4ac>
  802d67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d6a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d72:	a3 48 41 80 00       	mov    %eax,0x804148
  802d77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d7a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d81:	a1 54 41 80 00       	mov    0x804154,%eax
  802d86:	40                   	inc    %eax
  802d87:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802d8c:	e9 78 02 00 00       	jmp    803009 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d94:	8b 50 08             	mov    0x8(%eax),%edx
  802d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d9d:	01 c2                	add    %eax,%edx
  802d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802da2:	8b 40 08             	mov    0x8(%eax),%eax
  802da5:	39 c2                	cmp    %eax,%edx
  802da7:	0f 83 b8 00 00 00    	jae    802e65 <insert_sorted_with_merge_freeList+0x5a2>
  802dad:	8b 45 08             	mov    0x8(%ebp),%eax
  802db0:	8b 50 08             	mov    0x8(%eax),%edx
  802db3:	8b 45 08             	mov    0x8(%ebp),%eax
  802db6:	8b 40 0c             	mov    0xc(%eax),%eax
  802db9:	01 c2                	add    %eax,%edx
  802dbb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dbe:	8b 40 08             	mov    0x8(%eax),%eax
  802dc1:	39 c2                	cmp    %eax,%edx
  802dc3:	0f 85 9c 00 00 00    	jne    802e65 <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  802dc9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dcc:	8b 50 0c             	mov    0xc(%eax),%edx
  802dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd2:	8b 40 0c             	mov    0xc(%eax),%eax
  802dd5:	01 c2                	add    %eax,%edx
  802dd7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dda:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  802ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  802de0:	8b 50 08             	mov    0x8(%eax),%edx
  802de3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802de6:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  802de9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dec:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802df3:	8b 45 08             	mov    0x8(%ebp),%eax
  802df6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802dfd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e01:	75 17                	jne    802e1a <insert_sorted_with_merge_freeList+0x557>
  802e03:	83 ec 04             	sub    $0x4,%esp
  802e06:	68 14 3c 80 00       	push   $0x803c14
  802e0b:	68 67 01 00 00       	push   $0x167
  802e10:	68 37 3c 80 00       	push   $0x803c37
  802e15:	e8 cf d4 ff ff       	call   8002e9 <_panic>
  802e1a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e20:	8b 45 08             	mov    0x8(%ebp),%eax
  802e23:	89 10                	mov    %edx,(%eax)
  802e25:	8b 45 08             	mov    0x8(%ebp),%eax
  802e28:	8b 00                	mov    (%eax),%eax
  802e2a:	85 c0                	test   %eax,%eax
  802e2c:	74 0d                	je     802e3b <insert_sorted_with_merge_freeList+0x578>
  802e2e:	a1 48 41 80 00       	mov    0x804148,%eax
  802e33:	8b 55 08             	mov    0x8(%ebp),%edx
  802e36:	89 50 04             	mov    %edx,0x4(%eax)
  802e39:	eb 08                	jmp    802e43 <insert_sorted_with_merge_freeList+0x580>
  802e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e43:	8b 45 08             	mov    0x8(%ebp),%eax
  802e46:	a3 48 41 80 00       	mov    %eax,0x804148
  802e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e55:	a1 54 41 80 00       	mov    0x804154,%eax
  802e5a:	40                   	inc    %eax
  802e5b:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802e60:	e9 a4 01 00 00       	jmp    803009 <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e68:	8b 50 08             	mov    0x8(%eax),%edx
  802e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6e:	8b 40 0c             	mov    0xc(%eax),%eax
  802e71:	01 c2                	add    %eax,%edx
  802e73:	8b 45 08             	mov    0x8(%ebp),%eax
  802e76:	8b 40 08             	mov    0x8(%eax),%eax
  802e79:	39 c2                	cmp    %eax,%edx
  802e7b:	0f 85 ac 00 00 00    	jne    802f2d <insert_sorted_with_merge_freeList+0x66a>
  802e81:	8b 45 08             	mov    0x8(%ebp),%eax
  802e84:	8b 50 08             	mov    0x8(%eax),%edx
  802e87:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e8d:	01 c2                	add    %eax,%edx
  802e8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e92:	8b 40 08             	mov    0x8(%eax),%eax
  802e95:	39 c2                	cmp    %eax,%edx
  802e97:	0f 83 90 00 00 00    	jae    802f2d <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  802e9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea0:	8b 50 0c             	mov    0xc(%eax),%edx
  802ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea9:	01 c2                	add    %eax,%edx
  802eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eae:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  802eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  802ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebe:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802ec5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ec9:	75 17                	jne    802ee2 <insert_sorted_with_merge_freeList+0x61f>
  802ecb:	83 ec 04             	sub    $0x4,%esp
  802ece:	68 14 3c 80 00       	push   $0x803c14
  802ed3:	68 70 01 00 00       	push   $0x170
  802ed8:	68 37 3c 80 00       	push   $0x803c37
  802edd:	e8 07 d4 ff ff       	call   8002e9 <_panic>
  802ee2:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  802eeb:	89 10                	mov    %edx,(%eax)
  802eed:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef0:	8b 00                	mov    (%eax),%eax
  802ef2:	85 c0                	test   %eax,%eax
  802ef4:	74 0d                	je     802f03 <insert_sorted_with_merge_freeList+0x640>
  802ef6:	a1 48 41 80 00       	mov    0x804148,%eax
  802efb:	8b 55 08             	mov    0x8(%ebp),%edx
  802efe:	89 50 04             	mov    %edx,0x4(%eax)
  802f01:	eb 08                	jmp    802f0b <insert_sorted_with_merge_freeList+0x648>
  802f03:	8b 45 08             	mov    0x8(%ebp),%eax
  802f06:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0e:	a3 48 41 80 00       	mov    %eax,0x804148
  802f13:	8b 45 08             	mov    0x8(%ebp),%eax
  802f16:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f1d:	a1 54 41 80 00       	mov    0x804154,%eax
  802f22:	40                   	inc    %eax
  802f23:	a3 54 41 80 00       	mov    %eax,0x804154
	      break;
  802f28:	e9 dc 00 00 00       	jmp    803009 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802f2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f30:	8b 50 08             	mov    0x8(%eax),%edx
  802f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f36:	8b 40 0c             	mov    0xc(%eax),%eax
  802f39:	01 c2                	add    %eax,%edx
  802f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3e:	8b 40 08             	mov    0x8(%eax),%eax
  802f41:	39 c2                	cmp    %eax,%edx
  802f43:	0f 83 88 00 00 00    	jae    802fd1 <insert_sorted_with_merge_freeList+0x70e>
  802f49:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4c:	8b 50 08             	mov    0x8(%eax),%edx
  802f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f52:	8b 40 0c             	mov    0xc(%eax),%eax
  802f55:	01 c2                	add    %eax,%edx
  802f57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f5a:	8b 40 08             	mov    0x8(%eax),%eax
  802f5d:	39 c2                	cmp    %eax,%edx
  802f5f:	73 70                	jae    802fd1 <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  802f61:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f65:	74 06                	je     802f6d <insert_sorted_with_merge_freeList+0x6aa>
  802f67:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f6b:	75 17                	jne    802f84 <insert_sorted_with_merge_freeList+0x6c1>
  802f6d:	83 ec 04             	sub    $0x4,%esp
  802f70:	68 74 3c 80 00       	push   $0x803c74
  802f75:	68 75 01 00 00       	push   $0x175
  802f7a:	68 37 3c 80 00       	push   $0x803c37
  802f7f:	e8 65 d3 ff ff       	call   8002e9 <_panic>
  802f84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f87:	8b 10                	mov    (%eax),%edx
  802f89:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8c:	89 10                	mov    %edx,(%eax)
  802f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f91:	8b 00                	mov    (%eax),%eax
  802f93:	85 c0                	test   %eax,%eax
  802f95:	74 0b                	je     802fa2 <insert_sorted_with_merge_freeList+0x6df>
  802f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9a:	8b 00                	mov    (%eax),%eax
  802f9c:	8b 55 08             	mov    0x8(%ebp),%edx
  802f9f:	89 50 04             	mov    %edx,0x4(%eax)
  802fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa5:	8b 55 08             	mov    0x8(%ebp),%edx
  802fa8:	89 10                	mov    %edx,(%eax)
  802faa:	8b 45 08             	mov    0x8(%ebp),%eax
  802fad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fb0:	89 50 04             	mov    %edx,0x4(%eax)
  802fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb6:	8b 00                	mov    (%eax),%eax
  802fb8:	85 c0                	test   %eax,%eax
  802fba:	75 08                	jne    802fc4 <insert_sorted_with_merge_freeList+0x701>
  802fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbf:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802fc4:	a1 44 41 80 00       	mov    0x804144,%eax
  802fc9:	40                   	inc    %eax
  802fca:	a3 44 41 80 00       	mov    %eax,0x804144
	      break;
  802fcf:	eb 38                	jmp    803009 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802fd1:	a1 40 41 80 00       	mov    0x804140,%eax
  802fd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fd9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fdd:	74 07                	je     802fe6 <insert_sorted_with_merge_freeList+0x723>
  802fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe2:	8b 00                	mov    (%eax),%eax
  802fe4:	eb 05                	jmp    802feb <insert_sorted_with_merge_freeList+0x728>
  802fe6:	b8 00 00 00 00       	mov    $0x0,%eax
  802feb:	a3 40 41 80 00       	mov    %eax,0x804140
  802ff0:	a1 40 41 80 00       	mov    0x804140,%eax
  802ff5:	85 c0                	test   %eax,%eax
  802ff7:	0f 85 c3 fb ff ff    	jne    802bc0 <insert_sorted_with_merge_freeList+0x2fd>
  802ffd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803001:	0f 85 b9 fb ff ff    	jne    802bc0 <insert_sorted_with_merge_freeList+0x2fd>





}
  803007:	eb 00                	jmp    803009 <insert_sorted_with_merge_freeList+0x746>
  803009:	90                   	nop
  80300a:	c9                   	leave  
  80300b:	c3                   	ret    

0080300c <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80300c:	55                   	push   %ebp
  80300d:	89 e5                	mov    %esp,%ebp
  80300f:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803012:	8b 55 08             	mov    0x8(%ebp),%edx
  803015:	89 d0                	mov    %edx,%eax
  803017:	c1 e0 02             	shl    $0x2,%eax
  80301a:	01 d0                	add    %edx,%eax
  80301c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803023:	01 d0                	add    %edx,%eax
  803025:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80302c:	01 d0                	add    %edx,%eax
  80302e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803035:	01 d0                	add    %edx,%eax
  803037:	c1 e0 04             	shl    $0x4,%eax
  80303a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80303d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803044:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803047:	83 ec 0c             	sub    $0xc,%esp
  80304a:	50                   	push   %eax
  80304b:	e8 31 ec ff ff       	call   801c81 <sys_get_virtual_time>
  803050:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803053:	eb 41                	jmp    803096 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803055:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803058:	83 ec 0c             	sub    $0xc,%esp
  80305b:	50                   	push   %eax
  80305c:	e8 20 ec ff ff       	call   801c81 <sys_get_virtual_time>
  803061:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803064:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803067:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80306a:	29 c2                	sub    %eax,%edx
  80306c:	89 d0                	mov    %edx,%eax
  80306e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803071:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803074:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803077:	89 d1                	mov    %edx,%ecx
  803079:	29 c1                	sub    %eax,%ecx
  80307b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80307e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803081:	39 c2                	cmp    %eax,%edx
  803083:	0f 97 c0             	seta   %al
  803086:	0f b6 c0             	movzbl %al,%eax
  803089:	29 c1                	sub    %eax,%ecx
  80308b:	89 c8                	mov    %ecx,%eax
  80308d:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803090:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803093:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803096:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803099:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80309c:	72 b7                	jb     803055 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80309e:	90                   	nop
  80309f:	c9                   	leave  
  8030a0:	c3                   	ret    

008030a1 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8030a1:	55                   	push   %ebp
  8030a2:	89 e5                	mov    %esp,%ebp
  8030a4:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8030a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8030ae:	eb 03                	jmp    8030b3 <busy_wait+0x12>
  8030b0:	ff 45 fc             	incl   -0x4(%ebp)
  8030b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8030b6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030b9:	72 f5                	jb     8030b0 <busy_wait+0xf>
	return i;
  8030bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8030be:	c9                   	leave  
  8030bf:	c3                   	ret    

008030c0 <__udivdi3>:
  8030c0:	55                   	push   %ebp
  8030c1:	57                   	push   %edi
  8030c2:	56                   	push   %esi
  8030c3:	53                   	push   %ebx
  8030c4:	83 ec 1c             	sub    $0x1c,%esp
  8030c7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8030cb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8030cf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8030d3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8030d7:	89 ca                	mov    %ecx,%edx
  8030d9:	89 f8                	mov    %edi,%eax
  8030db:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8030df:	85 f6                	test   %esi,%esi
  8030e1:	75 2d                	jne    803110 <__udivdi3+0x50>
  8030e3:	39 cf                	cmp    %ecx,%edi
  8030e5:	77 65                	ja     80314c <__udivdi3+0x8c>
  8030e7:	89 fd                	mov    %edi,%ebp
  8030e9:	85 ff                	test   %edi,%edi
  8030eb:	75 0b                	jne    8030f8 <__udivdi3+0x38>
  8030ed:	b8 01 00 00 00       	mov    $0x1,%eax
  8030f2:	31 d2                	xor    %edx,%edx
  8030f4:	f7 f7                	div    %edi
  8030f6:	89 c5                	mov    %eax,%ebp
  8030f8:	31 d2                	xor    %edx,%edx
  8030fa:	89 c8                	mov    %ecx,%eax
  8030fc:	f7 f5                	div    %ebp
  8030fe:	89 c1                	mov    %eax,%ecx
  803100:	89 d8                	mov    %ebx,%eax
  803102:	f7 f5                	div    %ebp
  803104:	89 cf                	mov    %ecx,%edi
  803106:	89 fa                	mov    %edi,%edx
  803108:	83 c4 1c             	add    $0x1c,%esp
  80310b:	5b                   	pop    %ebx
  80310c:	5e                   	pop    %esi
  80310d:	5f                   	pop    %edi
  80310e:	5d                   	pop    %ebp
  80310f:	c3                   	ret    
  803110:	39 ce                	cmp    %ecx,%esi
  803112:	77 28                	ja     80313c <__udivdi3+0x7c>
  803114:	0f bd fe             	bsr    %esi,%edi
  803117:	83 f7 1f             	xor    $0x1f,%edi
  80311a:	75 40                	jne    80315c <__udivdi3+0x9c>
  80311c:	39 ce                	cmp    %ecx,%esi
  80311e:	72 0a                	jb     80312a <__udivdi3+0x6a>
  803120:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803124:	0f 87 9e 00 00 00    	ja     8031c8 <__udivdi3+0x108>
  80312a:	b8 01 00 00 00       	mov    $0x1,%eax
  80312f:	89 fa                	mov    %edi,%edx
  803131:	83 c4 1c             	add    $0x1c,%esp
  803134:	5b                   	pop    %ebx
  803135:	5e                   	pop    %esi
  803136:	5f                   	pop    %edi
  803137:	5d                   	pop    %ebp
  803138:	c3                   	ret    
  803139:	8d 76 00             	lea    0x0(%esi),%esi
  80313c:	31 ff                	xor    %edi,%edi
  80313e:	31 c0                	xor    %eax,%eax
  803140:	89 fa                	mov    %edi,%edx
  803142:	83 c4 1c             	add    $0x1c,%esp
  803145:	5b                   	pop    %ebx
  803146:	5e                   	pop    %esi
  803147:	5f                   	pop    %edi
  803148:	5d                   	pop    %ebp
  803149:	c3                   	ret    
  80314a:	66 90                	xchg   %ax,%ax
  80314c:	89 d8                	mov    %ebx,%eax
  80314e:	f7 f7                	div    %edi
  803150:	31 ff                	xor    %edi,%edi
  803152:	89 fa                	mov    %edi,%edx
  803154:	83 c4 1c             	add    $0x1c,%esp
  803157:	5b                   	pop    %ebx
  803158:	5e                   	pop    %esi
  803159:	5f                   	pop    %edi
  80315a:	5d                   	pop    %ebp
  80315b:	c3                   	ret    
  80315c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803161:	89 eb                	mov    %ebp,%ebx
  803163:	29 fb                	sub    %edi,%ebx
  803165:	89 f9                	mov    %edi,%ecx
  803167:	d3 e6                	shl    %cl,%esi
  803169:	89 c5                	mov    %eax,%ebp
  80316b:	88 d9                	mov    %bl,%cl
  80316d:	d3 ed                	shr    %cl,%ebp
  80316f:	89 e9                	mov    %ebp,%ecx
  803171:	09 f1                	or     %esi,%ecx
  803173:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803177:	89 f9                	mov    %edi,%ecx
  803179:	d3 e0                	shl    %cl,%eax
  80317b:	89 c5                	mov    %eax,%ebp
  80317d:	89 d6                	mov    %edx,%esi
  80317f:	88 d9                	mov    %bl,%cl
  803181:	d3 ee                	shr    %cl,%esi
  803183:	89 f9                	mov    %edi,%ecx
  803185:	d3 e2                	shl    %cl,%edx
  803187:	8b 44 24 08          	mov    0x8(%esp),%eax
  80318b:	88 d9                	mov    %bl,%cl
  80318d:	d3 e8                	shr    %cl,%eax
  80318f:	09 c2                	or     %eax,%edx
  803191:	89 d0                	mov    %edx,%eax
  803193:	89 f2                	mov    %esi,%edx
  803195:	f7 74 24 0c          	divl   0xc(%esp)
  803199:	89 d6                	mov    %edx,%esi
  80319b:	89 c3                	mov    %eax,%ebx
  80319d:	f7 e5                	mul    %ebp
  80319f:	39 d6                	cmp    %edx,%esi
  8031a1:	72 19                	jb     8031bc <__udivdi3+0xfc>
  8031a3:	74 0b                	je     8031b0 <__udivdi3+0xf0>
  8031a5:	89 d8                	mov    %ebx,%eax
  8031a7:	31 ff                	xor    %edi,%edi
  8031a9:	e9 58 ff ff ff       	jmp    803106 <__udivdi3+0x46>
  8031ae:	66 90                	xchg   %ax,%ax
  8031b0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8031b4:	89 f9                	mov    %edi,%ecx
  8031b6:	d3 e2                	shl    %cl,%edx
  8031b8:	39 c2                	cmp    %eax,%edx
  8031ba:	73 e9                	jae    8031a5 <__udivdi3+0xe5>
  8031bc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8031bf:	31 ff                	xor    %edi,%edi
  8031c1:	e9 40 ff ff ff       	jmp    803106 <__udivdi3+0x46>
  8031c6:	66 90                	xchg   %ax,%ax
  8031c8:	31 c0                	xor    %eax,%eax
  8031ca:	e9 37 ff ff ff       	jmp    803106 <__udivdi3+0x46>
  8031cf:	90                   	nop

008031d0 <__umoddi3>:
  8031d0:	55                   	push   %ebp
  8031d1:	57                   	push   %edi
  8031d2:	56                   	push   %esi
  8031d3:	53                   	push   %ebx
  8031d4:	83 ec 1c             	sub    $0x1c,%esp
  8031d7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8031db:	8b 74 24 34          	mov    0x34(%esp),%esi
  8031df:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8031e3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8031e7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8031eb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8031ef:	89 f3                	mov    %esi,%ebx
  8031f1:	89 fa                	mov    %edi,%edx
  8031f3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8031f7:	89 34 24             	mov    %esi,(%esp)
  8031fa:	85 c0                	test   %eax,%eax
  8031fc:	75 1a                	jne    803218 <__umoddi3+0x48>
  8031fe:	39 f7                	cmp    %esi,%edi
  803200:	0f 86 a2 00 00 00    	jbe    8032a8 <__umoddi3+0xd8>
  803206:	89 c8                	mov    %ecx,%eax
  803208:	89 f2                	mov    %esi,%edx
  80320a:	f7 f7                	div    %edi
  80320c:	89 d0                	mov    %edx,%eax
  80320e:	31 d2                	xor    %edx,%edx
  803210:	83 c4 1c             	add    $0x1c,%esp
  803213:	5b                   	pop    %ebx
  803214:	5e                   	pop    %esi
  803215:	5f                   	pop    %edi
  803216:	5d                   	pop    %ebp
  803217:	c3                   	ret    
  803218:	39 f0                	cmp    %esi,%eax
  80321a:	0f 87 ac 00 00 00    	ja     8032cc <__umoddi3+0xfc>
  803220:	0f bd e8             	bsr    %eax,%ebp
  803223:	83 f5 1f             	xor    $0x1f,%ebp
  803226:	0f 84 ac 00 00 00    	je     8032d8 <__umoddi3+0x108>
  80322c:	bf 20 00 00 00       	mov    $0x20,%edi
  803231:	29 ef                	sub    %ebp,%edi
  803233:	89 fe                	mov    %edi,%esi
  803235:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803239:	89 e9                	mov    %ebp,%ecx
  80323b:	d3 e0                	shl    %cl,%eax
  80323d:	89 d7                	mov    %edx,%edi
  80323f:	89 f1                	mov    %esi,%ecx
  803241:	d3 ef                	shr    %cl,%edi
  803243:	09 c7                	or     %eax,%edi
  803245:	89 e9                	mov    %ebp,%ecx
  803247:	d3 e2                	shl    %cl,%edx
  803249:	89 14 24             	mov    %edx,(%esp)
  80324c:	89 d8                	mov    %ebx,%eax
  80324e:	d3 e0                	shl    %cl,%eax
  803250:	89 c2                	mov    %eax,%edx
  803252:	8b 44 24 08          	mov    0x8(%esp),%eax
  803256:	d3 e0                	shl    %cl,%eax
  803258:	89 44 24 04          	mov    %eax,0x4(%esp)
  80325c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803260:	89 f1                	mov    %esi,%ecx
  803262:	d3 e8                	shr    %cl,%eax
  803264:	09 d0                	or     %edx,%eax
  803266:	d3 eb                	shr    %cl,%ebx
  803268:	89 da                	mov    %ebx,%edx
  80326a:	f7 f7                	div    %edi
  80326c:	89 d3                	mov    %edx,%ebx
  80326e:	f7 24 24             	mull   (%esp)
  803271:	89 c6                	mov    %eax,%esi
  803273:	89 d1                	mov    %edx,%ecx
  803275:	39 d3                	cmp    %edx,%ebx
  803277:	0f 82 87 00 00 00    	jb     803304 <__umoddi3+0x134>
  80327d:	0f 84 91 00 00 00    	je     803314 <__umoddi3+0x144>
  803283:	8b 54 24 04          	mov    0x4(%esp),%edx
  803287:	29 f2                	sub    %esi,%edx
  803289:	19 cb                	sbb    %ecx,%ebx
  80328b:	89 d8                	mov    %ebx,%eax
  80328d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803291:	d3 e0                	shl    %cl,%eax
  803293:	89 e9                	mov    %ebp,%ecx
  803295:	d3 ea                	shr    %cl,%edx
  803297:	09 d0                	or     %edx,%eax
  803299:	89 e9                	mov    %ebp,%ecx
  80329b:	d3 eb                	shr    %cl,%ebx
  80329d:	89 da                	mov    %ebx,%edx
  80329f:	83 c4 1c             	add    $0x1c,%esp
  8032a2:	5b                   	pop    %ebx
  8032a3:	5e                   	pop    %esi
  8032a4:	5f                   	pop    %edi
  8032a5:	5d                   	pop    %ebp
  8032a6:	c3                   	ret    
  8032a7:	90                   	nop
  8032a8:	89 fd                	mov    %edi,%ebp
  8032aa:	85 ff                	test   %edi,%edi
  8032ac:	75 0b                	jne    8032b9 <__umoddi3+0xe9>
  8032ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8032b3:	31 d2                	xor    %edx,%edx
  8032b5:	f7 f7                	div    %edi
  8032b7:	89 c5                	mov    %eax,%ebp
  8032b9:	89 f0                	mov    %esi,%eax
  8032bb:	31 d2                	xor    %edx,%edx
  8032bd:	f7 f5                	div    %ebp
  8032bf:	89 c8                	mov    %ecx,%eax
  8032c1:	f7 f5                	div    %ebp
  8032c3:	89 d0                	mov    %edx,%eax
  8032c5:	e9 44 ff ff ff       	jmp    80320e <__umoddi3+0x3e>
  8032ca:	66 90                	xchg   %ax,%ax
  8032cc:	89 c8                	mov    %ecx,%eax
  8032ce:	89 f2                	mov    %esi,%edx
  8032d0:	83 c4 1c             	add    $0x1c,%esp
  8032d3:	5b                   	pop    %ebx
  8032d4:	5e                   	pop    %esi
  8032d5:	5f                   	pop    %edi
  8032d6:	5d                   	pop    %ebp
  8032d7:	c3                   	ret    
  8032d8:	3b 04 24             	cmp    (%esp),%eax
  8032db:	72 06                	jb     8032e3 <__umoddi3+0x113>
  8032dd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8032e1:	77 0f                	ja     8032f2 <__umoddi3+0x122>
  8032e3:	89 f2                	mov    %esi,%edx
  8032e5:	29 f9                	sub    %edi,%ecx
  8032e7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8032eb:	89 14 24             	mov    %edx,(%esp)
  8032ee:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8032f2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8032f6:	8b 14 24             	mov    (%esp),%edx
  8032f9:	83 c4 1c             	add    $0x1c,%esp
  8032fc:	5b                   	pop    %ebx
  8032fd:	5e                   	pop    %esi
  8032fe:	5f                   	pop    %edi
  8032ff:	5d                   	pop    %ebp
  803300:	c3                   	ret    
  803301:	8d 76 00             	lea    0x0(%esi),%esi
  803304:	2b 04 24             	sub    (%esp),%eax
  803307:	19 fa                	sbb    %edi,%edx
  803309:	89 d1                	mov    %edx,%ecx
  80330b:	89 c6                	mov    %eax,%esi
  80330d:	e9 71 ff ff ff       	jmp    803283 <__umoddi3+0xb3>
  803312:	66 90                	xchg   %ax,%ax
  803314:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803318:	72 ea                	jb     803304 <__umoddi3+0x134>
  80331a:	89 d9                	mov    %ebx,%ecx
  80331c:	e9 62 ff ff ff       	jmp    803283 <__umoddi3+0xb3>
