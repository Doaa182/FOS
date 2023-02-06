
obj/user/tst_nextfit:     file format elf32-i386


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
  800031:	e8 b6 0b 00 00       	call   800bec <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec 40 08 00 00    	sub    $0x840,%esp
	int Mega = 1024*1024;
  800043:	c7 45 d8 00 00 10 00 	movl   $0x100000,-0x28(%ebp)
	int kilo = 1024;
  80004a:	c7 45 d4 00 04 00 00 	movl   $0x400,-0x2c(%ebp)
	sys_set_uheap_strategy(UHP_PLACE_NEXTFIT);
  800051:	83 ec 0c             	sub    $0xc,%esp
  800054:	6a 03                	push   $0x3
  800056:	e8 4e 28 00 00       	call   8028a9 <sys_set_uheap_strategy>
  80005b:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80005e:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800062:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800069:	eb 29                	jmp    800094 <_main+0x5c>
		{
			if (myEnv->__uptr_pws[i].empty)
  80006b:	a1 20 50 80 00       	mov    0x805020,%eax
  800070:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800076:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800079:	89 d0                	mov    %edx,%eax
  80007b:	01 c0                	add    %eax,%eax
  80007d:	01 d0                	add    %edx,%eax
  80007f:	c1 e0 03             	shl    $0x3,%eax
  800082:	01 c8                	add    %ecx,%eax
  800084:	8a 40 04             	mov    0x4(%eax),%al
  800087:	84 c0                	test   %al,%al
  800089:	74 06                	je     800091 <_main+0x59>
			{
				fullWS = 0;
  80008b:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80008f:	eb 12                	jmp    8000a3 <_main+0x6b>
	sys_set_uheap_strategy(UHP_PLACE_NEXTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800091:	ff 45 f0             	incl   -0x10(%ebp)
  800094:	a1 20 50 80 00       	mov    0x805020,%eax
  800099:	8b 50 74             	mov    0x74(%eax),%edx
  80009c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80009f:	39 c2                	cmp    %eax,%edx
  8000a1:	77 c8                	ja     80006b <_main+0x33>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  8000a3:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  8000a7:	74 14                	je     8000bd <_main+0x85>
  8000a9:	83 ec 04             	sub    $0x4,%esp
  8000ac:	68 c0 3c 80 00       	push   $0x803cc0
  8000b1:	6a 18                	push   $0x18
  8000b3:	68 dc 3c 80 00       	push   $0x803cdc
  8000b8:	e8 6b 0c 00 00       	call   800d28 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000bd:	83 ec 0c             	sub    $0xc,%esp
  8000c0:	6a 00                	push   $0x0
  8000c2:	e8 8e 1e 00 00       	call   801f55 <malloc>
  8000c7:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	//Make sure that the heap size is 512 MB
	int numOf2MBsInHeap = (USER_HEAP_MAX - USER_HEAP_START) / (2*Mega);
  8000ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000cd:	01 c0                	add    %eax,%eax
  8000cf:	89 c7                	mov    %eax,%edi
  8000d1:	b8 00 00 00 20       	mov    $0x20000000,%eax
  8000d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8000db:	f7 f7                	div    %edi
  8000dd:	89 45 d0             	mov    %eax,-0x30(%ebp)
	assert(numOf2MBsInHeap == 256);
  8000e0:	81 7d d0 00 01 00 00 	cmpl   $0x100,-0x30(%ebp)
  8000e7:	74 16                	je     8000ff <_main+0xc7>
  8000e9:	68 ef 3c 80 00       	push   $0x803cef
  8000ee:	68 06 3d 80 00       	push   $0x803d06
  8000f3:	6a 20                	push   $0x20
  8000f5:	68 dc 3c 80 00       	push   $0x803cdc
  8000fa:	e8 29 0c 00 00       	call   800d28 <_panic>




	sys_set_uheap_strategy(UHP_PLACE_NEXTFIT);
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	6a 03                	push   $0x3
  800104:	e8 a0 27 00 00       	call   8028a9 <sys_set_uheap_strategy>
  800109:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80010c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800110:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800117:	eb 29                	jmp    800142 <_main+0x10a>
		{
			if (myEnv->__uptr_pws[i].empty)
  800119:	a1 20 50 80 00       	mov    0x805020,%eax
  80011e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800124:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800127:	89 d0                	mov    %edx,%eax
  800129:	01 c0                	add    %eax,%eax
  80012b:	01 d0                	add    %edx,%eax
  80012d:	c1 e0 03             	shl    $0x3,%eax
  800130:	01 c8                	add    %ecx,%eax
  800132:	8a 40 04             	mov    0x4(%eax),%al
  800135:	84 c0                	test   %al,%al
  800137:	74 06                	je     80013f <_main+0x107>
			{
				fullWS = 0;
  800139:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
				break;
  80013d:	eb 12                	jmp    800151 <_main+0x119>
	sys_set_uheap_strategy(UHP_PLACE_NEXTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80013f:	ff 45 e8             	incl   -0x18(%ebp)
  800142:	a1 20 50 80 00       	mov    0x805020,%eax
  800147:	8b 50 74             	mov    0x74(%eax),%edx
  80014a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80014d:	39 c2                	cmp    %eax,%edx
  80014f:	77 c8                	ja     800119 <_main+0xe1>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800151:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  800155:	74 14                	je     80016b <_main+0x133>
  800157:	83 ec 04             	sub    $0x4,%esp
  80015a:	68 c0 3c 80 00       	push   $0x803cc0
  80015f:	6a 32                	push   $0x32
  800161:	68 dc 3c 80 00       	push   $0x803cdc
  800166:	e8 bd 0b 00 00       	call   800d28 <_panic>

	int freeFrames ;
	int usedDiskPages;

	//[0] Make sure there're available places in the WS
	int w = 0 ;
  80016b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	int requiredNumOfEmptyWSLocs = 2;
  800172:	c7 45 cc 02 00 00 00 	movl   $0x2,-0x34(%ebp)
	int numOfEmptyWSLocs = 0;
  800179:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	for (w = 0 ; w < myEnv->page_WS_max_size ; w++)
  800180:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800187:	eb 26                	jmp    8001af <_main+0x177>
	{
		if( myEnv->__uptr_pws[w].empty == 1)
  800189:	a1 20 50 80 00       	mov    0x805020,%eax
  80018e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800194:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800197:	89 d0                	mov    %edx,%eax
  800199:	01 c0                	add    %eax,%eax
  80019b:	01 d0                	add    %edx,%eax
  80019d:	c1 e0 03             	shl    $0x3,%eax
  8001a0:	01 c8                	add    %ecx,%eax
  8001a2:	8a 40 04             	mov    0x4(%eax),%al
  8001a5:	3c 01                	cmp    $0x1,%al
  8001a7:	75 03                	jne    8001ac <_main+0x174>
			numOfEmptyWSLocs++;
  8001a9:	ff 45 e0             	incl   -0x20(%ebp)

	//[0] Make sure there're available places in the WS
	int w = 0 ;
	int requiredNumOfEmptyWSLocs = 2;
	int numOfEmptyWSLocs = 0;
	for (w = 0 ; w < myEnv->page_WS_max_size ; w++)
  8001ac:	ff 45 e4             	incl   -0x1c(%ebp)
  8001af:	a1 20 50 80 00       	mov    0x805020,%eax
  8001b4:	8b 50 74             	mov    0x74(%eax),%edx
  8001b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001ba:	39 c2                	cmp    %eax,%edx
  8001bc:	77 cb                	ja     800189 <_main+0x151>
	{
		if( myEnv->__uptr_pws[w].empty == 1)
			numOfEmptyWSLocs++;
	}
	if (numOfEmptyWSLocs < requiredNumOfEmptyWSLocs)
  8001be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001c1:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8001c4:	7d 14                	jge    8001da <_main+0x1a2>
		panic("Insufficient number of WS empty locations! please increase the PAGE_WS_MAX_SIZE");
  8001c6:	83 ec 04             	sub    $0x4,%esp
  8001c9:	68 1c 3d 80 00       	push   $0x803d1c
  8001ce:	6a 43                	push   $0x43
  8001d0:	68 dc 3c 80 00       	push   $0x803cdc
  8001d5:	e8 4e 0b 00 00       	call   800d28 <_panic>


	void* ptr_allocations[512] = {0};
  8001da:	8d 95 c0 f7 ff ff    	lea    -0x840(%ebp),%edx
  8001e0:	b9 00 02 00 00       	mov    $0x200,%ecx
  8001e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8001ea:	89 d7                	mov    %edx,%edi
  8001ec:	f3 ab                	rep stos %eax,%es:(%edi)
	int i;

	cprintf("This test has THREE cases. A pass message will be displayed after each one.\n");
  8001ee:	83 ec 0c             	sub    $0xc,%esp
  8001f1:	68 6c 3d 80 00       	push   $0x803d6c
  8001f6:	e8 e1 0d 00 00       	call   800fdc <cprintf>
  8001fb:	83 c4 10             	add    $0x10,%esp

	// allocate pages
	freeFrames = sys_calculate_free_frames() ;
  8001fe:	e8 91 21 00 00       	call   802394 <sys_calculate_free_frames>
  800203:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800206:	e8 29 22 00 00       	call   802434 <sys_pf_calculate_allocated_pages>
  80020b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	for(i = 0; i< 256;i++)
  80020e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800215:	eb 20                	jmp    800237 <_main+0x1ff>
	{
		ptr_allocations[i] = malloc(2*Mega);
  800217:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80021a:	01 c0                	add    %eax,%eax
  80021c:	83 ec 0c             	sub    $0xc,%esp
  80021f:	50                   	push   %eax
  800220:	e8 30 1d 00 00       	call   801f55 <malloc>
  800225:	83 c4 10             	add    $0x10,%esp
  800228:	89 c2                	mov    %eax,%edx
  80022a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80022d:	89 94 85 c0 f7 ff ff 	mov    %edx,-0x840(%ebp,%eax,4)
	cprintf("This test has THREE cases. A pass message will be displayed after each one.\n");

	// allocate pages
	freeFrames = sys_calculate_free_frames() ;
	usedDiskPages = sys_pf_calculate_allocated_pages();
	for(i = 0; i< 256;i++)
  800234:	ff 45 dc             	incl   -0x24(%ebp)
  800237:	81 7d dc ff 00 00 00 	cmpl   $0xff,-0x24(%ebp)
  80023e:	7e d7                	jle    800217 <_main+0x1df>
	{
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
  800240:	8b 85 c0 f7 ff ff    	mov    -0x840(%ebp),%eax
  800246:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  80024b:	75 5b                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[2] != 0x80400000 ||
  80024d:	8b 85 c8 f7 ff ff    	mov    -0x838(%ebp),%eax
	{
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
  800253:	3d 00 00 40 80       	cmp    $0x80400000,%eax
  800258:	75 4e                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
  80025a:	8b 85 e0 f7 ff ff    	mov    -0x820(%ebp),%eax
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
  800260:	3d 00 00 00 81       	cmp    $0x81000000,%eax
  800265:	75 41                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
  800267:	8b 85 e8 f7 ff ff    	mov    -0x818(%ebp),%eax
	}

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
  80026d:	3d 00 00 40 81       	cmp    $0x81400000,%eax
  800272:	75 34                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[10] != 0x81400000 ||
			(uint32)ptr_allocations[15] != 0x81e00000 ||
  800274:	8b 85 fc f7 ff ff    	mov    -0x804(%ebp),%eax

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
  80027a:	3d 00 00 e0 81       	cmp    $0x81e00000,%eax
  80027f:	75 27                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[15] != 0x81e00000 ||
			(uint32)ptr_allocations[20] != 0x82800000 ||
  800281:	8b 85 10 f8 ff ff    	mov    -0x7f0(%ebp),%eax
	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
			(uint32)ptr_allocations[15] != 0x81e00000 ||
  800287:	3d 00 00 80 82       	cmp    $0x82800000,%eax
  80028c:	75 1a                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[20] != 0x82800000 ||
			(uint32)ptr_allocations[25] != 0x83200000 ||
  80028e:	8b 85 24 f8 ff ff    	mov    -0x7dc(%ebp),%eax
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
			(uint32)ptr_allocations[15] != 0x81e00000 ||
			(uint32)ptr_allocations[20] != 0x82800000 ||
  800294:	3d 00 00 20 83       	cmp    $0x83200000,%eax
  800299:	75 0d                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[25] != 0x83200000 ||
			(uint32)ptr_allocations[255] != 0x9FE00000)
  80029b:	8b 85 bc fb ff ff    	mov    -0x444(%ebp),%eax
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
			(uint32)ptr_allocations[15] != 0x81e00000 ||
			(uint32)ptr_allocations[20] != 0x82800000 ||
			(uint32)ptr_allocations[25] != 0x83200000 ||
  8002a1:	3d 00 00 e0 9f       	cmp    $0x9fe00000,%eax
  8002a6:	74 14                	je     8002bc <_main+0x284>
			(uint32)ptr_allocations[255] != 0x9FE00000)
		panic("Wrong allocation, Check fitting strategy is working correctly");
  8002a8:	83 ec 04             	sub    $0x4,%esp
  8002ab:	68 bc 3d 80 00       	push   $0x803dbc
  8002b0:	6a 5c                	push   $0x5c
  8002b2:	68 dc 3c 80 00       	push   $0x803cdc
  8002b7:	e8 6c 0a 00 00       	call   800d28 <_panic>

	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8002bc:	e8 73 21 00 00       	call   802434 <sys_pf_calculate_allocated_pages>
  8002c1:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8002c4:	89 c2                	mov    %eax,%edx
  8002c6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002c9:	c1 e0 09             	shl    $0x9,%eax
  8002cc:	85 c0                	test   %eax,%eax
  8002ce:	79 05                	jns    8002d5 <_main+0x29d>
  8002d0:	05 ff 0f 00 00       	add    $0xfff,%eax
  8002d5:	c1 f8 0c             	sar    $0xc,%eax
  8002d8:	39 c2                	cmp    %eax,%edx
  8002da:	74 14                	je     8002f0 <_main+0x2b8>
  8002dc:	83 ec 04             	sub    $0x4,%esp
  8002df:	68 fa 3d 80 00       	push   $0x803dfa
  8002e4:	6a 5e                	push   $0x5e
  8002e6:	68 dc 3c 80 00       	push   $0x803cdc
  8002eb:	e8 38 0a 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != (512*Mega)/(1024*PAGE_SIZE) ) panic("Wrong allocation");
  8002f0:	8b 5d c8             	mov    -0x38(%ebp),%ebx
  8002f3:	e8 9c 20 00 00       	call   802394 <sys_calculate_free_frames>
  8002f8:	29 c3                	sub    %eax,%ebx
  8002fa:	89 da                	mov    %ebx,%edx
  8002fc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002ff:	c1 e0 09             	shl    $0x9,%eax
  800302:	85 c0                	test   %eax,%eax
  800304:	79 05                	jns    80030b <_main+0x2d3>
  800306:	05 ff ff 3f 00       	add    $0x3fffff,%eax
  80030b:	c1 f8 16             	sar    $0x16,%eax
  80030e:	39 c2                	cmp    %eax,%edx
  800310:	74 14                	je     800326 <_main+0x2ee>
  800312:	83 ec 04             	sub    $0x4,%esp
  800315:	68 17 3e 80 00       	push   $0x803e17
  80031a:	6a 5f                	push   $0x5f
  80031c:	68 dc 3c 80 00       	push   $0x803cdc
  800321:	e8 02 0a 00 00       	call   800d28 <_panic>

	// Make memory holes.
	freeFrames = sys_calculate_free_frames() ;
  800326:	e8 69 20 00 00       	call   802394 <sys_calculate_free_frames>
  80032b:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80032e:	e8 01 21 00 00       	call   802434 <sys_pf_calculate_allocated_pages>
  800333:	89 45 c4             	mov    %eax,-0x3c(%ebp)

	free(ptr_allocations[0]);		// Hole 1 = 2 M
  800336:	8b 85 c0 f7 ff ff    	mov    -0x840(%ebp),%eax
  80033c:	83 ec 0c             	sub    $0xc,%esp
  80033f:	50                   	push   %eax
  800340:	e8 a7 1c 00 00       	call   801fec <free>
  800345:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[2]);		// Hole 2 = 4 M
  800348:	8b 85 c8 f7 ff ff    	mov    -0x838(%ebp),%eax
  80034e:	83 ec 0c             	sub    $0xc,%esp
  800351:	50                   	push   %eax
  800352:	e8 95 1c 00 00       	call   801fec <free>
  800357:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[3]);
  80035a:	8b 85 cc f7 ff ff    	mov    -0x834(%ebp),%eax
  800360:	83 ec 0c             	sub    $0xc,%esp
  800363:	50                   	push   %eax
  800364:	e8 83 1c 00 00       	call   801fec <free>
  800369:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[5]);		// Hole 3 = 2 M
  80036c:	8b 85 d4 f7 ff ff    	mov    -0x82c(%ebp),%eax
  800372:	83 ec 0c             	sub    $0xc,%esp
  800375:	50                   	push   %eax
  800376:	e8 71 1c 00 00       	call   801fec <free>
  80037b:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[10]);		// Hole 4 = 6 M
  80037e:	8b 85 e8 f7 ff ff    	mov    -0x818(%ebp),%eax
  800384:	83 ec 0c             	sub    $0xc,%esp
  800387:	50                   	push   %eax
  800388:	e8 5f 1c 00 00       	call   801fec <free>
  80038d:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[12]);
  800390:	8b 85 f0 f7 ff ff    	mov    -0x810(%ebp),%eax
  800396:	83 ec 0c             	sub    $0xc,%esp
  800399:	50                   	push   %eax
  80039a:	e8 4d 1c 00 00       	call   801fec <free>
  80039f:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[11]);
  8003a2:	8b 85 ec f7 ff ff    	mov    -0x814(%ebp),%eax
  8003a8:	83 ec 0c             	sub    $0xc,%esp
  8003ab:	50                   	push   %eax
  8003ac:	e8 3b 1c 00 00       	call   801fec <free>
  8003b1:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[20]);		// Hole 5 = 2 M
  8003b4:	8b 85 10 f8 ff ff    	mov    -0x7f0(%ebp),%eax
  8003ba:	83 ec 0c             	sub    $0xc,%esp
  8003bd:	50                   	push   %eax
  8003be:	e8 29 1c 00 00       	call   801fec <free>
  8003c3:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[25]);		// Hole 6 = 2 M
  8003c6:	8b 85 24 f8 ff ff    	mov    -0x7dc(%ebp),%eax
  8003cc:	83 ec 0c             	sub    $0xc,%esp
  8003cf:	50                   	push   %eax
  8003d0:	e8 17 1c 00 00       	call   801fec <free>
  8003d5:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[255]);		// Hole 7 = 2 M
  8003d8:	8b 85 bc fb ff ff    	mov    -0x444(%ebp),%eax
  8003de:	83 ec 0c             	sub    $0xc,%esp
  8003e1:	50                   	push   %eax
  8003e2:	e8 05 1c 00 00       	call   801fec <free>
  8003e7:	83 c4 10             	add    $0x10,%esp

	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 10*(2*Mega)/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  8003ea:	e8 45 20 00 00       	call   802434 <sys_pf_calculate_allocated_pages>
  8003ef:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8003f2:	89 d1                	mov    %edx,%ecx
  8003f4:	29 c1                	sub    %eax,%ecx
  8003f6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003f9:	89 d0                	mov    %edx,%eax
  8003fb:	c1 e0 02             	shl    $0x2,%eax
  8003fe:	01 d0                	add    %edx,%eax
  800400:	c1 e0 02             	shl    $0x2,%eax
  800403:	85 c0                	test   %eax,%eax
  800405:	79 05                	jns    80040c <_main+0x3d4>
  800407:	05 ff 0f 00 00       	add    $0xfff,%eax
  80040c:	c1 f8 0c             	sar    $0xc,%eax
  80040f:	39 c1                	cmp    %eax,%ecx
  800411:	74 14                	je     800427 <_main+0x3ef>
  800413:	83 ec 04             	sub    $0x4,%esp
  800416:	68 28 3e 80 00       	push   $0x803e28
  80041b:	6a 70                	push   $0x70
  80041d:	68 dc 3c 80 00       	push   $0x803cdc
  800422:	e8 01 09 00 00       	call   800d28 <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  800427:	e8 68 1f 00 00       	call   802394 <sys_calculate_free_frames>
  80042c:	89 c2                	mov    %eax,%edx
  80042e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800431:	39 c2                	cmp    %eax,%edx
  800433:	74 14                	je     800449 <_main+0x411>
  800435:	83 ec 04             	sub    $0x4,%esp
  800438:	68 64 3e 80 00       	push   $0x803e64
  80043d:	6a 71                	push   $0x71
  80043f:	68 dc 3c 80 00       	push   $0x803cdc
  800444:	e8 df 08 00 00       	call   800d28 <_panic>

	// Test next fit

	freeFrames = sys_calculate_free_frames() ;
  800449:	e8 46 1f 00 00       	call   802394 <sys_calculate_free_frames>
  80044e:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800451:	e8 de 1f 00 00       	call   802434 <sys_pf_calculate_allocated_pages>
  800456:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	void* tempAddress = malloc(Mega-kilo);		// Use Hole 1 -> Hole 1 = 1 M
  800459:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80045c:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80045f:	83 ec 0c             	sub    $0xc,%esp
  800462:	50                   	push   %eax
  800463:	e8 ed 1a 00 00       	call   801f55 <malloc>
  800468:	83 c4 10             	add    $0x10,%esp
  80046b:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x80000000)
  80046e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800471:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800476:	74 14                	je     80048c <_main+0x454>
		panic("Next Fit not working correctly");
  800478:	83 ec 04             	sub    $0x4,%esp
  80047b:	68 a4 3e 80 00       	push   $0x803ea4
  800480:	6a 79                	push   $0x79
  800482:	68 dc 3c 80 00       	push   $0x803cdc
  800487:	e8 9c 08 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  80048c:	e8 a3 1f 00 00       	call   802434 <sys_pf_calculate_allocated_pages>
  800491:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800494:	89 c2                	mov    %eax,%edx
  800496:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800499:	85 c0                	test   %eax,%eax
  80049b:	79 05                	jns    8004a2 <_main+0x46a>
  80049d:	05 ff 0f 00 00       	add    $0xfff,%eax
  8004a2:	c1 f8 0c             	sar    $0xc,%eax
  8004a5:	39 c2                	cmp    %eax,%edx
  8004a7:	74 14                	je     8004bd <_main+0x485>
  8004a9:	83 ec 04             	sub    $0x4,%esp
  8004ac:	68 fa 3d 80 00       	push   $0x803dfa
  8004b1:	6a 7a                	push   $0x7a
  8004b3:	68 dc 3c 80 00       	push   $0x803cdc
  8004b8:	e8 6b 08 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8004bd:	e8 d2 1e 00 00       	call   802394 <sys_calculate_free_frames>
  8004c2:	89 c2                	mov    %eax,%edx
  8004c4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004c7:	39 c2                	cmp    %eax,%edx
  8004c9:	74 14                	je     8004df <_main+0x4a7>
  8004cb:	83 ec 04             	sub    $0x4,%esp
  8004ce:	68 17 3e 80 00       	push   $0x803e17
  8004d3:	6a 7b                	push   $0x7b
  8004d5:	68 dc 3c 80 00       	push   $0x803cdc
  8004da:	e8 49 08 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  8004df:	e8 b0 1e 00 00       	call   802394 <sys_calculate_free_frames>
  8004e4:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8004e7:	e8 48 1f 00 00       	call   802434 <sys_pf_calculate_allocated_pages>
  8004ec:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(kilo);					// Use Hole 1 -> Hole 1 = 1 M - Kilo
  8004ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004f2:	83 ec 0c             	sub    $0xc,%esp
  8004f5:	50                   	push   %eax
  8004f6:	e8 5a 1a 00 00       	call   801f55 <malloc>
  8004fb:	83 c4 10             	add    $0x10,%esp
  8004fe:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x80100000)
  800501:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800504:	3d 00 00 10 80       	cmp    $0x80100000,%eax
  800509:	74 17                	je     800522 <_main+0x4ea>
		panic("Next Fit not working correctly");
  80050b:	83 ec 04             	sub    $0x4,%esp
  80050e:	68 a4 3e 80 00       	push   $0x803ea4
  800513:	68 81 00 00 00       	push   $0x81
  800518:	68 dc 3c 80 00       	push   $0x803cdc
  80051d:	e8 06 08 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800522:	e8 0d 1f 00 00       	call   802434 <sys_pf_calculate_allocated_pages>
  800527:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80052a:	89 c2                	mov    %eax,%edx
  80052c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80052f:	c1 e0 02             	shl    $0x2,%eax
  800532:	85 c0                	test   %eax,%eax
  800534:	79 05                	jns    80053b <_main+0x503>
  800536:	05 ff 0f 00 00       	add    $0xfff,%eax
  80053b:	c1 f8 0c             	sar    $0xc,%eax
  80053e:	39 c2                	cmp    %eax,%edx
  800540:	74 17                	je     800559 <_main+0x521>
  800542:	83 ec 04             	sub    $0x4,%esp
  800545:	68 fa 3d 80 00       	push   $0x803dfa
  80054a:	68 82 00 00 00       	push   $0x82
  80054f:	68 dc 3c 80 00       	push   $0x803cdc
  800554:	e8 cf 07 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800559:	e8 36 1e 00 00       	call   802394 <sys_calculate_free_frames>
  80055e:	89 c2                	mov    %eax,%edx
  800560:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800563:	39 c2                	cmp    %eax,%edx
  800565:	74 17                	je     80057e <_main+0x546>
  800567:	83 ec 04             	sub    $0x4,%esp
  80056a:	68 17 3e 80 00       	push   $0x803e17
  80056f:	68 83 00 00 00       	push   $0x83
  800574:	68 dc 3c 80 00       	push   $0x803cdc
  800579:	e8 aa 07 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  80057e:	e8 11 1e 00 00       	call   802394 <sys_calculate_free_frames>
  800583:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800586:	e8 a9 1e 00 00       	call   802434 <sys_pf_calculate_allocated_pages>
  80058b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(5*Mega); 			   // Use Hole 4 -> Hole 4 = 1 M
  80058e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800591:	89 d0                	mov    %edx,%eax
  800593:	c1 e0 02             	shl    $0x2,%eax
  800596:	01 d0                	add    %edx,%eax
  800598:	83 ec 0c             	sub    $0xc,%esp
  80059b:	50                   	push   %eax
  80059c:	e8 b4 19 00 00       	call   801f55 <malloc>
  8005a1:	83 c4 10             	add    $0x10,%esp
  8005a4:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x81400000)
  8005a7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8005aa:	3d 00 00 40 81       	cmp    $0x81400000,%eax
  8005af:	74 17                	je     8005c8 <_main+0x590>
		panic("Next Fit not working correctly");
  8005b1:	83 ec 04             	sub    $0x4,%esp
  8005b4:	68 a4 3e 80 00       	push   $0x803ea4
  8005b9:	68 89 00 00 00       	push   $0x89
  8005be:	68 dc 3c 80 00       	push   $0x803cdc
  8005c3:	e8 60 07 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8005c8:	e8 67 1e 00 00       	call   802434 <sys_pf_calculate_allocated_pages>
  8005cd:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8005d0:	89 c1                	mov    %eax,%ecx
  8005d2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005d5:	89 d0                	mov    %edx,%eax
  8005d7:	c1 e0 02             	shl    $0x2,%eax
  8005da:	01 d0                	add    %edx,%eax
  8005dc:	85 c0                	test   %eax,%eax
  8005de:	79 05                	jns    8005e5 <_main+0x5ad>
  8005e0:	05 ff 0f 00 00       	add    $0xfff,%eax
  8005e5:	c1 f8 0c             	sar    $0xc,%eax
  8005e8:	39 c1                	cmp    %eax,%ecx
  8005ea:	74 17                	je     800603 <_main+0x5cb>
  8005ec:	83 ec 04             	sub    $0x4,%esp
  8005ef:	68 fa 3d 80 00       	push   $0x803dfa
  8005f4:	68 8a 00 00 00       	push   $0x8a
  8005f9:	68 dc 3c 80 00       	push   $0x803cdc
  8005fe:	e8 25 07 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800603:	e8 8c 1d 00 00       	call   802394 <sys_calculate_free_frames>
  800608:	89 c2                	mov    %eax,%edx
  80060a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80060d:	39 c2                	cmp    %eax,%edx
  80060f:	74 17                	je     800628 <_main+0x5f0>
  800611:	83 ec 04             	sub    $0x4,%esp
  800614:	68 17 3e 80 00       	push   $0x803e17
  800619:	68 8b 00 00 00       	push   $0x8b
  80061e:	68 dc 3c 80 00       	push   $0x803cdc
  800623:	e8 00 07 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  800628:	e8 67 1d 00 00       	call   802394 <sys_calculate_free_frames>
  80062d:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800630:	e8 ff 1d 00 00       	call   802434 <sys_pf_calculate_allocated_pages>
  800635:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(1*Mega); 			   // Use Hole 4 -> Hole 4 = 0 M
  800638:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80063b:	83 ec 0c             	sub    $0xc,%esp
  80063e:	50                   	push   %eax
  80063f:	e8 11 19 00 00       	call   801f55 <malloc>
  800644:	83 c4 10             	add    $0x10,%esp
  800647:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x81900000)
  80064a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80064d:	3d 00 00 90 81       	cmp    $0x81900000,%eax
  800652:	74 17                	je     80066b <_main+0x633>
		panic("Next Fit not working correctly");
  800654:	83 ec 04             	sub    $0x4,%esp
  800657:	68 a4 3e 80 00       	push   $0x803ea4
  80065c:	68 91 00 00 00       	push   $0x91
  800661:	68 dc 3c 80 00       	push   $0x803cdc
  800666:	e8 bd 06 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  80066b:	e8 c4 1d 00 00       	call   802434 <sys_pf_calculate_allocated_pages>
  800670:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800673:	89 c2                	mov    %eax,%edx
  800675:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800678:	85 c0                	test   %eax,%eax
  80067a:	79 05                	jns    800681 <_main+0x649>
  80067c:	05 ff 0f 00 00       	add    $0xfff,%eax
  800681:	c1 f8 0c             	sar    $0xc,%eax
  800684:	39 c2                	cmp    %eax,%edx
  800686:	74 17                	je     80069f <_main+0x667>
  800688:	83 ec 04             	sub    $0x4,%esp
  80068b:	68 fa 3d 80 00       	push   $0x803dfa
  800690:	68 92 00 00 00       	push   $0x92
  800695:	68 dc 3c 80 00       	push   $0x803cdc
  80069a:	e8 89 06 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  80069f:	e8 f0 1c 00 00       	call   802394 <sys_calculate_free_frames>
  8006a4:	89 c2                	mov    %eax,%edx
  8006a6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8006a9:	39 c2                	cmp    %eax,%edx
  8006ab:	74 17                	je     8006c4 <_main+0x68c>
  8006ad:	83 ec 04             	sub    $0x4,%esp
  8006b0:	68 17 3e 80 00       	push   $0x803e17
  8006b5:	68 93 00 00 00       	push   $0x93
  8006ba:	68 dc 3c 80 00       	push   $0x803cdc
  8006bf:	e8 64 06 00 00       	call   800d28 <_panic>


	freeFrames = sys_calculate_free_frames() ;
  8006c4:	e8 cb 1c 00 00       	call   802394 <sys_calculate_free_frames>
  8006c9:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8006cc:	e8 63 1d 00 00       	call   802434 <sys_pf_calculate_allocated_pages>
  8006d1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	free(ptr_allocations[15]);					// Make a new hole => 2 M
  8006d4:	8b 85 fc f7 ff ff    	mov    -0x804(%ebp),%eax
  8006da:	83 ec 0c             	sub    $0xc,%esp
  8006dd:	50                   	push   %eax
  8006de:	e8 09 19 00 00       	call   801fec <free>
  8006e3:	83 c4 10             	add    $0x10,%esp
	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 2*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  8006e6:	e8 49 1d 00 00       	call   802434 <sys_pf_calculate_allocated_pages>
  8006eb:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8006ee:	29 c2                	sub    %eax,%edx
  8006f0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006f3:	01 c0                	add    %eax,%eax
  8006f5:	85 c0                	test   %eax,%eax
  8006f7:	79 05                	jns    8006fe <_main+0x6c6>
  8006f9:	05 ff 0f 00 00       	add    $0xfff,%eax
  8006fe:	c1 f8 0c             	sar    $0xc,%eax
  800701:	39 c2                	cmp    %eax,%edx
  800703:	74 17                	je     80071c <_main+0x6e4>
  800705:	83 ec 04             	sub    $0x4,%esp
  800708:	68 28 3e 80 00       	push   $0x803e28
  80070d:	68 99 00 00 00       	push   $0x99
  800712:	68 dc 3c 80 00       	push   $0x803cdc
  800717:	e8 0c 06 00 00       	call   800d28 <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  80071c:	e8 73 1c 00 00       	call   802394 <sys_calculate_free_frames>
  800721:	89 c2                	mov    %eax,%edx
  800723:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800726:	39 c2                	cmp    %eax,%edx
  800728:	74 17                	je     800741 <_main+0x709>
  80072a:	83 ec 04             	sub    $0x4,%esp
  80072d:	68 64 3e 80 00       	push   $0x803e64
  800732:	68 9a 00 00 00       	push   $0x9a
  800737:	68 dc 3c 80 00       	push   $0x803cdc
  80073c:	e8 e7 05 00 00       	call   800d28 <_panic>

	//[NEXT FIT Case]
	freeFrames = sys_calculate_free_frames() ;
  800741:	e8 4e 1c 00 00       	call   802394 <sys_calculate_free_frames>
  800746:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800749:	e8 e6 1c 00 00       	call   802434 <sys_pf_calculate_allocated_pages>
  80074e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(kilo); 			   // Use new Hole = 2 M - 4 kilo
  800751:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800754:	83 ec 0c             	sub    $0xc,%esp
  800757:	50                   	push   %eax
  800758:	e8 f8 17 00 00       	call   801f55 <malloc>
  80075d:	83 c4 10             	add    $0x10,%esp
  800760:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x81E00000)
  800763:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800766:	3d 00 00 e0 81       	cmp    $0x81e00000,%eax
  80076b:	74 17                	je     800784 <_main+0x74c>
		panic("Next Fit not working correctly");
  80076d:	83 ec 04             	sub    $0x4,%esp
  800770:	68 a4 3e 80 00       	push   $0x803ea4
  800775:	68 a1 00 00 00       	push   $0xa1
  80077a:	68 dc 3c 80 00       	push   $0x803cdc
  80077f:	e8 a4 05 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800784:	e8 ab 1c 00 00       	call   802434 <sys_pf_calculate_allocated_pages>
  800789:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80078c:	89 c2                	mov    %eax,%edx
  80078e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800791:	c1 e0 02             	shl    $0x2,%eax
  800794:	85 c0                	test   %eax,%eax
  800796:	79 05                	jns    80079d <_main+0x765>
  800798:	05 ff 0f 00 00       	add    $0xfff,%eax
  80079d:	c1 f8 0c             	sar    $0xc,%eax
  8007a0:	39 c2                	cmp    %eax,%edx
  8007a2:	74 17                	je     8007bb <_main+0x783>
  8007a4:	83 ec 04             	sub    $0x4,%esp
  8007a7:	68 fa 3d 80 00       	push   $0x803dfa
  8007ac:	68 a2 00 00 00       	push   $0xa2
  8007b1:	68 dc 3c 80 00       	push   $0x803cdc
  8007b6:	e8 6d 05 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8007bb:	e8 d4 1b 00 00       	call   802394 <sys_calculate_free_frames>
  8007c0:	89 c2                	mov    %eax,%edx
  8007c2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8007c5:	39 c2                	cmp    %eax,%edx
  8007c7:	74 17                	je     8007e0 <_main+0x7a8>
  8007c9:	83 ec 04             	sub    $0x4,%esp
  8007cc:	68 17 3e 80 00       	push   $0x803e17
  8007d1:	68 a3 00 00 00       	push   $0xa3
  8007d6:	68 dc 3c 80 00       	push   $0x803cdc
  8007db:	e8 48 05 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  8007e0:	e8 af 1b 00 00       	call   802394 <sys_calculate_free_frames>
  8007e5:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8007e8:	e8 47 1c 00 00       	call   802434 <sys_pf_calculate_allocated_pages>
  8007ed:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(Mega + 1016*kilo); 	// Use new Hole = 4 kilo
  8007f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8007f3:	c1 e0 03             	shl    $0x3,%eax
  8007f6:	89 c2                	mov    %eax,%edx
  8007f8:	c1 e2 07             	shl    $0x7,%edx
  8007fb:	29 c2                	sub    %eax,%edx
  8007fd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800800:	01 d0                	add    %edx,%eax
  800802:	83 ec 0c             	sub    $0xc,%esp
  800805:	50                   	push   %eax
  800806:	e8 4a 17 00 00       	call   801f55 <malloc>
  80080b:	83 c4 10             	add    $0x10,%esp
  80080e:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x81E01000)
  800811:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800814:	3d 00 10 e0 81       	cmp    $0x81e01000,%eax
  800819:	74 17                	je     800832 <_main+0x7fa>
		panic("Next Fit not working correctly");
  80081b:	83 ec 04             	sub    $0x4,%esp
  80081e:	68 a4 3e 80 00       	push   $0x803ea4
  800823:	68 a9 00 00 00       	push   $0xa9
  800828:	68 dc 3c 80 00       	push   $0x803cdc
  80082d:	e8 f6 04 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (1*Mega+1016*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  800832:	e8 fd 1b 00 00       	call   802434 <sys_pf_calculate_allocated_pages>
  800837:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80083a:	89 c2                	mov    %eax,%edx
  80083c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80083f:	c1 e0 03             	shl    $0x3,%eax
  800842:	89 c1                	mov    %eax,%ecx
  800844:	c1 e1 07             	shl    $0x7,%ecx
  800847:	29 c1                	sub    %eax,%ecx
  800849:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80084c:	01 c8                	add    %ecx,%eax
  80084e:	85 c0                	test   %eax,%eax
  800850:	79 05                	jns    800857 <_main+0x81f>
  800852:	05 ff 0f 00 00       	add    $0xfff,%eax
  800857:	c1 f8 0c             	sar    $0xc,%eax
  80085a:	39 c2                	cmp    %eax,%edx
  80085c:	74 17                	je     800875 <_main+0x83d>
  80085e:	83 ec 04             	sub    $0x4,%esp
  800861:	68 fa 3d 80 00       	push   $0x803dfa
  800866:	68 aa 00 00 00       	push   $0xaa
  80086b:	68 dc 3c 80 00       	push   $0x803cdc
  800870:	e8 b3 04 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800875:	e8 1a 1b 00 00       	call   802394 <sys_calculate_free_frames>
  80087a:	89 c2                	mov    %eax,%edx
  80087c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80087f:	39 c2                	cmp    %eax,%edx
  800881:	74 17                	je     80089a <_main+0x862>
  800883:	83 ec 04             	sub    $0x4,%esp
  800886:	68 17 3e 80 00       	push   $0x803e17
  80088b:	68 ab 00 00 00       	push   $0xab
  800890:	68 dc 3c 80 00       	push   $0x803cdc
  800895:	e8 8e 04 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  80089a:	e8 f5 1a 00 00       	call   802394 <sys_calculate_free_frames>
  80089f:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8008a2:	e8 8d 1b 00 00       	call   802434 <sys_pf_calculate_allocated_pages>
  8008a7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(512*kilo); 			   // Use Hole 5 -> Hole 5 = 1.5 M
  8008aa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8008ad:	c1 e0 09             	shl    $0x9,%eax
  8008b0:	83 ec 0c             	sub    $0xc,%esp
  8008b3:	50                   	push   %eax
  8008b4:	e8 9c 16 00 00       	call   801f55 <malloc>
  8008b9:	83 c4 10             	add    $0x10,%esp
  8008bc:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x82800000)
  8008bf:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8008c2:	3d 00 00 80 82       	cmp    $0x82800000,%eax
  8008c7:	74 17                	je     8008e0 <_main+0x8a8>
		panic("Next Fit not working correctly");
  8008c9:	83 ec 04             	sub    $0x4,%esp
  8008cc:	68 a4 3e 80 00       	push   $0x803ea4
  8008d1:	68 b1 00 00 00       	push   $0xb1
  8008d6:	68 dc 3c 80 00       	push   $0x803cdc
  8008db:	e8 48 04 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  8008e0:	e8 4f 1b 00 00       	call   802434 <sys_pf_calculate_allocated_pages>
  8008e5:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8008e8:	89 c2                	mov    %eax,%edx
  8008ea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8008ed:	c1 e0 09             	shl    $0x9,%eax
  8008f0:	85 c0                	test   %eax,%eax
  8008f2:	79 05                	jns    8008f9 <_main+0x8c1>
  8008f4:	05 ff 0f 00 00       	add    $0xfff,%eax
  8008f9:	c1 f8 0c             	sar    $0xc,%eax
  8008fc:	39 c2                	cmp    %eax,%edx
  8008fe:	74 17                	je     800917 <_main+0x8df>
  800900:	83 ec 04             	sub    $0x4,%esp
  800903:	68 fa 3d 80 00       	push   $0x803dfa
  800908:	68 b2 00 00 00       	push   $0xb2
  80090d:	68 dc 3c 80 00       	push   $0x803cdc
  800912:	e8 11 04 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800917:	e8 78 1a 00 00       	call   802394 <sys_calculate_free_frames>
  80091c:	89 c2                	mov    %eax,%edx
  80091e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800921:	39 c2                	cmp    %eax,%edx
  800923:	74 17                	je     80093c <_main+0x904>
  800925:	83 ec 04             	sub    $0x4,%esp
  800928:	68 17 3e 80 00       	push   $0x803e17
  80092d:	68 b3 00 00 00       	push   $0xb3
  800932:	68 dc 3c 80 00       	push   $0x803cdc
  800937:	e8 ec 03 00 00       	call   800d28 <_panic>

	cprintf("\nCASE1: (next fit without looping back) is succeeded...\n") ;
  80093c:	83 ec 0c             	sub    $0xc,%esp
  80093f:	68 c4 3e 80 00       	push   $0x803ec4
  800944:	e8 93 06 00 00       	call   800fdc <cprintf>
  800949:	83 c4 10             	add    $0x10,%esp

	// Check that next fit is looping back to check for free space
	freeFrames = sys_calculate_free_frames() ;
  80094c:	e8 43 1a 00 00       	call   802394 <sys_calculate_free_frames>
  800951:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800954:	e8 db 1a 00 00       	call   802434 <sys_pf_calculate_allocated_pages>
  800959:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(3*Mega + 512*kilo); 			   // Use Hole 2 -> Hole 2 = 0.5 M
  80095c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80095f:	89 c2                	mov    %eax,%edx
  800961:	01 d2                	add    %edx,%edx
  800963:	01 c2                	add    %eax,%edx
  800965:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800968:	c1 e0 09             	shl    $0x9,%eax
  80096b:	01 d0                	add    %edx,%eax
  80096d:	83 ec 0c             	sub    $0xc,%esp
  800970:	50                   	push   %eax
  800971:	e8 df 15 00 00       	call   801f55 <malloc>
  800976:	83 c4 10             	add    $0x10,%esp
  800979:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x80400000)
  80097c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80097f:	3d 00 00 40 80       	cmp    $0x80400000,%eax
  800984:	74 17                	je     80099d <_main+0x965>
		panic("Next Fit not working correctly");
  800986:	83 ec 04             	sub    $0x4,%esp
  800989:	68 a4 3e 80 00       	push   $0x803ea4
  80098e:	68 bc 00 00 00       	push   $0xbc
  800993:	68 dc 3c 80 00       	push   $0x803cdc
  800998:	e8 8b 03 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (3*Mega+512*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  80099d:	e8 92 1a 00 00       	call   802434 <sys_pf_calculate_allocated_pages>
  8009a2:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8009a5:	89 c2                	mov    %eax,%edx
  8009a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009aa:	89 c1                	mov    %eax,%ecx
  8009ac:	01 c9                	add    %ecx,%ecx
  8009ae:	01 c1                	add    %eax,%ecx
  8009b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8009b3:	c1 e0 09             	shl    $0x9,%eax
  8009b6:	01 c8                	add    %ecx,%eax
  8009b8:	85 c0                	test   %eax,%eax
  8009ba:	79 05                	jns    8009c1 <_main+0x989>
  8009bc:	05 ff 0f 00 00       	add    $0xfff,%eax
  8009c1:	c1 f8 0c             	sar    $0xc,%eax
  8009c4:	39 c2                	cmp    %eax,%edx
  8009c6:	74 17                	je     8009df <_main+0x9a7>
  8009c8:	83 ec 04             	sub    $0x4,%esp
  8009cb:	68 fa 3d 80 00       	push   $0x803dfa
  8009d0:	68 bd 00 00 00       	push   $0xbd
  8009d5:	68 dc 3c 80 00       	push   $0x803cdc
  8009da:	e8 49 03 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8009df:	e8 b0 19 00 00       	call   802394 <sys_calculate_free_frames>
  8009e4:	89 c2                	mov    %eax,%edx
  8009e6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8009e9:	39 c2                	cmp    %eax,%edx
  8009eb:	74 17                	je     800a04 <_main+0x9cc>
  8009ed:	83 ec 04             	sub    $0x4,%esp
  8009f0:	68 17 3e 80 00       	push   $0x803e17
  8009f5:	68 be 00 00 00       	push   $0xbe
  8009fa:	68 dc 3c 80 00       	push   $0x803cdc
  8009ff:	e8 24 03 00 00       	call   800d28 <_panic>


	freeFrames = sys_calculate_free_frames() ;
  800a04:	e8 8b 19 00 00       	call   802394 <sys_calculate_free_frames>
  800a09:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800a0c:	e8 23 1a 00 00       	call   802434 <sys_pf_calculate_allocated_pages>
  800a11:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	free(ptr_allocations[24]);		// Increase size of Hole 6 to 4 M
  800a14:	8b 85 20 f8 ff ff    	mov    -0x7e0(%ebp),%eax
  800a1a:	83 ec 0c             	sub    $0xc,%esp
  800a1d:	50                   	push   %eax
  800a1e:	e8 c9 15 00 00       	call   801fec <free>
  800a23:	83 c4 10             	add    $0x10,%esp
	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 2*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  800a26:	e8 09 1a 00 00       	call   802434 <sys_pf_calculate_allocated_pages>
  800a2b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800a2e:	29 c2                	sub    %eax,%edx
  800a30:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a33:	01 c0                	add    %eax,%eax
  800a35:	85 c0                	test   %eax,%eax
  800a37:	79 05                	jns    800a3e <_main+0xa06>
  800a39:	05 ff 0f 00 00       	add    $0xfff,%eax
  800a3e:	c1 f8 0c             	sar    $0xc,%eax
  800a41:	39 c2                	cmp    %eax,%edx
  800a43:	74 17                	je     800a5c <_main+0xa24>
  800a45:	83 ec 04             	sub    $0x4,%esp
  800a48:	68 28 3e 80 00       	push   $0x803e28
  800a4d:	68 c4 00 00 00       	push   $0xc4
  800a52:	68 dc 3c 80 00       	push   $0x803cdc
  800a57:	e8 cc 02 00 00       	call   800d28 <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  800a5c:	e8 33 19 00 00       	call   802394 <sys_calculate_free_frames>
  800a61:	89 c2                	mov    %eax,%edx
  800a63:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800a66:	39 c2                	cmp    %eax,%edx
  800a68:	74 17                	je     800a81 <_main+0xa49>
  800a6a:	83 ec 04             	sub    $0x4,%esp
  800a6d:	68 64 3e 80 00       	push   $0x803e64
  800a72:	68 c5 00 00 00       	push   $0xc5
  800a77:	68 dc 3c 80 00       	push   $0x803cdc
  800a7c:	e8 a7 02 00 00       	call   800d28 <_panic>


	freeFrames = sys_calculate_free_frames() ;
  800a81:	e8 0e 19 00 00       	call   802394 <sys_calculate_free_frames>
  800a86:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800a89:	e8 a6 19 00 00       	call   802434 <sys_pf_calculate_allocated_pages>
  800a8e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(4*Mega-kilo);		// Use Hole 6 -> Hole 6 = 0 M
  800a91:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a94:	c1 e0 02             	shl    $0x2,%eax
  800a97:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  800a9a:	83 ec 0c             	sub    $0xc,%esp
  800a9d:	50                   	push   %eax
  800a9e:	e8 b2 14 00 00       	call   801f55 <malloc>
  800aa3:	83 c4 10             	add    $0x10,%esp
  800aa6:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x83000000)
  800aa9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800aac:	3d 00 00 00 83       	cmp    $0x83000000,%eax
  800ab1:	74 17                	je     800aca <_main+0xa92>
		panic("Next Fit not working correctly");
  800ab3:	83 ec 04             	sub    $0x4,%esp
  800ab6:	68 a4 3e 80 00       	push   $0x803ea4
  800abb:	68 cc 00 00 00       	push   $0xcc
  800ac0:	68 dc 3c 80 00       	push   $0x803cdc
  800ac5:	e8 5e 02 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800aca:	e8 65 19 00 00       	call   802434 <sys_pf_calculate_allocated_pages>
  800acf:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800ad2:	89 c2                	mov    %eax,%edx
  800ad4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ad7:	c1 e0 02             	shl    $0x2,%eax
  800ada:	85 c0                	test   %eax,%eax
  800adc:	79 05                	jns    800ae3 <_main+0xaab>
  800ade:	05 ff 0f 00 00       	add    $0xfff,%eax
  800ae3:	c1 f8 0c             	sar    $0xc,%eax
  800ae6:	39 c2                	cmp    %eax,%edx
  800ae8:	74 17                	je     800b01 <_main+0xac9>
  800aea:	83 ec 04             	sub    $0x4,%esp
  800aed:	68 fa 3d 80 00       	push   $0x803dfa
  800af2:	68 cd 00 00 00       	push   $0xcd
  800af7:	68 dc 3c 80 00       	push   $0x803cdc
  800afc:	e8 27 02 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800b01:	e8 8e 18 00 00       	call   802394 <sys_calculate_free_frames>
  800b06:	89 c2                	mov    %eax,%edx
  800b08:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800b0b:	39 c2                	cmp    %eax,%edx
  800b0d:	74 17                	je     800b26 <_main+0xaee>
  800b0f:	83 ec 04             	sub    $0x4,%esp
  800b12:	68 17 3e 80 00       	push   $0x803e17
  800b17:	68 ce 00 00 00       	push   $0xce
  800b1c:	68 dc 3c 80 00       	push   $0x803cdc
  800b21:	e8 02 02 00 00       	call   800d28 <_panic>

	cprintf("\nCASE2: (next fit WITH looping back) is succeeded...\n") ;
  800b26:	83 ec 0c             	sub    $0xc,%esp
  800b29:	68 00 3f 80 00       	push   $0x803f00
  800b2e:	e8 a9 04 00 00       	call   800fdc <cprintf>
  800b33:	83 c4 10             	add    $0x10,%esp

	// Check that next fit returns null in case all holes are not free
	freeFrames = sys_calculate_free_frames() ;
  800b36:	e8 59 18 00 00       	call   802394 <sys_calculate_free_frames>
  800b3b:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800b3e:	e8 f1 18 00 00       	call   802434 <sys_pf_calculate_allocated_pages>
  800b43:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(6*Mega); 			   // No Suitable Hole is available
  800b46:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800b49:	89 d0                	mov    %edx,%eax
  800b4b:	01 c0                	add    %eax,%eax
  800b4d:	01 d0                	add    %edx,%eax
  800b4f:	01 c0                	add    %eax,%eax
  800b51:	83 ec 0c             	sub    $0xc,%esp
  800b54:	50                   	push   %eax
  800b55:	e8 fb 13 00 00       	call   801f55 <malloc>
  800b5a:	83 c4 10             	add    $0x10,%esp
  800b5d:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x0)
  800b60:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800b63:	85 c0                	test   %eax,%eax
  800b65:	74 17                	je     800b7e <_main+0xb46>
		panic("Next Fit not working correctly");
  800b67:	83 ec 04             	sub    $0x4,%esp
  800b6a:	68 a4 3e 80 00       	push   $0x803ea4
  800b6f:	68 d7 00 00 00       	push   $0xd7
  800b74:	68 dc 3c 80 00       	push   $0x803cdc
  800b79:	e8 aa 01 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800b7e:	e8 b1 18 00 00       	call   802434 <sys_pf_calculate_allocated_pages>
  800b83:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800b86:	74 17                	je     800b9f <_main+0xb67>
  800b88:	83 ec 04             	sub    $0x4,%esp
  800b8b:	68 fa 3d 80 00       	push   $0x803dfa
  800b90:	68 d8 00 00 00       	push   $0xd8
  800b95:	68 dc 3c 80 00       	push   $0x803cdc
  800b9a:	e8 89 01 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800b9f:	e8 f0 17 00 00       	call   802394 <sys_calculate_free_frames>
  800ba4:	89 c2                	mov    %eax,%edx
  800ba6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800ba9:	39 c2                	cmp    %eax,%edx
  800bab:	74 17                	je     800bc4 <_main+0xb8c>
  800bad:	83 ec 04             	sub    $0x4,%esp
  800bb0:	68 17 3e 80 00       	push   $0x803e17
  800bb5:	68 d9 00 00 00       	push   $0xd9
  800bba:	68 dc 3c 80 00       	push   $0x803cdc
  800bbf:	e8 64 01 00 00       	call   800d28 <_panic>

	cprintf("\nCASE3: (next fit with insufficient space) is succeeded...\n") ;
  800bc4:	83 ec 0c             	sub    $0xc,%esp
  800bc7:	68 38 3f 80 00       	push   $0x803f38
  800bcc:	e8 0b 04 00 00       	call   800fdc <cprintf>
  800bd1:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! test Next Fit completed successfully.\n");
  800bd4:	83 ec 0c             	sub    $0xc,%esp
  800bd7:	68 74 3f 80 00       	push   $0x803f74
  800bdc:	e8 fb 03 00 00       	call   800fdc <cprintf>
  800be1:	83 c4 10             	add    $0x10,%esp

	return;
  800be4:	90                   	nop
}
  800be5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800be8:	5b                   	pop    %ebx
  800be9:	5f                   	pop    %edi
  800bea:	5d                   	pop    %ebp
  800beb:	c3                   	ret    

00800bec <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800bf2:	e8 7d 1a 00 00       	call   802674 <sys_getenvindex>
  800bf7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800bfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bfd:	89 d0                	mov    %edx,%eax
  800bff:	c1 e0 03             	shl    $0x3,%eax
  800c02:	01 d0                	add    %edx,%eax
  800c04:	01 c0                	add    %eax,%eax
  800c06:	01 d0                	add    %edx,%eax
  800c08:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800c0f:	01 d0                	add    %edx,%eax
  800c11:	c1 e0 04             	shl    $0x4,%eax
  800c14:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800c19:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800c1e:	a1 20 50 80 00       	mov    0x805020,%eax
  800c23:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800c29:	84 c0                	test   %al,%al
  800c2b:	74 0f                	je     800c3c <libmain+0x50>
		binaryname = myEnv->prog_name;
  800c2d:	a1 20 50 80 00       	mov    0x805020,%eax
  800c32:	05 5c 05 00 00       	add    $0x55c,%eax
  800c37:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800c3c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c40:	7e 0a                	jle    800c4c <libmain+0x60>
		binaryname = argv[0];
  800c42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c45:	8b 00                	mov    (%eax),%eax
  800c47:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800c4c:	83 ec 08             	sub    $0x8,%esp
  800c4f:	ff 75 0c             	pushl  0xc(%ebp)
  800c52:	ff 75 08             	pushl  0x8(%ebp)
  800c55:	e8 de f3 ff ff       	call   800038 <_main>
  800c5a:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800c5d:	e8 1f 18 00 00       	call   802481 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800c62:	83 ec 0c             	sub    $0xc,%esp
  800c65:	68 c8 3f 80 00       	push   $0x803fc8
  800c6a:	e8 6d 03 00 00       	call   800fdc <cprintf>
  800c6f:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800c72:	a1 20 50 80 00       	mov    0x805020,%eax
  800c77:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800c7d:	a1 20 50 80 00       	mov    0x805020,%eax
  800c82:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800c88:	83 ec 04             	sub    $0x4,%esp
  800c8b:	52                   	push   %edx
  800c8c:	50                   	push   %eax
  800c8d:	68 f0 3f 80 00       	push   $0x803ff0
  800c92:	e8 45 03 00 00       	call   800fdc <cprintf>
  800c97:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800c9a:	a1 20 50 80 00       	mov    0x805020,%eax
  800c9f:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800ca5:	a1 20 50 80 00       	mov    0x805020,%eax
  800caa:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800cb0:	a1 20 50 80 00       	mov    0x805020,%eax
  800cb5:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800cbb:	51                   	push   %ecx
  800cbc:	52                   	push   %edx
  800cbd:	50                   	push   %eax
  800cbe:	68 18 40 80 00       	push   $0x804018
  800cc3:	e8 14 03 00 00       	call   800fdc <cprintf>
  800cc8:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800ccb:	a1 20 50 80 00       	mov    0x805020,%eax
  800cd0:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800cd6:	83 ec 08             	sub    $0x8,%esp
  800cd9:	50                   	push   %eax
  800cda:	68 70 40 80 00       	push   $0x804070
  800cdf:	e8 f8 02 00 00       	call   800fdc <cprintf>
  800ce4:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800ce7:	83 ec 0c             	sub    $0xc,%esp
  800cea:	68 c8 3f 80 00       	push   $0x803fc8
  800cef:	e8 e8 02 00 00       	call   800fdc <cprintf>
  800cf4:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800cf7:	e8 9f 17 00 00       	call   80249b <sys_enable_interrupt>

	// exit gracefully
	exit();
  800cfc:	e8 19 00 00 00       	call   800d1a <exit>
}
  800d01:	90                   	nop
  800d02:	c9                   	leave  
  800d03:	c3                   	ret    

00800d04 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800d04:	55                   	push   %ebp
  800d05:	89 e5                	mov    %esp,%ebp
  800d07:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800d0a:	83 ec 0c             	sub    $0xc,%esp
  800d0d:	6a 00                	push   $0x0
  800d0f:	e8 2c 19 00 00       	call   802640 <sys_destroy_env>
  800d14:	83 c4 10             	add    $0x10,%esp
}
  800d17:	90                   	nop
  800d18:	c9                   	leave  
  800d19:	c3                   	ret    

00800d1a <exit>:

void
exit(void)
{
  800d1a:	55                   	push   %ebp
  800d1b:	89 e5                	mov    %esp,%ebp
  800d1d:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800d20:	e8 81 19 00 00       	call   8026a6 <sys_exit_env>
}
  800d25:	90                   	nop
  800d26:	c9                   	leave  
  800d27:	c3                   	ret    

00800d28 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800d28:	55                   	push   %ebp
  800d29:	89 e5                	mov    %esp,%ebp
  800d2b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800d2e:	8d 45 10             	lea    0x10(%ebp),%eax
  800d31:	83 c0 04             	add    $0x4,%eax
  800d34:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800d37:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800d3c:	85 c0                	test   %eax,%eax
  800d3e:	74 16                	je     800d56 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800d40:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800d45:	83 ec 08             	sub    $0x8,%esp
  800d48:	50                   	push   %eax
  800d49:	68 84 40 80 00       	push   $0x804084
  800d4e:	e8 89 02 00 00       	call   800fdc <cprintf>
  800d53:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800d56:	a1 00 50 80 00       	mov    0x805000,%eax
  800d5b:	ff 75 0c             	pushl  0xc(%ebp)
  800d5e:	ff 75 08             	pushl  0x8(%ebp)
  800d61:	50                   	push   %eax
  800d62:	68 89 40 80 00       	push   $0x804089
  800d67:	e8 70 02 00 00       	call   800fdc <cprintf>
  800d6c:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800d6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d72:	83 ec 08             	sub    $0x8,%esp
  800d75:	ff 75 f4             	pushl  -0xc(%ebp)
  800d78:	50                   	push   %eax
  800d79:	e8 f3 01 00 00       	call   800f71 <vcprintf>
  800d7e:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800d81:	83 ec 08             	sub    $0x8,%esp
  800d84:	6a 00                	push   $0x0
  800d86:	68 a5 40 80 00       	push   $0x8040a5
  800d8b:	e8 e1 01 00 00       	call   800f71 <vcprintf>
  800d90:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800d93:	e8 82 ff ff ff       	call   800d1a <exit>

	// should not return here
	while (1) ;
  800d98:	eb fe                	jmp    800d98 <_panic+0x70>

00800d9a <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800d9a:	55                   	push   %ebp
  800d9b:	89 e5                	mov    %esp,%ebp
  800d9d:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800da0:	a1 20 50 80 00       	mov    0x805020,%eax
  800da5:	8b 50 74             	mov    0x74(%eax),%edx
  800da8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dab:	39 c2                	cmp    %eax,%edx
  800dad:	74 14                	je     800dc3 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800daf:	83 ec 04             	sub    $0x4,%esp
  800db2:	68 a8 40 80 00       	push   $0x8040a8
  800db7:	6a 26                	push   $0x26
  800db9:	68 f4 40 80 00       	push   $0x8040f4
  800dbe:	e8 65 ff ff ff       	call   800d28 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800dc3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800dca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800dd1:	e9 c2 00 00 00       	jmp    800e98 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800dd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dd9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	01 d0                	add    %edx,%eax
  800de5:	8b 00                	mov    (%eax),%eax
  800de7:	85 c0                	test   %eax,%eax
  800de9:	75 08                	jne    800df3 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800deb:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800dee:	e9 a2 00 00 00       	jmp    800e95 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800df3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800dfa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800e01:	eb 69                	jmp    800e6c <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800e03:	a1 20 50 80 00       	mov    0x805020,%eax
  800e08:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800e0e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800e11:	89 d0                	mov    %edx,%eax
  800e13:	01 c0                	add    %eax,%eax
  800e15:	01 d0                	add    %edx,%eax
  800e17:	c1 e0 03             	shl    $0x3,%eax
  800e1a:	01 c8                	add    %ecx,%eax
  800e1c:	8a 40 04             	mov    0x4(%eax),%al
  800e1f:	84 c0                	test   %al,%al
  800e21:	75 46                	jne    800e69 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800e23:	a1 20 50 80 00       	mov    0x805020,%eax
  800e28:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800e2e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800e31:	89 d0                	mov    %edx,%eax
  800e33:	01 c0                	add    %eax,%eax
  800e35:	01 d0                	add    %edx,%eax
  800e37:	c1 e0 03             	shl    $0x3,%eax
  800e3a:	01 c8                	add    %ecx,%eax
  800e3c:	8b 00                	mov    (%eax),%eax
  800e3e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800e41:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800e44:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e49:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800e4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e4e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800e55:	8b 45 08             	mov    0x8(%ebp),%eax
  800e58:	01 c8                	add    %ecx,%eax
  800e5a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800e5c:	39 c2                	cmp    %eax,%edx
  800e5e:	75 09                	jne    800e69 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800e60:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800e67:	eb 12                	jmp    800e7b <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e69:	ff 45 e8             	incl   -0x18(%ebp)
  800e6c:	a1 20 50 80 00       	mov    0x805020,%eax
  800e71:	8b 50 74             	mov    0x74(%eax),%edx
  800e74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800e77:	39 c2                	cmp    %eax,%edx
  800e79:	77 88                	ja     800e03 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800e7b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800e7f:	75 14                	jne    800e95 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800e81:	83 ec 04             	sub    $0x4,%esp
  800e84:	68 00 41 80 00       	push   $0x804100
  800e89:	6a 3a                	push   $0x3a
  800e8b:	68 f4 40 80 00       	push   $0x8040f4
  800e90:	e8 93 fe ff ff       	call   800d28 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800e95:	ff 45 f0             	incl   -0x10(%ebp)
  800e98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e9b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800e9e:	0f 8c 32 ff ff ff    	jl     800dd6 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800ea4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800eab:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800eb2:	eb 26                	jmp    800eda <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800eb4:	a1 20 50 80 00       	mov    0x805020,%eax
  800eb9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ebf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ec2:	89 d0                	mov    %edx,%eax
  800ec4:	01 c0                	add    %eax,%eax
  800ec6:	01 d0                	add    %edx,%eax
  800ec8:	c1 e0 03             	shl    $0x3,%eax
  800ecb:	01 c8                	add    %ecx,%eax
  800ecd:	8a 40 04             	mov    0x4(%eax),%al
  800ed0:	3c 01                	cmp    $0x1,%al
  800ed2:	75 03                	jne    800ed7 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800ed4:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ed7:	ff 45 e0             	incl   -0x20(%ebp)
  800eda:	a1 20 50 80 00       	mov    0x805020,%eax
  800edf:	8b 50 74             	mov    0x74(%eax),%edx
  800ee2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ee5:	39 c2                	cmp    %eax,%edx
  800ee7:	77 cb                	ja     800eb4 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800eec:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800eef:	74 14                	je     800f05 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800ef1:	83 ec 04             	sub    $0x4,%esp
  800ef4:	68 54 41 80 00       	push   $0x804154
  800ef9:	6a 44                	push   $0x44
  800efb:	68 f4 40 80 00       	push   $0x8040f4
  800f00:	e8 23 fe ff ff       	call   800d28 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800f05:	90                   	nop
  800f06:	c9                   	leave  
  800f07:	c3                   	ret    

00800f08 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
  800f0b:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800f0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f11:	8b 00                	mov    (%eax),%eax
  800f13:	8d 48 01             	lea    0x1(%eax),%ecx
  800f16:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f19:	89 0a                	mov    %ecx,(%edx)
  800f1b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1e:	88 d1                	mov    %dl,%cl
  800f20:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f23:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800f27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2a:	8b 00                	mov    (%eax),%eax
  800f2c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800f31:	75 2c                	jne    800f5f <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800f33:	a0 24 50 80 00       	mov    0x805024,%al
  800f38:	0f b6 c0             	movzbl %al,%eax
  800f3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f3e:	8b 12                	mov    (%edx),%edx
  800f40:	89 d1                	mov    %edx,%ecx
  800f42:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f45:	83 c2 08             	add    $0x8,%edx
  800f48:	83 ec 04             	sub    $0x4,%esp
  800f4b:	50                   	push   %eax
  800f4c:	51                   	push   %ecx
  800f4d:	52                   	push   %edx
  800f4e:	e8 80 13 00 00       	call   8022d3 <sys_cputs>
  800f53:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800f56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f62:	8b 40 04             	mov    0x4(%eax),%eax
  800f65:	8d 50 01             	lea    0x1(%eax),%edx
  800f68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6b:	89 50 04             	mov    %edx,0x4(%eax)
}
  800f6e:	90                   	nop
  800f6f:	c9                   	leave  
  800f70:	c3                   	ret    

00800f71 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800f71:	55                   	push   %ebp
  800f72:	89 e5                	mov    %esp,%ebp
  800f74:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800f7a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800f81:	00 00 00 
	b.cnt = 0;
  800f84:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800f8b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800f8e:	ff 75 0c             	pushl  0xc(%ebp)
  800f91:	ff 75 08             	pushl  0x8(%ebp)
  800f94:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800f9a:	50                   	push   %eax
  800f9b:	68 08 0f 80 00       	push   $0x800f08
  800fa0:	e8 11 02 00 00       	call   8011b6 <vprintfmt>
  800fa5:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800fa8:	a0 24 50 80 00       	mov    0x805024,%al
  800fad:	0f b6 c0             	movzbl %al,%eax
  800fb0:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800fb6:	83 ec 04             	sub    $0x4,%esp
  800fb9:	50                   	push   %eax
  800fba:	52                   	push   %edx
  800fbb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800fc1:	83 c0 08             	add    $0x8,%eax
  800fc4:	50                   	push   %eax
  800fc5:	e8 09 13 00 00       	call   8022d3 <sys_cputs>
  800fca:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800fcd:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800fd4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800fda:	c9                   	leave  
  800fdb:	c3                   	ret    

00800fdc <cprintf>:

int cprintf(const char *fmt, ...) {
  800fdc:	55                   	push   %ebp
  800fdd:	89 e5                	mov    %esp,%ebp
  800fdf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800fe2:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800fe9:	8d 45 0c             	lea    0xc(%ebp),%eax
  800fec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800fef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff2:	83 ec 08             	sub    $0x8,%esp
  800ff5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ff8:	50                   	push   %eax
  800ff9:	e8 73 ff ff ff       	call   800f71 <vcprintf>
  800ffe:	83 c4 10             	add    $0x10,%esp
  801001:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801004:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801007:	c9                   	leave  
  801008:	c3                   	ret    

00801009 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  801009:	55                   	push   %ebp
  80100a:	89 e5                	mov    %esp,%ebp
  80100c:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80100f:	e8 6d 14 00 00       	call   802481 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801014:	8d 45 0c             	lea    0xc(%ebp),%eax
  801017:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	83 ec 08             	sub    $0x8,%esp
  801020:	ff 75 f4             	pushl  -0xc(%ebp)
  801023:	50                   	push   %eax
  801024:	e8 48 ff ff ff       	call   800f71 <vcprintf>
  801029:	83 c4 10             	add    $0x10,%esp
  80102c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80102f:	e8 67 14 00 00       	call   80249b <sys_enable_interrupt>
	return cnt;
  801034:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801037:	c9                   	leave  
  801038:	c3                   	ret    

00801039 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801039:	55                   	push   %ebp
  80103a:	89 e5                	mov    %esp,%ebp
  80103c:	53                   	push   %ebx
  80103d:	83 ec 14             	sub    $0x14,%esp
  801040:	8b 45 10             	mov    0x10(%ebp),%eax
  801043:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801046:	8b 45 14             	mov    0x14(%ebp),%eax
  801049:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80104c:	8b 45 18             	mov    0x18(%ebp),%eax
  80104f:	ba 00 00 00 00       	mov    $0x0,%edx
  801054:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801057:	77 55                	ja     8010ae <printnum+0x75>
  801059:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80105c:	72 05                	jb     801063 <printnum+0x2a>
  80105e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801061:	77 4b                	ja     8010ae <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801063:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801066:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801069:	8b 45 18             	mov    0x18(%ebp),%eax
  80106c:	ba 00 00 00 00       	mov    $0x0,%edx
  801071:	52                   	push   %edx
  801072:	50                   	push   %eax
  801073:	ff 75 f4             	pushl  -0xc(%ebp)
  801076:	ff 75 f0             	pushl  -0x10(%ebp)
  801079:	e8 ce 29 00 00       	call   803a4c <__udivdi3>
  80107e:	83 c4 10             	add    $0x10,%esp
  801081:	83 ec 04             	sub    $0x4,%esp
  801084:	ff 75 20             	pushl  0x20(%ebp)
  801087:	53                   	push   %ebx
  801088:	ff 75 18             	pushl  0x18(%ebp)
  80108b:	52                   	push   %edx
  80108c:	50                   	push   %eax
  80108d:	ff 75 0c             	pushl  0xc(%ebp)
  801090:	ff 75 08             	pushl  0x8(%ebp)
  801093:	e8 a1 ff ff ff       	call   801039 <printnum>
  801098:	83 c4 20             	add    $0x20,%esp
  80109b:	eb 1a                	jmp    8010b7 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80109d:	83 ec 08             	sub    $0x8,%esp
  8010a0:	ff 75 0c             	pushl  0xc(%ebp)
  8010a3:	ff 75 20             	pushl  0x20(%ebp)
  8010a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a9:	ff d0                	call   *%eax
  8010ab:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8010ae:	ff 4d 1c             	decl   0x1c(%ebp)
  8010b1:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8010b5:	7f e6                	jg     80109d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8010b7:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8010ba:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010c5:	53                   	push   %ebx
  8010c6:	51                   	push   %ecx
  8010c7:	52                   	push   %edx
  8010c8:	50                   	push   %eax
  8010c9:	e8 8e 2a 00 00       	call   803b5c <__umoddi3>
  8010ce:	83 c4 10             	add    $0x10,%esp
  8010d1:	05 b4 43 80 00       	add    $0x8043b4,%eax
  8010d6:	8a 00                	mov    (%eax),%al
  8010d8:	0f be c0             	movsbl %al,%eax
  8010db:	83 ec 08             	sub    $0x8,%esp
  8010de:	ff 75 0c             	pushl  0xc(%ebp)
  8010e1:	50                   	push   %eax
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e5:	ff d0                	call   *%eax
  8010e7:	83 c4 10             	add    $0x10,%esp
}
  8010ea:	90                   	nop
  8010eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010ee:	c9                   	leave  
  8010ef:	c3                   	ret    

008010f0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8010f0:	55                   	push   %ebp
  8010f1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8010f3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8010f7:	7e 1c                	jle    801115 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8010f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fc:	8b 00                	mov    (%eax),%eax
  8010fe:	8d 50 08             	lea    0x8(%eax),%edx
  801101:	8b 45 08             	mov    0x8(%ebp),%eax
  801104:	89 10                	mov    %edx,(%eax)
  801106:	8b 45 08             	mov    0x8(%ebp),%eax
  801109:	8b 00                	mov    (%eax),%eax
  80110b:	83 e8 08             	sub    $0x8,%eax
  80110e:	8b 50 04             	mov    0x4(%eax),%edx
  801111:	8b 00                	mov    (%eax),%eax
  801113:	eb 40                	jmp    801155 <getuint+0x65>
	else if (lflag)
  801115:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801119:	74 1e                	je     801139 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80111b:	8b 45 08             	mov    0x8(%ebp),%eax
  80111e:	8b 00                	mov    (%eax),%eax
  801120:	8d 50 04             	lea    0x4(%eax),%edx
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
  801126:	89 10                	mov    %edx,(%eax)
  801128:	8b 45 08             	mov    0x8(%ebp),%eax
  80112b:	8b 00                	mov    (%eax),%eax
  80112d:	83 e8 04             	sub    $0x4,%eax
  801130:	8b 00                	mov    (%eax),%eax
  801132:	ba 00 00 00 00       	mov    $0x0,%edx
  801137:	eb 1c                	jmp    801155 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
  80113c:	8b 00                	mov    (%eax),%eax
  80113e:	8d 50 04             	lea    0x4(%eax),%edx
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	89 10                	mov    %edx,(%eax)
  801146:	8b 45 08             	mov    0x8(%ebp),%eax
  801149:	8b 00                	mov    (%eax),%eax
  80114b:	83 e8 04             	sub    $0x4,%eax
  80114e:	8b 00                	mov    (%eax),%eax
  801150:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801155:	5d                   	pop    %ebp
  801156:	c3                   	ret    

00801157 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801157:	55                   	push   %ebp
  801158:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80115a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80115e:	7e 1c                	jle    80117c <getint+0x25>
		return va_arg(*ap, long long);
  801160:	8b 45 08             	mov    0x8(%ebp),%eax
  801163:	8b 00                	mov    (%eax),%eax
  801165:	8d 50 08             	lea    0x8(%eax),%edx
  801168:	8b 45 08             	mov    0x8(%ebp),%eax
  80116b:	89 10                	mov    %edx,(%eax)
  80116d:	8b 45 08             	mov    0x8(%ebp),%eax
  801170:	8b 00                	mov    (%eax),%eax
  801172:	83 e8 08             	sub    $0x8,%eax
  801175:	8b 50 04             	mov    0x4(%eax),%edx
  801178:	8b 00                	mov    (%eax),%eax
  80117a:	eb 38                	jmp    8011b4 <getint+0x5d>
	else if (lflag)
  80117c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801180:	74 1a                	je     80119c <getint+0x45>
		return va_arg(*ap, long);
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	8b 00                	mov    (%eax),%eax
  801187:	8d 50 04             	lea    0x4(%eax),%edx
  80118a:	8b 45 08             	mov    0x8(%ebp),%eax
  80118d:	89 10                	mov    %edx,(%eax)
  80118f:	8b 45 08             	mov    0x8(%ebp),%eax
  801192:	8b 00                	mov    (%eax),%eax
  801194:	83 e8 04             	sub    $0x4,%eax
  801197:	8b 00                	mov    (%eax),%eax
  801199:	99                   	cltd   
  80119a:	eb 18                	jmp    8011b4 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80119c:	8b 45 08             	mov    0x8(%ebp),%eax
  80119f:	8b 00                	mov    (%eax),%eax
  8011a1:	8d 50 04             	lea    0x4(%eax),%edx
  8011a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a7:	89 10                	mov    %edx,(%eax)
  8011a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ac:	8b 00                	mov    (%eax),%eax
  8011ae:	83 e8 04             	sub    $0x4,%eax
  8011b1:	8b 00                	mov    (%eax),%eax
  8011b3:	99                   	cltd   
}
  8011b4:	5d                   	pop    %ebp
  8011b5:	c3                   	ret    

008011b6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8011b6:	55                   	push   %ebp
  8011b7:	89 e5                	mov    %esp,%ebp
  8011b9:	56                   	push   %esi
  8011ba:	53                   	push   %ebx
  8011bb:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8011be:	eb 17                	jmp    8011d7 <vprintfmt+0x21>
			if (ch == '\0')
  8011c0:	85 db                	test   %ebx,%ebx
  8011c2:	0f 84 af 03 00 00    	je     801577 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8011c8:	83 ec 08             	sub    $0x8,%esp
  8011cb:	ff 75 0c             	pushl  0xc(%ebp)
  8011ce:	53                   	push   %ebx
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	ff d0                	call   *%eax
  8011d4:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8011d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011da:	8d 50 01             	lea    0x1(%eax),%edx
  8011dd:	89 55 10             	mov    %edx,0x10(%ebp)
  8011e0:	8a 00                	mov    (%eax),%al
  8011e2:	0f b6 d8             	movzbl %al,%ebx
  8011e5:	83 fb 25             	cmp    $0x25,%ebx
  8011e8:	75 d6                	jne    8011c0 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8011ea:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8011ee:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8011f5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8011fc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801203:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80120a:	8b 45 10             	mov    0x10(%ebp),%eax
  80120d:	8d 50 01             	lea    0x1(%eax),%edx
  801210:	89 55 10             	mov    %edx,0x10(%ebp)
  801213:	8a 00                	mov    (%eax),%al
  801215:	0f b6 d8             	movzbl %al,%ebx
  801218:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80121b:	83 f8 55             	cmp    $0x55,%eax
  80121e:	0f 87 2b 03 00 00    	ja     80154f <vprintfmt+0x399>
  801224:	8b 04 85 d8 43 80 00 	mov    0x8043d8(,%eax,4),%eax
  80122b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80122d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801231:	eb d7                	jmp    80120a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801233:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801237:	eb d1                	jmp    80120a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801239:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801240:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801243:	89 d0                	mov    %edx,%eax
  801245:	c1 e0 02             	shl    $0x2,%eax
  801248:	01 d0                	add    %edx,%eax
  80124a:	01 c0                	add    %eax,%eax
  80124c:	01 d8                	add    %ebx,%eax
  80124e:	83 e8 30             	sub    $0x30,%eax
  801251:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801254:	8b 45 10             	mov    0x10(%ebp),%eax
  801257:	8a 00                	mov    (%eax),%al
  801259:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80125c:	83 fb 2f             	cmp    $0x2f,%ebx
  80125f:	7e 3e                	jle    80129f <vprintfmt+0xe9>
  801261:	83 fb 39             	cmp    $0x39,%ebx
  801264:	7f 39                	jg     80129f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801266:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801269:	eb d5                	jmp    801240 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80126b:	8b 45 14             	mov    0x14(%ebp),%eax
  80126e:	83 c0 04             	add    $0x4,%eax
  801271:	89 45 14             	mov    %eax,0x14(%ebp)
  801274:	8b 45 14             	mov    0x14(%ebp),%eax
  801277:	83 e8 04             	sub    $0x4,%eax
  80127a:	8b 00                	mov    (%eax),%eax
  80127c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80127f:	eb 1f                	jmp    8012a0 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801281:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801285:	79 83                	jns    80120a <vprintfmt+0x54>
				width = 0;
  801287:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80128e:	e9 77 ff ff ff       	jmp    80120a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801293:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80129a:	e9 6b ff ff ff       	jmp    80120a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80129f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8012a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012a4:	0f 89 60 ff ff ff    	jns    80120a <vprintfmt+0x54>
				width = precision, precision = -1;
  8012aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8012b0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8012b7:	e9 4e ff ff ff       	jmp    80120a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8012bc:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8012bf:	e9 46 ff ff ff       	jmp    80120a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8012c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c7:	83 c0 04             	add    $0x4,%eax
  8012ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8012cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d0:	83 e8 04             	sub    $0x4,%eax
  8012d3:	8b 00                	mov    (%eax),%eax
  8012d5:	83 ec 08             	sub    $0x8,%esp
  8012d8:	ff 75 0c             	pushl  0xc(%ebp)
  8012db:	50                   	push   %eax
  8012dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012df:	ff d0                	call   *%eax
  8012e1:	83 c4 10             	add    $0x10,%esp
			break;
  8012e4:	e9 89 02 00 00       	jmp    801572 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8012e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ec:	83 c0 04             	add    $0x4,%eax
  8012ef:	89 45 14             	mov    %eax,0x14(%ebp)
  8012f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f5:	83 e8 04             	sub    $0x4,%eax
  8012f8:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8012fa:	85 db                	test   %ebx,%ebx
  8012fc:	79 02                	jns    801300 <vprintfmt+0x14a>
				err = -err;
  8012fe:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801300:	83 fb 64             	cmp    $0x64,%ebx
  801303:	7f 0b                	jg     801310 <vprintfmt+0x15a>
  801305:	8b 34 9d 20 42 80 00 	mov    0x804220(,%ebx,4),%esi
  80130c:	85 f6                	test   %esi,%esi
  80130e:	75 19                	jne    801329 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801310:	53                   	push   %ebx
  801311:	68 c5 43 80 00       	push   $0x8043c5
  801316:	ff 75 0c             	pushl  0xc(%ebp)
  801319:	ff 75 08             	pushl  0x8(%ebp)
  80131c:	e8 5e 02 00 00       	call   80157f <printfmt>
  801321:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801324:	e9 49 02 00 00       	jmp    801572 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801329:	56                   	push   %esi
  80132a:	68 ce 43 80 00       	push   $0x8043ce
  80132f:	ff 75 0c             	pushl  0xc(%ebp)
  801332:	ff 75 08             	pushl  0x8(%ebp)
  801335:	e8 45 02 00 00       	call   80157f <printfmt>
  80133a:	83 c4 10             	add    $0x10,%esp
			break;
  80133d:	e9 30 02 00 00       	jmp    801572 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801342:	8b 45 14             	mov    0x14(%ebp),%eax
  801345:	83 c0 04             	add    $0x4,%eax
  801348:	89 45 14             	mov    %eax,0x14(%ebp)
  80134b:	8b 45 14             	mov    0x14(%ebp),%eax
  80134e:	83 e8 04             	sub    $0x4,%eax
  801351:	8b 30                	mov    (%eax),%esi
  801353:	85 f6                	test   %esi,%esi
  801355:	75 05                	jne    80135c <vprintfmt+0x1a6>
				p = "(null)";
  801357:	be d1 43 80 00       	mov    $0x8043d1,%esi
			if (width > 0 && padc != '-')
  80135c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801360:	7e 6d                	jle    8013cf <vprintfmt+0x219>
  801362:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801366:	74 67                	je     8013cf <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801368:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80136b:	83 ec 08             	sub    $0x8,%esp
  80136e:	50                   	push   %eax
  80136f:	56                   	push   %esi
  801370:	e8 0c 03 00 00       	call   801681 <strnlen>
  801375:	83 c4 10             	add    $0x10,%esp
  801378:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80137b:	eb 16                	jmp    801393 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80137d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801381:	83 ec 08             	sub    $0x8,%esp
  801384:	ff 75 0c             	pushl  0xc(%ebp)
  801387:	50                   	push   %eax
  801388:	8b 45 08             	mov    0x8(%ebp),%eax
  80138b:	ff d0                	call   *%eax
  80138d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801390:	ff 4d e4             	decl   -0x1c(%ebp)
  801393:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801397:	7f e4                	jg     80137d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801399:	eb 34                	jmp    8013cf <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80139b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80139f:	74 1c                	je     8013bd <vprintfmt+0x207>
  8013a1:	83 fb 1f             	cmp    $0x1f,%ebx
  8013a4:	7e 05                	jle    8013ab <vprintfmt+0x1f5>
  8013a6:	83 fb 7e             	cmp    $0x7e,%ebx
  8013a9:	7e 12                	jle    8013bd <vprintfmt+0x207>
					putch('?', putdat);
  8013ab:	83 ec 08             	sub    $0x8,%esp
  8013ae:	ff 75 0c             	pushl  0xc(%ebp)
  8013b1:	6a 3f                	push   $0x3f
  8013b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b6:	ff d0                	call   *%eax
  8013b8:	83 c4 10             	add    $0x10,%esp
  8013bb:	eb 0f                	jmp    8013cc <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8013bd:	83 ec 08             	sub    $0x8,%esp
  8013c0:	ff 75 0c             	pushl  0xc(%ebp)
  8013c3:	53                   	push   %ebx
  8013c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c7:	ff d0                	call   *%eax
  8013c9:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8013cc:	ff 4d e4             	decl   -0x1c(%ebp)
  8013cf:	89 f0                	mov    %esi,%eax
  8013d1:	8d 70 01             	lea    0x1(%eax),%esi
  8013d4:	8a 00                	mov    (%eax),%al
  8013d6:	0f be d8             	movsbl %al,%ebx
  8013d9:	85 db                	test   %ebx,%ebx
  8013db:	74 24                	je     801401 <vprintfmt+0x24b>
  8013dd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013e1:	78 b8                	js     80139b <vprintfmt+0x1e5>
  8013e3:	ff 4d e0             	decl   -0x20(%ebp)
  8013e6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013ea:	79 af                	jns    80139b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8013ec:	eb 13                	jmp    801401 <vprintfmt+0x24b>
				putch(' ', putdat);
  8013ee:	83 ec 08             	sub    $0x8,%esp
  8013f1:	ff 75 0c             	pushl  0xc(%ebp)
  8013f4:	6a 20                	push   $0x20
  8013f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f9:	ff d0                	call   *%eax
  8013fb:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8013fe:	ff 4d e4             	decl   -0x1c(%ebp)
  801401:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801405:	7f e7                	jg     8013ee <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801407:	e9 66 01 00 00       	jmp    801572 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80140c:	83 ec 08             	sub    $0x8,%esp
  80140f:	ff 75 e8             	pushl  -0x18(%ebp)
  801412:	8d 45 14             	lea    0x14(%ebp),%eax
  801415:	50                   	push   %eax
  801416:	e8 3c fd ff ff       	call   801157 <getint>
  80141b:	83 c4 10             	add    $0x10,%esp
  80141e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801421:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801424:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801427:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80142a:	85 d2                	test   %edx,%edx
  80142c:	79 23                	jns    801451 <vprintfmt+0x29b>
				putch('-', putdat);
  80142e:	83 ec 08             	sub    $0x8,%esp
  801431:	ff 75 0c             	pushl  0xc(%ebp)
  801434:	6a 2d                	push   $0x2d
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	ff d0                	call   *%eax
  80143b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80143e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801441:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801444:	f7 d8                	neg    %eax
  801446:	83 d2 00             	adc    $0x0,%edx
  801449:	f7 da                	neg    %edx
  80144b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80144e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801451:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801458:	e9 bc 00 00 00       	jmp    801519 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80145d:	83 ec 08             	sub    $0x8,%esp
  801460:	ff 75 e8             	pushl  -0x18(%ebp)
  801463:	8d 45 14             	lea    0x14(%ebp),%eax
  801466:	50                   	push   %eax
  801467:	e8 84 fc ff ff       	call   8010f0 <getuint>
  80146c:	83 c4 10             	add    $0x10,%esp
  80146f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801472:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801475:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80147c:	e9 98 00 00 00       	jmp    801519 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801481:	83 ec 08             	sub    $0x8,%esp
  801484:	ff 75 0c             	pushl  0xc(%ebp)
  801487:	6a 58                	push   $0x58
  801489:	8b 45 08             	mov    0x8(%ebp),%eax
  80148c:	ff d0                	call   *%eax
  80148e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801491:	83 ec 08             	sub    $0x8,%esp
  801494:	ff 75 0c             	pushl  0xc(%ebp)
  801497:	6a 58                	push   $0x58
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	ff d0                	call   *%eax
  80149e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8014a1:	83 ec 08             	sub    $0x8,%esp
  8014a4:	ff 75 0c             	pushl  0xc(%ebp)
  8014a7:	6a 58                	push   $0x58
  8014a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ac:	ff d0                	call   *%eax
  8014ae:	83 c4 10             	add    $0x10,%esp
			break;
  8014b1:	e9 bc 00 00 00       	jmp    801572 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8014b6:	83 ec 08             	sub    $0x8,%esp
  8014b9:	ff 75 0c             	pushl  0xc(%ebp)
  8014bc:	6a 30                	push   $0x30
  8014be:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c1:	ff d0                	call   *%eax
  8014c3:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8014c6:	83 ec 08             	sub    $0x8,%esp
  8014c9:	ff 75 0c             	pushl  0xc(%ebp)
  8014cc:	6a 78                	push   $0x78
  8014ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d1:	ff d0                	call   *%eax
  8014d3:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8014d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8014d9:	83 c0 04             	add    $0x4,%eax
  8014dc:	89 45 14             	mov    %eax,0x14(%ebp)
  8014df:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e2:	83 e8 04             	sub    $0x4,%eax
  8014e5:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8014e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8014f1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8014f8:	eb 1f                	jmp    801519 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8014fa:	83 ec 08             	sub    $0x8,%esp
  8014fd:	ff 75 e8             	pushl  -0x18(%ebp)
  801500:	8d 45 14             	lea    0x14(%ebp),%eax
  801503:	50                   	push   %eax
  801504:	e8 e7 fb ff ff       	call   8010f0 <getuint>
  801509:	83 c4 10             	add    $0x10,%esp
  80150c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80150f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801512:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801519:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80151d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801520:	83 ec 04             	sub    $0x4,%esp
  801523:	52                   	push   %edx
  801524:	ff 75 e4             	pushl  -0x1c(%ebp)
  801527:	50                   	push   %eax
  801528:	ff 75 f4             	pushl  -0xc(%ebp)
  80152b:	ff 75 f0             	pushl  -0x10(%ebp)
  80152e:	ff 75 0c             	pushl  0xc(%ebp)
  801531:	ff 75 08             	pushl  0x8(%ebp)
  801534:	e8 00 fb ff ff       	call   801039 <printnum>
  801539:	83 c4 20             	add    $0x20,%esp
			break;
  80153c:	eb 34                	jmp    801572 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80153e:	83 ec 08             	sub    $0x8,%esp
  801541:	ff 75 0c             	pushl  0xc(%ebp)
  801544:	53                   	push   %ebx
  801545:	8b 45 08             	mov    0x8(%ebp),%eax
  801548:	ff d0                	call   *%eax
  80154a:	83 c4 10             	add    $0x10,%esp
			break;
  80154d:	eb 23                	jmp    801572 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80154f:	83 ec 08             	sub    $0x8,%esp
  801552:	ff 75 0c             	pushl  0xc(%ebp)
  801555:	6a 25                	push   $0x25
  801557:	8b 45 08             	mov    0x8(%ebp),%eax
  80155a:	ff d0                	call   *%eax
  80155c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80155f:	ff 4d 10             	decl   0x10(%ebp)
  801562:	eb 03                	jmp    801567 <vprintfmt+0x3b1>
  801564:	ff 4d 10             	decl   0x10(%ebp)
  801567:	8b 45 10             	mov    0x10(%ebp),%eax
  80156a:	48                   	dec    %eax
  80156b:	8a 00                	mov    (%eax),%al
  80156d:	3c 25                	cmp    $0x25,%al
  80156f:	75 f3                	jne    801564 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801571:	90                   	nop
		}
	}
  801572:	e9 47 fc ff ff       	jmp    8011be <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801577:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801578:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80157b:	5b                   	pop    %ebx
  80157c:	5e                   	pop    %esi
  80157d:	5d                   	pop    %ebp
  80157e:	c3                   	ret    

0080157f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80157f:	55                   	push   %ebp
  801580:	89 e5                	mov    %esp,%ebp
  801582:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801585:	8d 45 10             	lea    0x10(%ebp),%eax
  801588:	83 c0 04             	add    $0x4,%eax
  80158b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80158e:	8b 45 10             	mov    0x10(%ebp),%eax
  801591:	ff 75 f4             	pushl  -0xc(%ebp)
  801594:	50                   	push   %eax
  801595:	ff 75 0c             	pushl  0xc(%ebp)
  801598:	ff 75 08             	pushl  0x8(%ebp)
  80159b:	e8 16 fc ff ff       	call   8011b6 <vprintfmt>
  8015a0:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8015a3:	90                   	nop
  8015a4:	c9                   	leave  
  8015a5:	c3                   	ret    

008015a6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8015a6:	55                   	push   %ebp
  8015a7:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8015a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ac:	8b 40 08             	mov    0x8(%eax),%eax
  8015af:	8d 50 01             	lea    0x1(%eax),%edx
  8015b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b5:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8015b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015bb:	8b 10                	mov    (%eax),%edx
  8015bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c0:	8b 40 04             	mov    0x4(%eax),%eax
  8015c3:	39 c2                	cmp    %eax,%edx
  8015c5:	73 12                	jae    8015d9 <sprintputch+0x33>
		*b->buf++ = ch;
  8015c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ca:	8b 00                	mov    (%eax),%eax
  8015cc:	8d 48 01             	lea    0x1(%eax),%ecx
  8015cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d2:	89 0a                	mov    %ecx,(%edx)
  8015d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8015d7:	88 10                	mov    %dl,(%eax)
}
  8015d9:	90                   	nop
  8015da:	5d                   	pop    %ebp
  8015db:	c3                   	ret    

008015dc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8015dc:	55                   	push   %ebp
  8015dd:	89 e5                	mov    %esp,%ebp
  8015df:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8015e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015eb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f1:	01 d0                	add    %edx,%eax
  8015f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8015fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801601:	74 06                	je     801609 <vsnprintf+0x2d>
  801603:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801607:	7f 07                	jg     801610 <vsnprintf+0x34>
		return -E_INVAL;
  801609:	b8 03 00 00 00       	mov    $0x3,%eax
  80160e:	eb 20                	jmp    801630 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801610:	ff 75 14             	pushl  0x14(%ebp)
  801613:	ff 75 10             	pushl  0x10(%ebp)
  801616:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801619:	50                   	push   %eax
  80161a:	68 a6 15 80 00       	push   $0x8015a6
  80161f:	e8 92 fb ff ff       	call   8011b6 <vprintfmt>
  801624:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801627:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80162a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80162d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801630:	c9                   	leave  
  801631:	c3                   	ret    

00801632 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801632:	55                   	push   %ebp
  801633:	89 e5                	mov    %esp,%ebp
  801635:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801638:	8d 45 10             	lea    0x10(%ebp),%eax
  80163b:	83 c0 04             	add    $0x4,%eax
  80163e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801641:	8b 45 10             	mov    0x10(%ebp),%eax
  801644:	ff 75 f4             	pushl  -0xc(%ebp)
  801647:	50                   	push   %eax
  801648:	ff 75 0c             	pushl  0xc(%ebp)
  80164b:	ff 75 08             	pushl  0x8(%ebp)
  80164e:	e8 89 ff ff ff       	call   8015dc <vsnprintf>
  801653:	83 c4 10             	add    $0x10,%esp
  801656:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801659:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80165c:	c9                   	leave  
  80165d:	c3                   	ret    

0080165e <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80165e:	55                   	push   %ebp
  80165f:	89 e5                	mov    %esp,%ebp
  801661:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801664:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80166b:	eb 06                	jmp    801673 <strlen+0x15>
		n++;
  80166d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801670:	ff 45 08             	incl   0x8(%ebp)
  801673:	8b 45 08             	mov    0x8(%ebp),%eax
  801676:	8a 00                	mov    (%eax),%al
  801678:	84 c0                	test   %al,%al
  80167a:	75 f1                	jne    80166d <strlen+0xf>
		n++;
	return n;
  80167c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80167f:	c9                   	leave  
  801680:	c3                   	ret    

00801681 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801681:	55                   	push   %ebp
  801682:	89 e5                	mov    %esp,%ebp
  801684:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801687:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80168e:	eb 09                	jmp    801699 <strnlen+0x18>
		n++;
  801690:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801693:	ff 45 08             	incl   0x8(%ebp)
  801696:	ff 4d 0c             	decl   0xc(%ebp)
  801699:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80169d:	74 09                	je     8016a8 <strnlen+0x27>
  80169f:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a2:	8a 00                	mov    (%eax),%al
  8016a4:	84 c0                	test   %al,%al
  8016a6:	75 e8                	jne    801690 <strnlen+0xf>
		n++;
	return n;
  8016a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8016ab:	c9                   	leave  
  8016ac:	c3                   	ret    

008016ad <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8016ad:	55                   	push   %ebp
  8016ae:	89 e5                	mov    %esp,%ebp
  8016b0:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8016b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8016b9:	90                   	nop
  8016ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bd:	8d 50 01             	lea    0x1(%eax),%edx
  8016c0:	89 55 08             	mov    %edx,0x8(%ebp)
  8016c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016c9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8016cc:	8a 12                	mov    (%edx),%dl
  8016ce:	88 10                	mov    %dl,(%eax)
  8016d0:	8a 00                	mov    (%eax),%al
  8016d2:	84 c0                	test   %al,%al
  8016d4:	75 e4                	jne    8016ba <strcpy+0xd>
		/* do nothing */;
	return ret;
  8016d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8016d9:	c9                   	leave  
  8016da:	c3                   	ret    

008016db <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8016db:	55                   	push   %ebp
  8016dc:	89 e5                	mov    %esp,%ebp
  8016de:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8016e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8016e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016ee:	eb 1f                	jmp    80170f <strncpy+0x34>
		*dst++ = *src;
  8016f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f3:	8d 50 01             	lea    0x1(%eax),%edx
  8016f6:	89 55 08             	mov    %edx,0x8(%ebp)
  8016f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016fc:	8a 12                	mov    (%edx),%dl
  8016fe:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801700:	8b 45 0c             	mov    0xc(%ebp),%eax
  801703:	8a 00                	mov    (%eax),%al
  801705:	84 c0                	test   %al,%al
  801707:	74 03                	je     80170c <strncpy+0x31>
			src++;
  801709:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80170c:	ff 45 fc             	incl   -0x4(%ebp)
  80170f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801712:	3b 45 10             	cmp    0x10(%ebp),%eax
  801715:	72 d9                	jb     8016f0 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801717:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80171a:	c9                   	leave  
  80171b:	c3                   	ret    

0080171c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
  80171f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801722:	8b 45 08             	mov    0x8(%ebp),%eax
  801725:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801728:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80172c:	74 30                	je     80175e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80172e:	eb 16                	jmp    801746 <strlcpy+0x2a>
			*dst++ = *src++;
  801730:	8b 45 08             	mov    0x8(%ebp),%eax
  801733:	8d 50 01             	lea    0x1(%eax),%edx
  801736:	89 55 08             	mov    %edx,0x8(%ebp)
  801739:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80173f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801742:	8a 12                	mov    (%edx),%dl
  801744:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801746:	ff 4d 10             	decl   0x10(%ebp)
  801749:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80174d:	74 09                	je     801758 <strlcpy+0x3c>
  80174f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801752:	8a 00                	mov    (%eax),%al
  801754:	84 c0                	test   %al,%al
  801756:	75 d8                	jne    801730 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801758:	8b 45 08             	mov    0x8(%ebp),%eax
  80175b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80175e:	8b 55 08             	mov    0x8(%ebp),%edx
  801761:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801764:	29 c2                	sub    %eax,%edx
  801766:	89 d0                	mov    %edx,%eax
}
  801768:	c9                   	leave  
  801769:	c3                   	ret    

0080176a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80176d:	eb 06                	jmp    801775 <strcmp+0xb>
		p++, q++;
  80176f:	ff 45 08             	incl   0x8(%ebp)
  801772:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801775:	8b 45 08             	mov    0x8(%ebp),%eax
  801778:	8a 00                	mov    (%eax),%al
  80177a:	84 c0                	test   %al,%al
  80177c:	74 0e                	je     80178c <strcmp+0x22>
  80177e:	8b 45 08             	mov    0x8(%ebp),%eax
  801781:	8a 10                	mov    (%eax),%dl
  801783:	8b 45 0c             	mov    0xc(%ebp),%eax
  801786:	8a 00                	mov    (%eax),%al
  801788:	38 c2                	cmp    %al,%dl
  80178a:	74 e3                	je     80176f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80178c:	8b 45 08             	mov    0x8(%ebp),%eax
  80178f:	8a 00                	mov    (%eax),%al
  801791:	0f b6 d0             	movzbl %al,%edx
  801794:	8b 45 0c             	mov    0xc(%ebp),%eax
  801797:	8a 00                	mov    (%eax),%al
  801799:	0f b6 c0             	movzbl %al,%eax
  80179c:	29 c2                	sub    %eax,%edx
  80179e:	89 d0                	mov    %edx,%eax
}
  8017a0:	5d                   	pop    %ebp
  8017a1:	c3                   	ret    

008017a2 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8017a5:	eb 09                	jmp    8017b0 <strncmp+0xe>
		n--, p++, q++;
  8017a7:	ff 4d 10             	decl   0x10(%ebp)
  8017aa:	ff 45 08             	incl   0x8(%ebp)
  8017ad:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8017b0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017b4:	74 17                	je     8017cd <strncmp+0x2b>
  8017b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b9:	8a 00                	mov    (%eax),%al
  8017bb:	84 c0                	test   %al,%al
  8017bd:	74 0e                	je     8017cd <strncmp+0x2b>
  8017bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c2:	8a 10                	mov    (%eax),%dl
  8017c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c7:	8a 00                	mov    (%eax),%al
  8017c9:	38 c2                	cmp    %al,%dl
  8017cb:	74 da                	je     8017a7 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8017cd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017d1:	75 07                	jne    8017da <strncmp+0x38>
		return 0;
  8017d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d8:	eb 14                	jmp    8017ee <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8017da:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dd:	8a 00                	mov    (%eax),%al
  8017df:	0f b6 d0             	movzbl %al,%edx
  8017e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e5:	8a 00                	mov    (%eax),%al
  8017e7:	0f b6 c0             	movzbl %al,%eax
  8017ea:	29 c2                	sub    %eax,%edx
  8017ec:	89 d0                	mov    %edx,%eax
}
  8017ee:	5d                   	pop    %ebp
  8017ef:	c3                   	ret    

008017f0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
  8017f3:	83 ec 04             	sub    $0x4,%esp
  8017f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8017fc:	eb 12                	jmp    801810 <strchr+0x20>
		if (*s == c)
  8017fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801801:	8a 00                	mov    (%eax),%al
  801803:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801806:	75 05                	jne    80180d <strchr+0x1d>
			return (char *) s;
  801808:	8b 45 08             	mov    0x8(%ebp),%eax
  80180b:	eb 11                	jmp    80181e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80180d:	ff 45 08             	incl   0x8(%ebp)
  801810:	8b 45 08             	mov    0x8(%ebp),%eax
  801813:	8a 00                	mov    (%eax),%al
  801815:	84 c0                	test   %al,%al
  801817:	75 e5                	jne    8017fe <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801819:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80181e:	c9                   	leave  
  80181f:	c3                   	ret    

00801820 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801820:	55                   	push   %ebp
  801821:	89 e5                	mov    %esp,%ebp
  801823:	83 ec 04             	sub    $0x4,%esp
  801826:	8b 45 0c             	mov    0xc(%ebp),%eax
  801829:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80182c:	eb 0d                	jmp    80183b <strfind+0x1b>
		if (*s == c)
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
  801831:	8a 00                	mov    (%eax),%al
  801833:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801836:	74 0e                	je     801846 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801838:	ff 45 08             	incl   0x8(%ebp)
  80183b:	8b 45 08             	mov    0x8(%ebp),%eax
  80183e:	8a 00                	mov    (%eax),%al
  801840:	84 c0                	test   %al,%al
  801842:	75 ea                	jne    80182e <strfind+0xe>
  801844:	eb 01                	jmp    801847 <strfind+0x27>
		if (*s == c)
			break;
  801846:	90                   	nop
	return (char *) s;
  801847:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80184a:	c9                   	leave  
  80184b:	c3                   	ret    

0080184c <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
  80184f:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801852:	8b 45 08             	mov    0x8(%ebp),%eax
  801855:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801858:	8b 45 10             	mov    0x10(%ebp),%eax
  80185b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80185e:	eb 0e                	jmp    80186e <memset+0x22>
		*p++ = c;
  801860:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801863:	8d 50 01             	lea    0x1(%eax),%edx
  801866:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801869:	8b 55 0c             	mov    0xc(%ebp),%edx
  80186c:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80186e:	ff 4d f8             	decl   -0x8(%ebp)
  801871:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801875:	79 e9                	jns    801860 <memset+0x14>
		*p++ = c;

	return v;
  801877:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80187a:	c9                   	leave  
  80187b:	c3                   	ret    

0080187c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
  80187f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801882:	8b 45 0c             	mov    0xc(%ebp),%eax
  801885:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801888:	8b 45 08             	mov    0x8(%ebp),%eax
  80188b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80188e:	eb 16                	jmp    8018a6 <memcpy+0x2a>
		*d++ = *s++;
  801890:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801893:	8d 50 01             	lea    0x1(%eax),%edx
  801896:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801899:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80189c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80189f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8018a2:	8a 12                	mov    (%edx),%dl
  8018a4:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8018a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018ac:	89 55 10             	mov    %edx,0x10(%ebp)
  8018af:	85 c0                	test   %eax,%eax
  8018b1:	75 dd                	jne    801890 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8018b3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018b6:	c9                   	leave  
  8018b7:	c3                   	ret    

008018b8 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
  8018bb:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8018be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8018c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8018ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018cd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8018d0:	73 50                	jae    801922 <memmove+0x6a>
  8018d2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8018d8:	01 d0                	add    %edx,%eax
  8018da:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8018dd:	76 43                	jbe    801922 <memmove+0x6a>
		s += n;
  8018df:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e2:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8018e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e8:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8018eb:	eb 10                	jmp    8018fd <memmove+0x45>
			*--d = *--s;
  8018ed:	ff 4d f8             	decl   -0x8(%ebp)
  8018f0:	ff 4d fc             	decl   -0x4(%ebp)
  8018f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018f6:	8a 10                	mov    (%eax),%dl
  8018f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018fb:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8018fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801900:	8d 50 ff             	lea    -0x1(%eax),%edx
  801903:	89 55 10             	mov    %edx,0x10(%ebp)
  801906:	85 c0                	test   %eax,%eax
  801908:	75 e3                	jne    8018ed <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80190a:	eb 23                	jmp    80192f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80190c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80190f:	8d 50 01             	lea    0x1(%eax),%edx
  801912:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801915:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801918:	8d 4a 01             	lea    0x1(%edx),%ecx
  80191b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80191e:	8a 12                	mov    (%edx),%dl
  801920:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801922:	8b 45 10             	mov    0x10(%ebp),%eax
  801925:	8d 50 ff             	lea    -0x1(%eax),%edx
  801928:	89 55 10             	mov    %edx,0x10(%ebp)
  80192b:	85 c0                	test   %eax,%eax
  80192d:	75 dd                	jne    80190c <memmove+0x54>
			*d++ = *s++;

	return dst;
  80192f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801932:	c9                   	leave  
  801933:	c3                   	ret    

00801934 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
  801937:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80193a:	8b 45 08             	mov    0x8(%ebp),%eax
  80193d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801940:	8b 45 0c             	mov    0xc(%ebp),%eax
  801943:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801946:	eb 2a                	jmp    801972 <memcmp+0x3e>
		if (*s1 != *s2)
  801948:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80194b:	8a 10                	mov    (%eax),%dl
  80194d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801950:	8a 00                	mov    (%eax),%al
  801952:	38 c2                	cmp    %al,%dl
  801954:	74 16                	je     80196c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801956:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801959:	8a 00                	mov    (%eax),%al
  80195b:	0f b6 d0             	movzbl %al,%edx
  80195e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801961:	8a 00                	mov    (%eax),%al
  801963:	0f b6 c0             	movzbl %al,%eax
  801966:	29 c2                	sub    %eax,%edx
  801968:	89 d0                	mov    %edx,%eax
  80196a:	eb 18                	jmp    801984 <memcmp+0x50>
		s1++, s2++;
  80196c:	ff 45 fc             	incl   -0x4(%ebp)
  80196f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801972:	8b 45 10             	mov    0x10(%ebp),%eax
  801975:	8d 50 ff             	lea    -0x1(%eax),%edx
  801978:	89 55 10             	mov    %edx,0x10(%ebp)
  80197b:	85 c0                	test   %eax,%eax
  80197d:	75 c9                	jne    801948 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80197f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801984:	c9                   	leave  
  801985:	c3                   	ret    

00801986 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
  801989:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80198c:	8b 55 08             	mov    0x8(%ebp),%edx
  80198f:	8b 45 10             	mov    0x10(%ebp),%eax
  801992:	01 d0                	add    %edx,%eax
  801994:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801997:	eb 15                	jmp    8019ae <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801999:	8b 45 08             	mov    0x8(%ebp),%eax
  80199c:	8a 00                	mov    (%eax),%al
  80199e:	0f b6 d0             	movzbl %al,%edx
  8019a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a4:	0f b6 c0             	movzbl %al,%eax
  8019a7:	39 c2                	cmp    %eax,%edx
  8019a9:	74 0d                	je     8019b8 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8019ab:	ff 45 08             	incl   0x8(%ebp)
  8019ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8019b4:	72 e3                	jb     801999 <memfind+0x13>
  8019b6:	eb 01                	jmp    8019b9 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8019b8:	90                   	nop
	return (void *) s;
  8019b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8019bc:	c9                   	leave  
  8019bd:	c3                   	ret    

008019be <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
  8019c1:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8019c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8019cb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019d2:	eb 03                	jmp    8019d7 <strtol+0x19>
		s++;
  8019d4:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019da:	8a 00                	mov    (%eax),%al
  8019dc:	3c 20                	cmp    $0x20,%al
  8019de:	74 f4                	je     8019d4 <strtol+0x16>
  8019e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e3:	8a 00                	mov    (%eax),%al
  8019e5:	3c 09                	cmp    $0x9,%al
  8019e7:	74 eb                	je     8019d4 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8019e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ec:	8a 00                	mov    (%eax),%al
  8019ee:	3c 2b                	cmp    $0x2b,%al
  8019f0:	75 05                	jne    8019f7 <strtol+0x39>
		s++;
  8019f2:	ff 45 08             	incl   0x8(%ebp)
  8019f5:	eb 13                	jmp    801a0a <strtol+0x4c>
	else if (*s == '-')
  8019f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fa:	8a 00                	mov    (%eax),%al
  8019fc:	3c 2d                	cmp    $0x2d,%al
  8019fe:	75 0a                	jne    801a0a <strtol+0x4c>
		s++, neg = 1;
  801a00:	ff 45 08             	incl   0x8(%ebp)
  801a03:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801a0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a0e:	74 06                	je     801a16 <strtol+0x58>
  801a10:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801a14:	75 20                	jne    801a36 <strtol+0x78>
  801a16:	8b 45 08             	mov    0x8(%ebp),%eax
  801a19:	8a 00                	mov    (%eax),%al
  801a1b:	3c 30                	cmp    $0x30,%al
  801a1d:	75 17                	jne    801a36 <strtol+0x78>
  801a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a22:	40                   	inc    %eax
  801a23:	8a 00                	mov    (%eax),%al
  801a25:	3c 78                	cmp    $0x78,%al
  801a27:	75 0d                	jne    801a36 <strtol+0x78>
		s += 2, base = 16;
  801a29:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801a2d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801a34:	eb 28                	jmp    801a5e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801a36:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a3a:	75 15                	jne    801a51 <strtol+0x93>
  801a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3f:	8a 00                	mov    (%eax),%al
  801a41:	3c 30                	cmp    $0x30,%al
  801a43:	75 0c                	jne    801a51 <strtol+0x93>
		s++, base = 8;
  801a45:	ff 45 08             	incl   0x8(%ebp)
  801a48:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801a4f:	eb 0d                	jmp    801a5e <strtol+0xa0>
	else if (base == 0)
  801a51:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a55:	75 07                	jne    801a5e <strtol+0xa0>
		base = 10;
  801a57:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a61:	8a 00                	mov    (%eax),%al
  801a63:	3c 2f                	cmp    $0x2f,%al
  801a65:	7e 19                	jle    801a80 <strtol+0xc2>
  801a67:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6a:	8a 00                	mov    (%eax),%al
  801a6c:	3c 39                	cmp    $0x39,%al
  801a6e:	7f 10                	jg     801a80 <strtol+0xc2>
			dig = *s - '0';
  801a70:	8b 45 08             	mov    0x8(%ebp),%eax
  801a73:	8a 00                	mov    (%eax),%al
  801a75:	0f be c0             	movsbl %al,%eax
  801a78:	83 e8 30             	sub    $0x30,%eax
  801a7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a7e:	eb 42                	jmp    801ac2 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801a80:	8b 45 08             	mov    0x8(%ebp),%eax
  801a83:	8a 00                	mov    (%eax),%al
  801a85:	3c 60                	cmp    $0x60,%al
  801a87:	7e 19                	jle    801aa2 <strtol+0xe4>
  801a89:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8c:	8a 00                	mov    (%eax),%al
  801a8e:	3c 7a                	cmp    $0x7a,%al
  801a90:	7f 10                	jg     801aa2 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801a92:	8b 45 08             	mov    0x8(%ebp),%eax
  801a95:	8a 00                	mov    (%eax),%al
  801a97:	0f be c0             	movsbl %al,%eax
  801a9a:	83 e8 57             	sub    $0x57,%eax
  801a9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801aa0:	eb 20                	jmp    801ac2 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa5:	8a 00                	mov    (%eax),%al
  801aa7:	3c 40                	cmp    $0x40,%al
  801aa9:	7e 39                	jle    801ae4 <strtol+0x126>
  801aab:	8b 45 08             	mov    0x8(%ebp),%eax
  801aae:	8a 00                	mov    (%eax),%al
  801ab0:	3c 5a                	cmp    $0x5a,%al
  801ab2:	7f 30                	jg     801ae4 <strtol+0x126>
			dig = *s - 'A' + 10;
  801ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab7:	8a 00                	mov    (%eax),%al
  801ab9:	0f be c0             	movsbl %al,%eax
  801abc:	83 e8 37             	sub    $0x37,%eax
  801abf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac5:	3b 45 10             	cmp    0x10(%ebp),%eax
  801ac8:	7d 19                	jge    801ae3 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801aca:	ff 45 08             	incl   0x8(%ebp)
  801acd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ad0:	0f af 45 10          	imul   0x10(%ebp),%eax
  801ad4:	89 c2                	mov    %eax,%edx
  801ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad9:	01 d0                	add    %edx,%eax
  801adb:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801ade:	e9 7b ff ff ff       	jmp    801a5e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801ae3:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801ae4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ae8:	74 08                	je     801af2 <strtol+0x134>
		*endptr = (char *) s;
  801aea:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aed:	8b 55 08             	mov    0x8(%ebp),%edx
  801af0:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801af2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801af6:	74 07                	je     801aff <strtol+0x141>
  801af8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801afb:	f7 d8                	neg    %eax
  801afd:	eb 03                	jmp    801b02 <strtol+0x144>
  801aff:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801b02:	c9                   	leave  
  801b03:	c3                   	ret    

00801b04 <ltostr>:

void
ltostr(long value, char *str)
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
  801b07:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801b0a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801b11:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801b18:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b1c:	79 13                	jns    801b31 <ltostr+0x2d>
	{
		neg = 1;
  801b1e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801b25:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b28:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801b2b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801b2e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801b31:	8b 45 08             	mov    0x8(%ebp),%eax
  801b34:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801b39:	99                   	cltd   
  801b3a:	f7 f9                	idiv   %ecx
  801b3c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801b3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b42:	8d 50 01             	lea    0x1(%eax),%edx
  801b45:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b48:	89 c2                	mov    %eax,%edx
  801b4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b4d:	01 d0                	add    %edx,%eax
  801b4f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b52:	83 c2 30             	add    $0x30,%edx
  801b55:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801b57:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b5a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801b5f:	f7 e9                	imul   %ecx
  801b61:	c1 fa 02             	sar    $0x2,%edx
  801b64:	89 c8                	mov    %ecx,%eax
  801b66:	c1 f8 1f             	sar    $0x1f,%eax
  801b69:	29 c2                	sub    %eax,%edx
  801b6b:	89 d0                	mov    %edx,%eax
  801b6d:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801b70:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b73:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801b78:	f7 e9                	imul   %ecx
  801b7a:	c1 fa 02             	sar    $0x2,%edx
  801b7d:	89 c8                	mov    %ecx,%eax
  801b7f:	c1 f8 1f             	sar    $0x1f,%eax
  801b82:	29 c2                	sub    %eax,%edx
  801b84:	89 d0                	mov    %edx,%eax
  801b86:	c1 e0 02             	shl    $0x2,%eax
  801b89:	01 d0                	add    %edx,%eax
  801b8b:	01 c0                	add    %eax,%eax
  801b8d:	29 c1                	sub    %eax,%ecx
  801b8f:	89 ca                	mov    %ecx,%edx
  801b91:	85 d2                	test   %edx,%edx
  801b93:	75 9c                	jne    801b31 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801b95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801b9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b9f:	48                   	dec    %eax
  801ba0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801ba3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801ba7:	74 3d                	je     801be6 <ltostr+0xe2>
		start = 1 ;
  801ba9:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801bb0:	eb 34                	jmp    801be6 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801bb2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb8:	01 d0                	add    %edx,%eax
  801bba:	8a 00                	mov    (%eax),%al
  801bbc:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801bbf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc5:	01 c2                	add    %eax,%edx
  801bc7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801bca:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bcd:	01 c8                	add    %ecx,%eax
  801bcf:	8a 00                	mov    (%eax),%al
  801bd1:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801bd3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801bd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd9:	01 c2                	add    %eax,%edx
  801bdb:	8a 45 eb             	mov    -0x15(%ebp),%al
  801bde:	88 02                	mov    %al,(%edx)
		start++ ;
  801be0:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801be3:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801bec:	7c c4                	jl     801bb2 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801bee:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801bf1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf4:	01 d0                	add    %edx,%eax
  801bf6:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801bf9:	90                   	nop
  801bfa:	c9                   	leave  
  801bfb:	c3                   	ret    

00801bfc <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
  801bff:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801c02:	ff 75 08             	pushl  0x8(%ebp)
  801c05:	e8 54 fa ff ff       	call   80165e <strlen>
  801c0a:	83 c4 04             	add    $0x4,%esp
  801c0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801c10:	ff 75 0c             	pushl  0xc(%ebp)
  801c13:	e8 46 fa ff ff       	call   80165e <strlen>
  801c18:	83 c4 04             	add    $0x4,%esp
  801c1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801c1e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801c25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c2c:	eb 17                	jmp    801c45 <strcconcat+0x49>
		final[s] = str1[s] ;
  801c2e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c31:	8b 45 10             	mov    0x10(%ebp),%eax
  801c34:	01 c2                	add    %eax,%edx
  801c36:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801c39:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3c:	01 c8                	add    %ecx,%eax
  801c3e:	8a 00                	mov    (%eax),%al
  801c40:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801c42:	ff 45 fc             	incl   -0x4(%ebp)
  801c45:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c48:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801c4b:	7c e1                	jl     801c2e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801c4d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801c54:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801c5b:	eb 1f                	jmp    801c7c <strcconcat+0x80>
		final[s++] = str2[i] ;
  801c5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c60:	8d 50 01             	lea    0x1(%eax),%edx
  801c63:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801c66:	89 c2                	mov    %eax,%edx
  801c68:	8b 45 10             	mov    0x10(%ebp),%eax
  801c6b:	01 c2                	add    %eax,%edx
  801c6d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801c70:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c73:	01 c8                	add    %ecx,%eax
  801c75:	8a 00                	mov    (%eax),%al
  801c77:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801c79:	ff 45 f8             	incl   -0x8(%ebp)
  801c7c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c7f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801c82:	7c d9                	jl     801c5d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801c84:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c87:	8b 45 10             	mov    0x10(%ebp),%eax
  801c8a:	01 d0                	add    %edx,%eax
  801c8c:	c6 00 00             	movb   $0x0,(%eax)
}
  801c8f:	90                   	nop
  801c90:	c9                   	leave  
  801c91:	c3                   	ret    

00801c92 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801c92:	55                   	push   %ebp
  801c93:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801c95:	8b 45 14             	mov    0x14(%ebp),%eax
  801c98:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801c9e:	8b 45 14             	mov    0x14(%ebp),%eax
  801ca1:	8b 00                	mov    (%eax),%eax
  801ca3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801caa:	8b 45 10             	mov    0x10(%ebp),%eax
  801cad:	01 d0                	add    %edx,%eax
  801caf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801cb5:	eb 0c                	jmp    801cc3 <strsplit+0x31>
			*string++ = 0;
  801cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cba:	8d 50 01             	lea    0x1(%eax),%edx
  801cbd:	89 55 08             	mov    %edx,0x8(%ebp)
  801cc0:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc6:	8a 00                	mov    (%eax),%al
  801cc8:	84 c0                	test   %al,%al
  801cca:	74 18                	je     801ce4 <strsplit+0x52>
  801ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccf:	8a 00                	mov    (%eax),%al
  801cd1:	0f be c0             	movsbl %al,%eax
  801cd4:	50                   	push   %eax
  801cd5:	ff 75 0c             	pushl  0xc(%ebp)
  801cd8:	e8 13 fb ff ff       	call   8017f0 <strchr>
  801cdd:	83 c4 08             	add    $0x8,%esp
  801ce0:	85 c0                	test   %eax,%eax
  801ce2:	75 d3                	jne    801cb7 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce7:	8a 00                	mov    (%eax),%al
  801ce9:	84 c0                	test   %al,%al
  801ceb:	74 5a                	je     801d47 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801ced:	8b 45 14             	mov    0x14(%ebp),%eax
  801cf0:	8b 00                	mov    (%eax),%eax
  801cf2:	83 f8 0f             	cmp    $0xf,%eax
  801cf5:	75 07                	jne    801cfe <strsplit+0x6c>
		{
			return 0;
  801cf7:	b8 00 00 00 00       	mov    $0x0,%eax
  801cfc:	eb 66                	jmp    801d64 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801cfe:	8b 45 14             	mov    0x14(%ebp),%eax
  801d01:	8b 00                	mov    (%eax),%eax
  801d03:	8d 48 01             	lea    0x1(%eax),%ecx
  801d06:	8b 55 14             	mov    0x14(%ebp),%edx
  801d09:	89 0a                	mov    %ecx,(%edx)
  801d0b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d12:	8b 45 10             	mov    0x10(%ebp),%eax
  801d15:	01 c2                	add    %eax,%edx
  801d17:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801d1c:	eb 03                	jmp    801d21 <strsplit+0x8f>
			string++;
  801d1e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801d21:	8b 45 08             	mov    0x8(%ebp),%eax
  801d24:	8a 00                	mov    (%eax),%al
  801d26:	84 c0                	test   %al,%al
  801d28:	74 8b                	je     801cb5 <strsplit+0x23>
  801d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2d:	8a 00                	mov    (%eax),%al
  801d2f:	0f be c0             	movsbl %al,%eax
  801d32:	50                   	push   %eax
  801d33:	ff 75 0c             	pushl  0xc(%ebp)
  801d36:	e8 b5 fa ff ff       	call   8017f0 <strchr>
  801d3b:	83 c4 08             	add    $0x8,%esp
  801d3e:	85 c0                	test   %eax,%eax
  801d40:	74 dc                	je     801d1e <strsplit+0x8c>
			string++;
	}
  801d42:	e9 6e ff ff ff       	jmp    801cb5 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801d47:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801d48:	8b 45 14             	mov    0x14(%ebp),%eax
  801d4b:	8b 00                	mov    (%eax),%eax
  801d4d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d54:	8b 45 10             	mov    0x10(%ebp),%eax
  801d57:	01 d0                	add    %edx,%eax
  801d59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801d5f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801d64:	c9                   	leave  
  801d65:	c3                   	ret    

00801d66 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801d66:	55                   	push   %ebp
  801d67:	89 e5                	mov    %esp,%ebp
  801d69:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801d6c:	a1 04 50 80 00       	mov    0x805004,%eax
  801d71:	85 c0                	test   %eax,%eax
  801d73:	74 1f                	je     801d94 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801d75:	e8 1d 00 00 00       	call   801d97 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801d7a:	83 ec 0c             	sub    $0xc,%esp
  801d7d:	68 30 45 80 00       	push   $0x804530
  801d82:	e8 55 f2 ff ff       	call   800fdc <cprintf>
  801d87:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801d8a:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801d91:	00 00 00 
	}
}
  801d94:	90                   	nop
  801d95:	c9                   	leave  
  801d96:	c3                   	ret    

00801d97 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801d97:	55                   	push   %ebp
  801d98:	89 e5                	mov    %esp,%ebp
  801d9a:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  801d9d:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801da4:	00 00 00 
  801da7:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801dae:	00 00 00 
  801db1:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801db8:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  801dbb:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801dc2:	00 00 00 
  801dc5:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801dcc:	00 00 00 
  801dcf:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801dd6:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  801dd9:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801de0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801de8:	2d 00 10 00 00       	sub    $0x1000,%eax
  801ded:	a3 50 50 80 00       	mov    %eax,0x805050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801df2:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801df9:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  801dfc:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801e03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e06:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  801e0b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801e0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e11:	ba 00 00 00 00       	mov    $0x0,%edx
  801e16:	f7 75 f0             	divl   -0x10(%ebp)
  801e19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e1c:	29 d0                	sub    %edx,%eax
  801e1e:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  801e21:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801e28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e2b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801e30:	2d 00 10 00 00       	sub    $0x1000,%eax
  801e35:	83 ec 04             	sub    $0x4,%esp
  801e38:	6a 06                	push   $0x6
  801e3a:	ff 75 e8             	pushl  -0x18(%ebp)
  801e3d:	50                   	push   %eax
  801e3e:	e8 d4 05 00 00       	call   802417 <sys_allocate_chunk>
  801e43:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801e46:	a1 20 51 80 00       	mov    0x805120,%eax
  801e4b:	83 ec 0c             	sub    $0xc,%esp
  801e4e:	50                   	push   %eax
  801e4f:	e8 49 0c 00 00       	call   802a9d <initialize_MemBlocksList>
  801e54:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  801e57:	a1 48 51 80 00       	mov    0x805148,%eax
  801e5c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  801e5f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e63:	75 14                	jne    801e79 <initialize_dyn_block_system+0xe2>
  801e65:	83 ec 04             	sub    $0x4,%esp
  801e68:	68 55 45 80 00       	push   $0x804555
  801e6d:	6a 39                	push   $0x39
  801e6f:	68 73 45 80 00       	push   $0x804573
  801e74:	e8 af ee ff ff       	call   800d28 <_panic>
  801e79:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e7c:	8b 00                	mov    (%eax),%eax
  801e7e:	85 c0                	test   %eax,%eax
  801e80:	74 10                	je     801e92 <initialize_dyn_block_system+0xfb>
  801e82:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e85:	8b 00                	mov    (%eax),%eax
  801e87:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e8a:	8b 52 04             	mov    0x4(%edx),%edx
  801e8d:	89 50 04             	mov    %edx,0x4(%eax)
  801e90:	eb 0b                	jmp    801e9d <initialize_dyn_block_system+0x106>
  801e92:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e95:	8b 40 04             	mov    0x4(%eax),%eax
  801e98:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801e9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ea0:	8b 40 04             	mov    0x4(%eax),%eax
  801ea3:	85 c0                	test   %eax,%eax
  801ea5:	74 0f                	je     801eb6 <initialize_dyn_block_system+0x11f>
  801ea7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801eaa:	8b 40 04             	mov    0x4(%eax),%eax
  801ead:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801eb0:	8b 12                	mov    (%edx),%edx
  801eb2:	89 10                	mov    %edx,(%eax)
  801eb4:	eb 0a                	jmp    801ec0 <initialize_dyn_block_system+0x129>
  801eb6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801eb9:	8b 00                	mov    (%eax),%eax
  801ebb:	a3 48 51 80 00       	mov    %eax,0x805148
  801ec0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ec3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ec9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ecc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ed3:	a1 54 51 80 00       	mov    0x805154,%eax
  801ed8:	48                   	dec    %eax
  801ed9:	a3 54 51 80 00       	mov    %eax,0x805154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  801ede:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ee1:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  801ee8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801eeb:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  801ef2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ef6:	75 14                	jne    801f0c <initialize_dyn_block_system+0x175>
  801ef8:	83 ec 04             	sub    $0x4,%esp
  801efb:	68 80 45 80 00       	push   $0x804580
  801f00:	6a 3f                	push   $0x3f
  801f02:	68 73 45 80 00       	push   $0x804573
  801f07:	e8 1c ee ff ff       	call   800d28 <_panic>
  801f0c:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801f12:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f15:	89 10                	mov    %edx,(%eax)
  801f17:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f1a:	8b 00                	mov    (%eax),%eax
  801f1c:	85 c0                	test   %eax,%eax
  801f1e:	74 0d                	je     801f2d <initialize_dyn_block_system+0x196>
  801f20:	a1 38 51 80 00       	mov    0x805138,%eax
  801f25:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f28:	89 50 04             	mov    %edx,0x4(%eax)
  801f2b:	eb 08                	jmp    801f35 <initialize_dyn_block_system+0x19e>
  801f2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f30:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801f35:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f38:	a3 38 51 80 00       	mov    %eax,0x805138
  801f3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f40:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f47:	a1 44 51 80 00       	mov    0x805144,%eax
  801f4c:	40                   	inc    %eax
  801f4d:	a3 44 51 80 00       	mov    %eax,0x805144

}
  801f52:	90                   	nop
  801f53:	c9                   	leave  
  801f54:	c3                   	ret    

00801f55 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801f55:	55                   	push   %ebp
  801f56:	89 e5                	mov    %esp,%ebp
  801f58:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f5b:	e8 06 fe ff ff       	call   801d66 <InitializeUHeap>
	if (size == 0) return NULL ;
  801f60:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f64:	75 07                	jne    801f6d <malloc+0x18>
  801f66:	b8 00 00 00 00       	mov    $0x0,%eax
  801f6b:	eb 7d                	jmp    801fea <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  801f6d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801f74:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801f7b:	8b 55 08             	mov    0x8(%ebp),%edx
  801f7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f81:	01 d0                	add    %edx,%eax
  801f83:	48                   	dec    %eax
  801f84:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801f87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f8a:	ba 00 00 00 00       	mov    $0x0,%edx
  801f8f:	f7 75 f0             	divl   -0x10(%ebp)
  801f92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f95:	29 d0                	sub    %edx,%eax
  801f97:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  801f9a:	e8 46 08 00 00       	call   8027e5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f9f:	83 f8 01             	cmp    $0x1,%eax
  801fa2:	75 07                	jne    801fab <malloc+0x56>
  801fa4:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  801fab:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  801faf:	75 34                	jne    801fe5 <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  801fb1:	83 ec 0c             	sub    $0xc,%esp
  801fb4:	ff 75 e8             	pushl  -0x18(%ebp)
  801fb7:	e8 73 0e 00 00       	call   802e2f <alloc_block_FF>
  801fbc:	83 c4 10             	add    $0x10,%esp
  801fbf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  801fc2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801fc6:	74 16                	je     801fde <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  801fc8:	83 ec 0c             	sub    $0xc,%esp
  801fcb:	ff 75 e4             	pushl  -0x1c(%ebp)
  801fce:	e8 ff 0b 00 00       	call   802bd2 <insert_sorted_allocList>
  801fd3:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  801fd6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fd9:	8b 40 08             	mov    0x8(%eax),%eax
  801fdc:	eb 0c                	jmp    801fea <malloc+0x95>
	             }
	             else
	             	return NULL;
  801fde:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe3:	eb 05                	jmp    801fea <malloc+0x95>
	      	  }
	          else
	               return NULL;
  801fe5:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  801fea:	c9                   	leave  
  801feb:	c3                   	ret    

00801fec <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801fec:	55                   	push   %ebp
  801fed:	89 e5                	mov    %esp,%ebp
  801fef:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  801ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff5:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  801ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ffe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802001:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802006:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  802009:	83 ec 08             	sub    $0x8,%esp
  80200c:	ff 75 f4             	pushl  -0xc(%ebp)
  80200f:	68 40 50 80 00       	push   $0x805040
  802014:	e8 61 0b 00 00       	call   802b7a <find_block>
  802019:	83 c4 10             	add    $0x10,%esp
  80201c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  80201f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802023:	0f 84 a5 00 00 00    	je     8020ce <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  802029:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80202c:	8b 40 0c             	mov    0xc(%eax),%eax
  80202f:	83 ec 08             	sub    $0x8,%esp
  802032:	50                   	push   %eax
  802033:	ff 75 f4             	pushl  -0xc(%ebp)
  802036:	e8 a4 03 00 00       	call   8023df <sys_free_user_mem>
  80203b:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  80203e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802042:	75 17                	jne    80205b <free+0x6f>
  802044:	83 ec 04             	sub    $0x4,%esp
  802047:	68 55 45 80 00       	push   $0x804555
  80204c:	68 87 00 00 00       	push   $0x87
  802051:	68 73 45 80 00       	push   $0x804573
  802056:	e8 cd ec ff ff       	call   800d28 <_panic>
  80205b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80205e:	8b 00                	mov    (%eax),%eax
  802060:	85 c0                	test   %eax,%eax
  802062:	74 10                	je     802074 <free+0x88>
  802064:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802067:	8b 00                	mov    (%eax),%eax
  802069:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80206c:	8b 52 04             	mov    0x4(%edx),%edx
  80206f:	89 50 04             	mov    %edx,0x4(%eax)
  802072:	eb 0b                	jmp    80207f <free+0x93>
  802074:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802077:	8b 40 04             	mov    0x4(%eax),%eax
  80207a:	a3 44 50 80 00       	mov    %eax,0x805044
  80207f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802082:	8b 40 04             	mov    0x4(%eax),%eax
  802085:	85 c0                	test   %eax,%eax
  802087:	74 0f                	je     802098 <free+0xac>
  802089:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80208c:	8b 40 04             	mov    0x4(%eax),%eax
  80208f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802092:	8b 12                	mov    (%edx),%edx
  802094:	89 10                	mov    %edx,(%eax)
  802096:	eb 0a                	jmp    8020a2 <free+0xb6>
  802098:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80209b:	8b 00                	mov    (%eax),%eax
  80209d:	a3 40 50 80 00       	mov    %eax,0x805040
  8020a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020b5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8020ba:	48                   	dec    %eax
  8020bb:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(theBlock);
  8020c0:	83 ec 0c             	sub    $0xc,%esp
  8020c3:	ff 75 ec             	pushl  -0x14(%ebp)
  8020c6:	e8 37 12 00 00       	call   803302 <insert_sorted_with_merge_freeList>
  8020cb:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  8020ce:	90                   	nop
  8020cf:	c9                   	leave  
  8020d0:	c3                   	ret    

008020d1 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8020d1:	55                   	push   %ebp
  8020d2:	89 e5                	mov    %esp,%ebp
  8020d4:	83 ec 38             	sub    $0x38,%esp
  8020d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8020da:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8020dd:	e8 84 fc ff ff       	call   801d66 <InitializeUHeap>
	if (size == 0) return NULL ;
  8020e2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8020e6:	75 07                	jne    8020ef <smalloc+0x1e>
  8020e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ed:	eb 7e                	jmp    80216d <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  8020ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8020f6:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8020fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802100:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802103:	01 d0                	add    %edx,%eax
  802105:	48                   	dec    %eax
  802106:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802109:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80210c:	ba 00 00 00 00       	mov    $0x0,%edx
  802111:	f7 75 f0             	divl   -0x10(%ebp)
  802114:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802117:	29 d0                	sub    %edx,%eax
  802119:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  80211c:	e8 c4 06 00 00       	call   8027e5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802121:	83 f8 01             	cmp    $0x1,%eax
  802124:	75 42                	jne    802168 <smalloc+0x97>

		  va = malloc(newsize) ;
  802126:	83 ec 0c             	sub    $0xc,%esp
  802129:	ff 75 e8             	pushl  -0x18(%ebp)
  80212c:	e8 24 fe ff ff       	call   801f55 <malloc>
  802131:	83 c4 10             	add    $0x10,%esp
  802134:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  802137:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80213b:	74 24                	je     802161 <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  80213d:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  802141:	ff 75 e4             	pushl  -0x1c(%ebp)
  802144:	50                   	push   %eax
  802145:	ff 75 e8             	pushl  -0x18(%ebp)
  802148:	ff 75 08             	pushl  0x8(%ebp)
  80214b:	e8 1a 04 00 00       	call   80256a <sys_createSharedObject>
  802150:	83 c4 10             	add    $0x10,%esp
  802153:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  802156:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80215a:	78 0c                	js     802168 <smalloc+0x97>
					  return va ;
  80215c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80215f:	eb 0c                	jmp    80216d <smalloc+0x9c>
				 }
				 else
					return NULL;
  802161:	b8 00 00 00 00       	mov    $0x0,%eax
  802166:	eb 05                	jmp    80216d <smalloc+0x9c>
	  }
		  return NULL ;
  802168:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80216d:	c9                   	leave  
  80216e:	c3                   	ret    

0080216f <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80216f:	55                   	push   %ebp
  802170:	89 e5                	mov    %esp,%ebp
  802172:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802175:	e8 ec fb ff ff       	call   801d66 <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  80217a:	83 ec 08             	sub    $0x8,%esp
  80217d:	ff 75 0c             	pushl  0xc(%ebp)
  802180:	ff 75 08             	pushl  0x8(%ebp)
  802183:	e8 0c 04 00 00       	call   802594 <sys_getSizeOfSharedObject>
  802188:	83 c4 10             	add    $0x10,%esp
  80218b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  80218e:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  802192:	75 07                	jne    80219b <sget+0x2c>
  802194:	b8 00 00 00 00       	mov    $0x0,%eax
  802199:	eb 75                	jmp    802210 <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  80219b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8021a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a8:	01 d0                	add    %edx,%eax
  8021aa:	48                   	dec    %eax
  8021ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8021ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8021b6:	f7 75 f0             	divl   -0x10(%ebp)
  8021b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021bc:	29 d0                	sub    %edx,%eax
  8021be:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  8021c1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  8021c8:	e8 18 06 00 00       	call   8027e5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8021cd:	83 f8 01             	cmp    $0x1,%eax
  8021d0:	75 39                	jne    80220b <sget+0x9c>

		  va = malloc(newsize) ;
  8021d2:	83 ec 0c             	sub    $0xc,%esp
  8021d5:	ff 75 e8             	pushl  -0x18(%ebp)
  8021d8:	e8 78 fd ff ff       	call   801f55 <malloc>
  8021dd:	83 c4 10             	add    $0x10,%esp
  8021e0:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  8021e3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8021e7:	74 22                	je     80220b <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  8021e9:	83 ec 04             	sub    $0x4,%esp
  8021ec:	ff 75 e0             	pushl  -0x20(%ebp)
  8021ef:	ff 75 0c             	pushl  0xc(%ebp)
  8021f2:	ff 75 08             	pushl  0x8(%ebp)
  8021f5:	e8 b7 03 00 00       	call   8025b1 <sys_getSharedObject>
  8021fa:	83 c4 10             	add    $0x10,%esp
  8021fd:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  802200:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802204:	78 05                	js     80220b <sget+0x9c>
					  return va;
  802206:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802209:	eb 05                	jmp    802210 <sget+0xa1>
				  }
			  }
     }
         return NULL;
  80220b:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  802210:	c9                   	leave  
  802211:	c3                   	ret    

00802212 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802212:	55                   	push   %ebp
  802213:	89 e5                	mov    %esp,%ebp
  802215:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802218:	e8 49 fb ff ff       	call   801d66 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80221d:	83 ec 04             	sub    $0x4,%esp
  802220:	68 a4 45 80 00       	push   $0x8045a4
  802225:	68 1e 01 00 00       	push   $0x11e
  80222a:	68 73 45 80 00       	push   $0x804573
  80222f:	e8 f4 ea ff ff       	call   800d28 <_panic>

00802234 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802234:	55                   	push   %ebp
  802235:	89 e5                	mov    %esp,%ebp
  802237:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80223a:	83 ec 04             	sub    $0x4,%esp
  80223d:	68 cc 45 80 00       	push   $0x8045cc
  802242:	68 32 01 00 00       	push   $0x132
  802247:	68 73 45 80 00       	push   $0x804573
  80224c:	e8 d7 ea ff ff       	call   800d28 <_panic>

00802251 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802251:	55                   	push   %ebp
  802252:	89 e5                	mov    %esp,%ebp
  802254:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802257:	83 ec 04             	sub    $0x4,%esp
  80225a:	68 f0 45 80 00       	push   $0x8045f0
  80225f:	68 3d 01 00 00       	push   $0x13d
  802264:	68 73 45 80 00       	push   $0x804573
  802269:	e8 ba ea ff ff       	call   800d28 <_panic>

0080226e <shrink>:

}
void shrink(uint32 newSize)
{
  80226e:	55                   	push   %ebp
  80226f:	89 e5                	mov    %esp,%ebp
  802271:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802274:	83 ec 04             	sub    $0x4,%esp
  802277:	68 f0 45 80 00       	push   $0x8045f0
  80227c:	68 42 01 00 00       	push   $0x142
  802281:	68 73 45 80 00       	push   $0x804573
  802286:	e8 9d ea ff ff       	call   800d28 <_panic>

0080228b <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80228b:	55                   	push   %ebp
  80228c:	89 e5                	mov    %esp,%ebp
  80228e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802291:	83 ec 04             	sub    $0x4,%esp
  802294:	68 f0 45 80 00       	push   $0x8045f0
  802299:	68 47 01 00 00       	push   $0x147
  80229e:	68 73 45 80 00       	push   $0x804573
  8022a3:	e8 80 ea ff ff       	call   800d28 <_panic>

008022a8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8022a8:	55                   	push   %ebp
  8022a9:	89 e5                	mov    %esp,%ebp
  8022ab:	57                   	push   %edi
  8022ac:	56                   	push   %esi
  8022ad:	53                   	push   %ebx
  8022ae:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8022b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022ba:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022bd:	8b 7d 18             	mov    0x18(%ebp),%edi
  8022c0:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8022c3:	cd 30                	int    $0x30
  8022c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8022c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8022cb:	83 c4 10             	add    $0x10,%esp
  8022ce:	5b                   	pop    %ebx
  8022cf:	5e                   	pop    %esi
  8022d0:	5f                   	pop    %edi
  8022d1:	5d                   	pop    %ebp
  8022d2:	c3                   	ret    

008022d3 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8022d3:	55                   	push   %ebp
  8022d4:	89 e5                	mov    %esp,%ebp
  8022d6:	83 ec 04             	sub    $0x4,%esp
  8022d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8022dc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8022df:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8022e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e6:	6a 00                	push   $0x0
  8022e8:	6a 00                	push   $0x0
  8022ea:	52                   	push   %edx
  8022eb:	ff 75 0c             	pushl  0xc(%ebp)
  8022ee:	50                   	push   %eax
  8022ef:	6a 00                	push   $0x0
  8022f1:	e8 b2 ff ff ff       	call   8022a8 <syscall>
  8022f6:	83 c4 18             	add    $0x18,%esp
}
  8022f9:	90                   	nop
  8022fa:	c9                   	leave  
  8022fb:	c3                   	ret    

008022fc <sys_cgetc>:

int
sys_cgetc(void)
{
  8022fc:	55                   	push   %ebp
  8022fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8022ff:	6a 00                	push   $0x0
  802301:	6a 00                	push   $0x0
  802303:	6a 00                	push   $0x0
  802305:	6a 00                	push   $0x0
  802307:	6a 00                	push   $0x0
  802309:	6a 01                	push   $0x1
  80230b:	e8 98 ff ff ff       	call   8022a8 <syscall>
  802310:	83 c4 18             	add    $0x18,%esp
}
  802313:	c9                   	leave  
  802314:	c3                   	ret    

00802315 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802315:	55                   	push   %ebp
  802316:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802318:	8b 55 0c             	mov    0xc(%ebp),%edx
  80231b:	8b 45 08             	mov    0x8(%ebp),%eax
  80231e:	6a 00                	push   $0x0
  802320:	6a 00                	push   $0x0
  802322:	6a 00                	push   $0x0
  802324:	52                   	push   %edx
  802325:	50                   	push   %eax
  802326:	6a 05                	push   $0x5
  802328:	e8 7b ff ff ff       	call   8022a8 <syscall>
  80232d:	83 c4 18             	add    $0x18,%esp
}
  802330:	c9                   	leave  
  802331:	c3                   	ret    

00802332 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802332:	55                   	push   %ebp
  802333:	89 e5                	mov    %esp,%ebp
  802335:	56                   	push   %esi
  802336:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802337:	8b 75 18             	mov    0x18(%ebp),%esi
  80233a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80233d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802340:	8b 55 0c             	mov    0xc(%ebp),%edx
  802343:	8b 45 08             	mov    0x8(%ebp),%eax
  802346:	56                   	push   %esi
  802347:	53                   	push   %ebx
  802348:	51                   	push   %ecx
  802349:	52                   	push   %edx
  80234a:	50                   	push   %eax
  80234b:	6a 06                	push   $0x6
  80234d:	e8 56 ff ff ff       	call   8022a8 <syscall>
  802352:	83 c4 18             	add    $0x18,%esp
}
  802355:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802358:	5b                   	pop    %ebx
  802359:	5e                   	pop    %esi
  80235a:	5d                   	pop    %ebp
  80235b:	c3                   	ret    

0080235c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80235c:	55                   	push   %ebp
  80235d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80235f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802362:	8b 45 08             	mov    0x8(%ebp),%eax
  802365:	6a 00                	push   $0x0
  802367:	6a 00                	push   $0x0
  802369:	6a 00                	push   $0x0
  80236b:	52                   	push   %edx
  80236c:	50                   	push   %eax
  80236d:	6a 07                	push   $0x7
  80236f:	e8 34 ff ff ff       	call   8022a8 <syscall>
  802374:	83 c4 18             	add    $0x18,%esp
}
  802377:	c9                   	leave  
  802378:	c3                   	ret    

00802379 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802379:	55                   	push   %ebp
  80237a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80237c:	6a 00                	push   $0x0
  80237e:	6a 00                	push   $0x0
  802380:	6a 00                	push   $0x0
  802382:	ff 75 0c             	pushl  0xc(%ebp)
  802385:	ff 75 08             	pushl  0x8(%ebp)
  802388:	6a 08                	push   $0x8
  80238a:	e8 19 ff ff ff       	call   8022a8 <syscall>
  80238f:	83 c4 18             	add    $0x18,%esp
}
  802392:	c9                   	leave  
  802393:	c3                   	ret    

00802394 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802394:	55                   	push   %ebp
  802395:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802397:	6a 00                	push   $0x0
  802399:	6a 00                	push   $0x0
  80239b:	6a 00                	push   $0x0
  80239d:	6a 00                	push   $0x0
  80239f:	6a 00                	push   $0x0
  8023a1:	6a 09                	push   $0x9
  8023a3:	e8 00 ff ff ff       	call   8022a8 <syscall>
  8023a8:	83 c4 18             	add    $0x18,%esp
}
  8023ab:	c9                   	leave  
  8023ac:	c3                   	ret    

008023ad <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8023ad:	55                   	push   %ebp
  8023ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8023b0:	6a 00                	push   $0x0
  8023b2:	6a 00                	push   $0x0
  8023b4:	6a 00                	push   $0x0
  8023b6:	6a 00                	push   $0x0
  8023b8:	6a 00                	push   $0x0
  8023ba:	6a 0a                	push   $0xa
  8023bc:	e8 e7 fe ff ff       	call   8022a8 <syscall>
  8023c1:	83 c4 18             	add    $0x18,%esp
}
  8023c4:	c9                   	leave  
  8023c5:	c3                   	ret    

008023c6 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8023c6:	55                   	push   %ebp
  8023c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8023c9:	6a 00                	push   $0x0
  8023cb:	6a 00                	push   $0x0
  8023cd:	6a 00                	push   $0x0
  8023cf:	6a 00                	push   $0x0
  8023d1:	6a 00                	push   $0x0
  8023d3:	6a 0b                	push   $0xb
  8023d5:	e8 ce fe ff ff       	call   8022a8 <syscall>
  8023da:	83 c4 18             	add    $0x18,%esp
}
  8023dd:	c9                   	leave  
  8023de:	c3                   	ret    

008023df <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8023df:	55                   	push   %ebp
  8023e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8023e2:	6a 00                	push   $0x0
  8023e4:	6a 00                	push   $0x0
  8023e6:	6a 00                	push   $0x0
  8023e8:	ff 75 0c             	pushl  0xc(%ebp)
  8023eb:	ff 75 08             	pushl  0x8(%ebp)
  8023ee:	6a 0f                	push   $0xf
  8023f0:	e8 b3 fe ff ff       	call   8022a8 <syscall>
  8023f5:	83 c4 18             	add    $0x18,%esp
	return;
  8023f8:	90                   	nop
}
  8023f9:	c9                   	leave  
  8023fa:	c3                   	ret    

008023fb <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8023fb:	55                   	push   %ebp
  8023fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8023fe:	6a 00                	push   $0x0
  802400:	6a 00                	push   $0x0
  802402:	6a 00                	push   $0x0
  802404:	ff 75 0c             	pushl  0xc(%ebp)
  802407:	ff 75 08             	pushl  0x8(%ebp)
  80240a:	6a 10                	push   $0x10
  80240c:	e8 97 fe ff ff       	call   8022a8 <syscall>
  802411:	83 c4 18             	add    $0x18,%esp
	return ;
  802414:	90                   	nop
}
  802415:	c9                   	leave  
  802416:	c3                   	ret    

00802417 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802417:	55                   	push   %ebp
  802418:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80241a:	6a 00                	push   $0x0
  80241c:	6a 00                	push   $0x0
  80241e:	ff 75 10             	pushl  0x10(%ebp)
  802421:	ff 75 0c             	pushl  0xc(%ebp)
  802424:	ff 75 08             	pushl  0x8(%ebp)
  802427:	6a 11                	push   $0x11
  802429:	e8 7a fe ff ff       	call   8022a8 <syscall>
  80242e:	83 c4 18             	add    $0x18,%esp
	return ;
  802431:	90                   	nop
}
  802432:	c9                   	leave  
  802433:	c3                   	ret    

00802434 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802434:	55                   	push   %ebp
  802435:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802437:	6a 00                	push   $0x0
  802439:	6a 00                	push   $0x0
  80243b:	6a 00                	push   $0x0
  80243d:	6a 00                	push   $0x0
  80243f:	6a 00                	push   $0x0
  802441:	6a 0c                	push   $0xc
  802443:	e8 60 fe ff ff       	call   8022a8 <syscall>
  802448:	83 c4 18             	add    $0x18,%esp
}
  80244b:	c9                   	leave  
  80244c:	c3                   	ret    

0080244d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80244d:	55                   	push   %ebp
  80244e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802450:	6a 00                	push   $0x0
  802452:	6a 00                	push   $0x0
  802454:	6a 00                	push   $0x0
  802456:	6a 00                	push   $0x0
  802458:	ff 75 08             	pushl  0x8(%ebp)
  80245b:	6a 0d                	push   $0xd
  80245d:	e8 46 fe ff ff       	call   8022a8 <syscall>
  802462:	83 c4 18             	add    $0x18,%esp
}
  802465:	c9                   	leave  
  802466:	c3                   	ret    

00802467 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802467:	55                   	push   %ebp
  802468:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80246a:	6a 00                	push   $0x0
  80246c:	6a 00                	push   $0x0
  80246e:	6a 00                	push   $0x0
  802470:	6a 00                	push   $0x0
  802472:	6a 00                	push   $0x0
  802474:	6a 0e                	push   $0xe
  802476:	e8 2d fe ff ff       	call   8022a8 <syscall>
  80247b:	83 c4 18             	add    $0x18,%esp
}
  80247e:	90                   	nop
  80247f:	c9                   	leave  
  802480:	c3                   	ret    

00802481 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802481:	55                   	push   %ebp
  802482:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802484:	6a 00                	push   $0x0
  802486:	6a 00                	push   $0x0
  802488:	6a 00                	push   $0x0
  80248a:	6a 00                	push   $0x0
  80248c:	6a 00                	push   $0x0
  80248e:	6a 13                	push   $0x13
  802490:	e8 13 fe ff ff       	call   8022a8 <syscall>
  802495:	83 c4 18             	add    $0x18,%esp
}
  802498:	90                   	nop
  802499:	c9                   	leave  
  80249a:	c3                   	ret    

0080249b <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80249b:	55                   	push   %ebp
  80249c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80249e:	6a 00                	push   $0x0
  8024a0:	6a 00                	push   $0x0
  8024a2:	6a 00                	push   $0x0
  8024a4:	6a 00                	push   $0x0
  8024a6:	6a 00                	push   $0x0
  8024a8:	6a 14                	push   $0x14
  8024aa:	e8 f9 fd ff ff       	call   8022a8 <syscall>
  8024af:	83 c4 18             	add    $0x18,%esp
}
  8024b2:	90                   	nop
  8024b3:	c9                   	leave  
  8024b4:	c3                   	ret    

008024b5 <sys_cputc>:


void
sys_cputc(const char c)
{
  8024b5:	55                   	push   %ebp
  8024b6:	89 e5                	mov    %esp,%ebp
  8024b8:	83 ec 04             	sub    $0x4,%esp
  8024bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024be:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8024c1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8024c5:	6a 00                	push   $0x0
  8024c7:	6a 00                	push   $0x0
  8024c9:	6a 00                	push   $0x0
  8024cb:	6a 00                	push   $0x0
  8024cd:	50                   	push   %eax
  8024ce:	6a 15                	push   $0x15
  8024d0:	e8 d3 fd ff ff       	call   8022a8 <syscall>
  8024d5:	83 c4 18             	add    $0x18,%esp
}
  8024d8:	90                   	nop
  8024d9:	c9                   	leave  
  8024da:	c3                   	ret    

008024db <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8024db:	55                   	push   %ebp
  8024dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8024de:	6a 00                	push   $0x0
  8024e0:	6a 00                	push   $0x0
  8024e2:	6a 00                	push   $0x0
  8024e4:	6a 00                	push   $0x0
  8024e6:	6a 00                	push   $0x0
  8024e8:	6a 16                	push   $0x16
  8024ea:	e8 b9 fd ff ff       	call   8022a8 <syscall>
  8024ef:	83 c4 18             	add    $0x18,%esp
}
  8024f2:	90                   	nop
  8024f3:	c9                   	leave  
  8024f4:	c3                   	ret    

008024f5 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8024f5:	55                   	push   %ebp
  8024f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8024f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fb:	6a 00                	push   $0x0
  8024fd:	6a 00                	push   $0x0
  8024ff:	6a 00                	push   $0x0
  802501:	ff 75 0c             	pushl  0xc(%ebp)
  802504:	50                   	push   %eax
  802505:	6a 17                	push   $0x17
  802507:	e8 9c fd ff ff       	call   8022a8 <syscall>
  80250c:	83 c4 18             	add    $0x18,%esp
}
  80250f:	c9                   	leave  
  802510:	c3                   	ret    

00802511 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802511:	55                   	push   %ebp
  802512:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802514:	8b 55 0c             	mov    0xc(%ebp),%edx
  802517:	8b 45 08             	mov    0x8(%ebp),%eax
  80251a:	6a 00                	push   $0x0
  80251c:	6a 00                	push   $0x0
  80251e:	6a 00                	push   $0x0
  802520:	52                   	push   %edx
  802521:	50                   	push   %eax
  802522:	6a 1a                	push   $0x1a
  802524:	e8 7f fd ff ff       	call   8022a8 <syscall>
  802529:	83 c4 18             	add    $0x18,%esp
}
  80252c:	c9                   	leave  
  80252d:	c3                   	ret    

0080252e <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80252e:	55                   	push   %ebp
  80252f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802531:	8b 55 0c             	mov    0xc(%ebp),%edx
  802534:	8b 45 08             	mov    0x8(%ebp),%eax
  802537:	6a 00                	push   $0x0
  802539:	6a 00                	push   $0x0
  80253b:	6a 00                	push   $0x0
  80253d:	52                   	push   %edx
  80253e:	50                   	push   %eax
  80253f:	6a 18                	push   $0x18
  802541:	e8 62 fd ff ff       	call   8022a8 <syscall>
  802546:	83 c4 18             	add    $0x18,%esp
}
  802549:	90                   	nop
  80254a:	c9                   	leave  
  80254b:	c3                   	ret    

0080254c <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80254c:	55                   	push   %ebp
  80254d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80254f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802552:	8b 45 08             	mov    0x8(%ebp),%eax
  802555:	6a 00                	push   $0x0
  802557:	6a 00                	push   $0x0
  802559:	6a 00                	push   $0x0
  80255b:	52                   	push   %edx
  80255c:	50                   	push   %eax
  80255d:	6a 19                	push   $0x19
  80255f:	e8 44 fd ff ff       	call   8022a8 <syscall>
  802564:	83 c4 18             	add    $0x18,%esp
}
  802567:	90                   	nop
  802568:	c9                   	leave  
  802569:	c3                   	ret    

0080256a <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80256a:	55                   	push   %ebp
  80256b:	89 e5                	mov    %esp,%ebp
  80256d:	83 ec 04             	sub    $0x4,%esp
  802570:	8b 45 10             	mov    0x10(%ebp),%eax
  802573:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802576:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802579:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80257d:	8b 45 08             	mov    0x8(%ebp),%eax
  802580:	6a 00                	push   $0x0
  802582:	51                   	push   %ecx
  802583:	52                   	push   %edx
  802584:	ff 75 0c             	pushl  0xc(%ebp)
  802587:	50                   	push   %eax
  802588:	6a 1b                	push   $0x1b
  80258a:	e8 19 fd ff ff       	call   8022a8 <syscall>
  80258f:	83 c4 18             	add    $0x18,%esp
}
  802592:	c9                   	leave  
  802593:	c3                   	ret    

00802594 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802594:	55                   	push   %ebp
  802595:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802597:	8b 55 0c             	mov    0xc(%ebp),%edx
  80259a:	8b 45 08             	mov    0x8(%ebp),%eax
  80259d:	6a 00                	push   $0x0
  80259f:	6a 00                	push   $0x0
  8025a1:	6a 00                	push   $0x0
  8025a3:	52                   	push   %edx
  8025a4:	50                   	push   %eax
  8025a5:	6a 1c                	push   $0x1c
  8025a7:	e8 fc fc ff ff       	call   8022a8 <syscall>
  8025ac:	83 c4 18             	add    $0x18,%esp
}
  8025af:	c9                   	leave  
  8025b0:	c3                   	ret    

008025b1 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8025b1:	55                   	push   %ebp
  8025b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8025b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8025b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8025bd:	6a 00                	push   $0x0
  8025bf:	6a 00                	push   $0x0
  8025c1:	51                   	push   %ecx
  8025c2:	52                   	push   %edx
  8025c3:	50                   	push   %eax
  8025c4:	6a 1d                	push   $0x1d
  8025c6:	e8 dd fc ff ff       	call   8022a8 <syscall>
  8025cb:	83 c4 18             	add    $0x18,%esp
}
  8025ce:	c9                   	leave  
  8025cf:	c3                   	ret    

008025d0 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8025d0:	55                   	push   %ebp
  8025d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8025d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d9:	6a 00                	push   $0x0
  8025db:	6a 00                	push   $0x0
  8025dd:	6a 00                	push   $0x0
  8025df:	52                   	push   %edx
  8025e0:	50                   	push   %eax
  8025e1:	6a 1e                	push   $0x1e
  8025e3:	e8 c0 fc ff ff       	call   8022a8 <syscall>
  8025e8:	83 c4 18             	add    $0x18,%esp
}
  8025eb:	c9                   	leave  
  8025ec:	c3                   	ret    

008025ed <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8025ed:	55                   	push   %ebp
  8025ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8025f0:	6a 00                	push   $0x0
  8025f2:	6a 00                	push   $0x0
  8025f4:	6a 00                	push   $0x0
  8025f6:	6a 00                	push   $0x0
  8025f8:	6a 00                	push   $0x0
  8025fa:	6a 1f                	push   $0x1f
  8025fc:	e8 a7 fc ff ff       	call   8022a8 <syscall>
  802601:	83 c4 18             	add    $0x18,%esp
}
  802604:	c9                   	leave  
  802605:	c3                   	ret    

00802606 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802606:	55                   	push   %ebp
  802607:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802609:	8b 45 08             	mov    0x8(%ebp),%eax
  80260c:	6a 00                	push   $0x0
  80260e:	ff 75 14             	pushl  0x14(%ebp)
  802611:	ff 75 10             	pushl  0x10(%ebp)
  802614:	ff 75 0c             	pushl  0xc(%ebp)
  802617:	50                   	push   %eax
  802618:	6a 20                	push   $0x20
  80261a:	e8 89 fc ff ff       	call   8022a8 <syscall>
  80261f:	83 c4 18             	add    $0x18,%esp
}
  802622:	c9                   	leave  
  802623:	c3                   	ret    

00802624 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802624:	55                   	push   %ebp
  802625:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802627:	8b 45 08             	mov    0x8(%ebp),%eax
  80262a:	6a 00                	push   $0x0
  80262c:	6a 00                	push   $0x0
  80262e:	6a 00                	push   $0x0
  802630:	6a 00                	push   $0x0
  802632:	50                   	push   %eax
  802633:	6a 21                	push   $0x21
  802635:	e8 6e fc ff ff       	call   8022a8 <syscall>
  80263a:	83 c4 18             	add    $0x18,%esp
}
  80263d:	90                   	nop
  80263e:	c9                   	leave  
  80263f:	c3                   	ret    

00802640 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802640:	55                   	push   %ebp
  802641:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802643:	8b 45 08             	mov    0x8(%ebp),%eax
  802646:	6a 00                	push   $0x0
  802648:	6a 00                	push   $0x0
  80264a:	6a 00                	push   $0x0
  80264c:	6a 00                	push   $0x0
  80264e:	50                   	push   %eax
  80264f:	6a 22                	push   $0x22
  802651:	e8 52 fc ff ff       	call   8022a8 <syscall>
  802656:	83 c4 18             	add    $0x18,%esp
}
  802659:	c9                   	leave  
  80265a:	c3                   	ret    

0080265b <sys_getenvid>:

int32 sys_getenvid(void)
{
  80265b:	55                   	push   %ebp
  80265c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80265e:	6a 00                	push   $0x0
  802660:	6a 00                	push   $0x0
  802662:	6a 00                	push   $0x0
  802664:	6a 00                	push   $0x0
  802666:	6a 00                	push   $0x0
  802668:	6a 02                	push   $0x2
  80266a:	e8 39 fc ff ff       	call   8022a8 <syscall>
  80266f:	83 c4 18             	add    $0x18,%esp
}
  802672:	c9                   	leave  
  802673:	c3                   	ret    

00802674 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802674:	55                   	push   %ebp
  802675:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802677:	6a 00                	push   $0x0
  802679:	6a 00                	push   $0x0
  80267b:	6a 00                	push   $0x0
  80267d:	6a 00                	push   $0x0
  80267f:	6a 00                	push   $0x0
  802681:	6a 03                	push   $0x3
  802683:	e8 20 fc ff ff       	call   8022a8 <syscall>
  802688:	83 c4 18             	add    $0x18,%esp
}
  80268b:	c9                   	leave  
  80268c:	c3                   	ret    

0080268d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80268d:	55                   	push   %ebp
  80268e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802690:	6a 00                	push   $0x0
  802692:	6a 00                	push   $0x0
  802694:	6a 00                	push   $0x0
  802696:	6a 00                	push   $0x0
  802698:	6a 00                	push   $0x0
  80269a:	6a 04                	push   $0x4
  80269c:	e8 07 fc ff ff       	call   8022a8 <syscall>
  8026a1:	83 c4 18             	add    $0x18,%esp
}
  8026a4:	c9                   	leave  
  8026a5:	c3                   	ret    

008026a6 <sys_exit_env>:


void sys_exit_env(void)
{
  8026a6:	55                   	push   %ebp
  8026a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8026a9:	6a 00                	push   $0x0
  8026ab:	6a 00                	push   $0x0
  8026ad:	6a 00                	push   $0x0
  8026af:	6a 00                	push   $0x0
  8026b1:	6a 00                	push   $0x0
  8026b3:	6a 23                	push   $0x23
  8026b5:	e8 ee fb ff ff       	call   8022a8 <syscall>
  8026ba:	83 c4 18             	add    $0x18,%esp
}
  8026bd:	90                   	nop
  8026be:	c9                   	leave  
  8026bf:	c3                   	ret    

008026c0 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8026c0:	55                   	push   %ebp
  8026c1:	89 e5                	mov    %esp,%ebp
  8026c3:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8026c6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8026c9:	8d 50 04             	lea    0x4(%eax),%edx
  8026cc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8026cf:	6a 00                	push   $0x0
  8026d1:	6a 00                	push   $0x0
  8026d3:	6a 00                	push   $0x0
  8026d5:	52                   	push   %edx
  8026d6:	50                   	push   %eax
  8026d7:	6a 24                	push   $0x24
  8026d9:	e8 ca fb ff ff       	call   8022a8 <syscall>
  8026de:	83 c4 18             	add    $0x18,%esp
	return result;
  8026e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8026e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8026ea:	89 01                	mov    %eax,(%ecx)
  8026ec:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8026ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f2:	c9                   	leave  
  8026f3:	c2 04 00             	ret    $0x4

008026f6 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8026f6:	55                   	push   %ebp
  8026f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8026f9:	6a 00                	push   $0x0
  8026fb:	6a 00                	push   $0x0
  8026fd:	ff 75 10             	pushl  0x10(%ebp)
  802700:	ff 75 0c             	pushl  0xc(%ebp)
  802703:	ff 75 08             	pushl  0x8(%ebp)
  802706:	6a 12                	push   $0x12
  802708:	e8 9b fb ff ff       	call   8022a8 <syscall>
  80270d:	83 c4 18             	add    $0x18,%esp
	return ;
  802710:	90                   	nop
}
  802711:	c9                   	leave  
  802712:	c3                   	ret    

00802713 <sys_rcr2>:
uint32 sys_rcr2()
{
  802713:	55                   	push   %ebp
  802714:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802716:	6a 00                	push   $0x0
  802718:	6a 00                	push   $0x0
  80271a:	6a 00                	push   $0x0
  80271c:	6a 00                	push   $0x0
  80271e:	6a 00                	push   $0x0
  802720:	6a 25                	push   $0x25
  802722:	e8 81 fb ff ff       	call   8022a8 <syscall>
  802727:	83 c4 18             	add    $0x18,%esp
}
  80272a:	c9                   	leave  
  80272b:	c3                   	ret    

0080272c <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80272c:	55                   	push   %ebp
  80272d:	89 e5                	mov    %esp,%ebp
  80272f:	83 ec 04             	sub    $0x4,%esp
  802732:	8b 45 08             	mov    0x8(%ebp),%eax
  802735:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802738:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80273c:	6a 00                	push   $0x0
  80273e:	6a 00                	push   $0x0
  802740:	6a 00                	push   $0x0
  802742:	6a 00                	push   $0x0
  802744:	50                   	push   %eax
  802745:	6a 26                	push   $0x26
  802747:	e8 5c fb ff ff       	call   8022a8 <syscall>
  80274c:	83 c4 18             	add    $0x18,%esp
	return ;
  80274f:	90                   	nop
}
  802750:	c9                   	leave  
  802751:	c3                   	ret    

00802752 <rsttst>:
void rsttst()
{
  802752:	55                   	push   %ebp
  802753:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802755:	6a 00                	push   $0x0
  802757:	6a 00                	push   $0x0
  802759:	6a 00                	push   $0x0
  80275b:	6a 00                	push   $0x0
  80275d:	6a 00                	push   $0x0
  80275f:	6a 28                	push   $0x28
  802761:	e8 42 fb ff ff       	call   8022a8 <syscall>
  802766:	83 c4 18             	add    $0x18,%esp
	return ;
  802769:	90                   	nop
}
  80276a:	c9                   	leave  
  80276b:	c3                   	ret    

0080276c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80276c:	55                   	push   %ebp
  80276d:	89 e5                	mov    %esp,%ebp
  80276f:	83 ec 04             	sub    $0x4,%esp
  802772:	8b 45 14             	mov    0x14(%ebp),%eax
  802775:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802778:	8b 55 18             	mov    0x18(%ebp),%edx
  80277b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80277f:	52                   	push   %edx
  802780:	50                   	push   %eax
  802781:	ff 75 10             	pushl  0x10(%ebp)
  802784:	ff 75 0c             	pushl  0xc(%ebp)
  802787:	ff 75 08             	pushl  0x8(%ebp)
  80278a:	6a 27                	push   $0x27
  80278c:	e8 17 fb ff ff       	call   8022a8 <syscall>
  802791:	83 c4 18             	add    $0x18,%esp
	return ;
  802794:	90                   	nop
}
  802795:	c9                   	leave  
  802796:	c3                   	ret    

00802797 <chktst>:
void chktst(uint32 n)
{
  802797:	55                   	push   %ebp
  802798:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80279a:	6a 00                	push   $0x0
  80279c:	6a 00                	push   $0x0
  80279e:	6a 00                	push   $0x0
  8027a0:	6a 00                	push   $0x0
  8027a2:	ff 75 08             	pushl  0x8(%ebp)
  8027a5:	6a 29                	push   $0x29
  8027a7:	e8 fc fa ff ff       	call   8022a8 <syscall>
  8027ac:	83 c4 18             	add    $0x18,%esp
	return ;
  8027af:	90                   	nop
}
  8027b0:	c9                   	leave  
  8027b1:	c3                   	ret    

008027b2 <inctst>:

void inctst()
{
  8027b2:	55                   	push   %ebp
  8027b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8027b5:	6a 00                	push   $0x0
  8027b7:	6a 00                	push   $0x0
  8027b9:	6a 00                	push   $0x0
  8027bb:	6a 00                	push   $0x0
  8027bd:	6a 00                	push   $0x0
  8027bf:	6a 2a                	push   $0x2a
  8027c1:	e8 e2 fa ff ff       	call   8022a8 <syscall>
  8027c6:	83 c4 18             	add    $0x18,%esp
	return ;
  8027c9:	90                   	nop
}
  8027ca:	c9                   	leave  
  8027cb:	c3                   	ret    

008027cc <gettst>:
uint32 gettst()
{
  8027cc:	55                   	push   %ebp
  8027cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8027cf:	6a 00                	push   $0x0
  8027d1:	6a 00                	push   $0x0
  8027d3:	6a 00                	push   $0x0
  8027d5:	6a 00                	push   $0x0
  8027d7:	6a 00                	push   $0x0
  8027d9:	6a 2b                	push   $0x2b
  8027db:	e8 c8 fa ff ff       	call   8022a8 <syscall>
  8027e0:	83 c4 18             	add    $0x18,%esp
}
  8027e3:	c9                   	leave  
  8027e4:	c3                   	ret    

008027e5 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8027e5:	55                   	push   %ebp
  8027e6:	89 e5                	mov    %esp,%ebp
  8027e8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027eb:	6a 00                	push   $0x0
  8027ed:	6a 00                	push   $0x0
  8027ef:	6a 00                	push   $0x0
  8027f1:	6a 00                	push   $0x0
  8027f3:	6a 00                	push   $0x0
  8027f5:	6a 2c                	push   $0x2c
  8027f7:	e8 ac fa ff ff       	call   8022a8 <syscall>
  8027fc:	83 c4 18             	add    $0x18,%esp
  8027ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802802:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802806:	75 07                	jne    80280f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802808:	b8 01 00 00 00       	mov    $0x1,%eax
  80280d:	eb 05                	jmp    802814 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80280f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802814:	c9                   	leave  
  802815:	c3                   	ret    

00802816 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802816:	55                   	push   %ebp
  802817:	89 e5                	mov    %esp,%ebp
  802819:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80281c:	6a 00                	push   $0x0
  80281e:	6a 00                	push   $0x0
  802820:	6a 00                	push   $0x0
  802822:	6a 00                	push   $0x0
  802824:	6a 00                	push   $0x0
  802826:	6a 2c                	push   $0x2c
  802828:	e8 7b fa ff ff       	call   8022a8 <syscall>
  80282d:	83 c4 18             	add    $0x18,%esp
  802830:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802833:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802837:	75 07                	jne    802840 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802839:	b8 01 00 00 00       	mov    $0x1,%eax
  80283e:	eb 05                	jmp    802845 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802840:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802845:	c9                   	leave  
  802846:	c3                   	ret    

00802847 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802847:	55                   	push   %ebp
  802848:	89 e5                	mov    %esp,%ebp
  80284a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80284d:	6a 00                	push   $0x0
  80284f:	6a 00                	push   $0x0
  802851:	6a 00                	push   $0x0
  802853:	6a 00                	push   $0x0
  802855:	6a 00                	push   $0x0
  802857:	6a 2c                	push   $0x2c
  802859:	e8 4a fa ff ff       	call   8022a8 <syscall>
  80285e:	83 c4 18             	add    $0x18,%esp
  802861:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802864:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802868:	75 07                	jne    802871 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80286a:	b8 01 00 00 00       	mov    $0x1,%eax
  80286f:	eb 05                	jmp    802876 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802871:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802876:	c9                   	leave  
  802877:	c3                   	ret    

00802878 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802878:	55                   	push   %ebp
  802879:	89 e5                	mov    %esp,%ebp
  80287b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80287e:	6a 00                	push   $0x0
  802880:	6a 00                	push   $0x0
  802882:	6a 00                	push   $0x0
  802884:	6a 00                	push   $0x0
  802886:	6a 00                	push   $0x0
  802888:	6a 2c                	push   $0x2c
  80288a:	e8 19 fa ff ff       	call   8022a8 <syscall>
  80288f:	83 c4 18             	add    $0x18,%esp
  802892:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802895:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802899:	75 07                	jne    8028a2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80289b:	b8 01 00 00 00       	mov    $0x1,%eax
  8028a0:	eb 05                	jmp    8028a7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8028a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028a7:	c9                   	leave  
  8028a8:	c3                   	ret    

008028a9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8028a9:	55                   	push   %ebp
  8028aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8028ac:	6a 00                	push   $0x0
  8028ae:	6a 00                	push   $0x0
  8028b0:	6a 00                	push   $0x0
  8028b2:	6a 00                	push   $0x0
  8028b4:	ff 75 08             	pushl  0x8(%ebp)
  8028b7:	6a 2d                	push   $0x2d
  8028b9:	e8 ea f9 ff ff       	call   8022a8 <syscall>
  8028be:	83 c4 18             	add    $0x18,%esp
	return ;
  8028c1:	90                   	nop
}
  8028c2:	c9                   	leave  
  8028c3:	c3                   	ret    

008028c4 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8028c4:	55                   	push   %ebp
  8028c5:	89 e5                	mov    %esp,%ebp
  8028c7:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8028c8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8028cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8028ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d4:	6a 00                	push   $0x0
  8028d6:	53                   	push   %ebx
  8028d7:	51                   	push   %ecx
  8028d8:	52                   	push   %edx
  8028d9:	50                   	push   %eax
  8028da:	6a 2e                	push   $0x2e
  8028dc:	e8 c7 f9 ff ff       	call   8022a8 <syscall>
  8028e1:	83 c4 18             	add    $0x18,%esp
}
  8028e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8028e7:	c9                   	leave  
  8028e8:	c3                   	ret    

008028e9 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8028e9:	55                   	push   %ebp
  8028ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8028ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f2:	6a 00                	push   $0x0
  8028f4:	6a 00                	push   $0x0
  8028f6:	6a 00                	push   $0x0
  8028f8:	52                   	push   %edx
  8028f9:	50                   	push   %eax
  8028fa:	6a 2f                	push   $0x2f
  8028fc:	e8 a7 f9 ff ff       	call   8022a8 <syscall>
  802901:	83 c4 18             	add    $0x18,%esp
}
  802904:	c9                   	leave  
  802905:	c3                   	ret    

00802906 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802906:	55                   	push   %ebp
  802907:	89 e5                	mov    %esp,%ebp
  802909:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80290c:	83 ec 0c             	sub    $0xc,%esp
  80290f:	68 00 46 80 00       	push   $0x804600
  802914:	e8 c3 e6 ff ff       	call   800fdc <cprintf>
  802919:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80291c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802923:	83 ec 0c             	sub    $0xc,%esp
  802926:	68 2c 46 80 00       	push   $0x80462c
  80292b:	e8 ac e6 ff ff       	call   800fdc <cprintf>
  802930:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802933:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802937:	a1 38 51 80 00       	mov    0x805138,%eax
  80293c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80293f:	eb 56                	jmp    802997 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802941:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802945:	74 1c                	je     802963 <print_mem_block_lists+0x5d>
  802947:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294a:	8b 50 08             	mov    0x8(%eax),%edx
  80294d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802950:	8b 48 08             	mov    0x8(%eax),%ecx
  802953:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802956:	8b 40 0c             	mov    0xc(%eax),%eax
  802959:	01 c8                	add    %ecx,%eax
  80295b:	39 c2                	cmp    %eax,%edx
  80295d:	73 04                	jae    802963 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80295f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802963:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802966:	8b 50 08             	mov    0x8(%eax),%edx
  802969:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296c:	8b 40 0c             	mov    0xc(%eax),%eax
  80296f:	01 c2                	add    %eax,%edx
  802971:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802974:	8b 40 08             	mov    0x8(%eax),%eax
  802977:	83 ec 04             	sub    $0x4,%esp
  80297a:	52                   	push   %edx
  80297b:	50                   	push   %eax
  80297c:	68 41 46 80 00       	push   $0x804641
  802981:	e8 56 e6 ff ff       	call   800fdc <cprintf>
  802986:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802989:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80298f:	a1 40 51 80 00       	mov    0x805140,%eax
  802994:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802997:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80299b:	74 07                	je     8029a4 <print_mem_block_lists+0x9e>
  80299d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a0:	8b 00                	mov    (%eax),%eax
  8029a2:	eb 05                	jmp    8029a9 <print_mem_block_lists+0xa3>
  8029a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a9:	a3 40 51 80 00       	mov    %eax,0x805140
  8029ae:	a1 40 51 80 00       	mov    0x805140,%eax
  8029b3:	85 c0                	test   %eax,%eax
  8029b5:	75 8a                	jne    802941 <print_mem_block_lists+0x3b>
  8029b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029bb:	75 84                	jne    802941 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8029bd:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8029c1:	75 10                	jne    8029d3 <print_mem_block_lists+0xcd>
  8029c3:	83 ec 0c             	sub    $0xc,%esp
  8029c6:	68 50 46 80 00       	push   $0x804650
  8029cb:	e8 0c e6 ff ff       	call   800fdc <cprintf>
  8029d0:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8029d3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8029da:	83 ec 0c             	sub    $0xc,%esp
  8029dd:	68 74 46 80 00       	push   $0x804674
  8029e2:	e8 f5 e5 ff ff       	call   800fdc <cprintf>
  8029e7:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8029ea:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8029ee:	a1 40 50 80 00       	mov    0x805040,%eax
  8029f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029f6:	eb 56                	jmp    802a4e <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8029f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029fc:	74 1c                	je     802a1a <print_mem_block_lists+0x114>
  8029fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a01:	8b 50 08             	mov    0x8(%eax),%edx
  802a04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a07:	8b 48 08             	mov    0x8(%eax),%ecx
  802a0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0d:	8b 40 0c             	mov    0xc(%eax),%eax
  802a10:	01 c8                	add    %ecx,%eax
  802a12:	39 c2                	cmp    %eax,%edx
  802a14:	73 04                	jae    802a1a <print_mem_block_lists+0x114>
			sorted = 0 ;
  802a16:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1d:	8b 50 08             	mov    0x8(%eax),%edx
  802a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a23:	8b 40 0c             	mov    0xc(%eax),%eax
  802a26:	01 c2                	add    %eax,%edx
  802a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2b:	8b 40 08             	mov    0x8(%eax),%eax
  802a2e:	83 ec 04             	sub    $0x4,%esp
  802a31:	52                   	push   %edx
  802a32:	50                   	push   %eax
  802a33:	68 41 46 80 00       	push   $0x804641
  802a38:	e8 9f e5 ff ff       	call   800fdc <cprintf>
  802a3d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a43:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802a46:	a1 48 50 80 00       	mov    0x805048,%eax
  802a4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a4e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a52:	74 07                	je     802a5b <print_mem_block_lists+0x155>
  802a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a57:	8b 00                	mov    (%eax),%eax
  802a59:	eb 05                	jmp    802a60 <print_mem_block_lists+0x15a>
  802a5b:	b8 00 00 00 00       	mov    $0x0,%eax
  802a60:	a3 48 50 80 00       	mov    %eax,0x805048
  802a65:	a1 48 50 80 00       	mov    0x805048,%eax
  802a6a:	85 c0                	test   %eax,%eax
  802a6c:	75 8a                	jne    8029f8 <print_mem_block_lists+0xf2>
  802a6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a72:	75 84                	jne    8029f8 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802a74:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802a78:	75 10                	jne    802a8a <print_mem_block_lists+0x184>
  802a7a:	83 ec 0c             	sub    $0xc,%esp
  802a7d:	68 8c 46 80 00       	push   $0x80468c
  802a82:	e8 55 e5 ff ff       	call   800fdc <cprintf>
  802a87:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802a8a:	83 ec 0c             	sub    $0xc,%esp
  802a8d:	68 00 46 80 00       	push   $0x804600
  802a92:	e8 45 e5 ff ff       	call   800fdc <cprintf>
  802a97:	83 c4 10             	add    $0x10,%esp

}
  802a9a:	90                   	nop
  802a9b:	c9                   	leave  
  802a9c:	c3                   	ret    

00802a9d <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802a9d:	55                   	push   %ebp
  802a9e:	89 e5                	mov    %esp,%ebp
  802aa0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  802aa3:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802aaa:	00 00 00 
  802aad:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802ab4:	00 00 00 
  802ab7:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802abe:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802ac1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802ac8:	e9 9e 00 00 00       	jmp    802b6b <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802acd:	a1 50 50 80 00       	mov    0x805050,%eax
  802ad2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ad5:	c1 e2 04             	shl    $0x4,%edx
  802ad8:	01 d0                	add    %edx,%eax
  802ada:	85 c0                	test   %eax,%eax
  802adc:	75 14                	jne    802af2 <initialize_MemBlocksList+0x55>
  802ade:	83 ec 04             	sub    $0x4,%esp
  802ae1:	68 b4 46 80 00       	push   $0x8046b4
  802ae6:	6a 47                	push   $0x47
  802ae8:	68 d7 46 80 00       	push   $0x8046d7
  802aed:	e8 36 e2 ff ff       	call   800d28 <_panic>
  802af2:	a1 50 50 80 00       	mov    0x805050,%eax
  802af7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802afa:	c1 e2 04             	shl    $0x4,%edx
  802afd:	01 d0                	add    %edx,%eax
  802aff:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802b05:	89 10                	mov    %edx,(%eax)
  802b07:	8b 00                	mov    (%eax),%eax
  802b09:	85 c0                	test   %eax,%eax
  802b0b:	74 18                	je     802b25 <initialize_MemBlocksList+0x88>
  802b0d:	a1 48 51 80 00       	mov    0x805148,%eax
  802b12:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802b18:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802b1b:	c1 e1 04             	shl    $0x4,%ecx
  802b1e:	01 ca                	add    %ecx,%edx
  802b20:	89 50 04             	mov    %edx,0x4(%eax)
  802b23:	eb 12                	jmp    802b37 <initialize_MemBlocksList+0x9a>
  802b25:	a1 50 50 80 00       	mov    0x805050,%eax
  802b2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b2d:	c1 e2 04             	shl    $0x4,%edx
  802b30:	01 d0                	add    %edx,%eax
  802b32:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b37:	a1 50 50 80 00       	mov    0x805050,%eax
  802b3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b3f:	c1 e2 04             	shl    $0x4,%edx
  802b42:	01 d0                	add    %edx,%eax
  802b44:	a3 48 51 80 00       	mov    %eax,0x805148
  802b49:	a1 50 50 80 00       	mov    0x805050,%eax
  802b4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b51:	c1 e2 04             	shl    $0x4,%edx
  802b54:	01 d0                	add    %edx,%eax
  802b56:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b5d:	a1 54 51 80 00       	mov    0x805154,%eax
  802b62:	40                   	inc    %eax
  802b63:	a3 54 51 80 00       	mov    %eax,0x805154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802b68:	ff 45 f4             	incl   -0xc(%ebp)
  802b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b71:	0f 82 56 ff ff ff    	jb     802acd <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  802b77:	90                   	nop
  802b78:	c9                   	leave  
  802b79:	c3                   	ret    

00802b7a <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802b7a:	55                   	push   %ebp
  802b7b:	89 e5                	mov    %esp,%ebp
  802b7d:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802b80:	8b 45 08             	mov    0x8(%ebp),%eax
  802b83:	8b 00                	mov    (%eax),%eax
  802b85:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802b88:	eb 19                	jmp    802ba3 <find_block+0x29>
	{
		if(element->sva == va){
  802b8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b8d:	8b 40 08             	mov    0x8(%eax),%eax
  802b90:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802b93:	75 05                	jne    802b9a <find_block+0x20>
			 		return element;
  802b95:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b98:	eb 36                	jmp    802bd0 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9d:	8b 40 08             	mov    0x8(%eax),%eax
  802ba0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802ba3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802ba7:	74 07                	je     802bb0 <find_block+0x36>
  802ba9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802bac:	8b 00                	mov    (%eax),%eax
  802bae:	eb 05                	jmp    802bb5 <find_block+0x3b>
  802bb0:	b8 00 00 00 00       	mov    $0x0,%eax
  802bb5:	8b 55 08             	mov    0x8(%ebp),%edx
  802bb8:	89 42 08             	mov    %eax,0x8(%edx)
  802bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbe:	8b 40 08             	mov    0x8(%eax),%eax
  802bc1:	85 c0                	test   %eax,%eax
  802bc3:	75 c5                	jne    802b8a <find_block+0x10>
  802bc5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802bc9:	75 bf                	jne    802b8a <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  802bcb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bd0:	c9                   	leave  
  802bd1:	c3                   	ret    

00802bd2 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802bd2:	55                   	push   %ebp
  802bd3:	89 e5                	mov    %esp,%ebp
  802bd5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  802bd8:	a1 44 50 80 00       	mov    0x805044,%eax
  802bdd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  802be0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802be5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  802be8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bec:	74 0a                	je     802bf8 <insert_sorted_allocList+0x26>
  802bee:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf1:	8b 40 08             	mov    0x8(%eax),%eax
  802bf4:	85 c0                	test   %eax,%eax
  802bf6:	75 65                	jne    802c5d <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802bf8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bfc:	75 14                	jne    802c12 <insert_sorted_allocList+0x40>
  802bfe:	83 ec 04             	sub    $0x4,%esp
  802c01:	68 b4 46 80 00       	push   $0x8046b4
  802c06:	6a 6e                	push   $0x6e
  802c08:	68 d7 46 80 00       	push   $0x8046d7
  802c0d:	e8 16 e1 ff ff       	call   800d28 <_panic>
  802c12:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802c18:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1b:	89 10                	mov    %edx,(%eax)
  802c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c20:	8b 00                	mov    (%eax),%eax
  802c22:	85 c0                	test   %eax,%eax
  802c24:	74 0d                	je     802c33 <insert_sorted_allocList+0x61>
  802c26:	a1 40 50 80 00       	mov    0x805040,%eax
  802c2b:	8b 55 08             	mov    0x8(%ebp),%edx
  802c2e:	89 50 04             	mov    %edx,0x4(%eax)
  802c31:	eb 08                	jmp    802c3b <insert_sorted_allocList+0x69>
  802c33:	8b 45 08             	mov    0x8(%ebp),%eax
  802c36:	a3 44 50 80 00       	mov    %eax,0x805044
  802c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3e:	a3 40 50 80 00       	mov    %eax,0x805040
  802c43:	8b 45 08             	mov    0x8(%ebp),%eax
  802c46:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c4d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c52:	40                   	inc    %eax
  802c53:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802c58:	e9 cf 01 00 00       	jmp    802e2c <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  802c5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c60:	8b 50 08             	mov    0x8(%eax),%edx
  802c63:	8b 45 08             	mov    0x8(%ebp),%eax
  802c66:	8b 40 08             	mov    0x8(%eax),%eax
  802c69:	39 c2                	cmp    %eax,%edx
  802c6b:	73 65                	jae    802cd2 <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802c6d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c71:	75 14                	jne    802c87 <insert_sorted_allocList+0xb5>
  802c73:	83 ec 04             	sub    $0x4,%esp
  802c76:	68 f0 46 80 00       	push   $0x8046f0
  802c7b:	6a 72                	push   $0x72
  802c7d:	68 d7 46 80 00       	push   $0x8046d7
  802c82:	e8 a1 e0 ff ff       	call   800d28 <_panic>
  802c87:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c90:	89 50 04             	mov    %edx,0x4(%eax)
  802c93:	8b 45 08             	mov    0x8(%ebp),%eax
  802c96:	8b 40 04             	mov    0x4(%eax),%eax
  802c99:	85 c0                	test   %eax,%eax
  802c9b:	74 0c                	je     802ca9 <insert_sorted_allocList+0xd7>
  802c9d:	a1 44 50 80 00       	mov    0x805044,%eax
  802ca2:	8b 55 08             	mov    0x8(%ebp),%edx
  802ca5:	89 10                	mov    %edx,(%eax)
  802ca7:	eb 08                	jmp    802cb1 <insert_sorted_allocList+0xdf>
  802ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cac:	a3 40 50 80 00       	mov    %eax,0x805040
  802cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb4:	a3 44 50 80 00       	mov    %eax,0x805044
  802cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cc2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802cc7:	40                   	inc    %eax
  802cc8:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  802ccd:	e9 5a 01 00 00       	jmp    802e2c <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  802cd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd5:	8b 50 08             	mov    0x8(%eax),%edx
  802cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdb:	8b 40 08             	mov    0x8(%eax),%eax
  802cde:	39 c2                	cmp    %eax,%edx
  802ce0:	75 70                	jne    802d52 <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  802ce2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ce6:	74 06                	je     802cee <insert_sorted_allocList+0x11c>
  802ce8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cec:	75 14                	jne    802d02 <insert_sorted_allocList+0x130>
  802cee:	83 ec 04             	sub    $0x4,%esp
  802cf1:	68 14 47 80 00       	push   $0x804714
  802cf6:	6a 75                	push   $0x75
  802cf8:	68 d7 46 80 00       	push   $0x8046d7
  802cfd:	e8 26 e0 ff ff       	call   800d28 <_panic>
  802d02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d05:	8b 10                	mov    (%eax),%edx
  802d07:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0a:	89 10                	mov    %edx,(%eax)
  802d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0f:	8b 00                	mov    (%eax),%eax
  802d11:	85 c0                	test   %eax,%eax
  802d13:	74 0b                	je     802d20 <insert_sorted_allocList+0x14e>
  802d15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d18:	8b 00                	mov    (%eax),%eax
  802d1a:	8b 55 08             	mov    0x8(%ebp),%edx
  802d1d:	89 50 04             	mov    %edx,0x4(%eax)
  802d20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d23:	8b 55 08             	mov    0x8(%ebp),%edx
  802d26:	89 10                	mov    %edx,(%eax)
  802d28:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d2e:	89 50 04             	mov    %edx,0x4(%eax)
  802d31:	8b 45 08             	mov    0x8(%ebp),%eax
  802d34:	8b 00                	mov    (%eax),%eax
  802d36:	85 c0                	test   %eax,%eax
  802d38:	75 08                	jne    802d42 <insert_sorted_allocList+0x170>
  802d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3d:	a3 44 50 80 00       	mov    %eax,0x805044
  802d42:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802d47:	40                   	inc    %eax
  802d48:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  802d4d:	e9 da 00 00 00       	jmp    802e2c <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802d52:	a1 40 50 80 00       	mov    0x805040,%eax
  802d57:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d5a:	e9 9d 00 00 00       	jmp    802dfc <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  802d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d62:	8b 00                	mov    (%eax),%eax
  802d64:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  802d67:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6a:	8b 50 08             	mov    0x8(%eax),%edx
  802d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d70:	8b 40 08             	mov    0x8(%eax),%eax
  802d73:	39 c2                	cmp    %eax,%edx
  802d75:	76 7d                	jbe    802df4 <insert_sorted_allocList+0x222>
  802d77:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7a:	8b 50 08             	mov    0x8(%eax),%edx
  802d7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d80:	8b 40 08             	mov    0x8(%eax),%eax
  802d83:	39 c2                	cmp    %eax,%edx
  802d85:	73 6d                	jae    802df4 <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802d87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d8b:	74 06                	je     802d93 <insert_sorted_allocList+0x1c1>
  802d8d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d91:	75 14                	jne    802da7 <insert_sorted_allocList+0x1d5>
  802d93:	83 ec 04             	sub    $0x4,%esp
  802d96:	68 14 47 80 00       	push   $0x804714
  802d9b:	6a 7c                	push   $0x7c
  802d9d:	68 d7 46 80 00       	push   $0x8046d7
  802da2:	e8 81 df ff ff       	call   800d28 <_panic>
  802da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802daa:	8b 10                	mov    (%eax),%edx
  802dac:	8b 45 08             	mov    0x8(%ebp),%eax
  802daf:	89 10                	mov    %edx,(%eax)
  802db1:	8b 45 08             	mov    0x8(%ebp),%eax
  802db4:	8b 00                	mov    (%eax),%eax
  802db6:	85 c0                	test   %eax,%eax
  802db8:	74 0b                	je     802dc5 <insert_sorted_allocList+0x1f3>
  802dba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbd:	8b 00                	mov    (%eax),%eax
  802dbf:	8b 55 08             	mov    0x8(%ebp),%edx
  802dc2:	89 50 04             	mov    %edx,0x4(%eax)
  802dc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc8:	8b 55 08             	mov    0x8(%ebp),%edx
  802dcb:	89 10                	mov    %edx,(%eax)
  802dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dd3:	89 50 04             	mov    %edx,0x4(%eax)
  802dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd9:	8b 00                	mov    (%eax),%eax
  802ddb:	85 c0                	test   %eax,%eax
  802ddd:	75 08                	jne    802de7 <insert_sorted_allocList+0x215>
  802ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  802de2:	a3 44 50 80 00       	mov    %eax,0x805044
  802de7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802dec:	40                   	inc    %eax
  802ded:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802df2:	eb 38                	jmp    802e2c <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802df4:	a1 48 50 80 00       	mov    0x805048,%eax
  802df9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dfc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e00:	74 07                	je     802e09 <insert_sorted_allocList+0x237>
  802e02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e05:	8b 00                	mov    (%eax),%eax
  802e07:	eb 05                	jmp    802e0e <insert_sorted_allocList+0x23c>
  802e09:	b8 00 00 00 00       	mov    $0x0,%eax
  802e0e:	a3 48 50 80 00       	mov    %eax,0x805048
  802e13:	a1 48 50 80 00       	mov    0x805048,%eax
  802e18:	85 c0                	test   %eax,%eax
  802e1a:	0f 85 3f ff ff ff    	jne    802d5f <insert_sorted_allocList+0x18d>
  802e20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e24:	0f 85 35 ff ff ff    	jne    802d5f <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  802e2a:	eb 00                	jmp    802e2c <insert_sorted_allocList+0x25a>
  802e2c:	90                   	nop
  802e2d:	c9                   	leave  
  802e2e:	c3                   	ret    

00802e2f <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802e2f:	55                   	push   %ebp
  802e30:	89 e5                	mov    %esp,%ebp
  802e32:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802e35:	a1 38 51 80 00       	mov    0x805138,%eax
  802e3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e3d:	e9 6b 02 00 00       	jmp    8030ad <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  802e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e45:	8b 40 0c             	mov    0xc(%eax),%eax
  802e48:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e4b:	0f 85 90 00 00 00    	jne    802ee1 <alloc_block_FF+0xb2>
			  temp=element;
  802e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e54:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  802e57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e5b:	75 17                	jne    802e74 <alloc_block_FF+0x45>
  802e5d:	83 ec 04             	sub    $0x4,%esp
  802e60:	68 48 47 80 00       	push   $0x804748
  802e65:	68 92 00 00 00       	push   $0x92
  802e6a:	68 d7 46 80 00       	push   $0x8046d7
  802e6f:	e8 b4 de ff ff       	call   800d28 <_panic>
  802e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e77:	8b 00                	mov    (%eax),%eax
  802e79:	85 c0                	test   %eax,%eax
  802e7b:	74 10                	je     802e8d <alloc_block_FF+0x5e>
  802e7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e80:	8b 00                	mov    (%eax),%eax
  802e82:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e85:	8b 52 04             	mov    0x4(%edx),%edx
  802e88:	89 50 04             	mov    %edx,0x4(%eax)
  802e8b:	eb 0b                	jmp    802e98 <alloc_block_FF+0x69>
  802e8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e90:	8b 40 04             	mov    0x4(%eax),%eax
  802e93:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9b:	8b 40 04             	mov    0x4(%eax),%eax
  802e9e:	85 c0                	test   %eax,%eax
  802ea0:	74 0f                	je     802eb1 <alloc_block_FF+0x82>
  802ea2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea5:	8b 40 04             	mov    0x4(%eax),%eax
  802ea8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eab:	8b 12                	mov    (%edx),%edx
  802ead:	89 10                	mov    %edx,(%eax)
  802eaf:	eb 0a                	jmp    802ebb <alloc_block_FF+0x8c>
  802eb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb4:	8b 00                	mov    (%eax),%eax
  802eb6:	a3 38 51 80 00       	mov    %eax,0x805138
  802ebb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ec4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ece:	a1 44 51 80 00       	mov    0x805144,%eax
  802ed3:	48                   	dec    %eax
  802ed4:	a3 44 51 80 00       	mov    %eax,0x805144
			  return temp;
  802ed9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802edc:	e9 ff 01 00 00       	jmp    8030e0 <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  802ee1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802eea:	0f 86 b5 01 00 00    	jbe    8030a5 <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  802ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ef6:	2b 45 08             	sub    0x8(%ebp),%eax
  802ef9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  802efc:	a1 48 51 80 00       	mov    0x805148,%eax
  802f01:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  802f04:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f08:	75 17                	jne    802f21 <alloc_block_FF+0xf2>
  802f0a:	83 ec 04             	sub    $0x4,%esp
  802f0d:	68 48 47 80 00       	push   $0x804748
  802f12:	68 99 00 00 00       	push   $0x99
  802f17:	68 d7 46 80 00       	push   $0x8046d7
  802f1c:	e8 07 de ff ff       	call   800d28 <_panic>
  802f21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f24:	8b 00                	mov    (%eax),%eax
  802f26:	85 c0                	test   %eax,%eax
  802f28:	74 10                	je     802f3a <alloc_block_FF+0x10b>
  802f2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f2d:	8b 00                	mov    (%eax),%eax
  802f2f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f32:	8b 52 04             	mov    0x4(%edx),%edx
  802f35:	89 50 04             	mov    %edx,0x4(%eax)
  802f38:	eb 0b                	jmp    802f45 <alloc_block_FF+0x116>
  802f3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f3d:	8b 40 04             	mov    0x4(%eax),%eax
  802f40:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f48:	8b 40 04             	mov    0x4(%eax),%eax
  802f4b:	85 c0                	test   %eax,%eax
  802f4d:	74 0f                	je     802f5e <alloc_block_FF+0x12f>
  802f4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f52:	8b 40 04             	mov    0x4(%eax),%eax
  802f55:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f58:	8b 12                	mov    (%edx),%edx
  802f5a:	89 10                	mov    %edx,(%eax)
  802f5c:	eb 0a                	jmp    802f68 <alloc_block_FF+0x139>
  802f5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f61:	8b 00                	mov    (%eax),%eax
  802f63:	a3 48 51 80 00       	mov    %eax,0x805148
  802f68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f6b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f74:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f7b:	a1 54 51 80 00       	mov    0x805154,%eax
  802f80:	48                   	dec    %eax
  802f81:	a3 54 51 80 00       	mov    %eax,0x805154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  802f86:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f8a:	75 17                	jne    802fa3 <alloc_block_FF+0x174>
  802f8c:	83 ec 04             	sub    $0x4,%esp
  802f8f:	68 f0 46 80 00       	push   $0x8046f0
  802f94:	68 9a 00 00 00       	push   $0x9a
  802f99:	68 d7 46 80 00       	push   $0x8046d7
  802f9e:	e8 85 dd ff ff       	call   800d28 <_panic>
  802fa3:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802fa9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fac:	89 50 04             	mov    %edx,0x4(%eax)
  802faf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fb2:	8b 40 04             	mov    0x4(%eax),%eax
  802fb5:	85 c0                	test   %eax,%eax
  802fb7:	74 0c                	je     802fc5 <alloc_block_FF+0x196>
  802fb9:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802fbe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802fc1:	89 10                	mov    %edx,(%eax)
  802fc3:	eb 08                	jmp    802fcd <alloc_block_FF+0x19e>
  802fc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fc8:	a3 38 51 80 00       	mov    %eax,0x805138
  802fcd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fd0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fd8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fde:	a1 44 51 80 00       	mov    0x805144,%eax
  802fe3:	40                   	inc    %eax
  802fe4:	a3 44 51 80 00       	mov    %eax,0x805144
		  // setting the size & sva
		  new_block->size=size;
  802fe9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fec:	8b 55 08             	mov    0x8(%ebp),%edx
  802fef:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  802ff2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff5:	8b 50 08             	mov    0x8(%eax),%edx
  802ff8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ffb:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  802ffe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803001:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803004:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  803007:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300a:	8b 50 08             	mov    0x8(%eax),%edx
  80300d:	8b 45 08             	mov    0x8(%ebp),%eax
  803010:	01 c2                	add    %eax,%edx
  803012:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803015:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  803018:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80301b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  80301e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803022:	75 17                	jne    80303b <alloc_block_FF+0x20c>
  803024:	83 ec 04             	sub    $0x4,%esp
  803027:	68 48 47 80 00       	push   $0x804748
  80302c:	68 a2 00 00 00       	push   $0xa2
  803031:	68 d7 46 80 00       	push   $0x8046d7
  803036:	e8 ed dc ff ff       	call   800d28 <_panic>
  80303b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80303e:	8b 00                	mov    (%eax),%eax
  803040:	85 c0                	test   %eax,%eax
  803042:	74 10                	je     803054 <alloc_block_FF+0x225>
  803044:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803047:	8b 00                	mov    (%eax),%eax
  803049:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80304c:	8b 52 04             	mov    0x4(%edx),%edx
  80304f:	89 50 04             	mov    %edx,0x4(%eax)
  803052:	eb 0b                	jmp    80305f <alloc_block_FF+0x230>
  803054:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803057:	8b 40 04             	mov    0x4(%eax),%eax
  80305a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80305f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803062:	8b 40 04             	mov    0x4(%eax),%eax
  803065:	85 c0                	test   %eax,%eax
  803067:	74 0f                	je     803078 <alloc_block_FF+0x249>
  803069:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80306c:	8b 40 04             	mov    0x4(%eax),%eax
  80306f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803072:	8b 12                	mov    (%edx),%edx
  803074:	89 10                	mov    %edx,(%eax)
  803076:	eb 0a                	jmp    803082 <alloc_block_FF+0x253>
  803078:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80307b:	8b 00                	mov    (%eax),%eax
  80307d:	a3 38 51 80 00       	mov    %eax,0x805138
  803082:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803085:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80308b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80308e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803095:	a1 44 51 80 00       	mov    0x805144,%eax
  80309a:	48                   	dec    %eax
  80309b:	a3 44 51 80 00       	mov    %eax,0x805144
		  return temp;
  8030a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a3:	eb 3b                	jmp    8030e0 <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  8030a5:	a1 40 51 80 00       	mov    0x805140,%eax
  8030aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030b1:	74 07                	je     8030ba <alloc_block_FF+0x28b>
  8030b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b6:	8b 00                	mov    (%eax),%eax
  8030b8:	eb 05                	jmp    8030bf <alloc_block_FF+0x290>
  8030ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8030bf:	a3 40 51 80 00       	mov    %eax,0x805140
  8030c4:	a1 40 51 80 00       	mov    0x805140,%eax
  8030c9:	85 c0                	test   %eax,%eax
  8030cb:	0f 85 71 fd ff ff    	jne    802e42 <alloc_block_FF+0x13>
  8030d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030d5:	0f 85 67 fd ff ff    	jne    802e42 <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  8030db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030e0:	c9                   	leave  
  8030e1:	c3                   	ret    

008030e2 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8030e2:	55                   	push   %ebp
  8030e3:	89 e5                	mov    %esp,%ebp
  8030e5:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  8030e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  8030ef:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  8030f6:	a1 38 51 80 00       	mov    0x805138,%eax
  8030fb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8030fe:	e9 d3 00 00 00       	jmp    8031d6 <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  803103:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803106:	8b 40 0c             	mov    0xc(%eax),%eax
  803109:	3b 45 08             	cmp    0x8(%ebp),%eax
  80310c:	0f 85 90 00 00 00    	jne    8031a2 <alloc_block_BF+0xc0>
	   temp = element;
  803112:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803115:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  803118:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80311c:	75 17                	jne    803135 <alloc_block_BF+0x53>
  80311e:	83 ec 04             	sub    $0x4,%esp
  803121:	68 48 47 80 00       	push   $0x804748
  803126:	68 bd 00 00 00       	push   $0xbd
  80312b:	68 d7 46 80 00       	push   $0x8046d7
  803130:	e8 f3 db ff ff       	call   800d28 <_panic>
  803135:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803138:	8b 00                	mov    (%eax),%eax
  80313a:	85 c0                	test   %eax,%eax
  80313c:	74 10                	je     80314e <alloc_block_BF+0x6c>
  80313e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803141:	8b 00                	mov    (%eax),%eax
  803143:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803146:	8b 52 04             	mov    0x4(%edx),%edx
  803149:	89 50 04             	mov    %edx,0x4(%eax)
  80314c:	eb 0b                	jmp    803159 <alloc_block_BF+0x77>
  80314e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803151:	8b 40 04             	mov    0x4(%eax),%eax
  803154:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803159:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80315c:	8b 40 04             	mov    0x4(%eax),%eax
  80315f:	85 c0                	test   %eax,%eax
  803161:	74 0f                	je     803172 <alloc_block_BF+0x90>
  803163:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803166:	8b 40 04             	mov    0x4(%eax),%eax
  803169:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80316c:	8b 12                	mov    (%edx),%edx
  80316e:	89 10                	mov    %edx,(%eax)
  803170:	eb 0a                	jmp    80317c <alloc_block_BF+0x9a>
  803172:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803175:	8b 00                	mov    (%eax),%eax
  803177:	a3 38 51 80 00       	mov    %eax,0x805138
  80317c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803185:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803188:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80318f:	a1 44 51 80 00       	mov    0x805144,%eax
  803194:	48                   	dec    %eax
  803195:	a3 44 51 80 00       	mov    %eax,0x805144
	   return temp;
  80319a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80319d:	e9 41 01 00 00       	jmp    8032e3 <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  8031a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8031a8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031ab:	76 21                	jbe    8031ce <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  8031ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8031b3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8031b6:	73 16                	jae    8031ce <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  8031b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8031be:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  8031c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  8031c7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  8031ce:	a1 40 51 80 00       	mov    0x805140,%eax
  8031d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8031d6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031da:	74 07                	je     8031e3 <alloc_block_BF+0x101>
  8031dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031df:	8b 00                	mov    (%eax),%eax
  8031e1:	eb 05                	jmp    8031e8 <alloc_block_BF+0x106>
  8031e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8031e8:	a3 40 51 80 00       	mov    %eax,0x805140
  8031ed:	a1 40 51 80 00       	mov    0x805140,%eax
  8031f2:	85 c0                	test   %eax,%eax
  8031f4:	0f 85 09 ff ff ff    	jne    803103 <alloc_block_BF+0x21>
  8031fa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031fe:	0f 85 ff fe ff ff    	jne    803103 <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  803204:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  803208:	0f 85 d0 00 00 00    	jne    8032de <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  80320e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803211:	8b 40 0c             	mov    0xc(%eax),%eax
  803214:	2b 45 08             	sub    0x8(%ebp),%eax
  803217:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  80321a:	a1 48 51 80 00       	mov    0x805148,%eax
  80321f:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  803222:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803226:	75 17                	jne    80323f <alloc_block_BF+0x15d>
  803228:	83 ec 04             	sub    $0x4,%esp
  80322b:	68 48 47 80 00       	push   $0x804748
  803230:	68 d1 00 00 00       	push   $0xd1
  803235:	68 d7 46 80 00       	push   $0x8046d7
  80323a:	e8 e9 da ff ff       	call   800d28 <_panic>
  80323f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803242:	8b 00                	mov    (%eax),%eax
  803244:	85 c0                	test   %eax,%eax
  803246:	74 10                	je     803258 <alloc_block_BF+0x176>
  803248:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80324b:	8b 00                	mov    (%eax),%eax
  80324d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803250:	8b 52 04             	mov    0x4(%edx),%edx
  803253:	89 50 04             	mov    %edx,0x4(%eax)
  803256:	eb 0b                	jmp    803263 <alloc_block_BF+0x181>
  803258:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80325b:	8b 40 04             	mov    0x4(%eax),%eax
  80325e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803263:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803266:	8b 40 04             	mov    0x4(%eax),%eax
  803269:	85 c0                	test   %eax,%eax
  80326b:	74 0f                	je     80327c <alloc_block_BF+0x19a>
  80326d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803270:	8b 40 04             	mov    0x4(%eax),%eax
  803273:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803276:	8b 12                	mov    (%edx),%edx
  803278:	89 10                	mov    %edx,(%eax)
  80327a:	eb 0a                	jmp    803286 <alloc_block_BF+0x1a4>
  80327c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80327f:	8b 00                	mov    (%eax),%eax
  803281:	a3 48 51 80 00       	mov    %eax,0x805148
  803286:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803289:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80328f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803292:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803299:	a1 54 51 80 00       	mov    0x805154,%eax
  80329e:	48                   	dec    %eax
  80329f:	a3 54 51 80 00       	mov    %eax,0x805154
	  // setting the size & sva
	  new_block->size = size;
  8032a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8032aa:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  8032ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032b0:	8b 50 08             	mov    0x8(%eax),%edx
  8032b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032b6:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  8032b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032bc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032bf:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  8032c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032c5:	8b 50 08             	mov    0x8(%eax),%edx
  8032c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cb:	01 c2                	add    %eax,%edx
  8032cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032d0:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  8032d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032d6:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  8032d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032dc:	eb 05                	jmp    8032e3 <alloc_block_BF+0x201>
	 }
	 return NULL;
  8032de:	b8 00 00 00 00       	mov    $0x0,%eax


}
  8032e3:	c9                   	leave  
  8032e4:	c3                   	ret    

008032e5 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8032e5:	55                   	push   %ebp
  8032e6:	89 e5                	mov    %esp,%ebp
  8032e8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  8032eb:	83 ec 04             	sub    $0x4,%esp
  8032ee:	68 68 47 80 00       	push   $0x804768
  8032f3:	68 e8 00 00 00       	push   $0xe8
  8032f8:	68 d7 46 80 00       	push   $0x8046d7
  8032fd:	e8 26 da ff ff       	call   800d28 <_panic>

00803302 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803302:	55                   	push   %ebp
  803303:	89 e5                	mov    %esp,%ebp
  803305:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  803308:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80330d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  803310:	a1 38 51 80 00       	mov    0x805138,%eax
  803315:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  803318:	a1 44 51 80 00       	mov    0x805144,%eax
  80331d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  803320:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803324:	75 68                	jne    80338e <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  803326:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80332a:	75 17                	jne    803343 <insert_sorted_with_merge_freeList+0x41>
  80332c:	83 ec 04             	sub    $0x4,%esp
  80332f:	68 b4 46 80 00       	push   $0x8046b4
  803334:	68 36 01 00 00       	push   $0x136
  803339:	68 d7 46 80 00       	push   $0x8046d7
  80333e:	e8 e5 d9 ff ff       	call   800d28 <_panic>
  803343:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803349:	8b 45 08             	mov    0x8(%ebp),%eax
  80334c:	89 10                	mov    %edx,(%eax)
  80334e:	8b 45 08             	mov    0x8(%ebp),%eax
  803351:	8b 00                	mov    (%eax),%eax
  803353:	85 c0                	test   %eax,%eax
  803355:	74 0d                	je     803364 <insert_sorted_with_merge_freeList+0x62>
  803357:	a1 38 51 80 00       	mov    0x805138,%eax
  80335c:	8b 55 08             	mov    0x8(%ebp),%edx
  80335f:	89 50 04             	mov    %edx,0x4(%eax)
  803362:	eb 08                	jmp    80336c <insert_sorted_with_merge_freeList+0x6a>
  803364:	8b 45 08             	mov    0x8(%ebp),%eax
  803367:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80336c:	8b 45 08             	mov    0x8(%ebp),%eax
  80336f:	a3 38 51 80 00       	mov    %eax,0x805138
  803374:	8b 45 08             	mov    0x8(%ebp),%eax
  803377:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80337e:	a1 44 51 80 00       	mov    0x805144,%eax
  803383:	40                   	inc    %eax
  803384:	a3 44 51 80 00       	mov    %eax,0x805144





}
  803389:	e9 ba 06 00 00       	jmp    803a48 <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  80338e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803391:	8b 50 08             	mov    0x8(%eax),%edx
  803394:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803397:	8b 40 0c             	mov    0xc(%eax),%eax
  80339a:	01 c2                	add    %eax,%edx
  80339c:	8b 45 08             	mov    0x8(%ebp),%eax
  80339f:	8b 40 08             	mov    0x8(%eax),%eax
  8033a2:	39 c2                	cmp    %eax,%edx
  8033a4:	73 68                	jae    80340e <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8033a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033aa:	75 17                	jne    8033c3 <insert_sorted_with_merge_freeList+0xc1>
  8033ac:	83 ec 04             	sub    $0x4,%esp
  8033af:	68 f0 46 80 00       	push   $0x8046f0
  8033b4:	68 3a 01 00 00       	push   $0x13a
  8033b9:	68 d7 46 80 00       	push   $0x8046d7
  8033be:	e8 65 d9 ff ff       	call   800d28 <_panic>
  8033c3:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8033c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033cc:	89 50 04             	mov    %edx,0x4(%eax)
  8033cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d2:	8b 40 04             	mov    0x4(%eax),%eax
  8033d5:	85 c0                	test   %eax,%eax
  8033d7:	74 0c                	je     8033e5 <insert_sorted_with_merge_freeList+0xe3>
  8033d9:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8033de:	8b 55 08             	mov    0x8(%ebp),%edx
  8033e1:	89 10                	mov    %edx,(%eax)
  8033e3:	eb 08                	jmp    8033ed <insert_sorted_with_merge_freeList+0xeb>
  8033e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e8:	a3 38 51 80 00       	mov    %eax,0x805138
  8033ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033fe:	a1 44 51 80 00       	mov    0x805144,%eax
  803403:	40                   	inc    %eax
  803404:	a3 44 51 80 00       	mov    %eax,0x805144





}
  803409:	e9 3a 06 00 00       	jmp    803a48 <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  80340e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803411:	8b 50 08             	mov    0x8(%eax),%edx
  803414:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803417:	8b 40 0c             	mov    0xc(%eax),%eax
  80341a:	01 c2                	add    %eax,%edx
  80341c:	8b 45 08             	mov    0x8(%ebp),%eax
  80341f:	8b 40 08             	mov    0x8(%eax),%eax
  803422:	39 c2                	cmp    %eax,%edx
  803424:	0f 85 90 00 00 00    	jne    8034ba <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  80342a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80342d:	8b 50 0c             	mov    0xc(%eax),%edx
  803430:	8b 45 08             	mov    0x8(%ebp),%eax
  803433:	8b 40 0c             	mov    0xc(%eax),%eax
  803436:	01 c2                	add    %eax,%edx
  803438:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80343b:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  80343e:	8b 45 08             	mov    0x8(%ebp),%eax
  803441:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  803448:	8b 45 08             	mov    0x8(%ebp),%eax
  80344b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803452:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803456:	75 17                	jne    80346f <insert_sorted_with_merge_freeList+0x16d>
  803458:	83 ec 04             	sub    $0x4,%esp
  80345b:	68 b4 46 80 00       	push   $0x8046b4
  803460:	68 41 01 00 00       	push   $0x141
  803465:	68 d7 46 80 00       	push   $0x8046d7
  80346a:	e8 b9 d8 ff ff       	call   800d28 <_panic>
  80346f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803475:	8b 45 08             	mov    0x8(%ebp),%eax
  803478:	89 10                	mov    %edx,(%eax)
  80347a:	8b 45 08             	mov    0x8(%ebp),%eax
  80347d:	8b 00                	mov    (%eax),%eax
  80347f:	85 c0                	test   %eax,%eax
  803481:	74 0d                	je     803490 <insert_sorted_with_merge_freeList+0x18e>
  803483:	a1 48 51 80 00       	mov    0x805148,%eax
  803488:	8b 55 08             	mov    0x8(%ebp),%edx
  80348b:	89 50 04             	mov    %edx,0x4(%eax)
  80348e:	eb 08                	jmp    803498 <insert_sorted_with_merge_freeList+0x196>
  803490:	8b 45 08             	mov    0x8(%ebp),%eax
  803493:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803498:	8b 45 08             	mov    0x8(%ebp),%eax
  80349b:	a3 48 51 80 00       	mov    %eax,0x805148
  8034a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034aa:	a1 54 51 80 00       	mov    0x805154,%eax
  8034af:	40                   	inc    %eax
  8034b0:	a3 54 51 80 00       	mov    %eax,0x805154





}
  8034b5:	e9 8e 05 00 00       	jmp    803a48 <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  8034ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8034bd:	8b 50 08             	mov    0x8(%eax),%edx
  8034c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8034c6:	01 c2                	add    %eax,%edx
  8034c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034cb:	8b 40 08             	mov    0x8(%eax),%eax
  8034ce:	39 c2                	cmp    %eax,%edx
  8034d0:	73 68                	jae    80353a <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8034d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034d6:	75 17                	jne    8034ef <insert_sorted_with_merge_freeList+0x1ed>
  8034d8:	83 ec 04             	sub    $0x4,%esp
  8034db:	68 b4 46 80 00       	push   $0x8046b4
  8034e0:	68 45 01 00 00       	push   $0x145
  8034e5:	68 d7 46 80 00       	push   $0x8046d7
  8034ea:	e8 39 d8 ff ff       	call   800d28 <_panic>
  8034ef:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8034f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f8:	89 10                	mov    %edx,(%eax)
  8034fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fd:	8b 00                	mov    (%eax),%eax
  8034ff:	85 c0                	test   %eax,%eax
  803501:	74 0d                	je     803510 <insert_sorted_with_merge_freeList+0x20e>
  803503:	a1 38 51 80 00       	mov    0x805138,%eax
  803508:	8b 55 08             	mov    0x8(%ebp),%edx
  80350b:	89 50 04             	mov    %edx,0x4(%eax)
  80350e:	eb 08                	jmp    803518 <insert_sorted_with_merge_freeList+0x216>
  803510:	8b 45 08             	mov    0x8(%ebp),%eax
  803513:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803518:	8b 45 08             	mov    0x8(%ebp),%eax
  80351b:	a3 38 51 80 00       	mov    %eax,0x805138
  803520:	8b 45 08             	mov    0x8(%ebp),%eax
  803523:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80352a:	a1 44 51 80 00       	mov    0x805144,%eax
  80352f:	40                   	inc    %eax
  803530:	a3 44 51 80 00       	mov    %eax,0x805144





}
  803535:	e9 0e 05 00 00       	jmp    803a48 <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  80353a:	8b 45 08             	mov    0x8(%ebp),%eax
  80353d:	8b 50 08             	mov    0x8(%eax),%edx
  803540:	8b 45 08             	mov    0x8(%ebp),%eax
  803543:	8b 40 0c             	mov    0xc(%eax),%eax
  803546:	01 c2                	add    %eax,%edx
  803548:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80354b:	8b 40 08             	mov    0x8(%eax),%eax
  80354e:	39 c2                	cmp    %eax,%edx
  803550:	0f 85 9c 00 00 00    	jne    8035f2 <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  803556:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803559:	8b 50 0c             	mov    0xc(%eax),%edx
  80355c:	8b 45 08             	mov    0x8(%ebp),%eax
  80355f:	8b 40 0c             	mov    0xc(%eax),%eax
  803562:	01 c2                	add    %eax,%edx
  803564:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803567:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  80356a:	8b 45 08             	mov    0x8(%ebp),%eax
  80356d:	8b 50 08             	mov    0x8(%eax),%edx
  803570:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803573:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  803576:	8b 45 08             	mov    0x8(%ebp),%eax
  803579:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  803580:	8b 45 08             	mov    0x8(%ebp),%eax
  803583:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80358a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80358e:	75 17                	jne    8035a7 <insert_sorted_with_merge_freeList+0x2a5>
  803590:	83 ec 04             	sub    $0x4,%esp
  803593:	68 b4 46 80 00       	push   $0x8046b4
  803598:	68 4d 01 00 00       	push   $0x14d
  80359d:	68 d7 46 80 00       	push   $0x8046d7
  8035a2:	e8 81 d7 ff ff       	call   800d28 <_panic>
  8035a7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b0:	89 10                	mov    %edx,(%eax)
  8035b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b5:	8b 00                	mov    (%eax),%eax
  8035b7:	85 c0                	test   %eax,%eax
  8035b9:	74 0d                	je     8035c8 <insert_sorted_with_merge_freeList+0x2c6>
  8035bb:	a1 48 51 80 00       	mov    0x805148,%eax
  8035c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8035c3:	89 50 04             	mov    %edx,0x4(%eax)
  8035c6:	eb 08                	jmp    8035d0 <insert_sorted_with_merge_freeList+0x2ce>
  8035c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035cb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d3:	a3 48 51 80 00       	mov    %eax,0x805148
  8035d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035e2:	a1 54 51 80 00       	mov    0x805154,%eax
  8035e7:	40                   	inc    %eax
  8035e8:	a3 54 51 80 00       	mov    %eax,0x805154





}
  8035ed:	e9 56 04 00 00       	jmp    803a48 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  8035f2:	a1 38 51 80 00       	mov    0x805138,%eax
  8035f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035fa:	e9 19 04 00 00       	jmp    803a18 <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  8035ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803602:	8b 00                	mov    (%eax),%eax
  803604:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  803607:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80360a:	8b 50 08             	mov    0x8(%eax),%edx
  80360d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803610:	8b 40 0c             	mov    0xc(%eax),%eax
  803613:	01 c2                	add    %eax,%edx
  803615:	8b 45 08             	mov    0x8(%ebp),%eax
  803618:	8b 40 08             	mov    0x8(%eax),%eax
  80361b:	39 c2                	cmp    %eax,%edx
  80361d:	0f 85 ad 01 00 00    	jne    8037d0 <insert_sorted_with_merge_freeList+0x4ce>
  803623:	8b 45 08             	mov    0x8(%ebp),%eax
  803626:	8b 50 08             	mov    0x8(%eax),%edx
  803629:	8b 45 08             	mov    0x8(%ebp),%eax
  80362c:	8b 40 0c             	mov    0xc(%eax),%eax
  80362f:	01 c2                	add    %eax,%edx
  803631:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803634:	8b 40 08             	mov    0x8(%eax),%eax
  803637:	39 c2                	cmp    %eax,%edx
  803639:	0f 85 91 01 00 00    	jne    8037d0 <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  80363f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803642:	8b 50 0c             	mov    0xc(%eax),%edx
  803645:	8b 45 08             	mov    0x8(%ebp),%eax
  803648:	8b 48 0c             	mov    0xc(%eax),%ecx
  80364b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80364e:	8b 40 0c             	mov    0xc(%eax),%eax
  803651:	01 c8                	add    %ecx,%eax
  803653:	01 c2                	add    %eax,%edx
  803655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803658:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  80365b:	8b 45 08             	mov    0x8(%ebp),%eax
  80365e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  803665:	8b 45 08             	mov    0x8(%ebp),%eax
  803668:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  80366f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803672:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  803679:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80367c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  803683:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803687:	75 17                	jne    8036a0 <insert_sorted_with_merge_freeList+0x39e>
  803689:	83 ec 04             	sub    $0x4,%esp
  80368c:	68 48 47 80 00       	push   $0x804748
  803691:	68 5b 01 00 00       	push   $0x15b
  803696:	68 d7 46 80 00       	push   $0x8046d7
  80369b:	e8 88 d6 ff ff       	call   800d28 <_panic>
  8036a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036a3:	8b 00                	mov    (%eax),%eax
  8036a5:	85 c0                	test   %eax,%eax
  8036a7:	74 10                	je     8036b9 <insert_sorted_with_merge_freeList+0x3b7>
  8036a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036ac:	8b 00                	mov    (%eax),%eax
  8036ae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036b1:	8b 52 04             	mov    0x4(%edx),%edx
  8036b4:	89 50 04             	mov    %edx,0x4(%eax)
  8036b7:	eb 0b                	jmp    8036c4 <insert_sorted_with_merge_freeList+0x3c2>
  8036b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036bc:	8b 40 04             	mov    0x4(%eax),%eax
  8036bf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036c7:	8b 40 04             	mov    0x4(%eax),%eax
  8036ca:	85 c0                	test   %eax,%eax
  8036cc:	74 0f                	je     8036dd <insert_sorted_with_merge_freeList+0x3db>
  8036ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036d1:	8b 40 04             	mov    0x4(%eax),%eax
  8036d4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036d7:	8b 12                	mov    (%edx),%edx
  8036d9:	89 10                	mov    %edx,(%eax)
  8036db:	eb 0a                	jmp    8036e7 <insert_sorted_with_merge_freeList+0x3e5>
  8036dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036e0:	8b 00                	mov    (%eax),%eax
  8036e2:	a3 38 51 80 00       	mov    %eax,0x805138
  8036e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036fa:	a1 44 51 80 00       	mov    0x805144,%eax
  8036ff:	48                   	dec    %eax
  803700:	a3 44 51 80 00       	mov    %eax,0x805144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803705:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803709:	75 17                	jne    803722 <insert_sorted_with_merge_freeList+0x420>
  80370b:	83 ec 04             	sub    $0x4,%esp
  80370e:	68 b4 46 80 00       	push   $0x8046b4
  803713:	68 5c 01 00 00       	push   $0x15c
  803718:	68 d7 46 80 00       	push   $0x8046d7
  80371d:	e8 06 d6 ff ff       	call   800d28 <_panic>
  803722:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803728:	8b 45 08             	mov    0x8(%ebp),%eax
  80372b:	89 10                	mov    %edx,(%eax)
  80372d:	8b 45 08             	mov    0x8(%ebp),%eax
  803730:	8b 00                	mov    (%eax),%eax
  803732:	85 c0                	test   %eax,%eax
  803734:	74 0d                	je     803743 <insert_sorted_with_merge_freeList+0x441>
  803736:	a1 48 51 80 00       	mov    0x805148,%eax
  80373b:	8b 55 08             	mov    0x8(%ebp),%edx
  80373e:	89 50 04             	mov    %edx,0x4(%eax)
  803741:	eb 08                	jmp    80374b <insert_sorted_with_merge_freeList+0x449>
  803743:	8b 45 08             	mov    0x8(%ebp),%eax
  803746:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80374b:	8b 45 08             	mov    0x8(%ebp),%eax
  80374e:	a3 48 51 80 00       	mov    %eax,0x805148
  803753:	8b 45 08             	mov    0x8(%ebp),%eax
  803756:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80375d:	a1 54 51 80 00       	mov    0x805154,%eax
  803762:	40                   	inc    %eax
  803763:	a3 54 51 80 00       	mov    %eax,0x805154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  803768:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80376c:	75 17                	jne    803785 <insert_sorted_with_merge_freeList+0x483>
  80376e:	83 ec 04             	sub    $0x4,%esp
  803771:	68 b4 46 80 00       	push   $0x8046b4
  803776:	68 5d 01 00 00       	push   $0x15d
  80377b:	68 d7 46 80 00       	push   $0x8046d7
  803780:	e8 a3 d5 ff ff       	call   800d28 <_panic>
  803785:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80378b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80378e:	89 10                	mov    %edx,(%eax)
  803790:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803793:	8b 00                	mov    (%eax),%eax
  803795:	85 c0                	test   %eax,%eax
  803797:	74 0d                	je     8037a6 <insert_sorted_with_merge_freeList+0x4a4>
  803799:	a1 48 51 80 00       	mov    0x805148,%eax
  80379e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037a1:	89 50 04             	mov    %edx,0x4(%eax)
  8037a4:	eb 08                	jmp    8037ae <insert_sorted_with_merge_freeList+0x4ac>
  8037a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037a9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8037ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037b1:	a3 48 51 80 00       	mov    %eax,0x805148
  8037b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037c0:	a1 54 51 80 00       	mov    0x805154,%eax
  8037c5:	40                   	inc    %eax
  8037c6:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  8037cb:	e9 78 02 00 00       	jmp    803a48 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  8037d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d3:	8b 50 08             	mov    0x8(%eax),%edx
  8037d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8037dc:	01 c2                	add    %eax,%edx
  8037de:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e1:	8b 40 08             	mov    0x8(%eax),%eax
  8037e4:	39 c2                	cmp    %eax,%edx
  8037e6:	0f 83 b8 00 00 00    	jae    8038a4 <insert_sorted_with_merge_freeList+0x5a2>
  8037ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ef:	8b 50 08             	mov    0x8(%eax),%edx
  8037f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8037f8:	01 c2                	add    %eax,%edx
  8037fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037fd:	8b 40 08             	mov    0x8(%eax),%eax
  803800:	39 c2                	cmp    %eax,%edx
  803802:	0f 85 9c 00 00 00    	jne    8038a4 <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  803808:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80380b:	8b 50 0c             	mov    0xc(%eax),%edx
  80380e:	8b 45 08             	mov    0x8(%ebp),%eax
  803811:	8b 40 0c             	mov    0xc(%eax),%eax
  803814:	01 c2                	add    %eax,%edx
  803816:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803819:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  80381c:	8b 45 08             	mov    0x8(%ebp),%eax
  80381f:	8b 50 08             	mov    0x8(%eax),%edx
  803822:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803825:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  803828:	8b 45 08             	mov    0x8(%ebp),%eax
  80382b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  803832:	8b 45 08             	mov    0x8(%ebp),%eax
  803835:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80383c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803840:	75 17                	jne    803859 <insert_sorted_with_merge_freeList+0x557>
  803842:	83 ec 04             	sub    $0x4,%esp
  803845:	68 b4 46 80 00       	push   $0x8046b4
  80384a:	68 67 01 00 00       	push   $0x167
  80384f:	68 d7 46 80 00       	push   $0x8046d7
  803854:	e8 cf d4 ff ff       	call   800d28 <_panic>
  803859:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80385f:	8b 45 08             	mov    0x8(%ebp),%eax
  803862:	89 10                	mov    %edx,(%eax)
  803864:	8b 45 08             	mov    0x8(%ebp),%eax
  803867:	8b 00                	mov    (%eax),%eax
  803869:	85 c0                	test   %eax,%eax
  80386b:	74 0d                	je     80387a <insert_sorted_with_merge_freeList+0x578>
  80386d:	a1 48 51 80 00       	mov    0x805148,%eax
  803872:	8b 55 08             	mov    0x8(%ebp),%edx
  803875:	89 50 04             	mov    %edx,0x4(%eax)
  803878:	eb 08                	jmp    803882 <insert_sorted_with_merge_freeList+0x580>
  80387a:	8b 45 08             	mov    0x8(%ebp),%eax
  80387d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803882:	8b 45 08             	mov    0x8(%ebp),%eax
  803885:	a3 48 51 80 00       	mov    %eax,0x805148
  80388a:	8b 45 08             	mov    0x8(%ebp),%eax
  80388d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803894:	a1 54 51 80 00       	mov    0x805154,%eax
  803899:	40                   	inc    %eax
  80389a:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  80389f:	e9 a4 01 00 00       	jmp    803a48 <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  8038a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038a7:	8b 50 08             	mov    0x8(%eax),%edx
  8038aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8038b0:	01 c2                	add    %eax,%edx
  8038b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b5:	8b 40 08             	mov    0x8(%eax),%eax
  8038b8:	39 c2                	cmp    %eax,%edx
  8038ba:	0f 85 ac 00 00 00    	jne    80396c <insert_sorted_with_merge_freeList+0x66a>
  8038c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c3:	8b 50 08             	mov    0x8(%eax),%edx
  8038c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8038cc:	01 c2                	add    %eax,%edx
  8038ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038d1:	8b 40 08             	mov    0x8(%eax),%eax
  8038d4:	39 c2                	cmp    %eax,%edx
  8038d6:	0f 83 90 00 00 00    	jae    80396c <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  8038dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038df:	8b 50 0c             	mov    0xc(%eax),%edx
  8038e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8038e8:	01 c2                	add    %eax,%edx
  8038ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038ed:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  8038f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  8038fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8038fd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803904:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803908:	75 17                	jne    803921 <insert_sorted_with_merge_freeList+0x61f>
  80390a:	83 ec 04             	sub    $0x4,%esp
  80390d:	68 b4 46 80 00       	push   $0x8046b4
  803912:	68 70 01 00 00       	push   $0x170
  803917:	68 d7 46 80 00       	push   $0x8046d7
  80391c:	e8 07 d4 ff ff       	call   800d28 <_panic>
  803921:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803927:	8b 45 08             	mov    0x8(%ebp),%eax
  80392a:	89 10                	mov    %edx,(%eax)
  80392c:	8b 45 08             	mov    0x8(%ebp),%eax
  80392f:	8b 00                	mov    (%eax),%eax
  803931:	85 c0                	test   %eax,%eax
  803933:	74 0d                	je     803942 <insert_sorted_with_merge_freeList+0x640>
  803935:	a1 48 51 80 00       	mov    0x805148,%eax
  80393a:	8b 55 08             	mov    0x8(%ebp),%edx
  80393d:	89 50 04             	mov    %edx,0x4(%eax)
  803940:	eb 08                	jmp    80394a <insert_sorted_with_merge_freeList+0x648>
  803942:	8b 45 08             	mov    0x8(%ebp),%eax
  803945:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80394a:	8b 45 08             	mov    0x8(%ebp),%eax
  80394d:	a3 48 51 80 00       	mov    %eax,0x805148
  803952:	8b 45 08             	mov    0x8(%ebp),%eax
  803955:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80395c:	a1 54 51 80 00       	mov    0x805154,%eax
  803961:	40                   	inc    %eax
  803962:	a3 54 51 80 00       	mov    %eax,0x805154
	      break;
  803967:	e9 dc 00 00 00       	jmp    803a48 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  80396c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80396f:	8b 50 08             	mov    0x8(%eax),%edx
  803972:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803975:	8b 40 0c             	mov    0xc(%eax),%eax
  803978:	01 c2                	add    %eax,%edx
  80397a:	8b 45 08             	mov    0x8(%ebp),%eax
  80397d:	8b 40 08             	mov    0x8(%eax),%eax
  803980:	39 c2                	cmp    %eax,%edx
  803982:	0f 83 88 00 00 00    	jae    803a10 <insert_sorted_with_merge_freeList+0x70e>
  803988:	8b 45 08             	mov    0x8(%ebp),%eax
  80398b:	8b 50 08             	mov    0x8(%eax),%edx
  80398e:	8b 45 08             	mov    0x8(%ebp),%eax
  803991:	8b 40 0c             	mov    0xc(%eax),%eax
  803994:	01 c2                	add    %eax,%edx
  803996:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803999:	8b 40 08             	mov    0x8(%eax),%eax
  80399c:	39 c2                	cmp    %eax,%edx
  80399e:	73 70                	jae    803a10 <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  8039a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039a4:	74 06                	je     8039ac <insert_sorted_with_merge_freeList+0x6aa>
  8039a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039aa:	75 17                	jne    8039c3 <insert_sorted_with_merge_freeList+0x6c1>
  8039ac:	83 ec 04             	sub    $0x4,%esp
  8039af:	68 14 47 80 00       	push   $0x804714
  8039b4:	68 75 01 00 00       	push   $0x175
  8039b9:	68 d7 46 80 00       	push   $0x8046d7
  8039be:	e8 65 d3 ff ff       	call   800d28 <_panic>
  8039c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039c6:	8b 10                	mov    (%eax),%edx
  8039c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8039cb:	89 10                	mov    %edx,(%eax)
  8039cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d0:	8b 00                	mov    (%eax),%eax
  8039d2:	85 c0                	test   %eax,%eax
  8039d4:	74 0b                	je     8039e1 <insert_sorted_with_merge_freeList+0x6df>
  8039d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d9:	8b 00                	mov    (%eax),%eax
  8039db:	8b 55 08             	mov    0x8(%ebp),%edx
  8039de:	89 50 04             	mov    %edx,0x4(%eax)
  8039e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8039e7:	89 10                	mov    %edx,(%eax)
  8039e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039ef:	89 50 04             	mov    %edx,0x4(%eax)
  8039f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f5:	8b 00                	mov    (%eax),%eax
  8039f7:	85 c0                	test   %eax,%eax
  8039f9:	75 08                	jne    803a03 <insert_sorted_with_merge_freeList+0x701>
  8039fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8039fe:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803a03:	a1 44 51 80 00       	mov    0x805144,%eax
  803a08:	40                   	inc    %eax
  803a09:	a3 44 51 80 00       	mov    %eax,0x805144
	      break;
  803a0e:	eb 38                	jmp    803a48 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  803a10:	a1 40 51 80 00       	mov    0x805140,%eax
  803a15:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a1c:	74 07                	je     803a25 <insert_sorted_with_merge_freeList+0x723>
  803a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a21:	8b 00                	mov    (%eax),%eax
  803a23:	eb 05                	jmp    803a2a <insert_sorted_with_merge_freeList+0x728>
  803a25:	b8 00 00 00 00       	mov    $0x0,%eax
  803a2a:	a3 40 51 80 00       	mov    %eax,0x805140
  803a2f:	a1 40 51 80 00       	mov    0x805140,%eax
  803a34:	85 c0                	test   %eax,%eax
  803a36:	0f 85 c3 fb ff ff    	jne    8035ff <insert_sorted_with_merge_freeList+0x2fd>
  803a3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a40:	0f 85 b9 fb ff ff    	jne    8035ff <insert_sorted_with_merge_freeList+0x2fd>





}
  803a46:	eb 00                	jmp    803a48 <insert_sorted_with_merge_freeList+0x746>
  803a48:	90                   	nop
  803a49:	c9                   	leave  
  803a4a:	c3                   	ret    
  803a4b:	90                   	nop

00803a4c <__udivdi3>:
  803a4c:	55                   	push   %ebp
  803a4d:	57                   	push   %edi
  803a4e:	56                   	push   %esi
  803a4f:	53                   	push   %ebx
  803a50:	83 ec 1c             	sub    $0x1c,%esp
  803a53:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803a57:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803a5b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a5f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a63:	89 ca                	mov    %ecx,%edx
  803a65:	89 f8                	mov    %edi,%eax
  803a67:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803a6b:	85 f6                	test   %esi,%esi
  803a6d:	75 2d                	jne    803a9c <__udivdi3+0x50>
  803a6f:	39 cf                	cmp    %ecx,%edi
  803a71:	77 65                	ja     803ad8 <__udivdi3+0x8c>
  803a73:	89 fd                	mov    %edi,%ebp
  803a75:	85 ff                	test   %edi,%edi
  803a77:	75 0b                	jne    803a84 <__udivdi3+0x38>
  803a79:	b8 01 00 00 00       	mov    $0x1,%eax
  803a7e:	31 d2                	xor    %edx,%edx
  803a80:	f7 f7                	div    %edi
  803a82:	89 c5                	mov    %eax,%ebp
  803a84:	31 d2                	xor    %edx,%edx
  803a86:	89 c8                	mov    %ecx,%eax
  803a88:	f7 f5                	div    %ebp
  803a8a:	89 c1                	mov    %eax,%ecx
  803a8c:	89 d8                	mov    %ebx,%eax
  803a8e:	f7 f5                	div    %ebp
  803a90:	89 cf                	mov    %ecx,%edi
  803a92:	89 fa                	mov    %edi,%edx
  803a94:	83 c4 1c             	add    $0x1c,%esp
  803a97:	5b                   	pop    %ebx
  803a98:	5e                   	pop    %esi
  803a99:	5f                   	pop    %edi
  803a9a:	5d                   	pop    %ebp
  803a9b:	c3                   	ret    
  803a9c:	39 ce                	cmp    %ecx,%esi
  803a9e:	77 28                	ja     803ac8 <__udivdi3+0x7c>
  803aa0:	0f bd fe             	bsr    %esi,%edi
  803aa3:	83 f7 1f             	xor    $0x1f,%edi
  803aa6:	75 40                	jne    803ae8 <__udivdi3+0x9c>
  803aa8:	39 ce                	cmp    %ecx,%esi
  803aaa:	72 0a                	jb     803ab6 <__udivdi3+0x6a>
  803aac:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803ab0:	0f 87 9e 00 00 00    	ja     803b54 <__udivdi3+0x108>
  803ab6:	b8 01 00 00 00       	mov    $0x1,%eax
  803abb:	89 fa                	mov    %edi,%edx
  803abd:	83 c4 1c             	add    $0x1c,%esp
  803ac0:	5b                   	pop    %ebx
  803ac1:	5e                   	pop    %esi
  803ac2:	5f                   	pop    %edi
  803ac3:	5d                   	pop    %ebp
  803ac4:	c3                   	ret    
  803ac5:	8d 76 00             	lea    0x0(%esi),%esi
  803ac8:	31 ff                	xor    %edi,%edi
  803aca:	31 c0                	xor    %eax,%eax
  803acc:	89 fa                	mov    %edi,%edx
  803ace:	83 c4 1c             	add    $0x1c,%esp
  803ad1:	5b                   	pop    %ebx
  803ad2:	5e                   	pop    %esi
  803ad3:	5f                   	pop    %edi
  803ad4:	5d                   	pop    %ebp
  803ad5:	c3                   	ret    
  803ad6:	66 90                	xchg   %ax,%ax
  803ad8:	89 d8                	mov    %ebx,%eax
  803ada:	f7 f7                	div    %edi
  803adc:	31 ff                	xor    %edi,%edi
  803ade:	89 fa                	mov    %edi,%edx
  803ae0:	83 c4 1c             	add    $0x1c,%esp
  803ae3:	5b                   	pop    %ebx
  803ae4:	5e                   	pop    %esi
  803ae5:	5f                   	pop    %edi
  803ae6:	5d                   	pop    %ebp
  803ae7:	c3                   	ret    
  803ae8:	bd 20 00 00 00       	mov    $0x20,%ebp
  803aed:	89 eb                	mov    %ebp,%ebx
  803aef:	29 fb                	sub    %edi,%ebx
  803af1:	89 f9                	mov    %edi,%ecx
  803af3:	d3 e6                	shl    %cl,%esi
  803af5:	89 c5                	mov    %eax,%ebp
  803af7:	88 d9                	mov    %bl,%cl
  803af9:	d3 ed                	shr    %cl,%ebp
  803afb:	89 e9                	mov    %ebp,%ecx
  803afd:	09 f1                	or     %esi,%ecx
  803aff:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803b03:	89 f9                	mov    %edi,%ecx
  803b05:	d3 e0                	shl    %cl,%eax
  803b07:	89 c5                	mov    %eax,%ebp
  803b09:	89 d6                	mov    %edx,%esi
  803b0b:	88 d9                	mov    %bl,%cl
  803b0d:	d3 ee                	shr    %cl,%esi
  803b0f:	89 f9                	mov    %edi,%ecx
  803b11:	d3 e2                	shl    %cl,%edx
  803b13:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b17:	88 d9                	mov    %bl,%cl
  803b19:	d3 e8                	shr    %cl,%eax
  803b1b:	09 c2                	or     %eax,%edx
  803b1d:	89 d0                	mov    %edx,%eax
  803b1f:	89 f2                	mov    %esi,%edx
  803b21:	f7 74 24 0c          	divl   0xc(%esp)
  803b25:	89 d6                	mov    %edx,%esi
  803b27:	89 c3                	mov    %eax,%ebx
  803b29:	f7 e5                	mul    %ebp
  803b2b:	39 d6                	cmp    %edx,%esi
  803b2d:	72 19                	jb     803b48 <__udivdi3+0xfc>
  803b2f:	74 0b                	je     803b3c <__udivdi3+0xf0>
  803b31:	89 d8                	mov    %ebx,%eax
  803b33:	31 ff                	xor    %edi,%edi
  803b35:	e9 58 ff ff ff       	jmp    803a92 <__udivdi3+0x46>
  803b3a:	66 90                	xchg   %ax,%ax
  803b3c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803b40:	89 f9                	mov    %edi,%ecx
  803b42:	d3 e2                	shl    %cl,%edx
  803b44:	39 c2                	cmp    %eax,%edx
  803b46:	73 e9                	jae    803b31 <__udivdi3+0xe5>
  803b48:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803b4b:	31 ff                	xor    %edi,%edi
  803b4d:	e9 40 ff ff ff       	jmp    803a92 <__udivdi3+0x46>
  803b52:	66 90                	xchg   %ax,%ax
  803b54:	31 c0                	xor    %eax,%eax
  803b56:	e9 37 ff ff ff       	jmp    803a92 <__udivdi3+0x46>
  803b5b:	90                   	nop

00803b5c <__umoddi3>:
  803b5c:	55                   	push   %ebp
  803b5d:	57                   	push   %edi
  803b5e:	56                   	push   %esi
  803b5f:	53                   	push   %ebx
  803b60:	83 ec 1c             	sub    $0x1c,%esp
  803b63:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803b67:	8b 74 24 34          	mov    0x34(%esp),%esi
  803b6b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b6f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803b73:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b77:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b7b:	89 f3                	mov    %esi,%ebx
  803b7d:	89 fa                	mov    %edi,%edx
  803b7f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b83:	89 34 24             	mov    %esi,(%esp)
  803b86:	85 c0                	test   %eax,%eax
  803b88:	75 1a                	jne    803ba4 <__umoddi3+0x48>
  803b8a:	39 f7                	cmp    %esi,%edi
  803b8c:	0f 86 a2 00 00 00    	jbe    803c34 <__umoddi3+0xd8>
  803b92:	89 c8                	mov    %ecx,%eax
  803b94:	89 f2                	mov    %esi,%edx
  803b96:	f7 f7                	div    %edi
  803b98:	89 d0                	mov    %edx,%eax
  803b9a:	31 d2                	xor    %edx,%edx
  803b9c:	83 c4 1c             	add    $0x1c,%esp
  803b9f:	5b                   	pop    %ebx
  803ba0:	5e                   	pop    %esi
  803ba1:	5f                   	pop    %edi
  803ba2:	5d                   	pop    %ebp
  803ba3:	c3                   	ret    
  803ba4:	39 f0                	cmp    %esi,%eax
  803ba6:	0f 87 ac 00 00 00    	ja     803c58 <__umoddi3+0xfc>
  803bac:	0f bd e8             	bsr    %eax,%ebp
  803baf:	83 f5 1f             	xor    $0x1f,%ebp
  803bb2:	0f 84 ac 00 00 00    	je     803c64 <__umoddi3+0x108>
  803bb8:	bf 20 00 00 00       	mov    $0x20,%edi
  803bbd:	29 ef                	sub    %ebp,%edi
  803bbf:	89 fe                	mov    %edi,%esi
  803bc1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803bc5:	89 e9                	mov    %ebp,%ecx
  803bc7:	d3 e0                	shl    %cl,%eax
  803bc9:	89 d7                	mov    %edx,%edi
  803bcb:	89 f1                	mov    %esi,%ecx
  803bcd:	d3 ef                	shr    %cl,%edi
  803bcf:	09 c7                	or     %eax,%edi
  803bd1:	89 e9                	mov    %ebp,%ecx
  803bd3:	d3 e2                	shl    %cl,%edx
  803bd5:	89 14 24             	mov    %edx,(%esp)
  803bd8:	89 d8                	mov    %ebx,%eax
  803bda:	d3 e0                	shl    %cl,%eax
  803bdc:	89 c2                	mov    %eax,%edx
  803bde:	8b 44 24 08          	mov    0x8(%esp),%eax
  803be2:	d3 e0                	shl    %cl,%eax
  803be4:	89 44 24 04          	mov    %eax,0x4(%esp)
  803be8:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bec:	89 f1                	mov    %esi,%ecx
  803bee:	d3 e8                	shr    %cl,%eax
  803bf0:	09 d0                	or     %edx,%eax
  803bf2:	d3 eb                	shr    %cl,%ebx
  803bf4:	89 da                	mov    %ebx,%edx
  803bf6:	f7 f7                	div    %edi
  803bf8:	89 d3                	mov    %edx,%ebx
  803bfa:	f7 24 24             	mull   (%esp)
  803bfd:	89 c6                	mov    %eax,%esi
  803bff:	89 d1                	mov    %edx,%ecx
  803c01:	39 d3                	cmp    %edx,%ebx
  803c03:	0f 82 87 00 00 00    	jb     803c90 <__umoddi3+0x134>
  803c09:	0f 84 91 00 00 00    	je     803ca0 <__umoddi3+0x144>
  803c0f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803c13:	29 f2                	sub    %esi,%edx
  803c15:	19 cb                	sbb    %ecx,%ebx
  803c17:	89 d8                	mov    %ebx,%eax
  803c19:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803c1d:	d3 e0                	shl    %cl,%eax
  803c1f:	89 e9                	mov    %ebp,%ecx
  803c21:	d3 ea                	shr    %cl,%edx
  803c23:	09 d0                	or     %edx,%eax
  803c25:	89 e9                	mov    %ebp,%ecx
  803c27:	d3 eb                	shr    %cl,%ebx
  803c29:	89 da                	mov    %ebx,%edx
  803c2b:	83 c4 1c             	add    $0x1c,%esp
  803c2e:	5b                   	pop    %ebx
  803c2f:	5e                   	pop    %esi
  803c30:	5f                   	pop    %edi
  803c31:	5d                   	pop    %ebp
  803c32:	c3                   	ret    
  803c33:	90                   	nop
  803c34:	89 fd                	mov    %edi,%ebp
  803c36:	85 ff                	test   %edi,%edi
  803c38:	75 0b                	jne    803c45 <__umoddi3+0xe9>
  803c3a:	b8 01 00 00 00       	mov    $0x1,%eax
  803c3f:	31 d2                	xor    %edx,%edx
  803c41:	f7 f7                	div    %edi
  803c43:	89 c5                	mov    %eax,%ebp
  803c45:	89 f0                	mov    %esi,%eax
  803c47:	31 d2                	xor    %edx,%edx
  803c49:	f7 f5                	div    %ebp
  803c4b:	89 c8                	mov    %ecx,%eax
  803c4d:	f7 f5                	div    %ebp
  803c4f:	89 d0                	mov    %edx,%eax
  803c51:	e9 44 ff ff ff       	jmp    803b9a <__umoddi3+0x3e>
  803c56:	66 90                	xchg   %ax,%ax
  803c58:	89 c8                	mov    %ecx,%eax
  803c5a:	89 f2                	mov    %esi,%edx
  803c5c:	83 c4 1c             	add    $0x1c,%esp
  803c5f:	5b                   	pop    %ebx
  803c60:	5e                   	pop    %esi
  803c61:	5f                   	pop    %edi
  803c62:	5d                   	pop    %ebp
  803c63:	c3                   	ret    
  803c64:	3b 04 24             	cmp    (%esp),%eax
  803c67:	72 06                	jb     803c6f <__umoddi3+0x113>
  803c69:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803c6d:	77 0f                	ja     803c7e <__umoddi3+0x122>
  803c6f:	89 f2                	mov    %esi,%edx
  803c71:	29 f9                	sub    %edi,%ecx
  803c73:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803c77:	89 14 24             	mov    %edx,(%esp)
  803c7a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c7e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803c82:	8b 14 24             	mov    (%esp),%edx
  803c85:	83 c4 1c             	add    $0x1c,%esp
  803c88:	5b                   	pop    %ebx
  803c89:	5e                   	pop    %esi
  803c8a:	5f                   	pop    %edi
  803c8b:	5d                   	pop    %ebp
  803c8c:	c3                   	ret    
  803c8d:	8d 76 00             	lea    0x0(%esi),%esi
  803c90:	2b 04 24             	sub    (%esp),%eax
  803c93:	19 fa                	sbb    %edi,%edx
  803c95:	89 d1                	mov    %edx,%ecx
  803c97:	89 c6                	mov    %eax,%esi
  803c99:	e9 71 ff ff ff       	jmp    803c0f <__umoddi3+0xb3>
  803c9e:	66 90                	xchg   %ax,%ax
  803ca0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803ca4:	72 ea                	jb     803c90 <__umoddi3+0x134>
  803ca6:	89 d9                	mov    %ebx,%ecx
  803ca8:	e9 62 ff ff ff       	jmp    803c0f <__umoddi3+0xb3>
