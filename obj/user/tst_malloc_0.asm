
obj/user/tst_malloc_0:     file format elf32-i386


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
  800031:	e8 a3 01 00 00       	call   8001d9 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
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
void _main(void)
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
  80008c:	68 a0 32 80 00       	push   $0x8032a0
  800091:	6a 14                	push   $0x14
  800093:	68 bc 32 80 00       	push   $0x8032bc
  800098:	e8 78 02 00 00       	call   800315 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	if(STATIC_MEMBLOCK_ALLOC != 0)
		panic("STATIC_MEMBLOCK_ALLOC = 1 & it shall be 0. Go to 'inc/dynamic_allocator.h' and set STATIC_MEMBLOCK_ALLOC by 0. Then, repeat the test again.");

	int freeFrames_before = sys_calculate_free_frames() ;
  80009d:	e8 df 18 00 00       	call   801981 <sys_calculate_free_frames>
  8000a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int freeDiskFrames_before = sys_pf_calculate_allocated_pages() ;
  8000a5:	e8 77 19 00 00       	call   801a21 <sys_pf_calculate_allocated_pages>
  8000aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
	malloc(0);
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	6a 00                	push   $0x0
  8000b2:	e8 8b 14 00 00       	call   801542 <malloc>
  8000b7:	83 c4 10             	add    $0x10,%esp
	int freeFrames_after = sys_calculate_free_frames() ;
  8000ba:	e8 c2 18 00 00       	call   801981 <sys_calculate_free_frames>
  8000bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int freeDiskFrames_after = sys_pf_calculate_allocated_pages() ;
  8000c2:	e8 5a 19 00 00       	call   801a21 <sys_pf_calculate_allocated_pages>
  8000c7:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//Check MAX_MEM_BLOCK_CNT
	if(MAX_MEM_BLOCK_CNT != ((0xA0000000-0x80000000)/4096))
  8000ca:	a1 20 41 80 00       	mov    0x804120,%eax
  8000cf:	3d 00 00 02 00       	cmp    $0x20000,%eax
  8000d4:	74 14                	je     8000ea <_main+0xb2>
	{
		panic("Wrong initialize: MAX_MEM_BLOCK_CNT is not set with the correct size of the array");
  8000d6:	83 ec 04             	sub    $0x4,%esp
  8000d9:	68 d0 32 80 00       	push   $0x8032d0
  8000de:	6a 23                	push   $0x23
  8000e0:	68 bc 32 80 00       	push   $0x8032bc
  8000e5:	e8 2b 02 00 00       	call   800315 <_panic>
	}

	//Check number of nodes in AvailableMemBlocksList
	if (LIST_SIZE(&(AvailableMemBlocksList)) != MAX_MEM_BLOCK_CNT-1)
  8000ea:	a1 54 41 80 00       	mov    0x804154,%eax
  8000ef:	8b 15 20 41 80 00    	mov    0x804120,%edx
  8000f5:	4a                   	dec    %edx
  8000f6:	39 d0                	cmp    %edx,%eax
  8000f8:	74 14                	je     80010e <_main+0xd6>
	{
		panic("Wrong initialize: Wrong size for the AvailableMemBlocksList");
  8000fa:	83 ec 04             	sub    $0x4,%esp
  8000fd:	68 24 33 80 00       	push   $0x803324
  800102:	6a 29                	push   $0x29
  800104:	68 bc 32 80 00       	push   $0x8032bc
  800109:	e8 07 02 00 00       	call   800315 <_panic>
	}

	//Check number of nodes in AllocMemBlocksList
	if (LIST_SIZE(&(AllocMemBlocksList)) != 0)
  80010e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  800113:	85 c0                	test   %eax,%eax
  800115:	74 14                	je     80012b <_main+0xf3>
	{
		panic("Wrong initialize: Wrong size for the AllocMemBlocksList");
  800117:	83 ec 04             	sub    $0x4,%esp
  80011a:	68 60 33 80 00       	push   $0x803360
  80011f:	6a 2f                	push   $0x2f
  800121:	68 bc 32 80 00       	push   $0x8032bc
  800126:	e8 ea 01 00 00       	call   800315 <_panic>
	}

	//Check number of nodes in FreeMemBlocksList
	if (LIST_SIZE(&(FreeMemBlocksList)) != 1)
  80012b:	a1 44 41 80 00       	mov    0x804144,%eax
  800130:	83 f8 01             	cmp    $0x1,%eax
  800133:	74 14                	je     800149 <_main+0x111>
	{
		panic("Wrong initialize: Wrong size for the FreeMemBlocksList");
  800135:	83 ec 04             	sub    $0x4,%esp
  800138:	68 98 33 80 00       	push   $0x803398
  80013d:	6a 35                	push   $0x35
  80013f:	68 bc 32 80 00       	push   $0x8032bc
  800144:	e8 cc 01 00 00       	call   800315 <_panic>
	}

	//Check content of FreeMemBlocksList
	struct MemBlock* block = LIST_FIRST(&FreeMemBlocksList);
  800149:	a1 38 41 80 00       	mov    0x804138,%eax
  80014e:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if(block == NULL || block->size != (0xA0000000-0x80000000) || block->sva != 0x80000000)
  800151:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800155:	74 1a                	je     800171 <_main+0x139>
  800157:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80015a:	8b 40 0c             	mov    0xc(%eax),%eax
  80015d:	3d 00 00 00 20       	cmp    $0x20000000,%eax
  800162:	75 0d                	jne    800171 <_main+0x139>
  800164:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800167:	8b 40 08             	mov    0x8(%eax),%eax
  80016a:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  80016f:	74 14                	je     800185 <_main+0x14d>
	{
		panic("Wrong initialize: Wrong content for the FreeMemBlocksList.");
  800171:	83 ec 04             	sub    $0x4,%esp
  800174:	68 d0 33 80 00       	push   $0x8033d0
  800179:	6a 3c                	push   $0x3c
  80017b:	68 bc 32 80 00       	push   $0x8032bc
  800180:	e8 90 01 00 00       	call   800315 <_panic>
	}

	//Check number of disk and memory frames
	if ((freeDiskFrames_after - freeDiskFrames_before) != 0) panic("Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)");
  800185:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800188:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80018b:	74 14                	je     8001a1 <_main+0x169>
  80018d:	83 ec 04             	sub    $0x4,%esp
  800190:	68 0c 34 80 00       	push   $0x80340c
  800195:	6a 40                	push   $0x40
  800197:	68 bc 32 80 00       	push   $0x8032bc
  80019c:	e8 74 01 00 00       	call   800315 <_panic>
	if ((freeFrames_before - freeFrames_after) != 512 + 1) panic("Wrong allocation: pages are not loaded successfully into memory %d", (freeFrames_before - freeFrames_after));
  8001a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001a4:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001a7:	3d 01 02 00 00       	cmp    $0x201,%eax
  8001ac:	74 18                	je     8001c6 <_main+0x18e>
  8001ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001b1:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001b4:	50                   	push   %eax
  8001b5:	68 74 34 80 00       	push   $0x803474
  8001ba:	6a 41                	push   $0x41
  8001bc:	68 bc 32 80 00       	push   $0x8032bc
  8001c1:	e8 4f 01 00 00       	call   800315 <_panic>

	/*=================================================*/

	cprintf("Congratulations!! test initialize_dyn_block_system of UHEAP completed successfully.\n");
  8001c6:	83 ec 0c             	sub    $0xc,%esp
  8001c9:	68 b8 34 80 00       	push   $0x8034b8
  8001ce:	e8 f6 03 00 00       	call   8005c9 <cprintf>
  8001d3:	83 c4 10             	add    $0x10,%esp

	return;
  8001d6:	90                   	nop
}
  8001d7:	c9                   	leave  
  8001d8:	c3                   	ret    

008001d9 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001d9:	55                   	push   %ebp
  8001da:	89 e5                	mov    %esp,%ebp
  8001dc:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001df:	e8 7d 1a 00 00       	call   801c61 <sys_getenvindex>
  8001e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001ea:	89 d0                	mov    %edx,%eax
  8001ec:	c1 e0 03             	shl    $0x3,%eax
  8001ef:	01 d0                	add    %edx,%eax
  8001f1:	01 c0                	add    %eax,%eax
  8001f3:	01 d0                	add    %edx,%eax
  8001f5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001fc:	01 d0                	add    %edx,%eax
  8001fe:	c1 e0 04             	shl    $0x4,%eax
  800201:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800206:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80020b:	a1 20 40 80 00       	mov    0x804020,%eax
  800210:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800216:	84 c0                	test   %al,%al
  800218:	74 0f                	je     800229 <libmain+0x50>
		binaryname = myEnv->prog_name;
  80021a:	a1 20 40 80 00       	mov    0x804020,%eax
  80021f:	05 5c 05 00 00       	add    $0x55c,%eax
  800224:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800229:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80022d:	7e 0a                	jle    800239 <libmain+0x60>
		binaryname = argv[0];
  80022f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800232:	8b 00                	mov    (%eax),%eax
  800234:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800239:	83 ec 08             	sub    $0x8,%esp
  80023c:	ff 75 0c             	pushl  0xc(%ebp)
  80023f:	ff 75 08             	pushl  0x8(%ebp)
  800242:	e8 f1 fd ff ff       	call   800038 <_main>
  800247:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80024a:	e8 1f 18 00 00       	call   801a6e <sys_disable_interrupt>
	cprintf("**************************************\n");
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	68 28 35 80 00       	push   $0x803528
  800257:	e8 6d 03 00 00       	call   8005c9 <cprintf>
  80025c:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80025f:	a1 20 40 80 00       	mov    0x804020,%eax
  800264:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80026a:	a1 20 40 80 00       	mov    0x804020,%eax
  80026f:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800275:	83 ec 04             	sub    $0x4,%esp
  800278:	52                   	push   %edx
  800279:	50                   	push   %eax
  80027a:	68 50 35 80 00       	push   $0x803550
  80027f:	e8 45 03 00 00       	call   8005c9 <cprintf>
  800284:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800287:	a1 20 40 80 00       	mov    0x804020,%eax
  80028c:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800292:	a1 20 40 80 00       	mov    0x804020,%eax
  800297:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80029d:	a1 20 40 80 00       	mov    0x804020,%eax
  8002a2:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8002a8:	51                   	push   %ecx
  8002a9:	52                   	push   %edx
  8002aa:	50                   	push   %eax
  8002ab:	68 78 35 80 00       	push   $0x803578
  8002b0:	e8 14 03 00 00       	call   8005c9 <cprintf>
  8002b5:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002b8:	a1 20 40 80 00       	mov    0x804020,%eax
  8002bd:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8002c3:	83 ec 08             	sub    $0x8,%esp
  8002c6:	50                   	push   %eax
  8002c7:	68 d0 35 80 00       	push   $0x8035d0
  8002cc:	e8 f8 02 00 00       	call   8005c9 <cprintf>
  8002d1:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002d4:	83 ec 0c             	sub    $0xc,%esp
  8002d7:	68 28 35 80 00       	push   $0x803528
  8002dc:	e8 e8 02 00 00       	call   8005c9 <cprintf>
  8002e1:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002e4:	e8 9f 17 00 00       	call   801a88 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002e9:	e8 19 00 00 00       	call   800307 <exit>
}
  8002ee:	90                   	nop
  8002ef:	c9                   	leave  
  8002f0:	c3                   	ret    

008002f1 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002f1:	55                   	push   %ebp
  8002f2:	89 e5                	mov    %esp,%ebp
  8002f4:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002f7:	83 ec 0c             	sub    $0xc,%esp
  8002fa:	6a 00                	push   $0x0
  8002fc:	e8 2c 19 00 00       	call   801c2d <sys_destroy_env>
  800301:	83 c4 10             	add    $0x10,%esp
}
  800304:	90                   	nop
  800305:	c9                   	leave  
  800306:	c3                   	ret    

00800307 <exit>:

void
exit(void)
{
  800307:	55                   	push   %ebp
  800308:	89 e5                	mov    %esp,%ebp
  80030a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80030d:	e8 81 19 00 00       	call   801c93 <sys_exit_env>
}
  800312:	90                   	nop
  800313:	c9                   	leave  
  800314:	c3                   	ret    

00800315 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800315:	55                   	push   %ebp
  800316:	89 e5                	mov    %esp,%ebp
  800318:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80031b:	8d 45 10             	lea    0x10(%ebp),%eax
  80031e:	83 c0 04             	add    $0x4,%eax
  800321:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800324:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800329:	85 c0                	test   %eax,%eax
  80032b:	74 16                	je     800343 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80032d:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800332:	83 ec 08             	sub    $0x8,%esp
  800335:	50                   	push   %eax
  800336:	68 e4 35 80 00       	push   $0x8035e4
  80033b:	e8 89 02 00 00       	call   8005c9 <cprintf>
  800340:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800343:	a1 00 40 80 00       	mov    0x804000,%eax
  800348:	ff 75 0c             	pushl  0xc(%ebp)
  80034b:	ff 75 08             	pushl  0x8(%ebp)
  80034e:	50                   	push   %eax
  80034f:	68 e9 35 80 00       	push   $0x8035e9
  800354:	e8 70 02 00 00       	call   8005c9 <cprintf>
  800359:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80035c:	8b 45 10             	mov    0x10(%ebp),%eax
  80035f:	83 ec 08             	sub    $0x8,%esp
  800362:	ff 75 f4             	pushl  -0xc(%ebp)
  800365:	50                   	push   %eax
  800366:	e8 f3 01 00 00       	call   80055e <vcprintf>
  80036b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80036e:	83 ec 08             	sub    $0x8,%esp
  800371:	6a 00                	push   $0x0
  800373:	68 05 36 80 00       	push   $0x803605
  800378:	e8 e1 01 00 00       	call   80055e <vcprintf>
  80037d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800380:	e8 82 ff ff ff       	call   800307 <exit>

	// should not return here
	while (1) ;
  800385:	eb fe                	jmp    800385 <_panic+0x70>

00800387 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800387:	55                   	push   %ebp
  800388:	89 e5                	mov    %esp,%ebp
  80038a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80038d:	a1 20 40 80 00       	mov    0x804020,%eax
  800392:	8b 50 74             	mov    0x74(%eax),%edx
  800395:	8b 45 0c             	mov    0xc(%ebp),%eax
  800398:	39 c2                	cmp    %eax,%edx
  80039a:	74 14                	je     8003b0 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80039c:	83 ec 04             	sub    $0x4,%esp
  80039f:	68 08 36 80 00       	push   $0x803608
  8003a4:	6a 26                	push   $0x26
  8003a6:	68 54 36 80 00       	push   $0x803654
  8003ab:	e8 65 ff ff ff       	call   800315 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003b7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003be:	e9 c2 00 00 00       	jmp    800485 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8003c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003c6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d0:	01 d0                	add    %edx,%eax
  8003d2:	8b 00                	mov    (%eax),%eax
  8003d4:	85 c0                	test   %eax,%eax
  8003d6:	75 08                	jne    8003e0 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8003d8:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003db:	e9 a2 00 00 00       	jmp    800482 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8003e0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003e7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003ee:	eb 69                	jmp    800459 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003f0:	a1 20 40 80 00       	mov    0x804020,%eax
  8003f5:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003fb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003fe:	89 d0                	mov    %edx,%eax
  800400:	01 c0                	add    %eax,%eax
  800402:	01 d0                	add    %edx,%eax
  800404:	c1 e0 03             	shl    $0x3,%eax
  800407:	01 c8                	add    %ecx,%eax
  800409:	8a 40 04             	mov    0x4(%eax),%al
  80040c:	84 c0                	test   %al,%al
  80040e:	75 46                	jne    800456 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800410:	a1 20 40 80 00       	mov    0x804020,%eax
  800415:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80041b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80041e:	89 d0                	mov    %edx,%eax
  800420:	01 c0                	add    %eax,%eax
  800422:	01 d0                	add    %edx,%eax
  800424:	c1 e0 03             	shl    $0x3,%eax
  800427:	01 c8                	add    %ecx,%eax
  800429:	8b 00                	mov    (%eax),%eax
  80042b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80042e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800431:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800436:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800438:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80043b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800442:	8b 45 08             	mov    0x8(%ebp),%eax
  800445:	01 c8                	add    %ecx,%eax
  800447:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800449:	39 c2                	cmp    %eax,%edx
  80044b:	75 09                	jne    800456 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80044d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800454:	eb 12                	jmp    800468 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800456:	ff 45 e8             	incl   -0x18(%ebp)
  800459:	a1 20 40 80 00       	mov    0x804020,%eax
  80045e:	8b 50 74             	mov    0x74(%eax),%edx
  800461:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800464:	39 c2                	cmp    %eax,%edx
  800466:	77 88                	ja     8003f0 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800468:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80046c:	75 14                	jne    800482 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80046e:	83 ec 04             	sub    $0x4,%esp
  800471:	68 60 36 80 00       	push   $0x803660
  800476:	6a 3a                	push   $0x3a
  800478:	68 54 36 80 00       	push   $0x803654
  80047d:	e8 93 fe ff ff       	call   800315 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800482:	ff 45 f0             	incl   -0x10(%ebp)
  800485:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800488:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80048b:	0f 8c 32 ff ff ff    	jl     8003c3 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800491:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800498:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80049f:	eb 26                	jmp    8004c7 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004a1:	a1 20 40 80 00       	mov    0x804020,%eax
  8004a6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004ac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004af:	89 d0                	mov    %edx,%eax
  8004b1:	01 c0                	add    %eax,%eax
  8004b3:	01 d0                	add    %edx,%eax
  8004b5:	c1 e0 03             	shl    $0x3,%eax
  8004b8:	01 c8                	add    %ecx,%eax
  8004ba:	8a 40 04             	mov    0x4(%eax),%al
  8004bd:	3c 01                	cmp    $0x1,%al
  8004bf:	75 03                	jne    8004c4 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8004c1:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004c4:	ff 45 e0             	incl   -0x20(%ebp)
  8004c7:	a1 20 40 80 00       	mov    0x804020,%eax
  8004cc:	8b 50 74             	mov    0x74(%eax),%edx
  8004cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004d2:	39 c2                	cmp    %eax,%edx
  8004d4:	77 cb                	ja     8004a1 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004d9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004dc:	74 14                	je     8004f2 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8004de:	83 ec 04             	sub    $0x4,%esp
  8004e1:	68 b4 36 80 00       	push   $0x8036b4
  8004e6:	6a 44                	push   $0x44
  8004e8:	68 54 36 80 00       	push   $0x803654
  8004ed:	e8 23 fe ff ff       	call   800315 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004f2:	90                   	nop
  8004f3:	c9                   	leave  
  8004f4:	c3                   	ret    

008004f5 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8004f5:	55                   	push   %ebp
  8004f6:	89 e5                	mov    %esp,%ebp
  8004f8:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004fe:	8b 00                	mov    (%eax),%eax
  800500:	8d 48 01             	lea    0x1(%eax),%ecx
  800503:	8b 55 0c             	mov    0xc(%ebp),%edx
  800506:	89 0a                	mov    %ecx,(%edx)
  800508:	8b 55 08             	mov    0x8(%ebp),%edx
  80050b:	88 d1                	mov    %dl,%cl
  80050d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800510:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800514:	8b 45 0c             	mov    0xc(%ebp),%eax
  800517:	8b 00                	mov    (%eax),%eax
  800519:	3d ff 00 00 00       	cmp    $0xff,%eax
  80051e:	75 2c                	jne    80054c <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800520:	a0 24 40 80 00       	mov    0x804024,%al
  800525:	0f b6 c0             	movzbl %al,%eax
  800528:	8b 55 0c             	mov    0xc(%ebp),%edx
  80052b:	8b 12                	mov    (%edx),%edx
  80052d:	89 d1                	mov    %edx,%ecx
  80052f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800532:	83 c2 08             	add    $0x8,%edx
  800535:	83 ec 04             	sub    $0x4,%esp
  800538:	50                   	push   %eax
  800539:	51                   	push   %ecx
  80053a:	52                   	push   %edx
  80053b:	e8 80 13 00 00       	call   8018c0 <sys_cputs>
  800540:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800543:	8b 45 0c             	mov    0xc(%ebp),%eax
  800546:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80054c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80054f:	8b 40 04             	mov    0x4(%eax),%eax
  800552:	8d 50 01             	lea    0x1(%eax),%edx
  800555:	8b 45 0c             	mov    0xc(%ebp),%eax
  800558:	89 50 04             	mov    %edx,0x4(%eax)
}
  80055b:	90                   	nop
  80055c:	c9                   	leave  
  80055d:	c3                   	ret    

0080055e <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80055e:	55                   	push   %ebp
  80055f:	89 e5                	mov    %esp,%ebp
  800561:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800567:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80056e:	00 00 00 
	b.cnt = 0;
  800571:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800578:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80057b:	ff 75 0c             	pushl  0xc(%ebp)
  80057e:	ff 75 08             	pushl  0x8(%ebp)
  800581:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800587:	50                   	push   %eax
  800588:	68 f5 04 80 00       	push   $0x8004f5
  80058d:	e8 11 02 00 00       	call   8007a3 <vprintfmt>
  800592:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800595:	a0 24 40 80 00       	mov    0x804024,%al
  80059a:	0f b6 c0             	movzbl %al,%eax
  80059d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005a3:	83 ec 04             	sub    $0x4,%esp
  8005a6:	50                   	push   %eax
  8005a7:	52                   	push   %edx
  8005a8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005ae:	83 c0 08             	add    $0x8,%eax
  8005b1:	50                   	push   %eax
  8005b2:	e8 09 13 00 00       	call   8018c0 <sys_cputs>
  8005b7:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005ba:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  8005c1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005c7:	c9                   	leave  
  8005c8:	c3                   	ret    

008005c9 <cprintf>:

int cprintf(const char *fmt, ...) {
  8005c9:	55                   	push   %ebp
  8005ca:	89 e5                	mov    %esp,%ebp
  8005cc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005cf:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8005d6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005df:	83 ec 08             	sub    $0x8,%esp
  8005e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8005e5:	50                   	push   %eax
  8005e6:	e8 73 ff ff ff       	call   80055e <vcprintf>
  8005eb:	83 c4 10             	add    $0x10,%esp
  8005ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005f4:	c9                   	leave  
  8005f5:	c3                   	ret    

008005f6 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8005f6:	55                   	push   %ebp
  8005f7:	89 e5                	mov    %esp,%ebp
  8005f9:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005fc:	e8 6d 14 00 00       	call   801a6e <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800601:	8d 45 0c             	lea    0xc(%ebp),%eax
  800604:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800607:	8b 45 08             	mov    0x8(%ebp),%eax
  80060a:	83 ec 08             	sub    $0x8,%esp
  80060d:	ff 75 f4             	pushl  -0xc(%ebp)
  800610:	50                   	push   %eax
  800611:	e8 48 ff ff ff       	call   80055e <vcprintf>
  800616:	83 c4 10             	add    $0x10,%esp
  800619:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80061c:	e8 67 14 00 00       	call   801a88 <sys_enable_interrupt>
	return cnt;
  800621:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800624:	c9                   	leave  
  800625:	c3                   	ret    

00800626 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800626:	55                   	push   %ebp
  800627:	89 e5                	mov    %esp,%ebp
  800629:	53                   	push   %ebx
  80062a:	83 ec 14             	sub    $0x14,%esp
  80062d:	8b 45 10             	mov    0x10(%ebp),%eax
  800630:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800633:	8b 45 14             	mov    0x14(%ebp),%eax
  800636:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800639:	8b 45 18             	mov    0x18(%ebp),%eax
  80063c:	ba 00 00 00 00       	mov    $0x0,%edx
  800641:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800644:	77 55                	ja     80069b <printnum+0x75>
  800646:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800649:	72 05                	jb     800650 <printnum+0x2a>
  80064b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80064e:	77 4b                	ja     80069b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800650:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800653:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800656:	8b 45 18             	mov    0x18(%ebp),%eax
  800659:	ba 00 00 00 00       	mov    $0x0,%edx
  80065e:	52                   	push   %edx
  80065f:	50                   	push   %eax
  800660:	ff 75 f4             	pushl  -0xc(%ebp)
  800663:	ff 75 f0             	pushl  -0x10(%ebp)
  800666:	e8 cd 29 00 00       	call   803038 <__udivdi3>
  80066b:	83 c4 10             	add    $0x10,%esp
  80066e:	83 ec 04             	sub    $0x4,%esp
  800671:	ff 75 20             	pushl  0x20(%ebp)
  800674:	53                   	push   %ebx
  800675:	ff 75 18             	pushl  0x18(%ebp)
  800678:	52                   	push   %edx
  800679:	50                   	push   %eax
  80067a:	ff 75 0c             	pushl  0xc(%ebp)
  80067d:	ff 75 08             	pushl  0x8(%ebp)
  800680:	e8 a1 ff ff ff       	call   800626 <printnum>
  800685:	83 c4 20             	add    $0x20,%esp
  800688:	eb 1a                	jmp    8006a4 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80068a:	83 ec 08             	sub    $0x8,%esp
  80068d:	ff 75 0c             	pushl  0xc(%ebp)
  800690:	ff 75 20             	pushl  0x20(%ebp)
  800693:	8b 45 08             	mov    0x8(%ebp),%eax
  800696:	ff d0                	call   *%eax
  800698:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80069b:	ff 4d 1c             	decl   0x1c(%ebp)
  80069e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006a2:	7f e6                	jg     80068a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006a4:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006a7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006b2:	53                   	push   %ebx
  8006b3:	51                   	push   %ecx
  8006b4:	52                   	push   %edx
  8006b5:	50                   	push   %eax
  8006b6:	e8 8d 2a 00 00       	call   803148 <__umoddi3>
  8006bb:	83 c4 10             	add    $0x10,%esp
  8006be:	05 14 39 80 00       	add    $0x803914,%eax
  8006c3:	8a 00                	mov    (%eax),%al
  8006c5:	0f be c0             	movsbl %al,%eax
  8006c8:	83 ec 08             	sub    $0x8,%esp
  8006cb:	ff 75 0c             	pushl  0xc(%ebp)
  8006ce:	50                   	push   %eax
  8006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d2:	ff d0                	call   *%eax
  8006d4:	83 c4 10             	add    $0x10,%esp
}
  8006d7:	90                   	nop
  8006d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006db:	c9                   	leave  
  8006dc:	c3                   	ret    

008006dd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006dd:	55                   	push   %ebp
  8006de:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006e0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006e4:	7e 1c                	jle    800702 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e9:	8b 00                	mov    (%eax),%eax
  8006eb:	8d 50 08             	lea    0x8(%eax),%edx
  8006ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f1:	89 10                	mov    %edx,(%eax)
  8006f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f6:	8b 00                	mov    (%eax),%eax
  8006f8:	83 e8 08             	sub    $0x8,%eax
  8006fb:	8b 50 04             	mov    0x4(%eax),%edx
  8006fe:	8b 00                	mov    (%eax),%eax
  800700:	eb 40                	jmp    800742 <getuint+0x65>
	else if (lflag)
  800702:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800706:	74 1e                	je     800726 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800708:	8b 45 08             	mov    0x8(%ebp),%eax
  80070b:	8b 00                	mov    (%eax),%eax
  80070d:	8d 50 04             	lea    0x4(%eax),%edx
  800710:	8b 45 08             	mov    0x8(%ebp),%eax
  800713:	89 10                	mov    %edx,(%eax)
  800715:	8b 45 08             	mov    0x8(%ebp),%eax
  800718:	8b 00                	mov    (%eax),%eax
  80071a:	83 e8 04             	sub    $0x4,%eax
  80071d:	8b 00                	mov    (%eax),%eax
  80071f:	ba 00 00 00 00       	mov    $0x0,%edx
  800724:	eb 1c                	jmp    800742 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800726:	8b 45 08             	mov    0x8(%ebp),%eax
  800729:	8b 00                	mov    (%eax),%eax
  80072b:	8d 50 04             	lea    0x4(%eax),%edx
  80072e:	8b 45 08             	mov    0x8(%ebp),%eax
  800731:	89 10                	mov    %edx,(%eax)
  800733:	8b 45 08             	mov    0x8(%ebp),%eax
  800736:	8b 00                	mov    (%eax),%eax
  800738:	83 e8 04             	sub    $0x4,%eax
  80073b:	8b 00                	mov    (%eax),%eax
  80073d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800742:	5d                   	pop    %ebp
  800743:	c3                   	ret    

00800744 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800744:	55                   	push   %ebp
  800745:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800747:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80074b:	7e 1c                	jle    800769 <getint+0x25>
		return va_arg(*ap, long long);
  80074d:	8b 45 08             	mov    0x8(%ebp),%eax
  800750:	8b 00                	mov    (%eax),%eax
  800752:	8d 50 08             	lea    0x8(%eax),%edx
  800755:	8b 45 08             	mov    0x8(%ebp),%eax
  800758:	89 10                	mov    %edx,(%eax)
  80075a:	8b 45 08             	mov    0x8(%ebp),%eax
  80075d:	8b 00                	mov    (%eax),%eax
  80075f:	83 e8 08             	sub    $0x8,%eax
  800762:	8b 50 04             	mov    0x4(%eax),%edx
  800765:	8b 00                	mov    (%eax),%eax
  800767:	eb 38                	jmp    8007a1 <getint+0x5d>
	else if (lflag)
  800769:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80076d:	74 1a                	je     800789 <getint+0x45>
		return va_arg(*ap, long);
  80076f:	8b 45 08             	mov    0x8(%ebp),%eax
  800772:	8b 00                	mov    (%eax),%eax
  800774:	8d 50 04             	lea    0x4(%eax),%edx
  800777:	8b 45 08             	mov    0x8(%ebp),%eax
  80077a:	89 10                	mov    %edx,(%eax)
  80077c:	8b 45 08             	mov    0x8(%ebp),%eax
  80077f:	8b 00                	mov    (%eax),%eax
  800781:	83 e8 04             	sub    $0x4,%eax
  800784:	8b 00                	mov    (%eax),%eax
  800786:	99                   	cltd   
  800787:	eb 18                	jmp    8007a1 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800789:	8b 45 08             	mov    0x8(%ebp),%eax
  80078c:	8b 00                	mov    (%eax),%eax
  80078e:	8d 50 04             	lea    0x4(%eax),%edx
  800791:	8b 45 08             	mov    0x8(%ebp),%eax
  800794:	89 10                	mov    %edx,(%eax)
  800796:	8b 45 08             	mov    0x8(%ebp),%eax
  800799:	8b 00                	mov    (%eax),%eax
  80079b:	83 e8 04             	sub    $0x4,%eax
  80079e:	8b 00                	mov    (%eax),%eax
  8007a0:	99                   	cltd   
}
  8007a1:	5d                   	pop    %ebp
  8007a2:	c3                   	ret    

008007a3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007a3:	55                   	push   %ebp
  8007a4:	89 e5                	mov    %esp,%ebp
  8007a6:	56                   	push   %esi
  8007a7:	53                   	push   %ebx
  8007a8:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007ab:	eb 17                	jmp    8007c4 <vprintfmt+0x21>
			if (ch == '\0')
  8007ad:	85 db                	test   %ebx,%ebx
  8007af:	0f 84 af 03 00 00    	je     800b64 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8007b5:	83 ec 08             	sub    $0x8,%esp
  8007b8:	ff 75 0c             	pushl  0xc(%ebp)
  8007bb:	53                   	push   %ebx
  8007bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bf:	ff d0                	call   *%eax
  8007c1:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8007c7:	8d 50 01             	lea    0x1(%eax),%edx
  8007ca:	89 55 10             	mov    %edx,0x10(%ebp)
  8007cd:	8a 00                	mov    (%eax),%al
  8007cf:	0f b6 d8             	movzbl %al,%ebx
  8007d2:	83 fb 25             	cmp    $0x25,%ebx
  8007d5:	75 d6                	jne    8007ad <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007d7:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007db:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007e2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007e9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007f0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8007fa:	8d 50 01             	lea    0x1(%eax),%edx
  8007fd:	89 55 10             	mov    %edx,0x10(%ebp)
  800800:	8a 00                	mov    (%eax),%al
  800802:	0f b6 d8             	movzbl %al,%ebx
  800805:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800808:	83 f8 55             	cmp    $0x55,%eax
  80080b:	0f 87 2b 03 00 00    	ja     800b3c <vprintfmt+0x399>
  800811:	8b 04 85 38 39 80 00 	mov    0x803938(,%eax,4),%eax
  800818:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80081a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80081e:	eb d7                	jmp    8007f7 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800820:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800824:	eb d1                	jmp    8007f7 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800826:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80082d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800830:	89 d0                	mov    %edx,%eax
  800832:	c1 e0 02             	shl    $0x2,%eax
  800835:	01 d0                	add    %edx,%eax
  800837:	01 c0                	add    %eax,%eax
  800839:	01 d8                	add    %ebx,%eax
  80083b:	83 e8 30             	sub    $0x30,%eax
  80083e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800841:	8b 45 10             	mov    0x10(%ebp),%eax
  800844:	8a 00                	mov    (%eax),%al
  800846:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800849:	83 fb 2f             	cmp    $0x2f,%ebx
  80084c:	7e 3e                	jle    80088c <vprintfmt+0xe9>
  80084e:	83 fb 39             	cmp    $0x39,%ebx
  800851:	7f 39                	jg     80088c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800853:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800856:	eb d5                	jmp    80082d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800858:	8b 45 14             	mov    0x14(%ebp),%eax
  80085b:	83 c0 04             	add    $0x4,%eax
  80085e:	89 45 14             	mov    %eax,0x14(%ebp)
  800861:	8b 45 14             	mov    0x14(%ebp),%eax
  800864:	83 e8 04             	sub    $0x4,%eax
  800867:	8b 00                	mov    (%eax),%eax
  800869:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80086c:	eb 1f                	jmp    80088d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80086e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800872:	79 83                	jns    8007f7 <vprintfmt+0x54>
				width = 0;
  800874:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80087b:	e9 77 ff ff ff       	jmp    8007f7 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800880:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800887:	e9 6b ff ff ff       	jmp    8007f7 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80088c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80088d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800891:	0f 89 60 ff ff ff    	jns    8007f7 <vprintfmt+0x54>
				width = precision, precision = -1;
  800897:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80089a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80089d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008a4:	e9 4e ff ff ff       	jmp    8007f7 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008a9:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008ac:	e9 46 ff ff ff       	jmp    8007f7 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b4:	83 c0 04             	add    $0x4,%eax
  8008b7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bd:	83 e8 04             	sub    $0x4,%eax
  8008c0:	8b 00                	mov    (%eax),%eax
  8008c2:	83 ec 08             	sub    $0x8,%esp
  8008c5:	ff 75 0c             	pushl  0xc(%ebp)
  8008c8:	50                   	push   %eax
  8008c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cc:	ff d0                	call   *%eax
  8008ce:	83 c4 10             	add    $0x10,%esp
			break;
  8008d1:	e9 89 02 00 00       	jmp    800b5f <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d9:	83 c0 04             	add    $0x4,%eax
  8008dc:	89 45 14             	mov    %eax,0x14(%ebp)
  8008df:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e2:	83 e8 04             	sub    $0x4,%eax
  8008e5:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008e7:	85 db                	test   %ebx,%ebx
  8008e9:	79 02                	jns    8008ed <vprintfmt+0x14a>
				err = -err;
  8008eb:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008ed:	83 fb 64             	cmp    $0x64,%ebx
  8008f0:	7f 0b                	jg     8008fd <vprintfmt+0x15a>
  8008f2:	8b 34 9d 80 37 80 00 	mov    0x803780(,%ebx,4),%esi
  8008f9:	85 f6                	test   %esi,%esi
  8008fb:	75 19                	jne    800916 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008fd:	53                   	push   %ebx
  8008fe:	68 25 39 80 00       	push   $0x803925
  800903:	ff 75 0c             	pushl  0xc(%ebp)
  800906:	ff 75 08             	pushl  0x8(%ebp)
  800909:	e8 5e 02 00 00       	call   800b6c <printfmt>
  80090e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800911:	e9 49 02 00 00       	jmp    800b5f <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800916:	56                   	push   %esi
  800917:	68 2e 39 80 00       	push   $0x80392e
  80091c:	ff 75 0c             	pushl  0xc(%ebp)
  80091f:	ff 75 08             	pushl  0x8(%ebp)
  800922:	e8 45 02 00 00       	call   800b6c <printfmt>
  800927:	83 c4 10             	add    $0x10,%esp
			break;
  80092a:	e9 30 02 00 00       	jmp    800b5f <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80092f:	8b 45 14             	mov    0x14(%ebp),%eax
  800932:	83 c0 04             	add    $0x4,%eax
  800935:	89 45 14             	mov    %eax,0x14(%ebp)
  800938:	8b 45 14             	mov    0x14(%ebp),%eax
  80093b:	83 e8 04             	sub    $0x4,%eax
  80093e:	8b 30                	mov    (%eax),%esi
  800940:	85 f6                	test   %esi,%esi
  800942:	75 05                	jne    800949 <vprintfmt+0x1a6>
				p = "(null)";
  800944:	be 31 39 80 00       	mov    $0x803931,%esi
			if (width > 0 && padc != '-')
  800949:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80094d:	7e 6d                	jle    8009bc <vprintfmt+0x219>
  80094f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800953:	74 67                	je     8009bc <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800955:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800958:	83 ec 08             	sub    $0x8,%esp
  80095b:	50                   	push   %eax
  80095c:	56                   	push   %esi
  80095d:	e8 0c 03 00 00       	call   800c6e <strnlen>
  800962:	83 c4 10             	add    $0x10,%esp
  800965:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800968:	eb 16                	jmp    800980 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80096a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80096e:	83 ec 08             	sub    $0x8,%esp
  800971:	ff 75 0c             	pushl  0xc(%ebp)
  800974:	50                   	push   %eax
  800975:	8b 45 08             	mov    0x8(%ebp),%eax
  800978:	ff d0                	call   *%eax
  80097a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80097d:	ff 4d e4             	decl   -0x1c(%ebp)
  800980:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800984:	7f e4                	jg     80096a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800986:	eb 34                	jmp    8009bc <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800988:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80098c:	74 1c                	je     8009aa <vprintfmt+0x207>
  80098e:	83 fb 1f             	cmp    $0x1f,%ebx
  800991:	7e 05                	jle    800998 <vprintfmt+0x1f5>
  800993:	83 fb 7e             	cmp    $0x7e,%ebx
  800996:	7e 12                	jle    8009aa <vprintfmt+0x207>
					putch('?', putdat);
  800998:	83 ec 08             	sub    $0x8,%esp
  80099b:	ff 75 0c             	pushl  0xc(%ebp)
  80099e:	6a 3f                	push   $0x3f
  8009a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a3:	ff d0                	call   *%eax
  8009a5:	83 c4 10             	add    $0x10,%esp
  8009a8:	eb 0f                	jmp    8009b9 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009aa:	83 ec 08             	sub    $0x8,%esp
  8009ad:	ff 75 0c             	pushl  0xc(%ebp)
  8009b0:	53                   	push   %ebx
  8009b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b4:	ff d0                	call   *%eax
  8009b6:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009b9:	ff 4d e4             	decl   -0x1c(%ebp)
  8009bc:	89 f0                	mov    %esi,%eax
  8009be:	8d 70 01             	lea    0x1(%eax),%esi
  8009c1:	8a 00                	mov    (%eax),%al
  8009c3:	0f be d8             	movsbl %al,%ebx
  8009c6:	85 db                	test   %ebx,%ebx
  8009c8:	74 24                	je     8009ee <vprintfmt+0x24b>
  8009ca:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009ce:	78 b8                	js     800988 <vprintfmt+0x1e5>
  8009d0:	ff 4d e0             	decl   -0x20(%ebp)
  8009d3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009d7:	79 af                	jns    800988 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009d9:	eb 13                	jmp    8009ee <vprintfmt+0x24b>
				putch(' ', putdat);
  8009db:	83 ec 08             	sub    $0x8,%esp
  8009de:	ff 75 0c             	pushl  0xc(%ebp)
  8009e1:	6a 20                	push   $0x20
  8009e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e6:	ff d0                	call   *%eax
  8009e8:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009eb:	ff 4d e4             	decl   -0x1c(%ebp)
  8009ee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009f2:	7f e7                	jg     8009db <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009f4:	e9 66 01 00 00       	jmp    800b5f <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009f9:	83 ec 08             	sub    $0x8,%esp
  8009fc:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ff:	8d 45 14             	lea    0x14(%ebp),%eax
  800a02:	50                   	push   %eax
  800a03:	e8 3c fd ff ff       	call   800744 <getint>
  800a08:	83 c4 10             	add    $0x10,%esp
  800a0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a0e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a17:	85 d2                	test   %edx,%edx
  800a19:	79 23                	jns    800a3e <vprintfmt+0x29b>
				putch('-', putdat);
  800a1b:	83 ec 08             	sub    $0x8,%esp
  800a1e:	ff 75 0c             	pushl  0xc(%ebp)
  800a21:	6a 2d                	push   $0x2d
  800a23:	8b 45 08             	mov    0x8(%ebp),%eax
  800a26:	ff d0                	call   *%eax
  800a28:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a31:	f7 d8                	neg    %eax
  800a33:	83 d2 00             	adc    $0x0,%edx
  800a36:	f7 da                	neg    %edx
  800a38:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a3b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a3e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a45:	e9 bc 00 00 00       	jmp    800b06 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a4a:	83 ec 08             	sub    $0x8,%esp
  800a4d:	ff 75 e8             	pushl  -0x18(%ebp)
  800a50:	8d 45 14             	lea    0x14(%ebp),%eax
  800a53:	50                   	push   %eax
  800a54:	e8 84 fc ff ff       	call   8006dd <getuint>
  800a59:	83 c4 10             	add    $0x10,%esp
  800a5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a5f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a62:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a69:	e9 98 00 00 00       	jmp    800b06 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a6e:	83 ec 08             	sub    $0x8,%esp
  800a71:	ff 75 0c             	pushl  0xc(%ebp)
  800a74:	6a 58                	push   $0x58
  800a76:	8b 45 08             	mov    0x8(%ebp),%eax
  800a79:	ff d0                	call   *%eax
  800a7b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a7e:	83 ec 08             	sub    $0x8,%esp
  800a81:	ff 75 0c             	pushl  0xc(%ebp)
  800a84:	6a 58                	push   $0x58
  800a86:	8b 45 08             	mov    0x8(%ebp),%eax
  800a89:	ff d0                	call   *%eax
  800a8b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a8e:	83 ec 08             	sub    $0x8,%esp
  800a91:	ff 75 0c             	pushl  0xc(%ebp)
  800a94:	6a 58                	push   $0x58
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	ff d0                	call   *%eax
  800a9b:	83 c4 10             	add    $0x10,%esp
			break;
  800a9e:	e9 bc 00 00 00       	jmp    800b5f <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800aa3:	83 ec 08             	sub    $0x8,%esp
  800aa6:	ff 75 0c             	pushl  0xc(%ebp)
  800aa9:	6a 30                	push   $0x30
  800aab:	8b 45 08             	mov    0x8(%ebp),%eax
  800aae:	ff d0                	call   *%eax
  800ab0:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ab3:	83 ec 08             	sub    $0x8,%esp
  800ab6:	ff 75 0c             	pushl  0xc(%ebp)
  800ab9:	6a 78                	push   $0x78
  800abb:	8b 45 08             	mov    0x8(%ebp),%eax
  800abe:	ff d0                	call   *%eax
  800ac0:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ac3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac6:	83 c0 04             	add    $0x4,%eax
  800ac9:	89 45 14             	mov    %eax,0x14(%ebp)
  800acc:	8b 45 14             	mov    0x14(%ebp),%eax
  800acf:	83 e8 04             	sub    $0x4,%eax
  800ad2:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ad4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ad7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ade:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ae5:	eb 1f                	jmp    800b06 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ae7:	83 ec 08             	sub    $0x8,%esp
  800aea:	ff 75 e8             	pushl  -0x18(%ebp)
  800aed:	8d 45 14             	lea    0x14(%ebp),%eax
  800af0:	50                   	push   %eax
  800af1:	e8 e7 fb ff ff       	call   8006dd <getuint>
  800af6:	83 c4 10             	add    $0x10,%esp
  800af9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800afc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800aff:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b06:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b0d:	83 ec 04             	sub    $0x4,%esp
  800b10:	52                   	push   %edx
  800b11:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b14:	50                   	push   %eax
  800b15:	ff 75 f4             	pushl  -0xc(%ebp)
  800b18:	ff 75 f0             	pushl  -0x10(%ebp)
  800b1b:	ff 75 0c             	pushl  0xc(%ebp)
  800b1e:	ff 75 08             	pushl  0x8(%ebp)
  800b21:	e8 00 fb ff ff       	call   800626 <printnum>
  800b26:	83 c4 20             	add    $0x20,%esp
			break;
  800b29:	eb 34                	jmp    800b5f <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b2b:	83 ec 08             	sub    $0x8,%esp
  800b2e:	ff 75 0c             	pushl  0xc(%ebp)
  800b31:	53                   	push   %ebx
  800b32:	8b 45 08             	mov    0x8(%ebp),%eax
  800b35:	ff d0                	call   *%eax
  800b37:	83 c4 10             	add    $0x10,%esp
			break;
  800b3a:	eb 23                	jmp    800b5f <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b3c:	83 ec 08             	sub    $0x8,%esp
  800b3f:	ff 75 0c             	pushl  0xc(%ebp)
  800b42:	6a 25                	push   $0x25
  800b44:	8b 45 08             	mov    0x8(%ebp),%eax
  800b47:	ff d0                	call   *%eax
  800b49:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b4c:	ff 4d 10             	decl   0x10(%ebp)
  800b4f:	eb 03                	jmp    800b54 <vprintfmt+0x3b1>
  800b51:	ff 4d 10             	decl   0x10(%ebp)
  800b54:	8b 45 10             	mov    0x10(%ebp),%eax
  800b57:	48                   	dec    %eax
  800b58:	8a 00                	mov    (%eax),%al
  800b5a:	3c 25                	cmp    $0x25,%al
  800b5c:	75 f3                	jne    800b51 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b5e:	90                   	nop
		}
	}
  800b5f:	e9 47 fc ff ff       	jmp    8007ab <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b64:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b65:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b68:	5b                   	pop    %ebx
  800b69:	5e                   	pop    %esi
  800b6a:	5d                   	pop    %ebp
  800b6b:	c3                   	ret    

00800b6c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b6c:	55                   	push   %ebp
  800b6d:	89 e5                	mov    %esp,%ebp
  800b6f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b72:	8d 45 10             	lea    0x10(%ebp),%eax
  800b75:	83 c0 04             	add    $0x4,%eax
  800b78:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b7e:	ff 75 f4             	pushl  -0xc(%ebp)
  800b81:	50                   	push   %eax
  800b82:	ff 75 0c             	pushl  0xc(%ebp)
  800b85:	ff 75 08             	pushl  0x8(%ebp)
  800b88:	e8 16 fc ff ff       	call   8007a3 <vprintfmt>
  800b8d:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b90:	90                   	nop
  800b91:	c9                   	leave  
  800b92:	c3                   	ret    

00800b93 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b93:	55                   	push   %ebp
  800b94:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b99:	8b 40 08             	mov    0x8(%eax),%eax
  800b9c:	8d 50 01             	lea    0x1(%eax),%edx
  800b9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba2:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800ba5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba8:	8b 10                	mov    (%eax),%edx
  800baa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bad:	8b 40 04             	mov    0x4(%eax),%eax
  800bb0:	39 c2                	cmp    %eax,%edx
  800bb2:	73 12                	jae    800bc6 <sprintputch+0x33>
		*b->buf++ = ch;
  800bb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb7:	8b 00                	mov    (%eax),%eax
  800bb9:	8d 48 01             	lea    0x1(%eax),%ecx
  800bbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bbf:	89 0a                	mov    %ecx,(%edx)
  800bc1:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc4:	88 10                	mov    %dl,(%eax)
}
  800bc6:	90                   	nop
  800bc7:	5d                   	pop    %ebp
  800bc8:	c3                   	ret    

00800bc9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bc9:	55                   	push   %ebp
  800bca:	89 e5                	mov    %esp,%ebp
  800bcc:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	01 d0                	add    %edx,%eax
  800be0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bee:	74 06                	je     800bf6 <vsnprintf+0x2d>
  800bf0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf4:	7f 07                	jg     800bfd <vsnprintf+0x34>
		return -E_INVAL;
  800bf6:	b8 03 00 00 00       	mov    $0x3,%eax
  800bfb:	eb 20                	jmp    800c1d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bfd:	ff 75 14             	pushl  0x14(%ebp)
  800c00:	ff 75 10             	pushl  0x10(%ebp)
  800c03:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c06:	50                   	push   %eax
  800c07:	68 93 0b 80 00       	push   $0x800b93
  800c0c:	e8 92 fb ff ff       	call   8007a3 <vprintfmt>
  800c11:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c17:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c1d:	c9                   	leave  
  800c1e:	c3                   	ret    

00800c1f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c25:	8d 45 10             	lea    0x10(%ebp),%eax
  800c28:	83 c0 04             	add    $0x4,%eax
  800c2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c31:	ff 75 f4             	pushl  -0xc(%ebp)
  800c34:	50                   	push   %eax
  800c35:	ff 75 0c             	pushl  0xc(%ebp)
  800c38:	ff 75 08             	pushl  0x8(%ebp)
  800c3b:	e8 89 ff ff ff       	call   800bc9 <vsnprintf>
  800c40:	83 c4 10             	add    $0x10,%esp
  800c43:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c46:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c49:	c9                   	leave  
  800c4a:	c3                   	ret    

00800c4b <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
  800c4e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c58:	eb 06                	jmp    800c60 <strlen+0x15>
		n++;
  800c5a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c5d:	ff 45 08             	incl   0x8(%ebp)
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	8a 00                	mov    (%eax),%al
  800c65:	84 c0                	test   %al,%al
  800c67:	75 f1                	jne    800c5a <strlen+0xf>
		n++;
	return n;
  800c69:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c6c:	c9                   	leave  
  800c6d:	c3                   	ret    

00800c6e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c74:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c7b:	eb 09                	jmp    800c86 <strnlen+0x18>
		n++;
  800c7d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c80:	ff 45 08             	incl   0x8(%ebp)
  800c83:	ff 4d 0c             	decl   0xc(%ebp)
  800c86:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c8a:	74 09                	je     800c95 <strnlen+0x27>
  800c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8f:	8a 00                	mov    (%eax),%al
  800c91:	84 c0                	test   %al,%al
  800c93:	75 e8                	jne    800c7d <strnlen+0xf>
		n++;
	return n;
  800c95:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c98:	c9                   	leave  
  800c99:	c3                   	ret    

00800c9a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c9a:	55                   	push   %ebp
  800c9b:	89 e5                	mov    %esp,%ebp
  800c9d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ca6:	90                   	nop
  800ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  800caa:	8d 50 01             	lea    0x1(%eax),%edx
  800cad:	89 55 08             	mov    %edx,0x8(%ebp)
  800cb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cb6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cb9:	8a 12                	mov    (%edx),%dl
  800cbb:	88 10                	mov    %dl,(%eax)
  800cbd:	8a 00                	mov    (%eax),%al
  800cbf:	84 c0                	test   %al,%al
  800cc1:	75 e4                	jne    800ca7 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cc6:	c9                   	leave  
  800cc7:	c3                   	ret    

00800cc8 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cc8:	55                   	push   %ebp
  800cc9:	89 e5                	mov    %esp,%ebp
  800ccb:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cd4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cdb:	eb 1f                	jmp    800cfc <strncpy+0x34>
		*dst++ = *src;
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	8d 50 01             	lea    0x1(%eax),%edx
  800ce3:	89 55 08             	mov    %edx,0x8(%ebp)
  800ce6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce9:	8a 12                	mov    (%edx),%dl
  800ceb:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ced:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf0:	8a 00                	mov    (%eax),%al
  800cf2:	84 c0                	test   %al,%al
  800cf4:	74 03                	je     800cf9 <strncpy+0x31>
			src++;
  800cf6:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cf9:	ff 45 fc             	incl   -0x4(%ebp)
  800cfc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cff:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d02:	72 d9                	jb     800cdd <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d04:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d07:	c9                   	leave  
  800d08:	c3                   	ret    

00800d09 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d09:	55                   	push   %ebp
  800d0a:	89 e5                	mov    %esp,%ebp
  800d0c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d12:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d15:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d19:	74 30                	je     800d4b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d1b:	eb 16                	jmp    800d33 <strlcpy+0x2a>
			*dst++ = *src++;
  800d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d20:	8d 50 01             	lea    0x1(%eax),%edx
  800d23:	89 55 08             	mov    %edx,0x8(%ebp)
  800d26:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d29:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d2c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d2f:	8a 12                	mov    (%edx),%dl
  800d31:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d33:	ff 4d 10             	decl   0x10(%ebp)
  800d36:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d3a:	74 09                	je     800d45 <strlcpy+0x3c>
  800d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3f:	8a 00                	mov    (%eax),%al
  800d41:	84 c0                	test   %al,%al
  800d43:	75 d8                	jne    800d1d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d51:	29 c2                	sub    %eax,%edx
  800d53:	89 d0                	mov    %edx,%eax
}
  800d55:	c9                   	leave  
  800d56:	c3                   	ret    

00800d57 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d57:	55                   	push   %ebp
  800d58:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d5a:	eb 06                	jmp    800d62 <strcmp+0xb>
		p++, q++;
  800d5c:	ff 45 08             	incl   0x8(%ebp)
  800d5f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	8a 00                	mov    (%eax),%al
  800d67:	84 c0                	test   %al,%al
  800d69:	74 0e                	je     800d79 <strcmp+0x22>
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	8a 10                	mov    (%eax),%dl
  800d70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d73:	8a 00                	mov    (%eax),%al
  800d75:	38 c2                	cmp    %al,%dl
  800d77:	74 e3                	je     800d5c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d79:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7c:	8a 00                	mov    (%eax),%al
  800d7e:	0f b6 d0             	movzbl %al,%edx
  800d81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d84:	8a 00                	mov    (%eax),%al
  800d86:	0f b6 c0             	movzbl %al,%eax
  800d89:	29 c2                	sub    %eax,%edx
  800d8b:	89 d0                	mov    %edx,%eax
}
  800d8d:	5d                   	pop    %ebp
  800d8e:	c3                   	ret    

00800d8f <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d8f:	55                   	push   %ebp
  800d90:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d92:	eb 09                	jmp    800d9d <strncmp+0xe>
		n--, p++, q++;
  800d94:	ff 4d 10             	decl   0x10(%ebp)
  800d97:	ff 45 08             	incl   0x8(%ebp)
  800d9a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d9d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da1:	74 17                	je     800dba <strncmp+0x2b>
  800da3:	8b 45 08             	mov    0x8(%ebp),%eax
  800da6:	8a 00                	mov    (%eax),%al
  800da8:	84 c0                	test   %al,%al
  800daa:	74 0e                	je     800dba <strncmp+0x2b>
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	8a 10                	mov    (%eax),%dl
  800db1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db4:	8a 00                	mov    (%eax),%al
  800db6:	38 c2                	cmp    %al,%dl
  800db8:	74 da                	je     800d94 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dbe:	75 07                	jne    800dc7 <strncmp+0x38>
		return 0;
  800dc0:	b8 00 00 00 00       	mov    $0x0,%eax
  800dc5:	eb 14                	jmp    800ddb <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dca:	8a 00                	mov    (%eax),%al
  800dcc:	0f b6 d0             	movzbl %al,%edx
  800dcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd2:	8a 00                	mov    (%eax),%al
  800dd4:	0f b6 c0             	movzbl %al,%eax
  800dd7:	29 c2                	sub    %eax,%edx
  800dd9:	89 d0                	mov    %edx,%eax
}
  800ddb:	5d                   	pop    %ebp
  800ddc:	c3                   	ret    

00800ddd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	83 ec 04             	sub    $0x4,%esp
  800de3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800de9:	eb 12                	jmp    800dfd <strchr+0x20>
		if (*s == c)
  800deb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dee:	8a 00                	mov    (%eax),%al
  800df0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800df3:	75 05                	jne    800dfa <strchr+0x1d>
			return (char *) s;
  800df5:	8b 45 08             	mov    0x8(%ebp),%eax
  800df8:	eb 11                	jmp    800e0b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dfa:	ff 45 08             	incl   0x8(%ebp)
  800dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800e00:	8a 00                	mov    (%eax),%al
  800e02:	84 c0                	test   %al,%al
  800e04:	75 e5                	jne    800deb <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e0b:	c9                   	leave  
  800e0c:	c3                   	ret    

00800e0d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	83 ec 04             	sub    $0x4,%esp
  800e13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e16:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e19:	eb 0d                	jmp    800e28 <strfind+0x1b>
		if (*s == c)
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	8a 00                	mov    (%eax),%al
  800e20:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e23:	74 0e                	je     800e33 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e25:	ff 45 08             	incl   0x8(%ebp)
  800e28:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2b:	8a 00                	mov    (%eax),%al
  800e2d:	84 c0                	test   %al,%al
  800e2f:	75 ea                	jne    800e1b <strfind+0xe>
  800e31:	eb 01                	jmp    800e34 <strfind+0x27>
		if (*s == c)
			break;
  800e33:	90                   	nop
	return (char *) s;
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e37:	c9                   	leave  
  800e38:	c3                   	ret    

00800e39 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e39:	55                   	push   %ebp
  800e3a:	89 e5                	mov    %esp,%ebp
  800e3c:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e42:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e45:	8b 45 10             	mov    0x10(%ebp),%eax
  800e48:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e4b:	eb 0e                	jmp    800e5b <memset+0x22>
		*p++ = c;
  800e4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e50:	8d 50 01             	lea    0x1(%eax),%edx
  800e53:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e56:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e59:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e5b:	ff 4d f8             	decl   -0x8(%ebp)
  800e5e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e62:	79 e9                	jns    800e4d <memset+0x14>
		*p++ = c;

	return v;
  800e64:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e67:	c9                   	leave  
  800e68:	c3                   	ret    

00800e69 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e69:	55                   	push   %ebp
  800e6a:	89 e5                	mov    %esp,%ebp
  800e6c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e72:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e7b:	eb 16                	jmp    800e93 <memcpy+0x2a>
		*d++ = *s++;
  800e7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e80:	8d 50 01             	lea    0x1(%eax),%edx
  800e83:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e86:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e89:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e8c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e8f:	8a 12                	mov    (%edx),%dl
  800e91:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e93:	8b 45 10             	mov    0x10(%ebp),%eax
  800e96:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e99:	89 55 10             	mov    %edx,0x10(%ebp)
  800e9c:	85 c0                	test   %eax,%eax
  800e9e:	75 dd                	jne    800e7d <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ea0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ea3:	c9                   	leave  
  800ea4:	c3                   	ret    

00800ea5 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ea5:	55                   	push   %ebp
  800ea6:	89 e5                	mov    %esp,%ebp
  800ea8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800eab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800eb7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eba:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ebd:	73 50                	jae    800f0f <memmove+0x6a>
  800ebf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ec2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec5:	01 d0                	add    %edx,%eax
  800ec7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800eca:	76 43                	jbe    800f0f <memmove+0x6a>
		s += n;
  800ecc:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecf:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ed2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed5:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ed8:	eb 10                	jmp    800eea <memmove+0x45>
			*--d = *--s;
  800eda:	ff 4d f8             	decl   -0x8(%ebp)
  800edd:	ff 4d fc             	decl   -0x4(%ebp)
  800ee0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee3:	8a 10                	mov    (%eax),%dl
  800ee5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee8:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800eea:	8b 45 10             	mov    0x10(%ebp),%eax
  800eed:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ef0:	89 55 10             	mov    %edx,0x10(%ebp)
  800ef3:	85 c0                	test   %eax,%eax
  800ef5:	75 e3                	jne    800eda <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ef7:	eb 23                	jmp    800f1c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ef9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800efc:	8d 50 01             	lea    0x1(%eax),%edx
  800eff:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f02:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f05:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f08:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f0b:	8a 12                	mov    (%edx),%dl
  800f0d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f0f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f12:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f15:	89 55 10             	mov    %edx,0x10(%ebp)
  800f18:	85 c0                	test   %eax,%eax
  800f1a:	75 dd                	jne    800ef9 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f1f:	c9                   	leave  
  800f20:	c3                   	ret    

00800f21 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f21:	55                   	push   %ebp
  800f22:	89 e5                	mov    %esp,%ebp
  800f24:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f30:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f33:	eb 2a                	jmp    800f5f <memcmp+0x3e>
		if (*s1 != *s2)
  800f35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f38:	8a 10                	mov    (%eax),%dl
  800f3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3d:	8a 00                	mov    (%eax),%al
  800f3f:	38 c2                	cmp    %al,%dl
  800f41:	74 16                	je     800f59 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f43:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	0f b6 d0             	movzbl %al,%edx
  800f4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f4e:	8a 00                	mov    (%eax),%al
  800f50:	0f b6 c0             	movzbl %al,%eax
  800f53:	29 c2                	sub    %eax,%edx
  800f55:	89 d0                	mov    %edx,%eax
  800f57:	eb 18                	jmp    800f71 <memcmp+0x50>
		s1++, s2++;
  800f59:	ff 45 fc             	incl   -0x4(%ebp)
  800f5c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f5f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f62:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f65:	89 55 10             	mov    %edx,0x10(%ebp)
  800f68:	85 c0                	test   %eax,%eax
  800f6a:	75 c9                	jne    800f35 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f71:	c9                   	leave  
  800f72:	c3                   	ret    

00800f73 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f73:	55                   	push   %ebp
  800f74:	89 e5                	mov    %esp,%ebp
  800f76:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f79:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7f:	01 d0                	add    %edx,%eax
  800f81:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f84:	eb 15                	jmp    800f9b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f86:	8b 45 08             	mov    0x8(%ebp),%eax
  800f89:	8a 00                	mov    (%eax),%al
  800f8b:	0f b6 d0             	movzbl %al,%edx
  800f8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f91:	0f b6 c0             	movzbl %al,%eax
  800f94:	39 c2                	cmp    %eax,%edx
  800f96:	74 0d                	je     800fa5 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f98:	ff 45 08             	incl   0x8(%ebp)
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fa1:	72 e3                	jb     800f86 <memfind+0x13>
  800fa3:	eb 01                	jmp    800fa6 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fa5:	90                   	nop
	return (void *) s;
  800fa6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fa9:	c9                   	leave  
  800faa:	c3                   	ret    

00800fab <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fab:	55                   	push   %ebp
  800fac:	89 e5                	mov    %esp,%ebp
  800fae:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fb1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fb8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fbf:	eb 03                	jmp    800fc4 <strtol+0x19>
		s++;
  800fc1:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc7:	8a 00                	mov    (%eax),%al
  800fc9:	3c 20                	cmp    $0x20,%al
  800fcb:	74 f4                	je     800fc1 <strtol+0x16>
  800fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd0:	8a 00                	mov    (%eax),%al
  800fd2:	3c 09                	cmp    $0x9,%al
  800fd4:	74 eb                	je     800fc1 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd9:	8a 00                	mov    (%eax),%al
  800fdb:	3c 2b                	cmp    $0x2b,%al
  800fdd:	75 05                	jne    800fe4 <strtol+0x39>
		s++;
  800fdf:	ff 45 08             	incl   0x8(%ebp)
  800fe2:	eb 13                	jmp    800ff7 <strtol+0x4c>
	else if (*s == '-')
  800fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe7:	8a 00                	mov    (%eax),%al
  800fe9:	3c 2d                	cmp    $0x2d,%al
  800feb:	75 0a                	jne    800ff7 <strtol+0x4c>
		s++, neg = 1;
  800fed:	ff 45 08             	incl   0x8(%ebp)
  800ff0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ff7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ffb:	74 06                	je     801003 <strtol+0x58>
  800ffd:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801001:	75 20                	jne    801023 <strtol+0x78>
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
  801006:	8a 00                	mov    (%eax),%al
  801008:	3c 30                	cmp    $0x30,%al
  80100a:	75 17                	jne    801023 <strtol+0x78>
  80100c:	8b 45 08             	mov    0x8(%ebp),%eax
  80100f:	40                   	inc    %eax
  801010:	8a 00                	mov    (%eax),%al
  801012:	3c 78                	cmp    $0x78,%al
  801014:	75 0d                	jne    801023 <strtol+0x78>
		s += 2, base = 16;
  801016:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80101a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801021:	eb 28                	jmp    80104b <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801023:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801027:	75 15                	jne    80103e <strtol+0x93>
  801029:	8b 45 08             	mov    0x8(%ebp),%eax
  80102c:	8a 00                	mov    (%eax),%al
  80102e:	3c 30                	cmp    $0x30,%al
  801030:	75 0c                	jne    80103e <strtol+0x93>
		s++, base = 8;
  801032:	ff 45 08             	incl   0x8(%ebp)
  801035:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80103c:	eb 0d                	jmp    80104b <strtol+0xa0>
	else if (base == 0)
  80103e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801042:	75 07                	jne    80104b <strtol+0xa0>
		base = 10;
  801044:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	8a 00                	mov    (%eax),%al
  801050:	3c 2f                	cmp    $0x2f,%al
  801052:	7e 19                	jle    80106d <strtol+0xc2>
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	8a 00                	mov    (%eax),%al
  801059:	3c 39                	cmp    $0x39,%al
  80105b:	7f 10                	jg     80106d <strtol+0xc2>
			dig = *s - '0';
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	8a 00                	mov    (%eax),%al
  801062:	0f be c0             	movsbl %al,%eax
  801065:	83 e8 30             	sub    $0x30,%eax
  801068:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80106b:	eb 42                	jmp    8010af <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	8a 00                	mov    (%eax),%al
  801072:	3c 60                	cmp    $0x60,%al
  801074:	7e 19                	jle    80108f <strtol+0xe4>
  801076:	8b 45 08             	mov    0x8(%ebp),%eax
  801079:	8a 00                	mov    (%eax),%al
  80107b:	3c 7a                	cmp    $0x7a,%al
  80107d:	7f 10                	jg     80108f <strtol+0xe4>
			dig = *s - 'a' + 10;
  80107f:	8b 45 08             	mov    0x8(%ebp),%eax
  801082:	8a 00                	mov    (%eax),%al
  801084:	0f be c0             	movsbl %al,%eax
  801087:	83 e8 57             	sub    $0x57,%eax
  80108a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80108d:	eb 20                	jmp    8010af <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80108f:	8b 45 08             	mov    0x8(%ebp),%eax
  801092:	8a 00                	mov    (%eax),%al
  801094:	3c 40                	cmp    $0x40,%al
  801096:	7e 39                	jle    8010d1 <strtol+0x126>
  801098:	8b 45 08             	mov    0x8(%ebp),%eax
  80109b:	8a 00                	mov    (%eax),%al
  80109d:	3c 5a                	cmp    $0x5a,%al
  80109f:	7f 30                	jg     8010d1 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a4:	8a 00                	mov    (%eax),%al
  8010a6:	0f be c0             	movsbl %al,%eax
  8010a9:	83 e8 37             	sub    $0x37,%eax
  8010ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010b2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010b5:	7d 19                	jge    8010d0 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010b7:	ff 45 08             	incl   0x8(%ebp)
  8010ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010bd:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010c1:	89 c2                	mov    %eax,%edx
  8010c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010c6:	01 d0                	add    %edx,%eax
  8010c8:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010cb:	e9 7b ff ff ff       	jmp    80104b <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010d0:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010d1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010d5:	74 08                	je     8010df <strtol+0x134>
		*endptr = (char *) s;
  8010d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010da:	8b 55 08             	mov    0x8(%ebp),%edx
  8010dd:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010df:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010e3:	74 07                	je     8010ec <strtol+0x141>
  8010e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e8:	f7 d8                	neg    %eax
  8010ea:	eb 03                	jmp    8010ef <strtol+0x144>
  8010ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010ef:	c9                   	leave  
  8010f0:	c3                   	ret    

008010f1 <ltostr>:

void
ltostr(long value, char *str)
{
  8010f1:	55                   	push   %ebp
  8010f2:	89 e5                	mov    %esp,%ebp
  8010f4:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010fe:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801105:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801109:	79 13                	jns    80111e <ltostr+0x2d>
	{
		neg = 1;
  80110b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801112:	8b 45 0c             	mov    0xc(%ebp),%eax
  801115:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801118:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80111b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80111e:	8b 45 08             	mov    0x8(%ebp),%eax
  801121:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801126:	99                   	cltd   
  801127:	f7 f9                	idiv   %ecx
  801129:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80112c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80112f:	8d 50 01             	lea    0x1(%eax),%edx
  801132:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801135:	89 c2                	mov    %eax,%edx
  801137:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113a:	01 d0                	add    %edx,%eax
  80113c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80113f:	83 c2 30             	add    $0x30,%edx
  801142:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801144:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801147:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80114c:	f7 e9                	imul   %ecx
  80114e:	c1 fa 02             	sar    $0x2,%edx
  801151:	89 c8                	mov    %ecx,%eax
  801153:	c1 f8 1f             	sar    $0x1f,%eax
  801156:	29 c2                	sub    %eax,%edx
  801158:	89 d0                	mov    %edx,%eax
  80115a:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80115d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801160:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801165:	f7 e9                	imul   %ecx
  801167:	c1 fa 02             	sar    $0x2,%edx
  80116a:	89 c8                	mov    %ecx,%eax
  80116c:	c1 f8 1f             	sar    $0x1f,%eax
  80116f:	29 c2                	sub    %eax,%edx
  801171:	89 d0                	mov    %edx,%eax
  801173:	c1 e0 02             	shl    $0x2,%eax
  801176:	01 d0                	add    %edx,%eax
  801178:	01 c0                	add    %eax,%eax
  80117a:	29 c1                	sub    %eax,%ecx
  80117c:	89 ca                	mov    %ecx,%edx
  80117e:	85 d2                	test   %edx,%edx
  801180:	75 9c                	jne    80111e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801182:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801189:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80118c:	48                   	dec    %eax
  80118d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801190:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801194:	74 3d                	je     8011d3 <ltostr+0xe2>
		start = 1 ;
  801196:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80119d:	eb 34                	jmp    8011d3 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80119f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a5:	01 d0                	add    %edx,%eax
  8011a7:	8a 00                	mov    (%eax),%al
  8011a9:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b2:	01 c2                	add    %eax,%edx
  8011b4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ba:	01 c8                	add    %ecx,%eax
  8011bc:	8a 00                	mov    (%eax),%al
  8011be:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c6:	01 c2                	add    %eax,%edx
  8011c8:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011cb:	88 02                	mov    %al,(%edx)
		start++ ;
  8011cd:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011d0:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011d6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011d9:	7c c4                	jl     80119f <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011db:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e1:	01 d0                	add    %edx,%eax
  8011e3:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011e6:	90                   	nop
  8011e7:	c9                   	leave  
  8011e8:	c3                   	ret    

008011e9 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011e9:	55                   	push   %ebp
  8011ea:	89 e5                	mov    %esp,%ebp
  8011ec:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011ef:	ff 75 08             	pushl  0x8(%ebp)
  8011f2:	e8 54 fa ff ff       	call   800c4b <strlen>
  8011f7:	83 c4 04             	add    $0x4,%esp
  8011fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011fd:	ff 75 0c             	pushl  0xc(%ebp)
  801200:	e8 46 fa ff ff       	call   800c4b <strlen>
  801205:	83 c4 04             	add    $0x4,%esp
  801208:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80120b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801212:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801219:	eb 17                	jmp    801232 <strcconcat+0x49>
		final[s] = str1[s] ;
  80121b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80121e:	8b 45 10             	mov    0x10(%ebp),%eax
  801221:	01 c2                	add    %eax,%edx
  801223:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	01 c8                	add    %ecx,%eax
  80122b:	8a 00                	mov    (%eax),%al
  80122d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80122f:	ff 45 fc             	incl   -0x4(%ebp)
  801232:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801235:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801238:	7c e1                	jl     80121b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80123a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801241:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801248:	eb 1f                	jmp    801269 <strcconcat+0x80>
		final[s++] = str2[i] ;
  80124a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80124d:	8d 50 01             	lea    0x1(%eax),%edx
  801250:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801253:	89 c2                	mov    %eax,%edx
  801255:	8b 45 10             	mov    0x10(%ebp),%eax
  801258:	01 c2                	add    %eax,%edx
  80125a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80125d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801260:	01 c8                	add    %ecx,%eax
  801262:	8a 00                	mov    (%eax),%al
  801264:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801266:	ff 45 f8             	incl   -0x8(%ebp)
  801269:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80126c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80126f:	7c d9                	jl     80124a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801271:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801274:	8b 45 10             	mov    0x10(%ebp),%eax
  801277:	01 d0                	add    %edx,%eax
  801279:	c6 00 00             	movb   $0x0,(%eax)
}
  80127c:	90                   	nop
  80127d:	c9                   	leave  
  80127e:	c3                   	ret    

0080127f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80127f:	55                   	push   %ebp
  801280:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801282:	8b 45 14             	mov    0x14(%ebp),%eax
  801285:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80128b:	8b 45 14             	mov    0x14(%ebp),%eax
  80128e:	8b 00                	mov    (%eax),%eax
  801290:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801297:	8b 45 10             	mov    0x10(%ebp),%eax
  80129a:	01 d0                	add    %edx,%eax
  80129c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012a2:	eb 0c                	jmp    8012b0 <strsplit+0x31>
			*string++ = 0;
  8012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a7:	8d 50 01             	lea    0x1(%eax),%edx
  8012aa:	89 55 08             	mov    %edx,0x8(%ebp)
  8012ad:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b3:	8a 00                	mov    (%eax),%al
  8012b5:	84 c0                	test   %al,%al
  8012b7:	74 18                	je     8012d1 <strsplit+0x52>
  8012b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bc:	8a 00                	mov    (%eax),%al
  8012be:	0f be c0             	movsbl %al,%eax
  8012c1:	50                   	push   %eax
  8012c2:	ff 75 0c             	pushl  0xc(%ebp)
  8012c5:	e8 13 fb ff ff       	call   800ddd <strchr>
  8012ca:	83 c4 08             	add    $0x8,%esp
  8012cd:	85 c0                	test   %eax,%eax
  8012cf:	75 d3                	jne    8012a4 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d4:	8a 00                	mov    (%eax),%al
  8012d6:	84 c0                	test   %al,%al
  8012d8:	74 5a                	je     801334 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012da:	8b 45 14             	mov    0x14(%ebp),%eax
  8012dd:	8b 00                	mov    (%eax),%eax
  8012df:	83 f8 0f             	cmp    $0xf,%eax
  8012e2:	75 07                	jne    8012eb <strsplit+0x6c>
		{
			return 0;
  8012e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8012e9:	eb 66                	jmp    801351 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ee:	8b 00                	mov    (%eax),%eax
  8012f0:	8d 48 01             	lea    0x1(%eax),%ecx
  8012f3:	8b 55 14             	mov    0x14(%ebp),%edx
  8012f6:	89 0a                	mov    %ecx,(%edx)
  8012f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801302:	01 c2                	add    %eax,%edx
  801304:	8b 45 08             	mov    0x8(%ebp),%eax
  801307:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801309:	eb 03                	jmp    80130e <strsplit+0x8f>
			string++;
  80130b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	8a 00                	mov    (%eax),%al
  801313:	84 c0                	test   %al,%al
  801315:	74 8b                	je     8012a2 <strsplit+0x23>
  801317:	8b 45 08             	mov    0x8(%ebp),%eax
  80131a:	8a 00                	mov    (%eax),%al
  80131c:	0f be c0             	movsbl %al,%eax
  80131f:	50                   	push   %eax
  801320:	ff 75 0c             	pushl  0xc(%ebp)
  801323:	e8 b5 fa ff ff       	call   800ddd <strchr>
  801328:	83 c4 08             	add    $0x8,%esp
  80132b:	85 c0                	test   %eax,%eax
  80132d:	74 dc                	je     80130b <strsplit+0x8c>
			string++;
	}
  80132f:	e9 6e ff ff ff       	jmp    8012a2 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801334:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801335:	8b 45 14             	mov    0x14(%ebp),%eax
  801338:	8b 00                	mov    (%eax),%eax
  80133a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801341:	8b 45 10             	mov    0x10(%ebp),%eax
  801344:	01 d0                	add    %edx,%eax
  801346:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80134c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801351:	c9                   	leave  
  801352:	c3                   	ret    

00801353 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801353:	55                   	push   %ebp
  801354:	89 e5                	mov    %esp,%ebp
  801356:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801359:	a1 04 40 80 00       	mov    0x804004,%eax
  80135e:	85 c0                	test   %eax,%eax
  801360:	74 1f                	je     801381 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801362:	e8 1d 00 00 00       	call   801384 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801367:	83 ec 0c             	sub    $0xc,%esp
  80136a:	68 90 3a 80 00       	push   $0x803a90
  80136f:	e8 55 f2 ff ff       	call   8005c9 <cprintf>
  801374:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801377:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80137e:	00 00 00 
	}
}
  801381:	90                   	nop
  801382:	c9                   	leave  
  801383:	c3                   	ret    

00801384 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801384:	55                   	push   %ebp
  801385:	89 e5                	mov    %esp,%ebp
  801387:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  80138a:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801391:	00 00 00 
  801394:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80139b:	00 00 00 
  80139e:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  8013a5:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  8013a8:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8013af:	00 00 00 
  8013b2:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  8013b9:	00 00 00 
  8013bc:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  8013c3:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  8013c6:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8013cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013d0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013d5:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013da:	a3 50 40 80 00       	mov    %eax,0x804050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  8013df:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  8013e6:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  8013e9:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8013f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013f3:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  8013f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8013fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013fe:	ba 00 00 00 00       	mov    $0x0,%edx
  801403:	f7 75 f0             	divl   -0x10(%ebp)
  801406:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801409:	29 d0                	sub    %edx,%eax
  80140b:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  80140e:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801415:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801418:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80141d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801422:	83 ec 04             	sub    $0x4,%esp
  801425:	6a 06                	push   $0x6
  801427:	ff 75 e8             	pushl  -0x18(%ebp)
  80142a:	50                   	push   %eax
  80142b:	e8 d4 05 00 00       	call   801a04 <sys_allocate_chunk>
  801430:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801433:	a1 20 41 80 00       	mov    0x804120,%eax
  801438:	83 ec 0c             	sub    $0xc,%esp
  80143b:	50                   	push   %eax
  80143c:	e8 49 0c 00 00       	call   80208a <initialize_MemBlocksList>
  801441:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  801444:	a1 48 41 80 00       	mov    0x804148,%eax
  801449:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  80144c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801450:	75 14                	jne    801466 <initialize_dyn_block_system+0xe2>
  801452:	83 ec 04             	sub    $0x4,%esp
  801455:	68 b5 3a 80 00       	push   $0x803ab5
  80145a:	6a 39                	push   $0x39
  80145c:	68 d3 3a 80 00       	push   $0x803ad3
  801461:	e8 af ee ff ff       	call   800315 <_panic>
  801466:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801469:	8b 00                	mov    (%eax),%eax
  80146b:	85 c0                	test   %eax,%eax
  80146d:	74 10                	je     80147f <initialize_dyn_block_system+0xfb>
  80146f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801472:	8b 00                	mov    (%eax),%eax
  801474:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801477:	8b 52 04             	mov    0x4(%edx),%edx
  80147a:	89 50 04             	mov    %edx,0x4(%eax)
  80147d:	eb 0b                	jmp    80148a <initialize_dyn_block_system+0x106>
  80147f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801482:	8b 40 04             	mov    0x4(%eax),%eax
  801485:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80148a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80148d:	8b 40 04             	mov    0x4(%eax),%eax
  801490:	85 c0                	test   %eax,%eax
  801492:	74 0f                	je     8014a3 <initialize_dyn_block_system+0x11f>
  801494:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801497:	8b 40 04             	mov    0x4(%eax),%eax
  80149a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80149d:	8b 12                	mov    (%edx),%edx
  80149f:	89 10                	mov    %edx,(%eax)
  8014a1:	eb 0a                	jmp    8014ad <initialize_dyn_block_system+0x129>
  8014a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014a6:	8b 00                	mov    (%eax),%eax
  8014a8:	a3 48 41 80 00       	mov    %eax,0x804148
  8014ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8014b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014c0:	a1 54 41 80 00       	mov    0x804154,%eax
  8014c5:	48                   	dec    %eax
  8014c6:	a3 54 41 80 00       	mov    %eax,0x804154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  8014cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014ce:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  8014d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014d8:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  8014df:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014e3:	75 14                	jne    8014f9 <initialize_dyn_block_system+0x175>
  8014e5:	83 ec 04             	sub    $0x4,%esp
  8014e8:	68 e0 3a 80 00       	push   $0x803ae0
  8014ed:	6a 3f                	push   $0x3f
  8014ef:	68 d3 3a 80 00       	push   $0x803ad3
  8014f4:	e8 1c ee ff ff       	call   800315 <_panic>
  8014f9:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8014ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801502:	89 10                	mov    %edx,(%eax)
  801504:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801507:	8b 00                	mov    (%eax),%eax
  801509:	85 c0                	test   %eax,%eax
  80150b:	74 0d                	je     80151a <initialize_dyn_block_system+0x196>
  80150d:	a1 38 41 80 00       	mov    0x804138,%eax
  801512:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801515:	89 50 04             	mov    %edx,0x4(%eax)
  801518:	eb 08                	jmp    801522 <initialize_dyn_block_system+0x19e>
  80151a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80151d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  801522:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801525:	a3 38 41 80 00       	mov    %eax,0x804138
  80152a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80152d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801534:	a1 44 41 80 00       	mov    0x804144,%eax
  801539:	40                   	inc    %eax
  80153a:	a3 44 41 80 00       	mov    %eax,0x804144

}
  80153f:	90                   	nop
  801540:	c9                   	leave  
  801541:	c3                   	ret    

00801542 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801542:	55                   	push   %ebp
  801543:	89 e5                	mov    %esp,%ebp
  801545:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801548:	e8 06 fe ff ff       	call   801353 <InitializeUHeap>
	if (size == 0) return NULL ;
  80154d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801551:	75 07                	jne    80155a <malloc+0x18>
  801553:	b8 00 00 00 00       	mov    $0x0,%eax
  801558:	eb 7d                	jmp    8015d7 <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  80155a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801561:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801568:	8b 55 08             	mov    0x8(%ebp),%edx
  80156b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80156e:	01 d0                	add    %edx,%eax
  801570:	48                   	dec    %eax
  801571:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801574:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801577:	ba 00 00 00 00       	mov    $0x0,%edx
  80157c:	f7 75 f0             	divl   -0x10(%ebp)
  80157f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801582:	29 d0                	sub    %edx,%eax
  801584:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  801587:	e8 46 08 00 00       	call   801dd2 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80158c:	83 f8 01             	cmp    $0x1,%eax
  80158f:	75 07                	jne    801598 <malloc+0x56>
  801591:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  801598:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  80159c:	75 34                	jne    8015d2 <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  80159e:	83 ec 0c             	sub    $0xc,%esp
  8015a1:	ff 75 e8             	pushl  -0x18(%ebp)
  8015a4:	e8 73 0e 00 00       	call   80241c <alloc_block_FF>
  8015a9:	83 c4 10             	add    $0x10,%esp
  8015ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  8015af:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8015b3:	74 16                	je     8015cb <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  8015b5:	83 ec 0c             	sub    $0xc,%esp
  8015b8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015bb:	e8 ff 0b 00 00       	call   8021bf <insert_sorted_allocList>
  8015c0:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  8015c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015c6:	8b 40 08             	mov    0x8(%eax),%eax
  8015c9:	eb 0c                	jmp    8015d7 <malloc+0x95>
	             }
	             else
	             	return NULL;
  8015cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d0:	eb 05                	jmp    8015d7 <malloc+0x95>
	      	  }
	          else
	               return NULL;
  8015d2:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  8015d7:	c9                   	leave  
  8015d8:	c3                   	ret    

008015d9 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8015d9:	55                   	push   %ebp
  8015da:	89 e5                	mov    %esp,%ebp
  8015dc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  8015df:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e2:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  8015e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ee:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015f3:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  8015f6:	83 ec 08             	sub    $0x8,%esp
  8015f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8015fc:	68 40 40 80 00       	push   $0x804040
  801601:	e8 61 0b 00 00       	call   802167 <find_block>
  801606:	83 c4 10             	add    $0x10,%esp
  801609:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  80160c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801610:	0f 84 a5 00 00 00    	je     8016bb <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  801616:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801619:	8b 40 0c             	mov    0xc(%eax),%eax
  80161c:	83 ec 08             	sub    $0x8,%esp
  80161f:	50                   	push   %eax
  801620:	ff 75 f4             	pushl  -0xc(%ebp)
  801623:	e8 a4 03 00 00       	call   8019cc <sys_free_user_mem>
  801628:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  80162b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80162f:	75 17                	jne    801648 <free+0x6f>
  801631:	83 ec 04             	sub    $0x4,%esp
  801634:	68 b5 3a 80 00       	push   $0x803ab5
  801639:	68 87 00 00 00       	push   $0x87
  80163e:	68 d3 3a 80 00       	push   $0x803ad3
  801643:	e8 cd ec ff ff       	call   800315 <_panic>
  801648:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80164b:	8b 00                	mov    (%eax),%eax
  80164d:	85 c0                	test   %eax,%eax
  80164f:	74 10                	je     801661 <free+0x88>
  801651:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801654:	8b 00                	mov    (%eax),%eax
  801656:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801659:	8b 52 04             	mov    0x4(%edx),%edx
  80165c:	89 50 04             	mov    %edx,0x4(%eax)
  80165f:	eb 0b                	jmp    80166c <free+0x93>
  801661:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801664:	8b 40 04             	mov    0x4(%eax),%eax
  801667:	a3 44 40 80 00       	mov    %eax,0x804044
  80166c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80166f:	8b 40 04             	mov    0x4(%eax),%eax
  801672:	85 c0                	test   %eax,%eax
  801674:	74 0f                	je     801685 <free+0xac>
  801676:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801679:	8b 40 04             	mov    0x4(%eax),%eax
  80167c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80167f:	8b 12                	mov    (%edx),%edx
  801681:	89 10                	mov    %edx,(%eax)
  801683:	eb 0a                	jmp    80168f <free+0xb6>
  801685:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801688:	8b 00                	mov    (%eax),%eax
  80168a:	a3 40 40 80 00       	mov    %eax,0x804040
  80168f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801692:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801698:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80169b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016a2:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8016a7:	48                   	dec    %eax
  8016a8:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(theBlock);
  8016ad:	83 ec 0c             	sub    $0xc,%esp
  8016b0:	ff 75 ec             	pushl  -0x14(%ebp)
  8016b3:	e8 37 12 00 00       	call   8028ef <insert_sorted_with_merge_freeList>
  8016b8:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  8016bb:	90                   	nop
  8016bc:	c9                   	leave  
  8016bd:	c3                   	ret    

008016be <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
  8016c1:	83 ec 38             	sub    $0x38,%esp
  8016c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c7:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016ca:	e8 84 fc ff ff       	call   801353 <InitializeUHeap>
	if (size == 0) return NULL ;
  8016cf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016d3:	75 07                	jne    8016dc <smalloc+0x1e>
  8016d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8016da:	eb 7e                	jmp    80175a <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  8016dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8016e3:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8016ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f0:	01 d0                	add    %edx,%eax
  8016f2:	48                   	dec    %eax
  8016f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8016fe:	f7 75 f0             	divl   -0x10(%ebp)
  801701:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801704:	29 d0                	sub    %edx,%eax
  801706:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801709:	e8 c4 06 00 00       	call   801dd2 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80170e:	83 f8 01             	cmp    $0x1,%eax
  801711:	75 42                	jne    801755 <smalloc+0x97>

		  va = malloc(newsize) ;
  801713:	83 ec 0c             	sub    $0xc,%esp
  801716:	ff 75 e8             	pushl  -0x18(%ebp)
  801719:	e8 24 fe ff ff       	call   801542 <malloc>
  80171e:	83 c4 10             	add    $0x10,%esp
  801721:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  801724:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801728:	74 24                	je     80174e <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  80172a:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80172e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801731:	50                   	push   %eax
  801732:	ff 75 e8             	pushl  -0x18(%ebp)
  801735:	ff 75 08             	pushl  0x8(%ebp)
  801738:	e8 1a 04 00 00       	call   801b57 <sys_createSharedObject>
  80173d:	83 c4 10             	add    $0x10,%esp
  801740:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  801743:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801747:	78 0c                	js     801755 <smalloc+0x97>
					  return va ;
  801749:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80174c:	eb 0c                	jmp    80175a <smalloc+0x9c>
				 }
				 else
					return NULL;
  80174e:	b8 00 00 00 00       	mov    $0x0,%eax
  801753:	eb 05                	jmp    80175a <smalloc+0x9c>
	  }
		  return NULL ;
  801755:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80175a:	c9                   	leave  
  80175b:	c3                   	ret    

0080175c <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
  80175f:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801762:	e8 ec fb ff ff       	call   801353 <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  801767:	83 ec 08             	sub    $0x8,%esp
  80176a:	ff 75 0c             	pushl  0xc(%ebp)
  80176d:	ff 75 08             	pushl  0x8(%ebp)
  801770:	e8 0c 04 00 00       	call   801b81 <sys_getSizeOfSharedObject>
  801775:	83 c4 10             	add    $0x10,%esp
  801778:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  80177b:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  80177f:	75 07                	jne    801788 <sget+0x2c>
  801781:	b8 00 00 00 00       	mov    $0x0,%eax
  801786:	eb 75                	jmp    8017fd <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801788:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80178f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801792:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801795:	01 d0                	add    %edx,%eax
  801797:	48                   	dec    %eax
  801798:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80179b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80179e:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a3:	f7 75 f0             	divl   -0x10(%ebp)
  8017a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017a9:	29 d0                	sub    %edx,%eax
  8017ab:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  8017ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  8017b5:	e8 18 06 00 00       	call   801dd2 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017ba:	83 f8 01             	cmp    $0x1,%eax
  8017bd:	75 39                	jne    8017f8 <sget+0x9c>

		  va = malloc(newsize) ;
  8017bf:	83 ec 0c             	sub    $0xc,%esp
  8017c2:	ff 75 e8             	pushl  -0x18(%ebp)
  8017c5:	e8 78 fd ff ff       	call   801542 <malloc>
  8017ca:	83 c4 10             	add    $0x10,%esp
  8017cd:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  8017d0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8017d4:	74 22                	je     8017f8 <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  8017d6:	83 ec 04             	sub    $0x4,%esp
  8017d9:	ff 75 e0             	pushl  -0x20(%ebp)
  8017dc:	ff 75 0c             	pushl  0xc(%ebp)
  8017df:	ff 75 08             	pushl  0x8(%ebp)
  8017e2:	e8 b7 03 00 00       	call   801b9e <sys_getSharedObject>
  8017e7:	83 c4 10             	add    $0x10,%esp
  8017ea:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  8017ed:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8017f1:	78 05                	js     8017f8 <sget+0x9c>
					  return va;
  8017f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017f6:	eb 05                	jmp    8017fd <sget+0xa1>
				  }
			  }
     }
         return NULL;
  8017f8:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  8017fd:	c9                   	leave  
  8017fe:	c3                   	ret    

008017ff <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
  801802:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801805:	e8 49 fb ff ff       	call   801353 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80180a:	83 ec 04             	sub    $0x4,%esp
  80180d:	68 04 3b 80 00       	push   $0x803b04
  801812:	68 1e 01 00 00       	push   $0x11e
  801817:	68 d3 3a 80 00       	push   $0x803ad3
  80181c:	e8 f4 ea ff ff       	call   800315 <_panic>

00801821 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801821:	55                   	push   %ebp
  801822:	89 e5                	mov    %esp,%ebp
  801824:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801827:	83 ec 04             	sub    $0x4,%esp
  80182a:	68 2c 3b 80 00       	push   $0x803b2c
  80182f:	68 32 01 00 00       	push   $0x132
  801834:	68 d3 3a 80 00       	push   $0x803ad3
  801839:	e8 d7 ea ff ff       	call   800315 <_panic>

0080183e <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80183e:	55                   	push   %ebp
  80183f:	89 e5                	mov    %esp,%ebp
  801841:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801844:	83 ec 04             	sub    $0x4,%esp
  801847:	68 50 3b 80 00       	push   $0x803b50
  80184c:	68 3d 01 00 00       	push   $0x13d
  801851:	68 d3 3a 80 00       	push   $0x803ad3
  801856:	e8 ba ea ff ff       	call   800315 <_panic>

0080185b <shrink>:

}
void shrink(uint32 newSize)
{
  80185b:	55                   	push   %ebp
  80185c:	89 e5                	mov    %esp,%ebp
  80185e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801861:	83 ec 04             	sub    $0x4,%esp
  801864:	68 50 3b 80 00       	push   $0x803b50
  801869:	68 42 01 00 00       	push   $0x142
  80186e:	68 d3 3a 80 00       	push   $0x803ad3
  801873:	e8 9d ea ff ff       	call   800315 <_panic>

00801878 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801878:	55                   	push   %ebp
  801879:	89 e5                	mov    %esp,%ebp
  80187b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80187e:	83 ec 04             	sub    $0x4,%esp
  801881:	68 50 3b 80 00       	push   $0x803b50
  801886:	68 47 01 00 00       	push   $0x147
  80188b:	68 d3 3a 80 00       	push   $0x803ad3
  801890:	e8 80 ea ff ff       	call   800315 <_panic>

00801895 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801895:	55                   	push   %ebp
  801896:	89 e5                	mov    %esp,%ebp
  801898:	57                   	push   %edi
  801899:	56                   	push   %esi
  80189a:	53                   	push   %ebx
  80189b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80189e:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018a7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018aa:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018ad:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018b0:	cd 30                	int    $0x30
  8018b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018b8:	83 c4 10             	add    $0x10,%esp
  8018bb:	5b                   	pop    %ebx
  8018bc:	5e                   	pop    %esi
  8018bd:	5f                   	pop    %edi
  8018be:	5d                   	pop    %ebp
  8018bf:	c3                   	ret    

008018c0 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
  8018c3:	83 ec 04             	sub    $0x4,%esp
  8018c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018cc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	52                   	push   %edx
  8018d8:	ff 75 0c             	pushl  0xc(%ebp)
  8018db:	50                   	push   %eax
  8018dc:	6a 00                	push   $0x0
  8018de:	e8 b2 ff ff ff       	call   801895 <syscall>
  8018e3:	83 c4 18             	add    $0x18,%esp
}
  8018e6:	90                   	nop
  8018e7:	c9                   	leave  
  8018e8:	c3                   	ret    

008018e9 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 01                	push   $0x1
  8018f8:	e8 98 ff ff ff       	call   801895 <syscall>
  8018fd:	83 c4 18             	add    $0x18,%esp
}
  801900:	c9                   	leave  
  801901:	c3                   	ret    

00801902 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801905:	8b 55 0c             	mov    0xc(%ebp),%edx
  801908:	8b 45 08             	mov    0x8(%ebp),%eax
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	52                   	push   %edx
  801912:	50                   	push   %eax
  801913:	6a 05                	push   $0x5
  801915:	e8 7b ff ff ff       	call   801895 <syscall>
  80191a:	83 c4 18             	add    $0x18,%esp
}
  80191d:	c9                   	leave  
  80191e:	c3                   	ret    

0080191f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80191f:	55                   	push   %ebp
  801920:	89 e5                	mov    %esp,%ebp
  801922:	56                   	push   %esi
  801923:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801924:	8b 75 18             	mov    0x18(%ebp),%esi
  801927:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80192a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80192d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801930:	8b 45 08             	mov    0x8(%ebp),%eax
  801933:	56                   	push   %esi
  801934:	53                   	push   %ebx
  801935:	51                   	push   %ecx
  801936:	52                   	push   %edx
  801937:	50                   	push   %eax
  801938:	6a 06                	push   $0x6
  80193a:	e8 56 ff ff ff       	call   801895 <syscall>
  80193f:	83 c4 18             	add    $0x18,%esp
}
  801942:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801945:	5b                   	pop    %ebx
  801946:	5e                   	pop    %esi
  801947:	5d                   	pop    %ebp
  801948:	c3                   	ret    

00801949 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801949:	55                   	push   %ebp
  80194a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80194c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194f:	8b 45 08             	mov    0x8(%ebp),%eax
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	52                   	push   %edx
  801959:	50                   	push   %eax
  80195a:	6a 07                	push   $0x7
  80195c:	e8 34 ff ff ff       	call   801895 <syscall>
  801961:	83 c4 18             	add    $0x18,%esp
}
  801964:	c9                   	leave  
  801965:	c3                   	ret    

00801966 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801966:	55                   	push   %ebp
  801967:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	ff 75 0c             	pushl  0xc(%ebp)
  801972:	ff 75 08             	pushl  0x8(%ebp)
  801975:	6a 08                	push   $0x8
  801977:	e8 19 ff ff ff       	call   801895 <syscall>
  80197c:	83 c4 18             	add    $0x18,%esp
}
  80197f:	c9                   	leave  
  801980:	c3                   	ret    

00801981 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801981:	55                   	push   %ebp
  801982:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 09                	push   $0x9
  801990:	e8 00 ff ff ff       	call   801895 <syscall>
  801995:	83 c4 18             	add    $0x18,%esp
}
  801998:	c9                   	leave  
  801999:	c3                   	ret    

0080199a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 0a                	push   $0xa
  8019a9:	e8 e7 fe ff ff       	call   801895 <syscall>
  8019ae:	83 c4 18             	add    $0x18,%esp
}
  8019b1:	c9                   	leave  
  8019b2:	c3                   	ret    

008019b3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019b3:	55                   	push   %ebp
  8019b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 0b                	push   $0xb
  8019c2:	e8 ce fe ff ff       	call   801895 <syscall>
  8019c7:	83 c4 18             	add    $0x18,%esp
}
  8019ca:	c9                   	leave  
  8019cb:	c3                   	ret    

008019cc <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	ff 75 0c             	pushl  0xc(%ebp)
  8019d8:	ff 75 08             	pushl  0x8(%ebp)
  8019db:	6a 0f                	push   $0xf
  8019dd:	e8 b3 fe ff ff       	call   801895 <syscall>
  8019e2:	83 c4 18             	add    $0x18,%esp
	return;
  8019e5:	90                   	nop
}
  8019e6:	c9                   	leave  
  8019e7:	c3                   	ret    

008019e8 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019e8:	55                   	push   %ebp
  8019e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	ff 75 0c             	pushl  0xc(%ebp)
  8019f4:	ff 75 08             	pushl  0x8(%ebp)
  8019f7:	6a 10                	push   $0x10
  8019f9:	e8 97 fe ff ff       	call   801895 <syscall>
  8019fe:	83 c4 18             	add    $0x18,%esp
	return ;
  801a01:	90                   	nop
}
  801a02:	c9                   	leave  
  801a03:	c3                   	ret    

00801a04 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a04:	55                   	push   %ebp
  801a05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	ff 75 10             	pushl  0x10(%ebp)
  801a0e:	ff 75 0c             	pushl  0xc(%ebp)
  801a11:	ff 75 08             	pushl  0x8(%ebp)
  801a14:	6a 11                	push   $0x11
  801a16:	e8 7a fe ff ff       	call   801895 <syscall>
  801a1b:	83 c4 18             	add    $0x18,%esp
	return ;
  801a1e:	90                   	nop
}
  801a1f:	c9                   	leave  
  801a20:	c3                   	ret    

00801a21 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a21:	55                   	push   %ebp
  801a22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 0c                	push   $0xc
  801a30:	e8 60 fe ff ff       	call   801895 <syscall>
  801a35:	83 c4 18             	add    $0x18,%esp
}
  801a38:	c9                   	leave  
  801a39:	c3                   	ret    

00801a3a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	ff 75 08             	pushl  0x8(%ebp)
  801a48:	6a 0d                	push   $0xd
  801a4a:	e8 46 fe ff ff       	call   801895 <syscall>
  801a4f:	83 c4 18             	add    $0x18,%esp
}
  801a52:	c9                   	leave  
  801a53:	c3                   	ret    

00801a54 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a54:	55                   	push   %ebp
  801a55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 0e                	push   $0xe
  801a63:	e8 2d fe ff ff       	call   801895 <syscall>
  801a68:	83 c4 18             	add    $0x18,%esp
}
  801a6b:	90                   	nop
  801a6c:	c9                   	leave  
  801a6d:	c3                   	ret    

00801a6e <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 13                	push   $0x13
  801a7d:	e8 13 fe ff ff       	call   801895 <syscall>
  801a82:	83 c4 18             	add    $0x18,%esp
}
  801a85:	90                   	nop
  801a86:	c9                   	leave  
  801a87:	c3                   	ret    

00801a88 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 14                	push   $0x14
  801a97:	e8 f9 fd ff ff       	call   801895 <syscall>
  801a9c:	83 c4 18             	add    $0x18,%esp
}
  801a9f:	90                   	nop
  801aa0:	c9                   	leave  
  801aa1:	c3                   	ret    

00801aa2 <sys_cputc>:


void
sys_cputc(const char c)
{
  801aa2:	55                   	push   %ebp
  801aa3:	89 e5                	mov    %esp,%ebp
  801aa5:	83 ec 04             	sub    $0x4,%esp
  801aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  801aab:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801aae:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	50                   	push   %eax
  801abb:	6a 15                	push   $0x15
  801abd:	e8 d3 fd ff ff       	call   801895 <syscall>
  801ac2:	83 c4 18             	add    $0x18,%esp
}
  801ac5:	90                   	nop
  801ac6:	c9                   	leave  
  801ac7:	c3                   	ret    

00801ac8 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ac8:	55                   	push   %ebp
  801ac9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 16                	push   $0x16
  801ad7:	e8 b9 fd ff ff       	call   801895 <syscall>
  801adc:	83 c4 18             	add    $0x18,%esp
}
  801adf:	90                   	nop
  801ae0:	c9                   	leave  
  801ae1:	c3                   	ret    

00801ae2 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	ff 75 0c             	pushl  0xc(%ebp)
  801af1:	50                   	push   %eax
  801af2:	6a 17                	push   $0x17
  801af4:	e8 9c fd ff ff       	call   801895 <syscall>
  801af9:	83 c4 18             	add    $0x18,%esp
}
  801afc:	c9                   	leave  
  801afd:	c3                   	ret    

00801afe <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801afe:	55                   	push   %ebp
  801aff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b01:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b04:	8b 45 08             	mov    0x8(%ebp),%eax
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	52                   	push   %edx
  801b0e:	50                   	push   %eax
  801b0f:	6a 1a                	push   $0x1a
  801b11:	e8 7f fd ff ff       	call   801895 <syscall>
  801b16:	83 c4 18             	add    $0x18,%esp
}
  801b19:	c9                   	leave  
  801b1a:	c3                   	ret    

00801b1b <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b1b:	55                   	push   %ebp
  801b1c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b21:	8b 45 08             	mov    0x8(%ebp),%eax
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	52                   	push   %edx
  801b2b:	50                   	push   %eax
  801b2c:	6a 18                	push   $0x18
  801b2e:	e8 62 fd ff ff       	call   801895 <syscall>
  801b33:	83 c4 18             	add    $0x18,%esp
}
  801b36:	90                   	nop
  801b37:	c9                   	leave  
  801b38:	c3                   	ret    

00801b39 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	52                   	push   %edx
  801b49:	50                   	push   %eax
  801b4a:	6a 19                	push   $0x19
  801b4c:	e8 44 fd ff ff       	call   801895 <syscall>
  801b51:	83 c4 18             	add    $0x18,%esp
}
  801b54:	90                   	nop
  801b55:	c9                   	leave  
  801b56:	c3                   	ret    

00801b57 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
  801b5a:	83 ec 04             	sub    $0x4,%esp
  801b5d:	8b 45 10             	mov    0x10(%ebp),%eax
  801b60:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b63:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b66:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6d:	6a 00                	push   $0x0
  801b6f:	51                   	push   %ecx
  801b70:	52                   	push   %edx
  801b71:	ff 75 0c             	pushl  0xc(%ebp)
  801b74:	50                   	push   %eax
  801b75:	6a 1b                	push   $0x1b
  801b77:	e8 19 fd ff ff       	call   801895 <syscall>
  801b7c:	83 c4 18             	add    $0x18,%esp
}
  801b7f:	c9                   	leave  
  801b80:	c3                   	ret    

00801b81 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b84:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b87:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	52                   	push   %edx
  801b91:	50                   	push   %eax
  801b92:	6a 1c                	push   $0x1c
  801b94:	e8 fc fc ff ff       	call   801895 <syscall>
  801b99:	83 c4 18             	add    $0x18,%esp
}
  801b9c:	c9                   	leave  
  801b9d:	c3                   	ret    

00801b9e <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b9e:	55                   	push   %ebp
  801b9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ba1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ba4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	51                   	push   %ecx
  801baf:	52                   	push   %edx
  801bb0:	50                   	push   %eax
  801bb1:	6a 1d                	push   $0x1d
  801bb3:	e8 dd fc ff ff       	call   801895 <syscall>
  801bb8:	83 c4 18             	add    $0x18,%esp
}
  801bbb:	c9                   	leave  
  801bbc:	c3                   	ret    

00801bbd <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	52                   	push   %edx
  801bcd:	50                   	push   %eax
  801bce:	6a 1e                	push   $0x1e
  801bd0:	e8 c0 fc ff ff       	call   801895 <syscall>
  801bd5:	83 c4 18             	add    $0x18,%esp
}
  801bd8:	c9                   	leave  
  801bd9:	c3                   	ret    

00801bda <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801bda:	55                   	push   %ebp
  801bdb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 1f                	push   $0x1f
  801be9:	e8 a7 fc ff ff       	call   801895 <syscall>
  801bee:	83 c4 18             	add    $0x18,%esp
}
  801bf1:	c9                   	leave  
  801bf2:	c3                   	ret    

00801bf3 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf9:	6a 00                	push   $0x0
  801bfb:	ff 75 14             	pushl  0x14(%ebp)
  801bfe:	ff 75 10             	pushl  0x10(%ebp)
  801c01:	ff 75 0c             	pushl  0xc(%ebp)
  801c04:	50                   	push   %eax
  801c05:	6a 20                	push   $0x20
  801c07:	e8 89 fc ff ff       	call   801895 <syscall>
  801c0c:	83 c4 18             	add    $0x18,%esp
}
  801c0f:	c9                   	leave  
  801c10:	c3                   	ret    

00801c11 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c11:	55                   	push   %ebp
  801c12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c14:	8b 45 08             	mov    0x8(%ebp),%eax
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	50                   	push   %eax
  801c20:	6a 21                	push   $0x21
  801c22:	e8 6e fc ff ff       	call   801895 <syscall>
  801c27:	83 c4 18             	add    $0x18,%esp
}
  801c2a:	90                   	nop
  801c2b:	c9                   	leave  
  801c2c:	c3                   	ret    

00801c2d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c2d:	55                   	push   %ebp
  801c2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c30:	8b 45 08             	mov    0x8(%ebp),%eax
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	50                   	push   %eax
  801c3c:	6a 22                	push   $0x22
  801c3e:	e8 52 fc ff ff       	call   801895 <syscall>
  801c43:	83 c4 18             	add    $0x18,%esp
}
  801c46:	c9                   	leave  
  801c47:	c3                   	ret    

00801c48 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c48:	55                   	push   %ebp
  801c49:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 02                	push   $0x2
  801c57:	e8 39 fc ff ff       	call   801895 <syscall>
  801c5c:	83 c4 18             	add    $0x18,%esp
}
  801c5f:	c9                   	leave  
  801c60:	c3                   	ret    

00801c61 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c61:	55                   	push   %ebp
  801c62:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 03                	push   $0x3
  801c70:	e8 20 fc ff ff       	call   801895 <syscall>
  801c75:	83 c4 18             	add    $0x18,%esp
}
  801c78:	c9                   	leave  
  801c79:	c3                   	ret    

00801c7a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c7a:	55                   	push   %ebp
  801c7b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 04                	push   $0x4
  801c89:	e8 07 fc ff ff       	call   801895 <syscall>
  801c8e:	83 c4 18             	add    $0x18,%esp
}
  801c91:	c9                   	leave  
  801c92:	c3                   	ret    

00801c93 <sys_exit_env>:


void sys_exit_env(void)
{
  801c93:	55                   	push   %ebp
  801c94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 23                	push   $0x23
  801ca2:	e8 ee fb ff ff       	call   801895 <syscall>
  801ca7:	83 c4 18             	add    $0x18,%esp
}
  801caa:	90                   	nop
  801cab:	c9                   	leave  
  801cac:	c3                   	ret    

00801cad <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801cad:	55                   	push   %ebp
  801cae:	89 e5                	mov    %esp,%ebp
  801cb0:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801cb3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cb6:	8d 50 04             	lea    0x4(%eax),%edx
  801cb9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	52                   	push   %edx
  801cc3:	50                   	push   %eax
  801cc4:	6a 24                	push   $0x24
  801cc6:	e8 ca fb ff ff       	call   801895 <syscall>
  801ccb:	83 c4 18             	add    $0x18,%esp
	return result;
  801cce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cd1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cd4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cd7:	89 01                	mov    %eax,(%ecx)
  801cd9:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdf:	c9                   	leave  
  801ce0:	c2 04 00             	ret    $0x4

00801ce3 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ce3:	55                   	push   %ebp
  801ce4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	ff 75 10             	pushl  0x10(%ebp)
  801ced:	ff 75 0c             	pushl  0xc(%ebp)
  801cf0:	ff 75 08             	pushl  0x8(%ebp)
  801cf3:	6a 12                	push   $0x12
  801cf5:	e8 9b fb ff ff       	call   801895 <syscall>
  801cfa:	83 c4 18             	add    $0x18,%esp
	return ;
  801cfd:	90                   	nop
}
  801cfe:	c9                   	leave  
  801cff:	c3                   	ret    

00801d00 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d00:	55                   	push   %ebp
  801d01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 25                	push   $0x25
  801d0f:	e8 81 fb ff ff       	call   801895 <syscall>
  801d14:	83 c4 18             	add    $0x18,%esp
}
  801d17:	c9                   	leave  
  801d18:	c3                   	ret    

00801d19 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d19:	55                   	push   %ebp
  801d1a:	89 e5                	mov    %esp,%ebp
  801d1c:	83 ec 04             	sub    $0x4,%esp
  801d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d22:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d25:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	50                   	push   %eax
  801d32:	6a 26                	push   $0x26
  801d34:	e8 5c fb ff ff       	call   801895 <syscall>
  801d39:	83 c4 18             	add    $0x18,%esp
	return ;
  801d3c:	90                   	nop
}
  801d3d:	c9                   	leave  
  801d3e:	c3                   	ret    

00801d3f <rsttst>:
void rsttst()
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 28                	push   $0x28
  801d4e:	e8 42 fb ff ff       	call   801895 <syscall>
  801d53:	83 c4 18             	add    $0x18,%esp
	return ;
  801d56:	90                   	nop
}
  801d57:	c9                   	leave  
  801d58:	c3                   	ret    

00801d59 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d59:	55                   	push   %ebp
  801d5a:	89 e5                	mov    %esp,%ebp
  801d5c:	83 ec 04             	sub    $0x4,%esp
  801d5f:	8b 45 14             	mov    0x14(%ebp),%eax
  801d62:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d65:	8b 55 18             	mov    0x18(%ebp),%edx
  801d68:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d6c:	52                   	push   %edx
  801d6d:	50                   	push   %eax
  801d6e:	ff 75 10             	pushl  0x10(%ebp)
  801d71:	ff 75 0c             	pushl  0xc(%ebp)
  801d74:	ff 75 08             	pushl  0x8(%ebp)
  801d77:	6a 27                	push   $0x27
  801d79:	e8 17 fb ff ff       	call   801895 <syscall>
  801d7e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d81:	90                   	nop
}
  801d82:	c9                   	leave  
  801d83:	c3                   	ret    

00801d84 <chktst>:
void chktst(uint32 n)
{
  801d84:	55                   	push   %ebp
  801d85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	ff 75 08             	pushl  0x8(%ebp)
  801d92:	6a 29                	push   $0x29
  801d94:	e8 fc fa ff ff       	call   801895 <syscall>
  801d99:	83 c4 18             	add    $0x18,%esp
	return ;
  801d9c:	90                   	nop
}
  801d9d:	c9                   	leave  
  801d9e:	c3                   	ret    

00801d9f <inctst>:

void inctst()
{
  801d9f:	55                   	push   %ebp
  801da0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	6a 2a                	push   $0x2a
  801dae:	e8 e2 fa ff ff       	call   801895 <syscall>
  801db3:	83 c4 18             	add    $0x18,%esp
	return ;
  801db6:	90                   	nop
}
  801db7:	c9                   	leave  
  801db8:	c3                   	ret    

00801db9 <gettst>:
uint32 gettst()
{
  801db9:	55                   	push   %ebp
  801dba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 2b                	push   $0x2b
  801dc8:	e8 c8 fa ff ff       	call   801895 <syscall>
  801dcd:	83 c4 18             	add    $0x18,%esp
}
  801dd0:	c9                   	leave  
  801dd1:	c3                   	ret    

00801dd2 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
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
  801de4:	e8 ac fa ff ff       	call   801895 <syscall>
  801de9:	83 c4 18             	add    $0x18,%esp
  801dec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801def:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801df3:	75 07                	jne    801dfc <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801df5:	b8 01 00 00 00       	mov    $0x1,%eax
  801dfa:	eb 05                	jmp    801e01 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801dfc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e01:	c9                   	leave  
  801e02:	c3                   	ret    

00801e03 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e03:	55                   	push   %ebp
  801e04:	89 e5                	mov    %esp,%ebp
  801e06:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 2c                	push   $0x2c
  801e15:	e8 7b fa ff ff       	call   801895 <syscall>
  801e1a:	83 c4 18             	add    $0x18,%esp
  801e1d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e20:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e24:	75 07                	jne    801e2d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e26:	b8 01 00 00 00       	mov    $0x1,%eax
  801e2b:	eb 05                	jmp    801e32 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e32:	c9                   	leave  
  801e33:	c3                   	ret    

00801e34 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e34:	55                   	push   %ebp
  801e35:	89 e5                	mov    %esp,%ebp
  801e37:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	6a 2c                	push   $0x2c
  801e46:	e8 4a fa ff ff       	call   801895 <syscall>
  801e4b:	83 c4 18             	add    $0x18,%esp
  801e4e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e51:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e55:	75 07                	jne    801e5e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e57:	b8 01 00 00 00       	mov    $0x1,%eax
  801e5c:	eb 05                	jmp    801e63 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e63:	c9                   	leave  
  801e64:	c3                   	ret    

00801e65 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e65:	55                   	push   %ebp
  801e66:	89 e5                	mov    %esp,%ebp
  801e68:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 2c                	push   $0x2c
  801e77:	e8 19 fa ff ff       	call   801895 <syscall>
  801e7c:	83 c4 18             	add    $0x18,%esp
  801e7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e82:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e86:	75 07                	jne    801e8f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e88:	b8 01 00 00 00       	mov    $0x1,%eax
  801e8d:	eb 05                	jmp    801e94 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e94:	c9                   	leave  
  801e95:	c3                   	ret    

00801e96 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e96:	55                   	push   %ebp
  801e97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	ff 75 08             	pushl  0x8(%ebp)
  801ea4:	6a 2d                	push   $0x2d
  801ea6:	e8 ea f9 ff ff       	call   801895 <syscall>
  801eab:	83 c4 18             	add    $0x18,%esp
	return ;
  801eae:	90                   	nop
}
  801eaf:	c9                   	leave  
  801eb0:	c3                   	ret    

00801eb1 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801eb1:	55                   	push   %ebp
  801eb2:	89 e5                	mov    %esp,%ebp
  801eb4:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801eb5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801eb8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ebb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec1:	6a 00                	push   $0x0
  801ec3:	53                   	push   %ebx
  801ec4:	51                   	push   %ecx
  801ec5:	52                   	push   %edx
  801ec6:	50                   	push   %eax
  801ec7:	6a 2e                	push   $0x2e
  801ec9:	e8 c7 f9 ff ff       	call   801895 <syscall>
  801ece:	83 c4 18             	add    $0x18,%esp
}
  801ed1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ed4:	c9                   	leave  
  801ed5:	c3                   	ret    

00801ed6 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ed6:	55                   	push   %ebp
  801ed7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ed9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801edc:	8b 45 08             	mov    0x8(%ebp),%eax
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	52                   	push   %edx
  801ee6:	50                   	push   %eax
  801ee7:	6a 2f                	push   $0x2f
  801ee9:	e8 a7 f9 ff ff       	call   801895 <syscall>
  801eee:	83 c4 18             	add    $0x18,%esp
}
  801ef1:	c9                   	leave  
  801ef2:	c3                   	ret    

00801ef3 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801ef3:	55                   	push   %ebp
  801ef4:	89 e5                	mov    %esp,%ebp
  801ef6:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801ef9:	83 ec 0c             	sub    $0xc,%esp
  801efc:	68 60 3b 80 00       	push   $0x803b60
  801f01:	e8 c3 e6 ff ff       	call   8005c9 <cprintf>
  801f06:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f09:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f10:	83 ec 0c             	sub    $0xc,%esp
  801f13:	68 8c 3b 80 00       	push   $0x803b8c
  801f18:	e8 ac e6 ff ff       	call   8005c9 <cprintf>
  801f1d:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f20:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f24:	a1 38 41 80 00       	mov    0x804138,%eax
  801f29:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f2c:	eb 56                	jmp    801f84 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f2e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f32:	74 1c                	je     801f50 <print_mem_block_lists+0x5d>
  801f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f37:	8b 50 08             	mov    0x8(%eax),%edx
  801f3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f3d:	8b 48 08             	mov    0x8(%eax),%ecx
  801f40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f43:	8b 40 0c             	mov    0xc(%eax),%eax
  801f46:	01 c8                	add    %ecx,%eax
  801f48:	39 c2                	cmp    %eax,%edx
  801f4a:	73 04                	jae    801f50 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f4c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f53:	8b 50 08             	mov    0x8(%eax),%edx
  801f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f59:	8b 40 0c             	mov    0xc(%eax),%eax
  801f5c:	01 c2                	add    %eax,%edx
  801f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f61:	8b 40 08             	mov    0x8(%eax),%eax
  801f64:	83 ec 04             	sub    $0x4,%esp
  801f67:	52                   	push   %edx
  801f68:	50                   	push   %eax
  801f69:	68 a1 3b 80 00       	push   $0x803ba1
  801f6e:	e8 56 e6 ff ff       	call   8005c9 <cprintf>
  801f73:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f79:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f7c:	a1 40 41 80 00       	mov    0x804140,%eax
  801f81:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f84:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f88:	74 07                	je     801f91 <print_mem_block_lists+0x9e>
  801f8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8d:	8b 00                	mov    (%eax),%eax
  801f8f:	eb 05                	jmp    801f96 <print_mem_block_lists+0xa3>
  801f91:	b8 00 00 00 00       	mov    $0x0,%eax
  801f96:	a3 40 41 80 00       	mov    %eax,0x804140
  801f9b:	a1 40 41 80 00       	mov    0x804140,%eax
  801fa0:	85 c0                	test   %eax,%eax
  801fa2:	75 8a                	jne    801f2e <print_mem_block_lists+0x3b>
  801fa4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fa8:	75 84                	jne    801f2e <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801faa:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fae:	75 10                	jne    801fc0 <print_mem_block_lists+0xcd>
  801fb0:	83 ec 0c             	sub    $0xc,%esp
  801fb3:	68 b0 3b 80 00       	push   $0x803bb0
  801fb8:	e8 0c e6 ff ff       	call   8005c9 <cprintf>
  801fbd:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801fc0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801fc7:	83 ec 0c             	sub    $0xc,%esp
  801fca:	68 d4 3b 80 00       	push   $0x803bd4
  801fcf:	e8 f5 e5 ff ff       	call   8005c9 <cprintf>
  801fd4:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801fd7:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fdb:	a1 40 40 80 00       	mov    0x804040,%eax
  801fe0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fe3:	eb 56                	jmp    80203b <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fe5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fe9:	74 1c                	je     802007 <print_mem_block_lists+0x114>
  801feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fee:	8b 50 08             	mov    0x8(%eax),%edx
  801ff1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff4:	8b 48 08             	mov    0x8(%eax),%ecx
  801ff7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ffa:	8b 40 0c             	mov    0xc(%eax),%eax
  801ffd:	01 c8                	add    %ecx,%eax
  801fff:	39 c2                	cmp    %eax,%edx
  802001:	73 04                	jae    802007 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802003:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802007:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200a:	8b 50 08             	mov    0x8(%eax),%edx
  80200d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802010:	8b 40 0c             	mov    0xc(%eax),%eax
  802013:	01 c2                	add    %eax,%edx
  802015:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802018:	8b 40 08             	mov    0x8(%eax),%eax
  80201b:	83 ec 04             	sub    $0x4,%esp
  80201e:	52                   	push   %edx
  80201f:	50                   	push   %eax
  802020:	68 a1 3b 80 00       	push   $0x803ba1
  802025:	e8 9f e5 ff ff       	call   8005c9 <cprintf>
  80202a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80202d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802030:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802033:	a1 48 40 80 00       	mov    0x804048,%eax
  802038:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80203b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80203f:	74 07                	je     802048 <print_mem_block_lists+0x155>
  802041:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802044:	8b 00                	mov    (%eax),%eax
  802046:	eb 05                	jmp    80204d <print_mem_block_lists+0x15a>
  802048:	b8 00 00 00 00       	mov    $0x0,%eax
  80204d:	a3 48 40 80 00       	mov    %eax,0x804048
  802052:	a1 48 40 80 00       	mov    0x804048,%eax
  802057:	85 c0                	test   %eax,%eax
  802059:	75 8a                	jne    801fe5 <print_mem_block_lists+0xf2>
  80205b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80205f:	75 84                	jne    801fe5 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802061:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802065:	75 10                	jne    802077 <print_mem_block_lists+0x184>
  802067:	83 ec 0c             	sub    $0xc,%esp
  80206a:	68 ec 3b 80 00       	push   $0x803bec
  80206f:	e8 55 e5 ff ff       	call   8005c9 <cprintf>
  802074:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802077:	83 ec 0c             	sub    $0xc,%esp
  80207a:	68 60 3b 80 00       	push   $0x803b60
  80207f:	e8 45 e5 ff ff       	call   8005c9 <cprintf>
  802084:	83 c4 10             	add    $0x10,%esp

}
  802087:	90                   	nop
  802088:	c9                   	leave  
  802089:	c3                   	ret    

0080208a <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80208a:	55                   	push   %ebp
  80208b:	89 e5                	mov    %esp,%ebp
  80208d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  802090:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802097:	00 00 00 
  80209a:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  8020a1:	00 00 00 
  8020a4:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  8020ab:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  8020ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8020b5:	e9 9e 00 00 00       	jmp    802158 <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  8020ba:	a1 50 40 80 00       	mov    0x804050,%eax
  8020bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020c2:	c1 e2 04             	shl    $0x4,%edx
  8020c5:	01 d0                	add    %edx,%eax
  8020c7:	85 c0                	test   %eax,%eax
  8020c9:	75 14                	jne    8020df <initialize_MemBlocksList+0x55>
  8020cb:	83 ec 04             	sub    $0x4,%esp
  8020ce:	68 14 3c 80 00       	push   $0x803c14
  8020d3:	6a 47                	push   $0x47
  8020d5:	68 37 3c 80 00       	push   $0x803c37
  8020da:	e8 36 e2 ff ff       	call   800315 <_panic>
  8020df:	a1 50 40 80 00       	mov    0x804050,%eax
  8020e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020e7:	c1 e2 04             	shl    $0x4,%edx
  8020ea:	01 d0                	add    %edx,%eax
  8020ec:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8020f2:	89 10                	mov    %edx,(%eax)
  8020f4:	8b 00                	mov    (%eax),%eax
  8020f6:	85 c0                	test   %eax,%eax
  8020f8:	74 18                	je     802112 <initialize_MemBlocksList+0x88>
  8020fa:	a1 48 41 80 00       	mov    0x804148,%eax
  8020ff:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802105:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802108:	c1 e1 04             	shl    $0x4,%ecx
  80210b:	01 ca                	add    %ecx,%edx
  80210d:	89 50 04             	mov    %edx,0x4(%eax)
  802110:	eb 12                	jmp    802124 <initialize_MemBlocksList+0x9a>
  802112:	a1 50 40 80 00       	mov    0x804050,%eax
  802117:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80211a:	c1 e2 04             	shl    $0x4,%edx
  80211d:	01 d0                	add    %edx,%eax
  80211f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802124:	a1 50 40 80 00       	mov    0x804050,%eax
  802129:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80212c:	c1 e2 04             	shl    $0x4,%edx
  80212f:	01 d0                	add    %edx,%eax
  802131:	a3 48 41 80 00       	mov    %eax,0x804148
  802136:	a1 50 40 80 00       	mov    0x804050,%eax
  80213b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80213e:	c1 e2 04             	shl    $0x4,%edx
  802141:	01 d0                	add    %edx,%eax
  802143:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80214a:	a1 54 41 80 00       	mov    0x804154,%eax
  80214f:	40                   	inc    %eax
  802150:	a3 54 41 80 00       	mov    %eax,0x804154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802155:	ff 45 f4             	incl   -0xc(%ebp)
  802158:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80215e:	0f 82 56 ff ff ff    	jb     8020ba <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  802164:	90                   	nop
  802165:	c9                   	leave  
  802166:	c3                   	ret    

00802167 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802167:	55                   	push   %ebp
  802168:	89 e5                	mov    %esp,%ebp
  80216a:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  80216d:	8b 45 08             	mov    0x8(%ebp),%eax
  802170:	8b 00                	mov    (%eax),%eax
  802172:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802175:	eb 19                	jmp    802190 <find_block+0x29>
	{
		if(element->sva == va){
  802177:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80217a:	8b 40 08             	mov    0x8(%eax),%eax
  80217d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802180:	75 05                	jne    802187 <find_block+0x20>
			 		return element;
  802182:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802185:	eb 36                	jmp    8021bd <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802187:	8b 45 08             	mov    0x8(%ebp),%eax
  80218a:	8b 40 08             	mov    0x8(%eax),%eax
  80218d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802190:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802194:	74 07                	je     80219d <find_block+0x36>
  802196:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802199:	8b 00                	mov    (%eax),%eax
  80219b:	eb 05                	jmp    8021a2 <find_block+0x3b>
  80219d:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8021a5:	89 42 08             	mov    %eax,0x8(%edx)
  8021a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ab:	8b 40 08             	mov    0x8(%eax),%eax
  8021ae:	85 c0                	test   %eax,%eax
  8021b0:	75 c5                	jne    802177 <find_block+0x10>
  8021b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021b6:	75 bf                	jne    802177 <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  8021b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021bd:	c9                   	leave  
  8021be:	c3                   	ret    

008021bf <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8021bf:	55                   	push   %ebp
  8021c0:	89 e5                	mov    %esp,%ebp
  8021c2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  8021c5:	a1 44 40 80 00       	mov    0x804044,%eax
  8021ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  8021cd:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  8021d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021d9:	74 0a                	je     8021e5 <insert_sorted_allocList+0x26>
  8021db:	8b 45 08             	mov    0x8(%ebp),%eax
  8021de:	8b 40 08             	mov    0x8(%eax),%eax
  8021e1:	85 c0                	test   %eax,%eax
  8021e3:	75 65                	jne    80224a <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8021e5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021e9:	75 14                	jne    8021ff <insert_sorted_allocList+0x40>
  8021eb:	83 ec 04             	sub    $0x4,%esp
  8021ee:	68 14 3c 80 00       	push   $0x803c14
  8021f3:	6a 6e                	push   $0x6e
  8021f5:	68 37 3c 80 00       	push   $0x803c37
  8021fa:	e8 16 e1 ff ff       	call   800315 <_panic>
  8021ff:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802205:	8b 45 08             	mov    0x8(%ebp),%eax
  802208:	89 10                	mov    %edx,(%eax)
  80220a:	8b 45 08             	mov    0x8(%ebp),%eax
  80220d:	8b 00                	mov    (%eax),%eax
  80220f:	85 c0                	test   %eax,%eax
  802211:	74 0d                	je     802220 <insert_sorted_allocList+0x61>
  802213:	a1 40 40 80 00       	mov    0x804040,%eax
  802218:	8b 55 08             	mov    0x8(%ebp),%edx
  80221b:	89 50 04             	mov    %edx,0x4(%eax)
  80221e:	eb 08                	jmp    802228 <insert_sorted_allocList+0x69>
  802220:	8b 45 08             	mov    0x8(%ebp),%eax
  802223:	a3 44 40 80 00       	mov    %eax,0x804044
  802228:	8b 45 08             	mov    0x8(%ebp),%eax
  80222b:	a3 40 40 80 00       	mov    %eax,0x804040
  802230:	8b 45 08             	mov    0x8(%ebp),%eax
  802233:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80223a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80223f:	40                   	inc    %eax
  802240:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802245:	e9 cf 01 00 00       	jmp    802419 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  80224a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80224d:	8b 50 08             	mov    0x8(%eax),%edx
  802250:	8b 45 08             	mov    0x8(%ebp),%eax
  802253:	8b 40 08             	mov    0x8(%eax),%eax
  802256:	39 c2                	cmp    %eax,%edx
  802258:	73 65                	jae    8022bf <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80225a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80225e:	75 14                	jne    802274 <insert_sorted_allocList+0xb5>
  802260:	83 ec 04             	sub    $0x4,%esp
  802263:	68 50 3c 80 00       	push   $0x803c50
  802268:	6a 72                	push   $0x72
  80226a:	68 37 3c 80 00       	push   $0x803c37
  80226f:	e8 a1 e0 ff ff       	call   800315 <_panic>
  802274:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80227a:	8b 45 08             	mov    0x8(%ebp),%eax
  80227d:	89 50 04             	mov    %edx,0x4(%eax)
  802280:	8b 45 08             	mov    0x8(%ebp),%eax
  802283:	8b 40 04             	mov    0x4(%eax),%eax
  802286:	85 c0                	test   %eax,%eax
  802288:	74 0c                	je     802296 <insert_sorted_allocList+0xd7>
  80228a:	a1 44 40 80 00       	mov    0x804044,%eax
  80228f:	8b 55 08             	mov    0x8(%ebp),%edx
  802292:	89 10                	mov    %edx,(%eax)
  802294:	eb 08                	jmp    80229e <insert_sorted_allocList+0xdf>
  802296:	8b 45 08             	mov    0x8(%ebp),%eax
  802299:	a3 40 40 80 00       	mov    %eax,0x804040
  80229e:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a1:	a3 44 40 80 00       	mov    %eax,0x804044
  8022a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022af:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022b4:	40                   	inc    %eax
  8022b5:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  8022ba:	e9 5a 01 00 00       	jmp    802419 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  8022bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c2:	8b 50 08             	mov    0x8(%eax),%edx
  8022c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c8:	8b 40 08             	mov    0x8(%eax),%eax
  8022cb:	39 c2                	cmp    %eax,%edx
  8022cd:	75 70                	jne    80233f <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  8022cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022d3:	74 06                	je     8022db <insert_sorted_allocList+0x11c>
  8022d5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022d9:	75 14                	jne    8022ef <insert_sorted_allocList+0x130>
  8022db:	83 ec 04             	sub    $0x4,%esp
  8022de:	68 74 3c 80 00       	push   $0x803c74
  8022e3:	6a 75                	push   $0x75
  8022e5:	68 37 3c 80 00       	push   $0x803c37
  8022ea:	e8 26 e0 ff ff       	call   800315 <_panic>
  8022ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f2:	8b 10                	mov    (%eax),%edx
  8022f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f7:	89 10                	mov    %edx,(%eax)
  8022f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fc:	8b 00                	mov    (%eax),%eax
  8022fe:	85 c0                	test   %eax,%eax
  802300:	74 0b                	je     80230d <insert_sorted_allocList+0x14e>
  802302:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802305:	8b 00                	mov    (%eax),%eax
  802307:	8b 55 08             	mov    0x8(%ebp),%edx
  80230a:	89 50 04             	mov    %edx,0x4(%eax)
  80230d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802310:	8b 55 08             	mov    0x8(%ebp),%edx
  802313:	89 10                	mov    %edx,(%eax)
  802315:	8b 45 08             	mov    0x8(%ebp),%eax
  802318:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80231b:	89 50 04             	mov    %edx,0x4(%eax)
  80231e:	8b 45 08             	mov    0x8(%ebp),%eax
  802321:	8b 00                	mov    (%eax),%eax
  802323:	85 c0                	test   %eax,%eax
  802325:	75 08                	jne    80232f <insert_sorted_allocList+0x170>
  802327:	8b 45 08             	mov    0x8(%ebp),%eax
  80232a:	a3 44 40 80 00       	mov    %eax,0x804044
  80232f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802334:	40                   	inc    %eax
  802335:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  80233a:	e9 da 00 00 00       	jmp    802419 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  80233f:	a1 40 40 80 00       	mov    0x804040,%eax
  802344:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802347:	e9 9d 00 00 00       	jmp    8023e9 <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  80234c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234f:	8b 00                	mov    (%eax),%eax
  802351:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  802354:	8b 45 08             	mov    0x8(%ebp),%eax
  802357:	8b 50 08             	mov    0x8(%eax),%edx
  80235a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235d:	8b 40 08             	mov    0x8(%eax),%eax
  802360:	39 c2                	cmp    %eax,%edx
  802362:	76 7d                	jbe    8023e1 <insert_sorted_allocList+0x222>
  802364:	8b 45 08             	mov    0x8(%ebp),%eax
  802367:	8b 50 08             	mov    0x8(%eax),%edx
  80236a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80236d:	8b 40 08             	mov    0x8(%eax),%eax
  802370:	39 c2                	cmp    %eax,%edx
  802372:	73 6d                	jae    8023e1 <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802374:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802378:	74 06                	je     802380 <insert_sorted_allocList+0x1c1>
  80237a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80237e:	75 14                	jne    802394 <insert_sorted_allocList+0x1d5>
  802380:	83 ec 04             	sub    $0x4,%esp
  802383:	68 74 3c 80 00       	push   $0x803c74
  802388:	6a 7c                	push   $0x7c
  80238a:	68 37 3c 80 00       	push   $0x803c37
  80238f:	e8 81 df ff ff       	call   800315 <_panic>
  802394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802397:	8b 10                	mov    (%eax),%edx
  802399:	8b 45 08             	mov    0x8(%ebp),%eax
  80239c:	89 10                	mov    %edx,(%eax)
  80239e:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a1:	8b 00                	mov    (%eax),%eax
  8023a3:	85 c0                	test   %eax,%eax
  8023a5:	74 0b                	je     8023b2 <insert_sorted_allocList+0x1f3>
  8023a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023aa:	8b 00                	mov    (%eax),%eax
  8023ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8023af:	89 50 04             	mov    %edx,0x4(%eax)
  8023b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8023b8:	89 10                	mov    %edx,(%eax)
  8023ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023c0:	89 50 04             	mov    %edx,0x4(%eax)
  8023c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c6:	8b 00                	mov    (%eax),%eax
  8023c8:	85 c0                	test   %eax,%eax
  8023ca:	75 08                	jne    8023d4 <insert_sorted_allocList+0x215>
  8023cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cf:	a3 44 40 80 00       	mov    %eax,0x804044
  8023d4:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023d9:	40                   	inc    %eax
  8023da:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8023df:	eb 38                	jmp    802419 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  8023e1:	a1 48 40 80 00       	mov    0x804048,%eax
  8023e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ed:	74 07                	je     8023f6 <insert_sorted_allocList+0x237>
  8023ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f2:	8b 00                	mov    (%eax),%eax
  8023f4:	eb 05                	jmp    8023fb <insert_sorted_allocList+0x23c>
  8023f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8023fb:	a3 48 40 80 00       	mov    %eax,0x804048
  802400:	a1 48 40 80 00       	mov    0x804048,%eax
  802405:	85 c0                	test   %eax,%eax
  802407:	0f 85 3f ff ff ff    	jne    80234c <insert_sorted_allocList+0x18d>
  80240d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802411:	0f 85 35 ff ff ff    	jne    80234c <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  802417:	eb 00                	jmp    802419 <insert_sorted_allocList+0x25a>
  802419:	90                   	nop
  80241a:	c9                   	leave  
  80241b:	c3                   	ret    

0080241c <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80241c:	55                   	push   %ebp
  80241d:	89 e5                	mov    %esp,%ebp
  80241f:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802422:	a1 38 41 80 00       	mov    0x804138,%eax
  802427:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80242a:	e9 6b 02 00 00       	jmp    80269a <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  80242f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802432:	8b 40 0c             	mov    0xc(%eax),%eax
  802435:	3b 45 08             	cmp    0x8(%ebp),%eax
  802438:	0f 85 90 00 00 00    	jne    8024ce <alloc_block_FF+0xb2>
			  temp=element;
  80243e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802441:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  802444:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802448:	75 17                	jne    802461 <alloc_block_FF+0x45>
  80244a:	83 ec 04             	sub    $0x4,%esp
  80244d:	68 a8 3c 80 00       	push   $0x803ca8
  802452:	68 92 00 00 00       	push   $0x92
  802457:	68 37 3c 80 00       	push   $0x803c37
  80245c:	e8 b4 de ff ff       	call   800315 <_panic>
  802461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802464:	8b 00                	mov    (%eax),%eax
  802466:	85 c0                	test   %eax,%eax
  802468:	74 10                	je     80247a <alloc_block_FF+0x5e>
  80246a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246d:	8b 00                	mov    (%eax),%eax
  80246f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802472:	8b 52 04             	mov    0x4(%edx),%edx
  802475:	89 50 04             	mov    %edx,0x4(%eax)
  802478:	eb 0b                	jmp    802485 <alloc_block_FF+0x69>
  80247a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247d:	8b 40 04             	mov    0x4(%eax),%eax
  802480:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802485:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802488:	8b 40 04             	mov    0x4(%eax),%eax
  80248b:	85 c0                	test   %eax,%eax
  80248d:	74 0f                	je     80249e <alloc_block_FF+0x82>
  80248f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802492:	8b 40 04             	mov    0x4(%eax),%eax
  802495:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802498:	8b 12                	mov    (%edx),%edx
  80249a:	89 10                	mov    %edx,(%eax)
  80249c:	eb 0a                	jmp    8024a8 <alloc_block_FF+0x8c>
  80249e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a1:	8b 00                	mov    (%eax),%eax
  8024a3:	a3 38 41 80 00       	mov    %eax,0x804138
  8024a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024bb:	a1 44 41 80 00       	mov    0x804144,%eax
  8024c0:	48                   	dec    %eax
  8024c1:	a3 44 41 80 00       	mov    %eax,0x804144
			  return temp;
  8024c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024c9:	e9 ff 01 00 00       	jmp    8026cd <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  8024ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8024d4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024d7:	0f 86 b5 01 00 00    	jbe    802692 <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  8024dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8024e3:	2b 45 08             	sub    0x8(%ebp),%eax
  8024e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  8024e9:	a1 48 41 80 00       	mov    0x804148,%eax
  8024ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  8024f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8024f5:	75 17                	jne    80250e <alloc_block_FF+0xf2>
  8024f7:	83 ec 04             	sub    $0x4,%esp
  8024fa:	68 a8 3c 80 00       	push   $0x803ca8
  8024ff:	68 99 00 00 00       	push   $0x99
  802504:	68 37 3c 80 00       	push   $0x803c37
  802509:	e8 07 de ff ff       	call   800315 <_panic>
  80250e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802511:	8b 00                	mov    (%eax),%eax
  802513:	85 c0                	test   %eax,%eax
  802515:	74 10                	je     802527 <alloc_block_FF+0x10b>
  802517:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80251a:	8b 00                	mov    (%eax),%eax
  80251c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80251f:	8b 52 04             	mov    0x4(%edx),%edx
  802522:	89 50 04             	mov    %edx,0x4(%eax)
  802525:	eb 0b                	jmp    802532 <alloc_block_FF+0x116>
  802527:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80252a:	8b 40 04             	mov    0x4(%eax),%eax
  80252d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802532:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802535:	8b 40 04             	mov    0x4(%eax),%eax
  802538:	85 c0                	test   %eax,%eax
  80253a:	74 0f                	je     80254b <alloc_block_FF+0x12f>
  80253c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80253f:	8b 40 04             	mov    0x4(%eax),%eax
  802542:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802545:	8b 12                	mov    (%edx),%edx
  802547:	89 10                	mov    %edx,(%eax)
  802549:	eb 0a                	jmp    802555 <alloc_block_FF+0x139>
  80254b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80254e:	8b 00                	mov    (%eax),%eax
  802550:	a3 48 41 80 00       	mov    %eax,0x804148
  802555:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802558:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80255e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802561:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802568:	a1 54 41 80 00       	mov    0x804154,%eax
  80256d:	48                   	dec    %eax
  80256e:	a3 54 41 80 00       	mov    %eax,0x804154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  802573:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802577:	75 17                	jne    802590 <alloc_block_FF+0x174>
  802579:	83 ec 04             	sub    $0x4,%esp
  80257c:	68 50 3c 80 00       	push   $0x803c50
  802581:	68 9a 00 00 00       	push   $0x9a
  802586:	68 37 3c 80 00       	push   $0x803c37
  80258b:	e8 85 dd ff ff       	call   800315 <_panic>
  802590:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802596:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802599:	89 50 04             	mov    %edx,0x4(%eax)
  80259c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80259f:	8b 40 04             	mov    0x4(%eax),%eax
  8025a2:	85 c0                	test   %eax,%eax
  8025a4:	74 0c                	je     8025b2 <alloc_block_FF+0x196>
  8025a6:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8025ab:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025ae:	89 10                	mov    %edx,(%eax)
  8025b0:	eb 08                	jmp    8025ba <alloc_block_FF+0x19e>
  8025b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025b5:	a3 38 41 80 00       	mov    %eax,0x804138
  8025ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025bd:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025cb:	a1 44 41 80 00       	mov    0x804144,%eax
  8025d0:	40                   	inc    %eax
  8025d1:	a3 44 41 80 00       	mov    %eax,0x804144
		  // setting the size & sva
		  new_block->size=size;
  8025d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8025dc:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  8025df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e2:	8b 50 08             	mov    0x8(%eax),%edx
  8025e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e8:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  8025eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025f1:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  8025f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f7:	8b 50 08             	mov    0x8(%eax),%edx
  8025fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fd:	01 c2                	add    %eax,%edx
  8025ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802602:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  802605:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802608:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  80260b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80260f:	75 17                	jne    802628 <alloc_block_FF+0x20c>
  802611:	83 ec 04             	sub    $0x4,%esp
  802614:	68 a8 3c 80 00       	push   $0x803ca8
  802619:	68 a2 00 00 00       	push   $0xa2
  80261e:	68 37 3c 80 00       	push   $0x803c37
  802623:	e8 ed dc ff ff       	call   800315 <_panic>
  802628:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80262b:	8b 00                	mov    (%eax),%eax
  80262d:	85 c0                	test   %eax,%eax
  80262f:	74 10                	je     802641 <alloc_block_FF+0x225>
  802631:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802634:	8b 00                	mov    (%eax),%eax
  802636:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802639:	8b 52 04             	mov    0x4(%edx),%edx
  80263c:	89 50 04             	mov    %edx,0x4(%eax)
  80263f:	eb 0b                	jmp    80264c <alloc_block_FF+0x230>
  802641:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802644:	8b 40 04             	mov    0x4(%eax),%eax
  802647:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80264c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80264f:	8b 40 04             	mov    0x4(%eax),%eax
  802652:	85 c0                	test   %eax,%eax
  802654:	74 0f                	je     802665 <alloc_block_FF+0x249>
  802656:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802659:	8b 40 04             	mov    0x4(%eax),%eax
  80265c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80265f:	8b 12                	mov    (%edx),%edx
  802661:	89 10                	mov    %edx,(%eax)
  802663:	eb 0a                	jmp    80266f <alloc_block_FF+0x253>
  802665:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802668:	8b 00                	mov    (%eax),%eax
  80266a:	a3 38 41 80 00       	mov    %eax,0x804138
  80266f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802672:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802678:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80267b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802682:	a1 44 41 80 00       	mov    0x804144,%eax
  802687:	48                   	dec    %eax
  802688:	a3 44 41 80 00       	mov    %eax,0x804144
		  return temp;
  80268d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802690:	eb 3b                	jmp    8026cd <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802692:	a1 40 41 80 00       	mov    0x804140,%eax
  802697:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80269a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80269e:	74 07                	je     8026a7 <alloc_block_FF+0x28b>
  8026a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a3:	8b 00                	mov    (%eax),%eax
  8026a5:	eb 05                	jmp    8026ac <alloc_block_FF+0x290>
  8026a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ac:	a3 40 41 80 00       	mov    %eax,0x804140
  8026b1:	a1 40 41 80 00       	mov    0x804140,%eax
  8026b6:	85 c0                	test   %eax,%eax
  8026b8:	0f 85 71 fd ff ff    	jne    80242f <alloc_block_FF+0x13>
  8026be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026c2:	0f 85 67 fd ff ff    	jne    80242f <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  8026c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026cd:	c9                   	leave  
  8026ce:	c3                   	ret    

008026cf <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8026cf:	55                   	push   %ebp
  8026d0:	89 e5                	mov    %esp,%ebp
  8026d2:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  8026d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  8026dc:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  8026e3:	a1 38 41 80 00       	mov    0x804138,%eax
  8026e8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8026eb:	e9 d3 00 00 00       	jmp    8027c3 <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  8026f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026f9:	0f 85 90 00 00 00    	jne    80278f <alloc_block_BF+0xc0>
	   temp = element;
  8026ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802702:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  802705:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802709:	75 17                	jne    802722 <alloc_block_BF+0x53>
  80270b:	83 ec 04             	sub    $0x4,%esp
  80270e:	68 a8 3c 80 00       	push   $0x803ca8
  802713:	68 bd 00 00 00       	push   $0xbd
  802718:	68 37 3c 80 00       	push   $0x803c37
  80271d:	e8 f3 db ff ff       	call   800315 <_panic>
  802722:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802725:	8b 00                	mov    (%eax),%eax
  802727:	85 c0                	test   %eax,%eax
  802729:	74 10                	je     80273b <alloc_block_BF+0x6c>
  80272b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80272e:	8b 00                	mov    (%eax),%eax
  802730:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802733:	8b 52 04             	mov    0x4(%edx),%edx
  802736:	89 50 04             	mov    %edx,0x4(%eax)
  802739:	eb 0b                	jmp    802746 <alloc_block_BF+0x77>
  80273b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80273e:	8b 40 04             	mov    0x4(%eax),%eax
  802741:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802746:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802749:	8b 40 04             	mov    0x4(%eax),%eax
  80274c:	85 c0                	test   %eax,%eax
  80274e:	74 0f                	je     80275f <alloc_block_BF+0x90>
  802750:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802753:	8b 40 04             	mov    0x4(%eax),%eax
  802756:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802759:	8b 12                	mov    (%edx),%edx
  80275b:	89 10                	mov    %edx,(%eax)
  80275d:	eb 0a                	jmp    802769 <alloc_block_BF+0x9a>
  80275f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802762:	8b 00                	mov    (%eax),%eax
  802764:	a3 38 41 80 00       	mov    %eax,0x804138
  802769:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80276c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802772:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802775:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80277c:	a1 44 41 80 00       	mov    0x804144,%eax
  802781:	48                   	dec    %eax
  802782:	a3 44 41 80 00       	mov    %eax,0x804144
	   return temp;
  802787:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80278a:	e9 41 01 00 00       	jmp    8028d0 <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  80278f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802792:	8b 40 0c             	mov    0xc(%eax),%eax
  802795:	3b 45 08             	cmp    0x8(%ebp),%eax
  802798:	76 21                	jbe    8027bb <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  80279a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80279d:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027a3:	73 16                	jae    8027bb <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  8027a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  8027ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  8027b4:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  8027bb:	a1 40 41 80 00       	mov    0x804140,%eax
  8027c0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8027c3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8027c7:	74 07                	je     8027d0 <alloc_block_BF+0x101>
  8027c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027cc:	8b 00                	mov    (%eax),%eax
  8027ce:	eb 05                	jmp    8027d5 <alloc_block_BF+0x106>
  8027d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d5:	a3 40 41 80 00       	mov    %eax,0x804140
  8027da:	a1 40 41 80 00       	mov    0x804140,%eax
  8027df:	85 c0                	test   %eax,%eax
  8027e1:	0f 85 09 ff ff ff    	jne    8026f0 <alloc_block_BF+0x21>
  8027e7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8027eb:	0f 85 ff fe ff ff    	jne    8026f0 <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  8027f1:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  8027f5:	0f 85 d0 00 00 00    	jne    8028cb <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  8027fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027fe:	8b 40 0c             	mov    0xc(%eax),%eax
  802801:	2b 45 08             	sub    0x8(%ebp),%eax
  802804:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  802807:	a1 48 41 80 00       	mov    0x804148,%eax
  80280c:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  80280f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802813:	75 17                	jne    80282c <alloc_block_BF+0x15d>
  802815:	83 ec 04             	sub    $0x4,%esp
  802818:	68 a8 3c 80 00       	push   $0x803ca8
  80281d:	68 d1 00 00 00       	push   $0xd1
  802822:	68 37 3c 80 00       	push   $0x803c37
  802827:	e8 e9 da ff ff       	call   800315 <_panic>
  80282c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80282f:	8b 00                	mov    (%eax),%eax
  802831:	85 c0                	test   %eax,%eax
  802833:	74 10                	je     802845 <alloc_block_BF+0x176>
  802835:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802838:	8b 00                	mov    (%eax),%eax
  80283a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80283d:	8b 52 04             	mov    0x4(%edx),%edx
  802840:	89 50 04             	mov    %edx,0x4(%eax)
  802843:	eb 0b                	jmp    802850 <alloc_block_BF+0x181>
  802845:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802848:	8b 40 04             	mov    0x4(%eax),%eax
  80284b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802850:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802853:	8b 40 04             	mov    0x4(%eax),%eax
  802856:	85 c0                	test   %eax,%eax
  802858:	74 0f                	je     802869 <alloc_block_BF+0x19a>
  80285a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80285d:	8b 40 04             	mov    0x4(%eax),%eax
  802860:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802863:	8b 12                	mov    (%edx),%edx
  802865:	89 10                	mov    %edx,(%eax)
  802867:	eb 0a                	jmp    802873 <alloc_block_BF+0x1a4>
  802869:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80286c:	8b 00                	mov    (%eax),%eax
  80286e:	a3 48 41 80 00       	mov    %eax,0x804148
  802873:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802876:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80287c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80287f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802886:	a1 54 41 80 00       	mov    0x804154,%eax
  80288b:	48                   	dec    %eax
  80288c:	a3 54 41 80 00       	mov    %eax,0x804154
	  // setting the size & sva
	  new_block->size = size;
  802891:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802894:	8b 55 08             	mov    0x8(%ebp),%edx
  802897:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  80289a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80289d:	8b 50 08             	mov    0x8(%eax),%edx
  8028a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028a3:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  8028a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028ac:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  8028af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b2:	8b 50 08             	mov    0x8(%eax),%edx
  8028b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b8:	01 c2                	add    %eax,%edx
  8028ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028bd:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  8028c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028c3:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  8028c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028c9:	eb 05                	jmp    8028d0 <alloc_block_BF+0x201>
	 }
	 return NULL;
  8028cb:	b8 00 00 00 00       	mov    $0x0,%eax


}
  8028d0:	c9                   	leave  
  8028d1:	c3                   	ret    

008028d2 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8028d2:	55                   	push   %ebp
  8028d3:	89 e5                	mov    %esp,%ebp
  8028d5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  8028d8:	83 ec 04             	sub    $0x4,%esp
  8028db:	68 c8 3c 80 00       	push   $0x803cc8
  8028e0:	68 e8 00 00 00       	push   $0xe8
  8028e5:	68 37 3c 80 00       	push   $0x803c37
  8028ea:	e8 26 da ff ff       	call   800315 <_panic>

008028ef <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8028ef:	55                   	push   %ebp
  8028f0:	89 e5                	mov    %esp,%ebp
  8028f2:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  8028f5:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8028fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  8028fd:	a1 38 41 80 00       	mov    0x804138,%eax
  802902:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  802905:	a1 44 41 80 00       	mov    0x804144,%eax
  80290a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  80290d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802911:	75 68                	jne    80297b <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802913:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802917:	75 17                	jne    802930 <insert_sorted_with_merge_freeList+0x41>
  802919:	83 ec 04             	sub    $0x4,%esp
  80291c:	68 14 3c 80 00       	push   $0x803c14
  802921:	68 36 01 00 00       	push   $0x136
  802926:	68 37 3c 80 00       	push   $0x803c37
  80292b:	e8 e5 d9 ff ff       	call   800315 <_panic>
  802930:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802936:	8b 45 08             	mov    0x8(%ebp),%eax
  802939:	89 10                	mov    %edx,(%eax)
  80293b:	8b 45 08             	mov    0x8(%ebp),%eax
  80293e:	8b 00                	mov    (%eax),%eax
  802940:	85 c0                	test   %eax,%eax
  802942:	74 0d                	je     802951 <insert_sorted_with_merge_freeList+0x62>
  802944:	a1 38 41 80 00       	mov    0x804138,%eax
  802949:	8b 55 08             	mov    0x8(%ebp),%edx
  80294c:	89 50 04             	mov    %edx,0x4(%eax)
  80294f:	eb 08                	jmp    802959 <insert_sorted_with_merge_freeList+0x6a>
  802951:	8b 45 08             	mov    0x8(%ebp),%eax
  802954:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802959:	8b 45 08             	mov    0x8(%ebp),%eax
  80295c:	a3 38 41 80 00       	mov    %eax,0x804138
  802961:	8b 45 08             	mov    0x8(%ebp),%eax
  802964:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80296b:	a1 44 41 80 00       	mov    0x804144,%eax
  802970:	40                   	inc    %eax
  802971:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802976:	e9 ba 06 00 00       	jmp    803035 <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  80297b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80297e:	8b 50 08             	mov    0x8(%eax),%edx
  802981:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802984:	8b 40 0c             	mov    0xc(%eax),%eax
  802987:	01 c2                	add    %eax,%edx
  802989:	8b 45 08             	mov    0x8(%ebp),%eax
  80298c:	8b 40 08             	mov    0x8(%eax),%eax
  80298f:	39 c2                	cmp    %eax,%edx
  802991:	73 68                	jae    8029fb <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802993:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802997:	75 17                	jne    8029b0 <insert_sorted_with_merge_freeList+0xc1>
  802999:	83 ec 04             	sub    $0x4,%esp
  80299c:	68 50 3c 80 00       	push   $0x803c50
  8029a1:	68 3a 01 00 00       	push   $0x13a
  8029a6:	68 37 3c 80 00       	push   $0x803c37
  8029ab:	e8 65 d9 ff ff       	call   800315 <_panic>
  8029b0:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8029b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b9:	89 50 04             	mov    %edx,0x4(%eax)
  8029bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bf:	8b 40 04             	mov    0x4(%eax),%eax
  8029c2:	85 c0                	test   %eax,%eax
  8029c4:	74 0c                	je     8029d2 <insert_sorted_with_merge_freeList+0xe3>
  8029c6:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8029ce:	89 10                	mov    %edx,(%eax)
  8029d0:	eb 08                	jmp    8029da <insert_sorted_with_merge_freeList+0xeb>
  8029d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d5:	a3 38 41 80 00       	mov    %eax,0x804138
  8029da:	8b 45 08             	mov    0x8(%ebp),%eax
  8029dd:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029eb:	a1 44 41 80 00       	mov    0x804144,%eax
  8029f0:	40                   	inc    %eax
  8029f1:	a3 44 41 80 00       	mov    %eax,0x804144





}
  8029f6:	e9 3a 06 00 00       	jmp    803035 <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  8029fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029fe:	8b 50 08             	mov    0x8(%eax),%edx
  802a01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a04:	8b 40 0c             	mov    0xc(%eax),%eax
  802a07:	01 c2                	add    %eax,%edx
  802a09:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0c:	8b 40 08             	mov    0x8(%eax),%eax
  802a0f:	39 c2                	cmp    %eax,%edx
  802a11:	0f 85 90 00 00 00    	jne    802aa7 <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  802a17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a1a:	8b 50 0c             	mov    0xc(%eax),%edx
  802a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a20:	8b 40 0c             	mov    0xc(%eax),%eax
  802a23:	01 c2                	add    %eax,%edx
  802a25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a28:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  802a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  802a35:	8b 45 08             	mov    0x8(%ebp),%eax
  802a38:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802a3f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a43:	75 17                	jne    802a5c <insert_sorted_with_merge_freeList+0x16d>
  802a45:	83 ec 04             	sub    $0x4,%esp
  802a48:	68 14 3c 80 00       	push   $0x803c14
  802a4d:	68 41 01 00 00       	push   $0x141
  802a52:	68 37 3c 80 00       	push   $0x803c37
  802a57:	e8 b9 d8 ff ff       	call   800315 <_panic>
  802a5c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a62:	8b 45 08             	mov    0x8(%ebp),%eax
  802a65:	89 10                	mov    %edx,(%eax)
  802a67:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6a:	8b 00                	mov    (%eax),%eax
  802a6c:	85 c0                	test   %eax,%eax
  802a6e:	74 0d                	je     802a7d <insert_sorted_with_merge_freeList+0x18e>
  802a70:	a1 48 41 80 00       	mov    0x804148,%eax
  802a75:	8b 55 08             	mov    0x8(%ebp),%edx
  802a78:	89 50 04             	mov    %edx,0x4(%eax)
  802a7b:	eb 08                	jmp    802a85 <insert_sorted_with_merge_freeList+0x196>
  802a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a80:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a85:	8b 45 08             	mov    0x8(%ebp),%eax
  802a88:	a3 48 41 80 00       	mov    %eax,0x804148
  802a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a90:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a97:	a1 54 41 80 00       	mov    0x804154,%eax
  802a9c:	40                   	inc    %eax
  802a9d:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802aa2:	e9 8e 05 00 00       	jmp    803035 <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  802aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aaa:	8b 50 08             	mov    0x8(%eax),%edx
  802aad:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ab3:	01 c2                	add    %eax,%edx
  802ab5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ab8:	8b 40 08             	mov    0x8(%eax),%eax
  802abb:	39 c2                	cmp    %eax,%edx
  802abd:	73 68                	jae    802b27 <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802abf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ac3:	75 17                	jne    802adc <insert_sorted_with_merge_freeList+0x1ed>
  802ac5:	83 ec 04             	sub    $0x4,%esp
  802ac8:	68 14 3c 80 00       	push   $0x803c14
  802acd:	68 45 01 00 00       	push   $0x145
  802ad2:	68 37 3c 80 00       	push   $0x803c37
  802ad7:	e8 39 d8 ff ff       	call   800315 <_panic>
  802adc:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae5:	89 10                	mov    %edx,(%eax)
  802ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aea:	8b 00                	mov    (%eax),%eax
  802aec:	85 c0                	test   %eax,%eax
  802aee:	74 0d                	je     802afd <insert_sorted_with_merge_freeList+0x20e>
  802af0:	a1 38 41 80 00       	mov    0x804138,%eax
  802af5:	8b 55 08             	mov    0x8(%ebp),%edx
  802af8:	89 50 04             	mov    %edx,0x4(%eax)
  802afb:	eb 08                	jmp    802b05 <insert_sorted_with_merge_freeList+0x216>
  802afd:	8b 45 08             	mov    0x8(%ebp),%eax
  802b00:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b05:	8b 45 08             	mov    0x8(%ebp),%eax
  802b08:	a3 38 41 80 00       	mov    %eax,0x804138
  802b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b10:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b17:	a1 44 41 80 00       	mov    0x804144,%eax
  802b1c:	40                   	inc    %eax
  802b1d:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802b22:	e9 0e 05 00 00       	jmp    803035 <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  802b27:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2a:	8b 50 08             	mov    0x8(%eax),%edx
  802b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b30:	8b 40 0c             	mov    0xc(%eax),%eax
  802b33:	01 c2                	add    %eax,%edx
  802b35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b38:	8b 40 08             	mov    0x8(%eax),%eax
  802b3b:	39 c2                	cmp    %eax,%edx
  802b3d:	0f 85 9c 00 00 00    	jne    802bdf <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  802b43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b46:	8b 50 0c             	mov    0xc(%eax),%edx
  802b49:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4c:	8b 40 0c             	mov    0xc(%eax),%eax
  802b4f:	01 c2                	add    %eax,%edx
  802b51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b54:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  802b57:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5a:	8b 50 08             	mov    0x8(%eax),%edx
  802b5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b60:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  802b63:	8b 45 08             	mov    0x8(%ebp),%eax
  802b66:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  802b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b70:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802b77:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b7b:	75 17                	jne    802b94 <insert_sorted_with_merge_freeList+0x2a5>
  802b7d:	83 ec 04             	sub    $0x4,%esp
  802b80:	68 14 3c 80 00       	push   $0x803c14
  802b85:	68 4d 01 00 00       	push   $0x14d
  802b8a:	68 37 3c 80 00       	push   $0x803c37
  802b8f:	e8 81 d7 ff ff       	call   800315 <_panic>
  802b94:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9d:	89 10                	mov    %edx,(%eax)
  802b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba2:	8b 00                	mov    (%eax),%eax
  802ba4:	85 c0                	test   %eax,%eax
  802ba6:	74 0d                	je     802bb5 <insert_sorted_with_merge_freeList+0x2c6>
  802ba8:	a1 48 41 80 00       	mov    0x804148,%eax
  802bad:	8b 55 08             	mov    0x8(%ebp),%edx
  802bb0:	89 50 04             	mov    %edx,0x4(%eax)
  802bb3:	eb 08                	jmp    802bbd <insert_sorted_with_merge_freeList+0x2ce>
  802bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc0:	a3 48 41 80 00       	mov    %eax,0x804148
  802bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bcf:	a1 54 41 80 00       	mov    0x804154,%eax
  802bd4:	40                   	inc    %eax
  802bd5:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802bda:	e9 56 04 00 00       	jmp    803035 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802bdf:	a1 38 41 80 00       	mov    0x804138,%eax
  802be4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802be7:	e9 19 04 00 00       	jmp    803005 <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  802bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bef:	8b 00                	mov    (%eax),%eax
  802bf1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf7:	8b 50 08             	mov    0x8(%eax),%edx
  802bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfd:	8b 40 0c             	mov    0xc(%eax),%eax
  802c00:	01 c2                	add    %eax,%edx
  802c02:	8b 45 08             	mov    0x8(%ebp),%eax
  802c05:	8b 40 08             	mov    0x8(%eax),%eax
  802c08:	39 c2                	cmp    %eax,%edx
  802c0a:	0f 85 ad 01 00 00    	jne    802dbd <insert_sorted_with_merge_freeList+0x4ce>
  802c10:	8b 45 08             	mov    0x8(%ebp),%eax
  802c13:	8b 50 08             	mov    0x8(%eax),%edx
  802c16:	8b 45 08             	mov    0x8(%ebp),%eax
  802c19:	8b 40 0c             	mov    0xc(%eax),%eax
  802c1c:	01 c2                	add    %eax,%edx
  802c1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c21:	8b 40 08             	mov    0x8(%eax),%eax
  802c24:	39 c2                	cmp    %eax,%edx
  802c26:	0f 85 91 01 00 00    	jne    802dbd <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  802c2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2f:	8b 50 0c             	mov    0xc(%eax),%edx
  802c32:	8b 45 08             	mov    0x8(%ebp),%eax
  802c35:	8b 48 0c             	mov    0xc(%eax),%ecx
  802c38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c3b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c3e:	01 c8                	add    %ecx,%eax
  802c40:	01 c2                	add    %eax,%edx
  802c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c45:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  802c48:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802c52:	8b 45 08             	mov    0x8(%ebp),%eax
  802c55:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  802c5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c5f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  802c66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c69:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  802c70:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802c74:	75 17                	jne    802c8d <insert_sorted_with_merge_freeList+0x39e>
  802c76:	83 ec 04             	sub    $0x4,%esp
  802c79:	68 a8 3c 80 00       	push   $0x803ca8
  802c7e:	68 5b 01 00 00       	push   $0x15b
  802c83:	68 37 3c 80 00       	push   $0x803c37
  802c88:	e8 88 d6 ff ff       	call   800315 <_panic>
  802c8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c90:	8b 00                	mov    (%eax),%eax
  802c92:	85 c0                	test   %eax,%eax
  802c94:	74 10                	je     802ca6 <insert_sorted_with_merge_freeList+0x3b7>
  802c96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c99:	8b 00                	mov    (%eax),%eax
  802c9b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c9e:	8b 52 04             	mov    0x4(%edx),%edx
  802ca1:	89 50 04             	mov    %edx,0x4(%eax)
  802ca4:	eb 0b                	jmp    802cb1 <insert_sorted_with_merge_freeList+0x3c2>
  802ca6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ca9:	8b 40 04             	mov    0x4(%eax),%eax
  802cac:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cb4:	8b 40 04             	mov    0x4(%eax),%eax
  802cb7:	85 c0                	test   %eax,%eax
  802cb9:	74 0f                	je     802cca <insert_sorted_with_merge_freeList+0x3db>
  802cbb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cbe:	8b 40 04             	mov    0x4(%eax),%eax
  802cc1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802cc4:	8b 12                	mov    (%edx),%edx
  802cc6:	89 10                	mov    %edx,(%eax)
  802cc8:	eb 0a                	jmp    802cd4 <insert_sorted_with_merge_freeList+0x3e5>
  802cca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ccd:	8b 00                	mov    (%eax),%eax
  802ccf:	a3 38 41 80 00       	mov    %eax,0x804138
  802cd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cd7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cdd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ce0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ce7:	a1 44 41 80 00       	mov    0x804144,%eax
  802cec:	48                   	dec    %eax
  802ced:	a3 44 41 80 00       	mov    %eax,0x804144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802cf2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cf6:	75 17                	jne    802d0f <insert_sorted_with_merge_freeList+0x420>
  802cf8:	83 ec 04             	sub    $0x4,%esp
  802cfb:	68 14 3c 80 00       	push   $0x803c14
  802d00:	68 5c 01 00 00       	push   $0x15c
  802d05:	68 37 3c 80 00       	push   $0x803c37
  802d0a:	e8 06 d6 ff ff       	call   800315 <_panic>
  802d0f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d15:	8b 45 08             	mov    0x8(%ebp),%eax
  802d18:	89 10                	mov    %edx,(%eax)
  802d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1d:	8b 00                	mov    (%eax),%eax
  802d1f:	85 c0                	test   %eax,%eax
  802d21:	74 0d                	je     802d30 <insert_sorted_with_merge_freeList+0x441>
  802d23:	a1 48 41 80 00       	mov    0x804148,%eax
  802d28:	8b 55 08             	mov    0x8(%ebp),%edx
  802d2b:	89 50 04             	mov    %edx,0x4(%eax)
  802d2e:	eb 08                	jmp    802d38 <insert_sorted_with_merge_freeList+0x449>
  802d30:	8b 45 08             	mov    0x8(%ebp),%eax
  802d33:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d38:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3b:	a3 48 41 80 00       	mov    %eax,0x804148
  802d40:	8b 45 08             	mov    0x8(%ebp),%eax
  802d43:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d4a:	a1 54 41 80 00       	mov    0x804154,%eax
  802d4f:	40                   	inc    %eax
  802d50:	a3 54 41 80 00       	mov    %eax,0x804154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  802d55:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802d59:	75 17                	jne    802d72 <insert_sorted_with_merge_freeList+0x483>
  802d5b:	83 ec 04             	sub    $0x4,%esp
  802d5e:	68 14 3c 80 00       	push   $0x803c14
  802d63:	68 5d 01 00 00       	push   $0x15d
  802d68:	68 37 3c 80 00       	push   $0x803c37
  802d6d:	e8 a3 d5 ff ff       	call   800315 <_panic>
  802d72:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d7b:	89 10                	mov    %edx,(%eax)
  802d7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d80:	8b 00                	mov    (%eax),%eax
  802d82:	85 c0                	test   %eax,%eax
  802d84:	74 0d                	je     802d93 <insert_sorted_with_merge_freeList+0x4a4>
  802d86:	a1 48 41 80 00       	mov    0x804148,%eax
  802d8b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d8e:	89 50 04             	mov    %edx,0x4(%eax)
  802d91:	eb 08                	jmp    802d9b <insert_sorted_with_merge_freeList+0x4ac>
  802d93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d96:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d9e:	a3 48 41 80 00       	mov    %eax,0x804148
  802da3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802da6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dad:	a1 54 41 80 00       	mov    0x804154,%eax
  802db2:	40                   	inc    %eax
  802db3:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802db8:	e9 78 02 00 00       	jmp    803035 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802dbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc0:	8b 50 08             	mov    0x8(%eax),%edx
  802dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc6:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc9:	01 c2                	add    %eax,%edx
  802dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dce:	8b 40 08             	mov    0x8(%eax),%eax
  802dd1:	39 c2                	cmp    %eax,%edx
  802dd3:	0f 83 b8 00 00 00    	jae    802e91 <insert_sorted_with_merge_freeList+0x5a2>
  802dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddc:	8b 50 08             	mov    0x8(%eax),%edx
  802ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  802de2:	8b 40 0c             	mov    0xc(%eax),%eax
  802de5:	01 c2                	add    %eax,%edx
  802de7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dea:	8b 40 08             	mov    0x8(%eax),%eax
  802ded:	39 c2                	cmp    %eax,%edx
  802def:	0f 85 9c 00 00 00    	jne    802e91 <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  802df5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802df8:	8b 50 0c             	mov    0xc(%eax),%edx
  802dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfe:	8b 40 0c             	mov    0xc(%eax),%eax
  802e01:	01 c2                	add    %eax,%edx
  802e03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e06:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  802e09:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0c:	8b 50 08             	mov    0x8(%eax),%edx
  802e0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e12:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  802e15:	8b 45 08             	mov    0x8(%ebp),%eax
  802e18:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e22:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e29:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e2d:	75 17                	jne    802e46 <insert_sorted_with_merge_freeList+0x557>
  802e2f:	83 ec 04             	sub    $0x4,%esp
  802e32:	68 14 3c 80 00       	push   $0x803c14
  802e37:	68 67 01 00 00       	push   $0x167
  802e3c:	68 37 3c 80 00       	push   $0x803c37
  802e41:	e8 cf d4 ff ff       	call   800315 <_panic>
  802e46:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4f:	89 10                	mov    %edx,(%eax)
  802e51:	8b 45 08             	mov    0x8(%ebp),%eax
  802e54:	8b 00                	mov    (%eax),%eax
  802e56:	85 c0                	test   %eax,%eax
  802e58:	74 0d                	je     802e67 <insert_sorted_with_merge_freeList+0x578>
  802e5a:	a1 48 41 80 00       	mov    0x804148,%eax
  802e5f:	8b 55 08             	mov    0x8(%ebp),%edx
  802e62:	89 50 04             	mov    %edx,0x4(%eax)
  802e65:	eb 08                	jmp    802e6f <insert_sorted_with_merge_freeList+0x580>
  802e67:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e72:	a3 48 41 80 00       	mov    %eax,0x804148
  802e77:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e81:	a1 54 41 80 00       	mov    0x804154,%eax
  802e86:	40                   	inc    %eax
  802e87:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802e8c:	e9 a4 01 00 00       	jmp    803035 <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802e91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e94:	8b 50 08             	mov    0x8(%eax),%edx
  802e97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e9d:	01 c2                	add    %eax,%edx
  802e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea2:	8b 40 08             	mov    0x8(%eax),%eax
  802ea5:	39 c2                	cmp    %eax,%edx
  802ea7:	0f 85 ac 00 00 00    	jne    802f59 <insert_sorted_with_merge_freeList+0x66a>
  802ead:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb0:	8b 50 08             	mov    0x8(%eax),%edx
  802eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb6:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb9:	01 c2                	add    %eax,%edx
  802ebb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ebe:	8b 40 08             	mov    0x8(%eax),%eax
  802ec1:	39 c2                	cmp    %eax,%edx
  802ec3:	0f 83 90 00 00 00    	jae    802f59 <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  802ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecc:	8b 50 0c             	mov    0xc(%eax),%edx
  802ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed5:	01 c2                	add    %eax,%edx
  802ed7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eda:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  802edd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  802ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eea:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802ef1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ef5:	75 17                	jne    802f0e <insert_sorted_with_merge_freeList+0x61f>
  802ef7:	83 ec 04             	sub    $0x4,%esp
  802efa:	68 14 3c 80 00       	push   $0x803c14
  802eff:	68 70 01 00 00       	push   $0x170
  802f04:	68 37 3c 80 00       	push   $0x803c37
  802f09:	e8 07 d4 ff ff       	call   800315 <_panic>
  802f0e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f14:	8b 45 08             	mov    0x8(%ebp),%eax
  802f17:	89 10                	mov    %edx,(%eax)
  802f19:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1c:	8b 00                	mov    (%eax),%eax
  802f1e:	85 c0                	test   %eax,%eax
  802f20:	74 0d                	je     802f2f <insert_sorted_with_merge_freeList+0x640>
  802f22:	a1 48 41 80 00       	mov    0x804148,%eax
  802f27:	8b 55 08             	mov    0x8(%ebp),%edx
  802f2a:	89 50 04             	mov    %edx,0x4(%eax)
  802f2d:	eb 08                	jmp    802f37 <insert_sorted_with_merge_freeList+0x648>
  802f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f32:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f37:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3a:	a3 48 41 80 00       	mov    %eax,0x804148
  802f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f42:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f49:	a1 54 41 80 00       	mov    0x804154,%eax
  802f4e:	40                   	inc    %eax
  802f4f:	a3 54 41 80 00       	mov    %eax,0x804154
	      break;
  802f54:	e9 dc 00 00 00       	jmp    803035 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5c:	8b 50 08             	mov    0x8(%eax),%edx
  802f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f62:	8b 40 0c             	mov    0xc(%eax),%eax
  802f65:	01 c2                	add    %eax,%edx
  802f67:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6a:	8b 40 08             	mov    0x8(%eax),%eax
  802f6d:	39 c2                	cmp    %eax,%edx
  802f6f:	0f 83 88 00 00 00    	jae    802ffd <insert_sorted_with_merge_freeList+0x70e>
  802f75:	8b 45 08             	mov    0x8(%ebp),%eax
  802f78:	8b 50 08             	mov    0x8(%eax),%edx
  802f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7e:	8b 40 0c             	mov    0xc(%eax),%eax
  802f81:	01 c2                	add    %eax,%edx
  802f83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f86:	8b 40 08             	mov    0x8(%eax),%eax
  802f89:	39 c2                	cmp    %eax,%edx
  802f8b:	73 70                	jae    802ffd <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  802f8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f91:	74 06                	je     802f99 <insert_sorted_with_merge_freeList+0x6aa>
  802f93:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f97:	75 17                	jne    802fb0 <insert_sorted_with_merge_freeList+0x6c1>
  802f99:	83 ec 04             	sub    $0x4,%esp
  802f9c:	68 74 3c 80 00       	push   $0x803c74
  802fa1:	68 75 01 00 00       	push   $0x175
  802fa6:	68 37 3c 80 00       	push   $0x803c37
  802fab:	e8 65 d3 ff ff       	call   800315 <_panic>
  802fb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb3:	8b 10                	mov    (%eax),%edx
  802fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb8:	89 10                	mov    %edx,(%eax)
  802fba:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbd:	8b 00                	mov    (%eax),%eax
  802fbf:	85 c0                	test   %eax,%eax
  802fc1:	74 0b                	je     802fce <insert_sorted_with_merge_freeList+0x6df>
  802fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc6:	8b 00                	mov    (%eax),%eax
  802fc8:	8b 55 08             	mov    0x8(%ebp),%edx
  802fcb:	89 50 04             	mov    %edx,0x4(%eax)
  802fce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd1:	8b 55 08             	mov    0x8(%ebp),%edx
  802fd4:	89 10                	mov    %edx,(%eax)
  802fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fdc:	89 50 04             	mov    %edx,0x4(%eax)
  802fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe2:	8b 00                	mov    (%eax),%eax
  802fe4:	85 c0                	test   %eax,%eax
  802fe6:	75 08                	jne    802ff0 <insert_sorted_with_merge_freeList+0x701>
  802fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  802feb:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ff0:	a1 44 41 80 00       	mov    0x804144,%eax
  802ff5:	40                   	inc    %eax
  802ff6:	a3 44 41 80 00       	mov    %eax,0x804144
	      break;
  802ffb:	eb 38                	jmp    803035 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802ffd:	a1 40 41 80 00       	mov    0x804140,%eax
  803002:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803005:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803009:	74 07                	je     803012 <insert_sorted_with_merge_freeList+0x723>
  80300b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300e:	8b 00                	mov    (%eax),%eax
  803010:	eb 05                	jmp    803017 <insert_sorted_with_merge_freeList+0x728>
  803012:	b8 00 00 00 00       	mov    $0x0,%eax
  803017:	a3 40 41 80 00       	mov    %eax,0x804140
  80301c:	a1 40 41 80 00       	mov    0x804140,%eax
  803021:	85 c0                	test   %eax,%eax
  803023:	0f 85 c3 fb ff ff    	jne    802bec <insert_sorted_with_merge_freeList+0x2fd>
  803029:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80302d:	0f 85 b9 fb ff ff    	jne    802bec <insert_sorted_with_merge_freeList+0x2fd>





}
  803033:	eb 00                	jmp    803035 <insert_sorted_with_merge_freeList+0x746>
  803035:	90                   	nop
  803036:	c9                   	leave  
  803037:	c3                   	ret    

00803038 <__udivdi3>:
  803038:	55                   	push   %ebp
  803039:	57                   	push   %edi
  80303a:	56                   	push   %esi
  80303b:	53                   	push   %ebx
  80303c:	83 ec 1c             	sub    $0x1c,%esp
  80303f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803043:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803047:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80304b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80304f:	89 ca                	mov    %ecx,%edx
  803051:	89 f8                	mov    %edi,%eax
  803053:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803057:	85 f6                	test   %esi,%esi
  803059:	75 2d                	jne    803088 <__udivdi3+0x50>
  80305b:	39 cf                	cmp    %ecx,%edi
  80305d:	77 65                	ja     8030c4 <__udivdi3+0x8c>
  80305f:	89 fd                	mov    %edi,%ebp
  803061:	85 ff                	test   %edi,%edi
  803063:	75 0b                	jne    803070 <__udivdi3+0x38>
  803065:	b8 01 00 00 00       	mov    $0x1,%eax
  80306a:	31 d2                	xor    %edx,%edx
  80306c:	f7 f7                	div    %edi
  80306e:	89 c5                	mov    %eax,%ebp
  803070:	31 d2                	xor    %edx,%edx
  803072:	89 c8                	mov    %ecx,%eax
  803074:	f7 f5                	div    %ebp
  803076:	89 c1                	mov    %eax,%ecx
  803078:	89 d8                	mov    %ebx,%eax
  80307a:	f7 f5                	div    %ebp
  80307c:	89 cf                	mov    %ecx,%edi
  80307e:	89 fa                	mov    %edi,%edx
  803080:	83 c4 1c             	add    $0x1c,%esp
  803083:	5b                   	pop    %ebx
  803084:	5e                   	pop    %esi
  803085:	5f                   	pop    %edi
  803086:	5d                   	pop    %ebp
  803087:	c3                   	ret    
  803088:	39 ce                	cmp    %ecx,%esi
  80308a:	77 28                	ja     8030b4 <__udivdi3+0x7c>
  80308c:	0f bd fe             	bsr    %esi,%edi
  80308f:	83 f7 1f             	xor    $0x1f,%edi
  803092:	75 40                	jne    8030d4 <__udivdi3+0x9c>
  803094:	39 ce                	cmp    %ecx,%esi
  803096:	72 0a                	jb     8030a2 <__udivdi3+0x6a>
  803098:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80309c:	0f 87 9e 00 00 00    	ja     803140 <__udivdi3+0x108>
  8030a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8030a7:	89 fa                	mov    %edi,%edx
  8030a9:	83 c4 1c             	add    $0x1c,%esp
  8030ac:	5b                   	pop    %ebx
  8030ad:	5e                   	pop    %esi
  8030ae:	5f                   	pop    %edi
  8030af:	5d                   	pop    %ebp
  8030b0:	c3                   	ret    
  8030b1:	8d 76 00             	lea    0x0(%esi),%esi
  8030b4:	31 ff                	xor    %edi,%edi
  8030b6:	31 c0                	xor    %eax,%eax
  8030b8:	89 fa                	mov    %edi,%edx
  8030ba:	83 c4 1c             	add    $0x1c,%esp
  8030bd:	5b                   	pop    %ebx
  8030be:	5e                   	pop    %esi
  8030bf:	5f                   	pop    %edi
  8030c0:	5d                   	pop    %ebp
  8030c1:	c3                   	ret    
  8030c2:	66 90                	xchg   %ax,%ax
  8030c4:	89 d8                	mov    %ebx,%eax
  8030c6:	f7 f7                	div    %edi
  8030c8:	31 ff                	xor    %edi,%edi
  8030ca:	89 fa                	mov    %edi,%edx
  8030cc:	83 c4 1c             	add    $0x1c,%esp
  8030cf:	5b                   	pop    %ebx
  8030d0:	5e                   	pop    %esi
  8030d1:	5f                   	pop    %edi
  8030d2:	5d                   	pop    %ebp
  8030d3:	c3                   	ret    
  8030d4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8030d9:	89 eb                	mov    %ebp,%ebx
  8030db:	29 fb                	sub    %edi,%ebx
  8030dd:	89 f9                	mov    %edi,%ecx
  8030df:	d3 e6                	shl    %cl,%esi
  8030e1:	89 c5                	mov    %eax,%ebp
  8030e3:	88 d9                	mov    %bl,%cl
  8030e5:	d3 ed                	shr    %cl,%ebp
  8030e7:	89 e9                	mov    %ebp,%ecx
  8030e9:	09 f1                	or     %esi,%ecx
  8030eb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8030ef:	89 f9                	mov    %edi,%ecx
  8030f1:	d3 e0                	shl    %cl,%eax
  8030f3:	89 c5                	mov    %eax,%ebp
  8030f5:	89 d6                	mov    %edx,%esi
  8030f7:	88 d9                	mov    %bl,%cl
  8030f9:	d3 ee                	shr    %cl,%esi
  8030fb:	89 f9                	mov    %edi,%ecx
  8030fd:	d3 e2                	shl    %cl,%edx
  8030ff:	8b 44 24 08          	mov    0x8(%esp),%eax
  803103:	88 d9                	mov    %bl,%cl
  803105:	d3 e8                	shr    %cl,%eax
  803107:	09 c2                	or     %eax,%edx
  803109:	89 d0                	mov    %edx,%eax
  80310b:	89 f2                	mov    %esi,%edx
  80310d:	f7 74 24 0c          	divl   0xc(%esp)
  803111:	89 d6                	mov    %edx,%esi
  803113:	89 c3                	mov    %eax,%ebx
  803115:	f7 e5                	mul    %ebp
  803117:	39 d6                	cmp    %edx,%esi
  803119:	72 19                	jb     803134 <__udivdi3+0xfc>
  80311b:	74 0b                	je     803128 <__udivdi3+0xf0>
  80311d:	89 d8                	mov    %ebx,%eax
  80311f:	31 ff                	xor    %edi,%edi
  803121:	e9 58 ff ff ff       	jmp    80307e <__udivdi3+0x46>
  803126:	66 90                	xchg   %ax,%ax
  803128:	8b 54 24 08          	mov    0x8(%esp),%edx
  80312c:	89 f9                	mov    %edi,%ecx
  80312e:	d3 e2                	shl    %cl,%edx
  803130:	39 c2                	cmp    %eax,%edx
  803132:	73 e9                	jae    80311d <__udivdi3+0xe5>
  803134:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803137:	31 ff                	xor    %edi,%edi
  803139:	e9 40 ff ff ff       	jmp    80307e <__udivdi3+0x46>
  80313e:	66 90                	xchg   %ax,%ax
  803140:	31 c0                	xor    %eax,%eax
  803142:	e9 37 ff ff ff       	jmp    80307e <__udivdi3+0x46>
  803147:	90                   	nop

00803148 <__umoddi3>:
  803148:	55                   	push   %ebp
  803149:	57                   	push   %edi
  80314a:	56                   	push   %esi
  80314b:	53                   	push   %ebx
  80314c:	83 ec 1c             	sub    $0x1c,%esp
  80314f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803153:	8b 74 24 34          	mov    0x34(%esp),%esi
  803157:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80315b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80315f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803163:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803167:	89 f3                	mov    %esi,%ebx
  803169:	89 fa                	mov    %edi,%edx
  80316b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80316f:	89 34 24             	mov    %esi,(%esp)
  803172:	85 c0                	test   %eax,%eax
  803174:	75 1a                	jne    803190 <__umoddi3+0x48>
  803176:	39 f7                	cmp    %esi,%edi
  803178:	0f 86 a2 00 00 00    	jbe    803220 <__umoddi3+0xd8>
  80317e:	89 c8                	mov    %ecx,%eax
  803180:	89 f2                	mov    %esi,%edx
  803182:	f7 f7                	div    %edi
  803184:	89 d0                	mov    %edx,%eax
  803186:	31 d2                	xor    %edx,%edx
  803188:	83 c4 1c             	add    $0x1c,%esp
  80318b:	5b                   	pop    %ebx
  80318c:	5e                   	pop    %esi
  80318d:	5f                   	pop    %edi
  80318e:	5d                   	pop    %ebp
  80318f:	c3                   	ret    
  803190:	39 f0                	cmp    %esi,%eax
  803192:	0f 87 ac 00 00 00    	ja     803244 <__umoddi3+0xfc>
  803198:	0f bd e8             	bsr    %eax,%ebp
  80319b:	83 f5 1f             	xor    $0x1f,%ebp
  80319e:	0f 84 ac 00 00 00    	je     803250 <__umoddi3+0x108>
  8031a4:	bf 20 00 00 00       	mov    $0x20,%edi
  8031a9:	29 ef                	sub    %ebp,%edi
  8031ab:	89 fe                	mov    %edi,%esi
  8031ad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8031b1:	89 e9                	mov    %ebp,%ecx
  8031b3:	d3 e0                	shl    %cl,%eax
  8031b5:	89 d7                	mov    %edx,%edi
  8031b7:	89 f1                	mov    %esi,%ecx
  8031b9:	d3 ef                	shr    %cl,%edi
  8031bb:	09 c7                	or     %eax,%edi
  8031bd:	89 e9                	mov    %ebp,%ecx
  8031bf:	d3 e2                	shl    %cl,%edx
  8031c1:	89 14 24             	mov    %edx,(%esp)
  8031c4:	89 d8                	mov    %ebx,%eax
  8031c6:	d3 e0                	shl    %cl,%eax
  8031c8:	89 c2                	mov    %eax,%edx
  8031ca:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031ce:	d3 e0                	shl    %cl,%eax
  8031d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031d4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031d8:	89 f1                	mov    %esi,%ecx
  8031da:	d3 e8                	shr    %cl,%eax
  8031dc:	09 d0                	or     %edx,%eax
  8031de:	d3 eb                	shr    %cl,%ebx
  8031e0:	89 da                	mov    %ebx,%edx
  8031e2:	f7 f7                	div    %edi
  8031e4:	89 d3                	mov    %edx,%ebx
  8031e6:	f7 24 24             	mull   (%esp)
  8031e9:	89 c6                	mov    %eax,%esi
  8031eb:	89 d1                	mov    %edx,%ecx
  8031ed:	39 d3                	cmp    %edx,%ebx
  8031ef:	0f 82 87 00 00 00    	jb     80327c <__umoddi3+0x134>
  8031f5:	0f 84 91 00 00 00    	je     80328c <__umoddi3+0x144>
  8031fb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8031ff:	29 f2                	sub    %esi,%edx
  803201:	19 cb                	sbb    %ecx,%ebx
  803203:	89 d8                	mov    %ebx,%eax
  803205:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803209:	d3 e0                	shl    %cl,%eax
  80320b:	89 e9                	mov    %ebp,%ecx
  80320d:	d3 ea                	shr    %cl,%edx
  80320f:	09 d0                	or     %edx,%eax
  803211:	89 e9                	mov    %ebp,%ecx
  803213:	d3 eb                	shr    %cl,%ebx
  803215:	89 da                	mov    %ebx,%edx
  803217:	83 c4 1c             	add    $0x1c,%esp
  80321a:	5b                   	pop    %ebx
  80321b:	5e                   	pop    %esi
  80321c:	5f                   	pop    %edi
  80321d:	5d                   	pop    %ebp
  80321e:	c3                   	ret    
  80321f:	90                   	nop
  803220:	89 fd                	mov    %edi,%ebp
  803222:	85 ff                	test   %edi,%edi
  803224:	75 0b                	jne    803231 <__umoddi3+0xe9>
  803226:	b8 01 00 00 00       	mov    $0x1,%eax
  80322b:	31 d2                	xor    %edx,%edx
  80322d:	f7 f7                	div    %edi
  80322f:	89 c5                	mov    %eax,%ebp
  803231:	89 f0                	mov    %esi,%eax
  803233:	31 d2                	xor    %edx,%edx
  803235:	f7 f5                	div    %ebp
  803237:	89 c8                	mov    %ecx,%eax
  803239:	f7 f5                	div    %ebp
  80323b:	89 d0                	mov    %edx,%eax
  80323d:	e9 44 ff ff ff       	jmp    803186 <__umoddi3+0x3e>
  803242:	66 90                	xchg   %ax,%ax
  803244:	89 c8                	mov    %ecx,%eax
  803246:	89 f2                	mov    %esi,%edx
  803248:	83 c4 1c             	add    $0x1c,%esp
  80324b:	5b                   	pop    %ebx
  80324c:	5e                   	pop    %esi
  80324d:	5f                   	pop    %edi
  80324e:	5d                   	pop    %ebp
  80324f:	c3                   	ret    
  803250:	3b 04 24             	cmp    (%esp),%eax
  803253:	72 06                	jb     80325b <__umoddi3+0x113>
  803255:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803259:	77 0f                	ja     80326a <__umoddi3+0x122>
  80325b:	89 f2                	mov    %esi,%edx
  80325d:	29 f9                	sub    %edi,%ecx
  80325f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803263:	89 14 24             	mov    %edx,(%esp)
  803266:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80326a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80326e:	8b 14 24             	mov    (%esp),%edx
  803271:	83 c4 1c             	add    $0x1c,%esp
  803274:	5b                   	pop    %ebx
  803275:	5e                   	pop    %esi
  803276:	5f                   	pop    %edi
  803277:	5d                   	pop    %ebp
  803278:	c3                   	ret    
  803279:	8d 76 00             	lea    0x0(%esi),%esi
  80327c:	2b 04 24             	sub    (%esp),%eax
  80327f:	19 fa                	sbb    %edi,%edx
  803281:	89 d1                	mov    %edx,%ecx
  803283:	89 c6                	mov    %eax,%esi
  803285:	e9 71 ff ff ff       	jmp    8031fb <__umoddi3+0xb3>
  80328a:	66 90                	xchg   %ax,%ax
  80328c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803290:	72 ea                	jb     80327c <__umoddi3+0x134>
  803292:	89 d9                	mov    %ebx,%ecx
  803294:	e9 62 ff ff ff       	jmp    8031fb <__umoddi3+0xb3>
