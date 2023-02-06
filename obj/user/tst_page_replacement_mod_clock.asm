
obj/user/tst_page_replacement_mod_clock:     file format elf32-i386


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
  800031:	e8 6d 05 00 00       	call   8005a3 <libmain>
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
  80003b:	83 ec 68             	sub    $0x68,%esp



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
  800060:	68 e0 1f 80 00       	push   $0x801fe0
  800065:	6a 15                	push   $0x15
  800067:	68 24 20 80 00       	push   $0x802024
  80006c:	e8 6e 06 00 00       	call   8006df <_panic>
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
  800096:	68 e0 1f 80 00       	push   $0x801fe0
  80009b:	6a 16                	push   $0x16
  80009d:	68 24 20 80 00       	push   $0x802024
  8000a2:	e8 38 06 00 00       	call   8006df <_panic>
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
  8000cc:	68 e0 1f 80 00       	push   $0x801fe0
  8000d1:	6a 17                	push   $0x17
  8000d3:	68 24 20 80 00       	push   $0x802024
  8000d8:	e8 02 06 00 00       	call   8006df <_panic>
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
  800102:	68 e0 1f 80 00       	push   $0x801fe0
  800107:	6a 18                	push   $0x18
  800109:	68 24 20 80 00       	push   $0x802024
  80010e:	e8 cc 05 00 00       	call   8006df <_panic>
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
  800138:	68 e0 1f 80 00       	push   $0x801fe0
  80013d:	6a 19                	push   $0x19
  80013f:	68 24 20 80 00       	push   $0x802024
  800144:	e8 96 05 00 00       	call   8006df <_panic>
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
  80016e:	68 e0 1f 80 00       	push   $0x801fe0
  800173:	6a 1a                	push   $0x1a
  800175:	68 24 20 80 00       	push   $0x802024
  80017a:	e8 60 05 00 00       	call   8006df <_panic>
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
  8001a6:	68 e0 1f 80 00       	push   $0x801fe0
  8001ab:	6a 1b                	push   $0x1b
  8001ad:	68 24 20 80 00       	push   $0x802024
  8001b2:	e8 28 05 00 00       	call   8006df <_panic>
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
  8001de:	68 e0 1f 80 00       	push   $0x801fe0
  8001e3:	6a 1c                	push   $0x1c
  8001e5:	68 24 20 80 00       	push   $0x802024
  8001ea:	e8 f0 04 00 00       	call   8006df <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=   0x802000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
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
  800216:	68 e0 1f 80 00       	push   $0x801fe0
  80021b:	6a 1d                	push   $0x1d
  80021d:	68 24 20 80 00       	push   $0x802024
  800222:	e8 b8 04 00 00       	call   8006df <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0x803000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
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
  80024e:	68 e0 1f 80 00       	push   $0x801fe0
  800253:	6a 1e                	push   $0x1e
  800255:	68 24 20 80 00       	push   $0x802024
  80025a:	e8 80 04 00 00       	call   8006df <_panic>
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
  800286:	68 e0 1f 80 00       	push   $0x801fe0
  80028b:	6a 1f                	push   $0x1f
  80028d:	68 24 20 80 00       	push   $0x802024
  800292:	e8 48 04 00 00       	call   8006df <_panic>
		if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
  800297:	a1 20 30 80 00       	mov    0x803020,%eax
  80029c:	8b 80 2c 05 00 00    	mov    0x52c(%eax),%eax
  8002a2:	85 c0                	test   %eax,%eax
  8002a4:	74 14                	je     8002ba <_main+0x282>
  8002a6:	83 ec 04             	sub    $0x4,%esp
  8002a9:	68 4c 20 80 00       	push   $0x80204c
  8002ae:	6a 20                	push   $0x20
  8002b0:	68 24 20 80 00       	push   $0x802024
  8002b5:	e8 25 04 00 00       	call   8006df <_panic>
	}

	//Reading (Not Modified)
	char garbage1 = arr[PAGE_SIZE*11-1] ;
  8002ba:	a0 5f e0 80 00       	mov    0x80e05f,%al
  8002bf:	88 45 c7             	mov    %al,-0x39(%ebp)
	char garbage2 = arr[PAGE_SIZE*12-1] ;
  8002c2:	a0 5f f0 80 00       	mov    0x80f05f,%al
  8002c7:	88 45 c6             	mov    %al,-0x3a(%ebp)

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8002ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8002d1:	eb 37                	jmp    80030a <_main+0x2d2>
	{
		arr[i] = -1 ;
  8002d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002d6:	05 60 30 80 00       	add    $0x803060,%eax
  8002db:	c6 00 ff             	movb   $0xff,(%eax)
		/*2016: this BUGGY line is REMOVED el7! it overwrites the KERNEL CODE :( !!!*/
		//*ptr = *ptr2 ;
		/*==========================================================================*/
		//always use pages at 0x801000 and 0x804000
		*ptr2 = *ptr ;
  8002de:	a1 04 30 80 00       	mov    0x803004,%eax
  8002e3:	8b 15 00 30 80 00    	mov    0x803000,%edx
  8002e9:	8a 12                	mov    (%edx),%dl
  8002eb:	88 10                	mov    %dl,(%eax)
		ptr++ ; ptr2++ ;
  8002ed:	a1 00 30 80 00       	mov    0x803000,%eax
  8002f2:	40                   	inc    %eax
  8002f3:	a3 00 30 80 00       	mov    %eax,0x803000
  8002f8:	a1 04 30 80 00       	mov    0x803004,%eax
  8002fd:	40                   	inc    %eax
  8002fe:	a3 04 30 80 00       	mov    %eax,0x803004
	char garbage1 = arr[PAGE_SIZE*11-1] ;
	char garbage2 = arr[PAGE_SIZE*12-1] ;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800303:	81 45 f4 00 08 00 00 	addl   $0x800,-0xc(%ebp)
  80030a:	81 7d f4 ff 9f 00 00 	cmpl   $0x9fff,-0xc(%ebp)
  800311:	7e c0                	jle    8002d3 <_main+0x29b>
		ptr++ ; ptr2++ ;
	}

	//===================
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=  0x809000)  panic("modified clock algo failed");
  800313:	a1 20 30 80 00       	mov    0x803020,%eax
  800318:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80031e:	8b 00                	mov    (%eax),%eax
  800320:	89 45 c0             	mov    %eax,-0x40(%ebp)
  800323:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800326:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80032b:	3d 00 90 80 00       	cmp    $0x809000,%eax
  800330:	74 14                	je     800346 <_main+0x30e>
  800332:	83 ec 04             	sub    $0x4,%esp
  800335:	68 92 20 80 00       	push   $0x802092
  80033a:	6a 36                	push   $0x36
  80033c:	68 24 20 80 00       	push   $0x802024
  800341:	e8 99 03 00 00       	call   8006df <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=  0x80a000)  panic("modified clock algo failed");
  800346:	a1 20 30 80 00       	mov    0x803020,%eax
  80034b:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800351:	83 c0 18             	add    $0x18,%eax
  800354:	8b 00                	mov    (%eax),%eax
  800356:	89 45 bc             	mov    %eax,-0x44(%ebp)
  800359:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80035c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800361:	3d 00 a0 80 00       	cmp    $0x80a000,%eax
  800366:	74 14                	je     80037c <_main+0x344>
  800368:	83 ec 04             	sub    $0x4,%esp
  80036b:	68 92 20 80 00       	push   $0x802092
  800370:	6a 37                	push   $0x37
  800372:	68 24 20 80 00       	push   $0x802024
  800377:	e8 63 03 00 00       	call   8006df <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=  0x804000)  panic("modified clock algo failed");
  80037c:	a1 20 30 80 00       	mov    0x803020,%eax
  800381:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800387:	83 c0 30             	add    $0x30,%eax
  80038a:	8b 00                	mov    (%eax),%eax
  80038c:	89 45 b8             	mov    %eax,-0x48(%ebp)
  80038f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800392:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800397:	3d 00 40 80 00       	cmp    $0x804000,%eax
  80039c:	74 14                	je     8003b2 <_main+0x37a>
  80039e:	83 ec 04             	sub    $0x4,%esp
  8003a1:	68 92 20 80 00       	push   $0x802092
  8003a6:	6a 38                	push   $0x38
  8003a8:	68 24 20 80 00       	push   $0x802024
  8003ad:	e8 2d 03 00 00       	call   8006df <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=  0x80b000)  panic("modified clock algo failed");
  8003b2:	a1 20 30 80 00       	mov    0x803020,%eax
  8003b7:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8003bd:	83 c0 48             	add    $0x48,%eax
  8003c0:	8b 00                	mov    (%eax),%eax
  8003c2:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8003c5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8003c8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003cd:	3d 00 b0 80 00       	cmp    $0x80b000,%eax
  8003d2:	74 14                	je     8003e8 <_main+0x3b0>
  8003d4:	83 ec 04             	sub    $0x4,%esp
  8003d7:	68 92 20 80 00       	push   $0x802092
  8003dc:	6a 39                	push   $0x39
  8003de:	68 24 20 80 00       	push   $0x802024
  8003e3:	e8 f7 02 00 00       	call   8006df <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=  0x80c000)  panic("modified clock algo failed");
  8003e8:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ed:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8003f3:	83 c0 60             	add    $0x60,%eax
  8003f6:	8b 00                	mov    (%eax),%eax
  8003f8:	89 45 b0             	mov    %eax,-0x50(%ebp)
  8003fb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8003fe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800403:	3d 00 c0 80 00       	cmp    $0x80c000,%eax
  800408:	74 14                	je     80041e <_main+0x3e6>
  80040a:	83 ec 04             	sub    $0x4,%esp
  80040d:	68 92 20 80 00       	push   $0x802092
  800412:	6a 3a                	push   $0x3a
  800414:	68 24 20 80 00       	push   $0x802024
  800419:	e8 c1 02 00 00       	call   8006df <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=  0x807000)  panic("modified clock algo failed");
  80041e:	a1 20 30 80 00       	mov    0x803020,%eax
  800423:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800429:	83 c0 78             	add    $0x78,%eax
  80042c:	8b 00                	mov    (%eax),%eax
  80042e:	89 45 ac             	mov    %eax,-0x54(%ebp)
  800431:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800434:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800439:	3d 00 70 80 00       	cmp    $0x807000,%eax
  80043e:	74 14                	je     800454 <_main+0x41c>
  800440:	83 ec 04             	sub    $0x4,%esp
  800443:	68 92 20 80 00       	push   $0x802092
  800448:	6a 3b                	push   $0x3b
  80044a:	68 24 20 80 00       	push   $0x802024
  80044f:	e8 8b 02 00 00       	call   8006df <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=  0x800000)  panic("modified clock algo failed");
  800454:	a1 20 30 80 00       	mov    0x803020,%eax
  800459:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80045f:	05 90 00 00 00       	add    $0x90,%eax
  800464:	8b 00                	mov    (%eax),%eax
  800466:	89 45 a8             	mov    %eax,-0x58(%ebp)
  800469:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80046c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800471:	3d 00 00 80 00       	cmp    $0x800000,%eax
  800476:	74 14                	je     80048c <_main+0x454>
  800478:	83 ec 04             	sub    $0x4,%esp
  80047b:	68 92 20 80 00       	push   $0x802092
  800480:	6a 3c                	push   $0x3c
  800482:	68 24 20 80 00       	push   $0x802024
  800487:	e8 53 02 00 00       	call   8006df <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=  0x801000)  panic("modified clock algo failed");
  80048c:	a1 20 30 80 00       	mov    0x803020,%eax
  800491:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800497:	05 a8 00 00 00       	add    $0xa8,%eax
  80049c:	8b 00                	mov    (%eax),%eax
  80049e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  8004a1:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8004a4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004a9:	3d 00 10 80 00       	cmp    $0x801000,%eax
  8004ae:	74 14                	je     8004c4 <_main+0x48c>
  8004b0:	83 ec 04             	sub    $0x4,%esp
  8004b3:	68 92 20 80 00       	push   $0x802092
  8004b8:	6a 3d                	push   $0x3d
  8004ba:	68 24 20 80 00       	push   $0x802024
  8004bf:	e8 1b 02 00 00       	call   8006df <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=  0x808000)  panic("modified clock algo failed");
  8004c4:	a1 20 30 80 00       	mov    0x803020,%eax
  8004c9:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8004cf:	05 c0 00 00 00       	add    $0xc0,%eax
  8004d4:	8b 00                	mov    (%eax),%eax
  8004d6:	89 45 a0             	mov    %eax,-0x60(%ebp)
  8004d9:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8004dc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004e1:	3d 00 80 80 00       	cmp    $0x808000,%eax
  8004e6:	74 14                	je     8004fc <_main+0x4c4>
  8004e8:	83 ec 04             	sub    $0x4,%esp
  8004eb:	68 92 20 80 00       	push   $0x802092
  8004f0:	6a 3e                	push   $0x3e
  8004f2:	68 24 20 80 00       	push   $0x802024
  8004f7:	e8 e3 01 00 00       	call   8006df <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=  0x803000)  panic("modified clock algo failed");
  8004fc:	a1 20 30 80 00       	mov    0x803020,%eax
  800501:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800507:	05 d8 00 00 00       	add    $0xd8,%eax
  80050c:	8b 00                	mov    (%eax),%eax
  80050e:	89 45 9c             	mov    %eax,-0x64(%ebp)
  800511:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800514:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800519:	3d 00 30 80 00       	cmp    $0x803000,%eax
  80051e:	74 14                	je     800534 <_main+0x4fc>
  800520:	83 ec 04             	sub    $0x4,%esp
  800523:	68 92 20 80 00       	push   $0x802092
  800528:	6a 3f                	push   $0x3f
  80052a:	68 24 20 80 00       	push   $0x802024
  80052f:	e8 ab 01 00 00       	call   8006df <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[10].virtual_address,PAGE_SIZE) !=  0xeebfd000)  panic("modified clock algo failed");
  800534:	a1 20 30 80 00       	mov    0x803020,%eax
  800539:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80053f:	05 f0 00 00 00       	add    $0xf0,%eax
  800544:	8b 00                	mov    (%eax),%eax
  800546:	89 45 98             	mov    %eax,-0x68(%ebp)
  800549:	8b 45 98             	mov    -0x68(%ebp),%eax
  80054c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800551:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  800556:	74 14                	je     80056c <_main+0x534>
  800558:	83 ec 04             	sub    $0x4,%esp
  80055b:	68 92 20 80 00       	push   $0x802092
  800560:	6a 40                	push   $0x40
  800562:	68 24 20 80 00       	push   $0x802024
  800567:	e8 73 01 00 00       	call   8006df <_panic>

		if(myEnv->page_last_WS_index != 5) panic("wrong PAGE WS pointer location");
  80056c:	a1 20 30 80 00       	mov    0x803020,%eax
  800571:	8b 80 2c 05 00 00    	mov    0x52c(%eax),%eax
  800577:	83 f8 05             	cmp    $0x5,%eax
  80057a:	74 14                	je     800590 <_main+0x558>
  80057c:	83 ec 04             	sub    $0x4,%esp
  80057f:	68 b0 20 80 00       	push   $0x8020b0
  800584:	6a 42                	push   $0x42
  800586:	68 24 20 80 00       	push   $0x802024
  80058b:	e8 4f 01 00 00       	call   8006df <_panic>

	}

	cprintf("Congratulations!! test PAGE replacement [Modified CLOCK Alg.] is completed successfully.\n");
  800590:	83 ec 0c             	sub    $0xc,%esp
  800593:	68 d0 20 80 00       	push   $0x8020d0
  800598:	e8 f6 03 00 00       	call   800993 <cprintf>
  80059d:	83 c4 10             	add    $0x10,%esp
	return;
  8005a0:	90                   	nop
}
  8005a1:	c9                   	leave  
  8005a2:	c3                   	ret    

008005a3 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8005a3:	55                   	push   %ebp
  8005a4:	89 e5                	mov    %esp,%ebp
  8005a6:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8005a9:	e8 3b 15 00 00       	call   801ae9 <sys_getenvindex>
  8005ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8005b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005b4:	89 d0                	mov    %edx,%eax
  8005b6:	c1 e0 03             	shl    $0x3,%eax
  8005b9:	01 d0                	add    %edx,%eax
  8005bb:	01 c0                	add    %eax,%eax
  8005bd:	01 d0                	add    %edx,%eax
  8005bf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005c6:	01 d0                	add    %edx,%eax
  8005c8:	c1 e0 04             	shl    $0x4,%eax
  8005cb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005d0:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8005d5:	a1 20 30 80 00       	mov    0x803020,%eax
  8005da:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8005e0:	84 c0                	test   %al,%al
  8005e2:	74 0f                	je     8005f3 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8005e4:	a1 20 30 80 00       	mov    0x803020,%eax
  8005e9:	05 5c 05 00 00       	add    $0x55c,%eax
  8005ee:	a3 08 30 80 00       	mov    %eax,0x803008

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8005f7:	7e 0a                	jle    800603 <libmain+0x60>
		binaryname = argv[0];
  8005f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005fc:	8b 00                	mov    (%eax),%eax
  8005fe:	a3 08 30 80 00       	mov    %eax,0x803008

	// call user main routine
	_main(argc, argv);
  800603:	83 ec 08             	sub    $0x8,%esp
  800606:	ff 75 0c             	pushl  0xc(%ebp)
  800609:	ff 75 08             	pushl  0x8(%ebp)
  80060c:	e8 27 fa ff ff       	call   800038 <_main>
  800611:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800614:	e8 dd 12 00 00       	call   8018f6 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800619:	83 ec 0c             	sub    $0xc,%esp
  80061c:	68 44 21 80 00       	push   $0x802144
  800621:	e8 6d 03 00 00       	call   800993 <cprintf>
  800626:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800629:	a1 20 30 80 00       	mov    0x803020,%eax
  80062e:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800634:	a1 20 30 80 00       	mov    0x803020,%eax
  800639:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80063f:	83 ec 04             	sub    $0x4,%esp
  800642:	52                   	push   %edx
  800643:	50                   	push   %eax
  800644:	68 6c 21 80 00       	push   $0x80216c
  800649:	e8 45 03 00 00       	call   800993 <cprintf>
  80064e:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800651:	a1 20 30 80 00       	mov    0x803020,%eax
  800656:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80065c:	a1 20 30 80 00       	mov    0x803020,%eax
  800661:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800667:	a1 20 30 80 00       	mov    0x803020,%eax
  80066c:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800672:	51                   	push   %ecx
  800673:	52                   	push   %edx
  800674:	50                   	push   %eax
  800675:	68 94 21 80 00       	push   $0x802194
  80067a:	e8 14 03 00 00       	call   800993 <cprintf>
  80067f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800682:	a1 20 30 80 00       	mov    0x803020,%eax
  800687:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80068d:	83 ec 08             	sub    $0x8,%esp
  800690:	50                   	push   %eax
  800691:	68 ec 21 80 00       	push   $0x8021ec
  800696:	e8 f8 02 00 00       	call   800993 <cprintf>
  80069b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80069e:	83 ec 0c             	sub    $0xc,%esp
  8006a1:	68 44 21 80 00       	push   $0x802144
  8006a6:	e8 e8 02 00 00       	call   800993 <cprintf>
  8006ab:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006ae:	e8 5d 12 00 00       	call   801910 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8006b3:	e8 19 00 00 00       	call   8006d1 <exit>
}
  8006b8:	90                   	nop
  8006b9:	c9                   	leave  
  8006ba:	c3                   	ret    

008006bb <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8006bb:	55                   	push   %ebp
  8006bc:	89 e5                	mov    %esp,%ebp
  8006be:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8006c1:	83 ec 0c             	sub    $0xc,%esp
  8006c4:	6a 00                	push   $0x0
  8006c6:	e8 ea 13 00 00       	call   801ab5 <sys_destroy_env>
  8006cb:	83 c4 10             	add    $0x10,%esp
}
  8006ce:	90                   	nop
  8006cf:	c9                   	leave  
  8006d0:	c3                   	ret    

008006d1 <exit>:

void
exit(void)
{
  8006d1:	55                   	push   %ebp
  8006d2:	89 e5                	mov    %esp,%ebp
  8006d4:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8006d7:	e8 3f 14 00 00       	call   801b1b <sys_exit_env>
}
  8006dc:	90                   	nop
  8006dd:	c9                   	leave  
  8006de:	c3                   	ret    

008006df <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8006df:	55                   	push   %ebp
  8006e0:	89 e5                	mov    %esp,%ebp
  8006e2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8006e5:	8d 45 10             	lea    0x10(%ebp),%eax
  8006e8:	83 c0 04             	add    $0x4,%eax
  8006eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8006ee:	a1 5c f1 80 00       	mov    0x80f15c,%eax
  8006f3:	85 c0                	test   %eax,%eax
  8006f5:	74 16                	je     80070d <_panic+0x2e>
		cprintf("%s: ", argv0);
  8006f7:	a1 5c f1 80 00       	mov    0x80f15c,%eax
  8006fc:	83 ec 08             	sub    $0x8,%esp
  8006ff:	50                   	push   %eax
  800700:	68 00 22 80 00       	push   $0x802200
  800705:	e8 89 02 00 00       	call   800993 <cprintf>
  80070a:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80070d:	a1 08 30 80 00       	mov    0x803008,%eax
  800712:	ff 75 0c             	pushl  0xc(%ebp)
  800715:	ff 75 08             	pushl  0x8(%ebp)
  800718:	50                   	push   %eax
  800719:	68 05 22 80 00       	push   $0x802205
  80071e:	e8 70 02 00 00       	call   800993 <cprintf>
  800723:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800726:	8b 45 10             	mov    0x10(%ebp),%eax
  800729:	83 ec 08             	sub    $0x8,%esp
  80072c:	ff 75 f4             	pushl  -0xc(%ebp)
  80072f:	50                   	push   %eax
  800730:	e8 f3 01 00 00       	call   800928 <vcprintf>
  800735:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800738:	83 ec 08             	sub    $0x8,%esp
  80073b:	6a 00                	push   $0x0
  80073d:	68 21 22 80 00       	push   $0x802221
  800742:	e8 e1 01 00 00       	call   800928 <vcprintf>
  800747:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80074a:	e8 82 ff ff ff       	call   8006d1 <exit>

	// should not return here
	while (1) ;
  80074f:	eb fe                	jmp    80074f <_panic+0x70>

00800751 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800751:	55                   	push   %ebp
  800752:	89 e5                	mov    %esp,%ebp
  800754:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800757:	a1 20 30 80 00       	mov    0x803020,%eax
  80075c:	8b 50 74             	mov    0x74(%eax),%edx
  80075f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800762:	39 c2                	cmp    %eax,%edx
  800764:	74 14                	je     80077a <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800766:	83 ec 04             	sub    $0x4,%esp
  800769:	68 24 22 80 00       	push   $0x802224
  80076e:	6a 26                	push   $0x26
  800770:	68 70 22 80 00       	push   $0x802270
  800775:	e8 65 ff ff ff       	call   8006df <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80077a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800781:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800788:	e9 c2 00 00 00       	jmp    80084f <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80078d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800790:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800797:	8b 45 08             	mov    0x8(%ebp),%eax
  80079a:	01 d0                	add    %edx,%eax
  80079c:	8b 00                	mov    (%eax),%eax
  80079e:	85 c0                	test   %eax,%eax
  8007a0:	75 08                	jne    8007aa <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8007a2:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8007a5:	e9 a2 00 00 00       	jmp    80084c <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8007aa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007b1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8007b8:	eb 69                	jmp    800823 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8007ba:	a1 20 30 80 00       	mov    0x803020,%eax
  8007bf:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007c5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007c8:	89 d0                	mov    %edx,%eax
  8007ca:	01 c0                	add    %eax,%eax
  8007cc:	01 d0                	add    %edx,%eax
  8007ce:	c1 e0 03             	shl    $0x3,%eax
  8007d1:	01 c8                	add    %ecx,%eax
  8007d3:	8a 40 04             	mov    0x4(%eax),%al
  8007d6:	84 c0                	test   %al,%al
  8007d8:	75 46                	jne    800820 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007da:	a1 20 30 80 00       	mov    0x803020,%eax
  8007df:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007e5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007e8:	89 d0                	mov    %edx,%eax
  8007ea:	01 c0                	add    %eax,%eax
  8007ec:	01 d0                	add    %edx,%eax
  8007ee:	c1 e0 03             	shl    $0x3,%eax
  8007f1:	01 c8                	add    %ecx,%eax
  8007f3:	8b 00                	mov    (%eax),%eax
  8007f5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007fb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800800:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800802:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800805:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80080c:	8b 45 08             	mov    0x8(%ebp),%eax
  80080f:	01 c8                	add    %ecx,%eax
  800811:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800813:	39 c2                	cmp    %eax,%edx
  800815:	75 09                	jne    800820 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800817:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80081e:	eb 12                	jmp    800832 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800820:	ff 45 e8             	incl   -0x18(%ebp)
  800823:	a1 20 30 80 00       	mov    0x803020,%eax
  800828:	8b 50 74             	mov    0x74(%eax),%edx
  80082b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80082e:	39 c2                	cmp    %eax,%edx
  800830:	77 88                	ja     8007ba <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800832:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800836:	75 14                	jne    80084c <CheckWSWithoutLastIndex+0xfb>
			panic(
  800838:	83 ec 04             	sub    $0x4,%esp
  80083b:	68 7c 22 80 00       	push   $0x80227c
  800840:	6a 3a                	push   $0x3a
  800842:	68 70 22 80 00       	push   $0x802270
  800847:	e8 93 fe ff ff       	call   8006df <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80084c:	ff 45 f0             	incl   -0x10(%ebp)
  80084f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800852:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800855:	0f 8c 32 ff ff ff    	jl     80078d <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80085b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800862:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800869:	eb 26                	jmp    800891 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80086b:	a1 20 30 80 00       	mov    0x803020,%eax
  800870:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800876:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800879:	89 d0                	mov    %edx,%eax
  80087b:	01 c0                	add    %eax,%eax
  80087d:	01 d0                	add    %edx,%eax
  80087f:	c1 e0 03             	shl    $0x3,%eax
  800882:	01 c8                	add    %ecx,%eax
  800884:	8a 40 04             	mov    0x4(%eax),%al
  800887:	3c 01                	cmp    $0x1,%al
  800889:	75 03                	jne    80088e <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80088b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80088e:	ff 45 e0             	incl   -0x20(%ebp)
  800891:	a1 20 30 80 00       	mov    0x803020,%eax
  800896:	8b 50 74             	mov    0x74(%eax),%edx
  800899:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80089c:	39 c2                	cmp    %eax,%edx
  80089e:	77 cb                	ja     80086b <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8008a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008a3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8008a6:	74 14                	je     8008bc <CheckWSWithoutLastIndex+0x16b>
		panic(
  8008a8:	83 ec 04             	sub    $0x4,%esp
  8008ab:	68 d0 22 80 00       	push   $0x8022d0
  8008b0:	6a 44                	push   $0x44
  8008b2:	68 70 22 80 00       	push   $0x802270
  8008b7:	e8 23 fe ff ff       	call   8006df <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8008bc:	90                   	nop
  8008bd:	c9                   	leave  
  8008be:	c3                   	ret    

008008bf <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8008bf:	55                   	push   %ebp
  8008c0:	89 e5                	mov    %esp,%ebp
  8008c2:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8008c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c8:	8b 00                	mov    (%eax),%eax
  8008ca:	8d 48 01             	lea    0x1(%eax),%ecx
  8008cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008d0:	89 0a                	mov    %ecx,(%edx)
  8008d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8008d5:	88 d1                	mov    %dl,%cl
  8008d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008da:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8008de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e1:	8b 00                	mov    (%eax),%eax
  8008e3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8008e8:	75 2c                	jne    800916 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8008ea:	a0 24 30 80 00       	mov    0x803024,%al
  8008ef:	0f b6 c0             	movzbl %al,%eax
  8008f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008f5:	8b 12                	mov    (%edx),%edx
  8008f7:	89 d1                	mov    %edx,%ecx
  8008f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008fc:	83 c2 08             	add    $0x8,%edx
  8008ff:	83 ec 04             	sub    $0x4,%esp
  800902:	50                   	push   %eax
  800903:	51                   	push   %ecx
  800904:	52                   	push   %edx
  800905:	e8 3e 0e 00 00       	call   801748 <sys_cputs>
  80090a:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80090d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800910:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800916:	8b 45 0c             	mov    0xc(%ebp),%eax
  800919:	8b 40 04             	mov    0x4(%eax),%eax
  80091c:	8d 50 01             	lea    0x1(%eax),%edx
  80091f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800922:	89 50 04             	mov    %edx,0x4(%eax)
}
  800925:	90                   	nop
  800926:	c9                   	leave  
  800927:	c3                   	ret    

00800928 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800928:	55                   	push   %ebp
  800929:	89 e5                	mov    %esp,%ebp
  80092b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800931:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800938:	00 00 00 
	b.cnt = 0;
  80093b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800942:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800945:	ff 75 0c             	pushl  0xc(%ebp)
  800948:	ff 75 08             	pushl  0x8(%ebp)
  80094b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800951:	50                   	push   %eax
  800952:	68 bf 08 80 00       	push   $0x8008bf
  800957:	e8 11 02 00 00       	call   800b6d <vprintfmt>
  80095c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80095f:	a0 24 30 80 00       	mov    0x803024,%al
  800964:	0f b6 c0             	movzbl %al,%eax
  800967:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80096d:	83 ec 04             	sub    $0x4,%esp
  800970:	50                   	push   %eax
  800971:	52                   	push   %edx
  800972:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800978:	83 c0 08             	add    $0x8,%eax
  80097b:	50                   	push   %eax
  80097c:	e8 c7 0d 00 00       	call   801748 <sys_cputs>
  800981:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800984:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80098b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800991:	c9                   	leave  
  800992:	c3                   	ret    

00800993 <cprintf>:

int cprintf(const char *fmt, ...) {
  800993:	55                   	push   %ebp
  800994:	89 e5                	mov    %esp,%ebp
  800996:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800999:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8009a0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a9:	83 ec 08             	sub    $0x8,%esp
  8009ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8009af:	50                   	push   %eax
  8009b0:	e8 73 ff ff ff       	call   800928 <vcprintf>
  8009b5:	83 c4 10             	add    $0x10,%esp
  8009b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8009bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009be:	c9                   	leave  
  8009bf:	c3                   	ret    

008009c0 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8009c0:	55                   	push   %ebp
  8009c1:	89 e5                	mov    %esp,%ebp
  8009c3:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8009c6:	e8 2b 0f 00 00       	call   8018f6 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8009cb:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d4:	83 ec 08             	sub    $0x8,%esp
  8009d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8009da:	50                   	push   %eax
  8009db:	e8 48 ff ff ff       	call   800928 <vcprintf>
  8009e0:	83 c4 10             	add    $0x10,%esp
  8009e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8009e6:	e8 25 0f 00 00       	call   801910 <sys_enable_interrupt>
	return cnt;
  8009eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009ee:	c9                   	leave  
  8009ef:	c3                   	ret    

008009f0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8009f0:	55                   	push   %ebp
  8009f1:	89 e5                	mov    %esp,%ebp
  8009f3:	53                   	push   %ebx
  8009f4:	83 ec 14             	sub    $0x14,%esp
  8009f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8009fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800a00:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a03:	8b 45 18             	mov    0x18(%ebp),%eax
  800a06:	ba 00 00 00 00       	mov    $0x0,%edx
  800a0b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a0e:	77 55                	ja     800a65 <printnum+0x75>
  800a10:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a13:	72 05                	jb     800a1a <printnum+0x2a>
  800a15:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a18:	77 4b                	ja     800a65 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a1a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a1d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a20:	8b 45 18             	mov    0x18(%ebp),%eax
  800a23:	ba 00 00 00 00       	mov    $0x0,%edx
  800a28:	52                   	push   %edx
  800a29:	50                   	push   %eax
  800a2a:	ff 75 f4             	pushl  -0xc(%ebp)
  800a2d:	ff 75 f0             	pushl  -0x10(%ebp)
  800a30:	e8 47 13 00 00       	call   801d7c <__udivdi3>
  800a35:	83 c4 10             	add    $0x10,%esp
  800a38:	83 ec 04             	sub    $0x4,%esp
  800a3b:	ff 75 20             	pushl  0x20(%ebp)
  800a3e:	53                   	push   %ebx
  800a3f:	ff 75 18             	pushl  0x18(%ebp)
  800a42:	52                   	push   %edx
  800a43:	50                   	push   %eax
  800a44:	ff 75 0c             	pushl  0xc(%ebp)
  800a47:	ff 75 08             	pushl  0x8(%ebp)
  800a4a:	e8 a1 ff ff ff       	call   8009f0 <printnum>
  800a4f:	83 c4 20             	add    $0x20,%esp
  800a52:	eb 1a                	jmp    800a6e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a54:	83 ec 08             	sub    $0x8,%esp
  800a57:	ff 75 0c             	pushl  0xc(%ebp)
  800a5a:	ff 75 20             	pushl  0x20(%ebp)
  800a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a60:	ff d0                	call   *%eax
  800a62:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a65:	ff 4d 1c             	decl   0x1c(%ebp)
  800a68:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a6c:	7f e6                	jg     800a54 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a6e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a71:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a79:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a7c:	53                   	push   %ebx
  800a7d:	51                   	push   %ecx
  800a7e:	52                   	push   %edx
  800a7f:	50                   	push   %eax
  800a80:	e8 07 14 00 00       	call   801e8c <__umoddi3>
  800a85:	83 c4 10             	add    $0x10,%esp
  800a88:	05 34 25 80 00       	add    $0x802534,%eax
  800a8d:	8a 00                	mov    (%eax),%al
  800a8f:	0f be c0             	movsbl %al,%eax
  800a92:	83 ec 08             	sub    $0x8,%esp
  800a95:	ff 75 0c             	pushl  0xc(%ebp)
  800a98:	50                   	push   %eax
  800a99:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9c:	ff d0                	call   *%eax
  800a9e:	83 c4 10             	add    $0x10,%esp
}
  800aa1:	90                   	nop
  800aa2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800aa5:	c9                   	leave  
  800aa6:	c3                   	ret    

00800aa7 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800aa7:	55                   	push   %ebp
  800aa8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800aaa:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800aae:	7e 1c                	jle    800acc <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab3:	8b 00                	mov    (%eax),%eax
  800ab5:	8d 50 08             	lea    0x8(%eax),%edx
  800ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  800abb:	89 10                	mov    %edx,(%eax)
  800abd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac0:	8b 00                	mov    (%eax),%eax
  800ac2:	83 e8 08             	sub    $0x8,%eax
  800ac5:	8b 50 04             	mov    0x4(%eax),%edx
  800ac8:	8b 00                	mov    (%eax),%eax
  800aca:	eb 40                	jmp    800b0c <getuint+0x65>
	else if (lflag)
  800acc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ad0:	74 1e                	je     800af0 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad5:	8b 00                	mov    (%eax),%eax
  800ad7:	8d 50 04             	lea    0x4(%eax),%edx
  800ada:	8b 45 08             	mov    0x8(%ebp),%eax
  800add:	89 10                	mov    %edx,(%eax)
  800adf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae2:	8b 00                	mov    (%eax),%eax
  800ae4:	83 e8 04             	sub    $0x4,%eax
  800ae7:	8b 00                	mov    (%eax),%eax
  800ae9:	ba 00 00 00 00       	mov    $0x0,%edx
  800aee:	eb 1c                	jmp    800b0c <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800af0:	8b 45 08             	mov    0x8(%ebp),%eax
  800af3:	8b 00                	mov    (%eax),%eax
  800af5:	8d 50 04             	lea    0x4(%eax),%edx
  800af8:	8b 45 08             	mov    0x8(%ebp),%eax
  800afb:	89 10                	mov    %edx,(%eax)
  800afd:	8b 45 08             	mov    0x8(%ebp),%eax
  800b00:	8b 00                	mov    (%eax),%eax
  800b02:	83 e8 04             	sub    $0x4,%eax
  800b05:	8b 00                	mov    (%eax),%eax
  800b07:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b0c:	5d                   	pop    %ebp
  800b0d:	c3                   	ret    

00800b0e <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b0e:	55                   	push   %ebp
  800b0f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b11:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b15:	7e 1c                	jle    800b33 <getint+0x25>
		return va_arg(*ap, long long);
  800b17:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1a:	8b 00                	mov    (%eax),%eax
  800b1c:	8d 50 08             	lea    0x8(%eax),%edx
  800b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b22:	89 10                	mov    %edx,(%eax)
  800b24:	8b 45 08             	mov    0x8(%ebp),%eax
  800b27:	8b 00                	mov    (%eax),%eax
  800b29:	83 e8 08             	sub    $0x8,%eax
  800b2c:	8b 50 04             	mov    0x4(%eax),%edx
  800b2f:	8b 00                	mov    (%eax),%eax
  800b31:	eb 38                	jmp    800b6b <getint+0x5d>
	else if (lflag)
  800b33:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b37:	74 1a                	je     800b53 <getint+0x45>
		return va_arg(*ap, long);
  800b39:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3c:	8b 00                	mov    (%eax),%eax
  800b3e:	8d 50 04             	lea    0x4(%eax),%edx
  800b41:	8b 45 08             	mov    0x8(%ebp),%eax
  800b44:	89 10                	mov    %edx,(%eax)
  800b46:	8b 45 08             	mov    0x8(%ebp),%eax
  800b49:	8b 00                	mov    (%eax),%eax
  800b4b:	83 e8 04             	sub    $0x4,%eax
  800b4e:	8b 00                	mov    (%eax),%eax
  800b50:	99                   	cltd   
  800b51:	eb 18                	jmp    800b6b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b53:	8b 45 08             	mov    0x8(%ebp),%eax
  800b56:	8b 00                	mov    (%eax),%eax
  800b58:	8d 50 04             	lea    0x4(%eax),%edx
  800b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5e:	89 10                	mov    %edx,(%eax)
  800b60:	8b 45 08             	mov    0x8(%ebp),%eax
  800b63:	8b 00                	mov    (%eax),%eax
  800b65:	83 e8 04             	sub    $0x4,%eax
  800b68:	8b 00                	mov    (%eax),%eax
  800b6a:	99                   	cltd   
}
  800b6b:	5d                   	pop    %ebp
  800b6c:	c3                   	ret    

00800b6d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b6d:	55                   	push   %ebp
  800b6e:	89 e5                	mov    %esp,%ebp
  800b70:	56                   	push   %esi
  800b71:	53                   	push   %ebx
  800b72:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b75:	eb 17                	jmp    800b8e <vprintfmt+0x21>
			if (ch == '\0')
  800b77:	85 db                	test   %ebx,%ebx
  800b79:	0f 84 af 03 00 00    	je     800f2e <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800b7f:	83 ec 08             	sub    $0x8,%esp
  800b82:	ff 75 0c             	pushl  0xc(%ebp)
  800b85:	53                   	push   %ebx
  800b86:	8b 45 08             	mov    0x8(%ebp),%eax
  800b89:	ff d0                	call   *%eax
  800b8b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b8e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b91:	8d 50 01             	lea    0x1(%eax),%edx
  800b94:	89 55 10             	mov    %edx,0x10(%ebp)
  800b97:	8a 00                	mov    (%eax),%al
  800b99:	0f b6 d8             	movzbl %al,%ebx
  800b9c:	83 fb 25             	cmp    $0x25,%ebx
  800b9f:	75 d6                	jne    800b77 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800ba1:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800ba5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800bac:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800bb3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800bba:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800bc1:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc4:	8d 50 01             	lea    0x1(%eax),%edx
  800bc7:	89 55 10             	mov    %edx,0x10(%ebp)
  800bca:	8a 00                	mov    (%eax),%al
  800bcc:	0f b6 d8             	movzbl %al,%ebx
  800bcf:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800bd2:	83 f8 55             	cmp    $0x55,%eax
  800bd5:	0f 87 2b 03 00 00    	ja     800f06 <vprintfmt+0x399>
  800bdb:	8b 04 85 58 25 80 00 	mov    0x802558(,%eax,4),%eax
  800be2:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800be4:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800be8:	eb d7                	jmp    800bc1 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bea:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800bee:	eb d1                	jmp    800bc1 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bf0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800bf7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bfa:	89 d0                	mov    %edx,%eax
  800bfc:	c1 e0 02             	shl    $0x2,%eax
  800bff:	01 d0                	add    %edx,%eax
  800c01:	01 c0                	add    %eax,%eax
  800c03:	01 d8                	add    %ebx,%eax
  800c05:	83 e8 30             	sub    $0x30,%eax
  800c08:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0e:	8a 00                	mov    (%eax),%al
  800c10:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c13:	83 fb 2f             	cmp    $0x2f,%ebx
  800c16:	7e 3e                	jle    800c56 <vprintfmt+0xe9>
  800c18:	83 fb 39             	cmp    $0x39,%ebx
  800c1b:	7f 39                	jg     800c56 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c1d:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c20:	eb d5                	jmp    800bf7 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c22:	8b 45 14             	mov    0x14(%ebp),%eax
  800c25:	83 c0 04             	add    $0x4,%eax
  800c28:	89 45 14             	mov    %eax,0x14(%ebp)
  800c2b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c2e:	83 e8 04             	sub    $0x4,%eax
  800c31:	8b 00                	mov    (%eax),%eax
  800c33:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c36:	eb 1f                	jmp    800c57 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c38:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c3c:	79 83                	jns    800bc1 <vprintfmt+0x54>
				width = 0;
  800c3e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c45:	e9 77 ff ff ff       	jmp    800bc1 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c4a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c51:	e9 6b ff ff ff       	jmp    800bc1 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c56:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c57:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c5b:	0f 89 60 ff ff ff    	jns    800bc1 <vprintfmt+0x54>
				width = precision, precision = -1;
  800c61:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c64:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c67:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c6e:	e9 4e ff ff ff       	jmp    800bc1 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c73:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c76:	e9 46 ff ff ff       	jmp    800bc1 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c7b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c7e:	83 c0 04             	add    $0x4,%eax
  800c81:	89 45 14             	mov    %eax,0x14(%ebp)
  800c84:	8b 45 14             	mov    0x14(%ebp),%eax
  800c87:	83 e8 04             	sub    $0x4,%eax
  800c8a:	8b 00                	mov    (%eax),%eax
  800c8c:	83 ec 08             	sub    $0x8,%esp
  800c8f:	ff 75 0c             	pushl  0xc(%ebp)
  800c92:	50                   	push   %eax
  800c93:	8b 45 08             	mov    0x8(%ebp),%eax
  800c96:	ff d0                	call   *%eax
  800c98:	83 c4 10             	add    $0x10,%esp
			break;
  800c9b:	e9 89 02 00 00       	jmp    800f29 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ca0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca3:	83 c0 04             	add    $0x4,%eax
  800ca6:	89 45 14             	mov    %eax,0x14(%ebp)
  800ca9:	8b 45 14             	mov    0x14(%ebp),%eax
  800cac:	83 e8 04             	sub    $0x4,%eax
  800caf:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800cb1:	85 db                	test   %ebx,%ebx
  800cb3:	79 02                	jns    800cb7 <vprintfmt+0x14a>
				err = -err;
  800cb5:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800cb7:	83 fb 64             	cmp    $0x64,%ebx
  800cba:	7f 0b                	jg     800cc7 <vprintfmt+0x15a>
  800cbc:	8b 34 9d a0 23 80 00 	mov    0x8023a0(,%ebx,4),%esi
  800cc3:	85 f6                	test   %esi,%esi
  800cc5:	75 19                	jne    800ce0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800cc7:	53                   	push   %ebx
  800cc8:	68 45 25 80 00       	push   $0x802545
  800ccd:	ff 75 0c             	pushl  0xc(%ebp)
  800cd0:	ff 75 08             	pushl  0x8(%ebp)
  800cd3:	e8 5e 02 00 00       	call   800f36 <printfmt>
  800cd8:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800cdb:	e9 49 02 00 00       	jmp    800f29 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ce0:	56                   	push   %esi
  800ce1:	68 4e 25 80 00       	push   $0x80254e
  800ce6:	ff 75 0c             	pushl  0xc(%ebp)
  800ce9:	ff 75 08             	pushl  0x8(%ebp)
  800cec:	e8 45 02 00 00       	call   800f36 <printfmt>
  800cf1:	83 c4 10             	add    $0x10,%esp
			break;
  800cf4:	e9 30 02 00 00       	jmp    800f29 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800cf9:	8b 45 14             	mov    0x14(%ebp),%eax
  800cfc:	83 c0 04             	add    $0x4,%eax
  800cff:	89 45 14             	mov    %eax,0x14(%ebp)
  800d02:	8b 45 14             	mov    0x14(%ebp),%eax
  800d05:	83 e8 04             	sub    $0x4,%eax
  800d08:	8b 30                	mov    (%eax),%esi
  800d0a:	85 f6                	test   %esi,%esi
  800d0c:	75 05                	jne    800d13 <vprintfmt+0x1a6>
				p = "(null)";
  800d0e:	be 51 25 80 00       	mov    $0x802551,%esi
			if (width > 0 && padc != '-')
  800d13:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d17:	7e 6d                	jle    800d86 <vprintfmt+0x219>
  800d19:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d1d:	74 67                	je     800d86 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d22:	83 ec 08             	sub    $0x8,%esp
  800d25:	50                   	push   %eax
  800d26:	56                   	push   %esi
  800d27:	e8 0c 03 00 00       	call   801038 <strnlen>
  800d2c:	83 c4 10             	add    $0x10,%esp
  800d2f:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d32:	eb 16                	jmp    800d4a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d34:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d38:	83 ec 08             	sub    $0x8,%esp
  800d3b:	ff 75 0c             	pushl  0xc(%ebp)
  800d3e:	50                   	push   %eax
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	ff d0                	call   *%eax
  800d44:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d47:	ff 4d e4             	decl   -0x1c(%ebp)
  800d4a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d4e:	7f e4                	jg     800d34 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d50:	eb 34                	jmp    800d86 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d52:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d56:	74 1c                	je     800d74 <vprintfmt+0x207>
  800d58:	83 fb 1f             	cmp    $0x1f,%ebx
  800d5b:	7e 05                	jle    800d62 <vprintfmt+0x1f5>
  800d5d:	83 fb 7e             	cmp    $0x7e,%ebx
  800d60:	7e 12                	jle    800d74 <vprintfmt+0x207>
					putch('?', putdat);
  800d62:	83 ec 08             	sub    $0x8,%esp
  800d65:	ff 75 0c             	pushl  0xc(%ebp)
  800d68:	6a 3f                	push   $0x3f
  800d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6d:	ff d0                	call   *%eax
  800d6f:	83 c4 10             	add    $0x10,%esp
  800d72:	eb 0f                	jmp    800d83 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d74:	83 ec 08             	sub    $0x8,%esp
  800d77:	ff 75 0c             	pushl  0xc(%ebp)
  800d7a:	53                   	push   %ebx
  800d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7e:	ff d0                	call   *%eax
  800d80:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d83:	ff 4d e4             	decl   -0x1c(%ebp)
  800d86:	89 f0                	mov    %esi,%eax
  800d88:	8d 70 01             	lea    0x1(%eax),%esi
  800d8b:	8a 00                	mov    (%eax),%al
  800d8d:	0f be d8             	movsbl %al,%ebx
  800d90:	85 db                	test   %ebx,%ebx
  800d92:	74 24                	je     800db8 <vprintfmt+0x24b>
  800d94:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d98:	78 b8                	js     800d52 <vprintfmt+0x1e5>
  800d9a:	ff 4d e0             	decl   -0x20(%ebp)
  800d9d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800da1:	79 af                	jns    800d52 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800da3:	eb 13                	jmp    800db8 <vprintfmt+0x24b>
				putch(' ', putdat);
  800da5:	83 ec 08             	sub    $0x8,%esp
  800da8:	ff 75 0c             	pushl  0xc(%ebp)
  800dab:	6a 20                	push   $0x20
  800dad:	8b 45 08             	mov    0x8(%ebp),%eax
  800db0:	ff d0                	call   *%eax
  800db2:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800db5:	ff 4d e4             	decl   -0x1c(%ebp)
  800db8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dbc:	7f e7                	jg     800da5 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800dbe:	e9 66 01 00 00       	jmp    800f29 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800dc3:	83 ec 08             	sub    $0x8,%esp
  800dc6:	ff 75 e8             	pushl  -0x18(%ebp)
  800dc9:	8d 45 14             	lea    0x14(%ebp),%eax
  800dcc:	50                   	push   %eax
  800dcd:	e8 3c fd ff ff       	call   800b0e <getint>
  800dd2:	83 c4 10             	add    $0x10,%esp
  800dd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dd8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ddb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800de1:	85 d2                	test   %edx,%edx
  800de3:	79 23                	jns    800e08 <vprintfmt+0x29b>
				putch('-', putdat);
  800de5:	83 ec 08             	sub    $0x8,%esp
  800de8:	ff 75 0c             	pushl  0xc(%ebp)
  800deb:	6a 2d                	push   $0x2d
  800ded:	8b 45 08             	mov    0x8(%ebp),%eax
  800df0:	ff d0                	call   *%eax
  800df2:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800df5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800df8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dfb:	f7 d8                	neg    %eax
  800dfd:	83 d2 00             	adc    $0x0,%edx
  800e00:	f7 da                	neg    %edx
  800e02:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e05:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e08:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e0f:	e9 bc 00 00 00       	jmp    800ed0 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e14:	83 ec 08             	sub    $0x8,%esp
  800e17:	ff 75 e8             	pushl  -0x18(%ebp)
  800e1a:	8d 45 14             	lea    0x14(%ebp),%eax
  800e1d:	50                   	push   %eax
  800e1e:	e8 84 fc ff ff       	call   800aa7 <getuint>
  800e23:	83 c4 10             	add    $0x10,%esp
  800e26:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e29:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e2c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e33:	e9 98 00 00 00       	jmp    800ed0 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e38:	83 ec 08             	sub    $0x8,%esp
  800e3b:	ff 75 0c             	pushl  0xc(%ebp)
  800e3e:	6a 58                	push   $0x58
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	ff d0                	call   *%eax
  800e45:	83 c4 10             	add    $0x10,%esp
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
			break;
  800e68:	e9 bc 00 00 00       	jmp    800f29 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800e6d:	83 ec 08             	sub    $0x8,%esp
  800e70:	ff 75 0c             	pushl  0xc(%ebp)
  800e73:	6a 30                	push   $0x30
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	ff d0                	call   *%eax
  800e7a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e7d:	83 ec 08             	sub    $0x8,%esp
  800e80:	ff 75 0c             	pushl  0xc(%ebp)
  800e83:	6a 78                	push   $0x78
  800e85:	8b 45 08             	mov    0x8(%ebp),%eax
  800e88:	ff d0                	call   *%eax
  800e8a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800e8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800e90:	83 c0 04             	add    $0x4,%eax
  800e93:	89 45 14             	mov    %eax,0x14(%ebp)
  800e96:	8b 45 14             	mov    0x14(%ebp),%eax
  800e99:	83 e8 04             	sub    $0x4,%eax
  800e9c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ea1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ea8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800eaf:	eb 1f                	jmp    800ed0 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800eb1:	83 ec 08             	sub    $0x8,%esp
  800eb4:	ff 75 e8             	pushl  -0x18(%ebp)
  800eb7:	8d 45 14             	lea    0x14(%ebp),%eax
  800eba:	50                   	push   %eax
  800ebb:	e8 e7 fb ff ff       	call   800aa7 <getuint>
  800ec0:	83 c4 10             	add    $0x10,%esp
  800ec3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ec6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ec9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ed0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ed4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ed7:	83 ec 04             	sub    $0x4,%esp
  800eda:	52                   	push   %edx
  800edb:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ede:	50                   	push   %eax
  800edf:	ff 75 f4             	pushl  -0xc(%ebp)
  800ee2:	ff 75 f0             	pushl  -0x10(%ebp)
  800ee5:	ff 75 0c             	pushl  0xc(%ebp)
  800ee8:	ff 75 08             	pushl  0x8(%ebp)
  800eeb:	e8 00 fb ff ff       	call   8009f0 <printnum>
  800ef0:	83 c4 20             	add    $0x20,%esp
			break;
  800ef3:	eb 34                	jmp    800f29 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ef5:	83 ec 08             	sub    $0x8,%esp
  800ef8:	ff 75 0c             	pushl  0xc(%ebp)
  800efb:	53                   	push   %ebx
  800efc:	8b 45 08             	mov    0x8(%ebp),%eax
  800eff:	ff d0                	call   *%eax
  800f01:	83 c4 10             	add    $0x10,%esp
			break;
  800f04:	eb 23                	jmp    800f29 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f06:	83 ec 08             	sub    $0x8,%esp
  800f09:	ff 75 0c             	pushl  0xc(%ebp)
  800f0c:	6a 25                	push   $0x25
  800f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f11:	ff d0                	call   *%eax
  800f13:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f16:	ff 4d 10             	decl   0x10(%ebp)
  800f19:	eb 03                	jmp    800f1e <vprintfmt+0x3b1>
  800f1b:	ff 4d 10             	decl   0x10(%ebp)
  800f1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f21:	48                   	dec    %eax
  800f22:	8a 00                	mov    (%eax),%al
  800f24:	3c 25                	cmp    $0x25,%al
  800f26:	75 f3                	jne    800f1b <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f28:	90                   	nop
		}
	}
  800f29:	e9 47 fc ff ff       	jmp    800b75 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f2e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f32:	5b                   	pop    %ebx
  800f33:	5e                   	pop    %esi
  800f34:	5d                   	pop    %ebp
  800f35:	c3                   	ret    

00800f36 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f36:	55                   	push   %ebp
  800f37:	89 e5                	mov    %esp,%ebp
  800f39:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f3c:	8d 45 10             	lea    0x10(%ebp),%eax
  800f3f:	83 c0 04             	add    $0x4,%eax
  800f42:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f45:	8b 45 10             	mov    0x10(%ebp),%eax
  800f48:	ff 75 f4             	pushl  -0xc(%ebp)
  800f4b:	50                   	push   %eax
  800f4c:	ff 75 0c             	pushl  0xc(%ebp)
  800f4f:	ff 75 08             	pushl  0x8(%ebp)
  800f52:	e8 16 fc ff ff       	call   800b6d <vprintfmt>
  800f57:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f5a:	90                   	nop
  800f5b:	c9                   	leave  
  800f5c:	c3                   	ret    

00800f5d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f5d:	55                   	push   %ebp
  800f5e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f63:	8b 40 08             	mov    0x8(%eax),%eax
  800f66:	8d 50 01             	lea    0x1(%eax),%edx
  800f69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f72:	8b 10                	mov    (%eax),%edx
  800f74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f77:	8b 40 04             	mov    0x4(%eax),%eax
  800f7a:	39 c2                	cmp    %eax,%edx
  800f7c:	73 12                	jae    800f90 <sprintputch+0x33>
		*b->buf++ = ch;
  800f7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f81:	8b 00                	mov    (%eax),%eax
  800f83:	8d 48 01             	lea    0x1(%eax),%ecx
  800f86:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f89:	89 0a                	mov    %ecx,(%edx)
  800f8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8e:	88 10                	mov    %dl,(%eax)
}
  800f90:	90                   	nop
  800f91:	5d                   	pop    %ebp
  800f92:	c3                   	ret    

00800f93 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f93:	55                   	push   %ebp
  800f94:	89 e5                	mov    %esp,%ebp
  800f96:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f99:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	01 d0                	add    %edx,%eax
  800faa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800fb4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fb8:	74 06                	je     800fc0 <vsnprintf+0x2d>
  800fba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fbe:	7f 07                	jg     800fc7 <vsnprintf+0x34>
		return -E_INVAL;
  800fc0:	b8 03 00 00 00       	mov    $0x3,%eax
  800fc5:	eb 20                	jmp    800fe7 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800fc7:	ff 75 14             	pushl  0x14(%ebp)
  800fca:	ff 75 10             	pushl  0x10(%ebp)
  800fcd:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800fd0:	50                   	push   %eax
  800fd1:	68 5d 0f 80 00       	push   $0x800f5d
  800fd6:	e8 92 fb ff ff       	call   800b6d <vprintfmt>
  800fdb:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800fde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fe1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800fe7:	c9                   	leave  
  800fe8:	c3                   	ret    

00800fe9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fe9:	55                   	push   %ebp
  800fea:	89 e5                	mov    %esp,%ebp
  800fec:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800fef:	8d 45 10             	lea    0x10(%ebp),%eax
  800ff2:	83 c0 04             	add    $0x4,%eax
  800ff5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ff8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffb:	ff 75 f4             	pushl  -0xc(%ebp)
  800ffe:	50                   	push   %eax
  800fff:	ff 75 0c             	pushl  0xc(%ebp)
  801002:	ff 75 08             	pushl  0x8(%ebp)
  801005:	e8 89 ff ff ff       	call   800f93 <vsnprintf>
  80100a:	83 c4 10             	add    $0x10,%esp
  80100d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801010:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801013:	c9                   	leave  
  801014:	c3                   	ret    

00801015 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801015:	55                   	push   %ebp
  801016:	89 e5                	mov    %esp,%ebp
  801018:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80101b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801022:	eb 06                	jmp    80102a <strlen+0x15>
		n++;
  801024:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801027:	ff 45 08             	incl   0x8(%ebp)
  80102a:	8b 45 08             	mov    0x8(%ebp),%eax
  80102d:	8a 00                	mov    (%eax),%al
  80102f:	84 c0                	test   %al,%al
  801031:	75 f1                	jne    801024 <strlen+0xf>
		n++;
	return n;
  801033:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801036:	c9                   	leave  
  801037:	c3                   	ret    

00801038 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801038:	55                   	push   %ebp
  801039:	89 e5                	mov    %esp,%ebp
  80103b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80103e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801045:	eb 09                	jmp    801050 <strnlen+0x18>
		n++;
  801047:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80104a:	ff 45 08             	incl   0x8(%ebp)
  80104d:	ff 4d 0c             	decl   0xc(%ebp)
  801050:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801054:	74 09                	je     80105f <strnlen+0x27>
  801056:	8b 45 08             	mov    0x8(%ebp),%eax
  801059:	8a 00                	mov    (%eax),%al
  80105b:	84 c0                	test   %al,%al
  80105d:	75 e8                	jne    801047 <strnlen+0xf>
		n++;
	return n;
  80105f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801062:	c9                   	leave  
  801063:	c3                   	ret    

00801064 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801064:	55                   	push   %ebp
  801065:	89 e5                	mov    %esp,%ebp
  801067:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80106a:	8b 45 08             	mov    0x8(%ebp),%eax
  80106d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801070:	90                   	nop
  801071:	8b 45 08             	mov    0x8(%ebp),%eax
  801074:	8d 50 01             	lea    0x1(%eax),%edx
  801077:	89 55 08             	mov    %edx,0x8(%ebp)
  80107a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80107d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801080:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801083:	8a 12                	mov    (%edx),%dl
  801085:	88 10                	mov    %dl,(%eax)
  801087:	8a 00                	mov    (%eax),%al
  801089:	84 c0                	test   %al,%al
  80108b:	75 e4                	jne    801071 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80108d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801090:	c9                   	leave  
  801091:	c3                   	ret    

00801092 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801092:	55                   	push   %ebp
  801093:	89 e5                	mov    %esp,%ebp
  801095:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801098:	8b 45 08             	mov    0x8(%ebp),%eax
  80109b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80109e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010a5:	eb 1f                	jmp    8010c6 <strncpy+0x34>
		*dst++ = *src;
  8010a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010aa:	8d 50 01             	lea    0x1(%eax),%edx
  8010ad:	89 55 08             	mov    %edx,0x8(%ebp)
  8010b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010b3:	8a 12                	mov    (%edx),%dl
  8010b5:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ba:	8a 00                	mov    (%eax),%al
  8010bc:	84 c0                	test   %al,%al
  8010be:	74 03                	je     8010c3 <strncpy+0x31>
			src++;
  8010c0:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010c3:	ff 45 fc             	incl   -0x4(%ebp)
  8010c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c9:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010cc:	72 d9                	jb     8010a7 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010d1:	c9                   	leave  
  8010d2:	c3                   	ret    

008010d3 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010d3:	55                   	push   %ebp
  8010d4:	89 e5                	mov    %esp,%ebp
  8010d6:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010df:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e3:	74 30                	je     801115 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010e5:	eb 16                	jmp    8010fd <strlcpy+0x2a>
			*dst++ = *src++;
  8010e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ea:	8d 50 01             	lea    0x1(%eax),%edx
  8010ed:	89 55 08             	mov    %edx,0x8(%ebp)
  8010f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010f6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010f9:	8a 12                	mov    (%edx),%dl
  8010fb:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010fd:	ff 4d 10             	decl   0x10(%ebp)
  801100:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801104:	74 09                	je     80110f <strlcpy+0x3c>
  801106:	8b 45 0c             	mov    0xc(%ebp),%eax
  801109:	8a 00                	mov    (%eax),%al
  80110b:	84 c0                	test   %al,%al
  80110d:	75 d8                	jne    8010e7 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80110f:	8b 45 08             	mov    0x8(%ebp),%eax
  801112:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801115:	8b 55 08             	mov    0x8(%ebp),%edx
  801118:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80111b:	29 c2                	sub    %eax,%edx
  80111d:	89 d0                	mov    %edx,%eax
}
  80111f:	c9                   	leave  
  801120:	c3                   	ret    

00801121 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801121:	55                   	push   %ebp
  801122:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801124:	eb 06                	jmp    80112c <strcmp+0xb>
		p++, q++;
  801126:	ff 45 08             	incl   0x8(%ebp)
  801129:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80112c:	8b 45 08             	mov    0x8(%ebp),%eax
  80112f:	8a 00                	mov    (%eax),%al
  801131:	84 c0                	test   %al,%al
  801133:	74 0e                	je     801143 <strcmp+0x22>
  801135:	8b 45 08             	mov    0x8(%ebp),%eax
  801138:	8a 10                	mov    (%eax),%dl
  80113a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113d:	8a 00                	mov    (%eax),%al
  80113f:	38 c2                	cmp    %al,%dl
  801141:	74 e3                	je     801126 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801143:	8b 45 08             	mov    0x8(%ebp),%eax
  801146:	8a 00                	mov    (%eax),%al
  801148:	0f b6 d0             	movzbl %al,%edx
  80114b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114e:	8a 00                	mov    (%eax),%al
  801150:	0f b6 c0             	movzbl %al,%eax
  801153:	29 c2                	sub    %eax,%edx
  801155:	89 d0                	mov    %edx,%eax
}
  801157:	5d                   	pop    %ebp
  801158:	c3                   	ret    

00801159 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801159:	55                   	push   %ebp
  80115a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80115c:	eb 09                	jmp    801167 <strncmp+0xe>
		n--, p++, q++;
  80115e:	ff 4d 10             	decl   0x10(%ebp)
  801161:	ff 45 08             	incl   0x8(%ebp)
  801164:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801167:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80116b:	74 17                	je     801184 <strncmp+0x2b>
  80116d:	8b 45 08             	mov    0x8(%ebp),%eax
  801170:	8a 00                	mov    (%eax),%al
  801172:	84 c0                	test   %al,%al
  801174:	74 0e                	je     801184 <strncmp+0x2b>
  801176:	8b 45 08             	mov    0x8(%ebp),%eax
  801179:	8a 10                	mov    (%eax),%dl
  80117b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117e:	8a 00                	mov    (%eax),%al
  801180:	38 c2                	cmp    %al,%dl
  801182:	74 da                	je     80115e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801184:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801188:	75 07                	jne    801191 <strncmp+0x38>
		return 0;
  80118a:	b8 00 00 00 00       	mov    $0x0,%eax
  80118f:	eb 14                	jmp    8011a5 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801191:	8b 45 08             	mov    0x8(%ebp),%eax
  801194:	8a 00                	mov    (%eax),%al
  801196:	0f b6 d0             	movzbl %al,%edx
  801199:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119c:	8a 00                	mov    (%eax),%al
  80119e:	0f b6 c0             	movzbl %al,%eax
  8011a1:	29 c2                	sub    %eax,%edx
  8011a3:	89 d0                	mov    %edx,%eax
}
  8011a5:	5d                   	pop    %ebp
  8011a6:	c3                   	ret    

008011a7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011a7:	55                   	push   %ebp
  8011a8:	89 e5                	mov    %esp,%ebp
  8011aa:	83 ec 04             	sub    $0x4,%esp
  8011ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011b3:	eb 12                	jmp    8011c7 <strchr+0x20>
		if (*s == c)
  8011b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b8:	8a 00                	mov    (%eax),%al
  8011ba:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011bd:	75 05                	jne    8011c4 <strchr+0x1d>
			return (char *) s;
  8011bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c2:	eb 11                	jmp    8011d5 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011c4:	ff 45 08             	incl   0x8(%ebp)
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ca:	8a 00                	mov    (%eax),%al
  8011cc:	84 c0                	test   %al,%al
  8011ce:	75 e5                	jne    8011b5 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011d5:	c9                   	leave  
  8011d6:	c3                   	ret    

008011d7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011d7:	55                   	push   %ebp
  8011d8:	89 e5                	mov    %esp,%ebp
  8011da:	83 ec 04             	sub    $0x4,%esp
  8011dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011e3:	eb 0d                	jmp    8011f2 <strfind+0x1b>
		if (*s == c)
  8011e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e8:	8a 00                	mov    (%eax),%al
  8011ea:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011ed:	74 0e                	je     8011fd <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011ef:	ff 45 08             	incl   0x8(%ebp)
  8011f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f5:	8a 00                	mov    (%eax),%al
  8011f7:	84 c0                	test   %al,%al
  8011f9:	75 ea                	jne    8011e5 <strfind+0xe>
  8011fb:	eb 01                	jmp    8011fe <strfind+0x27>
		if (*s == c)
			break;
  8011fd:	90                   	nop
	return (char *) s;
  8011fe:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801201:	c9                   	leave  
  801202:	c3                   	ret    

00801203 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801203:	55                   	push   %ebp
  801204:	89 e5                	mov    %esp,%ebp
  801206:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801209:	8b 45 08             	mov    0x8(%ebp),%eax
  80120c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80120f:	8b 45 10             	mov    0x10(%ebp),%eax
  801212:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801215:	eb 0e                	jmp    801225 <memset+0x22>
		*p++ = c;
  801217:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80121a:	8d 50 01             	lea    0x1(%eax),%edx
  80121d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801220:	8b 55 0c             	mov    0xc(%ebp),%edx
  801223:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801225:	ff 4d f8             	decl   -0x8(%ebp)
  801228:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80122c:	79 e9                	jns    801217 <memset+0x14>
		*p++ = c;

	return v;
  80122e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801231:	c9                   	leave  
  801232:	c3                   	ret    

00801233 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801233:	55                   	push   %ebp
  801234:	89 e5                	mov    %esp,%ebp
  801236:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801239:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80123f:	8b 45 08             	mov    0x8(%ebp),%eax
  801242:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801245:	eb 16                	jmp    80125d <memcpy+0x2a>
		*d++ = *s++;
  801247:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80124a:	8d 50 01             	lea    0x1(%eax),%edx
  80124d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801250:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801253:	8d 4a 01             	lea    0x1(%edx),%ecx
  801256:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801259:	8a 12                	mov    (%edx),%dl
  80125b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80125d:	8b 45 10             	mov    0x10(%ebp),%eax
  801260:	8d 50 ff             	lea    -0x1(%eax),%edx
  801263:	89 55 10             	mov    %edx,0x10(%ebp)
  801266:	85 c0                	test   %eax,%eax
  801268:	75 dd                	jne    801247 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80126a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80126d:	c9                   	leave  
  80126e:	c3                   	ret    

0080126f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80126f:	55                   	push   %ebp
  801270:	89 e5                	mov    %esp,%ebp
  801272:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801275:	8b 45 0c             	mov    0xc(%ebp),%eax
  801278:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80127b:	8b 45 08             	mov    0x8(%ebp),%eax
  80127e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801281:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801284:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801287:	73 50                	jae    8012d9 <memmove+0x6a>
  801289:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80128c:	8b 45 10             	mov    0x10(%ebp),%eax
  80128f:	01 d0                	add    %edx,%eax
  801291:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801294:	76 43                	jbe    8012d9 <memmove+0x6a>
		s += n;
  801296:	8b 45 10             	mov    0x10(%ebp),%eax
  801299:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80129c:	8b 45 10             	mov    0x10(%ebp),%eax
  80129f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012a2:	eb 10                	jmp    8012b4 <memmove+0x45>
			*--d = *--s;
  8012a4:	ff 4d f8             	decl   -0x8(%ebp)
  8012a7:	ff 4d fc             	decl   -0x4(%ebp)
  8012aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ad:	8a 10                	mov    (%eax),%dl
  8012af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b2:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012ba:	89 55 10             	mov    %edx,0x10(%ebp)
  8012bd:	85 c0                	test   %eax,%eax
  8012bf:	75 e3                	jne    8012a4 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8012c1:	eb 23                	jmp    8012e6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8012c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c6:	8d 50 01             	lea    0x1(%eax),%edx
  8012c9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012cc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012cf:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012d2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012d5:	8a 12                	mov    (%edx),%dl
  8012d7:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012dc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012df:	89 55 10             	mov    %edx,0x10(%ebp)
  8012e2:	85 c0                	test   %eax,%eax
  8012e4:	75 dd                	jne    8012c3 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8012e6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012e9:	c9                   	leave  
  8012ea:	c3                   	ret    

008012eb <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8012eb:	55                   	push   %ebp
  8012ec:	89 e5                	mov    %esp,%ebp
  8012ee:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8012f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8012f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fa:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8012fd:	eb 2a                	jmp    801329 <memcmp+0x3e>
		if (*s1 != *s2)
  8012ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801302:	8a 10                	mov    (%eax),%dl
  801304:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801307:	8a 00                	mov    (%eax),%al
  801309:	38 c2                	cmp    %al,%dl
  80130b:	74 16                	je     801323 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80130d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801310:	8a 00                	mov    (%eax),%al
  801312:	0f b6 d0             	movzbl %al,%edx
  801315:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801318:	8a 00                	mov    (%eax),%al
  80131a:	0f b6 c0             	movzbl %al,%eax
  80131d:	29 c2                	sub    %eax,%edx
  80131f:	89 d0                	mov    %edx,%eax
  801321:	eb 18                	jmp    80133b <memcmp+0x50>
		s1++, s2++;
  801323:	ff 45 fc             	incl   -0x4(%ebp)
  801326:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801329:	8b 45 10             	mov    0x10(%ebp),%eax
  80132c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80132f:	89 55 10             	mov    %edx,0x10(%ebp)
  801332:	85 c0                	test   %eax,%eax
  801334:	75 c9                	jne    8012ff <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801336:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80133b:	c9                   	leave  
  80133c:	c3                   	ret    

0080133d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80133d:	55                   	push   %ebp
  80133e:	89 e5                	mov    %esp,%ebp
  801340:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801343:	8b 55 08             	mov    0x8(%ebp),%edx
  801346:	8b 45 10             	mov    0x10(%ebp),%eax
  801349:	01 d0                	add    %edx,%eax
  80134b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80134e:	eb 15                	jmp    801365 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801350:	8b 45 08             	mov    0x8(%ebp),%eax
  801353:	8a 00                	mov    (%eax),%al
  801355:	0f b6 d0             	movzbl %al,%edx
  801358:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135b:	0f b6 c0             	movzbl %al,%eax
  80135e:	39 c2                	cmp    %eax,%edx
  801360:	74 0d                	je     80136f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801362:	ff 45 08             	incl   0x8(%ebp)
  801365:	8b 45 08             	mov    0x8(%ebp),%eax
  801368:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80136b:	72 e3                	jb     801350 <memfind+0x13>
  80136d:	eb 01                	jmp    801370 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80136f:	90                   	nop
	return (void *) s;
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801373:	c9                   	leave  
  801374:	c3                   	ret    

00801375 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801375:	55                   	push   %ebp
  801376:	89 e5                	mov    %esp,%ebp
  801378:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80137b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801382:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801389:	eb 03                	jmp    80138e <strtol+0x19>
		s++;
  80138b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80138e:	8b 45 08             	mov    0x8(%ebp),%eax
  801391:	8a 00                	mov    (%eax),%al
  801393:	3c 20                	cmp    $0x20,%al
  801395:	74 f4                	je     80138b <strtol+0x16>
  801397:	8b 45 08             	mov    0x8(%ebp),%eax
  80139a:	8a 00                	mov    (%eax),%al
  80139c:	3c 09                	cmp    $0x9,%al
  80139e:	74 eb                	je     80138b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a3:	8a 00                	mov    (%eax),%al
  8013a5:	3c 2b                	cmp    $0x2b,%al
  8013a7:	75 05                	jne    8013ae <strtol+0x39>
		s++;
  8013a9:	ff 45 08             	incl   0x8(%ebp)
  8013ac:	eb 13                	jmp    8013c1 <strtol+0x4c>
	else if (*s == '-')
  8013ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b1:	8a 00                	mov    (%eax),%al
  8013b3:	3c 2d                	cmp    $0x2d,%al
  8013b5:	75 0a                	jne    8013c1 <strtol+0x4c>
		s++, neg = 1;
  8013b7:	ff 45 08             	incl   0x8(%ebp)
  8013ba:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013c5:	74 06                	je     8013cd <strtol+0x58>
  8013c7:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8013cb:	75 20                	jne    8013ed <strtol+0x78>
  8013cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d0:	8a 00                	mov    (%eax),%al
  8013d2:	3c 30                	cmp    $0x30,%al
  8013d4:	75 17                	jne    8013ed <strtol+0x78>
  8013d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d9:	40                   	inc    %eax
  8013da:	8a 00                	mov    (%eax),%al
  8013dc:	3c 78                	cmp    $0x78,%al
  8013de:	75 0d                	jne    8013ed <strtol+0x78>
		s += 2, base = 16;
  8013e0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8013e4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8013eb:	eb 28                	jmp    801415 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8013ed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013f1:	75 15                	jne    801408 <strtol+0x93>
  8013f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f6:	8a 00                	mov    (%eax),%al
  8013f8:	3c 30                	cmp    $0x30,%al
  8013fa:	75 0c                	jne    801408 <strtol+0x93>
		s++, base = 8;
  8013fc:	ff 45 08             	incl   0x8(%ebp)
  8013ff:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801406:	eb 0d                	jmp    801415 <strtol+0xa0>
	else if (base == 0)
  801408:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80140c:	75 07                	jne    801415 <strtol+0xa0>
		base = 10;
  80140e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801415:	8b 45 08             	mov    0x8(%ebp),%eax
  801418:	8a 00                	mov    (%eax),%al
  80141a:	3c 2f                	cmp    $0x2f,%al
  80141c:	7e 19                	jle    801437 <strtol+0xc2>
  80141e:	8b 45 08             	mov    0x8(%ebp),%eax
  801421:	8a 00                	mov    (%eax),%al
  801423:	3c 39                	cmp    $0x39,%al
  801425:	7f 10                	jg     801437 <strtol+0xc2>
			dig = *s - '0';
  801427:	8b 45 08             	mov    0x8(%ebp),%eax
  80142a:	8a 00                	mov    (%eax),%al
  80142c:	0f be c0             	movsbl %al,%eax
  80142f:	83 e8 30             	sub    $0x30,%eax
  801432:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801435:	eb 42                	jmp    801479 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801437:	8b 45 08             	mov    0x8(%ebp),%eax
  80143a:	8a 00                	mov    (%eax),%al
  80143c:	3c 60                	cmp    $0x60,%al
  80143e:	7e 19                	jle    801459 <strtol+0xe4>
  801440:	8b 45 08             	mov    0x8(%ebp),%eax
  801443:	8a 00                	mov    (%eax),%al
  801445:	3c 7a                	cmp    $0x7a,%al
  801447:	7f 10                	jg     801459 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	8a 00                	mov    (%eax),%al
  80144e:	0f be c0             	movsbl %al,%eax
  801451:	83 e8 57             	sub    $0x57,%eax
  801454:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801457:	eb 20                	jmp    801479 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801459:	8b 45 08             	mov    0x8(%ebp),%eax
  80145c:	8a 00                	mov    (%eax),%al
  80145e:	3c 40                	cmp    $0x40,%al
  801460:	7e 39                	jle    80149b <strtol+0x126>
  801462:	8b 45 08             	mov    0x8(%ebp),%eax
  801465:	8a 00                	mov    (%eax),%al
  801467:	3c 5a                	cmp    $0x5a,%al
  801469:	7f 30                	jg     80149b <strtol+0x126>
			dig = *s - 'A' + 10;
  80146b:	8b 45 08             	mov    0x8(%ebp),%eax
  80146e:	8a 00                	mov    (%eax),%al
  801470:	0f be c0             	movsbl %al,%eax
  801473:	83 e8 37             	sub    $0x37,%eax
  801476:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801479:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80147c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80147f:	7d 19                	jge    80149a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801481:	ff 45 08             	incl   0x8(%ebp)
  801484:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801487:	0f af 45 10          	imul   0x10(%ebp),%eax
  80148b:	89 c2                	mov    %eax,%edx
  80148d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801490:	01 d0                	add    %edx,%eax
  801492:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801495:	e9 7b ff ff ff       	jmp    801415 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80149a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80149b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80149f:	74 08                	je     8014a9 <strtol+0x134>
		*endptr = (char *) s;
  8014a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8014a7:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8014a9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014ad:	74 07                	je     8014b6 <strtol+0x141>
  8014af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014b2:	f7 d8                	neg    %eax
  8014b4:	eb 03                	jmp    8014b9 <strtol+0x144>
  8014b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014b9:	c9                   	leave  
  8014ba:	c3                   	ret    

008014bb <ltostr>:

void
ltostr(long value, char *str)
{
  8014bb:	55                   	push   %ebp
  8014bc:	89 e5                	mov    %esp,%ebp
  8014be:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8014c1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8014c8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8014cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014d3:	79 13                	jns    8014e8 <ltostr+0x2d>
	{
		neg = 1;
  8014d5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014df:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8014e2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8014e5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8014e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014eb:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014f0:	99                   	cltd   
  8014f1:	f7 f9                	idiv   %ecx
  8014f3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8014f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f9:	8d 50 01             	lea    0x1(%eax),%edx
  8014fc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014ff:	89 c2                	mov    %eax,%edx
  801501:	8b 45 0c             	mov    0xc(%ebp),%eax
  801504:	01 d0                	add    %edx,%eax
  801506:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801509:	83 c2 30             	add    $0x30,%edx
  80150c:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80150e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801511:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801516:	f7 e9                	imul   %ecx
  801518:	c1 fa 02             	sar    $0x2,%edx
  80151b:	89 c8                	mov    %ecx,%eax
  80151d:	c1 f8 1f             	sar    $0x1f,%eax
  801520:	29 c2                	sub    %eax,%edx
  801522:	89 d0                	mov    %edx,%eax
  801524:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801527:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80152a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80152f:	f7 e9                	imul   %ecx
  801531:	c1 fa 02             	sar    $0x2,%edx
  801534:	89 c8                	mov    %ecx,%eax
  801536:	c1 f8 1f             	sar    $0x1f,%eax
  801539:	29 c2                	sub    %eax,%edx
  80153b:	89 d0                	mov    %edx,%eax
  80153d:	c1 e0 02             	shl    $0x2,%eax
  801540:	01 d0                	add    %edx,%eax
  801542:	01 c0                	add    %eax,%eax
  801544:	29 c1                	sub    %eax,%ecx
  801546:	89 ca                	mov    %ecx,%edx
  801548:	85 d2                	test   %edx,%edx
  80154a:	75 9c                	jne    8014e8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80154c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801553:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801556:	48                   	dec    %eax
  801557:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80155a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80155e:	74 3d                	je     80159d <ltostr+0xe2>
		start = 1 ;
  801560:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801567:	eb 34                	jmp    80159d <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801569:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80156c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156f:	01 d0                	add    %edx,%eax
  801571:	8a 00                	mov    (%eax),%al
  801573:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801576:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801579:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157c:	01 c2                	add    %eax,%edx
  80157e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801581:	8b 45 0c             	mov    0xc(%ebp),%eax
  801584:	01 c8                	add    %ecx,%eax
  801586:	8a 00                	mov    (%eax),%al
  801588:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80158a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80158d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801590:	01 c2                	add    %eax,%edx
  801592:	8a 45 eb             	mov    -0x15(%ebp),%al
  801595:	88 02                	mov    %al,(%edx)
		start++ ;
  801597:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80159a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80159d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015a3:	7c c4                	jl     801569 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8015a5:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8015a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ab:	01 d0                	add    %edx,%eax
  8015ad:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8015b0:	90                   	nop
  8015b1:	c9                   	leave  
  8015b2:	c3                   	ret    

008015b3 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8015b3:	55                   	push   %ebp
  8015b4:	89 e5                	mov    %esp,%ebp
  8015b6:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8015b9:	ff 75 08             	pushl  0x8(%ebp)
  8015bc:	e8 54 fa ff ff       	call   801015 <strlen>
  8015c1:	83 c4 04             	add    $0x4,%esp
  8015c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8015c7:	ff 75 0c             	pushl  0xc(%ebp)
  8015ca:	e8 46 fa ff ff       	call   801015 <strlen>
  8015cf:	83 c4 04             	add    $0x4,%esp
  8015d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8015dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015e3:	eb 17                	jmp    8015fc <strcconcat+0x49>
		final[s] = str1[s] ;
  8015e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8015eb:	01 c2                	add    %eax,%edx
  8015ed:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f3:	01 c8                	add    %ecx,%eax
  8015f5:	8a 00                	mov    (%eax),%al
  8015f7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8015f9:	ff 45 fc             	incl   -0x4(%ebp)
  8015fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015ff:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801602:	7c e1                	jl     8015e5 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801604:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80160b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801612:	eb 1f                	jmp    801633 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801614:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801617:	8d 50 01             	lea    0x1(%eax),%edx
  80161a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80161d:	89 c2                	mov    %eax,%edx
  80161f:	8b 45 10             	mov    0x10(%ebp),%eax
  801622:	01 c2                	add    %eax,%edx
  801624:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801627:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162a:	01 c8                	add    %ecx,%eax
  80162c:	8a 00                	mov    (%eax),%al
  80162e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801630:	ff 45 f8             	incl   -0x8(%ebp)
  801633:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801636:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801639:	7c d9                	jl     801614 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80163b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80163e:	8b 45 10             	mov    0x10(%ebp),%eax
  801641:	01 d0                	add    %edx,%eax
  801643:	c6 00 00             	movb   $0x0,(%eax)
}
  801646:	90                   	nop
  801647:	c9                   	leave  
  801648:	c3                   	ret    

00801649 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801649:	55                   	push   %ebp
  80164a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80164c:	8b 45 14             	mov    0x14(%ebp),%eax
  80164f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801655:	8b 45 14             	mov    0x14(%ebp),%eax
  801658:	8b 00                	mov    (%eax),%eax
  80165a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801661:	8b 45 10             	mov    0x10(%ebp),%eax
  801664:	01 d0                	add    %edx,%eax
  801666:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80166c:	eb 0c                	jmp    80167a <strsplit+0x31>
			*string++ = 0;
  80166e:	8b 45 08             	mov    0x8(%ebp),%eax
  801671:	8d 50 01             	lea    0x1(%eax),%edx
  801674:	89 55 08             	mov    %edx,0x8(%ebp)
  801677:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80167a:	8b 45 08             	mov    0x8(%ebp),%eax
  80167d:	8a 00                	mov    (%eax),%al
  80167f:	84 c0                	test   %al,%al
  801681:	74 18                	je     80169b <strsplit+0x52>
  801683:	8b 45 08             	mov    0x8(%ebp),%eax
  801686:	8a 00                	mov    (%eax),%al
  801688:	0f be c0             	movsbl %al,%eax
  80168b:	50                   	push   %eax
  80168c:	ff 75 0c             	pushl  0xc(%ebp)
  80168f:	e8 13 fb ff ff       	call   8011a7 <strchr>
  801694:	83 c4 08             	add    $0x8,%esp
  801697:	85 c0                	test   %eax,%eax
  801699:	75 d3                	jne    80166e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80169b:	8b 45 08             	mov    0x8(%ebp),%eax
  80169e:	8a 00                	mov    (%eax),%al
  8016a0:	84 c0                	test   %al,%al
  8016a2:	74 5a                	je     8016fe <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8016a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8016a7:	8b 00                	mov    (%eax),%eax
  8016a9:	83 f8 0f             	cmp    $0xf,%eax
  8016ac:	75 07                	jne    8016b5 <strsplit+0x6c>
		{
			return 0;
  8016ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b3:	eb 66                	jmp    80171b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8016b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8016b8:	8b 00                	mov    (%eax),%eax
  8016ba:	8d 48 01             	lea    0x1(%eax),%ecx
  8016bd:	8b 55 14             	mov    0x14(%ebp),%edx
  8016c0:	89 0a                	mov    %ecx,(%edx)
  8016c2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8016cc:	01 c2                	add    %eax,%edx
  8016ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d1:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016d3:	eb 03                	jmp    8016d8 <strsplit+0x8f>
			string++;
  8016d5:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016db:	8a 00                	mov    (%eax),%al
  8016dd:	84 c0                	test   %al,%al
  8016df:	74 8b                	je     80166c <strsplit+0x23>
  8016e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e4:	8a 00                	mov    (%eax),%al
  8016e6:	0f be c0             	movsbl %al,%eax
  8016e9:	50                   	push   %eax
  8016ea:	ff 75 0c             	pushl  0xc(%ebp)
  8016ed:	e8 b5 fa ff ff       	call   8011a7 <strchr>
  8016f2:	83 c4 08             	add    $0x8,%esp
  8016f5:	85 c0                	test   %eax,%eax
  8016f7:	74 dc                	je     8016d5 <strsplit+0x8c>
			string++;
	}
  8016f9:	e9 6e ff ff ff       	jmp    80166c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8016fe:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8016ff:	8b 45 14             	mov    0x14(%ebp),%eax
  801702:	8b 00                	mov    (%eax),%eax
  801704:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80170b:	8b 45 10             	mov    0x10(%ebp),%eax
  80170e:	01 d0                	add    %edx,%eax
  801710:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801716:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80171b:	c9                   	leave  
  80171c:	c3                   	ret    

0080171d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80171d:	55                   	push   %ebp
  80171e:	89 e5                	mov    %esp,%ebp
  801720:	57                   	push   %edi
  801721:	56                   	push   %esi
  801722:	53                   	push   %ebx
  801723:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801726:	8b 45 08             	mov    0x8(%ebp),%eax
  801729:	8b 55 0c             	mov    0xc(%ebp),%edx
  80172c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80172f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801732:	8b 7d 18             	mov    0x18(%ebp),%edi
  801735:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801738:	cd 30                	int    $0x30
  80173a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80173d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801740:	83 c4 10             	add    $0x10,%esp
  801743:	5b                   	pop    %ebx
  801744:	5e                   	pop    %esi
  801745:	5f                   	pop    %edi
  801746:	5d                   	pop    %ebp
  801747:	c3                   	ret    

00801748 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801748:	55                   	push   %ebp
  801749:	89 e5                	mov    %esp,%ebp
  80174b:	83 ec 04             	sub    $0x4,%esp
  80174e:	8b 45 10             	mov    0x10(%ebp),%eax
  801751:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801754:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801758:	8b 45 08             	mov    0x8(%ebp),%eax
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	52                   	push   %edx
  801760:	ff 75 0c             	pushl  0xc(%ebp)
  801763:	50                   	push   %eax
  801764:	6a 00                	push   $0x0
  801766:	e8 b2 ff ff ff       	call   80171d <syscall>
  80176b:	83 c4 18             	add    $0x18,%esp
}
  80176e:	90                   	nop
  80176f:	c9                   	leave  
  801770:	c3                   	ret    

00801771 <sys_cgetc>:

int
sys_cgetc(void)
{
  801771:	55                   	push   %ebp
  801772:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	6a 00                	push   $0x0
  80177a:	6a 00                	push   $0x0
  80177c:	6a 00                	push   $0x0
  80177e:	6a 01                	push   $0x1
  801780:	e8 98 ff ff ff       	call   80171d <syscall>
  801785:	83 c4 18             	add    $0x18,%esp
}
  801788:	c9                   	leave  
  801789:	c3                   	ret    

0080178a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80178a:	55                   	push   %ebp
  80178b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80178d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801790:	8b 45 08             	mov    0x8(%ebp),%eax
  801793:	6a 00                	push   $0x0
  801795:	6a 00                	push   $0x0
  801797:	6a 00                	push   $0x0
  801799:	52                   	push   %edx
  80179a:	50                   	push   %eax
  80179b:	6a 05                	push   $0x5
  80179d:	e8 7b ff ff ff       	call   80171d <syscall>
  8017a2:	83 c4 18             	add    $0x18,%esp
}
  8017a5:	c9                   	leave  
  8017a6:	c3                   	ret    

008017a7 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017a7:	55                   	push   %ebp
  8017a8:	89 e5                	mov    %esp,%ebp
  8017aa:	56                   	push   %esi
  8017ab:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017ac:	8b 75 18             	mov    0x18(%ebp),%esi
  8017af:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017b2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bb:	56                   	push   %esi
  8017bc:	53                   	push   %ebx
  8017bd:	51                   	push   %ecx
  8017be:	52                   	push   %edx
  8017bf:	50                   	push   %eax
  8017c0:	6a 06                	push   $0x6
  8017c2:	e8 56 ff ff ff       	call   80171d <syscall>
  8017c7:	83 c4 18             	add    $0x18,%esp
}
  8017ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017cd:	5b                   	pop    %ebx
  8017ce:	5e                   	pop    %esi
  8017cf:	5d                   	pop    %ebp
  8017d0:	c3                   	ret    

008017d1 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8017d1:	55                   	push   %ebp
  8017d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8017d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 00                	push   $0x0
  8017e0:	52                   	push   %edx
  8017e1:	50                   	push   %eax
  8017e2:	6a 07                	push   $0x7
  8017e4:	e8 34 ff ff ff       	call   80171d <syscall>
  8017e9:	83 c4 18             	add    $0x18,%esp
}
  8017ec:	c9                   	leave  
  8017ed:	c3                   	ret    

008017ee <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8017ee:	55                   	push   %ebp
  8017ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	ff 75 0c             	pushl  0xc(%ebp)
  8017fa:	ff 75 08             	pushl  0x8(%ebp)
  8017fd:	6a 08                	push   $0x8
  8017ff:	e8 19 ff ff ff       	call   80171d <syscall>
  801804:	83 c4 18             	add    $0x18,%esp
}
  801807:	c9                   	leave  
  801808:	c3                   	ret    

00801809 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801809:	55                   	push   %ebp
  80180a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	6a 00                	push   $0x0
  801812:	6a 00                	push   $0x0
  801814:	6a 00                	push   $0x0
  801816:	6a 09                	push   $0x9
  801818:	e8 00 ff ff ff       	call   80171d <syscall>
  80181d:	83 c4 18             	add    $0x18,%esp
}
  801820:	c9                   	leave  
  801821:	c3                   	ret    

00801822 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801822:	55                   	push   %ebp
  801823:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 0a                	push   $0xa
  801831:	e8 e7 fe ff ff       	call   80171d <syscall>
  801836:	83 c4 18             	add    $0x18,%esp
}
  801839:	c9                   	leave  
  80183a:	c3                   	ret    

0080183b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	6a 00                	push   $0x0
  801848:	6a 0b                	push   $0xb
  80184a:	e8 ce fe ff ff       	call   80171d <syscall>
  80184f:	83 c4 18             	add    $0x18,%esp
}
  801852:	c9                   	leave  
  801853:	c3                   	ret    

00801854 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801854:	55                   	push   %ebp
  801855:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	ff 75 0c             	pushl  0xc(%ebp)
  801860:	ff 75 08             	pushl  0x8(%ebp)
  801863:	6a 0f                	push   $0xf
  801865:	e8 b3 fe ff ff       	call   80171d <syscall>
  80186a:	83 c4 18             	add    $0x18,%esp
	return;
  80186d:	90                   	nop
}
  80186e:	c9                   	leave  
  80186f:	c3                   	ret    

00801870 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	ff 75 0c             	pushl  0xc(%ebp)
  80187c:	ff 75 08             	pushl  0x8(%ebp)
  80187f:	6a 10                	push   $0x10
  801881:	e8 97 fe ff ff       	call   80171d <syscall>
  801886:	83 c4 18             	add    $0x18,%esp
	return ;
  801889:	90                   	nop
}
  80188a:	c9                   	leave  
  80188b:	c3                   	ret    

0080188c <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	ff 75 10             	pushl  0x10(%ebp)
  801896:	ff 75 0c             	pushl  0xc(%ebp)
  801899:	ff 75 08             	pushl  0x8(%ebp)
  80189c:	6a 11                	push   $0x11
  80189e:	e8 7a fe ff ff       	call   80171d <syscall>
  8018a3:	83 c4 18             	add    $0x18,%esp
	return ;
  8018a6:	90                   	nop
}
  8018a7:	c9                   	leave  
  8018a8:	c3                   	ret    

008018a9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8018a9:	55                   	push   %ebp
  8018aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 0c                	push   $0xc
  8018b8:	e8 60 fe ff ff       	call   80171d <syscall>
  8018bd:	83 c4 18             	add    $0x18,%esp
}
  8018c0:	c9                   	leave  
  8018c1:	c3                   	ret    

008018c2 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8018c2:	55                   	push   %ebp
  8018c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	ff 75 08             	pushl  0x8(%ebp)
  8018d0:	6a 0d                	push   $0xd
  8018d2:	e8 46 fe ff ff       	call   80171d <syscall>
  8018d7:	83 c4 18             	add    $0x18,%esp
}
  8018da:	c9                   	leave  
  8018db:	c3                   	ret    

008018dc <sys_scarce_memory>:

void sys_scarce_memory()
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 0e                	push   $0xe
  8018eb:	e8 2d fe ff ff       	call   80171d <syscall>
  8018f0:	83 c4 18             	add    $0x18,%esp
}
  8018f3:	90                   	nop
  8018f4:	c9                   	leave  
  8018f5:	c3                   	ret    

008018f6 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8018f6:	55                   	push   %ebp
  8018f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	6a 13                	push   $0x13
  801905:	e8 13 fe ff ff       	call   80171d <syscall>
  80190a:	83 c4 18             	add    $0x18,%esp
}
  80190d:	90                   	nop
  80190e:	c9                   	leave  
  80190f:	c3                   	ret    

00801910 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801910:	55                   	push   %ebp
  801911:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 14                	push   $0x14
  80191f:	e8 f9 fd ff ff       	call   80171d <syscall>
  801924:	83 c4 18             	add    $0x18,%esp
}
  801927:	90                   	nop
  801928:	c9                   	leave  
  801929:	c3                   	ret    

0080192a <sys_cputc>:


void
sys_cputc(const char c)
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
  80192d:	83 ec 04             	sub    $0x4,%esp
  801930:	8b 45 08             	mov    0x8(%ebp),%eax
  801933:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801936:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	50                   	push   %eax
  801943:	6a 15                	push   $0x15
  801945:	e8 d3 fd ff ff       	call   80171d <syscall>
  80194a:	83 c4 18             	add    $0x18,%esp
}
  80194d:	90                   	nop
  80194e:	c9                   	leave  
  80194f:	c3                   	ret    

00801950 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 16                	push   $0x16
  80195f:	e8 b9 fd ff ff       	call   80171d <syscall>
  801964:	83 c4 18             	add    $0x18,%esp
}
  801967:	90                   	nop
  801968:	c9                   	leave  
  801969:	c3                   	ret    

0080196a <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80196d:	8b 45 08             	mov    0x8(%ebp),%eax
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	ff 75 0c             	pushl  0xc(%ebp)
  801979:	50                   	push   %eax
  80197a:	6a 17                	push   $0x17
  80197c:	e8 9c fd ff ff       	call   80171d <syscall>
  801981:	83 c4 18             	add    $0x18,%esp
}
  801984:	c9                   	leave  
  801985:	c3                   	ret    

00801986 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801989:	8b 55 0c             	mov    0xc(%ebp),%edx
  80198c:	8b 45 08             	mov    0x8(%ebp),%eax
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	52                   	push   %edx
  801996:	50                   	push   %eax
  801997:	6a 1a                	push   $0x1a
  801999:	e8 7f fd ff ff       	call   80171d <syscall>
  80199e:	83 c4 18             	add    $0x18,%esp
}
  8019a1:	c9                   	leave  
  8019a2:	c3                   	ret    

008019a3 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019a3:	55                   	push   %ebp
  8019a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	52                   	push   %edx
  8019b3:	50                   	push   %eax
  8019b4:	6a 18                	push   $0x18
  8019b6:	e8 62 fd ff ff       	call   80171d <syscall>
  8019bb:	83 c4 18             	add    $0x18,%esp
}
  8019be:	90                   	nop
  8019bf:	c9                   	leave  
  8019c0:	c3                   	ret    

008019c1 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019c1:	55                   	push   %ebp
  8019c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	52                   	push   %edx
  8019d1:	50                   	push   %eax
  8019d2:	6a 19                	push   $0x19
  8019d4:	e8 44 fd ff ff       	call   80171d <syscall>
  8019d9:	83 c4 18             	add    $0x18,%esp
}
  8019dc:	90                   	nop
  8019dd:	c9                   	leave  
  8019de:	c3                   	ret    

008019df <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019df:	55                   	push   %ebp
  8019e0:	89 e5                	mov    %esp,%ebp
  8019e2:	83 ec 04             	sub    $0x4,%esp
  8019e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019eb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019ee:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f5:	6a 00                	push   $0x0
  8019f7:	51                   	push   %ecx
  8019f8:	52                   	push   %edx
  8019f9:	ff 75 0c             	pushl  0xc(%ebp)
  8019fc:	50                   	push   %eax
  8019fd:	6a 1b                	push   $0x1b
  8019ff:	e8 19 fd ff ff       	call   80171d <syscall>
  801a04:	83 c4 18             	add    $0x18,%esp
}
  801a07:	c9                   	leave  
  801a08:	c3                   	ret    

00801a09 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a09:	55                   	push   %ebp
  801a0a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	52                   	push   %edx
  801a19:	50                   	push   %eax
  801a1a:	6a 1c                	push   $0x1c
  801a1c:	e8 fc fc ff ff       	call   80171d <syscall>
  801a21:	83 c4 18             	add    $0x18,%esp
}
  801a24:	c9                   	leave  
  801a25:	c3                   	ret    

00801a26 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a29:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	51                   	push   %ecx
  801a37:	52                   	push   %edx
  801a38:	50                   	push   %eax
  801a39:	6a 1d                	push   $0x1d
  801a3b:	e8 dd fc ff ff       	call   80171d <syscall>
  801a40:	83 c4 18             	add    $0x18,%esp
}
  801a43:	c9                   	leave  
  801a44:	c3                   	ret    

00801a45 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a45:	55                   	push   %ebp
  801a46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a48:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	52                   	push   %edx
  801a55:	50                   	push   %eax
  801a56:	6a 1e                	push   $0x1e
  801a58:	e8 c0 fc ff ff       	call   80171d <syscall>
  801a5d:	83 c4 18             	add    $0x18,%esp
}
  801a60:	c9                   	leave  
  801a61:	c3                   	ret    

00801a62 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a62:	55                   	push   %ebp
  801a63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 1f                	push   $0x1f
  801a71:	e8 a7 fc ff ff       	call   80171d <syscall>
  801a76:	83 c4 18             	add    $0x18,%esp
}
  801a79:	c9                   	leave  
  801a7a:	c3                   	ret    

00801a7b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a7b:	55                   	push   %ebp
  801a7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a81:	6a 00                	push   $0x0
  801a83:	ff 75 14             	pushl  0x14(%ebp)
  801a86:	ff 75 10             	pushl  0x10(%ebp)
  801a89:	ff 75 0c             	pushl  0xc(%ebp)
  801a8c:	50                   	push   %eax
  801a8d:	6a 20                	push   $0x20
  801a8f:	e8 89 fc ff ff       	call   80171d <syscall>
  801a94:	83 c4 18             	add    $0x18,%esp
}
  801a97:	c9                   	leave  
  801a98:	c3                   	ret    

00801a99 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	50                   	push   %eax
  801aa8:	6a 21                	push   $0x21
  801aaa:	e8 6e fc ff ff       	call   80171d <syscall>
  801aaf:	83 c4 18             	add    $0x18,%esp
}
  801ab2:	90                   	nop
  801ab3:	c9                   	leave  
  801ab4:	c3                   	ret    

00801ab5 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	50                   	push   %eax
  801ac4:	6a 22                	push   $0x22
  801ac6:	e8 52 fc ff ff       	call   80171d <syscall>
  801acb:	83 c4 18             	add    $0x18,%esp
}
  801ace:	c9                   	leave  
  801acf:	c3                   	ret    

00801ad0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ad0:	55                   	push   %ebp
  801ad1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 02                	push   $0x2
  801adf:	e8 39 fc ff ff       	call   80171d <syscall>
  801ae4:	83 c4 18             	add    $0x18,%esp
}
  801ae7:	c9                   	leave  
  801ae8:	c3                   	ret    

00801ae9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 03                	push   $0x3
  801af8:	e8 20 fc ff ff       	call   80171d <syscall>
  801afd:	83 c4 18             	add    $0x18,%esp
}
  801b00:	c9                   	leave  
  801b01:	c3                   	ret    

00801b02 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b02:	55                   	push   %ebp
  801b03:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 04                	push   $0x4
  801b11:	e8 07 fc ff ff       	call   80171d <syscall>
  801b16:	83 c4 18             	add    $0x18,%esp
}
  801b19:	c9                   	leave  
  801b1a:	c3                   	ret    

00801b1b <sys_exit_env>:


void sys_exit_env(void)
{
  801b1b:	55                   	push   %ebp
  801b1c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 23                	push   $0x23
  801b2a:	e8 ee fb ff ff       	call   80171d <syscall>
  801b2f:	83 c4 18             	add    $0x18,%esp
}
  801b32:	90                   	nop
  801b33:	c9                   	leave  
  801b34:	c3                   	ret    

00801b35 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
  801b38:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b3b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b3e:	8d 50 04             	lea    0x4(%eax),%edx
  801b41:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	52                   	push   %edx
  801b4b:	50                   	push   %eax
  801b4c:	6a 24                	push   $0x24
  801b4e:	e8 ca fb ff ff       	call   80171d <syscall>
  801b53:	83 c4 18             	add    $0x18,%esp
	return result;
  801b56:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b59:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b5c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b5f:	89 01                	mov    %eax,(%ecx)
  801b61:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b64:	8b 45 08             	mov    0x8(%ebp),%eax
  801b67:	c9                   	leave  
  801b68:	c2 04 00             	ret    $0x4

00801b6b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	ff 75 10             	pushl  0x10(%ebp)
  801b75:	ff 75 0c             	pushl  0xc(%ebp)
  801b78:	ff 75 08             	pushl  0x8(%ebp)
  801b7b:	6a 12                	push   $0x12
  801b7d:	e8 9b fb ff ff       	call   80171d <syscall>
  801b82:	83 c4 18             	add    $0x18,%esp
	return ;
  801b85:	90                   	nop
}
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 25                	push   $0x25
  801b97:	e8 81 fb ff ff       	call   80171d <syscall>
  801b9c:	83 c4 18             	add    $0x18,%esp
}
  801b9f:	c9                   	leave  
  801ba0:	c3                   	ret    

00801ba1 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
  801ba4:	83 ec 04             	sub    $0x4,%esp
  801ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  801baa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bad:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	50                   	push   %eax
  801bba:	6a 26                	push   $0x26
  801bbc:	e8 5c fb ff ff       	call   80171d <syscall>
  801bc1:	83 c4 18             	add    $0x18,%esp
	return ;
  801bc4:	90                   	nop
}
  801bc5:	c9                   	leave  
  801bc6:	c3                   	ret    

00801bc7 <rsttst>:
void rsttst()
{
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 28                	push   $0x28
  801bd6:	e8 42 fb ff ff       	call   80171d <syscall>
  801bdb:	83 c4 18             	add    $0x18,%esp
	return ;
  801bde:	90                   	nop
}
  801bdf:	c9                   	leave  
  801be0:	c3                   	ret    

00801be1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
  801be4:	83 ec 04             	sub    $0x4,%esp
  801be7:	8b 45 14             	mov    0x14(%ebp),%eax
  801bea:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801bed:	8b 55 18             	mov    0x18(%ebp),%edx
  801bf0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bf4:	52                   	push   %edx
  801bf5:	50                   	push   %eax
  801bf6:	ff 75 10             	pushl  0x10(%ebp)
  801bf9:	ff 75 0c             	pushl  0xc(%ebp)
  801bfc:	ff 75 08             	pushl  0x8(%ebp)
  801bff:	6a 27                	push   $0x27
  801c01:	e8 17 fb ff ff       	call   80171d <syscall>
  801c06:	83 c4 18             	add    $0x18,%esp
	return ;
  801c09:	90                   	nop
}
  801c0a:	c9                   	leave  
  801c0b:	c3                   	ret    

00801c0c <chktst>:
void chktst(uint32 n)
{
  801c0c:	55                   	push   %ebp
  801c0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	ff 75 08             	pushl  0x8(%ebp)
  801c1a:	6a 29                	push   $0x29
  801c1c:	e8 fc fa ff ff       	call   80171d <syscall>
  801c21:	83 c4 18             	add    $0x18,%esp
	return ;
  801c24:	90                   	nop
}
  801c25:	c9                   	leave  
  801c26:	c3                   	ret    

00801c27 <inctst>:

void inctst()
{
  801c27:	55                   	push   %ebp
  801c28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 2a                	push   $0x2a
  801c36:	e8 e2 fa ff ff       	call   80171d <syscall>
  801c3b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c3e:	90                   	nop
}
  801c3f:	c9                   	leave  
  801c40:	c3                   	ret    

00801c41 <gettst>:
uint32 gettst()
{
  801c41:	55                   	push   %ebp
  801c42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 2b                	push   $0x2b
  801c50:	e8 c8 fa ff ff       	call   80171d <syscall>
  801c55:	83 c4 18             	add    $0x18,%esp
}
  801c58:	c9                   	leave  
  801c59:	c3                   	ret    

00801c5a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
  801c5d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 2c                	push   $0x2c
  801c6c:	e8 ac fa ff ff       	call   80171d <syscall>
  801c71:	83 c4 18             	add    $0x18,%esp
  801c74:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c77:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c7b:	75 07                	jne    801c84 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c7d:	b8 01 00 00 00       	mov    $0x1,%eax
  801c82:	eb 05                	jmp    801c89 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c84:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c89:	c9                   	leave  
  801c8a:	c3                   	ret    

00801c8b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c8b:	55                   	push   %ebp
  801c8c:	89 e5                	mov    %esp,%ebp
  801c8e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 2c                	push   $0x2c
  801c9d:	e8 7b fa ff ff       	call   80171d <syscall>
  801ca2:	83 c4 18             	add    $0x18,%esp
  801ca5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ca8:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801cac:	75 07                	jne    801cb5 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801cae:	b8 01 00 00 00       	mov    $0x1,%eax
  801cb3:	eb 05                	jmp    801cba <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801cb5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cba:	c9                   	leave  
  801cbb:	c3                   	ret    

00801cbc <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801cbc:	55                   	push   %ebp
  801cbd:	89 e5                	mov    %esp,%ebp
  801cbf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 2c                	push   $0x2c
  801cce:	e8 4a fa ff ff       	call   80171d <syscall>
  801cd3:	83 c4 18             	add    $0x18,%esp
  801cd6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801cd9:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801cdd:	75 07                	jne    801ce6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801cdf:	b8 01 00 00 00       	mov    $0x1,%eax
  801ce4:	eb 05                	jmp    801ceb <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ce6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ceb:	c9                   	leave  
  801cec:	c3                   	ret    

00801ced <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ced:	55                   	push   %ebp
  801cee:	89 e5                	mov    %esp,%ebp
  801cf0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 2c                	push   $0x2c
  801cff:	e8 19 fa ff ff       	call   80171d <syscall>
  801d04:	83 c4 18             	add    $0x18,%esp
  801d07:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d0a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d0e:	75 07                	jne    801d17 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d10:	b8 01 00 00 00       	mov    $0x1,%eax
  801d15:	eb 05                	jmp    801d1c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d1c:	c9                   	leave  
  801d1d:	c3                   	ret    

00801d1e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d1e:	55                   	push   %ebp
  801d1f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	ff 75 08             	pushl  0x8(%ebp)
  801d2c:	6a 2d                	push   $0x2d
  801d2e:	e8 ea f9 ff ff       	call   80171d <syscall>
  801d33:	83 c4 18             	add    $0x18,%esp
	return ;
  801d36:	90                   	nop
}
  801d37:	c9                   	leave  
  801d38:	c3                   	ret    

00801d39 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d39:	55                   	push   %ebp
  801d3a:	89 e5                	mov    %esp,%ebp
  801d3c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d3d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d40:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d43:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d46:	8b 45 08             	mov    0x8(%ebp),%eax
  801d49:	6a 00                	push   $0x0
  801d4b:	53                   	push   %ebx
  801d4c:	51                   	push   %ecx
  801d4d:	52                   	push   %edx
  801d4e:	50                   	push   %eax
  801d4f:	6a 2e                	push   $0x2e
  801d51:	e8 c7 f9 ff ff       	call   80171d <syscall>
  801d56:	83 c4 18             	add    $0x18,%esp
}
  801d59:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d5c:	c9                   	leave  
  801d5d:	c3                   	ret    

00801d5e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d5e:	55                   	push   %ebp
  801d5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d61:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d64:	8b 45 08             	mov    0x8(%ebp),%eax
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	52                   	push   %edx
  801d6e:	50                   	push   %eax
  801d6f:	6a 2f                	push   $0x2f
  801d71:	e8 a7 f9 ff ff       	call   80171d <syscall>
  801d76:	83 c4 18             	add    $0x18,%esp
}
  801d79:	c9                   	leave  
  801d7a:	c3                   	ret    
  801d7b:	90                   	nop

00801d7c <__udivdi3>:
  801d7c:	55                   	push   %ebp
  801d7d:	57                   	push   %edi
  801d7e:	56                   	push   %esi
  801d7f:	53                   	push   %ebx
  801d80:	83 ec 1c             	sub    $0x1c,%esp
  801d83:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801d87:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801d8b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d8f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d93:	89 ca                	mov    %ecx,%edx
  801d95:	89 f8                	mov    %edi,%eax
  801d97:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801d9b:	85 f6                	test   %esi,%esi
  801d9d:	75 2d                	jne    801dcc <__udivdi3+0x50>
  801d9f:	39 cf                	cmp    %ecx,%edi
  801da1:	77 65                	ja     801e08 <__udivdi3+0x8c>
  801da3:	89 fd                	mov    %edi,%ebp
  801da5:	85 ff                	test   %edi,%edi
  801da7:	75 0b                	jne    801db4 <__udivdi3+0x38>
  801da9:	b8 01 00 00 00       	mov    $0x1,%eax
  801dae:	31 d2                	xor    %edx,%edx
  801db0:	f7 f7                	div    %edi
  801db2:	89 c5                	mov    %eax,%ebp
  801db4:	31 d2                	xor    %edx,%edx
  801db6:	89 c8                	mov    %ecx,%eax
  801db8:	f7 f5                	div    %ebp
  801dba:	89 c1                	mov    %eax,%ecx
  801dbc:	89 d8                	mov    %ebx,%eax
  801dbe:	f7 f5                	div    %ebp
  801dc0:	89 cf                	mov    %ecx,%edi
  801dc2:	89 fa                	mov    %edi,%edx
  801dc4:	83 c4 1c             	add    $0x1c,%esp
  801dc7:	5b                   	pop    %ebx
  801dc8:	5e                   	pop    %esi
  801dc9:	5f                   	pop    %edi
  801dca:	5d                   	pop    %ebp
  801dcb:	c3                   	ret    
  801dcc:	39 ce                	cmp    %ecx,%esi
  801dce:	77 28                	ja     801df8 <__udivdi3+0x7c>
  801dd0:	0f bd fe             	bsr    %esi,%edi
  801dd3:	83 f7 1f             	xor    $0x1f,%edi
  801dd6:	75 40                	jne    801e18 <__udivdi3+0x9c>
  801dd8:	39 ce                	cmp    %ecx,%esi
  801dda:	72 0a                	jb     801de6 <__udivdi3+0x6a>
  801ddc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801de0:	0f 87 9e 00 00 00    	ja     801e84 <__udivdi3+0x108>
  801de6:	b8 01 00 00 00       	mov    $0x1,%eax
  801deb:	89 fa                	mov    %edi,%edx
  801ded:	83 c4 1c             	add    $0x1c,%esp
  801df0:	5b                   	pop    %ebx
  801df1:	5e                   	pop    %esi
  801df2:	5f                   	pop    %edi
  801df3:	5d                   	pop    %ebp
  801df4:	c3                   	ret    
  801df5:	8d 76 00             	lea    0x0(%esi),%esi
  801df8:	31 ff                	xor    %edi,%edi
  801dfa:	31 c0                	xor    %eax,%eax
  801dfc:	89 fa                	mov    %edi,%edx
  801dfe:	83 c4 1c             	add    $0x1c,%esp
  801e01:	5b                   	pop    %ebx
  801e02:	5e                   	pop    %esi
  801e03:	5f                   	pop    %edi
  801e04:	5d                   	pop    %ebp
  801e05:	c3                   	ret    
  801e06:	66 90                	xchg   %ax,%ax
  801e08:	89 d8                	mov    %ebx,%eax
  801e0a:	f7 f7                	div    %edi
  801e0c:	31 ff                	xor    %edi,%edi
  801e0e:	89 fa                	mov    %edi,%edx
  801e10:	83 c4 1c             	add    $0x1c,%esp
  801e13:	5b                   	pop    %ebx
  801e14:	5e                   	pop    %esi
  801e15:	5f                   	pop    %edi
  801e16:	5d                   	pop    %ebp
  801e17:	c3                   	ret    
  801e18:	bd 20 00 00 00       	mov    $0x20,%ebp
  801e1d:	89 eb                	mov    %ebp,%ebx
  801e1f:	29 fb                	sub    %edi,%ebx
  801e21:	89 f9                	mov    %edi,%ecx
  801e23:	d3 e6                	shl    %cl,%esi
  801e25:	89 c5                	mov    %eax,%ebp
  801e27:	88 d9                	mov    %bl,%cl
  801e29:	d3 ed                	shr    %cl,%ebp
  801e2b:	89 e9                	mov    %ebp,%ecx
  801e2d:	09 f1                	or     %esi,%ecx
  801e2f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801e33:	89 f9                	mov    %edi,%ecx
  801e35:	d3 e0                	shl    %cl,%eax
  801e37:	89 c5                	mov    %eax,%ebp
  801e39:	89 d6                	mov    %edx,%esi
  801e3b:	88 d9                	mov    %bl,%cl
  801e3d:	d3 ee                	shr    %cl,%esi
  801e3f:	89 f9                	mov    %edi,%ecx
  801e41:	d3 e2                	shl    %cl,%edx
  801e43:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e47:	88 d9                	mov    %bl,%cl
  801e49:	d3 e8                	shr    %cl,%eax
  801e4b:	09 c2                	or     %eax,%edx
  801e4d:	89 d0                	mov    %edx,%eax
  801e4f:	89 f2                	mov    %esi,%edx
  801e51:	f7 74 24 0c          	divl   0xc(%esp)
  801e55:	89 d6                	mov    %edx,%esi
  801e57:	89 c3                	mov    %eax,%ebx
  801e59:	f7 e5                	mul    %ebp
  801e5b:	39 d6                	cmp    %edx,%esi
  801e5d:	72 19                	jb     801e78 <__udivdi3+0xfc>
  801e5f:	74 0b                	je     801e6c <__udivdi3+0xf0>
  801e61:	89 d8                	mov    %ebx,%eax
  801e63:	31 ff                	xor    %edi,%edi
  801e65:	e9 58 ff ff ff       	jmp    801dc2 <__udivdi3+0x46>
  801e6a:	66 90                	xchg   %ax,%ax
  801e6c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e70:	89 f9                	mov    %edi,%ecx
  801e72:	d3 e2                	shl    %cl,%edx
  801e74:	39 c2                	cmp    %eax,%edx
  801e76:	73 e9                	jae    801e61 <__udivdi3+0xe5>
  801e78:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801e7b:	31 ff                	xor    %edi,%edi
  801e7d:	e9 40 ff ff ff       	jmp    801dc2 <__udivdi3+0x46>
  801e82:	66 90                	xchg   %ax,%ax
  801e84:	31 c0                	xor    %eax,%eax
  801e86:	e9 37 ff ff ff       	jmp    801dc2 <__udivdi3+0x46>
  801e8b:	90                   	nop

00801e8c <__umoddi3>:
  801e8c:	55                   	push   %ebp
  801e8d:	57                   	push   %edi
  801e8e:	56                   	push   %esi
  801e8f:	53                   	push   %ebx
  801e90:	83 ec 1c             	sub    $0x1c,%esp
  801e93:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801e97:	8b 74 24 34          	mov    0x34(%esp),%esi
  801e9b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e9f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801ea3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ea7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801eab:	89 f3                	mov    %esi,%ebx
  801ead:	89 fa                	mov    %edi,%edx
  801eaf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801eb3:	89 34 24             	mov    %esi,(%esp)
  801eb6:	85 c0                	test   %eax,%eax
  801eb8:	75 1a                	jne    801ed4 <__umoddi3+0x48>
  801eba:	39 f7                	cmp    %esi,%edi
  801ebc:	0f 86 a2 00 00 00    	jbe    801f64 <__umoddi3+0xd8>
  801ec2:	89 c8                	mov    %ecx,%eax
  801ec4:	89 f2                	mov    %esi,%edx
  801ec6:	f7 f7                	div    %edi
  801ec8:	89 d0                	mov    %edx,%eax
  801eca:	31 d2                	xor    %edx,%edx
  801ecc:	83 c4 1c             	add    $0x1c,%esp
  801ecf:	5b                   	pop    %ebx
  801ed0:	5e                   	pop    %esi
  801ed1:	5f                   	pop    %edi
  801ed2:	5d                   	pop    %ebp
  801ed3:	c3                   	ret    
  801ed4:	39 f0                	cmp    %esi,%eax
  801ed6:	0f 87 ac 00 00 00    	ja     801f88 <__umoddi3+0xfc>
  801edc:	0f bd e8             	bsr    %eax,%ebp
  801edf:	83 f5 1f             	xor    $0x1f,%ebp
  801ee2:	0f 84 ac 00 00 00    	je     801f94 <__umoddi3+0x108>
  801ee8:	bf 20 00 00 00       	mov    $0x20,%edi
  801eed:	29 ef                	sub    %ebp,%edi
  801eef:	89 fe                	mov    %edi,%esi
  801ef1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ef5:	89 e9                	mov    %ebp,%ecx
  801ef7:	d3 e0                	shl    %cl,%eax
  801ef9:	89 d7                	mov    %edx,%edi
  801efb:	89 f1                	mov    %esi,%ecx
  801efd:	d3 ef                	shr    %cl,%edi
  801eff:	09 c7                	or     %eax,%edi
  801f01:	89 e9                	mov    %ebp,%ecx
  801f03:	d3 e2                	shl    %cl,%edx
  801f05:	89 14 24             	mov    %edx,(%esp)
  801f08:	89 d8                	mov    %ebx,%eax
  801f0a:	d3 e0                	shl    %cl,%eax
  801f0c:	89 c2                	mov    %eax,%edx
  801f0e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f12:	d3 e0                	shl    %cl,%eax
  801f14:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f18:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f1c:	89 f1                	mov    %esi,%ecx
  801f1e:	d3 e8                	shr    %cl,%eax
  801f20:	09 d0                	or     %edx,%eax
  801f22:	d3 eb                	shr    %cl,%ebx
  801f24:	89 da                	mov    %ebx,%edx
  801f26:	f7 f7                	div    %edi
  801f28:	89 d3                	mov    %edx,%ebx
  801f2a:	f7 24 24             	mull   (%esp)
  801f2d:	89 c6                	mov    %eax,%esi
  801f2f:	89 d1                	mov    %edx,%ecx
  801f31:	39 d3                	cmp    %edx,%ebx
  801f33:	0f 82 87 00 00 00    	jb     801fc0 <__umoddi3+0x134>
  801f39:	0f 84 91 00 00 00    	je     801fd0 <__umoddi3+0x144>
  801f3f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801f43:	29 f2                	sub    %esi,%edx
  801f45:	19 cb                	sbb    %ecx,%ebx
  801f47:	89 d8                	mov    %ebx,%eax
  801f49:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801f4d:	d3 e0                	shl    %cl,%eax
  801f4f:	89 e9                	mov    %ebp,%ecx
  801f51:	d3 ea                	shr    %cl,%edx
  801f53:	09 d0                	or     %edx,%eax
  801f55:	89 e9                	mov    %ebp,%ecx
  801f57:	d3 eb                	shr    %cl,%ebx
  801f59:	89 da                	mov    %ebx,%edx
  801f5b:	83 c4 1c             	add    $0x1c,%esp
  801f5e:	5b                   	pop    %ebx
  801f5f:	5e                   	pop    %esi
  801f60:	5f                   	pop    %edi
  801f61:	5d                   	pop    %ebp
  801f62:	c3                   	ret    
  801f63:	90                   	nop
  801f64:	89 fd                	mov    %edi,%ebp
  801f66:	85 ff                	test   %edi,%edi
  801f68:	75 0b                	jne    801f75 <__umoddi3+0xe9>
  801f6a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f6f:	31 d2                	xor    %edx,%edx
  801f71:	f7 f7                	div    %edi
  801f73:	89 c5                	mov    %eax,%ebp
  801f75:	89 f0                	mov    %esi,%eax
  801f77:	31 d2                	xor    %edx,%edx
  801f79:	f7 f5                	div    %ebp
  801f7b:	89 c8                	mov    %ecx,%eax
  801f7d:	f7 f5                	div    %ebp
  801f7f:	89 d0                	mov    %edx,%eax
  801f81:	e9 44 ff ff ff       	jmp    801eca <__umoddi3+0x3e>
  801f86:	66 90                	xchg   %ax,%ax
  801f88:	89 c8                	mov    %ecx,%eax
  801f8a:	89 f2                	mov    %esi,%edx
  801f8c:	83 c4 1c             	add    $0x1c,%esp
  801f8f:	5b                   	pop    %ebx
  801f90:	5e                   	pop    %esi
  801f91:	5f                   	pop    %edi
  801f92:	5d                   	pop    %ebp
  801f93:	c3                   	ret    
  801f94:	3b 04 24             	cmp    (%esp),%eax
  801f97:	72 06                	jb     801f9f <__umoddi3+0x113>
  801f99:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801f9d:	77 0f                	ja     801fae <__umoddi3+0x122>
  801f9f:	89 f2                	mov    %esi,%edx
  801fa1:	29 f9                	sub    %edi,%ecx
  801fa3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801fa7:	89 14 24             	mov    %edx,(%esp)
  801faa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801fae:	8b 44 24 04          	mov    0x4(%esp),%eax
  801fb2:	8b 14 24             	mov    (%esp),%edx
  801fb5:	83 c4 1c             	add    $0x1c,%esp
  801fb8:	5b                   	pop    %ebx
  801fb9:	5e                   	pop    %esi
  801fba:	5f                   	pop    %edi
  801fbb:	5d                   	pop    %ebp
  801fbc:	c3                   	ret    
  801fbd:	8d 76 00             	lea    0x0(%esi),%esi
  801fc0:	2b 04 24             	sub    (%esp),%eax
  801fc3:	19 fa                	sbb    %edi,%edx
  801fc5:	89 d1                	mov    %edx,%ecx
  801fc7:	89 c6                	mov    %eax,%esi
  801fc9:	e9 71 ff ff ff       	jmp    801f3f <__umoddi3+0xb3>
  801fce:	66 90                	xchg   %ax,%ax
  801fd0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801fd4:	72 ea                	jb     801fc0 <__umoddi3+0x134>
  801fd6:	89 d9                	mov    %ebx,%ecx
  801fd8:	e9 62 ff ff ff       	jmp    801f3f <__umoddi3+0xb3>
