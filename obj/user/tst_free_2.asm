
obj/user/tst_free_2:     file format elf32-i386


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
  800031:	e8 43 09 00 00       	call   800979 <libmain>
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
  80003c:	81 ec d4 00 00 00    	sub    $0xd4,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800042:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800046:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004d:	eb 29                	jmp    800078 <_main+0x40>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004f:	a1 20 50 80 00       	mov    0x805020,%eax
  800054:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80005a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005d:	89 d0                	mov    %edx,%eax
  80005f:	01 c0                	add    %eax,%eax
  800061:	01 d0                	add    %edx,%eax
  800063:	c1 e0 03             	shl    $0x3,%eax
  800066:	01 c8                	add    %ecx,%eax
  800068:	8a 40 04             	mov    0x4(%eax),%al
  80006b:	84 c0                	test   %al,%al
  80006d:	74 06                	je     800075 <_main+0x3d>
			{
				fullWS = 0;
  80006f:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800073:	eb 12                	jmp    800087 <_main+0x4f>
{

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800075:	ff 45 f0             	incl   -0x10(%ebp)
  800078:	a1 20 50 80 00       	mov    0x805020,%eax
  80007d:	8b 50 74             	mov    0x74(%eax),%edx
  800080:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800083:	39 c2                	cmp    %eax,%edx
  800085:	77 c8                	ja     80004f <_main+0x17>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800087:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  80008b:	74 14                	je     8000a1 <_main+0x69>
  80008d:	83 ec 04             	sub    $0x4,%esp
  800090:	68 40 3a 80 00       	push   $0x803a40
  800095:	6a 14                	push   $0x14
  800097:	68 5c 3a 80 00       	push   $0x803a5c
  80009c:	e8 14 0a 00 00       	call   800ab5 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	6a 00                	push   $0x0
  8000a6:	e8 37 1c 00 00       	call   801ce2 <malloc>
  8000ab:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/
	//Bypass the PAGE FAULT on <MOVB immediate, reg> instruction by setting its length
	//and continue executing the remaining code
	sys_bypassPageFault(3);
  8000ae:	83 ec 0c             	sub    $0xc,%esp
  8000b1:	6a 03                	push   $0x3
  8000b3:	e8 01 24 00 00       	call   8024b9 <sys_bypassPageFault>
  8000b8:	83 c4 10             	add    $0x10,%esp





	int Mega = 1024*1024;
  8000bb:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000c2:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)

	int start_freeFrames = sys_calculate_free_frames() ;
  8000c9:	e8 53 20 00 00       	call   802121 <sys_calculate_free_frames>
  8000ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	//ALLOCATE ALL
	void* ptr_allocations[20] = {0};
  8000d1:	8d 55 80             	lea    -0x80(%ebp),%edx
  8000d4:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8000de:	89 d7                	mov    %edx,%edi
  8000e0:	f3 ab                	rep stos %eax,%es:(%edi)
	int lastIndices[20] = {0};
  8000e2:	8d 95 30 ff ff ff    	lea    -0xd0(%ebp),%edx
  8000e8:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f2:	89 d7                	mov    %edx,%edi
  8000f4:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000f6:	e8 26 20 00 00       	call   802121 <sys_calculate_free_frames>
  8000fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000fe:	e8 be 20 00 00       	call   8021c1 <sys_pf_calculate_allocated_pages>
  800103:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800106:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800109:	01 c0                	add    %eax,%eax
  80010b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	50                   	push   %eax
  800112:	e8 cb 1b 00 00       	call   801ce2 <malloc>
  800117:	83 c4 10             	add    $0x10,%esp
  80011a:	89 45 80             	mov    %eax,-0x80(%ebp)
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80011d:	8b 45 80             	mov    -0x80(%ebp),%eax
  800120:	85 c0                	test   %eax,%eax
  800122:	78 14                	js     800138 <_main+0x100>
  800124:	83 ec 04             	sub    $0x4,%esp
  800127:	68 70 3a 80 00       	push   $0x803a70
  80012c:	6a 2d                	push   $0x2d
  80012e:	68 5c 3a 80 00       	push   $0x803a5c
  800133:	e8 7d 09 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800138:	e8 84 20 00 00       	call   8021c1 <sys_pf_calculate_allocated_pages>
  80013d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800140:	74 14                	je     800156 <_main+0x11e>
  800142:	83 ec 04             	sub    $0x4,%esp
  800145:	68 d8 3a 80 00       	push   $0x803ad8
  80014a:	6a 2e                	push   $0x2e
  80014c:	68 5c 3a 80 00       	push   $0x803a5c
  800151:	e8 5f 09 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		lastIndices[0] = (2*Mega-kilo)/sizeof(char) - 1;
  800156:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800159:	01 c0                	add    %eax,%eax
  80015b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80015e:	48                   	dec    %eax
  80015f:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  800165:	e8 b7 1f 00 00       	call   802121 <sys_calculate_free_frames>
  80016a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80016d:	e8 4f 20 00 00       	call   8021c1 <sys_pf_calculate_allocated_pages>
  800172:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800175:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800178:	01 c0                	add    %eax,%eax
  80017a:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80017d:	83 ec 0c             	sub    $0xc,%esp
  800180:	50                   	push   %eax
  800181:	e8 5c 1b 00 00       	call   801ce2 <malloc>
  800186:	83 c4 10             	add    $0x10,%esp
  800189:	89 45 84             	mov    %eax,-0x7c(%ebp)
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80018c:	8b 45 84             	mov    -0x7c(%ebp),%eax
  80018f:	89 c2                	mov    %eax,%edx
  800191:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800194:	01 c0                	add    %eax,%eax
  800196:	05 00 00 00 80       	add    $0x80000000,%eax
  80019b:	39 c2                	cmp    %eax,%edx
  80019d:	73 14                	jae    8001b3 <_main+0x17b>
  80019f:	83 ec 04             	sub    $0x4,%esp
  8001a2:	68 70 3a 80 00       	push   $0x803a70
  8001a7:	6a 35                	push   $0x35
  8001a9:	68 5c 3a 80 00       	push   $0x803a5c
  8001ae:	e8 02 09 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8001b3:	e8 09 20 00 00       	call   8021c1 <sys_pf_calculate_allocated_pages>
  8001b8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8001bb:	74 14                	je     8001d1 <_main+0x199>
  8001bd:	83 ec 04             	sub    $0x4,%esp
  8001c0:	68 d8 3a 80 00       	push   $0x803ad8
  8001c5:	6a 36                	push   $0x36
  8001c7:	68 5c 3a 80 00       	push   $0x803a5c
  8001cc:	e8 e4 08 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		lastIndices[1] = (2*Mega-kilo)/sizeof(char) - 1;
  8001d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001d4:	01 c0                	add    %eax,%eax
  8001d6:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8001d9:	48                   	dec    %eax
  8001da:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  8001e0:	e8 3c 1f 00 00       	call   802121 <sys_calculate_free_frames>
  8001e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001e8:	e8 d4 1f 00 00       	call   8021c1 <sys_pf_calculate_allocated_pages>
  8001ed:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  8001f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001f3:	01 c0                	add    %eax,%eax
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	50                   	push   %eax
  8001f9:	e8 e4 1a 00 00       	call   801ce2 <malloc>
  8001fe:	83 c4 10             	add    $0x10,%esp
  800201:	89 45 88             	mov    %eax,-0x78(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800204:	8b 45 88             	mov    -0x78(%ebp),%eax
  800207:	89 c2                	mov    %eax,%edx
  800209:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80020c:	c1 e0 02             	shl    $0x2,%eax
  80020f:	05 00 00 00 80       	add    $0x80000000,%eax
  800214:	39 c2                	cmp    %eax,%edx
  800216:	73 14                	jae    80022c <_main+0x1f4>
  800218:	83 ec 04             	sub    $0x4,%esp
  80021b:	68 70 3a 80 00       	push   $0x803a70
  800220:	6a 3d                	push   $0x3d
  800222:	68 5c 3a 80 00       	push   $0x803a5c
  800227:	e8 89 08 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  80022c:	e8 90 1f 00 00       	call   8021c1 <sys_pf_calculate_allocated_pages>
  800231:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800234:	74 14                	je     80024a <_main+0x212>
  800236:	83 ec 04             	sub    $0x4,%esp
  800239:	68 d8 3a 80 00       	push   $0x803ad8
  80023e:	6a 3e                	push   $0x3e
  800240:	68 5c 3a 80 00       	push   $0x803a5c
  800245:	e8 6b 08 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		lastIndices[2] = (2*kilo)/sizeof(char) - 1;
  80024a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80024d:	01 c0                	add    %eax,%eax
  80024f:	48                   	dec    %eax
  800250:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  800256:	e8 c6 1e 00 00       	call   802121 <sys_calculate_free_frames>
  80025b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80025e:	e8 5e 1f 00 00       	call   8021c1 <sys_pf_calculate_allocated_pages>
  800263:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  800266:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800269:	01 c0                	add    %eax,%eax
  80026b:	83 ec 0c             	sub    $0xc,%esp
  80026e:	50                   	push   %eax
  80026f:	e8 6e 1a 00 00       	call   801ce2 <malloc>
  800274:	83 c4 10             	add    $0x10,%esp
  800277:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80027a:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80027d:	89 c2                	mov    %eax,%edx
  80027f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800282:	c1 e0 02             	shl    $0x2,%eax
  800285:	89 c1                	mov    %eax,%ecx
  800287:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80028a:	c1 e0 02             	shl    $0x2,%eax
  80028d:	01 c8                	add    %ecx,%eax
  80028f:	05 00 00 00 80       	add    $0x80000000,%eax
  800294:	39 c2                	cmp    %eax,%edx
  800296:	73 14                	jae    8002ac <_main+0x274>
  800298:	83 ec 04             	sub    $0x4,%esp
  80029b:	68 70 3a 80 00       	push   $0x803a70
  8002a0:	6a 45                	push   $0x45
  8002a2:	68 5c 3a 80 00       	push   $0x803a5c
  8002a7:	e8 09 08 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8002ac:	e8 10 1f 00 00       	call   8021c1 <sys_pf_calculate_allocated_pages>
  8002b1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002b4:	74 14                	je     8002ca <_main+0x292>
  8002b6:	83 ec 04             	sub    $0x4,%esp
  8002b9:	68 d8 3a 80 00       	push   $0x803ad8
  8002be:	6a 46                	push   $0x46
  8002c0:	68 5c 3a 80 00       	push   $0x803a5c
  8002c5:	e8 eb 07 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		lastIndices[3] = (2*kilo)/sizeof(char) - 1;
  8002ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002cd:	01 c0                	add    %eax,%eax
  8002cf:	48                   	dec    %eax
  8002d0:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  8002d6:	e8 46 1e 00 00       	call   802121 <sys_calculate_free_frames>
  8002db:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002de:	e8 de 1e 00 00       	call   8021c1 <sys_pf_calculate_allocated_pages>
  8002e3:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  8002e6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002e9:	89 d0                	mov    %edx,%eax
  8002eb:	01 c0                	add    %eax,%eax
  8002ed:	01 d0                	add    %edx,%eax
  8002ef:	01 c0                	add    %eax,%eax
  8002f1:	01 d0                	add    %edx,%eax
  8002f3:	83 ec 0c             	sub    $0xc,%esp
  8002f6:	50                   	push   %eax
  8002f7:	e8 e6 19 00 00       	call   801ce2 <malloc>
  8002fc:	83 c4 10             	add    $0x10,%esp
  8002ff:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800302:	8b 45 90             	mov    -0x70(%ebp),%eax
  800305:	89 c2                	mov    %eax,%edx
  800307:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80030a:	c1 e0 02             	shl    $0x2,%eax
  80030d:	89 c1                	mov    %eax,%ecx
  80030f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800312:	c1 e0 03             	shl    $0x3,%eax
  800315:	01 c8                	add    %ecx,%eax
  800317:	05 00 00 00 80       	add    $0x80000000,%eax
  80031c:	39 c2                	cmp    %eax,%edx
  80031e:	73 14                	jae    800334 <_main+0x2fc>
  800320:	83 ec 04             	sub    $0x4,%esp
  800323:	68 70 3a 80 00       	push   $0x803a70
  800328:	6a 4d                	push   $0x4d
  80032a:	68 5c 3a 80 00       	push   $0x803a5c
  80032f:	e8 81 07 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800334:	e8 88 1e 00 00       	call   8021c1 <sys_pf_calculate_allocated_pages>
  800339:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80033c:	74 14                	je     800352 <_main+0x31a>
  80033e:	83 ec 04             	sub    $0x4,%esp
  800341:	68 d8 3a 80 00       	push   $0x803ad8
  800346:	6a 4e                	push   $0x4e
  800348:	68 5c 3a 80 00       	push   $0x803a5c
  80034d:	e8 63 07 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		lastIndices[4] = (7*kilo)/sizeof(char) - 1;
  800352:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800355:	89 d0                	mov    %edx,%eax
  800357:	01 c0                	add    %eax,%eax
  800359:	01 d0                	add    %edx,%eax
  80035b:	01 c0                	add    %eax,%eax
  80035d:	01 d0                	add    %edx,%eax
  80035f:	48                   	dec    %eax
  800360:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  800366:	e8 b6 1d 00 00       	call   802121 <sys_calculate_free_frames>
  80036b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80036e:	e8 4e 1e 00 00       	call   8021c1 <sys_pf_calculate_allocated_pages>
  800373:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  800376:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800379:	89 c2                	mov    %eax,%edx
  80037b:	01 d2                	add    %edx,%edx
  80037d:	01 d0                	add    %edx,%eax
  80037f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800382:	83 ec 0c             	sub    $0xc,%esp
  800385:	50                   	push   %eax
  800386:	e8 57 19 00 00       	call   801ce2 <malloc>
  80038b:	83 c4 10             	add    $0x10,%esp
  80038e:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800391:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800394:	89 c2                	mov    %eax,%edx
  800396:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800399:	c1 e0 02             	shl    $0x2,%eax
  80039c:	89 c1                	mov    %eax,%ecx
  80039e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003a1:	c1 e0 04             	shl    $0x4,%eax
  8003a4:	01 c8                	add    %ecx,%eax
  8003a6:	05 00 00 00 80       	add    $0x80000000,%eax
  8003ab:	39 c2                	cmp    %eax,%edx
  8003ad:	73 14                	jae    8003c3 <_main+0x38b>
  8003af:	83 ec 04             	sub    $0x4,%esp
  8003b2:	68 70 3a 80 00       	push   $0x803a70
  8003b7:	6a 55                	push   $0x55
  8003b9:	68 5c 3a 80 00       	push   $0x803a5c
  8003be:	e8 f2 06 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8003c3:	e8 f9 1d 00 00       	call   8021c1 <sys_pf_calculate_allocated_pages>
  8003c8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003cb:	74 14                	je     8003e1 <_main+0x3a9>
  8003cd:	83 ec 04             	sub    $0x4,%esp
  8003d0:	68 d8 3a 80 00       	push   $0x803ad8
  8003d5:	6a 56                	push   $0x56
  8003d7:	68 5c 3a 80 00       	push   $0x803a5c
  8003dc:	e8 d4 06 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		lastIndices[5] = (3*Mega - kilo)/sizeof(char) - 1;
  8003e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003e4:	89 c2                	mov    %eax,%edx
  8003e6:	01 d2                	add    %edx,%edx
  8003e8:	01 d0                	add    %edx,%eax
  8003ea:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003ed:	48                   	dec    %eax
  8003ee:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  8003f4:	e8 28 1d 00 00       	call   802121 <sys_calculate_free_frames>
  8003f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003fc:	e8 c0 1d 00 00       	call   8021c1 <sys_pf_calculate_allocated_pages>
  800401:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[6] = malloc(2*Mega-kilo);
  800404:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800407:	01 c0                	add    %eax,%eax
  800409:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80040c:	83 ec 0c             	sub    $0xc,%esp
  80040f:	50                   	push   %eax
  800410:	e8 cd 18 00 00       	call   801ce2 <malloc>
  800415:	83 c4 10             	add    $0x10,%esp
  800418:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80041b:	8b 45 98             	mov    -0x68(%ebp),%eax
  80041e:	89 c1                	mov    %eax,%ecx
  800420:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800423:	89 d0                	mov    %edx,%eax
  800425:	01 c0                	add    %eax,%eax
  800427:	01 d0                	add    %edx,%eax
  800429:	01 c0                	add    %eax,%eax
  80042b:	01 d0                	add    %edx,%eax
  80042d:	89 c2                	mov    %eax,%edx
  80042f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800432:	c1 e0 04             	shl    $0x4,%eax
  800435:	01 d0                	add    %edx,%eax
  800437:	05 00 00 00 80       	add    $0x80000000,%eax
  80043c:	39 c1                	cmp    %eax,%ecx
  80043e:	73 14                	jae    800454 <_main+0x41c>
  800440:	83 ec 04             	sub    $0x4,%esp
  800443:	68 70 3a 80 00       	push   $0x803a70
  800448:	6a 5d                	push   $0x5d
  80044a:	68 5c 3a 80 00       	push   $0x803a5c
  80044f:	e8 61 06 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800454:	e8 68 1d 00 00       	call   8021c1 <sys_pf_calculate_allocated_pages>
  800459:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80045c:	74 14                	je     800472 <_main+0x43a>
  80045e:	83 ec 04             	sub    $0x4,%esp
  800461:	68 d8 3a 80 00       	push   $0x803ad8
  800466:	6a 5e                	push   $0x5e
  800468:	68 5c 3a 80 00       	push   $0x803a5c
  80046d:	e8 43 06 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		lastIndices[6] = (2*Mega - kilo)/sizeof(char) - 1;
  800472:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800475:	01 c0                	add    %eax,%eax
  800477:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80047a:	48                   	dec    %eax
  80047b:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
	char x ;
	int y;
	char *byteArr ;
	//FREE ALL
	{
		int freeFrames = sys_calculate_free_frames() ;
  800481:	e8 9b 1c 00 00       	call   802121 <sys_calculate_free_frames>
  800486:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800489:	e8 33 1d 00 00       	call   8021c1 <sys_pf_calculate_allocated_pages>
  80048e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[0]);
  800491:	8b 45 80             	mov    -0x80(%ebp),%eax
  800494:	83 ec 0c             	sub    $0xc,%esp
  800497:	50                   	push   %eax
  800498:	e8 dc 18 00 00       	call   801d79 <free>
  80049d:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8004a0:	e8 1c 1d 00 00       	call   8021c1 <sys_pf_calculate_allocated_pages>
  8004a5:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8004a8:	74 14                	je     8004be <_main+0x486>
  8004aa:	83 ec 04             	sub    $0x4,%esp
  8004ad:	68 08 3b 80 00       	push   $0x803b08
  8004b2:	6a 6b                	push   $0x6b
  8004b4:	68 5c 3a 80 00       	push   $0x803a5c
  8004b9:	e8 f7 05 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 512 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[0];
  8004be:	8b 45 80             	mov    -0x80(%ebp),%eax
  8004c1:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8004c4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004c7:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  8004ca:	e8 d1 1f 00 00       	call   8024a0 <sys_rcr2>
  8004cf:	89 c2                	mov    %eax,%edx
  8004d1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004d4:	39 c2                	cmp    %eax,%edx
  8004d6:	74 14                	je     8004ec <_main+0x4b4>
  8004d8:	83 ec 04             	sub    $0x4,%esp
  8004db:	68 44 3b 80 00       	push   $0x803b44
  8004e0:	6a 6f                	push   $0x6f
  8004e2:	68 5c 3a 80 00       	push   $0x803a5c
  8004e7:	e8 c9 05 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[0]] = 10;
  8004ec:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  8004f2:	89 c2                	mov    %eax,%edx
  8004f4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004f7:	01 d0                	add    %edx,%eax
  8004f9:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[0]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8004fc:	e8 9f 1f 00 00       	call   8024a0 <sys_rcr2>
  800501:	8b 95 30 ff ff ff    	mov    -0xd0(%ebp),%edx
  800507:	89 d1                	mov    %edx,%ecx
  800509:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80050c:	01 ca                	add    %ecx,%edx
  80050e:	39 d0                	cmp    %edx,%eax
  800510:	74 14                	je     800526 <_main+0x4ee>
  800512:	83 ec 04             	sub    $0x4,%esp
  800515:	68 44 3b 80 00       	push   $0x803b44
  80051a:	6a 71                	push   $0x71
  80051c:	68 5c 3a 80 00       	push   $0x803a5c
  800521:	e8 8f 05 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800526:	e8 f6 1b 00 00       	call   802121 <sys_calculate_free_frames>
  80052b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80052e:	e8 8e 1c 00 00       	call   8021c1 <sys_pf_calculate_allocated_pages>
  800533:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[1]);
  800536:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800539:	83 ec 0c             	sub    $0xc,%esp
  80053c:	50                   	push   %eax
  80053d:	e8 37 18 00 00       	call   801d79 <free>
  800542:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800545:	e8 77 1c 00 00       	call   8021c1 <sys_pf_calculate_allocated_pages>
  80054a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80054d:	74 14                	je     800563 <_main+0x52b>
  80054f:	83 ec 04             	sub    $0x4,%esp
  800552:	68 08 3b 80 00       	push   $0x803b08
  800557:	6a 76                	push   $0x76
  800559:	68 5c 3a 80 00       	push   $0x803a5c
  80055e:	e8 52 05 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 512 + 1 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[1];
  800563:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800566:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  800569:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80056c:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  80056f:	e8 2c 1f 00 00       	call   8024a0 <sys_rcr2>
  800574:	89 c2                	mov    %eax,%edx
  800576:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800579:	39 c2                	cmp    %eax,%edx
  80057b:	74 14                	je     800591 <_main+0x559>
  80057d:	83 ec 04             	sub    $0x4,%esp
  800580:	68 44 3b 80 00       	push   $0x803b44
  800585:	6a 7a                	push   $0x7a
  800587:	68 5c 3a 80 00       	push   $0x803a5c
  80058c:	e8 24 05 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[1]] = 10;
  800591:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800597:	89 c2                	mov    %eax,%edx
  800599:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80059c:	01 d0                	add    %edx,%eax
  80059e:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[1]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8005a1:	e8 fa 1e 00 00       	call   8024a0 <sys_rcr2>
  8005a6:	8b 95 34 ff ff ff    	mov    -0xcc(%ebp),%edx
  8005ac:	89 d1                	mov    %edx,%ecx
  8005ae:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005b1:	01 ca                	add    %ecx,%edx
  8005b3:	39 d0                	cmp    %edx,%eax
  8005b5:	74 14                	je     8005cb <_main+0x593>
  8005b7:	83 ec 04             	sub    $0x4,%esp
  8005ba:	68 44 3b 80 00       	push   $0x803b44
  8005bf:	6a 7c                	push   $0x7c
  8005c1:	68 5c 3a 80 00       	push   $0x803a5c
  8005c6:	e8 ea 04 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8005cb:	e8 51 1b 00 00       	call   802121 <sys_calculate_free_frames>
  8005d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005d3:	e8 e9 1b 00 00       	call   8021c1 <sys_pf_calculate_allocated_pages>
  8005d8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[2]);
  8005db:	8b 45 88             	mov    -0x78(%ebp),%eax
  8005de:	83 ec 0c             	sub    $0xc,%esp
  8005e1:	50                   	push   %eax
  8005e2:	e8 92 17 00 00       	call   801d79 <free>
  8005e7:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8005ea:	e8 d2 1b 00 00       	call   8021c1 <sys_pf_calculate_allocated_pages>
  8005ef:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8005f2:	74 17                	je     80060b <_main+0x5d3>
  8005f4:	83 ec 04             	sub    $0x4,%esp
  8005f7:	68 08 3b 80 00       	push   $0x803b08
  8005fc:	68 81 00 00 00       	push   $0x81
  800601:	68 5c 3a 80 00       	push   $0x803a5c
  800606:	e8 aa 04 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 1 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[2];
  80060b:	8b 45 88             	mov    -0x78(%ebp),%eax
  80060e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  800611:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800614:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800617:	e8 84 1e 00 00       	call   8024a0 <sys_rcr2>
  80061c:	89 c2                	mov    %eax,%edx
  80061e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800621:	39 c2                	cmp    %eax,%edx
  800623:	74 17                	je     80063c <_main+0x604>
  800625:	83 ec 04             	sub    $0x4,%esp
  800628:	68 44 3b 80 00       	push   $0x803b44
  80062d:	68 85 00 00 00       	push   $0x85
  800632:	68 5c 3a 80 00       	push   $0x803a5c
  800637:	e8 79 04 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[2]] = 10;
  80063c:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800642:	89 c2                	mov    %eax,%edx
  800644:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800647:	01 d0                	add    %edx,%eax
  800649:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[2]])) panic("Free: successful access to freed space!! it should not be succeeded");
  80064c:	e8 4f 1e 00 00       	call   8024a0 <sys_rcr2>
  800651:	8b 95 38 ff ff ff    	mov    -0xc8(%ebp),%edx
  800657:	89 d1                	mov    %edx,%ecx
  800659:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80065c:	01 ca                	add    %ecx,%edx
  80065e:	39 d0                	cmp    %edx,%eax
  800660:	74 17                	je     800679 <_main+0x641>
  800662:	83 ec 04             	sub    $0x4,%esp
  800665:	68 44 3b 80 00       	push   $0x803b44
  80066a:	68 87 00 00 00       	push   $0x87
  80066f:	68 5c 3a 80 00       	push   $0x803a5c
  800674:	e8 3c 04 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800679:	e8 a3 1a 00 00       	call   802121 <sys_calculate_free_frames>
  80067e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800681:	e8 3b 1b 00 00       	call   8021c1 <sys_pf_calculate_allocated_pages>
  800686:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[3]);
  800689:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80068c:	83 ec 0c             	sub    $0xc,%esp
  80068f:	50                   	push   %eax
  800690:	e8 e4 16 00 00       	call   801d79 <free>
  800695:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800698:	e8 24 1b 00 00       	call   8021c1 <sys_pf_calculate_allocated_pages>
  80069d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8006a0:	74 17                	je     8006b9 <_main+0x681>
  8006a2:	83 ec 04             	sub    $0x4,%esp
  8006a5:	68 08 3b 80 00       	push   $0x803b08
  8006aa:	68 8c 00 00 00       	push   $0x8c
  8006af:	68 5c 3a 80 00       	push   $0x803a5c
  8006b4:	e8 fc 03 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 1 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[3];
  8006b9:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8006bf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006c2:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  8006c5:	e8 d6 1d 00 00       	call   8024a0 <sys_rcr2>
  8006ca:	89 c2                	mov    %eax,%edx
  8006cc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006cf:	39 c2                	cmp    %eax,%edx
  8006d1:	74 17                	je     8006ea <_main+0x6b2>
  8006d3:	83 ec 04             	sub    $0x4,%esp
  8006d6:	68 44 3b 80 00       	push   $0x803b44
  8006db:	68 90 00 00 00       	push   $0x90
  8006e0:	68 5c 3a 80 00       	push   $0x803a5c
  8006e5:	e8 cb 03 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[3]] = 10;
  8006ea:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  8006f0:	89 c2                	mov    %eax,%edx
  8006f2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006f5:	01 d0                	add    %edx,%eax
  8006f7:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[3]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8006fa:	e8 a1 1d 00 00       	call   8024a0 <sys_rcr2>
  8006ff:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
  800705:	89 d1                	mov    %edx,%ecx
  800707:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80070a:	01 ca                	add    %ecx,%edx
  80070c:	39 d0                	cmp    %edx,%eax
  80070e:	74 17                	je     800727 <_main+0x6ef>
  800710:	83 ec 04             	sub    $0x4,%esp
  800713:	68 44 3b 80 00       	push   $0x803b44
  800718:	68 92 00 00 00       	push   $0x92
  80071d:	68 5c 3a 80 00       	push   $0x803a5c
  800722:	e8 8e 03 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800727:	e8 f5 19 00 00       	call   802121 <sys_calculate_free_frames>
  80072c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80072f:	e8 8d 1a 00 00       	call   8021c1 <sys_pf_calculate_allocated_pages>
  800734:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[4]);
  800737:	8b 45 90             	mov    -0x70(%ebp),%eax
  80073a:	83 ec 0c             	sub    $0xc,%esp
  80073d:	50                   	push   %eax
  80073e:	e8 36 16 00 00       	call   801d79 <free>
  800743:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800746:	e8 76 1a 00 00       	call   8021c1 <sys_pf_calculate_allocated_pages>
  80074b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80074e:	74 17                	je     800767 <_main+0x72f>
  800750:	83 ec 04             	sub    $0x4,%esp
  800753:	68 08 3b 80 00       	push   $0x803b08
  800758:	68 97 00 00 00       	push   $0x97
  80075d:	68 5c 3a 80 00       	push   $0x803a5c
  800762:	e8 4e 03 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[4];
  800767:	8b 45 90             	mov    -0x70(%ebp),%eax
  80076a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  80076d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800770:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800773:	e8 28 1d 00 00       	call   8024a0 <sys_rcr2>
  800778:	89 c2                	mov    %eax,%edx
  80077a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80077d:	39 c2                	cmp    %eax,%edx
  80077f:	74 17                	je     800798 <_main+0x760>
  800781:	83 ec 04             	sub    $0x4,%esp
  800784:	68 44 3b 80 00       	push   $0x803b44
  800789:	68 9b 00 00 00       	push   $0x9b
  80078e:	68 5c 3a 80 00       	push   $0x803a5c
  800793:	e8 1d 03 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[4]] = 10;
  800798:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  80079e:	89 c2                	mov    %eax,%edx
  8007a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007a3:	01 d0                	add    %edx,%eax
  8007a5:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[4]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8007a8:	e8 f3 1c 00 00       	call   8024a0 <sys_rcr2>
  8007ad:	8b 95 40 ff ff ff    	mov    -0xc0(%ebp),%edx
  8007b3:	89 d1                	mov    %edx,%ecx
  8007b5:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8007b8:	01 ca                	add    %ecx,%edx
  8007ba:	39 d0                	cmp    %edx,%eax
  8007bc:	74 17                	je     8007d5 <_main+0x79d>
  8007be:	83 ec 04             	sub    $0x4,%esp
  8007c1:	68 44 3b 80 00       	push   $0x803b44
  8007c6:	68 9d 00 00 00       	push   $0x9d
  8007cb:	68 5c 3a 80 00       	push   $0x803a5c
  8007d0:	e8 e0 02 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8007d5:	e8 47 19 00 00       	call   802121 <sys_calculate_free_frames>
  8007da:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8007dd:	e8 df 19 00 00       	call   8021c1 <sys_pf_calculate_allocated_pages>
  8007e2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[5]);
  8007e5:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8007e8:	83 ec 0c             	sub    $0xc,%esp
  8007eb:	50                   	push   %eax
  8007ec:	e8 88 15 00 00       	call   801d79 <free>
  8007f1:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0 ) panic("Wrong free: Extra or less pages are removed from PageFile");
  8007f4:	e8 c8 19 00 00       	call   8021c1 <sys_pf_calculate_allocated_pages>
  8007f9:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8007fc:	74 17                	je     800815 <_main+0x7dd>
  8007fe:	83 ec 04             	sub    $0x4,%esp
  800801:	68 08 3b 80 00       	push   $0x803b08
  800806:	68 a2 00 00 00       	push   $0xa2
  80080b:	68 5c 3a 80 00       	push   $0x803a5c
  800810:	e8 a0 02 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 3*Mega/4096 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[5];
  800815:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800818:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  80081b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80081e:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800821:	e8 7a 1c 00 00       	call   8024a0 <sys_rcr2>
  800826:	89 c2                	mov    %eax,%edx
  800828:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80082b:	39 c2                	cmp    %eax,%edx
  80082d:	74 17                	je     800846 <_main+0x80e>
  80082f:	83 ec 04             	sub    $0x4,%esp
  800832:	68 44 3b 80 00       	push   $0x803b44
  800837:	68 a6 00 00 00       	push   $0xa6
  80083c:	68 5c 3a 80 00       	push   $0x803a5c
  800841:	e8 6f 02 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[5]] = 10;
  800846:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  80084c:	89 c2                	mov    %eax,%edx
  80084e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800851:	01 d0                	add    %edx,%eax
  800853:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[5]])) panic("Free: successful access to freed space!! it should not be succeeded");
  800856:	e8 45 1c 00 00       	call   8024a0 <sys_rcr2>
  80085b:	8b 95 44 ff ff ff    	mov    -0xbc(%ebp),%edx
  800861:	89 d1                	mov    %edx,%ecx
  800863:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800866:	01 ca                	add    %ecx,%edx
  800868:	39 d0                	cmp    %edx,%eax
  80086a:	74 17                	je     800883 <_main+0x84b>
  80086c:	83 ec 04             	sub    $0x4,%esp
  80086f:	68 44 3b 80 00       	push   $0x803b44
  800874:	68 a8 00 00 00       	push   $0xa8
  800879:	68 5c 3a 80 00       	push   $0x803a5c
  80087e:	e8 32 02 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800883:	e8 99 18 00 00       	call   802121 <sys_calculate_free_frames>
  800888:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80088b:	e8 31 19 00 00       	call   8021c1 <sys_pf_calculate_allocated_pages>
  800890:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[6]);
  800893:	8b 45 98             	mov    -0x68(%ebp),%eax
  800896:	83 ec 0c             	sub    $0xc,%esp
  800899:	50                   	push   %eax
  80089a:	e8 da 14 00 00       	call   801d79 <free>
  80089f:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8008a2:	e8 1a 19 00 00       	call   8021c1 <sys_pf_calculate_allocated_pages>
  8008a7:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8008aa:	74 17                	je     8008c3 <_main+0x88b>
  8008ac:	83 ec 04             	sub    $0x4,%esp
  8008af:	68 08 3b 80 00       	push   $0x803b08
  8008b4:	68 ad 00 00 00       	push   $0xad
  8008b9:	68 5c 3a 80 00       	push   $0x803a5c
  8008be:	e8 f2 01 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 512 + 2) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[6];
  8008c3:	8b 45 98             	mov    -0x68(%ebp),%eax
  8008c6:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8008c9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008cc:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  8008cf:	e8 cc 1b 00 00       	call   8024a0 <sys_rcr2>
  8008d4:	89 c2                	mov    %eax,%edx
  8008d6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008d9:	39 c2                	cmp    %eax,%edx
  8008db:	74 17                	je     8008f4 <_main+0x8bc>
  8008dd:	83 ec 04             	sub    $0x4,%esp
  8008e0:	68 44 3b 80 00       	push   $0x803b44
  8008e5:	68 b1 00 00 00       	push   $0xb1
  8008ea:	68 5c 3a 80 00       	push   $0x803a5c
  8008ef:	e8 c1 01 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[6]] = 10;
  8008f4:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  8008fa:	89 c2                	mov    %eax,%edx
  8008fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008ff:	01 d0                	add    %edx,%eax
  800901:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[6]])) panic("Free: successful access to freed space!! it should not be succeeded");
  800904:	e8 97 1b 00 00       	call   8024a0 <sys_rcr2>
  800909:	8b 95 48 ff ff ff    	mov    -0xb8(%ebp),%edx
  80090f:	89 d1                	mov    %edx,%ecx
  800911:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800914:	01 ca                	add    %ecx,%edx
  800916:	39 d0                	cmp    %edx,%eax
  800918:	74 17                	je     800931 <_main+0x8f9>
  80091a:	83 ec 04             	sub    $0x4,%esp
  80091d:	68 44 3b 80 00       	push   $0x803b44
  800922:	68 b3 00 00 00       	push   $0xb3
  800927:	68 5c 3a 80 00       	push   $0x803a5c
  80092c:	e8 84 01 00 00       	call   800ab5 <_panic>

		if(start_freeFrames != (sys_calculate_free_frames()) ) {panic("Wrong free: not all pages removed correctly at end");}
  800931:	e8 eb 17 00 00       	call   802121 <sys_calculate_free_frames>
  800936:	89 c2                	mov    %eax,%edx
  800938:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80093b:	39 c2                	cmp    %eax,%edx
  80093d:	74 17                	je     800956 <_main+0x91e>
  80093f:	83 ec 04             	sub    $0x4,%esp
  800942:	68 88 3b 80 00       	push   $0x803b88
  800947:	68 b5 00 00 00       	push   $0xb5
  80094c:	68 5c 3a 80 00       	push   $0x803a5c
  800951:	e8 5f 01 00 00       	call   800ab5 <_panic>
	}

	//set it to 0 again to cancel the bypassing option
	sys_bypassPageFault(0);
  800956:	83 ec 0c             	sub    $0xc,%esp
  800959:	6a 00                	push   $0x0
  80095b:	e8 59 1b 00 00       	call   8024b9 <sys_bypassPageFault>
  800960:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! test free [2] completed successfully.\n");
  800963:	83 ec 0c             	sub    $0xc,%esp
  800966:	68 bc 3b 80 00       	push   $0x803bbc
  80096b:	e8 f9 03 00 00       	call   800d69 <cprintf>
  800970:	83 c4 10             	add    $0x10,%esp

	return;
  800973:	90                   	nop
}
  800974:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800977:	c9                   	leave  
  800978:	c3                   	ret    

00800979 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800979:	55                   	push   %ebp
  80097a:	89 e5                	mov    %esp,%ebp
  80097c:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80097f:	e8 7d 1a 00 00       	call   802401 <sys_getenvindex>
  800984:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800987:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80098a:	89 d0                	mov    %edx,%eax
  80098c:	c1 e0 03             	shl    $0x3,%eax
  80098f:	01 d0                	add    %edx,%eax
  800991:	01 c0                	add    %eax,%eax
  800993:	01 d0                	add    %edx,%eax
  800995:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80099c:	01 d0                	add    %edx,%eax
  80099e:	c1 e0 04             	shl    $0x4,%eax
  8009a1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8009a6:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8009ab:	a1 20 50 80 00       	mov    0x805020,%eax
  8009b0:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8009b6:	84 c0                	test   %al,%al
  8009b8:	74 0f                	je     8009c9 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8009ba:	a1 20 50 80 00       	mov    0x805020,%eax
  8009bf:	05 5c 05 00 00       	add    $0x55c,%eax
  8009c4:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8009c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009cd:	7e 0a                	jle    8009d9 <libmain+0x60>
		binaryname = argv[0];
  8009cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d2:	8b 00                	mov    (%eax),%eax
  8009d4:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8009d9:	83 ec 08             	sub    $0x8,%esp
  8009dc:	ff 75 0c             	pushl  0xc(%ebp)
  8009df:	ff 75 08             	pushl  0x8(%ebp)
  8009e2:	e8 51 f6 ff ff       	call   800038 <_main>
  8009e7:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8009ea:	e8 1f 18 00 00       	call   80220e <sys_disable_interrupt>
	cprintf("**************************************\n");
  8009ef:	83 ec 0c             	sub    $0xc,%esp
  8009f2:	68 10 3c 80 00       	push   $0x803c10
  8009f7:	e8 6d 03 00 00       	call   800d69 <cprintf>
  8009fc:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8009ff:	a1 20 50 80 00       	mov    0x805020,%eax
  800a04:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800a0a:	a1 20 50 80 00       	mov    0x805020,%eax
  800a0f:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800a15:	83 ec 04             	sub    $0x4,%esp
  800a18:	52                   	push   %edx
  800a19:	50                   	push   %eax
  800a1a:	68 38 3c 80 00       	push   $0x803c38
  800a1f:	e8 45 03 00 00       	call   800d69 <cprintf>
  800a24:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800a27:	a1 20 50 80 00       	mov    0x805020,%eax
  800a2c:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800a32:	a1 20 50 80 00       	mov    0x805020,%eax
  800a37:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800a3d:	a1 20 50 80 00       	mov    0x805020,%eax
  800a42:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800a48:	51                   	push   %ecx
  800a49:	52                   	push   %edx
  800a4a:	50                   	push   %eax
  800a4b:	68 60 3c 80 00       	push   $0x803c60
  800a50:	e8 14 03 00 00       	call   800d69 <cprintf>
  800a55:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800a58:	a1 20 50 80 00       	mov    0x805020,%eax
  800a5d:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800a63:	83 ec 08             	sub    $0x8,%esp
  800a66:	50                   	push   %eax
  800a67:	68 b8 3c 80 00       	push   $0x803cb8
  800a6c:	e8 f8 02 00 00       	call   800d69 <cprintf>
  800a71:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800a74:	83 ec 0c             	sub    $0xc,%esp
  800a77:	68 10 3c 80 00       	push   $0x803c10
  800a7c:	e8 e8 02 00 00       	call   800d69 <cprintf>
  800a81:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800a84:	e8 9f 17 00 00       	call   802228 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800a89:	e8 19 00 00 00       	call   800aa7 <exit>
}
  800a8e:	90                   	nop
  800a8f:	c9                   	leave  
  800a90:	c3                   	ret    

00800a91 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800a91:	55                   	push   %ebp
  800a92:	89 e5                	mov    %esp,%ebp
  800a94:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800a97:	83 ec 0c             	sub    $0xc,%esp
  800a9a:	6a 00                	push   $0x0
  800a9c:	e8 2c 19 00 00       	call   8023cd <sys_destroy_env>
  800aa1:	83 c4 10             	add    $0x10,%esp
}
  800aa4:	90                   	nop
  800aa5:	c9                   	leave  
  800aa6:	c3                   	ret    

00800aa7 <exit>:

void
exit(void)
{
  800aa7:	55                   	push   %ebp
  800aa8:	89 e5                	mov    %esp,%ebp
  800aaa:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800aad:	e8 81 19 00 00       	call   802433 <sys_exit_env>
}
  800ab2:	90                   	nop
  800ab3:	c9                   	leave  
  800ab4:	c3                   	ret    

00800ab5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800ab5:	55                   	push   %ebp
  800ab6:	89 e5                	mov    %esp,%ebp
  800ab8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800abb:	8d 45 10             	lea    0x10(%ebp),%eax
  800abe:	83 c0 04             	add    $0x4,%eax
  800ac1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800ac4:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800ac9:	85 c0                	test   %eax,%eax
  800acb:	74 16                	je     800ae3 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800acd:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800ad2:	83 ec 08             	sub    $0x8,%esp
  800ad5:	50                   	push   %eax
  800ad6:	68 cc 3c 80 00       	push   $0x803ccc
  800adb:	e8 89 02 00 00       	call   800d69 <cprintf>
  800ae0:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800ae3:	a1 00 50 80 00       	mov    0x805000,%eax
  800ae8:	ff 75 0c             	pushl  0xc(%ebp)
  800aeb:	ff 75 08             	pushl  0x8(%ebp)
  800aee:	50                   	push   %eax
  800aef:	68 d1 3c 80 00       	push   $0x803cd1
  800af4:	e8 70 02 00 00       	call   800d69 <cprintf>
  800af9:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800afc:	8b 45 10             	mov    0x10(%ebp),%eax
  800aff:	83 ec 08             	sub    $0x8,%esp
  800b02:	ff 75 f4             	pushl  -0xc(%ebp)
  800b05:	50                   	push   %eax
  800b06:	e8 f3 01 00 00       	call   800cfe <vcprintf>
  800b0b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800b0e:	83 ec 08             	sub    $0x8,%esp
  800b11:	6a 00                	push   $0x0
  800b13:	68 ed 3c 80 00       	push   $0x803ced
  800b18:	e8 e1 01 00 00       	call   800cfe <vcprintf>
  800b1d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800b20:	e8 82 ff ff ff       	call   800aa7 <exit>

	// should not return here
	while (1) ;
  800b25:	eb fe                	jmp    800b25 <_panic+0x70>

00800b27 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800b27:	55                   	push   %ebp
  800b28:	89 e5                	mov    %esp,%ebp
  800b2a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800b2d:	a1 20 50 80 00       	mov    0x805020,%eax
  800b32:	8b 50 74             	mov    0x74(%eax),%edx
  800b35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b38:	39 c2                	cmp    %eax,%edx
  800b3a:	74 14                	je     800b50 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800b3c:	83 ec 04             	sub    $0x4,%esp
  800b3f:	68 f0 3c 80 00       	push   $0x803cf0
  800b44:	6a 26                	push   $0x26
  800b46:	68 3c 3d 80 00       	push   $0x803d3c
  800b4b:	e8 65 ff ff ff       	call   800ab5 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800b50:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800b57:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b5e:	e9 c2 00 00 00       	jmp    800c25 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800b63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b66:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b70:	01 d0                	add    %edx,%eax
  800b72:	8b 00                	mov    (%eax),%eax
  800b74:	85 c0                	test   %eax,%eax
  800b76:	75 08                	jne    800b80 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800b78:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800b7b:	e9 a2 00 00 00       	jmp    800c22 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800b80:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b87:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800b8e:	eb 69                	jmp    800bf9 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800b90:	a1 20 50 80 00       	mov    0x805020,%eax
  800b95:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b9b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b9e:	89 d0                	mov    %edx,%eax
  800ba0:	01 c0                	add    %eax,%eax
  800ba2:	01 d0                	add    %edx,%eax
  800ba4:	c1 e0 03             	shl    $0x3,%eax
  800ba7:	01 c8                	add    %ecx,%eax
  800ba9:	8a 40 04             	mov    0x4(%eax),%al
  800bac:	84 c0                	test   %al,%al
  800bae:	75 46                	jne    800bf6 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800bb0:	a1 20 50 80 00       	mov    0x805020,%eax
  800bb5:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800bbb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800bbe:	89 d0                	mov    %edx,%eax
  800bc0:	01 c0                	add    %eax,%eax
  800bc2:	01 d0                	add    %edx,%eax
  800bc4:	c1 e0 03             	shl    $0x3,%eax
  800bc7:	01 c8                	add    %ecx,%eax
  800bc9:	8b 00                	mov    (%eax),%eax
  800bcb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800bce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800bd1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bd6:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800bd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bdb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800be2:	8b 45 08             	mov    0x8(%ebp),%eax
  800be5:	01 c8                	add    %ecx,%eax
  800be7:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800be9:	39 c2                	cmp    %eax,%edx
  800beb:	75 09                	jne    800bf6 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800bed:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800bf4:	eb 12                	jmp    800c08 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800bf6:	ff 45 e8             	incl   -0x18(%ebp)
  800bf9:	a1 20 50 80 00       	mov    0x805020,%eax
  800bfe:	8b 50 74             	mov    0x74(%eax),%edx
  800c01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800c04:	39 c2                	cmp    %eax,%edx
  800c06:	77 88                	ja     800b90 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800c08:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800c0c:	75 14                	jne    800c22 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800c0e:	83 ec 04             	sub    $0x4,%esp
  800c11:	68 48 3d 80 00       	push   $0x803d48
  800c16:	6a 3a                	push   $0x3a
  800c18:	68 3c 3d 80 00       	push   $0x803d3c
  800c1d:	e8 93 fe ff ff       	call   800ab5 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800c22:	ff 45 f0             	incl   -0x10(%ebp)
  800c25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c28:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800c2b:	0f 8c 32 ff ff ff    	jl     800b63 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800c31:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800c38:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800c3f:	eb 26                	jmp    800c67 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800c41:	a1 20 50 80 00       	mov    0x805020,%eax
  800c46:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800c4c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c4f:	89 d0                	mov    %edx,%eax
  800c51:	01 c0                	add    %eax,%eax
  800c53:	01 d0                	add    %edx,%eax
  800c55:	c1 e0 03             	shl    $0x3,%eax
  800c58:	01 c8                	add    %ecx,%eax
  800c5a:	8a 40 04             	mov    0x4(%eax),%al
  800c5d:	3c 01                	cmp    $0x1,%al
  800c5f:	75 03                	jne    800c64 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800c61:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800c64:	ff 45 e0             	incl   -0x20(%ebp)
  800c67:	a1 20 50 80 00       	mov    0x805020,%eax
  800c6c:	8b 50 74             	mov    0x74(%eax),%edx
  800c6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c72:	39 c2                	cmp    %eax,%edx
  800c74:	77 cb                	ja     800c41 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c79:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800c7c:	74 14                	je     800c92 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800c7e:	83 ec 04             	sub    $0x4,%esp
  800c81:	68 9c 3d 80 00       	push   $0x803d9c
  800c86:	6a 44                	push   $0x44
  800c88:	68 3c 3d 80 00       	push   $0x803d3c
  800c8d:	e8 23 fe ff ff       	call   800ab5 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800c92:	90                   	nop
  800c93:	c9                   	leave  
  800c94:	c3                   	ret    

00800c95 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800c95:	55                   	push   %ebp
  800c96:	89 e5                	mov    %esp,%ebp
  800c98:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800c9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9e:	8b 00                	mov    (%eax),%eax
  800ca0:	8d 48 01             	lea    0x1(%eax),%ecx
  800ca3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca6:	89 0a                	mov    %ecx,(%edx)
  800ca8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cab:	88 d1                	mov    %dl,%cl
  800cad:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb0:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800cb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb7:	8b 00                	mov    (%eax),%eax
  800cb9:	3d ff 00 00 00       	cmp    $0xff,%eax
  800cbe:	75 2c                	jne    800cec <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800cc0:	a0 24 50 80 00       	mov    0x805024,%al
  800cc5:	0f b6 c0             	movzbl %al,%eax
  800cc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ccb:	8b 12                	mov    (%edx),%edx
  800ccd:	89 d1                	mov    %edx,%ecx
  800ccf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cd2:	83 c2 08             	add    $0x8,%edx
  800cd5:	83 ec 04             	sub    $0x4,%esp
  800cd8:	50                   	push   %eax
  800cd9:	51                   	push   %ecx
  800cda:	52                   	push   %edx
  800cdb:	e8 80 13 00 00       	call   802060 <sys_cputs>
  800ce0:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800ce3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800cec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cef:	8b 40 04             	mov    0x4(%eax),%eax
  800cf2:	8d 50 01             	lea    0x1(%eax),%edx
  800cf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf8:	89 50 04             	mov    %edx,0x4(%eax)
}
  800cfb:	90                   	nop
  800cfc:	c9                   	leave  
  800cfd:	c3                   	ret    

00800cfe <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
  800d01:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800d07:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800d0e:	00 00 00 
	b.cnt = 0;
  800d11:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800d18:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800d1b:	ff 75 0c             	pushl  0xc(%ebp)
  800d1e:	ff 75 08             	pushl  0x8(%ebp)
  800d21:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800d27:	50                   	push   %eax
  800d28:	68 95 0c 80 00       	push   $0x800c95
  800d2d:	e8 11 02 00 00       	call   800f43 <vprintfmt>
  800d32:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800d35:	a0 24 50 80 00       	mov    0x805024,%al
  800d3a:	0f b6 c0             	movzbl %al,%eax
  800d3d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800d43:	83 ec 04             	sub    $0x4,%esp
  800d46:	50                   	push   %eax
  800d47:	52                   	push   %edx
  800d48:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800d4e:	83 c0 08             	add    $0x8,%eax
  800d51:	50                   	push   %eax
  800d52:	e8 09 13 00 00       	call   802060 <sys_cputs>
  800d57:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800d5a:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800d61:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800d67:	c9                   	leave  
  800d68:	c3                   	ret    

00800d69 <cprintf>:

int cprintf(const char *fmt, ...) {
  800d69:	55                   	push   %ebp
  800d6a:	89 e5                	mov    %esp,%ebp
  800d6c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800d6f:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800d76:	8d 45 0c             	lea    0xc(%ebp),%eax
  800d79:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7f:	83 ec 08             	sub    $0x8,%esp
  800d82:	ff 75 f4             	pushl  -0xc(%ebp)
  800d85:	50                   	push   %eax
  800d86:	e8 73 ff ff ff       	call   800cfe <vcprintf>
  800d8b:	83 c4 10             	add    $0x10,%esp
  800d8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800d91:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d94:	c9                   	leave  
  800d95:	c3                   	ret    

00800d96 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800d96:	55                   	push   %ebp
  800d97:	89 e5                	mov    %esp,%ebp
  800d99:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800d9c:	e8 6d 14 00 00       	call   80220e <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800da1:	8d 45 0c             	lea    0xc(%ebp),%eax
  800da4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	83 ec 08             	sub    $0x8,%esp
  800dad:	ff 75 f4             	pushl  -0xc(%ebp)
  800db0:	50                   	push   %eax
  800db1:	e8 48 ff ff ff       	call   800cfe <vcprintf>
  800db6:	83 c4 10             	add    $0x10,%esp
  800db9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800dbc:	e8 67 14 00 00       	call   802228 <sys_enable_interrupt>
	return cnt;
  800dc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800dc4:	c9                   	leave  
  800dc5:	c3                   	ret    

00800dc6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800dc6:	55                   	push   %ebp
  800dc7:	89 e5                	mov    %esp,%ebp
  800dc9:	53                   	push   %ebx
  800dca:	83 ec 14             	sub    $0x14,%esp
  800dcd:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dd3:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800dd9:	8b 45 18             	mov    0x18(%ebp),%eax
  800ddc:	ba 00 00 00 00       	mov    $0x0,%edx
  800de1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800de4:	77 55                	ja     800e3b <printnum+0x75>
  800de6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800de9:	72 05                	jb     800df0 <printnum+0x2a>
  800deb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800dee:	77 4b                	ja     800e3b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800df0:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800df3:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800df6:	8b 45 18             	mov    0x18(%ebp),%eax
  800df9:	ba 00 00 00 00       	mov    $0x0,%edx
  800dfe:	52                   	push   %edx
  800dff:	50                   	push   %eax
  800e00:	ff 75 f4             	pushl  -0xc(%ebp)
  800e03:	ff 75 f0             	pushl  -0x10(%ebp)
  800e06:	e8 cd 29 00 00       	call   8037d8 <__udivdi3>
  800e0b:	83 c4 10             	add    $0x10,%esp
  800e0e:	83 ec 04             	sub    $0x4,%esp
  800e11:	ff 75 20             	pushl  0x20(%ebp)
  800e14:	53                   	push   %ebx
  800e15:	ff 75 18             	pushl  0x18(%ebp)
  800e18:	52                   	push   %edx
  800e19:	50                   	push   %eax
  800e1a:	ff 75 0c             	pushl  0xc(%ebp)
  800e1d:	ff 75 08             	pushl  0x8(%ebp)
  800e20:	e8 a1 ff ff ff       	call   800dc6 <printnum>
  800e25:	83 c4 20             	add    $0x20,%esp
  800e28:	eb 1a                	jmp    800e44 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800e2a:	83 ec 08             	sub    $0x8,%esp
  800e2d:	ff 75 0c             	pushl  0xc(%ebp)
  800e30:	ff 75 20             	pushl  0x20(%ebp)
  800e33:	8b 45 08             	mov    0x8(%ebp),%eax
  800e36:	ff d0                	call   *%eax
  800e38:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800e3b:	ff 4d 1c             	decl   0x1c(%ebp)
  800e3e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800e42:	7f e6                	jg     800e2a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800e44:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800e47:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e52:	53                   	push   %ebx
  800e53:	51                   	push   %ecx
  800e54:	52                   	push   %edx
  800e55:	50                   	push   %eax
  800e56:	e8 8d 2a 00 00       	call   8038e8 <__umoddi3>
  800e5b:	83 c4 10             	add    $0x10,%esp
  800e5e:	05 14 40 80 00       	add    $0x804014,%eax
  800e63:	8a 00                	mov    (%eax),%al
  800e65:	0f be c0             	movsbl %al,%eax
  800e68:	83 ec 08             	sub    $0x8,%esp
  800e6b:	ff 75 0c             	pushl  0xc(%ebp)
  800e6e:	50                   	push   %eax
  800e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e72:	ff d0                	call   *%eax
  800e74:	83 c4 10             	add    $0x10,%esp
}
  800e77:	90                   	nop
  800e78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e7b:	c9                   	leave  
  800e7c:	c3                   	ret    

00800e7d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800e80:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800e84:	7e 1c                	jle    800ea2 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800e86:	8b 45 08             	mov    0x8(%ebp),%eax
  800e89:	8b 00                	mov    (%eax),%eax
  800e8b:	8d 50 08             	lea    0x8(%eax),%edx
  800e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e91:	89 10                	mov    %edx,(%eax)
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	8b 00                	mov    (%eax),%eax
  800e98:	83 e8 08             	sub    $0x8,%eax
  800e9b:	8b 50 04             	mov    0x4(%eax),%edx
  800e9e:	8b 00                	mov    (%eax),%eax
  800ea0:	eb 40                	jmp    800ee2 <getuint+0x65>
	else if (lflag)
  800ea2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ea6:	74 1e                	je     800ec6 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eab:	8b 00                	mov    (%eax),%eax
  800ead:	8d 50 04             	lea    0x4(%eax),%edx
  800eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb3:	89 10                	mov    %edx,(%eax)
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	8b 00                	mov    (%eax),%eax
  800eba:	83 e8 04             	sub    $0x4,%eax
  800ebd:	8b 00                	mov    (%eax),%eax
  800ebf:	ba 00 00 00 00       	mov    $0x0,%edx
  800ec4:	eb 1c                	jmp    800ee2 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec9:	8b 00                	mov    (%eax),%eax
  800ecb:	8d 50 04             	lea    0x4(%eax),%edx
  800ece:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed1:	89 10                	mov    %edx,(%eax)
  800ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed6:	8b 00                	mov    (%eax),%eax
  800ed8:	83 e8 04             	sub    $0x4,%eax
  800edb:	8b 00                	mov    (%eax),%eax
  800edd:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800ee2:	5d                   	pop    %ebp
  800ee3:	c3                   	ret    

00800ee4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ee4:	55                   	push   %ebp
  800ee5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ee7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800eeb:	7e 1c                	jle    800f09 <getint+0x25>
		return va_arg(*ap, long long);
  800eed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef0:	8b 00                	mov    (%eax),%eax
  800ef2:	8d 50 08             	lea    0x8(%eax),%edx
  800ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef8:	89 10                	mov    %edx,(%eax)
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8b 00                	mov    (%eax),%eax
  800eff:	83 e8 08             	sub    $0x8,%eax
  800f02:	8b 50 04             	mov    0x4(%eax),%edx
  800f05:	8b 00                	mov    (%eax),%eax
  800f07:	eb 38                	jmp    800f41 <getint+0x5d>
	else if (lflag)
  800f09:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f0d:	74 1a                	je     800f29 <getint+0x45>
		return va_arg(*ap, long);
  800f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f12:	8b 00                	mov    (%eax),%eax
  800f14:	8d 50 04             	lea    0x4(%eax),%edx
  800f17:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1a:	89 10                	mov    %edx,(%eax)
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1f:	8b 00                	mov    (%eax),%eax
  800f21:	83 e8 04             	sub    $0x4,%eax
  800f24:	8b 00                	mov    (%eax),%eax
  800f26:	99                   	cltd   
  800f27:	eb 18                	jmp    800f41 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	8b 00                	mov    (%eax),%eax
  800f2e:	8d 50 04             	lea    0x4(%eax),%edx
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	89 10                	mov    %edx,(%eax)
  800f36:	8b 45 08             	mov    0x8(%ebp),%eax
  800f39:	8b 00                	mov    (%eax),%eax
  800f3b:	83 e8 04             	sub    $0x4,%eax
  800f3e:	8b 00                	mov    (%eax),%eax
  800f40:	99                   	cltd   
}
  800f41:	5d                   	pop    %ebp
  800f42:	c3                   	ret    

00800f43 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800f43:	55                   	push   %ebp
  800f44:	89 e5                	mov    %esp,%ebp
  800f46:	56                   	push   %esi
  800f47:	53                   	push   %ebx
  800f48:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f4b:	eb 17                	jmp    800f64 <vprintfmt+0x21>
			if (ch == '\0')
  800f4d:	85 db                	test   %ebx,%ebx
  800f4f:	0f 84 af 03 00 00    	je     801304 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800f55:	83 ec 08             	sub    $0x8,%esp
  800f58:	ff 75 0c             	pushl  0xc(%ebp)
  800f5b:	53                   	push   %ebx
  800f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5f:	ff d0                	call   *%eax
  800f61:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f64:	8b 45 10             	mov    0x10(%ebp),%eax
  800f67:	8d 50 01             	lea    0x1(%eax),%edx
  800f6a:	89 55 10             	mov    %edx,0x10(%ebp)
  800f6d:	8a 00                	mov    (%eax),%al
  800f6f:	0f b6 d8             	movzbl %al,%ebx
  800f72:	83 fb 25             	cmp    $0x25,%ebx
  800f75:	75 d6                	jne    800f4d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800f77:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800f7b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800f82:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800f89:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800f90:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f97:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9a:	8d 50 01             	lea    0x1(%eax),%edx
  800f9d:	89 55 10             	mov    %edx,0x10(%ebp)
  800fa0:	8a 00                	mov    (%eax),%al
  800fa2:	0f b6 d8             	movzbl %al,%ebx
  800fa5:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800fa8:	83 f8 55             	cmp    $0x55,%eax
  800fab:	0f 87 2b 03 00 00    	ja     8012dc <vprintfmt+0x399>
  800fb1:	8b 04 85 38 40 80 00 	mov    0x804038(,%eax,4),%eax
  800fb8:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800fba:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800fbe:	eb d7                	jmp    800f97 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800fc0:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800fc4:	eb d1                	jmp    800f97 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800fc6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800fcd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800fd0:	89 d0                	mov    %edx,%eax
  800fd2:	c1 e0 02             	shl    $0x2,%eax
  800fd5:	01 d0                	add    %edx,%eax
  800fd7:	01 c0                	add    %eax,%eax
  800fd9:	01 d8                	add    %ebx,%eax
  800fdb:	83 e8 30             	sub    $0x30,%eax
  800fde:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800fe1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe4:	8a 00                	mov    (%eax),%al
  800fe6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800fe9:	83 fb 2f             	cmp    $0x2f,%ebx
  800fec:	7e 3e                	jle    80102c <vprintfmt+0xe9>
  800fee:	83 fb 39             	cmp    $0x39,%ebx
  800ff1:	7f 39                	jg     80102c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ff3:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ff6:	eb d5                	jmp    800fcd <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ff8:	8b 45 14             	mov    0x14(%ebp),%eax
  800ffb:	83 c0 04             	add    $0x4,%eax
  800ffe:	89 45 14             	mov    %eax,0x14(%ebp)
  801001:	8b 45 14             	mov    0x14(%ebp),%eax
  801004:	83 e8 04             	sub    $0x4,%eax
  801007:	8b 00                	mov    (%eax),%eax
  801009:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80100c:	eb 1f                	jmp    80102d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80100e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801012:	79 83                	jns    800f97 <vprintfmt+0x54>
				width = 0;
  801014:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80101b:	e9 77 ff ff ff       	jmp    800f97 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801020:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801027:	e9 6b ff ff ff       	jmp    800f97 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80102c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80102d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801031:	0f 89 60 ff ff ff    	jns    800f97 <vprintfmt+0x54>
				width = precision, precision = -1;
  801037:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80103a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80103d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801044:	e9 4e ff ff ff       	jmp    800f97 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801049:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80104c:	e9 46 ff ff ff       	jmp    800f97 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801051:	8b 45 14             	mov    0x14(%ebp),%eax
  801054:	83 c0 04             	add    $0x4,%eax
  801057:	89 45 14             	mov    %eax,0x14(%ebp)
  80105a:	8b 45 14             	mov    0x14(%ebp),%eax
  80105d:	83 e8 04             	sub    $0x4,%eax
  801060:	8b 00                	mov    (%eax),%eax
  801062:	83 ec 08             	sub    $0x8,%esp
  801065:	ff 75 0c             	pushl  0xc(%ebp)
  801068:	50                   	push   %eax
  801069:	8b 45 08             	mov    0x8(%ebp),%eax
  80106c:	ff d0                	call   *%eax
  80106e:	83 c4 10             	add    $0x10,%esp
			break;
  801071:	e9 89 02 00 00       	jmp    8012ff <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801076:	8b 45 14             	mov    0x14(%ebp),%eax
  801079:	83 c0 04             	add    $0x4,%eax
  80107c:	89 45 14             	mov    %eax,0x14(%ebp)
  80107f:	8b 45 14             	mov    0x14(%ebp),%eax
  801082:	83 e8 04             	sub    $0x4,%eax
  801085:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801087:	85 db                	test   %ebx,%ebx
  801089:	79 02                	jns    80108d <vprintfmt+0x14a>
				err = -err;
  80108b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80108d:	83 fb 64             	cmp    $0x64,%ebx
  801090:	7f 0b                	jg     80109d <vprintfmt+0x15a>
  801092:	8b 34 9d 80 3e 80 00 	mov    0x803e80(,%ebx,4),%esi
  801099:	85 f6                	test   %esi,%esi
  80109b:	75 19                	jne    8010b6 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80109d:	53                   	push   %ebx
  80109e:	68 25 40 80 00       	push   $0x804025
  8010a3:	ff 75 0c             	pushl  0xc(%ebp)
  8010a6:	ff 75 08             	pushl  0x8(%ebp)
  8010a9:	e8 5e 02 00 00       	call   80130c <printfmt>
  8010ae:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8010b1:	e9 49 02 00 00       	jmp    8012ff <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8010b6:	56                   	push   %esi
  8010b7:	68 2e 40 80 00       	push   $0x80402e
  8010bc:	ff 75 0c             	pushl  0xc(%ebp)
  8010bf:	ff 75 08             	pushl  0x8(%ebp)
  8010c2:	e8 45 02 00 00       	call   80130c <printfmt>
  8010c7:	83 c4 10             	add    $0x10,%esp
			break;
  8010ca:	e9 30 02 00 00       	jmp    8012ff <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8010cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8010d2:	83 c0 04             	add    $0x4,%eax
  8010d5:	89 45 14             	mov    %eax,0x14(%ebp)
  8010d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8010db:	83 e8 04             	sub    $0x4,%eax
  8010de:	8b 30                	mov    (%eax),%esi
  8010e0:	85 f6                	test   %esi,%esi
  8010e2:	75 05                	jne    8010e9 <vprintfmt+0x1a6>
				p = "(null)";
  8010e4:	be 31 40 80 00       	mov    $0x804031,%esi
			if (width > 0 && padc != '-')
  8010e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010ed:	7e 6d                	jle    80115c <vprintfmt+0x219>
  8010ef:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8010f3:	74 67                	je     80115c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8010f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010f8:	83 ec 08             	sub    $0x8,%esp
  8010fb:	50                   	push   %eax
  8010fc:	56                   	push   %esi
  8010fd:	e8 0c 03 00 00       	call   80140e <strnlen>
  801102:	83 c4 10             	add    $0x10,%esp
  801105:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801108:	eb 16                	jmp    801120 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80110a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80110e:	83 ec 08             	sub    $0x8,%esp
  801111:	ff 75 0c             	pushl  0xc(%ebp)
  801114:	50                   	push   %eax
  801115:	8b 45 08             	mov    0x8(%ebp),%eax
  801118:	ff d0                	call   *%eax
  80111a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80111d:	ff 4d e4             	decl   -0x1c(%ebp)
  801120:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801124:	7f e4                	jg     80110a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801126:	eb 34                	jmp    80115c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801128:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80112c:	74 1c                	je     80114a <vprintfmt+0x207>
  80112e:	83 fb 1f             	cmp    $0x1f,%ebx
  801131:	7e 05                	jle    801138 <vprintfmt+0x1f5>
  801133:	83 fb 7e             	cmp    $0x7e,%ebx
  801136:	7e 12                	jle    80114a <vprintfmt+0x207>
					putch('?', putdat);
  801138:	83 ec 08             	sub    $0x8,%esp
  80113b:	ff 75 0c             	pushl  0xc(%ebp)
  80113e:	6a 3f                	push   $0x3f
  801140:	8b 45 08             	mov    0x8(%ebp),%eax
  801143:	ff d0                	call   *%eax
  801145:	83 c4 10             	add    $0x10,%esp
  801148:	eb 0f                	jmp    801159 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80114a:	83 ec 08             	sub    $0x8,%esp
  80114d:	ff 75 0c             	pushl  0xc(%ebp)
  801150:	53                   	push   %ebx
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
  801154:	ff d0                	call   *%eax
  801156:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801159:	ff 4d e4             	decl   -0x1c(%ebp)
  80115c:	89 f0                	mov    %esi,%eax
  80115e:	8d 70 01             	lea    0x1(%eax),%esi
  801161:	8a 00                	mov    (%eax),%al
  801163:	0f be d8             	movsbl %al,%ebx
  801166:	85 db                	test   %ebx,%ebx
  801168:	74 24                	je     80118e <vprintfmt+0x24b>
  80116a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80116e:	78 b8                	js     801128 <vprintfmt+0x1e5>
  801170:	ff 4d e0             	decl   -0x20(%ebp)
  801173:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801177:	79 af                	jns    801128 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801179:	eb 13                	jmp    80118e <vprintfmt+0x24b>
				putch(' ', putdat);
  80117b:	83 ec 08             	sub    $0x8,%esp
  80117e:	ff 75 0c             	pushl  0xc(%ebp)
  801181:	6a 20                	push   $0x20
  801183:	8b 45 08             	mov    0x8(%ebp),%eax
  801186:	ff d0                	call   *%eax
  801188:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80118b:	ff 4d e4             	decl   -0x1c(%ebp)
  80118e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801192:	7f e7                	jg     80117b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801194:	e9 66 01 00 00       	jmp    8012ff <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801199:	83 ec 08             	sub    $0x8,%esp
  80119c:	ff 75 e8             	pushl  -0x18(%ebp)
  80119f:	8d 45 14             	lea    0x14(%ebp),%eax
  8011a2:	50                   	push   %eax
  8011a3:	e8 3c fd ff ff       	call   800ee4 <getint>
  8011a8:	83 c4 10             	add    $0x10,%esp
  8011ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8011b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011b7:	85 d2                	test   %edx,%edx
  8011b9:	79 23                	jns    8011de <vprintfmt+0x29b>
				putch('-', putdat);
  8011bb:	83 ec 08             	sub    $0x8,%esp
  8011be:	ff 75 0c             	pushl  0xc(%ebp)
  8011c1:	6a 2d                	push   $0x2d
  8011c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c6:	ff d0                	call   *%eax
  8011c8:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8011cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011d1:	f7 d8                	neg    %eax
  8011d3:	83 d2 00             	adc    $0x0,%edx
  8011d6:	f7 da                	neg    %edx
  8011d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011db:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8011de:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8011e5:	e9 bc 00 00 00       	jmp    8012a6 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8011ea:	83 ec 08             	sub    $0x8,%esp
  8011ed:	ff 75 e8             	pushl  -0x18(%ebp)
  8011f0:	8d 45 14             	lea    0x14(%ebp),%eax
  8011f3:	50                   	push   %eax
  8011f4:	e8 84 fc ff ff       	call   800e7d <getuint>
  8011f9:	83 c4 10             	add    $0x10,%esp
  8011fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011ff:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801202:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801209:	e9 98 00 00 00       	jmp    8012a6 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80120e:	83 ec 08             	sub    $0x8,%esp
  801211:	ff 75 0c             	pushl  0xc(%ebp)
  801214:	6a 58                	push   $0x58
  801216:	8b 45 08             	mov    0x8(%ebp),%eax
  801219:	ff d0                	call   *%eax
  80121b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80121e:	83 ec 08             	sub    $0x8,%esp
  801221:	ff 75 0c             	pushl  0xc(%ebp)
  801224:	6a 58                	push   $0x58
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	ff d0                	call   *%eax
  80122b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80122e:	83 ec 08             	sub    $0x8,%esp
  801231:	ff 75 0c             	pushl  0xc(%ebp)
  801234:	6a 58                	push   $0x58
  801236:	8b 45 08             	mov    0x8(%ebp),%eax
  801239:	ff d0                	call   *%eax
  80123b:	83 c4 10             	add    $0x10,%esp
			break;
  80123e:	e9 bc 00 00 00       	jmp    8012ff <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801243:	83 ec 08             	sub    $0x8,%esp
  801246:	ff 75 0c             	pushl  0xc(%ebp)
  801249:	6a 30                	push   $0x30
  80124b:	8b 45 08             	mov    0x8(%ebp),%eax
  80124e:	ff d0                	call   *%eax
  801250:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801253:	83 ec 08             	sub    $0x8,%esp
  801256:	ff 75 0c             	pushl  0xc(%ebp)
  801259:	6a 78                	push   $0x78
  80125b:	8b 45 08             	mov    0x8(%ebp),%eax
  80125e:	ff d0                	call   *%eax
  801260:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801263:	8b 45 14             	mov    0x14(%ebp),%eax
  801266:	83 c0 04             	add    $0x4,%eax
  801269:	89 45 14             	mov    %eax,0x14(%ebp)
  80126c:	8b 45 14             	mov    0x14(%ebp),%eax
  80126f:	83 e8 04             	sub    $0x4,%eax
  801272:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801274:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801277:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80127e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801285:	eb 1f                	jmp    8012a6 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801287:	83 ec 08             	sub    $0x8,%esp
  80128a:	ff 75 e8             	pushl  -0x18(%ebp)
  80128d:	8d 45 14             	lea    0x14(%ebp),%eax
  801290:	50                   	push   %eax
  801291:	e8 e7 fb ff ff       	call   800e7d <getuint>
  801296:	83 c4 10             	add    $0x10,%esp
  801299:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80129c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80129f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8012a6:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8012aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012ad:	83 ec 04             	sub    $0x4,%esp
  8012b0:	52                   	push   %edx
  8012b1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012b4:	50                   	push   %eax
  8012b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8012b8:	ff 75 f0             	pushl  -0x10(%ebp)
  8012bb:	ff 75 0c             	pushl  0xc(%ebp)
  8012be:	ff 75 08             	pushl  0x8(%ebp)
  8012c1:	e8 00 fb ff ff       	call   800dc6 <printnum>
  8012c6:	83 c4 20             	add    $0x20,%esp
			break;
  8012c9:	eb 34                	jmp    8012ff <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8012cb:	83 ec 08             	sub    $0x8,%esp
  8012ce:	ff 75 0c             	pushl  0xc(%ebp)
  8012d1:	53                   	push   %ebx
  8012d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d5:	ff d0                	call   *%eax
  8012d7:	83 c4 10             	add    $0x10,%esp
			break;
  8012da:	eb 23                	jmp    8012ff <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8012dc:	83 ec 08             	sub    $0x8,%esp
  8012df:	ff 75 0c             	pushl  0xc(%ebp)
  8012e2:	6a 25                	push   $0x25
  8012e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e7:	ff d0                	call   *%eax
  8012e9:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8012ec:	ff 4d 10             	decl   0x10(%ebp)
  8012ef:	eb 03                	jmp    8012f4 <vprintfmt+0x3b1>
  8012f1:	ff 4d 10             	decl   0x10(%ebp)
  8012f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f7:	48                   	dec    %eax
  8012f8:	8a 00                	mov    (%eax),%al
  8012fa:	3c 25                	cmp    $0x25,%al
  8012fc:	75 f3                	jne    8012f1 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8012fe:	90                   	nop
		}
	}
  8012ff:	e9 47 fc ff ff       	jmp    800f4b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801304:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801305:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801308:	5b                   	pop    %ebx
  801309:	5e                   	pop    %esi
  80130a:	5d                   	pop    %ebp
  80130b:	c3                   	ret    

0080130c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80130c:	55                   	push   %ebp
  80130d:	89 e5                	mov    %esp,%ebp
  80130f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801312:	8d 45 10             	lea    0x10(%ebp),%eax
  801315:	83 c0 04             	add    $0x4,%eax
  801318:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80131b:	8b 45 10             	mov    0x10(%ebp),%eax
  80131e:	ff 75 f4             	pushl  -0xc(%ebp)
  801321:	50                   	push   %eax
  801322:	ff 75 0c             	pushl  0xc(%ebp)
  801325:	ff 75 08             	pushl  0x8(%ebp)
  801328:	e8 16 fc ff ff       	call   800f43 <vprintfmt>
  80132d:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801330:	90                   	nop
  801331:	c9                   	leave  
  801332:	c3                   	ret    

00801333 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801333:	55                   	push   %ebp
  801334:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801336:	8b 45 0c             	mov    0xc(%ebp),%eax
  801339:	8b 40 08             	mov    0x8(%eax),%eax
  80133c:	8d 50 01             	lea    0x1(%eax),%edx
  80133f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801342:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801345:	8b 45 0c             	mov    0xc(%ebp),%eax
  801348:	8b 10                	mov    (%eax),%edx
  80134a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134d:	8b 40 04             	mov    0x4(%eax),%eax
  801350:	39 c2                	cmp    %eax,%edx
  801352:	73 12                	jae    801366 <sprintputch+0x33>
		*b->buf++ = ch;
  801354:	8b 45 0c             	mov    0xc(%ebp),%eax
  801357:	8b 00                	mov    (%eax),%eax
  801359:	8d 48 01             	lea    0x1(%eax),%ecx
  80135c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80135f:	89 0a                	mov    %ecx,(%edx)
  801361:	8b 55 08             	mov    0x8(%ebp),%edx
  801364:	88 10                	mov    %dl,(%eax)
}
  801366:	90                   	nop
  801367:	5d                   	pop    %ebp
  801368:	c3                   	ret    

00801369 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801369:	55                   	push   %ebp
  80136a:	89 e5                	mov    %esp,%ebp
  80136c:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80136f:	8b 45 08             	mov    0x8(%ebp),%eax
  801372:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801375:	8b 45 0c             	mov    0xc(%ebp),%eax
  801378:	8d 50 ff             	lea    -0x1(%eax),%edx
  80137b:	8b 45 08             	mov    0x8(%ebp),%eax
  80137e:	01 d0                	add    %edx,%eax
  801380:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801383:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80138a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80138e:	74 06                	je     801396 <vsnprintf+0x2d>
  801390:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801394:	7f 07                	jg     80139d <vsnprintf+0x34>
		return -E_INVAL;
  801396:	b8 03 00 00 00       	mov    $0x3,%eax
  80139b:	eb 20                	jmp    8013bd <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80139d:	ff 75 14             	pushl  0x14(%ebp)
  8013a0:	ff 75 10             	pushl  0x10(%ebp)
  8013a3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8013a6:	50                   	push   %eax
  8013a7:	68 33 13 80 00       	push   $0x801333
  8013ac:	e8 92 fb ff ff       	call   800f43 <vprintfmt>
  8013b1:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8013b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013b7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8013ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8013bd:	c9                   	leave  
  8013be:	c3                   	ret    

008013bf <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8013bf:	55                   	push   %ebp
  8013c0:	89 e5                	mov    %esp,%ebp
  8013c2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8013c5:	8d 45 10             	lea    0x10(%ebp),%eax
  8013c8:	83 c0 04             	add    $0x4,%eax
  8013cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8013ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8013d4:	50                   	push   %eax
  8013d5:	ff 75 0c             	pushl  0xc(%ebp)
  8013d8:	ff 75 08             	pushl  0x8(%ebp)
  8013db:	e8 89 ff ff ff       	call   801369 <vsnprintf>
  8013e0:	83 c4 10             	add    $0x10,%esp
  8013e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8013e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8013e9:	c9                   	leave  
  8013ea:	c3                   	ret    

008013eb <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8013eb:	55                   	push   %ebp
  8013ec:	89 e5                	mov    %esp,%ebp
  8013ee:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8013f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013f8:	eb 06                	jmp    801400 <strlen+0x15>
		n++;
  8013fa:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8013fd:	ff 45 08             	incl   0x8(%ebp)
  801400:	8b 45 08             	mov    0x8(%ebp),%eax
  801403:	8a 00                	mov    (%eax),%al
  801405:	84 c0                	test   %al,%al
  801407:	75 f1                	jne    8013fa <strlen+0xf>
		n++;
	return n;
  801409:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80140c:	c9                   	leave  
  80140d:	c3                   	ret    

0080140e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80140e:	55                   	push   %ebp
  80140f:	89 e5                	mov    %esp,%ebp
  801411:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801414:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80141b:	eb 09                	jmp    801426 <strnlen+0x18>
		n++;
  80141d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801420:	ff 45 08             	incl   0x8(%ebp)
  801423:	ff 4d 0c             	decl   0xc(%ebp)
  801426:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80142a:	74 09                	je     801435 <strnlen+0x27>
  80142c:	8b 45 08             	mov    0x8(%ebp),%eax
  80142f:	8a 00                	mov    (%eax),%al
  801431:	84 c0                	test   %al,%al
  801433:	75 e8                	jne    80141d <strnlen+0xf>
		n++;
	return n;
  801435:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801438:	c9                   	leave  
  801439:	c3                   	ret    

0080143a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
  80143d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801440:	8b 45 08             	mov    0x8(%ebp),%eax
  801443:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801446:	90                   	nop
  801447:	8b 45 08             	mov    0x8(%ebp),%eax
  80144a:	8d 50 01             	lea    0x1(%eax),%edx
  80144d:	89 55 08             	mov    %edx,0x8(%ebp)
  801450:	8b 55 0c             	mov    0xc(%ebp),%edx
  801453:	8d 4a 01             	lea    0x1(%edx),%ecx
  801456:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801459:	8a 12                	mov    (%edx),%dl
  80145b:	88 10                	mov    %dl,(%eax)
  80145d:	8a 00                	mov    (%eax),%al
  80145f:	84 c0                	test   %al,%al
  801461:	75 e4                	jne    801447 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801463:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801466:	c9                   	leave  
  801467:	c3                   	ret    

00801468 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801468:	55                   	push   %ebp
  801469:	89 e5                	mov    %esp,%ebp
  80146b:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80146e:	8b 45 08             	mov    0x8(%ebp),%eax
  801471:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801474:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80147b:	eb 1f                	jmp    80149c <strncpy+0x34>
		*dst++ = *src;
  80147d:	8b 45 08             	mov    0x8(%ebp),%eax
  801480:	8d 50 01             	lea    0x1(%eax),%edx
  801483:	89 55 08             	mov    %edx,0x8(%ebp)
  801486:	8b 55 0c             	mov    0xc(%ebp),%edx
  801489:	8a 12                	mov    (%edx),%dl
  80148b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80148d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801490:	8a 00                	mov    (%eax),%al
  801492:	84 c0                	test   %al,%al
  801494:	74 03                	je     801499 <strncpy+0x31>
			src++;
  801496:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801499:	ff 45 fc             	incl   -0x4(%ebp)
  80149c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80149f:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014a2:	72 d9                	jb     80147d <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014a7:	c9                   	leave  
  8014a8:	c3                   	ret    

008014a9 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8014a9:	55                   	push   %ebp
  8014aa:	89 e5                	mov    %esp,%ebp
  8014ac:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8014af:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8014b5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014b9:	74 30                	je     8014eb <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8014bb:	eb 16                	jmp    8014d3 <strlcpy+0x2a>
			*dst++ = *src++;
  8014bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c0:	8d 50 01             	lea    0x1(%eax),%edx
  8014c3:	89 55 08             	mov    %edx,0x8(%ebp)
  8014c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014cc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014cf:	8a 12                	mov    (%edx),%dl
  8014d1:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014d3:	ff 4d 10             	decl   0x10(%ebp)
  8014d6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014da:	74 09                	je     8014e5 <strlcpy+0x3c>
  8014dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014df:	8a 00                	mov    (%eax),%al
  8014e1:	84 c0                	test   %al,%al
  8014e3:	75 d8                	jne    8014bd <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8014e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8014eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8014ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014f1:	29 c2                	sub    %eax,%edx
  8014f3:	89 d0                	mov    %edx,%eax
}
  8014f5:	c9                   	leave  
  8014f6:	c3                   	ret    

008014f7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8014f7:	55                   	push   %ebp
  8014f8:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8014fa:	eb 06                	jmp    801502 <strcmp+0xb>
		p++, q++;
  8014fc:	ff 45 08             	incl   0x8(%ebp)
  8014ff:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801502:	8b 45 08             	mov    0x8(%ebp),%eax
  801505:	8a 00                	mov    (%eax),%al
  801507:	84 c0                	test   %al,%al
  801509:	74 0e                	je     801519 <strcmp+0x22>
  80150b:	8b 45 08             	mov    0x8(%ebp),%eax
  80150e:	8a 10                	mov    (%eax),%dl
  801510:	8b 45 0c             	mov    0xc(%ebp),%eax
  801513:	8a 00                	mov    (%eax),%al
  801515:	38 c2                	cmp    %al,%dl
  801517:	74 e3                	je     8014fc <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801519:	8b 45 08             	mov    0x8(%ebp),%eax
  80151c:	8a 00                	mov    (%eax),%al
  80151e:	0f b6 d0             	movzbl %al,%edx
  801521:	8b 45 0c             	mov    0xc(%ebp),%eax
  801524:	8a 00                	mov    (%eax),%al
  801526:	0f b6 c0             	movzbl %al,%eax
  801529:	29 c2                	sub    %eax,%edx
  80152b:	89 d0                	mov    %edx,%eax
}
  80152d:	5d                   	pop    %ebp
  80152e:	c3                   	ret    

0080152f <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80152f:	55                   	push   %ebp
  801530:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801532:	eb 09                	jmp    80153d <strncmp+0xe>
		n--, p++, q++;
  801534:	ff 4d 10             	decl   0x10(%ebp)
  801537:	ff 45 08             	incl   0x8(%ebp)
  80153a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80153d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801541:	74 17                	je     80155a <strncmp+0x2b>
  801543:	8b 45 08             	mov    0x8(%ebp),%eax
  801546:	8a 00                	mov    (%eax),%al
  801548:	84 c0                	test   %al,%al
  80154a:	74 0e                	je     80155a <strncmp+0x2b>
  80154c:	8b 45 08             	mov    0x8(%ebp),%eax
  80154f:	8a 10                	mov    (%eax),%dl
  801551:	8b 45 0c             	mov    0xc(%ebp),%eax
  801554:	8a 00                	mov    (%eax),%al
  801556:	38 c2                	cmp    %al,%dl
  801558:	74 da                	je     801534 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80155a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80155e:	75 07                	jne    801567 <strncmp+0x38>
		return 0;
  801560:	b8 00 00 00 00       	mov    $0x0,%eax
  801565:	eb 14                	jmp    80157b <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801567:	8b 45 08             	mov    0x8(%ebp),%eax
  80156a:	8a 00                	mov    (%eax),%al
  80156c:	0f b6 d0             	movzbl %al,%edx
  80156f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801572:	8a 00                	mov    (%eax),%al
  801574:	0f b6 c0             	movzbl %al,%eax
  801577:	29 c2                	sub    %eax,%edx
  801579:	89 d0                	mov    %edx,%eax
}
  80157b:	5d                   	pop    %ebp
  80157c:	c3                   	ret    

0080157d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80157d:	55                   	push   %ebp
  80157e:	89 e5                	mov    %esp,%ebp
  801580:	83 ec 04             	sub    $0x4,%esp
  801583:	8b 45 0c             	mov    0xc(%ebp),%eax
  801586:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801589:	eb 12                	jmp    80159d <strchr+0x20>
		if (*s == c)
  80158b:	8b 45 08             	mov    0x8(%ebp),%eax
  80158e:	8a 00                	mov    (%eax),%al
  801590:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801593:	75 05                	jne    80159a <strchr+0x1d>
			return (char *) s;
  801595:	8b 45 08             	mov    0x8(%ebp),%eax
  801598:	eb 11                	jmp    8015ab <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80159a:	ff 45 08             	incl   0x8(%ebp)
  80159d:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a0:	8a 00                	mov    (%eax),%al
  8015a2:	84 c0                	test   %al,%al
  8015a4:	75 e5                	jne    80158b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8015a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ab:	c9                   	leave  
  8015ac:	c3                   	ret    

008015ad <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8015ad:	55                   	push   %ebp
  8015ae:	89 e5                	mov    %esp,%ebp
  8015b0:	83 ec 04             	sub    $0x4,%esp
  8015b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015b9:	eb 0d                	jmp    8015c8 <strfind+0x1b>
		if (*s == c)
  8015bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015be:	8a 00                	mov    (%eax),%al
  8015c0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015c3:	74 0e                	je     8015d3 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8015c5:	ff 45 08             	incl   0x8(%ebp)
  8015c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cb:	8a 00                	mov    (%eax),%al
  8015cd:	84 c0                	test   %al,%al
  8015cf:	75 ea                	jne    8015bb <strfind+0xe>
  8015d1:	eb 01                	jmp    8015d4 <strfind+0x27>
		if (*s == c)
			break;
  8015d3:	90                   	nop
	return (char *) s;
  8015d4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015d7:	c9                   	leave  
  8015d8:	c3                   	ret    

008015d9 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8015d9:	55                   	push   %ebp
  8015da:	89 e5                	mov    %esp,%ebp
  8015dc:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8015df:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8015e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8015eb:	eb 0e                	jmp    8015fb <memset+0x22>
		*p++ = c;
  8015ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015f0:	8d 50 01             	lea    0x1(%eax),%edx
  8015f3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015f9:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8015fb:	ff 4d f8             	decl   -0x8(%ebp)
  8015fe:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801602:	79 e9                	jns    8015ed <memset+0x14>
		*p++ = c;

	return v;
  801604:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801607:	c9                   	leave  
  801608:	c3                   	ret    

00801609 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
  80160c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80160f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801612:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801615:	8b 45 08             	mov    0x8(%ebp),%eax
  801618:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80161b:	eb 16                	jmp    801633 <memcpy+0x2a>
		*d++ = *s++;
  80161d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801620:	8d 50 01             	lea    0x1(%eax),%edx
  801623:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801626:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801629:	8d 4a 01             	lea    0x1(%edx),%ecx
  80162c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80162f:	8a 12                	mov    (%edx),%dl
  801631:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801633:	8b 45 10             	mov    0x10(%ebp),%eax
  801636:	8d 50 ff             	lea    -0x1(%eax),%edx
  801639:	89 55 10             	mov    %edx,0x10(%ebp)
  80163c:	85 c0                	test   %eax,%eax
  80163e:	75 dd                	jne    80161d <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801640:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801643:	c9                   	leave  
  801644:	c3                   	ret    

00801645 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801645:	55                   	push   %ebp
  801646:	89 e5                	mov    %esp,%ebp
  801648:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80164b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801651:	8b 45 08             	mov    0x8(%ebp),%eax
  801654:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801657:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80165a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80165d:	73 50                	jae    8016af <memmove+0x6a>
  80165f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801662:	8b 45 10             	mov    0x10(%ebp),%eax
  801665:	01 d0                	add    %edx,%eax
  801667:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80166a:	76 43                	jbe    8016af <memmove+0x6a>
		s += n;
  80166c:	8b 45 10             	mov    0x10(%ebp),%eax
  80166f:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801672:	8b 45 10             	mov    0x10(%ebp),%eax
  801675:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801678:	eb 10                	jmp    80168a <memmove+0x45>
			*--d = *--s;
  80167a:	ff 4d f8             	decl   -0x8(%ebp)
  80167d:	ff 4d fc             	decl   -0x4(%ebp)
  801680:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801683:	8a 10                	mov    (%eax),%dl
  801685:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801688:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80168a:	8b 45 10             	mov    0x10(%ebp),%eax
  80168d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801690:	89 55 10             	mov    %edx,0x10(%ebp)
  801693:	85 c0                	test   %eax,%eax
  801695:	75 e3                	jne    80167a <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801697:	eb 23                	jmp    8016bc <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801699:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80169c:	8d 50 01             	lea    0x1(%eax),%edx
  80169f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016a2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016a5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016a8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016ab:	8a 12                	mov    (%edx),%dl
  8016ad:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8016af:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016b5:	89 55 10             	mov    %edx,0x10(%ebp)
  8016b8:	85 c0                	test   %eax,%eax
  8016ba:	75 dd                	jne    801699 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8016bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016bf:	c9                   	leave  
  8016c0:	c3                   	ret    

008016c1 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8016c1:	55                   	push   %ebp
  8016c2:	89 e5                	mov    %esp,%ebp
  8016c4:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8016c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d0:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8016d3:	eb 2a                	jmp    8016ff <memcmp+0x3e>
		if (*s1 != *s2)
  8016d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016d8:	8a 10                	mov    (%eax),%dl
  8016da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016dd:	8a 00                	mov    (%eax),%al
  8016df:	38 c2                	cmp    %al,%dl
  8016e1:	74 16                	je     8016f9 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8016e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016e6:	8a 00                	mov    (%eax),%al
  8016e8:	0f b6 d0             	movzbl %al,%edx
  8016eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016ee:	8a 00                	mov    (%eax),%al
  8016f0:	0f b6 c0             	movzbl %al,%eax
  8016f3:	29 c2                	sub    %eax,%edx
  8016f5:	89 d0                	mov    %edx,%eax
  8016f7:	eb 18                	jmp    801711 <memcmp+0x50>
		s1++, s2++;
  8016f9:	ff 45 fc             	incl   -0x4(%ebp)
  8016fc:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8016ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801702:	8d 50 ff             	lea    -0x1(%eax),%edx
  801705:	89 55 10             	mov    %edx,0x10(%ebp)
  801708:	85 c0                	test   %eax,%eax
  80170a:	75 c9                	jne    8016d5 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80170c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801711:	c9                   	leave  
  801712:	c3                   	ret    

00801713 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
  801716:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801719:	8b 55 08             	mov    0x8(%ebp),%edx
  80171c:	8b 45 10             	mov    0x10(%ebp),%eax
  80171f:	01 d0                	add    %edx,%eax
  801721:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801724:	eb 15                	jmp    80173b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801726:	8b 45 08             	mov    0x8(%ebp),%eax
  801729:	8a 00                	mov    (%eax),%al
  80172b:	0f b6 d0             	movzbl %al,%edx
  80172e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801731:	0f b6 c0             	movzbl %al,%eax
  801734:	39 c2                	cmp    %eax,%edx
  801736:	74 0d                	je     801745 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801738:	ff 45 08             	incl   0x8(%ebp)
  80173b:	8b 45 08             	mov    0x8(%ebp),%eax
  80173e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801741:	72 e3                	jb     801726 <memfind+0x13>
  801743:	eb 01                	jmp    801746 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801745:	90                   	nop
	return (void *) s;
  801746:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801749:	c9                   	leave  
  80174a:	c3                   	ret    

0080174b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80174b:	55                   	push   %ebp
  80174c:	89 e5                	mov    %esp,%ebp
  80174e:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801751:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801758:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80175f:	eb 03                	jmp    801764 <strtol+0x19>
		s++;
  801761:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801764:	8b 45 08             	mov    0x8(%ebp),%eax
  801767:	8a 00                	mov    (%eax),%al
  801769:	3c 20                	cmp    $0x20,%al
  80176b:	74 f4                	je     801761 <strtol+0x16>
  80176d:	8b 45 08             	mov    0x8(%ebp),%eax
  801770:	8a 00                	mov    (%eax),%al
  801772:	3c 09                	cmp    $0x9,%al
  801774:	74 eb                	je     801761 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801776:	8b 45 08             	mov    0x8(%ebp),%eax
  801779:	8a 00                	mov    (%eax),%al
  80177b:	3c 2b                	cmp    $0x2b,%al
  80177d:	75 05                	jne    801784 <strtol+0x39>
		s++;
  80177f:	ff 45 08             	incl   0x8(%ebp)
  801782:	eb 13                	jmp    801797 <strtol+0x4c>
	else if (*s == '-')
  801784:	8b 45 08             	mov    0x8(%ebp),%eax
  801787:	8a 00                	mov    (%eax),%al
  801789:	3c 2d                	cmp    $0x2d,%al
  80178b:	75 0a                	jne    801797 <strtol+0x4c>
		s++, neg = 1;
  80178d:	ff 45 08             	incl   0x8(%ebp)
  801790:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801797:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80179b:	74 06                	je     8017a3 <strtol+0x58>
  80179d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8017a1:	75 20                	jne    8017c3 <strtol+0x78>
  8017a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a6:	8a 00                	mov    (%eax),%al
  8017a8:	3c 30                	cmp    $0x30,%al
  8017aa:	75 17                	jne    8017c3 <strtol+0x78>
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	40                   	inc    %eax
  8017b0:	8a 00                	mov    (%eax),%al
  8017b2:	3c 78                	cmp    $0x78,%al
  8017b4:	75 0d                	jne    8017c3 <strtol+0x78>
		s += 2, base = 16;
  8017b6:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8017ba:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8017c1:	eb 28                	jmp    8017eb <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8017c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017c7:	75 15                	jne    8017de <strtol+0x93>
  8017c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cc:	8a 00                	mov    (%eax),%al
  8017ce:	3c 30                	cmp    $0x30,%al
  8017d0:	75 0c                	jne    8017de <strtol+0x93>
		s++, base = 8;
  8017d2:	ff 45 08             	incl   0x8(%ebp)
  8017d5:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8017dc:	eb 0d                	jmp    8017eb <strtol+0xa0>
	else if (base == 0)
  8017de:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017e2:	75 07                	jne    8017eb <strtol+0xa0>
		base = 10;
  8017e4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ee:	8a 00                	mov    (%eax),%al
  8017f0:	3c 2f                	cmp    $0x2f,%al
  8017f2:	7e 19                	jle    80180d <strtol+0xc2>
  8017f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f7:	8a 00                	mov    (%eax),%al
  8017f9:	3c 39                	cmp    $0x39,%al
  8017fb:	7f 10                	jg     80180d <strtol+0xc2>
			dig = *s - '0';
  8017fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801800:	8a 00                	mov    (%eax),%al
  801802:	0f be c0             	movsbl %al,%eax
  801805:	83 e8 30             	sub    $0x30,%eax
  801808:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80180b:	eb 42                	jmp    80184f <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80180d:	8b 45 08             	mov    0x8(%ebp),%eax
  801810:	8a 00                	mov    (%eax),%al
  801812:	3c 60                	cmp    $0x60,%al
  801814:	7e 19                	jle    80182f <strtol+0xe4>
  801816:	8b 45 08             	mov    0x8(%ebp),%eax
  801819:	8a 00                	mov    (%eax),%al
  80181b:	3c 7a                	cmp    $0x7a,%al
  80181d:	7f 10                	jg     80182f <strtol+0xe4>
			dig = *s - 'a' + 10;
  80181f:	8b 45 08             	mov    0x8(%ebp),%eax
  801822:	8a 00                	mov    (%eax),%al
  801824:	0f be c0             	movsbl %al,%eax
  801827:	83 e8 57             	sub    $0x57,%eax
  80182a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80182d:	eb 20                	jmp    80184f <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80182f:	8b 45 08             	mov    0x8(%ebp),%eax
  801832:	8a 00                	mov    (%eax),%al
  801834:	3c 40                	cmp    $0x40,%al
  801836:	7e 39                	jle    801871 <strtol+0x126>
  801838:	8b 45 08             	mov    0x8(%ebp),%eax
  80183b:	8a 00                	mov    (%eax),%al
  80183d:	3c 5a                	cmp    $0x5a,%al
  80183f:	7f 30                	jg     801871 <strtol+0x126>
			dig = *s - 'A' + 10;
  801841:	8b 45 08             	mov    0x8(%ebp),%eax
  801844:	8a 00                	mov    (%eax),%al
  801846:	0f be c0             	movsbl %al,%eax
  801849:	83 e8 37             	sub    $0x37,%eax
  80184c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80184f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801852:	3b 45 10             	cmp    0x10(%ebp),%eax
  801855:	7d 19                	jge    801870 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801857:	ff 45 08             	incl   0x8(%ebp)
  80185a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80185d:	0f af 45 10          	imul   0x10(%ebp),%eax
  801861:	89 c2                	mov    %eax,%edx
  801863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801866:	01 d0                	add    %edx,%eax
  801868:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80186b:	e9 7b ff ff ff       	jmp    8017eb <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801870:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801871:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801875:	74 08                	je     80187f <strtol+0x134>
		*endptr = (char *) s;
  801877:	8b 45 0c             	mov    0xc(%ebp),%eax
  80187a:	8b 55 08             	mov    0x8(%ebp),%edx
  80187d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80187f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801883:	74 07                	je     80188c <strtol+0x141>
  801885:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801888:	f7 d8                	neg    %eax
  80188a:	eb 03                	jmp    80188f <strtol+0x144>
  80188c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80188f:	c9                   	leave  
  801890:	c3                   	ret    

00801891 <ltostr>:

void
ltostr(long value, char *str)
{
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
  801894:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801897:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80189e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8018a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018a9:	79 13                	jns    8018be <ltostr+0x2d>
	{
		neg = 1;
  8018ab:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8018b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b5:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8018b8:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8018bb:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018be:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c1:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018c6:	99                   	cltd   
  8018c7:	f7 f9                	idiv   %ecx
  8018c9:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018cf:	8d 50 01             	lea    0x1(%eax),%edx
  8018d2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018d5:	89 c2                	mov    %eax,%edx
  8018d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018da:	01 d0                	add    %edx,%eax
  8018dc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018df:	83 c2 30             	add    $0x30,%edx
  8018e2:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8018e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018e7:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018ec:	f7 e9                	imul   %ecx
  8018ee:	c1 fa 02             	sar    $0x2,%edx
  8018f1:	89 c8                	mov    %ecx,%eax
  8018f3:	c1 f8 1f             	sar    $0x1f,%eax
  8018f6:	29 c2                	sub    %eax,%edx
  8018f8:	89 d0                	mov    %edx,%eax
  8018fa:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8018fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801900:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801905:	f7 e9                	imul   %ecx
  801907:	c1 fa 02             	sar    $0x2,%edx
  80190a:	89 c8                	mov    %ecx,%eax
  80190c:	c1 f8 1f             	sar    $0x1f,%eax
  80190f:	29 c2                	sub    %eax,%edx
  801911:	89 d0                	mov    %edx,%eax
  801913:	c1 e0 02             	shl    $0x2,%eax
  801916:	01 d0                	add    %edx,%eax
  801918:	01 c0                	add    %eax,%eax
  80191a:	29 c1                	sub    %eax,%ecx
  80191c:	89 ca                	mov    %ecx,%edx
  80191e:	85 d2                	test   %edx,%edx
  801920:	75 9c                	jne    8018be <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801922:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801929:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80192c:	48                   	dec    %eax
  80192d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801930:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801934:	74 3d                	je     801973 <ltostr+0xe2>
		start = 1 ;
  801936:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80193d:	eb 34                	jmp    801973 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80193f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801942:	8b 45 0c             	mov    0xc(%ebp),%eax
  801945:	01 d0                	add    %edx,%eax
  801947:	8a 00                	mov    (%eax),%al
  801949:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80194c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80194f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801952:	01 c2                	add    %eax,%edx
  801954:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801957:	8b 45 0c             	mov    0xc(%ebp),%eax
  80195a:	01 c8                	add    %ecx,%eax
  80195c:	8a 00                	mov    (%eax),%al
  80195e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801960:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801963:	8b 45 0c             	mov    0xc(%ebp),%eax
  801966:	01 c2                	add    %eax,%edx
  801968:	8a 45 eb             	mov    -0x15(%ebp),%al
  80196b:	88 02                	mov    %al,(%edx)
		start++ ;
  80196d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801970:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801976:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801979:	7c c4                	jl     80193f <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80197b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80197e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801981:	01 d0                	add    %edx,%eax
  801983:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801986:	90                   	nop
  801987:	c9                   	leave  
  801988:	c3                   	ret    

00801989 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
  80198c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80198f:	ff 75 08             	pushl  0x8(%ebp)
  801992:	e8 54 fa ff ff       	call   8013eb <strlen>
  801997:	83 c4 04             	add    $0x4,%esp
  80199a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80199d:	ff 75 0c             	pushl  0xc(%ebp)
  8019a0:	e8 46 fa ff ff       	call   8013eb <strlen>
  8019a5:	83 c4 04             	add    $0x4,%esp
  8019a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8019ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8019b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8019b9:	eb 17                	jmp    8019d2 <strcconcat+0x49>
		final[s] = str1[s] ;
  8019bb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019be:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c1:	01 c2                	add    %eax,%edx
  8019c3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c9:	01 c8                	add    %ecx,%eax
  8019cb:	8a 00                	mov    (%eax),%al
  8019cd:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8019cf:	ff 45 fc             	incl   -0x4(%ebp)
  8019d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019d5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8019d8:	7c e1                	jl     8019bb <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8019da:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8019e1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8019e8:	eb 1f                	jmp    801a09 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8019ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019ed:	8d 50 01             	lea    0x1(%eax),%edx
  8019f0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8019f3:	89 c2                	mov    %eax,%edx
  8019f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f8:	01 c2                	add    %eax,%edx
  8019fa:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8019fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a00:	01 c8                	add    %ecx,%eax
  801a02:	8a 00                	mov    (%eax),%al
  801a04:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a06:	ff 45 f8             	incl   -0x8(%ebp)
  801a09:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a0c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a0f:	7c d9                	jl     8019ea <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a11:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a14:	8b 45 10             	mov    0x10(%ebp),%eax
  801a17:	01 d0                	add    %edx,%eax
  801a19:	c6 00 00             	movb   $0x0,(%eax)
}
  801a1c:	90                   	nop
  801a1d:	c9                   	leave  
  801a1e:	c3                   	ret    

00801a1f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a22:	8b 45 14             	mov    0x14(%ebp),%eax
  801a25:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a2b:	8b 45 14             	mov    0x14(%ebp),%eax
  801a2e:	8b 00                	mov    (%eax),%eax
  801a30:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a37:	8b 45 10             	mov    0x10(%ebp),%eax
  801a3a:	01 d0                	add    %edx,%eax
  801a3c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a42:	eb 0c                	jmp    801a50 <strsplit+0x31>
			*string++ = 0;
  801a44:	8b 45 08             	mov    0x8(%ebp),%eax
  801a47:	8d 50 01             	lea    0x1(%eax),%edx
  801a4a:	89 55 08             	mov    %edx,0x8(%ebp)
  801a4d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a50:	8b 45 08             	mov    0x8(%ebp),%eax
  801a53:	8a 00                	mov    (%eax),%al
  801a55:	84 c0                	test   %al,%al
  801a57:	74 18                	je     801a71 <strsplit+0x52>
  801a59:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5c:	8a 00                	mov    (%eax),%al
  801a5e:	0f be c0             	movsbl %al,%eax
  801a61:	50                   	push   %eax
  801a62:	ff 75 0c             	pushl  0xc(%ebp)
  801a65:	e8 13 fb ff ff       	call   80157d <strchr>
  801a6a:	83 c4 08             	add    $0x8,%esp
  801a6d:	85 c0                	test   %eax,%eax
  801a6f:	75 d3                	jne    801a44 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a71:	8b 45 08             	mov    0x8(%ebp),%eax
  801a74:	8a 00                	mov    (%eax),%al
  801a76:	84 c0                	test   %al,%al
  801a78:	74 5a                	je     801ad4 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a7a:	8b 45 14             	mov    0x14(%ebp),%eax
  801a7d:	8b 00                	mov    (%eax),%eax
  801a7f:	83 f8 0f             	cmp    $0xf,%eax
  801a82:	75 07                	jne    801a8b <strsplit+0x6c>
		{
			return 0;
  801a84:	b8 00 00 00 00       	mov    $0x0,%eax
  801a89:	eb 66                	jmp    801af1 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a8b:	8b 45 14             	mov    0x14(%ebp),%eax
  801a8e:	8b 00                	mov    (%eax),%eax
  801a90:	8d 48 01             	lea    0x1(%eax),%ecx
  801a93:	8b 55 14             	mov    0x14(%ebp),%edx
  801a96:	89 0a                	mov    %ecx,(%edx)
  801a98:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a9f:	8b 45 10             	mov    0x10(%ebp),%eax
  801aa2:	01 c2                	add    %eax,%edx
  801aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa7:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801aa9:	eb 03                	jmp    801aae <strsplit+0x8f>
			string++;
  801aab:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801aae:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab1:	8a 00                	mov    (%eax),%al
  801ab3:	84 c0                	test   %al,%al
  801ab5:	74 8b                	je     801a42 <strsplit+0x23>
  801ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aba:	8a 00                	mov    (%eax),%al
  801abc:	0f be c0             	movsbl %al,%eax
  801abf:	50                   	push   %eax
  801ac0:	ff 75 0c             	pushl  0xc(%ebp)
  801ac3:	e8 b5 fa ff ff       	call   80157d <strchr>
  801ac8:	83 c4 08             	add    $0x8,%esp
  801acb:	85 c0                	test   %eax,%eax
  801acd:	74 dc                	je     801aab <strsplit+0x8c>
			string++;
	}
  801acf:	e9 6e ff ff ff       	jmp    801a42 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801ad4:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801ad5:	8b 45 14             	mov    0x14(%ebp),%eax
  801ad8:	8b 00                	mov    (%eax),%eax
  801ada:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ae1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ae4:	01 d0                	add    %edx,%eax
  801ae6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801aec:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801af1:	c9                   	leave  
  801af2:	c3                   	ret    

00801af3 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
  801af6:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801af9:	a1 04 50 80 00       	mov    0x805004,%eax
  801afe:	85 c0                	test   %eax,%eax
  801b00:	74 1f                	je     801b21 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801b02:	e8 1d 00 00 00       	call   801b24 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801b07:	83 ec 0c             	sub    $0xc,%esp
  801b0a:	68 90 41 80 00       	push   $0x804190
  801b0f:	e8 55 f2 ff ff       	call   800d69 <cprintf>
  801b14:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801b17:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801b1e:	00 00 00 
	}
}
  801b21:	90                   	nop
  801b22:	c9                   	leave  
  801b23:	c3                   	ret    

00801b24 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
  801b27:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  801b2a:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801b31:	00 00 00 
  801b34:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801b3b:	00 00 00 
  801b3e:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801b45:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  801b48:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801b4f:	00 00 00 
  801b52:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801b59:	00 00 00 
  801b5c:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801b63:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  801b66:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801b6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b70:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b75:	2d 00 10 00 00       	sub    $0x1000,%eax
  801b7a:	a3 50 50 80 00       	mov    %eax,0x805050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801b7f:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801b86:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  801b89:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801b90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b93:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  801b98:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b9e:	ba 00 00 00 00       	mov    $0x0,%edx
  801ba3:	f7 75 f0             	divl   -0x10(%ebp)
  801ba6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ba9:	29 d0                	sub    %edx,%eax
  801bab:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  801bae:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801bb5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bb8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bbd:	2d 00 10 00 00       	sub    $0x1000,%eax
  801bc2:	83 ec 04             	sub    $0x4,%esp
  801bc5:	6a 06                	push   $0x6
  801bc7:	ff 75 e8             	pushl  -0x18(%ebp)
  801bca:	50                   	push   %eax
  801bcb:	e8 d4 05 00 00       	call   8021a4 <sys_allocate_chunk>
  801bd0:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801bd3:	a1 20 51 80 00       	mov    0x805120,%eax
  801bd8:	83 ec 0c             	sub    $0xc,%esp
  801bdb:	50                   	push   %eax
  801bdc:	e8 49 0c 00 00       	call   80282a <initialize_MemBlocksList>
  801be1:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  801be4:	a1 48 51 80 00       	mov    0x805148,%eax
  801be9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  801bec:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801bf0:	75 14                	jne    801c06 <initialize_dyn_block_system+0xe2>
  801bf2:	83 ec 04             	sub    $0x4,%esp
  801bf5:	68 b5 41 80 00       	push   $0x8041b5
  801bfa:	6a 39                	push   $0x39
  801bfc:	68 d3 41 80 00       	push   $0x8041d3
  801c01:	e8 af ee ff ff       	call   800ab5 <_panic>
  801c06:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c09:	8b 00                	mov    (%eax),%eax
  801c0b:	85 c0                	test   %eax,%eax
  801c0d:	74 10                	je     801c1f <initialize_dyn_block_system+0xfb>
  801c0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c12:	8b 00                	mov    (%eax),%eax
  801c14:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c17:	8b 52 04             	mov    0x4(%edx),%edx
  801c1a:	89 50 04             	mov    %edx,0x4(%eax)
  801c1d:	eb 0b                	jmp    801c2a <initialize_dyn_block_system+0x106>
  801c1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c22:	8b 40 04             	mov    0x4(%eax),%eax
  801c25:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801c2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c2d:	8b 40 04             	mov    0x4(%eax),%eax
  801c30:	85 c0                	test   %eax,%eax
  801c32:	74 0f                	je     801c43 <initialize_dyn_block_system+0x11f>
  801c34:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c37:	8b 40 04             	mov    0x4(%eax),%eax
  801c3a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c3d:	8b 12                	mov    (%edx),%edx
  801c3f:	89 10                	mov    %edx,(%eax)
  801c41:	eb 0a                	jmp    801c4d <initialize_dyn_block_system+0x129>
  801c43:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c46:	8b 00                	mov    (%eax),%eax
  801c48:	a3 48 51 80 00       	mov    %eax,0x805148
  801c4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c50:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c56:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c59:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801c60:	a1 54 51 80 00       	mov    0x805154,%eax
  801c65:	48                   	dec    %eax
  801c66:	a3 54 51 80 00       	mov    %eax,0x805154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  801c6b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c6e:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  801c75:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c78:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  801c7f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c83:	75 14                	jne    801c99 <initialize_dyn_block_system+0x175>
  801c85:	83 ec 04             	sub    $0x4,%esp
  801c88:	68 e0 41 80 00       	push   $0x8041e0
  801c8d:	6a 3f                	push   $0x3f
  801c8f:	68 d3 41 80 00       	push   $0x8041d3
  801c94:	e8 1c ee ff ff       	call   800ab5 <_panic>
  801c99:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801c9f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ca2:	89 10                	mov    %edx,(%eax)
  801ca4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ca7:	8b 00                	mov    (%eax),%eax
  801ca9:	85 c0                	test   %eax,%eax
  801cab:	74 0d                	je     801cba <initialize_dyn_block_system+0x196>
  801cad:	a1 38 51 80 00       	mov    0x805138,%eax
  801cb2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801cb5:	89 50 04             	mov    %edx,0x4(%eax)
  801cb8:	eb 08                	jmp    801cc2 <initialize_dyn_block_system+0x19e>
  801cba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cbd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801cc2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cc5:	a3 38 51 80 00       	mov    %eax,0x805138
  801cca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ccd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801cd4:	a1 44 51 80 00       	mov    0x805144,%eax
  801cd9:	40                   	inc    %eax
  801cda:	a3 44 51 80 00       	mov    %eax,0x805144

}
  801cdf:	90                   	nop
  801ce0:	c9                   	leave  
  801ce1:	c3                   	ret    

00801ce2 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801ce2:	55                   	push   %ebp
  801ce3:	89 e5                	mov    %esp,%ebp
  801ce5:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ce8:	e8 06 fe ff ff       	call   801af3 <InitializeUHeap>
	if (size == 0) return NULL ;
  801ced:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801cf1:	75 07                	jne    801cfa <malloc+0x18>
  801cf3:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf8:	eb 7d                	jmp    801d77 <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  801cfa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801d01:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d08:	8b 55 08             	mov    0x8(%ebp),%edx
  801d0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d0e:	01 d0                	add    %edx,%eax
  801d10:	48                   	dec    %eax
  801d11:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d17:	ba 00 00 00 00       	mov    $0x0,%edx
  801d1c:	f7 75 f0             	divl   -0x10(%ebp)
  801d1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d22:	29 d0                	sub    %edx,%eax
  801d24:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  801d27:	e8 46 08 00 00       	call   802572 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d2c:	83 f8 01             	cmp    $0x1,%eax
  801d2f:	75 07                	jne    801d38 <malloc+0x56>
  801d31:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  801d38:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  801d3c:	75 34                	jne    801d72 <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  801d3e:	83 ec 0c             	sub    $0xc,%esp
  801d41:	ff 75 e8             	pushl  -0x18(%ebp)
  801d44:	e8 73 0e 00 00       	call   802bbc <alloc_block_FF>
  801d49:	83 c4 10             	add    $0x10,%esp
  801d4c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  801d4f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801d53:	74 16                	je     801d6b <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  801d55:	83 ec 0c             	sub    $0xc,%esp
  801d58:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d5b:	e8 ff 0b 00 00       	call   80295f <insert_sorted_allocList>
  801d60:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  801d63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d66:	8b 40 08             	mov    0x8(%eax),%eax
  801d69:	eb 0c                	jmp    801d77 <malloc+0x95>
	             }
	             else
	             	return NULL;
  801d6b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d70:	eb 05                	jmp    801d77 <malloc+0x95>
	      	  }
	          else
	               return NULL;
  801d72:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  801d77:	c9                   	leave  
  801d78:	c3                   	ret    

00801d79 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801d79:	55                   	push   %ebp
  801d7a:	89 e5                	mov    %esp,%ebp
  801d7c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  801d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d82:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  801d85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d88:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d8e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d93:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  801d96:	83 ec 08             	sub    $0x8,%esp
  801d99:	ff 75 f4             	pushl  -0xc(%ebp)
  801d9c:	68 40 50 80 00       	push   $0x805040
  801da1:	e8 61 0b 00 00       	call   802907 <find_block>
  801da6:	83 c4 10             	add    $0x10,%esp
  801da9:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  801dac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801db0:	0f 84 a5 00 00 00    	je     801e5b <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  801db6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801db9:	8b 40 0c             	mov    0xc(%eax),%eax
  801dbc:	83 ec 08             	sub    $0x8,%esp
  801dbf:	50                   	push   %eax
  801dc0:	ff 75 f4             	pushl  -0xc(%ebp)
  801dc3:	e8 a4 03 00 00       	call   80216c <sys_free_user_mem>
  801dc8:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  801dcb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801dcf:	75 17                	jne    801de8 <free+0x6f>
  801dd1:	83 ec 04             	sub    $0x4,%esp
  801dd4:	68 b5 41 80 00       	push   $0x8041b5
  801dd9:	68 87 00 00 00       	push   $0x87
  801dde:	68 d3 41 80 00       	push   $0x8041d3
  801de3:	e8 cd ec ff ff       	call   800ab5 <_panic>
  801de8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801deb:	8b 00                	mov    (%eax),%eax
  801ded:	85 c0                	test   %eax,%eax
  801def:	74 10                	je     801e01 <free+0x88>
  801df1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801df4:	8b 00                	mov    (%eax),%eax
  801df6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801df9:	8b 52 04             	mov    0x4(%edx),%edx
  801dfc:	89 50 04             	mov    %edx,0x4(%eax)
  801dff:	eb 0b                	jmp    801e0c <free+0x93>
  801e01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e04:	8b 40 04             	mov    0x4(%eax),%eax
  801e07:	a3 44 50 80 00       	mov    %eax,0x805044
  801e0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e0f:	8b 40 04             	mov    0x4(%eax),%eax
  801e12:	85 c0                	test   %eax,%eax
  801e14:	74 0f                	je     801e25 <free+0xac>
  801e16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e19:	8b 40 04             	mov    0x4(%eax),%eax
  801e1c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e1f:	8b 12                	mov    (%edx),%edx
  801e21:	89 10                	mov    %edx,(%eax)
  801e23:	eb 0a                	jmp    801e2f <free+0xb6>
  801e25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e28:	8b 00                	mov    (%eax),%eax
  801e2a:	a3 40 50 80 00       	mov    %eax,0x805040
  801e2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e3b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e42:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801e47:	48                   	dec    %eax
  801e48:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(theBlock);
  801e4d:	83 ec 0c             	sub    $0xc,%esp
  801e50:	ff 75 ec             	pushl  -0x14(%ebp)
  801e53:	e8 37 12 00 00       	call   80308f <insert_sorted_with_merge_freeList>
  801e58:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  801e5b:	90                   	nop
  801e5c:	c9                   	leave  
  801e5d:	c3                   	ret    

00801e5e <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801e5e:	55                   	push   %ebp
  801e5f:	89 e5                	mov    %esp,%ebp
  801e61:	83 ec 38             	sub    $0x38,%esp
  801e64:	8b 45 10             	mov    0x10(%ebp),%eax
  801e67:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e6a:	e8 84 fc ff ff       	call   801af3 <InitializeUHeap>
	if (size == 0) return NULL ;
  801e6f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e73:	75 07                	jne    801e7c <smalloc+0x1e>
  801e75:	b8 00 00 00 00       	mov    $0x0,%eax
  801e7a:	eb 7e                	jmp    801efa <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  801e7c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801e83:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801e8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e90:	01 d0                	add    %edx,%eax
  801e92:	48                   	dec    %eax
  801e93:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801e96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e99:	ba 00 00 00 00       	mov    $0x0,%edx
  801e9e:	f7 75 f0             	divl   -0x10(%ebp)
  801ea1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ea4:	29 d0                	sub    %edx,%eax
  801ea6:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801ea9:	e8 c4 06 00 00       	call   802572 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801eae:	83 f8 01             	cmp    $0x1,%eax
  801eb1:	75 42                	jne    801ef5 <smalloc+0x97>

		  va = malloc(newsize) ;
  801eb3:	83 ec 0c             	sub    $0xc,%esp
  801eb6:	ff 75 e8             	pushl  -0x18(%ebp)
  801eb9:	e8 24 fe ff ff       	call   801ce2 <malloc>
  801ebe:	83 c4 10             	add    $0x10,%esp
  801ec1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  801ec4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801ec8:	74 24                	je     801eee <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  801eca:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801ece:	ff 75 e4             	pushl  -0x1c(%ebp)
  801ed1:	50                   	push   %eax
  801ed2:	ff 75 e8             	pushl  -0x18(%ebp)
  801ed5:	ff 75 08             	pushl  0x8(%ebp)
  801ed8:	e8 1a 04 00 00       	call   8022f7 <sys_createSharedObject>
  801edd:	83 c4 10             	add    $0x10,%esp
  801ee0:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  801ee3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ee7:	78 0c                	js     801ef5 <smalloc+0x97>
					  return va ;
  801ee9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801eec:	eb 0c                	jmp    801efa <smalloc+0x9c>
				 }
				 else
					return NULL;
  801eee:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef3:	eb 05                	jmp    801efa <smalloc+0x9c>
	  }
		  return NULL ;
  801ef5:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801efa:	c9                   	leave  
  801efb:	c3                   	ret    

00801efc <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801efc:	55                   	push   %ebp
  801efd:	89 e5                	mov    %esp,%ebp
  801eff:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f02:	e8 ec fb ff ff       	call   801af3 <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  801f07:	83 ec 08             	sub    $0x8,%esp
  801f0a:	ff 75 0c             	pushl  0xc(%ebp)
  801f0d:	ff 75 08             	pushl  0x8(%ebp)
  801f10:	e8 0c 04 00 00       	call   802321 <sys_getSizeOfSharedObject>
  801f15:	83 c4 10             	add    $0x10,%esp
  801f18:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  801f1b:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801f1f:	75 07                	jne    801f28 <sget+0x2c>
  801f21:	b8 00 00 00 00       	mov    $0x0,%eax
  801f26:	eb 75                	jmp    801f9d <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801f28:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801f2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f35:	01 d0                	add    %edx,%eax
  801f37:	48                   	dec    %eax
  801f38:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801f3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f3e:	ba 00 00 00 00       	mov    $0x0,%edx
  801f43:	f7 75 f0             	divl   -0x10(%ebp)
  801f46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f49:	29 d0                	sub    %edx,%eax
  801f4b:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  801f4e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801f55:	e8 18 06 00 00       	call   802572 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f5a:	83 f8 01             	cmp    $0x1,%eax
  801f5d:	75 39                	jne    801f98 <sget+0x9c>

		  va = malloc(newsize) ;
  801f5f:	83 ec 0c             	sub    $0xc,%esp
  801f62:	ff 75 e8             	pushl  -0x18(%ebp)
  801f65:	e8 78 fd ff ff       	call   801ce2 <malloc>
  801f6a:	83 c4 10             	add    $0x10,%esp
  801f6d:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  801f70:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801f74:	74 22                	je     801f98 <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  801f76:	83 ec 04             	sub    $0x4,%esp
  801f79:	ff 75 e0             	pushl  -0x20(%ebp)
  801f7c:	ff 75 0c             	pushl  0xc(%ebp)
  801f7f:	ff 75 08             	pushl  0x8(%ebp)
  801f82:	e8 b7 03 00 00       	call   80233e <sys_getSharedObject>
  801f87:	83 c4 10             	add    $0x10,%esp
  801f8a:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  801f8d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801f91:	78 05                	js     801f98 <sget+0x9c>
					  return va;
  801f93:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f96:	eb 05                	jmp    801f9d <sget+0xa1>
				  }
			  }
     }
         return NULL;
  801f98:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  801f9d:	c9                   	leave  
  801f9e:	c3                   	ret    

00801f9f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801f9f:	55                   	push   %ebp
  801fa0:	89 e5                	mov    %esp,%ebp
  801fa2:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801fa5:	e8 49 fb ff ff       	call   801af3 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801faa:	83 ec 04             	sub    $0x4,%esp
  801fad:	68 04 42 80 00       	push   $0x804204
  801fb2:	68 1e 01 00 00       	push   $0x11e
  801fb7:	68 d3 41 80 00       	push   $0x8041d3
  801fbc:	e8 f4 ea ff ff       	call   800ab5 <_panic>

00801fc1 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801fc1:	55                   	push   %ebp
  801fc2:	89 e5                	mov    %esp,%ebp
  801fc4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801fc7:	83 ec 04             	sub    $0x4,%esp
  801fca:	68 2c 42 80 00       	push   $0x80422c
  801fcf:	68 32 01 00 00       	push   $0x132
  801fd4:	68 d3 41 80 00       	push   $0x8041d3
  801fd9:	e8 d7 ea ff ff       	call   800ab5 <_panic>

00801fde <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801fde:	55                   	push   %ebp
  801fdf:	89 e5                	mov    %esp,%ebp
  801fe1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801fe4:	83 ec 04             	sub    $0x4,%esp
  801fe7:	68 50 42 80 00       	push   $0x804250
  801fec:	68 3d 01 00 00       	push   $0x13d
  801ff1:	68 d3 41 80 00       	push   $0x8041d3
  801ff6:	e8 ba ea ff ff       	call   800ab5 <_panic>

00801ffb <shrink>:

}
void shrink(uint32 newSize)
{
  801ffb:	55                   	push   %ebp
  801ffc:	89 e5                	mov    %esp,%ebp
  801ffe:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802001:	83 ec 04             	sub    $0x4,%esp
  802004:	68 50 42 80 00       	push   $0x804250
  802009:	68 42 01 00 00       	push   $0x142
  80200e:	68 d3 41 80 00       	push   $0x8041d3
  802013:	e8 9d ea ff ff       	call   800ab5 <_panic>

00802018 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802018:	55                   	push   %ebp
  802019:	89 e5                	mov    %esp,%ebp
  80201b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80201e:	83 ec 04             	sub    $0x4,%esp
  802021:	68 50 42 80 00       	push   $0x804250
  802026:	68 47 01 00 00       	push   $0x147
  80202b:	68 d3 41 80 00       	push   $0x8041d3
  802030:	e8 80 ea ff ff       	call   800ab5 <_panic>

00802035 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802035:	55                   	push   %ebp
  802036:	89 e5                	mov    %esp,%ebp
  802038:	57                   	push   %edi
  802039:	56                   	push   %esi
  80203a:	53                   	push   %ebx
  80203b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80203e:	8b 45 08             	mov    0x8(%ebp),%eax
  802041:	8b 55 0c             	mov    0xc(%ebp),%edx
  802044:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802047:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80204a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80204d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802050:	cd 30                	int    $0x30
  802052:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802055:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802058:	83 c4 10             	add    $0x10,%esp
  80205b:	5b                   	pop    %ebx
  80205c:	5e                   	pop    %esi
  80205d:	5f                   	pop    %edi
  80205e:	5d                   	pop    %ebp
  80205f:	c3                   	ret    

00802060 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802060:	55                   	push   %ebp
  802061:	89 e5                	mov    %esp,%ebp
  802063:	83 ec 04             	sub    $0x4,%esp
  802066:	8b 45 10             	mov    0x10(%ebp),%eax
  802069:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80206c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802070:	8b 45 08             	mov    0x8(%ebp),%eax
  802073:	6a 00                	push   $0x0
  802075:	6a 00                	push   $0x0
  802077:	52                   	push   %edx
  802078:	ff 75 0c             	pushl  0xc(%ebp)
  80207b:	50                   	push   %eax
  80207c:	6a 00                	push   $0x0
  80207e:	e8 b2 ff ff ff       	call   802035 <syscall>
  802083:	83 c4 18             	add    $0x18,%esp
}
  802086:	90                   	nop
  802087:	c9                   	leave  
  802088:	c3                   	ret    

00802089 <sys_cgetc>:

int
sys_cgetc(void)
{
  802089:	55                   	push   %ebp
  80208a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80208c:	6a 00                	push   $0x0
  80208e:	6a 00                	push   $0x0
  802090:	6a 00                	push   $0x0
  802092:	6a 00                	push   $0x0
  802094:	6a 00                	push   $0x0
  802096:	6a 01                	push   $0x1
  802098:	e8 98 ff ff ff       	call   802035 <syscall>
  80209d:	83 c4 18             	add    $0x18,%esp
}
  8020a0:	c9                   	leave  
  8020a1:	c3                   	ret    

008020a2 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8020a2:	55                   	push   %ebp
  8020a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8020a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 00                	push   $0x0
  8020b1:	52                   	push   %edx
  8020b2:	50                   	push   %eax
  8020b3:	6a 05                	push   $0x5
  8020b5:	e8 7b ff ff ff       	call   802035 <syscall>
  8020ba:	83 c4 18             	add    $0x18,%esp
}
  8020bd:	c9                   	leave  
  8020be:	c3                   	ret    

008020bf <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8020bf:	55                   	push   %ebp
  8020c0:	89 e5                	mov    %esp,%ebp
  8020c2:	56                   	push   %esi
  8020c3:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8020c4:	8b 75 18             	mov    0x18(%ebp),%esi
  8020c7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020ca:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d3:	56                   	push   %esi
  8020d4:	53                   	push   %ebx
  8020d5:	51                   	push   %ecx
  8020d6:	52                   	push   %edx
  8020d7:	50                   	push   %eax
  8020d8:	6a 06                	push   $0x6
  8020da:	e8 56 ff ff ff       	call   802035 <syscall>
  8020df:	83 c4 18             	add    $0x18,%esp
}
  8020e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020e5:	5b                   	pop    %ebx
  8020e6:	5e                   	pop    %esi
  8020e7:	5d                   	pop    %ebp
  8020e8:	c3                   	ret    

008020e9 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8020e9:	55                   	push   %ebp
  8020ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8020ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f2:	6a 00                	push   $0x0
  8020f4:	6a 00                	push   $0x0
  8020f6:	6a 00                	push   $0x0
  8020f8:	52                   	push   %edx
  8020f9:	50                   	push   %eax
  8020fa:	6a 07                	push   $0x7
  8020fc:	e8 34 ff ff ff       	call   802035 <syscall>
  802101:	83 c4 18             	add    $0x18,%esp
}
  802104:	c9                   	leave  
  802105:	c3                   	ret    

00802106 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802106:	55                   	push   %ebp
  802107:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802109:	6a 00                	push   $0x0
  80210b:	6a 00                	push   $0x0
  80210d:	6a 00                	push   $0x0
  80210f:	ff 75 0c             	pushl  0xc(%ebp)
  802112:	ff 75 08             	pushl  0x8(%ebp)
  802115:	6a 08                	push   $0x8
  802117:	e8 19 ff ff ff       	call   802035 <syscall>
  80211c:	83 c4 18             	add    $0x18,%esp
}
  80211f:	c9                   	leave  
  802120:	c3                   	ret    

00802121 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802121:	55                   	push   %ebp
  802122:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802124:	6a 00                	push   $0x0
  802126:	6a 00                	push   $0x0
  802128:	6a 00                	push   $0x0
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	6a 09                	push   $0x9
  802130:	e8 00 ff ff ff       	call   802035 <syscall>
  802135:	83 c4 18             	add    $0x18,%esp
}
  802138:	c9                   	leave  
  802139:	c3                   	ret    

0080213a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80213a:	55                   	push   %ebp
  80213b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80213d:	6a 00                	push   $0x0
  80213f:	6a 00                	push   $0x0
  802141:	6a 00                	push   $0x0
  802143:	6a 00                	push   $0x0
  802145:	6a 00                	push   $0x0
  802147:	6a 0a                	push   $0xa
  802149:	e8 e7 fe ff ff       	call   802035 <syscall>
  80214e:	83 c4 18             	add    $0x18,%esp
}
  802151:	c9                   	leave  
  802152:	c3                   	ret    

00802153 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802153:	55                   	push   %ebp
  802154:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802156:	6a 00                	push   $0x0
  802158:	6a 00                	push   $0x0
  80215a:	6a 00                	push   $0x0
  80215c:	6a 00                	push   $0x0
  80215e:	6a 00                	push   $0x0
  802160:	6a 0b                	push   $0xb
  802162:	e8 ce fe ff ff       	call   802035 <syscall>
  802167:	83 c4 18             	add    $0x18,%esp
}
  80216a:	c9                   	leave  
  80216b:	c3                   	ret    

0080216c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80216c:	55                   	push   %ebp
  80216d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80216f:	6a 00                	push   $0x0
  802171:	6a 00                	push   $0x0
  802173:	6a 00                	push   $0x0
  802175:	ff 75 0c             	pushl  0xc(%ebp)
  802178:	ff 75 08             	pushl  0x8(%ebp)
  80217b:	6a 0f                	push   $0xf
  80217d:	e8 b3 fe ff ff       	call   802035 <syscall>
  802182:	83 c4 18             	add    $0x18,%esp
	return;
  802185:	90                   	nop
}
  802186:	c9                   	leave  
  802187:	c3                   	ret    

00802188 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802188:	55                   	push   %ebp
  802189:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80218b:	6a 00                	push   $0x0
  80218d:	6a 00                	push   $0x0
  80218f:	6a 00                	push   $0x0
  802191:	ff 75 0c             	pushl  0xc(%ebp)
  802194:	ff 75 08             	pushl  0x8(%ebp)
  802197:	6a 10                	push   $0x10
  802199:	e8 97 fe ff ff       	call   802035 <syscall>
  80219e:	83 c4 18             	add    $0x18,%esp
	return ;
  8021a1:	90                   	nop
}
  8021a2:	c9                   	leave  
  8021a3:	c3                   	ret    

008021a4 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8021a4:	55                   	push   %ebp
  8021a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8021a7:	6a 00                	push   $0x0
  8021a9:	6a 00                	push   $0x0
  8021ab:	ff 75 10             	pushl  0x10(%ebp)
  8021ae:	ff 75 0c             	pushl  0xc(%ebp)
  8021b1:	ff 75 08             	pushl  0x8(%ebp)
  8021b4:	6a 11                	push   $0x11
  8021b6:	e8 7a fe ff ff       	call   802035 <syscall>
  8021bb:	83 c4 18             	add    $0x18,%esp
	return ;
  8021be:	90                   	nop
}
  8021bf:	c9                   	leave  
  8021c0:	c3                   	ret    

008021c1 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8021c1:	55                   	push   %ebp
  8021c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8021c4:	6a 00                	push   $0x0
  8021c6:	6a 00                	push   $0x0
  8021c8:	6a 00                	push   $0x0
  8021ca:	6a 00                	push   $0x0
  8021cc:	6a 00                	push   $0x0
  8021ce:	6a 0c                	push   $0xc
  8021d0:	e8 60 fe ff ff       	call   802035 <syscall>
  8021d5:	83 c4 18             	add    $0x18,%esp
}
  8021d8:	c9                   	leave  
  8021d9:	c3                   	ret    

008021da <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8021da:	55                   	push   %ebp
  8021db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8021dd:	6a 00                	push   $0x0
  8021df:	6a 00                	push   $0x0
  8021e1:	6a 00                	push   $0x0
  8021e3:	6a 00                	push   $0x0
  8021e5:	ff 75 08             	pushl  0x8(%ebp)
  8021e8:	6a 0d                	push   $0xd
  8021ea:	e8 46 fe ff ff       	call   802035 <syscall>
  8021ef:	83 c4 18             	add    $0x18,%esp
}
  8021f2:	c9                   	leave  
  8021f3:	c3                   	ret    

008021f4 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8021f4:	55                   	push   %ebp
  8021f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8021f7:	6a 00                	push   $0x0
  8021f9:	6a 00                	push   $0x0
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	6a 0e                	push   $0xe
  802203:	e8 2d fe ff ff       	call   802035 <syscall>
  802208:	83 c4 18             	add    $0x18,%esp
}
  80220b:	90                   	nop
  80220c:	c9                   	leave  
  80220d:	c3                   	ret    

0080220e <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80220e:	55                   	push   %ebp
  80220f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802211:	6a 00                	push   $0x0
  802213:	6a 00                	push   $0x0
  802215:	6a 00                	push   $0x0
  802217:	6a 00                	push   $0x0
  802219:	6a 00                	push   $0x0
  80221b:	6a 13                	push   $0x13
  80221d:	e8 13 fe ff ff       	call   802035 <syscall>
  802222:	83 c4 18             	add    $0x18,%esp
}
  802225:	90                   	nop
  802226:	c9                   	leave  
  802227:	c3                   	ret    

00802228 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802228:	55                   	push   %ebp
  802229:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80222b:	6a 00                	push   $0x0
  80222d:	6a 00                	push   $0x0
  80222f:	6a 00                	push   $0x0
  802231:	6a 00                	push   $0x0
  802233:	6a 00                	push   $0x0
  802235:	6a 14                	push   $0x14
  802237:	e8 f9 fd ff ff       	call   802035 <syscall>
  80223c:	83 c4 18             	add    $0x18,%esp
}
  80223f:	90                   	nop
  802240:	c9                   	leave  
  802241:	c3                   	ret    

00802242 <sys_cputc>:


void
sys_cputc(const char c)
{
  802242:	55                   	push   %ebp
  802243:	89 e5                	mov    %esp,%ebp
  802245:	83 ec 04             	sub    $0x4,%esp
  802248:	8b 45 08             	mov    0x8(%ebp),%eax
  80224b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80224e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802252:	6a 00                	push   $0x0
  802254:	6a 00                	push   $0x0
  802256:	6a 00                	push   $0x0
  802258:	6a 00                	push   $0x0
  80225a:	50                   	push   %eax
  80225b:	6a 15                	push   $0x15
  80225d:	e8 d3 fd ff ff       	call   802035 <syscall>
  802262:	83 c4 18             	add    $0x18,%esp
}
  802265:	90                   	nop
  802266:	c9                   	leave  
  802267:	c3                   	ret    

00802268 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802268:	55                   	push   %ebp
  802269:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80226b:	6a 00                	push   $0x0
  80226d:	6a 00                	push   $0x0
  80226f:	6a 00                	push   $0x0
  802271:	6a 00                	push   $0x0
  802273:	6a 00                	push   $0x0
  802275:	6a 16                	push   $0x16
  802277:	e8 b9 fd ff ff       	call   802035 <syscall>
  80227c:	83 c4 18             	add    $0x18,%esp
}
  80227f:	90                   	nop
  802280:	c9                   	leave  
  802281:	c3                   	ret    

00802282 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802282:	55                   	push   %ebp
  802283:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802285:	8b 45 08             	mov    0x8(%ebp),%eax
  802288:	6a 00                	push   $0x0
  80228a:	6a 00                	push   $0x0
  80228c:	6a 00                	push   $0x0
  80228e:	ff 75 0c             	pushl  0xc(%ebp)
  802291:	50                   	push   %eax
  802292:	6a 17                	push   $0x17
  802294:	e8 9c fd ff ff       	call   802035 <syscall>
  802299:	83 c4 18             	add    $0x18,%esp
}
  80229c:	c9                   	leave  
  80229d:	c3                   	ret    

0080229e <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80229e:	55                   	push   %ebp
  80229f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a7:	6a 00                	push   $0x0
  8022a9:	6a 00                	push   $0x0
  8022ab:	6a 00                	push   $0x0
  8022ad:	52                   	push   %edx
  8022ae:	50                   	push   %eax
  8022af:	6a 1a                	push   $0x1a
  8022b1:	e8 7f fd ff ff       	call   802035 <syscall>
  8022b6:	83 c4 18             	add    $0x18,%esp
}
  8022b9:	c9                   	leave  
  8022ba:	c3                   	ret    

008022bb <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022bb:	55                   	push   %ebp
  8022bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c4:	6a 00                	push   $0x0
  8022c6:	6a 00                	push   $0x0
  8022c8:	6a 00                	push   $0x0
  8022ca:	52                   	push   %edx
  8022cb:	50                   	push   %eax
  8022cc:	6a 18                	push   $0x18
  8022ce:	e8 62 fd ff ff       	call   802035 <syscall>
  8022d3:	83 c4 18             	add    $0x18,%esp
}
  8022d6:	90                   	nop
  8022d7:	c9                   	leave  
  8022d8:	c3                   	ret    

008022d9 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022d9:	55                   	push   %ebp
  8022da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022df:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e2:	6a 00                	push   $0x0
  8022e4:	6a 00                	push   $0x0
  8022e6:	6a 00                	push   $0x0
  8022e8:	52                   	push   %edx
  8022e9:	50                   	push   %eax
  8022ea:	6a 19                	push   $0x19
  8022ec:	e8 44 fd ff ff       	call   802035 <syscall>
  8022f1:	83 c4 18             	add    $0x18,%esp
}
  8022f4:	90                   	nop
  8022f5:	c9                   	leave  
  8022f6:	c3                   	ret    

008022f7 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8022f7:	55                   	push   %ebp
  8022f8:	89 e5                	mov    %esp,%ebp
  8022fa:	83 ec 04             	sub    $0x4,%esp
  8022fd:	8b 45 10             	mov    0x10(%ebp),%eax
  802300:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802303:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802306:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80230a:	8b 45 08             	mov    0x8(%ebp),%eax
  80230d:	6a 00                	push   $0x0
  80230f:	51                   	push   %ecx
  802310:	52                   	push   %edx
  802311:	ff 75 0c             	pushl  0xc(%ebp)
  802314:	50                   	push   %eax
  802315:	6a 1b                	push   $0x1b
  802317:	e8 19 fd ff ff       	call   802035 <syscall>
  80231c:	83 c4 18             	add    $0x18,%esp
}
  80231f:	c9                   	leave  
  802320:	c3                   	ret    

00802321 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802321:	55                   	push   %ebp
  802322:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802324:	8b 55 0c             	mov    0xc(%ebp),%edx
  802327:	8b 45 08             	mov    0x8(%ebp),%eax
  80232a:	6a 00                	push   $0x0
  80232c:	6a 00                	push   $0x0
  80232e:	6a 00                	push   $0x0
  802330:	52                   	push   %edx
  802331:	50                   	push   %eax
  802332:	6a 1c                	push   $0x1c
  802334:	e8 fc fc ff ff       	call   802035 <syscall>
  802339:	83 c4 18             	add    $0x18,%esp
}
  80233c:	c9                   	leave  
  80233d:	c3                   	ret    

0080233e <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80233e:	55                   	push   %ebp
  80233f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802341:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802344:	8b 55 0c             	mov    0xc(%ebp),%edx
  802347:	8b 45 08             	mov    0x8(%ebp),%eax
  80234a:	6a 00                	push   $0x0
  80234c:	6a 00                	push   $0x0
  80234e:	51                   	push   %ecx
  80234f:	52                   	push   %edx
  802350:	50                   	push   %eax
  802351:	6a 1d                	push   $0x1d
  802353:	e8 dd fc ff ff       	call   802035 <syscall>
  802358:	83 c4 18             	add    $0x18,%esp
}
  80235b:	c9                   	leave  
  80235c:	c3                   	ret    

0080235d <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80235d:	55                   	push   %ebp
  80235e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802360:	8b 55 0c             	mov    0xc(%ebp),%edx
  802363:	8b 45 08             	mov    0x8(%ebp),%eax
  802366:	6a 00                	push   $0x0
  802368:	6a 00                	push   $0x0
  80236a:	6a 00                	push   $0x0
  80236c:	52                   	push   %edx
  80236d:	50                   	push   %eax
  80236e:	6a 1e                	push   $0x1e
  802370:	e8 c0 fc ff ff       	call   802035 <syscall>
  802375:	83 c4 18             	add    $0x18,%esp
}
  802378:	c9                   	leave  
  802379:	c3                   	ret    

0080237a <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80237a:	55                   	push   %ebp
  80237b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80237d:	6a 00                	push   $0x0
  80237f:	6a 00                	push   $0x0
  802381:	6a 00                	push   $0x0
  802383:	6a 00                	push   $0x0
  802385:	6a 00                	push   $0x0
  802387:	6a 1f                	push   $0x1f
  802389:	e8 a7 fc ff ff       	call   802035 <syscall>
  80238e:	83 c4 18             	add    $0x18,%esp
}
  802391:	c9                   	leave  
  802392:	c3                   	ret    

00802393 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802393:	55                   	push   %ebp
  802394:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802396:	8b 45 08             	mov    0x8(%ebp),%eax
  802399:	6a 00                	push   $0x0
  80239b:	ff 75 14             	pushl  0x14(%ebp)
  80239e:	ff 75 10             	pushl  0x10(%ebp)
  8023a1:	ff 75 0c             	pushl  0xc(%ebp)
  8023a4:	50                   	push   %eax
  8023a5:	6a 20                	push   $0x20
  8023a7:	e8 89 fc ff ff       	call   802035 <syscall>
  8023ac:	83 c4 18             	add    $0x18,%esp
}
  8023af:	c9                   	leave  
  8023b0:	c3                   	ret    

008023b1 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8023b1:	55                   	push   %ebp
  8023b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8023b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b7:	6a 00                	push   $0x0
  8023b9:	6a 00                	push   $0x0
  8023bb:	6a 00                	push   $0x0
  8023bd:	6a 00                	push   $0x0
  8023bf:	50                   	push   %eax
  8023c0:	6a 21                	push   $0x21
  8023c2:	e8 6e fc ff ff       	call   802035 <syscall>
  8023c7:	83 c4 18             	add    $0x18,%esp
}
  8023ca:	90                   	nop
  8023cb:	c9                   	leave  
  8023cc:	c3                   	ret    

008023cd <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8023cd:	55                   	push   %ebp
  8023ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8023d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d3:	6a 00                	push   $0x0
  8023d5:	6a 00                	push   $0x0
  8023d7:	6a 00                	push   $0x0
  8023d9:	6a 00                	push   $0x0
  8023db:	50                   	push   %eax
  8023dc:	6a 22                	push   $0x22
  8023de:	e8 52 fc ff ff       	call   802035 <syscall>
  8023e3:	83 c4 18             	add    $0x18,%esp
}
  8023e6:	c9                   	leave  
  8023e7:	c3                   	ret    

008023e8 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8023e8:	55                   	push   %ebp
  8023e9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8023eb:	6a 00                	push   $0x0
  8023ed:	6a 00                	push   $0x0
  8023ef:	6a 00                	push   $0x0
  8023f1:	6a 00                	push   $0x0
  8023f3:	6a 00                	push   $0x0
  8023f5:	6a 02                	push   $0x2
  8023f7:	e8 39 fc ff ff       	call   802035 <syscall>
  8023fc:	83 c4 18             	add    $0x18,%esp
}
  8023ff:	c9                   	leave  
  802400:	c3                   	ret    

00802401 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802401:	55                   	push   %ebp
  802402:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802404:	6a 00                	push   $0x0
  802406:	6a 00                	push   $0x0
  802408:	6a 00                	push   $0x0
  80240a:	6a 00                	push   $0x0
  80240c:	6a 00                	push   $0x0
  80240e:	6a 03                	push   $0x3
  802410:	e8 20 fc ff ff       	call   802035 <syscall>
  802415:	83 c4 18             	add    $0x18,%esp
}
  802418:	c9                   	leave  
  802419:	c3                   	ret    

0080241a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80241a:	55                   	push   %ebp
  80241b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80241d:	6a 00                	push   $0x0
  80241f:	6a 00                	push   $0x0
  802421:	6a 00                	push   $0x0
  802423:	6a 00                	push   $0x0
  802425:	6a 00                	push   $0x0
  802427:	6a 04                	push   $0x4
  802429:	e8 07 fc ff ff       	call   802035 <syscall>
  80242e:	83 c4 18             	add    $0x18,%esp
}
  802431:	c9                   	leave  
  802432:	c3                   	ret    

00802433 <sys_exit_env>:


void sys_exit_env(void)
{
  802433:	55                   	push   %ebp
  802434:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802436:	6a 00                	push   $0x0
  802438:	6a 00                	push   $0x0
  80243a:	6a 00                	push   $0x0
  80243c:	6a 00                	push   $0x0
  80243e:	6a 00                	push   $0x0
  802440:	6a 23                	push   $0x23
  802442:	e8 ee fb ff ff       	call   802035 <syscall>
  802447:	83 c4 18             	add    $0x18,%esp
}
  80244a:	90                   	nop
  80244b:	c9                   	leave  
  80244c:	c3                   	ret    

0080244d <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80244d:	55                   	push   %ebp
  80244e:	89 e5                	mov    %esp,%ebp
  802450:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802453:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802456:	8d 50 04             	lea    0x4(%eax),%edx
  802459:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80245c:	6a 00                	push   $0x0
  80245e:	6a 00                	push   $0x0
  802460:	6a 00                	push   $0x0
  802462:	52                   	push   %edx
  802463:	50                   	push   %eax
  802464:	6a 24                	push   $0x24
  802466:	e8 ca fb ff ff       	call   802035 <syscall>
  80246b:	83 c4 18             	add    $0x18,%esp
	return result;
  80246e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802471:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802474:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802477:	89 01                	mov    %eax,(%ecx)
  802479:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80247c:	8b 45 08             	mov    0x8(%ebp),%eax
  80247f:	c9                   	leave  
  802480:	c2 04 00             	ret    $0x4

00802483 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802483:	55                   	push   %ebp
  802484:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802486:	6a 00                	push   $0x0
  802488:	6a 00                	push   $0x0
  80248a:	ff 75 10             	pushl  0x10(%ebp)
  80248d:	ff 75 0c             	pushl  0xc(%ebp)
  802490:	ff 75 08             	pushl  0x8(%ebp)
  802493:	6a 12                	push   $0x12
  802495:	e8 9b fb ff ff       	call   802035 <syscall>
  80249a:	83 c4 18             	add    $0x18,%esp
	return ;
  80249d:	90                   	nop
}
  80249e:	c9                   	leave  
  80249f:	c3                   	ret    

008024a0 <sys_rcr2>:
uint32 sys_rcr2()
{
  8024a0:	55                   	push   %ebp
  8024a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8024a3:	6a 00                	push   $0x0
  8024a5:	6a 00                	push   $0x0
  8024a7:	6a 00                	push   $0x0
  8024a9:	6a 00                	push   $0x0
  8024ab:	6a 00                	push   $0x0
  8024ad:	6a 25                	push   $0x25
  8024af:	e8 81 fb ff ff       	call   802035 <syscall>
  8024b4:	83 c4 18             	add    $0x18,%esp
}
  8024b7:	c9                   	leave  
  8024b8:	c3                   	ret    

008024b9 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8024b9:	55                   	push   %ebp
  8024ba:	89 e5                	mov    %esp,%ebp
  8024bc:	83 ec 04             	sub    $0x4,%esp
  8024bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8024c5:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8024c9:	6a 00                	push   $0x0
  8024cb:	6a 00                	push   $0x0
  8024cd:	6a 00                	push   $0x0
  8024cf:	6a 00                	push   $0x0
  8024d1:	50                   	push   %eax
  8024d2:	6a 26                	push   $0x26
  8024d4:	e8 5c fb ff ff       	call   802035 <syscall>
  8024d9:	83 c4 18             	add    $0x18,%esp
	return ;
  8024dc:	90                   	nop
}
  8024dd:	c9                   	leave  
  8024de:	c3                   	ret    

008024df <rsttst>:
void rsttst()
{
  8024df:	55                   	push   %ebp
  8024e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8024e2:	6a 00                	push   $0x0
  8024e4:	6a 00                	push   $0x0
  8024e6:	6a 00                	push   $0x0
  8024e8:	6a 00                	push   $0x0
  8024ea:	6a 00                	push   $0x0
  8024ec:	6a 28                	push   $0x28
  8024ee:	e8 42 fb ff ff       	call   802035 <syscall>
  8024f3:	83 c4 18             	add    $0x18,%esp
	return ;
  8024f6:	90                   	nop
}
  8024f7:	c9                   	leave  
  8024f8:	c3                   	ret    

008024f9 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8024f9:	55                   	push   %ebp
  8024fa:	89 e5                	mov    %esp,%ebp
  8024fc:	83 ec 04             	sub    $0x4,%esp
  8024ff:	8b 45 14             	mov    0x14(%ebp),%eax
  802502:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802505:	8b 55 18             	mov    0x18(%ebp),%edx
  802508:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80250c:	52                   	push   %edx
  80250d:	50                   	push   %eax
  80250e:	ff 75 10             	pushl  0x10(%ebp)
  802511:	ff 75 0c             	pushl  0xc(%ebp)
  802514:	ff 75 08             	pushl  0x8(%ebp)
  802517:	6a 27                	push   $0x27
  802519:	e8 17 fb ff ff       	call   802035 <syscall>
  80251e:	83 c4 18             	add    $0x18,%esp
	return ;
  802521:	90                   	nop
}
  802522:	c9                   	leave  
  802523:	c3                   	ret    

00802524 <chktst>:
void chktst(uint32 n)
{
  802524:	55                   	push   %ebp
  802525:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802527:	6a 00                	push   $0x0
  802529:	6a 00                	push   $0x0
  80252b:	6a 00                	push   $0x0
  80252d:	6a 00                	push   $0x0
  80252f:	ff 75 08             	pushl  0x8(%ebp)
  802532:	6a 29                	push   $0x29
  802534:	e8 fc fa ff ff       	call   802035 <syscall>
  802539:	83 c4 18             	add    $0x18,%esp
	return ;
  80253c:	90                   	nop
}
  80253d:	c9                   	leave  
  80253e:	c3                   	ret    

0080253f <inctst>:

void inctst()
{
  80253f:	55                   	push   %ebp
  802540:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802542:	6a 00                	push   $0x0
  802544:	6a 00                	push   $0x0
  802546:	6a 00                	push   $0x0
  802548:	6a 00                	push   $0x0
  80254a:	6a 00                	push   $0x0
  80254c:	6a 2a                	push   $0x2a
  80254e:	e8 e2 fa ff ff       	call   802035 <syscall>
  802553:	83 c4 18             	add    $0x18,%esp
	return ;
  802556:	90                   	nop
}
  802557:	c9                   	leave  
  802558:	c3                   	ret    

00802559 <gettst>:
uint32 gettst()
{
  802559:	55                   	push   %ebp
  80255a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80255c:	6a 00                	push   $0x0
  80255e:	6a 00                	push   $0x0
  802560:	6a 00                	push   $0x0
  802562:	6a 00                	push   $0x0
  802564:	6a 00                	push   $0x0
  802566:	6a 2b                	push   $0x2b
  802568:	e8 c8 fa ff ff       	call   802035 <syscall>
  80256d:	83 c4 18             	add    $0x18,%esp
}
  802570:	c9                   	leave  
  802571:	c3                   	ret    

00802572 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802572:	55                   	push   %ebp
  802573:	89 e5                	mov    %esp,%ebp
  802575:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802578:	6a 00                	push   $0x0
  80257a:	6a 00                	push   $0x0
  80257c:	6a 00                	push   $0x0
  80257e:	6a 00                	push   $0x0
  802580:	6a 00                	push   $0x0
  802582:	6a 2c                	push   $0x2c
  802584:	e8 ac fa ff ff       	call   802035 <syscall>
  802589:	83 c4 18             	add    $0x18,%esp
  80258c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80258f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802593:	75 07                	jne    80259c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802595:	b8 01 00 00 00       	mov    $0x1,%eax
  80259a:	eb 05                	jmp    8025a1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80259c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025a1:	c9                   	leave  
  8025a2:	c3                   	ret    

008025a3 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8025a3:	55                   	push   %ebp
  8025a4:	89 e5                	mov    %esp,%ebp
  8025a6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025a9:	6a 00                	push   $0x0
  8025ab:	6a 00                	push   $0x0
  8025ad:	6a 00                	push   $0x0
  8025af:	6a 00                	push   $0x0
  8025b1:	6a 00                	push   $0x0
  8025b3:	6a 2c                	push   $0x2c
  8025b5:	e8 7b fa ff ff       	call   802035 <syscall>
  8025ba:	83 c4 18             	add    $0x18,%esp
  8025bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8025c0:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8025c4:	75 07                	jne    8025cd <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8025c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8025cb:	eb 05                	jmp    8025d2 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8025cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025d2:	c9                   	leave  
  8025d3:	c3                   	ret    

008025d4 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8025d4:	55                   	push   %ebp
  8025d5:	89 e5                	mov    %esp,%ebp
  8025d7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025da:	6a 00                	push   $0x0
  8025dc:	6a 00                	push   $0x0
  8025de:	6a 00                	push   $0x0
  8025e0:	6a 00                	push   $0x0
  8025e2:	6a 00                	push   $0x0
  8025e4:	6a 2c                	push   $0x2c
  8025e6:	e8 4a fa ff ff       	call   802035 <syscall>
  8025eb:	83 c4 18             	add    $0x18,%esp
  8025ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8025f1:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8025f5:	75 07                	jne    8025fe <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8025f7:	b8 01 00 00 00       	mov    $0x1,%eax
  8025fc:	eb 05                	jmp    802603 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8025fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802603:	c9                   	leave  
  802604:	c3                   	ret    

00802605 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802605:	55                   	push   %ebp
  802606:	89 e5                	mov    %esp,%ebp
  802608:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80260b:	6a 00                	push   $0x0
  80260d:	6a 00                	push   $0x0
  80260f:	6a 00                	push   $0x0
  802611:	6a 00                	push   $0x0
  802613:	6a 00                	push   $0x0
  802615:	6a 2c                	push   $0x2c
  802617:	e8 19 fa ff ff       	call   802035 <syscall>
  80261c:	83 c4 18             	add    $0x18,%esp
  80261f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802622:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802626:	75 07                	jne    80262f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802628:	b8 01 00 00 00       	mov    $0x1,%eax
  80262d:	eb 05                	jmp    802634 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80262f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802634:	c9                   	leave  
  802635:	c3                   	ret    

00802636 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802636:	55                   	push   %ebp
  802637:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802639:	6a 00                	push   $0x0
  80263b:	6a 00                	push   $0x0
  80263d:	6a 00                	push   $0x0
  80263f:	6a 00                	push   $0x0
  802641:	ff 75 08             	pushl  0x8(%ebp)
  802644:	6a 2d                	push   $0x2d
  802646:	e8 ea f9 ff ff       	call   802035 <syscall>
  80264b:	83 c4 18             	add    $0x18,%esp
	return ;
  80264e:	90                   	nop
}
  80264f:	c9                   	leave  
  802650:	c3                   	ret    

00802651 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802651:	55                   	push   %ebp
  802652:	89 e5                	mov    %esp,%ebp
  802654:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802655:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802658:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80265b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80265e:	8b 45 08             	mov    0x8(%ebp),%eax
  802661:	6a 00                	push   $0x0
  802663:	53                   	push   %ebx
  802664:	51                   	push   %ecx
  802665:	52                   	push   %edx
  802666:	50                   	push   %eax
  802667:	6a 2e                	push   $0x2e
  802669:	e8 c7 f9 ff ff       	call   802035 <syscall>
  80266e:	83 c4 18             	add    $0x18,%esp
}
  802671:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802674:	c9                   	leave  
  802675:	c3                   	ret    

00802676 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802676:	55                   	push   %ebp
  802677:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802679:	8b 55 0c             	mov    0xc(%ebp),%edx
  80267c:	8b 45 08             	mov    0x8(%ebp),%eax
  80267f:	6a 00                	push   $0x0
  802681:	6a 00                	push   $0x0
  802683:	6a 00                	push   $0x0
  802685:	52                   	push   %edx
  802686:	50                   	push   %eax
  802687:	6a 2f                	push   $0x2f
  802689:	e8 a7 f9 ff ff       	call   802035 <syscall>
  80268e:	83 c4 18             	add    $0x18,%esp
}
  802691:	c9                   	leave  
  802692:	c3                   	ret    

00802693 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802693:	55                   	push   %ebp
  802694:	89 e5                	mov    %esp,%ebp
  802696:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802699:	83 ec 0c             	sub    $0xc,%esp
  80269c:	68 60 42 80 00       	push   $0x804260
  8026a1:	e8 c3 e6 ff ff       	call   800d69 <cprintf>
  8026a6:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8026a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8026b0:	83 ec 0c             	sub    $0xc,%esp
  8026b3:	68 8c 42 80 00       	push   $0x80428c
  8026b8:	e8 ac e6 ff ff       	call   800d69 <cprintf>
  8026bd:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8026c0:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026c4:	a1 38 51 80 00       	mov    0x805138,%eax
  8026c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026cc:	eb 56                	jmp    802724 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8026ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026d2:	74 1c                	je     8026f0 <print_mem_block_lists+0x5d>
  8026d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d7:	8b 50 08             	mov    0x8(%eax),%edx
  8026da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026dd:	8b 48 08             	mov    0x8(%eax),%ecx
  8026e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8026e6:	01 c8                	add    %ecx,%eax
  8026e8:	39 c2                	cmp    %eax,%edx
  8026ea:	73 04                	jae    8026f0 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8026ec:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8026f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f3:	8b 50 08             	mov    0x8(%eax),%edx
  8026f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8026fc:	01 c2                	add    %eax,%edx
  8026fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802701:	8b 40 08             	mov    0x8(%eax),%eax
  802704:	83 ec 04             	sub    $0x4,%esp
  802707:	52                   	push   %edx
  802708:	50                   	push   %eax
  802709:	68 a1 42 80 00       	push   $0x8042a1
  80270e:	e8 56 e6 ff ff       	call   800d69 <cprintf>
  802713:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802716:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802719:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80271c:	a1 40 51 80 00       	mov    0x805140,%eax
  802721:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802724:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802728:	74 07                	je     802731 <print_mem_block_lists+0x9e>
  80272a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272d:	8b 00                	mov    (%eax),%eax
  80272f:	eb 05                	jmp    802736 <print_mem_block_lists+0xa3>
  802731:	b8 00 00 00 00       	mov    $0x0,%eax
  802736:	a3 40 51 80 00       	mov    %eax,0x805140
  80273b:	a1 40 51 80 00       	mov    0x805140,%eax
  802740:	85 c0                	test   %eax,%eax
  802742:	75 8a                	jne    8026ce <print_mem_block_lists+0x3b>
  802744:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802748:	75 84                	jne    8026ce <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80274a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80274e:	75 10                	jne    802760 <print_mem_block_lists+0xcd>
  802750:	83 ec 0c             	sub    $0xc,%esp
  802753:	68 b0 42 80 00       	push   $0x8042b0
  802758:	e8 0c e6 ff ff       	call   800d69 <cprintf>
  80275d:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802760:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802767:	83 ec 0c             	sub    $0xc,%esp
  80276a:	68 d4 42 80 00       	push   $0x8042d4
  80276f:	e8 f5 e5 ff ff       	call   800d69 <cprintf>
  802774:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802777:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80277b:	a1 40 50 80 00       	mov    0x805040,%eax
  802780:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802783:	eb 56                	jmp    8027db <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802785:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802789:	74 1c                	je     8027a7 <print_mem_block_lists+0x114>
  80278b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278e:	8b 50 08             	mov    0x8(%eax),%edx
  802791:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802794:	8b 48 08             	mov    0x8(%eax),%ecx
  802797:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279a:	8b 40 0c             	mov    0xc(%eax),%eax
  80279d:	01 c8                	add    %ecx,%eax
  80279f:	39 c2                	cmp    %eax,%edx
  8027a1:	73 04                	jae    8027a7 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8027a3:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8027a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027aa:	8b 50 08             	mov    0x8(%eax),%edx
  8027ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b3:	01 c2                	add    %eax,%edx
  8027b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b8:	8b 40 08             	mov    0x8(%eax),%eax
  8027bb:	83 ec 04             	sub    $0x4,%esp
  8027be:	52                   	push   %edx
  8027bf:	50                   	push   %eax
  8027c0:	68 a1 42 80 00       	push   $0x8042a1
  8027c5:	e8 9f e5 ff ff       	call   800d69 <cprintf>
  8027ca:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8027cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8027d3:	a1 48 50 80 00       	mov    0x805048,%eax
  8027d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027df:	74 07                	je     8027e8 <print_mem_block_lists+0x155>
  8027e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e4:	8b 00                	mov    (%eax),%eax
  8027e6:	eb 05                	jmp    8027ed <print_mem_block_lists+0x15a>
  8027e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ed:	a3 48 50 80 00       	mov    %eax,0x805048
  8027f2:	a1 48 50 80 00       	mov    0x805048,%eax
  8027f7:	85 c0                	test   %eax,%eax
  8027f9:	75 8a                	jne    802785 <print_mem_block_lists+0xf2>
  8027fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ff:	75 84                	jne    802785 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802801:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802805:	75 10                	jne    802817 <print_mem_block_lists+0x184>
  802807:	83 ec 0c             	sub    $0xc,%esp
  80280a:	68 ec 42 80 00       	push   $0x8042ec
  80280f:	e8 55 e5 ff ff       	call   800d69 <cprintf>
  802814:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802817:	83 ec 0c             	sub    $0xc,%esp
  80281a:	68 60 42 80 00       	push   $0x804260
  80281f:	e8 45 e5 ff ff       	call   800d69 <cprintf>
  802824:	83 c4 10             	add    $0x10,%esp

}
  802827:	90                   	nop
  802828:	c9                   	leave  
  802829:	c3                   	ret    

0080282a <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80282a:	55                   	push   %ebp
  80282b:	89 e5                	mov    %esp,%ebp
  80282d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  802830:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802837:	00 00 00 
  80283a:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802841:	00 00 00 
  802844:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80284b:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  80284e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802855:	e9 9e 00 00 00       	jmp    8028f8 <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  80285a:	a1 50 50 80 00       	mov    0x805050,%eax
  80285f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802862:	c1 e2 04             	shl    $0x4,%edx
  802865:	01 d0                	add    %edx,%eax
  802867:	85 c0                	test   %eax,%eax
  802869:	75 14                	jne    80287f <initialize_MemBlocksList+0x55>
  80286b:	83 ec 04             	sub    $0x4,%esp
  80286e:	68 14 43 80 00       	push   $0x804314
  802873:	6a 47                	push   $0x47
  802875:	68 37 43 80 00       	push   $0x804337
  80287a:	e8 36 e2 ff ff       	call   800ab5 <_panic>
  80287f:	a1 50 50 80 00       	mov    0x805050,%eax
  802884:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802887:	c1 e2 04             	shl    $0x4,%edx
  80288a:	01 d0                	add    %edx,%eax
  80288c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802892:	89 10                	mov    %edx,(%eax)
  802894:	8b 00                	mov    (%eax),%eax
  802896:	85 c0                	test   %eax,%eax
  802898:	74 18                	je     8028b2 <initialize_MemBlocksList+0x88>
  80289a:	a1 48 51 80 00       	mov    0x805148,%eax
  80289f:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8028a5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8028a8:	c1 e1 04             	shl    $0x4,%ecx
  8028ab:	01 ca                	add    %ecx,%edx
  8028ad:	89 50 04             	mov    %edx,0x4(%eax)
  8028b0:	eb 12                	jmp    8028c4 <initialize_MemBlocksList+0x9a>
  8028b2:	a1 50 50 80 00       	mov    0x805050,%eax
  8028b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028ba:	c1 e2 04             	shl    $0x4,%edx
  8028bd:	01 d0                	add    %edx,%eax
  8028bf:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028c4:	a1 50 50 80 00       	mov    0x805050,%eax
  8028c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028cc:	c1 e2 04             	shl    $0x4,%edx
  8028cf:	01 d0                	add    %edx,%eax
  8028d1:	a3 48 51 80 00       	mov    %eax,0x805148
  8028d6:	a1 50 50 80 00       	mov    0x805050,%eax
  8028db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028de:	c1 e2 04             	shl    $0x4,%edx
  8028e1:	01 d0                	add    %edx,%eax
  8028e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ea:	a1 54 51 80 00       	mov    0x805154,%eax
  8028ef:	40                   	inc    %eax
  8028f0:	a3 54 51 80 00       	mov    %eax,0x805154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  8028f5:	ff 45 f4             	incl   -0xc(%ebp)
  8028f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028fe:	0f 82 56 ff ff ff    	jb     80285a <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  802904:	90                   	nop
  802905:	c9                   	leave  
  802906:	c3                   	ret    

00802907 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802907:	55                   	push   %ebp
  802908:	89 e5                	mov    %esp,%ebp
  80290a:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  80290d:	8b 45 08             	mov    0x8(%ebp),%eax
  802910:	8b 00                	mov    (%eax),%eax
  802912:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802915:	eb 19                	jmp    802930 <find_block+0x29>
	{
		if(element->sva == va){
  802917:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80291a:	8b 40 08             	mov    0x8(%eax),%eax
  80291d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802920:	75 05                	jne    802927 <find_block+0x20>
			 		return element;
  802922:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802925:	eb 36                	jmp    80295d <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802927:	8b 45 08             	mov    0x8(%ebp),%eax
  80292a:	8b 40 08             	mov    0x8(%eax),%eax
  80292d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802930:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802934:	74 07                	je     80293d <find_block+0x36>
  802936:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802939:	8b 00                	mov    (%eax),%eax
  80293b:	eb 05                	jmp    802942 <find_block+0x3b>
  80293d:	b8 00 00 00 00       	mov    $0x0,%eax
  802942:	8b 55 08             	mov    0x8(%ebp),%edx
  802945:	89 42 08             	mov    %eax,0x8(%edx)
  802948:	8b 45 08             	mov    0x8(%ebp),%eax
  80294b:	8b 40 08             	mov    0x8(%eax),%eax
  80294e:	85 c0                	test   %eax,%eax
  802950:	75 c5                	jne    802917 <find_block+0x10>
  802952:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802956:	75 bf                	jne    802917 <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  802958:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80295d:	c9                   	leave  
  80295e:	c3                   	ret    

0080295f <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80295f:	55                   	push   %ebp
  802960:	89 e5                	mov    %esp,%ebp
  802962:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  802965:	a1 44 50 80 00       	mov    0x805044,%eax
  80296a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  80296d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802972:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  802975:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802979:	74 0a                	je     802985 <insert_sorted_allocList+0x26>
  80297b:	8b 45 08             	mov    0x8(%ebp),%eax
  80297e:	8b 40 08             	mov    0x8(%eax),%eax
  802981:	85 c0                	test   %eax,%eax
  802983:	75 65                	jne    8029ea <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802985:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802989:	75 14                	jne    80299f <insert_sorted_allocList+0x40>
  80298b:	83 ec 04             	sub    $0x4,%esp
  80298e:	68 14 43 80 00       	push   $0x804314
  802993:	6a 6e                	push   $0x6e
  802995:	68 37 43 80 00       	push   $0x804337
  80299a:	e8 16 e1 ff ff       	call   800ab5 <_panic>
  80299f:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8029a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a8:	89 10                	mov    %edx,(%eax)
  8029aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ad:	8b 00                	mov    (%eax),%eax
  8029af:	85 c0                	test   %eax,%eax
  8029b1:	74 0d                	je     8029c0 <insert_sorted_allocList+0x61>
  8029b3:	a1 40 50 80 00       	mov    0x805040,%eax
  8029b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8029bb:	89 50 04             	mov    %edx,0x4(%eax)
  8029be:	eb 08                	jmp    8029c8 <insert_sorted_allocList+0x69>
  8029c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c3:	a3 44 50 80 00       	mov    %eax,0x805044
  8029c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cb:	a3 40 50 80 00       	mov    %eax,0x805040
  8029d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029da:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029df:	40                   	inc    %eax
  8029e0:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8029e5:	e9 cf 01 00 00       	jmp    802bb9 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  8029ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ed:	8b 50 08             	mov    0x8(%eax),%edx
  8029f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f3:	8b 40 08             	mov    0x8(%eax),%eax
  8029f6:	39 c2                	cmp    %eax,%edx
  8029f8:	73 65                	jae    802a5f <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8029fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029fe:	75 14                	jne    802a14 <insert_sorted_allocList+0xb5>
  802a00:	83 ec 04             	sub    $0x4,%esp
  802a03:	68 50 43 80 00       	push   $0x804350
  802a08:	6a 72                	push   $0x72
  802a0a:	68 37 43 80 00       	push   $0x804337
  802a0f:	e8 a1 e0 ff ff       	call   800ab5 <_panic>
  802a14:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1d:	89 50 04             	mov    %edx,0x4(%eax)
  802a20:	8b 45 08             	mov    0x8(%ebp),%eax
  802a23:	8b 40 04             	mov    0x4(%eax),%eax
  802a26:	85 c0                	test   %eax,%eax
  802a28:	74 0c                	je     802a36 <insert_sorted_allocList+0xd7>
  802a2a:	a1 44 50 80 00       	mov    0x805044,%eax
  802a2f:	8b 55 08             	mov    0x8(%ebp),%edx
  802a32:	89 10                	mov    %edx,(%eax)
  802a34:	eb 08                	jmp    802a3e <insert_sorted_allocList+0xdf>
  802a36:	8b 45 08             	mov    0x8(%ebp),%eax
  802a39:	a3 40 50 80 00       	mov    %eax,0x805040
  802a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a41:	a3 44 50 80 00       	mov    %eax,0x805044
  802a46:	8b 45 08             	mov    0x8(%ebp),%eax
  802a49:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a4f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a54:	40                   	inc    %eax
  802a55:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  802a5a:	e9 5a 01 00 00       	jmp    802bb9 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  802a5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a62:	8b 50 08             	mov    0x8(%eax),%edx
  802a65:	8b 45 08             	mov    0x8(%ebp),%eax
  802a68:	8b 40 08             	mov    0x8(%eax),%eax
  802a6b:	39 c2                	cmp    %eax,%edx
  802a6d:	75 70                	jne    802adf <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  802a6f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a73:	74 06                	je     802a7b <insert_sorted_allocList+0x11c>
  802a75:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a79:	75 14                	jne    802a8f <insert_sorted_allocList+0x130>
  802a7b:	83 ec 04             	sub    $0x4,%esp
  802a7e:	68 74 43 80 00       	push   $0x804374
  802a83:	6a 75                	push   $0x75
  802a85:	68 37 43 80 00       	push   $0x804337
  802a8a:	e8 26 e0 ff ff       	call   800ab5 <_panic>
  802a8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a92:	8b 10                	mov    (%eax),%edx
  802a94:	8b 45 08             	mov    0x8(%ebp),%eax
  802a97:	89 10                	mov    %edx,(%eax)
  802a99:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9c:	8b 00                	mov    (%eax),%eax
  802a9e:	85 c0                	test   %eax,%eax
  802aa0:	74 0b                	je     802aad <insert_sorted_allocList+0x14e>
  802aa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa5:	8b 00                	mov    (%eax),%eax
  802aa7:	8b 55 08             	mov    0x8(%ebp),%edx
  802aaa:	89 50 04             	mov    %edx,0x4(%eax)
  802aad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab0:	8b 55 08             	mov    0x8(%ebp),%edx
  802ab3:	89 10                	mov    %edx,(%eax)
  802ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802abb:	89 50 04             	mov    %edx,0x4(%eax)
  802abe:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac1:	8b 00                	mov    (%eax),%eax
  802ac3:	85 c0                	test   %eax,%eax
  802ac5:	75 08                	jne    802acf <insert_sorted_allocList+0x170>
  802ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aca:	a3 44 50 80 00       	mov    %eax,0x805044
  802acf:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802ad4:	40                   	inc    %eax
  802ad5:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  802ada:	e9 da 00 00 00       	jmp    802bb9 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802adf:	a1 40 50 80 00       	mov    0x805040,%eax
  802ae4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ae7:	e9 9d 00 00 00       	jmp    802b89 <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  802aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aef:	8b 00                	mov    (%eax),%eax
  802af1:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  802af4:	8b 45 08             	mov    0x8(%ebp),%eax
  802af7:	8b 50 08             	mov    0x8(%eax),%edx
  802afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afd:	8b 40 08             	mov    0x8(%eax),%eax
  802b00:	39 c2                	cmp    %eax,%edx
  802b02:	76 7d                	jbe    802b81 <insert_sorted_allocList+0x222>
  802b04:	8b 45 08             	mov    0x8(%ebp),%eax
  802b07:	8b 50 08             	mov    0x8(%eax),%edx
  802b0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b0d:	8b 40 08             	mov    0x8(%eax),%eax
  802b10:	39 c2                	cmp    %eax,%edx
  802b12:	73 6d                	jae    802b81 <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802b14:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b18:	74 06                	je     802b20 <insert_sorted_allocList+0x1c1>
  802b1a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b1e:	75 14                	jne    802b34 <insert_sorted_allocList+0x1d5>
  802b20:	83 ec 04             	sub    $0x4,%esp
  802b23:	68 74 43 80 00       	push   $0x804374
  802b28:	6a 7c                	push   $0x7c
  802b2a:	68 37 43 80 00       	push   $0x804337
  802b2f:	e8 81 df ff ff       	call   800ab5 <_panic>
  802b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b37:	8b 10                	mov    (%eax),%edx
  802b39:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3c:	89 10                	mov    %edx,(%eax)
  802b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b41:	8b 00                	mov    (%eax),%eax
  802b43:	85 c0                	test   %eax,%eax
  802b45:	74 0b                	je     802b52 <insert_sorted_allocList+0x1f3>
  802b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4a:	8b 00                	mov    (%eax),%eax
  802b4c:	8b 55 08             	mov    0x8(%ebp),%edx
  802b4f:	89 50 04             	mov    %edx,0x4(%eax)
  802b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b55:	8b 55 08             	mov    0x8(%ebp),%edx
  802b58:	89 10                	mov    %edx,(%eax)
  802b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b60:	89 50 04             	mov    %edx,0x4(%eax)
  802b63:	8b 45 08             	mov    0x8(%ebp),%eax
  802b66:	8b 00                	mov    (%eax),%eax
  802b68:	85 c0                	test   %eax,%eax
  802b6a:	75 08                	jne    802b74 <insert_sorted_allocList+0x215>
  802b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6f:	a3 44 50 80 00       	mov    %eax,0x805044
  802b74:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b79:	40                   	inc    %eax
  802b7a:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802b7f:	eb 38                	jmp    802bb9 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802b81:	a1 48 50 80 00       	mov    0x805048,%eax
  802b86:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b8d:	74 07                	je     802b96 <insert_sorted_allocList+0x237>
  802b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b92:	8b 00                	mov    (%eax),%eax
  802b94:	eb 05                	jmp    802b9b <insert_sorted_allocList+0x23c>
  802b96:	b8 00 00 00 00       	mov    $0x0,%eax
  802b9b:	a3 48 50 80 00       	mov    %eax,0x805048
  802ba0:	a1 48 50 80 00       	mov    0x805048,%eax
  802ba5:	85 c0                	test   %eax,%eax
  802ba7:	0f 85 3f ff ff ff    	jne    802aec <insert_sorted_allocList+0x18d>
  802bad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bb1:	0f 85 35 ff ff ff    	jne    802aec <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  802bb7:	eb 00                	jmp    802bb9 <insert_sorted_allocList+0x25a>
  802bb9:	90                   	nop
  802bba:	c9                   	leave  
  802bbb:	c3                   	ret    

00802bbc <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802bbc:	55                   	push   %ebp
  802bbd:	89 e5                	mov    %esp,%ebp
  802bbf:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802bc2:	a1 38 51 80 00       	mov    0x805138,%eax
  802bc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bca:	e9 6b 02 00 00       	jmp    802e3a <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  802bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd2:	8b 40 0c             	mov    0xc(%eax),%eax
  802bd5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bd8:	0f 85 90 00 00 00    	jne    802c6e <alloc_block_FF+0xb2>
			  temp=element;
  802bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be1:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  802be4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802be8:	75 17                	jne    802c01 <alloc_block_FF+0x45>
  802bea:	83 ec 04             	sub    $0x4,%esp
  802bed:	68 a8 43 80 00       	push   $0x8043a8
  802bf2:	68 92 00 00 00       	push   $0x92
  802bf7:	68 37 43 80 00       	push   $0x804337
  802bfc:	e8 b4 de ff ff       	call   800ab5 <_panic>
  802c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c04:	8b 00                	mov    (%eax),%eax
  802c06:	85 c0                	test   %eax,%eax
  802c08:	74 10                	je     802c1a <alloc_block_FF+0x5e>
  802c0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0d:	8b 00                	mov    (%eax),%eax
  802c0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c12:	8b 52 04             	mov    0x4(%edx),%edx
  802c15:	89 50 04             	mov    %edx,0x4(%eax)
  802c18:	eb 0b                	jmp    802c25 <alloc_block_FF+0x69>
  802c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1d:	8b 40 04             	mov    0x4(%eax),%eax
  802c20:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c28:	8b 40 04             	mov    0x4(%eax),%eax
  802c2b:	85 c0                	test   %eax,%eax
  802c2d:	74 0f                	je     802c3e <alloc_block_FF+0x82>
  802c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c32:	8b 40 04             	mov    0x4(%eax),%eax
  802c35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c38:	8b 12                	mov    (%edx),%edx
  802c3a:	89 10                	mov    %edx,(%eax)
  802c3c:	eb 0a                	jmp    802c48 <alloc_block_FF+0x8c>
  802c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c41:	8b 00                	mov    (%eax),%eax
  802c43:	a3 38 51 80 00       	mov    %eax,0x805138
  802c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c54:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c5b:	a1 44 51 80 00       	mov    0x805144,%eax
  802c60:	48                   	dec    %eax
  802c61:	a3 44 51 80 00       	mov    %eax,0x805144
			  return temp;
  802c66:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c69:	e9 ff 01 00 00       	jmp    802e6d <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  802c6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c71:	8b 40 0c             	mov    0xc(%eax),%eax
  802c74:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c77:	0f 86 b5 01 00 00    	jbe    802e32 <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  802c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c80:	8b 40 0c             	mov    0xc(%eax),%eax
  802c83:	2b 45 08             	sub    0x8(%ebp),%eax
  802c86:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  802c89:	a1 48 51 80 00       	mov    0x805148,%eax
  802c8e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  802c91:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c95:	75 17                	jne    802cae <alloc_block_FF+0xf2>
  802c97:	83 ec 04             	sub    $0x4,%esp
  802c9a:	68 a8 43 80 00       	push   $0x8043a8
  802c9f:	68 99 00 00 00       	push   $0x99
  802ca4:	68 37 43 80 00       	push   $0x804337
  802ca9:	e8 07 de ff ff       	call   800ab5 <_panic>
  802cae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb1:	8b 00                	mov    (%eax),%eax
  802cb3:	85 c0                	test   %eax,%eax
  802cb5:	74 10                	je     802cc7 <alloc_block_FF+0x10b>
  802cb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cba:	8b 00                	mov    (%eax),%eax
  802cbc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cbf:	8b 52 04             	mov    0x4(%edx),%edx
  802cc2:	89 50 04             	mov    %edx,0x4(%eax)
  802cc5:	eb 0b                	jmp    802cd2 <alloc_block_FF+0x116>
  802cc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cca:	8b 40 04             	mov    0x4(%eax),%eax
  802ccd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802cd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd5:	8b 40 04             	mov    0x4(%eax),%eax
  802cd8:	85 c0                	test   %eax,%eax
  802cda:	74 0f                	je     802ceb <alloc_block_FF+0x12f>
  802cdc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cdf:	8b 40 04             	mov    0x4(%eax),%eax
  802ce2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ce5:	8b 12                	mov    (%edx),%edx
  802ce7:	89 10                	mov    %edx,(%eax)
  802ce9:	eb 0a                	jmp    802cf5 <alloc_block_FF+0x139>
  802ceb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cee:	8b 00                	mov    (%eax),%eax
  802cf0:	a3 48 51 80 00       	mov    %eax,0x805148
  802cf5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cfe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d01:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d08:	a1 54 51 80 00       	mov    0x805154,%eax
  802d0d:	48                   	dec    %eax
  802d0e:	a3 54 51 80 00       	mov    %eax,0x805154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  802d13:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d17:	75 17                	jne    802d30 <alloc_block_FF+0x174>
  802d19:	83 ec 04             	sub    $0x4,%esp
  802d1c:	68 50 43 80 00       	push   $0x804350
  802d21:	68 9a 00 00 00       	push   $0x9a
  802d26:	68 37 43 80 00       	push   $0x804337
  802d2b:	e8 85 dd ff ff       	call   800ab5 <_panic>
  802d30:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802d36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d39:	89 50 04             	mov    %edx,0x4(%eax)
  802d3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d3f:	8b 40 04             	mov    0x4(%eax),%eax
  802d42:	85 c0                	test   %eax,%eax
  802d44:	74 0c                	je     802d52 <alloc_block_FF+0x196>
  802d46:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d4b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d4e:	89 10                	mov    %edx,(%eax)
  802d50:	eb 08                	jmp    802d5a <alloc_block_FF+0x19e>
  802d52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d55:	a3 38 51 80 00       	mov    %eax,0x805138
  802d5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d5d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d65:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d6b:	a1 44 51 80 00       	mov    0x805144,%eax
  802d70:	40                   	inc    %eax
  802d71:	a3 44 51 80 00       	mov    %eax,0x805144
		  // setting the size & sva
		  new_block->size=size;
  802d76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d79:	8b 55 08             	mov    0x8(%ebp),%edx
  802d7c:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  802d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d82:	8b 50 08             	mov    0x8(%eax),%edx
  802d85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d88:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  802d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d91:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  802d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d97:	8b 50 08             	mov    0x8(%eax),%edx
  802d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9d:	01 c2                	add    %eax,%edx
  802d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da2:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  802da5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da8:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  802dab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802daf:	75 17                	jne    802dc8 <alloc_block_FF+0x20c>
  802db1:	83 ec 04             	sub    $0x4,%esp
  802db4:	68 a8 43 80 00       	push   $0x8043a8
  802db9:	68 a2 00 00 00       	push   $0xa2
  802dbe:	68 37 43 80 00       	push   $0x804337
  802dc3:	e8 ed dc ff ff       	call   800ab5 <_panic>
  802dc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dcb:	8b 00                	mov    (%eax),%eax
  802dcd:	85 c0                	test   %eax,%eax
  802dcf:	74 10                	je     802de1 <alloc_block_FF+0x225>
  802dd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd4:	8b 00                	mov    (%eax),%eax
  802dd6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802dd9:	8b 52 04             	mov    0x4(%edx),%edx
  802ddc:	89 50 04             	mov    %edx,0x4(%eax)
  802ddf:	eb 0b                	jmp    802dec <alloc_block_FF+0x230>
  802de1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802de4:	8b 40 04             	mov    0x4(%eax),%eax
  802de7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802def:	8b 40 04             	mov    0x4(%eax),%eax
  802df2:	85 c0                	test   %eax,%eax
  802df4:	74 0f                	je     802e05 <alloc_block_FF+0x249>
  802df6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df9:	8b 40 04             	mov    0x4(%eax),%eax
  802dfc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802dff:	8b 12                	mov    (%edx),%edx
  802e01:	89 10                	mov    %edx,(%eax)
  802e03:	eb 0a                	jmp    802e0f <alloc_block_FF+0x253>
  802e05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e08:	8b 00                	mov    (%eax),%eax
  802e0a:	a3 38 51 80 00       	mov    %eax,0x805138
  802e0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e12:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e1b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e22:	a1 44 51 80 00       	mov    0x805144,%eax
  802e27:	48                   	dec    %eax
  802e28:	a3 44 51 80 00       	mov    %eax,0x805144
		  return temp;
  802e2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e30:	eb 3b                	jmp    802e6d <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802e32:	a1 40 51 80 00       	mov    0x805140,%eax
  802e37:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e3e:	74 07                	je     802e47 <alloc_block_FF+0x28b>
  802e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e43:	8b 00                	mov    (%eax),%eax
  802e45:	eb 05                	jmp    802e4c <alloc_block_FF+0x290>
  802e47:	b8 00 00 00 00       	mov    $0x0,%eax
  802e4c:	a3 40 51 80 00       	mov    %eax,0x805140
  802e51:	a1 40 51 80 00       	mov    0x805140,%eax
  802e56:	85 c0                	test   %eax,%eax
  802e58:	0f 85 71 fd ff ff    	jne    802bcf <alloc_block_FF+0x13>
  802e5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e62:	0f 85 67 fd ff ff    	jne    802bcf <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  802e68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e6d:	c9                   	leave  
  802e6e:	c3                   	ret    

00802e6f <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802e6f:	55                   	push   %ebp
  802e70:	89 e5                	mov    %esp,%ebp
  802e72:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  802e75:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  802e7c:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802e83:	a1 38 51 80 00       	mov    0x805138,%eax
  802e88:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802e8b:	e9 d3 00 00 00       	jmp    802f63 <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  802e90:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e93:	8b 40 0c             	mov    0xc(%eax),%eax
  802e96:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e99:	0f 85 90 00 00 00    	jne    802f2f <alloc_block_BF+0xc0>
	   temp = element;
  802e9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ea2:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  802ea5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ea9:	75 17                	jne    802ec2 <alloc_block_BF+0x53>
  802eab:	83 ec 04             	sub    $0x4,%esp
  802eae:	68 a8 43 80 00       	push   $0x8043a8
  802eb3:	68 bd 00 00 00       	push   $0xbd
  802eb8:	68 37 43 80 00       	push   $0x804337
  802ebd:	e8 f3 db ff ff       	call   800ab5 <_panic>
  802ec2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ec5:	8b 00                	mov    (%eax),%eax
  802ec7:	85 c0                	test   %eax,%eax
  802ec9:	74 10                	je     802edb <alloc_block_BF+0x6c>
  802ecb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ece:	8b 00                	mov    (%eax),%eax
  802ed0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ed3:	8b 52 04             	mov    0x4(%edx),%edx
  802ed6:	89 50 04             	mov    %edx,0x4(%eax)
  802ed9:	eb 0b                	jmp    802ee6 <alloc_block_BF+0x77>
  802edb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ede:	8b 40 04             	mov    0x4(%eax),%eax
  802ee1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ee6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ee9:	8b 40 04             	mov    0x4(%eax),%eax
  802eec:	85 c0                	test   %eax,%eax
  802eee:	74 0f                	je     802eff <alloc_block_BF+0x90>
  802ef0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ef3:	8b 40 04             	mov    0x4(%eax),%eax
  802ef6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ef9:	8b 12                	mov    (%edx),%edx
  802efb:	89 10                	mov    %edx,(%eax)
  802efd:	eb 0a                	jmp    802f09 <alloc_block_BF+0x9a>
  802eff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f02:	8b 00                	mov    (%eax),%eax
  802f04:	a3 38 51 80 00       	mov    %eax,0x805138
  802f09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f0c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f12:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f15:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f1c:	a1 44 51 80 00       	mov    0x805144,%eax
  802f21:	48                   	dec    %eax
  802f22:	a3 44 51 80 00       	mov    %eax,0x805144
	   return temp;
  802f27:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f2a:	e9 41 01 00 00       	jmp    803070 <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  802f2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f32:	8b 40 0c             	mov    0xc(%eax),%eax
  802f35:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f38:	76 21                	jbe    802f5b <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  802f3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f3d:	8b 40 0c             	mov    0xc(%eax),%eax
  802f40:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802f43:	73 16                	jae    802f5b <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  802f45:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f48:	8b 40 0c             	mov    0xc(%eax),%eax
  802f4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  802f4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f51:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  802f54:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802f5b:	a1 40 51 80 00       	mov    0x805140,%eax
  802f60:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802f63:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f67:	74 07                	je     802f70 <alloc_block_BF+0x101>
  802f69:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f6c:	8b 00                	mov    (%eax),%eax
  802f6e:	eb 05                	jmp    802f75 <alloc_block_BF+0x106>
  802f70:	b8 00 00 00 00       	mov    $0x0,%eax
  802f75:	a3 40 51 80 00       	mov    %eax,0x805140
  802f7a:	a1 40 51 80 00       	mov    0x805140,%eax
  802f7f:	85 c0                	test   %eax,%eax
  802f81:	0f 85 09 ff ff ff    	jne    802e90 <alloc_block_BF+0x21>
  802f87:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f8b:	0f 85 ff fe ff ff    	jne    802e90 <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  802f91:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  802f95:	0f 85 d0 00 00 00    	jne    80306b <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  802f9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f9e:	8b 40 0c             	mov    0xc(%eax),%eax
  802fa1:	2b 45 08             	sub    0x8(%ebp),%eax
  802fa4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  802fa7:	a1 48 51 80 00       	mov    0x805148,%eax
  802fac:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  802faf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802fb3:	75 17                	jne    802fcc <alloc_block_BF+0x15d>
  802fb5:	83 ec 04             	sub    $0x4,%esp
  802fb8:	68 a8 43 80 00       	push   $0x8043a8
  802fbd:	68 d1 00 00 00       	push   $0xd1
  802fc2:	68 37 43 80 00       	push   $0x804337
  802fc7:	e8 e9 da ff ff       	call   800ab5 <_panic>
  802fcc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fcf:	8b 00                	mov    (%eax),%eax
  802fd1:	85 c0                	test   %eax,%eax
  802fd3:	74 10                	je     802fe5 <alloc_block_BF+0x176>
  802fd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fd8:	8b 00                	mov    (%eax),%eax
  802fda:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fdd:	8b 52 04             	mov    0x4(%edx),%edx
  802fe0:	89 50 04             	mov    %edx,0x4(%eax)
  802fe3:	eb 0b                	jmp    802ff0 <alloc_block_BF+0x181>
  802fe5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fe8:	8b 40 04             	mov    0x4(%eax),%eax
  802feb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ff0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ff3:	8b 40 04             	mov    0x4(%eax),%eax
  802ff6:	85 c0                	test   %eax,%eax
  802ff8:	74 0f                	je     803009 <alloc_block_BF+0x19a>
  802ffa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ffd:	8b 40 04             	mov    0x4(%eax),%eax
  803000:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803003:	8b 12                	mov    (%edx),%edx
  803005:	89 10                	mov    %edx,(%eax)
  803007:	eb 0a                	jmp    803013 <alloc_block_BF+0x1a4>
  803009:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80300c:	8b 00                	mov    (%eax),%eax
  80300e:	a3 48 51 80 00       	mov    %eax,0x805148
  803013:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803016:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80301c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80301f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803026:	a1 54 51 80 00       	mov    0x805154,%eax
  80302b:	48                   	dec    %eax
  80302c:	a3 54 51 80 00       	mov    %eax,0x805154
	  // setting the size & sva
	  new_block->size = size;
  803031:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803034:	8b 55 08             	mov    0x8(%ebp),%edx
  803037:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  80303a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80303d:	8b 50 08             	mov    0x8(%eax),%edx
  803040:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803043:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  803046:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803049:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80304c:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  80304f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803052:	8b 50 08             	mov    0x8(%eax),%edx
  803055:	8b 45 08             	mov    0x8(%ebp),%eax
  803058:	01 c2                	add    %eax,%edx
  80305a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80305d:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  803060:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803063:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  803066:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803069:	eb 05                	jmp    803070 <alloc_block_BF+0x201>
	 }
	 return NULL;
  80306b:	b8 00 00 00 00       	mov    $0x0,%eax


}
  803070:	c9                   	leave  
  803071:	c3                   	ret    

00803072 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  803072:	55                   	push   %ebp
  803073:	89 e5                	mov    %esp,%ebp
  803075:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  803078:	83 ec 04             	sub    $0x4,%esp
  80307b:	68 c8 43 80 00       	push   $0x8043c8
  803080:	68 e8 00 00 00       	push   $0xe8
  803085:	68 37 43 80 00       	push   $0x804337
  80308a:	e8 26 da ff ff       	call   800ab5 <_panic>

0080308f <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80308f:	55                   	push   %ebp
  803090:	89 e5                	mov    %esp,%ebp
  803092:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  803095:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80309a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  80309d:	a1 38 51 80 00       	mov    0x805138,%eax
  8030a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  8030a5:	a1 44 51 80 00       	mov    0x805144,%eax
  8030aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  8030ad:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030b1:	75 68                	jne    80311b <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8030b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030b7:	75 17                	jne    8030d0 <insert_sorted_with_merge_freeList+0x41>
  8030b9:	83 ec 04             	sub    $0x4,%esp
  8030bc:	68 14 43 80 00       	push   $0x804314
  8030c1:	68 36 01 00 00       	push   $0x136
  8030c6:	68 37 43 80 00       	push   $0x804337
  8030cb:	e8 e5 d9 ff ff       	call   800ab5 <_panic>
  8030d0:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8030d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d9:	89 10                	mov    %edx,(%eax)
  8030db:	8b 45 08             	mov    0x8(%ebp),%eax
  8030de:	8b 00                	mov    (%eax),%eax
  8030e0:	85 c0                	test   %eax,%eax
  8030e2:	74 0d                	je     8030f1 <insert_sorted_with_merge_freeList+0x62>
  8030e4:	a1 38 51 80 00       	mov    0x805138,%eax
  8030e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8030ec:	89 50 04             	mov    %edx,0x4(%eax)
  8030ef:	eb 08                	jmp    8030f9 <insert_sorted_with_merge_freeList+0x6a>
  8030f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fc:	a3 38 51 80 00       	mov    %eax,0x805138
  803101:	8b 45 08             	mov    0x8(%ebp),%eax
  803104:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80310b:	a1 44 51 80 00       	mov    0x805144,%eax
  803110:	40                   	inc    %eax
  803111:	a3 44 51 80 00       	mov    %eax,0x805144





}
  803116:	e9 ba 06 00 00       	jmp    8037d5 <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  80311b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80311e:	8b 50 08             	mov    0x8(%eax),%edx
  803121:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803124:	8b 40 0c             	mov    0xc(%eax),%eax
  803127:	01 c2                	add    %eax,%edx
  803129:	8b 45 08             	mov    0x8(%ebp),%eax
  80312c:	8b 40 08             	mov    0x8(%eax),%eax
  80312f:	39 c2                	cmp    %eax,%edx
  803131:	73 68                	jae    80319b <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803133:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803137:	75 17                	jne    803150 <insert_sorted_with_merge_freeList+0xc1>
  803139:	83 ec 04             	sub    $0x4,%esp
  80313c:	68 50 43 80 00       	push   $0x804350
  803141:	68 3a 01 00 00       	push   $0x13a
  803146:	68 37 43 80 00       	push   $0x804337
  80314b:	e8 65 d9 ff ff       	call   800ab5 <_panic>
  803150:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803156:	8b 45 08             	mov    0x8(%ebp),%eax
  803159:	89 50 04             	mov    %edx,0x4(%eax)
  80315c:	8b 45 08             	mov    0x8(%ebp),%eax
  80315f:	8b 40 04             	mov    0x4(%eax),%eax
  803162:	85 c0                	test   %eax,%eax
  803164:	74 0c                	je     803172 <insert_sorted_with_merge_freeList+0xe3>
  803166:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80316b:	8b 55 08             	mov    0x8(%ebp),%edx
  80316e:	89 10                	mov    %edx,(%eax)
  803170:	eb 08                	jmp    80317a <insert_sorted_with_merge_freeList+0xeb>
  803172:	8b 45 08             	mov    0x8(%ebp),%eax
  803175:	a3 38 51 80 00       	mov    %eax,0x805138
  80317a:	8b 45 08             	mov    0x8(%ebp),%eax
  80317d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803182:	8b 45 08             	mov    0x8(%ebp),%eax
  803185:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80318b:	a1 44 51 80 00       	mov    0x805144,%eax
  803190:	40                   	inc    %eax
  803191:	a3 44 51 80 00       	mov    %eax,0x805144





}
  803196:	e9 3a 06 00 00       	jmp    8037d5 <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  80319b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80319e:	8b 50 08             	mov    0x8(%eax),%edx
  8031a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8031a7:	01 c2                	add    %eax,%edx
  8031a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ac:	8b 40 08             	mov    0x8(%eax),%eax
  8031af:	39 c2                	cmp    %eax,%edx
  8031b1:	0f 85 90 00 00 00    	jne    803247 <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  8031b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ba:	8b 50 0c             	mov    0xc(%eax),%edx
  8031bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8031c3:	01 c2                	add    %eax,%edx
  8031c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c8:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  8031cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ce:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  8031d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8031df:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031e3:	75 17                	jne    8031fc <insert_sorted_with_merge_freeList+0x16d>
  8031e5:	83 ec 04             	sub    $0x4,%esp
  8031e8:	68 14 43 80 00       	push   $0x804314
  8031ed:	68 41 01 00 00       	push   $0x141
  8031f2:	68 37 43 80 00       	push   $0x804337
  8031f7:	e8 b9 d8 ff ff       	call   800ab5 <_panic>
  8031fc:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803202:	8b 45 08             	mov    0x8(%ebp),%eax
  803205:	89 10                	mov    %edx,(%eax)
  803207:	8b 45 08             	mov    0x8(%ebp),%eax
  80320a:	8b 00                	mov    (%eax),%eax
  80320c:	85 c0                	test   %eax,%eax
  80320e:	74 0d                	je     80321d <insert_sorted_with_merge_freeList+0x18e>
  803210:	a1 48 51 80 00       	mov    0x805148,%eax
  803215:	8b 55 08             	mov    0x8(%ebp),%edx
  803218:	89 50 04             	mov    %edx,0x4(%eax)
  80321b:	eb 08                	jmp    803225 <insert_sorted_with_merge_freeList+0x196>
  80321d:	8b 45 08             	mov    0x8(%ebp),%eax
  803220:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803225:	8b 45 08             	mov    0x8(%ebp),%eax
  803228:	a3 48 51 80 00       	mov    %eax,0x805148
  80322d:	8b 45 08             	mov    0x8(%ebp),%eax
  803230:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803237:	a1 54 51 80 00       	mov    0x805154,%eax
  80323c:	40                   	inc    %eax
  80323d:	a3 54 51 80 00       	mov    %eax,0x805154





}
  803242:	e9 8e 05 00 00       	jmp    8037d5 <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  803247:	8b 45 08             	mov    0x8(%ebp),%eax
  80324a:	8b 50 08             	mov    0x8(%eax),%edx
  80324d:	8b 45 08             	mov    0x8(%ebp),%eax
  803250:	8b 40 0c             	mov    0xc(%eax),%eax
  803253:	01 c2                	add    %eax,%edx
  803255:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803258:	8b 40 08             	mov    0x8(%eax),%eax
  80325b:	39 c2                	cmp    %eax,%edx
  80325d:	73 68                	jae    8032c7 <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80325f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803263:	75 17                	jne    80327c <insert_sorted_with_merge_freeList+0x1ed>
  803265:	83 ec 04             	sub    $0x4,%esp
  803268:	68 14 43 80 00       	push   $0x804314
  80326d:	68 45 01 00 00       	push   $0x145
  803272:	68 37 43 80 00       	push   $0x804337
  803277:	e8 39 d8 ff ff       	call   800ab5 <_panic>
  80327c:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803282:	8b 45 08             	mov    0x8(%ebp),%eax
  803285:	89 10                	mov    %edx,(%eax)
  803287:	8b 45 08             	mov    0x8(%ebp),%eax
  80328a:	8b 00                	mov    (%eax),%eax
  80328c:	85 c0                	test   %eax,%eax
  80328e:	74 0d                	je     80329d <insert_sorted_with_merge_freeList+0x20e>
  803290:	a1 38 51 80 00       	mov    0x805138,%eax
  803295:	8b 55 08             	mov    0x8(%ebp),%edx
  803298:	89 50 04             	mov    %edx,0x4(%eax)
  80329b:	eb 08                	jmp    8032a5 <insert_sorted_with_merge_freeList+0x216>
  80329d:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a8:	a3 38 51 80 00       	mov    %eax,0x805138
  8032ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032b7:	a1 44 51 80 00       	mov    0x805144,%eax
  8032bc:	40                   	inc    %eax
  8032bd:	a3 44 51 80 00       	mov    %eax,0x805144





}
  8032c2:	e9 0e 05 00 00       	jmp    8037d5 <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  8032c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ca:	8b 50 08             	mov    0x8(%eax),%edx
  8032cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8032d3:	01 c2                	add    %eax,%edx
  8032d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032d8:	8b 40 08             	mov    0x8(%eax),%eax
  8032db:	39 c2                	cmp    %eax,%edx
  8032dd:	0f 85 9c 00 00 00    	jne    80337f <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  8032e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032e6:	8b 50 0c             	mov    0xc(%eax),%edx
  8032e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8032ef:	01 c2                	add    %eax,%edx
  8032f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032f4:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  8032f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fa:	8b 50 08             	mov    0x8(%eax),%edx
  8032fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803300:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  803303:	8b 45 08             	mov    0x8(%ebp),%eax
  803306:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  80330d:	8b 45 08             	mov    0x8(%ebp),%eax
  803310:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803317:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80331b:	75 17                	jne    803334 <insert_sorted_with_merge_freeList+0x2a5>
  80331d:	83 ec 04             	sub    $0x4,%esp
  803320:	68 14 43 80 00       	push   $0x804314
  803325:	68 4d 01 00 00       	push   $0x14d
  80332a:	68 37 43 80 00       	push   $0x804337
  80332f:	e8 81 d7 ff ff       	call   800ab5 <_panic>
  803334:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80333a:	8b 45 08             	mov    0x8(%ebp),%eax
  80333d:	89 10                	mov    %edx,(%eax)
  80333f:	8b 45 08             	mov    0x8(%ebp),%eax
  803342:	8b 00                	mov    (%eax),%eax
  803344:	85 c0                	test   %eax,%eax
  803346:	74 0d                	je     803355 <insert_sorted_with_merge_freeList+0x2c6>
  803348:	a1 48 51 80 00       	mov    0x805148,%eax
  80334d:	8b 55 08             	mov    0x8(%ebp),%edx
  803350:	89 50 04             	mov    %edx,0x4(%eax)
  803353:	eb 08                	jmp    80335d <insert_sorted_with_merge_freeList+0x2ce>
  803355:	8b 45 08             	mov    0x8(%ebp),%eax
  803358:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80335d:	8b 45 08             	mov    0x8(%ebp),%eax
  803360:	a3 48 51 80 00       	mov    %eax,0x805148
  803365:	8b 45 08             	mov    0x8(%ebp),%eax
  803368:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80336f:	a1 54 51 80 00       	mov    0x805154,%eax
  803374:	40                   	inc    %eax
  803375:	a3 54 51 80 00       	mov    %eax,0x805154





}
  80337a:	e9 56 04 00 00       	jmp    8037d5 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  80337f:	a1 38 51 80 00       	mov    0x805138,%eax
  803384:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803387:	e9 19 04 00 00       	jmp    8037a5 <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  80338c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80338f:	8b 00                	mov    (%eax),%eax
  803391:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  803394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803397:	8b 50 08             	mov    0x8(%eax),%edx
  80339a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339d:	8b 40 0c             	mov    0xc(%eax),%eax
  8033a0:	01 c2                	add    %eax,%edx
  8033a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a5:	8b 40 08             	mov    0x8(%eax),%eax
  8033a8:	39 c2                	cmp    %eax,%edx
  8033aa:	0f 85 ad 01 00 00    	jne    80355d <insert_sorted_with_merge_freeList+0x4ce>
  8033b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b3:	8b 50 08             	mov    0x8(%eax),%edx
  8033b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8033bc:	01 c2                	add    %eax,%edx
  8033be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033c1:	8b 40 08             	mov    0x8(%eax),%eax
  8033c4:	39 c2                	cmp    %eax,%edx
  8033c6:	0f 85 91 01 00 00    	jne    80355d <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  8033cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033cf:	8b 50 0c             	mov    0xc(%eax),%edx
  8033d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d5:	8b 48 0c             	mov    0xc(%eax),%ecx
  8033d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033db:	8b 40 0c             	mov    0xc(%eax),%eax
  8033de:	01 c8                	add    %ecx,%eax
  8033e0:	01 c2                	add    %eax,%edx
  8033e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e5:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  8033e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033eb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  8033f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  8033fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033ff:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  803406:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803409:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  803410:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803414:	75 17                	jne    80342d <insert_sorted_with_merge_freeList+0x39e>
  803416:	83 ec 04             	sub    $0x4,%esp
  803419:	68 a8 43 80 00       	push   $0x8043a8
  80341e:	68 5b 01 00 00       	push   $0x15b
  803423:	68 37 43 80 00       	push   $0x804337
  803428:	e8 88 d6 ff ff       	call   800ab5 <_panic>
  80342d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803430:	8b 00                	mov    (%eax),%eax
  803432:	85 c0                	test   %eax,%eax
  803434:	74 10                	je     803446 <insert_sorted_with_merge_freeList+0x3b7>
  803436:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803439:	8b 00                	mov    (%eax),%eax
  80343b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80343e:	8b 52 04             	mov    0x4(%edx),%edx
  803441:	89 50 04             	mov    %edx,0x4(%eax)
  803444:	eb 0b                	jmp    803451 <insert_sorted_with_merge_freeList+0x3c2>
  803446:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803449:	8b 40 04             	mov    0x4(%eax),%eax
  80344c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803451:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803454:	8b 40 04             	mov    0x4(%eax),%eax
  803457:	85 c0                	test   %eax,%eax
  803459:	74 0f                	je     80346a <insert_sorted_with_merge_freeList+0x3db>
  80345b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80345e:	8b 40 04             	mov    0x4(%eax),%eax
  803461:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803464:	8b 12                	mov    (%edx),%edx
  803466:	89 10                	mov    %edx,(%eax)
  803468:	eb 0a                	jmp    803474 <insert_sorted_with_merge_freeList+0x3e5>
  80346a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80346d:	8b 00                	mov    (%eax),%eax
  80346f:	a3 38 51 80 00       	mov    %eax,0x805138
  803474:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803477:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80347d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803480:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803487:	a1 44 51 80 00       	mov    0x805144,%eax
  80348c:	48                   	dec    %eax
  80348d:	a3 44 51 80 00       	mov    %eax,0x805144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803492:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803496:	75 17                	jne    8034af <insert_sorted_with_merge_freeList+0x420>
  803498:	83 ec 04             	sub    $0x4,%esp
  80349b:	68 14 43 80 00       	push   $0x804314
  8034a0:	68 5c 01 00 00       	push   $0x15c
  8034a5:	68 37 43 80 00       	push   $0x804337
  8034aa:	e8 06 d6 ff ff       	call   800ab5 <_panic>
  8034af:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b8:	89 10                	mov    %edx,(%eax)
  8034ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8034bd:	8b 00                	mov    (%eax),%eax
  8034bf:	85 c0                	test   %eax,%eax
  8034c1:	74 0d                	je     8034d0 <insert_sorted_with_merge_freeList+0x441>
  8034c3:	a1 48 51 80 00       	mov    0x805148,%eax
  8034c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8034cb:	89 50 04             	mov    %edx,0x4(%eax)
  8034ce:	eb 08                	jmp    8034d8 <insert_sorted_with_merge_freeList+0x449>
  8034d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034db:	a3 48 51 80 00       	mov    %eax,0x805148
  8034e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034ea:	a1 54 51 80 00       	mov    0x805154,%eax
  8034ef:	40                   	inc    %eax
  8034f0:	a3 54 51 80 00       	mov    %eax,0x805154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  8034f5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8034f9:	75 17                	jne    803512 <insert_sorted_with_merge_freeList+0x483>
  8034fb:	83 ec 04             	sub    $0x4,%esp
  8034fe:	68 14 43 80 00       	push   $0x804314
  803503:	68 5d 01 00 00       	push   $0x15d
  803508:	68 37 43 80 00       	push   $0x804337
  80350d:	e8 a3 d5 ff ff       	call   800ab5 <_panic>
  803512:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803518:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80351b:	89 10                	mov    %edx,(%eax)
  80351d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803520:	8b 00                	mov    (%eax),%eax
  803522:	85 c0                	test   %eax,%eax
  803524:	74 0d                	je     803533 <insert_sorted_with_merge_freeList+0x4a4>
  803526:	a1 48 51 80 00       	mov    0x805148,%eax
  80352b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80352e:	89 50 04             	mov    %edx,0x4(%eax)
  803531:	eb 08                	jmp    80353b <insert_sorted_with_merge_freeList+0x4ac>
  803533:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803536:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80353b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80353e:	a3 48 51 80 00       	mov    %eax,0x805148
  803543:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803546:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80354d:	a1 54 51 80 00       	mov    0x805154,%eax
  803552:	40                   	inc    %eax
  803553:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  803558:	e9 78 02 00 00       	jmp    8037d5 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  80355d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803560:	8b 50 08             	mov    0x8(%eax),%edx
  803563:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803566:	8b 40 0c             	mov    0xc(%eax),%eax
  803569:	01 c2                	add    %eax,%edx
  80356b:	8b 45 08             	mov    0x8(%ebp),%eax
  80356e:	8b 40 08             	mov    0x8(%eax),%eax
  803571:	39 c2                	cmp    %eax,%edx
  803573:	0f 83 b8 00 00 00    	jae    803631 <insert_sorted_with_merge_freeList+0x5a2>
  803579:	8b 45 08             	mov    0x8(%ebp),%eax
  80357c:	8b 50 08             	mov    0x8(%eax),%edx
  80357f:	8b 45 08             	mov    0x8(%ebp),%eax
  803582:	8b 40 0c             	mov    0xc(%eax),%eax
  803585:	01 c2                	add    %eax,%edx
  803587:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80358a:	8b 40 08             	mov    0x8(%eax),%eax
  80358d:	39 c2                	cmp    %eax,%edx
  80358f:	0f 85 9c 00 00 00    	jne    803631 <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  803595:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803598:	8b 50 0c             	mov    0xc(%eax),%edx
  80359b:	8b 45 08             	mov    0x8(%ebp),%eax
  80359e:	8b 40 0c             	mov    0xc(%eax),%eax
  8035a1:	01 c2                	add    %eax,%edx
  8035a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035a6:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  8035a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ac:	8b 50 08             	mov    0x8(%eax),%edx
  8035af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035b2:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  8035b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  8035bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8035c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035cd:	75 17                	jne    8035e6 <insert_sorted_with_merge_freeList+0x557>
  8035cf:	83 ec 04             	sub    $0x4,%esp
  8035d2:	68 14 43 80 00       	push   $0x804314
  8035d7:	68 67 01 00 00       	push   $0x167
  8035dc:	68 37 43 80 00       	push   $0x804337
  8035e1:	e8 cf d4 ff ff       	call   800ab5 <_panic>
  8035e6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ef:	89 10                	mov    %edx,(%eax)
  8035f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f4:	8b 00                	mov    (%eax),%eax
  8035f6:	85 c0                	test   %eax,%eax
  8035f8:	74 0d                	je     803607 <insert_sorted_with_merge_freeList+0x578>
  8035fa:	a1 48 51 80 00       	mov    0x805148,%eax
  8035ff:	8b 55 08             	mov    0x8(%ebp),%edx
  803602:	89 50 04             	mov    %edx,0x4(%eax)
  803605:	eb 08                	jmp    80360f <insert_sorted_with_merge_freeList+0x580>
  803607:	8b 45 08             	mov    0x8(%ebp),%eax
  80360a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80360f:	8b 45 08             	mov    0x8(%ebp),%eax
  803612:	a3 48 51 80 00       	mov    %eax,0x805148
  803617:	8b 45 08             	mov    0x8(%ebp),%eax
  80361a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803621:	a1 54 51 80 00       	mov    0x805154,%eax
  803626:	40                   	inc    %eax
  803627:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  80362c:	e9 a4 01 00 00       	jmp    8037d5 <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  803631:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803634:	8b 50 08             	mov    0x8(%eax),%edx
  803637:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80363a:	8b 40 0c             	mov    0xc(%eax),%eax
  80363d:	01 c2                	add    %eax,%edx
  80363f:	8b 45 08             	mov    0x8(%ebp),%eax
  803642:	8b 40 08             	mov    0x8(%eax),%eax
  803645:	39 c2                	cmp    %eax,%edx
  803647:	0f 85 ac 00 00 00    	jne    8036f9 <insert_sorted_with_merge_freeList+0x66a>
  80364d:	8b 45 08             	mov    0x8(%ebp),%eax
  803650:	8b 50 08             	mov    0x8(%eax),%edx
  803653:	8b 45 08             	mov    0x8(%ebp),%eax
  803656:	8b 40 0c             	mov    0xc(%eax),%eax
  803659:	01 c2                	add    %eax,%edx
  80365b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80365e:	8b 40 08             	mov    0x8(%eax),%eax
  803661:	39 c2                	cmp    %eax,%edx
  803663:	0f 83 90 00 00 00    	jae    8036f9 <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  803669:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80366c:	8b 50 0c             	mov    0xc(%eax),%edx
  80366f:	8b 45 08             	mov    0x8(%ebp),%eax
  803672:	8b 40 0c             	mov    0xc(%eax),%eax
  803675:	01 c2                	add    %eax,%edx
  803677:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80367a:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  80367d:	8b 45 08             	mov    0x8(%ebp),%eax
  803680:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  803687:	8b 45 08             	mov    0x8(%ebp),%eax
  80368a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803691:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803695:	75 17                	jne    8036ae <insert_sorted_with_merge_freeList+0x61f>
  803697:	83 ec 04             	sub    $0x4,%esp
  80369a:	68 14 43 80 00       	push   $0x804314
  80369f:	68 70 01 00 00       	push   $0x170
  8036a4:	68 37 43 80 00       	push   $0x804337
  8036a9:	e8 07 d4 ff ff       	call   800ab5 <_panic>
  8036ae:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b7:	89 10                	mov    %edx,(%eax)
  8036b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8036bc:	8b 00                	mov    (%eax),%eax
  8036be:	85 c0                	test   %eax,%eax
  8036c0:	74 0d                	je     8036cf <insert_sorted_with_merge_freeList+0x640>
  8036c2:	a1 48 51 80 00       	mov    0x805148,%eax
  8036c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8036ca:	89 50 04             	mov    %edx,0x4(%eax)
  8036cd:	eb 08                	jmp    8036d7 <insert_sorted_with_merge_freeList+0x648>
  8036cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036da:	a3 48 51 80 00       	mov    %eax,0x805148
  8036df:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036e9:	a1 54 51 80 00       	mov    0x805154,%eax
  8036ee:	40                   	inc    %eax
  8036ef:	a3 54 51 80 00       	mov    %eax,0x805154
	      break;
  8036f4:	e9 dc 00 00 00       	jmp    8037d5 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  8036f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036fc:	8b 50 08             	mov    0x8(%eax),%edx
  8036ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803702:	8b 40 0c             	mov    0xc(%eax),%eax
  803705:	01 c2                	add    %eax,%edx
  803707:	8b 45 08             	mov    0x8(%ebp),%eax
  80370a:	8b 40 08             	mov    0x8(%eax),%eax
  80370d:	39 c2                	cmp    %eax,%edx
  80370f:	0f 83 88 00 00 00    	jae    80379d <insert_sorted_with_merge_freeList+0x70e>
  803715:	8b 45 08             	mov    0x8(%ebp),%eax
  803718:	8b 50 08             	mov    0x8(%eax),%edx
  80371b:	8b 45 08             	mov    0x8(%ebp),%eax
  80371e:	8b 40 0c             	mov    0xc(%eax),%eax
  803721:	01 c2                	add    %eax,%edx
  803723:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803726:	8b 40 08             	mov    0x8(%eax),%eax
  803729:	39 c2                	cmp    %eax,%edx
  80372b:	73 70                	jae    80379d <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  80372d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803731:	74 06                	je     803739 <insert_sorted_with_merge_freeList+0x6aa>
  803733:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803737:	75 17                	jne    803750 <insert_sorted_with_merge_freeList+0x6c1>
  803739:	83 ec 04             	sub    $0x4,%esp
  80373c:	68 74 43 80 00       	push   $0x804374
  803741:	68 75 01 00 00       	push   $0x175
  803746:	68 37 43 80 00       	push   $0x804337
  80374b:	e8 65 d3 ff ff       	call   800ab5 <_panic>
  803750:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803753:	8b 10                	mov    (%eax),%edx
  803755:	8b 45 08             	mov    0x8(%ebp),%eax
  803758:	89 10                	mov    %edx,(%eax)
  80375a:	8b 45 08             	mov    0x8(%ebp),%eax
  80375d:	8b 00                	mov    (%eax),%eax
  80375f:	85 c0                	test   %eax,%eax
  803761:	74 0b                	je     80376e <insert_sorted_with_merge_freeList+0x6df>
  803763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803766:	8b 00                	mov    (%eax),%eax
  803768:	8b 55 08             	mov    0x8(%ebp),%edx
  80376b:	89 50 04             	mov    %edx,0x4(%eax)
  80376e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803771:	8b 55 08             	mov    0x8(%ebp),%edx
  803774:	89 10                	mov    %edx,(%eax)
  803776:	8b 45 08             	mov    0x8(%ebp),%eax
  803779:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80377c:	89 50 04             	mov    %edx,0x4(%eax)
  80377f:	8b 45 08             	mov    0x8(%ebp),%eax
  803782:	8b 00                	mov    (%eax),%eax
  803784:	85 c0                	test   %eax,%eax
  803786:	75 08                	jne    803790 <insert_sorted_with_merge_freeList+0x701>
  803788:	8b 45 08             	mov    0x8(%ebp),%eax
  80378b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803790:	a1 44 51 80 00       	mov    0x805144,%eax
  803795:	40                   	inc    %eax
  803796:	a3 44 51 80 00       	mov    %eax,0x805144
	      break;
  80379b:	eb 38                	jmp    8037d5 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  80379d:	a1 40 51 80 00       	mov    0x805140,%eax
  8037a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037a9:	74 07                	je     8037b2 <insert_sorted_with_merge_freeList+0x723>
  8037ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ae:	8b 00                	mov    (%eax),%eax
  8037b0:	eb 05                	jmp    8037b7 <insert_sorted_with_merge_freeList+0x728>
  8037b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8037b7:	a3 40 51 80 00       	mov    %eax,0x805140
  8037bc:	a1 40 51 80 00       	mov    0x805140,%eax
  8037c1:	85 c0                	test   %eax,%eax
  8037c3:	0f 85 c3 fb ff ff    	jne    80338c <insert_sorted_with_merge_freeList+0x2fd>
  8037c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037cd:	0f 85 b9 fb ff ff    	jne    80338c <insert_sorted_with_merge_freeList+0x2fd>





}
  8037d3:	eb 00                	jmp    8037d5 <insert_sorted_with_merge_freeList+0x746>
  8037d5:	90                   	nop
  8037d6:	c9                   	leave  
  8037d7:	c3                   	ret    

008037d8 <__udivdi3>:
  8037d8:	55                   	push   %ebp
  8037d9:	57                   	push   %edi
  8037da:	56                   	push   %esi
  8037db:	53                   	push   %ebx
  8037dc:	83 ec 1c             	sub    $0x1c,%esp
  8037df:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8037e3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8037e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037eb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8037ef:	89 ca                	mov    %ecx,%edx
  8037f1:	89 f8                	mov    %edi,%eax
  8037f3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8037f7:	85 f6                	test   %esi,%esi
  8037f9:	75 2d                	jne    803828 <__udivdi3+0x50>
  8037fb:	39 cf                	cmp    %ecx,%edi
  8037fd:	77 65                	ja     803864 <__udivdi3+0x8c>
  8037ff:	89 fd                	mov    %edi,%ebp
  803801:	85 ff                	test   %edi,%edi
  803803:	75 0b                	jne    803810 <__udivdi3+0x38>
  803805:	b8 01 00 00 00       	mov    $0x1,%eax
  80380a:	31 d2                	xor    %edx,%edx
  80380c:	f7 f7                	div    %edi
  80380e:	89 c5                	mov    %eax,%ebp
  803810:	31 d2                	xor    %edx,%edx
  803812:	89 c8                	mov    %ecx,%eax
  803814:	f7 f5                	div    %ebp
  803816:	89 c1                	mov    %eax,%ecx
  803818:	89 d8                	mov    %ebx,%eax
  80381a:	f7 f5                	div    %ebp
  80381c:	89 cf                	mov    %ecx,%edi
  80381e:	89 fa                	mov    %edi,%edx
  803820:	83 c4 1c             	add    $0x1c,%esp
  803823:	5b                   	pop    %ebx
  803824:	5e                   	pop    %esi
  803825:	5f                   	pop    %edi
  803826:	5d                   	pop    %ebp
  803827:	c3                   	ret    
  803828:	39 ce                	cmp    %ecx,%esi
  80382a:	77 28                	ja     803854 <__udivdi3+0x7c>
  80382c:	0f bd fe             	bsr    %esi,%edi
  80382f:	83 f7 1f             	xor    $0x1f,%edi
  803832:	75 40                	jne    803874 <__udivdi3+0x9c>
  803834:	39 ce                	cmp    %ecx,%esi
  803836:	72 0a                	jb     803842 <__udivdi3+0x6a>
  803838:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80383c:	0f 87 9e 00 00 00    	ja     8038e0 <__udivdi3+0x108>
  803842:	b8 01 00 00 00       	mov    $0x1,%eax
  803847:	89 fa                	mov    %edi,%edx
  803849:	83 c4 1c             	add    $0x1c,%esp
  80384c:	5b                   	pop    %ebx
  80384d:	5e                   	pop    %esi
  80384e:	5f                   	pop    %edi
  80384f:	5d                   	pop    %ebp
  803850:	c3                   	ret    
  803851:	8d 76 00             	lea    0x0(%esi),%esi
  803854:	31 ff                	xor    %edi,%edi
  803856:	31 c0                	xor    %eax,%eax
  803858:	89 fa                	mov    %edi,%edx
  80385a:	83 c4 1c             	add    $0x1c,%esp
  80385d:	5b                   	pop    %ebx
  80385e:	5e                   	pop    %esi
  80385f:	5f                   	pop    %edi
  803860:	5d                   	pop    %ebp
  803861:	c3                   	ret    
  803862:	66 90                	xchg   %ax,%ax
  803864:	89 d8                	mov    %ebx,%eax
  803866:	f7 f7                	div    %edi
  803868:	31 ff                	xor    %edi,%edi
  80386a:	89 fa                	mov    %edi,%edx
  80386c:	83 c4 1c             	add    $0x1c,%esp
  80386f:	5b                   	pop    %ebx
  803870:	5e                   	pop    %esi
  803871:	5f                   	pop    %edi
  803872:	5d                   	pop    %ebp
  803873:	c3                   	ret    
  803874:	bd 20 00 00 00       	mov    $0x20,%ebp
  803879:	89 eb                	mov    %ebp,%ebx
  80387b:	29 fb                	sub    %edi,%ebx
  80387d:	89 f9                	mov    %edi,%ecx
  80387f:	d3 e6                	shl    %cl,%esi
  803881:	89 c5                	mov    %eax,%ebp
  803883:	88 d9                	mov    %bl,%cl
  803885:	d3 ed                	shr    %cl,%ebp
  803887:	89 e9                	mov    %ebp,%ecx
  803889:	09 f1                	or     %esi,%ecx
  80388b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80388f:	89 f9                	mov    %edi,%ecx
  803891:	d3 e0                	shl    %cl,%eax
  803893:	89 c5                	mov    %eax,%ebp
  803895:	89 d6                	mov    %edx,%esi
  803897:	88 d9                	mov    %bl,%cl
  803899:	d3 ee                	shr    %cl,%esi
  80389b:	89 f9                	mov    %edi,%ecx
  80389d:	d3 e2                	shl    %cl,%edx
  80389f:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038a3:	88 d9                	mov    %bl,%cl
  8038a5:	d3 e8                	shr    %cl,%eax
  8038a7:	09 c2                	or     %eax,%edx
  8038a9:	89 d0                	mov    %edx,%eax
  8038ab:	89 f2                	mov    %esi,%edx
  8038ad:	f7 74 24 0c          	divl   0xc(%esp)
  8038b1:	89 d6                	mov    %edx,%esi
  8038b3:	89 c3                	mov    %eax,%ebx
  8038b5:	f7 e5                	mul    %ebp
  8038b7:	39 d6                	cmp    %edx,%esi
  8038b9:	72 19                	jb     8038d4 <__udivdi3+0xfc>
  8038bb:	74 0b                	je     8038c8 <__udivdi3+0xf0>
  8038bd:	89 d8                	mov    %ebx,%eax
  8038bf:	31 ff                	xor    %edi,%edi
  8038c1:	e9 58 ff ff ff       	jmp    80381e <__udivdi3+0x46>
  8038c6:	66 90                	xchg   %ax,%ax
  8038c8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8038cc:	89 f9                	mov    %edi,%ecx
  8038ce:	d3 e2                	shl    %cl,%edx
  8038d0:	39 c2                	cmp    %eax,%edx
  8038d2:	73 e9                	jae    8038bd <__udivdi3+0xe5>
  8038d4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8038d7:	31 ff                	xor    %edi,%edi
  8038d9:	e9 40 ff ff ff       	jmp    80381e <__udivdi3+0x46>
  8038de:	66 90                	xchg   %ax,%ax
  8038e0:	31 c0                	xor    %eax,%eax
  8038e2:	e9 37 ff ff ff       	jmp    80381e <__udivdi3+0x46>
  8038e7:	90                   	nop

008038e8 <__umoddi3>:
  8038e8:	55                   	push   %ebp
  8038e9:	57                   	push   %edi
  8038ea:	56                   	push   %esi
  8038eb:	53                   	push   %ebx
  8038ec:	83 ec 1c             	sub    $0x1c,%esp
  8038ef:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8038f3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8038f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8038fb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8038ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803903:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803907:	89 f3                	mov    %esi,%ebx
  803909:	89 fa                	mov    %edi,%edx
  80390b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80390f:	89 34 24             	mov    %esi,(%esp)
  803912:	85 c0                	test   %eax,%eax
  803914:	75 1a                	jne    803930 <__umoddi3+0x48>
  803916:	39 f7                	cmp    %esi,%edi
  803918:	0f 86 a2 00 00 00    	jbe    8039c0 <__umoddi3+0xd8>
  80391e:	89 c8                	mov    %ecx,%eax
  803920:	89 f2                	mov    %esi,%edx
  803922:	f7 f7                	div    %edi
  803924:	89 d0                	mov    %edx,%eax
  803926:	31 d2                	xor    %edx,%edx
  803928:	83 c4 1c             	add    $0x1c,%esp
  80392b:	5b                   	pop    %ebx
  80392c:	5e                   	pop    %esi
  80392d:	5f                   	pop    %edi
  80392e:	5d                   	pop    %ebp
  80392f:	c3                   	ret    
  803930:	39 f0                	cmp    %esi,%eax
  803932:	0f 87 ac 00 00 00    	ja     8039e4 <__umoddi3+0xfc>
  803938:	0f bd e8             	bsr    %eax,%ebp
  80393b:	83 f5 1f             	xor    $0x1f,%ebp
  80393e:	0f 84 ac 00 00 00    	je     8039f0 <__umoddi3+0x108>
  803944:	bf 20 00 00 00       	mov    $0x20,%edi
  803949:	29 ef                	sub    %ebp,%edi
  80394b:	89 fe                	mov    %edi,%esi
  80394d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803951:	89 e9                	mov    %ebp,%ecx
  803953:	d3 e0                	shl    %cl,%eax
  803955:	89 d7                	mov    %edx,%edi
  803957:	89 f1                	mov    %esi,%ecx
  803959:	d3 ef                	shr    %cl,%edi
  80395b:	09 c7                	or     %eax,%edi
  80395d:	89 e9                	mov    %ebp,%ecx
  80395f:	d3 e2                	shl    %cl,%edx
  803961:	89 14 24             	mov    %edx,(%esp)
  803964:	89 d8                	mov    %ebx,%eax
  803966:	d3 e0                	shl    %cl,%eax
  803968:	89 c2                	mov    %eax,%edx
  80396a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80396e:	d3 e0                	shl    %cl,%eax
  803970:	89 44 24 04          	mov    %eax,0x4(%esp)
  803974:	8b 44 24 08          	mov    0x8(%esp),%eax
  803978:	89 f1                	mov    %esi,%ecx
  80397a:	d3 e8                	shr    %cl,%eax
  80397c:	09 d0                	or     %edx,%eax
  80397e:	d3 eb                	shr    %cl,%ebx
  803980:	89 da                	mov    %ebx,%edx
  803982:	f7 f7                	div    %edi
  803984:	89 d3                	mov    %edx,%ebx
  803986:	f7 24 24             	mull   (%esp)
  803989:	89 c6                	mov    %eax,%esi
  80398b:	89 d1                	mov    %edx,%ecx
  80398d:	39 d3                	cmp    %edx,%ebx
  80398f:	0f 82 87 00 00 00    	jb     803a1c <__umoddi3+0x134>
  803995:	0f 84 91 00 00 00    	je     803a2c <__umoddi3+0x144>
  80399b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80399f:	29 f2                	sub    %esi,%edx
  8039a1:	19 cb                	sbb    %ecx,%ebx
  8039a3:	89 d8                	mov    %ebx,%eax
  8039a5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8039a9:	d3 e0                	shl    %cl,%eax
  8039ab:	89 e9                	mov    %ebp,%ecx
  8039ad:	d3 ea                	shr    %cl,%edx
  8039af:	09 d0                	or     %edx,%eax
  8039b1:	89 e9                	mov    %ebp,%ecx
  8039b3:	d3 eb                	shr    %cl,%ebx
  8039b5:	89 da                	mov    %ebx,%edx
  8039b7:	83 c4 1c             	add    $0x1c,%esp
  8039ba:	5b                   	pop    %ebx
  8039bb:	5e                   	pop    %esi
  8039bc:	5f                   	pop    %edi
  8039bd:	5d                   	pop    %ebp
  8039be:	c3                   	ret    
  8039bf:	90                   	nop
  8039c0:	89 fd                	mov    %edi,%ebp
  8039c2:	85 ff                	test   %edi,%edi
  8039c4:	75 0b                	jne    8039d1 <__umoddi3+0xe9>
  8039c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8039cb:	31 d2                	xor    %edx,%edx
  8039cd:	f7 f7                	div    %edi
  8039cf:	89 c5                	mov    %eax,%ebp
  8039d1:	89 f0                	mov    %esi,%eax
  8039d3:	31 d2                	xor    %edx,%edx
  8039d5:	f7 f5                	div    %ebp
  8039d7:	89 c8                	mov    %ecx,%eax
  8039d9:	f7 f5                	div    %ebp
  8039db:	89 d0                	mov    %edx,%eax
  8039dd:	e9 44 ff ff ff       	jmp    803926 <__umoddi3+0x3e>
  8039e2:	66 90                	xchg   %ax,%ax
  8039e4:	89 c8                	mov    %ecx,%eax
  8039e6:	89 f2                	mov    %esi,%edx
  8039e8:	83 c4 1c             	add    $0x1c,%esp
  8039eb:	5b                   	pop    %ebx
  8039ec:	5e                   	pop    %esi
  8039ed:	5f                   	pop    %edi
  8039ee:	5d                   	pop    %ebp
  8039ef:	c3                   	ret    
  8039f0:	3b 04 24             	cmp    (%esp),%eax
  8039f3:	72 06                	jb     8039fb <__umoddi3+0x113>
  8039f5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8039f9:	77 0f                	ja     803a0a <__umoddi3+0x122>
  8039fb:	89 f2                	mov    %esi,%edx
  8039fd:	29 f9                	sub    %edi,%ecx
  8039ff:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803a03:	89 14 24             	mov    %edx,(%esp)
  803a06:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a0a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803a0e:	8b 14 24             	mov    (%esp),%edx
  803a11:	83 c4 1c             	add    $0x1c,%esp
  803a14:	5b                   	pop    %ebx
  803a15:	5e                   	pop    %esi
  803a16:	5f                   	pop    %edi
  803a17:	5d                   	pop    %ebp
  803a18:	c3                   	ret    
  803a19:	8d 76 00             	lea    0x0(%esi),%esi
  803a1c:	2b 04 24             	sub    (%esp),%eax
  803a1f:	19 fa                	sbb    %edi,%edx
  803a21:	89 d1                	mov    %edx,%ecx
  803a23:	89 c6                	mov    %eax,%esi
  803a25:	e9 71 ff ff ff       	jmp    80399b <__umoddi3+0xb3>
  803a2a:	66 90                	xchg   %ax,%ax
  803a2c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803a30:	72 ea                	jb     803a1c <__umoddi3+0x134>
  803a32:	89 d9                	mov    %ebx,%ecx
  803a34:	e9 62 ff ff ff       	jmp    80399b <__umoddi3+0xb3>
