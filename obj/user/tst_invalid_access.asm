
obj/user/tst_invalid_access:     file format elf32-i386


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
  800031:	e8 57 00 00 00       	call   80008d <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/************************************************************/

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp

	uint32 kilo = 1024;
  80003e:	c7 45 f0 00 04 00 00 	movl   $0x400,-0x10(%ebp)

//	cprintf("envID = %d\n",envID);

	/// testing illegal memory access
	{
		uint32 size = 4*kilo;
  800045:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800048:	c1 e0 02             	shl    $0x2,%eax
  80004b:	89 45 ec             	mov    %eax,-0x14(%ebp)

		unsigned char *x = (unsigned char *)(0x00200000-PAGE_SIZE);
  80004e:	c7 45 e8 00 f0 1f 00 	movl   $0x1ff000,-0x18(%ebp)

		int i=0;
  800055:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		for(;i< size+20;i++)
  80005c:	eb 0e                	jmp    80006c <_main+0x34>
		{
			x[i]=-1;
  80005e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800061:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800064:	01 d0                	add    %edx,%eax
  800066:	c6 00 ff             	movb   $0xff,(%eax)
		uint32 size = 4*kilo;

		unsigned char *x = (unsigned char *)(0x00200000-PAGE_SIZE);

		int i=0;
		for(;i< size+20;i++)
  800069:	ff 45 f4             	incl   -0xc(%ebp)
  80006c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80006f:	8d 50 14             	lea    0x14(%eax),%edx
  800072:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800075:	39 c2                	cmp    %eax,%edx
  800077:	77 e5                	ja     80005e <_main+0x26>
		{
			x[i]=-1;
		}

		panic("ERROR: FOS SHOULD NOT panic here, it should panic earlier in page_fault_handler(), since we have illegal access to page that is NOT EXIST in PF and NOT BELONGS to STACK. REMEMBER: creating new page in page file shouldn't be allowed except ONLY for new stack pages\n");
  800079:	83 ec 04             	sub    $0x4,%esp
  80007c:	68 e0 1a 80 00       	push   $0x801ae0
  800081:	6a 1a                	push   $0x1a
  800083:	68 e9 1b 80 00       	push   $0x801be9
  800088:	e8 3c 01 00 00       	call   8001c9 <_panic>

0080008d <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80008d:	55                   	push   %ebp
  80008e:	89 e5                	mov    %esp,%ebp
  800090:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800093:	e8 3b 15 00 00       	call   8015d3 <sys_getenvindex>
  800098:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80009b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80009e:	89 d0                	mov    %edx,%eax
  8000a0:	c1 e0 03             	shl    $0x3,%eax
  8000a3:	01 d0                	add    %edx,%eax
  8000a5:	01 c0                	add    %eax,%eax
  8000a7:	01 d0                	add    %edx,%eax
  8000a9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000b0:	01 d0                	add    %edx,%eax
  8000b2:	c1 e0 04             	shl    $0x4,%eax
  8000b5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000ba:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000bf:	a1 20 30 80 00       	mov    0x803020,%eax
  8000c4:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8000ca:	84 c0                	test   %al,%al
  8000cc:	74 0f                	je     8000dd <libmain+0x50>
		binaryname = myEnv->prog_name;
  8000ce:	a1 20 30 80 00       	mov    0x803020,%eax
  8000d3:	05 5c 05 00 00       	add    $0x55c,%eax
  8000d8:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000dd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000e1:	7e 0a                	jle    8000ed <libmain+0x60>
		binaryname = argv[0];
  8000e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000e6:	8b 00                	mov    (%eax),%eax
  8000e8:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8000ed:	83 ec 08             	sub    $0x8,%esp
  8000f0:	ff 75 0c             	pushl  0xc(%ebp)
  8000f3:	ff 75 08             	pushl  0x8(%ebp)
  8000f6:	e8 3d ff ff ff       	call   800038 <_main>
  8000fb:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8000fe:	e8 dd 12 00 00       	call   8013e0 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800103:	83 ec 0c             	sub    $0xc,%esp
  800106:	68 1c 1c 80 00       	push   $0x801c1c
  80010b:	e8 6d 03 00 00       	call   80047d <cprintf>
  800110:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800113:	a1 20 30 80 00       	mov    0x803020,%eax
  800118:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80011e:	a1 20 30 80 00       	mov    0x803020,%eax
  800123:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800129:	83 ec 04             	sub    $0x4,%esp
  80012c:	52                   	push   %edx
  80012d:	50                   	push   %eax
  80012e:	68 44 1c 80 00       	push   $0x801c44
  800133:	e8 45 03 00 00       	call   80047d <cprintf>
  800138:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80013b:	a1 20 30 80 00       	mov    0x803020,%eax
  800140:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800146:	a1 20 30 80 00       	mov    0x803020,%eax
  80014b:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800151:	a1 20 30 80 00       	mov    0x803020,%eax
  800156:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80015c:	51                   	push   %ecx
  80015d:	52                   	push   %edx
  80015e:	50                   	push   %eax
  80015f:	68 6c 1c 80 00       	push   $0x801c6c
  800164:	e8 14 03 00 00       	call   80047d <cprintf>
  800169:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80016c:	a1 20 30 80 00       	mov    0x803020,%eax
  800171:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800177:	83 ec 08             	sub    $0x8,%esp
  80017a:	50                   	push   %eax
  80017b:	68 c4 1c 80 00       	push   $0x801cc4
  800180:	e8 f8 02 00 00       	call   80047d <cprintf>
  800185:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	68 1c 1c 80 00       	push   $0x801c1c
  800190:	e8 e8 02 00 00       	call   80047d <cprintf>
  800195:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800198:	e8 5d 12 00 00       	call   8013fa <sys_enable_interrupt>

	// exit gracefully
	exit();
  80019d:	e8 19 00 00 00       	call   8001bb <exit>
}
  8001a2:	90                   	nop
  8001a3:	c9                   	leave  
  8001a4:	c3                   	ret    

008001a5 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001a5:	55                   	push   %ebp
  8001a6:	89 e5                	mov    %esp,%ebp
  8001a8:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	6a 00                	push   $0x0
  8001b0:	e8 ea 13 00 00       	call   80159f <sys_destroy_env>
  8001b5:	83 c4 10             	add    $0x10,%esp
}
  8001b8:	90                   	nop
  8001b9:	c9                   	leave  
  8001ba:	c3                   	ret    

008001bb <exit>:

void
exit(void)
{
  8001bb:	55                   	push   %ebp
  8001bc:	89 e5                	mov    %esp,%ebp
  8001be:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001c1:	e8 3f 14 00 00       	call   801605 <sys_exit_env>
}
  8001c6:	90                   	nop
  8001c7:	c9                   	leave  
  8001c8:	c3                   	ret    

008001c9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8001c9:	55                   	push   %ebp
  8001ca:	89 e5                	mov    %esp,%ebp
  8001cc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8001cf:	8d 45 10             	lea    0x10(%ebp),%eax
  8001d2:	83 c0 04             	add    $0x4,%eax
  8001d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8001d8:	a1 5c 31 80 00       	mov    0x80315c,%eax
  8001dd:	85 c0                	test   %eax,%eax
  8001df:	74 16                	je     8001f7 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8001e1:	a1 5c 31 80 00       	mov    0x80315c,%eax
  8001e6:	83 ec 08             	sub    $0x8,%esp
  8001e9:	50                   	push   %eax
  8001ea:	68 d8 1c 80 00       	push   $0x801cd8
  8001ef:	e8 89 02 00 00       	call   80047d <cprintf>
  8001f4:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8001f7:	a1 00 30 80 00       	mov    0x803000,%eax
  8001fc:	ff 75 0c             	pushl  0xc(%ebp)
  8001ff:	ff 75 08             	pushl  0x8(%ebp)
  800202:	50                   	push   %eax
  800203:	68 dd 1c 80 00       	push   $0x801cdd
  800208:	e8 70 02 00 00       	call   80047d <cprintf>
  80020d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800210:	8b 45 10             	mov    0x10(%ebp),%eax
  800213:	83 ec 08             	sub    $0x8,%esp
  800216:	ff 75 f4             	pushl  -0xc(%ebp)
  800219:	50                   	push   %eax
  80021a:	e8 f3 01 00 00       	call   800412 <vcprintf>
  80021f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800222:	83 ec 08             	sub    $0x8,%esp
  800225:	6a 00                	push   $0x0
  800227:	68 f9 1c 80 00       	push   $0x801cf9
  80022c:	e8 e1 01 00 00       	call   800412 <vcprintf>
  800231:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800234:	e8 82 ff ff ff       	call   8001bb <exit>

	// should not return here
	while (1) ;
  800239:	eb fe                	jmp    800239 <_panic+0x70>

0080023b <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80023b:	55                   	push   %ebp
  80023c:	89 e5                	mov    %esp,%ebp
  80023e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800241:	a1 20 30 80 00       	mov    0x803020,%eax
  800246:	8b 50 74             	mov    0x74(%eax),%edx
  800249:	8b 45 0c             	mov    0xc(%ebp),%eax
  80024c:	39 c2                	cmp    %eax,%edx
  80024e:	74 14                	je     800264 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800250:	83 ec 04             	sub    $0x4,%esp
  800253:	68 fc 1c 80 00       	push   $0x801cfc
  800258:	6a 26                	push   $0x26
  80025a:	68 48 1d 80 00       	push   $0x801d48
  80025f:	e8 65 ff ff ff       	call   8001c9 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800264:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80026b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800272:	e9 c2 00 00 00       	jmp    800339 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800277:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80027a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800281:	8b 45 08             	mov    0x8(%ebp),%eax
  800284:	01 d0                	add    %edx,%eax
  800286:	8b 00                	mov    (%eax),%eax
  800288:	85 c0                	test   %eax,%eax
  80028a:	75 08                	jne    800294 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80028c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80028f:	e9 a2 00 00 00       	jmp    800336 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800294:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80029b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8002a2:	eb 69                	jmp    80030d <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8002a4:	a1 20 30 80 00       	mov    0x803020,%eax
  8002a9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8002af:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002b2:	89 d0                	mov    %edx,%eax
  8002b4:	01 c0                	add    %eax,%eax
  8002b6:	01 d0                	add    %edx,%eax
  8002b8:	c1 e0 03             	shl    $0x3,%eax
  8002bb:	01 c8                	add    %ecx,%eax
  8002bd:	8a 40 04             	mov    0x4(%eax),%al
  8002c0:	84 c0                	test   %al,%al
  8002c2:	75 46                	jne    80030a <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002c4:	a1 20 30 80 00       	mov    0x803020,%eax
  8002c9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8002cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002d2:	89 d0                	mov    %edx,%eax
  8002d4:	01 c0                	add    %eax,%eax
  8002d6:	01 d0                	add    %edx,%eax
  8002d8:	c1 e0 03             	shl    $0x3,%eax
  8002db:	01 c8                	add    %ecx,%eax
  8002dd:	8b 00                	mov    (%eax),%eax
  8002df:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002e5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002ea:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8002ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002ef:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f9:	01 c8                	add    %ecx,%eax
  8002fb:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002fd:	39 c2                	cmp    %eax,%edx
  8002ff:	75 09                	jne    80030a <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800301:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800308:	eb 12                	jmp    80031c <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80030a:	ff 45 e8             	incl   -0x18(%ebp)
  80030d:	a1 20 30 80 00       	mov    0x803020,%eax
  800312:	8b 50 74             	mov    0x74(%eax),%edx
  800315:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800318:	39 c2                	cmp    %eax,%edx
  80031a:	77 88                	ja     8002a4 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80031c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800320:	75 14                	jne    800336 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800322:	83 ec 04             	sub    $0x4,%esp
  800325:	68 54 1d 80 00       	push   $0x801d54
  80032a:	6a 3a                	push   $0x3a
  80032c:	68 48 1d 80 00       	push   $0x801d48
  800331:	e8 93 fe ff ff       	call   8001c9 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800336:	ff 45 f0             	incl   -0x10(%ebp)
  800339:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80033f:	0f 8c 32 ff ff ff    	jl     800277 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800345:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80034c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800353:	eb 26                	jmp    80037b <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800355:	a1 20 30 80 00       	mov    0x803020,%eax
  80035a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800360:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800363:	89 d0                	mov    %edx,%eax
  800365:	01 c0                	add    %eax,%eax
  800367:	01 d0                	add    %edx,%eax
  800369:	c1 e0 03             	shl    $0x3,%eax
  80036c:	01 c8                	add    %ecx,%eax
  80036e:	8a 40 04             	mov    0x4(%eax),%al
  800371:	3c 01                	cmp    $0x1,%al
  800373:	75 03                	jne    800378 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800375:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800378:	ff 45 e0             	incl   -0x20(%ebp)
  80037b:	a1 20 30 80 00       	mov    0x803020,%eax
  800380:	8b 50 74             	mov    0x74(%eax),%edx
  800383:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800386:	39 c2                	cmp    %eax,%edx
  800388:	77 cb                	ja     800355 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80038a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80038d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800390:	74 14                	je     8003a6 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800392:	83 ec 04             	sub    $0x4,%esp
  800395:	68 a8 1d 80 00       	push   $0x801da8
  80039a:	6a 44                	push   $0x44
  80039c:	68 48 1d 80 00       	push   $0x801d48
  8003a1:	e8 23 fe ff ff       	call   8001c9 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8003a6:	90                   	nop
  8003a7:	c9                   	leave  
  8003a8:	c3                   	ret    

008003a9 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8003a9:	55                   	push   %ebp
  8003aa:	89 e5                	mov    %esp,%ebp
  8003ac:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8003af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b2:	8b 00                	mov    (%eax),%eax
  8003b4:	8d 48 01             	lea    0x1(%eax),%ecx
  8003b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003ba:	89 0a                	mov    %ecx,(%edx)
  8003bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8003bf:	88 d1                	mov    %dl,%cl
  8003c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003c4:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8003c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003cb:	8b 00                	mov    (%eax),%eax
  8003cd:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003d2:	75 2c                	jne    800400 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8003d4:	a0 24 30 80 00       	mov    0x803024,%al
  8003d9:	0f b6 c0             	movzbl %al,%eax
  8003dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003df:	8b 12                	mov    (%edx),%edx
  8003e1:	89 d1                	mov    %edx,%ecx
  8003e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003e6:	83 c2 08             	add    $0x8,%edx
  8003e9:	83 ec 04             	sub    $0x4,%esp
  8003ec:	50                   	push   %eax
  8003ed:	51                   	push   %ecx
  8003ee:	52                   	push   %edx
  8003ef:	e8 3e 0e 00 00       	call   801232 <sys_cputs>
  8003f4:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800400:	8b 45 0c             	mov    0xc(%ebp),%eax
  800403:	8b 40 04             	mov    0x4(%eax),%eax
  800406:	8d 50 01             	lea    0x1(%eax),%edx
  800409:	8b 45 0c             	mov    0xc(%ebp),%eax
  80040c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80040f:	90                   	nop
  800410:	c9                   	leave  
  800411:	c3                   	ret    

00800412 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800412:	55                   	push   %ebp
  800413:	89 e5                	mov    %esp,%ebp
  800415:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80041b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800422:	00 00 00 
	b.cnt = 0;
  800425:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80042c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80042f:	ff 75 0c             	pushl  0xc(%ebp)
  800432:	ff 75 08             	pushl  0x8(%ebp)
  800435:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80043b:	50                   	push   %eax
  80043c:	68 a9 03 80 00       	push   $0x8003a9
  800441:	e8 11 02 00 00       	call   800657 <vprintfmt>
  800446:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800449:	a0 24 30 80 00       	mov    0x803024,%al
  80044e:	0f b6 c0             	movzbl %al,%eax
  800451:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800457:	83 ec 04             	sub    $0x4,%esp
  80045a:	50                   	push   %eax
  80045b:	52                   	push   %edx
  80045c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800462:	83 c0 08             	add    $0x8,%eax
  800465:	50                   	push   %eax
  800466:	e8 c7 0d 00 00       	call   801232 <sys_cputs>
  80046b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80046e:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800475:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80047b:	c9                   	leave  
  80047c:	c3                   	ret    

0080047d <cprintf>:

int cprintf(const char *fmt, ...) {
  80047d:	55                   	push   %ebp
  80047e:	89 e5                	mov    %esp,%ebp
  800480:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800483:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  80048a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80048d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800490:	8b 45 08             	mov    0x8(%ebp),%eax
  800493:	83 ec 08             	sub    $0x8,%esp
  800496:	ff 75 f4             	pushl  -0xc(%ebp)
  800499:	50                   	push   %eax
  80049a:	e8 73 ff ff ff       	call   800412 <vcprintf>
  80049f:	83 c4 10             	add    $0x10,%esp
  8004a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8004a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004a8:	c9                   	leave  
  8004a9:	c3                   	ret    

008004aa <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8004aa:	55                   	push   %ebp
  8004ab:	89 e5                	mov    %esp,%ebp
  8004ad:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8004b0:	e8 2b 0f 00 00       	call   8013e0 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004b5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8004bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004be:	83 ec 08             	sub    $0x8,%esp
  8004c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8004c4:	50                   	push   %eax
  8004c5:	e8 48 ff ff ff       	call   800412 <vcprintf>
  8004ca:	83 c4 10             	add    $0x10,%esp
  8004cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8004d0:	e8 25 0f 00 00       	call   8013fa <sys_enable_interrupt>
	return cnt;
  8004d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004d8:	c9                   	leave  
  8004d9:	c3                   	ret    

008004da <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004da:	55                   	push   %ebp
  8004db:	89 e5                	mov    %esp,%ebp
  8004dd:	53                   	push   %ebx
  8004de:	83 ec 14             	sub    $0x14,%esp
  8004e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8004e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004ed:	8b 45 18             	mov    0x18(%ebp),%eax
  8004f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8004f5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004f8:	77 55                	ja     80054f <printnum+0x75>
  8004fa:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004fd:	72 05                	jb     800504 <printnum+0x2a>
  8004ff:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800502:	77 4b                	ja     80054f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800504:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800507:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80050a:	8b 45 18             	mov    0x18(%ebp),%eax
  80050d:	ba 00 00 00 00       	mov    $0x0,%edx
  800512:	52                   	push   %edx
  800513:	50                   	push   %eax
  800514:	ff 75 f4             	pushl  -0xc(%ebp)
  800517:	ff 75 f0             	pushl  -0x10(%ebp)
  80051a:	e8 49 13 00 00       	call   801868 <__udivdi3>
  80051f:	83 c4 10             	add    $0x10,%esp
  800522:	83 ec 04             	sub    $0x4,%esp
  800525:	ff 75 20             	pushl  0x20(%ebp)
  800528:	53                   	push   %ebx
  800529:	ff 75 18             	pushl  0x18(%ebp)
  80052c:	52                   	push   %edx
  80052d:	50                   	push   %eax
  80052e:	ff 75 0c             	pushl  0xc(%ebp)
  800531:	ff 75 08             	pushl  0x8(%ebp)
  800534:	e8 a1 ff ff ff       	call   8004da <printnum>
  800539:	83 c4 20             	add    $0x20,%esp
  80053c:	eb 1a                	jmp    800558 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80053e:	83 ec 08             	sub    $0x8,%esp
  800541:	ff 75 0c             	pushl  0xc(%ebp)
  800544:	ff 75 20             	pushl  0x20(%ebp)
  800547:	8b 45 08             	mov    0x8(%ebp),%eax
  80054a:	ff d0                	call   *%eax
  80054c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80054f:	ff 4d 1c             	decl   0x1c(%ebp)
  800552:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800556:	7f e6                	jg     80053e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800558:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80055b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800560:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800563:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800566:	53                   	push   %ebx
  800567:	51                   	push   %ecx
  800568:	52                   	push   %edx
  800569:	50                   	push   %eax
  80056a:	e8 09 14 00 00       	call   801978 <__umoddi3>
  80056f:	83 c4 10             	add    $0x10,%esp
  800572:	05 14 20 80 00       	add    $0x802014,%eax
  800577:	8a 00                	mov    (%eax),%al
  800579:	0f be c0             	movsbl %al,%eax
  80057c:	83 ec 08             	sub    $0x8,%esp
  80057f:	ff 75 0c             	pushl  0xc(%ebp)
  800582:	50                   	push   %eax
  800583:	8b 45 08             	mov    0x8(%ebp),%eax
  800586:	ff d0                	call   *%eax
  800588:	83 c4 10             	add    $0x10,%esp
}
  80058b:	90                   	nop
  80058c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80058f:	c9                   	leave  
  800590:	c3                   	ret    

00800591 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800591:	55                   	push   %ebp
  800592:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800594:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800598:	7e 1c                	jle    8005b6 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80059a:	8b 45 08             	mov    0x8(%ebp),%eax
  80059d:	8b 00                	mov    (%eax),%eax
  80059f:	8d 50 08             	lea    0x8(%eax),%edx
  8005a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a5:	89 10                	mov    %edx,(%eax)
  8005a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005aa:	8b 00                	mov    (%eax),%eax
  8005ac:	83 e8 08             	sub    $0x8,%eax
  8005af:	8b 50 04             	mov    0x4(%eax),%edx
  8005b2:	8b 00                	mov    (%eax),%eax
  8005b4:	eb 40                	jmp    8005f6 <getuint+0x65>
	else if (lflag)
  8005b6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005ba:	74 1e                	je     8005da <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8005bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bf:	8b 00                	mov    (%eax),%eax
  8005c1:	8d 50 04             	lea    0x4(%eax),%edx
  8005c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c7:	89 10                	mov    %edx,(%eax)
  8005c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cc:	8b 00                	mov    (%eax),%eax
  8005ce:	83 e8 04             	sub    $0x4,%eax
  8005d1:	8b 00                	mov    (%eax),%eax
  8005d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d8:	eb 1c                	jmp    8005f6 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005da:	8b 45 08             	mov    0x8(%ebp),%eax
  8005dd:	8b 00                	mov    (%eax),%eax
  8005df:	8d 50 04             	lea    0x4(%eax),%edx
  8005e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e5:	89 10                	mov    %edx,(%eax)
  8005e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ea:	8b 00                	mov    (%eax),%eax
  8005ec:	83 e8 04             	sub    $0x4,%eax
  8005ef:	8b 00                	mov    (%eax),%eax
  8005f1:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005f6:	5d                   	pop    %ebp
  8005f7:	c3                   	ret    

008005f8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005f8:	55                   	push   %ebp
  8005f9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005fb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005ff:	7e 1c                	jle    80061d <getint+0x25>
		return va_arg(*ap, long long);
  800601:	8b 45 08             	mov    0x8(%ebp),%eax
  800604:	8b 00                	mov    (%eax),%eax
  800606:	8d 50 08             	lea    0x8(%eax),%edx
  800609:	8b 45 08             	mov    0x8(%ebp),%eax
  80060c:	89 10                	mov    %edx,(%eax)
  80060e:	8b 45 08             	mov    0x8(%ebp),%eax
  800611:	8b 00                	mov    (%eax),%eax
  800613:	83 e8 08             	sub    $0x8,%eax
  800616:	8b 50 04             	mov    0x4(%eax),%edx
  800619:	8b 00                	mov    (%eax),%eax
  80061b:	eb 38                	jmp    800655 <getint+0x5d>
	else if (lflag)
  80061d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800621:	74 1a                	je     80063d <getint+0x45>
		return va_arg(*ap, long);
  800623:	8b 45 08             	mov    0x8(%ebp),%eax
  800626:	8b 00                	mov    (%eax),%eax
  800628:	8d 50 04             	lea    0x4(%eax),%edx
  80062b:	8b 45 08             	mov    0x8(%ebp),%eax
  80062e:	89 10                	mov    %edx,(%eax)
  800630:	8b 45 08             	mov    0x8(%ebp),%eax
  800633:	8b 00                	mov    (%eax),%eax
  800635:	83 e8 04             	sub    $0x4,%eax
  800638:	8b 00                	mov    (%eax),%eax
  80063a:	99                   	cltd   
  80063b:	eb 18                	jmp    800655 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80063d:	8b 45 08             	mov    0x8(%ebp),%eax
  800640:	8b 00                	mov    (%eax),%eax
  800642:	8d 50 04             	lea    0x4(%eax),%edx
  800645:	8b 45 08             	mov    0x8(%ebp),%eax
  800648:	89 10                	mov    %edx,(%eax)
  80064a:	8b 45 08             	mov    0x8(%ebp),%eax
  80064d:	8b 00                	mov    (%eax),%eax
  80064f:	83 e8 04             	sub    $0x4,%eax
  800652:	8b 00                	mov    (%eax),%eax
  800654:	99                   	cltd   
}
  800655:	5d                   	pop    %ebp
  800656:	c3                   	ret    

00800657 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800657:	55                   	push   %ebp
  800658:	89 e5                	mov    %esp,%ebp
  80065a:	56                   	push   %esi
  80065b:	53                   	push   %ebx
  80065c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80065f:	eb 17                	jmp    800678 <vprintfmt+0x21>
			if (ch == '\0')
  800661:	85 db                	test   %ebx,%ebx
  800663:	0f 84 af 03 00 00    	je     800a18 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800669:	83 ec 08             	sub    $0x8,%esp
  80066c:	ff 75 0c             	pushl  0xc(%ebp)
  80066f:	53                   	push   %ebx
  800670:	8b 45 08             	mov    0x8(%ebp),%eax
  800673:	ff d0                	call   *%eax
  800675:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800678:	8b 45 10             	mov    0x10(%ebp),%eax
  80067b:	8d 50 01             	lea    0x1(%eax),%edx
  80067e:	89 55 10             	mov    %edx,0x10(%ebp)
  800681:	8a 00                	mov    (%eax),%al
  800683:	0f b6 d8             	movzbl %al,%ebx
  800686:	83 fb 25             	cmp    $0x25,%ebx
  800689:	75 d6                	jne    800661 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80068b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80068f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800696:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80069d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8006a4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8006ae:	8d 50 01             	lea    0x1(%eax),%edx
  8006b1:	89 55 10             	mov    %edx,0x10(%ebp)
  8006b4:	8a 00                	mov    (%eax),%al
  8006b6:	0f b6 d8             	movzbl %al,%ebx
  8006b9:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8006bc:	83 f8 55             	cmp    $0x55,%eax
  8006bf:	0f 87 2b 03 00 00    	ja     8009f0 <vprintfmt+0x399>
  8006c5:	8b 04 85 38 20 80 00 	mov    0x802038(,%eax,4),%eax
  8006cc:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006ce:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006d2:	eb d7                	jmp    8006ab <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006d4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006d8:	eb d1                	jmp    8006ab <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006da:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006e1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006e4:	89 d0                	mov    %edx,%eax
  8006e6:	c1 e0 02             	shl    $0x2,%eax
  8006e9:	01 d0                	add    %edx,%eax
  8006eb:	01 c0                	add    %eax,%eax
  8006ed:	01 d8                	add    %ebx,%eax
  8006ef:	83 e8 30             	sub    $0x30,%eax
  8006f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8006f8:	8a 00                	mov    (%eax),%al
  8006fa:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006fd:	83 fb 2f             	cmp    $0x2f,%ebx
  800700:	7e 3e                	jle    800740 <vprintfmt+0xe9>
  800702:	83 fb 39             	cmp    $0x39,%ebx
  800705:	7f 39                	jg     800740 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800707:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80070a:	eb d5                	jmp    8006e1 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80070c:	8b 45 14             	mov    0x14(%ebp),%eax
  80070f:	83 c0 04             	add    $0x4,%eax
  800712:	89 45 14             	mov    %eax,0x14(%ebp)
  800715:	8b 45 14             	mov    0x14(%ebp),%eax
  800718:	83 e8 04             	sub    $0x4,%eax
  80071b:	8b 00                	mov    (%eax),%eax
  80071d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800720:	eb 1f                	jmp    800741 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800722:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800726:	79 83                	jns    8006ab <vprintfmt+0x54>
				width = 0;
  800728:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80072f:	e9 77 ff ff ff       	jmp    8006ab <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800734:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80073b:	e9 6b ff ff ff       	jmp    8006ab <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800740:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800741:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800745:	0f 89 60 ff ff ff    	jns    8006ab <vprintfmt+0x54>
				width = precision, precision = -1;
  80074b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80074e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800751:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800758:	e9 4e ff ff ff       	jmp    8006ab <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80075d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800760:	e9 46 ff ff ff       	jmp    8006ab <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800765:	8b 45 14             	mov    0x14(%ebp),%eax
  800768:	83 c0 04             	add    $0x4,%eax
  80076b:	89 45 14             	mov    %eax,0x14(%ebp)
  80076e:	8b 45 14             	mov    0x14(%ebp),%eax
  800771:	83 e8 04             	sub    $0x4,%eax
  800774:	8b 00                	mov    (%eax),%eax
  800776:	83 ec 08             	sub    $0x8,%esp
  800779:	ff 75 0c             	pushl  0xc(%ebp)
  80077c:	50                   	push   %eax
  80077d:	8b 45 08             	mov    0x8(%ebp),%eax
  800780:	ff d0                	call   *%eax
  800782:	83 c4 10             	add    $0x10,%esp
			break;
  800785:	e9 89 02 00 00       	jmp    800a13 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80078a:	8b 45 14             	mov    0x14(%ebp),%eax
  80078d:	83 c0 04             	add    $0x4,%eax
  800790:	89 45 14             	mov    %eax,0x14(%ebp)
  800793:	8b 45 14             	mov    0x14(%ebp),%eax
  800796:	83 e8 04             	sub    $0x4,%eax
  800799:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80079b:	85 db                	test   %ebx,%ebx
  80079d:	79 02                	jns    8007a1 <vprintfmt+0x14a>
				err = -err;
  80079f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8007a1:	83 fb 64             	cmp    $0x64,%ebx
  8007a4:	7f 0b                	jg     8007b1 <vprintfmt+0x15a>
  8007a6:	8b 34 9d 80 1e 80 00 	mov    0x801e80(,%ebx,4),%esi
  8007ad:	85 f6                	test   %esi,%esi
  8007af:	75 19                	jne    8007ca <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8007b1:	53                   	push   %ebx
  8007b2:	68 25 20 80 00       	push   $0x802025
  8007b7:	ff 75 0c             	pushl  0xc(%ebp)
  8007ba:	ff 75 08             	pushl  0x8(%ebp)
  8007bd:	e8 5e 02 00 00       	call   800a20 <printfmt>
  8007c2:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007c5:	e9 49 02 00 00       	jmp    800a13 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007ca:	56                   	push   %esi
  8007cb:	68 2e 20 80 00       	push   $0x80202e
  8007d0:	ff 75 0c             	pushl  0xc(%ebp)
  8007d3:	ff 75 08             	pushl  0x8(%ebp)
  8007d6:	e8 45 02 00 00       	call   800a20 <printfmt>
  8007db:	83 c4 10             	add    $0x10,%esp
			break;
  8007de:	e9 30 02 00 00       	jmp    800a13 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e6:	83 c0 04             	add    $0x4,%eax
  8007e9:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ef:	83 e8 04             	sub    $0x4,%eax
  8007f2:	8b 30                	mov    (%eax),%esi
  8007f4:	85 f6                	test   %esi,%esi
  8007f6:	75 05                	jne    8007fd <vprintfmt+0x1a6>
				p = "(null)";
  8007f8:	be 31 20 80 00       	mov    $0x802031,%esi
			if (width > 0 && padc != '-')
  8007fd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800801:	7e 6d                	jle    800870 <vprintfmt+0x219>
  800803:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800807:	74 67                	je     800870 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800809:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80080c:	83 ec 08             	sub    $0x8,%esp
  80080f:	50                   	push   %eax
  800810:	56                   	push   %esi
  800811:	e8 0c 03 00 00       	call   800b22 <strnlen>
  800816:	83 c4 10             	add    $0x10,%esp
  800819:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80081c:	eb 16                	jmp    800834 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80081e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800822:	83 ec 08             	sub    $0x8,%esp
  800825:	ff 75 0c             	pushl  0xc(%ebp)
  800828:	50                   	push   %eax
  800829:	8b 45 08             	mov    0x8(%ebp),%eax
  80082c:	ff d0                	call   *%eax
  80082e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800831:	ff 4d e4             	decl   -0x1c(%ebp)
  800834:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800838:	7f e4                	jg     80081e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80083a:	eb 34                	jmp    800870 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80083c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800840:	74 1c                	je     80085e <vprintfmt+0x207>
  800842:	83 fb 1f             	cmp    $0x1f,%ebx
  800845:	7e 05                	jle    80084c <vprintfmt+0x1f5>
  800847:	83 fb 7e             	cmp    $0x7e,%ebx
  80084a:	7e 12                	jle    80085e <vprintfmt+0x207>
					putch('?', putdat);
  80084c:	83 ec 08             	sub    $0x8,%esp
  80084f:	ff 75 0c             	pushl  0xc(%ebp)
  800852:	6a 3f                	push   $0x3f
  800854:	8b 45 08             	mov    0x8(%ebp),%eax
  800857:	ff d0                	call   *%eax
  800859:	83 c4 10             	add    $0x10,%esp
  80085c:	eb 0f                	jmp    80086d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80085e:	83 ec 08             	sub    $0x8,%esp
  800861:	ff 75 0c             	pushl  0xc(%ebp)
  800864:	53                   	push   %ebx
  800865:	8b 45 08             	mov    0x8(%ebp),%eax
  800868:	ff d0                	call   *%eax
  80086a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80086d:	ff 4d e4             	decl   -0x1c(%ebp)
  800870:	89 f0                	mov    %esi,%eax
  800872:	8d 70 01             	lea    0x1(%eax),%esi
  800875:	8a 00                	mov    (%eax),%al
  800877:	0f be d8             	movsbl %al,%ebx
  80087a:	85 db                	test   %ebx,%ebx
  80087c:	74 24                	je     8008a2 <vprintfmt+0x24b>
  80087e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800882:	78 b8                	js     80083c <vprintfmt+0x1e5>
  800884:	ff 4d e0             	decl   -0x20(%ebp)
  800887:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80088b:	79 af                	jns    80083c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80088d:	eb 13                	jmp    8008a2 <vprintfmt+0x24b>
				putch(' ', putdat);
  80088f:	83 ec 08             	sub    $0x8,%esp
  800892:	ff 75 0c             	pushl  0xc(%ebp)
  800895:	6a 20                	push   $0x20
  800897:	8b 45 08             	mov    0x8(%ebp),%eax
  80089a:	ff d0                	call   *%eax
  80089c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80089f:	ff 4d e4             	decl   -0x1c(%ebp)
  8008a2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008a6:	7f e7                	jg     80088f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8008a8:	e9 66 01 00 00       	jmp    800a13 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8008ad:	83 ec 08             	sub    $0x8,%esp
  8008b0:	ff 75 e8             	pushl  -0x18(%ebp)
  8008b3:	8d 45 14             	lea    0x14(%ebp),%eax
  8008b6:	50                   	push   %eax
  8008b7:	e8 3c fd ff ff       	call   8005f8 <getint>
  8008bc:	83 c4 10             	add    $0x10,%esp
  8008bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008c2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008cb:	85 d2                	test   %edx,%edx
  8008cd:	79 23                	jns    8008f2 <vprintfmt+0x29b>
				putch('-', putdat);
  8008cf:	83 ec 08             	sub    $0x8,%esp
  8008d2:	ff 75 0c             	pushl  0xc(%ebp)
  8008d5:	6a 2d                	push   $0x2d
  8008d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008da:	ff d0                	call   *%eax
  8008dc:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008e5:	f7 d8                	neg    %eax
  8008e7:	83 d2 00             	adc    $0x0,%edx
  8008ea:	f7 da                	neg    %edx
  8008ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008ef:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008f2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008f9:	e9 bc 00 00 00       	jmp    8009ba <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008fe:	83 ec 08             	sub    $0x8,%esp
  800901:	ff 75 e8             	pushl  -0x18(%ebp)
  800904:	8d 45 14             	lea    0x14(%ebp),%eax
  800907:	50                   	push   %eax
  800908:	e8 84 fc ff ff       	call   800591 <getuint>
  80090d:	83 c4 10             	add    $0x10,%esp
  800910:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800913:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800916:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80091d:	e9 98 00 00 00       	jmp    8009ba <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800922:	83 ec 08             	sub    $0x8,%esp
  800925:	ff 75 0c             	pushl  0xc(%ebp)
  800928:	6a 58                	push   $0x58
  80092a:	8b 45 08             	mov    0x8(%ebp),%eax
  80092d:	ff d0                	call   *%eax
  80092f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800932:	83 ec 08             	sub    $0x8,%esp
  800935:	ff 75 0c             	pushl  0xc(%ebp)
  800938:	6a 58                	push   $0x58
  80093a:	8b 45 08             	mov    0x8(%ebp),%eax
  80093d:	ff d0                	call   *%eax
  80093f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800942:	83 ec 08             	sub    $0x8,%esp
  800945:	ff 75 0c             	pushl  0xc(%ebp)
  800948:	6a 58                	push   $0x58
  80094a:	8b 45 08             	mov    0x8(%ebp),%eax
  80094d:	ff d0                	call   *%eax
  80094f:	83 c4 10             	add    $0x10,%esp
			break;
  800952:	e9 bc 00 00 00       	jmp    800a13 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800957:	83 ec 08             	sub    $0x8,%esp
  80095a:	ff 75 0c             	pushl  0xc(%ebp)
  80095d:	6a 30                	push   $0x30
  80095f:	8b 45 08             	mov    0x8(%ebp),%eax
  800962:	ff d0                	call   *%eax
  800964:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800967:	83 ec 08             	sub    $0x8,%esp
  80096a:	ff 75 0c             	pushl  0xc(%ebp)
  80096d:	6a 78                	push   $0x78
  80096f:	8b 45 08             	mov    0x8(%ebp),%eax
  800972:	ff d0                	call   *%eax
  800974:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800977:	8b 45 14             	mov    0x14(%ebp),%eax
  80097a:	83 c0 04             	add    $0x4,%eax
  80097d:	89 45 14             	mov    %eax,0x14(%ebp)
  800980:	8b 45 14             	mov    0x14(%ebp),%eax
  800983:	83 e8 04             	sub    $0x4,%eax
  800986:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800988:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80098b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800992:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800999:	eb 1f                	jmp    8009ba <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80099b:	83 ec 08             	sub    $0x8,%esp
  80099e:	ff 75 e8             	pushl  -0x18(%ebp)
  8009a1:	8d 45 14             	lea    0x14(%ebp),%eax
  8009a4:	50                   	push   %eax
  8009a5:	e8 e7 fb ff ff       	call   800591 <getuint>
  8009aa:	83 c4 10             	add    $0x10,%esp
  8009ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009b0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8009b3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8009ba:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8009be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009c1:	83 ec 04             	sub    $0x4,%esp
  8009c4:	52                   	push   %edx
  8009c5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009c8:	50                   	push   %eax
  8009c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8009cc:	ff 75 f0             	pushl  -0x10(%ebp)
  8009cf:	ff 75 0c             	pushl  0xc(%ebp)
  8009d2:	ff 75 08             	pushl  0x8(%ebp)
  8009d5:	e8 00 fb ff ff       	call   8004da <printnum>
  8009da:	83 c4 20             	add    $0x20,%esp
			break;
  8009dd:	eb 34                	jmp    800a13 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009df:	83 ec 08             	sub    $0x8,%esp
  8009e2:	ff 75 0c             	pushl  0xc(%ebp)
  8009e5:	53                   	push   %ebx
  8009e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e9:	ff d0                	call   *%eax
  8009eb:	83 c4 10             	add    $0x10,%esp
			break;
  8009ee:	eb 23                	jmp    800a13 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009f0:	83 ec 08             	sub    $0x8,%esp
  8009f3:	ff 75 0c             	pushl  0xc(%ebp)
  8009f6:	6a 25                	push   $0x25
  8009f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fb:	ff d0                	call   *%eax
  8009fd:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a00:	ff 4d 10             	decl   0x10(%ebp)
  800a03:	eb 03                	jmp    800a08 <vprintfmt+0x3b1>
  800a05:	ff 4d 10             	decl   0x10(%ebp)
  800a08:	8b 45 10             	mov    0x10(%ebp),%eax
  800a0b:	48                   	dec    %eax
  800a0c:	8a 00                	mov    (%eax),%al
  800a0e:	3c 25                	cmp    $0x25,%al
  800a10:	75 f3                	jne    800a05 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800a12:	90                   	nop
		}
	}
  800a13:	e9 47 fc ff ff       	jmp    80065f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800a18:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a19:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a1c:	5b                   	pop    %ebx
  800a1d:	5e                   	pop    %esi
  800a1e:	5d                   	pop    %ebp
  800a1f:	c3                   	ret    

00800a20 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a20:	55                   	push   %ebp
  800a21:	89 e5                	mov    %esp,%ebp
  800a23:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a26:	8d 45 10             	lea    0x10(%ebp),%eax
  800a29:	83 c0 04             	add    $0x4,%eax
  800a2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800a32:	ff 75 f4             	pushl  -0xc(%ebp)
  800a35:	50                   	push   %eax
  800a36:	ff 75 0c             	pushl  0xc(%ebp)
  800a39:	ff 75 08             	pushl  0x8(%ebp)
  800a3c:	e8 16 fc ff ff       	call   800657 <vprintfmt>
  800a41:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a44:	90                   	nop
  800a45:	c9                   	leave  
  800a46:	c3                   	ret    

00800a47 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a47:	55                   	push   %ebp
  800a48:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4d:	8b 40 08             	mov    0x8(%eax),%eax
  800a50:	8d 50 01             	lea    0x1(%eax),%edx
  800a53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a56:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5c:	8b 10                	mov    (%eax),%edx
  800a5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a61:	8b 40 04             	mov    0x4(%eax),%eax
  800a64:	39 c2                	cmp    %eax,%edx
  800a66:	73 12                	jae    800a7a <sprintputch+0x33>
		*b->buf++ = ch;
  800a68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6b:	8b 00                	mov    (%eax),%eax
  800a6d:	8d 48 01             	lea    0x1(%eax),%ecx
  800a70:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a73:	89 0a                	mov    %ecx,(%edx)
  800a75:	8b 55 08             	mov    0x8(%ebp),%edx
  800a78:	88 10                	mov    %dl,(%eax)
}
  800a7a:	90                   	nop
  800a7b:	5d                   	pop    %ebp
  800a7c:	c3                   	ret    

00800a7d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a7d:	55                   	push   %ebp
  800a7e:	89 e5                	mov    %esp,%ebp
  800a80:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a83:	8b 45 08             	mov    0x8(%ebp),%eax
  800a86:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a92:	01 d0                	add    %edx,%eax
  800a94:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a97:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a9e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800aa2:	74 06                	je     800aaa <vsnprintf+0x2d>
  800aa4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800aa8:	7f 07                	jg     800ab1 <vsnprintf+0x34>
		return -E_INVAL;
  800aaa:	b8 03 00 00 00       	mov    $0x3,%eax
  800aaf:	eb 20                	jmp    800ad1 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ab1:	ff 75 14             	pushl  0x14(%ebp)
  800ab4:	ff 75 10             	pushl  0x10(%ebp)
  800ab7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800aba:	50                   	push   %eax
  800abb:	68 47 0a 80 00       	push   $0x800a47
  800ac0:	e8 92 fb ff ff       	call   800657 <vprintfmt>
  800ac5:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ac8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800acb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ad1:	c9                   	leave  
  800ad2:	c3                   	ret    

00800ad3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ad3:	55                   	push   %ebp
  800ad4:	89 e5                	mov    %esp,%ebp
  800ad6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ad9:	8d 45 10             	lea    0x10(%ebp),%eax
  800adc:	83 c0 04             	add    $0x4,%eax
  800adf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ae2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ae8:	50                   	push   %eax
  800ae9:	ff 75 0c             	pushl  0xc(%ebp)
  800aec:	ff 75 08             	pushl  0x8(%ebp)
  800aef:	e8 89 ff ff ff       	call   800a7d <vsnprintf>
  800af4:	83 c4 10             	add    $0x10,%esp
  800af7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800afa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800afd:	c9                   	leave  
  800afe:	c3                   	ret    

00800aff <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800aff:	55                   	push   %ebp
  800b00:	89 e5                	mov    %esp,%ebp
  800b02:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b05:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b0c:	eb 06                	jmp    800b14 <strlen+0x15>
		n++;
  800b0e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b11:	ff 45 08             	incl   0x8(%ebp)
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	8a 00                	mov    (%eax),%al
  800b19:	84 c0                	test   %al,%al
  800b1b:	75 f1                	jne    800b0e <strlen+0xf>
		n++;
	return n;
  800b1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b20:	c9                   	leave  
  800b21:	c3                   	ret    

00800b22 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b22:	55                   	push   %ebp
  800b23:	89 e5                	mov    %esp,%ebp
  800b25:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b28:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b2f:	eb 09                	jmp    800b3a <strnlen+0x18>
		n++;
  800b31:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b34:	ff 45 08             	incl   0x8(%ebp)
  800b37:	ff 4d 0c             	decl   0xc(%ebp)
  800b3a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b3e:	74 09                	je     800b49 <strnlen+0x27>
  800b40:	8b 45 08             	mov    0x8(%ebp),%eax
  800b43:	8a 00                	mov    (%eax),%al
  800b45:	84 c0                	test   %al,%al
  800b47:	75 e8                	jne    800b31 <strnlen+0xf>
		n++;
	return n;
  800b49:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b4c:	c9                   	leave  
  800b4d:	c3                   	ret    

00800b4e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b4e:	55                   	push   %ebp
  800b4f:	89 e5                	mov    %esp,%ebp
  800b51:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b54:	8b 45 08             	mov    0x8(%ebp),%eax
  800b57:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b5a:	90                   	nop
  800b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5e:	8d 50 01             	lea    0x1(%eax),%edx
  800b61:	89 55 08             	mov    %edx,0x8(%ebp)
  800b64:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b67:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b6a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b6d:	8a 12                	mov    (%edx),%dl
  800b6f:	88 10                	mov    %dl,(%eax)
  800b71:	8a 00                	mov    (%eax),%al
  800b73:	84 c0                	test   %al,%al
  800b75:	75 e4                	jne    800b5b <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b77:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b7a:	c9                   	leave  
  800b7b:	c3                   	ret    

00800b7c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b7c:	55                   	push   %ebp
  800b7d:	89 e5                	mov    %esp,%ebp
  800b7f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b82:	8b 45 08             	mov    0x8(%ebp),%eax
  800b85:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b88:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b8f:	eb 1f                	jmp    800bb0 <strncpy+0x34>
		*dst++ = *src;
  800b91:	8b 45 08             	mov    0x8(%ebp),%eax
  800b94:	8d 50 01             	lea    0x1(%eax),%edx
  800b97:	89 55 08             	mov    %edx,0x8(%ebp)
  800b9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b9d:	8a 12                	mov    (%edx),%dl
  800b9f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ba1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba4:	8a 00                	mov    (%eax),%al
  800ba6:	84 c0                	test   %al,%al
  800ba8:	74 03                	je     800bad <strncpy+0x31>
			src++;
  800baa:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bad:	ff 45 fc             	incl   -0x4(%ebp)
  800bb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bb3:	3b 45 10             	cmp    0x10(%ebp),%eax
  800bb6:	72 d9                	jb     800b91 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800bb8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800bbb:	c9                   	leave  
  800bbc:	c3                   	ret    

00800bbd <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800bbd:	55                   	push   %ebp
  800bbe:	89 e5                	mov    %esp,%ebp
  800bc0:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800bc9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bcd:	74 30                	je     800bff <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800bcf:	eb 16                	jmp    800be7 <strlcpy+0x2a>
			*dst++ = *src++;
  800bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd4:	8d 50 01             	lea    0x1(%eax),%edx
  800bd7:	89 55 08             	mov    %edx,0x8(%ebp)
  800bda:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bdd:	8d 4a 01             	lea    0x1(%edx),%ecx
  800be0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800be3:	8a 12                	mov    (%edx),%dl
  800be5:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800be7:	ff 4d 10             	decl   0x10(%ebp)
  800bea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bee:	74 09                	je     800bf9 <strlcpy+0x3c>
  800bf0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf3:	8a 00                	mov    (%eax),%al
  800bf5:	84 c0                	test   %al,%al
  800bf7:	75 d8                	jne    800bd1 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfc:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bff:	8b 55 08             	mov    0x8(%ebp),%edx
  800c02:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c05:	29 c2                	sub    %eax,%edx
  800c07:	89 d0                	mov    %edx,%eax
}
  800c09:	c9                   	leave  
  800c0a:	c3                   	ret    

00800c0b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c0b:	55                   	push   %ebp
  800c0c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c0e:	eb 06                	jmp    800c16 <strcmp+0xb>
		p++, q++;
  800c10:	ff 45 08             	incl   0x8(%ebp)
  800c13:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
  800c19:	8a 00                	mov    (%eax),%al
  800c1b:	84 c0                	test   %al,%al
  800c1d:	74 0e                	je     800c2d <strcmp+0x22>
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c22:	8a 10                	mov    (%eax),%dl
  800c24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c27:	8a 00                	mov    (%eax),%al
  800c29:	38 c2                	cmp    %al,%dl
  800c2b:	74 e3                	je     800c10 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c30:	8a 00                	mov    (%eax),%al
  800c32:	0f b6 d0             	movzbl %al,%edx
  800c35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c38:	8a 00                	mov    (%eax),%al
  800c3a:	0f b6 c0             	movzbl %al,%eax
  800c3d:	29 c2                	sub    %eax,%edx
  800c3f:	89 d0                	mov    %edx,%eax
}
  800c41:	5d                   	pop    %ebp
  800c42:	c3                   	ret    

00800c43 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c43:	55                   	push   %ebp
  800c44:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c46:	eb 09                	jmp    800c51 <strncmp+0xe>
		n--, p++, q++;
  800c48:	ff 4d 10             	decl   0x10(%ebp)
  800c4b:	ff 45 08             	incl   0x8(%ebp)
  800c4e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c51:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c55:	74 17                	je     800c6e <strncmp+0x2b>
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	8a 00                	mov    (%eax),%al
  800c5c:	84 c0                	test   %al,%al
  800c5e:	74 0e                	je     800c6e <strncmp+0x2b>
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	8a 10                	mov    (%eax),%dl
  800c65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c68:	8a 00                	mov    (%eax),%al
  800c6a:	38 c2                	cmp    %al,%dl
  800c6c:	74 da                	je     800c48 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c6e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c72:	75 07                	jne    800c7b <strncmp+0x38>
		return 0;
  800c74:	b8 00 00 00 00       	mov    $0x0,%eax
  800c79:	eb 14                	jmp    800c8f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7e:	8a 00                	mov    (%eax),%al
  800c80:	0f b6 d0             	movzbl %al,%edx
  800c83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c86:	8a 00                	mov    (%eax),%al
  800c88:	0f b6 c0             	movzbl %al,%eax
  800c8b:	29 c2                	sub    %eax,%edx
  800c8d:	89 d0                	mov    %edx,%eax
}
  800c8f:	5d                   	pop    %ebp
  800c90:	c3                   	ret    

00800c91 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c91:	55                   	push   %ebp
  800c92:	89 e5                	mov    %esp,%ebp
  800c94:	83 ec 04             	sub    $0x4,%esp
  800c97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c9d:	eb 12                	jmp    800cb1 <strchr+0x20>
		if (*s == c)
  800c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca2:	8a 00                	mov    (%eax),%al
  800ca4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ca7:	75 05                	jne    800cae <strchr+0x1d>
			return (char *) s;
  800ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cac:	eb 11                	jmp    800cbf <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800cae:	ff 45 08             	incl   0x8(%ebp)
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	8a 00                	mov    (%eax),%al
  800cb6:	84 c0                	test   %al,%al
  800cb8:	75 e5                	jne    800c9f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800cba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cbf:	c9                   	leave  
  800cc0:	c3                   	ret    

00800cc1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cc1:	55                   	push   %ebp
  800cc2:	89 e5                	mov    %esp,%ebp
  800cc4:	83 ec 04             	sub    $0x4,%esp
  800cc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cca:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ccd:	eb 0d                	jmp    800cdc <strfind+0x1b>
		if (*s == c)
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	8a 00                	mov    (%eax),%al
  800cd4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cd7:	74 0e                	je     800ce7 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cd9:	ff 45 08             	incl   0x8(%ebp)
  800cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdf:	8a 00                	mov    (%eax),%al
  800ce1:	84 c0                	test   %al,%al
  800ce3:	75 ea                	jne    800ccf <strfind+0xe>
  800ce5:	eb 01                	jmp    800ce8 <strfind+0x27>
		if (*s == c)
			break;
  800ce7:	90                   	nop
	return (char *) s;
  800ce8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ceb:	c9                   	leave  
  800cec:	c3                   	ret    

00800ced <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ced:	55                   	push   %ebp
  800cee:	89 e5                	mov    %esp,%ebp
  800cf0:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800cf9:	8b 45 10             	mov    0x10(%ebp),%eax
  800cfc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800cff:	eb 0e                	jmp    800d0f <memset+0x22>
		*p++ = c;
  800d01:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d04:	8d 50 01             	lea    0x1(%eax),%edx
  800d07:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d0d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d0f:	ff 4d f8             	decl   -0x8(%ebp)
  800d12:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d16:	79 e9                	jns    800d01 <memset+0x14>
		*p++ = c;

	return v;
  800d18:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d1b:	c9                   	leave  
  800d1c:	c3                   	ret    

00800d1d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d1d:	55                   	push   %ebp
  800d1e:	89 e5                	mov    %esp,%ebp
  800d20:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d26:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d29:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d2f:	eb 16                	jmp    800d47 <memcpy+0x2a>
		*d++ = *s++;
  800d31:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d34:	8d 50 01             	lea    0x1(%eax),%edx
  800d37:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d3a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d3d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d40:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d43:	8a 12                	mov    (%edx),%dl
  800d45:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d47:	8b 45 10             	mov    0x10(%ebp),%eax
  800d4a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d4d:	89 55 10             	mov    %edx,0x10(%ebp)
  800d50:	85 c0                	test   %eax,%eax
  800d52:	75 dd                	jne    800d31 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d54:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d57:	c9                   	leave  
  800d58:	c3                   	ret    

00800d59 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d59:	55                   	push   %ebp
  800d5a:	89 e5                	mov    %esp,%ebp
  800d5c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d62:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d6e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d71:	73 50                	jae    800dc3 <memmove+0x6a>
  800d73:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d76:	8b 45 10             	mov    0x10(%ebp),%eax
  800d79:	01 d0                	add    %edx,%eax
  800d7b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d7e:	76 43                	jbe    800dc3 <memmove+0x6a>
		s += n;
  800d80:	8b 45 10             	mov    0x10(%ebp),%eax
  800d83:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d86:	8b 45 10             	mov    0x10(%ebp),%eax
  800d89:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d8c:	eb 10                	jmp    800d9e <memmove+0x45>
			*--d = *--s;
  800d8e:	ff 4d f8             	decl   -0x8(%ebp)
  800d91:	ff 4d fc             	decl   -0x4(%ebp)
  800d94:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d97:	8a 10                	mov    (%eax),%dl
  800d99:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d9c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d9e:	8b 45 10             	mov    0x10(%ebp),%eax
  800da1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800da4:	89 55 10             	mov    %edx,0x10(%ebp)
  800da7:	85 c0                	test   %eax,%eax
  800da9:	75 e3                	jne    800d8e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800dab:	eb 23                	jmp    800dd0 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800dad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800db0:	8d 50 01             	lea    0x1(%eax),%edx
  800db3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800db6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800db9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dbc:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dbf:	8a 12                	mov    (%edx),%dl
  800dc1:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800dc3:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dc9:	89 55 10             	mov    %edx,0x10(%ebp)
  800dcc:	85 c0                	test   %eax,%eax
  800dce:	75 dd                	jne    800dad <memmove+0x54>
			*d++ = *s++;

	return dst;
  800dd0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd3:	c9                   	leave  
  800dd4:	c3                   	ret    

00800dd5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800dd5:	55                   	push   %ebp
  800dd6:	89 e5                	mov    %esp,%ebp
  800dd8:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dde:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800de1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de4:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800de7:	eb 2a                	jmp    800e13 <memcmp+0x3e>
		if (*s1 != *s2)
  800de9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dec:	8a 10                	mov    (%eax),%dl
  800dee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800df1:	8a 00                	mov    (%eax),%al
  800df3:	38 c2                	cmp    %al,%dl
  800df5:	74 16                	je     800e0d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800df7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dfa:	8a 00                	mov    (%eax),%al
  800dfc:	0f b6 d0             	movzbl %al,%edx
  800dff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e02:	8a 00                	mov    (%eax),%al
  800e04:	0f b6 c0             	movzbl %al,%eax
  800e07:	29 c2                	sub    %eax,%edx
  800e09:	89 d0                	mov    %edx,%eax
  800e0b:	eb 18                	jmp    800e25 <memcmp+0x50>
		s1++, s2++;
  800e0d:	ff 45 fc             	incl   -0x4(%ebp)
  800e10:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e13:	8b 45 10             	mov    0x10(%ebp),%eax
  800e16:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e19:	89 55 10             	mov    %edx,0x10(%ebp)
  800e1c:	85 c0                	test   %eax,%eax
  800e1e:	75 c9                	jne    800de9 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e20:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e25:	c9                   	leave  
  800e26:	c3                   	ret    

00800e27 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e27:	55                   	push   %ebp
  800e28:	89 e5                	mov    %esp,%ebp
  800e2a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e2d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e30:	8b 45 10             	mov    0x10(%ebp),%eax
  800e33:	01 d0                	add    %edx,%eax
  800e35:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e38:	eb 15                	jmp    800e4f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3d:	8a 00                	mov    (%eax),%al
  800e3f:	0f b6 d0             	movzbl %al,%edx
  800e42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e45:	0f b6 c0             	movzbl %al,%eax
  800e48:	39 c2                	cmp    %eax,%edx
  800e4a:	74 0d                	je     800e59 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e4c:	ff 45 08             	incl   0x8(%ebp)
  800e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e52:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e55:	72 e3                	jb     800e3a <memfind+0x13>
  800e57:	eb 01                	jmp    800e5a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e59:	90                   	nop
	return (void *) s;
  800e5a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e5d:	c9                   	leave  
  800e5e:	c3                   	ret    

00800e5f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e5f:	55                   	push   %ebp
  800e60:	89 e5                	mov    %esp,%ebp
  800e62:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e65:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e6c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e73:	eb 03                	jmp    800e78 <strtol+0x19>
		s++;
  800e75:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e78:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7b:	8a 00                	mov    (%eax),%al
  800e7d:	3c 20                	cmp    $0x20,%al
  800e7f:	74 f4                	je     800e75 <strtol+0x16>
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
  800e84:	8a 00                	mov    (%eax),%al
  800e86:	3c 09                	cmp    $0x9,%al
  800e88:	74 eb                	je     800e75 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8d:	8a 00                	mov    (%eax),%al
  800e8f:	3c 2b                	cmp    $0x2b,%al
  800e91:	75 05                	jne    800e98 <strtol+0x39>
		s++;
  800e93:	ff 45 08             	incl   0x8(%ebp)
  800e96:	eb 13                	jmp    800eab <strtol+0x4c>
	else if (*s == '-')
  800e98:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9b:	8a 00                	mov    (%eax),%al
  800e9d:	3c 2d                	cmp    $0x2d,%al
  800e9f:	75 0a                	jne    800eab <strtol+0x4c>
		s++, neg = 1;
  800ea1:	ff 45 08             	incl   0x8(%ebp)
  800ea4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800eab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eaf:	74 06                	je     800eb7 <strtol+0x58>
  800eb1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800eb5:	75 20                	jne    800ed7 <strtol+0x78>
  800eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eba:	8a 00                	mov    (%eax),%al
  800ebc:	3c 30                	cmp    $0x30,%al
  800ebe:	75 17                	jne    800ed7 <strtol+0x78>
  800ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec3:	40                   	inc    %eax
  800ec4:	8a 00                	mov    (%eax),%al
  800ec6:	3c 78                	cmp    $0x78,%al
  800ec8:	75 0d                	jne    800ed7 <strtol+0x78>
		s += 2, base = 16;
  800eca:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ece:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ed5:	eb 28                	jmp    800eff <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ed7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800edb:	75 15                	jne    800ef2 <strtol+0x93>
  800edd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee0:	8a 00                	mov    (%eax),%al
  800ee2:	3c 30                	cmp    $0x30,%al
  800ee4:	75 0c                	jne    800ef2 <strtol+0x93>
		s++, base = 8;
  800ee6:	ff 45 08             	incl   0x8(%ebp)
  800ee9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ef0:	eb 0d                	jmp    800eff <strtol+0xa0>
	else if (base == 0)
  800ef2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef6:	75 07                	jne    800eff <strtol+0xa0>
		base = 10;
  800ef8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800eff:	8b 45 08             	mov    0x8(%ebp),%eax
  800f02:	8a 00                	mov    (%eax),%al
  800f04:	3c 2f                	cmp    $0x2f,%al
  800f06:	7e 19                	jle    800f21 <strtol+0xc2>
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0b:	8a 00                	mov    (%eax),%al
  800f0d:	3c 39                	cmp    $0x39,%al
  800f0f:	7f 10                	jg     800f21 <strtol+0xc2>
			dig = *s - '0';
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
  800f14:	8a 00                	mov    (%eax),%al
  800f16:	0f be c0             	movsbl %al,%eax
  800f19:	83 e8 30             	sub    $0x30,%eax
  800f1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f1f:	eb 42                	jmp    800f63 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f21:	8b 45 08             	mov    0x8(%ebp),%eax
  800f24:	8a 00                	mov    (%eax),%al
  800f26:	3c 60                	cmp    $0x60,%al
  800f28:	7e 19                	jle    800f43 <strtol+0xe4>
  800f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2d:	8a 00                	mov    (%eax),%al
  800f2f:	3c 7a                	cmp    $0x7a,%al
  800f31:	7f 10                	jg     800f43 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f33:	8b 45 08             	mov    0x8(%ebp),%eax
  800f36:	8a 00                	mov    (%eax),%al
  800f38:	0f be c0             	movsbl %al,%eax
  800f3b:	83 e8 57             	sub    $0x57,%eax
  800f3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f41:	eb 20                	jmp    800f63 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	3c 40                	cmp    $0x40,%al
  800f4a:	7e 39                	jle    800f85 <strtol+0x126>
  800f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4f:	8a 00                	mov    (%eax),%al
  800f51:	3c 5a                	cmp    $0x5a,%al
  800f53:	7f 30                	jg     800f85 <strtol+0x126>
			dig = *s - 'A' + 10;
  800f55:	8b 45 08             	mov    0x8(%ebp),%eax
  800f58:	8a 00                	mov    (%eax),%al
  800f5a:	0f be c0             	movsbl %al,%eax
  800f5d:	83 e8 37             	sub    $0x37,%eax
  800f60:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f66:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f69:	7d 19                	jge    800f84 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f6b:	ff 45 08             	incl   0x8(%ebp)
  800f6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f71:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f75:	89 c2                	mov    %eax,%edx
  800f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f7a:	01 d0                	add    %edx,%eax
  800f7c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f7f:	e9 7b ff ff ff       	jmp    800eff <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f84:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f85:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f89:	74 08                	je     800f93 <strtol+0x134>
		*endptr = (char *) s;
  800f8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f91:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f93:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f97:	74 07                	je     800fa0 <strtol+0x141>
  800f99:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f9c:	f7 d8                	neg    %eax
  800f9e:	eb 03                	jmp    800fa3 <strtol+0x144>
  800fa0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800fa3:	c9                   	leave  
  800fa4:	c3                   	ret    

00800fa5 <ltostr>:

void
ltostr(long value, char *str)
{
  800fa5:	55                   	push   %ebp
  800fa6:	89 e5                	mov    %esp,%ebp
  800fa8:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800fab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800fb2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800fb9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fbd:	79 13                	jns    800fd2 <ltostr+0x2d>
	{
		neg = 1;
  800fbf:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc9:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fcc:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fcf:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fda:	99                   	cltd   
  800fdb:	f7 f9                	idiv   %ecx
  800fdd:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fe0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe3:	8d 50 01             	lea    0x1(%eax),%edx
  800fe6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fe9:	89 c2                	mov    %eax,%edx
  800feb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fee:	01 d0                	add    %edx,%eax
  800ff0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ff3:	83 c2 30             	add    $0x30,%edx
  800ff6:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ff8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ffb:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801000:	f7 e9                	imul   %ecx
  801002:	c1 fa 02             	sar    $0x2,%edx
  801005:	89 c8                	mov    %ecx,%eax
  801007:	c1 f8 1f             	sar    $0x1f,%eax
  80100a:	29 c2                	sub    %eax,%edx
  80100c:	89 d0                	mov    %edx,%eax
  80100e:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801011:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801014:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801019:	f7 e9                	imul   %ecx
  80101b:	c1 fa 02             	sar    $0x2,%edx
  80101e:	89 c8                	mov    %ecx,%eax
  801020:	c1 f8 1f             	sar    $0x1f,%eax
  801023:	29 c2                	sub    %eax,%edx
  801025:	89 d0                	mov    %edx,%eax
  801027:	c1 e0 02             	shl    $0x2,%eax
  80102a:	01 d0                	add    %edx,%eax
  80102c:	01 c0                	add    %eax,%eax
  80102e:	29 c1                	sub    %eax,%ecx
  801030:	89 ca                	mov    %ecx,%edx
  801032:	85 d2                	test   %edx,%edx
  801034:	75 9c                	jne    800fd2 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801036:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80103d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801040:	48                   	dec    %eax
  801041:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801044:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801048:	74 3d                	je     801087 <ltostr+0xe2>
		start = 1 ;
  80104a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801051:	eb 34                	jmp    801087 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801053:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801056:	8b 45 0c             	mov    0xc(%ebp),%eax
  801059:	01 d0                	add    %edx,%eax
  80105b:	8a 00                	mov    (%eax),%al
  80105d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801060:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801063:	8b 45 0c             	mov    0xc(%ebp),%eax
  801066:	01 c2                	add    %eax,%edx
  801068:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80106b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106e:	01 c8                	add    %ecx,%eax
  801070:	8a 00                	mov    (%eax),%al
  801072:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801074:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801077:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107a:	01 c2                	add    %eax,%edx
  80107c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80107f:	88 02                	mov    %al,(%edx)
		start++ ;
  801081:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801084:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801087:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80108a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80108d:	7c c4                	jl     801053 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80108f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801092:	8b 45 0c             	mov    0xc(%ebp),%eax
  801095:	01 d0                	add    %edx,%eax
  801097:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80109a:	90                   	nop
  80109b:	c9                   	leave  
  80109c:	c3                   	ret    

0080109d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80109d:	55                   	push   %ebp
  80109e:	89 e5                	mov    %esp,%ebp
  8010a0:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8010a3:	ff 75 08             	pushl  0x8(%ebp)
  8010a6:	e8 54 fa ff ff       	call   800aff <strlen>
  8010ab:	83 c4 04             	add    $0x4,%esp
  8010ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8010b1:	ff 75 0c             	pushl  0xc(%ebp)
  8010b4:	e8 46 fa ff ff       	call   800aff <strlen>
  8010b9:	83 c4 04             	add    $0x4,%esp
  8010bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8010bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8010c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010cd:	eb 17                	jmp    8010e6 <strcconcat+0x49>
		final[s] = str1[s] ;
  8010cf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d5:	01 c2                	add    %eax,%edx
  8010d7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010da:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dd:	01 c8                	add    %ecx,%eax
  8010df:	8a 00                	mov    (%eax),%al
  8010e1:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010e3:	ff 45 fc             	incl   -0x4(%ebp)
  8010e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010ec:	7c e1                	jl     8010cf <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010ee:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010f5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010fc:	eb 1f                	jmp    80111d <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801101:	8d 50 01             	lea    0x1(%eax),%edx
  801104:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801107:	89 c2                	mov    %eax,%edx
  801109:	8b 45 10             	mov    0x10(%ebp),%eax
  80110c:	01 c2                	add    %eax,%edx
  80110e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801111:	8b 45 0c             	mov    0xc(%ebp),%eax
  801114:	01 c8                	add    %ecx,%eax
  801116:	8a 00                	mov    (%eax),%al
  801118:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80111a:	ff 45 f8             	incl   -0x8(%ebp)
  80111d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801120:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801123:	7c d9                	jl     8010fe <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801125:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801128:	8b 45 10             	mov    0x10(%ebp),%eax
  80112b:	01 d0                	add    %edx,%eax
  80112d:	c6 00 00             	movb   $0x0,(%eax)
}
  801130:	90                   	nop
  801131:	c9                   	leave  
  801132:	c3                   	ret    

00801133 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801133:	55                   	push   %ebp
  801134:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801136:	8b 45 14             	mov    0x14(%ebp),%eax
  801139:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80113f:	8b 45 14             	mov    0x14(%ebp),%eax
  801142:	8b 00                	mov    (%eax),%eax
  801144:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80114b:	8b 45 10             	mov    0x10(%ebp),%eax
  80114e:	01 d0                	add    %edx,%eax
  801150:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801156:	eb 0c                	jmp    801164 <strsplit+0x31>
			*string++ = 0;
  801158:	8b 45 08             	mov    0x8(%ebp),%eax
  80115b:	8d 50 01             	lea    0x1(%eax),%edx
  80115e:	89 55 08             	mov    %edx,0x8(%ebp)
  801161:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801164:	8b 45 08             	mov    0x8(%ebp),%eax
  801167:	8a 00                	mov    (%eax),%al
  801169:	84 c0                	test   %al,%al
  80116b:	74 18                	je     801185 <strsplit+0x52>
  80116d:	8b 45 08             	mov    0x8(%ebp),%eax
  801170:	8a 00                	mov    (%eax),%al
  801172:	0f be c0             	movsbl %al,%eax
  801175:	50                   	push   %eax
  801176:	ff 75 0c             	pushl  0xc(%ebp)
  801179:	e8 13 fb ff ff       	call   800c91 <strchr>
  80117e:	83 c4 08             	add    $0x8,%esp
  801181:	85 c0                	test   %eax,%eax
  801183:	75 d3                	jne    801158 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801185:	8b 45 08             	mov    0x8(%ebp),%eax
  801188:	8a 00                	mov    (%eax),%al
  80118a:	84 c0                	test   %al,%al
  80118c:	74 5a                	je     8011e8 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80118e:	8b 45 14             	mov    0x14(%ebp),%eax
  801191:	8b 00                	mov    (%eax),%eax
  801193:	83 f8 0f             	cmp    $0xf,%eax
  801196:	75 07                	jne    80119f <strsplit+0x6c>
		{
			return 0;
  801198:	b8 00 00 00 00       	mov    $0x0,%eax
  80119d:	eb 66                	jmp    801205 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80119f:	8b 45 14             	mov    0x14(%ebp),%eax
  8011a2:	8b 00                	mov    (%eax),%eax
  8011a4:	8d 48 01             	lea    0x1(%eax),%ecx
  8011a7:	8b 55 14             	mov    0x14(%ebp),%edx
  8011aa:	89 0a                	mov    %ecx,(%edx)
  8011ac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b6:	01 c2                	add    %eax,%edx
  8011b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bb:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011bd:	eb 03                	jmp    8011c2 <strsplit+0x8f>
			string++;
  8011bf:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c5:	8a 00                	mov    (%eax),%al
  8011c7:	84 c0                	test   %al,%al
  8011c9:	74 8b                	je     801156 <strsplit+0x23>
  8011cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ce:	8a 00                	mov    (%eax),%al
  8011d0:	0f be c0             	movsbl %al,%eax
  8011d3:	50                   	push   %eax
  8011d4:	ff 75 0c             	pushl  0xc(%ebp)
  8011d7:	e8 b5 fa ff ff       	call   800c91 <strchr>
  8011dc:	83 c4 08             	add    $0x8,%esp
  8011df:	85 c0                	test   %eax,%eax
  8011e1:	74 dc                	je     8011bf <strsplit+0x8c>
			string++;
	}
  8011e3:	e9 6e ff ff ff       	jmp    801156 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011e8:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ec:	8b 00                	mov    (%eax),%eax
  8011ee:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f8:	01 d0                	add    %edx,%eax
  8011fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801200:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801205:	c9                   	leave  
  801206:	c3                   	ret    

00801207 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801207:	55                   	push   %ebp
  801208:	89 e5                	mov    %esp,%ebp
  80120a:	57                   	push   %edi
  80120b:	56                   	push   %esi
  80120c:	53                   	push   %ebx
  80120d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801210:	8b 45 08             	mov    0x8(%ebp),%eax
  801213:	8b 55 0c             	mov    0xc(%ebp),%edx
  801216:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801219:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80121c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80121f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801222:	cd 30                	int    $0x30
  801224:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801227:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80122a:	83 c4 10             	add    $0x10,%esp
  80122d:	5b                   	pop    %ebx
  80122e:	5e                   	pop    %esi
  80122f:	5f                   	pop    %edi
  801230:	5d                   	pop    %ebp
  801231:	c3                   	ret    

00801232 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801232:	55                   	push   %ebp
  801233:	89 e5                	mov    %esp,%ebp
  801235:	83 ec 04             	sub    $0x4,%esp
  801238:	8b 45 10             	mov    0x10(%ebp),%eax
  80123b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80123e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801242:	8b 45 08             	mov    0x8(%ebp),%eax
  801245:	6a 00                	push   $0x0
  801247:	6a 00                	push   $0x0
  801249:	52                   	push   %edx
  80124a:	ff 75 0c             	pushl  0xc(%ebp)
  80124d:	50                   	push   %eax
  80124e:	6a 00                	push   $0x0
  801250:	e8 b2 ff ff ff       	call   801207 <syscall>
  801255:	83 c4 18             	add    $0x18,%esp
}
  801258:	90                   	nop
  801259:	c9                   	leave  
  80125a:	c3                   	ret    

0080125b <sys_cgetc>:

int
sys_cgetc(void)
{
  80125b:	55                   	push   %ebp
  80125c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80125e:	6a 00                	push   $0x0
  801260:	6a 00                	push   $0x0
  801262:	6a 00                	push   $0x0
  801264:	6a 00                	push   $0x0
  801266:	6a 00                	push   $0x0
  801268:	6a 01                	push   $0x1
  80126a:	e8 98 ff ff ff       	call   801207 <syscall>
  80126f:	83 c4 18             	add    $0x18,%esp
}
  801272:	c9                   	leave  
  801273:	c3                   	ret    

00801274 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801274:	55                   	push   %ebp
  801275:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801277:	8b 55 0c             	mov    0xc(%ebp),%edx
  80127a:	8b 45 08             	mov    0x8(%ebp),%eax
  80127d:	6a 00                	push   $0x0
  80127f:	6a 00                	push   $0x0
  801281:	6a 00                	push   $0x0
  801283:	52                   	push   %edx
  801284:	50                   	push   %eax
  801285:	6a 05                	push   $0x5
  801287:	e8 7b ff ff ff       	call   801207 <syscall>
  80128c:	83 c4 18             	add    $0x18,%esp
}
  80128f:	c9                   	leave  
  801290:	c3                   	ret    

00801291 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801291:	55                   	push   %ebp
  801292:	89 e5                	mov    %esp,%ebp
  801294:	56                   	push   %esi
  801295:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801296:	8b 75 18             	mov    0x18(%ebp),%esi
  801299:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80129c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80129f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a5:	56                   	push   %esi
  8012a6:	53                   	push   %ebx
  8012a7:	51                   	push   %ecx
  8012a8:	52                   	push   %edx
  8012a9:	50                   	push   %eax
  8012aa:	6a 06                	push   $0x6
  8012ac:	e8 56 ff ff ff       	call   801207 <syscall>
  8012b1:	83 c4 18             	add    $0x18,%esp
}
  8012b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012b7:	5b                   	pop    %ebx
  8012b8:	5e                   	pop    %esi
  8012b9:	5d                   	pop    %ebp
  8012ba:	c3                   	ret    

008012bb <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8012bb:	55                   	push   %ebp
  8012bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8012be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c4:	6a 00                	push   $0x0
  8012c6:	6a 00                	push   $0x0
  8012c8:	6a 00                	push   $0x0
  8012ca:	52                   	push   %edx
  8012cb:	50                   	push   %eax
  8012cc:	6a 07                	push   $0x7
  8012ce:	e8 34 ff ff ff       	call   801207 <syscall>
  8012d3:	83 c4 18             	add    $0x18,%esp
}
  8012d6:	c9                   	leave  
  8012d7:	c3                   	ret    

008012d8 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8012d8:	55                   	push   %ebp
  8012d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8012db:	6a 00                	push   $0x0
  8012dd:	6a 00                	push   $0x0
  8012df:	6a 00                	push   $0x0
  8012e1:	ff 75 0c             	pushl  0xc(%ebp)
  8012e4:	ff 75 08             	pushl  0x8(%ebp)
  8012e7:	6a 08                	push   $0x8
  8012e9:	e8 19 ff ff ff       	call   801207 <syscall>
  8012ee:	83 c4 18             	add    $0x18,%esp
}
  8012f1:	c9                   	leave  
  8012f2:	c3                   	ret    

008012f3 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8012f3:	55                   	push   %ebp
  8012f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8012f6:	6a 00                	push   $0x0
  8012f8:	6a 00                	push   $0x0
  8012fa:	6a 00                	push   $0x0
  8012fc:	6a 00                	push   $0x0
  8012fe:	6a 00                	push   $0x0
  801300:	6a 09                	push   $0x9
  801302:	e8 00 ff ff ff       	call   801207 <syscall>
  801307:	83 c4 18             	add    $0x18,%esp
}
  80130a:	c9                   	leave  
  80130b:	c3                   	ret    

0080130c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80130c:	55                   	push   %ebp
  80130d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80130f:	6a 00                	push   $0x0
  801311:	6a 00                	push   $0x0
  801313:	6a 00                	push   $0x0
  801315:	6a 00                	push   $0x0
  801317:	6a 00                	push   $0x0
  801319:	6a 0a                	push   $0xa
  80131b:	e8 e7 fe ff ff       	call   801207 <syscall>
  801320:	83 c4 18             	add    $0x18,%esp
}
  801323:	c9                   	leave  
  801324:	c3                   	ret    

00801325 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801325:	55                   	push   %ebp
  801326:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801328:	6a 00                	push   $0x0
  80132a:	6a 00                	push   $0x0
  80132c:	6a 00                	push   $0x0
  80132e:	6a 00                	push   $0x0
  801330:	6a 00                	push   $0x0
  801332:	6a 0b                	push   $0xb
  801334:	e8 ce fe ff ff       	call   801207 <syscall>
  801339:	83 c4 18             	add    $0x18,%esp
}
  80133c:	c9                   	leave  
  80133d:	c3                   	ret    

0080133e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80133e:	55                   	push   %ebp
  80133f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801341:	6a 00                	push   $0x0
  801343:	6a 00                	push   $0x0
  801345:	6a 00                	push   $0x0
  801347:	ff 75 0c             	pushl  0xc(%ebp)
  80134a:	ff 75 08             	pushl  0x8(%ebp)
  80134d:	6a 0f                	push   $0xf
  80134f:	e8 b3 fe ff ff       	call   801207 <syscall>
  801354:	83 c4 18             	add    $0x18,%esp
	return;
  801357:	90                   	nop
}
  801358:	c9                   	leave  
  801359:	c3                   	ret    

0080135a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80135a:	55                   	push   %ebp
  80135b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80135d:	6a 00                	push   $0x0
  80135f:	6a 00                	push   $0x0
  801361:	6a 00                	push   $0x0
  801363:	ff 75 0c             	pushl  0xc(%ebp)
  801366:	ff 75 08             	pushl  0x8(%ebp)
  801369:	6a 10                	push   $0x10
  80136b:	e8 97 fe ff ff       	call   801207 <syscall>
  801370:	83 c4 18             	add    $0x18,%esp
	return ;
  801373:	90                   	nop
}
  801374:	c9                   	leave  
  801375:	c3                   	ret    

00801376 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801376:	55                   	push   %ebp
  801377:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801379:	6a 00                	push   $0x0
  80137b:	6a 00                	push   $0x0
  80137d:	ff 75 10             	pushl  0x10(%ebp)
  801380:	ff 75 0c             	pushl  0xc(%ebp)
  801383:	ff 75 08             	pushl  0x8(%ebp)
  801386:	6a 11                	push   $0x11
  801388:	e8 7a fe ff ff       	call   801207 <syscall>
  80138d:	83 c4 18             	add    $0x18,%esp
	return ;
  801390:	90                   	nop
}
  801391:	c9                   	leave  
  801392:	c3                   	ret    

00801393 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801393:	55                   	push   %ebp
  801394:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801396:	6a 00                	push   $0x0
  801398:	6a 00                	push   $0x0
  80139a:	6a 00                	push   $0x0
  80139c:	6a 00                	push   $0x0
  80139e:	6a 00                	push   $0x0
  8013a0:	6a 0c                	push   $0xc
  8013a2:	e8 60 fe ff ff       	call   801207 <syscall>
  8013a7:	83 c4 18             	add    $0x18,%esp
}
  8013aa:	c9                   	leave  
  8013ab:	c3                   	ret    

008013ac <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8013af:	6a 00                	push   $0x0
  8013b1:	6a 00                	push   $0x0
  8013b3:	6a 00                	push   $0x0
  8013b5:	6a 00                	push   $0x0
  8013b7:	ff 75 08             	pushl  0x8(%ebp)
  8013ba:	6a 0d                	push   $0xd
  8013bc:	e8 46 fe ff ff       	call   801207 <syscall>
  8013c1:	83 c4 18             	add    $0x18,%esp
}
  8013c4:	c9                   	leave  
  8013c5:	c3                   	ret    

008013c6 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8013c6:	55                   	push   %ebp
  8013c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8013c9:	6a 00                	push   $0x0
  8013cb:	6a 00                	push   $0x0
  8013cd:	6a 00                	push   $0x0
  8013cf:	6a 00                	push   $0x0
  8013d1:	6a 00                	push   $0x0
  8013d3:	6a 0e                	push   $0xe
  8013d5:	e8 2d fe ff ff       	call   801207 <syscall>
  8013da:	83 c4 18             	add    $0x18,%esp
}
  8013dd:	90                   	nop
  8013de:	c9                   	leave  
  8013df:	c3                   	ret    

008013e0 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8013e0:	55                   	push   %ebp
  8013e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8013e3:	6a 00                	push   $0x0
  8013e5:	6a 00                	push   $0x0
  8013e7:	6a 00                	push   $0x0
  8013e9:	6a 00                	push   $0x0
  8013eb:	6a 00                	push   $0x0
  8013ed:	6a 13                	push   $0x13
  8013ef:	e8 13 fe ff ff       	call   801207 <syscall>
  8013f4:	83 c4 18             	add    $0x18,%esp
}
  8013f7:	90                   	nop
  8013f8:	c9                   	leave  
  8013f9:	c3                   	ret    

008013fa <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8013fa:	55                   	push   %ebp
  8013fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8013fd:	6a 00                	push   $0x0
  8013ff:	6a 00                	push   $0x0
  801401:	6a 00                	push   $0x0
  801403:	6a 00                	push   $0x0
  801405:	6a 00                	push   $0x0
  801407:	6a 14                	push   $0x14
  801409:	e8 f9 fd ff ff       	call   801207 <syscall>
  80140e:	83 c4 18             	add    $0x18,%esp
}
  801411:	90                   	nop
  801412:	c9                   	leave  
  801413:	c3                   	ret    

00801414 <sys_cputc>:


void
sys_cputc(const char c)
{
  801414:	55                   	push   %ebp
  801415:	89 e5                	mov    %esp,%ebp
  801417:	83 ec 04             	sub    $0x4,%esp
  80141a:	8b 45 08             	mov    0x8(%ebp),%eax
  80141d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801420:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801424:	6a 00                	push   $0x0
  801426:	6a 00                	push   $0x0
  801428:	6a 00                	push   $0x0
  80142a:	6a 00                	push   $0x0
  80142c:	50                   	push   %eax
  80142d:	6a 15                	push   $0x15
  80142f:	e8 d3 fd ff ff       	call   801207 <syscall>
  801434:	83 c4 18             	add    $0x18,%esp
}
  801437:	90                   	nop
  801438:	c9                   	leave  
  801439:	c3                   	ret    

0080143a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80143d:	6a 00                	push   $0x0
  80143f:	6a 00                	push   $0x0
  801441:	6a 00                	push   $0x0
  801443:	6a 00                	push   $0x0
  801445:	6a 00                	push   $0x0
  801447:	6a 16                	push   $0x16
  801449:	e8 b9 fd ff ff       	call   801207 <syscall>
  80144e:	83 c4 18             	add    $0x18,%esp
}
  801451:	90                   	nop
  801452:	c9                   	leave  
  801453:	c3                   	ret    

00801454 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801454:	55                   	push   %ebp
  801455:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801457:	8b 45 08             	mov    0x8(%ebp),%eax
  80145a:	6a 00                	push   $0x0
  80145c:	6a 00                	push   $0x0
  80145e:	6a 00                	push   $0x0
  801460:	ff 75 0c             	pushl  0xc(%ebp)
  801463:	50                   	push   %eax
  801464:	6a 17                	push   $0x17
  801466:	e8 9c fd ff ff       	call   801207 <syscall>
  80146b:	83 c4 18             	add    $0x18,%esp
}
  80146e:	c9                   	leave  
  80146f:	c3                   	ret    

00801470 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801470:	55                   	push   %ebp
  801471:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801473:	8b 55 0c             	mov    0xc(%ebp),%edx
  801476:	8b 45 08             	mov    0x8(%ebp),%eax
  801479:	6a 00                	push   $0x0
  80147b:	6a 00                	push   $0x0
  80147d:	6a 00                	push   $0x0
  80147f:	52                   	push   %edx
  801480:	50                   	push   %eax
  801481:	6a 1a                	push   $0x1a
  801483:	e8 7f fd ff ff       	call   801207 <syscall>
  801488:	83 c4 18             	add    $0x18,%esp
}
  80148b:	c9                   	leave  
  80148c:	c3                   	ret    

0080148d <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80148d:	55                   	push   %ebp
  80148e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801490:	8b 55 0c             	mov    0xc(%ebp),%edx
  801493:	8b 45 08             	mov    0x8(%ebp),%eax
  801496:	6a 00                	push   $0x0
  801498:	6a 00                	push   $0x0
  80149a:	6a 00                	push   $0x0
  80149c:	52                   	push   %edx
  80149d:	50                   	push   %eax
  80149e:	6a 18                	push   $0x18
  8014a0:	e8 62 fd ff ff       	call   801207 <syscall>
  8014a5:	83 c4 18             	add    $0x18,%esp
}
  8014a8:	90                   	nop
  8014a9:	c9                   	leave  
  8014aa:	c3                   	ret    

008014ab <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8014ab:	55                   	push   %ebp
  8014ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b4:	6a 00                	push   $0x0
  8014b6:	6a 00                	push   $0x0
  8014b8:	6a 00                	push   $0x0
  8014ba:	52                   	push   %edx
  8014bb:	50                   	push   %eax
  8014bc:	6a 19                	push   $0x19
  8014be:	e8 44 fd ff ff       	call   801207 <syscall>
  8014c3:	83 c4 18             	add    $0x18,%esp
}
  8014c6:	90                   	nop
  8014c7:	c9                   	leave  
  8014c8:	c3                   	ret    

008014c9 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8014c9:	55                   	push   %ebp
  8014ca:	89 e5                	mov    %esp,%ebp
  8014cc:	83 ec 04             	sub    $0x4,%esp
  8014cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d2:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8014d5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014d8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014df:	6a 00                	push   $0x0
  8014e1:	51                   	push   %ecx
  8014e2:	52                   	push   %edx
  8014e3:	ff 75 0c             	pushl  0xc(%ebp)
  8014e6:	50                   	push   %eax
  8014e7:	6a 1b                	push   $0x1b
  8014e9:	e8 19 fd ff ff       	call   801207 <syscall>
  8014ee:	83 c4 18             	add    $0x18,%esp
}
  8014f1:	c9                   	leave  
  8014f2:	c3                   	ret    

008014f3 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8014f3:	55                   	push   %ebp
  8014f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8014f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fc:	6a 00                	push   $0x0
  8014fe:	6a 00                	push   $0x0
  801500:	6a 00                	push   $0x0
  801502:	52                   	push   %edx
  801503:	50                   	push   %eax
  801504:	6a 1c                	push   $0x1c
  801506:	e8 fc fc ff ff       	call   801207 <syscall>
  80150b:	83 c4 18             	add    $0x18,%esp
}
  80150e:	c9                   	leave  
  80150f:	c3                   	ret    

00801510 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801510:	55                   	push   %ebp
  801511:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801513:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801516:	8b 55 0c             	mov    0xc(%ebp),%edx
  801519:	8b 45 08             	mov    0x8(%ebp),%eax
  80151c:	6a 00                	push   $0x0
  80151e:	6a 00                	push   $0x0
  801520:	51                   	push   %ecx
  801521:	52                   	push   %edx
  801522:	50                   	push   %eax
  801523:	6a 1d                	push   $0x1d
  801525:	e8 dd fc ff ff       	call   801207 <syscall>
  80152a:	83 c4 18             	add    $0x18,%esp
}
  80152d:	c9                   	leave  
  80152e:	c3                   	ret    

0080152f <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80152f:	55                   	push   %ebp
  801530:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801532:	8b 55 0c             	mov    0xc(%ebp),%edx
  801535:	8b 45 08             	mov    0x8(%ebp),%eax
  801538:	6a 00                	push   $0x0
  80153a:	6a 00                	push   $0x0
  80153c:	6a 00                	push   $0x0
  80153e:	52                   	push   %edx
  80153f:	50                   	push   %eax
  801540:	6a 1e                	push   $0x1e
  801542:	e8 c0 fc ff ff       	call   801207 <syscall>
  801547:	83 c4 18             	add    $0x18,%esp
}
  80154a:	c9                   	leave  
  80154b:	c3                   	ret    

0080154c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80154c:	55                   	push   %ebp
  80154d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80154f:	6a 00                	push   $0x0
  801551:	6a 00                	push   $0x0
  801553:	6a 00                	push   $0x0
  801555:	6a 00                	push   $0x0
  801557:	6a 00                	push   $0x0
  801559:	6a 1f                	push   $0x1f
  80155b:	e8 a7 fc ff ff       	call   801207 <syscall>
  801560:	83 c4 18             	add    $0x18,%esp
}
  801563:	c9                   	leave  
  801564:	c3                   	ret    

00801565 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801565:	55                   	push   %ebp
  801566:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801568:	8b 45 08             	mov    0x8(%ebp),%eax
  80156b:	6a 00                	push   $0x0
  80156d:	ff 75 14             	pushl  0x14(%ebp)
  801570:	ff 75 10             	pushl  0x10(%ebp)
  801573:	ff 75 0c             	pushl  0xc(%ebp)
  801576:	50                   	push   %eax
  801577:	6a 20                	push   $0x20
  801579:	e8 89 fc ff ff       	call   801207 <syscall>
  80157e:	83 c4 18             	add    $0x18,%esp
}
  801581:	c9                   	leave  
  801582:	c3                   	ret    

00801583 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801583:	55                   	push   %ebp
  801584:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801586:	8b 45 08             	mov    0x8(%ebp),%eax
  801589:	6a 00                	push   $0x0
  80158b:	6a 00                	push   $0x0
  80158d:	6a 00                	push   $0x0
  80158f:	6a 00                	push   $0x0
  801591:	50                   	push   %eax
  801592:	6a 21                	push   $0x21
  801594:	e8 6e fc ff ff       	call   801207 <syscall>
  801599:	83 c4 18             	add    $0x18,%esp
}
  80159c:	90                   	nop
  80159d:	c9                   	leave  
  80159e:	c3                   	ret    

0080159f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80159f:	55                   	push   %ebp
  8015a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8015a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a5:	6a 00                	push   $0x0
  8015a7:	6a 00                	push   $0x0
  8015a9:	6a 00                	push   $0x0
  8015ab:	6a 00                	push   $0x0
  8015ad:	50                   	push   %eax
  8015ae:	6a 22                	push   $0x22
  8015b0:	e8 52 fc ff ff       	call   801207 <syscall>
  8015b5:	83 c4 18             	add    $0x18,%esp
}
  8015b8:	c9                   	leave  
  8015b9:	c3                   	ret    

008015ba <sys_getenvid>:

int32 sys_getenvid(void)
{
  8015ba:	55                   	push   %ebp
  8015bb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8015bd:	6a 00                	push   $0x0
  8015bf:	6a 00                	push   $0x0
  8015c1:	6a 00                	push   $0x0
  8015c3:	6a 00                	push   $0x0
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 02                	push   $0x2
  8015c9:	e8 39 fc ff ff       	call   801207 <syscall>
  8015ce:	83 c4 18             	add    $0x18,%esp
}
  8015d1:	c9                   	leave  
  8015d2:	c3                   	ret    

008015d3 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8015d3:	55                   	push   %ebp
  8015d4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8015d6:	6a 00                	push   $0x0
  8015d8:	6a 00                	push   $0x0
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 00                	push   $0x0
  8015e0:	6a 03                	push   $0x3
  8015e2:	e8 20 fc ff ff       	call   801207 <syscall>
  8015e7:	83 c4 18             	add    $0x18,%esp
}
  8015ea:	c9                   	leave  
  8015eb:	c3                   	ret    

008015ec <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8015ec:	55                   	push   %ebp
  8015ed:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8015ef:	6a 00                	push   $0x0
  8015f1:	6a 00                	push   $0x0
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 04                	push   $0x4
  8015fb:	e8 07 fc ff ff       	call   801207 <syscall>
  801600:	83 c4 18             	add    $0x18,%esp
}
  801603:	c9                   	leave  
  801604:	c3                   	ret    

00801605 <sys_exit_env>:


void sys_exit_env(void)
{
  801605:	55                   	push   %ebp
  801606:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801608:	6a 00                	push   $0x0
  80160a:	6a 00                	push   $0x0
  80160c:	6a 00                	push   $0x0
  80160e:	6a 00                	push   $0x0
  801610:	6a 00                	push   $0x0
  801612:	6a 23                	push   $0x23
  801614:	e8 ee fb ff ff       	call   801207 <syscall>
  801619:	83 c4 18             	add    $0x18,%esp
}
  80161c:	90                   	nop
  80161d:	c9                   	leave  
  80161e:	c3                   	ret    

0080161f <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80161f:	55                   	push   %ebp
  801620:	89 e5                	mov    %esp,%ebp
  801622:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801625:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801628:	8d 50 04             	lea    0x4(%eax),%edx
  80162b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80162e:	6a 00                	push   $0x0
  801630:	6a 00                	push   $0x0
  801632:	6a 00                	push   $0x0
  801634:	52                   	push   %edx
  801635:	50                   	push   %eax
  801636:	6a 24                	push   $0x24
  801638:	e8 ca fb ff ff       	call   801207 <syscall>
  80163d:	83 c4 18             	add    $0x18,%esp
	return result;
  801640:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801643:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801646:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801649:	89 01                	mov    %eax,(%ecx)
  80164b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80164e:	8b 45 08             	mov    0x8(%ebp),%eax
  801651:	c9                   	leave  
  801652:	c2 04 00             	ret    $0x4

00801655 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801655:	55                   	push   %ebp
  801656:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801658:	6a 00                	push   $0x0
  80165a:	6a 00                	push   $0x0
  80165c:	ff 75 10             	pushl  0x10(%ebp)
  80165f:	ff 75 0c             	pushl  0xc(%ebp)
  801662:	ff 75 08             	pushl  0x8(%ebp)
  801665:	6a 12                	push   $0x12
  801667:	e8 9b fb ff ff       	call   801207 <syscall>
  80166c:	83 c4 18             	add    $0x18,%esp
	return ;
  80166f:	90                   	nop
}
  801670:	c9                   	leave  
  801671:	c3                   	ret    

00801672 <sys_rcr2>:
uint32 sys_rcr2()
{
  801672:	55                   	push   %ebp
  801673:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801675:	6a 00                	push   $0x0
  801677:	6a 00                	push   $0x0
  801679:	6a 00                	push   $0x0
  80167b:	6a 00                	push   $0x0
  80167d:	6a 00                	push   $0x0
  80167f:	6a 25                	push   $0x25
  801681:	e8 81 fb ff ff       	call   801207 <syscall>
  801686:	83 c4 18             	add    $0x18,%esp
}
  801689:	c9                   	leave  
  80168a:	c3                   	ret    

0080168b <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80168b:	55                   	push   %ebp
  80168c:	89 e5                	mov    %esp,%ebp
  80168e:	83 ec 04             	sub    $0x4,%esp
  801691:	8b 45 08             	mov    0x8(%ebp),%eax
  801694:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801697:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80169b:	6a 00                	push   $0x0
  80169d:	6a 00                	push   $0x0
  80169f:	6a 00                	push   $0x0
  8016a1:	6a 00                	push   $0x0
  8016a3:	50                   	push   %eax
  8016a4:	6a 26                	push   $0x26
  8016a6:	e8 5c fb ff ff       	call   801207 <syscall>
  8016ab:	83 c4 18             	add    $0x18,%esp
	return ;
  8016ae:	90                   	nop
}
  8016af:	c9                   	leave  
  8016b0:	c3                   	ret    

008016b1 <rsttst>:
void rsttst()
{
  8016b1:	55                   	push   %ebp
  8016b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8016b4:	6a 00                	push   $0x0
  8016b6:	6a 00                	push   $0x0
  8016b8:	6a 00                	push   $0x0
  8016ba:	6a 00                	push   $0x0
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 28                	push   $0x28
  8016c0:	e8 42 fb ff ff       	call   801207 <syscall>
  8016c5:	83 c4 18             	add    $0x18,%esp
	return ;
  8016c8:	90                   	nop
}
  8016c9:	c9                   	leave  
  8016ca:	c3                   	ret    

008016cb <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8016cb:	55                   	push   %ebp
  8016cc:	89 e5                	mov    %esp,%ebp
  8016ce:	83 ec 04             	sub    $0x4,%esp
  8016d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8016d4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8016d7:	8b 55 18             	mov    0x18(%ebp),%edx
  8016da:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016de:	52                   	push   %edx
  8016df:	50                   	push   %eax
  8016e0:	ff 75 10             	pushl  0x10(%ebp)
  8016e3:	ff 75 0c             	pushl  0xc(%ebp)
  8016e6:	ff 75 08             	pushl  0x8(%ebp)
  8016e9:	6a 27                	push   $0x27
  8016eb:	e8 17 fb ff ff       	call   801207 <syscall>
  8016f0:	83 c4 18             	add    $0x18,%esp
	return ;
  8016f3:	90                   	nop
}
  8016f4:	c9                   	leave  
  8016f5:	c3                   	ret    

008016f6 <chktst>:
void chktst(uint32 n)
{
  8016f6:	55                   	push   %ebp
  8016f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 00                	push   $0x0
  801701:	ff 75 08             	pushl  0x8(%ebp)
  801704:	6a 29                	push   $0x29
  801706:	e8 fc fa ff ff       	call   801207 <syscall>
  80170b:	83 c4 18             	add    $0x18,%esp
	return ;
  80170e:	90                   	nop
}
  80170f:	c9                   	leave  
  801710:	c3                   	ret    

00801711 <inctst>:

void inctst()
{
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801714:	6a 00                	push   $0x0
  801716:	6a 00                	push   $0x0
  801718:	6a 00                	push   $0x0
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	6a 2a                	push   $0x2a
  801720:	e8 e2 fa ff ff       	call   801207 <syscall>
  801725:	83 c4 18             	add    $0x18,%esp
	return ;
  801728:	90                   	nop
}
  801729:	c9                   	leave  
  80172a:	c3                   	ret    

0080172b <gettst>:
uint32 gettst()
{
  80172b:	55                   	push   %ebp
  80172c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80172e:	6a 00                	push   $0x0
  801730:	6a 00                	push   $0x0
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 2b                	push   $0x2b
  80173a:	e8 c8 fa ff ff       	call   801207 <syscall>
  80173f:	83 c4 18             	add    $0x18,%esp
}
  801742:	c9                   	leave  
  801743:	c3                   	ret    

00801744 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801744:	55                   	push   %ebp
  801745:	89 e5                	mov    %esp,%ebp
  801747:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80174a:	6a 00                	push   $0x0
  80174c:	6a 00                	push   $0x0
  80174e:	6a 00                	push   $0x0
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	6a 2c                	push   $0x2c
  801756:	e8 ac fa ff ff       	call   801207 <syscall>
  80175b:	83 c4 18             	add    $0x18,%esp
  80175e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801761:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801765:	75 07                	jne    80176e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801767:	b8 01 00 00 00       	mov    $0x1,%eax
  80176c:	eb 05                	jmp    801773 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80176e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801773:	c9                   	leave  
  801774:	c3                   	ret    

00801775 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
  801778:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80177b:	6a 00                	push   $0x0
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 2c                	push   $0x2c
  801787:	e8 7b fa ff ff       	call   801207 <syscall>
  80178c:	83 c4 18             	add    $0x18,%esp
  80178f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801792:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801796:	75 07                	jne    80179f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801798:	b8 01 00 00 00       	mov    $0x1,%eax
  80179d:	eb 05                	jmp    8017a4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80179f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017a4:	c9                   	leave  
  8017a5:	c3                   	ret    

008017a6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8017a6:	55                   	push   %ebp
  8017a7:	89 e5                	mov    %esp,%ebp
  8017a9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 2c                	push   $0x2c
  8017b8:	e8 4a fa ff ff       	call   801207 <syscall>
  8017bd:	83 c4 18             	add    $0x18,%esp
  8017c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8017c3:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8017c7:	75 07                	jne    8017d0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8017c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8017ce:	eb 05                	jmp    8017d5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8017d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017d5:	c9                   	leave  
  8017d6:	c3                   	ret    

008017d7 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8017d7:	55                   	push   %ebp
  8017d8:	89 e5                	mov    %esp,%ebp
  8017da:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017dd:	6a 00                	push   $0x0
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 2c                	push   $0x2c
  8017e9:	e8 19 fa ff ff       	call   801207 <syscall>
  8017ee:	83 c4 18             	add    $0x18,%esp
  8017f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8017f4:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8017f8:	75 07                	jne    801801 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8017fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8017ff:	eb 05                	jmp    801806 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801801:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801806:	c9                   	leave  
  801807:	c3                   	ret    

00801808 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801808:	55                   	push   %ebp
  801809:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80180b:	6a 00                	push   $0x0
  80180d:	6a 00                	push   $0x0
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	ff 75 08             	pushl  0x8(%ebp)
  801816:	6a 2d                	push   $0x2d
  801818:	e8 ea f9 ff ff       	call   801207 <syscall>
  80181d:	83 c4 18             	add    $0x18,%esp
	return ;
  801820:	90                   	nop
}
  801821:	c9                   	leave  
  801822:	c3                   	ret    

00801823 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
  801826:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801827:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80182a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80182d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801830:	8b 45 08             	mov    0x8(%ebp),%eax
  801833:	6a 00                	push   $0x0
  801835:	53                   	push   %ebx
  801836:	51                   	push   %ecx
  801837:	52                   	push   %edx
  801838:	50                   	push   %eax
  801839:	6a 2e                	push   $0x2e
  80183b:	e8 c7 f9 ff ff       	call   801207 <syscall>
  801840:	83 c4 18             	add    $0x18,%esp
}
  801843:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801846:	c9                   	leave  
  801847:	c3                   	ret    

00801848 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80184b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80184e:	8b 45 08             	mov    0x8(%ebp),%eax
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	52                   	push   %edx
  801858:	50                   	push   %eax
  801859:	6a 2f                	push   $0x2f
  80185b:	e8 a7 f9 ff ff       	call   801207 <syscall>
  801860:	83 c4 18             	add    $0x18,%esp
}
  801863:	c9                   	leave  
  801864:	c3                   	ret    
  801865:	66 90                	xchg   %ax,%ax
  801867:	90                   	nop

00801868 <__udivdi3>:
  801868:	55                   	push   %ebp
  801869:	57                   	push   %edi
  80186a:	56                   	push   %esi
  80186b:	53                   	push   %ebx
  80186c:	83 ec 1c             	sub    $0x1c,%esp
  80186f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801873:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801877:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80187b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80187f:	89 ca                	mov    %ecx,%edx
  801881:	89 f8                	mov    %edi,%eax
  801883:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801887:	85 f6                	test   %esi,%esi
  801889:	75 2d                	jne    8018b8 <__udivdi3+0x50>
  80188b:	39 cf                	cmp    %ecx,%edi
  80188d:	77 65                	ja     8018f4 <__udivdi3+0x8c>
  80188f:	89 fd                	mov    %edi,%ebp
  801891:	85 ff                	test   %edi,%edi
  801893:	75 0b                	jne    8018a0 <__udivdi3+0x38>
  801895:	b8 01 00 00 00       	mov    $0x1,%eax
  80189a:	31 d2                	xor    %edx,%edx
  80189c:	f7 f7                	div    %edi
  80189e:	89 c5                	mov    %eax,%ebp
  8018a0:	31 d2                	xor    %edx,%edx
  8018a2:	89 c8                	mov    %ecx,%eax
  8018a4:	f7 f5                	div    %ebp
  8018a6:	89 c1                	mov    %eax,%ecx
  8018a8:	89 d8                	mov    %ebx,%eax
  8018aa:	f7 f5                	div    %ebp
  8018ac:	89 cf                	mov    %ecx,%edi
  8018ae:	89 fa                	mov    %edi,%edx
  8018b0:	83 c4 1c             	add    $0x1c,%esp
  8018b3:	5b                   	pop    %ebx
  8018b4:	5e                   	pop    %esi
  8018b5:	5f                   	pop    %edi
  8018b6:	5d                   	pop    %ebp
  8018b7:	c3                   	ret    
  8018b8:	39 ce                	cmp    %ecx,%esi
  8018ba:	77 28                	ja     8018e4 <__udivdi3+0x7c>
  8018bc:	0f bd fe             	bsr    %esi,%edi
  8018bf:	83 f7 1f             	xor    $0x1f,%edi
  8018c2:	75 40                	jne    801904 <__udivdi3+0x9c>
  8018c4:	39 ce                	cmp    %ecx,%esi
  8018c6:	72 0a                	jb     8018d2 <__udivdi3+0x6a>
  8018c8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8018cc:	0f 87 9e 00 00 00    	ja     801970 <__udivdi3+0x108>
  8018d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8018d7:	89 fa                	mov    %edi,%edx
  8018d9:	83 c4 1c             	add    $0x1c,%esp
  8018dc:	5b                   	pop    %ebx
  8018dd:	5e                   	pop    %esi
  8018de:	5f                   	pop    %edi
  8018df:	5d                   	pop    %ebp
  8018e0:	c3                   	ret    
  8018e1:	8d 76 00             	lea    0x0(%esi),%esi
  8018e4:	31 ff                	xor    %edi,%edi
  8018e6:	31 c0                	xor    %eax,%eax
  8018e8:	89 fa                	mov    %edi,%edx
  8018ea:	83 c4 1c             	add    $0x1c,%esp
  8018ed:	5b                   	pop    %ebx
  8018ee:	5e                   	pop    %esi
  8018ef:	5f                   	pop    %edi
  8018f0:	5d                   	pop    %ebp
  8018f1:	c3                   	ret    
  8018f2:	66 90                	xchg   %ax,%ax
  8018f4:	89 d8                	mov    %ebx,%eax
  8018f6:	f7 f7                	div    %edi
  8018f8:	31 ff                	xor    %edi,%edi
  8018fa:	89 fa                	mov    %edi,%edx
  8018fc:	83 c4 1c             	add    $0x1c,%esp
  8018ff:	5b                   	pop    %ebx
  801900:	5e                   	pop    %esi
  801901:	5f                   	pop    %edi
  801902:	5d                   	pop    %ebp
  801903:	c3                   	ret    
  801904:	bd 20 00 00 00       	mov    $0x20,%ebp
  801909:	89 eb                	mov    %ebp,%ebx
  80190b:	29 fb                	sub    %edi,%ebx
  80190d:	89 f9                	mov    %edi,%ecx
  80190f:	d3 e6                	shl    %cl,%esi
  801911:	89 c5                	mov    %eax,%ebp
  801913:	88 d9                	mov    %bl,%cl
  801915:	d3 ed                	shr    %cl,%ebp
  801917:	89 e9                	mov    %ebp,%ecx
  801919:	09 f1                	or     %esi,%ecx
  80191b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80191f:	89 f9                	mov    %edi,%ecx
  801921:	d3 e0                	shl    %cl,%eax
  801923:	89 c5                	mov    %eax,%ebp
  801925:	89 d6                	mov    %edx,%esi
  801927:	88 d9                	mov    %bl,%cl
  801929:	d3 ee                	shr    %cl,%esi
  80192b:	89 f9                	mov    %edi,%ecx
  80192d:	d3 e2                	shl    %cl,%edx
  80192f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801933:	88 d9                	mov    %bl,%cl
  801935:	d3 e8                	shr    %cl,%eax
  801937:	09 c2                	or     %eax,%edx
  801939:	89 d0                	mov    %edx,%eax
  80193b:	89 f2                	mov    %esi,%edx
  80193d:	f7 74 24 0c          	divl   0xc(%esp)
  801941:	89 d6                	mov    %edx,%esi
  801943:	89 c3                	mov    %eax,%ebx
  801945:	f7 e5                	mul    %ebp
  801947:	39 d6                	cmp    %edx,%esi
  801949:	72 19                	jb     801964 <__udivdi3+0xfc>
  80194b:	74 0b                	je     801958 <__udivdi3+0xf0>
  80194d:	89 d8                	mov    %ebx,%eax
  80194f:	31 ff                	xor    %edi,%edi
  801951:	e9 58 ff ff ff       	jmp    8018ae <__udivdi3+0x46>
  801956:	66 90                	xchg   %ax,%ax
  801958:	8b 54 24 08          	mov    0x8(%esp),%edx
  80195c:	89 f9                	mov    %edi,%ecx
  80195e:	d3 e2                	shl    %cl,%edx
  801960:	39 c2                	cmp    %eax,%edx
  801962:	73 e9                	jae    80194d <__udivdi3+0xe5>
  801964:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801967:	31 ff                	xor    %edi,%edi
  801969:	e9 40 ff ff ff       	jmp    8018ae <__udivdi3+0x46>
  80196e:	66 90                	xchg   %ax,%ax
  801970:	31 c0                	xor    %eax,%eax
  801972:	e9 37 ff ff ff       	jmp    8018ae <__udivdi3+0x46>
  801977:	90                   	nop

00801978 <__umoddi3>:
  801978:	55                   	push   %ebp
  801979:	57                   	push   %edi
  80197a:	56                   	push   %esi
  80197b:	53                   	push   %ebx
  80197c:	83 ec 1c             	sub    $0x1c,%esp
  80197f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801983:	8b 74 24 34          	mov    0x34(%esp),%esi
  801987:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80198b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80198f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801993:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801997:	89 f3                	mov    %esi,%ebx
  801999:	89 fa                	mov    %edi,%edx
  80199b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80199f:	89 34 24             	mov    %esi,(%esp)
  8019a2:	85 c0                	test   %eax,%eax
  8019a4:	75 1a                	jne    8019c0 <__umoddi3+0x48>
  8019a6:	39 f7                	cmp    %esi,%edi
  8019a8:	0f 86 a2 00 00 00    	jbe    801a50 <__umoddi3+0xd8>
  8019ae:	89 c8                	mov    %ecx,%eax
  8019b0:	89 f2                	mov    %esi,%edx
  8019b2:	f7 f7                	div    %edi
  8019b4:	89 d0                	mov    %edx,%eax
  8019b6:	31 d2                	xor    %edx,%edx
  8019b8:	83 c4 1c             	add    $0x1c,%esp
  8019bb:	5b                   	pop    %ebx
  8019bc:	5e                   	pop    %esi
  8019bd:	5f                   	pop    %edi
  8019be:	5d                   	pop    %ebp
  8019bf:	c3                   	ret    
  8019c0:	39 f0                	cmp    %esi,%eax
  8019c2:	0f 87 ac 00 00 00    	ja     801a74 <__umoddi3+0xfc>
  8019c8:	0f bd e8             	bsr    %eax,%ebp
  8019cb:	83 f5 1f             	xor    $0x1f,%ebp
  8019ce:	0f 84 ac 00 00 00    	je     801a80 <__umoddi3+0x108>
  8019d4:	bf 20 00 00 00       	mov    $0x20,%edi
  8019d9:	29 ef                	sub    %ebp,%edi
  8019db:	89 fe                	mov    %edi,%esi
  8019dd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8019e1:	89 e9                	mov    %ebp,%ecx
  8019e3:	d3 e0                	shl    %cl,%eax
  8019e5:	89 d7                	mov    %edx,%edi
  8019e7:	89 f1                	mov    %esi,%ecx
  8019e9:	d3 ef                	shr    %cl,%edi
  8019eb:	09 c7                	or     %eax,%edi
  8019ed:	89 e9                	mov    %ebp,%ecx
  8019ef:	d3 e2                	shl    %cl,%edx
  8019f1:	89 14 24             	mov    %edx,(%esp)
  8019f4:	89 d8                	mov    %ebx,%eax
  8019f6:	d3 e0                	shl    %cl,%eax
  8019f8:	89 c2                	mov    %eax,%edx
  8019fa:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019fe:	d3 e0                	shl    %cl,%eax
  801a00:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a04:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a08:	89 f1                	mov    %esi,%ecx
  801a0a:	d3 e8                	shr    %cl,%eax
  801a0c:	09 d0                	or     %edx,%eax
  801a0e:	d3 eb                	shr    %cl,%ebx
  801a10:	89 da                	mov    %ebx,%edx
  801a12:	f7 f7                	div    %edi
  801a14:	89 d3                	mov    %edx,%ebx
  801a16:	f7 24 24             	mull   (%esp)
  801a19:	89 c6                	mov    %eax,%esi
  801a1b:	89 d1                	mov    %edx,%ecx
  801a1d:	39 d3                	cmp    %edx,%ebx
  801a1f:	0f 82 87 00 00 00    	jb     801aac <__umoddi3+0x134>
  801a25:	0f 84 91 00 00 00    	je     801abc <__umoddi3+0x144>
  801a2b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801a2f:	29 f2                	sub    %esi,%edx
  801a31:	19 cb                	sbb    %ecx,%ebx
  801a33:	89 d8                	mov    %ebx,%eax
  801a35:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801a39:	d3 e0                	shl    %cl,%eax
  801a3b:	89 e9                	mov    %ebp,%ecx
  801a3d:	d3 ea                	shr    %cl,%edx
  801a3f:	09 d0                	or     %edx,%eax
  801a41:	89 e9                	mov    %ebp,%ecx
  801a43:	d3 eb                	shr    %cl,%ebx
  801a45:	89 da                	mov    %ebx,%edx
  801a47:	83 c4 1c             	add    $0x1c,%esp
  801a4a:	5b                   	pop    %ebx
  801a4b:	5e                   	pop    %esi
  801a4c:	5f                   	pop    %edi
  801a4d:	5d                   	pop    %ebp
  801a4e:	c3                   	ret    
  801a4f:	90                   	nop
  801a50:	89 fd                	mov    %edi,%ebp
  801a52:	85 ff                	test   %edi,%edi
  801a54:	75 0b                	jne    801a61 <__umoddi3+0xe9>
  801a56:	b8 01 00 00 00       	mov    $0x1,%eax
  801a5b:	31 d2                	xor    %edx,%edx
  801a5d:	f7 f7                	div    %edi
  801a5f:	89 c5                	mov    %eax,%ebp
  801a61:	89 f0                	mov    %esi,%eax
  801a63:	31 d2                	xor    %edx,%edx
  801a65:	f7 f5                	div    %ebp
  801a67:	89 c8                	mov    %ecx,%eax
  801a69:	f7 f5                	div    %ebp
  801a6b:	89 d0                	mov    %edx,%eax
  801a6d:	e9 44 ff ff ff       	jmp    8019b6 <__umoddi3+0x3e>
  801a72:	66 90                	xchg   %ax,%ax
  801a74:	89 c8                	mov    %ecx,%eax
  801a76:	89 f2                	mov    %esi,%edx
  801a78:	83 c4 1c             	add    $0x1c,%esp
  801a7b:	5b                   	pop    %ebx
  801a7c:	5e                   	pop    %esi
  801a7d:	5f                   	pop    %edi
  801a7e:	5d                   	pop    %ebp
  801a7f:	c3                   	ret    
  801a80:	3b 04 24             	cmp    (%esp),%eax
  801a83:	72 06                	jb     801a8b <__umoddi3+0x113>
  801a85:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801a89:	77 0f                	ja     801a9a <__umoddi3+0x122>
  801a8b:	89 f2                	mov    %esi,%edx
  801a8d:	29 f9                	sub    %edi,%ecx
  801a8f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801a93:	89 14 24             	mov    %edx,(%esp)
  801a96:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a9a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801a9e:	8b 14 24             	mov    (%esp),%edx
  801aa1:	83 c4 1c             	add    $0x1c,%esp
  801aa4:	5b                   	pop    %ebx
  801aa5:	5e                   	pop    %esi
  801aa6:	5f                   	pop    %edi
  801aa7:	5d                   	pop    %ebp
  801aa8:	c3                   	ret    
  801aa9:	8d 76 00             	lea    0x0(%esi),%esi
  801aac:	2b 04 24             	sub    (%esp),%eax
  801aaf:	19 fa                	sbb    %edi,%edx
  801ab1:	89 d1                	mov    %edx,%ecx
  801ab3:	89 c6                	mov    %eax,%esi
  801ab5:	e9 71 ff ff ff       	jmp    801a2b <__umoddi3+0xb3>
  801aba:	66 90                	xchg   %ax,%ax
  801abc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801ac0:	72 ea                	jb     801aac <__umoddi3+0x134>
  801ac2:	89 d9                	mov    %ebx,%ecx
  801ac4:	e9 62 ff ff ff       	jmp    801a2b <__umoddi3+0xb3>
