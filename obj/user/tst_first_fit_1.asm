
obj/user/tst_first_fit_1:     file format elf32-i386


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
  800031:	e8 38 0b 00 00       	call   800b6e <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* MAKE SURE PAGE_WS_MAX_SIZE = 1000 */
/* *********************************************************** */
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	83 ec 74             	sub    $0x74,%esp
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);
  80003f:	83 ec 0c             	sub    $0xc,%esp
  800042:	6a 01                	push   $0x1
  800044:	e8 e2 27 00 00       	call   80282b <sys_set_uheap_strategy>
  800049:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80004c:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800050:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800057:	eb 29                	jmp    800082 <_main+0x4a>
		{
			if (myEnv->__uptr_pws[i].empty)
  800059:	a1 20 50 80 00       	mov    0x805020,%eax
  80005e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800064:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800067:	89 d0                	mov    %edx,%eax
  800069:	01 c0                	add    %eax,%eax
  80006b:	01 d0                	add    %edx,%eax
  80006d:	c1 e0 03             	shl    $0x3,%eax
  800070:	01 c8                	add    %ecx,%eax
  800072:	8a 40 04             	mov    0x4(%eax),%al
  800075:	84 c0                	test   %al,%al
  800077:	74 06                	je     80007f <_main+0x47>
			{
				fullWS = 0;
  800079:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80007d:	eb 12                	jmp    800091 <_main+0x59>
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80007f:	ff 45 f0             	incl   -0x10(%ebp)
  800082:	a1 20 50 80 00       	mov    0x805020,%eax
  800087:	8b 50 74             	mov    0x74(%eax),%edx
  80008a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80008d:	39 c2                	cmp    %eax,%edx
  80008f:	77 c8                	ja     800059 <_main+0x21>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800091:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800095:	74 14                	je     8000ab <_main+0x73>
  800097:	83 ec 04             	sub    $0x4,%esp
  80009a:	68 40 3c 80 00       	push   $0x803c40
  80009f:	6a 15                	push   $0x15
  8000a1:	68 5c 3c 80 00       	push   $0x803c5c
  8000a6:	e8 ff 0b 00 00       	call   800caa <_panic>
	}

	int Mega = 1024*1024;
  8000ab:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000b2:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000b9:	83 ec 0c             	sub    $0xc,%esp
  8000bc:	6a 00                	push   $0x0
  8000be:	e8 14 1e 00 00       	call   801ed7 <malloc>
  8000c3:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/
	void* ptr_allocations[20] = {0};
  8000c6:	8d 55 90             	lea    -0x70(%ebp),%edx
  8000c9:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d3:	89 d7                	mov    %edx,%edi
  8000d5:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	//[1] Allocate all
	{
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8000d7:	e8 3a 22 00 00       	call   802316 <sys_calculate_free_frames>
  8000dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000df:	e8 d2 22 00 00       	call   8023b6 <sys_pf_calculate_allocated_pages>
  8000e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(1*Mega-kilo);
  8000e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ea:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000ed:	83 ec 0c             	sub    $0xc,%esp
  8000f0:	50                   	push   %eax
  8000f1:	e8 e1 1d 00 00       	call   801ed7 <malloc>
  8000f6:	83 c4 10             	add    $0x10,%esp
  8000f9:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  8000fc:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000ff:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800104:	74 14                	je     80011a <_main+0xe2>
  800106:	83 ec 04             	sub    $0x4,%esp
  800109:	68 74 3c 80 00       	push   $0x803c74
  80010e:	6a 26                	push   $0x26
  800110:	68 5c 3c 80 00       	push   $0x803c5c
  800115:	e8 90 0b 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80011a:	e8 97 22 00 00       	call   8023b6 <sys_pf_calculate_allocated_pages>
  80011f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800122:	74 14                	je     800138 <_main+0x100>
  800124:	83 ec 04             	sub    $0x4,%esp
  800127:	68 a4 3c 80 00       	push   $0x803ca4
  80012c:	6a 28                	push   $0x28
  80012e:	68 5c 3c 80 00       	push   $0x803c5c
  800133:	e8 72 0b 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  800138:	e8 d9 21 00 00       	call   802316 <sys_calculate_free_frames>
  80013d:	89 c2                	mov    %eax,%edx
  80013f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800142:	39 c2                	cmp    %eax,%edx
  800144:	74 14                	je     80015a <_main+0x122>
  800146:	83 ec 04             	sub    $0x4,%esp
  800149:	68 c1 3c 80 00       	push   $0x803cc1
  80014e:	6a 29                	push   $0x29
  800150:	68 5c 3c 80 00       	push   $0x803c5c
  800155:	e8 50 0b 00 00       	call   800caa <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80015a:	e8 b7 21 00 00       	call   802316 <sys_calculate_free_frames>
  80015f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800162:	e8 4f 22 00 00       	call   8023b6 <sys_pf_calculate_allocated_pages>
  800167:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  80016a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80016d:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800170:	83 ec 0c             	sub    $0xc,%esp
  800173:	50                   	push   %eax
  800174:	e8 5e 1d 00 00       	call   801ed7 <malloc>
  800179:	83 c4 10             	add    $0x10,%esp
  80017c:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] != (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  80017f:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800182:	89 c2                	mov    %eax,%edx
  800184:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800187:	05 00 00 00 80       	add    $0x80000000,%eax
  80018c:	39 c2                	cmp    %eax,%edx
  80018e:	74 14                	je     8001a4 <_main+0x16c>
  800190:	83 ec 04             	sub    $0x4,%esp
  800193:	68 74 3c 80 00       	push   $0x803c74
  800198:	6a 2f                	push   $0x2f
  80019a:	68 5c 3c 80 00       	push   $0x803c5c
  80019f:	e8 06 0b 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8001a4:	e8 0d 22 00 00       	call   8023b6 <sys_pf_calculate_allocated_pages>
  8001a9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001ac:	74 14                	je     8001c2 <_main+0x18a>
  8001ae:	83 ec 04             	sub    $0x4,%esp
  8001b1:	68 a4 3c 80 00       	push   $0x803ca4
  8001b6:	6a 31                	push   $0x31
  8001b8:	68 5c 3c 80 00       	push   $0x803c5c
  8001bd:	e8 e8 0a 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  8001c2:	e8 4f 21 00 00       	call   802316 <sys_calculate_free_frames>
  8001c7:	89 c2                	mov    %eax,%edx
  8001c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001cc:	39 c2                	cmp    %eax,%edx
  8001ce:	74 14                	je     8001e4 <_main+0x1ac>
  8001d0:	83 ec 04             	sub    $0x4,%esp
  8001d3:	68 c1 3c 80 00       	push   $0x803cc1
  8001d8:	6a 32                	push   $0x32
  8001da:	68 5c 3c 80 00       	push   $0x803c5c
  8001df:	e8 c6 0a 00 00       	call   800caa <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8001e4:	e8 2d 21 00 00       	call   802316 <sys_calculate_free_frames>
  8001e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001ec:	e8 c5 21 00 00       	call   8023b6 <sys_pf_calculate_allocated_pages>
  8001f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  8001f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001f7:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8001fa:	83 ec 0c             	sub    $0xc,%esp
  8001fd:	50                   	push   %eax
  8001fe:	e8 d4 1c 00 00       	call   801ed7 <malloc>
  800203:	83 c4 10             	add    $0x10,%esp
  800206:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  800209:	8b 45 98             	mov    -0x68(%ebp),%eax
  80020c:	89 c2                	mov    %eax,%edx
  80020e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800211:	01 c0                	add    %eax,%eax
  800213:	05 00 00 00 80       	add    $0x80000000,%eax
  800218:	39 c2                	cmp    %eax,%edx
  80021a:	74 14                	je     800230 <_main+0x1f8>
  80021c:	83 ec 04             	sub    $0x4,%esp
  80021f:	68 74 3c 80 00       	push   $0x803c74
  800224:	6a 38                	push   $0x38
  800226:	68 5c 3c 80 00       	push   $0x803c5c
  80022b:	e8 7a 0a 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800230:	e8 81 21 00 00       	call   8023b6 <sys_pf_calculate_allocated_pages>
  800235:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800238:	74 14                	je     80024e <_main+0x216>
  80023a:	83 ec 04             	sub    $0x4,%esp
  80023d:	68 a4 3c 80 00       	push   $0x803ca4
  800242:	6a 3a                	push   $0x3a
  800244:	68 5c 3c 80 00       	push   $0x803c5c
  800249:	e8 5c 0a 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80024e:	e8 c3 20 00 00       	call   802316 <sys_calculate_free_frames>
  800253:	89 c2                	mov    %eax,%edx
  800255:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800258:	39 c2                	cmp    %eax,%edx
  80025a:	74 14                	je     800270 <_main+0x238>
  80025c:	83 ec 04             	sub    $0x4,%esp
  80025f:	68 c1 3c 80 00       	push   $0x803cc1
  800264:	6a 3b                	push   $0x3b
  800266:	68 5c 3c 80 00       	push   $0x803c5c
  80026b:	e8 3a 0a 00 00       	call   800caa <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800270:	e8 a1 20 00 00       	call   802316 <sys_calculate_free_frames>
  800275:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800278:	e8 39 21 00 00       	call   8023b6 <sys_pf_calculate_allocated_pages>
  80027d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  800280:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800283:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	50                   	push   %eax
  80028a:	e8 48 1c 00 00       	call   801ed7 <malloc>
  80028f:	83 c4 10             	add    $0x10,%esp
  800292:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 3*Mega) ) panic("Wrong start address for the allocated space... ");
  800295:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800298:	89 c1                	mov    %eax,%ecx
  80029a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80029d:	89 c2                	mov    %eax,%edx
  80029f:	01 d2                	add    %edx,%edx
  8002a1:	01 d0                	add    %edx,%eax
  8002a3:	05 00 00 00 80       	add    $0x80000000,%eax
  8002a8:	39 c1                	cmp    %eax,%ecx
  8002aa:	74 14                	je     8002c0 <_main+0x288>
  8002ac:	83 ec 04             	sub    $0x4,%esp
  8002af:	68 74 3c 80 00       	push   $0x803c74
  8002b4:	6a 41                	push   $0x41
  8002b6:	68 5c 3c 80 00       	push   $0x803c5c
  8002bb:	e8 ea 09 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8002c0:	e8 f1 20 00 00       	call   8023b6 <sys_pf_calculate_allocated_pages>
  8002c5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002c8:	74 14                	je     8002de <_main+0x2a6>
  8002ca:	83 ec 04             	sub    $0x4,%esp
  8002cd:	68 a4 3c 80 00       	push   $0x803ca4
  8002d2:	6a 43                	push   $0x43
  8002d4:	68 5c 3c 80 00       	push   $0x803c5c
  8002d9:	e8 cc 09 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  8002de:	e8 33 20 00 00       	call   802316 <sys_calculate_free_frames>
  8002e3:	89 c2                	mov    %eax,%edx
  8002e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002e8:	39 c2                	cmp    %eax,%edx
  8002ea:	74 14                	je     800300 <_main+0x2c8>
  8002ec:	83 ec 04             	sub    $0x4,%esp
  8002ef:	68 c1 3c 80 00       	push   $0x803cc1
  8002f4:	6a 44                	push   $0x44
  8002f6:	68 5c 3c 80 00       	push   $0x803c5c
  8002fb:	e8 aa 09 00 00       	call   800caa <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800300:	e8 11 20 00 00       	call   802316 <sys_calculate_free_frames>
  800305:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800308:	e8 a9 20 00 00       	call   8023b6 <sys_pf_calculate_allocated_pages>
  80030d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  800310:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800313:	01 c0                	add    %eax,%eax
  800315:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800318:	83 ec 0c             	sub    $0xc,%esp
  80031b:	50                   	push   %eax
  80031c:	e8 b6 1b 00 00       	call   801ed7 <malloc>
  800321:	83 c4 10             	add    $0x10,%esp
  800324:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800327:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80032a:	89 c2                	mov    %eax,%edx
  80032c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80032f:	c1 e0 02             	shl    $0x2,%eax
  800332:	05 00 00 00 80       	add    $0x80000000,%eax
  800337:	39 c2                	cmp    %eax,%edx
  800339:	74 14                	je     80034f <_main+0x317>
  80033b:	83 ec 04             	sub    $0x4,%esp
  80033e:	68 74 3c 80 00       	push   $0x803c74
  800343:	6a 4a                	push   $0x4a
  800345:	68 5c 3c 80 00       	push   $0x803c5c
  80034a:	e8 5b 09 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80034f:	e8 62 20 00 00       	call   8023b6 <sys_pf_calculate_allocated_pages>
  800354:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800357:	74 14                	je     80036d <_main+0x335>
  800359:	83 ec 04             	sub    $0x4,%esp
  80035c:	68 a4 3c 80 00       	push   $0x803ca4
  800361:	6a 4c                	push   $0x4c
  800363:	68 5c 3c 80 00       	push   $0x803c5c
  800368:	e8 3d 09 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80036d:	e8 a4 1f 00 00       	call   802316 <sys_calculate_free_frames>
  800372:	89 c2                	mov    %eax,%edx
  800374:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800377:	39 c2                	cmp    %eax,%edx
  800379:	74 14                	je     80038f <_main+0x357>
  80037b:	83 ec 04             	sub    $0x4,%esp
  80037e:	68 c1 3c 80 00       	push   $0x803cc1
  800383:	6a 4d                	push   $0x4d
  800385:	68 5c 3c 80 00       	push   $0x803c5c
  80038a:	e8 1b 09 00 00       	call   800caa <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  80038f:	e8 82 1f 00 00       	call   802316 <sys_calculate_free_frames>
  800394:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800397:	e8 1a 20 00 00       	call   8023b6 <sys_pf_calculate_allocated_pages>
  80039c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(2*Mega-kilo);
  80039f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003a2:	01 c0                	add    %eax,%eax
  8003a4:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003a7:	83 ec 0c             	sub    $0xc,%esp
  8003aa:	50                   	push   %eax
  8003ab:	e8 27 1b 00 00       	call   801ed7 <malloc>
  8003b0:	83 c4 10             	add    $0x10,%esp
  8003b3:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] != (USER_HEAP_START + 6*Mega)) panic("Wrong start address for the allocated space... ");
  8003b6:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003b9:	89 c1                	mov    %eax,%ecx
  8003bb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003be:	89 d0                	mov    %edx,%eax
  8003c0:	01 c0                	add    %eax,%eax
  8003c2:	01 d0                	add    %edx,%eax
  8003c4:	01 c0                	add    %eax,%eax
  8003c6:	05 00 00 00 80       	add    $0x80000000,%eax
  8003cb:	39 c1                	cmp    %eax,%ecx
  8003cd:	74 14                	je     8003e3 <_main+0x3ab>
  8003cf:	83 ec 04             	sub    $0x4,%esp
  8003d2:	68 74 3c 80 00       	push   $0x803c74
  8003d7:	6a 53                	push   $0x53
  8003d9:	68 5c 3c 80 00       	push   $0x803c5c
  8003de:	e8 c7 08 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8003e3:	e8 ce 1f 00 00       	call   8023b6 <sys_pf_calculate_allocated_pages>
  8003e8:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003eb:	74 14                	je     800401 <_main+0x3c9>
  8003ed:	83 ec 04             	sub    $0x4,%esp
  8003f0:	68 a4 3c 80 00       	push   $0x803ca4
  8003f5:	6a 55                	push   $0x55
  8003f7:	68 5c 3c 80 00       	push   $0x803c5c
  8003fc:	e8 a9 08 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800401:	e8 10 1f 00 00       	call   802316 <sys_calculate_free_frames>
  800406:	89 c2                	mov    %eax,%edx
  800408:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80040b:	39 c2                	cmp    %eax,%edx
  80040d:	74 14                	je     800423 <_main+0x3eb>
  80040f:	83 ec 04             	sub    $0x4,%esp
  800412:	68 c1 3c 80 00       	push   $0x803cc1
  800417:	6a 56                	push   $0x56
  800419:	68 5c 3c 80 00       	push   $0x803c5c
  80041e:	e8 87 08 00 00       	call   800caa <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800423:	e8 ee 1e 00 00       	call   802316 <sys_calculate_free_frames>
  800428:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80042b:	e8 86 1f 00 00       	call   8023b6 <sys_pf_calculate_allocated_pages>
  800430:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  800433:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800436:	89 c2                	mov    %eax,%edx
  800438:	01 d2                	add    %edx,%edx
  80043a:	01 d0                	add    %edx,%eax
  80043c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80043f:	83 ec 0c             	sub    $0xc,%esp
  800442:	50                   	push   %eax
  800443:	e8 8f 1a 00 00       	call   801ed7 <malloc>
  800448:	83 c4 10             	add    $0x10,%esp
  80044b:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  80044e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800451:	89 c2                	mov    %eax,%edx
  800453:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800456:	c1 e0 03             	shl    $0x3,%eax
  800459:	05 00 00 00 80       	add    $0x80000000,%eax
  80045e:	39 c2                	cmp    %eax,%edx
  800460:	74 14                	je     800476 <_main+0x43e>
  800462:	83 ec 04             	sub    $0x4,%esp
  800465:	68 74 3c 80 00       	push   $0x803c74
  80046a:	6a 5c                	push   $0x5c
  80046c:	68 5c 3c 80 00       	push   $0x803c5c
  800471:	e8 34 08 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800476:	e8 3b 1f 00 00       	call   8023b6 <sys_pf_calculate_allocated_pages>
  80047b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80047e:	74 14                	je     800494 <_main+0x45c>
  800480:	83 ec 04             	sub    $0x4,%esp
  800483:	68 a4 3c 80 00       	push   $0x803ca4
  800488:	6a 5e                	push   $0x5e
  80048a:	68 5c 3c 80 00       	push   $0x803c5c
  80048f:	e8 16 08 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800494:	e8 7d 1e 00 00       	call   802316 <sys_calculate_free_frames>
  800499:	89 c2                	mov    %eax,%edx
  80049b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80049e:	39 c2                	cmp    %eax,%edx
  8004a0:	74 14                	je     8004b6 <_main+0x47e>
  8004a2:	83 ec 04             	sub    $0x4,%esp
  8004a5:	68 c1 3c 80 00       	push   $0x803cc1
  8004aa:	6a 5f                	push   $0x5f
  8004ac:	68 5c 3c 80 00       	push   $0x803c5c
  8004b1:	e8 f4 07 00 00       	call   800caa <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8004b6:	e8 5b 1e 00 00       	call   802316 <sys_calculate_free_frames>
  8004bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004be:	e8 f3 1e 00 00       	call   8023b6 <sys_pf_calculate_allocated_pages>
  8004c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = malloc(3*Mega-kilo);
  8004c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004c9:	89 c2                	mov    %eax,%edx
  8004cb:	01 d2                	add    %edx,%edx
  8004cd:	01 d0                	add    %edx,%eax
  8004cf:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8004d2:	83 ec 0c             	sub    $0xc,%esp
  8004d5:	50                   	push   %eax
  8004d6:	e8 fc 19 00 00       	call   801ed7 <malloc>
  8004db:	83 c4 10             	add    $0x10,%esp
  8004de:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 11*Mega)) panic("Wrong start address for the allocated space... ");
  8004e1:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8004e4:	89 c1                	mov    %eax,%ecx
  8004e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8004e9:	89 d0                	mov    %edx,%eax
  8004eb:	c1 e0 02             	shl    $0x2,%eax
  8004ee:	01 d0                	add    %edx,%eax
  8004f0:	01 c0                	add    %eax,%eax
  8004f2:	01 d0                	add    %edx,%eax
  8004f4:	05 00 00 00 80       	add    $0x80000000,%eax
  8004f9:	39 c1                	cmp    %eax,%ecx
  8004fb:	74 14                	je     800511 <_main+0x4d9>
  8004fd:	83 ec 04             	sub    $0x4,%esp
  800500:	68 74 3c 80 00       	push   $0x803c74
  800505:	6a 65                	push   $0x65
  800507:	68 5c 3c 80 00       	push   $0x803c5c
  80050c:	e8 99 07 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800511:	e8 a0 1e 00 00       	call   8023b6 <sys_pf_calculate_allocated_pages>
  800516:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800519:	74 14                	je     80052f <_main+0x4f7>
  80051b:	83 ec 04             	sub    $0x4,%esp
  80051e:	68 a4 3c 80 00       	push   $0x803ca4
  800523:	6a 67                	push   $0x67
  800525:	68 5c 3c 80 00       	push   $0x803c5c
  80052a:	e8 7b 07 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80052f:	e8 e2 1d 00 00       	call   802316 <sys_calculate_free_frames>
  800534:	89 c2                	mov    %eax,%edx
  800536:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800539:	39 c2                	cmp    %eax,%edx
  80053b:	74 14                	je     800551 <_main+0x519>
  80053d:	83 ec 04             	sub    $0x4,%esp
  800540:	68 c1 3c 80 00       	push   $0x803cc1
  800545:	6a 68                	push   $0x68
  800547:	68 5c 3c 80 00       	push   $0x803c5c
  80054c:	e8 59 07 00 00       	call   800caa <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800551:	e8 c0 1d 00 00       	call   802316 <sys_calculate_free_frames>
  800556:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800559:	e8 58 1e 00 00       	call   8023b6 <sys_pf_calculate_allocated_pages>
  80055e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  800561:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800564:	83 ec 0c             	sub    $0xc,%esp
  800567:	50                   	push   %eax
  800568:	e8 01 1a 00 00       	call   801f6e <free>
  80056d:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800570:	e8 41 1e 00 00       	call   8023b6 <sys_pf_calculate_allocated_pages>
  800575:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800578:	74 14                	je     80058e <_main+0x556>
  80057a:	83 ec 04             	sub    $0x4,%esp
  80057d:	68 d4 3c 80 00       	push   $0x803cd4
  800582:	6a 72                	push   $0x72
  800584:	68 5c 3c 80 00       	push   $0x803c5c
  800589:	e8 1c 07 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80058e:	e8 83 1d 00 00       	call   802316 <sys_calculate_free_frames>
  800593:	89 c2                	mov    %eax,%edx
  800595:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800598:	39 c2                	cmp    %eax,%edx
  80059a:	74 14                	je     8005b0 <_main+0x578>
  80059c:	83 ec 04             	sub    $0x4,%esp
  80059f:	68 eb 3c 80 00       	push   $0x803ceb
  8005a4:	6a 73                	push   $0x73
  8005a6:	68 5c 3c 80 00       	push   $0x803c5c
  8005ab:	e8 fa 06 00 00       	call   800caa <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005b0:	e8 61 1d 00 00       	call   802316 <sys_calculate_free_frames>
  8005b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005b8:	e8 f9 1d 00 00       	call   8023b6 <sys_pf_calculate_allocated_pages>
  8005bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[4]);
  8005c0:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8005c3:	83 ec 0c             	sub    $0xc,%esp
  8005c6:	50                   	push   %eax
  8005c7:	e8 a2 19 00 00       	call   801f6e <free>
  8005cc:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8005cf:	e8 e2 1d 00 00       	call   8023b6 <sys_pf_calculate_allocated_pages>
  8005d4:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005d7:	74 14                	je     8005ed <_main+0x5b5>
  8005d9:	83 ec 04             	sub    $0x4,%esp
  8005dc:	68 d4 3c 80 00       	push   $0x803cd4
  8005e1:	6a 7a                	push   $0x7a
  8005e3:	68 5c 3c 80 00       	push   $0x803c5c
  8005e8:	e8 bd 06 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8005ed:	e8 24 1d 00 00       	call   802316 <sys_calculate_free_frames>
  8005f2:	89 c2                	mov    %eax,%edx
  8005f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005f7:	39 c2                	cmp    %eax,%edx
  8005f9:	74 14                	je     80060f <_main+0x5d7>
  8005fb:	83 ec 04             	sub    $0x4,%esp
  8005fe:	68 eb 3c 80 00       	push   $0x803ceb
  800603:	6a 7b                	push   $0x7b
  800605:	68 5c 3c 80 00       	push   $0x803c5c
  80060a:	e8 9b 06 00 00       	call   800caa <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80060f:	e8 02 1d 00 00       	call   802316 <sys_calculate_free_frames>
  800614:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800617:	e8 9a 1d 00 00       	call   8023b6 <sys_pf_calculate_allocated_pages>
  80061c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[6]);
  80061f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800622:	83 ec 0c             	sub    $0xc,%esp
  800625:	50                   	push   %eax
  800626:	e8 43 19 00 00       	call   801f6e <free>
  80062b:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  80062e:	e8 83 1d 00 00       	call   8023b6 <sys_pf_calculate_allocated_pages>
  800633:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800636:	74 17                	je     80064f <_main+0x617>
  800638:	83 ec 04             	sub    $0x4,%esp
  80063b:	68 d4 3c 80 00       	push   $0x803cd4
  800640:	68 82 00 00 00       	push   $0x82
  800645:	68 5c 3c 80 00       	push   $0x803c5c
  80064a:	e8 5b 06 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80064f:	e8 c2 1c 00 00       	call   802316 <sys_calculate_free_frames>
  800654:	89 c2                	mov    %eax,%edx
  800656:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800659:	39 c2                	cmp    %eax,%edx
  80065b:	74 17                	je     800674 <_main+0x63c>
  80065d:	83 ec 04             	sub    $0x4,%esp
  800660:	68 eb 3c 80 00       	push   $0x803ceb
  800665:	68 83 00 00 00       	push   $0x83
  80066a:	68 5c 3c 80 00       	push   $0x803c5c
  80066f:	e8 36 06 00 00       	call   800caa <_panic>
	}

	//[3] Allocate again [test first fit]
	{
		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800674:	e8 9d 1c 00 00       	call   802316 <sys_calculate_free_frames>
  800679:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80067c:	e8 35 1d 00 00       	call   8023b6 <sys_pf_calculate_allocated_pages>
  800681:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(512*kilo - kilo);
  800684:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800687:	89 d0                	mov    %edx,%eax
  800689:	c1 e0 09             	shl    $0x9,%eax
  80068c:	29 d0                	sub    %edx,%eax
  80068e:	83 ec 0c             	sub    $0xc,%esp
  800691:	50                   	push   %eax
  800692:	e8 40 18 00 00       	call   801ed7 <malloc>
  800697:	83 c4 10             	add    $0x10,%esp
  80069a:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[8] != (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  80069d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8006a0:	89 c2                	mov    %eax,%edx
  8006a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006a5:	05 00 00 00 80       	add    $0x80000000,%eax
  8006aa:	39 c2                	cmp    %eax,%edx
  8006ac:	74 17                	je     8006c5 <_main+0x68d>
  8006ae:	83 ec 04             	sub    $0x4,%esp
  8006b1:	68 74 3c 80 00       	push   $0x803c74
  8006b6:	68 8c 00 00 00       	push   $0x8c
  8006bb:	68 5c 3c 80 00       	push   $0x803c5c
  8006c0:	e8 e5 05 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8006c5:	e8 ec 1c 00 00       	call   8023b6 <sys_pf_calculate_allocated_pages>
  8006ca:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8006cd:	74 17                	je     8006e6 <_main+0x6ae>
  8006cf:	83 ec 04             	sub    $0x4,%esp
  8006d2:	68 a4 3c 80 00       	push   $0x803ca4
  8006d7:	68 8e 00 00 00       	push   $0x8e
  8006dc:	68 5c 3c 80 00       	push   $0x803c5c
  8006e1:	e8 c4 05 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8006e6:	e8 2b 1c 00 00       	call   802316 <sys_calculate_free_frames>
  8006eb:	89 c2                	mov    %eax,%edx
  8006ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006f0:	39 c2                	cmp    %eax,%edx
  8006f2:	74 17                	je     80070b <_main+0x6d3>
  8006f4:	83 ec 04             	sub    $0x4,%esp
  8006f7:	68 c1 3c 80 00       	push   $0x803cc1
  8006fc:	68 8f 00 00 00       	push   $0x8f
  800701:	68 5c 3c 80 00       	push   $0x803c5c
  800706:	e8 9f 05 00 00       	call   800caa <_panic>

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  80070b:	e8 06 1c 00 00       	call   802316 <sys_calculate_free_frames>
  800710:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800713:	e8 9e 1c 00 00       	call   8023b6 <sys_pf_calculate_allocated_pages>
  800718:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[9] = malloc(1*Mega - kilo);
  80071b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80071e:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800721:	83 ec 0c             	sub    $0xc,%esp
  800724:	50                   	push   %eax
  800725:	e8 ad 17 00 00       	call   801ed7 <malloc>
  80072a:	83 c4 10             	add    $0x10,%esp
  80072d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800730:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800733:	89 c2                	mov    %eax,%edx
  800735:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800738:	c1 e0 02             	shl    $0x2,%eax
  80073b:	05 00 00 00 80       	add    $0x80000000,%eax
  800740:	39 c2                	cmp    %eax,%edx
  800742:	74 17                	je     80075b <_main+0x723>
  800744:	83 ec 04             	sub    $0x4,%esp
  800747:	68 74 3c 80 00       	push   $0x803c74
  80074c:	68 95 00 00 00       	push   $0x95
  800751:	68 5c 3c 80 00       	push   $0x803c5c
  800756:	e8 4f 05 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80075b:	e8 56 1c 00 00       	call   8023b6 <sys_pf_calculate_allocated_pages>
  800760:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800763:	74 17                	je     80077c <_main+0x744>
  800765:	83 ec 04             	sub    $0x4,%esp
  800768:	68 a4 3c 80 00       	push   $0x803ca4
  80076d:	68 97 00 00 00       	push   $0x97
  800772:	68 5c 3c 80 00       	push   $0x803c5c
  800777:	e8 2e 05 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80077c:	e8 95 1b 00 00       	call   802316 <sys_calculate_free_frames>
  800781:	89 c2                	mov    %eax,%edx
  800783:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800786:	39 c2                	cmp    %eax,%edx
  800788:	74 17                	je     8007a1 <_main+0x769>
  80078a:	83 ec 04             	sub    $0x4,%esp
  80078d:	68 c1 3c 80 00       	push   $0x803cc1
  800792:	68 98 00 00 00       	push   $0x98
  800797:	68 5c 3c 80 00       	push   $0x803c5c
  80079c:	e8 09 05 00 00       	call   800caa <_panic>

		//Allocate 256 KB - should be placed in remaining of 1st hole
		freeFrames = sys_calculate_free_frames() ;
  8007a1:	e8 70 1b 00 00       	call   802316 <sys_calculate_free_frames>
  8007a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8007a9:	e8 08 1c 00 00       	call   8023b6 <sys_pf_calculate_allocated_pages>
  8007ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[10] = malloc(256*kilo - kilo);
  8007b1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007b4:	89 d0                	mov    %edx,%eax
  8007b6:	c1 e0 08             	shl    $0x8,%eax
  8007b9:	29 d0                	sub    %edx,%eax
  8007bb:	83 ec 0c             	sub    $0xc,%esp
  8007be:	50                   	push   %eax
  8007bf:	e8 13 17 00 00       	call   801ed7 <malloc>
  8007c4:	83 c4 10             	add    $0x10,%esp
  8007c7:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START + 1*Mega + 512*kilo)) panic("Wrong start address for the allocated space... ");
  8007ca:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8007cd:	89 c2                	mov    %eax,%edx
  8007cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007d2:	c1 e0 09             	shl    $0x9,%eax
  8007d5:	89 c1                	mov    %eax,%ecx
  8007d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007da:	01 c8                	add    %ecx,%eax
  8007dc:	05 00 00 00 80       	add    $0x80000000,%eax
  8007e1:	39 c2                	cmp    %eax,%edx
  8007e3:	74 17                	je     8007fc <_main+0x7c4>
  8007e5:	83 ec 04             	sub    $0x4,%esp
  8007e8:	68 74 3c 80 00       	push   $0x803c74
  8007ed:	68 9e 00 00 00       	push   $0x9e
  8007f2:	68 5c 3c 80 00       	push   $0x803c5c
  8007f7:	e8 ae 04 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8007fc:	e8 b5 1b 00 00       	call   8023b6 <sys_pf_calculate_allocated_pages>
  800801:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800804:	74 17                	je     80081d <_main+0x7e5>
  800806:	83 ec 04             	sub    $0x4,%esp
  800809:	68 a4 3c 80 00       	push   $0x803ca4
  80080e:	68 a0 00 00 00       	push   $0xa0
  800813:	68 5c 3c 80 00       	push   $0x803c5c
  800818:	e8 8d 04 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80081d:	e8 f4 1a 00 00       	call   802316 <sys_calculate_free_frames>
  800822:	89 c2                	mov    %eax,%edx
  800824:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800827:	39 c2                	cmp    %eax,%edx
  800829:	74 17                	je     800842 <_main+0x80a>
  80082b:	83 ec 04             	sub    $0x4,%esp
  80082e:	68 c1 3c 80 00       	push   $0x803cc1
  800833:	68 a1 00 00 00       	push   $0xa1
  800838:	68 5c 3c 80 00       	push   $0x803c5c
  80083d:	e8 68 04 00 00       	call   800caa <_panic>

		//Allocate 2 MB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  800842:	e8 cf 1a 00 00       	call   802316 <sys_calculate_free_frames>
  800847:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80084a:	e8 67 1b 00 00       	call   8023b6 <sys_pf_calculate_allocated_pages>
  80084f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[11] = malloc(2*Mega);
  800852:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800855:	01 c0                	add    %eax,%eax
  800857:	83 ec 0c             	sub    $0xc,%esp
  80085a:	50                   	push   %eax
  80085b:	e8 77 16 00 00       	call   801ed7 <malloc>
  800860:	83 c4 10             	add    $0x10,%esp
  800863:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if ((uint32) ptr_allocations[11] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  800866:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800869:	89 c2                	mov    %eax,%edx
  80086b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80086e:	c1 e0 03             	shl    $0x3,%eax
  800871:	05 00 00 00 80       	add    $0x80000000,%eax
  800876:	39 c2                	cmp    %eax,%edx
  800878:	74 17                	je     800891 <_main+0x859>
  80087a:	83 ec 04             	sub    $0x4,%esp
  80087d:	68 74 3c 80 00       	push   $0x803c74
  800882:	68 a7 00 00 00       	push   $0xa7
  800887:	68 5c 3c 80 00       	push   $0x803c5c
  80088c:	e8 19 04 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800891:	e8 20 1b 00 00       	call   8023b6 <sys_pf_calculate_allocated_pages>
  800896:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800899:	74 17                	je     8008b2 <_main+0x87a>
  80089b:	83 ec 04             	sub    $0x4,%esp
  80089e:	68 a4 3c 80 00       	push   $0x803ca4
  8008a3:	68 a9 00 00 00       	push   $0xa9
  8008a8:	68 5c 3c 80 00       	push   $0x803c5c
  8008ad:	e8 f8 03 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8008b2:	e8 5f 1a 00 00       	call   802316 <sys_calculate_free_frames>
  8008b7:	89 c2                	mov    %eax,%edx
  8008b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008bc:	39 c2                	cmp    %eax,%edx
  8008be:	74 17                	je     8008d7 <_main+0x89f>
  8008c0:	83 ec 04             	sub    $0x4,%esp
  8008c3:	68 c1 3c 80 00       	push   $0x803cc1
  8008c8:	68 aa 00 00 00       	push   $0xaa
  8008cd:	68 5c 3c 80 00       	push   $0x803c5c
  8008d2:	e8 d3 03 00 00       	call   800caa <_panic>

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  8008d7:	e8 3a 1a 00 00       	call   802316 <sys_calculate_free_frames>
  8008dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8008df:	e8 d2 1a 00 00       	call   8023b6 <sys_pf_calculate_allocated_pages>
  8008e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[12] = malloc(4*Mega - kilo);
  8008e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008ea:	c1 e0 02             	shl    $0x2,%eax
  8008ed:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8008f0:	83 ec 0c             	sub    $0xc,%esp
  8008f3:	50                   	push   %eax
  8008f4:	e8 de 15 00 00       	call   801ed7 <malloc>
  8008f9:	83 c4 10             	add    $0x10,%esp
  8008fc:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if ((uint32) ptr_allocations[12] != (USER_HEAP_START + 14*Mega) ) panic("Wrong start address for the allocated space... ");
  8008ff:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800902:	89 c1                	mov    %eax,%ecx
  800904:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800907:	89 d0                	mov    %edx,%eax
  800909:	01 c0                	add    %eax,%eax
  80090b:	01 d0                	add    %edx,%eax
  80090d:	01 c0                	add    %eax,%eax
  80090f:	01 d0                	add    %edx,%eax
  800911:	01 c0                	add    %eax,%eax
  800913:	05 00 00 00 80       	add    $0x80000000,%eax
  800918:	39 c1                	cmp    %eax,%ecx
  80091a:	74 17                	je     800933 <_main+0x8fb>
  80091c:	83 ec 04             	sub    $0x4,%esp
  80091f:	68 74 3c 80 00       	push   $0x803c74
  800924:	68 b0 00 00 00       	push   $0xb0
  800929:	68 5c 3c 80 00       	push   $0x803c5c
  80092e:	e8 77 03 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1024 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800933:	e8 7e 1a 00 00       	call   8023b6 <sys_pf_calculate_allocated_pages>
  800938:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80093b:	74 17                	je     800954 <_main+0x91c>
  80093d:	83 ec 04             	sub    $0x4,%esp
  800940:	68 a4 3c 80 00       	push   $0x803ca4
  800945:	68 b2 00 00 00       	push   $0xb2
  80094a:	68 5c 3c 80 00       	push   $0x803c5c
  80094f:	e8 56 03 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800954:	e8 bd 19 00 00       	call   802316 <sys_calculate_free_frames>
  800959:	89 c2                	mov    %eax,%edx
  80095b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80095e:	39 c2                	cmp    %eax,%edx
  800960:	74 17                	je     800979 <_main+0x941>
  800962:	83 ec 04             	sub    $0x4,%esp
  800965:	68 c1 3c 80 00       	push   $0x803cc1
  80096a:	68 b3 00 00 00       	push   $0xb3
  80096f:	68 5c 3c 80 00       	push   $0x803c5c
  800974:	e8 31 03 00 00       	call   800caa <_panic>
	}

	//[4] Free contiguous allocations
	{
		//1 MB Hole appended to previous 256 KB hole
		freeFrames = sys_calculate_free_frames() ;
  800979:	e8 98 19 00 00       	call   802316 <sys_calculate_free_frames>
  80097e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800981:	e8 30 1a 00 00       	call   8023b6 <sys_pf_calculate_allocated_pages>
  800986:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[2]);
  800989:	8b 45 98             	mov    -0x68(%ebp),%eax
  80098c:	83 ec 0c             	sub    $0xc,%esp
  80098f:	50                   	push   %eax
  800990:	e8 d9 15 00 00       	call   801f6e <free>
  800995:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800998:	e8 19 1a 00 00       	call   8023b6 <sys_pf_calculate_allocated_pages>
  80099d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8009a0:	74 17                	je     8009b9 <_main+0x981>
  8009a2:	83 ec 04             	sub    $0x4,%esp
  8009a5:	68 d4 3c 80 00       	push   $0x803cd4
  8009aa:	68 bd 00 00 00       	push   $0xbd
  8009af:	68 5c 3c 80 00       	push   $0x803c5c
  8009b4:	e8 f1 02 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8009b9:	e8 58 19 00 00       	call   802316 <sys_calculate_free_frames>
  8009be:	89 c2                	mov    %eax,%edx
  8009c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009c3:	39 c2                	cmp    %eax,%edx
  8009c5:	74 17                	je     8009de <_main+0x9a6>
  8009c7:	83 ec 04             	sub    $0x4,%esp
  8009ca:	68 eb 3c 80 00       	push   $0x803ceb
  8009cf:	68 be 00 00 00       	push   $0xbe
  8009d4:	68 5c 3c 80 00       	push   $0x803c5c
  8009d9:	e8 cc 02 00 00       	call   800caa <_panic>

		//1 MB Hole appended to next 1 MB hole
		freeFrames = sys_calculate_free_frames() ;
  8009de:	e8 33 19 00 00       	call   802316 <sys_calculate_free_frames>
  8009e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8009e6:	e8 cb 19 00 00       	call   8023b6 <sys_pf_calculate_allocated_pages>
  8009eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[9]);
  8009ee:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8009f1:	83 ec 0c             	sub    $0xc,%esp
  8009f4:	50                   	push   %eax
  8009f5:	e8 74 15 00 00       	call   801f6e <free>
  8009fa:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8009fd:	e8 b4 19 00 00       	call   8023b6 <sys_pf_calculate_allocated_pages>
  800a02:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800a05:	74 17                	je     800a1e <_main+0x9e6>
  800a07:	83 ec 04             	sub    $0x4,%esp
  800a0a:	68 d4 3c 80 00       	push   $0x803cd4
  800a0f:	68 c5 00 00 00       	push   $0xc5
  800a14:	68 5c 3c 80 00       	push   $0x803c5c
  800a19:	e8 8c 02 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a1e:	e8 f3 18 00 00       	call   802316 <sys_calculate_free_frames>
  800a23:	89 c2                	mov    %eax,%edx
  800a25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a28:	39 c2                	cmp    %eax,%edx
  800a2a:	74 17                	je     800a43 <_main+0xa0b>
  800a2c:	83 ec 04             	sub    $0x4,%esp
  800a2f:	68 eb 3c 80 00       	push   $0x803ceb
  800a34:	68 c6 00 00 00       	push   $0xc6
  800a39:	68 5c 3c 80 00       	push   $0x803c5c
  800a3e:	e8 67 02 00 00       	call   800caa <_panic>

		//1 MB Hole appended to previous 1 MB + 256 KB hole and next 2 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800a43:	e8 ce 18 00 00       	call   802316 <sys_calculate_free_frames>
  800a48:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a4b:	e8 66 19 00 00       	call   8023b6 <sys_pf_calculate_allocated_pages>
  800a50:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[3]);
  800a53:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800a56:	83 ec 0c             	sub    $0xc,%esp
  800a59:	50                   	push   %eax
  800a5a:	e8 0f 15 00 00       	call   801f6e <free>
  800a5f:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800a62:	e8 4f 19 00 00       	call   8023b6 <sys_pf_calculate_allocated_pages>
  800a67:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800a6a:	74 17                	je     800a83 <_main+0xa4b>
  800a6c:	83 ec 04             	sub    $0x4,%esp
  800a6f:	68 d4 3c 80 00       	push   $0x803cd4
  800a74:	68 cd 00 00 00       	push   $0xcd
  800a79:	68 5c 3c 80 00       	push   $0x803c5c
  800a7e:	e8 27 02 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a83:	e8 8e 18 00 00       	call   802316 <sys_calculate_free_frames>
  800a88:	89 c2                	mov    %eax,%edx
  800a8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a8d:	39 c2                	cmp    %eax,%edx
  800a8f:	74 17                	je     800aa8 <_main+0xa70>
  800a91:	83 ec 04             	sub    $0x4,%esp
  800a94:	68 eb 3c 80 00       	push   $0x803ceb
  800a99:	68 ce 00 00 00       	push   $0xce
  800a9e:	68 5c 3c 80 00       	push   $0x803c5c
  800aa3:	e8 02 02 00 00       	call   800caa <_panic>

	//[5] Allocate again [test first fit]
	{
		//[FIRST FIT Case]
		//Allocate 4 MB + 256 KB - should be placed in the contiguous hole (256 KB + 4 MB)
		freeFrames = sys_calculate_free_frames() ;
  800aa8:	e8 69 18 00 00       	call   802316 <sys_calculate_free_frames>
  800aad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800ab0:	e8 01 19 00 00       	call   8023b6 <sys_pf_calculate_allocated_pages>
  800ab5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[13] = malloc(4*Mega + 256*kilo - kilo);
  800ab8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800abb:	c1 e0 06             	shl    $0x6,%eax
  800abe:	89 c2                	mov    %eax,%edx
  800ac0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ac3:	01 d0                	add    %edx,%eax
  800ac5:	c1 e0 02             	shl    $0x2,%eax
  800ac8:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800acb:	83 ec 0c             	sub    $0xc,%esp
  800ace:	50                   	push   %eax
  800acf:	e8 03 14 00 00       	call   801ed7 <malloc>
  800ad4:	83 c4 10             	add    $0x10,%esp
  800ad7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if ((uint32) ptr_allocations[13] != (USER_HEAP_START + 1*Mega + 768*kilo)) panic("Wrong start address for the allocated space... ");
  800ada:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800add:	89 c1                	mov    %eax,%ecx
  800adf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800ae2:	89 d0                	mov    %edx,%eax
  800ae4:	01 c0                	add    %eax,%eax
  800ae6:	01 d0                	add    %edx,%eax
  800ae8:	c1 e0 08             	shl    $0x8,%eax
  800aeb:	89 c2                	mov    %eax,%edx
  800aed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800af0:	01 d0                	add    %edx,%eax
  800af2:	05 00 00 00 80       	add    $0x80000000,%eax
  800af7:	39 c1                	cmp    %eax,%ecx
  800af9:	74 17                	je     800b12 <_main+0xada>
  800afb:	83 ec 04             	sub    $0x4,%esp
  800afe:	68 74 3c 80 00       	push   $0x803c74
  800b03:	68 d8 00 00 00       	push   $0xd8
  800b08:	68 5c 3c 80 00       	push   $0x803c5c
  800b0d:	e8 98 01 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800b12:	e8 9f 18 00 00       	call   8023b6 <sys_pf_calculate_allocated_pages>
  800b17:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800b1a:	74 17                	je     800b33 <_main+0xafb>
  800b1c:	83 ec 04             	sub    $0x4,%esp
  800b1f:	68 a4 3c 80 00       	push   $0x803ca4
  800b24:	68 da 00 00 00       	push   $0xda
  800b29:	68 5c 3c 80 00       	push   $0x803c5c
  800b2e:	e8 77 01 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800b33:	e8 de 17 00 00       	call   802316 <sys_calculate_free_frames>
  800b38:	89 c2                	mov    %eax,%edx
  800b3a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800b3d:	39 c2                	cmp    %eax,%edx
  800b3f:	74 17                	je     800b58 <_main+0xb20>
  800b41:	83 ec 04             	sub    $0x4,%esp
  800b44:	68 c1 3c 80 00       	push   $0x803cc1
  800b49:	68 db 00 00 00       	push   $0xdb
  800b4e:	68 5c 3c 80 00       	push   $0x803c5c
  800b53:	e8 52 01 00 00       	call   800caa <_panic>
	}
	cprintf("Congratulations!! test FIRST FIT allocation (1) completed successfully.\n");
  800b58:	83 ec 0c             	sub    $0xc,%esp
  800b5b:	68 f8 3c 80 00       	push   $0x803cf8
  800b60:	e8 f9 03 00 00       	call   800f5e <cprintf>
  800b65:	83 c4 10             	add    $0x10,%esp

	return;
  800b68:	90                   	nop
}
  800b69:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800b6c:	c9                   	leave  
  800b6d:	c3                   	ret    

00800b6e <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800b6e:	55                   	push   %ebp
  800b6f:	89 e5                	mov    %esp,%ebp
  800b71:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800b74:	e8 7d 1a 00 00       	call   8025f6 <sys_getenvindex>
  800b79:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800b7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b7f:	89 d0                	mov    %edx,%eax
  800b81:	c1 e0 03             	shl    $0x3,%eax
  800b84:	01 d0                	add    %edx,%eax
  800b86:	01 c0                	add    %eax,%eax
  800b88:	01 d0                	add    %edx,%eax
  800b8a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b91:	01 d0                	add    %edx,%eax
  800b93:	c1 e0 04             	shl    $0x4,%eax
  800b96:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800b9b:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800ba0:	a1 20 50 80 00       	mov    0x805020,%eax
  800ba5:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800bab:	84 c0                	test   %al,%al
  800bad:	74 0f                	je     800bbe <libmain+0x50>
		binaryname = myEnv->prog_name;
  800baf:	a1 20 50 80 00       	mov    0x805020,%eax
  800bb4:	05 5c 05 00 00       	add    $0x55c,%eax
  800bb9:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800bbe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bc2:	7e 0a                	jle    800bce <libmain+0x60>
		binaryname = argv[0];
  800bc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc7:	8b 00                	mov    (%eax),%eax
  800bc9:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800bce:	83 ec 08             	sub    $0x8,%esp
  800bd1:	ff 75 0c             	pushl  0xc(%ebp)
  800bd4:	ff 75 08             	pushl  0x8(%ebp)
  800bd7:	e8 5c f4 ff ff       	call   800038 <_main>
  800bdc:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800bdf:	e8 1f 18 00 00       	call   802403 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800be4:	83 ec 0c             	sub    $0xc,%esp
  800be7:	68 5c 3d 80 00       	push   $0x803d5c
  800bec:	e8 6d 03 00 00       	call   800f5e <cprintf>
  800bf1:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800bf4:	a1 20 50 80 00       	mov    0x805020,%eax
  800bf9:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800bff:	a1 20 50 80 00       	mov    0x805020,%eax
  800c04:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800c0a:	83 ec 04             	sub    $0x4,%esp
  800c0d:	52                   	push   %edx
  800c0e:	50                   	push   %eax
  800c0f:	68 84 3d 80 00       	push   $0x803d84
  800c14:	e8 45 03 00 00       	call   800f5e <cprintf>
  800c19:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800c1c:	a1 20 50 80 00       	mov    0x805020,%eax
  800c21:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800c27:	a1 20 50 80 00       	mov    0x805020,%eax
  800c2c:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800c32:	a1 20 50 80 00       	mov    0x805020,%eax
  800c37:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800c3d:	51                   	push   %ecx
  800c3e:	52                   	push   %edx
  800c3f:	50                   	push   %eax
  800c40:	68 ac 3d 80 00       	push   $0x803dac
  800c45:	e8 14 03 00 00       	call   800f5e <cprintf>
  800c4a:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800c4d:	a1 20 50 80 00       	mov    0x805020,%eax
  800c52:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800c58:	83 ec 08             	sub    $0x8,%esp
  800c5b:	50                   	push   %eax
  800c5c:	68 04 3e 80 00       	push   $0x803e04
  800c61:	e8 f8 02 00 00       	call   800f5e <cprintf>
  800c66:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800c69:	83 ec 0c             	sub    $0xc,%esp
  800c6c:	68 5c 3d 80 00       	push   $0x803d5c
  800c71:	e8 e8 02 00 00       	call   800f5e <cprintf>
  800c76:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800c79:	e8 9f 17 00 00       	call   80241d <sys_enable_interrupt>

	// exit gracefully
	exit();
  800c7e:	e8 19 00 00 00       	call   800c9c <exit>
}
  800c83:	90                   	nop
  800c84:	c9                   	leave  
  800c85:	c3                   	ret    

00800c86 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800c86:	55                   	push   %ebp
  800c87:	89 e5                	mov    %esp,%ebp
  800c89:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800c8c:	83 ec 0c             	sub    $0xc,%esp
  800c8f:	6a 00                	push   $0x0
  800c91:	e8 2c 19 00 00       	call   8025c2 <sys_destroy_env>
  800c96:	83 c4 10             	add    $0x10,%esp
}
  800c99:	90                   	nop
  800c9a:	c9                   	leave  
  800c9b:	c3                   	ret    

00800c9c <exit>:

void
exit(void)
{
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
  800c9f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800ca2:	e8 81 19 00 00       	call   802628 <sys_exit_env>
}
  800ca7:	90                   	nop
  800ca8:	c9                   	leave  
  800ca9:	c3                   	ret    

00800caa <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800caa:	55                   	push   %ebp
  800cab:	89 e5                	mov    %esp,%ebp
  800cad:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800cb0:	8d 45 10             	lea    0x10(%ebp),%eax
  800cb3:	83 c0 04             	add    $0x4,%eax
  800cb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800cb9:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800cbe:	85 c0                	test   %eax,%eax
  800cc0:	74 16                	je     800cd8 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800cc2:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800cc7:	83 ec 08             	sub    $0x8,%esp
  800cca:	50                   	push   %eax
  800ccb:	68 18 3e 80 00       	push   $0x803e18
  800cd0:	e8 89 02 00 00       	call   800f5e <cprintf>
  800cd5:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800cd8:	a1 00 50 80 00       	mov    0x805000,%eax
  800cdd:	ff 75 0c             	pushl  0xc(%ebp)
  800ce0:	ff 75 08             	pushl  0x8(%ebp)
  800ce3:	50                   	push   %eax
  800ce4:	68 1d 3e 80 00       	push   $0x803e1d
  800ce9:	e8 70 02 00 00       	call   800f5e <cprintf>
  800cee:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800cf1:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf4:	83 ec 08             	sub    $0x8,%esp
  800cf7:	ff 75 f4             	pushl  -0xc(%ebp)
  800cfa:	50                   	push   %eax
  800cfb:	e8 f3 01 00 00       	call   800ef3 <vcprintf>
  800d00:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800d03:	83 ec 08             	sub    $0x8,%esp
  800d06:	6a 00                	push   $0x0
  800d08:	68 39 3e 80 00       	push   $0x803e39
  800d0d:	e8 e1 01 00 00       	call   800ef3 <vcprintf>
  800d12:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800d15:	e8 82 ff ff ff       	call   800c9c <exit>

	// should not return here
	while (1) ;
  800d1a:	eb fe                	jmp    800d1a <_panic+0x70>

00800d1c <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800d1c:	55                   	push   %ebp
  800d1d:	89 e5                	mov    %esp,%ebp
  800d1f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800d22:	a1 20 50 80 00       	mov    0x805020,%eax
  800d27:	8b 50 74             	mov    0x74(%eax),%edx
  800d2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2d:	39 c2                	cmp    %eax,%edx
  800d2f:	74 14                	je     800d45 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800d31:	83 ec 04             	sub    $0x4,%esp
  800d34:	68 3c 3e 80 00       	push   $0x803e3c
  800d39:	6a 26                	push   $0x26
  800d3b:	68 88 3e 80 00       	push   $0x803e88
  800d40:	e8 65 ff ff ff       	call   800caa <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800d45:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800d4c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d53:	e9 c2 00 00 00       	jmp    800e1a <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800d58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d5b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	01 d0                	add    %edx,%eax
  800d67:	8b 00                	mov    (%eax),%eax
  800d69:	85 c0                	test   %eax,%eax
  800d6b:	75 08                	jne    800d75 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800d6d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800d70:	e9 a2 00 00 00       	jmp    800e17 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800d75:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d7c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800d83:	eb 69                	jmp    800dee <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800d85:	a1 20 50 80 00       	mov    0x805020,%eax
  800d8a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d90:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d93:	89 d0                	mov    %edx,%eax
  800d95:	01 c0                	add    %eax,%eax
  800d97:	01 d0                	add    %edx,%eax
  800d99:	c1 e0 03             	shl    $0x3,%eax
  800d9c:	01 c8                	add    %ecx,%eax
  800d9e:	8a 40 04             	mov    0x4(%eax),%al
  800da1:	84 c0                	test   %al,%al
  800da3:	75 46                	jne    800deb <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800da5:	a1 20 50 80 00       	mov    0x805020,%eax
  800daa:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800db0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800db3:	89 d0                	mov    %edx,%eax
  800db5:	01 c0                	add    %eax,%eax
  800db7:	01 d0                	add    %edx,%eax
  800db9:	c1 e0 03             	shl    $0x3,%eax
  800dbc:	01 c8                	add    %ecx,%eax
  800dbe:	8b 00                	mov    (%eax),%eax
  800dc0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800dc3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800dc6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dcb:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dd0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	01 c8                	add    %ecx,%eax
  800ddc:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800dde:	39 c2                	cmp    %eax,%edx
  800de0:	75 09                	jne    800deb <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800de2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800de9:	eb 12                	jmp    800dfd <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800deb:	ff 45 e8             	incl   -0x18(%ebp)
  800dee:	a1 20 50 80 00       	mov    0x805020,%eax
  800df3:	8b 50 74             	mov    0x74(%eax),%edx
  800df6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800df9:	39 c2                	cmp    %eax,%edx
  800dfb:	77 88                	ja     800d85 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800dfd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800e01:	75 14                	jne    800e17 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800e03:	83 ec 04             	sub    $0x4,%esp
  800e06:	68 94 3e 80 00       	push   $0x803e94
  800e0b:	6a 3a                	push   $0x3a
  800e0d:	68 88 3e 80 00       	push   $0x803e88
  800e12:	e8 93 fe ff ff       	call   800caa <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800e17:	ff 45 f0             	incl   -0x10(%ebp)
  800e1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e1d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800e20:	0f 8c 32 ff ff ff    	jl     800d58 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800e26:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e2d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800e34:	eb 26                	jmp    800e5c <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800e36:	a1 20 50 80 00       	mov    0x805020,%eax
  800e3b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800e41:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e44:	89 d0                	mov    %edx,%eax
  800e46:	01 c0                	add    %eax,%eax
  800e48:	01 d0                	add    %edx,%eax
  800e4a:	c1 e0 03             	shl    $0x3,%eax
  800e4d:	01 c8                	add    %ecx,%eax
  800e4f:	8a 40 04             	mov    0x4(%eax),%al
  800e52:	3c 01                	cmp    $0x1,%al
  800e54:	75 03                	jne    800e59 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800e56:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e59:	ff 45 e0             	incl   -0x20(%ebp)
  800e5c:	a1 20 50 80 00       	mov    0x805020,%eax
  800e61:	8b 50 74             	mov    0x74(%eax),%edx
  800e64:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e67:	39 c2                	cmp    %eax,%edx
  800e69:	77 cb                	ja     800e36 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e6e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800e71:	74 14                	je     800e87 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800e73:	83 ec 04             	sub    $0x4,%esp
  800e76:	68 e8 3e 80 00       	push   $0x803ee8
  800e7b:	6a 44                	push   $0x44
  800e7d:	68 88 3e 80 00       	push   $0x803e88
  800e82:	e8 23 fe ff ff       	call   800caa <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800e87:	90                   	nop
  800e88:	c9                   	leave  
  800e89:	c3                   	ret    

00800e8a <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800e8a:	55                   	push   %ebp
  800e8b:	89 e5                	mov    %esp,%ebp
  800e8d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800e90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e93:	8b 00                	mov    (%eax),%eax
  800e95:	8d 48 01             	lea    0x1(%eax),%ecx
  800e98:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e9b:	89 0a                	mov    %ecx,(%edx)
  800e9d:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea0:	88 d1                	mov    %dl,%cl
  800ea2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea5:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800ea9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eac:	8b 00                	mov    (%eax),%eax
  800eae:	3d ff 00 00 00       	cmp    $0xff,%eax
  800eb3:	75 2c                	jne    800ee1 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800eb5:	a0 24 50 80 00       	mov    0x805024,%al
  800eba:	0f b6 c0             	movzbl %al,%eax
  800ebd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec0:	8b 12                	mov    (%edx),%edx
  800ec2:	89 d1                	mov    %edx,%ecx
  800ec4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec7:	83 c2 08             	add    $0x8,%edx
  800eca:	83 ec 04             	sub    $0x4,%esp
  800ecd:	50                   	push   %eax
  800ece:	51                   	push   %ecx
  800ecf:	52                   	push   %edx
  800ed0:	e8 80 13 00 00       	call   802255 <sys_cputs>
  800ed5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800ed8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800ee1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee4:	8b 40 04             	mov    0x4(%eax),%eax
  800ee7:	8d 50 01             	lea    0x1(%eax),%edx
  800eea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eed:	89 50 04             	mov    %edx,0x4(%eax)
}
  800ef0:	90                   	nop
  800ef1:	c9                   	leave  
  800ef2:	c3                   	ret    

00800ef3 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800ef3:	55                   	push   %ebp
  800ef4:	89 e5                	mov    %esp,%ebp
  800ef6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800efc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800f03:	00 00 00 
	b.cnt = 0;
  800f06:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800f0d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800f10:	ff 75 0c             	pushl  0xc(%ebp)
  800f13:	ff 75 08             	pushl  0x8(%ebp)
  800f16:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800f1c:	50                   	push   %eax
  800f1d:	68 8a 0e 80 00       	push   $0x800e8a
  800f22:	e8 11 02 00 00       	call   801138 <vprintfmt>
  800f27:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800f2a:	a0 24 50 80 00       	mov    0x805024,%al
  800f2f:	0f b6 c0             	movzbl %al,%eax
  800f32:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800f38:	83 ec 04             	sub    $0x4,%esp
  800f3b:	50                   	push   %eax
  800f3c:	52                   	push   %edx
  800f3d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800f43:	83 c0 08             	add    $0x8,%eax
  800f46:	50                   	push   %eax
  800f47:	e8 09 13 00 00       	call   802255 <sys_cputs>
  800f4c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800f4f:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800f56:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800f5c:	c9                   	leave  
  800f5d:	c3                   	ret    

00800f5e <cprintf>:

int cprintf(const char *fmt, ...) {
  800f5e:	55                   	push   %ebp
  800f5f:	89 e5                	mov    %esp,%ebp
  800f61:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800f64:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800f6b:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f71:	8b 45 08             	mov    0x8(%ebp),%eax
  800f74:	83 ec 08             	sub    $0x8,%esp
  800f77:	ff 75 f4             	pushl  -0xc(%ebp)
  800f7a:	50                   	push   %eax
  800f7b:	e8 73 ff ff ff       	call   800ef3 <vcprintf>
  800f80:	83 c4 10             	add    $0x10,%esp
  800f83:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800f86:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f89:	c9                   	leave  
  800f8a:	c3                   	ret    

00800f8b <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800f8b:	55                   	push   %ebp
  800f8c:	89 e5                	mov    %esp,%ebp
  800f8e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800f91:	e8 6d 14 00 00       	call   802403 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800f96:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f99:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	83 ec 08             	sub    $0x8,%esp
  800fa2:	ff 75 f4             	pushl  -0xc(%ebp)
  800fa5:	50                   	push   %eax
  800fa6:	e8 48 ff ff ff       	call   800ef3 <vcprintf>
  800fab:	83 c4 10             	add    $0x10,%esp
  800fae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800fb1:	e8 67 14 00 00       	call   80241d <sys_enable_interrupt>
	return cnt;
  800fb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800fb9:	c9                   	leave  
  800fba:	c3                   	ret    

00800fbb <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800fbb:	55                   	push   %ebp
  800fbc:	89 e5                	mov    %esp,%ebp
  800fbe:	53                   	push   %ebx
  800fbf:	83 ec 14             	sub    $0x14,%esp
  800fc2:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fc8:	8b 45 14             	mov    0x14(%ebp),%eax
  800fcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800fce:	8b 45 18             	mov    0x18(%ebp),%eax
  800fd1:	ba 00 00 00 00       	mov    $0x0,%edx
  800fd6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800fd9:	77 55                	ja     801030 <printnum+0x75>
  800fdb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800fde:	72 05                	jb     800fe5 <printnum+0x2a>
  800fe0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fe3:	77 4b                	ja     801030 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800fe5:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800fe8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800feb:	8b 45 18             	mov    0x18(%ebp),%eax
  800fee:	ba 00 00 00 00       	mov    $0x0,%edx
  800ff3:	52                   	push   %edx
  800ff4:	50                   	push   %eax
  800ff5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ff8:	ff 75 f0             	pushl  -0x10(%ebp)
  800ffb:	e8 d0 29 00 00       	call   8039d0 <__udivdi3>
  801000:	83 c4 10             	add    $0x10,%esp
  801003:	83 ec 04             	sub    $0x4,%esp
  801006:	ff 75 20             	pushl  0x20(%ebp)
  801009:	53                   	push   %ebx
  80100a:	ff 75 18             	pushl  0x18(%ebp)
  80100d:	52                   	push   %edx
  80100e:	50                   	push   %eax
  80100f:	ff 75 0c             	pushl  0xc(%ebp)
  801012:	ff 75 08             	pushl  0x8(%ebp)
  801015:	e8 a1 ff ff ff       	call   800fbb <printnum>
  80101a:	83 c4 20             	add    $0x20,%esp
  80101d:	eb 1a                	jmp    801039 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80101f:	83 ec 08             	sub    $0x8,%esp
  801022:	ff 75 0c             	pushl  0xc(%ebp)
  801025:	ff 75 20             	pushl  0x20(%ebp)
  801028:	8b 45 08             	mov    0x8(%ebp),%eax
  80102b:	ff d0                	call   *%eax
  80102d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801030:	ff 4d 1c             	decl   0x1c(%ebp)
  801033:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801037:	7f e6                	jg     80101f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801039:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80103c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801041:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801044:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801047:	53                   	push   %ebx
  801048:	51                   	push   %ecx
  801049:	52                   	push   %edx
  80104a:	50                   	push   %eax
  80104b:	e8 90 2a 00 00       	call   803ae0 <__umoddi3>
  801050:	83 c4 10             	add    $0x10,%esp
  801053:	05 54 41 80 00       	add    $0x804154,%eax
  801058:	8a 00                	mov    (%eax),%al
  80105a:	0f be c0             	movsbl %al,%eax
  80105d:	83 ec 08             	sub    $0x8,%esp
  801060:	ff 75 0c             	pushl  0xc(%ebp)
  801063:	50                   	push   %eax
  801064:	8b 45 08             	mov    0x8(%ebp),%eax
  801067:	ff d0                	call   *%eax
  801069:	83 c4 10             	add    $0x10,%esp
}
  80106c:	90                   	nop
  80106d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801070:	c9                   	leave  
  801071:	c3                   	ret    

00801072 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801072:	55                   	push   %ebp
  801073:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801075:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801079:	7e 1c                	jle    801097 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80107b:	8b 45 08             	mov    0x8(%ebp),%eax
  80107e:	8b 00                	mov    (%eax),%eax
  801080:	8d 50 08             	lea    0x8(%eax),%edx
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	89 10                	mov    %edx,(%eax)
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
  80108b:	8b 00                	mov    (%eax),%eax
  80108d:	83 e8 08             	sub    $0x8,%eax
  801090:	8b 50 04             	mov    0x4(%eax),%edx
  801093:	8b 00                	mov    (%eax),%eax
  801095:	eb 40                	jmp    8010d7 <getuint+0x65>
	else if (lflag)
  801097:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80109b:	74 1e                	je     8010bb <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80109d:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a0:	8b 00                	mov    (%eax),%eax
  8010a2:	8d 50 04             	lea    0x4(%eax),%edx
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a8:	89 10                	mov    %edx,(%eax)
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	8b 00                	mov    (%eax),%eax
  8010af:	83 e8 04             	sub    $0x4,%eax
  8010b2:	8b 00                	mov    (%eax),%eax
  8010b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8010b9:	eb 1c                	jmp    8010d7 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	8b 00                	mov    (%eax),%eax
  8010c0:	8d 50 04             	lea    0x4(%eax),%edx
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	89 10                	mov    %edx,(%eax)
  8010c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cb:	8b 00                	mov    (%eax),%eax
  8010cd:	83 e8 04             	sub    $0x4,%eax
  8010d0:	8b 00                	mov    (%eax),%eax
  8010d2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8010d7:	5d                   	pop    %ebp
  8010d8:	c3                   	ret    

008010d9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8010d9:	55                   	push   %ebp
  8010da:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8010dc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8010e0:	7e 1c                	jle    8010fe <getint+0x25>
		return va_arg(*ap, long long);
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e5:	8b 00                	mov    (%eax),%eax
  8010e7:	8d 50 08             	lea    0x8(%eax),%edx
  8010ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ed:	89 10                	mov    %edx,(%eax)
  8010ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f2:	8b 00                	mov    (%eax),%eax
  8010f4:	83 e8 08             	sub    $0x8,%eax
  8010f7:	8b 50 04             	mov    0x4(%eax),%edx
  8010fa:	8b 00                	mov    (%eax),%eax
  8010fc:	eb 38                	jmp    801136 <getint+0x5d>
	else if (lflag)
  8010fe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801102:	74 1a                	je     80111e <getint+0x45>
		return va_arg(*ap, long);
  801104:	8b 45 08             	mov    0x8(%ebp),%eax
  801107:	8b 00                	mov    (%eax),%eax
  801109:	8d 50 04             	lea    0x4(%eax),%edx
  80110c:	8b 45 08             	mov    0x8(%ebp),%eax
  80110f:	89 10                	mov    %edx,(%eax)
  801111:	8b 45 08             	mov    0x8(%ebp),%eax
  801114:	8b 00                	mov    (%eax),%eax
  801116:	83 e8 04             	sub    $0x4,%eax
  801119:	8b 00                	mov    (%eax),%eax
  80111b:	99                   	cltd   
  80111c:	eb 18                	jmp    801136 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80111e:	8b 45 08             	mov    0x8(%ebp),%eax
  801121:	8b 00                	mov    (%eax),%eax
  801123:	8d 50 04             	lea    0x4(%eax),%edx
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	89 10                	mov    %edx,(%eax)
  80112b:	8b 45 08             	mov    0x8(%ebp),%eax
  80112e:	8b 00                	mov    (%eax),%eax
  801130:	83 e8 04             	sub    $0x4,%eax
  801133:	8b 00                	mov    (%eax),%eax
  801135:	99                   	cltd   
}
  801136:	5d                   	pop    %ebp
  801137:	c3                   	ret    

00801138 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801138:	55                   	push   %ebp
  801139:	89 e5                	mov    %esp,%ebp
  80113b:	56                   	push   %esi
  80113c:	53                   	push   %ebx
  80113d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801140:	eb 17                	jmp    801159 <vprintfmt+0x21>
			if (ch == '\0')
  801142:	85 db                	test   %ebx,%ebx
  801144:	0f 84 af 03 00 00    	je     8014f9 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80114a:	83 ec 08             	sub    $0x8,%esp
  80114d:	ff 75 0c             	pushl  0xc(%ebp)
  801150:	53                   	push   %ebx
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
  801154:	ff d0                	call   *%eax
  801156:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801159:	8b 45 10             	mov    0x10(%ebp),%eax
  80115c:	8d 50 01             	lea    0x1(%eax),%edx
  80115f:	89 55 10             	mov    %edx,0x10(%ebp)
  801162:	8a 00                	mov    (%eax),%al
  801164:	0f b6 d8             	movzbl %al,%ebx
  801167:	83 fb 25             	cmp    $0x25,%ebx
  80116a:	75 d6                	jne    801142 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80116c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801170:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801177:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80117e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801185:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80118c:	8b 45 10             	mov    0x10(%ebp),%eax
  80118f:	8d 50 01             	lea    0x1(%eax),%edx
  801192:	89 55 10             	mov    %edx,0x10(%ebp)
  801195:	8a 00                	mov    (%eax),%al
  801197:	0f b6 d8             	movzbl %al,%ebx
  80119a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80119d:	83 f8 55             	cmp    $0x55,%eax
  8011a0:	0f 87 2b 03 00 00    	ja     8014d1 <vprintfmt+0x399>
  8011a6:	8b 04 85 78 41 80 00 	mov    0x804178(,%eax,4),%eax
  8011ad:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8011af:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8011b3:	eb d7                	jmp    80118c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8011b5:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8011b9:	eb d1                	jmp    80118c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011bb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8011c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8011c5:	89 d0                	mov    %edx,%eax
  8011c7:	c1 e0 02             	shl    $0x2,%eax
  8011ca:	01 d0                	add    %edx,%eax
  8011cc:	01 c0                	add    %eax,%eax
  8011ce:	01 d8                	add    %ebx,%eax
  8011d0:	83 e8 30             	sub    $0x30,%eax
  8011d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8011d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d9:	8a 00                	mov    (%eax),%al
  8011db:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8011de:	83 fb 2f             	cmp    $0x2f,%ebx
  8011e1:	7e 3e                	jle    801221 <vprintfmt+0xe9>
  8011e3:	83 fb 39             	cmp    $0x39,%ebx
  8011e6:	7f 39                	jg     801221 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011e8:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8011eb:	eb d5                	jmp    8011c2 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8011ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f0:	83 c0 04             	add    $0x4,%eax
  8011f3:	89 45 14             	mov    %eax,0x14(%ebp)
  8011f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f9:	83 e8 04             	sub    $0x4,%eax
  8011fc:	8b 00                	mov    (%eax),%eax
  8011fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801201:	eb 1f                	jmp    801222 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801203:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801207:	79 83                	jns    80118c <vprintfmt+0x54>
				width = 0;
  801209:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801210:	e9 77 ff ff ff       	jmp    80118c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801215:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80121c:	e9 6b ff ff ff       	jmp    80118c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801221:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801222:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801226:	0f 89 60 ff ff ff    	jns    80118c <vprintfmt+0x54>
				width = precision, precision = -1;
  80122c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80122f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801232:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801239:	e9 4e ff ff ff       	jmp    80118c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80123e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801241:	e9 46 ff ff ff       	jmp    80118c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801246:	8b 45 14             	mov    0x14(%ebp),%eax
  801249:	83 c0 04             	add    $0x4,%eax
  80124c:	89 45 14             	mov    %eax,0x14(%ebp)
  80124f:	8b 45 14             	mov    0x14(%ebp),%eax
  801252:	83 e8 04             	sub    $0x4,%eax
  801255:	8b 00                	mov    (%eax),%eax
  801257:	83 ec 08             	sub    $0x8,%esp
  80125a:	ff 75 0c             	pushl  0xc(%ebp)
  80125d:	50                   	push   %eax
  80125e:	8b 45 08             	mov    0x8(%ebp),%eax
  801261:	ff d0                	call   *%eax
  801263:	83 c4 10             	add    $0x10,%esp
			break;
  801266:	e9 89 02 00 00       	jmp    8014f4 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80126b:	8b 45 14             	mov    0x14(%ebp),%eax
  80126e:	83 c0 04             	add    $0x4,%eax
  801271:	89 45 14             	mov    %eax,0x14(%ebp)
  801274:	8b 45 14             	mov    0x14(%ebp),%eax
  801277:	83 e8 04             	sub    $0x4,%eax
  80127a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80127c:	85 db                	test   %ebx,%ebx
  80127e:	79 02                	jns    801282 <vprintfmt+0x14a>
				err = -err;
  801280:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801282:	83 fb 64             	cmp    $0x64,%ebx
  801285:	7f 0b                	jg     801292 <vprintfmt+0x15a>
  801287:	8b 34 9d c0 3f 80 00 	mov    0x803fc0(,%ebx,4),%esi
  80128e:	85 f6                	test   %esi,%esi
  801290:	75 19                	jne    8012ab <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801292:	53                   	push   %ebx
  801293:	68 65 41 80 00       	push   $0x804165
  801298:	ff 75 0c             	pushl  0xc(%ebp)
  80129b:	ff 75 08             	pushl  0x8(%ebp)
  80129e:	e8 5e 02 00 00       	call   801501 <printfmt>
  8012a3:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8012a6:	e9 49 02 00 00       	jmp    8014f4 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8012ab:	56                   	push   %esi
  8012ac:	68 6e 41 80 00       	push   $0x80416e
  8012b1:	ff 75 0c             	pushl  0xc(%ebp)
  8012b4:	ff 75 08             	pushl  0x8(%ebp)
  8012b7:	e8 45 02 00 00       	call   801501 <printfmt>
  8012bc:	83 c4 10             	add    $0x10,%esp
			break;
  8012bf:	e9 30 02 00 00       	jmp    8014f4 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8012c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c7:	83 c0 04             	add    $0x4,%eax
  8012ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8012cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d0:	83 e8 04             	sub    $0x4,%eax
  8012d3:	8b 30                	mov    (%eax),%esi
  8012d5:	85 f6                	test   %esi,%esi
  8012d7:	75 05                	jne    8012de <vprintfmt+0x1a6>
				p = "(null)";
  8012d9:	be 71 41 80 00       	mov    $0x804171,%esi
			if (width > 0 && padc != '-')
  8012de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012e2:	7e 6d                	jle    801351 <vprintfmt+0x219>
  8012e4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8012e8:	74 67                	je     801351 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8012ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012ed:	83 ec 08             	sub    $0x8,%esp
  8012f0:	50                   	push   %eax
  8012f1:	56                   	push   %esi
  8012f2:	e8 0c 03 00 00       	call   801603 <strnlen>
  8012f7:	83 c4 10             	add    $0x10,%esp
  8012fa:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8012fd:	eb 16                	jmp    801315 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8012ff:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801303:	83 ec 08             	sub    $0x8,%esp
  801306:	ff 75 0c             	pushl  0xc(%ebp)
  801309:	50                   	push   %eax
  80130a:	8b 45 08             	mov    0x8(%ebp),%eax
  80130d:	ff d0                	call   *%eax
  80130f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801312:	ff 4d e4             	decl   -0x1c(%ebp)
  801315:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801319:	7f e4                	jg     8012ff <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80131b:	eb 34                	jmp    801351 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80131d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801321:	74 1c                	je     80133f <vprintfmt+0x207>
  801323:	83 fb 1f             	cmp    $0x1f,%ebx
  801326:	7e 05                	jle    80132d <vprintfmt+0x1f5>
  801328:	83 fb 7e             	cmp    $0x7e,%ebx
  80132b:	7e 12                	jle    80133f <vprintfmt+0x207>
					putch('?', putdat);
  80132d:	83 ec 08             	sub    $0x8,%esp
  801330:	ff 75 0c             	pushl  0xc(%ebp)
  801333:	6a 3f                	push   $0x3f
  801335:	8b 45 08             	mov    0x8(%ebp),%eax
  801338:	ff d0                	call   *%eax
  80133a:	83 c4 10             	add    $0x10,%esp
  80133d:	eb 0f                	jmp    80134e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80133f:	83 ec 08             	sub    $0x8,%esp
  801342:	ff 75 0c             	pushl  0xc(%ebp)
  801345:	53                   	push   %ebx
  801346:	8b 45 08             	mov    0x8(%ebp),%eax
  801349:	ff d0                	call   *%eax
  80134b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80134e:	ff 4d e4             	decl   -0x1c(%ebp)
  801351:	89 f0                	mov    %esi,%eax
  801353:	8d 70 01             	lea    0x1(%eax),%esi
  801356:	8a 00                	mov    (%eax),%al
  801358:	0f be d8             	movsbl %al,%ebx
  80135b:	85 db                	test   %ebx,%ebx
  80135d:	74 24                	je     801383 <vprintfmt+0x24b>
  80135f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801363:	78 b8                	js     80131d <vprintfmt+0x1e5>
  801365:	ff 4d e0             	decl   -0x20(%ebp)
  801368:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80136c:	79 af                	jns    80131d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80136e:	eb 13                	jmp    801383 <vprintfmt+0x24b>
				putch(' ', putdat);
  801370:	83 ec 08             	sub    $0x8,%esp
  801373:	ff 75 0c             	pushl  0xc(%ebp)
  801376:	6a 20                	push   $0x20
  801378:	8b 45 08             	mov    0x8(%ebp),%eax
  80137b:	ff d0                	call   *%eax
  80137d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801380:	ff 4d e4             	decl   -0x1c(%ebp)
  801383:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801387:	7f e7                	jg     801370 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801389:	e9 66 01 00 00       	jmp    8014f4 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80138e:	83 ec 08             	sub    $0x8,%esp
  801391:	ff 75 e8             	pushl  -0x18(%ebp)
  801394:	8d 45 14             	lea    0x14(%ebp),%eax
  801397:	50                   	push   %eax
  801398:	e8 3c fd ff ff       	call   8010d9 <getint>
  80139d:	83 c4 10             	add    $0x10,%esp
  8013a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013a3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8013a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013ac:	85 d2                	test   %edx,%edx
  8013ae:	79 23                	jns    8013d3 <vprintfmt+0x29b>
				putch('-', putdat);
  8013b0:	83 ec 08             	sub    $0x8,%esp
  8013b3:	ff 75 0c             	pushl  0xc(%ebp)
  8013b6:	6a 2d                	push   $0x2d
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	ff d0                	call   *%eax
  8013bd:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8013c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013c6:	f7 d8                	neg    %eax
  8013c8:	83 d2 00             	adc    $0x0,%edx
  8013cb:	f7 da                	neg    %edx
  8013cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013d0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8013d3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8013da:	e9 bc 00 00 00       	jmp    80149b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8013df:	83 ec 08             	sub    $0x8,%esp
  8013e2:	ff 75 e8             	pushl  -0x18(%ebp)
  8013e5:	8d 45 14             	lea    0x14(%ebp),%eax
  8013e8:	50                   	push   %eax
  8013e9:	e8 84 fc ff ff       	call   801072 <getuint>
  8013ee:	83 c4 10             	add    $0x10,%esp
  8013f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013f4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8013f7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8013fe:	e9 98 00 00 00       	jmp    80149b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801403:	83 ec 08             	sub    $0x8,%esp
  801406:	ff 75 0c             	pushl  0xc(%ebp)
  801409:	6a 58                	push   $0x58
  80140b:	8b 45 08             	mov    0x8(%ebp),%eax
  80140e:	ff d0                	call   *%eax
  801410:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801413:	83 ec 08             	sub    $0x8,%esp
  801416:	ff 75 0c             	pushl  0xc(%ebp)
  801419:	6a 58                	push   $0x58
  80141b:	8b 45 08             	mov    0x8(%ebp),%eax
  80141e:	ff d0                	call   *%eax
  801420:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801423:	83 ec 08             	sub    $0x8,%esp
  801426:	ff 75 0c             	pushl  0xc(%ebp)
  801429:	6a 58                	push   $0x58
  80142b:	8b 45 08             	mov    0x8(%ebp),%eax
  80142e:	ff d0                	call   *%eax
  801430:	83 c4 10             	add    $0x10,%esp
			break;
  801433:	e9 bc 00 00 00       	jmp    8014f4 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801438:	83 ec 08             	sub    $0x8,%esp
  80143b:	ff 75 0c             	pushl  0xc(%ebp)
  80143e:	6a 30                	push   $0x30
  801440:	8b 45 08             	mov    0x8(%ebp),%eax
  801443:	ff d0                	call   *%eax
  801445:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801448:	83 ec 08             	sub    $0x8,%esp
  80144b:	ff 75 0c             	pushl  0xc(%ebp)
  80144e:	6a 78                	push   $0x78
  801450:	8b 45 08             	mov    0x8(%ebp),%eax
  801453:	ff d0                	call   *%eax
  801455:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801458:	8b 45 14             	mov    0x14(%ebp),%eax
  80145b:	83 c0 04             	add    $0x4,%eax
  80145e:	89 45 14             	mov    %eax,0x14(%ebp)
  801461:	8b 45 14             	mov    0x14(%ebp),%eax
  801464:	83 e8 04             	sub    $0x4,%eax
  801467:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801469:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80146c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801473:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80147a:	eb 1f                	jmp    80149b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80147c:	83 ec 08             	sub    $0x8,%esp
  80147f:	ff 75 e8             	pushl  -0x18(%ebp)
  801482:	8d 45 14             	lea    0x14(%ebp),%eax
  801485:	50                   	push   %eax
  801486:	e8 e7 fb ff ff       	call   801072 <getuint>
  80148b:	83 c4 10             	add    $0x10,%esp
  80148e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801491:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801494:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80149b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80149f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014a2:	83 ec 04             	sub    $0x4,%esp
  8014a5:	52                   	push   %edx
  8014a6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014a9:	50                   	push   %eax
  8014aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8014ad:	ff 75 f0             	pushl  -0x10(%ebp)
  8014b0:	ff 75 0c             	pushl  0xc(%ebp)
  8014b3:	ff 75 08             	pushl  0x8(%ebp)
  8014b6:	e8 00 fb ff ff       	call   800fbb <printnum>
  8014bb:	83 c4 20             	add    $0x20,%esp
			break;
  8014be:	eb 34                	jmp    8014f4 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8014c0:	83 ec 08             	sub    $0x8,%esp
  8014c3:	ff 75 0c             	pushl  0xc(%ebp)
  8014c6:	53                   	push   %ebx
  8014c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ca:	ff d0                	call   *%eax
  8014cc:	83 c4 10             	add    $0x10,%esp
			break;
  8014cf:	eb 23                	jmp    8014f4 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8014d1:	83 ec 08             	sub    $0x8,%esp
  8014d4:	ff 75 0c             	pushl  0xc(%ebp)
  8014d7:	6a 25                	push   $0x25
  8014d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dc:	ff d0                	call   *%eax
  8014de:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8014e1:	ff 4d 10             	decl   0x10(%ebp)
  8014e4:	eb 03                	jmp    8014e9 <vprintfmt+0x3b1>
  8014e6:	ff 4d 10             	decl   0x10(%ebp)
  8014e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ec:	48                   	dec    %eax
  8014ed:	8a 00                	mov    (%eax),%al
  8014ef:	3c 25                	cmp    $0x25,%al
  8014f1:	75 f3                	jne    8014e6 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8014f3:	90                   	nop
		}
	}
  8014f4:	e9 47 fc ff ff       	jmp    801140 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8014f9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8014fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014fd:	5b                   	pop    %ebx
  8014fe:	5e                   	pop    %esi
  8014ff:	5d                   	pop    %ebp
  801500:	c3                   	ret    

00801501 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801501:	55                   	push   %ebp
  801502:	89 e5                	mov    %esp,%ebp
  801504:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801507:	8d 45 10             	lea    0x10(%ebp),%eax
  80150a:	83 c0 04             	add    $0x4,%eax
  80150d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801510:	8b 45 10             	mov    0x10(%ebp),%eax
  801513:	ff 75 f4             	pushl  -0xc(%ebp)
  801516:	50                   	push   %eax
  801517:	ff 75 0c             	pushl  0xc(%ebp)
  80151a:	ff 75 08             	pushl  0x8(%ebp)
  80151d:	e8 16 fc ff ff       	call   801138 <vprintfmt>
  801522:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801525:	90                   	nop
  801526:	c9                   	leave  
  801527:	c3                   	ret    

00801528 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801528:	55                   	push   %ebp
  801529:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80152b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80152e:	8b 40 08             	mov    0x8(%eax),%eax
  801531:	8d 50 01             	lea    0x1(%eax),%edx
  801534:	8b 45 0c             	mov    0xc(%ebp),%eax
  801537:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80153a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153d:	8b 10                	mov    (%eax),%edx
  80153f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801542:	8b 40 04             	mov    0x4(%eax),%eax
  801545:	39 c2                	cmp    %eax,%edx
  801547:	73 12                	jae    80155b <sprintputch+0x33>
		*b->buf++ = ch;
  801549:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154c:	8b 00                	mov    (%eax),%eax
  80154e:	8d 48 01             	lea    0x1(%eax),%ecx
  801551:	8b 55 0c             	mov    0xc(%ebp),%edx
  801554:	89 0a                	mov    %ecx,(%edx)
  801556:	8b 55 08             	mov    0x8(%ebp),%edx
  801559:	88 10                	mov    %dl,(%eax)
}
  80155b:	90                   	nop
  80155c:	5d                   	pop    %ebp
  80155d:	c3                   	ret    

0080155e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80155e:	55                   	push   %ebp
  80155f:	89 e5                	mov    %esp,%ebp
  801561:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
  801567:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80156a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801570:	8b 45 08             	mov    0x8(%ebp),%eax
  801573:	01 d0                	add    %edx,%eax
  801575:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801578:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80157f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801583:	74 06                	je     80158b <vsnprintf+0x2d>
  801585:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801589:	7f 07                	jg     801592 <vsnprintf+0x34>
		return -E_INVAL;
  80158b:	b8 03 00 00 00       	mov    $0x3,%eax
  801590:	eb 20                	jmp    8015b2 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801592:	ff 75 14             	pushl  0x14(%ebp)
  801595:	ff 75 10             	pushl  0x10(%ebp)
  801598:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80159b:	50                   	push   %eax
  80159c:	68 28 15 80 00       	push   $0x801528
  8015a1:	e8 92 fb ff ff       	call   801138 <vprintfmt>
  8015a6:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8015a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ac:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8015af:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8015b2:	c9                   	leave  
  8015b3:	c3                   	ret    

008015b4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8015b4:	55                   	push   %ebp
  8015b5:	89 e5                	mov    %esp,%ebp
  8015b7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8015ba:	8d 45 10             	lea    0x10(%ebp),%eax
  8015bd:	83 c0 04             	add    $0x4,%eax
  8015c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8015c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8015c9:	50                   	push   %eax
  8015ca:	ff 75 0c             	pushl  0xc(%ebp)
  8015cd:	ff 75 08             	pushl  0x8(%ebp)
  8015d0:	e8 89 ff ff ff       	call   80155e <vsnprintf>
  8015d5:	83 c4 10             	add    $0x10,%esp
  8015d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8015db:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015de:	c9                   	leave  
  8015df:	c3                   	ret    

008015e0 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
  8015e3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8015e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015ed:	eb 06                	jmp    8015f5 <strlen+0x15>
		n++;
  8015ef:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8015f2:	ff 45 08             	incl   0x8(%ebp)
  8015f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f8:	8a 00                	mov    (%eax),%al
  8015fa:	84 c0                	test   %al,%al
  8015fc:	75 f1                	jne    8015ef <strlen+0xf>
		n++;
	return n;
  8015fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801601:	c9                   	leave  
  801602:	c3                   	ret    

00801603 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
  801606:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801609:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801610:	eb 09                	jmp    80161b <strnlen+0x18>
		n++;
  801612:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801615:	ff 45 08             	incl   0x8(%ebp)
  801618:	ff 4d 0c             	decl   0xc(%ebp)
  80161b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80161f:	74 09                	je     80162a <strnlen+0x27>
  801621:	8b 45 08             	mov    0x8(%ebp),%eax
  801624:	8a 00                	mov    (%eax),%al
  801626:	84 c0                	test   %al,%al
  801628:	75 e8                	jne    801612 <strnlen+0xf>
		n++;
	return n;
  80162a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80162d:	c9                   	leave  
  80162e:	c3                   	ret    

0080162f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80162f:	55                   	push   %ebp
  801630:	89 e5                	mov    %esp,%ebp
  801632:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801635:	8b 45 08             	mov    0x8(%ebp),%eax
  801638:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80163b:	90                   	nop
  80163c:	8b 45 08             	mov    0x8(%ebp),%eax
  80163f:	8d 50 01             	lea    0x1(%eax),%edx
  801642:	89 55 08             	mov    %edx,0x8(%ebp)
  801645:	8b 55 0c             	mov    0xc(%ebp),%edx
  801648:	8d 4a 01             	lea    0x1(%edx),%ecx
  80164b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80164e:	8a 12                	mov    (%edx),%dl
  801650:	88 10                	mov    %dl,(%eax)
  801652:	8a 00                	mov    (%eax),%al
  801654:	84 c0                	test   %al,%al
  801656:	75 e4                	jne    80163c <strcpy+0xd>
		/* do nothing */;
	return ret;
  801658:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80165b:	c9                   	leave  
  80165c:	c3                   	ret    

0080165d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80165d:	55                   	push   %ebp
  80165e:	89 e5                	mov    %esp,%ebp
  801660:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801663:	8b 45 08             	mov    0x8(%ebp),%eax
  801666:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801669:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801670:	eb 1f                	jmp    801691 <strncpy+0x34>
		*dst++ = *src;
  801672:	8b 45 08             	mov    0x8(%ebp),%eax
  801675:	8d 50 01             	lea    0x1(%eax),%edx
  801678:	89 55 08             	mov    %edx,0x8(%ebp)
  80167b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80167e:	8a 12                	mov    (%edx),%dl
  801680:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801682:	8b 45 0c             	mov    0xc(%ebp),%eax
  801685:	8a 00                	mov    (%eax),%al
  801687:	84 c0                	test   %al,%al
  801689:	74 03                	je     80168e <strncpy+0x31>
			src++;
  80168b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80168e:	ff 45 fc             	incl   -0x4(%ebp)
  801691:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801694:	3b 45 10             	cmp    0x10(%ebp),%eax
  801697:	72 d9                	jb     801672 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801699:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80169c:	c9                   	leave  
  80169d:	c3                   	ret    

0080169e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80169e:	55                   	push   %ebp
  80169f:	89 e5                	mov    %esp,%ebp
  8016a1:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8016a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8016aa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016ae:	74 30                	je     8016e0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8016b0:	eb 16                	jmp    8016c8 <strlcpy+0x2a>
			*dst++ = *src++;
  8016b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b5:	8d 50 01             	lea    0x1(%eax),%edx
  8016b8:	89 55 08             	mov    %edx,0x8(%ebp)
  8016bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016be:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016c1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8016c4:	8a 12                	mov    (%edx),%dl
  8016c6:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8016c8:	ff 4d 10             	decl   0x10(%ebp)
  8016cb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016cf:	74 09                	je     8016da <strlcpy+0x3c>
  8016d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d4:	8a 00                	mov    (%eax),%al
  8016d6:	84 c0                	test   %al,%al
  8016d8:	75 d8                	jne    8016b2 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8016da:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8016e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8016e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016e6:	29 c2                	sub    %eax,%edx
  8016e8:	89 d0                	mov    %edx,%eax
}
  8016ea:	c9                   	leave  
  8016eb:	c3                   	ret    

008016ec <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8016ef:	eb 06                	jmp    8016f7 <strcmp+0xb>
		p++, q++;
  8016f1:	ff 45 08             	incl   0x8(%ebp)
  8016f4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8016f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fa:	8a 00                	mov    (%eax),%al
  8016fc:	84 c0                	test   %al,%al
  8016fe:	74 0e                	je     80170e <strcmp+0x22>
  801700:	8b 45 08             	mov    0x8(%ebp),%eax
  801703:	8a 10                	mov    (%eax),%dl
  801705:	8b 45 0c             	mov    0xc(%ebp),%eax
  801708:	8a 00                	mov    (%eax),%al
  80170a:	38 c2                	cmp    %al,%dl
  80170c:	74 e3                	je     8016f1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80170e:	8b 45 08             	mov    0x8(%ebp),%eax
  801711:	8a 00                	mov    (%eax),%al
  801713:	0f b6 d0             	movzbl %al,%edx
  801716:	8b 45 0c             	mov    0xc(%ebp),%eax
  801719:	8a 00                	mov    (%eax),%al
  80171b:	0f b6 c0             	movzbl %al,%eax
  80171e:	29 c2                	sub    %eax,%edx
  801720:	89 d0                	mov    %edx,%eax
}
  801722:	5d                   	pop    %ebp
  801723:	c3                   	ret    

00801724 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801724:	55                   	push   %ebp
  801725:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801727:	eb 09                	jmp    801732 <strncmp+0xe>
		n--, p++, q++;
  801729:	ff 4d 10             	decl   0x10(%ebp)
  80172c:	ff 45 08             	incl   0x8(%ebp)
  80172f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801732:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801736:	74 17                	je     80174f <strncmp+0x2b>
  801738:	8b 45 08             	mov    0x8(%ebp),%eax
  80173b:	8a 00                	mov    (%eax),%al
  80173d:	84 c0                	test   %al,%al
  80173f:	74 0e                	je     80174f <strncmp+0x2b>
  801741:	8b 45 08             	mov    0x8(%ebp),%eax
  801744:	8a 10                	mov    (%eax),%dl
  801746:	8b 45 0c             	mov    0xc(%ebp),%eax
  801749:	8a 00                	mov    (%eax),%al
  80174b:	38 c2                	cmp    %al,%dl
  80174d:	74 da                	je     801729 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80174f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801753:	75 07                	jne    80175c <strncmp+0x38>
		return 0;
  801755:	b8 00 00 00 00       	mov    $0x0,%eax
  80175a:	eb 14                	jmp    801770 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80175c:	8b 45 08             	mov    0x8(%ebp),%eax
  80175f:	8a 00                	mov    (%eax),%al
  801761:	0f b6 d0             	movzbl %al,%edx
  801764:	8b 45 0c             	mov    0xc(%ebp),%eax
  801767:	8a 00                	mov    (%eax),%al
  801769:	0f b6 c0             	movzbl %al,%eax
  80176c:	29 c2                	sub    %eax,%edx
  80176e:	89 d0                	mov    %edx,%eax
}
  801770:	5d                   	pop    %ebp
  801771:	c3                   	ret    

00801772 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801772:	55                   	push   %ebp
  801773:	89 e5                	mov    %esp,%ebp
  801775:	83 ec 04             	sub    $0x4,%esp
  801778:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80177e:	eb 12                	jmp    801792 <strchr+0x20>
		if (*s == c)
  801780:	8b 45 08             	mov    0x8(%ebp),%eax
  801783:	8a 00                	mov    (%eax),%al
  801785:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801788:	75 05                	jne    80178f <strchr+0x1d>
			return (char *) s;
  80178a:	8b 45 08             	mov    0x8(%ebp),%eax
  80178d:	eb 11                	jmp    8017a0 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80178f:	ff 45 08             	incl   0x8(%ebp)
  801792:	8b 45 08             	mov    0x8(%ebp),%eax
  801795:	8a 00                	mov    (%eax),%al
  801797:	84 c0                	test   %al,%al
  801799:	75 e5                	jne    801780 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80179b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017a0:	c9                   	leave  
  8017a1:	c3                   	ret    

008017a2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
  8017a5:	83 ec 04             	sub    $0x4,%esp
  8017a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ab:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8017ae:	eb 0d                	jmp    8017bd <strfind+0x1b>
		if (*s == c)
  8017b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b3:	8a 00                	mov    (%eax),%al
  8017b5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8017b8:	74 0e                	je     8017c8 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8017ba:	ff 45 08             	incl   0x8(%ebp)
  8017bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c0:	8a 00                	mov    (%eax),%al
  8017c2:	84 c0                	test   %al,%al
  8017c4:	75 ea                	jne    8017b0 <strfind+0xe>
  8017c6:	eb 01                	jmp    8017c9 <strfind+0x27>
		if (*s == c)
			break;
  8017c8:	90                   	nop
	return (char *) s;
  8017c9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017cc:	c9                   	leave  
  8017cd:	c3                   	ret    

008017ce <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8017ce:	55                   	push   %ebp
  8017cf:	89 e5                	mov    %esp,%ebp
  8017d1:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8017d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8017da:	8b 45 10             	mov    0x10(%ebp),%eax
  8017dd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8017e0:	eb 0e                	jmp    8017f0 <memset+0x22>
		*p++ = c;
  8017e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017e5:	8d 50 01             	lea    0x1(%eax),%edx
  8017e8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8017eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ee:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8017f0:	ff 4d f8             	decl   -0x8(%ebp)
  8017f3:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8017f7:	79 e9                	jns    8017e2 <memset+0x14>
		*p++ = c;

	return v;
  8017f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017fc:	c9                   	leave  
  8017fd:	c3                   	ret    

008017fe <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
  801801:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801804:	8b 45 0c             	mov    0xc(%ebp),%eax
  801807:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80180a:	8b 45 08             	mov    0x8(%ebp),%eax
  80180d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801810:	eb 16                	jmp    801828 <memcpy+0x2a>
		*d++ = *s++;
  801812:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801815:	8d 50 01             	lea    0x1(%eax),%edx
  801818:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80181b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80181e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801821:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801824:	8a 12                	mov    (%edx),%dl
  801826:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801828:	8b 45 10             	mov    0x10(%ebp),%eax
  80182b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80182e:	89 55 10             	mov    %edx,0x10(%ebp)
  801831:	85 c0                	test   %eax,%eax
  801833:	75 dd                	jne    801812 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801835:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801838:	c9                   	leave  
  801839:	c3                   	ret    

0080183a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
  80183d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801840:	8b 45 0c             	mov    0xc(%ebp),%eax
  801843:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801846:	8b 45 08             	mov    0x8(%ebp),%eax
  801849:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80184c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80184f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801852:	73 50                	jae    8018a4 <memmove+0x6a>
  801854:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801857:	8b 45 10             	mov    0x10(%ebp),%eax
  80185a:	01 d0                	add    %edx,%eax
  80185c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80185f:	76 43                	jbe    8018a4 <memmove+0x6a>
		s += n;
  801861:	8b 45 10             	mov    0x10(%ebp),%eax
  801864:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801867:	8b 45 10             	mov    0x10(%ebp),%eax
  80186a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80186d:	eb 10                	jmp    80187f <memmove+0x45>
			*--d = *--s;
  80186f:	ff 4d f8             	decl   -0x8(%ebp)
  801872:	ff 4d fc             	decl   -0x4(%ebp)
  801875:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801878:	8a 10                	mov    (%eax),%dl
  80187a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80187d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80187f:	8b 45 10             	mov    0x10(%ebp),%eax
  801882:	8d 50 ff             	lea    -0x1(%eax),%edx
  801885:	89 55 10             	mov    %edx,0x10(%ebp)
  801888:	85 c0                	test   %eax,%eax
  80188a:	75 e3                	jne    80186f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80188c:	eb 23                	jmp    8018b1 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80188e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801891:	8d 50 01             	lea    0x1(%eax),%edx
  801894:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801897:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80189a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80189d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8018a0:	8a 12                	mov    (%edx),%dl
  8018a2:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8018a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018aa:	89 55 10             	mov    %edx,0x10(%ebp)
  8018ad:	85 c0                	test   %eax,%eax
  8018af:	75 dd                	jne    80188e <memmove+0x54>
			*d++ = *s++;

	return dst;
  8018b1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    

008018b6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
  8018b9:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8018bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8018c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c5:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8018c8:	eb 2a                	jmp    8018f4 <memcmp+0x3e>
		if (*s1 != *s2)
  8018ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018cd:	8a 10                	mov    (%eax),%dl
  8018cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018d2:	8a 00                	mov    (%eax),%al
  8018d4:	38 c2                	cmp    %al,%dl
  8018d6:	74 16                	je     8018ee <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8018d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018db:	8a 00                	mov    (%eax),%al
  8018dd:	0f b6 d0             	movzbl %al,%edx
  8018e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018e3:	8a 00                	mov    (%eax),%al
  8018e5:	0f b6 c0             	movzbl %al,%eax
  8018e8:	29 c2                	sub    %eax,%edx
  8018ea:	89 d0                	mov    %edx,%eax
  8018ec:	eb 18                	jmp    801906 <memcmp+0x50>
		s1++, s2++;
  8018ee:	ff 45 fc             	incl   -0x4(%ebp)
  8018f1:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8018f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018fa:	89 55 10             	mov    %edx,0x10(%ebp)
  8018fd:	85 c0                	test   %eax,%eax
  8018ff:	75 c9                	jne    8018ca <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801901:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801906:	c9                   	leave  
  801907:	c3                   	ret    

00801908 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801908:	55                   	push   %ebp
  801909:	89 e5                	mov    %esp,%ebp
  80190b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80190e:	8b 55 08             	mov    0x8(%ebp),%edx
  801911:	8b 45 10             	mov    0x10(%ebp),%eax
  801914:	01 d0                	add    %edx,%eax
  801916:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801919:	eb 15                	jmp    801930 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80191b:	8b 45 08             	mov    0x8(%ebp),%eax
  80191e:	8a 00                	mov    (%eax),%al
  801920:	0f b6 d0             	movzbl %al,%edx
  801923:	8b 45 0c             	mov    0xc(%ebp),%eax
  801926:	0f b6 c0             	movzbl %al,%eax
  801929:	39 c2                	cmp    %eax,%edx
  80192b:	74 0d                	je     80193a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80192d:	ff 45 08             	incl   0x8(%ebp)
  801930:	8b 45 08             	mov    0x8(%ebp),%eax
  801933:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801936:	72 e3                	jb     80191b <memfind+0x13>
  801938:	eb 01                	jmp    80193b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80193a:	90                   	nop
	return (void *) s;
  80193b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80193e:	c9                   	leave  
  80193f:	c3                   	ret    

00801940 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
  801943:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801946:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80194d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801954:	eb 03                	jmp    801959 <strtol+0x19>
		s++;
  801956:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801959:	8b 45 08             	mov    0x8(%ebp),%eax
  80195c:	8a 00                	mov    (%eax),%al
  80195e:	3c 20                	cmp    $0x20,%al
  801960:	74 f4                	je     801956 <strtol+0x16>
  801962:	8b 45 08             	mov    0x8(%ebp),%eax
  801965:	8a 00                	mov    (%eax),%al
  801967:	3c 09                	cmp    $0x9,%al
  801969:	74 eb                	je     801956 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80196b:	8b 45 08             	mov    0x8(%ebp),%eax
  80196e:	8a 00                	mov    (%eax),%al
  801970:	3c 2b                	cmp    $0x2b,%al
  801972:	75 05                	jne    801979 <strtol+0x39>
		s++;
  801974:	ff 45 08             	incl   0x8(%ebp)
  801977:	eb 13                	jmp    80198c <strtol+0x4c>
	else if (*s == '-')
  801979:	8b 45 08             	mov    0x8(%ebp),%eax
  80197c:	8a 00                	mov    (%eax),%al
  80197e:	3c 2d                	cmp    $0x2d,%al
  801980:	75 0a                	jne    80198c <strtol+0x4c>
		s++, neg = 1;
  801982:	ff 45 08             	incl   0x8(%ebp)
  801985:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80198c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801990:	74 06                	je     801998 <strtol+0x58>
  801992:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801996:	75 20                	jne    8019b8 <strtol+0x78>
  801998:	8b 45 08             	mov    0x8(%ebp),%eax
  80199b:	8a 00                	mov    (%eax),%al
  80199d:	3c 30                	cmp    $0x30,%al
  80199f:	75 17                	jne    8019b8 <strtol+0x78>
  8019a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a4:	40                   	inc    %eax
  8019a5:	8a 00                	mov    (%eax),%al
  8019a7:	3c 78                	cmp    $0x78,%al
  8019a9:	75 0d                	jne    8019b8 <strtol+0x78>
		s += 2, base = 16;
  8019ab:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8019af:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8019b6:	eb 28                	jmp    8019e0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8019b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019bc:	75 15                	jne    8019d3 <strtol+0x93>
  8019be:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c1:	8a 00                	mov    (%eax),%al
  8019c3:	3c 30                	cmp    $0x30,%al
  8019c5:	75 0c                	jne    8019d3 <strtol+0x93>
		s++, base = 8;
  8019c7:	ff 45 08             	incl   0x8(%ebp)
  8019ca:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8019d1:	eb 0d                	jmp    8019e0 <strtol+0xa0>
	else if (base == 0)
  8019d3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019d7:	75 07                	jne    8019e0 <strtol+0xa0>
		base = 10;
  8019d9:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8019e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e3:	8a 00                	mov    (%eax),%al
  8019e5:	3c 2f                	cmp    $0x2f,%al
  8019e7:	7e 19                	jle    801a02 <strtol+0xc2>
  8019e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ec:	8a 00                	mov    (%eax),%al
  8019ee:	3c 39                	cmp    $0x39,%al
  8019f0:	7f 10                	jg     801a02 <strtol+0xc2>
			dig = *s - '0';
  8019f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f5:	8a 00                	mov    (%eax),%al
  8019f7:	0f be c0             	movsbl %al,%eax
  8019fa:	83 e8 30             	sub    $0x30,%eax
  8019fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a00:	eb 42                	jmp    801a44 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801a02:	8b 45 08             	mov    0x8(%ebp),%eax
  801a05:	8a 00                	mov    (%eax),%al
  801a07:	3c 60                	cmp    $0x60,%al
  801a09:	7e 19                	jle    801a24 <strtol+0xe4>
  801a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0e:	8a 00                	mov    (%eax),%al
  801a10:	3c 7a                	cmp    $0x7a,%al
  801a12:	7f 10                	jg     801a24 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801a14:	8b 45 08             	mov    0x8(%ebp),%eax
  801a17:	8a 00                	mov    (%eax),%al
  801a19:	0f be c0             	movsbl %al,%eax
  801a1c:	83 e8 57             	sub    $0x57,%eax
  801a1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a22:	eb 20                	jmp    801a44 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801a24:	8b 45 08             	mov    0x8(%ebp),%eax
  801a27:	8a 00                	mov    (%eax),%al
  801a29:	3c 40                	cmp    $0x40,%al
  801a2b:	7e 39                	jle    801a66 <strtol+0x126>
  801a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a30:	8a 00                	mov    (%eax),%al
  801a32:	3c 5a                	cmp    $0x5a,%al
  801a34:	7f 30                	jg     801a66 <strtol+0x126>
			dig = *s - 'A' + 10;
  801a36:	8b 45 08             	mov    0x8(%ebp),%eax
  801a39:	8a 00                	mov    (%eax),%al
  801a3b:	0f be c0             	movsbl %al,%eax
  801a3e:	83 e8 37             	sub    $0x37,%eax
  801a41:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a47:	3b 45 10             	cmp    0x10(%ebp),%eax
  801a4a:	7d 19                	jge    801a65 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801a4c:	ff 45 08             	incl   0x8(%ebp)
  801a4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a52:	0f af 45 10          	imul   0x10(%ebp),%eax
  801a56:	89 c2                	mov    %eax,%edx
  801a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a5b:	01 d0                	add    %edx,%eax
  801a5d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801a60:	e9 7b ff ff ff       	jmp    8019e0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801a65:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801a66:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a6a:	74 08                	je     801a74 <strtol+0x134>
		*endptr = (char *) s;
  801a6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a6f:	8b 55 08             	mov    0x8(%ebp),%edx
  801a72:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801a74:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a78:	74 07                	je     801a81 <strtol+0x141>
  801a7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a7d:	f7 d8                	neg    %eax
  801a7f:	eb 03                	jmp    801a84 <strtol+0x144>
  801a81:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801a84:	c9                   	leave  
  801a85:	c3                   	ret    

00801a86 <ltostr>:

void
ltostr(long value, char *str)
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
  801a89:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801a8c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801a93:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801a9a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a9e:	79 13                	jns    801ab3 <ltostr+0x2d>
	{
		neg = 1;
  801aa0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801aa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aaa:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801aad:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801ab0:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab6:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801abb:	99                   	cltd   
  801abc:	f7 f9                	idiv   %ecx
  801abe:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801ac1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ac4:	8d 50 01             	lea    0x1(%eax),%edx
  801ac7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801aca:	89 c2                	mov    %eax,%edx
  801acc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801acf:	01 d0                	add    %edx,%eax
  801ad1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ad4:	83 c2 30             	add    $0x30,%edx
  801ad7:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801ad9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801adc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801ae1:	f7 e9                	imul   %ecx
  801ae3:	c1 fa 02             	sar    $0x2,%edx
  801ae6:	89 c8                	mov    %ecx,%eax
  801ae8:	c1 f8 1f             	sar    $0x1f,%eax
  801aeb:	29 c2                	sub    %eax,%edx
  801aed:	89 d0                	mov    %edx,%eax
  801aef:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801af2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801af5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801afa:	f7 e9                	imul   %ecx
  801afc:	c1 fa 02             	sar    $0x2,%edx
  801aff:	89 c8                	mov    %ecx,%eax
  801b01:	c1 f8 1f             	sar    $0x1f,%eax
  801b04:	29 c2                	sub    %eax,%edx
  801b06:	89 d0                	mov    %edx,%eax
  801b08:	c1 e0 02             	shl    $0x2,%eax
  801b0b:	01 d0                	add    %edx,%eax
  801b0d:	01 c0                	add    %eax,%eax
  801b0f:	29 c1                	sub    %eax,%ecx
  801b11:	89 ca                	mov    %ecx,%edx
  801b13:	85 d2                	test   %edx,%edx
  801b15:	75 9c                	jne    801ab3 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801b17:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801b1e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b21:	48                   	dec    %eax
  801b22:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801b25:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801b29:	74 3d                	je     801b68 <ltostr+0xe2>
		start = 1 ;
  801b2b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801b32:	eb 34                	jmp    801b68 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801b34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b37:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3a:	01 d0                	add    %edx,%eax
  801b3c:	8a 00                	mov    (%eax),%al
  801b3e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801b41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b44:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b47:	01 c2                	add    %eax,%edx
  801b49:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801b4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b4f:	01 c8                	add    %ecx,%eax
  801b51:	8a 00                	mov    (%eax),%al
  801b53:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801b55:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b58:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b5b:	01 c2                	add    %eax,%edx
  801b5d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801b60:	88 02                	mov    %al,(%edx)
		start++ ;
  801b62:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801b65:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b6b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b6e:	7c c4                	jl     801b34 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801b70:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801b73:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b76:	01 d0                	add    %edx,%eax
  801b78:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801b7b:	90                   	nop
  801b7c:	c9                   	leave  
  801b7d:	c3                   	ret    

00801b7e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
  801b81:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801b84:	ff 75 08             	pushl  0x8(%ebp)
  801b87:	e8 54 fa ff ff       	call   8015e0 <strlen>
  801b8c:	83 c4 04             	add    $0x4,%esp
  801b8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801b92:	ff 75 0c             	pushl  0xc(%ebp)
  801b95:	e8 46 fa ff ff       	call   8015e0 <strlen>
  801b9a:	83 c4 04             	add    $0x4,%esp
  801b9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801ba0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801ba7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801bae:	eb 17                	jmp    801bc7 <strcconcat+0x49>
		final[s] = str1[s] ;
  801bb0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bb3:	8b 45 10             	mov    0x10(%ebp),%eax
  801bb6:	01 c2                	add    %eax,%edx
  801bb8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbe:	01 c8                	add    %ecx,%eax
  801bc0:	8a 00                	mov    (%eax),%al
  801bc2:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801bc4:	ff 45 fc             	incl   -0x4(%ebp)
  801bc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bca:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801bcd:	7c e1                	jl     801bb0 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801bcf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801bd6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801bdd:	eb 1f                	jmp    801bfe <strcconcat+0x80>
		final[s++] = str2[i] ;
  801bdf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801be2:	8d 50 01             	lea    0x1(%eax),%edx
  801be5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801be8:	89 c2                	mov    %eax,%edx
  801bea:	8b 45 10             	mov    0x10(%ebp),%eax
  801bed:	01 c2                	add    %eax,%edx
  801bef:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801bf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf5:	01 c8                	add    %ecx,%eax
  801bf7:	8a 00                	mov    (%eax),%al
  801bf9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801bfb:	ff 45 f8             	incl   -0x8(%ebp)
  801bfe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c01:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801c04:	7c d9                	jl     801bdf <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801c06:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c09:	8b 45 10             	mov    0x10(%ebp),%eax
  801c0c:	01 d0                	add    %edx,%eax
  801c0e:	c6 00 00             	movb   $0x0,(%eax)
}
  801c11:	90                   	nop
  801c12:	c9                   	leave  
  801c13:	c3                   	ret    

00801c14 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801c17:	8b 45 14             	mov    0x14(%ebp),%eax
  801c1a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801c20:	8b 45 14             	mov    0x14(%ebp),%eax
  801c23:	8b 00                	mov    (%eax),%eax
  801c25:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c2c:	8b 45 10             	mov    0x10(%ebp),%eax
  801c2f:	01 d0                	add    %edx,%eax
  801c31:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c37:	eb 0c                	jmp    801c45 <strsplit+0x31>
			*string++ = 0;
  801c39:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3c:	8d 50 01             	lea    0x1(%eax),%edx
  801c3f:	89 55 08             	mov    %edx,0x8(%ebp)
  801c42:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c45:	8b 45 08             	mov    0x8(%ebp),%eax
  801c48:	8a 00                	mov    (%eax),%al
  801c4a:	84 c0                	test   %al,%al
  801c4c:	74 18                	je     801c66 <strsplit+0x52>
  801c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c51:	8a 00                	mov    (%eax),%al
  801c53:	0f be c0             	movsbl %al,%eax
  801c56:	50                   	push   %eax
  801c57:	ff 75 0c             	pushl  0xc(%ebp)
  801c5a:	e8 13 fb ff ff       	call   801772 <strchr>
  801c5f:	83 c4 08             	add    $0x8,%esp
  801c62:	85 c0                	test   %eax,%eax
  801c64:	75 d3                	jne    801c39 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801c66:	8b 45 08             	mov    0x8(%ebp),%eax
  801c69:	8a 00                	mov    (%eax),%al
  801c6b:	84 c0                	test   %al,%al
  801c6d:	74 5a                	je     801cc9 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801c6f:	8b 45 14             	mov    0x14(%ebp),%eax
  801c72:	8b 00                	mov    (%eax),%eax
  801c74:	83 f8 0f             	cmp    $0xf,%eax
  801c77:	75 07                	jne    801c80 <strsplit+0x6c>
		{
			return 0;
  801c79:	b8 00 00 00 00       	mov    $0x0,%eax
  801c7e:	eb 66                	jmp    801ce6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801c80:	8b 45 14             	mov    0x14(%ebp),%eax
  801c83:	8b 00                	mov    (%eax),%eax
  801c85:	8d 48 01             	lea    0x1(%eax),%ecx
  801c88:	8b 55 14             	mov    0x14(%ebp),%edx
  801c8b:	89 0a                	mov    %ecx,(%edx)
  801c8d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c94:	8b 45 10             	mov    0x10(%ebp),%eax
  801c97:	01 c2                	add    %eax,%edx
  801c99:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c9e:	eb 03                	jmp    801ca3 <strsplit+0x8f>
			string++;
  801ca0:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca6:	8a 00                	mov    (%eax),%al
  801ca8:	84 c0                	test   %al,%al
  801caa:	74 8b                	je     801c37 <strsplit+0x23>
  801cac:	8b 45 08             	mov    0x8(%ebp),%eax
  801caf:	8a 00                	mov    (%eax),%al
  801cb1:	0f be c0             	movsbl %al,%eax
  801cb4:	50                   	push   %eax
  801cb5:	ff 75 0c             	pushl  0xc(%ebp)
  801cb8:	e8 b5 fa ff ff       	call   801772 <strchr>
  801cbd:	83 c4 08             	add    $0x8,%esp
  801cc0:	85 c0                	test   %eax,%eax
  801cc2:	74 dc                	je     801ca0 <strsplit+0x8c>
			string++;
	}
  801cc4:	e9 6e ff ff ff       	jmp    801c37 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801cc9:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801cca:	8b 45 14             	mov    0x14(%ebp),%eax
  801ccd:	8b 00                	mov    (%eax),%eax
  801ccf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801cd6:	8b 45 10             	mov    0x10(%ebp),%eax
  801cd9:	01 d0                	add    %edx,%eax
  801cdb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801ce1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ce6:	c9                   	leave  
  801ce7:	c3                   	ret    

00801ce8 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
  801ceb:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801cee:	a1 04 50 80 00       	mov    0x805004,%eax
  801cf3:	85 c0                	test   %eax,%eax
  801cf5:	74 1f                	je     801d16 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801cf7:	e8 1d 00 00 00       	call   801d19 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801cfc:	83 ec 0c             	sub    $0xc,%esp
  801cff:	68 d0 42 80 00       	push   $0x8042d0
  801d04:	e8 55 f2 ff ff       	call   800f5e <cprintf>
  801d09:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801d0c:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801d13:	00 00 00 
	}
}
  801d16:	90                   	nop
  801d17:	c9                   	leave  
  801d18:	c3                   	ret    

00801d19 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801d19:	55                   	push   %ebp
  801d1a:	89 e5                	mov    %esp,%ebp
  801d1c:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  801d1f:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801d26:	00 00 00 
  801d29:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801d30:	00 00 00 
  801d33:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801d3a:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  801d3d:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801d44:	00 00 00 
  801d47:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801d4e:	00 00 00 
  801d51:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801d58:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  801d5b:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d65:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d6a:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d6f:	a3 50 50 80 00       	mov    %eax,0x805050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801d74:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801d7b:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  801d7e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d88:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  801d8d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d93:	ba 00 00 00 00       	mov    $0x0,%edx
  801d98:	f7 75 f0             	divl   -0x10(%ebp)
  801d9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d9e:	29 d0                	sub    %edx,%eax
  801da0:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  801da3:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801daa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801db2:	2d 00 10 00 00       	sub    $0x1000,%eax
  801db7:	83 ec 04             	sub    $0x4,%esp
  801dba:	6a 06                	push   $0x6
  801dbc:	ff 75 e8             	pushl  -0x18(%ebp)
  801dbf:	50                   	push   %eax
  801dc0:	e8 d4 05 00 00       	call   802399 <sys_allocate_chunk>
  801dc5:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801dc8:	a1 20 51 80 00       	mov    0x805120,%eax
  801dcd:	83 ec 0c             	sub    $0xc,%esp
  801dd0:	50                   	push   %eax
  801dd1:	e8 49 0c 00 00       	call   802a1f <initialize_MemBlocksList>
  801dd6:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  801dd9:	a1 48 51 80 00       	mov    0x805148,%eax
  801dde:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  801de1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801de5:	75 14                	jne    801dfb <initialize_dyn_block_system+0xe2>
  801de7:	83 ec 04             	sub    $0x4,%esp
  801dea:	68 f5 42 80 00       	push   $0x8042f5
  801def:	6a 39                	push   $0x39
  801df1:	68 13 43 80 00       	push   $0x804313
  801df6:	e8 af ee ff ff       	call   800caa <_panic>
  801dfb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dfe:	8b 00                	mov    (%eax),%eax
  801e00:	85 c0                	test   %eax,%eax
  801e02:	74 10                	je     801e14 <initialize_dyn_block_system+0xfb>
  801e04:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e07:	8b 00                	mov    (%eax),%eax
  801e09:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e0c:	8b 52 04             	mov    0x4(%edx),%edx
  801e0f:	89 50 04             	mov    %edx,0x4(%eax)
  801e12:	eb 0b                	jmp    801e1f <initialize_dyn_block_system+0x106>
  801e14:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e17:	8b 40 04             	mov    0x4(%eax),%eax
  801e1a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801e1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e22:	8b 40 04             	mov    0x4(%eax),%eax
  801e25:	85 c0                	test   %eax,%eax
  801e27:	74 0f                	je     801e38 <initialize_dyn_block_system+0x11f>
  801e29:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e2c:	8b 40 04             	mov    0x4(%eax),%eax
  801e2f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e32:	8b 12                	mov    (%edx),%edx
  801e34:	89 10                	mov    %edx,(%eax)
  801e36:	eb 0a                	jmp    801e42 <initialize_dyn_block_system+0x129>
  801e38:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e3b:	8b 00                	mov    (%eax),%eax
  801e3d:	a3 48 51 80 00       	mov    %eax,0x805148
  801e42:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e45:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e4e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e55:	a1 54 51 80 00       	mov    0x805154,%eax
  801e5a:	48                   	dec    %eax
  801e5b:	a3 54 51 80 00       	mov    %eax,0x805154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  801e60:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e63:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  801e6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e6d:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  801e74:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e78:	75 14                	jne    801e8e <initialize_dyn_block_system+0x175>
  801e7a:	83 ec 04             	sub    $0x4,%esp
  801e7d:	68 20 43 80 00       	push   $0x804320
  801e82:	6a 3f                	push   $0x3f
  801e84:	68 13 43 80 00       	push   $0x804313
  801e89:	e8 1c ee ff ff       	call   800caa <_panic>
  801e8e:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801e94:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e97:	89 10                	mov    %edx,(%eax)
  801e99:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e9c:	8b 00                	mov    (%eax),%eax
  801e9e:	85 c0                	test   %eax,%eax
  801ea0:	74 0d                	je     801eaf <initialize_dyn_block_system+0x196>
  801ea2:	a1 38 51 80 00       	mov    0x805138,%eax
  801ea7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801eaa:	89 50 04             	mov    %edx,0x4(%eax)
  801ead:	eb 08                	jmp    801eb7 <initialize_dyn_block_system+0x19e>
  801eaf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801eb2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801eb7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801eba:	a3 38 51 80 00       	mov    %eax,0x805138
  801ebf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ec2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ec9:	a1 44 51 80 00       	mov    0x805144,%eax
  801ece:	40                   	inc    %eax
  801ecf:	a3 44 51 80 00       	mov    %eax,0x805144

}
  801ed4:	90                   	nop
  801ed5:	c9                   	leave  
  801ed6:	c3                   	ret    

00801ed7 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801ed7:	55                   	push   %ebp
  801ed8:	89 e5                	mov    %esp,%ebp
  801eda:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801edd:	e8 06 fe ff ff       	call   801ce8 <InitializeUHeap>
	if (size == 0) return NULL ;
  801ee2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ee6:	75 07                	jne    801eef <malloc+0x18>
  801ee8:	b8 00 00 00 00       	mov    $0x0,%eax
  801eed:	eb 7d                	jmp    801f6c <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  801eef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801ef6:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801efd:	8b 55 08             	mov    0x8(%ebp),%edx
  801f00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f03:	01 d0                	add    %edx,%eax
  801f05:	48                   	dec    %eax
  801f06:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801f09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f0c:	ba 00 00 00 00       	mov    $0x0,%edx
  801f11:	f7 75 f0             	divl   -0x10(%ebp)
  801f14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f17:	29 d0                	sub    %edx,%eax
  801f19:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  801f1c:	e8 46 08 00 00       	call   802767 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f21:	83 f8 01             	cmp    $0x1,%eax
  801f24:	75 07                	jne    801f2d <malloc+0x56>
  801f26:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  801f2d:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  801f31:	75 34                	jne    801f67 <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  801f33:	83 ec 0c             	sub    $0xc,%esp
  801f36:	ff 75 e8             	pushl  -0x18(%ebp)
  801f39:	e8 73 0e 00 00       	call   802db1 <alloc_block_FF>
  801f3e:	83 c4 10             	add    $0x10,%esp
  801f41:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  801f44:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801f48:	74 16                	je     801f60 <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  801f4a:	83 ec 0c             	sub    $0xc,%esp
  801f4d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801f50:	e8 ff 0b 00 00       	call   802b54 <insert_sorted_allocList>
  801f55:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  801f58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f5b:	8b 40 08             	mov    0x8(%eax),%eax
  801f5e:	eb 0c                	jmp    801f6c <malloc+0x95>
	             }
	             else
	             	return NULL;
  801f60:	b8 00 00 00 00       	mov    $0x0,%eax
  801f65:	eb 05                	jmp    801f6c <malloc+0x95>
	      	  }
	          else
	               return NULL;
  801f67:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  801f6c:	c9                   	leave  
  801f6d:	c3                   	ret    

00801f6e <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801f6e:	55                   	push   %ebp
  801f6f:	89 e5                	mov    %esp,%ebp
  801f71:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  801f74:	8b 45 08             	mov    0x8(%ebp),%eax
  801f77:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  801f7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f83:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801f88:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  801f8b:	83 ec 08             	sub    $0x8,%esp
  801f8e:	ff 75 f4             	pushl  -0xc(%ebp)
  801f91:	68 40 50 80 00       	push   $0x805040
  801f96:	e8 61 0b 00 00       	call   802afc <find_block>
  801f9b:	83 c4 10             	add    $0x10,%esp
  801f9e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  801fa1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801fa5:	0f 84 a5 00 00 00    	je     802050 <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  801fab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fae:	8b 40 0c             	mov    0xc(%eax),%eax
  801fb1:	83 ec 08             	sub    $0x8,%esp
  801fb4:	50                   	push   %eax
  801fb5:	ff 75 f4             	pushl  -0xc(%ebp)
  801fb8:	e8 a4 03 00 00       	call   802361 <sys_free_user_mem>
  801fbd:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  801fc0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801fc4:	75 17                	jne    801fdd <free+0x6f>
  801fc6:	83 ec 04             	sub    $0x4,%esp
  801fc9:	68 f5 42 80 00       	push   $0x8042f5
  801fce:	68 87 00 00 00       	push   $0x87
  801fd3:	68 13 43 80 00       	push   $0x804313
  801fd8:	e8 cd ec ff ff       	call   800caa <_panic>
  801fdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fe0:	8b 00                	mov    (%eax),%eax
  801fe2:	85 c0                	test   %eax,%eax
  801fe4:	74 10                	je     801ff6 <free+0x88>
  801fe6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fe9:	8b 00                	mov    (%eax),%eax
  801feb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801fee:	8b 52 04             	mov    0x4(%edx),%edx
  801ff1:	89 50 04             	mov    %edx,0x4(%eax)
  801ff4:	eb 0b                	jmp    802001 <free+0x93>
  801ff6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ff9:	8b 40 04             	mov    0x4(%eax),%eax
  801ffc:	a3 44 50 80 00       	mov    %eax,0x805044
  802001:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802004:	8b 40 04             	mov    0x4(%eax),%eax
  802007:	85 c0                	test   %eax,%eax
  802009:	74 0f                	je     80201a <free+0xac>
  80200b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80200e:	8b 40 04             	mov    0x4(%eax),%eax
  802011:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802014:	8b 12                	mov    (%edx),%edx
  802016:	89 10                	mov    %edx,(%eax)
  802018:	eb 0a                	jmp    802024 <free+0xb6>
  80201a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80201d:	8b 00                	mov    (%eax),%eax
  80201f:	a3 40 50 80 00       	mov    %eax,0x805040
  802024:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802027:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80202d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802030:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802037:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80203c:	48                   	dec    %eax
  80203d:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(theBlock);
  802042:	83 ec 0c             	sub    $0xc,%esp
  802045:	ff 75 ec             	pushl  -0x14(%ebp)
  802048:	e8 37 12 00 00       	call   803284 <insert_sorted_with_merge_freeList>
  80204d:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  802050:	90                   	nop
  802051:	c9                   	leave  
  802052:	c3                   	ret    

00802053 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802053:	55                   	push   %ebp
  802054:	89 e5                	mov    %esp,%ebp
  802056:	83 ec 38             	sub    $0x38,%esp
  802059:	8b 45 10             	mov    0x10(%ebp),%eax
  80205c:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80205f:	e8 84 fc ff ff       	call   801ce8 <InitializeUHeap>
	if (size == 0) return NULL ;
  802064:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802068:	75 07                	jne    802071 <smalloc+0x1e>
  80206a:	b8 00 00 00 00       	mov    $0x0,%eax
  80206f:	eb 7e                	jmp    8020ef <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  802071:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  802078:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80207f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802082:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802085:	01 d0                	add    %edx,%eax
  802087:	48                   	dec    %eax
  802088:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80208b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80208e:	ba 00 00 00 00       	mov    $0x0,%edx
  802093:	f7 75 f0             	divl   -0x10(%ebp)
  802096:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802099:	29 d0                	sub    %edx,%eax
  80209b:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  80209e:	e8 c4 06 00 00       	call   802767 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8020a3:	83 f8 01             	cmp    $0x1,%eax
  8020a6:	75 42                	jne    8020ea <smalloc+0x97>

		  va = malloc(newsize) ;
  8020a8:	83 ec 0c             	sub    $0xc,%esp
  8020ab:	ff 75 e8             	pushl  -0x18(%ebp)
  8020ae:	e8 24 fe ff ff       	call   801ed7 <malloc>
  8020b3:	83 c4 10             	add    $0x10,%esp
  8020b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  8020b9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8020bd:	74 24                	je     8020e3 <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  8020bf:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8020c3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8020c6:	50                   	push   %eax
  8020c7:	ff 75 e8             	pushl  -0x18(%ebp)
  8020ca:	ff 75 08             	pushl  0x8(%ebp)
  8020cd:	e8 1a 04 00 00       	call   8024ec <sys_createSharedObject>
  8020d2:	83 c4 10             	add    $0x10,%esp
  8020d5:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  8020d8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8020dc:	78 0c                	js     8020ea <smalloc+0x97>
					  return va ;
  8020de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020e1:	eb 0c                	jmp    8020ef <smalloc+0x9c>
				 }
				 else
					return NULL;
  8020e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e8:	eb 05                	jmp    8020ef <smalloc+0x9c>
	  }
		  return NULL ;
  8020ea:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8020ef:	c9                   	leave  
  8020f0:	c3                   	ret    

008020f1 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8020f1:	55                   	push   %ebp
  8020f2:	89 e5                	mov    %esp,%ebp
  8020f4:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8020f7:	e8 ec fb ff ff       	call   801ce8 <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  8020fc:	83 ec 08             	sub    $0x8,%esp
  8020ff:	ff 75 0c             	pushl  0xc(%ebp)
  802102:	ff 75 08             	pushl  0x8(%ebp)
  802105:	e8 0c 04 00 00       	call   802516 <sys_getSizeOfSharedObject>
  80210a:	83 c4 10             	add    $0x10,%esp
  80210d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  802110:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  802114:	75 07                	jne    80211d <sget+0x2c>
  802116:	b8 00 00 00 00       	mov    $0x0,%eax
  80211b:	eb 75                	jmp    802192 <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  80211d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802124:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802127:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80212a:	01 d0                	add    %edx,%eax
  80212c:	48                   	dec    %eax
  80212d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802130:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802133:	ba 00 00 00 00       	mov    $0x0,%edx
  802138:	f7 75 f0             	divl   -0x10(%ebp)
  80213b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80213e:	29 d0                	sub    %edx,%eax
  802140:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  802143:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  80214a:	e8 18 06 00 00       	call   802767 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80214f:	83 f8 01             	cmp    $0x1,%eax
  802152:	75 39                	jne    80218d <sget+0x9c>

		  va = malloc(newsize) ;
  802154:	83 ec 0c             	sub    $0xc,%esp
  802157:	ff 75 e8             	pushl  -0x18(%ebp)
  80215a:	e8 78 fd ff ff       	call   801ed7 <malloc>
  80215f:	83 c4 10             	add    $0x10,%esp
  802162:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  802165:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802169:	74 22                	je     80218d <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  80216b:	83 ec 04             	sub    $0x4,%esp
  80216e:	ff 75 e0             	pushl  -0x20(%ebp)
  802171:	ff 75 0c             	pushl  0xc(%ebp)
  802174:	ff 75 08             	pushl  0x8(%ebp)
  802177:	e8 b7 03 00 00       	call   802533 <sys_getSharedObject>
  80217c:	83 c4 10             	add    $0x10,%esp
  80217f:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  802182:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802186:	78 05                	js     80218d <sget+0x9c>
					  return va;
  802188:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80218b:	eb 05                	jmp    802192 <sget+0xa1>
				  }
			  }
     }
         return NULL;
  80218d:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  802192:	c9                   	leave  
  802193:	c3                   	ret    

00802194 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802194:	55                   	push   %ebp
  802195:	89 e5                	mov    %esp,%ebp
  802197:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80219a:	e8 49 fb ff ff       	call   801ce8 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80219f:	83 ec 04             	sub    $0x4,%esp
  8021a2:	68 44 43 80 00       	push   $0x804344
  8021a7:	68 1e 01 00 00       	push   $0x11e
  8021ac:	68 13 43 80 00       	push   $0x804313
  8021b1:	e8 f4 ea ff ff       	call   800caa <_panic>

008021b6 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8021b6:	55                   	push   %ebp
  8021b7:	89 e5                	mov    %esp,%ebp
  8021b9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8021bc:	83 ec 04             	sub    $0x4,%esp
  8021bf:	68 6c 43 80 00       	push   $0x80436c
  8021c4:	68 32 01 00 00       	push   $0x132
  8021c9:	68 13 43 80 00       	push   $0x804313
  8021ce:	e8 d7 ea ff ff       	call   800caa <_panic>

008021d3 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8021d3:	55                   	push   %ebp
  8021d4:	89 e5                	mov    %esp,%ebp
  8021d6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8021d9:	83 ec 04             	sub    $0x4,%esp
  8021dc:	68 90 43 80 00       	push   $0x804390
  8021e1:	68 3d 01 00 00       	push   $0x13d
  8021e6:	68 13 43 80 00       	push   $0x804313
  8021eb:	e8 ba ea ff ff       	call   800caa <_panic>

008021f0 <shrink>:

}
void shrink(uint32 newSize)
{
  8021f0:	55                   	push   %ebp
  8021f1:	89 e5                	mov    %esp,%ebp
  8021f3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8021f6:	83 ec 04             	sub    $0x4,%esp
  8021f9:	68 90 43 80 00       	push   $0x804390
  8021fe:	68 42 01 00 00       	push   $0x142
  802203:	68 13 43 80 00       	push   $0x804313
  802208:	e8 9d ea ff ff       	call   800caa <_panic>

0080220d <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80220d:	55                   	push   %ebp
  80220e:	89 e5                	mov    %esp,%ebp
  802210:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802213:	83 ec 04             	sub    $0x4,%esp
  802216:	68 90 43 80 00       	push   $0x804390
  80221b:	68 47 01 00 00       	push   $0x147
  802220:	68 13 43 80 00       	push   $0x804313
  802225:	e8 80 ea ff ff       	call   800caa <_panic>

0080222a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80222a:	55                   	push   %ebp
  80222b:	89 e5                	mov    %esp,%ebp
  80222d:	57                   	push   %edi
  80222e:	56                   	push   %esi
  80222f:	53                   	push   %ebx
  802230:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802233:	8b 45 08             	mov    0x8(%ebp),%eax
  802236:	8b 55 0c             	mov    0xc(%ebp),%edx
  802239:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80223c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80223f:	8b 7d 18             	mov    0x18(%ebp),%edi
  802242:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802245:	cd 30                	int    $0x30
  802247:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80224a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80224d:	83 c4 10             	add    $0x10,%esp
  802250:	5b                   	pop    %ebx
  802251:	5e                   	pop    %esi
  802252:	5f                   	pop    %edi
  802253:	5d                   	pop    %ebp
  802254:	c3                   	ret    

00802255 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802255:	55                   	push   %ebp
  802256:	89 e5                	mov    %esp,%ebp
  802258:	83 ec 04             	sub    $0x4,%esp
  80225b:	8b 45 10             	mov    0x10(%ebp),%eax
  80225e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802261:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802265:	8b 45 08             	mov    0x8(%ebp),%eax
  802268:	6a 00                	push   $0x0
  80226a:	6a 00                	push   $0x0
  80226c:	52                   	push   %edx
  80226d:	ff 75 0c             	pushl  0xc(%ebp)
  802270:	50                   	push   %eax
  802271:	6a 00                	push   $0x0
  802273:	e8 b2 ff ff ff       	call   80222a <syscall>
  802278:	83 c4 18             	add    $0x18,%esp
}
  80227b:	90                   	nop
  80227c:	c9                   	leave  
  80227d:	c3                   	ret    

0080227e <sys_cgetc>:

int
sys_cgetc(void)
{
  80227e:	55                   	push   %ebp
  80227f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802281:	6a 00                	push   $0x0
  802283:	6a 00                	push   $0x0
  802285:	6a 00                	push   $0x0
  802287:	6a 00                	push   $0x0
  802289:	6a 00                	push   $0x0
  80228b:	6a 01                	push   $0x1
  80228d:	e8 98 ff ff ff       	call   80222a <syscall>
  802292:	83 c4 18             	add    $0x18,%esp
}
  802295:	c9                   	leave  
  802296:	c3                   	ret    

00802297 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802297:	55                   	push   %ebp
  802298:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80229a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80229d:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a0:	6a 00                	push   $0x0
  8022a2:	6a 00                	push   $0x0
  8022a4:	6a 00                	push   $0x0
  8022a6:	52                   	push   %edx
  8022a7:	50                   	push   %eax
  8022a8:	6a 05                	push   $0x5
  8022aa:	e8 7b ff ff ff       	call   80222a <syscall>
  8022af:	83 c4 18             	add    $0x18,%esp
}
  8022b2:	c9                   	leave  
  8022b3:	c3                   	ret    

008022b4 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8022b4:	55                   	push   %ebp
  8022b5:	89 e5                	mov    %esp,%ebp
  8022b7:	56                   	push   %esi
  8022b8:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8022b9:	8b 75 18             	mov    0x18(%ebp),%esi
  8022bc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022bf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c8:	56                   	push   %esi
  8022c9:	53                   	push   %ebx
  8022ca:	51                   	push   %ecx
  8022cb:	52                   	push   %edx
  8022cc:	50                   	push   %eax
  8022cd:	6a 06                	push   $0x6
  8022cf:	e8 56 ff ff ff       	call   80222a <syscall>
  8022d4:	83 c4 18             	add    $0x18,%esp
}
  8022d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022da:	5b                   	pop    %ebx
  8022db:	5e                   	pop    %esi
  8022dc:	5d                   	pop    %ebp
  8022dd:	c3                   	ret    

008022de <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8022de:	55                   	push   %ebp
  8022df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8022e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e7:	6a 00                	push   $0x0
  8022e9:	6a 00                	push   $0x0
  8022eb:	6a 00                	push   $0x0
  8022ed:	52                   	push   %edx
  8022ee:	50                   	push   %eax
  8022ef:	6a 07                	push   $0x7
  8022f1:	e8 34 ff ff ff       	call   80222a <syscall>
  8022f6:	83 c4 18             	add    $0x18,%esp
}
  8022f9:	c9                   	leave  
  8022fa:	c3                   	ret    

008022fb <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8022fb:	55                   	push   %ebp
  8022fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8022fe:	6a 00                	push   $0x0
  802300:	6a 00                	push   $0x0
  802302:	6a 00                	push   $0x0
  802304:	ff 75 0c             	pushl  0xc(%ebp)
  802307:	ff 75 08             	pushl  0x8(%ebp)
  80230a:	6a 08                	push   $0x8
  80230c:	e8 19 ff ff ff       	call   80222a <syscall>
  802311:	83 c4 18             	add    $0x18,%esp
}
  802314:	c9                   	leave  
  802315:	c3                   	ret    

00802316 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802316:	55                   	push   %ebp
  802317:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802319:	6a 00                	push   $0x0
  80231b:	6a 00                	push   $0x0
  80231d:	6a 00                	push   $0x0
  80231f:	6a 00                	push   $0x0
  802321:	6a 00                	push   $0x0
  802323:	6a 09                	push   $0x9
  802325:	e8 00 ff ff ff       	call   80222a <syscall>
  80232a:	83 c4 18             	add    $0x18,%esp
}
  80232d:	c9                   	leave  
  80232e:	c3                   	ret    

0080232f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80232f:	55                   	push   %ebp
  802330:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802332:	6a 00                	push   $0x0
  802334:	6a 00                	push   $0x0
  802336:	6a 00                	push   $0x0
  802338:	6a 00                	push   $0x0
  80233a:	6a 00                	push   $0x0
  80233c:	6a 0a                	push   $0xa
  80233e:	e8 e7 fe ff ff       	call   80222a <syscall>
  802343:	83 c4 18             	add    $0x18,%esp
}
  802346:	c9                   	leave  
  802347:	c3                   	ret    

00802348 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802348:	55                   	push   %ebp
  802349:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80234b:	6a 00                	push   $0x0
  80234d:	6a 00                	push   $0x0
  80234f:	6a 00                	push   $0x0
  802351:	6a 00                	push   $0x0
  802353:	6a 00                	push   $0x0
  802355:	6a 0b                	push   $0xb
  802357:	e8 ce fe ff ff       	call   80222a <syscall>
  80235c:	83 c4 18             	add    $0x18,%esp
}
  80235f:	c9                   	leave  
  802360:	c3                   	ret    

00802361 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802361:	55                   	push   %ebp
  802362:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802364:	6a 00                	push   $0x0
  802366:	6a 00                	push   $0x0
  802368:	6a 00                	push   $0x0
  80236a:	ff 75 0c             	pushl  0xc(%ebp)
  80236d:	ff 75 08             	pushl  0x8(%ebp)
  802370:	6a 0f                	push   $0xf
  802372:	e8 b3 fe ff ff       	call   80222a <syscall>
  802377:	83 c4 18             	add    $0x18,%esp
	return;
  80237a:	90                   	nop
}
  80237b:	c9                   	leave  
  80237c:	c3                   	ret    

0080237d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80237d:	55                   	push   %ebp
  80237e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802380:	6a 00                	push   $0x0
  802382:	6a 00                	push   $0x0
  802384:	6a 00                	push   $0x0
  802386:	ff 75 0c             	pushl  0xc(%ebp)
  802389:	ff 75 08             	pushl  0x8(%ebp)
  80238c:	6a 10                	push   $0x10
  80238e:	e8 97 fe ff ff       	call   80222a <syscall>
  802393:	83 c4 18             	add    $0x18,%esp
	return ;
  802396:	90                   	nop
}
  802397:	c9                   	leave  
  802398:	c3                   	ret    

00802399 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802399:	55                   	push   %ebp
  80239a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80239c:	6a 00                	push   $0x0
  80239e:	6a 00                	push   $0x0
  8023a0:	ff 75 10             	pushl  0x10(%ebp)
  8023a3:	ff 75 0c             	pushl  0xc(%ebp)
  8023a6:	ff 75 08             	pushl  0x8(%ebp)
  8023a9:	6a 11                	push   $0x11
  8023ab:	e8 7a fe ff ff       	call   80222a <syscall>
  8023b0:	83 c4 18             	add    $0x18,%esp
	return ;
  8023b3:	90                   	nop
}
  8023b4:	c9                   	leave  
  8023b5:	c3                   	ret    

008023b6 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8023b6:	55                   	push   %ebp
  8023b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8023b9:	6a 00                	push   $0x0
  8023bb:	6a 00                	push   $0x0
  8023bd:	6a 00                	push   $0x0
  8023bf:	6a 00                	push   $0x0
  8023c1:	6a 00                	push   $0x0
  8023c3:	6a 0c                	push   $0xc
  8023c5:	e8 60 fe ff ff       	call   80222a <syscall>
  8023ca:	83 c4 18             	add    $0x18,%esp
}
  8023cd:	c9                   	leave  
  8023ce:	c3                   	ret    

008023cf <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8023cf:	55                   	push   %ebp
  8023d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8023d2:	6a 00                	push   $0x0
  8023d4:	6a 00                	push   $0x0
  8023d6:	6a 00                	push   $0x0
  8023d8:	6a 00                	push   $0x0
  8023da:	ff 75 08             	pushl  0x8(%ebp)
  8023dd:	6a 0d                	push   $0xd
  8023df:	e8 46 fe ff ff       	call   80222a <syscall>
  8023e4:	83 c4 18             	add    $0x18,%esp
}
  8023e7:	c9                   	leave  
  8023e8:	c3                   	ret    

008023e9 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8023e9:	55                   	push   %ebp
  8023ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8023ec:	6a 00                	push   $0x0
  8023ee:	6a 00                	push   $0x0
  8023f0:	6a 00                	push   $0x0
  8023f2:	6a 00                	push   $0x0
  8023f4:	6a 00                	push   $0x0
  8023f6:	6a 0e                	push   $0xe
  8023f8:	e8 2d fe ff ff       	call   80222a <syscall>
  8023fd:	83 c4 18             	add    $0x18,%esp
}
  802400:	90                   	nop
  802401:	c9                   	leave  
  802402:	c3                   	ret    

00802403 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802403:	55                   	push   %ebp
  802404:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802406:	6a 00                	push   $0x0
  802408:	6a 00                	push   $0x0
  80240a:	6a 00                	push   $0x0
  80240c:	6a 00                	push   $0x0
  80240e:	6a 00                	push   $0x0
  802410:	6a 13                	push   $0x13
  802412:	e8 13 fe ff ff       	call   80222a <syscall>
  802417:	83 c4 18             	add    $0x18,%esp
}
  80241a:	90                   	nop
  80241b:	c9                   	leave  
  80241c:	c3                   	ret    

0080241d <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80241d:	55                   	push   %ebp
  80241e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802420:	6a 00                	push   $0x0
  802422:	6a 00                	push   $0x0
  802424:	6a 00                	push   $0x0
  802426:	6a 00                	push   $0x0
  802428:	6a 00                	push   $0x0
  80242a:	6a 14                	push   $0x14
  80242c:	e8 f9 fd ff ff       	call   80222a <syscall>
  802431:	83 c4 18             	add    $0x18,%esp
}
  802434:	90                   	nop
  802435:	c9                   	leave  
  802436:	c3                   	ret    

00802437 <sys_cputc>:


void
sys_cputc(const char c)
{
  802437:	55                   	push   %ebp
  802438:	89 e5                	mov    %esp,%ebp
  80243a:	83 ec 04             	sub    $0x4,%esp
  80243d:	8b 45 08             	mov    0x8(%ebp),%eax
  802440:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802443:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802447:	6a 00                	push   $0x0
  802449:	6a 00                	push   $0x0
  80244b:	6a 00                	push   $0x0
  80244d:	6a 00                	push   $0x0
  80244f:	50                   	push   %eax
  802450:	6a 15                	push   $0x15
  802452:	e8 d3 fd ff ff       	call   80222a <syscall>
  802457:	83 c4 18             	add    $0x18,%esp
}
  80245a:	90                   	nop
  80245b:	c9                   	leave  
  80245c:	c3                   	ret    

0080245d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80245d:	55                   	push   %ebp
  80245e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802460:	6a 00                	push   $0x0
  802462:	6a 00                	push   $0x0
  802464:	6a 00                	push   $0x0
  802466:	6a 00                	push   $0x0
  802468:	6a 00                	push   $0x0
  80246a:	6a 16                	push   $0x16
  80246c:	e8 b9 fd ff ff       	call   80222a <syscall>
  802471:	83 c4 18             	add    $0x18,%esp
}
  802474:	90                   	nop
  802475:	c9                   	leave  
  802476:	c3                   	ret    

00802477 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802477:	55                   	push   %ebp
  802478:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80247a:	8b 45 08             	mov    0x8(%ebp),%eax
  80247d:	6a 00                	push   $0x0
  80247f:	6a 00                	push   $0x0
  802481:	6a 00                	push   $0x0
  802483:	ff 75 0c             	pushl  0xc(%ebp)
  802486:	50                   	push   %eax
  802487:	6a 17                	push   $0x17
  802489:	e8 9c fd ff ff       	call   80222a <syscall>
  80248e:	83 c4 18             	add    $0x18,%esp
}
  802491:	c9                   	leave  
  802492:	c3                   	ret    

00802493 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802493:	55                   	push   %ebp
  802494:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802496:	8b 55 0c             	mov    0xc(%ebp),%edx
  802499:	8b 45 08             	mov    0x8(%ebp),%eax
  80249c:	6a 00                	push   $0x0
  80249e:	6a 00                	push   $0x0
  8024a0:	6a 00                	push   $0x0
  8024a2:	52                   	push   %edx
  8024a3:	50                   	push   %eax
  8024a4:	6a 1a                	push   $0x1a
  8024a6:	e8 7f fd ff ff       	call   80222a <syscall>
  8024ab:	83 c4 18             	add    $0x18,%esp
}
  8024ae:	c9                   	leave  
  8024af:	c3                   	ret    

008024b0 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8024b0:	55                   	push   %ebp
  8024b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8024b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b9:	6a 00                	push   $0x0
  8024bb:	6a 00                	push   $0x0
  8024bd:	6a 00                	push   $0x0
  8024bf:	52                   	push   %edx
  8024c0:	50                   	push   %eax
  8024c1:	6a 18                	push   $0x18
  8024c3:	e8 62 fd ff ff       	call   80222a <syscall>
  8024c8:	83 c4 18             	add    $0x18,%esp
}
  8024cb:	90                   	nop
  8024cc:	c9                   	leave  
  8024cd:	c3                   	ret    

008024ce <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8024ce:	55                   	push   %ebp
  8024cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8024d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d7:	6a 00                	push   $0x0
  8024d9:	6a 00                	push   $0x0
  8024db:	6a 00                	push   $0x0
  8024dd:	52                   	push   %edx
  8024de:	50                   	push   %eax
  8024df:	6a 19                	push   $0x19
  8024e1:	e8 44 fd ff ff       	call   80222a <syscall>
  8024e6:	83 c4 18             	add    $0x18,%esp
}
  8024e9:	90                   	nop
  8024ea:	c9                   	leave  
  8024eb:	c3                   	ret    

008024ec <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8024ec:	55                   	push   %ebp
  8024ed:	89 e5                	mov    %esp,%ebp
  8024ef:	83 ec 04             	sub    $0x4,%esp
  8024f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8024f5:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8024f8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8024fb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8024ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802502:	6a 00                	push   $0x0
  802504:	51                   	push   %ecx
  802505:	52                   	push   %edx
  802506:	ff 75 0c             	pushl  0xc(%ebp)
  802509:	50                   	push   %eax
  80250a:	6a 1b                	push   $0x1b
  80250c:	e8 19 fd ff ff       	call   80222a <syscall>
  802511:	83 c4 18             	add    $0x18,%esp
}
  802514:	c9                   	leave  
  802515:	c3                   	ret    

00802516 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802516:	55                   	push   %ebp
  802517:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802519:	8b 55 0c             	mov    0xc(%ebp),%edx
  80251c:	8b 45 08             	mov    0x8(%ebp),%eax
  80251f:	6a 00                	push   $0x0
  802521:	6a 00                	push   $0x0
  802523:	6a 00                	push   $0x0
  802525:	52                   	push   %edx
  802526:	50                   	push   %eax
  802527:	6a 1c                	push   $0x1c
  802529:	e8 fc fc ff ff       	call   80222a <syscall>
  80252e:	83 c4 18             	add    $0x18,%esp
}
  802531:	c9                   	leave  
  802532:	c3                   	ret    

00802533 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802533:	55                   	push   %ebp
  802534:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802536:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802539:	8b 55 0c             	mov    0xc(%ebp),%edx
  80253c:	8b 45 08             	mov    0x8(%ebp),%eax
  80253f:	6a 00                	push   $0x0
  802541:	6a 00                	push   $0x0
  802543:	51                   	push   %ecx
  802544:	52                   	push   %edx
  802545:	50                   	push   %eax
  802546:	6a 1d                	push   $0x1d
  802548:	e8 dd fc ff ff       	call   80222a <syscall>
  80254d:	83 c4 18             	add    $0x18,%esp
}
  802550:	c9                   	leave  
  802551:	c3                   	ret    

00802552 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802552:	55                   	push   %ebp
  802553:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802555:	8b 55 0c             	mov    0xc(%ebp),%edx
  802558:	8b 45 08             	mov    0x8(%ebp),%eax
  80255b:	6a 00                	push   $0x0
  80255d:	6a 00                	push   $0x0
  80255f:	6a 00                	push   $0x0
  802561:	52                   	push   %edx
  802562:	50                   	push   %eax
  802563:	6a 1e                	push   $0x1e
  802565:	e8 c0 fc ff ff       	call   80222a <syscall>
  80256a:	83 c4 18             	add    $0x18,%esp
}
  80256d:	c9                   	leave  
  80256e:	c3                   	ret    

0080256f <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80256f:	55                   	push   %ebp
  802570:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802572:	6a 00                	push   $0x0
  802574:	6a 00                	push   $0x0
  802576:	6a 00                	push   $0x0
  802578:	6a 00                	push   $0x0
  80257a:	6a 00                	push   $0x0
  80257c:	6a 1f                	push   $0x1f
  80257e:	e8 a7 fc ff ff       	call   80222a <syscall>
  802583:	83 c4 18             	add    $0x18,%esp
}
  802586:	c9                   	leave  
  802587:	c3                   	ret    

00802588 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802588:	55                   	push   %ebp
  802589:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80258b:	8b 45 08             	mov    0x8(%ebp),%eax
  80258e:	6a 00                	push   $0x0
  802590:	ff 75 14             	pushl  0x14(%ebp)
  802593:	ff 75 10             	pushl  0x10(%ebp)
  802596:	ff 75 0c             	pushl  0xc(%ebp)
  802599:	50                   	push   %eax
  80259a:	6a 20                	push   $0x20
  80259c:	e8 89 fc ff ff       	call   80222a <syscall>
  8025a1:	83 c4 18             	add    $0x18,%esp
}
  8025a4:	c9                   	leave  
  8025a5:	c3                   	ret    

008025a6 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8025a6:	55                   	push   %ebp
  8025a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8025a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ac:	6a 00                	push   $0x0
  8025ae:	6a 00                	push   $0x0
  8025b0:	6a 00                	push   $0x0
  8025b2:	6a 00                	push   $0x0
  8025b4:	50                   	push   %eax
  8025b5:	6a 21                	push   $0x21
  8025b7:	e8 6e fc ff ff       	call   80222a <syscall>
  8025bc:	83 c4 18             	add    $0x18,%esp
}
  8025bf:	90                   	nop
  8025c0:	c9                   	leave  
  8025c1:	c3                   	ret    

008025c2 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8025c2:	55                   	push   %ebp
  8025c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8025c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c8:	6a 00                	push   $0x0
  8025ca:	6a 00                	push   $0x0
  8025cc:	6a 00                	push   $0x0
  8025ce:	6a 00                	push   $0x0
  8025d0:	50                   	push   %eax
  8025d1:	6a 22                	push   $0x22
  8025d3:	e8 52 fc ff ff       	call   80222a <syscall>
  8025d8:	83 c4 18             	add    $0x18,%esp
}
  8025db:	c9                   	leave  
  8025dc:	c3                   	ret    

008025dd <sys_getenvid>:

int32 sys_getenvid(void)
{
  8025dd:	55                   	push   %ebp
  8025de:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8025e0:	6a 00                	push   $0x0
  8025e2:	6a 00                	push   $0x0
  8025e4:	6a 00                	push   $0x0
  8025e6:	6a 00                	push   $0x0
  8025e8:	6a 00                	push   $0x0
  8025ea:	6a 02                	push   $0x2
  8025ec:	e8 39 fc ff ff       	call   80222a <syscall>
  8025f1:	83 c4 18             	add    $0x18,%esp
}
  8025f4:	c9                   	leave  
  8025f5:	c3                   	ret    

008025f6 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8025f6:	55                   	push   %ebp
  8025f7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8025f9:	6a 00                	push   $0x0
  8025fb:	6a 00                	push   $0x0
  8025fd:	6a 00                	push   $0x0
  8025ff:	6a 00                	push   $0x0
  802601:	6a 00                	push   $0x0
  802603:	6a 03                	push   $0x3
  802605:	e8 20 fc ff ff       	call   80222a <syscall>
  80260a:	83 c4 18             	add    $0x18,%esp
}
  80260d:	c9                   	leave  
  80260e:	c3                   	ret    

0080260f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80260f:	55                   	push   %ebp
  802610:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802612:	6a 00                	push   $0x0
  802614:	6a 00                	push   $0x0
  802616:	6a 00                	push   $0x0
  802618:	6a 00                	push   $0x0
  80261a:	6a 00                	push   $0x0
  80261c:	6a 04                	push   $0x4
  80261e:	e8 07 fc ff ff       	call   80222a <syscall>
  802623:	83 c4 18             	add    $0x18,%esp
}
  802626:	c9                   	leave  
  802627:	c3                   	ret    

00802628 <sys_exit_env>:


void sys_exit_env(void)
{
  802628:	55                   	push   %ebp
  802629:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80262b:	6a 00                	push   $0x0
  80262d:	6a 00                	push   $0x0
  80262f:	6a 00                	push   $0x0
  802631:	6a 00                	push   $0x0
  802633:	6a 00                	push   $0x0
  802635:	6a 23                	push   $0x23
  802637:	e8 ee fb ff ff       	call   80222a <syscall>
  80263c:	83 c4 18             	add    $0x18,%esp
}
  80263f:	90                   	nop
  802640:	c9                   	leave  
  802641:	c3                   	ret    

00802642 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802642:	55                   	push   %ebp
  802643:	89 e5                	mov    %esp,%ebp
  802645:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802648:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80264b:	8d 50 04             	lea    0x4(%eax),%edx
  80264e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802651:	6a 00                	push   $0x0
  802653:	6a 00                	push   $0x0
  802655:	6a 00                	push   $0x0
  802657:	52                   	push   %edx
  802658:	50                   	push   %eax
  802659:	6a 24                	push   $0x24
  80265b:	e8 ca fb ff ff       	call   80222a <syscall>
  802660:	83 c4 18             	add    $0x18,%esp
	return result;
  802663:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802666:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802669:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80266c:	89 01                	mov    %eax,(%ecx)
  80266e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802671:	8b 45 08             	mov    0x8(%ebp),%eax
  802674:	c9                   	leave  
  802675:	c2 04 00             	ret    $0x4

00802678 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802678:	55                   	push   %ebp
  802679:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80267b:	6a 00                	push   $0x0
  80267d:	6a 00                	push   $0x0
  80267f:	ff 75 10             	pushl  0x10(%ebp)
  802682:	ff 75 0c             	pushl  0xc(%ebp)
  802685:	ff 75 08             	pushl  0x8(%ebp)
  802688:	6a 12                	push   $0x12
  80268a:	e8 9b fb ff ff       	call   80222a <syscall>
  80268f:	83 c4 18             	add    $0x18,%esp
	return ;
  802692:	90                   	nop
}
  802693:	c9                   	leave  
  802694:	c3                   	ret    

00802695 <sys_rcr2>:
uint32 sys_rcr2()
{
  802695:	55                   	push   %ebp
  802696:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802698:	6a 00                	push   $0x0
  80269a:	6a 00                	push   $0x0
  80269c:	6a 00                	push   $0x0
  80269e:	6a 00                	push   $0x0
  8026a0:	6a 00                	push   $0x0
  8026a2:	6a 25                	push   $0x25
  8026a4:	e8 81 fb ff ff       	call   80222a <syscall>
  8026a9:	83 c4 18             	add    $0x18,%esp
}
  8026ac:	c9                   	leave  
  8026ad:	c3                   	ret    

008026ae <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8026ae:	55                   	push   %ebp
  8026af:	89 e5                	mov    %esp,%ebp
  8026b1:	83 ec 04             	sub    $0x4,%esp
  8026b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8026ba:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8026be:	6a 00                	push   $0x0
  8026c0:	6a 00                	push   $0x0
  8026c2:	6a 00                	push   $0x0
  8026c4:	6a 00                	push   $0x0
  8026c6:	50                   	push   %eax
  8026c7:	6a 26                	push   $0x26
  8026c9:	e8 5c fb ff ff       	call   80222a <syscall>
  8026ce:	83 c4 18             	add    $0x18,%esp
	return ;
  8026d1:	90                   	nop
}
  8026d2:	c9                   	leave  
  8026d3:	c3                   	ret    

008026d4 <rsttst>:
void rsttst()
{
  8026d4:	55                   	push   %ebp
  8026d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8026d7:	6a 00                	push   $0x0
  8026d9:	6a 00                	push   $0x0
  8026db:	6a 00                	push   $0x0
  8026dd:	6a 00                	push   $0x0
  8026df:	6a 00                	push   $0x0
  8026e1:	6a 28                	push   $0x28
  8026e3:	e8 42 fb ff ff       	call   80222a <syscall>
  8026e8:	83 c4 18             	add    $0x18,%esp
	return ;
  8026eb:	90                   	nop
}
  8026ec:	c9                   	leave  
  8026ed:	c3                   	ret    

008026ee <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8026ee:	55                   	push   %ebp
  8026ef:	89 e5                	mov    %esp,%ebp
  8026f1:	83 ec 04             	sub    $0x4,%esp
  8026f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8026f7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8026fa:	8b 55 18             	mov    0x18(%ebp),%edx
  8026fd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802701:	52                   	push   %edx
  802702:	50                   	push   %eax
  802703:	ff 75 10             	pushl  0x10(%ebp)
  802706:	ff 75 0c             	pushl  0xc(%ebp)
  802709:	ff 75 08             	pushl  0x8(%ebp)
  80270c:	6a 27                	push   $0x27
  80270e:	e8 17 fb ff ff       	call   80222a <syscall>
  802713:	83 c4 18             	add    $0x18,%esp
	return ;
  802716:	90                   	nop
}
  802717:	c9                   	leave  
  802718:	c3                   	ret    

00802719 <chktst>:
void chktst(uint32 n)
{
  802719:	55                   	push   %ebp
  80271a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80271c:	6a 00                	push   $0x0
  80271e:	6a 00                	push   $0x0
  802720:	6a 00                	push   $0x0
  802722:	6a 00                	push   $0x0
  802724:	ff 75 08             	pushl  0x8(%ebp)
  802727:	6a 29                	push   $0x29
  802729:	e8 fc fa ff ff       	call   80222a <syscall>
  80272e:	83 c4 18             	add    $0x18,%esp
	return ;
  802731:	90                   	nop
}
  802732:	c9                   	leave  
  802733:	c3                   	ret    

00802734 <inctst>:

void inctst()
{
  802734:	55                   	push   %ebp
  802735:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802737:	6a 00                	push   $0x0
  802739:	6a 00                	push   $0x0
  80273b:	6a 00                	push   $0x0
  80273d:	6a 00                	push   $0x0
  80273f:	6a 00                	push   $0x0
  802741:	6a 2a                	push   $0x2a
  802743:	e8 e2 fa ff ff       	call   80222a <syscall>
  802748:	83 c4 18             	add    $0x18,%esp
	return ;
  80274b:	90                   	nop
}
  80274c:	c9                   	leave  
  80274d:	c3                   	ret    

0080274e <gettst>:
uint32 gettst()
{
  80274e:	55                   	push   %ebp
  80274f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802751:	6a 00                	push   $0x0
  802753:	6a 00                	push   $0x0
  802755:	6a 00                	push   $0x0
  802757:	6a 00                	push   $0x0
  802759:	6a 00                	push   $0x0
  80275b:	6a 2b                	push   $0x2b
  80275d:	e8 c8 fa ff ff       	call   80222a <syscall>
  802762:	83 c4 18             	add    $0x18,%esp
}
  802765:	c9                   	leave  
  802766:	c3                   	ret    

00802767 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802767:	55                   	push   %ebp
  802768:	89 e5                	mov    %esp,%ebp
  80276a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80276d:	6a 00                	push   $0x0
  80276f:	6a 00                	push   $0x0
  802771:	6a 00                	push   $0x0
  802773:	6a 00                	push   $0x0
  802775:	6a 00                	push   $0x0
  802777:	6a 2c                	push   $0x2c
  802779:	e8 ac fa ff ff       	call   80222a <syscall>
  80277e:	83 c4 18             	add    $0x18,%esp
  802781:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802784:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802788:	75 07                	jne    802791 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80278a:	b8 01 00 00 00       	mov    $0x1,%eax
  80278f:	eb 05                	jmp    802796 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802791:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802796:	c9                   	leave  
  802797:	c3                   	ret    

00802798 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802798:	55                   	push   %ebp
  802799:	89 e5                	mov    %esp,%ebp
  80279b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80279e:	6a 00                	push   $0x0
  8027a0:	6a 00                	push   $0x0
  8027a2:	6a 00                	push   $0x0
  8027a4:	6a 00                	push   $0x0
  8027a6:	6a 00                	push   $0x0
  8027a8:	6a 2c                	push   $0x2c
  8027aa:	e8 7b fa ff ff       	call   80222a <syscall>
  8027af:	83 c4 18             	add    $0x18,%esp
  8027b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8027b5:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8027b9:	75 07                	jne    8027c2 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8027bb:	b8 01 00 00 00       	mov    $0x1,%eax
  8027c0:	eb 05                	jmp    8027c7 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8027c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027c7:	c9                   	leave  
  8027c8:	c3                   	ret    

008027c9 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8027c9:	55                   	push   %ebp
  8027ca:	89 e5                	mov    %esp,%ebp
  8027cc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027cf:	6a 00                	push   $0x0
  8027d1:	6a 00                	push   $0x0
  8027d3:	6a 00                	push   $0x0
  8027d5:	6a 00                	push   $0x0
  8027d7:	6a 00                	push   $0x0
  8027d9:	6a 2c                	push   $0x2c
  8027db:	e8 4a fa ff ff       	call   80222a <syscall>
  8027e0:	83 c4 18             	add    $0x18,%esp
  8027e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8027e6:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8027ea:	75 07                	jne    8027f3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8027ec:	b8 01 00 00 00       	mov    $0x1,%eax
  8027f1:	eb 05                	jmp    8027f8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8027f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027f8:	c9                   	leave  
  8027f9:	c3                   	ret    

008027fa <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8027fa:	55                   	push   %ebp
  8027fb:	89 e5                	mov    %esp,%ebp
  8027fd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802800:	6a 00                	push   $0x0
  802802:	6a 00                	push   $0x0
  802804:	6a 00                	push   $0x0
  802806:	6a 00                	push   $0x0
  802808:	6a 00                	push   $0x0
  80280a:	6a 2c                	push   $0x2c
  80280c:	e8 19 fa ff ff       	call   80222a <syscall>
  802811:	83 c4 18             	add    $0x18,%esp
  802814:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802817:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80281b:	75 07                	jne    802824 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80281d:	b8 01 00 00 00       	mov    $0x1,%eax
  802822:	eb 05                	jmp    802829 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802824:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802829:	c9                   	leave  
  80282a:	c3                   	ret    

0080282b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80282b:	55                   	push   %ebp
  80282c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80282e:	6a 00                	push   $0x0
  802830:	6a 00                	push   $0x0
  802832:	6a 00                	push   $0x0
  802834:	6a 00                	push   $0x0
  802836:	ff 75 08             	pushl  0x8(%ebp)
  802839:	6a 2d                	push   $0x2d
  80283b:	e8 ea f9 ff ff       	call   80222a <syscall>
  802840:	83 c4 18             	add    $0x18,%esp
	return ;
  802843:	90                   	nop
}
  802844:	c9                   	leave  
  802845:	c3                   	ret    

00802846 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802846:	55                   	push   %ebp
  802847:	89 e5                	mov    %esp,%ebp
  802849:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80284a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80284d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802850:	8b 55 0c             	mov    0xc(%ebp),%edx
  802853:	8b 45 08             	mov    0x8(%ebp),%eax
  802856:	6a 00                	push   $0x0
  802858:	53                   	push   %ebx
  802859:	51                   	push   %ecx
  80285a:	52                   	push   %edx
  80285b:	50                   	push   %eax
  80285c:	6a 2e                	push   $0x2e
  80285e:	e8 c7 f9 ff ff       	call   80222a <syscall>
  802863:	83 c4 18             	add    $0x18,%esp
}
  802866:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802869:	c9                   	leave  
  80286a:	c3                   	ret    

0080286b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80286b:	55                   	push   %ebp
  80286c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80286e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802871:	8b 45 08             	mov    0x8(%ebp),%eax
  802874:	6a 00                	push   $0x0
  802876:	6a 00                	push   $0x0
  802878:	6a 00                	push   $0x0
  80287a:	52                   	push   %edx
  80287b:	50                   	push   %eax
  80287c:	6a 2f                	push   $0x2f
  80287e:	e8 a7 f9 ff ff       	call   80222a <syscall>
  802883:	83 c4 18             	add    $0x18,%esp
}
  802886:	c9                   	leave  
  802887:	c3                   	ret    

00802888 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802888:	55                   	push   %ebp
  802889:	89 e5                	mov    %esp,%ebp
  80288b:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80288e:	83 ec 0c             	sub    $0xc,%esp
  802891:	68 a0 43 80 00       	push   $0x8043a0
  802896:	e8 c3 e6 ff ff       	call   800f5e <cprintf>
  80289b:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80289e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8028a5:	83 ec 0c             	sub    $0xc,%esp
  8028a8:	68 cc 43 80 00       	push   $0x8043cc
  8028ad:	e8 ac e6 ff ff       	call   800f5e <cprintf>
  8028b2:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8028b5:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8028b9:	a1 38 51 80 00       	mov    0x805138,%eax
  8028be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028c1:	eb 56                	jmp    802919 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8028c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028c7:	74 1c                	je     8028e5 <print_mem_block_lists+0x5d>
  8028c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cc:	8b 50 08             	mov    0x8(%eax),%edx
  8028cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d2:	8b 48 08             	mov    0x8(%eax),%ecx
  8028d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8028db:	01 c8                	add    %ecx,%eax
  8028dd:	39 c2                	cmp    %eax,%edx
  8028df:	73 04                	jae    8028e5 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8028e1:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8028e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e8:	8b 50 08             	mov    0x8(%eax),%edx
  8028eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8028f1:	01 c2                	add    %eax,%edx
  8028f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f6:	8b 40 08             	mov    0x8(%eax),%eax
  8028f9:	83 ec 04             	sub    $0x4,%esp
  8028fc:	52                   	push   %edx
  8028fd:	50                   	push   %eax
  8028fe:	68 e1 43 80 00       	push   $0x8043e1
  802903:	e8 56 e6 ff ff       	call   800f5e <cprintf>
  802908:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80290b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802911:	a1 40 51 80 00       	mov    0x805140,%eax
  802916:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802919:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80291d:	74 07                	je     802926 <print_mem_block_lists+0x9e>
  80291f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802922:	8b 00                	mov    (%eax),%eax
  802924:	eb 05                	jmp    80292b <print_mem_block_lists+0xa3>
  802926:	b8 00 00 00 00       	mov    $0x0,%eax
  80292b:	a3 40 51 80 00       	mov    %eax,0x805140
  802930:	a1 40 51 80 00       	mov    0x805140,%eax
  802935:	85 c0                	test   %eax,%eax
  802937:	75 8a                	jne    8028c3 <print_mem_block_lists+0x3b>
  802939:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80293d:	75 84                	jne    8028c3 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80293f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802943:	75 10                	jne    802955 <print_mem_block_lists+0xcd>
  802945:	83 ec 0c             	sub    $0xc,%esp
  802948:	68 f0 43 80 00       	push   $0x8043f0
  80294d:	e8 0c e6 ff ff       	call   800f5e <cprintf>
  802952:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802955:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80295c:	83 ec 0c             	sub    $0xc,%esp
  80295f:	68 14 44 80 00       	push   $0x804414
  802964:	e8 f5 e5 ff ff       	call   800f5e <cprintf>
  802969:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80296c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802970:	a1 40 50 80 00       	mov    0x805040,%eax
  802975:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802978:	eb 56                	jmp    8029d0 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80297a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80297e:	74 1c                	je     80299c <print_mem_block_lists+0x114>
  802980:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802983:	8b 50 08             	mov    0x8(%eax),%edx
  802986:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802989:	8b 48 08             	mov    0x8(%eax),%ecx
  80298c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80298f:	8b 40 0c             	mov    0xc(%eax),%eax
  802992:	01 c8                	add    %ecx,%eax
  802994:	39 c2                	cmp    %eax,%edx
  802996:	73 04                	jae    80299c <print_mem_block_lists+0x114>
			sorted = 0 ;
  802998:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80299c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299f:	8b 50 08             	mov    0x8(%eax),%edx
  8029a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8029a8:	01 c2                	add    %eax,%edx
  8029aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ad:	8b 40 08             	mov    0x8(%eax),%eax
  8029b0:	83 ec 04             	sub    $0x4,%esp
  8029b3:	52                   	push   %edx
  8029b4:	50                   	push   %eax
  8029b5:	68 e1 43 80 00       	push   $0x8043e1
  8029ba:	e8 9f e5 ff ff       	call   800f5e <cprintf>
  8029bf:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8029c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8029c8:	a1 48 50 80 00       	mov    0x805048,%eax
  8029cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029d4:	74 07                	je     8029dd <print_mem_block_lists+0x155>
  8029d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d9:	8b 00                	mov    (%eax),%eax
  8029db:	eb 05                	jmp    8029e2 <print_mem_block_lists+0x15a>
  8029dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8029e2:	a3 48 50 80 00       	mov    %eax,0x805048
  8029e7:	a1 48 50 80 00       	mov    0x805048,%eax
  8029ec:	85 c0                	test   %eax,%eax
  8029ee:	75 8a                	jne    80297a <print_mem_block_lists+0xf2>
  8029f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029f4:	75 84                	jne    80297a <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8029f6:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8029fa:	75 10                	jne    802a0c <print_mem_block_lists+0x184>
  8029fc:	83 ec 0c             	sub    $0xc,%esp
  8029ff:	68 2c 44 80 00       	push   $0x80442c
  802a04:	e8 55 e5 ff ff       	call   800f5e <cprintf>
  802a09:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802a0c:	83 ec 0c             	sub    $0xc,%esp
  802a0f:	68 a0 43 80 00       	push   $0x8043a0
  802a14:	e8 45 e5 ff ff       	call   800f5e <cprintf>
  802a19:	83 c4 10             	add    $0x10,%esp

}
  802a1c:	90                   	nop
  802a1d:	c9                   	leave  
  802a1e:	c3                   	ret    

00802a1f <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802a1f:	55                   	push   %ebp
  802a20:	89 e5                	mov    %esp,%ebp
  802a22:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  802a25:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802a2c:	00 00 00 
  802a2f:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802a36:	00 00 00 
  802a39:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802a40:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802a43:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802a4a:	e9 9e 00 00 00       	jmp    802aed <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802a4f:	a1 50 50 80 00       	mov    0x805050,%eax
  802a54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a57:	c1 e2 04             	shl    $0x4,%edx
  802a5a:	01 d0                	add    %edx,%eax
  802a5c:	85 c0                	test   %eax,%eax
  802a5e:	75 14                	jne    802a74 <initialize_MemBlocksList+0x55>
  802a60:	83 ec 04             	sub    $0x4,%esp
  802a63:	68 54 44 80 00       	push   $0x804454
  802a68:	6a 47                	push   $0x47
  802a6a:	68 77 44 80 00       	push   $0x804477
  802a6f:	e8 36 e2 ff ff       	call   800caa <_panic>
  802a74:	a1 50 50 80 00       	mov    0x805050,%eax
  802a79:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a7c:	c1 e2 04             	shl    $0x4,%edx
  802a7f:	01 d0                	add    %edx,%eax
  802a81:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802a87:	89 10                	mov    %edx,(%eax)
  802a89:	8b 00                	mov    (%eax),%eax
  802a8b:	85 c0                	test   %eax,%eax
  802a8d:	74 18                	je     802aa7 <initialize_MemBlocksList+0x88>
  802a8f:	a1 48 51 80 00       	mov    0x805148,%eax
  802a94:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802a9a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802a9d:	c1 e1 04             	shl    $0x4,%ecx
  802aa0:	01 ca                	add    %ecx,%edx
  802aa2:	89 50 04             	mov    %edx,0x4(%eax)
  802aa5:	eb 12                	jmp    802ab9 <initialize_MemBlocksList+0x9a>
  802aa7:	a1 50 50 80 00       	mov    0x805050,%eax
  802aac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aaf:	c1 e2 04             	shl    $0x4,%edx
  802ab2:	01 d0                	add    %edx,%eax
  802ab4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ab9:	a1 50 50 80 00       	mov    0x805050,%eax
  802abe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ac1:	c1 e2 04             	shl    $0x4,%edx
  802ac4:	01 d0                	add    %edx,%eax
  802ac6:	a3 48 51 80 00       	mov    %eax,0x805148
  802acb:	a1 50 50 80 00       	mov    0x805050,%eax
  802ad0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ad3:	c1 e2 04             	shl    $0x4,%edx
  802ad6:	01 d0                	add    %edx,%eax
  802ad8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802adf:	a1 54 51 80 00       	mov    0x805154,%eax
  802ae4:	40                   	inc    %eax
  802ae5:	a3 54 51 80 00       	mov    %eax,0x805154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802aea:	ff 45 f4             	incl   -0xc(%ebp)
  802aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802af3:	0f 82 56 ff ff ff    	jb     802a4f <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  802af9:	90                   	nop
  802afa:	c9                   	leave  
  802afb:	c3                   	ret    

00802afc <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802afc:	55                   	push   %ebp
  802afd:	89 e5                	mov    %esp,%ebp
  802aff:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802b02:	8b 45 08             	mov    0x8(%ebp),%eax
  802b05:	8b 00                	mov    (%eax),%eax
  802b07:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802b0a:	eb 19                	jmp    802b25 <find_block+0x29>
	{
		if(element->sva == va){
  802b0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b0f:	8b 40 08             	mov    0x8(%eax),%eax
  802b12:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802b15:	75 05                	jne    802b1c <find_block+0x20>
			 		return element;
  802b17:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b1a:	eb 36                	jmp    802b52 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1f:	8b 40 08             	mov    0x8(%eax),%eax
  802b22:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802b25:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802b29:	74 07                	je     802b32 <find_block+0x36>
  802b2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b2e:	8b 00                	mov    (%eax),%eax
  802b30:	eb 05                	jmp    802b37 <find_block+0x3b>
  802b32:	b8 00 00 00 00       	mov    $0x0,%eax
  802b37:	8b 55 08             	mov    0x8(%ebp),%edx
  802b3a:	89 42 08             	mov    %eax,0x8(%edx)
  802b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b40:	8b 40 08             	mov    0x8(%eax),%eax
  802b43:	85 c0                	test   %eax,%eax
  802b45:	75 c5                	jne    802b0c <find_block+0x10>
  802b47:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802b4b:	75 bf                	jne    802b0c <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  802b4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b52:	c9                   	leave  
  802b53:	c3                   	ret    

00802b54 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802b54:	55                   	push   %ebp
  802b55:	89 e5                	mov    %esp,%ebp
  802b57:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  802b5a:	a1 44 50 80 00       	mov    0x805044,%eax
  802b5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  802b62:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b67:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  802b6a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b6e:	74 0a                	je     802b7a <insert_sorted_allocList+0x26>
  802b70:	8b 45 08             	mov    0x8(%ebp),%eax
  802b73:	8b 40 08             	mov    0x8(%eax),%eax
  802b76:	85 c0                	test   %eax,%eax
  802b78:	75 65                	jne    802bdf <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802b7a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b7e:	75 14                	jne    802b94 <insert_sorted_allocList+0x40>
  802b80:	83 ec 04             	sub    $0x4,%esp
  802b83:	68 54 44 80 00       	push   $0x804454
  802b88:	6a 6e                	push   $0x6e
  802b8a:	68 77 44 80 00       	push   $0x804477
  802b8f:	e8 16 e1 ff ff       	call   800caa <_panic>
  802b94:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9d:	89 10                	mov    %edx,(%eax)
  802b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba2:	8b 00                	mov    (%eax),%eax
  802ba4:	85 c0                	test   %eax,%eax
  802ba6:	74 0d                	je     802bb5 <insert_sorted_allocList+0x61>
  802ba8:	a1 40 50 80 00       	mov    0x805040,%eax
  802bad:	8b 55 08             	mov    0x8(%ebp),%edx
  802bb0:	89 50 04             	mov    %edx,0x4(%eax)
  802bb3:	eb 08                	jmp    802bbd <insert_sorted_allocList+0x69>
  802bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb8:	a3 44 50 80 00       	mov    %eax,0x805044
  802bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc0:	a3 40 50 80 00       	mov    %eax,0x805040
  802bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bcf:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802bd4:	40                   	inc    %eax
  802bd5:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802bda:	e9 cf 01 00 00       	jmp    802dae <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  802bdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be2:	8b 50 08             	mov    0x8(%eax),%edx
  802be5:	8b 45 08             	mov    0x8(%ebp),%eax
  802be8:	8b 40 08             	mov    0x8(%eax),%eax
  802beb:	39 c2                	cmp    %eax,%edx
  802bed:	73 65                	jae    802c54 <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802bef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bf3:	75 14                	jne    802c09 <insert_sorted_allocList+0xb5>
  802bf5:	83 ec 04             	sub    $0x4,%esp
  802bf8:	68 90 44 80 00       	push   $0x804490
  802bfd:	6a 72                	push   $0x72
  802bff:	68 77 44 80 00       	push   $0x804477
  802c04:	e8 a1 e0 ff ff       	call   800caa <_panic>
  802c09:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c12:	89 50 04             	mov    %edx,0x4(%eax)
  802c15:	8b 45 08             	mov    0x8(%ebp),%eax
  802c18:	8b 40 04             	mov    0x4(%eax),%eax
  802c1b:	85 c0                	test   %eax,%eax
  802c1d:	74 0c                	je     802c2b <insert_sorted_allocList+0xd7>
  802c1f:	a1 44 50 80 00       	mov    0x805044,%eax
  802c24:	8b 55 08             	mov    0x8(%ebp),%edx
  802c27:	89 10                	mov    %edx,(%eax)
  802c29:	eb 08                	jmp    802c33 <insert_sorted_allocList+0xdf>
  802c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2e:	a3 40 50 80 00       	mov    %eax,0x805040
  802c33:	8b 45 08             	mov    0x8(%ebp),%eax
  802c36:	a3 44 50 80 00       	mov    %eax,0x805044
  802c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c44:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c49:	40                   	inc    %eax
  802c4a:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  802c4f:	e9 5a 01 00 00       	jmp    802dae <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  802c54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c57:	8b 50 08             	mov    0x8(%eax),%edx
  802c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5d:	8b 40 08             	mov    0x8(%eax),%eax
  802c60:	39 c2                	cmp    %eax,%edx
  802c62:	75 70                	jne    802cd4 <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  802c64:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c68:	74 06                	je     802c70 <insert_sorted_allocList+0x11c>
  802c6a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c6e:	75 14                	jne    802c84 <insert_sorted_allocList+0x130>
  802c70:	83 ec 04             	sub    $0x4,%esp
  802c73:	68 b4 44 80 00       	push   $0x8044b4
  802c78:	6a 75                	push   $0x75
  802c7a:	68 77 44 80 00       	push   $0x804477
  802c7f:	e8 26 e0 ff ff       	call   800caa <_panic>
  802c84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c87:	8b 10                	mov    (%eax),%edx
  802c89:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8c:	89 10                	mov    %edx,(%eax)
  802c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c91:	8b 00                	mov    (%eax),%eax
  802c93:	85 c0                	test   %eax,%eax
  802c95:	74 0b                	je     802ca2 <insert_sorted_allocList+0x14e>
  802c97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9a:	8b 00                	mov    (%eax),%eax
  802c9c:	8b 55 08             	mov    0x8(%ebp),%edx
  802c9f:	89 50 04             	mov    %edx,0x4(%eax)
  802ca2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca5:	8b 55 08             	mov    0x8(%ebp),%edx
  802ca8:	89 10                	mov    %edx,(%eax)
  802caa:	8b 45 08             	mov    0x8(%ebp),%eax
  802cad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cb0:	89 50 04             	mov    %edx,0x4(%eax)
  802cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb6:	8b 00                	mov    (%eax),%eax
  802cb8:	85 c0                	test   %eax,%eax
  802cba:	75 08                	jne    802cc4 <insert_sorted_allocList+0x170>
  802cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbf:	a3 44 50 80 00       	mov    %eax,0x805044
  802cc4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802cc9:	40                   	inc    %eax
  802cca:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  802ccf:	e9 da 00 00 00       	jmp    802dae <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802cd4:	a1 40 50 80 00       	mov    0x805040,%eax
  802cd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cdc:	e9 9d 00 00 00       	jmp    802d7e <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  802ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce4:	8b 00                	mov    (%eax),%eax
  802ce6:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  802ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cec:	8b 50 08             	mov    0x8(%eax),%edx
  802cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf2:	8b 40 08             	mov    0x8(%eax),%eax
  802cf5:	39 c2                	cmp    %eax,%edx
  802cf7:	76 7d                	jbe    802d76 <insert_sorted_allocList+0x222>
  802cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfc:	8b 50 08             	mov    0x8(%eax),%edx
  802cff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d02:	8b 40 08             	mov    0x8(%eax),%eax
  802d05:	39 c2                	cmp    %eax,%edx
  802d07:	73 6d                	jae    802d76 <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802d09:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d0d:	74 06                	je     802d15 <insert_sorted_allocList+0x1c1>
  802d0f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d13:	75 14                	jne    802d29 <insert_sorted_allocList+0x1d5>
  802d15:	83 ec 04             	sub    $0x4,%esp
  802d18:	68 b4 44 80 00       	push   $0x8044b4
  802d1d:	6a 7c                	push   $0x7c
  802d1f:	68 77 44 80 00       	push   $0x804477
  802d24:	e8 81 df ff ff       	call   800caa <_panic>
  802d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2c:	8b 10                	mov    (%eax),%edx
  802d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d31:	89 10                	mov    %edx,(%eax)
  802d33:	8b 45 08             	mov    0x8(%ebp),%eax
  802d36:	8b 00                	mov    (%eax),%eax
  802d38:	85 c0                	test   %eax,%eax
  802d3a:	74 0b                	je     802d47 <insert_sorted_allocList+0x1f3>
  802d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3f:	8b 00                	mov    (%eax),%eax
  802d41:	8b 55 08             	mov    0x8(%ebp),%edx
  802d44:	89 50 04             	mov    %edx,0x4(%eax)
  802d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4a:	8b 55 08             	mov    0x8(%ebp),%edx
  802d4d:	89 10                	mov    %edx,(%eax)
  802d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d55:	89 50 04             	mov    %edx,0x4(%eax)
  802d58:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5b:	8b 00                	mov    (%eax),%eax
  802d5d:	85 c0                	test   %eax,%eax
  802d5f:	75 08                	jne    802d69 <insert_sorted_allocList+0x215>
  802d61:	8b 45 08             	mov    0x8(%ebp),%eax
  802d64:	a3 44 50 80 00       	mov    %eax,0x805044
  802d69:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802d6e:	40                   	inc    %eax
  802d6f:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802d74:	eb 38                	jmp    802dae <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802d76:	a1 48 50 80 00       	mov    0x805048,%eax
  802d7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d82:	74 07                	je     802d8b <insert_sorted_allocList+0x237>
  802d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d87:	8b 00                	mov    (%eax),%eax
  802d89:	eb 05                	jmp    802d90 <insert_sorted_allocList+0x23c>
  802d8b:	b8 00 00 00 00       	mov    $0x0,%eax
  802d90:	a3 48 50 80 00       	mov    %eax,0x805048
  802d95:	a1 48 50 80 00       	mov    0x805048,%eax
  802d9a:	85 c0                	test   %eax,%eax
  802d9c:	0f 85 3f ff ff ff    	jne    802ce1 <insert_sorted_allocList+0x18d>
  802da2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802da6:	0f 85 35 ff ff ff    	jne    802ce1 <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  802dac:	eb 00                	jmp    802dae <insert_sorted_allocList+0x25a>
  802dae:	90                   	nop
  802daf:	c9                   	leave  
  802db0:	c3                   	ret    

00802db1 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802db1:	55                   	push   %ebp
  802db2:	89 e5                	mov    %esp,%ebp
  802db4:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802db7:	a1 38 51 80 00       	mov    0x805138,%eax
  802dbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dbf:	e9 6b 02 00 00       	jmp    80302f <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  802dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc7:	8b 40 0c             	mov    0xc(%eax),%eax
  802dca:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dcd:	0f 85 90 00 00 00    	jne    802e63 <alloc_block_FF+0xb2>
			  temp=element;
  802dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd6:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  802dd9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ddd:	75 17                	jne    802df6 <alloc_block_FF+0x45>
  802ddf:	83 ec 04             	sub    $0x4,%esp
  802de2:	68 e8 44 80 00       	push   $0x8044e8
  802de7:	68 92 00 00 00       	push   $0x92
  802dec:	68 77 44 80 00       	push   $0x804477
  802df1:	e8 b4 de ff ff       	call   800caa <_panic>
  802df6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df9:	8b 00                	mov    (%eax),%eax
  802dfb:	85 c0                	test   %eax,%eax
  802dfd:	74 10                	je     802e0f <alloc_block_FF+0x5e>
  802dff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e02:	8b 00                	mov    (%eax),%eax
  802e04:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e07:	8b 52 04             	mov    0x4(%edx),%edx
  802e0a:	89 50 04             	mov    %edx,0x4(%eax)
  802e0d:	eb 0b                	jmp    802e1a <alloc_block_FF+0x69>
  802e0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e12:	8b 40 04             	mov    0x4(%eax),%eax
  802e15:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1d:	8b 40 04             	mov    0x4(%eax),%eax
  802e20:	85 c0                	test   %eax,%eax
  802e22:	74 0f                	je     802e33 <alloc_block_FF+0x82>
  802e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e27:	8b 40 04             	mov    0x4(%eax),%eax
  802e2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e2d:	8b 12                	mov    (%edx),%edx
  802e2f:	89 10                	mov    %edx,(%eax)
  802e31:	eb 0a                	jmp    802e3d <alloc_block_FF+0x8c>
  802e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e36:	8b 00                	mov    (%eax),%eax
  802e38:	a3 38 51 80 00       	mov    %eax,0x805138
  802e3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e40:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e49:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e50:	a1 44 51 80 00       	mov    0x805144,%eax
  802e55:	48                   	dec    %eax
  802e56:	a3 44 51 80 00       	mov    %eax,0x805144
			  return temp;
  802e5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e5e:	e9 ff 01 00 00       	jmp    803062 <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  802e63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e66:	8b 40 0c             	mov    0xc(%eax),%eax
  802e69:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e6c:	0f 86 b5 01 00 00    	jbe    803027 <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  802e72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e75:	8b 40 0c             	mov    0xc(%eax),%eax
  802e78:	2b 45 08             	sub    0x8(%ebp),%eax
  802e7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  802e7e:	a1 48 51 80 00       	mov    0x805148,%eax
  802e83:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  802e86:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e8a:	75 17                	jne    802ea3 <alloc_block_FF+0xf2>
  802e8c:	83 ec 04             	sub    $0x4,%esp
  802e8f:	68 e8 44 80 00       	push   $0x8044e8
  802e94:	68 99 00 00 00       	push   $0x99
  802e99:	68 77 44 80 00       	push   $0x804477
  802e9e:	e8 07 de ff ff       	call   800caa <_panic>
  802ea3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ea6:	8b 00                	mov    (%eax),%eax
  802ea8:	85 c0                	test   %eax,%eax
  802eaa:	74 10                	je     802ebc <alloc_block_FF+0x10b>
  802eac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eaf:	8b 00                	mov    (%eax),%eax
  802eb1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802eb4:	8b 52 04             	mov    0x4(%edx),%edx
  802eb7:	89 50 04             	mov    %edx,0x4(%eax)
  802eba:	eb 0b                	jmp    802ec7 <alloc_block_FF+0x116>
  802ebc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ebf:	8b 40 04             	mov    0x4(%eax),%eax
  802ec2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ec7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eca:	8b 40 04             	mov    0x4(%eax),%eax
  802ecd:	85 c0                	test   %eax,%eax
  802ecf:	74 0f                	je     802ee0 <alloc_block_FF+0x12f>
  802ed1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed4:	8b 40 04             	mov    0x4(%eax),%eax
  802ed7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802eda:	8b 12                	mov    (%edx),%edx
  802edc:	89 10                	mov    %edx,(%eax)
  802ede:	eb 0a                	jmp    802eea <alloc_block_FF+0x139>
  802ee0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ee3:	8b 00                	mov    (%eax),%eax
  802ee5:	a3 48 51 80 00       	mov    %eax,0x805148
  802eea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ef3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802efd:	a1 54 51 80 00       	mov    0x805154,%eax
  802f02:	48                   	dec    %eax
  802f03:	a3 54 51 80 00       	mov    %eax,0x805154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  802f08:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f0c:	75 17                	jne    802f25 <alloc_block_FF+0x174>
  802f0e:	83 ec 04             	sub    $0x4,%esp
  802f11:	68 90 44 80 00       	push   $0x804490
  802f16:	68 9a 00 00 00       	push   $0x9a
  802f1b:	68 77 44 80 00       	push   $0x804477
  802f20:	e8 85 dd ff ff       	call   800caa <_panic>
  802f25:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802f2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f2e:	89 50 04             	mov    %edx,0x4(%eax)
  802f31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f34:	8b 40 04             	mov    0x4(%eax),%eax
  802f37:	85 c0                	test   %eax,%eax
  802f39:	74 0c                	je     802f47 <alloc_block_FF+0x196>
  802f3b:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f40:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f43:	89 10                	mov    %edx,(%eax)
  802f45:	eb 08                	jmp    802f4f <alloc_block_FF+0x19e>
  802f47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f4a:	a3 38 51 80 00       	mov    %eax,0x805138
  802f4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f52:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f5a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f60:	a1 44 51 80 00       	mov    0x805144,%eax
  802f65:	40                   	inc    %eax
  802f66:	a3 44 51 80 00       	mov    %eax,0x805144
		  // setting the size & sva
		  new_block->size=size;
  802f6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f6e:	8b 55 08             	mov    0x8(%ebp),%edx
  802f71:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  802f74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f77:	8b 50 08             	mov    0x8(%eax),%edx
  802f7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f7d:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  802f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f83:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f86:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  802f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8c:	8b 50 08             	mov    0x8(%eax),%edx
  802f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f92:	01 c2                	add    %eax,%edx
  802f94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f97:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  802f9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f9d:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  802fa0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802fa4:	75 17                	jne    802fbd <alloc_block_FF+0x20c>
  802fa6:	83 ec 04             	sub    $0x4,%esp
  802fa9:	68 e8 44 80 00       	push   $0x8044e8
  802fae:	68 a2 00 00 00       	push   $0xa2
  802fb3:	68 77 44 80 00       	push   $0x804477
  802fb8:	e8 ed dc ff ff       	call   800caa <_panic>
  802fbd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fc0:	8b 00                	mov    (%eax),%eax
  802fc2:	85 c0                	test   %eax,%eax
  802fc4:	74 10                	je     802fd6 <alloc_block_FF+0x225>
  802fc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fc9:	8b 00                	mov    (%eax),%eax
  802fcb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802fce:	8b 52 04             	mov    0x4(%edx),%edx
  802fd1:	89 50 04             	mov    %edx,0x4(%eax)
  802fd4:	eb 0b                	jmp    802fe1 <alloc_block_FF+0x230>
  802fd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fd9:	8b 40 04             	mov    0x4(%eax),%eax
  802fdc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fe1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe4:	8b 40 04             	mov    0x4(%eax),%eax
  802fe7:	85 c0                	test   %eax,%eax
  802fe9:	74 0f                	je     802ffa <alloc_block_FF+0x249>
  802feb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fee:	8b 40 04             	mov    0x4(%eax),%eax
  802ff1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ff4:	8b 12                	mov    (%edx),%edx
  802ff6:	89 10                	mov    %edx,(%eax)
  802ff8:	eb 0a                	jmp    803004 <alloc_block_FF+0x253>
  802ffa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ffd:	8b 00                	mov    (%eax),%eax
  802fff:	a3 38 51 80 00       	mov    %eax,0x805138
  803004:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803007:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80300d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803010:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803017:	a1 44 51 80 00       	mov    0x805144,%eax
  80301c:	48                   	dec    %eax
  80301d:	a3 44 51 80 00       	mov    %eax,0x805144
		  return temp;
  803022:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803025:	eb 3b                	jmp    803062 <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  803027:	a1 40 51 80 00       	mov    0x805140,%eax
  80302c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80302f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803033:	74 07                	je     80303c <alloc_block_FF+0x28b>
  803035:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803038:	8b 00                	mov    (%eax),%eax
  80303a:	eb 05                	jmp    803041 <alloc_block_FF+0x290>
  80303c:	b8 00 00 00 00       	mov    $0x0,%eax
  803041:	a3 40 51 80 00       	mov    %eax,0x805140
  803046:	a1 40 51 80 00       	mov    0x805140,%eax
  80304b:	85 c0                	test   %eax,%eax
  80304d:	0f 85 71 fd ff ff    	jne    802dc4 <alloc_block_FF+0x13>
  803053:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803057:	0f 85 67 fd ff ff    	jne    802dc4 <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  80305d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803062:	c9                   	leave  
  803063:	c3                   	ret    

00803064 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  803064:	55                   	push   %ebp
  803065:	89 e5                	mov    %esp,%ebp
  803067:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  80306a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  803071:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  803078:	a1 38 51 80 00       	mov    0x805138,%eax
  80307d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  803080:	e9 d3 00 00 00       	jmp    803158 <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  803085:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803088:	8b 40 0c             	mov    0xc(%eax),%eax
  80308b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80308e:	0f 85 90 00 00 00    	jne    803124 <alloc_block_BF+0xc0>
	   temp = element;
  803094:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803097:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  80309a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80309e:	75 17                	jne    8030b7 <alloc_block_BF+0x53>
  8030a0:	83 ec 04             	sub    $0x4,%esp
  8030a3:	68 e8 44 80 00       	push   $0x8044e8
  8030a8:	68 bd 00 00 00       	push   $0xbd
  8030ad:	68 77 44 80 00       	push   $0x804477
  8030b2:	e8 f3 db ff ff       	call   800caa <_panic>
  8030b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ba:	8b 00                	mov    (%eax),%eax
  8030bc:	85 c0                	test   %eax,%eax
  8030be:	74 10                	je     8030d0 <alloc_block_BF+0x6c>
  8030c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c3:	8b 00                	mov    (%eax),%eax
  8030c5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030c8:	8b 52 04             	mov    0x4(%edx),%edx
  8030cb:	89 50 04             	mov    %edx,0x4(%eax)
  8030ce:	eb 0b                	jmp    8030db <alloc_block_BF+0x77>
  8030d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d3:	8b 40 04             	mov    0x4(%eax),%eax
  8030d6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030de:	8b 40 04             	mov    0x4(%eax),%eax
  8030e1:	85 c0                	test   %eax,%eax
  8030e3:	74 0f                	je     8030f4 <alloc_block_BF+0x90>
  8030e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e8:	8b 40 04             	mov    0x4(%eax),%eax
  8030eb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030ee:	8b 12                	mov    (%edx),%edx
  8030f0:	89 10                	mov    %edx,(%eax)
  8030f2:	eb 0a                	jmp    8030fe <alloc_block_BF+0x9a>
  8030f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f7:	8b 00                	mov    (%eax),%eax
  8030f9:	a3 38 51 80 00       	mov    %eax,0x805138
  8030fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803101:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803107:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80310a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803111:	a1 44 51 80 00       	mov    0x805144,%eax
  803116:	48                   	dec    %eax
  803117:	a3 44 51 80 00       	mov    %eax,0x805144
	   return temp;
  80311c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80311f:	e9 41 01 00 00       	jmp    803265 <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  803124:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803127:	8b 40 0c             	mov    0xc(%eax),%eax
  80312a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80312d:	76 21                	jbe    803150 <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  80312f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803132:	8b 40 0c             	mov    0xc(%eax),%eax
  803135:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803138:	73 16                	jae    803150 <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  80313a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80313d:	8b 40 0c             	mov    0xc(%eax),%eax
  803140:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  803143:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803146:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  803149:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  803150:	a1 40 51 80 00       	mov    0x805140,%eax
  803155:	89 45 e8             	mov    %eax,-0x18(%ebp)
  803158:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80315c:	74 07                	je     803165 <alloc_block_BF+0x101>
  80315e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803161:	8b 00                	mov    (%eax),%eax
  803163:	eb 05                	jmp    80316a <alloc_block_BF+0x106>
  803165:	b8 00 00 00 00       	mov    $0x0,%eax
  80316a:	a3 40 51 80 00       	mov    %eax,0x805140
  80316f:	a1 40 51 80 00       	mov    0x805140,%eax
  803174:	85 c0                	test   %eax,%eax
  803176:	0f 85 09 ff ff ff    	jne    803085 <alloc_block_BF+0x21>
  80317c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803180:	0f 85 ff fe ff ff    	jne    803085 <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  803186:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  80318a:	0f 85 d0 00 00 00    	jne    803260 <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  803190:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803193:	8b 40 0c             	mov    0xc(%eax),%eax
  803196:	2b 45 08             	sub    0x8(%ebp),%eax
  803199:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  80319c:	a1 48 51 80 00       	mov    0x805148,%eax
  8031a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  8031a4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8031a8:	75 17                	jne    8031c1 <alloc_block_BF+0x15d>
  8031aa:	83 ec 04             	sub    $0x4,%esp
  8031ad:	68 e8 44 80 00       	push   $0x8044e8
  8031b2:	68 d1 00 00 00       	push   $0xd1
  8031b7:	68 77 44 80 00       	push   $0x804477
  8031bc:	e8 e9 da ff ff       	call   800caa <_panic>
  8031c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031c4:	8b 00                	mov    (%eax),%eax
  8031c6:	85 c0                	test   %eax,%eax
  8031c8:	74 10                	je     8031da <alloc_block_BF+0x176>
  8031ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031cd:	8b 00                	mov    (%eax),%eax
  8031cf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8031d2:	8b 52 04             	mov    0x4(%edx),%edx
  8031d5:	89 50 04             	mov    %edx,0x4(%eax)
  8031d8:	eb 0b                	jmp    8031e5 <alloc_block_BF+0x181>
  8031da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031dd:	8b 40 04             	mov    0x4(%eax),%eax
  8031e0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031e8:	8b 40 04             	mov    0x4(%eax),%eax
  8031eb:	85 c0                	test   %eax,%eax
  8031ed:	74 0f                	je     8031fe <alloc_block_BF+0x19a>
  8031ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031f2:	8b 40 04             	mov    0x4(%eax),%eax
  8031f5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8031f8:	8b 12                	mov    (%edx),%edx
  8031fa:	89 10                	mov    %edx,(%eax)
  8031fc:	eb 0a                	jmp    803208 <alloc_block_BF+0x1a4>
  8031fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803201:	8b 00                	mov    (%eax),%eax
  803203:	a3 48 51 80 00       	mov    %eax,0x805148
  803208:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80320b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803211:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803214:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80321b:	a1 54 51 80 00       	mov    0x805154,%eax
  803220:	48                   	dec    %eax
  803221:	a3 54 51 80 00       	mov    %eax,0x805154
	  // setting the size & sva
	  new_block->size = size;
  803226:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803229:	8b 55 08             	mov    0x8(%ebp),%edx
  80322c:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  80322f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803232:	8b 50 08             	mov    0x8(%eax),%edx
  803235:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803238:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  80323b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80323e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803241:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  803244:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803247:	8b 50 08             	mov    0x8(%eax),%edx
  80324a:	8b 45 08             	mov    0x8(%ebp),%eax
  80324d:	01 c2                	add    %eax,%edx
  80324f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803252:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  803255:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803258:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  80325b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80325e:	eb 05                	jmp    803265 <alloc_block_BF+0x201>
	 }
	 return NULL;
  803260:	b8 00 00 00 00       	mov    $0x0,%eax


}
  803265:	c9                   	leave  
  803266:	c3                   	ret    

00803267 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  803267:	55                   	push   %ebp
  803268:	89 e5                	mov    %esp,%ebp
  80326a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  80326d:	83 ec 04             	sub    $0x4,%esp
  803270:	68 08 45 80 00       	push   $0x804508
  803275:	68 e8 00 00 00       	push   $0xe8
  80327a:	68 77 44 80 00       	push   $0x804477
  80327f:	e8 26 da ff ff       	call   800caa <_panic>

00803284 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803284:	55                   	push   %ebp
  803285:	89 e5                	mov    %esp,%ebp
  803287:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  80328a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80328f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  803292:	a1 38 51 80 00       	mov    0x805138,%eax
  803297:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  80329a:	a1 44 51 80 00       	mov    0x805144,%eax
  80329f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  8032a2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032a6:	75 68                	jne    803310 <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8032a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032ac:	75 17                	jne    8032c5 <insert_sorted_with_merge_freeList+0x41>
  8032ae:	83 ec 04             	sub    $0x4,%esp
  8032b1:	68 54 44 80 00       	push   $0x804454
  8032b6:	68 36 01 00 00       	push   $0x136
  8032bb:	68 77 44 80 00       	push   $0x804477
  8032c0:	e8 e5 d9 ff ff       	call   800caa <_panic>
  8032c5:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8032cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ce:	89 10                	mov    %edx,(%eax)
  8032d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d3:	8b 00                	mov    (%eax),%eax
  8032d5:	85 c0                	test   %eax,%eax
  8032d7:	74 0d                	je     8032e6 <insert_sorted_with_merge_freeList+0x62>
  8032d9:	a1 38 51 80 00       	mov    0x805138,%eax
  8032de:	8b 55 08             	mov    0x8(%ebp),%edx
  8032e1:	89 50 04             	mov    %edx,0x4(%eax)
  8032e4:	eb 08                	jmp    8032ee <insert_sorted_with_merge_freeList+0x6a>
  8032e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f1:	a3 38 51 80 00       	mov    %eax,0x805138
  8032f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803300:	a1 44 51 80 00       	mov    0x805144,%eax
  803305:	40                   	inc    %eax
  803306:	a3 44 51 80 00       	mov    %eax,0x805144





}
  80330b:	e9 ba 06 00 00       	jmp    8039ca <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  803310:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803313:	8b 50 08             	mov    0x8(%eax),%edx
  803316:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803319:	8b 40 0c             	mov    0xc(%eax),%eax
  80331c:	01 c2                	add    %eax,%edx
  80331e:	8b 45 08             	mov    0x8(%ebp),%eax
  803321:	8b 40 08             	mov    0x8(%eax),%eax
  803324:	39 c2                	cmp    %eax,%edx
  803326:	73 68                	jae    803390 <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803328:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80332c:	75 17                	jne    803345 <insert_sorted_with_merge_freeList+0xc1>
  80332e:	83 ec 04             	sub    $0x4,%esp
  803331:	68 90 44 80 00       	push   $0x804490
  803336:	68 3a 01 00 00       	push   $0x13a
  80333b:	68 77 44 80 00       	push   $0x804477
  803340:	e8 65 d9 ff ff       	call   800caa <_panic>
  803345:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80334b:	8b 45 08             	mov    0x8(%ebp),%eax
  80334e:	89 50 04             	mov    %edx,0x4(%eax)
  803351:	8b 45 08             	mov    0x8(%ebp),%eax
  803354:	8b 40 04             	mov    0x4(%eax),%eax
  803357:	85 c0                	test   %eax,%eax
  803359:	74 0c                	je     803367 <insert_sorted_with_merge_freeList+0xe3>
  80335b:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803360:	8b 55 08             	mov    0x8(%ebp),%edx
  803363:	89 10                	mov    %edx,(%eax)
  803365:	eb 08                	jmp    80336f <insert_sorted_with_merge_freeList+0xeb>
  803367:	8b 45 08             	mov    0x8(%ebp),%eax
  80336a:	a3 38 51 80 00       	mov    %eax,0x805138
  80336f:	8b 45 08             	mov    0x8(%ebp),%eax
  803372:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803377:	8b 45 08             	mov    0x8(%ebp),%eax
  80337a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803380:	a1 44 51 80 00       	mov    0x805144,%eax
  803385:	40                   	inc    %eax
  803386:	a3 44 51 80 00       	mov    %eax,0x805144





}
  80338b:	e9 3a 06 00 00       	jmp    8039ca <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  803390:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803393:	8b 50 08             	mov    0x8(%eax),%edx
  803396:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803399:	8b 40 0c             	mov    0xc(%eax),%eax
  80339c:	01 c2                	add    %eax,%edx
  80339e:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a1:	8b 40 08             	mov    0x8(%eax),%eax
  8033a4:	39 c2                	cmp    %eax,%edx
  8033a6:	0f 85 90 00 00 00    	jne    80343c <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  8033ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033af:	8b 50 0c             	mov    0xc(%eax),%edx
  8033b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8033b8:	01 c2                	add    %eax,%edx
  8033ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033bd:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  8033c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  8033ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8033cd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8033d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033d8:	75 17                	jne    8033f1 <insert_sorted_with_merge_freeList+0x16d>
  8033da:	83 ec 04             	sub    $0x4,%esp
  8033dd:	68 54 44 80 00       	push   $0x804454
  8033e2:	68 41 01 00 00       	push   $0x141
  8033e7:	68 77 44 80 00       	push   $0x804477
  8033ec:	e8 b9 d8 ff ff       	call   800caa <_panic>
  8033f1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fa:	89 10                	mov    %edx,(%eax)
  8033fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ff:	8b 00                	mov    (%eax),%eax
  803401:	85 c0                	test   %eax,%eax
  803403:	74 0d                	je     803412 <insert_sorted_with_merge_freeList+0x18e>
  803405:	a1 48 51 80 00       	mov    0x805148,%eax
  80340a:	8b 55 08             	mov    0x8(%ebp),%edx
  80340d:	89 50 04             	mov    %edx,0x4(%eax)
  803410:	eb 08                	jmp    80341a <insert_sorted_with_merge_freeList+0x196>
  803412:	8b 45 08             	mov    0x8(%ebp),%eax
  803415:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80341a:	8b 45 08             	mov    0x8(%ebp),%eax
  80341d:	a3 48 51 80 00       	mov    %eax,0x805148
  803422:	8b 45 08             	mov    0x8(%ebp),%eax
  803425:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80342c:	a1 54 51 80 00       	mov    0x805154,%eax
  803431:	40                   	inc    %eax
  803432:	a3 54 51 80 00       	mov    %eax,0x805154





}
  803437:	e9 8e 05 00 00       	jmp    8039ca <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  80343c:	8b 45 08             	mov    0x8(%ebp),%eax
  80343f:	8b 50 08             	mov    0x8(%eax),%edx
  803442:	8b 45 08             	mov    0x8(%ebp),%eax
  803445:	8b 40 0c             	mov    0xc(%eax),%eax
  803448:	01 c2                	add    %eax,%edx
  80344a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80344d:	8b 40 08             	mov    0x8(%eax),%eax
  803450:	39 c2                	cmp    %eax,%edx
  803452:	73 68                	jae    8034bc <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  803454:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803458:	75 17                	jne    803471 <insert_sorted_with_merge_freeList+0x1ed>
  80345a:	83 ec 04             	sub    $0x4,%esp
  80345d:	68 54 44 80 00       	push   $0x804454
  803462:	68 45 01 00 00       	push   $0x145
  803467:	68 77 44 80 00       	push   $0x804477
  80346c:	e8 39 d8 ff ff       	call   800caa <_panic>
  803471:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803477:	8b 45 08             	mov    0x8(%ebp),%eax
  80347a:	89 10                	mov    %edx,(%eax)
  80347c:	8b 45 08             	mov    0x8(%ebp),%eax
  80347f:	8b 00                	mov    (%eax),%eax
  803481:	85 c0                	test   %eax,%eax
  803483:	74 0d                	je     803492 <insert_sorted_with_merge_freeList+0x20e>
  803485:	a1 38 51 80 00       	mov    0x805138,%eax
  80348a:	8b 55 08             	mov    0x8(%ebp),%edx
  80348d:	89 50 04             	mov    %edx,0x4(%eax)
  803490:	eb 08                	jmp    80349a <insert_sorted_with_merge_freeList+0x216>
  803492:	8b 45 08             	mov    0x8(%ebp),%eax
  803495:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80349a:	8b 45 08             	mov    0x8(%ebp),%eax
  80349d:	a3 38 51 80 00       	mov    %eax,0x805138
  8034a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034ac:	a1 44 51 80 00       	mov    0x805144,%eax
  8034b1:	40                   	inc    %eax
  8034b2:	a3 44 51 80 00       	mov    %eax,0x805144





}
  8034b7:	e9 0e 05 00 00       	jmp    8039ca <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  8034bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8034bf:	8b 50 08             	mov    0x8(%eax),%edx
  8034c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8034c8:	01 c2                	add    %eax,%edx
  8034ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034cd:	8b 40 08             	mov    0x8(%eax),%eax
  8034d0:	39 c2                	cmp    %eax,%edx
  8034d2:	0f 85 9c 00 00 00    	jne    803574 <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  8034d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034db:	8b 50 0c             	mov    0xc(%eax),%edx
  8034de:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8034e4:	01 c2                	add    %eax,%edx
  8034e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034e9:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  8034ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ef:	8b 50 08             	mov    0x8(%eax),%edx
  8034f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034f5:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  8034f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  803502:	8b 45 08             	mov    0x8(%ebp),%eax
  803505:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80350c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803510:	75 17                	jne    803529 <insert_sorted_with_merge_freeList+0x2a5>
  803512:	83 ec 04             	sub    $0x4,%esp
  803515:	68 54 44 80 00       	push   $0x804454
  80351a:	68 4d 01 00 00       	push   $0x14d
  80351f:	68 77 44 80 00       	push   $0x804477
  803524:	e8 81 d7 ff ff       	call   800caa <_panic>
  803529:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80352f:	8b 45 08             	mov    0x8(%ebp),%eax
  803532:	89 10                	mov    %edx,(%eax)
  803534:	8b 45 08             	mov    0x8(%ebp),%eax
  803537:	8b 00                	mov    (%eax),%eax
  803539:	85 c0                	test   %eax,%eax
  80353b:	74 0d                	je     80354a <insert_sorted_with_merge_freeList+0x2c6>
  80353d:	a1 48 51 80 00       	mov    0x805148,%eax
  803542:	8b 55 08             	mov    0x8(%ebp),%edx
  803545:	89 50 04             	mov    %edx,0x4(%eax)
  803548:	eb 08                	jmp    803552 <insert_sorted_with_merge_freeList+0x2ce>
  80354a:	8b 45 08             	mov    0x8(%ebp),%eax
  80354d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803552:	8b 45 08             	mov    0x8(%ebp),%eax
  803555:	a3 48 51 80 00       	mov    %eax,0x805148
  80355a:	8b 45 08             	mov    0x8(%ebp),%eax
  80355d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803564:	a1 54 51 80 00       	mov    0x805154,%eax
  803569:	40                   	inc    %eax
  80356a:	a3 54 51 80 00       	mov    %eax,0x805154





}
  80356f:	e9 56 04 00 00       	jmp    8039ca <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  803574:	a1 38 51 80 00       	mov    0x805138,%eax
  803579:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80357c:	e9 19 04 00 00       	jmp    80399a <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  803581:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803584:	8b 00                	mov    (%eax),%eax
  803586:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  803589:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80358c:	8b 50 08             	mov    0x8(%eax),%edx
  80358f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803592:	8b 40 0c             	mov    0xc(%eax),%eax
  803595:	01 c2                	add    %eax,%edx
  803597:	8b 45 08             	mov    0x8(%ebp),%eax
  80359a:	8b 40 08             	mov    0x8(%eax),%eax
  80359d:	39 c2                	cmp    %eax,%edx
  80359f:	0f 85 ad 01 00 00    	jne    803752 <insert_sorted_with_merge_freeList+0x4ce>
  8035a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a8:	8b 50 08             	mov    0x8(%eax),%edx
  8035ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8035b1:	01 c2                	add    %eax,%edx
  8035b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035b6:	8b 40 08             	mov    0x8(%eax),%eax
  8035b9:	39 c2                	cmp    %eax,%edx
  8035bb:	0f 85 91 01 00 00    	jne    803752 <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  8035c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c4:	8b 50 0c             	mov    0xc(%eax),%edx
  8035c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ca:	8b 48 0c             	mov    0xc(%eax),%ecx
  8035cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8035d3:	01 c8                	add    %ecx,%eax
  8035d5:	01 c2                	add    %eax,%edx
  8035d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035da:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  8035dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  8035e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ea:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  8035f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035f4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  8035fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035fe:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  803605:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803609:	75 17                	jne    803622 <insert_sorted_with_merge_freeList+0x39e>
  80360b:	83 ec 04             	sub    $0x4,%esp
  80360e:	68 e8 44 80 00       	push   $0x8044e8
  803613:	68 5b 01 00 00       	push   $0x15b
  803618:	68 77 44 80 00       	push   $0x804477
  80361d:	e8 88 d6 ff ff       	call   800caa <_panic>
  803622:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803625:	8b 00                	mov    (%eax),%eax
  803627:	85 c0                	test   %eax,%eax
  803629:	74 10                	je     80363b <insert_sorted_with_merge_freeList+0x3b7>
  80362b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80362e:	8b 00                	mov    (%eax),%eax
  803630:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803633:	8b 52 04             	mov    0x4(%edx),%edx
  803636:	89 50 04             	mov    %edx,0x4(%eax)
  803639:	eb 0b                	jmp    803646 <insert_sorted_with_merge_freeList+0x3c2>
  80363b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80363e:	8b 40 04             	mov    0x4(%eax),%eax
  803641:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803646:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803649:	8b 40 04             	mov    0x4(%eax),%eax
  80364c:	85 c0                	test   %eax,%eax
  80364e:	74 0f                	je     80365f <insert_sorted_with_merge_freeList+0x3db>
  803650:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803653:	8b 40 04             	mov    0x4(%eax),%eax
  803656:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803659:	8b 12                	mov    (%edx),%edx
  80365b:	89 10                	mov    %edx,(%eax)
  80365d:	eb 0a                	jmp    803669 <insert_sorted_with_merge_freeList+0x3e5>
  80365f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803662:	8b 00                	mov    (%eax),%eax
  803664:	a3 38 51 80 00       	mov    %eax,0x805138
  803669:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80366c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803672:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803675:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80367c:	a1 44 51 80 00       	mov    0x805144,%eax
  803681:	48                   	dec    %eax
  803682:	a3 44 51 80 00       	mov    %eax,0x805144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803687:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80368b:	75 17                	jne    8036a4 <insert_sorted_with_merge_freeList+0x420>
  80368d:	83 ec 04             	sub    $0x4,%esp
  803690:	68 54 44 80 00       	push   $0x804454
  803695:	68 5c 01 00 00       	push   $0x15c
  80369a:	68 77 44 80 00       	push   $0x804477
  80369f:	e8 06 d6 ff ff       	call   800caa <_panic>
  8036a4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ad:	89 10                	mov    %edx,(%eax)
  8036af:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b2:	8b 00                	mov    (%eax),%eax
  8036b4:	85 c0                	test   %eax,%eax
  8036b6:	74 0d                	je     8036c5 <insert_sorted_with_merge_freeList+0x441>
  8036b8:	a1 48 51 80 00       	mov    0x805148,%eax
  8036bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8036c0:	89 50 04             	mov    %edx,0x4(%eax)
  8036c3:	eb 08                	jmp    8036cd <insert_sorted_with_merge_freeList+0x449>
  8036c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d0:	a3 48 51 80 00       	mov    %eax,0x805148
  8036d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036df:	a1 54 51 80 00       	mov    0x805154,%eax
  8036e4:	40                   	inc    %eax
  8036e5:	a3 54 51 80 00       	mov    %eax,0x805154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  8036ea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036ee:	75 17                	jne    803707 <insert_sorted_with_merge_freeList+0x483>
  8036f0:	83 ec 04             	sub    $0x4,%esp
  8036f3:	68 54 44 80 00       	push   $0x804454
  8036f8:	68 5d 01 00 00       	push   $0x15d
  8036fd:	68 77 44 80 00       	push   $0x804477
  803702:	e8 a3 d5 ff ff       	call   800caa <_panic>
  803707:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80370d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803710:	89 10                	mov    %edx,(%eax)
  803712:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803715:	8b 00                	mov    (%eax),%eax
  803717:	85 c0                	test   %eax,%eax
  803719:	74 0d                	je     803728 <insert_sorted_with_merge_freeList+0x4a4>
  80371b:	a1 48 51 80 00       	mov    0x805148,%eax
  803720:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803723:	89 50 04             	mov    %edx,0x4(%eax)
  803726:	eb 08                	jmp    803730 <insert_sorted_with_merge_freeList+0x4ac>
  803728:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80372b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803733:	a3 48 51 80 00       	mov    %eax,0x805148
  803738:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80373b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803742:	a1 54 51 80 00       	mov    0x805154,%eax
  803747:	40                   	inc    %eax
  803748:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  80374d:	e9 78 02 00 00       	jmp    8039ca <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  803752:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803755:	8b 50 08             	mov    0x8(%eax),%edx
  803758:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80375b:	8b 40 0c             	mov    0xc(%eax),%eax
  80375e:	01 c2                	add    %eax,%edx
  803760:	8b 45 08             	mov    0x8(%ebp),%eax
  803763:	8b 40 08             	mov    0x8(%eax),%eax
  803766:	39 c2                	cmp    %eax,%edx
  803768:	0f 83 b8 00 00 00    	jae    803826 <insert_sorted_with_merge_freeList+0x5a2>
  80376e:	8b 45 08             	mov    0x8(%ebp),%eax
  803771:	8b 50 08             	mov    0x8(%eax),%edx
  803774:	8b 45 08             	mov    0x8(%ebp),%eax
  803777:	8b 40 0c             	mov    0xc(%eax),%eax
  80377a:	01 c2                	add    %eax,%edx
  80377c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80377f:	8b 40 08             	mov    0x8(%eax),%eax
  803782:	39 c2                	cmp    %eax,%edx
  803784:	0f 85 9c 00 00 00    	jne    803826 <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  80378a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80378d:	8b 50 0c             	mov    0xc(%eax),%edx
  803790:	8b 45 08             	mov    0x8(%ebp),%eax
  803793:	8b 40 0c             	mov    0xc(%eax),%eax
  803796:	01 c2                	add    %eax,%edx
  803798:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80379b:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  80379e:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a1:	8b 50 08             	mov    0x8(%eax),%edx
  8037a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037a7:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  8037aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ad:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  8037b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8037be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037c2:	75 17                	jne    8037db <insert_sorted_with_merge_freeList+0x557>
  8037c4:	83 ec 04             	sub    $0x4,%esp
  8037c7:	68 54 44 80 00       	push   $0x804454
  8037cc:	68 67 01 00 00       	push   $0x167
  8037d1:	68 77 44 80 00       	push   $0x804477
  8037d6:	e8 cf d4 ff ff       	call   800caa <_panic>
  8037db:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8037e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e4:	89 10                	mov    %edx,(%eax)
  8037e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e9:	8b 00                	mov    (%eax),%eax
  8037eb:	85 c0                	test   %eax,%eax
  8037ed:	74 0d                	je     8037fc <insert_sorted_with_merge_freeList+0x578>
  8037ef:	a1 48 51 80 00       	mov    0x805148,%eax
  8037f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8037f7:	89 50 04             	mov    %edx,0x4(%eax)
  8037fa:	eb 08                	jmp    803804 <insert_sorted_with_merge_freeList+0x580>
  8037fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ff:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803804:	8b 45 08             	mov    0x8(%ebp),%eax
  803807:	a3 48 51 80 00       	mov    %eax,0x805148
  80380c:	8b 45 08             	mov    0x8(%ebp),%eax
  80380f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803816:	a1 54 51 80 00       	mov    0x805154,%eax
  80381b:	40                   	inc    %eax
  80381c:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  803821:	e9 a4 01 00 00       	jmp    8039ca <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  803826:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803829:	8b 50 08             	mov    0x8(%eax),%edx
  80382c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80382f:	8b 40 0c             	mov    0xc(%eax),%eax
  803832:	01 c2                	add    %eax,%edx
  803834:	8b 45 08             	mov    0x8(%ebp),%eax
  803837:	8b 40 08             	mov    0x8(%eax),%eax
  80383a:	39 c2                	cmp    %eax,%edx
  80383c:	0f 85 ac 00 00 00    	jne    8038ee <insert_sorted_with_merge_freeList+0x66a>
  803842:	8b 45 08             	mov    0x8(%ebp),%eax
  803845:	8b 50 08             	mov    0x8(%eax),%edx
  803848:	8b 45 08             	mov    0x8(%ebp),%eax
  80384b:	8b 40 0c             	mov    0xc(%eax),%eax
  80384e:	01 c2                	add    %eax,%edx
  803850:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803853:	8b 40 08             	mov    0x8(%eax),%eax
  803856:	39 c2                	cmp    %eax,%edx
  803858:	0f 83 90 00 00 00    	jae    8038ee <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  80385e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803861:	8b 50 0c             	mov    0xc(%eax),%edx
  803864:	8b 45 08             	mov    0x8(%ebp),%eax
  803867:	8b 40 0c             	mov    0xc(%eax),%eax
  80386a:	01 c2                	add    %eax,%edx
  80386c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80386f:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  803872:	8b 45 08             	mov    0x8(%ebp),%eax
  803875:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  80387c:	8b 45 08             	mov    0x8(%ebp),%eax
  80387f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803886:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80388a:	75 17                	jne    8038a3 <insert_sorted_with_merge_freeList+0x61f>
  80388c:	83 ec 04             	sub    $0x4,%esp
  80388f:	68 54 44 80 00       	push   $0x804454
  803894:	68 70 01 00 00       	push   $0x170
  803899:	68 77 44 80 00       	push   $0x804477
  80389e:	e8 07 d4 ff ff       	call   800caa <_panic>
  8038a3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8038a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ac:	89 10                	mov    %edx,(%eax)
  8038ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b1:	8b 00                	mov    (%eax),%eax
  8038b3:	85 c0                	test   %eax,%eax
  8038b5:	74 0d                	je     8038c4 <insert_sorted_with_merge_freeList+0x640>
  8038b7:	a1 48 51 80 00       	mov    0x805148,%eax
  8038bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8038bf:	89 50 04             	mov    %edx,0x4(%eax)
  8038c2:	eb 08                	jmp    8038cc <insert_sorted_with_merge_freeList+0x648>
  8038c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8038cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8038cf:	a3 48 51 80 00       	mov    %eax,0x805148
  8038d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038de:	a1 54 51 80 00       	mov    0x805154,%eax
  8038e3:	40                   	inc    %eax
  8038e4:	a3 54 51 80 00       	mov    %eax,0x805154
	      break;
  8038e9:	e9 dc 00 00 00       	jmp    8039ca <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  8038ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038f1:	8b 50 08             	mov    0x8(%eax),%edx
  8038f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8038fa:	01 c2                	add    %eax,%edx
  8038fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ff:	8b 40 08             	mov    0x8(%eax),%eax
  803902:	39 c2                	cmp    %eax,%edx
  803904:	0f 83 88 00 00 00    	jae    803992 <insert_sorted_with_merge_freeList+0x70e>
  80390a:	8b 45 08             	mov    0x8(%ebp),%eax
  80390d:	8b 50 08             	mov    0x8(%eax),%edx
  803910:	8b 45 08             	mov    0x8(%ebp),%eax
  803913:	8b 40 0c             	mov    0xc(%eax),%eax
  803916:	01 c2                	add    %eax,%edx
  803918:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80391b:	8b 40 08             	mov    0x8(%eax),%eax
  80391e:	39 c2                	cmp    %eax,%edx
  803920:	73 70                	jae    803992 <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  803922:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803926:	74 06                	je     80392e <insert_sorted_with_merge_freeList+0x6aa>
  803928:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80392c:	75 17                	jne    803945 <insert_sorted_with_merge_freeList+0x6c1>
  80392e:	83 ec 04             	sub    $0x4,%esp
  803931:	68 b4 44 80 00       	push   $0x8044b4
  803936:	68 75 01 00 00       	push   $0x175
  80393b:	68 77 44 80 00       	push   $0x804477
  803940:	e8 65 d3 ff ff       	call   800caa <_panic>
  803945:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803948:	8b 10                	mov    (%eax),%edx
  80394a:	8b 45 08             	mov    0x8(%ebp),%eax
  80394d:	89 10                	mov    %edx,(%eax)
  80394f:	8b 45 08             	mov    0x8(%ebp),%eax
  803952:	8b 00                	mov    (%eax),%eax
  803954:	85 c0                	test   %eax,%eax
  803956:	74 0b                	je     803963 <insert_sorted_with_merge_freeList+0x6df>
  803958:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80395b:	8b 00                	mov    (%eax),%eax
  80395d:	8b 55 08             	mov    0x8(%ebp),%edx
  803960:	89 50 04             	mov    %edx,0x4(%eax)
  803963:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803966:	8b 55 08             	mov    0x8(%ebp),%edx
  803969:	89 10                	mov    %edx,(%eax)
  80396b:	8b 45 08             	mov    0x8(%ebp),%eax
  80396e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803971:	89 50 04             	mov    %edx,0x4(%eax)
  803974:	8b 45 08             	mov    0x8(%ebp),%eax
  803977:	8b 00                	mov    (%eax),%eax
  803979:	85 c0                	test   %eax,%eax
  80397b:	75 08                	jne    803985 <insert_sorted_with_merge_freeList+0x701>
  80397d:	8b 45 08             	mov    0x8(%ebp),%eax
  803980:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803985:	a1 44 51 80 00       	mov    0x805144,%eax
  80398a:	40                   	inc    %eax
  80398b:	a3 44 51 80 00       	mov    %eax,0x805144
	      break;
  803990:	eb 38                	jmp    8039ca <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  803992:	a1 40 51 80 00       	mov    0x805140,%eax
  803997:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80399a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80399e:	74 07                	je     8039a7 <insert_sorted_with_merge_freeList+0x723>
  8039a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039a3:	8b 00                	mov    (%eax),%eax
  8039a5:	eb 05                	jmp    8039ac <insert_sorted_with_merge_freeList+0x728>
  8039a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8039ac:	a3 40 51 80 00       	mov    %eax,0x805140
  8039b1:	a1 40 51 80 00       	mov    0x805140,%eax
  8039b6:	85 c0                	test   %eax,%eax
  8039b8:	0f 85 c3 fb ff ff    	jne    803581 <insert_sorted_with_merge_freeList+0x2fd>
  8039be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039c2:	0f 85 b9 fb ff ff    	jne    803581 <insert_sorted_with_merge_freeList+0x2fd>





}
  8039c8:	eb 00                	jmp    8039ca <insert_sorted_with_merge_freeList+0x746>
  8039ca:	90                   	nop
  8039cb:	c9                   	leave  
  8039cc:	c3                   	ret    
  8039cd:	66 90                	xchg   %ax,%ax
  8039cf:	90                   	nop

008039d0 <__udivdi3>:
  8039d0:	55                   	push   %ebp
  8039d1:	57                   	push   %edi
  8039d2:	56                   	push   %esi
  8039d3:	53                   	push   %ebx
  8039d4:	83 ec 1c             	sub    $0x1c,%esp
  8039d7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8039db:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8039df:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039e3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8039e7:	89 ca                	mov    %ecx,%edx
  8039e9:	89 f8                	mov    %edi,%eax
  8039eb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8039ef:	85 f6                	test   %esi,%esi
  8039f1:	75 2d                	jne    803a20 <__udivdi3+0x50>
  8039f3:	39 cf                	cmp    %ecx,%edi
  8039f5:	77 65                	ja     803a5c <__udivdi3+0x8c>
  8039f7:	89 fd                	mov    %edi,%ebp
  8039f9:	85 ff                	test   %edi,%edi
  8039fb:	75 0b                	jne    803a08 <__udivdi3+0x38>
  8039fd:	b8 01 00 00 00       	mov    $0x1,%eax
  803a02:	31 d2                	xor    %edx,%edx
  803a04:	f7 f7                	div    %edi
  803a06:	89 c5                	mov    %eax,%ebp
  803a08:	31 d2                	xor    %edx,%edx
  803a0a:	89 c8                	mov    %ecx,%eax
  803a0c:	f7 f5                	div    %ebp
  803a0e:	89 c1                	mov    %eax,%ecx
  803a10:	89 d8                	mov    %ebx,%eax
  803a12:	f7 f5                	div    %ebp
  803a14:	89 cf                	mov    %ecx,%edi
  803a16:	89 fa                	mov    %edi,%edx
  803a18:	83 c4 1c             	add    $0x1c,%esp
  803a1b:	5b                   	pop    %ebx
  803a1c:	5e                   	pop    %esi
  803a1d:	5f                   	pop    %edi
  803a1e:	5d                   	pop    %ebp
  803a1f:	c3                   	ret    
  803a20:	39 ce                	cmp    %ecx,%esi
  803a22:	77 28                	ja     803a4c <__udivdi3+0x7c>
  803a24:	0f bd fe             	bsr    %esi,%edi
  803a27:	83 f7 1f             	xor    $0x1f,%edi
  803a2a:	75 40                	jne    803a6c <__udivdi3+0x9c>
  803a2c:	39 ce                	cmp    %ecx,%esi
  803a2e:	72 0a                	jb     803a3a <__udivdi3+0x6a>
  803a30:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a34:	0f 87 9e 00 00 00    	ja     803ad8 <__udivdi3+0x108>
  803a3a:	b8 01 00 00 00       	mov    $0x1,%eax
  803a3f:	89 fa                	mov    %edi,%edx
  803a41:	83 c4 1c             	add    $0x1c,%esp
  803a44:	5b                   	pop    %ebx
  803a45:	5e                   	pop    %esi
  803a46:	5f                   	pop    %edi
  803a47:	5d                   	pop    %ebp
  803a48:	c3                   	ret    
  803a49:	8d 76 00             	lea    0x0(%esi),%esi
  803a4c:	31 ff                	xor    %edi,%edi
  803a4e:	31 c0                	xor    %eax,%eax
  803a50:	89 fa                	mov    %edi,%edx
  803a52:	83 c4 1c             	add    $0x1c,%esp
  803a55:	5b                   	pop    %ebx
  803a56:	5e                   	pop    %esi
  803a57:	5f                   	pop    %edi
  803a58:	5d                   	pop    %ebp
  803a59:	c3                   	ret    
  803a5a:	66 90                	xchg   %ax,%ax
  803a5c:	89 d8                	mov    %ebx,%eax
  803a5e:	f7 f7                	div    %edi
  803a60:	31 ff                	xor    %edi,%edi
  803a62:	89 fa                	mov    %edi,%edx
  803a64:	83 c4 1c             	add    $0x1c,%esp
  803a67:	5b                   	pop    %ebx
  803a68:	5e                   	pop    %esi
  803a69:	5f                   	pop    %edi
  803a6a:	5d                   	pop    %ebp
  803a6b:	c3                   	ret    
  803a6c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a71:	89 eb                	mov    %ebp,%ebx
  803a73:	29 fb                	sub    %edi,%ebx
  803a75:	89 f9                	mov    %edi,%ecx
  803a77:	d3 e6                	shl    %cl,%esi
  803a79:	89 c5                	mov    %eax,%ebp
  803a7b:	88 d9                	mov    %bl,%cl
  803a7d:	d3 ed                	shr    %cl,%ebp
  803a7f:	89 e9                	mov    %ebp,%ecx
  803a81:	09 f1                	or     %esi,%ecx
  803a83:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a87:	89 f9                	mov    %edi,%ecx
  803a89:	d3 e0                	shl    %cl,%eax
  803a8b:	89 c5                	mov    %eax,%ebp
  803a8d:	89 d6                	mov    %edx,%esi
  803a8f:	88 d9                	mov    %bl,%cl
  803a91:	d3 ee                	shr    %cl,%esi
  803a93:	89 f9                	mov    %edi,%ecx
  803a95:	d3 e2                	shl    %cl,%edx
  803a97:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a9b:	88 d9                	mov    %bl,%cl
  803a9d:	d3 e8                	shr    %cl,%eax
  803a9f:	09 c2                	or     %eax,%edx
  803aa1:	89 d0                	mov    %edx,%eax
  803aa3:	89 f2                	mov    %esi,%edx
  803aa5:	f7 74 24 0c          	divl   0xc(%esp)
  803aa9:	89 d6                	mov    %edx,%esi
  803aab:	89 c3                	mov    %eax,%ebx
  803aad:	f7 e5                	mul    %ebp
  803aaf:	39 d6                	cmp    %edx,%esi
  803ab1:	72 19                	jb     803acc <__udivdi3+0xfc>
  803ab3:	74 0b                	je     803ac0 <__udivdi3+0xf0>
  803ab5:	89 d8                	mov    %ebx,%eax
  803ab7:	31 ff                	xor    %edi,%edi
  803ab9:	e9 58 ff ff ff       	jmp    803a16 <__udivdi3+0x46>
  803abe:	66 90                	xchg   %ax,%ax
  803ac0:	8b 54 24 08          	mov    0x8(%esp),%edx
  803ac4:	89 f9                	mov    %edi,%ecx
  803ac6:	d3 e2                	shl    %cl,%edx
  803ac8:	39 c2                	cmp    %eax,%edx
  803aca:	73 e9                	jae    803ab5 <__udivdi3+0xe5>
  803acc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803acf:	31 ff                	xor    %edi,%edi
  803ad1:	e9 40 ff ff ff       	jmp    803a16 <__udivdi3+0x46>
  803ad6:	66 90                	xchg   %ax,%ax
  803ad8:	31 c0                	xor    %eax,%eax
  803ada:	e9 37 ff ff ff       	jmp    803a16 <__udivdi3+0x46>
  803adf:	90                   	nop

00803ae0 <__umoddi3>:
  803ae0:	55                   	push   %ebp
  803ae1:	57                   	push   %edi
  803ae2:	56                   	push   %esi
  803ae3:	53                   	push   %ebx
  803ae4:	83 ec 1c             	sub    $0x1c,%esp
  803ae7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803aeb:	8b 74 24 34          	mov    0x34(%esp),%esi
  803aef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803af3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803af7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803afb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803aff:	89 f3                	mov    %esi,%ebx
  803b01:	89 fa                	mov    %edi,%edx
  803b03:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b07:	89 34 24             	mov    %esi,(%esp)
  803b0a:	85 c0                	test   %eax,%eax
  803b0c:	75 1a                	jne    803b28 <__umoddi3+0x48>
  803b0e:	39 f7                	cmp    %esi,%edi
  803b10:	0f 86 a2 00 00 00    	jbe    803bb8 <__umoddi3+0xd8>
  803b16:	89 c8                	mov    %ecx,%eax
  803b18:	89 f2                	mov    %esi,%edx
  803b1a:	f7 f7                	div    %edi
  803b1c:	89 d0                	mov    %edx,%eax
  803b1e:	31 d2                	xor    %edx,%edx
  803b20:	83 c4 1c             	add    $0x1c,%esp
  803b23:	5b                   	pop    %ebx
  803b24:	5e                   	pop    %esi
  803b25:	5f                   	pop    %edi
  803b26:	5d                   	pop    %ebp
  803b27:	c3                   	ret    
  803b28:	39 f0                	cmp    %esi,%eax
  803b2a:	0f 87 ac 00 00 00    	ja     803bdc <__umoddi3+0xfc>
  803b30:	0f bd e8             	bsr    %eax,%ebp
  803b33:	83 f5 1f             	xor    $0x1f,%ebp
  803b36:	0f 84 ac 00 00 00    	je     803be8 <__umoddi3+0x108>
  803b3c:	bf 20 00 00 00       	mov    $0x20,%edi
  803b41:	29 ef                	sub    %ebp,%edi
  803b43:	89 fe                	mov    %edi,%esi
  803b45:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b49:	89 e9                	mov    %ebp,%ecx
  803b4b:	d3 e0                	shl    %cl,%eax
  803b4d:	89 d7                	mov    %edx,%edi
  803b4f:	89 f1                	mov    %esi,%ecx
  803b51:	d3 ef                	shr    %cl,%edi
  803b53:	09 c7                	or     %eax,%edi
  803b55:	89 e9                	mov    %ebp,%ecx
  803b57:	d3 e2                	shl    %cl,%edx
  803b59:	89 14 24             	mov    %edx,(%esp)
  803b5c:	89 d8                	mov    %ebx,%eax
  803b5e:	d3 e0                	shl    %cl,%eax
  803b60:	89 c2                	mov    %eax,%edx
  803b62:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b66:	d3 e0                	shl    %cl,%eax
  803b68:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b6c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b70:	89 f1                	mov    %esi,%ecx
  803b72:	d3 e8                	shr    %cl,%eax
  803b74:	09 d0                	or     %edx,%eax
  803b76:	d3 eb                	shr    %cl,%ebx
  803b78:	89 da                	mov    %ebx,%edx
  803b7a:	f7 f7                	div    %edi
  803b7c:	89 d3                	mov    %edx,%ebx
  803b7e:	f7 24 24             	mull   (%esp)
  803b81:	89 c6                	mov    %eax,%esi
  803b83:	89 d1                	mov    %edx,%ecx
  803b85:	39 d3                	cmp    %edx,%ebx
  803b87:	0f 82 87 00 00 00    	jb     803c14 <__umoddi3+0x134>
  803b8d:	0f 84 91 00 00 00    	je     803c24 <__umoddi3+0x144>
  803b93:	8b 54 24 04          	mov    0x4(%esp),%edx
  803b97:	29 f2                	sub    %esi,%edx
  803b99:	19 cb                	sbb    %ecx,%ebx
  803b9b:	89 d8                	mov    %ebx,%eax
  803b9d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803ba1:	d3 e0                	shl    %cl,%eax
  803ba3:	89 e9                	mov    %ebp,%ecx
  803ba5:	d3 ea                	shr    %cl,%edx
  803ba7:	09 d0                	or     %edx,%eax
  803ba9:	89 e9                	mov    %ebp,%ecx
  803bab:	d3 eb                	shr    %cl,%ebx
  803bad:	89 da                	mov    %ebx,%edx
  803baf:	83 c4 1c             	add    $0x1c,%esp
  803bb2:	5b                   	pop    %ebx
  803bb3:	5e                   	pop    %esi
  803bb4:	5f                   	pop    %edi
  803bb5:	5d                   	pop    %ebp
  803bb6:	c3                   	ret    
  803bb7:	90                   	nop
  803bb8:	89 fd                	mov    %edi,%ebp
  803bba:	85 ff                	test   %edi,%edi
  803bbc:	75 0b                	jne    803bc9 <__umoddi3+0xe9>
  803bbe:	b8 01 00 00 00       	mov    $0x1,%eax
  803bc3:	31 d2                	xor    %edx,%edx
  803bc5:	f7 f7                	div    %edi
  803bc7:	89 c5                	mov    %eax,%ebp
  803bc9:	89 f0                	mov    %esi,%eax
  803bcb:	31 d2                	xor    %edx,%edx
  803bcd:	f7 f5                	div    %ebp
  803bcf:	89 c8                	mov    %ecx,%eax
  803bd1:	f7 f5                	div    %ebp
  803bd3:	89 d0                	mov    %edx,%eax
  803bd5:	e9 44 ff ff ff       	jmp    803b1e <__umoddi3+0x3e>
  803bda:	66 90                	xchg   %ax,%ax
  803bdc:	89 c8                	mov    %ecx,%eax
  803bde:	89 f2                	mov    %esi,%edx
  803be0:	83 c4 1c             	add    $0x1c,%esp
  803be3:	5b                   	pop    %ebx
  803be4:	5e                   	pop    %esi
  803be5:	5f                   	pop    %edi
  803be6:	5d                   	pop    %ebp
  803be7:	c3                   	ret    
  803be8:	3b 04 24             	cmp    (%esp),%eax
  803beb:	72 06                	jb     803bf3 <__umoddi3+0x113>
  803bed:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803bf1:	77 0f                	ja     803c02 <__umoddi3+0x122>
  803bf3:	89 f2                	mov    %esi,%edx
  803bf5:	29 f9                	sub    %edi,%ecx
  803bf7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803bfb:	89 14 24             	mov    %edx,(%esp)
  803bfe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c02:	8b 44 24 04          	mov    0x4(%esp),%eax
  803c06:	8b 14 24             	mov    (%esp),%edx
  803c09:	83 c4 1c             	add    $0x1c,%esp
  803c0c:	5b                   	pop    %ebx
  803c0d:	5e                   	pop    %esi
  803c0e:	5f                   	pop    %edi
  803c0f:	5d                   	pop    %ebp
  803c10:	c3                   	ret    
  803c11:	8d 76 00             	lea    0x0(%esi),%esi
  803c14:	2b 04 24             	sub    (%esp),%eax
  803c17:	19 fa                	sbb    %edi,%edx
  803c19:	89 d1                	mov    %edx,%ecx
  803c1b:	89 c6                	mov    %eax,%esi
  803c1d:	e9 71 ff ff ff       	jmp    803b93 <__umoddi3+0xb3>
  803c22:	66 90                	xchg   %ax,%ax
  803c24:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803c28:	72 ea                	jb     803c14 <__umoddi3+0x134>
  803c2a:	89 d9                	mov    %ebx,%ecx
  803c2c:	e9 62 ff ff ff       	jmp    803b93 <__umoddi3+0xb3>
