
obj/user/tst_best_fit_2:     file format elf32-i386


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
  800031:	e8 b5 08 00 00       	call   8008eb <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
	char a;
	short b;
	int c;
};
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 70             	sub    $0x70,%esp
	sys_set_uheap_strategy(UHP_PLACE_BESTFIT);
  800040:	83 ec 0c             	sub    $0xc,%esp
  800043:	6a 02                	push   $0x2
  800045:	e8 5e 25 00 00       	call   8025a8 <sys_set_uheap_strategy>
  80004a:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80004d:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800051:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800058:	eb 29                	jmp    800083 <_main+0x4b>
		{
			if (myEnv->__uptr_pws[i].empty)
  80005a:	a1 20 50 80 00       	mov    0x805020,%eax
  80005f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800065:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800068:	89 d0                	mov    %edx,%eax
  80006a:	01 c0                	add    %eax,%eax
  80006c:	01 d0                	add    %edx,%eax
  80006e:	c1 e0 03             	shl    $0x3,%eax
  800071:	01 c8                	add    %ecx,%eax
  800073:	8a 40 04             	mov    0x4(%eax),%al
  800076:	84 c0                	test   %al,%al
  800078:	74 06                	je     800080 <_main+0x48>
			{
				fullWS = 0;
  80007a:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80007e:	eb 12                	jmp    800092 <_main+0x5a>
	sys_set_uheap_strategy(UHP_PLACE_BESTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800080:	ff 45 f0             	incl   -0x10(%ebp)
  800083:	a1 20 50 80 00       	mov    0x805020,%eax
  800088:	8b 50 74             	mov    0x74(%eax),%edx
  80008b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80008e:	39 c2                	cmp    %eax,%edx
  800090:	77 c8                	ja     80005a <_main+0x22>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800092:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800096:	74 14                	je     8000ac <_main+0x74>
  800098:	83 ec 04             	sub    $0x4,%esp
  80009b:	68 c0 39 80 00       	push   $0x8039c0
  8000a0:	6a 1b                	push   $0x1b
  8000a2:	68 dc 39 80 00       	push   $0x8039dc
  8000a7:	e8 7b 09 00 00       	call   800a27 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	6a 00                	push   $0x0
  8000b1:	e8 9e 1b 00 00       	call   801c54 <malloc>
  8000b6:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int Mega = 1024*1024;
  8000b9:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000c0:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	void* ptr_allocations[20] = {0};
  8000c7:	8d 55 90             	lea    -0x70(%ebp),%edx
  8000ca:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d4:	89 d7                	mov    %edx,%edi
  8000d6:	f3 ab                	rep stos %eax,%es:(%edi)

	//[1] Attempt to allocate more than heap size
	{
		ptr_allocations[0] = malloc(USER_HEAP_MAX - USER_HEAP_START + 1);
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	68 01 00 00 20       	push   $0x20000001
  8000e0:	e8 6f 1b 00 00       	call   801c54 <malloc>
  8000e5:	83 c4 10             	add    $0x10,%esp
  8000e8:	89 45 90             	mov    %eax,-0x70(%ebp)
		if (ptr_allocations[0] != NULL) panic("Malloc: Attempt to allocate more than heap size, should return NULL");
  8000eb:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000ee:	85 c0                	test   %eax,%eax
  8000f0:	74 14                	je     800106 <_main+0xce>
  8000f2:	83 ec 04             	sub    $0x4,%esp
  8000f5:	68 f4 39 80 00       	push   $0x8039f4
  8000fa:	6a 28                	push   $0x28
  8000fc:	68 dc 39 80 00       	push   $0x8039dc
  800101:	e8 21 09 00 00       	call   800a27 <_panic>
	}
	//[2] Attempt to allocate space more than any available fragment
	//	a) Create Fragments
	{
		//2 MB
		int freeFrames = sys_calculate_free_frames() ;
  800106:	e8 88 1f 00 00       	call   802093 <sys_calculate_free_frames>
  80010b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages();
  80010e:	e8 20 20 00 00       	call   802133 <sys_pf_calculate_allocated_pages>
  800113:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800116:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800119:	01 c0                	add    %eax,%eax
  80011b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	50                   	push   %eax
  800122:	e8 2d 1b 00 00       	call   801c54 <malloc>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START) ) panic("Wrong start address for the allocated space... ");
  80012d:	8b 45 90             	mov    -0x70(%ebp),%eax
  800130:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800135:	74 14                	je     80014b <_main+0x113>
  800137:	83 ec 04             	sub    $0x4,%esp
  80013a:	68 38 3a 80 00       	push   $0x803a38
  80013f:	6a 31                	push   $0x31
  800141:	68 dc 39 80 00       	push   $0x8039dc
  800146:	e8 dc 08 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  80014b:	e8 e3 1f 00 00       	call   802133 <sys_pf_calculate_allocated_pages>
  800150:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800153:	3d 00 02 00 00       	cmp    $0x200,%eax
  800158:	74 14                	je     80016e <_main+0x136>
  80015a:	83 ec 04             	sub    $0x4,%esp
  80015d:	68 68 3a 80 00       	push   $0x803a68
  800162:	6a 33                	push   $0x33
  800164:	68 dc 39 80 00       	push   $0x8039dc
  800169:	e8 b9 08 00 00       	call   800a27 <_panic>

		//2 MB
		freeFrames = sys_calculate_free_frames() ;
  80016e:	e8 20 1f 00 00       	call   802093 <sys_calculate_free_frames>
  800173:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800176:	e8 b8 1f 00 00       	call   802133 <sys_pf_calculate_allocated_pages>
  80017b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  80017e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800181:	01 c0                	add    %eax,%eax
  800183:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800186:	83 ec 0c             	sub    $0xc,%esp
  800189:	50                   	push   %eax
  80018a:	e8 c5 1a 00 00       	call   801c54 <malloc>
  80018f:	83 c4 10             	add    $0x10,%esp
  800192:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  800195:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800198:	89 c2                	mov    %eax,%edx
  80019a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80019d:	01 c0                	add    %eax,%eax
  80019f:	05 00 00 00 80       	add    $0x80000000,%eax
  8001a4:	39 c2                	cmp    %eax,%edx
  8001a6:	74 14                	je     8001bc <_main+0x184>
  8001a8:	83 ec 04             	sub    $0x4,%esp
  8001ab:	68 38 3a 80 00       	push   $0x803a38
  8001b0:	6a 39                	push   $0x39
  8001b2:	68 dc 39 80 00       	push   $0x8039dc
  8001b7:	e8 6b 08 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  8001bc:	e8 72 1f 00 00       	call   802133 <sys_pf_calculate_allocated_pages>
  8001c1:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8001c4:	3d 00 02 00 00       	cmp    $0x200,%eax
  8001c9:	74 14                	je     8001df <_main+0x1a7>
  8001cb:	83 ec 04             	sub    $0x4,%esp
  8001ce:	68 68 3a 80 00       	push   $0x803a68
  8001d3:	6a 3b                	push   $0x3b
  8001d5:	68 dc 39 80 00       	push   $0x8039dc
  8001da:	e8 48 08 00 00       	call   800a27 <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  8001df:	e8 af 1e 00 00       	call   802093 <sys_calculate_free_frames>
  8001e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001e7:	e8 47 1f 00 00       	call   802133 <sys_pf_calculate_allocated_pages>
  8001ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  8001ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001f2:	01 c0                	add    %eax,%eax
  8001f4:	83 ec 0c             	sub    $0xc,%esp
  8001f7:	50                   	push   %eax
  8001f8:	e8 57 1a 00 00       	call   801c54 <malloc>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800203:	8b 45 98             	mov    -0x68(%ebp),%eax
  800206:	89 c2                	mov    %eax,%edx
  800208:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80020b:	c1 e0 02             	shl    $0x2,%eax
  80020e:	05 00 00 00 80       	add    $0x80000000,%eax
  800213:	39 c2                	cmp    %eax,%edx
  800215:	74 14                	je     80022b <_main+0x1f3>
  800217:	83 ec 04             	sub    $0x4,%esp
  80021a:	68 38 3a 80 00       	push   $0x803a38
  80021f:	6a 41                	push   $0x41
  800221:	68 dc 39 80 00       	push   $0x8039dc
  800226:	e8 fc 07 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1) panic("Wrong page file allocation: ");
  80022b:	e8 03 1f 00 00       	call   802133 <sys_pf_calculate_allocated_pages>
  800230:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800233:	83 f8 01             	cmp    $0x1,%eax
  800236:	74 14                	je     80024c <_main+0x214>
  800238:	83 ec 04             	sub    $0x4,%esp
  80023b:	68 68 3a 80 00       	push   $0x803a68
  800240:	6a 43                	push   $0x43
  800242:	68 dc 39 80 00       	push   $0x8039dc
  800247:	e8 db 07 00 00       	call   800a27 <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  80024c:	e8 42 1e 00 00       	call   802093 <sys_calculate_free_frames>
  800251:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800254:	e8 da 1e 00 00       	call   802133 <sys_pf_calculate_allocated_pages>
  800259:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  80025c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80025f:	01 c0                	add    %eax,%eax
  800261:	83 ec 0c             	sub    $0xc,%esp
  800264:	50                   	push   %eax
  800265:	e8 ea 19 00 00       	call   801c54 <malloc>
  80026a:	83 c4 10             	add    $0x10,%esp
  80026d:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 4*Mega + 4*kilo)) panic("Wrong start address for the allocated space... ");
  800270:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800273:	89 c2                	mov    %eax,%edx
  800275:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800278:	c1 e0 02             	shl    $0x2,%eax
  80027b:	89 c1                	mov    %eax,%ecx
  80027d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800280:	c1 e0 02             	shl    $0x2,%eax
  800283:	01 c8                	add    %ecx,%eax
  800285:	05 00 00 00 80       	add    $0x80000000,%eax
  80028a:	39 c2                	cmp    %eax,%edx
  80028c:	74 14                	je     8002a2 <_main+0x26a>
  80028e:	83 ec 04             	sub    $0x4,%esp
  800291:	68 38 3a 80 00       	push   $0x803a38
  800296:	6a 49                	push   $0x49
  800298:	68 dc 39 80 00       	push   $0x8039dc
  80029d:	e8 85 07 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1) panic("Wrong page file allocation: ");
  8002a2:	e8 8c 1e 00 00       	call   802133 <sys_pf_calculate_allocated_pages>
  8002a7:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8002aa:	83 f8 01             	cmp    $0x1,%eax
  8002ad:	74 14                	je     8002c3 <_main+0x28b>
  8002af:	83 ec 04             	sub    $0x4,%esp
  8002b2:	68 68 3a 80 00       	push   $0x803a68
  8002b7:	6a 4b                	push   $0x4b
  8002b9:	68 dc 39 80 00       	push   $0x8039dc
  8002be:	e8 64 07 00 00       	call   800a27 <_panic>

		//4 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  8002c3:	e8 cb 1d 00 00       	call   802093 <sys_calculate_free_frames>
  8002c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002cb:	e8 63 1e 00 00       	call   802133 <sys_pf_calculate_allocated_pages>
  8002d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[2]);
  8002d3:	8b 45 98             	mov    -0x68(%ebp),%eax
  8002d6:	83 ec 0c             	sub    $0xc,%esp
  8002d9:	50                   	push   %eax
  8002da:	e8 0c 1a 00 00       	call   801ceb <free>
  8002df:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1) panic("Wrong free: ");
		if( (usedDiskPages-sys_pf_calculate_allocated_pages()) !=  1) panic("Wrong page file free: ");
  8002e2:	e8 4c 1e 00 00       	call   802133 <sys_pf_calculate_allocated_pages>
  8002e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002ea:	29 c2                	sub    %eax,%edx
  8002ec:	89 d0                	mov    %edx,%eax
  8002ee:	83 f8 01             	cmp    $0x1,%eax
  8002f1:	74 14                	je     800307 <_main+0x2cf>
  8002f3:	83 ec 04             	sub    $0x4,%esp
  8002f6:	68 85 3a 80 00       	push   $0x803a85
  8002fb:	6a 52                	push   $0x52
  8002fd:	68 dc 39 80 00       	push   $0x8039dc
  800302:	e8 20 07 00 00       	call   800a27 <_panic>

		//7 KB
		freeFrames = sys_calculate_free_frames() ;
  800307:	e8 87 1d 00 00       	call   802093 <sys_calculate_free_frames>
  80030c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80030f:	e8 1f 1e 00 00       	call   802133 <sys_pf_calculate_allocated_pages>
  800314:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  800317:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80031a:	89 d0                	mov    %edx,%eax
  80031c:	01 c0                	add    %eax,%eax
  80031e:	01 d0                	add    %edx,%eax
  800320:	01 c0                	add    %eax,%eax
  800322:	01 d0                	add    %edx,%eax
  800324:	83 ec 0c             	sub    $0xc,%esp
  800327:	50                   	push   %eax
  800328:	e8 27 19 00 00       	call   801c54 <malloc>
  80032d:	83 c4 10             	add    $0x10,%esp
  800330:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] != (USER_HEAP_START + 4*Mega + 8*kilo)) panic("Wrong start address for the allocated space... ");
  800333:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800336:	89 c2                	mov    %eax,%edx
  800338:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80033b:	c1 e0 02             	shl    $0x2,%eax
  80033e:	89 c1                	mov    %eax,%ecx
  800340:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800343:	c1 e0 03             	shl    $0x3,%eax
  800346:	01 c8                	add    %ecx,%eax
  800348:	05 00 00 00 80       	add    $0x80000000,%eax
  80034d:	39 c2                	cmp    %eax,%edx
  80034f:	74 14                	je     800365 <_main+0x32d>
  800351:	83 ec 04             	sub    $0x4,%esp
  800354:	68 38 3a 80 00       	push   $0x803a38
  800359:	6a 58                	push   $0x58
  80035b:	68 dc 39 80 00       	push   $0x8039dc
  800360:	e8 c2 06 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2) panic("Wrong page file allocation: ");
  800365:	e8 c9 1d 00 00       	call   802133 <sys_pf_calculate_allocated_pages>
  80036a:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80036d:	83 f8 02             	cmp    $0x2,%eax
  800370:	74 14                	je     800386 <_main+0x34e>
  800372:	83 ec 04             	sub    $0x4,%esp
  800375:	68 68 3a 80 00       	push   $0x803a68
  80037a:	6a 5a                	push   $0x5a
  80037c:	68 dc 39 80 00       	push   $0x8039dc
  800381:	e8 a1 06 00 00       	call   800a27 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800386:	e8 08 1d 00 00       	call   802093 <sys_calculate_free_frames>
  80038b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80038e:	e8 a0 1d 00 00       	call   802133 <sys_pf_calculate_allocated_pages>
  800393:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[0]);
  800396:	8b 45 90             	mov    -0x70(%ebp),%eax
  800399:	83 ec 0c             	sub    $0xc,%esp
  80039c:	50                   	push   %eax
  80039d:	e8 49 19 00 00       	call   801ceb <free>
  8003a2:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  512) panic("Wrong page file free: ");
  8003a5:	e8 89 1d 00 00       	call   802133 <sys_pf_calculate_allocated_pages>
  8003aa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003ad:	29 c2                	sub    %eax,%edx
  8003af:	89 d0                	mov    %edx,%eax
  8003b1:	3d 00 02 00 00       	cmp    $0x200,%eax
  8003b6:	74 14                	je     8003cc <_main+0x394>
  8003b8:	83 ec 04             	sub    $0x4,%esp
  8003bb:	68 85 3a 80 00       	push   $0x803a85
  8003c0:	6a 61                	push   $0x61
  8003c2:	68 dc 39 80 00       	push   $0x8039dc
  8003c7:	e8 5b 06 00 00       	call   800a27 <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003cc:	e8 c2 1c 00 00       	call   802093 <sys_calculate_free_frames>
  8003d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003d4:	e8 5a 1d 00 00       	call   802133 <sys_pf_calculate_allocated_pages>
  8003d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8003dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003df:	89 c2                	mov    %eax,%edx
  8003e1:	01 d2                	add    %edx,%edx
  8003e3:	01 d0                	add    %edx,%eax
  8003e5:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003e8:	83 ec 0c             	sub    $0xc,%esp
  8003eb:	50                   	push   %eax
  8003ec:	e8 63 18 00 00       	call   801c54 <malloc>
  8003f1:	83 c4 10             	add    $0x10,%esp
  8003f4:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] != (USER_HEAP_START + 4*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  8003f7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003fa:	89 c2                	mov    %eax,%edx
  8003fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003ff:	c1 e0 02             	shl    $0x2,%eax
  800402:	89 c1                	mov    %eax,%ecx
  800404:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800407:	c1 e0 04             	shl    $0x4,%eax
  80040a:	01 c8                	add    %ecx,%eax
  80040c:	05 00 00 00 80       	add    $0x80000000,%eax
  800411:	39 c2                	cmp    %eax,%edx
  800413:	74 14                	je     800429 <_main+0x3f1>
  800415:	83 ec 04             	sub    $0x4,%esp
  800418:	68 38 3a 80 00       	push   $0x803a38
  80041d:	6a 67                	push   $0x67
  80041f:	68 dc 39 80 00       	push   $0x8039dc
  800424:	e8 fe 05 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*Mega/4096) panic("Wrong page file allocation: ");
  800429:	e8 05 1d 00 00       	call   802133 <sys_pf_calculate_allocated_pages>
  80042e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800431:	89 c2                	mov    %eax,%edx
  800433:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800436:	89 c1                	mov    %eax,%ecx
  800438:	01 c9                	add    %ecx,%ecx
  80043a:	01 c8                	add    %ecx,%eax
  80043c:	85 c0                	test   %eax,%eax
  80043e:	79 05                	jns    800445 <_main+0x40d>
  800440:	05 ff 0f 00 00       	add    $0xfff,%eax
  800445:	c1 f8 0c             	sar    $0xc,%eax
  800448:	39 c2                	cmp    %eax,%edx
  80044a:	74 14                	je     800460 <_main+0x428>
  80044c:	83 ec 04             	sub    $0x4,%esp
  80044f:	68 68 3a 80 00       	push   $0x803a68
  800454:	6a 69                	push   $0x69
  800456:	68 dc 39 80 00       	push   $0x8039dc
  80045b:	e8 c7 05 00 00       	call   800a27 <_panic>

		//2 MB + 6 KB
		freeFrames = sys_calculate_free_frames() ;
  800460:	e8 2e 1c 00 00       	call   802093 <sys_calculate_free_frames>
  800465:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800468:	e8 c6 1c 00 00       	call   802133 <sys_pf_calculate_allocated_pages>
  80046d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(2*Mega + 6*kilo);
  800470:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800473:	89 c2                	mov    %eax,%edx
  800475:	01 d2                	add    %edx,%edx
  800477:	01 c2                	add    %eax,%edx
  800479:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80047c:	01 d0                	add    %edx,%eax
  80047e:	01 c0                	add    %eax,%eax
  800480:	83 ec 0c             	sub    $0xc,%esp
  800483:	50                   	push   %eax
  800484:	e8 cb 17 00 00       	call   801c54 <malloc>
  800489:	83 c4 10             	add    $0x10,%esp
  80048c:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] != (USER_HEAP_START + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  80048f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800492:	89 c1                	mov    %eax,%ecx
  800494:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800497:	89 d0                	mov    %edx,%eax
  800499:	01 c0                	add    %eax,%eax
  80049b:	01 d0                	add    %edx,%eax
  80049d:	01 c0                	add    %eax,%eax
  80049f:	01 d0                	add    %edx,%eax
  8004a1:	89 c2                	mov    %eax,%edx
  8004a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004a6:	c1 e0 04             	shl    $0x4,%eax
  8004a9:	01 d0                	add    %edx,%eax
  8004ab:	05 00 00 00 80       	add    $0x80000000,%eax
  8004b0:	39 c1                	cmp    %eax,%ecx
  8004b2:	74 14                	je     8004c8 <_main+0x490>
  8004b4:	83 ec 04             	sub    $0x4,%esp
  8004b7:	68 38 3a 80 00       	push   $0x803a38
  8004bc:	6a 6f                	push   $0x6f
  8004be:	68 dc 39 80 00       	push   $0x8039dc
  8004c3:	e8 5f 05 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 514+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  514) panic("Wrong page file allocation: ");
  8004c8:	e8 66 1c 00 00       	call   802133 <sys_pf_calculate_allocated_pages>
  8004cd:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8004d0:	3d 02 02 00 00       	cmp    $0x202,%eax
  8004d5:	74 14                	je     8004eb <_main+0x4b3>
  8004d7:	83 ec 04             	sub    $0x4,%esp
  8004da:	68 68 3a 80 00       	push   $0x803a68
  8004df:	6a 71                	push   $0x71
  8004e1:	68 dc 39 80 00       	push   $0x8039dc
  8004e6:	e8 3c 05 00 00       	call   800a27 <_panic>

		//5 MB
		freeFrames = sys_calculate_free_frames() ;
  8004eb:	e8 a3 1b 00 00       	call   802093 <sys_calculate_free_frames>
  8004f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004f3:	e8 3b 1c 00 00       	call   802133 <sys_pf_calculate_allocated_pages>
  8004f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = malloc(5*Mega-kilo);
  8004fb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8004fe:	89 d0                	mov    %edx,%eax
  800500:	c1 e0 02             	shl    $0x2,%eax
  800503:	01 d0                	add    %edx,%eax
  800505:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800508:	83 ec 0c             	sub    $0xc,%esp
  80050b:	50                   	push   %eax
  80050c:	e8 43 17 00 00       	call   801c54 <malloc>
  800511:	83 c4 10             	add    $0x10,%esp
  800514:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 9*Mega + 24*kilo)) panic("Wrong start address for the allocated space... ");
  800517:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80051a:	89 c1                	mov    %eax,%ecx
  80051c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80051f:	89 d0                	mov    %edx,%eax
  800521:	c1 e0 03             	shl    $0x3,%eax
  800524:	01 d0                	add    %edx,%eax
  800526:	89 c3                	mov    %eax,%ebx
  800528:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80052b:	89 d0                	mov    %edx,%eax
  80052d:	01 c0                	add    %eax,%eax
  80052f:	01 d0                	add    %edx,%eax
  800531:	c1 e0 03             	shl    $0x3,%eax
  800534:	01 d8                	add    %ebx,%eax
  800536:	05 00 00 00 80       	add    $0x80000000,%eax
  80053b:	39 c1                	cmp    %eax,%ecx
  80053d:	74 14                	je     800553 <_main+0x51b>
  80053f:	83 ec 04             	sub    $0x4,%esp
  800542:	68 38 3a 80 00       	push   $0x803a38
  800547:	6a 77                	push   $0x77
  800549:	68 dc 39 80 00       	push   $0x8039dc
  80054e:	e8 d4 04 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 5*Mega/4096 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/4096) panic("Wrong page file allocation: ");
  800553:	e8 db 1b 00 00       	call   802133 <sys_pf_calculate_allocated_pages>
  800558:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80055b:	89 c1                	mov    %eax,%ecx
  80055d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800560:	89 d0                	mov    %edx,%eax
  800562:	c1 e0 02             	shl    $0x2,%eax
  800565:	01 d0                	add    %edx,%eax
  800567:	85 c0                	test   %eax,%eax
  800569:	79 05                	jns    800570 <_main+0x538>
  80056b:	05 ff 0f 00 00       	add    $0xfff,%eax
  800570:	c1 f8 0c             	sar    $0xc,%eax
  800573:	39 c1                	cmp    %eax,%ecx
  800575:	74 14                	je     80058b <_main+0x553>
  800577:	83 ec 04             	sub    $0x4,%esp
  80057a:	68 68 3a 80 00       	push   $0x803a68
  80057f:	6a 79                	push   $0x79
  800581:	68 dc 39 80 00       	push   $0x8039dc
  800586:	e8 9c 04 00 00       	call   800a27 <_panic>

		//2 MB + 8 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  80058b:	e8 03 1b 00 00       	call   802093 <sys_calculate_free_frames>
  800590:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800593:	e8 9b 1b 00 00       	call   802133 <sys_pf_calculate_allocated_pages>
  800598:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[6]);
  80059b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80059e:	83 ec 0c             	sub    $0xc,%esp
  8005a1:	50                   	push   %eax
  8005a2:	e8 44 17 00 00       	call   801ceb <free>
  8005a7:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 514) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  514) panic("Wrong page file free: ");
  8005aa:	e8 84 1b 00 00       	call   802133 <sys_pf_calculate_allocated_pages>
  8005af:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005b2:	29 c2                	sub    %eax,%edx
  8005b4:	89 d0                	mov    %edx,%eax
  8005b6:	3d 02 02 00 00       	cmp    $0x202,%eax
  8005bb:	74 17                	je     8005d4 <_main+0x59c>
  8005bd:	83 ec 04             	sub    $0x4,%esp
  8005c0:	68 85 3a 80 00       	push   $0x803a85
  8005c5:	68 80 00 00 00       	push   $0x80
  8005ca:	68 dc 39 80 00       	push   $0x8039dc
  8005cf:	e8 53 04 00 00       	call   800a27 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005d4:	e8 ba 1a 00 00       	call   802093 <sys_calculate_free_frames>
  8005d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005dc:	e8 52 1b 00 00       	call   802133 <sys_pf_calculate_allocated_pages>
  8005e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  8005e4:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8005e7:	83 ec 0c             	sub    $0xc,%esp
  8005ea:	50                   	push   %eax
  8005eb:	e8 fb 16 00 00       	call   801ceb <free>
  8005f0:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  512) panic("Wrong page file free: ");
  8005f3:	e8 3b 1b 00 00       	call   802133 <sys_pf_calculate_allocated_pages>
  8005f8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005fb:	29 c2                	sub    %eax,%edx
  8005fd:	89 d0                	mov    %edx,%eax
  8005ff:	3d 00 02 00 00       	cmp    $0x200,%eax
  800604:	74 17                	je     80061d <_main+0x5e5>
  800606:	83 ec 04             	sub    $0x4,%esp
  800609:	68 85 3a 80 00       	push   $0x803a85
  80060e:	68 87 00 00 00       	push   $0x87
  800613:	68 dc 39 80 00       	push   $0x8039dc
  800618:	e8 0a 04 00 00       	call   800a27 <_panic>

		//2 MB [BEST FIT Case]
		freeFrames = sys_calculate_free_frames() ;
  80061d:	e8 71 1a 00 00       	call   802093 <sys_calculate_free_frames>
  800622:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800625:	e8 09 1b 00 00       	call   802133 <sys_pf_calculate_allocated_pages>
  80062a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(2*Mega-kilo);
  80062d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800630:	01 c0                	add    %eax,%eax
  800632:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800635:	83 ec 0c             	sub    $0xc,%esp
  800638:	50                   	push   %eax
  800639:	e8 16 16 00 00       	call   801c54 <malloc>
  80063e:	83 c4 10             	add    $0x10,%esp
  800641:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[8] !=  (USER_HEAP_START + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  800644:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800647:	89 c1                	mov    %eax,%ecx
  800649:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80064c:	89 d0                	mov    %edx,%eax
  80064e:	01 c0                	add    %eax,%eax
  800650:	01 d0                	add    %edx,%eax
  800652:	01 c0                	add    %eax,%eax
  800654:	01 d0                	add    %edx,%eax
  800656:	89 c2                	mov    %eax,%edx
  800658:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80065b:	c1 e0 04             	shl    $0x4,%eax
  80065e:	01 d0                	add    %edx,%eax
  800660:	05 00 00 00 80       	add    $0x80000000,%eax
  800665:	39 c1                	cmp    %eax,%ecx
  800667:	74 17                	je     800680 <_main+0x648>
  800669:	83 ec 04             	sub    $0x4,%esp
  80066c:	68 38 3a 80 00       	push   $0x803a38
  800671:	68 8d 00 00 00       	push   $0x8d
  800676:	68 dc 39 80 00       	push   $0x8039dc
  80067b:	e8 a7 03 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  800680:	e8 ae 1a 00 00       	call   802133 <sys_pf_calculate_allocated_pages>
  800685:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800688:	3d 00 02 00 00       	cmp    $0x200,%eax
  80068d:	74 17                	je     8006a6 <_main+0x66e>
  80068f:	83 ec 04             	sub    $0x4,%esp
  800692:	68 68 3a 80 00       	push   $0x803a68
  800697:	68 8f 00 00 00       	push   $0x8f
  80069c:	68 dc 39 80 00       	push   $0x8039dc
  8006a1:	e8 81 03 00 00       	call   800a27 <_panic>

		//6 KB [BEST FIT Case]
		freeFrames = sys_calculate_free_frames() ;
  8006a6:	e8 e8 19 00 00       	call   802093 <sys_calculate_free_frames>
  8006ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8006ae:	e8 80 1a 00 00       	call   802133 <sys_pf_calculate_allocated_pages>
  8006b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[9] = malloc(6*kilo);
  8006b6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006b9:	89 d0                	mov    %edx,%eax
  8006bb:	01 c0                	add    %eax,%eax
  8006bd:	01 d0                	add    %edx,%eax
  8006bf:	01 c0                	add    %eax,%eax
  8006c1:	83 ec 0c             	sub    $0xc,%esp
  8006c4:	50                   	push   %eax
  8006c5:	e8 8a 15 00 00       	call   801c54 <malloc>
  8006ca:	83 c4 10             	add    $0x10,%esp
  8006cd:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 9*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  8006d0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8006d3:	89 c1                	mov    %eax,%ecx
  8006d5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8006d8:	89 d0                	mov    %edx,%eax
  8006da:	c1 e0 03             	shl    $0x3,%eax
  8006dd:	01 d0                	add    %edx,%eax
  8006df:	89 c2                	mov    %eax,%edx
  8006e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006e4:	c1 e0 04             	shl    $0x4,%eax
  8006e7:	01 d0                	add    %edx,%eax
  8006e9:	05 00 00 00 80       	add    $0x80000000,%eax
  8006ee:	39 c1                	cmp    %eax,%ecx
  8006f0:	74 17                	je     800709 <_main+0x6d1>
  8006f2:	83 ec 04             	sub    $0x4,%esp
  8006f5:	68 38 3a 80 00       	push   $0x803a38
  8006fa:	68 95 00 00 00       	push   $0x95
  8006ff:	68 dc 39 80 00       	push   $0x8039dc
  800704:	e8 1e 03 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2) panic("Wrong page file allocation: ");
  800709:	e8 25 1a 00 00       	call   802133 <sys_pf_calculate_allocated_pages>
  80070e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800711:	83 f8 02             	cmp    $0x2,%eax
  800714:	74 17                	je     80072d <_main+0x6f5>
  800716:	83 ec 04             	sub    $0x4,%esp
  800719:	68 68 3a 80 00       	push   $0x803a68
  80071e:	68 97 00 00 00       	push   $0x97
  800723:	68 dc 39 80 00       	push   $0x8039dc
  800728:	e8 fa 02 00 00       	call   800a27 <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80072d:	e8 61 19 00 00       	call   802093 <sys_calculate_free_frames>
  800732:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800735:	e8 f9 19 00 00       	call   802133 <sys_pf_calculate_allocated_pages>
  80073a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[5]);
  80073d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800740:	83 ec 0c             	sub    $0xc,%esp
  800743:	50                   	push   %eax
  800744:	e8 a2 15 00 00       	call   801ceb <free>
  800749:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  768) panic("Wrong page file free: ");
  80074c:	e8 e2 19 00 00       	call   802133 <sys_pf_calculate_allocated_pages>
  800751:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800754:	29 c2                	sub    %eax,%edx
  800756:	89 d0                	mov    %edx,%eax
  800758:	3d 00 03 00 00       	cmp    $0x300,%eax
  80075d:	74 17                	je     800776 <_main+0x73e>
  80075f:	83 ec 04             	sub    $0x4,%esp
  800762:	68 85 3a 80 00       	push   $0x803a85
  800767:	68 9e 00 00 00       	push   $0x9e
  80076c:	68 dc 39 80 00       	push   $0x8039dc
  800771:	e8 b1 02 00 00       	call   800a27 <_panic>

		//3 MB [BEST FIT Case]
		freeFrames = sys_calculate_free_frames() ;
  800776:	e8 18 19 00 00       	call   802093 <sys_calculate_free_frames>
  80077b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80077e:	e8 b0 19 00 00       	call   802133 <sys_pf_calculate_allocated_pages>
  800783:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[10] = malloc(3*Mega-kilo);
  800786:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800789:	89 c2                	mov    %eax,%edx
  80078b:	01 d2                	add    %edx,%edx
  80078d:	01 d0                	add    %edx,%eax
  80078f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800792:	83 ec 0c             	sub    $0xc,%esp
  800795:	50                   	push   %eax
  800796:	e8 b9 14 00 00       	call   801c54 <malloc>
  80079b:	83 c4 10             	add    $0x10,%esp
  80079e:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START + 4*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  8007a1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8007a4:	89 c2                	mov    %eax,%edx
  8007a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007a9:	c1 e0 02             	shl    $0x2,%eax
  8007ac:	89 c1                	mov    %eax,%ecx
  8007ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007b1:	c1 e0 04             	shl    $0x4,%eax
  8007b4:	01 c8                	add    %ecx,%eax
  8007b6:	05 00 00 00 80       	add    $0x80000000,%eax
  8007bb:	39 c2                	cmp    %eax,%edx
  8007bd:	74 17                	je     8007d6 <_main+0x79e>
  8007bf:	83 ec 04             	sub    $0x4,%esp
  8007c2:	68 38 3a 80 00       	push   $0x803a38
  8007c7:	68 a4 00 00 00       	push   $0xa4
  8007cc:	68 dc 39 80 00       	push   $0x8039dc
  8007d1:	e8 51 02 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*Mega/4096) panic("Wrong page file allocation: ");
  8007d6:	e8 58 19 00 00       	call   802133 <sys_pf_calculate_allocated_pages>
  8007db:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8007de:	89 c2                	mov    %eax,%edx
  8007e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007e3:	89 c1                	mov    %eax,%ecx
  8007e5:	01 c9                	add    %ecx,%ecx
  8007e7:	01 c8                	add    %ecx,%eax
  8007e9:	85 c0                	test   %eax,%eax
  8007eb:	79 05                	jns    8007f2 <_main+0x7ba>
  8007ed:	05 ff 0f 00 00       	add    $0xfff,%eax
  8007f2:	c1 f8 0c             	sar    $0xc,%eax
  8007f5:	39 c2                	cmp    %eax,%edx
  8007f7:	74 17                	je     800810 <_main+0x7d8>
  8007f9:	83 ec 04             	sub    $0x4,%esp
  8007fc:	68 68 3a 80 00       	push   $0x803a68
  800801:	68 a6 00 00 00       	push   $0xa6
  800806:	68 dc 39 80 00       	push   $0x8039dc
  80080b:	e8 17 02 00 00       	call   800a27 <_panic>

		//4 MB
		freeFrames = sys_calculate_free_frames() ;
  800810:	e8 7e 18 00 00       	call   802093 <sys_calculate_free_frames>
  800815:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800818:	e8 16 19 00 00       	call   802133 <sys_pf_calculate_allocated_pages>
  80081d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[11] = malloc(4*Mega-kilo);
  800820:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800823:	c1 e0 02             	shl    $0x2,%eax
  800826:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800829:	83 ec 0c             	sub    $0xc,%esp
  80082c:	50                   	push   %eax
  80082d:	e8 22 14 00 00       	call   801c54 <malloc>
  800832:	83 c4 10             	add    $0x10,%esp
  800835:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if ((uint32) ptr_allocations[11] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  800838:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80083b:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800840:	74 17                	je     800859 <_main+0x821>
  800842:	83 ec 04             	sub    $0x4,%esp
  800845:	68 38 3a 80 00       	push   $0x803a38
  80084a:	68 ac 00 00 00       	push   $0xac
  80084f:	68 dc 39 80 00       	push   $0x8039dc
  800854:	e8 ce 01 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 4*Mega/4096) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/4096) panic("Wrong page file allocation: ");
  800859:	e8 d5 18 00 00       	call   802133 <sys_pf_calculate_allocated_pages>
  80085e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800861:	89 c2                	mov    %eax,%edx
  800863:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800866:	c1 e0 02             	shl    $0x2,%eax
  800869:	85 c0                	test   %eax,%eax
  80086b:	79 05                	jns    800872 <_main+0x83a>
  80086d:	05 ff 0f 00 00       	add    $0xfff,%eax
  800872:	c1 f8 0c             	sar    $0xc,%eax
  800875:	39 c2                	cmp    %eax,%edx
  800877:	74 17                	je     800890 <_main+0x858>
  800879:	83 ec 04             	sub    $0x4,%esp
  80087c:	68 68 3a 80 00       	push   $0x803a68
  800881:	68 ae 00 00 00       	push   $0xae
  800886:	68 dc 39 80 00       	push   $0x8039dc
  80088b:	e8 97 01 00 00       	call   800a27 <_panic>
	//	b) Attempt to allocate large segment with no suitable fragment to fit on
	{
		//Large Allocation
		//int freeFrames = sys_calculate_free_frames() ;
		//usedDiskPages = sys_pf_calculate_allocated_pages();
		ptr_allocations[12] = malloc((USER_HEAP_MAX - USER_HEAP_START - 14*Mega));
  800890:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800893:	89 d0                	mov    %edx,%eax
  800895:	01 c0                	add    %eax,%eax
  800897:	01 d0                	add    %edx,%eax
  800899:	01 c0                	add    %eax,%eax
  80089b:	01 d0                	add    %edx,%eax
  80089d:	01 c0                	add    %eax,%eax
  80089f:	f7 d8                	neg    %eax
  8008a1:	05 00 00 00 20       	add    $0x20000000,%eax
  8008a6:	83 ec 0c             	sub    $0xc,%esp
  8008a9:	50                   	push   %eax
  8008aa:	e8 a5 13 00 00       	call   801c54 <malloc>
  8008af:	83 c4 10             	add    $0x10,%esp
  8008b2:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if (ptr_allocations[12] != NULL) panic("Malloc: Attempt to allocate large segment with no suitable fragment to fit on, should return NULL");
  8008b5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8008b8:	85 c0                	test   %eax,%eax
  8008ba:	74 17                	je     8008d3 <_main+0x89b>
  8008bc:	83 ec 04             	sub    $0x4,%esp
  8008bf:	68 9c 3a 80 00       	push   $0x803a9c
  8008c4:	68 b7 00 00 00       	push   $0xb7
  8008c9:	68 dc 39 80 00       	push   $0x8039dc
  8008ce:	e8 54 01 00 00       	call   800a27 <_panic>

		cprintf("Congratulations!! test BEST FIT allocation (2) completed successfully.\n");
  8008d3:	83 ec 0c             	sub    $0xc,%esp
  8008d6:	68 00 3b 80 00       	push   $0x803b00
  8008db:	e8 fb 03 00 00       	call   800cdb <cprintf>
  8008e0:	83 c4 10             	add    $0x10,%esp

		return;
  8008e3:	90                   	nop
	}
}
  8008e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008e7:	5b                   	pop    %ebx
  8008e8:	5f                   	pop    %edi
  8008e9:	5d                   	pop    %ebp
  8008ea:	c3                   	ret    

008008eb <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8008eb:	55                   	push   %ebp
  8008ec:	89 e5                	mov    %esp,%ebp
  8008ee:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8008f1:	e8 7d 1a 00 00       	call   802373 <sys_getenvindex>
  8008f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8008f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008fc:	89 d0                	mov    %edx,%eax
  8008fe:	c1 e0 03             	shl    $0x3,%eax
  800901:	01 d0                	add    %edx,%eax
  800903:	01 c0                	add    %eax,%eax
  800905:	01 d0                	add    %edx,%eax
  800907:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80090e:	01 d0                	add    %edx,%eax
  800910:	c1 e0 04             	shl    $0x4,%eax
  800913:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800918:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80091d:	a1 20 50 80 00       	mov    0x805020,%eax
  800922:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800928:	84 c0                	test   %al,%al
  80092a:	74 0f                	je     80093b <libmain+0x50>
		binaryname = myEnv->prog_name;
  80092c:	a1 20 50 80 00       	mov    0x805020,%eax
  800931:	05 5c 05 00 00       	add    $0x55c,%eax
  800936:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80093b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80093f:	7e 0a                	jle    80094b <libmain+0x60>
		binaryname = argv[0];
  800941:	8b 45 0c             	mov    0xc(%ebp),%eax
  800944:	8b 00                	mov    (%eax),%eax
  800946:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  80094b:	83 ec 08             	sub    $0x8,%esp
  80094e:	ff 75 0c             	pushl  0xc(%ebp)
  800951:	ff 75 08             	pushl  0x8(%ebp)
  800954:	e8 df f6 ff ff       	call   800038 <_main>
  800959:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80095c:	e8 1f 18 00 00       	call   802180 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800961:	83 ec 0c             	sub    $0xc,%esp
  800964:	68 60 3b 80 00       	push   $0x803b60
  800969:	e8 6d 03 00 00       	call   800cdb <cprintf>
  80096e:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800971:	a1 20 50 80 00       	mov    0x805020,%eax
  800976:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80097c:	a1 20 50 80 00       	mov    0x805020,%eax
  800981:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800987:	83 ec 04             	sub    $0x4,%esp
  80098a:	52                   	push   %edx
  80098b:	50                   	push   %eax
  80098c:	68 88 3b 80 00       	push   $0x803b88
  800991:	e8 45 03 00 00       	call   800cdb <cprintf>
  800996:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800999:	a1 20 50 80 00       	mov    0x805020,%eax
  80099e:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8009a4:	a1 20 50 80 00       	mov    0x805020,%eax
  8009a9:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8009af:	a1 20 50 80 00       	mov    0x805020,%eax
  8009b4:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8009ba:	51                   	push   %ecx
  8009bb:	52                   	push   %edx
  8009bc:	50                   	push   %eax
  8009bd:	68 b0 3b 80 00       	push   $0x803bb0
  8009c2:	e8 14 03 00 00       	call   800cdb <cprintf>
  8009c7:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8009ca:	a1 20 50 80 00       	mov    0x805020,%eax
  8009cf:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8009d5:	83 ec 08             	sub    $0x8,%esp
  8009d8:	50                   	push   %eax
  8009d9:	68 08 3c 80 00       	push   $0x803c08
  8009de:	e8 f8 02 00 00       	call   800cdb <cprintf>
  8009e3:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8009e6:	83 ec 0c             	sub    $0xc,%esp
  8009e9:	68 60 3b 80 00       	push   $0x803b60
  8009ee:	e8 e8 02 00 00       	call   800cdb <cprintf>
  8009f3:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8009f6:	e8 9f 17 00 00       	call   80219a <sys_enable_interrupt>

	// exit gracefully
	exit();
  8009fb:	e8 19 00 00 00       	call   800a19 <exit>
}
  800a00:	90                   	nop
  800a01:	c9                   	leave  
  800a02:	c3                   	ret    

00800a03 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800a03:	55                   	push   %ebp
  800a04:	89 e5                	mov    %esp,%ebp
  800a06:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800a09:	83 ec 0c             	sub    $0xc,%esp
  800a0c:	6a 00                	push   $0x0
  800a0e:	e8 2c 19 00 00       	call   80233f <sys_destroy_env>
  800a13:	83 c4 10             	add    $0x10,%esp
}
  800a16:	90                   	nop
  800a17:	c9                   	leave  
  800a18:	c3                   	ret    

00800a19 <exit>:

void
exit(void)
{
  800a19:	55                   	push   %ebp
  800a1a:	89 e5                	mov    %esp,%ebp
  800a1c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800a1f:	e8 81 19 00 00       	call   8023a5 <sys_exit_env>
}
  800a24:	90                   	nop
  800a25:	c9                   	leave  
  800a26:	c3                   	ret    

00800a27 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800a27:	55                   	push   %ebp
  800a28:	89 e5                	mov    %esp,%ebp
  800a2a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800a2d:	8d 45 10             	lea    0x10(%ebp),%eax
  800a30:	83 c0 04             	add    $0x4,%eax
  800a33:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800a36:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800a3b:	85 c0                	test   %eax,%eax
  800a3d:	74 16                	je     800a55 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800a3f:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800a44:	83 ec 08             	sub    $0x8,%esp
  800a47:	50                   	push   %eax
  800a48:	68 1c 3c 80 00       	push   $0x803c1c
  800a4d:	e8 89 02 00 00       	call   800cdb <cprintf>
  800a52:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800a55:	a1 00 50 80 00       	mov    0x805000,%eax
  800a5a:	ff 75 0c             	pushl  0xc(%ebp)
  800a5d:	ff 75 08             	pushl  0x8(%ebp)
  800a60:	50                   	push   %eax
  800a61:	68 21 3c 80 00       	push   $0x803c21
  800a66:	e8 70 02 00 00       	call   800cdb <cprintf>
  800a6b:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800a6e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a71:	83 ec 08             	sub    $0x8,%esp
  800a74:	ff 75 f4             	pushl  -0xc(%ebp)
  800a77:	50                   	push   %eax
  800a78:	e8 f3 01 00 00       	call   800c70 <vcprintf>
  800a7d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800a80:	83 ec 08             	sub    $0x8,%esp
  800a83:	6a 00                	push   $0x0
  800a85:	68 3d 3c 80 00       	push   $0x803c3d
  800a8a:	e8 e1 01 00 00       	call   800c70 <vcprintf>
  800a8f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800a92:	e8 82 ff ff ff       	call   800a19 <exit>

	// should not return here
	while (1) ;
  800a97:	eb fe                	jmp    800a97 <_panic+0x70>

00800a99 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800a99:	55                   	push   %ebp
  800a9a:	89 e5                	mov    %esp,%ebp
  800a9c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800a9f:	a1 20 50 80 00       	mov    0x805020,%eax
  800aa4:	8b 50 74             	mov    0x74(%eax),%edx
  800aa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aaa:	39 c2                	cmp    %eax,%edx
  800aac:	74 14                	je     800ac2 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800aae:	83 ec 04             	sub    $0x4,%esp
  800ab1:	68 40 3c 80 00       	push   $0x803c40
  800ab6:	6a 26                	push   $0x26
  800ab8:	68 8c 3c 80 00       	push   $0x803c8c
  800abd:	e8 65 ff ff ff       	call   800a27 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800ac2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800ac9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ad0:	e9 c2 00 00 00       	jmp    800b97 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800ad5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ad8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800adf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae2:	01 d0                	add    %edx,%eax
  800ae4:	8b 00                	mov    (%eax),%eax
  800ae6:	85 c0                	test   %eax,%eax
  800ae8:	75 08                	jne    800af2 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800aea:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800aed:	e9 a2 00 00 00       	jmp    800b94 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800af2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800af9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800b00:	eb 69                	jmp    800b6b <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800b02:	a1 20 50 80 00       	mov    0x805020,%eax
  800b07:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b0d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b10:	89 d0                	mov    %edx,%eax
  800b12:	01 c0                	add    %eax,%eax
  800b14:	01 d0                	add    %edx,%eax
  800b16:	c1 e0 03             	shl    $0x3,%eax
  800b19:	01 c8                	add    %ecx,%eax
  800b1b:	8a 40 04             	mov    0x4(%eax),%al
  800b1e:	84 c0                	test   %al,%al
  800b20:	75 46                	jne    800b68 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800b22:	a1 20 50 80 00       	mov    0x805020,%eax
  800b27:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b2d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b30:	89 d0                	mov    %edx,%eax
  800b32:	01 c0                	add    %eax,%eax
  800b34:	01 d0                	add    %edx,%eax
  800b36:	c1 e0 03             	shl    $0x3,%eax
  800b39:	01 c8                	add    %ecx,%eax
  800b3b:	8b 00                	mov    (%eax),%eax
  800b3d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800b40:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800b43:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b48:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800b4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b4d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800b54:	8b 45 08             	mov    0x8(%ebp),%eax
  800b57:	01 c8                	add    %ecx,%eax
  800b59:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800b5b:	39 c2                	cmp    %eax,%edx
  800b5d:	75 09                	jne    800b68 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800b5f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800b66:	eb 12                	jmp    800b7a <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b68:	ff 45 e8             	incl   -0x18(%ebp)
  800b6b:	a1 20 50 80 00       	mov    0x805020,%eax
  800b70:	8b 50 74             	mov    0x74(%eax),%edx
  800b73:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b76:	39 c2                	cmp    %eax,%edx
  800b78:	77 88                	ja     800b02 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800b7a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800b7e:	75 14                	jne    800b94 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800b80:	83 ec 04             	sub    $0x4,%esp
  800b83:	68 98 3c 80 00       	push   $0x803c98
  800b88:	6a 3a                	push   $0x3a
  800b8a:	68 8c 3c 80 00       	push   $0x803c8c
  800b8f:	e8 93 fe ff ff       	call   800a27 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800b94:	ff 45 f0             	incl   -0x10(%ebp)
  800b97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b9a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800b9d:	0f 8c 32 ff ff ff    	jl     800ad5 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800ba3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800baa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800bb1:	eb 26                	jmp    800bd9 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800bb3:	a1 20 50 80 00       	mov    0x805020,%eax
  800bb8:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800bbe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bc1:	89 d0                	mov    %edx,%eax
  800bc3:	01 c0                	add    %eax,%eax
  800bc5:	01 d0                	add    %edx,%eax
  800bc7:	c1 e0 03             	shl    $0x3,%eax
  800bca:	01 c8                	add    %ecx,%eax
  800bcc:	8a 40 04             	mov    0x4(%eax),%al
  800bcf:	3c 01                	cmp    $0x1,%al
  800bd1:	75 03                	jne    800bd6 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800bd3:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800bd6:	ff 45 e0             	incl   -0x20(%ebp)
  800bd9:	a1 20 50 80 00       	mov    0x805020,%eax
  800bde:	8b 50 74             	mov    0x74(%eax),%edx
  800be1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800be4:	39 c2                	cmp    %eax,%edx
  800be6:	77 cb                	ja     800bb3 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800beb:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800bee:	74 14                	je     800c04 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800bf0:	83 ec 04             	sub    $0x4,%esp
  800bf3:	68 ec 3c 80 00       	push   $0x803cec
  800bf8:	6a 44                	push   $0x44
  800bfa:	68 8c 3c 80 00       	push   $0x803c8c
  800bff:	e8 23 fe ff ff       	call   800a27 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800c04:	90                   	nop
  800c05:	c9                   	leave  
  800c06:	c3                   	ret    

00800c07 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800c0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c10:	8b 00                	mov    (%eax),%eax
  800c12:	8d 48 01             	lea    0x1(%eax),%ecx
  800c15:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c18:	89 0a                	mov    %ecx,(%edx)
  800c1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1d:	88 d1                	mov    %dl,%cl
  800c1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c22:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800c26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c29:	8b 00                	mov    (%eax),%eax
  800c2b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800c30:	75 2c                	jne    800c5e <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800c32:	a0 24 50 80 00       	mov    0x805024,%al
  800c37:	0f b6 c0             	movzbl %al,%eax
  800c3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c3d:	8b 12                	mov    (%edx),%edx
  800c3f:	89 d1                	mov    %edx,%ecx
  800c41:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c44:	83 c2 08             	add    $0x8,%edx
  800c47:	83 ec 04             	sub    $0x4,%esp
  800c4a:	50                   	push   %eax
  800c4b:	51                   	push   %ecx
  800c4c:	52                   	push   %edx
  800c4d:	e8 80 13 00 00       	call   801fd2 <sys_cputs>
  800c52:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800c55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c58:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800c5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c61:	8b 40 04             	mov    0x4(%eax),%eax
  800c64:	8d 50 01             	lea    0x1(%eax),%edx
  800c67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6a:	89 50 04             	mov    %edx,0x4(%eax)
}
  800c6d:	90                   	nop
  800c6e:	c9                   	leave  
  800c6f:	c3                   	ret    

00800c70 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800c70:	55                   	push   %ebp
  800c71:	89 e5                	mov    %esp,%ebp
  800c73:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800c79:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800c80:	00 00 00 
	b.cnt = 0;
  800c83:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800c8a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800c8d:	ff 75 0c             	pushl  0xc(%ebp)
  800c90:	ff 75 08             	pushl  0x8(%ebp)
  800c93:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c99:	50                   	push   %eax
  800c9a:	68 07 0c 80 00       	push   $0x800c07
  800c9f:	e8 11 02 00 00       	call   800eb5 <vprintfmt>
  800ca4:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800ca7:	a0 24 50 80 00       	mov    0x805024,%al
  800cac:	0f b6 c0             	movzbl %al,%eax
  800caf:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800cb5:	83 ec 04             	sub    $0x4,%esp
  800cb8:	50                   	push   %eax
  800cb9:	52                   	push   %edx
  800cba:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800cc0:	83 c0 08             	add    $0x8,%eax
  800cc3:	50                   	push   %eax
  800cc4:	e8 09 13 00 00       	call   801fd2 <sys_cputs>
  800cc9:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800ccc:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800cd3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800cd9:	c9                   	leave  
  800cda:	c3                   	ret    

00800cdb <cprintf>:

int cprintf(const char *fmt, ...) {
  800cdb:	55                   	push   %ebp
  800cdc:	89 e5                	mov    %esp,%ebp
  800cde:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800ce1:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800ce8:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ceb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	83 ec 08             	sub    $0x8,%esp
  800cf4:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf7:	50                   	push   %eax
  800cf8:	e8 73 ff ff ff       	call   800c70 <vcprintf>
  800cfd:	83 c4 10             	add    $0x10,%esp
  800d00:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800d03:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d06:	c9                   	leave  
  800d07:	c3                   	ret    

00800d08 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800d08:	55                   	push   %ebp
  800d09:	89 e5                	mov    %esp,%ebp
  800d0b:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800d0e:	e8 6d 14 00 00       	call   802180 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800d13:	8d 45 0c             	lea    0xc(%ebp),%eax
  800d16:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	83 ec 08             	sub    $0x8,%esp
  800d1f:	ff 75 f4             	pushl  -0xc(%ebp)
  800d22:	50                   	push   %eax
  800d23:	e8 48 ff ff ff       	call   800c70 <vcprintf>
  800d28:	83 c4 10             	add    $0x10,%esp
  800d2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800d2e:	e8 67 14 00 00       	call   80219a <sys_enable_interrupt>
	return cnt;
  800d33:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d36:	c9                   	leave  
  800d37:	c3                   	ret    

00800d38 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800d38:	55                   	push   %ebp
  800d39:	89 e5                	mov    %esp,%ebp
  800d3b:	53                   	push   %ebx
  800d3c:	83 ec 14             	sub    $0x14,%esp
  800d3f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d42:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d45:	8b 45 14             	mov    0x14(%ebp),%eax
  800d48:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800d4b:	8b 45 18             	mov    0x18(%ebp),%eax
  800d4e:	ba 00 00 00 00       	mov    $0x0,%edx
  800d53:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800d56:	77 55                	ja     800dad <printnum+0x75>
  800d58:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800d5b:	72 05                	jb     800d62 <printnum+0x2a>
  800d5d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800d60:	77 4b                	ja     800dad <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800d62:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800d65:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800d68:	8b 45 18             	mov    0x18(%ebp),%eax
  800d6b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d70:	52                   	push   %edx
  800d71:	50                   	push   %eax
  800d72:	ff 75 f4             	pushl  -0xc(%ebp)
  800d75:	ff 75 f0             	pushl  -0x10(%ebp)
  800d78:	e8 cf 29 00 00       	call   80374c <__udivdi3>
  800d7d:	83 c4 10             	add    $0x10,%esp
  800d80:	83 ec 04             	sub    $0x4,%esp
  800d83:	ff 75 20             	pushl  0x20(%ebp)
  800d86:	53                   	push   %ebx
  800d87:	ff 75 18             	pushl  0x18(%ebp)
  800d8a:	52                   	push   %edx
  800d8b:	50                   	push   %eax
  800d8c:	ff 75 0c             	pushl  0xc(%ebp)
  800d8f:	ff 75 08             	pushl  0x8(%ebp)
  800d92:	e8 a1 ff ff ff       	call   800d38 <printnum>
  800d97:	83 c4 20             	add    $0x20,%esp
  800d9a:	eb 1a                	jmp    800db6 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800d9c:	83 ec 08             	sub    $0x8,%esp
  800d9f:	ff 75 0c             	pushl  0xc(%ebp)
  800da2:	ff 75 20             	pushl  0x20(%ebp)
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
  800da8:	ff d0                	call   *%eax
  800daa:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800dad:	ff 4d 1c             	decl   0x1c(%ebp)
  800db0:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800db4:	7f e6                	jg     800d9c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800db6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800db9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dc4:	53                   	push   %ebx
  800dc5:	51                   	push   %ecx
  800dc6:	52                   	push   %edx
  800dc7:	50                   	push   %eax
  800dc8:	e8 8f 2a 00 00       	call   80385c <__umoddi3>
  800dcd:	83 c4 10             	add    $0x10,%esp
  800dd0:	05 54 3f 80 00       	add    $0x803f54,%eax
  800dd5:	8a 00                	mov    (%eax),%al
  800dd7:	0f be c0             	movsbl %al,%eax
  800dda:	83 ec 08             	sub    $0x8,%esp
  800ddd:	ff 75 0c             	pushl  0xc(%ebp)
  800de0:	50                   	push   %eax
  800de1:	8b 45 08             	mov    0x8(%ebp),%eax
  800de4:	ff d0                	call   *%eax
  800de6:	83 c4 10             	add    $0x10,%esp
}
  800de9:	90                   	nop
  800dea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ded:	c9                   	leave  
  800dee:	c3                   	ret    

00800def <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800def:	55                   	push   %ebp
  800df0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800df2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800df6:	7e 1c                	jle    800e14 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	8b 00                	mov    (%eax),%eax
  800dfd:	8d 50 08             	lea    0x8(%eax),%edx
  800e00:	8b 45 08             	mov    0x8(%ebp),%eax
  800e03:	89 10                	mov    %edx,(%eax)
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
  800e08:	8b 00                	mov    (%eax),%eax
  800e0a:	83 e8 08             	sub    $0x8,%eax
  800e0d:	8b 50 04             	mov    0x4(%eax),%edx
  800e10:	8b 00                	mov    (%eax),%eax
  800e12:	eb 40                	jmp    800e54 <getuint+0x65>
	else if (lflag)
  800e14:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e18:	74 1e                	je     800e38 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1d:	8b 00                	mov    (%eax),%eax
  800e1f:	8d 50 04             	lea    0x4(%eax),%edx
  800e22:	8b 45 08             	mov    0x8(%ebp),%eax
  800e25:	89 10                	mov    %edx,(%eax)
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	8b 00                	mov    (%eax),%eax
  800e2c:	83 e8 04             	sub    $0x4,%eax
  800e2f:	8b 00                	mov    (%eax),%eax
  800e31:	ba 00 00 00 00       	mov    $0x0,%edx
  800e36:	eb 1c                	jmp    800e54 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800e38:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3b:	8b 00                	mov    (%eax),%eax
  800e3d:	8d 50 04             	lea    0x4(%eax),%edx
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	89 10                	mov    %edx,(%eax)
  800e45:	8b 45 08             	mov    0x8(%ebp),%eax
  800e48:	8b 00                	mov    (%eax),%eax
  800e4a:	83 e8 04             	sub    $0x4,%eax
  800e4d:	8b 00                	mov    (%eax),%eax
  800e4f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800e54:	5d                   	pop    %ebp
  800e55:	c3                   	ret    

00800e56 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800e56:	55                   	push   %ebp
  800e57:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800e59:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800e5d:	7e 1c                	jle    800e7b <getint+0x25>
		return va_arg(*ap, long long);
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	8b 00                	mov    (%eax),%eax
  800e64:	8d 50 08             	lea    0x8(%eax),%edx
  800e67:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6a:	89 10                	mov    %edx,(%eax)
  800e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6f:	8b 00                	mov    (%eax),%eax
  800e71:	83 e8 08             	sub    $0x8,%eax
  800e74:	8b 50 04             	mov    0x4(%eax),%edx
  800e77:	8b 00                	mov    (%eax),%eax
  800e79:	eb 38                	jmp    800eb3 <getint+0x5d>
	else if (lflag)
  800e7b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e7f:	74 1a                	je     800e9b <getint+0x45>
		return va_arg(*ap, long);
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
  800e84:	8b 00                	mov    (%eax),%eax
  800e86:	8d 50 04             	lea    0x4(%eax),%edx
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8c:	89 10                	mov    %edx,(%eax)
  800e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e91:	8b 00                	mov    (%eax),%eax
  800e93:	83 e8 04             	sub    $0x4,%eax
  800e96:	8b 00                	mov    (%eax),%eax
  800e98:	99                   	cltd   
  800e99:	eb 18                	jmp    800eb3 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9e:	8b 00                	mov    (%eax),%eax
  800ea0:	8d 50 04             	lea    0x4(%eax),%edx
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	89 10                	mov    %edx,(%eax)
  800ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eab:	8b 00                	mov    (%eax),%eax
  800ead:	83 e8 04             	sub    $0x4,%eax
  800eb0:	8b 00                	mov    (%eax),%eax
  800eb2:	99                   	cltd   
}
  800eb3:	5d                   	pop    %ebp
  800eb4:	c3                   	ret    

00800eb5 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800eb5:	55                   	push   %ebp
  800eb6:	89 e5                	mov    %esp,%ebp
  800eb8:	56                   	push   %esi
  800eb9:	53                   	push   %ebx
  800eba:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ebd:	eb 17                	jmp    800ed6 <vprintfmt+0x21>
			if (ch == '\0')
  800ebf:	85 db                	test   %ebx,%ebx
  800ec1:	0f 84 af 03 00 00    	je     801276 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800ec7:	83 ec 08             	sub    $0x8,%esp
  800eca:	ff 75 0c             	pushl  0xc(%ebp)
  800ecd:	53                   	push   %ebx
  800ece:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed1:	ff d0                	call   *%eax
  800ed3:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ed6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed9:	8d 50 01             	lea    0x1(%eax),%edx
  800edc:	89 55 10             	mov    %edx,0x10(%ebp)
  800edf:	8a 00                	mov    (%eax),%al
  800ee1:	0f b6 d8             	movzbl %al,%ebx
  800ee4:	83 fb 25             	cmp    $0x25,%ebx
  800ee7:	75 d6                	jne    800ebf <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800ee9:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800eed:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800ef4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800efb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800f02:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f09:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0c:	8d 50 01             	lea    0x1(%eax),%edx
  800f0f:	89 55 10             	mov    %edx,0x10(%ebp)
  800f12:	8a 00                	mov    (%eax),%al
  800f14:	0f b6 d8             	movzbl %al,%ebx
  800f17:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800f1a:	83 f8 55             	cmp    $0x55,%eax
  800f1d:	0f 87 2b 03 00 00    	ja     80124e <vprintfmt+0x399>
  800f23:	8b 04 85 78 3f 80 00 	mov    0x803f78(,%eax,4),%eax
  800f2a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800f2c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800f30:	eb d7                	jmp    800f09 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800f32:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800f36:	eb d1                	jmp    800f09 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f38:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800f3f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800f42:	89 d0                	mov    %edx,%eax
  800f44:	c1 e0 02             	shl    $0x2,%eax
  800f47:	01 d0                	add    %edx,%eax
  800f49:	01 c0                	add    %eax,%eax
  800f4b:	01 d8                	add    %ebx,%eax
  800f4d:	83 e8 30             	sub    $0x30,%eax
  800f50:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800f53:	8b 45 10             	mov    0x10(%ebp),%eax
  800f56:	8a 00                	mov    (%eax),%al
  800f58:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800f5b:	83 fb 2f             	cmp    $0x2f,%ebx
  800f5e:	7e 3e                	jle    800f9e <vprintfmt+0xe9>
  800f60:	83 fb 39             	cmp    $0x39,%ebx
  800f63:	7f 39                	jg     800f9e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f65:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800f68:	eb d5                	jmp    800f3f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800f6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800f6d:	83 c0 04             	add    $0x4,%eax
  800f70:	89 45 14             	mov    %eax,0x14(%ebp)
  800f73:	8b 45 14             	mov    0x14(%ebp),%eax
  800f76:	83 e8 04             	sub    $0x4,%eax
  800f79:	8b 00                	mov    (%eax),%eax
  800f7b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800f7e:	eb 1f                	jmp    800f9f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800f80:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f84:	79 83                	jns    800f09 <vprintfmt+0x54>
				width = 0;
  800f86:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800f8d:	e9 77 ff ff ff       	jmp    800f09 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800f92:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800f99:	e9 6b ff ff ff       	jmp    800f09 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800f9e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800f9f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fa3:	0f 89 60 ff ff ff    	jns    800f09 <vprintfmt+0x54>
				width = precision, precision = -1;
  800fa9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800faf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800fb6:	e9 4e ff ff ff       	jmp    800f09 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800fbb:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800fbe:	e9 46 ff ff ff       	jmp    800f09 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800fc3:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc6:	83 c0 04             	add    $0x4,%eax
  800fc9:	89 45 14             	mov    %eax,0x14(%ebp)
  800fcc:	8b 45 14             	mov    0x14(%ebp),%eax
  800fcf:	83 e8 04             	sub    $0x4,%eax
  800fd2:	8b 00                	mov    (%eax),%eax
  800fd4:	83 ec 08             	sub    $0x8,%esp
  800fd7:	ff 75 0c             	pushl  0xc(%ebp)
  800fda:	50                   	push   %eax
  800fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fde:	ff d0                	call   *%eax
  800fe0:	83 c4 10             	add    $0x10,%esp
			break;
  800fe3:	e9 89 02 00 00       	jmp    801271 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800fe8:	8b 45 14             	mov    0x14(%ebp),%eax
  800feb:	83 c0 04             	add    $0x4,%eax
  800fee:	89 45 14             	mov    %eax,0x14(%ebp)
  800ff1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ff4:	83 e8 04             	sub    $0x4,%eax
  800ff7:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ff9:	85 db                	test   %ebx,%ebx
  800ffb:	79 02                	jns    800fff <vprintfmt+0x14a>
				err = -err;
  800ffd:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800fff:	83 fb 64             	cmp    $0x64,%ebx
  801002:	7f 0b                	jg     80100f <vprintfmt+0x15a>
  801004:	8b 34 9d c0 3d 80 00 	mov    0x803dc0(,%ebx,4),%esi
  80100b:	85 f6                	test   %esi,%esi
  80100d:	75 19                	jne    801028 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80100f:	53                   	push   %ebx
  801010:	68 65 3f 80 00       	push   $0x803f65
  801015:	ff 75 0c             	pushl  0xc(%ebp)
  801018:	ff 75 08             	pushl  0x8(%ebp)
  80101b:	e8 5e 02 00 00       	call   80127e <printfmt>
  801020:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801023:	e9 49 02 00 00       	jmp    801271 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801028:	56                   	push   %esi
  801029:	68 6e 3f 80 00       	push   $0x803f6e
  80102e:	ff 75 0c             	pushl  0xc(%ebp)
  801031:	ff 75 08             	pushl  0x8(%ebp)
  801034:	e8 45 02 00 00       	call   80127e <printfmt>
  801039:	83 c4 10             	add    $0x10,%esp
			break;
  80103c:	e9 30 02 00 00       	jmp    801271 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801041:	8b 45 14             	mov    0x14(%ebp),%eax
  801044:	83 c0 04             	add    $0x4,%eax
  801047:	89 45 14             	mov    %eax,0x14(%ebp)
  80104a:	8b 45 14             	mov    0x14(%ebp),%eax
  80104d:	83 e8 04             	sub    $0x4,%eax
  801050:	8b 30                	mov    (%eax),%esi
  801052:	85 f6                	test   %esi,%esi
  801054:	75 05                	jne    80105b <vprintfmt+0x1a6>
				p = "(null)";
  801056:	be 71 3f 80 00       	mov    $0x803f71,%esi
			if (width > 0 && padc != '-')
  80105b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80105f:	7e 6d                	jle    8010ce <vprintfmt+0x219>
  801061:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801065:	74 67                	je     8010ce <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801067:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80106a:	83 ec 08             	sub    $0x8,%esp
  80106d:	50                   	push   %eax
  80106e:	56                   	push   %esi
  80106f:	e8 0c 03 00 00       	call   801380 <strnlen>
  801074:	83 c4 10             	add    $0x10,%esp
  801077:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80107a:	eb 16                	jmp    801092 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80107c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801080:	83 ec 08             	sub    $0x8,%esp
  801083:	ff 75 0c             	pushl  0xc(%ebp)
  801086:	50                   	push   %eax
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	ff d0                	call   *%eax
  80108c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80108f:	ff 4d e4             	decl   -0x1c(%ebp)
  801092:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801096:	7f e4                	jg     80107c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801098:	eb 34                	jmp    8010ce <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80109a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80109e:	74 1c                	je     8010bc <vprintfmt+0x207>
  8010a0:	83 fb 1f             	cmp    $0x1f,%ebx
  8010a3:	7e 05                	jle    8010aa <vprintfmt+0x1f5>
  8010a5:	83 fb 7e             	cmp    $0x7e,%ebx
  8010a8:	7e 12                	jle    8010bc <vprintfmt+0x207>
					putch('?', putdat);
  8010aa:	83 ec 08             	sub    $0x8,%esp
  8010ad:	ff 75 0c             	pushl  0xc(%ebp)
  8010b0:	6a 3f                	push   $0x3f
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	ff d0                	call   *%eax
  8010b7:	83 c4 10             	add    $0x10,%esp
  8010ba:	eb 0f                	jmp    8010cb <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8010bc:	83 ec 08             	sub    $0x8,%esp
  8010bf:	ff 75 0c             	pushl  0xc(%ebp)
  8010c2:	53                   	push   %ebx
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	ff d0                	call   *%eax
  8010c8:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8010cb:	ff 4d e4             	decl   -0x1c(%ebp)
  8010ce:	89 f0                	mov    %esi,%eax
  8010d0:	8d 70 01             	lea    0x1(%eax),%esi
  8010d3:	8a 00                	mov    (%eax),%al
  8010d5:	0f be d8             	movsbl %al,%ebx
  8010d8:	85 db                	test   %ebx,%ebx
  8010da:	74 24                	je     801100 <vprintfmt+0x24b>
  8010dc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8010e0:	78 b8                	js     80109a <vprintfmt+0x1e5>
  8010e2:	ff 4d e0             	decl   -0x20(%ebp)
  8010e5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8010e9:	79 af                	jns    80109a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8010eb:	eb 13                	jmp    801100 <vprintfmt+0x24b>
				putch(' ', putdat);
  8010ed:	83 ec 08             	sub    $0x8,%esp
  8010f0:	ff 75 0c             	pushl  0xc(%ebp)
  8010f3:	6a 20                	push   $0x20
  8010f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f8:	ff d0                	call   *%eax
  8010fa:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8010fd:	ff 4d e4             	decl   -0x1c(%ebp)
  801100:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801104:	7f e7                	jg     8010ed <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801106:	e9 66 01 00 00       	jmp    801271 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80110b:	83 ec 08             	sub    $0x8,%esp
  80110e:	ff 75 e8             	pushl  -0x18(%ebp)
  801111:	8d 45 14             	lea    0x14(%ebp),%eax
  801114:	50                   	push   %eax
  801115:	e8 3c fd ff ff       	call   800e56 <getint>
  80111a:	83 c4 10             	add    $0x10,%esp
  80111d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801120:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801123:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801126:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801129:	85 d2                	test   %edx,%edx
  80112b:	79 23                	jns    801150 <vprintfmt+0x29b>
				putch('-', putdat);
  80112d:	83 ec 08             	sub    $0x8,%esp
  801130:	ff 75 0c             	pushl  0xc(%ebp)
  801133:	6a 2d                	push   $0x2d
  801135:	8b 45 08             	mov    0x8(%ebp),%eax
  801138:	ff d0                	call   *%eax
  80113a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80113d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801140:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801143:	f7 d8                	neg    %eax
  801145:	83 d2 00             	adc    $0x0,%edx
  801148:	f7 da                	neg    %edx
  80114a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80114d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801150:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801157:	e9 bc 00 00 00       	jmp    801218 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80115c:	83 ec 08             	sub    $0x8,%esp
  80115f:	ff 75 e8             	pushl  -0x18(%ebp)
  801162:	8d 45 14             	lea    0x14(%ebp),%eax
  801165:	50                   	push   %eax
  801166:	e8 84 fc ff ff       	call   800def <getuint>
  80116b:	83 c4 10             	add    $0x10,%esp
  80116e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801171:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801174:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80117b:	e9 98 00 00 00       	jmp    801218 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801180:	83 ec 08             	sub    $0x8,%esp
  801183:	ff 75 0c             	pushl  0xc(%ebp)
  801186:	6a 58                	push   $0x58
  801188:	8b 45 08             	mov    0x8(%ebp),%eax
  80118b:	ff d0                	call   *%eax
  80118d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801190:	83 ec 08             	sub    $0x8,%esp
  801193:	ff 75 0c             	pushl  0xc(%ebp)
  801196:	6a 58                	push   $0x58
  801198:	8b 45 08             	mov    0x8(%ebp),%eax
  80119b:	ff d0                	call   *%eax
  80119d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8011a0:	83 ec 08             	sub    $0x8,%esp
  8011a3:	ff 75 0c             	pushl  0xc(%ebp)
  8011a6:	6a 58                	push   $0x58
  8011a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ab:	ff d0                	call   *%eax
  8011ad:	83 c4 10             	add    $0x10,%esp
			break;
  8011b0:	e9 bc 00 00 00       	jmp    801271 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8011b5:	83 ec 08             	sub    $0x8,%esp
  8011b8:	ff 75 0c             	pushl  0xc(%ebp)
  8011bb:	6a 30                	push   $0x30
  8011bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c0:	ff d0                	call   *%eax
  8011c2:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8011c5:	83 ec 08             	sub    $0x8,%esp
  8011c8:	ff 75 0c             	pushl  0xc(%ebp)
  8011cb:	6a 78                	push   $0x78
  8011cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d0:	ff d0                	call   *%eax
  8011d2:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8011d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d8:	83 c0 04             	add    $0x4,%eax
  8011db:	89 45 14             	mov    %eax,0x14(%ebp)
  8011de:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e1:	83 e8 04             	sub    $0x4,%eax
  8011e4:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8011e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8011f0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8011f7:	eb 1f                	jmp    801218 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8011f9:	83 ec 08             	sub    $0x8,%esp
  8011fc:	ff 75 e8             	pushl  -0x18(%ebp)
  8011ff:	8d 45 14             	lea    0x14(%ebp),%eax
  801202:	50                   	push   %eax
  801203:	e8 e7 fb ff ff       	call   800def <getuint>
  801208:	83 c4 10             	add    $0x10,%esp
  80120b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80120e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801211:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801218:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80121c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80121f:	83 ec 04             	sub    $0x4,%esp
  801222:	52                   	push   %edx
  801223:	ff 75 e4             	pushl  -0x1c(%ebp)
  801226:	50                   	push   %eax
  801227:	ff 75 f4             	pushl  -0xc(%ebp)
  80122a:	ff 75 f0             	pushl  -0x10(%ebp)
  80122d:	ff 75 0c             	pushl  0xc(%ebp)
  801230:	ff 75 08             	pushl  0x8(%ebp)
  801233:	e8 00 fb ff ff       	call   800d38 <printnum>
  801238:	83 c4 20             	add    $0x20,%esp
			break;
  80123b:	eb 34                	jmp    801271 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80123d:	83 ec 08             	sub    $0x8,%esp
  801240:	ff 75 0c             	pushl  0xc(%ebp)
  801243:	53                   	push   %ebx
  801244:	8b 45 08             	mov    0x8(%ebp),%eax
  801247:	ff d0                	call   *%eax
  801249:	83 c4 10             	add    $0x10,%esp
			break;
  80124c:	eb 23                	jmp    801271 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80124e:	83 ec 08             	sub    $0x8,%esp
  801251:	ff 75 0c             	pushl  0xc(%ebp)
  801254:	6a 25                	push   $0x25
  801256:	8b 45 08             	mov    0x8(%ebp),%eax
  801259:	ff d0                	call   *%eax
  80125b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80125e:	ff 4d 10             	decl   0x10(%ebp)
  801261:	eb 03                	jmp    801266 <vprintfmt+0x3b1>
  801263:	ff 4d 10             	decl   0x10(%ebp)
  801266:	8b 45 10             	mov    0x10(%ebp),%eax
  801269:	48                   	dec    %eax
  80126a:	8a 00                	mov    (%eax),%al
  80126c:	3c 25                	cmp    $0x25,%al
  80126e:	75 f3                	jne    801263 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801270:	90                   	nop
		}
	}
  801271:	e9 47 fc ff ff       	jmp    800ebd <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801276:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801277:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80127a:	5b                   	pop    %ebx
  80127b:	5e                   	pop    %esi
  80127c:	5d                   	pop    %ebp
  80127d:	c3                   	ret    

0080127e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80127e:	55                   	push   %ebp
  80127f:	89 e5                	mov    %esp,%ebp
  801281:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801284:	8d 45 10             	lea    0x10(%ebp),%eax
  801287:	83 c0 04             	add    $0x4,%eax
  80128a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80128d:	8b 45 10             	mov    0x10(%ebp),%eax
  801290:	ff 75 f4             	pushl  -0xc(%ebp)
  801293:	50                   	push   %eax
  801294:	ff 75 0c             	pushl  0xc(%ebp)
  801297:	ff 75 08             	pushl  0x8(%ebp)
  80129a:	e8 16 fc ff ff       	call   800eb5 <vprintfmt>
  80129f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8012a2:	90                   	nop
  8012a3:	c9                   	leave  
  8012a4:	c3                   	ret    

008012a5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8012a5:	55                   	push   %ebp
  8012a6:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8012a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ab:	8b 40 08             	mov    0x8(%eax),%eax
  8012ae:	8d 50 01             	lea    0x1(%eax),%edx
  8012b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b4:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8012b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ba:	8b 10                	mov    (%eax),%edx
  8012bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bf:	8b 40 04             	mov    0x4(%eax),%eax
  8012c2:	39 c2                	cmp    %eax,%edx
  8012c4:	73 12                	jae    8012d8 <sprintputch+0x33>
		*b->buf++ = ch;
  8012c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c9:	8b 00                	mov    (%eax),%eax
  8012cb:	8d 48 01             	lea    0x1(%eax),%ecx
  8012ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012d1:	89 0a                	mov    %ecx,(%edx)
  8012d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8012d6:	88 10                	mov    %dl,(%eax)
}
  8012d8:	90                   	nop
  8012d9:	5d                   	pop    %ebp
  8012da:	c3                   	ret    

008012db <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8012db:	55                   	push   %ebp
  8012dc:	89 e5                	mov    %esp,%ebp
  8012de:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8012e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8012e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ea:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f0:	01 d0                	add    %edx,%eax
  8012f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8012f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8012fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801300:	74 06                	je     801308 <vsnprintf+0x2d>
  801302:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801306:	7f 07                	jg     80130f <vsnprintf+0x34>
		return -E_INVAL;
  801308:	b8 03 00 00 00       	mov    $0x3,%eax
  80130d:	eb 20                	jmp    80132f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80130f:	ff 75 14             	pushl  0x14(%ebp)
  801312:	ff 75 10             	pushl  0x10(%ebp)
  801315:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801318:	50                   	push   %eax
  801319:	68 a5 12 80 00       	push   $0x8012a5
  80131e:	e8 92 fb ff ff       	call   800eb5 <vprintfmt>
  801323:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801326:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801329:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80132c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80132f:	c9                   	leave  
  801330:	c3                   	ret    

00801331 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801331:	55                   	push   %ebp
  801332:	89 e5                	mov    %esp,%ebp
  801334:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801337:	8d 45 10             	lea    0x10(%ebp),%eax
  80133a:	83 c0 04             	add    $0x4,%eax
  80133d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801340:	8b 45 10             	mov    0x10(%ebp),%eax
  801343:	ff 75 f4             	pushl  -0xc(%ebp)
  801346:	50                   	push   %eax
  801347:	ff 75 0c             	pushl  0xc(%ebp)
  80134a:	ff 75 08             	pushl  0x8(%ebp)
  80134d:	e8 89 ff ff ff       	call   8012db <vsnprintf>
  801352:	83 c4 10             	add    $0x10,%esp
  801355:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801358:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80135b:	c9                   	leave  
  80135c:	c3                   	ret    

0080135d <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80135d:	55                   	push   %ebp
  80135e:	89 e5                	mov    %esp,%ebp
  801360:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801363:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80136a:	eb 06                	jmp    801372 <strlen+0x15>
		n++;
  80136c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80136f:	ff 45 08             	incl   0x8(%ebp)
  801372:	8b 45 08             	mov    0x8(%ebp),%eax
  801375:	8a 00                	mov    (%eax),%al
  801377:	84 c0                	test   %al,%al
  801379:	75 f1                	jne    80136c <strlen+0xf>
		n++;
	return n;
  80137b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80137e:	c9                   	leave  
  80137f:	c3                   	ret    

00801380 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
  801383:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801386:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80138d:	eb 09                	jmp    801398 <strnlen+0x18>
		n++;
  80138f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801392:	ff 45 08             	incl   0x8(%ebp)
  801395:	ff 4d 0c             	decl   0xc(%ebp)
  801398:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80139c:	74 09                	je     8013a7 <strnlen+0x27>
  80139e:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a1:	8a 00                	mov    (%eax),%al
  8013a3:	84 c0                	test   %al,%al
  8013a5:	75 e8                	jne    80138f <strnlen+0xf>
		n++;
	return n;
  8013a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013aa:	c9                   	leave  
  8013ab:	c3                   	ret    

008013ac <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
  8013af:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8013b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8013b8:	90                   	nop
  8013b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bc:	8d 50 01             	lea    0x1(%eax),%edx
  8013bf:	89 55 08             	mov    %edx,0x8(%ebp)
  8013c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013c5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013c8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013cb:	8a 12                	mov    (%edx),%dl
  8013cd:	88 10                	mov    %dl,(%eax)
  8013cf:	8a 00                	mov    (%eax),%al
  8013d1:	84 c0                	test   %al,%al
  8013d3:	75 e4                	jne    8013b9 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8013d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013d8:	c9                   	leave  
  8013d9:	c3                   	ret    

008013da <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8013da:	55                   	push   %ebp
  8013db:	89 e5                	mov    %esp,%ebp
  8013dd:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8013e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8013e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013ed:	eb 1f                	jmp    80140e <strncpy+0x34>
		*dst++ = *src;
  8013ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f2:	8d 50 01             	lea    0x1(%eax),%edx
  8013f5:	89 55 08             	mov    %edx,0x8(%ebp)
  8013f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013fb:	8a 12                	mov    (%edx),%dl
  8013fd:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801402:	8a 00                	mov    (%eax),%al
  801404:	84 c0                	test   %al,%al
  801406:	74 03                	je     80140b <strncpy+0x31>
			src++;
  801408:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80140b:	ff 45 fc             	incl   -0x4(%ebp)
  80140e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801411:	3b 45 10             	cmp    0x10(%ebp),%eax
  801414:	72 d9                	jb     8013ef <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801416:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801419:	c9                   	leave  
  80141a:	c3                   	ret    

0080141b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80141b:	55                   	push   %ebp
  80141c:	89 e5                	mov    %esp,%ebp
  80141e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801421:	8b 45 08             	mov    0x8(%ebp),%eax
  801424:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801427:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80142b:	74 30                	je     80145d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80142d:	eb 16                	jmp    801445 <strlcpy+0x2a>
			*dst++ = *src++;
  80142f:	8b 45 08             	mov    0x8(%ebp),%eax
  801432:	8d 50 01             	lea    0x1(%eax),%edx
  801435:	89 55 08             	mov    %edx,0x8(%ebp)
  801438:	8b 55 0c             	mov    0xc(%ebp),%edx
  80143b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80143e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801441:	8a 12                	mov    (%edx),%dl
  801443:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801445:	ff 4d 10             	decl   0x10(%ebp)
  801448:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80144c:	74 09                	je     801457 <strlcpy+0x3c>
  80144e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801451:	8a 00                	mov    (%eax),%al
  801453:	84 c0                	test   %al,%al
  801455:	75 d8                	jne    80142f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801457:	8b 45 08             	mov    0x8(%ebp),%eax
  80145a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80145d:	8b 55 08             	mov    0x8(%ebp),%edx
  801460:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801463:	29 c2                	sub    %eax,%edx
  801465:	89 d0                	mov    %edx,%eax
}
  801467:	c9                   	leave  
  801468:	c3                   	ret    

00801469 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801469:	55                   	push   %ebp
  80146a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80146c:	eb 06                	jmp    801474 <strcmp+0xb>
		p++, q++;
  80146e:	ff 45 08             	incl   0x8(%ebp)
  801471:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801474:	8b 45 08             	mov    0x8(%ebp),%eax
  801477:	8a 00                	mov    (%eax),%al
  801479:	84 c0                	test   %al,%al
  80147b:	74 0e                	je     80148b <strcmp+0x22>
  80147d:	8b 45 08             	mov    0x8(%ebp),%eax
  801480:	8a 10                	mov    (%eax),%dl
  801482:	8b 45 0c             	mov    0xc(%ebp),%eax
  801485:	8a 00                	mov    (%eax),%al
  801487:	38 c2                	cmp    %al,%dl
  801489:	74 e3                	je     80146e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	8a 00                	mov    (%eax),%al
  801490:	0f b6 d0             	movzbl %al,%edx
  801493:	8b 45 0c             	mov    0xc(%ebp),%eax
  801496:	8a 00                	mov    (%eax),%al
  801498:	0f b6 c0             	movzbl %al,%eax
  80149b:	29 c2                	sub    %eax,%edx
  80149d:	89 d0                	mov    %edx,%eax
}
  80149f:	5d                   	pop    %ebp
  8014a0:	c3                   	ret    

008014a1 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8014a1:	55                   	push   %ebp
  8014a2:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8014a4:	eb 09                	jmp    8014af <strncmp+0xe>
		n--, p++, q++;
  8014a6:	ff 4d 10             	decl   0x10(%ebp)
  8014a9:	ff 45 08             	incl   0x8(%ebp)
  8014ac:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8014af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014b3:	74 17                	je     8014cc <strncmp+0x2b>
  8014b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b8:	8a 00                	mov    (%eax),%al
  8014ba:	84 c0                	test   %al,%al
  8014bc:	74 0e                	je     8014cc <strncmp+0x2b>
  8014be:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c1:	8a 10                	mov    (%eax),%dl
  8014c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c6:	8a 00                	mov    (%eax),%al
  8014c8:	38 c2                	cmp    %al,%dl
  8014ca:	74 da                	je     8014a6 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8014cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014d0:	75 07                	jne    8014d9 <strncmp+0x38>
		return 0;
  8014d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d7:	eb 14                	jmp    8014ed <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8014d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dc:	8a 00                	mov    (%eax),%al
  8014de:	0f b6 d0             	movzbl %al,%edx
  8014e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e4:	8a 00                	mov    (%eax),%al
  8014e6:	0f b6 c0             	movzbl %al,%eax
  8014e9:	29 c2                	sub    %eax,%edx
  8014eb:	89 d0                	mov    %edx,%eax
}
  8014ed:	5d                   	pop    %ebp
  8014ee:	c3                   	ret    

008014ef <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8014ef:	55                   	push   %ebp
  8014f0:	89 e5                	mov    %esp,%ebp
  8014f2:	83 ec 04             	sub    $0x4,%esp
  8014f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8014fb:	eb 12                	jmp    80150f <strchr+0x20>
		if (*s == c)
  8014fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801500:	8a 00                	mov    (%eax),%al
  801502:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801505:	75 05                	jne    80150c <strchr+0x1d>
			return (char *) s;
  801507:	8b 45 08             	mov    0x8(%ebp),%eax
  80150a:	eb 11                	jmp    80151d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80150c:	ff 45 08             	incl   0x8(%ebp)
  80150f:	8b 45 08             	mov    0x8(%ebp),%eax
  801512:	8a 00                	mov    (%eax),%al
  801514:	84 c0                	test   %al,%al
  801516:	75 e5                	jne    8014fd <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801518:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80151d:	c9                   	leave  
  80151e:	c3                   	ret    

0080151f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80151f:	55                   	push   %ebp
  801520:	89 e5                	mov    %esp,%ebp
  801522:	83 ec 04             	sub    $0x4,%esp
  801525:	8b 45 0c             	mov    0xc(%ebp),%eax
  801528:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80152b:	eb 0d                	jmp    80153a <strfind+0x1b>
		if (*s == c)
  80152d:	8b 45 08             	mov    0x8(%ebp),%eax
  801530:	8a 00                	mov    (%eax),%al
  801532:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801535:	74 0e                	je     801545 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801537:	ff 45 08             	incl   0x8(%ebp)
  80153a:	8b 45 08             	mov    0x8(%ebp),%eax
  80153d:	8a 00                	mov    (%eax),%al
  80153f:	84 c0                	test   %al,%al
  801541:	75 ea                	jne    80152d <strfind+0xe>
  801543:	eb 01                	jmp    801546 <strfind+0x27>
		if (*s == c)
			break;
  801545:	90                   	nop
	return (char *) s;
  801546:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801549:	c9                   	leave  
  80154a:	c3                   	ret    

0080154b <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80154b:	55                   	push   %ebp
  80154c:	89 e5                	mov    %esp,%ebp
  80154e:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801551:	8b 45 08             	mov    0x8(%ebp),%eax
  801554:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801557:	8b 45 10             	mov    0x10(%ebp),%eax
  80155a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80155d:	eb 0e                	jmp    80156d <memset+0x22>
		*p++ = c;
  80155f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801562:	8d 50 01             	lea    0x1(%eax),%edx
  801565:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801568:	8b 55 0c             	mov    0xc(%ebp),%edx
  80156b:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80156d:	ff 4d f8             	decl   -0x8(%ebp)
  801570:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801574:	79 e9                	jns    80155f <memset+0x14>
		*p++ = c;

	return v;
  801576:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801579:	c9                   	leave  
  80157a:	c3                   	ret    

0080157b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80157b:	55                   	push   %ebp
  80157c:	89 e5                	mov    %esp,%ebp
  80157e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801581:	8b 45 0c             	mov    0xc(%ebp),%eax
  801584:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801587:	8b 45 08             	mov    0x8(%ebp),%eax
  80158a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80158d:	eb 16                	jmp    8015a5 <memcpy+0x2a>
		*d++ = *s++;
  80158f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801592:	8d 50 01             	lea    0x1(%eax),%edx
  801595:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801598:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80159b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80159e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8015a1:	8a 12                	mov    (%edx),%dl
  8015a3:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8015a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015ab:	89 55 10             	mov    %edx,0x10(%ebp)
  8015ae:	85 c0                	test   %eax,%eax
  8015b0:	75 dd                	jne    80158f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8015b2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015b5:	c9                   	leave  
  8015b6:	c3                   	ret    

008015b7 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8015b7:	55                   	push   %ebp
  8015b8:	89 e5                	mov    %esp,%ebp
  8015ba:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8015bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8015c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8015c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015cc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8015cf:	73 50                	jae    801621 <memmove+0x6a>
  8015d1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d7:	01 d0                	add    %edx,%eax
  8015d9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8015dc:	76 43                	jbe    801621 <memmove+0x6a>
		s += n;
  8015de:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e1:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8015e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e7:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8015ea:	eb 10                	jmp    8015fc <memmove+0x45>
			*--d = *--s;
  8015ec:	ff 4d f8             	decl   -0x8(%ebp)
  8015ef:	ff 4d fc             	decl   -0x4(%ebp)
  8015f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015f5:	8a 10                	mov    (%eax),%dl
  8015f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015fa:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8015fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ff:	8d 50 ff             	lea    -0x1(%eax),%edx
  801602:	89 55 10             	mov    %edx,0x10(%ebp)
  801605:	85 c0                	test   %eax,%eax
  801607:	75 e3                	jne    8015ec <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801609:	eb 23                	jmp    80162e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80160b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80160e:	8d 50 01             	lea    0x1(%eax),%edx
  801611:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801614:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801617:	8d 4a 01             	lea    0x1(%edx),%ecx
  80161a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80161d:	8a 12                	mov    (%edx),%dl
  80161f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801621:	8b 45 10             	mov    0x10(%ebp),%eax
  801624:	8d 50 ff             	lea    -0x1(%eax),%edx
  801627:	89 55 10             	mov    %edx,0x10(%ebp)
  80162a:	85 c0                	test   %eax,%eax
  80162c:	75 dd                	jne    80160b <memmove+0x54>
			*d++ = *s++;

	return dst;
  80162e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801631:	c9                   	leave  
  801632:	c3                   	ret    

00801633 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
  801636:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801639:	8b 45 08             	mov    0x8(%ebp),%eax
  80163c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80163f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801642:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801645:	eb 2a                	jmp    801671 <memcmp+0x3e>
		if (*s1 != *s2)
  801647:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80164a:	8a 10                	mov    (%eax),%dl
  80164c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80164f:	8a 00                	mov    (%eax),%al
  801651:	38 c2                	cmp    %al,%dl
  801653:	74 16                	je     80166b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801655:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801658:	8a 00                	mov    (%eax),%al
  80165a:	0f b6 d0             	movzbl %al,%edx
  80165d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801660:	8a 00                	mov    (%eax),%al
  801662:	0f b6 c0             	movzbl %al,%eax
  801665:	29 c2                	sub    %eax,%edx
  801667:	89 d0                	mov    %edx,%eax
  801669:	eb 18                	jmp    801683 <memcmp+0x50>
		s1++, s2++;
  80166b:	ff 45 fc             	incl   -0x4(%ebp)
  80166e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801671:	8b 45 10             	mov    0x10(%ebp),%eax
  801674:	8d 50 ff             	lea    -0x1(%eax),%edx
  801677:	89 55 10             	mov    %edx,0x10(%ebp)
  80167a:	85 c0                	test   %eax,%eax
  80167c:	75 c9                	jne    801647 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80167e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801683:	c9                   	leave  
  801684:	c3                   	ret    

00801685 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801685:	55                   	push   %ebp
  801686:	89 e5                	mov    %esp,%ebp
  801688:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80168b:	8b 55 08             	mov    0x8(%ebp),%edx
  80168e:	8b 45 10             	mov    0x10(%ebp),%eax
  801691:	01 d0                	add    %edx,%eax
  801693:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801696:	eb 15                	jmp    8016ad <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801698:	8b 45 08             	mov    0x8(%ebp),%eax
  80169b:	8a 00                	mov    (%eax),%al
  80169d:	0f b6 d0             	movzbl %al,%edx
  8016a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a3:	0f b6 c0             	movzbl %al,%eax
  8016a6:	39 c2                	cmp    %eax,%edx
  8016a8:	74 0d                	je     8016b7 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8016aa:	ff 45 08             	incl   0x8(%ebp)
  8016ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8016b3:	72 e3                	jb     801698 <memfind+0x13>
  8016b5:	eb 01                	jmp    8016b8 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8016b7:	90                   	nop
	return (void *) s;
  8016b8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016bb:	c9                   	leave  
  8016bc:	c3                   	ret    

008016bd <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
  8016c0:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8016c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8016ca:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016d1:	eb 03                	jmp    8016d6 <strtol+0x19>
		s++;
  8016d3:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d9:	8a 00                	mov    (%eax),%al
  8016db:	3c 20                	cmp    $0x20,%al
  8016dd:	74 f4                	je     8016d3 <strtol+0x16>
  8016df:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e2:	8a 00                	mov    (%eax),%al
  8016e4:	3c 09                	cmp    $0x9,%al
  8016e6:	74 eb                	je     8016d3 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8016e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016eb:	8a 00                	mov    (%eax),%al
  8016ed:	3c 2b                	cmp    $0x2b,%al
  8016ef:	75 05                	jne    8016f6 <strtol+0x39>
		s++;
  8016f1:	ff 45 08             	incl   0x8(%ebp)
  8016f4:	eb 13                	jmp    801709 <strtol+0x4c>
	else if (*s == '-')
  8016f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f9:	8a 00                	mov    (%eax),%al
  8016fb:	3c 2d                	cmp    $0x2d,%al
  8016fd:	75 0a                	jne    801709 <strtol+0x4c>
		s++, neg = 1;
  8016ff:	ff 45 08             	incl   0x8(%ebp)
  801702:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801709:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80170d:	74 06                	je     801715 <strtol+0x58>
  80170f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801713:	75 20                	jne    801735 <strtol+0x78>
  801715:	8b 45 08             	mov    0x8(%ebp),%eax
  801718:	8a 00                	mov    (%eax),%al
  80171a:	3c 30                	cmp    $0x30,%al
  80171c:	75 17                	jne    801735 <strtol+0x78>
  80171e:	8b 45 08             	mov    0x8(%ebp),%eax
  801721:	40                   	inc    %eax
  801722:	8a 00                	mov    (%eax),%al
  801724:	3c 78                	cmp    $0x78,%al
  801726:	75 0d                	jne    801735 <strtol+0x78>
		s += 2, base = 16;
  801728:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80172c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801733:	eb 28                	jmp    80175d <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801735:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801739:	75 15                	jne    801750 <strtol+0x93>
  80173b:	8b 45 08             	mov    0x8(%ebp),%eax
  80173e:	8a 00                	mov    (%eax),%al
  801740:	3c 30                	cmp    $0x30,%al
  801742:	75 0c                	jne    801750 <strtol+0x93>
		s++, base = 8;
  801744:	ff 45 08             	incl   0x8(%ebp)
  801747:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80174e:	eb 0d                	jmp    80175d <strtol+0xa0>
	else if (base == 0)
  801750:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801754:	75 07                	jne    80175d <strtol+0xa0>
		base = 10;
  801756:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80175d:	8b 45 08             	mov    0x8(%ebp),%eax
  801760:	8a 00                	mov    (%eax),%al
  801762:	3c 2f                	cmp    $0x2f,%al
  801764:	7e 19                	jle    80177f <strtol+0xc2>
  801766:	8b 45 08             	mov    0x8(%ebp),%eax
  801769:	8a 00                	mov    (%eax),%al
  80176b:	3c 39                	cmp    $0x39,%al
  80176d:	7f 10                	jg     80177f <strtol+0xc2>
			dig = *s - '0';
  80176f:	8b 45 08             	mov    0x8(%ebp),%eax
  801772:	8a 00                	mov    (%eax),%al
  801774:	0f be c0             	movsbl %al,%eax
  801777:	83 e8 30             	sub    $0x30,%eax
  80177a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80177d:	eb 42                	jmp    8017c1 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80177f:	8b 45 08             	mov    0x8(%ebp),%eax
  801782:	8a 00                	mov    (%eax),%al
  801784:	3c 60                	cmp    $0x60,%al
  801786:	7e 19                	jle    8017a1 <strtol+0xe4>
  801788:	8b 45 08             	mov    0x8(%ebp),%eax
  80178b:	8a 00                	mov    (%eax),%al
  80178d:	3c 7a                	cmp    $0x7a,%al
  80178f:	7f 10                	jg     8017a1 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801791:	8b 45 08             	mov    0x8(%ebp),%eax
  801794:	8a 00                	mov    (%eax),%al
  801796:	0f be c0             	movsbl %al,%eax
  801799:	83 e8 57             	sub    $0x57,%eax
  80179c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80179f:	eb 20                	jmp    8017c1 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8017a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a4:	8a 00                	mov    (%eax),%al
  8017a6:	3c 40                	cmp    $0x40,%al
  8017a8:	7e 39                	jle    8017e3 <strtol+0x126>
  8017aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ad:	8a 00                	mov    (%eax),%al
  8017af:	3c 5a                	cmp    $0x5a,%al
  8017b1:	7f 30                	jg     8017e3 <strtol+0x126>
			dig = *s - 'A' + 10;
  8017b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b6:	8a 00                	mov    (%eax),%al
  8017b8:	0f be c0             	movsbl %al,%eax
  8017bb:	83 e8 37             	sub    $0x37,%eax
  8017be:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8017c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c4:	3b 45 10             	cmp    0x10(%ebp),%eax
  8017c7:	7d 19                	jge    8017e2 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8017c9:	ff 45 08             	incl   0x8(%ebp)
  8017cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017cf:	0f af 45 10          	imul   0x10(%ebp),%eax
  8017d3:	89 c2                	mov    %eax,%edx
  8017d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d8:	01 d0                	add    %edx,%eax
  8017da:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8017dd:	e9 7b ff ff ff       	jmp    80175d <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8017e2:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8017e3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017e7:	74 08                	je     8017f1 <strtol+0x134>
		*endptr = (char *) s;
  8017e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8017ef:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8017f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8017f5:	74 07                	je     8017fe <strtol+0x141>
  8017f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017fa:	f7 d8                	neg    %eax
  8017fc:	eb 03                	jmp    801801 <strtol+0x144>
  8017fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801801:	c9                   	leave  
  801802:	c3                   	ret    

00801803 <ltostr>:

void
ltostr(long value, char *str)
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
  801806:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801809:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801810:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801817:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80181b:	79 13                	jns    801830 <ltostr+0x2d>
	{
		neg = 1;
  80181d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801824:	8b 45 0c             	mov    0xc(%ebp),%eax
  801827:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80182a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80182d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801830:	8b 45 08             	mov    0x8(%ebp),%eax
  801833:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801838:	99                   	cltd   
  801839:	f7 f9                	idiv   %ecx
  80183b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80183e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801841:	8d 50 01             	lea    0x1(%eax),%edx
  801844:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801847:	89 c2                	mov    %eax,%edx
  801849:	8b 45 0c             	mov    0xc(%ebp),%eax
  80184c:	01 d0                	add    %edx,%eax
  80184e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801851:	83 c2 30             	add    $0x30,%edx
  801854:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801856:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801859:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80185e:	f7 e9                	imul   %ecx
  801860:	c1 fa 02             	sar    $0x2,%edx
  801863:	89 c8                	mov    %ecx,%eax
  801865:	c1 f8 1f             	sar    $0x1f,%eax
  801868:	29 c2                	sub    %eax,%edx
  80186a:	89 d0                	mov    %edx,%eax
  80186c:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80186f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801872:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801877:	f7 e9                	imul   %ecx
  801879:	c1 fa 02             	sar    $0x2,%edx
  80187c:	89 c8                	mov    %ecx,%eax
  80187e:	c1 f8 1f             	sar    $0x1f,%eax
  801881:	29 c2                	sub    %eax,%edx
  801883:	89 d0                	mov    %edx,%eax
  801885:	c1 e0 02             	shl    $0x2,%eax
  801888:	01 d0                	add    %edx,%eax
  80188a:	01 c0                	add    %eax,%eax
  80188c:	29 c1                	sub    %eax,%ecx
  80188e:	89 ca                	mov    %ecx,%edx
  801890:	85 d2                	test   %edx,%edx
  801892:	75 9c                	jne    801830 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801894:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80189b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80189e:	48                   	dec    %eax
  80189f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8018a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018a6:	74 3d                	je     8018e5 <ltostr+0xe2>
		start = 1 ;
  8018a8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8018af:	eb 34                	jmp    8018e5 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8018b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b7:	01 d0                	add    %edx,%eax
  8018b9:	8a 00                	mov    (%eax),%al
  8018bb:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8018be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c4:	01 c2                	add    %eax,%edx
  8018c6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8018c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018cc:	01 c8                	add    %ecx,%eax
  8018ce:	8a 00                	mov    (%eax),%al
  8018d0:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8018d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d8:	01 c2                	add    %eax,%edx
  8018da:	8a 45 eb             	mov    -0x15(%ebp),%al
  8018dd:	88 02                	mov    %al,(%edx)
		start++ ;
  8018df:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8018e2:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8018e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018eb:	7c c4                	jl     8018b1 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8018ed:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8018f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f3:	01 d0                	add    %edx,%eax
  8018f5:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8018f8:	90                   	nop
  8018f9:	c9                   	leave  
  8018fa:	c3                   	ret    

008018fb <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
  8018fe:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801901:	ff 75 08             	pushl  0x8(%ebp)
  801904:	e8 54 fa ff ff       	call   80135d <strlen>
  801909:	83 c4 04             	add    $0x4,%esp
  80190c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80190f:	ff 75 0c             	pushl  0xc(%ebp)
  801912:	e8 46 fa ff ff       	call   80135d <strlen>
  801917:	83 c4 04             	add    $0x4,%esp
  80191a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80191d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801924:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80192b:	eb 17                	jmp    801944 <strcconcat+0x49>
		final[s] = str1[s] ;
  80192d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801930:	8b 45 10             	mov    0x10(%ebp),%eax
  801933:	01 c2                	add    %eax,%edx
  801935:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801938:	8b 45 08             	mov    0x8(%ebp),%eax
  80193b:	01 c8                	add    %ecx,%eax
  80193d:	8a 00                	mov    (%eax),%al
  80193f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801941:	ff 45 fc             	incl   -0x4(%ebp)
  801944:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801947:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80194a:	7c e1                	jl     80192d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80194c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801953:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80195a:	eb 1f                	jmp    80197b <strcconcat+0x80>
		final[s++] = str2[i] ;
  80195c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80195f:	8d 50 01             	lea    0x1(%eax),%edx
  801962:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801965:	89 c2                	mov    %eax,%edx
  801967:	8b 45 10             	mov    0x10(%ebp),%eax
  80196a:	01 c2                	add    %eax,%edx
  80196c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80196f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801972:	01 c8                	add    %ecx,%eax
  801974:	8a 00                	mov    (%eax),%al
  801976:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801978:	ff 45 f8             	incl   -0x8(%ebp)
  80197b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80197e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801981:	7c d9                	jl     80195c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801983:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801986:	8b 45 10             	mov    0x10(%ebp),%eax
  801989:	01 d0                	add    %edx,%eax
  80198b:	c6 00 00             	movb   $0x0,(%eax)
}
  80198e:	90                   	nop
  80198f:	c9                   	leave  
  801990:	c3                   	ret    

00801991 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801991:	55                   	push   %ebp
  801992:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801994:	8b 45 14             	mov    0x14(%ebp),%eax
  801997:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80199d:	8b 45 14             	mov    0x14(%ebp),%eax
  8019a0:	8b 00                	mov    (%eax),%eax
  8019a2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ac:	01 d0                	add    %edx,%eax
  8019ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019b4:	eb 0c                	jmp    8019c2 <strsplit+0x31>
			*string++ = 0;
  8019b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b9:	8d 50 01             	lea    0x1(%eax),%edx
  8019bc:	89 55 08             	mov    %edx,0x8(%ebp)
  8019bf:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c5:	8a 00                	mov    (%eax),%al
  8019c7:	84 c0                	test   %al,%al
  8019c9:	74 18                	je     8019e3 <strsplit+0x52>
  8019cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ce:	8a 00                	mov    (%eax),%al
  8019d0:	0f be c0             	movsbl %al,%eax
  8019d3:	50                   	push   %eax
  8019d4:	ff 75 0c             	pushl  0xc(%ebp)
  8019d7:	e8 13 fb ff ff       	call   8014ef <strchr>
  8019dc:	83 c4 08             	add    $0x8,%esp
  8019df:	85 c0                	test   %eax,%eax
  8019e1:	75 d3                	jne    8019b6 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8019e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e6:	8a 00                	mov    (%eax),%al
  8019e8:	84 c0                	test   %al,%al
  8019ea:	74 5a                	je     801a46 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8019ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ef:	8b 00                	mov    (%eax),%eax
  8019f1:	83 f8 0f             	cmp    $0xf,%eax
  8019f4:	75 07                	jne    8019fd <strsplit+0x6c>
		{
			return 0;
  8019f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8019fb:	eb 66                	jmp    801a63 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8019fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801a00:	8b 00                	mov    (%eax),%eax
  801a02:	8d 48 01             	lea    0x1(%eax),%ecx
  801a05:	8b 55 14             	mov    0x14(%ebp),%edx
  801a08:	89 0a                	mov    %ecx,(%edx)
  801a0a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a11:	8b 45 10             	mov    0x10(%ebp),%eax
  801a14:	01 c2                	add    %eax,%edx
  801a16:	8b 45 08             	mov    0x8(%ebp),%eax
  801a19:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a1b:	eb 03                	jmp    801a20 <strsplit+0x8f>
			string++;
  801a1d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a20:	8b 45 08             	mov    0x8(%ebp),%eax
  801a23:	8a 00                	mov    (%eax),%al
  801a25:	84 c0                	test   %al,%al
  801a27:	74 8b                	je     8019b4 <strsplit+0x23>
  801a29:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2c:	8a 00                	mov    (%eax),%al
  801a2e:	0f be c0             	movsbl %al,%eax
  801a31:	50                   	push   %eax
  801a32:	ff 75 0c             	pushl  0xc(%ebp)
  801a35:	e8 b5 fa ff ff       	call   8014ef <strchr>
  801a3a:	83 c4 08             	add    $0x8,%esp
  801a3d:	85 c0                	test   %eax,%eax
  801a3f:	74 dc                	je     801a1d <strsplit+0x8c>
			string++;
	}
  801a41:	e9 6e ff ff ff       	jmp    8019b4 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801a46:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801a47:	8b 45 14             	mov    0x14(%ebp),%eax
  801a4a:	8b 00                	mov    (%eax),%eax
  801a4c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a53:	8b 45 10             	mov    0x10(%ebp),%eax
  801a56:	01 d0                	add    %edx,%eax
  801a58:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801a5e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
  801a68:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801a6b:	a1 04 50 80 00       	mov    0x805004,%eax
  801a70:	85 c0                	test   %eax,%eax
  801a72:	74 1f                	je     801a93 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801a74:	e8 1d 00 00 00       	call   801a96 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801a79:	83 ec 0c             	sub    $0xc,%esp
  801a7c:	68 d0 40 80 00       	push   $0x8040d0
  801a81:	e8 55 f2 ff ff       	call   800cdb <cprintf>
  801a86:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801a89:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801a90:	00 00 00 
	}
}
  801a93:	90                   	nop
  801a94:	c9                   	leave  
  801a95:	c3                   	ret    

00801a96 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
  801a99:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  801a9c:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801aa3:	00 00 00 
  801aa6:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801aad:	00 00 00 
  801ab0:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801ab7:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  801aba:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801ac1:	00 00 00 
  801ac4:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801acb:	00 00 00 
  801ace:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801ad5:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  801ad8:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ae2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801ae7:	2d 00 10 00 00       	sub    $0x1000,%eax
  801aec:	a3 50 50 80 00       	mov    %eax,0x805050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801af1:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801af8:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  801afb:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801b02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b05:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  801b0a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b10:	ba 00 00 00 00       	mov    $0x0,%edx
  801b15:	f7 75 f0             	divl   -0x10(%ebp)
  801b18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b1b:	29 d0                	sub    %edx,%eax
  801b1d:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  801b20:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801b27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b2a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b2f:	2d 00 10 00 00       	sub    $0x1000,%eax
  801b34:	83 ec 04             	sub    $0x4,%esp
  801b37:	6a 06                	push   $0x6
  801b39:	ff 75 e8             	pushl  -0x18(%ebp)
  801b3c:	50                   	push   %eax
  801b3d:	e8 d4 05 00 00       	call   802116 <sys_allocate_chunk>
  801b42:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801b45:	a1 20 51 80 00       	mov    0x805120,%eax
  801b4a:	83 ec 0c             	sub    $0xc,%esp
  801b4d:	50                   	push   %eax
  801b4e:	e8 49 0c 00 00       	call   80279c <initialize_MemBlocksList>
  801b53:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  801b56:	a1 48 51 80 00       	mov    0x805148,%eax
  801b5b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  801b5e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801b62:	75 14                	jne    801b78 <initialize_dyn_block_system+0xe2>
  801b64:	83 ec 04             	sub    $0x4,%esp
  801b67:	68 f5 40 80 00       	push   $0x8040f5
  801b6c:	6a 39                	push   $0x39
  801b6e:	68 13 41 80 00       	push   $0x804113
  801b73:	e8 af ee ff ff       	call   800a27 <_panic>
  801b78:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b7b:	8b 00                	mov    (%eax),%eax
  801b7d:	85 c0                	test   %eax,%eax
  801b7f:	74 10                	je     801b91 <initialize_dyn_block_system+0xfb>
  801b81:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b84:	8b 00                	mov    (%eax),%eax
  801b86:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b89:	8b 52 04             	mov    0x4(%edx),%edx
  801b8c:	89 50 04             	mov    %edx,0x4(%eax)
  801b8f:	eb 0b                	jmp    801b9c <initialize_dyn_block_system+0x106>
  801b91:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b94:	8b 40 04             	mov    0x4(%eax),%eax
  801b97:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801b9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b9f:	8b 40 04             	mov    0x4(%eax),%eax
  801ba2:	85 c0                	test   %eax,%eax
  801ba4:	74 0f                	je     801bb5 <initialize_dyn_block_system+0x11f>
  801ba6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ba9:	8b 40 04             	mov    0x4(%eax),%eax
  801bac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801baf:	8b 12                	mov    (%edx),%edx
  801bb1:	89 10                	mov    %edx,(%eax)
  801bb3:	eb 0a                	jmp    801bbf <initialize_dyn_block_system+0x129>
  801bb5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bb8:	8b 00                	mov    (%eax),%eax
  801bba:	a3 48 51 80 00       	mov    %eax,0x805148
  801bbf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bc2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801bc8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bcb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801bd2:	a1 54 51 80 00       	mov    0x805154,%eax
  801bd7:	48                   	dec    %eax
  801bd8:	a3 54 51 80 00       	mov    %eax,0x805154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  801bdd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801be0:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  801be7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bea:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  801bf1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801bf5:	75 14                	jne    801c0b <initialize_dyn_block_system+0x175>
  801bf7:	83 ec 04             	sub    $0x4,%esp
  801bfa:	68 20 41 80 00       	push   $0x804120
  801bff:	6a 3f                	push   $0x3f
  801c01:	68 13 41 80 00       	push   $0x804113
  801c06:	e8 1c ee ff ff       	call   800a27 <_panic>
  801c0b:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801c11:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c14:	89 10                	mov    %edx,(%eax)
  801c16:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c19:	8b 00                	mov    (%eax),%eax
  801c1b:	85 c0                	test   %eax,%eax
  801c1d:	74 0d                	je     801c2c <initialize_dyn_block_system+0x196>
  801c1f:	a1 38 51 80 00       	mov    0x805138,%eax
  801c24:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c27:	89 50 04             	mov    %edx,0x4(%eax)
  801c2a:	eb 08                	jmp    801c34 <initialize_dyn_block_system+0x19e>
  801c2c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c2f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801c34:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c37:	a3 38 51 80 00       	mov    %eax,0x805138
  801c3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c3f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801c46:	a1 44 51 80 00       	mov    0x805144,%eax
  801c4b:	40                   	inc    %eax
  801c4c:	a3 44 51 80 00       	mov    %eax,0x805144

}
  801c51:	90                   	nop
  801c52:	c9                   	leave  
  801c53:	c3                   	ret    

00801c54 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801c54:	55                   	push   %ebp
  801c55:	89 e5                	mov    %esp,%ebp
  801c57:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c5a:	e8 06 fe ff ff       	call   801a65 <InitializeUHeap>
	if (size == 0) return NULL ;
  801c5f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c63:	75 07                	jne    801c6c <malloc+0x18>
  801c65:	b8 00 00 00 00       	mov    $0x0,%eax
  801c6a:	eb 7d                	jmp    801ce9 <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  801c6c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801c73:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801c7a:	8b 55 08             	mov    0x8(%ebp),%edx
  801c7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c80:	01 d0                	add    %edx,%eax
  801c82:	48                   	dec    %eax
  801c83:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c89:	ba 00 00 00 00       	mov    $0x0,%edx
  801c8e:	f7 75 f0             	divl   -0x10(%ebp)
  801c91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c94:	29 d0                	sub    %edx,%eax
  801c96:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  801c99:	e8 46 08 00 00       	call   8024e4 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c9e:	83 f8 01             	cmp    $0x1,%eax
  801ca1:	75 07                	jne    801caa <malloc+0x56>
  801ca3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  801caa:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  801cae:	75 34                	jne    801ce4 <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  801cb0:	83 ec 0c             	sub    $0xc,%esp
  801cb3:	ff 75 e8             	pushl  -0x18(%ebp)
  801cb6:	e8 73 0e 00 00       	call   802b2e <alloc_block_FF>
  801cbb:	83 c4 10             	add    $0x10,%esp
  801cbe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  801cc1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801cc5:	74 16                	je     801cdd <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  801cc7:	83 ec 0c             	sub    $0xc,%esp
  801cca:	ff 75 e4             	pushl  -0x1c(%ebp)
  801ccd:	e8 ff 0b 00 00       	call   8028d1 <insert_sorted_allocList>
  801cd2:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  801cd5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801cd8:	8b 40 08             	mov    0x8(%eax),%eax
  801cdb:	eb 0c                	jmp    801ce9 <malloc+0x95>
	             }
	             else
	             	return NULL;
  801cdd:	b8 00 00 00 00       	mov    $0x0,%eax
  801ce2:	eb 05                	jmp    801ce9 <malloc+0x95>
	      	  }
	          else
	               return NULL;
  801ce4:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  801ce9:	c9                   	leave  
  801cea:	c3                   	ret    

00801ceb <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801ceb:	55                   	push   %ebp
  801cec:	89 e5                	mov    %esp,%ebp
  801cee:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  801cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf4:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  801cf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d00:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d05:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  801d08:	83 ec 08             	sub    $0x8,%esp
  801d0b:	ff 75 f4             	pushl  -0xc(%ebp)
  801d0e:	68 40 50 80 00       	push   $0x805040
  801d13:	e8 61 0b 00 00       	call   802879 <find_block>
  801d18:	83 c4 10             	add    $0x10,%esp
  801d1b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  801d1e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d22:	0f 84 a5 00 00 00    	je     801dcd <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  801d28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d2b:	8b 40 0c             	mov    0xc(%eax),%eax
  801d2e:	83 ec 08             	sub    $0x8,%esp
  801d31:	50                   	push   %eax
  801d32:	ff 75 f4             	pushl  -0xc(%ebp)
  801d35:	e8 a4 03 00 00       	call   8020de <sys_free_user_mem>
  801d3a:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  801d3d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d41:	75 17                	jne    801d5a <free+0x6f>
  801d43:	83 ec 04             	sub    $0x4,%esp
  801d46:	68 f5 40 80 00       	push   $0x8040f5
  801d4b:	68 87 00 00 00       	push   $0x87
  801d50:	68 13 41 80 00       	push   $0x804113
  801d55:	e8 cd ec ff ff       	call   800a27 <_panic>
  801d5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d5d:	8b 00                	mov    (%eax),%eax
  801d5f:	85 c0                	test   %eax,%eax
  801d61:	74 10                	je     801d73 <free+0x88>
  801d63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d66:	8b 00                	mov    (%eax),%eax
  801d68:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d6b:	8b 52 04             	mov    0x4(%edx),%edx
  801d6e:	89 50 04             	mov    %edx,0x4(%eax)
  801d71:	eb 0b                	jmp    801d7e <free+0x93>
  801d73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d76:	8b 40 04             	mov    0x4(%eax),%eax
  801d79:	a3 44 50 80 00       	mov    %eax,0x805044
  801d7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d81:	8b 40 04             	mov    0x4(%eax),%eax
  801d84:	85 c0                	test   %eax,%eax
  801d86:	74 0f                	je     801d97 <free+0xac>
  801d88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d8b:	8b 40 04             	mov    0x4(%eax),%eax
  801d8e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d91:	8b 12                	mov    (%edx),%edx
  801d93:	89 10                	mov    %edx,(%eax)
  801d95:	eb 0a                	jmp    801da1 <free+0xb6>
  801d97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d9a:	8b 00                	mov    (%eax),%eax
  801d9c:	a3 40 50 80 00       	mov    %eax,0x805040
  801da1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801da4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801daa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801db4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801db9:	48                   	dec    %eax
  801dba:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(theBlock);
  801dbf:	83 ec 0c             	sub    $0xc,%esp
  801dc2:	ff 75 ec             	pushl  -0x14(%ebp)
  801dc5:	e8 37 12 00 00       	call   803001 <insert_sorted_with_merge_freeList>
  801dca:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  801dcd:	90                   	nop
  801dce:	c9                   	leave  
  801dcf:	c3                   	ret    

00801dd0 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801dd0:	55                   	push   %ebp
  801dd1:	89 e5                	mov    %esp,%ebp
  801dd3:	83 ec 38             	sub    $0x38,%esp
  801dd6:	8b 45 10             	mov    0x10(%ebp),%eax
  801dd9:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ddc:	e8 84 fc ff ff       	call   801a65 <InitializeUHeap>
	if (size == 0) return NULL ;
  801de1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801de5:	75 07                	jne    801dee <smalloc+0x1e>
  801de7:	b8 00 00 00 00       	mov    $0x0,%eax
  801dec:	eb 7e                	jmp    801e6c <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  801dee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801df5:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801dfc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e02:	01 d0                	add    %edx,%eax
  801e04:	48                   	dec    %eax
  801e05:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801e08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e0b:	ba 00 00 00 00       	mov    $0x0,%edx
  801e10:	f7 75 f0             	divl   -0x10(%ebp)
  801e13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e16:	29 d0                	sub    %edx,%eax
  801e18:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801e1b:	e8 c4 06 00 00       	call   8024e4 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801e20:	83 f8 01             	cmp    $0x1,%eax
  801e23:	75 42                	jne    801e67 <smalloc+0x97>

		  va = malloc(newsize) ;
  801e25:	83 ec 0c             	sub    $0xc,%esp
  801e28:	ff 75 e8             	pushl  -0x18(%ebp)
  801e2b:	e8 24 fe ff ff       	call   801c54 <malloc>
  801e30:	83 c4 10             	add    $0x10,%esp
  801e33:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  801e36:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801e3a:	74 24                	je     801e60 <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  801e3c:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801e40:	ff 75 e4             	pushl  -0x1c(%ebp)
  801e43:	50                   	push   %eax
  801e44:	ff 75 e8             	pushl  -0x18(%ebp)
  801e47:	ff 75 08             	pushl  0x8(%ebp)
  801e4a:	e8 1a 04 00 00       	call   802269 <sys_createSharedObject>
  801e4f:	83 c4 10             	add    $0x10,%esp
  801e52:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  801e55:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e59:	78 0c                	js     801e67 <smalloc+0x97>
					  return va ;
  801e5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e5e:	eb 0c                	jmp    801e6c <smalloc+0x9c>
				 }
				 else
					return NULL;
  801e60:	b8 00 00 00 00       	mov    $0x0,%eax
  801e65:	eb 05                	jmp    801e6c <smalloc+0x9c>
	  }
		  return NULL ;
  801e67:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801e6c:	c9                   	leave  
  801e6d:	c3                   	ret    

00801e6e <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801e6e:	55                   	push   %ebp
  801e6f:	89 e5                	mov    %esp,%ebp
  801e71:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e74:	e8 ec fb ff ff       	call   801a65 <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  801e79:	83 ec 08             	sub    $0x8,%esp
  801e7c:	ff 75 0c             	pushl  0xc(%ebp)
  801e7f:	ff 75 08             	pushl  0x8(%ebp)
  801e82:	e8 0c 04 00 00       	call   802293 <sys_getSizeOfSharedObject>
  801e87:	83 c4 10             	add    $0x10,%esp
  801e8a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  801e8d:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801e91:	75 07                	jne    801e9a <sget+0x2c>
  801e93:	b8 00 00 00 00       	mov    $0x0,%eax
  801e98:	eb 75                	jmp    801f0f <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801e9a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801ea1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ea4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ea7:	01 d0                	add    %edx,%eax
  801ea9:	48                   	dec    %eax
  801eaa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ead:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eb0:	ba 00 00 00 00       	mov    $0x0,%edx
  801eb5:	f7 75 f0             	divl   -0x10(%ebp)
  801eb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ebb:	29 d0                	sub    %edx,%eax
  801ebd:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  801ec0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801ec7:	e8 18 06 00 00       	call   8024e4 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ecc:	83 f8 01             	cmp    $0x1,%eax
  801ecf:	75 39                	jne    801f0a <sget+0x9c>

		  va = malloc(newsize) ;
  801ed1:	83 ec 0c             	sub    $0xc,%esp
  801ed4:	ff 75 e8             	pushl  -0x18(%ebp)
  801ed7:	e8 78 fd ff ff       	call   801c54 <malloc>
  801edc:	83 c4 10             	add    $0x10,%esp
  801edf:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  801ee2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ee6:	74 22                	je     801f0a <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  801ee8:	83 ec 04             	sub    $0x4,%esp
  801eeb:	ff 75 e0             	pushl  -0x20(%ebp)
  801eee:	ff 75 0c             	pushl  0xc(%ebp)
  801ef1:	ff 75 08             	pushl  0x8(%ebp)
  801ef4:	e8 b7 03 00 00       	call   8022b0 <sys_getSharedObject>
  801ef9:	83 c4 10             	add    $0x10,%esp
  801efc:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  801eff:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801f03:	78 05                	js     801f0a <sget+0x9c>
					  return va;
  801f05:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f08:	eb 05                	jmp    801f0f <sget+0xa1>
				  }
			  }
     }
         return NULL;
  801f0a:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  801f0f:	c9                   	leave  
  801f10:	c3                   	ret    

00801f11 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801f11:	55                   	push   %ebp
  801f12:	89 e5                	mov    %esp,%ebp
  801f14:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f17:	e8 49 fb ff ff       	call   801a65 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801f1c:	83 ec 04             	sub    $0x4,%esp
  801f1f:	68 44 41 80 00       	push   $0x804144
  801f24:	68 1e 01 00 00       	push   $0x11e
  801f29:	68 13 41 80 00       	push   $0x804113
  801f2e:	e8 f4 ea ff ff       	call   800a27 <_panic>

00801f33 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801f33:	55                   	push   %ebp
  801f34:	89 e5                	mov    %esp,%ebp
  801f36:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801f39:	83 ec 04             	sub    $0x4,%esp
  801f3c:	68 6c 41 80 00       	push   $0x80416c
  801f41:	68 32 01 00 00       	push   $0x132
  801f46:	68 13 41 80 00       	push   $0x804113
  801f4b:	e8 d7 ea ff ff       	call   800a27 <_panic>

00801f50 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801f50:	55                   	push   %ebp
  801f51:	89 e5                	mov    %esp,%ebp
  801f53:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f56:	83 ec 04             	sub    $0x4,%esp
  801f59:	68 90 41 80 00       	push   $0x804190
  801f5e:	68 3d 01 00 00       	push   $0x13d
  801f63:	68 13 41 80 00       	push   $0x804113
  801f68:	e8 ba ea ff ff       	call   800a27 <_panic>

00801f6d <shrink>:

}
void shrink(uint32 newSize)
{
  801f6d:	55                   	push   %ebp
  801f6e:	89 e5                	mov    %esp,%ebp
  801f70:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f73:	83 ec 04             	sub    $0x4,%esp
  801f76:	68 90 41 80 00       	push   $0x804190
  801f7b:	68 42 01 00 00       	push   $0x142
  801f80:	68 13 41 80 00       	push   $0x804113
  801f85:	e8 9d ea ff ff       	call   800a27 <_panic>

00801f8a <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801f8a:	55                   	push   %ebp
  801f8b:	89 e5                	mov    %esp,%ebp
  801f8d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f90:	83 ec 04             	sub    $0x4,%esp
  801f93:	68 90 41 80 00       	push   $0x804190
  801f98:	68 47 01 00 00       	push   $0x147
  801f9d:	68 13 41 80 00       	push   $0x804113
  801fa2:	e8 80 ea ff ff       	call   800a27 <_panic>

00801fa7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801fa7:	55                   	push   %ebp
  801fa8:	89 e5                	mov    %esp,%ebp
  801faa:	57                   	push   %edi
  801fab:	56                   	push   %esi
  801fac:	53                   	push   %ebx
  801fad:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fb9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fbc:	8b 7d 18             	mov    0x18(%ebp),%edi
  801fbf:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801fc2:	cd 30                	int    $0x30
  801fc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801fc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801fca:	83 c4 10             	add    $0x10,%esp
  801fcd:	5b                   	pop    %ebx
  801fce:	5e                   	pop    %esi
  801fcf:	5f                   	pop    %edi
  801fd0:	5d                   	pop    %ebp
  801fd1:	c3                   	ret    

00801fd2 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801fd2:	55                   	push   %ebp
  801fd3:	89 e5                	mov    %esp,%ebp
  801fd5:	83 ec 04             	sub    $0x4,%esp
  801fd8:	8b 45 10             	mov    0x10(%ebp),%eax
  801fdb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801fde:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 00                	push   $0x0
  801fe9:	52                   	push   %edx
  801fea:	ff 75 0c             	pushl  0xc(%ebp)
  801fed:	50                   	push   %eax
  801fee:	6a 00                	push   $0x0
  801ff0:	e8 b2 ff ff ff       	call   801fa7 <syscall>
  801ff5:	83 c4 18             	add    $0x18,%esp
}
  801ff8:	90                   	nop
  801ff9:	c9                   	leave  
  801ffa:	c3                   	ret    

00801ffb <sys_cgetc>:

int
sys_cgetc(void)
{
  801ffb:	55                   	push   %ebp
  801ffc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ffe:	6a 00                	push   $0x0
  802000:	6a 00                	push   $0x0
  802002:	6a 00                	push   $0x0
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	6a 01                	push   $0x1
  80200a:	e8 98 ff ff ff       	call   801fa7 <syscall>
  80200f:	83 c4 18             	add    $0x18,%esp
}
  802012:	c9                   	leave  
  802013:	c3                   	ret    

00802014 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802014:	55                   	push   %ebp
  802015:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802017:	8b 55 0c             	mov    0xc(%ebp),%edx
  80201a:	8b 45 08             	mov    0x8(%ebp),%eax
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	52                   	push   %edx
  802024:	50                   	push   %eax
  802025:	6a 05                	push   $0x5
  802027:	e8 7b ff ff ff       	call   801fa7 <syscall>
  80202c:	83 c4 18             	add    $0x18,%esp
}
  80202f:	c9                   	leave  
  802030:	c3                   	ret    

00802031 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802031:	55                   	push   %ebp
  802032:	89 e5                	mov    %esp,%ebp
  802034:	56                   	push   %esi
  802035:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802036:	8b 75 18             	mov    0x18(%ebp),%esi
  802039:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80203c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80203f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802042:	8b 45 08             	mov    0x8(%ebp),%eax
  802045:	56                   	push   %esi
  802046:	53                   	push   %ebx
  802047:	51                   	push   %ecx
  802048:	52                   	push   %edx
  802049:	50                   	push   %eax
  80204a:	6a 06                	push   $0x6
  80204c:	e8 56 ff ff ff       	call   801fa7 <syscall>
  802051:	83 c4 18             	add    $0x18,%esp
}
  802054:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802057:	5b                   	pop    %ebx
  802058:	5e                   	pop    %esi
  802059:	5d                   	pop    %ebp
  80205a:	c3                   	ret    

0080205b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80205b:	55                   	push   %ebp
  80205c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80205e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802061:	8b 45 08             	mov    0x8(%ebp),%eax
  802064:	6a 00                	push   $0x0
  802066:	6a 00                	push   $0x0
  802068:	6a 00                	push   $0x0
  80206a:	52                   	push   %edx
  80206b:	50                   	push   %eax
  80206c:	6a 07                	push   $0x7
  80206e:	e8 34 ff ff ff       	call   801fa7 <syscall>
  802073:	83 c4 18             	add    $0x18,%esp
}
  802076:	c9                   	leave  
  802077:	c3                   	ret    

00802078 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802078:	55                   	push   %ebp
  802079:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80207b:	6a 00                	push   $0x0
  80207d:	6a 00                	push   $0x0
  80207f:	6a 00                	push   $0x0
  802081:	ff 75 0c             	pushl  0xc(%ebp)
  802084:	ff 75 08             	pushl  0x8(%ebp)
  802087:	6a 08                	push   $0x8
  802089:	e8 19 ff ff ff       	call   801fa7 <syscall>
  80208e:	83 c4 18             	add    $0x18,%esp
}
  802091:	c9                   	leave  
  802092:	c3                   	ret    

00802093 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802093:	55                   	push   %ebp
  802094:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802096:	6a 00                	push   $0x0
  802098:	6a 00                	push   $0x0
  80209a:	6a 00                	push   $0x0
  80209c:	6a 00                	push   $0x0
  80209e:	6a 00                	push   $0x0
  8020a0:	6a 09                	push   $0x9
  8020a2:	e8 00 ff ff ff       	call   801fa7 <syscall>
  8020a7:	83 c4 18             	add    $0x18,%esp
}
  8020aa:	c9                   	leave  
  8020ab:	c3                   	ret    

008020ac <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8020ac:	55                   	push   %ebp
  8020ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 00                	push   $0x0
  8020b3:	6a 00                	push   $0x0
  8020b5:	6a 00                	push   $0x0
  8020b7:	6a 00                	push   $0x0
  8020b9:	6a 0a                	push   $0xa
  8020bb:	e8 e7 fe ff ff       	call   801fa7 <syscall>
  8020c0:	83 c4 18             	add    $0x18,%esp
}
  8020c3:	c9                   	leave  
  8020c4:	c3                   	ret    

008020c5 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8020c5:	55                   	push   %ebp
  8020c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8020c8:	6a 00                	push   $0x0
  8020ca:	6a 00                	push   $0x0
  8020cc:	6a 00                	push   $0x0
  8020ce:	6a 00                	push   $0x0
  8020d0:	6a 00                	push   $0x0
  8020d2:	6a 0b                	push   $0xb
  8020d4:	e8 ce fe ff ff       	call   801fa7 <syscall>
  8020d9:	83 c4 18             	add    $0x18,%esp
}
  8020dc:	c9                   	leave  
  8020dd:	c3                   	ret    

008020de <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8020de:	55                   	push   %ebp
  8020df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 00                	push   $0x0
  8020e7:	ff 75 0c             	pushl  0xc(%ebp)
  8020ea:	ff 75 08             	pushl  0x8(%ebp)
  8020ed:	6a 0f                	push   $0xf
  8020ef:	e8 b3 fe ff ff       	call   801fa7 <syscall>
  8020f4:	83 c4 18             	add    $0x18,%esp
	return;
  8020f7:	90                   	nop
}
  8020f8:	c9                   	leave  
  8020f9:	c3                   	ret    

008020fa <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8020fa:	55                   	push   %ebp
  8020fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8020fd:	6a 00                	push   $0x0
  8020ff:	6a 00                	push   $0x0
  802101:	6a 00                	push   $0x0
  802103:	ff 75 0c             	pushl  0xc(%ebp)
  802106:	ff 75 08             	pushl  0x8(%ebp)
  802109:	6a 10                	push   $0x10
  80210b:	e8 97 fe ff ff       	call   801fa7 <syscall>
  802110:	83 c4 18             	add    $0x18,%esp
	return ;
  802113:	90                   	nop
}
  802114:	c9                   	leave  
  802115:	c3                   	ret    

00802116 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802116:	55                   	push   %ebp
  802117:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802119:	6a 00                	push   $0x0
  80211b:	6a 00                	push   $0x0
  80211d:	ff 75 10             	pushl  0x10(%ebp)
  802120:	ff 75 0c             	pushl  0xc(%ebp)
  802123:	ff 75 08             	pushl  0x8(%ebp)
  802126:	6a 11                	push   $0x11
  802128:	e8 7a fe ff ff       	call   801fa7 <syscall>
  80212d:	83 c4 18             	add    $0x18,%esp
	return ;
  802130:	90                   	nop
}
  802131:	c9                   	leave  
  802132:	c3                   	ret    

00802133 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802133:	55                   	push   %ebp
  802134:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802136:	6a 00                	push   $0x0
  802138:	6a 00                	push   $0x0
  80213a:	6a 00                	push   $0x0
  80213c:	6a 00                	push   $0x0
  80213e:	6a 00                	push   $0x0
  802140:	6a 0c                	push   $0xc
  802142:	e8 60 fe ff ff       	call   801fa7 <syscall>
  802147:	83 c4 18             	add    $0x18,%esp
}
  80214a:	c9                   	leave  
  80214b:	c3                   	ret    

0080214c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80214c:	55                   	push   %ebp
  80214d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80214f:	6a 00                	push   $0x0
  802151:	6a 00                	push   $0x0
  802153:	6a 00                	push   $0x0
  802155:	6a 00                	push   $0x0
  802157:	ff 75 08             	pushl  0x8(%ebp)
  80215a:	6a 0d                	push   $0xd
  80215c:	e8 46 fe ff ff       	call   801fa7 <syscall>
  802161:	83 c4 18             	add    $0x18,%esp
}
  802164:	c9                   	leave  
  802165:	c3                   	ret    

00802166 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802166:	55                   	push   %ebp
  802167:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802169:	6a 00                	push   $0x0
  80216b:	6a 00                	push   $0x0
  80216d:	6a 00                	push   $0x0
  80216f:	6a 00                	push   $0x0
  802171:	6a 00                	push   $0x0
  802173:	6a 0e                	push   $0xe
  802175:	e8 2d fe ff ff       	call   801fa7 <syscall>
  80217a:	83 c4 18             	add    $0x18,%esp
}
  80217d:	90                   	nop
  80217e:	c9                   	leave  
  80217f:	c3                   	ret    

00802180 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802180:	55                   	push   %ebp
  802181:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802183:	6a 00                	push   $0x0
  802185:	6a 00                	push   $0x0
  802187:	6a 00                	push   $0x0
  802189:	6a 00                	push   $0x0
  80218b:	6a 00                	push   $0x0
  80218d:	6a 13                	push   $0x13
  80218f:	e8 13 fe ff ff       	call   801fa7 <syscall>
  802194:	83 c4 18             	add    $0x18,%esp
}
  802197:	90                   	nop
  802198:	c9                   	leave  
  802199:	c3                   	ret    

0080219a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80219a:	55                   	push   %ebp
  80219b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80219d:	6a 00                	push   $0x0
  80219f:	6a 00                	push   $0x0
  8021a1:	6a 00                	push   $0x0
  8021a3:	6a 00                	push   $0x0
  8021a5:	6a 00                	push   $0x0
  8021a7:	6a 14                	push   $0x14
  8021a9:	e8 f9 fd ff ff       	call   801fa7 <syscall>
  8021ae:	83 c4 18             	add    $0x18,%esp
}
  8021b1:	90                   	nop
  8021b2:	c9                   	leave  
  8021b3:	c3                   	ret    

008021b4 <sys_cputc>:


void
sys_cputc(const char c)
{
  8021b4:	55                   	push   %ebp
  8021b5:	89 e5                	mov    %esp,%ebp
  8021b7:	83 ec 04             	sub    $0x4,%esp
  8021ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8021c0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021c4:	6a 00                	push   $0x0
  8021c6:	6a 00                	push   $0x0
  8021c8:	6a 00                	push   $0x0
  8021ca:	6a 00                	push   $0x0
  8021cc:	50                   	push   %eax
  8021cd:	6a 15                	push   $0x15
  8021cf:	e8 d3 fd ff ff       	call   801fa7 <syscall>
  8021d4:	83 c4 18             	add    $0x18,%esp
}
  8021d7:	90                   	nop
  8021d8:	c9                   	leave  
  8021d9:	c3                   	ret    

008021da <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8021da:	55                   	push   %ebp
  8021db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8021dd:	6a 00                	push   $0x0
  8021df:	6a 00                	push   $0x0
  8021e1:	6a 00                	push   $0x0
  8021e3:	6a 00                	push   $0x0
  8021e5:	6a 00                	push   $0x0
  8021e7:	6a 16                	push   $0x16
  8021e9:	e8 b9 fd ff ff       	call   801fa7 <syscall>
  8021ee:	83 c4 18             	add    $0x18,%esp
}
  8021f1:	90                   	nop
  8021f2:	c9                   	leave  
  8021f3:	c3                   	ret    

008021f4 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8021f4:	55                   	push   %ebp
  8021f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8021f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fa:	6a 00                	push   $0x0
  8021fc:	6a 00                	push   $0x0
  8021fe:	6a 00                	push   $0x0
  802200:	ff 75 0c             	pushl  0xc(%ebp)
  802203:	50                   	push   %eax
  802204:	6a 17                	push   $0x17
  802206:	e8 9c fd ff ff       	call   801fa7 <syscall>
  80220b:	83 c4 18             	add    $0x18,%esp
}
  80220e:	c9                   	leave  
  80220f:	c3                   	ret    

00802210 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802210:	55                   	push   %ebp
  802211:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802213:	8b 55 0c             	mov    0xc(%ebp),%edx
  802216:	8b 45 08             	mov    0x8(%ebp),%eax
  802219:	6a 00                	push   $0x0
  80221b:	6a 00                	push   $0x0
  80221d:	6a 00                	push   $0x0
  80221f:	52                   	push   %edx
  802220:	50                   	push   %eax
  802221:	6a 1a                	push   $0x1a
  802223:	e8 7f fd ff ff       	call   801fa7 <syscall>
  802228:	83 c4 18             	add    $0x18,%esp
}
  80222b:	c9                   	leave  
  80222c:	c3                   	ret    

0080222d <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80222d:	55                   	push   %ebp
  80222e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802230:	8b 55 0c             	mov    0xc(%ebp),%edx
  802233:	8b 45 08             	mov    0x8(%ebp),%eax
  802236:	6a 00                	push   $0x0
  802238:	6a 00                	push   $0x0
  80223a:	6a 00                	push   $0x0
  80223c:	52                   	push   %edx
  80223d:	50                   	push   %eax
  80223e:	6a 18                	push   $0x18
  802240:	e8 62 fd ff ff       	call   801fa7 <syscall>
  802245:	83 c4 18             	add    $0x18,%esp
}
  802248:	90                   	nop
  802249:	c9                   	leave  
  80224a:	c3                   	ret    

0080224b <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80224b:	55                   	push   %ebp
  80224c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80224e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802251:	8b 45 08             	mov    0x8(%ebp),%eax
  802254:	6a 00                	push   $0x0
  802256:	6a 00                	push   $0x0
  802258:	6a 00                	push   $0x0
  80225a:	52                   	push   %edx
  80225b:	50                   	push   %eax
  80225c:	6a 19                	push   $0x19
  80225e:	e8 44 fd ff ff       	call   801fa7 <syscall>
  802263:	83 c4 18             	add    $0x18,%esp
}
  802266:	90                   	nop
  802267:	c9                   	leave  
  802268:	c3                   	ret    

00802269 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802269:	55                   	push   %ebp
  80226a:	89 e5                	mov    %esp,%ebp
  80226c:	83 ec 04             	sub    $0x4,%esp
  80226f:	8b 45 10             	mov    0x10(%ebp),%eax
  802272:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802275:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802278:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80227c:	8b 45 08             	mov    0x8(%ebp),%eax
  80227f:	6a 00                	push   $0x0
  802281:	51                   	push   %ecx
  802282:	52                   	push   %edx
  802283:	ff 75 0c             	pushl  0xc(%ebp)
  802286:	50                   	push   %eax
  802287:	6a 1b                	push   $0x1b
  802289:	e8 19 fd ff ff       	call   801fa7 <syscall>
  80228e:	83 c4 18             	add    $0x18,%esp
}
  802291:	c9                   	leave  
  802292:	c3                   	ret    

00802293 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802293:	55                   	push   %ebp
  802294:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802296:	8b 55 0c             	mov    0xc(%ebp),%edx
  802299:	8b 45 08             	mov    0x8(%ebp),%eax
  80229c:	6a 00                	push   $0x0
  80229e:	6a 00                	push   $0x0
  8022a0:	6a 00                	push   $0x0
  8022a2:	52                   	push   %edx
  8022a3:	50                   	push   %eax
  8022a4:	6a 1c                	push   $0x1c
  8022a6:	e8 fc fc ff ff       	call   801fa7 <syscall>
  8022ab:	83 c4 18             	add    $0x18,%esp
}
  8022ae:	c9                   	leave  
  8022af:	c3                   	ret    

008022b0 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8022b0:	55                   	push   %ebp
  8022b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8022b3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 00                	push   $0x0
  8022c0:	51                   	push   %ecx
  8022c1:	52                   	push   %edx
  8022c2:	50                   	push   %eax
  8022c3:	6a 1d                	push   $0x1d
  8022c5:	e8 dd fc ff ff       	call   801fa7 <syscall>
  8022ca:	83 c4 18             	add    $0x18,%esp
}
  8022cd:	c9                   	leave  
  8022ce:	c3                   	ret    

008022cf <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8022cf:	55                   	push   %ebp
  8022d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8022d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d8:	6a 00                	push   $0x0
  8022da:	6a 00                	push   $0x0
  8022dc:	6a 00                	push   $0x0
  8022de:	52                   	push   %edx
  8022df:	50                   	push   %eax
  8022e0:	6a 1e                	push   $0x1e
  8022e2:	e8 c0 fc ff ff       	call   801fa7 <syscall>
  8022e7:	83 c4 18             	add    $0x18,%esp
}
  8022ea:	c9                   	leave  
  8022eb:	c3                   	ret    

008022ec <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8022ec:	55                   	push   %ebp
  8022ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8022ef:	6a 00                	push   $0x0
  8022f1:	6a 00                	push   $0x0
  8022f3:	6a 00                	push   $0x0
  8022f5:	6a 00                	push   $0x0
  8022f7:	6a 00                	push   $0x0
  8022f9:	6a 1f                	push   $0x1f
  8022fb:	e8 a7 fc ff ff       	call   801fa7 <syscall>
  802300:	83 c4 18             	add    $0x18,%esp
}
  802303:	c9                   	leave  
  802304:	c3                   	ret    

00802305 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802305:	55                   	push   %ebp
  802306:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802308:	8b 45 08             	mov    0x8(%ebp),%eax
  80230b:	6a 00                	push   $0x0
  80230d:	ff 75 14             	pushl  0x14(%ebp)
  802310:	ff 75 10             	pushl  0x10(%ebp)
  802313:	ff 75 0c             	pushl  0xc(%ebp)
  802316:	50                   	push   %eax
  802317:	6a 20                	push   $0x20
  802319:	e8 89 fc ff ff       	call   801fa7 <syscall>
  80231e:	83 c4 18             	add    $0x18,%esp
}
  802321:	c9                   	leave  
  802322:	c3                   	ret    

00802323 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802323:	55                   	push   %ebp
  802324:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802326:	8b 45 08             	mov    0x8(%ebp),%eax
  802329:	6a 00                	push   $0x0
  80232b:	6a 00                	push   $0x0
  80232d:	6a 00                	push   $0x0
  80232f:	6a 00                	push   $0x0
  802331:	50                   	push   %eax
  802332:	6a 21                	push   $0x21
  802334:	e8 6e fc ff ff       	call   801fa7 <syscall>
  802339:	83 c4 18             	add    $0x18,%esp
}
  80233c:	90                   	nop
  80233d:	c9                   	leave  
  80233e:	c3                   	ret    

0080233f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80233f:	55                   	push   %ebp
  802340:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802342:	8b 45 08             	mov    0x8(%ebp),%eax
  802345:	6a 00                	push   $0x0
  802347:	6a 00                	push   $0x0
  802349:	6a 00                	push   $0x0
  80234b:	6a 00                	push   $0x0
  80234d:	50                   	push   %eax
  80234e:	6a 22                	push   $0x22
  802350:	e8 52 fc ff ff       	call   801fa7 <syscall>
  802355:	83 c4 18             	add    $0x18,%esp
}
  802358:	c9                   	leave  
  802359:	c3                   	ret    

0080235a <sys_getenvid>:

int32 sys_getenvid(void)
{
  80235a:	55                   	push   %ebp
  80235b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80235d:	6a 00                	push   $0x0
  80235f:	6a 00                	push   $0x0
  802361:	6a 00                	push   $0x0
  802363:	6a 00                	push   $0x0
  802365:	6a 00                	push   $0x0
  802367:	6a 02                	push   $0x2
  802369:	e8 39 fc ff ff       	call   801fa7 <syscall>
  80236e:	83 c4 18             	add    $0x18,%esp
}
  802371:	c9                   	leave  
  802372:	c3                   	ret    

00802373 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802373:	55                   	push   %ebp
  802374:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802376:	6a 00                	push   $0x0
  802378:	6a 00                	push   $0x0
  80237a:	6a 00                	push   $0x0
  80237c:	6a 00                	push   $0x0
  80237e:	6a 00                	push   $0x0
  802380:	6a 03                	push   $0x3
  802382:	e8 20 fc ff ff       	call   801fa7 <syscall>
  802387:	83 c4 18             	add    $0x18,%esp
}
  80238a:	c9                   	leave  
  80238b:	c3                   	ret    

0080238c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80238c:	55                   	push   %ebp
  80238d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80238f:	6a 00                	push   $0x0
  802391:	6a 00                	push   $0x0
  802393:	6a 00                	push   $0x0
  802395:	6a 00                	push   $0x0
  802397:	6a 00                	push   $0x0
  802399:	6a 04                	push   $0x4
  80239b:	e8 07 fc ff ff       	call   801fa7 <syscall>
  8023a0:	83 c4 18             	add    $0x18,%esp
}
  8023a3:	c9                   	leave  
  8023a4:	c3                   	ret    

008023a5 <sys_exit_env>:


void sys_exit_env(void)
{
  8023a5:	55                   	push   %ebp
  8023a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8023a8:	6a 00                	push   $0x0
  8023aa:	6a 00                	push   $0x0
  8023ac:	6a 00                	push   $0x0
  8023ae:	6a 00                	push   $0x0
  8023b0:	6a 00                	push   $0x0
  8023b2:	6a 23                	push   $0x23
  8023b4:	e8 ee fb ff ff       	call   801fa7 <syscall>
  8023b9:	83 c4 18             	add    $0x18,%esp
}
  8023bc:	90                   	nop
  8023bd:	c9                   	leave  
  8023be:	c3                   	ret    

008023bf <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8023bf:	55                   	push   %ebp
  8023c0:	89 e5                	mov    %esp,%ebp
  8023c2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8023c5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8023c8:	8d 50 04             	lea    0x4(%eax),%edx
  8023cb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8023ce:	6a 00                	push   $0x0
  8023d0:	6a 00                	push   $0x0
  8023d2:	6a 00                	push   $0x0
  8023d4:	52                   	push   %edx
  8023d5:	50                   	push   %eax
  8023d6:	6a 24                	push   $0x24
  8023d8:	e8 ca fb ff ff       	call   801fa7 <syscall>
  8023dd:	83 c4 18             	add    $0x18,%esp
	return result;
  8023e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023e6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8023e9:	89 01                	mov    %eax,(%ecx)
  8023eb:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8023ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f1:	c9                   	leave  
  8023f2:	c2 04 00             	ret    $0x4

008023f5 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8023f5:	55                   	push   %ebp
  8023f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8023f8:	6a 00                	push   $0x0
  8023fa:	6a 00                	push   $0x0
  8023fc:	ff 75 10             	pushl  0x10(%ebp)
  8023ff:	ff 75 0c             	pushl  0xc(%ebp)
  802402:	ff 75 08             	pushl  0x8(%ebp)
  802405:	6a 12                	push   $0x12
  802407:	e8 9b fb ff ff       	call   801fa7 <syscall>
  80240c:	83 c4 18             	add    $0x18,%esp
	return ;
  80240f:	90                   	nop
}
  802410:	c9                   	leave  
  802411:	c3                   	ret    

00802412 <sys_rcr2>:
uint32 sys_rcr2()
{
  802412:	55                   	push   %ebp
  802413:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802415:	6a 00                	push   $0x0
  802417:	6a 00                	push   $0x0
  802419:	6a 00                	push   $0x0
  80241b:	6a 00                	push   $0x0
  80241d:	6a 00                	push   $0x0
  80241f:	6a 25                	push   $0x25
  802421:	e8 81 fb ff ff       	call   801fa7 <syscall>
  802426:	83 c4 18             	add    $0x18,%esp
}
  802429:	c9                   	leave  
  80242a:	c3                   	ret    

0080242b <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80242b:	55                   	push   %ebp
  80242c:	89 e5                	mov    %esp,%ebp
  80242e:	83 ec 04             	sub    $0x4,%esp
  802431:	8b 45 08             	mov    0x8(%ebp),%eax
  802434:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802437:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80243b:	6a 00                	push   $0x0
  80243d:	6a 00                	push   $0x0
  80243f:	6a 00                	push   $0x0
  802441:	6a 00                	push   $0x0
  802443:	50                   	push   %eax
  802444:	6a 26                	push   $0x26
  802446:	e8 5c fb ff ff       	call   801fa7 <syscall>
  80244b:	83 c4 18             	add    $0x18,%esp
	return ;
  80244e:	90                   	nop
}
  80244f:	c9                   	leave  
  802450:	c3                   	ret    

00802451 <rsttst>:
void rsttst()
{
  802451:	55                   	push   %ebp
  802452:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802454:	6a 00                	push   $0x0
  802456:	6a 00                	push   $0x0
  802458:	6a 00                	push   $0x0
  80245a:	6a 00                	push   $0x0
  80245c:	6a 00                	push   $0x0
  80245e:	6a 28                	push   $0x28
  802460:	e8 42 fb ff ff       	call   801fa7 <syscall>
  802465:	83 c4 18             	add    $0x18,%esp
	return ;
  802468:	90                   	nop
}
  802469:	c9                   	leave  
  80246a:	c3                   	ret    

0080246b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80246b:	55                   	push   %ebp
  80246c:	89 e5                	mov    %esp,%ebp
  80246e:	83 ec 04             	sub    $0x4,%esp
  802471:	8b 45 14             	mov    0x14(%ebp),%eax
  802474:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802477:	8b 55 18             	mov    0x18(%ebp),%edx
  80247a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80247e:	52                   	push   %edx
  80247f:	50                   	push   %eax
  802480:	ff 75 10             	pushl  0x10(%ebp)
  802483:	ff 75 0c             	pushl  0xc(%ebp)
  802486:	ff 75 08             	pushl  0x8(%ebp)
  802489:	6a 27                	push   $0x27
  80248b:	e8 17 fb ff ff       	call   801fa7 <syscall>
  802490:	83 c4 18             	add    $0x18,%esp
	return ;
  802493:	90                   	nop
}
  802494:	c9                   	leave  
  802495:	c3                   	ret    

00802496 <chktst>:
void chktst(uint32 n)
{
  802496:	55                   	push   %ebp
  802497:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802499:	6a 00                	push   $0x0
  80249b:	6a 00                	push   $0x0
  80249d:	6a 00                	push   $0x0
  80249f:	6a 00                	push   $0x0
  8024a1:	ff 75 08             	pushl  0x8(%ebp)
  8024a4:	6a 29                	push   $0x29
  8024a6:	e8 fc fa ff ff       	call   801fa7 <syscall>
  8024ab:	83 c4 18             	add    $0x18,%esp
	return ;
  8024ae:	90                   	nop
}
  8024af:	c9                   	leave  
  8024b0:	c3                   	ret    

008024b1 <inctst>:

void inctst()
{
  8024b1:	55                   	push   %ebp
  8024b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8024b4:	6a 00                	push   $0x0
  8024b6:	6a 00                	push   $0x0
  8024b8:	6a 00                	push   $0x0
  8024ba:	6a 00                	push   $0x0
  8024bc:	6a 00                	push   $0x0
  8024be:	6a 2a                	push   $0x2a
  8024c0:	e8 e2 fa ff ff       	call   801fa7 <syscall>
  8024c5:	83 c4 18             	add    $0x18,%esp
	return ;
  8024c8:	90                   	nop
}
  8024c9:	c9                   	leave  
  8024ca:	c3                   	ret    

008024cb <gettst>:
uint32 gettst()
{
  8024cb:	55                   	push   %ebp
  8024cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8024ce:	6a 00                	push   $0x0
  8024d0:	6a 00                	push   $0x0
  8024d2:	6a 00                	push   $0x0
  8024d4:	6a 00                	push   $0x0
  8024d6:	6a 00                	push   $0x0
  8024d8:	6a 2b                	push   $0x2b
  8024da:	e8 c8 fa ff ff       	call   801fa7 <syscall>
  8024df:	83 c4 18             	add    $0x18,%esp
}
  8024e2:	c9                   	leave  
  8024e3:	c3                   	ret    

008024e4 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8024e4:	55                   	push   %ebp
  8024e5:	89 e5                	mov    %esp,%ebp
  8024e7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024ea:	6a 00                	push   $0x0
  8024ec:	6a 00                	push   $0x0
  8024ee:	6a 00                	push   $0x0
  8024f0:	6a 00                	push   $0x0
  8024f2:	6a 00                	push   $0x0
  8024f4:	6a 2c                	push   $0x2c
  8024f6:	e8 ac fa ff ff       	call   801fa7 <syscall>
  8024fb:	83 c4 18             	add    $0x18,%esp
  8024fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802501:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802505:	75 07                	jne    80250e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802507:	b8 01 00 00 00       	mov    $0x1,%eax
  80250c:	eb 05                	jmp    802513 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80250e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802513:	c9                   	leave  
  802514:	c3                   	ret    

00802515 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802515:	55                   	push   %ebp
  802516:	89 e5                	mov    %esp,%ebp
  802518:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80251b:	6a 00                	push   $0x0
  80251d:	6a 00                	push   $0x0
  80251f:	6a 00                	push   $0x0
  802521:	6a 00                	push   $0x0
  802523:	6a 00                	push   $0x0
  802525:	6a 2c                	push   $0x2c
  802527:	e8 7b fa ff ff       	call   801fa7 <syscall>
  80252c:	83 c4 18             	add    $0x18,%esp
  80252f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802532:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802536:	75 07                	jne    80253f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802538:	b8 01 00 00 00       	mov    $0x1,%eax
  80253d:	eb 05                	jmp    802544 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80253f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802544:	c9                   	leave  
  802545:	c3                   	ret    

00802546 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802546:	55                   	push   %ebp
  802547:	89 e5                	mov    %esp,%ebp
  802549:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80254c:	6a 00                	push   $0x0
  80254e:	6a 00                	push   $0x0
  802550:	6a 00                	push   $0x0
  802552:	6a 00                	push   $0x0
  802554:	6a 00                	push   $0x0
  802556:	6a 2c                	push   $0x2c
  802558:	e8 4a fa ff ff       	call   801fa7 <syscall>
  80255d:	83 c4 18             	add    $0x18,%esp
  802560:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802563:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802567:	75 07                	jne    802570 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802569:	b8 01 00 00 00       	mov    $0x1,%eax
  80256e:	eb 05                	jmp    802575 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802570:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802575:	c9                   	leave  
  802576:	c3                   	ret    

00802577 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802577:	55                   	push   %ebp
  802578:	89 e5                	mov    %esp,%ebp
  80257a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80257d:	6a 00                	push   $0x0
  80257f:	6a 00                	push   $0x0
  802581:	6a 00                	push   $0x0
  802583:	6a 00                	push   $0x0
  802585:	6a 00                	push   $0x0
  802587:	6a 2c                	push   $0x2c
  802589:	e8 19 fa ff ff       	call   801fa7 <syscall>
  80258e:	83 c4 18             	add    $0x18,%esp
  802591:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802594:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802598:	75 07                	jne    8025a1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80259a:	b8 01 00 00 00       	mov    $0x1,%eax
  80259f:	eb 05                	jmp    8025a6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8025a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025a6:	c9                   	leave  
  8025a7:	c3                   	ret    

008025a8 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8025a8:	55                   	push   %ebp
  8025a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8025ab:	6a 00                	push   $0x0
  8025ad:	6a 00                	push   $0x0
  8025af:	6a 00                	push   $0x0
  8025b1:	6a 00                	push   $0x0
  8025b3:	ff 75 08             	pushl  0x8(%ebp)
  8025b6:	6a 2d                	push   $0x2d
  8025b8:	e8 ea f9 ff ff       	call   801fa7 <syscall>
  8025bd:	83 c4 18             	add    $0x18,%esp
	return ;
  8025c0:	90                   	nop
}
  8025c1:	c9                   	leave  
  8025c2:	c3                   	ret    

008025c3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8025c3:	55                   	push   %ebp
  8025c4:	89 e5                	mov    %esp,%ebp
  8025c6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8025c7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8025ca:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8025cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d3:	6a 00                	push   $0x0
  8025d5:	53                   	push   %ebx
  8025d6:	51                   	push   %ecx
  8025d7:	52                   	push   %edx
  8025d8:	50                   	push   %eax
  8025d9:	6a 2e                	push   $0x2e
  8025db:	e8 c7 f9 ff ff       	call   801fa7 <syscall>
  8025e0:	83 c4 18             	add    $0x18,%esp
}
  8025e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8025e6:	c9                   	leave  
  8025e7:	c3                   	ret    

008025e8 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8025e8:	55                   	push   %ebp
  8025e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8025eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f1:	6a 00                	push   $0x0
  8025f3:	6a 00                	push   $0x0
  8025f5:	6a 00                	push   $0x0
  8025f7:	52                   	push   %edx
  8025f8:	50                   	push   %eax
  8025f9:	6a 2f                	push   $0x2f
  8025fb:	e8 a7 f9 ff ff       	call   801fa7 <syscall>
  802600:	83 c4 18             	add    $0x18,%esp
}
  802603:	c9                   	leave  
  802604:	c3                   	ret    

00802605 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802605:	55                   	push   %ebp
  802606:	89 e5                	mov    %esp,%ebp
  802608:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80260b:	83 ec 0c             	sub    $0xc,%esp
  80260e:	68 a0 41 80 00       	push   $0x8041a0
  802613:	e8 c3 e6 ff ff       	call   800cdb <cprintf>
  802618:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80261b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802622:	83 ec 0c             	sub    $0xc,%esp
  802625:	68 cc 41 80 00       	push   $0x8041cc
  80262a:	e8 ac e6 ff ff       	call   800cdb <cprintf>
  80262f:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802632:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802636:	a1 38 51 80 00       	mov    0x805138,%eax
  80263b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80263e:	eb 56                	jmp    802696 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802640:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802644:	74 1c                	je     802662 <print_mem_block_lists+0x5d>
  802646:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802649:	8b 50 08             	mov    0x8(%eax),%edx
  80264c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80264f:	8b 48 08             	mov    0x8(%eax),%ecx
  802652:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802655:	8b 40 0c             	mov    0xc(%eax),%eax
  802658:	01 c8                	add    %ecx,%eax
  80265a:	39 c2                	cmp    %eax,%edx
  80265c:	73 04                	jae    802662 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80265e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802662:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802665:	8b 50 08             	mov    0x8(%eax),%edx
  802668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266b:	8b 40 0c             	mov    0xc(%eax),%eax
  80266e:	01 c2                	add    %eax,%edx
  802670:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802673:	8b 40 08             	mov    0x8(%eax),%eax
  802676:	83 ec 04             	sub    $0x4,%esp
  802679:	52                   	push   %edx
  80267a:	50                   	push   %eax
  80267b:	68 e1 41 80 00       	push   $0x8041e1
  802680:	e8 56 e6 ff ff       	call   800cdb <cprintf>
  802685:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802688:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80268e:	a1 40 51 80 00       	mov    0x805140,%eax
  802693:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802696:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80269a:	74 07                	je     8026a3 <print_mem_block_lists+0x9e>
  80269c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269f:	8b 00                	mov    (%eax),%eax
  8026a1:	eb 05                	jmp    8026a8 <print_mem_block_lists+0xa3>
  8026a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a8:	a3 40 51 80 00       	mov    %eax,0x805140
  8026ad:	a1 40 51 80 00       	mov    0x805140,%eax
  8026b2:	85 c0                	test   %eax,%eax
  8026b4:	75 8a                	jne    802640 <print_mem_block_lists+0x3b>
  8026b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ba:	75 84                	jne    802640 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8026bc:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8026c0:	75 10                	jne    8026d2 <print_mem_block_lists+0xcd>
  8026c2:	83 ec 0c             	sub    $0xc,%esp
  8026c5:	68 f0 41 80 00       	push   $0x8041f0
  8026ca:	e8 0c e6 ff ff       	call   800cdb <cprintf>
  8026cf:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8026d2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8026d9:	83 ec 0c             	sub    $0xc,%esp
  8026dc:	68 14 42 80 00       	push   $0x804214
  8026e1:	e8 f5 e5 ff ff       	call   800cdb <cprintf>
  8026e6:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8026e9:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8026ed:	a1 40 50 80 00       	mov    0x805040,%eax
  8026f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026f5:	eb 56                	jmp    80274d <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8026f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026fb:	74 1c                	je     802719 <print_mem_block_lists+0x114>
  8026fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802700:	8b 50 08             	mov    0x8(%eax),%edx
  802703:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802706:	8b 48 08             	mov    0x8(%eax),%ecx
  802709:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270c:	8b 40 0c             	mov    0xc(%eax),%eax
  80270f:	01 c8                	add    %ecx,%eax
  802711:	39 c2                	cmp    %eax,%edx
  802713:	73 04                	jae    802719 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802715:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271c:	8b 50 08             	mov    0x8(%eax),%edx
  80271f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802722:	8b 40 0c             	mov    0xc(%eax),%eax
  802725:	01 c2                	add    %eax,%edx
  802727:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272a:	8b 40 08             	mov    0x8(%eax),%eax
  80272d:	83 ec 04             	sub    $0x4,%esp
  802730:	52                   	push   %edx
  802731:	50                   	push   %eax
  802732:	68 e1 41 80 00       	push   $0x8041e1
  802737:	e8 9f e5 ff ff       	call   800cdb <cprintf>
  80273c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80273f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802742:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802745:	a1 48 50 80 00       	mov    0x805048,%eax
  80274a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80274d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802751:	74 07                	je     80275a <print_mem_block_lists+0x155>
  802753:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802756:	8b 00                	mov    (%eax),%eax
  802758:	eb 05                	jmp    80275f <print_mem_block_lists+0x15a>
  80275a:	b8 00 00 00 00       	mov    $0x0,%eax
  80275f:	a3 48 50 80 00       	mov    %eax,0x805048
  802764:	a1 48 50 80 00       	mov    0x805048,%eax
  802769:	85 c0                	test   %eax,%eax
  80276b:	75 8a                	jne    8026f7 <print_mem_block_lists+0xf2>
  80276d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802771:	75 84                	jne    8026f7 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802773:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802777:	75 10                	jne    802789 <print_mem_block_lists+0x184>
  802779:	83 ec 0c             	sub    $0xc,%esp
  80277c:	68 2c 42 80 00       	push   $0x80422c
  802781:	e8 55 e5 ff ff       	call   800cdb <cprintf>
  802786:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802789:	83 ec 0c             	sub    $0xc,%esp
  80278c:	68 a0 41 80 00       	push   $0x8041a0
  802791:	e8 45 e5 ff ff       	call   800cdb <cprintf>
  802796:	83 c4 10             	add    $0x10,%esp

}
  802799:	90                   	nop
  80279a:	c9                   	leave  
  80279b:	c3                   	ret    

0080279c <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80279c:	55                   	push   %ebp
  80279d:	89 e5                	mov    %esp,%ebp
  80279f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  8027a2:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8027a9:	00 00 00 
  8027ac:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8027b3:	00 00 00 
  8027b6:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8027bd:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  8027c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8027c7:	e9 9e 00 00 00       	jmp    80286a <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  8027cc:	a1 50 50 80 00       	mov    0x805050,%eax
  8027d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027d4:	c1 e2 04             	shl    $0x4,%edx
  8027d7:	01 d0                	add    %edx,%eax
  8027d9:	85 c0                	test   %eax,%eax
  8027db:	75 14                	jne    8027f1 <initialize_MemBlocksList+0x55>
  8027dd:	83 ec 04             	sub    $0x4,%esp
  8027e0:	68 54 42 80 00       	push   $0x804254
  8027e5:	6a 47                	push   $0x47
  8027e7:	68 77 42 80 00       	push   $0x804277
  8027ec:	e8 36 e2 ff ff       	call   800a27 <_panic>
  8027f1:	a1 50 50 80 00       	mov    0x805050,%eax
  8027f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027f9:	c1 e2 04             	shl    $0x4,%edx
  8027fc:	01 d0                	add    %edx,%eax
  8027fe:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802804:	89 10                	mov    %edx,(%eax)
  802806:	8b 00                	mov    (%eax),%eax
  802808:	85 c0                	test   %eax,%eax
  80280a:	74 18                	je     802824 <initialize_MemBlocksList+0x88>
  80280c:	a1 48 51 80 00       	mov    0x805148,%eax
  802811:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802817:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80281a:	c1 e1 04             	shl    $0x4,%ecx
  80281d:	01 ca                	add    %ecx,%edx
  80281f:	89 50 04             	mov    %edx,0x4(%eax)
  802822:	eb 12                	jmp    802836 <initialize_MemBlocksList+0x9a>
  802824:	a1 50 50 80 00       	mov    0x805050,%eax
  802829:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80282c:	c1 e2 04             	shl    $0x4,%edx
  80282f:	01 d0                	add    %edx,%eax
  802831:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802836:	a1 50 50 80 00       	mov    0x805050,%eax
  80283b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80283e:	c1 e2 04             	shl    $0x4,%edx
  802841:	01 d0                	add    %edx,%eax
  802843:	a3 48 51 80 00       	mov    %eax,0x805148
  802848:	a1 50 50 80 00       	mov    0x805050,%eax
  80284d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802850:	c1 e2 04             	shl    $0x4,%edx
  802853:	01 d0                	add    %edx,%eax
  802855:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80285c:	a1 54 51 80 00       	mov    0x805154,%eax
  802861:	40                   	inc    %eax
  802862:	a3 54 51 80 00       	mov    %eax,0x805154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802867:	ff 45 f4             	incl   -0xc(%ebp)
  80286a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802870:	0f 82 56 ff ff ff    	jb     8027cc <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  802876:	90                   	nop
  802877:	c9                   	leave  
  802878:	c3                   	ret    

00802879 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802879:	55                   	push   %ebp
  80287a:	89 e5                	mov    %esp,%ebp
  80287c:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  80287f:	8b 45 08             	mov    0x8(%ebp),%eax
  802882:	8b 00                	mov    (%eax),%eax
  802884:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802887:	eb 19                	jmp    8028a2 <find_block+0x29>
	{
		if(element->sva == va){
  802889:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80288c:	8b 40 08             	mov    0x8(%eax),%eax
  80288f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802892:	75 05                	jne    802899 <find_block+0x20>
			 		return element;
  802894:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802897:	eb 36                	jmp    8028cf <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802899:	8b 45 08             	mov    0x8(%ebp),%eax
  80289c:	8b 40 08             	mov    0x8(%eax),%eax
  80289f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8028a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8028a6:	74 07                	je     8028af <find_block+0x36>
  8028a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8028ab:	8b 00                	mov    (%eax),%eax
  8028ad:	eb 05                	jmp    8028b4 <find_block+0x3b>
  8028af:	b8 00 00 00 00       	mov    $0x0,%eax
  8028b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8028b7:	89 42 08             	mov    %eax,0x8(%edx)
  8028ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bd:	8b 40 08             	mov    0x8(%eax),%eax
  8028c0:	85 c0                	test   %eax,%eax
  8028c2:	75 c5                	jne    802889 <find_block+0x10>
  8028c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8028c8:	75 bf                	jne    802889 <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  8028ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028cf:	c9                   	leave  
  8028d0:	c3                   	ret    

008028d1 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8028d1:	55                   	push   %ebp
  8028d2:	89 e5                	mov    %esp,%ebp
  8028d4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  8028d7:	a1 44 50 80 00       	mov    0x805044,%eax
  8028dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  8028df:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  8028e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028eb:	74 0a                	je     8028f7 <insert_sorted_allocList+0x26>
  8028ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f0:	8b 40 08             	mov    0x8(%eax),%eax
  8028f3:	85 c0                	test   %eax,%eax
  8028f5:	75 65                	jne    80295c <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8028f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028fb:	75 14                	jne    802911 <insert_sorted_allocList+0x40>
  8028fd:	83 ec 04             	sub    $0x4,%esp
  802900:	68 54 42 80 00       	push   $0x804254
  802905:	6a 6e                	push   $0x6e
  802907:	68 77 42 80 00       	push   $0x804277
  80290c:	e8 16 e1 ff ff       	call   800a27 <_panic>
  802911:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802917:	8b 45 08             	mov    0x8(%ebp),%eax
  80291a:	89 10                	mov    %edx,(%eax)
  80291c:	8b 45 08             	mov    0x8(%ebp),%eax
  80291f:	8b 00                	mov    (%eax),%eax
  802921:	85 c0                	test   %eax,%eax
  802923:	74 0d                	je     802932 <insert_sorted_allocList+0x61>
  802925:	a1 40 50 80 00       	mov    0x805040,%eax
  80292a:	8b 55 08             	mov    0x8(%ebp),%edx
  80292d:	89 50 04             	mov    %edx,0x4(%eax)
  802930:	eb 08                	jmp    80293a <insert_sorted_allocList+0x69>
  802932:	8b 45 08             	mov    0x8(%ebp),%eax
  802935:	a3 44 50 80 00       	mov    %eax,0x805044
  80293a:	8b 45 08             	mov    0x8(%ebp),%eax
  80293d:	a3 40 50 80 00       	mov    %eax,0x805040
  802942:	8b 45 08             	mov    0x8(%ebp),%eax
  802945:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80294c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802951:	40                   	inc    %eax
  802952:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802957:	e9 cf 01 00 00       	jmp    802b2b <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  80295c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295f:	8b 50 08             	mov    0x8(%eax),%edx
  802962:	8b 45 08             	mov    0x8(%ebp),%eax
  802965:	8b 40 08             	mov    0x8(%eax),%eax
  802968:	39 c2                	cmp    %eax,%edx
  80296a:	73 65                	jae    8029d1 <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80296c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802970:	75 14                	jne    802986 <insert_sorted_allocList+0xb5>
  802972:	83 ec 04             	sub    $0x4,%esp
  802975:	68 90 42 80 00       	push   $0x804290
  80297a:	6a 72                	push   $0x72
  80297c:	68 77 42 80 00       	push   $0x804277
  802981:	e8 a1 e0 ff ff       	call   800a27 <_panic>
  802986:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80298c:	8b 45 08             	mov    0x8(%ebp),%eax
  80298f:	89 50 04             	mov    %edx,0x4(%eax)
  802992:	8b 45 08             	mov    0x8(%ebp),%eax
  802995:	8b 40 04             	mov    0x4(%eax),%eax
  802998:	85 c0                	test   %eax,%eax
  80299a:	74 0c                	je     8029a8 <insert_sorted_allocList+0xd7>
  80299c:	a1 44 50 80 00       	mov    0x805044,%eax
  8029a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8029a4:	89 10                	mov    %edx,(%eax)
  8029a6:	eb 08                	jmp    8029b0 <insert_sorted_allocList+0xdf>
  8029a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ab:	a3 40 50 80 00       	mov    %eax,0x805040
  8029b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b3:	a3 44 50 80 00       	mov    %eax,0x805044
  8029b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029c1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029c6:	40                   	inc    %eax
  8029c7:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  8029cc:	e9 5a 01 00 00       	jmp    802b2b <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  8029d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d4:	8b 50 08             	mov    0x8(%eax),%edx
  8029d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029da:	8b 40 08             	mov    0x8(%eax),%eax
  8029dd:	39 c2                	cmp    %eax,%edx
  8029df:	75 70                	jne    802a51 <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  8029e1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029e5:	74 06                	je     8029ed <insert_sorted_allocList+0x11c>
  8029e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029eb:	75 14                	jne    802a01 <insert_sorted_allocList+0x130>
  8029ed:	83 ec 04             	sub    $0x4,%esp
  8029f0:	68 b4 42 80 00       	push   $0x8042b4
  8029f5:	6a 75                	push   $0x75
  8029f7:	68 77 42 80 00       	push   $0x804277
  8029fc:	e8 26 e0 ff ff       	call   800a27 <_panic>
  802a01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a04:	8b 10                	mov    (%eax),%edx
  802a06:	8b 45 08             	mov    0x8(%ebp),%eax
  802a09:	89 10                	mov    %edx,(%eax)
  802a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0e:	8b 00                	mov    (%eax),%eax
  802a10:	85 c0                	test   %eax,%eax
  802a12:	74 0b                	je     802a1f <insert_sorted_allocList+0x14e>
  802a14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a17:	8b 00                	mov    (%eax),%eax
  802a19:	8b 55 08             	mov    0x8(%ebp),%edx
  802a1c:	89 50 04             	mov    %edx,0x4(%eax)
  802a1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a22:	8b 55 08             	mov    0x8(%ebp),%edx
  802a25:	89 10                	mov    %edx,(%eax)
  802a27:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a2d:	89 50 04             	mov    %edx,0x4(%eax)
  802a30:	8b 45 08             	mov    0x8(%ebp),%eax
  802a33:	8b 00                	mov    (%eax),%eax
  802a35:	85 c0                	test   %eax,%eax
  802a37:	75 08                	jne    802a41 <insert_sorted_allocList+0x170>
  802a39:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3c:	a3 44 50 80 00       	mov    %eax,0x805044
  802a41:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a46:	40                   	inc    %eax
  802a47:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  802a4c:	e9 da 00 00 00       	jmp    802b2b <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802a51:	a1 40 50 80 00       	mov    0x805040,%eax
  802a56:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a59:	e9 9d 00 00 00       	jmp    802afb <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  802a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a61:	8b 00                	mov    (%eax),%eax
  802a63:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  802a66:	8b 45 08             	mov    0x8(%ebp),%eax
  802a69:	8b 50 08             	mov    0x8(%eax),%edx
  802a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6f:	8b 40 08             	mov    0x8(%eax),%eax
  802a72:	39 c2                	cmp    %eax,%edx
  802a74:	76 7d                	jbe    802af3 <insert_sorted_allocList+0x222>
  802a76:	8b 45 08             	mov    0x8(%ebp),%eax
  802a79:	8b 50 08             	mov    0x8(%eax),%edx
  802a7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a7f:	8b 40 08             	mov    0x8(%eax),%eax
  802a82:	39 c2                	cmp    %eax,%edx
  802a84:	73 6d                	jae    802af3 <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802a86:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a8a:	74 06                	je     802a92 <insert_sorted_allocList+0x1c1>
  802a8c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a90:	75 14                	jne    802aa6 <insert_sorted_allocList+0x1d5>
  802a92:	83 ec 04             	sub    $0x4,%esp
  802a95:	68 b4 42 80 00       	push   $0x8042b4
  802a9a:	6a 7c                	push   $0x7c
  802a9c:	68 77 42 80 00       	push   $0x804277
  802aa1:	e8 81 df ff ff       	call   800a27 <_panic>
  802aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa9:	8b 10                	mov    (%eax),%edx
  802aab:	8b 45 08             	mov    0x8(%ebp),%eax
  802aae:	89 10                	mov    %edx,(%eax)
  802ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab3:	8b 00                	mov    (%eax),%eax
  802ab5:	85 c0                	test   %eax,%eax
  802ab7:	74 0b                	je     802ac4 <insert_sorted_allocList+0x1f3>
  802ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abc:	8b 00                	mov    (%eax),%eax
  802abe:	8b 55 08             	mov    0x8(%ebp),%edx
  802ac1:	89 50 04             	mov    %edx,0x4(%eax)
  802ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac7:	8b 55 08             	mov    0x8(%ebp),%edx
  802aca:	89 10                	mov    %edx,(%eax)
  802acc:	8b 45 08             	mov    0x8(%ebp),%eax
  802acf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ad2:	89 50 04             	mov    %edx,0x4(%eax)
  802ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad8:	8b 00                	mov    (%eax),%eax
  802ada:	85 c0                	test   %eax,%eax
  802adc:	75 08                	jne    802ae6 <insert_sorted_allocList+0x215>
  802ade:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae1:	a3 44 50 80 00       	mov    %eax,0x805044
  802ae6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802aeb:	40                   	inc    %eax
  802aec:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802af1:	eb 38                	jmp    802b2b <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802af3:	a1 48 50 80 00       	mov    0x805048,%eax
  802af8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802afb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aff:	74 07                	je     802b08 <insert_sorted_allocList+0x237>
  802b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b04:	8b 00                	mov    (%eax),%eax
  802b06:	eb 05                	jmp    802b0d <insert_sorted_allocList+0x23c>
  802b08:	b8 00 00 00 00       	mov    $0x0,%eax
  802b0d:	a3 48 50 80 00       	mov    %eax,0x805048
  802b12:	a1 48 50 80 00       	mov    0x805048,%eax
  802b17:	85 c0                	test   %eax,%eax
  802b19:	0f 85 3f ff ff ff    	jne    802a5e <insert_sorted_allocList+0x18d>
  802b1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b23:	0f 85 35 ff ff ff    	jne    802a5e <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  802b29:	eb 00                	jmp    802b2b <insert_sorted_allocList+0x25a>
  802b2b:	90                   	nop
  802b2c:	c9                   	leave  
  802b2d:	c3                   	ret    

00802b2e <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802b2e:	55                   	push   %ebp
  802b2f:	89 e5                	mov    %esp,%ebp
  802b31:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802b34:	a1 38 51 80 00       	mov    0x805138,%eax
  802b39:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b3c:	e9 6b 02 00 00       	jmp    802dac <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  802b41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b44:	8b 40 0c             	mov    0xc(%eax),%eax
  802b47:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b4a:	0f 85 90 00 00 00    	jne    802be0 <alloc_block_FF+0xb2>
			  temp=element;
  802b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b53:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  802b56:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b5a:	75 17                	jne    802b73 <alloc_block_FF+0x45>
  802b5c:	83 ec 04             	sub    $0x4,%esp
  802b5f:	68 e8 42 80 00       	push   $0x8042e8
  802b64:	68 92 00 00 00       	push   $0x92
  802b69:	68 77 42 80 00       	push   $0x804277
  802b6e:	e8 b4 de ff ff       	call   800a27 <_panic>
  802b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b76:	8b 00                	mov    (%eax),%eax
  802b78:	85 c0                	test   %eax,%eax
  802b7a:	74 10                	je     802b8c <alloc_block_FF+0x5e>
  802b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7f:	8b 00                	mov    (%eax),%eax
  802b81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b84:	8b 52 04             	mov    0x4(%edx),%edx
  802b87:	89 50 04             	mov    %edx,0x4(%eax)
  802b8a:	eb 0b                	jmp    802b97 <alloc_block_FF+0x69>
  802b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8f:	8b 40 04             	mov    0x4(%eax),%eax
  802b92:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9a:	8b 40 04             	mov    0x4(%eax),%eax
  802b9d:	85 c0                	test   %eax,%eax
  802b9f:	74 0f                	je     802bb0 <alloc_block_FF+0x82>
  802ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba4:	8b 40 04             	mov    0x4(%eax),%eax
  802ba7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802baa:	8b 12                	mov    (%edx),%edx
  802bac:	89 10                	mov    %edx,(%eax)
  802bae:	eb 0a                	jmp    802bba <alloc_block_FF+0x8c>
  802bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb3:	8b 00                	mov    (%eax),%eax
  802bb5:	a3 38 51 80 00       	mov    %eax,0x805138
  802bba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bcd:	a1 44 51 80 00       	mov    0x805144,%eax
  802bd2:	48                   	dec    %eax
  802bd3:	a3 44 51 80 00       	mov    %eax,0x805144
			  return temp;
  802bd8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bdb:	e9 ff 01 00 00       	jmp    802ddf <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  802be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be3:	8b 40 0c             	mov    0xc(%eax),%eax
  802be6:	3b 45 08             	cmp    0x8(%ebp),%eax
  802be9:	0f 86 b5 01 00 00    	jbe    802da4 <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  802bef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf2:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf5:	2b 45 08             	sub    0x8(%ebp),%eax
  802bf8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  802bfb:	a1 48 51 80 00       	mov    0x805148,%eax
  802c00:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  802c03:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c07:	75 17                	jne    802c20 <alloc_block_FF+0xf2>
  802c09:	83 ec 04             	sub    $0x4,%esp
  802c0c:	68 e8 42 80 00       	push   $0x8042e8
  802c11:	68 99 00 00 00       	push   $0x99
  802c16:	68 77 42 80 00       	push   $0x804277
  802c1b:	e8 07 de ff ff       	call   800a27 <_panic>
  802c20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c23:	8b 00                	mov    (%eax),%eax
  802c25:	85 c0                	test   %eax,%eax
  802c27:	74 10                	je     802c39 <alloc_block_FF+0x10b>
  802c29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c2c:	8b 00                	mov    (%eax),%eax
  802c2e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c31:	8b 52 04             	mov    0x4(%edx),%edx
  802c34:	89 50 04             	mov    %edx,0x4(%eax)
  802c37:	eb 0b                	jmp    802c44 <alloc_block_FF+0x116>
  802c39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c3c:	8b 40 04             	mov    0x4(%eax),%eax
  802c3f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c47:	8b 40 04             	mov    0x4(%eax),%eax
  802c4a:	85 c0                	test   %eax,%eax
  802c4c:	74 0f                	je     802c5d <alloc_block_FF+0x12f>
  802c4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c51:	8b 40 04             	mov    0x4(%eax),%eax
  802c54:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c57:	8b 12                	mov    (%edx),%edx
  802c59:	89 10                	mov    %edx,(%eax)
  802c5b:	eb 0a                	jmp    802c67 <alloc_block_FF+0x139>
  802c5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c60:	8b 00                	mov    (%eax),%eax
  802c62:	a3 48 51 80 00       	mov    %eax,0x805148
  802c67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c6a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c73:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c7a:	a1 54 51 80 00       	mov    0x805154,%eax
  802c7f:	48                   	dec    %eax
  802c80:	a3 54 51 80 00       	mov    %eax,0x805154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  802c85:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c89:	75 17                	jne    802ca2 <alloc_block_FF+0x174>
  802c8b:	83 ec 04             	sub    $0x4,%esp
  802c8e:	68 90 42 80 00       	push   $0x804290
  802c93:	68 9a 00 00 00       	push   $0x9a
  802c98:	68 77 42 80 00       	push   $0x804277
  802c9d:	e8 85 dd ff ff       	call   800a27 <_panic>
  802ca2:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802ca8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cab:	89 50 04             	mov    %edx,0x4(%eax)
  802cae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb1:	8b 40 04             	mov    0x4(%eax),%eax
  802cb4:	85 c0                	test   %eax,%eax
  802cb6:	74 0c                	je     802cc4 <alloc_block_FF+0x196>
  802cb8:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802cbd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cc0:	89 10                	mov    %edx,(%eax)
  802cc2:	eb 08                	jmp    802ccc <alloc_block_FF+0x19e>
  802cc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc7:	a3 38 51 80 00       	mov    %eax,0x805138
  802ccc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ccf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cdd:	a1 44 51 80 00       	mov    0x805144,%eax
  802ce2:	40                   	inc    %eax
  802ce3:	a3 44 51 80 00       	mov    %eax,0x805144
		  // setting the size & sva
		  new_block->size=size;
  802ce8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ceb:	8b 55 08             	mov    0x8(%ebp),%edx
  802cee:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  802cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf4:	8b 50 08             	mov    0x8(%eax),%edx
  802cf7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cfa:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  802cfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d00:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d03:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  802d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d09:	8b 50 08             	mov    0x8(%eax),%edx
  802d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0f:	01 c2                	add    %eax,%edx
  802d11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d14:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  802d17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d1a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  802d1d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d21:	75 17                	jne    802d3a <alloc_block_FF+0x20c>
  802d23:	83 ec 04             	sub    $0x4,%esp
  802d26:	68 e8 42 80 00       	push   $0x8042e8
  802d2b:	68 a2 00 00 00       	push   $0xa2
  802d30:	68 77 42 80 00       	push   $0x804277
  802d35:	e8 ed dc ff ff       	call   800a27 <_panic>
  802d3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d3d:	8b 00                	mov    (%eax),%eax
  802d3f:	85 c0                	test   %eax,%eax
  802d41:	74 10                	je     802d53 <alloc_block_FF+0x225>
  802d43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d46:	8b 00                	mov    (%eax),%eax
  802d48:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d4b:	8b 52 04             	mov    0x4(%edx),%edx
  802d4e:	89 50 04             	mov    %edx,0x4(%eax)
  802d51:	eb 0b                	jmp    802d5e <alloc_block_FF+0x230>
  802d53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d56:	8b 40 04             	mov    0x4(%eax),%eax
  802d59:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d61:	8b 40 04             	mov    0x4(%eax),%eax
  802d64:	85 c0                	test   %eax,%eax
  802d66:	74 0f                	je     802d77 <alloc_block_FF+0x249>
  802d68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d6b:	8b 40 04             	mov    0x4(%eax),%eax
  802d6e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d71:	8b 12                	mov    (%edx),%edx
  802d73:	89 10                	mov    %edx,(%eax)
  802d75:	eb 0a                	jmp    802d81 <alloc_block_FF+0x253>
  802d77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d7a:	8b 00                	mov    (%eax),%eax
  802d7c:	a3 38 51 80 00       	mov    %eax,0x805138
  802d81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d84:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d8d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d94:	a1 44 51 80 00       	mov    0x805144,%eax
  802d99:	48                   	dec    %eax
  802d9a:	a3 44 51 80 00       	mov    %eax,0x805144
		  return temp;
  802d9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802da2:	eb 3b                	jmp    802ddf <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802da4:	a1 40 51 80 00       	mov    0x805140,%eax
  802da9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802db0:	74 07                	je     802db9 <alloc_block_FF+0x28b>
  802db2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db5:	8b 00                	mov    (%eax),%eax
  802db7:	eb 05                	jmp    802dbe <alloc_block_FF+0x290>
  802db9:	b8 00 00 00 00       	mov    $0x0,%eax
  802dbe:	a3 40 51 80 00       	mov    %eax,0x805140
  802dc3:	a1 40 51 80 00       	mov    0x805140,%eax
  802dc8:	85 c0                	test   %eax,%eax
  802dca:	0f 85 71 fd ff ff    	jne    802b41 <alloc_block_FF+0x13>
  802dd0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dd4:	0f 85 67 fd ff ff    	jne    802b41 <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  802dda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ddf:	c9                   	leave  
  802de0:	c3                   	ret    

00802de1 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802de1:	55                   	push   %ebp
  802de2:	89 e5                	mov    %esp,%ebp
  802de4:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  802de7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  802dee:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802df5:	a1 38 51 80 00       	mov    0x805138,%eax
  802dfa:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802dfd:	e9 d3 00 00 00       	jmp    802ed5 <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  802e02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e05:	8b 40 0c             	mov    0xc(%eax),%eax
  802e08:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e0b:	0f 85 90 00 00 00    	jne    802ea1 <alloc_block_BF+0xc0>
	   temp = element;
  802e11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e14:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  802e17:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e1b:	75 17                	jne    802e34 <alloc_block_BF+0x53>
  802e1d:	83 ec 04             	sub    $0x4,%esp
  802e20:	68 e8 42 80 00       	push   $0x8042e8
  802e25:	68 bd 00 00 00       	push   $0xbd
  802e2a:	68 77 42 80 00       	push   $0x804277
  802e2f:	e8 f3 db ff ff       	call   800a27 <_panic>
  802e34:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e37:	8b 00                	mov    (%eax),%eax
  802e39:	85 c0                	test   %eax,%eax
  802e3b:	74 10                	je     802e4d <alloc_block_BF+0x6c>
  802e3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e40:	8b 00                	mov    (%eax),%eax
  802e42:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e45:	8b 52 04             	mov    0x4(%edx),%edx
  802e48:	89 50 04             	mov    %edx,0x4(%eax)
  802e4b:	eb 0b                	jmp    802e58 <alloc_block_BF+0x77>
  802e4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e50:	8b 40 04             	mov    0x4(%eax),%eax
  802e53:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e58:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e5b:	8b 40 04             	mov    0x4(%eax),%eax
  802e5e:	85 c0                	test   %eax,%eax
  802e60:	74 0f                	je     802e71 <alloc_block_BF+0x90>
  802e62:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e65:	8b 40 04             	mov    0x4(%eax),%eax
  802e68:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e6b:	8b 12                	mov    (%edx),%edx
  802e6d:	89 10                	mov    %edx,(%eax)
  802e6f:	eb 0a                	jmp    802e7b <alloc_block_BF+0x9a>
  802e71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e74:	8b 00                	mov    (%eax),%eax
  802e76:	a3 38 51 80 00       	mov    %eax,0x805138
  802e7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e7e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e84:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e87:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e8e:	a1 44 51 80 00       	mov    0x805144,%eax
  802e93:	48                   	dec    %eax
  802e94:	a3 44 51 80 00       	mov    %eax,0x805144
	   return temp;
  802e99:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e9c:	e9 41 01 00 00       	jmp    802fe2 <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  802ea1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ea4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802eaa:	76 21                	jbe    802ecd <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  802eac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eaf:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802eb5:	73 16                	jae    802ecd <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  802eb7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eba:	8b 40 0c             	mov    0xc(%eax),%eax
  802ebd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  802ec0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ec3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  802ec6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802ecd:	a1 40 51 80 00       	mov    0x805140,%eax
  802ed2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802ed5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ed9:	74 07                	je     802ee2 <alloc_block_BF+0x101>
  802edb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ede:	8b 00                	mov    (%eax),%eax
  802ee0:	eb 05                	jmp    802ee7 <alloc_block_BF+0x106>
  802ee2:	b8 00 00 00 00       	mov    $0x0,%eax
  802ee7:	a3 40 51 80 00       	mov    %eax,0x805140
  802eec:	a1 40 51 80 00       	mov    0x805140,%eax
  802ef1:	85 c0                	test   %eax,%eax
  802ef3:	0f 85 09 ff ff ff    	jne    802e02 <alloc_block_BF+0x21>
  802ef9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802efd:	0f 85 ff fe ff ff    	jne    802e02 <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  802f03:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  802f07:	0f 85 d0 00 00 00    	jne    802fdd <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  802f0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f10:	8b 40 0c             	mov    0xc(%eax),%eax
  802f13:	2b 45 08             	sub    0x8(%ebp),%eax
  802f16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  802f19:	a1 48 51 80 00       	mov    0x805148,%eax
  802f1e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  802f21:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f25:	75 17                	jne    802f3e <alloc_block_BF+0x15d>
  802f27:	83 ec 04             	sub    $0x4,%esp
  802f2a:	68 e8 42 80 00       	push   $0x8042e8
  802f2f:	68 d1 00 00 00       	push   $0xd1
  802f34:	68 77 42 80 00       	push   $0x804277
  802f39:	e8 e9 da ff ff       	call   800a27 <_panic>
  802f3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f41:	8b 00                	mov    (%eax),%eax
  802f43:	85 c0                	test   %eax,%eax
  802f45:	74 10                	je     802f57 <alloc_block_BF+0x176>
  802f47:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f4a:	8b 00                	mov    (%eax),%eax
  802f4c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f4f:	8b 52 04             	mov    0x4(%edx),%edx
  802f52:	89 50 04             	mov    %edx,0x4(%eax)
  802f55:	eb 0b                	jmp    802f62 <alloc_block_BF+0x181>
  802f57:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f5a:	8b 40 04             	mov    0x4(%eax),%eax
  802f5d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f62:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f65:	8b 40 04             	mov    0x4(%eax),%eax
  802f68:	85 c0                	test   %eax,%eax
  802f6a:	74 0f                	je     802f7b <alloc_block_BF+0x19a>
  802f6c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f6f:	8b 40 04             	mov    0x4(%eax),%eax
  802f72:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f75:	8b 12                	mov    (%edx),%edx
  802f77:	89 10                	mov    %edx,(%eax)
  802f79:	eb 0a                	jmp    802f85 <alloc_block_BF+0x1a4>
  802f7b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f7e:	8b 00                	mov    (%eax),%eax
  802f80:	a3 48 51 80 00       	mov    %eax,0x805148
  802f85:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f88:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f91:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f98:	a1 54 51 80 00       	mov    0x805154,%eax
  802f9d:	48                   	dec    %eax
  802f9e:	a3 54 51 80 00       	mov    %eax,0x805154
	  // setting the size & sva
	  new_block->size = size;
  802fa3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fa6:	8b 55 08             	mov    0x8(%ebp),%edx
  802fa9:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  802fac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802faf:	8b 50 08             	mov    0x8(%eax),%edx
  802fb2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fb5:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  802fb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fbb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802fbe:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  802fc1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fc4:	8b 50 08             	mov    0x8(%eax),%edx
  802fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fca:	01 c2                	add    %eax,%edx
  802fcc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fcf:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  802fd2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fd5:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  802fd8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fdb:	eb 05                	jmp    802fe2 <alloc_block_BF+0x201>
	 }
	 return NULL;
  802fdd:	b8 00 00 00 00       	mov    $0x0,%eax


}
  802fe2:	c9                   	leave  
  802fe3:	c3                   	ret    

00802fe4 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802fe4:	55                   	push   %ebp
  802fe5:	89 e5                	mov    %esp,%ebp
  802fe7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802fea:	83 ec 04             	sub    $0x4,%esp
  802fed:	68 08 43 80 00       	push   $0x804308
  802ff2:	68 e8 00 00 00       	push   $0xe8
  802ff7:	68 77 42 80 00       	push   $0x804277
  802ffc:	e8 26 da ff ff       	call   800a27 <_panic>

00803001 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803001:	55                   	push   %ebp
  803002:	89 e5                	mov    %esp,%ebp
  803004:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  803007:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80300c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  80300f:	a1 38 51 80 00       	mov    0x805138,%eax
  803014:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  803017:	a1 44 51 80 00       	mov    0x805144,%eax
  80301c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  80301f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803023:	75 68                	jne    80308d <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  803025:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803029:	75 17                	jne    803042 <insert_sorted_with_merge_freeList+0x41>
  80302b:	83 ec 04             	sub    $0x4,%esp
  80302e:	68 54 42 80 00       	push   $0x804254
  803033:	68 36 01 00 00       	push   $0x136
  803038:	68 77 42 80 00       	push   $0x804277
  80303d:	e8 e5 d9 ff ff       	call   800a27 <_panic>
  803042:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803048:	8b 45 08             	mov    0x8(%ebp),%eax
  80304b:	89 10                	mov    %edx,(%eax)
  80304d:	8b 45 08             	mov    0x8(%ebp),%eax
  803050:	8b 00                	mov    (%eax),%eax
  803052:	85 c0                	test   %eax,%eax
  803054:	74 0d                	je     803063 <insert_sorted_with_merge_freeList+0x62>
  803056:	a1 38 51 80 00       	mov    0x805138,%eax
  80305b:	8b 55 08             	mov    0x8(%ebp),%edx
  80305e:	89 50 04             	mov    %edx,0x4(%eax)
  803061:	eb 08                	jmp    80306b <insert_sorted_with_merge_freeList+0x6a>
  803063:	8b 45 08             	mov    0x8(%ebp),%eax
  803066:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80306b:	8b 45 08             	mov    0x8(%ebp),%eax
  80306e:	a3 38 51 80 00       	mov    %eax,0x805138
  803073:	8b 45 08             	mov    0x8(%ebp),%eax
  803076:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80307d:	a1 44 51 80 00       	mov    0x805144,%eax
  803082:	40                   	inc    %eax
  803083:	a3 44 51 80 00       	mov    %eax,0x805144





}
  803088:	e9 ba 06 00 00       	jmp    803747 <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  80308d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803090:	8b 50 08             	mov    0x8(%eax),%edx
  803093:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803096:	8b 40 0c             	mov    0xc(%eax),%eax
  803099:	01 c2                	add    %eax,%edx
  80309b:	8b 45 08             	mov    0x8(%ebp),%eax
  80309e:	8b 40 08             	mov    0x8(%eax),%eax
  8030a1:	39 c2                	cmp    %eax,%edx
  8030a3:	73 68                	jae    80310d <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8030a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030a9:	75 17                	jne    8030c2 <insert_sorted_with_merge_freeList+0xc1>
  8030ab:	83 ec 04             	sub    $0x4,%esp
  8030ae:	68 90 42 80 00       	push   $0x804290
  8030b3:	68 3a 01 00 00       	push   $0x13a
  8030b8:	68 77 42 80 00       	push   $0x804277
  8030bd:	e8 65 d9 ff ff       	call   800a27 <_panic>
  8030c2:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8030c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cb:	89 50 04             	mov    %edx,0x4(%eax)
  8030ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d1:	8b 40 04             	mov    0x4(%eax),%eax
  8030d4:	85 c0                	test   %eax,%eax
  8030d6:	74 0c                	je     8030e4 <insert_sorted_with_merge_freeList+0xe3>
  8030d8:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8030dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8030e0:	89 10                	mov    %edx,(%eax)
  8030e2:	eb 08                	jmp    8030ec <insert_sorted_with_merge_freeList+0xeb>
  8030e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e7:	a3 38 51 80 00       	mov    %eax,0x805138
  8030ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ef:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030fd:	a1 44 51 80 00       	mov    0x805144,%eax
  803102:	40                   	inc    %eax
  803103:	a3 44 51 80 00       	mov    %eax,0x805144





}
  803108:	e9 3a 06 00 00       	jmp    803747 <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  80310d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803110:	8b 50 08             	mov    0x8(%eax),%edx
  803113:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803116:	8b 40 0c             	mov    0xc(%eax),%eax
  803119:	01 c2                	add    %eax,%edx
  80311b:	8b 45 08             	mov    0x8(%ebp),%eax
  80311e:	8b 40 08             	mov    0x8(%eax),%eax
  803121:	39 c2                	cmp    %eax,%edx
  803123:	0f 85 90 00 00 00    	jne    8031b9 <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  803129:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80312c:	8b 50 0c             	mov    0xc(%eax),%edx
  80312f:	8b 45 08             	mov    0x8(%ebp),%eax
  803132:	8b 40 0c             	mov    0xc(%eax),%eax
  803135:	01 c2                	add    %eax,%edx
  803137:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80313a:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  80313d:	8b 45 08             	mov    0x8(%ebp),%eax
  803140:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  803147:	8b 45 08             	mov    0x8(%ebp),%eax
  80314a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803151:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803155:	75 17                	jne    80316e <insert_sorted_with_merge_freeList+0x16d>
  803157:	83 ec 04             	sub    $0x4,%esp
  80315a:	68 54 42 80 00       	push   $0x804254
  80315f:	68 41 01 00 00       	push   $0x141
  803164:	68 77 42 80 00       	push   $0x804277
  803169:	e8 b9 d8 ff ff       	call   800a27 <_panic>
  80316e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803174:	8b 45 08             	mov    0x8(%ebp),%eax
  803177:	89 10                	mov    %edx,(%eax)
  803179:	8b 45 08             	mov    0x8(%ebp),%eax
  80317c:	8b 00                	mov    (%eax),%eax
  80317e:	85 c0                	test   %eax,%eax
  803180:	74 0d                	je     80318f <insert_sorted_with_merge_freeList+0x18e>
  803182:	a1 48 51 80 00       	mov    0x805148,%eax
  803187:	8b 55 08             	mov    0x8(%ebp),%edx
  80318a:	89 50 04             	mov    %edx,0x4(%eax)
  80318d:	eb 08                	jmp    803197 <insert_sorted_with_merge_freeList+0x196>
  80318f:	8b 45 08             	mov    0x8(%ebp),%eax
  803192:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803197:	8b 45 08             	mov    0x8(%ebp),%eax
  80319a:	a3 48 51 80 00       	mov    %eax,0x805148
  80319f:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031a9:	a1 54 51 80 00       	mov    0x805154,%eax
  8031ae:	40                   	inc    %eax
  8031af:	a3 54 51 80 00       	mov    %eax,0x805154





}
  8031b4:	e9 8e 05 00 00       	jmp    803747 <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  8031b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bc:	8b 50 08             	mov    0x8(%eax),%edx
  8031bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8031c5:	01 c2                	add    %eax,%edx
  8031c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031ca:	8b 40 08             	mov    0x8(%eax),%eax
  8031cd:	39 c2                	cmp    %eax,%edx
  8031cf:	73 68                	jae    803239 <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8031d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031d5:	75 17                	jne    8031ee <insert_sorted_with_merge_freeList+0x1ed>
  8031d7:	83 ec 04             	sub    $0x4,%esp
  8031da:	68 54 42 80 00       	push   $0x804254
  8031df:	68 45 01 00 00       	push   $0x145
  8031e4:	68 77 42 80 00       	push   $0x804277
  8031e9:	e8 39 d8 ff ff       	call   800a27 <_panic>
  8031ee:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8031f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f7:	89 10                	mov    %edx,(%eax)
  8031f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fc:	8b 00                	mov    (%eax),%eax
  8031fe:	85 c0                	test   %eax,%eax
  803200:	74 0d                	je     80320f <insert_sorted_with_merge_freeList+0x20e>
  803202:	a1 38 51 80 00       	mov    0x805138,%eax
  803207:	8b 55 08             	mov    0x8(%ebp),%edx
  80320a:	89 50 04             	mov    %edx,0x4(%eax)
  80320d:	eb 08                	jmp    803217 <insert_sorted_with_merge_freeList+0x216>
  80320f:	8b 45 08             	mov    0x8(%ebp),%eax
  803212:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803217:	8b 45 08             	mov    0x8(%ebp),%eax
  80321a:	a3 38 51 80 00       	mov    %eax,0x805138
  80321f:	8b 45 08             	mov    0x8(%ebp),%eax
  803222:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803229:	a1 44 51 80 00       	mov    0x805144,%eax
  80322e:	40                   	inc    %eax
  80322f:	a3 44 51 80 00       	mov    %eax,0x805144





}
  803234:	e9 0e 05 00 00       	jmp    803747 <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  803239:	8b 45 08             	mov    0x8(%ebp),%eax
  80323c:	8b 50 08             	mov    0x8(%eax),%edx
  80323f:	8b 45 08             	mov    0x8(%ebp),%eax
  803242:	8b 40 0c             	mov    0xc(%eax),%eax
  803245:	01 c2                	add    %eax,%edx
  803247:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80324a:	8b 40 08             	mov    0x8(%eax),%eax
  80324d:	39 c2                	cmp    %eax,%edx
  80324f:	0f 85 9c 00 00 00    	jne    8032f1 <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  803255:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803258:	8b 50 0c             	mov    0xc(%eax),%edx
  80325b:	8b 45 08             	mov    0x8(%ebp),%eax
  80325e:	8b 40 0c             	mov    0xc(%eax),%eax
  803261:	01 c2                	add    %eax,%edx
  803263:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803266:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  803269:	8b 45 08             	mov    0x8(%ebp),%eax
  80326c:	8b 50 08             	mov    0x8(%eax),%edx
  80326f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803272:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  803275:	8b 45 08             	mov    0x8(%ebp),%eax
  803278:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  80327f:	8b 45 08             	mov    0x8(%ebp),%eax
  803282:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803289:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80328d:	75 17                	jne    8032a6 <insert_sorted_with_merge_freeList+0x2a5>
  80328f:	83 ec 04             	sub    $0x4,%esp
  803292:	68 54 42 80 00       	push   $0x804254
  803297:	68 4d 01 00 00       	push   $0x14d
  80329c:	68 77 42 80 00       	push   $0x804277
  8032a1:	e8 81 d7 ff ff       	call   800a27 <_panic>
  8032a6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8032af:	89 10                	mov    %edx,(%eax)
  8032b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b4:	8b 00                	mov    (%eax),%eax
  8032b6:	85 c0                	test   %eax,%eax
  8032b8:	74 0d                	je     8032c7 <insert_sorted_with_merge_freeList+0x2c6>
  8032ba:	a1 48 51 80 00       	mov    0x805148,%eax
  8032bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8032c2:	89 50 04             	mov    %edx,0x4(%eax)
  8032c5:	eb 08                	jmp    8032cf <insert_sorted_with_merge_freeList+0x2ce>
  8032c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ca:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d2:	a3 48 51 80 00       	mov    %eax,0x805148
  8032d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032e1:	a1 54 51 80 00       	mov    0x805154,%eax
  8032e6:	40                   	inc    %eax
  8032e7:	a3 54 51 80 00       	mov    %eax,0x805154





}
  8032ec:	e9 56 04 00 00       	jmp    803747 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  8032f1:	a1 38 51 80 00       	mov    0x805138,%eax
  8032f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032f9:	e9 19 04 00 00       	jmp    803717 <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  8032fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803301:	8b 00                	mov    (%eax),%eax
  803303:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  803306:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803309:	8b 50 08             	mov    0x8(%eax),%edx
  80330c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330f:	8b 40 0c             	mov    0xc(%eax),%eax
  803312:	01 c2                	add    %eax,%edx
  803314:	8b 45 08             	mov    0x8(%ebp),%eax
  803317:	8b 40 08             	mov    0x8(%eax),%eax
  80331a:	39 c2                	cmp    %eax,%edx
  80331c:	0f 85 ad 01 00 00    	jne    8034cf <insert_sorted_with_merge_freeList+0x4ce>
  803322:	8b 45 08             	mov    0x8(%ebp),%eax
  803325:	8b 50 08             	mov    0x8(%eax),%edx
  803328:	8b 45 08             	mov    0x8(%ebp),%eax
  80332b:	8b 40 0c             	mov    0xc(%eax),%eax
  80332e:	01 c2                	add    %eax,%edx
  803330:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803333:	8b 40 08             	mov    0x8(%eax),%eax
  803336:	39 c2                	cmp    %eax,%edx
  803338:	0f 85 91 01 00 00    	jne    8034cf <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  80333e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803341:	8b 50 0c             	mov    0xc(%eax),%edx
  803344:	8b 45 08             	mov    0x8(%ebp),%eax
  803347:	8b 48 0c             	mov    0xc(%eax),%ecx
  80334a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80334d:	8b 40 0c             	mov    0xc(%eax),%eax
  803350:	01 c8                	add    %ecx,%eax
  803352:	01 c2                	add    %eax,%edx
  803354:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803357:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  80335a:	8b 45 08             	mov    0x8(%ebp),%eax
  80335d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  803364:	8b 45 08             	mov    0x8(%ebp),%eax
  803367:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  80336e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803371:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  803378:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80337b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  803382:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803386:	75 17                	jne    80339f <insert_sorted_with_merge_freeList+0x39e>
  803388:	83 ec 04             	sub    $0x4,%esp
  80338b:	68 e8 42 80 00       	push   $0x8042e8
  803390:	68 5b 01 00 00       	push   $0x15b
  803395:	68 77 42 80 00       	push   $0x804277
  80339a:	e8 88 d6 ff ff       	call   800a27 <_panic>
  80339f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033a2:	8b 00                	mov    (%eax),%eax
  8033a4:	85 c0                	test   %eax,%eax
  8033a6:	74 10                	je     8033b8 <insert_sorted_with_merge_freeList+0x3b7>
  8033a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033ab:	8b 00                	mov    (%eax),%eax
  8033ad:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033b0:	8b 52 04             	mov    0x4(%edx),%edx
  8033b3:	89 50 04             	mov    %edx,0x4(%eax)
  8033b6:	eb 0b                	jmp    8033c3 <insert_sorted_with_merge_freeList+0x3c2>
  8033b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033bb:	8b 40 04             	mov    0x4(%eax),%eax
  8033be:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033c6:	8b 40 04             	mov    0x4(%eax),%eax
  8033c9:	85 c0                	test   %eax,%eax
  8033cb:	74 0f                	je     8033dc <insert_sorted_with_merge_freeList+0x3db>
  8033cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033d0:	8b 40 04             	mov    0x4(%eax),%eax
  8033d3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033d6:	8b 12                	mov    (%edx),%edx
  8033d8:	89 10                	mov    %edx,(%eax)
  8033da:	eb 0a                	jmp    8033e6 <insert_sorted_with_merge_freeList+0x3e5>
  8033dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033df:	8b 00                	mov    (%eax),%eax
  8033e1:	a3 38 51 80 00       	mov    %eax,0x805138
  8033e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033f9:	a1 44 51 80 00       	mov    0x805144,%eax
  8033fe:	48                   	dec    %eax
  8033ff:	a3 44 51 80 00       	mov    %eax,0x805144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803404:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803408:	75 17                	jne    803421 <insert_sorted_with_merge_freeList+0x420>
  80340a:	83 ec 04             	sub    $0x4,%esp
  80340d:	68 54 42 80 00       	push   $0x804254
  803412:	68 5c 01 00 00       	push   $0x15c
  803417:	68 77 42 80 00       	push   $0x804277
  80341c:	e8 06 d6 ff ff       	call   800a27 <_panic>
  803421:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803427:	8b 45 08             	mov    0x8(%ebp),%eax
  80342a:	89 10                	mov    %edx,(%eax)
  80342c:	8b 45 08             	mov    0x8(%ebp),%eax
  80342f:	8b 00                	mov    (%eax),%eax
  803431:	85 c0                	test   %eax,%eax
  803433:	74 0d                	je     803442 <insert_sorted_with_merge_freeList+0x441>
  803435:	a1 48 51 80 00       	mov    0x805148,%eax
  80343a:	8b 55 08             	mov    0x8(%ebp),%edx
  80343d:	89 50 04             	mov    %edx,0x4(%eax)
  803440:	eb 08                	jmp    80344a <insert_sorted_with_merge_freeList+0x449>
  803442:	8b 45 08             	mov    0x8(%ebp),%eax
  803445:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80344a:	8b 45 08             	mov    0x8(%ebp),%eax
  80344d:	a3 48 51 80 00       	mov    %eax,0x805148
  803452:	8b 45 08             	mov    0x8(%ebp),%eax
  803455:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80345c:	a1 54 51 80 00       	mov    0x805154,%eax
  803461:	40                   	inc    %eax
  803462:	a3 54 51 80 00       	mov    %eax,0x805154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  803467:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80346b:	75 17                	jne    803484 <insert_sorted_with_merge_freeList+0x483>
  80346d:	83 ec 04             	sub    $0x4,%esp
  803470:	68 54 42 80 00       	push   $0x804254
  803475:	68 5d 01 00 00       	push   $0x15d
  80347a:	68 77 42 80 00       	push   $0x804277
  80347f:	e8 a3 d5 ff ff       	call   800a27 <_panic>
  803484:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80348a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80348d:	89 10                	mov    %edx,(%eax)
  80348f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803492:	8b 00                	mov    (%eax),%eax
  803494:	85 c0                	test   %eax,%eax
  803496:	74 0d                	je     8034a5 <insert_sorted_with_merge_freeList+0x4a4>
  803498:	a1 48 51 80 00       	mov    0x805148,%eax
  80349d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034a0:	89 50 04             	mov    %edx,0x4(%eax)
  8034a3:	eb 08                	jmp    8034ad <insert_sorted_with_merge_freeList+0x4ac>
  8034a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034a8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034b0:	a3 48 51 80 00       	mov    %eax,0x805148
  8034b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034b8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034bf:	a1 54 51 80 00       	mov    0x805154,%eax
  8034c4:	40                   	inc    %eax
  8034c5:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  8034ca:	e9 78 02 00 00       	jmp    803747 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  8034cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d2:	8b 50 08             	mov    0x8(%eax),%edx
  8034d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8034db:	01 c2                	add    %eax,%edx
  8034dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e0:	8b 40 08             	mov    0x8(%eax),%eax
  8034e3:	39 c2                	cmp    %eax,%edx
  8034e5:	0f 83 b8 00 00 00    	jae    8035a3 <insert_sorted_with_merge_freeList+0x5a2>
  8034eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ee:	8b 50 08             	mov    0x8(%eax),%edx
  8034f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8034f7:	01 c2                	add    %eax,%edx
  8034f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034fc:	8b 40 08             	mov    0x8(%eax),%eax
  8034ff:	39 c2                	cmp    %eax,%edx
  803501:	0f 85 9c 00 00 00    	jne    8035a3 <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  803507:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80350a:	8b 50 0c             	mov    0xc(%eax),%edx
  80350d:	8b 45 08             	mov    0x8(%ebp),%eax
  803510:	8b 40 0c             	mov    0xc(%eax),%eax
  803513:	01 c2                	add    %eax,%edx
  803515:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803518:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  80351b:	8b 45 08             	mov    0x8(%ebp),%eax
  80351e:	8b 50 08             	mov    0x8(%eax),%edx
  803521:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803524:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  803527:	8b 45 08             	mov    0x8(%ebp),%eax
  80352a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  803531:	8b 45 08             	mov    0x8(%ebp),%eax
  803534:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80353b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80353f:	75 17                	jne    803558 <insert_sorted_with_merge_freeList+0x557>
  803541:	83 ec 04             	sub    $0x4,%esp
  803544:	68 54 42 80 00       	push   $0x804254
  803549:	68 67 01 00 00       	push   $0x167
  80354e:	68 77 42 80 00       	push   $0x804277
  803553:	e8 cf d4 ff ff       	call   800a27 <_panic>
  803558:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80355e:	8b 45 08             	mov    0x8(%ebp),%eax
  803561:	89 10                	mov    %edx,(%eax)
  803563:	8b 45 08             	mov    0x8(%ebp),%eax
  803566:	8b 00                	mov    (%eax),%eax
  803568:	85 c0                	test   %eax,%eax
  80356a:	74 0d                	je     803579 <insert_sorted_with_merge_freeList+0x578>
  80356c:	a1 48 51 80 00       	mov    0x805148,%eax
  803571:	8b 55 08             	mov    0x8(%ebp),%edx
  803574:	89 50 04             	mov    %edx,0x4(%eax)
  803577:	eb 08                	jmp    803581 <insert_sorted_with_merge_freeList+0x580>
  803579:	8b 45 08             	mov    0x8(%ebp),%eax
  80357c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803581:	8b 45 08             	mov    0x8(%ebp),%eax
  803584:	a3 48 51 80 00       	mov    %eax,0x805148
  803589:	8b 45 08             	mov    0x8(%ebp),%eax
  80358c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803593:	a1 54 51 80 00       	mov    0x805154,%eax
  803598:	40                   	inc    %eax
  803599:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  80359e:	e9 a4 01 00 00       	jmp    803747 <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  8035a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a6:	8b 50 08             	mov    0x8(%eax),%edx
  8035a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8035af:	01 c2                	add    %eax,%edx
  8035b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b4:	8b 40 08             	mov    0x8(%eax),%eax
  8035b7:	39 c2                	cmp    %eax,%edx
  8035b9:	0f 85 ac 00 00 00    	jne    80366b <insert_sorted_with_merge_freeList+0x66a>
  8035bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c2:	8b 50 08             	mov    0x8(%eax),%edx
  8035c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8035cb:	01 c2                	add    %eax,%edx
  8035cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035d0:	8b 40 08             	mov    0x8(%eax),%eax
  8035d3:	39 c2                	cmp    %eax,%edx
  8035d5:	0f 83 90 00 00 00    	jae    80366b <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  8035db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035de:	8b 50 0c             	mov    0xc(%eax),%edx
  8035e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8035e7:	01 c2                	add    %eax,%edx
  8035e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ec:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  8035ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  8035f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803603:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803607:	75 17                	jne    803620 <insert_sorted_with_merge_freeList+0x61f>
  803609:	83 ec 04             	sub    $0x4,%esp
  80360c:	68 54 42 80 00       	push   $0x804254
  803611:	68 70 01 00 00       	push   $0x170
  803616:	68 77 42 80 00       	push   $0x804277
  80361b:	e8 07 d4 ff ff       	call   800a27 <_panic>
  803620:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803626:	8b 45 08             	mov    0x8(%ebp),%eax
  803629:	89 10                	mov    %edx,(%eax)
  80362b:	8b 45 08             	mov    0x8(%ebp),%eax
  80362e:	8b 00                	mov    (%eax),%eax
  803630:	85 c0                	test   %eax,%eax
  803632:	74 0d                	je     803641 <insert_sorted_with_merge_freeList+0x640>
  803634:	a1 48 51 80 00       	mov    0x805148,%eax
  803639:	8b 55 08             	mov    0x8(%ebp),%edx
  80363c:	89 50 04             	mov    %edx,0x4(%eax)
  80363f:	eb 08                	jmp    803649 <insert_sorted_with_merge_freeList+0x648>
  803641:	8b 45 08             	mov    0x8(%ebp),%eax
  803644:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803649:	8b 45 08             	mov    0x8(%ebp),%eax
  80364c:	a3 48 51 80 00       	mov    %eax,0x805148
  803651:	8b 45 08             	mov    0x8(%ebp),%eax
  803654:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80365b:	a1 54 51 80 00       	mov    0x805154,%eax
  803660:	40                   	inc    %eax
  803661:	a3 54 51 80 00       	mov    %eax,0x805154
	      break;
  803666:	e9 dc 00 00 00       	jmp    803747 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  80366b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80366e:	8b 50 08             	mov    0x8(%eax),%edx
  803671:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803674:	8b 40 0c             	mov    0xc(%eax),%eax
  803677:	01 c2                	add    %eax,%edx
  803679:	8b 45 08             	mov    0x8(%ebp),%eax
  80367c:	8b 40 08             	mov    0x8(%eax),%eax
  80367f:	39 c2                	cmp    %eax,%edx
  803681:	0f 83 88 00 00 00    	jae    80370f <insert_sorted_with_merge_freeList+0x70e>
  803687:	8b 45 08             	mov    0x8(%ebp),%eax
  80368a:	8b 50 08             	mov    0x8(%eax),%edx
  80368d:	8b 45 08             	mov    0x8(%ebp),%eax
  803690:	8b 40 0c             	mov    0xc(%eax),%eax
  803693:	01 c2                	add    %eax,%edx
  803695:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803698:	8b 40 08             	mov    0x8(%eax),%eax
  80369b:	39 c2                	cmp    %eax,%edx
  80369d:	73 70                	jae    80370f <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  80369f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036a3:	74 06                	je     8036ab <insert_sorted_with_merge_freeList+0x6aa>
  8036a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036a9:	75 17                	jne    8036c2 <insert_sorted_with_merge_freeList+0x6c1>
  8036ab:	83 ec 04             	sub    $0x4,%esp
  8036ae:	68 b4 42 80 00       	push   $0x8042b4
  8036b3:	68 75 01 00 00       	push   $0x175
  8036b8:	68 77 42 80 00       	push   $0x804277
  8036bd:	e8 65 d3 ff ff       	call   800a27 <_panic>
  8036c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c5:	8b 10                	mov    (%eax),%edx
  8036c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ca:	89 10                	mov    %edx,(%eax)
  8036cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8036cf:	8b 00                	mov    (%eax),%eax
  8036d1:	85 c0                	test   %eax,%eax
  8036d3:	74 0b                	je     8036e0 <insert_sorted_with_merge_freeList+0x6df>
  8036d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d8:	8b 00                	mov    (%eax),%eax
  8036da:	8b 55 08             	mov    0x8(%ebp),%edx
  8036dd:	89 50 04             	mov    %edx,0x4(%eax)
  8036e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8036e6:	89 10                	mov    %edx,(%eax)
  8036e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036ee:	89 50 04             	mov    %edx,0x4(%eax)
  8036f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f4:	8b 00                	mov    (%eax),%eax
  8036f6:	85 c0                	test   %eax,%eax
  8036f8:	75 08                	jne    803702 <insert_sorted_with_merge_freeList+0x701>
  8036fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8036fd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803702:	a1 44 51 80 00       	mov    0x805144,%eax
  803707:	40                   	inc    %eax
  803708:	a3 44 51 80 00       	mov    %eax,0x805144
	      break;
  80370d:	eb 38                	jmp    803747 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  80370f:	a1 40 51 80 00       	mov    0x805140,%eax
  803714:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803717:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80371b:	74 07                	je     803724 <insert_sorted_with_merge_freeList+0x723>
  80371d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803720:	8b 00                	mov    (%eax),%eax
  803722:	eb 05                	jmp    803729 <insert_sorted_with_merge_freeList+0x728>
  803724:	b8 00 00 00 00       	mov    $0x0,%eax
  803729:	a3 40 51 80 00       	mov    %eax,0x805140
  80372e:	a1 40 51 80 00       	mov    0x805140,%eax
  803733:	85 c0                	test   %eax,%eax
  803735:	0f 85 c3 fb ff ff    	jne    8032fe <insert_sorted_with_merge_freeList+0x2fd>
  80373b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80373f:	0f 85 b9 fb ff ff    	jne    8032fe <insert_sorted_with_merge_freeList+0x2fd>





}
  803745:	eb 00                	jmp    803747 <insert_sorted_with_merge_freeList+0x746>
  803747:	90                   	nop
  803748:	c9                   	leave  
  803749:	c3                   	ret    
  80374a:	66 90                	xchg   %ax,%ax

0080374c <__udivdi3>:
  80374c:	55                   	push   %ebp
  80374d:	57                   	push   %edi
  80374e:	56                   	push   %esi
  80374f:	53                   	push   %ebx
  803750:	83 ec 1c             	sub    $0x1c,%esp
  803753:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803757:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80375b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80375f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803763:	89 ca                	mov    %ecx,%edx
  803765:	89 f8                	mov    %edi,%eax
  803767:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80376b:	85 f6                	test   %esi,%esi
  80376d:	75 2d                	jne    80379c <__udivdi3+0x50>
  80376f:	39 cf                	cmp    %ecx,%edi
  803771:	77 65                	ja     8037d8 <__udivdi3+0x8c>
  803773:	89 fd                	mov    %edi,%ebp
  803775:	85 ff                	test   %edi,%edi
  803777:	75 0b                	jne    803784 <__udivdi3+0x38>
  803779:	b8 01 00 00 00       	mov    $0x1,%eax
  80377e:	31 d2                	xor    %edx,%edx
  803780:	f7 f7                	div    %edi
  803782:	89 c5                	mov    %eax,%ebp
  803784:	31 d2                	xor    %edx,%edx
  803786:	89 c8                	mov    %ecx,%eax
  803788:	f7 f5                	div    %ebp
  80378a:	89 c1                	mov    %eax,%ecx
  80378c:	89 d8                	mov    %ebx,%eax
  80378e:	f7 f5                	div    %ebp
  803790:	89 cf                	mov    %ecx,%edi
  803792:	89 fa                	mov    %edi,%edx
  803794:	83 c4 1c             	add    $0x1c,%esp
  803797:	5b                   	pop    %ebx
  803798:	5e                   	pop    %esi
  803799:	5f                   	pop    %edi
  80379a:	5d                   	pop    %ebp
  80379b:	c3                   	ret    
  80379c:	39 ce                	cmp    %ecx,%esi
  80379e:	77 28                	ja     8037c8 <__udivdi3+0x7c>
  8037a0:	0f bd fe             	bsr    %esi,%edi
  8037a3:	83 f7 1f             	xor    $0x1f,%edi
  8037a6:	75 40                	jne    8037e8 <__udivdi3+0x9c>
  8037a8:	39 ce                	cmp    %ecx,%esi
  8037aa:	72 0a                	jb     8037b6 <__udivdi3+0x6a>
  8037ac:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8037b0:	0f 87 9e 00 00 00    	ja     803854 <__udivdi3+0x108>
  8037b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8037bb:	89 fa                	mov    %edi,%edx
  8037bd:	83 c4 1c             	add    $0x1c,%esp
  8037c0:	5b                   	pop    %ebx
  8037c1:	5e                   	pop    %esi
  8037c2:	5f                   	pop    %edi
  8037c3:	5d                   	pop    %ebp
  8037c4:	c3                   	ret    
  8037c5:	8d 76 00             	lea    0x0(%esi),%esi
  8037c8:	31 ff                	xor    %edi,%edi
  8037ca:	31 c0                	xor    %eax,%eax
  8037cc:	89 fa                	mov    %edi,%edx
  8037ce:	83 c4 1c             	add    $0x1c,%esp
  8037d1:	5b                   	pop    %ebx
  8037d2:	5e                   	pop    %esi
  8037d3:	5f                   	pop    %edi
  8037d4:	5d                   	pop    %ebp
  8037d5:	c3                   	ret    
  8037d6:	66 90                	xchg   %ax,%ax
  8037d8:	89 d8                	mov    %ebx,%eax
  8037da:	f7 f7                	div    %edi
  8037dc:	31 ff                	xor    %edi,%edi
  8037de:	89 fa                	mov    %edi,%edx
  8037e0:	83 c4 1c             	add    $0x1c,%esp
  8037e3:	5b                   	pop    %ebx
  8037e4:	5e                   	pop    %esi
  8037e5:	5f                   	pop    %edi
  8037e6:	5d                   	pop    %ebp
  8037e7:	c3                   	ret    
  8037e8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8037ed:	89 eb                	mov    %ebp,%ebx
  8037ef:	29 fb                	sub    %edi,%ebx
  8037f1:	89 f9                	mov    %edi,%ecx
  8037f3:	d3 e6                	shl    %cl,%esi
  8037f5:	89 c5                	mov    %eax,%ebp
  8037f7:	88 d9                	mov    %bl,%cl
  8037f9:	d3 ed                	shr    %cl,%ebp
  8037fb:	89 e9                	mov    %ebp,%ecx
  8037fd:	09 f1                	or     %esi,%ecx
  8037ff:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803803:	89 f9                	mov    %edi,%ecx
  803805:	d3 e0                	shl    %cl,%eax
  803807:	89 c5                	mov    %eax,%ebp
  803809:	89 d6                	mov    %edx,%esi
  80380b:	88 d9                	mov    %bl,%cl
  80380d:	d3 ee                	shr    %cl,%esi
  80380f:	89 f9                	mov    %edi,%ecx
  803811:	d3 e2                	shl    %cl,%edx
  803813:	8b 44 24 08          	mov    0x8(%esp),%eax
  803817:	88 d9                	mov    %bl,%cl
  803819:	d3 e8                	shr    %cl,%eax
  80381b:	09 c2                	or     %eax,%edx
  80381d:	89 d0                	mov    %edx,%eax
  80381f:	89 f2                	mov    %esi,%edx
  803821:	f7 74 24 0c          	divl   0xc(%esp)
  803825:	89 d6                	mov    %edx,%esi
  803827:	89 c3                	mov    %eax,%ebx
  803829:	f7 e5                	mul    %ebp
  80382b:	39 d6                	cmp    %edx,%esi
  80382d:	72 19                	jb     803848 <__udivdi3+0xfc>
  80382f:	74 0b                	je     80383c <__udivdi3+0xf0>
  803831:	89 d8                	mov    %ebx,%eax
  803833:	31 ff                	xor    %edi,%edi
  803835:	e9 58 ff ff ff       	jmp    803792 <__udivdi3+0x46>
  80383a:	66 90                	xchg   %ax,%ax
  80383c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803840:	89 f9                	mov    %edi,%ecx
  803842:	d3 e2                	shl    %cl,%edx
  803844:	39 c2                	cmp    %eax,%edx
  803846:	73 e9                	jae    803831 <__udivdi3+0xe5>
  803848:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80384b:	31 ff                	xor    %edi,%edi
  80384d:	e9 40 ff ff ff       	jmp    803792 <__udivdi3+0x46>
  803852:	66 90                	xchg   %ax,%ax
  803854:	31 c0                	xor    %eax,%eax
  803856:	e9 37 ff ff ff       	jmp    803792 <__udivdi3+0x46>
  80385b:	90                   	nop

0080385c <__umoddi3>:
  80385c:	55                   	push   %ebp
  80385d:	57                   	push   %edi
  80385e:	56                   	push   %esi
  80385f:	53                   	push   %ebx
  803860:	83 ec 1c             	sub    $0x1c,%esp
  803863:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803867:	8b 74 24 34          	mov    0x34(%esp),%esi
  80386b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80386f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803873:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803877:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80387b:	89 f3                	mov    %esi,%ebx
  80387d:	89 fa                	mov    %edi,%edx
  80387f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803883:	89 34 24             	mov    %esi,(%esp)
  803886:	85 c0                	test   %eax,%eax
  803888:	75 1a                	jne    8038a4 <__umoddi3+0x48>
  80388a:	39 f7                	cmp    %esi,%edi
  80388c:	0f 86 a2 00 00 00    	jbe    803934 <__umoddi3+0xd8>
  803892:	89 c8                	mov    %ecx,%eax
  803894:	89 f2                	mov    %esi,%edx
  803896:	f7 f7                	div    %edi
  803898:	89 d0                	mov    %edx,%eax
  80389a:	31 d2                	xor    %edx,%edx
  80389c:	83 c4 1c             	add    $0x1c,%esp
  80389f:	5b                   	pop    %ebx
  8038a0:	5e                   	pop    %esi
  8038a1:	5f                   	pop    %edi
  8038a2:	5d                   	pop    %ebp
  8038a3:	c3                   	ret    
  8038a4:	39 f0                	cmp    %esi,%eax
  8038a6:	0f 87 ac 00 00 00    	ja     803958 <__umoddi3+0xfc>
  8038ac:	0f bd e8             	bsr    %eax,%ebp
  8038af:	83 f5 1f             	xor    $0x1f,%ebp
  8038b2:	0f 84 ac 00 00 00    	je     803964 <__umoddi3+0x108>
  8038b8:	bf 20 00 00 00       	mov    $0x20,%edi
  8038bd:	29 ef                	sub    %ebp,%edi
  8038bf:	89 fe                	mov    %edi,%esi
  8038c1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8038c5:	89 e9                	mov    %ebp,%ecx
  8038c7:	d3 e0                	shl    %cl,%eax
  8038c9:	89 d7                	mov    %edx,%edi
  8038cb:	89 f1                	mov    %esi,%ecx
  8038cd:	d3 ef                	shr    %cl,%edi
  8038cf:	09 c7                	or     %eax,%edi
  8038d1:	89 e9                	mov    %ebp,%ecx
  8038d3:	d3 e2                	shl    %cl,%edx
  8038d5:	89 14 24             	mov    %edx,(%esp)
  8038d8:	89 d8                	mov    %ebx,%eax
  8038da:	d3 e0                	shl    %cl,%eax
  8038dc:	89 c2                	mov    %eax,%edx
  8038de:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038e2:	d3 e0                	shl    %cl,%eax
  8038e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038e8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038ec:	89 f1                	mov    %esi,%ecx
  8038ee:	d3 e8                	shr    %cl,%eax
  8038f0:	09 d0                	or     %edx,%eax
  8038f2:	d3 eb                	shr    %cl,%ebx
  8038f4:	89 da                	mov    %ebx,%edx
  8038f6:	f7 f7                	div    %edi
  8038f8:	89 d3                	mov    %edx,%ebx
  8038fa:	f7 24 24             	mull   (%esp)
  8038fd:	89 c6                	mov    %eax,%esi
  8038ff:	89 d1                	mov    %edx,%ecx
  803901:	39 d3                	cmp    %edx,%ebx
  803903:	0f 82 87 00 00 00    	jb     803990 <__umoddi3+0x134>
  803909:	0f 84 91 00 00 00    	je     8039a0 <__umoddi3+0x144>
  80390f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803913:	29 f2                	sub    %esi,%edx
  803915:	19 cb                	sbb    %ecx,%ebx
  803917:	89 d8                	mov    %ebx,%eax
  803919:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80391d:	d3 e0                	shl    %cl,%eax
  80391f:	89 e9                	mov    %ebp,%ecx
  803921:	d3 ea                	shr    %cl,%edx
  803923:	09 d0                	or     %edx,%eax
  803925:	89 e9                	mov    %ebp,%ecx
  803927:	d3 eb                	shr    %cl,%ebx
  803929:	89 da                	mov    %ebx,%edx
  80392b:	83 c4 1c             	add    $0x1c,%esp
  80392e:	5b                   	pop    %ebx
  80392f:	5e                   	pop    %esi
  803930:	5f                   	pop    %edi
  803931:	5d                   	pop    %ebp
  803932:	c3                   	ret    
  803933:	90                   	nop
  803934:	89 fd                	mov    %edi,%ebp
  803936:	85 ff                	test   %edi,%edi
  803938:	75 0b                	jne    803945 <__umoddi3+0xe9>
  80393a:	b8 01 00 00 00       	mov    $0x1,%eax
  80393f:	31 d2                	xor    %edx,%edx
  803941:	f7 f7                	div    %edi
  803943:	89 c5                	mov    %eax,%ebp
  803945:	89 f0                	mov    %esi,%eax
  803947:	31 d2                	xor    %edx,%edx
  803949:	f7 f5                	div    %ebp
  80394b:	89 c8                	mov    %ecx,%eax
  80394d:	f7 f5                	div    %ebp
  80394f:	89 d0                	mov    %edx,%eax
  803951:	e9 44 ff ff ff       	jmp    80389a <__umoddi3+0x3e>
  803956:	66 90                	xchg   %ax,%ax
  803958:	89 c8                	mov    %ecx,%eax
  80395a:	89 f2                	mov    %esi,%edx
  80395c:	83 c4 1c             	add    $0x1c,%esp
  80395f:	5b                   	pop    %ebx
  803960:	5e                   	pop    %esi
  803961:	5f                   	pop    %edi
  803962:	5d                   	pop    %ebp
  803963:	c3                   	ret    
  803964:	3b 04 24             	cmp    (%esp),%eax
  803967:	72 06                	jb     80396f <__umoddi3+0x113>
  803969:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80396d:	77 0f                	ja     80397e <__umoddi3+0x122>
  80396f:	89 f2                	mov    %esi,%edx
  803971:	29 f9                	sub    %edi,%ecx
  803973:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803977:	89 14 24             	mov    %edx,(%esp)
  80397a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80397e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803982:	8b 14 24             	mov    (%esp),%edx
  803985:	83 c4 1c             	add    $0x1c,%esp
  803988:	5b                   	pop    %ebx
  803989:	5e                   	pop    %esi
  80398a:	5f                   	pop    %edi
  80398b:	5d                   	pop    %ebp
  80398c:	c3                   	ret    
  80398d:	8d 76 00             	lea    0x0(%esi),%esi
  803990:	2b 04 24             	sub    (%esp),%eax
  803993:	19 fa                	sbb    %edi,%edx
  803995:	89 d1                	mov    %edx,%ecx
  803997:	89 c6                	mov    %eax,%esi
  803999:	e9 71 ff ff ff       	jmp    80390f <__umoddi3+0xb3>
  80399e:	66 90                	xchg   %ax,%ax
  8039a0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8039a4:	72 ea                	jb     803990 <__umoddi3+0x134>
  8039a6:	89 d9                	mov    %ebx,%ecx
  8039a8:	e9 62 ff ff ff       	jmp    80390f <__umoddi3+0xb3>
