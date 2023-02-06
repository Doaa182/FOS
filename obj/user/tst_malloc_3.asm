
obj/user/tst_malloc_3:     file format elf32-i386


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
  800031:	e8 f6 0d 00 00       	call   800e2c <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
	short b;
	int c;
};

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec 20 01 00 00    	sub    $0x120,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800043:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800047:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004e:	eb 29                	jmp    800079 <_main+0x41>
		{
			if (myEnv->__uptr_pws[i].empty)
  800050:	a1 20 50 80 00       	mov    0x805020,%eax
  800055:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80005b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005e:	89 d0                	mov    %edx,%eax
  800060:	01 c0                	add    %eax,%eax
  800062:	01 d0                	add    %edx,%eax
  800064:	c1 e0 03             	shl    $0x3,%eax
  800067:	01 c8                	add    %ecx,%eax
  800069:	8a 40 04             	mov    0x4(%eax),%al
  80006c:	84 c0                	test   %al,%al
  80006e:	74 06                	je     800076 <_main+0x3e>
			{
				fullWS = 0;
  800070:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800074:	eb 12                	jmp    800088 <_main+0x50>
void _main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800076:	ff 45 f0             	incl   -0x10(%ebp)
  800079:	a1 20 50 80 00       	mov    0x805020,%eax
  80007e:	8b 50 74             	mov    0x74(%eax),%edx
  800081:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800084:	39 c2                	cmp    %eax,%edx
  800086:	77 c8                	ja     800050 <_main+0x18>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800088:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  80008c:	74 14                	je     8000a2 <_main+0x6a>
  80008e:	83 ec 04             	sub    $0x4,%esp
  800091:	68 00 3f 80 00       	push   $0x803f00
  800096:	6a 1a                	push   $0x1a
  800098:	68 1c 3f 80 00       	push   $0x803f1c
  80009d:	e8 c6 0e 00 00       	call   800f68 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	6a 00                	push   $0x0
  8000a7:	e8 e9 20 00 00       	call   802195 <malloc>
  8000ac:	83 c4 10             	add    $0x10,%esp





	int Mega = 1024*1024;
  8000af:	c7 45 e4 00 00 10 00 	movl   $0x100000,-0x1c(%ebp)
	int kilo = 1024;
  8000b6:	c7 45 e0 00 04 00 00 	movl   $0x400,-0x20(%ebp)
	char minByte = 1<<7;
  8000bd:	c6 45 df 80          	movb   $0x80,-0x21(%ebp)
	char maxByte = 0x7F;
  8000c1:	c6 45 de 7f          	movb   $0x7f,-0x22(%ebp)
	short minShort = 1<<15 ;
  8000c5:	66 c7 45 dc 00 80    	movw   $0x8000,-0x24(%ebp)
	short maxShort = 0x7FFF;
  8000cb:	66 c7 45 da ff 7f    	movw   $0x7fff,-0x26(%ebp)
	int minInt = 1<<31 ;
  8000d1:	c7 45 d4 00 00 00 80 	movl   $0x80000000,-0x2c(%ebp)
	int maxInt = 0x7FFFFFFF;
  8000d8:	c7 45 d0 ff ff ff 7f 	movl   $0x7fffffff,-0x30(%ebp)
	char *byteArr, *byteArr2 ;
	short *shortArr, *shortArr2 ;
	int *intArr;
	struct MyStruct *structArr ;
	int lastIndexOfByte, lastIndexOfByte2, lastIndexOfShort, lastIndexOfShort2, lastIndexOfInt, lastIndexOfStruct;
	int start_freeFrames = sys_calculate_free_frames() ;
  8000df:	e8 f0 24 00 00       	call   8025d4 <sys_calculate_free_frames>
  8000e4:	89 45 cc             	mov    %eax,-0x34(%ebp)

	void* ptr_allocations[20] = {0};
  8000e7:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  8000ed:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f7:	89 d7                	mov    %edx,%edi
  8000f9:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		//2 MB
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000fb:	e8 74 25 00 00       	call   802674 <sys_pf_calculate_allocated_pages>
  800100:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800103:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800106:	01 c0                	add    %eax,%eax
  800108:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	50                   	push   %eax
  80010f:	e8 81 20 00 00       	call   802195 <malloc>
  800114:	83 c4 10             	add    $0x10,%esp
  800117:	89 85 dc fe ff ff    	mov    %eax,-0x124(%ebp)
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START) || (uint32) ptr_allocations[0] > (USER_HEAP_START+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80011d:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  800123:	85 c0                	test   %eax,%eax
  800125:	79 0d                	jns    800134 <_main+0xfc>
  800127:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  80012d:	3d 00 10 00 80       	cmp    $0x80001000,%eax
  800132:	76 14                	jbe    800148 <_main+0x110>
  800134:	83 ec 04             	sub    $0x4,%esp
  800137:	68 30 3f 80 00       	push   $0x803f30
  80013c:	6a 39                	push   $0x39
  80013e:	68 1c 3f 80 00       	push   $0x803f1c
  800143:	e8 20 0e 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800148:	e8 27 25 00 00       	call   802674 <sys_pf_calculate_allocated_pages>
  80014d:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800150:	74 14                	je     800166 <_main+0x12e>
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	68 98 3f 80 00       	push   $0x803f98
  80015a:	6a 3a                	push   $0x3a
  80015c:	68 1c 3f 80 00       	push   $0x803f1c
  800161:	e8 02 0e 00 00       	call   800f68 <_panic>

		int freeFrames = sys_calculate_free_frames() ;
  800166:	e8 69 24 00 00       	call   8025d4 <sys_calculate_free_frames>
  80016b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  80016e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800171:	01 c0                	add    %eax,%eax
  800173:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800176:	48                   	dec    %eax
  800177:	89 45 c0             	mov    %eax,-0x40(%ebp)
		byteArr = (char *) ptr_allocations[0];
  80017a:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  800180:	89 45 bc             	mov    %eax,-0x44(%ebp)
		byteArr[0] = minByte ;
  800183:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800186:	8a 55 df             	mov    -0x21(%ebp),%dl
  800189:	88 10                	mov    %dl,(%eax)
		byteArr[lastIndexOfByte] = maxByte ;
  80018b:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80018e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800191:	01 c2                	add    %eax,%edx
  800193:	8a 45 de             	mov    -0x22(%ebp),%al
  800196:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800198:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  80019b:	e8 34 24 00 00       	call   8025d4 <sys_calculate_free_frames>
  8001a0:	29 c3                	sub    %eax,%ebx
  8001a2:	89 d8                	mov    %ebx,%eax
  8001a4:	83 f8 03             	cmp    $0x3,%eax
  8001a7:	74 14                	je     8001bd <_main+0x185>
  8001a9:	83 ec 04             	sub    $0x4,%esp
  8001ac:	68 c8 3f 80 00       	push   $0x803fc8
  8001b1:	6a 41                	push   $0x41
  8001b3:	68 1c 3f 80 00       	push   $0x803f1c
  8001b8:	e8 ab 0d 00 00       	call   800f68 <_panic>
		int var;
		int found = 0;
  8001bd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8001c4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001cb:	e9 82 00 00 00       	jmp    800252 <_main+0x21a>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE))
  8001d0:	a1 20 50 80 00       	mov    0x805020,%eax
  8001d5:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8001db:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8001de:	89 d0                	mov    %edx,%eax
  8001e0:	01 c0                	add    %eax,%eax
  8001e2:	01 d0                	add    %edx,%eax
  8001e4:	c1 e0 03             	shl    $0x3,%eax
  8001e7:	01 c8                	add    %ecx,%eax
  8001e9:	8b 00                	mov    (%eax),%eax
  8001eb:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8001ee:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001f1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001f6:	89 c2                	mov    %eax,%edx
  8001f8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8001fb:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8001fe:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800201:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800206:	39 c2                	cmp    %eax,%edx
  800208:	75 03                	jne    80020d <_main+0x1d5>
				found++;
  80020a:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE))
  80020d:	a1 20 50 80 00       	mov    0x805020,%eax
  800212:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800218:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80021b:	89 d0                	mov    %edx,%eax
  80021d:	01 c0                	add    %eax,%eax
  80021f:	01 d0                	add    %edx,%eax
  800221:	c1 e0 03             	shl    $0x3,%eax
  800224:	01 c8                	add    %ecx,%eax
  800226:	8b 00                	mov    (%eax),%eax
  800228:	89 45 b0             	mov    %eax,-0x50(%ebp)
  80022b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80022e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800233:	89 c1                	mov    %eax,%ecx
  800235:	8b 55 c0             	mov    -0x40(%ebp),%edx
  800238:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80023b:	01 d0                	add    %edx,%eax
  80023d:	89 45 ac             	mov    %eax,-0x54(%ebp)
  800240:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800243:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800248:	39 c1                	cmp    %eax,%ecx
  80024a:	75 03                	jne    80024f <_main+0x217>
				found++;
  80024c:	ff 45 e8             	incl   -0x18(%ebp)
		byteArr[0] = minByte ;
		byteArr[lastIndexOfByte] = maxByte ;
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		int var;
		int found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80024f:	ff 45 ec             	incl   -0x14(%ebp)
  800252:	a1 20 50 80 00       	mov    0x805020,%eax
  800257:	8b 50 74             	mov    0x74(%eax),%edx
  80025a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80025d:	39 c2                	cmp    %eax,%edx
  80025f:	0f 87 6b ff ff ff    	ja     8001d0 <_main+0x198>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800265:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  800269:	74 14                	je     80027f <_main+0x247>
  80026b:	83 ec 04             	sub    $0x4,%esp
  80026e:	68 0c 40 80 00       	push   $0x80400c
  800273:	6a 4b                	push   $0x4b
  800275:	68 1c 3f 80 00       	push   $0x803f1c
  80027a:	e8 e9 0c 00 00       	call   800f68 <_panic>

		//2 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80027f:	e8 f0 23 00 00       	call   802674 <sys_pf_calculate_allocated_pages>
  800284:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800287:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80028a:	01 c0                	add    %eax,%eax
  80028c:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80028f:	83 ec 0c             	sub    $0xc,%esp
  800292:	50                   	push   %eax
  800293:	e8 fd 1e 00 00       	call   802195 <malloc>
  800298:	83 c4 10             	add    $0x10,%esp
  80029b:	89 85 e0 fe ff ff    	mov    %eax,-0x120(%ebp)
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega) || (uint32) ptr_allocations[1] > (USER_HEAP_START+ 2*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8002a1:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  8002a7:	89 c2                	mov    %eax,%edx
  8002a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002ac:	01 c0                	add    %eax,%eax
  8002ae:	05 00 00 00 80       	add    $0x80000000,%eax
  8002b3:	39 c2                	cmp    %eax,%edx
  8002b5:	72 16                	jb     8002cd <_main+0x295>
  8002b7:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  8002bd:	89 c2                	mov    %eax,%edx
  8002bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002c2:	01 c0                	add    %eax,%eax
  8002c4:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8002c9:	39 c2                	cmp    %eax,%edx
  8002cb:	76 14                	jbe    8002e1 <_main+0x2a9>
  8002cd:	83 ec 04             	sub    $0x4,%esp
  8002d0:	68 30 3f 80 00       	push   $0x803f30
  8002d5:	6a 50                	push   $0x50
  8002d7:	68 1c 3f 80 00       	push   $0x803f1c
  8002dc:	e8 87 0c 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8002e1:	e8 8e 23 00 00       	call   802674 <sys_pf_calculate_allocated_pages>
  8002e6:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8002e9:	74 14                	je     8002ff <_main+0x2c7>
  8002eb:	83 ec 04             	sub    $0x4,%esp
  8002ee:	68 98 3f 80 00       	push   $0x803f98
  8002f3:	6a 51                	push   $0x51
  8002f5:	68 1c 3f 80 00       	push   $0x803f1c
  8002fa:	e8 69 0c 00 00       	call   800f68 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8002ff:	e8 d0 22 00 00       	call   8025d4 <sys_calculate_free_frames>
  800304:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		shortArr = (short *) ptr_allocations[1];
  800307:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  80030d:	89 45 a8             	mov    %eax,-0x58(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  800310:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800313:	01 c0                	add    %eax,%eax
  800315:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800318:	d1 e8                	shr    %eax
  80031a:	48                   	dec    %eax
  80031b:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		shortArr[0] = minShort;
  80031e:	8b 55 a8             	mov    -0x58(%ebp),%edx
  800321:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800324:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  800327:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80032a:	01 c0                	add    %eax,%eax
  80032c:	89 c2                	mov    %eax,%edx
  80032e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800331:	01 c2                	add    %eax,%edx
  800333:	66 8b 45 da          	mov    -0x26(%ebp),%ax
  800337:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  80033a:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  80033d:	e8 92 22 00 00       	call   8025d4 <sys_calculate_free_frames>
  800342:	29 c3                	sub    %eax,%ebx
  800344:	89 d8                	mov    %ebx,%eax
  800346:	83 f8 02             	cmp    $0x2,%eax
  800349:	74 14                	je     80035f <_main+0x327>
  80034b:	83 ec 04             	sub    $0x4,%esp
  80034e:	68 c8 3f 80 00       	push   $0x803fc8
  800353:	6a 58                	push   $0x58
  800355:	68 1c 3f 80 00       	push   $0x803f1c
  80035a:	e8 09 0c 00 00       	call   800f68 <_panic>
		found = 0;
  80035f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800366:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80036d:	e9 86 00 00 00       	jmp    8003f8 <_main+0x3c0>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  800372:	a1 20 50 80 00       	mov    0x805020,%eax
  800377:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80037d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800380:	89 d0                	mov    %edx,%eax
  800382:	01 c0                	add    %eax,%eax
  800384:	01 d0                	add    %edx,%eax
  800386:	c1 e0 03             	shl    $0x3,%eax
  800389:	01 c8                	add    %ecx,%eax
  80038b:	8b 00                	mov    (%eax),%eax
  80038d:	89 45 a0             	mov    %eax,-0x60(%ebp)
  800390:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800393:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800398:	89 c2                	mov    %eax,%edx
  80039a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80039d:	89 45 9c             	mov    %eax,-0x64(%ebp)
  8003a0:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8003a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003a8:	39 c2                	cmp    %eax,%edx
  8003aa:	75 03                	jne    8003af <_main+0x377>
				found++;
  8003ac:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
  8003af:	a1 20 50 80 00       	mov    0x805020,%eax
  8003b4:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003ba:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003bd:	89 d0                	mov    %edx,%eax
  8003bf:	01 c0                	add    %eax,%eax
  8003c1:	01 d0                	add    %edx,%eax
  8003c3:	c1 e0 03             	shl    $0x3,%eax
  8003c6:	01 c8                	add    %ecx,%eax
  8003c8:	8b 00                	mov    (%eax),%eax
  8003ca:	89 45 98             	mov    %eax,-0x68(%ebp)
  8003cd:	8b 45 98             	mov    -0x68(%ebp),%eax
  8003d0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003d5:	89 c2                	mov    %eax,%edx
  8003d7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003da:	01 c0                	add    %eax,%eax
  8003dc:	89 c1                	mov    %eax,%ecx
  8003de:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003e1:	01 c8                	add    %ecx,%eax
  8003e3:	89 45 94             	mov    %eax,-0x6c(%ebp)
  8003e6:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8003e9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003ee:	39 c2                	cmp    %eax,%edx
  8003f0:	75 03                	jne    8003f5 <_main+0x3bd>
				found++;
  8003f2:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
		shortArr[0] = minShort;
		shortArr[lastIndexOfShort] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8003f5:	ff 45 ec             	incl   -0x14(%ebp)
  8003f8:	a1 20 50 80 00       	mov    0x805020,%eax
  8003fd:	8b 50 74             	mov    0x74(%eax),%edx
  800400:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800403:	39 c2                	cmp    %eax,%edx
  800405:	0f 87 67 ff ff ff    	ja     800372 <_main+0x33a>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  80040b:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  80040f:	74 14                	je     800425 <_main+0x3ed>
  800411:	83 ec 04             	sub    $0x4,%esp
  800414:	68 0c 40 80 00       	push   $0x80400c
  800419:	6a 61                	push   $0x61
  80041b:	68 1c 3f 80 00       	push   $0x803f1c
  800420:	e8 43 0b 00 00       	call   800f68 <_panic>

		//3 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800425:	e8 4a 22 00 00       	call   802674 <sys_pf_calculate_allocated_pages>
  80042a:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[2] = malloc(3*kilo);
  80042d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800430:	89 c2                	mov    %eax,%edx
  800432:	01 d2                	add    %edx,%edx
  800434:	01 d0                	add    %edx,%eax
  800436:	83 ec 0c             	sub    $0xc,%esp
  800439:	50                   	push   %eax
  80043a:	e8 56 1d 00 00       	call   802195 <malloc>
  80043f:	83 c4 10             	add    $0x10,%esp
  800442:	89 85 e4 fe ff ff    	mov    %eax,-0x11c(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START+ 4*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800448:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  80044e:	89 c2                	mov    %eax,%edx
  800450:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800453:	c1 e0 02             	shl    $0x2,%eax
  800456:	05 00 00 00 80       	add    $0x80000000,%eax
  80045b:	39 c2                	cmp    %eax,%edx
  80045d:	72 17                	jb     800476 <_main+0x43e>
  80045f:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  800465:	89 c2                	mov    %eax,%edx
  800467:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80046a:	c1 e0 02             	shl    $0x2,%eax
  80046d:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800472:	39 c2                	cmp    %eax,%edx
  800474:	76 14                	jbe    80048a <_main+0x452>
  800476:	83 ec 04             	sub    $0x4,%esp
  800479:	68 30 3f 80 00       	push   $0x803f30
  80047e:	6a 66                	push   $0x66
  800480:	68 1c 3f 80 00       	push   $0x803f1c
  800485:	e8 de 0a 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  80048a:	e8 e5 21 00 00       	call   802674 <sys_pf_calculate_allocated_pages>
  80048f:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800492:	74 14                	je     8004a8 <_main+0x470>
  800494:	83 ec 04             	sub    $0x4,%esp
  800497:	68 98 3f 80 00       	push   $0x803f98
  80049c:	6a 67                	push   $0x67
  80049e:	68 1c 3f 80 00       	push   $0x803f1c
  8004a3:	e8 c0 0a 00 00       	call   800f68 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8004a8:	e8 27 21 00 00       	call   8025d4 <sys_calculate_free_frames>
  8004ad:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		intArr = (int *) ptr_allocations[2];
  8004b0:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  8004b6:	89 45 90             	mov    %eax,-0x70(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  8004b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004bc:	01 c0                	add    %eax,%eax
  8004be:	c1 e8 02             	shr    $0x2,%eax
  8004c1:	48                   	dec    %eax
  8004c2:	89 45 8c             	mov    %eax,-0x74(%ebp)
		intArr[0] = minInt;
  8004c5:	8b 45 90             	mov    -0x70(%ebp),%eax
  8004c8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004cb:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  8004cd:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8004d0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004d7:	8b 45 90             	mov    -0x70(%ebp),%eax
  8004da:	01 c2                	add    %eax,%edx
  8004dc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004df:	89 02                	mov    %eax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8004e1:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  8004e4:	e8 eb 20 00 00       	call   8025d4 <sys_calculate_free_frames>
  8004e9:	29 c3                	sub    %eax,%ebx
  8004eb:	89 d8                	mov    %ebx,%eax
  8004ed:	83 f8 02             	cmp    $0x2,%eax
  8004f0:	74 14                	je     800506 <_main+0x4ce>
  8004f2:	83 ec 04             	sub    $0x4,%esp
  8004f5:	68 c8 3f 80 00       	push   $0x803fc8
  8004fa:	6a 6e                	push   $0x6e
  8004fc:	68 1c 3f 80 00       	push   $0x803f1c
  800501:	e8 62 0a 00 00       	call   800f68 <_panic>
		found = 0;
  800506:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80050d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800514:	e9 8f 00 00 00       	jmp    8005a8 <_main+0x570>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
  800519:	a1 20 50 80 00       	mov    0x805020,%eax
  80051e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800524:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800527:	89 d0                	mov    %edx,%eax
  800529:	01 c0                	add    %eax,%eax
  80052b:	01 d0                	add    %edx,%eax
  80052d:	c1 e0 03             	shl    $0x3,%eax
  800530:	01 c8                	add    %ecx,%eax
  800532:	8b 00                	mov    (%eax),%eax
  800534:	89 45 88             	mov    %eax,-0x78(%ebp)
  800537:	8b 45 88             	mov    -0x78(%ebp),%eax
  80053a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80053f:	89 c2                	mov    %eax,%edx
  800541:	8b 45 90             	mov    -0x70(%ebp),%eax
  800544:	89 45 84             	mov    %eax,-0x7c(%ebp)
  800547:	8b 45 84             	mov    -0x7c(%ebp),%eax
  80054a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80054f:	39 c2                	cmp    %eax,%edx
  800551:	75 03                	jne    800556 <_main+0x51e>
				found++;
  800553:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
  800556:	a1 20 50 80 00       	mov    0x805020,%eax
  80055b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800561:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800564:	89 d0                	mov    %edx,%eax
  800566:	01 c0                	add    %eax,%eax
  800568:	01 d0                	add    %edx,%eax
  80056a:	c1 e0 03             	shl    $0x3,%eax
  80056d:	01 c8                	add    %ecx,%eax
  80056f:	8b 00                	mov    (%eax),%eax
  800571:	89 45 80             	mov    %eax,-0x80(%ebp)
  800574:	8b 45 80             	mov    -0x80(%ebp),%eax
  800577:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80057c:	89 c2                	mov    %eax,%edx
  80057e:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800581:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800588:	8b 45 90             	mov    -0x70(%ebp),%eax
  80058b:	01 c8                	add    %ecx,%eax
  80058d:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  800593:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800599:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80059e:	39 c2                	cmp    %eax,%edx
  8005a0:	75 03                	jne    8005a5 <_main+0x56d>
				found++;
  8005a2:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
		intArr[0] = minInt;
		intArr[lastIndexOfInt] = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8005a5:	ff 45 ec             	incl   -0x14(%ebp)
  8005a8:	a1 20 50 80 00       	mov    0x805020,%eax
  8005ad:	8b 50 74             	mov    0x74(%eax),%edx
  8005b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005b3:	39 c2                	cmp    %eax,%edx
  8005b5:	0f 87 5e ff ff ff    	ja     800519 <_main+0x4e1>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  8005bb:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  8005bf:	74 14                	je     8005d5 <_main+0x59d>
  8005c1:	83 ec 04             	sub    $0x4,%esp
  8005c4:	68 0c 40 80 00       	push   $0x80400c
  8005c9:	6a 77                	push   $0x77
  8005cb:	68 1c 3f 80 00       	push   $0x803f1c
  8005d0:	e8 93 09 00 00       	call   800f68 <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  8005d5:	e8 fa 1f 00 00       	call   8025d4 <sys_calculate_free_frames>
  8005da:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005dd:	e8 92 20 00 00       	call   802674 <sys_pf_calculate_allocated_pages>
  8005e2:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[3] = malloc(3*kilo);
  8005e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005e8:	89 c2                	mov    %eax,%edx
  8005ea:	01 d2                	add    %edx,%edx
  8005ec:	01 d0                	add    %edx,%eax
  8005ee:	83 ec 0c             	sub    $0xc,%esp
  8005f1:	50                   	push   %eax
  8005f2:	e8 9e 1b 00 00       	call   802195 <malloc>
  8005f7:	83 c4 10             	add    $0x10,%esp
  8005fa:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo) || (uint32) ptr_allocations[3] > (USER_HEAP_START+ 4*Mega + 4*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800600:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
  800606:	89 c2                	mov    %eax,%edx
  800608:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80060b:	c1 e0 02             	shl    $0x2,%eax
  80060e:	89 c1                	mov    %eax,%ecx
  800610:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800613:	c1 e0 02             	shl    $0x2,%eax
  800616:	01 c8                	add    %ecx,%eax
  800618:	05 00 00 00 80       	add    $0x80000000,%eax
  80061d:	39 c2                	cmp    %eax,%edx
  80061f:	72 21                	jb     800642 <_main+0x60a>
  800621:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
  800627:	89 c2                	mov    %eax,%edx
  800629:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80062c:	c1 e0 02             	shl    $0x2,%eax
  80062f:	89 c1                	mov    %eax,%ecx
  800631:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800634:	c1 e0 02             	shl    $0x2,%eax
  800637:	01 c8                	add    %ecx,%eax
  800639:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80063e:	39 c2                	cmp    %eax,%edx
  800640:	76 14                	jbe    800656 <_main+0x61e>
  800642:	83 ec 04             	sub    $0x4,%esp
  800645:	68 30 3f 80 00       	push   $0x803f30
  80064a:	6a 7d                	push   $0x7d
  80064c:	68 1c 3f 80 00       	push   $0x803f1c
  800651:	e8 12 09 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800656:	e8 19 20 00 00       	call   802674 <sys_pf_calculate_allocated_pages>
  80065b:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80065e:	74 14                	je     800674 <_main+0x63c>
  800660:	83 ec 04             	sub    $0x4,%esp
  800663:	68 98 3f 80 00       	push   $0x803f98
  800668:	6a 7e                	push   $0x7e
  80066a:	68 1c 3f 80 00       	push   $0x803f1c
  80066f:	e8 f4 08 00 00       	call   800f68 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800674:	e8 fb 1f 00 00       	call   802674 <sys_pf_calculate_allocated_pages>
  800679:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  80067c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80067f:	89 d0                	mov    %edx,%eax
  800681:	01 c0                	add    %eax,%eax
  800683:	01 d0                	add    %edx,%eax
  800685:	01 c0                	add    %eax,%eax
  800687:	01 d0                	add    %edx,%eax
  800689:	83 ec 0c             	sub    $0xc,%esp
  80068c:	50                   	push   %eax
  80068d:	e8 03 1b 00 00       	call   802195 <malloc>
  800692:	83 c4 10             	add    $0x10,%esp
  800695:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo)|| (uint32) ptr_allocations[4] > (USER_HEAP_START+ 4*Mega + 8*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80069b:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  8006a1:	89 c2                	mov    %eax,%edx
  8006a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006a6:	c1 e0 02             	shl    $0x2,%eax
  8006a9:	89 c1                	mov    %eax,%ecx
  8006ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006ae:	c1 e0 03             	shl    $0x3,%eax
  8006b1:	01 c8                	add    %ecx,%eax
  8006b3:	05 00 00 00 80       	add    $0x80000000,%eax
  8006b8:	39 c2                	cmp    %eax,%edx
  8006ba:	72 21                	jb     8006dd <_main+0x6a5>
  8006bc:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  8006c2:	89 c2                	mov    %eax,%edx
  8006c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006c7:	c1 e0 02             	shl    $0x2,%eax
  8006ca:	89 c1                	mov    %eax,%ecx
  8006cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006cf:	c1 e0 03             	shl    $0x3,%eax
  8006d2:	01 c8                	add    %ecx,%eax
  8006d4:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8006d9:	39 c2                	cmp    %eax,%edx
  8006db:	76 17                	jbe    8006f4 <_main+0x6bc>
  8006dd:	83 ec 04             	sub    $0x4,%esp
  8006e0:	68 30 3f 80 00       	push   $0x803f30
  8006e5:	68 84 00 00 00       	push   $0x84
  8006ea:	68 1c 3f 80 00       	push   $0x803f1c
  8006ef:	e8 74 08 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8006f4:	e8 7b 1f 00 00       	call   802674 <sys_pf_calculate_allocated_pages>
  8006f9:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8006fc:	74 17                	je     800715 <_main+0x6dd>
  8006fe:	83 ec 04             	sub    $0x4,%esp
  800701:	68 98 3f 80 00       	push   $0x803f98
  800706:	68 85 00 00 00       	push   $0x85
  80070b:	68 1c 3f 80 00       	push   $0x803f1c
  800710:	e8 53 08 00 00       	call   800f68 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800715:	e8 ba 1e 00 00       	call   8025d4 <sys_calculate_free_frames>
  80071a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		structArr = (struct MyStruct *) ptr_allocations[4];
  80071d:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  800723:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
		lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  800729:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80072c:	89 d0                	mov    %edx,%eax
  80072e:	01 c0                	add    %eax,%eax
  800730:	01 d0                	add    %edx,%eax
  800732:	01 c0                	add    %eax,%eax
  800734:	01 d0                	add    %edx,%eax
  800736:	c1 e8 03             	shr    $0x3,%eax
  800739:	48                   	dec    %eax
  80073a:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  800740:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800746:	8a 55 df             	mov    -0x21(%ebp),%dl
  800749:	88 10                	mov    %dl,(%eax)
  80074b:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  800751:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800754:	66 89 42 02          	mov    %ax,0x2(%edx)
  800758:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80075e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800761:	89 50 04             	mov    %edx,0x4(%eax)
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  800764:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80076a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800771:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800777:	01 c2                	add    %eax,%edx
  800779:	8a 45 de             	mov    -0x22(%ebp),%al
  80077c:	88 02                	mov    %al,(%edx)
  80077e:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800784:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80078b:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800791:	01 c2                	add    %eax,%edx
  800793:	66 8b 45 da          	mov    -0x26(%ebp),%ax
  800797:	66 89 42 02          	mov    %ax,0x2(%edx)
  80079b:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8007a1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007a8:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8007ae:	01 c2                	add    %eax,%edx
  8007b0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007b3:	89 42 04             	mov    %eax,0x4(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8007b6:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  8007b9:	e8 16 1e 00 00       	call   8025d4 <sys_calculate_free_frames>
  8007be:	29 c3                	sub    %eax,%ebx
  8007c0:	89 d8                	mov    %ebx,%eax
  8007c2:	83 f8 02             	cmp    $0x2,%eax
  8007c5:	74 17                	je     8007de <_main+0x7a6>
  8007c7:	83 ec 04             	sub    $0x4,%esp
  8007ca:	68 c8 3f 80 00       	push   $0x803fc8
  8007cf:	68 8c 00 00 00       	push   $0x8c
  8007d4:	68 1c 3f 80 00       	push   $0x803f1c
  8007d9:	e8 8a 07 00 00       	call   800f68 <_panic>
		found = 0;
  8007de:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8007e5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8007ec:	e9 aa 00 00 00       	jmp    80089b <_main+0x863>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
  8007f1:	a1 20 50 80 00       	mov    0x805020,%eax
  8007f6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007fc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8007ff:	89 d0                	mov    %edx,%eax
  800801:	01 c0                	add    %eax,%eax
  800803:	01 d0                	add    %edx,%eax
  800805:	c1 e0 03             	shl    $0x3,%eax
  800808:	01 c8                	add    %ecx,%eax
  80080a:	8b 00                	mov    (%eax),%eax
  80080c:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
  800812:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800818:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80081d:	89 c2                	mov    %eax,%edx
  80081f:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800825:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  80082b:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800831:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800836:	39 c2                	cmp    %eax,%edx
  800838:	75 03                	jne    80083d <_main+0x805>
				found++;
  80083a:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
  80083d:	a1 20 50 80 00       	mov    0x805020,%eax
  800842:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800848:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80084b:	89 d0                	mov    %edx,%eax
  80084d:	01 c0                	add    %eax,%eax
  80084f:	01 d0                	add    %edx,%eax
  800851:	c1 e0 03             	shl    $0x3,%eax
  800854:	01 c8                	add    %ecx,%eax
  800856:	8b 00                	mov    (%eax),%eax
  800858:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
  80085e:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800864:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800869:	89 c2                	mov    %eax,%edx
  80086b:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800871:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800878:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80087e:	01 c8                	add    %ecx,%eax
  800880:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  800886:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  80088c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800891:	39 c2                	cmp    %eax,%edx
  800893:	75 03                	jne    800898 <_main+0x860>
				found++;
  800895:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800898:	ff 45 ec             	incl   -0x14(%ebp)
  80089b:	a1 20 50 80 00       	mov    0x805020,%eax
  8008a0:	8b 50 74             	mov    0x74(%eax),%edx
  8008a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008a6:	39 c2                	cmp    %eax,%edx
  8008a8:	0f 87 43 ff ff ff    	ja     8007f1 <_main+0x7b9>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  8008ae:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  8008b2:	74 17                	je     8008cb <_main+0x893>
  8008b4:	83 ec 04             	sub    $0x4,%esp
  8008b7:	68 0c 40 80 00       	push   $0x80400c
  8008bc:	68 95 00 00 00       	push   $0x95
  8008c1:	68 1c 3f 80 00       	push   $0x803f1c
  8008c6:	e8 9d 06 00 00       	call   800f68 <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8008cb:	e8 04 1d 00 00       	call   8025d4 <sys_calculate_free_frames>
  8008d0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008d3:	e8 9c 1d 00 00       	call   802674 <sys_pf_calculate_allocated_pages>
  8008d8:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8008db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008de:	89 c2                	mov    %eax,%edx
  8008e0:	01 d2                	add    %edx,%edx
  8008e2:	01 d0                	add    %edx,%eax
  8008e4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8008e7:	83 ec 0c             	sub    $0xc,%esp
  8008ea:	50                   	push   %eax
  8008eb:	e8 a5 18 00 00       	call   802195 <malloc>
  8008f0:	83 c4 10             	add    $0x10,%esp
  8008f3:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo) || (uint32) ptr_allocations[5] > (USER_HEAP_START+ 4*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8008f9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8008ff:	89 c2                	mov    %eax,%edx
  800901:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800904:	c1 e0 02             	shl    $0x2,%eax
  800907:	89 c1                	mov    %eax,%ecx
  800909:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80090c:	c1 e0 04             	shl    $0x4,%eax
  80090f:	01 c8                	add    %ecx,%eax
  800911:	05 00 00 00 80       	add    $0x80000000,%eax
  800916:	39 c2                	cmp    %eax,%edx
  800918:	72 21                	jb     80093b <_main+0x903>
  80091a:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800920:	89 c2                	mov    %eax,%edx
  800922:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800925:	c1 e0 02             	shl    $0x2,%eax
  800928:	89 c1                	mov    %eax,%ecx
  80092a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80092d:	c1 e0 04             	shl    $0x4,%eax
  800930:	01 c8                	add    %ecx,%eax
  800932:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800937:	39 c2                	cmp    %eax,%edx
  800939:	76 17                	jbe    800952 <_main+0x91a>
  80093b:	83 ec 04             	sub    $0x4,%esp
  80093e:	68 30 3f 80 00       	push   $0x803f30
  800943:	68 9b 00 00 00       	push   $0x9b
  800948:	68 1c 3f 80 00       	push   $0x803f1c
  80094d:	e8 16 06 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800952:	e8 1d 1d 00 00       	call   802674 <sys_pf_calculate_allocated_pages>
  800957:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80095a:	74 17                	je     800973 <_main+0x93b>
  80095c:	83 ec 04             	sub    $0x4,%esp
  80095f:	68 98 3f 80 00       	push   $0x803f98
  800964:	68 9c 00 00 00       	push   $0x9c
  800969:	68 1c 3f 80 00       	push   $0x803f1c
  80096e:	e8 f5 05 00 00       	call   800f68 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800973:	e8 fc 1c 00 00       	call   802674 <sys_pf_calculate_allocated_pages>
  800978:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[6] = malloc(6*Mega-kilo);
  80097b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80097e:	89 d0                	mov    %edx,%eax
  800980:	01 c0                	add    %eax,%eax
  800982:	01 d0                	add    %edx,%eax
  800984:	01 c0                	add    %eax,%eax
  800986:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800989:	83 ec 0c             	sub    $0xc,%esp
  80098c:	50                   	push   %eax
  80098d:	e8 03 18 00 00       	call   802195 <malloc>
  800992:	83 c4 10             	add    $0x10,%esp
  800995:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo) || (uint32) ptr_allocations[6] > (USER_HEAP_START+ 7*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80099b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8009a1:	89 c1                	mov    %eax,%ecx
  8009a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8009a6:	89 d0                	mov    %edx,%eax
  8009a8:	01 c0                	add    %eax,%eax
  8009aa:	01 d0                	add    %edx,%eax
  8009ac:	01 c0                	add    %eax,%eax
  8009ae:	01 d0                	add    %edx,%eax
  8009b0:	89 c2                	mov    %eax,%edx
  8009b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009b5:	c1 e0 04             	shl    $0x4,%eax
  8009b8:	01 d0                	add    %edx,%eax
  8009ba:	05 00 00 00 80       	add    $0x80000000,%eax
  8009bf:	39 c1                	cmp    %eax,%ecx
  8009c1:	72 28                	jb     8009eb <_main+0x9b3>
  8009c3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8009c9:	89 c1                	mov    %eax,%ecx
  8009cb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8009ce:	89 d0                	mov    %edx,%eax
  8009d0:	01 c0                	add    %eax,%eax
  8009d2:	01 d0                	add    %edx,%eax
  8009d4:	01 c0                	add    %eax,%eax
  8009d6:	01 d0                	add    %edx,%eax
  8009d8:	89 c2                	mov    %eax,%edx
  8009da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009dd:	c1 e0 04             	shl    $0x4,%eax
  8009e0:	01 d0                	add    %edx,%eax
  8009e2:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8009e7:	39 c1                	cmp    %eax,%ecx
  8009e9:	76 17                	jbe    800a02 <_main+0x9ca>
  8009eb:	83 ec 04             	sub    $0x4,%esp
  8009ee:	68 30 3f 80 00       	push   $0x803f30
  8009f3:	68 a2 00 00 00       	push   $0xa2
  8009f8:	68 1c 3f 80 00       	push   $0x803f1c
  8009fd:	e8 66 05 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800a02:	e8 6d 1c 00 00       	call   802674 <sys_pf_calculate_allocated_pages>
  800a07:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800a0a:	74 17                	je     800a23 <_main+0x9eb>
  800a0c:	83 ec 04             	sub    $0x4,%esp
  800a0f:	68 98 3f 80 00       	push   $0x803f98
  800a14:	68 a3 00 00 00       	push   $0xa3
  800a19:	68 1c 3f 80 00       	push   $0x803f1c
  800a1e:	e8 45 05 00 00       	call   800f68 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800a23:	e8 ac 1b 00 00       	call   8025d4 <sys_calculate_free_frames>
  800a28:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		lastIndexOfByte2 = (6*Mega-kilo)/sizeof(char) - 1;
  800a2b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a2e:	89 d0                	mov    %edx,%eax
  800a30:	01 c0                	add    %eax,%eax
  800a32:	01 d0                	add    %edx,%eax
  800a34:	01 c0                	add    %eax,%eax
  800a36:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800a39:	48                   	dec    %eax
  800a3a:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
		byteArr2 = (char *) ptr_allocations[6];
  800a40:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800a46:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
		byteArr2[0] = minByte ;
  800a4c:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800a52:	8a 55 df             	mov    -0x21(%ebp),%dl
  800a55:	88 10                	mov    %dl,(%eax)
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
  800a57:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800a5d:	89 c2                	mov    %eax,%edx
  800a5f:	c1 ea 1f             	shr    $0x1f,%edx
  800a62:	01 d0                	add    %edx,%eax
  800a64:	d1 f8                	sar    %eax
  800a66:	89 c2                	mov    %eax,%edx
  800a68:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800a6e:	01 c2                	add    %eax,%edx
  800a70:	8a 45 de             	mov    -0x22(%ebp),%al
  800a73:	88 c1                	mov    %al,%cl
  800a75:	c0 e9 07             	shr    $0x7,%cl
  800a78:	01 c8                	add    %ecx,%eax
  800a7a:	d0 f8                	sar    %al
  800a7c:	88 02                	mov    %al,(%edx)
		byteArr2[lastIndexOfByte2] = maxByte ;
  800a7e:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  800a84:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800a8a:	01 c2                	add    %eax,%edx
  800a8c:	8a 45 de             	mov    -0x22(%ebp),%al
  800a8f:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800a91:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  800a94:	e8 3b 1b 00 00       	call   8025d4 <sys_calculate_free_frames>
  800a99:	29 c3                	sub    %eax,%ebx
  800a9b:	89 d8                	mov    %ebx,%eax
  800a9d:	83 f8 05             	cmp    $0x5,%eax
  800aa0:	74 17                	je     800ab9 <_main+0xa81>
  800aa2:	83 ec 04             	sub    $0x4,%esp
  800aa5:	68 c8 3f 80 00       	push   $0x803fc8
  800aaa:	68 ab 00 00 00       	push   $0xab
  800aaf:	68 1c 3f 80 00       	push   $0x803f1c
  800ab4:	e8 af 04 00 00       	call   800f68 <_panic>
		found = 0;
  800ab9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800ac0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800ac7:	e9 02 01 00 00       	jmp    800bce <_main+0xb96>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE))
  800acc:	a1 20 50 80 00       	mov    0x805020,%eax
  800ad1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ad7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ada:	89 d0                	mov    %edx,%eax
  800adc:	01 c0                	add    %eax,%eax
  800ade:	01 d0                	add    %edx,%eax
  800ae0:	c1 e0 03             	shl    $0x3,%eax
  800ae3:	01 c8                	add    %ecx,%eax
  800ae5:	8b 00                	mov    (%eax),%eax
  800ae7:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
  800aed:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800af3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800af8:	89 c2                	mov    %eax,%edx
  800afa:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800b00:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  800b06:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800b0c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b11:	39 c2                	cmp    %eax,%edx
  800b13:	75 03                	jne    800b18 <_main+0xae0>
				found++;
  800b15:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
  800b18:	a1 20 50 80 00       	mov    0x805020,%eax
  800b1d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b23:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b26:	89 d0                	mov    %edx,%eax
  800b28:	01 c0                	add    %eax,%eax
  800b2a:	01 d0                	add    %edx,%eax
  800b2c:	c1 e0 03             	shl    $0x3,%eax
  800b2f:	01 c8                	add    %ecx,%eax
  800b31:	8b 00                	mov    (%eax),%eax
  800b33:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  800b39:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800b3f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b44:	89 c2                	mov    %eax,%edx
  800b46:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800b4c:	89 c1                	mov    %eax,%ecx
  800b4e:	c1 e9 1f             	shr    $0x1f,%ecx
  800b51:	01 c8                	add    %ecx,%eax
  800b53:	d1 f8                	sar    %eax
  800b55:	89 c1                	mov    %eax,%ecx
  800b57:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800b5d:	01 c8                	add    %ecx,%eax
  800b5f:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  800b65:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800b6b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b70:	39 c2                	cmp    %eax,%edx
  800b72:	75 03                	jne    800b77 <_main+0xb3f>
				found++;
  800b74:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
  800b77:	a1 20 50 80 00       	mov    0x805020,%eax
  800b7c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b82:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b85:	89 d0                	mov    %edx,%eax
  800b87:	01 c0                	add    %eax,%eax
  800b89:	01 d0                	add    %edx,%eax
  800b8b:	c1 e0 03             	shl    $0x3,%eax
  800b8e:	01 c8                	add    %ecx,%eax
  800b90:	8b 00                	mov    (%eax),%eax
  800b92:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
  800b98:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800b9e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ba3:	89 c1                	mov    %eax,%ecx
  800ba5:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  800bab:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800bb1:	01 d0                	add    %edx,%eax
  800bb3:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  800bb9:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800bbf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bc4:	39 c1                	cmp    %eax,%ecx
  800bc6:	75 03                	jne    800bcb <_main+0xb93>
				found++;
  800bc8:	ff 45 e8             	incl   -0x18(%ebp)
		byteArr2[0] = minByte ;
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
		byteArr2[lastIndexOfByte2] = maxByte ;
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800bcb:	ff 45 ec             	incl   -0x14(%ebp)
  800bce:	a1 20 50 80 00       	mov    0x805020,%eax
  800bd3:	8b 50 74             	mov    0x74(%eax),%edx
  800bd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bd9:	39 c2                	cmp    %eax,%edx
  800bdb:	0f 87 eb fe ff ff    	ja     800acc <_main+0xa94>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
				found++;
		}
		if (found != 3) panic("malloc: page is not added to WS");
  800be1:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  800be5:	74 17                	je     800bfe <_main+0xbc6>
  800be7:	83 ec 04             	sub    $0x4,%esp
  800bea:	68 0c 40 80 00       	push   $0x80400c
  800bef:	68 b6 00 00 00       	push   $0xb6
  800bf4:	68 1c 3f 80 00       	push   $0x803f1c
  800bf9:	e8 6a 03 00 00       	call   800f68 <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800bfe:	e8 71 1a 00 00       	call   802674 <sys_pf_calculate_allocated_pages>
  800c03:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[7] = malloc(14*kilo);
  800c06:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c09:	89 d0                	mov    %edx,%eax
  800c0b:	01 c0                	add    %eax,%eax
  800c0d:	01 d0                	add    %edx,%eax
  800c0f:	01 c0                	add    %eax,%eax
  800c11:	01 d0                	add    %edx,%eax
  800c13:	01 c0                	add    %eax,%eax
  800c15:	83 ec 0c             	sub    $0xc,%esp
  800c18:	50                   	push   %eax
  800c19:	e8 77 15 00 00       	call   802195 <malloc>
  800c1e:	83 c4 10             	add    $0x10,%esp
  800c21:	89 85 f8 fe ff ff    	mov    %eax,-0x108(%ebp)
		if ((uint32) ptr_allocations[7] < (USER_HEAP_START + 13*Mega + 16*kilo)|| (uint32) ptr_allocations[7] > (USER_HEAP_START+ 13*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800c27:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  800c2d:	89 c1                	mov    %eax,%ecx
  800c2f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800c32:	89 d0                	mov    %edx,%eax
  800c34:	01 c0                	add    %eax,%eax
  800c36:	01 d0                	add    %edx,%eax
  800c38:	c1 e0 02             	shl    $0x2,%eax
  800c3b:	01 d0                	add    %edx,%eax
  800c3d:	89 c2                	mov    %eax,%edx
  800c3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c42:	c1 e0 04             	shl    $0x4,%eax
  800c45:	01 d0                	add    %edx,%eax
  800c47:	05 00 00 00 80       	add    $0x80000000,%eax
  800c4c:	39 c1                	cmp    %eax,%ecx
  800c4e:	72 29                	jb     800c79 <_main+0xc41>
  800c50:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  800c56:	89 c1                	mov    %eax,%ecx
  800c58:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800c5b:	89 d0                	mov    %edx,%eax
  800c5d:	01 c0                	add    %eax,%eax
  800c5f:	01 d0                	add    %edx,%eax
  800c61:	c1 e0 02             	shl    $0x2,%eax
  800c64:	01 d0                	add    %edx,%eax
  800c66:	89 c2                	mov    %eax,%edx
  800c68:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c6b:	c1 e0 04             	shl    $0x4,%eax
  800c6e:	01 d0                	add    %edx,%eax
  800c70:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800c75:	39 c1                	cmp    %eax,%ecx
  800c77:	76 17                	jbe    800c90 <_main+0xc58>
  800c79:	83 ec 04             	sub    $0x4,%esp
  800c7c:	68 30 3f 80 00       	push   $0x803f30
  800c81:	68 bb 00 00 00       	push   $0xbb
  800c86:	68 1c 3f 80 00       	push   $0x803f1c
  800c8b:	e8 d8 02 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800c90:	e8 df 19 00 00       	call   802674 <sys_pf_calculate_allocated_pages>
  800c95:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800c98:	74 17                	je     800cb1 <_main+0xc79>
  800c9a:	83 ec 04             	sub    $0x4,%esp
  800c9d:	68 98 3f 80 00       	push   $0x803f98
  800ca2:	68 bc 00 00 00       	push   $0xbc
  800ca7:	68 1c 3f 80 00       	push   $0x803f1c
  800cac:	e8 b7 02 00 00       	call   800f68 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800cb1:	e8 1e 19 00 00       	call   8025d4 <sys_calculate_free_frames>
  800cb6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		shortArr2 = (short *) ptr_allocations[7];
  800cb9:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  800cbf:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
  800cc5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cc8:	89 d0                	mov    %edx,%eax
  800cca:	01 c0                	add    %eax,%eax
  800ccc:	01 d0                	add    %edx,%eax
  800cce:	01 c0                	add    %eax,%eax
  800cd0:	01 d0                	add    %edx,%eax
  800cd2:	01 c0                	add    %eax,%eax
  800cd4:	d1 e8                	shr    %eax
  800cd6:	48                   	dec    %eax
  800cd7:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
		shortArr2[0] = minShort;
  800cdd:	8b 95 40 ff ff ff    	mov    -0xc0(%ebp),%edx
  800ce3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800ce6:	66 89 02             	mov    %ax,(%edx)
		shortArr2[lastIndexOfShort2] = maxShort;
  800ce9:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800cef:	01 c0                	add    %eax,%eax
  800cf1:	89 c2                	mov    %eax,%edx
  800cf3:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800cf9:	01 c2                	add    %eax,%edx
  800cfb:	66 8b 45 da          	mov    -0x26(%ebp),%ax
  800cff:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800d02:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  800d05:	e8 ca 18 00 00       	call   8025d4 <sys_calculate_free_frames>
  800d0a:	29 c3                	sub    %eax,%ebx
  800d0c:	89 d8                	mov    %ebx,%eax
  800d0e:	83 f8 02             	cmp    $0x2,%eax
  800d11:	74 17                	je     800d2a <_main+0xcf2>
  800d13:	83 ec 04             	sub    $0x4,%esp
  800d16:	68 c8 3f 80 00       	push   $0x803fc8
  800d1b:	68 c3 00 00 00       	push   $0xc3
  800d20:	68 1c 3f 80 00       	push   $0x803f1c
  800d25:	e8 3e 02 00 00       	call   800f68 <_panic>
		found = 0;
  800d2a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800d31:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800d38:	e9 a7 00 00 00       	jmp    800de4 <_main+0xdac>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
  800d3d:	a1 20 50 80 00       	mov    0x805020,%eax
  800d42:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d48:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800d4b:	89 d0                	mov    %edx,%eax
  800d4d:	01 c0                	add    %eax,%eax
  800d4f:	01 d0                	add    %edx,%eax
  800d51:	c1 e0 03             	shl    $0x3,%eax
  800d54:	01 c8                	add    %ecx,%eax
  800d56:	8b 00                	mov    (%eax),%eax
  800d58:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)
  800d5e:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800d64:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d69:	89 c2                	mov    %eax,%edx
  800d6b:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800d71:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
  800d77:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800d7d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d82:	39 c2                	cmp    %eax,%edx
  800d84:	75 03                	jne    800d89 <_main+0xd51>
				found++;
  800d86:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
  800d89:	a1 20 50 80 00       	mov    0x805020,%eax
  800d8e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d94:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800d97:	89 d0                	mov    %edx,%eax
  800d99:	01 c0                	add    %eax,%eax
  800d9b:	01 d0                	add    %edx,%eax
  800d9d:	c1 e0 03             	shl    $0x3,%eax
  800da0:	01 c8                	add    %ecx,%eax
  800da2:	8b 00                	mov    (%eax),%eax
  800da4:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)
  800daa:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  800db0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800db5:	89 c2                	mov    %eax,%edx
  800db7:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800dbd:	01 c0                	add    %eax,%eax
  800dbf:	89 c1                	mov    %eax,%ecx
  800dc1:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800dc7:	01 c8                	add    %ecx,%eax
  800dc9:	89 85 2c ff ff ff    	mov    %eax,-0xd4(%ebp)
  800dcf:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  800dd5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dda:	39 c2                	cmp    %eax,%edx
  800ddc:	75 03                	jne    800de1 <_main+0xda9>
				found++;
  800dde:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
		shortArr2[0] = minShort;
		shortArr2[lastIndexOfShort2] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800de1:	ff 45 ec             	incl   -0x14(%ebp)
  800de4:	a1 20 50 80 00       	mov    0x805020,%eax
  800de9:	8b 50 74             	mov    0x74(%eax),%edx
  800dec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800def:	39 c2                	cmp    %eax,%edx
  800df1:	0f 87 46 ff ff ff    	ja     800d3d <_main+0xd05>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800df7:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  800dfb:	74 17                	je     800e14 <_main+0xddc>
  800dfd:	83 ec 04             	sub    $0x4,%esp
  800e00:	68 0c 40 80 00       	push   $0x80400c
  800e05:	68 cc 00 00 00       	push   $0xcc
  800e0a:	68 1c 3f 80 00       	push   $0x803f1c
  800e0f:	e8 54 01 00 00       	call   800f68 <_panic>
	}

	cprintf("Congratulations!! test malloc [3] completed successfully.\n");
  800e14:	83 ec 0c             	sub    $0xc,%esp
  800e17:	68 2c 40 80 00       	push   $0x80402c
  800e1c:	e8 fb 03 00 00       	call   80121c <cprintf>
  800e21:	83 c4 10             	add    $0x10,%esp

	return;
  800e24:	90                   	nop
}
  800e25:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e28:	5b                   	pop    %ebx
  800e29:	5f                   	pop    %edi
  800e2a:	5d                   	pop    %ebp
  800e2b:	c3                   	ret    

00800e2c <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800e2c:	55                   	push   %ebp
  800e2d:	89 e5                	mov    %esp,%ebp
  800e2f:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800e32:	e8 7d 1a 00 00       	call   8028b4 <sys_getenvindex>
  800e37:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800e3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e3d:	89 d0                	mov    %edx,%eax
  800e3f:	c1 e0 03             	shl    $0x3,%eax
  800e42:	01 d0                	add    %edx,%eax
  800e44:	01 c0                	add    %eax,%eax
  800e46:	01 d0                	add    %edx,%eax
  800e48:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800e4f:	01 d0                	add    %edx,%eax
  800e51:	c1 e0 04             	shl    $0x4,%eax
  800e54:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800e59:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800e5e:	a1 20 50 80 00       	mov    0x805020,%eax
  800e63:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800e69:	84 c0                	test   %al,%al
  800e6b:	74 0f                	je     800e7c <libmain+0x50>
		binaryname = myEnv->prog_name;
  800e6d:	a1 20 50 80 00       	mov    0x805020,%eax
  800e72:	05 5c 05 00 00       	add    $0x55c,%eax
  800e77:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800e7c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e80:	7e 0a                	jle    800e8c <libmain+0x60>
		binaryname = argv[0];
  800e82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e85:	8b 00                	mov    (%eax),%eax
  800e87:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800e8c:	83 ec 08             	sub    $0x8,%esp
  800e8f:	ff 75 0c             	pushl  0xc(%ebp)
  800e92:	ff 75 08             	pushl  0x8(%ebp)
  800e95:	e8 9e f1 ff ff       	call   800038 <_main>
  800e9a:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800e9d:	e8 1f 18 00 00       	call   8026c1 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800ea2:	83 ec 0c             	sub    $0xc,%esp
  800ea5:	68 80 40 80 00       	push   $0x804080
  800eaa:	e8 6d 03 00 00       	call   80121c <cprintf>
  800eaf:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800eb2:	a1 20 50 80 00       	mov    0x805020,%eax
  800eb7:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800ebd:	a1 20 50 80 00       	mov    0x805020,%eax
  800ec2:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800ec8:	83 ec 04             	sub    $0x4,%esp
  800ecb:	52                   	push   %edx
  800ecc:	50                   	push   %eax
  800ecd:	68 a8 40 80 00       	push   $0x8040a8
  800ed2:	e8 45 03 00 00       	call   80121c <cprintf>
  800ed7:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800eda:	a1 20 50 80 00       	mov    0x805020,%eax
  800edf:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800ee5:	a1 20 50 80 00       	mov    0x805020,%eax
  800eea:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800ef0:	a1 20 50 80 00       	mov    0x805020,%eax
  800ef5:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800efb:	51                   	push   %ecx
  800efc:	52                   	push   %edx
  800efd:	50                   	push   %eax
  800efe:	68 d0 40 80 00       	push   $0x8040d0
  800f03:	e8 14 03 00 00       	call   80121c <cprintf>
  800f08:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800f0b:	a1 20 50 80 00       	mov    0x805020,%eax
  800f10:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800f16:	83 ec 08             	sub    $0x8,%esp
  800f19:	50                   	push   %eax
  800f1a:	68 28 41 80 00       	push   $0x804128
  800f1f:	e8 f8 02 00 00       	call   80121c <cprintf>
  800f24:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800f27:	83 ec 0c             	sub    $0xc,%esp
  800f2a:	68 80 40 80 00       	push   $0x804080
  800f2f:	e8 e8 02 00 00       	call   80121c <cprintf>
  800f34:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800f37:	e8 9f 17 00 00       	call   8026db <sys_enable_interrupt>

	// exit gracefully
	exit();
  800f3c:	e8 19 00 00 00       	call   800f5a <exit>
}
  800f41:	90                   	nop
  800f42:	c9                   	leave  
  800f43:	c3                   	ret    

00800f44 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800f44:	55                   	push   %ebp
  800f45:	89 e5                	mov    %esp,%ebp
  800f47:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800f4a:	83 ec 0c             	sub    $0xc,%esp
  800f4d:	6a 00                	push   $0x0
  800f4f:	e8 2c 19 00 00       	call   802880 <sys_destroy_env>
  800f54:	83 c4 10             	add    $0x10,%esp
}
  800f57:	90                   	nop
  800f58:	c9                   	leave  
  800f59:	c3                   	ret    

00800f5a <exit>:

void
exit(void)
{
  800f5a:	55                   	push   %ebp
  800f5b:	89 e5                	mov    %esp,%ebp
  800f5d:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800f60:	e8 81 19 00 00       	call   8028e6 <sys_exit_env>
}
  800f65:	90                   	nop
  800f66:	c9                   	leave  
  800f67:	c3                   	ret    

00800f68 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800f68:	55                   	push   %ebp
  800f69:	89 e5                	mov    %esp,%ebp
  800f6b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800f6e:	8d 45 10             	lea    0x10(%ebp),%eax
  800f71:	83 c0 04             	add    $0x4,%eax
  800f74:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800f77:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800f7c:	85 c0                	test   %eax,%eax
  800f7e:	74 16                	je     800f96 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800f80:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800f85:	83 ec 08             	sub    $0x8,%esp
  800f88:	50                   	push   %eax
  800f89:	68 3c 41 80 00       	push   $0x80413c
  800f8e:	e8 89 02 00 00       	call   80121c <cprintf>
  800f93:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800f96:	a1 00 50 80 00       	mov    0x805000,%eax
  800f9b:	ff 75 0c             	pushl  0xc(%ebp)
  800f9e:	ff 75 08             	pushl  0x8(%ebp)
  800fa1:	50                   	push   %eax
  800fa2:	68 41 41 80 00       	push   $0x804141
  800fa7:	e8 70 02 00 00       	call   80121c <cprintf>
  800fac:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800faf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb2:	83 ec 08             	sub    $0x8,%esp
  800fb5:	ff 75 f4             	pushl  -0xc(%ebp)
  800fb8:	50                   	push   %eax
  800fb9:	e8 f3 01 00 00       	call   8011b1 <vcprintf>
  800fbe:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800fc1:	83 ec 08             	sub    $0x8,%esp
  800fc4:	6a 00                	push   $0x0
  800fc6:	68 5d 41 80 00       	push   $0x80415d
  800fcb:	e8 e1 01 00 00       	call   8011b1 <vcprintf>
  800fd0:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800fd3:	e8 82 ff ff ff       	call   800f5a <exit>

	// should not return here
	while (1) ;
  800fd8:	eb fe                	jmp    800fd8 <_panic+0x70>

00800fda <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800fda:	55                   	push   %ebp
  800fdb:	89 e5                	mov    %esp,%ebp
  800fdd:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800fe0:	a1 20 50 80 00       	mov    0x805020,%eax
  800fe5:	8b 50 74             	mov    0x74(%eax),%edx
  800fe8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800feb:	39 c2                	cmp    %eax,%edx
  800fed:	74 14                	je     801003 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800fef:	83 ec 04             	sub    $0x4,%esp
  800ff2:	68 60 41 80 00       	push   $0x804160
  800ff7:	6a 26                	push   $0x26
  800ff9:	68 ac 41 80 00       	push   $0x8041ac
  800ffe:	e8 65 ff ff ff       	call   800f68 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801003:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80100a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801011:	e9 c2 00 00 00       	jmp    8010d8 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  801016:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801019:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801020:	8b 45 08             	mov    0x8(%ebp),%eax
  801023:	01 d0                	add    %edx,%eax
  801025:	8b 00                	mov    (%eax),%eax
  801027:	85 c0                	test   %eax,%eax
  801029:	75 08                	jne    801033 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80102b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80102e:	e9 a2 00 00 00       	jmp    8010d5 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  801033:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80103a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801041:	eb 69                	jmp    8010ac <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801043:	a1 20 50 80 00       	mov    0x805020,%eax
  801048:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80104e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801051:	89 d0                	mov    %edx,%eax
  801053:	01 c0                	add    %eax,%eax
  801055:	01 d0                	add    %edx,%eax
  801057:	c1 e0 03             	shl    $0x3,%eax
  80105a:	01 c8                	add    %ecx,%eax
  80105c:	8a 40 04             	mov    0x4(%eax),%al
  80105f:	84 c0                	test   %al,%al
  801061:	75 46                	jne    8010a9 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801063:	a1 20 50 80 00       	mov    0x805020,%eax
  801068:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80106e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801071:	89 d0                	mov    %edx,%eax
  801073:	01 c0                	add    %eax,%eax
  801075:	01 d0                	add    %edx,%eax
  801077:	c1 e0 03             	shl    $0x3,%eax
  80107a:	01 c8                	add    %ecx,%eax
  80107c:	8b 00                	mov    (%eax),%eax
  80107e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801081:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801084:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801089:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80108b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80108e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801095:	8b 45 08             	mov    0x8(%ebp),%eax
  801098:	01 c8                	add    %ecx,%eax
  80109a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80109c:	39 c2                	cmp    %eax,%edx
  80109e:	75 09                	jne    8010a9 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8010a0:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8010a7:	eb 12                	jmp    8010bb <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8010a9:	ff 45 e8             	incl   -0x18(%ebp)
  8010ac:	a1 20 50 80 00       	mov    0x805020,%eax
  8010b1:	8b 50 74             	mov    0x74(%eax),%edx
  8010b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8010b7:	39 c2                	cmp    %eax,%edx
  8010b9:	77 88                	ja     801043 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8010bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8010bf:	75 14                	jne    8010d5 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8010c1:	83 ec 04             	sub    $0x4,%esp
  8010c4:	68 b8 41 80 00       	push   $0x8041b8
  8010c9:	6a 3a                	push   $0x3a
  8010cb:	68 ac 41 80 00       	push   $0x8041ac
  8010d0:	e8 93 fe ff ff       	call   800f68 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8010d5:	ff 45 f0             	incl   -0x10(%ebp)
  8010d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010db:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8010de:	0f 8c 32 ff ff ff    	jl     801016 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8010e4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8010eb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8010f2:	eb 26                	jmp    80111a <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8010f4:	a1 20 50 80 00       	mov    0x805020,%eax
  8010f9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8010ff:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801102:	89 d0                	mov    %edx,%eax
  801104:	01 c0                	add    %eax,%eax
  801106:	01 d0                	add    %edx,%eax
  801108:	c1 e0 03             	shl    $0x3,%eax
  80110b:	01 c8                	add    %ecx,%eax
  80110d:	8a 40 04             	mov    0x4(%eax),%al
  801110:	3c 01                	cmp    $0x1,%al
  801112:	75 03                	jne    801117 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  801114:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801117:	ff 45 e0             	incl   -0x20(%ebp)
  80111a:	a1 20 50 80 00       	mov    0x805020,%eax
  80111f:	8b 50 74             	mov    0x74(%eax),%edx
  801122:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801125:	39 c2                	cmp    %eax,%edx
  801127:	77 cb                	ja     8010f4 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801129:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80112c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80112f:	74 14                	je     801145 <CheckWSWithoutLastIndex+0x16b>
		panic(
  801131:	83 ec 04             	sub    $0x4,%esp
  801134:	68 0c 42 80 00       	push   $0x80420c
  801139:	6a 44                	push   $0x44
  80113b:	68 ac 41 80 00       	push   $0x8041ac
  801140:	e8 23 fe ff ff       	call   800f68 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801145:	90                   	nop
  801146:	c9                   	leave  
  801147:	c3                   	ret    

00801148 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  801148:	55                   	push   %ebp
  801149:	89 e5                	mov    %esp,%ebp
  80114b:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80114e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801151:	8b 00                	mov    (%eax),%eax
  801153:	8d 48 01             	lea    0x1(%eax),%ecx
  801156:	8b 55 0c             	mov    0xc(%ebp),%edx
  801159:	89 0a                	mov    %ecx,(%edx)
  80115b:	8b 55 08             	mov    0x8(%ebp),%edx
  80115e:	88 d1                	mov    %dl,%cl
  801160:	8b 55 0c             	mov    0xc(%ebp),%edx
  801163:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801167:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116a:	8b 00                	mov    (%eax),%eax
  80116c:	3d ff 00 00 00       	cmp    $0xff,%eax
  801171:	75 2c                	jne    80119f <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  801173:	a0 24 50 80 00       	mov    0x805024,%al
  801178:	0f b6 c0             	movzbl %al,%eax
  80117b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80117e:	8b 12                	mov    (%edx),%edx
  801180:	89 d1                	mov    %edx,%ecx
  801182:	8b 55 0c             	mov    0xc(%ebp),%edx
  801185:	83 c2 08             	add    $0x8,%edx
  801188:	83 ec 04             	sub    $0x4,%esp
  80118b:	50                   	push   %eax
  80118c:	51                   	push   %ecx
  80118d:	52                   	push   %edx
  80118e:	e8 80 13 00 00       	call   802513 <sys_cputs>
  801193:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801196:	8b 45 0c             	mov    0xc(%ebp),%eax
  801199:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80119f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a2:	8b 40 04             	mov    0x4(%eax),%eax
  8011a5:	8d 50 01             	lea    0x1(%eax),%edx
  8011a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ab:	89 50 04             	mov    %edx,0x4(%eax)
}
  8011ae:	90                   	nop
  8011af:	c9                   	leave  
  8011b0:	c3                   	ret    

008011b1 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8011b1:	55                   	push   %ebp
  8011b2:	89 e5                	mov    %esp,%ebp
  8011b4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8011ba:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8011c1:	00 00 00 
	b.cnt = 0;
  8011c4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8011cb:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8011ce:	ff 75 0c             	pushl  0xc(%ebp)
  8011d1:	ff 75 08             	pushl  0x8(%ebp)
  8011d4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8011da:	50                   	push   %eax
  8011db:	68 48 11 80 00       	push   $0x801148
  8011e0:	e8 11 02 00 00       	call   8013f6 <vprintfmt>
  8011e5:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8011e8:	a0 24 50 80 00       	mov    0x805024,%al
  8011ed:	0f b6 c0             	movzbl %al,%eax
  8011f0:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8011f6:	83 ec 04             	sub    $0x4,%esp
  8011f9:	50                   	push   %eax
  8011fa:	52                   	push   %edx
  8011fb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801201:	83 c0 08             	add    $0x8,%eax
  801204:	50                   	push   %eax
  801205:	e8 09 13 00 00       	call   802513 <sys_cputs>
  80120a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80120d:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  801214:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80121a:	c9                   	leave  
  80121b:	c3                   	ret    

0080121c <cprintf>:

int cprintf(const char *fmt, ...) {
  80121c:	55                   	push   %ebp
  80121d:	89 e5                	mov    %esp,%ebp
  80121f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801222:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  801229:	8d 45 0c             	lea    0xc(%ebp),%eax
  80122c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80122f:	8b 45 08             	mov    0x8(%ebp),%eax
  801232:	83 ec 08             	sub    $0x8,%esp
  801235:	ff 75 f4             	pushl  -0xc(%ebp)
  801238:	50                   	push   %eax
  801239:	e8 73 ff ff ff       	call   8011b1 <vcprintf>
  80123e:	83 c4 10             	add    $0x10,%esp
  801241:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801244:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801247:	c9                   	leave  
  801248:	c3                   	ret    

00801249 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  801249:	55                   	push   %ebp
  80124a:	89 e5                	mov    %esp,%ebp
  80124c:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80124f:	e8 6d 14 00 00       	call   8026c1 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801254:	8d 45 0c             	lea    0xc(%ebp),%eax
  801257:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
  80125d:	83 ec 08             	sub    $0x8,%esp
  801260:	ff 75 f4             	pushl  -0xc(%ebp)
  801263:	50                   	push   %eax
  801264:	e8 48 ff ff ff       	call   8011b1 <vcprintf>
  801269:	83 c4 10             	add    $0x10,%esp
  80126c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80126f:	e8 67 14 00 00       	call   8026db <sys_enable_interrupt>
	return cnt;
  801274:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801277:	c9                   	leave  
  801278:	c3                   	ret    

00801279 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801279:	55                   	push   %ebp
  80127a:	89 e5                	mov    %esp,%ebp
  80127c:	53                   	push   %ebx
  80127d:	83 ec 14             	sub    $0x14,%esp
  801280:	8b 45 10             	mov    0x10(%ebp),%eax
  801283:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801286:	8b 45 14             	mov    0x14(%ebp),%eax
  801289:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80128c:	8b 45 18             	mov    0x18(%ebp),%eax
  80128f:	ba 00 00 00 00       	mov    $0x0,%edx
  801294:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801297:	77 55                	ja     8012ee <printnum+0x75>
  801299:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80129c:	72 05                	jb     8012a3 <printnum+0x2a>
  80129e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012a1:	77 4b                	ja     8012ee <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8012a3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8012a6:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8012a9:	8b 45 18             	mov    0x18(%ebp),%eax
  8012ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8012b1:	52                   	push   %edx
  8012b2:	50                   	push   %eax
  8012b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8012b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8012b9:	e8 ce 29 00 00       	call   803c8c <__udivdi3>
  8012be:	83 c4 10             	add    $0x10,%esp
  8012c1:	83 ec 04             	sub    $0x4,%esp
  8012c4:	ff 75 20             	pushl  0x20(%ebp)
  8012c7:	53                   	push   %ebx
  8012c8:	ff 75 18             	pushl  0x18(%ebp)
  8012cb:	52                   	push   %edx
  8012cc:	50                   	push   %eax
  8012cd:	ff 75 0c             	pushl  0xc(%ebp)
  8012d0:	ff 75 08             	pushl  0x8(%ebp)
  8012d3:	e8 a1 ff ff ff       	call   801279 <printnum>
  8012d8:	83 c4 20             	add    $0x20,%esp
  8012db:	eb 1a                	jmp    8012f7 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8012dd:	83 ec 08             	sub    $0x8,%esp
  8012e0:	ff 75 0c             	pushl  0xc(%ebp)
  8012e3:	ff 75 20             	pushl  0x20(%ebp)
  8012e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e9:	ff d0                	call   *%eax
  8012eb:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8012ee:	ff 4d 1c             	decl   0x1c(%ebp)
  8012f1:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8012f5:	7f e6                	jg     8012dd <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8012f7:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8012fa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801302:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801305:	53                   	push   %ebx
  801306:	51                   	push   %ecx
  801307:	52                   	push   %edx
  801308:	50                   	push   %eax
  801309:	e8 8e 2a 00 00       	call   803d9c <__umoddi3>
  80130e:	83 c4 10             	add    $0x10,%esp
  801311:	05 74 44 80 00       	add    $0x804474,%eax
  801316:	8a 00                	mov    (%eax),%al
  801318:	0f be c0             	movsbl %al,%eax
  80131b:	83 ec 08             	sub    $0x8,%esp
  80131e:	ff 75 0c             	pushl  0xc(%ebp)
  801321:	50                   	push   %eax
  801322:	8b 45 08             	mov    0x8(%ebp),%eax
  801325:	ff d0                	call   *%eax
  801327:	83 c4 10             	add    $0x10,%esp
}
  80132a:	90                   	nop
  80132b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80132e:	c9                   	leave  
  80132f:	c3                   	ret    

00801330 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801330:	55                   	push   %ebp
  801331:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801333:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801337:	7e 1c                	jle    801355 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801339:	8b 45 08             	mov    0x8(%ebp),%eax
  80133c:	8b 00                	mov    (%eax),%eax
  80133e:	8d 50 08             	lea    0x8(%eax),%edx
  801341:	8b 45 08             	mov    0x8(%ebp),%eax
  801344:	89 10                	mov    %edx,(%eax)
  801346:	8b 45 08             	mov    0x8(%ebp),%eax
  801349:	8b 00                	mov    (%eax),%eax
  80134b:	83 e8 08             	sub    $0x8,%eax
  80134e:	8b 50 04             	mov    0x4(%eax),%edx
  801351:	8b 00                	mov    (%eax),%eax
  801353:	eb 40                	jmp    801395 <getuint+0x65>
	else if (lflag)
  801355:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801359:	74 1e                	je     801379 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80135b:	8b 45 08             	mov    0x8(%ebp),%eax
  80135e:	8b 00                	mov    (%eax),%eax
  801360:	8d 50 04             	lea    0x4(%eax),%edx
  801363:	8b 45 08             	mov    0x8(%ebp),%eax
  801366:	89 10                	mov    %edx,(%eax)
  801368:	8b 45 08             	mov    0x8(%ebp),%eax
  80136b:	8b 00                	mov    (%eax),%eax
  80136d:	83 e8 04             	sub    $0x4,%eax
  801370:	8b 00                	mov    (%eax),%eax
  801372:	ba 00 00 00 00       	mov    $0x0,%edx
  801377:	eb 1c                	jmp    801395 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801379:	8b 45 08             	mov    0x8(%ebp),%eax
  80137c:	8b 00                	mov    (%eax),%eax
  80137e:	8d 50 04             	lea    0x4(%eax),%edx
  801381:	8b 45 08             	mov    0x8(%ebp),%eax
  801384:	89 10                	mov    %edx,(%eax)
  801386:	8b 45 08             	mov    0x8(%ebp),%eax
  801389:	8b 00                	mov    (%eax),%eax
  80138b:	83 e8 04             	sub    $0x4,%eax
  80138e:	8b 00                	mov    (%eax),%eax
  801390:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801395:	5d                   	pop    %ebp
  801396:	c3                   	ret    

00801397 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801397:	55                   	push   %ebp
  801398:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80139a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80139e:	7e 1c                	jle    8013bc <getint+0x25>
		return va_arg(*ap, long long);
  8013a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a3:	8b 00                	mov    (%eax),%eax
  8013a5:	8d 50 08             	lea    0x8(%eax),%edx
  8013a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ab:	89 10                	mov    %edx,(%eax)
  8013ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b0:	8b 00                	mov    (%eax),%eax
  8013b2:	83 e8 08             	sub    $0x8,%eax
  8013b5:	8b 50 04             	mov    0x4(%eax),%edx
  8013b8:	8b 00                	mov    (%eax),%eax
  8013ba:	eb 38                	jmp    8013f4 <getint+0x5d>
	else if (lflag)
  8013bc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013c0:	74 1a                	je     8013dc <getint+0x45>
		return va_arg(*ap, long);
  8013c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c5:	8b 00                	mov    (%eax),%eax
  8013c7:	8d 50 04             	lea    0x4(%eax),%edx
  8013ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cd:	89 10                	mov    %edx,(%eax)
  8013cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d2:	8b 00                	mov    (%eax),%eax
  8013d4:	83 e8 04             	sub    $0x4,%eax
  8013d7:	8b 00                	mov    (%eax),%eax
  8013d9:	99                   	cltd   
  8013da:	eb 18                	jmp    8013f4 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8013dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013df:	8b 00                	mov    (%eax),%eax
  8013e1:	8d 50 04             	lea    0x4(%eax),%edx
  8013e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e7:	89 10                	mov    %edx,(%eax)
  8013e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ec:	8b 00                	mov    (%eax),%eax
  8013ee:	83 e8 04             	sub    $0x4,%eax
  8013f1:	8b 00                	mov    (%eax),%eax
  8013f3:	99                   	cltd   
}
  8013f4:	5d                   	pop    %ebp
  8013f5:	c3                   	ret    

008013f6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8013f6:	55                   	push   %ebp
  8013f7:	89 e5                	mov    %esp,%ebp
  8013f9:	56                   	push   %esi
  8013fa:	53                   	push   %ebx
  8013fb:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8013fe:	eb 17                	jmp    801417 <vprintfmt+0x21>
			if (ch == '\0')
  801400:	85 db                	test   %ebx,%ebx
  801402:	0f 84 af 03 00 00    	je     8017b7 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801408:	83 ec 08             	sub    $0x8,%esp
  80140b:	ff 75 0c             	pushl  0xc(%ebp)
  80140e:	53                   	push   %ebx
  80140f:	8b 45 08             	mov    0x8(%ebp),%eax
  801412:	ff d0                	call   *%eax
  801414:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801417:	8b 45 10             	mov    0x10(%ebp),%eax
  80141a:	8d 50 01             	lea    0x1(%eax),%edx
  80141d:	89 55 10             	mov    %edx,0x10(%ebp)
  801420:	8a 00                	mov    (%eax),%al
  801422:	0f b6 d8             	movzbl %al,%ebx
  801425:	83 fb 25             	cmp    $0x25,%ebx
  801428:	75 d6                	jne    801400 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80142a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80142e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801435:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80143c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801443:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80144a:	8b 45 10             	mov    0x10(%ebp),%eax
  80144d:	8d 50 01             	lea    0x1(%eax),%edx
  801450:	89 55 10             	mov    %edx,0x10(%ebp)
  801453:	8a 00                	mov    (%eax),%al
  801455:	0f b6 d8             	movzbl %al,%ebx
  801458:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80145b:	83 f8 55             	cmp    $0x55,%eax
  80145e:	0f 87 2b 03 00 00    	ja     80178f <vprintfmt+0x399>
  801464:	8b 04 85 98 44 80 00 	mov    0x804498(,%eax,4),%eax
  80146b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80146d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801471:	eb d7                	jmp    80144a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801473:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801477:	eb d1                	jmp    80144a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801479:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801480:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801483:	89 d0                	mov    %edx,%eax
  801485:	c1 e0 02             	shl    $0x2,%eax
  801488:	01 d0                	add    %edx,%eax
  80148a:	01 c0                	add    %eax,%eax
  80148c:	01 d8                	add    %ebx,%eax
  80148e:	83 e8 30             	sub    $0x30,%eax
  801491:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801494:	8b 45 10             	mov    0x10(%ebp),%eax
  801497:	8a 00                	mov    (%eax),%al
  801499:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80149c:	83 fb 2f             	cmp    $0x2f,%ebx
  80149f:	7e 3e                	jle    8014df <vprintfmt+0xe9>
  8014a1:	83 fb 39             	cmp    $0x39,%ebx
  8014a4:	7f 39                	jg     8014df <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8014a6:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8014a9:	eb d5                	jmp    801480 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8014ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ae:	83 c0 04             	add    $0x4,%eax
  8014b1:	89 45 14             	mov    %eax,0x14(%ebp)
  8014b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8014b7:	83 e8 04             	sub    $0x4,%eax
  8014ba:	8b 00                	mov    (%eax),%eax
  8014bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8014bf:	eb 1f                	jmp    8014e0 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8014c1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014c5:	79 83                	jns    80144a <vprintfmt+0x54>
				width = 0;
  8014c7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8014ce:	e9 77 ff ff ff       	jmp    80144a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8014d3:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8014da:	e9 6b ff ff ff       	jmp    80144a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8014df:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8014e0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014e4:	0f 89 60 ff ff ff    	jns    80144a <vprintfmt+0x54>
				width = precision, precision = -1;
  8014ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8014f0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8014f7:	e9 4e ff ff ff       	jmp    80144a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8014fc:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8014ff:	e9 46 ff ff ff       	jmp    80144a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801504:	8b 45 14             	mov    0x14(%ebp),%eax
  801507:	83 c0 04             	add    $0x4,%eax
  80150a:	89 45 14             	mov    %eax,0x14(%ebp)
  80150d:	8b 45 14             	mov    0x14(%ebp),%eax
  801510:	83 e8 04             	sub    $0x4,%eax
  801513:	8b 00                	mov    (%eax),%eax
  801515:	83 ec 08             	sub    $0x8,%esp
  801518:	ff 75 0c             	pushl  0xc(%ebp)
  80151b:	50                   	push   %eax
  80151c:	8b 45 08             	mov    0x8(%ebp),%eax
  80151f:	ff d0                	call   *%eax
  801521:	83 c4 10             	add    $0x10,%esp
			break;
  801524:	e9 89 02 00 00       	jmp    8017b2 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801529:	8b 45 14             	mov    0x14(%ebp),%eax
  80152c:	83 c0 04             	add    $0x4,%eax
  80152f:	89 45 14             	mov    %eax,0x14(%ebp)
  801532:	8b 45 14             	mov    0x14(%ebp),%eax
  801535:	83 e8 04             	sub    $0x4,%eax
  801538:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80153a:	85 db                	test   %ebx,%ebx
  80153c:	79 02                	jns    801540 <vprintfmt+0x14a>
				err = -err;
  80153e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801540:	83 fb 64             	cmp    $0x64,%ebx
  801543:	7f 0b                	jg     801550 <vprintfmt+0x15a>
  801545:	8b 34 9d e0 42 80 00 	mov    0x8042e0(,%ebx,4),%esi
  80154c:	85 f6                	test   %esi,%esi
  80154e:	75 19                	jne    801569 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801550:	53                   	push   %ebx
  801551:	68 85 44 80 00       	push   $0x804485
  801556:	ff 75 0c             	pushl  0xc(%ebp)
  801559:	ff 75 08             	pushl  0x8(%ebp)
  80155c:	e8 5e 02 00 00       	call   8017bf <printfmt>
  801561:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801564:	e9 49 02 00 00       	jmp    8017b2 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801569:	56                   	push   %esi
  80156a:	68 8e 44 80 00       	push   $0x80448e
  80156f:	ff 75 0c             	pushl  0xc(%ebp)
  801572:	ff 75 08             	pushl  0x8(%ebp)
  801575:	e8 45 02 00 00       	call   8017bf <printfmt>
  80157a:	83 c4 10             	add    $0x10,%esp
			break;
  80157d:	e9 30 02 00 00       	jmp    8017b2 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801582:	8b 45 14             	mov    0x14(%ebp),%eax
  801585:	83 c0 04             	add    $0x4,%eax
  801588:	89 45 14             	mov    %eax,0x14(%ebp)
  80158b:	8b 45 14             	mov    0x14(%ebp),%eax
  80158e:	83 e8 04             	sub    $0x4,%eax
  801591:	8b 30                	mov    (%eax),%esi
  801593:	85 f6                	test   %esi,%esi
  801595:	75 05                	jne    80159c <vprintfmt+0x1a6>
				p = "(null)";
  801597:	be 91 44 80 00       	mov    $0x804491,%esi
			if (width > 0 && padc != '-')
  80159c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8015a0:	7e 6d                	jle    80160f <vprintfmt+0x219>
  8015a2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8015a6:	74 67                	je     80160f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8015a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015ab:	83 ec 08             	sub    $0x8,%esp
  8015ae:	50                   	push   %eax
  8015af:	56                   	push   %esi
  8015b0:	e8 0c 03 00 00       	call   8018c1 <strnlen>
  8015b5:	83 c4 10             	add    $0x10,%esp
  8015b8:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8015bb:	eb 16                	jmp    8015d3 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8015bd:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8015c1:	83 ec 08             	sub    $0x8,%esp
  8015c4:	ff 75 0c             	pushl  0xc(%ebp)
  8015c7:	50                   	push   %eax
  8015c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cb:	ff d0                	call   *%eax
  8015cd:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8015d0:	ff 4d e4             	decl   -0x1c(%ebp)
  8015d3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8015d7:	7f e4                	jg     8015bd <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8015d9:	eb 34                	jmp    80160f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8015db:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8015df:	74 1c                	je     8015fd <vprintfmt+0x207>
  8015e1:	83 fb 1f             	cmp    $0x1f,%ebx
  8015e4:	7e 05                	jle    8015eb <vprintfmt+0x1f5>
  8015e6:	83 fb 7e             	cmp    $0x7e,%ebx
  8015e9:	7e 12                	jle    8015fd <vprintfmt+0x207>
					putch('?', putdat);
  8015eb:	83 ec 08             	sub    $0x8,%esp
  8015ee:	ff 75 0c             	pushl  0xc(%ebp)
  8015f1:	6a 3f                	push   $0x3f
  8015f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f6:	ff d0                	call   *%eax
  8015f8:	83 c4 10             	add    $0x10,%esp
  8015fb:	eb 0f                	jmp    80160c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8015fd:	83 ec 08             	sub    $0x8,%esp
  801600:	ff 75 0c             	pushl  0xc(%ebp)
  801603:	53                   	push   %ebx
  801604:	8b 45 08             	mov    0x8(%ebp),%eax
  801607:	ff d0                	call   *%eax
  801609:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80160c:	ff 4d e4             	decl   -0x1c(%ebp)
  80160f:	89 f0                	mov    %esi,%eax
  801611:	8d 70 01             	lea    0x1(%eax),%esi
  801614:	8a 00                	mov    (%eax),%al
  801616:	0f be d8             	movsbl %al,%ebx
  801619:	85 db                	test   %ebx,%ebx
  80161b:	74 24                	je     801641 <vprintfmt+0x24b>
  80161d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801621:	78 b8                	js     8015db <vprintfmt+0x1e5>
  801623:	ff 4d e0             	decl   -0x20(%ebp)
  801626:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80162a:	79 af                	jns    8015db <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80162c:	eb 13                	jmp    801641 <vprintfmt+0x24b>
				putch(' ', putdat);
  80162e:	83 ec 08             	sub    $0x8,%esp
  801631:	ff 75 0c             	pushl  0xc(%ebp)
  801634:	6a 20                	push   $0x20
  801636:	8b 45 08             	mov    0x8(%ebp),%eax
  801639:	ff d0                	call   *%eax
  80163b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80163e:	ff 4d e4             	decl   -0x1c(%ebp)
  801641:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801645:	7f e7                	jg     80162e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801647:	e9 66 01 00 00       	jmp    8017b2 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80164c:	83 ec 08             	sub    $0x8,%esp
  80164f:	ff 75 e8             	pushl  -0x18(%ebp)
  801652:	8d 45 14             	lea    0x14(%ebp),%eax
  801655:	50                   	push   %eax
  801656:	e8 3c fd ff ff       	call   801397 <getint>
  80165b:	83 c4 10             	add    $0x10,%esp
  80165e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801661:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801664:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801667:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80166a:	85 d2                	test   %edx,%edx
  80166c:	79 23                	jns    801691 <vprintfmt+0x29b>
				putch('-', putdat);
  80166e:	83 ec 08             	sub    $0x8,%esp
  801671:	ff 75 0c             	pushl  0xc(%ebp)
  801674:	6a 2d                	push   $0x2d
  801676:	8b 45 08             	mov    0x8(%ebp),%eax
  801679:	ff d0                	call   *%eax
  80167b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80167e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801681:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801684:	f7 d8                	neg    %eax
  801686:	83 d2 00             	adc    $0x0,%edx
  801689:	f7 da                	neg    %edx
  80168b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80168e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801691:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801698:	e9 bc 00 00 00       	jmp    801759 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80169d:	83 ec 08             	sub    $0x8,%esp
  8016a0:	ff 75 e8             	pushl  -0x18(%ebp)
  8016a3:	8d 45 14             	lea    0x14(%ebp),%eax
  8016a6:	50                   	push   %eax
  8016a7:	e8 84 fc ff ff       	call   801330 <getuint>
  8016ac:	83 c4 10             	add    $0x10,%esp
  8016af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016b2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8016b5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8016bc:	e9 98 00 00 00       	jmp    801759 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8016c1:	83 ec 08             	sub    $0x8,%esp
  8016c4:	ff 75 0c             	pushl  0xc(%ebp)
  8016c7:	6a 58                	push   $0x58
  8016c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cc:	ff d0                	call   *%eax
  8016ce:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8016d1:	83 ec 08             	sub    $0x8,%esp
  8016d4:	ff 75 0c             	pushl  0xc(%ebp)
  8016d7:	6a 58                	push   $0x58
  8016d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dc:	ff d0                	call   *%eax
  8016de:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8016e1:	83 ec 08             	sub    $0x8,%esp
  8016e4:	ff 75 0c             	pushl  0xc(%ebp)
  8016e7:	6a 58                	push   $0x58
  8016e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ec:	ff d0                	call   *%eax
  8016ee:	83 c4 10             	add    $0x10,%esp
			break;
  8016f1:	e9 bc 00 00 00       	jmp    8017b2 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8016f6:	83 ec 08             	sub    $0x8,%esp
  8016f9:	ff 75 0c             	pushl  0xc(%ebp)
  8016fc:	6a 30                	push   $0x30
  8016fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801701:	ff d0                	call   *%eax
  801703:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801706:	83 ec 08             	sub    $0x8,%esp
  801709:	ff 75 0c             	pushl  0xc(%ebp)
  80170c:	6a 78                	push   $0x78
  80170e:	8b 45 08             	mov    0x8(%ebp),%eax
  801711:	ff d0                	call   *%eax
  801713:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801716:	8b 45 14             	mov    0x14(%ebp),%eax
  801719:	83 c0 04             	add    $0x4,%eax
  80171c:	89 45 14             	mov    %eax,0x14(%ebp)
  80171f:	8b 45 14             	mov    0x14(%ebp),%eax
  801722:	83 e8 04             	sub    $0x4,%eax
  801725:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801727:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80172a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801731:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801738:	eb 1f                	jmp    801759 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80173a:	83 ec 08             	sub    $0x8,%esp
  80173d:	ff 75 e8             	pushl  -0x18(%ebp)
  801740:	8d 45 14             	lea    0x14(%ebp),%eax
  801743:	50                   	push   %eax
  801744:	e8 e7 fb ff ff       	call   801330 <getuint>
  801749:	83 c4 10             	add    $0x10,%esp
  80174c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80174f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801752:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801759:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80175d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801760:	83 ec 04             	sub    $0x4,%esp
  801763:	52                   	push   %edx
  801764:	ff 75 e4             	pushl  -0x1c(%ebp)
  801767:	50                   	push   %eax
  801768:	ff 75 f4             	pushl  -0xc(%ebp)
  80176b:	ff 75 f0             	pushl  -0x10(%ebp)
  80176e:	ff 75 0c             	pushl  0xc(%ebp)
  801771:	ff 75 08             	pushl  0x8(%ebp)
  801774:	e8 00 fb ff ff       	call   801279 <printnum>
  801779:	83 c4 20             	add    $0x20,%esp
			break;
  80177c:	eb 34                	jmp    8017b2 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80177e:	83 ec 08             	sub    $0x8,%esp
  801781:	ff 75 0c             	pushl  0xc(%ebp)
  801784:	53                   	push   %ebx
  801785:	8b 45 08             	mov    0x8(%ebp),%eax
  801788:	ff d0                	call   *%eax
  80178a:	83 c4 10             	add    $0x10,%esp
			break;
  80178d:	eb 23                	jmp    8017b2 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80178f:	83 ec 08             	sub    $0x8,%esp
  801792:	ff 75 0c             	pushl  0xc(%ebp)
  801795:	6a 25                	push   $0x25
  801797:	8b 45 08             	mov    0x8(%ebp),%eax
  80179a:	ff d0                	call   *%eax
  80179c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80179f:	ff 4d 10             	decl   0x10(%ebp)
  8017a2:	eb 03                	jmp    8017a7 <vprintfmt+0x3b1>
  8017a4:	ff 4d 10             	decl   0x10(%ebp)
  8017a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8017aa:	48                   	dec    %eax
  8017ab:	8a 00                	mov    (%eax),%al
  8017ad:	3c 25                	cmp    $0x25,%al
  8017af:	75 f3                	jne    8017a4 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8017b1:	90                   	nop
		}
	}
  8017b2:	e9 47 fc ff ff       	jmp    8013fe <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8017b7:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8017b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017bb:	5b                   	pop    %ebx
  8017bc:	5e                   	pop    %esi
  8017bd:	5d                   	pop    %ebp
  8017be:	c3                   	ret    

008017bf <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8017bf:	55                   	push   %ebp
  8017c0:	89 e5                	mov    %esp,%ebp
  8017c2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8017c5:	8d 45 10             	lea    0x10(%ebp),%eax
  8017c8:	83 c0 04             	add    $0x4,%eax
  8017cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8017ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8017d4:	50                   	push   %eax
  8017d5:	ff 75 0c             	pushl  0xc(%ebp)
  8017d8:	ff 75 08             	pushl  0x8(%ebp)
  8017db:	e8 16 fc ff ff       	call   8013f6 <vprintfmt>
  8017e0:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8017e3:	90                   	nop
  8017e4:	c9                   	leave  
  8017e5:	c3                   	ret    

008017e6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8017e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ec:	8b 40 08             	mov    0x8(%eax),%eax
  8017ef:	8d 50 01             	lea    0x1(%eax),%edx
  8017f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f5:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8017f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017fb:	8b 10                	mov    (%eax),%edx
  8017fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801800:	8b 40 04             	mov    0x4(%eax),%eax
  801803:	39 c2                	cmp    %eax,%edx
  801805:	73 12                	jae    801819 <sprintputch+0x33>
		*b->buf++ = ch;
  801807:	8b 45 0c             	mov    0xc(%ebp),%eax
  80180a:	8b 00                	mov    (%eax),%eax
  80180c:	8d 48 01             	lea    0x1(%eax),%ecx
  80180f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801812:	89 0a                	mov    %ecx,(%edx)
  801814:	8b 55 08             	mov    0x8(%ebp),%edx
  801817:	88 10                	mov    %dl,(%eax)
}
  801819:	90                   	nop
  80181a:	5d                   	pop    %ebp
  80181b:	c3                   	ret    

0080181c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
  80181f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801822:	8b 45 08             	mov    0x8(%ebp),%eax
  801825:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801828:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
  801831:	01 d0                	add    %edx,%eax
  801833:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801836:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80183d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801841:	74 06                	je     801849 <vsnprintf+0x2d>
  801843:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801847:	7f 07                	jg     801850 <vsnprintf+0x34>
		return -E_INVAL;
  801849:	b8 03 00 00 00       	mov    $0x3,%eax
  80184e:	eb 20                	jmp    801870 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801850:	ff 75 14             	pushl  0x14(%ebp)
  801853:	ff 75 10             	pushl  0x10(%ebp)
  801856:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801859:	50                   	push   %eax
  80185a:	68 e6 17 80 00       	push   $0x8017e6
  80185f:	e8 92 fb ff ff       	call   8013f6 <vprintfmt>
  801864:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801867:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80186a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80186d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801870:	c9                   	leave  
  801871:	c3                   	ret    

00801872 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
  801875:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801878:	8d 45 10             	lea    0x10(%ebp),%eax
  80187b:	83 c0 04             	add    $0x4,%eax
  80187e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801881:	8b 45 10             	mov    0x10(%ebp),%eax
  801884:	ff 75 f4             	pushl  -0xc(%ebp)
  801887:	50                   	push   %eax
  801888:	ff 75 0c             	pushl  0xc(%ebp)
  80188b:	ff 75 08             	pushl  0x8(%ebp)
  80188e:	e8 89 ff ff ff       	call   80181c <vsnprintf>
  801893:	83 c4 10             	add    $0x10,%esp
  801896:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801899:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80189c:	c9                   	leave  
  80189d:	c3                   	ret    

0080189e <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80189e:	55                   	push   %ebp
  80189f:	89 e5                	mov    %esp,%ebp
  8018a1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8018a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8018ab:	eb 06                	jmp    8018b3 <strlen+0x15>
		n++;
  8018ad:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8018b0:	ff 45 08             	incl   0x8(%ebp)
  8018b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b6:	8a 00                	mov    (%eax),%al
  8018b8:	84 c0                	test   %al,%al
  8018ba:	75 f1                	jne    8018ad <strlen+0xf>
		n++;
	return n;
  8018bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8018bf:	c9                   	leave  
  8018c0:	c3                   	ret    

008018c1 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
  8018c4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8018ce:	eb 09                	jmp    8018d9 <strnlen+0x18>
		n++;
  8018d0:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018d3:	ff 45 08             	incl   0x8(%ebp)
  8018d6:	ff 4d 0c             	decl   0xc(%ebp)
  8018d9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018dd:	74 09                	je     8018e8 <strnlen+0x27>
  8018df:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e2:	8a 00                	mov    (%eax),%al
  8018e4:	84 c0                	test   %al,%al
  8018e6:	75 e8                	jne    8018d0 <strnlen+0xf>
		n++;
	return n;
  8018e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8018eb:	c9                   	leave  
  8018ec:	c3                   	ret    

008018ed <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
  8018f0:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8018f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8018f9:	90                   	nop
  8018fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fd:	8d 50 01             	lea    0x1(%eax),%edx
  801900:	89 55 08             	mov    %edx,0x8(%ebp)
  801903:	8b 55 0c             	mov    0xc(%ebp),%edx
  801906:	8d 4a 01             	lea    0x1(%edx),%ecx
  801909:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80190c:	8a 12                	mov    (%edx),%dl
  80190e:	88 10                	mov    %dl,(%eax)
  801910:	8a 00                	mov    (%eax),%al
  801912:	84 c0                	test   %al,%al
  801914:	75 e4                	jne    8018fa <strcpy+0xd>
		/* do nothing */;
	return ret;
  801916:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801919:	c9                   	leave  
  80191a:	c3                   	ret    

0080191b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
  80191e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801921:	8b 45 08             	mov    0x8(%ebp),%eax
  801924:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801927:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80192e:	eb 1f                	jmp    80194f <strncpy+0x34>
		*dst++ = *src;
  801930:	8b 45 08             	mov    0x8(%ebp),%eax
  801933:	8d 50 01             	lea    0x1(%eax),%edx
  801936:	89 55 08             	mov    %edx,0x8(%ebp)
  801939:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193c:	8a 12                	mov    (%edx),%dl
  80193e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801940:	8b 45 0c             	mov    0xc(%ebp),%eax
  801943:	8a 00                	mov    (%eax),%al
  801945:	84 c0                	test   %al,%al
  801947:	74 03                	je     80194c <strncpy+0x31>
			src++;
  801949:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80194c:	ff 45 fc             	incl   -0x4(%ebp)
  80194f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801952:	3b 45 10             	cmp    0x10(%ebp),%eax
  801955:	72 d9                	jb     801930 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801957:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80195a:	c9                   	leave  
  80195b:	c3                   	ret    

0080195c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
  80195f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801962:	8b 45 08             	mov    0x8(%ebp),%eax
  801965:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801968:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80196c:	74 30                	je     80199e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80196e:	eb 16                	jmp    801986 <strlcpy+0x2a>
			*dst++ = *src++;
  801970:	8b 45 08             	mov    0x8(%ebp),%eax
  801973:	8d 50 01             	lea    0x1(%eax),%edx
  801976:	89 55 08             	mov    %edx,0x8(%ebp)
  801979:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80197f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801982:	8a 12                	mov    (%edx),%dl
  801984:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801986:	ff 4d 10             	decl   0x10(%ebp)
  801989:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80198d:	74 09                	je     801998 <strlcpy+0x3c>
  80198f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801992:	8a 00                	mov    (%eax),%al
  801994:	84 c0                	test   %al,%al
  801996:	75 d8                	jne    801970 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801998:	8b 45 08             	mov    0x8(%ebp),%eax
  80199b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80199e:	8b 55 08             	mov    0x8(%ebp),%edx
  8019a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019a4:	29 c2                	sub    %eax,%edx
  8019a6:	89 d0                	mov    %edx,%eax
}
  8019a8:	c9                   	leave  
  8019a9:	c3                   	ret    

008019aa <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8019ad:	eb 06                	jmp    8019b5 <strcmp+0xb>
		p++, q++;
  8019af:	ff 45 08             	incl   0x8(%ebp)
  8019b2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8019b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b8:	8a 00                	mov    (%eax),%al
  8019ba:	84 c0                	test   %al,%al
  8019bc:	74 0e                	je     8019cc <strcmp+0x22>
  8019be:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c1:	8a 10                	mov    (%eax),%dl
  8019c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c6:	8a 00                	mov    (%eax),%al
  8019c8:	38 c2                	cmp    %al,%dl
  8019ca:	74 e3                	je     8019af <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8019cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cf:	8a 00                	mov    (%eax),%al
  8019d1:	0f b6 d0             	movzbl %al,%edx
  8019d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d7:	8a 00                	mov    (%eax),%al
  8019d9:	0f b6 c0             	movzbl %al,%eax
  8019dc:	29 c2                	sub    %eax,%edx
  8019de:	89 d0                	mov    %edx,%eax
}
  8019e0:	5d                   	pop    %ebp
  8019e1:	c3                   	ret    

008019e2 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8019e5:	eb 09                	jmp    8019f0 <strncmp+0xe>
		n--, p++, q++;
  8019e7:	ff 4d 10             	decl   0x10(%ebp)
  8019ea:	ff 45 08             	incl   0x8(%ebp)
  8019ed:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8019f0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019f4:	74 17                	je     801a0d <strncmp+0x2b>
  8019f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f9:	8a 00                	mov    (%eax),%al
  8019fb:	84 c0                	test   %al,%al
  8019fd:	74 0e                	je     801a0d <strncmp+0x2b>
  8019ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801a02:	8a 10                	mov    (%eax),%dl
  801a04:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a07:	8a 00                	mov    (%eax),%al
  801a09:	38 c2                	cmp    %al,%dl
  801a0b:	74 da                	je     8019e7 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801a0d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a11:	75 07                	jne    801a1a <strncmp+0x38>
		return 0;
  801a13:	b8 00 00 00 00       	mov    $0x0,%eax
  801a18:	eb 14                	jmp    801a2e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1d:	8a 00                	mov    (%eax),%al
  801a1f:	0f b6 d0             	movzbl %al,%edx
  801a22:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a25:	8a 00                	mov    (%eax),%al
  801a27:	0f b6 c0             	movzbl %al,%eax
  801a2a:	29 c2                	sub    %eax,%edx
  801a2c:	89 d0                	mov    %edx,%eax
}
  801a2e:	5d                   	pop    %ebp
  801a2f:	c3                   	ret    

00801a30 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
  801a33:	83 ec 04             	sub    $0x4,%esp
  801a36:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a39:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801a3c:	eb 12                	jmp    801a50 <strchr+0x20>
		if (*s == c)
  801a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a41:	8a 00                	mov    (%eax),%al
  801a43:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801a46:	75 05                	jne    801a4d <strchr+0x1d>
			return (char *) s;
  801a48:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4b:	eb 11                	jmp    801a5e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801a4d:	ff 45 08             	incl   0x8(%ebp)
  801a50:	8b 45 08             	mov    0x8(%ebp),%eax
  801a53:	8a 00                	mov    (%eax),%al
  801a55:	84 c0                	test   %al,%al
  801a57:	75 e5                	jne    801a3e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801a59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a5e:	c9                   	leave  
  801a5f:	c3                   	ret    

00801a60 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
  801a63:	83 ec 04             	sub    $0x4,%esp
  801a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a69:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801a6c:	eb 0d                	jmp    801a7b <strfind+0x1b>
		if (*s == c)
  801a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a71:	8a 00                	mov    (%eax),%al
  801a73:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801a76:	74 0e                	je     801a86 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801a78:	ff 45 08             	incl   0x8(%ebp)
  801a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7e:	8a 00                	mov    (%eax),%al
  801a80:	84 c0                	test   %al,%al
  801a82:	75 ea                	jne    801a6e <strfind+0xe>
  801a84:	eb 01                	jmp    801a87 <strfind+0x27>
		if (*s == c)
			break;
  801a86:	90                   	nop
	return (char *) s;
  801a87:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
  801a8f:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801a92:	8b 45 08             	mov    0x8(%ebp),%eax
  801a95:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801a98:	8b 45 10             	mov    0x10(%ebp),%eax
  801a9b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801a9e:	eb 0e                	jmp    801aae <memset+0x22>
		*p++ = c;
  801aa0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801aa3:	8d 50 01             	lea    0x1(%eax),%edx
  801aa6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801aa9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aac:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801aae:	ff 4d f8             	decl   -0x8(%ebp)
  801ab1:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801ab5:	79 e9                	jns    801aa0 <memset+0x14>
		*p++ = c;

	return v;
  801ab7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

00801abc <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
  801abf:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801ac2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  801acb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801ace:	eb 16                	jmp    801ae6 <memcpy+0x2a>
		*d++ = *s++;
  801ad0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ad3:	8d 50 01             	lea    0x1(%eax),%edx
  801ad6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801ad9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801adc:	8d 4a 01             	lea    0x1(%edx),%ecx
  801adf:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801ae2:	8a 12                	mov    (%edx),%dl
  801ae4:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801ae6:	8b 45 10             	mov    0x10(%ebp),%eax
  801ae9:	8d 50 ff             	lea    -0x1(%eax),%edx
  801aec:	89 55 10             	mov    %edx,0x10(%ebp)
  801aef:	85 c0                	test   %eax,%eax
  801af1:	75 dd                	jne    801ad0 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801af3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801af6:	c9                   	leave  
  801af7:	c3                   	ret    

00801af8 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
  801afb:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801afe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b01:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801b04:	8b 45 08             	mov    0x8(%ebp),%eax
  801b07:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801b0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b0d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801b10:	73 50                	jae    801b62 <memmove+0x6a>
  801b12:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b15:	8b 45 10             	mov    0x10(%ebp),%eax
  801b18:	01 d0                	add    %edx,%eax
  801b1a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801b1d:	76 43                	jbe    801b62 <memmove+0x6a>
		s += n;
  801b1f:	8b 45 10             	mov    0x10(%ebp),%eax
  801b22:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801b25:	8b 45 10             	mov    0x10(%ebp),%eax
  801b28:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801b2b:	eb 10                	jmp    801b3d <memmove+0x45>
			*--d = *--s;
  801b2d:	ff 4d f8             	decl   -0x8(%ebp)
  801b30:	ff 4d fc             	decl   -0x4(%ebp)
  801b33:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b36:	8a 10                	mov    (%eax),%dl
  801b38:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b3b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801b3d:	8b 45 10             	mov    0x10(%ebp),%eax
  801b40:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b43:	89 55 10             	mov    %edx,0x10(%ebp)
  801b46:	85 c0                	test   %eax,%eax
  801b48:	75 e3                	jne    801b2d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801b4a:	eb 23                	jmp    801b6f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801b4c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b4f:	8d 50 01             	lea    0x1(%eax),%edx
  801b52:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b55:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b58:	8d 4a 01             	lea    0x1(%edx),%ecx
  801b5b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801b5e:	8a 12                	mov    (%edx),%dl
  801b60:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801b62:	8b 45 10             	mov    0x10(%ebp),%eax
  801b65:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b68:	89 55 10             	mov    %edx,0x10(%ebp)
  801b6b:	85 c0                	test   %eax,%eax
  801b6d:	75 dd                	jne    801b4c <memmove+0x54>
			*d++ = *s++;

	return dst;
  801b6f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801b72:	c9                   	leave  
  801b73:	c3                   	ret    

00801b74 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801b74:	55                   	push   %ebp
  801b75:	89 e5                	mov    %esp,%ebp
  801b77:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801b80:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b83:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801b86:	eb 2a                	jmp    801bb2 <memcmp+0x3e>
		if (*s1 != *s2)
  801b88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b8b:	8a 10                	mov    (%eax),%dl
  801b8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b90:	8a 00                	mov    (%eax),%al
  801b92:	38 c2                	cmp    %al,%dl
  801b94:	74 16                	je     801bac <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801b96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b99:	8a 00                	mov    (%eax),%al
  801b9b:	0f b6 d0             	movzbl %al,%edx
  801b9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ba1:	8a 00                	mov    (%eax),%al
  801ba3:	0f b6 c0             	movzbl %al,%eax
  801ba6:	29 c2                	sub    %eax,%edx
  801ba8:	89 d0                	mov    %edx,%eax
  801baa:	eb 18                	jmp    801bc4 <memcmp+0x50>
		s1++, s2++;
  801bac:	ff 45 fc             	incl   -0x4(%ebp)
  801baf:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801bb2:	8b 45 10             	mov    0x10(%ebp),%eax
  801bb5:	8d 50 ff             	lea    -0x1(%eax),%edx
  801bb8:	89 55 10             	mov    %edx,0x10(%ebp)
  801bbb:	85 c0                	test   %eax,%eax
  801bbd:	75 c9                	jne    801b88 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801bbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bc4:	c9                   	leave  
  801bc5:	c3                   	ret    

00801bc6 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801bc6:	55                   	push   %ebp
  801bc7:	89 e5                	mov    %esp,%ebp
  801bc9:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801bcc:	8b 55 08             	mov    0x8(%ebp),%edx
  801bcf:	8b 45 10             	mov    0x10(%ebp),%eax
  801bd2:	01 d0                	add    %edx,%eax
  801bd4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801bd7:	eb 15                	jmp    801bee <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdc:	8a 00                	mov    (%eax),%al
  801bde:	0f b6 d0             	movzbl %al,%edx
  801be1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be4:	0f b6 c0             	movzbl %al,%eax
  801be7:	39 c2                	cmp    %eax,%edx
  801be9:	74 0d                	je     801bf8 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801beb:	ff 45 08             	incl   0x8(%ebp)
  801bee:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801bf4:	72 e3                	jb     801bd9 <memfind+0x13>
  801bf6:	eb 01                	jmp    801bf9 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801bf8:	90                   	nop
	return (void *) s;
  801bf9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
  801c01:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801c04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801c0b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c12:	eb 03                	jmp    801c17 <strtol+0x19>
		s++;
  801c14:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c17:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1a:	8a 00                	mov    (%eax),%al
  801c1c:	3c 20                	cmp    $0x20,%al
  801c1e:	74 f4                	je     801c14 <strtol+0x16>
  801c20:	8b 45 08             	mov    0x8(%ebp),%eax
  801c23:	8a 00                	mov    (%eax),%al
  801c25:	3c 09                	cmp    $0x9,%al
  801c27:	74 eb                	je     801c14 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801c29:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2c:	8a 00                	mov    (%eax),%al
  801c2e:	3c 2b                	cmp    $0x2b,%al
  801c30:	75 05                	jne    801c37 <strtol+0x39>
		s++;
  801c32:	ff 45 08             	incl   0x8(%ebp)
  801c35:	eb 13                	jmp    801c4a <strtol+0x4c>
	else if (*s == '-')
  801c37:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3a:	8a 00                	mov    (%eax),%al
  801c3c:	3c 2d                	cmp    $0x2d,%al
  801c3e:	75 0a                	jne    801c4a <strtol+0x4c>
		s++, neg = 1;
  801c40:	ff 45 08             	incl   0x8(%ebp)
  801c43:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801c4a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c4e:	74 06                	je     801c56 <strtol+0x58>
  801c50:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801c54:	75 20                	jne    801c76 <strtol+0x78>
  801c56:	8b 45 08             	mov    0x8(%ebp),%eax
  801c59:	8a 00                	mov    (%eax),%al
  801c5b:	3c 30                	cmp    $0x30,%al
  801c5d:	75 17                	jne    801c76 <strtol+0x78>
  801c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c62:	40                   	inc    %eax
  801c63:	8a 00                	mov    (%eax),%al
  801c65:	3c 78                	cmp    $0x78,%al
  801c67:	75 0d                	jne    801c76 <strtol+0x78>
		s += 2, base = 16;
  801c69:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801c6d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801c74:	eb 28                	jmp    801c9e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801c76:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c7a:	75 15                	jne    801c91 <strtol+0x93>
  801c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7f:	8a 00                	mov    (%eax),%al
  801c81:	3c 30                	cmp    $0x30,%al
  801c83:	75 0c                	jne    801c91 <strtol+0x93>
		s++, base = 8;
  801c85:	ff 45 08             	incl   0x8(%ebp)
  801c88:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801c8f:	eb 0d                	jmp    801c9e <strtol+0xa0>
	else if (base == 0)
  801c91:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c95:	75 07                	jne    801c9e <strtol+0xa0>
		base = 10;
  801c97:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca1:	8a 00                	mov    (%eax),%al
  801ca3:	3c 2f                	cmp    $0x2f,%al
  801ca5:	7e 19                	jle    801cc0 <strtol+0xc2>
  801ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  801caa:	8a 00                	mov    (%eax),%al
  801cac:	3c 39                	cmp    $0x39,%al
  801cae:	7f 10                	jg     801cc0 <strtol+0xc2>
			dig = *s - '0';
  801cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb3:	8a 00                	mov    (%eax),%al
  801cb5:	0f be c0             	movsbl %al,%eax
  801cb8:	83 e8 30             	sub    $0x30,%eax
  801cbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cbe:	eb 42                	jmp    801d02 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc3:	8a 00                	mov    (%eax),%al
  801cc5:	3c 60                	cmp    $0x60,%al
  801cc7:	7e 19                	jle    801ce2 <strtol+0xe4>
  801cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccc:	8a 00                	mov    (%eax),%al
  801cce:	3c 7a                	cmp    $0x7a,%al
  801cd0:	7f 10                	jg     801ce2 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd5:	8a 00                	mov    (%eax),%al
  801cd7:	0f be c0             	movsbl %al,%eax
  801cda:	83 e8 57             	sub    $0x57,%eax
  801cdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ce0:	eb 20                	jmp    801d02 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce5:	8a 00                	mov    (%eax),%al
  801ce7:	3c 40                	cmp    $0x40,%al
  801ce9:	7e 39                	jle    801d24 <strtol+0x126>
  801ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cee:	8a 00                	mov    (%eax),%al
  801cf0:	3c 5a                	cmp    $0x5a,%al
  801cf2:	7f 30                	jg     801d24 <strtol+0x126>
			dig = *s - 'A' + 10;
  801cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf7:	8a 00                	mov    (%eax),%al
  801cf9:	0f be c0             	movsbl %al,%eax
  801cfc:	83 e8 37             	sub    $0x37,%eax
  801cff:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d05:	3b 45 10             	cmp    0x10(%ebp),%eax
  801d08:	7d 19                	jge    801d23 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801d0a:	ff 45 08             	incl   0x8(%ebp)
  801d0d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d10:	0f af 45 10          	imul   0x10(%ebp),%eax
  801d14:	89 c2                	mov    %eax,%edx
  801d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d19:	01 d0                	add    %edx,%eax
  801d1b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801d1e:	e9 7b ff ff ff       	jmp    801c9e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801d23:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801d24:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d28:	74 08                	je     801d32 <strtol+0x134>
		*endptr = (char *) s;
  801d2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d2d:	8b 55 08             	mov    0x8(%ebp),%edx
  801d30:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801d32:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801d36:	74 07                	je     801d3f <strtol+0x141>
  801d38:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d3b:	f7 d8                	neg    %eax
  801d3d:	eb 03                	jmp    801d42 <strtol+0x144>
  801d3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801d42:	c9                   	leave  
  801d43:	c3                   	ret    

00801d44 <ltostr>:

void
ltostr(long value, char *str)
{
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
  801d47:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801d4a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801d51:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801d58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d5c:	79 13                	jns    801d71 <ltostr+0x2d>
	{
		neg = 1;
  801d5e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801d65:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d68:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801d6b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801d6e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801d71:	8b 45 08             	mov    0x8(%ebp),%eax
  801d74:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801d79:	99                   	cltd   
  801d7a:	f7 f9                	idiv   %ecx
  801d7c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801d7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d82:	8d 50 01             	lea    0x1(%eax),%edx
  801d85:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801d88:	89 c2                	mov    %eax,%edx
  801d8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d8d:	01 d0                	add    %edx,%eax
  801d8f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d92:	83 c2 30             	add    $0x30,%edx
  801d95:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801d97:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d9a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801d9f:	f7 e9                	imul   %ecx
  801da1:	c1 fa 02             	sar    $0x2,%edx
  801da4:	89 c8                	mov    %ecx,%eax
  801da6:	c1 f8 1f             	sar    $0x1f,%eax
  801da9:	29 c2                	sub    %eax,%edx
  801dab:	89 d0                	mov    %edx,%eax
  801dad:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801db0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801db3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801db8:	f7 e9                	imul   %ecx
  801dba:	c1 fa 02             	sar    $0x2,%edx
  801dbd:	89 c8                	mov    %ecx,%eax
  801dbf:	c1 f8 1f             	sar    $0x1f,%eax
  801dc2:	29 c2                	sub    %eax,%edx
  801dc4:	89 d0                	mov    %edx,%eax
  801dc6:	c1 e0 02             	shl    $0x2,%eax
  801dc9:	01 d0                	add    %edx,%eax
  801dcb:	01 c0                	add    %eax,%eax
  801dcd:	29 c1                	sub    %eax,%ecx
  801dcf:	89 ca                	mov    %ecx,%edx
  801dd1:	85 d2                	test   %edx,%edx
  801dd3:	75 9c                	jne    801d71 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801dd5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801ddc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ddf:	48                   	dec    %eax
  801de0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801de3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801de7:	74 3d                	je     801e26 <ltostr+0xe2>
		start = 1 ;
  801de9:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801df0:	eb 34                	jmp    801e26 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801df2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801df5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df8:	01 d0                	add    %edx,%eax
  801dfa:	8a 00                	mov    (%eax),%al
  801dfc:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801dff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e02:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e05:	01 c2                	add    %eax,%edx
  801e07:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e0d:	01 c8                	add    %ecx,%eax
  801e0f:	8a 00                	mov    (%eax),%al
  801e11:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801e13:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e16:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e19:	01 c2                	add    %eax,%edx
  801e1b:	8a 45 eb             	mov    -0x15(%ebp),%al
  801e1e:	88 02                	mov    %al,(%edx)
		start++ ;
  801e20:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801e23:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e29:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801e2c:	7c c4                	jl     801df2 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801e2e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801e31:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e34:	01 d0                	add    %edx,%eax
  801e36:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801e39:	90                   	nop
  801e3a:	c9                   	leave  
  801e3b:	c3                   	ret    

00801e3c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801e3c:	55                   	push   %ebp
  801e3d:	89 e5                	mov    %esp,%ebp
  801e3f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801e42:	ff 75 08             	pushl  0x8(%ebp)
  801e45:	e8 54 fa ff ff       	call   80189e <strlen>
  801e4a:	83 c4 04             	add    $0x4,%esp
  801e4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801e50:	ff 75 0c             	pushl  0xc(%ebp)
  801e53:	e8 46 fa ff ff       	call   80189e <strlen>
  801e58:	83 c4 04             	add    $0x4,%esp
  801e5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801e5e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801e65:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801e6c:	eb 17                	jmp    801e85 <strcconcat+0x49>
		final[s] = str1[s] ;
  801e6e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e71:	8b 45 10             	mov    0x10(%ebp),%eax
  801e74:	01 c2                	add    %eax,%edx
  801e76:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801e79:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7c:	01 c8                	add    %ecx,%eax
  801e7e:	8a 00                	mov    (%eax),%al
  801e80:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801e82:	ff 45 fc             	incl   -0x4(%ebp)
  801e85:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e88:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801e8b:	7c e1                	jl     801e6e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801e8d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801e94:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801e9b:	eb 1f                	jmp    801ebc <strcconcat+0x80>
		final[s++] = str2[i] ;
  801e9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ea0:	8d 50 01             	lea    0x1(%eax),%edx
  801ea3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801ea6:	89 c2                	mov    %eax,%edx
  801ea8:	8b 45 10             	mov    0x10(%ebp),%eax
  801eab:	01 c2                	add    %eax,%edx
  801ead:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801eb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eb3:	01 c8                	add    %ecx,%eax
  801eb5:	8a 00                	mov    (%eax),%al
  801eb7:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801eb9:	ff 45 f8             	incl   -0x8(%ebp)
  801ebc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ebf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801ec2:	7c d9                	jl     801e9d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801ec4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ec7:	8b 45 10             	mov    0x10(%ebp),%eax
  801eca:	01 d0                	add    %edx,%eax
  801ecc:	c6 00 00             	movb   $0x0,(%eax)
}
  801ecf:	90                   	nop
  801ed0:	c9                   	leave  
  801ed1:	c3                   	ret    

00801ed2 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801ed2:	55                   	push   %ebp
  801ed3:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801ed5:	8b 45 14             	mov    0x14(%ebp),%eax
  801ed8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801ede:	8b 45 14             	mov    0x14(%ebp),%eax
  801ee1:	8b 00                	mov    (%eax),%eax
  801ee3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801eea:	8b 45 10             	mov    0x10(%ebp),%eax
  801eed:	01 d0                	add    %edx,%eax
  801eef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801ef5:	eb 0c                	jmp    801f03 <strsplit+0x31>
			*string++ = 0;
  801ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  801efa:	8d 50 01             	lea    0x1(%eax),%edx
  801efd:	89 55 08             	mov    %edx,0x8(%ebp)
  801f00:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801f03:	8b 45 08             	mov    0x8(%ebp),%eax
  801f06:	8a 00                	mov    (%eax),%al
  801f08:	84 c0                	test   %al,%al
  801f0a:	74 18                	je     801f24 <strsplit+0x52>
  801f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0f:	8a 00                	mov    (%eax),%al
  801f11:	0f be c0             	movsbl %al,%eax
  801f14:	50                   	push   %eax
  801f15:	ff 75 0c             	pushl  0xc(%ebp)
  801f18:	e8 13 fb ff ff       	call   801a30 <strchr>
  801f1d:	83 c4 08             	add    $0x8,%esp
  801f20:	85 c0                	test   %eax,%eax
  801f22:	75 d3                	jne    801ef7 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801f24:	8b 45 08             	mov    0x8(%ebp),%eax
  801f27:	8a 00                	mov    (%eax),%al
  801f29:	84 c0                	test   %al,%al
  801f2b:	74 5a                	je     801f87 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801f2d:	8b 45 14             	mov    0x14(%ebp),%eax
  801f30:	8b 00                	mov    (%eax),%eax
  801f32:	83 f8 0f             	cmp    $0xf,%eax
  801f35:	75 07                	jne    801f3e <strsplit+0x6c>
		{
			return 0;
  801f37:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3c:	eb 66                	jmp    801fa4 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801f3e:	8b 45 14             	mov    0x14(%ebp),%eax
  801f41:	8b 00                	mov    (%eax),%eax
  801f43:	8d 48 01             	lea    0x1(%eax),%ecx
  801f46:	8b 55 14             	mov    0x14(%ebp),%edx
  801f49:	89 0a                	mov    %ecx,(%edx)
  801f4b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801f52:	8b 45 10             	mov    0x10(%ebp),%eax
  801f55:	01 c2                	add    %eax,%edx
  801f57:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801f5c:	eb 03                	jmp    801f61 <strsplit+0x8f>
			string++;
  801f5e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801f61:	8b 45 08             	mov    0x8(%ebp),%eax
  801f64:	8a 00                	mov    (%eax),%al
  801f66:	84 c0                	test   %al,%al
  801f68:	74 8b                	je     801ef5 <strsplit+0x23>
  801f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6d:	8a 00                	mov    (%eax),%al
  801f6f:	0f be c0             	movsbl %al,%eax
  801f72:	50                   	push   %eax
  801f73:	ff 75 0c             	pushl  0xc(%ebp)
  801f76:	e8 b5 fa ff ff       	call   801a30 <strchr>
  801f7b:	83 c4 08             	add    $0x8,%esp
  801f7e:	85 c0                	test   %eax,%eax
  801f80:	74 dc                	je     801f5e <strsplit+0x8c>
			string++;
	}
  801f82:	e9 6e ff ff ff       	jmp    801ef5 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801f87:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801f88:	8b 45 14             	mov    0x14(%ebp),%eax
  801f8b:	8b 00                	mov    (%eax),%eax
  801f8d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801f94:	8b 45 10             	mov    0x10(%ebp),%eax
  801f97:	01 d0                	add    %edx,%eax
  801f99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801f9f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801fa4:	c9                   	leave  
  801fa5:	c3                   	ret    

00801fa6 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801fa6:	55                   	push   %ebp
  801fa7:	89 e5                	mov    %esp,%ebp
  801fa9:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801fac:	a1 04 50 80 00       	mov    0x805004,%eax
  801fb1:	85 c0                	test   %eax,%eax
  801fb3:	74 1f                	je     801fd4 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801fb5:	e8 1d 00 00 00       	call   801fd7 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801fba:	83 ec 0c             	sub    $0xc,%esp
  801fbd:	68 f0 45 80 00       	push   $0x8045f0
  801fc2:	e8 55 f2 ff ff       	call   80121c <cprintf>
  801fc7:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801fca:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801fd1:	00 00 00 
	}
}
  801fd4:	90                   	nop
  801fd5:	c9                   	leave  
  801fd6:	c3                   	ret    

00801fd7 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801fd7:	55                   	push   %ebp
  801fd8:	89 e5                	mov    %esp,%ebp
  801fda:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  801fdd:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801fe4:	00 00 00 
  801fe7:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801fee:	00 00 00 
  801ff1:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801ff8:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  801ffb:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  802002:	00 00 00 
  802005:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  80200c:	00 00 00 
  80200f:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  802016:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  802019:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  802020:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802023:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802028:	2d 00 10 00 00       	sub    $0x1000,%eax
  80202d:	a3 50 50 80 00       	mov    %eax,0x805050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  802032:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  802039:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  80203c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802043:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802046:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  80204b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80204e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802051:	ba 00 00 00 00       	mov    $0x0,%edx
  802056:	f7 75 f0             	divl   -0x10(%ebp)
  802059:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80205c:	29 d0                	sub    %edx,%eax
  80205e:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  802061:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  802068:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80206b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802070:	2d 00 10 00 00       	sub    $0x1000,%eax
  802075:	83 ec 04             	sub    $0x4,%esp
  802078:	6a 06                	push   $0x6
  80207a:	ff 75 e8             	pushl  -0x18(%ebp)
  80207d:	50                   	push   %eax
  80207e:	e8 d4 05 00 00       	call   802657 <sys_allocate_chunk>
  802083:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  802086:	a1 20 51 80 00       	mov    0x805120,%eax
  80208b:	83 ec 0c             	sub    $0xc,%esp
  80208e:	50                   	push   %eax
  80208f:	e8 49 0c 00 00       	call   802cdd <initialize_MemBlocksList>
  802094:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  802097:	a1 48 51 80 00       	mov    0x805148,%eax
  80209c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  80209f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8020a3:	75 14                	jne    8020b9 <initialize_dyn_block_system+0xe2>
  8020a5:	83 ec 04             	sub    $0x4,%esp
  8020a8:	68 15 46 80 00       	push   $0x804615
  8020ad:	6a 39                	push   $0x39
  8020af:	68 33 46 80 00       	push   $0x804633
  8020b4:	e8 af ee ff ff       	call   800f68 <_panic>
  8020b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020bc:	8b 00                	mov    (%eax),%eax
  8020be:	85 c0                	test   %eax,%eax
  8020c0:	74 10                	je     8020d2 <initialize_dyn_block_system+0xfb>
  8020c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020c5:	8b 00                	mov    (%eax),%eax
  8020c7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020ca:	8b 52 04             	mov    0x4(%edx),%edx
  8020cd:	89 50 04             	mov    %edx,0x4(%eax)
  8020d0:	eb 0b                	jmp    8020dd <initialize_dyn_block_system+0x106>
  8020d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020d5:	8b 40 04             	mov    0x4(%eax),%eax
  8020d8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8020dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020e0:	8b 40 04             	mov    0x4(%eax),%eax
  8020e3:	85 c0                	test   %eax,%eax
  8020e5:	74 0f                	je     8020f6 <initialize_dyn_block_system+0x11f>
  8020e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020ea:	8b 40 04             	mov    0x4(%eax),%eax
  8020ed:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020f0:	8b 12                	mov    (%edx),%edx
  8020f2:	89 10                	mov    %edx,(%eax)
  8020f4:	eb 0a                	jmp    802100 <initialize_dyn_block_system+0x129>
  8020f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020f9:	8b 00                	mov    (%eax),%eax
  8020fb:	a3 48 51 80 00       	mov    %eax,0x805148
  802100:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802103:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802109:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80210c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802113:	a1 54 51 80 00       	mov    0x805154,%eax
  802118:	48                   	dec    %eax
  802119:	a3 54 51 80 00       	mov    %eax,0x805154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  80211e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802121:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  802128:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80212b:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  802132:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802136:	75 14                	jne    80214c <initialize_dyn_block_system+0x175>
  802138:	83 ec 04             	sub    $0x4,%esp
  80213b:	68 40 46 80 00       	push   $0x804640
  802140:	6a 3f                	push   $0x3f
  802142:	68 33 46 80 00       	push   $0x804633
  802147:	e8 1c ee ff ff       	call   800f68 <_panic>
  80214c:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802152:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802155:	89 10                	mov    %edx,(%eax)
  802157:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80215a:	8b 00                	mov    (%eax),%eax
  80215c:	85 c0                	test   %eax,%eax
  80215e:	74 0d                	je     80216d <initialize_dyn_block_system+0x196>
  802160:	a1 38 51 80 00       	mov    0x805138,%eax
  802165:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802168:	89 50 04             	mov    %edx,0x4(%eax)
  80216b:	eb 08                	jmp    802175 <initialize_dyn_block_system+0x19e>
  80216d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802170:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802175:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802178:	a3 38 51 80 00       	mov    %eax,0x805138
  80217d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802180:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802187:	a1 44 51 80 00       	mov    0x805144,%eax
  80218c:	40                   	inc    %eax
  80218d:	a3 44 51 80 00       	mov    %eax,0x805144

}
  802192:	90                   	nop
  802193:	c9                   	leave  
  802194:	c3                   	ret    

00802195 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  802195:	55                   	push   %ebp
  802196:	89 e5                	mov    %esp,%ebp
  802198:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80219b:	e8 06 fe ff ff       	call   801fa6 <InitializeUHeap>
	if (size == 0) return NULL ;
  8021a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021a4:	75 07                	jne    8021ad <malloc+0x18>
  8021a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ab:	eb 7d                	jmp    80222a <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  8021ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8021b4:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8021bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8021be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c1:	01 d0                	add    %edx,%eax
  8021c3:	48                   	dec    %eax
  8021c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8021c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8021cf:	f7 75 f0             	divl   -0x10(%ebp)
  8021d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021d5:	29 d0                	sub    %edx,%eax
  8021d7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  8021da:	e8 46 08 00 00       	call   802a25 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8021df:	83 f8 01             	cmp    $0x1,%eax
  8021e2:	75 07                	jne    8021eb <malloc+0x56>
  8021e4:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  8021eb:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  8021ef:	75 34                	jne    802225 <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  8021f1:	83 ec 0c             	sub    $0xc,%esp
  8021f4:	ff 75 e8             	pushl  -0x18(%ebp)
  8021f7:	e8 73 0e 00 00       	call   80306f <alloc_block_FF>
  8021fc:	83 c4 10             	add    $0x10,%esp
  8021ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  802202:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802206:	74 16                	je     80221e <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  802208:	83 ec 0c             	sub    $0xc,%esp
  80220b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80220e:	e8 ff 0b 00 00       	call   802e12 <insert_sorted_allocList>
  802213:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  802216:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802219:	8b 40 08             	mov    0x8(%eax),%eax
  80221c:	eb 0c                	jmp    80222a <malloc+0x95>
	             }
	             else
	             	return NULL;
  80221e:	b8 00 00 00 00       	mov    $0x0,%eax
  802223:	eb 05                	jmp    80222a <malloc+0x95>
	      	  }
	          else
	               return NULL;
  802225:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  80222a:	c9                   	leave  
  80222b:	c3                   	ret    

0080222c <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80222c:	55                   	push   %ebp
  80222d:	89 e5                	mov    %esp,%ebp
  80222f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  802232:	8b 45 08             	mov    0x8(%ebp),%eax
  802235:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  802238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80223e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802241:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802246:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  802249:	83 ec 08             	sub    $0x8,%esp
  80224c:	ff 75 f4             	pushl  -0xc(%ebp)
  80224f:	68 40 50 80 00       	push   $0x805040
  802254:	e8 61 0b 00 00       	call   802dba <find_block>
  802259:	83 c4 10             	add    $0x10,%esp
  80225c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  80225f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802263:	0f 84 a5 00 00 00    	je     80230e <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  802269:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80226c:	8b 40 0c             	mov    0xc(%eax),%eax
  80226f:	83 ec 08             	sub    $0x8,%esp
  802272:	50                   	push   %eax
  802273:	ff 75 f4             	pushl  -0xc(%ebp)
  802276:	e8 a4 03 00 00       	call   80261f <sys_free_user_mem>
  80227b:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  80227e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802282:	75 17                	jne    80229b <free+0x6f>
  802284:	83 ec 04             	sub    $0x4,%esp
  802287:	68 15 46 80 00       	push   $0x804615
  80228c:	68 87 00 00 00       	push   $0x87
  802291:	68 33 46 80 00       	push   $0x804633
  802296:	e8 cd ec ff ff       	call   800f68 <_panic>
  80229b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80229e:	8b 00                	mov    (%eax),%eax
  8022a0:	85 c0                	test   %eax,%eax
  8022a2:	74 10                	je     8022b4 <free+0x88>
  8022a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022a7:	8b 00                	mov    (%eax),%eax
  8022a9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8022ac:	8b 52 04             	mov    0x4(%edx),%edx
  8022af:	89 50 04             	mov    %edx,0x4(%eax)
  8022b2:	eb 0b                	jmp    8022bf <free+0x93>
  8022b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022b7:	8b 40 04             	mov    0x4(%eax),%eax
  8022ba:	a3 44 50 80 00       	mov    %eax,0x805044
  8022bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022c2:	8b 40 04             	mov    0x4(%eax),%eax
  8022c5:	85 c0                	test   %eax,%eax
  8022c7:	74 0f                	je     8022d8 <free+0xac>
  8022c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022cc:	8b 40 04             	mov    0x4(%eax),%eax
  8022cf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8022d2:	8b 12                	mov    (%edx),%edx
  8022d4:	89 10                	mov    %edx,(%eax)
  8022d6:	eb 0a                	jmp    8022e2 <free+0xb6>
  8022d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022db:	8b 00                	mov    (%eax),%eax
  8022dd:	a3 40 50 80 00       	mov    %eax,0x805040
  8022e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022f5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022fa:	48                   	dec    %eax
  8022fb:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(theBlock);
  802300:	83 ec 0c             	sub    $0xc,%esp
  802303:	ff 75 ec             	pushl  -0x14(%ebp)
  802306:	e8 37 12 00 00       	call   803542 <insert_sorted_with_merge_freeList>
  80230b:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  80230e:	90                   	nop
  80230f:	c9                   	leave  
  802310:	c3                   	ret    

00802311 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802311:	55                   	push   %ebp
  802312:	89 e5                	mov    %esp,%ebp
  802314:	83 ec 38             	sub    $0x38,%esp
  802317:	8b 45 10             	mov    0x10(%ebp),%eax
  80231a:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80231d:	e8 84 fc ff ff       	call   801fa6 <InitializeUHeap>
	if (size == 0) return NULL ;
  802322:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802326:	75 07                	jne    80232f <smalloc+0x1e>
  802328:	b8 00 00 00 00       	mov    $0x0,%eax
  80232d:	eb 7e                	jmp    8023ad <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  80232f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  802336:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80233d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802340:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802343:	01 d0                	add    %edx,%eax
  802345:	48                   	dec    %eax
  802346:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802349:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80234c:	ba 00 00 00 00       	mov    $0x0,%edx
  802351:	f7 75 f0             	divl   -0x10(%ebp)
  802354:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802357:	29 d0                	sub    %edx,%eax
  802359:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  80235c:	e8 c4 06 00 00       	call   802a25 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802361:	83 f8 01             	cmp    $0x1,%eax
  802364:	75 42                	jne    8023a8 <smalloc+0x97>

		  va = malloc(newsize) ;
  802366:	83 ec 0c             	sub    $0xc,%esp
  802369:	ff 75 e8             	pushl  -0x18(%ebp)
  80236c:	e8 24 fe ff ff       	call   802195 <malloc>
  802371:	83 c4 10             	add    $0x10,%esp
  802374:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  802377:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80237b:	74 24                	je     8023a1 <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  80237d:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  802381:	ff 75 e4             	pushl  -0x1c(%ebp)
  802384:	50                   	push   %eax
  802385:	ff 75 e8             	pushl  -0x18(%ebp)
  802388:	ff 75 08             	pushl  0x8(%ebp)
  80238b:	e8 1a 04 00 00       	call   8027aa <sys_createSharedObject>
  802390:	83 c4 10             	add    $0x10,%esp
  802393:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  802396:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80239a:	78 0c                	js     8023a8 <smalloc+0x97>
					  return va ;
  80239c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80239f:	eb 0c                	jmp    8023ad <smalloc+0x9c>
				 }
				 else
					return NULL;
  8023a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8023a6:	eb 05                	jmp    8023ad <smalloc+0x9c>
	  }
		  return NULL ;
  8023a8:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8023ad:	c9                   	leave  
  8023ae:	c3                   	ret    

008023af <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8023af:	55                   	push   %ebp
  8023b0:	89 e5                	mov    %esp,%ebp
  8023b2:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8023b5:	e8 ec fb ff ff       	call   801fa6 <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  8023ba:	83 ec 08             	sub    $0x8,%esp
  8023bd:	ff 75 0c             	pushl  0xc(%ebp)
  8023c0:	ff 75 08             	pushl  0x8(%ebp)
  8023c3:	e8 0c 04 00 00       	call   8027d4 <sys_getSizeOfSharedObject>
  8023c8:	83 c4 10             	add    $0x10,%esp
  8023cb:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  8023ce:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8023d2:	75 07                	jne    8023db <sget+0x2c>
  8023d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d9:	eb 75                	jmp    802450 <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8023db:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8023e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e8:	01 d0                	add    %edx,%eax
  8023ea:	48                   	dec    %eax
  8023eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8023ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8023f6:	f7 75 f0             	divl   -0x10(%ebp)
  8023f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023fc:	29 d0                	sub    %edx,%eax
  8023fe:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  802401:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  802408:	e8 18 06 00 00       	call   802a25 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80240d:	83 f8 01             	cmp    $0x1,%eax
  802410:	75 39                	jne    80244b <sget+0x9c>

		  va = malloc(newsize) ;
  802412:	83 ec 0c             	sub    $0xc,%esp
  802415:	ff 75 e8             	pushl  -0x18(%ebp)
  802418:	e8 78 fd ff ff       	call   802195 <malloc>
  80241d:	83 c4 10             	add    $0x10,%esp
  802420:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  802423:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802427:	74 22                	je     80244b <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  802429:	83 ec 04             	sub    $0x4,%esp
  80242c:	ff 75 e0             	pushl  -0x20(%ebp)
  80242f:	ff 75 0c             	pushl  0xc(%ebp)
  802432:	ff 75 08             	pushl  0x8(%ebp)
  802435:	e8 b7 03 00 00       	call   8027f1 <sys_getSharedObject>
  80243a:	83 c4 10             	add    $0x10,%esp
  80243d:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  802440:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802444:	78 05                	js     80244b <sget+0x9c>
					  return va;
  802446:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802449:	eb 05                	jmp    802450 <sget+0xa1>
				  }
			  }
     }
         return NULL;
  80244b:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  802450:	c9                   	leave  
  802451:	c3                   	ret    

00802452 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802452:	55                   	push   %ebp
  802453:	89 e5                	mov    %esp,%ebp
  802455:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802458:	e8 49 fb ff ff       	call   801fa6 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80245d:	83 ec 04             	sub    $0x4,%esp
  802460:	68 64 46 80 00       	push   $0x804664
  802465:	68 1e 01 00 00       	push   $0x11e
  80246a:	68 33 46 80 00       	push   $0x804633
  80246f:	e8 f4 ea ff ff       	call   800f68 <_panic>

00802474 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802474:	55                   	push   %ebp
  802475:	89 e5                	mov    %esp,%ebp
  802477:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80247a:	83 ec 04             	sub    $0x4,%esp
  80247d:	68 8c 46 80 00       	push   $0x80468c
  802482:	68 32 01 00 00       	push   $0x132
  802487:	68 33 46 80 00       	push   $0x804633
  80248c:	e8 d7 ea ff ff       	call   800f68 <_panic>

00802491 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802491:	55                   	push   %ebp
  802492:	89 e5                	mov    %esp,%ebp
  802494:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802497:	83 ec 04             	sub    $0x4,%esp
  80249a:	68 b0 46 80 00       	push   $0x8046b0
  80249f:	68 3d 01 00 00       	push   $0x13d
  8024a4:	68 33 46 80 00       	push   $0x804633
  8024a9:	e8 ba ea ff ff       	call   800f68 <_panic>

008024ae <shrink>:

}
void shrink(uint32 newSize)
{
  8024ae:	55                   	push   %ebp
  8024af:	89 e5                	mov    %esp,%ebp
  8024b1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8024b4:	83 ec 04             	sub    $0x4,%esp
  8024b7:	68 b0 46 80 00       	push   $0x8046b0
  8024bc:	68 42 01 00 00       	push   $0x142
  8024c1:	68 33 46 80 00       	push   $0x804633
  8024c6:	e8 9d ea ff ff       	call   800f68 <_panic>

008024cb <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8024cb:	55                   	push   %ebp
  8024cc:	89 e5                	mov    %esp,%ebp
  8024ce:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8024d1:	83 ec 04             	sub    $0x4,%esp
  8024d4:	68 b0 46 80 00       	push   $0x8046b0
  8024d9:	68 47 01 00 00       	push   $0x147
  8024de:	68 33 46 80 00       	push   $0x804633
  8024e3:	e8 80 ea ff ff       	call   800f68 <_panic>

008024e8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8024e8:	55                   	push   %ebp
  8024e9:	89 e5                	mov    %esp,%ebp
  8024eb:	57                   	push   %edi
  8024ec:	56                   	push   %esi
  8024ed:	53                   	push   %ebx
  8024ee:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8024f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024fa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024fd:	8b 7d 18             	mov    0x18(%ebp),%edi
  802500:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802503:	cd 30                	int    $0x30
  802505:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802508:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80250b:	83 c4 10             	add    $0x10,%esp
  80250e:	5b                   	pop    %ebx
  80250f:	5e                   	pop    %esi
  802510:	5f                   	pop    %edi
  802511:	5d                   	pop    %ebp
  802512:	c3                   	ret    

00802513 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802513:	55                   	push   %ebp
  802514:	89 e5                	mov    %esp,%ebp
  802516:	83 ec 04             	sub    $0x4,%esp
  802519:	8b 45 10             	mov    0x10(%ebp),%eax
  80251c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80251f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802523:	8b 45 08             	mov    0x8(%ebp),%eax
  802526:	6a 00                	push   $0x0
  802528:	6a 00                	push   $0x0
  80252a:	52                   	push   %edx
  80252b:	ff 75 0c             	pushl  0xc(%ebp)
  80252e:	50                   	push   %eax
  80252f:	6a 00                	push   $0x0
  802531:	e8 b2 ff ff ff       	call   8024e8 <syscall>
  802536:	83 c4 18             	add    $0x18,%esp
}
  802539:	90                   	nop
  80253a:	c9                   	leave  
  80253b:	c3                   	ret    

0080253c <sys_cgetc>:

int
sys_cgetc(void)
{
  80253c:	55                   	push   %ebp
  80253d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80253f:	6a 00                	push   $0x0
  802541:	6a 00                	push   $0x0
  802543:	6a 00                	push   $0x0
  802545:	6a 00                	push   $0x0
  802547:	6a 00                	push   $0x0
  802549:	6a 01                	push   $0x1
  80254b:	e8 98 ff ff ff       	call   8024e8 <syscall>
  802550:	83 c4 18             	add    $0x18,%esp
}
  802553:	c9                   	leave  
  802554:	c3                   	ret    

00802555 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802555:	55                   	push   %ebp
  802556:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802558:	8b 55 0c             	mov    0xc(%ebp),%edx
  80255b:	8b 45 08             	mov    0x8(%ebp),%eax
  80255e:	6a 00                	push   $0x0
  802560:	6a 00                	push   $0x0
  802562:	6a 00                	push   $0x0
  802564:	52                   	push   %edx
  802565:	50                   	push   %eax
  802566:	6a 05                	push   $0x5
  802568:	e8 7b ff ff ff       	call   8024e8 <syscall>
  80256d:	83 c4 18             	add    $0x18,%esp
}
  802570:	c9                   	leave  
  802571:	c3                   	ret    

00802572 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802572:	55                   	push   %ebp
  802573:	89 e5                	mov    %esp,%ebp
  802575:	56                   	push   %esi
  802576:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802577:	8b 75 18             	mov    0x18(%ebp),%esi
  80257a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80257d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802580:	8b 55 0c             	mov    0xc(%ebp),%edx
  802583:	8b 45 08             	mov    0x8(%ebp),%eax
  802586:	56                   	push   %esi
  802587:	53                   	push   %ebx
  802588:	51                   	push   %ecx
  802589:	52                   	push   %edx
  80258a:	50                   	push   %eax
  80258b:	6a 06                	push   $0x6
  80258d:	e8 56 ff ff ff       	call   8024e8 <syscall>
  802592:	83 c4 18             	add    $0x18,%esp
}
  802595:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802598:	5b                   	pop    %ebx
  802599:	5e                   	pop    %esi
  80259a:	5d                   	pop    %ebp
  80259b:	c3                   	ret    

0080259c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80259c:	55                   	push   %ebp
  80259d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80259f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a5:	6a 00                	push   $0x0
  8025a7:	6a 00                	push   $0x0
  8025a9:	6a 00                	push   $0x0
  8025ab:	52                   	push   %edx
  8025ac:	50                   	push   %eax
  8025ad:	6a 07                	push   $0x7
  8025af:	e8 34 ff ff ff       	call   8024e8 <syscall>
  8025b4:	83 c4 18             	add    $0x18,%esp
}
  8025b7:	c9                   	leave  
  8025b8:	c3                   	ret    

008025b9 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8025b9:	55                   	push   %ebp
  8025ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8025bc:	6a 00                	push   $0x0
  8025be:	6a 00                	push   $0x0
  8025c0:	6a 00                	push   $0x0
  8025c2:	ff 75 0c             	pushl  0xc(%ebp)
  8025c5:	ff 75 08             	pushl  0x8(%ebp)
  8025c8:	6a 08                	push   $0x8
  8025ca:	e8 19 ff ff ff       	call   8024e8 <syscall>
  8025cf:	83 c4 18             	add    $0x18,%esp
}
  8025d2:	c9                   	leave  
  8025d3:	c3                   	ret    

008025d4 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8025d4:	55                   	push   %ebp
  8025d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8025d7:	6a 00                	push   $0x0
  8025d9:	6a 00                	push   $0x0
  8025db:	6a 00                	push   $0x0
  8025dd:	6a 00                	push   $0x0
  8025df:	6a 00                	push   $0x0
  8025e1:	6a 09                	push   $0x9
  8025e3:	e8 00 ff ff ff       	call   8024e8 <syscall>
  8025e8:	83 c4 18             	add    $0x18,%esp
}
  8025eb:	c9                   	leave  
  8025ec:	c3                   	ret    

008025ed <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8025ed:	55                   	push   %ebp
  8025ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8025f0:	6a 00                	push   $0x0
  8025f2:	6a 00                	push   $0x0
  8025f4:	6a 00                	push   $0x0
  8025f6:	6a 00                	push   $0x0
  8025f8:	6a 00                	push   $0x0
  8025fa:	6a 0a                	push   $0xa
  8025fc:	e8 e7 fe ff ff       	call   8024e8 <syscall>
  802601:	83 c4 18             	add    $0x18,%esp
}
  802604:	c9                   	leave  
  802605:	c3                   	ret    

00802606 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802606:	55                   	push   %ebp
  802607:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802609:	6a 00                	push   $0x0
  80260b:	6a 00                	push   $0x0
  80260d:	6a 00                	push   $0x0
  80260f:	6a 00                	push   $0x0
  802611:	6a 00                	push   $0x0
  802613:	6a 0b                	push   $0xb
  802615:	e8 ce fe ff ff       	call   8024e8 <syscall>
  80261a:	83 c4 18             	add    $0x18,%esp
}
  80261d:	c9                   	leave  
  80261e:	c3                   	ret    

0080261f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80261f:	55                   	push   %ebp
  802620:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802622:	6a 00                	push   $0x0
  802624:	6a 00                	push   $0x0
  802626:	6a 00                	push   $0x0
  802628:	ff 75 0c             	pushl  0xc(%ebp)
  80262b:	ff 75 08             	pushl  0x8(%ebp)
  80262e:	6a 0f                	push   $0xf
  802630:	e8 b3 fe ff ff       	call   8024e8 <syscall>
  802635:	83 c4 18             	add    $0x18,%esp
	return;
  802638:	90                   	nop
}
  802639:	c9                   	leave  
  80263a:	c3                   	ret    

0080263b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80263b:	55                   	push   %ebp
  80263c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80263e:	6a 00                	push   $0x0
  802640:	6a 00                	push   $0x0
  802642:	6a 00                	push   $0x0
  802644:	ff 75 0c             	pushl  0xc(%ebp)
  802647:	ff 75 08             	pushl  0x8(%ebp)
  80264a:	6a 10                	push   $0x10
  80264c:	e8 97 fe ff ff       	call   8024e8 <syscall>
  802651:	83 c4 18             	add    $0x18,%esp
	return ;
  802654:	90                   	nop
}
  802655:	c9                   	leave  
  802656:	c3                   	ret    

00802657 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802657:	55                   	push   %ebp
  802658:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80265a:	6a 00                	push   $0x0
  80265c:	6a 00                	push   $0x0
  80265e:	ff 75 10             	pushl  0x10(%ebp)
  802661:	ff 75 0c             	pushl  0xc(%ebp)
  802664:	ff 75 08             	pushl  0x8(%ebp)
  802667:	6a 11                	push   $0x11
  802669:	e8 7a fe ff ff       	call   8024e8 <syscall>
  80266e:	83 c4 18             	add    $0x18,%esp
	return ;
  802671:	90                   	nop
}
  802672:	c9                   	leave  
  802673:	c3                   	ret    

00802674 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802674:	55                   	push   %ebp
  802675:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802677:	6a 00                	push   $0x0
  802679:	6a 00                	push   $0x0
  80267b:	6a 00                	push   $0x0
  80267d:	6a 00                	push   $0x0
  80267f:	6a 00                	push   $0x0
  802681:	6a 0c                	push   $0xc
  802683:	e8 60 fe ff ff       	call   8024e8 <syscall>
  802688:	83 c4 18             	add    $0x18,%esp
}
  80268b:	c9                   	leave  
  80268c:	c3                   	ret    

0080268d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80268d:	55                   	push   %ebp
  80268e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802690:	6a 00                	push   $0x0
  802692:	6a 00                	push   $0x0
  802694:	6a 00                	push   $0x0
  802696:	6a 00                	push   $0x0
  802698:	ff 75 08             	pushl  0x8(%ebp)
  80269b:	6a 0d                	push   $0xd
  80269d:	e8 46 fe ff ff       	call   8024e8 <syscall>
  8026a2:	83 c4 18             	add    $0x18,%esp
}
  8026a5:	c9                   	leave  
  8026a6:	c3                   	ret    

008026a7 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8026a7:	55                   	push   %ebp
  8026a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8026aa:	6a 00                	push   $0x0
  8026ac:	6a 00                	push   $0x0
  8026ae:	6a 00                	push   $0x0
  8026b0:	6a 00                	push   $0x0
  8026b2:	6a 00                	push   $0x0
  8026b4:	6a 0e                	push   $0xe
  8026b6:	e8 2d fe ff ff       	call   8024e8 <syscall>
  8026bb:	83 c4 18             	add    $0x18,%esp
}
  8026be:	90                   	nop
  8026bf:	c9                   	leave  
  8026c0:	c3                   	ret    

008026c1 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8026c1:	55                   	push   %ebp
  8026c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8026c4:	6a 00                	push   $0x0
  8026c6:	6a 00                	push   $0x0
  8026c8:	6a 00                	push   $0x0
  8026ca:	6a 00                	push   $0x0
  8026cc:	6a 00                	push   $0x0
  8026ce:	6a 13                	push   $0x13
  8026d0:	e8 13 fe ff ff       	call   8024e8 <syscall>
  8026d5:	83 c4 18             	add    $0x18,%esp
}
  8026d8:	90                   	nop
  8026d9:	c9                   	leave  
  8026da:	c3                   	ret    

008026db <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8026db:	55                   	push   %ebp
  8026dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8026de:	6a 00                	push   $0x0
  8026e0:	6a 00                	push   $0x0
  8026e2:	6a 00                	push   $0x0
  8026e4:	6a 00                	push   $0x0
  8026e6:	6a 00                	push   $0x0
  8026e8:	6a 14                	push   $0x14
  8026ea:	e8 f9 fd ff ff       	call   8024e8 <syscall>
  8026ef:	83 c4 18             	add    $0x18,%esp
}
  8026f2:	90                   	nop
  8026f3:	c9                   	leave  
  8026f4:	c3                   	ret    

008026f5 <sys_cputc>:


void
sys_cputc(const char c)
{
  8026f5:	55                   	push   %ebp
  8026f6:	89 e5                	mov    %esp,%ebp
  8026f8:	83 ec 04             	sub    $0x4,%esp
  8026fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fe:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802701:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802705:	6a 00                	push   $0x0
  802707:	6a 00                	push   $0x0
  802709:	6a 00                	push   $0x0
  80270b:	6a 00                	push   $0x0
  80270d:	50                   	push   %eax
  80270e:	6a 15                	push   $0x15
  802710:	e8 d3 fd ff ff       	call   8024e8 <syscall>
  802715:	83 c4 18             	add    $0x18,%esp
}
  802718:	90                   	nop
  802719:	c9                   	leave  
  80271a:	c3                   	ret    

0080271b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80271b:	55                   	push   %ebp
  80271c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80271e:	6a 00                	push   $0x0
  802720:	6a 00                	push   $0x0
  802722:	6a 00                	push   $0x0
  802724:	6a 00                	push   $0x0
  802726:	6a 00                	push   $0x0
  802728:	6a 16                	push   $0x16
  80272a:	e8 b9 fd ff ff       	call   8024e8 <syscall>
  80272f:	83 c4 18             	add    $0x18,%esp
}
  802732:	90                   	nop
  802733:	c9                   	leave  
  802734:	c3                   	ret    

00802735 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802735:	55                   	push   %ebp
  802736:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802738:	8b 45 08             	mov    0x8(%ebp),%eax
  80273b:	6a 00                	push   $0x0
  80273d:	6a 00                	push   $0x0
  80273f:	6a 00                	push   $0x0
  802741:	ff 75 0c             	pushl  0xc(%ebp)
  802744:	50                   	push   %eax
  802745:	6a 17                	push   $0x17
  802747:	e8 9c fd ff ff       	call   8024e8 <syscall>
  80274c:	83 c4 18             	add    $0x18,%esp
}
  80274f:	c9                   	leave  
  802750:	c3                   	ret    

00802751 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802751:	55                   	push   %ebp
  802752:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802754:	8b 55 0c             	mov    0xc(%ebp),%edx
  802757:	8b 45 08             	mov    0x8(%ebp),%eax
  80275a:	6a 00                	push   $0x0
  80275c:	6a 00                	push   $0x0
  80275e:	6a 00                	push   $0x0
  802760:	52                   	push   %edx
  802761:	50                   	push   %eax
  802762:	6a 1a                	push   $0x1a
  802764:	e8 7f fd ff ff       	call   8024e8 <syscall>
  802769:	83 c4 18             	add    $0x18,%esp
}
  80276c:	c9                   	leave  
  80276d:	c3                   	ret    

0080276e <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80276e:	55                   	push   %ebp
  80276f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802771:	8b 55 0c             	mov    0xc(%ebp),%edx
  802774:	8b 45 08             	mov    0x8(%ebp),%eax
  802777:	6a 00                	push   $0x0
  802779:	6a 00                	push   $0x0
  80277b:	6a 00                	push   $0x0
  80277d:	52                   	push   %edx
  80277e:	50                   	push   %eax
  80277f:	6a 18                	push   $0x18
  802781:	e8 62 fd ff ff       	call   8024e8 <syscall>
  802786:	83 c4 18             	add    $0x18,%esp
}
  802789:	90                   	nop
  80278a:	c9                   	leave  
  80278b:	c3                   	ret    

0080278c <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80278c:	55                   	push   %ebp
  80278d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80278f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802792:	8b 45 08             	mov    0x8(%ebp),%eax
  802795:	6a 00                	push   $0x0
  802797:	6a 00                	push   $0x0
  802799:	6a 00                	push   $0x0
  80279b:	52                   	push   %edx
  80279c:	50                   	push   %eax
  80279d:	6a 19                	push   $0x19
  80279f:	e8 44 fd ff ff       	call   8024e8 <syscall>
  8027a4:	83 c4 18             	add    $0x18,%esp
}
  8027a7:	90                   	nop
  8027a8:	c9                   	leave  
  8027a9:	c3                   	ret    

008027aa <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8027aa:	55                   	push   %ebp
  8027ab:	89 e5                	mov    %esp,%ebp
  8027ad:	83 ec 04             	sub    $0x4,%esp
  8027b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8027b3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8027b6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8027b9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8027bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c0:	6a 00                	push   $0x0
  8027c2:	51                   	push   %ecx
  8027c3:	52                   	push   %edx
  8027c4:	ff 75 0c             	pushl  0xc(%ebp)
  8027c7:	50                   	push   %eax
  8027c8:	6a 1b                	push   $0x1b
  8027ca:	e8 19 fd ff ff       	call   8024e8 <syscall>
  8027cf:	83 c4 18             	add    $0x18,%esp
}
  8027d2:	c9                   	leave  
  8027d3:	c3                   	ret    

008027d4 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8027d4:	55                   	push   %ebp
  8027d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8027d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027da:	8b 45 08             	mov    0x8(%ebp),%eax
  8027dd:	6a 00                	push   $0x0
  8027df:	6a 00                	push   $0x0
  8027e1:	6a 00                	push   $0x0
  8027e3:	52                   	push   %edx
  8027e4:	50                   	push   %eax
  8027e5:	6a 1c                	push   $0x1c
  8027e7:	e8 fc fc ff ff       	call   8024e8 <syscall>
  8027ec:	83 c4 18             	add    $0x18,%esp
}
  8027ef:	c9                   	leave  
  8027f0:	c3                   	ret    

008027f1 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8027f1:	55                   	push   %ebp
  8027f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8027f4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8027f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fd:	6a 00                	push   $0x0
  8027ff:	6a 00                	push   $0x0
  802801:	51                   	push   %ecx
  802802:	52                   	push   %edx
  802803:	50                   	push   %eax
  802804:	6a 1d                	push   $0x1d
  802806:	e8 dd fc ff ff       	call   8024e8 <syscall>
  80280b:	83 c4 18             	add    $0x18,%esp
}
  80280e:	c9                   	leave  
  80280f:	c3                   	ret    

00802810 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802810:	55                   	push   %ebp
  802811:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802813:	8b 55 0c             	mov    0xc(%ebp),%edx
  802816:	8b 45 08             	mov    0x8(%ebp),%eax
  802819:	6a 00                	push   $0x0
  80281b:	6a 00                	push   $0x0
  80281d:	6a 00                	push   $0x0
  80281f:	52                   	push   %edx
  802820:	50                   	push   %eax
  802821:	6a 1e                	push   $0x1e
  802823:	e8 c0 fc ff ff       	call   8024e8 <syscall>
  802828:	83 c4 18             	add    $0x18,%esp
}
  80282b:	c9                   	leave  
  80282c:	c3                   	ret    

0080282d <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80282d:	55                   	push   %ebp
  80282e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802830:	6a 00                	push   $0x0
  802832:	6a 00                	push   $0x0
  802834:	6a 00                	push   $0x0
  802836:	6a 00                	push   $0x0
  802838:	6a 00                	push   $0x0
  80283a:	6a 1f                	push   $0x1f
  80283c:	e8 a7 fc ff ff       	call   8024e8 <syscall>
  802841:	83 c4 18             	add    $0x18,%esp
}
  802844:	c9                   	leave  
  802845:	c3                   	ret    

00802846 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802846:	55                   	push   %ebp
  802847:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802849:	8b 45 08             	mov    0x8(%ebp),%eax
  80284c:	6a 00                	push   $0x0
  80284e:	ff 75 14             	pushl  0x14(%ebp)
  802851:	ff 75 10             	pushl  0x10(%ebp)
  802854:	ff 75 0c             	pushl  0xc(%ebp)
  802857:	50                   	push   %eax
  802858:	6a 20                	push   $0x20
  80285a:	e8 89 fc ff ff       	call   8024e8 <syscall>
  80285f:	83 c4 18             	add    $0x18,%esp
}
  802862:	c9                   	leave  
  802863:	c3                   	ret    

00802864 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802864:	55                   	push   %ebp
  802865:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802867:	8b 45 08             	mov    0x8(%ebp),%eax
  80286a:	6a 00                	push   $0x0
  80286c:	6a 00                	push   $0x0
  80286e:	6a 00                	push   $0x0
  802870:	6a 00                	push   $0x0
  802872:	50                   	push   %eax
  802873:	6a 21                	push   $0x21
  802875:	e8 6e fc ff ff       	call   8024e8 <syscall>
  80287a:	83 c4 18             	add    $0x18,%esp
}
  80287d:	90                   	nop
  80287e:	c9                   	leave  
  80287f:	c3                   	ret    

00802880 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802880:	55                   	push   %ebp
  802881:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802883:	8b 45 08             	mov    0x8(%ebp),%eax
  802886:	6a 00                	push   $0x0
  802888:	6a 00                	push   $0x0
  80288a:	6a 00                	push   $0x0
  80288c:	6a 00                	push   $0x0
  80288e:	50                   	push   %eax
  80288f:	6a 22                	push   $0x22
  802891:	e8 52 fc ff ff       	call   8024e8 <syscall>
  802896:	83 c4 18             	add    $0x18,%esp
}
  802899:	c9                   	leave  
  80289a:	c3                   	ret    

0080289b <sys_getenvid>:

int32 sys_getenvid(void)
{
  80289b:	55                   	push   %ebp
  80289c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80289e:	6a 00                	push   $0x0
  8028a0:	6a 00                	push   $0x0
  8028a2:	6a 00                	push   $0x0
  8028a4:	6a 00                	push   $0x0
  8028a6:	6a 00                	push   $0x0
  8028a8:	6a 02                	push   $0x2
  8028aa:	e8 39 fc ff ff       	call   8024e8 <syscall>
  8028af:	83 c4 18             	add    $0x18,%esp
}
  8028b2:	c9                   	leave  
  8028b3:	c3                   	ret    

008028b4 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8028b4:	55                   	push   %ebp
  8028b5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8028b7:	6a 00                	push   $0x0
  8028b9:	6a 00                	push   $0x0
  8028bb:	6a 00                	push   $0x0
  8028bd:	6a 00                	push   $0x0
  8028bf:	6a 00                	push   $0x0
  8028c1:	6a 03                	push   $0x3
  8028c3:	e8 20 fc ff ff       	call   8024e8 <syscall>
  8028c8:	83 c4 18             	add    $0x18,%esp
}
  8028cb:	c9                   	leave  
  8028cc:	c3                   	ret    

008028cd <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8028cd:	55                   	push   %ebp
  8028ce:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8028d0:	6a 00                	push   $0x0
  8028d2:	6a 00                	push   $0x0
  8028d4:	6a 00                	push   $0x0
  8028d6:	6a 00                	push   $0x0
  8028d8:	6a 00                	push   $0x0
  8028da:	6a 04                	push   $0x4
  8028dc:	e8 07 fc ff ff       	call   8024e8 <syscall>
  8028e1:	83 c4 18             	add    $0x18,%esp
}
  8028e4:	c9                   	leave  
  8028e5:	c3                   	ret    

008028e6 <sys_exit_env>:


void sys_exit_env(void)
{
  8028e6:	55                   	push   %ebp
  8028e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8028e9:	6a 00                	push   $0x0
  8028eb:	6a 00                	push   $0x0
  8028ed:	6a 00                	push   $0x0
  8028ef:	6a 00                	push   $0x0
  8028f1:	6a 00                	push   $0x0
  8028f3:	6a 23                	push   $0x23
  8028f5:	e8 ee fb ff ff       	call   8024e8 <syscall>
  8028fa:	83 c4 18             	add    $0x18,%esp
}
  8028fd:	90                   	nop
  8028fe:	c9                   	leave  
  8028ff:	c3                   	ret    

00802900 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802900:	55                   	push   %ebp
  802901:	89 e5                	mov    %esp,%ebp
  802903:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802906:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802909:	8d 50 04             	lea    0x4(%eax),%edx
  80290c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80290f:	6a 00                	push   $0x0
  802911:	6a 00                	push   $0x0
  802913:	6a 00                	push   $0x0
  802915:	52                   	push   %edx
  802916:	50                   	push   %eax
  802917:	6a 24                	push   $0x24
  802919:	e8 ca fb ff ff       	call   8024e8 <syscall>
  80291e:	83 c4 18             	add    $0x18,%esp
	return result;
  802921:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802924:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802927:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80292a:	89 01                	mov    %eax,(%ecx)
  80292c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80292f:	8b 45 08             	mov    0x8(%ebp),%eax
  802932:	c9                   	leave  
  802933:	c2 04 00             	ret    $0x4

00802936 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802936:	55                   	push   %ebp
  802937:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802939:	6a 00                	push   $0x0
  80293b:	6a 00                	push   $0x0
  80293d:	ff 75 10             	pushl  0x10(%ebp)
  802940:	ff 75 0c             	pushl  0xc(%ebp)
  802943:	ff 75 08             	pushl  0x8(%ebp)
  802946:	6a 12                	push   $0x12
  802948:	e8 9b fb ff ff       	call   8024e8 <syscall>
  80294d:	83 c4 18             	add    $0x18,%esp
	return ;
  802950:	90                   	nop
}
  802951:	c9                   	leave  
  802952:	c3                   	ret    

00802953 <sys_rcr2>:
uint32 sys_rcr2()
{
  802953:	55                   	push   %ebp
  802954:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802956:	6a 00                	push   $0x0
  802958:	6a 00                	push   $0x0
  80295a:	6a 00                	push   $0x0
  80295c:	6a 00                	push   $0x0
  80295e:	6a 00                	push   $0x0
  802960:	6a 25                	push   $0x25
  802962:	e8 81 fb ff ff       	call   8024e8 <syscall>
  802967:	83 c4 18             	add    $0x18,%esp
}
  80296a:	c9                   	leave  
  80296b:	c3                   	ret    

0080296c <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80296c:	55                   	push   %ebp
  80296d:	89 e5                	mov    %esp,%ebp
  80296f:	83 ec 04             	sub    $0x4,%esp
  802972:	8b 45 08             	mov    0x8(%ebp),%eax
  802975:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802978:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80297c:	6a 00                	push   $0x0
  80297e:	6a 00                	push   $0x0
  802980:	6a 00                	push   $0x0
  802982:	6a 00                	push   $0x0
  802984:	50                   	push   %eax
  802985:	6a 26                	push   $0x26
  802987:	e8 5c fb ff ff       	call   8024e8 <syscall>
  80298c:	83 c4 18             	add    $0x18,%esp
	return ;
  80298f:	90                   	nop
}
  802990:	c9                   	leave  
  802991:	c3                   	ret    

00802992 <rsttst>:
void rsttst()
{
  802992:	55                   	push   %ebp
  802993:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802995:	6a 00                	push   $0x0
  802997:	6a 00                	push   $0x0
  802999:	6a 00                	push   $0x0
  80299b:	6a 00                	push   $0x0
  80299d:	6a 00                	push   $0x0
  80299f:	6a 28                	push   $0x28
  8029a1:	e8 42 fb ff ff       	call   8024e8 <syscall>
  8029a6:	83 c4 18             	add    $0x18,%esp
	return ;
  8029a9:	90                   	nop
}
  8029aa:	c9                   	leave  
  8029ab:	c3                   	ret    

008029ac <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8029ac:	55                   	push   %ebp
  8029ad:	89 e5                	mov    %esp,%ebp
  8029af:	83 ec 04             	sub    $0x4,%esp
  8029b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8029b5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8029b8:	8b 55 18             	mov    0x18(%ebp),%edx
  8029bb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8029bf:	52                   	push   %edx
  8029c0:	50                   	push   %eax
  8029c1:	ff 75 10             	pushl  0x10(%ebp)
  8029c4:	ff 75 0c             	pushl  0xc(%ebp)
  8029c7:	ff 75 08             	pushl  0x8(%ebp)
  8029ca:	6a 27                	push   $0x27
  8029cc:	e8 17 fb ff ff       	call   8024e8 <syscall>
  8029d1:	83 c4 18             	add    $0x18,%esp
	return ;
  8029d4:	90                   	nop
}
  8029d5:	c9                   	leave  
  8029d6:	c3                   	ret    

008029d7 <chktst>:
void chktst(uint32 n)
{
  8029d7:	55                   	push   %ebp
  8029d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8029da:	6a 00                	push   $0x0
  8029dc:	6a 00                	push   $0x0
  8029de:	6a 00                	push   $0x0
  8029e0:	6a 00                	push   $0x0
  8029e2:	ff 75 08             	pushl  0x8(%ebp)
  8029e5:	6a 29                	push   $0x29
  8029e7:	e8 fc fa ff ff       	call   8024e8 <syscall>
  8029ec:	83 c4 18             	add    $0x18,%esp
	return ;
  8029ef:	90                   	nop
}
  8029f0:	c9                   	leave  
  8029f1:	c3                   	ret    

008029f2 <inctst>:

void inctst()
{
  8029f2:	55                   	push   %ebp
  8029f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8029f5:	6a 00                	push   $0x0
  8029f7:	6a 00                	push   $0x0
  8029f9:	6a 00                	push   $0x0
  8029fb:	6a 00                	push   $0x0
  8029fd:	6a 00                	push   $0x0
  8029ff:	6a 2a                	push   $0x2a
  802a01:	e8 e2 fa ff ff       	call   8024e8 <syscall>
  802a06:	83 c4 18             	add    $0x18,%esp
	return ;
  802a09:	90                   	nop
}
  802a0a:	c9                   	leave  
  802a0b:	c3                   	ret    

00802a0c <gettst>:
uint32 gettst()
{
  802a0c:	55                   	push   %ebp
  802a0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802a0f:	6a 00                	push   $0x0
  802a11:	6a 00                	push   $0x0
  802a13:	6a 00                	push   $0x0
  802a15:	6a 00                	push   $0x0
  802a17:	6a 00                	push   $0x0
  802a19:	6a 2b                	push   $0x2b
  802a1b:	e8 c8 fa ff ff       	call   8024e8 <syscall>
  802a20:	83 c4 18             	add    $0x18,%esp
}
  802a23:	c9                   	leave  
  802a24:	c3                   	ret    

00802a25 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802a25:	55                   	push   %ebp
  802a26:	89 e5                	mov    %esp,%ebp
  802a28:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802a2b:	6a 00                	push   $0x0
  802a2d:	6a 00                	push   $0x0
  802a2f:	6a 00                	push   $0x0
  802a31:	6a 00                	push   $0x0
  802a33:	6a 00                	push   $0x0
  802a35:	6a 2c                	push   $0x2c
  802a37:	e8 ac fa ff ff       	call   8024e8 <syscall>
  802a3c:	83 c4 18             	add    $0x18,%esp
  802a3f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802a42:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802a46:	75 07                	jne    802a4f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802a48:	b8 01 00 00 00       	mov    $0x1,%eax
  802a4d:	eb 05                	jmp    802a54 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802a4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a54:	c9                   	leave  
  802a55:	c3                   	ret    

00802a56 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802a56:	55                   	push   %ebp
  802a57:	89 e5                	mov    %esp,%ebp
  802a59:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802a5c:	6a 00                	push   $0x0
  802a5e:	6a 00                	push   $0x0
  802a60:	6a 00                	push   $0x0
  802a62:	6a 00                	push   $0x0
  802a64:	6a 00                	push   $0x0
  802a66:	6a 2c                	push   $0x2c
  802a68:	e8 7b fa ff ff       	call   8024e8 <syscall>
  802a6d:	83 c4 18             	add    $0x18,%esp
  802a70:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802a73:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802a77:	75 07                	jne    802a80 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802a79:	b8 01 00 00 00       	mov    $0x1,%eax
  802a7e:	eb 05                	jmp    802a85 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802a80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a85:	c9                   	leave  
  802a86:	c3                   	ret    

00802a87 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802a87:	55                   	push   %ebp
  802a88:	89 e5                	mov    %esp,%ebp
  802a8a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802a8d:	6a 00                	push   $0x0
  802a8f:	6a 00                	push   $0x0
  802a91:	6a 00                	push   $0x0
  802a93:	6a 00                	push   $0x0
  802a95:	6a 00                	push   $0x0
  802a97:	6a 2c                	push   $0x2c
  802a99:	e8 4a fa ff ff       	call   8024e8 <syscall>
  802a9e:	83 c4 18             	add    $0x18,%esp
  802aa1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802aa4:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802aa8:	75 07                	jne    802ab1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802aaa:	b8 01 00 00 00       	mov    $0x1,%eax
  802aaf:	eb 05                	jmp    802ab6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802ab1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ab6:	c9                   	leave  
  802ab7:	c3                   	ret    

00802ab8 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802ab8:	55                   	push   %ebp
  802ab9:	89 e5                	mov    %esp,%ebp
  802abb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802abe:	6a 00                	push   $0x0
  802ac0:	6a 00                	push   $0x0
  802ac2:	6a 00                	push   $0x0
  802ac4:	6a 00                	push   $0x0
  802ac6:	6a 00                	push   $0x0
  802ac8:	6a 2c                	push   $0x2c
  802aca:	e8 19 fa ff ff       	call   8024e8 <syscall>
  802acf:	83 c4 18             	add    $0x18,%esp
  802ad2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802ad5:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802ad9:	75 07                	jne    802ae2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802adb:	b8 01 00 00 00       	mov    $0x1,%eax
  802ae0:	eb 05                	jmp    802ae7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802ae2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ae7:	c9                   	leave  
  802ae8:	c3                   	ret    

00802ae9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802ae9:	55                   	push   %ebp
  802aea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802aec:	6a 00                	push   $0x0
  802aee:	6a 00                	push   $0x0
  802af0:	6a 00                	push   $0x0
  802af2:	6a 00                	push   $0x0
  802af4:	ff 75 08             	pushl  0x8(%ebp)
  802af7:	6a 2d                	push   $0x2d
  802af9:	e8 ea f9 ff ff       	call   8024e8 <syscall>
  802afe:	83 c4 18             	add    $0x18,%esp
	return ;
  802b01:	90                   	nop
}
  802b02:	c9                   	leave  
  802b03:	c3                   	ret    

00802b04 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802b04:	55                   	push   %ebp
  802b05:	89 e5                	mov    %esp,%ebp
  802b07:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802b08:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802b0b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802b0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b11:	8b 45 08             	mov    0x8(%ebp),%eax
  802b14:	6a 00                	push   $0x0
  802b16:	53                   	push   %ebx
  802b17:	51                   	push   %ecx
  802b18:	52                   	push   %edx
  802b19:	50                   	push   %eax
  802b1a:	6a 2e                	push   $0x2e
  802b1c:	e8 c7 f9 ff ff       	call   8024e8 <syscall>
  802b21:	83 c4 18             	add    $0x18,%esp
}
  802b24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802b27:	c9                   	leave  
  802b28:	c3                   	ret    

00802b29 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802b29:	55                   	push   %ebp
  802b2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802b2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b32:	6a 00                	push   $0x0
  802b34:	6a 00                	push   $0x0
  802b36:	6a 00                	push   $0x0
  802b38:	52                   	push   %edx
  802b39:	50                   	push   %eax
  802b3a:	6a 2f                	push   $0x2f
  802b3c:	e8 a7 f9 ff ff       	call   8024e8 <syscall>
  802b41:	83 c4 18             	add    $0x18,%esp
}
  802b44:	c9                   	leave  
  802b45:	c3                   	ret    

00802b46 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802b46:	55                   	push   %ebp
  802b47:	89 e5                	mov    %esp,%ebp
  802b49:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802b4c:	83 ec 0c             	sub    $0xc,%esp
  802b4f:	68 c0 46 80 00       	push   $0x8046c0
  802b54:	e8 c3 e6 ff ff       	call   80121c <cprintf>
  802b59:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802b5c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802b63:	83 ec 0c             	sub    $0xc,%esp
  802b66:	68 ec 46 80 00       	push   $0x8046ec
  802b6b:	e8 ac e6 ff ff       	call   80121c <cprintf>
  802b70:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802b73:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802b77:	a1 38 51 80 00       	mov    0x805138,%eax
  802b7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b7f:	eb 56                	jmp    802bd7 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802b81:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b85:	74 1c                	je     802ba3 <print_mem_block_lists+0x5d>
  802b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8a:	8b 50 08             	mov    0x8(%eax),%edx
  802b8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b90:	8b 48 08             	mov    0x8(%eax),%ecx
  802b93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b96:	8b 40 0c             	mov    0xc(%eax),%eax
  802b99:	01 c8                	add    %ecx,%eax
  802b9b:	39 c2                	cmp    %eax,%edx
  802b9d:	73 04                	jae    802ba3 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802b9f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba6:	8b 50 08             	mov    0x8(%eax),%edx
  802ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bac:	8b 40 0c             	mov    0xc(%eax),%eax
  802baf:	01 c2                	add    %eax,%edx
  802bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb4:	8b 40 08             	mov    0x8(%eax),%eax
  802bb7:	83 ec 04             	sub    $0x4,%esp
  802bba:	52                   	push   %edx
  802bbb:	50                   	push   %eax
  802bbc:	68 01 47 80 00       	push   $0x804701
  802bc1:	e8 56 e6 ff ff       	call   80121c <cprintf>
  802bc6:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802bcf:	a1 40 51 80 00       	mov    0x805140,%eax
  802bd4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bd7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bdb:	74 07                	je     802be4 <print_mem_block_lists+0x9e>
  802bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be0:	8b 00                	mov    (%eax),%eax
  802be2:	eb 05                	jmp    802be9 <print_mem_block_lists+0xa3>
  802be4:	b8 00 00 00 00       	mov    $0x0,%eax
  802be9:	a3 40 51 80 00       	mov    %eax,0x805140
  802bee:	a1 40 51 80 00       	mov    0x805140,%eax
  802bf3:	85 c0                	test   %eax,%eax
  802bf5:	75 8a                	jne    802b81 <print_mem_block_lists+0x3b>
  802bf7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bfb:	75 84                	jne    802b81 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802bfd:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802c01:	75 10                	jne    802c13 <print_mem_block_lists+0xcd>
  802c03:	83 ec 0c             	sub    $0xc,%esp
  802c06:	68 10 47 80 00       	push   $0x804710
  802c0b:	e8 0c e6 ff ff       	call   80121c <cprintf>
  802c10:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802c13:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802c1a:	83 ec 0c             	sub    $0xc,%esp
  802c1d:	68 34 47 80 00       	push   $0x804734
  802c22:	e8 f5 e5 ff ff       	call   80121c <cprintf>
  802c27:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802c2a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802c2e:	a1 40 50 80 00       	mov    0x805040,%eax
  802c33:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c36:	eb 56                	jmp    802c8e <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802c38:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c3c:	74 1c                	je     802c5a <print_mem_block_lists+0x114>
  802c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c41:	8b 50 08             	mov    0x8(%eax),%edx
  802c44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c47:	8b 48 08             	mov    0x8(%eax),%ecx
  802c4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c4d:	8b 40 0c             	mov    0xc(%eax),%eax
  802c50:	01 c8                	add    %ecx,%eax
  802c52:	39 c2                	cmp    %eax,%edx
  802c54:	73 04                	jae    802c5a <print_mem_block_lists+0x114>
			sorted = 0 ;
  802c56:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802c5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5d:	8b 50 08             	mov    0x8(%eax),%edx
  802c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c63:	8b 40 0c             	mov    0xc(%eax),%eax
  802c66:	01 c2                	add    %eax,%edx
  802c68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6b:	8b 40 08             	mov    0x8(%eax),%eax
  802c6e:	83 ec 04             	sub    $0x4,%esp
  802c71:	52                   	push   %edx
  802c72:	50                   	push   %eax
  802c73:	68 01 47 80 00       	push   $0x804701
  802c78:	e8 9f e5 ff ff       	call   80121c <cprintf>
  802c7d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802c80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c83:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802c86:	a1 48 50 80 00       	mov    0x805048,%eax
  802c8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c92:	74 07                	je     802c9b <print_mem_block_lists+0x155>
  802c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c97:	8b 00                	mov    (%eax),%eax
  802c99:	eb 05                	jmp    802ca0 <print_mem_block_lists+0x15a>
  802c9b:	b8 00 00 00 00       	mov    $0x0,%eax
  802ca0:	a3 48 50 80 00       	mov    %eax,0x805048
  802ca5:	a1 48 50 80 00       	mov    0x805048,%eax
  802caa:	85 c0                	test   %eax,%eax
  802cac:	75 8a                	jne    802c38 <print_mem_block_lists+0xf2>
  802cae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cb2:	75 84                	jne    802c38 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802cb4:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802cb8:	75 10                	jne    802cca <print_mem_block_lists+0x184>
  802cba:	83 ec 0c             	sub    $0xc,%esp
  802cbd:	68 4c 47 80 00       	push   $0x80474c
  802cc2:	e8 55 e5 ff ff       	call   80121c <cprintf>
  802cc7:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802cca:	83 ec 0c             	sub    $0xc,%esp
  802ccd:	68 c0 46 80 00       	push   $0x8046c0
  802cd2:	e8 45 e5 ff ff       	call   80121c <cprintf>
  802cd7:	83 c4 10             	add    $0x10,%esp

}
  802cda:	90                   	nop
  802cdb:	c9                   	leave  
  802cdc:	c3                   	ret    

00802cdd <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802cdd:	55                   	push   %ebp
  802cde:	89 e5                	mov    %esp,%ebp
  802ce0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  802ce3:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802cea:	00 00 00 
  802ced:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802cf4:	00 00 00 
  802cf7:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802cfe:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802d01:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802d08:	e9 9e 00 00 00       	jmp    802dab <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802d0d:	a1 50 50 80 00       	mov    0x805050,%eax
  802d12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d15:	c1 e2 04             	shl    $0x4,%edx
  802d18:	01 d0                	add    %edx,%eax
  802d1a:	85 c0                	test   %eax,%eax
  802d1c:	75 14                	jne    802d32 <initialize_MemBlocksList+0x55>
  802d1e:	83 ec 04             	sub    $0x4,%esp
  802d21:	68 74 47 80 00       	push   $0x804774
  802d26:	6a 47                	push   $0x47
  802d28:	68 97 47 80 00       	push   $0x804797
  802d2d:	e8 36 e2 ff ff       	call   800f68 <_panic>
  802d32:	a1 50 50 80 00       	mov    0x805050,%eax
  802d37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d3a:	c1 e2 04             	shl    $0x4,%edx
  802d3d:	01 d0                	add    %edx,%eax
  802d3f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802d45:	89 10                	mov    %edx,(%eax)
  802d47:	8b 00                	mov    (%eax),%eax
  802d49:	85 c0                	test   %eax,%eax
  802d4b:	74 18                	je     802d65 <initialize_MemBlocksList+0x88>
  802d4d:	a1 48 51 80 00       	mov    0x805148,%eax
  802d52:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802d58:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802d5b:	c1 e1 04             	shl    $0x4,%ecx
  802d5e:	01 ca                	add    %ecx,%edx
  802d60:	89 50 04             	mov    %edx,0x4(%eax)
  802d63:	eb 12                	jmp    802d77 <initialize_MemBlocksList+0x9a>
  802d65:	a1 50 50 80 00       	mov    0x805050,%eax
  802d6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d6d:	c1 e2 04             	shl    $0x4,%edx
  802d70:	01 d0                	add    %edx,%eax
  802d72:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d77:	a1 50 50 80 00       	mov    0x805050,%eax
  802d7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d7f:	c1 e2 04             	shl    $0x4,%edx
  802d82:	01 d0                	add    %edx,%eax
  802d84:	a3 48 51 80 00       	mov    %eax,0x805148
  802d89:	a1 50 50 80 00       	mov    0x805050,%eax
  802d8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d91:	c1 e2 04             	shl    $0x4,%edx
  802d94:	01 d0                	add    %edx,%eax
  802d96:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d9d:	a1 54 51 80 00       	mov    0x805154,%eax
  802da2:	40                   	inc    %eax
  802da3:	a3 54 51 80 00       	mov    %eax,0x805154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802da8:	ff 45 f4             	incl   -0xc(%ebp)
  802dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dae:	3b 45 08             	cmp    0x8(%ebp),%eax
  802db1:	0f 82 56 ff ff ff    	jb     802d0d <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  802db7:	90                   	nop
  802db8:	c9                   	leave  
  802db9:	c3                   	ret    

00802dba <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802dba:	55                   	push   %ebp
  802dbb:	89 e5                	mov    %esp,%ebp
  802dbd:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc3:	8b 00                	mov    (%eax),%eax
  802dc5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802dc8:	eb 19                	jmp    802de3 <find_block+0x29>
	{
		if(element->sva == va){
  802dca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802dcd:	8b 40 08             	mov    0x8(%eax),%eax
  802dd0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802dd3:	75 05                	jne    802dda <find_block+0x20>
			 		return element;
  802dd5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802dd8:	eb 36                	jmp    802e10 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802dda:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddd:	8b 40 08             	mov    0x8(%eax),%eax
  802de0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802de3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802de7:	74 07                	je     802df0 <find_block+0x36>
  802de9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802dec:	8b 00                	mov    (%eax),%eax
  802dee:	eb 05                	jmp    802df5 <find_block+0x3b>
  802df0:	b8 00 00 00 00       	mov    $0x0,%eax
  802df5:	8b 55 08             	mov    0x8(%ebp),%edx
  802df8:	89 42 08             	mov    %eax,0x8(%edx)
  802dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfe:	8b 40 08             	mov    0x8(%eax),%eax
  802e01:	85 c0                	test   %eax,%eax
  802e03:	75 c5                	jne    802dca <find_block+0x10>
  802e05:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802e09:	75 bf                	jne    802dca <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  802e0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e10:	c9                   	leave  
  802e11:	c3                   	ret    

00802e12 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802e12:	55                   	push   %ebp
  802e13:	89 e5                	mov    %esp,%ebp
  802e15:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  802e18:	a1 44 50 80 00       	mov    0x805044,%eax
  802e1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  802e20:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802e25:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  802e28:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e2c:	74 0a                	je     802e38 <insert_sorted_allocList+0x26>
  802e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e31:	8b 40 08             	mov    0x8(%eax),%eax
  802e34:	85 c0                	test   %eax,%eax
  802e36:	75 65                	jne    802e9d <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802e38:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e3c:	75 14                	jne    802e52 <insert_sorted_allocList+0x40>
  802e3e:	83 ec 04             	sub    $0x4,%esp
  802e41:	68 74 47 80 00       	push   $0x804774
  802e46:	6a 6e                	push   $0x6e
  802e48:	68 97 47 80 00       	push   $0x804797
  802e4d:	e8 16 e1 ff ff       	call   800f68 <_panic>
  802e52:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802e58:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5b:	89 10                	mov    %edx,(%eax)
  802e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e60:	8b 00                	mov    (%eax),%eax
  802e62:	85 c0                	test   %eax,%eax
  802e64:	74 0d                	je     802e73 <insert_sorted_allocList+0x61>
  802e66:	a1 40 50 80 00       	mov    0x805040,%eax
  802e6b:	8b 55 08             	mov    0x8(%ebp),%edx
  802e6e:	89 50 04             	mov    %edx,0x4(%eax)
  802e71:	eb 08                	jmp    802e7b <insert_sorted_allocList+0x69>
  802e73:	8b 45 08             	mov    0x8(%ebp),%eax
  802e76:	a3 44 50 80 00       	mov    %eax,0x805044
  802e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7e:	a3 40 50 80 00       	mov    %eax,0x805040
  802e83:	8b 45 08             	mov    0x8(%ebp),%eax
  802e86:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e8d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802e92:	40                   	inc    %eax
  802e93:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802e98:	e9 cf 01 00 00       	jmp    80306c <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  802e9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea0:	8b 50 08             	mov    0x8(%eax),%edx
  802ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea6:	8b 40 08             	mov    0x8(%eax),%eax
  802ea9:	39 c2                	cmp    %eax,%edx
  802eab:	73 65                	jae    802f12 <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802ead:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eb1:	75 14                	jne    802ec7 <insert_sorted_allocList+0xb5>
  802eb3:	83 ec 04             	sub    $0x4,%esp
  802eb6:	68 b0 47 80 00       	push   $0x8047b0
  802ebb:	6a 72                	push   $0x72
  802ebd:	68 97 47 80 00       	push   $0x804797
  802ec2:	e8 a1 e0 ff ff       	call   800f68 <_panic>
  802ec7:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed0:	89 50 04             	mov    %edx,0x4(%eax)
  802ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed6:	8b 40 04             	mov    0x4(%eax),%eax
  802ed9:	85 c0                	test   %eax,%eax
  802edb:	74 0c                	je     802ee9 <insert_sorted_allocList+0xd7>
  802edd:	a1 44 50 80 00       	mov    0x805044,%eax
  802ee2:	8b 55 08             	mov    0x8(%ebp),%edx
  802ee5:	89 10                	mov    %edx,(%eax)
  802ee7:	eb 08                	jmp    802ef1 <insert_sorted_allocList+0xdf>
  802ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  802eec:	a3 40 50 80 00       	mov    %eax,0x805040
  802ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef4:	a3 44 50 80 00       	mov    %eax,0x805044
  802ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  802efc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f02:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802f07:	40                   	inc    %eax
  802f08:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  802f0d:	e9 5a 01 00 00       	jmp    80306c <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  802f12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f15:	8b 50 08             	mov    0x8(%eax),%edx
  802f18:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1b:	8b 40 08             	mov    0x8(%eax),%eax
  802f1e:	39 c2                	cmp    %eax,%edx
  802f20:	75 70                	jne    802f92 <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  802f22:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f26:	74 06                	je     802f2e <insert_sorted_allocList+0x11c>
  802f28:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f2c:	75 14                	jne    802f42 <insert_sorted_allocList+0x130>
  802f2e:	83 ec 04             	sub    $0x4,%esp
  802f31:	68 d4 47 80 00       	push   $0x8047d4
  802f36:	6a 75                	push   $0x75
  802f38:	68 97 47 80 00       	push   $0x804797
  802f3d:	e8 26 e0 ff ff       	call   800f68 <_panic>
  802f42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f45:	8b 10                	mov    (%eax),%edx
  802f47:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4a:	89 10                	mov    %edx,(%eax)
  802f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4f:	8b 00                	mov    (%eax),%eax
  802f51:	85 c0                	test   %eax,%eax
  802f53:	74 0b                	je     802f60 <insert_sorted_allocList+0x14e>
  802f55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f58:	8b 00                	mov    (%eax),%eax
  802f5a:	8b 55 08             	mov    0x8(%ebp),%edx
  802f5d:	89 50 04             	mov    %edx,0x4(%eax)
  802f60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f63:	8b 55 08             	mov    0x8(%ebp),%edx
  802f66:	89 10                	mov    %edx,(%eax)
  802f68:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f6e:	89 50 04             	mov    %edx,0x4(%eax)
  802f71:	8b 45 08             	mov    0x8(%ebp),%eax
  802f74:	8b 00                	mov    (%eax),%eax
  802f76:	85 c0                	test   %eax,%eax
  802f78:	75 08                	jne    802f82 <insert_sorted_allocList+0x170>
  802f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7d:	a3 44 50 80 00       	mov    %eax,0x805044
  802f82:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802f87:	40                   	inc    %eax
  802f88:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  802f8d:	e9 da 00 00 00       	jmp    80306c <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802f92:	a1 40 50 80 00       	mov    0x805040,%eax
  802f97:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f9a:	e9 9d 00 00 00       	jmp    80303c <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  802f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa2:	8b 00                	mov    (%eax),%eax
  802fa4:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  802fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  802faa:	8b 50 08             	mov    0x8(%eax),%edx
  802fad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb0:	8b 40 08             	mov    0x8(%eax),%eax
  802fb3:	39 c2                	cmp    %eax,%edx
  802fb5:	76 7d                	jbe    803034 <insert_sorted_allocList+0x222>
  802fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fba:	8b 50 08             	mov    0x8(%eax),%edx
  802fbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc0:	8b 40 08             	mov    0x8(%eax),%eax
  802fc3:	39 c2                	cmp    %eax,%edx
  802fc5:	73 6d                	jae    803034 <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802fc7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fcb:	74 06                	je     802fd3 <insert_sorted_allocList+0x1c1>
  802fcd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fd1:	75 14                	jne    802fe7 <insert_sorted_allocList+0x1d5>
  802fd3:	83 ec 04             	sub    $0x4,%esp
  802fd6:	68 d4 47 80 00       	push   $0x8047d4
  802fdb:	6a 7c                	push   $0x7c
  802fdd:	68 97 47 80 00       	push   $0x804797
  802fe2:	e8 81 df ff ff       	call   800f68 <_panic>
  802fe7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fea:	8b 10                	mov    (%eax),%edx
  802fec:	8b 45 08             	mov    0x8(%ebp),%eax
  802fef:	89 10                	mov    %edx,(%eax)
  802ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff4:	8b 00                	mov    (%eax),%eax
  802ff6:	85 c0                	test   %eax,%eax
  802ff8:	74 0b                	je     803005 <insert_sorted_allocList+0x1f3>
  802ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffd:	8b 00                	mov    (%eax),%eax
  802fff:	8b 55 08             	mov    0x8(%ebp),%edx
  803002:	89 50 04             	mov    %edx,0x4(%eax)
  803005:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803008:	8b 55 08             	mov    0x8(%ebp),%edx
  80300b:	89 10                	mov    %edx,(%eax)
  80300d:	8b 45 08             	mov    0x8(%ebp),%eax
  803010:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803013:	89 50 04             	mov    %edx,0x4(%eax)
  803016:	8b 45 08             	mov    0x8(%ebp),%eax
  803019:	8b 00                	mov    (%eax),%eax
  80301b:	85 c0                	test   %eax,%eax
  80301d:	75 08                	jne    803027 <insert_sorted_allocList+0x215>
  80301f:	8b 45 08             	mov    0x8(%ebp),%eax
  803022:	a3 44 50 80 00       	mov    %eax,0x805044
  803027:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80302c:	40                   	inc    %eax
  80302d:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  803032:	eb 38                	jmp    80306c <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  803034:	a1 48 50 80 00       	mov    0x805048,%eax
  803039:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80303c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803040:	74 07                	je     803049 <insert_sorted_allocList+0x237>
  803042:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803045:	8b 00                	mov    (%eax),%eax
  803047:	eb 05                	jmp    80304e <insert_sorted_allocList+0x23c>
  803049:	b8 00 00 00 00       	mov    $0x0,%eax
  80304e:	a3 48 50 80 00       	mov    %eax,0x805048
  803053:	a1 48 50 80 00       	mov    0x805048,%eax
  803058:	85 c0                	test   %eax,%eax
  80305a:	0f 85 3f ff ff ff    	jne    802f9f <insert_sorted_allocList+0x18d>
  803060:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803064:	0f 85 35 ff ff ff    	jne    802f9f <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  80306a:	eb 00                	jmp    80306c <insert_sorted_allocList+0x25a>
  80306c:	90                   	nop
  80306d:	c9                   	leave  
  80306e:	c3                   	ret    

0080306f <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80306f:	55                   	push   %ebp
  803070:	89 e5                	mov    %esp,%ebp
  803072:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  803075:	a1 38 51 80 00       	mov    0x805138,%eax
  80307a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80307d:	e9 6b 02 00 00       	jmp    8032ed <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  803082:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803085:	8b 40 0c             	mov    0xc(%eax),%eax
  803088:	3b 45 08             	cmp    0x8(%ebp),%eax
  80308b:	0f 85 90 00 00 00    	jne    803121 <alloc_block_FF+0xb2>
			  temp=element;
  803091:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803094:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  803097:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80309b:	75 17                	jne    8030b4 <alloc_block_FF+0x45>
  80309d:	83 ec 04             	sub    $0x4,%esp
  8030a0:	68 08 48 80 00       	push   $0x804808
  8030a5:	68 92 00 00 00       	push   $0x92
  8030aa:	68 97 47 80 00       	push   $0x804797
  8030af:	e8 b4 de ff ff       	call   800f68 <_panic>
  8030b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b7:	8b 00                	mov    (%eax),%eax
  8030b9:	85 c0                	test   %eax,%eax
  8030bb:	74 10                	je     8030cd <alloc_block_FF+0x5e>
  8030bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c0:	8b 00                	mov    (%eax),%eax
  8030c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030c5:	8b 52 04             	mov    0x4(%edx),%edx
  8030c8:	89 50 04             	mov    %edx,0x4(%eax)
  8030cb:	eb 0b                	jmp    8030d8 <alloc_block_FF+0x69>
  8030cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d0:	8b 40 04             	mov    0x4(%eax),%eax
  8030d3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030db:	8b 40 04             	mov    0x4(%eax),%eax
  8030de:	85 c0                	test   %eax,%eax
  8030e0:	74 0f                	je     8030f1 <alloc_block_FF+0x82>
  8030e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e5:	8b 40 04             	mov    0x4(%eax),%eax
  8030e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030eb:	8b 12                	mov    (%edx),%edx
  8030ed:	89 10                	mov    %edx,(%eax)
  8030ef:	eb 0a                	jmp    8030fb <alloc_block_FF+0x8c>
  8030f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f4:	8b 00                	mov    (%eax),%eax
  8030f6:	a3 38 51 80 00       	mov    %eax,0x805138
  8030fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803104:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803107:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80310e:	a1 44 51 80 00       	mov    0x805144,%eax
  803113:	48                   	dec    %eax
  803114:	a3 44 51 80 00       	mov    %eax,0x805144
			  return temp;
  803119:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311c:	e9 ff 01 00 00       	jmp    803320 <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  803121:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803124:	8b 40 0c             	mov    0xc(%eax),%eax
  803127:	3b 45 08             	cmp    0x8(%ebp),%eax
  80312a:	0f 86 b5 01 00 00    	jbe    8032e5 <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  803130:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803133:	8b 40 0c             	mov    0xc(%eax),%eax
  803136:	2b 45 08             	sub    0x8(%ebp),%eax
  803139:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  80313c:	a1 48 51 80 00       	mov    0x805148,%eax
  803141:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  803144:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803148:	75 17                	jne    803161 <alloc_block_FF+0xf2>
  80314a:	83 ec 04             	sub    $0x4,%esp
  80314d:	68 08 48 80 00       	push   $0x804808
  803152:	68 99 00 00 00       	push   $0x99
  803157:	68 97 47 80 00       	push   $0x804797
  80315c:	e8 07 de ff ff       	call   800f68 <_panic>
  803161:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803164:	8b 00                	mov    (%eax),%eax
  803166:	85 c0                	test   %eax,%eax
  803168:	74 10                	je     80317a <alloc_block_FF+0x10b>
  80316a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80316d:	8b 00                	mov    (%eax),%eax
  80316f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803172:	8b 52 04             	mov    0x4(%edx),%edx
  803175:	89 50 04             	mov    %edx,0x4(%eax)
  803178:	eb 0b                	jmp    803185 <alloc_block_FF+0x116>
  80317a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80317d:	8b 40 04             	mov    0x4(%eax),%eax
  803180:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803185:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803188:	8b 40 04             	mov    0x4(%eax),%eax
  80318b:	85 c0                	test   %eax,%eax
  80318d:	74 0f                	je     80319e <alloc_block_FF+0x12f>
  80318f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803192:	8b 40 04             	mov    0x4(%eax),%eax
  803195:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803198:	8b 12                	mov    (%edx),%edx
  80319a:	89 10                	mov    %edx,(%eax)
  80319c:	eb 0a                	jmp    8031a8 <alloc_block_FF+0x139>
  80319e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031a1:	8b 00                	mov    (%eax),%eax
  8031a3:	a3 48 51 80 00       	mov    %eax,0x805148
  8031a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031bb:	a1 54 51 80 00       	mov    0x805154,%eax
  8031c0:	48                   	dec    %eax
  8031c1:	a3 54 51 80 00       	mov    %eax,0x805154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  8031c6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8031ca:	75 17                	jne    8031e3 <alloc_block_FF+0x174>
  8031cc:	83 ec 04             	sub    $0x4,%esp
  8031cf:	68 b0 47 80 00       	push   $0x8047b0
  8031d4:	68 9a 00 00 00       	push   $0x9a
  8031d9:	68 97 47 80 00       	push   $0x804797
  8031de:	e8 85 dd ff ff       	call   800f68 <_panic>
  8031e3:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8031e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031ec:	89 50 04             	mov    %edx,0x4(%eax)
  8031ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031f2:	8b 40 04             	mov    0x4(%eax),%eax
  8031f5:	85 c0                	test   %eax,%eax
  8031f7:	74 0c                	je     803205 <alloc_block_FF+0x196>
  8031f9:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8031fe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803201:	89 10                	mov    %edx,(%eax)
  803203:	eb 08                	jmp    80320d <alloc_block_FF+0x19e>
  803205:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803208:	a3 38 51 80 00       	mov    %eax,0x805138
  80320d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803210:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803215:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803218:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80321e:	a1 44 51 80 00       	mov    0x805144,%eax
  803223:	40                   	inc    %eax
  803224:	a3 44 51 80 00       	mov    %eax,0x805144
		  // setting the size & sva
		  new_block->size=size;
  803229:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80322c:	8b 55 08             	mov    0x8(%ebp),%edx
  80322f:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  803232:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803235:	8b 50 08             	mov    0x8(%eax),%edx
  803238:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80323b:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  80323e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803241:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803244:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  803247:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324a:	8b 50 08             	mov    0x8(%eax),%edx
  80324d:	8b 45 08             	mov    0x8(%ebp),%eax
  803250:	01 c2                	add    %eax,%edx
  803252:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803255:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  803258:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80325b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  80325e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803262:	75 17                	jne    80327b <alloc_block_FF+0x20c>
  803264:	83 ec 04             	sub    $0x4,%esp
  803267:	68 08 48 80 00       	push   $0x804808
  80326c:	68 a2 00 00 00       	push   $0xa2
  803271:	68 97 47 80 00       	push   $0x804797
  803276:	e8 ed dc ff ff       	call   800f68 <_panic>
  80327b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80327e:	8b 00                	mov    (%eax),%eax
  803280:	85 c0                	test   %eax,%eax
  803282:	74 10                	je     803294 <alloc_block_FF+0x225>
  803284:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803287:	8b 00                	mov    (%eax),%eax
  803289:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80328c:	8b 52 04             	mov    0x4(%edx),%edx
  80328f:	89 50 04             	mov    %edx,0x4(%eax)
  803292:	eb 0b                	jmp    80329f <alloc_block_FF+0x230>
  803294:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803297:	8b 40 04             	mov    0x4(%eax),%eax
  80329a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80329f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032a2:	8b 40 04             	mov    0x4(%eax),%eax
  8032a5:	85 c0                	test   %eax,%eax
  8032a7:	74 0f                	je     8032b8 <alloc_block_FF+0x249>
  8032a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032ac:	8b 40 04             	mov    0x4(%eax),%eax
  8032af:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8032b2:	8b 12                	mov    (%edx),%edx
  8032b4:	89 10                	mov    %edx,(%eax)
  8032b6:	eb 0a                	jmp    8032c2 <alloc_block_FF+0x253>
  8032b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032bb:	8b 00                	mov    (%eax),%eax
  8032bd:	a3 38 51 80 00       	mov    %eax,0x805138
  8032c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032d5:	a1 44 51 80 00       	mov    0x805144,%eax
  8032da:	48                   	dec    %eax
  8032db:	a3 44 51 80 00       	mov    %eax,0x805144
		  return temp;
  8032e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e3:	eb 3b                	jmp    803320 <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  8032e5:	a1 40 51 80 00       	mov    0x805140,%eax
  8032ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032f1:	74 07                	je     8032fa <alloc_block_FF+0x28b>
  8032f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f6:	8b 00                	mov    (%eax),%eax
  8032f8:	eb 05                	jmp    8032ff <alloc_block_FF+0x290>
  8032fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8032ff:	a3 40 51 80 00       	mov    %eax,0x805140
  803304:	a1 40 51 80 00       	mov    0x805140,%eax
  803309:	85 c0                	test   %eax,%eax
  80330b:	0f 85 71 fd ff ff    	jne    803082 <alloc_block_FF+0x13>
  803311:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803315:	0f 85 67 fd ff ff    	jne    803082 <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  80331b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803320:	c9                   	leave  
  803321:	c3                   	ret    

00803322 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  803322:	55                   	push   %ebp
  803323:	89 e5                	mov    %esp,%ebp
  803325:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  803328:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  80332f:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  803336:	a1 38 51 80 00       	mov    0x805138,%eax
  80333b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80333e:	e9 d3 00 00 00       	jmp    803416 <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  803343:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803346:	8b 40 0c             	mov    0xc(%eax),%eax
  803349:	3b 45 08             	cmp    0x8(%ebp),%eax
  80334c:	0f 85 90 00 00 00    	jne    8033e2 <alloc_block_BF+0xc0>
	   temp = element;
  803352:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803355:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  803358:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80335c:	75 17                	jne    803375 <alloc_block_BF+0x53>
  80335e:	83 ec 04             	sub    $0x4,%esp
  803361:	68 08 48 80 00       	push   $0x804808
  803366:	68 bd 00 00 00       	push   $0xbd
  80336b:	68 97 47 80 00       	push   $0x804797
  803370:	e8 f3 db ff ff       	call   800f68 <_panic>
  803375:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803378:	8b 00                	mov    (%eax),%eax
  80337a:	85 c0                	test   %eax,%eax
  80337c:	74 10                	je     80338e <alloc_block_BF+0x6c>
  80337e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803381:	8b 00                	mov    (%eax),%eax
  803383:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803386:	8b 52 04             	mov    0x4(%edx),%edx
  803389:	89 50 04             	mov    %edx,0x4(%eax)
  80338c:	eb 0b                	jmp    803399 <alloc_block_BF+0x77>
  80338e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803391:	8b 40 04             	mov    0x4(%eax),%eax
  803394:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803399:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80339c:	8b 40 04             	mov    0x4(%eax),%eax
  80339f:	85 c0                	test   %eax,%eax
  8033a1:	74 0f                	je     8033b2 <alloc_block_BF+0x90>
  8033a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a6:	8b 40 04             	mov    0x4(%eax),%eax
  8033a9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033ac:	8b 12                	mov    (%edx),%edx
  8033ae:	89 10                	mov    %edx,(%eax)
  8033b0:	eb 0a                	jmp    8033bc <alloc_block_BF+0x9a>
  8033b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b5:	8b 00                	mov    (%eax),%eax
  8033b7:	a3 38 51 80 00       	mov    %eax,0x805138
  8033bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033cf:	a1 44 51 80 00       	mov    0x805144,%eax
  8033d4:	48                   	dec    %eax
  8033d5:	a3 44 51 80 00       	mov    %eax,0x805144
	   return temp;
  8033da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033dd:	e9 41 01 00 00       	jmp    803523 <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  8033e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8033e8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033eb:	76 21                	jbe    80340e <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  8033ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8033f3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8033f6:	73 16                	jae    80340e <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  8033f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8033fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  803401:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803404:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  803407:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  80340e:	a1 40 51 80 00       	mov    0x805140,%eax
  803413:	89 45 e8             	mov    %eax,-0x18(%ebp)
  803416:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80341a:	74 07                	je     803423 <alloc_block_BF+0x101>
  80341c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80341f:	8b 00                	mov    (%eax),%eax
  803421:	eb 05                	jmp    803428 <alloc_block_BF+0x106>
  803423:	b8 00 00 00 00       	mov    $0x0,%eax
  803428:	a3 40 51 80 00       	mov    %eax,0x805140
  80342d:	a1 40 51 80 00       	mov    0x805140,%eax
  803432:	85 c0                	test   %eax,%eax
  803434:	0f 85 09 ff ff ff    	jne    803343 <alloc_block_BF+0x21>
  80343a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80343e:	0f 85 ff fe ff ff    	jne    803343 <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  803444:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  803448:	0f 85 d0 00 00 00    	jne    80351e <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  80344e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803451:	8b 40 0c             	mov    0xc(%eax),%eax
  803454:	2b 45 08             	sub    0x8(%ebp),%eax
  803457:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  80345a:	a1 48 51 80 00       	mov    0x805148,%eax
  80345f:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  803462:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803466:	75 17                	jne    80347f <alloc_block_BF+0x15d>
  803468:	83 ec 04             	sub    $0x4,%esp
  80346b:	68 08 48 80 00       	push   $0x804808
  803470:	68 d1 00 00 00       	push   $0xd1
  803475:	68 97 47 80 00       	push   $0x804797
  80347a:	e8 e9 da ff ff       	call   800f68 <_panic>
  80347f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803482:	8b 00                	mov    (%eax),%eax
  803484:	85 c0                	test   %eax,%eax
  803486:	74 10                	je     803498 <alloc_block_BF+0x176>
  803488:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80348b:	8b 00                	mov    (%eax),%eax
  80348d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803490:	8b 52 04             	mov    0x4(%edx),%edx
  803493:	89 50 04             	mov    %edx,0x4(%eax)
  803496:	eb 0b                	jmp    8034a3 <alloc_block_BF+0x181>
  803498:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80349b:	8b 40 04             	mov    0x4(%eax),%eax
  80349e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034a6:	8b 40 04             	mov    0x4(%eax),%eax
  8034a9:	85 c0                	test   %eax,%eax
  8034ab:	74 0f                	je     8034bc <alloc_block_BF+0x19a>
  8034ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034b0:	8b 40 04             	mov    0x4(%eax),%eax
  8034b3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8034b6:	8b 12                	mov    (%edx),%edx
  8034b8:	89 10                	mov    %edx,(%eax)
  8034ba:	eb 0a                	jmp    8034c6 <alloc_block_BF+0x1a4>
  8034bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034bf:	8b 00                	mov    (%eax),%eax
  8034c1:	a3 48 51 80 00       	mov    %eax,0x805148
  8034c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034d9:	a1 54 51 80 00       	mov    0x805154,%eax
  8034de:	48                   	dec    %eax
  8034df:	a3 54 51 80 00       	mov    %eax,0x805154
	  // setting the size & sva
	  new_block->size = size;
  8034e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8034ea:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  8034ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034f0:	8b 50 08             	mov    0x8(%eax),%edx
  8034f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034f6:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  8034f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034ff:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  803502:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803505:	8b 50 08             	mov    0x8(%eax),%edx
  803508:	8b 45 08             	mov    0x8(%ebp),%eax
  80350b:	01 c2                	add    %eax,%edx
  80350d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803510:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  803513:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803516:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  803519:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80351c:	eb 05                	jmp    803523 <alloc_block_BF+0x201>
	 }
	 return NULL;
  80351e:	b8 00 00 00 00       	mov    $0x0,%eax


}
  803523:	c9                   	leave  
  803524:	c3                   	ret    

00803525 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  803525:	55                   	push   %ebp
  803526:	89 e5                	mov    %esp,%ebp
  803528:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  80352b:	83 ec 04             	sub    $0x4,%esp
  80352e:	68 28 48 80 00       	push   $0x804828
  803533:	68 e8 00 00 00       	push   $0xe8
  803538:	68 97 47 80 00       	push   $0x804797
  80353d:	e8 26 da ff ff       	call   800f68 <_panic>

00803542 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803542:	55                   	push   %ebp
  803543:	89 e5                	mov    %esp,%ebp
  803545:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  803548:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80354d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  803550:	a1 38 51 80 00       	mov    0x805138,%eax
  803555:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  803558:	a1 44 51 80 00       	mov    0x805144,%eax
  80355d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  803560:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803564:	75 68                	jne    8035ce <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  803566:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80356a:	75 17                	jne    803583 <insert_sorted_with_merge_freeList+0x41>
  80356c:	83 ec 04             	sub    $0x4,%esp
  80356f:	68 74 47 80 00       	push   $0x804774
  803574:	68 36 01 00 00       	push   $0x136
  803579:	68 97 47 80 00       	push   $0x804797
  80357e:	e8 e5 d9 ff ff       	call   800f68 <_panic>
  803583:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803589:	8b 45 08             	mov    0x8(%ebp),%eax
  80358c:	89 10                	mov    %edx,(%eax)
  80358e:	8b 45 08             	mov    0x8(%ebp),%eax
  803591:	8b 00                	mov    (%eax),%eax
  803593:	85 c0                	test   %eax,%eax
  803595:	74 0d                	je     8035a4 <insert_sorted_with_merge_freeList+0x62>
  803597:	a1 38 51 80 00       	mov    0x805138,%eax
  80359c:	8b 55 08             	mov    0x8(%ebp),%edx
  80359f:	89 50 04             	mov    %edx,0x4(%eax)
  8035a2:	eb 08                	jmp    8035ac <insert_sorted_with_merge_freeList+0x6a>
  8035a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8035af:	a3 38 51 80 00       	mov    %eax,0x805138
  8035b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035be:	a1 44 51 80 00       	mov    0x805144,%eax
  8035c3:	40                   	inc    %eax
  8035c4:	a3 44 51 80 00       	mov    %eax,0x805144





}
  8035c9:	e9 ba 06 00 00       	jmp    803c88 <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  8035ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035d1:	8b 50 08             	mov    0x8(%eax),%edx
  8035d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8035da:	01 c2                	add    %eax,%edx
  8035dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8035df:	8b 40 08             	mov    0x8(%eax),%eax
  8035e2:	39 c2                	cmp    %eax,%edx
  8035e4:	73 68                	jae    80364e <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8035e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035ea:	75 17                	jne    803603 <insert_sorted_with_merge_freeList+0xc1>
  8035ec:	83 ec 04             	sub    $0x4,%esp
  8035ef:	68 b0 47 80 00       	push   $0x8047b0
  8035f4:	68 3a 01 00 00       	push   $0x13a
  8035f9:	68 97 47 80 00       	push   $0x804797
  8035fe:	e8 65 d9 ff ff       	call   800f68 <_panic>
  803603:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803609:	8b 45 08             	mov    0x8(%ebp),%eax
  80360c:	89 50 04             	mov    %edx,0x4(%eax)
  80360f:	8b 45 08             	mov    0x8(%ebp),%eax
  803612:	8b 40 04             	mov    0x4(%eax),%eax
  803615:	85 c0                	test   %eax,%eax
  803617:	74 0c                	je     803625 <insert_sorted_with_merge_freeList+0xe3>
  803619:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80361e:	8b 55 08             	mov    0x8(%ebp),%edx
  803621:	89 10                	mov    %edx,(%eax)
  803623:	eb 08                	jmp    80362d <insert_sorted_with_merge_freeList+0xeb>
  803625:	8b 45 08             	mov    0x8(%ebp),%eax
  803628:	a3 38 51 80 00       	mov    %eax,0x805138
  80362d:	8b 45 08             	mov    0x8(%ebp),%eax
  803630:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803635:	8b 45 08             	mov    0x8(%ebp),%eax
  803638:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80363e:	a1 44 51 80 00       	mov    0x805144,%eax
  803643:	40                   	inc    %eax
  803644:	a3 44 51 80 00       	mov    %eax,0x805144





}
  803649:	e9 3a 06 00 00       	jmp    803c88 <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  80364e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803651:	8b 50 08             	mov    0x8(%eax),%edx
  803654:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803657:	8b 40 0c             	mov    0xc(%eax),%eax
  80365a:	01 c2                	add    %eax,%edx
  80365c:	8b 45 08             	mov    0x8(%ebp),%eax
  80365f:	8b 40 08             	mov    0x8(%eax),%eax
  803662:	39 c2                	cmp    %eax,%edx
  803664:	0f 85 90 00 00 00    	jne    8036fa <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  80366a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80366d:	8b 50 0c             	mov    0xc(%eax),%edx
  803670:	8b 45 08             	mov    0x8(%ebp),%eax
  803673:	8b 40 0c             	mov    0xc(%eax),%eax
  803676:	01 c2                	add    %eax,%edx
  803678:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80367b:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  80367e:	8b 45 08             	mov    0x8(%ebp),%eax
  803681:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  803688:	8b 45 08             	mov    0x8(%ebp),%eax
  80368b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803692:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803696:	75 17                	jne    8036af <insert_sorted_with_merge_freeList+0x16d>
  803698:	83 ec 04             	sub    $0x4,%esp
  80369b:	68 74 47 80 00       	push   $0x804774
  8036a0:	68 41 01 00 00       	push   $0x141
  8036a5:	68 97 47 80 00       	push   $0x804797
  8036aa:	e8 b9 d8 ff ff       	call   800f68 <_panic>
  8036af:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b8:	89 10                	mov    %edx,(%eax)
  8036ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8036bd:	8b 00                	mov    (%eax),%eax
  8036bf:	85 c0                	test   %eax,%eax
  8036c1:	74 0d                	je     8036d0 <insert_sorted_with_merge_freeList+0x18e>
  8036c3:	a1 48 51 80 00       	mov    0x805148,%eax
  8036c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8036cb:	89 50 04             	mov    %edx,0x4(%eax)
  8036ce:	eb 08                	jmp    8036d8 <insert_sorted_with_merge_freeList+0x196>
  8036d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036db:	a3 48 51 80 00       	mov    %eax,0x805148
  8036e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036ea:	a1 54 51 80 00       	mov    0x805154,%eax
  8036ef:	40                   	inc    %eax
  8036f0:	a3 54 51 80 00       	mov    %eax,0x805154





}
  8036f5:	e9 8e 05 00 00       	jmp    803c88 <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  8036fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8036fd:	8b 50 08             	mov    0x8(%eax),%edx
  803700:	8b 45 08             	mov    0x8(%ebp),%eax
  803703:	8b 40 0c             	mov    0xc(%eax),%eax
  803706:	01 c2                	add    %eax,%edx
  803708:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80370b:	8b 40 08             	mov    0x8(%eax),%eax
  80370e:	39 c2                	cmp    %eax,%edx
  803710:	73 68                	jae    80377a <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  803712:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803716:	75 17                	jne    80372f <insert_sorted_with_merge_freeList+0x1ed>
  803718:	83 ec 04             	sub    $0x4,%esp
  80371b:	68 74 47 80 00       	push   $0x804774
  803720:	68 45 01 00 00       	push   $0x145
  803725:	68 97 47 80 00       	push   $0x804797
  80372a:	e8 39 d8 ff ff       	call   800f68 <_panic>
  80372f:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803735:	8b 45 08             	mov    0x8(%ebp),%eax
  803738:	89 10                	mov    %edx,(%eax)
  80373a:	8b 45 08             	mov    0x8(%ebp),%eax
  80373d:	8b 00                	mov    (%eax),%eax
  80373f:	85 c0                	test   %eax,%eax
  803741:	74 0d                	je     803750 <insert_sorted_with_merge_freeList+0x20e>
  803743:	a1 38 51 80 00       	mov    0x805138,%eax
  803748:	8b 55 08             	mov    0x8(%ebp),%edx
  80374b:	89 50 04             	mov    %edx,0x4(%eax)
  80374e:	eb 08                	jmp    803758 <insert_sorted_with_merge_freeList+0x216>
  803750:	8b 45 08             	mov    0x8(%ebp),%eax
  803753:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803758:	8b 45 08             	mov    0x8(%ebp),%eax
  80375b:	a3 38 51 80 00       	mov    %eax,0x805138
  803760:	8b 45 08             	mov    0x8(%ebp),%eax
  803763:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80376a:	a1 44 51 80 00       	mov    0x805144,%eax
  80376f:	40                   	inc    %eax
  803770:	a3 44 51 80 00       	mov    %eax,0x805144





}
  803775:	e9 0e 05 00 00       	jmp    803c88 <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  80377a:	8b 45 08             	mov    0x8(%ebp),%eax
  80377d:	8b 50 08             	mov    0x8(%eax),%edx
  803780:	8b 45 08             	mov    0x8(%ebp),%eax
  803783:	8b 40 0c             	mov    0xc(%eax),%eax
  803786:	01 c2                	add    %eax,%edx
  803788:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80378b:	8b 40 08             	mov    0x8(%eax),%eax
  80378e:	39 c2                	cmp    %eax,%edx
  803790:	0f 85 9c 00 00 00    	jne    803832 <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  803796:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803799:	8b 50 0c             	mov    0xc(%eax),%edx
  80379c:	8b 45 08             	mov    0x8(%ebp),%eax
  80379f:	8b 40 0c             	mov    0xc(%eax),%eax
  8037a2:	01 c2                	add    %eax,%edx
  8037a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037a7:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  8037aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ad:	8b 50 08             	mov    0x8(%eax),%edx
  8037b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037b3:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  8037b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  8037c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8037ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037ce:	75 17                	jne    8037e7 <insert_sorted_with_merge_freeList+0x2a5>
  8037d0:	83 ec 04             	sub    $0x4,%esp
  8037d3:	68 74 47 80 00       	push   $0x804774
  8037d8:	68 4d 01 00 00       	push   $0x14d
  8037dd:	68 97 47 80 00       	push   $0x804797
  8037e2:	e8 81 d7 ff ff       	call   800f68 <_panic>
  8037e7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8037ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f0:	89 10                	mov    %edx,(%eax)
  8037f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f5:	8b 00                	mov    (%eax),%eax
  8037f7:	85 c0                	test   %eax,%eax
  8037f9:	74 0d                	je     803808 <insert_sorted_with_merge_freeList+0x2c6>
  8037fb:	a1 48 51 80 00       	mov    0x805148,%eax
  803800:	8b 55 08             	mov    0x8(%ebp),%edx
  803803:	89 50 04             	mov    %edx,0x4(%eax)
  803806:	eb 08                	jmp    803810 <insert_sorted_with_merge_freeList+0x2ce>
  803808:	8b 45 08             	mov    0x8(%ebp),%eax
  80380b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803810:	8b 45 08             	mov    0x8(%ebp),%eax
  803813:	a3 48 51 80 00       	mov    %eax,0x805148
  803818:	8b 45 08             	mov    0x8(%ebp),%eax
  80381b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803822:	a1 54 51 80 00       	mov    0x805154,%eax
  803827:	40                   	inc    %eax
  803828:	a3 54 51 80 00       	mov    %eax,0x805154





}
  80382d:	e9 56 04 00 00       	jmp    803c88 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  803832:	a1 38 51 80 00       	mov    0x805138,%eax
  803837:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80383a:	e9 19 04 00 00       	jmp    803c58 <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  80383f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803842:	8b 00                	mov    (%eax),%eax
  803844:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  803847:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80384a:	8b 50 08             	mov    0x8(%eax),%edx
  80384d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803850:	8b 40 0c             	mov    0xc(%eax),%eax
  803853:	01 c2                	add    %eax,%edx
  803855:	8b 45 08             	mov    0x8(%ebp),%eax
  803858:	8b 40 08             	mov    0x8(%eax),%eax
  80385b:	39 c2                	cmp    %eax,%edx
  80385d:	0f 85 ad 01 00 00    	jne    803a10 <insert_sorted_with_merge_freeList+0x4ce>
  803863:	8b 45 08             	mov    0x8(%ebp),%eax
  803866:	8b 50 08             	mov    0x8(%eax),%edx
  803869:	8b 45 08             	mov    0x8(%ebp),%eax
  80386c:	8b 40 0c             	mov    0xc(%eax),%eax
  80386f:	01 c2                	add    %eax,%edx
  803871:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803874:	8b 40 08             	mov    0x8(%eax),%eax
  803877:	39 c2                	cmp    %eax,%edx
  803879:	0f 85 91 01 00 00    	jne    803a10 <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  80387f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803882:	8b 50 0c             	mov    0xc(%eax),%edx
  803885:	8b 45 08             	mov    0x8(%ebp),%eax
  803888:	8b 48 0c             	mov    0xc(%eax),%ecx
  80388b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80388e:	8b 40 0c             	mov    0xc(%eax),%eax
  803891:	01 c8                	add    %ecx,%eax
  803893:	01 c2                	add    %eax,%edx
  803895:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803898:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  80389b:	8b 45 08             	mov    0x8(%ebp),%eax
  80389e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  8038a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  8038af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038b2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  8038b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038bc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  8038c3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038c7:	75 17                	jne    8038e0 <insert_sorted_with_merge_freeList+0x39e>
  8038c9:	83 ec 04             	sub    $0x4,%esp
  8038cc:	68 08 48 80 00       	push   $0x804808
  8038d1:	68 5b 01 00 00       	push   $0x15b
  8038d6:	68 97 47 80 00       	push   $0x804797
  8038db:	e8 88 d6 ff ff       	call   800f68 <_panic>
  8038e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e3:	8b 00                	mov    (%eax),%eax
  8038e5:	85 c0                	test   %eax,%eax
  8038e7:	74 10                	je     8038f9 <insert_sorted_with_merge_freeList+0x3b7>
  8038e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ec:	8b 00                	mov    (%eax),%eax
  8038ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038f1:	8b 52 04             	mov    0x4(%edx),%edx
  8038f4:	89 50 04             	mov    %edx,0x4(%eax)
  8038f7:	eb 0b                	jmp    803904 <insert_sorted_with_merge_freeList+0x3c2>
  8038f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038fc:	8b 40 04             	mov    0x4(%eax),%eax
  8038ff:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803904:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803907:	8b 40 04             	mov    0x4(%eax),%eax
  80390a:	85 c0                	test   %eax,%eax
  80390c:	74 0f                	je     80391d <insert_sorted_with_merge_freeList+0x3db>
  80390e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803911:	8b 40 04             	mov    0x4(%eax),%eax
  803914:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803917:	8b 12                	mov    (%edx),%edx
  803919:	89 10                	mov    %edx,(%eax)
  80391b:	eb 0a                	jmp    803927 <insert_sorted_with_merge_freeList+0x3e5>
  80391d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803920:	8b 00                	mov    (%eax),%eax
  803922:	a3 38 51 80 00       	mov    %eax,0x805138
  803927:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80392a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803930:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803933:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80393a:	a1 44 51 80 00       	mov    0x805144,%eax
  80393f:	48                   	dec    %eax
  803940:	a3 44 51 80 00       	mov    %eax,0x805144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803945:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803949:	75 17                	jne    803962 <insert_sorted_with_merge_freeList+0x420>
  80394b:	83 ec 04             	sub    $0x4,%esp
  80394e:	68 74 47 80 00       	push   $0x804774
  803953:	68 5c 01 00 00       	push   $0x15c
  803958:	68 97 47 80 00       	push   $0x804797
  80395d:	e8 06 d6 ff ff       	call   800f68 <_panic>
  803962:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803968:	8b 45 08             	mov    0x8(%ebp),%eax
  80396b:	89 10                	mov    %edx,(%eax)
  80396d:	8b 45 08             	mov    0x8(%ebp),%eax
  803970:	8b 00                	mov    (%eax),%eax
  803972:	85 c0                	test   %eax,%eax
  803974:	74 0d                	je     803983 <insert_sorted_with_merge_freeList+0x441>
  803976:	a1 48 51 80 00       	mov    0x805148,%eax
  80397b:	8b 55 08             	mov    0x8(%ebp),%edx
  80397e:	89 50 04             	mov    %edx,0x4(%eax)
  803981:	eb 08                	jmp    80398b <insert_sorted_with_merge_freeList+0x449>
  803983:	8b 45 08             	mov    0x8(%ebp),%eax
  803986:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80398b:	8b 45 08             	mov    0x8(%ebp),%eax
  80398e:	a3 48 51 80 00       	mov    %eax,0x805148
  803993:	8b 45 08             	mov    0x8(%ebp),%eax
  803996:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80399d:	a1 54 51 80 00       	mov    0x805154,%eax
  8039a2:	40                   	inc    %eax
  8039a3:	a3 54 51 80 00       	mov    %eax,0x805154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  8039a8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8039ac:	75 17                	jne    8039c5 <insert_sorted_with_merge_freeList+0x483>
  8039ae:	83 ec 04             	sub    $0x4,%esp
  8039b1:	68 74 47 80 00       	push   $0x804774
  8039b6:	68 5d 01 00 00       	push   $0x15d
  8039bb:	68 97 47 80 00       	push   $0x804797
  8039c0:	e8 a3 d5 ff ff       	call   800f68 <_panic>
  8039c5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8039cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039ce:	89 10                	mov    %edx,(%eax)
  8039d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039d3:	8b 00                	mov    (%eax),%eax
  8039d5:	85 c0                	test   %eax,%eax
  8039d7:	74 0d                	je     8039e6 <insert_sorted_with_merge_freeList+0x4a4>
  8039d9:	a1 48 51 80 00       	mov    0x805148,%eax
  8039de:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039e1:	89 50 04             	mov    %edx,0x4(%eax)
  8039e4:	eb 08                	jmp    8039ee <insert_sorted_with_merge_freeList+0x4ac>
  8039e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039e9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8039ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039f1:	a3 48 51 80 00       	mov    %eax,0x805148
  8039f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a00:	a1 54 51 80 00       	mov    0x805154,%eax
  803a05:	40                   	inc    %eax
  803a06:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  803a0b:	e9 78 02 00 00       	jmp    803c88 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  803a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a13:	8b 50 08             	mov    0x8(%eax),%edx
  803a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a19:	8b 40 0c             	mov    0xc(%eax),%eax
  803a1c:	01 c2                	add    %eax,%edx
  803a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  803a21:	8b 40 08             	mov    0x8(%eax),%eax
  803a24:	39 c2                	cmp    %eax,%edx
  803a26:	0f 83 b8 00 00 00    	jae    803ae4 <insert_sorted_with_merge_freeList+0x5a2>
  803a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a2f:	8b 50 08             	mov    0x8(%eax),%edx
  803a32:	8b 45 08             	mov    0x8(%ebp),%eax
  803a35:	8b 40 0c             	mov    0xc(%eax),%eax
  803a38:	01 c2                	add    %eax,%edx
  803a3a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a3d:	8b 40 08             	mov    0x8(%eax),%eax
  803a40:	39 c2                	cmp    %eax,%edx
  803a42:	0f 85 9c 00 00 00    	jne    803ae4 <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  803a48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a4b:	8b 50 0c             	mov    0xc(%eax),%edx
  803a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  803a51:	8b 40 0c             	mov    0xc(%eax),%eax
  803a54:	01 c2                	add    %eax,%edx
  803a56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a59:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  803a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a5f:	8b 50 08             	mov    0x8(%eax),%edx
  803a62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a65:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  803a68:	8b 45 08             	mov    0x8(%ebp),%eax
  803a6b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  803a72:	8b 45 08             	mov    0x8(%ebp),%eax
  803a75:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803a7c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a80:	75 17                	jne    803a99 <insert_sorted_with_merge_freeList+0x557>
  803a82:	83 ec 04             	sub    $0x4,%esp
  803a85:	68 74 47 80 00       	push   $0x804774
  803a8a:	68 67 01 00 00       	push   $0x167
  803a8f:	68 97 47 80 00       	push   $0x804797
  803a94:	e8 cf d4 ff ff       	call   800f68 <_panic>
  803a99:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa2:	89 10                	mov    %edx,(%eax)
  803aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa7:	8b 00                	mov    (%eax),%eax
  803aa9:	85 c0                	test   %eax,%eax
  803aab:	74 0d                	je     803aba <insert_sorted_with_merge_freeList+0x578>
  803aad:	a1 48 51 80 00       	mov    0x805148,%eax
  803ab2:	8b 55 08             	mov    0x8(%ebp),%edx
  803ab5:	89 50 04             	mov    %edx,0x4(%eax)
  803ab8:	eb 08                	jmp    803ac2 <insert_sorted_with_merge_freeList+0x580>
  803aba:	8b 45 08             	mov    0x8(%ebp),%eax
  803abd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  803ac5:	a3 48 51 80 00       	mov    %eax,0x805148
  803aca:	8b 45 08             	mov    0x8(%ebp),%eax
  803acd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ad4:	a1 54 51 80 00       	mov    0x805154,%eax
  803ad9:	40                   	inc    %eax
  803ada:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  803adf:	e9 a4 01 00 00       	jmp    803c88 <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  803ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ae7:	8b 50 08             	mov    0x8(%eax),%edx
  803aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aed:	8b 40 0c             	mov    0xc(%eax),%eax
  803af0:	01 c2                	add    %eax,%edx
  803af2:	8b 45 08             	mov    0x8(%ebp),%eax
  803af5:	8b 40 08             	mov    0x8(%eax),%eax
  803af8:	39 c2                	cmp    %eax,%edx
  803afa:	0f 85 ac 00 00 00    	jne    803bac <insert_sorted_with_merge_freeList+0x66a>
  803b00:	8b 45 08             	mov    0x8(%ebp),%eax
  803b03:	8b 50 08             	mov    0x8(%eax),%edx
  803b06:	8b 45 08             	mov    0x8(%ebp),%eax
  803b09:	8b 40 0c             	mov    0xc(%eax),%eax
  803b0c:	01 c2                	add    %eax,%edx
  803b0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b11:	8b 40 08             	mov    0x8(%eax),%eax
  803b14:	39 c2                	cmp    %eax,%edx
  803b16:	0f 83 90 00 00 00    	jae    803bac <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  803b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b1f:	8b 50 0c             	mov    0xc(%eax),%edx
  803b22:	8b 45 08             	mov    0x8(%ebp),%eax
  803b25:	8b 40 0c             	mov    0xc(%eax),%eax
  803b28:	01 c2                	add    %eax,%edx
  803b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b2d:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  803b30:	8b 45 08             	mov    0x8(%ebp),%eax
  803b33:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  803b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b3d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803b44:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b48:	75 17                	jne    803b61 <insert_sorted_with_merge_freeList+0x61f>
  803b4a:	83 ec 04             	sub    $0x4,%esp
  803b4d:	68 74 47 80 00       	push   $0x804774
  803b52:	68 70 01 00 00       	push   $0x170
  803b57:	68 97 47 80 00       	push   $0x804797
  803b5c:	e8 07 d4 ff ff       	call   800f68 <_panic>
  803b61:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803b67:	8b 45 08             	mov    0x8(%ebp),%eax
  803b6a:	89 10                	mov    %edx,(%eax)
  803b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  803b6f:	8b 00                	mov    (%eax),%eax
  803b71:	85 c0                	test   %eax,%eax
  803b73:	74 0d                	je     803b82 <insert_sorted_with_merge_freeList+0x640>
  803b75:	a1 48 51 80 00       	mov    0x805148,%eax
  803b7a:	8b 55 08             	mov    0x8(%ebp),%edx
  803b7d:	89 50 04             	mov    %edx,0x4(%eax)
  803b80:	eb 08                	jmp    803b8a <insert_sorted_with_merge_freeList+0x648>
  803b82:	8b 45 08             	mov    0x8(%ebp),%eax
  803b85:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b8d:	a3 48 51 80 00       	mov    %eax,0x805148
  803b92:	8b 45 08             	mov    0x8(%ebp),%eax
  803b95:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b9c:	a1 54 51 80 00       	mov    0x805154,%eax
  803ba1:	40                   	inc    %eax
  803ba2:	a3 54 51 80 00       	mov    %eax,0x805154
	      break;
  803ba7:	e9 dc 00 00 00       	jmp    803c88 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  803bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803baf:	8b 50 08             	mov    0x8(%eax),%edx
  803bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bb5:	8b 40 0c             	mov    0xc(%eax),%eax
  803bb8:	01 c2                	add    %eax,%edx
  803bba:	8b 45 08             	mov    0x8(%ebp),%eax
  803bbd:	8b 40 08             	mov    0x8(%eax),%eax
  803bc0:	39 c2                	cmp    %eax,%edx
  803bc2:	0f 83 88 00 00 00    	jae    803c50 <insert_sorted_with_merge_freeList+0x70e>
  803bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  803bcb:	8b 50 08             	mov    0x8(%eax),%edx
  803bce:	8b 45 08             	mov    0x8(%ebp),%eax
  803bd1:	8b 40 0c             	mov    0xc(%eax),%eax
  803bd4:	01 c2                	add    %eax,%edx
  803bd6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bd9:	8b 40 08             	mov    0x8(%eax),%eax
  803bdc:	39 c2                	cmp    %eax,%edx
  803bde:	73 70                	jae    803c50 <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  803be0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803be4:	74 06                	je     803bec <insert_sorted_with_merge_freeList+0x6aa>
  803be6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803bea:	75 17                	jne    803c03 <insert_sorted_with_merge_freeList+0x6c1>
  803bec:	83 ec 04             	sub    $0x4,%esp
  803bef:	68 d4 47 80 00       	push   $0x8047d4
  803bf4:	68 75 01 00 00       	push   $0x175
  803bf9:	68 97 47 80 00       	push   $0x804797
  803bfe:	e8 65 d3 ff ff       	call   800f68 <_panic>
  803c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c06:	8b 10                	mov    (%eax),%edx
  803c08:	8b 45 08             	mov    0x8(%ebp),%eax
  803c0b:	89 10                	mov    %edx,(%eax)
  803c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  803c10:	8b 00                	mov    (%eax),%eax
  803c12:	85 c0                	test   %eax,%eax
  803c14:	74 0b                	je     803c21 <insert_sorted_with_merge_freeList+0x6df>
  803c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c19:	8b 00                	mov    (%eax),%eax
  803c1b:	8b 55 08             	mov    0x8(%ebp),%edx
  803c1e:	89 50 04             	mov    %edx,0x4(%eax)
  803c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c24:	8b 55 08             	mov    0x8(%ebp),%edx
  803c27:	89 10                	mov    %edx,(%eax)
  803c29:	8b 45 08             	mov    0x8(%ebp),%eax
  803c2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c2f:	89 50 04             	mov    %edx,0x4(%eax)
  803c32:	8b 45 08             	mov    0x8(%ebp),%eax
  803c35:	8b 00                	mov    (%eax),%eax
  803c37:	85 c0                	test   %eax,%eax
  803c39:	75 08                	jne    803c43 <insert_sorted_with_merge_freeList+0x701>
  803c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  803c3e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803c43:	a1 44 51 80 00       	mov    0x805144,%eax
  803c48:	40                   	inc    %eax
  803c49:	a3 44 51 80 00       	mov    %eax,0x805144
	      break;
  803c4e:	eb 38                	jmp    803c88 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  803c50:	a1 40 51 80 00       	mov    0x805140,%eax
  803c55:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c58:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c5c:	74 07                	je     803c65 <insert_sorted_with_merge_freeList+0x723>
  803c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c61:	8b 00                	mov    (%eax),%eax
  803c63:	eb 05                	jmp    803c6a <insert_sorted_with_merge_freeList+0x728>
  803c65:	b8 00 00 00 00       	mov    $0x0,%eax
  803c6a:	a3 40 51 80 00       	mov    %eax,0x805140
  803c6f:	a1 40 51 80 00       	mov    0x805140,%eax
  803c74:	85 c0                	test   %eax,%eax
  803c76:	0f 85 c3 fb ff ff    	jne    80383f <insert_sorted_with_merge_freeList+0x2fd>
  803c7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c80:	0f 85 b9 fb ff ff    	jne    80383f <insert_sorted_with_merge_freeList+0x2fd>





}
  803c86:	eb 00                	jmp    803c88 <insert_sorted_with_merge_freeList+0x746>
  803c88:	90                   	nop
  803c89:	c9                   	leave  
  803c8a:	c3                   	ret    
  803c8b:	90                   	nop

00803c8c <__udivdi3>:
  803c8c:	55                   	push   %ebp
  803c8d:	57                   	push   %edi
  803c8e:	56                   	push   %esi
  803c8f:	53                   	push   %ebx
  803c90:	83 ec 1c             	sub    $0x1c,%esp
  803c93:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803c97:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803c9b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c9f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803ca3:	89 ca                	mov    %ecx,%edx
  803ca5:	89 f8                	mov    %edi,%eax
  803ca7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803cab:	85 f6                	test   %esi,%esi
  803cad:	75 2d                	jne    803cdc <__udivdi3+0x50>
  803caf:	39 cf                	cmp    %ecx,%edi
  803cb1:	77 65                	ja     803d18 <__udivdi3+0x8c>
  803cb3:	89 fd                	mov    %edi,%ebp
  803cb5:	85 ff                	test   %edi,%edi
  803cb7:	75 0b                	jne    803cc4 <__udivdi3+0x38>
  803cb9:	b8 01 00 00 00       	mov    $0x1,%eax
  803cbe:	31 d2                	xor    %edx,%edx
  803cc0:	f7 f7                	div    %edi
  803cc2:	89 c5                	mov    %eax,%ebp
  803cc4:	31 d2                	xor    %edx,%edx
  803cc6:	89 c8                	mov    %ecx,%eax
  803cc8:	f7 f5                	div    %ebp
  803cca:	89 c1                	mov    %eax,%ecx
  803ccc:	89 d8                	mov    %ebx,%eax
  803cce:	f7 f5                	div    %ebp
  803cd0:	89 cf                	mov    %ecx,%edi
  803cd2:	89 fa                	mov    %edi,%edx
  803cd4:	83 c4 1c             	add    $0x1c,%esp
  803cd7:	5b                   	pop    %ebx
  803cd8:	5e                   	pop    %esi
  803cd9:	5f                   	pop    %edi
  803cda:	5d                   	pop    %ebp
  803cdb:	c3                   	ret    
  803cdc:	39 ce                	cmp    %ecx,%esi
  803cde:	77 28                	ja     803d08 <__udivdi3+0x7c>
  803ce0:	0f bd fe             	bsr    %esi,%edi
  803ce3:	83 f7 1f             	xor    $0x1f,%edi
  803ce6:	75 40                	jne    803d28 <__udivdi3+0x9c>
  803ce8:	39 ce                	cmp    %ecx,%esi
  803cea:	72 0a                	jb     803cf6 <__udivdi3+0x6a>
  803cec:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803cf0:	0f 87 9e 00 00 00    	ja     803d94 <__udivdi3+0x108>
  803cf6:	b8 01 00 00 00       	mov    $0x1,%eax
  803cfb:	89 fa                	mov    %edi,%edx
  803cfd:	83 c4 1c             	add    $0x1c,%esp
  803d00:	5b                   	pop    %ebx
  803d01:	5e                   	pop    %esi
  803d02:	5f                   	pop    %edi
  803d03:	5d                   	pop    %ebp
  803d04:	c3                   	ret    
  803d05:	8d 76 00             	lea    0x0(%esi),%esi
  803d08:	31 ff                	xor    %edi,%edi
  803d0a:	31 c0                	xor    %eax,%eax
  803d0c:	89 fa                	mov    %edi,%edx
  803d0e:	83 c4 1c             	add    $0x1c,%esp
  803d11:	5b                   	pop    %ebx
  803d12:	5e                   	pop    %esi
  803d13:	5f                   	pop    %edi
  803d14:	5d                   	pop    %ebp
  803d15:	c3                   	ret    
  803d16:	66 90                	xchg   %ax,%ax
  803d18:	89 d8                	mov    %ebx,%eax
  803d1a:	f7 f7                	div    %edi
  803d1c:	31 ff                	xor    %edi,%edi
  803d1e:	89 fa                	mov    %edi,%edx
  803d20:	83 c4 1c             	add    $0x1c,%esp
  803d23:	5b                   	pop    %ebx
  803d24:	5e                   	pop    %esi
  803d25:	5f                   	pop    %edi
  803d26:	5d                   	pop    %ebp
  803d27:	c3                   	ret    
  803d28:	bd 20 00 00 00       	mov    $0x20,%ebp
  803d2d:	89 eb                	mov    %ebp,%ebx
  803d2f:	29 fb                	sub    %edi,%ebx
  803d31:	89 f9                	mov    %edi,%ecx
  803d33:	d3 e6                	shl    %cl,%esi
  803d35:	89 c5                	mov    %eax,%ebp
  803d37:	88 d9                	mov    %bl,%cl
  803d39:	d3 ed                	shr    %cl,%ebp
  803d3b:	89 e9                	mov    %ebp,%ecx
  803d3d:	09 f1                	or     %esi,%ecx
  803d3f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803d43:	89 f9                	mov    %edi,%ecx
  803d45:	d3 e0                	shl    %cl,%eax
  803d47:	89 c5                	mov    %eax,%ebp
  803d49:	89 d6                	mov    %edx,%esi
  803d4b:	88 d9                	mov    %bl,%cl
  803d4d:	d3 ee                	shr    %cl,%esi
  803d4f:	89 f9                	mov    %edi,%ecx
  803d51:	d3 e2                	shl    %cl,%edx
  803d53:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d57:	88 d9                	mov    %bl,%cl
  803d59:	d3 e8                	shr    %cl,%eax
  803d5b:	09 c2                	or     %eax,%edx
  803d5d:	89 d0                	mov    %edx,%eax
  803d5f:	89 f2                	mov    %esi,%edx
  803d61:	f7 74 24 0c          	divl   0xc(%esp)
  803d65:	89 d6                	mov    %edx,%esi
  803d67:	89 c3                	mov    %eax,%ebx
  803d69:	f7 e5                	mul    %ebp
  803d6b:	39 d6                	cmp    %edx,%esi
  803d6d:	72 19                	jb     803d88 <__udivdi3+0xfc>
  803d6f:	74 0b                	je     803d7c <__udivdi3+0xf0>
  803d71:	89 d8                	mov    %ebx,%eax
  803d73:	31 ff                	xor    %edi,%edi
  803d75:	e9 58 ff ff ff       	jmp    803cd2 <__udivdi3+0x46>
  803d7a:	66 90                	xchg   %ax,%ax
  803d7c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803d80:	89 f9                	mov    %edi,%ecx
  803d82:	d3 e2                	shl    %cl,%edx
  803d84:	39 c2                	cmp    %eax,%edx
  803d86:	73 e9                	jae    803d71 <__udivdi3+0xe5>
  803d88:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803d8b:	31 ff                	xor    %edi,%edi
  803d8d:	e9 40 ff ff ff       	jmp    803cd2 <__udivdi3+0x46>
  803d92:	66 90                	xchg   %ax,%ax
  803d94:	31 c0                	xor    %eax,%eax
  803d96:	e9 37 ff ff ff       	jmp    803cd2 <__udivdi3+0x46>
  803d9b:	90                   	nop

00803d9c <__umoddi3>:
  803d9c:	55                   	push   %ebp
  803d9d:	57                   	push   %edi
  803d9e:	56                   	push   %esi
  803d9f:	53                   	push   %ebx
  803da0:	83 ec 1c             	sub    $0x1c,%esp
  803da3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803da7:	8b 74 24 34          	mov    0x34(%esp),%esi
  803dab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803daf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803db3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803db7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803dbb:	89 f3                	mov    %esi,%ebx
  803dbd:	89 fa                	mov    %edi,%edx
  803dbf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803dc3:	89 34 24             	mov    %esi,(%esp)
  803dc6:	85 c0                	test   %eax,%eax
  803dc8:	75 1a                	jne    803de4 <__umoddi3+0x48>
  803dca:	39 f7                	cmp    %esi,%edi
  803dcc:	0f 86 a2 00 00 00    	jbe    803e74 <__umoddi3+0xd8>
  803dd2:	89 c8                	mov    %ecx,%eax
  803dd4:	89 f2                	mov    %esi,%edx
  803dd6:	f7 f7                	div    %edi
  803dd8:	89 d0                	mov    %edx,%eax
  803dda:	31 d2                	xor    %edx,%edx
  803ddc:	83 c4 1c             	add    $0x1c,%esp
  803ddf:	5b                   	pop    %ebx
  803de0:	5e                   	pop    %esi
  803de1:	5f                   	pop    %edi
  803de2:	5d                   	pop    %ebp
  803de3:	c3                   	ret    
  803de4:	39 f0                	cmp    %esi,%eax
  803de6:	0f 87 ac 00 00 00    	ja     803e98 <__umoddi3+0xfc>
  803dec:	0f bd e8             	bsr    %eax,%ebp
  803def:	83 f5 1f             	xor    $0x1f,%ebp
  803df2:	0f 84 ac 00 00 00    	je     803ea4 <__umoddi3+0x108>
  803df8:	bf 20 00 00 00       	mov    $0x20,%edi
  803dfd:	29 ef                	sub    %ebp,%edi
  803dff:	89 fe                	mov    %edi,%esi
  803e01:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803e05:	89 e9                	mov    %ebp,%ecx
  803e07:	d3 e0                	shl    %cl,%eax
  803e09:	89 d7                	mov    %edx,%edi
  803e0b:	89 f1                	mov    %esi,%ecx
  803e0d:	d3 ef                	shr    %cl,%edi
  803e0f:	09 c7                	or     %eax,%edi
  803e11:	89 e9                	mov    %ebp,%ecx
  803e13:	d3 e2                	shl    %cl,%edx
  803e15:	89 14 24             	mov    %edx,(%esp)
  803e18:	89 d8                	mov    %ebx,%eax
  803e1a:	d3 e0                	shl    %cl,%eax
  803e1c:	89 c2                	mov    %eax,%edx
  803e1e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e22:	d3 e0                	shl    %cl,%eax
  803e24:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e28:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e2c:	89 f1                	mov    %esi,%ecx
  803e2e:	d3 e8                	shr    %cl,%eax
  803e30:	09 d0                	or     %edx,%eax
  803e32:	d3 eb                	shr    %cl,%ebx
  803e34:	89 da                	mov    %ebx,%edx
  803e36:	f7 f7                	div    %edi
  803e38:	89 d3                	mov    %edx,%ebx
  803e3a:	f7 24 24             	mull   (%esp)
  803e3d:	89 c6                	mov    %eax,%esi
  803e3f:	89 d1                	mov    %edx,%ecx
  803e41:	39 d3                	cmp    %edx,%ebx
  803e43:	0f 82 87 00 00 00    	jb     803ed0 <__umoddi3+0x134>
  803e49:	0f 84 91 00 00 00    	je     803ee0 <__umoddi3+0x144>
  803e4f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803e53:	29 f2                	sub    %esi,%edx
  803e55:	19 cb                	sbb    %ecx,%ebx
  803e57:	89 d8                	mov    %ebx,%eax
  803e59:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803e5d:	d3 e0                	shl    %cl,%eax
  803e5f:	89 e9                	mov    %ebp,%ecx
  803e61:	d3 ea                	shr    %cl,%edx
  803e63:	09 d0                	or     %edx,%eax
  803e65:	89 e9                	mov    %ebp,%ecx
  803e67:	d3 eb                	shr    %cl,%ebx
  803e69:	89 da                	mov    %ebx,%edx
  803e6b:	83 c4 1c             	add    $0x1c,%esp
  803e6e:	5b                   	pop    %ebx
  803e6f:	5e                   	pop    %esi
  803e70:	5f                   	pop    %edi
  803e71:	5d                   	pop    %ebp
  803e72:	c3                   	ret    
  803e73:	90                   	nop
  803e74:	89 fd                	mov    %edi,%ebp
  803e76:	85 ff                	test   %edi,%edi
  803e78:	75 0b                	jne    803e85 <__umoddi3+0xe9>
  803e7a:	b8 01 00 00 00       	mov    $0x1,%eax
  803e7f:	31 d2                	xor    %edx,%edx
  803e81:	f7 f7                	div    %edi
  803e83:	89 c5                	mov    %eax,%ebp
  803e85:	89 f0                	mov    %esi,%eax
  803e87:	31 d2                	xor    %edx,%edx
  803e89:	f7 f5                	div    %ebp
  803e8b:	89 c8                	mov    %ecx,%eax
  803e8d:	f7 f5                	div    %ebp
  803e8f:	89 d0                	mov    %edx,%eax
  803e91:	e9 44 ff ff ff       	jmp    803dda <__umoddi3+0x3e>
  803e96:	66 90                	xchg   %ax,%ax
  803e98:	89 c8                	mov    %ecx,%eax
  803e9a:	89 f2                	mov    %esi,%edx
  803e9c:	83 c4 1c             	add    $0x1c,%esp
  803e9f:	5b                   	pop    %ebx
  803ea0:	5e                   	pop    %esi
  803ea1:	5f                   	pop    %edi
  803ea2:	5d                   	pop    %ebp
  803ea3:	c3                   	ret    
  803ea4:	3b 04 24             	cmp    (%esp),%eax
  803ea7:	72 06                	jb     803eaf <__umoddi3+0x113>
  803ea9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803ead:	77 0f                	ja     803ebe <__umoddi3+0x122>
  803eaf:	89 f2                	mov    %esi,%edx
  803eb1:	29 f9                	sub    %edi,%ecx
  803eb3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803eb7:	89 14 24             	mov    %edx,(%esp)
  803eba:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ebe:	8b 44 24 04          	mov    0x4(%esp),%eax
  803ec2:	8b 14 24             	mov    (%esp),%edx
  803ec5:	83 c4 1c             	add    $0x1c,%esp
  803ec8:	5b                   	pop    %ebx
  803ec9:	5e                   	pop    %esi
  803eca:	5f                   	pop    %edi
  803ecb:	5d                   	pop    %ebp
  803ecc:	c3                   	ret    
  803ecd:	8d 76 00             	lea    0x0(%esi),%esi
  803ed0:	2b 04 24             	sub    (%esp),%eax
  803ed3:	19 fa                	sbb    %edi,%edx
  803ed5:	89 d1                	mov    %edx,%ecx
  803ed7:	89 c6                	mov    %eax,%esi
  803ed9:	e9 71 ff ff ff       	jmp    803e4f <__umoddi3+0xb3>
  803ede:	66 90                	xchg   %ax,%ax
  803ee0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803ee4:	72 ea                	jb     803ed0 <__umoddi3+0x134>
  803ee6:	89 d9                	mov    %ebx,%ecx
  803ee8:	e9 62 ff ff ff       	jmp    803e4f <__umoddi3+0xb3>
