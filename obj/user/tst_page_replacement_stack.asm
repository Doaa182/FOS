
obj/user/tst_page_replacement_stack:     file format elf32-i386


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
  800031:	e8 f9 00 00 00       	call   80012f <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/************************************************************/

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 14 a0 00 00    	sub    $0xa014,%esp
	char arr[PAGE_SIZE*10];

	uint32 kilo = 1024;
  800042:	c7 45 f0 00 04 00 00 	movl   $0x400,-0x10(%ebp)

//	cprintf("envID = %d\n",envID);

	int freePages = sys_calculate_free_frames();
  800049:	e8 47 13 00 00       	call   801395 <sys_calculate_free_frames>
  80004e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  800051:	e8 df 13 00 00       	call   801435 <sys_pf_calculate_allocated_pages>
  800056:	89 45 e8             	mov    %eax,-0x18(%ebp)

	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800059:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800060:	eb 15                	jmp    800077 <_main+0x3f>
		arr[i] = -1 ;
  800062:	8d 95 e8 5f ff ff    	lea    -0xa018(%ebp),%edx
  800068:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80006b:	01 d0                	add    %edx,%eax
  80006d:	c6 00 ff             	movb   $0xff,(%eax)

	int freePages = sys_calculate_free_frames();
	int usedDiskPages = sys_pf_calculate_allocated_pages();

	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800070:	81 45 f4 00 08 00 00 	addl   $0x800,-0xc(%ebp)
  800077:	81 7d f4 ff 9f 00 00 	cmpl   $0x9fff,-0xc(%ebp)
  80007e:	7e e2                	jle    800062 <_main+0x2a>
		arr[i] = -1 ;


	cprintf("checking REPLACEMENT fault handling of STACK pages... \n");
  800080:	83 ec 0c             	sub    $0xc,%esp
  800083:	68 80 1b 80 00       	push   $0x801b80
  800088:	e8 92 04 00 00       	call   80051f <cprintf>
  80008d:	83 c4 10             	add    $0x10,%esp
	{
		for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800090:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800097:	eb 2c                	jmp    8000c5 <_main+0x8d>
			if( arr[i] != -1) panic("modified stack page(s) not restored correctly");
  800099:	8d 95 e8 5f ff ff    	lea    -0xa018(%ebp),%edx
  80009f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000a2:	01 d0                	add    %edx,%eax
  8000a4:	8a 00                	mov    (%eax),%al
  8000a6:	3c ff                	cmp    $0xff,%al
  8000a8:	74 14                	je     8000be <_main+0x86>
  8000aa:	83 ec 04             	sub    $0x4,%esp
  8000ad:	68 b8 1b 80 00       	push   $0x801bb8
  8000b2:	6a 1a                	push   $0x1a
  8000b4:	68 e8 1b 80 00       	push   $0x801be8
  8000b9:	e8 ad 01 00 00       	call   80026b <_panic>
		arr[i] = -1 ;


	cprintf("checking REPLACEMENT fault handling of STACK pages... \n");
	{
		for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8000be:	81 45 f4 00 08 00 00 	addl   $0x800,-0xc(%ebp)
  8000c5:	81 7d f4 ff 9f 00 00 	cmpl   $0x9fff,-0xc(%ebp)
  8000cc:	7e cb                	jle    800099 <_main+0x61>
			if( arr[i] != -1) panic("modified stack page(s) not restored correctly");

		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  10) panic("Unexpected extra/less pages have been added to page file");
  8000ce:	e8 62 13 00 00       	call   801435 <sys_pf_calculate_allocated_pages>
  8000d3:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000d6:	83 f8 0a             	cmp    $0xa,%eax
  8000d9:	74 14                	je     8000ef <_main+0xb7>
  8000db:	83 ec 04             	sub    $0x4,%esp
  8000de:	68 0c 1c 80 00       	push   $0x801c0c
  8000e3:	6a 1c                	push   $0x1c
  8000e5:	68 e8 1b 80 00       	push   $0x801be8
  8000ea:	e8 7c 01 00 00       	call   80026b <_panic>

		if( (freePages - (sys_calculate_free_frames() + sys_calculate_modified_frames())) != 0 ) panic("Extra memory are wrongly allocated... It's REplacement: expected that no extra frames are allocated");
  8000ef:	e8 a1 12 00 00       	call   801395 <sys_calculate_free_frames>
  8000f4:	89 c3                	mov    %eax,%ebx
  8000f6:	e8 b3 12 00 00       	call   8013ae <sys_calculate_modified_frames>
  8000fb:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  8000fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800101:	39 c2                	cmp    %eax,%edx
  800103:	74 14                	je     800119 <_main+0xe1>
  800105:	83 ec 04             	sub    $0x4,%esp
  800108:	68 48 1c 80 00       	push   $0x801c48
  80010d:	6a 1e                	push   $0x1e
  80010f:	68 e8 1b 80 00       	push   $0x801be8
  800114:	e8 52 01 00 00       	call   80026b <_panic>
	}//consider tables of PF, disk pages

	cprintf("Congratulations: stack pages created, modified and read successfully!\n\n");
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	68 ac 1c 80 00       	push   $0x801cac
  800121:	e8 f9 03 00 00       	call   80051f <cprintf>
  800126:	83 c4 10             	add    $0x10,%esp


	return;
  800129:	90                   	nop
}
  80012a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80012d:	c9                   	leave  
  80012e:	c3                   	ret    

0080012f <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80012f:	55                   	push   %ebp
  800130:	89 e5                	mov    %esp,%ebp
  800132:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800135:	e8 3b 15 00 00       	call   801675 <sys_getenvindex>
  80013a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80013d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800140:	89 d0                	mov    %edx,%eax
  800142:	c1 e0 03             	shl    $0x3,%eax
  800145:	01 d0                	add    %edx,%eax
  800147:	01 c0                	add    %eax,%eax
  800149:	01 d0                	add    %edx,%eax
  80014b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800152:	01 d0                	add    %edx,%eax
  800154:	c1 e0 04             	shl    $0x4,%eax
  800157:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80015c:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800161:	a1 20 30 80 00       	mov    0x803020,%eax
  800166:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80016c:	84 c0                	test   %al,%al
  80016e:	74 0f                	je     80017f <libmain+0x50>
		binaryname = myEnv->prog_name;
  800170:	a1 20 30 80 00       	mov    0x803020,%eax
  800175:	05 5c 05 00 00       	add    $0x55c,%eax
  80017a:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80017f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800183:	7e 0a                	jle    80018f <libmain+0x60>
		binaryname = argv[0];
  800185:	8b 45 0c             	mov    0xc(%ebp),%eax
  800188:	8b 00                	mov    (%eax),%eax
  80018a:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80018f:	83 ec 08             	sub    $0x8,%esp
  800192:	ff 75 0c             	pushl  0xc(%ebp)
  800195:	ff 75 08             	pushl  0x8(%ebp)
  800198:	e8 9b fe ff ff       	call   800038 <_main>
  80019d:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001a0:	e8 dd 12 00 00       	call   801482 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001a5:	83 ec 0c             	sub    $0xc,%esp
  8001a8:	68 0c 1d 80 00       	push   $0x801d0c
  8001ad:	e8 6d 03 00 00       	call   80051f <cprintf>
  8001b2:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001b5:	a1 20 30 80 00       	mov    0x803020,%eax
  8001ba:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001c0:	a1 20 30 80 00       	mov    0x803020,%eax
  8001c5:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001cb:	83 ec 04             	sub    $0x4,%esp
  8001ce:	52                   	push   %edx
  8001cf:	50                   	push   %eax
  8001d0:	68 34 1d 80 00       	push   $0x801d34
  8001d5:	e8 45 03 00 00       	call   80051f <cprintf>
  8001da:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001dd:	a1 20 30 80 00       	mov    0x803020,%eax
  8001e2:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8001e8:	a1 20 30 80 00       	mov    0x803020,%eax
  8001ed:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8001f3:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f8:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8001fe:	51                   	push   %ecx
  8001ff:	52                   	push   %edx
  800200:	50                   	push   %eax
  800201:	68 5c 1d 80 00       	push   $0x801d5c
  800206:	e8 14 03 00 00       	call   80051f <cprintf>
  80020b:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80020e:	a1 20 30 80 00       	mov    0x803020,%eax
  800213:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800219:	83 ec 08             	sub    $0x8,%esp
  80021c:	50                   	push   %eax
  80021d:	68 b4 1d 80 00       	push   $0x801db4
  800222:	e8 f8 02 00 00       	call   80051f <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80022a:	83 ec 0c             	sub    $0xc,%esp
  80022d:	68 0c 1d 80 00       	push   $0x801d0c
  800232:	e8 e8 02 00 00       	call   80051f <cprintf>
  800237:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80023a:	e8 5d 12 00 00       	call   80149c <sys_enable_interrupt>

	// exit gracefully
	exit();
  80023f:	e8 19 00 00 00       	call   80025d <exit>
}
  800244:	90                   	nop
  800245:	c9                   	leave  
  800246:	c3                   	ret    

00800247 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800247:	55                   	push   %ebp
  800248:	89 e5                	mov    %esp,%ebp
  80024a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80024d:	83 ec 0c             	sub    $0xc,%esp
  800250:	6a 00                	push   $0x0
  800252:	e8 ea 13 00 00       	call   801641 <sys_destroy_env>
  800257:	83 c4 10             	add    $0x10,%esp
}
  80025a:	90                   	nop
  80025b:	c9                   	leave  
  80025c:	c3                   	ret    

0080025d <exit>:

void
exit(void)
{
  80025d:	55                   	push   %ebp
  80025e:	89 e5                	mov    %esp,%ebp
  800260:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800263:	e8 3f 14 00 00       	call   8016a7 <sys_exit_env>
}
  800268:	90                   	nop
  800269:	c9                   	leave  
  80026a:	c3                   	ret    

0080026b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80026b:	55                   	push   %ebp
  80026c:	89 e5                	mov    %esp,%ebp
  80026e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800271:	8d 45 10             	lea    0x10(%ebp),%eax
  800274:	83 c0 04             	add    $0x4,%eax
  800277:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80027a:	a1 5c 31 80 00       	mov    0x80315c,%eax
  80027f:	85 c0                	test   %eax,%eax
  800281:	74 16                	je     800299 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800283:	a1 5c 31 80 00       	mov    0x80315c,%eax
  800288:	83 ec 08             	sub    $0x8,%esp
  80028b:	50                   	push   %eax
  80028c:	68 c8 1d 80 00       	push   $0x801dc8
  800291:	e8 89 02 00 00       	call   80051f <cprintf>
  800296:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800299:	a1 00 30 80 00       	mov    0x803000,%eax
  80029e:	ff 75 0c             	pushl  0xc(%ebp)
  8002a1:	ff 75 08             	pushl  0x8(%ebp)
  8002a4:	50                   	push   %eax
  8002a5:	68 cd 1d 80 00       	push   $0x801dcd
  8002aa:	e8 70 02 00 00       	call   80051f <cprintf>
  8002af:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8002b5:	83 ec 08             	sub    $0x8,%esp
  8002b8:	ff 75 f4             	pushl  -0xc(%ebp)
  8002bb:	50                   	push   %eax
  8002bc:	e8 f3 01 00 00       	call   8004b4 <vcprintf>
  8002c1:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002c4:	83 ec 08             	sub    $0x8,%esp
  8002c7:	6a 00                	push   $0x0
  8002c9:	68 e9 1d 80 00       	push   $0x801de9
  8002ce:	e8 e1 01 00 00       	call   8004b4 <vcprintf>
  8002d3:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002d6:	e8 82 ff ff ff       	call   80025d <exit>

	// should not return here
	while (1) ;
  8002db:	eb fe                	jmp    8002db <_panic+0x70>

008002dd <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002dd:	55                   	push   %ebp
  8002de:	89 e5                	mov    %esp,%ebp
  8002e0:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002e3:	a1 20 30 80 00       	mov    0x803020,%eax
  8002e8:	8b 50 74             	mov    0x74(%eax),%edx
  8002eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ee:	39 c2                	cmp    %eax,%edx
  8002f0:	74 14                	je     800306 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002f2:	83 ec 04             	sub    $0x4,%esp
  8002f5:	68 ec 1d 80 00       	push   $0x801dec
  8002fa:	6a 26                	push   $0x26
  8002fc:	68 38 1e 80 00       	push   $0x801e38
  800301:	e8 65 ff ff ff       	call   80026b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800306:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80030d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800314:	e9 c2 00 00 00       	jmp    8003db <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800319:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80031c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800323:	8b 45 08             	mov    0x8(%ebp),%eax
  800326:	01 d0                	add    %edx,%eax
  800328:	8b 00                	mov    (%eax),%eax
  80032a:	85 c0                	test   %eax,%eax
  80032c:	75 08                	jne    800336 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80032e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800331:	e9 a2 00 00 00       	jmp    8003d8 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800336:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80033d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800344:	eb 69                	jmp    8003af <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800346:	a1 20 30 80 00       	mov    0x803020,%eax
  80034b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800351:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800354:	89 d0                	mov    %edx,%eax
  800356:	01 c0                	add    %eax,%eax
  800358:	01 d0                	add    %edx,%eax
  80035a:	c1 e0 03             	shl    $0x3,%eax
  80035d:	01 c8                	add    %ecx,%eax
  80035f:	8a 40 04             	mov    0x4(%eax),%al
  800362:	84 c0                	test   %al,%al
  800364:	75 46                	jne    8003ac <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800366:	a1 20 30 80 00       	mov    0x803020,%eax
  80036b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800371:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800374:	89 d0                	mov    %edx,%eax
  800376:	01 c0                	add    %eax,%eax
  800378:	01 d0                	add    %edx,%eax
  80037a:	c1 e0 03             	shl    $0x3,%eax
  80037d:	01 c8                	add    %ecx,%eax
  80037f:	8b 00                	mov    (%eax),%eax
  800381:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800384:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800387:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80038c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80038e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800391:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800398:	8b 45 08             	mov    0x8(%ebp),%eax
  80039b:	01 c8                	add    %ecx,%eax
  80039d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80039f:	39 c2                	cmp    %eax,%edx
  8003a1:	75 09                	jne    8003ac <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003a3:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003aa:	eb 12                	jmp    8003be <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003ac:	ff 45 e8             	incl   -0x18(%ebp)
  8003af:	a1 20 30 80 00       	mov    0x803020,%eax
  8003b4:	8b 50 74             	mov    0x74(%eax),%edx
  8003b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003ba:	39 c2                	cmp    %eax,%edx
  8003bc:	77 88                	ja     800346 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003be:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003c2:	75 14                	jne    8003d8 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003c4:	83 ec 04             	sub    $0x4,%esp
  8003c7:	68 44 1e 80 00       	push   $0x801e44
  8003cc:	6a 3a                	push   $0x3a
  8003ce:	68 38 1e 80 00       	push   $0x801e38
  8003d3:	e8 93 fe ff ff       	call   80026b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003d8:	ff 45 f0             	incl   -0x10(%ebp)
  8003db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003de:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003e1:	0f 8c 32 ff ff ff    	jl     800319 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003e7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003ee:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003f5:	eb 26                	jmp    80041d <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8003f7:	a1 20 30 80 00       	mov    0x803020,%eax
  8003fc:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800402:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800405:	89 d0                	mov    %edx,%eax
  800407:	01 c0                	add    %eax,%eax
  800409:	01 d0                	add    %edx,%eax
  80040b:	c1 e0 03             	shl    $0x3,%eax
  80040e:	01 c8                	add    %ecx,%eax
  800410:	8a 40 04             	mov    0x4(%eax),%al
  800413:	3c 01                	cmp    $0x1,%al
  800415:	75 03                	jne    80041a <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800417:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80041a:	ff 45 e0             	incl   -0x20(%ebp)
  80041d:	a1 20 30 80 00       	mov    0x803020,%eax
  800422:	8b 50 74             	mov    0x74(%eax),%edx
  800425:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800428:	39 c2                	cmp    %eax,%edx
  80042a:	77 cb                	ja     8003f7 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80042c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80042f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800432:	74 14                	je     800448 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800434:	83 ec 04             	sub    $0x4,%esp
  800437:	68 98 1e 80 00       	push   $0x801e98
  80043c:	6a 44                	push   $0x44
  80043e:	68 38 1e 80 00       	push   $0x801e38
  800443:	e8 23 fe ff ff       	call   80026b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800448:	90                   	nop
  800449:	c9                   	leave  
  80044a:	c3                   	ret    

0080044b <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80044b:	55                   	push   %ebp
  80044c:	89 e5                	mov    %esp,%ebp
  80044e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800451:	8b 45 0c             	mov    0xc(%ebp),%eax
  800454:	8b 00                	mov    (%eax),%eax
  800456:	8d 48 01             	lea    0x1(%eax),%ecx
  800459:	8b 55 0c             	mov    0xc(%ebp),%edx
  80045c:	89 0a                	mov    %ecx,(%edx)
  80045e:	8b 55 08             	mov    0x8(%ebp),%edx
  800461:	88 d1                	mov    %dl,%cl
  800463:	8b 55 0c             	mov    0xc(%ebp),%edx
  800466:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80046a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046d:	8b 00                	mov    (%eax),%eax
  80046f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800474:	75 2c                	jne    8004a2 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800476:	a0 24 30 80 00       	mov    0x803024,%al
  80047b:	0f b6 c0             	movzbl %al,%eax
  80047e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800481:	8b 12                	mov    (%edx),%edx
  800483:	89 d1                	mov    %edx,%ecx
  800485:	8b 55 0c             	mov    0xc(%ebp),%edx
  800488:	83 c2 08             	add    $0x8,%edx
  80048b:	83 ec 04             	sub    $0x4,%esp
  80048e:	50                   	push   %eax
  80048f:	51                   	push   %ecx
  800490:	52                   	push   %edx
  800491:	e8 3e 0e 00 00       	call   8012d4 <sys_cputs>
  800496:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800499:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a5:	8b 40 04             	mov    0x4(%eax),%eax
  8004a8:	8d 50 01             	lea    0x1(%eax),%edx
  8004ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ae:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004b1:	90                   	nop
  8004b2:	c9                   	leave  
  8004b3:	c3                   	ret    

008004b4 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004b4:	55                   	push   %ebp
  8004b5:	89 e5                	mov    %esp,%ebp
  8004b7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004bd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004c4:	00 00 00 
	b.cnt = 0;
  8004c7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004ce:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004d1:	ff 75 0c             	pushl  0xc(%ebp)
  8004d4:	ff 75 08             	pushl  0x8(%ebp)
  8004d7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004dd:	50                   	push   %eax
  8004de:	68 4b 04 80 00       	push   $0x80044b
  8004e3:	e8 11 02 00 00       	call   8006f9 <vprintfmt>
  8004e8:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004eb:	a0 24 30 80 00       	mov    0x803024,%al
  8004f0:	0f b6 c0             	movzbl %al,%eax
  8004f3:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8004f9:	83 ec 04             	sub    $0x4,%esp
  8004fc:	50                   	push   %eax
  8004fd:	52                   	push   %edx
  8004fe:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800504:	83 c0 08             	add    $0x8,%eax
  800507:	50                   	push   %eax
  800508:	e8 c7 0d 00 00       	call   8012d4 <sys_cputs>
  80050d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800510:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800517:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80051d:	c9                   	leave  
  80051e:	c3                   	ret    

0080051f <cprintf>:

int cprintf(const char *fmt, ...) {
  80051f:	55                   	push   %ebp
  800520:	89 e5                	mov    %esp,%ebp
  800522:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800525:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  80052c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80052f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800532:	8b 45 08             	mov    0x8(%ebp),%eax
  800535:	83 ec 08             	sub    $0x8,%esp
  800538:	ff 75 f4             	pushl  -0xc(%ebp)
  80053b:	50                   	push   %eax
  80053c:	e8 73 ff ff ff       	call   8004b4 <vcprintf>
  800541:	83 c4 10             	add    $0x10,%esp
  800544:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800547:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80054a:	c9                   	leave  
  80054b:	c3                   	ret    

0080054c <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80054c:	55                   	push   %ebp
  80054d:	89 e5                	mov    %esp,%ebp
  80054f:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800552:	e8 2b 0f 00 00       	call   801482 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800557:	8d 45 0c             	lea    0xc(%ebp),%eax
  80055a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80055d:	8b 45 08             	mov    0x8(%ebp),%eax
  800560:	83 ec 08             	sub    $0x8,%esp
  800563:	ff 75 f4             	pushl  -0xc(%ebp)
  800566:	50                   	push   %eax
  800567:	e8 48 ff ff ff       	call   8004b4 <vcprintf>
  80056c:	83 c4 10             	add    $0x10,%esp
  80056f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800572:	e8 25 0f 00 00       	call   80149c <sys_enable_interrupt>
	return cnt;
  800577:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80057a:	c9                   	leave  
  80057b:	c3                   	ret    

0080057c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80057c:	55                   	push   %ebp
  80057d:	89 e5                	mov    %esp,%ebp
  80057f:	53                   	push   %ebx
  800580:	83 ec 14             	sub    $0x14,%esp
  800583:	8b 45 10             	mov    0x10(%ebp),%eax
  800586:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800589:	8b 45 14             	mov    0x14(%ebp),%eax
  80058c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80058f:	8b 45 18             	mov    0x18(%ebp),%eax
  800592:	ba 00 00 00 00       	mov    $0x0,%edx
  800597:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80059a:	77 55                	ja     8005f1 <printnum+0x75>
  80059c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80059f:	72 05                	jb     8005a6 <printnum+0x2a>
  8005a1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005a4:	77 4b                	ja     8005f1 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005a6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005a9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005ac:	8b 45 18             	mov    0x18(%ebp),%eax
  8005af:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b4:	52                   	push   %edx
  8005b5:	50                   	push   %eax
  8005b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8005b9:	ff 75 f0             	pushl  -0x10(%ebp)
  8005bc:	e8 47 13 00 00       	call   801908 <__udivdi3>
  8005c1:	83 c4 10             	add    $0x10,%esp
  8005c4:	83 ec 04             	sub    $0x4,%esp
  8005c7:	ff 75 20             	pushl  0x20(%ebp)
  8005ca:	53                   	push   %ebx
  8005cb:	ff 75 18             	pushl  0x18(%ebp)
  8005ce:	52                   	push   %edx
  8005cf:	50                   	push   %eax
  8005d0:	ff 75 0c             	pushl  0xc(%ebp)
  8005d3:	ff 75 08             	pushl  0x8(%ebp)
  8005d6:	e8 a1 ff ff ff       	call   80057c <printnum>
  8005db:	83 c4 20             	add    $0x20,%esp
  8005de:	eb 1a                	jmp    8005fa <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005e0:	83 ec 08             	sub    $0x8,%esp
  8005e3:	ff 75 0c             	pushl  0xc(%ebp)
  8005e6:	ff 75 20             	pushl  0x20(%ebp)
  8005e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ec:	ff d0                	call   *%eax
  8005ee:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005f1:	ff 4d 1c             	decl   0x1c(%ebp)
  8005f4:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8005f8:	7f e6                	jg     8005e0 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005fa:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8005fd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800602:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800605:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800608:	53                   	push   %ebx
  800609:	51                   	push   %ecx
  80060a:	52                   	push   %edx
  80060b:	50                   	push   %eax
  80060c:	e8 07 14 00 00       	call   801a18 <__umoddi3>
  800611:	83 c4 10             	add    $0x10,%esp
  800614:	05 14 21 80 00       	add    $0x802114,%eax
  800619:	8a 00                	mov    (%eax),%al
  80061b:	0f be c0             	movsbl %al,%eax
  80061e:	83 ec 08             	sub    $0x8,%esp
  800621:	ff 75 0c             	pushl  0xc(%ebp)
  800624:	50                   	push   %eax
  800625:	8b 45 08             	mov    0x8(%ebp),%eax
  800628:	ff d0                	call   *%eax
  80062a:	83 c4 10             	add    $0x10,%esp
}
  80062d:	90                   	nop
  80062e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800631:	c9                   	leave  
  800632:	c3                   	ret    

00800633 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800633:	55                   	push   %ebp
  800634:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800636:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80063a:	7e 1c                	jle    800658 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80063c:	8b 45 08             	mov    0x8(%ebp),%eax
  80063f:	8b 00                	mov    (%eax),%eax
  800641:	8d 50 08             	lea    0x8(%eax),%edx
  800644:	8b 45 08             	mov    0x8(%ebp),%eax
  800647:	89 10                	mov    %edx,(%eax)
  800649:	8b 45 08             	mov    0x8(%ebp),%eax
  80064c:	8b 00                	mov    (%eax),%eax
  80064e:	83 e8 08             	sub    $0x8,%eax
  800651:	8b 50 04             	mov    0x4(%eax),%edx
  800654:	8b 00                	mov    (%eax),%eax
  800656:	eb 40                	jmp    800698 <getuint+0x65>
	else if (lflag)
  800658:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80065c:	74 1e                	je     80067c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80065e:	8b 45 08             	mov    0x8(%ebp),%eax
  800661:	8b 00                	mov    (%eax),%eax
  800663:	8d 50 04             	lea    0x4(%eax),%edx
  800666:	8b 45 08             	mov    0x8(%ebp),%eax
  800669:	89 10                	mov    %edx,(%eax)
  80066b:	8b 45 08             	mov    0x8(%ebp),%eax
  80066e:	8b 00                	mov    (%eax),%eax
  800670:	83 e8 04             	sub    $0x4,%eax
  800673:	8b 00                	mov    (%eax),%eax
  800675:	ba 00 00 00 00       	mov    $0x0,%edx
  80067a:	eb 1c                	jmp    800698 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80067c:	8b 45 08             	mov    0x8(%ebp),%eax
  80067f:	8b 00                	mov    (%eax),%eax
  800681:	8d 50 04             	lea    0x4(%eax),%edx
  800684:	8b 45 08             	mov    0x8(%ebp),%eax
  800687:	89 10                	mov    %edx,(%eax)
  800689:	8b 45 08             	mov    0x8(%ebp),%eax
  80068c:	8b 00                	mov    (%eax),%eax
  80068e:	83 e8 04             	sub    $0x4,%eax
  800691:	8b 00                	mov    (%eax),%eax
  800693:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800698:	5d                   	pop    %ebp
  800699:	c3                   	ret    

0080069a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80069a:	55                   	push   %ebp
  80069b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80069d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006a1:	7e 1c                	jle    8006bf <getint+0x25>
		return va_arg(*ap, long long);
  8006a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a6:	8b 00                	mov    (%eax),%eax
  8006a8:	8d 50 08             	lea    0x8(%eax),%edx
  8006ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ae:	89 10                	mov    %edx,(%eax)
  8006b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b3:	8b 00                	mov    (%eax),%eax
  8006b5:	83 e8 08             	sub    $0x8,%eax
  8006b8:	8b 50 04             	mov    0x4(%eax),%edx
  8006bb:	8b 00                	mov    (%eax),%eax
  8006bd:	eb 38                	jmp    8006f7 <getint+0x5d>
	else if (lflag)
  8006bf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006c3:	74 1a                	je     8006df <getint+0x45>
		return va_arg(*ap, long);
  8006c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c8:	8b 00                	mov    (%eax),%eax
  8006ca:	8d 50 04             	lea    0x4(%eax),%edx
  8006cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d0:	89 10                	mov    %edx,(%eax)
  8006d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d5:	8b 00                	mov    (%eax),%eax
  8006d7:	83 e8 04             	sub    $0x4,%eax
  8006da:	8b 00                	mov    (%eax),%eax
  8006dc:	99                   	cltd   
  8006dd:	eb 18                	jmp    8006f7 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006df:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e2:	8b 00                	mov    (%eax),%eax
  8006e4:	8d 50 04             	lea    0x4(%eax),%edx
  8006e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ea:	89 10                	mov    %edx,(%eax)
  8006ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ef:	8b 00                	mov    (%eax),%eax
  8006f1:	83 e8 04             	sub    $0x4,%eax
  8006f4:	8b 00                	mov    (%eax),%eax
  8006f6:	99                   	cltd   
}
  8006f7:	5d                   	pop    %ebp
  8006f8:	c3                   	ret    

008006f9 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006f9:	55                   	push   %ebp
  8006fa:	89 e5                	mov    %esp,%ebp
  8006fc:	56                   	push   %esi
  8006fd:	53                   	push   %ebx
  8006fe:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800701:	eb 17                	jmp    80071a <vprintfmt+0x21>
			if (ch == '\0')
  800703:	85 db                	test   %ebx,%ebx
  800705:	0f 84 af 03 00 00    	je     800aba <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80070b:	83 ec 08             	sub    $0x8,%esp
  80070e:	ff 75 0c             	pushl  0xc(%ebp)
  800711:	53                   	push   %ebx
  800712:	8b 45 08             	mov    0x8(%ebp),%eax
  800715:	ff d0                	call   *%eax
  800717:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80071a:	8b 45 10             	mov    0x10(%ebp),%eax
  80071d:	8d 50 01             	lea    0x1(%eax),%edx
  800720:	89 55 10             	mov    %edx,0x10(%ebp)
  800723:	8a 00                	mov    (%eax),%al
  800725:	0f b6 d8             	movzbl %al,%ebx
  800728:	83 fb 25             	cmp    $0x25,%ebx
  80072b:	75 d6                	jne    800703 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80072d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800731:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800738:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80073f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800746:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80074d:	8b 45 10             	mov    0x10(%ebp),%eax
  800750:	8d 50 01             	lea    0x1(%eax),%edx
  800753:	89 55 10             	mov    %edx,0x10(%ebp)
  800756:	8a 00                	mov    (%eax),%al
  800758:	0f b6 d8             	movzbl %al,%ebx
  80075b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80075e:	83 f8 55             	cmp    $0x55,%eax
  800761:	0f 87 2b 03 00 00    	ja     800a92 <vprintfmt+0x399>
  800767:	8b 04 85 38 21 80 00 	mov    0x802138(,%eax,4),%eax
  80076e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800770:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800774:	eb d7                	jmp    80074d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800776:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80077a:	eb d1                	jmp    80074d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80077c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800783:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800786:	89 d0                	mov    %edx,%eax
  800788:	c1 e0 02             	shl    $0x2,%eax
  80078b:	01 d0                	add    %edx,%eax
  80078d:	01 c0                	add    %eax,%eax
  80078f:	01 d8                	add    %ebx,%eax
  800791:	83 e8 30             	sub    $0x30,%eax
  800794:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800797:	8b 45 10             	mov    0x10(%ebp),%eax
  80079a:	8a 00                	mov    (%eax),%al
  80079c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80079f:	83 fb 2f             	cmp    $0x2f,%ebx
  8007a2:	7e 3e                	jle    8007e2 <vprintfmt+0xe9>
  8007a4:	83 fb 39             	cmp    $0x39,%ebx
  8007a7:	7f 39                	jg     8007e2 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007a9:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007ac:	eb d5                	jmp    800783 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b1:	83 c0 04             	add    $0x4,%eax
  8007b4:	89 45 14             	mov    %eax,0x14(%ebp)
  8007b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ba:	83 e8 04             	sub    $0x4,%eax
  8007bd:	8b 00                	mov    (%eax),%eax
  8007bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007c2:	eb 1f                	jmp    8007e3 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007c8:	79 83                	jns    80074d <vprintfmt+0x54>
				width = 0;
  8007ca:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007d1:	e9 77 ff ff ff       	jmp    80074d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007d6:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007dd:	e9 6b ff ff ff       	jmp    80074d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007e2:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007e3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007e7:	0f 89 60 ff ff ff    	jns    80074d <vprintfmt+0x54>
				width = precision, precision = -1;
  8007ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007f3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8007fa:	e9 4e ff ff ff       	jmp    80074d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007ff:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800802:	e9 46 ff ff ff       	jmp    80074d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800807:	8b 45 14             	mov    0x14(%ebp),%eax
  80080a:	83 c0 04             	add    $0x4,%eax
  80080d:	89 45 14             	mov    %eax,0x14(%ebp)
  800810:	8b 45 14             	mov    0x14(%ebp),%eax
  800813:	83 e8 04             	sub    $0x4,%eax
  800816:	8b 00                	mov    (%eax),%eax
  800818:	83 ec 08             	sub    $0x8,%esp
  80081b:	ff 75 0c             	pushl  0xc(%ebp)
  80081e:	50                   	push   %eax
  80081f:	8b 45 08             	mov    0x8(%ebp),%eax
  800822:	ff d0                	call   *%eax
  800824:	83 c4 10             	add    $0x10,%esp
			break;
  800827:	e9 89 02 00 00       	jmp    800ab5 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80082c:	8b 45 14             	mov    0x14(%ebp),%eax
  80082f:	83 c0 04             	add    $0x4,%eax
  800832:	89 45 14             	mov    %eax,0x14(%ebp)
  800835:	8b 45 14             	mov    0x14(%ebp),%eax
  800838:	83 e8 04             	sub    $0x4,%eax
  80083b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80083d:	85 db                	test   %ebx,%ebx
  80083f:	79 02                	jns    800843 <vprintfmt+0x14a>
				err = -err;
  800841:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800843:	83 fb 64             	cmp    $0x64,%ebx
  800846:	7f 0b                	jg     800853 <vprintfmt+0x15a>
  800848:	8b 34 9d 80 1f 80 00 	mov    0x801f80(,%ebx,4),%esi
  80084f:	85 f6                	test   %esi,%esi
  800851:	75 19                	jne    80086c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800853:	53                   	push   %ebx
  800854:	68 25 21 80 00       	push   $0x802125
  800859:	ff 75 0c             	pushl  0xc(%ebp)
  80085c:	ff 75 08             	pushl  0x8(%ebp)
  80085f:	e8 5e 02 00 00       	call   800ac2 <printfmt>
  800864:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800867:	e9 49 02 00 00       	jmp    800ab5 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80086c:	56                   	push   %esi
  80086d:	68 2e 21 80 00       	push   $0x80212e
  800872:	ff 75 0c             	pushl  0xc(%ebp)
  800875:	ff 75 08             	pushl  0x8(%ebp)
  800878:	e8 45 02 00 00       	call   800ac2 <printfmt>
  80087d:	83 c4 10             	add    $0x10,%esp
			break;
  800880:	e9 30 02 00 00       	jmp    800ab5 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800885:	8b 45 14             	mov    0x14(%ebp),%eax
  800888:	83 c0 04             	add    $0x4,%eax
  80088b:	89 45 14             	mov    %eax,0x14(%ebp)
  80088e:	8b 45 14             	mov    0x14(%ebp),%eax
  800891:	83 e8 04             	sub    $0x4,%eax
  800894:	8b 30                	mov    (%eax),%esi
  800896:	85 f6                	test   %esi,%esi
  800898:	75 05                	jne    80089f <vprintfmt+0x1a6>
				p = "(null)";
  80089a:	be 31 21 80 00       	mov    $0x802131,%esi
			if (width > 0 && padc != '-')
  80089f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008a3:	7e 6d                	jle    800912 <vprintfmt+0x219>
  8008a5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008a9:	74 67                	je     800912 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ae:	83 ec 08             	sub    $0x8,%esp
  8008b1:	50                   	push   %eax
  8008b2:	56                   	push   %esi
  8008b3:	e8 0c 03 00 00       	call   800bc4 <strnlen>
  8008b8:	83 c4 10             	add    $0x10,%esp
  8008bb:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008be:	eb 16                	jmp    8008d6 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008c0:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008c4:	83 ec 08             	sub    $0x8,%esp
  8008c7:	ff 75 0c             	pushl  0xc(%ebp)
  8008ca:	50                   	push   %eax
  8008cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ce:	ff d0                	call   *%eax
  8008d0:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008d3:	ff 4d e4             	decl   -0x1c(%ebp)
  8008d6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008da:	7f e4                	jg     8008c0 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008dc:	eb 34                	jmp    800912 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008de:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008e2:	74 1c                	je     800900 <vprintfmt+0x207>
  8008e4:	83 fb 1f             	cmp    $0x1f,%ebx
  8008e7:	7e 05                	jle    8008ee <vprintfmt+0x1f5>
  8008e9:	83 fb 7e             	cmp    $0x7e,%ebx
  8008ec:	7e 12                	jle    800900 <vprintfmt+0x207>
					putch('?', putdat);
  8008ee:	83 ec 08             	sub    $0x8,%esp
  8008f1:	ff 75 0c             	pushl  0xc(%ebp)
  8008f4:	6a 3f                	push   $0x3f
  8008f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f9:	ff d0                	call   *%eax
  8008fb:	83 c4 10             	add    $0x10,%esp
  8008fe:	eb 0f                	jmp    80090f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800900:	83 ec 08             	sub    $0x8,%esp
  800903:	ff 75 0c             	pushl  0xc(%ebp)
  800906:	53                   	push   %ebx
  800907:	8b 45 08             	mov    0x8(%ebp),%eax
  80090a:	ff d0                	call   *%eax
  80090c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80090f:	ff 4d e4             	decl   -0x1c(%ebp)
  800912:	89 f0                	mov    %esi,%eax
  800914:	8d 70 01             	lea    0x1(%eax),%esi
  800917:	8a 00                	mov    (%eax),%al
  800919:	0f be d8             	movsbl %al,%ebx
  80091c:	85 db                	test   %ebx,%ebx
  80091e:	74 24                	je     800944 <vprintfmt+0x24b>
  800920:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800924:	78 b8                	js     8008de <vprintfmt+0x1e5>
  800926:	ff 4d e0             	decl   -0x20(%ebp)
  800929:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80092d:	79 af                	jns    8008de <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80092f:	eb 13                	jmp    800944 <vprintfmt+0x24b>
				putch(' ', putdat);
  800931:	83 ec 08             	sub    $0x8,%esp
  800934:	ff 75 0c             	pushl  0xc(%ebp)
  800937:	6a 20                	push   $0x20
  800939:	8b 45 08             	mov    0x8(%ebp),%eax
  80093c:	ff d0                	call   *%eax
  80093e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800941:	ff 4d e4             	decl   -0x1c(%ebp)
  800944:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800948:	7f e7                	jg     800931 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80094a:	e9 66 01 00 00       	jmp    800ab5 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80094f:	83 ec 08             	sub    $0x8,%esp
  800952:	ff 75 e8             	pushl  -0x18(%ebp)
  800955:	8d 45 14             	lea    0x14(%ebp),%eax
  800958:	50                   	push   %eax
  800959:	e8 3c fd ff ff       	call   80069a <getint>
  80095e:	83 c4 10             	add    $0x10,%esp
  800961:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800964:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800967:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80096a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80096d:	85 d2                	test   %edx,%edx
  80096f:	79 23                	jns    800994 <vprintfmt+0x29b>
				putch('-', putdat);
  800971:	83 ec 08             	sub    $0x8,%esp
  800974:	ff 75 0c             	pushl  0xc(%ebp)
  800977:	6a 2d                	push   $0x2d
  800979:	8b 45 08             	mov    0x8(%ebp),%eax
  80097c:	ff d0                	call   *%eax
  80097e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800981:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800984:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800987:	f7 d8                	neg    %eax
  800989:	83 d2 00             	adc    $0x0,%edx
  80098c:	f7 da                	neg    %edx
  80098e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800991:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800994:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80099b:	e9 bc 00 00 00       	jmp    800a5c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009a0:	83 ec 08             	sub    $0x8,%esp
  8009a3:	ff 75 e8             	pushl  -0x18(%ebp)
  8009a6:	8d 45 14             	lea    0x14(%ebp),%eax
  8009a9:	50                   	push   %eax
  8009aa:	e8 84 fc ff ff       	call   800633 <getuint>
  8009af:	83 c4 10             	add    $0x10,%esp
  8009b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009b5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009b8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009bf:	e9 98 00 00 00       	jmp    800a5c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
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
			putch('X', putdat);
  8009e4:	83 ec 08             	sub    $0x8,%esp
  8009e7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ea:	6a 58                	push   $0x58
  8009ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ef:	ff d0                	call   *%eax
  8009f1:	83 c4 10             	add    $0x10,%esp
			break;
  8009f4:	e9 bc 00 00 00       	jmp    800ab5 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8009f9:	83 ec 08             	sub    $0x8,%esp
  8009fc:	ff 75 0c             	pushl  0xc(%ebp)
  8009ff:	6a 30                	push   $0x30
  800a01:	8b 45 08             	mov    0x8(%ebp),%eax
  800a04:	ff d0                	call   *%eax
  800a06:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a09:	83 ec 08             	sub    $0x8,%esp
  800a0c:	ff 75 0c             	pushl  0xc(%ebp)
  800a0f:	6a 78                	push   $0x78
  800a11:	8b 45 08             	mov    0x8(%ebp),%eax
  800a14:	ff d0                	call   *%eax
  800a16:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a19:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1c:	83 c0 04             	add    $0x4,%eax
  800a1f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a22:	8b 45 14             	mov    0x14(%ebp),%eax
  800a25:	83 e8 04             	sub    $0x4,%eax
  800a28:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a2d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a34:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a3b:	eb 1f                	jmp    800a5c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a3d:	83 ec 08             	sub    $0x8,%esp
  800a40:	ff 75 e8             	pushl  -0x18(%ebp)
  800a43:	8d 45 14             	lea    0x14(%ebp),%eax
  800a46:	50                   	push   %eax
  800a47:	e8 e7 fb ff ff       	call   800633 <getuint>
  800a4c:	83 c4 10             	add    $0x10,%esp
  800a4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a52:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a55:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a5c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a63:	83 ec 04             	sub    $0x4,%esp
  800a66:	52                   	push   %edx
  800a67:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a6a:	50                   	push   %eax
  800a6b:	ff 75 f4             	pushl  -0xc(%ebp)
  800a6e:	ff 75 f0             	pushl  -0x10(%ebp)
  800a71:	ff 75 0c             	pushl  0xc(%ebp)
  800a74:	ff 75 08             	pushl  0x8(%ebp)
  800a77:	e8 00 fb ff ff       	call   80057c <printnum>
  800a7c:	83 c4 20             	add    $0x20,%esp
			break;
  800a7f:	eb 34                	jmp    800ab5 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a81:	83 ec 08             	sub    $0x8,%esp
  800a84:	ff 75 0c             	pushl  0xc(%ebp)
  800a87:	53                   	push   %ebx
  800a88:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8b:	ff d0                	call   *%eax
  800a8d:	83 c4 10             	add    $0x10,%esp
			break;
  800a90:	eb 23                	jmp    800ab5 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a92:	83 ec 08             	sub    $0x8,%esp
  800a95:	ff 75 0c             	pushl  0xc(%ebp)
  800a98:	6a 25                	push   $0x25
  800a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9d:	ff d0                	call   *%eax
  800a9f:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aa2:	ff 4d 10             	decl   0x10(%ebp)
  800aa5:	eb 03                	jmp    800aaa <vprintfmt+0x3b1>
  800aa7:	ff 4d 10             	decl   0x10(%ebp)
  800aaa:	8b 45 10             	mov    0x10(%ebp),%eax
  800aad:	48                   	dec    %eax
  800aae:	8a 00                	mov    (%eax),%al
  800ab0:	3c 25                	cmp    $0x25,%al
  800ab2:	75 f3                	jne    800aa7 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800ab4:	90                   	nop
		}
	}
  800ab5:	e9 47 fc ff ff       	jmp    800701 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800aba:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800abb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800abe:	5b                   	pop    %ebx
  800abf:	5e                   	pop    %esi
  800ac0:	5d                   	pop    %ebp
  800ac1:	c3                   	ret    

00800ac2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ac2:	55                   	push   %ebp
  800ac3:	89 e5                	mov    %esp,%ebp
  800ac5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ac8:	8d 45 10             	lea    0x10(%ebp),%eax
  800acb:	83 c0 04             	add    $0x4,%eax
  800ace:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ad1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad4:	ff 75 f4             	pushl  -0xc(%ebp)
  800ad7:	50                   	push   %eax
  800ad8:	ff 75 0c             	pushl  0xc(%ebp)
  800adb:	ff 75 08             	pushl  0x8(%ebp)
  800ade:	e8 16 fc ff ff       	call   8006f9 <vprintfmt>
  800ae3:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ae6:	90                   	nop
  800ae7:	c9                   	leave  
  800ae8:	c3                   	ret    

00800ae9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ae9:	55                   	push   %ebp
  800aea:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800aec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aef:	8b 40 08             	mov    0x8(%eax),%eax
  800af2:	8d 50 01             	lea    0x1(%eax),%edx
  800af5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af8:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800afb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afe:	8b 10                	mov    (%eax),%edx
  800b00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b03:	8b 40 04             	mov    0x4(%eax),%eax
  800b06:	39 c2                	cmp    %eax,%edx
  800b08:	73 12                	jae    800b1c <sprintputch+0x33>
		*b->buf++ = ch;
  800b0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0d:	8b 00                	mov    (%eax),%eax
  800b0f:	8d 48 01             	lea    0x1(%eax),%ecx
  800b12:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b15:	89 0a                	mov    %ecx,(%edx)
  800b17:	8b 55 08             	mov    0x8(%ebp),%edx
  800b1a:	88 10                	mov    %dl,(%eax)
}
  800b1c:	90                   	nop
  800b1d:	5d                   	pop    %ebp
  800b1e:	c3                   	ret    

00800b1f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b1f:	55                   	push   %ebp
  800b20:	89 e5                	mov    %esp,%ebp
  800b22:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b25:	8b 45 08             	mov    0x8(%ebp),%eax
  800b28:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	01 d0                	add    %edx,%eax
  800b36:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b39:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b40:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b44:	74 06                	je     800b4c <vsnprintf+0x2d>
  800b46:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b4a:	7f 07                	jg     800b53 <vsnprintf+0x34>
		return -E_INVAL;
  800b4c:	b8 03 00 00 00       	mov    $0x3,%eax
  800b51:	eb 20                	jmp    800b73 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b53:	ff 75 14             	pushl  0x14(%ebp)
  800b56:	ff 75 10             	pushl  0x10(%ebp)
  800b59:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b5c:	50                   	push   %eax
  800b5d:	68 e9 0a 80 00       	push   $0x800ae9
  800b62:	e8 92 fb ff ff       	call   8006f9 <vprintfmt>
  800b67:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b6d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b73:	c9                   	leave  
  800b74:	c3                   	ret    

00800b75 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b75:	55                   	push   %ebp
  800b76:	89 e5                	mov    %esp,%ebp
  800b78:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b7b:	8d 45 10             	lea    0x10(%ebp),%eax
  800b7e:	83 c0 04             	add    $0x4,%eax
  800b81:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b84:	8b 45 10             	mov    0x10(%ebp),%eax
  800b87:	ff 75 f4             	pushl  -0xc(%ebp)
  800b8a:	50                   	push   %eax
  800b8b:	ff 75 0c             	pushl  0xc(%ebp)
  800b8e:	ff 75 08             	pushl  0x8(%ebp)
  800b91:	e8 89 ff ff ff       	call   800b1f <vsnprintf>
  800b96:	83 c4 10             	add    $0x10,%esp
  800b99:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800b9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b9f:	c9                   	leave  
  800ba0:	c3                   	ret    

00800ba1 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ba1:	55                   	push   %ebp
  800ba2:	89 e5                	mov    %esp,%ebp
  800ba4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ba7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bae:	eb 06                	jmp    800bb6 <strlen+0x15>
		n++;
  800bb0:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bb3:	ff 45 08             	incl   0x8(%ebp)
  800bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb9:	8a 00                	mov    (%eax),%al
  800bbb:	84 c0                	test   %al,%al
  800bbd:	75 f1                	jne    800bb0 <strlen+0xf>
		n++;
	return n;
  800bbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bc2:	c9                   	leave  
  800bc3:	c3                   	ret    

00800bc4 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bc4:	55                   	push   %ebp
  800bc5:	89 e5                	mov    %esp,%ebp
  800bc7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bd1:	eb 09                	jmp    800bdc <strnlen+0x18>
		n++;
  800bd3:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bd6:	ff 45 08             	incl   0x8(%ebp)
  800bd9:	ff 4d 0c             	decl   0xc(%ebp)
  800bdc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800be0:	74 09                	je     800beb <strnlen+0x27>
  800be2:	8b 45 08             	mov    0x8(%ebp),%eax
  800be5:	8a 00                	mov    (%eax),%al
  800be7:	84 c0                	test   %al,%al
  800be9:	75 e8                	jne    800bd3 <strnlen+0xf>
		n++;
	return n;
  800beb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bee:	c9                   	leave  
  800bef:	c3                   	ret    

00800bf0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bf0:	55                   	push   %ebp
  800bf1:	89 e5                	mov    %esp,%ebp
  800bf3:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800bfc:	90                   	nop
  800bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800c00:	8d 50 01             	lea    0x1(%eax),%edx
  800c03:	89 55 08             	mov    %edx,0x8(%ebp)
  800c06:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c09:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c0c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c0f:	8a 12                	mov    (%edx),%dl
  800c11:	88 10                	mov    %dl,(%eax)
  800c13:	8a 00                	mov    (%eax),%al
  800c15:	84 c0                	test   %al,%al
  800c17:	75 e4                	jne    800bfd <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c19:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c1c:	c9                   	leave  
  800c1d:	c3                   	ret    

00800c1e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c1e:	55                   	push   %ebp
  800c1f:	89 e5                	mov    %esp,%ebp
  800c21:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c24:	8b 45 08             	mov    0x8(%ebp),%eax
  800c27:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c2a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c31:	eb 1f                	jmp    800c52 <strncpy+0x34>
		*dst++ = *src;
  800c33:	8b 45 08             	mov    0x8(%ebp),%eax
  800c36:	8d 50 01             	lea    0x1(%eax),%edx
  800c39:	89 55 08             	mov    %edx,0x8(%ebp)
  800c3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c3f:	8a 12                	mov    (%edx),%dl
  800c41:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c46:	8a 00                	mov    (%eax),%al
  800c48:	84 c0                	test   %al,%al
  800c4a:	74 03                	je     800c4f <strncpy+0x31>
			src++;
  800c4c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c4f:	ff 45 fc             	incl   -0x4(%ebp)
  800c52:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c55:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c58:	72 d9                	jb     800c33 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c5d:	c9                   	leave  
  800c5e:	c3                   	ret    

00800c5f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c5f:	55                   	push   %ebp
  800c60:	89 e5                	mov    %esp,%ebp
  800c62:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c65:	8b 45 08             	mov    0x8(%ebp),%eax
  800c68:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c6b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c6f:	74 30                	je     800ca1 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c71:	eb 16                	jmp    800c89 <strlcpy+0x2a>
			*dst++ = *src++;
  800c73:	8b 45 08             	mov    0x8(%ebp),%eax
  800c76:	8d 50 01             	lea    0x1(%eax),%edx
  800c79:	89 55 08             	mov    %edx,0x8(%ebp)
  800c7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c7f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c82:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c85:	8a 12                	mov    (%edx),%dl
  800c87:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c89:	ff 4d 10             	decl   0x10(%ebp)
  800c8c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c90:	74 09                	je     800c9b <strlcpy+0x3c>
  800c92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c95:	8a 00                	mov    (%eax),%al
  800c97:	84 c0                	test   %al,%al
  800c99:	75 d8                	jne    800c73 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ca1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ca7:	29 c2                	sub    %eax,%edx
  800ca9:	89 d0                	mov    %edx,%eax
}
  800cab:	c9                   	leave  
  800cac:	c3                   	ret    

00800cad <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cad:	55                   	push   %ebp
  800cae:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cb0:	eb 06                	jmp    800cb8 <strcmp+0xb>
		p++, q++;
  800cb2:	ff 45 08             	incl   0x8(%ebp)
  800cb5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbb:	8a 00                	mov    (%eax),%al
  800cbd:	84 c0                	test   %al,%al
  800cbf:	74 0e                	je     800ccf <strcmp+0x22>
  800cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc4:	8a 10                	mov    (%eax),%dl
  800cc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc9:	8a 00                	mov    (%eax),%al
  800ccb:	38 c2                	cmp    %al,%dl
  800ccd:	74 e3                	je     800cb2 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	8a 00                	mov    (%eax),%al
  800cd4:	0f b6 d0             	movzbl %al,%edx
  800cd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cda:	8a 00                	mov    (%eax),%al
  800cdc:	0f b6 c0             	movzbl %al,%eax
  800cdf:	29 c2                	sub    %eax,%edx
  800ce1:	89 d0                	mov    %edx,%eax
}
  800ce3:	5d                   	pop    %ebp
  800ce4:	c3                   	ret    

00800ce5 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ce5:	55                   	push   %ebp
  800ce6:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800ce8:	eb 09                	jmp    800cf3 <strncmp+0xe>
		n--, p++, q++;
  800cea:	ff 4d 10             	decl   0x10(%ebp)
  800ced:	ff 45 08             	incl   0x8(%ebp)
  800cf0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cf3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf7:	74 17                	je     800d10 <strncmp+0x2b>
  800cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfc:	8a 00                	mov    (%eax),%al
  800cfe:	84 c0                	test   %al,%al
  800d00:	74 0e                	je     800d10 <strncmp+0x2b>
  800d02:	8b 45 08             	mov    0x8(%ebp),%eax
  800d05:	8a 10                	mov    (%eax),%dl
  800d07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0a:	8a 00                	mov    (%eax),%al
  800d0c:	38 c2                	cmp    %al,%dl
  800d0e:	74 da                	je     800cea <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d10:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d14:	75 07                	jne    800d1d <strncmp+0x38>
		return 0;
  800d16:	b8 00 00 00 00       	mov    $0x0,%eax
  800d1b:	eb 14                	jmp    800d31 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d20:	8a 00                	mov    (%eax),%al
  800d22:	0f b6 d0             	movzbl %al,%edx
  800d25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d28:	8a 00                	mov    (%eax),%al
  800d2a:	0f b6 c0             	movzbl %al,%eax
  800d2d:	29 c2                	sub    %eax,%edx
  800d2f:	89 d0                	mov    %edx,%eax
}
  800d31:	5d                   	pop    %ebp
  800d32:	c3                   	ret    

00800d33 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d33:	55                   	push   %ebp
  800d34:	89 e5                	mov    %esp,%ebp
  800d36:	83 ec 04             	sub    $0x4,%esp
  800d39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d3f:	eb 12                	jmp    800d53 <strchr+0x20>
		if (*s == c)
  800d41:	8b 45 08             	mov    0x8(%ebp),%eax
  800d44:	8a 00                	mov    (%eax),%al
  800d46:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d49:	75 05                	jne    800d50 <strchr+0x1d>
			return (char *) s;
  800d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4e:	eb 11                	jmp    800d61 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d50:	ff 45 08             	incl   0x8(%ebp)
  800d53:	8b 45 08             	mov    0x8(%ebp),%eax
  800d56:	8a 00                	mov    (%eax),%al
  800d58:	84 c0                	test   %al,%al
  800d5a:	75 e5                	jne    800d41 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d61:	c9                   	leave  
  800d62:	c3                   	ret    

00800d63 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d63:	55                   	push   %ebp
  800d64:	89 e5                	mov    %esp,%ebp
  800d66:	83 ec 04             	sub    $0x4,%esp
  800d69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d6f:	eb 0d                	jmp    800d7e <strfind+0x1b>
		if (*s == c)
  800d71:	8b 45 08             	mov    0x8(%ebp),%eax
  800d74:	8a 00                	mov    (%eax),%al
  800d76:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d79:	74 0e                	je     800d89 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d7b:	ff 45 08             	incl   0x8(%ebp)
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	8a 00                	mov    (%eax),%al
  800d83:	84 c0                	test   %al,%al
  800d85:	75 ea                	jne    800d71 <strfind+0xe>
  800d87:	eb 01                	jmp    800d8a <strfind+0x27>
		if (*s == c)
			break;
  800d89:	90                   	nop
	return (char *) s;
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d8d:	c9                   	leave  
  800d8e:	c3                   	ret    

00800d8f <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d8f:	55                   	push   %ebp
  800d90:	89 e5                	mov    %esp,%ebp
  800d92:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
  800d98:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d9e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800da1:	eb 0e                	jmp    800db1 <memset+0x22>
		*p++ = c;
  800da3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800da6:	8d 50 01             	lea    0x1(%eax),%edx
  800da9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dac:	8b 55 0c             	mov    0xc(%ebp),%edx
  800daf:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800db1:	ff 4d f8             	decl   -0x8(%ebp)
  800db4:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800db8:	79 e9                	jns    800da3 <memset+0x14>
		*p++ = c;

	return v;
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dbd:	c9                   	leave  
  800dbe:	c3                   	ret    

00800dbf <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dbf:	55                   	push   %ebp
  800dc0:	89 e5                	mov    %esp,%ebp
  800dc2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dce:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800dd1:	eb 16                	jmp    800de9 <memcpy+0x2a>
		*d++ = *s++;
  800dd3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dd6:	8d 50 01             	lea    0x1(%eax),%edx
  800dd9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ddc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ddf:	8d 4a 01             	lea    0x1(%edx),%ecx
  800de2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800de5:	8a 12                	mov    (%edx),%dl
  800de7:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800de9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dec:	8d 50 ff             	lea    -0x1(%eax),%edx
  800def:	89 55 10             	mov    %edx,0x10(%ebp)
  800df2:	85 c0                	test   %eax,%eax
  800df4:	75 dd                	jne    800dd3 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800df6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800df9:	c9                   	leave  
  800dfa:	c3                   	ret    

00800dfb <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800dfb:	55                   	push   %ebp
  800dfc:	89 e5                	mov    %esp,%ebp
  800dfe:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e04:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e07:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e10:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e13:	73 50                	jae    800e65 <memmove+0x6a>
  800e15:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e18:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1b:	01 d0                	add    %edx,%eax
  800e1d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e20:	76 43                	jbe    800e65 <memmove+0x6a>
		s += n;
  800e22:	8b 45 10             	mov    0x10(%ebp),%eax
  800e25:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e28:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e2e:	eb 10                	jmp    800e40 <memmove+0x45>
			*--d = *--s;
  800e30:	ff 4d f8             	decl   -0x8(%ebp)
  800e33:	ff 4d fc             	decl   -0x4(%ebp)
  800e36:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e39:	8a 10                	mov    (%eax),%dl
  800e3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e3e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e40:	8b 45 10             	mov    0x10(%ebp),%eax
  800e43:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e46:	89 55 10             	mov    %edx,0x10(%ebp)
  800e49:	85 c0                	test   %eax,%eax
  800e4b:	75 e3                	jne    800e30 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e4d:	eb 23                	jmp    800e72 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e52:	8d 50 01             	lea    0x1(%eax),%edx
  800e55:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e58:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e5b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e5e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e61:	8a 12                	mov    (%edx),%dl
  800e63:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e65:	8b 45 10             	mov    0x10(%ebp),%eax
  800e68:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e6b:	89 55 10             	mov    %edx,0x10(%ebp)
  800e6e:	85 c0                	test   %eax,%eax
  800e70:	75 dd                	jne    800e4f <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e72:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e75:	c9                   	leave  
  800e76:	c3                   	ret    

00800e77 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e77:	55                   	push   %ebp
  800e78:	89 e5                	mov    %esp,%ebp
  800e7a:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e86:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e89:	eb 2a                	jmp    800eb5 <memcmp+0x3e>
		if (*s1 != *s2)
  800e8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e8e:	8a 10                	mov    (%eax),%dl
  800e90:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e93:	8a 00                	mov    (%eax),%al
  800e95:	38 c2                	cmp    %al,%dl
  800e97:	74 16                	je     800eaf <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e99:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e9c:	8a 00                	mov    (%eax),%al
  800e9e:	0f b6 d0             	movzbl %al,%edx
  800ea1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea4:	8a 00                	mov    (%eax),%al
  800ea6:	0f b6 c0             	movzbl %al,%eax
  800ea9:	29 c2                	sub    %eax,%edx
  800eab:	89 d0                	mov    %edx,%eax
  800ead:	eb 18                	jmp    800ec7 <memcmp+0x50>
		s1++, s2++;
  800eaf:	ff 45 fc             	incl   -0x4(%ebp)
  800eb2:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800eb5:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ebb:	89 55 10             	mov    %edx,0x10(%ebp)
  800ebe:	85 c0                	test   %eax,%eax
  800ec0:	75 c9                	jne    800e8b <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ec2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ec7:	c9                   	leave  
  800ec8:	c3                   	ret    

00800ec9 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ec9:	55                   	push   %ebp
  800eca:	89 e5                	mov    %esp,%ebp
  800ecc:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ecf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed5:	01 d0                	add    %edx,%eax
  800ed7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800eda:	eb 15                	jmp    800ef1 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	8a 00                	mov    (%eax),%al
  800ee1:	0f b6 d0             	movzbl %al,%edx
  800ee4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee7:	0f b6 c0             	movzbl %al,%eax
  800eea:	39 c2                	cmp    %eax,%edx
  800eec:	74 0d                	je     800efb <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800eee:	ff 45 08             	incl   0x8(%ebp)
  800ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ef7:	72 e3                	jb     800edc <memfind+0x13>
  800ef9:	eb 01                	jmp    800efc <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800efb:	90                   	nop
	return (void *) s;
  800efc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eff:	c9                   	leave  
  800f00:	c3                   	ret    

00800f01 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f01:	55                   	push   %ebp
  800f02:	89 e5                	mov    %esp,%ebp
  800f04:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f07:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f0e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f15:	eb 03                	jmp    800f1a <strtol+0x19>
		s++;
  800f17:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1d:	8a 00                	mov    (%eax),%al
  800f1f:	3c 20                	cmp    $0x20,%al
  800f21:	74 f4                	je     800f17 <strtol+0x16>
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	8a 00                	mov    (%eax),%al
  800f28:	3c 09                	cmp    $0x9,%al
  800f2a:	74 eb                	je     800f17 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	8a 00                	mov    (%eax),%al
  800f31:	3c 2b                	cmp    $0x2b,%al
  800f33:	75 05                	jne    800f3a <strtol+0x39>
		s++;
  800f35:	ff 45 08             	incl   0x8(%ebp)
  800f38:	eb 13                	jmp    800f4d <strtol+0x4c>
	else if (*s == '-')
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	8a 00                	mov    (%eax),%al
  800f3f:	3c 2d                	cmp    $0x2d,%al
  800f41:	75 0a                	jne    800f4d <strtol+0x4c>
		s++, neg = 1;
  800f43:	ff 45 08             	incl   0x8(%ebp)
  800f46:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f4d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f51:	74 06                	je     800f59 <strtol+0x58>
  800f53:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f57:	75 20                	jne    800f79 <strtol+0x78>
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5c:	8a 00                	mov    (%eax),%al
  800f5e:	3c 30                	cmp    $0x30,%al
  800f60:	75 17                	jne    800f79 <strtol+0x78>
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
  800f65:	40                   	inc    %eax
  800f66:	8a 00                	mov    (%eax),%al
  800f68:	3c 78                	cmp    $0x78,%al
  800f6a:	75 0d                	jne    800f79 <strtol+0x78>
		s += 2, base = 16;
  800f6c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f70:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f77:	eb 28                	jmp    800fa1 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f79:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7d:	75 15                	jne    800f94 <strtol+0x93>
  800f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f82:	8a 00                	mov    (%eax),%al
  800f84:	3c 30                	cmp    $0x30,%al
  800f86:	75 0c                	jne    800f94 <strtol+0x93>
		s++, base = 8;
  800f88:	ff 45 08             	incl   0x8(%ebp)
  800f8b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f92:	eb 0d                	jmp    800fa1 <strtol+0xa0>
	else if (base == 0)
  800f94:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f98:	75 07                	jne    800fa1 <strtol+0xa0>
		base = 10;
  800f9a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa4:	8a 00                	mov    (%eax),%al
  800fa6:	3c 2f                	cmp    $0x2f,%al
  800fa8:	7e 19                	jle    800fc3 <strtol+0xc2>
  800faa:	8b 45 08             	mov    0x8(%ebp),%eax
  800fad:	8a 00                	mov    (%eax),%al
  800faf:	3c 39                	cmp    $0x39,%al
  800fb1:	7f 10                	jg     800fc3 <strtol+0xc2>
			dig = *s - '0';
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	8a 00                	mov    (%eax),%al
  800fb8:	0f be c0             	movsbl %al,%eax
  800fbb:	83 e8 30             	sub    $0x30,%eax
  800fbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fc1:	eb 42                	jmp    801005 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc6:	8a 00                	mov    (%eax),%al
  800fc8:	3c 60                	cmp    $0x60,%al
  800fca:	7e 19                	jle    800fe5 <strtol+0xe4>
  800fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcf:	8a 00                	mov    (%eax),%al
  800fd1:	3c 7a                	cmp    $0x7a,%al
  800fd3:	7f 10                	jg     800fe5 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd8:	8a 00                	mov    (%eax),%al
  800fda:	0f be c0             	movsbl %al,%eax
  800fdd:	83 e8 57             	sub    $0x57,%eax
  800fe0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fe3:	eb 20                	jmp    801005 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	8a 00                	mov    (%eax),%al
  800fea:	3c 40                	cmp    $0x40,%al
  800fec:	7e 39                	jle    801027 <strtol+0x126>
  800fee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff1:	8a 00                	mov    (%eax),%al
  800ff3:	3c 5a                	cmp    $0x5a,%al
  800ff5:	7f 30                	jg     801027 <strtol+0x126>
			dig = *s - 'A' + 10;
  800ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffa:	8a 00                	mov    (%eax),%al
  800ffc:	0f be c0             	movsbl %al,%eax
  800fff:	83 e8 37             	sub    $0x37,%eax
  801002:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801005:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801008:	3b 45 10             	cmp    0x10(%ebp),%eax
  80100b:	7d 19                	jge    801026 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80100d:	ff 45 08             	incl   0x8(%ebp)
  801010:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801013:	0f af 45 10          	imul   0x10(%ebp),%eax
  801017:	89 c2                	mov    %eax,%edx
  801019:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80101c:	01 d0                	add    %edx,%eax
  80101e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801021:	e9 7b ff ff ff       	jmp    800fa1 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801026:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801027:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80102b:	74 08                	je     801035 <strtol+0x134>
		*endptr = (char *) s;
  80102d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801030:	8b 55 08             	mov    0x8(%ebp),%edx
  801033:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801035:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801039:	74 07                	je     801042 <strtol+0x141>
  80103b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80103e:	f7 d8                	neg    %eax
  801040:	eb 03                	jmp    801045 <strtol+0x144>
  801042:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801045:	c9                   	leave  
  801046:	c3                   	ret    

00801047 <ltostr>:

void
ltostr(long value, char *str)
{
  801047:	55                   	push   %ebp
  801048:	89 e5                	mov    %esp,%ebp
  80104a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80104d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801054:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80105b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80105f:	79 13                	jns    801074 <ltostr+0x2d>
	{
		neg = 1;
  801061:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801068:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80106e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801071:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80107c:	99                   	cltd   
  80107d:	f7 f9                	idiv   %ecx
  80107f:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801082:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801085:	8d 50 01             	lea    0x1(%eax),%edx
  801088:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80108b:	89 c2                	mov    %eax,%edx
  80108d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801090:	01 d0                	add    %edx,%eax
  801092:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801095:	83 c2 30             	add    $0x30,%edx
  801098:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80109a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80109d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010a2:	f7 e9                	imul   %ecx
  8010a4:	c1 fa 02             	sar    $0x2,%edx
  8010a7:	89 c8                	mov    %ecx,%eax
  8010a9:	c1 f8 1f             	sar    $0x1f,%eax
  8010ac:	29 c2                	sub    %eax,%edx
  8010ae:	89 d0                	mov    %edx,%eax
  8010b0:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010b6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010bb:	f7 e9                	imul   %ecx
  8010bd:	c1 fa 02             	sar    $0x2,%edx
  8010c0:	89 c8                	mov    %ecx,%eax
  8010c2:	c1 f8 1f             	sar    $0x1f,%eax
  8010c5:	29 c2                	sub    %eax,%edx
  8010c7:	89 d0                	mov    %edx,%eax
  8010c9:	c1 e0 02             	shl    $0x2,%eax
  8010cc:	01 d0                	add    %edx,%eax
  8010ce:	01 c0                	add    %eax,%eax
  8010d0:	29 c1                	sub    %eax,%ecx
  8010d2:	89 ca                	mov    %ecx,%edx
  8010d4:	85 d2                	test   %edx,%edx
  8010d6:	75 9c                	jne    801074 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e2:	48                   	dec    %eax
  8010e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010ea:	74 3d                	je     801129 <ltostr+0xe2>
		start = 1 ;
  8010ec:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010f3:	eb 34                	jmp    801129 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8010f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fb:	01 d0                	add    %edx,%eax
  8010fd:	8a 00                	mov    (%eax),%al
  8010ff:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801102:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801105:	8b 45 0c             	mov    0xc(%ebp),%eax
  801108:	01 c2                	add    %eax,%edx
  80110a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80110d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801110:	01 c8                	add    %ecx,%eax
  801112:	8a 00                	mov    (%eax),%al
  801114:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801116:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801119:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111c:	01 c2                	add    %eax,%edx
  80111e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801121:	88 02                	mov    %al,(%edx)
		start++ ;
  801123:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801126:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801129:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80112c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80112f:	7c c4                	jl     8010f5 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801131:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801134:	8b 45 0c             	mov    0xc(%ebp),%eax
  801137:	01 d0                	add    %edx,%eax
  801139:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80113c:	90                   	nop
  80113d:	c9                   	leave  
  80113e:	c3                   	ret    

0080113f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80113f:	55                   	push   %ebp
  801140:	89 e5                	mov    %esp,%ebp
  801142:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801145:	ff 75 08             	pushl  0x8(%ebp)
  801148:	e8 54 fa ff ff       	call   800ba1 <strlen>
  80114d:	83 c4 04             	add    $0x4,%esp
  801150:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801153:	ff 75 0c             	pushl  0xc(%ebp)
  801156:	e8 46 fa ff ff       	call   800ba1 <strlen>
  80115b:	83 c4 04             	add    $0x4,%esp
  80115e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801161:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801168:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80116f:	eb 17                	jmp    801188 <strcconcat+0x49>
		final[s] = str1[s] ;
  801171:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801174:	8b 45 10             	mov    0x10(%ebp),%eax
  801177:	01 c2                	add    %eax,%edx
  801179:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80117c:	8b 45 08             	mov    0x8(%ebp),%eax
  80117f:	01 c8                	add    %ecx,%eax
  801181:	8a 00                	mov    (%eax),%al
  801183:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801185:	ff 45 fc             	incl   -0x4(%ebp)
  801188:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80118b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80118e:	7c e1                	jl     801171 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801190:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801197:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80119e:	eb 1f                	jmp    8011bf <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a3:	8d 50 01             	lea    0x1(%eax),%edx
  8011a6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011a9:	89 c2                	mov    %eax,%edx
  8011ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ae:	01 c2                	add    %eax,%edx
  8011b0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b6:	01 c8                	add    %ecx,%eax
  8011b8:	8a 00                	mov    (%eax),%al
  8011ba:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011bc:	ff 45 f8             	incl   -0x8(%ebp)
  8011bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011c5:	7c d9                	jl     8011a0 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011c7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8011cd:	01 d0                	add    %edx,%eax
  8011cf:	c6 00 00             	movb   $0x0,(%eax)
}
  8011d2:	90                   	nop
  8011d3:	c9                   	leave  
  8011d4:	c3                   	ret    

008011d5 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011d5:	55                   	push   %ebp
  8011d6:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8011db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e4:	8b 00                	mov    (%eax),%eax
  8011e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f0:	01 d0                	add    %edx,%eax
  8011f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011f8:	eb 0c                	jmp    801206 <strsplit+0x31>
			*string++ = 0;
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fd:	8d 50 01             	lea    0x1(%eax),%edx
  801200:	89 55 08             	mov    %edx,0x8(%ebp)
  801203:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	8a 00                	mov    (%eax),%al
  80120b:	84 c0                	test   %al,%al
  80120d:	74 18                	je     801227 <strsplit+0x52>
  80120f:	8b 45 08             	mov    0x8(%ebp),%eax
  801212:	8a 00                	mov    (%eax),%al
  801214:	0f be c0             	movsbl %al,%eax
  801217:	50                   	push   %eax
  801218:	ff 75 0c             	pushl  0xc(%ebp)
  80121b:	e8 13 fb ff ff       	call   800d33 <strchr>
  801220:	83 c4 08             	add    $0x8,%esp
  801223:	85 c0                	test   %eax,%eax
  801225:	75 d3                	jne    8011fa <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801227:	8b 45 08             	mov    0x8(%ebp),%eax
  80122a:	8a 00                	mov    (%eax),%al
  80122c:	84 c0                	test   %al,%al
  80122e:	74 5a                	je     80128a <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801230:	8b 45 14             	mov    0x14(%ebp),%eax
  801233:	8b 00                	mov    (%eax),%eax
  801235:	83 f8 0f             	cmp    $0xf,%eax
  801238:	75 07                	jne    801241 <strsplit+0x6c>
		{
			return 0;
  80123a:	b8 00 00 00 00       	mov    $0x0,%eax
  80123f:	eb 66                	jmp    8012a7 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801241:	8b 45 14             	mov    0x14(%ebp),%eax
  801244:	8b 00                	mov    (%eax),%eax
  801246:	8d 48 01             	lea    0x1(%eax),%ecx
  801249:	8b 55 14             	mov    0x14(%ebp),%edx
  80124c:	89 0a                	mov    %ecx,(%edx)
  80124e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801255:	8b 45 10             	mov    0x10(%ebp),%eax
  801258:	01 c2                	add    %eax,%edx
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
  80125d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80125f:	eb 03                	jmp    801264 <strsplit+0x8f>
			string++;
  801261:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801264:	8b 45 08             	mov    0x8(%ebp),%eax
  801267:	8a 00                	mov    (%eax),%al
  801269:	84 c0                	test   %al,%al
  80126b:	74 8b                	je     8011f8 <strsplit+0x23>
  80126d:	8b 45 08             	mov    0x8(%ebp),%eax
  801270:	8a 00                	mov    (%eax),%al
  801272:	0f be c0             	movsbl %al,%eax
  801275:	50                   	push   %eax
  801276:	ff 75 0c             	pushl  0xc(%ebp)
  801279:	e8 b5 fa ff ff       	call   800d33 <strchr>
  80127e:	83 c4 08             	add    $0x8,%esp
  801281:	85 c0                	test   %eax,%eax
  801283:	74 dc                	je     801261 <strsplit+0x8c>
			string++;
	}
  801285:	e9 6e ff ff ff       	jmp    8011f8 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80128a:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80128b:	8b 45 14             	mov    0x14(%ebp),%eax
  80128e:	8b 00                	mov    (%eax),%eax
  801290:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801297:	8b 45 10             	mov    0x10(%ebp),%eax
  80129a:	01 d0                	add    %edx,%eax
  80129c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012a2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012a7:	c9                   	leave  
  8012a8:	c3                   	ret    

008012a9 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8012a9:	55                   	push   %ebp
  8012aa:	89 e5                	mov    %esp,%ebp
  8012ac:	57                   	push   %edi
  8012ad:	56                   	push   %esi
  8012ae:	53                   	push   %ebx
  8012af:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012b8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012bb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012be:	8b 7d 18             	mov    0x18(%ebp),%edi
  8012c1:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8012c4:	cd 30                	int    $0x30
  8012c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8012c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012cc:	83 c4 10             	add    $0x10,%esp
  8012cf:	5b                   	pop    %ebx
  8012d0:	5e                   	pop    %esi
  8012d1:	5f                   	pop    %edi
  8012d2:	5d                   	pop    %ebp
  8012d3:	c3                   	ret    

008012d4 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8012d4:	55                   	push   %ebp
  8012d5:	89 e5                	mov    %esp,%ebp
  8012d7:	83 ec 04             	sub    $0x4,%esp
  8012da:	8b 45 10             	mov    0x10(%ebp),%eax
  8012dd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8012e0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e7:	6a 00                	push   $0x0
  8012e9:	6a 00                	push   $0x0
  8012eb:	52                   	push   %edx
  8012ec:	ff 75 0c             	pushl  0xc(%ebp)
  8012ef:	50                   	push   %eax
  8012f0:	6a 00                	push   $0x0
  8012f2:	e8 b2 ff ff ff       	call   8012a9 <syscall>
  8012f7:	83 c4 18             	add    $0x18,%esp
}
  8012fa:	90                   	nop
  8012fb:	c9                   	leave  
  8012fc:	c3                   	ret    

008012fd <sys_cgetc>:

int
sys_cgetc(void)
{
  8012fd:	55                   	push   %ebp
  8012fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801300:	6a 00                	push   $0x0
  801302:	6a 00                	push   $0x0
  801304:	6a 00                	push   $0x0
  801306:	6a 00                	push   $0x0
  801308:	6a 00                	push   $0x0
  80130a:	6a 01                	push   $0x1
  80130c:	e8 98 ff ff ff       	call   8012a9 <syscall>
  801311:	83 c4 18             	add    $0x18,%esp
}
  801314:	c9                   	leave  
  801315:	c3                   	ret    

00801316 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801316:	55                   	push   %ebp
  801317:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801319:	8b 55 0c             	mov    0xc(%ebp),%edx
  80131c:	8b 45 08             	mov    0x8(%ebp),%eax
  80131f:	6a 00                	push   $0x0
  801321:	6a 00                	push   $0x0
  801323:	6a 00                	push   $0x0
  801325:	52                   	push   %edx
  801326:	50                   	push   %eax
  801327:	6a 05                	push   $0x5
  801329:	e8 7b ff ff ff       	call   8012a9 <syscall>
  80132e:	83 c4 18             	add    $0x18,%esp
}
  801331:	c9                   	leave  
  801332:	c3                   	ret    

00801333 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801333:	55                   	push   %ebp
  801334:	89 e5                	mov    %esp,%ebp
  801336:	56                   	push   %esi
  801337:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801338:	8b 75 18             	mov    0x18(%ebp),%esi
  80133b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80133e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801341:	8b 55 0c             	mov    0xc(%ebp),%edx
  801344:	8b 45 08             	mov    0x8(%ebp),%eax
  801347:	56                   	push   %esi
  801348:	53                   	push   %ebx
  801349:	51                   	push   %ecx
  80134a:	52                   	push   %edx
  80134b:	50                   	push   %eax
  80134c:	6a 06                	push   $0x6
  80134e:	e8 56 ff ff ff       	call   8012a9 <syscall>
  801353:	83 c4 18             	add    $0x18,%esp
}
  801356:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801359:	5b                   	pop    %ebx
  80135a:	5e                   	pop    %esi
  80135b:	5d                   	pop    %ebp
  80135c:	c3                   	ret    

0080135d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80135d:	55                   	push   %ebp
  80135e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801360:	8b 55 0c             	mov    0xc(%ebp),%edx
  801363:	8b 45 08             	mov    0x8(%ebp),%eax
  801366:	6a 00                	push   $0x0
  801368:	6a 00                	push   $0x0
  80136a:	6a 00                	push   $0x0
  80136c:	52                   	push   %edx
  80136d:	50                   	push   %eax
  80136e:	6a 07                	push   $0x7
  801370:	e8 34 ff ff ff       	call   8012a9 <syscall>
  801375:	83 c4 18             	add    $0x18,%esp
}
  801378:	c9                   	leave  
  801379:	c3                   	ret    

0080137a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80137a:	55                   	push   %ebp
  80137b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80137d:	6a 00                	push   $0x0
  80137f:	6a 00                	push   $0x0
  801381:	6a 00                	push   $0x0
  801383:	ff 75 0c             	pushl  0xc(%ebp)
  801386:	ff 75 08             	pushl  0x8(%ebp)
  801389:	6a 08                	push   $0x8
  80138b:	e8 19 ff ff ff       	call   8012a9 <syscall>
  801390:	83 c4 18             	add    $0x18,%esp
}
  801393:	c9                   	leave  
  801394:	c3                   	ret    

00801395 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801395:	55                   	push   %ebp
  801396:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801398:	6a 00                	push   $0x0
  80139a:	6a 00                	push   $0x0
  80139c:	6a 00                	push   $0x0
  80139e:	6a 00                	push   $0x0
  8013a0:	6a 00                	push   $0x0
  8013a2:	6a 09                	push   $0x9
  8013a4:	e8 00 ff ff ff       	call   8012a9 <syscall>
  8013a9:	83 c4 18             	add    $0x18,%esp
}
  8013ac:	c9                   	leave  
  8013ad:	c3                   	ret    

008013ae <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8013ae:	55                   	push   %ebp
  8013af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8013b1:	6a 00                	push   $0x0
  8013b3:	6a 00                	push   $0x0
  8013b5:	6a 00                	push   $0x0
  8013b7:	6a 00                	push   $0x0
  8013b9:	6a 00                	push   $0x0
  8013bb:	6a 0a                	push   $0xa
  8013bd:	e8 e7 fe ff ff       	call   8012a9 <syscall>
  8013c2:	83 c4 18             	add    $0x18,%esp
}
  8013c5:	c9                   	leave  
  8013c6:	c3                   	ret    

008013c7 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8013c7:	55                   	push   %ebp
  8013c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8013ca:	6a 00                	push   $0x0
  8013cc:	6a 00                	push   $0x0
  8013ce:	6a 00                	push   $0x0
  8013d0:	6a 00                	push   $0x0
  8013d2:	6a 00                	push   $0x0
  8013d4:	6a 0b                	push   $0xb
  8013d6:	e8 ce fe ff ff       	call   8012a9 <syscall>
  8013db:	83 c4 18             	add    $0x18,%esp
}
  8013de:	c9                   	leave  
  8013df:	c3                   	ret    

008013e0 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8013e0:	55                   	push   %ebp
  8013e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8013e3:	6a 00                	push   $0x0
  8013e5:	6a 00                	push   $0x0
  8013e7:	6a 00                	push   $0x0
  8013e9:	ff 75 0c             	pushl  0xc(%ebp)
  8013ec:	ff 75 08             	pushl  0x8(%ebp)
  8013ef:	6a 0f                	push   $0xf
  8013f1:	e8 b3 fe ff ff       	call   8012a9 <syscall>
  8013f6:	83 c4 18             	add    $0x18,%esp
	return;
  8013f9:	90                   	nop
}
  8013fa:	c9                   	leave  
  8013fb:	c3                   	ret    

008013fc <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8013fc:	55                   	push   %ebp
  8013fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8013ff:	6a 00                	push   $0x0
  801401:	6a 00                	push   $0x0
  801403:	6a 00                	push   $0x0
  801405:	ff 75 0c             	pushl  0xc(%ebp)
  801408:	ff 75 08             	pushl  0x8(%ebp)
  80140b:	6a 10                	push   $0x10
  80140d:	e8 97 fe ff ff       	call   8012a9 <syscall>
  801412:	83 c4 18             	add    $0x18,%esp
	return ;
  801415:	90                   	nop
}
  801416:	c9                   	leave  
  801417:	c3                   	ret    

00801418 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801418:	55                   	push   %ebp
  801419:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80141b:	6a 00                	push   $0x0
  80141d:	6a 00                	push   $0x0
  80141f:	ff 75 10             	pushl  0x10(%ebp)
  801422:	ff 75 0c             	pushl  0xc(%ebp)
  801425:	ff 75 08             	pushl  0x8(%ebp)
  801428:	6a 11                	push   $0x11
  80142a:	e8 7a fe ff ff       	call   8012a9 <syscall>
  80142f:	83 c4 18             	add    $0x18,%esp
	return ;
  801432:	90                   	nop
}
  801433:	c9                   	leave  
  801434:	c3                   	ret    

00801435 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801435:	55                   	push   %ebp
  801436:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801438:	6a 00                	push   $0x0
  80143a:	6a 00                	push   $0x0
  80143c:	6a 00                	push   $0x0
  80143e:	6a 00                	push   $0x0
  801440:	6a 00                	push   $0x0
  801442:	6a 0c                	push   $0xc
  801444:	e8 60 fe ff ff       	call   8012a9 <syscall>
  801449:	83 c4 18             	add    $0x18,%esp
}
  80144c:	c9                   	leave  
  80144d:	c3                   	ret    

0080144e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80144e:	55                   	push   %ebp
  80144f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801451:	6a 00                	push   $0x0
  801453:	6a 00                	push   $0x0
  801455:	6a 00                	push   $0x0
  801457:	6a 00                	push   $0x0
  801459:	ff 75 08             	pushl  0x8(%ebp)
  80145c:	6a 0d                	push   $0xd
  80145e:	e8 46 fe ff ff       	call   8012a9 <syscall>
  801463:	83 c4 18             	add    $0x18,%esp
}
  801466:	c9                   	leave  
  801467:	c3                   	ret    

00801468 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801468:	55                   	push   %ebp
  801469:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80146b:	6a 00                	push   $0x0
  80146d:	6a 00                	push   $0x0
  80146f:	6a 00                	push   $0x0
  801471:	6a 00                	push   $0x0
  801473:	6a 00                	push   $0x0
  801475:	6a 0e                	push   $0xe
  801477:	e8 2d fe ff ff       	call   8012a9 <syscall>
  80147c:	83 c4 18             	add    $0x18,%esp
}
  80147f:	90                   	nop
  801480:	c9                   	leave  
  801481:	c3                   	ret    

00801482 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801482:	55                   	push   %ebp
  801483:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801485:	6a 00                	push   $0x0
  801487:	6a 00                	push   $0x0
  801489:	6a 00                	push   $0x0
  80148b:	6a 00                	push   $0x0
  80148d:	6a 00                	push   $0x0
  80148f:	6a 13                	push   $0x13
  801491:	e8 13 fe ff ff       	call   8012a9 <syscall>
  801496:	83 c4 18             	add    $0x18,%esp
}
  801499:	90                   	nop
  80149a:	c9                   	leave  
  80149b:	c3                   	ret    

0080149c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80149c:	55                   	push   %ebp
  80149d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80149f:	6a 00                	push   $0x0
  8014a1:	6a 00                	push   $0x0
  8014a3:	6a 00                	push   $0x0
  8014a5:	6a 00                	push   $0x0
  8014a7:	6a 00                	push   $0x0
  8014a9:	6a 14                	push   $0x14
  8014ab:	e8 f9 fd ff ff       	call   8012a9 <syscall>
  8014b0:	83 c4 18             	add    $0x18,%esp
}
  8014b3:	90                   	nop
  8014b4:	c9                   	leave  
  8014b5:	c3                   	ret    

008014b6 <sys_cputc>:


void
sys_cputc(const char c)
{
  8014b6:	55                   	push   %ebp
  8014b7:	89 e5                	mov    %esp,%ebp
  8014b9:	83 ec 04             	sub    $0x4,%esp
  8014bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8014c2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8014c6:	6a 00                	push   $0x0
  8014c8:	6a 00                	push   $0x0
  8014ca:	6a 00                	push   $0x0
  8014cc:	6a 00                	push   $0x0
  8014ce:	50                   	push   %eax
  8014cf:	6a 15                	push   $0x15
  8014d1:	e8 d3 fd ff ff       	call   8012a9 <syscall>
  8014d6:	83 c4 18             	add    $0x18,%esp
}
  8014d9:	90                   	nop
  8014da:	c9                   	leave  
  8014db:	c3                   	ret    

008014dc <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8014dc:	55                   	push   %ebp
  8014dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8014df:	6a 00                	push   $0x0
  8014e1:	6a 00                	push   $0x0
  8014e3:	6a 00                	push   $0x0
  8014e5:	6a 00                	push   $0x0
  8014e7:	6a 00                	push   $0x0
  8014e9:	6a 16                	push   $0x16
  8014eb:	e8 b9 fd ff ff       	call   8012a9 <syscall>
  8014f0:	83 c4 18             	add    $0x18,%esp
}
  8014f3:	90                   	nop
  8014f4:	c9                   	leave  
  8014f5:	c3                   	ret    

008014f6 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8014f6:	55                   	push   %ebp
  8014f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8014f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fc:	6a 00                	push   $0x0
  8014fe:	6a 00                	push   $0x0
  801500:	6a 00                	push   $0x0
  801502:	ff 75 0c             	pushl  0xc(%ebp)
  801505:	50                   	push   %eax
  801506:	6a 17                	push   $0x17
  801508:	e8 9c fd ff ff       	call   8012a9 <syscall>
  80150d:	83 c4 18             	add    $0x18,%esp
}
  801510:	c9                   	leave  
  801511:	c3                   	ret    

00801512 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801512:	55                   	push   %ebp
  801513:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801515:	8b 55 0c             	mov    0xc(%ebp),%edx
  801518:	8b 45 08             	mov    0x8(%ebp),%eax
  80151b:	6a 00                	push   $0x0
  80151d:	6a 00                	push   $0x0
  80151f:	6a 00                	push   $0x0
  801521:	52                   	push   %edx
  801522:	50                   	push   %eax
  801523:	6a 1a                	push   $0x1a
  801525:	e8 7f fd ff ff       	call   8012a9 <syscall>
  80152a:	83 c4 18             	add    $0x18,%esp
}
  80152d:	c9                   	leave  
  80152e:	c3                   	ret    

0080152f <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80152f:	55                   	push   %ebp
  801530:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801532:	8b 55 0c             	mov    0xc(%ebp),%edx
  801535:	8b 45 08             	mov    0x8(%ebp),%eax
  801538:	6a 00                	push   $0x0
  80153a:	6a 00                	push   $0x0
  80153c:	6a 00                	push   $0x0
  80153e:	52                   	push   %edx
  80153f:	50                   	push   %eax
  801540:	6a 18                	push   $0x18
  801542:	e8 62 fd ff ff       	call   8012a9 <syscall>
  801547:	83 c4 18             	add    $0x18,%esp
}
  80154a:	90                   	nop
  80154b:	c9                   	leave  
  80154c:	c3                   	ret    

0080154d <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80154d:	55                   	push   %ebp
  80154e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801550:	8b 55 0c             	mov    0xc(%ebp),%edx
  801553:	8b 45 08             	mov    0x8(%ebp),%eax
  801556:	6a 00                	push   $0x0
  801558:	6a 00                	push   $0x0
  80155a:	6a 00                	push   $0x0
  80155c:	52                   	push   %edx
  80155d:	50                   	push   %eax
  80155e:	6a 19                	push   $0x19
  801560:	e8 44 fd ff ff       	call   8012a9 <syscall>
  801565:	83 c4 18             	add    $0x18,%esp
}
  801568:	90                   	nop
  801569:	c9                   	leave  
  80156a:	c3                   	ret    

0080156b <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80156b:	55                   	push   %ebp
  80156c:	89 e5                	mov    %esp,%ebp
  80156e:	83 ec 04             	sub    $0x4,%esp
  801571:	8b 45 10             	mov    0x10(%ebp),%eax
  801574:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801577:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80157a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80157e:	8b 45 08             	mov    0x8(%ebp),%eax
  801581:	6a 00                	push   $0x0
  801583:	51                   	push   %ecx
  801584:	52                   	push   %edx
  801585:	ff 75 0c             	pushl  0xc(%ebp)
  801588:	50                   	push   %eax
  801589:	6a 1b                	push   $0x1b
  80158b:	e8 19 fd ff ff       	call   8012a9 <syscall>
  801590:	83 c4 18             	add    $0x18,%esp
}
  801593:	c9                   	leave  
  801594:	c3                   	ret    

00801595 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801595:	55                   	push   %ebp
  801596:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801598:	8b 55 0c             	mov    0xc(%ebp),%edx
  80159b:	8b 45 08             	mov    0x8(%ebp),%eax
  80159e:	6a 00                	push   $0x0
  8015a0:	6a 00                	push   $0x0
  8015a2:	6a 00                	push   $0x0
  8015a4:	52                   	push   %edx
  8015a5:	50                   	push   %eax
  8015a6:	6a 1c                	push   $0x1c
  8015a8:	e8 fc fc ff ff       	call   8012a9 <syscall>
  8015ad:	83 c4 18             	add    $0x18,%esp
}
  8015b0:	c9                   	leave  
  8015b1:	c3                   	ret    

008015b2 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8015b2:	55                   	push   %ebp
  8015b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8015b5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015be:	6a 00                	push   $0x0
  8015c0:	6a 00                	push   $0x0
  8015c2:	51                   	push   %ecx
  8015c3:	52                   	push   %edx
  8015c4:	50                   	push   %eax
  8015c5:	6a 1d                	push   $0x1d
  8015c7:	e8 dd fc ff ff       	call   8012a9 <syscall>
  8015cc:	83 c4 18             	add    $0x18,%esp
}
  8015cf:	c9                   	leave  
  8015d0:	c3                   	ret    

008015d1 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8015d1:	55                   	push   %ebp
  8015d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8015d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 00                	push   $0x0
  8015e0:	52                   	push   %edx
  8015e1:	50                   	push   %eax
  8015e2:	6a 1e                	push   $0x1e
  8015e4:	e8 c0 fc ff ff       	call   8012a9 <syscall>
  8015e9:	83 c4 18             	add    $0x18,%esp
}
  8015ec:	c9                   	leave  
  8015ed:	c3                   	ret    

008015ee <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8015ee:	55                   	push   %ebp
  8015ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8015f1:	6a 00                	push   $0x0
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 00                	push   $0x0
  8015fb:	6a 1f                	push   $0x1f
  8015fd:	e8 a7 fc ff ff       	call   8012a9 <syscall>
  801602:	83 c4 18             	add    $0x18,%esp
}
  801605:	c9                   	leave  
  801606:	c3                   	ret    

00801607 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801607:	55                   	push   %ebp
  801608:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80160a:	8b 45 08             	mov    0x8(%ebp),%eax
  80160d:	6a 00                	push   $0x0
  80160f:	ff 75 14             	pushl  0x14(%ebp)
  801612:	ff 75 10             	pushl  0x10(%ebp)
  801615:	ff 75 0c             	pushl  0xc(%ebp)
  801618:	50                   	push   %eax
  801619:	6a 20                	push   $0x20
  80161b:	e8 89 fc ff ff       	call   8012a9 <syscall>
  801620:	83 c4 18             	add    $0x18,%esp
}
  801623:	c9                   	leave  
  801624:	c3                   	ret    

00801625 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801625:	55                   	push   %ebp
  801626:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801628:	8b 45 08             	mov    0x8(%ebp),%eax
  80162b:	6a 00                	push   $0x0
  80162d:	6a 00                	push   $0x0
  80162f:	6a 00                	push   $0x0
  801631:	6a 00                	push   $0x0
  801633:	50                   	push   %eax
  801634:	6a 21                	push   $0x21
  801636:	e8 6e fc ff ff       	call   8012a9 <syscall>
  80163b:	83 c4 18             	add    $0x18,%esp
}
  80163e:	90                   	nop
  80163f:	c9                   	leave  
  801640:	c3                   	ret    

00801641 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801641:	55                   	push   %ebp
  801642:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801644:	8b 45 08             	mov    0x8(%ebp),%eax
  801647:	6a 00                	push   $0x0
  801649:	6a 00                	push   $0x0
  80164b:	6a 00                	push   $0x0
  80164d:	6a 00                	push   $0x0
  80164f:	50                   	push   %eax
  801650:	6a 22                	push   $0x22
  801652:	e8 52 fc ff ff       	call   8012a9 <syscall>
  801657:	83 c4 18             	add    $0x18,%esp
}
  80165a:	c9                   	leave  
  80165b:	c3                   	ret    

0080165c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80165c:	55                   	push   %ebp
  80165d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80165f:	6a 00                	push   $0x0
  801661:	6a 00                	push   $0x0
  801663:	6a 00                	push   $0x0
  801665:	6a 00                	push   $0x0
  801667:	6a 00                	push   $0x0
  801669:	6a 02                	push   $0x2
  80166b:	e8 39 fc ff ff       	call   8012a9 <syscall>
  801670:	83 c4 18             	add    $0x18,%esp
}
  801673:	c9                   	leave  
  801674:	c3                   	ret    

00801675 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801675:	55                   	push   %ebp
  801676:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801678:	6a 00                	push   $0x0
  80167a:	6a 00                	push   $0x0
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	6a 03                	push   $0x3
  801684:	e8 20 fc ff ff       	call   8012a9 <syscall>
  801689:	83 c4 18             	add    $0x18,%esp
}
  80168c:	c9                   	leave  
  80168d:	c3                   	ret    

0080168e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801691:	6a 00                	push   $0x0
  801693:	6a 00                	push   $0x0
  801695:	6a 00                	push   $0x0
  801697:	6a 00                	push   $0x0
  801699:	6a 00                	push   $0x0
  80169b:	6a 04                	push   $0x4
  80169d:	e8 07 fc ff ff       	call   8012a9 <syscall>
  8016a2:	83 c4 18             	add    $0x18,%esp
}
  8016a5:	c9                   	leave  
  8016a6:	c3                   	ret    

008016a7 <sys_exit_env>:


void sys_exit_env(void)
{
  8016a7:	55                   	push   %ebp
  8016a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 00                	push   $0x0
  8016b2:	6a 00                	push   $0x0
  8016b4:	6a 23                	push   $0x23
  8016b6:	e8 ee fb ff ff       	call   8012a9 <syscall>
  8016bb:	83 c4 18             	add    $0x18,%esp
}
  8016be:	90                   	nop
  8016bf:	c9                   	leave  
  8016c0:	c3                   	ret    

008016c1 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8016c1:	55                   	push   %ebp
  8016c2:	89 e5                	mov    %esp,%ebp
  8016c4:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8016c7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016ca:	8d 50 04             	lea    0x4(%eax),%edx
  8016cd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 00                	push   $0x0
  8016d4:	6a 00                	push   $0x0
  8016d6:	52                   	push   %edx
  8016d7:	50                   	push   %eax
  8016d8:	6a 24                	push   $0x24
  8016da:	e8 ca fb ff ff       	call   8012a9 <syscall>
  8016df:	83 c4 18             	add    $0x18,%esp
	return result;
  8016e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016eb:	89 01                	mov    %eax,(%ecx)
  8016ed:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8016f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f3:	c9                   	leave  
  8016f4:	c2 04 00             	ret    $0x4

008016f7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	ff 75 10             	pushl  0x10(%ebp)
  801701:	ff 75 0c             	pushl  0xc(%ebp)
  801704:	ff 75 08             	pushl  0x8(%ebp)
  801707:	6a 12                	push   $0x12
  801709:	e8 9b fb ff ff       	call   8012a9 <syscall>
  80170e:	83 c4 18             	add    $0x18,%esp
	return ;
  801711:	90                   	nop
}
  801712:	c9                   	leave  
  801713:	c3                   	ret    

00801714 <sys_rcr2>:
uint32 sys_rcr2()
{
  801714:	55                   	push   %ebp
  801715:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 25                	push   $0x25
  801723:	e8 81 fb ff ff       	call   8012a9 <syscall>
  801728:	83 c4 18             	add    $0x18,%esp
}
  80172b:	c9                   	leave  
  80172c:	c3                   	ret    

0080172d <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
  801730:	83 ec 04             	sub    $0x4,%esp
  801733:	8b 45 08             	mov    0x8(%ebp),%eax
  801736:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801739:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	50                   	push   %eax
  801746:	6a 26                	push   $0x26
  801748:	e8 5c fb ff ff       	call   8012a9 <syscall>
  80174d:	83 c4 18             	add    $0x18,%esp
	return ;
  801750:	90                   	nop
}
  801751:	c9                   	leave  
  801752:	c3                   	ret    

00801753 <rsttst>:
void rsttst()
{
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 28                	push   $0x28
  801762:	e8 42 fb ff ff       	call   8012a9 <syscall>
  801767:	83 c4 18             	add    $0x18,%esp
	return ;
  80176a:	90                   	nop
}
  80176b:	c9                   	leave  
  80176c:	c3                   	ret    

0080176d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80176d:	55                   	push   %ebp
  80176e:	89 e5                	mov    %esp,%ebp
  801770:	83 ec 04             	sub    $0x4,%esp
  801773:	8b 45 14             	mov    0x14(%ebp),%eax
  801776:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801779:	8b 55 18             	mov    0x18(%ebp),%edx
  80177c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801780:	52                   	push   %edx
  801781:	50                   	push   %eax
  801782:	ff 75 10             	pushl  0x10(%ebp)
  801785:	ff 75 0c             	pushl  0xc(%ebp)
  801788:	ff 75 08             	pushl  0x8(%ebp)
  80178b:	6a 27                	push   $0x27
  80178d:	e8 17 fb ff ff       	call   8012a9 <syscall>
  801792:	83 c4 18             	add    $0x18,%esp
	return ;
  801795:	90                   	nop
}
  801796:	c9                   	leave  
  801797:	c3                   	ret    

00801798 <chktst>:
void chktst(uint32 n)
{
  801798:	55                   	push   %ebp
  801799:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	ff 75 08             	pushl  0x8(%ebp)
  8017a6:	6a 29                	push   $0x29
  8017a8:	e8 fc fa ff ff       	call   8012a9 <syscall>
  8017ad:	83 c4 18             	add    $0x18,%esp
	return ;
  8017b0:	90                   	nop
}
  8017b1:	c9                   	leave  
  8017b2:	c3                   	ret    

008017b3 <inctst>:

void inctst()
{
  8017b3:	55                   	push   %ebp
  8017b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 2a                	push   $0x2a
  8017c2:	e8 e2 fa ff ff       	call   8012a9 <syscall>
  8017c7:	83 c4 18             	add    $0x18,%esp
	return ;
  8017ca:	90                   	nop
}
  8017cb:	c9                   	leave  
  8017cc:	c3                   	ret    

008017cd <gettst>:
uint32 gettst()
{
  8017cd:	55                   	push   %ebp
  8017ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 2b                	push   $0x2b
  8017dc:	e8 c8 fa ff ff       	call   8012a9 <syscall>
  8017e1:	83 c4 18             	add    $0x18,%esp
}
  8017e4:	c9                   	leave  
  8017e5:	c3                   	ret    

008017e6 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
  8017e9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 2c                	push   $0x2c
  8017f8:	e8 ac fa ff ff       	call   8012a9 <syscall>
  8017fd:	83 c4 18             	add    $0x18,%esp
  801800:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801803:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801807:	75 07                	jne    801810 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801809:	b8 01 00 00 00       	mov    $0x1,%eax
  80180e:	eb 05                	jmp    801815 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801810:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801815:	c9                   	leave  
  801816:	c3                   	ret    

00801817 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
  80181a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80181d:	6a 00                	push   $0x0
  80181f:	6a 00                	push   $0x0
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	6a 2c                	push   $0x2c
  801829:	e8 7b fa ff ff       	call   8012a9 <syscall>
  80182e:	83 c4 18             	add    $0x18,%esp
  801831:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801834:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801838:	75 07                	jne    801841 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80183a:	b8 01 00 00 00       	mov    $0x1,%eax
  80183f:	eb 05                	jmp    801846 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801841:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801846:	c9                   	leave  
  801847:	c3                   	ret    

00801848 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
  80184b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	6a 2c                	push   $0x2c
  80185a:	e8 4a fa ff ff       	call   8012a9 <syscall>
  80185f:	83 c4 18             	add    $0x18,%esp
  801862:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801865:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801869:	75 07                	jne    801872 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80186b:	b8 01 00 00 00       	mov    $0x1,%eax
  801870:	eb 05                	jmp    801877 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801872:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801877:	c9                   	leave  
  801878:	c3                   	ret    

00801879 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
  80187c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 2c                	push   $0x2c
  80188b:	e8 19 fa ff ff       	call   8012a9 <syscall>
  801890:	83 c4 18             	add    $0x18,%esp
  801893:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801896:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80189a:	75 07                	jne    8018a3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80189c:	b8 01 00 00 00       	mov    $0x1,%eax
  8018a1:	eb 05                	jmp    8018a8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8018a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018a8:	c9                   	leave  
  8018a9:	c3                   	ret    

008018aa <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	ff 75 08             	pushl  0x8(%ebp)
  8018b8:	6a 2d                	push   $0x2d
  8018ba:	e8 ea f9 ff ff       	call   8012a9 <syscall>
  8018bf:	83 c4 18             	add    $0x18,%esp
	return ;
  8018c2:	90                   	nop
}
  8018c3:	c9                   	leave  
  8018c4:	c3                   	ret    

008018c5 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8018c5:	55                   	push   %ebp
  8018c6:	89 e5                	mov    %esp,%ebp
  8018c8:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8018c9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018cc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d5:	6a 00                	push   $0x0
  8018d7:	53                   	push   %ebx
  8018d8:	51                   	push   %ecx
  8018d9:	52                   	push   %edx
  8018da:	50                   	push   %eax
  8018db:	6a 2e                	push   $0x2e
  8018dd:	e8 c7 f9 ff ff       	call   8012a9 <syscall>
  8018e2:	83 c4 18             	add    $0x18,%esp
}
  8018e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018e8:	c9                   	leave  
  8018e9:	c3                   	ret    

008018ea <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8018ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	52                   	push   %edx
  8018fa:	50                   	push   %eax
  8018fb:	6a 2f                	push   $0x2f
  8018fd:	e8 a7 f9 ff ff       	call   8012a9 <syscall>
  801902:	83 c4 18             	add    $0x18,%esp
}
  801905:	c9                   	leave  
  801906:	c3                   	ret    
  801907:	90                   	nop

00801908 <__udivdi3>:
  801908:	55                   	push   %ebp
  801909:	57                   	push   %edi
  80190a:	56                   	push   %esi
  80190b:	53                   	push   %ebx
  80190c:	83 ec 1c             	sub    $0x1c,%esp
  80190f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801913:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801917:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80191b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80191f:	89 ca                	mov    %ecx,%edx
  801921:	89 f8                	mov    %edi,%eax
  801923:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801927:	85 f6                	test   %esi,%esi
  801929:	75 2d                	jne    801958 <__udivdi3+0x50>
  80192b:	39 cf                	cmp    %ecx,%edi
  80192d:	77 65                	ja     801994 <__udivdi3+0x8c>
  80192f:	89 fd                	mov    %edi,%ebp
  801931:	85 ff                	test   %edi,%edi
  801933:	75 0b                	jne    801940 <__udivdi3+0x38>
  801935:	b8 01 00 00 00       	mov    $0x1,%eax
  80193a:	31 d2                	xor    %edx,%edx
  80193c:	f7 f7                	div    %edi
  80193e:	89 c5                	mov    %eax,%ebp
  801940:	31 d2                	xor    %edx,%edx
  801942:	89 c8                	mov    %ecx,%eax
  801944:	f7 f5                	div    %ebp
  801946:	89 c1                	mov    %eax,%ecx
  801948:	89 d8                	mov    %ebx,%eax
  80194a:	f7 f5                	div    %ebp
  80194c:	89 cf                	mov    %ecx,%edi
  80194e:	89 fa                	mov    %edi,%edx
  801950:	83 c4 1c             	add    $0x1c,%esp
  801953:	5b                   	pop    %ebx
  801954:	5e                   	pop    %esi
  801955:	5f                   	pop    %edi
  801956:	5d                   	pop    %ebp
  801957:	c3                   	ret    
  801958:	39 ce                	cmp    %ecx,%esi
  80195a:	77 28                	ja     801984 <__udivdi3+0x7c>
  80195c:	0f bd fe             	bsr    %esi,%edi
  80195f:	83 f7 1f             	xor    $0x1f,%edi
  801962:	75 40                	jne    8019a4 <__udivdi3+0x9c>
  801964:	39 ce                	cmp    %ecx,%esi
  801966:	72 0a                	jb     801972 <__udivdi3+0x6a>
  801968:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80196c:	0f 87 9e 00 00 00    	ja     801a10 <__udivdi3+0x108>
  801972:	b8 01 00 00 00       	mov    $0x1,%eax
  801977:	89 fa                	mov    %edi,%edx
  801979:	83 c4 1c             	add    $0x1c,%esp
  80197c:	5b                   	pop    %ebx
  80197d:	5e                   	pop    %esi
  80197e:	5f                   	pop    %edi
  80197f:	5d                   	pop    %ebp
  801980:	c3                   	ret    
  801981:	8d 76 00             	lea    0x0(%esi),%esi
  801984:	31 ff                	xor    %edi,%edi
  801986:	31 c0                	xor    %eax,%eax
  801988:	89 fa                	mov    %edi,%edx
  80198a:	83 c4 1c             	add    $0x1c,%esp
  80198d:	5b                   	pop    %ebx
  80198e:	5e                   	pop    %esi
  80198f:	5f                   	pop    %edi
  801990:	5d                   	pop    %ebp
  801991:	c3                   	ret    
  801992:	66 90                	xchg   %ax,%ax
  801994:	89 d8                	mov    %ebx,%eax
  801996:	f7 f7                	div    %edi
  801998:	31 ff                	xor    %edi,%edi
  80199a:	89 fa                	mov    %edi,%edx
  80199c:	83 c4 1c             	add    $0x1c,%esp
  80199f:	5b                   	pop    %ebx
  8019a0:	5e                   	pop    %esi
  8019a1:	5f                   	pop    %edi
  8019a2:	5d                   	pop    %ebp
  8019a3:	c3                   	ret    
  8019a4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8019a9:	89 eb                	mov    %ebp,%ebx
  8019ab:	29 fb                	sub    %edi,%ebx
  8019ad:	89 f9                	mov    %edi,%ecx
  8019af:	d3 e6                	shl    %cl,%esi
  8019b1:	89 c5                	mov    %eax,%ebp
  8019b3:	88 d9                	mov    %bl,%cl
  8019b5:	d3 ed                	shr    %cl,%ebp
  8019b7:	89 e9                	mov    %ebp,%ecx
  8019b9:	09 f1                	or     %esi,%ecx
  8019bb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8019bf:	89 f9                	mov    %edi,%ecx
  8019c1:	d3 e0                	shl    %cl,%eax
  8019c3:	89 c5                	mov    %eax,%ebp
  8019c5:	89 d6                	mov    %edx,%esi
  8019c7:	88 d9                	mov    %bl,%cl
  8019c9:	d3 ee                	shr    %cl,%esi
  8019cb:	89 f9                	mov    %edi,%ecx
  8019cd:	d3 e2                	shl    %cl,%edx
  8019cf:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019d3:	88 d9                	mov    %bl,%cl
  8019d5:	d3 e8                	shr    %cl,%eax
  8019d7:	09 c2                	or     %eax,%edx
  8019d9:	89 d0                	mov    %edx,%eax
  8019db:	89 f2                	mov    %esi,%edx
  8019dd:	f7 74 24 0c          	divl   0xc(%esp)
  8019e1:	89 d6                	mov    %edx,%esi
  8019e3:	89 c3                	mov    %eax,%ebx
  8019e5:	f7 e5                	mul    %ebp
  8019e7:	39 d6                	cmp    %edx,%esi
  8019e9:	72 19                	jb     801a04 <__udivdi3+0xfc>
  8019eb:	74 0b                	je     8019f8 <__udivdi3+0xf0>
  8019ed:	89 d8                	mov    %ebx,%eax
  8019ef:	31 ff                	xor    %edi,%edi
  8019f1:	e9 58 ff ff ff       	jmp    80194e <__udivdi3+0x46>
  8019f6:	66 90                	xchg   %ax,%ax
  8019f8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8019fc:	89 f9                	mov    %edi,%ecx
  8019fe:	d3 e2                	shl    %cl,%edx
  801a00:	39 c2                	cmp    %eax,%edx
  801a02:	73 e9                	jae    8019ed <__udivdi3+0xe5>
  801a04:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a07:	31 ff                	xor    %edi,%edi
  801a09:	e9 40 ff ff ff       	jmp    80194e <__udivdi3+0x46>
  801a0e:	66 90                	xchg   %ax,%ax
  801a10:	31 c0                	xor    %eax,%eax
  801a12:	e9 37 ff ff ff       	jmp    80194e <__udivdi3+0x46>
  801a17:	90                   	nop

00801a18 <__umoddi3>:
  801a18:	55                   	push   %ebp
  801a19:	57                   	push   %edi
  801a1a:	56                   	push   %esi
  801a1b:	53                   	push   %ebx
  801a1c:	83 ec 1c             	sub    $0x1c,%esp
  801a1f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801a23:	8b 74 24 34          	mov    0x34(%esp),%esi
  801a27:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a2b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801a2f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a33:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a37:	89 f3                	mov    %esi,%ebx
  801a39:	89 fa                	mov    %edi,%edx
  801a3b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a3f:	89 34 24             	mov    %esi,(%esp)
  801a42:	85 c0                	test   %eax,%eax
  801a44:	75 1a                	jne    801a60 <__umoddi3+0x48>
  801a46:	39 f7                	cmp    %esi,%edi
  801a48:	0f 86 a2 00 00 00    	jbe    801af0 <__umoddi3+0xd8>
  801a4e:	89 c8                	mov    %ecx,%eax
  801a50:	89 f2                	mov    %esi,%edx
  801a52:	f7 f7                	div    %edi
  801a54:	89 d0                	mov    %edx,%eax
  801a56:	31 d2                	xor    %edx,%edx
  801a58:	83 c4 1c             	add    $0x1c,%esp
  801a5b:	5b                   	pop    %ebx
  801a5c:	5e                   	pop    %esi
  801a5d:	5f                   	pop    %edi
  801a5e:	5d                   	pop    %ebp
  801a5f:	c3                   	ret    
  801a60:	39 f0                	cmp    %esi,%eax
  801a62:	0f 87 ac 00 00 00    	ja     801b14 <__umoddi3+0xfc>
  801a68:	0f bd e8             	bsr    %eax,%ebp
  801a6b:	83 f5 1f             	xor    $0x1f,%ebp
  801a6e:	0f 84 ac 00 00 00    	je     801b20 <__umoddi3+0x108>
  801a74:	bf 20 00 00 00       	mov    $0x20,%edi
  801a79:	29 ef                	sub    %ebp,%edi
  801a7b:	89 fe                	mov    %edi,%esi
  801a7d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801a81:	89 e9                	mov    %ebp,%ecx
  801a83:	d3 e0                	shl    %cl,%eax
  801a85:	89 d7                	mov    %edx,%edi
  801a87:	89 f1                	mov    %esi,%ecx
  801a89:	d3 ef                	shr    %cl,%edi
  801a8b:	09 c7                	or     %eax,%edi
  801a8d:	89 e9                	mov    %ebp,%ecx
  801a8f:	d3 e2                	shl    %cl,%edx
  801a91:	89 14 24             	mov    %edx,(%esp)
  801a94:	89 d8                	mov    %ebx,%eax
  801a96:	d3 e0                	shl    %cl,%eax
  801a98:	89 c2                	mov    %eax,%edx
  801a9a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a9e:	d3 e0                	shl    %cl,%eax
  801aa0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aa4:	8b 44 24 08          	mov    0x8(%esp),%eax
  801aa8:	89 f1                	mov    %esi,%ecx
  801aaa:	d3 e8                	shr    %cl,%eax
  801aac:	09 d0                	or     %edx,%eax
  801aae:	d3 eb                	shr    %cl,%ebx
  801ab0:	89 da                	mov    %ebx,%edx
  801ab2:	f7 f7                	div    %edi
  801ab4:	89 d3                	mov    %edx,%ebx
  801ab6:	f7 24 24             	mull   (%esp)
  801ab9:	89 c6                	mov    %eax,%esi
  801abb:	89 d1                	mov    %edx,%ecx
  801abd:	39 d3                	cmp    %edx,%ebx
  801abf:	0f 82 87 00 00 00    	jb     801b4c <__umoddi3+0x134>
  801ac5:	0f 84 91 00 00 00    	je     801b5c <__umoddi3+0x144>
  801acb:	8b 54 24 04          	mov    0x4(%esp),%edx
  801acf:	29 f2                	sub    %esi,%edx
  801ad1:	19 cb                	sbb    %ecx,%ebx
  801ad3:	89 d8                	mov    %ebx,%eax
  801ad5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801ad9:	d3 e0                	shl    %cl,%eax
  801adb:	89 e9                	mov    %ebp,%ecx
  801add:	d3 ea                	shr    %cl,%edx
  801adf:	09 d0                	or     %edx,%eax
  801ae1:	89 e9                	mov    %ebp,%ecx
  801ae3:	d3 eb                	shr    %cl,%ebx
  801ae5:	89 da                	mov    %ebx,%edx
  801ae7:	83 c4 1c             	add    $0x1c,%esp
  801aea:	5b                   	pop    %ebx
  801aeb:	5e                   	pop    %esi
  801aec:	5f                   	pop    %edi
  801aed:	5d                   	pop    %ebp
  801aee:	c3                   	ret    
  801aef:	90                   	nop
  801af0:	89 fd                	mov    %edi,%ebp
  801af2:	85 ff                	test   %edi,%edi
  801af4:	75 0b                	jne    801b01 <__umoddi3+0xe9>
  801af6:	b8 01 00 00 00       	mov    $0x1,%eax
  801afb:	31 d2                	xor    %edx,%edx
  801afd:	f7 f7                	div    %edi
  801aff:	89 c5                	mov    %eax,%ebp
  801b01:	89 f0                	mov    %esi,%eax
  801b03:	31 d2                	xor    %edx,%edx
  801b05:	f7 f5                	div    %ebp
  801b07:	89 c8                	mov    %ecx,%eax
  801b09:	f7 f5                	div    %ebp
  801b0b:	89 d0                	mov    %edx,%eax
  801b0d:	e9 44 ff ff ff       	jmp    801a56 <__umoddi3+0x3e>
  801b12:	66 90                	xchg   %ax,%ax
  801b14:	89 c8                	mov    %ecx,%eax
  801b16:	89 f2                	mov    %esi,%edx
  801b18:	83 c4 1c             	add    $0x1c,%esp
  801b1b:	5b                   	pop    %ebx
  801b1c:	5e                   	pop    %esi
  801b1d:	5f                   	pop    %edi
  801b1e:	5d                   	pop    %ebp
  801b1f:	c3                   	ret    
  801b20:	3b 04 24             	cmp    (%esp),%eax
  801b23:	72 06                	jb     801b2b <__umoddi3+0x113>
  801b25:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801b29:	77 0f                	ja     801b3a <__umoddi3+0x122>
  801b2b:	89 f2                	mov    %esi,%edx
  801b2d:	29 f9                	sub    %edi,%ecx
  801b2f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801b33:	89 14 24             	mov    %edx,(%esp)
  801b36:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b3a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801b3e:	8b 14 24             	mov    (%esp),%edx
  801b41:	83 c4 1c             	add    $0x1c,%esp
  801b44:	5b                   	pop    %ebx
  801b45:	5e                   	pop    %esi
  801b46:	5f                   	pop    %edi
  801b47:	5d                   	pop    %ebp
  801b48:	c3                   	ret    
  801b49:	8d 76 00             	lea    0x0(%esi),%esi
  801b4c:	2b 04 24             	sub    (%esp),%eax
  801b4f:	19 fa                	sbb    %edi,%edx
  801b51:	89 d1                	mov    %edx,%ecx
  801b53:	89 c6                	mov    %eax,%esi
  801b55:	e9 71 ff ff ff       	jmp    801acb <__umoddi3+0xb3>
  801b5a:	66 90                	xchg   %ax,%ax
  801b5c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801b60:	72 ea                	jb     801b4c <__umoddi3+0x134>
  801b62:	89 d9                	mov    %ebx,%ecx
  801b64:	e9 62 ff ff ff       	jmp    801acb <__umoddi3+0xb3>
