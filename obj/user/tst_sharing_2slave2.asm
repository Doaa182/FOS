
obj/user/tst_sharing_2slave2:     file format elf32-i386


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
  800031:	e8 c3 01 00 00       	call   8001f9 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Slave program2: Get 2 shared variables, edit the writable one, and attempt to edit the readOnly one
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 24             	sub    $0x24,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003f:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800043:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004a:	eb 29                	jmp    800075 <_main+0x3d>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004c:	a1 20 40 80 00       	mov    0x804020,%eax
  800051:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800057:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005a:	89 d0                	mov    %edx,%eax
  80005c:	01 c0                	add    %eax,%eax
  80005e:	01 d0                	add    %edx,%eax
  800060:	c1 e0 03             	shl    $0x3,%eax
  800063:	01 c8                	add    %ecx,%eax
  800065:	8a 40 04             	mov    0x4(%eax),%al
  800068:	84 c0                	test   %al,%al
  80006a:	74 06                	je     800072 <_main+0x3a>
			{
				fullWS = 0;
  80006c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800070:	eb 12                	jmp    800084 <_main+0x4c>
_main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800072:	ff 45 f0             	incl   -0x10(%ebp)
  800075:	a1 20 40 80 00       	mov    0x804020,%eax
  80007a:	8b 50 74             	mov    0x74(%eax),%edx
  80007d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800080:	39 c2                	cmp    %eax,%edx
  800082:	77 c8                	ja     80004c <_main+0x14>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800084:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800088:	74 14                	je     80009e <_main+0x66>
  80008a:	83 ec 04             	sub    $0x4,%esp
  80008d:	68 c0 32 80 00       	push   $0x8032c0
  800092:	6a 13                	push   $0x13
  800094:	68 dc 32 80 00       	push   $0x8032dc
  800099:	e8 97 02 00 00       	call   800335 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 ba 14 00 00       	call   801562 <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int32 parentenvID = sys_getparentenvid();
  8000ab:	e8 ea 1b 00 00       	call   801c9a <sys_getparentenvid>
  8000b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 *x, *z;

	//GET: z then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	sys_disable_interrupt();
  8000b3:	e8 d6 19 00 00       	call   801a8e <sys_disable_interrupt>
	int freeFrames = sys_calculate_free_frames() ;
  8000b8:	e8 e4 18 00 00       	call   8019a1 <sys_calculate_free_frames>
  8000bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = sget(parentenvID,"z");
  8000c0:	83 ec 08             	sub    $0x8,%esp
  8000c3:	68 f7 32 80 00       	push   $0x8032f7
  8000c8:	ff 75 ec             	pushl  -0x14(%ebp)
  8000cb:	e8 ac 16 00 00       	call   80177c <sget>
  8000d0:	83 c4 10             	add    $0x10,%esp
  8000d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 0 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000d6:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000dd:	74 14                	je     8000f3 <_main+0xbb>
  8000df:	83 ec 04             	sub    $0x4,%esp
  8000e2:	68 fc 32 80 00       	push   $0x8032fc
  8000e7:	6a 21                	push   $0x21
  8000e9:	68 dc 32 80 00       	push   $0x8032dc
  8000ee:	e8 42 02 00 00       	call   800335 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8000f3:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000f6:	e8 a6 18 00 00       	call   8019a1 <sys_calculate_free_frames>
  8000fb:	29 c3                	sub    %eax,%ebx
  8000fd:	89 d8                	mov    %ebx,%eax
  8000ff:	83 f8 01             	cmp    $0x1,%eax
  800102:	74 14                	je     800118 <_main+0xe0>
  800104:	83 ec 04             	sub    $0x4,%esp
  800107:	68 5c 33 80 00       	push   $0x80335c
  80010c:	6a 22                	push   $0x22
  80010e:	68 dc 32 80 00       	push   $0x8032dc
  800113:	e8 1d 02 00 00       	call   800335 <_panic>
	sys_enable_interrupt();
  800118:	e8 8b 19 00 00       	call   801aa8 <sys_enable_interrupt>

	sys_disable_interrupt();
  80011d:	e8 6c 19 00 00       	call   801a8e <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  800122:	e8 7a 18 00 00       	call   8019a1 <sys_calculate_free_frames>
  800127:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = sget(parentenvID,"x");
  80012a:	83 ec 08             	sub    $0x8,%esp
  80012d:	68 ed 33 80 00       	push   $0x8033ed
  800132:	ff 75 ec             	pushl  -0x14(%ebp)
  800135:	e8 42 16 00 00       	call   80177c <sget>
  80013a:	83 c4 10             	add    $0x10,%esp
  80013d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (x != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800140:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  800147:	74 14                	je     80015d <_main+0x125>
  800149:	83 ec 04             	sub    $0x4,%esp
  80014c:	68 fc 32 80 00       	push   $0x8032fc
  800151:	6a 28                	push   $0x28
  800153:	68 dc 32 80 00       	push   $0x8032dc
  800158:	e8 d8 01 00 00       	call   800335 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  80015d:	e8 3f 18 00 00       	call   8019a1 <sys_calculate_free_frames>
  800162:	89 c2                	mov    %eax,%edx
  800164:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800167:	39 c2                	cmp    %eax,%edx
  800169:	74 14                	je     80017f <_main+0x147>
  80016b:	83 ec 04             	sub    $0x4,%esp
  80016e:	68 5c 33 80 00       	push   $0x80335c
  800173:	6a 29                	push   $0x29
  800175:	68 dc 32 80 00       	push   $0x8032dc
  80017a:	e8 b6 01 00 00       	call   800335 <_panic>
	sys_enable_interrupt();
  80017f:	e8 24 19 00 00       	call   801aa8 <sys_enable_interrupt>

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  800184:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800187:	8b 00                	mov    (%eax),%eax
  800189:	83 f8 0a             	cmp    $0xa,%eax
  80018c:	74 14                	je     8001a2 <_main+0x16a>
  80018e:	83 ec 04             	sub    $0x4,%esp
  800191:	68 f0 33 80 00       	push   $0x8033f0
  800196:	6a 2c                	push   $0x2c
  800198:	68 dc 32 80 00       	push   $0x8032dc
  80019d:	e8 93 01 00 00       	call   800335 <_panic>

	//Edit the writable object
	*z = 30;
  8001a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001a5:	c7 00 1e 00 00 00    	movl   $0x1e,(%eax)
	if (*z != 30) panic("Get(): Shared Variable is not created or got correctly") ;
  8001ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001ae:	8b 00                	mov    (%eax),%eax
  8001b0:	83 f8 1e             	cmp    $0x1e,%eax
  8001b3:	74 14                	je     8001c9 <_main+0x191>
  8001b5:	83 ec 04             	sub    $0x4,%esp
  8001b8:	68 f0 33 80 00       	push   $0x8033f0
  8001bd:	6a 30                	push   $0x30
  8001bf:	68 dc 32 80 00       	push   $0x8032dc
  8001c4:	e8 6c 01 00 00       	call   800335 <_panic>

	//Attempt to edit the ReadOnly object, it should panic
	cprintf("Attempt to edit the ReadOnly object @ va = %x\n", x);
  8001c9:	83 ec 08             	sub    $0x8,%esp
  8001cc:	ff 75 e0             	pushl  -0x20(%ebp)
  8001cf:	68 28 34 80 00       	push   $0x803428
  8001d4:	e8 10 04 00 00       	call   8005e9 <cprintf>
  8001d9:	83 c4 10             	add    $0x10,%esp
	*x = 100;
  8001dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001df:	c7 00 64 00 00 00    	movl   $0x64,(%eax)

	panic("Test FAILED! it should panic early and not reach this line of code") ;
  8001e5:	83 ec 04             	sub    $0x4,%esp
  8001e8:	68 58 34 80 00       	push   $0x803458
  8001ed:	6a 36                	push   $0x36
  8001ef:	68 dc 32 80 00       	push   $0x8032dc
  8001f4:	e8 3c 01 00 00       	call   800335 <_panic>

008001f9 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001f9:	55                   	push   %ebp
  8001fa:	89 e5                	mov    %esp,%ebp
  8001fc:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001ff:	e8 7d 1a 00 00       	call   801c81 <sys_getenvindex>
  800204:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800207:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80020a:	89 d0                	mov    %edx,%eax
  80020c:	c1 e0 03             	shl    $0x3,%eax
  80020f:	01 d0                	add    %edx,%eax
  800211:	01 c0                	add    %eax,%eax
  800213:	01 d0                	add    %edx,%eax
  800215:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80021c:	01 d0                	add    %edx,%eax
  80021e:	c1 e0 04             	shl    $0x4,%eax
  800221:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800226:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80022b:	a1 20 40 80 00       	mov    0x804020,%eax
  800230:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800236:	84 c0                	test   %al,%al
  800238:	74 0f                	je     800249 <libmain+0x50>
		binaryname = myEnv->prog_name;
  80023a:	a1 20 40 80 00       	mov    0x804020,%eax
  80023f:	05 5c 05 00 00       	add    $0x55c,%eax
  800244:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800249:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80024d:	7e 0a                	jle    800259 <libmain+0x60>
		binaryname = argv[0];
  80024f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800252:	8b 00                	mov    (%eax),%eax
  800254:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800259:	83 ec 08             	sub    $0x8,%esp
  80025c:	ff 75 0c             	pushl  0xc(%ebp)
  80025f:	ff 75 08             	pushl  0x8(%ebp)
  800262:	e8 d1 fd ff ff       	call   800038 <_main>
  800267:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80026a:	e8 1f 18 00 00       	call   801a8e <sys_disable_interrupt>
	cprintf("**************************************\n");
  80026f:	83 ec 0c             	sub    $0xc,%esp
  800272:	68 b4 34 80 00       	push   $0x8034b4
  800277:	e8 6d 03 00 00       	call   8005e9 <cprintf>
  80027c:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80027f:	a1 20 40 80 00       	mov    0x804020,%eax
  800284:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80028a:	a1 20 40 80 00       	mov    0x804020,%eax
  80028f:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800295:	83 ec 04             	sub    $0x4,%esp
  800298:	52                   	push   %edx
  800299:	50                   	push   %eax
  80029a:	68 dc 34 80 00       	push   $0x8034dc
  80029f:	e8 45 03 00 00       	call   8005e9 <cprintf>
  8002a4:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002a7:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ac:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8002b2:	a1 20 40 80 00       	mov    0x804020,%eax
  8002b7:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8002bd:	a1 20 40 80 00       	mov    0x804020,%eax
  8002c2:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8002c8:	51                   	push   %ecx
  8002c9:	52                   	push   %edx
  8002ca:	50                   	push   %eax
  8002cb:	68 04 35 80 00       	push   $0x803504
  8002d0:	e8 14 03 00 00       	call   8005e9 <cprintf>
  8002d5:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002d8:	a1 20 40 80 00       	mov    0x804020,%eax
  8002dd:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8002e3:	83 ec 08             	sub    $0x8,%esp
  8002e6:	50                   	push   %eax
  8002e7:	68 5c 35 80 00       	push   $0x80355c
  8002ec:	e8 f8 02 00 00       	call   8005e9 <cprintf>
  8002f1:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002f4:	83 ec 0c             	sub    $0xc,%esp
  8002f7:	68 b4 34 80 00       	push   $0x8034b4
  8002fc:	e8 e8 02 00 00       	call   8005e9 <cprintf>
  800301:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800304:	e8 9f 17 00 00       	call   801aa8 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800309:	e8 19 00 00 00       	call   800327 <exit>
}
  80030e:	90                   	nop
  80030f:	c9                   	leave  
  800310:	c3                   	ret    

00800311 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800311:	55                   	push   %ebp
  800312:	89 e5                	mov    %esp,%ebp
  800314:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800317:	83 ec 0c             	sub    $0xc,%esp
  80031a:	6a 00                	push   $0x0
  80031c:	e8 2c 19 00 00       	call   801c4d <sys_destroy_env>
  800321:	83 c4 10             	add    $0x10,%esp
}
  800324:	90                   	nop
  800325:	c9                   	leave  
  800326:	c3                   	ret    

00800327 <exit>:

void
exit(void)
{
  800327:	55                   	push   %ebp
  800328:	89 e5                	mov    %esp,%ebp
  80032a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80032d:	e8 81 19 00 00       	call   801cb3 <sys_exit_env>
}
  800332:	90                   	nop
  800333:	c9                   	leave  
  800334:	c3                   	ret    

00800335 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800335:	55                   	push   %ebp
  800336:	89 e5                	mov    %esp,%ebp
  800338:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80033b:	8d 45 10             	lea    0x10(%ebp),%eax
  80033e:	83 c0 04             	add    $0x4,%eax
  800341:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800344:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800349:	85 c0                	test   %eax,%eax
  80034b:	74 16                	je     800363 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80034d:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800352:	83 ec 08             	sub    $0x8,%esp
  800355:	50                   	push   %eax
  800356:	68 70 35 80 00       	push   $0x803570
  80035b:	e8 89 02 00 00       	call   8005e9 <cprintf>
  800360:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800363:	a1 00 40 80 00       	mov    0x804000,%eax
  800368:	ff 75 0c             	pushl  0xc(%ebp)
  80036b:	ff 75 08             	pushl  0x8(%ebp)
  80036e:	50                   	push   %eax
  80036f:	68 75 35 80 00       	push   $0x803575
  800374:	e8 70 02 00 00       	call   8005e9 <cprintf>
  800379:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80037c:	8b 45 10             	mov    0x10(%ebp),%eax
  80037f:	83 ec 08             	sub    $0x8,%esp
  800382:	ff 75 f4             	pushl  -0xc(%ebp)
  800385:	50                   	push   %eax
  800386:	e8 f3 01 00 00       	call   80057e <vcprintf>
  80038b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80038e:	83 ec 08             	sub    $0x8,%esp
  800391:	6a 00                	push   $0x0
  800393:	68 91 35 80 00       	push   $0x803591
  800398:	e8 e1 01 00 00       	call   80057e <vcprintf>
  80039d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003a0:	e8 82 ff ff ff       	call   800327 <exit>

	// should not return here
	while (1) ;
  8003a5:	eb fe                	jmp    8003a5 <_panic+0x70>

008003a7 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8003a7:	55                   	push   %ebp
  8003a8:	89 e5                	mov    %esp,%ebp
  8003aa:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8003ad:	a1 20 40 80 00       	mov    0x804020,%eax
  8003b2:	8b 50 74             	mov    0x74(%eax),%edx
  8003b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b8:	39 c2                	cmp    %eax,%edx
  8003ba:	74 14                	je     8003d0 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003bc:	83 ec 04             	sub    $0x4,%esp
  8003bf:	68 94 35 80 00       	push   $0x803594
  8003c4:	6a 26                	push   $0x26
  8003c6:	68 e0 35 80 00       	push   $0x8035e0
  8003cb:	e8 65 ff ff ff       	call   800335 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003d7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003de:	e9 c2 00 00 00       	jmp    8004a5 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8003e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f0:	01 d0                	add    %edx,%eax
  8003f2:	8b 00                	mov    (%eax),%eax
  8003f4:	85 c0                	test   %eax,%eax
  8003f6:	75 08                	jne    800400 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8003f8:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003fb:	e9 a2 00 00 00       	jmp    8004a2 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800400:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800407:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80040e:	eb 69                	jmp    800479 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800410:	a1 20 40 80 00       	mov    0x804020,%eax
  800415:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80041b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80041e:	89 d0                	mov    %edx,%eax
  800420:	01 c0                	add    %eax,%eax
  800422:	01 d0                	add    %edx,%eax
  800424:	c1 e0 03             	shl    $0x3,%eax
  800427:	01 c8                	add    %ecx,%eax
  800429:	8a 40 04             	mov    0x4(%eax),%al
  80042c:	84 c0                	test   %al,%al
  80042e:	75 46                	jne    800476 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800430:	a1 20 40 80 00       	mov    0x804020,%eax
  800435:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80043b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80043e:	89 d0                	mov    %edx,%eax
  800440:	01 c0                	add    %eax,%eax
  800442:	01 d0                	add    %edx,%eax
  800444:	c1 e0 03             	shl    $0x3,%eax
  800447:	01 c8                	add    %ecx,%eax
  800449:	8b 00                	mov    (%eax),%eax
  80044b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80044e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800451:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800456:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800458:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80045b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800462:	8b 45 08             	mov    0x8(%ebp),%eax
  800465:	01 c8                	add    %ecx,%eax
  800467:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800469:	39 c2                	cmp    %eax,%edx
  80046b:	75 09                	jne    800476 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80046d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800474:	eb 12                	jmp    800488 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800476:	ff 45 e8             	incl   -0x18(%ebp)
  800479:	a1 20 40 80 00       	mov    0x804020,%eax
  80047e:	8b 50 74             	mov    0x74(%eax),%edx
  800481:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800484:	39 c2                	cmp    %eax,%edx
  800486:	77 88                	ja     800410 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800488:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80048c:	75 14                	jne    8004a2 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80048e:	83 ec 04             	sub    $0x4,%esp
  800491:	68 ec 35 80 00       	push   $0x8035ec
  800496:	6a 3a                	push   $0x3a
  800498:	68 e0 35 80 00       	push   $0x8035e0
  80049d:	e8 93 fe ff ff       	call   800335 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004a2:	ff 45 f0             	incl   -0x10(%ebp)
  8004a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004a8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004ab:	0f 8c 32 ff ff ff    	jl     8003e3 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004b1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004b8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004bf:	eb 26                	jmp    8004e7 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004c1:	a1 20 40 80 00       	mov    0x804020,%eax
  8004c6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004cf:	89 d0                	mov    %edx,%eax
  8004d1:	01 c0                	add    %eax,%eax
  8004d3:	01 d0                	add    %edx,%eax
  8004d5:	c1 e0 03             	shl    $0x3,%eax
  8004d8:	01 c8                	add    %ecx,%eax
  8004da:	8a 40 04             	mov    0x4(%eax),%al
  8004dd:	3c 01                	cmp    $0x1,%al
  8004df:	75 03                	jne    8004e4 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8004e1:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004e4:	ff 45 e0             	incl   -0x20(%ebp)
  8004e7:	a1 20 40 80 00       	mov    0x804020,%eax
  8004ec:	8b 50 74             	mov    0x74(%eax),%edx
  8004ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004f2:	39 c2                	cmp    %eax,%edx
  8004f4:	77 cb                	ja     8004c1 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004f9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004fc:	74 14                	je     800512 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8004fe:	83 ec 04             	sub    $0x4,%esp
  800501:	68 40 36 80 00       	push   $0x803640
  800506:	6a 44                	push   $0x44
  800508:	68 e0 35 80 00       	push   $0x8035e0
  80050d:	e8 23 fe ff ff       	call   800335 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800512:	90                   	nop
  800513:	c9                   	leave  
  800514:	c3                   	ret    

00800515 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800515:	55                   	push   %ebp
  800516:	89 e5                	mov    %esp,%ebp
  800518:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80051b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051e:	8b 00                	mov    (%eax),%eax
  800520:	8d 48 01             	lea    0x1(%eax),%ecx
  800523:	8b 55 0c             	mov    0xc(%ebp),%edx
  800526:	89 0a                	mov    %ecx,(%edx)
  800528:	8b 55 08             	mov    0x8(%ebp),%edx
  80052b:	88 d1                	mov    %dl,%cl
  80052d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800530:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800534:	8b 45 0c             	mov    0xc(%ebp),%eax
  800537:	8b 00                	mov    (%eax),%eax
  800539:	3d ff 00 00 00       	cmp    $0xff,%eax
  80053e:	75 2c                	jne    80056c <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800540:	a0 24 40 80 00       	mov    0x804024,%al
  800545:	0f b6 c0             	movzbl %al,%eax
  800548:	8b 55 0c             	mov    0xc(%ebp),%edx
  80054b:	8b 12                	mov    (%edx),%edx
  80054d:	89 d1                	mov    %edx,%ecx
  80054f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800552:	83 c2 08             	add    $0x8,%edx
  800555:	83 ec 04             	sub    $0x4,%esp
  800558:	50                   	push   %eax
  800559:	51                   	push   %ecx
  80055a:	52                   	push   %edx
  80055b:	e8 80 13 00 00       	call   8018e0 <sys_cputs>
  800560:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800563:	8b 45 0c             	mov    0xc(%ebp),%eax
  800566:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80056c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80056f:	8b 40 04             	mov    0x4(%eax),%eax
  800572:	8d 50 01             	lea    0x1(%eax),%edx
  800575:	8b 45 0c             	mov    0xc(%ebp),%eax
  800578:	89 50 04             	mov    %edx,0x4(%eax)
}
  80057b:	90                   	nop
  80057c:	c9                   	leave  
  80057d:	c3                   	ret    

0080057e <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80057e:	55                   	push   %ebp
  80057f:	89 e5                	mov    %esp,%ebp
  800581:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800587:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80058e:	00 00 00 
	b.cnt = 0;
  800591:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800598:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80059b:	ff 75 0c             	pushl  0xc(%ebp)
  80059e:	ff 75 08             	pushl  0x8(%ebp)
  8005a1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005a7:	50                   	push   %eax
  8005a8:	68 15 05 80 00       	push   $0x800515
  8005ad:	e8 11 02 00 00       	call   8007c3 <vprintfmt>
  8005b2:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005b5:	a0 24 40 80 00       	mov    0x804024,%al
  8005ba:	0f b6 c0             	movzbl %al,%eax
  8005bd:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005c3:	83 ec 04             	sub    $0x4,%esp
  8005c6:	50                   	push   %eax
  8005c7:	52                   	push   %edx
  8005c8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005ce:	83 c0 08             	add    $0x8,%eax
  8005d1:	50                   	push   %eax
  8005d2:	e8 09 13 00 00       	call   8018e0 <sys_cputs>
  8005d7:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005da:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  8005e1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005e7:	c9                   	leave  
  8005e8:	c3                   	ret    

008005e9 <cprintf>:

int cprintf(const char *fmt, ...) {
  8005e9:	55                   	push   %ebp
  8005ea:	89 e5                	mov    %esp,%ebp
  8005ec:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005ef:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8005f6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ff:	83 ec 08             	sub    $0x8,%esp
  800602:	ff 75 f4             	pushl  -0xc(%ebp)
  800605:	50                   	push   %eax
  800606:	e8 73 ff ff ff       	call   80057e <vcprintf>
  80060b:	83 c4 10             	add    $0x10,%esp
  80060e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800611:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800614:	c9                   	leave  
  800615:	c3                   	ret    

00800616 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800616:	55                   	push   %ebp
  800617:	89 e5                	mov    %esp,%ebp
  800619:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80061c:	e8 6d 14 00 00       	call   801a8e <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800621:	8d 45 0c             	lea    0xc(%ebp),%eax
  800624:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800627:	8b 45 08             	mov    0x8(%ebp),%eax
  80062a:	83 ec 08             	sub    $0x8,%esp
  80062d:	ff 75 f4             	pushl  -0xc(%ebp)
  800630:	50                   	push   %eax
  800631:	e8 48 ff ff ff       	call   80057e <vcprintf>
  800636:	83 c4 10             	add    $0x10,%esp
  800639:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80063c:	e8 67 14 00 00       	call   801aa8 <sys_enable_interrupt>
	return cnt;
  800641:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800644:	c9                   	leave  
  800645:	c3                   	ret    

00800646 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800646:	55                   	push   %ebp
  800647:	89 e5                	mov    %esp,%ebp
  800649:	53                   	push   %ebx
  80064a:	83 ec 14             	sub    $0x14,%esp
  80064d:	8b 45 10             	mov    0x10(%ebp),%eax
  800650:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800653:	8b 45 14             	mov    0x14(%ebp),%eax
  800656:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800659:	8b 45 18             	mov    0x18(%ebp),%eax
  80065c:	ba 00 00 00 00       	mov    $0x0,%edx
  800661:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800664:	77 55                	ja     8006bb <printnum+0x75>
  800666:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800669:	72 05                	jb     800670 <printnum+0x2a>
  80066b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80066e:	77 4b                	ja     8006bb <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800670:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800673:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800676:	8b 45 18             	mov    0x18(%ebp),%eax
  800679:	ba 00 00 00 00       	mov    $0x0,%edx
  80067e:	52                   	push   %edx
  80067f:	50                   	push   %eax
  800680:	ff 75 f4             	pushl  -0xc(%ebp)
  800683:	ff 75 f0             	pushl  -0x10(%ebp)
  800686:	e8 cd 29 00 00       	call   803058 <__udivdi3>
  80068b:	83 c4 10             	add    $0x10,%esp
  80068e:	83 ec 04             	sub    $0x4,%esp
  800691:	ff 75 20             	pushl  0x20(%ebp)
  800694:	53                   	push   %ebx
  800695:	ff 75 18             	pushl  0x18(%ebp)
  800698:	52                   	push   %edx
  800699:	50                   	push   %eax
  80069a:	ff 75 0c             	pushl  0xc(%ebp)
  80069d:	ff 75 08             	pushl  0x8(%ebp)
  8006a0:	e8 a1 ff ff ff       	call   800646 <printnum>
  8006a5:	83 c4 20             	add    $0x20,%esp
  8006a8:	eb 1a                	jmp    8006c4 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006aa:	83 ec 08             	sub    $0x8,%esp
  8006ad:	ff 75 0c             	pushl  0xc(%ebp)
  8006b0:	ff 75 20             	pushl  0x20(%ebp)
  8006b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b6:	ff d0                	call   *%eax
  8006b8:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006bb:	ff 4d 1c             	decl   0x1c(%ebp)
  8006be:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006c2:	7f e6                	jg     8006aa <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006c4:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006c7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006d2:	53                   	push   %ebx
  8006d3:	51                   	push   %ecx
  8006d4:	52                   	push   %edx
  8006d5:	50                   	push   %eax
  8006d6:	e8 8d 2a 00 00       	call   803168 <__umoddi3>
  8006db:	83 c4 10             	add    $0x10,%esp
  8006de:	05 b4 38 80 00       	add    $0x8038b4,%eax
  8006e3:	8a 00                	mov    (%eax),%al
  8006e5:	0f be c0             	movsbl %al,%eax
  8006e8:	83 ec 08             	sub    $0x8,%esp
  8006eb:	ff 75 0c             	pushl  0xc(%ebp)
  8006ee:	50                   	push   %eax
  8006ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f2:	ff d0                	call   *%eax
  8006f4:	83 c4 10             	add    $0x10,%esp
}
  8006f7:	90                   	nop
  8006f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006fb:	c9                   	leave  
  8006fc:	c3                   	ret    

008006fd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006fd:	55                   	push   %ebp
  8006fe:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800700:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800704:	7e 1c                	jle    800722 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800706:	8b 45 08             	mov    0x8(%ebp),%eax
  800709:	8b 00                	mov    (%eax),%eax
  80070b:	8d 50 08             	lea    0x8(%eax),%edx
  80070e:	8b 45 08             	mov    0x8(%ebp),%eax
  800711:	89 10                	mov    %edx,(%eax)
  800713:	8b 45 08             	mov    0x8(%ebp),%eax
  800716:	8b 00                	mov    (%eax),%eax
  800718:	83 e8 08             	sub    $0x8,%eax
  80071b:	8b 50 04             	mov    0x4(%eax),%edx
  80071e:	8b 00                	mov    (%eax),%eax
  800720:	eb 40                	jmp    800762 <getuint+0x65>
	else if (lflag)
  800722:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800726:	74 1e                	je     800746 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	8b 00                	mov    (%eax),%eax
  80072d:	8d 50 04             	lea    0x4(%eax),%edx
  800730:	8b 45 08             	mov    0x8(%ebp),%eax
  800733:	89 10                	mov    %edx,(%eax)
  800735:	8b 45 08             	mov    0x8(%ebp),%eax
  800738:	8b 00                	mov    (%eax),%eax
  80073a:	83 e8 04             	sub    $0x4,%eax
  80073d:	8b 00                	mov    (%eax),%eax
  80073f:	ba 00 00 00 00       	mov    $0x0,%edx
  800744:	eb 1c                	jmp    800762 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800746:	8b 45 08             	mov    0x8(%ebp),%eax
  800749:	8b 00                	mov    (%eax),%eax
  80074b:	8d 50 04             	lea    0x4(%eax),%edx
  80074e:	8b 45 08             	mov    0x8(%ebp),%eax
  800751:	89 10                	mov    %edx,(%eax)
  800753:	8b 45 08             	mov    0x8(%ebp),%eax
  800756:	8b 00                	mov    (%eax),%eax
  800758:	83 e8 04             	sub    $0x4,%eax
  80075b:	8b 00                	mov    (%eax),%eax
  80075d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800762:	5d                   	pop    %ebp
  800763:	c3                   	ret    

00800764 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800764:	55                   	push   %ebp
  800765:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800767:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80076b:	7e 1c                	jle    800789 <getint+0x25>
		return va_arg(*ap, long long);
  80076d:	8b 45 08             	mov    0x8(%ebp),%eax
  800770:	8b 00                	mov    (%eax),%eax
  800772:	8d 50 08             	lea    0x8(%eax),%edx
  800775:	8b 45 08             	mov    0x8(%ebp),%eax
  800778:	89 10                	mov    %edx,(%eax)
  80077a:	8b 45 08             	mov    0x8(%ebp),%eax
  80077d:	8b 00                	mov    (%eax),%eax
  80077f:	83 e8 08             	sub    $0x8,%eax
  800782:	8b 50 04             	mov    0x4(%eax),%edx
  800785:	8b 00                	mov    (%eax),%eax
  800787:	eb 38                	jmp    8007c1 <getint+0x5d>
	else if (lflag)
  800789:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80078d:	74 1a                	je     8007a9 <getint+0x45>
		return va_arg(*ap, long);
  80078f:	8b 45 08             	mov    0x8(%ebp),%eax
  800792:	8b 00                	mov    (%eax),%eax
  800794:	8d 50 04             	lea    0x4(%eax),%edx
  800797:	8b 45 08             	mov    0x8(%ebp),%eax
  80079a:	89 10                	mov    %edx,(%eax)
  80079c:	8b 45 08             	mov    0x8(%ebp),%eax
  80079f:	8b 00                	mov    (%eax),%eax
  8007a1:	83 e8 04             	sub    $0x4,%eax
  8007a4:	8b 00                	mov    (%eax),%eax
  8007a6:	99                   	cltd   
  8007a7:	eb 18                	jmp    8007c1 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ac:	8b 00                	mov    (%eax),%eax
  8007ae:	8d 50 04             	lea    0x4(%eax),%edx
  8007b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b4:	89 10                	mov    %edx,(%eax)
  8007b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b9:	8b 00                	mov    (%eax),%eax
  8007bb:	83 e8 04             	sub    $0x4,%eax
  8007be:	8b 00                	mov    (%eax),%eax
  8007c0:	99                   	cltd   
}
  8007c1:	5d                   	pop    %ebp
  8007c2:	c3                   	ret    

008007c3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007c3:	55                   	push   %ebp
  8007c4:	89 e5                	mov    %esp,%ebp
  8007c6:	56                   	push   %esi
  8007c7:	53                   	push   %ebx
  8007c8:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007cb:	eb 17                	jmp    8007e4 <vprintfmt+0x21>
			if (ch == '\0')
  8007cd:	85 db                	test   %ebx,%ebx
  8007cf:	0f 84 af 03 00 00    	je     800b84 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8007d5:	83 ec 08             	sub    $0x8,%esp
  8007d8:	ff 75 0c             	pushl  0xc(%ebp)
  8007db:	53                   	push   %ebx
  8007dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007df:	ff d0                	call   *%eax
  8007e1:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e7:	8d 50 01             	lea    0x1(%eax),%edx
  8007ea:	89 55 10             	mov    %edx,0x10(%ebp)
  8007ed:	8a 00                	mov    (%eax),%al
  8007ef:	0f b6 d8             	movzbl %al,%ebx
  8007f2:	83 fb 25             	cmp    $0x25,%ebx
  8007f5:	75 d6                	jne    8007cd <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007f7:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007fb:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800802:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800809:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800810:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800817:	8b 45 10             	mov    0x10(%ebp),%eax
  80081a:	8d 50 01             	lea    0x1(%eax),%edx
  80081d:	89 55 10             	mov    %edx,0x10(%ebp)
  800820:	8a 00                	mov    (%eax),%al
  800822:	0f b6 d8             	movzbl %al,%ebx
  800825:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800828:	83 f8 55             	cmp    $0x55,%eax
  80082b:	0f 87 2b 03 00 00    	ja     800b5c <vprintfmt+0x399>
  800831:	8b 04 85 d8 38 80 00 	mov    0x8038d8(,%eax,4),%eax
  800838:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80083a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80083e:	eb d7                	jmp    800817 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800840:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800844:	eb d1                	jmp    800817 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800846:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80084d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800850:	89 d0                	mov    %edx,%eax
  800852:	c1 e0 02             	shl    $0x2,%eax
  800855:	01 d0                	add    %edx,%eax
  800857:	01 c0                	add    %eax,%eax
  800859:	01 d8                	add    %ebx,%eax
  80085b:	83 e8 30             	sub    $0x30,%eax
  80085e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800861:	8b 45 10             	mov    0x10(%ebp),%eax
  800864:	8a 00                	mov    (%eax),%al
  800866:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800869:	83 fb 2f             	cmp    $0x2f,%ebx
  80086c:	7e 3e                	jle    8008ac <vprintfmt+0xe9>
  80086e:	83 fb 39             	cmp    $0x39,%ebx
  800871:	7f 39                	jg     8008ac <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800873:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800876:	eb d5                	jmp    80084d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800878:	8b 45 14             	mov    0x14(%ebp),%eax
  80087b:	83 c0 04             	add    $0x4,%eax
  80087e:	89 45 14             	mov    %eax,0x14(%ebp)
  800881:	8b 45 14             	mov    0x14(%ebp),%eax
  800884:	83 e8 04             	sub    $0x4,%eax
  800887:	8b 00                	mov    (%eax),%eax
  800889:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80088c:	eb 1f                	jmp    8008ad <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80088e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800892:	79 83                	jns    800817 <vprintfmt+0x54>
				width = 0;
  800894:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80089b:	e9 77 ff ff ff       	jmp    800817 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008a0:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008a7:	e9 6b ff ff ff       	jmp    800817 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008ac:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008b1:	0f 89 60 ff ff ff    	jns    800817 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008bd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008c4:	e9 4e ff ff ff       	jmp    800817 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008c9:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008cc:	e9 46 ff ff ff       	jmp    800817 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d4:	83 c0 04             	add    $0x4,%eax
  8008d7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008da:	8b 45 14             	mov    0x14(%ebp),%eax
  8008dd:	83 e8 04             	sub    $0x4,%eax
  8008e0:	8b 00                	mov    (%eax),%eax
  8008e2:	83 ec 08             	sub    $0x8,%esp
  8008e5:	ff 75 0c             	pushl  0xc(%ebp)
  8008e8:	50                   	push   %eax
  8008e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ec:	ff d0                	call   *%eax
  8008ee:	83 c4 10             	add    $0x10,%esp
			break;
  8008f1:	e9 89 02 00 00       	jmp    800b7f <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f9:	83 c0 04             	add    $0x4,%eax
  8008fc:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800902:	83 e8 04             	sub    $0x4,%eax
  800905:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800907:	85 db                	test   %ebx,%ebx
  800909:	79 02                	jns    80090d <vprintfmt+0x14a>
				err = -err;
  80090b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80090d:	83 fb 64             	cmp    $0x64,%ebx
  800910:	7f 0b                	jg     80091d <vprintfmt+0x15a>
  800912:	8b 34 9d 20 37 80 00 	mov    0x803720(,%ebx,4),%esi
  800919:	85 f6                	test   %esi,%esi
  80091b:	75 19                	jne    800936 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80091d:	53                   	push   %ebx
  80091e:	68 c5 38 80 00       	push   $0x8038c5
  800923:	ff 75 0c             	pushl  0xc(%ebp)
  800926:	ff 75 08             	pushl  0x8(%ebp)
  800929:	e8 5e 02 00 00       	call   800b8c <printfmt>
  80092e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800931:	e9 49 02 00 00       	jmp    800b7f <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800936:	56                   	push   %esi
  800937:	68 ce 38 80 00       	push   $0x8038ce
  80093c:	ff 75 0c             	pushl  0xc(%ebp)
  80093f:	ff 75 08             	pushl  0x8(%ebp)
  800942:	e8 45 02 00 00       	call   800b8c <printfmt>
  800947:	83 c4 10             	add    $0x10,%esp
			break;
  80094a:	e9 30 02 00 00       	jmp    800b7f <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80094f:	8b 45 14             	mov    0x14(%ebp),%eax
  800952:	83 c0 04             	add    $0x4,%eax
  800955:	89 45 14             	mov    %eax,0x14(%ebp)
  800958:	8b 45 14             	mov    0x14(%ebp),%eax
  80095b:	83 e8 04             	sub    $0x4,%eax
  80095e:	8b 30                	mov    (%eax),%esi
  800960:	85 f6                	test   %esi,%esi
  800962:	75 05                	jne    800969 <vprintfmt+0x1a6>
				p = "(null)";
  800964:	be d1 38 80 00       	mov    $0x8038d1,%esi
			if (width > 0 && padc != '-')
  800969:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80096d:	7e 6d                	jle    8009dc <vprintfmt+0x219>
  80096f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800973:	74 67                	je     8009dc <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800975:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800978:	83 ec 08             	sub    $0x8,%esp
  80097b:	50                   	push   %eax
  80097c:	56                   	push   %esi
  80097d:	e8 0c 03 00 00       	call   800c8e <strnlen>
  800982:	83 c4 10             	add    $0x10,%esp
  800985:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800988:	eb 16                	jmp    8009a0 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80098a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80098e:	83 ec 08             	sub    $0x8,%esp
  800991:	ff 75 0c             	pushl  0xc(%ebp)
  800994:	50                   	push   %eax
  800995:	8b 45 08             	mov    0x8(%ebp),%eax
  800998:	ff d0                	call   *%eax
  80099a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80099d:	ff 4d e4             	decl   -0x1c(%ebp)
  8009a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009a4:	7f e4                	jg     80098a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009a6:	eb 34                	jmp    8009dc <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009a8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009ac:	74 1c                	je     8009ca <vprintfmt+0x207>
  8009ae:	83 fb 1f             	cmp    $0x1f,%ebx
  8009b1:	7e 05                	jle    8009b8 <vprintfmt+0x1f5>
  8009b3:	83 fb 7e             	cmp    $0x7e,%ebx
  8009b6:	7e 12                	jle    8009ca <vprintfmt+0x207>
					putch('?', putdat);
  8009b8:	83 ec 08             	sub    $0x8,%esp
  8009bb:	ff 75 0c             	pushl  0xc(%ebp)
  8009be:	6a 3f                	push   $0x3f
  8009c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c3:	ff d0                	call   *%eax
  8009c5:	83 c4 10             	add    $0x10,%esp
  8009c8:	eb 0f                	jmp    8009d9 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009ca:	83 ec 08             	sub    $0x8,%esp
  8009cd:	ff 75 0c             	pushl  0xc(%ebp)
  8009d0:	53                   	push   %ebx
  8009d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d4:	ff d0                	call   *%eax
  8009d6:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009d9:	ff 4d e4             	decl   -0x1c(%ebp)
  8009dc:	89 f0                	mov    %esi,%eax
  8009de:	8d 70 01             	lea    0x1(%eax),%esi
  8009e1:	8a 00                	mov    (%eax),%al
  8009e3:	0f be d8             	movsbl %al,%ebx
  8009e6:	85 db                	test   %ebx,%ebx
  8009e8:	74 24                	je     800a0e <vprintfmt+0x24b>
  8009ea:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009ee:	78 b8                	js     8009a8 <vprintfmt+0x1e5>
  8009f0:	ff 4d e0             	decl   -0x20(%ebp)
  8009f3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009f7:	79 af                	jns    8009a8 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009f9:	eb 13                	jmp    800a0e <vprintfmt+0x24b>
				putch(' ', putdat);
  8009fb:	83 ec 08             	sub    $0x8,%esp
  8009fe:	ff 75 0c             	pushl  0xc(%ebp)
  800a01:	6a 20                	push   $0x20
  800a03:	8b 45 08             	mov    0x8(%ebp),%eax
  800a06:	ff d0                	call   *%eax
  800a08:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a0b:	ff 4d e4             	decl   -0x1c(%ebp)
  800a0e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a12:	7f e7                	jg     8009fb <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a14:	e9 66 01 00 00       	jmp    800b7f <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a19:	83 ec 08             	sub    $0x8,%esp
  800a1c:	ff 75 e8             	pushl  -0x18(%ebp)
  800a1f:	8d 45 14             	lea    0x14(%ebp),%eax
  800a22:	50                   	push   %eax
  800a23:	e8 3c fd ff ff       	call   800764 <getint>
  800a28:	83 c4 10             	add    $0x10,%esp
  800a2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a2e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a37:	85 d2                	test   %edx,%edx
  800a39:	79 23                	jns    800a5e <vprintfmt+0x29b>
				putch('-', putdat);
  800a3b:	83 ec 08             	sub    $0x8,%esp
  800a3e:	ff 75 0c             	pushl  0xc(%ebp)
  800a41:	6a 2d                	push   $0x2d
  800a43:	8b 45 08             	mov    0x8(%ebp),%eax
  800a46:	ff d0                	call   *%eax
  800a48:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a51:	f7 d8                	neg    %eax
  800a53:	83 d2 00             	adc    $0x0,%edx
  800a56:	f7 da                	neg    %edx
  800a58:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a5b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a5e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a65:	e9 bc 00 00 00       	jmp    800b26 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a6a:	83 ec 08             	sub    $0x8,%esp
  800a6d:	ff 75 e8             	pushl  -0x18(%ebp)
  800a70:	8d 45 14             	lea    0x14(%ebp),%eax
  800a73:	50                   	push   %eax
  800a74:	e8 84 fc ff ff       	call   8006fd <getuint>
  800a79:	83 c4 10             	add    $0x10,%esp
  800a7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a7f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a82:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a89:	e9 98 00 00 00       	jmp    800b26 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a8e:	83 ec 08             	sub    $0x8,%esp
  800a91:	ff 75 0c             	pushl  0xc(%ebp)
  800a94:	6a 58                	push   $0x58
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	ff d0                	call   *%eax
  800a9b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a9e:	83 ec 08             	sub    $0x8,%esp
  800aa1:	ff 75 0c             	pushl  0xc(%ebp)
  800aa4:	6a 58                	push   $0x58
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	ff d0                	call   *%eax
  800aab:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800aae:	83 ec 08             	sub    $0x8,%esp
  800ab1:	ff 75 0c             	pushl  0xc(%ebp)
  800ab4:	6a 58                	push   $0x58
  800ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab9:	ff d0                	call   *%eax
  800abb:	83 c4 10             	add    $0x10,%esp
			break;
  800abe:	e9 bc 00 00 00       	jmp    800b7f <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800ac3:	83 ec 08             	sub    $0x8,%esp
  800ac6:	ff 75 0c             	pushl  0xc(%ebp)
  800ac9:	6a 30                	push   $0x30
  800acb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ace:	ff d0                	call   *%eax
  800ad0:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ad3:	83 ec 08             	sub    $0x8,%esp
  800ad6:	ff 75 0c             	pushl  0xc(%ebp)
  800ad9:	6a 78                	push   $0x78
  800adb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ade:	ff d0                	call   *%eax
  800ae0:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ae3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae6:	83 c0 04             	add    $0x4,%eax
  800ae9:	89 45 14             	mov    %eax,0x14(%ebp)
  800aec:	8b 45 14             	mov    0x14(%ebp),%eax
  800aef:	83 e8 04             	sub    $0x4,%eax
  800af2:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800af4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800afe:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b05:	eb 1f                	jmp    800b26 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b07:	83 ec 08             	sub    $0x8,%esp
  800b0a:	ff 75 e8             	pushl  -0x18(%ebp)
  800b0d:	8d 45 14             	lea    0x14(%ebp),%eax
  800b10:	50                   	push   %eax
  800b11:	e8 e7 fb ff ff       	call   8006fd <getuint>
  800b16:	83 c4 10             	add    $0x10,%esp
  800b19:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b1c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b1f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b26:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b2d:	83 ec 04             	sub    $0x4,%esp
  800b30:	52                   	push   %edx
  800b31:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b34:	50                   	push   %eax
  800b35:	ff 75 f4             	pushl  -0xc(%ebp)
  800b38:	ff 75 f0             	pushl  -0x10(%ebp)
  800b3b:	ff 75 0c             	pushl  0xc(%ebp)
  800b3e:	ff 75 08             	pushl  0x8(%ebp)
  800b41:	e8 00 fb ff ff       	call   800646 <printnum>
  800b46:	83 c4 20             	add    $0x20,%esp
			break;
  800b49:	eb 34                	jmp    800b7f <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b4b:	83 ec 08             	sub    $0x8,%esp
  800b4e:	ff 75 0c             	pushl  0xc(%ebp)
  800b51:	53                   	push   %ebx
  800b52:	8b 45 08             	mov    0x8(%ebp),%eax
  800b55:	ff d0                	call   *%eax
  800b57:	83 c4 10             	add    $0x10,%esp
			break;
  800b5a:	eb 23                	jmp    800b7f <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b5c:	83 ec 08             	sub    $0x8,%esp
  800b5f:	ff 75 0c             	pushl  0xc(%ebp)
  800b62:	6a 25                	push   $0x25
  800b64:	8b 45 08             	mov    0x8(%ebp),%eax
  800b67:	ff d0                	call   *%eax
  800b69:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b6c:	ff 4d 10             	decl   0x10(%ebp)
  800b6f:	eb 03                	jmp    800b74 <vprintfmt+0x3b1>
  800b71:	ff 4d 10             	decl   0x10(%ebp)
  800b74:	8b 45 10             	mov    0x10(%ebp),%eax
  800b77:	48                   	dec    %eax
  800b78:	8a 00                	mov    (%eax),%al
  800b7a:	3c 25                	cmp    $0x25,%al
  800b7c:	75 f3                	jne    800b71 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b7e:	90                   	nop
		}
	}
  800b7f:	e9 47 fc ff ff       	jmp    8007cb <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b84:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b85:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b88:	5b                   	pop    %ebx
  800b89:	5e                   	pop    %esi
  800b8a:	5d                   	pop    %ebp
  800b8b:	c3                   	ret    

00800b8c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b92:	8d 45 10             	lea    0x10(%ebp),%eax
  800b95:	83 c0 04             	add    $0x4,%eax
  800b98:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9e:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba1:	50                   	push   %eax
  800ba2:	ff 75 0c             	pushl  0xc(%ebp)
  800ba5:	ff 75 08             	pushl  0x8(%ebp)
  800ba8:	e8 16 fc ff ff       	call   8007c3 <vprintfmt>
  800bad:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bb0:	90                   	nop
  800bb1:	c9                   	leave  
  800bb2:	c3                   	ret    

00800bb3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bb3:	55                   	push   %ebp
  800bb4:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb9:	8b 40 08             	mov    0x8(%eax),%eax
  800bbc:	8d 50 01             	lea    0x1(%eax),%edx
  800bbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc2:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc8:	8b 10                	mov    (%eax),%edx
  800bca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bcd:	8b 40 04             	mov    0x4(%eax),%eax
  800bd0:	39 c2                	cmp    %eax,%edx
  800bd2:	73 12                	jae    800be6 <sprintputch+0x33>
		*b->buf++ = ch;
  800bd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd7:	8b 00                	mov    (%eax),%eax
  800bd9:	8d 48 01             	lea    0x1(%eax),%ecx
  800bdc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bdf:	89 0a                	mov    %ecx,(%edx)
  800be1:	8b 55 08             	mov    0x8(%ebp),%edx
  800be4:	88 10                	mov    %dl,(%eax)
}
  800be6:	90                   	nop
  800be7:	5d                   	pop    %ebp
  800be8:	c3                   	ret    

00800be9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800be9:	55                   	push   %ebp
  800bea:	89 e5                	mov    %esp,%ebp
  800bec:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bef:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfe:	01 d0                	add    %edx,%eax
  800c00:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c03:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c0a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c0e:	74 06                	je     800c16 <vsnprintf+0x2d>
  800c10:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c14:	7f 07                	jg     800c1d <vsnprintf+0x34>
		return -E_INVAL;
  800c16:	b8 03 00 00 00       	mov    $0x3,%eax
  800c1b:	eb 20                	jmp    800c3d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c1d:	ff 75 14             	pushl  0x14(%ebp)
  800c20:	ff 75 10             	pushl  0x10(%ebp)
  800c23:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c26:	50                   	push   %eax
  800c27:	68 b3 0b 80 00       	push   $0x800bb3
  800c2c:	e8 92 fb ff ff       	call   8007c3 <vprintfmt>
  800c31:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c37:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c3d:	c9                   	leave  
  800c3e:	c3                   	ret    

00800c3f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c3f:	55                   	push   %ebp
  800c40:	89 e5                	mov    %esp,%ebp
  800c42:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c45:	8d 45 10             	lea    0x10(%ebp),%eax
  800c48:	83 c0 04             	add    $0x4,%eax
  800c4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c4e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c51:	ff 75 f4             	pushl  -0xc(%ebp)
  800c54:	50                   	push   %eax
  800c55:	ff 75 0c             	pushl  0xc(%ebp)
  800c58:	ff 75 08             	pushl  0x8(%ebp)
  800c5b:	e8 89 ff ff ff       	call   800be9 <vsnprintf>
  800c60:	83 c4 10             	add    $0x10,%esp
  800c63:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c66:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c69:	c9                   	leave  
  800c6a:	c3                   	ret    

00800c6b <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c6b:	55                   	push   %ebp
  800c6c:	89 e5                	mov    %esp,%ebp
  800c6e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c71:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c78:	eb 06                	jmp    800c80 <strlen+0x15>
		n++;
  800c7a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c7d:	ff 45 08             	incl   0x8(%ebp)
  800c80:	8b 45 08             	mov    0x8(%ebp),%eax
  800c83:	8a 00                	mov    (%eax),%al
  800c85:	84 c0                	test   %al,%al
  800c87:	75 f1                	jne    800c7a <strlen+0xf>
		n++;
	return n;
  800c89:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c8c:	c9                   	leave  
  800c8d:	c3                   	ret    

00800c8e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c8e:	55                   	push   %ebp
  800c8f:	89 e5                	mov    %esp,%ebp
  800c91:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c94:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c9b:	eb 09                	jmp    800ca6 <strnlen+0x18>
		n++;
  800c9d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ca0:	ff 45 08             	incl   0x8(%ebp)
  800ca3:	ff 4d 0c             	decl   0xc(%ebp)
  800ca6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800caa:	74 09                	je     800cb5 <strnlen+0x27>
  800cac:	8b 45 08             	mov    0x8(%ebp),%eax
  800caf:	8a 00                	mov    (%eax),%al
  800cb1:	84 c0                	test   %al,%al
  800cb3:	75 e8                	jne    800c9d <strnlen+0xf>
		n++;
	return n;
  800cb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cb8:	c9                   	leave  
  800cb9:	c3                   	ret    

00800cba <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cba:	55                   	push   %ebp
  800cbb:	89 e5                	mov    %esp,%ebp
  800cbd:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cc6:	90                   	nop
  800cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cca:	8d 50 01             	lea    0x1(%eax),%edx
  800ccd:	89 55 08             	mov    %edx,0x8(%ebp)
  800cd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cd3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cd6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cd9:	8a 12                	mov    (%edx),%dl
  800cdb:	88 10                	mov    %dl,(%eax)
  800cdd:	8a 00                	mov    (%eax),%al
  800cdf:	84 c0                	test   %al,%al
  800ce1:	75 e4                	jne    800cc7 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ce3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ce6:	c9                   	leave  
  800ce7:	c3                   	ret    

00800ce8 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ce8:	55                   	push   %ebp
  800ce9:	89 e5                	mov    %esp,%ebp
  800ceb:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cf4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cfb:	eb 1f                	jmp    800d1c <strncpy+0x34>
		*dst++ = *src;
  800cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800d00:	8d 50 01             	lea    0x1(%eax),%edx
  800d03:	89 55 08             	mov    %edx,0x8(%ebp)
  800d06:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d09:	8a 12                	mov    (%edx),%dl
  800d0b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	84 c0                	test   %al,%al
  800d14:	74 03                	je     800d19 <strncpy+0x31>
			src++;
  800d16:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d19:	ff 45 fc             	incl   -0x4(%ebp)
  800d1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d1f:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d22:	72 d9                	jb     800cfd <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d24:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d27:	c9                   	leave  
  800d28:	c3                   	ret    

00800d29 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d29:	55                   	push   %ebp
  800d2a:	89 e5                	mov    %esp,%ebp
  800d2c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d32:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d39:	74 30                	je     800d6b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d3b:	eb 16                	jmp    800d53 <strlcpy+0x2a>
			*dst++ = *src++;
  800d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d40:	8d 50 01             	lea    0x1(%eax),%edx
  800d43:	89 55 08             	mov    %edx,0x8(%ebp)
  800d46:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d49:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d4c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d4f:	8a 12                	mov    (%edx),%dl
  800d51:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d53:	ff 4d 10             	decl   0x10(%ebp)
  800d56:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5a:	74 09                	je     800d65 <strlcpy+0x3c>
  800d5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5f:	8a 00                	mov    (%eax),%al
  800d61:	84 c0                	test   %al,%al
  800d63:	75 d8                	jne    800d3d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d71:	29 c2                	sub    %eax,%edx
  800d73:	89 d0                	mov    %edx,%eax
}
  800d75:	c9                   	leave  
  800d76:	c3                   	ret    

00800d77 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d77:	55                   	push   %ebp
  800d78:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d7a:	eb 06                	jmp    800d82 <strcmp+0xb>
		p++, q++;
  800d7c:	ff 45 08             	incl   0x8(%ebp)
  800d7f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d82:	8b 45 08             	mov    0x8(%ebp),%eax
  800d85:	8a 00                	mov    (%eax),%al
  800d87:	84 c0                	test   %al,%al
  800d89:	74 0e                	je     800d99 <strcmp+0x22>
  800d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8e:	8a 10                	mov    (%eax),%dl
  800d90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d93:	8a 00                	mov    (%eax),%al
  800d95:	38 c2                	cmp    %al,%dl
  800d97:	74 e3                	je     800d7c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d99:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9c:	8a 00                	mov    (%eax),%al
  800d9e:	0f b6 d0             	movzbl %al,%edx
  800da1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da4:	8a 00                	mov    (%eax),%al
  800da6:	0f b6 c0             	movzbl %al,%eax
  800da9:	29 c2                	sub    %eax,%edx
  800dab:	89 d0                	mov    %edx,%eax
}
  800dad:	5d                   	pop    %ebp
  800dae:	c3                   	ret    

00800daf <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800daf:	55                   	push   %ebp
  800db0:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800db2:	eb 09                	jmp    800dbd <strncmp+0xe>
		n--, p++, q++;
  800db4:	ff 4d 10             	decl   0x10(%ebp)
  800db7:	ff 45 08             	incl   0x8(%ebp)
  800dba:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800dbd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dc1:	74 17                	je     800dda <strncmp+0x2b>
  800dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc6:	8a 00                	mov    (%eax),%al
  800dc8:	84 c0                	test   %al,%al
  800dca:	74 0e                	je     800dda <strncmp+0x2b>
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcf:	8a 10                	mov    (%eax),%dl
  800dd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd4:	8a 00                	mov    (%eax),%al
  800dd6:	38 c2                	cmp    %al,%dl
  800dd8:	74 da                	je     800db4 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dda:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dde:	75 07                	jne    800de7 <strncmp+0x38>
		return 0;
  800de0:	b8 00 00 00 00       	mov    $0x0,%eax
  800de5:	eb 14                	jmp    800dfb <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	8a 00                	mov    (%eax),%al
  800dec:	0f b6 d0             	movzbl %al,%edx
  800def:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df2:	8a 00                	mov    (%eax),%al
  800df4:	0f b6 c0             	movzbl %al,%eax
  800df7:	29 c2                	sub    %eax,%edx
  800df9:	89 d0                	mov    %edx,%eax
}
  800dfb:	5d                   	pop    %ebp
  800dfc:	c3                   	ret    

00800dfd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800dfd:	55                   	push   %ebp
  800dfe:	89 e5                	mov    %esp,%ebp
  800e00:	83 ec 04             	sub    $0x4,%esp
  800e03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e06:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e09:	eb 12                	jmp    800e1d <strchr+0x20>
		if (*s == c)
  800e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0e:	8a 00                	mov    (%eax),%al
  800e10:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e13:	75 05                	jne    800e1a <strchr+0x1d>
			return (char *) s;
  800e15:	8b 45 08             	mov    0x8(%ebp),%eax
  800e18:	eb 11                	jmp    800e2b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e1a:	ff 45 08             	incl   0x8(%ebp)
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	8a 00                	mov    (%eax),%al
  800e22:	84 c0                	test   %al,%al
  800e24:	75 e5                	jne    800e0b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e2b:	c9                   	leave  
  800e2c:	c3                   	ret    

00800e2d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e2d:	55                   	push   %ebp
  800e2e:	89 e5                	mov    %esp,%ebp
  800e30:	83 ec 04             	sub    $0x4,%esp
  800e33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e36:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e39:	eb 0d                	jmp    800e48 <strfind+0x1b>
		if (*s == c)
  800e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3e:	8a 00                	mov    (%eax),%al
  800e40:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e43:	74 0e                	je     800e53 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e45:	ff 45 08             	incl   0x8(%ebp)
  800e48:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4b:	8a 00                	mov    (%eax),%al
  800e4d:	84 c0                	test   %al,%al
  800e4f:	75 ea                	jne    800e3b <strfind+0xe>
  800e51:	eb 01                	jmp    800e54 <strfind+0x27>
		if (*s == c)
			break;
  800e53:	90                   	nop
	return (char *) s;
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e57:	c9                   	leave  
  800e58:	c3                   	ret    

00800e59 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e59:	55                   	push   %ebp
  800e5a:	89 e5                	mov    %esp,%ebp
  800e5c:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e65:	8b 45 10             	mov    0x10(%ebp),%eax
  800e68:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e6b:	eb 0e                	jmp    800e7b <memset+0x22>
		*p++ = c;
  800e6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e70:	8d 50 01             	lea    0x1(%eax),%edx
  800e73:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e76:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e79:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e7b:	ff 4d f8             	decl   -0x8(%ebp)
  800e7e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e82:	79 e9                	jns    800e6d <memset+0x14>
		*p++ = c;

	return v;
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e87:	c9                   	leave  
  800e88:	c3                   	ret    

00800e89 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e89:	55                   	push   %ebp
  800e8a:	89 e5                	mov    %esp,%ebp
  800e8c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e92:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e95:	8b 45 08             	mov    0x8(%ebp),%eax
  800e98:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e9b:	eb 16                	jmp    800eb3 <memcpy+0x2a>
		*d++ = *s++;
  800e9d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea0:	8d 50 01             	lea    0x1(%eax),%edx
  800ea3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ea6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ea9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eac:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800eaf:	8a 12                	mov    (%edx),%dl
  800eb1:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800eb3:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eb9:	89 55 10             	mov    %edx,0x10(%ebp)
  800ebc:	85 c0                	test   %eax,%eax
  800ebe:	75 dd                	jne    800e9d <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ec0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec3:	c9                   	leave  
  800ec4:	c3                   	ret    

00800ec5 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ec5:	55                   	push   %ebp
  800ec6:	89 e5                	mov    %esp,%ebp
  800ec8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ece:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ed7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eda:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800edd:	73 50                	jae    800f2f <memmove+0x6a>
  800edf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ee2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee5:	01 d0                	add    %edx,%eax
  800ee7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800eea:	76 43                	jbe    800f2f <memmove+0x6a>
		s += n;
  800eec:	8b 45 10             	mov    0x10(%ebp),%eax
  800eef:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ef2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef5:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ef8:	eb 10                	jmp    800f0a <memmove+0x45>
			*--d = *--s;
  800efa:	ff 4d f8             	decl   -0x8(%ebp)
  800efd:	ff 4d fc             	decl   -0x4(%ebp)
  800f00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f03:	8a 10                	mov    (%eax),%dl
  800f05:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f08:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f0a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f10:	89 55 10             	mov    %edx,0x10(%ebp)
  800f13:	85 c0                	test   %eax,%eax
  800f15:	75 e3                	jne    800efa <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f17:	eb 23                	jmp    800f3c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f19:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f1c:	8d 50 01             	lea    0x1(%eax),%edx
  800f1f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f22:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f25:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f28:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f2b:	8a 12                	mov    (%edx),%dl
  800f2d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f32:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f35:	89 55 10             	mov    %edx,0x10(%ebp)
  800f38:	85 c0                	test   %eax,%eax
  800f3a:	75 dd                	jne    800f19 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f3c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f3f:	c9                   	leave  
  800f40:	c3                   	ret    

00800f41 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f41:	55                   	push   %ebp
  800f42:	89 e5                	mov    %esp,%ebp
  800f44:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f50:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f53:	eb 2a                	jmp    800f7f <memcmp+0x3e>
		if (*s1 != *s2)
  800f55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f58:	8a 10                	mov    (%eax),%dl
  800f5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5d:	8a 00                	mov    (%eax),%al
  800f5f:	38 c2                	cmp    %al,%dl
  800f61:	74 16                	je     800f79 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f63:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f66:	8a 00                	mov    (%eax),%al
  800f68:	0f b6 d0             	movzbl %al,%edx
  800f6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f6e:	8a 00                	mov    (%eax),%al
  800f70:	0f b6 c0             	movzbl %al,%eax
  800f73:	29 c2                	sub    %eax,%edx
  800f75:	89 d0                	mov    %edx,%eax
  800f77:	eb 18                	jmp    800f91 <memcmp+0x50>
		s1++, s2++;
  800f79:	ff 45 fc             	incl   -0x4(%ebp)
  800f7c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f82:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f85:	89 55 10             	mov    %edx,0x10(%ebp)
  800f88:	85 c0                	test   %eax,%eax
  800f8a:	75 c9                	jne    800f55 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f91:	c9                   	leave  
  800f92:	c3                   	ret    

00800f93 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f93:	55                   	push   %ebp
  800f94:	89 e5                	mov    %esp,%ebp
  800f96:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f99:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9f:	01 d0                	add    %edx,%eax
  800fa1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fa4:	eb 15                	jmp    800fbb <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa9:	8a 00                	mov    (%eax),%al
  800fab:	0f b6 d0             	movzbl %al,%edx
  800fae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb1:	0f b6 c0             	movzbl %al,%eax
  800fb4:	39 c2                	cmp    %eax,%edx
  800fb6:	74 0d                	je     800fc5 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fb8:	ff 45 08             	incl   0x8(%ebp)
  800fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbe:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fc1:	72 e3                	jb     800fa6 <memfind+0x13>
  800fc3:	eb 01                	jmp    800fc6 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fc5:	90                   	nop
	return (void *) s;
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fc9:	c9                   	leave  
  800fca:	c3                   	ret    

00800fcb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fcb:	55                   	push   %ebp
  800fcc:	89 e5                	mov    %esp,%ebp
  800fce:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fd1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fd8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fdf:	eb 03                	jmp    800fe4 <strtol+0x19>
		s++;
  800fe1:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe7:	8a 00                	mov    (%eax),%al
  800fe9:	3c 20                	cmp    $0x20,%al
  800feb:	74 f4                	je     800fe1 <strtol+0x16>
  800fed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff0:	8a 00                	mov    (%eax),%al
  800ff2:	3c 09                	cmp    $0x9,%al
  800ff4:	74 eb                	je     800fe1 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff9:	8a 00                	mov    (%eax),%al
  800ffb:	3c 2b                	cmp    $0x2b,%al
  800ffd:	75 05                	jne    801004 <strtol+0x39>
		s++;
  800fff:	ff 45 08             	incl   0x8(%ebp)
  801002:	eb 13                	jmp    801017 <strtol+0x4c>
	else if (*s == '-')
  801004:	8b 45 08             	mov    0x8(%ebp),%eax
  801007:	8a 00                	mov    (%eax),%al
  801009:	3c 2d                	cmp    $0x2d,%al
  80100b:	75 0a                	jne    801017 <strtol+0x4c>
		s++, neg = 1;
  80100d:	ff 45 08             	incl   0x8(%ebp)
  801010:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801017:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80101b:	74 06                	je     801023 <strtol+0x58>
  80101d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801021:	75 20                	jne    801043 <strtol+0x78>
  801023:	8b 45 08             	mov    0x8(%ebp),%eax
  801026:	8a 00                	mov    (%eax),%al
  801028:	3c 30                	cmp    $0x30,%al
  80102a:	75 17                	jne    801043 <strtol+0x78>
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	40                   	inc    %eax
  801030:	8a 00                	mov    (%eax),%al
  801032:	3c 78                	cmp    $0x78,%al
  801034:	75 0d                	jne    801043 <strtol+0x78>
		s += 2, base = 16;
  801036:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80103a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801041:	eb 28                	jmp    80106b <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801043:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801047:	75 15                	jne    80105e <strtol+0x93>
  801049:	8b 45 08             	mov    0x8(%ebp),%eax
  80104c:	8a 00                	mov    (%eax),%al
  80104e:	3c 30                	cmp    $0x30,%al
  801050:	75 0c                	jne    80105e <strtol+0x93>
		s++, base = 8;
  801052:	ff 45 08             	incl   0x8(%ebp)
  801055:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80105c:	eb 0d                	jmp    80106b <strtol+0xa0>
	else if (base == 0)
  80105e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801062:	75 07                	jne    80106b <strtol+0xa0>
		base = 10;
  801064:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80106b:	8b 45 08             	mov    0x8(%ebp),%eax
  80106e:	8a 00                	mov    (%eax),%al
  801070:	3c 2f                	cmp    $0x2f,%al
  801072:	7e 19                	jle    80108d <strtol+0xc2>
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	8a 00                	mov    (%eax),%al
  801079:	3c 39                	cmp    $0x39,%al
  80107b:	7f 10                	jg     80108d <strtol+0xc2>
			dig = *s - '0';
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
  801080:	8a 00                	mov    (%eax),%al
  801082:	0f be c0             	movsbl %al,%eax
  801085:	83 e8 30             	sub    $0x30,%eax
  801088:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80108b:	eb 42                	jmp    8010cf <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
  801090:	8a 00                	mov    (%eax),%al
  801092:	3c 60                	cmp    $0x60,%al
  801094:	7e 19                	jle    8010af <strtol+0xe4>
  801096:	8b 45 08             	mov    0x8(%ebp),%eax
  801099:	8a 00                	mov    (%eax),%al
  80109b:	3c 7a                	cmp    $0x7a,%al
  80109d:	7f 10                	jg     8010af <strtol+0xe4>
			dig = *s - 'a' + 10;
  80109f:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a2:	8a 00                	mov    (%eax),%al
  8010a4:	0f be c0             	movsbl %al,%eax
  8010a7:	83 e8 57             	sub    $0x57,%eax
  8010aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010ad:	eb 20                	jmp    8010cf <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010af:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b2:	8a 00                	mov    (%eax),%al
  8010b4:	3c 40                	cmp    $0x40,%al
  8010b6:	7e 39                	jle    8010f1 <strtol+0x126>
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bb:	8a 00                	mov    (%eax),%al
  8010bd:	3c 5a                	cmp    $0x5a,%al
  8010bf:	7f 30                	jg     8010f1 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	8a 00                	mov    (%eax),%al
  8010c6:	0f be c0             	movsbl %al,%eax
  8010c9:	83 e8 37             	sub    $0x37,%eax
  8010cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010d2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010d5:	7d 19                	jge    8010f0 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010d7:	ff 45 08             	incl   0x8(%ebp)
  8010da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010dd:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010e1:	89 c2                	mov    %eax,%edx
  8010e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010e6:	01 d0                	add    %edx,%eax
  8010e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010eb:	e9 7b ff ff ff       	jmp    80106b <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010f0:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010f1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010f5:	74 08                	je     8010ff <strtol+0x134>
		*endptr = (char *) s;
  8010f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8010fd:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801103:	74 07                	je     80110c <strtol+0x141>
  801105:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801108:	f7 d8                	neg    %eax
  80110a:	eb 03                	jmp    80110f <strtol+0x144>
  80110c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80110f:	c9                   	leave  
  801110:	c3                   	ret    

00801111 <ltostr>:

void
ltostr(long value, char *str)
{
  801111:	55                   	push   %ebp
  801112:	89 e5                	mov    %esp,%ebp
  801114:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801117:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80111e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801125:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801129:	79 13                	jns    80113e <ltostr+0x2d>
	{
		neg = 1;
  80112b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801132:	8b 45 0c             	mov    0xc(%ebp),%eax
  801135:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801138:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80113b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80113e:	8b 45 08             	mov    0x8(%ebp),%eax
  801141:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801146:	99                   	cltd   
  801147:	f7 f9                	idiv   %ecx
  801149:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80114c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80114f:	8d 50 01             	lea    0x1(%eax),%edx
  801152:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801155:	89 c2                	mov    %eax,%edx
  801157:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115a:	01 d0                	add    %edx,%eax
  80115c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80115f:	83 c2 30             	add    $0x30,%edx
  801162:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801164:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801167:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80116c:	f7 e9                	imul   %ecx
  80116e:	c1 fa 02             	sar    $0x2,%edx
  801171:	89 c8                	mov    %ecx,%eax
  801173:	c1 f8 1f             	sar    $0x1f,%eax
  801176:	29 c2                	sub    %eax,%edx
  801178:	89 d0                	mov    %edx,%eax
  80117a:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80117d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801180:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801185:	f7 e9                	imul   %ecx
  801187:	c1 fa 02             	sar    $0x2,%edx
  80118a:	89 c8                	mov    %ecx,%eax
  80118c:	c1 f8 1f             	sar    $0x1f,%eax
  80118f:	29 c2                	sub    %eax,%edx
  801191:	89 d0                	mov    %edx,%eax
  801193:	c1 e0 02             	shl    $0x2,%eax
  801196:	01 d0                	add    %edx,%eax
  801198:	01 c0                	add    %eax,%eax
  80119a:	29 c1                	sub    %eax,%ecx
  80119c:	89 ca                	mov    %ecx,%edx
  80119e:	85 d2                	test   %edx,%edx
  8011a0:	75 9c                	jne    80113e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ac:	48                   	dec    %eax
  8011ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011b4:	74 3d                	je     8011f3 <ltostr+0xe2>
		start = 1 ;
  8011b6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011bd:	eb 34                	jmp    8011f3 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8011bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c5:	01 d0                	add    %edx,%eax
  8011c7:	8a 00                	mov    (%eax),%al
  8011c9:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d2:	01 c2                	add    %eax,%edx
  8011d4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011da:	01 c8                	add    %ecx,%eax
  8011dc:	8a 00                	mov    (%eax),%al
  8011de:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e6:	01 c2                	add    %eax,%edx
  8011e8:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011eb:	88 02                	mov    %al,(%edx)
		start++ ;
  8011ed:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011f0:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011f6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011f9:	7c c4                	jl     8011bf <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011fb:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801201:	01 d0                	add    %edx,%eax
  801203:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801206:	90                   	nop
  801207:	c9                   	leave  
  801208:	c3                   	ret    

00801209 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801209:	55                   	push   %ebp
  80120a:	89 e5                	mov    %esp,%ebp
  80120c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80120f:	ff 75 08             	pushl  0x8(%ebp)
  801212:	e8 54 fa ff ff       	call   800c6b <strlen>
  801217:	83 c4 04             	add    $0x4,%esp
  80121a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80121d:	ff 75 0c             	pushl  0xc(%ebp)
  801220:	e8 46 fa ff ff       	call   800c6b <strlen>
  801225:	83 c4 04             	add    $0x4,%esp
  801228:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80122b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801232:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801239:	eb 17                	jmp    801252 <strcconcat+0x49>
		final[s] = str1[s] ;
  80123b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80123e:	8b 45 10             	mov    0x10(%ebp),%eax
  801241:	01 c2                	add    %eax,%edx
  801243:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801246:	8b 45 08             	mov    0x8(%ebp),%eax
  801249:	01 c8                	add    %ecx,%eax
  80124b:	8a 00                	mov    (%eax),%al
  80124d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80124f:	ff 45 fc             	incl   -0x4(%ebp)
  801252:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801255:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801258:	7c e1                	jl     80123b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80125a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801261:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801268:	eb 1f                	jmp    801289 <strcconcat+0x80>
		final[s++] = str2[i] ;
  80126a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80126d:	8d 50 01             	lea    0x1(%eax),%edx
  801270:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801273:	89 c2                	mov    %eax,%edx
  801275:	8b 45 10             	mov    0x10(%ebp),%eax
  801278:	01 c2                	add    %eax,%edx
  80127a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80127d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801280:	01 c8                	add    %ecx,%eax
  801282:	8a 00                	mov    (%eax),%al
  801284:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801286:	ff 45 f8             	incl   -0x8(%ebp)
  801289:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80128c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80128f:	7c d9                	jl     80126a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801291:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801294:	8b 45 10             	mov    0x10(%ebp),%eax
  801297:	01 d0                	add    %edx,%eax
  801299:	c6 00 00             	movb   $0x0,(%eax)
}
  80129c:	90                   	nop
  80129d:	c9                   	leave  
  80129e:	c3                   	ret    

0080129f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80129f:	55                   	push   %ebp
  8012a0:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ae:	8b 00                	mov    (%eax),%eax
  8012b0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ba:	01 d0                	add    %edx,%eax
  8012bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012c2:	eb 0c                	jmp    8012d0 <strsplit+0x31>
			*string++ = 0;
  8012c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c7:	8d 50 01             	lea    0x1(%eax),%edx
  8012ca:	89 55 08             	mov    %edx,0x8(%ebp)
  8012cd:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d3:	8a 00                	mov    (%eax),%al
  8012d5:	84 c0                	test   %al,%al
  8012d7:	74 18                	je     8012f1 <strsplit+0x52>
  8012d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dc:	8a 00                	mov    (%eax),%al
  8012de:	0f be c0             	movsbl %al,%eax
  8012e1:	50                   	push   %eax
  8012e2:	ff 75 0c             	pushl  0xc(%ebp)
  8012e5:	e8 13 fb ff ff       	call   800dfd <strchr>
  8012ea:	83 c4 08             	add    $0x8,%esp
  8012ed:	85 c0                	test   %eax,%eax
  8012ef:	75 d3                	jne    8012c4 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f4:	8a 00                	mov    (%eax),%al
  8012f6:	84 c0                	test   %al,%al
  8012f8:	74 5a                	je     801354 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8012fd:	8b 00                	mov    (%eax),%eax
  8012ff:	83 f8 0f             	cmp    $0xf,%eax
  801302:	75 07                	jne    80130b <strsplit+0x6c>
		{
			return 0;
  801304:	b8 00 00 00 00       	mov    $0x0,%eax
  801309:	eb 66                	jmp    801371 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80130b:	8b 45 14             	mov    0x14(%ebp),%eax
  80130e:	8b 00                	mov    (%eax),%eax
  801310:	8d 48 01             	lea    0x1(%eax),%ecx
  801313:	8b 55 14             	mov    0x14(%ebp),%edx
  801316:	89 0a                	mov    %ecx,(%edx)
  801318:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80131f:	8b 45 10             	mov    0x10(%ebp),%eax
  801322:	01 c2                	add    %eax,%edx
  801324:	8b 45 08             	mov    0x8(%ebp),%eax
  801327:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801329:	eb 03                	jmp    80132e <strsplit+0x8f>
			string++;
  80132b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80132e:	8b 45 08             	mov    0x8(%ebp),%eax
  801331:	8a 00                	mov    (%eax),%al
  801333:	84 c0                	test   %al,%al
  801335:	74 8b                	je     8012c2 <strsplit+0x23>
  801337:	8b 45 08             	mov    0x8(%ebp),%eax
  80133a:	8a 00                	mov    (%eax),%al
  80133c:	0f be c0             	movsbl %al,%eax
  80133f:	50                   	push   %eax
  801340:	ff 75 0c             	pushl  0xc(%ebp)
  801343:	e8 b5 fa ff ff       	call   800dfd <strchr>
  801348:	83 c4 08             	add    $0x8,%esp
  80134b:	85 c0                	test   %eax,%eax
  80134d:	74 dc                	je     80132b <strsplit+0x8c>
			string++;
	}
  80134f:	e9 6e ff ff ff       	jmp    8012c2 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801354:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801355:	8b 45 14             	mov    0x14(%ebp),%eax
  801358:	8b 00                	mov    (%eax),%eax
  80135a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801361:	8b 45 10             	mov    0x10(%ebp),%eax
  801364:	01 d0                	add    %edx,%eax
  801366:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80136c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801371:	c9                   	leave  
  801372:	c3                   	ret    

00801373 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801373:	55                   	push   %ebp
  801374:	89 e5                	mov    %esp,%ebp
  801376:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801379:	a1 04 40 80 00       	mov    0x804004,%eax
  80137e:	85 c0                	test   %eax,%eax
  801380:	74 1f                	je     8013a1 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801382:	e8 1d 00 00 00       	call   8013a4 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801387:	83 ec 0c             	sub    $0xc,%esp
  80138a:	68 30 3a 80 00       	push   $0x803a30
  80138f:	e8 55 f2 ff ff       	call   8005e9 <cprintf>
  801394:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801397:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80139e:	00 00 00 
	}
}
  8013a1:	90                   	nop
  8013a2:	c9                   	leave  
  8013a3:	c3                   	ret    

008013a4 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8013a4:	55                   	push   %ebp
  8013a5:	89 e5                	mov    %esp,%ebp
  8013a7:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  8013aa:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8013b1:	00 00 00 
  8013b4:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  8013bb:	00 00 00 
  8013be:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  8013c5:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  8013c8:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8013cf:	00 00 00 
  8013d2:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  8013d9:	00 00 00 
  8013dc:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  8013e3:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  8013e6:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8013ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013f0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013f5:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013fa:	a3 50 40 80 00       	mov    %eax,0x804050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  8013ff:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801406:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  801409:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801410:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801413:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  801418:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80141b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80141e:	ba 00 00 00 00       	mov    $0x0,%edx
  801423:	f7 75 f0             	divl   -0x10(%ebp)
  801426:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801429:	29 d0                	sub    %edx,%eax
  80142b:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  80142e:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801435:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801438:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80143d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801442:	83 ec 04             	sub    $0x4,%esp
  801445:	6a 06                	push   $0x6
  801447:	ff 75 e8             	pushl  -0x18(%ebp)
  80144a:	50                   	push   %eax
  80144b:	e8 d4 05 00 00       	call   801a24 <sys_allocate_chunk>
  801450:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801453:	a1 20 41 80 00       	mov    0x804120,%eax
  801458:	83 ec 0c             	sub    $0xc,%esp
  80145b:	50                   	push   %eax
  80145c:	e8 49 0c 00 00       	call   8020aa <initialize_MemBlocksList>
  801461:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  801464:	a1 48 41 80 00       	mov    0x804148,%eax
  801469:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  80146c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801470:	75 14                	jne    801486 <initialize_dyn_block_system+0xe2>
  801472:	83 ec 04             	sub    $0x4,%esp
  801475:	68 55 3a 80 00       	push   $0x803a55
  80147a:	6a 39                	push   $0x39
  80147c:	68 73 3a 80 00       	push   $0x803a73
  801481:	e8 af ee ff ff       	call   800335 <_panic>
  801486:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801489:	8b 00                	mov    (%eax),%eax
  80148b:	85 c0                	test   %eax,%eax
  80148d:	74 10                	je     80149f <initialize_dyn_block_system+0xfb>
  80148f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801492:	8b 00                	mov    (%eax),%eax
  801494:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801497:	8b 52 04             	mov    0x4(%edx),%edx
  80149a:	89 50 04             	mov    %edx,0x4(%eax)
  80149d:	eb 0b                	jmp    8014aa <initialize_dyn_block_system+0x106>
  80149f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014a2:	8b 40 04             	mov    0x4(%eax),%eax
  8014a5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8014aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014ad:	8b 40 04             	mov    0x4(%eax),%eax
  8014b0:	85 c0                	test   %eax,%eax
  8014b2:	74 0f                	je     8014c3 <initialize_dyn_block_system+0x11f>
  8014b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014b7:	8b 40 04             	mov    0x4(%eax),%eax
  8014ba:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014bd:	8b 12                	mov    (%edx),%edx
  8014bf:	89 10                	mov    %edx,(%eax)
  8014c1:	eb 0a                	jmp    8014cd <initialize_dyn_block_system+0x129>
  8014c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014c6:	8b 00                	mov    (%eax),%eax
  8014c8:	a3 48 41 80 00       	mov    %eax,0x804148
  8014cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8014d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014e0:	a1 54 41 80 00       	mov    0x804154,%eax
  8014e5:	48                   	dec    %eax
  8014e6:	a3 54 41 80 00       	mov    %eax,0x804154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  8014eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014ee:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  8014f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014f8:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  8014ff:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801503:	75 14                	jne    801519 <initialize_dyn_block_system+0x175>
  801505:	83 ec 04             	sub    $0x4,%esp
  801508:	68 80 3a 80 00       	push   $0x803a80
  80150d:	6a 3f                	push   $0x3f
  80150f:	68 73 3a 80 00       	push   $0x803a73
  801514:	e8 1c ee ff ff       	call   800335 <_panic>
  801519:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80151f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801522:	89 10                	mov    %edx,(%eax)
  801524:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801527:	8b 00                	mov    (%eax),%eax
  801529:	85 c0                	test   %eax,%eax
  80152b:	74 0d                	je     80153a <initialize_dyn_block_system+0x196>
  80152d:	a1 38 41 80 00       	mov    0x804138,%eax
  801532:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801535:	89 50 04             	mov    %edx,0x4(%eax)
  801538:	eb 08                	jmp    801542 <initialize_dyn_block_system+0x19e>
  80153a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80153d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  801542:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801545:	a3 38 41 80 00       	mov    %eax,0x804138
  80154a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80154d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801554:	a1 44 41 80 00       	mov    0x804144,%eax
  801559:	40                   	inc    %eax
  80155a:	a3 44 41 80 00       	mov    %eax,0x804144

}
  80155f:	90                   	nop
  801560:	c9                   	leave  
  801561:	c3                   	ret    

00801562 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801562:	55                   	push   %ebp
  801563:	89 e5                	mov    %esp,%ebp
  801565:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801568:	e8 06 fe ff ff       	call   801373 <InitializeUHeap>
	if (size == 0) return NULL ;
  80156d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801571:	75 07                	jne    80157a <malloc+0x18>
  801573:	b8 00 00 00 00       	mov    $0x0,%eax
  801578:	eb 7d                	jmp    8015f7 <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  80157a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801581:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801588:	8b 55 08             	mov    0x8(%ebp),%edx
  80158b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80158e:	01 d0                	add    %edx,%eax
  801590:	48                   	dec    %eax
  801591:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801594:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801597:	ba 00 00 00 00       	mov    $0x0,%edx
  80159c:	f7 75 f0             	divl   -0x10(%ebp)
  80159f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015a2:	29 d0                	sub    %edx,%eax
  8015a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  8015a7:	e8 46 08 00 00       	call   801df2 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015ac:	83 f8 01             	cmp    $0x1,%eax
  8015af:	75 07                	jne    8015b8 <malloc+0x56>
  8015b1:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  8015b8:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  8015bc:	75 34                	jne    8015f2 <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  8015be:	83 ec 0c             	sub    $0xc,%esp
  8015c1:	ff 75 e8             	pushl  -0x18(%ebp)
  8015c4:	e8 73 0e 00 00       	call   80243c <alloc_block_FF>
  8015c9:	83 c4 10             	add    $0x10,%esp
  8015cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  8015cf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8015d3:	74 16                	je     8015eb <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  8015d5:	83 ec 0c             	sub    $0xc,%esp
  8015d8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015db:	e8 ff 0b 00 00       	call   8021df <insert_sorted_allocList>
  8015e0:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  8015e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015e6:	8b 40 08             	mov    0x8(%eax),%eax
  8015e9:	eb 0c                	jmp    8015f7 <malloc+0x95>
	             }
	             else
	             	return NULL;
  8015eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8015f0:	eb 05                	jmp    8015f7 <malloc+0x95>
	      	  }
	          else
	               return NULL;
  8015f2:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  8015f7:	c9                   	leave  
  8015f8:	c3                   	ret    

008015f9 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8015f9:	55                   	push   %ebp
  8015fa:	89 e5                	mov    %esp,%ebp
  8015fc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  8015ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801602:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  801605:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801608:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80160b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80160e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801613:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  801616:	83 ec 08             	sub    $0x8,%esp
  801619:	ff 75 f4             	pushl  -0xc(%ebp)
  80161c:	68 40 40 80 00       	push   $0x804040
  801621:	e8 61 0b 00 00       	call   802187 <find_block>
  801626:	83 c4 10             	add    $0x10,%esp
  801629:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  80162c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801630:	0f 84 a5 00 00 00    	je     8016db <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  801636:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801639:	8b 40 0c             	mov    0xc(%eax),%eax
  80163c:	83 ec 08             	sub    $0x8,%esp
  80163f:	50                   	push   %eax
  801640:	ff 75 f4             	pushl  -0xc(%ebp)
  801643:	e8 a4 03 00 00       	call   8019ec <sys_free_user_mem>
  801648:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  80164b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80164f:	75 17                	jne    801668 <free+0x6f>
  801651:	83 ec 04             	sub    $0x4,%esp
  801654:	68 55 3a 80 00       	push   $0x803a55
  801659:	68 87 00 00 00       	push   $0x87
  80165e:	68 73 3a 80 00       	push   $0x803a73
  801663:	e8 cd ec ff ff       	call   800335 <_panic>
  801668:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80166b:	8b 00                	mov    (%eax),%eax
  80166d:	85 c0                	test   %eax,%eax
  80166f:	74 10                	je     801681 <free+0x88>
  801671:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801674:	8b 00                	mov    (%eax),%eax
  801676:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801679:	8b 52 04             	mov    0x4(%edx),%edx
  80167c:	89 50 04             	mov    %edx,0x4(%eax)
  80167f:	eb 0b                	jmp    80168c <free+0x93>
  801681:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801684:	8b 40 04             	mov    0x4(%eax),%eax
  801687:	a3 44 40 80 00       	mov    %eax,0x804044
  80168c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80168f:	8b 40 04             	mov    0x4(%eax),%eax
  801692:	85 c0                	test   %eax,%eax
  801694:	74 0f                	je     8016a5 <free+0xac>
  801696:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801699:	8b 40 04             	mov    0x4(%eax),%eax
  80169c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80169f:	8b 12                	mov    (%edx),%edx
  8016a1:	89 10                	mov    %edx,(%eax)
  8016a3:	eb 0a                	jmp    8016af <free+0xb6>
  8016a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016a8:	8b 00                	mov    (%eax),%eax
  8016aa:	a3 40 40 80 00       	mov    %eax,0x804040
  8016af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8016b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016c2:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8016c7:	48                   	dec    %eax
  8016c8:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(theBlock);
  8016cd:	83 ec 0c             	sub    $0xc,%esp
  8016d0:	ff 75 ec             	pushl  -0x14(%ebp)
  8016d3:	e8 37 12 00 00       	call   80290f <insert_sorted_with_merge_freeList>
  8016d8:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  8016db:	90                   	nop
  8016dc:	c9                   	leave  
  8016dd:	c3                   	ret    

008016de <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
  8016e1:	83 ec 38             	sub    $0x38,%esp
  8016e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e7:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016ea:	e8 84 fc ff ff       	call   801373 <InitializeUHeap>
	if (size == 0) return NULL ;
  8016ef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016f3:	75 07                	jne    8016fc <smalloc+0x1e>
  8016f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8016fa:	eb 7e                	jmp    80177a <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  8016fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801703:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80170a:	8b 55 0c             	mov    0xc(%ebp),%edx
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

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801729:	e8 c4 06 00 00       	call   801df2 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80172e:	83 f8 01             	cmp    $0x1,%eax
  801731:	75 42                	jne    801775 <smalloc+0x97>

		  va = malloc(newsize) ;
  801733:	83 ec 0c             	sub    $0xc,%esp
  801736:	ff 75 e8             	pushl  -0x18(%ebp)
  801739:	e8 24 fe ff ff       	call   801562 <malloc>
  80173e:	83 c4 10             	add    $0x10,%esp
  801741:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  801744:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801748:	74 24                	je     80176e <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  80174a:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80174e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801751:	50                   	push   %eax
  801752:	ff 75 e8             	pushl  -0x18(%ebp)
  801755:	ff 75 08             	pushl  0x8(%ebp)
  801758:	e8 1a 04 00 00       	call   801b77 <sys_createSharedObject>
  80175d:	83 c4 10             	add    $0x10,%esp
  801760:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  801763:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801767:	78 0c                	js     801775 <smalloc+0x97>
					  return va ;
  801769:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80176c:	eb 0c                	jmp    80177a <smalloc+0x9c>
				 }
				 else
					return NULL;
  80176e:	b8 00 00 00 00       	mov    $0x0,%eax
  801773:	eb 05                	jmp    80177a <smalloc+0x9c>
	  }
		  return NULL ;
  801775:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80177a:	c9                   	leave  
  80177b:	c3                   	ret    

0080177c <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80177c:	55                   	push   %ebp
  80177d:	89 e5                	mov    %esp,%ebp
  80177f:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801782:	e8 ec fb ff ff       	call   801373 <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  801787:	83 ec 08             	sub    $0x8,%esp
  80178a:	ff 75 0c             	pushl  0xc(%ebp)
  80178d:	ff 75 08             	pushl  0x8(%ebp)
  801790:	e8 0c 04 00 00       	call   801ba1 <sys_getSizeOfSharedObject>
  801795:	83 c4 10             	add    $0x10,%esp
  801798:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  80179b:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  80179f:	75 07                	jne    8017a8 <sget+0x2c>
  8017a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a6:	eb 75                	jmp    80181d <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8017a8:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b5:	01 d0                	add    %edx,%eax
  8017b7:	48                   	dec    %eax
  8017b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017be:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c3:	f7 75 f0             	divl   -0x10(%ebp)
  8017c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017c9:	29 d0                	sub    %edx,%eax
  8017cb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  8017ce:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  8017d5:	e8 18 06 00 00       	call   801df2 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017da:	83 f8 01             	cmp    $0x1,%eax
  8017dd:	75 39                	jne    801818 <sget+0x9c>

		  va = malloc(newsize) ;
  8017df:	83 ec 0c             	sub    $0xc,%esp
  8017e2:	ff 75 e8             	pushl  -0x18(%ebp)
  8017e5:	e8 78 fd ff ff       	call   801562 <malloc>
  8017ea:	83 c4 10             	add    $0x10,%esp
  8017ed:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  8017f0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8017f4:	74 22                	je     801818 <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  8017f6:	83 ec 04             	sub    $0x4,%esp
  8017f9:	ff 75 e0             	pushl  -0x20(%ebp)
  8017fc:	ff 75 0c             	pushl  0xc(%ebp)
  8017ff:	ff 75 08             	pushl  0x8(%ebp)
  801802:	e8 b7 03 00 00       	call   801bbe <sys_getSharedObject>
  801807:	83 c4 10             	add    $0x10,%esp
  80180a:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  80180d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801811:	78 05                	js     801818 <sget+0x9c>
					  return va;
  801813:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801816:	eb 05                	jmp    80181d <sget+0xa1>
				  }
			  }
     }
         return NULL;
  801818:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  80181d:	c9                   	leave  
  80181e:	c3                   	ret    

0080181f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80181f:	55                   	push   %ebp
  801820:	89 e5                	mov    %esp,%ebp
  801822:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801825:	e8 49 fb ff ff       	call   801373 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80182a:	83 ec 04             	sub    $0x4,%esp
  80182d:	68 a4 3a 80 00       	push   $0x803aa4
  801832:	68 1e 01 00 00       	push   $0x11e
  801837:	68 73 3a 80 00       	push   $0x803a73
  80183c:	e8 f4 ea ff ff       	call   800335 <_panic>

00801841 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801841:	55                   	push   %ebp
  801842:	89 e5                	mov    %esp,%ebp
  801844:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801847:	83 ec 04             	sub    $0x4,%esp
  80184a:	68 cc 3a 80 00       	push   $0x803acc
  80184f:	68 32 01 00 00       	push   $0x132
  801854:	68 73 3a 80 00       	push   $0x803a73
  801859:	e8 d7 ea ff ff       	call   800335 <_panic>

0080185e <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80185e:	55                   	push   %ebp
  80185f:	89 e5                	mov    %esp,%ebp
  801861:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801864:	83 ec 04             	sub    $0x4,%esp
  801867:	68 f0 3a 80 00       	push   $0x803af0
  80186c:	68 3d 01 00 00       	push   $0x13d
  801871:	68 73 3a 80 00       	push   $0x803a73
  801876:	e8 ba ea ff ff       	call   800335 <_panic>

0080187b <shrink>:

}
void shrink(uint32 newSize)
{
  80187b:	55                   	push   %ebp
  80187c:	89 e5                	mov    %esp,%ebp
  80187e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801881:	83 ec 04             	sub    $0x4,%esp
  801884:	68 f0 3a 80 00       	push   $0x803af0
  801889:	68 42 01 00 00       	push   $0x142
  80188e:	68 73 3a 80 00       	push   $0x803a73
  801893:	e8 9d ea ff ff       	call   800335 <_panic>

00801898 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801898:	55                   	push   %ebp
  801899:	89 e5                	mov    %esp,%ebp
  80189b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80189e:	83 ec 04             	sub    $0x4,%esp
  8018a1:	68 f0 3a 80 00       	push   $0x803af0
  8018a6:	68 47 01 00 00       	push   $0x147
  8018ab:	68 73 3a 80 00       	push   $0x803a73
  8018b0:	e8 80 ea ff ff       	call   800335 <_panic>

008018b5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018b5:	55                   	push   %ebp
  8018b6:	89 e5                	mov    %esp,%ebp
  8018b8:	57                   	push   %edi
  8018b9:	56                   	push   %esi
  8018ba:	53                   	push   %ebx
  8018bb:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018be:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018c7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018ca:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018cd:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018d0:	cd 30                	int    $0x30
  8018d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018d8:	83 c4 10             	add    $0x10,%esp
  8018db:	5b                   	pop    %ebx
  8018dc:	5e                   	pop    %esi
  8018dd:	5f                   	pop    %edi
  8018de:	5d                   	pop    %ebp
  8018df:	c3                   	ret    

008018e0 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
  8018e3:	83 ec 04             	sub    $0x4,%esp
  8018e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018ec:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	52                   	push   %edx
  8018f8:	ff 75 0c             	pushl  0xc(%ebp)
  8018fb:	50                   	push   %eax
  8018fc:	6a 00                	push   $0x0
  8018fe:	e8 b2 ff ff ff       	call   8018b5 <syscall>
  801903:	83 c4 18             	add    $0x18,%esp
}
  801906:	90                   	nop
  801907:	c9                   	leave  
  801908:	c3                   	ret    

00801909 <sys_cgetc>:

int
sys_cgetc(void)
{
  801909:	55                   	push   %ebp
  80190a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 01                	push   $0x1
  801918:	e8 98 ff ff ff       	call   8018b5 <syscall>
  80191d:	83 c4 18             	add    $0x18,%esp
}
  801920:	c9                   	leave  
  801921:	c3                   	ret    

00801922 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801922:	55                   	push   %ebp
  801923:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801925:	8b 55 0c             	mov    0xc(%ebp),%edx
  801928:	8b 45 08             	mov    0x8(%ebp),%eax
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	52                   	push   %edx
  801932:	50                   	push   %eax
  801933:	6a 05                	push   $0x5
  801935:	e8 7b ff ff ff       	call   8018b5 <syscall>
  80193a:	83 c4 18             	add    $0x18,%esp
}
  80193d:	c9                   	leave  
  80193e:	c3                   	ret    

0080193f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80193f:	55                   	push   %ebp
  801940:	89 e5                	mov    %esp,%ebp
  801942:	56                   	push   %esi
  801943:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801944:	8b 75 18             	mov    0x18(%ebp),%esi
  801947:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80194a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80194d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801950:	8b 45 08             	mov    0x8(%ebp),%eax
  801953:	56                   	push   %esi
  801954:	53                   	push   %ebx
  801955:	51                   	push   %ecx
  801956:	52                   	push   %edx
  801957:	50                   	push   %eax
  801958:	6a 06                	push   $0x6
  80195a:	e8 56 ff ff ff       	call   8018b5 <syscall>
  80195f:	83 c4 18             	add    $0x18,%esp
}
  801962:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801965:	5b                   	pop    %ebx
  801966:	5e                   	pop    %esi
  801967:	5d                   	pop    %ebp
  801968:	c3                   	ret    

00801969 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80196c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196f:	8b 45 08             	mov    0x8(%ebp),%eax
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	52                   	push   %edx
  801979:	50                   	push   %eax
  80197a:	6a 07                	push   $0x7
  80197c:	e8 34 ff ff ff       	call   8018b5 <syscall>
  801981:	83 c4 18             	add    $0x18,%esp
}
  801984:	c9                   	leave  
  801985:	c3                   	ret    

00801986 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	ff 75 0c             	pushl  0xc(%ebp)
  801992:	ff 75 08             	pushl  0x8(%ebp)
  801995:	6a 08                	push   $0x8
  801997:	e8 19 ff ff ff       	call   8018b5 <syscall>
  80199c:	83 c4 18             	add    $0x18,%esp
}
  80199f:	c9                   	leave  
  8019a0:	c3                   	ret    

008019a1 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019a1:	55                   	push   %ebp
  8019a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 09                	push   $0x9
  8019b0:	e8 00 ff ff ff       	call   8018b5 <syscall>
  8019b5:	83 c4 18             	add    $0x18,%esp
}
  8019b8:	c9                   	leave  
  8019b9:	c3                   	ret    

008019ba <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 0a                	push   $0xa
  8019c9:	e8 e7 fe ff ff       	call   8018b5 <syscall>
  8019ce:	83 c4 18             	add    $0x18,%esp
}
  8019d1:	c9                   	leave  
  8019d2:	c3                   	ret    

008019d3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019d3:	55                   	push   %ebp
  8019d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 0b                	push   $0xb
  8019e2:	e8 ce fe ff ff       	call   8018b5 <syscall>
  8019e7:	83 c4 18             	add    $0x18,%esp
}
  8019ea:	c9                   	leave  
  8019eb:	c3                   	ret    

008019ec <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019ec:	55                   	push   %ebp
  8019ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	ff 75 0c             	pushl  0xc(%ebp)
  8019f8:	ff 75 08             	pushl  0x8(%ebp)
  8019fb:	6a 0f                	push   $0xf
  8019fd:	e8 b3 fe ff ff       	call   8018b5 <syscall>
  801a02:	83 c4 18             	add    $0x18,%esp
	return;
  801a05:	90                   	nop
}
  801a06:	c9                   	leave  
  801a07:	c3                   	ret    

00801a08 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	ff 75 0c             	pushl  0xc(%ebp)
  801a14:	ff 75 08             	pushl  0x8(%ebp)
  801a17:	6a 10                	push   $0x10
  801a19:	e8 97 fe ff ff       	call   8018b5 <syscall>
  801a1e:	83 c4 18             	add    $0x18,%esp
	return ;
  801a21:	90                   	nop
}
  801a22:	c9                   	leave  
  801a23:	c3                   	ret    

00801a24 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a24:	55                   	push   %ebp
  801a25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	ff 75 10             	pushl  0x10(%ebp)
  801a2e:	ff 75 0c             	pushl  0xc(%ebp)
  801a31:	ff 75 08             	pushl  0x8(%ebp)
  801a34:	6a 11                	push   $0x11
  801a36:	e8 7a fe ff ff       	call   8018b5 <syscall>
  801a3b:	83 c4 18             	add    $0x18,%esp
	return ;
  801a3e:	90                   	nop
}
  801a3f:	c9                   	leave  
  801a40:	c3                   	ret    

00801a41 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a41:	55                   	push   %ebp
  801a42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 0c                	push   $0xc
  801a50:	e8 60 fe ff ff       	call   8018b5 <syscall>
  801a55:	83 c4 18             	add    $0x18,%esp
}
  801a58:	c9                   	leave  
  801a59:	c3                   	ret    

00801a5a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	ff 75 08             	pushl  0x8(%ebp)
  801a68:	6a 0d                	push   $0xd
  801a6a:	e8 46 fe ff ff       	call   8018b5 <syscall>
  801a6f:	83 c4 18             	add    $0x18,%esp
}
  801a72:	c9                   	leave  
  801a73:	c3                   	ret    

00801a74 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a74:	55                   	push   %ebp
  801a75:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 0e                	push   $0xe
  801a83:	e8 2d fe ff ff       	call   8018b5 <syscall>
  801a88:	83 c4 18             	add    $0x18,%esp
}
  801a8b:	90                   	nop
  801a8c:	c9                   	leave  
  801a8d:	c3                   	ret    

00801a8e <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a8e:	55                   	push   %ebp
  801a8f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 13                	push   $0x13
  801a9d:	e8 13 fe ff ff       	call   8018b5 <syscall>
  801aa2:	83 c4 18             	add    $0x18,%esp
}
  801aa5:	90                   	nop
  801aa6:	c9                   	leave  
  801aa7:	c3                   	ret    

00801aa8 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801aa8:	55                   	push   %ebp
  801aa9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 14                	push   $0x14
  801ab7:	e8 f9 fd ff ff       	call   8018b5 <syscall>
  801abc:	83 c4 18             	add    $0x18,%esp
}
  801abf:	90                   	nop
  801ac0:	c9                   	leave  
  801ac1:	c3                   	ret    

00801ac2 <sys_cputc>:


void
sys_cputc(const char c)
{
  801ac2:	55                   	push   %ebp
  801ac3:	89 e5                	mov    %esp,%ebp
  801ac5:	83 ec 04             	sub    $0x4,%esp
  801ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  801acb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ace:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	50                   	push   %eax
  801adb:	6a 15                	push   $0x15
  801add:	e8 d3 fd ff ff       	call   8018b5 <syscall>
  801ae2:	83 c4 18             	add    $0x18,%esp
}
  801ae5:	90                   	nop
  801ae6:	c9                   	leave  
  801ae7:	c3                   	ret    

00801ae8 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ae8:	55                   	push   %ebp
  801ae9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 16                	push   $0x16
  801af7:	e8 b9 fd ff ff       	call   8018b5 <syscall>
  801afc:	83 c4 18             	add    $0x18,%esp
}
  801aff:	90                   	nop
  801b00:	c9                   	leave  
  801b01:	c3                   	ret    

00801b02 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b02:	55                   	push   %ebp
  801b03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b05:	8b 45 08             	mov    0x8(%ebp),%eax
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	ff 75 0c             	pushl  0xc(%ebp)
  801b11:	50                   	push   %eax
  801b12:	6a 17                	push   $0x17
  801b14:	e8 9c fd ff ff       	call   8018b5 <syscall>
  801b19:	83 c4 18             	add    $0x18,%esp
}
  801b1c:	c9                   	leave  
  801b1d:	c3                   	ret    

00801b1e <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b21:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b24:	8b 45 08             	mov    0x8(%ebp),%eax
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	52                   	push   %edx
  801b2e:	50                   	push   %eax
  801b2f:	6a 1a                	push   $0x1a
  801b31:	e8 7f fd ff ff       	call   8018b5 <syscall>
  801b36:	83 c4 18             	add    $0x18,%esp
}
  801b39:	c9                   	leave  
  801b3a:	c3                   	ret    

00801b3b <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b41:	8b 45 08             	mov    0x8(%ebp),%eax
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	52                   	push   %edx
  801b4b:	50                   	push   %eax
  801b4c:	6a 18                	push   $0x18
  801b4e:	e8 62 fd ff ff       	call   8018b5 <syscall>
  801b53:	83 c4 18             	add    $0x18,%esp
}
  801b56:	90                   	nop
  801b57:	c9                   	leave  
  801b58:	c3                   	ret    

00801b59 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	52                   	push   %edx
  801b69:	50                   	push   %eax
  801b6a:	6a 19                	push   $0x19
  801b6c:	e8 44 fd ff ff       	call   8018b5 <syscall>
  801b71:	83 c4 18             	add    $0x18,%esp
}
  801b74:	90                   	nop
  801b75:	c9                   	leave  
  801b76:	c3                   	ret    

00801b77 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
  801b7a:	83 ec 04             	sub    $0x4,%esp
  801b7d:	8b 45 10             	mov    0x10(%ebp),%eax
  801b80:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b83:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b86:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8d:	6a 00                	push   $0x0
  801b8f:	51                   	push   %ecx
  801b90:	52                   	push   %edx
  801b91:	ff 75 0c             	pushl  0xc(%ebp)
  801b94:	50                   	push   %eax
  801b95:	6a 1b                	push   $0x1b
  801b97:	e8 19 fd ff ff       	call   8018b5 <syscall>
  801b9c:	83 c4 18             	add    $0x18,%esp
}
  801b9f:	c9                   	leave  
  801ba0:	c3                   	ret    

00801ba1 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ba4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	52                   	push   %edx
  801bb1:	50                   	push   %eax
  801bb2:	6a 1c                	push   $0x1c
  801bb4:	e8 fc fc ff ff       	call   8018b5 <syscall>
  801bb9:	83 c4 18             	add    $0x18,%esp
}
  801bbc:	c9                   	leave  
  801bbd:	c3                   	ret    

00801bbe <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bbe:	55                   	push   %ebp
  801bbf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bc1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	51                   	push   %ecx
  801bcf:	52                   	push   %edx
  801bd0:	50                   	push   %eax
  801bd1:	6a 1d                	push   $0x1d
  801bd3:	e8 dd fc ff ff       	call   8018b5 <syscall>
  801bd8:	83 c4 18             	add    $0x18,%esp
}
  801bdb:	c9                   	leave  
  801bdc:	c3                   	ret    

00801bdd <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801be0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be3:	8b 45 08             	mov    0x8(%ebp),%eax
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	52                   	push   %edx
  801bed:	50                   	push   %eax
  801bee:	6a 1e                	push   $0x1e
  801bf0:	e8 c0 fc ff ff       	call   8018b5 <syscall>
  801bf5:	83 c4 18             	add    $0x18,%esp
}
  801bf8:	c9                   	leave  
  801bf9:	c3                   	ret    

00801bfa <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801bfa:	55                   	push   %ebp
  801bfb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 1f                	push   $0x1f
  801c09:	e8 a7 fc ff ff       	call   8018b5 <syscall>
  801c0e:	83 c4 18             	add    $0x18,%esp
}
  801c11:	c9                   	leave  
  801c12:	c3                   	ret    

00801c13 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c16:	8b 45 08             	mov    0x8(%ebp),%eax
  801c19:	6a 00                	push   $0x0
  801c1b:	ff 75 14             	pushl  0x14(%ebp)
  801c1e:	ff 75 10             	pushl  0x10(%ebp)
  801c21:	ff 75 0c             	pushl  0xc(%ebp)
  801c24:	50                   	push   %eax
  801c25:	6a 20                	push   $0x20
  801c27:	e8 89 fc ff ff       	call   8018b5 <syscall>
  801c2c:	83 c4 18             	add    $0x18,%esp
}
  801c2f:	c9                   	leave  
  801c30:	c3                   	ret    

00801c31 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c31:	55                   	push   %ebp
  801c32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c34:	8b 45 08             	mov    0x8(%ebp),%eax
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	50                   	push   %eax
  801c40:	6a 21                	push   $0x21
  801c42:	e8 6e fc ff ff       	call   8018b5 <syscall>
  801c47:	83 c4 18             	add    $0x18,%esp
}
  801c4a:	90                   	nop
  801c4b:	c9                   	leave  
  801c4c:	c3                   	ret    

00801c4d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c4d:	55                   	push   %ebp
  801c4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c50:	8b 45 08             	mov    0x8(%ebp),%eax
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	50                   	push   %eax
  801c5c:	6a 22                	push   $0x22
  801c5e:	e8 52 fc ff ff       	call   8018b5 <syscall>
  801c63:	83 c4 18             	add    $0x18,%esp
}
  801c66:	c9                   	leave  
  801c67:	c3                   	ret    

00801c68 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c68:	55                   	push   %ebp
  801c69:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 02                	push   $0x2
  801c77:	e8 39 fc ff ff       	call   8018b5 <syscall>
  801c7c:	83 c4 18             	add    $0x18,%esp
}
  801c7f:	c9                   	leave  
  801c80:	c3                   	ret    

00801c81 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 03                	push   $0x3
  801c90:	e8 20 fc ff ff       	call   8018b5 <syscall>
  801c95:	83 c4 18             	add    $0x18,%esp
}
  801c98:	c9                   	leave  
  801c99:	c3                   	ret    

00801c9a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c9a:	55                   	push   %ebp
  801c9b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 04                	push   $0x4
  801ca9:	e8 07 fc ff ff       	call   8018b5 <syscall>
  801cae:	83 c4 18             	add    $0x18,%esp
}
  801cb1:	c9                   	leave  
  801cb2:	c3                   	ret    

00801cb3 <sys_exit_env>:


void sys_exit_env(void)
{
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 23                	push   $0x23
  801cc2:	e8 ee fb ff ff       	call   8018b5 <syscall>
  801cc7:	83 c4 18             	add    $0x18,%esp
}
  801cca:	90                   	nop
  801ccb:	c9                   	leave  
  801ccc:	c3                   	ret    

00801ccd <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801ccd:	55                   	push   %ebp
  801cce:	89 e5                	mov    %esp,%ebp
  801cd0:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801cd3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cd6:	8d 50 04             	lea    0x4(%eax),%edx
  801cd9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	52                   	push   %edx
  801ce3:	50                   	push   %eax
  801ce4:	6a 24                	push   $0x24
  801ce6:	e8 ca fb ff ff       	call   8018b5 <syscall>
  801ceb:	83 c4 18             	add    $0x18,%esp
	return result;
  801cee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cf1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cf4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cf7:	89 01                	mov    %eax,(%ecx)
  801cf9:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cff:	c9                   	leave  
  801d00:	c2 04 00             	ret    $0x4

00801d03 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d03:	55                   	push   %ebp
  801d04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	ff 75 10             	pushl  0x10(%ebp)
  801d0d:	ff 75 0c             	pushl  0xc(%ebp)
  801d10:	ff 75 08             	pushl  0x8(%ebp)
  801d13:	6a 12                	push   $0x12
  801d15:	e8 9b fb ff ff       	call   8018b5 <syscall>
  801d1a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d1d:	90                   	nop
}
  801d1e:	c9                   	leave  
  801d1f:	c3                   	ret    

00801d20 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d20:	55                   	push   %ebp
  801d21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 25                	push   $0x25
  801d2f:	e8 81 fb ff ff       	call   8018b5 <syscall>
  801d34:	83 c4 18             	add    $0x18,%esp
}
  801d37:	c9                   	leave  
  801d38:	c3                   	ret    

00801d39 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d39:	55                   	push   %ebp
  801d3a:	89 e5                	mov    %esp,%ebp
  801d3c:	83 ec 04             	sub    $0x4,%esp
  801d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d42:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d45:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	50                   	push   %eax
  801d52:	6a 26                	push   $0x26
  801d54:	e8 5c fb ff ff       	call   8018b5 <syscall>
  801d59:	83 c4 18             	add    $0x18,%esp
	return ;
  801d5c:	90                   	nop
}
  801d5d:	c9                   	leave  
  801d5e:	c3                   	ret    

00801d5f <rsttst>:
void rsttst()
{
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 28                	push   $0x28
  801d6e:	e8 42 fb ff ff       	call   8018b5 <syscall>
  801d73:	83 c4 18             	add    $0x18,%esp
	return ;
  801d76:	90                   	nop
}
  801d77:	c9                   	leave  
  801d78:	c3                   	ret    

00801d79 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d79:	55                   	push   %ebp
  801d7a:	89 e5                	mov    %esp,%ebp
  801d7c:	83 ec 04             	sub    $0x4,%esp
  801d7f:	8b 45 14             	mov    0x14(%ebp),%eax
  801d82:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d85:	8b 55 18             	mov    0x18(%ebp),%edx
  801d88:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d8c:	52                   	push   %edx
  801d8d:	50                   	push   %eax
  801d8e:	ff 75 10             	pushl  0x10(%ebp)
  801d91:	ff 75 0c             	pushl  0xc(%ebp)
  801d94:	ff 75 08             	pushl  0x8(%ebp)
  801d97:	6a 27                	push   $0x27
  801d99:	e8 17 fb ff ff       	call   8018b5 <syscall>
  801d9e:	83 c4 18             	add    $0x18,%esp
	return ;
  801da1:	90                   	nop
}
  801da2:	c9                   	leave  
  801da3:	c3                   	ret    

00801da4 <chktst>:
void chktst(uint32 n)
{
  801da4:	55                   	push   %ebp
  801da5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	ff 75 08             	pushl  0x8(%ebp)
  801db2:	6a 29                	push   $0x29
  801db4:	e8 fc fa ff ff       	call   8018b5 <syscall>
  801db9:	83 c4 18             	add    $0x18,%esp
	return ;
  801dbc:	90                   	nop
}
  801dbd:	c9                   	leave  
  801dbe:	c3                   	ret    

00801dbf <inctst>:

void inctst()
{
  801dbf:	55                   	push   %ebp
  801dc0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 2a                	push   $0x2a
  801dce:	e8 e2 fa ff ff       	call   8018b5 <syscall>
  801dd3:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd6:	90                   	nop
}
  801dd7:	c9                   	leave  
  801dd8:	c3                   	ret    

00801dd9 <gettst>:
uint32 gettst()
{
  801dd9:	55                   	push   %ebp
  801dda:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 2b                	push   $0x2b
  801de8:	e8 c8 fa ff ff       	call   8018b5 <syscall>
  801ded:	83 c4 18             	add    $0x18,%esp
}
  801df0:	c9                   	leave  
  801df1:	c3                   	ret    

00801df2 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801df2:	55                   	push   %ebp
  801df3:	89 e5                	mov    %esp,%ebp
  801df5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	6a 2c                	push   $0x2c
  801e04:	e8 ac fa ff ff       	call   8018b5 <syscall>
  801e09:	83 c4 18             	add    $0x18,%esp
  801e0c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e0f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e13:	75 07                	jne    801e1c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e15:	b8 01 00 00 00       	mov    $0x1,%eax
  801e1a:	eb 05                	jmp    801e21 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e21:	c9                   	leave  
  801e22:	c3                   	ret    

00801e23 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e23:	55                   	push   %ebp
  801e24:	89 e5                	mov    %esp,%ebp
  801e26:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	6a 2c                	push   $0x2c
  801e35:	e8 7b fa ff ff       	call   8018b5 <syscall>
  801e3a:	83 c4 18             	add    $0x18,%esp
  801e3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e40:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e44:	75 07                	jne    801e4d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e46:	b8 01 00 00 00       	mov    $0x1,%eax
  801e4b:	eb 05                	jmp    801e52 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e52:	c9                   	leave  
  801e53:	c3                   	ret    

00801e54 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
  801e57:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	6a 2c                	push   $0x2c
  801e66:	e8 4a fa ff ff       	call   8018b5 <syscall>
  801e6b:	83 c4 18             	add    $0x18,%esp
  801e6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e71:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e75:	75 07                	jne    801e7e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e77:	b8 01 00 00 00       	mov    $0x1,%eax
  801e7c:	eb 05                	jmp    801e83 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e83:	c9                   	leave  
  801e84:	c3                   	ret    

00801e85 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e85:	55                   	push   %ebp
  801e86:	89 e5                	mov    %esp,%ebp
  801e88:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 2c                	push   $0x2c
  801e97:	e8 19 fa ff ff       	call   8018b5 <syscall>
  801e9c:	83 c4 18             	add    $0x18,%esp
  801e9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ea2:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ea6:	75 07                	jne    801eaf <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ea8:	b8 01 00 00 00       	mov    $0x1,%eax
  801ead:	eb 05                	jmp    801eb4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801eaf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eb4:	c9                   	leave  
  801eb5:	c3                   	ret    

00801eb6 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801eb6:	55                   	push   %ebp
  801eb7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	6a 00                	push   $0x0
  801ec1:	ff 75 08             	pushl  0x8(%ebp)
  801ec4:	6a 2d                	push   $0x2d
  801ec6:	e8 ea f9 ff ff       	call   8018b5 <syscall>
  801ecb:	83 c4 18             	add    $0x18,%esp
	return ;
  801ece:	90                   	nop
}
  801ecf:	c9                   	leave  
  801ed0:	c3                   	ret    

00801ed1 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ed1:	55                   	push   %ebp
  801ed2:	89 e5                	mov    %esp,%ebp
  801ed4:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ed5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ed8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801edb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ede:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee1:	6a 00                	push   $0x0
  801ee3:	53                   	push   %ebx
  801ee4:	51                   	push   %ecx
  801ee5:	52                   	push   %edx
  801ee6:	50                   	push   %eax
  801ee7:	6a 2e                	push   $0x2e
  801ee9:	e8 c7 f9 ff ff       	call   8018b5 <syscall>
  801eee:	83 c4 18             	add    $0x18,%esp
}
  801ef1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ef4:	c9                   	leave  
  801ef5:	c3                   	ret    

00801ef6 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ef6:	55                   	push   %ebp
  801ef7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ef9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801efc:	8b 45 08             	mov    0x8(%ebp),%eax
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	6a 00                	push   $0x0
  801f05:	52                   	push   %edx
  801f06:	50                   	push   %eax
  801f07:	6a 2f                	push   $0x2f
  801f09:	e8 a7 f9 ff ff       	call   8018b5 <syscall>
  801f0e:	83 c4 18             	add    $0x18,%esp
}
  801f11:	c9                   	leave  
  801f12:	c3                   	ret    

00801f13 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f13:	55                   	push   %ebp
  801f14:	89 e5                	mov    %esp,%ebp
  801f16:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f19:	83 ec 0c             	sub    $0xc,%esp
  801f1c:	68 00 3b 80 00       	push   $0x803b00
  801f21:	e8 c3 e6 ff ff       	call   8005e9 <cprintf>
  801f26:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f29:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f30:	83 ec 0c             	sub    $0xc,%esp
  801f33:	68 2c 3b 80 00       	push   $0x803b2c
  801f38:	e8 ac e6 ff ff       	call   8005e9 <cprintf>
  801f3d:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f40:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f44:	a1 38 41 80 00       	mov    0x804138,%eax
  801f49:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f4c:	eb 56                	jmp    801fa4 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f4e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f52:	74 1c                	je     801f70 <print_mem_block_lists+0x5d>
  801f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f57:	8b 50 08             	mov    0x8(%eax),%edx
  801f5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f5d:	8b 48 08             	mov    0x8(%eax),%ecx
  801f60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f63:	8b 40 0c             	mov    0xc(%eax),%eax
  801f66:	01 c8                	add    %ecx,%eax
  801f68:	39 c2                	cmp    %eax,%edx
  801f6a:	73 04                	jae    801f70 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f6c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f73:	8b 50 08             	mov    0x8(%eax),%edx
  801f76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f79:	8b 40 0c             	mov    0xc(%eax),%eax
  801f7c:	01 c2                	add    %eax,%edx
  801f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f81:	8b 40 08             	mov    0x8(%eax),%eax
  801f84:	83 ec 04             	sub    $0x4,%esp
  801f87:	52                   	push   %edx
  801f88:	50                   	push   %eax
  801f89:	68 41 3b 80 00       	push   $0x803b41
  801f8e:	e8 56 e6 ff ff       	call   8005e9 <cprintf>
  801f93:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f99:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f9c:	a1 40 41 80 00       	mov    0x804140,%eax
  801fa1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fa4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fa8:	74 07                	je     801fb1 <print_mem_block_lists+0x9e>
  801faa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fad:	8b 00                	mov    (%eax),%eax
  801faf:	eb 05                	jmp    801fb6 <print_mem_block_lists+0xa3>
  801fb1:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb6:	a3 40 41 80 00       	mov    %eax,0x804140
  801fbb:	a1 40 41 80 00       	mov    0x804140,%eax
  801fc0:	85 c0                	test   %eax,%eax
  801fc2:	75 8a                	jne    801f4e <print_mem_block_lists+0x3b>
  801fc4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fc8:	75 84                	jne    801f4e <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801fca:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fce:	75 10                	jne    801fe0 <print_mem_block_lists+0xcd>
  801fd0:	83 ec 0c             	sub    $0xc,%esp
  801fd3:	68 50 3b 80 00       	push   $0x803b50
  801fd8:	e8 0c e6 ff ff       	call   8005e9 <cprintf>
  801fdd:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801fe0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801fe7:	83 ec 0c             	sub    $0xc,%esp
  801fea:	68 74 3b 80 00       	push   $0x803b74
  801fef:	e8 f5 e5 ff ff       	call   8005e9 <cprintf>
  801ff4:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801ff7:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ffb:	a1 40 40 80 00       	mov    0x804040,%eax
  802000:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802003:	eb 56                	jmp    80205b <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802005:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802009:	74 1c                	je     802027 <print_mem_block_lists+0x114>
  80200b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200e:	8b 50 08             	mov    0x8(%eax),%edx
  802011:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802014:	8b 48 08             	mov    0x8(%eax),%ecx
  802017:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80201a:	8b 40 0c             	mov    0xc(%eax),%eax
  80201d:	01 c8                	add    %ecx,%eax
  80201f:	39 c2                	cmp    %eax,%edx
  802021:	73 04                	jae    802027 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802023:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802027:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202a:	8b 50 08             	mov    0x8(%eax),%edx
  80202d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802030:	8b 40 0c             	mov    0xc(%eax),%eax
  802033:	01 c2                	add    %eax,%edx
  802035:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802038:	8b 40 08             	mov    0x8(%eax),%eax
  80203b:	83 ec 04             	sub    $0x4,%esp
  80203e:	52                   	push   %edx
  80203f:	50                   	push   %eax
  802040:	68 41 3b 80 00       	push   $0x803b41
  802045:	e8 9f e5 ff ff       	call   8005e9 <cprintf>
  80204a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80204d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802050:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802053:	a1 48 40 80 00       	mov    0x804048,%eax
  802058:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80205b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80205f:	74 07                	je     802068 <print_mem_block_lists+0x155>
  802061:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802064:	8b 00                	mov    (%eax),%eax
  802066:	eb 05                	jmp    80206d <print_mem_block_lists+0x15a>
  802068:	b8 00 00 00 00       	mov    $0x0,%eax
  80206d:	a3 48 40 80 00       	mov    %eax,0x804048
  802072:	a1 48 40 80 00       	mov    0x804048,%eax
  802077:	85 c0                	test   %eax,%eax
  802079:	75 8a                	jne    802005 <print_mem_block_lists+0xf2>
  80207b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80207f:	75 84                	jne    802005 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802081:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802085:	75 10                	jne    802097 <print_mem_block_lists+0x184>
  802087:	83 ec 0c             	sub    $0xc,%esp
  80208a:	68 8c 3b 80 00       	push   $0x803b8c
  80208f:	e8 55 e5 ff ff       	call   8005e9 <cprintf>
  802094:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802097:	83 ec 0c             	sub    $0xc,%esp
  80209a:	68 00 3b 80 00       	push   $0x803b00
  80209f:	e8 45 e5 ff ff       	call   8005e9 <cprintf>
  8020a4:	83 c4 10             	add    $0x10,%esp

}
  8020a7:	90                   	nop
  8020a8:	c9                   	leave  
  8020a9:	c3                   	ret    

008020aa <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8020aa:	55                   	push   %ebp
  8020ab:	89 e5                	mov    %esp,%ebp
  8020ad:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  8020b0:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  8020b7:	00 00 00 
  8020ba:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  8020c1:	00 00 00 
  8020c4:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  8020cb:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  8020ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8020d5:	e9 9e 00 00 00       	jmp    802178 <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  8020da:	a1 50 40 80 00       	mov    0x804050,%eax
  8020df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020e2:	c1 e2 04             	shl    $0x4,%edx
  8020e5:	01 d0                	add    %edx,%eax
  8020e7:	85 c0                	test   %eax,%eax
  8020e9:	75 14                	jne    8020ff <initialize_MemBlocksList+0x55>
  8020eb:	83 ec 04             	sub    $0x4,%esp
  8020ee:	68 b4 3b 80 00       	push   $0x803bb4
  8020f3:	6a 47                	push   $0x47
  8020f5:	68 d7 3b 80 00       	push   $0x803bd7
  8020fa:	e8 36 e2 ff ff       	call   800335 <_panic>
  8020ff:	a1 50 40 80 00       	mov    0x804050,%eax
  802104:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802107:	c1 e2 04             	shl    $0x4,%edx
  80210a:	01 d0                	add    %edx,%eax
  80210c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802112:	89 10                	mov    %edx,(%eax)
  802114:	8b 00                	mov    (%eax),%eax
  802116:	85 c0                	test   %eax,%eax
  802118:	74 18                	je     802132 <initialize_MemBlocksList+0x88>
  80211a:	a1 48 41 80 00       	mov    0x804148,%eax
  80211f:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802125:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802128:	c1 e1 04             	shl    $0x4,%ecx
  80212b:	01 ca                	add    %ecx,%edx
  80212d:	89 50 04             	mov    %edx,0x4(%eax)
  802130:	eb 12                	jmp    802144 <initialize_MemBlocksList+0x9a>
  802132:	a1 50 40 80 00       	mov    0x804050,%eax
  802137:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80213a:	c1 e2 04             	shl    $0x4,%edx
  80213d:	01 d0                	add    %edx,%eax
  80213f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802144:	a1 50 40 80 00       	mov    0x804050,%eax
  802149:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80214c:	c1 e2 04             	shl    $0x4,%edx
  80214f:	01 d0                	add    %edx,%eax
  802151:	a3 48 41 80 00       	mov    %eax,0x804148
  802156:	a1 50 40 80 00       	mov    0x804050,%eax
  80215b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80215e:	c1 e2 04             	shl    $0x4,%edx
  802161:	01 d0                	add    %edx,%eax
  802163:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80216a:	a1 54 41 80 00       	mov    0x804154,%eax
  80216f:	40                   	inc    %eax
  802170:	a3 54 41 80 00       	mov    %eax,0x804154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802175:	ff 45 f4             	incl   -0xc(%ebp)
  802178:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80217e:	0f 82 56 ff ff ff    	jb     8020da <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  802184:	90                   	nop
  802185:	c9                   	leave  
  802186:	c3                   	ret    

00802187 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802187:	55                   	push   %ebp
  802188:	89 e5                	mov    %esp,%ebp
  80218a:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  80218d:	8b 45 08             	mov    0x8(%ebp),%eax
  802190:	8b 00                	mov    (%eax),%eax
  802192:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802195:	eb 19                	jmp    8021b0 <find_block+0x29>
	{
		if(element->sva == va){
  802197:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80219a:	8b 40 08             	mov    0x8(%eax),%eax
  80219d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8021a0:	75 05                	jne    8021a7 <find_block+0x20>
			 		return element;
  8021a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021a5:	eb 36                	jmp    8021dd <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  8021a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021aa:	8b 40 08             	mov    0x8(%eax),%eax
  8021ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021b4:	74 07                	je     8021bd <find_block+0x36>
  8021b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021b9:	8b 00                	mov    (%eax),%eax
  8021bb:	eb 05                	jmp    8021c2 <find_block+0x3b>
  8021bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8021c5:	89 42 08             	mov    %eax,0x8(%edx)
  8021c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cb:	8b 40 08             	mov    0x8(%eax),%eax
  8021ce:	85 c0                	test   %eax,%eax
  8021d0:	75 c5                	jne    802197 <find_block+0x10>
  8021d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021d6:	75 bf                	jne    802197 <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  8021d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021dd:	c9                   	leave  
  8021de:	c3                   	ret    

008021df <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8021df:	55                   	push   %ebp
  8021e0:	89 e5                	mov    %esp,%ebp
  8021e2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  8021e5:	a1 44 40 80 00       	mov    0x804044,%eax
  8021ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  8021ed:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  8021f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021f9:	74 0a                	je     802205 <insert_sorted_allocList+0x26>
  8021fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fe:	8b 40 08             	mov    0x8(%eax),%eax
  802201:	85 c0                	test   %eax,%eax
  802203:	75 65                	jne    80226a <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802205:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802209:	75 14                	jne    80221f <insert_sorted_allocList+0x40>
  80220b:	83 ec 04             	sub    $0x4,%esp
  80220e:	68 b4 3b 80 00       	push   $0x803bb4
  802213:	6a 6e                	push   $0x6e
  802215:	68 d7 3b 80 00       	push   $0x803bd7
  80221a:	e8 16 e1 ff ff       	call   800335 <_panic>
  80221f:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802225:	8b 45 08             	mov    0x8(%ebp),%eax
  802228:	89 10                	mov    %edx,(%eax)
  80222a:	8b 45 08             	mov    0x8(%ebp),%eax
  80222d:	8b 00                	mov    (%eax),%eax
  80222f:	85 c0                	test   %eax,%eax
  802231:	74 0d                	je     802240 <insert_sorted_allocList+0x61>
  802233:	a1 40 40 80 00       	mov    0x804040,%eax
  802238:	8b 55 08             	mov    0x8(%ebp),%edx
  80223b:	89 50 04             	mov    %edx,0x4(%eax)
  80223e:	eb 08                	jmp    802248 <insert_sorted_allocList+0x69>
  802240:	8b 45 08             	mov    0x8(%ebp),%eax
  802243:	a3 44 40 80 00       	mov    %eax,0x804044
  802248:	8b 45 08             	mov    0x8(%ebp),%eax
  80224b:	a3 40 40 80 00       	mov    %eax,0x804040
  802250:	8b 45 08             	mov    0x8(%ebp),%eax
  802253:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80225a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80225f:	40                   	inc    %eax
  802260:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802265:	e9 cf 01 00 00       	jmp    802439 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  80226a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80226d:	8b 50 08             	mov    0x8(%eax),%edx
  802270:	8b 45 08             	mov    0x8(%ebp),%eax
  802273:	8b 40 08             	mov    0x8(%eax),%eax
  802276:	39 c2                	cmp    %eax,%edx
  802278:	73 65                	jae    8022df <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80227a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80227e:	75 14                	jne    802294 <insert_sorted_allocList+0xb5>
  802280:	83 ec 04             	sub    $0x4,%esp
  802283:	68 f0 3b 80 00       	push   $0x803bf0
  802288:	6a 72                	push   $0x72
  80228a:	68 d7 3b 80 00       	push   $0x803bd7
  80228f:	e8 a1 e0 ff ff       	call   800335 <_panic>
  802294:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80229a:	8b 45 08             	mov    0x8(%ebp),%eax
  80229d:	89 50 04             	mov    %edx,0x4(%eax)
  8022a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a3:	8b 40 04             	mov    0x4(%eax),%eax
  8022a6:	85 c0                	test   %eax,%eax
  8022a8:	74 0c                	je     8022b6 <insert_sorted_allocList+0xd7>
  8022aa:	a1 44 40 80 00       	mov    0x804044,%eax
  8022af:	8b 55 08             	mov    0x8(%ebp),%edx
  8022b2:	89 10                	mov    %edx,(%eax)
  8022b4:	eb 08                	jmp    8022be <insert_sorted_allocList+0xdf>
  8022b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b9:	a3 40 40 80 00       	mov    %eax,0x804040
  8022be:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c1:	a3 44 40 80 00       	mov    %eax,0x804044
  8022c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022cf:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022d4:	40                   	inc    %eax
  8022d5:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  8022da:	e9 5a 01 00 00       	jmp    802439 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  8022df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e2:	8b 50 08             	mov    0x8(%eax),%edx
  8022e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e8:	8b 40 08             	mov    0x8(%eax),%eax
  8022eb:	39 c2                	cmp    %eax,%edx
  8022ed:	75 70                	jne    80235f <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  8022ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022f3:	74 06                	je     8022fb <insert_sorted_allocList+0x11c>
  8022f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022f9:	75 14                	jne    80230f <insert_sorted_allocList+0x130>
  8022fb:	83 ec 04             	sub    $0x4,%esp
  8022fe:	68 14 3c 80 00       	push   $0x803c14
  802303:	6a 75                	push   $0x75
  802305:	68 d7 3b 80 00       	push   $0x803bd7
  80230a:	e8 26 e0 ff ff       	call   800335 <_panic>
  80230f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802312:	8b 10                	mov    (%eax),%edx
  802314:	8b 45 08             	mov    0x8(%ebp),%eax
  802317:	89 10                	mov    %edx,(%eax)
  802319:	8b 45 08             	mov    0x8(%ebp),%eax
  80231c:	8b 00                	mov    (%eax),%eax
  80231e:	85 c0                	test   %eax,%eax
  802320:	74 0b                	je     80232d <insert_sorted_allocList+0x14e>
  802322:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802325:	8b 00                	mov    (%eax),%eax
  802327:	8b 55 08             	mov    0x8(%ebp),%edx
  80232a:	89 50 04             	mov    %edx,0x4(%eax)
  80232d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802330:	8b 55 08             	mov    0x8(%ebp),%edx
  802333:	89 10                	mov    %edx,(%eax)
  802335:	8b 45 08             	mov    0x8(%ebp),%eax
  802338:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80233b:	89 50 04             	mov    %edx,0x4(%eax)
  80233e:	8b 45 08             	mov    0x8(%ebp),%eax
  802341:	8b 00                	mov    (%eax),%eax
  802343:	85 c0                	test   %eax,%eax
  802345:	75 08                	jne    80234f <insert_sorted_allocList+0x170>
  802347:	8b 45 08             	mov    0x8(%ebp),%eax
  80234a:	a3 44 40 80 00       	mov    %eax,0x804044
  80234f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802354:	40                   	inc    %eax
  802355:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  80235a:	e9 da 00 00 00       	jmp    802439 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  80235f:	a1 40 40 80 00       	mov    0x804040,%eax
  802364:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802367:	e9 9d 00 00 00       	jmp    802409 <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  80236c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236f:	8b 00                	mov    (%eax),%eax
  802371:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  802374:	8b 45 08             	mov    0x8(%ebp),%eax
  802377:	8b 50 08             	mov    0x8(%eax),%edx
  80237a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237d:	8b 40 08             	mov    0x8(%eax),%eax
  802380:	39 c2                	cmp    %eax,%edx
  802382:	76 7d                	jbe    802401 <insert_sorted_allocList+0x222>
  802384:	8b 45 08             	mov    0x8(%ebp),%eax
  802387:	8b 50 08             	mov    0x8(%eax),%edx
  80238a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80238d:	8b 40 08             	mov    0x8(%eax),%eax
  802390:	39 c2                	cmp    %eax,%edx
  802392:	73 6d                	jae    802401 <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802394:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802398:	74 06                	je     8023a0 <insert_sorted_allocList+0x1c1>
  80239a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80239e:	75 14                	jne    8023b4 <insert_sorted_allocList+0x1d5>
  8023a0:	83 ec 04             	sub    $0x4,%esp
  8023a3:	68 14 3c 80 00       	push   $0x803c14
  8023a8:	6a 7c                	push   $0x7c
  8023aa:	68 d7 3b 80 00       	push   $0x803bd7
  8023af:	e8 81 df ff ff       	call   800335 <_panic>
  8023b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b7:	8b 10                	mov    (%eax),%edx
  8023b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bc:	89 10                	mov    %edx,(%eax)
  8023be:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c1:	8b 00                	mov    (%eax),%eax
  8023c3:	85 c0                	test   %eax,%eax
  8023c5:	74 0b                	je     8023d2 <insert_sorted_allocList+0x1f3>
  8023c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ca:	8b 00                	mov    (%eax),%eax
  8023cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8023cf:	89 50 04             	mov    %edx,0x4(%eax)
  8023d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8023d8:	89 10                	mov    %edx,(%eax)
  8023da:	8b 45 08             	mov    0x8(%ebp),%eax
  8023dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023e0:	89 50 04             	mov    %edx,0x4(%eax)
  8023e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e6:	8b 00                	mov    (%eax),%eax
  8023e8:	85 c0                	test   %eax,%eax
  8023ea:	75 08                	jne    8023f4 <insert_sorted_allocList+0x215>
  8023ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ef:	a3 44 40 80 00       	mov    %eax,0x804044
  8023f4:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023f9:	40                   	inc    %eax
  8023fa:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8023ff:	eb 38                	jmp    802439 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802401:	a1 48 40 80 00       	mov    0x804048,%eax
  802406:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802409:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80240d:	74 07                	je     802416 <insert_sorted_allocList+0x237>
  80240f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802412:	8b 00                	mov    (%eax),%eax
  802414:	eb 05                	jmp    80241b <insert_sorted_allocList+0x23c>
  802416:	b8 00 00 00 00       	mov    $0x0,%eax
  80241b:	a3 48 40 80 00       	mov    %eax,0x804048
  802420:	a1 48 40 80 00       	mov    0x804048,%eax
  802425:	85 c0                	test   %eax,%eax
  802427:	0f 85 3f ff ff ff    	jne    80236c <insert_sorted_allocList+0x18d>
  80242d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802431:	0f 85 35 ff ff ff    	jne    80236c <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  802437:	eb 00                	jmp    802439 <insert_sorted_allocList+0x25a>
  802439:	90                   	nop
  80243a:	c9                   	leave  
  80243b:	c3                   	ret    

0080243c <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80243c:	55                   	push   %ebp
  80243d:	89 e5                	mov    %esp,%ebp
  80243f:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802442:	a1 38 41 80 00       	mov    0x804138,%eax
  802447:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80244a:	e9 6b 02 00 00       	jmp    8026ba <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  80244f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802452:	8b 40 0c             	mov    0xc(%eax),%eax
  802455:	3b 45 08             	cmp    0x8(%ebp),%eax
  802458:	0f 85 90 00 00 00    	jne    8024ee <alloc_block_FF+0xb2>
			  temp=element;
  80245e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802461:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  802464:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802468:	75 17                	jne    802481 <alloc_block_FF+0x45>
  80246a:	83 ec 04             	sub    $0x4,%esp
  80246d:	68 48 3c 80 00       	push   $0x803c48
  802472:	68 92 00 00 00       	push   $0x92
  802477:	68 d7 3b 80 00       	push   $0x803bd7
  80247c:	e8 b4 de ff ff       	call   800335 <_panic>
  802481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802484:	8b 00                	mov    (%eax),%eax
  802486:	85 c0                	test   %eax,%eax
  802488:	74 10                	je     80249a <alloc_block_FF+0x5e>
  80248a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248d:	8b 00                	mov    (%eax),%eax
  80248f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802492:	8b 52 04             	mov    0x4(%edx),%edx
  802495:	89 50 04             	mov    %edx,0x4(%eax)
  802498:	eb 0b                	jmp    8024a5 <alloc_block_FF+0x69>
  80249a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249d:	8b 40 04             	mov    0x4(%eax),%eax
  8024a0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8024a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a8:	8b 40 04             	mov    0x4(%eax),%eax
  8024ab:	85 c0                	test   %eax,%eax
  8024ad:	74 0f                	je     8024be <alloc_block_FF+0x82>
  8024af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b2:	8b 40 04             	mov    0x4(%eax),%eax
  8024b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024b8:	8b 12                	mov    (%edx),%edx
  8024ba:	89 10                	mov    %edx,(%eax)
  8024bc:	eb 0a                	jmp    8024c8 <alloc_block_FF+0x8c>
  8024be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c1:	8b 00                	mov    (%eax),%eax
  8024c3:	a3 38 41 80 00       	mov    %eax,0x804138
  8024c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024db:	a1 44 41 80 00       	mov    0x804144,%eax
  8024e0:	48                   	dec    %eax
  8024e1:	a3 44 41 80 00       	mov    %eax,0x804144
			  return temp;
  8024e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024e9:	e9 ff 01 00 00       	jmp    8026ed <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  8024ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8024f4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024f7:	0f 86 b5 01 00 00    	jbe    8026b2 <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  8024fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802500:	8b 40 0c             	mov    0xc(%eax),%eax
  802503:	2b 45 08             	sub    0x8(%ebp),%eax
  802506:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  802509:	a1 48 41 80 00       	mov    0x804148,%eax
  80250e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  802511:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802515:	75 17                	jne    80252e <alloc_block_FF+0xf2>
  802517:	83 ec 04             	sub    $0x4,%esp
  80251a:	68 48 3c 80 00       	push   $0x803c48
  80251f:	68 99 00 00 00       	push   $0x99
  802524:	68 d7 3b 80 00       	push   $0x803bd7
  802529:	e8 07 de ff ff       	call   800335 <_panic>
  80252e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802531:	8b 00                	mov    (%eax),%eax
  802533:	85 c0                	test   %eax,%eax
  802535:	74 10                	je     802547 <alloc_block_FF+0x10b>
  802537:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80253a:	8b 00                	mov    (%eax),%eax
  80253c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80253f:	8b 52 04             	mov    0x4(%edx),%edx
  802542:	89 50 04             	mov    %edx,0x4(%eax)
  802545:	eb 0b                	jmp    802552 <alloc_block_FF+0x116>
  802547:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80254a:	8b 40 04             	mov    0x4(%eax),%eax
  80254d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802552:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802555:	8b 40 04             	mov    0x4(%eax),%eax
  802558:	85 c0                	test   %eax,%eax
  80255a:	74 0f                	je     80256b <alloc_block_FF+0x12f>
  80255c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80255f:	8b 40 04             	mov    0x4(%eax),%eax
  802562:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802565:	8b 12                	mov    (%edx),%edx
  802567:	89 10                	mov    %edx,(%eax)
  802569:	eb 0a                	jmp    802575 <alloc_block_FF+0x139>
  80256b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80256e:	8b 00                	mov    (%eax),%eax
  802570:	a3 48 41 80 00       	mov    %eax,0x804148
  802575:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802578:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80257e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802581:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802588:	a1 54 41 80 00       	mov    0x804154,%eax
  80258d:	48                   	dec    %eax
  80258e:	a3 54 41 80 00       	mov    %eax,0x804154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  802593:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802597:	75 17                	jne    8025b0 <alloc_block_FF+0x174>
  802599:	83 ec 04             	sub    $0x4,%esp
  80259c:	68 f0 3b 80 00       	push   $0x803bf0
  8025a1:	68 9a 00 00 00       	push   $0x9a
  8025a6:	68 d7 3b 80 00       	push   $0x803bd7
  8025ab:	e8 85 dd ff ff       	call   800335 <_panic>
  8025b0:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8025b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025b9:	89 50 04             	mov    %edx,0x4(%eax)
  8025bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025bf:	8b 40 04             	mov    0x4(%eax),%eax
  8025c2:	85 c0                	test   %eax,%eax
  8025c4:	74 0c                	je     8025d2 <alloc_block_FF+0x196>
  8025c6:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8025cb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025ce:	89 10                	mov    %edx,(%eax)
  8025d0:	eb 08                	jmp    8025da <alloc_block_FF+0x19e>
  8025d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d5:	a3 38 41 80 00       	mov    %eax,0x804138
  8025da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025dd:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025eb:	a1 44 41 80 00       	mov    0x804144,%eax
  8025f0:	40                   	inc    %eax
  8025f1:	a3 44 41 80 00       	mov    %eax,0x804144
		  // setting the size & sva
		  new_block->size=size;
  8025f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8025fc:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  8025ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802602:	8b 50 08             	mov    0x8(%eax),%edx
  802605:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802608:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  80260b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802611:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  802614:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802617:	8b 50 08             	mov    0x8(%eax),%edx
  80261a:	8b 45 08             	mov    0x8(%ebp),%eax
  80261d:	01 c2                	add    %eax,%edx
  80261f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802622:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  802625:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802628:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  80262b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80262f:	75 17                	jne    802648 <alloc_block_FF+0x20c>
  802631:	83 ec 04             	sub    $0x4,%esp
  802634:	68 48 3c 80 00       	push   $0x803c48
  802639:	68 a2 00 00 00       	push   $0xa2
  80263e:	68 d7 3b 80 00       	push   $0x803bd7
  802643:	e8 ed dc ff ff       	call   800335 <_panic>
  802648:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80264b:	8b 00                	mov    (%eax),%eax
  80264d:	85 c0                	test   %eax,%eax
  80264f:	74 10                	je     802661 <alloc_block_FF+0x225>
  802651:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802654:	8b 00                	mov    (%eax),%eax
  802656:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802659:	8b 52 04             	mov    0x4(%edx),%edx
  80265c:	89 50 04             	mov    %edx,0x4(%eax)
  80265f:	eb 0b                	jmp    80266c <alloc_block_FF+0x230>
  802661:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802664:	8b 40 04             	mov    0x4(%eax),%eax
  802667:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80266c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80266f:	8b 40 04             	mov    0x4(%eax),%eax
  802672:	85 c0                	test   %eax,%eax
  802674:	74 0f                	je     802685 <alloc_block_FF+0x249>
  802676:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802679:	8b 40 04             	mov    0x4(%eax),%eax
  80267c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80267f:	8b 12                	mov    (%edx),%edx
  802681:	89 10                	mov    %edx,(%eax)
  802683:	eb 0a                	jmp    80268f <alloc_block_FF+0x253>
  802685:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802688:	8b 00                	mov    (%eax),%eax
  80268a:	a3 38 41 80 00       	mov    %eax,0x804138
  80268f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802692:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802698:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80269b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026a2:	a1 44 41 80 00       	mov    0x804144,%eax
  8026a7:	48                   	dec    %eax
  8026a8:	a3 44 41 80 00       	mov    %eax,0x804144
		  return temp;
  8026ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026b0:	eb 3b                	jmp    8026ed <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  8026b2:	a1 40 41 80 00       	mov    0x804140,%eax
  8026b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026be:	74 07                	je     8026c7 <alloc_block_FF+0x28b>
  8026c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c3:	8b 00                	mov    (%eax),%eax
  8026c5:	eb 05                	jmp    8026cc <alloc_block_FF+0x290>
  8026c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8026cc:	a3 40 41 80 00       	mov    %eax,0x804140
  8026d1:	a1 40 41 80 00       	mov    0x804140,%eax
  8026d6:	85 c0                	test   %eax,%eax
  8026d8:	0f 85 71 fd ff ff    	jne    80244f <alloc_block_FF+0x13>
  8026de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e2:	0f 85 67 fd ff ff    	jne    80244f <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  8026e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026ed:	c9                   	leave  
  8026ee:	c3                   	ret    

008026ef <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8026ef:	55                   	push   %ebp
  8026f0:	89 e5                	mov    %esp,%ebp
  8026f2:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  8026f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  8026fc:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802703:	a1 38 41 80 00       	mov    0x804138,%eax
  802708:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80270b:	e9 d3 00 00 00       	jmp    8027e3 <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  802710:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802713:	8b 40 0c             	mov    0xc(%eax),%eax
  802716:	3b 45 08             	cmp    0x8(%ebp),%eax
  802719:	0f 85 90 00 00 00    	jne    8027af <alloc_block_BF+0xc0>
	   temp = element;
  80271f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802722:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  802725:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802729:	75 17                	jne    802742 <alloc_block_BF+0x53>
  80272b:	83 ec 04             	sub    $0x4,%esp
  80272e:	68 48 3c 80 00       	push   $0x803c48
  802733:	68 bd 00 00 00       	push   $0xbd
  802738:	68 d7 3b 80 00       	push   $0x803bd7
  80273d:	e8 f3 db ff ff       	call   800335 <_panic>
  802742:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802745:	8b 00                	mov    (%eax),%eax
  802747:	85 c0                	test   %eax,%eax
  802749:	74 10                	je     80275b <alloc_block_BF+0x6c>
  80274b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80274e:	8b 00                	mov    (%eax),%eax
  802750:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802753:	8b 52 04             	mov    0x4(%edx),%edx
  802756:	89 50 04             	mov    %edx,0x4(%eax)
  802759:	eb 0b                	jmp    802766 <alloc_block_BF+0x77>
  80275b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80275e:	8b 40 04             	mov    0x4(%eax),%eax
  802761:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802766:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802769:	8b 40 04             	mov    0x4(%eax),%eax
  80276c:	85 c0                	test   %eax,%eax
  80276e:	74 0f                	je     80277f <alloc_block_BF+0x90>
  802770:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802773:	8b 40 04             	mov    0x4(%eax),%eax
  802776:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802779:	8b 12                	mov    (%edx),%edx
  80277b:	89 10                	mov    %edx,(%eax)
  80277d:	eb 0a                	jmp    802789 <alloc_block_BF+0x9a>
  80277f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802782:	8b 00                	mov    (%eax),%eax
  802784:	a3 38 41 80 00       	mov    %eax,0x804138
  802789:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80278c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802792:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802795:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80279c:	a1 44 41 80 00       	mov    0x804144,%eax
  8027a1:	48                   	dec    %eax
  8027a2:	a3 44 41 80 00       	mov    %eax,0x804144
	   return temp;
  8027a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027aa:	e9 41 01 00 00       	jmp    8028f0 <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  8027af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027b8:	76 21                	jbe    8027db <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  8027ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027c3:	73 16                	jae    8027db <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  8027c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8027cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  8027ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  8027d4:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  8027db:	a1 40 41 80 00       	mov    0x804140,%eax
  8027e0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8027e3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8027e7:	74 07                	je     8027f0 <alloc_block_BF+0x101>
  8027e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027ec:	8b 00                	mov    (%eax),%eax
  8027ee:	eb 05                	jmp    8027f5 <alloc_block_BF+0x106>
  8027f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f5:	a3 40 41 80 00       	mov    %eax,0x804140
  8027fa:	a1 40 41 80 00       	mov    0x804140,%eax
  8027ff:	85 c0                	test   %eax,%eax
  802801:	0f 85 09 ff ff ff    	jne    802710 <alloc_block_BF+0x21>
  802807:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80280b:	0f 85 ff fe ff ff    	jne    802710 <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  802811:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  802815:	0f 85 d0 00 00 00    	jne    8028eb <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  80281b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80281e:	8b 40 0c             	mov    0xc(%eax),%eax
  802821:	2b 45 08             	sub    0x8(%ebp),%eax
  802824:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  802827:	a1 48 41 80 00       	mov    0x804148,%eax
  80282c:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  80282f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802833:	75 17                	jne    80284c <alloc_block_BF+0x15d>
  802835:	83 ec 04             	sub    $0x4,%esp
  802838:	68 48 3c 80 00       	push   $0x803c48
  80283d:	68 d1 00 00 00       	push   $0xd1
  802842:	68 d7 3b 80 00       	push   $0x803bd7
  802847:	e8 e9 da ff ff       	call   800335 <_panic>
  80284c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80284f:	8b 00                	mov    (%eax),%eax
  802851:	85 c0                	test   %eax,%eax
  802853:	74 10                	je     802865 <alloc_block_BF+0x176>
  802855:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802858:	8b 00                	mov    (%eax),%eax
  80285a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80285d:	8b 52 04             	mov    0x4(%edx),%edx
  802860:	89 50 04             	mov    %edx,0x4(%eax)
  802863:	eb 0b                	jmp    802870 <alloc_block_BF+0x181>
  802865:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802868:	8b 40 04             	mov    0x4(%eax),%eax
  80286b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802870:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802873:	8b 40 04             	mov    0x4(%eax),%eax
  802876:	85 c0                	test   %eax,%eax
  802878:	74 0f                	je     802889 <alloc_block_BF+0x19a>
  80287a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80287d:	8b 40 04             	mov    0x4(%eax),%eax
  802880:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802883:	8b 12                	mov    (%edx),%edx
  802885:	89 10                	mov    %edx,(%eax)
  802887:	eb 0a                	jmp    802893 <alloc_block_BF+0x1a4>
  802889:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80288c:	8b 00                	mov    (%eax),%eax
  80288e:	a3 48 41 80 00       	mov    %eax,0x804148
  802893:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802896:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80289c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80289f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028a6:	a1 54 41 80 00       	mov    0x804154,%eax
  8028ab:	48                   	dec    %eax
  8028ac:	a3 54 41 80 00       	mov    %eax,0x804154
	  // setting the size & sva
	  new_block->size = size;
  8028b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8028b7:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  8028ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028bd:	8b 50 08             	mov    0x8(%eax),%edx
  8028c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028c3:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  8028c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028cc:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  8028cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d2:	8b 50 08             	mov    0x8(%eax),%edx
  8028d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d8:	01 c2                	add    %eax,%edx
  8028da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028dd:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  8028e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028e3:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  8028e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028e9:	eb 05                	jmp    8028f0 <alloc_block_BF+0x201>
	 }
	 return NULL;
  8028eb:	b8 00 00 00 00       	mov    $0x0,%eax


}
  8028f0:	c9                   	leave  
  8028f1:	c3                   	ret    

008028f2 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8028f2:	55                   	push   %ebp
  8028f3:	89 e5                	mov    %esp,%ebp
  8028f5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  8028f8:	83 ec 04             	sub    $0x4,%esp
  8028fb:	68 68 3c 80 00       	push   $0x803c68
  802900:	68 e8 00 00 00       	push   $0xe8
  802905:	68 d7 3b 80 00       	push   $0x803bd7
  80290a:	e8 26 da ff ff       	call   800335 <_panic>

0080290f <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80290f:	55                   	push   %ebp
  802910:	89 e5                	mov    %esp,%ebp
  802912:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  802915:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80291a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  80291d:	a1 38 41 80 00       	mov    0x804138,%eax
  802922:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  802925:	a1 44 41 80 00       	mov    0x804144,%eax
  80292a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  80292d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802931:	75 68                	jne    80299b <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802933:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802937:	75 17                	jne    802950 <insert_sorted_with_merge_freeList+0x41>
  802939:	83 ec 04             	sub    $0x4,%esp
  80293c:	68 b4 3b 80 00       	push   $0x803bb4
  802941:	68 36 01 00 00       	push   $0x136
  802946:	68 d7 3b 80 00       	push   $0x803bd7
  80294b:	e8 e5 d9 ff ff       	call   800335 <_panic>
  802950:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802956:	8b 45 08             	mov    0x8(%ebp),%eax
  802959:	89 10                	mov    %edx,(%eax)
  80295b:	8b 45 08             	mov    0x8(%ebp),%eax
  80295e:	8b 00                	mov    (%eax),%eax
  802960:	85 c0                	test   %eax,%eax
  802962:	74 0d                	je     802971 <insert_sorted_with_merge_freeList+0x62>
  802964:	a1 38 41 80 00       	mov    0x804138,%eax
  802969:	8b 55 08             	mov    0x8(%ebp),%edx
  80296c:	89 50 04             	mov    %edx,0x4(%eax)
  80296f:	eb 08                	jmp    802979 <insert_sorted_with_merge_freeList+0x6a>
  802971:	8b 45 08             	mov    0x8(%ebp),%eax
  802974:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802979:	8b 45 08             	mov    0x8(%ebp),%eax
  80297c:	a3 38 41 80 00       	mov    %eax,0x804138
  802981:	8b 45 08             	mov    0x8(%ebp),%eax
  802984:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80298b:	a1 44 41 80 00       	mov    0x804144,%eax
  802990:	40                   	inc    %eax
  802991:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802996:	e9 ba 06 00 00       	jmp    803055 <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  80299b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80299e:	8b 50 08             	mov    0x8(%eax),%edx
  8029a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8029a7:	01 c2                	add    %eax,%edx
  8029a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ac:	8b 40 08             	mov    0x8(%eax),%eax
  8029af:	39 c2                	cmp    %eax,%edx
  8029b1:	73 68                	jae    802a1b <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8029b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029b7:	75 17                	jne    8029d0 <insert_sorted_with_merge_freeList+0xc1>
  8029b9:	83 ec 04             	sub    $0x4,%esp
  8029bc:	68 f0 3b 80 00       	push   $0x803bf0
  8029c1:	68 3a 01 00 00       	push   $0x13a
  8029c6:	68 d7 3b 80 00       	push   $0x803bd7
  8029cb:	e8 65 d9 ff ff       	call   800335 <_panic>
  8029d0:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8029d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d9:	89 50 04             	mov    %edx,0x4(%eax)
  8029dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029df:	8b 40 04             	mov    0x4(%eax),%eax
  8029e2:	85 c0                	test   %eax,%eax
  8029e4:	74 0c                	je     8029f2 <insert_sorted_with_merge_freeList+0xe3>
  8029e6:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8029ee:	89 10                	mov    %edx,(%eax)
  8029f0:	eb 08                	jmp    8029fa <insert_sorted_with_merge_freeList+0xeb>
  8029f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f5:	a3 38 41 80 00       	mov    %eax,0x804138
  8029fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fd:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a02:	8b 45 08             	mov    0x8(%ebp),%eax
  802a05:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a0b:	a1 44 41 80 00       	mov    0x804144,%eax
  802a10:	40                   	inc    %eax
  802a11:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802a16:	e9 3a 06 00 00       	jmp    803055 <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  802a1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a1e:	8b 50 08             	mov    0x8(%eax),%edx
  802a21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a24:	8b 40 0c             	mov    0xc(%eax),%eax
  802a27:	01 c2                	add    %eax,%edx
  802a29:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2c:	8b 40 08             	mov    0x8(%eax),%eax
  802a2f:	39 c2                	cmp    %eax,%edx
  802a31:	0f 85 90 00 00 00    	jne    802ac7 <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  802a37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a3a:	8b 50 0c             	mov    0xc(%eax),%edx
  802a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a40:	8b 40 0c             	mov    0xc(%eax),%eax
  802a43:	01 c2                	add    %eax,%edx
  802a45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a48:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  802a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  802a55:	8b 45 08             	mov    0x8(%ebp),%eax
  802a58:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802a5f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a63:	75 17                	jne    802a7c <insert_sorted_with_merge_freeList+0x16d>
  802a65:	83 ec 04             	sub    $0x4,%esp
  802a68:	68 b4 3b 80 00       	push   $0x803bb4
  802a6d:	68 41 01 00 00       	push   $0x141
  802a72:	68 d7 3b 80 00       	push   $0x803bd7
  802a77:	e8 b9 d8 ff ff       	call   800335 <_panic>
  802a7c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a82:	8b 45 08             	mov    0x8(%ebp),%eax
  802a85:	89 10                	mov    %edx,(%eax)
  802a87:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8a:	8b 00                	mov    (%eax),%eax
  802a8c:	85 c0                	test   %eax,%eax
  802a8e:	74 0d                	je     802a9d <insert_sorted_with_merge_freeList+0x18e>
  802a90:	a1 48 41 80 00       	mov    0x804148,%eax
  802a95:	8b 55 08             	mov    0x8(%ebp),%edx
  802a98:	89 50 04             	mov    %edx,0x4(%eax)
  802a9b:	eb 08                	jmp    802aa5 <insert_sorted_with_merge_freeList+0x196>
  802a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa8:	a3 48 41 80 00       	mov    %eax,0x804148
  802aad:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ab7:	a1 54 41 80 00       	mov    0x804154,%eax
  802abc:	40                   	inc    %eax
  802abd:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802ac2:	e9 8e 05 00 00       	jmp    803055 <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  802ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aca:	8b 50 08             	mov    0x8(%eax),%edx
  802acd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ad3:	01 c2                	add    %eax,%edx
  802ad5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad8:	8b 40 08             	mov    0x8(%eax),%eax
  802adb:	39 c2                	cmp    %eax,%edx
  802add:	73 68                	jae    802b47 <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802adf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ae3:	75 17                	jne    802afc <insert_sorted_with_merge_freeList+0x1ed>
  802ae5:	83 ec 04             	sub    $0x4,%esp
  802ae8:	68 b4 3b 80 00       	push   $0x803bb4
  802aed:	68 45 01 00 00       	push   $0x145
  802af2:	68 d7 3b 80 00       	push   $0x803bd7
  802af7:	e8 39 d8 ff ff       	call   800335 <_panic>
  802afc:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b02:	8b 45 08             	mov    0x8(%ebp),%eax
  802b05:	89 10                	mov    %edx,(%eax)
  802b07:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0a:	8b 00                	mov    (%eax),%eax
  802b0c:	85 c0                	test   %eax,%eax
  802b0e:	74 0d                	je     802b1d <insert_sorted_with_merge_freeList+0x20e>
  802b10:	a1 38 41 80 00       	mov    0x804138,%eax
  802b15:	8b 55 08             	mov    0x8(%ebp),%edx
  802b18:	89 50 04             	mov    %edx,0x4(%eax)
  802b1b:	eb 08                	jmp    802b25 <insert_sorted_with_merge_freeList+0x216>
  802b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b20:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b25:	8b 45 08             	mov    0x8(%ebp),%eax
  802b28:	a3 38 41 80 00       	mov    %eax,0x804138
  802b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b30:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b37:	a1 44 41 80 00       	mov    0x804144,%eax
  802b3c:	40                   	inc    %eax
  802b3d:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802b42:	e9 0e 05 00 00       	jmp    803055 <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  802b47:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4a:	8b 50 08             	mov    0x8(%eax),%edx
  802b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b50:	8b 40 0c             	mov    0xc(%eax),%eax
  802b53:	01 c2                	add    %eax,%edx
  802b55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b58:	8b 40 08             	mov    0x8(%eax),%eax
  802b5b:	39 c2                	cmp    %eax,%edx
  802b5d:	0f 85 9c 00 00 00    	jne    802bff <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  802b63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b66:	8b 50 0c             	mov    0xc(%eax),%edx
  802b69:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6c:	8b 40 0c             	mov    0xc(%eax),%eax
  802b6f:	01 c2                	add    %eax,%edx
  802b71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b74:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  802b77:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7a:	8b 50 08             	mov    0x8(%eax),%edx
  802b7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b80:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  802b83:	8b 45 08             	mov    0x8(%ebp),%eax
  802b86:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  802b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b90:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802b97:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b9b:	75 17                	jne    802bb4 <insert_sorted_with_merge_freeList+0x2a5>
  802b9d:	83 ec 04             	sub    $0x4,%esp
  802ba0:	68 b4 3b 80 00       	push   $0x803bb4
  802ba5:	68 4d 01 00 00       	push   $0x14d
  802baa:	68 d7 3b 80 00       	push   $0x803bd7
  802baf:	e8 81 d7 ff ff       	call   800335 <_panic>
  802bb4:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802bba:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbd:	89 10                	mov    %edx,(%eax)
  802bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc2:	8b 00                	mov    (%eax),%eax
  802bc4:	85 c0                	test   %eax,%eax
  802bc6:	74 0d                	je     802bd5 <insert_sorted_with_merge_freeList+0x2c6>
  802bc8:	a1 48 41 80 00       	mov    0x804148,%eax
  802bcd:	8b 55 08             	mov    0x8(%ebp),%edx
  802bd0:	89 50 04             	mov    %edx,0x4(%eax)
  802bd3:	eb 08                	jmp    802bdd <insert_sorted_with_merge_freeList+0x2ce>
  802bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  802be0:	a3 48 41 80 00       	mov    %eax,0x804148
  802be5:	8b 45 08             	mov    0x8(%ebp),%eax
  802be8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bef:	a1 54 41 80 00       	mov    0x804154,%eax
  802bf4:	40                   	inc    %eax
  802bf5:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802bfa:	e9 56 04 00 00       	jmp    803055 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802bff:	a1 38 41 80 00       	mov    0x804138,%eax
  802c04:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c07:	e9 19 04 00 00       	jmp    803025 <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  802c0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0f:	8b 00                	mov    (%eax),%eax
  802c11:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c17:	8b 50 08             	mov    0x8(%eax),%edx
  802c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1d:	8b 40 0c             	mov    0xc(%eax),%eax
  802c20:	01 c2                	add    %eax,%edx
  802c22:	8b 45 08             	mov    0x8(%ebp),%eax
  802c25:	8b 40 08             	mov    0x8(%eax),%eax
  802c28:	39 c2                	cmp    %eax,%edx
  802c2a:	0f 85 ad 01 00 00    	jne    802ddd <insert_sorted_with_merge_freeList+0x4ce>
  802c30:	8b 45 08             	mov    0x8(%ebp),%eax
  802c33:	8b 50 08             	mov    0x8(%eax),%edx
  802c36:	8b 45 08             	mov    0x8(%ebp),%eax
  802c39:	8b 40 0c             	mov    0xc(%eax),%eax
  802c3c:	01 c2                	add    %eax,%edx
  802c3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c41:	8b 40 08             	mov    0x8(%eax),%eax
  802c44:	39 c2                	cmp    %eax,%edx
  802c46:	0f 85 91 01 00 00    	jne    802ddd <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  802c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4f:	8b 50 0c             	mov    0xc(%eax),%edx
  802c52:	8b 45 08             	mov    0x8(%ebp),%eax
  802c55:	8b 48 0c             	mov    0xc(%eax),%ecx
  802c58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c5b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c5e:	01 c8                	add    %ecx,%eax
  802c60:	01 c2                	add    %eax,%edx
  802c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c65:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  802c68:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802c72:	8b 45 08             	mov    0x8(%ebp),%eax
  802c75:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  802c7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c7f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  802c86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c89:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  802c90:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802c94:	75 17                	jne    802cad <insert_sorted_with_merge_freeList+0x39e>
  802c96:	83 ec 04             	sub    $0x4,%esp
  802c99:	68 48 3c 80 00       	push   $0x803c48
  802c9e:	68 5b 01 00 00       	push   $0x15b
  802ca3:	68 d7 3b 80 00       	push   $0x803bd7
  802ca8:	e8 88 d6 ff ff       	call   800335 <_panic>
  802cad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cb0:	8b 00                	mov    (%eax),%eax
  802cb2:	85 c0                	test   %eax,%eax
  802cb4:	74 10                	je     802cc6 <insert_sorted_with_merge_freeList+0x3b7>
  802cb6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cb9:	8b 00                	mov    (%eax),%eax
  802cbb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802cbe:	8b 52 04             	mov    0x4(%edx),%edx
  802cc1:	89 50 04             	mov    %edx,0x4(%eax)
  802cc4:	eb 0b                	jmp    802cd1 <insert_sorted_with_merge_freeList+0x3c2>
  802cc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cc9:	8b 40 04             	mov    0x4(%eax),%eax
  802ccc:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cd1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cd4:	8b 40 04             	mov    0x4(%eax),%eax
  802cd7:	85 c0                	test   %eax,%eax
  802cd9:	74 0f                	je     802cea <insert_sorted_with_merge_freeList+0x3db>
  802cdb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cde:	8b 40 04             	mov    0x4(%eax),%eax
  802ce1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ce4:	8b 12                	mov    (%edx),%edx
  802ce6:	89 10                	mov    %edx,(%eax)
  802ce8:	eb 0a                	jmp    802cf4 <insert_sorted_with_merge_freeList+0x3e5>
  802cea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ced:	8b 00                	mov    (%eax),%eax
  802cef:	a3 38 41 80 00       	mov    %eax,0x804138
  802cf4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cf7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cfd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d00:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d07:	a1 44 41 80 00       	mov    0x804144,%eax
  802d0c:	48                   	dec    %eax
  802d0d:	a3 44 41 80 00       	mov    %eax,0x804144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802d12:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d16:	75 17                	jne    802d2f <insert_sorted_with_merge_freeList+0x420>
  802d18:	83 ec 04             	sub    $0x4,%esp
  802d1b:	68 b4 3b 80 00       	push   $0x803bb4
  802d20:	68 5c 01 00 00       	push   $0x15c
  802d25:	68 d7 3b 80 00       	push   $0x803bd7
  802d2a:	e8 06 d6 ff ff       	call   800335 <_panic>
  802d2f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d35:	8b 45 08             	mov    0x8(%ebp),%eax
  802d38:	89 10                	mov    %edx,(%eax)
  802d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3d:	8b 00                	mov    (%eax),%eax
  802d3f:	85 c0                	test   %eax,%eax
  802d41:	74 0d                	je     802d50 <insert_sorted_with_merge_freeList+0x441>
  802d43:	a1 48 41 80 00       	mov    0x804148,%eax
  802d48:	8b 55 08             	mov    0x8(%ebp),%edx
  802d4b:	89 50 04             	mov    %edx,0x4(%eax)
  802d4e:	eb 08                	jmp    802d58 <insert_sorted_with_merge_freeList+0x449>
  802d50:	8b 45 08             	mov    0x8(%ebp),%eax
  802d53:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d58:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5b:	a3 48 41 80 00       	mov    %eax,0x804148
  802d60:	8b 45 08             	mov    0x8(%ebp),%eax
  802d63:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d6a:	a1 54 41 80 00       	mov    0x804154,%eax
  802d6f:	40                   	inc    %eax
  802d70:	a3 54 41 80 00       	mov    %eax,0x804154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  802d75:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802d79:	75 17                	jne    802d92 <insert_sorted_with_merge_freeList+0x483>
  802d7b:	83 ec 04             	sub    $0x4,%esp
  802d7e:	68 b4 3b 80 00       	push   $0x803bb4
  802d83:	68 5d 01 00 00       	push   $0x15d
  802d88:	68 d7 3b 80 00       	push   $0x803bd7
  802d8d:	e8 a3 d5 ff ff       	call   800335 <_panic>
  802d92:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d9b:	89 10                	mov    %edx,(%eax)
  802d9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802da0:	8b 00                	mov    (%eax),%eax
  802da2:	85 c0                	test   %eax,%eax
  802da4:	74 0d                	je     802db3 <insert_sorted_with_merge_freeList+0x4a4>
  802da6:	a1 48 41 80 00       	mov    0x804148,%eax
  802dab:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802dae:	89 50 04             	mov    %edx,0x4(%eax)
  802db1:	eb 08                	jmp    802dbb <insert_sorted_with_merge_freeList+0x4ac>
  802db3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802db6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802dbb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dbe:	a3 48 41 80 00       	mov    %eax,0x804148
  802dc3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dc6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dcd:	a1 54 41 80 00       	mov    0x804154,%eax
  802dd2:	40                   	inc    %eax
  802dd3:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802dd8:	e9 78 02 00 00       	jmp    803055 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802ddd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de0:	8b 50 08             	mov    0x8(%eax),%edx
  802de3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de6:	8b 40 0c             	mov    0xc(%eax),%eax
  802de9:	01 c2                	add    %eax,%edx
  802deb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dee:	8b 40 08             	mov    0x8(%eax),%eax
  802df1:	39 c2                	cmp    %eax,%edx
  802df3:	0f 83 b8 00 00 00    	jae    802eb1 <insert_sorted_with_merge_freeList+0x5a2>
  802df9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfc:	8b 50 08             	mov    0x8(%eax),%edx
  802dff:	8b 45 08             	mov    0x8(%ebp),%eax
  802e02:	8b 40 0c             	mov    0xc(%eax),%eax
  802e05:	01 c2                	add    %eax,%edx
  802e07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e0a:	8b 40 08             	mov    0x8(%eax),%eax
  802e0d:	39 c2                	cmp    %eax,%edx
  802e0f:	0f 85 9c 00 00 00    	jne    802eb1 <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  802e15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e18:	8b 50 0c             	mov    0xc(%eax),%edx
  802e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1e:	8b 40 0c             	mov    0xc(%eax),%eax
  802e21:	01 c2                	add    %eax,%edx
  802e23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e26:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  802e29:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2c:	8b 50 08             	mov    0x8(%eax),%edx
  802e2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e32:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  802e35:	8b 45 08             	mov    0x8(%ebp),%eax
  802e38:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e42:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e49:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e4d:	75 17                	jne    802e66 <insert_sorted_with_merge_freeList+0x557>
  802e4f:	83 ec 04             	sub    $0x4,%esp
  802e52:	68 b4 3b 80 00       	push   $0x803bb4
  802e57:	68 67 01 00 00       	push   $0x167
  802e5c:	68 d7 3b 80 00       	push   $0x803bd7
  802e61:	e8 cf d4 ff ff       	call   800335 <_panic>
  802e66:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6f:	89 10                	mov    %edx,(%eax)
  802e71:	8b 45 08             	mov    0x8(%ebp),%eax
  802e74:	8b 00                	mov    (%eax),%eax
  802e76:	85 c0                	test   %eax,%eax
  802e78:	74 0d                	je     802e87 <insert_sorted_with_merge_freeList+0x578>
  802e7a:	a1 48 41 80 00       	mov    0x804148,%eax
  802e7f:	8b 55 08             	mov    0x8(%ebp),%edx
  802e82:	89 50 04             	mov    %edx,0x4(%eax)
  802e85:	eb 08                	jmp    802e8f <insert_sorted_with_merge_freeList+0x580>
  802e87:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e92:	a3 48 41 80 00       	mov    %eax,0x804148
  802e97:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ea1:	a1 54 41 80 00       	mov    0x804154,%eax
  802ea6:	40                   	inc    %eax
  802ea7:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802eac:	e9 a4 01 00 00       	jmp    803055 <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802eb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb4:	8b 50 08             	mov    0x8(%eax),%edx
  802eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eba:	8b 40 0c             	mov    0xc(%eax),%eax
  802ebd:	01 c2                	add    %eax,%edx
  802ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec2:	8b 40 08             	mov    0x8(%eax),%eax
  802ec5:	39 c2                	cmp    %eax,%edx
  802ec7:	0f 85 ac 00 00 00    	jne    802f79 <insert_sorted_with_merge_freeList+0x66a>
  802ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed0:	8b 50 08             	mov    0x8(%eax),%edx
  802ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed9:	01 c2                	add    %eax,%edx
  802edb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ede:	8b 40 08             	mov    0x8(%eax),%eax
  802ee1:	39 c2                	cmp    %eax,%edx
  802ee3:	0f 83 90 00 00 00    	jae    802f79 <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  802ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eec:	8b 50 0c             	mov    0xc(%eax),%edx
  802eef:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ef5:	01 c2                	add    %eax,%edx
  802ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efa:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  802efd:	8b 45 08             	mov    0x8(%ebp),%eax
  802f00:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  802f07:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802f11:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f15:	75 17                	jne    802f2e <insert_sorted_with_merge_freeList+0x61f>
  802f17:	83 ec 04             	sub    $0x4,%esp
  802f1a:	68 b4 3b 80 00       	push   $0x803bb4
  802f1f:	68 70 01 00 00       	push   $0x170
  802f24:	68 d7 3b 80 00       	push   $0x803bd7
  802f29:	e8 07 d4 ff ff       	call   800335 <_panic>
  802f2e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f34:	8b 45 08             	mov    0x8(%ebp),%eax
  802f37:	89 10                	mov    %edx,(%eax)
  802f39:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3c:	8b 00                	mov    (%eax),%eax
  802f3e:	85 c0                	test   %eax,%eax
  802f40:	74 0d                	je     802f4f <insert_sorted_with_merge_freeList+0x640>
  802f42:	a1 48 41 80 00       	mov    0x804148,%eax
  802f47:	8b 55 08             	mov    0x8(%ebp),%edx
  802f4a:	89 50 04             	mov    %edx,0x4(%eax)
  802f4d:	eb 08                	jmp    802f57 <insert_sorted_with_merge_freeList+0x648>
  802f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f52:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f57:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5a:	a3 48 41 80 00       	mov    %eax,0x804148
  802f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f62:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f69:	a1 54 41 80 00       	mov    0x804154,%eax
  802f6e:	40                   	inc    %eax
  802f6f:	a3 54 41 80 00       	mov    %eax,0x804154
	      break;
  802f74:	e9 dc 00 00 00       	jmp    803055 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7c:	8b 50 08             	mov    0x8(%eax),%edx
  802f7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f82:	8b 40 0c             	mov    0xc(%eax),%eax
  802f85:	01 c2                	add    %eax,%edx
  802f87:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8a:	8b 40 08             	mov    0x8(%eax),%eax
  802f8d:	39 c2                	cmp    %eax,%edx
  802f8f:	0f 83 88 00 00 00    	jae    80301d <insert_sorted_with_merge_freeList+0x70e>
  802f95:	8b 45 08             	mov    0x8(%ebp),%eax
  802f98:	8b 50 08             	mov    0x8(%eax),%edx
  802f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9e:	8b 40 0c             	mov    0xc(%eax),%eax
  802fa1:	01 c2                	add    %eax,%edx
  802fa3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fa6:	8b 40 08             	mov    0x8(%eax),%eax
  802fa9:	39 c2                	cmp    %eax,%edx
  802fab:	73 70                	jae    80301d <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  802fad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fb1:	74 06                	je     802fb9 <insert_sorted_with_merge_freeList+0x6aa>
  802fb3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fb7:	75 17                	jne    802fd0 <insert_sorted_with_merge_freeList+0x6c1>
  802fb9:	83 ec 04             	sub    $0x4,%esp
  802fbc:	68 14 3c 80 00       	push   $0x803c14
  802fc1:	68 75 01 00 00       	push   $0x175
  802fc6:	68 d7 3b 80 00       	push   $0x803bd7
  802fcb:	e8 65 d3 ff ff       	call   800335 <_panic>
  802fd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd3:	8b 10                	mov    (%eax),%edx
  802fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd8:	89 10                	mov    %edx,(%eax)
  802fda:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdd:	8b 00                	mov    (%eax),%eax
  802fdf:	85 c0                	test   %eax,%eax
  802fe1:	74 0b                	je     802fee <insert_sorted_with_merge_freeList+0x6df>
  802fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe6:	8b 00                	mov    (%eax),%eax
  802fe8:	8b 55 08             	mov    0x8(%ebp),%edx
  802feb:	89 50 04             	mov    %edx,0x4(%eax)
  802fee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ff4:	89 10                	mov    %edx,(%eax)
  802ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ffc:	89 50 04             	mov    %edx,0x4(%eax)
  802fff:	8b 45 08             	mov    0x8(%ebp),%eax
  803002:	8b 00                	mov    (%eax),%eax
  803004:	85 c0                	test   %eax,%eax
  803006:	75 08                	jne    803010 <insert_sorted_with_merge_freeList+0x701>
  803008:	8b 45 08             	mov    0x8(%ebp),%eax
  80300b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803010:	a1 44 41 80 00       	mov    0x804144,%eax
  803015:	40                   	inc    %eax
  803016:	a3 44 41 80 00       	mov    %eax,0x804144
	      break;
  80301b:	eb 38                	jmp    803055 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  80301d:	a1 40 41 80 00       	mov    0x804140,%eax
  803022:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803025:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803029:	74 07                	je     803032 <insert_sorted_with_merge_freeList+0x723>
  80302b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302e:	8b 00                	mov    (%eax),%eax
  803030:	eb 05                	jmp    803037 <insert_sorted_with_merge_freeList+0x728>
  803032:	b8 00 00 00 00       	mov    $0x0,%eax
  803037:	a3 40 41 80 00       	mov    %eax,0x804140
  80303c:	a1 40 41 80 00       	mov    0x804140,%eax
  803041:	85 c0                	test   %eax,%eax
  803043:	0f 85 c3 fb ff ff    	jne    802c0c <insert_sorted_with_merge_freeList+0x2fd>
  803049:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80304d:	0f 85 b9 fb ff ff    	jne    802c0c <insert_sorted_with_merge_freeList+0x2fd>





}
  803053:	eb 00                	jmp    803055 <insert_sorted_with_merge_freeList+0x746>
  803055:	90                   	nop
  803056:	c9                   	leave  
  803057:	c3                   	ret    

00803058 <__udivdi3>:
  803058:	55                   	push   %ebp
  803059:	57                   	push   %edi
  80305a:	56                   	push   %esi
  80305b:	53                   	push   %ebx
  80305c:	83 ec 1c             	sub    $0x1c,%esp
  80305f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803063:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803067:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80306b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80306f:	89 ca                	mov    %ecx,%edx
  803071:	89 f8                	mov    %edi,%eax
  803073:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803077:	85 f6                	test   %esi,%esi
  803079:	75 2d                	jne    8030a8 <__udivdi3+0x50>
  80307b:	39 cf                	cmp    %ecx,%edi
  80307d:	77 65                	ja     8030e4 <__udivdi3+0x8c>
  80307f:	89 fd                	mov    %edi,%ebp
  803081:	85 ff                	test   %edi,%edi
  803083:	75 0b                	jne    803090 <__udivdi3+0x38>
  803085:	b8 01 00 00 00       	mov    $0x1,%eax
  80308a:	31 d2                	xor    %edx,%edx
  80308c:	f7 f7                	div    %edi
  80308e:	89 c5                	mov    %eax,%ebp
  803090:	31 d2                	xor    %edx,%edx
  803092:	89 c8                	mov    %ecx,%eax
  803094:	f7 f5                	div    %ebp
  803096:	89 c1                	mov    %eax,%ecx
  803098:	89 d8                	mov    %ebx,%eax
  80309a:	f7 f5                	div    %ebp
  80309c:	89 cf                	mov    %ecx,%edi
  80309e:	89 fa                	mov    %edi,%edx
  8030a0:	83 c4 1c             	add    $0x1c,%esp
  8030a3:	5b                   	pop    %ebx
  8030a4:	5e                   	pop    %esi
  8030a5:	5f                   	pop    %edi
  8030a6:	5d                   	pop    %ebp
  8030a7:	c3                   	ret    
  8030a8:	39 ce                	cmp    %ecx,%esi
  8030aa:	77 28                	ja     8030d4 <__udivdi3+0x7c>
  8030ac:	0f bd fe             	bsr    %esi,%edi
  8030af:	83 f7 1f             	xor    $0x1f,%edi
  8030b2:	75 40                	jne    8030f4 <__udivdi3+0x9c>
  8030b4:	39 ce                	cmp    %ecx,%esi
  8030b6:	72 0a                	jb     8030c2 <__udivdi3+0x6a>
  8030b8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8030bc:	0f 87 9e 00 00 00    	ja     803160 <__udivdi3+0x108>
  8030c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8030c7:	89 fa                	mov    %edi,%edx
  8030c9:	83 c4 1c             	add    $0x1c,%esp
  8030cc:	5b                   	pop    %ebx
  8030cd:	5e                   	pop    %esi
  8030ce:	5f                   	pop    %edi
  8030cf:	5d                   	pop    %ebp
  8030d0:	c3                   	ret    
  8030d1:	8d 76 00             	lea    0x0(%esi),%esi
  8030d4:	31 ff                	xor    %edi,%edi
  8030d6:	31 c0                	xor    %eax,%eax
  8030d8:	89 fa                	mov    %edi,%edx
  8030da:	83 c4 1c             	add    $0x1c,%esp
  8030dd:	5b                   	pop    %ebx
  8030de:	5e                   	pop    %esi
  8030df:	5f                   	pop    %edi
  8030e0:	5d                   	pop    %ebp
  8030e1:	c3                   	ret    
  8030e2:	66 90                	xchg   %ax,%ax
  8030e4:	89 d8                	mov    %ebx,%eax
  8030e6:	f7 f7                	div    %edi
  8030e8:	31 ff                	xor    %edi,%edi
  8030ea:	89 fa                	mov    %edi,%edx
  8030ec:	83 c4 1c             	add    $0x1c,%esp
  8030ef:	5b                   	pop    %ebx
  8030f0:	5e                   	pop    %esi
  8030f1:	5f                   	pop    %edi
  8030f2:	5d                   	pop    %ebp
  8030f3:	c3                   	ret    
  8030f4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8030f9:	89 eb                	mov    %ebp,%ebx
  8030fb:	29 fb                	sub    %edi,%ebx
  8030fd:	89 f9                	mov    %edi,%ecx
  8030ff:	d3 e6                	shl    %cl,%esi
  803101:	89 c5                	mov    %eax,%ebp
  803103:	88 d9                	mov    %bl,%cl
  803105:	d3 ed                	shr    %cl,%ebp
  803107:	89 e9                	mov    %ebp,%ecx
  803109:	09 f1                	or     %esi,%ecx
  80310b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80310f:	89 f9                	mov    %edi,%ecx
  803111:	d3 e0                	shl    %cl,%eax
  803113:	89 c5                	mov    %eax,%ebp
  803115:	89 d6                	mov    %edx,%esi
  803117:	88 d9                	mov    %bl,%cl
  803119:	d3 ee                	shr    %cl,%esi
  80311b:	89 f9                	mov    %edi,%ecx
  80311d:	d3 e2                	shl    %cl,%edx
  80311f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803123:	88 d9                	mov    %bl,%cl
  803125:	d3 e8                	shr    %cl,%eax
  803127:	09 c2                	or     %eax,%edx
  803129:	89 d0                	mov    %edx,%eax
  80312b:	89 f2                	mov    %esi,%edx
  80312d:	f7 74 24 0c          	divl   0xc(%esp)
  803131:	89 d6                	mov    %edx,%esi
  803133:	89 c3                	mov    %eax,%ebx
  803135:	f7 e5                	mul    %ebp
  803137:	39 d6                	cmp    %edx,%esi
  803139:	72 19                	jb     803154 <__udivdi3+0xfc>
  80313b:	74 0b                	je     803148 <__udivdi3+0xf0>
  80313d:	89 d8                	mov    %ebx,%eax
  80313f:	31 ff                	xor    %edi,%edi
  803141:	e9 58 ff ff ff       	jmp    80309e <__udivdi3+0x46>
  803146:	66 90                	xchg   %ax,%ax
  803148:	8b 54 24 08          	mov    0x8(%esp),%edx
  80314c:	89 f9                	mov    %edi,%ecx
  80314e:	d3 e2                	shl    %cl,%edx
  803150:	39 c2                	cmp    %eax,%edx
  803152:	73 e9                	jae    80313d <__udivdi3+0xe5>
  803154:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803157:	31 ff                	xor    %edi,%edi
  803159:	e9 40 ff ff ff       	jmp    80309e <__udivdi3+0x46>
  80315e:	66 90                	xchg   %ax,%ax
  803160:	31 c0                	xor    %eax,%eax
  803162:	e9 37 ff ff ff       	jmp    80309e <__udivdi3+0x46>
  803167:	90                   	nop

00803168 <__umoddi3>:
  803168:	55                   	push   %ebp
  803169:	57                   	push   %edi
  80316a:	56                   	push   %esi
  80316b:	53                   	push   %ebx
  80316c:	83 ec 1c             	sub    $0x1c,%esp
  80316f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803173:	8b 74 24 34          	mov    0x34(%esp),%esi
  803177:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80317b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80317f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803183:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803187:	89 f3                	mov    %esi,%ebx
  803189:	89 fa                	mov    %edi,%edx
  80318b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80318f:	89 34 24             	mov    %esi,(%esp)
  803192:	85 c0                	test   %eax,%eax
  803194:	75 1a                	jne    8031b0 <__umoddi3+0x48>
  803196:	39 f7                	cmp    %esi,%edi
  803198:	0f 86 a2 00 00 00    	jbe    803240 <__umoddi3+0xd8>
  80319e:	89 c8                	mov    %ecx,%eax
  8031a0:	89 f2                	mov    %esi,%edx
  8031a2:	f7 f7                	div    %edi
  8031a4:	89 d0                	mov    %edx,%eax
  8031a6:	31 d2                	xor    %edx,%edx
  8031a8:	83 c4 1c             	add    $0x1c,%esp
  8031ab:	5b                   	pop    %ebx
  8031ac:	5e                   	pop    %esi
  8031ad:	5f                   	pop    %edi
  8031ae:	5d                   	pop    %ebp
  8031af:	c3                   	ret    
  8031b0:	39 f0                	cmp    %esi,%eax
  8031b2:	0f 87 ac 00 00 00    	ja     803264 <__umoddi3+0xfc>
  8031b8:	0f bd e8             	bsr    %eax,%ebp
  8031bb:	83 f5 1f             	xor    $0x1f,%ebp
  8031be:	0f 84 ac 00 00 00    	je     803270 <__umoddi3+0x108>
  8031c4:	bf 20 00 00 00       	mov    $0x20,%edi
  8031c9:	29 ef                	sub    %ebp,%edi
  8031cb:	89 fe                	mov    %edi,%esi
  8031cd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8031d1:	89 e9                	mov    %ebp,%ecx
  8031d3:	d3 e0                	shl    %cl,%eax
  8031d5:	89 d7                	mov    %edx,%edi
  8031d7:	89 f1                	mov    %esi,%ecx
  8031d9:	d3 ef                	shr    %cl,%edi
  8031db:	09 c7                	or     %eax,%edi
  8031dd:	89 e9                	mov    %ebp,%ecx
  8031df:	d3 e2                	shl    %cl,%edx
  8031e1:	89 14 24             	mov    %edx,(%esp)
  8031e4:	89 d8                	mov    %ebx,%eax
  8031e6:	d3 e0                	shl    %cl,%eax
  8031e8:	89 c2                	mov    %eax,%edx
  8031ea:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031ee:	d3 e0                	shl    %cl,%eax
  8031f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031f4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031f8:	89 f1                	mov    %esi,%ecx
  8031fa:	d3 e8                	shr    %cl,%eax
  8031fc:	09 d0                	or     %edx,%eax
  8031fe:	d3 eb                	shr    %cl,%ebx
  803200:	89 da                	mov    %ebx,%edx
  803202:	f7 f7                	div    %edi
  803204:	89 d3                	mov    %edx,%ebx
  803206:	f7 24 24             	mull   (%esp)
  803209:	89 c6                	mov    %eax,%esi
  80320b:	89 d1                	mov    %edx,%ecx
  80320d:	39 d3                	cmp    %edx,%ebx
  80320f:	0f 82 87 00 00 00    	jb     80329c <__umoddi3+0x134>
  803215:	0f 84 91 00 00 00    	je     8032ac <__umoddi3+0x144>
  80321b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80321f:	29 f2                	sub    %esi,%edx
  803221:	19 cb                	sbb    %ecx,%ebx
  803223:	89 d8                	mov    %ebx,%eax
  803225:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803229:	d3 e0                	shl    %cl,%eax
  80322b:	89 e9                	mov    %ebp,%ecx
  80322d:	d3 ea                	shr    %cl,%edx
  80322f:	09 d0                	or     %edx,%eax
  803231:	89 e9                	mov    %ebp,%ecx
  803233:	d3 eb                	shr    %cl,%ebx
  803235:	89 da                	mov    %ebx,%edx
  803237:	83 c4 1c             	add    $0x1c,%esp
  80323a:	5b                   	pop    %ebx
  80323b:	5e                   	pop    %esi
  80323c:	5f                   	pop    %edi
  80323d:	5d                   	pop    %ebp
  80323e:	c3                   	ret    
  80323f:	90                   	nop
  803240:	89 fd                	mov    %edi,%ebp
  803242:	85 ff                	test   %edi,%edi
  803244:	75 0b                	jne    803251 <__umoddi3+0xe9>
  803246:	b8 01 00 00 00       	mov    $0x1,%eax
  80324b:	31 d2                	xor    %edx,%edx
  80324d:	f7 f7                	div    %edi
  80324f:	89 c5                	mov    %eax,%ebp
  803251:	89 f0                	mov    %esi,%eax
  803253:	31 d2                	xor    %edx,%edx
  803255:	f7 f5                	div    %ebp
  803257:	89 c8                	mov    %ecx,%eax
  803259:	f7 f5                	div    %ebp
  80325b:	89 d0                	mov    %edx,%eax
  80325d:	e9 44 ff ff ff       	jmp    8031a6 <__umoddi3+0x3e>
  803262:	66 90                	xchg   %ax,%ax
  803264:	89 c8                	mov    %ecx,%eax
  803266:	89 f2                	mov    %esi,%edx
  803268:	83 c4 1c             	add    $0x1c,%esp
  80326b:	5b                   	pop    %ebx
  80326c:	5e                   	pop    %esi
  80326d:	5f                   	pop    %edi
  80326e:	5d                   	pop    %ebp
  80326f:	c3                   	ret    
  803270:	3b 04 24             	cmp    (%esp),%eax
  803273:	72 06                	jb     80327b <__umoddi3+0x113>
  803275:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803279:	77 0f                	ja     80328a <__umoddi3+0x122>
  80327b:	89 f2                	mov    %esi,%edx
  80327d:	29 f9                	sub    %edi,%ecx
  80327f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803283:	89 14 24             	mov    %edx,(%esp)
  803286:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80328a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80328e:	8b 14 24             	mov    (%esp),%edx
  803291:	83 c4 1c             	add    $0x1c,%esp
  803294:	5b                   	pop    %ebx
  803295:	5e                   	pop    %esi
  803296:	5f                   	pop    %edi
  803297:	5d                   	pop    %ebp
  803298:	c3                   	ret    
  803299:	8d 76 00             	lea    0x0(%esi),%esi
  80329c:	2b 04 24             	sub    (%esp),%eax
  80329f:	19 fa                	sbb    %edi,%edx
  8032a1:	89 d1                	mov    %edx,%ecx
  8032a3:	89 c6                	mov    %eax,%esi
  8032a5:	e9 71 ff ff ff       	jmp    80321b <__umoddi3+0xb3>
  8032aa:	66 90                	xchg   %ax,%ax
  8032ac:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8032b0:	72 ea                	jb     80329c <__umoddi3+0x134>
  8032b2:	89 d9                	mov    %ebx,%ecx
  8032b4:	e9 62 ff ff ff       	jmp    80321b <__umoddi3+0xb3>
