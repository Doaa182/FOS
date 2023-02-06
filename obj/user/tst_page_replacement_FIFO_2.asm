
obj/user/tst_page_replacement_FIFO_2:     file format elf32-i386


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
  800031:	e8 33 07 00 00       	call   800769 <libmain>
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
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec bc 00 00 00    	sub    $0xbc,%esp

//	cprintf("envID = %d\n",envID);



	char* tempArr = (char*)0x80000000;
  800044:	c7 45 cc 00 00 00 80 	movl   $0x80000000,-0x34(%ebp)
	//sys_allocateMem(0x80000000, 15*1024);

	//("STEP 0: checking Initial WS entries ...\n");
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=   0x200000)  	panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80004b:	a1 20 30 80 00       	mov    0x803020,%eax
  800050:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800056:	8b 00                	mov    (%eax),%eax
  800058:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80005b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80005e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800063:	3d 00 00 20 00       	cmp    $0x200000,%eax
  800068:	74 14                	je     80007e <_main+0x46>
  80006a:	83 ec 04             	sub    $0x4,%esp
  80006d:	68 c0 21 80 00       	push   $0x8021c0
  800072:	6a 17                	push   $0x17
  800074:	68 04 22 80 00       	push   $0x802204
  800079:	e8 27 08 00 00       	call   8008a5 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=   0x201000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80007e:	a1 20 30 80 00       	mov    0x803020,%eax
  800083:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800089:	83 c0 18             	add    $0x18,%eax
  80008c:	8b 00                	mov    (%eax),%eax
  80008e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800091:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800094:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800099:	3d 00 10 20 00       	cmp    $0x201000,%eax
  80009e:	74 14                	je     8000b4 <_main+0x7c>
  8000a0:	83 ec 04             	sub    $0x4,%esp
  8000a3:	68 c0 21 80 00       	push   $0x8021c0
  8000a8:	6a 18                	push   $0x18
  8000aa:	68 04 22 80 00       	push   $0x802204
  8000af:	e8 f1 07 00 00       	call   8008a5 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=   0x202000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000b4:	a1 20 30 80 00       	mov    0x803020,%eax
  8000b9:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8000bf:	83 c0 30             	add    $0x30,%eax
  8000c2:	8b 00                	mov    (%eax),%eax
  8000c4:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8000c7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8000ca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000cf:	3d 00 20 20 00       	cmp    $0x202000,%eax
  8000d4:	74 14                	je     8000ea <_main+0xb2>
  8000d6:	83 ec 04             	sub    $0x4,%esp
  8000d9:	68 c0 21 80 00       	push   $0x8021c0
  8000de:	6a 19                	push   $0x19
  8000e0:	68 04 22 80 00       	push   $0x802204
  8000e5:	e8 bb 07 00 00       	call   8008a5 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=   0x203000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000ea:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ef:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8000f5:	83 c0 48             	add    $0x48,%eax
  8000f8:	8b 00                	mov    (%eax),%eax
  8000fa:	89 45 bc             	mov    %eax,-0x44(%ebp)
  8000fd:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800100:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800105:	3d 00 30 20 00       	cmp    $0x203000,%eax
  80010a:	74 14                	je     800120 <_main+0xe8>
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	68 c0 21 80 00       	push   $0x8021c0
  800114:	6a 1a                	push   $0x1a
  800116:	68 04 22 80 00       	push   $0x802204
  80011b:	e8 85 07 00 00       	call   8008a5 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=   0x204000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800120:	a1 20 30 80 00       	mov    0x803020,%eax
  800125:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80012b:	83 c0 60             	add    $0x60,%eax
  80012e:	8b 00                	mov    (%eax),%eax
  800130:	89 45 b8             	mov    %eax,-0x48(%ebp)
  800133:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800136:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80013b:	3d 00 40 20 00       	cmp    $0x204000,%eax
  800140:	74 14                	je     800156 <_main+0x11e>
  800142:	83 ec 04             	sub    $0x4,%esp
  800145:	68 c0 21 80 00       	push   $0x8021c0
  80014a:	6a 1b                	push   $0x1b
  80014c:	68 04 22 80 00       	push   $0x802204
  800151:	e8 4f 07 00 00       	call   8008a5 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=   0x205000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800156:	a1 20 30 80 00       	mov    0x803020,%eax
  80015b:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800161:	83 c0 78             	add    $0x78,%eax
  800164:	8b 00                	mov    (%eax),%eax
  800166:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  800169:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80016c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800171:	3d 00 50 20 00       	cmp    $0x205000,%eax
  800176:	74 14                	je     80018c <_main+0x154>
  800178:	83 ec 04             	sub    $0x4,%esp
  80017b:	68 c0 21 80 00       	push   $0x8021c0
  800180:	6a 1c                	push   $0x1c
  800182:	68 04 22 80 00       	push   $0x802204
  800187:	e8 19 07 00 00       	call   8008a5 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=   0x800000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80018c:	a1 20 30 80 00       	mov    0x803020,%eax
  800191:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800197:	05 90 00 00 00       	add    $0x90,%eax
  80019c:	8b 00                	mov    (%eax),%eax
  80019e:	89 45 b0             	mov    %eax,-0x50(%ebp)
  8001a1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8001a4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001a9:	3d 00 00 80 00       	cmp    $0x800000,%eax
  8001ae:	74 14                	je     8001c4 <_main+0x18c>
  8001b0:	83 ec 04             	sub    $0x4,%esp
  8001b3:	68 c0 21 80 00       	push   $0x8021c0
  8001b8:	6a 1d                	push   $0x1d
  8001ba:	68 04 22 80 00       	push   $0x802204
  8001bf:	e8 e1 06 00 00       	call   8008a5 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x801000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001c4:	a1 20 30 80 00       	mov    0x803020,%eax
  8001c9:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8001cf:	05 a8 00 00 00       	add    $0xa8,%eax
  8001d4:	8b 00                	mov    (%eax),%eax
  8001d6:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8001d9:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8001dc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001e1:	3d 00 10 80 00       	cmp    $0x801000,%eax
  8001e6:	74 14                	je     8001fc <_main+0x1c4>
  8001e8:	83 ec 04             	sub    $0x4,%esp
  8001eb:	68 c0 21 80 00       	push   $0x8021c0
  8001f0:	6a 1e                	push   $0x1e
  8001f2:	68 04 22 80 00       	push   $0x802204
  8001f7:	e8 a9 06 00 00       	call   8008a5 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=   0x802000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001fc:	a1 20 30 80 00       	mov    0x803020,%eax
  800201:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800207:	05 c0 00 00 00       	add    $0xc0,%eax
  80020c:	8b 00                	mov    (%eax),%eax
  80020e:	89 45 a8             	mov    %eax,-0x58(%ebp)
  800211:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800214:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800219:	3d 00 20 80 00       	cmp    $0x802000,%eax
  80021e:	74 14                	je     800234 <_main+0x1fc>
  800220:	83 ec 04             	sub    $0x4,%esp
  800223:	68 c0 21 80 00       	push   $0x8021c0
  800228:	6a 1f                	push   $0x1f
  80022a:	68 04 22 80 00       	push   $0x802204
  80022f:	e8 71 06 00 00       	call   8008a5 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0x803000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800234:	a1 20 30 80 00       	mov    0x803020,%eax
  800239:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80023f:	05 d8 00 00 00       	add    $0xd8,%eax
  800244:	8b 00                	mov    (%eax),%eax
  800246:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  800249:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80024c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800251:	3d 00 30 80 00       	cmp    $0x803000,%eax
  800256:	74 14                	je     80026c <_main+0x234>
  800258:	83 ec 04             	sub    $0x4,%esp
  80025b:	68 c0 21 80 00       	push   $0x8021c0
  800260:	6a 20                	push   $0x20
  800262:	68 04 22 80 00       	push   $0x802204
  800267:	e8 39 06 00 00       	call   8008a5 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[10].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80026c:	a1 20 30 80 00       	mov    0x803020,%eax
  800271:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800277:	05 f0 00 00 00       	add    $0xf0,%eax
  80027c:	8b 00                	mov    (%eax),%eax
  80027e:	89 45 a0             	mov    %eax,-0x60(%ebp)
  800281:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800284:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800289:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  80028e:	74 14                	je     8002a4 <_main+0x26c>
  800290:	83 ec 04             	sub    $0x4,%esp
  800293:	68 c0 21 80 00       	push   $0x8021c0
  800298:	6a 21                	push   $0x21
  80029a:	68 04 22 80 00       	push   $0x802204
  80029f:	e8 01 06 00 00       	call   8008a5 <_panic>
		if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
  8002a4:	a1 20 30 80 00       	mov    0x803020,%eax
  8002a9:	8b 80 2c 05 00 00    	mov    0x52c(%eax),%eax
  8002af:	85 c0                	test   %eax,%eax
  8002b1:	74 14                	je     8002c7 <_main+0x28f>
  8002b3:	83 ec 04             	sub    $0x4,%esp
  8002b6:	68 28 22 80 00       	push   $0x802228
  8002bb:	6a 22                	push   $0x22
  8002bd:	68 04 22 80 00       	push   $0x802204
  8002c2:	e8 de 05 00 00       	call   8008a5 <_panic>
	}

	int freePages = sys_calculate_free_frames();
  8002c7:	e8 03 17 00 00       	call   8019cf <sys_calculate_free_frames>
  8002cc:	89 45 9c             	mov    %eax,-0x64(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  8002cf:	e8 9b 17 00 00       	call   801a6f <sys_pf_calculate_allocated_pages>
  8002d4:	89 45 98             	mov    %eax,-0x68(%ebp)

	//Reading (Not Modified)
	char garbage1 = arr[PAGE_SIZE*11-1];
  8002d7:	a0 5f e0 80 00       	mov    0x80e05f,%al
  8002dc:	88 45 97             	mov    %al,-0x69(%ebp)
	char garbage2 = arr[PAGE_SIZE*12-1];
  8002df:	a0 5f f0 80 00       	mov    0x80f05f,%al
  8002e4:	88 45 96             	mov    %al,-0x6a(%ebp)
	char garbage4, garbage5;

	//Writing (Modified)
	int i;
	for (i = 0 ; i < PAGE_SIZE*5 ; i+=PAGE_SIZE/2)
  8002e7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8002ee:	eb 26                	jmp    800316 <_main+0x2de>
	{
		arr[i] = -1 ;
  8002f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002f3:	05 60 30 80 00       	add    $0x803060,%eax
  8002f8:	c6 00 ff             	movb   $0xff,(%eax)
		/*2016: this BUGGY line is REMOVED el7! it overwrites the KERNEL CODE :( !!!*/
		//*ptr = *ptr2 ;
		//ptr++ ; ptr2++ ;
		/*==========================================================================*/
		//always use pages at 0x801000 and 0x804000
		garbage4 = *ptr ;
  8002fb:	a1 00 30 80 00       	mov    0x803000,%eax
  800300:	8a 00                	mov    (%eax),%al
  800302:	88 45 e7             	mov    %al,-0x19(%ebp)
		garbage5 = *ptr2 ;
  800305:	a1 04 30 80 00       	mov    0x803004,%eax
  80030a:	8a 00                	mov    (%eax),%al
  80030c:	88 45 e6             	mov    %al,-0x1a(%ebp)
	char garbage2 = arr[PAGE_SIZE*12-1];
	char garbage4, garbage5;

	//Writing (Modified)
	int i;
	for (i = 0 ; i < PAGE_SIZE*5 ; i+=PAGE_SIZE/2)
  80030f:	81 45 e0 00 08 00 00 	addl   $0x800,-0x20(%ebp)
  800316:	81 7d e0 ff 4f 00 00 	cmpl   $0x4fff,-0x20(%ebp)
  80031d:	7e d1                	jle    8002f0 <_main+0x2b8>
		garbage5 = *ptr2 ;
	}

	//Check FIFO 1
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=  0x80e000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  80031f:	a1 20 30 80 00       	mov    0x803020,%eax
  800324:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80032a:	8b 00                	mov    (%eax),%eax
  80032c:	89 45 90             	mov    %eax,-0x70(%ebp)
  80032f:	8b 45 90             	mov    -0x70(%ebp),%eax
  800332:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800337:	3d 00 e0 80 00       	cmp    $0x80e000,%eax
  80033c:	74 14                	je     800352 <_main+0x31a>
  80033e:	83 ec 04             	sub    $0x4,%esp
  800341:	68 70 22 80 00       	push   $0x802270
  800346:	6a 3d                	push   $0x3d
  800348:	68 04 22 80 00       	push   $0x802204
  80034d:	e8 53 05 00 00       	call   8008a5 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=  0x80f000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  800352:	a1 20 30 80 00       	mov    0x803020,%eax
  800357:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80035d:	83 c0 18             	add    $0x18,%eax
  800360:	8b 00                	mov    (%eax),%eax
  800362:	89 45 8c             	mov    %eax,-0x74(%ebp)
  800365:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800368:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80036d:	3d 00 f0 80 00       	cmp    $0x80f000,%eax
  800372:	74 14                	je     800388 <_main+0x350>
  800374:	83 ec 04             	sub    $0x4,%esp
  800377:	68 70 22 80 00       	push   $0x802270
  80037c:	6a 3e                	push   $0x3e
  80037e:	68 04 22 80 00       	push   $0x802204
  800383:	e8 1d 05 00 00       	call   8008a5 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=  0x804000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  800388:	a1 20 30 80 00       	mov    0x803020,%eax
  80038d:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800393:	83 c0 30             	add    $0x30,%eax
  800396:	8b 00                	mov    (%eax),%eax
  800398:	89 45 88             	mov    %eax,-0x78(%ebp)
  80039b:	8b 45 88             	mov    -0x78(%ebp),%eax
  80039e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003a3:	3d 00 40 80 00       	cmp    $0x804000,%eax
  8003a8:	74 14                	je     8003be <_main+0x386>
  8003aa:	83 ec 04             	sub    $0x4,%esp
  8003ad:	68 70 22 80 00       	push   $0x802270
  8003b2:	6a 3f                	push   $0x3f
  8003b4:	68 04 22 80 00       	push   $0x802204
  8003b9:	e8 e7 04 00 00       	call   8008a5 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=  0x805000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  8003be:	a1 20 30 80 00       	mov    0x803020,%eax
  8003c3:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8003c9:	83 c0 48             	add    $0x48,%eax
  8003cc:	8b 00                	mov    (%eax),%eax
  8003ce:	89 45 84             	mov    %eax,-0x7c(%ebp)
  8003d1:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8003d4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003d9:	3d 00 50 80 00       	cmp    $0x805000,%eax
  8003de:	74 14                	je     8003f4 <_main+0x3bc>
  8003e0:	83 ec 04             	sub    $0x4,%esp
  8003e3:	68 70 22 80 00       	push   $0x802270
  8003e8:	6a 40                	push   $0x40
  8003ea:	68 04 22 80 00       	push   $0x802204
  8003ef:	e8 b1 04 00 00       	call   8008a5 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=  0x806000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  8003f4:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f9:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8003ff:	83 c0 60             	add    $0x60,%eax
  800402:	8b 00                	mov    (%eax),%eax
  800404:	89 45 80             	mov    %eax,-0x80(%ebp)
  800407:	8b 45 80             	mov    -0x80(%ebp),%eax
  80040a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80040f:	3d 00 60 80 00       	cmp    $0x806000,%eax
  800414:	74 14                	je     80042a <_main+0x3f2>
  800416:	83 ec 04             	sub    $0x4,%esp
  800419:	68 70 22 80 00       	push   $0x802270
  80041e:	6a 41                	push   $0x41
  800420:	68 04 22 80 00       	push   $0x802204
  800425:	e8 7b 04 00 00       	call   8008a5 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=  0x807000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  80042a:	a1 20 30 80 00       	mov    0x803020,%eax
  80042f:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800435:	83 c0 78             	add    $0x78,%eax
  800438:	8b 00                	mov    (%eax),%eax
  80043a:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  800440:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800446:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80044b:	3d 00 70 80 00       	cmp    $0x807000,%eax
  800450:	74 14                	je     800466 <_main+0x42e>
  800452:	83 ec 04             	sub    $0x4,%esp
  800455:	68 70 22 80 00       	push   $0x802270
  80045a:	6a 42                	push   $0x42
  80045c:	68 04 22 80 00       	push   $0x802204
  800461:	e8 3f 04 00 00       	call   8008a5 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=  0x800000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  800466:	a1 20 30 80 00       	mov    0x803020,%eax
  80046b:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800471:	05 90 00 00 00       	add    $0x90,%eax
  800476:	8b 00                	mov    (%eax),%eax
  800478:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  80047e:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800484:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800489:	3d 00 00 80 00       	cmp    $0x800000,%eax
  80048e:	74 14                	je     8004a4 <_main+0x46c>
  800490:	83 ec 04             	sub    $0x4,%esp
  800493:	68 70 22 80 00       	push   $0x802270
  800498:	6a 43                	push   $0x43
  80049a:	68 04 22 80 00       	push   $0x802204
  80049f:	e8 01 04 00 00       	call   8008a5 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=  0x801000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  8004a4:	a1 20 30 80 00       	mov    0x803020,%eax
  8004a9:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8004af:	05 a8 00 00 00       	add    $0xa8,%eax
  8004b4:	8b 00                	mov    (%eax),%eax
  8004b6:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
  8004bc:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8004c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004c7:	3d 00 10 80 00       	cmp    $0x801000,%eax
  8004cc:	74 14                	je     8004e2 <_main+0x4aa>
  8004ce:	83 ec 04             	sub    $0x4,%esp
  8004d1:	68 70 22 80 00       	push   $0x802270
  8004d6:	6a 44                	push   $0x44
  8004d8:	68 04 22 80 00       	push   $0x802204
  8004dd:	e8 c3 03 00 00       	call   8008a5 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=  0x802000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  8004e2:	a1 20 30 80 00       	mov    0x803020,%eax
  8004e7:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8004ed:	05 c0 00 00 00       	add    $0xc0,%eax
  8004f2:	8b 00                	mov    (%eax),%eax
  8004f4:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
  8004fa:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800500:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800505:	3d 00 20 80 00       	cmp    $0x802000,%eax
  80050a:	74 14                	je     800520 <_main+0x4e8>
  80050c:	83 ec 04             	sub    $0x4,%esp
  80050f:	68 70 22 80 00       	push   $0x802270
  800514:	6a 45                	push   $0x45
  800516:	68 04 22 80 00       	push   $0x802204
  80051b:	e8 85 03 00 00       	call   8008a5 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=  0x803000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  800520:	a1 20 30 80 00       	mov    0x803020,%eax
  800525:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80052b:	05 d8 00 00 00       	add    $0xd8,%eax
  800530:	8b 00                	mov    (%eax),%eax
  800532:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  800538:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  80053e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800543:	3d 00 30 80 00       	cmp    $0x803000,%eax
  800548:	74 14                	je     80055e <_main+0x526>
  80054a:	83 ec 04             	sub    $0x4,%esp
  80054d:	68 70 22 80 00       	push   $0x802270
  800552:	6a 46                	push   $0x46
  800554:	68 04 22 80 00       	push   $0x802204
  800559:	e8 47 03 00 00       	call   8008a5 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[10].virtual_address,PAGE_SIZE) !=  0xeebfd000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  80055e:	a1 20 30 80 00       	mov    0x803020,%eax
  800563:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800569:	05 f0 00 00 00       	add    $0xf0,%eax
  80056e:	8b 00                	mov    (%eax),%eax
  800570:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
  800576:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  80057c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800581:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  800586:	74 14                	je     80059c <_main+0x564>
  800588:	83 ec 04             	sub    $0x4,%esp
  80058b:	68 70 22 80 00       	push   $0x802270
  800590:	6a 47                	push   $0x47
  800592:	68 04 22 80 00       	push   $0x802204
  800597:	e8 09 03 00 00       	call   8008a5 <_panic>

		if(myEnv->page_last_WS_index != 6) panic("wrong PAGE WS pointer location");
  80059c:	a1 20 30 80 00       	mov    0x803020,%eax
  8005a1:	8b 80 2c 05 00 00    	mov    0x52c(%eax),%eax
  8005a7:	83 f8 06             	cmp    $0x6,%eax
  8005aa:	74 14                	je     8005c0 <_main+0x588>
  8005ac:	83 ec 04             	sub    $0x4,%esp
  8005af:	68 bc 22 80 00       	push   $0x8022bc
  8005b4:	6a 49                	push   $0x49
  8005b6:	68 04 22 80 00       	push   $0x802204
  8005bb:	e8 e5 02 00 00       	call   8008a5 <_panic>
	}

	sys_allocate_user_mem(0x80000000, 4*PAGE_SIZE);
  8005c0:	83 ec 08             	sub    $0x8,%esp
  8005c3:	68 00 40 00 00       	push   $0x4000
  8005c8:	68 00 00 00 80       	push   $0x80000000
  8005cd:	e8 64 14 00 00       	call   801a36 <sys_allocate_user_mem>
  8005d2:	83 c4 10             	add    $0x10,%esp
	//cprintf("1\n");

	int c;
	for(c = 0;c< 15*1024;c++)
  8005d5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8005dc:	eb 0e                	jmp    8005ec <_main+0x5b4>
	{
		tempArr[c] = 'a';
  8005de:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8005e1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005e4:	01 d0                	add    %edx,%eax
  8005e6:	c6 00 61             	movb   $0x61,(%eax)

	sys_allocate_user_mem(0x80000000, 4*PAGE_SIZE);
	//cprintf("1\n");

	int c;
	for(c = 0;c< 15*1024;c++)
  8005e9:	ff 45 dc             	incl   -0x24(%ebp)
  8005ec:	81 7d dc ff 3b 00 00 	cmpl   $0x3bff,-0x24(%ebp)
  8005f3:	7e e9                	jle    8005de <_main+0x5a6>
		tempArr[c] = 'a';
	}

	//cprintf("2\n");

	sys_free_user_mem(0x80000000, 4*PAGE_SIZE);
  8005f5:	83 ec 08             	sub    $0x8,%esp
  8005f8:	68 00 40 00 00       	push   $0x4000
  8005fd:	68 00 00 00 80       	push   $0x80000000
  800602:	e8 13 14 00 00       	call   801a1a <sys_free_user_mem>
  800607:	83 c4 10             	add    $0x10,%esp
	//cprintf("3\n");

	//Check after free either push records up or leave them empty
	for (i = PAGE_SIZE*5 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  80060a:	c7 45 e0 00 50 00 00 	movl   $0x5000,-0x20(%ebp)
  800611:	eb 26                	jmp    800639 <_main+0x601>
	{
		arr[i] = -1 ;
  800613:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800616:	05 60 30 80 00       	add    $0x803060,%eax
  80061b:	c6 00 ff             	movb   $0xff,(%eax)
		//always use pages at 0x801000 and 0x804000
		garbage4 = *ptr ;
  80061e:	a1 00 30 80 00       	mov    0x803000,%eax
  800623:	8a 00                	mov    (%eax),%al
  800625:	88 45 e7             	mov    %al,-0x19(%ebp)
		garbage5 = *ptr2 ;
  800628:	a1 04 30 80 00       	mov    0x803004,%eax
  80062d:	8a 00                	mov    (%eax),%al
  80062f:	88 45 e6             	mov    %al,-0x1a(%ebp)

	sys_free_user_mem(0x80000000, 4*PAGE_SIZE);
	//cprintf("3\n");

	//Check after free either push records up or leave them empty
	for (i = PAGE_SIZE*5 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800632:	81 45 e0 00 08 00 00 	addl   $0x800,-0x20(%ebp)
  800639:	81 7d e0 ff 9f 00 00 	cmpl   $0x9fff,-0x20(%ebp)
  800640:	7e d1                	jle    800613 <_main+0x5db>
		garbage5 = *ptr2 ;
	}
	//cprintf("4\n");

	//===================
	uint32 finalPageNums[11] = {0x800000,0x801000,0x802000,0x803000,0x804000,0x808000,0x809000,0x80a000,0x80b000,0x80c000,0xeebfd000};
  800642:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
  800648:	bb 60 23 80 00       	mov    $0x802360,%ebx
  80064d:	ba 0b 00 00 00       	mov    $0xb,%edx
  800652:	89 c7                	mov    %eax,%edi
  800654:	89 de                	mov    %ebx,%esi
  800656:	89 d1                	mov    %edx,%ecx
  800658:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

	//cprintf("Checking PAGE FIFO algorithm after Free and replacement... \n");
	{
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80065a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800661:	e9 97 00 00 00       	jmp    8006fd <_main+0x6c5>
		{
			uint8 found = 0;
  800666:	c6 45 d7 00          	movb   $0x0,-0x29(%ebp)
			for (int j = 0; j < myEnv->page_WS_max_size; ++j)
  80066a:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  800671:	eb 43                	jmp    8006b6 <_main+0x67e>
			{
				if(finalPageNums[i] == ROUNDDOWN(myEnv->__uptr_pws[j].virtual_address,PAGE_SIZE))
  800673:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800676:	8b 8c 85 38 ff ff ff 	mov    -0xc8(%ebp,%eax,4),%ecx
  80067d:	a1 20 30 80 00       	mov    0x803020,%eax
  800682:	8b 98 9c 05 00 00    	mov    0x59c(%eax),%ebx
  800688:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80068b:	89 d0                	mov    %edx,%eax
  80068d:	01 c0                	add    %eax,%eax
  80068f:	01 d0                	add    %edx,%eax
  800691:	c1 e0 03             	shl    $0x3,%eax
  800694:	01 d8                	add    %ebx,%eax
  800696:	8b 00                	mov    (%eax),%eax
  800698:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  80069e:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8006a4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8006a9:	39 c1                	cmp    %eax,%ecx
  8006ab:	75 06                	jne    8006b3 <_main+0x67b>
				{
					found = 1;
  8006ad:	c6 45 d7 01          	movb   $0x1,-0x29(%ebp)
					break;
  8006b1:	eb 12                	jmp    8006c5 <_main+0x68d>
	//cprintf("Checking PAGE FIFO algorithm after Free and replacement... \n");
	{
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
		{
			uint8 found = 0;
			for (int j = 0; j < myEnv->page_WS_max_size; ++j)
  8006b3:	ff 45 d0             	incl   -0x30(%ebp)
  8006b6:	a1 20 30 80 00       	mov    0x803020,%eax
  8006bb:	8b 50 74             	mov    0x74(%eax),%edx
  8006be:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006c1:	39 c2                	cmp    %eax,%edx
  8006c3:	77 ae                	ja     800673 <_main+0x63b>
				{
					found = 1;
					break;
				}
			}
			if (found == 0)
  8006c5:	80 7d d7 00          	cmpb   $0x0,-0x29(%ebp)
  8006c9:	75 2f                	jne    8006fa <_main+0x6c2>
			{
				cprintf("%x NOT FOUND\n", finalPageNums[i]);
  8006cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006ce:	8b 84 85 38 ff ff ff 	mov    -0xc8(%ebp,%eax,4),%eax
  8006d5:	83 ec 08             	sub    $0x8,%esp
  8006d8:	50                   	push   %eax
  8006d9:	68 db 22 80 00       	push   $0x8022db
  8006de:	e8 76 04 00 00       	call   800b59 <cprintf>
  8006e3:	83 c4 10             	add    $0x10,%esp
				panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  8006e6:	83 ec 04             	sub    $0x4,%esp
  8006e9:	68 70 22 80 00       	push   $0x802270
  8006ee:	6a 77                	push   $0x77
  8006f0:	68 04 22 80 00       	push   $0x802204
  8006f5:	e8 ab 01 00 00       	call   8008a5 <_panic>
	//===================
	uint32 finalPageNums[11] = {0x800000,0x801000,0x802000,0x803000,0x804000,0x808000,0x809000,0x80a000,0x80b000,0x80c000,0xeebfd000};

	//cprintf("Checking PAGE FIFO algorithm after Free and replacement... \n");
	{
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  8006fa:	ff 45 d8             	incl   -0x28(%ebp)
  8006fd:	a1 20 30 80 00       	mov    0x803020,%eax
  800702:	8b 50 74             	mov    0x74(%eax),%edx
  800705:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800708:	39 c2                	cmp    %eax,%edx
  80070a:	0f 87 56 ff ff ff    	ja     800666 <_main+0x62e>
			}
		}
	}

	{
		if (garbage4 != *ptr) panic("test failed!");
  800710:	a1 00 30 80 00       	mov    0x803000,%eax
  800715:	8a 00                	mov    (%eax),%al
  800717:	3a 45 e7             	cmp    -0x19(%ebp),%al
  80071a:	74 14                	je     800730 <_main+0x6f8>
  80071c:	83 ec 04             	sub    $0x4,%esp
  80071f:	68 e9 22 80 00       	push   $0x8022e9
  800724:	6a 7d                	push   $0x7d
  800726:	68 04 22 80 00       	push   $0x802204
  80072b:	e8 75 01 00 00       	call   8008a5 <_panic>
		if (garbage5 != *ptr2) panic("test failed!");
  800730:	a1 04 30 80 00       	mov    0x803004,%eax
  800735:	8a 00                	mov    (%eax),%al
  800737:	3a 45 e6             	cmp    -0x1a(%ebp),%al
  80073a:	74 14                	je     800750 <_main+0x718>
  80073c:	83 ec 04             	sub    $0x4,%esp
  80073f:	68 e9 22 80 00       	push   $0x8022e9
  800744:	6a 7e                	push   $0x7e
  800746:	68 04 22 80 00       	push   $0x802204
  80074b:	e8 55 01 00 00       	call   8008a5 <_panic>
	}

	cprintf("Congratulations!! test PAGE replacement [FIFO 2] is completed successfully.\n");
  800750:	83 ec 0c             	sub    $0xc,%esp
  800753:	68 f8 22 80 00       	push   $0x8022f8
  800758:	e8 fc 03 00 00       	call   800b59 <cprintf>
  80075d:	83 c4 10             	add    $0x10,%esp
	return;
  800760:	90                   	nop
}
  800761:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800764:	5b                   	pop    %ebx
  800765:	5e                   	pop    %esi
  800766:	5f                   	pop    %edi
  800767:	5d                   	pop    %ebp
  800768:	c3                   	ret    

00800769 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800769:	55                   	push   %ebp
  80076a:	89 e5                	mov    %esp,%ebp
  80076c:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80076f:	e8 3b 15 00 00       	call   801caf <sys_getenvindex>
  800774:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800777:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80077a:	89 d0                	mov    %edx,%eax
  80077c:	c1 e0 03             	shl    $0x3,%eax
  80077f:	01 d0                	add    %edx,%eax
  800781:	01 c0                	add    %eax,%eax
  800783:	01 d0                	add    %edx,%eax
  800785:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80078c:	01 d0                	add    %edx,%eax
  80078e:	c1 e0 04             	shl    $0x4,%eax
  800791:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800796:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80079b:	a1 20 30 80 00       	mov    0x803020,%eax
  8007a0:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8007a6:	84 c0                	test   %al,%al
  8007a8:	74 0f                	je     8007b9 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8007aa:	a1 20 30 80 00       	mov    0x803020,%eax
  8007af:	05 5c 05 00 00       	add    $0x55c,%eax
  8007b4:	a3 08 30 80 00       	mov    %eax,0x803008

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007bd:	7e 0a                	jle    8007c9 <libmain+0x60>
		binaryname = argv[0];
  8007bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007c2:	8b 00                	mov    (%eax),%eax
  8007c4:	a3 08 30 80 00       	mov    %eax,0x803008

	// call user main routine
	_main(argc, argv);
  8007c9:	83 ec 08             	sub    $0x8,%esp
  8007cc:	ff 75 0c             	pushl  0xc(%ebp)
  8007cf:	ff 75 08             	pushl  0x8(%ebp)
  8007d2:	e8 61 f8 ff ff       	call   800038 <_main>
  8007d7:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8007da:	e8 dd 12 00 00       	call   801abc <sys_disable_interrupt>
	cprintf("**************************************\n");
  8007df:	83 ec 0c             	sub    $0xc,%esp
  8007e2:	68 a4 23 80 00       	push   $0x8023a4
  8007e7:	e8 6d 03 00 00       	call   800b59 <cprintf>
  8007ec:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8007ef:	a1 20 30 80 00       	mov    0x803020,%eax
  8007f4:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8007fa:	a1 20 30 80 00       	mov    0x803020,%eax
  8007ff:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800805:	83 ec 04             	sub    $0x4,%esp
  800808:	52                   	push   %edx
  800809:	50                   	push   %eax
  80080a:	68 cc 23 80 00       	push   $0x8023cc
  80080f:	e8 45 03 00 00       	call   800b59 <cprintf>
  800814:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800817:	a1 20 30 80 00       	mov    0x803020,%eax
  80081c:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800822:	a1 20 30 80 00       	mov    0x803020,%eax
  800827:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80082d:	a1 20 30 80 00       	mov    0x803020,%eax
  800832:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800838:	51                   	push   %ecx
  800839:	52                   	push   %edx
  80083a:	50                   	push   %eax
  80083b:	68 f4 23 80 00       	push   $0x8023f4
  800840:	e8 14 03 00 00       	call   800b59 <cprintf>
  800845:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800848:	a1 20 30 80 00       	mov    0x803020,%eax
  80084d:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800853:	83 ec 08             	sub    $0x8,%esp
  800856:	50                   	push   %eax
  800857:	68 4c 24 80 00       	push   $0x80244c
  80085c:	e8 f8 02 00 00       	call   800b59 <cprintf>
  800861:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800864:	83 ec 0c             	sub    $0xc,%esp
  800867:	68 a4 23 80 00       	push   $0x8023a4
  80086c:	e8 e8 02 00 00       	call   800b59 <cprintf>
  800871:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800874:	e8 5d 12 00 00       	call   801ad6 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800879:	e8 19 00 00 00       	call   800897 <exit>
}
  80087e:	90                   	nop
  80087f:	c9                   	leave  
  800880:	c3                   	ret    

00800881 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800881:	55                   	push   %ebp
  800882:	89 e5                	mov    %esp,%ebp
  800884:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800887:	83 ec 0c             	sub    $0xc,%esp
  80088a:	6a 00                	push   $0x0
  80088c:	e8 ea 13 00 00       	call   801c7b <sys_destroy_env>
  800891:	83 c4 10             	add    $0x10,%esp
}
  800894:	90                   	nop
  800895:	c9                   	leave  
  800896:	c3                   	ret    

00800897 <exit>:

void
exit(void)
{
  800897:	55                   	push   %ebp
  800898:	89 e5                	mov    %esp,%ebp
  80089a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80089d:	e8 3f 14 00 00       	call   801ce1 <sys_exit_env>
}
  8008a2:	90                   	nop
  8008a3:	c9                   	leave  
  8008a4:	c3                   	ret    

008008a5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8008a5:	55                   	push   %ebp
  8008a6:	89 e5                	mov    %esp,%ebp
  8008a8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8008ab:	8d 45 10             	lea    0x10(%ebp),%eax
  8008ae:	83 c0 04             	add    $0x4,%eax
  8008b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8008b4:	a1 5c f1 80 00       	mov    0x80f15c,%eax
  8008b9:	85 c0                	test   %eax,%eax
  8008bb:	74 16                	je     8008d3 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8008bd:	a1 5c f1 80 00       	mov    0x80f15c,%eax
  8008c2:	83 ec 08             	sub    $0x8,%esp
  8008c5:	50                   	push   %eax
  8008c6:	68 60 24 80 00       	push   $0x802460
  8008cb:	e8 89 02 00 00       	call   800b59 <cprintf>
  8008d0:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8008d3:	a1 08 30 80 00       	mov    0x803008,%eax
  8008d8:	ff 75 0c             	pushl  0xc(%ebp)
  8008db:	ff 75 08             	pushl  0x8(%ebp)
  8008de:	50                   	push   %eax
  8008df:	68 65 24 80 00       	push   $0x802465
  8008e4:	e8 70 02 00 00       	call   800b59 <cprintf>
  8008e9:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8008ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ef:	83 ec 08             	sub    $0x8,%esp
  8008f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8008f5:	50                   	push   %eax
  8008f6:	e8 f3 01 00 00       	call   800aee <vcprintf>
  8008fb:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8008fe:	83 ec 08             	sub    $0x8,%esp
  800901:	6a 00                	push   $0x0
  800903:	68 81 24 80 00       	push   $0x802481
  800908:	e8 e1 01 00 00       	call   800aee <vcprintf>
  80090d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800910:	e8 82 ff ff ff       	call   800897 <exit>

	// should not return here
	while (1) ;
  800915:	eb fe                	jmp    800915 <_panic+0x70>

00800917 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800917:	55                   	push   %ebp
  800918:	89 e5                	mov    %esp,%ebp
  80091a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80091d:	a1 20 30 80 00       	mov    0x803020,%eax
  800922:	8b 50 74             	mov    0x74(%eax),%edx
  800925:	8b 45 0c             	mov    0xc(%ebp),%eax
  800928:	39 c2                	cmp    %eax,%edx
  80092a:	74 14                	je     800940 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80092c:	83 ec 04             	sub    $0x4,%esp
  80092f:	68 84 24 80 00       	push   $0x802484
  800934:	6a 26                	push   $0x26
  800936:	68 d0 24 80 00       	push   $0x8024d0
  80093b:	e8 65 ff ff ff       	call   8008a5 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800940:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800947:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80094e:	e9 c2 00 00 00       	jmp    800a15 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800953:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800956:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80095d:	8b 45 08             	mov    0x8(%ebp),%eax
  800960:	01 d0                	add    %edx,%eax
  800962:	8b 00                	mov    (%eax),%eax
  800964:	85 c0                	test   %eax,%eax
  800966:	75 08                	jne    800970 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800968:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80096b:	e9 a2 00 00 00       	jmp    800a12 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800970:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800977:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80097e:	eb 69                	jmp    8009e9 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800980:	a1 20 30 80 00       	mov    0x803020,%eax
  800985:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80098b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80098e:	89 d0                	mov    %edx,%eax
  800990:	01 c0                	add    %eax,%eax
  800992:	01 d0                	add    %edx,%eax
  800994:	c1 e0 03             	shl    $0x3,%eax
  800997:	01 c8                	add    %ecx,%eax
  800999:	8a 40 04             	mov    0x4(%eax),%al
  80099c:	84 c0                	test   %al,%al
  80099e:	75 46                	jne    8009e6 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009a0:	a1 20 30 80 00       	mov    0x803020,%eax
  8009a5:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009ab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009ae:	89 d0                	mov    %edx,%eax
  8009b0:	01 c0                	add    %eax,%eax
  8009b2:	01 d0                	add    %edx,%eax
  8009b4:	c1 e0 03             	shl    $0x3,%eax
  8009b7:	01 c8                	add    %ecx,%eax
  8009b9:	8b 00                	mov    (%eax),%eax
  8009bb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8009be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009c1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8009c6:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8009c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009cb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8009d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d5:	01 c8                	add    %ecx,%eax
  8009d7:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009d9:	39 c2                	cmp    %eax,%edx
  8009db:	75 09                	jne    8009e6 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8009dd:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8009e4:	eb 12                	jmp    8009f8 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009e6:	ff 45 e8             	incl   -0x18(%ebp)
  8009e9:	a1 20 30 80 00       	mov    0x803020,%eax
  8009ee:	8b 50 74             	mov    0x74(%eax),%edx
  8009f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8009f4:	39 c2                	cmp    %eax,%edx
  8009f6:	77 88                	ja     800980 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8009f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8009fc:	75 14                	jne    800a12 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8009fe:	83 ec 04             	sub    $0x4,%esp
  800a01:	68 dc 24 80 00       	push   $0x8024dc
  800a06:	6a 3a                	push   $0x3a
  800a08:	68 d0 24 80 00       	push   $0x8024d0
  800a0d:	e8 93 fe ff ff       	call   8008a5 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a12:	ff 45 f0             	incl   -0x10(%ebp)
  800a15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a18:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a1b:	0f 8c 32 ff ff ff    	jl     800953 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a21:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a28:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a2f:	eb 26                	jmp    800a57 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a31:	a1 20 30 80 00       	mov    0x803020,%eax
  800a36:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a3c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a3f:	89 d0                	mov    %edx,%eax
  800a41:	01 c0                	add    %eax,%eax
  800a43:	01 d0                	add    %edx,%eax
  800a45:	c1 e0 03             	shl    $0x3,%eax
  800a48:	01 c8                	add    %ecx,%eax
  800a4a:	8a 40 04             	mov    0x4(%eax),%al
  800a4d:	3c 01                	cmp    $0x1,%al
  800a4f:	75 03                	jne    800a54 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800a51:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a54:	ff 45 e0             	incl   -0x20(%ebp)
  800a57:	a1 20 30 80 00       	mov    0x803020,%eax
  800a5c:	8b 50 74             	mov    0x74(%eax),%edx
  800a5f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a62:	39 c2                	cmp    %eax,%edx
  800a64:	77 cb                	ja     800a31 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a69:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800a6c:	74 14                	je     800a82 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800a6e:	83 ec 04             	sub    $0x4,%esp
  800a71:	68 30 25 80 00       	push   $0x802530
  800a76:	6a 44                	push   $0x44
  800a78:	68 d0 24 80 00       	push   $0x8024d0
  800a7d:	e8 23 fe ff ff       	call   8008a5 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800a82:	90                   	nop
  800a83:	c9                   	leave  
  800a84:	c3                   	ret    

00800a85 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800a85:	55                   	push   %ebp
  800a86:	89 e5                	mov    %esp,%ebp
  800a88:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800a8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8e:	8b 00                	mov    (%eax),%eax
  800a90:	8d 48 01             	lea    0x1(%eax),%ecx
  800a93:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a96:	89 0a                	mov    %ecx,(%edx)
  800a98:	8b 55 08             	mov    0x8(%ebp),%edx
  800a9b:	88 d1                	mov    %dl,%cl
  800a9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa0:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800aa4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa7:	8b 00                	mov    (%eax),%eax
  800aa9:	3d ff 00 00 00       	cmp    $0xff,%eax
  800aae:	75 2c                	jne    800adc <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800ab0:	a0 24 30 80 00       	mov    0x803024,%al
  800ab5:	0f b6 c0             	movzbl %al,%eax
  800ab8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800abb:	8b 12                	mov    (%edx),%edx
  800abd:	89 d1                	mov    %edx,%ecx
  800abf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac2:	83 c2 08             	add    $0x8,%edx
  800ac5:	83 ec 04             	sub    $0x4,%esp
  800ac8:	50                   	push   %eax
  800ac9:	51                   	push   %ecx
  800aca:	52                   	push   %edx
  800acb:	e8 3e 0e 00 00       	call   80190e <sys_cputs>
  800ad0:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800ad3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800adc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800adf:	8b 40 04             	mov    0x4(%eax),%eax
  800ae2:	8d 50 01             	lea    0x1(%eax),%edx
  800ae5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae8:	89 50 04             	mov    %edx,0x4(%eax)
}
  800aeb:	90                   	nop
  800aec:	c9                   	leave  
  800aed:	c3                   	ret    

00800aee <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800aee:	55                   	push   %ebp
  800aef:	89 e5                	mov    %esp,%ebp
  800af1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800af7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800afe:	00 00 00 
	b.cnt = 0;
  800b01:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b08:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b0b:	ff 75 0c             	pushl  0xc(%ebp)
  800b0e:	ff 75 08             	pushl  0x8(%ebp)
  800b11:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b17:	50                   	push   %eax
  800b18:	68 85 0a 80 00       	push   $0x800a85
  800b1d:	e8 11 02 00 00       	call   800d33 <vprintfmt>
  800b22:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b25:	a0 24 30 80 00       	mov    0x803024,%al
  800b2a:	0f b6 c0             	movzbl %al,%eax
  800b2d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b33:	83 ec 04             	sub    $0x4,%esp
  800b36:	50                   	push   %eax
  800b37:	52                   	push   %edx
  800b38:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b3e:	83 c0 08             	add    $0x8,%eax
  800b41:	50                   	push   %eax
  800b42:	e8 c7 0d 00 00       	call   80190e <sys_cputs>
  800b47:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800b4a:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800b51:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800b57:	c9                   	leave  
  800b58:	c3                   	ret    

00800b59 <cprintf>:

int cprintf(const char *fmt, ...) {
  800b59:	55                   	push   %ebp
  800b5a:	89 e5                	mov    %esp,%ebp
  800b5c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b5f:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800b66:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b69:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6f:	83 ec 08             	sub    $0x8,%esp
  800b72:	ff 75 f4             	pushl  -0xc(%ebp)
  800b75:	50                   	push   %eax
  800b76:	e8 73 ff ff ff       	call   800aee <vcprintf>
  800b7b:	83 c4 10             	add    $0x10,%esp
  800b7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800b81:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b84:	c9                   	leave  
  800b85:	c3                   	ret    

00800b86 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800b86:	55                   	push   %ebp
  800b87:	89 e5                	mov    %esp,%ebp
  800b89:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800b8c:	e8 2b 0f 00 00       	call   801abc <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800b91:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b94:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	83 ec 08             	sub    $0x8,%esp
  800b9d:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba0:	50                   	push   %eax
  800ba1:	e8 48 ff ff ff       	call   800aee <vcprintf>
  800ba6:	83 c4 10             	add    $0x10,%esp
  800ba9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800bac:	e8 25 0f 00 00       	call   801ad6 <sys_enable_interrupt>
	return cnt;
  800bb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bb4:	c9                   	leave  
  800bb5:	c3                   	ret    

00800bb6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800bb6:	55                   	push   %ebp
  800bb7:	89 e5                	mov    %esp,%ebp
  800bb9:	53                   	push   %ebx
  800bba:	83 ec 14             	sub    $0x14,%esp
  800bbd:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bc3:	8b 45 14             	mov    0x14(%ebp),%eax
  800bc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800bc9:	8b 45 18             	mov    0x18(%ebp),%eax
  800bcc:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800bd4:	77 55                	ja     800c2b <printnum+0x75>
  800bd6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800bd9:	72 05                	jb     800be0 <printnum+0x2a>
  800bdb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800bde:	77 4b                	ja     800c2b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800be0:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800be3:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800be6:	8b 45 18             	mov    0x18(%ebp),%eax
  800be9:	ba 00 00 00 00       	mov    $0x0,%edx
  800bee:	52                   	push   %edx
  800bef:	50                   	push   %eax
  800bf0:	ff 75 f4             	pushl  -0xc(%ebp)
  800bf3:	ff 75 f0             	pushl  -0x10(%ebp)
  800bf6:	e8 49 13 00 00       	call   801f44 <__udivdi3>
  800bfb:	83 c4 10             	add    $0x10,%esp
  800bfe:	83 ec 04             	sub    $0x4,%esp
  800c01:	ff 75 20             	pushl  0x20(%ebp)
  800c04:	53                   	push   %ebx
  800c05:	ff 75 18             	pushl  0x18(%ebp)
  800c08:	52                   	push   %edx
  800c09:	50                   	push   %eax
  800c0a:	ff 75 0c             	pushl  0xc(%ebp)
  800c0d:	ff 75 08             	pushl  0x8(%ebp)
  800c10:	e8 a1 ff ff ff       	call   800bb6 <printnum>
  800c15:	83 c4 20             	add    $0x20,%esp
  800c18:	eb 1a                	jmp    800c34 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c1a:	83 ec 08             	sub    $0x8,%esp
  800c1d:	ff 75 0c             	pushl  0xc(%ebp)
  800c20:	ff 75 20             	pushl  0x20(%ebp)
  800c23:	8b 45 08             	mov    0x8(%ebp),%eax
  800c26:	ff d0                	call   *%eax
  800c28:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c2b:	ff 4d 1c             	decl   0x1c(%ebp)
  800c2e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c32:	7f e6                	jg     800c1a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c34:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c37:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c42:	53                   	push   %ebx
  800c43:	51                   	push   %ecx
  800c44:	52                   	push   %edx
  800c45:	50                   	push   %eax
  800c46:	e8 09 14 00 00       	call   802054 <__umoddi3>
  800c4b:	83 c4 10             	add    $0x10,%esp
  800c4e:	05 94 27 80 00       	add    $0x802794,%eax
  800c53:	8a 00                	mov    (%eax),%al
  800c55:	0f be c0             	movsbl %al,%eax
  800c58:	83 ec 08             	sub    $0x8,%esp
  800c5b:	ff 75 0c             	pushl  0xc(%ebp)
  800c5e:	50                   	push   %eax
  800c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c62:	ff d0                	call   *%eax
  800c64:	83 c4 10             	add    $0x10,%esp
}
  800c67:	90                   	nop
  800c68:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c6b:	c9                   	leave  
  800c6c:	c3                   	ret    

00800c6d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c6d:	55                   	push   %ebp
  800c6e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c70:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c74:	7e 1c                	jle    800c92 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	8b 00                	mov    (%eax),%eax
  800c7b:	8d 50 08             	lea    0x8(%eax),%edx
  800c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c81:	89 10                	mov    %edx,(%eax)
  800c83:	8b 45 08             	mov    0x8(%ebp),%eax
  800c86:	8b 00                	mov    (%eax),%eax
  800c88:	83 e8 08             	sub    $0x8,%eax
  800c8b:	8b 50 04             	mov    0x4(%eax),%edx
  800c8e:	8b 00                	mov    (%eax),%eax
  800c90:	eb 40                	jmp    800cd2 <getuint+0x65>
	else if (lflag)
  800c92:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c96:	74 1e                	je     800cb6 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	8b 00                	mov    (%eax),%eax
  800c9d:	8d 50 04             	lea    0x4(%eax),%edx
  800ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca3:	89 10                	mov    %edx,(%eax)
  800ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca8:	8b 00                	mov    (%eax),%eax
  800caa:	83 e8 04             	sub    $0x4,%eax
  800cad:	8b 00                	mov    (%eax),%eax
  800caf:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb4:	eb 1c                	jmp    800cd2 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	8b 00                	mov    (%eax),%eax
  800cbb:	8d 50 04             	lea    0x4(%eax),%edx
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	89 10                	mov    %edx,(%eax)
  800cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc6:	8b 00                	mov    (%eax),%eax
  800cc8:	83 e8 04             	sub    $0x4,%eax
  800ccb:	8b 00                	mov    (%eax),%eax
  800ccd:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800cd2:	5d                   	pop    %ebp
  800cd3:	c3                   	ret    

00800cd4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800cd4:	55                   	push   %ebp
  800cd5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800cd7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cdb:	7e 1c                	jle    800cf9 <getint+0x25>
		return va_arg(*ap, long long);
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	8b 00                	mov    (%eax),%eax
  800ce2:	8d 50 08             	lea    0x8(%eax),%edx
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce8:	89 10                	mov    %edx,(%eax)
  800cea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ced:	8b 00                	mov    (%eax),%eax
  800cef:	83 e8 08             	sub    $0x8,%eax
  800cf2:	8b 50 04             	mov    0x4(%eax),%edx
  800cf5:	8b 00                	mov    (%eax),%eax
  800cf7:	eb 38                	jmp    800d31 <getint+0x5d>
	else if (lflag)
  800cf9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cfd:	74 1a                	je     800d19 <getint+0x45>
		return va_arg(*ap, long);
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	8b 00                	mov    (%eax),%eax
  800d04:	8d 50 04             	lea    0x4(%eax),%edx
  800d07:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0a:	89 10                	mov    %edx,(%eax)
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	8b 00                	mov    (%eax),%eax
  800d11:	83 e8 04             	sub    $0x4,%eax
  800d14:	8b 00                	mov    (%eax),%eax
  800d16:	99                   	cltd   
  800d17:	eb 18                	jmp    800d31 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	8b 00                	mov    (%eax),%eax
  800d1e:	8d 50 04             	lea    0x4(%eax),%edx
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	89 10                	mov    %edx,(%eax)
  800d26:	8b 45 08             	mov    0x8(%ebp),%eax
  800d29:	8b 00                	mov    (%eax),%eax
  800d2b:	83 e8 04             	sub    $0x4,%eax
  800d2e:	8b 00                	mov    (%eax),%eax
  800d30:	99                   	cltd   
}
  800d31:	5d                   	pop    %ebp
  800d32:	c3                   	ret    

00800d33 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d33:	55                   	push   %ebp
  800d34:	89 e5                	mov    %esp,%ebp
  800d36:	56                   	push   %esi
  800d37:	53                   	push   %ebx
  800d38:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d3b:	eb 17                	jmp    800d54 <vprintfmt+0x21>
			if (ch == '\0')
  800d3d:	85 db                	test   %ebx,%ebx
  800d3f:	0f 84 af 03 00 00    	je     8010f4 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800d45:	83 ec 08             	sub    $0x8,%esp
  800d48:	ff 75 0c             	pushl  0xc(%ebp)
  800d4b:	53                   	push   %ebx
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	ff d0                	call   *%eax
  800d51:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d54:	8b 45 10             	mov    0x10(%ebp),%eax
  800d57:	8d 50 01             	lea    0x1(%eax),%edx
  800d5a:	89 55 10             	mov    %edx,0x10(%ebp)
  800d5d:	8a 00                	mov    (%eax),%al
  800d5f:	0f b6 d8             	movzbl %al,%ebx
  800d62:	83 fb 25             	cmp    $0x25,%ebx
  800d65:	75 d6                	jne    800d3d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d67:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d6b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800d72:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800d79:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800d80:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d87:	8b 45 10             	mov    0x10(%ebp),%eax
  800d8a:	8d 50 01             	lea    0x1(%eax),%edx
  800d8d:	89 55 10             	mov    %edx,0x10(%ebp)
  800d90:	8a 00                	mov    (%eax),%al
  800d92:	0f b6 d8             	movzbl %al,%ebx
  800d95:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d98:	83 f8 55             	cmp    $0x55,%eax
  800d9b:	0f 87 2b 03 00 00    	ja     8010cc <vprintfmt+0x399>
  800da1:	8b 04 85 b8 27 80 00 	mov    0x8027b8(,%eax,4),%eax
  800da8:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800daa:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800dae:	eb d7                	jmp    800d87 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800db0:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800db4:	eb d1                	jmp    800d87 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800db6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800dbd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800dc0:	89 d0                	mov    %edx,%eax
  800dc2:	c1 e0 02             	shl    $0x2,%eax
  800dc5:	01 d0                	add    %edx,%eax
  800dc7:	01 c0                	add    %eax,%eax
  800dc9:	01 d8                	add    %ebx,%eax
  800dcb:	83 e8 30             	sub    $0x30,%eax
  800dce:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800dd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd4:	8a 00                	mov    (%eax),%al
  800dd6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800dd9:	83 fb 2f             	cmp    $0x2f,%ebx
  800ddc:	7e 3e                	jle    800e1c <vprintfmt+0xe9>
  800dde:	83 fb 39             	cmp    $0x39,%ebx
  800de1:	7f 39                	jg     800e1c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800de3:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800de6:	eb d5                	jmp    800dbd <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800de8:	8b 45 14             	mov    0x14(%ebp),%eax
  800deb:	83 c0 04             	add    $0x4,%eax
  800dee:	89 45 14             	mov    %eax,0x14(%ebp)
  800df1:	8b 45 14             	mov    0x14(%ebp),%eax
  800df4:	83 e8 04             	sub    $0x4,%eax
  800df7:	8b 00                	mov    (%eax),%eax
  800df9:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800dfc:	eb 1f                	jmp    800e1d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800dfe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e02:	79 83                	jns    800d87 <vprintfmt+0x54>
				width = 0;
  800e04:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e0b:	e9 77 ff ff ff       	jmp    800d87 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e10:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e17:	e9 6b ff ff ff       	jmp    800d87 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e1c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e1d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e21:	0f 89 60 ff ff ff    	jns    800d87 <vprintfmt+0x54>
				width = precision, precision = -1;
  800e27:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e2d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e34:	e9 4e ff ff ff       	jmp    800d87 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e39:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e3c:	e9 46 ff ff ff       	jmp    800d87 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e41:	8b 45 14             	mov    0x14(%ebp),%eax
  800e44:	83 c0 04             	add    $0x4,%eax
  800e47:	89 45 14             	mov    %eax,0x14(%ebp)
  800e4a:	8b 45 14             	mov    0x14(%ebp),%eax
  800e4d:	83 e8 04             	sub    $0x4,%eax
  800e50:	8b 00                	mov    (%eax),%eax
  800e52:	83 ec 08             	sub    $0x8,%esp
  800e55:	ff 75 0c             	pushl  0xc(%ebp)
  800e58:	50                   	push   %eax
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	ff d0                	call   *%eax
  800e5e:	83 c4 10             	add    $0x10,%esp
			break;
  800e61:	e9 89 02 00 00       	jmp    8010ef <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e66:	8b 45 14             	mov    0x14(%ebp),%eax
  800e69:	83 c0 04             	add    $0x4,%eax
  800e6c:	89 45 14             	mov    %eax,0x14(%ebp)
  800e6f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e72:	83 e8 04             	sub    $0x4,%eax
  800e75:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800e77:	85 db                	test   %ebx,%ebx
  800e79:	79 02                	jns    800e7d <vprintfmt+0x14a>
				err = -err;
  800e7b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800e7d:	83 fb 64             	cmp    $0x64,%ebx
  800e80:	7f 0b                	jg     800e8d <vprintfmt+0x15a>
  800e82:	8b 34 9d 00 26 80 00 	mov    0x802600(,%ebx,4),%esi
  800e89:	85 f6                	test   %esi,%esi
  800e8b:	75 19                	jne    800ea6 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e8d:	53                   	push   %ebx
  800e8e:	68 a5 27 80 00       	push   $0x8027a5
  800e93:	ff 75 0c             	pushl  0xc(%ebp)
  800e96:	ff 75 08             	pushl  0x8(%ebp)
  800e99:	e8 5e 02 00 00       	call   8010fc <printfmt>
  800e9e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ea1:	e9 49 02 00 00       	jmp    8010ef <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ea6:	56                   	push   %esi
  800ea7:	68 ae 27 80 00       	push   $0x8027ae
  800eac:	ff 75 0c             	pushl  0xc(%ebp)
  800eaf:	ff 75 08             	pushl  0x8(%ebp)
  800eb2:	e8 45 02 00 00       	call   8010fc <printfmt>
  800eb7:	83 c4 10             	add    $0x10,%esp
			break;
  800eba:	e9 30 02 00 00       	jmp    8010ef <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ebf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec2:	83 c0 04             	add    $0x4,%eax
  800ec5:	89 45 14             	mov    %eax,0x14(%ebp)
  800ec8:	8b 45 14             	mov    0x14(%ebp),%eax
  800ecb:	83 e8 04             	sub    $0x4,%eax
  800ece:	8b 30                	mov    (%eax),%esi
  800ed0:	85 f6                	test   %esi,%esi
  800ed2:	75 05                	jne    800ed9 <vprintfmt+0x1a6>
				p = "(null)";
  800ed4:	be b1 27 80 00       	mov    $0x8027b1,%esi
			if (width > 0 && padc != '-')
  800ed9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800edd:	7e 6d                	jle    800f4c <vprintfmt+0x219>
  800edf:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ee3:	74 67                	je     800f4c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ee5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ee8:	83 ec 08             	sub    $0x8,%esp
  800eeb:	50                   	push   %eax
  800eec:	56                   	push   %esi
  800eed:	e8 0c 03 00 00       	call   8011fe <strnlen>
  800ef2:	83 c4 10             	add    $0x10,%esp
  800ef5:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ef8:	eb 16                	jmp    800f10 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800efa:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800efe:	83 ec 08             	sub    $0x8,%esp
  800f01:	ff 75 0c             	pushl  0xc(%ebp)
  800f04:	50                   	push   %eax
  800f05:	8b 45 08             	mov    0x8(%ebp),%eax
  800f08:	ff d0                	call   *%eax
  800f0a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f0d:	ff 4d e4             	decl   -0x1c(%ebp)
  800f10:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f14:	7f e4                	jg     800efa <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f16:	eb 34                	jmp    800f4c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f18:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f1c:	74 1c                	je     800f3a <vprintfmt+0x207>
  800f1e:	83 fb 1f             	cmp    $0x1f,%ebx
  800f21:	7e 05                	jle    800f28 <vprintfmt+0x1f5>
  800f23:	83 fb 7e             	cmp    $0x7e,%ebx
  800f26:	7e 12                	jle    800f3a <vprintfmt+0x207>
					putch('?', putdat);
  800f28:	83 ec 08             	sub    $0x8,%esp
  800f2b:	ff 75 0c             	pushl  0xc(%ebp)
  800f2e:	6a 3f                	push   $0x3f
  800f30:	8b 45 08             	mov    0x8(%ebp),%eax
  800f33:	ff d0                	call   *%eax
  800f35:	83 c4 10             	add    $0x10,%esp
  800f38:	eb 0f                	jmp    800f49 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f3a:	83 ec 08             	sub    $0x8,%esp
  800f3d:	ff 75 0c             	pushl  0xc(%ebp)
  800f40:	53                   	push   %ebx
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
  800f44:	ff d0                	call   *%eax
  800f46:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f49:	ff 4d e4             	decl   -0x1c(%ebp)
  800f4c:	89 f0                	mov    %esi,%eax
  800f4e:	8d 70 01             	lea    0x1(%eax),%esi
  800f51:	8a 00                	mov    (%eax),%al
  800f53:	0f be d8             	movsbl %al,%ebx
  800f56:	85 db                	test   %ebx,%ebx
  800f58:	74 24                	je     800f7e <vprintfmt+0x24b>
  800f5a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f5e:	78 b8                	js     800f18 <vprintfmt+0x1e5>
  800f60:	ff 4d e0             	decl   -0x20(%ebp)
  800f63:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f67:	79 af                	jns    800f18 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f69:	eb 13                	jmp    800f7e <vprintfmt+0x24b>
				putch(' ', putdat);
  800f6b:	83 ec 08             	sub    $0x8,%esp
  800f6e:	ff 75 0c             	pushl  0xc(%ebp)
  800f71:	6a 20                	push   $0x20
  800f73:	8b 45 08             	mov    0x8(%ebp),%eax
  800f76:	ff d0                	call   *%eax
  800f78:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f7b:	ff 4d e4             	decl   -0x1c(%ebp)
  800f7e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f82:	7f e7                	jg     800f6b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800f84:	e9 66 01 00 00       	jmp    8010ef <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f89:	83 ec 08             	sub    $0x8,%esp
  800f8c:	ff 75 e8             	pushl  -0x18(%ebp)
  800f8f:	8d 45 14             	lea    0x14(%ebp),%eax
  800f92:	50                   	push   %eax
  800f93:	e8 3c fd ff ff       	call   800cd4 <getint>
  800f98:	83 c4 10             	add    $0x10,%esp
  800f9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f9e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800fa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fa4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fa7:	85 d2                	test   %edx,%edx
  800fa9:	79 23                	jns    800fce <vprintfmt+0x29b>
				putch('-', putdat);
  800fab:	83 ec 08             	sub    $0x8,%esp
  800fae:	ff 75 0c             	pushl  0xc(%ebp)
  800fb1:	6a 2d                	push   $0x2d
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	ff d0                	call   *%eax
  800fb8:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800fbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fbe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fc1:	f7 d8                	neg    %eax
  800fc3:	83 d2 00             	adc    $0x0,%edx
  800fc6:	f7 da                	neg    %edx
  800fc8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fcb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800fce:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800fd5:	e9 bc 00 00 00       	jmp    801096 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800fda:	83 ec 08             	sub    $0x8,%esp
  800fdd:	ff 75 e8             	pushl  -0x18(%ebp)
  800fe0:	8d 45 14             	lea    0x14(%ebp),%eax
  800fe3:	50                   	push   %eax
  800fe4:	e8 84 fc ff ff       	call   800c6d <getuint>
  800fe9:	83 c4 10             	add    $0x10,%esp
  800fec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fef:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ff2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ff9:	e9 98 00 00 00       	jmp    801096 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ffe:	83 ec 08             	sub    $0x8,%esp
  801001:	ff 75 0c             	pushl  0xc(%ebp)
  801004:	6a 58                	push   $0x58
  801006:	8b 45 08             	mov    0x8(%ebp),%eax
  801009:	ff d0                	call   *%eax
  80100b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80100e:	83 ec 08             	sub    $0x8,%esp
  801011:	ff 75 0c             	pushl  0xc(%ebp)
  801014:	6a 58                	push   $0x58
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
  801019:	ff d0                	call   *%eax
  80101b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80101e:	83 ec 08             	sub    $0x8,%esp
  801021:	ff 75 0c             	pushl  0xc(%ebp)
  801024:	6a 58                	push   $0x58
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	ff d0                	call   *%eax
  80102b:	83 c4 10             	add    $0x10,%esp
			break;
  80102e:	e9 bc 00 00 00       	jmp    8010ef <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801033:	83 ec 08             	sub    $0x8,%esp
  801036:	ff 75 0c             	pushl  0xc(%ebp)
  801039:	6a 30                	push   $0x30
  80103b:	8b 45 08             	mov    0x8(%ebp),%eax
  80103e:	ff d0                	call   *%eax
  801040:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801043:	83 ec 08             	sub    $0x8,%esp
  801046:	ff 75 0c             	pushl  0xc(%ebp)
  801049:	6a 78                	push   $0x78
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	ff d0                	call   *%eax
  801050:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801053:	8b 45 14             	mov    0x14(%ebp),%eax
  801056:	83 c0 04             	add    $0x4,%eax
  801059:	89 45 14             	mov    %eax,0x14(%ebp)
  80105c:	8b 45 14             	mov    0x14(%ebp),%eax
  80105f:	83 e8 04             	sub    $0x4,%eax
  801062:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801064:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801067:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80106e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801075:	eb 1f                	jmp    801096 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801077:	83 ec 08             	sub    $0x8,%esp
  80107a:	ff 75 e8             	pushl  -0x18(%ebp)
  80107d:	8d 45 14             	lea    0x14(%ebp),%eax
  801080:	50                   	push   %eax
  801081:	e8 e7 fb ff ff       	call   800c6d <getuint>
  801086:	83 c4 10             	add    $0x10,%esp
  801089:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80108c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80108f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801096:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80109a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80109d:	83 ec 04             	sub    $0x4,%esp
  8010a0:	52                   	push   %edx
  8010a1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010a4:	50                   	push   %eax
  8010a5:	ff 75 f4             	pushl  -0xc(%ebp)
  8010a8:	ff 75 f0             	pushl  -0x10(%ebp)
  8010ab:	ff 75 0c             	pushl  0xc(%ebp)
  8010ae:	ff 75 08             	pushl  0x8(%ebp)
  8010b1:	e8 00 fb ff ff       	call   800bb6 <printnum>
  8010b6:	83 c4 20             	add    $0x20,%esp
			break;
  8010b9:	eb 34                	jmp    8010ef <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010bb:	83 ec 08             	sub    $0x8,%esp
  8010be:	ff 75 0c             	pushl  0xc(%ebp)
  8010c1:	53                   	push   %ebx
  8010c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c5:	ff d0                	call   *%eax
  8010c7:	83 c4 10             	add    $0x10,%esp
			break;
  8010ca:	eb 23                	jmp    8010ef <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010cc:	83 ec 08             	sub    $0x8,%esp
  8010cf:	ff 75 0c             	pushl  0xc(%ebp)
  8010d2:	6a 25                	push   $0x25
  8010d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d7:	ff d0                	call   *%eax
  8010d9:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010dc:	ff 4d 10             	decl   0x10(%ebp)
  8010df:	eb 03                	jmp    8010e4 <vprintfmt+0x3b1>
  8010e1:	ff 4d 10             	decl   0x10(%ebp)
  8010e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e7:	48                   	dec    %eax
  8010e8:	8a 00                	mov    (%eax),%al
  8010ea:	3c 25                	cmp    $0x25,%al
  8010ec:	75 f3                	jne    8010e1 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8010ee:	90                   	nop
		}
	}
  8010ef:	e9 47 fc ff ff       	jmp    800d3b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8010f4:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8010f5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010f8:	5b                   	pop    %ebx
  8010f9:	5e                   	pop    %esi
  8010fa:	5d                   	pop    %ebp
  8010fb:	c3                   	ret    

008010fc <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8010fc:	55                   	push   %ebp
  8010fd:	89 e5                	mov    %esp,%ebp
  8010ff:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801102:	8d 45 10             	lea    0x10(%ebp),%eax
  801105:	83 c0 04             	add    $0x4,%eax
  801108:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80110b:	8b 45 10             	mov    0x10(%ebp),%eax
  80110e:	ff 75 f4             	pushl  -0xc(%ebp)
  801111:	50                   	push   %eax
  801112:	ff 75 0c             	pushl  0xc(%ebp)
  801115:	ff 75 08             	pushl  0x8(%ebp)
  801118:	e8 16 fc ff ff       	call   800d33 <vprintfmt>
  80111d:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801120:	90                   	nop
  801121:	c9                   	leave  
  801122:	c3                   	ret    

00801123 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801123:	55                   	push   %ebp
  801124:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801126:	8b 45 0c             	mov    0xc(%ebp),%eax
  801129:	8b 40 08             	mov    0x8(%eax),%eax
  80112c:	8d 50 01             	lea    0x1(%eax),%edx
  80112f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801132:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801135:	8b 45 0c             	mov    0xc(%ebp),%eax
  801138:	8b 10                	mov    (%eax),%edx
  80113a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113d:	8b 40 04             	mov    0x4(%eax),%eax
  801140:	39 c2                	cmp    %eax,%edx
  801142:	73 12                	jae    801156 <sprintputch+0x33>
		*b->buf++ = ch;
  801144:	8b 45 0c             	mov    0xc(%ebp),%eax
  801147:	8b 00                	mov    (%eax),%eax
  801149:	8d 48 01             	lea    0x1(%eax),%ecx
  80114c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80114f:	89 0a                	mov    %ecx,(%edx)
  801151:	8b 55 08             	mov    0x8(%ebp),%edx
  801154:	88 10                	mov    %dl,(%eax)
}
  801156:	90                   	nop
  801157:	5d                   	pop    %ebp
  801158:	c3                   	ret    

00801159 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801159:	55                   	push   %ebp
  80115a:	89 e5                	mov    %esp,%ebp
  80115c:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80115f:	8b 45 08             	mov    0x8(%ebp),%eax
  801162:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801165:	8b 45 0c             	mov    0xc(%ebp),%eax
  801168:	8d 50 ff             	lea    -0x1(%eax),%edx
  80116b:	8b 45 08             	mov    0x8(%ebp),%eax
  80116e:	01 d0                	add    %edx,%eax
  801170:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801173:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80117a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80117e:	74 06                	je     801186 <vsnprintf+0x2d>
  801180:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801184:	7f 07                	jg     80118d <vsnprintf+0x34>
		return -E_INVAL;
  801186:	b8 03 00 00 00       	mov    $0x3,%eax
  80118b:	eb 20                	jmp    8011ad <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80118d:	ff 75 14             	pushl  0x14(%ebp)
  801190:	ff 75 10             	pushl  0x10(%ebp)
  801193:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801196:	50                   	push   %eax
  801197:	68 23 11 80 00       	push   $0x801123
  80119c:	e8 92 fb ff ff       	call   800d33 <vprintfmt>
  8011a1:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8011a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011a7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8011aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8011ad:	c9                   	leave  
  8011ae:	c3                   	ret    

008011af <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011af:	55                   	push   %ebp
  8011b0:	89 e5                	mov    %esp,%ebp
  8011b2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8011b5:	8d 45 10             	lea    0x10(%ebp),%eax
  8011b8:	83 c0 04             	add    $0x4,%eax
  8011bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8011be:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8011c4:	50                   	push   %eax
  8011c5:	ff 75 0c             	pushl  0xc(%ebp)
  8011c8:	ff 75 08             	pushl  0x8(%ebp)
  8011cb:	e8 89 ff ff ff       	call   801159 <vsnprintf>
  8011d0:	83 c4 10             	add    $0x10,%esp
  8011d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8011d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011d9:	c9                   	leave  
  8011da:	c3                   	ret    

008011db <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8011db:	55                   	push   %ebp
  8011dc:	89 e5                	mov    %esp,%ebp
  8011de:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8011e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011e8:	eb 06                	jmp    8011f0 <strlen+0x15>
		n++;
  8011ea:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8011ed:	ff 45 08             	incl   0x8(%ebp)
  8011f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f3:	8a 00                	mov    (%eax),%al
  8011f5:	84 c0                	test   %al,%al
  8011f7:	75 f1                	jne    8011ea <strlen+0xf>
		n++;
	return n;
  8011f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8011fc:	c9                   	leave  
  8011fd:	c3                   	ret    

008011fe <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8011fe:	55                   	push   %ebp
  8011ff:	89 e5                	mov    %esp,%ebp
  801201:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801204:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80120b:	eb 09                	jmp    801216 <strnlen+0x18>
		n++;
  80120d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801210:	ff 45 08             	incl   0x8(%ebp)
  801213:	ff 4d 0c             	decl   0xc(%ebp)
  801216:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80121a:	74 09                	je     801225 <strnlen+0x27>
  80121c:	8b 45 08             	mov    0x8(%ebp),%eax
  80121f:	8a 00                	mov    (%eax),%al
  801221:	84 c0                	test   %al,%al
  801223:	75 e8                	jne    80120d <strnlen+0xf>
		n++;
	return n;
  801225:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801228:	c9                   	leave  
  801229:	c3                   	ret    

0080122a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80122a:	55                   	push   %ebp
  80122b:	89 e5                	mov    %esp,%ebp
  80122d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801230:	8b 45 08             	mov    0x8(%ebp),%eax
  801233:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801236:	90                   	nop
  801237:	8b 45 08             	mov    0x8(%ebp),%eax
  80123a:	8d 50 01             	lea    0x1(%eax),%edx
  80123d:	89 55 08             	mov    %edx,0x8(%ebp)
  801240:	8b 55 0c             	mov    0xc(%ebp),%edx
  801243:	8d 4a 01             	lea    0x1(%edx),%ecx
  801246:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801249:	8a 12                	mov    (%edx),%dl
  80124b:	88 10                	mov    %dl,(%eax)
  80124d:	8a 00                	mov    (%eax),%al
  80124f:	84 c0                	test   %al,%al
  801251:	75 e4                	jne    801237 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801253:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801256:	c9                   	leave  
  801257:	c3                   	ret    

00801258 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801258:	55                   	push   %ebp
  801259:	89 e5                	mov    %esp,%ebp
  80125b:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80125e:	8b 45 08             	mov    0x8(%ebp),%eax
  801261:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801264:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80126b:	eb 1f                	jmp    80128c <strncpy+0x34>
		*dst++ = *src;
  80126d:	8b 45 08             	mov    0x8(%ebp),%eax
  801270:	8d 50 01             	lea    0x1(%eax),%edx
  801273:	89 55 08             	mov    %edx,0x8(%ebp)
  801276:	8b 55 0c             	mov    0xc(%ebp),%edx
  801279:	8a 12                	mov    (%edx),%dl
  80127b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80127d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801280:	8a 00                	mov    (%eax),%al
  801282:	84 c0                	test   %al,%al
  801284:	74 03                	je     801289 <strncpy+0x31>
			src++;
  801286:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801289:	ff 45 fc             	incl   -0x4(%ebp)
  80128c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80128f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801292:	72 d9                	jb     80126d <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801294:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801297:	c9                   	leave  
  801298:	c3                   	ret    

00801299 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801299:	55                   	push   %ebp
  80129a:	89 e5                	mov    %esp,%ebp
  80129c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80129f:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8012a5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012a9:	74 30                	je     8012db <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8012ab:	eb 16                	jmp    8012c3 <strlcpy+0x2a>
			*dst++ = *src++;
  8012ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b0:	8d 50 01             	lea    0x1(%eax),%edx
  8012b3:	89 55 08             	mov    %edx,0x8(%ebp)
  8012b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012b9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012bc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8012bf:	8a 12                	mov    (%edx),%dl
  8012c1:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8012c3:	ff 4d 10             	decl   0x10(%ebp)
  8012c6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012ca:	74 09                	je     8012d5 <strlcpy+0x3c>
  8012cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cf:	8a 00                	mov    (%eax),%al
  8012d1:	84 c0                	test   %al,%al
  8012d3:	75 d8                	jne    8012ad <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8012d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8012db:	8b 55 08             	mov    0x8(%ebp),%edx
  8012de:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012e1:	29 c2                	sub    %eax,%edx
  8012e3:	89 d0                	mov    %edx,%eax
}
  8012e5:	c9                   	leave  
  8012e6:	c3                   	ret    

008012e7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8012e7:	55                   	push   %ebp
  8012e8:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8012ea:	eb 06                	jmp    8012f2 <strcmp+0xb>
		p++, q++;
  8012ec:	ff 45 08             	incl   0x8(%ebp)
  8012ef:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8012f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f5:	8a 00                	mov    (%eax),%al
  8012f7:	84 c0                	test   %al,%al
  8012f9:	74 0e                	je     801309 <strcmp+0x22>
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	8a 10                	mov    (%eax),%dl
  801300:	8b 45 0c             	mov    0xc(%ebp),%eax
  801303:	8a 00                	mov    (%eax),%al
  801305:	38 c2                	cmp    %al,%dl
  801307:	74 e3                	je     8012ec <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801309:	8b 45 08             	mov    0x8(%ebp),%eax
  80130c:	8a 00                	mov    (%eax),%al
  80130e:	0f b6 d0             	movzbl %al,%edx
  801311:	8b 45 0c             	mov    0xc(%ebp),%eax
  801314:	8a 00                	mov    (%eax),%al
  801316:	0f b6 c0             	movzbl %al,%eax
  801319:	29 c2                	sub    %eax,%edx
  80131b:	89 d0                	mov    %edx,%eax
}
  80131d:	5d                   	pop    %ebp
  80131e:	c3                   	ret    

0080131f <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80131f:	55                   	push   %ebp
  801320:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801322:	eb 09                	jmp    80132d <strncmp+0xe>
		n--, p++, q++;
  801324:	ff 4d 10             	decl   0x10(%ebp)
  801327:	ff 45 08             	incl   0x8(%ebp)
  80132a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80132d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801331:	74 17                	je     80134a <strncmp+0x2b>
  801333:	8b 45 08             	mov    0x8(%ebp),%eax
  801336:	8a 00                	mov    (%eax),%al
  801338:	84 c0                	test   %al,%al
  80133a:	74 0e                	je     80134a <strncmp+0x2b>
  80133c:	8b 45 08             	mov    0x8(%ebp),%eax
  80133f:	8a 10                	mov    (%eax),%dl
  801341:	8b 45 0c             	mov    0xc(%ebp),%eax
  801344:	8a 00                	mov    (%eax),%al
  801346:	38 c2                	cmp    %al,%dl
  801348:	74 da                	je     801324 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80134a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80134e:	75 07                	jne    801357 <strncmp+0x38>
		return 0;
  801350:	b8 00 00 00 00       	mov    $0x0,%eax
  801355:	eb 14                	jmp    80136b <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801357:	8b 45 08             	mov    0x8(%ebp),%eax
  80135a:	8a 00                	mov    (%eax),%al
  80135c:	0f b6 d0             	movzbl %al,%edx
  80135f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801362:	8a 00                	mov    (%eax),%al
  801364:	0f b6 c0             	movzbl %al,%eax
  801367:	29 c2                	sub    %eax,%edx
  801369:	89 d0                	mov    %edx,%eax
}
  80136b:	5d                   	pop    %ebp
  80136c:	c3                   	ret    

0080136d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
  801370:	83 ec 04             	sub    $0x4,%esp
  801373:	8b 45 0c             	mov    0xc(%ebp),%eax
  801376:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801379:	eb 12                	jmp    80138d <strchr+0x20>
		if (*s == c)
  80137b:	8b 45 08             	mov    0x8(%ebp),%eax
  80137e:	8a 00                	mov    (%eax),%al
  801380:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801383:	75 05                	jne    80138a <strchr+0x1d>
			return (char *) s;
  801385:	8b 45 08             	mov    0x8(%ebp),%eax
  801388:	eb 11                	jmp    80139b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80138a:	ff 45 08             	incl   0x8(%ebp)
  80138d:	8b 45 08             	mov    0x8(%ebp),%eax
  801390:	8a 00                	mov    (%eax),%al
  801392:	84 c0                	test   %al,%al
  801394:	75 e5                	jne    80137b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801396:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80139b:	c9                   	leave  
  80139c:	c3                   	ret    

0080139d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80139d:	55                   	push   %ebp
  80139e:	89 e5                	mov    %esp,%ebp
  8013a0:	83 ec 04             	sub    $0x4,%esp
  8013a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8013a9:	eb 0d                	jmp    8013b8 <strfind+0x1b>
		if (*s == c)
  8013ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ae:	8a 00                	mov    (%eax),%al
  8013b0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8013b3:	74 0e                	je     8013c3 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8013b5:	ff 45 08             	incl   0x8(%ebp)
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	8a 00                	mov    (%eax),%al
  8013bd:	84 c0                	test   %al,%al
  8013bf:	75 ea                	jne    8013ab <strfind+0xe>
  8013c1:	eb 01                	jmp    8013c4 <strfind+0x27>
		if (*s == c)
			break;
  8013c3:	90                   	nop
	return (char *) s;
  8013c4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013c7:	c9                   	leave  
  8013c8:	c3                   	ret    

008013c9 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8013c9:	55                   	push   %ebp
  8013ca:	89 e5                	mov    %esp,%ebp
  8013cc:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8013cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8013d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8013db:	eb 0e                	jmp    8013eb <memset+0x22>
		*p++ = c;
  8013dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013e0:	8d 50 01             	lea    0x1(%eax),%edx
  8013e3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013e9:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8013eb:	ff 4d f8             	decl   -0x8(%ebp)
  8013ee:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8013f2:	79 e9                	jns    8013dd <memset+0x14>
		*p++ = c;

	return v;
  8013f4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013f7:	c9                   	leave  
  8013f8:	c3                   	ret    

008013f9 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8013f9:	55                   	push   %ebp
  8013fa:	89 e5                	mov    %esp,%ebp
  8013fc:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8013ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801402:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801405:	8b 45 08             	mov    0x8(%ebp),%eax
  801408:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80140b:	eb 16                	jmp    801423 <memcpy+0x2a>
		*d++ = *s++;
  80140d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801410:	8d 50 01             	lea    0x1(%eax),%edx
  801413:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801416:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801419:	8d 4a 01             	lea    0x1(%edx),%ecx
  80141c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80141f:	8a 12                	mov    (%edx),%dl
  801421:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801423:	8b 45 10             	mov    0x10(%ebp),%eax
  801426:	8d 50 ff             	lea    -0x1(%eax),%edx
  801429:	89 55 10             	mov    %edx,0x10(%ebp)
  80142c:	85 c0                	test   %eax,%eax
  80142e:	75 dd                	jne    80140d <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801430:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801433:	c9                   	leave  
  801434:	c3                   	ret    

00801435 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801435:	55                   	push   %ebp
  801436:	89 e5                	mov    %esp,%ebp
  801438:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80143b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801441:	8b 45 08             	mov    0x8(%ebp),%eax
  801444:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801447:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80144a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80144d:	73 50                	jae    80149f <memmove+0x6a>
  80144f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801452:	8b 45 10             	mov    0x10(%ebp),%eax
  801455:	01 d0                	add    %edx,%eax
  801457:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80145a:	76 43                	jbe    80149f <memmove+0x6a>
		s += n;
  80145c:	8b 45 10             	mov    0x10(%ebp),%eax
  80145f:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801462:	8b 45 10             	mov    0x10(%ebp),%eax
  801465:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801468:	eb 10                	jmp    80147a <memmove+0x45>
			*--d = *--s;
  80146a:	ff 4d f8             	decl   -0x8(%ebp)
  80146d:	ff 4d fc             	decl   -0x4(%ebp)
  801470:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801473:	8a 10                	mov    (%eax),%dl
  801475:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801478:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80147a:	8b 45 10             	mov    0x10(%ebp),%eax
  80147d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801480:	89 55 10             	mov    %edx,0x10(%ebp)
  801483:	85 c0                	test   %eax,%eax
  801485:	75 e3                	jne    80146a <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801487:	eb 23                	jmp    8014ac <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801489:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80148c:	8d 50 01             	lea    0x1(%eax),%edx
  80148f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801492:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801495:	8d 4a 01             	lea    0x1(%edx),%ecx
  801498:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80149b:	8a 12                	mov    (%edx),%dl
  80149d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80149f:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014a5:	89 55 10             	mov    %edx,0x10(%ebp)
  8014a8:	85 c0                	test   %eax,%eax
  8014aa:	75 dd                	jne    801489 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8014ac:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014af:	c9                   	leave  
  8014b0:	c3                   	ret    

008014b1 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8014b1:	55                   	push   %ebp
  8014b2:	89 e5                	mov    %esp,%ebp
  8014b4:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8014b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8014bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c0:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8014c3:	eb 2a                	jmp    8014ef <memcmp+0x3e>
		if (*s1 != *s2)
  8014c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c8:	8a 10                	mov    (%eax),%dl
  8014ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014cd:	8a 00                	mov    (%eax),%al
  8014cf:	38 c2                	cmp    %al,%dl
  8014d1:	74 16                	je     8014e9 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8014d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014d6:	8a 00                	mov    (%eax),%al
  8014d8:	0f b6 d0             	movzbl %al,%edx
  8014db:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014de:	8a 00                	mov    (%eax),%al
  8014e0:	0f b6 c0             	movzbl %al,%eax
  8014e3:	29 c2                	sub    %eax,%edx
  8014e5:	89 d0                	mov    %edx,%eax
  8014e7:	eb 18                	jmp    801501 <memcmp+0x50>
		s1++, s2++;
  8014e9:	ff 45 fc             	incl   -0x4(%ebp)
  8014ec:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8014ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014f5:	89 55 10             	mov    %edx,0x10(%ebp)
  8014f8:	85 c0                	test   %eax,%eax
  8014fa:	75 c9                	jne    8014c5 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8014fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801501:	c9                   	leave  
  801502:	c3                   	ret    

00801503 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801503:	55                   	push   %ebp
  801504:	89 e5                	mov    %esp,%ebp
  801506:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801509:	8b 55 08             	mov    0x8(%ebp),%edx
  80150c:	8b 45 10             	mov    0x10(%ebp),%eax
  80150f:	01 d0                	add    %edx,%eax
  801511:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801514:	eb 15                	jmp    80152b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801516:	8b 45 08             	mov    0x8(%ebp),%eax
  801519:	8a 00                	mov    (%eax),%al
  80151b:	0f b6 d0             	movzbl %al,%edx
  80151e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801521:	0f b6 c0             	movzbl %al,%eax
  801524:	39 c2                	cmp    %eax,%edx
  801526:	74 0d                	je     801535 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801528:	ff 45 08             	incl   0x8(%ebp)
  80152b:	8b 45 08             	mov    0x8(%ebp),%eax
  80152e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801531:	72 e3                	jb     801516 <memfind+0x13>
  801533:	eb 01                	jmp    801536 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801535:	90                   	nop
	return (void *) s;
  801536:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801539:	c9                   	leave  
  80153a:	c3                   	ret    

0080153b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80153b:	55                   	push   %ebp
  80153c:	89 e5                	mov    %esp,%ebp
  80153e:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801541:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801548:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80154f:	eb 03                	jmp    801554 <strtol+0x19>
		s++;
  801551:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801554:	8b 45 08             	mov    0x8(%ebp),%eax
  801557:	8a 00                	mov    (%eax),%al
  801559:	3c 20                	cmp    $0x20,%al
  80155b:	74 f4                	je     801551 <strtol+0x16>
  80155d:	8b 45 08             	mov    0x8(%ebp),%eax
  801560:	8a 00                	mov    (%eax),%al
  801562:	3c 09                	cmp    $0x9,%al
  801564:	74 eb                	je     801551 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801566:	8b 45 08             	mov    0x8(%ebp),%eax
  801569:	8a 00                	mov    (%eax),%al
  80156b:	3c 2b                	cmp    $0x2b,%al
  80156d:	75 05                	jne    801574 <strtol+0x39>
		s++;
  80156f:	ff 45 08             	incl   0x8(%ebp)
  801572:	eb 13                	jmp    801587 <strtol+0x4c>
	else if (*s == '-')
  801574:	8b 45 08             	mov    0x8(%ebp),%eax
  801577:	8a 00                	mov    (%eax),%al
  801579:	3c 2d                	cmp    $0x2d,%al
  80157b:	75 0a                	jne    801587 <strtol+0x4c>
		s++, neg = 1;
  80157d:	ff 45 08             	incl   0x8(%ebp)
  801580:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801587:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80158b:	74 06                	je     801593 <strtol+0x58>
  80158d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801591:	75 20                	jne    8015b3 <strtol+0x78>
  801593:	8b 45 08             	mov    0x8(%ebp),%eax
  801596:	8a 00                	mov    (%eax),%al
  801598:	3c 30                	cmp    $0x30,%al
  80159a:	75 17                	jne    8015b3 <strtol+0x78>
  80159c:	8b 45 08             	mov    0x8(%ebp),%eax
  80159f:	40                   	inc    %eax
  8015a0:	8a 00                	mov    (%eax),%al
  8015a2:	3c 78                	cmp    $0x78,%al
  8015a4:	75 0d                	jne    8015b3 <strtol+0x78>
		s += 2, base = 16;
  8015a6:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8015aa:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8015b1:	eb 28                	jmp    8015db <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8015b3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015b7:	75 15                	jne    8015ce <strtol+0x93>
  8015b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bc:	8a 00                	mov    (%eax),%al
  8015be:	3c 30                	cmp    $0x30,%al
  8015c0:	75 0c                	jne    8015ce <strtol+0x93>
		s++, base = 8;
  8015c2:	ff 45 08             	incl   0x8(%ebp)
  8015c5:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8015cc:	eb 0d                	jmp    8015db <strtol+0xa0>
	else if (base == 0)
  8015ce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015d2:	75 07                	jne    8015db <strtol+0xa0>
		base = 10;
  8015d4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8015db:	8b 45 08             	mov    0x8(%ebp),%eax
  8015de:	8a 00                	mov    (%eax),%al
  8015e0:	3c 2f                	cmp    $0x2f,%al
  8015e2:	7e 19                	jle    8015fd <strtol+0xc2>
  8015e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e7:	8a 00                	mov    (%eax),%al
  8015e9:	3c 39                	cmp    $0x39,%al
  8015eb:	7f 10                	jg     8015fd <strtol+0xc2>
			dig = *s - '0';
  8015ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f0:	8a 00                	mov    (%eax),%al
  8015f2:	0f be c0             	movsbl %al,%eax
  8015f5:	83 e8 30             	sub    $0x30,%eax
  8015f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8015fb:	eb 42                	jmp    80163f <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8015fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801600:	8a 00                	mov    (%eax),%al
  801602:	3c 60                	cmp    $0x60,%al
  801604:	7e 19                	jle    80161f <strtol+0xe4>
  801606:	8b 45 08             	mov    0x8(%ebp),%eax
  801609:	8a 00                	mov    (%eax),%al
  80160b:	3c 7a                	cmp    $0x7a,%al
  80160d:	7f 10                	jg     80161f <strtol+0xe4>
			dig = *s - 'a' + 10;
  80160f:	8b 45 08             	mov    0x8(%ebp),%eax
  801612:	8a 00                	mov    (%eax),%al
  801614:	0f be c0             	movsbl %al,%eax
  801617:	83 e8 57             	sub    $0x57,%eax
  80161a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80161d:	eb 20                	jmp    80163f <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80161f:	8b 45 08             	mov    0x8(%ebp),%eax
  801622:	8a 00                	mov    (%eax),%al
  801624:	3c 40                	cmp    $0x40,%al
  801626:	7e 39                	jle    801661 <strtol+0x126>
  801628:	8b 45 08             	mov    0x8(%ebp),%eax
  80162b:	8a 00                	mov    (%eax),%al
  80162d:	3c 5a                	cmp    $0x5a,%al
  80162f:	7f 30                	jg     801661 <strtol+0x126>
			dig = *s - 'A' + 10;
  801631:	8b 45 08             	mov    0x8(%ebp),%eax
  801634:	8a 00                	mov    (%eax),%al
  801636:	0f be c0             	movsbl %al,%eax
  801639:	83 e8 37             	sub    $0x37,%eax
  80163c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80163f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801642:	3b 45 10             	cmp    0x10(%ebp),%eax
  801645:	7d 19                	jge    801660 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801647:	ff 45 08             	incl   0x8(%ebp)
  80164a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80164d:	0f af 45 10          	imul   0x10(%ebp),%eax
  801651:	89 c2                	mov    %eax,%edx
  801653:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801656:	01 d0                	add    %edx,%eax
  801658:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80165b:	e9 7b ff ff ff       	jmp    8015db <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801660:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801661:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801665:	74 08                	je     80166f <strtol+0x134>
		*endptr = (char *) s;
  801667:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166a:	8b 55 08             	mov    0x8(%ebp),%edx
  80166d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80166f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801673:	74 07                	je     80167c <strtol+0x141>
  801675:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801678:	f7 d8                	neg    %eax
  80167a:	eb 03                	jmp    80167f <strtol+0x144>
  80167c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80167f:	c9                   	leave  
  801680:	c3                   	ret    

00801681 <ltostr>:

void
ltostr(long value, char *str)
{
  801681:	55                   	push   %ebp
  801682:	89 e5                	mov    %esp,%ebp
  801684:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801687:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80168e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801695:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801699:	79 13                	jns    8016ae <ltostr+0x2d>
	{
		neg = 1;
  80169b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8016a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a5:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8016a8:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8016ab:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8016ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b1:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8016b6:	99                   	cltd   
  8016b7:	f7 f9                	idiv   %ecx
  8016b9:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8016bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016bf:	8d 50 01             	lea    0x1(%eax),%edx
  8016c2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016c5:	89 c2                	mov    %eax,%edx
  8016c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ca:	01 d0                	add    %edx,%eax
  8016cc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016cf:	83 c2 30             	add    $0x30,%edx
  8016d2:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8016d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016d7:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8016dc:	f7 e9                	imul   %ecx
  8016de:	c1 fa 02             	sar    $0x2,%edx
  8016e1:	89 c8                	mov    %ecx,%eax
  8016e3:	c1 f8 1f             	sar    $0x1f,%eax
  8016e6:	29 c2                	sub    %eax,%edx
  8016e8:	89 d0                	mov    %edx,%eax
  8016ea:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8016ed:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016f0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8016f5:	f7 e9                	imul   %ecx
  8016f7:	c1 fa 02             	sar    $0x2,%edx
  8016fa:	89 c8                	mov    %ecx,%eax
  8016fc:	c1 f8 1f             	sar    $0x1f,%eax
  8016ff:	29 c2                	sub    %eax,%edx
  801701:	89 d0                	mov    %edx,%eax
  801703:	c1 e0 02             	shl    $0x2,%eax
  801706:	01 d0                	add    %edx,%eax
  801708:	01 c0                	add    %eax,%eax
  80170a:	29 c1                	sub    %eax,%ecx
  80170c:	89 ca                	mov    %ecx,%edx
  80170e:	85 d2                	test   %edx,%edx
  801710:	75 9c                	jne    8016ae <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801712:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801719:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80171c:	48                   	dec    %eax
  80171d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801720:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801724:	74 3d                	je     801763 <ltostr+0xe2>
		start = 1 ;
  801726:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80172d:	eb 34                	jmp    801763 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80172f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801732:	8b 45 0c             	mov    0xc(%ebp),%eax
  801735:	01 d0                	add    %edx,%eax
  801737:	8a 00                	mov    (%eax),%al
  801739:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80173c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80173f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801742:	01 c2                	add    %eax,%edx
  801744:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801747:	8b 45 0c             	mov    0xc(%ebp),%eax
  80174a:	01 c8                	add    %ecx,%eax
  80174c:	8a 00                	mov    (%eax),%al
  80174e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801750:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801753:	8b 45 0c             	mov    0xc(%ebp),%eax
  801756:	01 c2                	add    %eax,%edx
  801758:	8a 45 eb             	mov    -0x15(%ebp),%al
  80175b:	88 02                	mov    %al,(%edx)
		start++ ;
  80175d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801760:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801766:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801769:	7c c4                	jl     80172f <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80176b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80176e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801771:	01 d0                	add    %edx,%eax
  801773:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801776:	90                   	nop
  801777:	c9                   	leave  
  801778:	c3                   	ret    

00801779 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801779:	55                   	push   %ebp
  80177a:	89 e5                	mov    %esp,%ebp
  80177c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80177f:	ff 75 08             	pushl  0x8(%ebp)
  801782:	e8 54 fa ff ff       	call   8011db <strlen>
  801787:	83 c4 04             	add    $0x4,%esp
  80178a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80178d:	ff 75 0c             	pushl  0xc(%ebp)
  801790:	e8 46 fa ff ff       	call   8011db <strlen>
  801795:	83 c4 04             	add    $0x4,%esp
  801798:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80179b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8017a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8017a9:	eb 17                	jmp    8017c2 <strcconcat+0x49>
		final[s] = str1[s] ;
  8017ab:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8017b1:	01 c2                	add    %eax,%edx
  8017b3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8017b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b9:	01 c8                	add    %ecx,%eax
  8017bb:	8a 00                	mov    (%eax),%al
  8017bd:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8017bf:	ff 45 fc             	incl   -0x4(%ebp)
  8017c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017c5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8017c8:	7c e1                	jl     8017ab <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8017ca:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8017d1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8017d8:	eb 1f                	jmp    8017f9 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8017da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017dd:	8d 50 01             	lea    0x1(%eax),%edx
  8017e0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8017e3:	89 c2                	mov    %eax,%edx
  8017e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8017e8:	01 c2                	add    %eax,%edx
  8017ea:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8017ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f0:	01 c8                	add    %ecx,%eax
  8017f2:	8a 00                	mov    (%eax),%al
  8017f4:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8017f6:	ff 45 f8             	incl   -0x8(%ebp)
  8017f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017fc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8017ff:	7c d9                	jl     8017da <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801801:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801804:	8b 45 10             	mov    0x10(%ebp),%eax
  801807:	01 d0                	add    %edx,%eax
  801809:	c6 00 00             	movb   $0x0,(%eax)
}
  80180c:	90                   	nop
  80180d:	c9                   	leave  
  80180e:	c3                   	ret    

0080180f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80180f:	55                   	push   %ebp
  801810:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801812:	8b 45 14             	mov    0x14(%ebp),%eax
  801815:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80181b:	8b 45 14             	mov    0x14(%ebp),%eax
  80181e:	8b 00                	mov    (%eax),%eax
  801820:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801827:	8b 45 10             	mov    0x10(%ebp),%eax
  80182a:	01 d0                	add    %edx,%eax
  80182c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801832:	eb 0c                	jmp    801840 <strsplit+0x31>
			*string++ = 0;
  801834:	8b 45 08             	mov    0x8(%ebp),%eax
  801837:	8d 50 01             	lea    0x1(%eax),%edx
  80183a:	89 55 08             	mov    %edx,0x8(%ebp)
  80183d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801840:	8b 45 08             	mov    0x8(%ebp),%eax
  801843:	8a 00                	mov    (%eax),%al
  801845:	84 c0                	test   %al,%al
  801847:	74 18                	je     801861 <strsplit+0x52>
  801849:	8b 45 08             	mov    0x8(%ebp),%eax
  80184c:	8a 00                	mov    (%eax),%al
  80184e:	0f be c0             	movsbl %al,%eax
  801851:	50                   	push   %eax
  801852:	ff 75 0c             	pushl  0xc(%ebp)
  801855:	e8 13 fb ff ff       	call   80136d <strchr>
  80185a:	83 c4 08             	add    $0x8,%esp
  80185d:	85 c0                	test   %eax,%eax
  80185f:	75 d3                	jne    801834 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801861:	8b 45 08             	mov    0x8(%ebp),%eax
  801864:	8a 00                	mov    (%eax),%al
  801866:	84 c0                	test   %al,%al
  801868:	74 5a                	je     8018c4 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80186a:	8b 45 14             	mov    0x14(%ebp),%eax
  80186d:	8b 00                	mov    (%eax),%eax
  80186f:	83 f8 0f             	cmp    $0xf,%eax
  801872:	75 07                	jne    80187b <strsplit+0x6c>
		{
			return 0;
  801874:	b8 00 00 00 00       	mov    $0x0,%eax
  801879:	eb 66                	jmp    8018e1 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80187b:	8b 45 14             	mov    0x14(%ebp),%eax
  80187e:	8b 00                	mov    (%eax),%eax
  801880:	8d 48 01             	lea    0x1(%eax),%ecx
  801883:	8b 55 14             	mov    0x14(%ebp),%edx
  801886:	89 0a                	mov    %ecx,(%edx)
  801888:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80188f:	8b 45 10             	mov    0x10(%ebp),%eax
  801892:	01 c2                	add    %eax,%edx
  801894:	8b 45 08             	mov    0x8(%ebp),%eax
  801897:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801899:	eb 03                	jmp    80189e <strsplit+0x8f>
			string++;
  80189b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80189e:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a1:	8a 00                	mov    (%eax),%al
  8018a3:	84 c0                	test   %al,%al
  8018a5:	74 8b                	je     801832 <strsplit+0x23>
  8018a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018aa:	8a 00                	mov    (%eax),%al
  8018ac:	0f be c0             	movsbl %al,%eax
  8018af:	50                   	push   %eax
  8018b0:	ff 75 0c             	pushl  0xc(%ebp)
  8018b3:	e8 b5 fa ff ff       	call   80136d <strchr>
  8018b8:	83 c4 08             	add    $0x8,%esp
  8018bb:	85 c0                	test   %eax,%eax
  8018bd:	74 dc                	je     80189b <strsplit+0x8c>
			string++;
	}
  8018bf:	e9 6e ff ff ff       	jmp    801832 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8018c4:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8018c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8018c8:	8b 00                	mov    (%eax),%eax
  8018ca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8018d4:	01 d0                	add    %edx,%eax
  8018d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8018dc:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8018e1:	c9                   	leave  
  8018e2:	c3                   	ret    

008018e3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
  8018e6:	57                   	push   %edi
  8018e7:	56                   	push   %esi
  8018e8:	53                   	push   %ebx
  8018e9:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018f5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018f8:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018fb:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018fe:	cd 30                	int    $0x30
  801900:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801903:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801906:	83 c4 10             	add    $0x10,%esp
  801909:	5b                   	pop    %ebx
  80190a:	5e                   	pop    %esi
  80190b:	5f                   	pop    %edi
  80190c:	5d                   	pop    %ebp
  80190d:	c3                   	ret    

0080190e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
  801911:	83 ec 04             	sub    $0x4,%esp
  801914:	8b 45 10             	mov    0x10(%ebp),%eax
  801917:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80191a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80191e:	8b 45 08             	mov    0x8(%ebp),%eax
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	52                   	push   %edx
  801926:	ff 75 0c             	pushl  0xc(%ebp)
  801929:	50                   	push   %eax
  80192a:	6a 00                	push   $0x0
  80192c:	e8 b2 ff ff ff       	call   8018e3 <syscall>
  801931:	83 c4 18             	add    $0x18,%esp
}
  801934:	90                   	nop
  801935:	c9                   	leave  
  801936:	c3                   	ret    

00801937 <sys_cgetc>:

int
sys_cgetc(void)
{
  801937:	55                   	push   %ebp
  801938:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	6a 01                	push   $0x1
  801946:	e8 98 ff ff ff       	call   8018e3 <syscall>
  80194b:	83 c4 18             	add    $0x18,%esp
}
  80194e:	c9                   	leave  
  80194f:	c3                   	ret    

00801950 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801953:	8b 55 0c             	mov    0xc(%ebp),%edx
  801956:	8b 45 08             	mov    0x8(%ebp),%eax
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	52                   	push   %edx
  801960:	50                   	push   %eax
  801961:	6a 05                	push   $0x5
  801963:	e8 7b ff ff ff       	call   8018e3 <syscall>
  801968:	83 c4 18             	add    $0x18,%esp
}
  80196b:	c9                   	leave  
  80196c:	c3                   	ret    

0080196d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80196d:	55                   	push   %ebp
  80196e:	89 e5                	mov    %esp,%ebp
  801970:	56                   	push   %esi
  801971:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801972:	8b 75 18             	mov    0x18(%ebp),%esi
  801975:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801978:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80197b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197e:	8b 45 08             	mov    0x8(%ebp),%eax
  801981:	56                   	push   %esi
  801982:	53                   	push   %ebx
  801983:	51                   	push   %ecx
  801984:	52                   	push   %edx
  801985:	50                   	push   %eax
  801986:	6a 06                	push   $0x6
  801988:	e8 56 ff ff ff       	call   8018e3 <syscall>
  80198d:	83 c4 18             	add    $0x18,%esp
}
  801990:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801993:	5b                   	pop    %ebx
  801994:	5e                   	pop    %esi
  801995:	5d                   	pop    %ebp
  801996:	c3                   	ret    

00801997 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80199a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80199d:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	52                   	push   %edx
  8019a7:	50                   	push   %eax
  8019a8:	6a 07                	push   $0x7
  8019aa:	e8 34 ff ff ff       	call   8018e3 <syscall>
  8019af:	83 c4 18             	add    $0x18,%esp
}
  8019b2:	c9                   	leave  
  8019b3:	c3                   	ret    

008019b4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019b4:	55                   	push   %ebp
  8019b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	ff 75 0c             	pushl  0xc(%ebp)
  8019c0:	ff 75 08             	pushl  0x8(%ebp)
  8019c3:	6a 08                	push   $0x8
  8019c5:	e8 19 ff ff ff       	call   8018e3 <syscall>
  8019ca:	83 c4 18             	add    $0x18,%esp
}
  8019cd:	c9                   	leave  
  8019ce:	c3                   	ret    

008019cf <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019cf:	55                   	push   %ebp
  8019d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 09                	push   $0x9
  8019de:	e8 00 ff ff ff       	call   8018e3 <syscall>
  8019e3:	83 c4 18             	add    $0x18,%esp
}
  8019e6:	c9                   	leave  
  8019e7:	c3                   	ret    

008019e8 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019e8:	55                   	push   %ebp
  8019e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 0a                	push   $0xa
  8019f7:	e8 e7 fe ff ff       	call   8018e3 <syscall>
  8019fc:	83 c4 18             	add    $0x18,%esp
}
  8019ff:	c9                   	leave  
  801a00:	c3                   	ret    

00801a01 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 0b                	push   $0xb
  801a10:	e8 ce fe ff ff       	call   8018e3 <syscall>
  801a15:	83 c4 18             	add    $0x18,%esp
}
  801a18:	c9                   	leave  
  801a19:	c3                   	ret    

00801a1a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a1a:	55                   	push   %ebp
  801a1b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	ff 75 0c             	pushl  0xc(%ebp)
  801a26:	ff 75 08             	pushl  0x8(%ebp)
  801a29:	6a 0f                	push   $0xf
  801a2b:	e8 b3 fe ff ff       	call   8018e3 <syscall>
  801a30:	83 c4 18             	add    $0x18,%esp
	return;
  801a33:	90                   	nop
}
  801a34:	c9                   	leave  
  801a35:	c3                   	ret    

00801a36 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	ff 75 0c             	pushl  0xc(%ebp)
  801a42:	ff 75 08             	pushl  0x8(%ebp)
  801a45:	6a 10                	push   $0x10
  801a47:	e8 97 fe ff ff       	call   8018e3 <syscall>
  801a4c:	83 c4 18             	add    $0x18,%esp
	return ;
  801a4f:	90                   	nop
}
  801a50:	c9                   	leave  
  801a51:	c3                   	ret    

00801a52 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	ff 75 10             	pushl  0x10(%ebp)
  801a5c:	ff 75 0c             	pushl  0xc(%ebp)
  801a5f:	ff 75 08             	pushl  0x8(%ebp)
  801a62:	6a 11                	push   $0x11
  801a64:	e8 7a fe ff ff       	call   8018e3 <syscall>
  801a69:	83 c4 18             	add    $0x18,%esp
	return ;
  801a6c:	90                   	nop
}
  801a6d:	c9                   	leave  
  801a6e:	c3                   	ret    

00801a6f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a6f:	55                   	push   %ebp
  801a70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 0c                	push   $0xc
  801a7e:	e8 60 fe ff ff       	call   8018e3 <syscall>
  801a83:	83 c4 18             	add    $0x18,%esp
}
  801a86:	c9                   	leave  
  801a87:	c3                   	ret    

00801a88 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	ff 75 08             	pushl  0x8(%ebp)
  801a96:	6a 0d                	push   $0xd
  801a98:	e8 46 fe ff ff       	call   8018e3 <syscall>
  801a9d:	83 c4 18             	add    $0x18,%esp
}
  801aa0:	c9                   	leave  
  801aa1:	c3                   	ret    

00801aa2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801aa2:	55                   	push   %ebp
  801aa3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 0e                	push   $0xe
  801ab1:	e8 2d fe ff ff       	call   8018e3 <syscall>
  801ab6:	83 c4 18             	add    $0x18,%esp
}
  801ab9:	90                   	nop
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

00801abc <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 13                	push   $0x13
  801acb:	e8 13 fe ff ff       	call   8018e3 <syscall>
  801ad0:	83 c4 18             	add    $0x18,%esp
}
  801ad3:	90                   	nop
  801ad4:	c9                   	leave  
  801ad5:	c3                   	ret    

00801ad6 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 14                	push   $0x14
  801ae5:	e8 f9 fd ff ff       	call   8018e3 <syscall>
  801aea:	83 c4 18             	add    $0x18,%esp
}
  801aed:	90                   	nop
  801aee:	c9                   	leave  
  801aef:	c3                   	ret    

00801af0 <sys_cputc>:


void
sys_cputc(const char c)
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
  801af3:	83 ec 04             	sub    $0x4,%esp
  801af6:	8b 45 08             	mov    0x8(%ebp),%eax
  801af9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801afc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	50                   	push   %eax
  801b09:	6a 15                	push   $0x15
  801b0b:	e8 d3 fd ff ff       	call   8018e3 <syscall>
  801b10:	83 c4 18             	add    $0x18,%esp
}
  801b13:	90                   	nop
  801b14:	c9                   	leave  
  801b15:	c3                   	ret    

00801b16 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b16:	55                   	push   %ebp
  801b17:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 16                	push   $0x16
  801b25:	e8 b9 fd ff ff       	call   8018e3 <syscall>
  801b2a:	83 c4 18             	add    $0x18,%esp
}
  801b2d:	90                   	nop
  801b2e:	c9                   	leave  
  801b2f:	c3                   	ret    

00801b30 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b33:	8b 45 08             	mov    0x8(%ebp),%eax
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	ff 75 0c             	pushl  0xc(%ebp)
  801b3f:	50                   	push   %eax
  801b40:	6a 17                	push   $0x17
  801b42:	e8 9c fd ff ff       	call   8018e3 <syscall>
  801b47:	83 c4 18             	add    $0x18,%esp
}
  801b4a:	c9                   	leave  
  801b4b:	c3                   	ret    

00801b4c <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b52:	8b 45 08             	mov    0x8(%ebp),%eax
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	52                   	push   %edx
  801b5c:	50                   	push   %eax
  801b5d:	6a 1a                	push   $0x1a
  801b5f:	e8 7f fd ff ff       	call   8018e3 <syscall>
  801b64:	83 c4 18             	add    $0x18,%esp
}
  801b67:	c9                   	leave  
  801b68:	c3                   	ret    

00801b69 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b69:	55                   	push   %ebp
  801b6a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	52                   	push   %edx
  801b79:	50                   	push   %eax
  801b7a:	6a 18                	push   $0x18
  801b7c:	e8 62 fd ff ff       	call   8018e3 <syscall>
  801b81:	83 c4 18             	add    $0x18,%esp
}
  801b84:	90                   	nop
  801b85:	c9                   	leave  
  801b86:	c3                   	ret    

00801b87 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b87:	55                   	push   %ebp
  801b88:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	52                   	push   %edx
  801b97:	50                   	push   %eax
  801b98:	6a 19                	push   $0x19
  801b9a:	e8 44 fd ff ff       	call   8018e3 <syscall>
  801b9f:	83 c4 18             	add    $0x18,%esp
}
  801ba2:	90                   	nop
  801ba3:	c9                   	leave  
  801ba4:	c3                   	ret    

00801ba5 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ba5:	55                   	push   %ebp
  801ba6:	89 e5                	mov    %esp,%ebp
  801ba8:	83 ec 04             	sub    $0x4,%esp
  801bab:	8b 45 10             	mov    0x10(%ebp),%eax
  801bae:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801bb1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bb4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbb:	6a 00                	push   $0x0
  801bbd:	51                   	push   %ecx
  801bbe:	52                   	push   %edx
  801bbf:	ff 75 0c             	pushl  0xc(%ebp)
  801bc2:	50                   	push   %eax
  801bc3:	6a 1b                	push   $0x1b
  801bc5:	e8 19 fd ff ff       	call   8018e3 <syscall>
  801bca:	83 c4 18             	add    $0x18,%esp
}
  801bcd:	c9                   	leave  
  801bce:	c3                   	ret    

00801bcf <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801bcf:	55                   	push   %ebp
  801bd0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801bd2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	52                   	push   %edx
  801bdf:	50                   	push   %eax
  801be0:	6a 1c                	push   $0x1c
  801be2:	e8 fc fc ff ff       	call   8018e3 <syscall>
  801be7:	83 c4 18             	add    $0x18,%esp
}
  801bea:	c9                   	leave  
  801beb:	c3                   	ret    

00801bec <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bef:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bf2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	51                   	push   %ecx
  801bfd:	52                   	push   %edx
  801bfe:	50                   	push   %eax
  801bff:	6a 1d                	push   $0x1d
  801c01:	e8 dd fc ff ff       	call   8018e3 <syscall>
  801c06:	83 c4 18             	add    $0x18,%esp
}
  801c09:	c9                   	leave  
  801c0a:	c3                   	ret    

00801c0b <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c11:	8b 45 08             	mov    0x8(%ebp),%eax
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	52                   	push   %edx
  801c1b:	50                   	push   %eax
  801c1c:	6a 1e                	push   $0x1e
  801c1e:	e8 c0 fc ff ff       	call   8018e3 <syscall>
  801c23:	83 c4 18             	add    $0x18,%esp
}
  801c26:	c9                   	leave  
  801c27:	c3                   	ret    

00801c28 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 1f                	push   $0x1f
  801c37:	e8 a7 fc ff ff       	call   8018e3 <syscall>
  801c3c:	83 c4 18             	add    $0x18,%esp
}
  801c3f:	c9                   	leave  
  801c40:	c3                   	ret    

00801c41 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c41:	55                   	push   %ebp
  801c42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c44:	8b 45 08             	mov    0x8(%ebp),%eax
  801c47:	6a 00                	push   $0x0
  801c49:	ff 75 14             	pushl  0x14(%ebp)
  801c4c:	ff 75 10             	pushl  0x10(%ebp)
  801c4f:	ff 75 0c             	pushl  0xc(%ebp)
  801c52:	50                   	push   %eax
  801c53:	6a 20                	push   $0x20
  801c55:	e8 89 fc ff ff       	call   8018e3 <syscall>
  801c5a:	83 c4 18             	add    $0x18,%esp
}
  801c5d:	c9                   	leave  
  801c5e:	c3                   	ret    

00801c5f <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c62:	8b 45 08             	mov    0x8(%ebp),%eax
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	50                   	push   %eax
  801c6e:	6a 21                	push   $0x21
  801c70:	e8 6e fc ff ff       	call   8018e3 <syscall>
  801c75:	83 c4 18             	add    $0x18,%esp
}
  801c78:	90                   	nop
  801c79:	c9                   	leave  
  801c7a:	c3                   	ret    

00801c7b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c7b:	55                   	push   %ebp
  801c7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	50                   	push   %eax
  801c8a:	6a 22                	push   $0x22
  801c8c:	e8 52 fc ff ff       	call   8018e3 <syscall>
  801c91:	83 c4 18             	add    $0x18,%esp
}
  801c94:	c9                   	leave  
  801c95:	c3                   	ret    

00801c96 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c96:	55                   	push   %ebp
  801c97:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 02                	push   $0x2
  801ca5:	e8 39 fc ff ff       	call   8018e3 <syscall>
  801caa:	83 c4 18             	add    $0x18,%esp
}
  801cad:	c9                   	leave  
  801cae:	c3                   	ret    

00801caf <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801caf:	55                   	push   %ebp
  801cb0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 03                	push   $0x3
  801cbe:	e8 20 fc ff ff       	call   8018e3 <syscall>
  801cc3:	83 c4 18             	add    $0x18,%esp
}
  801cc6:	c9                   	leave  
  801cc7:	c3                   	ret    

00801cc8 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801cc8:	55                   	push   %ebp
  801cc9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 04                	push   $0x4
  801cd7:	e8 07 fc ff ff       	call   8018e3 <syscall>
  801cdc:	83 c4 18             	add    $0x18,%esp
}
  801cdf:	c9                   	leave  
  801ce0:	c3                   	ret    

00801ce1 <sys_exit_env>:


void sys_exit_env(void)
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 23                	push   $0x23
  801cf0:	e8 ee fb ff ff       	call   8018e3 <syscall>
  801cf5:	83 c4 18             	add    $0x18,%esp
}
  801cf8:	90                   	nop
  801cf9:	c9                   	leave  
  801cfa:	c3                   	ret    

00801cfb <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801cfb:	55                   	push   %ebp
  801cfc:	89 e5                	mov    %esp,%ebp
  801cfe:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d01:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d04:	8d 50 04             	lea    0x4(%eax),%edx
  801d07:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	52                   	push   %edx
  801d11:	50                   	push   %eax
  801d12:	6a 24                	push   $0x24
  801d14:	e8 ca fb ff ff       	call   8018e3 <syscall>
  801d19:	83 c4 18             	add    $0x18,%esp
	return result;
  801d1c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d1f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d22:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d25:	89 01                	mov    %eax,(%ecx)
  801d27:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2d:	c9                   	leave  
  801d2e:	c2 04 00             	ret    $0x4

00801d31 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d31:	55                   	push   %ebp
  801d32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	ff 75 10             	pushl  0x10(%ebp)
  801d3b:	ff 75 0c             	pushl  0xc(%ebp)
  801d3e:	ff 75 08             	pushl  0x8(%ebp)
  801d41:	6a 12                	push   $0x12
  801d43:	e8 9b fb ff ff       	call   8018e3 <syscall>
  801d48:	83 c4 18             	add    $0x18,%esp
	return ;
  801d4b:	90                   	nop
}
  801d4c:	c9                   	leave  
  801d4d:	c3                   	ret    

00801d4e <sys_rcr2>:
uint32 sys_rcr2()
{
  801d4e:	55                   	push   %ebp
  801d4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 25                	push   $0x25
  801d5d:	e8 81 fb ff ff       	call   8018e3 <syscall>
  801d62:	83 c4 18             	add    $0x18,%esp
}
  801d65:	c9                   	leave  
  801d66:	c3                   	ret    

00801d67 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d67:	55                   	push   %ebp
  801d68:	89 e5                	mov    %esp,%ebp
  801d6a:	83 ec 04             	sub    $0x4,%esp
  801d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d70:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d73:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	50                   	push   %eax
  801d80:	6a 26                	push   $0x26
  801d82:	e8 5c fb ff ff       	call   8018e3 <syscall>
  801d87:	83 c4 18             	add    $0x18,%esp
	return ;
  801d8a:	90                   	nop
}
  801d8b:	c9                   	leave  
  801d8c:	c3                   	ret    

00801d8d <rsttst>:
void rsttst()
{
  801d8d:	55                   	push   %ebp
  801d8e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 28                	push   $0x28
  801d9c:	e8 42 fb ff ff       	call   8018e3 <syscall>
  801da1:	83 c4 18             	add    $0x18,%esp
	return ;
  801da4:	90                   	nop
}
  801da5:	c9                   	leave  
  801da6:	c3                   	ret    

00801da7 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801da7:	55                   	push   %ebp
  801da8:	89 e5                	mov    %esp,%ebp
  801daa:	83 ec 04             	sub    $0x4,%esp
  801dad:	8b 45 14             	mov    0x14(%ebp),%eax
  801db0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801db3:	8b 55 18             	mov    0x18(%ebp),%edx
  801db6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801dba:	52                   	push   %edx
  801dbb:	50                   	push   %eax
  801dbc:	ff 75 10             	pushl  0x10(%ebp)
  801dbf:	ff 75 0c             	pushl  0xc(%ebp)
  801dc2:	ff 75 08             	pushl  0x8(%ebp)
  801dc5:	6a 27                	push   $0x27
  801dc7:	e8 17 fb ff ff       	call   8018e3 <syscall>
  801dcc:	83 c4 18             	add    $0x18,%esp
	return ;
  801dcf:	90                   	nop
}
  801dd0:	c9                   	leave  
  801dd1:	c3                   	ret    

00801dd2 <chktst>:
void chktst(uint32 n)
{
  801dd2:	55                   	push   %ebp
  801dd3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	ff 75 08             	pushl  0x8(%ebp)
  801de0:	6a 29                	push   $0x29
  801de2:	e8 fc fa ff ff       	call   8018e3 <syscall>
  801de7:	83 c4 18             	add    $0x18,%esp
	return ;
  801dea:	90                   	nop
}
  801deb:	c9                   	leave  
  801dec:	c3                   	ret    

00801ded <inctst>:

void inctst()
{
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 2a                	push   $0x2a
  801dfc:	e8 e2 fa ff ff       	call   8018e3 <syscall>
  801e01:	83 c4 18             	add    $0x18,%esp
	return ;
  801e04:	90                   	nop
}
  801e05:	c9                   	leave  
  801e06:	c3                   	ret    

00801e07 <gettst>:
uint32 gettst()
{
  801e07:	55                   	push   %ebp
  801e08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 2b                	push   $0x2b
  801e16:	e8 c8 fa ff ff       	call   8018e3 <syscall>
  801e1b:	83 c4 18             	add    $0x18,%esp
}
  801e1e:	c9                   	leave  
  801e1f:	c3                   	ret    

00801e20 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e20:	55                   	push   %ebp
  801e21:	89 e5                	mov    %esp,%ebp
  801e23:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 2c                	push   $0x2c
  801e32:	e8 ac fa ff ff       	call   8018e3 <syscall>
  801e37:	83 c4 18             	add    $0x18,%esp
  801e3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e3d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e41:	75 07                	jne    801e4a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e43:	b8 01 00 00 00       	mov    $0x1,%eax
  801e48:	eb 05                	jmp    801e4f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e4f:	c9                   	leave  
  801e50:	c3                   	ret    

00801e51 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e51:	55                   	push   %ebp
  801e52:	89 e5                	mov    %esp,%ebp
  801e54:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e57:	6a 00                	push   $0x0
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 2c                	push   $0x2c
  801e63:	e8 7b fa ff ff       	call   8018e3 <syscall>
  801e68:	83 c4 18             	add    $0x18,%esp
  801e6b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e6e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e72:	75 07                	jne    801e7b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e74:	b8 01 00 00 00       	mov    $0x1,%eax
  801e79:	eb 05                	jmp    801e80 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e80:	c9                   	leave  
  801e81:	c3                   	ret    

00801e82 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e82:	55                   	push   %ebp
  801e83:	89 e5                	mov    %esp,%ebp
  801e85:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 00                	push   $0x0
  801e8e:	6a 00                	push   $0x0
  801e90:	6a 00                	push   $0x0
  801e92:	6a 2c                	push   $0x2c
  801e94:	e8 4a fa ff ff       	call   8018e3 <syscall>
  801e99:	83 c4 18             	add    $0x18,%esp
  801e9c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e9f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ea3:	75 07                	jne    801eac <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ea5:	b8 01 00 00 00       	mov    $0x1,%eax
  801eaa:	eb 05                	jmp    801eb1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801eac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eb1:	c9                   	leave  
  801eb2:	c3                   	ret    

00801eb3 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801eb3:	55                   	push   %ebp
  801eb4:	89 e5                	mov    %esp,%ebp
  801eb6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	6a 00                	push   $0x0
  801ec1:	6a 00                	push   $0x0
  801ec3:	6a 2c                	push   $0x2c
  801ec5:	e8 19 fa ff ff       	call   8018e3 <syscall>
  801eca:	83 c4 18             	add    $0x18,%esp
  801ecd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ed0:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ed4:	75 07                	jne    801edd <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ed6:	b8 01 00 00 00       	mov    $0x1,%eax
  801edb:	eb 05                	jmp    801ee2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801edd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ee2:	c9                   	leave  
  801ee3:	c3                   	ret    

00801ee4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ee4:	55                   	push   %ebp
  801ee5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 00                	push   $0x0
  801eef:	ff 75 08             	pushl  0x8(%ebp)
  801ef2:	6a 2d                	push   $0x2d
  801ef4:	e8 ea f9 ff ff       	call   8018e3 <syscall>
  801ef9:	83 c4 18             	add    $0x18,%esp
	return ;
  801efc:	90                   	nop
}
  801efd:	c9                   	leave  
  801efe:	c3                   	ret    

00801eff <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801eff:	55                   	push   %ebp
  801f00:	89 e5                	mov    %esp,%ebp
  801f02:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f03:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f06:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f09:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0f:	6a 00                	push   $0x0
  801f11:	53                   	push   %ebx
  801f12:	51                   	push   %ecx
  801f13:	52                   	push   %edx
  801f14:	50                   	push   %eax
  801f15:	6a 2e                	push   $0x2e
  801f17:	e8 c7 f9 ff ff       	call   8018e3 <syscall>
  801f1c:	83 c4 18             	add    $0x18,%esp
}
  801f1f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f22:	c9                   	leave  
  801f23:	c3                   	ret    

00801f24 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f24:	55                   	push   %ebp
  801f25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f27:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2d:	6a 00                	push   $0x0
  801f2f:	6a 00                	push   $0x0
  801f31:	6a 00                	push   $0x0
  801f33:	52                   	push   %edx
  801f34:	50                   	push   %eax
  801f35:	6a 2f                	push   $0x2f
  801f37:	e8 a7 f9 ff ff       	call   8018e3 <syscall>
  801f3c:	83 c4 18             	add    $0x18,%esp
}
  801f3f:	c9                   	leave  
  801f40:	c3                   	ret    
  801f41:	66 90                	xchg   %ax,%ax
  801f43:	90                   	nop

00801f44 <__udivdi3>:
  801f44:	55                   	push   %ebp
  801f45:	57                   	push   %edi
  801f46:	56                   	push   %esi
  801f47:	53                   	push   %ebx
  801f48:	83 ec 1c             	sub    $0x1c,%esp
  801f4b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801f4f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801f53:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f57:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f5b:	89 ca                	mov    %ecx,%edx
  801f5d:	89 f8                	mov    %edi,%eax
  801f5f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801f63:	85 f6                	test   %esi,%esi
  801f65:	75 2d                	jne    801f94 <__udivdi3+0x50>
  801f67:	39 cf                	cmp    %ecx,%edi
  801f69:	77 65                	ja     801fd0 <__udivdi3+0x8c>
  801f6b:	89 fd                	mov    %edi,%ebp
  801f6d:	85 ff                	test   %edi,%edi
  801f6f:	75 0b                	jne    801f7c <__udivdi3+0x38>
  801f71:	b8 01 00 00 00       	mov    $0x1,%eax
  801f76:	31 d2                	xor    %edx,%edx
  801f78:	f7 f7                	div    %edi
  801f7a:	89 c5                	mov    %eax,%ebp
  801f7c:	31 d2                	xor    %edx,%edx
  801f7e:	89 c8                	mov    %ecx,%eax
  801f80:	f7 f5                	div    %ebp
  801f82:	89 c1                	mov    %eax,%ecx
  801f84:	89 d8                	mov    %ebx,%eax
  801f86:	f7 f5                	div    %ebp
  801f88:	89 cf                	mov    %ecx,%edi
  801f8a:	89 fa                	mov    %edi,%edx
  801f8c:	83 c4 1c             	add    $0x1c,%esp
  801f8f:	5b                   	pop    %ebx
  801f90:	5e                   	pop    %esi
  801f91:	5f                   	pop    %edi
  801f92:	5d                   	pop    %ebp
  801f93:	c3                   	ret    
  801f94:	39 ce                	cmp    %ecx,%esi
  801f96:	77 28                	ja     801fc0 <__udivdi3+0x7c>
  801f98:	0f bd fe             	bsr    %esi,%edi
  801f9b:	83 f7 1f             	xor    $0x1f,%edi
  801f9e:	75 40                	jne    801fe0 <__udivdi3+0x9c>
  801fa0:	39 ce                	cmp    %ecx,%esi
  801fa2:	72 0a                	jb     801fae <__udivdi3+0x6a>
  801fa4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801fa8:	0f 87 9e 00 00 00    	ja     80204c <__udivdi3+0x108>
  801fae:	b8 01 00 00 00       	mov    $0x1,%eax
  801fb3:	89 fa                	mov    %edi,%edx
  801fb5:	83 c4 1c             	add    $0x1c,%esp
  801fb8:	5b                   	pop    %ebx
  801fb9:	5e                   	pop    %esi
  801fba:	5f                   	pop    %edi
  801fbb:	5d                   	pop    %ebp
  801fbc:	c3                   	ret    
  801fbd:	8d 76 00             	lea    0x0(%esi),%esi
  801fc0:	31 ff                	xor    %edi,%edi
  801fc2:	31 c0                	xor    %eax,%eax
  801fc4:	89 fa                	mov    %edi,%edx
  801fc6:	83 c4 1c             	add    $0x1c,%esp
  801fc9:	5b                   	pop    %ebx
  801fca:	5e                   	pop    %esi
  801fcb:	5f                   	pop    %edi
  801fcc:	5d                   	pop    %ebp
  801fcd:	c3                   	ret    
  801fce:	66 90                	xchg   %ax,%ax
  801fd0:	89 d8                	mov    %ebx,%eax
  801fd2:	f7 f7                	div    %edi
  801fd4:	31 ff                	xor    %edi,%edi
  801fd6:	89 fa                	mov    %edi,%edx
  801fd8:	83 c4 1c             	add    $0x1c,%esp
  801fdb:	5b                   	pop    %ebx
  801fdc:	5e                   	pop    %esi
  801fdd:	5f                   	pop    %edi
  801fde:	5d                   	pop    %ebp
  801fdf:	c3                   	ret    
  801fe0:	bd 20 00 00 00       	mov    $0x20,%ebp
  801fe5:	89 eb                	mov    %ebp,%ebx
  801fe7:	29 fb                	sub    %edi,%ebx
  801fe9:	89 f9                	mov    %edi,%ecx
  801feb:	d3 e6                	shl    %cl,%esi
  801fed:	89 c5                	mov    %eax,%ebp
  801fef:	88 d9                	mov    %bl,%cl
  801ff1:	d3 ed                	shr    %cl,%ebp
  801ff3:	89 e9                	mov    %ebp,%ecx
  801ff5:	09 f1                	or     %esi,%ecx
  801ff7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801ffb:	89 f9                	mov    %edi,%ecx
  801ffd:	d3 e0                	shl    %cl,%eax
  801fff:	89 c5                	mov    %eax,%ebp
  802001:	89 d6                	mov    %edx,%esi
  802003:	88 d9                	mov    %bl,%cl
  802005:	d3 ee                	shr    %cl,%esi
  802007:	89 f9                	mov    %edi,%ecx
  802009:	d3 e2                	shl    %cl,%edx
  80200b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80200f:	88 d9                	mov    %bl,%cl
  802011:	d3 e8                	shr    %cl,%eax
  802013:	09 c2                	or     %eax,%edx
  802015:	89 d0                	mov    %edx,%eax
  802017:	89 f2                	mov    %esi,%edx
  802019:	f7 74 24 0c          	divl   0xc(%esp)
  80201d:	89 d6                	mov    %edx,%esi
  80201f:	89 c3                	mov    %eax,%ebx
  802021:	f7 e5                	mul    %ebp
  802023:	39 d6                	cmp    %edx,%esi
  802025:	72 19                	jb     802040 <__udivdi3+0xfc>
  802027:	74 0b                	je     802034 <__udivdi3+0xf0>
  802029:	89 d8                	mov    %ebx,%eax
  80202b:	31 ff                	xor    %edi,%edi
  80202d:	e9 58 ff ff ff       	jmp    801f8a <__udivdi3+0x46>
  802032:	66 90                	xchg   %ax,%ax
  802034:	8b 54 24 08          	mov    0x8(%esp),%edx
  802038:	89 f9                	mov    %edi,%ecx
  80203a:	d3 e2                	shl    %cl,%edx
  80203c:	39 c2                	cmp    %eax,%edx
  80203e:	73 e9                	jae    802029 <__udivdi3+0xe5>
  802040:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802043:	31 ff                	xor    %edi,%edi
  802045:	e9 40 ff ff ff       	jmp    801f8a <__udivdi3+0x46>
  80204a:	66 90                	xchg   %ax,%ax
  80204c:	31 c0                	xor    %eax,%eax
  80204e:	e9 37 ff ff ff       	jmp    801f8a <__udivdi3+0x46>
  802053:	90                   	nop

00802054 <__umoddi3>:
  802054:	55                   	push   %ebp
  802055:	57                   	push   %edi
  802056:	56                   	push   %esi
  802057:	53                   	push   %ebx
  802058:	83 ec 1c             	sub    $0x1c,%esp
  80205b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80205f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802063:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802067:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80206b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80206f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802073:	89 f3                	mov    %esi,%ebx
  802075:	89 fa                	mov    %edi,%edx
  802077:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80207b:	89 34 24             	mov    %esi,(%esp)
  80207e:	85 c0                	test   %eax,%eax
  802080:	75 1a                	jne    80209c <__umoddi3+0x48>
  802082:	39 f7                	cmp    %esi,%edi
  802084:	0f 86 a2 00 00 00    	jbe    80212c <__umoddi3+0xd8>
  80208a:	89 c8                	mov    %ecx,%eax
  80208c:	89 f2                	mov    %esi,%edx
  80208e:	f7 f7                	div    %edi
  802090:	89 d0                	mov    %edx,%eax
  802092:	31 d2                	xor    %edx,%edx
  802094:	83 c4 1c             	add    $0x1c,%esp
  802097:	5b                   	pop    %ebx
  802098:	5e                   	pop    %esi
  802099:	5f                   	pop    %edi
  80209a:	5d                   	pop    %ebp
  80209b:	c3                   	ret    
  80209c:	39 f0                	cmp    %esi,%eax
  80209e:	0f 87 ac 00 00 00    	ja     802150 <__umoddi3+0xfc>
  8020a4:	0f bd e8             	bsr    %eax,%ebp
  8020a7:	83 f5 1f             	xor    $0x1f,%ebp
  8020aa:	0f 84 ac 00 00 00    	je     80215c <__umoddi3+0x108>
  8020b0:	bf 20 00 00 00       	mov    $0x20,%edi
  8020b5:	29 ef                	sub    %ebp,%edi
  8020b7:	89 fe                	mov    %edi,%esi
  8020b9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8020bd:	89 e9                	mov    %ebp,%ecx
  8020bf:	d3 e0                	shl    %cl,%eax
  8020c1:	89 d7                	mov    %edx,%edi
  8020c3:	89 f1                	mov    %esi,%ecx
  8020c5:	d3 ef                	shr    %cl,%edi
  8020c7:	09 c7                	or     %eax,%edi
  8020c9:	89 e9                	mov    %ebp,%ecx
  8020cb:	d3 e2                	shl    %cl,%edx
  8020cd:	89 14 24             	mov    %edx,(%esp)
  8020d0:	89 d8                	mov    %ebx,%eax
  8020d2:	d3 e0                	shl    %cl,%eax
  8020d4:	89 c2                	mov    %eax,%edx
  8020d6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8020da:	d3 e0                	shl    %cl,%eax
  8020dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020e0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8020e4:	89 f1                	mov    %esi,%ecx
  8020e6:	d3 e8                	shr    %cl,%eax
  8020e8:	09 d0                	or     %edx,%eax
  8020ea:	d3 eb                	shr    %cl,%ebx
  8020ec:	89 da                	mov    %ebx,%edx
  8020ee:	f7 f7                	div    %edi
  8020f0:	89 d3                	mov    %edx,%ebx
  8020f2:	f7 24 24             	mull   (%esp)
  8020f5:	89 c6                	mov    %eax,%esi
  8020f7:	89 d1                	mov    %edx,%ecx
  8020f9:	39 d3                	cmp    %edx,%ebx
  8020fb:	0f 82 87 00 00 00    	jb     802188 <__umoddi3+0x134>
  802101:	0f 84 91 00 00 00    	je     802198 <__umoddi3+0x144>
  802107:	8b 54 24 04          	mov    0x4(%esp),%edx
  80210b:	29 f2                	sub    %esi,%edx
  80210d:	19 cb                	sbb    %ecx,%ebx
  80210f:	89 d8                	mov    %ebx,%eax
  802111:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802115:	d3 e0                	shl    %cl,%eax
  802117:	89 e9                	mov    %ebp,%ecx
  802119:	d3 ea                	shr    %cl,%edx
  80211b:	09 d0                	or     %edx,%eax
  80211d:	89 e9                	mov    %ebp,%ecx
  80211f:	d3 eb                	shr    %cl,%ebx
  802121:	89 da                	mov    %ebx,%edx
  802123:	83 c4 1c             	add    $0x1c,%esp
  802126:	5b                   	pop    %ebx
  802127:	5e                   	pop    %esi
  802128:	5f                   	pop    %edi
  802129:	5d                   	pop    %ebp
  80212a:	c3                   	ret    
  80212b:	90                   	nop
  80212c:	89 fd                	mov    %edi,%ebp
  80212e:	85 ff                	test   %edi,%edi
  802130:	75 0b                	jne    80213d <__umoddi3+0xe9>
  802132:	b8 01 00 00 00       	mov    $0x1,%eax
  802137:	31 d2                	xor    %edx,%edx
  802139:	f7 f7                	div    %edi
  80213b:	89 c5                	mov    %eax,%ebp
  80213d:	89 f0                	mov    %esi,%eax
  80213f:	31 d2                	xor    %edx,%edx
  802141:	f7 f5                	div    %ebp
  802143:	89 c8                	mov    %ecx,%eax
  802145:	f7 f5                	div    %ebp
  802147:	89 d0                	mov    %edx,%eax
  802149:	e9 44 ff ff ff       	jmp    802092 <__umoddi3+0x3e>
  80214e:	66 90                	xchg   %ax,%ax
  802150:	89 c8                	mov    %ecx,%eax
  802152:	89 f2                	mov    %esi,%edx
  802154:	83 c4 1c             	add    $0x1c,%esp
  802157:	5b                   	pop    %ebx
  802158:	5e                   	pop    %esi
  802159:	5f                   	pop    %edi
  80215a:	5d                   	pop    %ebp
  80215b:	c3                   	ret    
  80215c:	3b 04 24             	cmp    (%esp),%eax
  80215f:	72 06                	jb     802167 <__umoddi3+0x113>
  802161:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802165:	77 0f                	ja     802176 <__umoddi3+0x122>
  802167:	89 f2                	mov    %esi,%edx
  802169:	29 f9                	sub    %edi,%ecx
  80216b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80216f:	89 14 24             	mov    %edx,(%esp)
  802172:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802176:	8b 44 24 04          	mov    0x4(%esp),%eax
  80217a:	8b 14 24             	mov    (%esp),%edx
  80217d:	83 c4 1c             	add    $0x1c,%esp
  802180:	5b                   	pop    %ebx
  802181:	5e                   	pop    %esi
  802182:	5f                   	pop    %edi
  802183:	5d                   	pop    %ebp
  802184:	c3                   	ret    
  802185:	8d 76 00             	lea    0x0(%esi),%esi
  802188:	2b 04 24             	sub    (%esp),%eax
  80218b:	19 fa                	sbb    %edi,%edx
  80218d:	89 d1                	mov    %edx,%ecx
  80218f:	89 c6                	mov    %eax,%esi
  802191:	e9 71 ff ff ff       	jmp    802107 <__umoddi3+0xb3>
  802196:	66 90                	xchg   %ax,%ax
  802198:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80219c:	72 ea                	jb     802188 <__umoddi3+0x134>
  80219e:	89 d9                	mov    %ebx,%ecx
  8021a0:	e9 62 ff ff ff       	jmp    802107 <__umoddi3+0xb3>
