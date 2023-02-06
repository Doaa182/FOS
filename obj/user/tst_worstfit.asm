
obj/user/tst_worstfit:     file format elf32-i386


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
  800031:	e8 81 0c 00 00       	call   800cb7 <libmain>
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
	sys_set_uheap_strategy(UHP_PLACE_WORSTFIT);
  800043:	83 ec 0c             	sub    $0xc,%esp
  800046:	6a 04                	push   $0x4
  800048:	e8 27 29 00 00       	call   802974 <sys_set_uheap_strategy>
  80004d:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800050:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800054:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80005b:	eb 29                	jmp    800086 <_main+0x4e>
		{
			if (myEnv->__uptr_pws[i].empty)
  80005d:	a1 20 50 80 00       	mov    0x805020,%eax
  800062:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800068:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80006b:	89 d0                	mov    %edx,%eax
  80006d:	01 c0                	add    %eax,%eax
  80006f:	01 d0                	add    %edx,%eax
  800071:	c1 e0 03             	shl    $0x3,%eax
  800074:	01 c8                	add    %ecx,%eax
  800076:	8a 40 04             	mov    0x4(%eax),%al
  800079:	84 c0                	test   %al,%al
  80007b:	74 06                	je     800083 <_main+0x4b>
			{
				fullWS = 0;
  80007d:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800081:	eb 12                	jmp    800095 <_main+0x5d>
	sys_set_uheap_strategy(UHP_PLACE_WORSTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800083:	ff 45 f0             	incl   -0x10(%ebp)
  800086:	a1 20 50 80 00       	mov    0x805020,%eax
  80008b:	8b 50 74             	mov    0x74(%eax),%edx
  80008e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800091:	39 c2                	cmp    %eax,%edx
  800093:	77 c8                	ja     80005d <_main+0x25>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800095:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800099:	74 14                	je     8000af <_main+0x77>
  80009b:	83 ec 04             	sub    $0x4,%esp
  80009e:	68 80 3d 80 00       	push   $0x803d80
  8000a3:	6a 16                	push   $0x16
  8000a5:	68 9c 3d 80 00       	push   $0x803d9c
  8000aa:	e8 44 0d 00 00       	call   800df3 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000af:	83 ec 0c             	sub    $0xc,%esp
  8000b2:	6a 00                	push   $0x0
  8000b4:	e8 67 1f 00 00       	call   802020 <malloc>
  8000b9:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int Mega = 1024*1024;
  8000bc:	c7 45 d8 00 00 10 00 	movl   $0x100000,-0x28(%ebp)
	int kilo = 1024;
  8000c3:	c7 45 d4 00 04 00 00 	movl   $0x400,-0x2c(%ebp)

	int count = 0;
  8000ca:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
	int totalNumberOfTests = 11;
  8000d1:	c7 45 cc 0b 00 00 00 	movl   $0xb,-0x34(%ebp)

	//Make sure that the heap size is 512 MB
	int numOf2MBsInHeap = (USER_HEAP_MAX - USER_HEAP_START) / (2*Mega);
  8000d8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000db:	01 c0                	add    %eax,%eax
  8000dd:	89 c7                	mov    %eax,%edi
  8000df:	b8 00 00 00 20       	mov    $0x20000000,%eax
  8000e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8000e9:	f7 f7                	div    %edi
  8000eb:	89 45 c8             	mov    %eax,-0x38(%ebp)
	assert(numOf2MBsInHeap == 256);
  8000ee:	81 7d c8 00 01 00 00 	cmpl   $0x100,-0x38(%ebp)
  8000f5:	74 16                	je     80010d <_main+0xd5>
  8000f7:	68 b0 3d 80 00       	push   $0x803db0
  8000fc:	68 c7 3d 80 00       	push   $0x803dc7
  800101:	6a 24                	push   $0x24
  800103:	68 9c 3d 80 00       	push   $0x803d9c
  800108:	e8 e6 0c 00 00       	call   800df3 <_panic>




	sys_set_uheap_strategy(UHP_PLACE_WORSTFIT);
  80010d:	83 ec 0c             	sub    $0xc,%esp
  800110:	6a 04                	push   $0x4
  800112:	e8 5d 28 00 00       	call   802974 <sys_set_uheap_strategy>
  800117:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80011a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80011e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800125:	eb 29                	jmp    800150 <_main+0x118>
		{
			if (myEnv->__uptr_pws[i].empty)
  800127:	a1 20 50 80 00       	mov    0x805020,%eax
  80012c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800132:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800135:	89 d0                	mov    %edx,%eax
  800137:	01 c0                	add    %eax,%eax
  800139:	01 d0                	add    %edx,%eax
  80013b:	c1 e0 03             	shl    $0x3,%eax
  80013e:	01 c8                	add    %ecx,%eax
  800140:	8a 40 04             	mov    0x4(%eax),%al
  800143:	84 c0                	test   %al,%al
  800145:	74 06                	je     80014d <_main+0x115>
			{
				fullWS = 0;
  800147:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
				break;
  80014b:	eb 12                	jmp    80015f <_main+0x127>
	sys_set_uheap_strategy(UHP_PLACE_WORSTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80014d:	ff 45 e8             	incl   -0x18(%ebp)
  800150:	a1 20 50 80 00       	mov    0x805020,%eax
  800155:	8b 50 74             	mov    0x74(%eax),%edx
  800158:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80015b:	39 c2                	cmp    %eax,%edx
  80015d:	77 c8                	ja     800127 <_main+0xef>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  80015f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  800163:	74 14                	je     800179 <_main+0x141>
  800165:	83 ec 04             	sub    $0x4,%esp
  800168:	68 80 3d 80 00       	push   $0x803d80
  80016d:	6a 36                	push   $0x36
  80016f:	68 9c 3d 80 00       	push   $0x803d9c
  800174:	e8 7a 0c 00 00       	call   800df3 <_panic>
	}

	int freeFrames ;
	int usedDiskPages;

	cprintf("This test has %d tests. A pass message will be displayed after each one.\n", totalNumberOfTests);
  800179:	83 ec 08             	sub    $0x8,%esp
  80017c:	ff 75 cc             	pushl  -0x34(%ebp)
  80017f:	68 dc 3d 80 00       	push   $0x803ddc
  800184:	e8 1e 0f 00 00       	call   8010a7 <cprintf>
  800189:	83 c4 10             	add    $0x10,%esp

	//[0] Make sure there're available places in the WS
	int w = 0 ;
  80018c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	int requiredNumOfEmptyWSLocs = 2;
  800193:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
	int numOfEmptyWSLocs = 0;
  80019a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	for (w = 0 ; w < myEnv->page_WS_max_size; w++)
  8001a1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001a8:	eb 26                	jmp    8001d0 <_main+0x198>
	{
		if( myEnv->__uptr_pws[w].empty == 1)
  8001aa:	a1 20 50 80 00       	mov    0x805020,%eax
  8001af:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8001b5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8001b8:	89 d0                	mov    %edx,%eax
  8001ba:	01 c0                	add    %eax,%eax
  8001bc:	01 d0                	add    %edx,%eax
  8001be:	c1 e0 03             	shl    $0x3,%eax
  8001c1:	01 c8                	add    %ecx,%eax
  8001c3:	8a 40 04             	mov    0x4(%eax),%al
  8001c6:	3c 01                	cmp    $0x1,%al
  8001c8:	75 03                	jne    8001cd <_main+0x195>
			numOfEmptyWSLocs++;
  8001ca:	ff 45 e0             	incl   -0x20(%ebp)

	//[0] Make sure there're available places in the WS
	int w = 0 ;
	int requiredNumOfEmptyWSLocs = 2;
	int numOfEmptyWSLocs = 0;
	for (w = 0 ; w < myEnv->page_WS_max_size; w++)
  8001cd:	ff 45 e4             	incl   -0x1c(%ebp)
  8001d0:	a1 20 50 80 00       	mov    0x805020,%eax
  8001d5:	8b 50 74             	mov    0x74(%eax),%edx
  8001d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001db:	39 c2                	cmp    %eax,%edx
  8001dd:	77 cb                	ja     8001aa <_main+0x172>
	{
		if( myEnv->__uptr_pws[w].empty == 1)
			numOfEmptyWSLocs++;
	}
	if (numOfEmptyWSLocs < requiredNumOfEmptyWSLocs)
  8001df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001e2:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8001e5:	7d 14                	jge    8001fb <_main+0x1c3>
		panic("Insufficient number of WS empty locations! please increase the PAGE_WS_MAX_SIZE");
  8001e7:	83 ec 04             	sub    $0x4,%esp
  8001ea:	68 28 3e 80 00       	push   $0x803e28
  8001ef:	6a 48                	push   $0x48
  8001f1:	68 9c 3d 80 00       	push   $0x803d9c
  8001f6:	e8 f8 0b 00 00       	call   800df3 <_panic>

	void* ptr_allocations[512] = {0};
  8001fb:	8d 95 b8 f7 ff ff    	lea    -0x848(%ebp),%edx
  800201:	b9 00 02 00 00       	mov    $0x200,%ecx
  800206:	b8 00 00 00 00       	mov    $0x0,%eax
  80020b:	89 d7                	mov    %edx,%edi
  80020d:	f3 ab                	rep stos %eax,%es:(%edi)
	int i;

	// allocate pages
	freeFrames = sys_calculate_free_frames() ;
  80020f:	e8 4b 22 00 00       	call   80245f <sys_calculate_free_frames>
  800214:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800217:	e8 e3 22 00 00       	call   8024ff <sys_pf_calculate_allocated_pages>
  80021c:	89 45 bc             	mov    %eax,-0x44(%ebp)
	for(i = 0; i< 256;i++)
  80021f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800226:	eb 20                	jmp    800248 <_main+0x210>
	{
		ptr_allocations[i] = malloc(2*Mega);
  800228:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80022b:	01 c0                	add    %eax,%eax
  80022d:	83 ec 0c             	sub    $0xc,%esp
  800230:	50                   	push   %eax
  800231:	e8 ea 1d 00 00       	call   802020 <malloc>
  800236:	83 c4 10             	add    $0x10,%esp
  800239:	89 c2                	mov    %eax,%edx
  80023b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80023e:	89 94 85 b8 f7 ff ff 	mov    %edx,-0x848(%ebp,%eax,4)
	int i;

	// allocate pages
	freeFrames = sys_calculate_free_frames() ;
	usedDiskPages = sys_pf_calculate_allocated_pages();
	for(i = 0; i< 256;i++)
  800245:	ff 45 dc             	incl   -0x24(%ebp)
  800248:	81 7d dc ff 00 00 00 	cmpl   $0xff,-0x24(%ebp)
  80024f:	7e d7                	jle    800228 <_main+0x1f0>
	{
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
  800251:	8b 85 b8 f7 ff ff    	mov    -0x848(%ebp),%eax
  800257:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  80025c:	75 4e                	jne    8002ac <_main+0x274>
			(uint32)ptr_allocations[2] != 0x80400000 ||
  80025e:	8b 85 c0 f7 ff ff    	mov    -0x840(%ebp),%eax
	{
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
  800264:	3d 00 00 40 80       	cmp    $0x80400000,%eax
  800269:	75 41                	jne    8002ac <_main+0x274>
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
  80026b:	8b 85 d8 f7 ff ff    	mov    -0x828(%ebp),%eax
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
  800271:	3d 00 00 00 81       	cmp    $0x81000000,%eax
  800276:	75 34                	jne    8002ac <_main+0x274>
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[100] != 0x8C800000 ||
  800278:	8b 85 48 f9 ff ff    	mov    -0x6b8(%ebp),%eax
	}

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
  80027e:	3d 00 00 80 8c       	cmp    $0x8c800000,%eax
  800283:	75 27                	jne    8002ac <_main+0x274>
			(uint32)ptr_allocations[100] != 0x8C800000 ||
			(uint32)ptr_allocations[150] != 0x92C00000 ||
  800285:	8b 85 10 fa ff ff    	mov    -0x5f0(%ebp),%eax

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[100] != 0x8C800000 ||
  80028b:	3d 00 00 c0 92       	cmp    $0x92c00000,%eax
  800290:	75 1a                	jne    8002ac <_main+0x274>
			(uint32)ptr_allocations[150] != 0x92C00000 ||
			(uint32)ptr_allocations[200] != 0x99000000 ||
  800292:	8b 85 d8 fa ff ff    	mov    -0x528(%ebp),%eax
	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[100] != 0x8C800000 ||
			(uint32)ptr_allocations[150] != 0x92C00000 ||
  800298:	3d 00 00 00 99       	cmp    $0x99000000,%eax
  80029d:	75 0d                	jne    8002ac <_main+0x274>
			(uint32)ptr_allocations[200] != 0x99000000 ||
			(uint32)ptr_allocations[255] != 0x9FE00000)
  80029f:	8b 85 b4 fb ff ff    	mov    -0x44c(%ebp),%eax
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[100] != 0x8C800000 ||
			(uint32)ptr_allocations[150] != 0x92C00000 ||
			(uint32)ptr_allocations[200] != 0x99000000 ||
  8002a5:	3d 00 00 e0 9f       	cmp    $0x9fe00000,%eax
  8002aa:	74 14                	je     8002c0 <_main+0x288>
			(uint32)ptr_allocations[255] != 0x9FE00000)
		panic("Wrong allocation, Check fitting strategy is working correctly");
  8002ac:	83 ec 04             	sub    $0x4,%esp
  8002af:	68 78 3e 80 00       	push   $0x803e78
  8002b4:	6a 5d                	push   $0x5d
  8002b6:	68 9c 3d 80 00       	push   $0x803d9c
  8002bb:	e8 33 0b 00 00       	call   800df3 <_panic>

	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8002c0:	e8 3a 22 00 00       	call   8024ff <sys_pf_calculate_allocated_pages>
  8002c5:	2b 45 bc             	sub    -0x44(%ebp),%eax
  8002c8:	89 c2                	mov    %eax,%edx
  8002ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002cd:	c1 e0 09             	shl    $0x9,%eax
  8002d0:	85 c0                	test   %eax,%eax
  8002d2:	79 05                	jns    8002d9 <_main+0x2a1>
  8002d4:	05 ff 0f 00 00       	add    $0xfff,%eax
  8002d9:	c1 f8 0c             	sar    $0xc,%eax
  8002dc:	39 c2                	cmp    %eax,%edx
  8002de:	74 14                	je     8002f4 <_main+0x2bc>
  8002e0:	83 ec 04             	sub    $0x4,%esp
  8002e3:	68 b6 3e 80 00       	push   $0x803eb6
  8002e8:	6a 5f                	push   $0x5f
  8002ea:	68 9c 3d 80 00       	push   $0x803d9c
  8002ef:	e8 ff 0a 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != (512*Mega)/(1024*PAGE_SIZE) ) panic("Wrong allocation");
  8002f4:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8002f7:	e8 63 21 00 00       	call   80245f <sys_calculate_free_frames>
  8002fc:	29 c3                	sub    %eax,%ebx
  8002fe:	89 da                	mov    %ebx,%edx
  800300:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800303:	c1 e0 09             	shl    $0x9,%eax
  800306:	85 c0                	test   %eax,%eax
  800308:	79 05                	jns    80030f <_main+0x2d7>
  80030a:	05 ff ff 3f 00       	add    $0x3fffff,%eax
  80030f:	c1 f8 16             	sar    $0x16,%eax
  800312:	39 c2                	cmp    %eax,%edx
  800314:	74 14                	je     80032a <_main+0x2f2>
  800316:	83 ec 04             	sub    $0x4,%esp
  800319:	68 d3 3e 80 00       	push   $0x803ed3
  80031e:	6a 60                	push   $0x60
  800320:	68 9c 3d 80 00       	push   $0x803d9c
  800325:	e8 c9 0a 00 00       	call   800df3 <_panic>

	// Make memory holes.
	freeFrames = sys_calculate_free_frames() ;
  80032a:	e8 30 21 00 00       	call   80245f <sys_calculate_free_frames>
  80032f:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800332:	e8 c8 21 00 00       	call   8024ff <sys_pf_calculate_allocated_pages>
  800337:	89 45 bc             	mov    %eax,-0x44(%ebp)

	free(ptr_allocations[0]);		// Hole 1 = 2 M
  80033a:	8b 85 b8 f7 ff ff    	mov    -0x848(%ebp),%eax
  800340:	83 ec 0c             	sub    $0xc,%esp
  800343:	50                   	push   %eax
  800344:	e8 6e 1d 00 00       	call   8020b7 <free>
  800349:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[2]);		// Hole 2 = 4 M
  80034c:	8b 85 c0 f7 ff ff    	mov    -0x840(%ebp),%eax
  800352:	83 ec 0c             	sub    $0xc,%esp
  800355:	50                   	push   %eax
  800356:	e8 5c 1d 00 00       	call   8020b7 <free>
  80035b:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[3]);
  80035e:	8b 85 c4 f7 ff ff    	mov    -0x83c(%ebp),%eax
  800364:	83 ec 0c             	sub    $0xc,%esp
  800367:	50                   	push   %eax
  800368:	e8 4a 1d 00 00       	call   8020b7 <free>
  80036d:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[10]);		// Hole 3 = 6 M
  800370:	8b 85 e0 f7 ff ff    	mov    -0x820(%ebp),%eax
  800376:	83 ec 0c             	sub    $0xc,%esp
  800379:	50                   	push   %eax
  80037a:	e8 38 1d 00 00       	call   8020b7 <free>
  80037f:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[12]);
  800382:	8b 85 e8 f7 ff ff    	mov    -0x818(%ebp),%eax
  800388:	83 ec 0c             	sub    $0xc,%esp
  80038b:	50                   	push   %eax
  80038c:	e8 26 1d 00 00       	call   8020b7 <free>
  800391:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[11]);
  800394:	8b 85 e4 f7 ff ff    	mov    -0x81c(%ebp),%eax
  80039a:	83 ec 0c             	sub    $0xc,%esp
  80039d:	50                   	push   %eax
  80039e:	e8 14 1d 00 00       	call   8020b7 <free>
  8003a3:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[100]);		// Hole 4 = 10 M
  8003a6:	8b 85 48 f9 ff ff    	mov    -0x6b8(%ebp),%eax
  8003ac:	83 ec 0c             	sub    $0xc,%esp
  8003af:	50                   	push   %eax
  8003b0:	e8 02 1d 00 00       	call   8020b7 <free>
  8003b5:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[104]);
  8003b8:	8b 85 58 f9 ff ff    	mov    -0x6a8(%ebp),%eax
  8003be:	83 ec 0c             	sub    $0xc,%esp
  8003c1:	50                   	push   %eax
  8003c2:	e8 f0 1c 00 00       	call   8020b7 <free>
  8003c7:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[103]);
  8003ca:	8b 85 54 f9 ff ff    	mov    -0x6ac(%ebp),%eax
  8003d0:	83 ec 0c             	sub    $0xc,%esp
  8003d3:	50                   	push   %eax
  8003d4:	e8 de 1c 00 00       	call   8020b7 <free>
  8003d9:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[102]);
  8003dc:	8b 85 50 f9 ff ff    	mov    -0x6b0(%ebp),%eax
  8003e2:	83 ec 0c             	sub    $0xc,%esp
  8003e5:	50                   	push   %eax
  8003e6:	e8 cc 1c 00 00       	call   8020b7 <free>
  8003eb:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[101]);
  8003ee:	8b 85 4c f9 ff ff    	mov    -0x6b4(%ebp),%eax
  8003f4:	83 ec 0c             	sub    $0xc,%esp
  8003f7:	50                   	push   %eax
  8003f8:	e8 ba 1c 00 00       	call   8020b7 <free>
  8003fd:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[200]);		// Hole 5 = 8 M
  800400:	8b 85 d8 fa ff ff    	mov    -0x528(%ebp),%eax
  800406:	83 ec 0c             	sub    $0xc,%esp
  800409:	50                   	push   %eax
  80040a:	e8 a8 1c 00 00       	call   8020b7 <free>
  80040f:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[201]);
  800412:	8b 85 dc fa ff ff    	mov    -0x524(%ebp),%eax
  800418:	83 ec 0c             	sub    $0xc,%esp
  80041b:	50                   	push   %eax
  80041c:	e8 96 1c 00 00       	call   8020b7 <free>
  800421:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[202]);
  800424:	8b 85 e0 fa ff ff    	mov    -0x520(%ebp),%eax
  80042a:	83 ec 0c             	sub    $0xc,%esp
  80042d:	50                   	push   %eax
  80042e:	e8 84 1c 00 00       	call   8020b7 <free>
  800433:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[203]);
  800436:	8b 85 e4 fa ff ff    	mov    -0x51c(%ebp),%eax
  80043c:	83 ec 0c             	sub    $0xc,%esp
  80043f:	50                   	push   %eax
  800440:	e8 72 1c 00 00       	call   8020b7 <free>
  800445:	83 c4 10             	add    $0x10,%esp

	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 15*(2*Mega)/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  800448:	e8 b2 20 00 00       	call   8024ff <sys_pf_calculate_allocated_pages>
  80044d:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800450:	89 d1                	mov    %edx,%ecx
  800452:	29 c1                	sub    %eax,%ecx
  800454:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800457:	89 d0                	mov    %edx,%eax
  800459:	01 c0                	add    %eax,%eax
  80045b:	01 d0                	add    %edx,%eax
  80045d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800464:	01 d0                	add    %edx,%eax
  800466:	01 c0                	add    %eax,%eax
  800468:	85 c0                	test   %eax,%eax
  80046a:	79 05                	jns    800471 <_main+0x439>
  80046c:	05 ff 0f 00 00       	add    $0xfff,%eax
  800471:	c1 f8 0c             	sar    $0xc,%eax
  800474:	39 c1                	cmp    %eax,%ecx
  800476:	74 14                	je     80048c <_main+0x454>
  800478:	83 ec 04             	sub    $0x4,%esp
  80047b:	68 e4 3e 80 00       	push   $0x803ee4
  800480:	6a 76                	push   $0x76
  800482:	68 9c 3d 80 00       	push   $0x803d9c
  800487:	e8 67 09 00 00       	call   800df3 <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  80048c:	e8 ce 1f 00 00       	call   80245f <sys_calculate_free_frames>
  800491:	89 c2                	mov    %eax,%edx
  800493:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800496:	39 c2                	cmp    %eax,%edx
  800498:	74 14                	je     8004ae <_main+0x476>
  80049a:	83 ec 04             	sub    $0x4,%esp
  80049d:	68 20 3f 80 00       	push   $0x803f20
  8004a2:	6a 77                	push   $0x77
  8004a4:	68 9c 3d 80 00       	push   $0x803d9c
  8004a9:	e8 45 09 00 00       	call   800df3 <_panic>

	// Test worst fit
	//[WORST FIT Case]
	freeFrames = sys_calculate_free_frames() ;
  8004ae:	e8 ac 1f 00 00       	call   80245f <sys_calculate_free_frames>
  8004b3:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8004b6:	e8 44 20 00 00       	call   8024ff <sys_pf_calculate_allocated_pages>
  8004bb:	89 45 bc             	mov    %eax,-0x44(%ebp)
	void* tempAddress = malloc(Mega);		// Use Hole 4 -> Hole 4 = 9 M
  8004be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004c1:	83 ec 0c             	sub    $0xc,%esp
  8004c4:	50                   	push   %eax
  8004c5:	e8 56 1b 00 00       	call   802020 <malloc>
  8004ca:	83 c4 10             	add    $0x10,%esp
  8004cd:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x8C800000)
  8004d0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8004d3:	3d 00 00 80 8c       	cmp    $0x8c800000,%eax
  8004d8:	74 14                	je     8004ee <_main+0x4b6>
		panic("Worst Fit not working correctly");
  8004da:	83 ec 04             	sub    $0x4,%esp
  8004dd:	68 60 3f 80 00       	push   $0x803f60
  8004e2:	6a 7f                	push   $0x7f
  8004e4:	68 9c 3d 80 00       	push   $0x803d9c
  8004e9:	e8 05 09 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8004ee:	e8 0c 20 00 00       	call   8024ff <sys_pf_calculate_allocated_pages>
  8004f3:	2b 45 bc             	sub    -0x44(%ebp),%eax
  8004f6:	89 c2                	mov    %eax,%edx
  8004f8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004fb:	85 c0                	test   %eax,%eax
  8004fd:	79 05                	jns    800504 <_main+0x4cc>
  8004ff:	05 ff 0f 00 00       	add    $0xfff,%eax
  800504:	c1 f8 0c             	sar    $0xc,%eax
  800507:	39 c2                	cmp    %eax,%edx
  800509:	74 17                	je     800522 <_main+0x4ea>
  80050b:	83 ec 04             	sub    $0x4,%esp
  80050e:	68 b6 3e 80 00       	push   $0x803eb6
  800513:	68 80 00 00 00       	push   $0x80
  800518:	68 9c 3d 80 00       	push   $0x803d9c
  80051d:	e8 d1 08 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800522:	e8 38 1f 00 00       	call   80245f <sys_calculate_free_frames>
  800527:	89 c2                	mov    %eax,%edx
  800529:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80052c:	39 c2                	cmp    %eax,%edx
  80052e:	74 17                	je     800547 <_main+0x50f>
  800530:	83 ec 04             	sub    $0x4,%esp
  800533:	68 d3 3e 80 00       	push   $0x803ed3
  800538:	68 81 00 00 00       	push   $0x81
  80053d:	68 9c 3d 80 00       	push   $0x803d9c
  800542:	e8 ac 08 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800547:	ff 45 d0             	incl   -0x30(%ebp)
  80054a:	83 ec 08             	sub    $0x8,%esp
  80054d:	ff 75 d0             	pushl  -0x30(%ebp)
  800550:	68 80 3f 80 00       	push   $0x803f80
  800555:	e8 4d 0b 00 00       	call   8010a7 <cprintf>
  80055a:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  80055d:	e8 fd 1e 00 00       	call   80245f <sys_calculate_free_frames>
  800562:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800565:	e8 95 1f 00 00       	call   8024ff <sys_pf_calculate_allocated_pages>
  80056a:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(4 * Mega);			// Use Hole 4 -> Hole 4 = 5 M
  80056d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800570:	c1 e0 02             	shl    $0x2,%eax
  800573:	83 ec 0c             	sub    $0xc,%esp
  800576:	50                   	push   %eax
  800577:	e8 a4 1a 00 00       	call   802020 <malloc>
  80057c:	83 c4 10             	add    $0x10,%esp
  80057f:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x8C900000)
  800582:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800585:	3d 00 00 90 8c       	cmp    $0x8c900000,%eax
  80058a:	74 17                	je     8005a3 <_main+0x56b>
		panic("Worst Fit not working correctly");
  80058c:	83 ec 04             	sub    $0x4,%esp
  80058f:	68 60 3f 80 00       	push   $0x803f60
  800594:	68 88 00 00 00       	push   $0x88
  800599:	68 9c 3d 80 00       	push   $0x803d9c
  80059e:	e8 50 08 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8005a3:	e8 57 1f 00 00       	call   8024ff <sys_pf_calculate_allocated_pages>
  8005a8:	2b 45 bc             	sub    -0x44(%ebp),%eax
  8005ab:	89 c2                	mov    %eax,%edx
  8005ad:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005b0:	c1 e0 02             	shl    $0x2,%eax
  8005b3:	85 c0                	test   %eax,%eax
  8005b5:	79 05                	jns    8005bc <_main+0x584>
  8005b7:	05 ff 0f 00 00       	add    $0xfff,%eax
  8005bc:	c1 f8 0c             	sar    $0xc,%eax
  8005bf:	39 c2                	cmp    %eax,%edx
  8005c1:	74 17                	je     8005da <_main+0x5a2>
  8005c3:	83 ec 04             	sub    $0x4,%esp
  8005c6:	68 b6 3e 80 00       	push   $0x803eb6
  8005cb:	68 89 00 00 00       	push   $0x89
  8005d0:	68 9c 3d 80 00       	push   $0x803d9c
  8005d5:	e8 19 08 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8005da:	e8 80 1e 00 00       	call   80245f <sys_calculate_free_frames>
  8005df:	89 c2                	mov    %eax,%edx
  8005e1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8005e4:	39 c2                	cmp    %eax,%edx
  8005e6:	74 17                	je     8005ff <_main+0x5c7>
  8005e8:	83 ec 04             	sub    $0x4,%esp
  8005eb:	68 d3 3e 80 00       	push   $0x803ed3
  8005f0:	68 8a 00 00 00       	push   $0x8a
  8005f5:	68 9c 3d 80 00       	push   $0x803d9c
  8005fa:	e8 f4 07 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8005ff:	ff 45 d0             	incl   -0x30(%ebp)
  800602:	83 ec 08             	sub    $0x8,%esp
  800605:	ff 75 d0             	pushl  -0x30(%ebp)
  800608:	68 80 3f 80 00       	push   $0x803f80
  80060d:	e8 95 0a 00 00       	call   8010a7 <cprintf>
  800612:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800615:	e8 45 1e 00 00       	call   80245f <sys_calculate_free_frames>
  80061a:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80061d:	e8 dd 1e 00 00       	call   8024ff <sys_pf_calculate_allocated_pages>
  800622:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(6*Mega); 			   // Use Hole 5 -> Hole 5 = 2 M
  800625:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800628:	89 d0                	mov    %edx,%eax
  80062a:	01 c0                	add    %eax,%eax
  80062c:	01 d0                	add    %edx,%eax
  80062e:	01 c0                	add    %eax,%eax
  800630:	83 ec 0c             	sub    $0xc,%esp
  800633:	50                   	push   %eax
  800634:	e8 e7 19 00 00       	call   802020 <malloc>
  800639:	83 c4 10             	add    $0x10,%esp
  80063c:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x99000000)
  80063f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800642:	3d 00 00 00 99       	cmp    $0x99000000,%eax
  800647:	74 17                	je     800660 <_main+0x628>
		panic("Worst Fit not working correctly");
  800649:	83 ec 04             	sub    $0x4,%esp
  80064c:	68 60 3f 80 00       	push   $0x803f60
  800651:	68 91 00 00 00       	push   $0x91
  800656:	68 9c 3d 80 00       	push   $0x803d9c
  80065b:	e8 93 07 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  6*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800660:	e8 9a 1e 00 00       	call   8024ff <sys_pf_calculate_allocated_pages>
  800665:	2b 45 bc             	sub    -0x44(%ebp),%eax
  800668:	89 c1                	mov    %eax,%ecx
  80066a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80066d:	89 d0                	mov    %edx,%eax
  80066f:	01 c0                	add    %eax,%eax
  800671:	01 d0                	add    %edx,%eax
  800673:	01 c0                	add    %eax,%eax
  800675:	85 c0                	test   %eax,%eax
  800677:	79 05                	jns    80067e <_main+0x646>
  800679:	05 ff 0f 00 00       	add    $0xfff,%eax
  80067e:	c1 f8 0c             	sar    $0xc,%eax
  800681:	39 c1                	cmp    %eax,%ecx
  800683:	74 17                	je     80069c <_main+0x664>
  800685:	83 ec 04             	sub    $0x4,%esp
  800688:	68 b6 3e 80 00       	push   $0x803eb6
  80068d:	68 92 00 00 00       	push   $0x92
  800692:	68 9c 3d 80 00       	push   $0x803d9c
  800697:	e8 57 07 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  80069c:	e8 be 1d 00 00       	call   80245f <sys_calculate_free_frames>
  8006a1:	89 c2                	mov    %eax,%edx
  8006a3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8006a6:	39 c2                	cmp    %eax,%edx
  8006a8:	74 17                	je     8006c1 <_main+0x689>
  8006aa:	83 ec 04             	sub    $0x4,%esp
  8006ad:	68 d3 3e 80 00       	push   $0x803ed3
  8006b2:	68 93 00 00 00       	push   $0x93
  8006b7:	68 9c 3d 80 00       	push   $0x803d9c
  8006bc:	e8 32 07 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8006c1:	ff 45 d0             	incl   -0x30(%ebp)
  8006c4:	83 ec 08             	sub    $0x8,%esp
  8006c7:	ff 75 d0             	pushl  -0x30(%ebp)
  8006ca:	68 80 3f 80 00       	push   $0x803f80
  8006cf:	e8 d3 09 00 00       	call   8010a7 <cprintf>
  8006d4:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  8006d7:	e8 83 1d 00 00       	call   80245f <sys_calculate_free_frames>
  8006dc:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8006df:	e8 1b 1e 00 00       	call   8024ff <sys_pf_calculate_allocated_pages>
  8006e4:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(5*Mega); 			   // Use Hole 3 -> Hole 3 = 1 M
  8006e7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006ea:	89 d0                	mov    %edx,%eax
  8006ec:	c1 e0 02             	shl    $0x2,%eax
  8006ef:	01 d0                	add    %edx,%eax
  8006f1:	83 ec 0c             	sub    $0xc,%esp
  8006f4:	50                   	push   %eax
  8006f5:	e8 26 19 00 00       	call   802020 <malloc>
  8006fa:	83 c4 10             	add    $0x10,%esp
  8006fd:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x81400000)
  800700:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800703:	3d 00 00 40 81       	cmp    $0x81400000,%eax
  800708:	74 17                	je     800721 <_main+0x6e9>
		panic("Worst Fit not working correctly");
  80070a:	83 ec 04             	sub    $0x4,%esp
  80070d:	68 60 3f 80 00       	push   $0x803f60
  800712:	68 9a 00 00 00       	push   $0x9a
  800717:	68 9c 3d 80 00       	push   $0x803d9c
  80071c:	e8 d2 06 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800721:	e8 d9 1d 00 00       	call   8024ff <sys_pf_calculate_allocated_pages>
  800726:	2b 45 bc             	sub    -0x44(%ebp),%eax
  800729:	89 c1                	mov    %eax,%ecx
  80072b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80072e:	89 d0                	mov    %edx,%eax
  800730:	c1 e0 02             	shl    $0x2,%eax
  800733:	01 d0                	add    %edx,%eax
  800735:	85 c0                	test   %eax,%eax
  800737:	79 05                	jns    80073e <_main+0x706>
  800739:	05 ff 0f 00 00       	add    $0xfff,%eax
  80073e:	c1 f8 0c             	sar    $0xc,%eax
  800741:	39 c1                	cmp    %eax,%ecx
  800743:	74 17                	je     80075c <_main+0x724>
  800745:	83 ec 04             	sub    $0x4,%esp
  800748:	68 b6 3e 80 00       	push   $0x803eb6
  80074d:	68 9b 00 00 00       	push   $0x9b
  800752:	68 9c 3d 80 00       	push   $0x803d9c
  800757:	e8 97 06 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  80075c:	e8 fe 1c 00 00       	call   80245f <sys_calculate_free_frames>
  800761:	89 c2                	mov    %eax,%edx
  800763:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800766:	39 c2                	cmp    %eax,%edx
  800768:	74 17                	je     800781 <_main+0x749>
  80076a:	83 ec 04             	sub    $0x4,%esp
  80076d:	68 d3 3e 80 00       	push   $0x803ed3
  800772:	68 9c 00 00 00       	push   $0x9c
  800777:	68 9c 3d 80 00       	push   $0x803d9c
  80077c:	e8 72 06 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800781:	ff 45 d0             	incl   -0x30(%ebp)
  800784:	83 ec 08             	sub    $0x8,%esp
  800787:	ff 75 d0             	pushl  -0x30(%ebp)
  80078a:	68 80 3f 80 00       	push   $0x803f80
  80078f:	e8 13 09 00 00       	call   8010a7 <cprintf>
  800794:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800797:	e8 c3 1c 00 00       	call   80245f <sys_calculate_free_frames>
  80079c:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80079f:	e8 5b 1d 00 00       	call   8024ff <sys_pf_calculate_allocated_pages>
  8007a4:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(4*Mega); 			   // Use Hole 4 -> Hole 4 = 1 M
  8007a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007aa:	c1 e0 02             	shl    $0x2,%eax
  8007ad:	83 ec 0c             	sub    $0xc,%esp
  8007b0:	50                   	push   %eax
  8007b1:	e8 6a 18 00 00       	call   802020 <malloc>
  8007b6:	83 c4 10             	add    $0x10,%esp
  8007b9:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x8CD00000)
  8007bc:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8007bf:	3d 00 00 d0 8c       	cmp    $0x8cd00000,%eax
  8007c4:	74 17                	je     8007dd <_main+0x7a5>
		panic("Worst Fit not working correctly");
  8007c6:	83 ec 04             	sub    $0x4,%esp
  8007c9:	68 60 3f 80 00       	push   $0x803f60
  8007ce:	68 a3 00 00 00       	push   $0xa3
  8007d3:	68 9c 3d 80 00       	push   $0x803d9c
  8007d8:	e8 16 06 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8007dd:	e8 1d 1d 00 00       	call   8024ff <sys_pf_calculate_allocated_pages>
  8007e2:	2b 45 bc             	sub    -0x44(%ebp),%eax
  8007e5:	89 c2                	mov    %eax,%edx
  8007e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007ea:	c1 e0 02             	shl    $0x2,%eax
  8007ed:	85 c0                	test   %eax,%eax
  8007ef:	79 05                	jns    8007f6 <_main+0x7be>
  8007f1:	05 ff 0f 00 00       	add    $0xfff,%eax
  8007f6:	c1 f8 0c             	sar    $0xc,%eax
  8007f9:	39 c2                	cmp    %eax,%edx
  8007fb:	74 17                	je     800814 <_main+0x7dc>
  8007fd:	83 ec 04             	sub    $0x4,%esp
  800800:	68 b6 3e 80 00       	push   $0x803eb6
  800805:	68 a4 00 00 00       	push   $0xa4
  80080a:	68 9c 3d 80 00       	push   $0x803d9c
  80080f:	e8 df 05 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800814:	e8 46 1c 00 00       	call   80245f <sys_calculate_free_frames>
  800819:	89 c2                	mov    %eax,%edx
  80081b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80081e:	39 c2                	cmp    %eax,%edx
  800820:	74 17                	je     800839 <_main+0x801>
  800822:	83 ec 04             	sub    $0x4,%esp
  800825:	68 d3 3e 80 00       	push   $0x803ed3
  80082a:	68 a5 00 00 00       	push   $0xa5
  80082f:	68 9c 3d 80 00       	push   $0x803d9c
  800834:	e8 ba 05 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800839:	ff 45 d0             	incl   -0x30(%ebp)
  80083c:	83 ec 08             	sub    $0x8,%esp
  80083f:	ff 75 d0             	pushl  -0x30(%ebp)
  800842:	68 80 3f 80 00       	push   $0x803f80
  800847:	e8 5b 08 00 00       	call   8010a7 <cprintf>
  80084c:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  80084f:	e8 0b 1c 00 00       	call   80245f <sys_calculate_free_frames>
  800854:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800857:	e8 a3 1c 00 00       	call   8024ff <sys_pf_calculate_allocated_pages>
  80085c:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(2 * Mega); 			// Use Hole 2 -> Hole 2 = 2 M
  80085f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800862:	01 c0                	add    %eax,%eax
  800864:	83 ec 0c             	sub    $0xc,%esp
  800867:	50                   	push   %eax
  800868:	e8 b3 17 00 00       	call   802020 <malloc>
  80086d:	83 c4 10             	add    $0x10,%esp
  800870:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x80400000)
  800873:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800876:	3d 00 00 40 80       	cmp    $0x80400000,%eax
  80087b:	74 17                	je     800894 <_main+0x85c>
		panic("Worst Fit not working correctly");
  80087d:	83 ec 04             	sub    $0x4,%esp
  800880:	68 60 3f 80 00       	push   $0x803f60
  800885:	68 ac 00 00 00       	push   $0xac
  80088a:	68 9c 3d 80 00       	push   $0x803d9c
  80088f:	e8 5f 05 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800894:	e8 66 1c 00 00       	call   8024ff <sys_pf_calculate_allocated_pages>
  800899:	2b 45 bc             	sub    -0x44(%ebp),%eax
  80089c:	89 c2                	mov    %eax,%edx
  80089e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008a1:	01 c0                	add    %eax,%eax
  8008a3:	85 c0                	test   %eax,%eax
  8008a5:	79 05                	jns    8008ac <_main+0x874>
  8008a7:	05 ff 0f 00 00       	add    $0xfff,%eax
  8008ac:	c1 f8 0c             	sar    $0xc,%eax
  8008af:	39 c2                	cmp    %eax,%edx
  8008b1:	74 17                	je     8008ca <_main+0x892>
  8008b3:	83 ec 04             	sub    $0x4,%esp
  8008b6:	68 b6 3e 80 00       	push   $0x803eb6
  8008bb:	68 ad 00 00 00       	push   $0xad
  8008c0:	68 9c 3d 80 00       	push   $0x803d9c
  8008c5:	e8 29 05 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8008ca:	e8 90 1b 00 00       	call   80245f <sys_calculate_free_frames>
  8008cf:	89 c2                	mov    %eax,%edx
  8008d1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8008d4:	39 c2                	cmp    %eax,%edx
  8008d6:	74 17                	je     8008ef <_main+0x8b7>
  8008d8:	83 ec 04             	sub    $0x4,%esp
  8008db:	68 d3 3e 80 00       	push   $0x803ed3
  8008e0:	68 ae 00 00 00       	push   $0xae
  8008e5:	68 9c 3d 80 00       	push   $0x803d9c
  8008ea:	e8 04 05 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8008ef:	ff 45 d0             	incl   -0x30(%ebp)
  8008f2:	83 ec 08             	sub    $0x8,%esp
  8008f5:	ff 75 d0             	pushl  -0x30(%ebp)
  8008f8:	68 80 3f 80 00       	push   $0x803f80
  8008fd:	e8 a5 07 00 00       	call   8010a7 <cprintf>
  800902:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800905:	e8 55 1b 00 00       	call   80245f <sys_calculate_free_frames>
  80090a:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80090d:	e8 ed 1b 00 00       	call   8024ff <sys_pf_calculate_allocated_pages>
  800912:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(1*Mega + 512*kilo);    // Use Hole 1 -> Hole 1 = 0.5 M
  800915:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800918:	c1 e0 09             	shl    $0x9,%eax
  80091b:	89 c2                	mov    %eax,%edx
  80091d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800920:	01 d0                	add    %edx,%eax
  800922:	83 ec 0c             	sub    $0xc,%esp
  800925:	50                   	push   %eax
  800926:	e8 f5 16 00 00       	call   802020 <malloc>
  80092b:	83 c4 10             	add    $0x10,%esp
  80092e:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x80000000)
  800931:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800934:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800939:	74 17                	je     800952 <_main+0x91a>
		panic("Worst Fit not working correctly");
  80093b:	83 ec 04             	sub    $0x4,%esp
  80093e:	68 60 3f 80 00       	push   $0x803f60
  800943:	68 b5 00 00 00       	push   $0xb5
  800948:	68 9c 3d 80 00       	push   $0x803d9c
  80094d:	e8 a1 04 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (1*Mega + 512*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  800952:	e8 a8 1b 00 00       	call   8024ff <sys_pf_calculate_allocated_pages>
  800957:	2b 45 bc             	sub    -0x44(%ebp),%eax
  80095a:	89 c2                	mov    %eax,%edx
  80095c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80095f:	c1 e0 09             	shl    $0x9,%eax
  800962:	89 c1                	mov    %eax,%ecx
  800964:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800967:	01 c8                	add    %ecx,%eax
  800969:	85 c0                	test   %eax,%eax
  80096b:	79 05                	jns    800972 <_main+0x93a>
  80096d:	05 ff 0f 00 00       	add    $0xfff,%eax
  800972:	c1 f8 0c             	sar    $0xc,%eax
  800975:	39 c2                	cmp    %eax,%edx
  800977:	74 17                	je     800990 <_main+0x958>
  800979:	83 ec 04             	sub    $0x4,%esp
  80097c:	68 b6 3e 80 00       	push   $0x803eb6
  800981:	68 b6 00 00 00       	push   $0xb6
  800986:	68 9c 3d 80 00       	push   $0x803d9c
  80098b:	e8 63 04 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800990:	e8 ca 1a 00 00       	call   80245f <sys_calculate_free_frames>
  800995:	89 c2                	mov    %eax,%edx
  800997:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80099a:	39 c2                	cmp    %eax,%edx
  80099c:	74 17                	je     8009b5 <_main+0x97d>
  80099e:	83 ec 04             	sub    $0x4,%esp
  8009a1:	68 d3 3e 80 00       	push   $0x803ed3
  8009a6:	68 b7 00 00 00       	push   $0xb7
  8009ab:	68 9c 3d 80 00       	push   $0x803d9c
  8009b0:	e8 3e 04 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8009b5:	ff 45 d0             	incl   -0x30(%ebp)
  8009b8:	83 ec 08             	sub    $0x8,%esp
  8009bb:	ff 75 d0             	pushl  -0x30(%ebp)
  8009be:	68 80 3f 80 00       	push   $0x803f80
  8009c3:	e8 df 06 00 00       	call   8010a7 <cprintf>
  8009c8:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  8009cb:	e8 8f 1a 00 00       	call   80245f <sys_calculate_free_frames>
  8009d0:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8009d3:	e8 27 1b 00 00       	call   8024ff <sys_pf_calculate_allocated_pages>
  8009d8:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(512*kilo); 			   // Use Hole 2 -> Hole 2 = 1.5 M
  8009db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8009de:	c1 e0 09             	shl    $0x9,%eax
  8009e1:	83 ec 0c             	sub    $0xc,%esp
  8009e4:	50                   	push   %eax
  8009e5:	e8 36 16 00 00       	call   802020 <malloc>
  8009ea:	83 c4 10             	add    $0x10,%esp
  8009ed:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x80600000)
  8009f0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8009f3:	3d 00 00 60 80       	cmp    $0x80600000,%eax
  8009f8:	74 17                	je     800a11 <_main+0x9d9>
		panic("Worst Fit not working correctly");
  8009fa:	83 ec 04             	sub    $0x4,%esp
  8009fd:	68 60 3f 80 00       	push   $0x803f60
  800a02:	68 be 00 00 00       	push   $0xbe
  800a07:	68 9c 3d 80 00       	push   $0x803d9c
  800a0c:	e8 e2 03 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800a11:	e8 e9 1a 00 00       	call   8024ff <sys_pf_calculate_allocated_pages>
  800a16:	2b 45 bc             	sub    -0x44(%ebp),%eax
  800a19:	89 c2                	mov    %eax,%edx
  800a1b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a1e:	c1 e0 09             	shl    $0x9,%eax
  800a21:	85 c0                	test   %eax,%eax
  800a23:	79 05                	jns    800a2a <_main+0x9f2>
  800a25:	05 ff 0f 00 00       	add    $0xfff,%eax
  800a2a:	c1 f8 0c             	sar    $0xc,%eax
  800a2d:	39 c2                	cmp    %eax,%edx
  800a2f:	74 17                	je     800a48 <_main+0xa10>
  800a31:	83 ec 04             	sub    $0x4,%esp
  800a34:	68 b6 3e 80 00       	push   $0x803eb6
  800a39:	68 bf 00 00 00       	push   $0xbf
  800a3e:	68 9c 3d 80 00       	push   $0x803d9c
  800a43:	e8 ab 03 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800a48:	e8 12 1a 00 00       	call   80245f <sys_calculate_free_frames>
  800a4d:	89 c2                	mov    %eax,%edx
  800a4f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800a52:	39 c2                	cmp    %eax,%edx
  800a54:	74 17                	je     800a6d <_main+0xa35>
  800a56:	83 ec 04             	sub    $0x4,%esp
  800a59:	68 d3 3e 80 00       	push   $0x803ed3
  800a5e:	68 c0 00 00 00       	push   $0xc0
  800a63:	68 9c 3d 80 00       	push   $0x803d9c
  800a68:	e8 86 03 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800a6d:	ff 45 d0             	incl   -0x30(%ebp)
  800a70:	83 ec 08             	sub    $0x8,%esp
  800a73:	ff 75 d0             	pushl  -0x30(%ebp)
  800a76:	68 80 3f 80 00       	push   $0x803f80
  800a7b:	e8 27 06 00 00       	call   8010a7 <cprintf>
  800a80:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800a83:	e8 d7 19 00 00       	call   80245f <sys_calculate_free_frames>
  800a88:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800a8b:	e8 6f 1a 00 00       	call   8024ff <sys_pf_calculate_allocated_pages>
  800a90:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(kilo); 			   // Use Hole 5 -> Hole 5 = 2 M - K
  800a93:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a96:	83 ec 0c             	sub    $0xc,%esp
  800a99:	50                   	push   %eax
  800a9a:	e8 81 15 00 00       	call   802020 <malloc>
  800a9f:	83 c4 10             	add    $0x10,%esp
  800aa2:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x99600000)
  800aa5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800aa8:	3d 00 00 60 99       	cmp    $0x99600000,%eax
  800aad:	74 17                	je     800ac6 <_main+0xa8e>
		panic("Worst Fit not working correctly");
  800aaf:	83 ec 04             	sub    $0x4,%esp
  800ab2:	68 60 3f 80 00       	push   $0x803f60
  800ab7:	68 c7 00 00 00       	push   $0xc7
  800abc:	68 9c 3d 80 00       	push   $0x803d9c
  800ac1:	e8 2d 03 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800ac6:	e8 34 1a 00 00       	call   8024ff <sys_pf_calculate_allocated_pages>
  800acb:	2b 45 bc             	sub    -0x44(%ebp),%eax
  800ace:	89 c2                	mov    %eax,%edx
  800ad0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800ad3:	c1 e0 02             	shl    $0x2,%eax
  800ad6:	85 c0                	test   %eax,%eax
  800ad8:	79 05                	jns    800adf <_main+0xaa7>
  800ada:	05 ff 0f 00 00       	add    $0xfff,%eax
  800adf:	c1 f8 0c             	sar    $0xc,%eax
  800ae2:	39 c2                	cmp    %eax,%edx
  800ae4:	74 17                	je     800afd <_main+0xac5>
  800ae6:	83 ec 04             	sub    $0x4,%esp
  800ae9:	68 b6 3e 80 00       	push   $0x803eb6
  800aee:	68 c8 00 00 00       	push   $0xc8
  800af3:	68 9c 3d 80 00       	push   $0x803d9c
  800af8:	e8 f6 02 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800afd:	e8 5d 19 00 00       	call   80245f <sys_calculate_free_frames>
  800b02:	89 c2                	mov    %eax,%edx
  800b04:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800b07:	39 c2                	cmp    %eax,%edx
  800b09:	74 17                	je     800b22 <_main+0xaea>
  800b0b:	83 ec 04             	sub    $0x4,%esp
  800b0e:	68 d3 3e 80 00       	push   $0x803ed3
  800b13:	68 c9 00 00 00       	push   $0xc9
  800b18:	68 9c 3d 80 00       	push   $0x803d9c
  800b1d:	e8 d1 02 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800b22:	ff 45 d0             	incl   -0x30(%ebp)
  800b25:	83 ec 08             	sub    $0x8,%esp
  800b28:	ff 75 d0             	pushl  -0x30(%ebp)
  800b2b:	68 80 3f 80 00       	push   $0x803f80
  800b30:	e8 72 05 00 00       	call   8010a7 <cprintf>
  800b35:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800b38:	e8 22 19 00 00       	call   80245f <sys_calculate_free_frames>
  800b3d:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800b40:	e8 ba 19 00 00       	call   8024ff <sys_pf_calculate_allocated_pages>
  800b45:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(2*Mega - 4*kilo); 		// Use Hole 5 -> Hole 5 = 0
  800b48:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b4b:	01 c0                	add    %eax,%eax
  800b4d:	89 c2                	mov    %eax,%edx
  800b4f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b52:	29 d0                	sub    %edx,%eax
  800b54:	01 c0                	add    %eax,%eax
  800b56:	83 ec 0c             	sub    $0xc,%esp
  800b59:	50                   	push   %eax
  800b5a:	e8 c1 14 00 00       	call   802020 <malloc>
  800b5f:	83 c4 10             	add    $0x10,%esp
  800b62:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x99601000)
  800b65:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800b68:	3d 00 10 60 99       	cmp    $0x99601000,%eax
  800b6d:	74 17                	je     800b86 <_main+0xb4e>
		panic("Worst Fit not working correctly");
  800b6f:	83 ec 04             	sub    $0x4,%esp
  800b72:	68 60 3f 80 00       	push   $0x803f60
  800b77:	68 d0 00 00 00       	push   $0xd0
  800b7c:	68 9c 3d 80 00       	push   $0x803d9c
  800b81:	e8 6d 02 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (2*Mega - 4*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  800b86:	e8 74 19 00 00       	call   8024ff <sys_pf_calculate_allocated_pages>
  800b8b:	2b 45 bc             	sub    -0x44(%ebp),%eax
  800b8e:	89 c2                	mov    %eax,%edx
  800b90:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b93:	01 c0                	add    %eax,%eax
  800b95:	89 c1                	mov    %eax,%ecx
  800b97:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b9a:	29 c8                	sub    %ecx,%eax
  800b9c:	01 c0                	add    %eax,%eax
  800b9e:	85 c0                	test   %eax,%eax
  800ba0:	79 05                	jns    800ba7 <_main+0xb6f>
  800ba2:	05 ff 0f 00 00       	add    $0xfff,%eax
  800ba7:	c1 f8 0c             	sar    $0xc,%eax
  800baa:	39 c2                	cmp    %eax,%edx
  800bac:	74 17                	je     800bc5 <_main+0xb8d>
  800bae:	83 ec 04             	sub    $0x4,%esp
  800bb1:	68 b6 3e 80 00       	push   $0x803eb6
  800bb6:	68 d1 00 00 00       	push   $0xd1
  800bbb:	68 9c 3d 80 00       	push   $0x803d9c
  800bc0:	e8 2e 02 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800bc5:	e8 95 18 00 00       	call   80245f <sys_calculate_free_frames>
  800bca:	89 c2                	mov    %eax,%edx
  800bcc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800bcf:	39 c2                	cmp    %eax,%edx
  800bd1:	74 17                	je     800bea <_main+0xbb2>
  800bd3:	83 ec 04             	sub    $0x4,%esp
  800bd6:	68 d3 3e 80 00       	push   $0x803ed3
  800bdb:	68 d2 00 00 00       	push   $0xd2
  800be0:	68 9c 3d 80 00       	push   $0x803d9c
  800be5:	e8 09 02 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800bea:	ff 45 d0             	incl   -0x30(%ebp)
  800bed:	83 ec 08             	sub    $0x8,%esp
  800bf0:	ff 75 d0             	pushl  -0x30(%ebp)
  800bf3:	68 80 3f 80 00       	push   $0x803f80
  800bf8:	e8 aa 04 00 00       	call   8010a7 <cprintf>
  800bfd:	83 c4 10             	add    $0x10,%esp

	// Check that worst fit returns null in case all holes are not free
	freeFrames = sys_calculate_free_frames() ;
  800c00:	e8 5a 18 00 00       	call   80245f <sys_calculate_free_frames>
  800c05:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800c08:	e8 f2 18 00 00       	call   8024ff <sys_pf_calculate_allocated_pages>
  800c0d:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(4*Mega); 		//No Suitable hole
  800c10:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c13:	c1 e0 02             	shl    $0x2,%eax
  800c16:	83 ec 0c             	sub    $0xc,%esp
  800c19:	50                   	push   %eax
  800c1a:	e8 01 14 00 00       	call   802020 <malloc>
  800c1f:	83 c4 10             	add    $0x10,%esp
  800c22:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x0)
  800c25:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800c28:	85 c0                	test   %eax,%eax
  800c2a:	74 17                	je     800c43 <_main+0xc0b>
		panic("Worst Fit not working correctly");
  800c2c:	83 ec 04             	sub    $0x4,%esp
  800c2f:	68 60 3f 80 00       	push   $0x803f60
  800c34:	68 da 00 00 00       	push   $0xda
  800c39:	68 9c 3d 80 00       	push   $0x803d9c
  800c3e:	e8 b0 01 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800c43:	e8 b7 18 00 00       	call   8024ff <sys_pf_calculate_allocated_pages>
  800c48:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  800c4b:	74 17                	je     800c64 <_main+0xc2c>
  800c4d:	83 ec 04             	sub    $0x4,%esp
  800c50:	68 b6 3e 80 00       	push   $0x803eb6
  800c55:	68 db 00 00 00       	push   $0xdb
  800c5a:	68 9c 3d 80 00       	push   $0x803d9c
  800c5f:	e8 8f 01 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800c64:	e8 f6 17 00 00       	call   80245f <sys_calculate_free_frames>
  800c69:	89 c2                	mov    %eax,%edx
  800c6b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800c6e:	39 c2                	cmp    %eax,%edx
  800c70:	74 17                	je     800c89 <_main+0xc51>
  800c72:	83 ec 04             	sub    $0x4,%esp
  800c75:	68 d3 3e 80 00       	push   $0x803ed3
  800c7a:	68 dc 00 00 00       	push   $0xdc
  800c7f:	68 9c 3d 80 00       	push   $0x803d9c
  800c84:	e8 6a 01 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800c89:	ff 45 d0             	incl   -0x30(%ebp)
  800c8c:	83 ec 08             	sub    $0x8,%esp
  800c8f:	ff 75 d0             	pushl  -0x30(%ebp)
  800c92:	68 80 3f 80 00       	push   $0x803f80
  800c97:	e8 0b 04 00 00       	call   8010a7 <cprintf>
  800c9c:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! test Worst Fit completed successfully.\n");
  800c9f:	83 ec 0c             	sub    $0xc,%esp
  800ca2:	68 94 3f 80 00       	push   $0x803f94
  800ca7:	e8 fb 03 00 00       	call   8010a7 <cprintf>
  800cac:	83 c4 10             	add    $0x10,%esp

	return;
  800caf:	90                   	nop
}
  800cb0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cb3:	5b                   	pop    %ebx
  800cb4:	5f                   	pop    %edi
  800cb5:	5d                   	pop    %ebp
  800cb6:	c3                   	ret    

00800cb7 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800cb7:	55                   	push   %ebp
  800cb8:	89 e5                	mov    %esp,%ebp
  800cba:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800cbd:	e8 7d 1a 00 00       	call   80273f <sys_getenvindex>
  800cc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800cc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cc8:	89 d0                	mov    %edx,%eax
  800cca:	c1 e0 03             	shl    $0x3,%eax
  800ccd:	01 d0                	add    %edx,%eax
  800ccf:	01 c0                	add    %eax,%eax
  800cd1:	01 d0                	add    %edx,%eax
  800cd3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800cda:	01 d0                	add    %edx,%eax
  800cdc:	c1 e0 04             	shl    $0x4,%eax
  800cdf:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800ce4:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800ce9:	a1 20 50 80 00       	mov    0x805020,%eax
  800cee:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800cf4:	84 c0                	test   %al,%al
  800cf6:	74 0f                	je     800d07 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800cf8:	a1 20 50 80 00       	mov    0x805020,%eax
  800cfd:	05 5c 05 00 00       	add    $0x55c,%eax
  800d02:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800d07:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d0b:	7e 0a                	jle    800d17 <libmain+0x60>
		binaryname = argv[0];
  800d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d10:	8b 00                	mov    (%eax),%eax
  800d12:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800d17:	83 ec 08             	sub    $0x8,%esp
  800d1a:	ff 75 0c             	pushl  0xc(%ebp)
  800d1d:	ff 75 08             	pushl  0x8(%ebp)
  800d20:	e8 13 f3 ff ff       	call   800038 <_main>
  800d25:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800d28:	e8 1f 18 00 00       	call   80254c <sys_disable_interrupt>
	cprintf("**************************************\n");
  800d2d:	83 ec 0c             	sub    $0xc,%esp
  800d30:	68 e8 3f 80 00       	push   $0x803fe8
  800d35:	e8 6d 03 00 00       	call   8010a7 <cprintf>
  800d3a:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800d3d:	a1 20 50 80 00       	mov    0x805020,%eax
  800d42:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800d48:	a1 20 50 80 00       	mov    0x805020,%eax
  800d4d:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800d53:	83 ec 04             	sub    $0x4,%esp
  800d56:	52                   	push   %edx
  800d57:	50                   	push   %eax
  800d58:	68 10 40 80 00       	push   $0x804010
  800d5d:	e8 45 03 00 00       	call   8010a7 <cprintf>
  800d62:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800d65:	a1 20 50 80 00       	mov    0x805020,%eax
  800d6a:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800d70:	a1 20 50 80 00       	mov    0x805020,%eax
  800d75:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800d7b:	a1 20 50 80 00       	mov    0x805020,%eax
  800d80:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800d86:	51                   	push   %ecx
  800d87:	52                   	push   %edx
  800d88:	50                   	push   %eax
  800d89:	68 38 40 80 00       	push   $0x804038
  800d8e:	e8 14 03 00 00       	call   8010a7 <cprintf>
  800d93:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800d96:	a1 20 50 80 00       	mov    0x805020,%eax
  800d9b:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800da1:	83 ec 08             	sub    $0x8,%esp
  800da4:	50                   	push   %eax
  800da5:	68 90 40 80 00       	push   $0x804090
  800daa:	e8 f8 02 00 00       	call   8010a7 <cprintf>
  800daf:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800db2:	83 ec 0c             	sub    $0xc,%esp
  800db5:	68 e8 3f 80 00       	push   $0x803fe8
  800dba:	e8 e8 02 00 00       	call   8010a7 <cprintf>
  800dbf:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800dc2:	e8 9f 17 00 00       	call   802566 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800dc7:	e8 19 00 00 00       	call   800de5 <exit>
}
  800dcc:	90                   	nop
  800dcd:	c9                   	leave  
  800dce:	c3                   	ret    

00800dcf <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800dcf:	55                   	push   %ebp
  800dd0:	89 e5                	mov    %esp,%ebp
  800dd2:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800dd5:	83 ec 0c             	sub    $0xc,%esp
  800dd8:	6a 00                	push   $0x0
  800dda:	e8 2c 19 00 00       	call   80270b <sys_destroy_env>
  800ddf:	83 c4 10             	add    $0x10,%esp
}
  800de2:	90                   	nop
  800de3:	c9                   	leave  
  800de4:	c3                   	ret    

00800de5 <exit>:

void
exit(void)
{
  800de5:	55                   	push   %ebp
  800de6:	89 e5                	mov    %esp,%ebp
  800de8:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800deb:	e8 81 19 00 00       	call   802771 <sys_exit_env>
}
  800df0:	90                   	nop
  800df1:	c9                   	leave  
  800df2:	c3                   	ret    

00800df3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800df3:	55                   	push   %ebp
  800df4:	89 e5                	mov    %esp,%ebp
  800df6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800df9:	8d 45 10             	lea    0x10(%ebp),%eax
  800dfc:	83 c0 04             	add    $0x4,%eax
  800dff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800e02:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800e07:	85 c0                	test   %eax,%eax
  800e09:	74 16                	je     800e21 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800e0b:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800e10:	83 ec 08             	sub    $0x8,%esp
  800e13:	50                   	push   %eax
  800e14:	68 a4 40 80 00       	push   $0x8040a4
  800e19:	e8 89 02 00 00       	call   8010a7 <cprintf>
  800e1e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800e21:	a1 00 50 80 00       	mov    0x805000,%eax
  800e26:	ff 75 0c             	pushl  0xc(%ebp)
  800e29:	ff 75 08             	pushl  0x8(%ebp)
  800e2c:	50                   	push   %eax
  800e2d:	68 a9 40 80 00       	push   $0x8040a9
  800e32:	e8 70 02 00 00       	call   8010a7 <cprintf>
  800e37:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800e3a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3d:	83 ec 08             	sub    $0x8,%esp
  800e40:	ff 75 f4             	pushl  -0xc(%ebp)
  800e43:	50                   	push   %eax
  800e44:	e8 f3 01 00 00       	call   80103c <vcprintf>
  800e49:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800e4c:	83 ec 08             	sub    $0x8,%esp
  800e4f:	6a 00                	push   $0x0
  800e51:	68 c5 40 80 00       	push   $0x8040c5
  800e56:	e8 e1 01 00 00       	call   80103c <vcprintf>
  800e5b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800e5e:	e8 82 ff ff ff       	call   800de5 <exit>

	// should not return here
	while (1) ;
  800e63:	eb fe                	jmp    800e63 <_panic+0x70>

00800e65 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800e65:	55                   	push   %ebp
  800e66:	89 e5                	mov    %esp,%ebp
  800e68:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800e6b:	a1 20 50 80 00       	mov    0x805020,%eax
  800e70:	8b 50 74             	mov    0x74(%eax),%edx
  800e73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e76:	39 c2                	cmp    %eax,%edx
  800e78:	74 14                	je     800e8e <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800e7a:	83 ec 04             	sub    $0x4,%esp
  800e7d:	68 c8 40 80 00       	push   $0x8040c8
  800e82:	6a 26                	push   $0x26
  800e84:	68 14 41 80 00       	push   $0x804114
  800e89:	e8 65 ff ff ff       	call   800df3 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800e8e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800e95:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e9c:	e9 c2 00 00 00       	jmp    800f63 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800ea1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ea4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800eab:	8b 45 08             	mov    0x8(%ebp),%eax
  800eae:	01 d0                	add    %edx,%eax
  800eb0:	8b 00                	mov    (%eax),%eax
  800eb2:	85 c0                	test   %eax,%eax
  800eb4:	75 08                	jne    800ebe <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800eb6:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800eb9:	e9 a2 00 00 00       	jmp    800f60 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800ebe:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ec5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800ecc:	eb 69                	jmp    800f37 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800ece:	a1 20 50 80 00       	mov    0x805020,%eax
  800ed3:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ed9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800edc:	89 d0                	mov    %edx,%eax
  800ede:	01 c0                	add    %eax,%eax
  800ee0:	01 d0                	add    %edx,%eax
  800ee2:	c1 e0 03             	shl    $0x3,%eax
  800ee5:	01 c8                	add    %ecx,%eax
  800ee7:	8a 40 04             	mov    0x4(%eax),%al
  800eea:	84 c0                	test   %al,%al
  800eec:	75 46                	jne    800f34 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800eee:	a1 20 50 80 00       	mov    0x805020,%eax
  800ef3:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ef9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800efc:	89 d0                	mov    %edx,%eax
  800efe:	01 c0                	add    %eax,%eax
  800f00:	01 d0                	add    %edx,%eax
  800f02:	c1 e0 03             	shl    $0x3,%eax
  800f05:	01 c8                	add    %ecx,%eax
  800f07:	8b 00                	mov    (%eax),%eax
  800f09:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800f0c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800f0f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f14:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800f16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f19:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	01 c8                	add    %ecx,%eax
  800f25:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800f27:	39 c2                	cmp    %eax,%edx
  800f29:	75 09                	jne    800f34 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800f2b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800f32:	eb 12                	jmp    800f46 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800f34:	ff 45 e8             	incl   -0x18(%ebp)
  800f37:	a1 20 50 80 00       	mov    0x805020,%eax
  800f3c:	8b 50 74             	mov    0x74(%eax),%edx
  800f3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800f42:	39 c2                	cmp    %eax,%edx
  800f44:	77 88                	ja     800ece <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800f46:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800f4a:	75 14                	jne    800f60 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800f4c:	83 ec 04             	sub    $0x4,%esp
  800f4f:	68 20 41 80 00       	push   $0x804120
  800f54:	6a 3a                	push   $0x3a
  800f56:	68 14 41 80 00       	push   $0x804114
  800f5b:	e8 93 fe ff ff       	call   800df3 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800f60:	ff 45 f0             	incl   -0x10(%ebp)
  800f63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f66:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800f69:	0f 8c 32 ff ff ff    	jl     800ea1 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800f6f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800f76:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800f7d:	eb 26                	jmp    800fa5 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800f7f:	a1 20 50 80 00       	mov    0x805020,%eax
  800f84:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800f8a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800f8d:	89 d0                	mov    %edx,%eax
  800f8f:	01 c0                	add    %eax,%eax
  800f91:	01 d0                	add    %edx,%eax
  800f93:	c1 e0 03             	shl    $0x3,%eax
  800f96:	01 c8                	add    %ecx,%eax
  800f98:	8a 40 04             	mov    0x4(%eax),%al
  800f9b:	3c 01                	cmp    $0x1,%al
  800f9d:	75 03                	jne    800fa2 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800f9f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800fa2:	ff 45 e0             	incl   -0x20(%ebp)
  800fa5:	a1 20 50 80 00       	mov    0x805020,%eax
  800faa:	8b 50 74             	mov    0x74(%eax),%edx
  800fad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fb0:	39 c2                	cmp    %eax,%edx
  800fb2:	77 cb                	ja     800f7f <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fb7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800fba:	74 14                	je     800fd0 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800fbc:	83 ec 04             	sub    $0x4,%esp
  800fbf:	68 74 41 80 00       	push   $0x804174
  800fc4:	6a 44                	push   $0x44
  800fc6:	68 14 41 80 00       	push   $0x804114
  800fcb:	e8 23 fe ff ff       	call   800df3 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800fd0:	90                   	nop
  800fd1:	c9                   	leave  
  800fd2:	c3                   	ret    

00800fd3 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800fd3:	55                   	push   %ebp
  800fd4:	89 e5                	mov    %esp,%ebp
  800fd6:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdc:	8b 00                	mov    (%eax),%eax
  800fde:	8d 48 01             	lea    0x1(%eax),%ecx
  800fe1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fe4:	89 0a                	mov    %ecx,(%edx)
  800fe6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe9:	88 d1                	mov    %dl,%cl
  800feb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fee:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800ff2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff5:	8b 00                	mov    (%eax),%eax
  800ff7:	3d ff 00 00 00       	cmp    $0xff,%eax
  800ffc:	75 2c                	jne    80102a <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800ffe:	a0 24 50 80 00       	mov    0x805024,%al
  801003:	0f b6 c0             	movzbl %al,%eax
  801006:	8b 55 0c             	mov    0xc(%ebp),%edx
  801009:	8b 12                	mov    (%edx),%edx
  80100b:	89 d1                	mov    %edx,%ecx
  80100d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801010:	83 c2 08             	add    $0x8,%edx
  801013:	83 ec 04             	sub    $0x4,%esp
  801016:	50                   	push   %eax
  801017:	51                   	push   %ecx
  801018:	52                   	push   %edx
  801019:	e8 80 13 00 00       	call   80239e <sys_cputs>
  80101e:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801021:	8b 45 0c             	mov    0xc(%ebp),%eax
  801024:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80102a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102d:	8b 40 04             	mov    0x4(%eax),%eax
  801030:	8d 50 01             	lea    0x1(%eax),%edx
  801033:	8b 45 0c             	mov    0xc(%ebp),%eax
  801036:	89 50 04             	mov    %edx,0x4(%eax)
}
  801039:	90                   	nop
  80103a:	c9                   	leave  
  80103b:	c3                   	ret    

0080103c <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80103c:	55                   	push   %ebp
  80103d:	89 e5                	mov    %esp,%ebp
  80103f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801045:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80104c:	00 00 00 
	b.cnt = 0;
  80104f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801056:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801059:	ff 75 0c             	pushl  0xc(%ebp)
  80105c:	ff 75 08             	pushl  0x8(%ebp)
  80105f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801065:	50                   	push   %eax
  801066:	68 d3 0f 80 00       	push   $0x800fd3
  80106b:	e8 11 02 00 00       	call   801281 <vprintfmt>
  801070:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  801073:	a0 24 50 80 00       	mov    0x805024,%al
  801078:	0f b6 c0             	movzbl %al,%eax
  80107b:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801081:	83 ec 04             	sub    $0x4,%esp
  801084:	50                   	push   %eax
  801085:	52                   	push   %edx
  801086:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80108c:	83 c0 08             	add    $0x8,%eax
  80108f:	50                   	push   %eax
  801090:	e8 09 13 00 00       	call   80239e <sys_cputs>
  801095:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801098:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80109f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8010a5:	c9                   	leave  
  8010a6:	c3                   	ret    

008010a7 <cprintf>:

int cprintf(const char *fmt, ...) {
  8010a7:	55                   	push   %ebp
  8010a8:	89 e5                	mov    %esp,%ebp
  8010aa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8010ad:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  8010b4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8010b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8010ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bd:	83 ec 08             	sub    $0x8,%esp
  8010c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8010c3:	50                   	push   %eax
  8010c4:	e8 73 ff ff ff       	call   80103c <vcprintf>
  8010c9:	83 c4 10             	add    $0x10,%esp
  8010cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8010cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010d2:	c9                   	leave  
  8010d3:	c3                   	ret    

008010d4 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8010d4:	55                   	push   %ebp
  8010d5:	89 e5                	mov    %esp,%ebp
  8010d7:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8010da:	e8 6d 14 00 00       	call   80254c <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8010df:	8d 45 0c             	lea    0xc(%ebp),%eax
  8010e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8010e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e8:	83 ec 08             	sub    $0x8,%esp
  8010eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8010ee:	50                   	push   %eax
  8010ef:	e8 48 ff ff ff       	call   80103c <vcprintf>
  8010f4:	83 c4 10             	add    $0x10,%esp
  8010f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8010fa:	e8 67 14 00 00       	call   802566 <sys_enable_interrupt>
	return cnt;
  8010ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801102:	c9                   	leave  
  801103:	c3                   	ret    

00801104 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801104:	55                   	push   %ebp
  801105:	89 e5                	mov    %esp,%ebp
  801107:	53                   	push   %ebx
  801108:	83 ec 14             	sub    $0x14,%esp
  80110b:	8b 45 10             	mov    0x10(%ebp),%eax
  80110e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801111:	8b 45 14             	mov    0x14(%ebp),%eax
  801114:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801117:	8b 45 18             	mov    0x18(%ebp),%eax
  80111a:	ba 00 00 00 00       	mov    $0x0,%edx
  80111f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801122:	77 55                	ja     801179 <printnum+0x75>
  801124:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801127:	72 05                	jb     80112e <printnum+0x2a>
  801129:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80112c:	77 4b                	ja     801179 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80112e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801131:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801134:	8b 45 18             	mov    0x18(%ebp),%eax
  801137:	ba 00 00 00 00       	mov    $0x0,%edx
  80113c:	52                   	push   %edx
  80113d:	50                   	push   %eax
  80113e:	ff 75 f4             	pushl  -0xc(%ebp)
  801141:	ff 75 f0             	pushl  -0x10(%ebp)
  801144:	e8 cf 29 00 00       	call   803b18 <__udivdi3>
  801149:	83 c4 10             	add    $0x10,%esp
  80114c:	83 ec 04             	sub    $0x4,%esp
  80114f:	ff 75 20             	pushl  0x20(%ebp)
  801152:	53                   	push   %ebx
  801153:	ff 75 18             	pushl  0x18(%ebp)
  801156:	52                   	push   %edx
  801157:	50                   	push   %eax
  801158:	ff 75 0c             	pushl  0xc(%ebp)
  80115b:	ff 75 08             	pushl  0x8(%ebp)
  80115e:	e8 a1 ff ff ff       	call   801104 <printnum>
  801163:	83 c4 20             	add    $0x20,%esp
  801166:	eb 1a                	jmp    801182 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801168:	83 ec 08             	sub    $0x8,%esp
  80116b:	ff 75 0c             	pushl  0xc(%ebp)
  80116e:	ff 75 20             	pushl  0x20(%ebp)
  801171:	8b 45 08             	mov    0x8(%ebp),%eax
  801174:	ff d0                	call   *%eax
  801176:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801179:	ff 4d 1c             	decl   0x1c(%ebp)
  80117c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801180:	7f e6                	jg     801168 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801182:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801185:	bb 00 00 00 00       	mov    $0x0,%ebx
  80118a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80118d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801190:	53                   	push   %ebx
  801191:	51                   	push   %ecx
  801192:	52                   	push   %edx
  801193:	50                   	push   %eax
  801194:	e8 8f 2a 00 00       	call   803c28 <__umoddi3>
  801199:	83 c4 10             	add    $0x10,%esp
  80119c:	05 d4 43 80 00       	add    $0x8043d4,%eax
  8011a1:	8a 00                	mov    (%eax),%al
  8011a3:	0f be c0             	movsbl %al,%eax
  8011a6:	83 ec 08             	sub    $0x8,%esp
  8011a9:	ff 75 0c             	pushl  0xc(%ebp)
  8011ac:	50                   	push   %eax
  8011ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b0:	ff d0                	call   *%eax
  8011b2:	83 c4 10             	add    $0x10,%esp
}
  8011b5:	90                   	nop
  8011b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011b9:	c9                   	leave  
  8011ba:	c3                   	ret    

008011bb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8011bb:	55                   	push   %ebp
  8011bc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8011be:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8011c2:	7e 1c                	jle    8011e0 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c7:	8b 00                	mov    (%eax),%eax
  8011c9:	8d 50 08             	lea    0x8(%eax),%edx
  8011cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cf:	89 10                	mov    %edx,(%eax)
  8011d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d4:	8b 00                	mov    (%eax),%eax
  8011d6:	83 e8 08             	sub    $0x8,%eax
  8011d9:	8b 50 04             	mov    0x4(%eax),%edx
  8011dc:	8b 00                	mov    (%eax),%eax
  8011de:	eb 40                	jmp    801220 <getuint+0x65>
	else if (lflag)
  8011e0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011e4:	74 1e                	je     801204 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8011e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e9:	8b 00                	mov    (%eax),%eax
  8011eb:	8d 50 04             	lea    0x4(%eax),%edx
  8011ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f1:	89 10                	mov    %edx,(%eax)
  8011f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f6:	8b 00                	mov    (%eax),%eax
  8011f8:	83 e8 04             	sub    $0x4,%eax
  8011fb:	8b 00                	mov    (%eax),%eax
  8011fd:	ba 00 00 00 00       	mov    $0x0,%edx
  801202:	eb 1c                	jmp    801220 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801204:	8b 45 08             	mov    0x8(%ebp),%eax
  801207:	8b 00                	mov    (%eax),%eax
  801209:	8d 50 04             	lea    0x4(%eax),%edx
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	89 10                	mov    %edx,(%eax)
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	8b 00                	mov    (%eax),%eax
  801216:	83 e8 04             	sub    $0x4,%eax
  801219:	8b 00                	mov    (%eax),%eax
  80121b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801220:	5d                   	pop    %ebp
  801221:	c3                   	ret    

00801222 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801222:	55                   	push   %ebp
  801223:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801225:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801229:	7e 1c                	jle    801247 <getint+0x25>
		return va_arg(*ap, long long);
  80122b:	8b 45 08             	mov    0x8(%ebp),%eax
  80122e:	8b 00                	mov    (%eax),%eax
  801230:	8d 50 08             	lea    0x8(%eax),%edx
  801233:	8b 45 08             	mov    0x8(%ebp),%eax
  801236:	89 10                	mov    %edx,(%eax)
  801238:	8b 45 08             	mov    0x8(%ebp),%eax
  80123b:	8b 00                	mov    (%eax),%eax
  80123d:	83 e8 08             	sub    $0x8,%eax
  801240:	8b 50 04             	mov    0x4(%eax),%edx
  801243:	8b 00                	mov    (%eax),%eax
  801245:	eb 38                	jmp    80127f <getint+0x5d>
	else if (lflag)
  801247:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80124b:	74 1a                	je     801267 <getint+0x45>
		return va_arg(*ap, long);
  80124d:	8b 45 08             	mov    0x8(%ebp),%eax
  801250:	8b 00                	mov    (%eax),%eax
  801252:	8d 50 04             	lea    0x4(%eax),%edx
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	89 10                	mov    %edx,(%eax)
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
  80125d:	8b 00                	mov    (%eax),%eax
  80125f:	83 e8 04             	sub    $0x4,%eax
  801262:	8b 00                	mov    (%eax),%eax
  801264:	99                   	cltd   
  801265:	eb 18                	jmp    80127f <getint+0x5d>
	else
		return va_arg(*ap, int);
  801267:	8b 45 08             	mov    0x8(%ebp),%eax
  80126a:	8b 00                	mov    (%eax),%eax
  80126c:	8d 50 04             	lea    0x4(%eax),%edx
  80126f:	8b 45 08             	mov    0x8(%ebp),%eax
  801272:	89 10                	mov    %edx,(%eax)
  801274:	8b 45 08             	mov    0x8(%ebp),%eax
  801277:	8b 00                	mov    (%eax),%eax
  801279:	83 e8 04             	sub    $0x4,%eax
  80127c:	8b 00                	mov    (%eax),%eax
  80127e:	99                   	cltd   
}
  80127f:	5d                   	pop    %ebp
  801280:	c3                   	ret    

00801281 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801281:	55                   	push   %ebp
  801282:	89 e5                	mov    %esp,%ebp
  801284:	56                   	push   %esi
  801285:	53                   	push   %ebx
  801286:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801289:	eb 17                	jmp    8012a2 <vprintfmt+0x21>
			if (ch == '\0')
  80128b:	85 db                	test   %ebx,%ebx
  80128d:	0f 84 af 03 00 00    	je     801642 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801293:	83 ec 08             	sub    $0x8,%esp
  801296:	ff 75 0c             	pushl  0xc(%ebp)
  801299:	53                   	push   %ebx
  80129a:	8b 45 08             	mov    0x8(%ebp),%eax
  80129d:	ff d0                	call   *%eax
  80129f:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8012a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a5:	8d 50 01             	lea    0x1(%eax),%edx
  8012a8:	89 55 10             	mov    %edx,0x10(%ebp)
  8012ab:	8a 00                	mov    (%eax),%al
  8012ad:	0f b6 d8             	movzbl %al,%ebx
  8012b0:	83 fb 25             	cmp    $0x25,%ebx
  8012b3:	75 d6                	jne    80128b <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8012b5:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8012b9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8012c0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8012c7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8012ce:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8012d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d8:	8d 50 01             	lea    0x1(%eax),%edx
  8012db:	89 55 10             	mov    %edx,0x10(%ebp)
  8012de:	8a 00                	mov    (%eax),%al
  8012e0:	0f b6 d8             	movzbl %al,%ebx
  8012e3:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8012e6:	83 f8 55             	cmp    $0x55,%eax
  8012e9:	0f 87 2b 03 00 00    	ja     80161a <vprintfmt+0x399>
  8012ef:	8b 04 85 f8 43 80 00 	mov    0x8043f8(,%eax,4),%eax
  8012f6:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8012f8:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8012fc:	eb d7                	jmp    8012d5 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8012fe:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801302:	eb d1                	jmp    8012d5 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801304:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80130b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80130e:	89 d0                	mov    %edx,%eax
  801310:	c1 e0 02             	shl    $0x2,%eax
  801313:	01 d0                	add    %edx,%eax
  801315:	01 c0                	add    %eax,%eax
  801317:	01 d8                	add    %ebx,%eax
  801319:	83 e8 30             	sub    $0x30,%eax
  80131c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80131f:	8b 45 10             	mov    0x10(%ebp),%eax
  801322:	8a 00                	mov    (%eax),%al
  801324:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801327:	83 fb 2f             	cmp    $0x2f,%ebx
  80132a:	7e 3e                	jle    80136a <vprintfmt+0xe9>
  80132c:	83 fb 39             	cmp    $0x39,%ebx
  80132f:	7f 39                	jg     80136a <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801331:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801334:	eb d5                	jmp    80130b <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801336:	8b 45 14             	mov    0x14(%ebp),%eax
  801339:	83 c0 04             	add    $0x4,%eax
  80133c:	89 45 14             	mov    %eax,0x14(%ebp)
  80133f:	8b 45 14             	mov    0x14(%ebp),%eax
  801342:	83 e8 04             	sub    $0x4,%eax
  801345:	8b 00                	mov    (%eax),%eax
  801347:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80134a:	eb 1f                	jmp    80136b <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80134c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801350:	79 83                	jns    8012d5 <vprintfmt+0x54>
				width = 0;
  801352:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801359:	e9 77 ff ff ff       	jmp    8012d5 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80135e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801365:	e9 6b ff ff ff       	jmp    8012d5 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80136a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80136b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80136f:	0f 89 60 ff ff ff    	jns    8012d5 <vprintfmt+0x54>
				width = precision, precision = -1;
  801375:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801378:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80137b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801382:	e9 4e ff ff ff       	jmp    8012d5 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801387:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80138a:	e9 46 ff ff ff       	jmp    8012d5 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80138f:	8b 45 14             	mov    0x14(%ebp),%eax
  801392:	83 c0 04             	add    $0x4,%eax
  801395:	89 45 14             	mov    %eax,0x14(%ebp)
  801398:	8b 45 14             	mov    0x14(%ebp),%eax
  80139b:	83 e8 04             	sub    $0x4,%eax
  80139e:	8b 00                	mov    (%eax),%eax
  8013a0:	83 ec 08             	sub    $0x8,%esp
  8013a3:	ff 75 0c             	pushl  0xc(%ebp)
  8013a6:	50                   	push   %eax
  8013a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013aa:	ff d0                	call   *%eax
  8013ac:	83 c4 10             	add    $0x10,%esp
			break;
  8013af:	e9 89 02 00 00       	jmp    80163d <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8013b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8013b7:	83 c0 04             	add    $0x4,%eax
  8013ba:	89 45 14             	mov    %eax,0x14(%ebp)
  8013bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c0:	83 e8 04             	sub    $0x4,%eax
  8013c3:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8013c5:	85 db                	test   %ebx,%ebx
  8013c7:	79 02                	jns    8013cb <vprintfmt+0x14a>
				err = -err;
  8013c9:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8013cb:	83 fb 64             	cmp    $0x64,%ebx
  8013ce:	7f 0b                	jg     8013db <vprintfmt+0x15a>
  8013d0:	8b 34 9d 40 42 80 00 	mov    0x804240(,%ebx,4),%esi
  8013d7:	85 f6                	test   %esi,%esi
  8013d9:	75 19                	jne    8013f4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8013db:	53                   	push   %ebx
  8013dc:	68 e5 43 80 00       	push   $0x8043e5
  8013e1:	ff 75 0c             	pushl  0xc(%ebp)
  8013e4:	ff 75 08             	pushl  0x8(%ebp)
  8013e7:	e8 5e 02 00 00       	call   80164a <printfmt>
  8013ec:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8013ef:	e9 49 02 00 00       	jmp    80163d <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8013f4:	56                   	push   %esi
  8013f5:	68 ee 43 80 00       	push   $0x8043ee
  8013fa:	ff 75 0c             	pushl  0xc(%ebp)
  8013fd:	ff 75 08             	pushl  0x8(%ebp)
  801400:	e8 45 02 00 00       	call   80164a <printfmt>
  801405:	83 c4 10             	add    $0x10,%esp
			break;
  801408:	e9 30 02 00 00       	jmp    80163d <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80140d:	8b 45 14             	mov    0x14(%ebp),%eax
  801410:	83 c0 04             	add    $0x4,%eax
  801413:	89 45 14             	mov    %eax,0x14(%ebp)
  801416:	8b 45 14             	mov    0x14(%ebp),%eax
  801419:	83 e8 04             	sub    $0x4,%eax
  80141c:	8b 30                	mov    (%eax),%esi
  80141e:	85 f6                	test   %esi,%esi
  801420:	75 05                	jne    801427 <vprintfmt+0x1a6>
				p = "(null)";
  801422:	be f1 43 80 00       	mov    $0x8043f1,%esi
			if (width > 0 && padc != '-')
  801427:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80142b:	7e 6d                	jle    80149a <vprintfmt+0x219>
  80142d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801431:	74 67                	je     80149a <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801433:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801436:	83 ec 08             	sub    $0x8,%esp
  801439:	50                   	push   %eax
  80143a:	56                   	push   %esi
  80143b:	e8 0c 03 00 00       	call   80174c <strnlen>
  801440:	83 c4 10             	add    $0x10,%esp
  801443:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801446:	eb 16                	jmp    80145e <vprintfmt+0x1dd>
					putch(padc, putdat);
  801448:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80144c:	83 ec 08             	sub    $0x8,%esp
  80144f:	ff 75 0c             	pushl  0xc(%ebp)
  801452:	50                   	push   %eax
  801453:	8b 45 08             	mov    0x8(%ebp),%eax
  801456:	ff d0                	call   *%eax
  801458:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80145b:	ff 4d e4             	decl   -0x1c(%ebp)
  80145e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801462:	7f e4                	jg     801448 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801464:	eb 34                	jmp    80149a <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801466:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80146a:	74 1c                	je     801488 <vprintfmt+0x207>
  80146c:	83 fb 1f             	cmp    $0x1f,%ebx
  80146f:	7e 05                	jle    801476 <vprintfmt+0x1f5>
  801471:	83 fb 7e             	cmp    $0x7e,%ebx
  801474:	7e 12                	jle    801488 <vprintfmt+0x207>
					putch('?', putdat);
  801476:	83 ec 08             	sub    $0x8,%esp
  801479:	ff 75 0c             	pushl  0xc(%ebp)
  80147c:	6a 3f                	push   $0x3f
  80147e:	8b 45 08             	mov    0x8(%ebp),%eax
  801481:	ff d0                	call   *%eax
  801483:	83 c4 10             	add    $0x10,%esp
  801486:	eb 0f                	jmp    801497 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801488:	83 ec 08             	sub    $0x8,%esp
  80148b:	ff 75 0c             	pushl  0xc(%ebp)
  80148e:	53                   	push   %ebx
  80148f:	8b 45 08             	mov    0x8(%ebp),%eax
  801492:	ff d0                	call   *%eax
  801494:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801497:	ff 4d e4             	decl   -0x1c(%ebp)
  80149a:	89 f0                	mov    %esi,%eax
  80149c:	8d 70 01             	lea    0x1(%eax),%esi
  80149f:	8a 00                	mov    (%eax),%al
  8014a1:	0f be d8             	movsbl %al,%ebx
  8014a4:	85 db                	test   %ebx,%ebx
  8014a6:	74 24                	je     8014cc <vprintfmt+0x24b>
  8014a8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014ac:	78 b8                	js     801466 <vprintfmt+0x1e5>
  8014ae:	ff 4d e0             	decl   -0x20(%ebp)
  8014b1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014b5:	79 af                	jns    801466 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8014b7:	eb 13                	jmp    8014cc <vprintfmt+0x24b>
				putch(' ', putdat);
  8014b9:	83 ec 08             	sub    $0x8,%esp
  8014bc:	ff 75 0c             	pushl  0xc(%ebp)
  8014bf:	6a 20                	push   $0x20
  8014c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c4:	ff d0                	call   *%eax
  8014c6:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8014c9:	ff 4d e4             	decl   -0x1c(%ebp)
  8014cc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014d0:	7f e7                	jg     8014b9 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8014d2:	e9 66 01 00 00       	jmp    80163d <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8014d7:	83 ec 08             	sub    $0x8,%esp
  8014da:	ff 75 e8             	pushl  -0x18(%ebp)
  8014dd:	8d 45 14             	lea    0x14(%ebp),%eax
  8014e0:	50                   	push   %eax
  8014e1:	e8 3c fd ff ff       	call   801222 <getint>
  8014e6:	83 c4 10             	add    $0x10,%esp
  8014e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014ec:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8014ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014f5:	85 d2                	test   %edx,%edx
  8014f7:	79 23                	jns    80151c <vprintfmt+0x29b>
				putch('-', putdat);
  8014f9:	83 ec 08             	sub    $0x8,%esp
  8014fc:	ff 75 0c             	pushl  0xc(%ebp)
  8014ff:	6a 2d                	push   $0x2d
  801501:	8b 45 08             	mov    0x8(%ebp),%eax
  801504:	ff d0                	call   *%eax
  801506:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801509:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80150c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80150f:	f7 d8                	neg    %eax
  801511:	83 d2 00             	adc    $0x0,%edx
  801514:	f7 da                	neg    %edx
  801516:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801519:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80151c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801523:	e9 bc 00 00 00       	jmp    8015e4 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801528:	83 ec 08             	sub    $0x8,%esp
  80152b:	ff 75 e8             	pushl  -0x18(%ebp)
  80152e:	8d 45 14             	lea    0x14(%ebp),%eax
  801531:	50                   	push   %eax
  801532:	e8 84 fc ff ff       	call   8011bb <getuint>
  801537:	83 c4 10             	add    $0x10,%esp
  80153a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80153d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801540:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801547:	e9 98 00 00 00       	jmp    8015e4 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80154c:	83 ec 08             	sub    $0x8,%esp
  80154f:	ff 75 0c             	pushl  0xc(%ebp)
  801552:	6a 58                	push   $0x58
  801554:	8b 45 08             	mov    0x8(%ebp),%eax
  801557:	ff d0                	call   *%eax
  801559:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80155c:	83 ec 08             	sub    $0x8,%esp
  80155f:	ff 75 0c             	pushl  0xc(%ebp)
  801562:	6a 58                	push   $0x58
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
  801567:	ff d0                	call   *%eax
  801569:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80156c:	83 ec 08             	sub    $0x8,%esp
  80156f:	ff 75 0c             	pushl  0xc(%ebp)
  801572:	6a 58                	push   $0x58
  801574:	8b 45 08             	mov    0x8(%ebp),%eax
  801577:	ff d0                	call   *%eax
  801579:	83 c4 10             	add    $0x10,%esp
			break;
  80157c:	e9 bc 00 00 00       	jmp    80163d <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801581:	83 ec 08             	sub    $0x8,%esp
  801584:	ff 75 0c             	pushl  0xc(%ebp)
  801587:	6a 30                	push   $0x30
  801589:	8b 45 08             	mov    0x8(%ebp),%eax
  80158c:	ff d0                	call   *%eax
  80158e:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801591:	83 ec 08             	sub    $0x8,%esp
  801594:	ff 75 0c             	pushl  0xc(%ebp)
  801597:	6a 78                	push   $0x78
  801599:	8b 45 08             	mov    0x8(%ebp),%eax
  80159c:	ff d0                	call   *%eax
  80159e:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8015a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8015a4:	83 c0 04             	add    $0x4,%eax
  8015a7:	89 45 14             	mov    %eax,0x14(%ebp)
  8015aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ad:	83 e8 04             	sub    $0x4,%eax
  8015b0:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8015b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8015bc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8015c3:	eb 1f                	jmp    8015e4 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8015c5:	83 ec 08             	sub    $0x8,%esp
  8015c8:	ff 75 e8             	pushl  -0x18(%ebp)
  8015cb:	8d 45 14             	lea    0x14(%ebp),%eax
  8015ce:	50                   	push   %eax
  8015cf:	e8 e7 fb ff ff       	call   8011bb <getuint>
  8015d4:	83 c4 10             	add    $0x10,%esp
  8015d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015da:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8015dd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8015e4:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8015e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015eb:	83 ec 04             	sub    $0x4,%esp
  8015ee:	52                   	push   %edx
  8015ef:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015f2:	50                   	push   %eax
  8015f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8015f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8015f9:	ff 75 0c             	pushl  0xc(%ebp)
  8015fc:	ff 75 08             	pushl  0x8(%ebp)
  8015ff:	e8 00 fb ff ff       	call   801104 <printnum>
  801604:	83 c4 20             	add    $0x20,%esp
			break;
  801607:	eb 34                	jmp    80163d <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801609:	83 ec 08             	sub    $0x8,%esp
  80160c:	ff 75 0c             	pushl  0xc(%ebp)
  80160f:	53                   	push   %ebx
  801610:	8b 45 08             	mov    0x8(%ebp),%eax
  801613:	ff d0                	call   *%eax
  801615:	83 c4 10             	add    $0x10,%esp
			break;
  801618:	eb 23                	jmp    80163d <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80161a:	83 ec 08             	sub    $0x8,%esp
  80161d:	ff 75 0c             	pushl  0xc(%ebp)
  801620:	6a 25                	push   $0x25
  801622:	8b 45 08             	mov    0x8(%ebp),%eax
  801625:	ff d0                	call   *%eax
  801627:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80162a:	ff 4d 10             	decl   0x10(%ebp)
  80162d:	eb 03                	jmp    801632 <vprintfmt+0x3b1>
  80162f:	ff 4d 10             	decl   0x10(%ebp)
  801632:	8b 45 10             	mov    0x10(%ebp),%eax
  801635:	48                   	dec    %eax
  801636:	8a 00                	mov    (%eax),%al
  801638:	3c 25                	cmp    $0x25,%al
  80163a:	75 f3                	jne    80162f <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80163c:	90                   	nop
		}
	}
  80163d:	e9 47 fc ff ff       	jmp    801289 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801642:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801643:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801646:	5b                   	pop    %ebx
  801647:	5e                   	pop    %esi
  801648:	5d                   	pop    %ebp
  801649:	c3                   	ret    

0080164a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80164a:	55                   	push   %ebp
  80164b:	89 e5                	mov    %esp,%ebp
  80164d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801650:	8d 45 10             	lea    0x10(%ebp),%eax
  801653:	83 c0 04             	add    $0x4,%eax
  801656:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801659:	8b 45 10             	mov    0x10(%ebp),%eax
  80165c:	ff 75 f4             	pushl  -0xc(%ebp)
  80165f:	50                   	push   %eax
  801660:	ff 75 0c             	pushl  0xc(%ebp)
  801663:	ff 75 08             	pushl  0x8(%ebp)
  801666:	e8 16 fc ff ff       	call   801281 <vprintfmt>
  80166b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80166e:	90                   	nop
  80166f:	c9                   	leave  
  801670:	c3                   	ret    

00801671 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801671:	55                   	push   %ebp
  801672:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801674:	8b 45 0c             	mov    0xc(%ebp),%eax
  801677:	8b 40 08             	mov    0x8(%eax),%eax
  80167a:	8d 50 01             	lea    0x1(%eax),%edx
  80167d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801680:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801683:	8b 45 0c             	mov    0xc(%ebp),%eax
  801686:	8b 10                	mov    (%eax),%edx
  801688:	8b 45 0c             	mov    0xc(%ebp),%eax
  80168b:	8b 40 04             	mov    0x4(%eax),%eax
  80168e:	39 c2                	cmp    %eax,%edx
  801690:	73 12                	jae    8016a4 <sprintputch+0x33>
		*b->buf++ = ch;
  801692:	8b 45 0c             	mov    0xc(%ebp),%eax
  801695:	8b 00                	mov    (%eax),%eax
  801697:	8d 48 01             	lea    0x1(%eax),%ecx
  80169a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169d:	89 0a                	mov    %ecx,(%edx)
  80169f:	8b 55 08             	mov    0x8(%ebp),%edx
  8016a2:	88 10                	mov    %dl,(%eax)
}
  8016a4:	90                   	nop
  8016a5:	5d                   	pop    %ebp
  8016a6:	c3                   	ret    

008016a7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8016a7:	55                   	push   %ebp
  8016a8:	89 e5                	mov    %esp,%ebp
  8016aa:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8016ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bc:	01 d0                	add    %edx,%eax
  8016be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8016c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016cc:	74 06                	je     8016d4 <vsnprintf+0x2d>
  8016ce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016d2:	7f 07                	jg     8016db <vsnprintf+0x34>
		return -E_INVAL;
  8016d4:	b8 03 00 00 00       	mov    $0x3,%eax
  8016d9:	eb 20                	jmp    8016fb <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8016db:	ff 75 14             	pushl  0x14(%ebp)
  8016de:	ff 75 10             	pushl  0x10(%ebp)
  8016e1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8016e4:	50                   	push   %eax
  8016e5:	68 71 16 80 00       	push   $0x801671
  8016ea:	e8 92 fb ff ff       	call   801281 <vprintfmt>
  8016ef:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8016f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016f5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8016f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8016fb:	c9                   	leave  
  8016fc:	c3                   	ret    

008016fd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8016fd:	55                   	push   %ebp
  8016fe:	89 e5                	mov    %esp,%ebp
  801700:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801703:	8d 45 10             	lea    0x10(%ebp),%eax
  801706:	83 c0 04             	add    $0x4,%eax
  801709:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80170c:	8b 45 10             	mov    0x10(%ebp),%eax
  80170f:	ff 75 f4             	pushl  -0xc(%ebp)
  801712:	50                   	push   %eax
  801713:	ff 75 0c             	pushl  0xc(%ebp)
  801716:	ff 75 08             	pushl  0x8(%ebp)
  801719:	e8 89 ff ff ff       	call   8016a7 <vsnprintf>
  80171e:	83 c4 10             	add    $0x10,%esp
  801721:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801724:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801727:	c9                   	leave  
  801728:	c3                   	ret    

00801729 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
  80172c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80172f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801736:	eb 06                	jmp    80173e <strlen+0x15>
		n++;
  801738:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80173b:	ff 45 08             	incl   0x8(%ebp)
  80173e:	8b 45 08             	mov    0x8(%ebp),%eax
  801741:	8a 00                	mov    (%eax),%al
  801743:	84 c0                	test   %al,%al
  801745:	75 f1                	jne    801738 <strlen+0xf>
		n++;
	return n;
  801747:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80174a:	c9                   	leave  
  80174b:	c3                   	ret    

0080174c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80174c:	55                   	push   %ebp
  80174d:	89 e5                	mov    %esp,%ebp
  80174f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801752:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801759:	eb 09                	jmp    801764 <strnlen+0x18>
		n++;
  80175b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80175e:	ff 45 08             	incl   0x8(%ebp)
  801761:	ff 4d 0c             	decl   0xc(%ebp)
  801764:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801768:	74 09                	je     801773 <strnlen+0x27>
  80176a:	8b 45 08             	mov    0x8(%ebp),%eax
  80176d:	8a 00                	mov    (%eax),%al
  80176f:	84 c0                	test   %al,%al
  801771:	75 e8                	jne    80175b <strnlen+0xf>
		n++;
	return n;
  801773:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801776:	c9                   	leave  
  801777:	c3                   	ret    

00801778 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801778:	55                   	push   %ebp
  801779:	89 e5                	mov    %esp,%ebp
  80177b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80177e:	8b 45 08             	mov    0x8(%ebp),%eax
  801781:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801784:	90                   	nop
  801785:	8b 45 08             	mov    0x8(%ebp),%eax
  801788:	8d 50 01             	lea    0x1(%eax),%edx
  80178b:	89 55 08             	mov    %edx,0x8(%ebp)
  80178e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801791:	8d 4a 01             	lea    0x1(%edx),%ecx
  801794:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801797:	8a 12                	mov    (%edx),%dl
  801799:	88 10                	mov    %dl,(%eax)
  80179b:	8a 00                	mov    (%eax),%al
  80179d:	84 c0                	test   %al,%al
  80179f:	75 e4                	jne    801785 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8017a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8017a4:	c9                   	leave  
  8017a5:	c3                   	ret    

008017a6 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8017a6:	55                   	push   %ebp
  8017a7:	89 e5                	mov    %esp,%ebp
  8017a9:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8017b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8017b9:	eb 1f                	jmp    8017da <strncpy+0x34>
		*dst++ = *src;
  8017bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017be:	8d 50 01             	lea    0x1(%eax),%edx
  8017c1:	89 55 08             	mov    %edx,0x8(%ebp)
  8017c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c7:	8a 12                	mov    (%edx),%dl
  8017c9:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8017cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ce:	8a 00                	mov    (%eax),%al
  8017d0:	84 c0                	test   %al,%al
  8017d2:	74 03                	je     8017d7 <strncpy+0x31>
			src++;
  8017d4:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8017d7:	ff 45 fc             	incl   -0x4(%ebp)
  8017da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017dd:	3b 45 10             	cmp    0x10(%ebp),%eax
  8017e0:	72 d9                	jb     8017bb <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8017e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8017e5:	c9                   	leave  
  8017e6:	c3                   	ret    

008017e7 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8017e7:	55                   	push   %ebp
  8017e8:	89 e5                	mov    %esp,%ebp
  8017ea:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8017ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8017f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017f7:	74 30                	je     801829 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8017f9:	eb 16                	jmp    801811 <strlcpy+0x2a>
			*dst++ = *src++;
  8017fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fe:	8d 50 01             	lea    0x1(%eax),%edx
  801801:	89 55 08             	mov    %edx,0x8(%ebp)
  801804:	8b 55 0c             	mov    0xc(%ebp),%edx
  801807:	8d 4a 01             	lea    0x1(%edx),%ecx
  80180a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80180d:	8a 12                	mov    (%edx),%dl
  80180f:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801811:	ff 4d 10             	decl   0x10(%ebp)
  801814:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801818:	74 09                	je     801823 <strlcpy+0x3c>
  80181a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80181d:	8a 00                	mov    (%eax),%al
  80181f:	84 c0                	test   %al,%al
  801821:	75 d8                	jne    8017fb <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801823:	8b 45 08             	mov    0x8(%ebp),%eax
  801826:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801829:	8b 55 08             	mov    0x8(%ebp),%edx
  80182c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80182f:	29 c2                	sub    %eax,%edx
  801831:	89 d0                	mov    %edx,%eax
}
  801833:	c9                   	leave  
  801834:	c3                   	ret    

00801835 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801838:	eb 06                	jmp    801840 <strcmp+0xb>
		p++, q++;
  80183a:	ff 45 08             	incl   0x8(%ebp)
  80183d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801840:	8b 45 08             	mov    0x8(%ebp),%eax
  801843:	8a 00                	mov    (%eax),%al
  801845:	84 c0                	test   %al,%al
  801847:	74 0e                	je     801857 <strcmp+0x22>
  801849:	8b 45 08             	mov    0x8(%ebp),%eax
  80184c:	8a 10                	mov    (%eax),%dl
  80184e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801851:	8a 00                	mov    (%eax),%al
  801853:	38 c2                	cmp    %al,%dl
  801855:	74 e3                	je     80183a <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801857:	8b 45 08             	mov    0x8(%ebp),%eax
  80185a:	8a 00                	mov    (%eax),%al
  80185c:	0f b6 d0             	movzbl %al,%edx
  80185f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801862:	8a 00                	mov    (%eax),%al
  801864:	0f b6 c0             	movzbl %al,%eax
  801867:	29 c2                	sub    %eax,%edx
  801869:	89 d0                	mov    %edx,%eax
}
  80186b:	5d                   	pop    %ebp
  80186c:	c3                   	ret    

0080186d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801870:	eb 09                	jmp    80187b <strncmp+0xe>
		n--, p++, q++;
  801872:	ff 4d 10             	decl   0x10(%ebp)
  801875:	ff 45 08             	incl   0x8(%ebp)
  801878:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80187b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80187f:	74 17                	je     801898 <strncmp+0x2b>
  801881:	8b 45 08             	mov    0x8(%ebp),%eax
  801884:	8a 00                	mov    (%eax),%al
  801886:	84 c0                	test   %al,%al
  801888:	74 0e                	je     801898 <strncmp+0x2b>
  80188a:	8b 45 08             	mov    0x8(%ebp),%eax
  80188d:	8a 10                	mov    (%eax),%dl
  80188f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801892:	8a 00                	mov    (%eax),%al
  801894:	38 c2                	cmp    %al,%dl
  801896:	74 da                	je     801872 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801898:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80189c:	75 07                	jne    8018a5 <strncmp+0x38>
		return 0;
  80189e:	b8 00 00 00 00       	mov    $0x0,%eax
  8018a3:	eb 14                	jmp    8018b9 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8018a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a8:	8a 00                	mov    (%eax),%al
  8018aa:	0f b6 d0             	movzbl %al,%edx
  8018ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b0:	8a 00                	mov    (%eax),%al
  8018b2:	0f b6 c0             	movzbl %al,%eax
  8018b5:	29 c2                	sub    %eax,%edx
  8018b7:	89 d0                	mov    %edx,%eax
}
  8018b9:	5d                   	pop    %ebp
  8018ba:	c3                   	ret    

008018bb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
  8018be:	83 ec 04             	sub    $0x4,%esp
  8018c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8018c7:	eb 12                	jmp    8018db <strchr+0x20>
		if (*s == c)
  8018c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cc:	8a 00                	mov    (%eax),%al
  8018ce:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8018d1:	75 05                	jne    8018d8 <strchr+0x1d>
			return (char *) s;
  8018d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d6:	eb 11                	jmp    8018e9 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8018d8:	ff 45 08             	incl   0x8(%ebp)
  8018db:	8b 45 08             	mov    0x8(%ebp),%eax
  8018de:	8a 00                	mov    (%eax),%al
  8018e0:	84 c0                	test   %al,%al
  8018e2:	75 e5                	jne    8018c9 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8018e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018e9:	c9                   	leave  
  8018ea:	c3                   	ret    

008018eb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
  8018ee:	83 ec 04             	sub    $0x4,%esp
  8018f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8018f7:	eb 0d                	jmp    801906 <strfind+0x1b>
		if (*s == c)
  8018f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fc:	8a 00                	mov    (%eax),%al
  8018fe:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801901:	74 0e                	je     801911 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801903:	ff 45 08             	incl   0x8(%ebp)
  801906:	8b 45 08             	mov    0x8(%ebp),%eax
  801909:	8a 00                	mov    (%eax),%al
  80190b:	84 c0                	test   %al,%al
  80190d:	75 ea                	jne    8018f9 <strfind+0xe>
  80190f:	eb 01                	jmp    801912 <strfind+0x27>
		if (*s == c)
			break;
  801911:	90                   	nop
	return (char *) s;
  801912:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801915:	c9                   	leave  
  801916:	c3                   	ret    

00801917 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801917:	55                   	push   %ebp
  801918:	89 e5                	mov    %esp,%ebp
  80191a:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80191d:	8b 45 08             	mov    0x8(%ebp),%eax
  801920:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801923:	8b 45 10             	mov    0x10(%ebp),%eax
  801926:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801929:	eb 0e                	jmp    801939 <memset+0x22>
		*p++ = c;
  80192b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80192e:	8d 50 01             	lea    0x1(%eax),%edx
  801931:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801934:	8b 55 0c             	mov    0xc(%ebp),%edx
  801937:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801939:	ff 4d f8             	decl   -0x8(%ebp)
  80193c:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801940:	79 e9                	jns    80192b <memset+0x14>
		*p++ = c;

	return v;
  801942:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801945:	c9                   	leave  
  801946:	c3                   	ret    

00801947 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
  80194a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80194d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801950:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801953:	8b 45 08             	mov    0x8(%ebp),%eax
  801956:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801959:	eb 16                	jmp    801971 <memcpy+0x2a>
		*d++ = *s++;
  80195b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80195e:	8d 50 01             	lea    0x1(%eax),%edx
  801961:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801964:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801967:	8d 4a 01             	lea    0x1(%edx),%ecx
  80196a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80196d:	8a 12                	mov    (%edx),%dl
  80196f:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801971:	8b 45 10             	mov    0x10(%ebp),%eax
  801974:	8d 50 ff             	lea    -0x1(%eax),%edx
  801977:	89 55 10             	mov    %edx,0x10(%ebp)
  80197a:	85 c0                	test   %eax,%eax
  80197c:	75 dd                	jne    80195b <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80197e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801981:	c9                   	leave  
  801982:	c3                   	ret    

00801983 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
  801986:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801989:	8b 45 0c             	mov    0xc(%ebp),%eax
  80198c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80198f:	8b 45 08             	mov    0x8(%ebp),%eax
  801992:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801995:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801998:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80199b:	73 50                	jae    8019ed <memmove+0x6a>
  80199d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a3:	01 d0                	add    %edx,%eax
  8019a5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8019a8:	76 43                	jbe    8019ed <memmove+0x6a>
		s += n;
  8019aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ad:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8019b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8019b3:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8019b6:	eb 10                	jmp    8019c8 <memmove+0x45>
			*--d = *--s;
  8019b8:	ff 4d f8             	decl   -0x8(%ebp)
  8019bb:	ff 4d fc             	decl   -0x4(%ebp)
  8019be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019c1:	8a 10                	mov    (%eax),%dl
  8019c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019c6:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8019c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8019cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8019ce:	89 55 10             	mov    %edx,0x10(%ebp)
  8019d1:	85 c0                	test   %eax,%eax
  8019d3:	75 e3                	jne    8019b8 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8019d5:	eb 23                	jmp    8019fa <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8019d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019da:	8d 50 01             	lea    0x1(%eax),%edx
  8019dd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8019e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019e3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8019e6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8019e9:	8a 12                	mov    (%edx),%dl
  8019eb:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8019ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8019f3:	89 55 10             	mov    %edx,0x10(%ebp)
  8019f6:	85 c0                	test   %eax,%eax
  8019f8:	75 dd                	jne    8019d7 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8019fa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8019fd:	c9                   	leave  
  8019fe:	c3                   	ret    

008019ff <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
  801a02:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801a05:	8b 45 08             	mov    0x8(%ebp),%eax
  801a08:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801a0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a0e:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801a11:	eb 2a                	jmp    801a3d <memcmp+0x3e>
		if (*s1 != *s2)
  801a13:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a16:	8a 10                	mov    (%eax),%dl
  801a18:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a1b:	8a 00                	mov    (%eax),%al
  801a1d:	38 c2                	cmp    %al,%dl
  801a1f:	74 16                	je     801a37 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801a21:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a24:	8a 00                	mov    (%eax),%al
  801a26:	0f b6 d0             	movzbl %al,%edx
  801a29:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a2c:	8a 00                	mov    (%eax),%al
  801a2e:	0f b6 c0             	movzbl %al,%eax
  801a31:	29 c2                	sub    %eax,%edx
  801a33:	89 d0                	mov    %edx,%eax
  801a35:	eb 18                	jmp    801a4f <memcmp+0x50>
		s1++, s2++;
  801a37:	ff 45 fc             	incl   -0x4(%ebp)
  801a3a:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801a3d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a40:	8d 50 ff             	lea    -0x1(%eax),%edx
  801a43:	89 55 10             	mov    %edx,0x10(%ebp)
  801a46:	85 c0                	test   %eax,%eax
  801a48:	75 c9                	jne    801a13 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801a4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a4f:	c9                   	leave  
  801a50:	c3                   	ret    

00801a51 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
  801a54:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801a57:	8b 55 08             	mov    0x8(%ebp),%edx
  801a5a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a5d:	01 d0                	add    %edx,%eax
  801a5f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801a62:	eb 15                	jmp    801a79 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801a64:	8b 45 08             	mov    0x8(%ebp),%eax
  801a67:	8a 00                	mov    (%eax),%al
  801a69:	0f b6 d0             	movzbl %al,%edx
  801a6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a6f:	0f b6 c0             	movzbl %al,%eax
  801a72:	39 c2                	cmp    %eax,%edx
  801a74:	74 0d                	je     801a83 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801a76:	ff 45 08             	incl   0x8(%ebp)
  801a79:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801a7f:	72 e3                	jb     801a64 <memfind+0x13>
  801a81:	eb 01                	jmp    801a84 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801a83:	90                   	nop
	return (void *) s;
  801a84:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801a87:	c9                   	leave  
  801a88:	c3                   	ret    

00801a89 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
  801a8c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801a8f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801a96:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a9d:	eb 03                	jmp    801aa2 <strtol+0x19>
		s++;
  801a9f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa5:	8a 00                	mov    (%eax),%al
  801aa7:	3c 20                	cmp    $0x20,%al
  801aa9:	74 f4                	je     801a9f <strtol+0x16>
  801aab:	8b 45 08             	mov    0x8(%ebp),%eax
  801aae:	8a 00                	mov    (%eax),%al
  801ab0:	3c 09                	cmp    $0x9,%al
  801ab2:	74 eb                	je     801a9f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab7:	8a 00                	mov    (%eax),%al
  801ab9:	3c 2b                	cmp    $0x2b,%al
  801abb:	75 05                	jne    801ac2 <strtol+0x39>
		s++;
  801abd:	ff 45 08             	incl   0x8(%ebp)
  801ac0:	eb 13                	jmp    801ad5 <strtol+0x4c>
	else if (*s == '-')
  801ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac5:	8a 00                	mov    (%eax),%al
  801ac7:	3c 2d                	cmp    $0x2d,%al
  801ac9:	75 0a                	jne    801ad5 <strtol+0x4c>
		s++, neg = 1;
  801acb:	ff 45 08             	incl   0x8(%ebp)
  801ace:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ad5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ad9:	74 06                	je     801ae1 <strtol+0x58>
  801adb:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801adf:	75 20                	jne    801b01 <strtol+0x78>
  801ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae4:	8a 00                	mov    (%eax),%al
  801ae6:	3c 30                	cmp    $0x30,%al
  801ae8:	75 17                	jne    801b01 <strtol+0x78>
  801aea:	8b 45 08             	mov    0x8(%ebp),%eax
  801aed:	40                   	inc    %eax
  801aee:	8a 00                	mov    (%eax),%al
  801af0:	3c 78                	cmp    $0x78,%al
  801af2:	75 0d                	jne    801b01 <strtol+0x78>
		s += 2, base = 16;
  801af4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801af8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801aff:	eb 28                	jmp    801b29 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801b01:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b05:	75 15                	jne    801b1c <strtol+0x93>
  801b07:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0a:	8a 00                	mov    (%eax),%al
  801b0c:	3c 30                	cmp    $0x30,%al
  801b0e:	75 0c                	jne    801b1c <strtol+0x93>
		s++, base = 8;
  801b10:	ff 45 08             	incl   0x8(%ebp)
  801b13:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801b1a:	eb 0d                	jmp    801b29 <strtol+0xa0>
	else if (base == 0)
  801b1c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b20:	75 07                	jne    801b29 <strtol+0xa0>
		base = 10;
  801b22:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801b29:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2c:	8a 00                	mov    (%eax),%al
  801b2e:	3c 2f                	cmp    $0x2f,%al
  801b30:	7e 19                	jle    801b4b <strtol+0xc2>
  801b32:	8b 45 08             	mov    0x8(%ebp),%eax
  801b35:	8a 00                	mov    (%eax),%al
  801b37:	3c 39                	cmp    $0x39,%al
  801b39:	7f 10                	jg     801b4b <strtol+0xc2>
			dig = *s - '0';
  801b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3e:	8a 00                	mov    (%eax),%al
  801b40:	0f be c0             	movsbl %al,%eax
  801b43:	83 e8 30             	sub    $0x30,%eax
  801b46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b49:	eb 42                	jmp    801b8d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4e:	8a 00                	mov    (%eax),%al
  801b50:	3c 60                	cmp    $0x60,%al
  801b52:	7e 19                	jle    801b6d <strtol+0xe4>
  801b54:	8b 45 08             	mov    0x8(%ebp),%eax
  801b57:	8a 00                	mov    (%eax),%al
  801b59:	3c 7a                	cmp    $0x7a,%al
  801b5b:	7f 10                	jg     801b6d <strtol+0xe4>
			dig = *s - 'a' + 10;
  801b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b60:	8a 00                	mov    (%eax),%al
  801b62:	0f be c0             	movsbl %al,%eax
  801b65:	83 e8 57             	sub    $0x57,%eax
  801b68:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b6b:	eb 20                	jmp    801b8d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b70:	8a 00                	mov    (%eax),%al
  801b72:	3c 40                	cmp    $0x40,%al
  801b74:	7e 39                	jle    801baf <strtol+0x126>
  801b76:	8b 45 08             	mov    0x8(%ebp),%eax
  801b79:	8a 00                	mov    (%eax),%al
  801b7b:	3c 5a                	cmp    $0x5a,%al
  801b7d:	7f 30                	jg     801baf <strtol+0x126>
			dig = *s - 'A' + 10;
  801b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b82:	8a 00                	mov    (%eax),%al
  801b84:	0f be c0             	movsbl %al,%eax
  801b87:	83 e8 37             	sub    $0x37,%eax
  801b8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b90:	3b 45 10             	cmp    0x10(%ebp),%eax
  801b93:	7d 19                	jge    801bae <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801b95:	ff 45 08             	incl   0x8(%ebp)
  801b98:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b9b:	0f af 45 10          	imul   0x10(%ebp),%eax
  801b9f:	89 c2                	mov    %eax,%edx
  801ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba4:	01 d0                	add    %edx,%eax
  801ba6:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801ba9:	e9 7b ff ff ff       	jmp    801b29 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801bae:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801baf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801bb3:	74 08                	je     801bbd <strtol+0x134>
		*endptr = (char *) s;
  801bb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb8:	8b 55 08             	mov    0x8(%ebp),%edx
  801bbb:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801bbd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801bc1:	74 07                	je     801bca <strtol+0x141>
  801bc3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bc6:	f7 d8                	neg    %eax
  801bc8:	eb 03                	jmp    801bcd <strtol+0x144>
  801bca:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801bcd:	c9                   	leave  
  801bce:	c3                   	ret    

00801bcf <ltostr>:

void
ltostr(long value, char *str)
{
  801bcf:	55                   	push   %ebp
  801bd0:	89 e5                	mov    %esp,%ebp
  801bd2:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801bd5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801bdc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801be3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801be7:	79 13                	jns    801bfc <ltostr+0x2d>
	{
		neg = 1;
  801be9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801bf0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf3:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801bf6:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801bf9:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bff:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801c04:	99                   	cltd   
  801c05:	f7 f9                	idiv   %ecx
  801c07:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801c0a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c0d:	8d 50 01             	lea    0x1(%eax),%edx
  801c10:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801c13:	89 c2                	mov    %eax,%edx
  801c15:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c18:	01 d0                	add    %edx,%eax
  801c1a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c1d:	83 c2 30             	add    $0x30,%edx
  801c20:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801c22:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c25:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801c2a:	f7 e9                	imul   %ecx
  801c2c:	c1 fa 02             	sar    $0x2,%edx
  801c2f:	89 c8                	mov    %ecx,%eax
  801c31:	c1 f8 1f             	sar    $0x1f,%eax
  801c34:	29 c2                	sub    %eax,%edx
  801c36:	89 d0                	mov    %edx,%eax
  801c38:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801c3b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c3e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801c43:	f7 e9                	imul   %ecx
  801c45:	c1 fa 02             	sar    $0x2,%edx
  801c48:	89 c8                	mov    %ecx,%eax
  801c4a:	c1 f8 1f             	sar    $0x1f,%eax
  801c4d:	29 c2                	sub    %eax,%edx
  801c4f:	89 d0                	mov    %edx,%eax
  801c51:	c1 e0 02             	shl    $0x2,%eax
  801c54:	01 d0                	add    %edx,%eax
  801c56:	01 c0                	add    %eax,%eax
  801c58:	29 c1                	sub    %eax,%ecx
  801c5a:	89 ca                	mov    %ecx,%edx
  801c5c:	85 d2                	test   %edx,%edx
  801c5e:	75 9c                	jne    801bfc <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801c60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801c67:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c6a:	48                   	dec    %eax
  801c6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801c6e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801c72:	74 3d                	je     801cb1 <ltostr+0xe2>
		start = 1 ;
  801c74:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801c7b:	eb 34                	jmp    801cb1 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801c7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c80:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c83:	01 d0                	add    %edx,%eax
  801c85:	8a 00                	mov    (%eax),%al
  801c87:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801c8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c90:	01 c2                	add    %eax,%edx
  801c92:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801c95:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c98:	01 c8                	add    %ecx,%eax
  801c9a:	8a 00                	mov    (%eax),%al
  801c9c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801c9e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ca1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca4:	01 c2                	add    %eax,%edx
  801ca6:	8a 45 eb             	mov    -0x15(%ebp),%al
  801ca9:	88 02                	mov    %al,(%edx)
		start++ ;
  801cab:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801cae:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801cb7:	7c c4                	jl     801c7d <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801cb9:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cbf:	01 d0                	add    %edx,%eax
  801cc1:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801cc4:	90                   	nop
  801cc5:	c9                   	leave  
  801cc6:	c3                   	ret    

00801cc7 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
  801cca:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801ccd:	ff 75 08             	pushl  0x8(%ebp)
  801cd0:	e8 54 fa ff ff       	call   801729 <strlen>
  801cd5:	83 c4 04             	add    $0x4,%esp
  801cd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801cdb:	ff 75 0c             	pushl  0xc(%ebp)
  801cde:	e8 46 fa ff ff       	call   801729 <strlen>
  801ce3:	83 c4 04             	add    $0x4,%esp
  801ce6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801ce9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801cf0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801cf7:	eb 17                	jmp    801d10 <strcconcat+0x49>
		final[s] = str1[s] ;
  801cf9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cfc:	8b 45 10             	mov    0x10(%ebp),%eax
  801cff:	01 c2                	add    %eax,%edx
  801d01:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801d04:	8b 45 08             	mov    0x8(%ebp),%eax
  801d07:	01 c8                	add    %ecx,%eax
  801d09:	8a 00                	mov    (%eax),%al
  801d0b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801d0d:	ff 45 fc             	incl   -0x4(%ebp)
  801d10:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d13:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801d16:	7c e1                	jl     801cf9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801d18:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801d1f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801d26:	eb 1f                	jmp    801d47 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801d28:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d2b:	8d 50 01             	lea    0x1(%eax),%edx
  801d2e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801d31:	89 c2                	mov    %eax,%edx
  801d33:	8b 45 10             	mov    0x10(%ebp),%eax
  801d36:	01 c2                	add    %eax,%edx
  801d38:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801d3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d3e:	01 c8                	add    %ecx,%eax
  801d40:	8a 00                	mov    (%eax),%al
  801d42:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801d44:	ff 45 f8             	incl   -0x8(%ebp)
  801d47:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d4a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801d4d:	7c d9                	jl     801d28 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801d4f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d52:	8b 45 10             	mov    0x10(%ebp),%eax
  801d55:	01 d0                	add    %edx,%eax
  801d57:	c6 00 00             	movb   $0x0,(%eax)
}
  801d5a:	90                   	nop
  801d5b:	c9                   	leave  
  801d5c:	c3                   	ret    

00801d5d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801d5d:	55                   	push   %ebp
  801d5e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801d60:	8b 45 14             	mov    0x14(%ebp),%eax
  801d63:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801d69:	8b 45 14             	mov    0x14(%ebp),%eax
  801d6c:	8b 00                	mov    (%eax),%eax
  801d6e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d75:	8b 45 10             	mov    0x10(%ebp),%eax
  801d78:	01 d0                	add    %edx,%eax
  801d7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801d80:	eb 0c                	jmp    801d8e <strsplit+0x31>
			*string++ = 0;
  801d82:	8b 45 08             	mov    0x8(%ebp),%eax
  801d85:	8d 50 01             	lea    0x1(%eax),%edx
  801d88:	89 55 08             	mov    %edx,0x8(%ebp)
  801d8b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d91:	8a 00                	mov    (%eax),%al
  801d93:	84 c0                	test   %al,%al
  801d95:	74 18                	je     801daf <strsplit+0x52>
  801d97:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9a:	8a 00                	mov    (%eax),%al
  801d9c:	0f be c0             	movsbl %al,%eax
  801d9f:	50                   	push   %eax
  801da0:	ff 75 0c             	pushl  0xc(%ebp)
  801da3:	e8 13 fb ff ff       	call   8018bb <strchr>
  801da8:	83 c4 08             	add    $0x8,%esp
  801dab:	85 c0                	test   %eax,%eax
  801dad:	75 d3                	jne    801d82 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801daf:	8b 45 08             	mov    0x8(%ebp),%eax
  801db2:	8a 00                	mov    (%eax),%al
  801db4:	84 c0                	test   %al,%al
  801db6:	74 5a                	je     801e12 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801db8:	8b 45 14             	mov    0x14(%ebp),%eax
  801dbb:	8b 00                	mov    (%eax),%eax
  801dbd:	83 f8 0f             	cmp    $0xf,%eax
  801dc0:	75 07                	jne    801dc9 <strsplit+0x6c>
		{
			return 0;
  801dc2:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc7:	eb 66                	jmp    801e2f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801dc9:	8b 45 14             	mov    0x14(%ebp),%eax
  801dcc:	8b 00                	mov    (%eax),%eax
  801dce:	8d 48 01             	lea    0x1(%eax),%ecx
  801dd1:	8b 55 14             	mov    0x14(%ebp),%edx
  801dd4:	89 0a                	mov    %ecx,(%edx)
  801dd6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ddd:	8b 45 10             	mov    0x10(%ebp),%eax
  801de0:	01 c2                	add    %eax,%edx
  801de2:	8b 45 08             	mov    0x8(%ebp),%eax
  801de5:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801de7:	eb 03                	jmp    801dec <strsplit+0x8f>
			string++;
  801de9:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801dec:	8b 45 08             	mov    0x8(%ebp),%eax
  801def:	8a 00                	mov    (%eax),%al
  801df1:	84 c0                	test   %al,%al
  801df3:	74 8b                	je     801d80 <strsplit+0x23>
  801df5:	8b 45 08             	mov    0x8(%ebp),%eax
  801df8:	8a 00                	mov    (%eax),%al
  801dfa:	0f be c0             	movsbl %al,%eax
  801dfd:	50                   	push   %eax
  801dfe:	ff 75 0c             	pushl  0xc(%ebp)
  801e01:	e8 b5 fa ff ff       	call   8018bb <strchr>
  801e06:	83 c4 08             	add    $0x8,%esp
  801e09:	85 c0                	test   %eax,%eax
  801e0b:	74 dc                	je     801de9 <strsplit+0x8c>
			string++;
	}
  801e0d:	e9 6e ff ff ff       	jmp    801d80 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801e12:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801e13:	8b 45 14             	mov    0x14(%ebp),%eax
  801e16:	8b 00                	mov    (%eax),%eax
  801e18:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801e1f:	8b 45 10             	mov    0x10(%ebp),%eax
  801e22:	01 d0                	add    %edx,%eax
  801e24:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801e2a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801e2f:	c9                   	leave  
  801e30:	c3                   	ret    

00801e31 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801e31:	55                   	push   %ebp
  801e32:	89 e5                	mov    %esp,%ebp
  801e34:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801e37:	a1 04 50 80 00       	mov    0x805004,%eax
  801e3c:	85 c0                	test   %eax,%eax
  801e3e:	74 1f                	je     801e5f <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801e40:	e8 1d 00 00 00       	call   801e62 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801e45:	83 ec 0c             	sub    $0xc,%esp
  801e48:	68 50 45 80 00       	push   $0x804550
  801e4d:	e8 55 f2 ff ff       	call   8010a7 <cprintf>
  801e52:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801e55:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801e5c:	00 00 00 
	}
}
  801e5f:	90                   	nop
  801e60:	c9                   	leave  
  801e61:	c3                   	ret    

00801e62 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
  801e65:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  801e68:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801e6f:	00 00 00 
  801e72:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801e79:	00 00 00 
  801e7c:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801e83:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  801e86:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801e8d:	00 00 00 
  801e90:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801e97:	00 00 00 
  801e9a:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801ea1:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  801ea4:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801eb3:	2d 00 10 00 00       	sub    $0x1000,%eax
  801eb8:	a3 50 50 80 00       	mov    %eax,0x805050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801ebd:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801ec4:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  801ec7:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801ece:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ed1:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  801ed6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ed9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801edc:	ba 00 00 00 00       	mov    $0x0,%edx
  801ee1:	f7 75 f0             	divl   -0x10(%ebp)
  801ee4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ee7:	29 d0                	sub    %edx,%eax
  801ee9:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  801eec:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801ef3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ef6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801efb:	2d 00 10 00 00       	sub    $0x1000,%eax
  801f00:	83 ec 04             	sub    $0x4,%esp
  801f03:	6a 06                	push   $0x6
  801f05:	ff 75 e8             	pushl  -0x18(%ebp)
  801f08:	50                   	push   %eax
  801f09:	e8 d4 05 00 00       	call   8024e2 <sys_allocate_chunk>
  801f0e:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801f11:	a1 20 51 80 00       	mov    0x805120,%eax
  801f16:	83 ec 0c             	sub    $0xc,%esp
  801f19:	50                   	push   %eax
  801f1a:	e8 49 0c 00 00       	call   802b68 <initialize_MemBlocksList>
  801f1f:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  801f22:	a1 48 51 80 00       	mov    0x805148,%eax
  801f27:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  801f2a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801f2e:	75 14                	jne    801f44 <initialize_dyn_block_system+0xe2>
  801f30:	83 ec 04             	sub    $0x4,%esp
  801f33:	68 75 45 80 00       	push   $0x804575
  801f38:	6a 39                	push   $0x39
  801f3a:	68 93 45 80 00       	push   $0x804593
  801f3f:	e8 af ee ff ff       	call   800df3 <_panic>
  801f44:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f47:	8b 00                	mov    (%eax),%eax
  801f49:	85 c0                	test   %eax,%eax
  801f4b:	74 10                	je     801f5d <initialize_dyn_block_system+0xfb>
  801f4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f50:	8b 00                	mov    (%eax),%eax
  801f52:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f55:	8b 52 04             	mov    0x4(%edx),%edx
  801f58:	89 50 04             	mov    %edx,0x4(%eax)
  801f5b:	eb 0b                	jmp    801f68 <initialize_dyn_block_system+0x106>
  801f5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f60:	8b 40 04             	mov    0x4(%eax),%eax
  801f63:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801f68:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f6b:	8b 40 04             	mov    0x4(%eax),%eax
  801f6e:	85 c0                	test   %eax,%eax
  801f70:	74 0f                	je     801f81 <initialize_dyn_block_system+0x11f>
  801f72:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f75:	8b 40 04             	mov    0x4(%eax),%eax
  801f78:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f7b:	8b 12                	mov    (%edx),%edx
  801f7d:	89 10                	mov    %edx,(%eax)
  801f7f:	eb 0a                	jmp    801f8b <initialize_dyn_block_system+0x129>
  801f81:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f84:	8b 00                	mov    (%eax),%eax
  801f86:	a3 48 51 80 00       	mov    %eax,0x805148
  801f8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f8e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f94:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f97:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f9e:	a1 54 51 80 00       	mov    0x805154,%eax
  801fa3:	48                   	dec    %eax
  801fa4:	a3 54 51 80 00       	mov    %eax,0x805154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  801fa9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fac:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  801fb3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fb6:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  801fbd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801fc1:	75 14                	jne    801fd7 <initialize_dyn_block_system+0x175>
  801fc3:	83 ec 04             	sub    $0x4,%esp
  801fc6:	68 a0 45 80 00       	push   $0x8045a0
  801fcb:	6a 3f                	push   $0x3f
  801fcd:	68 93 45 80 00       	push   $0x804593
  801fd2:	e8 1c ee ff ff       	call   800df3 <_panic>
  801fd7:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801fdd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fe0:	89 10                	mov    %edx,(%eax)
  801fe2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fe5:	8b 00                	mov    (%eax),%eax
  801fe7:	85 c0                	test   %eax,%eax
  801fe9:	74 0d                	je     801ff8 <initialize_dyn_block_system+0x196>
  801feb:	a1 38 51 80 00       	mov    0x805138,%eax
  801ff0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ff3:	89 50 04             	mov    %edx,0x4(%eax)
  801ff6:	eb 08                	jmp    802000 <initialize_dyn_block_system+0x19e>
  801ff8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ffb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802000:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802003:	a3 38 51 80 00       	mov    %eax,0x805138
  802008:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80200b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802012:	a1 44 51 80 00       	mov    0x805144,%eax
  802017:	40                   	inc    %eax
  802018:	a3 44 51 80 00       	mov    %eax,0x805144

}
  80201d:	90                   	nop
  80201e:	c9                   	leave  
  80201f:	c3                   	ret    

00802020 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  802020:	55                   	push   %ebp
  802021:	89 e5                	mov    %esp,%ebp
  802023:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802026:	e8 06 fe ff ff       	call   801e31 <InitializeUHeap>
	if (size == 0) return NULL ;
  80202b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80202f:	75 07                	jne    802038 <malloc+0x18>
  802031:	b8 00 00 00 00       	mov    $0x0,%eax
  802036:	eb 7d                	jmp    8020b5 <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  802038:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  80203f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802046:	8b 55 08             	mov    0x8(%ebp),%edx
  802049:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80204c:	01 d0                	add    %edx,%eax
  80204e:	48                   	dec    %eax
  80204f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802052:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802055:	ba 00 00 00 00       	mov    $0x0,%edx
  80205a:	f7 75 f0             	divl   -0x10(%ebp)
  80205d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802060:	29 d0                	sub    %edx,%eax
  802062:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  802065:	e8 46 08 00 00       	call   8028b0 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80206a:	83 f8 01             	cmp    $0x1,%eax
  80206d:	75 07                	jne    802076 <malloc+0x56>
  80206f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  802076:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  80207a:	75 34                	jne    8020b0 <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  80207c:	83 ec 0c             	sub    $0xc,%esp
  80207f:	ff 75 e8             	pushl  -0x18(%ebp)
  802082:	e8 73 0e 00 00       	call   802efa <alloc_block_FF>
  802087:	83 c4 10             	add    $0x10,%esp
  80208a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  80208d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802091:	74 16                	je     8020a9 <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  802093:	83 ec 0c             	sub    $0xc,%esp
  802096:	ff 75 e4             	pushl  -0x1c(%ebp)
  802099:	e8 ff 0b 00 00       	call   802c9d <insert_sorted_allocList>
  80209e:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  8020a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020a4:	8b 40 08             	mov    0x8(%eax),%eax
  8020a7:	eb 0c                	jmp    8020b5 <malloc+0x95>
	             }
	             else
	             	return NULL;
  8020a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ae:	eb 05                	jmp    8020b5 <malloc+0x95>
	      	  }
	          else
	               return NULL;
  8020b0:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  8020b5:	c9                   	leave  
  8020b6:	c3                   	ret    

008020b7 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8020b7:	55                   	push   %ebp
  8020b8:	89 e5                	mov    %esp,%ebp
  8020ba:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  8020bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c0:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  8020c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8020c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020cc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8020d1:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  8020d4:	83 ec 08             	sub    $0x8,%esp
  8020d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8020da:	68 40 50 80 00       	push   $0x805040
  8020df:	e8 61 0b 00 00       	call   802c45 <find_block>
  8020e4:	83 c4 10             	add    $0x10,%esp
  8020e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  8020ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8020ee:	0f 84 a5 00 00 00    	je     802199 <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  8020f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8020fa:	83 ec 08             	sub    $0x8,%esp
  8020fd:	50                   	push   %eax
  8020fe:	ff 75 f4             	pushl  -0xc(%ebp)
  802101:	e8 a4 03 00 00       	call   8024aa <sys_free_user_mem>
  802106:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  802109:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80210d:	75 17                	jne    802126 <free+0x6f>
  80210f:	83 ec 04             	sub    $0x4,%esp
  802112:	68 75 45 80 00       	push   $0x804575
  802117:	68 87 00 00 00       	push   $0x87
  80211c:	68 93 45 80 00       	push   $0x804593
  802121:	e8 cd ec ff ff       	call   800df3 <_panic>
  802126:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802129:	8b 00                	mov    (%eax),%eax
  80212b:	85 c0                	test   %eax,%eax
  80212d:	74 10                	je     80213f <free+0x88>
  80212f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802132:	8b 00                	mov    (%eax),%eax
  802134:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802137:	8b 52 04             	mov    0x4(%edx),%edx
  80213a:	89 50 04             	mov    %edx,0x4(%eax)
  80213d:	eb 0b                	jmp    80214a <free+0x93>
  80213f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802142:	8b 40 04             	mov    0x4(%eax),%eax
  802145:	a3 44 50 80 00       	mov    %eax,0x805044
  80214a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80214d:	8b 40 04             	mov    0x4(%eax),%eax
  802150:	85 c0                	test   %eax,%eax
  802152:	74 0f                	je     802163 <free+0xac>
  802154:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802157:	8b 40 04             	mov    0x4(%eax),%eax
  80215a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80215d:	8b 12                	mov    (%edx),%edx
  80215f:	89 10                	mov    %edx,(%eax)
  802161:	eb 0a                	jmp    80216d <free+0xb6>
  802163:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802166:	8b 00                	mov    (%eax),%eax
  802168:	a3 40 50 80 00       	mov    %eax,0x805040
  80216d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802170:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802176:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802179:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802180:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802185:	48                   	dec    %eax
  802186:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(theBlock);
  80218b:	83 ec 0c             	sub    $0xc,%esp
  80218e:	ff 75 ec             	pushl  -0x14(%ebp)
  802191:	e8 37 12 00 00       	call   8033cd <insert_sorted_with_merge_freeList>
  802196:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  802199:	90                   	nop
  80219a:	c9                   	leave  
  80219b:	c3                   	ret    

0080219c <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80219c:	55                   	push   %ebp
  80219d:	89 e5                	mov    %esp,%ebp
  80219f:	83 ec 38             	sub    $0x38,%esp
  8021a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8021a5:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8021a8:	e8 84 fc ff ff       	call   801e31 <InitializeUHeap>
	if (size == 0) return NULL ;
  8021ad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8021b1:	75 07                	jne    8021ba <smalloc+0x1e>
  8021b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b8:	eb 7e                	jmp    802238 <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  8021ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8021c1:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8021c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ce:	01 d0                	add    %edx,%eax
  8021d0:	48                   	dec    %eax
  8021d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8021d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8021dc:	f7 75 f0             	divl   -0x10(%ebp)
  8021df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021e2:	29 d0                	sub    %edx,%eax
  8021e4:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  8021e7:	e8 c4 06 00 00       	call   8028b0 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8021ec:	83 f8 01             	cmp    $0x1,%eax
  8021ef:	75 42                	jne    802233 <smalloc+0x97>

		  va = malloc(newsize) ;
  8021f1:	83 ec 0c             	sub    $0xc,%esp
  8021f4:	ff 75 e8             	pushl  -0x18(%ebp)
  8021f7:	e8 24 fe ff ff       	call   802020 <malloc>
  8021fc:	83 c4 10             	add    $0x10,%esp
  8021ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  802202:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802206:	74 24                	je     80222c <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  802208:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80220c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80220f:	50                   	push   %eax
  802210:	ff 75 e8             	pushl  -0x18(%ebp)
  802213:	ff 75 08             	pushl  0x8(%ebp)
  802216:	e8 1a 04 00 00       	call   802635 <sys_createSharedObject>
  80221b:	83 c4 10             	add    $0x10,%esp
  80221e:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  802221:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802225:	78 0c                	js     802233 <smalloc+0x97>
					  return va ;
  802227:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80222a:	eb 0c                	jmp    802238 <smalloc+0x9c>
				 }
				 else
					return NULL;
  80222c:	b8 00 00 00 00       	mov    $0x0,%eax
  802231:	eb 05                	jmp    802238 <smalloc+0x9c>
	  }
		  return NULL ;
  802233:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  802238:	c9                   	leave  
  802239:	c3                   	ret    

0080223a <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80223a:	55                   	push   %ebp
  80223b:	89 e5                	mov    %esp,%ebp
  80223d:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802240:	e8 ec fb ff ff       	call   801e31 <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  802245:	83 ec 08             	sub    $0x8,%esp
  802248:	ff 75 0c             	pushl  0xc(%ebp)
  80224b:	ff 75 08             	pushl  0x8(%ebp)
  80224e:	e8 0c 04 00 00       	call   80265f <sys_getSizeOfSharedObject>
  802253:	83 c4 10             	add    $0x10,%esp
  802256:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  802259:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  80225d:	75 07                	jne    802266 <sget+0x2c>
  80225f:	b8 00 00 00 00       	mov    $0x0,%eax
  802264:	eb 75                	jmp    8022db <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  802266:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80226d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802270:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802273:	01 d0                	add    %edx,%eax
  802275:	48                   	dec    %eax
  802276:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802279:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80227c:	ba 00 00 00 00       	mov    $0x0,%edx
  802281:	f7 75 f0             	divl   -0x10(%ebp)
  802284:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802287:	29 d0                	sub    %edx,%eax
  802289:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  80228c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  802293:	e8 18 06 00 00       	call   8028b0 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802298:	83 f8 01             	cmp    $0x1,%eax
  80229b:	75 39                	jne    8022d6 <sget+0x9c>

		  va = malloc(newsize) ;
  80229d:	83 ec 0c             	sub    $0xc,%esp
  8022a0:	ff 75 e8             	pushl  -0x18(%ebp)
  8022a3:	e8 78 fd ff ff       	call   802020 <malloc>
  8022a8:	83 c4 10             	add    $0x10,%esp
  8022ab:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  8022ae:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8022b2:	74 22                	je     8022d6 <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  8022b4:	83 ec 04             	sub    $0x4,%esp
  8022b7:	ff 75 e0             	pushl  -0x20(%ebp)
  8022ba:	ff 75 0c             	pushl  0xc(%ebp)
  8022bd:	ff 75 08             	pushl  0x8(%ebp)
  8022c0:	e8 b7 03 00 00       	call   80267c <sys_getSharedObject>
  8022c5:	83 c4 10             	add    $0x10,%esp
  8022c8:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  8022cb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8022cf:	78 05                	js     8022d6 <sget+0x9c>
					  return va;
  8022d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022d4:	eb 05                	jmp    8022db <sget+0xa1>
				  }
			  }
     }
         return NULL;
  8022d6:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  8022db:	c9                   	leave  
  8022dc:	c3                   	ret    

008022dd <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8022dd:	55                   	push   %ebp
  8022de:	89 e5                	mov    %esp,%ebp
  8022e0:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8022e3:	e8 49 fb ff ff       	call   801e31 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8022e8:	83 ec 04             	sub    $0x4,%esp
  8022eb:	68 c4 45 80 00       	push   $0x8045c4
  8022f0:	68 1e 01 00 00       	push   $0x11e
  8022f5:	68 93 45 80 00       	push   $0x804593
  8022fa:	e8 f4 ea ff ff       	call   800df3 <_panic>

008022ff <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8022ff:	55                   	push   %ebp
  802300:	89 e5                	mov    %esp,%ebp
  802302:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802305:	83 ec 04             	sub    $0x4,%esp
  802308:	68 ec 45 80 00       	push   $0x8045ec
  80230d:	68 32 01 00 00       	push   $0x132
  802312:	68 93 45 80 00       	push   $0x804593
  802317:	e8 d7 ea ff ff       	call   800df3 <_panic>

0080231c <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80231c:	55                   	push   %ebp
  80231d:	89 e5                	mov    %esp,%ebp
  80231f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802322:	83 ec 04             	sub    $0x4,%esp
  802325:	68 10 46 80 00       	push   $0x804610
  80232a:	68 3d 01 00 00       	push   $0x13d
  80232f:	68 93 45 80 00       	push   $0x804593
  802334:	e8 ba ea ff ff       	call   800df3 <_panic>

00802339 <shrink>:

}
void shrink(uint32 newSize)
{
  802339:	55                   	push   %ebp
  80233a:	89 e5                	mov    %esp,%ebp
  80233c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80233f:	83 ec 04             	sub    $0x4,%esp
  802342:	68 10 46 80 00       	push   $0x804610
  802347:	68 42 01 00 00       	push   $0x142
  80234c:	68 93 45 80 00       	push   $0x804593
  802351:	e8 9d ea ff ff       	call   800df3 <_panic>

00802356 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802356:	55                   	push   %ebp
  802357:	89 e5                	mov    %esp,%ebp
  802359:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80235c:	83 ec 04             	sub    $0x4,%esp
  80235f:	68 10 46 80 00       	push   $0x804610
  802364:	68 47 01 00 00       	push   $0x147
  802369:	68 93 45 80 00       	push   $0x804593
  80236e:	e8 80 ea ff ff       	call   800df3 <_panic>

00802373 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802373:	55                   	push   %ebp
  802374:	89 e5                	mov    %esp,%ebp
  802376:	57                   	push   %edi
  802377:	56                   	push   %esi
  802378:	53                   	push   %ebx
  802379:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80237c:	8b 45 08             	mov    0x8(%ebp),%eax
  80237f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802382:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802385:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802388:	8b 7d 18             	mov    0x18(%ebp),%edi
  80238b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80238e:	cd 30                	int    $0x30
  802390:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802393:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802396:	83 c4 10             	add    $0x10,%esp
  802399:	5b                   	pop    %ebx
  80239a:	5e                   	pop    %esi
  80239b:	5f                   	pop    %edi
  80239c:	5d                   	pop    %ebp
  80239d:	c3                   	ret    

0080239e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80239e:	55                   	push   %ebp
  80239f:	89 e5                	mov    %esp,%ebp
  8023a1:	83 ec 04             	sub    $0x4,%esp
  8023a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8023a7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8023aa:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8023ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b1:	6a 00                	push   $0x0
  8023b3:	6a 00                	push   $0x0
  8023b5:	52                   	push   %edx
  8023b6:	ff 75 0c             	pushl  0xc(%ebp)
  8023b9:	50                   	push   %eax
  8023ba:	6a 00                	push   $0x0
  8023bc:	e8 b2 ff ff ff       	call   802373 <syscall>
  8023c1:	83 c4 18             	add    $0x18,%esp
}
  8023c4:	90                   	nop
  8023c5:	c9                   	leave  
  8023c6:	c3                   	ret    

008023c7 <sys_cgetc>:

int
sys_cgetc(void)
{
  8023c7:	55                   	push   %ebp
  8023c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8023ca:	6a 00                	push   $0x0
  8023cc:	6a 00                	push   $0x0
  8023ce:	6a 00                	push   $0x0
  8023d0:	6a 00                	push   $0x0
  8023d2:	6a 00                	push   $0x0
  8023d4:	6a 01                	push   $0x1
  8023d6:	e8 98 ff ff ff       	call   802373 <syscall>
  8023db:	83 c4 18             	add    $0x18,%esp
}
  8023de:	c9                   	leave  
  8023df:	c3                   	ret    

008023e0 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8023e0:	55                   	push   %ebp
  8023e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8023e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e9:	6a 00                	push   $0x0
  8023eb:	6a 00                	push   $0x0
  8023ed:	6a 00                	push   $0x0
  8023ef:	52                   	push   %edx
  8023f0:	50                   	push   %eax
  8023f1:	6a 05                	push   $0x5
  8023f3:	e8 7b ff ff ff       	call   802373 <syscall>
  8023f8:	83 c4 18             	add    $0x18,%esp
}
  8023fb:	c9                   	leave  
  8023fc:	c3                   	ret    

008023fd <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8023fd:	55                   	push   %ebp
  8023fe:	89 e5                	mov    %esp,%ebp
  802400:	56                   	push   %esi
  802401:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802402:	8b 75 18             	mov    0x18(%ebp),%esi
  802405:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802408:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80240b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80240e:	8b 45 08             	mov    0x8(%ebp),%eax
  802411:	56                   	push   %esi
  802412:	53                   	push   %ebx
  802413:	51                   	push   %ecx
  802414:	52                   	push   %edx
  802415:	50                   	push   %eax
  802416:	6a 06                	push   $0x6
  802418:	e8 56 ff ff ff       	call   802373 <syscall>
  80241d:	83 c4 18             	add    $0x18,%esp
}
  802420:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802423:	5b                   	pop    %ebx
  802424:	5e                   	pop    %esi
  802425:	5d                   	pop    %ebp
  802426:	c3                   	ret    

00802427 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802427:	55                   	push   %ebp
  802428:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80242a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80242d:	8b 45 08             	mov    0x8(%ebp),%eax
  802430:	6a 00                	push   $0x0
  802432:	6a 00                	push   $0x0
  802434:	6a 00                	push   $0x0
  802436:	52                   	push   %edx
  802437:	50                   	push   %eax
  802438:	6a 07                	push   $0x7
  80243a:	e8 34 ff ff ff       	call   802373 <syscall>
  80243f:	83 c4 18             	add    $0x18,%esp
}
  802442:	c9                   	leave  
  802443:	c3                   	ret    

00802444 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802444:	55                   	push   %ebp
  802445:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802447:	6a 00                	push   $0x0
  802449:	6a 00                	push   $0x0
  80244b:	6a 00                	push   $0x0
  80244d:	ff 75 0c             	pushl  0xc(%ebp)
  802450:	ff 75 08             	pushl  0x8(%ebp)
  802453:	6a 08                	push   $0x8
  802455:	e8 19 ff ff ff       	call   802373 <syscall>
  80245a:	83 c4 18             	add    $0x18,%esp
}
  80245d:	c9                   	leave  
  80245e:	c3                   	ret    

0080245f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80245f:	55                   	push   %ebp
  802460:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802462:	6a 00                	push   $0x0
  802464:	6a 00                	push   $0x0
  802466:	6a 00                	push   $0x0
  802468:	6a 00                	push   $0x0
  80246a:	6a 00                	push   $0x0
  80246c:	6a 09                	push   $0x9
  80246e:	e8 00 ff ff ff       	call   802373 <syscall>
  802473:	83 c4 18             	add    $0x18,%esp
}
  802476:	c9                   	leave  
  802477:	c3                   	ret    

00802478 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802478:	55                   	push   %ebp
  802479:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80247b:	6a 00                	push   $0x0
  80247d:	6a 00                	push   $0x0
  80247f:	6a 00                	push   $0x0
  802481:	6a 00                	push   $0x0
  802483:	6a 00                	push   $0x0
  802485:	6a 0a                	push   $0xa
  802487:	e8 e7 fe ff ff       	call   802373 <syscall>
  80248c:	83 c4 18             	add    $0x18,%esp
}
  80248f:	c9                   	leave  
  802490:	c3                   	ret    

00802491 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802491:	55                   	push   %ebp
  802492:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802494:	6a 00                	push   $0x0
  802496:	6a 00                	push   $0x0
  802498:	6a 00                	push   $0x0
  80249a:	6a 00                	push   $0x0
  80249c:	6a 00                	push   $0x0
  80249e:	6a 0b                	push   $0xb
  8024a0:	e8 ce fe ff ff       	call   802373 <syscall>
  8024a5:	83 c4 18             	add    $0x18,%esp
}
  8024a8:	c9                   	leave  
  8024a9:	c3                   	ret    

008024aa <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8024aa:	55                   	push   %ebp
  8024ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8024ad:	6a 00                	push   $0x0
  8024af:	6a 00                	push   $0x0
  8024b1:	6a 00                	push   $0x0
  8024b3:	ff 75 0c             	pushl  0xc(%ebp)
  8024b6:	ff 75 08             	pushl  0x8(%ebp)
  8024b9:	6a 0f                	push   $0xf
  8024bb:	e8 b3 fe ff ff       	call   802373 <syscall>
  8024c0:	83 c4 18             	add    $0x18,%esp
	return;
  8024c3:	90                   	nop
}
  8024c4:	c9                   	leave  
  8024c5:	c3                   	ret    

008024c6 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8024c6:	55                   	push   %ebp
  8024c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8024c9:	6a 00                	push   $0x0
  8024cb:	6a 00                	push   $0x0
  8024cd:	6a 00                	push   $0x0
  8024cf:	ff 75 0c             	pushl  0xc(%ebp)
  8024d2:	ff 75 08             	pushl  0x8(%ebp)
  8024d5:	6a 10                	push   $0x10
  8024d7:	e8 97 fe ff ff       	call   802373 <syscall>
  8024dc:	83 c4 18             	add    $0x18,%esp
	return ;
  8024df:	90                   	nop
}
  8024e0:	c9                   	leave  
  8024e1:	c3                   	ret    

008024e2 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8024e2:	55                   	push   %ebp
  8024e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8024e5:	6a 00                	push   $0x0
  8024e7:	6a 00                	push   $0x0
  8024e9:	ff 75 10             	pushl  0x10(%ebp)
  8024ec:	ff 75 0c             	pushl  0xc(%ebp)
  8024ef:	ff 75 08             	pushl  0x8(%ebp)
  8024f2:	6a 11                	push   $0x11
  8024f4:	e8 7a fe ff ff       	call   802373 <syscall>
  8024f9:	83 c4 18             	add    $0x18,%esp
	return ;
  8024fc:	90                   	nop
}
  8024fd:	c9                   	leave  
  8024fe:	c3                   	ret    

008024ff <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8024ff:	55                   	push   %ebp
  802500:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802502:	6a 00                	push   $0x0
  802504:	6a 00                	push   $0x0
  802506:	6a 00                	push   $0x0
  802508:	6a 00                	push   $0x0
  80250a:	6a 00                	push   $0x0
  80250c:	6a 0c                	push   $0xc
  80250e:	e8 60 fe ff ff       	call   802373 <syscall>
  802513:	83 c4 18             	add    $0x18,%esp
}
  802516:	c9                   	leave  
  802517:	c3                   	ret    

00802518 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802518:	55                   	push   %ebp
  802519:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80251b:	6a 00                	push   $0x0
  80251d:	6a 00                	push   $0x0
  80251f:	6a 00                	push   $0x0
  802521:	6a 00                	push   $0x0
  802523:	ff 75 08             	pushl  0x8(%ebp)
  802526:	6a 0d                	push   $0xd
  802528:	e8 46 fe ff ff       	call   802373 <syscall>
  80252d:	83 c4 18             	add    $0x18,%esp
}
  802530:	c9                   	leave  
  802531:	c3                   	ret    

00802532 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802532:	55                   	push   %ebp
  802533:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802535:	6a 00                	push   $0x0
  802537:	6a 00                	push   $0x0
  802539:	6a 00                	push   $0x0
  80253b:	6a 00                	push   $0x0
  80253d:	6a 00                	push   $0x0
  80253f:	6a 0e                	push   $0xe
  802541:	e8 2d fe ff ff       	call   802373 <syscall>
  802546:	83 c4 18             	add    $0x18,%esp
}
  802549:	90                   	nop
  80254a:	c9                   	leave  
  80254b:	c3                   	ret    

0080254c <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80254c:	55                   	push   %ebp
  80254d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80254f:	6a 00                	push   $0x0
  802551:	6a 00                	push   $0x0
  802553:	6a 00                	push   $0x0
  802555:	6a 00                	push   $0x0
  802557:	6a 00                	push   $0x0
  802559:	6a 13                	push   $0x13
  80255b:	e8 13 fe ff ff       	call   802373 <syscall>
  802560:	83 c4 18             	add    $0x18,%esp
}
  802563:	90                   	nop
  802564:	c9                   	leave  
  802565:	c3                   	ret    

00802566 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802566:	55                   	push   %ebp
  802567:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802569:	6a 00                	push   $0x0
  80256b:	6a 00                	push   $0x0
  80256d:	6a 00                	push   $0x0
  80256f:	6a 00                	push   $0x0
  802571:	6a 00                	push   $0x0
  802573:	6a 14                	push   $0x14
  802575:	e8 f9 fd ff ff       	call   802373 <syscall>
  80257a:	83 c4 18             	add    $0x18,%esp
}
  80257d:	90                   	nop
  80257e:	c9                   	leave  
  80257f:	c3                   	ret    

00802580 <sys_cputc>:


void
sys_cputc(const char c)
{
  802580:	55                   	push   %ebp
  802581:	89 e5                	mov    %esp,%ebp
  802583:	83 ec 04             	sub    $0x4,%esp
  802586:	8b 45 08             	mov    0x8(%ebp),%eax
  802589:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80258c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802590:	6a 00                	push   $0x0
  802592:	6a 00                	push   $0x0
  802594:	6a 00                	push   $0x0
  802596:	6a 00                	push   $0x0
  802598:	50                   	push   %eax
  802599:	6a 15                	push   $0x15
  80259b:	e8 d3 fd ff ff       	call   802373 <syscall>
  8025a0:	83 c4 18             	add    $0x18,%esp
}
  8025a3:	90                   	nop
  8025a4:	c9                   	leave  
  8025a5:	c3                   	ret    

008025a6 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8025a6:	55                   	push   %ebp
  8025a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8025a9:	6a 00                	push   $0x0
  8025ab:	6a 00                	push   $0x0
  8025ad:	6a 00                	push   $0x0
  8025af:	6a 00                	push   $0x0
  8025b1:	6a 00                	push   $0x0
  8025b3:	6a 16                	push   $0x16
  8025b5:	e8 b9 fd ff ff       	call   802373 <syscall>
  8025ba:	83 c4 18             	add    $0x18,%esp
}
  8025bd:	90                   	nop
  8025be:	c9                   	leave  
  8025bf:	c3                   	ret    

008025c0 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8025c0:	55                   	push   %ebp
  8025c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8025c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c6:	6a 00                	push   $0x0
  8025c8:	6a 00                	push   $0x0
  8025ca:	6a 00                	push   $0x0
  8025cc:	ff 75 0c             	pushl  0xc(%ebp)
  8025cf:	50                   	push   %eax
  8025d0:	6a 17                	push   $0x17
  8025d2:	e8 9c fd ff ff       	call   802373 <syscall>
  8025d7:	83 c4 18             	add    $0x18,%esp
}
  8025da:	c9                   	leave  
  8025db:	c3                   	ret    

008025dc <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8025dc:	55                   	push   %ebp
  8025dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8025df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e5:	6a 00                	push   $0x0
  8025e7:	6a 00                	push   $0x0
  8025e9:	6a 00                	push   $0x0
  8025eb:	52                   	push   %edx
  8025ec:	50                   	push   %eax
  8025ed:	6a 1a                	push   $0x1a
  8025ef:	e8 7f fd ff ff       	call   802373 <syscall>
  8025f4:	83 c4 18             	add    $0x18,%esp
}
  8025f7:	c9                   	leave  
  8025f8:	c3                   	ret    

008025f9 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8025f9:	55                   	push   %ebp
  8025fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8025fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802602:	6a 00                	push   $0x0
  802604:	6a 00                	push   $0x0
  802606:	6a 00                	push   $0x0
  802608:	52                   	push   %edx
  802609:	50                   	push   %eax
  80260a:	6a 18                	push   $0x18
  80260c:	e8 62 fd ff ff       	call   802373 <syscall>
  802611:	83 c4 18             	add    $0x18,%esp
}
  802614:	90                   	nop
  802615:	c9                   	leave  
  802616:	c3                   	ret    

00802617 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802617:	55                   	push   %ebp
  802618:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80261a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80261d:	8b 45 08             	mov    0x8(%ebp),%eax
  802620:	6a 00                	push   $0x0
  802622:	6a 00                	push   $0x0
  802624:	6a 00                	push   $0x0
  802626:	52                   	push   %edx
  802627:	50                   	push   %eax
  802628:	6a 19                	push   $0x19
  80262a:	e8 44 fd ff ff       	call   802373 <syscall>
  80262f:	83 c4 18             	add    $0x18,%esp
}
  802632:	90                   	nop
  802633:	c9                   	leave  
  802634:	c3                   	ret    

00802635 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802635:	55                   	push   %ebp
  802636:	89 e5                	mov    %esp,%ebp
  802638:	83 ec 04             	sub    $0x4,%esp
  80263b:	8b 45 10             	mov    0x10(%ebp),%eax
  80263e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802641:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802644:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802648:	8b 45 08             	mov    0x8(%ebp),%eax
  80264b:	6a 00                	push   $0x0
  80264d:	51                   	push   %ecx
  80264e:	52                   	push   %edx
  80264f:	ff 75 0c             	pushl  0xc(%ebp)
  802652:	50                   	push   %eax
  802653:	6a 1b                	push   $0x1b
  802655:	e8 19 fd ff ff       	call   802373 <syscall>
  80265a:	83 c4 18             	add    $0x18,%esp
}
  80265d:	c9                   	leave  
  80265e:	c3                   	ret    

0080265f <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80265f:	55                   	push   %ebp
  802660:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802662:	8b 55 0c             	mov    0xc(%ebp),%edx
  802665:	8b 45 08             	mov    0x8(%ebp),%eax
  802668:	6a 00                	push   $0x0
  80266a:	6a 00                	push   $0x0
  80266c:	6a 00                	push   $0x0
  80266e:	52                   	push   %edx
  80266f:	50                   	push   %eax
  802670:	6a 1c                	push   $0x1c
  802672:	e8 fc fc ff ff       	call   802373 <syscall>
  802677:	83 c4 18             	add    $0x18,%esp
}
  80267a:	c9                   	leave  
  80267b:	c3                   	ret    

0080267c <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80267c:	55                   	push   %ebp
  80267d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80267f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802682:	8b 55 0c             	mov    0xc(%ebp),%edx
  802685:	8b 45 08             	mov    0x8(%ebp),%eax
  802688:	6a 00                	push   $0x0
  80268a:	6a 00                	push   $0x0
  80268c:	51                   	push   %ecx
  80268d:	52                   	push   %edx
  80268e:	50                   	push   %eax
  80268f:	6a 1d                	push   $0x1d
  802691:	e8 dd fc ff ff       	call   802373 <syscall>
  802696:	83 c4 18             	add    $0x18,%esp
}
  802699:	c9                   	leave  
  80269a:	c3                   	ret    

0080269b <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80269b:	55                   	push   %ebp
  80269c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80269e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a4:	6a 00                	push   $0x0
  8026a6:	6a 00                	push   $0x0
  8026a8:	6a 00                	push   $0x0
  8026aa:	52                   	push   %edx
  8026ab:	50                   	push   %eax
  8026ac:	6a 1e                	push   $0x1e
  8026ae:	e8 c0 fc ff ff       	call   802373 <syscall>
  8026b3:	83 c4 18             	add    $0x18,%esp
}
  8026b6:	c9                   	leave  
  8026b7:	c3                   	ret    

008026b8 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8026b8:	55                   	push   %ebp
  8026b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8026bb:	6a 00                	push   $0x0
  8026bd:	6a 00                	push   $0x0
  8026bf:	6a 00                	push   $0x0
  8026c1:	6a 00                	push   $0x0
  8026c3:	6a 00                	push   $0x0
  8026c5:	6a 1f                	push   $0x1f
  8026c7:	e8 a7 fc ff ff       	call   802373 <syscall>
  8026cc:	83 c4 18             	add    $0x18,%esp
}
  8026cf:	c9                   	leave  
  8026d0:	c3                   	ret    

008026d1 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8026d1:	55                   	push   %ebp
  8026d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8026d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d7:	6a 00                	push   $0x0
  8026d9:	ff 75 14             	pushl  0x14(%ebp)
  8026dc:	ff 75 10             	pushl  0x10(%ebp)
  8026df:	ff 75 0c             	pushl  0xc(%ebp)
  8026e2:	50                   	push   %eax
  8026e3:	6a 20                	push   $0x20
  8026e5:	e8 89 fc ff ff       	call   802373 <syscall>
  8026ea:	83 c4 18             	add    $0x18,%esp
}
  8026ed:	c9                   	leave  
  8026ee:	c3                   	ret    

008026ef <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8026ef:	55                   	push   %ebp
  8026f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8026f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f5:	6a 00                	push   $0x0
  8026f7:	6a 00                	push   $0x0
  8026f9:	6a 00                	push   $0x0
  8026fb:	6a 00                	push   $0x0
  8026fd:	50                   	push   %eax
  8026fe:	6a 21                	push   $0x21
  802700:	e8 6e fc ff ff       	call   802373 <syscall>
  802705:	83 c4 18             	add    $0x18,%esp
}
  802708:	90                   	nop
  802709:	c9                   	leave  
  80270a:	c3                   	ret    

0080270b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80270b:	55                   	push   %ebp
  80270c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80270e:	8b 45 08             	mov    0x8(%ebp),%eax
  802711:	6a 00                	push   $0x0
  802713:	6a 00                	push   $0x0
  802715:	6a 00                	push   $0x0
  802717:	6a 00                	push   $0x0
  802719:	50                   	push   %eax
  80271a:	6a 22                	push   $0x22
  80271c:	e8 52 fc ff ff       	call   802373 <syscall>
  802721:	83 c4 18             	add    $0x18,%esp
}
  802724:	c9                   	leave  
  802725:	c3                   	ret    

00802726 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802726:	55                   	push   %ebp
  802727:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802729:	6a 00                	push   $0x0
  80272b:	6a 00                	push   $0x0
  80272d:	6a 00                	push   $0x0
  80272f:	6a 00                	push   $0x0
  802731:	6a 00                	push   $0x0
  802733:	6a 02                	push   $0x2
  802735:	e8 39 fc ff ff       	call   802373 <syscall>
  80273a:	83 c4 18             	add    $0x18,%esp
}
  80273d:	c9                   	leave  
  80273e:	c3                   	ret    

0080273f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80273f:	55                   	push   %ebp
  802740:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802742:	6a 00                	push   $0x0
  802744:	6a 00                	push   $0x0
  802746:	6a 00                	push   $0x0
  802748:	6a 00                	push   $0x0
  80274a:	6a 00                	push   $0x0
  80274c:	6a 03                	push   $0x3
  80274e:	e8 20 fc ff ff       	call   802373 <syscall>
  802753:	83 c4 18             	add    $0x18,%esp
}
  802756:	c9                   	leave  
  802757:	c3                   	ret    

00802758 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802758:	55                   	push   %ebp
  802759:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80275b:	6a 00                	push   $0x0
  80275d:	6a 00                	push   $0x0
  80275f:	6a 00                	push   $0x0
  802761:	6a 00                	push   $0x0
  802763:	6a 00                	push   $0x0
  802765:	6a 04                	push   $0x4
  802767:	e8 07 fc ff ff       	call   802373 <syscall>
  80276c:	83 c4 18             	add    $0x18,%esp
}
  80276f:	c9                   	leave  
  802770:	c3                   	ret    

00802771 <sys_exit_env>:


void sys_exit_env(void)
{
  802771:	55                   	push   %ebp
  802772:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802774:	6a 00                	push   $0x0
  802776:	6a 00                	push   $0x0
  802778:	6a 00                	push   $0x0
  80277a:	6a 00                	push   $0x0
  80277c:	6a 00                	push   $0x0
  80277e:	6a 23                	push   $0x23
  802780:	e8 ee fb ff ff       	call   802373 <syscall>
  802785:	83 c4 18             	add    $0x18,%esp
}
  802788:	90                   	nop
  802789:	c9                   	leave  
  80278a:	c3                   	ret    

0080278b <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80278b:	55                   	push   %ebp
  80278c:	89 e5                	mov    %esp,%ebp
  80278e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802791:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802794:	8d 50 04             	lea    0x4(%eax),%edx
  802797:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80279a:	6a 00                	push   $0x0
  80279c:	6a 00                	push   $0x0
  80279e:	6a 00                	push   $0x0
  8027a0:	52                   	push   %edx
  8027a1:	50                   	push   %eax
  8027a2:	6a 24                	push   $0x24
  8027a4:	e8 ca fb ff ff       	call   802373 <syscall>
  8027a9:	83 c4 18             	add    $0x18,%esp
	return result;
  8027ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8027af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8027b2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8027b5:	89 01                	mov    %eax,(%ecx)
  8027b7:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8027ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8027bd:	c9                   	leave  
  8027be:	c2 04 00             	ret    $0x4

008027c1 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8027c1:	55                   	push   %ebp
  8027c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8027c4:	6a 00                	push   $0x0
  8027c6:	6a 00                	push   $0x0
  8027c8:	ff 75 10             	pushl  0x10(%ebp)
  8027cb:	ff 75 0c             	pushl  0xc(%ebp)
  8027ce:	ff 75 08             	pushl  0x8(%ebp)
  8027d1:	6a 12                	push   $0x12
  8027d3:	e8 9b fb ff ff       	call   802373 <syscall>
  8027d8:	83 c4 18             	add    $0x18,%esp
	return ;
  8027db:	90                   	nop
}
  8027dc:	c9                   	leave  
  8027dd:	c3                   	ret    

008027de <sys_rcr2>:
uint32 sys_rcr2()
{
  8027de:	55                   	push   %ebp
  8027df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8027e1:	6a 00                	push   $0x0
  8027e3:	6a 00                	push   $0x0
  8027e5:	6a 00                	push   $0x0
  8027e7:	6a 00                	push   $0x0
  8027e9:	6a 00                	push   $0x0
  8027eb:	6a 25                	push   $0x25
  8027ed:	e8 81 fb ff ff       	call   802373 <syscall>
  8027f2:	83 c4 18             	add    $0x18,%esp
}
  8027f5:	c9                   	leave  
  8027f6:	c3                   	ret    

008027f7 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8027f7:	55                   	push   %ebp
  8027f8:	89 e5                	mov    %esp,%ebp
  8027fa:	83 ec 04             	sub    $0x4,%esp
  8027fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802800:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802803:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802807:	6a 00                	push   $0x0
  802809:	6a 00                	push   $0x0
  80280b:	6a 00                	push   $0x0
  80280d:	6a 00                	push   $0x0
  80280f:	50                   	push   %eax
  802810:	6a 26                	push   $0x26
  802812:	e8 5c fb ff ff       	call   802373 <syscall>
  802817:	83 c4 18             	add    $0x18,%esp
	return ;
  80281a:	90                   	nop
}
  80281b:	c9                   	leave  
  80281c:	c3                   	ret    

0080281d <rsttst>:
void rsttst()
{
  80281d:	55                   	push   %ebp
  80281e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802820:	6a 00                	push   $0x0
  802822:	6a 00                	push   $0x0
  802824:	6a 00                	push   $0x0
  802826:	6a 00                	push   $0x0
  802828:	6a 00                	push   $0x0
  80282a:	6a 28                	push   $0x28
  80282c:	e8 42 fb ff ff       	call   802373 <syscall>
  802831:	83 c4 18             	add    $0x18,%esp
	return ;
  802834:	90                   	nop
}
  802835:	c9                   	leave  
  802836:	c3                   	ret    

00802837 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802837:	55                   	push   %ebp
  802838:	89 e5                	mov    %esp,%ebp
  80283a:	83 ec 04             	sub    $0x4,%esp
  80283d:	8b 45 14             	mov    0x14(%ebp),%eax
  802840:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802843:	8b 55 18             	mov    0x18(%ebp),%edx
  802846:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80284a:	52                   	push   %edx
  80284b:	50                   	push   %eax
  80284c:	ff 75 10             	pushl  0x10(%ebp)
  80284f:	ff 75 0c             	pushl  0xc(%ebp)
  802852:	ff 75 08             	pushl  0x8(%ebp)
  802855:	6a 27                	push   $0x27
  802857:	e8 17 fb ff ff       	call   802373 <syscall>
  80285c:	83 c4 18             	add    $0x18,%esp
	return ;
  80285f:	90                   	nop
}
  802860:	c9                   	leave  
  802861:	c3                   	ret    

00802862 <chktst>:
void chktst(uint32 n)
{
  802862:	55                   	push   %ebp
  802863:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802865:	6a 00                	push   $0x0
  802867:	6a 00                	push   $0x0
  802869:	6a 00                	push   $0x0
  80286b:	6a 00                	push   $0x0
  80286d:	ff 75 08             	pushl  0x8(%ebp)
  802870:	6a 29                	push   $0x29
  802872:	e8 fc fa ff ff       	call   802373 <syscall>
  802877:	83 c4 18             	add    $0x18,%esp
	return ;
  80287a:	90                   	nop
}
  80287b:	c9                   	leave  
  80287c:	c3                   	ret    

0080287d <inctst>:

void inctst()
{
  80287d:	55                   	push   %ebp
  80287e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802880:	6a 00                	push   $0x0
  802882:	6a 00                	push   $0x0
  802884:	6a 00                	push   $0x0
  802886:	6a 00                	push   $0x0
  802888:	6a 00                	push   $0x0
  80288a:	6a 2a                	push   $0x2a
  80288c:	e8 e2 fa ff ff       	call   802373 <syscall>
  802891:	83 c4 18             	add    $0x18,%esp
	return ;
  802894:	90                   	nop
}
  802895:	c9                   	leave  
  802896:	c3                   	ret    

00802897 <gettst>:
uint32 gettst()
{
  802897:	55                   	push   %ebp
  802898:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80289a:	6a 00                	push   $0x0
  80289c:	6a 00                	push   $0x0
  80289e:	6a 00                	push   $0x0
  8028a0:	6a 00                	push   $0x0
  8028a2:	6a 00                	push   $0x0
  8028a4:	6a 2b                	push   $0x2b
  8028a6:	e8 c8 fa ff ff       	call   802373 <syscall>
  8028ab:	83 c4 18             	add    $0x18,%esp
}
  8028ae:	c9                   	leave  
  8028af:	c3                   	ret    

008028b0 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8028b0:	55                   	push   %ebp
  8028b1:	89 e5                	mov    %esp,%ebp
  8028b3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8028b6:	6a 00                	push   $0x0
  8028b8:	6a 00                	push   $0x0
  8028ba:	6a 00                	push   $0x0
  8028bc:	6a 00                	push   $0x0
  8028be:	6a 00                	push   $0x0
  8028c0:	6a 2c                	push   $0x2c
  8028c2:	e8 ac fa ff ff       	call   802373 <syscall>
  8028c7:	83 c4 18             	add    $0x18,%esp
  8028ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8028cd:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8028d1:	75 07                	jne    8028da <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8028d3:	b8 01 00 00 00       	mov    $0x1,%eax
  8028d8:	eb 05                	jmp    8028df <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8028da:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028df:	c9                   	leave  
  8028e0:	c3                   	ret    

008028e1 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8028e1:	55                   	push   %ebp
  8028e2:	89 e5                	mov    %esp,%ebp
  8028e4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8028e7:	6a 00                	push   $0x0
  8028e9:	6a 00                	push   $0x0
  8028eb:	6a 00                	push   $0x0
  8028ed:	6a 00                	push   $0x0
  8028ef:	6a 00                	push   $0x0
  8028f1:	6a 2c                	push   $0x2c
  8028f3:	e8 7b fa ff ff       	call   802373 <syscall>
  8028f8:	83 c4 18             	add    $0x18,%esp
  8028fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8028fe:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802902:	75 07                	jne    80290b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802904:	b8 01 00 00 00       	mov    $0x1,%eax
  802909:	eb 05                	jmp    802910 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80290b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802910:	c9                   	leave  
  802911:	c3                   	ret    

00802912 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802912:	55                   	push   %ebp
  802913:	89 e5                	mov    %esp,%ebp
  802915:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802918:	6a 00                	push   $0x0
  80291a:	6a 00                	push   $0x0
  80291c:	6a 00                	push   $0x0
  80291e:	6a 00                	push   $0x0
  802920:	6a 00                	push   $0x0
  802922:	6a 2c                	push   $0x2c
  802924:	e8 4a fa ff ff       	call   802373 <syscall>
  802929:	83 c4 18             	add    $0x18,%esp
  80292c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80292f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802933:	75 07                	jne    80293c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802935:	b8 01 00 00 00       	mov    $0x1,%eax
  80293a:	eb 05                	jmp    802941 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80293c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802941:	c9                   	leave  
  802942:	c3                   	ret    

00802943 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802943:	55                   	push   %ebp
  802944:	89 e5                	mov    %esp,%ebp
  802946:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802949:	6a 00                	push   $0x0
  80294b:	6a 00                	push   $0x0
  80294d:	6a 00                	push   $0x0
  80294f:	6a 00                	push   $0x0
  802951:	6a 00                	push   $0x0
  802953:	6a 2c                	push   $0x2c
  802955:	e8 19 fa ff ff       	call   802373 <syscall>
  80295a:	83 c4 18             	add    $0x18,%esp
  80295d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802960:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802964:	75 07                	jne    80296d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802966:	b8 01 00 00 00       	mov    $0x1,%eax
  80296b:	eb 05                	jmp    802972 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80296d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802972:	c9                   	leave  
  802973:	c3                   	ret    

00802974 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802974:	55                   	push   %ebp
  802975:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802977:	6a 00                	push   $0x0
  802979:	6a 00                	push   $0x0
  80297b:	6a 00                	push   $0x0
  80297d:	6a 00                	push   $0x0
  80297f:	ff 75 08             	pushl  0x8(%ebp)
  802982:	6a 2d                	push   $0x2d
  802984:	e8 ea f9 ff ff       	call   802373 <syscall>
  802989:	83 c4 18             	add    $0x18,%esp
	return ;
  80298c:	90                   	nop
}
  80298d:	c9                   	leave  
  80298e:	c3                   	ret    

0080298f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80298f:	55                   	push   %ebp
  802990:	89 e5                	mov    %esp,%ebp
  802992:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802993:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802996:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802999:	8b 55 0c             	mov    0xc(%ebp),%edx
  80299c:	8b 45 08             	mov    0x8(%ebp),%eax
  80299f:	6a 00                	push   $0x0
  8029a1:	53                   	push   %ebx
  8029a2:	51                   	push   %ecx
  8029a3:	52                   	push   %edx
  8029a4:	50                   	push   %eax
  8029a5:	6a 2e                	push   $0x2e
  8029a7:	e8 c7 f9 ff ff       	call   802373 <syscall>
  8029ac:	83 c4 18             	add    $0x18,%esp
}
  8029af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8029b2:	c9                   	leave  
  8029b3:	c3                   	ret    

008029b4 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8029b4:	55                   	push   %ebp
  8029b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8029b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bd:	6a 00                	push   $0x0
  8029bf:	6a 00                	push   $0x0
  8029c1:	6a 00                	push   $0x0
  8029c3:	52                   	push   %edx
  8029c4:	50                   	push   %eax
  8029c5:	6a 2f                	push   $0x2f
  8029c7:	e8 a7 f9 ff ff       	call   802373 <syscall>
  8029cc:	83 c4 18             	add    $0x18,%esp
}
  8029cf:	c9                   	leave  
  8029d0:	c3                   	ret    

008029d1 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8029d1:	55                   	push   %ebp
  8029d2:	89 e5                	mov    %esp,%ebp
  8029d4:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8029d7:	83 ec 0c             	sub    $0xc,%esp
  8029da:	68 20 46 80 00       	push   $0x804620
  8029df:	e8 c3 e6 ff ff       	call   8010a7 <cprintf>
  8029e4:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8029e7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8029ee:	83 ec 0c             	sub    $0xc,%esp
  8029f1:	68 4c 46 80 00       	push   $0x80464c
  8029f6:	e8 ac e6 ff ff       	call   8010a7 <cprintf>
  8029fb:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8029fe:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802a02:	a1 38 51 80 00       	mov    0x805138,%eax
  802a07:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a0a:	eb 56                	jmp    802a62 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802a0c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a10:	74 1c                	je     802a2e <print_mem_block_lists+0x5d>
  802a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a15:	8b 50 08             	mov    0x8(%eax),%edx
  802a18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a1b:	8b 48 08             	mov    0x8(%eax),%ecx
  802a1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a21:	8b 40 0c             	mov    0xc(%eax),%eax
  802a24:	01 c8                	add    %ecx,%eax
  802a26:	39 c2                	cmp    %eax,%edx
  802a28:	73 04                	jae    802a2e <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802a2a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a31:	8b 50 08             	mov    0x8(%eax),%edx
  802a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a37:	8b 40 0c             	mov    0xc(%eax),%eax
  802a3a:	01 c2                	add    %eax,%edx
  802a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3f:	8b 40 08             	mov    0x8(%eax),%eax
  802a42:	83 ec 04             	sub    $0x4,%esp
  802a45:	52                   	push   %edx
  802a46:	50                   	push   %eax
  802a47:	68 61 46 80 00       	push   $0x804661
  802a4c:	e8 56 e6 ff ff       	call   8010a7 <cprintf>
  802a51:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a57:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802a5a:	a1 40 51 80 00       	mov    0x805140,%eax
  802a5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a62:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a66:	74 07                	je     802a6f <print_mem_block_lists+0x9e>
  802a68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6b:	8b 00                	mov    (%eax),%eax
  802a6d:	eb 05                	jmp    802a74 <print_mem_block_lists+0xa3>
  802a6f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a74:	a3 40 51 80 00       	mov    %eax,0x805140
  802a79:	a1 40 51 80 00       	mov    0x805140,%eax
  802a7e:	85 c0                	test   %eax,%eax
  802a80:	75 8a                	jne    802a0c <print_mem_block_lists+0x3b>
  802a82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a86:	75 84                	jne    802a0c <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802a88:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802a8c:	75 10                	jne    802a9e <print_mem_block_lists+0xcd>
  802a8e:	83 ec 0c             	sub    $0xc,%esp
  802a91:	68 70 46 80 00       	push   $0x804670
  802a96:	e8 0c e6 ff ff       	call   8010a7 <cprintf>
  802a9b:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802a9e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802aa5:	83 ec 0c             	sub    $0xc,%esp
  802aa8:	68 94 46 80 00       	push   $0x804694
  802aad:	e8 f5 e5 ff ff       	call   8010a7 <cprintf>
  802ab2:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802ab5:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802ab9:	a1 40 50 80 00       	mov    0x805040,%eax
  802abe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ac1:	eb 56                	jmp    802b19 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802ac3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ac7:	74 1c                	je     802ae5 <print_mem_block_lists+0x114>
  802ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acc:	8b 50 08             	mov    0x8(%eax),%edx
  802acf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad2:	8b 48 08             	mov    0x8(%eax),%ecx
  802ad5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad8:	8b 40 0c             	mov    0xc(%eax),%eax
  802adb:	01 c8                	add    %ecx,%eax
  802add:	39 c2                	cmp    %eax,%edx
  802adf:	73 04                	jae    802ae5 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802ae1:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae8:	8b 50 08             	mov    0x8(%eax),%edx
  802aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aee:	8b 40 0c             	mov    0xc(%eax),%eax
  802af1:	01 c2                	add    %eax,%edx
  802af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af6:	8b 40 08             	mov    0x8(%eax),%eax
  802af9:	83 ec 04             	sub    $0x4,%esp
  802afc:	52                   	push   %edx
  802afd:	50                   	push   %eax
  802afe:	68 61 46 80 00       	push   $0x804661
  802b03:	e8 9f e5 ff ff       	call   8010a7 <cprintf>
  802b08:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802b11:	a1 48 50 80 00       	mov    0x805048,%eax
  802b16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b1d:	74 07                	je     802b26 <print_mem_block_lists+0x155>
  802b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b22:	8b 00                	mov    (%eax),%eax
  802b24:	eb 05                	jmp    802b2b <print_mem_block_lists+0x15a>
  802b26:	b8 00 00 00 00       	mov    $0x0,%eax
  802b2b:	a3 48 50 80 00       	mov    %eax,0x805048
  802b30:	a1 48 50 80 00       	mov    0x805048,%eax
  802b35:	85 c0                	test   %eax,%eax
  802b37:	75 8a                	jne    802ac3 <print_mem_block_lists+0xf2>
  802b39:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b3d:	75 84                	jne    802ac3 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802b3f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802b43:	75 10                	jne    802b55 <print_mem_block_lists+0x184>
  802b45:	83 ec 0c             	sub    $0xc,%esp
  802b48:	68 ac 46 80 00       	push   $0x8046ac
  802b4d:	e8 55 e5 ff ff       	call   8010a7 <cprintf>
  802b52:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802b55:	83 ec 0c             	sub    $0xc,%esp
  802b58:	68 20 46 80 00       	push   $0x804620
  802b5d:	e8 45 e5 ff ff       	call   8010a7 <cprintf>
  802b62:	83 c4 10             	add    $0x10,%esp

}
  802b65:	90                   	nop
  802b66:	c9                   	leave  
  802b67:	c3                   	ret    

00802b68 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802b68:	55                   	push   %ebp
  802b69:	89 e5                	mov    %esp,%ebp
  802b6b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  802b6e:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802b75:	00 00 00 
  802b78:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802b7f:	00 00 00 
  802b82:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802b89:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802b8c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802b93:	e9 9e 00 00 00       	jmp    802c36 <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802b98:	a1 50 50 80 00       	mov    0x805050,%eax
  802b9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ba0:	c1 e2 04             	shl    $0x4,%edx
  802ba3:	01 d0                	add    %edx,%eax
  802ba5:	85 c0                	test   %eax,%eax
  802ba7:	75 14                	jne    802bbd <initialize_MemBlocksList+0x55>
  802ba9:	83 ec 04             	sub    $0x4,%esp
  802bac:	68 d4 46 80 00       	push   $0x8046d4
  802bb1:	6a 47                	push   $0x47
  802bb3:	68 f7 46 80 00       	push   $0x8046f7
  802bb8:	e8 36 e2 ff ff       	call   800df3 <_panic>
  802bbd:	a1 50 50 80 00       	mov    0x805050,%eax
  802bc2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bc5:	c1 e2 04             	shl    $0x4,%edx
  802bc8:	01 d0                	add    %edx,%eax
  802bca:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802bd0:	89 10                	mov    %edx,(%eax)
  802bd2:	8b 00                	mov    (%eax),%eax
  802bd4:	85 c0                	test   %eax,%eax
  802bd6:	74 18                	je     802bf0 <initialize_MemBlocksList+0x88>
  802bd8:	a1 48 51 80 00       	mov    0x805148,%eax
  802bdd:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802be3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802be6:	c1 e1 04             	shl    $0x4,%ecx
  802be9:	01 ca                	add    %ecx,%edx
  802beb:	89 50 04             	mov    %edx,0x4(%eax)
  802bee:	eb 12                	jmp    802c02 <initialize_MemBlocksList+0x9a>
  802bf0:	a1 50 50 80 00       	mov    0x805050,%eax
  802bf5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bf8:	c1 e2 04             	shl    $0x4,%edx
  802bfb:	01 d0                	add    %edx,%eax
  802bfd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c02:	a1 50 50 80 00       	mov    0x805050,%eax
  802c07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c0a:	c1 e2 04             	shl    $0x4,%edx
  802c0d:	01 d0                	add    %edx,%eax
  802c0f:	a3 48 51 80 00       	mov    %eax,0x805148
  802c14:	a1 50 50 80 00       	mov    0x805050,%eax
  802c19:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c1c:	c1 e2 04             	shl    $0x4,%edx
  802c1f:	01 d0                	add    %edx,%eax
  802c21:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c28:	a1 54 51 80 00       	mov    0x805154,%eax
  802c2d:	40                   	inc    %eax
  802c2e:	a3 54 51 80 00       	mov    %eax,0x805154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802c33:	ff 45 f4             	incl   -0xc(%ebp)
  802c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c39:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c3c:	0f 82 56 ff ff ff    	jb     802b98 <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  802c42:	90                   	nop
  802c43:	c9                   	leave  
  802c44:	c3                   	ret    

00802c45 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802c45:	55                   	push   %ebp
  802c46:	89 e5                	mov    %esp,%ebp
  802c48:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4e:	8b 00                	mov    (%eax),%eax
  802c50:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802c53:	eb 19                	jmp    802c6e <find_block+0x29>
	{
		if(element->sva == va){
  802c55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c58:	8b 40 08             	mov    0x8(%eax),%eax
  802c5b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802c5e:	75 05                	jne    802c65 <find_block+0x20>
			 		return element;
  802c60:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c63:	eb 36                	jmp    802c9b <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802c65:	8b 45 08             	mov    0x8(%ebp),%eax
  802c68:	8b 40 08             	mov    0x8(%eax),%eax
  802c6b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802c6e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802c72:	74 07                	je     802c7b <find_block+0x36>
  802c74:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c77:	8b 00                	mov    (%eax),%eax
  802c79:	eb 05                	jmp    802c80 <find_block+0x3b>
  802c7b:	b8 00 00 00 00       	mov    $0x0,%eax
  802c80:	8b 55 08             	mov    0x8(%ebp),%edx
  802c83:	89 42 08             	mov    %eax,0x8(%edx)
  802c86:	8b 45 08             	mov    0x8(%ebp),%eax
  802c89:	8b 40 08             	mov    0x8(%eax),%eax
  802c8c:	85 c0                	test   %eax,%eax
  802c8e:	75 c5                	jne    802c55 <find_block+0x10>
  802c90:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802c94:	75 bf                	jne    802c55 <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  802c96:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c9b:	c9                   	leave  
  802c9c:	c3                   	ret    

00802c9d <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802c9d:	55                   	push   %ebp
  802c9e:	89 e5                	mov    %esp,%ebp
  802ca0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  802ca3:	a1 44 50 80 00       	mov    0x805044,%eax
  802ca8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  802cab:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802cb0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  802cb3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802cb7:	74 0a                	je     802cc3 <insert_sorted_allocList+0x26>
  802cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbc:	8b 40 08             	mov    0x8(%eax),%eax
  802cbf:	85 c0                	test   %eax,%eax
  802cc1:	75 65                	jne    802d28 <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802cc3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cc7:	75 14                	jne    802cdd <insert_sorted_allocList+0x40>
  802cc9:	83 ec 04             	sub    $0x4,%esp
  802ccc:	68 d4 46 80 00       	push   $0x8046d4
  802cd1:	6a 6e                	push   $0x6e
  802cd3:	68 f7 46 80 00       	push   $0x8046f7
  802cd8:	e8 16 e1 ff ff       	call   800df3 <_panic>
  802cdd:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce6:	89 10                	mov    %edx,(%eax)
  802ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ceb:	8b 00                	mov    (%eax),%eax
  802ced:	85 c0                	test   %eax,%eax
  802cef:	74 0d                	je     802cfe <insert_sorted_allocList+0x61>
  802cf1:	a1 40 50 80 00       	mov    0x805040,%eax
  802cf6:	8b 55 08             	mov    0x8(%ebp),%edx
  802cf9:	89 50 04             	mov    %edx,0x4(%eax)
  802cfc:	eb 08                	jmp    802d06 <insert_sorted_allocList+0x69>
  802cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802d01:	a3 44 50 80 00       	mov    %eax,0x805044
  802d06:	8b 45 08             	mov    0x8(%ebp),%eax
  802d09:	a3 40 50 80 00       	mov    %eax,0x805040
  802d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d11:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d18:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802d1d:	40                   	inc    %eax
  802d1e:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802d23:	e9 cf 01 00 00       	jmp    802ef7 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  802d28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2b:	8b 50 08             	mov    0x8(%eax),%edx
  802d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d31:	8b 40 08             	mov    0x8(%eax),%eax
  802d34:	39 c2                	cmp    %eax,%edx
  802d36:	73 65                	jae    802d9d <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802d38:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d3c:	75 14                	jne    802d52 <insert_sorted_allocList+0xb5>
  802d3e:	83 ec 04             	sub    $0x4,%esp
  802d41:	68 10 47 80 00       	push   $0x804710
  802d46:	6a 72                	push   $0x72
  802d48:	68 f7 46 80 00       	push   $0x8046f7
  802d4d:	e8 a1 e0 ff ff       	call   800df3 <_panic>
  802d52:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802d58:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5b:	89 50 04             	mov    %edx,0x4(%eax)
  802d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d61:	8b 40 04             	mov    0x4(%eax),%eax
  802d64:	85 c0                	test   %eax,%eax
  802d66:	74 0c                	je     802d74 <insert_sorted_allocList+0xd7>
  802d68:	a1 44 50 80 00       	mov    0x805044,%eax
  802d6d:	8b 55 08             	mov    0x8(%ebp),%edx
  802d70:	89 10                	mov    %edx,(%eax)
  802d72:	eb 08                	jmp    802d7c <insert_sorted_allocList+0xdf>
  802d74:	8b 45 08             	mov    0x8(%ebp),%eax
  802d77:	a3 40 50 80 00       	mov    %eax,0x805040
  802d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7f:	a3 44 50 80 00       	mov    %eax,0x805044
  802d84:	8b 45 08             	mov    0x8(%ebp),%eax
  802d87:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d8d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802d92:	40                   	inc    %eax
  802d93:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  802d98:	e9 5a 01 00 00       	jmp    802ef7 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  802d9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da0:	8b 50 08             	mov    0x8(%eax),%edx
  802da3:	8b 45 08             	mov    0x8(%ebp),%eax
  802da6:	8b 40 08             	mov    0x8(%eax),%eax
  802da9:	39 c2                	cmp    %eax,%edx
  802dab:	75 70                	jne    802e1d <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  802dad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802db1:	74 06                	je     802db9 <insert_sorted_allocList+0x11c>
  802db3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802db7:	75 14                	jne    802dcd <insert_sorted_allocList+0x130>
  802db9:	83 ec 04             	sub    $0x4,%esp
  802dbc:	68 34 47 80 00       	push   $0x804734
  802dc1:	6a 75                	push   $0x75
  802dc3:	68 f7 46 80 00       	push   $0x8046f7
  802dc8:	e8 26 e0 ff ff       	call   800df3 <_panic>
  802dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd0:	8b 10                	mov    (%eax),%edx
  802dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd5:	89 10                	mov    %edx,(%eax)
  802dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dda:	8b 00                	mov    (%eax),%eax
  802ddc:	85 c0                	test   %eax,%eax
  802dde:	74 0b                	je     802deb <insert_sorted_allocList+0x14e>
  802de0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de3:	8b 00                	mov    (%eax),%eax
  802de5:	8b 55 08             	mov    0x8(%ebp),%edx
  802de8:	89 50 04             	mov    %edx,0x4(%eax)
  802deb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dee:	8b 55 08             	mov    0x8(%ebp),%edx
  802df1:	89 10                	mov    %edx,(%eax)
  802df3:	8b 45 08             	mov    0x8(%ebp),%eax
  802df6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802df9:	89 50 04             	mov    %edx,0x4(%eax)
  802dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dff:	8b 00                	mov    (%eax),%eax
  802e01:	85 c0                	test   %eax,%eax
  802e03:	75 08                	jne    802e0d <insert_sorted_allocList+0x170>
  802e05:	8b 45 08             	mov    0x8(%ebp),%eax
  802e08:	a3 44 50 80 00       	mov    %eax,0x805044
  802e0d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802e12:	40                   	inc    %eax
  802e13:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  802e18:	e9 da 00 00 00       	jmp    802ef7 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802e1d:	a1 40 50 80 00       	mov    0x805040,%eax
  802e22:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e25:	e9 9d 00 00 00       	jmp    802ec7 <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  802e2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2d:	8b 00                	mov    (%eax),%eax
  802e2f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  802e32:	8b 45 08             	mov    0x8(%ebp),%eax
  802e35:	8b 50 08             	mov    0x8(%eax),%edx
  802e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3b:	8b 40 08             	mov    0x8(%eax),%eax
  802e3e:	39 c2                	cmp    %eax,%edx
  802e40:	76 7d                	jbe    802ebf <insert_sorted_allocList+0x222>
  802e42:	8b 45 08             	mov    0x8(%ebp),%eax
  802e45:	8b 50 08             	mov    0x8(%eax),%edx
  802e48:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e4b:	8b 40 08             	mov    0x8(%eax),%eax
  802e4e:	39 c2                	cmp    %eax,%edx
  802e50:	73 6d                	jae    802ebf <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802e52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e56:	74 06                	je     802e5e <insert_sorted_allocList+0x1c1>
  802e58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e5c:	75 14                	jne    802e72 <insert_sorted_allocList+0x1d5>
  802e5e:	83 ec 04             	sub    $0x4,%esp
  802e61:	68 34 47 80 00       	push   $0x804734
  802e66:	6a 7c                	push   $0x7c
  802e68:	68 f7 46 80 00       	push   $0x8046f7
  802e6d:	e8 81 df ff ff       	call   800df3 <_panic>
  802e72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e75:	8b 10                	mov    (%eax),%edx
  802e77:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7a:	89 10                	mov    %edx,(%eax)
  802e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7f:	8b 00                	mov    (%eax),%eax
  802e81:	85 c0                	test   %eax,%eax
  802e83:	74 0b                	je     802e90 <insert_sorted_allocList+0x1f3>
  802e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e88:	8b 00                	mov    (%eax),%eax
  802e8a:	8b 55 08             	mov    0x8(%ebp),%edx
  802e8d:	89 50 04             	mov    %edx,0x4(%eax)
  802e90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e93:	8b 55 08             	mov    0x8(%ebp),%edx
  802e96:	89 10                	mov    %edx,(%eax)
  802e98:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e9e:	89 50 04             	mov    %edx,0x4(%eax)
  802ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea4:	8b 00                	mov    (%eax),%eax
  802ea6:	85 c0                	test   %eax,%eax
  802ea8:	75 08                	jne    802eb2 <insert_sorted_allocList+0x215>
  802eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  802ead:	a3 44 50 80 00       	mov    %eax,0x805044
  802eb2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802eb7:	40                   	inc    %eax
  802eb8:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802ebd:	eb 38                	jmp    802ef7 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802ebf:	a1 48 50 80 00       	mov    0x805048,%eax
  802ec4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ec7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ecb:	74 07                	je     802ed4 <insert_sorted_allocList+0x237>
  802ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed0:	8b 00                	mov    (%eax),%eax
  802ed2:	eb 05                	jmp    802ed9 <insert_sorted_allocList+0x23c>
  802ed4:	b8 00 00 00 00       	mov    $0x0,%eax
  802ed9:	a3 48 50 80 00       	mov    %eax,0x805048
  802ede:	a1 48 50 80 00       	mov    0x805048,%eax
  802ee3:	85 c0                	test   %eax,%eax
  802ee5:	0f 85 3f ff ff ff    	jne    802e2a <insert_sorted_allocList+0x18d>
  802eeb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eef:	0f 85 35 ff ff ff    	jne    802e2a <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  802ef5:	eb 00                	jmp    802ef7 <insert_sorted_allocList+0x25a>
  802ef7:	90                   	nop
  802ef8:	c9                   	leave  
  802ef9:	c3                   	ret    

00802efa <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802efa:	55                   	push   %ebp
  802efb:	89 e5                	mov    %esp,%ebp
  802efd:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802f00:	a1 38 51 80 00       	mov    0x805138,%eax
  802f05:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f08:	e9 6b 02 00 00       	jmp    803178 <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  802f0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f10:	8b 40 0c             	mov    0xc(%eax),%eax
  802f13:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f16:	0f 85 90 00 00 00    	jne    802fac <alloc_block_FF+0xb2>
			  temp=element;
  802f1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  802f22:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f26:	75 17                	jne    802f3f <alloc_block_FF+0x45>
  802f28:	83 ec 04             	sub    $0x4,%esp
  802f2b:	68 68 47 80 00       	push   $0x804768
  802f30:	68 92 00 00 00       	push   $0x92
  802f35:	68 f7 46 80 00       	push   $0x8046f7
  802f3a:	e8 b4 de ff ff       	call   800df3 <_panic>
  802f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f42:	8b 00                	mov    (%eax),%eax
  802f44:	85 c0                	test   %eax,%eax
  802f46:	74 10                	je     802f58 <alloc_block_FF+0x5e>
  802f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4b:	8b 00                	mov    (%eax),%eax
  802f4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f50:	8b 52 04             	mov    0x4(%edx),%edx
  802f53:	89 50 04             	mov    %edx,0x4(%eax)
  802f56:	eb 0b                	jmp    802f63 <alloc_block_FF+0x69>
  802f58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5b:	8b 40 04             	mov    0x4(%eax),%eax
  802f5e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f66:	8b 40 04             	mov    0x4(%eax),%eax
  802f69:	85 c0                	test   %eax,%eax
  802f6b:	74 0f                	je     802f7c <alloc_block_FF+0x82>
  802f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f70:	8b 40 04             	mov    0x4(%eax),%eax
  802f73:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f76:	8b 12                	mov    (%edx),%edx
  802f78:	89 10                	mov    %edx,(%eax)
  802f7a:	eb 0a                	jmp    802f86 <alloc_block_FF+0x8c>
  802f7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7f:	8b 00                	mov    (%eax),%eax
  802f81:	a3 38 51 80 00       	mov    %eax,0x805138
  802f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f89:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f92:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f99:	a1 44 51 80 00       	mov    0x805144,%eax
  802f9e:	48                   	dec    %eax
  802f9f:	a3 44 51 80 00       	mov    %eax,0x805144
			  return temp;
  802fa4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa7:	e9 ff 01 00 00       	jmp    8031ab <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  802fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802faf:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fb5:	0f 86 b5 01 00 00    	jbe    803170 <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  802fbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbe:	8b 40 0c             	mov    0xc(%eax),%eax
  802fc1:	2b 45 08             	sub    0x8(%ebp),%eax
  802fc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  802fc7:	a1 48 51 80 00       	mov    0x805148,%eax
  802fcc:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  802fcf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802fd3:	75 17                	jne    802fec <alloc_block_FF+0xf2>
  802fd5:	83 ec 04             	sub    $0x4,%esp
  802fd8:	68 68 47 80 00       	push   $0x804768
  802fdd:	68 99 00 00 00       	push   $0x99
  802fe2:	68 f7 46 80 00       	push   $0x8046f7
  802fe7:	e8 07 de ff ff       	call   800df3 <_panic>
  802fec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fef:	8b 00                	mov    (%eax),%eax
  802ff1:	85 c0                	test   %eax,%eax
  802ff3:	74 10                	je     803005 <alloc_block_FF+0x10b>
  802ff5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ff8:	8b 00                	mov    (%eax),%eax
  802ffa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ffd:	8b 52 04             	mov    0x4(%edx),%edx
  803000:	89 50 04             	mov    %edx,0x4(%eax)
  803003:	eb 0b                	jmp    803010 <alloc_block_FF+0x116>
  803005:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803008:	8b 40 04             	mov    0x4(%eax),%eax
  80300b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803010:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803013:	8b 40 04             	mov    0x4(%eax),%eax
  803016:	85 c0                	test   %eax,%eax
  803018:	74 0f                	je     803029 <alloc_block_FF+0x12f>
  80301a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80301d:	8b 40 04             	mov    0x4(%eax),%eax
  803020:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803023:	8b 12                	mov    (%edx),%edx
  803025:	89 10                	mov    %edx,(%eax)
  803027:	eb 0a                	jmp    803033 <alloc_block_FF+0x139>
  803029:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80302c:	8b 00                	mov    (%eax),%eax
  80302e:	a3 48 51 80 00       	mov    %eax,0x805148
  803033:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803036:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80303c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80303f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803046:	a1 54 51 80 00       	mov    0x805154,%eax
  80304b:	48                   	dec    %eax
  80304c:	a3 54 51 80 00       	mov    %eax,0x805154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  803051:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803055:	75 17                	jne    80306e <alloc_block_FF+0x174>
  803057:	83 ec 04             	sub    $0x4,%esp
  80305a:	68 10 47 80 00       	push   $0x804710
  80305f:	68 9a 00 00 00       	push   $0x9a
  803064:	68 f7 46 80 00       	push   $0x8046f7
  803069:	e8 85 dd ff ff       	call   800df3 <_panic>
  80306e:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803074:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803077:	89 50 04             	mov    %edx,0x4(%eax)
  80307a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80307d:	8b 40 04             	mov    0x4(%eax),%eax
  803080:	85 c0                	test   %eax,%eax
  803082:	74 0c                	je     803090 <alloc_block_FF+0x196>
  803084:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803089:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80308c:	89 10                	mov    %edx,(%eax)
  80308e:	eb 08                	jmp    803098 <alloc_block_FF+0x19e>
  803090:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803093:	a3 38 51 80 00       	mov    %eax,0x805138
  803098:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80309b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030a9:	a1 44 51 80 00       	mov    0x805144,%eax
  8030ae:	40                   	inc    %eax
  8030af:	a3 44 51 80 00       	mov    %eax,0x805144
		  // setting the size & sva
		  new_block->size=size;
  8030b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8030ba:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  8030bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c0:	8b 50 08             	mov    0x8(%eax),%edx
  8030c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030c6:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  8030c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030cf:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  8030d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d5:	8b 50 08             	mov    0x8(%eax),%edx
  8030d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030db:	01 c2                	add    %eax,%edx
  8030dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e0:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  8030e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030e6:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  8030e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8030ed:	75 17                	jne    803106 <alloc_block_FF+0x20c>
  8030ef:	83 ec 04             	sub    $0x4,%esp
  8030f2:	68 68 47 80 00       	push   $0x804768
  8030f7:	68 a2 00 00 00       	push   $0xa2
  8030fc:	68 f7 46 80 00       	push   $0x8046f7
  803101:	e8 ed dc ff ff       	call   800df3 <_panic>
  803106:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803109:	8b 00                	mov    (%eax),%eax
  80310b:	85 c0                	test   %eax,%eax
  80310d:	74 10                	je     80311f <alloc_block_FF+0x225>
  80310f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803112:	8b 00                	mov    (%eax),%eax
  803114:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803117:	8b 52 04             	mov    0x4(%edx),%edx
  80311a:	89 50 04             	mov    %edx,0x4(%eax)
  80311d:	eb 0b                	jmp    80312a <alloc_block_FF+0x230>
  80311f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803122:	8b 40 04             	mov    0x4(%eax),%eax
  803125:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80312a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80312d:	8b 40 04             	mov    0x4(%eax),%eax
  803130:	85 c0                	test   %eax,%eax
  803132:	74 0f                	je     803143 <alloc_block_FF+0x249>
  803134:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803137:	8b 40 04             	mov    0x4(%eax),%eax
  80313a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80313d:	8b 12                	mov    (%edx),%edx
  80313f:	89 10                	mov    %edx,(%eax)
  803141:	eb 0a                	jmp    80314d <alloc_block_FF+0x253>
  803143:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803146:	8b 00                	mov    (%eax),%eax
  803148:	a3 38 51 80 00       	mov    %eax,0x805138
  80314d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803150:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803156:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803159:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803160:	a1 44 51 80 00       	mov    0x805144,%eax
  803165:	48                   	dec    %eax
  803166:	a3 44 51 80 00       	mov    %eax,0x805144
		  return temp;
  80316b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80316e:	eb 3b                	jmp    8031ab <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  803170:	a1 40 51 80 00       	mov    0x805140,%eax
  803175:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803178:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80317c:	74 07                	je     803185 <alloc_block_FF+0x28b>
  80317e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803181:	8b 00                	mov    (%eax),%eax
  803183:	eb 05                	jmp    80318a <alloc_block_FF+0x290>
  803185:	b8 00 00 00 00       	mov    $0x0,%eax
  80318a:	a3 40 51 80 00       	mov    %eax,0x805140
  80318f:	a1 40 51 80 00       	mov    0x805140,%eax
  803194:	85 c0                	test   %eax,%eax
  803196:	0f 85 71 fd ff ff    	jne    802f0d <alloc_block_FF+0x13>
  80319c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031a0:	0f 85 67 fd ff ff    	jne    802f0d <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  8031a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031ab:	c9                   	leave  
  8031ac:	c3                   	ret    

008031ad <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8031ad:	55                   	push   %ebp
  8031ae:	89 e5                	mov    %esp,%ebp
  8031b0:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  8031b3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  8031ba:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  8031c1:	a1 38 51 80 00       	mov    0x805138,%eax
  8031c6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8031c9:	e9 d3 00 00 00       	jmp    8032a1 <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  8031ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8031d4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031d7:	0f 85 90 00 00 00    	jne    80326d <alloc_block_BF+0xc0>
	   temp = element;
  8031dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e0:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  8031e3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031e7:	75 17                	jne    803200 <alloc_block_BF+0x53>
  8031e9:	83 ec 04             	sub    $0x4,%esp
  8031ec:	68 68 47 80 00       	push   $0x804768
  8031f1:	68 bd 00 00 00       	push   $0xbd
  8031f6:	68 f7 46 80 00       	push   $0x8046f7
  8031fb:	e8 f3 db ff ff       	call   800df3 <_panic>
  803200:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803203:	8b 00                	mov    (%eax),%eax
  803205:	85 c0                	test   %eax,%eax
  803207:	74 10                	je     803219 <alloc_block_BF+0x6c>
  803209:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80320c:	8b 00                	mov    (%eax),%eax
  80320e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803211:	8b 52 04             	mov    0x4(%edx),%edx
  803214:	89 50 04             	mov    %edx,0x4(%eax)
  803217:	eb 0b                	jmp    803224 <alloc_block_BF+0x77>
  803219:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321c:	8b 40 04             	mov    0x4(%eax),%eax
  80321f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803224:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803227:	8b 40 04             	mov    0x4(%eax),%eax
  80322a:	85 c0                	test   %eax,%eax
  80322c:	74 0f                	je     80323d <alloc_block_BF+0x90>
  80322e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803231:	8b 40 04             	mov    0x4(%eax),%eax
  803234:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803237:	8b 12                	mov    (%edx),%edx
  803239:	89 10                	mov    %edx,(%eax)
  80323b:	eb 0a                	jmp    803247 <alloc_block_BF+0x9a>
  80323d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803240:	8b 00                	mov    (%eax),%eax
  803242:	a3 38 51 80 00       	mov    %eax,0x805138
  803247:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803250:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803253:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80325a:	a1 44 51 80 00       	mov    0x805144,%eax
  80325f:	48                   	dec    %eax
  803260:	a3 44 51 80 00       	mov    %eax,0x805144
	   return temp;
  803265:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803268:	e9 41 01 00 00       	jmp    8033ae <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  80326d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803270:	8b 40 0c             	mov    0xc(%eax),%eax
  803273:	3b 45 08             	cmp    0x8(%ebp),%eax
  803276:	76 21                	jbe    803299 <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  803278:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80327b:	8b 40 0c             	mov    0xc(%eax),%eax
  80327e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803281:	73 16                	jae    803299 <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  803283:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803286:	8b 40 0c             	mov    0xc(%eax),%eax
  803289:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  80328c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  803292:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  803299:	a1 40 51 80 00       	mov    0x805140,%eax
  80329e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8032a1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032a5:	74 07                	je     8032ae <alloc_block_BF+0x101>
  8032a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032aa:	8b 00                	mov    (%eax),%eax
  8032ac:	eb 05                	jmp    8032b3 <alloc_block_BF+0x106>
  8032ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8032b3:	a3 40 51 80 00       	mov    %eax,0x805140
  8032b8:	a1 40 51 80 00       	mov    0x805140,%eax
  8032bd:	85 c0                	test   %eax,%eax
  8032bf:	0f 85 09 ff ff ff    	jne    8031ce <alloc_block_BF+0x21>
  8032c5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032c9:	0f 85 ff fe ff ff    	jne    8031ce <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  8032cf:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  8032d3:	0f 85 d0 00 00 00    	jne    8033a9 <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  8032d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8032df:	2b 45 08             	sub    0x8(%ebp),%eax
  8032e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  8032e5:	a1 48 51 80 00       	mov    0x805148,%eax
  8032ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  8032ed:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8032f1:	75 17                	jne    80330a <alloc_block_BF+0x15d>
  8032f3:	83 ec 04             	sub    $0x4,%esp
  8032f6:	68 68 47 80 00       	push   $0x804768
  8032fb:	68 d1 00 00 00       	push   $0xd1
  803300:	68 f7 46 80 00       	push   $0x8046f7
  803305:	e8 e9 da ff ff       	call   800df3 <_panic>
  80330a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80330d:	8b 00                	mov    (%eax),%eax
  80330f:	85 c0                	test   %eax,%eax
  803311:	74 10                	je     803323 <alloc_block_BF+0x176>
  803313:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803316:	8b 00                	mov    (%eax),%eax
  803318:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80331b:	8b 52 04             	mov    0x4(%edx),%edx
  80331e:	89 50 04             	mov    %edx,0x4(%eax)
  803321:	eb 0b                	jmp    80332e <alloc_block_BF+0x181>
  803323:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803326:	8b 40 04             	mov    0x4(%eax),%eax
  803329:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80332e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803331:	8b 40 04             	mov    0x4(%eax),%eax
  803334:	85 c0                	test   %eax,%eax
  803336:	74 0f                	je     803347 <alloc_block_BF+0x19a>
  803338:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80333b:	8b 40 04             	mov    0x4(%eax),%eax
  80333e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803341:	8b 12                	mov    (%edx),%edx
  803343:	89 10                	mov    %edx,(%eax)
  803345:	eb 0a                	jmp    803351 <alloc_block_BF+0x1a4>
  803347:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80334a:	8b 00                	mov    (%eax),%eax
  80334c:	a3 48 51 80 00       	mov    %eax,0x805148
  803351:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803354:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80335a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80335d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803364:	a1 54 51 80 00       	mov    0x805154,%eax
  803369:	48                   	dec    %eax
  80336a:	a3 54 51 80 00       	mov    %eax,0x805154
	  // setting the size & sva
	  new_block->size = size;
  80336f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803372:	8b 55 08             	mov    0x8(%ebp),%edx
  803375:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  803378:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80337b:	8b 50 08             	mov    0x8(%eax),%edx
  80337e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803381:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  803384:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803387:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80338a:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  80338d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803390:	8b 50 08             	mov    0x8(%eax),%edx
  803393:	8b 45 08             	mov    0x8(%ebp),%eax
  803396:	01 c2                	add    %eax,%edx
  803398:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80339b:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  80339e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033a1:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  8033a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033a7:	eb 05                	jmp    8033ae <alloc_block_BF+0x201>
	 }
	 return NULL;
  8033a9:	b8 00 00 00 00       	mov    $0x0,%eax


}
  8033ae:	c9                   	leave  
  8033af:	c3                   	ret    

008033b0 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8033b0:	55                   	push   %ebp
  8033b1:	89 e5                	mov    %esp,%ebp
  8033b3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  8033b6:	83 ec 04             	sub    $0x4,%esp
  8033b9:	68 88 47 80 00       	push   $0x804788
  8033be:	68 e8 00 00 00       	push   $0xe8
  8033c3:	68 f7 46 80 00       	push   $0x8046f7
  8033c8:	e8 26 da ff ff       	call   800df3 <_panic>

008033cd <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8033cd:	55                   	push   %ebp
  8033ce:	89 e5                	mov    %esp,%ebp
  8033d0:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  8033d3:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8033d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  8033db:	a1 38 51 80 00       	mov    0x805138,%eax
  8033e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  8033e3:	a1 44 51 80 00       	mov    0x805144,%eax
  8033e8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  8033eb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033ef:	75 68                	jne    803459 <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8033f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033f5:	75 17                	jne    80340e <insert_sorted_with_merge_freeList+0x41>
  8033f7:	83 ec 04             	sub    $0x4,%esp
  8033fa:	68 d4 46 80 00       	push   $0x8046d4
  8033ff:	68 36 01 00 00       	push   $0x136
  803404:	68 f7 46 80 00       	push   $0x8046f7
  803409:	e8 e5 d9 ff ff       	call   800df3 <_panic>
  80340e:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803414:	8b 45 08             	mov    0x8(%ebp),%eax
  803417:	89 10                	mov    %edx,(%eax)
  803419:	8b 45 08             	mov    0x8(%ebp),%eax
  80341c:	8b 00                	mov    (%eax),%eax
  80341e:	85 c0                	test   %eax,%eax
  803420:	74 0d                	je     80342f <insert_sorted_with_merge_freeList+0x62>
  803422:	a1 38 51 80 00       	mov    0x805138,%eax
  803427:	8b 55 08             	mov    0x8(%ebp),%edx
  80342a:	89 50 04             	mov    %edx,0x4(%eax)
  80342d:	eb 08                	jmp    803437 <insert_sorted_with_merge_freeList+0x6a>
  80342f:	8b 45 08             	mov    0x8(%ebp),%eax
  803432:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803437:	8b 45 08             	mov    0x8(%ebp),%eax
  80343a:	a3 38 51 80 00       	mov    %eax,0x805138
  80343f:	8b 45 08             	mov    0x8(%ebp),%eax
  803442:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803449:	a1 44 51 80 00       	mov    0x805144,%eax
  80344e:	40                   	inc    %eax
  80344f:	a3 44 51 80 00       	mov    %eax,0x805144





}
  803454:	e9 ba 06 00 00       	jmp    803b13 <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  803459:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80345c:	8b 50 08             	mov    0x8(%eax),%edx
  80345f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803462:	8b 40 0c             	mov    0xc(%eax),%eax
  803465:	01 c2                	add    %eax,%edx
  803467:	8b 45 08             	mov    0x8(%ebp),%eax
  80346a:	8b 40 08             	mov    0x8(%eax),%eax
  80346d:	39 c2                	cmp    %eax,%edx
  80346f:	73 68                	jae    8034d9 <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803471:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803475:	75 17                	jne    80348e <insert_sorted_with_merge_freeList+0xc1>
  803477:	83 ec 04             	sub    $0x4,%esp
  80347a:	68 10 47 80 00       	push   $0x804710
  80347f:	68 3a 01 00 00       	push   $0x13a
  803484:	68 f7 46 80 00       	push   $0x8046f7
  803489:	e8 65 d9 ff ff       	call   800df3 <_panic>
  80348e:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803494:	8b 45 08             	mov    0x8(%ebp),%eax
  803497:	89 50 04             	mov    %edx,0x4(%eax)
  80349a:	8b 45 08             	mov    0x8(%ebp),%eax
  80349d:	8b 40 04             	mov    0x4(%eax),%eax
  8034a0:	85 c0                	test   %eax,%eax
  8034a2:	74 0c                	je     8034b0 <insert_sorted_with_merge_freeList+0xe3>
  8034a4:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8034a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8034ac:	89 10                	mov    %edx,(%eax)
  8034ae:	eb 08                	jmp    8034b8 <insert_sorted_with_merge_freeList+0xeb>
  8034b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b3:	a3 38 51 80 00       	mov    %eax,0x805138
  8034b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034bb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034c9:	a1 44 51 80 00       	mov    0x805144,%eax
  8034ce:	40                   	inc    %eax
  8034cf:	a3 44 51 80 00       	mov    %eax,0x805144





}
  8034d4:	e9 3a 06 00 00       	jmp    803b13 <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  8034d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034dc:	8b 50 08             	mov    0x8(%eax),%edx
  8034df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8034e5:	01 c2                	add    %eax,%edx
  8034e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ea:	8b 40 08             	mov    0x8(%eax),%eax
  8034ed:	39 c2                	cmp    %eax,%edx
  8034ef:	0f 85 90 00 00 00    	jne    803585 <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  8034f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034f8:	8b 50 0c             	mov    0xc(%eax),%edx
  8034fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fe:	8b 40 0c             	mov    0xc(%eax),%eax
  803501:	01 c2                	add    %eax,%edx
  803503:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803506:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  803509:	8b 45 08             	mov    0x8(%ebp),%eax
  80350c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  803513:	8b 45 08             	mov    0x8(%ebp),%eax
  803516:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80351d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803521:	75 17                	jne    80353a <insert_sorted_with_merge_freeList+0x16d>
  803523:	83 ec 04             	sub    $0x4,%esp
  803526:	68 d4 46 80 00       	push   $0x8046d4
  80352b:	68 41 01 00 00       	push   $0x141
  803530:	68 f7 46 80 00       	push   $0x8046f7
  803535:	e8 b9 d8 ff ff       	call   800df3 <_panic>
  80353a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803540:	8b 45 08             	mov    0x8(%ebp),%eax
  803543:	89 10                	mov    %edx,(%eax)
  803545:	8b 45 08             	mov    0x8(%ebp),%eax
  803548:	8b 00                	mov    (%eax),%eax
  80354a:	85 c0                	test   %eax,%eax
  80354c:	74 0d                	je     80355b <insert_sorted_with_merge_freeList+0x18e>
  80354e:	a1 48 51 80 00       	mov    0x805148,%eax
  803553:	8b 55 08             	mov    0x8(%ebp),%edx
  803556:	89 50 04             	mov    %edx,0x4(%eax)
  803559:	eb 08                	jmp    803563 <insert_sorted_with_merge_freeList+0x196>
  80355b:	8b 45 08             	mov    0x8(%ebp),%eax
  80355e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803563:	8b 45 08             	mov    0x8(%ebp),%eax
  803566:	a3 48 51 80 00       	mov    %eax,0x805148
  80356b:	8b 45 08             	mov    0x8(%ebp),%eax
  80356e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803575:	a1 54 51 80 00       	mov    0x805154,%eax
  80357a:	40                   	inc    %eax
  80357b:	a3 54 51 80 00       	mov    %eax,0x805154





}
  803580:	e9 8e 05 00 00       	jmp    803b13 <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  803585:	8b 45 08             	mov    0x8(%ebp),%eax
  803588:	8b 50 08             	mov    0x8(%eax),%edx
  80358b:	8b 45 08             	mov    0x8(%ebp),%eax
  80358e:	8b 40 0c             	mov    0xc(%eax),%eax
  803591:	01 c2                	add    %eax,%edx
  803593:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803596:	8b 40 08             	mov    0x8(%eax),%eax
  803599:	39 c2                	cmp    %eax,%edx
  80359b:	73 68                	jae    803605 <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80359d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035a1:	75 17                	jne    8035ba <insert_sorted_with_merge_freeList+0x1ed>
  8035a3:	83 ec 04             	sub    $0x4,%esp
  8035a6:	68 d4 46 80 00       	push   $0x8046d4
  8035ab:	68 45 01 00 00       	push   $0x145
  8035b0:	68 f7 46 80 00       	push   $0x8046f7
  8035b5:	e8 39 d8 ff ff       	call   800df3 <_panic>
  8035ba:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8035c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c3:	89 10                	mov    %edx,(%eax)
  8035c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c8:	8b 00                	mov    (%eax),%eax
  8035ca:	85 c0                	test   %eax,%eax
  8035cc:	74 0d                	je     8035db <insert_sorted_with_merge_freeList+0x20e>
  8035ce:	a1 38 51 80 00       	mov    0x805138,%eax
  8035d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8035d6:	89 50 04             	mov    %edx,0x4(%eax)
  8035d9:	eb 08                	jmp    8035e3 <insert_sorted_with_merge_freeList+0x216>
  8035db:	8b 45 08             	mov    0x8(%ebp),%eax
  8035de:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e6:	a3 38 51 80 00       	mov    %eax,0x805138
  8035eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035f5:	a1 44 51 80 00       	mov    0x805144,%eax
  8035fa:	40                   	inc    %eax
  8035fb:	a3 44 51 80 00       	mov    %eax,0x805144





}
  803600:	e9 0e 05 00 00       	jmp    803b13 <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  803605:	8b 45 08             	mov    0x8(%ebp),%eax
  803608:	8b 50 08             	mov    0x8(%eax),%edx
  80360b:	8b 45 08             	mov    0x8(%ebp),%eax
  80360e:	8b 40 0c             	mov    0xc(%eax),%eax
  803611:	01 c2                	add    %eax,%edx
  803613:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803616:	8b 40 08             	mov    0x8(%eax),%eax
  803619:	39 c2                	cmp    %eax,%edx
  80361b:	0f 85 9c 00 00 00    	jne    8036bd <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  803621:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803624:	8b 50 0c             	mov    0xc(%eax),%edx
  803627:	8b 45 08             	mov    0x8(%ebp),%eax
  80362a:	8b 40 0c             	mov    0xc(%eax),%eax
  80362d:	01 c2                	add    %eax,%edx
  80362f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803632:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  803635:	8b 45 08             	mov    0x8(%ebp),%eax
  803638:	8b 50 08             	mov    0x8(%eax),%edx
  80363b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80363e:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  803641:	8b 45 08             	mov    0x8(%ebp),%eax
  803644:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  80364b:	8b 45 08             	mov    0x8(%ebp),%eax
  80364e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803655:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803659:	75 17                	jne    803672 <insert_sorted_with_merge_freeList+0x2a5>
  80365b:	83 ec 04             	sub    $0x4,%esp
  80365e:	68 d4 46 80 00       	push   $0x8046d4
  803663:	68 4d 01 00 00       	push   $0x14d
  803668:	68 f7 46 80 00       	push   $0x8046f7
  80366d:	e8 81 d7 ff ff       	call   800df3 <_panic>
  803672:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803678:	8b 45 08             	mov    0x8(%ebp),%eax
  80367b:	89 10                	mov    %edx,(%eax)
  80367d:	8b 45 08             	mov    0x8(%ebp),%eax
  803680:	8b 00                	mov    (%eax),%eax
  803682:	85 c0                	test   %eax,%eax
  803684:	74 0d                	je     803693 <insert_sorted_with_merge_freeList+0x2c6>
  803686:	a1 48 51 80 00       	mov    0x805148,%eax
  80368b:	8b 55 08             	mov    0x8(%ebp),%edx
  80368e:	89 50 04             	mov    %edx,0x4(%eax)
  803691:	eb 08                	jmp    80369b <insert_sorted_with_merge_freeList+0x2ce>
  803693:	8b 45 08             	mov    0x8(%ebp),%eax
  803696:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80369b:	8b 45 08             	mov    0x8(%ebp),%eax
  80369e:	a3 48 51 80 00       	mov    %eax,0x805148
  8036a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036ad:	a1 54 51 80 00       	mov    0x805154,%eax
  8036b2:	40                   	inc    %eax
  8036b3:	a3 54 51 80 00       	mov    %eax,0x805154





}
  8036b8:	e9 56 04 00 00       	jmp    803b13 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  8036bd:	a1 38 51 80 00       	mov    0x805138,%eax
  8036c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036c5:	e9 19 04 00 00       	jmp    803ae3 <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  8036ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036cd:	8b 00                	mov    (%eax),%eax
  8036cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  8036d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d5:	8b 50 08             	mov    0x8(%eax),%edx
  8036d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036db:	8b 40 0c             	mov    0xc(%eax),%eax
  8036de:	01 c2                	add    %eax,%edx
  8036e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e3:	8b 40 08             	mov    0x8(%eax),%eax
  8036e6:	39 c2                	cmp    %eax,%edx
  8036e8:	0f 85 ad 01 00 00    	jne    80389b <insert_sorted_with_merge_freeList+0x4ce>
  8036ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f1:	8b 50 08             	mov    0x8(%eax),%edx
  8036f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8036fa:	01 c2                	add    %eax,%edx
  8036fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036ff:	8b 40 08             	mov    0x8(%eax),%eax
  803702:	39 c2                	cmp    %eax,%edx
  803704:	0f 85 91 01 00 00    	jne    80389b <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  80370a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80370d:	8b 50 0c             	mov    0xc(%eax),%edx
  803710:	8b 45 08             	mov    0x8(%ebp),%eax
  803713:	8b 48 0c             	mov    0xc(%eax),%ecx
  803716:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803719:	8b 40 0c             	mov    0xc(%eax),%eax
  80371c:	01 c8                	add    %ecx,%eax
  80371e:	01 c2                	add    %eax,%edx
  803720:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803723:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  803726:	8b 45 08             	mov    0x8(%ebp),%eax
  803729:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  803730:	8b 45 08             	mov    0x8(%ebp),%eax
  803733:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  80373a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80373d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  803744:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803747:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  80374e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803752:	75 17                	jne    80376b <insert_sorted_with_merge_freeList+0x39e>
  803754:	83 ec 04             	sub    $0x4,%esp
  803757:	68 68 47 80 00       	push   $0x804768
  80375c:	68 5b 01 00 00       	push   $0x15b
  803761:	68 f7 46 80 00       	push   $0x8046f7
  803766:	e8 88 d6 ff ff       	call   800df3 <_panic>
  80376b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80376e:	8b 00                	mov    (%eax),%eax
  803770:	85 c0                	test   %eax,%eax
  803772:	74 10                	je     803784 <insert_sorted_with_merge_freeList+0x3b7>
  803774:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803777:	8b 00                	mov    (%eax),%eax
  803779:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80377c:	8b 52 04             	mov    0x4(%edx),%edx
  80377f:	89 50 04             	mov    %edx,0x4(%eax)
  803782:	eb 0b                	jmp    80378f <insert_sorted_with_merge_freeList+0x3c2>
  803784:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803787:	8b 40 04             	mov    0x4(%eax),%eax
  80378a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80378f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803792:	8b 40 04             	mov    0x4(%eax),%eax
  803795:	85 c0                	test   %eax,%eax
  803797:	74 0f                	je     8037a8 <insert_sorted_with_merge_freeList+0x3db>
  803799:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80379c:	8b 40 04             	mov    0x4(%eax),%eax
  80379f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037a2:	8b 12                	mov    (%edx),%edx
  8037a4:	89 10                	mov    %edx,(%eax)
  8037a6:	eb 0a                	jmp    8037b2 <insert_sorted_with_merge_freeList+0x3e5>
  8037a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037ab:	8b 00                	mov    (%eax),%eax
  8037ad:	a3 38 51 80 00       	mov    %eax,0x805138
  8037b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037c5:	a1 44 51 80 00       	mov    0x805144,%eax
  8037ca:	48                   	dec    %eax
  8037cb:	a3 44 51 80 00       	mov    %eax,0x805144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8037d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037d4:	75 17                	jne    8037ed <insert_sorted_with_merge_freeList+0x420>
  8037d6:	83 ec 04             	sub    $0x4,%esp
  8037d9:	68 d4 46 80 00       	push   $0x8046d4
  8037de:	68 5c 01 00 00       	push   $0x15c
  8037e3:	68 f7 46 80 00       	push   $0x8046f7
  8037e8:	e8 06 d6 ff ff       	call   800df3 <_panic>
  8037ed:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8037f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f6:	89 10                	mov    %edx,(%eax)
  8037f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8037fb:	8b 00                	mov    (%eax),%eax
  8037fd:	85 c0                	test   %eax,%eax
  8037ff:	74 0d                	je     80380e <insert_sorted_with_merge_freeList+0x441>
  803801:	a1 48 51 80 00       	mov    0x805148,%eax
  803806:	8b 55 08             	mov    0x8(%ebp),%edx
  803809:	89 50 04             	mov    %edx,0x4(%eax)
  80380c:	eb 08                	jmp    803816 <insert_sorted_with_merge_freeList+0x449>
  80380e:	8b 45 08             	mov    0x8(%ebp),%eax
  803811:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803816:	8b 45 08             	mov    0x8(%ebp),%eax
  803819:	a3 48 51 80 00       	mov    %eax,0x805148
  80381e:	8b 45 08             	mov    0x8(%ebp),%eax
  803821:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803828:	a1 54 51 80 00       	mov    0x805154,%eax
  80382d:	40                   	inc    %eax
  80382e:	a3 54 51 80 00       	mov    %eax,0x805154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  803833:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803837:	75 17                	jne    803850 <insert_sorted_with_merge_freeList+0x483>
  803839:	83 ec 04             	sub    $0x4,%esp
  80383c:	68 d4 46 80 00       	push   $0x8046d4
  803841:	68 5d 01 00 00       	push   $0x15d
  803846:	68 f7 46 80 00       	push   $0x8046f7
  80384b:	e8 a3 d5 ff ff       	call   800df3 <_panic>
  803850:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803856:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803859:	89 10                	mov    %edx,(%eax)
  80385b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80385e:	8b 00                	mov    (%eax),%eax
  803860:	85 c0                	test   %eax,%eax
  803862:	74 0d                	je     803871 <insert_sorted_with_merge_freeList+0x4a4>
  803864:	a1 48 51 80 00       	mov    0x805148,%eax
  803869:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80386c:	89 50 04             	mov    %edx,0x4(%eax)
  80386f:	eb 08                	jmp    803879 <insert_sorted_with_merge_freeList+0x4ac>
  803871:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803874:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803879:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80387c:	a3 48 51 80 00       	mov    %eax,0x805148
  803881:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803884:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80388b:	a1 54 51 80 00       	mov    0x805154,%eax
  803890:	40                   	inc    %eax
  803891:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  803896:	e9 78 02 00 00       	jmp    803b13 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  80389b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80389e:	8b 50 08             	mov    0x8(%eax),%edx
  8038a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8038a7:	01 c2                	add    %eax,%edx
  8038a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ac:	8b 40 08             	mov    0x8(%eax),%eax
  8038af:	39 c2                	cmp    %eax,%edx
  8038b1:	0f 83 b8 00 00 00    	jae    80396f <insert_sorted_with_merge_freeList+0x5a2>
  8038b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ba:	8b 50 08             	mov    0x8(%eax),%edx
  8038bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8038c3:	01 c2                	add    %eax,%edx
  8038c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038c8:	8b 40 08             	mov    0x8(%eax),%eax
  8038cb:	39 c2                	cmp    %eax,%edx
  8038cd:	0f 85 9c 00 00 00    	jne    80396f <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  8038d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038d6:	8b 50 0c             	mov    0xc(%eax),%edx
  8038d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8038df:	01 c2                	add    %eax,%edx
  8038e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e4:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  8038e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ea:	8b 50 08             	mov    0x8(%eax),%edx
  8038ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f0:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  8038f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  8038fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803900:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803907:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80390b:	75 17                	jne    803924 <insert_sorted_with_merge_freeList+0x557>
  80390d:	83 ec 04             	sub    $0x4,%esp
  803910:	68 d4 46 80 00       	push   $0x8046d4
  803915:	68 67 01 00 00       	push   $0x167
  80391a:	68 f7 46 80 00       	push   $0x8046f7
  80391f:	e8 cf d4 ff ff       	call   800df3 <_panic>
  803924:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80392a:	8b 45 08             	mov    0x8(%ebp),%eax
  80392d:	89 10                	mov    %edx,(%eax)
  80392f:	8b 45 08             	mov    0x8(%ebp),%eax
  803932:	8b 00                	mov    (%eax),%eax
  803934:	85 c0                	test   %eax,%eax
  803936:	74 0d                	je     803945 <insert_sorted_with_merge_freeList+0x578>
  803938:	a1 48 51 80 00       	mov    0x805148,%eax
  80393d:	8b 55 08             	mov    0x8(%ebp),%edx
  803940:	89 50 04             	mov    %edx,0x4(%eax)
  803943:	eb 08                	jmp    80394d <insert_sorted_with_merge_freeList+0x580>
  803945:	8b 45 08             	mov    0x8(%ebp),%eax
  803948:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80394d:	8b 45 08             	mov    0x8(%ebp),%eax
  803950:	a3 48 51 80 00       	mov    %eax,0x805148
  803955:	8b 45 08             	mov    0x8(%ebp),%eax
  803958:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80395f:	a1 54 51 80 00       	mov    0x805154,%eax
  803964:	40                   	inc    %eax
  803965:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  80396a:	e9 a4 01 00 00       	jmp    803b13 <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  80396f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803972:	8b 50 08             	mov    0x8(%eax),%edx
  803975:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803978:	8b 40 0c             	mov    0xc(%eax),%eax
  80397b:	01 c2                	add    %eax,%edx
  80397d:	8b 45 08             	mov    0x8(%ebp),%eax
  803980:	8b 40 08             	mov    0x8(%eax),%eax
  803983:	39 c2                	cmp    %eax,%edx
  803985:	0f 85 ac 00 00 00    	jne    803a37 <insert_sorted_with_merge_freeList+0x66a>
  80398b:	8b 45 08             	mov    0x8(%ebp),%eax
  80398e:	8b 50 08             	mov    0x8(%eax),%edx
  803991:	8b 45 08             	mov    0x8(%ebp),%eax
  803994:	8b 40 0c             	mov    0xc(%eax),%eax
  803997:	01 c2                	add    %eax,%edx
  803999:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80399c:	8b 40 08             	mov    0x8(%eax),%eax
  80399f:	39 c2                	cmp    %eax,%edx
  8039a1:	0f 83 90 00 00 00    	jae    803a37 <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  8039a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039aa:	8b 50 0c             	mov    0xc(%eax),%edx
  8039ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8039b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8039b3:	01 c2                	add    %eax,%edx
  8039b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039b8:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  8039bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8039be:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  8039c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8039cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039d3:	75 17                	jne    8039ec <insert_sorted_with_merge_freeList+0x61f>
  8039d5:	83 ec 04             	sub    $0x4,%esp
  8039d8:	68 d4 46 80 00       	push   $0x8046d4
  8039dd:	68 70 01 00 00       	push   $0x170
  8039e2:	68 f7 46 80 00       	push   $0x8046f7
  8039e7:	e8 07 d4 ff ff       	call   800df3 <_panic>
  8039ec:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8039f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f5:	89 10                	mov    %edx,(%eax)
  8039f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8039fa:	8b 00                	mov    (%eax),%eax
  8039fc:	85 c0                	test   %eax,%eax
  8039fe:	74 0d                	je     803a0d <insert_sorted_with_merge_freeList+0x640>
  803a00:	a1 48 51 80 00       	mov    0x805148,%eax
  803a05:	8b 55 08             	mov    0x8(%ebp),%edx
  803a08:	89 50 04             	mov    %edx,0x4(%eax)
  803a0b:	eb 08                	jmp    803a15 <insert_sorted_with_merge_freeList+0x648>
  803a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  803a10:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a15:	8b 45 08             	mov    0x8(%ebp),%eax
  803a18:	a3 48 51 80 00       	mov    %eax,0x805148
  803a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  803a20:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a27:	a1 54 51 80 00       	mov    0x805154,%eax
  803a2c:	40                   	inc    %eax
  803a2d:	a3 54 51 80 00       	mov    %eax,0x805154
	      break;
  803a32:	e9 dc 00 00 00       	jmp    803b13 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  803a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a3a:	8b 50 08             	mov    0x8(%eax),%edx
  803a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a40:	8b 40 0c             	mov    0xc(%eax),%eax
  803a43:	01 c2                	add    %eax,%edx
  803a45:	8b 45 08             	mov    0x8(%ebp),%eax
  803a48:	8b 40 08             	mov    0x8(%eax),%eax
  803a4b:	39 c2                	cmp    %eax,%edx
  803a4d:	0f 83 88 00 00 00    	jae    803adb <insert_sorted_with_merge_freeList+0x70e>
  803a53:	8b 45 08             	mov    0x8(%ebp),%eax
  803a56:	8b 50 08             	mov    0x8(%eax),%edx
  803a59:	8b 45 08             	mov    0x8(%ebp),%eax
  803a5c:	8b 40 0c             	mov    0xc(%eax),%eax
  803a5f:	01 c2                	add    %eax,%edx
  803a61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a64:	8b 40 08             	mov    0x8(%eax),%eax
  803a67:	39 c2                	cmp    %eax,%edx
  803a69:	73 70                	jae    803adb <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  803a6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a6f:	74 06                	je     803a77 <insert_sorted_with_merge_freeList+0x6aa>
  803a71:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a75:	75 17                	jne    803a8e <insert_sorted_with_merge_freeList+0x6c1>
  803a77:	83 ec 04             	sub    $0x4,%esp
  803a7a:	68 34 47 80 00       	push   $0x804734
  803a7f:	68 75 01 00 00       	push   $0x175
  803a84:	68 f7 46 80 00       	push   $0x8046f7
  803a89:	e8 65 d3 ff ff       	call   800df3 <_panic>
  803a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a91:	8b 10                	mov    (%eax),%edx
  803a93:	8b 45 08             	mov    0x8(%ebp),%eax
  803a96:	89 10                	mov    %edx,(%eax)
  803a98:	8b 45 08             	mov    0x8(%ebp),%eax
  803a9b:	8b 00                	mov    (%eax),%eax
  803a9d:	85 c0                	test   %eax,%eax
  803a9f:	74 0b                	je     803aac <insert_sorted_with_merge_freeList+0x6df>
  803aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aa4:	8b 00                	mov    (%eax),%eax
  803aa6:	8b 55 08             	mov    0x8(%ebp),%edx
  803aa9:	89 50 04             	mov    %edx,0x4(%eax)
  803aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aaf:	8b 55 08             	mov    0x8(%ebp),%edx
  803ab2:	89 10                	mov    %edx,(%eax)
  803ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  803ab7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803aba:	89 50 04             	mov    %edx,0x4(%eax)
  803abd:	8b 45 08             	mov    0x8(%ebp),%eax
  803ac0:	8b 00                	mov    (%eax),%eax
  803ac2:	85 c0                	test   %eax,%eax
  803ac4:	75 08                	jne    803ace <insert_sorted_with_merge_freeList+0x701>
  803ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  803ac9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803ace:	a1 44 51 80 00       	mov    0x805144,%eax
  803ad3:	40                   	inc    %eax
  803ad4:	a3 44 51 80 00       	mov    %eax,0x805144
	      break;
  803ad9:	eb 38                	jmp    803b13 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  803adb:	a1 40 51 80 00       	mov    0x805140,%eax
  803ae0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ae3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ae7:	74 07                	je     803af0 <insert_sorted_with_merge_freeList+0x723>
  803ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aec:	8b 00                	mov    (%eax),%eax
  803aee:	eb 05                	jmp    803af5 <insert_sorted_with_merge_freeList+0x728>
  803af0:	b8 00 00 00 00       	mov    $0x0,%eax
  803af5:	a3 40 51 80 00       	mov    %eax,0x805140
  803afa:	a1 40 51 80 00       	mov    0x805140,%eax
  803aff:	85 c0                	test   %eax,%eax
  803b01:	0f 85 c3 fb ff ff    	jne    8036ca <insert_sorted_with_merge_freeList+0x2fd>
  803b07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b0b:	0f 85 b9 fb ff ff    	jne    8036ca <insert_sorted_with_merge_freeList+0x2fd>





}
  803b11:	eb 00                	jmp    803b13 <insert_sorted_with_merge_freeList+0x746>
  803b13:	90                   	nop
  803b14:	c9                   	leave  
  803b15:	c3                   	ret    
  803b16:	66 90                	xchg   %ax,%ax

00803b18 <__udivdi3>:
  803b18:	55                   	push   %ebp
  803b19:	57                   	push   %edi
  803b1a:	56                   	push   %esi
  803b1b:	53                   	push   %ebx
  803b1c:	83 ec 1c             	sub    $0x1c,%esp
  803b1f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b23:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b27:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b2b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b2f:	89 ca                	mov    %ecx,%edx
  803b31:	89 f8                	mov    %edi,%eax
  803b33:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b37:	85 f6                	test   %esi,%esi
  803b39:	75 2d                	jne    803b68 <__udivdi3+0x50>
  803b3b:	39 cf                	cmp    %ecx,%edi
  803b3d:	77 65                	ja     803ba4 <__udivdi3+0x8c>
  803b3f:	89 fd                	mov    %edi,%ebp
  803b41:	85 ff                	test   %edi,%edi
  803b43:	75 0b                	jne    803b50 <__udivdi3+0x38>
  803b45:	b8 01 00 00 00       	mov    $0x1,%eax
  803b4a:	31 d2                	xor    %edx,%edx
  803b4c:	f7 f7                	div    %edi
  803b4e:	89 c5                	mov    %eax,%ebp
  803b50:	31 d2                	xor    %edx,%edx
  803b52:	89 c8                	mov    %ecx,%eax
  803b54:	f7 f5                	div    %ebp
  803b56:	89 c1                	mov    %eax,%ecx
  803b58:	89 d8                	mov    %ebx,%eax
  803b5a:	f7 f5                	div    %ebp
  803b5c:	89 cf                	mov    %ecx,%edi
  803b5e:	89 fa                	mov    %edi,%edx
  803b60:	83 c4 1c             	add    $0x1c,%esp
  803b63:	5b                   	pop    %ebx
  803b64:	5e                   	pop    %esi
  803b65:	5f                   	pop    %edi
  803b66:	5d                   	pop    %ebp
  803b67:	c3                   	ret    
  803b68:	39 ce                	cmp    %ecx,%esi
  803b6a:	77 28                	ja     803b94 <__udivdi3+0x7c>
  803b6c:	0f bd fe             	bsr    %esi,%edi
  803b6f:	83 f7 1f             	xor    $0x1f,%edi
  803b72:	75 40                	jne    803bb4 <__udivdi3+0x9c>
  803b74:	39 ce                	cmp    %ecx,%esi
  803b76:	72 0a                	jb     803b82 <__udivdi3+0x6a>
  803b78:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b7c:	0f 87 9e 00 00 00    	ja     803c20 <__udivdi3+0x108>
  803b82:	b8 01 00 00 00       	mov    $0x1,%eax
  803b87:	89 fa                	mov    %edi,%edx
  803b89:	83 c4 1c             	add    $0x1c,%esp
  803b8c:	5b                   	pop    %ebx
  803b8d:	5e                   	pop    %esi
  803b8e:	5f                   	pop    %edi
  803b8f:	5d                   	pop    %ebp
  803b90:	c3                   	ret    
  803b91:	8d 76 00             	lea    0x0(%esi),%esi
  803b94:	31 ff                	xor    %edi,%edi
  803b96:	31 c0                	xor    %eax,%eax
  803b98:	89 fa                	mov    %edi,%edx
  803b9a:	83 c4 1c             	add    $0x1c,%esp
  803b9d:	5b                   	pop    %ebx
  803b9e:	5e                   	pop    %esi
  803b9f:	5f                   	pop    %edi
  803ba0:	5d                   	pop    %ebp
  803ba1:	c3                   	ret    
  803ba2:	66 90                	xchg   %ax,%ax
  803ba4:	89 d8                	mov    %ebx,%eax
  803ba6:	f7 f7                	div    %edi
  803ba8:	31 ff                	xor    %edi,%edi
  803baa:	89 fa                	mov    %edi,%edx
  803bac:	83 c4 1c             	add    $0x1c,%esp
  803baf:	5b                   	pop    %ebx
  803bb0:	5e                   	pop    %esi
  803bb1:	5f                   	pop    %edi
  803bb2:	5d                   	pop    %ebp
  803bb3:	c3                   	ret    
  803bb4:	bd 20 00 00 00       	mov    $0x20,%ebp
  803bb9:	89 eb                	mov    %ebp,%ebx
  803bbb:	29 fb                	sub    %edi,%ebx
  803bbd:	89 f9                	mov    %edi,%ecx
  803bbf:	d3 e6                	shl    %cl,%esi
  803bc1:	89 c5                	mov    %eax,%ebp
  803bc3:	88 d9                	mov    %bl,%cl
  803bc5:	d3 ed                	shr    %cl,%ebp
  803bc7:	89 e9                	mov    %ebp,%ecx
  803bc9:	09 f1                	or     %esi,%ecx
  803bcb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803bcf:	89 f9                	mov    %edi,%ecx
  803bd1:	d3 e0                	shl    %cl,%eax
  803bd3:	89 c5                	mov    %eax,%ebp
  803bd5:	89 d6                	mov    %edx,%esi
  803bd7:	88 d9                	mov    %bl,%cl
  803bd9:	d3 ee                	shr    %cl,%esi
  803bdb:	89 f9                	mov    %edi,%ecx
  803bdd:	d3 e2                	shl    %cl,%edx
  803bdf:	8b 44 24 08          	mov    0x8(%esp),%eax
  803be3:	88 d9                	mov    %bl,%cl
  803be5:	d3 e8                	shr    %cl,%eax
  803be7:	09 c2                	or     %eax,%edx
  803be9:	89 d0                	mov    %edx,%eax
  803beb:	89 f2                	mov    %esi,%edx
  803bed:	f7 74 24 0c          	divl   0xc(%esp)
  803bf1:	89 d6                	mov    %edx,%esi
  803bf3:	89 c3                	mov    %eax,%ebx
  803bf5:	f7 e5                	mul    %ebp
  803bf7:	39 d6                	cmp    %edx,%esi
  803bf9:	72 19                	jb     803c14 <__udivdi3+0xfc>
  803bfb:	74 0b                	je     803c08 <__udivdi3+0xf0>
  803bfd:	89 d8                	mov    %ebx,%eax
  803bff:	31 ff                	xor    %edi,%edi
  803c01:	e9 58 ff ff ff       	jmp    803b5e <__udivdi3+0x46>
  803c06:	66 90                	xchg   %ax,%ax
  803c08:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c0c:	89 f9                	mov    %edi,%ecx
  803c0e:	d3 e2                	shl    %cl,%edx
  803c10:	39 c2                	cmp    %eax,%edx
  803c12:	73 e9                	jae    803bfd <__udivdi3+0xe5>
  803c14:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c17:	31 ff                	xor    %edi,%edi
  803c19:	e9 40 ff ff ff       	jmp    803b5e <__udivdi3+0x46>
  803c1e:	66 90                	xchg   %ax,%ax
  803c20:	31 c0                	xor    %eax,%eax
  803c22:	e9 37 ff ff ff       	jmp    803b5e <__udivdi3+0x46>
  803c27:	90                   	nop

00803c28 <__umoddi3>:
  803c28:	55                   	push   %ebp
  803c29:	57                   	push   %edi
  803c2a:	56                   	push   %esi
  803c2b:	53                   	push   %ebx
  803c2c:	83 ec 1c             	sub    $0x1c,%esp
  803c2f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c33:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c37:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c3b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c3f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c43:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c47:	89 f3                	mov    %esi,%ebx
  803c49:	89 fa                	mov    %edi,%edx
  803c4b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c4f:	89 34 24             	mov    %esi,(%esp)
  803c52:	85 c0                	test   %eax,%eax
  803c54:	75 1a                	jne    803c70 <__umoddi3+0x48>
  803c56:	39 f7                	cmp    %esi,%edi
  803c58:	0f 86 a2 00 00 00    	jbe    803d00 <__umoddi3+0xd8>
  803c5e:	89 c8                	mov    %ecx,%eax
  803c60:	89 f2                	mov    %esi,%edx
  803c62:	f7 f7                	div    %edi
  803c64:	89 d0                	mov    %edx,%eax
  803c66:	31 d2                	xor    %edx,%edx
  803c68:	83 c4 1c             	add    $0x1c,%esp
  803c6b:	5b                   	pop    %ebx
  803c6c:	5e                   	pop    %esi
  803c6d:	5f                   	pop    %edi
  803c6e:	5d                   	pop    %ebp
  803c6f:	c3                   	ret    
  803c70:	39 f0                	cmp    %esi,%eax
  803c72:	0f 87 ac 00 00 00    	ja     803d24 <__umoddi3+0xfc>
  803c78:	0f bd e8             	bsr    %eax,%ebp
  803c7b:	83 f5 1f             	xor    $0x1f,%ebp
  803c7e:	0f 84 ac 00 00 00    	je     803d30 <__umoddi3+0x108>
  803c84:	bf 20 00 00 00       	mov    $0x20,%edi
  803c89:	29 ef                	sub    %ebp,%edi
  803c8b:	89 fe                	mov    %edi,%esi
  803c8d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c91:	89 e9                	mov    %ebp,%ecx
  803c93:	d3 e0                	shl    %cl,%eax
  803c95:	89 d7                	mov    %edx,%edi
  803c97:	89 f1                	mov    %esi,%ecx
  803c99:	d3 ef                	shr    %cl,%edi
  803c9b:	09 c7                	or     %eax,%edi
  803c9d:	89 e9                	mov    %ebp,%ecx
  803c9f:	d3 e2                	shl    %cl,%edx
  803ca1:	89 14 24             	mov    %edx,(%esp)
  803ca4:	89 d8                	mov    %ebx,%eax
  803ca6:	d3 e0                	shl    %cl,%eax
  803ca8:	89 c2                	mov    %eax,%edx
  803caa:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cae:	d3 e0                	shl    %cl,%eax
  803cb0:	89 44 24 04          	mov    %eax,0x4(%esp)
  803cb4:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cb8:	89 f1                	mov    %esi,%ecx
  803cba:	d3 e8                	shr    %cl,%eax
  803cbc:	09 d0                	or     %edx,%eax
  803cbe:	d3 eb                	shr    %cl,%ebx
  803cc0:	89 da                	mov    %ebx,%edx
  803cc2:	f7 f7                	div    %edi
  803cc4:	89 d3                	mov    %edx,%ebx
  803cc6:	f7 24 24             	mull   (%esp)
  803cc9:	89 c6                	mov    %eax,%esi
  803ccb:	89 d1                	mov    %edx,%ecx
  803ccd:	39 d3                	cmp    %edx,%ebx
  803ccf:	0f 82 87 00 00 00    	jb     803d5c <__umoddi3+0x134>
  803cd5:	0f 84 91 00 00 00    	je     803d6c <__umoddi3+0x144>
  803cdb:	8b 54 24 04          	mov    0x4(%esp),%edx
  803cdf:	29 f2                	sub    %esi,%edx
  803ce1:	19 cb                	sbb    %ecx,%ebx
  803ce3:	89 d8                	mov    %ebx,%eax
  803ce5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803ce9:	d3 e0                	shl    %cl,%eax
  803ceb:	89 e9                	mov    %ebp,%ecx
  803ced:	d3 ea                	shr    %cl,%edx
  803cef:	09 d0                	or     %edx,%eax
  803cf1:	89 e9                	mov    %ebp,%ecx
  803cf3:	d3 eb                	shr    %cl,%ebx
  803cf5:	89 da                	mov    %ebx,%edx
  803cf7:	83 c4 1c             	add    $0x1c,%esp
  803cfa:	5b                   	pop    %ebx
  803cfb:	5e                   	pop    %esi
  803cfc:	5f                   	pop    %edi
  803cfd:	5d                   	pop    %ebp
  803cfe:	c3                   	ret    
  803cff:	90                   	nop
  803d00:	89 fd                	mov    %edi,%ebp
  803d02:	85 ff                	test   %edi,%edi
  803d04:	75 0b                	jne    803d11 <__umoddi3+0xe9>
  803d06:	b8 01 00 00 00       	mov    $0x1,%eax
  803d0b:	31 d2                	xor    %edx,%edx
  803d0d:	f7 f7                	div    %edi
  803d0f:	89 c5                	mov    %eax,%ebp
  803d11:	89 f0                	mov    %esi,%eax
  803d13:	31 d2                	xor    %edx,%edx
  803d15:	f7 f5                	div    %ebp
  803d17:	89 c8                	mov    %ecx,%eax
  803d19:	f7 f5                	div    %ebp
  803d1b:	89 d0                	mov    %edx,%eax
  803d1d:	e9 44 ff ff ff       	jmp    803c66 <__umoddi3+0x3e>
  803d22:	66 90                	xchg   %ax,%ax
  803d24:	89 c8                	mov    %ecx,%eax
  803d26:	89 f2                	mov    %esi,%edx
  803d28:	83 c4 1c             	add    $0x1c,%esp
  803d2b:	5b                   	pop    %ebx
  803d2c:	5e                   	pop    %esi
  803d2d:	5f                   	pop    %edi
  803d2e:	5d                   	pop    %ebp
  803d2f:	c3                   	ret    
  803d30:	3b 04 24             	cmp    (%esp),%eax
  803d33:	72 06                	jb     803d3b <__umoddi3+0x113>
  803d35:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d39:	77 0f                	ja     803d4a <__umoddi3+0x122>
  803d3b:	89 f2                	mov    %esi,%edx
  803d3d:	29 f9                	sub    %edi,%ecx
  803d3f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d43:	89 14 24             	mov    %edx,(%esp)
  803d46:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d4a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d4e:	8b 14 24             	mov    (%esp),%edx
  803d51:	83 c4 1c             	add    $0x1c,%esp
  803d54:	5b                   	pop    %ebx
  803d55:	5e                   	pop    %esi
  803d56:	5f                   	pop    %edi
  803d57:	5d                   	pop    %ebp
  803d58:	c3                   	ret    
  803d59:	8d 76 00             	lea    0x0(%esi),%esi
  803d5c:	2b 04 24             	sub    (%esp),%eax
  803d5f:	19 fa                	sbb    %edi,%edx
  803d61:	89 d1                	mov    %edx,%ecx
  803d63:	89 c6                	mov    %eax,%esi
  803d65:	e9 71 ff ff ff       	jmp    803cdb <__umoddi3+0xb3>
  803d6a:	66 90                	xchg   %ax,%ax
  803d6c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d70:	72 ea                	jb     803d5c <__umoddi3+0x134>
  803d72:	89 d9                	mov    %ebx,%ecx
  803d74:	e9 62 ff ff ff       	jmp    803cdb <__umoddi3+0xb3>
