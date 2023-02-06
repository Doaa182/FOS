
obj/user/tst_first_fit_2:     file format elf32-i386


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
  800031:	e8 4a 06 00 00       	call   800680 <libmain>
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
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);
  800040:	83 ec 0c             	sub    $0xc,%esp
  800043:	6a 01                	push   $0x1
  800045:	e8 f3 22 00 00       	call   80233d <sys_set_uheap_strategy>
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
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);

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
  80009b:	68 60 37 80 00       	push   $0x803760
  8000a0:	6a 1b                	push   $0x1b
  8000a2:	68 7c 37 80 00       	push   $0x80377c
  8000a7:	e8 10 07 00 00       	call   8007bc <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	6a 00                	push   $0x0
  8000b1:	e8 33 19 00 00       	call   8019e9 <malloc>
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
  8000e0:	e8 04 19 00 00       	call   8019e9 <malloc>
  8000e5:	83 c4 10             	add    $0x10,%esp
  8000e8:	89 45 90             	mov    %eax,-0x70(%ebp)
		if (ptr_allocations[0] != NULL) panic("Malloc: Attempt to allocate more than heap size, should return NULL");
  8000eb:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000ee:	85 c0                	test   %eax,%eax
  8000f0:	74 14                	je     800106 <_main+0xce>
  8000f2:	83 ec 04             	sub    $0x4,%esp
  8000f5:	68 94 37 80 00       	push   $0x803794
  8000fa:	6a 28                	push   $0x28
  8000fc:	68 7c 37 80 00       	push   $0x80377c
  800101:	e8 b6 06 00 00       	call   8007bc <_panic>
	}
	//[2] Attempt to allocate space more than any available fragment
	//	a) Create Fragments
	{
		//2 MB
		int freeFrames = sys_calculate_free_frames() ;
  800106:	e8 1d 1d 00 00       	call   801e28 <sys_calculate_free_frames>
  80010b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages();
  80010e:	e8 b5 1d 00 00       	call   801ec8 <sys_pf_calculate_allocated_pages>
  800113:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800116:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800119:	01 c0                	add    %eax,%eax
  80011b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	50                   	push   %eax
  800122:	e8 c2 18 00 00       	call   8019e9 <malloc>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  80012d:	8b 45 90             	mov    -0x70(%ebp),%eax
  800130:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800135:	74 14                	je     80014b <_main+0x113>
  800137:	83 ec 04             	sub    $0x4,%esp
  80013a:	68 d8 37 80 00       	push   $0x8037d8
  80013f:	6a 31                	push   $0x31
  800141:	68 7c 37 80 00       	push   $0x80377c
  800146:	e8 71 06 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80014b:	e8 78 1d 00 00       	call   801ec8 <sys_pf_calculate_allocated_pages>
  800150:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800153:	74 14                	je     800169 <_main+0x131>
  800155:	83 ec 04             	sub    $0x4,%esp
  800158:	68 08 38 80 00       	push   $0x803808
  80015d:	6a 33                	push   $0x33
  80015f:	68 7c 37 80 00       	push   $0x80377c
  800164:	e8 53 06 00 00       	call   8007bc <_panic>

		//2 MB
		freeFrames = sys_calculate_free_frames() ;
  800169:	e8 ba 1c 00 00       	call   801e28 <sys_calculate_free_frames>
  80016e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800171:	e8 52 1d 00 00       	call   801ec8 <sys_pf_calculate_allocated_pages>
  800176:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800179:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80017c:	01 c0                	add    %eax,%eax
  80017e:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800181:	83 ec 0c             	sub    $0xc,%esp
  800184:	50                   	push   %eax
  800185:	e8 5f 18 00 00       	call   8019e9 <malloc>
  80018a:	83 c4 10             	add    $0x10,%esp
  80018d:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  800190:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800193:	89 c2                	mov    %eax,%edx
  800195:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800198:	01 c0                	add    %eax,%eax
  80019a:	05 00 00 00 80       	add    $0x80000000,%eax
  80019f:	39 c2                	cmp    %eax,%edx
  8001a1:	74 14                	je     8001b7 <_main+0x17f>
  8001a3:	83 ec 04             	sub    $0x4,%esp
  8001a6:	68 d8 37 80 00       	push   $0x8037d8
  8001ab:	6a 39                	push   $0x39
  8001ad:	68 7c 37 80 00       	push   $0x80377c
  8001b2:	e8 05 06 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8001b7:	e8 0c 1d 00 00       	call   801ec8 <sys_pf_calculate_allocated_pages>
  8001bc:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001bf:	74 14                	je     8001d5 <_main+0x19d>
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 08 38 80 00       	push   $0x803808
  8001c9:	6a 3b                	push   $0x3b
  8001cb:	68 7c 37 80 00       	push   $0x80377c
  8001d0:	e8 e7 05 00 00       	call   8007bc <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  8001d5:	e8 4e 1c 00 00       	call   801e28 <sys_calculate_free_frames>
  8001da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001dd:	e8 e6 1c 00 00       	call   801ec8 <sys_pf_calculate_allocated_pages>
  8001e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(3*kilo);
  8001e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001e8:	89 c2                	mov    %eax,%edx
  8001ea:	01 d2                	add    %edx,%edx
  8001ec:	01 d0                	add    %edx,%eax
  8001ee:	83 ec 0c             	sub    $0xc,%esp
  8001f1:	50                   	push   %eax
  8001f2:	e8 f2 17 00 00       	call   8019e9 <malloc>
  8001f7:	83 c4 10             	add    $0x10,%esp
  8001fa:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  8001fd:	8b 45 98             	mov    -0x68(%ebp),%eax
  800200:	89 c2                	mov    %eax,%edx
  800202:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800205:	c1 e0 02             	shl    $0x2,%eax
  800208:	05 00 00 00 80       	add    $0x80000000,%eax
  80020d:	39 c2                	cmp    %eax,%edx
  80020f:	74 14                	je     800225 <_main+0x1ed>
  800211:	83 ec 04             	sub    $0x4,%esp
  800214:	68 d8 37 80 00       	push   $0x8037d8
  800219:	6a 41                	push   $0x41
  80021b:	68 7c 37 80 00       	push   $0x80377c
  800220:	e8 97 05 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800225:	e8 9e 1c 00 00       	call   801ec8 <sys_pf_calculate_allocated_pages>
  80022a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80022d:	74 14                	je     800243 <_main+0x20b>
  80022f:	83 ec 04             	sub    $0x4,%esp
  800232:	68 08 38 80 00       	push   $0x803808
  800237:	6a 43                	push   $0x43
  800239:	68 7c 37 80 00       	push   $0x80377c
  80023e:	e8 79 05 00 00       	call   8007bc <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  800243:	e8 e0 1b 00 00       	call   801e28 <sys_calculate_free_frames>
  800248:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80024b:	e8 78 1c 00 00       	call   801ec8 <sys_pf_calculate_allocated_pages>
  800250:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(3*kilo);
  800253:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800256:	89 c2                	mov    %eax,%edx
  800258:	01 d2                	add    %edx,%edx
  80025a:	01 d0                	add    %edx,%eax
  80025c:	83 ec 0c             	sub    $0xc,%esp
  80025f:	50                   	push   %eax
  800260:	e8 84 17 00 00       	call   8019e9 <malloc>
  800265:	83 c4 10             	add    $0x10,%esp
  800268:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 4*Mega + 4*kilo)) panic("Wrong start address for the allocated space... ");
  80026b:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80026e:	89 c2                	mov    %eax,%edx
  800270:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800273:	c1 e0 02             	shl    $0x2,%eax
  800276:	89 c1                	mov    %eax,%ecx
  800278:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80027b:	c1 e0 02             	shl    $0x2,%eax
  80027e:	01 c8                	add    %ecx,%eax
  800280:	05 00 00 00 80       	add    $0x80000000,%eax
  800285:	39 c2                	cmp    %eax,%edx
  800287:	74 14                	je     80029d <_main+0x265>
  800289:	83 ec 04             	sub    $0x4,%esp
  80028c:	68 d8 37 80 00       	push   $0x8037d8
  800291:	6a 49                	push   $0x49
  800293:	68 7c 37 80 00       	push   $0x80377c
  800298:	e8 1f 05 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80029d:	e8 26 1c 00 00       	call   801ec8 <sys_pf_calculate_allocated_pages>
  8002a2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002a5:	74 14                	je     8002bb <_main+0x283>
  8002a7:	83 ec 04             	sub    $0x4,%esp
  8002aa:	68 08 38 80 00       	push   $0x803808
  8002af:	6a 4b                	push   $0x4b
  8002b1:	68 7c 37 80 00       	push   $0x80377c
  8002b6:	e8 01 05 00 00       	call   8007bc <_panic>

		//4 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  8002bb:	e8 68 1b 00 00       	call   801e28 <sys_calculate_free_frames>
  8002c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002c3:	e8 00 1c 00 00       	call   801ec8 <sys_pf_calculate_allocated_pages>
  8002c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[2]);
  8002cb:	8b 45 98             	mov    -0x68(%ebp),%eax
  8002ce:	83 ec 0c             	sub    $0xc,%esp
  8002d1:	50                   	push   %eax
  8002d2:	e8 a9 17 00 00       	call   801a80 <free>
  8002d7:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1) panic("Wrong free: ");
		if( (usedDiskPages-sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8002da:	e8 e9 1b 00 00       	call   801ec8 <sys_pf_calculate_allocated_pages>
  8002df:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002e2:	74 14                	je     8002f8 <_main+0x2c0>
  8002e4:	83 ec 04             	sub    $0x4,%esp
  8002e7:	68 25 38 80 00       	push   $0x803825
  8002ec:	6a 52                	push   $0x52
  8002ee:	68 7c 37 80 00       	push   $0x80377c
  8002f3:	e8 c4 04 00 00       	call   8007bc <_panic>

		//7 KB
		freeFrames = sys_calculate_free_frames() ;
  8002f8:	e8 2b 1b 00 00       	call   801e28 <sys_calculate_free_frames>
  8002fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800300:	e8 c3 1b 00 00       	call   801ec8 <sys_pf_calculate_allocated_pages>
  800305:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  800308:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80030b:	89 d0                	mov    %edx,%eax
  80030d:	01 c0                	add    %eax,%eax
  80030f:	01 d0                	add    %edx,%eax
  800311:	01 c0                	add    %eax,%eax
  800313:	01 d0                	add    %edx,%eax
  800315:	83 ec 0c             	sub    $0xc,%esp
  800318:	50                   	push   %eax
  800319:	e8 cb 16 00 00       	call   8019e9 <malloc>
  80031e:	83 c4 10             	add    $0x10,%esp
  800321:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] != (USER_HEAP_START + 4*Mega + 8*kilo)) panic("Wrong start address for the allocated space... ");
  800324:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800327:	89 c2                	mov    %eax,%edx
  800329:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80032c:	c1 e0 02             	shl    $0x2,%eax
  80032f:	89 c1                	mov    %eax,%ecx
  800331:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800334:	c1 e0 03             	shl    $0x3,%eax
  800337:	01 c8                	add    %ecx,%eax
  800339:	05 00 00 00 80       	add    $0x80000000,%eax
  80033e:	39 c2                	cmp    %eax,%edx
  800340:	74 14                	je     800356 <_main+0x31e>
  800342:	83 ec 04             	sub    $0x4,%esp
  800345:	68 d8 37 80 00       	push   $0x8037d8
  80034a:	6a 58                	push   $0x58
  80034c:	68 7c 37 80 00       	push   $0x80377c
  800351:	e8 66 04 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800356:	e8 6d 1b 00 00       	call   801ec8 <sys_pf_calculate_allocated_pages>
  80035b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80035e:	74 14                	je     800374 <_main+0x33c>
  800360:	83 ec 04             	sub    $0x4,%esp
  800363:	68 08 38 80 00       	push   $0x803808
  800368:	6a 5a                	push   $0x5a
  80036a:	68 7c 37 80 00       	push   $0x80377c
  80036f:	e8 48 04 00 00       	call   8007bc <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800374:	e8 af 1a 00 00       	call   801e28 <sys_calculate_free_frames>
  800379:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80037c:	e8 47 1b 00 00       	call   801ec8 <sys_pf_calculate_allocated_pages>
  800381:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[0]);
  800384:	8b 45 90             	mov    -0x70(%ebp),%eax
  800387:	83 ec 0c             	sub    $0xc,%esp
  80038a:	50                   	push   %eax
  80038b:	e8 f0 16 00 00       	call   801a80 <free>
  800390:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  0) panic("Wrong page file free: ");
  800393:	e8 30 1b 00 00       	call   801ec8 <sys_pf_calculate_allocated_pages>
  800398:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80039b:	74 14                	je     8003b1 <_main+0x379>
  80039d:	83 ec 04             	sub    $0x4,%esp
  8003a0:	68 25 38 80 00       	push   $0x803825
  8003a5:	6a 61                	push   $0x61
  8003a7:	68 7c 37 80 00       	push   $0x80377c
  8003ac:	e8 0b 04 00 00       	call   8007bc <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003b1:	e8 72 1a 00 00       	call   801e28 <sys_calculate_free_frames>
  8003b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003b9:	e8 0a 1b 00 00       	call   801ec8 <sys_pf_calculate_allocated_pages>
  8003be:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8003c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003c4:	89 c2                	mov    %eax,%edx
  8003c6:	01 d2                	add    %edx,%edx
  8003c8:	01 d0                	add    %edx,%eax
  8003ca:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003cd:	83 ec 0c             	sub    $0xc,%esp
  8003d0:	50                   	push   %eax
  8003d1:	e8 13 16 00 00       	call   8019e9 <malloc>
  8003d6:	83 c4 10             	add    $0x10,%esp
  8003d9:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] !=  (USER_HEAP_START + 4*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  8003dc:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003df:	89 c2                	mov    %eax,%edx
  8003e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003e4:	c1 e0 02             	shl    $0x2,%eax
  8003e7:	89 c1                	mov    %eax,%ecx
  8003e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003ec:	c1 e0 04             	shl    $0x4,%eax
  8003ef:	01 c8                	add    %ecx,%eax
  8003f1:	05 00 00 00 80       	add    $0x80000000,%eax
  8003f6:	39 c2                	cmp    %eax,%edx
  8003f8:	74 14                	je     80040e <_main+0x3d6>
  8003fa:	83 ec 04             	sub    $0x4,%esp
  8003fd:	68 d8 37 80 00       	push   $0x8037d8
  800402:	6a 67                	push   $0x67
  800404:	68 7c 37 80 00       	push   $0x80377c
  800409:	e8 ae 03 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80040e:	e8 b5 1a 00 00       	call   801ec8 <sys_pf_calculate_allocated_pages>
  800413:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800416:	74 14                	je     80042c <_main+0x3f4>
  800418:	83 ec 04             	sub    $0x4,%esp
  80041b:	68 08 38 80 00       	push   $0x803808
  800420:	6a 69                	push   $0x69
  800422:	68 7c 37 80 00       	push   $0x80377c
  800427:	e8 90 03 00 00       	call   8007bc <_panic>

		//2 MB + 6 KB
		freeFrames = sys_calculate_free_frames() ;
  80042c:	e8 f7 19 00 00       	call   801e28 <sys_calculate_free_frames>
  800431:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800434:	e8 8f 1a 00 00       	call   801ec8 <sys_pf_calculate_allocated_pages>
  800439:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(2*Mega + 6*kilo);
  80043c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80043f:	89 c2                	mov    %eax,%edx
  800441:	01 d2                	add    %edx,%edx
  800443:	01 c2                	add    %eax,%edx
  800445:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800448:	01 d0                	add    %edx,%eax
  80044a:	01 c0                	add    %eax,%eax
  80044c:	83 ec 0c             	sub    $0xc,%esp
  80044f:	50                   	push   %eax
  800450:	e8 94 15 00 00       	call   8019e9 <malloc>
  800455:	83 c4 10             	add    $0x10,%esp
  800458:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] !=  (USER_HEAP_START + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  80045b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80045e:	89 c1                	mov    %eax,%ecx
  800460:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800463:	89 d0                	mov    %edx,%eax
  800465:	01 c0                	add    %eax,%eax
  800467:	01 d0                	add    %edx,%eax
  800469:	01 c0                	add    %eax,%eax
  80046b:	01 d0                	add    %edx,%eax
  80046d:	89 c2                	mov    %eax,%edx
  80046f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800472:	c1 e0 04             	shl    $0x4,%eax
  800475:	01 d0                	add    %edx,%eax
  800477:	05 00 00 00 80       	add    $0x80000000,%eax
  80047c:	39 c1                	cmp    %eax,%ecx
  80047e:	74 14                	je     800494 <_main+0x45c>
  800480:	83 ec 04             	sub    $0x4,%esp
  800483:	68 d8 37 80 00       	push   $0x8037d8
  800488:	6a 6f                	push   $0x6f
  80048a:	68 7c 37 80 00       	push   $0x80377c
  80048f:	e8 28 03 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 514+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800494:	e8 2f 1a 00 00       	call   801ec8 <sys_pf_calculate_allocated_pages>
  800499:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80049c:	74 14                	je     8004b2 <_main+0x47a>
  80049e:	83 ec 04             	sub    $0x4,%esp
  8004a1:	68 08 38 80 00       	push   $0x803808
  8004a6:	6a 71                	push   $0x71
  8004a8:	68 7c 37 80 00       	push   $0x80377c
  8004ad:	e8 0a 03 00 00       	call   8007bc <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8004b2:	e8 71 19 00 00       	call   801e28 <sys_calculate_free_frames>
  8004b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004ba:	e8 09 1a 00 00       	call   801ec8 <sys_pf_calculate_allocated_pages>
  8004bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[5]);
  8004c2:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8004c5:	83 ec 0c             	sub    $0xc,%esp
  8004c8:	50                   	push   %eax
  8004c9:	e8 b2 15 00 00       	call   801a80 <free>
  8004ce:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8004d1:	e8 f2 19 00 00       	call   801ec8 <sys_pf_calculate_allocated_pages>
  8004d6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004d9:	74 14                	je     8004ef <_main+0x4b7>
  8004db:	83 ec 04             	sub    $0x4,%esp
  8004de:	68 25 38 80 00       	push   $0x803825
  8004e3:	6a 78                	push   $0x78
  8004e5:	68 7c 37 80 00       	push   $0x80377c
  8004ea:	e8 cd 02 00 00       	call   8007bc <_panic>

		//2 MB Hole [Resulting Hole = 2 MB + 2 MB + 4 KB = 4 MB + 4 KB]
		freeFrames = sys_calculate_free_frames() ;
  8004ef:	e8 34 19 00 00       	call   801e28 <sys_calculate_free_frames>
  8004f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004f7:	e8 cc 19 00 00       	call   801ec8 <sys_pf_calculate_allocated_pages>
  8004fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  8004ff:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800502:	83 ec 0c             	sub    $0xc,%esp
  800505:	50                   	push   %eax
  800506:	e8 75 15 00 00       	call   801a80 <free>
  80050b:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  0) panic("Wrong page file free: ");
  80050e:	e8 b5 19 00 00       	call   801ec8 <sys_pf_calculate_allocated_pages>
  800513:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800516:	74 14                	je     80052c <_main+0x4f4>
  800518:	83 ec 04             	sub    $0x4,%esp
  80051b:	68 25 38 80 00       	push   $0x803825
  800520:	6a 7f                	push   $0x7f
  800522:	68 7c 37 80 00       	push   $0x80377c
  800527:	e8 90 02 00 00       	call   8007bc <_panic>

		//5 MB
		freeFrames = sys_calculate_free_frames() ;
  80052c:	e8 f7 18 00 00       	call   801e28 <sys_calculate_free_frames>
  800531:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800534:	e8 8f 19 00 00       	call   801ec8 <sys_pf_calculate_allocated_pages>
  800539:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = malloc(5*Mega-kilo);
  80053c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80053f:	89 d0                	mov    %edx,%eax
  800541:	c1 e0 02             	shl    $0x2,%eax
  800544:	01 d0                	add    %edx,%eax
  800546:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800549:	83 ec 0c             	sub    $0xc,%esp
  80054c:	50                   	push   %eax
  80054d:	e8 97 14 00 00       	call   8019e9 <malloc>
  800552:	83 c4 10             	add    $0x10,%esp
  800555:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 9*Mega + 24*kilo)) panic("Wrong start address for the allocated space... ");
  800558:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80055b:	89 c1                	mov    %eax,%ecx
  80055d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800560:	89 d0                	mov    %edx,%eax
  800562:	c1 e0 03             	shl    $0x3,%eax
  800565:	01 d0                	add    %edx,%eax
  800567:	89 c3                	mov    %eax,%ebx
  800569:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80056c:	89 d0                	mov    %edx,%eax
  80056e:	01 c0                	add    %eax,%eax
  800570:	01 d0                	add    %edx,%eax
  800572:	c1 e0 03             	shl    $0x3,%eax
  800575:	01 d8                	add    %ebx,%eax
  800577:	05 00 00 00 80       	add    $0x80000000,%eax
  80057c:	39 c1                	cmp    %eax,%ecx
  80057e:	74 17                	je     800597 <_main+0x55f>
  800580:	83 ec 04             	sub    $0x4,%esp
  800583:	68 d8 37 80 00       	push   $0x8037d8
  800588:	68 85 00 00 00       	push   $0x85
  80058d:	68 7c 37 80 00       	push   $0x80377c
  800592:	e8 25 02 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 5*Mega/4096 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800597:	e8 2c 19 00 00       	call   801ec8 <sys_pf_calculate_allocated_pages>
  80059c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80059f:	74 17                	je     8005b8 <_main+0x580>
  8005a1:	83 ec 04             	sub    $0x4,%esp
  8005a4:	68 08 38 80 00       	push   $0x803808
  8005a9:	68 87 00 00 00       	push   $0x87
  8005ae:	68 7c 37 80 00       	push   $0x80377c
  8005b3:	e8 04 02 00 00       	call   8007bc <_panic>
		//		//if ((sys_calculate_free_frames() - freeFrames) != 514) panic("Wrong free: ");
		//		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  514) panic("Wrong page file free: ");

		//[FIRST FIT Case]
		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8005b8:	e8 6b 18 00 00       	call   801e28 <sys_calculate_free_frames>
  8005bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005c0:	e8 03 19 00 00       	call   801ec8 <sys_pf_calculate_allocated_pages>
  8005c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(3*Mega-kilo);
  8005c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005cb:	89 c2                	mov    %eax,%edx
  8005cd:	01 d2                	add    %edx,%edx
  8005cf:	01 d0                	add    %edx,%eax
  8005d1:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8005d4:	83 ec 0c             	sub    $0xc,%esp
  8005d7:	50                   	push   %eax
  8005d8:	e8 0c 14 00 00       	call   8019e9 <malloc>
  8005dd:	83 c4 10             	add    $0x10,%esp
  8005e0:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[8] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  8005e3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8005e6:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  8005eb:	74 17                	je     800604 <_main+0x5cc>
  8005ed:	83 ec 04             	sub    $0x4,%esp
  8005f0:	68 d8 37 80 00       	push   $0x8037d8
  8005f5:	68 95 00 00 00       	push   $0x95
  8005fa:	68 7c 37 80 00       	push   $0x80377c
  8005ff:	e8 b8 01 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800604:	e8 bf 18 00 00       	call   801ec8 <sys_pf_calculate_allocated_pages>
  800609:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80060c:	74 17                	je     800625 <_main+0x5ed>
  80060e:	83 ec 04             	sub    $0x4,%esp
  800611:	68 08 38 80 00       	push   $0x803808
  800616:	68 97 00 00 00       	push   $0x97
  80061b:	68 7c 37 80 00       	push   $0x80377c
  800620:	e8 97 01 00 00       	call   8007bc <_panic>
	//	b) Attempt to allocate large segment with no suitable fragment to fit on
	{
		//Large Allocation
		//int freeFrames = sys_calculate_free_frames() ;
		//usedDiskPages = sys_pf_calculate_allocated_pages();
		ptr_allocations[9] = malloc((USER_HEAP_MAX - USER_HEAP_START - 14*Mega));
  800625:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800628:	89 d0                	mov    %edx,%eax
  80062a:	01 c0                	add    %eax,%eax
  80062c:	01 d0                	add    %edx,%eax
  80062e:	01 c0                	add    %eax,%eax
  800630:	01 d0                	add    %edx,%eax
  800632:	01 c0                	add    %eax,%eax
  800634:	f7 d8                	neg    %eax
  800636:	05 00 00 00 20       	add    $0x20000000,%eax
  80063b:	83 ec 0c             	sub    $0xc,%esp
  80063e:	50                   	push   %eax
  80063f:	e8 a5 13 00 00       	call   8019e9 <malloc>
  800644:	83 c4 10             	add    $0x10,%esp
  800647:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if (ptr_allocations[9] != NULL) panic("Malloc: Attempt to allocate large segment with no suitable fragment to fit on, should return NULL");
  80064a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80064d:	85 c0                	test   %eax,%eax
  80064f:	74 17                	je     800668 <_main+0x630>
  800651:	83 ec 04             	sub    $0x4,%esp
  800654:	68 3c 38 80 00       	push   $0x80383c
  800659:	68 a0 00 00 00       	push   $0xa0
  80065e:	68 7c 37 80 00       	push   $0x80377c
  800663:	e8 54 01 00 00       	call   8007bc <_panic>

		cprintf("Congratulations!! test FIRST FIT allocation (2) completed successfully.\n");
  800668:	83 ec 0c             	sub    $0xc,%esp
  80066b:	68 a0 38 80 00       	push   $0x8038a0
  800670:	e8 fb 03 00 00       	call   800a70 <cprintf>
  800675:	83 c4 10             	add    $0x10,%esp

		return;
  800678:	90                   	nop
	}
}
  800679:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80067c:	5b                   	pop    %ebx
  80067d:	5f                   	pop    %edi
  80067e:	5d                   	pop    %ebp
  80067f:	c3                   	ret    

00800680 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800680:	55                   	push   %ebp
  800681:	89 e5                	mov    %esp,%ebp
  800683:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800686:	e8 7d 1a 00 00       	call   802108 <sys_getenvindex>
  80068b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80068e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800691:	89 d0                	mov    %edx,%eax
  800693:	c1 e0 03             	shl    $0x3,%eax
  800696:	01 d0                	add    %edx,%eax
  800698:	01 c0                	add    %eax,%eax
  80069a:	01 d0                	add    %edx,%eax
  80069c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006a3:	01 d0                	add    %edx,%eax
  8006a5:	c1 e0 04             	shl    $0x4,%eax
  8006a8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8006ad:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8006b2:	a1 20 50 80 00       	mov    0x805020,%eax
  8006b7:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8006bd:	84 c0                	test   %al,%al
  8006bf:	74 0f                	je     8006d0 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8006c1:	a1 20 50 80 00       	mov    0x805020,%eax
  8006c6:	05 5c 05 00 00       	add    $0x55c,%eax
  8006cb:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006d4:	7e 0a                	jle    8006e0 <libmain+0x60>
		binaryname = argv[0];
  8006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d9:	8b 00                	mov    (%eax),%eax
  8006db:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8006e0:	83 ec 08             	sub    $0x8,%esp
  8006e3:	ff 75 0c             	pushl  0xc(%ebp)
  8006e6:	ff 75 08             	pushl  0x8(%ebp)
  8006e9:	e8 4a f9 ff ff       	call   800038 <_main>
  8006ee:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8006f1:	e8 1f 18 00 00       	call   801f15 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006f6:	83 ec 0c             	sub    $0xc,%esp
  8006f9:	68 04 39 80 00       	push   $0x803904
  8006fe:	e8 6d 03 00 00       	call   800a70 <cprintf>
  800703:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800706:	a1 20 50 80 00       	mov    0x805020,%eax
  80070b:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800711:	a1 20 50 80 00       	mov    0x805020,%eax
  800716:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80071c:	83 ec 04             	sub    $0x4,%esp
  80071f:	52                   	push   %edx
  800720:	50                   	push   %eax
  800721:	68 2c 39 80 00       	push   $0x80392c
  800726:	e8 45 03 00 00       	call   800a70 <cprintf>
  80072b:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80072e:	a1 20 50 80 00       	mov    0x805020,%eax
  800733:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800739:	a1 20 50 80 00       	mov    0x805020,%eax
  80073e:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800744:	a1 20 50 80 00       	mov    0x805020,%eax
  800749:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80074f:	51                   	push   %ecx
  800750:	52                   	push   %edx
  800751:	50                   	push   %eax
  800752:	68 54 39 80 00       	push   $0x803954
  800757:	e8 14 03 00 00       	call   800a70 <cprintf>
  80075c:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80075f:	a1 20 50 80 00       	mov    0x805020,%eax
  800764:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80076a:	83 ec 08             	sub    $0x8,%esp
  80076d:	50                   	push   %eax
  80076e:	68 ac 39 80 00       	push   $0x8039ac
  800773:	e8 f8 02 00 00       	call   800a70 <cprintf>
  800778:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80077b:	83 ec 0c             	sub    $0xc,%esp
  80077e:	68 04 39 80 00       	push   $0x803904
  800783:	e8 e8 02 00 00       	call   800a70 <cprintf>
  800788:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80078b:	e8 9f 17 00 00       	call   801f2f <sys_enable_interrupt>

	// exit gracefully
	exit();
  800790:	e8 19 00 00 00       	call   8007ae <exit>
}
  800795:	90                   	nop
  800796:	c9                   	leave  
  800797:	c3                   	ret    

00800798 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800798:	55                   	push   %ebp
  800799:	89 e5                	mov    %esp,%ebp
  80079b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80079e:	83 ec 0c             	sub    $0xc,%esp
  8007a1:	6a 00                	push   $0x0
  8007a3:	e8 2c 19 00 00       	call   8020d4 <sys_destroy_env>
  8007a8:	83 c4 10             	add    $0x10,%esp
}
  8007ab:	90                   	nop
  8007ac:	c9                   	leave  
  8007ad:	c3                   	ret    

008007ae <exit>:

void
exit(void)
{
  8007ae:	55                   	push   %ebp
  8007af:	89 e5                	mov    %esp,%ebp
  8007b1:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8007b4:	e8 81 19 00 00       	call   80213a <sys_exit_env>
}
  8007b9:	90                   	nop
  8007ba:	c9                   	leave  
  8007bb:	c3                   	ret    

008007bc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8007bc:	55                   	push   %ebp
  8007bd:	89 e5                	mov    %esp,%ebp
  8007bf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8007c2:	8d 45 10             	lea    0x10(%ebp),%eax
  8007c5:	83 c0 04             	add    $0x4,%eax
  8007c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8007cb:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8007d0:	85 c0                	test   %eax,%eax
  8007d2:	74 16                	je     8007ea <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007d4:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8007d9:	83 ec 08             	sub    $0x8,%esp
  8007dc:	50                   	push   %eax
  8007dd:	68 c0 39 80 00       	push   $0x8039c0
  8007e2:	e8 89 02 00 00       	call   800a70 <cprintf>
  8007e7:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007ea:	a1 00 50 80 00       	mov    0x805000,%eax
  8007ef:	ff 75 0c             	pushl  0xc(%ebp)
  8007f2:	ff 75 08             	pushl  0x8(%ebp)
  8007f5:	50                   	push   %eax
  8007f6:	68 c5 39 80 00       	push   $0x8039c5
  8007fb:	e8 70 02 00 00       	call   800a70 <cprintf>
  800800:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800803:	8b 45 10             	mov    0x10(%ebp),%eax
  800806:	83 ec 08             	sub    $0x8,%esp
  800809:	ff 75 f4             	pushl  -0xc(%ebp)
  80080c:	50                   	push   %eax
  80080d:	e8 f3 01 00 00       	call   800a05 <vcprintf>
  800812:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800815:	83 ec 08             	sub    $0x8,%esp
  800818:	6a 00                	push   $0x0
  80081a:	68 e1 39 80 00       	push   $0x8039e1
  80081f:	e8 e1 01 00 00       	call   800a05 <vcprintf>
  800824:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800827:	e8 82 ff ff ff       	call   8007ae <exit>

	// should not return here
	while (1) ;
  80082c:	eb fe                	jmp    80082c <_panic+0x70>

0080082e <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80082e:	55                   	push   %ebp
  80082f:	89 e5                	mov    %esp,%ebp
  800831:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800834:	a1 20 50 80 00       	mov    0x805020,%eax
  800839:	8b 50 74             	mov    0x74(%eax),%edx
  80083c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80083f:	39 c2                	cmp    %eax,%edx
  800841:	74 14                	je     800857 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800843:	83 ec 04             	sub    $0x4,%esp
  800846:	68 e4 39 80 00       	push   $0x8039e4
  80084b:	6a 26                	push   $0x26
  80084d:	68 30 3a 80 00       	push   $0x803a30
  800852:	e8 65 ff ff ff       	call   8007bc <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800857:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80085e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800865:	e9 c2 00 00 00       	jmp    80092c <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80086a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80086d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800874:	8b 45 08             	mov    0x8(%ebp),%eax
  800877:	01 d0                	add    %edx,%eax
  800879:	8b 00                	mov    (%eax),%eax
  80087b:	85 c0                	test   %eax,%eax
  80087d:	75 08                	jne    800887 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80087f:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800882:	e9 a2 00 00 00       	jmp    800929 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800887:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80088e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800895:	eb 69                	jmp    800900 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800897:	a1 20 50 80 00       	mov    0x805020,%eax
  80089c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8008a2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008a5:	89 d0                	mov    %edx,%eax
  8008a7:	01 c0                	add    %eax,%eax
  8008a9:	01 d0                	add    %edx,%eax
  8008ab:	c1 e0 03             	shl    $0x3,%eax
  8008ae:	01 c8                	add    %ecx,%eax
  8008b0:	8a 40 04             	mov    0x4(%eax),%al
  8008b3:	84 c0                	test   %al,%al
  8008b5:	75 46                	jne    8008fd <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008b7:	a1 20 50 80 00       	mov    0x805020,%eax
  8008bc:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8008c2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008c5:	89 d0                	mov    %edx,%eax
  8008c7:	01 c0                	add    %eax,%eax
  8008c9:	01 d0                	add    %edx,%eax
  8008cb:	c1 e0 03             	shl    $0x3,%eax
  8008ce:	01 c8                	add    %ecx,%eax
  8008d0:	8b 00                	mov    (%eax),%eax
  8008d2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008d8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008dd:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008e2:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ec:	01 c8                	add    %ecx,%eax
  8008ee:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008f0:	39 c2                	cmp    %eax,%edx
  8008f2:	75 09                	jne    8008fd <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8008f4:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008fb:	eb 12                	jmp    80090f <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008fd:	ff 45 e8             	incl   -0x18(%ebp)
  800900:	a1 20 50 80 00       	mov    0x805020,%eax
  800905:	8b 50 74             	mov    0x74(%eax),%edx
  800908:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80090b:	39 c2                	cmp    %eax,%edx
  80090d:	77 88                	ja     800897 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80090f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800913:	75 14                	jne    800929 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800915:	83 ec 04             	sub    $0x4,%esp
  800918:	68 3c 3a 80 00       	push   $0x803a3c
  80091d:	6a 3a                	push   $0x3a
  80091f:	68 30 3a 80 00       	push   $0x803a30
  800924:	e8 93 fe ff ff       	call   8007bc <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800929:	ff 45 f0             	incl   -0x10(%ebp)
  80092c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80092f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800932:	0f 8c 32 ff ff ff    	jl     80086a <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800938:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80093f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800946:	eb 26                	jmp    80096e <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800948:	a1 20 50 80 00       	mov    0x805020,%eax
  80094d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800953:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800956:	89 d0                	mov    %edx,%eax
  800958:	01 c0                	add    %eax,%eax
  80095a:	01 d0                	add    %edx,%eax
  80095c:	c1 e0 03             	shl    $0x3,%eax
  80095f:	01 c8                	add    %ecx,%eax
  800961:	8a 40 04             	mov    0x4(%eax),%al
  800964:	3c 01                	cmp    $0x1,%al
  800966:	75 03                	jne    80096b <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800968:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80096b:	ff 45 e0             	incl   -0x20(%ebp)
  80096e:	a1 20 50 80 00       	mov    0x805020,%eax
  800973:	8b 50 74             	mov    0x74(%eax),%edx
  800976:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800979:	39 c2                	cmp    %eax,%edx
  80097b:	77 cb                	ja     800948 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80097d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800980:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800983:	74 14                	je     800999 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800985:	83 ec 04             	sub    $0x4,%esp
  800988:	68 90 3a 80 00       	push   $0x803a90
  80098d:	6a 44                	push   $0x44
  80098f:	68 30 3a 80 00       	push   $0x803a30
  800994:	e8 23 fe ff ff       	call   8007bc <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800999:	90                   	nop
  80099a:	c9                   	leave  
  80099b:	c3                   	ret    

0080099c <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80099c:	55                   	push   %ebp
  80099d:	89 e5                	mov    %esp,%ebp
  80099f:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8009a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a5:	8b 00                	mov    (%eax),%eax
  8009a7:	8d 48 01             	lea    0x1(%eax),%ecx
  8009aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ad:	89 0a                	mov    %ecx,(%edx)
  8009af:	8b 55 08             	mov    0x8(%ebp),%edx
  8009b2:	88 d1                	mov    %dl,%cl
  8009b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b7:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8009bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009be:	8b 00                	mov    (%eax),%eax
  8009c0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009c5:	75 2c                	jne    8009f3 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8009c7:	a0 24 50 80 00       	mov    0x805024,%al
  8009cc:	0f b6 c0             	movzbl %al,%eax
  8009cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d2:	8b 12                	mov    (%edx),%edx
  8009d4:	89 d1                	mov    %edx,%ecx
  8009d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d9:	83 c2 08             	add    $0x8,%edx
  8009dc:	83 ec 04             	sub    $0x4,%esp
  8009df:	50                   	push   %eax
  8009e0:	51                   	push   %ecx
  8009e1:	52                   	push   %edx
  8009e2:	e8 80 13 00 00       	call   801d67 <sys_cputs>
  8009e7:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f6:	8b 40 04             	mov    0x4(%eax),%eax
  8009f9:	8d 50 01             	lea    0x1(%eax),%edx
  8009fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ff:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a02:	90                   	nop
  800a03:	c9                   	leave  
  800a04:	c3                   	ret    

00800a05 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a05:	55                   	push   %ebp
  800a06:	89 e5                	mov    %esp,%ebp
  800a08:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a0e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a15:	00 00 00 
	b.cnt = 0;
  800a18:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a1f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a22:	ff 75 0c             	pushl  0xc(%ebp)
  800a25:	ff 75 08             	pushl  0x8(%ebp)
  800a28:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a2e:	50                   	push   %eax
  800a2f:	68 9c 09 80 00       	push   $0x80099c
  800a34:	e8 11 02 00 00       	call   800c4a <vprintfmt>
  800a39:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a3c:	a0 24 50 80 00       	mov    0x805024,%al
  800a41:	0f b6 c0             	movzbl %al,%eax
  800a44:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a4a:	83 ec 04             	sub    $0x4,%esp
  800a4d:	50                   	push   %eax
  800a4e:	52                   	push   %edx
  800a4f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a55:	83 c0 08             	add    $0x8,%eax
  800a58:	50                   	push   %eax
  800a59:	e8 09 13 00 00       	call   801d67 <sys_cputs>
  800a5e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a61:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800a68:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a6e:	c9                   	leave  
  800a6f:	c3                   	ret    

00800a70 <cprintf>:

int cprintf(const char *fmt, ...) {
  800a70:	55                   	push   %ebp
  800a71:	89 e5                	mov    %esp,%ebp
  800a73:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a76:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800a7d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a80:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a83:	8b 45 08             	mov    0x8(%ebp),%eax
  800a86:	83 ec 08             	sub    $0x8,%esp
  800a89:	ff 75 f4             	pushl  -0xc(%ebp)
  800a8c:	50                   	push   %eax
  800a8d:	e8 73 ff ff ff       	call   800a05 <vcprintf>
  800a92:	83 c4 10             	add    $0x10,%esp
  800a95:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a98:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a9b:	c9                   	leave  
  800a9c:	c3                   	ret    

00800a9d <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a9d:	55                   	push   %ebp
  800a9e:	89 e5                	mov    %esp,%ebp
  800aa0:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800aa3:	e8 6d 14 00 00       	call   801f15 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800aa8:	8d 45 0c             	lea    0xc(%ebp),%eax
  800aab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800aae:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab1:	83 ec 08             	sub    $0x8,%esp
  800ab4:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab7:	50                   	push   %eax
  800ab8:	e8 48 ff ff ff       	call   800a05 <vcprintf>
  800abd:	83 c4 10             	add    $0x10,%esp
  800ac0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800ac3:	e8 67 14 00 00       	call   801f2f <sys_enable_interrupt>
	return cnt;
  800ac8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800acb:	c9                   	leave  
  800acc:	c3                   	ret    

00800acd <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800acd:	55                   	push   %ebp
  800ace:	89 e5                	mov    %esp,%ebp
  800ad0:	53                   	push   %ebx
  800ad1:	83 ec 14             	sub    $0x14,%esp
  800ad4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ada:	8b 45 14             	mov    0x14(%ebp),%eax
  800add:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800ae0:	8b 45 18             	mov    0x18(%ebp),%eax
  800ae3:	ba 00 00 00 00       	mov    $0x0,%edx
  800ae8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800aeb:	77 55                	ja     800b42 <printnum+0x75>
  800aed:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800af0:	72 05                	jb     800af7 <printnum+0x2a>
  800af2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800af5:	77 4b                	ja     800b42 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800af7:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800afa:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800afd:	8b 45 18             	mov    0x18(%ebp),%eax
  800b00:	ba 00 00 00 00       	mov    $0x0,%edx
  800b05:	52                   	push   %edx
  800b06:	50                   	push   %eax
  800b07:	ff 75 f4             	pushl  -0xc(%ebp)
  800b0a:	ff 75 f0             	pushl  -0x10(%ebp)
  800b0d:	e8 ce 29 00 00       	call   8034e0 <__udivdi3>
  800b12:	83 c4 10             	add    $0x10,%esp
  800b15:	83 ec 04             	sub    $0x4,%esp
  800b18:	ff 75 20             	pushl  0x20(%ebp)
  800b1b:	53                   	push   %ebx
  800b1c:	ff 75 18             	pushl  0x18(%ebp)
  800b1f:	52                   	push   %edx
  800b20:	50                   	push   %eax
  800b21:	ff 75 0c             	pushl  0xc(%ebp)
  800b24:	ff 75 08             	pushl  0x8(%ebp)
  800b27:	e8 a1 ff ff ff       	call   800acd <printnum>
  800b2c:	83 c4 20             	add    $0x20,%esp
  800b2f:	eb 1a                	jmp    800b4b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b31:	83 ec 08             	sub    $0x8,%esp
  800b34:	ff 75 0c             	pushl  0xc(%ebp)
  800b37:	ff 75 20             	pushl  0x20(%ebp)
  800b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3d:	ff d0                	call   *%eax
  800b3f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b42:	ff 4d 1c             	decl   0x1c(%ebp)
  800b45:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b49:	7f e6                	jg     800b31 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b4b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b4e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b59:	53                   	push   %ebx
  800b5a:	51                   	push   %ecx
  800b5b:	52                   	push   %edx
  800b5c:	50                   	push   %eax
  800b5d:	e8 8e 2a 00 00       	call   8035f0 <__umoddi3>
  800b62:	83 c4 10             	add    $0x10,%esp
  800b65:	05 f4 3c 80 00       	add    $0x803cf4,%eax
  800b6a:	8a 00                	mov    (%eax),%al
  800b6c:	0f be c0             	movsbl %al,%eax
  800b6f:	83 ec 08             	sub    $0x8,%esp
  800b72:	ff 75 0c             	pushl  0xc(%ebp)
  800b75:	50                   	push   %eax
  800b76:	8b 45 08             	mov    0x8(%ebp),%eax
  800b79:	ff d0                	call   *%eax
  800b7b:	83 c4 10             	add    $0x10,%esp
}
  800b7e:	90                   	nop
  800b7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b82:	c9                   	leave  
  800b83:	c3                   	ret    

00800b84 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b84:	55                   	push   %ebp
  800b85:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b87:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b8b:	7e 1c                	jle    800ba9 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b90:	8b 00                	mov    (%eax),%eax
  800b92:	8d 50 08             	lea    0x8(%eax),%edx
  800b95:	8b 45 08             	mov    0x8(%ebp),%eax
  800b98:	89 10                	mov    %edx,(%eax)
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	8b 00                	mov    (%eax),%eax
  800b9f:	83 e8 08             	sub    $0x8,%eax
  800ba2:	8b 50 04             	mov    0x4(%eax),%edx
  800ba5:	8b 00                	mov    (%eax),%eax
  800ba7:	eb 40                	jmp    800be9 <getuint+0x65>
	else if (lflag)
  800ba9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bad:	74 1e                	je     800bcd <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	8b 00                	mov    (%eax),%eax
  800bb4:	8d 50 04             	lea    0x4(%eax),%edx
  800bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bba:	89 10                	mov    %edx,(%eax)
  800bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbf:	8b 00                	mov    (%eax),%eax
  800bc1:	83 e8 04             	sub    $0x4,%eax
  800bc4:	8b 00                	mov    (%eax),%eax
  800bc6:	ba 00 00 00 00       	mov    $0x0,%edx
  800bcb:	eb 1c                	jmp    800be9 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	8b 00                	mov    (%eax),%eax
  800bd2:	8d 50 04             	lea    0x4(%eax),%edx
  800bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd8:	89 10                	mov    %edx,(%eax)
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	8b 00                	mov    (%eax),%eax
  800bdf:	83 e8 04             	sub    $0x4,%eax
  800be2:	8b 00                	mov    (%eax),%eax
  800be4:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800be9:	5d                   	pop    %ebp
  800bea:	c3                   	ret    

00800beb <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bee:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bf2:	7e 1c                	jle    800c10 <getint+0x25>
		return va_arg(*ap, long long);
  800bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf7:	8b 00                	mov    (%eax),%eax
  800bf9:	8d 50 08             	lea    0x8(%eax),%edx
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	89 10                	mov    %edx,(%eax)
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	8b 00                	mov    (%eax),%eax
  800c06:	83 e8 08             	sub    $0x8,%eax
  800c09:	8b 50 04             	mov    0x4(%eax),%edx
  800c0c:	8b 00                	mov    (%eax),%eax
  800c0e:	eb 38                	jmp    800c48 <getint+0x5d>
	else if (lflag)
  800c10:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c14:	74 1a                	je     800c30 <getint+0x45>
		return va_arg(*ap, long);
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
  800c19:	8b 00                	mov    (%eax),%eax
  800c1b:	8d 50 04             	lea    0x4(%eax),%edx
  800c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c21:	89 10                	mov    %edx,(%eax)
  800c23:	8b 45 08             	mov    0x8(%ebp),%eax
  800c26:	8b 00                	mov    (%eax),%eax
  800c28:	83 e8 04             	sub    $0x4,%eax
  800c2b:	8b 00                	mov    (%eax),%eax
  800c2d:	99                   	cltd   
  800c2e:	eb 18                	jmp    800c48 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	8b 00                	mov    (%eax),%eax
  800c35:	8d 50 04             	lea    0x4(%eax),%edx
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	89 10                	mov    %edx,(%eax)
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	8b 00                	mov    (%eax),%eax
  800c42:	83 e8 04             	sub    $0x4,%eax
  800c45:	8b 00                	mov    (%eax),%eax
  800c47:	99                   	cltd   
}
  800c48:	5d                   	pop    %ebp
  800c49:	c3                   	ret    

00800c4a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c4a:	55                   	push   %ebp
  800c4b:	89 e5                	mov    %esp,%ebp
  800c4d:	56                   	push   %esi
  800c4e:	53                   	push   %ebx
  800c4f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c52:	eb 17                	jmp    800c6b <vprintfmt+0x21>
			if (ch == '\0')
  800c54:	85 db                	test   %ebx,%ebx
  800c56:	0f 84 af 03 00 00    	je     80100b <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800c5c:	83 ec 08             	sub    $0x8,%esp
  800c5f:	ff 75 0c             	pushl  0xc(%ebp)
  800c62:	53                   	push   %ebx
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	ff d0                	call   *%eax
  800c68:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c6b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c6e:	8d 50 01             	lea    0x1(%eax),%edx
  800c71:	89 55 10             	mov    %edx,0x10(%ebp)
  800c74:	8a 00                	mov    (%eax),%al
  800c76:	0f b6 d8             	movzbl %al,%ebx
  800c79:	83 fb 25             	cmp    $0x25,%ebx
  800c7c:	75 d6                	jne    800c54 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c7e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c82:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c89:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c90:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c97:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c9e:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca1:	8d 50 01             	lea    0x1(%eax),%edx
  800ca4:	89 55 10             	mov    %edx,0x10(%ebp)
  800ca7:	8a 00                	mov    (%eax),%al
  800ca9:	0f b6 d8             	movzbl %al,%ebx
  800cac:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800caf:	83 f8 55             	cmp    $0x55,%eax
  800cb2:	0f 87 2b 03 00 00    	ja     800fe3 <vprintfmt+0x399>
  800cb8:	8b 04 85 18 3d 80 00 	mov    0x803d18(,%eax,4),%eax
  800cbf:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800cc1:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800cc5:	eb d7                	jmp    800c9e <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800cc7:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800ccb:	eb d1                	jmp    800c9e <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ccd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800cd4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cd7:	89 d0                	mov    %edx,%eax
  800cd9:	c1 e0 02             	shl    $0x2,%eax
  800cdc:	01 d0                	add    %edx,%eax
  800cde:	01 c0                	add    %eax,%eax
  800ce0:	01 d8                	add    %ebx,%eax
  800ce2:	83 e8 30             	sub    $0x30,%eax
  800ce5:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800ce8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ceb:	8a 00                	mov    (%eax),%al
  800ced:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800cf0:	83 fb 2f             	cmp    $0x2f,%ebx
  800cf3:	7e 3e                	jle    800d33 <vprintfmt+0xe9>
  800cf5:	83 fb 39             	cmp    $0x39,%ebx
  800cf8:	7f 39                	jg     800d33 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cfa:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cfd:	eb d5                	jmp    800cd4 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800cff:	8b 45 14             	mov    0x14(%ebp),%eax
  800d02:	83 c0 04             	add    $0x4,%eax
  800d05:	89 45 14             	mov    %eax,0x14(%ebp)
  800d08:	8b 45 14             	mov    0x14(%ebp),%eax
  800d0b:	83 e8 04             	sub    $0x4,%eax
  800d0e:	8b 00                	mov    (%eax),%eax
  800d10:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d13:	eb 1f                	jmp    800d34 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d15:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d19:	79 83                	jns    800c9e <vprintfmt+0x54>
				width = 0;
  800d1b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d22:	e9 77 ff ff ff       	jmp    800c9e <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d27:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d2e:	e9 6b ff ff ff       	jmp    800c9e <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d33:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d34:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d38:	0f 89 60 ff ff ff    	jns    800c9e <vprintfmt+0x54>
				width = precision, precision = -1;
  800d3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d41:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d44:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d4b:	e9 4e ff ff ff       	jmp    800c9e <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d50:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d53:	e9 46 ff ff ff       	jmp    800c9e <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d58:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5b:	83 c0 04             	add    $0x4,%eax
  800d5e:	89 45 14             	mov    %eax,0x14(%ebp)
  800d61:	8b 45 14             	mov    0x14(%ebp),%eax
  800d64:	83 e8 04             	sub    $0x4,%eax
  800d67:	8b 00                	mov    (%eax),%eax
  800d69:	83 ec 08             	sub    $0x8,%esp
  800d6c:	ff 75 0c             	pushl  0xc(%ebp)
  800d6f:	50                   	push   %eax
  800d70:	8b 45 08             	mov    0x8(%ebp),%eax
  800d73:	ff d0                	call   *%eax
  800d75:	83 c4 10             	add    $0x10,%esp
			break;
  800d78:	e9 89 02 00 00       	jmp    801006 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d80:	83 c0 04             	add    $0x4,%eax
  800d83:	89 45 14             	mov    %eax,0x14(%ebp)
  800d86:	8b 45 14             	mov    0x14(%ebp),%eax
  800d89:	83 e8 04             	sub    $0x4,%eax
  800d8c:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d8e:	85 db                	test   %ebx,%ebx
  800d90:	79 02                	jns    800d94 <vprintfmt+0x14a>
				err = -err;
  800d92:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d94:	83 fb 64             	cmp    $0x64,%ebx
  800d97:	7f 0b                	jg     800da4 <vprintfmt+0x15a>
  800d99:	8b 34 9d 60 3b 80 00 	mov    0x803b60(,%ebx,4),%esi
  800da0:	85 f6                	test   %esi,%esi
  800da2:	75 19                	jne    800dbd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800da4:	53                   	push   %ebx
  800da5:	68 05 3d 80 00       	push   $0x803d05
  800daa:	ff 75 0c             	pushl  0xc(%ebp)
  800dad:	ff 75 08             	pushl  0x8(%ebp)
  800db0:	e8 5e 02 00 00       	call   801013 <printfmt>
  800db5:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800db8:	e9 49 02 00 00       	jmp    801006 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800dbd:	56                   	push   %esi
  800dbe:	68 0e 3d 80 00       	push   $0x803d0e
  800dc3:	ff 75 0c             	pushl  0xc(%ebp)
  800dc6:	ff 75 08             	pushl  0x8(%ebp)
  800dc9:	e8 45 02 00 00       	call   801013 <printfmt>
  800dce:	83 c4 10             	add    $0x10,%esp
			break;
  800dd1:	e9 30 02 00 00       	jmp    801006 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800dd6:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd9:	83 c0 04             	add    $0x4,%eax
  800ddc:	89 45 14             	mov    %eax,0x14(%ebp)
  800ddf:	8b 45 14             	mov    0x14(%ebp),%eax
  800de2:	83 e8 04             	sub    $0x4,%eax
  800de5:	8b 30                	mov    (%eax),%esi
  800de7:	85 f6                	test   %esi,%esi
  800de9:	75 05                	jne    800df0 <vprintfmt+0x1a6>
				p = "(null)";
  800deb:	be 11 3d 80 00       	mov    $0x803d11,%esi
			if (width > 0 && padc != '-')
  800df0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800df4:	7e 6d                	jle    800e63 <vprintfmt+0x219>
  800df6:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800dfa:	74 67                	je     800e63 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dfc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dff:	83 ec 08             	sub    $0x8,%esp
  800e02:	50                   	push   %eax
  800e03:	56                   	push   %esi
  800e04:	e8 0c 03 00 00       	call   801115 <strnlen>
  800e09:	83 c4 10             	add    $0x10,%esp
  800e0c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e0f:	eb 16                	jmp    800e27 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e11:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e15:	83 ec 08             	sub    $0x8,%esp
  800e18:	ff 75 0c             	pushl  0xc(%ebp)
  800e1b:	50                   	push   %eax
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	ff d0                	call   *%eax
  800e21:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e24:	ff 4d e4             	decl   -0x1c(%ebp)
  800e27:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e2b:	7f e4                	jg     800e11 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e2d:	eb 34                	jmp    800e63 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e2f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e33:	74 1c                	je     800e51 <vprintfmt+0x207>
  800e35:	83 fb 1f             	cmp    $0x1f,%ebx
  800e38:	7e 05                	jle    800e3f <vprintfmt+0x1f5>
  800e3a:	83 fb 7e             	cmp    $0x7e,%ebx
  800e3d:	7e 12                	jle    800e51 <vprintfmt+0x207>
					putch('?', putdat);
  800e3f:	83 ec 08             	sub    $0x8,%esp
  800e42:	ff 75 0c             	pushl  0xc(%ebp)
  800e45:	6a 3f                	push   $0x3f
  800e47:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4a:	ff d0                	call   *%eax
  800e4c:	83 c4 10             	add    $0x10,%esp
  800e4f:	eb 0f                	jmp    800e60 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e51:	83 ec 08             	sub    $0x8,%esp
  800e54:	ff 75 0c             	pushl  0xc(%ebp)
  800e57:	53                   	push   %ebx
  800e58:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5b:	ff d0                	call   *%eax
  800e5d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e60:	ff 4d e4             	decl   -0x1c(%ebp)
  800e63:	89 f0                	mov    %esi,%eax
  800e65:	8d 70 01             	lea    0x1(%eax),%esi
  800e68:	8a 00                	mov    (%eax),%al
  800e6a:	0f be d8             	movsbl %al,%ebx
  800e6d:	85 db                	test   %ebx,%ebx
  800e6f:	74 24                	je     800e95 <vprintfmt+0x24b>
  800e71:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e75:	78 b8                	js     800e2f <vprintfmt+0x1e5>
  800e77:	ff 4d e0             	decl   -0x20(%ebp)
  800e7a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e7e:	79 af                	jns    800e2f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e80:	eb 13                	jmp    800e95 <vprintfmt+0x24b>
				putch(' ', putdat);
  800e82:	83 ec 08             	sub    $0x8,%esp
  800e85:	ff 75 0c             	pushl  0xc(%ebp)
  800e88:	6a 20                	push   $0x20
  800e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8d:	ff d0                	call   *%eax
  800e8f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e92:	ff 4d e4             	decl   -0x1c(%ebp)
  800e95:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e99:	7f e7                	jg     800e82 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e9b:	e9 66 01 00 00       	jmp    801006 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ea0:	83 ec 08             	sub    $0x8,%esp
  800ea3:	ff 75 e8             	pushl  -0x18(%ebp)
  800ea6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ea9:	50                   	push   %eax
  800eaa:	e8 3c fd ff ff       	call   800beb <getint>
  800eaf:	83 c4 10             	add    $0x10,%esp
  800eb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eb5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800eb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ebb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ebe:	85 d2                	test   %edx,%edx
  800ec0:	79 23                	jns    800ee5 <vprintfmt+0x29b>
				putch('-', putdat);
  800ec2:	83 ec 08             	sub    $0x8,%esp
  800ec5:	ff 75 0c             	pushl  0xc(%ebp)
  800ec8:	6a 2d                	push   $0x2d
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	ff d0                	call   *%eax
  800ecf:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ed2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ed5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ed8:	f7 d8                	neg    %eax
  800eda:	83 d2 00             	adc    $0x0,%edx
  800edd:	f7 da                	neg    %edx
  800edf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ee2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ee5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800eec:	e9 bc 00 00 00       	jmp    800fad <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ef1:	83 ec 08             	sub    $0x8,%esp
  800ef4:	ff 75 e8             	pushl  -0x18(%ebp)
  800ef7:	8d 45 14             	lea    0x14(%ebp),%eax
  800efa:	50                   	push   %eax
  800efb:	e8 84 fc ff ff       	call   800b84 <getuint>
  800f00:	83 c4 10             	add    $0x10,%esp
  800f03:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f06:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f09:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f10:	e9 98 00 00 00       	jmp    800fad <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f15:	83 ec 08             	sub    $0x8,%esp
  800f18:	ff 75 0c             	pushl  0xc(%ebp)
  800f1b:	6a 58                	push   $0x58
  800f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f20:	ff d0                	call   *%eax
  800f22:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f25:	83 ec 08             	sub    $0x8,%esp
  800f28:	ff 75 0c             	pushl  0xc(%ebp)
  800f2b:	6a 58                	push   $0x58
  800f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f30:	ff d0                	call   *%eax
  800f32:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f35:	83 ec 08             	sub    $0x8,%esp
  800f38:	ff 75 0c             	pushl  0xc(%ebp)
  800f3b:	6a 58                	push   $0x58
  800f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f40:	ff d0                	call   *%eax
  800f42:	83 c4 10             	add    $0x10,%esp
			break;
  800f45:	e9 bc 00 00 00       	jmp    801006 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800f4a:	83 ec 08             	sub    $0x8,%esp
  800f4d:	ff 75 0c             	pushl  0xc(%ebp)
  800f50:	6a 30                	push   $0x30
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	ff d0                	call   *%eax
  800f57:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f5a:	83 ec 08             	sub    $0x8,%esp
  800f5d:	ff 75 0c             	pushl  0xc(%ebp)
  800f60:	6a 78                	push   $0x78
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
  800f65:	ff d0                	call   *%eax
  800f67:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800f6d:	83 c0 04             	add    $0x4,%eax
  800f70:	89 45 14             	mov    %eax,0x14(%ebp)
  800f73:	8b 45 14             	mov    0x14(%ebp),%eax
  800f76:	83 e8 04             	sub    $0x4,%eax
  800f79:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f7e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f85:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f8c:	eb 1f                	jmp    800fad <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f8e:	83 ec 08             	sub    $0x8,%esp
  800f91:	ff 75 e8             	pushl  -0x18(%ebp)
  800f94:	8d 45 14             	lea    0x14(%ebp),%eax
  800f97:	50                   	push   %eax
  800f98:	e8 e7 fb ff ff       	call   800b84 <getuint>
  800f9d:	83 c4 10             	add    $0x10,%esp
  800fa0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fa3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800fa6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800fad:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800fb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fb4:	83 ec 04             	sub    $0x4,%esp
  800fb7:	52                   	push   %edx
  800fb8:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fbb:	50                   	push   %eax
  800fbc:	ff 75 f4             	pushl  -0xc(%ebp)
  800fbf:	ff 75 f0             	pushl  -0x10(%ebp)
  800fc2:	ff 75 0c             	pushl  0xc(%ebp)
  800fc5:	ff 75 08             	pushl  0x8(%ebp)
  800fc8:	e8 00 fb ff ff       	call   800acd <printnum>
  800fcd:	83 c4 20             	add    $0x20,%esp
			break;
  800fd0:	eb 34                	jmp    801006 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fd2:	83 ec 08             	sub    $0x8,%esp
  800fd5:	ff 75 0c             	pushl  0xc(%ebp)
  800fd8:	53                   	push   %ebx
  800fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdc:	ff d0                	call   *%eax
  800fde:	83 c4 10             	add    $0x10,%esp
			break;
  800fe1:	eb 23                	jmp    801006 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fe3:	83 ec 08             	sub    $0x8,%esp
  800fe6:	ff 75 0c             	pushl  0xc(%ebp)
  800fe9:	6a 25                	push   $0x25
  800feb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fee:	ff d0                	call   *%eax
  800ff0:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ff3:	ff 4d 10             	decl   0x10(%ebp)
  800ff6:	eb 03                	jmp    800ffb <vprintfmt+0x3b1>
  800ff8:	ff 4d 10             	decl   0x10(%ebp)
  800ffb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffe:	48                   	dec    %eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	3c 25                	cmp    $0x25,%al
  801003:	75 f3                	jne    800ff8 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801005:	90                   	nop
		}
	}
  801006:	e9 47 fc ff ff       	jmp    800c52 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80100b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80100c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80100f:	5b                   	pop    %ebx
  801010:	5e                   	pop    %esi
  801011:	5d                   	pop    %ebp
  801012:	c3                   	ret    

00801013 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801013:	55                   	push   %ebp
  801014:	89 e5                	mov    %esp,%ebp
  801016:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801019:	8d 45 10             	lea    0x10(%ebp),%eax
  80101c:	83 c0 04             	add    $0x4,%eax
  80101f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801022:	8b 45 10             	mov    0x10(%ebp),%eax
  801025:	ff 75 f4             	pushl  -0xc(%ebp)
  801028:	50                   	push   %eax
  801029:	ff 75 0c             	pushl  0xc(%ebp)
  80102c:	ff 75 08             	pushl  0x8(%ebp)
  80102f:	e8 16 fc ff ff       	call   800c4a <vprintfmt>
  801034:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801037:	90                   	nop
  801038:	c9                   	leave  
  801039:	c3                   	ret    

0080103a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80103a:	55                   	push   %ebp
  80103b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80103d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801040:	8b 40 08             	mov    0x8(%eax),%eax
  801043:	8d 50 01             	lea    0x1(%eax),%edx
  801046:	8b 45 0c             	mov    0xc(%ebp),%eax
  801049:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80104c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104f:	8b 10                	mov    (%eax),%edx
  801051:	8b 45 0c             	mov    0xc(%ebp),%eax
  801054:	8b 40 04             	mov    0x4(%eax),%eax
  801057:	39 c2                	cmp    %eax,%edx
  801059:	73 12                	jae    80106d <sprintputch+0x33>
		*b->buf++ = ch;
  80105b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105e:	8b 00                	mov    (%eax),%eax
  801060:	8d 48 01             	lea    0x1(%eax),%ecx
  801063:	8b 55 0c             	mov    0xc(%ebp),%edx
  801066:	89 0a                	mov    %ecx,(%edx)
  801068:	8b 55 08             	mov    0x8(%ebp),%edx
  80106b:	88 10                	mov    %dl,(%eax)
}
  80106d:	90                   	nop
  80106e:	5d                   	pop    %ebp
  80106f:	c3                   	ret    

00801070 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801070:	55                   	push   %ebp
  801071:	89 e5                	mov    %esp,%ebp
  801073:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801076:	8b 45 08             	mov    0x8(%ebp),%eax
  801079:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80107c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	01 d0                	add    %edx,%eax
  801087:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80108a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801091:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801095:	74 06                	je     80109d <vsnprintf+0x2d>
  801097:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80109b:	7f 07                	jg     8010a4 <vsnprintf+0x34>
		return -E_INVAL;
  80109d:	b8 03 00 00 00       	mov    $0x3,%eax
  8010a2:	eb 20                	jmp    8010c4 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8010a4:	ff 75 14             	pushl  0x14(%ebp)
  8010a7:	ff 75 10             	pushl  0x10(%ebp)
  8010aa:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8010ad:	50                   	push   %eax
  8010ae:	68 3a 10 80 00       	push   $0x80103a
  8010b3:	e8 92 fb ff ff       	call   800c4a <vprintfmt>
  8010b8:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8010bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010be:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8010c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8010c4:	c9                   	leave  
  8010c5:	c3                   	ret    

008010c6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010c6:	55                   	push   %ebp
  8010c7:	89 e5                	mov    %esp,%ebp
  8010c9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8010cc:	8d 45 10             	lea    0x10(%ebp),%eax
  8010cf:	83 c0 04             	add    $0x4,%eax
  8010d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8010d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8010db:	50                   	push   %eax
  8010dc:	ff 75 0c             	pushl  0xc(%ebp)
  8010df:	ff 75 08             	pushl  0x8(%ebp)
  8010e2:	e8 89 ff ff ff       	call   801070 <vsnprintf>
  8010e7:	83 c4 10             	add    $0x10,%esp
  8010ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8010ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010f0:	c9                   	leave  
  8010f1:	c3                   	ret    

008010f2 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8010f2:	55                   	push   %ebp
  8010f3:	89 e5                	mov    %esp,%ebp
  8010f5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8010f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010ff:	eb 06                	jmp    801107 <strlen+0x15>
		n++;
  801101:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801104:	ff 45 08             	incl   0x8(%ebp)
  801107:	8b 45 08             	mov    0x8(%ebp),%eax
  80110a:	8a 00                	mov    (%eax),%al
  80110c:	84 c0                	test   %al,%al
  80110e:	75 f1                	jne    801101 <strlen+0xf>
		n++;
	return n;
  801110:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801113:	c9                   	leave  
  801114:	c3                   	ret    

00801115 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801115:	55                   	push   %ebp
  801116:	89 e5                	mov    %esp,%ebp
  801118:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80111b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801122:	eb 09                	jmp    80112d <strnlen+0x18>
		n++;
  801124:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801127:	ff 45 08             	incl   0x8(%ebp)
  80112a:	ff 4d 0c             	decl   0xc(%ebp)
  80112d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801131:	74 09                	je     80113c <strnlen+0x27>
  801133:	8b 45 08             	mov    0x8(%ebp),%eax
  801136:	8a 00                	mov    (%eax),%al
  801138:	84 c0                	test   %al,%al
  80113a:	75 e8                	jne    801124 <strnlen+0xf>
		n++;
	return n;
  80113c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80113f:	c9                   	leave  
  801140:	c3                   	ret    

00801141 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801141:	55                   	push   %ebp
  801142:	89 e5                	mov    %esp,%ebp
  801144:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
  80114a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80114d:	90                   	nop
  80114e:	8b 45 08             	mov    0x8(%ebp),%eax
  801151:	8d 50 01             	lea    0x1(%eax),%edx
  801154:	89 55 08             	mov    %edx,0x8(%ebp)
  801157:	8b 55 0c             	mov    0xc(%ebp),%edx
  80115a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80115d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801160:	8a 12                	mov    (%edx),%dl
  801162:	88 10                	mov    %dl,(%eax)
  801164:	8a 00                	mov    (%eax),%al
  801166:	84 c0                	test   %al,%al
  801168:	75 e4                	jne    80114e <strcpy+0xd>
		/* do nothing */;
	return ret;
  80116a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80116d:	c9                   	leave  
  80116e:	c3                   	ret    

0080116f <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80116f:	55                   	push   %ebp
  801170:	89 e5                	mov    %esp,%ebp
  801172:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801175:	8b 45 08             	mov    0x8(%ebp),%eax
  801178:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80117b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801182:	eb 1f                	jmp    8011a3 <strncpy+0x34>
		*dst++ = *src;
  801184:	8b 45 08             	mov    0x8(%ebp),%eax
  801187:	8d 50 01             	lea    0x1(%eax),%edx
  80118a:	89 55 08             	mov    %edx,0x8(%ebp)
  80118d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801190:	8a 12                	mov    (%edx),%dl
  801192:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801194:	8b 45 0c             	mov    0xc(%ebp),%eax
  801197:	8a 00                	mov    (%eax),%al
  801199:	84 c0                	test   %al,%al
  80119b:	74 03                	je     8011a0 <strncpy+0x31>
			src++;
  80119d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011a0:	ff 45 fc             	incl   -0x4(%ebp)
  8011a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011a9:	72 d9                	jb     801184 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8011ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011ae:	c9                   	leave  
  8011af:	c3                   	ret    

008011b0 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8011b0:	55                   	push   %ebp
  8011b1:	89 e5                	mov    %esp,%ebp
  8011b3:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8011b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8011bc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011c0:	74 30                	je     8011f2 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8011c2:	eb 16                	jmp    8011da <strlcpy+0x2a>
			*dst++ = *src++;
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c7:	8d 50 01             	lea    0x1(%eax),%edx
  8011ca:	89 55 08             	mov    %edx,0x8(%ebp)
  8011cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011d0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011d3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8011d6:	8a 12                	mov    (%edx),%dl
  8011d8:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011da:	ff 4d 10             	decl   0x10(%ebp)
  8011dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011e1:	74 09                	je     8011ec <strlcpy+0x3c>
  8011e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e6:	8a 00                	mov    (%eax),%al
  8011e8:	84 c0                	test   %al,%al
  8011ea:	75 d8                	jne    8011c4 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8011ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ef:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8011f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011f8:	29 c2                	sub    %eax,%edx
  8011fa:	89 d0                	mov    %edx,%eax
}
  8011fc:	c9                   	leave  
  8011fd:	c3                   	ret    

008011fe <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011fe:	55                   	push   %ebp
  8011ff:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801201:	eb 06                	jmp    801209 <strcmp+0xb>
		p++, q++;
  801203:	ff 45 08             	incl   0x8(%ebp)
  801206:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801209:	8b 45 08             	mov    0x8(%ebp),%eax
  80120c:	8a 00                	mov    (%eax),%al
  80120e:	84 c0                	test   %al,%al
  801210:	74 0e                	je     801220 <strcmp+0x22>
  801212:	8b 45 08             	mov    0x8(%ebp),%eax
  801215:	8a 10                	mov    (%eax),%dl
  801217:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121a:	8a 00                	mov    (%eax),%al
  80121c:	38 c2                	cmp    %al,%dl
  80121e:	74 e3                	je     801203 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801220:	8b 45 08             	mov    0x8(%ebp),%eax
  801223:	8a 00                	mov    (%eax),%al
  801225:	0f b6 d0             	movzbl %al,%edx
  801228:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122b:	8a 00                	mov    (%eax),%al
  80122d:	0f b6 c0             	movzbl %al,%eax
  801230:	29 c2                	sub    %eax,%edx
  801232:	89 d0                	mov    %edx,%eax
}
  801234:	5d                   	pop    %ebp
  801235:	c3                   	ret    

00801236 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801236:	55                   	push   %ebp
  801237:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801239:	eb 09                	jmp    801244 <strncmp+0xe>
		n--, p++, q++;
  80123b:	ff 4d 10             	decl   0x10(%ebp)
  80123e:	ff 45 08             	incl   0x8(%ebp)
  801241:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801244:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801248:	74 17                	je     801261 <strncmp+0x2b>
  80124a:	8b 45 08             	mov    0x8(%ebp),%eax
  80124d:	8a 00                	mov    (%eax),%al
  80124f:	84 c0                	test   %al,%al
  801251:	74 0e                	je     801261 <strncmp+0x2b>
  801253:	8b 45 08             	mov    0x8(%ebp),%eax
  801256:	8a 10                	mov    (%eax),%dl
  801258:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125b:	8a 00                	mov    (%eax),%al
  80125d:	38 c2                	cmp    %al,%dl
  80125f:	74 da                	je     80123b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801261:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801265:	75 07                	jne    80126e <strncmp+0x38>
		return 0;
  801267:	b8 00 00 00 00       	mov    $0x0,%eax
  80126c:	eb 14                	jmp    801282 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80126e:	8b 45 08             	mov    0x8(%ebp),%eax
  801271:	8a 00                	mov    (%eax),%al
  801273:	0f b6 d0             	movzbl %al,%edx
  801276:	8b 45 0c             	mov    0xc(%ebp),%eax
  801279:	8a 00                	mov    (%eax),%al
  80127b:	0f b6 c0             	movzbl %al,%eax
  80127e:	29 c2                	sub    %eax,%edx
  801280:	89 d0                	mov    %edx,%eax
}
  801282:	5d                   	pop    %ebp
  801283:	c3                   	ret    

00801284 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801284:	55                   	push   %ebp
  801285:	89 e5                	mov    %esp,%ebp
  801287:	83 ec 04             	sub    $0x4,%esp
  80128a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801290:	eb 12                	jmp    8012a4 <strchr+0x20>
		if (*s == c)
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	8a 00                	mov    (%eax),%al
  801297:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80129a:	75 05                	jne    8012a1 <strchr+0x1d>
			return (char *) s;
  80129c:	8b 45 08             	mov    0x8(%ebp),%eax
  80129f:	eb 11                	jmp    8012b2 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012a1:	ff 45 08             	incl   0x8(%ebp)
  8012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a7:	8a 00                	mov    (%eax),%al
  8012a9:	84 c0                	test   %al,%al
  8012ab:	75 e5                	jne    801292 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8012ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012b2:	c9                   	leave  
  8012b3:	c3                   	ret    

008012b4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012b4:	55                   	push   %ebp
  8012b5:	89 e5                	mov    %esp,%ebp
  8012b7:	83 ec 04             	sub    $0x4,%esp
  8012ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8012c0:	eb 0d                	jmp    8012cf <strfind+0x1b>
		if (*s == c)
  8012c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c5:	8a 00                	mov    (%eax),%al
  8012c7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8012ca:	74 0e                	je     8012da <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012cc:	ff 45 08             	incl   0x8(%ebp)
  8012cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d2:	8a 00                	mov    (%eax),%al
  8012d4:	84 c0                	test   %al,%al
  8012d6:	75 ea                	jne    8012c2 <strfind+0xe>
  8012d8:	eb 01                	jmp    8012db <strfind+0x27>
		if (*s == c)
			break;
  8012da:	90                   	nop
	return (char *) s;
  8012db:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012de:	c9                   	leave  
  8012df:	c3                   	ret    

008012e0 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8012e0:	55                   	push   %ebp
  8012e1:	89 e5                	mov    %esp,%ebp
  8012e3:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8012e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8012ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ef:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8012f2:	eb 0e                	jmp    801302 <memset+0x22>
		*p++ = c;
  8012f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f7:	8d 50 01             	lea    0x1(%eax),%edx
  8012fa:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801300:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801302:	ff 4d f8             	decl   -0x8(%ebp)
  801305:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801309:	79 e9                	jns    8012f4 <memset+0x14>
		*p++ = c;

	return v;
  80130b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80130e:	c9                   	leave  
  80130f:	c3                   	ret    

00801310 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801310:	55                   	push   %ebp
  801311:	89 e5                	mov    %esp,%ebp
  801313:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801316:	8b 45 0c             	mov    0xc(%ebp),%eax
  801319:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80131c:	8b 45 08             	mov    0x8(%ebp),%eax
  80131f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801322:	eb 16                	jmp    80133a <memcpy+0x2a>
		*d++ = *s++;
  801324:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801327:	8d 50 01             	lea    0x1(%eax),%edx
  80132a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80132d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801330:	8d 4a 01             	lea    0x1(%edx),%ecx
  801333:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801336:	8a 12                	mov    (%edx),%dl
  801338:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80133a:	8b 45 10             	mov    0x10(%ebp),%eax
  80133d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801340:	89 55 10             	mov    %edx,0x10(%ebp)
  801343:	85 c0                	test   %eax,%eax
  801345:	75 dd                	jne    801324 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801347:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80134a:	c9                   	leave  
  80134b:	c3                   	ret    

0080134c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80134c:	55                   	push   %ebp
  80134d:	89 e5                	mov    %esp,%ebp
  80134f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801352:	8b 45 0c             	mov    0xc(%ebp),%eax
  801355:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801358:	8b 45 08             	mov    0x8(%ebp),%eax
  80135b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80135e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801361:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801364:	73 50                	jae    8013b6 <memmove+0x6a>
  801366:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801369:	8b 45 10             	mov    0x10(%ebp),%eax
  80136c:	01 d0                	add    %edx,%eax
  80136e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801371:	76 43                	jbe    8013b6 <memmove+0x6a>
		s += n;
  801373:	8b 45 10             	mov    0x10(%ebp),%eax
  801376:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801379:	8b 45 10             	mov    0x10(%ebp),%eax
  80137c:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80137f:	eb 10                	jmp    801391 <memmove+0x45>
			*--d = *--s;
  801381:	ff 4d f8             	decl   -0x8(%ebp)
  801384:	ff 4d fc             	decl   -0x4(%ebp)
  801387:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80138a:	8a 10                	mov    (%eax),%dl
  80138c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80138f:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801391:	8b 45 10             	mov    0x10(%ebp),%eax
  801394:	8d 50 ff             	lea    -0x1(%eax),%edx
  801397:	89 55 10             	mov    %edx,0x10(%ebp)
  80139a:	85 c0                	test   %eax,%eax
  80139c:	75 e3                	jne    801381 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80139e:	eb 23                	jmp    8013c3 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8013a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013a3:	8d 50 01             	lea    0x1(%eax),%edx
  8013a6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013ac:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013af:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8013b2:	8a 12                	mov    (%edx),%dl
  8013b4:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8013b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013bc:	89 55 10             	mov    %edx,0x10(%ebp)
  8013bf:	85 c0                	test   %eax,%eax
  8013c1:	75 dd                	jne    8013a0 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8013c3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013c6:	c9                   	leave  
  8013c7:	c3                   	ret    

008013c8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8013c8:	55                   	push   %ebp
  8013c9:	89 e5                	mov    %esp,%ebp
  8013cb:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8013ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8013d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d7:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8013da:	eb 2a                	jmp    801406 <memcmp+0x3e>
		if (*s1 != *s2)
  8013dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013df:	8a 10                	mov    (%eax),%dl
  8013e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013e4:	8a 00                	mov    (%eax),%al
  8013e6:	38 c2                	cmp    %al,%dl
  8013e8:	74 16                	je     801400 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8013ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013ed:	8a 00                	mov    (%eax),%al
  8013ef:	0f b6 d0             	movzbl %al,%edx
  8013f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	0f b6 c0             	movzbl %al,%eax
  8013fa:	29 c2                	sub    %eax,%edx
  8013fc:	89 d0                	mov    %edx,%eax
  8013fe:	eb 18                	jmp    801418 <memcmp+0x50>
		s1++, s2++;
  801400:	ff 45 fc             	incl   -0x4(%ebp)
  801403:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801406:	8b 45 10             	mov    0x10(%ebp),%eax
  801409:	8d 50 ff             	lea    -0x1(%eax),%edx
  80140c:	89 55 10             	mov    %edx,0x10(%ebp)
  80140f:	85 c0                	test   %eax,%eax
  801411:	75 c9                	jne    8013dc <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801413:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801418:	c9                   	leave  
  801419:	c3                   	ret    

0080141a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80141a:	55                   	push   %ebp
  80141b:	89 e5                	mov    %esp,%ebp
  80141d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801420:	8b 55 08             	mov    0x8(%ebp),%edx
  801423:	8b 45 10             	mov    0x10(%ebp),%eax
  801426:	01 d0                	add    %edx,%eax
  801428:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80142b:	eb 15                	jmp    801442 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
  801430:	8a 00                	mov    (%eax),%al
  801432:	0f b6 d0             	movzbl %al,%edx
  801435:	8b 45 0c             	mov    0xc(%ebp),%eax
  801438:	0f b6 c0             	movzbl %al,%eax
  80143b:	39 c2                	cmp    %eax,%edx
  80143d:	74 0d                	je     80144c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80143f:	ff 45 08             	incl   0x8(%ebp)
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
  801445:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801448:	72 e3                	jb     80142d <memfind+0x13>
  80144a:	eb 01                	jmp    80144d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80144c:	90                   	nop
	return (void *) s;
  80144d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801450:	c9                   	leave  
  801451:	c3                   	ret    

00801452 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801452:	55                   	push   %ebp
  801453:	89 e5                	mov    %esp,%ebp
  801455:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801458:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80145f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801466:	eb 03                	jmp    80146b <strtol+0x19>
		s++;
  801468:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80146b:	8b 45 08             	mov    0x8(%ebp),%eax
  80146e:	8a 00                	mov    (%eax),%al
  801470:	3c 20                	cmp    $0x20,%al
  801472:	74 f4                	je     801468 <strtol+0x16>
  801474:	8b 45 08             	mov    0x8(%ebp),%eax
  801477:	8a 00                	mov    (%eax),%al
  801479:	3c 09                	cmp    $0x9,%al
  80147b:	74 eb                	je     801468 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80147d:	8b 45 08             	mov    0x8(%ebp),%eax
  801480:	8a 00                	mov    (%eax),%al
  801482:	3c 2b                	cmp    $0x2b,%al
  801484:	75 05                	jne    80148b <strtol+0x39>
		s++;
  801486:	ff 45 08             	incl   0x8(%ebp)
  801489:	eb 13                	jmp    80149e <strtol+0x4c>
	else if (*s == '-')
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	8a 00                	mov    (%eax),%al
  801490:	3c 2d                	cmp    $0x2d,%al
  801492:	75 0a                	jne    80149e <strtol+0x4c>
		s++, neg = 1;
  801494:	ff 45 08             	incl   0x8(%ebp)
  801497:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80149e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014a2:	74 06                	je     8014aa <strtol+0x58>
  8014a4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8014a8:	75 20                	jne    8014ca <strtol+0x78>
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	8a 00                	mov    (%eax),%al
  8014af:	3c 30                	cmp    $0x30,%al
  8014b1:	75 17                	jne    8014ca <strtol+0x78>
  8014b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b6:	40                   	inc    %eax
  8014b7:	8a 00                	mov    (%eax),%al
  8014b9:	3c 78                	cmp    $0x78,%al
  8014bb:	75 0d                	jne    8014ca <strtol+0x78>
		s += 2, base = 16;
  8014bd:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8014c1:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8014c8:	eb 28                	jmp    8014f2 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8014ca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014ce:	75 15                	jne    8014e5 <strtol+0x93>
  8014d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d3:	8a 00                	mov    (%eax),%al
  8014d5:	3c 30                	cmp    $0x30,%al
  8014d7:	75 0c                	jne    8014e5 <strtol+0x93>
		s++, base = 8;
  8014d9:	ff 45 08             	incl   0x8(%ebp)
  8014dc:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8014e3:	eb 0d                	jmp    8014f2 <strtol+0xa0>
	else if (base == 0)
  8014e5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014e9:	75 07                	jne    8014f2 <strtol+0xa0>
		base = 10;
  8014eb:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f5:	8a 00                	mov    (%eax),%al
  8014f7:	3c 2f                	cmp    $0x2f,%al
  8014f9:	7e 19                	jle    801514 <strtol+0xc2>
  8014fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fe:	8a 00                	mov    (%eax),%al
  801500:	3c 39                	cmp    $0x39,%al
  801502:	7f 10                	jg     801514 <strtol+0xc2>
			dig = *s - '0';
  801504:	8b 45 08             	mov    0x8(%ebp),%eax
  801507:	8a 00                	mov    (%eax),%al
  801509:	0f be c0             	movsbl %al,%eax
  80150c:	83 e8 30             	sub    $0x30,%eax
  80150f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801512:	eb 42                	jmp    801556 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801514:	8b 45 08             	mov    0x8(%ebp),%eax
  801517:	8a 00                	mov    (%eax),%al
  801519:	3c 60                	cmp    $0x60,%al
  80151b:	7e 19                	jle    801536 <strtol+0xe4>
  80151d:	8b 45 08             	mov    0x8(%ebp),%eax
  801520:	8a 00                	mov    (%eax),%al
  801522:	3c 7a                	cmp    $0x7a,%al
  801524:	7f 10                	jg     801536 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801526:	8b 45 08             	mov    0x8(%ebp),%eax
  801529:	8a 00                	mov    (%eax),%al
  80152b:	0f be c0             	movsbl %al,%eax
  80152e:	83 e8 57             	sub    $0x57,%eax
  801531:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801534:	eb 20                	jmp    801556 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801536:	8b 45 08             	mov    0x8(%ebp),%eax
  801539:	8a 00                	mov    (%eax),%al
  80153b:	3c 40                	cmp    $0x40,%al
  80153d:	7e 39                	jle    801578 <strtol+0x126>
  80153f:	8b 45 08             	mov    0x8(%ebp),%eax
  801542:	8a 00                	mov    (%eax),%al
  801544:	3c 5a                	cmp    $0x5a,%al
  801546:	7f 30                	jg     801578 <strtol+0x126>
			dig = *s - 'A' + 10;
  801548:	8b 45 08             	mov    0x8(%ebp),%eax
  80154b:	8a 00                	mov    (%eax),%al
  80154d:	0f be c0             	movsbl %al,%eax
  801550:	83 e8 37             	sub    $0x37,%eax
  801553:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801559:	3b 45 10             	cmp    0x10(%ebp),%eax
  80155c:	7d 19                	jge    801577 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80155e:	ff 45 08             	incl   0x8(%ebp)
  801561:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801564:	0f af 45 10          	imul   0x10(%ebp),%eax
  801568:	89 c2                	mov    %eax,%edx
  80156a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80156d:	01 d0                	add    %edx,%eax
  80156f:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801572:	e9 7b ff ff ff       	jmp    8014f2 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801577:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801578:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80157c:	74 08                	je     801586 <strtol+0x134>
		*endptr = (char *) s;
  80157e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801581:	8b 55 08             	mov    0x8(%ebp),%edx
  801584:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801586:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80158a:	74 07                	je     801593 <strtol+0x141>
  80158c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80158f:	f7 d8                	neg    %eax
  801591:	eb 03                	jmp    801596 <strtol+0x144>
  801593:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801596:	c9                   	leave  
  801597:	c3                   	ret    

00801598 <ltostr>:

void
ltostr(long value, char *str)
{
  801598:	55                   	push   %ebp
  801599:	89 e5                	mov    %esp,%ebp
  80159b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80159e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8015a5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8015ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015b0:	79 13                	jns    8015c5 <ltostr+0x2d>
	{
		neg = 1;
  8015b2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8015b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015bc:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8015bf:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8015c2:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8015c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c8:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8015cd:	99                   	cltd   
  8015ce:	f7 f9                	idiv   %ecx
  8015d0:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8015d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015d6:	8d 50 01             	lea    0x1(%eax),%edx
  8015d9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015dc:	89 c2                	mov    %eax,%edx
  8015de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e1:	01 d0                	add    %edx,%eax
  8015e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015e6:	83 c2 30             	add    $0x30,%edx
  8015e9:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8015eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015ee:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015f3:	f7 e9                	imul   %ecx
  8015f5:	c1 fa 02             	sar    $0x2,%edx
  8015f8:	89 c8                	mov    %ecx,%eax
  8015fa:	c1 f8 1f             	sar    $0x1f,%eax
  8015fd:	29 c2                	sub    %eax,%edx
  8015ff:	89 d0                	mov    %edx,%eax
  801601:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801604:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801607:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80160c:	f7 e9                	imul   %ecx
  80160e:	c1 fa 02             	sar    $0x2,%edx
  801611:	89 c8                	mov    %ecx,%eax
  801613:	c1 f8 1f             	sar    $0x1f,%eax
  801616:	29 c2                	sub    %eax,%edx
  801618:	89 d0                	mov    %edx,%eax
  80161a:	c1 e0 02             	shl    $0x2,%eax
  80161d:	01 d0                	add    %edx,%eax
  80161f:	01 c0                	add    %eax,%eax
  801621:	29 c1                	sub    %eax,%ecx
  801623:	89 ca                	mov    %ecx,%edx
  801625:	85 d2                	test   %edx,%edx
  801627:	75 9c                	jne    8015c5 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801629:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801630:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801633:	48                   	dec    %eax
  801634:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801637:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80163b:	74 3d                	je     80167a <ltostr+0xe2>
		start = 1 ;
  80163d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801644:	eb 34                	jmp    80167a <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801646:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801649:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164c:	01 d0                	add    %edx,%eax
  80164e:	8a 00                	mov    (%eax),%al
  801650:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801653:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801656:	8b 45 0c             	mov    0xc(%ebp),%eax
  801659:	01 c2                	add    %eax,%edx
  80165b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80165e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801661:	01 c8                	add    %ecx,%eax
  801663:	8a 00                	mov    (%eax),%al
  801665:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801667:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80166a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166d:	01 c2                	add    %eax,%edx
  80166f:	8a 45 eb             	mov    -0x15(%ebp),%al
  801672:	88 02                	mov    %al,(%edx)
		start++ ;
  801674:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801677:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80167a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80167d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801680:	7c c4                	jl     801646 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801682:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801685:	8b 45 0c             	mov    0xc(%ebp),%eax
  801688:	01 d0                	add    %edx,%eax
  80168a:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80168d:	90                   	nop
  80168e:	c9                   	leave  
  80168f:	c3                   	ret    

00801690 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
  801693:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801696:	ff 75 08             	pushl  0x8(%ebp)
  801699:	e8 54 fa ff ff       	call   8010f2 <strlen>
  80169e:	83 c4 04             	add    $0x4,%esp
  8016a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8016a4:	ff 75 0c             	pushl  0xc(%ebp)
  8016a7:	e8 46 fa ff ff       	call   8010f2 <strlen>
  8016ac:	83 c4 04             	add    $0x4,%esp
  8016af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8016b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8016b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016c0:	eb 17                	jmp    8016d9 <strcconcat+0x49>
		final[s] = str1[s] ;
  8016c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c8:	01 c2                	add    %eax,%edx
  8016ca:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d0:	01 c8                	add    %ecx,%eax
  8016d2:	8a 00                	mov    (%eax),%al
  8016d4:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8016d6:	ff 45 fc             	incl   -0x4(%ebp)
  8016d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016dc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8016df:	7c e1                	jl     8016c2 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8016e1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8016e8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8016ef:	eb 1f                	jmp    801710 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8016f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016f4:	8d 50 01             	lea    0x1(%eax),%edx
  8016f7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016fa:	89 c2                	mov    %eax,%edx
  8016fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ff:	01 c2                	add    %eax,%edx
  801701:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801704:	8b 45 0c             	mov    0xc(%ebp),%eax
  801707:	01 c8                	add    %ecx,%eax
  801709:	8a 00                	mov    (%eax),%al
  80170b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80170d:	ff 45 f8             	incl   -0x8(%ebp)
  801710:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801713:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801716:	7c d9                	jl     8016f1 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801718:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80171b:	8b 45 10             	mov    0x10(%ebp),%eax
  80171e:	01 d0                	add    %edx,%eax
  801720:	c6 00 00             	movb   $0x0,(%eax)
}
  801723:	90                   	nop
  801724:	c9                   	leave  
  801725:	c3                   	ret    

00801726 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801726:	55                   	push   %ebp
  801727:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801729:	8b 45 14             	mov    0x14(%ebp),%eax
  80172c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801732:	8b 45 14             	mov    0x14(%ebp),%eax
  801735:	8b 00                	mov    (%eax),%eax
  801737:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80173e:	8b 45 10             	mov    0x10(%ebp),%eax
  801741:	01 d0                	add    %edx,%eax
  801743:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801749:	eb 0c                	jmp    801757 <strsplit+0x31>
			*string++ = 0;
  80174b:	8b 45 08             	mov    0x8(%ebp),%eax
  80174e:	8d 50 01             	lea    0x1(%eax),%edx
  801751:	89 55 08             	mov    %edx,0x8(%ebp)
  801754:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801757:	8b 45 08             	mov    0x8(%ebp),%eax
  80175a:	8a 00                	mov    (%eax),%al
  80175c:	84 c0                	test   %al,%al
  80175e:	74 18                	je     801778 <strsplit+0x52>
  801760:	8b 45 08             	mov    0x8(%ebp),%eax
  801763:	8a 00                	mov    (%eax),%al
  801765:	0f be c0             	movsbl %al,%eax
  801768:	50                   	push   %eax
  801769:	ff 75 0c             	pushl  0xc(%ebp)
  80176c:	e8 13 fb ff ff       	call   801284 <strchr>
  801771:	83 c4 08             	add    $0x8,%esp
  801774:	85 c0                	test   %eax,%eax
  801776:	75 d3                	jne    80174b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801778:	8b 45 08             	mov    0x8(%ebp),%eax
  80177b:	8a 00                	mov    (%eax),%al
  80177d:	84 c0                	test   %al,%al
  80177f:	74 5a                	je     8017db <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801781:	8b 45 14             	mov    0x14(%ebp),%eax
  801784:	8b 00                	mov    (%eax),%eax
  801786:	83 f8 0f             	cmp    $0xf,%eax
  801789:	75 07                	jne    801792 <strsplit+0x6c>
		{
			return 0;
  80178b:	b8 00 00 00 00       	mov    $0x0,%eax
  801790:	eb 66                	jmp    8017f8 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801792:	8b 45 14             	mov    0x14(%ebp),%eax
  801795:	8b 00                	mov    (%eax),%eax
  801797:	8d 48 01             	lea    0x1(%eax),%ecx
  80179a:	8b 55 14             	mov    0x14(%ebp),%edx
  80179d:	89 0a                	mov    %ecx,(%edx)
  80179f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8017a9:	01 c2                	add    %eax,%edx
  8017ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ae:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017b0:	eb 03                	jmp    8017b5 <strsplit+0x8f>
			string++;
  8017b2:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b8:	8a 00                	mov    (%eax),%al
  8017ba:	84 c0                	test   %al,%al
  8017bc:	74 8b                	je     801749 <strsplit+0x23>
  8017be:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c1:	8a 00                	mov    (%eax),%al
  8017c3:	0f be c0             	movsbl %al,%eax
  8017c6:	50                   	push   %eax
  8017c7:	ff 75 0c             	pushl  0xc(%ebp)
  8017ca:	e8 b5 fa ff ff       	call   801284 <strchr>
  8017cf:	83 c4 08             	add    $0x8,%esp
  8017d2:	85 c0                	test   %eax,%eax
  8017d4:	74 dc                	je     8017b2 <strsplit+0x8c>
			string++;
	}
  8017d6:	e9 6e ff ff ff       	jmp    801749 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8017db:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8017dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8017df:	8b 00                	mov    (%eax),%eax
  8017e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8017eb:	01 d0                	add    %edx,%eax
  8017ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8017f3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8017f8:	c9                   	leave  
  8017f9:	c3                   	ret    

008017fa <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
  8017fd:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801800:	a1 04 50 80 00       	mov    0x805004,%eax
  801805:	85 c0                	test   %eax,%eax
  801807:	74 1f                	je     801828 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801809:	e8 1d 00 00 00       	call   80182b <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80180e:	83 ec 0c             	sub    $0xc,%esp
  801811:	68 70 3e 80 00       	push   $0x803e70
  801816:	e8 55 f2 ff ff       	call   800a70 <cprintf>
  80181b:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80181e:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801825:	00 00 00 
	}
}
  801828:	90                   	nop
  801829:	c9                   	leave  
  80182a:	c3                   	ret    

0080182b <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
  80182e:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  801831:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801838:	00 00 00 
  80183b:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801842:	00 00 00 
  801845:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80184c:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  80184f:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801856:	00 00 00 
  801859:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801860:	00 00 00 
  801863:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80186a:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  80186d:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801877:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80187c:	2d 00 10 00 00       	sub    $0x1000,%eax
  801881:	a3 50 50 80 00       	mov    %eax,0x805050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801886:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  80188d:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  801890:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801897:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80189a:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  80189f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8018a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8018aa:	f7 75 f0             	divl   -0x10(%ebp)
  8018ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018b0:	29 d0                	sub    %edx,%eax
  8018b2:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  8018b5:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8018bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018bf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8018c4:	2d 00 10 00 00       	sub    $0x1000,%eax
  8018c9:	83 ec 04             	sub    $0x4,%esp
  8018cc:	6a 06                	push   $0x6
  8018ce:	ff 75 e8             	pushl  -0x18(%ebp)
  8018d1:	50                   	push   %eax
  8018d2:	e8 d4 05 00 00       	call   801eab <sys_allocate_chunk>
  8018d7:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8018da:	a1 20 51 80 00       	mov    0x805120,%eax
  8018df:	83 ec 0c             	sub    $0xc,%esp
  8018e2:	50                   	push   %eax
  8018e3:	e8 49 0c 00 00       	call   802531 <initialize_MemBlocksList>
  8018e8:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  8018eb:	a1 48 51 80 00       	mov    0x805148,%eax
  8018f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  8018f3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8018f7:	75 14                	jne    80190d <initialize_dyn_block_system+0xe2>
  8018f9:	83 ec 04             	sub    $0x4,%esp
  8018fc:	68 95 3e 80 00       	push   $0x803e95
  801901:	6a 39                	push   $0x39
  801903:	68 b3 3e 80 00       	push   $0x803eb3
  801908:	e8 af ee ff ff       	call   8007bc <_panic>
  80190d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801910:	8b 00                	mov    (%eax),%eax
  801912:	85 c0                	test   %eax,%eax
  801914:	74 10                	je     801926 <initialize_dyn_block_system+0xfb>
  801916:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801919:	8b 00                	mov    (%eax),%eax
  80191b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80191e:	8b 52 04             	mov    0x4(%edx),%edx
  801921:	89 50 04             	mov    %edx,0x4(%eax)
  801924:	eb 0b                	jmp    801931 <initialize_dyn_block_system+0x106>
  801926:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801929:	8b 40 04             	mov    0x4(%eax),%eax
  80192c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801931:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801934:	8b 40 04             	mov    0x4(%eax),%eax
  801937:	85 c0                	test   %eax,%eax
  801939:	74 0f                	je     80194a <initialize_dyn_block_system+0x11f>
  80193b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80193e:	8b 40 04             	mov    0x4(%eax),%eax
  801941:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801944:	8b 12                	mov    (%edx),%edx
  801946:	89 10                	mov    %edx,(%eax)
  801948:	eb 0a                	jmp    801954 <initialize_dyn_block_system+0x129>
  80194a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80194d:	8b 00                	mov    (%eax),%eax
  80194f:	a3 48 51 80 00       	mov    %eax,0x805148
  801954:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801957:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80195d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801960:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801967:	a1 54 51 80 00       	mov    0x805154,%eax
  80196c:	48                   	dec    %eax
  80196d:	a3 54 51 80 00       	mov    %eax,0x805154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  801972:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801975:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  80197c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80197f:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  801986:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80198a:	75 14                	jne    8019a0 <initialize_dyn_block_system+0x175>
  80198c:	83 ec 04             	sub    $0x4,%esp
  80198f:	68 c0 3e 80 00       	push   $0x803ec0
  801994:	6a 3f                	push   $0x3f
  801996:	68 b3 3e 80 00       	push   $0x803eb3
  80199b:	e8 1c ee ff ff       	call   8007bc <_panic>
  8019a0:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8019a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019a9:	89 10                	mov    %edx,(%eax)
  8019ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019ae:	8b 00                	mov    (%eax),%eax
  8019b0:	85 c0                	test   %eax,%eax
  8019b2:	74 0d                	je     8019c1 <initialize_dyn_block_system+0x196>
  8019b4:	a1 38 51 80 00       	mov    0x805138,%eax
  8019b9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019bc:	89 50 04             	mov    %edx,0x4(%eax)
  8019bf:	eb 08                	jmp    8019c9 <initialize_dyn_block_system+0x19e>
  8019c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019c4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8019c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019cc:	a3 38 51 80 00       	mov    %eax,0x805138
  8019d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8019db:	a1 44 51 80 00       	mov    0x805144,%eax
  8019e0:	40                   	inc    %eax
  8019e1:	a3 44 51 80 00       	mov    %eax,0x805144

}
  8019e6:	90                   	nop
  8019e7:	c9                   	leave  
  8019e8:	c3                   	ret    

008019e9 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8019e9:	55                   	push   %ebp
  8019ea:	89 e5                	mov    %esp,%ebp
  8019ec:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019ef:	e8 06 fe ff ff       	call   8017fa <InitializeUHeap>
	if (size == 0) return NULL ;
  8019f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8019f8:	75 07                	jne    801a01 <malloc+0x18>
  8019fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ff:	eb 7d                	jmp    801a7e <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  801a01:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801a08:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801a0f:	8b 55 08             	mov    0x8(%ebp),%edx
  801a12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a15:	01 d0                	add    %edx,%eax
  801a17:	48                   	dec    %eax
  801a18:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801a1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a1e:	ba 00 00 00 00       	mov    $0x0,%edx
  801a23:	f7 75 f0             	divl   -0x10(%ebp)
  801a26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a29:	29 d0                	sub    %edx,%eax
  801a2b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  801a2e:	e8 46 08 00 00       	call   802279 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a33:	83 f8 01             	cmp    $0x1,%eax
  801a36:	75 07                	jne    801a3f <malloc+0x56>
  801a38:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  801a3f:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  801a43:	75 34                	jne    801a79 <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  801a45:	83 ec 0c             	sub    $0xc,%esp
  801a48:	ff 75 e8             	pushl  -0x18(%ebp)
  801a4b:	e8 73 0e 00 00       	call   8028c3 <alloc_block_FF>
  801a50:	83 c4 10             	add    $0x10,%esp
  801a53:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  801a56:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801a5a:	74 16                	je     801a72 <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  801a5c:	83 ec 0c             	sub    $0xc,%esp
  801a5f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a62:	e8 ff 0b 00 00       	call   802666 <insert_sorted_allocList>
  801a67:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  801a6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a6d:	8b 40 08             	mov    0x8(%eax),%eax
  801a70:	eb 0c                	jmp    801a7e <malloc+0x95>
	             }
	             else
	             	return NULL;
  801a72:	b8 00 00 00 00       	mov    $0x0,%eax
  801a77:	eb 05                	jmp    801a7e <malloc+0x95>
	      	  }
	          else
	               return NULL;
  801a79:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  801a7e:	c9                   	leave  
  801a7f:	c3                   	ret    

00801a80 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
  801a83:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  801a86:	8b 45 08             	mov    0x8(%ebp),%eax
  801a89:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  801a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a95:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a9a:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  801a9d:	83 ec 08             	sub    $0x8,%esp
  801aa0:	ff 75 f4             	pushl  -0xc(%ebp)
  801aa3:	68 40 50 80 00       	push   $0x805040
  801aa8:	e8 61 0b 00 00       	call   80260e <find_block>
  801aad:	83 c4 10             	add    $0x10,%esp
  801ab0:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  801ab3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ab7:	0f 84 a5 00 00 00    	je     801b62 <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  801abd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ac0:	8b 40 0c             	mov    0xc(%eax),%eax
  801ac3:	83 ec 08             	sub    $0x8,%esp
  801ac6:	50                   	push   %eax
  801ac7:	ff 75 f4             	pushl  -0xc(%ebp)
  801aca:	e8 a4 03 00 00       	call   801e73 <sys_free_user_mem>
  801acf:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  801ad2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ad6:	75 17                	jne    801aef <free+0x6f>
  801ad8:	83 ec 04             	sub    $0x4,%esp
  801adb:	68 95 3e 80 00       	push   $0x803e95
  801ae0:	68 87 00 00 00       	push   $0x87
  801ae5:	68 b3 3e 80 00       	push   $0x803eb3
  801aea:	e8 cd ec ff ff       	call   8007bc <_panic>
  801aef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801af2:	8b 00                	mov    (%eax),%eax
  801af4:	85 c0                	test   %eax,%eax
  801af6:	74 10                	je     801b08 <free+0x88>
  801af8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801afb:	8b 00                	mov    (%eax),%eax
  801afd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b00:	8b 52 04             	mov    0x4(%edx),%edx
  801b03:	89 50 04             	mov    %edx,0x4(%eax)
  801b06:	eb 0b                	jmp    801b13 <free+0x93>
  801b08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b0b:	8b 40 04             	mov    0x4(%eax),%eax
  801b0e:	a3 44 50 80 00       	mov    %eax,0x805044
  801b13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b16:	8b 40 04             	mov    0x4(%eax),%eax
  801b19:	85 c0                	test   %eax,%eax
  801b1b:	74 0f                	je     801b2c <free+0xac>
  801b1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b20:	8b 40 04             	mov    0x4(%eax),%eax
  801b23:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b26:	8b 12                	mov    (%edx),%edx
  801b28:	89 10                	mov    %edx,(%eax)
  801b2a:	eb 0a                	jmp    801b36 <free+0xb6>
  801b2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b2f:	8b 00                	mov    (%eax),%eax
  801b31:	a3 40 50 80 00       	mov    %eax,0x805040
  801b36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b39:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801b3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b42:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801b49:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801b4e:	48                   	dec    %eax
  801b4f:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(theBlock);
  801b54:	83 ec 0c             	sub    $0xc,%esp
  801b57:	ff 75 ec             	pushl  -0x14(%ebp)
  801b5a:	e8 37 12 00 00       	call   802d96 <insert_sorted_with_merge_freeList>
  801b5f:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  801b62:	90                   	nop
  801b63:	c9                   	leave  
  801b64:	c3                   	ret    

00801b65 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801b65:	55                   	push   %ebp
  801b66:	89 e5                	mov    %esp,%ebp
  801b68:	83 ec 38             	sub    $0x38,%esp
  801b6b:	8b 45 10             	mov    0x10(%ebp),%eax
  801b6e:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b71:	e8 84 fc ff ff       	call   8017fa <InitializeUHeap>
	if (size == 0) return NULL ;
  801b76:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b7a:	75 07                	jne    801b83 <smalloc+0x1e>
  801b7c:	b8 00 00 00 00       	mov    $0x0,%eax
  801b81:	eb 7e                	jmp    801c01 <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  801b83:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801b8a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801b91:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b97:	01 d0                	add    %edx,%eax
  801b99:	48                   	dec    %eax
  801b9a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ba0:	ba 00 00 00 00       	mov    $0x0,%edx
  801ba5:	f7 75 f0             	divl   -0x10(%ebp)
  801ba8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bab:	29 d0                	sub    %edx,%eax
  801bad:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801bb0:	e8 c4 06 00 00       	call   802279 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801bb5:	83 f8 01             	cmp    $0x1,%eax
  801bb8:	75 42                	jne    801bfc <smalloc+0x97>

		  va = malloc(newsize) ;
  801bba:	83 ec 0c             	sub    $0xc,%esp
  801bbd:	ff 75 e8             	pushl  -0x18(%ebp)
  801bc0:	e8 24 fe ff ff       	call   8019e9 <malloc>
  801bc5:	83 c4 10             	add    $0x10,%esp
  801bc8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  801bcb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801bcf:	74 24                	je     801bf5 <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  801bd1:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801bd5:	ff 75 e4             	pushl  -0x1c(%ebp)
  801bd8:	50                   	push   %eax
  801bd9:	ff 75 e8             	pushl  -0x18(%ebp)
  801bdc:	ff 75 08             	pushl  0x8(%ebp)
  801bdf:	e8 1a 04 00 00       	call   801ffe <sys_createSharedObject>
  801be4:	83 c4 10             	add    $0x10,%esp
  801be7:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  801bea:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801bee:	78 0c                	js     801bfc <smalloc+0x97>
					  return va ;
  801bf0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bf3:	eb 0c                	jmp    801c01 <smalloc+0x9c>
				 }
				 else
					return NULL;
  801bf5:	b8 00 00 00 00       	mov    $0x0,%eax
  801bfa:	eb 05                	jmp    801c01 <smalloc+0x9c>
	  }
		  return NULL ;
  801bfc:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801c01:	c9                   	leave  
  801c02:	c3                   	ret    

00801c03 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
  801c06:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c09:	e8 ec fb ff ff       	call   8017fa <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  801c0e:	83 ec 08             	sub    $0x8,%esp
  801c11:	ff 75 0c             	pushl  0xc(%ebp)
  801c14:	ff 75 08             	pushl  0x8(%ebp)
  801c17:	e8 0c 04 00 00       	call   802028 <sys_getSizeOfSharedObject>
  801c1c:	83 c4 10             	add    $0x10,%esp
  801c1f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  801c22:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801c26:	75 07                	jne    801c2f <sget+0x2c>
  801c28:	b8 00 00 00 00       	mov    $0x0,%eax
  801c2d:	eb 75                	jmp    801ca4 <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801c2f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801c36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c3c:	01 d0                	add    %edx,%eax
  801c3e:	48                   	dec    %eax
  801c3f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c45:	ba 00 00 00 00       	mov    $0x0,%edx
  801c4a:	f7 75 f0             	divl   -0x10(%ebp)
  801c4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c50:	29 d0                	sub    %edx,%eax
  801c52:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  801c55:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801c5c:	e8 18 06 00 00       	call   802279 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c61:	83 f8 01             	cmp    $0x1,%eax
  801c64:	75 39                	jne    801c9f <sget+0x9c>

		  va = malloc(newsize) ;
  801c66:	83 ec 0c             	sub    $0xc,%esp
  801c69:	ff 75 e8             	pushl  -0x18(%ebp)
  801c6c:	e8 78 fd ff ff       	call   8019e9 <malloc>
  801c71:	83 c4 10             	add    $0x10,%esp
  801c74:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  801c77:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c7b:	74 22                	je     801c9f <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  801c7d:	83 ec 04             	sub    $0x4,%esp
  801c80:	ff 75 e0             	pushl  -0x20(%ebp)
  801c83:	ff 75 0c             	pushl  0xc(%ebp)
  801c86:	ff 75 08             	pushl  0x8(%ebp)
  801c89:	e8 b7 03 00 00       	call   802045 <sys_getSharedObject>
  801c8e:	83 c4 10             	add    $0x10,%esp
  801c91:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  801c94:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801c98:	78 05                	js     801c9f <sget+0x9c>
					  return va;
  801c9a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c9d:	eb 05                	jmp    801ca4 <sget+0xa1>
				  }
			  }
     }
         return NULL;
  801c9f:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  801ca4:	c9                   	leave  
  801ca5:	c3                   	ret    

00801ca6 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801ca6:	55                   	push   %ebp
  801ca7:	89 e5                	mov    %esp,%ebp
  801ca9:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801cac:	e8 49 fb ff ff       	call   8017fa <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801cb1:	83 ec 04             	sub    $0x4,%esp
  801cb4:	68 e4 3e 80 00       	push   $0x803ee4
  801cb9:	68 1e 01 00 00       	push   $0x11e
  801cbe:	68 b3 3e 80 00       	push   $0x803eb3
  801cc3:	e8 f4 ea ff ff       	call   8007bc <_panic>

00801cc8 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801cc8:	55                   	push   %ebp
  801cc9:	89 e5                	mov    %esp,%ebp
  801ccb:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801cce:	83 ec 04             	sub    $0x4,%esp
  801cd1:	68 0c 3f 80 00       	push   $0x803f0c
  801cd6:	68 32 01 00 00       	push   $0x132
  801cdb:	68 b3 3e 80 00       	push   $0x803eb3
  801ce0:	e8 d7 ea ff ff       	call   8007bc <_panic>

00801ce5 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
  801ce8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ceb:	83 ec 04             	sub    $0x4,%esp
  801cee:	68 30 3f 80 00       	push   $0x803f30
  801cf3:	68 3d 01 00 00       	push   $0x13d
  801cf8:	68 b3 3e 80 00       	push   $0x803eb3
  801cfd:	e8 ba ea ff ff       	call   8007bc <_panic>

00801d02 <shrink>:

}
void shrink(uint32 newSize)
{
  801d02:	55                   	push   %ebp
  801d03:	89 e5                	mov    %esp,%ebp
  801d05:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d08:	83 ec 04             	sub    $0x4,%esp
  801d0b:	68 30 3f 80 00       	push   $0x803f30
  801d10:	68 42 01 00 00       	push   $0x142
  801d15:	68 b3 3e 80 00       	push   $0x803eb3
  801d1a:	e8 9d ea ff ff       	call   8007bc <_panic>

00801d1f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801d1f:	55                   	push   %ebp
  801d20:	89 e5                	mov    %esp,%ebp
  801d22:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d25:	83 ec 04             	sub    $0x4,%esp
  801d28:	68 30 3f 80 00       	push   $0x803f30
  801d2d:	68 47 01 00 00       	push   $0x147
  801d32:	68 b3 3e 80 00       	push   $0x803eb3
  801d37:	e8 80 ea ff ff       	call   8007bc <_panic>

00801d3c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801d3c:	55                   	push   %ebp
  801d3d:	89 e5                	mov    %esp,%ebp
  801d3f:	57                   	push   %edi
  801d40:	56                   	push   %esi
  801d41:	53                   	push   %ebx
  801d42:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801d45:	8b 45 08             	mov    0x8(%ebp),%eax
  801d48:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d4b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d4e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d51:	8b 7d 18             	mov    0x18(%ebp),%edi
  801d54:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801d57:	cd 30                	int    $0x30
  801d59:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801d5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d5f:	83 c4 10             	add    $0x10,%esp
  801d62:	5b                   	pop    %ebx
  801d63:	5e                   	pop    %esi
  801d64:	5f                   	pop    %edi
  801d65:	5d                   	pop    %ebp
  801d66:	c3                   	ret    

00801d67 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801d67:	55                   	push   %ebp
  801d68:	89 e5                	mov    %esp,%ebp
  801d6a:	83 ec 04             	sub    $0x4,%esp
  801d6d:	8b 45 10             	mov    0x10(%ebp),%eax
  801d70:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801d73:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d77:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	52                   	push   %edx
  801d7f:	ff 75 0c             	pushl  0xc(%ebp)
  801d82:	50                   	push   %eax
  801d83:	6a 00                	push   $0x0
  801d85:	e8 b2 ff ff ff       	call   801d3c <syscall>
  801d8a:	83 c4 18             	add    $0x18,%esp
}
  801d8d:	90                   	nop
  801d8e:	c9                   	leave  
  801d8f:	c3                   	ret    

00801d90 <sys_cgetc>:

int
sys_cgetc(void)
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 01                	push   $0x1
  801d9f:	e8 98 ff ff ff       	call   801d3c <syscall>
  801da4:	83 c4 18             	add    $0x18,%esp
}
  801da7:	c9                   	leave  
  801da8:	c3                   	ret    

00801da9 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801da9:	55                   	push   %ebp
  801daa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801dac:	8b 55 0c             	mov    0xc(%ebp),%edx
  801daf:	8b 45 08             	mov    0x8(%ebp),%eax
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	6a 00                	push   $0x0
  801db8:	52                   	push   %edx
  801db9:	50                   	push   %eax
  801dba:	6a 05                	push   $0x5
  801dbc:	e8 7b ff ff ff       	call   801d3c <syscall>
  801dc1:	83 c4 18             	add    $0x18,%esp
}
  801dc4:	c9                   	leave  
  801dc5:	c3                   	ret    

00801dc6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801dc6:	55                   	push   %ebp
  801dc7:	89 e5                	mov    %esp,%ebp
  801dc9:	56                   	push   %esi
  801dca:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801dcb:	8b 75 18             	mov    0x18(%ebp),%esi
  801dce:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801dd1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dd4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dda:	56                   	push   %esi
  801ddb:	53                   	push   %ebx
  801ddc:	51                   	push   %ecx
  801ddd:	52                   	push   %edx
  801dde:	50                   	push   %eax
  801ddf:	6a 06                	push   $0x6
  801de1:	e8 56 ff ff ff       	call   801d3c <syscall>
  801de6:	83 c4 18             	add    $0x18,%esp
}
  801de9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dec:	5b                   	pop    %ebx
  801ded:	5e                   	pop    %esi
  801dee:	5d                   	pop    %ebp
  801def:	c3                   	ret    

00801df0 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801df3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801df6:	8b 45 08             	mov    0x8(%ebp),%eax
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	52                   	push   %edx
  801e00:	50                   	push   %eax
  801e01:	6a 07                	push   $0x7
  801e03:	e8 34 ff ff ff       	call   801d3c <syscall>
  801e08:	83 c4 18             	add    $0x18,%esp
}
  801e0b:	c9                   	leave  
  801e0c:	c3                   	ret    

00801e0d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	ff 75 0c             	pushl  0xc(%ebp)
  801e19:	ff 75 08             	pushl  0x8(%ebp)
  801e1c:	6a 08                	push   $0x8
  801e1e:	e8 19 ff ff ff       	call   801d3c <syscall>
  801e23:	83 c4 18             	add    $0x18,%esp
}
  801e26:	c9                   	leave  
  801e27:	c3                   	ret    

00801e28 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801e28:	55                   	push   %ebp
  801e29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	6a 00                	push   $0x0
  801e35:	6a 09                	push   $0x9
  801e37:	e8 00 ff ff ff       	call   801d3c <syscall>
  801e3c:	83 c4 18             	add    $0x18,%esp
}
  801e3f:	c9                   	leave  
  801e40:	c3                   	ret    

00801e41 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801e41:	55                   	push   %ebp
  801e42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 0a                	push   $0xa
  801e50:	e8 e7 fe ff ff       	call   801d3c <syscall>
  801e55:	83 c4 18             	add    $0x18,%esp
}
  801e58:	c9                   	leave  
  801e59:	c3                   	ret    

00801e5a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801e5a:	55                   	push   %ebp
  801e5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	6a 0b                	push   $0xb
  801e69:	e8 ce fe ff ff       	call   801d3c <syscall>
  801e6e:	83 c4 18             	add    $0x18,%esp
}
  801e71:	c9                   	leave  
  801e72:	c3                   	ret    

00801e73 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e73:	55                   	push   %ebp
  801e74:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	ff 75 0c             	pushl  0xc(%ebp)
  801e7f:	ff 75 08             	pushl  0x8(%ebp)
  801e82:	6a 0f                	push   $0xf
  801e84:	e8 b3 fe ff ff       	call   801d3c <syscall>
  801e89:	83 c4 18             	add    $0x18,%esp
	return;
  801e8c:	90                   	nop
}
  801e8d:	c9                   	leave  
  801e8e:	c3                   	ret    

00801e8f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e8f:	55                   	push   %ebp
  801e90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	ff 75 0c             	pushl  0xc(%ebp)
  801e9b:	ff 75 08             	pushl  0x8(%ebp)
  801e9e:	6a 10                	push   $0x10
  801ea0:	e8 97 fe ff ff       	call   801d3c <syscall>
  801ea5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ea8:	90                   	nop
}
  801ea9:	c9                   	leave  
  801eaa:	c3                   	ret    

00801eab <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801eab:	55                   	push   %ebp
  801eac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	ff 75 10             	pushl  0x10(%ebp)
  801eb5:	ff 75 0c             	pushl  0xc(%ebp)
  801eb8:	ff 75 08             	pushl  0x8(%ebp)
  801ebb:	6a 11                	push   $0x11
  801ebd:	e8 7a fe ff ff       	call   801d3c <syscall>
  801ec2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ec5:	90                   	nop
}
  801ec6:	c9                   	leave  
  801ec7:	c3                   	ret    

00801ec8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ec8:	55                   	push   %ebp
  801ec9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 0c                	push   $0xc
  801ed7:	e8 60 fe ff ff       	call   801d3c <syscall>
  801edc:	83 c4 18             	add    $0x18,%esp
}
  801edf:	c9                   	leave  
  801ee0:	c3                   	ret    

00801ee1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ee1:	55                   	push   %ebp
  801ee2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	ff 75 08             	pushl  0x8(%ebp)
  801eef:	6a 0d                	push   $0xd
  801ef1:	e8 46 fe ff ff       	call   801d3c <syscall>
  801ef6:	83 c4 18             	add    $0x18,%esp
}
  801ef9:	c9                   	leave  
  801efa:	c3                   	ret    

00801efb <sys_scarce_memory>:

void sys_scarce_memory()
{
  801efb:	55                   	push   %ebp
  801efc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	6a 00                	push   $0x0
  801f08:	6a 0e                	push   $0xe
  801f0a:	e8 2d fe ff ff       	call   801d3c <syscall>
  801f0f:	83 c4 18             	add    $0x18,%esp
}
  801f12:	90                   	nop
  801f13:	c9                   	leave  
  801f14:	c3                   	ret    

00801f15 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801f15:	55                   	push   %ebp
  801f16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801f18:	6a 00                	push   $0x0
  801f1a:	6a 00                	push   $0x0
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	6a 13                	push   $0x13
  801f24:	e8 13 fe ff ff       	call   801d3c <syscall>
  801f29:	83 c4 18             	add    $0x18,%esp
}
  801f2c:	90                   	nop
  801f2d:	c9                   	leave  
  801f2e:	c3                   	ret    

00801f2f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801f2f:	55                   	push   %ebp
  801f30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 14                	push   $0x14
  801f3e:	e8 f9 fd ff ff       	call   801d3c <syscall>
  801f43:	83 c4 18             	add    $0x18,%esp
}
  801f46:	90                   	nop
  801f47:	c9                   	leave  
  801f48:	c3                   	ret    

00801f49 <sys_cputc>:


void
sys_cputc(const char c)
{
  801f49:	55                   	push   %ebp
  801f4a:	89 e5                	mov    %esp,%ebp
  801f4c:	83 ec 04             	sub    $0x4,%esp
  801f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f52:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801f55:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f59:	6a 00                	push   $0x0
  801f5b:	6a 00                	push   $0x0
  801f5d:	6a 00                	push   $0x0
  801f5f:	6a 00                	push   $0x0
  801f61:	50                   	push   %eax
  801f62:	6a 15                	push   $0x15
  801f64:	e8 d3 fd ff ff       	call   801d3c <syscall>
  801f69:	83 c4 18             	add    $0x18,%esp
}
  801f6c:	90                   	nop
  801f6d:	c9                   	leave  
  801f6e:	c3                   	ret    

00801f6f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f6f:	55                   	push   %ebp
  801f70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f72:	6a 00                	push   $0x0
  801f74:	6a 00                	push   $0x0
  801f76:	6a 00                	push   $0x0
  801f78:	6a 00                	push   $0x0
  801f7a:	6a 00                	push   $0x0
  801f7c:	6a 16                	push   $0x16
  801f7e:	e8 b9 fd ff ff       	call   801d3c <syscall>
  801f83:	83 c4 18             	add    $0x18,%esp
}
  801f86:	90                   	nop
  801f87:	c9                   	leave  
  801f88:	c3                   	ret    

00801f89 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801f89:	55                   	push   %ebp
  801f8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8f:	6a 00                	push   $0x0
  801f91:	6a 00                	push   $0x0
  801f93:	6a 00                	push   $0x0
  801f95:	ff 75 0c             	pushl  0xc(%ebp)
  801f98:	50                   	push   %eax
  801f99:	6a 17                	push   $0x17
  801f9b:	e8 9c fd ff ff       	call   801d3c <syscall>
  801fa0:	83 c4 18             	add    $0x18,%esp
}
  801fa3:	c9                   	leave  
  801fa4:	c3                   	ret    

00801fa5 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801fa5:	55                   	push   %ebp
  801fa6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fa8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fab:	8b 45 08             	mov    0x8(%ebp),%eax
  801fae:	6a 00                	push   $0x0
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 00                	push   $0x0
  801fb4:	52                   	push   %edx
  801fb5:	50                   	push   %eax
  801fb6:	6a 1a                	push   $0x1a
  801fb8:	e8 7f fd ff ff       	call   801d3c <syscall>
  801fbd:	83 c4 18             	add    $0x18,%esp
}
  801fc0:	c9                   	leave  
  801fc1:	c3                   	ret    

00801fc2 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801fc2:	55                   	push   %ebp
  801fc3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcb:	6a 00                	push   $0x0
  801fcd:	6a 00                	push   $0x0
  801fcf:	6a 00                	push   $0x0
  801fd1:	52                   	push   %edx
  801fd2:	50                   	push   %eax
  801fd3:	6a 18                	push   $0x18
  801fd5:	e8 62 fd ff ff       	call   801d3c <syscall>
  801fda:	83 c4 18             	add    $0x18,%esp
}
  801fdd:	90                   	nop
  801fde:	c9                   	leave  
  801fdf:	c3                   	ret    

00801fe0 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801fe0:	55                   	push   %ebp
  801fe1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fe3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	52                   	push   %edx
  801ff0:	50                   	push   %eax
  801ff1:	6a 19                	push   $0x19
  801ff3:	e8 44 fd ff ff       	call   801d3c <syscall>
  801ff8:	83 c4 18             	add    $0x18,%esp
}
  801ffb:	90                   	nop
  801ffc:	c9                   	leave  
  801ffd:	c3                   	ret    

00801ffe <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ffe:	55                   	push   %ebp
  801fff:	89 e5                	mov    %esp,%ebp
  802001:	83 ec 04             	sub    $0x4,%esp
  802004:	8b 45 10             	mov    0x10(%ebp),%eax
  802007:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80200a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80200d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802011:	8b 45 08             	mov    0x8(%ebp),%eax
  802014:	6a 00                	push   $0x0
  802016:	51                   	push   %ecx
  802017:	52                   	push   %edx
  802018:	ff 75 0c             	pushl  0xc(%ebp)
  80201b:	50                   	push   %eax
  80201c:	6a 1b                	push   $0x1b
  80201e:	e8 19 fd ff ff       	call   801d3c <syscall>
  802023:	83 c4 18             	add    $0x18,%esp
}
  802026:	c9                   	leave  
  802027:	c3                   	ret    

00802028 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802028:	55                   	push   %ebp
  802029:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80202b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80202e:	8b 45 08             	mov    0x8(%ebp),%eax
  802031:	6a 00                	push   $0x0
  802033:	6a 00                	push   $0x0
  802035:	6a 00                	push   $0x0
  802037:	52                   	push   %edx
  802038:	50                   	push   %eax
  802039:	6a 1c                	push   $0x1c
  80203b:	e8 fc fc ff ff       	call   801d3c <syscall>
  802040:	83 c4 18             	add    $0x18,%esp
}
  802043:	c9                   	leave  
  802044:	c3                   	ret    

00802045 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802045:	55                   	push   %ebp
  802046:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802048:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80204b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80204e:	8b 45 08             	mov    0x8(%ebp),%eax
  802051:	6a 00                	push   $0x0
  802053:	6a 00                	push   $0x0
  802055:	51                   	push   %ecx
  802056:	52                   	push   %edx
  802057:	50                   	push   %eax
  802058:	6a 1d                	push   $0x1d
  80205a:	e8 dd fc ff ff       	call   801d3c <syscall>
  80205f:	83 c4 18             	add    $0x18,%esp
}
  802062:	c9                   	leave  
  802063:	c3                   	ret    

00802064 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802064:	55                   	push   %ebp
  802065:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802067:	8b 55 0c             	mov    0xc(%ebp),%edx
  80206a:	8b 45 08             	mov    0x8(%ebp),%eax
  80206d:	6a 00                	push   $0x0
  80206f:	6a 00                	push   $0x0
  802071:	6a 00                	push   $0x0
  802073:	52                   	push   %edx
  802074:	50                   	push   %eax
  802075:	6a 1e                	push   $0x1e
  802077:	e8 c0 fc ff ff       	call   801d3c <syscall>
  80207c:	83 c4 18             	add    $0x18,%esp
}
  80207f:	c9                   	leave  
  802080:	c3                   	ret    

00802081 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802081:	55                   	push   %ebp
  802082:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802084:	6a 00                	push   $0x0
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	6a 00                	push   $0x0
  80208e:	6a 1f                	push   $0x1f
  802090:	e8 a7 fc ff ff       	call   801d3c <syscall>
  802095:	83 c4 18             	add    $0x18,%esp
}
  802098:	c9                   	leave  
  802099:	c3                   	ret    

0080209a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80209a:	55                   	push   %ebp
  80209b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80209d:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a0:	6a 00                	push   $0x0
  8020a2:	ff 75 14             	pushl  0x14(%ebp)
  8020a5:	ff 75 10             	pushl  0x10(%ebp)
  8020a8:	ff 75 0c             	pushl  0xc(%ebp)
  8020ab:	50                   	push   %eax
  8020ac:	6a 20                	push   $0x20
  8020ae:	e8 89 fc ff ff       	call   801d3c <syscall>
  8020b3:	83 c4 18             	add    $0x18,%esp
}
  8020b6:	c9                   	leave  
  8020b7:	c3                   	ret    

008020b8 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8020b8:	55                   	push   %ebp
  8020b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8020bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020be:	6a 00                	push   $0x0
  8020c0:	6a 00                	push   $0x0
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 00                	push   $0x0
  8020c6:	50                   	push   %eax
  8020c7:	6a 21                	push   $0x21
  8020c9:	e8 6e fc ff ff       	call   801d3c <syscall>
  8020ce:	83 c4 18             	add    $0x18,%esp
}
  8020d1:	90                   	nop
  8020d2:	c9                   	leave  
  8020d3:	c3                   	ret    

008020d4 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8020d4:	55                   	push   %ebp
  8020d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8020d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020da:	6a 00                	push   $0x0
  8020dc:	6a 00                	push   $0x0
  8020de:	6a 00                	push   $0x0
  8020e0:	6a 00                	push   $0x0
  8020e2:	50                   	push   %eax
  8020e3:	6a 22                	push   $0x22
  8020e5:	e8 52 fc ff ff       	call   801d3c <syscall>
  8020ea:	83 c4 18             	add    $0x18,%esp
}
  8020ed:	c9                   	leave  
  8020ee:	c3                   	ret    

008020ef <sys_getenvid>:

int32 sys_getenvid(void)
{
  8020ef:	55                   	push   %ebp
  8020f0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8020f2:	6a 00                	push   $0x0
  8020f4:	6a 00                	push   $0x0
  8020f6:	6a 00                	push   $0x0
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 02                	push   $0x2
  8020fe:	e8 39 fc ff ff       	call   801d3c <syscall>
  802103:	83 c4 18             	add    $0x18,%esp
}
  802106:	c9                   	leave  
  802107:	c3                   	ret    

00802108 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802108:	55                   	push   %ebp
  802109:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80210b:	6a 00                	push   $0x0
  80210d:	6a 00                	push   $0x0
  80210f:	6a 00                	push   $0x0
  802111:	6a 00                	push   $0x0
  802113:	6a 00                	push   $0x0
  802115:	6a 03                	push   $0x3
  802117:	e8 20 fc ff ff       	call   801d3c <syscall>
  80211c:	83 c4 18             	add    $0x18,%esp
}
  80211f:	c9                   	leave  
  802120:	c3                   	ret    

00802121 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802121:	55                   	push   %ebp
  802122:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802124:	6a 00                	push   $0x0
  802126:	6a 00                	push   $0x0
  802128:	6a 00                	push   $0x0
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	6a 04                	push   $0x4
  802130:	e8 07 fc ff ff       	call   801d3c <syscall>
  802135:	83 c4 18             	add    $0x18,%esp
}
  802138:	c9                   	leave  
  802139:	c3                   	ret    

0080213a <sys_exit_env>:


void sys_exit_env(void)
{
  80213a:	55                   	push   %ebp
  80213b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80213d:	6a 00                	push   $0x0
  80213f:	6a 00                	push   $0x0
  802141:	6a 00                	push   $0x0
  802143:	6a 00                	push   $0x0
  802145:	6a 00                	push   $0x0
  802147:	6a 23                	push   $0x23
  802149:	e8 ee fb ff ff       	call   801d3c <syscall>
  80214e:	83 c4 18             	add    $0x18,%esp
}
  802151:	90                   	nop
  802152:	c9                   	leave  
  802153:	c3                   	ret    

00802154 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802154:	55                   	push   %ebp
  802155:	89 e5                	mov    %esp,%ebp
  802157:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80215a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80215d:	8d 50 04             	lea    0x4(%eax),%edx
  802160:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802163:	6a 00                	push   $0x0
  802165:	6a 00                	push   $0x0
  802167:	6a 00                	push   $0x0
  802169:	52                   	push   %edx
  80216a:	50                   	push   %eax
  80216b:	6a 24                	push   $0x24
  80216d:	e8 ca fb ff ff       	call   801d3c <syscall>
  802172:	83 c4 18             	add    $0x18,%esp
	return result;
  802175:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802178:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80217b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80217e:	89 01                	mov    %eax,(%ecx)
  802180:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802183:	8b 45 08             	mov    0x8(%ebp),%eax
  802186:	c9                   	leave  
  802187:	c2 04 00             	ret    $0x4

0080218a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80218a:	55                   	push   %ebp
  80218b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80218d:	6a 00                	push   $0x0
  80218f:	6a 00                	push   $0x0
  802191:	ff 75 10             	pushl  0x10(%ebp)
  802194:	ff 75 0c             	pushl  0xc(%ebp)
  802197:	ff 75 08             	pushl  0x8(%ebp)
  80219a:	6a 12                	push   $0x12
  80219c:	e8 9b fb ff ff       	call   801d3c <syscall>
  8021a1:	83 c4 18             	add    $0x18,%esp
	return ;
  8021a4:	90                   	nop
}
  8021a5:	c9                   	leave  
  8021a6:	c3                   	ret    

008021a7 <sys_rcr2>:
uint32 sys_rcr2()
{
  8021a7:	55                   	push   %ebp
  8021a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8021aa:	6a 00                	push   $0x0
  8021ac:	6a 00                	push   $0x0
  8021ae:	6a 00                	push   $0x0
  8021b0:	6a 00                	push   $0x0
  8021b2:	6a 00                	push   $0x0
  8021b4:	6a 25                	push   $0x25
  8021b6:	e8 81 fb ff ff       	call   801d3c <syscall>
  8021bb:	83 c4 18             	add    $0x18,%esp
}
  8021be:	c9                   	leave  
  8021bf:	c3                   	ret    

008021c0 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8021c0:	55                   	push   %ebp
  8021c1:	89 e5                	mov    %esp,%ebp
  8021c3:	83 ec 04             	sub    $0x4,%esp
  8021c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8021cc:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8021d0:	6a 00                	push   $0x0
  8021d2:	6a 00                	push   $0x0
  8021d4:	6a 00                	push   $0x0
  8021d6:	6a 00                	push   $0x0
  8021d8:	50                   	push   %eax
  8021d9:	6a 26                	push   $0x26
  8021db:	e8 5c fb ff ff       	call   801d3c <syscall>
  8021e0:	83 c4 18             	add    $0x18,%esp
	return ;
  8021e3:	90                   	nop
}
  8021e4:	c9                   	leave  
  8021e5:	c3                   	ret    

008021e6 <rsttst>:
void rsttst()
{
  8021e6:	55                   	push   %ebp
  8021e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8021e9:	6a 00                	push   $0x0
  8021eb:	6a 00                	push   $0x0
  8021ed:	6a 00                	push   $0x0
  8021ef:	6a 00                	push   $0x0
  8021f1:	6a 00                	push   $0x0
  8021f3:	6a 28                	push   $0x28
  8021f5:	e8 42 fb ff ff       	call   801d3c <syscall>
  8021fa:	83 c4 18             	add    $0x18,%esp
	return ;
  8021fd:	90                   	nop
}
  8021fe:	c9                   	leave  
  8021ff:	c3                   	ret    

00802200 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802200:	55                   	push   %ebp
  802201:	89 e5                	mov    %esp,%ebp
  802203:	83 ec 04             	sub    $0x4,%esp
  802206:	8b 45 14             	mov    0x14(%ebp),%eax
  802209:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80220c:	8b 55 18             	mov    0x18(%ebp),%edx
  80220f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802213:	52                   	push   %edx
  802214:	50                   	push   %eax
  802215:	ff 75 10             	pushl  0x10(%ebp)
  802218:	ff 75 0c             	pushl  0xc(%ebp)
  80221b:	ff 75 08             	pushl  0x8(%ebp)
  80221e:	6a 27                	push   $0x27
  802220:	e8 17 fb ff ff       	call   801d3c <syscall>
  802225:	83 c4 18             	add    $0x18,%esp
	return ;
  802228:	90                   	nop
}
  802229:	c9                   	leave  
  80222a:	c3                   	ret    

0080222b <chktst>:
void chktst(uint32 n)
{
  80222b:	55                   	push   %ebp
  80222c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80222e:	6a 00                	push   $0x0
  802230:	6a 00                	push   $0x0
  802232:	6a 00                	push   $0x0
  802234:	6a 00                	push   $0x0
  802236:	ff 75 08             	pushl  0x8(%ebp)
  802239:	6a 29                	push   $0x29
  80223b:	e8 fc fa ff ff       	call   801d3c <syscall>
  802240:	83 c4 18             	add    $0x18,%esp
	return ;
  802243:	90                   	nop
}
  802244:	c9                   	leave  
  802245:	c3                   	ret    

00802246 <inctst>:

void inctst()
{
  802246:	55                   	push   %ebp
  802247:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802249:	6a 00                	push   $0x0
  80224b:	6a 00                	push   $0x0
  80224d:	6a 00                	push   $0x0
  80224f:	6a 00                	push   $0x0
  802251:	6a 00                	push   $0x0
  802253:	6a 2a                	push   $0x2a
  802255:	e8 e2 fa ff ff       	call   801d3c <syscall>
  80225a:	83 c4 18             	add    $0x18,%esp
	return ;
  80225d:	90                   	nop
}
  80225e:	c9                   	leave  
  80225f:	c3                   	ret    

00802260 <gettst>:
uint32 gettst()
{
  802260:	55                   	push   %ebp
  802261:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802263:	6a 00                	push   $0x0
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	6a 00                	push   $0x0
  80226b:	6a 00                	push   $0x0
  80226d:	6a 2b                	push   $0x2b
  80226f:	e8 c8 fa ff ff       	call   801d3c <syscall>
  802274:	83 c4 18             	add    $0x18,%esp
}
  802277:	c9                   	leave  
  802278:	c3                   	ret    

00802279 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802279:	55                   	push   %ebp
  80227a:	89 e5                	mov    %esp,%ebp
  80227c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80227f:	6a 00                	push   $0x0
  802281:	6a 00                	push   $0x0
  802283:	6a 00                	push   $0x0
  802285:	6a 00                	push   $0x0
  802287:	6a 00                	push   $0x0
  802289:	6a 2c                	push   $0x2c
  80228b:	e8 ac fa ff ff       	call   801d3c <syscall>
  802290:	83 c4 18             	add    $0x18,%esp
  802293:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802296:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80229a:	75 07                	jne    8022a3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80229c:	b8 01 00 00 00       	mov    $0x1,%eax
  8022a1:	eb 05                	jmp    8022a8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8022a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022a8:	c9                   	leave  
  8022a9:	c3                   	ret    

008022aa <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8022aa:	55                   	push   %ebp
  8022ab:	89 e5                	mov    %esp,%ebp
  8022ad:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022b0:	6a 00                	push   $0x0
  8022b2:	6a 00                	push   $0x0
  8022b4:	6a 00                	push   $0x0
  8022b6:	6a 00                	push   $0x0
  8022b8:	6a 00                	push   $0x0
  8022ba:	6a 2c                	push   $0x2c
  8022bc:	e8 7b fa ff ff       	call   801d3c <syscall>
  8022c1:	83 c4 18             	add    $0x18,%esp
  8022c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8022c7:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8022cb:	75 07                	jne    8022d4 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8022cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8022d2:	eb 05                	jmp    8022d9 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8022d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022d9:	c9                   	leave  
  8022da:	c3                   	ret    

008022db <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8022db:	55                   	push   %ebp
  8022dc:	89 e5                	mov    %esp,%ebp
  8022de:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022e1:	6a 00                	push   $0x0
  8022e3:	6a 00                	push   $0x0
  8022e5:	6a 00                	push   $0x0
  8022e7:	6a 00                	push   $0x0
  8022e9:	6a 00                	push   $0x0
  8022eb:	6a 2c                	push   $0x2c
  8022ed:	e8 4a fa ff ff       	call   801d3c <syscall>
  8022f2:	83 c4 18             	add    $0x18,%esp
  8022f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8022f8:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8022fc:	75 07                	jne    802305 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8022fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802303:	eb 05                	jmp    80230a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802305:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80230a:	c9                   	leave  
  80230b:	c3                   	ret    

0080230c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80230c:	55                   	push   %ebp
  80230d:	89 e5                	mov    %esp,%ebp
  80230f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802312:	6a 00                	push   $0x0
  802314:	6a 00                	push   $0x0
  802316:	6a 00                	push   $0x0
  802318:	6a 00                	push   $0x0
  80231a:	6a 00                	push   $0x0
  80231c:	6a 2c                	push   $0x2c
  80231e:	e8 19 fa ff ff       	call   801d3c <syscall>
  802323:	83 c4 18             	add    $0x18,%esp
  802326:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802329:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80232d:	75 07                	jne    802336 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80232f:	b8 01 00 00 00       	mov    $0x1,%eax
  802334:	eb 05                	jmp    80233b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802336:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80233b:	c9                   	leave  
  80233c:	c3                   	ret    

0080233d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80233d:	55                   	push   %ebp
  80233e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802340:	6a 00                	push   $0x0
  802342:	6a 00                	push   $0x0
  802344:	6a 00                	push   $0x0
  802346:	6a 00                	push   $0x0
  802348:	ff 75 08             	pushl  0x8(%ebp)
  80234b:	6a 2d                	push   $0x2d
  80234d:	e8 ea f9 ff ff       	call   801d3c <syscall>
  802352:	83 c4 18             	add    $0x18,%esp
	return ;
  802355:	90                   	nop
}
  802356:	c9                   	leave  
  802357:	c3                   	ret    

00802358 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802358:	55                   	push   %ebp
  802359:	89 e5                	mov    %esp,%ebp
  80235b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80235c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80235f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802362:	8b 55 0c             	mov    0xc(%ebp),%edx
  802365:	8b 45 08             	mov    0x8(%ebp),%eax
  802368:	6a 00                	push   $0x0
  80236a:	53                   	push   %ebx
  80236b:	51                   	push   %ecx
  80236c:	52                   	push   %edx
  80236d:	50                   	push   %eax
  80236e:	6a 2e                	push   $0x2e
  802370:	e8 c7 f9 ff ff       	call   801d3c <syscall>
  802375:	83 c4 18             	add    $0x18,%esp
}
  802378:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80237b:	c9                   	leave  
  80237c:	c3                   	ret    

0080237d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80237d:	55                   	push   %ebp
  80237e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802380:	8b 55 0c             	mov    0xc(%ebp),%edx
  802383:	8b 45 08             	mov    0x8(%ebp),%eax
  802386:	6a 00                	push   $0x0
  802388:	6a 00                	push   $0x0
  80238a:	6a 00                	push   $0x0
  80238c:	52                   	push   %edx
  80238d:	50                   	push   %eax
  80238e:	6a 2f                	push   $0x2f
  802390:	e8 a7 f9 ff ff       	call   801d3c <syscall>
  802395:	83 c4 18             	add    $0x18,%esp
}
  802398:	c9                   	leave  
  802399:	c3                   	ret    

0080239a <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80239a:	55                   	push   %ebp
  80239b:	89 e5                	mov    %esp,%ebp
  80239d:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8023a0:	83 ec 0c             	sub    $0xc,%esp
  8023a3:	68 40 3f 80 00       	push   $0x803f40
  8023a8:	e8 c3 e6 ff ff       	call   800a70 <cprintf>
  8023ad:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8023b0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8023b7:	83 ec 0c             	sub    $0xc,%esp
  8023ba:	68 6c 3f 80 00       	push   $0x803f6c
  8023bf:	e8 ac e6 ff ff       	call   800a70 <cprintf>
  8023c4:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8023c7:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8023cb:	a1 38 51 80 00       	mov    0x805138,%eax
  8023d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023d3:	eb 56                	jmp    80242b <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8023d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023d9:	74 1c                	je     8023f7 <print_mem_block_lists+0x5d>
  8023db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023de:	8b 50 08             	mov    0x8(%eax),%edx
  8023e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e4:	8b 48 08             	mov    0x8(%eax),%ecx
  8023e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8023ed:	01 c8                	add    %ecx,%eax
  8023ef:	39 c2                	cmp    %eax,%edx
  8023f1:	73 04                	jae    8023f7 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8023f3:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8023f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fa:	8b 50 08             	mov    0x8(%eax),%edx
  8023fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802400:	8b 40 0c             	mov    0xc(%eax),%eax
  802403:	01 c2                	add    %eax,%edx
  802405:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802408:	8b 40 08             	mov    0x8(%eax),%eax
  80240b:	83 ec 04             	sub    $0x4,%esp
  80240e:	52                   	push   %edx
  80240f:	50                   	push   %eax
  802410:	68 81 3f 80 00       	push   $0x803f81
  802415:	e8 56 e6 ff ff       	call   800a70 <cprintf>
  80241a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80241d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802420:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802423:	a1 40 51 80 00       	mov    0x805140,%eax
  802428:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80242b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80242f:	74 07                	je     802438 <print_mem_block_lists+0x9e>
  802431:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802434:	8b 00                	mov    (%eax),%eax
  802436:	eb 05                	jmp    80243d <print_mem_block_lists+0xa3>
  802438:	b8 00 00 00 00       	mov    $0x0,%eax
  80243d:	a3 40 51 80 00       	mov    %eax,0x805140
  802442:	a1 40 51 80 00       	mov    0x805140,%eax
  802447:	85 c0                	test   %eax,%eax
  802449:	75 8a                	jne    8023d5 <print_mem_block_lists+0x3b>
  80244b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80244f:	75 84                	jne    8023d5 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802451:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802455:	75 10                	jne    802467 <print_mem_block_lists+0xcd>
  802457:	83 ec 0c             	sub    $0xc,%esp
  80245a:	68 90 3f 80 00       	push   $0x803f90
  80245f:	e8 0c e6 ff ff       	call   800a70 <cprintf>
  802464:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802467:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80246e:	83 ec 0c             	sub    $0xc,%esp
  802471:	68 b4 3f 80 00       	push   $0x803fb4
  802476:	e8 f5 e5 ff ff       	call   800a70 <cprintf>
  80247b:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80247e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802482:	a1 40 50 80 00       	mov    0x805040,%eax
  802487:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80248a:	eb 56                	jmp    8024e2 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80248c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802490:	74 1c                	je     8024ae <print_mem_block_lists+0x114>
  802492:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802495:	8b 50 08             	mov    0x8(%eax),%edx
  802498:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80249b:	8b 48 08             	mov    0x8(%eax),%ecx
  80249e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8024a4:	01 c8                	add    %ecx,%eax
  8024a6:	39 c2                	cmp    %eax,%edx
  8024a8:	73 04                	jae    8024ae <print_mem_block_lists+0x114>
			sorted = 0 ;
  8024aa:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8024ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b1:	8b 50 08             	mov    0x8(%eax),%edx
  8024b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ba:	01 c2                	add    %eax,%edx
  8024bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bf:	8b 40 08             	mov    0x8(%eax),%eax
  8024c2:	83 ec 04             	sub    $0x4,%esp
  8024c5:	52                   	push   %edx
  8024c6:	50                   	push   %eax
  8024c7:	68 81 3f 80 00       	push   $0x803f81
  8024cc:	e8 9f e5 ff ff       	call   800a70 <cprintf>
  8024d1:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8024d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8024da:	a1 48 50 80 00       	mov    0x805048,%eax
  8024df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024e6:	74 07                	je     8024ef <print_mem_block_lists+0x155>
  8024e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024eb:	8b 00                	mov    (%eax),%eax
  8024ed:	eb 05                	jmp    8024f4 <print_mem_block_lists+0x15a>
  8024ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f4:	a3 48 50 80 00       	mov    %eax,0x805048
  8024f9:	a1 48 50 80 00       	mov    0x805048,%eax
  8024fe:	85 c0                	test   %eax,%eax
  802500:	75 8a                	jne    80248c <print_mem_block_lists+0xf2>
  802502:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802506:	75 84                	jne    80248c <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802508:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80250c:	75 10                	jne    80251e <print_mem_block_lists+0x184>
  80250e:	83 ec 0c             	sub    $0xc,%esp
  802511:	68 cc 3f 80 00       	push   $0x803fcc
  802516:	e8 55 e5 ff ff       	call   800a70 <cprintf>
  80251b:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80251e:	83 ec 0c             	sub    $0xc,%esp
  802521:	68 40 3f 80 00       	push   $0x803f40
  802526:	e8 45 e5 ff ff       	call   800a70 <cprintf>
  80252b:	83 c4 10             	add    $0x10,%esp

}
  80252e:	90                   	nop
  80252f:	c9                   	leave  
  802530:	c3                   	ret    

00802531 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802531:	55                   	push   %ebp
  802532:	89 e5                	mov    %esp,%ebp
  802534:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  802537:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80253e:	00 00 00 
  802541:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802548:	00 00 00 
  80254b:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802552:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802555:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80255c:	e9 9e 00 00 00       	jmp    8025ff <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802561:	a1 50 50 80 00       	mov    0x805050,%eax
  802566:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802569:	c1 e2 04             	shl    $0x4,%edx
  80256c:	01 d0                	add    %edx,%eax
  80256e:	85 c0                	test   %eax,%eax
  802570:	75 14                	jne    802586 <initialize_MemBlocksList+0x55>
  802572:	83 ec 04             	sub    $0x4,%esp
  802575:	68 f4 3f 80 00       	push   $0x803ff4
  80257a:	6a 47                	push   $0x47
  80257c:	68 17 40 80 00       	push   $0x804017
  802581:	e8 36 e2 ff ff       	call   8007bc <_panic>
  802586:	a1 50 50 80 00       	mov    0x805050,%eax
  80258b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80258e:	c1 e2 04             	shl    $0x4,%edx
  802591:	01 d0                	add    %edx,%eax
  802593:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802599:	89 10                	mov    %edx,(%eax)
  80259b:	8b 00                	mov    (%eax),%eax
  80259d:	85 c0                	test   %eax,%eax
  80259f:	74 18                	je     8025b9 <initialize_MemBlocksList+0x88>
  8025a1:	a1 48 51 80 00       	mov    0x805148,%eax
  8025a6:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8025ac:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8025af:	c1 e1 04             	shl    $0x4,%ecx
  8025b2:	01 ca                	add    %ecx,%edx
  8025b4:	89 50 04             	mov    %edx,0x4(%eax)
  8025b7:	eb 12                	jmp    8025cb <initialize_MemBlocksList+0x9a>
  8025b9:	a1 50 50 80 00       	mov    0x805050,%eax
  8025be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025c1:	c1 e2 04             	shl    $0x4,%edx
  8025c4:	01 d0                	add    %edx,%eax
  8025c6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8025cb:	a1 50 50 80 00       	mov    0x805050,%eax
  8025d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025d3:	c1 e2 04             	shl    $0x4,%edx
  8025d6:	01 d0                	add    %edx,%eax
  8025d8:	a3 48 51 80 00       	mov    %eax,0x805148
  8025dd:	a1 50 50 80 00       	mov    0x805050,%eax
  8025e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025e5:	c1 e2 04             	shl    $0x4,%edx
  8025e8:	01 d0                	add    %edx,%eax
  8025ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025f1:	a1 54 51 80 00       	mov    0x805154,%eax
  8025f6:	40                   	inc    %eax
  8025f7:	a3 54 51 80 00       	mov    %eax,0x805154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  8025fc:	ff 45 f4             	incl   -0xc(%ebp)
  8025ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802602:	3b 45 08             	cmp    0x8(%ebp),%eax
  802605:	0f 82 56 ff ff ff    	jb     802561 <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  80260b:	90                   	nop
  80260c:	c9                   	leave  
  80260d:	c3                   	ret    

0080260e <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80260e:	55                   	push   %ebp
  80260f:	89 e5                	mov    %esp,%ebp
  802611:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802614:	8b 45 08             	mov    0x8(%ebp),%eax
  802617:	8b 00                	mov    (%eax),%eax
  802619:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80261c:	eb 19                	jmp    802637 <find_block+0x29>
	{
		if(element->sva == va){
  80261e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802621:	8b 40 08             	mov    0x8(%eax),%eax
  802624:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802627:	75 05                	jne    80262e <find_block+0x20>
			 		return element;
  802629:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80262c:	eb 36                	jmp    802664 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  80262e:	8b 45 08             	mov    0x8(%ebp),%eax
  802631:	8b 40 08             	mov    0x8(%eax),%eax
  802634:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802637:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80263b:	74 07                	je     802644 <find_block+0x36>
  80263d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802640:	8b 00                	mov    (%eax),%eax
  802642:	eb 05                	jmp    802649 <find_block+0x3b>
  802644:	b8 00 00 00 00       	mov    $0x0,%eax
  802649:	8b 55 08             	mov    0x8(%ebp),%edx
  80264c:	89 42 08             	mov    %eax,0x8(%edx)
  80264f:	8b 45 08             	mov    0x8(%ebp),%eax
  802652:	8b 40 08             	mov    0x8(%eax),%eax
  802655:	85 c0                	test   %eax,%eax
  802657:	75 c5                	jne    80261e <find_block+0x10>
  802659:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80265d:	75 bf                	jne    80261e <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  80265f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802664:	c9                   	leave  
  802665:	c3                   	ret    

00802666 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802666:	55                   	push   %ebp
  802667:	89 e5                	mov    %esp,%ebp
  802669:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  80266c:	a1 44 50 80 00       	mov    0x805044,%eax
  802671:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  802674:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802679:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  80267c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802680:	74 0a                	je     80268c <insert_sorted_allocList+0x26>
  802682:	8b 45 08             	mov    0x8(%ebp),%eax
  802685:	8b 40 08             	mov    0x8(%eax),%eax
  802688:	85 c0                	test   %eax,%eax
  80268a:	75 65                	jne    8026f1 <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80268c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802690:	75 14                	jne    8026a6 <insert_sorted_allocList+0x40>
  802692:	83 ec 04             	sub    $0x4,%esp
  802695:	68 f4 3f 80 00       	push   $0x803ff4
  80269a:	6a 6e                	push   $0x6e
  80269c:	68 17 40 80 00       	push   $0x804017
  8026a1:	e8 16 e1 ff ff       	call   8007bc <_panic>
  8026a6:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8026ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8026af:	89 10                	mov    %edx,(%eax)
  8026b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b4:	8b 00                	mov    (%eax),%eax
  8026b6:	85 c0                	test   %eax,%eax
  8026b8:	74 0d                	je     8026c7 <insert_sorted_allocList+0x61>
  8026ba:	a1 40 50 80 00       	mov    0x805040,%eax
  8026bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8026c2:	89 50 04             	mov    %edx,0x4(%eax)
  8026c5:	eb 08                	jmp    8026cf <insert_sorted_allocList+0x69>
  8026c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ca:	a3 44 50 80 00       	mov    %eax,0x805044
  8026cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d2:	a3 40 50 80 00       	mov    %eax,0x805040
  8026d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026e1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026e6:	40                   	inc    %eax
  8026e7:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8026ec:	e9 cf 01 00 00       	jmp    8028c0 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  8026f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f4:	8b 50 08             	mov    0x8(%eax),%edx
  8026f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fa:	8b 40 08             	mov    0x8(%eax),%eax
  8026fd:	39 c2                	cmp    %eax,%edx
  8026ff:	73 65                	jae    802766 <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802701:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802705:	75 14                	jne    80271b <insert_sorted_allocList+0xb5>
  802707:	83 ec 04             	sub    $0x4,%esp
  80270a:	68 30 40 80 00       	push   $0x804030
  80270f:	6a 72                	push   $0x72
  802711:	68 17 40 80 00       	push   $0x804017
  802716:	e8 a1 e0 ff ff       	call   8007bc <_panic>
  80271b:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802721:	8b 45 08             	mov    0x8(%ebp),%eax
  802724:	89 50 04             	mov    %edx,0x4(%eax)
  802727:	8b 45 08             	mov    0x8(%ebp),%eax
  80272a:	8b 40 04             	mov    0x4(%eax),%eax
  80272d:	85 c0                	test   %eax,%eax
  80272f:	74 0c                	je     80273d <insert_sorted_allocList+0xd7>
  802731:	a1 44 50 80 00       	mov    0x805044,%eax
  802736:	8b 55 08             	mov    0x8(%ebp),%edx
  802739:	89 10                	mov    %edx,(%eax)
  80273b:	eb 08                	jmp    802745 <insert_sorted_allocList+0xdf>
  80273d:	8b 45 08             	mov    0x8(%ebp),%eax
  802740:	a3 40 50 80 00       	mov    %eax,0x805040
  802745:	8b 45 08             	mov    0x8(%ebp),%eax
  802748:	a3 44 50 80 00       	mov    %eax,0x805044
  80274d:	8b 45 08             	mov    0x8(%ebp),%eax
  802750:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802756:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80275b:	40                   	inc    %eax
  80275c:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  802761:	e9 5a 01 00 00       	jmp    8028c0 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  802766:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802769:	8b 50 08             	mov    0x8(%eax),%edx
  80276c:	8b 45 08             	mov    0x8(%ebp),%eax
  80276f:	8b 40 08             	mov    0x8(%eax),%eax
  802772:	39 c2                	cmp    %eax,%edx
  802774:	75 70                	jne    8027e6 <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  802776:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80277a:	74 06                	je     802782 <insert_sorted_allocList+0x11c>
  80277c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802780:	75 14                	jne    802796 <insert_sorted_allocList+0x130>
  802782:	83 ec 04             	sub    $0x4,%esp
  802785:	68 54 40 80 00       	push   $0x804054
  80278a:	6a 75                	push   $0x75
  80278c:	68 17 40 80 00       	push   $0x804017
  802791:	e8 26 e0 ff ff       	call   8007bc <_panic>
  802796:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802799:	8b 10                	mov    (%eax),%edx
  80279b:	8b 45 08             	mov    0x8(%ebp),%eax
  80279e:	89 10                	mov    %edx,(%eax)
  8027a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a3:	8b 00                	mov    (%eax),%eax
  8027a5:	85 c0                	test   %eax,%eax
  8027a7:	74 0b                	je     8027b4 <insert_sorted_allocList+0x14e>
  8027a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ac:	8b 00                	mov    (%eax),%eax
  8027ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8027b1:	89 50 04             	mov    %edx,0x4(%eax)
  8027b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8027ba:	89 10                	mov    %edx,(%eax)
  8027bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027bf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027c2:	89 50 04             	mov    %edx,0x4(%eax)
  8027c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c8:	8b 00                	mov    (%eax),%eax
  8027ca:	85 c0                	test   %eax,%eax
  8027cc:	75 08                	jne    8027d6 <insert_sorted_allocList+0x170>
  8027ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d1:	a3 44 50 80 00       	mov    %eax,0x805044
  8027d6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027db:	40                   	inc    %eax
  8027dc:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  8027e1:	e9 da 00 00 00       	jmp    8028c0 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  8027e6:	a1 40 50 80 00       	mov    0x805040,%eax
  8027eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027ee:	e9 9d 00 00 00       	jmp    802890 <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  8027f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f6:	8b 00                	mov    (%eax),%eax
  8027f8:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  8027fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fe:	8b 50 08             	mov    0x8(%eax),%edx
  802801:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802804:	8b 40 08             	mov    0x8(%eax),%eax
  802807:	39 c2                	cmp    %eax,%edx
  802809:	76 7d                	jbe    802888 <insert_sorted_allocList+0x222>
  80280b:	8b 45 08             	mov    0x8(%ebp),%eax
  80280e:	8b 50 08             	mov    0x8(%eax),%edx
  802811:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802814:	8b 40 08             	mov    0x8(%eax),%eax
  802817:	39 c2                	cmp    %eax,%edx
  802819:	73 6d                	jae    802888 <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  80281b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80281f:	74 06                	je     802827 <insert_sorted_allocList+0x1c1>
  802821:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802825:	75 14                	jne    80283b <insert_sorted_allocList+0x1d5>
  802827:	83 ec 04             	sub    $0x4,%esp
  80282a:	68 54 40 80 00       	push   $0x804054
  80282f:	6a 7c                	push   $0x7c
  802831:	68 17 40 80 00       	push   $0x804017
  802836:	e8 81 df ff ff       	call   8007bc <_panic>
  80283b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283e:	8b 10                	mov    (%eax),%edx
  802840:	8b 45 08             	mov    0x8(%ebp),%eax
  802843:	89 10                	mov    %edx,(%eax)
  802845:	8b 45 08             	mov    0x8(%ebp),%eax
  802848:	8b 00                	mov    (%eax),%eax
  80284a:	85 c0                	test   %eax,%eax
  80284c:	74 0b                	je     802859 <insert_sorted_allocList+0x1f3>
  80284e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802851:	8b 00                	mov    (%eax),%eax
  802853:	8b 55 08             	mov    0x8(%ebp),%edx
  802856:	89 50 04             	mov    %edx,0x4(%eax)
  802859:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285c:	8b 55 08             	mov    0x8(%ebp),%edx
  80285f:	89 10                	mov    %edx,(%eax)
  802861:	8b 45 08             	mov    0x8(%ebp),%eax
  802864:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802867:	89 50 04             	mov    %edx,0x4(%eax)
  80286a:	8b 45 08             	mov    0x8(%ebp),%eax
  80286d:	8b 00                	mov    (%eax),%eax
  80286f:	85 c0                	test   %eax,%eax
  802871:	75 08                	jne    80287b <insert_sorted_allocList+0x215>
  802873:	8b 45 08             	mov    0x8(%ebp),%eax
  802876:	a3 44 50 80 00       	mov    %eax,0x805044
  80287b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802880:	40                   	inc    %eax
  802881:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802886:	eb 38                	jmp    8028c0 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802888:	a1 48 50 80 00       	mov    0x805048,%eax
  80288d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802890:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802894:	74 07                	je     80289d <insert_sorted_allocList+0x237>
  802896:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802899:	8b 00                	mov    (%eax),%eax
  80289b:	eb 05                	jmp    8028a2 <insert_sorted_allocList+0x23c>
  80289d:	b8 00 00 00 00       	mov    $0x0,%eax
  8028a2:	a3 48 50 80 00       	mov    %eax,0x805048
  8028a7:	a1 48 50 80 00       	mov    0x805048,%eax
  8028ac:	85 c0                	test   %eax,%eax
  8028ae:	0f 85 3f ff ff ff    	jne    8027f3 <insert_sorted_allocList+0x18d>
  8028b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028b8:	0f 85 35 ff ff ff    	jne    8027f3 <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  8028be:	eb 00                	jmp    8028c0 <insert_sorted_allocList+0x25a>
  8028c0:	90                   	nop
  8028c1:	c9                   	leave  
  8028c2:	c3                   	ret    

008028c3 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8028c3:	55                   	push   %ebp
  8028c4:	89 e5                	mov    %esp,%ebp
  8028c6:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  8028c9:	a1 38 51 80 00       	mov    0x805138,%eax
  8028ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028d1:	e9 6b 02 00 00       	jmp    802b41 <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  8028d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8028dc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028df:	0f 85 90 00 00 00    	jne    802975 <alloc_block_FF+0xb2>
			  temp=element;
  8028e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e8:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  8028eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ef:	75 17                	jne    802908 <alloc_block_FF+0x45>
  8028f1:	83 ec 04             	sub    $0x4,%esp
  8028f4:	68 88 40 80 00       	push   $0x804088
  8028f9:	68 92 00 00 00       	push   $0x92
  8028fe:	68 17 40 80 00       	push   $0x804017
  802903:	e8 b4 de ff ff       	call   8007bc <_panic>
  802908:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290b:	8b 00                	mov    (%eax),%eax
  80290d:	85 c0                	test   %eax,%eax
  80290f:	74 10                	je     802921 <alloc_block_FF+0x5e>
  802911:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802914:	8b 00                	mov    (%eax),%eax
  802916:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802919:	8b 52 04             	mov    0x4(%edx),%edx
  80291c:	89 50 04             	mov    %edx,0x4(%eax)
  80291f:	eb 0b                	jmp    80292c <alloc_block_FF+0x69>
  802921:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802924:	8b 40 04             	mov    0x4(%eax),%eax
  802927:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80292c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292f:	8b 40 04             	mov    0x4(%eax),%eax
  802932:	85 c0                	test   %eax,%eax
  802934:	74 0f                	je     802945 <alloc_block_FF+0x82>
  802936:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802939:	8b 40 04             	mov    0x4(%eax),%eax
  80293c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80293f:	8b 12                	mov    (%edx),%edx
  802941:	89 10                	mov    %edx,(%eax)
  802943:	eb 0a                	jmp    80294f <alloc_block_FF+0x8c>
  802945:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802948:	8b 00                	mov    (%eax),%eax
  80294a:	a3 38 51 80 00       	mov    %eax,0x805138
  80294f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802952:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802958:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802962:	a1 44 51 80 00       	mov    0x805144,%eax
  802967:	48                   	dec    %eax
  802968:	a3 44 51 80 00       	mov    %eax,0x805144
			  return temp;
  80296d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802970:	e9 ff 01 00 00       	jmp    802b74 <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  802975:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802978:	8b 40 0c             	mov    0xc(%eax),%eax
  80297b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80297e:	0f 86 b5 01 00 00    	jbe    802b39 <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  802984:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802987:	8b 40 0c             	mov    0xc(%eax),%eax
  80298a:	2b 45 08             	sub    0x8(%ebp),%eax
  80298d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  802990:	a1 48 51 80 00       	mov    0x805148,%eax
  802995:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  802998:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80299c:	75 17                	jne    8029b5 <alloc_block_FF+0xf2>
  80299e:	83 ec 04             	sub    $0x4,%esp
  8029a1:	68 88 40 80 00       	push   $0x804088
  8029a6:	68 99 00 00 00       	push   $0x99
  8029ab:	68 17 40 80 00       	push   $0x804017
  8029b0:	e8 07 de ff ff       	call   8007bc <_panic>
  8029b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029b8:	8b 00                	mov    (%eax),%eax
  8029ba:	85 c0                	test   %eax,%eax
  8029bc:	74 10                	je     8029ce <alloc_block_FF+0x10b>
  8029be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c1:	8b 00                	mov    (%eax),%eax
  8029c3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029c6:	8b 52 04             	mov    0x4(%edx),%edx
  8029c9:	89 50 04             	mov    %edx,0x4(%eax)
  8029cc:	eb 0b                	jmp    8029d9 <alloc_block_FF+0x116>
  8029ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d1:	8b 40 04             	mov    0x4(%eax),%eax
  8029d4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029dc:	8b 40 04             	mov    0x4(%eax),%eax
  8029df:	85 c0                	test   %eax,%eax
  8029e1:	74 0f                	je     8029f2 <alloc_block_FF+0x12f>
  8029e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e6:	8b 40 04             	mov    0x4(%eax),%eax
  8029e9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029ec:	8b 12                	mov    (%edx),%edx
  8029ee:	89 10                	mov    %edx,(%eax)
  8029f0:	eb 0a                	jmp    8029fc <alloc_block_FF+0x139>
  8029f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f5:	8b 00                	mov    (%eax),%eax
  8029f7:	a3 48 51 80 00       	mov    %eax,0x805148
  8029fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a08:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a0f:	a1 54 51 80 00       	mov    0x805154,%eax
  802a14:	48                   	dec    %eax
  802a15:	a3 54 51 80 00       	mov    %eax,0x805154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  802a1a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a1e:	75 17                	jne    802a37 <alloc_block_FF+0x174>
  802a20:	83 ec 04             	sub    $0x4,%esp
  802a23:	68 30 40 80 00       	push   $0x804030
  802a28:	68 9a 00 00 00       	push   $0x9a
  802a2d:	68 17 40 80 00       	push   $0x804017
  802a32:	e8 85 dd ff ff       	call   8007bc <_panic>
  802a37:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802a3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a40:	89 50 04             	mov    %edx,0x4(%eax)
  802a43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a46:	8b 40 04             	mov    0x4(%eax),%eax
  802a49:	85 c0                	test   %eax,%eax
  802a4b:	74 0c                	je     802a59 <alloc_block_FF+0x196>
  802a4d:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802a52:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a55:	89 10                	mov    %edx,(%eax)
  802a57:	eb 08                	jmp    802a61 <alloc_block_FF+0x19e>
  802a59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a5c:	a3 38 51 80 00       	mov    %eax,0x805138
  802a61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a64:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a6c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a72:	a1 44 51 80 00       	mov    0x805144,%eax
  802a77:	40                   	inc    %eax
  802a78:	a3 44 51 80 00       	mov    %eax,0x805144
		  // setting the size & sva
		  new_block->size=size;
  802a7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a80:	8b 55 08             	mov    0x8(%ebp),%edx
  802a83:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  802a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a89:	8b 50 08             	mov    0x8(%eax),%edx
  802a8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a8f:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  802a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a95:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a98:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  802a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9e:	8b 50 08             	mov    0x8(%eax),%edx
  802aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa4:	01 c2                	add    %eax,%edx
  802aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa9:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  802aac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aaf:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  802ab2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ab6:	75 17                	jne    802acf <alloc_block_FF+0x20c>
  802ab8:	83 ec 04             	sub    $0x4,%esp
  802abb:	68 88 40 80 00       	push   $0x804088
  802ac0:	68 a2 00 00 00       	push   $0xa2
  802ac5:	68 17 40 80 00       	push   $0x804017
  802aca:	e8 ed dc ff ff       	call   8007bc <_panic>
  802acf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad2:	8b 00                	mov    (%eax),%eax
  802ad4:	85 c0                	test   %eax,%eax
  802ad6:	74 10                	je     802ae8 <alloc_block_FF+0x225>
  802ad8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802adb:	8b 00                	mov    (%eax),%eax
  802add:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ae0:	8b 52 04             	mov    0x4(%edx),%edx
  802ae3:	89 50 04             	mov    %edx,0x4(%eax)
  802ae6:	eb 0b                	jmp    802af3 <alloc_block_FF+0x230>
  802ae8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aeb:	8b 40 04             	mov    0x4(%eax),%eax
  802aee:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802af3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af6:	8b 40 04             	mov    0x4(%eax),%eax
  802af9:	85 c0                	test   %eax,%eax
  802afb:	74 0f                	je     802b0c <alloc_block_FF+0x249>
  802afd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b00:	8b 40 04             	mov    0x4(%eax),%eax
  802b03:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b06:	8b 12                	mov    (%edx),%edx
  802b08:	89 10                	mov    %edx,(%eax)
  802b0a:	eb 0a                	jmp    802b16 <alloc_block_FF+0x253>
  802b0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0f:	8b 00                	mov    (%eax),%eax
  802b11:	a3 38 51 80 00       	mov    %eax,0x805138
  802b16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b19:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b22:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b29:	a1 44 51 80 00       	mov    0x805144,%eax
  802b2e:	48                   	dec    %eax
  802b2f:	a3 44 51 80 00       	mov    %eax,0x805144
		  return temp;
  802b34:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b37:	eb 3b                	jmp    802b74 <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802b39:	a1 40 51 80 00       	mov    0x805140,%eax
  802b3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b45:	74 07                	je     802b4e <alloc_block_FF+0x28b>
  802b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4a:	8b 00                	mov    (%eax),%eax
  802b4c:	eb 05                	jmp    802b53 <alloc_block_FF+0x290>
  802b4e:	b8 00 00 00 00       	mov    $0x0,%eax
  802b53:	a3 40 51 80 00       	mov    %eax,0x805140
  802b58:	a1 40 51 80 00       	mov    0x805140,%eax
  802b5d:	85 c0                	test   %eax,%eax
  802b5f:	0f 85 71 fd ff ff    	jne    8028d6 <alloc_block_FF+0x13>
  802b65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b69:	0f 85 67 fd ff ff    	jne    8028d6 <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  802b6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b74:	c9                   	leave  
  802b75:	c3                   	ret    

00802b76 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802b76:	55                   	push   %ebp
  802b77:	89 e5                	mov    %esp,%ebp
  802b79:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  802b7c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  802b83:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802b8a:	a1 38 51 80 00       	mov    0x805138,%eax
  802b8f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802b92:	e9 d3 00 00 00       	jmp    802c6a <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  802b97:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b9a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b9d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ba0:	0f 85 90 00 00 00    	jne    802c36 <alloc_block_BF+0xc0>
	   temp = element;
  802ba6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ba9:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  802bac:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802bb0:	75 17                	jne    802bc9 <alloc_block_BF+0x53>
  802bb2:	83 ec 04             	sub    $0x4,%esp
  802bb5:	68 88 40 80 00       	push   $0x804088
  802bba:	68 bd 00 00 00       	push   $0xbd
  802bbf:	68 17 40 80 00       	push   $0x804017
  802bc4:	e8 f3 db ff ff       	call   8007bc <_panic>
  802bc9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bcc:	8b 00                	mov    (%eax),%eax
  802bce:	85 c0                	test   %eax,%eax
  802bd0:	74 10                	je     802be2 <alloc_block_BF+0x6c>
  802bd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bd5:	8b 00                	mov    (%eax),%eax
  802bd7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bda:	8b 52 04             	mov    0x4(%edx),%edx
  802bdd:	89 50 04             	mov    %edx,0x4(%eax)
  802be0:	eb 0b                	jmp    802bed <alloc_block_BF+0x77>
  802be2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802be5:	8b 40 04             	mov    0x4(%eax),%eax
  802be8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bf0:	8b 40 04             	mov    0x4(%eax),%eax
  802bf3:	85 c0                	test   %eax,%eax
  802bf5:	74 0f                	je     802c06 <alloc_block_BF+0x90>
  802bf7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bfa:	8b 40 04             	mov    0x4(%eax),%eax
  802bfd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c00:	8b 12                	mov    (%edx),%edx
  802c02:	89 10                	mov    %edx,(%eax)
  802c04:	eb 0a                	jmp    802c10 <alloc_block_BF+0x9a>
  802c06:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c09:	8b 00                	mov    (%eax),%eax
  802c0b:	a3 38 51 80 00       	mov    %eax,0x805138
  802c10:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c13:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c19:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c1c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c23:	a1 44 51 80 00       	mov    0x805144,%eax
  802c28:	48                   	dec    %eax
  802c29:	a3 44 51 80 00       	mov    %eax,0x805144
	   return temp;
  802c2e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c31:	e9 41 01 00 00       	jmp    802d77 <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  802c36:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c39:	8b 40 0c             	mov    0xc(%eax),%eax
  802c3c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c3f:	76 21                	jbe    802c62 <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  802c41:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c44:	8b 40 0c             	mov    0xc(%eax),%eax
  802c47:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c4a:	73 16                	jae    802c62 <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  802c4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c4f:	8b 40 0c             	mov    0xc(%eax),%eax
  802c52:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  802c55:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c58:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  802c5b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802c62:	a1 40 51 80 00       	mov    0x805140,%eax
  802c67:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802c6a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c6e:	74 07                	je     802c77 <alloc_block_BF+0x101>
  802c70:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c73:	8b 00                	mov    (%eax),%eax
  802c75:	eb 05                	jmp    802c7c <alloc_block_BF+0x106>
  802c77:	b8 00 00 00 00       	mov    $0x0,%eax
  802c7c:	a3 40 51 80 00       	mov    %eax,0x805140
  802c81:	a1 40 51 80 00       	mov    0x805140,%eax
  802c86:	85 c0                	test   %eax,%eax
  802c88:	0f 85 09 ff ff ff    	jne    802b97 <alloc_block_BF+0x21>
  802c8e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c92:	0f 85 ff fe ff ff    	jne    802b97 <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  802c98:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  802c9c:	0f 85 d0 00 00 00    	jne    802d72 <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  802ca2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca8:	2b 45 08             	sub    0x8(%ebp),%eax
  802cab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  802cae:	a1 48 51 80 00       	mov    0x805148,%eax
  802cb3:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  802cb6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802cba:	75 17                	jne    802cd3 <alloc_block_BF+0x15d>
  802cbc:	83 ec 04             	sub    $0x4,%esp
  802cbf:	68 88 40 80 00       	push   $0x804088
  802cc4:	68 d1 00 00 00       	push   $0xd1
  802cc9:	68 17 40 80 00       	push   $0x804017
  802cce:	e8 e9 da ff ff       	call   8007bc <_panic>
  802cd3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cd6:	8b 00                	mov    (%eax),%eax
  802cd8:	85 c0                	test   %eax,%eax
  802cda:	74 10                	je     802cec <alloc_block_BF+0x176>
  802cdc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cdf:	8b 00                	mov    (%eax),%eax
  802ce1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ce4:	8b 52 04             	mov    0x4(%edx),%edx
  802ce7:	89 50 04             	mov    %edx,0x4(%eax)
  802cea:	eb 0b                	jmp    802cf7 <alloc_block_BF+0x181>
  802cec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cef:	8b 40 04             	mov    0x4(%eax),%eax
  802cf2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802cf7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cfa:	8b 40 04             	mov    0x4(%eax),%eax
  802cfd:	85 c0                	test   %eax,%eax
  802cff:	74 0f                	je     802d10 <alloc_block_BF+0x19a>
  802d01:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d04:	8b 40 04             	mov    0x4(%eax),%eax
  802d07:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d0a:	8b 12                	mov    (%edx),%edx
  802d0c:	89 10                	mov    %edx,(%eax)
  802d0e:	eb 0a                	jmp    802d1a <alloc_block_BF+0x1a4>
  802d10:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d13:	8b 00                	mov    (%eax),%eax
  802d15:	a3 48 51 80 00       	mov    %eax,0x805148
  802d1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d1d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d23:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d26:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d2d:	a1 54 51 80 00       	mov    0x805154,%eax
  802d32:	48                   	dec    %eax
  802d33:	a3 54 51 80 00       	mov    %eax,0x805154
	  // setting the size & sva
	  new_block->size = size;
  802d38:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d3b:	8b 55 08             	mov    0x8(%ebp),%edx
  802d3e:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  802d41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d44:	8b 50 08             	mov    0x8(%eax),%edx
  802d47:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d4a:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  802d4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d50:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d53:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  802d56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d59:	8b 50 08             	mov    0x8(%eax),%edx
  802d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5f:	01 c2                	add    %eax,%edx
  802d61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d64:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  802d67:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d6a:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  802d6d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d70:	eb 05                	jmp    802d77 <alloc_block_BF+0x201>
	 }
	 return NULL;
  802d72:	b8 00 00 00 00       	mov    $0x0,%eax


}
  802d77:	c9                   	leave  
  802d78:	c3                   	ret    

00802d79 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802d79:	55                   	push   %ebp
  802d7a:	89 e5                	mov    %esp,%ebp
  802d7c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802d7f:	83 ec 04             	sub    $0x4,%esp
  802d82:	68 a8 40 80 00       	push   $0x8040a8
  802d87:	68 e8 00 00 00       	push   $0xe8
  802d8c:	68 17 40 80 00       	push   $0x804017
  802d91:	e8 26 da ff ff       	call   8007bc <_panic>

00802d96 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802d96:	55                   	push   %ebp
  802d97:	89 e5                	mov    %esp,%ebp
  802d99:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  802d9c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802da1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  802da4:	a1 38 51 80 00       	mov    0x805138,%eax
  802da9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  802dac:	a1 44 51 80 00       	mov    0x805144,%eax
  802db1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  802db4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802db8:	75 68                	jne    802e22 <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802dba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dbe:	75 17                	jne    802dd7 <insert_sorted_with_merge_freeList+0x41>
  802dc0:	83 ec 04             	sub    $0x4,%esp
  802dc3:	68 f4 3f 80 00       	push   $0x803ff4
  802dc8:	68 36 01 00 00       	push   $0x136
  802dcd:	68 17 40 80 00       	push   $0x804017
  802dd2:	e8 e5 d9 ff ff       	call   8007bc <_panic>
  802dd7:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  802de0:	89 10                	mov    %edx,(%eax)
  802de2:	8b 45 08             	mov    0x8(%ebp),%eax
  802de5:	8b 00                	mov    (%eax),%eax
  802de7:	85 c0                	test   %eax,%eax
  802de9:	74 0d                	je     802df8 <insert_sorted_with_merge_freeList+0x62>
  802deb:	a1 38 51 80 00       	mov    0x805138,%eax
  802df0:	8b 55 08             	mov    0x8(%ebp),%edx
  802df3:	89 50 04             	mov    %edx,0x4(%eax)
  802df6:	eb 08                	jmp    802e00 <insert_sorted_with_merge_freeList+0x6a>
  802df8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e00:	8b 45 08             	mov    0x8(%ebp),%eax
  802e03:	a3 38 51 80 00       	mov    %eax,0x805138
  802e08:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e12:	a1 44 51 80 00       	mov    0x805144,%eax
  802e17:	40                   	inc    %eax
  802e18:	a3 44 51 80 00       	mov    %eax,0x805144





}
  802e1d:	e9 ba 06 00 00       	jmp    8034dc <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  802e22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e25:	8b 50 08             	mov    0x8(%eax),%edx
  802e28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e2e:	01 c2                	add    %eax,%edx
  802e30:	8b 45 08             	mov    0x8(%ebp),%eax
  802e33:	8b 40 08             	mov    0x8(%eax),%eax
  802e36:	39 c2                	cmp    %eax,%edx
  802e38:	73 68                	jae    802ea2 <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802e3a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e3e:	75 17                	jne    802e57 <insert_sorted_with_merge_freeList+0xc1>
  802e40:	83 ec 04             	sub    $0x4,%esp
  802e43:	68 30 40 80 00       	push   $0x804030
  802e48:	68 3a 01 00 00       	push   $0x13a
  802e4d:	68 17 40 80 00       	push   $0x804017
  802e52:	e8 65 d9 ff ff       	call   8007bc <_panic>
  802e57:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e60:	89 50 04             	mov    %edx,0x4(%eax)
  802e63:	8b 45 08             	mov    0x8(%ebp),%eax
  802e66:	8b 40 04             	mov    0x4(%eax),%eax
  802e69:	85 c0                	test   %eax,%eax
  802e6b:	74 0c                	je     802e79 <insert_sorted_with_merge_freeList+0xe3>
  802e6d:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e72:	8b 55 08             	mov    0x8(%ebp),%edx
  802e75:	89 10                	mov    %edx,(%eax)
  802e77:	eb 08                	jmp    802e81 <insert_sorted_with_merge_freeList+0xeb>
  802e79:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7c:	a3 38 51 80 00       	mov    %eax,0x805138
  802e81:	8b 45 08             	mov    0x8(%ebp),%eax
  802e84:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e89:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e92:	a1 44 51 80 00       	mov    0x805144,%eax
  802e97:	40                   	inc    %eax
  802e98:	a3 44 51 80 00       	mov    %eax,0x805144





}
  802e9d:	e9 3a 06 00 00       	jmp    8034dc <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  802ea2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea5:	8b 50 08             	mov    0x8(%eax),%edx
  802ea8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eab:	8b 40 0c             	mov    0xc(%eax),%eax
  802eae:	01 c2                	add    %eax,%edx
  802eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb3:	8b 40 08             	mov    0x8(%eax),%eax
  802eb6:	39 c2                	cmp    %eax,%edx
  802eb8:	0f 85 90 00 00 00    	jne    802f4e <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  802ebe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec1:	8b 50 0c             	mov    0xc(%eax),%edx
  802ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec7:	8b 40 0c             	mov    0xc(%eax),%eax
  802eca:	01 c2                	add    %eax,%edx
  802ecc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ecf:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  802ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  802edc:	8b 45 08             	mov    0x8(%ebp),%eax
  802edf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802ee6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eea:	75 17                	jne    802f03 <insert_sorted_with_merge_freeList+0x16d>
  802eec:	83 ec 04             	sub    $0x4,%esp
  802eef:	68 f4 3f 80 00       	push   $0x803ff4
  802ef4:	68 41 01 00 00       	push   $0x141
  802ef9:	68 17 40 80 00       	push   $0x804017
  802efe:	e8 b9 d8 ff ff       	call   8007bc <_panic>
  802f03:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f09:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0c:	89 10                	mov    %edx,(%eax)
  802f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f11:	8b 00                	mov    (%eax),%eax
  802f13:	85 c0                	test   %eax,%eax
  802f15:	74 0d                	je     802f24 <insert_sorted_with_merge_freeList+0x18e>
  802f17:	a1 48 51 80 00       	mov    0x805148,%eax
  802f1c:	8b 55 08             	mov    0x8(%ebp),%edx
  802f1f:	89 50 04             	mov    %edx,0x4(%eax)
  802f22:	eb 08                	jmp    802f2c <insert_sorted_with_merge_freeList+0x196>
  802f24:	8b 45 08             	mov    0x8(%ebp),%eax
  802f27:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2f:	a3 48 51 80 00       	mov    %eax,0x805148
  802f34:	8b 45 08             	mov    0x8(%ebp),%eax
  802f37:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f3e:	a1 54 51 80 00       	mov    0x805154,%eax
  802f43:	40                   	inc    %eax
  802f44:	a3 54 51 80 00       	mov    %eax,0x805154





}
  802f49:	e9 8e 05 00 00       	jmp    8034dc <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  802f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f51:	8b 50 08             	mov    0x8(%eax),%edx
  802f54:	8b 45 08             	mov    0x8(%ebp),%eax
  802f57:	8b 40 0c             	mov    0xc(%eax),%eax
  802f5a:	01 c2                	add    %eax,%edx
  802f5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f5f:	8b 40 08             	mov    0x8(%eax),%eax
  802f62:	39 c2                	cmp    %eax,%edx
  802f64:	73 68                	jae    802fce <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802f66:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f6a:	75 17                	jne    802f83 <insert_sorted_with_merge_freeList+0x1ed>
  802f6c:	83 ec 04             	sub    $0x4,%esp
  802f6f:	68 f4 3f 80 00       	push   $0x803ff4
  802f74:	68 45 01 00 00       	push   $0x145
  802f79:	68 17 40 80 00       	push   $0x804017
  802f7e:	e8 39 d8 ff ff       	call   8007bc <_panic>
  802f83:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802f89:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8c:	89 10                	mov    %edx,(%eax)
  802f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f91:	8b 00                	mov    (%eax),%eax
  802f93:	85 c0                	test   %eax,%eax
  802f95:	74 0d                	je     802fa4 <insert_sorted_with_merge_freeList+0x20e>
  802f97:	a1 38 51 80 00       	mov    0x805138,%eax
  802f9c:	8b 55 08             	mov    0x8(%ebp),%edx
  802f9f:	89 50 04             	mov    %edx,0x4(%eax)
  802fa2:	eb 08                	jmp    802fac <insert_sorted_with_merge_freeList+0x216>
  802fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fac:	8b 45 08             	mov    0x8(%ebp),%eax
  802faf:	a3 38 51 80 00       	mov    %eax,0x805138
  802fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fbe:	a1 44 51 80 00       	mov    0x805144,%eax
  802fc3:	40                   	inc    %eax
  802fc4:	a3 44 51 80 00       	mov    %eax,0x805144





}
  802fc9:	e9 0e 05 00 00       	jmp    8034dc <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  802fce:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd1:	8b 50 08             	mov    0x8(%eax),%edx
  802fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd7:	8b 40 0c             	mov    0xc(%eax),%eax
  802fda:	01 c2                	add    %eax,%edx
  802fdc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fdf:	8b 40 08             	mov    0x8(%eax),%eax
  802fe2:	39 c2                	cmp    %eax,%edx
  802fe4:	0f 85 9c 00 00 00    	jne    803086 <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  802fea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fed:	8b 50 0c             	mov    0xc(%eax),%edx
  802ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ff6:	01 c2                	add    %eax,%edx
  802ff8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ffb:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  802ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  803001:	8b 50 08             	mov    0x8(%eax),%edx
  803004:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803007:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  80300a:	8b 45 08             	mov    0x8(%ebp),%eax
  80300d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  803014:	8b 45 08             	mov    0x8(%ebp),%eax
  803017:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80301e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803022:	75 17                	jne    80303b <insert_sorted_with_merge_freeList+0x2a5>
  803024:	83 ec 04             	sub    $0x4,%esp
  803027:	68 f4 3f 80 00       	push   $0x803ff4
  80302c:	68 4d 01 00 00       	push   $0x14d
  803031:	68 17 40 80 00       	push   $0x804017
  803036:	e8 81 d7 ff ff       	call   8007bc <_panic>
  80303b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803041:	8b 45 08             	mov    0x8(%ebp),%eax
  803044:	89 10                	mov    %edx,(%eax)
  803046:	8b 45 08             	mov    0x8(%ebp),%eax
  803049:	8b 00                	mov    (%eax),%eax
  80304b:	85 c0                	test   %eax,%eax
  80304d:	74 0d                	je     80305c <insert_sorted_with_merge_freeList+0x2c6>
  80304f:	a1 48 51 80 00       	mov    0x805148,%eax
  803054:	8b 55 08             	mov    0x8(%ebp),%edx
  803057:	89 50 04             	mov    %edx,0x4(%eax)
  80305a:	eb 08                	jmp    803064 <insert_sorted_with_merge_freeList+0x2ce>
  80305c:	8b 45 08             	mov    0x8(%ebp),%eax
  80305f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803064:	8b 45 08             	mov    0x8(%ebp),%eax
  803067:	a3 48 51 80 00       	mov    %eax,0x805148
  80306c:	8b 45 08             	mov    0x8(%ebp),%eax
  80306f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803076:	a1 54 51 80 00       	mov    0x805154,%eax
  80307b:	40                   	inc    %eax
  80307c:	a3 54 51 80 00       	mov    %eax,0x805154





}
  803081:	e9 56 04 00 00       	jmp    8034dc <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  803086:	a1 38 51 80 00       	mov    0x805138,%eax
  80308b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80308e:	e9 19 04 00 00       	jmp    8034ac <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  803093:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803096:	8b 00                	mov    (%eax),%eax
  803098:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  80309b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309e:	8b 50 08             	mov    0x8(%eax),%edx
  8030a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8030a7:	01 c2                	add    %eax,%edx
  8030a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ac:	8b 40 08             	mov    0x8(%eax),%eax
  8030af:	39 c2                	cmp    %eax,%edx
  8030b1:	0f 85 ad 01 00 00    	jne    803264 <insert_sorted_with_merge_freeList+0x4ce>
  8030b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ba:	8b 50 08             	mov    0x8(%eax),%edx
  8030bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8030c3:	01 c2                	add    %eax,%edx
  8030c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030c8:	8b 40 08             	mov    0x8(%eax),%eax
  8030cb:	39 c2                	cmp    %eax,%edx
  8030cd:	0f 85 91 01 00 00    	jne    803264 <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  8030d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d6:	8b 50 0c             	mov    0xc(%eax),%edx
  8030d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030dc:	8b 48 0c             	mov    0xc(%eax),%ecx
  8030df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8030e5:	01 c8                	add    %ecx,%eax
  8030e7:	01 c2                	add    %eax,%edx
  8030e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ec:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  8030ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  8030f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  803103:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803106:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  80310d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803110:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  803117:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80311b:	75 17                	jne    803134 <insert_sorted_with_merge_freeList+0x39e>
  80311d:	83 ec 04             	sub    $0x4,%esp
  803120:	68 88 40 80 00       	push   $0x804088
  803125:	68 5b 01 00 00       	push   $0x15b
  80312a:	68 17 40 80 00       	push   $0x804017
  80312f:	e8 88 d6 ff ff       	call   8007bc <_panic>
  803134:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803137:	8b 00                	mov    (%eax),%eax
  803139:	85 c0                	test   %eax,%eax
  80313b:	74 10                	je     80314d <insert_sorted_with_merge_freeList+0x3b7>
  80313d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803140:	8b 00                	mov    (%eax),%eax
  803142:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803145:	8b 52 04             	mov    0x4(%edx),%edx
  803148:	89 50 04             	mov    %edx,0x4(%eax)
  80314b:	eb 0b                	jmp    803158 <insert_sorted_with_merge_freeList+0x3c2>
  80314d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803150:	8b 40 04             	mov    0x4(%eax),%eax
  803153:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803158:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80315b:	8b 40 04             	mov    0x4(%eax),%eax
  80315e:	85 c0                	test   %eax,%eax
  803160:	74 0f                	je     803171 <insert_sorted_with_merge_freeList+0x3db>
  803162:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803165:	8b 40 04             	mov    0x4(%eax),%eax
  803168:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80316b:	8b 12                	mov    (%edx),%edx
  80316d:	89 10                	mov    %edx,(%eax)
  80316f:	eb 0a                	jmp    80317b <insert_sorted_with_merge_freeList+0x3e5>
  803171:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803174:	8b 00                	mov    (%eax),%eax
  803176:	a3 38 51 80 00       	mov    %eax,0x805138
  80317b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80317e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803184:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803187:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80318e:	a1 44 51 80 00       	mov    0x805144,%eax
  803193:	48                   	dec    %eax
  803194:	a3 44 51 80 00       	mov    %eax,0x805144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803199:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80319d:	75 17                	jne    8031b6 <insert_sorted_with_merge_freeList+0x420>
  80319f:	83 ec 04             	sub    $0x4,%esp
  8031a2:	68 f4 3f 80 00       	push   $0x803ff4
  8031a7:	68 5c 01 00 00       	push   $0x15c
  8031ac:	68 17 40 80 00       	push   $0x804017
  8031b1:	e8 06 d6 ff ff       	call   8007bc <_panic>
  8031b6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bf:	89 10                	mov    %edx,(%eax)
  8031c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c4:	8b 00                	mov    (%eax),%eax
  8031c6:	85 c0                	test   %eax,%eax
  8031c8:	74 0d                	je     8031d7 <insert_sorted_with_merge_freeList+0x441>
  8031ca:	a1 48 51 80 00       	mov    0x805148,%eax
  8031cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8031d2:	89 50 04             	mov    %edx,0x4(%eax)
  8031d5:	eb 08                	jmp    8031df <insert_sorted_with_merge_freeList+0x449>
  8031d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031da:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031df:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e2:	a3 48 51 80 00       	mov    %eax,0x805148
  8031e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031f1:	a1 54 51 80 00       	mov    0x805154,%eax
  8031f6:	40                   	inc    %eax
  8031f7:	a3 54 51 80 00       	mov    %eax,0x805154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  8031fc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803200:	75 17                	jne    803219 <insert_sorted_with_merge_freeList+0x483>
  803202:	83 ec 04             	sub    $0x4,%esp
  803205:	68 f4 3f 80 00       	push   $0x803ff4
  80320a:	68 5d 01 00 00       	push   $0x15d
  80320f:	68 17 40 80 00       	push   $0x804017
  803214:	e8 a3 d5 ff ff       	call   8007bc <_panic>
  803219:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80321f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803222:	89 10                	mov    %edx,(%eax)
  803224:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803227:	8b 00                	mov    (%eax),%eax
  803229:	85 c0                	test   %eax,%eax
  80322b:	74 0d                	je     80323a <insert_sorted_with_merge_freeList+0x4a4>
  80322d:	a1 48 51 80 00       	mov    0x805148,%eax
  803232:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803235:	89 50 04             	mov    %edx,0x4(%eax)
  803238:	eb 08                	jmp    803242 <insert_sorted_with_merge_freeList+0x4ac>
  80323a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80323d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803242:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803245:	a3 48 51 80 00       	mov    %eax,0x805148
  80324a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80324d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803254:	a1 54 51 80 00       	mov    0x805154,%eax
  803259:	40                   	inc    %eax
  80325a:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  80325f:	e9 78 02 00 00       	jmp    8034dc <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  803264:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803267:	8b 50 08             	mov    0x8(%eax),%edx
  80326a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326d:	8b 40 0c             	mov    0xc(%eax),%eax
  803270:	01 c2                	add    %eax,%edx
  803272:	8b 45 08             	mov    0x8(%ebp),%eax
  803275:	8b 40 08             	mov    0x8(%eax),%eax
  803278:	39 c2                	cmp    %eax,%edx
  80327a:	0f 83 b8 00 00 00    	jae    803338 <insert_sorted_with_merge_freeList+0x5a2>
  803280:	8b 45 08             	mov    0x8(%ebp),%eax
  803283:	8b 50 08             	mov    0x8(%eax),%edx
  803286:	8b 45 08             	mov    0x8(%ebp),%eax
  803289:	8b 40 0c             	mov    0xc(%eax),%eax
  80328c:	01 c2                	add    %eax,%edx
  80328e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803291:	8b 40 08             	mov    0x8(%eax),%eax
  803294:	39 c2                	cmp    %eax,%edx
  803296:	0f 85 9c 00 00 00    	jne    803338 <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  80329c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80329f:	8b 50 0c             	mov    0xc(%eax),%edx
  8032a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8032a8:	01 c2                	add    %eax,%edx
  8032aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032ad:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  8032b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b3:	8b 50 08             	mov    0x8(%eax),%edx
  8032b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032b9:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  8032bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  8032c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8032d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032d4:	75 17                	jne    8032ed <insert_sorted_with_merge_freeList+0x557>
  8032d6:	83 ec 04             	sub    $0x4,%esp
  8032d9:	68 f4 3f 80 00       	push   $0x803ff4
  8032de:	68 67 01 00 00       	push   $0x167
  8032e3:	68 17 40 80 00       	push   $0x804017
  8032e8:	e8 cf d4 ff ff       	call   8007bc <_panic>
  8032ed:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f6:	89 10                	mov    %edx,(%eax)
  8032f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fb:	8b 00                	mov    (%eax),%eax
  8032fd:	85 c0                	test   %eax,%eax
  8032ff:	74 0d                	je     80330e <insert_sorted_with_merge_freeList+0x578>
  803301:	a1 48 51 80 00       	mov    0x805148,%eax
  803306:	8b 55 08             	mov    0x8(%ebp),%edx
  803309:	89 50 04             	mov    %edx,0x4(%eax)
  80330c:	eb 08                	jmp    803316 <insert_sorted_with_merge_freeList+0x580>
  80330e:	8b 45 08             	mov    0x8(%ebp),%eax
  803311:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803316:	8b 45 08             	mov    0x8(%ebp),%eax
  803319:	a3 48 51 80 00       	mov    %eax,0x805148
  80331e:	8b 45 08             	mov    0x8(%ebp),%eax
  803321:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803328:	a1 54 51 80 00       	mov    0x805154,%eax
  80332d:	40                   	inc    %eax
  80332e:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  803333:	e9 a4 01 00 00       	jmp    8034dc <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  803338:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333b:	8b 50 08             	mov    0x8(%eax),%edx
  80333e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803341:	8b 40 0c             	mov    0xc(%eax),%eax
  803344:	01 c2                	add    %eax,%edx
  803346:	8b 45 08             	mov    0x8(%ebp),%eax
  803349:	8b 40 08             	mov    0x8(%eax),%eax
  80334c:	39 c2                	cmp    %eax,%edx
  80334e:	0f 85 ac 00 00 00    	jne    803400 <insert_sorted_with_merge_freeList+0x66a>
  803354:	8b 45 08             	mov    0x8(%ebp),%eax
  803357:	8b 50 08             	mov    0x8(%eax),%edx
  80335a:	8b 45 08             	mov    0x8(%ebp),%eax
  80335d:	8b 40 0c             	mov    0xc(%eax),%eax
  803360:	01 c2                	add    %eax,%edx
  803362:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803365:	8b 40 08             	mov    0x8(%eax),%eax
  803368:	39 c2                	cmp    %eax,%edx
  80336a:	0f 83 90 00 00 00    	jae    803400 <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  803370:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803373:	8b 50 0c             	mov    0xc(%eax),%edx
  803376:	8b 45 08             	mov    0x8(%ebp),%eax
  803379:	8b 40 0c             	mov    0xc(%eax),%eax
  80337c:	01 c2                	add    %eax,%edx
  80337e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803381:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  803384:	8b 45 08             	mov    0x8(%ebp),%eax
  803387:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  80338e:	8b 45 08             	mov    0x8(%ebp),%eax
  803391:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803398:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80339c:	75 17                	jne    8033b5 <insert_sorted_with_merge_freeList+0x61f>
  80339e:	83 ec 04             	sub    $0x4,%esp
  8033a1:	68 f4 3f 80 00       	push   $0x803ff4
  8033a6:	68 70 01 00 00       	push   $0x170
  8033ab:	68 17 40 80 00       	push   $0x804017
  8033b0:	e8 07 d4 ff ff       	call   8007bc <_panic>
  8033b5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033be:	89 10                	mov    %edx,(%eax)
  8033c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c3:	8b 00                	mov    (%eax),%eax
  8033c5:	85 c0                	test   %eax,%eax
  8033c7:	74 0d                	je     8033d6 <insert_sorted_with_merge_freeList+0x640>
  8033c9:	a1 48 51 80 00       	mov    0x805148,%eax
  8033ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8033d1:	89 50 04             	mov    %edx,0x4(%eax)
  8033d4:	eb 08                	jmp    8033de <insert_sorted_with_merge_freeList+0x648>
  8033d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033de:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e1:	a3 48 51 80 00       	mov    %eax,0x805148
  8033e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033f0:	a1 54 51 80 00       	mov    0x805154,%eax
  8033f5:	40                   	inc    %eax
  8033f6:	a3 54 51 80 00       	mov    %eax,0x805154
	      break;
  8033fb:	e9 dc 00 00 00       	jmp    8034dc <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  803400:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803403:	8b 50 08             	mov    0x8(%eax),%edx
  803406:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803409:	8b 40 0c             	mov    0xc(%eax),%eax
  80340c:	01 c2                	add    %eax,%edx
  80340e:	8b 45 08             	mov    0x8(%ebp),%eax
  803411:	8b 40 08             	mov    0x8(%eax),%eax
  803414:	39 c2                	cmp    %eax,%edx
  803416:	0f 83 88 00 00 00    	jae    8034a4 <insert_sorted_with_merge_freeList+0x70e>
  80341c:	8b 45 08             	mov    0x8(%ebp),%eax
  80341f:	8b 50 08             	mov    0x8(%eax),%edx
  803422:	8b 45 08             	mov    0x8(%ebp),%eax
  803425:	8b 40 0c             	mov    0xc(%eax),%eax
  803428:	01 c2                	add    %eax,%edx
  80342a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80342d:	8b 40 08             	mov    0x8(%eax),%eax
  803430:	39 c2                	cmp    %eax,%edx
  803432:	73 70                	jae    8034a4 <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  803434:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803438:	74 06                	je     803440 <insert_sorted_with_merge_freeList+0x6aa>
  80343a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80343e:	75 17                	jne    803457 <insert_sorted_with_merge_freeList+0x6c1>
  803440:	83 ec 04             	sub    $0x4,%esp
  803443:	68 54 40 80 00       	push   $0x804054
  803448:	68 75 01 00 00       	push   $0x175
  80344d:	68 17 40 80 00       	push   $0x804017
  803452:	e8 65 d3 ff ff       	call   8007bc <_panic>
  803457:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345a:	8b 10                	mov    (%eax),%edx
  80345c:	8b 45 08             	mov    0x8(%ebp),%eax
  80345f:	89 10                	mov    %edx,(%eax)
  803461:	8b 45 08             	mov    0x8(%ebp),%eax
  803464:	8b 00                	mov    (%eax),%eax
  803466:	85 c0                	test   %eax,%eax
  803468:	74 0b                	je     803475 <insert_sorted_with_merge_freeList+0x6df>
  80346a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346d:	8b 00                	mov    (%eax),%eax
  80346f:	8b 55 08             	mov    0x8(%ebp),%edx
  803472:	89 50 04             	mov    %edx,0x4(%eax)
  803475:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803478:	8b 55 08             	mov    0x8(%ebp),%edx
  80347b:	89 10                	mov    %edx,(%eax)
  80347d:	8b 45 08             	mov    0x8(%ebp),%eax
  803480:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803483:	89 50 04             	mov    %edx,0x4(%eax)
  803486:	8b 45 08             	mov    0x8(%ebp),%eax
  803489:	8b 00                	mov    (%eax),%eax
  80348b:	85 c0                	test   %eax,%eax
  80348d:	75 08                	jne    803497 <insert_sorted_with_merge_freeList+0x701>
  80348f:	8b 45 08             	mov    0x8(%ebp),%eax
  803492:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803497:	a1 44 51 80 00       	mov    0x805144,%eax
  80349c:	40                   	inc    %eax
  80349d:	a3 44 51 80 00       	mov    %eax,0x805144
	      break;
  8034a2:	eb 38                	jmp    8034dc <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  8034a4:	a1 40 51 80 00       	mov    0x805140,%eax
  8034a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034b0:	74 07                	je     8034b9 <insert_sorted_with_merge_freeList+0x723>
  8034b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b5:	8b 00                	mov    (%eax),%eax
  8034b7:	eb 05                	jmp    8034be <insert_sorted_with_merge_freeList+0x728>
  8034b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8034be:	a3 40 51 80 00       	mov    %eax,0x805140
  8034c3:	a1 40 51 80 00       	mov    0x805140,%eax
  8034c8:	85 c0                	test   %eax,%eax
  8034ca:	0f 85 c3 fb ff ff    	jne    803093 <insert_sorted_with_merge_freeList+0x2fd>
  8034d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034d4:	0f 85 b9 fb ff ff    	jne    803093 <insert_sorted_with_merge_freeList+0x2fd>





}
  8034da:	eb 00                	jmp    8034dc <insert_sorted_with_merge_freeList+0x746>
  8034dc:	90                   	nop
  8034dd:	c9                   	leave  
  8034de:	c3                   	ret    
  8034df:	90                   	nop

008034e0 <__udivdi3>:
  8034e0:	55                   	push   %ebp
  8034e1:	57                   	push   %edi
  8034e2:	56                   	push   %esi
  8034e3:	53                   	push   %ebx
  8034e4:	83 ec 1c             	sub    $0x1c,%esp
  8034e7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8034eb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8034ef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034f3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8034f7:	89 ca                	mov    %ecx,%edx
  8034f9:	89 f8                	mov    %edi,%eax
  8034fb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8034ff:	85 f6                	test   %esi,%esi
  803501:	75 2d                	jne    803530 <__udivdi3+0x50>
  803503:	39 cf                	cmp    %ecx,%edi
  803505:	77 65                	ja     80356c <__udivdi3+0x8c>
  803507:	89 fd                	mov    %edi,%ebp
  803509:	85 ff                	test   %edi,%edi
  80350b:	75 0b                	jne    803518 <__udivdi3+0x38>
  80350d:	b8 01 00 00 00       	mov    $0x1,%eax
  803512:	31 d2                	xor    %edx,%edx
  803514:	f7 f7                	div    %edi
  803516:	89 c5                	mov    %eax,%ebp
  803518:	31 d2                	xor    %edx,%edx
  80351a:	89 c8                	mov    %ecx,%eax
  80351c:	f7 f5                	div    %ebp
  80351e:	89 c1                	mov    %eax,%ecx
  803520:	89 d8                	mov    %ebx,%eax
  803522:	f7 f5                	div    %ebp
  803524:	89 cf                	mov    %ecx,%edi
  803526:	89 fa                	mov    %edi,%edx
  803528:	83 c4 1c             	add    $0x1c,%esp
  80352b:	5b                   	pop    %ebx
  80352c:	5e                   	pop    %esi
  80352d:	5f                   	pop    %edi
  80352e:	5d                   	pop    %ebp
  80352f:	c3                   	ret    
  803530:	39 ce                	cmp    %ecx,%esi
  803532:	77 28                	ja     80355c <__udivdi3+0x7c>
  803534:	0f bd fe             	bsr    %esi,%edi
  803537:	83 f7 1f             	xor    $0x1f,%edi
  80353a:	75 40                	jne    80357c <__udivdi3+0x9c>
  80353c:	39 ce                	cmp    %ecx,%esi
  80353e:	72 0a                	jb     80354a <__udivdi3+0x6a>
  803540:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803544:	0f 87 9e 00 00 00    	ja     8035e8 <__udivdi3+0x108>
  80354a:	b8 01 00 00 00       	mov    $0x1,%eax
  80354f:	89 fa                	mov    %edi,%edx
  803551:	83 c4 1c             	add    $0x1c,%esp
  803554:	5b                   	pop    %ebx
  803555:	5e                   	pop    %esi
  803556:	5f                   	pop    %edi
  803557:	5d                   	pop    %ebp
  803558:	c3                   	ret    
  803559:	8d 76 00             	lea    0x0(%esi),%esi
  80355c:	31 ff                	xor    %edi,%edi
  80355e:	31 c0                	xor    %eax,%eax
  803560:	89 fa                	mov    %edi,%edx
  803562:	83 c4 1c             	add    $0x1c,%esp
  803565:	5b                   	pop    %ebx
  803566:	5e                   	pop    %esi
  803567:	5f                   	pop    %edi
  803568:	5d                   	pop    %ebp
  803569:	c3                   	ret    
  80356a:	66 90                	xchg   %ax,%ax
  80356c:	89 d8                	mov    %ebx,%eax
  80356e:	f7 f7                	div    %edi
  803570:	31 ff                	xor    %edi,%edi
  803572:	89 fa                	mov    %edi,%edx
  803574:	83 c4 1c             	add    $0x1c,%esp
  803577:	5b                   	pop    %ebx
  803578:	5e                   	pop    %esi
  803579:	5f                   	pop    %edi
  80357a:	5d                   	pop    %ebp
  80357b:	c3                   	ret    
  80357c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803581:	89 eb                	mov    %ebp,%ebx
  803583:	29 fb                	sub    %edi,%ebx
  803585:	89 f9                	mov    %edi,%ecx
  803587:	d3 e6                	shl    %cl,%esi
  803589:	89 c5                	mov    %eax,%ebp
  80358b:	88 d9                	mov    %bl,%cl
  80358d:	d3 ed                	shr    %cl,%ebp
  80358f:	89 e9                	mov    %ebp,%ecx
  803591:	09 f1                	or     %esi,%ecx
  803593:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803597:	89 f9                	mov    %edi,%ecx
  803599:	d3 e0                	shl    %cl,%eax
  80359b:	89 c5                	mov    %eax,%ebp
  80359d:	89 d6                	mov    %edx,%esi
  80359f:	88 d9                	mov    %bl,%cl
  8035a1:	d3 ee                	shr    %cl,%esi
  8035a3:	89 f9                	mov    %edi,%ecx
  8035a5:	d3 e2                	shl    %cl,%edx
  8035a7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035ab:	88 d9                	mov    %bl,%cl
  8035ad:	d3 e8                	shr    %cl,%eax
  8035af:	09 c2                	or     %eax,%edx
  8035b1:	89 d0                	mov    %edx,%eax
  8035b3:	89 f2                	mov    %esi,%edx
  8035b5:	f7 74 24 0c          	divl   0xc(%esp)
  8035b9:	89 d6                	mov    %edx,%esi
  8035bb:	89 c3                	mov    %eax,%ebx
  8035bd:	f7 e5                	mul    %ebp
  8035bf:	39 d6                	cmp    %edx,%esi
  8035c1:	72 19                	jb     8035dc <__udivdi3+0xfc>
  8035c3:	74 0b                	je     8035d0 <__udivdi3+0xf0>
  8035c5:	89 d8                	mov    %ebx,%eax
  8035c7:	31 ff                	xor    %edi,%edi
  8035c9:	e9 58 ff ff ff       	jmp    803526 <__udivdi3+0x46>
  8035ce:	66 90                	xchg   %ax,%ax
  8035d0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8035d4:	89 f9                	mov    %edi,%ecx
  8035d6:	d3 e2                	shl    %cl,%edx
  8035d8:	39 c2                	cmp    %eax,%edx
  8035da:	73 e9                	jae    8035c5 <__udivdi3+0xe5>
  8035dc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8035df:	31 ff                	xor    %edi,%edi
  8035e1:	e9 40 ff ff ff       	jmp    803526 <__udivdi3+0x46>
  8035e6:	66 90                	xchg   %ax,%ax
  8035e8:	31 c0                	xor    %eax,%eax
  8035ea:	e9 37 ff ff ff       	jmp    803526 <__udivdi3+0x46>
  8035ef:	90                   	nop

008035f0 <__umoddi3>:
  8035f0:	55                   	push   %ebp
  8035f1:	57                   	push   %edi
  8035f2:	56                   	push   %esi
  8035f3:	53                   	push   %ebx
  8035f4:	83 ec 1c             	sub    $0x1c,%esp
  8035f7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8035fb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8035ff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803603:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803607:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80360b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80360f:	89 f3                	mov    %esi,%ebx
  803611:	89 fa                	mov    %edi,%edx
  803613:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803617:	89 34 24             	mov    %esi,(%esp)
  80361a:	85 c0                	test   %eax,%eax
  80361c:	75 1a                	jne    803638 <__umoddi3+0x48>
  80361e:	39 f7                	cmp    %esi,%edi
  803620:	0f 86 a2 00 00 00    	jbe    8036c8 <__umoddi3+0xd8>
  803626:	89 c8                	mov    %ecx,%eax
  803628:	89 f2                	mov    %esi,%edx
  80362a:	f7 f7                	div    %edi
  80362c:	89 d0                	mov    %edx,%eax
  80362e:	31 d2                	xor    %edx,%edx
  803630:	83 c4 1c             	add    $0x1c,%esp
  803633:	5b                   	pop    %ebx
  803634:	5e                   	pop    %esi
  803635:	5f                   	pop    %edi
  803636:	5d                   	pop    %ebp
  803637:	c3                   	ret    
  803638:	39 f0                	cmp    %esi,%eax
  80363a:	0f 87 ac 00 00 00    	ja     8036ec <__umoddi3+0xfc>
  803640:	0f bd e8             	bsr    %eax,%ebp
  803643:	83 f5 1f             	xor    $0x1f,%ebp
  803646:	0f 84 ac 00 00 00    	je     8036f8 <__umoddi3+0x108>
  80364c:	bf 20 00 00 00       	mov    $0x20,%edi
  803651:	29 ef                	sub    %ebp,%edi
  803653:	89 fe                	mov    %edi,%esi
  803655:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803659:	89 e9                	mov    %ebp,%ecx
  80365b:	d3 e0                	shl    %cl,%eax
  80365d:	89 d7                	mov    %edx,%edi
  80365f:	89 f1                	mov    %esi,%ecx
  803661:	d3 ef                	shr    %cl,%edi
  803663:	09 c7                	or     %eax,%edi
  803665:	89 e9                	mov    %ebp,%ecx
  803667:	d3 e2                	shl    %cl,%edx
  803669:	89 14 24             	mov    %edx,(%esp)
  80366c:	89 d8                	mov    %ebx,%eax
  80366e:	d3 e0                	shl    %cl,%eax
  803670:	89 c2                	mov    %eax,%edx
  803672:	8b 44 24 08          	mov    0x8(%esp),%eax
  803676:	d3 e0                	shl    %cl,%eax
  803678:	89 44 24 04          	mov    %eax,0x4(%esp)
  80367c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803680:	89 f1                	mov    %esi,%ecx
  803682:	d3 e8                	shr    %cl,%eax
  803684:	09 d0                	or     %edx,%eax
  803686:	d3 eb                	shr    %cl,%ebx
  803688:	89 da                	mov    %ebx,%edx
  80368a:	f7 f7                	div    %edi
  80368c:	89 d3                	mov    %edx,%ebx
  80368e:	f7 24 24             	mull   (%esp)
  803691:	89 c6                	mov    %eax,%esi
  803693:	89 d1                	mov    %edx,%ecx
  803695:	39 d3                	cmp    %edx,%ebx
  803697:	0f 82 87 00 00 00    	jb     803724 <__umoddi3+0x134>
  80369d:	0f 84 91 00 00 00    	je     803734 <__umoddi3+0x144>
  8036a3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8036a7:	29 f2                	sub    %esi,%edx
  8036a9:	19 cb                	sbb    %ecx,%ebx
  8036ab:	89 d8                	mov    %ebx,%eax
  8036ad:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8036b1:	d3 e0                	shl    %cl,%eax
  8036b3:	89 e9                	mov    %ebp,%ecx
  8036b5:	d3 ea                	shr    %cl,%edx
  8036b7:	09 d0                	or     %edx,%eax
  8036b9:	89 e9                	mov    %ebp,%ecx
  8036bb:	d3 eb                	shr    %cl,%ebx
  8036bd:	89 da                	mov    %ebx,%edx
  8036bf:	83 c4 1c             	add    $0x1c,%esp
  8036c2:	5b                   	pop    %ebx
  8036c3:	5e                   	pop    %esi
  8036c4:	5f                   	pop    %edi
  8036c5:	5d                   	pop    %ebp
  8036c6:	c3                   	ret    
  8036c7:	90                   	nop
  8036c8:	89 fd                	mov    %edi,%ebp
  8036ca:	85 ff                	test   %edi,%edi
  8036cc:	75 0b                	jne    8036d9 <__umoddi3+0xe9>
  8036ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8036d3:	31 d2                	xor    %edx,%edx
  8036d5:	f7 f7                	div    %edi
  8036d7:	89 c5                	mov    %eax,%ebp
  8036d9:	89 f0                	mov    %esi,%eax
  8036db:	31 d2                	xor    %edx,%edx
  8036dd:	f7 f5                	div    %ebp
  8036df:	89 c8                	mov    %ecx,%eax
  8036e1:	f7 f5                	div    %ebp
  8036e3:	89 d0                	mov    %edx,%eax
  8036e5:	e9 44 ff ff ff       	jmp    80362e <__umoddi3+0x3e>
  8036ea:	66 90                	xchg   %ax,%ax
  8036ec:	89 c8                	mov    %ecx,%eax
  8036ee:	89 f2                	mov    %esi,%edx
  8036f0:	83 c4 1c             	add    $0x1c,%esp
  8036f3:	5b                   	pop    %ebx
  8036f4:	5e                   	pop    %esi
  8036f5:	5f                   	pop    %edi
  8036f6:	5d                   	pop    %ebp
  8036f7:	c3                   	ret    
  8036f8:	3b 04 24             	cmp    (%esp),%eax
  8036fb:	72 06                	jb     803703 <__umoddi3+0x113>
  8036fd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803701:	77 0f                	ja     803712 <__umoddi3+0x122>
  803703:	89 f2                	mov    %esi,%edx
  803705:	29 f9                	sub    %edi,%ecx
  803707:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80370b:	89 14 24             	mov    %edx,(%esp)
  80370e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803712:	8b 44 24 04          	mov    0x4(%esp),%eax
  803716:	8b 14 24             	mov    (%esp),%edx
  803719:	83 c4 1c             	add    $0x1c,%esp
  80371c:	5b                   	pop    %ebx
  80371d:	5e                   	pop    %esi
  80371e:	5f                   	pop    %edi
  80371f:	5d                   	pop    %ebp
  803720:	c3                   	ret    
  803721:	8d 76 00             	lea    0x0(%esi),%esi
  803724:	2b 04 24             	sub    (%esp),%eax
  803727:	19 fa                	sbb    %edi,%edx
  803729:	89 d1                	mov    %edx,%ecx
  80372b:	89 c6                	mov    %eax,%esi
  80372d:	e9 71 ff ff ff       	jmp    8036a3 <__umoddi3+0xb3>
  803732:	66 90                	xchg   %ax,%ax
  803734:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803738:	72 ea                	jb     803724 <__umoddi3+0x134>
  80373a:	89 d9                	mov    %ebx,%ecx
  80373c:	e9 62 ff ff ff       	jmp    8036a3 <__umoddi3+0xb3>
