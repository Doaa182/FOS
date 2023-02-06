
obj/user/tst_page_replacement_clock:     file format elf32-i386


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
  800031:	e8 7d 05 00 00       	call   8005b3 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
char arr[PAGE_SIZE*12];
char* ptr = (char* )0x0801000 ;
char* ptr2 = (char* )0x0804000 ;

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 78             	sub    $0x78,%esp



	//("STEP 0: checking Initial WS entries ...\n");
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=   0x200000)  	panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80003e:	a1 20 30 80 00       	mov    0x803020,%eax
  800043:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800049:	8b 00                	mov    (%eax),%eax
  80004b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80004e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800051:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800056:	3d 00 00 20 00       	cmp    $0x200000,%eax
  80005b:	74 14                	je     800071 <_main+0x39>
  80005d:	83 ec 04             	sub    $0x4,%esp
  800060:	68 00 20 80 00       	push   $0x802000
  800065:	6a 15                	push   $0x15
  800067:	68 44 20 80 00       	push   $0x802044
  80006c:	e8 7e 06 00 00       	call   8006ef <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=   0x201000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800071:	a1 20 30 80 00       	mov    0x803020,%eax
  800076:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80007c:	83 c0 18             	add    $0x18,%eax
  80007f:	8b 00                	mov    (%eax),%eax
  800081:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800084:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800087:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80008c:	3d 00 10 20 00       	cmp    $0x201000,%eax
  800091:	74 14                	je     8000a7 <_main+0x6f>
  800093:	83 ec 04             	sub    $0x4,%esp
  800096:	68 00 20 80 00       	push   $0x802000
  80009b:	6a 16                	push   $0x16
  80009d:	68 44 20 80 00       	push   $0x802044
  8000a2:	e8 48 06 00 00       	call   8006ef <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=   0x202000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000a7:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ac:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8000b2:	83 c0 30             	add    $0x30,%eax
  8000b5:	8b 00                	mov    (%eax),%eax
  8000b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8000ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000bd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000c2:	3d 00 20 20 00       	cmp    $0x202000,%eax
  8000c7:	74 14                	je     8000dd <_main+0xa5>
  8000c9:	83 ec 04             	sub    $0x4,%esp
  8000cc:	68 00 20 80 00       	push   $0x802000
  8000d1:	6a 17                	push   $0x17
  8000d3:	68 44 20 80 00       	push   $0x802044
  8000d8:	e8 12 06 00 00       	call   8006ef <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=   0x203000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000dd:	a1 20 30 80 00       	mov    0x803020,%eax
  8000e2:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8000e8:	83 c0 48             	add    $0x48,%eax
  8000eb:	8b 00                	mov    (%eax),%eax
  8000ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8000f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000f8:	3d 00 30 20 00       	cmp    $0x203000,%eax
  8000fd:	74 14                	je     800113 <_main+0xdb>
  8000ff:	83 ec 04             	sub    $0x4,%esp
  800102:	68 00 20 80 00       	push   $0x802000
  800107:	6a 18                	push   $0x18
  800109:	68 44 20 80 00       	push   $0x802044
  80010e:	e8 dc 05 00 00       	call   8006ef <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=   0x204000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800113:	a1 20 30 80 00       	mov    0x803020,%eax
  800118:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80011e:	83 c0 60             	add    $0x60,%eax
  800121:	8b 00                	mov    (%eax),%eax
  800123:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800126:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800129:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80012e:	3d 00 40 20 00       	cmp    $0x204000,%eax
  800133:	74 14                	je     800149 <_main+0x111>
  800135:	83 ec 04             	sub    $0x4,%esp
  800138:	68 00 20 80 00       	push   $0x802000
  80013d:	6a 19                	push   $0x19
  80013f:	68 44 20 80 00       	push   $0x802044
  800144:	e8 a6 05 00 00       	call   8006ef <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=   0x205000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800149:	a1 20 30 80 00       	mov    0x803020,%eax
  80014e:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800154:	83 c0 78             	add    $0x78,%eax
  800157:	8b 00                	mov    (%eax),%eax
  800159:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80015c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80015f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800164:	3d 00 50 20 00       	cmp    $0x205000,%eax
  800169:	74 14                	je     80017f <_main+0x147>
  80016b:	83 ec 04             	sub    $0x4,%esp
  80016e:	68 00 20 80 00       	push   $0x802000
  800173:	6a 1a                	push   $0x1a
  800175:	68 44 20 80 00       	push   $0x802044
  80017a:	e8 70 05 00 00       	call   8006ef <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=   0x800000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80017f:	a1 20 30 80 00       	mov    0x803020,%eax
  800184:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80018a:	05 90 00 00 00       	add    $0x90,%eax
  80018f:	8b 00                	mov    (%eax),%eax
  800191:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800194:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800197:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80019c:	3d 00 00 80 00       	cmp    $0x800000,%eax
  8001a1:	74 14                	je     8001b7 <_main+0x17f>
  8001a3:	83 ec 04             	sub    $0x4,%esp
  8001a6:	68 00 20 80 00       	push   $0x802000
  8001ab:	6a 1b                	push   $0x1b
  8001ad:	68 44 20 80 00       	push   $0x802044
  8001b2:	e8 38 05 00 00       	call   8006ef <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x801000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001b7:	a1 20 30 80 00       	mov    0x803020,%eax
  8001bc:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8001c2:	05 a8 00 00 00       	add    $0xa8,%eax
  8001c7:	8b 00                	mov    (%eax),%eax
  8001c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8001cc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8001cf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001d4:	3d 00 10 80 00       	cmp    $0x801000,%eax
  8001d9:	74 14                	je     8001ef <_main+0x1b7>
  8001db:	83 ec 04             	sub    $0x4,%esp
  8001de:	68 00 20 80 00       	push   $0x802000
  8001e3:	6a 1c                	push   $0x1c
  8001e5:	68 44 20 80 00       	push   $0x802044
  8001ea:	e8 00 05 00 00       	call   8006ef <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=   0x802000)  	panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001ef:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f4:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8001fa:	05 c0 00 00 00       	add    $0xc0,%eax
  8001ff:	8b 00                	mov    (%eax),%eax
  800201:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800204:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800207:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80020c:	3d 00 20 80 00       	cmp    $0x802000,%eax
  800211:	74 14                	je     800227 <_main+0x1ef>
  800213:	83 ec 04             	sub    $0x4,%esp
  800216:	68 00 20 80 00       	push   $0x802000
  80021b:	6a 1d                	push   $0x1d
  80021d:	68 44 20 80 00       	push   $0x802044
  800222:	e8 c8 04 00 00       	call   8006ef <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0x803000)  	panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800227:	a1 20 30 80 00       	mov    0x803020,%eax
  80022c:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800232:	05 d8 00 00 00       	add    $0xd8,%eax
  800237:	8b 00                	mov    (%eax),%eax
  800239:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80023c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80023f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800244:	3d 00 30 80 00       	cmp    $0x803000,%eax
  800249:	74 14                	je     80025f <_main+0x227>
  80024b:	83 ec 04             	sub    $0x4,%esp
  80024e:	68 00 20 80 00       	push   $0x802000
  800253:	6a 1e                	push   $0x1e
  800255:	68 44 20 80 00       	push   $0x802044
  80025a:	e8 90 04 00 00       	call   8006ef <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[10].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80025f:	a1 20 30 80 00       	mov    0x803020,%eax
  800264:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80026a:	05 f0 00 00 00       	add    $0xf0,%eax
  80026f:	8b 00                	mov    (%eax),%eax
  800271:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800274:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800277:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80027c:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  800281:	74 14                	je     800297 <_main+0x25f>
  800283:	83 ec 04             	sub    $0x4,%esp
  800286:	68 00 20 80 00       	push   $0x802000
  80028b:	6a 1f                	push   $0x1f
  80028d:	68 44 20 80 00       	push   $0x802044
  800292:	e8 58 04 00 00       	call   8006ef <_panic>
		if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
  800297:	a1 20 30 80 00       	mov    0x803020,%eax
  80029c:	8b 80 2c 05 00 00    	mov    0x52c(%eax),%eax
  8002a2:	85 c0                	test   %eax,%eax
  8002a4:	74 14                	je     8002ba <_main+0x282>
  8002a6:	83 ec 04             	sub    $0x4,%esp
  8002a9:	68 68 20 80 00       	push   $0x802068
  8002ae:	6a 20                	push   $0x20
  8002b0:	68 44 20 80 00       	push   $0x802044
  8002b5:	e8 35 04 00 00       	call   8006ef <_panic>
	}

	int freePages = sys_calculate_free_frames();
  8002ba:	e8 5a 15 00 00       	call   801819 <sys_calculate_free_frames>
  8002bf:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  8002c2:	e8 f2 15 00 00       	call   8018b9 <sys_pf_calculate_allocated_pages>
  8002c7:	89 45 c0             	mov    %eax,-0x40(%ebp)

	//Reading (Not Modified)
	char garbage1 = arr[PAGE_SIZE*11-1] ;
  8002ca:	a0 5f e0 80 00       	mov    0x80e05f,%al
  8002cf:	88 45 bf             	mov    %al,-0x41(%ebp)
	char garbage2 = arr[PAGE_SIZE*12-1] ;
  8002d2:	a0 5f f0 80 00       	mov    0x80f05f,%al
  8002d7:	88 45 be             	mov    %al,-0x42(%ebp)

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8002da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8002e1:	eb 37                	jmp    80031a <_main+0x2e2>
	{
		arr[i] = -1 ;
  8002e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002e6:	05 60 30 80 00       	add    $0x803060,%eax
  8002eb:	c6 00 ff             	movb   $0xff,(%eax)
		/*2016: this BUGGY line is REMOVED el7! it overwrites the KERNEL CODE :( !!!*/
		//*ptr = *ptr2 ;
		/*==========================================================================*/
		//always use pages at 0x801000 and 0x804000
		*ptr2 = *ptr ;
  8002ee:	a1 04 30 80 00       	mov    0x803004,%eax
  8002f3:	8b 15 00 30 80 00    	mov    0x803000,%edx
  8002f9:	8a 12                	mov    (%edx),%dl
  8002fb:	88 10                	mov    %dl,(%eax)
		ptr++ ; ptr2++ ;
  8002fd:	a1 00 30 80 00       	mov    0x803000,%eax
  800302:	40                   	inc    %eax
  800303:	a3 00 30 80 00       	mov    %eax,0x803000
  800308:	a1 04 30 80 00       	mov    0x803004,%eax
  80030d:	40                   	inc    %eax
  80030e:	a3 04 30 80 00       	mov    %eax,0x803004
	char garbage1 = arr[PAGE_SIZE*11-1] ;
	char garbage2 = arr[PAGE_SIZE*12-1] ;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800313:	81 45 f4 00 08 00 00 	addl   $0x800,-0xc(%ebp)
  80031a:	81 7d f4 ff 9f 00 00 	cmpl   $0x9fff,-0xc(%ebp)
  800321:	7e c0                	jle    8002e3 <_main+0x2ab>

	//===================

	//cprintf("Checking PAGE CLOCK algorithm... \n");
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=  0xeebfd000)  panic("Page clock algo failed.. trace it by printing WS before and after page fault");
  800323:	a1 20 30 80 00       	mov    0x803020,%eax
  800328:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80032e:	8b 00                	mov    (%eax),%eax
  800330:	89 45 b8             	mov    %eax,-0x48(%ebp)
  800333:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800336:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80033b:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  800340:	74 14                	je     800356 <_main+0x31e>
  800342:	83 ec 04             	sub    $0x4,%esp
  800345:	68 b0 20 80 00       	push   $0x8020b0
  80034a:	6a 3c                	push   $0x3c
  80034c:	68 44 20 80 00       	push   $0x802044
  800351:	e8 99 03 00 00       	call   8006ef <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=  0x80a000)  panic("Page clock algo failed.. trace it by printing WS before and after page fault");
  800356:	a1 20 30 80 00       	mov    0x803020,%eax
  80035b:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800361:	83 c0 18             	add    $0x18,%eax
  800364:	8b 00                	mov    (%eax),%eax
  800366:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  800369:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80036c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800371:	3d 00 a0 80 00       	cmp    $0x80a000,%eax
  800376:	74 14                	je     80038c <_main+0x354>
  800378:	83 ec 04             	sub    $0x4,%esp
  80037b:	68 b0 20 80 00       	push   $0x8020b0
  800380:	6a 3d                	push   $0x3d
  800382:	68 44 20 80 00       	push   $0x802044
  800387:	e8 63 03 00 00       	call   8006ef <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=  0x804000)  panic("Page clock algo failed.. trace it by printing WS before and after page fault");
  80038c:	a1 20 30 80 00       	mov    0x803020,%eax
  800391:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800397:	83 c0 30             	add    $0x30,%eax
  80039a:	8b 00                	mov    (%eax),%eax
  80039c:	89 45 b0             	mov    %eax,-0x50(%ebp)
  80039f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8003a2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003a7:	3d 00 40 80 00       	cmp    $0x804000,%eax
  8003ac:	74 14                	je     8003c2 <_main+0x38a>
  8003ae:	83 ec 04             	sub    $0x4,%esp
  8003b1:	68 b0 20 80 00       	push   $0x8020b0
  8003b6:	6a 3e                	push   $0x3e
  8003b8:	68 44 20 80 00       	push   $0x802044
  8003bd:	e8 2d 03 00 00       	call   8006ef <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=  0x80b000)  panic("Page clock algo failed.. trace it by printing WS before and after page fault");
  8003c2:	a1 20 30 80 00       	mov    0x803020,%eax
  8003c7:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8003cd:	83 c0 48             	add    $0x48,%eax
  8003d0:	8b 00                	mov    (%eax),%eax
  8003d2:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8003d5:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8003d8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003dd:	3d 00 b0 80 00       	cmp    $0x80b000,%eax
  8003e2:	74 14                	je     8003f8 <_main+0x3c0>
  8003e4:	83 ec 04             	sub    $0x4,%esp
  8003e7:	68 b0 20 80 00       	push   $0x8020b0
  8003ec:	6a 3f                	push   $0x3f
  8003ee:	68 44 20 80 00       	push   $0x802044
  8003f3:	e8 f7 02 00 00       	call   8006ef <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=  0x80c000)  panic("Page clock algo failed.. trace it by printing WS before and after page fault");
  8003f8:	a1 20 30 80 00       	mov    0x803020,%eax
  8003fd:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800403:	83 c0 60             	add    $0x60,%eax
  800406:	8b 00                	mov    (%eax),%eax
  800408:	89 45 a8             	mov    %eax,-0x58(%ebp)
  80040b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80040e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800413:	3d 00 c0 80 00       	cmp    $0x80c000,%eax
  800418:	74 14                	je     80042e <_main+0x3f6>
  80041a:	83 ec 04             	sub    $0x4,%esp
  80041d:	68 b0 20 80 00       	push   $0x8020b0
  800422:	6a 40                	push   $0x40
  800424:	68 44 20 80 00       	push   $0x802044
  800429:	e8 c1 02 00 00       	call   8006ef <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=  0x807000)  panic("Page clock algo failed.. trace it by printing WS before and after page fault");
  80042e:	a1 20 30 80 00       	mov    0x803020,%eax
  800433:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800439:	83 c0 78             	add    $0x78,%eax
  80043c:	8b 00                	mov    (%eax),%eax
  80043e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  800441:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800444:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800449:	3d 00 70 80 00       	cmp    $0x807000,%eax
  80044e:	74 14                	je     800464 <_main+0x42c>
  800450:	83 ec 04             	sub    $0x4,%esp
  800453:	68 b0 20 80 00       	push   $0x8020b0
  800458:	6a 41                	push   $0x41
  80045a:	68 44 20 80 00       	push   $0x802044
  80045f:	e8 8b 02 00 00       	call   8006ef <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=  0x800000)  panic("Page clock algo failed.. trace it by printing WS before and after page fault");
  800464:	a1 20 30 80 00       	mov    0x803020,%eax
  800469:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80046f:	05 90 00 00 00       	add    $0x90,%eax
  800474:	8b 00                	mov    (%eax),%eax
  800476:	89 45 a0             	mov    %eax,-0x60(%ebp)
  800479:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80047c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800481:	3d 00 00 80 00       	cmp    $0x800000,%eax
  800486:	74 14                	je     80049c <_main+0x464>
  800488:	83 ec 04             	sub    $0x4,%esp
  80048b:	68 b0 20 80 00       	push   $0x8020b0
  800490:	6a 42                	push   $0x42
  800492:	68 44 20 80 00       	push   $0x802044
  800497:	e8 53 02 00 00       	call   8006ef <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=  0x801000)  panic("Page clock algo failed.. trace it by printing WS before and after page fault");
  80049c:	a1 20 30 80 00       	mov    0x803020,%eax
  8004a1:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8004a7:	05 a8 00 00 00       	add    $0xa8,%eax
  8004ac:	8b 00                	mov    (%eax),%eax
  8004ae:	89 45 9c             	mov    %eax,-0x64(%ebp)
  8004b1:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8004b4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004b9:	3d 00 10 80 00       	cmp    $0x801000,%eax
  8004be:	74 14                	je     8004d4 <_main+0x49c>
  8004c0:	83 ec 04             	sub    $0x4,%esp
  8004c3:	68 b0 20 80 00       	push   $0x8020b0
  8004c8:	6a 43                	push   $0x43
  8004ca:	68 44 20 80 00       	push   $0x802044
  8004cf:	e8 1b 02 00 00       	call   8006ef <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=  0x808000)  panic("Page clock algo failed.. trace it by printing WS before and after page fault");
  8004d4:	a1 20 30 80 00       	mov    0x803020,%eax
  8004d9:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8004df:	05 c0 00 00 00       	add    $0xc0,%eax
  8004e4:	8b 00                	mov    (%eax),%eax
  8004e6:	89 45 98             	mov    %eax,-0x68(%ebp)
  8004e9:	8b 45 98             	mov    -0x68(%ebp),%eax
  8004ec:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004f1:	3d 00 80 80 00       	cmp    $0x808000,%eax
  8004f6:	74 14                	je     80050c <_main+0x4d4>
  8004f8:	83 ec 04             	sub    $0x4,%esp
  8004fb:	68 b0 20 80 00       	push   $0x8020b0
  800500:	6a 44                	push   $0x44
  800502:	68 44 20 80 00       	push   $0x802044
  800507:	e8 e3 01 00 00       	call   8006ef <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=  0x809000)  panic("Page clock algo failed.. trace it by printing WS before and after page fault");
  80050c:	a1 20 30 80 00       	mov    0x803020,%eax
  800511:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800517:	05 d8 00 00 00       	add    $0xd8,%eax
  80051c:	8b 00                	mov    (%eax),%eax
  80051e:	89 45 94             	mov    %eax,-0x6c(%ebp)
  800521:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800524:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800529:	3d 00 90 80 00       	cmp    $0x809000,%eax
  80052e:	74 14                	je     800544 <_main+0x50c>
  800530:	83 ec 04             	sub    $0x4,%esp
  800533:	68 b0 20 80 00       	push   $0x8020b0
  800538:	6a 45                	push   $0x45
  80053a:	68 44 20 80 00       	push   $0x802044
  80053f:	e8 ab 01 00 00       	call   8006ef <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[10].virtual_address,PAGE_SIZE) !=  0x803000)  panic("Page clock algo failed.. trace it by printing WS before and after page fault");
  800544:	a1 20 30 80 00       	mov    0x803020,%eax
  800549:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80054f:	05 f0 00 00 00       	add    $0xf0,%eax
  800554:	8b 00                	mov    (%eax),%eax
  800556:	89 45 90             	mov    %eax,-0x70(%ebp)
  800559:	8b 45 90             	mov    -0x70(%ebp),%eax
  80055c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800561:	3d 00 30 80 00       	cmp    $0x803000,%eax
  800566:	74 14                	je     80057c <_main+0x544>
  800568:	83 ec 04             	sub    $0x4,%esp
  80056b:	68 b0 20 80 00       	push   $0x8020b0
  800570:	6a 46                	push   $0x46
  800572:	68 44 20 80 00       	push   $0x802044
  800577:	e8 73 01 00 00       	call   8006ef <_panic>
		if(myEnv->page_last_WS_index != 5) panic("wrong PAGE WS pointer location");
  80057c:	a1 20 30 80 00       	mov    0x803020,%eax
  800581:	8b 80 2c 05 00 00    	mov    0x52c(%eax),%eax
  800587:	83 f8 05             	cmp    $0x5,%eax
  80058a:	74 14                	je     8005a0 <_main+0x568>
  80058c:	83 ec 04             	sub    $0x4,%esp
  80058f:	68 00 21 80 00       	push   $0x802100
  800594:	6a 47                	push   $0x47
  800596:	68 44 20 80 00       	push   $0x802044
  80059b:	e8 4f 01 00 00       	call   8006ef <_panic>

	}

	cprintf("Congratulations!! test PAGE replacement [CLOCK Alg.] is completed successfully.\n");
  8005a0:	83 ec 0c             	sub    $0xc,%esp
  8005a3:	68 20 21 80 00       	push   $0x802120
  8005a8:	e8 f6 03 00 00       	call   8009a3 <cprintf>
  8005ad:	83 c4 10             	add    $0x10,%esp
	return;
  8005b0:	90                   	nop
}
  8005b1:	c9                   	leave  
  8005b2:	c3                   	ret    

008005b3 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8005b3:	55                   	push   %ebp
  8005b4:	89 e5                	mov    %esp,%ebp
  8005b6:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8005b9:	e8 3b 15 00 00       	call   801af9 <sys_getenvindex>
  8005be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8005c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005c4:	89 d0                	mov    %edx,%eax
  8005c6:	c1 e0 03             	shl    $0x3,%eax
  8005c9:	01 d0                	add    %edx,%eax
  8005cb:	01 c0                	add    %eax,%eax
  8005cd:	01 d0                	add    %edx,%eax
  8005cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005d6:	01 d0                	add    %edx,%eax
  8005d8:	c1 e0 04             	shl    $0x4,%eax
  8005db:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005e0:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8005e5:	a1 20 30 80 00       	mov    0x803020,%eax
  8005ea:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8005f0:	84 c0                	test   %al,%al
  8005f2:	74 0f                	je     800603 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8005f4:	a1 20 30 80 00       	mov    0x803020,%eax
  8005f9:	05 5c 05 00 00       	add    $0x55c,%eax
  8005fe:	a3 08 30 80 00       	mov    %eax,0x803008

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800603:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800607:	7e 0a                	jle    800613 <libmain+0x60>
		binaryname = argv[0];
  800609:	8b 45 0c             	mov    0xc(%ebp),%eax
  80060c:	8b 00                	mov    (%eax),%eax
  80060e:	a3 08 30 80 00       	mov    %eax,0x803008

	// call user main routine
	_main(argc, argv);
  800613:	83 ec 08             	sub    $0x8,%esp
  800616:	ff 75 0c             	pushl  0xc(%ebp)
  800619:	ff 75 08             	pushl  0x8(%ebp)
  80061c:	e8 17 fa ff ff       	call   800038 <_main>
  800621:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800624:	e8 dd 12 00 00       	call   801906 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800629:	83 ec 0c             	sub    $0xc,%esp
  80062c:	68 8c 21 80 00       	push   $0x80218c
  800631:	e8 6d 03 00 00       	call   8009a3 <cprintf>
  800636:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800639:	a1 20 30 80 00       	mov    0x803020,%eax
  80063e:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800644:	a1 20 30 80 00       	mov    0x803020,%eax
  800649:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80064f:	83 ec 04             	sub    $0x4,%esp
  800652:	52                   	push   %edx
  800653:	50                   	push   %eax
  800654:	68 b4 21 80 00       	push   $0x8021b4
  800659:	e8 45 03 00 00       	call   8009a3 <cprintf>
  80065e:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800661:	a1 20 30 80 00       	mov    0x803020,%eax
  800666:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80066c:	a1 20 30 80 00       	mov    0x803020,%eax
  800671:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800677:	a1 20 30 80 00       	mov    0x803020,%eax
  80067c:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800682:	51                   	push   %ecx
  800683:	52                   	push   %edx
  800684:	50                   	push   %eax
  800685:	68 dc 21 80 00       	push   $0x8021dc
  80068a:	e8 14 03 00 00       	call   8009a3 <cprintf>
  80068f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800692:	a1 20 30 80 00       	mov    0x803020,%eax
  800697:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80069d:	83 ec 08             	sub    $0x8,%esp
  8006a0:	50                   	push   %eax
  8006a1:	68 34 22 80 00       	push   $0x802234
  8006a6:	e8 f8 02 00 00       	call   8009a3 <cprintf>
  8006ab:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006ae:	83 ec 0c             	sub    $0xc,%esp
  8006b1:	68 8c 21 80 00       	push   $0x80218c
  8006b6:	e8 e8 02 00 00       	call   8009a3 <cprintf>
  8006bb:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006be:	e8 5d 12 00 00       	call   801920 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8006c3:	e8 19 00 00 00       	call   8006e1 <exit>
}
  8006c8:	90                   	nop
  8006c9:	c9                   	leave  
  8006ca:	c3                   	ret    

008006cb <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8006cb:	55                   	push   %ebp
  8006cc:	89 e5                	mov    %esp,%ebp
  8006ce:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8006d1:	83 ec 0c             	sub    $0xc,%esp
  8006d4:	6a 00                	push   $0x0
  8006d6:	e8 ea 13 00 00       	call   801ac5 <sys_destroy_env>
  8006db:	83 c4 10             	add    $0x10,%esp
}
  8006de:	90                   	nop
  8006df:	c9                   	leave  
  8006e0:	c3                   	ret    

008006e1 <exit>:

void
exit(void)
{
  8006e1:	55                   	push   %ebp
  8006e2:	89 e5                	mov    %esp,%ebp
  8006e4:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8006e7:	e8 3f 14 00 00       	call   801b2b <sys_exit_env>
}
  8006ec:	90                   	nop
  8006ed:	c9                   	leave  
  8006ee:	c3                   	ret    

008006ef <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8006ef:	55                   	push   %ebp
  8006f0:	89 e5                	mov    %esp,%ebp
  8006f2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8006f5:	8d 45 10             	lea    0x10(%ebp),%eax
  8006f8:	83 c0 04             	add    $0x4,%eax
  8006fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8006fe:	a1 5c f1 80 00       	mov    0x80f15c,%eax
  800703:	85 c0                	test   %eax,%eax
  800705:	74 16                	je     80071d <_panic+0x2e>
		cprintf("%s: ", argv0);
  800707:	a1 5c f1 80 00       	mov    0x80f15c,%eax
  80070c:	83 ec 08             	sub    $0x8,%esp
  80070f:	50                   	push   %eax
  800710:	68 48 22 80 00       	push   $0x802248
  800715:	e8 89 02 00 00       	call   8009a3 <cprintf>
  80071a:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80071d:	a1 08 30 80 00       	mov    0x803008,%eax
  800722:	ff 75 0c             	pushl  0xc(%ebp)
  800725:	ff 75 08             	pushl  0x8(%ebp)
  800728:	50                   	push   %eax
  800729:	68 4d 22 80 00       	push   $0x80224d
  80072e:	e8 70 02 00 00       	call   8009a3 <cprintf>
  800733:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800736:	8b 45 10             	mov    0x10(%ebp),%eax
  800739:	83 ec 08             	sub    $0x8,%esp
  80073c:	ff 75 f4             	pushl  -0xc(%ebp)
  80073f:	50                   	push   %eax
  800740:	e8 f3 01 00 00       	call   800938 <vcprintf>
  800745:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800748:	83 ec 08             	sub    $0x8,%esp
  80074b:	6a 00                	push   $0x0
  80074d:	68 69 22 80 00       	push   $0x802269
  800752:	e8 e1 01 00 00       	call   800938 <vcprintf>
  800757:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80075a:	e8 82 ff ff ff       	call   8006e1 <exit>

	// should not return here
	while (1) ;
  80075f:	eb fe                	jmp    80075f <_panic+0x70>

00800761 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800761:	55                   	push   %ebp
  800762:	89 e5                	mov    %esp,%ebp
  800764:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800767:	a1 20 30 80 00       	mov    0x803020,%eax
  80076c:	8b 50 74             	mov    0x74(%eax),%edx
  80076f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800772:	39 c2                	cmp    %eax,%edx
  800774:	74 14                	je     80078a <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800776:	83 ec 04             	sub    $0x4,%esp
  800779:	68 6c 22 80 00       	push   $0x80226c
  80077e:	6a 26                	push   $0x26
  800780:	68 b8 22 80 00       	push   $0x8022b8
  800785:	e8 65 ff ff ff       	call   8006ef <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80078a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800791:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800798:	e9 c2 00 00 00       	jmp    80085f <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80079d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007aa:	01 d0                	add    %edx,%eax
  8007ac:	8b 00                	mov    (%eax),%eax
  8007ae:	85 c0                	test   %eax,%eax
  8007b0:	75 08                	jne    8007ba <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8007b2:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8007b5:	e9 a2 00 00 00       	jmp    80085c <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8007ba:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007c1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8007c8:	eb 69                	jmp    800833 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8007ca:	a1 20 30 80 00       	mov    0x803020,%eax
  8007cf:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007d5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007d8:	89 d0                	mov    %edx,%eax
  8007da:	01 c0                	add    %eax,%eax
  8007dc:	01 d0                	add    %edx,%eax
  8007de:	c1 e0 03             	shl    $0x3,%eax
  8007e1:	01 c8                	add    %ecx,%eax
  8007e3:	8a 40 04             	mov    0x4(%eax),%al
  8007e6:	84 c0                	test   %al,%al
  8007e8:	75 46                	jne    800830 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007ea:	a1 20 30 80 00       	mov    0x803020,%eax
  8007ef:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007f5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007f8:	89 d0                	mov    %edx,%eax
  8007fa:	01 c0                	add    %eax,%eax
  8007fc:	01 d0                	add    %edx,%eax
  8007fe:	c1 e0 03             	shl    $0x3,%eax
  800801:	01 c8                	add    %ecx,%eax
  800803:	8b 00                	mov    (%eax),%eax
  800805:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800808:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80080b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800810:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800812:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800815:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80081c:	8b 45 08             	mov    0x8(%ebp),%eax
  80081f:	01 c8                	add    %ecx,%eax
  800821:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800823:	39 c2                	cmp    %eax,%edx
  800825:	75 09                	jne    800830 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800827:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80082e:	eb 12                	jmp    800842 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800830:	ff 45 e8             	incl   -0x18(%ebp)
  800833:	a1 20 30 80 00       	mov    0x803020,%eax
  800838:	8b 50 74             	mov    0x74(%eax),%edx
  80083b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80083e:	39 c2                	cmp    %eax,%edx
  800840:	77 88                	ja     8007ca <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800842:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800846:	75 14                	jne    80085c <CheckWSWithoutLastIndex+0xfb>
			panic(
  800848:	83 ec 04             	sub    $0x4,%esp
  80084b:	68 c4 22 80 00       	push   $0x8022c4
  800850:	6a 3a                	push   $0x3a
  800852:	68 b8 22 80 00       	push   $0x8022b8
  800857:	e8 93 fe ff ff       	call   8006ef <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80085c:	ff 45 f0             	incl   -0x10(%ebp)
  80085f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800862:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800865:	0f 8c 32 ff ff ff    	jl     80079d <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80086b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800872:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800879:	eb 26                	jmp    8008a1 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80087b:	a1 20 30 80 00       	mov    0x803020,%eax
  800880:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800886:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800889:	89 d0                	mov    %edx,%eax
  80088b:	01 c0                	add    %eax,%eax
  80088d:	01 d0                	add    %edx,%eax
  80088f:	c1 e0 03             	shl    $0x3,%eax
  800892:	01 c8                	add    %ecx,%eax
  800894:	8a 40 04             	mov    0x4(%eax),%al
  800897:	3c 01                	cmp    $0x1,%al
  800899:	75 03                	jne    80089e <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80089b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80089e:	ff 45 e0             	incl   -0x20(%ebp)
  8008a1:	a1 20 30 80 00       	mov    0x803020,%eax
  8008a6:	8b 50 74             	mov    0x74(%eax),%edx
  8008a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ac:	39 c2                	cmp    %eax,%edx
  8008ae:	77 cb                	ja     80087b <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8008b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008b3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8008b6:	74 14                	je     8008cc <CheckWSWithoutLastIndex+0x16b>
		panic(
  8008b8:	83 ec 04             	sub    $0x4,%esp
  8008bb:	68 18 23 80 00       	push   $0x802318
  8008c0:	6a 44                	push   $0x44
  8008c2:	68 b8 22 80 00       	push   $0x8022b8
  8008c7:	e8 23 fe ff ff       	call   8006ef <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8008cc:	90                   	nop
  8008cd:	c9                   	leave  
  8008ce:	c3                   	ret    

008008cf <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8008cf:	55                   	push   %ebp
  8008d0:	89 e5                	mov    %esp,%ebp
  8008d2:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8008d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d8:	8b 00                	mov    (%eax),%eax
  8008da:	8d 48 01             	lea    0x1(%eax),%ecx
  8008dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008e0:	89 0a                	mov    %ecx,(%edx)
  8008e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8008e5:	88 d1                	mov    %dl,%cl
  8008e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ea:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8008ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f1:	8b 00                	mov    (%eax),%eax
  8008f3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8008f8:	75 2c                	jne    800926 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8008fa:	a0 24 30 80 00       	mov    0x803024,%al
  8008ff:	0f b6 c0             	movzbl %al,%eax
  800902:	8b 55 0c             	mov    0xc(%ebp),%edx
  800905:	8b 12                	mov    (%edx),%edx
  800907:	89 d1                	mov    %edx,%ecx
  800909:	8b 55 0c             	mov    0xc(%ebp),%edx
  80090c:	83 c2 08             	add    $0x8,%edx
  80090f:	83 ec 04             	sub    $0x4,%esp
  800912:	50                   	push   %eax
  800913:	51                   	push   %ecx
  800914:	52                   	push   %edx
  800915:	e8 3e 0e 00 00       	call   801758 <sys_cputs>
  80091a:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80091d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800920:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800926:	8b 45 0c             	mov    0xc(%ebp),%eax
  800929:	8b 40 04             	mov    0x4(%eax),%eax
  80092c:	8d 50 01             	lea    0x1(%eax),%edx
  80092f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800932:	89 50 04             	mov    %edx,0x4(%eax)
}
  800935:	90                   	nop
  800936:	c9                   	leave  
  800937:	c3                   	ret    

00800938 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800938:	55                   	push   %ebp
  800939:	89 e5                	mov    %esp,%ebp
  80093b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800941:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800948:	00 00 00 
	b.cnt = 0;
  80094b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800952:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800955:	ff 75 0c             	pushl  0xc(%ebp)
  800958:	ff 75 08             	pushl  0x8(%ebp)
  80095b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800961:	50                   	push   %eax
  800962:	68 cf 08 80 00       	push   $0x8008cf
  800967:	e8 11 02 00 00       	call   800b7d <vprintfmt>
  80096c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80096f:	a0 24 30 80 00       	mov    0x803024,%al
  800974:	0f b6 c0             	movzbl %al,%eax
  800977:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80097d:	83 ec 04             	sub    $0x4,%esp
  800980:	50                   	push   %eax
  800981:	52                   	push   %edx
  800982:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800988:	83 c0 08             	add    $0x8,%eax
  80098b:	50                   	push   %eax
  80098c:	e8 c7 0d 00 00       	call   801758 <sys_cputs>
  800991:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800994:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80099b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8009a1:	c9                   	leave  
  8009a2:	c3                   	ret    

008009a3 <cprintf>:

int cprintf(const char *fmt, ...) {
  8009a3:	55                   	push   %ebp
  8009a4:	89 e5                	mov    %esp,%ebp
  8009a6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8009a9:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8009b0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b9:	83 ec 08             	sub    $0x8,%esp
  8009bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8009bf:	50                   	push   %eax
  8009c0:	e8 73 ff ff ff       	call   800938 <vcprintf>
  8009c5:	83 c4 10             	add    $0x10,%esp
  8009c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8009cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009ce:	c9                   	leave  
  8009cf:	c3                   	ret    

008009d0 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8009d0:	55                   	push   %ebp
  8009d1:	89 e5                	mov    %esp,%ebp
  8009d3:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8009d6:	e8 2b 0f 00 00       	call   801906 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8009db:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e4:	83 ec 08             	sub    $0x8,%esp
  8009e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ea:	50                   	push   %eax
  8009eb:	e8 48 ff ff ff       	call   800938 <vcprintf>
  8009f0:	83 c4 10             	add    $0x10,%esp
  8009f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8009f6:	e8 25 0f 00 00       	call   801920 <sys_enable_interrupt>
	return cnt;
  8009fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009fe:	c9                   	leave  
  8009ff:	c3                   	ret    

00800a00 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a00:	55                   	push   %ebp
  800a01:	89 e5                	mov    %esp,%ebp
  800a03:	53                   	push   %ebx
  800a04:	83 ec 14             	sub    $0x14,%esp
  800a07:	8b 45 10             	mov    0x10(%ebp),%eax
  800a0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a0d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a10:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a13:	8b 45 18             	mov    0x18(%ebp),%eax
  800a16:	ba 00 00 00 00       	mov    $0x0,%edx
  800a1b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a1e:	77 55                	ja     800a75 <printnum+0x75>
  800a20:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a23:	72 05                	jb     800a2a <printnum+0x2a>
  800a25:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a28:	77 4b                	ja     800a75 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a2a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a2d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a30:	8b 45 18             	mov    0x18(%ebp),%eax
  800a33:	ba 00 00 00 00       	mov    $0x0,%edx
  800a38:	52                   	push   %edx
  800a39:	50                   	push   %eax
  800a3a:	ff 75 f4             	pushl  -0xc(%ebp)
  800a3d:	ff 75 f0             	pushl  -0x10(%ebp)
  800a40:	e8 47 13 00 00       	call   801d8c <__udivdi3>
  800a45:	83 c4 10             	add    $0x10,%esp
  800a48:	83 ec 04             	sub    $0x4,%esp
  800a4b:	ff 75 20             	pushl  0x20(%ebp)
  800a4e:	53                   	push   %ebx
  800a4f:	ff 75 18             	pushl  0x18(%ebp)
  800a52:	52                   	push   %edx
  800a53:	50                   	push   %eax
  800a54:	ff 75 0c             	pushl  0xc(%ebp)
  800a57:	ff 75 08             	pushl  0x8(%ebp)
  800a5a:	e8 a1 ff ff ff       	call   800a00 <printnum>
  800a5f:	83 c4 20             	add    $0x20,%esp
  800a62:	eb 1a                	jmp    800a7e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a64:	83 ec 08             	sub    $0x8,%esp
  800a67:	ff 75 0c             	pushl  0xc(%ebp)
  800a6a:	ff 75 20             	pushl  0x20(%ebp)
  800a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a70:	ff d0                	call   *%eax
  800a72:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a75:	ff 4d 1c             	decl   0x1c(%ebp)
  800a78:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a7c:	7f e6                	jg     800a64 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a7e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a81:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a89:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a8c:	53                   	push   %ebx
  800a8d:	51                   	push   %ecx
  800a8e:	52                   	push   %edx
  800a8f:	50                   	push   %eax
  800a90:	e8 07 14 00 00       	call   801e9c <__umoddi3>
  800a95:	83 c4 10             	add    $0x10,%esp
  800a98:	05 94 25 80 00       	add    $0x802594,%eax
  800a9d:	8a 00                	mov    (%eax),%al
  800a9f:	0f be c0             	movsbl %al,%eax
  800aa2:	83 ec 08             	sub    $0x8,%esp
  800aa5:	ff 75 0c             	pushl  0xc(%ebp)
  800aa8:	50                   	push   %eax
  800aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aac:	ff d0                	call   *%eax
  800aae:	83 c4 10             	add    $0x10,%esp
}
  800ab1:	90                   	nop
  800ab2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ab5:	c9                   	leave  
  800ab6:	c3                   	ret    

00800ab7 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800ab7:	55                   	push   %ebp
  800ab8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800aba:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800abe:	7e 1c                	jle    800adc <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac3:	8b 00                	mov    (%eax),%eax
  800ac5:	8d 50 08             	lea    0x8(%eax),%edx
  800ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  800acb:	89 10                	mov    %edx,(%eax)
  800acd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad0:	8b 00                	mov    (%eax),%eax
  800ad2:	83 e8 08             	sub    $0x8,%eax
  800ad5:	8b 50 04             	mov    0x4(%eax),%edx
  800ad8:	8b 00                	mov    (%eax),%eax
  800ada:	eb 40                	jmp    800b1c <getuint+0x65>
	else if (lflag)
  800adc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ae0:	74 1e                	je     800b00 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae5:	8b 00                	mov    (%eax),%eax
  800ae7:	8d 50 04             	lea    0x4(%eax),%edx
  800aea:	8b 45 08             	mov    0x8(%ebp),%eax
  800aed:	89 10                	mov    %edx,(%eax)
  800aef:	8b 45 08             	mov    0x8(%ebp),%eax
  800af2:	8b 00                	mov    (%eax),%eax
  800af4:	83 e8 04             	sub    $0x4,%eax
  800af7:	8b 00                	mov    (%eax),%eax
  800af9:	ba 00 00 00 00       	mov    $0x0,%edx
  800afe:	eb 1c                	jmp    800b1c <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b00:	8b 45 08             	mov    0x8(%ebp),%eax
  800b03:	8b 00                	mov    (%eax),%eax
  800b05:	8d 50 04             	lea    0x4(%eax),%edx
  800b08:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0b:	89 10                	mov    %edx,(%eax)
  800b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b10:	8b 00                	mov    (%eax),%eax
  800b12:	83 e8 04             	sub    $0x4,%eax
  800b15:	8b 00                	mov    (%eax),%eax
  800b17:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b1c:	5d                   	pop    %ebp
  800b1d:	c3                   	ret    

00800b1e <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b1e:	55                   	push   %ebp
  800b1f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b21:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b25:	7e 1c                	jle    800b43 <getint+0x25>
		return va_arg(*ap, long long);
  800b27:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2a:	8b 00                	mov    (%eax),%eax
  800b2c:	8d 50 08             	lea    0x8(%eax),%edx
  800b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b32:	89 10                	mov    %edx,(%eax)
  800b34:	8b 45 08             	mov    0x8(%ebp),%eax
  800b37:	8b 00                	mov    (%eax),%eax
  800b39:	83 e8 08             	sub    $0x8,%eax
  800b3c:	8b 50 04             	mov    0x4(%eax),%edx
  800b3f:	8b 00                	mov    (%eax),%eax
  800b41:	eb 38                	jmp    800b7b <getint+0x5d>
	else if (lflag)
  800b43:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b47:	74 1a                	je     800b63 <getint+0x45>
		return va_arg(*ap, long);
  800b49:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4c:	8b 00                	mov    (%eax),%eax
  800b4e:	8d 50 04             	lea    0x4(%eax),%edx
  800b51:	8b 45 08             	mov    0x8(%ebp),%eax
  800b54:	89 10                	mov    %edx,(%eax)
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	8b 00                	mov    (%eax),%eax
  800b5b:	83 e8 04             	sub    $0x4,%eax
  800b5e:	8b 00                	mov    (%eax),%eax
  800b60:	99                   	cltd   
  800b61:	eb 18                	jmp    800b7b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
  800b66:	8b 00                	mov    (%eax),%eax
  800b68:	8d 50 04             	lea    0x4(%eax),%edx
  800b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6e:	89 10                	mov    %edx,(%eax)
  800b70:	8b 45 08             	mov    0x8(%ebp),%eax
  800b73:	8b 00                	mov    (%eax),%eax
  800b75:	83 e8 04             	sub    $0x4,%eax
  800b78:	8b 00                	mov    (%eax),%eax
  800b7a:	99                   	cltd   
}
  800b7b:	5d                   	pop    %ebp
  800b7c:	c3                   	ret    

00800b7d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b7d:	55                   	push   %ebp
  800b7e:	89 e5                	mov    %esp,%ebp
  800b80:	56                   	push   %esi
  800b81:	53                   	push   %ebx
  800b82:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b85:	eb 17                	jmp    800b9e <vprintfmt+0x21>
			if (ch == '\0')
  800b87:	85 db                	test   %ebx,%ebx
  800b89:	0f 84 af 03 00 00    	je     800f3e <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800b8f:	83 ec 08             	sub    $0x8,%esp
  800b92:	ff 75 0c             	pushl  0xc(%ebp)
  800b95:	53                   	push   %ebx
  800b96:	8b 45 08             	mov    0x8(%ebp),%eax
  800b99:	ff d0                	call   *%eax
  800b9b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b9e:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba1:	8d 50 01             	lea    0x1(%eax),%edx
  800ba4:	89 55 10             	mov    %edx,0x10(%ebp)
  800ba7:	8a 00                	mov    (%eax),%al
  800ba9:	0f b6 d8             	movzbl %al,%ebx
  800bac:	83 fb 25             	cmp    $0x25,%ebx
  800baf:	75 d6                	jne    800b87 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800bb1:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800bb5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800bbc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800bc3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800bca:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800bd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd4:	8d 50 01             	lea    0x1(%eax),%edx
  800bd7:	89 55 10             	mov    %edx,0x10(%ebp)
  800bda:	8a 00                	mov    (%eax),%al
  800bdc:	0f b6 d8             	movzbl %al,%ebx
  800bdf:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800be2:	83 f8 55             	cmp    $0x55,%eax
  800be5:	0f 87 2b 03 00 00    	ja     800f16 <vprintfmt+0x399>
  800beb:	8b 04 85 b8 25 80 00 	mov    0x8025b8(,%eax,4),%eax
  800bf2:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800bf4:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800bf8:	eb d7                	jmp    800bd1 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bfa:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800bfe:	eb d1                	jmp    800bd1 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c00:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c07:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c0a:	89 d0                	mov    %edx,%eax
  800c0c:	c1 e0 02             	shl    $0x2,%eax
  800c0f:	01 d0                	add    %edx,%eax
  800c11:	01 c0                	add    %eax,%eax
  800c13:	01 d8                	add    %ebx,%eax
  800c15:	83 e8 30             	sub    $0x30,%eax
  800c18:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c1e:	8a 00                	mov    (%eax),%al
  800c20:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c23:	83 fb 2f             	cmp    $0x2f,%ebx
  800c26:	7e 3e                	jle    800c66 <vprintfmt+0xe9>
  800c28:	83 fb 39             	cmp    $0x39,%ebx
  800c2b:	7f 39                	jg     800c66 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c2d:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c30:	eb d5                	jmp    800c07 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c32:	8b 45 14             	mov    0x14(%ebp),%eax
  800c35:	83 c0 04             	add    $0x4,%eax
  800c38:	89 45 14             	mov    %eax,0x14(%ebp)
  800c3b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c3e:	83 e8 04             	sub    $0x4,%eax
  800c41:	8b 00                	mov    (%eax),%eax
  800c43:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c46:	eb 1f                	jmp    800c67 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c48:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c4c:	79 83                	jns    800bd1 <vprintfmt+0x54>
				width = 0;
  800c4e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c55:	e9 77 ff ff ff       	jmp    800bd1 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c5a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c61:	e9 6b ff ff ff       	jmp    800bd1 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c66:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c67:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c6b:	0f 89 60 ff ff ff    	jns    800bd1 <vprintfmt+0x54>
				width = precision, precision = -1;
  800c71:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c74:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c77:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c7e:	e9 4e ff ff ff       	jmp    800bd1 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c83:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c86:	e9 46 ff ff ff       	jmp    800bd1 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c8b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c8e:	83 c0 04             	add    $0x4,%eax
  800c91:	89 45 14             	mov    %eax,0x14(%ebp)
  800c94:	8b 45 14             	mov    0x14(%ebp),%eax
  800c97:	83 e8 04             	sub    $0x4,%eax
  800c9a:	8b 00                	mov    (%eax),%eax
  800c9c:	83 ec 08             	sub    $0x8,%esp
  800c9f:	ff 75 0c             	pushl  0xc(%ebp)
  800ca2:	50                   	push   %eax
  800ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca6:	ff d0                	call   *%eax
  800ca8:	83 c4 10             	add    $0x10,%esp
			break;
  800cab:	e9 89 02 00 00       	jmp    800f39 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800cb0:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb3:	83 c0 04             	add    $0x4,%eax
  800cb6:	89 45 14             	mov    %eax,0x14(%ebp)
  800cb9:	8b 45 14             	mov    0x14(%ebp),%eax
  800cbc:	83 e8 04             	sub    $0x4,%eax
  800cbf:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800cc1:	85 db                	test   %ebx,%ebx
  800cc3:	79 02                	jns    800cc7 <vprintfmt+0x14a>
				err = -err;
  800cc5:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800cc7:	83 fb 64             	cmp    $0x64,%ebx
  800cca:	7f 0b                	jg     800cd7 <vprintfmt+0x15a>
  800ccc:	8b 34 9d 00 24 80 00 	mov    0x802400(,%ebx,4),%esi
  800cd3:	85 f6                	test   %esi,%esi
  800cd5:	75 19                	jne    800cf0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800cd7:	53                   	push   %ebx
  800cd8:	68 a5 25 80 00       	push   $0x8025a5
  800cdd:	ff 75 0c             	pushl  0xc(%ebp)
  800ce0:	ff 75 08             	pushl  0x8(%ebp)
  800ce3:	e8 5e 02 00 00       	call   800f46 <printfmt>
  800ce8:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ceb:	e9 49 02 00 00       	jmp    800f39 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800cf0:	56                   	push   %esi
  800cf1:	68 ae 25 80 00       	push   $0x8025ae
  800cf6:	ff 75 0c             	pushl  0xc(%ebp)
  800cf9:	ff 75 08             	pushl  0x8(%ebp)
  800cfc:	e8 45 02 00 00       	call   800f46 <printfmt>
  800d01:	83 c4 10             	add    $0x10,%esp
			break;
  800d04:	e9 30 02 00 00       	jmp    800f39 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d09:	8b 45 14             	mov    0x14(%ebp),%eax
  800d0c:	83 c0 04             	add    $0x4,%eax
  800d0f:	89 45 14             	mov    %eax,0x14(%ebp)
  800d12:	8b 45 14             	mov    0x14(%ebp),%eax
  800d15:	83 e8 04             	sub    $0x4,%eax
  800d18:	8b 30                	mov    (%eax),%esi
  800d1a:	85 f6                	test   %esi,%esi
  800d1c:	75 05                	jne    800d23 <vprintfmt+0x1a6>
				p = "(null)";
  800d1e:	be b1 25 80 00       	mov    $0x8025b1,%esi
			if (width > 0 && padc != '-')
  800d23:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d27:	7e 6d                	jle    800d96 <vprintfmt+0x219>
  800d29:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d2d:	74 67                	je     800d96 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d32:	83 ec 08             	sub    $0x8,%esp
  800d35:	50                   	push   %eax
  800d36:	56                   	push   %esi
  800d37:	e8 0c 03 00 00       	call   801048 <strnlen>
  800d3c:	83 c4 10             	add    $0x10,%esp
  800d3f:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d42:	eb 16                	jmp    800d5a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d44:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d48:	83 ec 08             	sub    $0x8,%esp
  800d4b:	ff 75 0c             	pushl  0xc(%ebp)
  800d4e:	50                   	push   %eax
  800d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d52:	ff d0                	call   *%eax
  800d54:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d57:	ff 4d e4             	decl   -0x1c(%ebp)
  800d5a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d5e:	7f e4                	jg     800d44 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d60:	eb 34                	jmp    800d96 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d62:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d66:	74 1c                	je     800d84 <vprintfmt+0x207>
  800d68:	83 fb 1f             	cmp    $0x1f,%ebx
  800d6b:	7e 05                	jle    800d72 <vprintfmt+0x1f5>
  800d6d:	83 fb 7e             	cmp    $0x7e,%ebx
  800d70:	7e 12                	jle    800d84 <vprintfmt+0x207>
					putch('?', putdat);
  800d72:	83 ec 08             	sub    $0x8,%esp
  800d75:	ff 75 0c             	pushl  0xc(%ebp)
  800d78:	6a 3f                	push   $0x3f
  800d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7d:	ff d0                	call   *%eax
  800d7f:	83 c4 10             	add    $0x10,%esp
  800d82:	eb 0f                	jmp    800d93 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d84:	83 ec 08             	sub    $0x8,%esp
  800d87:	ff 75 0c             	pushl  0xc(%ebp)
  800d8a:	53                   	push   %ebx
  800d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8e:	ff d0                	call   *%eax
  800d90:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d93:	ff 4d e4             	decl   -0x1c(%ebp)
  800d96:	89 f0                	mov    %esi,%eax
  800d98:	8d 70 01             	lea    0x1(%eax),%esi
  800d9b:	8a 00                	mov    (%eax),%al
  800d9d:	0f be d8             	movsbl %al,%ebx
  800da0:	85 db                	test   %ebx,%ebx
  800da2:	74 24                	je     800dc8 <vprintfmt+0x24b>
  800da4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800da8:	78 b8                	js     800d62 <vprintfmt+0x1e5>
  800daa:	ff 4d e0             	decl   -0x20(%ebp)
  800dad:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800db1:	79 af                	jns    800d62 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800db3:	eb 13                	jmp    800dc8 <vprintfmt+0x24b>
				putch(' ', putdat);
  800db5:	83 ec 08             	sub    $0x8,%esp
  800db8:	ff 75 0c             	pushl  0xc(%ebp)
  800dbb:	6a 20                	push   $0x20
  800dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc0:	ff d0                	call   *%eax
  800dc2:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800dc5:	ff 4d e4             	decl   -0x1c(%ebp)
  800dc8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dcc:	7f e7                	jg     800db5 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800dce:	e9 66 01 00 00       	jmp    800f39 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800dd3:	83 ec 08             	sub    $0x8,%esp
  800dd6:	ff 75 e8             	pushl  -0x18(%ebp)
  800dd9:	8d 45 14             	lea    0x14(%ebp),%eax
  800ddc:	50                   	push   %eax
  800ddd:	e8 3c fd ff ff       	call   800b1e <getint>
  800de2:	83 c4 10             	add    $0x10,%esp
  800de5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800de8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800deb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800df1:	85 d2                	test   %edx,%edx
  800df3:	79 23                	jns    800e18 <vprintfmt+0x29b>
				putch('-', putdat);
  800df5:	83 ec 08             	sub    $0x8,%esp
  800df8:	ff 75 0c             	pushl  0xc(%ebp)
  800dfb:	6a 2d                	push   $0x2d
  800dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800e00:	ff d0                	call   *%eax
  800e02:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e0b:	f7 d8                	neg    %eax
  800e0d:	83 d2 00             	adc    $0x0,%edx
  800e10:	f7 da                	neg    %edx
  800e12:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e15:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e18:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e1f:	e9 bc 00 00 00       	jmp    800ee0 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e24:	83 ec 08             	sub    $0x8,%esp
  800e27:	ff 75 e8             	pushl  -0x18(%ebp)
  800e2a:	8d 45 14             	lea    0x14(%ebp),%eax
  800e2d:	50                   	push   %eax
  800e2e:	e8 84 fc ff ff       	call   800ab7 <getuint>
  800e33:	83 c4 10             	add    $0x10,%esp
  800e36:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e39:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e3c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e43:	e9 98 00 00 00       	jmp    800ee0 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e48:	83 ec 08             	sub    $0x8,%esp
  800e4b:	ff 75 0c             	pushl  0xc(%ebp)
  800e4e:	6a 58                	push   $0x58
  800e50:	8b 45 08             	mov    0x8(%ebp),%eax
  800e53:	ff d0                	call   *%eax
  800e55:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e58:	83 ec 08             	sub    $0x8,%esp
  800e5b:	ff 75 0c             	pushl  0xc(%ebp)
  800e5e:	6a 58                	push   $0x58
  800e60:	8b 45 08             	mov    0x8(%ebp),%eax
  800e63:	ff d0                	call   *%eax
  800e65:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e68:	83 ec 08             	sub    $0x8,%esp
  800e6b:	ff 75 0c             	pushl  0xc(%ebp)
  800e6e:	6a 58                	push   $0x58
  800e70:	8b 45 08             	mov    0x8(%ebp),%eax
  800e73:	ff d0                	call   *%eax
  800e75:	83 c4 10             	add    $0x10,%esp
			break;
  800e78:	e9 bc 00 00 00       	jmp    800f39 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800e7d:	83 ec 08             	sub    $0x8,%esp
  800e80:	ff 75 0c             	pushl  0xc(%ebp)
  800e83:	6a 30                	push   $0x30
  800e85:	8b 45 08             	mov    0x8(%ebp),%eax
  800e88:	ff d0                	call   *%eax
  800e8a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e8d:	83 ec 08             	sub    $0x8,%esp
  800e90:	ff 75 0c             	pushl  0xc(%ebp)
  800e93:	6a 78                	push   $0x78
  800e95:	8b 45 08             	mov    0x8(%ebp),%eax
  800e98:	ff d0                	call   *%eax
  800e9a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800e9d:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea0:	83 c0 04             	add    $0x4,%eax
  800ea3:	89 45 14             	mov    %eax,0x14(%ebp)
  800ea6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea9:	83 e8 04             	sub    $0x4,%eax
  800eac:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800eae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eb1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800eb8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ebf:	eb 1f                	jmp    800ee0 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ec1:	83 ec 08             	sub    $0x8,%esp
  800ec4:	ff 75 e8             	pushl  -0x18(%ebp)
  800ec7:	8d 45 14             	lea    0x14(%ebp),%eax
  800eca:	50                   	push   %eax
  800ecb:	e8 e7 fb ff ff       	call   800ab7 <getuint>
  800ed0:	83 c4 10             	add    $0x10,%esp
  800ed3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ed6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ed9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ee0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ee4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ee7:	83 ec 04             	sub    $0x4,%esp
  800eea:	52                   	push   %edx
  800eeb:	ff 75 e4             	pushl  -0x1c(%ebp)
  800eee:	50                   	push   %eax
  800eef:	ff 75 f4             	pushl  -0xc(%ebp)
  800ef2:	ff 75 f0             	pushl  -0x10(%ebp)
  800ef5:	ff 75 0c             	pushl  0xc(%ebp)
  800ef8:	ff 75 08             	pushl  0x8(%ebp)
  800efb:	e8 00 fb ff ff       	call   800a00 <printnum>
  800f00:	83 c4 20             	add    $0x20,%esp
			break;
  800f03:	eb 34                	jmp    800f39 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f05:	83 ec 08             	sub    $0x8,%esp
  800f08:	ff 75 0c             	pushl  0xc(%ebp)
  800f0b:	53                   	push   %ebx
  800f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0f:	ff d0                	call   *%eax
  800f11:	83 c4 10             	add    $0x10,%esp
			break;
  800f14:	eb 23                	jmp    800f39 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f16:	83 ec 08             	sub    $0x8,%esp
  800f19:	ff 75 0c             	pushl  0xc(%ebp)
  800f1c:	6a 25                	push   $0x25
  800f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f21:	ff d0                	call   *%eax
  800f23:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f26:	ff 4d 10             	decl   0x10(%ebp)
  800f29:	eb 03                	jmp    800f2e <vprintfmt+0x3b1>
  800f2b:	ff 4d 10             	decl   0x10(%ebp)
  800f2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f31:	48                   	dec    %eax
  800f32:	8a 00                	mov    (%eax),%al
  800f34:	3c 25                	cmp    $0x25,%al
  800f36:	75 f3                	jne    800f2b <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f38:	90                   	nop
		}
	}
  800f39:	e9 47 fc ff ff       	jmp    800b85 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f3e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f3f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f42:	5b                   	pop    %ebx
  800f43:	5e                   	pop    %esi
  800f44:	5d                   	pop    %ebp
  800f45:	c3                   	ret    

00800f46 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f46:	55                   	push   %ebp
  800f47:	89 e5                	mov    %esp,%ebp
  800f49:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f4c:	8d 45 10             	lea    0x10(%ebp),%eax
  800f4f:	83 c0 04             	add    $0x4,%eax
  800f52:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f55:	8b 45 10             	mov    0x10(%ebp),%eax
  800f58:	ff 75 f4             	pushl  -0xc(%ebp)
  800f5b:	50                   	push   %eax
  800f5c:	ff 75 0c             	pushl  0xc(%ebp)
  800f5f:	ff 75 08             	pushl  0x8(%ebp)
  800f62:	e8 16 fc ff ff       	call   800b7d <vprintfmt>
  800f67:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f6a:	90                   	nop
  800f6b:	c9                   	leave  
  800f6c:	c3                   	ret    

00800f6d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f6d:	55                   	push   %ebp
  800f6e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f73:	8b 40 08             	mov    0x8(%eax),%eax
  800f76:	8d 50 01             	lea    0x1(%eax),%edx
  800f79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f82:	8b 10                	mov    (%eax),%edx
  800f84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f87:	8b 40 04             	mov    0x4(%eax),%eax
  800f8a:	39 c2                	cmp    %eax,%edx
  800f8c:	73 12                	jae    800fa0 <sprintputch+0x33>
		*b->buf++ = ch;
  800f8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f91:	8b 00                	mov    (%eax),%eax
  800f93:	8d 48 01             	lea    0x1(%eax),%ecx
  800f96:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f99:	89 0a                	mov    %ecx,(%edx)
  800f9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9e:	88 10                	mov    %dl,(%eax)
}
  800fa0:	90                   	nop
  800fa1:	5d                   	pop    %ebp
  800fa2:	c3                   	ret    

00800fa3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fa3:	55                   	push   %ebp
  800fa4:	89 e5                	mov    %esp,%ebp
  800fa6:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800faf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb8:	01 d0                	add    %edx,%eax
  800fba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fbd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800fc4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fc8:	74 06                	je     800fd0 <vsnprintf+0x2d>
  800fca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fce:	7f 07                	jg     800fd7 <vsnprintf+0x34>
		return -E_INVAL;
  800fd0:	b8 03 00 00 00       	mov    $0x3,%eax
  800fd5:	eb 20                	jmp    800ff7 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800fd7:	ff 75 14             	pushl  0x14(%ebp)
  800fda:	ff 75 10             	pushl  0x10(%ebp)
  800fdd:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800fe0:	50                   	push   %eax
  800fe1:	68 6d 0f 80 00       	push   $0x800f6d
  800fe6:	e8 92 fb ff ff       	call   800b7d <vprintfmt>
  800feb:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800fee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ff1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ff7:	c9                   	leave  
  800ff8:	c3                   	ret    

00800ff9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ff9:	55                   	push   %ebp
  800ffa:	89 e5                	mov    %esp,%ebp
  800ffc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800fff:	8d 45 10             	lea    0x10(%ebp),%eax
  801002:	83 c0 04             	add    $0x4,%eax
  801005:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801008:	8b 45 10             	mov    0x10(%ebp),%eax
  80100b:	ff 75 f4             	pushl  -0xc(%ebp)
  80100e:	50                   	push   %eax
  80100f:	ff 75 0c             	pushl  0xc(%ebp)
  801012:	ff 75 08             	pushl  0x8(%ebp)
  801015:	e8 89 ff ff ff       	call   800fa3 <vsnprintf>
  80101a:	83 c4 10             	add    $0x10,%esp
  80101d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801020:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801023:	c9                   	leave  
  801024:	c3                   	ret    

00801025 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801025:	55                   	push   %ebp
  801026:	89 e5                	mov    %esp,%ebp
  801028:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80102b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801032:	eb 06                	jmp    80103a <strlen+0x15>
		n++;
  801034:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801037:	ff 45 08             	incl   0x8(%ebp)
  80103a:	8b 45 08             	mov    0x8(%ebp),%eax
  80103d:	8a 00                	mov    (%eax),%al
  80103f:	84 c0                	test   %al,%al
  801041:	75 f1                	jne    801034 <strlen+0xf>
		n++;
	return n;
  801043:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801046:	c9                   	leave  
  801047:	c3                   	ret    

00801048 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801048:	55                   	push   %ebp
  801049:	89 e5                	mov    %esp,%ebp
  80104b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80104e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801055:	eb 09                	jmp    801060 <strnlen+0x18>
		n++;
  801057:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80105a:	ff 45 08             	incl   0x8(%ebp)
  80105d:	ff 4d 0c             	decl   0xc(%ebp)
  801060:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801064:	74 09                	je     80106f <strnlen+0x27>
  801066:	8b 45 08             	mov    0x8(%ebp),%eax
  801069:	8a 00                	mov    (%eax),%al
  80106b:	84 c0                	test   %al,%al
  80106d:	75 e8                	jne    801057 <strnlen+0xf>
		n++;
	return n;
  80106f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801072:	c9                   	leave  
  801073:	c3                   	ret    

00801074 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801074:	55                   	push   %ebp
  801075:	89 e5                	mov    %esp,%ebp
  801077:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801080:	90                   	nop
  801081:	8b 45 08             	mov    0x8(%ebp),%eax
  801084:	8d 50 01             	lea    0x1(%eax),%edx
  801087:	89 55 08             	mov    %edx,0x8(%ebp)
  80108a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80108d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801090:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801093:	8a 12                	mov    (%edx),%dl
  801095:	88 10                	mov    %dl,(%eax)
  801097:	8a 00                	mov    (%eax),%al
  801099:	84 c0                	test   %al,%al
  80109b:	75 e4                	jne    801081 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80109d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010a0:	c9                   	leave  
  8010a1:	c3                   	ret    

008010a2 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8010a2:	55                   	push   %ebp
  8010a3:	89 e5                	mov    %esp,%ebp
  8010a5:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8010a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ab:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010b5:	eb 1f                	jmp    8010d6 <strncpy+0x34>
		*dst++ = *src;
  8010b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ba:	8d 50 01             	lea    0x1(%eax),%edx
  8010bd:	89 55 08             	mov    %edx,0x8(%ebp)
  8010c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010c3:	8a 12                	mov    (%edx),%dl
  8010c5:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ca:	8a 00                	mov    (%eax),%al
  8010cc:	84 c0                	test   %al,%al
  8010ce:	74 03                	je     8010d3 <strncpy+0x31>
			src++;
  8010d0:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010d3:	ff 45 fc             	incl   -0x4(%ebp)
  8010d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d9:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010dc:	72 d9                	jb     8010b7 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010de:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010e1:	c9                   	leave  
  8010e2:	c3                   	ret    

008010e3 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010e3:	55                   	push   %ebp
  8010e4:	89 e5                	mov    %esp,%ebp
  8010e6:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010ef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010f3:	74 30                	je     801125 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010f5:	eb 16                	jmp    80110d <strlcpy+0x2a>
			*dst++ = *src++;
  8010f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fa:	8d 50 01             	lea    0x1(%eax),%edx
  8010fd:	89 55 08             	mov    %edx,0x8(%ebp)
  801100:	8b 55 0c             	mov    0xc(%ebp),%edx
  801103:	8d 4a 01             	lea    0x1(%edx),%ecx
  801106:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801109:	8a 12                	mov    (%edx),%dl
  80110b:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80110d:	ff 4d 10             	decl   0x10(%ebp)
  801110:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801114:	74 09                	je     80111f <strlcpy+0x3c>
  801116:	8b 45 0c             	mov    0xc(%ebp),%eax
  801119:	8a 00                	mov    (%eax),%al
  80111b:	84 c0                	test   %al,%al
  80111d:	75 d8                	jne    8010f7 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80111f:	8b 45 08             	mov    0x8(%ebp),%eax
  801122:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801125:	8b 55 08             	mov    0x8(%ebp),%edx
  801128:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80112b:	29 c2                	sub    %eax,%edx
  80112d:	89 d0                	mov    %edx,%eax
}
  80112f:	c9                   	leave  
  801130:	c3                   	ret    

00801131 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801131:	55                   	push   %ebp
  801132:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801134:	eb 06                	jmp    80113c <strcmp+0xb>
		p++, q++;
  801136:	ff 45 08             	incl   0x8(%ebp)
  801139:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80113c:	8b 45 08             	mov    0x8(%ebp),%eax
  80113f:	8a 00                	mov    (%eax),%al
  801141:	84 c0                	test   %al,%al
  801143:	74 0e                	je     801153 <strcmp+0x22>
  801145:	8b 45 08             	mov    0x8(%ebp),%eax
  801148:	8a 10                	mov    (%eax),%dl
  80114a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114d:	8a 00                	mov    (%eax),%al
  80114f:	38 c2                	cmp    %al,%dl
  801151:	74 e3                	je     801136 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801153:	8b 45 08             	mov    0x8(%ebp),%eax
  801156:	8a 00                	mov    (%eax),%al
  801158:	0f b6 d0             	movzbl %al,%edx
  80115b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115e:	8a 00                	mov    (%eax),%al
  801160:	0f b6 c0             	movzbl %al,%eax
  801163:	29 c2                	sub    %eax,%edx
  801165:	89 d0                	mov    %edx,%eax
}
  801167:	5d                   	pop    %ebp
  801168:	c3                   	ret    

00801169 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801169:	55                   	push   %ebp
  80116a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80116c:	eb 09                	jmp    801177 <strncmp+0xe>
		n--, p++, q++;
  80116e:	ff 4d 10             	decl   0x10(%ebp)
  801171:	ff 45 08             	incl   0x8(%ebp)
  801174:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801177:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80117b:	74 17                	je     801194 <strncmp+0x2b>
  80117d:	8b 45 08             	mov    0x8(%ebp),%eax
  801180:	8a 00                	mov    (%eax),%al
  801182:	84 c0                	test   %al,%al
  801184:	74 0e                	je     801194 <strncmp+0x2b>
  801186:	8b 45 08             	mov    0x8(%ebp),%eax
  801189:	8a 10                	mov    (%eax),%dl
  80118b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118e:	8a 00                	mov    (%eax),%al
  801190:	38 c2                	cmp    %al,%dl
  801192:	74 da                	je     80116e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801194:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801198:	75 07                	jne    8011a1 <strncmp+0x38>
		return 0;
  80119a:	b8 00 00 00 00       	mov    $0x0,%eax
  80119f:	eb 14                	jmp    8011b5 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a4:	8a 00                	mov    (%eax),%al
  8011a6:	0f b6 d0             	movzbl %al,%edx
  8011a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ac:	8a 00                	mov    (%eax),%al
  8011ae:	0f b6 c0             	movzbl %al,%eax
  8011b1:	29 c2                	sub    %eax,%edx
  8011b3:	89 d0                	mov    %edx,%eax
}
  8011b5:	5d                   	pop    %ebp
  8011b6:	c3                   	ret    

008011b7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011b7:	55                   	push   %ebp
  8011b8:	89 e5                	mov    %esp,%ebp
  8011ba:	83 ec 04             	sub    $0x4,%esp
  8011bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011c3:	eb 12                	jmp    8011d7 <strchr+0x20>
		if (*s == c)
  8011c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c8:	8a 00                	mov    (%eax),%al
  8011ca:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011cd:	75 05                	jne    8011d4 <strchr+0x1d>
			return (char *) s;
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	eb 11                	jmp    8011e5 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011d4:	ff 45 08             	incl   0x8(%ebp)
  8011d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011da:	8a 00                	mov    (%eax),%al
  8011dc:	84 c0                	test   %al,%al
  8011de:	75 e5                	jne    8011c5 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011e5:	c9                   	leave  
  8011e6:	c3                   	ret    

008011e7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011e7:	55                   	push   %ebp
  8011e8:	89 e5                	mov    %esp,%ebp
  8011ea:	83 ec 04             	sub    $0x4,%esp
  8011ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011f3:	eb 0d                	jmp    801202 <strfind+0x1b>
		if (*s == c)
  8011f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f8:	8a 00                	mov    (%eax),%al
  8011fa:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011fd:	74 0e                	je     80120d <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011ff:	ff 45 08             	incl   0x8(%ebp)
  801202:	8b 45 08             	mov    0x8(%ebp),%eax
  801205:	8a 00                	mov    (%eax),%al
  801207:	84 c0                	test   %al,%al
  801209:	75 ea                	jne    8011f5 <strfind+0xe>
  80120b:	eb 01                	jmp    80120e <strfind+0x27>
		if (*s == c)
			break;
  80120d:	90                   	nop
	return (char *) s;
  80120e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801211:	c9                   	leave  
  801212:	c3                   	ret    

00801213 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801213:	55                   	push   %ebp
  801214:	89 e5                	mov    %esp,%ebp
  801216:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801219:	8b 45 08             	mov    0x8(%ebp),%eax
  80121c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80121f:	8b 45 10             	mov    0x10(%ebp),%eax
  801222:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801225:	eb 0e                	jmp    801235 <memset+0x22>
		*p++ = c;
  801227:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80122a:	8d 50 01             	lea    0x1(%eax),%edx
  80122d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801230:	8b 55 0c             	mov    0xc(%ebp),%edx
  801233:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801235:	ff 4d f8             	decl   -0x8(%ebp)
  801238:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80123c:	79 e9                	jns    801227 <memset+0x14>
		*p++ = c;

	return v;
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801241:	c9                   	leave  
  801242:	c3                   	ret    

00801243 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801243:	55                   	push   %ebp
  801244:	89 e5                	mov    %esp,%ebp
  801246:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801249:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80124f:	8b 45 08             	mov    0x8(%ebp),%eax
  801252:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801255:	eb 16                	jmp    80126d <memcpy+0x2a>
		*d++ = *s++;
  801257:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80125a:	8d 50 01             	lea    0x1(%eax),%edx
  80125d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801260:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801263:	8d 4a 01             	lea    0x1(%edx),%ecx
  801266:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801269:	8a 12                	mov    (%edx),%dl
  80126b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80126d:	8b 45 10             	mov    0x10(%ebp),%eax
  801270:	8d 50 ff             	lea    -0x1(%eax),%edx
  801273:	89 55 10             	mov    %edx,0x10(%ebp)
  801276:	85 c0                	test   %eax,%eax
  801278:	75 dd                	jne    801257 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80127a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80127d:	c9                   	leave  
  80127e:	c3                   	ret    

0080127f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80127f:	55                   	push   %ebp
  801280:	89 e5                	mov    %esp,%ebp
  801282:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801285:	8b 45 0c             	mov    0xc(%ebp),%eax
  801288:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80128b:	8b 45 08             	mov    0x8(%ebp),%eax
  80128e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801291:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801294:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801297:	73 50                	jae    8012e9 <memmove+0x6a>
  801299:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80129c:	8b 45 10             	mov    0x10(%ebp),%eax
  80129f:	01 d0                	add    %edx,%eax
  8012a1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012a4:	76 43                	jbe    8012e9 <memmove+0x6a>
		s += n;
  8012a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a9:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8012ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8012af:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012b2:	eb 10                	jmp    8012c4 <memmove+0x45>
			*--d = *--s;
  8012b4:	ff 4d f8             	decl   -0x8(%ebp)
  8012b7:	ff 4d fc             	decl   -0x4(%ebp)
  8012ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012bd:	8a 10                	mov    (%eax),%dl
  8012bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c2:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012ca:	89 55 10             	mov    %edx,0x10(%ebp)
  8012cd:	85 c0                	test   %eax,%eax
  8012cf:	75 e3                	jne    8012b4 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8012d1:	eb 23                	jmp    8012f6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8012d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012d6:	8d 50 01             	lea    0x1(%eax),%edx
  8012d9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012dc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012df:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012e2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012e5:	8a 12                	mov    (%edx),%dl
  8012e7:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ec:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012ef:	89 55 10             	mov    %edx,0x10(%ebp)
  8012f2:	85 c0                	test   %eax,%eax
  8012f4:	75 dd                	jne    8012d3 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8012f6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012f9:	c9                   	leave  
  8012fa:	c3                   	ret    

008012fb <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8012fb:	55                   	push   %ebp
  8012fc:	89 e5                	mov    %esp,%ebp
  8012fe:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801301:	8b 45 08             	mov    0x8(%ebp),%eax
  801304:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801307:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130a:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80130d:	eb 2a                	jmp    801339 <memcmp+0x3e>
		if (*s1 != *s2)
  80130f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801312:	8a 10                	mov    (%eax),%dl
  801314:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801317:	8a 00                	mov    (%eax),%al
  801319:	38 c2                	cmp    %al,%dl
  80131b:	74 16                	je     801333 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80131d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801320:	8a 00                	mov    (%eax),%al
  801322:	0f b6 d0             	movzbl %al,%edx
  801325:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801328:	8a 00                	mov    (%eax),%al
  80132a:	0f b6 c0             	movzbl %al,%eax
  80132d:	29 c2                	sub    %eax,%edx
  80132f:	89 d0                	mov    %edx,%eax
  801331:	eb 18                	jmp    80134b <memcmp+0x50>
		s1++, s2++;
  801333:	ff 45 fc             	incl   -0x4(%ebp)
  801336:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801339:	8b 45 10             	mov    0x10(%ebp),%eax
  80133c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80133f:	89 55 10             	mov    %edx,0x10(%ebp)
  801342:	85 c0                	test   %eax,%eax
  801344:	75 c9                	jne    80130f <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801346:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80134b:	c9                   	leave  
  80134c:	c3                   	ret    

0080134d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80134d:	55                   	push   %ebp
  80134e:	89 e5                	mov    %esp,%ebp
  801350:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801353:	8b 55 08             	mov    0x8(%ebp),%edx
  801356:	8b 45 10             	mov    0x10(%ebp),%eax
  801359:	01 d0                	add    %edx,%eax
  80135b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80135e:	eb 15                	jmp    801375 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801360:	8b 45 08             	mov    0x8(%ebp),%eax
  801363:	8a 00                	mov    (%eax),%al
  801365:	0f b6 d0             	movzbl %al,%edx
  801368:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136b:	0f b6 c0             	movzbl %al,%eax
  80136e:	39 c2                	cmp    %eax,%edx
  801370:	74 0d                	je     80137f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801372:	ff 45 08             	incl   0x8(%ebp)
  801375:	8b 45 08             	mov    0x8(%ebp),%eax
  801378:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80137b:	72 e3                	jb     801360 <memfind+0x13>
  80137d:	eb 01                	jmp    801380 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80137f:	90                   	nop
	return (void *) s;
  801380:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801383:	c9                   	leave  
  801384:	c3                   	ret    

00801385 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801385:	55                   	push   %ebp
  801386:	89 e5                	mov    %esp,%ebp
  801388:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80138b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801392:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801399:	eb 03                	jmp    80139e <strtol+0x19>
		s++;
  80139b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80139e:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a1:	8a 00                	mov    (%eax),%al
  8013a3:	3c 20                	cmp    $0x20,%al
  8013a5:	74 f4                	je     80139b <strtol+0x16>
  8013a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013aa:	8a 00                	mov    (%eax),%al
  8013ac:	3c 09                	cmp    $0x9,%al
  8013ae:	74 eb                	je     80139b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b3:	8a 00                	mov    (%eax),%al
  8013b5:	3c 2b                	cmp    $0x2b,%al
  8013b7:	75 05                	jne    8013be <strtol+0x39>
		s++;
  8013b9:	ff 45 08             	incl   0x8(%ebp)
  8013bc:	eb 13                	jmp    8013d1 <strtol+0x4c>
	else if (*s == '-')
  8013be:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c1:	8a 00                	mov    (%eax),%al
  8013c3:	3c 2d                	cmp    $0x2d,%al
  8013c5:	75 0a                	jne    8013d1 <strtol+0x4c>
		s++, neg = 1;
  8013c7:	ff 45 08             	incl   0x8(%ebp)
  8013ca:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013d1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013d5:	74 06                	je     8013dd <strtol+0x58>
  8013d7:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8013db:	75 20                	jne    8013fd <strtol+0x78>
  8013dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e0:	8a 00                	mov    (%eax),%al
  8013e2:	3c 30                	cmp    $0x30,%al
  8013e4:	75 17                	jne    8013fd <strtol+0x78>
  8013e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e9:	40                   	inc    %eax
  8013ea:	8a 00                	mov    (%eax),%al
  8013ec:	3c 78                	cmp    $0x78,%al
  8013ee:	75 0d                	jne    8013fd <strtol+0x78>
		s += 2, base = 16;
  8013f0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8013f4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8013fb:	eb 28                	jmp    801425 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8013fd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801401:	75 15                	jne    801418 <strtol+0x93>
  801403:	8b 45 08             	mov    0x8(%ebp),%eax
  801406:	8a 00                	mov    (%eax),%al
  801408:	3c 30                	cmp    $0x30,%al
  80140a:	75 0c                	jne    801418 <strtol+0x93>
		s++, base = 8;
  80140c:	ff 45 08             	incl   0x8(%ebp)
  80140f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801416:	eb 0d                	jmp    801425 <strtol+0xa0>
	else if (base == 0)
  801418:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80141c:	75 07                	jne    801425 <strtol+0xa0>
		base = 10;
  80141e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801425:	8b 45 08             	mov    0x8(%ebp),%eax
  801428:	8a 00                	mov    (%eax),%al
  80142a:	3c 2f                	cmp    $0x2f,%al
  80142c:	7e 19                	jle    801447 <strtol+0xc2>
  80142e:	8b 45 08             	mov    0x8(%ebp),%eax
  801431:	8a 00                	mov    (%eax),%al
  801433:	3c 39                	cmp    $0x39,%al
  801435:	7f 10                	jg     801447 <strtol+0xc2>
			dig = *s - '0';
  801437:	8b 45 08             	mov    0x8(%ebp),%eax
  80143a:	8a 00                	mov    (%eax),%al
  80143c:	0f be c0             	movsbl %al,%eax
  80143f:	83 e8 30             	sub    $0x30,%eax
  801442:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801445:	eb 42                	jmp    801489 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801447:	8b 45 08             	mov    0x8(%ebp),%eax
  80144a:	8a 00                	mov    (%eax),%al
  80144c:	3c 60                	cmp    $0x60,%al
  80144e:	7e 19                	jle    801469 <strtol+0xe4>
  801450:	8b 45 08             	mov    0x8(%ebp),%eax
  801453:	8a 00                	mov    (%eax),%al
  801455:	3c 7a                	cmp    $0x7a,%al
  801457:	7f 10                	jg     801469 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801459:	8b 45 08             	mov    0x8(%ebp),%eax
  80145c:	8a 00                	mov    (%eax),%al
  80145e:	0f be c0             	movsbl %al,%eax
  801461:	83 e8 57             	sub    $0x57,%eax
  801464:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801467:	eb 20                	jmp    801489 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801469:	8b 45 08             	mov    0x8(%ebp),%eax
  80146c:	8a 00                	mov    (%eax),%al
  80146e:	3c 40                	cmp    $0x40,%al
  801470:	7e 39                	jle    8014ab <strtol+0x126>
  801472:	8b 45 08             	mov    0x8(%ebp),%eax
  801475:	8a 00                	mov    (%eax),%al
  801477:	3c 5a                	cmp    $0x5a,%al
  801479:	7f 30                	jg     8014ab <strtol+0x126>
			dig = *s - 'A' + 10;
  80147b:	8b 45 08             	mov    0x8(%ebp),%eax
  80147e:	8a 00                	mov    (%eax),%al
  801480:	0f be c0             	movsbl %al,%eax
  801483:	83 e8 37             	sub    $0x37,%eax
  801486:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801489:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80148c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80148f:	7d 19                	jge    8014aa <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801491:	ff 45 08             	incl   0x8(%ebp)
  801494:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801497:	0f af 45 10          	imul   0x10(%ebp),%eax
  80149b:	89 c2                	mov    %eax,%edx
  80149d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014a0:	01 d0                	add    %edx,%eax
  8014a2:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8014a5:	e9 7b ff ff ff       	jmp    801425 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8014aa:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8014ab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014af:	74 08                	je     8014b9 <strtol+0x134>
		*endptr = (char *) s;
  8014b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8014b7:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8014b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014bd:	74 07                	je     8014c6 <strtol+0x141>
  8014bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014c2:	f7 d8                	neg    %eax
  8014c4:	eb 03                	jmp    8014c9 <strtol+0x144>
  8014c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014c9:	c9                   	leave  
  8014ca:	c3                   	ret    

008014cb <ltostr>:

void
ltostr(long value, char *str)
{
  8014cb:	55                   	push   %ebp
  8014cc:	89 e5                	mov    %esp,%ebp
  8014ce:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8014d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8014d8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8014df:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014e3:	79 13                	jns    8014f8 <ltostr+0x2d>
	{
		neg = 1;
  8014e5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ef:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8014f2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8014f5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8014f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fb:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801500:	99                   	cltd   
  801501:	f7 f9                	idiv   %ecx
  801503:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801506:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801509:	8d 50 01             	lea    0x1(%eax),%edx
  80150c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80150f:	89 c2                	mov    %eax,%edx
  801511:	8b 45 0c             	mov    0xc(%ebp),%eax
  801514:	01 d0                	add    %edx,%eax
  801516:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801519:	83 c2 30             	add    $0x30,%edx
  80151c:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80151e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801521:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801526:	f7 e9                	imul   %ecx
  801528:	c1 fa 02             	sar    $0x2,%edx
  80152b:	89 c8                	mov    %ecx,%eax
  80152d:	c1 f8 1f             	sar    $0x1f,%eax
  801530:	29 c2                	sub    %eax,%edx
  801532:	89 d0                	mov    %edx,%eax
  801534:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801537:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80153a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80153f:	f7 e9                	imul   %ecx
  801541:	c1 fa 02             	sar    $0x2,%edx
  801544:	89 c8                	mov    %ecx,%eax
  801546:	c1 f8 1f             	sar    $0x1f,%eax
  801549:	29 c2                	sub    %eax,%edx
  80154b:	89 d0                	mov    %edx,%eax
  80154d:	c1 e0 02             	shl    $0x2,%eax
  801550:	01 d0                	add    %edx,%eax
  801552:	01 c0                	add    %eax,%eax
  801554:	29 c1                	sub    %eax,%ecx
  801556:	89 ca                	mov    %ecx,%edx
  801558:	85 d2                	test   %edx,%edx
  80155a:	75 9c                	jne    8014f8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80155c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801563:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801566:	48                   	dec    %eax
  801567:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80156a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80156e:	74 3d                	je     8015ad <ltostr+0xe2>
		start = 1 ;
  801570:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801577:	eb 34                	jmp    8015ad <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801579:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80157c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157f:	01 d0                	add    %edx,%eax
  801581:	8a 00                	mov    (%eax),%al
  801583:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801586:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801589:	8b 45 0c             	mov    0xc(%ebp),%eax
  80158c:	01 c2                	add    %eax,%edx
  80158e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801591:	8b 45 0c             	mov    0xc(%ebp),%eax
  801594:	01 c8                	add    %ecx,%eax
  801596:	8a 00                	mov    (%eax),%al
  801598:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80159a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80159d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a0:	01 c2                	add    %eax,%edx
  8015a2:	8a 45 eb             	mov    -0x15(%ebp),%al
  8015a5:	88 02                	mov    %al,(%edx)
		start++ ;
  8015a7:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8015aa:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8015ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015b3:	7c c4                	jl     801579 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8015b5:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8015b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015bb:	01 d0                	add    %edx,%eax
  8015bd:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8015c0:	90                   	nop
  8015c1:	c9                   	leave  
  8015c2:	c3                   	ret    

008015c3 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8015c3:	55                   	push   %ebp
  8015c4:	89 e5                	mov    %esp,%ebp
  8015c6:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8015c9:	ff 75 08             	pushl  0x8(%ebp)
  8015cc:	e8 54 fa ff ff       	call   801025 <strlen>
  8015d1:	83 c4 04             	add    $0x4,%esp
  8015d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8015d7:	ff 75 0c             	pushl  0xc(%ebp)
  8015da:	e8 46 fa ff ff       	call   801025 <strlen>
  8015df:	83 c4 04             	add    $0x4,%esp
  8015e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8015ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015f3:	eb 17                	jmp    80160c <strcconcat+0x49>
		final[s] = str1[s] ;
  8015f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8015fb:	01 c2                	add    %eax,%edx
  8015fd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801600:	8b 45 08             	mov    0x8(%ebp),%eax
  801603:	01 c8                	add    %ecx,%eax
  801605:	8a 00                	mov    (%eax),%al
  801607:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801609:	ff 45 fc             	incl   -0x4(%ebp)
  80160c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80160f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801612:	7c e1                	jl     8015f5 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801614:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80161b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801622:	eb 1f                	jmp    801643 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801624:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801627:	8d 50 01             	lea    0x1(%eax),%edx
  80162a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80162d:	89 c2                	mov    %eax,%edx
  80162f:	8b 45 10             	mov    0x10(%ebp),%eax
  801632:	01 c2                	add    %eax,%edx
  801634:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801637:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163a:	01 c8                	add    %ecx,%eax
  80163c:	8a 00                	mov    (%eax),%al
  80163e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801640:	ff 45 f8             	incl   -0x8(%ebp)
  801643:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801646:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801649:	7c d9                	jl     801624 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80164b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80164e:	8b 45 10             	mov    0x10(%ebp),%eax
  801651:	01 d0                	add    %edx,%eax
  801653:	c6 00 00             	movb   $0x0,(%eax)
}
  801656:	90                   	nop
  801657:	c9                   	leave  
  801658:	c3                   	ret    

00801659 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801659:	55                   	push   %ebp
  80165a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80165c:	8b 45 14             	mov    0x14(%ebp),%eax
  80165f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801665:	8b 45 14             	mov    0x14(%ebp),%eax
  801668:	8b 00                	mov    (%eax),%eax
  80166a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801671:	8b 45 10             	mov    0x10(%ebp),%eax
  801674:	01 d0                	add    %edx,%eax
  801676:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80167c:	eb 0c                	jmp    80168a <strsplit+0x31>
			*string++ = 0;
  80167e:	8b 45 08             	mov    0x8(%ebp),%eax
  801681:	8d 50 01             	lea    0x1(%eax),%edx
  801684:	89 55 08             	mov    %edx,0x8(%ebp)
  801687:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80168a:	8b 45 08             	mov    0x8(%ebp),%eax
  80168d:	8a 00                	mov    (%eax),%al
  80168f:	84 c0                	test   %al,%al
  801691:	74 18                	je     8016ab <strsplit+0x52>
  801693:	8b 45 08             	mov    0x8(%ebp),%eax
  801696:	8a 00                	mov    (%eax),%al
  801698:	0f be c0             	movsbl %al,%eax
  80169b:	50                   	push   %eax
  80169c:	ff 75 0c             	pushl  0xc(%ebp)
  80169f:	e8 13 fb ff ff       	call   8011b7 <strchr>
  8016a4:	83 c4 08             	add    $0x8,%esp
  8016a7:	85 c0                	test   %eax,%eax
  8016a9:	75 d3                	jne    80167e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8016ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ae:	8a 00                	mov    (%eax),%al
  8016b0:	84 c0                	test   %al,%al
  8016b2:	74 5a                	je     80170e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8016b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8016b7:	8b 00                	mov    (%eax),%eax
  8016b9:	83 f8 0f             	cmp    $0xf,%eax
  8016bc:	75 07                	jne    8016c5 <strsplit+0x6c>
		{
			return 0;
  8016be:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c3:	eb 66                	jmp    80172b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8016c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8016c8:	8b 00                	mov    (%eax),%eax
  8016ca:	8d 48 01             	lea    0x1(%eax),%ecx
  8016cd:	8b 55 14             	mov    0x14(%ebp),%edx
  8016d0:	89 0a                	mov    %ecx,(%edx)
  8016d2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8016dc:	01 c2                	add    %eax,%edx
  8016de:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e1:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016e3:	eb 03                	jmp    8016e8 <strsplit+0x8f>
			string++;
  8016e5:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016eb:	8a 00                	mov    (%eax),%al
  8016ed:	84 c0                	test   %al,%al
  8016ef:	74 8b                	je     80167c <strsplit+0x23>
  8016f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f4:	8a 00                	mov    (%eax),%al
  8016f6:	0f be c0             	movsbl %al,%eax
  8016f9:	50                   	push   %eax
  8016fa:	ff 75 0c             	pushl  0xc(%ebp)
  8016fd:	e8 b5 fa ff ff       	call   8011b7 <strchr>
  801702:	83 c4 08             	add    $0x8,%esp
  801705:	85 c0                	test   %eax,%eax
  801707:	74 dc                	je     8016e5 <strsplit+0x8c>
			string++;
	}
  801709:	e9 6e ff ff ff       	jmp    80167c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80170e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80170f:	8b 45 14             	mov    0x14(%ebp),%eax
  801712:	8b 00                	mov    (%eax),%eax
  801714:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80171b:	8b 45 10             	mov    0x10(%ebp),%eax
  80171e:	01 d0                	add    %edx,%eax
  801720:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801726:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80172b:	c9                   	leave  
  80172c:	c3                   	ret    

0080172d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
  801730:	57                   	push   %edi
  801731:	56                   	push   %esi
  801732:	53                   	push   %ebx
  801733:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801736:	8b 45 08             	mov    0x8(%ebp),%eax
  801739:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80173f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801742:	8b 7d 18             	mov    0x18(%ebp),%edi
  801745:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801748:	cd 30                	int    $0x30
  80174a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80174d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801750:	83 c4 10             	add    $0x10,%esp
  801753:	5b                   	pop    %ebx
  801754:	5e                   	pop    %esi
  801755:	5f                   	pop    %edi
  801756:	5d                   	pop    %ebp
  801757:	c3                   	ret    

00801758 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801758:	55                   	push   %ebp
  801759:	89 e5                	mov    %esp,%ebp
  80175b:	83 ec 04             	sub    $0x4,%esp
  80175e:	8b 45 10             	mov    0x10(%ebp),%eax
  801761:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801764:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801768:	8b 45 08             	mov    0x8(%ebp),%eax
  80176b:	6a 00                	push   $0x0
  80176d:	6a 00                	push   $0x0
  80176f:	52                   	push   %edx
  801770:	ff 75 0c             	pushl  0xc(%ebp)
  801773:	50                   	push   %eax
  801774:	6a 00                	push   $0x0
  801776:	e8 b2 ff ff ff       	call   80172d <syscall>
  80177b:	83 c4 18             	add    $0x18,%esp
}
  80177e:	90                   	nop
  80177f:	c9                   	leave  
  801780:	c3                   	ret    

00801781 <sys_cgetc>:

int
sys_cgetc(void)
{
  801781:	55                   	push   %ebp
  801782:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801784:	6a 00                	push   $0x0
  801786:	6a 00                	push   $0x0
  801788:	6a 00                	push   $0x0
  80178a:	6a 00                	push   $0x0
  80178c:	6a 00                	push   $0x0
  80178e:	6a 01                	push   $0x1
  801790:	e8 98 ff ff ff       	call   80172d <syscall>
  801795:	83 c4 18             	add    $0x18,%esp
}
  801798:	c9                   	leave  
  801799:	c3                   	ret    

0080179a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80179d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	52                   	push   %edx
  8017aa:	50                   	push   %eax
  8017ab:	6a 05                	push   $0x5
  8017ad:	e8 7b ff ff ff       	call   80172d <syscall>
  8017b2:	83 c4 18             	add    $0x18,%esp
}
  8017b5:	c9                   	leave  
  8017b6:	c3                   	ret    

008017b7 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
  8017ba:	56                   	push   %esi
  8017bb:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017bc:	8b 75 18             	mov    0x18(%ebp),%esi
  8017bf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017c2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cb:	56                   	push   %esi
  8017cc:	53                   	push   %ebx
  8017cd:	51                   	push   %ecx
  8017ce:	52                   	push   %edx
  8017cf:	50                   	push   %eax
  8017d0:	6a 06                	push   $0x6
  8017d2:	e8 56 ff ff ff       	call   80172d <syscall>
  8017d7:	83 c4 18             	add    $0x18,%esp
}
  8017da:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017dd:	5b                   	pop    %ebx
  8017de:	5e                   	pop    %esi
  8017df:	5d                   	pop    %ebp
  8017e0:	c3                   	ret    

008017e1 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8017e1:	55                   	push   %ebp
  8017e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8017e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	52                   	push   %edx
  8017f1:	50                   	push   %eax
  8017f2:	6a 07                	push   $0x7
  8017f4:	e8 34 ff ff ff       	call   80172d <syscall>
  8017f9:	83 c4 18             	add    $0x18,%esp
}
  8017fc:	c9                   	leave  
  8017fd:	c3                   	ret    

008017fe <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	ff 75 0c             	pushl  0xc(%ebp)
  80180a:	ff 75 08             	pushl  0x8(%ebp)
  80180d:	6a 08                	push   $0x8
  80180f:	e8 19 ff ff ff       	call   80172d <syscall>
  801814:	83 c4 18             	add    $0x18,%esp
}
  801817:	c9                   	leave  
  801818:	c3                   	ret    

00801819 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801819:	55                   	push   %ebp
  80181a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	6a 09                	push   $0x9
  801828:	e8 00 ff ff ff       	call   80172d <syscall>
  80182d:	83 c4 18             	add    $0x18,%esp
}
  801830:	c9                   	leave  
  801831:	c3                   	ret    

00801832 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	6a 0a                	push   $0xa
  801841:	e8 e7 fe ff ff       	call   80172d <syscall>
  801846:	83 c4 18             	add    $0x18,%esp
}
  801849:	c9                   	leave  
  80184a:	c3                   	ret    

0080184b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80184b:	55                   	push   %ebp
  80184c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	6a 0b                	push   $0xb
  80185a:	e8 ce fe ff ff       	call   80172d <syscall>
  80185f:	83 c4 18             	add    $0x18,%esp
}
  801862:	c9                   	leave  
  801863:	c3                   	ret    

00801864 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801864:	55                   	push   %ebp
  801865:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	ff 75 0c             	pushl  0xc(%ebp)
  801870:	ff 75 08             	pushl  0x8(%ebp)
  801873:	6a 0f                	push   $0xf
  801875:	e8 b3 fe ff ff       	call   80172d <syscall>
  80187a:	83 c4 18             	add    $0x18,%esp
	return;
  80187d:	90                   	nop
}
  80187e:	c9                   	leave  
  80187f:	c3                   	ret    

00801880 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	ff 75 0c             	pushl  0xc(%ebp)
  80188c:	ff 75 08             	pushl  0x8(%ebp)
  80188f:	6a 10                	push   $0x10
  801891:	e8 97 fe ff ff       	call   80172d <syscall>
  801896:	83 c4 18             	add    $0x18,%esp
	return ;
  801899:	90                   	nop
}
  80189a:	c9                   	leave  
  80189b:	c3                   	ret    

0080189c <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	ff 75 10             	pushl  0x10(%ebp)
  8018a6:	ff 75 0c             	pushl  0xc(%ebp)
  8018a9:	ff 75 08             	pushl  0x8(%ebp)
  8018ac:	6a 11                	push   $0x11
  8018ae:	e8 7a fe ff ff       	call   80172d <syscall>
  8018b3:	83 c4 18             	add    $0x18,%esp
	return ;
  8018b6:	90                   	nop
}
  8018b7:	c9                   	leave  
  8018b8:	c3                   	ret    

008018b9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 0c                	push   $0xc
  8018c8:	e8 60 fe ff ff       	call   80172d <syscall>
  8018cd:	83 c4 18             	add    $0x18,%esp
}
  8018d0:	c9                   	leave  
  8018d1:	c3                   	ret    

008018d2 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8018d2:	55                   	push   %ebp
  8018d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	ff 75 08             	pushl  0x8(%ebp)
  8018e0:	6a 0d                	push   $0xd
  8018e2:	e8 46 fe ff ff       	call   80172d <syscall>
  8018e7:	83 c4 18             	add    $0x18,%esp
}
  8018ea:	c9                   	leave  
  8018eb:	c3                   	ret    

008018ec <sys_scarce_memory>:

void sys_scarce_memory()
{
  8018ec:	55                   	push   %ebp
  8018ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 0e                	push   $0xe
  8018fb:	e8 2d fe ff ff       	call   80172d <syscall>
  801900:	83 c4 18             	add    $0x18,%esp
}
  801903:	90                   	nop
  801904:	c9                   	leave  
  801905:	c3                   	ret    

00801906 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 13                	push   $0x13
  801915:	e8 13 fe ff ff       	call   80172d <syscall>
  80191a:	83 c4 18             	add    $0x18,%esp
}
  80191d:	90                   	nop
  80191e:	c9                   	leave  
  80191f:	c3                   	ret    

00801920 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 14                	push   $0x14
  80192f:	e8 f9 fd ff ff       	call   80172d <syscall>
  801934:	83 c4 18             	add    $0x18,%esp
}
  801937:	90                   	nop
  801938:	c9                   	leave  
  801939:	c3                   	ret    

0080193a <sys_cputc>:


void
sys_cputc(const char c)
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
  80193d:	83 ec 04             	sub    $0x4,%esp
  801940:	8b 45 08             	mov    0x8(%ebp),%eax
  801943:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801946:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	50                   	push   %eax
  801953:	6a 15                	push   $0x15
  801955:	e8 d3 fd ff ff       	call   80172d <syscall>
  80195a:	83 c4 18             	add    $0x18,%esp
}
  80195d:	90                   	nop
  80195e:	c9                   	leave  
  80195f:	c3                   	ret    

00801960 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 16                	push   $0x16
  80196f:	e8 b9 fd ff ff       	call   80172d <syscall>
  801974:	83 c4 18             	add    $0x18,%esp
}
  801977:	90                   	nop
  801978:	c9                   	leave  
  801979:	c3                   	ret    

0080197a <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80197a:	55                   	push   %ebp
  80197b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80197d:	8b 45 08             	mov    0x8(%ebp),%eax
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	ff 75 0c             	pushl  0xc(%ebp)
  801989:	50                   	push   %eax
  80198a:	6a 17                	push   $0x17
  80198c:	e8 9c fd ff ff       	call   80172d <syscall>
  801991:	83 c4 18             	add    $0x18,%esp
}
  801994:	c9                   	leave  
  801995:	c3                   	ret    

00801996 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801999:	8b 55 0c             	mov    0xc(%ebp),%edx
  80199c:	8b 45 08             	mov    0x8(%ebp),%eax
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	52                   	push   %edx
  8019a6:	50                   	push   %eax
  8019a7:	6a 1a                	push   $0x1a
  8019a9:	e8 7f fd ff ff       	call   80172d <syscall>
  8019ae:	83 c4 18             	add    $0x18,%esp
}
  8019b1:	c9                   	leave  
  8019b2:	c3                   	ret    

008019b3 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019b3:	55                   	push   %ebp
  8019b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	52                   	push   %edx
  8019c3:	50                   	push   %eax
  8019c4:	6a 18                	push   $0x18
  8019c6:	e8 62 fd ff ff       	call   80172d <syscall>
  8019cb:	83 c4 18             	add    $0x18,%esp
}
  8019ce:	90                   	nop
  8019cf:	c9                   	leave  
  8019d0:	c3                   	ret    

008019d1 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019d1:	55                   	push   %ebp
  8019d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	52                   	push   %edx
  8019e1:	50                   	push   %eax
  8019e2:	6a 19                	push   $0x19
  8019e4:	e8 44 fd ff ff       	call   80172d <syscall>
  8019e9:	83 c4 18             	add    $0x18,%esp
}
  8019ec:	90                   	nop
  8019ed:	c9                   	leave  
  8019ee:	c3                   	ret    

008019ef <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019ef:	55                   	push   %ebp
  8019f0:	89 e5                	mov    %esp,%ebp
  8019f2:	83 ec 04             	sub    $0x4,%esp
  8019f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019fb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019fe:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a02:	8b 45 08             	mov    0x8(%ebp),%eax
  801a05:	6a 00                	push   $0x0
  801a07:	51                   	push   %ecx
  801a08:	52                   	push   %edx
  801a09:	ff 75 0c             	pushl  0xc(%ebp)
  801a0c:	50                   	push   %eax
  801a0d:	6a 1b                	push   $0x1b
  801a0f:	e8 19 fd ff ff       	call   80172d <syscall>
  801a14:	83 c4 18             	add    $0x18,%esp
}
  801a17:	c9                   	leave  
  801a18:	c3                   	ret    

00801a19 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a19:	55                   	push   %ebp
  801a1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	52                   	push   %edx
  801a29:	50                   	push   %eax
  801a2a:	6a 1c                	push   $0x1c
  801a2c:	e8 fc fc ff ff       	call   80172d <syscall>
  801a31:	83 c4 18             	add    $0x18,%esp
}
  801a34:	c9                   	leave  
  801a35:	c3                   	ret    

00801a36 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a39:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	51                   	push   %ecx
  801a47:	52                   	push   %edx
  801a48:	50                   	push   %eax
  801a49:	6a 1d                	push   $0x1d
  801a4b:	e8 dd fc ff ff       	call   80172d <syscall>
  801a50:	83 c4 18             	add    $0x18,%esp
}
  801a53:	c9                   	leave  
  801a54:	c3                   	ret    

00801a55 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a58:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	52                   	push   %edx
  801a65:	50                   	push   %eax
  801a66:	6a 1e                	push   $0x1e
  801a68:	e8 c0 fc ff ff       	call   80172d <syscall>
  801a6d:	83 c4 18             	add    $0x18,%esp
}
  801a70:	c9                   	leave  
  801a71:	c3                   	ret    

00801a72 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 1f                	push   $0x1f
  801a81:	e8 a7 fc ff ff       	call   80172d <syscall>
  801a86:	83 c4 18             	add    $0x18,%esp
}
  801a89:	c9                   	leave  
  801a8a:	c3                   	ret    

00801a8b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a8b:	55                   	push   %ebp
  801a8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a91:	6a 00                	push   $0x0
  801a93:	ff 75 14             	pushl  0x14(%ebp)
  801a96:	ff 75 10             	pushl  0x10(%ebp)
  801a99:	ff 75 0c             	pushl  0xc(%ebp)
  801a9c:	50                   	push   %eax
  801a9d:	6a 20                	push   $0x20
  801a9f:	e8 89 fc ff ff       	call   80172d <syscall>
  801aa4:	83 c4 18             	add    $0x18,%esp
}
  801aa7:	c9                   	leave  
  801aa8:	c3                   	ret    

00801aa9 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801aa9:	55                   	push   %ebp
  801aaa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801aac:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	50                   	push   %eax
  801ab8:	6a 21                	push   $0x21
  801aba:	e8 6e fc ff ff       	call   80172d <syscall>
  801abf:	83 c4 18             	add    $0x18,%esp
}
  801ac2:	90                   	nop
  801ac3:	c9                   	leave  
  801ac4:	c3                   	ret    

00801ac5 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ac5:	55                   	push   %ebp
  801ac6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	50                   	push   %eax
  801ad4:	6a 22                	push   $0x22
  801ad6:	e8 52 fc ff ff       	call   80172d <syscall>
  801adb:	83 c4 18             	add    $0x18,%esp
}
  801ade:	c9                   	leave  
  801adf:	c3                   	ret    

00801ae0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 02                	push   $0x2
  801aef:	e8 39 fc ff ff       	call   80172d <syscall>
  801af4:	83 c4 18             	add    $0x18,%esp
}
  801af7:	c9                   	leave  
  801af8:	c3                   	ret    

00801af9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801af9:	55                   	push   %ebp
  801afa:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 03                	push   $0x3
  801b08:	e8 20 fc ff ff       	call   80172d <syscall>
  801b0d:	83 c4 18             	add    $0x18,%esp
}
  801b10:	c9                   	leave  
  801b11:	c3                   	ret    

00801b12 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b12:	55                   	push   %ebp
  801b13:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 04                	push   $0x4
  801b21:	e8 07 fc ff ff       	call   80172d <syscall>
  801b26:	83 c4 18             	add    $0x18,%esp
}
  801b29:	c9                   	leave  
  801b2a:	c3                   	ret    

00801b2b <sys_exit_env>:


void sys_exit_env(void)
{
  801b2b:	55                   	push   %ebp
  801b2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 23                	push   $0x23
  801b3a:	e8 ee fb ff ff       	call   80172d <syscall>
  801b3f:	83 c4 18             	add    $0x18,%esp
}
  801b42:	90                   	nop
  801b43:	c9                   	leave  
  801b44:	c3                   	ret    

00801b45 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
  801b48:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b4b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b4e:	8d 50 04             	lea    0x4(%eax),%edx
  801b51:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	52                   	push   %edx
  801b5b:	50                   	push   %eax
  801b5c:	6a 24                	push   $0x24
  801b5e:	e8 ca fb ff ff       	call   80172d <syscall>
  801b63:	83 c4 18             	add    $0x18,%esp
	return result;
  801b66:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b69:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b6c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b6f:	89 01                	mov    %eax,(%ecx)
  801b71:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b74:	8b 45 08             	mov    0x8(%ebp),%eax
  801b77:	c9                   	leave  
  801b78:	c2 04 00             	ret    $0x4

00801b7b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b7b:	55                   	push   %ebp
  801b7c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	ff 75 10             	pushl  0x10(%ebp)
  801b85:	ff 75 0c             	pushl  0xc(%ebp)
  801b88:	ff 75 08             	pushl  0x8(%ebp)
  801b8b:	6a 12                	push   $0x12
  801b8d:	e8 9b fb ff ff       	call   80172d <syscall>
  801b92:	83 c4 18             	add    $0x18,%esp
	return ;
  801b95:	90                   	nop
}
  801b96:	c9                   	leave  
  801b97:	c3                   	ret    

00801b98 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b98:	55                   	push   %ebp
  801b99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 25                	push   $0x25
  801ba7:	e8 81 fb ff ff       	call   80172d <syscall>
  801bac:	83 c4 18             	add    $0x18,%esp
}
  801baf:	c9                   	leave  
  801bb0:	c3                   	ret    

00801bb1 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801bb1:	55                   	push   %ebp
  801bb2:	89 e5                	mov    %esp,%ebp
  801bb4:	83 ec 04             	sub    $0x4,%esp
  801bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bba:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bbd:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	50                   	push   %eax
  801bca:	6a 26                	push   $0x26
  801bcc:	e8 5c fb ff ff       	call   80172d <syscall>
  801bd1:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd4:	90                   	nop
}
  801bd5:	c9                   	leave  
  801bd6:	c3                   	ret    

00801bd7 <rsttst>:
void rsttst()
{
  801bd7:	55                   	push   %ebp
  801bd8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 28                	push   $0x28
  801be6:	e8 42 fb ff ff       	call   80172d <syscall>
  801beb:	83 c4 18             	add    $0x18,%esp
	return ;
  801bee:	90                   	nop
}
  801bef:	c9                   	leave  
  801bf0:	c3                   	ret    

00801bf1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
  801bf4:	83 ec 04             	sub    $0x4,%esp
  801bf7:	8b 45 14             	mov    0x14(%ebp),%eax
  801bfa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801bfd:	8b 55 18             	mov    0x18(%ebp),%edx
  801c00:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c04:	52                   	push   %edx
  801c05:	50                   	push   %eax
  801c06:	ff 75 10             	pushl  0x10(%ebp)
  801c09:	ff 75 0c             	pushl  0xc(%ebp)
  801c0c:	ff 75 08             	pushl  0x8(%ebp)
  801c0f:	6a 27                	push   $0x27
  801c11:	e8 17 fb ff ff       	call   80172d <syscall>
  801c16:	83 c4 18             	add    $0x18,%esp
	return ;
  801c19:	90                   	nop
}
  801c1a:	c9                   	leave  
  801c1b:	c3                   	ret    

00801c1c <chktst>:
void chktst(uint32 n)
{
  801c1c:	55                   	push   %ebp
  801c1d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	ff 75 08             	pushl  0x8(%ebp)
  801c2a:	6a 29                	push   $0x29
  801c2c:	e8 fc fa ff ff       	call   80172d <syscall>
  801c31:	83 c4 18             	add    $0x18,%esp
	return ;
  801c34:	90                   	nop
}
  801c35:	c9                   	leave  
  801c36:	c3                   	ret    

00801c37 <inctst>:

void inctst()
{
  801c37:	55                   	push   %ebp
  801c38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 2a                	push   $0x2a
  801c46:	e8 e2 fa ff ff       	call   80172d <syscall>
  801c4b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c4e:	90                   	nop
}
  801c4f:	c9                   	leave  
  801c50:	c3                   	ret    

00801c51 <gettst>:
uint32 gettst()
{
  801c51:	55                   	push   %ebp
  801c52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 2b                	push   $0x2b
  801c60:	e8 c8 fa ff ff       	call   80172d <syscall>
  801c65:	83 c4 18             	add    $0x18,%esp
}
  801c68:	c9                   	leave  
  801c69:	c3                   	ret    

00801c6a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c6a:	55                   	push   %ebp
  801c6b:	89 e5                	mov    %esp,%ebp
  801c6d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 2c                	push   $0x2c
  801c7c:	e8 ac fa ff ff       	call   80172d <syscall>
  801c81:	83 c4 18             	add    $0x18,%esp
  801c84:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c87:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c8b:	75 07                	jne    801c94 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c8d:	b8 01 00 00 00       	mov    $0x1,%eax
  801c92:	eb 05                	jmp    801c99 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c99:	c9                   	leave  
  801c9a:	c3                   	ret    

00801c9b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
  801c9e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 2c                	push   $0x2c
  801cad:	e8 7b fa ff ff       	call   80172d <syscall>
  801cb2:	83 c4 18             	add    $0x18,%esp
  801cb5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801cb8:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801cbc:	75 07                	jne    801cc5 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801cbe:	b8 01 00 00 00       	mov    $0x1,%eax
  801cc3:	eb 05                	jmp    801cca <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801cc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cca:	c9                   	leave  
  801ccb:	c3                   	ret    

00801ccc <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ccc:	55                   	push   %ebp
  801ccd:	89 e5                	mov    %esp,%ebp
  801ccf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 2c                	push   $0x2c
  801cde:	e8 4a fa ff ff       	call   80172d <syscall>
  801ce3:	83 c4 18             	add    $0x18,%esp
  801ce6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ce9:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ced:	75 07                	jne    801cf6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801cef:	b8 01 00 00 00       	mov    $0x1,%eax
  801cf4:	eb 05                	jmp    801cfb <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801cf6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cfb:	c9                   	leave  
  801cfc:	c3                   	ret    

00801cfd <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801cfd:	55                   	push   %ebp
  801cfe:	89 e5                	mov    %esp,%ebp
  801d00:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 2c                	push   $0x2c
  801d0f:	e8 19 fa ff ff       	call   80172d <syscall>
  801d14:	83 c4 18             	add    $0x18,%esp
  801d17:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d1a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d1e:	75 07                	jne    801d27 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d20:	b8 01 00 00 00       	mov    $0x1,%eax
  801d25:	eb 05                	jmp    801d2c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d2c:	c9                   	leave  
  801d2d:	c3                   	ret    

00801d2e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	ff 75 08             	pushl  0x8(%ebp)
  801d3c:	6a 2d                	push   $0x2d
  801d3e:	e8 ea f9 ff ff       	call   80172d <syscall>
  801d43:	83 c4 18             	add    $0x18,%esp
	return ;
  801d46:	90                   	nop
}
  801d47:	c9                   	leave  
  801d48:	c3                   	ret    

00801d49 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d49:	55                   	push   %ebp
  801d4a:	89 e5                	mov    %esp,%ebp
  801d4c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d4d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d50:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d53:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d56:	8b 45 08             	mov    0x8(%ebp),%eax
  801d59:	6a 00                	push   $0x0
  801d5b:	53                   	push   %ebx
  801d5c:	51                   	push   %ecx
  801d5d:	52                   	push   %edx
  801d5e:	50                   	push   %eax
  801d5f:	6a 2e                	push   $0x2e
  801d61:	e8 c7 f9 ff ff       	call   80172d <syscall>
  801d66:	83 c4 18             	add    $0x18,%esp
}
  801d69:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d6c:	c9                   	leave  
  801d6d:	c3                   	ret    

00801d6e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d6e:	55                   	push   %ebp
  801d6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d71:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d74:	8b 45 08             	mov    0x8(%ebp),%eax
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	52                   	push   %edx
  801d7e:	50                   	push   %eax
  801d7f:	6a 2f                	push   $0x2f
  801d81:	e8 a7 f9 ff ff       	call   80172d <syscall>
  801d86:	83 c4 18             	add    $0x18,%esp
}
  801d89:	c9                   	leave  
  801d8a:	c3                   	ret    
  801d8b:	90                   	nop

00801d8c <__udivdi3>:
  801d8c:	55                   	push   %ebp
  801d8d:	57                   	push   %edi
  801d8e:	56                   	push   %esi
  801d8f:	53                   	push   %ebx
  801d90:	83 ec 1c             	sub    $0x1c,%esp
  801d93:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801d97:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801d9b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d9f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801da3:	89 ca                	mov    %ecx,%edx
  801da5:	89 f8                	mov    %edi,%eax
  801da7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801dab:	85 f6                	test   %esi,%esi
  801dad:	75 2d                	jne    801ddc <__udivdi3+0x50>
  801daf:	39 cf                	cmp    %ecx,%edi
  801db1:	77 65                	ja     801e18 <__udivdi3+0x8c>
  801db3:	89 fd                	mov    %edi,%ebp
  801db5:	85 ff                	test   %edi,%edi
  801db7:	75 0b                	jne    801dc4 <__udivdi3+0x38>
  801db9:	b8 01 00 00 00       	mov    $0x1,%eax
  801dbe:	31 d2                	xor    %edx,%edx
  801dc0:	f7 f7                	div    %edi
  801dc2:	89 c5                	mov    %eax,%ebp
  801dc4:	31 d2                	xor    %edx,%edx
  801dc6:	89 c8                	mov    %ecx,%eax
  801dc8:	f7 f5                	div    %ebp
  801dca:	89 c1                	mov    %eax,%ecx
  801dcc:	89 d8                	mov    %ebx,%eax
  801dce:	f7 f5                	div    %ebp
  801dd0:	89 cf                	mov    %ecx,%edi
  801dd2:	89 fa                	mov    %edi,%edx
  801dd4:	83 c4 1c             	add    $0x1c,%esp
  801dd7:	5b                   	pop    %ebx
  801dd8:	5e                   	pop    %esi
  801dd9:	5f                   	pop    %edi
  801dda:	5d                   	pop    %ebp
  801ddb:	c3                   	ret    
  801ddc:	39 ce                	cmp    %ecx,%esi
  801dde:	77 28                	ja     801e08 <__udivdi3+0x7c>
  801de0:	0f bd fe             	bsr    %esi,%edi
  801de3:	83 f7 1f             	xor    $0x1f,%edi
  801de6:	75 40                	jne    801e28 <__udivdi3+0x9c>
  801de8:	39 ce                	cmp    %ecx,%esi
  801dea:	72 0a                	jb     801df6 <__udivdi3+0x6a>
  801dec:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801df0:	0f 87 9e 00 00 00    	ja     801e94 <__udivdi3+0x108>
  801df6:	b8 01 00 00 00       	mov    $0x1,%eax
  801dfb:	89 fa                	mov    %edi,%edx
  801dfd:	83 c4 1c             	add    $0x1c,%esp
  801e00:	5b                   	pop    %ebx
  801e01:	5e                   	pop    %esi
  801e02:	5f                   	pop    %edi
  801e03:	5d                   	pop    %ebp
  801e04:	c3                   	ret    
  801e05:	8d 76 00             	lea    0x0(%esi),%esi
  801e08:	31 ff                	xor    %edi,%edi
  801e0a:	31 c0                	xor    %eax,%eax
  801e0c:	89 fa                	mov    %edi,%edx
  801e0e:	83 c4 1c             	add    $0x1c,%esp
  801e11:	5b                   	pop    %ebx
  801e12:	5e                   	pop    %esi
  801e13:	5f                   	pop    %edi
  801e14:	5d                   	pop    %ebp
  801e15:	c3                   	ret    
  801e16:	66 90                	xchg   %ax,%ax
  801e18:	89 d8                	mov    %ebx,%eax
  801e1a:	f7 f7                	div    %edi
  801e1c:	31 ff                	xor    %edi,%edi
  801e1e:	89 fa                	mov    %edi,%edx
  801e20:	83 c4 1c             	add    $0x1c,%esp
  801e23:	5b                   	pop    %ebx
  801e24:	5e                   	pop    %esi
  801e25:	5f                   	pop    %edi
  801e26:	5d                   	pop    %ebp
  801e27:	c3                   	ret    
  801e28:	bd 20 00 00 00       	mov    $0x20,%ebp
  801e2d:	89 eb                	mov    %ebp,%ebx
  801e2f:	29 fb                	sub    %edi,%ebx
  801e31:	89 f9                	mov    %edi,%ecx
  801e33:	d3 e6                	shl    %cl,%esi
  801e35:	89 c5                	mov    %eax,%ebp
  801e37:	88 d9                	mov    %bl,%cl
  801e39:	d3 ed                	shr    %cl,%ebp
  801e3b:	89 e9                	mov    %ebp,%ecx
  801e3d:	09 f1                	or     %esi,%ecx
  801e3f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801e43:	89 f9                	mov    %edi,%ecx
  801e45:	d3 e0                	shl    %cl,%eax
  801e47:	89 c5                	mov    %eax,%ebp
  801e49:	89 d6                	mov    %edx,%esi
  801e4b:	88 d9                	mov    %bl,%cl
  801e4d:	d3 ee                	shr    %cl,%esi
  801e4f:	89 f9                	mov    %edi,%ecx
  801e51:	d3 e2                	shl    %cl,%edx
  801e53:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e57:	88 d9                	mov    %bl,%cl
  801e59:	d3 e8                	shr    %cl,%eax
  801e5b:	09 c2                	or     %eax,%edx
  801e5d:	89 d0                	mov    %edx,%eax
  801e5f:	89 f2                	mov    %esi,%edx
  801e61:	f7 74 24 0c          	divl   0xc(%esp)
  801e65:	89 d6                	mov    %edx,%esi
  801e67:	89 c3                	mov    %eax,%ebx
  801e69:	f7 e5                	mul    %ebp
  801e6b:	39 d6                	cmp    %edx,%esi
  801e6d:	72 19                	jb     801e88 <__udivdi3+0xfc>
  801e6f:	74 0b                	je     801e7c <__udivdi3+0xf0>
  801e71:	89 d8                	mov    %ebx,%eax
  801e73:	31 ff                	xor    %edi,%edi
  801e75:	e9 58 ff ff ff       	jmp    801dd2 <__udivdi3+0x46>
  801e7a:	66 90                	xchg   %ax,%ax
  801e7c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e80:	89 f9                	mov    %edi,%ecx
  801e82:	d3 e2                	shl    %cl,%edx
  801e84:	39 c2                	cmp    %eax,%edx
  801e86:	73 e9                	jae    801e71 <__udivdi3+0xe5>
  801e88:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801e8b:	31 ff                	xor    %edi,%edi
  801e8d:	e9 40 ff ff ff       	jmp    801dd2 <__udivdi3+0x46>
  801e92:	66 90                	xchg   %ax,%ax
  801e94:	31 c0                	xor    %eax,%eax
  801e96:	e9 37 ff ff ff       	jmp    801dd2 <__udivdi3+0x46>
  801e9b:	90                   	nop

00801e9c <__umoddi3>:
  801e9c:	55                   	push   %ebp
  801e9d:	57                   	push   %edi
  801e9e:	56                   	push   %esi
  801e9f:	53                   	push   %ebx
  801ea0:	83 ec 1c             	sub    $0x1c,%esp
  801ea3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801ea7:	8b 74 24 34          	mov    0x34(%esp),%esi
  801eab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801eaf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801eb3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801eb7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ebb:	89 f3                	mov    %esi,%ebx
  801ebd:	89 fa                	mov    %edi,%edx
  801ebf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ec3:	89 34 24             	mov    %esi,(%esp)
  801ec6:	85 c0                	test   %eax,%eax
  801ec8:	75 1a                	jne    801ee4 <__umoddi3+0x48>
  801eca:	39 f7                	cmp    %esi,%edi
  801ecc:	0f 86 a2 00 00 00    	jbe    801f74 <__umoddi3+0xd8>
  801ed2:	89 c8                	mov    %ecx,%eax
  801ed4:	89 f2                	mov    %esi,%edx
  801ed6:	f7 f7                	div    %edi
  801ed8:	89 d0                	mov    %edx,%eax
  801eda:	31 d2                	xor    %edx,%edx
  801edc:	83 c4 1c             	add    $0x1c,%esp
  801edf:	5b                   	pop    %ebx
  801ee0:	5e                   	pop    %esi
  801ee1:	5f                   	pop    %edi
  801ee2:	5d                   	pop    %ebp
  801ee3:	c3                   	ret    
  801ee4:	39 f0                	cmp    %esi,%eax
  801ee6:	0f 87 ac 00 00 00    	ja     801f98 <__umoddi3+0xfc>
  801eec:	0f bd e8             	bsr    %eax,%ebp
  801eef:	83 f5 1f             	xor    $0x1f,%ebp
  801ef2:	0f 84 ac 00 00 00    	je     801fa4 <__umoddi3+0x108>
  801ef8:	bf 20 00 00 00       	mov    $0x20,%edi
  801efd:	29 ef                	sub    %ebp,%edi
  801eff:	89 fe                	mov    %edi,%esi
  801f01:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801f05:	89 e9                	mov    %ebp,%ecx
  801f07:	d3 e0                	shl    %cl,%eax
  801f09:	89 d7                	mov    %edx,%edi
  801f0b:	89 f1                	mov    %esi,%ecx
  801f0d:	d3 ef                	shr    %cl,%edi
  801f0f:	09 c7                	or     %eax,%edi
  801f11:	89 e9                	mov    %ebp,%ecx
  801f13:	d3 e2                	shl    %cl,%edx
  801f15:	89 14 24             	mov    %edx,(%esp)
  801f18:	89 d8                	mov    %ebx,%eax
  801f1a:	d3 e0                	shl    %cl,%eax
  801f1c:	89 c2                	mov    %eax,%edx
  801f1e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f22:	d3 e0                	shl    %cl,%eax
  801f24:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f28:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f2c:	89 f1                	mov    %esi,%ecx
  801f2e:	d3 e8                	shr    %cl,%eax
  801f30:	09 d0                	or     %edx,%eax
  801f32:	d3 eb                	shr    %cl,%ebx
  801f34:	89 da                	mov    %ebx,%edx
  801f36:	f7 f7                	div    %edi
  801f38:	89 d3                	mov    %edx,%ebx
  801f3a:	f7 24 24             	mull   (%esp)
  801f3d:	89 c6                	mov    %eax,%esi
  801f3f:	89 d1                	mov    %edx,%ecx
  801f41:	39 d3                	cmp    %edx,%ebx
  801f43:	0f 82 87 00 00 00    	jb     801fd0 <__umoddi3+0x134>
  801f49:	0f 84 91 00 00 00    	je     801fe0 <__umoddi3+0x144>
  801f4f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801f53:	29 f2                	sub    %esi,%edx
  801f55:	19 cb                	sbb    %ecx,%ebx
  801f57:	89 d8                	mov    %ebx,%eax
  801f59:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801f5d:	d3 e0                	shl    %cl,%eax
  801f5f:	89 e9                	mov    %ebp,%ecx
  801f61:	d3 ea                	shr    %cl,%edx
  801f63:	09 d0                	or     %edx,%eax
  801f65:	89 e9                	mov    %ebp,%ecx
  801f67:	d3 eb                	shr    %cl,%ebx
  801f69:	89 da                	mov    %ebx,%edx
  801f6b:	83 c4 1c             	add    $0x1c,%esp
  801f6e:	5b                   	pop    %ebx
  801f6f:	5e                   	pop    %esi
  801f70:	5f                   	pop    %edi
  801f71:	5d                   	pop    %ebp
  801f72:	c3                   	ret    
  801f73:	90                   	nop
  801f74:	89 fd                	mov    %edi,%ebp
  801f76:	85 ff                	test   %edi,%edi
  801f78:	75 0b                	jne    801f85 <__umoddi3+0xe9>
  801f7a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f7f:	31 d2                	xor    %edx,%edx
  801f81:	f7 f7                	div    %edi
  801f83:	89 c5                	mov    %eax,%ebp
  801f85:	89 f0                	mov    %esi,%eax
  801f87:	31 d2                	xor    %edx,%edx
  801f89:	f7 f5                	div    %ebp
  801f8b:	89 c8                	mov    %ecx,%eax
  801f8d:	f7 f5                	div    %ebp
  801f8f:	89 d0                	mov    %edx,%eax
  801f91:	e9 44 ff ff ff       	jmp    801eda <__umoddi3+0x3e>
  801f96:	66 90                	xchg   %ax,%ax
  801f98:	89 c8                	mov    %ecx,%eax
  801f9a:	89 f2                	mov    %esi,%edx
  801f9c:	83 c4 1c             	add    $0x1c,%esp
  801f9f:	5b                   	pop    %ebx
  801fa0:	5e                   	pop    %esi
  801fa1:	5f                   	pop    %edi
  801fa2:	5d                   	pop    %ebp
  801fa3:	c3                   	ret    
  801fa4:	3b 04 24             	cmp    (%esp),%eax
  801fa7:	72 06                	jb     801faf <__umoddi3+0x113>
  801fa9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801fad:	77 0f                	ja     801fbe <__umoddi3+0x122>
  801faf:	89 f2                	mov    %esi,%edx
  801fb1:	29 f9                	sub    %edi,%ecx
  801fb3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801fb7:	89 14 24             	mov    %edx,(%esp)
  801fba:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801fbe:	8b 44 24 04          	mov    0x4(%esp),%eax
  801fc2:	8b 14 24             	mov    (%esp),%edx
  801fc5:	83 c4 1c             	add    $0x1c,%esp
  801fc8:	5b                   	pop    %ebx
  801fc9:	5e                   	pop    %esi
  801fca:	5f                   	pop    %edi
  801fcb:	5d                   	pop    %ebp
  801fcc:	c3                   	ret    
  801fcd:	8d 76 00             	lea    0x0(%esi),%esi
  801fd0:	2b 04 24             	sub    (%esp),%eax
  801fd3:	19 fa                	sbb    %edi,%edx
  801fd5:	89 d1                	mov    %edx,%ecx
  801fd7:	89 c6                	mov    %eax,%esi
  801fd9:	e9 71 ff ff ff       	jmp    801f4f <__umoddi3+0xb3>
  801fde:	66 90                	xchg   %ax,%ax
  801fe0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801fe4:	72 ea                	jb     801fd0 <__umoddi3+0x134>
  801fe6:	89 d9                	mov    %ebx,%ecx
  801fe8:	e9 62 ff ff ff       	jmp    801f4f <__umoddi3+0xb3>
