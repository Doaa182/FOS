
obj/user/tst_buffer_1:     file format elf32-i386


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
  800031:	e8 89 05 00 00       	call   8005bf <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#define arrSize PAGE_SIZE*8 / 4
int src[arrSize];
int dst[arrSize];

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 58             	sub    $0x58,%esp



	//("STEP 0: checking Initial WS entries ...\n");
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=   0x200000)  	panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  80003e:	a1 20 30 80 00       	mov    0x803020,%eax
  800043:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800049:	8b 00                	mov    (%eax),%eax
  80004b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80004e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800051:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800056:	3d 00 00 20 00       	cmp    $0x200000,%eax
  80005b:	74 14                	je     800071 <_main+0x39>
  80005d:	83 ec 04             	sub    $0x4,%esp
  800060:	68 00 20 80 00       	push   $0x802000
  800065:	6a 16                	push   $0x16
  800067:	68 48 20 80 00       	push   $0x802048
  80006c:	e8 8a 06 00 00       	call   8006fb <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=   0x201000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  800071:	a1 20 30 80 00       	mov    0x803020,%eax
  800076:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80007c:	83 c0 18             	add    $0x18,%eax
  80007f:	8b 00                	mov    (%eax),%eax
  800081:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800084:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800087:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80008c:	3d 00 10 20 00       	cmp    $0x201000,%eax
  800091:	74 14                	je     8000a7 <_main+0x6f>
  800093:	83 ec 04             	sub    $0x4,%esp
  800096:	68 00 20 80 00       	push   $0x802000
  80009b:	6a 17                	push   $0x17
  80009d:	68 48 20 80 00       	push   $0x802048
  8000a2:	e8 54 06 00 00       	call   8006fb <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=   0x202000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  8000a7:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ac:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8000b2:	83 c0 30             	add    $0x30,%eax
  8000b5:	8b 00                	mov    (%eax),%eax
  8000b7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8000ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8000bd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000c2:	3d 00 20 20 00       	cmp    $0x202000,%eax
  8000c7:	74 14                	je     8000dd <_main+0xa5>
  8000c9:	83 ec 04             	sub    $0x4,%esp
  8000cc:	68 00 20 80 00       	push   $0x802000
  8000d1:	6a 18                	push   $0x18
  8000d3:	68 48 20 80 00       	push   $0x802048
  8000d8:	e8 1e 06 00 00       	call   8006fb <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=   0x203000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  8000dd:	a1 20 30 80 00       	mov    0x803020,%eax
  8000e2:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8000e8:	83 c0 48             	add    $0x48,%eax
  8000eb:	8b 00                	mov    (%eax),%eax
  8000ed:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8000f0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8000f3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000f8:	3d 00 30 20 00       	cmp    $0x203000,%eax
  8000fd:	74 14                	je     800113 <_main+0xdb>
  8000ff:	83 ec 04             	sub    $0x4,%esp
  800102:	68 00 20 80 00       	push   $0x802000
  800107:	6a 19                	push   $0x19
  800109:	68 48 20 80 00       	push   $0x802048
  80010e:	e8 e8 05 00 00       	call   8006fb <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=   0x204000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  800113:	a1 20 30 80 00       	mov    0x803020,%eax
  800118:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80011e:	83 c0 60             	add    $0x60,%eax
  800121:	8b 00                	mov    (%eax),%eax
  800123:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800126:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800129:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80012e:	3d 00 40 20 00       	cmp    $0x204000,%eax
  800133:	74 14                	je     800149 <_main+0x111>
  800135:	83 ec 04             	sub    $0x4,%esp
  800138:	68 00 20 80 00       	push   $0x802000
  80013d:	6a 1a                	push   $0x1a
  80013f:	68 48 20 80 00       	push   $0x802048
  800144:	e8 b2 05 00 00       	call   8006fb <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=   0x205000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  800149:	a1 20 30 80 00       	mov    0x803020,%eax
  80014e:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800154:	83 c0 78             	add    $0x78,%eax
  800157:	8b 00                	mov    (%eax),%eax
  800159:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80015c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80015f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800164:	3d 00 50 20 00       	cmp    $0x205000,%eax
  800169:	74 14                	je     80017f <_main+0x147>
  80016b:	83 ec 04             	sub    $0x4,%esp
  80016e:	68 00 20 80 00       	push   $0x802000
  800173:	6a 1b                	push   $0x1b
  800175:	68 48 20 80 00       	push   $0x802048
  80017a:	e8 7c 05 00 00       	call   8006fb <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=   0x800000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  80017f:	a1 20 30 80 00       	mov    0x803020,%eax
  800184:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80018a:	05 90 00 00 00       	add    $0x90,%eax
  80018f:	8b 00                	mov    (%eax),%eax
  800191:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800194:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800197:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80019c:	3d 00 00 80 00       	cmp    $0x800000,%eax
  8001a1:	74 14                	je     8001b7 <_main+0x17f>
  8001a3:	83 ec 04             	sub    $0x4,%esp
  8001a6:	68 00 20 80 00       	push   $0x802000
  8001ab:	6a 1c                	push   $0x1c
  8001ad:	68 48 20 80 00       	push   $0x802048
  8001b2:	e8 44 05 00 00       	call   8006fb <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x801000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  8001b7:	a1 20 30 80 00       	mov    0x803020,%eax
  8001bc:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8001c2:	05 a8 00 00 00       	add    $0xa8,%eax
  8001c7:	8b 00                	mov    (%eax),%eax
  8001c9:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8001cc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8001cf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001d4:	3d 00 10 80 00       	cmp    $0x801000,%eax
  8001d9:	74 14                	je     8001ef <_main+0x1b7>
  8001db:	83 ec 04             	sub    $0x4,%esp
  8001de:	68 00 20 80 00       	push   $0x802000
  8001e3:	6a 1d                	push   $0x1d
  8001e5:	68 48 20 80 00       	push   $0x802048
  8001ea:	e8 0c 05 00 00       	call   8006fb <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=   0x802000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  8001ef:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f4:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8001fa:	05 c0 00 00 00       	add    $0xc0,%eax
  8001ff:	8b 00                	mov    (%eax),%eax
  800201:	89 45 bc             	mov    %eax,-0x44(%ebp)
  800204:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800207:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80020c:	3d 00 20 80 00       	cmp    $0x802000,%eax
  800211:	74 14                	je     800227 <_main+0x1ef>
  800213:	83 ec 04             	sub    $0x4,%esp
  800216:	68 00 20 80 00       	push   $0x802000
  80021b:	6a 1e                	push   $0x1e
  80021d:	68 48 20 80 00       	push   $0x802048
  800222:	e8 d4 04 00 00       	call   8006fb <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0x803000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  800227:	a1 20 30 80 00       	mov    0x803020,%eax
  80022c:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800232:	05 d8 00 00 00       	add    $0xd8,%eax
  800237:	8b 00                	mov    (%eax),%eax
  800239:	89 45 b8             	mov    %eax,-0x48(%ebp)
  80023c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80023f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800244:	3d 00 30 80 00       	cmp    $0x803000,%eax
  800249:	74 14                	je     80025f <_main+0x227>
  80024b:	83 ec 04             	sub    $0x4,%esp
  80024e:	68 00 20 80 00       	push   $0x802000
  800253:	6a 1f                	push   $0x1f
  800255:	68 48 20 80 00       	push   $0x802048
  80025a:	e8 9c 04 00 00       	call   8006fb <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[10].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  80025f:	a1 20 30 80 00       	mov    0x803020,%eax
  800264:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80026a:	05 f0 00 00 00       	add    $0xf0,%eax
  80026f:	8b 00                	mov    (%eax),%eax
  800271:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  800274:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800277:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80027c:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  800281:	74 14                	je     800297 <_main+0x25f>
  800283:	83 ec 04             	sub    $0x4,%esp
  800286:	68 00 20 80 00       	push   $0x802000
  80028b:	6a 20                	push   $0x20
  80028d:	68 48 20 80 00       	push   $0x802048
  800292:	e8 64 04 00 00       	call   8006fb <_panic>
		if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review sizes of the two WS's..!!");
  800297:	a1 20 30 80 00       	mov    0x803020,%eax
  80029c:	8b 80 2c 05 00 00    	mov    0x52c(%eax),%eax
  8002a2:	85 c0                	test   %eax,%eax
  8002a4:	74 14                	je     8002ba <_main+0x282>
  8002a6:	83 ec 04             	sub    $0x4,%esp
  8002a9:	68 5c 20 80 00       	push   $0x80205c
  8002ae:	6a 21                	push   $0x21
  8002b0:	68 48 20 80 00       	push   $0x802048
  8002b5:	e8 41 04 00 00       	call   8006fb <_panic>
	}

	int initModBufCnt = sys_calculate_modified_frames();
  8002ba:	e8 7f 15 00 00       	call   80183e <sys_calculate_modified_frames>
  8002bf:	89 45 b0             	mov    %eax,-0x50(%ebp)
	int initFreeBufCnt = sys_calculate_notmod_frames();
  8002c2:	e8 90 15 00 00       	call   801857 <sys_calculate_notmod_frames>
  8002c7:	89 45 ac             	mov    %eax,-0x54(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  8002ca:	e8 f6 15 00 00       	call   8018c5 <sys_pf_calculate_allocated_pages>
  8002cf:	89 45 a8             	mov    %eax,-0x58(%ebp)

	//[1]Bring 7 pages and modify them (7 unmodified will be buffered)
	int i=0;
  8002d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int dstSum1 = 0;
  8002d9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	//cprintf("not modified frames= %d\n", sys_calculate_notmod_frames());
	int dummy = 0;
  8002e0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	for(i=(PAGE_SIZE/4);i<arrSize;i+=PAGE_SIZE/4)
  8002e7:	c7 45 f4 00 04 00 00 	movl   $0x400,-0xc(%ebp)
  8002ee:	eb 33                	jmp    800323 <_main+0x2eb>
	{
		dst[i] = i;
  8002f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8002f6:	89 14 85 20 31 80 00 	mov    %edx,0x803120(,%eax,4)
		dstSum1 += i;
  8002fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800300:	01 45 f0             	add    %eax,-0x10(%ebp)
		dummy += sys_calculate_notmod_frames() + myEnv->env_id; //Always use page #: 800000, 801000, 803000
  800303:	e8 4f 15 00 00       	call   801857 <sys_calculate_notmod_frames>
  800308:	89 c2                	mov    %eax,%edx
  80030a:	a1 20 30 80 00       	mov    0x803020,%eax
  80030f:	8b 40 4c             	mov    0x4c(%eax),%eax
  800312:	01 c2                	add    %eax,%edx
  800314:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800317:	01 d0                	add    %edx,%eax
  800319:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//[1]Bring 7 pages and modify them (7 unmodified will be buffered)
	int i=0;
	int dstSum1 = 0;
	//cprintf("not modified frames= %d\n", sys_calculate_notmod_frames());
	int dummy = 0;
	for(i=(PAGE_SIZE/4);i<arrSize;i+=PAGE_SIZE/4)
  80031c:	81 45 f4 00 04 00 00 	addl   $0x400,-0xc(%ebp)
  800323:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  80032a:	7e c4                	jle    8002f0 <_main+0x2b8>
		dstSum1 += i;
		dummy += sys_calculate_notmod_frames() + myEnv->env_id; //Always use page #: 800000, 801000, 803000
	}


	if (sys_calculate_notmod_frames()  - initFreeBufCnt != 7)  panic("Error in BUFFERING/RESTORING of free frames... WRONG number of buffered pages in FREE frame list");
  80032c:	e8 26 15 00 00       	call   801857 <sys_calculate_notmod_frames>
  800331:	89 c2                	mov    %eax,%edx
  800333:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800336:	29 c2                	sub    %eax,%edx
  800338:	89 d0                	mov    %edx,%eax
  80033a:	83 f8 07             	cmp    $0x7,%eax
  80033d:	74 14                	je     800353 <_main+0x31b>
  80033f:	83 ec 04             	sub    $0x4,%esp
  800342:	68 ac 20 80 00       	push   $0x8020ac
  800347:	6a 35                	push   $0x35
  800349:	68 48 20 80 00       	push   $0x802048
  80034e:	e8 a8 03 00 00       	call   8006fb <_panic>
	if (sys_calculate_modified_frames() - initModBufCnt  != 0)  panic("Error in BUFFERING/RESTORING of modified frames... WRONG number of buffered pages in MODIFIED frame list");
  800353:	e8 e6 14 00 00       	call   80183e <sys_calculate_modified_frames>
  800358:	89 c2                	mov    %eax,%edx
  80035a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80035d:	39 c2                	cmp    %eax,%edx
  80035f:	74 14                	je     800375 <_main+0x33d>
  800361:	83 ec 04             	sub    $0x4,%esp
  800364:	68 10 21 80 00       	push   $0x802110
  800369:	6a 36                	push   $0x36
  80036b:	68 48 20 80 00       	push   $0x802048
  800370:	e8 86 03 00 00       	call   8006fb <_panic>

	initFreeBufCnt = sys_calculate_notmod_frames();
  800375:	e8 dd 14 00 00       	call   801857 <sys_calculate_notmod_frames>
  80037a:	89 45 ac             	mov    %eax,-0x54(%ebp)
	initModBufCnt = sys_calculate_modified_frames();
  80037d:	e8 bc 14 00 00       	call   80183e <sys_calculate_modified_frames>
  800382:	89 45 b0             	mov    %eax,-0x50(%ebp)

	//[2]Bring 7 unmodified pages (7 modified will be buffered)
	int srcSum1 = 0 ;
  800385:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	i = PAGE_SIZE/4;
  80038c:	c7 45 f4 00 04 00 00 	movl   $0x400,-0xc(%ebp)
	for(;i<arrSize;i+=PAGE_SIZE/4)
  800393:	eb 2d                	jmp    8003c2 <_main+0x38a>
	{
		srcSum1 += src[i];
  800395:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800398:	8b 04 85 60 b1 80 00 	mov    0x80b160(,%eax,4),%eax
  80039f:	01 45 e8             	add    %eax,-0x18(%ebp)
		dummy += sys_calculate_notmod_frames() + myEnv->env_id; //Always use page #: 800000, 801000, 803000
  8003a2:	e8 b0 14 00 00       	call   801857 <sys_calculate_notmod_frames>
  8003a7:	89 c2                	mov    %eax,%edx
  8003a9:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ae:	8b 40 4c             	mov    0x4c(%eax),%eax
  8003b1:	01 c2                	add    %eax,%edx
  8003b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003b6:	01 d0                	add    %edx,%eax
  8003b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
	initModBufCnt = sys_calculate_modified_frames();

	//[2]Bring 7 unmodified pages (7 modified will be buffered)
	int srcSum1 = 0 ;
	i = PAGE_SIZE/4;
	for(;i<arrSize;i+=PAGE_SIZE/4)
  8003bb:	81 45 f4 00 04 00 00 	addl   $0x400,-0xc(%ebp)
  8003c2:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  8003c9:	7e ca                	jle    800395 <_main+0x35d>
		srcSum1 += src[i];
		dummy += sys_calculate_notmod_frames() + myEnv->env_id; //Always use page #: 800000, 801000, 803000
	}

	//cprintf("sys_calculate_notmod_frames()  - initFreeBufCnt = %d\n", sys_calculate_notmod_frames()  - initFreeBufCnt);
	if (sys_calculate_notmod_frames()  - initFreeBufCnt != 0)  panic("Error in BUFFERING/RESTORING of free frames... WRONG number of buffered pages in FREE frame list");
  8003cb:	e8 87 14 00 00       	call   801857 <sys_calculate_notmod_frames>
  8003d0:	89 c2                	mov    %eax,%edx
  8003d2:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8003d5:	39 c2                	cmp    %eax,%edx
  8003d7:	74 14                	je     8003ed <_main+0x3b5>
  8003d9:	83 ec 04             	sub    $0x4,%esp
  8003dc:	68 ac 20 80 00       	push   $0x8020ac
  8003e1:	6a 45                	push   $0x45
  8003e3:	68 48 20 80 00       	push   $0x802048
  8003e8:	e8 0e 03 00 00       	call   8006fb <_panic>
	if (sys_calculate_modified_frames() - initModBufCnt  != 7)  panic("Error in BUFFERING/RESTORING of modified frames... WRONG number of buffered pages in MODIFIED frame list");
  8003ed:	e8 4c 14 00 00       	call   80183e <sys_calculate_modified_frames>
  8003f2:	89 c2                	mov    %eax,%edx
  8003f4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8003f7:	29 c2                	sub    %eax,%edx
  8003f9:	89 d0                	mov    %edx,%eax
  8003fb:	83 f8 07             	cmp    $0x7,%eax
  8003fe:	74 14                	je     800414 <_main+0x3dc>
  800400:	83 ec 04             	sub    $0x4,%esp
  800403:	68 10 21 80 00       	push   $0x802110
  800408:	6a 46                	push   $0x46
  80040a:	68 48 20 80 00       	push   $0x802048
  80040f:	e8 e7 02 00 00       	call   8006fb <_panic>
	initFreeBufCnt = sys_calculate_notmod_frames();
  800414:	e8 3e 14 00 00       	call   801857 <sys_calculate_notmod_frames>
  800419:	89 45 ac             	mov    %eax,-0x54(%ebp)
	initModBufCnt = sys_calculate_modified_frames();
  80041c:	e8 1d 14 00 00       	call   80183e <sys_calculate_modified_frames>
  800421:	89 45 b0             	mov    %eax,-0x50(%ebp)

	//[3]Bring the 7 modified pages again and ensure their values are correct (7 unmodified will be buffered)
	i = 0;
  800424:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int dstSum2 = 0 ;
  80042b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for(i=PAGE_SIZE/4;i<arrSize;i+=PAGE_SIZE/4)
  800432:	c7 45 f4 00 04 00 00 	movl   $0x400,-0xc(%ebp)
  800439:	eb 2d                	jmp    800468 <_main+0x430>
	{
		dstSum2 += dst[i];
  80043b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80043e:	8b 04 85 20 31 80 00 	mov    0x803120(,%eax,4),%eax
  800445:	01 45 e4             	add    %eax,-0x1c(%ebp)
		dummy += sys_calculate_notmod_frames() + myEnv->env_id; //Always use page #: 800000, 801000, 803000
  800448:	e8 0a 14 00 00       	call   801857 <sys_calculate_notmod_frames>
  80044d:	89 c2                	mov    %eax,%edx
  80044f:	a1 20 30 80 00       	mov    0x803020,%eax
  800454:	8b 40 4c             	mov    0x4c(%eax),%eax
  800457:	01 c2                	add    %eax,%edx
  800459:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80045c:	01 d0                	add    %edx,%eax
  80045e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	initModBufCnt = sys_calculate_modified_frames();

	//[3]Bring the 7 modified pages again and ensure their values are correct (7 unmodified will be buffered)
	i = 0;
	int dstSum2 = 0 ;
	for(i=PAGE_SIZE/4;i<arrSize;i+=PAGE_SIZE/4)
  800461:	81 45 f4 00 04 00 00 	addl   $0x400,-0xc(%ebp)
  800468:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  80046f:	7e ca                	jle    80043b <_main+0x403>
	{
		dstSum2 += dst[i];
		dummy += sys_calculate_notmod_frames() + myEnv->env_id; //Always use page #: 800000, 801000, 803000
	}

	if (sys_calculate_notmod_frames()  - initFreeBufCnt != 7)  panic("Error in BUFFERING/RESTORING of free frames... WRONG number of buffered pages in FREE frame list");
  800471:	e8 e1 13 00 00       	call   801857 <sys_calculate_notmod_frames>
  800476:	89 c2                	mov    %eax,%edx
  800478:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80047b:	29 c2                	sub    %eax,%edx
  80047d:	89 d0                	mov    %edx,%eax
  80047f:	83 f8 07             	cmp    $0x7,%eax
  800482:	74 14                	je     800498 <_main+0x460>
  800484:	83 ec 04             	sub    $0x4,%esp
  800487:	68 ac 20 80 00       	push   $0x8020ac
  80048c:	6a 53                	push   $0x53
  80048e:	68 48 20 80 00       	push   $0x802048
  800493:	e8 63 02 00 00       	call   8006fb <_panic>
	if (sys_calculate_modified_frames() - initModBufCnt  != -7)  panic("Error in BUFFERING/RESTORING of modified frames... WRONG number of buffered pages in MODIFIED frame list");
  800498:	e8 a1 13 00 00       	call   80183e <sys_calculate_modified_frames>
  80049d:	89 c2                	mov    %eax,%edx
  80049f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8004a2:	29 c2                	sub    %eax,%edx
  8004a4:	89 d0                	mov    %edx,%eax
  8004a6:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8004a9:	74 14                	je     8004bf <_main+0x487>
  8004ab:	83 ec 04             	sub    $0x4,%esp
  8004ae:	68 10 21 80 00       	push   $0x802110
  8004b3:	6a 54                	push   $0x54
  8004b5:	68 48 20 80 00       	push   $0x802048
  8004ba:	e8 3c 02 00 00       	call   8006fb <_panic>

	initFreeBufCnt = sys_calculate_notmod_frames();
  8004bf:	e8 93 13 00 00       	call   801857 <sys_calculate_notmod_frames>
  8004c4:	89 45 ac             	mov    %eax,-0x54(%ebp)
	initModBufCnt = sys_calculate_modified_frames();
  8004c7:	e8 72 13 00 00       	call   80183e <sys_calculate_modified_frames>
  8004cc:	89 45 b0             	mov    %eax,-0x50(%ebp)

	//[4]Bring the 7 unmodified pages again and ensure their values are correct (7 modified will be buffered)
	i = 0;
  8004cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int srcSum2 = 0 ;
  8004d6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	for(i=PAGE_SIZE/4;i<arrSize;i+=PAGE_SIZE/4)
  8004dd:	c7 45 f4 00 04 00 00 	movl   $0x400,-0xc(%ebp)
  8004e4:	eb 2d                	jmp    800513 <_main+0x4db>
	{
		srcSum2 += src[i];
  8004e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004e9:	8b 04 85 60 b1 80 00 	mov    0x80b160(,%eax,4),%eax
  8004f0:	01 45 e0             	add    %eax,-0x20(%ebp)
		dummy += sys_calculate_notmod_frames() + myEnv->env_id; //Always use page #: 800000, 801000, 803000
  8004f3:	e8 5f 13 00 00       	call   801857 <sys_calculate_notmod_frames>
  8004f8:	89 c2                	mov    %eax,%edx
  8004fa:	a1 20 30 80 00       	mov    0x803020,%eax
  8004ff:	8b 40 4c             	mov    0x4c(%eax),%eax
  800502:	01 c2                	add    %eax,%edx
  800504:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800507:	01 d0                	add    %edx,%eax
  800509:	89 45 ec             	mov    %eax,-0x14(%ebp)
	initModBufCnt = sys_calculate_modified_frames();

	//[4]Bring the 7 unmodified pages again and ensure their values are correct (7 modified will be buffered)
	i = 0;
	int srcSum2 = 0 ;
	for(i=PAGE_SIZE/4;i<arrSize;i+=PAGE_SIZE/4)
  80050c:	81 45 f4 00 04 00 00 	addl   $0x400,-0xc(%ebp)
  800513:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  80051a:	7e ca                	jle    8004e6 <_main+0x4ae>
	{
		srcSum2 += src[i];
		dummy += sys_calculate_notmod_frames() + myEnv->env_id; //Always use page #: 800000, 801000, 803000
	}

	if (sys_calculate_notmod_frames()  - initFreeBufCnt != -7)  panic("Error in BUFFERING/RESTORING of free frames... WRONG number of buffered pages in FREE frame list");
  80051c:	e8 36 13 00 00       	call   801857 <sys_calculate_notmod_frames>
  800521:	89 c2                	mov    %eax,%edx
  800523:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800526:	29 c2                	sub    %eax,%edx
  800528:	89 d0                	mov    %edx,%eax
  80052a:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80052d:	74 14                	je     800543 <_main+0x50b>
  80052f:	83 ec 04             	sub    $0x4,%esp
  800532:	68 ac 20 80 00       	push   $0x8020ac
  800537:	6a 62                	push   $0x62
  800539:	68 48 20 80 00       	push   $0x802048
  80053e:	e8 b8 01 00 00       	call   8006fb <_panic>
	if (sys_calculate_modified_frames() - initModBufCnt  != 7)  panic("Error in BUFFERING/RESTORING of modified frames... WRONG number of buffered pages in MODIFIED frame list");
  800543:	e8 f6 12 00 00       	call   80183e <sys_calculate_modified_frames>
  800548:	89 c2                	mov    %eax,%edx
  80054a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80054d:	29 c2                	sub    %eax,%edx
  80054f:	89 d0                	mov    %edx,%eax
  800551:	83 f8 07             	cmp    $0x7,%eax
  800554:	74 14                	je     80056a <_main+0x532>
  800556:	83 ec 04             	sub    $0x4,%esp
  800559:	68 10 21 80 00       	push   $0x802110
  80055e:	6a 63                	push   $0x63
  800560:	68 48 20 80 00       	push   $0x802048
  800565:	e8 91 01 00 00       	call   8006fb <_panic>

	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Unexpected extra/less pages have been added to page file.. NOT Expected to add any new page to the page file");
  80056a:	e8 56 13 00 00       	call   8018c5 <sys_pf_calculate_allocated_pages>
  80056f:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  800572:	74 14                	je     800588 <_main+0x550>
  800574:	83 ec 04             	sub    $0x4,%esp
  800577:	68 7c 21 80 00       	push   $0x80217c
  80057c:	6a 65                	push   $0x65
  80057e:	68 48 20 80 00       	push   $0x802048
  800583:	e8 73 01 00 00       	call   8006fb <_panic>

	if (srcSum1 != srcSum2 || dstSum1 != dstSum2) 	panic("Error in buffering/restoring modified/not modified pages") ;
  800588:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80058b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80058e:	75 08                	jne    800598 <_main+0x560>
  800590:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800593:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800596:	74 14                	je     8005ac <_main+0x574>
  800598:	83 ec 04             	sub    $0x4,%esp
  80059b:	68 ec 21 80 00       	push   $0x8021ec
  8005a0:	6a 67                	push   $0x67
  8005a2:	68 48 20 80 00       	push   $0x802048
  8005a7:	e8 4f 01 00 00       	call   8006fb <_panic>

	cprintf("Congratulations!! test buffered pages inside REPLACEMENT is completed successfully.\n");
  8005ac:	83 ec 0c             	sub    $0xc,%esp
  8005af:	68 28 22 80 00       	push   $0x802228
  8005b4:	e8 f6 03 00 00       	call   8009af <cprintf>
  8005b9:	83 c4 10             	add    $0x10,%esp
	return;
  8005bc:	90                   	nop

}
  8005bd:	c9                   	leave  
  8005be:	c3                   	ret    

008005bf <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8005bf:	55                   	push   %ebp
  8005c0:	89 e5                	mov    %esp,%ebp
  8005c2:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8005c5:	e8 3b 15 00 00       	call   801b05 <sys_getenvindex>
  8005ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8005cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005d0:	89 d0                	mov    %edx,%eax
  8005d2:	c1 e0 03             	shl    $0x3,%eax
  8005d5:	01 d0                	add    %edx,%eax
  8005d7:	01 c0                	add    %eax,%eax
  8005d9:	01 d0                	add    %edx,%eax
  8005db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005e2:	01 d0                	add    %edx,%eax
  8005e4:	c1 e0 04             	shl    $0x4,%eax
  8005e7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005ec:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8005f1:	a1 20 30 80 00       	mov    0x803020,%eax
  8005f6:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8005fc:	84 c0                	test   %al,%al
  8005fe:	74 0f                	je     80060f <libmain+0x50>
		binaryname = myEnv->prog_name;
  800600:	a1 20 30 80 00       	mov    0x803020,%eax
  800605:	05 5c 05 00 00       	add    $0x55c,%eax
  80060a:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80060f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800613:	7e 0a                	jle    80061f <libmain+0x60>
		binaryname = argv[0];
  800615:	8b 45 0c             	mov    0xc(%ebp),%eax
  800618:	8b 00                	mov    (%eax),%eax
  80061a:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80061f:	83 ec 08             	sub    $0x8,%esp
  800622:	ff 75 0c             	pushl  0xc(%ebp)
  800625:	ff 75 08             	pushl  0x8(%ebp)
  800628:	e8 0b fa ff ff       	call   800038 <_main>
  80062d:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800630:	e8 dd 12 00 00       	call   801912 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800635:	83 ec 0c             	sub    $0xc,%esp
  800638:	68 98 22 80 00       	push   $0x802298
  80063d:	e8 6d 03 00 00       	call   8009af <cprintf>
  800642:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800645:	a1 20 30 80 00       	mov    0x803020,%eax
  80064a:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800650:	a1 20 30 80 00       	mov    0x803020,%eax
  800655:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80065b:	83 ec 04             	sub    $0x4,%esp
  80065e:	52                   	push   %edx
  80065f:	50                   	push   %eax
  800660:	68 c0 22 80 00       	push   $0x8022c0
  800665:	e8 45 03 00 00       	call   8009af <cprintf>
  80066a:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80066d:	a1 20 30 80 00       	mov    0x803020,%eax
  800672:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800678:	a1 20 30 80 00       	mov    0x803020,%eax
  80067d:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800683:	a1 20 30 80 00       	mov    0x803020,%eax
  800688:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80068e:	51                   	push   %ecx
  80068f:	52                   	push   %edx
  800690:	50                   	push   %eax
  800691:	68 e8 22 80 00       	push   $0x8022e8
  800696:	e8 14 03 00 00       	call   8009af <cprintf>
  80069b:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80069e:	a1 20 30 80 00       	mov    0x803020,%eax
  8006a3:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8006a9:	83 ec 08             	sub    $0x8,%esp
  8006ac:	50                   	push   %eax
  8006ad:	68 40 23 80 00       	push   $0x802340
  8006b2:	e8 f8 02 00 00       	call   8009af <cprintf>
  8006b7:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006ba:	83 ec 0c             	sub    $0xc,%esp
  8006bd:	68 98 22 80 00       	push   $0x802298
  8006c2:	e8 e8 02 00 00       	call   8009af <cprintf>
  8006c7:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006ca:	e8 5d 12 00 00       	call   80192c <sys_enable_interrupt>

	// exit gracefully
	exit();
  8006cf:	e8 19 00 00 00       	call   8006ed <exit>
}
  8006d4:	90                   	nop
  8006d5:	c9                   	leave  
  8006d6:	c3                   	ret    

008006d7 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8006d7:	55                   	push   %ebp
  8006d8:	89 e5                	mov    %esp,%ebp
  8006da:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8006dd:	83 ec 0c             	sub    $0xc,%esp
  8006e0:	6a 00                	push   $0x0
  8006e2:	e8 ea 13 00 00       	call   801ad1 <sys_destroy_env>
  8006e7:	83 c4 10             	add    $0x10,%esp
}
  8006ea:	90                   	nop
  8006eb:	c9                   	leave  
  8006ec:	c3                   	ret    

008006ed <exit>:

void
exit(void)
{
  8006ed:	55                   	push   %ebp
  8006ee:	89 e5                	mov    %esp,%ebp
  8006f0:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8006f3:	e8 3f 14 00 00       	call   801b37 <sys_exit_env>
}
  8006f8:	90                   	nop
  8006f9:	c9                   	leave  
  8006fa:	c3                   	ret    

008006fb <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8006fb:	55                   	push   %ebp
  8006fc:	89 e5                	mov    %esp,%ebp
  8006fe:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800701:	8d 45 10             	lea    0x10(%ebp),%eax
  800704:	83 c0 04             	add    $0x4,%eax
  800707:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80070a:	a1 74 31 81 00       	mov    0x813174,%eax
  80070f:	85 c0                	test   %eax,%eax
  800711:	74 16                	je     800729 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800713:	a1 74 31 81 00       	mov    0x813174,%eax
  800718:	83 ec 08             	sub    $0x8,%esp
  80071b:	50                   	push   %eax
  80071c:	68 54 23 80 00       	push   $0x802354
  800721:	e8 89 02 00 00       	call   8009af <cprintf>
  800726:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800729:	a1 00 30 80 00       	mov    0x803000,%eax
  80072e:	ff 75 0c             	pushl  0xc(%ebp)
  800731:	ff 75 08             	pushl  0x8(%ebp)
  800734:	50                   	push   %eax
  800735:	68 59 23 80 00       	push   $0x802359
  80073a:	e8 70 02 00 00       	call   8009af <cprintf>
  80073f:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800742:	8b 45 10             	mov    0x10(%ebp),%eax
  800745:	83 ec 08             	sub    $0x8,%esp
  800748:	ff 75 f4             	pushl  -0xc(%ebp)
  80074b:	50                   	push   %eax
  80074c:	e8 f3 01 00 00       	call   800944 <vcprintf>
  800751:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800754:	83 ec 08             	sub    $0x8,%esp
  800757:	6a 00                	push   $0x0
  800759:	68 75 23 80 00       	push   $0x802375
  80075e:	e8 e1 01 00 00       	call   800944 <vcprintf>
  800763:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800766:	e8 82 ff ff ff       	call   8006ed <exit>

	// should not return here
	while (1) ;
  80076b:	eb fe                	jmp    80076b <_panic+0x70>

0080076d <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80076d:	55                   	push   %ebp
  80076e:	89 e5                	mov    %esp,%ebp
  800770:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800773:	a1 20 30 80 00       	mov    0x803020,%eax
  800778:	8b 50 74             	mov    0x74(%eax),%edx
  80077b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80077e:	39 c2                	cmp    %eax,%edx
  800780:	74 14                	je     800796 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800782:	83 ec 04             	sub    $0x4,%esp
  800785:	68 78 23 80 00       	push   $0x802378
  80078a:	6a 26                	push   $0x26
  80078c:	68 c4 23 80 00       	push   $0x8023c4
  800791:	e8 65 ff ff ff       	call   8006fb <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800796:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80079d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007a4:	e9 c2 00 00 00       	jmp    80086b <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8007a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b6:	01 d0                	add    %edx,%eax
  8007b8:	8b 00                	mov    (%eax),%eax
  8007ba:	85 c0                	test   %eax,%eax
  8007bc:	75 08                	jne    8007c6 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8007be:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8007c1:	e9 a2 00 00 00       	jmp    800868 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8007c6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007cd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8007d4:	eb 69                	jmp    80083f <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8007d6:	a1 20 30 80 00       	mov    0x803020,%eax
  8007db:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007e1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007e4:	89 d0                	mov    %edx,%eax
  8007e6:	01 c0                	add    %eax,%eax
  8007e8:	01 d0                	add    %edx,%eax
  8007ea:	c1 e0 03             	shl    $0x3,%eax
  8007ed:	01 c8                	add    %ecx,%eax
  8007ef:	8a 40 04             	mov    0x4(%eax),%al
  8007f2:	84 c0                	test   %al,%al
  8007f4:	75 46                	jne    80083c <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007f6:	a1 20 30 80 00       	mov    0x803020,%eax
  8007fb:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800801:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800804:	89 d0                	mov    %edx,%eax
  800806:	01 c0                	add    %eax,%eax
  800808:	01 d0                	add    %edx,%eax
  80080a:	c1 e0 03             	shl    $0x3,%eax
  80080d:	01 c8                	add    %ecx,%eax
  80080f:	8b 00                	mov    (%eax),%eax
  800811:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800814:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800817:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80081c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80081e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800821:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800828:	8b 45 08             	mov    0x8(%ebp),%eax
  80082b:	01 c8                	add    %ecx,%eax
  80082d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80082f:	39 c2                	cmp    %eax,%edx
  800831:	75 09                	jne    80083c <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800833:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80083a:	eb 12                	jmp    80084e <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80083c:	ff 45 e8             	incl   -0x18(%ebp)
  80083f:	a1 20 30 80 00       	mov    0x803020,%eax
  800844:	8b 50 74             	mov    0x74(%eax),%edx
  800847:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80084a:	39 c2                	cmp    %eax,%edx
  80084c:	77 88                	ja     8007d6 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80084e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800852:	75 14                	jne    800868 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800854:	83 ec 04             	sub    $0x4,%esp
  800857:	68 d0 23 80 00       	push   $0x8023d0
  80085c:	6a 3a                	push   $0x3a
  80085e:	68 c4 23 80 00       	push   $0x8023c4
  800863:	e8 93 fe ff ff       	call   8006fb <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800868:	ff 45 f0             	incl   -0x10(%ebp)
  80086b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80086e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800871:	0f 8c 32 ff ff ff    	jl     8007a9 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800877:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80087e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800885:	eb 26                	jmp    8008ad <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800887:	a1 20 30 80 00       	mov    0x803020,%eax
  80088c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800892:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800895:	89 d0                	mov    %edx,%eax
  800897:	01 c0                	add    %eax,%eax
  800899:	01 d0                	add    %edx,%eax
  80089b:	c1 e0 03             	shl    $0x3,%eax
  80089e:	01 c8                	add    %ecx,%eax
  8008a0:	8a 40 04             	mov    0x4(%eax),%al
  8008a3:	3c 01                	cmp    $0x1,%al
  8008a5:	75 03                	jne    8008aa <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8008a7:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008aa:	ff 45 e0             	incl   -0x20(%ebp)
  8008ad:	a1 20 30 80 00       	mov    0x803020,%eax
  8008b2:	8b 50 74             	mov    0x74(%eax),%edx
  8008b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008b8:	39 c2                	cmp    %eax,%edx
  8008ba:	77 cb                	ja     800887 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8008bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008bf:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8008c2:	74 14                	je     8008d8 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8008c4:	83 ec 04             	sub    $0x4,%esp
  8008c7:	68 24 24 80 00       	push   $0x802424
  8008cc:	6a 44                	push   $0x44
  8008ce:	68 c4 23 80 00       	push   $0x8023c4
  8008d3:	e8 23 fe ff ff       	call   8006fb <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8008d8:	90                   	nop
  8008d9:	c9                   	leave  
  8008da:	c3                   	ret    

008008db <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8008db:	55                   	push   %ebp
  8008dc:	89 e5                	mov    %esp,%ebp
  8008de:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8008e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e4:	8b 00                	mov    (%eax),%eax
  8008e6:	8d 48 01             	lea    0x1(%eax),%ecx
  8008e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ec:	89 0a                	mov    %ecx,(%edx)
  8008ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8008f1:	88 d1                	mov    %dl,%cl
  8008f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008f6:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8008fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008fd:	8b 00                	mov    (%eax),%eax
  8008ff:	3d ff 00 00 00       	cmp    $0xff,%eax
  800904:	75 2c                	jne    800932 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800906:	a0 24 30 80 00       	mov    0x803024,%al
  80090b:	0f b6 c0             	movzbl %al,%eax
  80090e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800911:	8b 12                	mov    (%edx),%edx
  800913:	89 d1                	mov    %edx,%ecx
  800915:	8b 55 0c             	mov    0xc(%ebp),%edx
  800918:	83 c2 08             	add    $0x8,%edx
  80091b:	83 ec 04             	sub    $0x4,%esp
  80091e:	50                   	push   %eax
  80091f:	51                   	push   %ecx
  800920:	52                   	push   %edx
  800921:	e8 3e 0e 00 00       	call   801764 <sys_cputs>
  800926:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800929:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800932:	8b 45 0c             	mov    0xc(%ebp),%eax
  800935:	8b 40 04             	mov    0x4(%eax),%eax
  800938:	8d 50 01             	lea    0x1(%eax),%edx
  80093b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093e:	89 50 04             	mov    %edx,0x4(%eax)
}
  800941:	90                   	nop
  800942:	c9                   	leave  
  800943:	c3                   	ret    

00800944 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800944:	55                   	push   %ebp
  800945:	89 e5                	mov    %esp,%ebp
  800947:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80094d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800954:	00 00 00 
	b.cnt = 0;
  800957:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80095e:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800961:	ff 75 0c             	pushl  0xc(%ebp)
  800964:	ff 75 08             	pushl  0x8(%ebp)
  800967:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80096d:	50                   	push   %eax
  80096e:	68 db 08 80 00       	push   $0x8008db
  800973:	e8 11 02 00 00       	call   800b89 <vprintfmt>
  800978:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80097b:	a0 24 30 80 00       	mov    0x803024,%al
  800980:	0f b6 c0             	movzbl %al,%eax
  800983:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800989:	83 ec 04             	sub    $0x4,%esp
  80098c:	50                   	push   %eax
  80098d:	52                   	push   %edx
  80098e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800994:	83 c0 08             	add    $0x8,%eax
  800997:	50                   	push   %eax
  800998:	e8 c7 0d 00 00       	call   801764 <sys_cputs>
  80099d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009a0:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8009a7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8009ad:	c9                   	leave  
  8009ae:	c3                   	ret    

008009af <cprintf>:

int cprintf(const char *fmt, ...) {
  8009af:	55                   	push   %ebp
  8009b0:	89 e5                	mov    %esp,%ebp
  8009b2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8009b5:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8009bc:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c5:	83 ec 08             	sub    $0x8,%esp
  8009c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8009cb:	50                   	push   %eax
  8009cc:	e8 73 ff ff ff       	call   800944 <vcprintf>
  8009d1:	83 c4 10             	add    $0x10,%esp
  8009d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8009d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009da:	c9                   	leave  
  8009db:	c3                   	ret    

008009dc <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8009dc:	55                   	push   %ebp
  8009dd:	89 e5                	mov    %esp,%ebp
  8009df:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8009e2:	e8 2b 0f 00 00       	call   801912 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8009e7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f0:	83 ec 08             	sub    $0x8,%esp
  8009f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8009f6:	50                   	push   %eax
  8009f7:	e8 48 ff ff ff       	call   800944 <vcprintf>
  8009fc:	83 c4 10             	add    $0x10,%esp
  8009ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a02:	e8 25 0f 00 00       	call   80192c <sys_enable_interrupt>
	return cnt;
  800a07:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a0a:	c9                   	leave  
  800a0b:	c3                   	ret    

00800a0c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a0c:	55                   	push   %ebp
  800a0d:	89 e5                	mov    %esp,%ebp
  800a0f:	53                   	push   %ebx
  800a10:	83 ec 14             	sub    $0x14,%esp
  800a13:	8b 45 10             	mov    0x10(%ebp),%eax
  800a16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a19:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a1f:	8b 45 18             	mov    0x18(%ebp),%eax
  800a22:	ba 00 00 00 00       	mov    $0x0,%edx
  800a27:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a2a:	77 55                	ja     800a81 <printnum+0x75>
  800a2c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a2f:	72 05                	jb     800a36 <printnum+0x2a>
  800a31:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a34:	77 4b                	ja     800a81 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a36:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a39:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a3c:	8b 45 18             	mov    0x18(%ebp),%eax
  800a3f:	ba 00 00 00 00       	mov    $0x0,%edx
  800a44:	52                   	push   %edx
  800a45:	50                   	push   %eax
  800a46:	ff 75 f4             	pushl  -0xc(%ebp)
  800a49:	ff 75 f0             	pushl  -0x10(%ebp)
  800a4c:	e8 47 13 00 00       	call   801d98 <__udivdi3>
  800a51:	83 c4 10             	add    $0x10,%esp
  800a54:	83 ec 04             	sub    $0x4,%esp
  800a57:	ff 75 20             	pushl  0x20(%ebp)
  800a5a:	53                   	push   %ebx
  800a5b:	ff 75 18             	pushl  0x18(%ebp)
  800a5e:	52                   	push   %edx
  800a5f:	50                   	push   %eax
  800a60:	ff 75 0c             	pushl  0xc(%ebp)
  800a63:	ff 75 08             	pushl  0x8(%ebp)
  800a66:	e8 a1 ff ff ff       	call   800a0c <printnum>
  800a6b:	83 c4 20             	add    $0x20,%esp
  800a6e:	eb 1a                	jmp    800a8a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a70:	83 ec 08             	sub    $0x8,%esp
  800a73:	ff 75 0c             	pushl  0xc(%ebp)
  800a76:	ff 75 20             	pushl  0x20(%ebp)
  800a79:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7c:	ff d0                	call   *%eax
  800a7e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a81:	ff 4d 1c             	decl   0x1c(%ebp)
  800a84:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a88:	7f e6                	jg     800a70 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a8a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a8d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a98:	53                   	push   %ebx
  800a99:	51                   	push   %ecx
  800a9a:	52                   	push   %edx
  800a9b:	50                   	push   %eax
  800a9c:	e8 07 14 00 00       	call   801ea8 <__umoddi3>
  800aa1:	83 c4 10             	add    $0x10,%esp
  800aa4:	05 94 26 80 00       	add    $0x802694,%eax
  800aa9:	8a 00                	mov    (%eax),%al
  800aab:	0f be c0             	movsbl %al,%eax
  800aae:	83 ec 08             	sub    $0x8,%esp
  800ab1:	ff 75 0c             	pushl  0xc(%ebp)
  800ab4:	50                   	push   %eax
  800ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab8:	ff d0                	call   *%eax
  800aba:	83 c4 10             	add    $0x10,%esp
}
  800abd:	90                   	nop
  800abe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ac1:	c9                   	leave  
  800ac2:	c3                   	ret    

00800ac3 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800ac3:	55                   	push   %ebp
  800ac4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ac6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800aca:	7e 1c                	jle    800ae8 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800acc:	8b 45 08             	mov    0x8(%ebp),%eax
  800acf:	8b 00                	mov    (%eax),%eax
  800ad1:	8d 50 08             	lea    0x8(%eax),%edx
  800ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad7:	89 10                	mov    %edx,(%eax)
  800ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  800adc:	8b 00                	mov    (%eax),%eax
  800ade:	83 e8 08             	sub    $0x8,%eax
  800ae1:	8b 50 04             	mov    0x4(%eax),%edx
  800ae4:	8b 00                	mov    (%eax),%eax
  800ae6:	eb 40                	jmp    800b28 <getuint+0x65>
	else if (lflag)
  800ae8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800aec:	74 1e                	je     800b0c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800aee:	8b 45 08             	mov    0x8(%ebp),%eax
  800af1:	8b 00                	mov    (%eax),%eax
  800af3:	8d 50 04             	lea    0x4(%eax),%edx
  800af6:	8b 45 08             	mov    0x8(%ebp),%eax
  800af9:	89 10                	mov    %edx,(%eax)
  800afb:	8b 45 08             	mov    0x8(%ebp),%eax
  800afe:	8b 00                	mov    (%eax),%eax
  800b00:	83 e8 04             	sub    $0x4,%eax
  800b03:	8b 00                	mov    (%eax),%eax
  800b05:	ba 00 00 00 00       	mov    $0x0,%edx
  800b0a:	eb 1c                	jmp    800b28 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0f:	8b 00                	mov    (%eax),%eax
  800b11:	8d 50 04             	lea    0x4(%eax),%edx
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	89 10                	mov    %edx,(%eax)
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	8b 00                	mov    (%eax),%eax
  800b1e:	83 e8 04             	sub    $0x4,%eax
  800b21:	8b 00                	mov    (%eax),%eax
  800b23:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b28:	5d                   	pop    %ebp
  800b29:	c3                   	ret    

00800b2a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b2a:	55                   	push   %ebp
  800b2b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b2d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b31:	7e 1c                	jle    800b4f <getint+0x25>
		return va_arg(*ap, long long);
  800b33:	8b 45 08             	mov    0x8(%ebp),%eax
  800b36:	8b 00                	mov    (%eax),%eax
  800b38:	8d 50 08             	lea    0x8(%eax),%edx
  800b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3e:	89 10                	mov    %edx,(%eax)
  800b40:	8b 45 08             	mov    0x8(%ebp),%eax
  800b43:	8b 00                	mov    (%eax),%eax
  800b45:	83 e8 08             	sub    $0x8,%eax
  800b48:	8b 50 04             	mov    0x4(%eax),%edx
  800b4b:	8b 00                	mov    (%eax),%eax
  800b4d:	eb 38                	jmp    800b87 <getint+0x5d>
	else if (lflag)
  800b4f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b53:	74 1a                	je     800b6f <getint+0x45>
		return va_arg(*ap, long);
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	8b 00                	mov    (%eax),%eax
  800b5a:	8d 50 04             	lea    0x4(%eax),%edx
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	89 10                	mov    %edx,(%eax)
  800b62:	8b 45 08             	mov    0x8(%ebp),%eax
  800b65:	8b 00                	mov    (%eax),%eax
  800b67:	83 e8 04             	sub    $0x4,%eax
  800b6a:	8b 00                	mov    (%eax),%eax
  800b6c:	99                   	cltd   
  800b6d:	eb 18                	jmp    800b87 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b72:	8b 00                	mov    (%eax),%eax
  800b74:	8d 50 04             	lea    0x4(%eax),%edx
  800b77:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7a:	89 10                	mov    %edx,(%eax)
  800b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7f:	8b 00                	mov    (%eax),%eax
  800b81:	83 e8 04             	sub    $0x4,%eax
  800b84:	8b 00                	mov    (%eax),%eax
  800b86:	99                   	cltd   
}
  800b87:	5d                   	pop    %ebp
  800b88:	c3                   	ret    

00800b89 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b89:	55                   	push   %ebp
  800b8a:	89 e5                	mov    %esp,%ebp
  800b8c:	56                   	push   %esi
  800b8d:	53                   	push   %ebx
  800b8e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b91:	eb 17                	jmp    800baa <vprintfmt+0x21>
			if (ch == '\0')
  800b93:	85 db                	test   %ebx,%ebx
  800b95:	0f 84 af 03 00 00    	je     800f4a <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800b9b:	83 ec 08             	sub    $0x8,%esp
  800b9e:	ff 75 0c             	pushl  0xc(%ebp)
  800ba1:	53                   	push   %ebx
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	ff d0                	call   *%eax
  800ba7:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800baa:	8b 45 10             	mov    0x10(%ebp),%eax
  800bad:	8d 50 01             	lea    0x1(%eax),%edx
  800bb0:	89 55 10             	mov    %edx,0x10(%ebp)
  800bb3:	8a 00                	mov    (%eax),%al
  800bb5:	0f b6 d8             	movzbl %al,%ebx
  800bb8:	83 fb 25             	cmp    $0x25,%ebx
  800bbb:	75 d6                	jne    800b93 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800bbd:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800bc1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800bc8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800bcf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800bd6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800bdd:	8b 45 10             	mov    0x10(%ebp),%eax
  800be0:	8d 50 01             	lea    0x1(%eax),%edx
  800be3:	89 55 10             	mov    %edx,0x10(%ebp)
  800be6:	8a 00                	mov    (%eax),%al
  800be8:	0f b6 d8             	movzbl %al,%ebx
  800beb:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800bee:	83 f8 55             	cmp    $0x55,%eax
  800bf1:	0f 87 2b 03 00 00    	ja     800f22 <vprintfmt+0x399>
  800bf7:	8b 04 85 b8 26 80 00 	mov    0x8026b8(,%eax,4),%eax
  800bfe:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c00:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c04:	eb d7                	jmp    800bdd <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c06:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c0a:	eb d1                	jmp    800bdd <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c0c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c13:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c16:	89 d0                	mov    %edx,%eax
  800c18:	c1 e0 02             	shl    $0x2,%eax
  800c1b:	01 d0                	add    %edx,%eax
  800c1d:	01 c0                	add    %eax,%eax
  800c1f:	01 d8                	add    %ebx,%eax
  800c21:	83 e8 30             	sub    $0x30,%eax
  800c24:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c27:	8b 45 10             	mov    0x10(%ebp),%eax
  800c2a:	8a 00                	mov    (%eax),%al
  800c2c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c2f:	83 fb 2f             	cmp    $0x2f,%ebx
  800c32:	7e 3e                	jle    800c72 <vprintfmt+0xe9>
  800c34:	83 fb 39             	cmp    $0x39,%ebx
  800c37:	7f 39                	jg     800c72 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c39:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c3c:	eb d5                	jmp    800c13 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800c41:	83 c0 04             	add    $0x4,%eax
  800c44:	89 45 14             	mov    %eax,0x14(%ebp)
  800c47:	8b 45 14             	mov    0x14(%ebp),%eax
  800c4a:	83 e8 04             	sub    $0x4,%eax
  800c4d:	8b 00                	mov    (%eax),%eax
  800c4f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c52:	eb 1f                	jmp    800c73 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c54:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c58:	79 83                	jns    800bdd <vprintfmt+0x54>
				width = 0;
  800c5a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c61:	e9 77 ff ff ff       	jmp    800bdd <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c66:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c6d:	e9 6b ff ff ff       	jmp    800bdd <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c72:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c73:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c77:	0f 89 60 ff ff ff    	jns    800bdd <vprintfmt+0x54>
				width = precision, precision = -1;
  800c7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c80:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c83:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c8a:	e9 4e ff ff ff       	jmp    800bdd <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c8f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c92:	e9 46 ff ff ff       	jmp    800bdd <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c97:	8b 45 14             	mov    0x14(%ebp),%eax
  800c9a:	83 c0 04             	add    $0x4,%eax
  800c9d:	89 45 14             	mov    %eax,0x14(%ebp)
  800ca0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca3:	83 e8 04             	sub    $0x4,%eax
  800ca6:	8b 00                	mov    (%eax),%eax
  800ca8:	83 ec 08             	sub    $0x8,%esp
  800cab:	ff 75 0c             	pushl  0xc(%ebp)
  800cae:	50                   	push   %eax
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb2:	ff d0                	call   *%eax
  800cb4:	83 c4 10             	add    $0x10,%esp
			break;
  800cb7:	e9 89 02 00 00       	jmp    800f45 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800cbc:	8b 45 14             	mov    0x14(%ebp),%eax
  800cbf:	83 c0 04             	add    $0x4,%eax
  800cc2:	89 45 14             	mov    %eax,0x14(%ebp)
  800cc5:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc8:	83 e8 04             	sub    $0x4,%eax
  800ccb:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ccd:	85 db                	test   %ebx,%ebx
  800ccf:	79 02                	jns    800cd3 <vprintfmt+0x14a>
				err = -err;
  800cd1:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800cd3:	83 fb 64             	cmp    $0x64,%ebx
  800cd6:	7f 0b                	jg     800ce3 <vprintfmt+0x15a>
  800cd8:	8b 34 9d 00 25 80 00 	mov    0x802500(,%ebx,4),%esi
  800cdf:	85 f6                	test   %esi,%esi
  800ce1:	75 19                	jne    800cfc <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ce3:	53                   	push   %ebx
  800ce4:	68 a5 26 80 00       	push   $0x8026a5
  800ce9:	ff 75 0c             	pushl  0xc(%ebp)
  800cec:	ff 75 08             	pushl  0x8(%ebp)
  800cef:	e8 5e 02 00 00       	call   800f52 <printfmt>
  800cf4:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800cf7:	e9 49 02 00 00       	jmp    800f45 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800cfc:	56                   	push   %esi
  800cfd:	68 ae 26 80 00       	push   $0x8026ae
  800d02:	ff 75 0c             	pushl  0xc(%ebp)
  800d05:	ff 75 08             	pushl  0x8(%ebp)
  800d08:	e8 45 02 00 00       	call   800f52 <printfmt>
  800d0d:	83 c4 10             	add    $0x10,%esp
			break;
  800d10:	e9 30 02 00 00       	jmp    800f45 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d15:	8b 45 14             	mov    0x14(%ebp),%eax
  800d18:	83 c0 04             	add    $0x4,%eax
  800d1b:	89 45 14             	mov    %eax,0x14(%ebp)
  800d1e:	8b 45 14             	mov    0x14(%ebp),%eax
  800d21:	83 e8 04             	sub    $0x4,%eax
  800d24:	8b 30                	mov    (%eax),%esi
  800d26:	85 f6                	test   %esi,%esi
  800d28:	75 05                	jne    800d2f <vprintfmt+0x1a6>
				p = "(null)";
  800d2a:	be b1 26 80 00       	mov    $0x8026b1,%esi
			if (width > 0 && padc != '-')
  800d2f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d33:	7e 6d                	jle    800da2 <vprintfmt+0x219>
  800d35:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d39:	74 67                	je     800da2 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d3b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d3e:	83 ec 08             	sub    $0x8,%esp
  800d41:	50                   	push   %eax
  800d42:	56                   	push   %esi
  800d43:	e8 0c 03 00 00       	call   801054 <strnlen>
  800d48:	83 c4 10             	add    $0x10,%esp
  800d4b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d4e:	eb 16                	jmp    800d66 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d50:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d54:	83 ec 08             	sub    $0x8,%esp
  800d57:	ff 75 0c             	pushl  0xc(%ebp)
  800d5a:	50                   	push   %eax
  800d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5e:	ff d0                	call   *%eax
  800d60:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d63:	ff 4d e4             	decl   -0x1c(%ebp)
  800d66:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d6a:	7f e4                	jg     800d50 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d6c:	eb 34                	jmp    800da2 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d6e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d72:	74 1c                	je     800d90 <vprintfmt+0x207>
  800d74:	83 fb 1f             	cmp    $0x1f,%ebx
  800d77:	7e 05                	jle    800d7e <vprintfmt+0x1f5>
  800d79:	83 fb 7e             	cmp    $0x7e,%ebx
  800d7c:	7e 12                	jle    800d90 <vprintfmt+0x207>
					putch('?', putdat);
  800d7e:	83 ec 08             	sub    $0x8,%esp
  800d81:	ff 75 0c             	pushl  0xc(%ebp)
  800d84:	6a 3f                	push   $0x3f
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	ff d0                	call   *%eax
  800d8b:	83 c4 10             	add    $0x10,%esp
  800d8e:	eb 0f                	jmp    800d9f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d90:	83 ec 08             	sub    $0x8,%esp
  800d93:	ff 75 0c             	pushl  0xc(%ebp)
  800d96:	53                   	push   %ebx
  800d97:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9a:	ff d0                	call   *%eax
  800d9c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d9f:	ff 4d e4             	decl   -0x1c(%ebp)
  800da2:	89 f0                	mov    %esi,%eax
  800da4:	8d 70 01             	lea    0x1(%eax),%esi
  800da7:	8a 00                	mov    (%eax),%al
  800da9:	0f be d8             	movsbl %al,%ebx
  800dac:	85 db                	test   %ebx,%ebx
  800dae:	74 24                	je     800dd4 <vprintfmt+0x24b>
  800db0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800db4:	78 b8                	js     800d6e <vprintfmt+0x1e5>
  800db6:	ff 4d e0             	decl   -0x20(%ebp)
  800db9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800dbd:	79 af                	jns    800d6e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800dbf:	eb 13                	jmp    800dd4 <vprintfmt+0x24b>
				putch(' ', putdat);
  800dc1:	83 ec 08             	sub    $0x8,%esp
  800dc4:	ff 75 0c             	pushl  0xc(%ebp)
  800dc7:	6a 20                	push   $0x20
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcc:	ff d0                	call   *%eax
  800dce:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800dd1:	ff 4d e4             	decl   -0x1c(%ebp)
  800dd4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dd8:	7f e7                	jg     800dc1 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800dda:	e9 66 01 00 00       	jmp    800f45 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ddf:	83 ec 08             	sub    $0x8,%esp
  800de2:	ff 75 e8             	pushl  -0x18(%ebp)
  800de5:	8d 45 14             	lea    0x14(%ebp),%eax
  800de8:	50                   	push   %eax
  800de9:	e8 3c fd ff ff       	call   800b2a <getint>
  800dee:	83 c4 10             	add    $0x10,%esp
  800df1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800df4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800df7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dfd:	85 d2                	test   %edx,%edx
  800dff:	79 23                	jns    800e24 <vprintfmt+0x29b>
				putch('-', putdat);
  800e01:	83 ec 08             	sub    $0x8,%esp
  800e04:	ff 75 0c             	pushl  0xc(%ebp)
  800e07:	6a 2d                	push   $0x2d
  800e09:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0c:	ff d0                	call   *%eax
  800e0e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e17:	f7 d8                	neg    %eax
  800e19:	83 d2 00             	adc    $0x0,%edx
  800e1c:	f7 da                	neg    %edx
  800e1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e21:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e24:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e2b:	e9 bc 00 00 00       	jmp    800eec <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e30:	83 ec 08             	sub    $0x8,%esp
  800e33:	ff 75 e8             	pushl  -0x18(%ebp)
  800e36:	8d 45 14             	lea    0x14(%ebp),%eax
  800e39:	50                   	push   %eax
  800e3a:	e8 84 fc ff ff       	call   800ac3 <getuint>
  800e3f:	83 c4 10             	add    $0x10,%esp
  800e42:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e45:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e48:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e4f:	e9 98 00 00 00       	jmp    800eec <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e54:	83 ec 08             	sub    $0x8,%esp
  800e57:	ff 75 0c             	pushl  0xc(%ebp)
  800e5a:	6a 58                	push   $0x58
  800e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5f:	ff d0                	call   *%eax
  800e61:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e64:	83 ec 08             	sub    $0x8,%esp
  800e67:	ff 75 0c             	pushl  0xc(%ebp)
  800e6a:	6a 58                	push   $0x58
  800e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6f:	ff d0                	call   *%eax
  800e71:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e74:	83 ec 08             	sub    $0x8,%esp
  800e77:	ff 75 0c             	pushl  0xc(%ebp)
  800e7a:	6a 58                	push   $0x58
  800e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7f:	ff d0                	call   *%eax
  800e81:	83 c4 10             	add    $0x10,%esp
			break;
  800e84:	e9 bc 00 00 00       	jmp    800f45 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800e89:	83 ec 08             	sub    $0x8,%esp
  800e8c:	ff 75 0c             	pushl  0xc(%ebp)
  800e8f:	6a 30                	push   $0x30
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
  800e94:	ff d0                	call   *%eax
  800e96:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e99:	83 ec 08             	sub    $0x8,%esp
  800e9c:	ff 75 0c             	pushl  0xc(%ebp)
  800e9f:	6a 78                	push   $0x78
  800ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea4:	ff d0                	call   *%eax
  800ea6:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ea9:	8b 45 14             	mov    0x14(%ebp),%eax
  800eac:	83 c0 04             	add    $0x4,%eax
  800eaf:	89 45 14             	mov    %eax,0x14(%ebp)
  800eb2:	8b 45 14             	mov    0x14(%ebp),%eax
  800eb5:	83 e8 04             	sub    $0x4,%eax
  800eb8:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800eba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ebd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ec4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ecb:	eb 1f                	jmp    800eec <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ecd:	83 ec 08             	sub    $0x8,%esp
  800ed0:	ff 75 e8             	pushl  -0x18(%ebp)
  800ed3:	8d 45 14             	lea    0x14(%ebp),%eax
  800ed6:	50                   	push   %eax
  800ed7:	e8 e7 fb ff ff       	call   800ac3 <getuint>
  800edc:	83 c4 10             	add    $0x10,%esp
  800edf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ee2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ee5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800eec:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ef0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ef3:	83 ec 04             	sub    $0x4,%esp
  800ef6:	52                   	push   %edx
  800ef7:	ff 75 e4             	pushl  -0x1c(%ebp)
  800efa:	50                   	push   %eax
  800efb:	ff 75 f4             	pushl  -0xc(%ebp)
  800efe:	ff 75 f0             	pushl  -0x10(%ebp)
  800f01:	ff 75 0c             	pushl  0xc(%ebp)
  800f04:	ff 75 08             	pushl  0x8(%ebp)
  800f07:	e8 00 fb ff ff       	call   800a0c <printnum>
  800f0c:	83 c4 20             	add    $0x20,%esp
			break;
  800f0f:	eb 34                	jmp    800f45 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f11:	83 ec 08             	sub    $0x8,%esp
  800f14:	ff 75 0c             	pushl  0xc(%ebp)
  800f17:	53                   	push   %ebx
  800f18:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1b:	ff d0                	call   *%eax
  800f1d:	83 c4 10             	add    $0x10,%esp
			break;
  800f20:	eb 23                	jmp    800f45 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f22:	83 ec 08             	sub    $0x8,%esp
  800f25:	ff 75 0c             	pushl  0xc(%ebp)
  800f28:	6a 25                	push   $0x25
  800f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2d:	ff d0                	call   *%eax
  800f2f:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f32:	ff 4d 10             	decl   0x10(%ebp)
  800f35:	eb 03                	jmp    800f3a <vprintfmt+0x3b1>
  800f37:	ff 4d 10             	decl   0x10(%ebp)
  800f3a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3d:	48                   	dec    %eax
  800f3e:	8a 00                	mov    (%eax),%al
  800f40:	3c 25                	cmp    $0x25,%al
  800f42:	75 f3                	jne    800f37 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f44:	90                   	nop
		}
	}
  800f45:	e9 47 fc ff ff       	jmp    800b91 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f4a:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f4b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f4e:	5b                   	pop    %ebx
  800f4f:	5e                   	pop    %esi
  800f50:	5d                   	pop    %ebp
  800f51:	c3                   	ret    

00800f52 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f52:	55                   	push   %ebp
  800f53:	89 e5                	mov    %esp,%ebp
  800f55:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f58:	8d 45 10             	lea    0x10(%ebp),%eax
  800f5b:	83 c0 04             	add    $0x4,%eax
  800f5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f61:	8b 45 10             	mov    0x10(%ebp),%eax
  800f64:	ff 75 f4             	pushl  -0xc(%ebp)
  800f67:	50                   	push   %eax
  800f68:	ff 75 0c             	pushl  0xc(%ebp)
  800f6b:	ff 75 08             	pushl  0x8(%ebp)
  800f6e:	e8 16 fc ff ff       	call   800b89 <vprintfmt>
  800f73:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f76:	90                   	nop
  800f77:	c9                   	leave  
  800f78:	c3                   	ret    

00800f79 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f79:	55                   	push   %ebp
  800f7a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7f:	8b 40 08             	mov    0x8(%eax),%eax
  800f82:	8d 50 01             	lea    0x1(%eax),%edx
  800f85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f88:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8e:	8b 10                	mov    (%eax),%edx
  800f90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f93:	8b 40 04             	mov    0x4(%eax),%eax
  800f96:	39 c2                	cmp    %eax,%edx
  800f98:	73 12                	jae    800fac <sprintputch+0x33>
		*b->buf++ = ch;
  800f9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9d:	8b 00                	mov    (%eax),%eax
  800f9f:	8d 48 01             	lea    0x1(%eax),%ecx
  800fa2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fa5:	89 0a                	mov    %ecx,(%edx)
  800fa7:	8b 55 08             	mov    0x8(%ebp),%edx
  800faa:	88 10                	mov    %dl,(%eax)
}
  800fac:	90                   	nop
  800fad:	5d                   	pop    %ebp
  800fae:	c3                   	ret    

00800faf <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800faf:	55                   	push   %ebp
  800fb0:	89 e5                	mov    %esp,%ebp
  800fb2:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800fbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbe:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc4:	01 d0                	add    %edx,%eax
  800fc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fc9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800fd0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fd4:	74 06                	je     800fdc <vsnprintf+0x2d>
  800fd6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fda:	7f 07                	jg     800fe3 <vsnprintf+0x34>
		return -E_INVAL;
  800fdc:	b8 03 00 00 00       	mov    $0x3,%eax
  800fe1:	eb 20                	jmp    801003 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800fe3:	ff 75 14             	pushl  0x14(%ebp)
  800fe6:	ff 75 10             	pushl  0x10(%ebp)
  800fe9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800fec:	50                   	push   %eax
  800fed:	68 79 0f 80 00       	push   $0x800f79
  800ff2:	e8 92 fb ff ff       	call   800b89 <vprintfmt>
  800ff7:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ffa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ffd:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801000:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801003:	c9                   	leave  
  801004:	c3                   	ret    

00801005 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801005:	55                   	push   %ebp
  801006:	89 e5                	mov    %esp,%ebp
  801008:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80100b:	8d 45 10             	lea    0x10(%ebp),%eax
  80100e:	83 c0 04             	add    $0x4,%eax
  801011:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801014:	8b 45 10             	mov    0x10(%ebp),%eax
  801017:	ff 75 f4             	pushl  -0xc(%ebp)
  80101a:	50                   	push   %eax
  80101b:	ff 75 0c             	pushl  0xc(%ebp)
  80101e:	ff 75 08             	pushl  0x8(%ebp)
  801021:	e8 89 ff ff ff       	call   800faf <vsnprintf>
  801026:	83 c4 10             	add    $0x10,%esp
  801029:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80102c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80102f:	c9                   	leave  
  801030:	c3                   	ret    

00801031 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801031:	55                   	push   %ebp
  801032:	89 e5                	mov    %esp,%ebp
  801034:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801037:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80103e:	eb 06                	jmp    801046 <strlen+0x15>
		n++;
  801040:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801043:	ff 45 08             	incl   0x8(%ebp)
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
  801049:	8a 00                	mov    (%eax),%al
  80104b:	84 c0                	test   %al,%al
  80104d:	75 f1                	jne    801040 <strlen+0xf>
		n++;
	return n;
  80104f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801052:	c9                   	leave  
  801053:	c3                   	ret    

00801054 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801054:	55                   	push   %ebp
  801055:	89 e5                	mov    %esp,%ebp
  801057:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80105a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801061:	eb 09                	jmp    80106c <strnlen+0x18>
		n++;
  801063:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801066:	ff 45 08             	incl   0x8(%ebp)
  801069:	ff 4d 0c             	decl   0xc(%ebp)
  80106c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801070:	74 09                	je     80107b <strnlen+0x27>
  801072:	8b 45 08             	mov    0x8(%ebp),%eax
  801075:	8a 00                	mov    (%eax),%al
  801077:	84 c0                	test   %al,%al
  801079:	75 e8                	jne    801063 <strnlen+0xf>
		n++;
	return n;
  80107b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80107e:	c9                   	leave  
  80107f:	c3                   	ret    

00801080 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801080:	55                   	push   %ebp
  801081:	89 e5                	mov    %esp,%ebp
  801083:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801086:	8b 45 08             	mov    0x8(%ebp),%eax
  801089:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80108c:	90                   	nop
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
  801090:	8d 50 01             	lea    0x1(%eax),%edx
  801093:	89 55 08             	mov    %edx,0x8(%ebp)
  801096:	8b 55 0c             	mov    0xc(%ebp),%edx
  801099:	8d 4a 01             	lea    0x1(%edx),%ecx
  80109c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80109f:	8a 12                	mov    (%edx),%dl
  8010a1:	88 10                	mov    %dl,(%eax)
  8010a3:	8a 00                	mov    (%eax),%al
  8010a5:	84 c0                	test   %al,%al
  8010a7:	75 e4                	jne    80108d <strcpy+0xd>
		/* do nothing */;
	return ret;
  8010a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010ac:	c9                   	leave  
  8010ad:	c3                   	ret    

008010ae <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8010ae:	55                   	push   %ebp
  8010af:	89 e5                	mov    %esp,%ebp
  8010b1:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010c1:	eb 1f                	jmp    8010e2 <strncpy+0x34>
		*dst++ = *src;
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	8d 50 01             	lea    0x1(%eax),%edx
  8010c9:	89 55 08             	mov    %edx,0x8(%ebp)
  8010cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010cf:	8a 12                	mov    (%edx),%dl
  8010d1:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d6:	8a 00                	mov    (%eax),%al
  8010d8:	84 c0                	test   %al,%al
  8010da:	74 03                	je     8010df <strncpy+0x31>
			src++;
  8010dc:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010df:	ff 45 fc             	incl   -0x4(%ebp)
  8010e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e5:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010e8:	72 d9                	jb     8010c3 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010ed:	c9                   	leave  
  8010ee:	c3                   	ret    

008010ef <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010ef:	55                   	push   %ebp
  8010f0:	89 e5                	mov    %esp,%ebp
  8010f2:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010fb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ff:	74 30                	je     801131 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801101:	eb 16                	jmp    801119 <strlcpy+0x2a>
			*dst++ = *src++;
  801103:	8b 45 08             	mov    0x8(%ebp),%eax
  801106:	8d 50 01             	lea    0x1(%eax),%edx
  801109:	89 55 08             	mov    %edx,0x8(%ebp)
  80110c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80110f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801112:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801115:	8a 12                	mov    (%edx),%dl
  801117:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801119:	ff 4d 10             	decl   0x10(%ebp)
  80111c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801120:	74 09                	je     80112b <strlcpy+0x3c>
  801122:	8b 45 0c             	mov    0xc(%ebp),%eax
  801125:	8a 00                	mov    (%eax),%al
  801127:	84 c0                	test   %al,%al
  801129:	75 d8                	jne    801103 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80112b:	8b 45 08             	mov    0x8(%ebp),%eax
  80112e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801131:	8b 55 08             	mov    0x8(%ebp),%edx
  801134:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801137:	29 c2                	sub    %eax,%edx
  801139:	89 d0                	mov    %edx,%eax
}
  80113b:	c9                   	leave  
  80113c:	c3                   	ret    

0080113d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80113d:	55                   	push   %ebp
  80113e:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801140:	eb 06                	jmp    801148 <strcmp+0xb>
		p++, q++;
  801142:	ff 45 08             	incl   0x8(%ebp)
  801145:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
  80114b:	8a 00                	mov    (%eax),%al
  80114d:	84 c0                	test   %al,%al
  80114f:	74 0e                	je     80115f <strcmp+0x22>
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
  801154:	8a 10                	mov    (%eax),%dl
  801156:	8b 45 0c             	mov    0xc(%ebp),%eax
  801159:	8a 00                	mov    (%eax),%al
  80115b:	38 c2                	cmp    %al,%dl
  80115d:	74 e3                	je     801142 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80115f:	8b 45 08             	mov    0x8(%ebp),%eax
  801162:	8a 00                	mov    (%eax),%al
  801164:	0f b6 d0             	movzbl %al,%edx
  801167:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116a:	8a 00                	mov    (%eax),%al
  80116c:	0f b6 c0             	movzbl %al,%eax
  80116f:	29 c2                	sub    %eax,%edx
  801171:	89 d0                	mov    %edx,%eax
}
  801173:	5d                   	pop    %ebp
  801174:	c3                   	ret    

00801175 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801175:	55                   	push   %ebp
  801176:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801178:	eb 09                	jmp    801183 <strncmp+0xe>
		n--, p++, q++;
  80117a:	ff 4d 10             	decl   0x10(%ebp)
  80117d:	ff 45 08             	incl   0x8(%ebp)
  801180:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801183:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801187:	74 17                	je     8011a0 <strncmp+0x2b>
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
  80118c:	8a 00                	mov    (%eax),%al
  80118e:	84 c0                	test   %al,%al
  801190:	74 0e                	je     8011a0 <strncmp+0x2b>
  801192:	8b 45 08             	mov    0x8(%ebp),%eax
  801195:	8a 10                	mov    (%eax),%dl
  801197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119a:	8a 00                	mov    (%eax),%al
  80119c:	38 c2                	cmp    %al,%dl
  80119e:	74 da                	je     80117a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8011a0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011a4:	75 07                	jne    8011ad <strncmp+0x38>
		return 0;
  8011a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8011ab:	eb 14                	jmp    8011c1 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b0:	8a 00                	mov    (%eax),%al
  8011b2:	0f b6 d0             	movzbl %al,%edx
  8011b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b8:	8a 00                	mov    (%eax),%al
  8011ba:	0f b6 c0             	movzbl %al,%eax
  8011bd:	29 c2                	sub    %eax,%edx
  8011bf:	89 d0                	mov    %edx,%eax
}
  8011c1:	5d                   	pop    %ebp
  8011c2:	c3                   	ret    

008011c3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011c3:	55                   	push   %ebp
  8011c4:	89 e5                	mov    %esp,%ebp
  8011c6:	83 ec 04             	sub    $0x4,%esp
  8011c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cc:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011cf:	eb 12                	jmp    8011e3 <strchr+0x20>
		if (*s == c)
  8011d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d4:	8a 00                	mov    (%eax),%al
  8011d6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011d9:	75 05                	jne    8011e0 <strchr+0x1d>
			return (char *) s;
  8011db:	8b 45 08             	mov    0x8(%ebp),%eax
  8011de:	eb 11                	jmp    8011f1 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011e0:	ff 45 08             	incl   0x8(%ebp)
  8011e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e6:	8a 00                	mov    (%eax),%al
  8011e8:	84 c0                	test   %al,%al
  8011ea:	75 e5                	jne    8011d1 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011f1:	c9                   	leave  
  8011f2:	c3                   	ret    

008011f3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011f3:	55                   	push   %ebp
  8011f4:	89 e5                	mov    %esp,%ebp
  8011f6:	83 ec 04             	sub    $0x4,%esp
  8011f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fc:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011ff:	eb 0d                	jmp    80120e <strfind+0x1b>
		if (*s == c)
  801201:	8b 45 08             	mov    0x8(%ebp),%eax
  801204:	8a 00                	mov    (%eax),%al
  801206:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801209:	74 0e                	je     801219 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80120b:	ff 45 08             	incl   0x8(%ebp)
  80120e:	8b 45 08             	mov    0x8(%ebp),%eax
  801211:	8a 00                	mov    (%eax),%al
  801213:	84 c0                	test   %al,%al
  801215:	75 ea                	jne    801201 <strfind+0xe>
  801217:	eb 01                	jmp    80121a <strfind+0x27>
		if (*s == c)
			break;
  801219:	90                   	nop
	return (char *) s;
  80121a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80121d:	c9                   	leave  
  80121e:	c3                   	ret    

0080121f <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80121f:	55                   	push   %ebp
  801220:	89 e5                	mov    %esp,%ebp
  801222:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801225:	8b 45 08             	mov    0x8(%ebp),%eax
  801228:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80122b:	8b 45 10             	mov    0x10(%ebp),%eax
  80122e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801231:	eb 0e                	jmp    801241 <memset+0x22>
		*p++ = c;
  801233:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801236:	8d 50 01             	lea    0x1(%eax),%edx
  801239:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80123c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80123f:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801241:	ff 4d f8             	decl   -0x8(%ebp)
  801244:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801248:	79 e9                	jns    801233 <memset+0x14>
		*p++ = c;

	return v;
  80124a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80124d:	c9                   	leave  
  80124e:	c3                   	ret    

0080124f <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80124f:	55                   	push   %ebp
  801250:	89 e5                	mov    %esp,%ebp
  801252:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801255:	8b 45 0c             	mov    0xc(%ebp),%eax
  801258:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80125b:	8b 45 08             	mov    0x8(%ebp),%eax
  80125e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801261:	eb 16                	jmp    801279 <memcpy+0x2a>
		*d++ = *s++;
  801263:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801266:	8d 50 01             	lea    0x1(%eax),%edx
  801269:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80126c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80126f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801272:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801275:	8a 12                	mov    (%edx),%dl
  801277:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801279:	8b 45 10             	mov    0x10(%ebp),%eax
  80127c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80127f:	89 55 10             	mov    %edx,0x10(%ebp)
  801282:	85 c0                	test   %eax,%eax
  801284:	75 dd                	jne    801263 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801286:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801289:	c9                   	leave  
  80128a:	c3                   	ret    

0080128b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80128b:	55                   	push   %ebp
  80128c:	89 e5                	mov    %esp,%ebp
  80128e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801291:	8b 45 0c             	mov    0xc(%ebp),%eax
  801294:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801297:	8b 45 08             	mov    0x8(%ebp),%eax
  80129a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80129d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012a0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012a3:	73 50                	jae    8012f5 <memmove+0x6a>
  8012a5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ab:	01 d0                	add    %edx,%eax
  8012ad:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012b0:	76 43                	jbe    8012f5 <memmove+0x6a>
		s += n;
  8012b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b5:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8012b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012bb:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012be:	eb 10                	jmp    8012d0 <memmove+0x45>
			*--d = *--s;
  8012c0:	ff 4d f8             	decl   -0x8(%ebp)
  8012c3:	ff 4d fc             	decl   -0x4(%ebp)
  8012c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012c9:	8a 10                	mov    (%eax),%dl
  8012cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ce:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012d6:	89 55 10             	mov    %edx,0x10(%ebp)
  8012d9:	85 c0                	test   %eax,%eax
  8012db:	75 e3                	jne    8012c0 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8012dd:	eb 23                	jmp    801302 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8012df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e2:	8d 50 01             	lea    0x1(%eax),%edx
  8012e5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012eb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012ee:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012f1:	8a 12                	mov    (%edx),%dl
  8012f3:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012fb:	89 55 10             	mov    %edx,0x10(%ebp)
  8012fe:	85 c0                	test   %eax,%eax
  801300:	75 dd                	jne    8012df <memmove+0x54>
			*d++ = *s++;

	return dst;
  801302:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801305:	c9                   	leave  
  801306:	c3                   	ret    

00801307 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801307:	55                   	push   %ebp
  801308:	89 e5                	mov    %esp,%ebp
  80130a:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80130d:	8b 45 08             	mov    0x8(%ebp),%eax
  801310:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801313:	8b 45 0c             	mov    0xc(%ebp),%eax
  801316:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801319:	eb 2a                	jmp    801345 <memcmp+0x3e>
		if (*s1 != *s2)
  80131b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80131e:	8a 10                	mov    (%eax),%dl
  801320:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801323:	8a 00                	mov    (%eax),%al
  801325:	38 c2                	cmp    %al,%dl
  801327:	74 16                	je     80133f <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801329:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80132c:	8a 00                	mov    (%eax),%al
  80132e:	0f b6 d0             	movzbl %al,%edx
  801331:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801334:	8a 00                	mov    (%eax),%al
  801336:	0f b6 c0             	movzbl %al,%eax
  801339:	29 c2                	sub    %eax,%edx
  80133b:	89 d0                	mov    %edx,%eax
  80133d:	eb 18                	jmp    801357 <memcmp+0x50>
		s1++, s2++;
  80133f:	ff 45 fc             	incl   -0x4(%ebp)
  801342:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801345:	8b 45 10             	mov    0x10(%ebp),%eax
  801348:	8d 50 ff             	lea    -0x1(%eax),%edx
  80134b:	89 55 10             	mov    %edx,0x10(%ebp)
  80134e:	85 c0                	test   %eax,%eax
  801350:	75 c9                	jne    80131b <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801352:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801357:	c9                   	leave  
  801358:	c3                   	ret    

00801359 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801359:	55                   	push   %ebp
  80135a:	89 e5                	mov    %esp,%ebp
  80135c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80135f:	8b 55 08             	mov    0x8(%ebp),%edx
  801362:	8b 45 10             	mov    0x10(%ebp),%eax
  801365:	01 d0                	add    %edx,%eax
  801367:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80136a:	eb 15                	jmp    801381 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80136c:	8b 45 08             	mov    0x8(%ebp),%eax
  80136f:	8a 00                	mov    (%eax),%al
  801371:	0f b6 d0             	movzbl %al,%edx
  801374:	8b 45 0c             	mov    0xc(%ebp),%eax
  801377:	0f b6 c0             	movzbl %al,%eax
  80137a:	39 c2                	cmp    %eax,%edx
  80137c:	74 0d                	je     80138b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80137e:	ff 45 08             	incl   0x8(%ebp)
  801381:	8b 45 08             	mov    0x8(%ebp),%eax
  801384:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801387:	72 e3                	jb     80136c <memfind+0x13>
  801389:	eb 01                	jmp    80138c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80138b:	90                   	nop
	return (void *) s;
  80138c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80138f:	c9                   	leave  
  801390:	c3                   	ret    

00801391 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801391:	55                   	push   %ebp
  801392:	89 e5                	mov    %esp,%ebp
  801394:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801397:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80139e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013a5:	eb 03                	jmp    8013aa <strtol+0x19>
		s++;
  8013a7:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ad:	8a 00                	mov    (%eax),%al
  8013af:	3c 20                	cmp    $0x20,%al
  8013b1:	74 f4                	je     8013a7 <strtol+0x16>
  8013b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b6:	8a 00                	mov    (%eax),%al
  8013b8:	3c 09                	cmp    $0x9,%al
  8013ba:	74 eb                	je     8013a7 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bf:	8a 00                	mov    (%eax),%al
  8013c1:	3c 2b                	cmp    $0x2b,%al
  8013c3:	75 05                	jne    8013ca <strtol+0x39>
		s++;
  8013c5:	ff 45 08             	incl   0x8(%ebp)
  8013c8:	eb 13                	jmp    8013dd <strtol+0x4c>
	else if (*s == '-')
  8013ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cd:	8a 00                	mov    (%eax),%al
  8013cf:	3c 2d                	cmp    $0x2d,%al
  8013d1:	75 0a                	jne    8013dd <strtol+0x4c>
		s++, neg = 1;
  8013d3:	ff 45 08             	incl   0x8(%ebp)
  8013d6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013e1:	74 06                	je     8013e9 <strtol+0x58>
  8013e3:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8013e7:	75 20                	jne    801409 <strtol+0x78>
  8013e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ec:	8a 00                	mov    (%eax),%al
  8013ee:	3c 30                	cmp    $0x30,%al
  8013f0:	75 17                	jne    801409 <strtol+0x78>
  8013f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f5:	40                   	inc    %eax
  8013f6:	8a 00                	mov    (%eax),%al
  8013f8:	3c 78                	cmp    $0x78,%al
  8013fa:	75 0d                	jne    801409 <strtol+0x78>
		s += 2, base = 16;
  8013fc:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801400:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801407:	eb 28                	jmp    801431 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801409:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80140d:	75 15                	jne    801424 <strtol+0x93>
  80140f:	8b 45 08             	mov    0x8(%ebp),%eax
  801412:	8a 00                	mov    (%eax),%al
  801414:	3c 30                	cmp    $0x30,%al
  801416:	75 0c                	jne    801424 <strtol+0x93>
		s++, base = 8;
  801418:	ff 45 08             	incl   0x8(%ebp)
  80141b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801422:	eb 0d                	jmp    801431 <strtol+0xa0>
	else if (base == 0)
  801424:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801428:	75 07                	jne    801431 <strtol+0xa0>
		base = 10;
  80142a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801431:	8b 45 08             	mov    0x8(%ebp),%eax
  801434:	8a 00                	mov    (%eax),%al
  801436:	3c 2f                	cmp    $0x2f,%al
  801438:	7e 19                	jle    801453 <strtol+0xc2>
  80143a:	8b 45 08             	mov    0x8(%ebp),%eax
  80143d:	8a 00                	mov    (%eax),%al
  80143f:	3c 39                	cmp    $0x39,%al
  801441:	7f 10                	jg     801453 <strtol+0xc2>
			dig = *s - '0';
  801443:	8b 45 08             	mov    0x8(%ebp),%eax
  801446:	8a 00                	mov    (%eax),%al
  801448:	0f be c0             	movsbl %al,%eax
  80144b:	83 e8 30             	sub    $0x30,%eax
  80144e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801451:	eb 42                	jmp    801495 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801453:	8b 45 08             	mov    0x8(%ebp),%eax
  801456:	8a 00                	mov    (%eax),%al
  801458:	3c 60                	cmp    $0x60,%al
  80145a:	7e 19                	jle    801475 <strtol+0xe4>
  80145c:	8b 45 08             	mov    0x8(%ebp),%eax
  80145f:	8a 00                	mov    (%eax),%al
  801461:	3c 7a                	cmp    $0x7a,%al
  801463:	7f 10                	jg     801475 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801465:	8b 45 08             	mov    0x8(%ebp),%eax
  801468:	8a 00                	mov    (%eax),%al
  80146a:	0f be c0             	movsbl %al,%eax
  80146d:	83 e8 57             	sub    $0x57,%eax
  801470:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801473:	eb 20                	jmp    801495 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801475:	8b 45 08             	mov    0x8(%ebp),%eax
  801478:	8a 00                	mov    (%eax),%al
  80147a:	3c 40                	cmp    $0x40,%al
  80147c:	7e 39                	jle    8014b7 <strtol+0x126>
  80147e:	8b 45 08             	mov    0x8(%ebp),%eax
  801481:	8a 00                	mov    (%eax),%al
  801483:	3c 5a                	cmp    $0x5a,%al
  801485:	7f 30                	jg     8014b7 <strtol+0x126>
			dig = *s - 'A' + 10;
  801487:	8b 45 08             	mov    0x8(%ebp),%eax
  80148a:	8a 00                	mov    (%eax),%al
  80148c:	0f be c0             	movsbl %al,%eax
  80148f:	83 e8 37             	sub    $0x37,%eax
  801492:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801498:	3b 45 10             	cmp    0x10(%ebp),%eax
  80149b:	7d 19                	jge    8014b6 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80149d:	ff 45 08             	incl   0x8(%ebp)
  8014a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014a3:	0f af 45 10          	imul   0x10(%ebp),%eax
  8014a7:	89 c2                	mov    %eax,%edx
  8014a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ac:	01 d0                	add    %edx,%eax
  8014ae:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8014b1:	e9 7b ff ff ff       	jmp    801431 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8014b6:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8014b7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014bb:	74 08                	je     8014c5 <strtol+0x134>
		*endptr = (char *) s;
  8014bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8014c3:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8014c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014c9:	74 07                	je     8014d2 <strtol+0x141>
  8014cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014ce:	f7 d8                	neg    %eax
  8014d0:	eb 03                	jmp    8014d5 <strtol+0x144>
  8014d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014d5:	c9                   	leave  
  8014d6:	c3                   	ret    

008014d7 <ltostr>:

void
ltostr(long value, char *str)
{
  8014d7:	55                   	push   %ebp
  8014d8:	89 e5                	mov    %esp,%ebp
  8014da:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8014dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8014e4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8014eb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014ef:	79 13                	jns    801504 <ltostr+0x2d>
	{
		neg = 1;
  8014f1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014fb:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8014fe:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801501:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801504:	8b 45 08             	mov    0x8(%ebp),%eax
  801507:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80150c:	99                   	cltd   
  80150d:	f7 f9                	idiv   %ecx
  80150f:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801512:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801515:	8d 50 01             	lea    0x1(%eax),%edx
  801518:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80151b:	89 c2                	mov    %eax,%edx
  80151d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801520:	01 d0                	add    %edx,%eax
  801522:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801525:	83 c2 30             	add    $0x30,%edx
  801528:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80152a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80152d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801532:	f7 e9                	imul   %ecx
  801534:	c1 fa 02             	sar    $0x2,%edx
  801537:	89 c8                	mov    %ecx,%eax
  801539:	c1 f8 1f             	sar    $0x1f,%eax
  80153c:	29 c2                	sub    %eax,%edx
  80153e:	89 d0                	mov    %edx,%eax
  801540:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801543:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801546:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80154b:	f7 e9                	imul   %ecx
  80154d:	c1 fa 02             	sar    $0x2,%edx
  801550:	89 c8                	mov    %ecx,%eax
  801552:	c1 f8 1f             	sar    $0x1f,%eax
  801555:	29 c2                	sub    %eax,%edx
  801557:	89 d0                	mov    %edx,%eax
  801559:	c1 e0 02             	shl    $0x2,%eax
  80155c:	01 d0                	add    %edx,%eax
  80155e:	01 c0                	add    %eax,%eax
  801560:	29 c1                	sub    %eax,%ecx
  801562:	89 ca                	mov    %ecx,%edx
  801564:	85 d2                	test   %edx,%edx
  801566:	75 9c                	jne    801504 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801568:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80156f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801572:	48                   	dec    %eax
  801573:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801576:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80157a:	74 3d                	je     8015b9 <ltostr+0xe2>
		start = 1 ;
  80157c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801583:	eb 34                	jmp    8015b9 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801585:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801588:	8b 45 0c             	mov    0xc(%ebp),%eax
  80158b:	01 d0                	add    %edx,%eax
  80158d:	8a 00                	mov    (%eax),%al
  80158f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801592:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801595:	8b 45 0c             	mov    0xc(%ebp),%eax
  801598:	01 c2                	add    %eax,%edx
  80159a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80159d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a0:	01 c8                	add    %ecx,%eax
  8015a2:	8a 00                	mov    (%eax),%al
  8015a4:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8015a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ac:	01 c2                	add    %eax,%edx
  8015ae:	8a 45 eb             	mov    -0x15(%ebp),%al
  8015b1:	88 02                	mov    %al,(%edx)
		start++ ;
  8015b3:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8015b6:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8015b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015bc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015bf:	7c c4                	jl     801585 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8015c1:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8015c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c7:	01 d0                	add    %edx,%eax
  8015c9:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8015cc:	90                   	nop
  8015cd:	c9                   	leave  
  8015ce:	c3                   	ret    

008015cf <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8015cf:	55                   	push   %ebp
  8015d0:	89 e5                	mov    %esp,%ebp
  8015d2:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8015d5:	ff 75 08             	pushl  0x8(%ebp)
  8015d8:	e8 54 fa ff ff       	call   801031 <strlen>
  8015dd:	83 c4 04             	add    $0x4,%esp
  8015e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8015e3:	ff 75 0c             	pushl  0xc(%ebp)
  8015e6:	e8 46 fa ff ff       	call   801031 <strlen>
  8015eb:	83 c4 04             	add    $0x4,%esp
  8015ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8015f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015ff:	eb 17                	jmp    801618 <strcconcat+0x49>
		final[s] = str1[s] ;
  801601:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801604:	8b 45 10             	mov    0x10(%ebp),%eax
  801607:	01 c2                	add    %eax,%edx
  801609:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80160c:	8b 45 08             	mov    0x8(%ebp),%eax
  80160f:	01 c8                	add    %ecx,%eax
  801611:	8a 00                	mov    (%eax),%al
  801613:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801615:	ff 45 fc             	incl   -0x4(%ebp)
  801618:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80161b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80161e:	7c e1                	jl     801601 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801620:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801627:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80162e:	eb 1f                	jmp    80164f <strcconcat+0x80>
		final[s++] = str2[i] ;
  801630:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801633:	8d 50 01             	lea    0x1(%eax),%edx
  801636:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801639:	89 c2                	mov    %eax,%edx
  80163b:	8b 45 10             	mov    0x10(%ebp),%eax
  80163e:	01 c2                	add    %eax,%edx
  801640:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801643:	8b 45 0c             	mov    0xc(%ebp),%eax
  801646:	01 c8                	add    %ecx,%eax
  801648:	8a 00                	mov    (%eax),%al
  80164a:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80164c:	ff 45 f8             	incl   -0x8(%ebp)
  80164f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801652:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801655:	7c d9                	jl     801630 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801657:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80165a:	8b 45 10             	mov    0x10(%ebp),%eax
  80165d:	01 d0                	add    %edx,%eax
  80165f:	c6 00 00             	movb   $0x0,(%eax)
}
  801662:	90                   	nop
  801663:	c9                   	leave  
  801664:	c3                   	ret    

00801665 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801665:	55                   	push   %ebp
  801666:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801668:	8b 45 14             	mov    0x14(%ebp),%eax
  80166b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801671:	8b 45 14             	mov    0x14(%ebp),%eax
  801674:	8b 00                	mov    (%eax),%eax
  801676:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80167d:	8b 45 10             	mov    0x10(%ebp),%eax
  801680:	01 d0                	add    %edx,%eax
  801682:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801688:	eb 0c                	jmp    801696 <strsplit+0x31>
			*string++ = 0;
  80168a:	8b 45 08             	mov    0x8(%ebp),%eax
  80168d:	8d 50 01             	lea    0x1(%eax),%edx
  801690:	89 55 08             	mov    %edx,0x8(%ebp)
  801693:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801696:	8b 45 08             	mov    0x8(%ebp),%eax
  801699:	8a 00                	mov    (%eax),%al
  80169b:	84 c0                	test   %al,%al
  80169d:	74 18                	je     8016b7 <strsplit+0x52>
  80169f:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a2:	8a 00                	mov    (%eax),%al
  8016a4:	0f be c0             	movsbl %al,%eax
  8016a7:	50                   	push   %eax
  8016a8:	ff 75 0c             	pushl  0xc(%ebp)
  8016ab:	e8 13 fb ff ff       	call   8011c3 <strchr>
  8016b0:	83 c4 08             	add    $0x8,%esp
  8016b3:	85 c0                	test   %eax,%eax
  8016b5:	75 d3                	jne    80168a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8016b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ba:	8a 00                	mov    (%eax),%al
  8016bc:	84 c0                	test   %al,%al
  8016be:	74 5a                	je     80171a <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8016c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8016c3:	8b 00                	mov    (%eax),%eax
  8016c5:	83 f8 0f             	cmp    $0xf,%eax
  8016c8:	75 07                	jne    8016d1 <strsplit+0x6c>
		{
			return 0;
  8016ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8016cf:	eb 66                	jmp    801737 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8016d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8016d4:	8b 00                	mov    (%eax),%eax
  8016d6:	8d 48 01             	lea    0x1(%eax),%ecx
  8016d9:	8b 55 14             	mov    0x14(%ebp),%edx
  8016dc:	89 0a                	mov    %ecx,(%edx)
  8016de:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e8:	01 c2                	add    %eax,%edx
  8016ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ed:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016ef:	eb 03                	jmp    8016f4 <strsplit+0x8f>
			string++;
  8016f1:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f7:	8a 00                	mov    (%eax),%al
  8016f9:	84 c0                	test   %al,%al
  8016fb:	74 8b                	je     801688 <strsplit+0x23>
  8016fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801700:	8a 00                	mov    (%eax),%al
  801702:	0f be c0             	movsbl %al,%eax
  801705:	50                   	push   %eax
  801706:	ff 75 0c             	pushl  0xc(%ebp)
  801709:	e8 b5 fa ff ff       	call   8011c3 <strchr>
  80170e:	83 c4 08             	add    $0x8,%esp
  801711:	85 c0                	test   %eax,%eax
  801713:	74 dc                	je     8016f1 <strsplit+0x8c>
			string++;
	}
  801715:	e9 6e ff ff ff       	jmp    801688 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80171a:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80171b:	8b 45 14             	mov    0x14(%ebp),%eax
  80171e:	8b 00                	mov    (%eax),%eax
  801720:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801727:	8b 45 10             	mov    0x10(%ebp),%eax
  80172a:	01 d0                	add    %edx,%eax
  80172c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801732:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801737:	c9                   	leave  
  801738:	c3                   	ret    

00801739 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
  80173c:	57                   	push   %edi
  80173d:	56                   	push   %esi
  80173e:	53                   	push   %ebx
  80173f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801742:	8b 45 08             	mov    0x8(%ebp),%eax
  801745:	8b 55 0c             	mov    0xc(%ebp),%edx
  801748:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80174b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80174e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801751:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801754:	cd 30                	int    $0x30
  801756:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801759:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80175c:	83 c4 10             	add    $0x10,%esp
  80175f:	5b                   	pop    %ebx
  801760:	5e                   	pop    %esi
  801761:	5f                   	pop    %edi
  801762:	5d                   	pop    %ebp
  801763:	c3                   	ret    

00801764 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801764:	55                   	push   %ebp
  801765:	89 e5                	mov    %esp,%ebp
  801767:	83 ec 04             	sub    $0x4,%esp
  80176a:	8b 45 10             	mov    0x10(%ebp),%eax
  80176d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801770:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801774:	8b 45 08             	mov    0x8(%ebp),%eax
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	52                   	push   %edx
  80177c:	ff 75 0c             	pushl  0xc(%ebp)
  80177f:	50                   	push   %eax
  801780:	6a 00                	push   $0x0
  801782:	e8 b2 ff ff ff       	call   801739 <syscall>
  801787:	83 c4 18             	add    $0x18,%esp
}
  80178a:	90                   	nop
  80178b:	c9                   	leave  
  80178c:	c3                   	ret    

0080178d <sys_cgetc>:

int
sys_cgetc(void)
{
  80178d:	55                   	push   %ebp
  80178e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801790:	6a 00                	push   $0x0
  801792:	6a 00                	push   $0x0
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	6a 01                	push   $0x1
  80179c:	e8 98 ff ff ff       	call   801739 <syscall>
  8017a1:	83 c4 18             	add    $0x18,%esp
}
  8017a4:	c9                   	leave  
  8017a5:	c3                   	ret    

008017a6 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8017a6:	55                   	push   %ebp
  8017a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8017a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	6a 00                	push   $0x0
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 00                	push   $0x0
  8017b5:	52                   	push   %edx
  8017b6:	50                   	push   %eax
  8017b7:	6a 05                	push   $0x5
  8017b9:	e8 7b ff ff ff       	call   801739 <syscall>
  8017be:	83 c4 18             	add    $0x18,%esp
}
  8017c1:	c9                   	leave  
  8017c2:	c3                   	ret    

008017c3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
  8017c6:	56                   	push   %esi
  8017c7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017c8:	8b 75 18             	mov    0x18(%ebp),%esi
  8017cb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017ce:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d7:	56                   	push   %esi
  8017d8:	53                   	push   %ebx
  8017d9:	51                   	push   %ecx
  8017da:	52                   	push   %edx
  8017db:	50                   	push   %eax
  8017dc:	6a 06                	push   $0x6
  8017de:	e8 56 ff ff ff       	call   801739 <syscall>
  8017e3:	83 c4 18             	add    $0x18,%esp
}
  8017e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017e9:	5b                   	pop    %ebx
  8017ea:	5e                   	pop    %esi
  8017eb:	5d                   	pop    %ebp
  8017ec:	c3                   	ret    

008017ed <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8017ed:	55                   	push   %ebp
  8017ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8017f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 00                	push   $0x0
  8017fc:	52                   	push   %edx
  8017fd:	50                   	push   %eax
  8017fe:	6a 07                	push   $0x7
  801800:	e8 34 ff ff ff       	call   801739 <syscall>
  801805:	83 c4 18             	add    $0x18,%esp
}
  801808:	c9                   	leave  
  801809:	c3                   	ret    

0080180a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80180d:	6a 00                	push   $0x0
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	ff 75 0c             	pushl  0xc(%ebp)
  801816:	ff 75 08             	pushl  0x8(%ebp)
  801819:	6a 08                	push   $0x8
  80181b:	e8 19 ff ff ff       	call   801739 <syscall>
  801820:	83 c4 18             	add    $0x18,%esp
}
  801823:	c9                   	leave  
  801824:	c3                   	ret    

00801825 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801825:	55                   	push   %ebp
  801826:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	6a 09                	push   $0x9
  801834:	e8 00 ff ff ff       	call   801739 <syscall>
  801839:	83 c4 18             	add    $0x18,%esp
}
  80183c:	c9                   	leave  
  80183d:	c3                   	ret    

0080183e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80183e:	55                   	push   %ebp
  80183f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 0a                	push   $0xa
  80184d:	e8 e7 fe ff ff       	call   801739 <syscall>
  801852:	83 c4 18             	add    $0x18,%esp
}
  801855:	c9                   	leave  
  801856:	c3                   	ret    

00801857 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 0b                	push   $0xb
  801866:	e8 ce fe ff ff       	call   801739 <syscall>
  80186b:	83 c4 18             	add    $0x18,%esp
}
  80186e:	c9                   	leave  
  80186f:	c3                   	ret    

00801870 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	ff 75 0c             	pushl  0xc(%ebp)
  80187c:	ff 75 08             	pushl  0x8(%ebp)
  80187f:	6a 0f                	push   $0xf
  801881:	e8 b3 fe ff ff       	call   801739 <syscall>
  801886:	83 c4 18             	add    $0x18,%esp
	return;
  801889:	90                   	nop
}
  80188a:	c9                   	leave  
  80188b:	c3                   	ret    

0080188c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	ff 75 0c             	pushl  0xc(%ebp)
  801898:	ff 75 08             	pushl  0x8(%ebp)
  80189b:	6a 10                	push   $0x10
  80189d:	e8 97 fe ff ff       	call   801739 <syscall>
  8018a2:	83 c4 18             	add    $0x18,%esp
	return ;
  8018a5:	90                   	nop
}
  8018a6:	c9                   	leave  
  8018a7:	c3                   	ret    

008018a8 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018a8:	55                   	push   %ebp
  8018a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	ff 75 10             	pushl  0x10(%ebp)
  8018b2:	ff 75 0c             	pushl  0xc(%ebp)
  8018b5:	ff 75 08             	pushl  0x8(%ebp)
  8018b8:	6a 11                	push   $0x11
  8018ba:	e8 7a fe ff ff       	call   801739 <syscall>
  8018bf:	83 c4 18             	add    $0x18,%esp
	return ;
  8018c2:	90                   	nop
}
  8018c3:	c9                   	leave  
  8018c4:	c3                   	ret    

008018c5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8018c5:	55                   	push   %ebp
  8018c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 0c                	push   $0xc
  8018d4:	e8 60 fe ff ff       	call   801739 <syscall>
  8018d9:	83 c4 18             	add    $0x18,%esp
}
  8018dc:	c9                   	leave  
  8018dd:	c3                   	ret    

008018de <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8018de:	55                   	push   %ebp
  8018df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	ff 75 08             	pushl  0x8(%ebp)
  8018ec:	6a 0d                	push   $0xd
  8018ee:	e8 46 fe ff ff       	call   801739 <syscall>
  8018f3:	83 c4 18             	add    $0x18,%esp
}
  8018f6:	c9                   	leave  
  8018f7:	c3                   	ret    

008018f8 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8018f8:	55                   	push   %ebp
  8018f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	6a 0e                	push   $0xe
  801907:	e8 2d fe ff ff       	call   801739 <syscall>
  80190c:	83 c4 18             	add    $0x18,%esp
}
  80190f:	90                   	nop
  801910:	c9                   	leave  
  801911:	c3                   	ret    

00801912 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801912:	55                   	push   %ebp
  801913:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 13                	push   $0x13
  801921:	e8 13 fe ff ff       	call   801739 <syscall>
  801926:	83 c4 18             	add    $0x18,%esp
}
  801929:	90                   	nop
  80192a:	c9                   	leave  
  80192b:	c3                   	ret    

0080192c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80192c:	55                   	push   %ebp
  80192d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 14                	push   $0x14
  80193b:	e8 f9 fd ff ff       	call   801739 <syscall>
  801940:	83 c4 18             	add    $0x18,%esp
}
  801943:	90                   	nop
  801944:	c9                   	leave  
  801945:	c3                   	ret    

00801946 <sys_cputc>:


void
sys_cputc(const char c)
{
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
  801949:	83 ec 04             	sub    $0x4,%esp
  80194c:	8b 45 08             	mov    0x8(%ebp),%eax
  80194f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801952:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	50                   	push   %eax
  80195f:	6a 15                	push   $0x15
  801961:	e8 d3 fd ff ff       	call   801739 <syscall>
  801966:	83 c4 18             	add    $0x18,%esp
}
  801969:	90                   	nop
  80196a:	c9                   	leave  
  80196b:	c3                   	ret    

0080196c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 16                	push   $0x16
  80197b:	e8 b9 fd ff ff       	call   801739 <syscall>
  801980:	83 c4 18             	add    $0x18,%esp
}
  801983:	90                   	nop
  801984:	c9                   	leave  
  801985:	c3                   	ret    

00801986 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801989:	8b 45 08             	mov    0x8(%ebp),%eax
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	ff 75 0c             	pushl  0xc(%ebp)
  801995:	50                   	push   %eax
  801996:	6a 17                	push   $0x17
  801998:	e8 9c fd ff ff       	call   801739 <syscall>
  80199d:	83 c4 18             	add    $0x18,%esp
}
  8019a0:	c9                   	leave  
  8019a1:	c3                   	ret    

008019a2 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	52                   	push   %edx
  8019b2:	50                   	push   %eax
  8019b3:	6a 1a                	push   $0x1a
  8019b5:	e8 7f fd ff ff       	call   801739 <syscall>
  8019ba:	83 c4 18             	add    $0x18,%esp
}
  8019bd:	c9                   	leave  
  8019be:	c3                   	ret    

008019bf <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019bf:	55                   	push   %ebp
  8019c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	52                   	push   %edx
  8019cf:	50                   	push   %eax
  8019d0:	6a 18                	push   $0x18
  8019d2:	e8 62 fd ff ff       	call   801739 <syscall>
  8019d7:	83 c4 18             	add    $0x18,%esp
}
  8019da:	90                   	nop
  8019db:	c9                   	leave  
  8019dc:	c3                   	ret    

008019dd <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	52                   	push   %edx
  8019ed:	50                   	push   %eax
  8019ee:	6a 19                	push   $0x19
  8019f0:	e8 44 fd ff ff       	call   801739 <syscall>
  8019f5:	83 c4 18             	add    $0x18,%esp
}
  8019f8:	90                   	nop
  8019f9:	c9                   	leave  
  8019fa:	c3                   	ret    

008019fb <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019fb:	55                   	push   %ebp
  8019fc:	89 e5                	mov    %esp,%ebp
  8019fe:	83 ec 04             	sub    $0x4,%esp
  801a01:	8b 45 10             	mov    0x10(%ebp),%eax
  801a04:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a07:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a0a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a11:	6a 00                	push   $0x0
  801a13:	51                   	push   %ecx
  801a14:	52                   	push   %edx
  801a15:	ff 75 0c             	pushl  0xc(%ebp)
  801a18:	50                   	push   %eax
  801a19:	6a 1b                	push   $0x1b
  801a1b:	e8 19 fd ff ff       	call   801739 <syscall>
  801a20:	83 c4 18             	add    $0x18,%esp
}
  801a23:	c9                   	leave  
  801a24:	c3                   	ret    

00801a25 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a28:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	52                   	push   %edx
  801a35:	50                   	push   %eax
  801a36:	6a 1c                	push   $0x1c
  801a38:	e8 fc fc ff ff       	call   801739 <syscall>
  801a3d:	83 c4 18             	add    $0x18,%esp
}
  801a40:	c9                   	leave  
  801a41:	c3                   	ret    

00801a42 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a42:	55                   	push   %ebp
  801a43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a45:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a48:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	51                   	push   %ecx
  801a53:	52                   	push   %edx
  801a54:	50                   	push   %eax
  801a55:	6a 1d                	push   $0x1d
  801a57:	e8 dd fc ff ff       	call   801739 <syscall>
  801a5c:	83 c4 18             	add    $0x18,%esp
}
  801a5f:	c9                   	leave  
  801a60:	c3                   	ret    

00801a61 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a64:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a67:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	52                   	push   %edx
  801a71:	50                   	push   %eax
  801a72:	6a 1e                	push   $0x1e
  801a74:	e8 c0 fc ff ff       	call   801739 <syscall>
  801a79:	83 c4 18             	add    $0x18,%esp
}
  801a7c:	c9                   	leave  
  801a7d:	c3                   	ret    

00801a7e <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a7e:	55                   	push   %ebp
  801a7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 1f                	push   $0x1f
  801a8d:	e8 a7 fc ff ff       	call   801739 <syscall>
  801a92:	83 c4 18             	add    $0x18,%esp
}
  801a95:	c9                   	leave  
  801a96:	c3                   	ret    

00801a97 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9d:	6a 00                	push   $0x0
  801a9f:	ff 75 14             	pushl  0x14(%ebp)
  801aa2:	ff 75 10             	pushl  0x10(%ebp)
  801aa5:	ff 75 0c             	pushl  0xc(%ebp)
  801aa8:	50                   	push   %eax
  801aa9:	6a 20                	push   $0x20
  801aab:	e8 89 fc ff ff       	call   801739 <syscall>
  801ab0:	83 c4 18             	add    $0x18,%esp
}
  801ab3:	c9                   	leave  
  801ab4:	c3                   	ret    

00801ab5 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	50                   	push   %eax
  801ac4:	6a 21                	push   $0x21
  801ac6:	e8 6e fc ff ff       	call   801739 <syscall>
  801acb:	83 c4 18             	add    $0x18,%esp
}
  801ace:	90                   	nop
  801acf:	c9                   	leave  
  801ad0:	c3                   	ret    

00801ad1 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	50                   	push   %eax
  801ae0:	6a 22                	push   $0x22
  801ae2:	e8 52 fc ff ff       	call   801739 <syscall>
  801ae7:	83 c4 18             	add    $0x18,%esp
}
  801aea:	c9                   	leave  
  801aeb:	c3                   	ret    

00801aec <sys_getenvid>:

int32 sys_getenvid(void)
{
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 02                	push   $0x2
  801afb:	e8 39 fc ff ff       	call   801739 <syscall>
  801b00:	83 c4 18             	add    $0x18,%esp
}
  801b03:	c9                   	leave  
  801b04:	c3                   	ret    

00801b05 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b05:	55                   	push   %ebp
  801b06:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 03                	push   $0x3
  801b14:	e8 20 fc ff ff       	call   801739 <syscall>
  801b19:	83 c4 18             	add    $0x18,%esp
}
  801b1c:	c9                   	leave  
  801b1d:	c3                   	ret    

00801b1e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 04                	push   $0x4
  801b2d:	e8 07 fc ff ff       	call   801739 <syscall>
  801b32:	83 c4 18             	add    $0x18,%esp
}
  801b35:	c9                   	leave  
  801b36:	c3                   	ret    

00801b37 <sys_exit_env>:


void sys_exit_env(void)
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 23                	push   $0x23
  801b46:	e8 ee fb ff ff       	call   801739 <syscall>
  801b4b:	83 c4 18             	add    $0x18,%esp
}
  801b4e:	90                   	nop
  801b4f:	c9                   	leave  
  801b50:	c3                   	ret    

00801b51 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b51:	55                   	push   %ebp
  801b52:	89 e5                	mov    %esp,%ebp
  801b54:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b57:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b5a:	8d 50 04             	lea    0x4(%eax),%edx
  801b5d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	52                   	push   %edx
  801b67:	50                   	push   %eax
  801b68:	6a 24                	push   $0x24
  801b6a:	e8 ca fb ff ff       	call   801739 <syscall>
  801b6f:	83 c4 18             	add    $0x18,%esp
	return result;
  801b72:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b75:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b78:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b7b:	89 01                	mov    %eax,(%ecx)
  801b7d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b80:	8b 45 08             	mov    0x8(%ebp),%eax
  801b83:	c9                   	leave  
  801b84:	c2 04 00             	ret    $0x4

00801b87 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b87:	55                   	push   %ebp
  801b88:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	ff 75 10             	pushl  0x10(%ebp)
  801b91:	ff 75 0c             	pushl  0xc(%ebp)
  801b94:	ff 75 08             	pushl  0x8(%ebp)
  801b97:	6a 12                	push   $0x12
  801b99:	e8 9b fb ff ff       	call   801739 <syscall>
  801b9e:	83 c4 18             	add    $0x18,%esp
	return ;
  801ba1:	90                   	nop
}
  801ba2:	c9                   	leave  
  801ba3:	c3                   	ret    

00801ba4 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 25                	push   $0x25
  801bb3:	e8 81 fb ff ff       	call   801739 <syscall>
  801bb8:	83 c4 18             	add    $0x18,%esp
}
  801bbb:	c9                   	leave  
  801bbc:	c3                   	ret    

00801bbd <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
  801bc0:	83 ec 04             	sub    $0x4,%esp
  801bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bc9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	50                   	push   %eax
  801bd6:	6a 26                	push   $0x26
  801bd8:	e8 5c fb ff ff       	call   801739 <syscall>
  801bdd:	83 c4 18             	add    $0x18,%esp
	return ;
  801be0:	90                   	nop
}
  801be1:	c9                   	leave  
  801be2:	c3                   	ret    

00801be3 <rsttst>:
void rsttst()
{
  801be3:	55                   	push   %ebp
  801be4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 28                	push   $0x28
  801bf2:	e8 42 fb ff ff       	call   801739 <syscall>
  801bf7:	83 c4 18             	add    $0x18,%esp
	return ;
  801bfa:	90                   	nop
}
  801bfb:	c9                   	leave  
  801bfc:	c3                   	ret    

00801bfd <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801bfd:	55                   	push   %ebp
  801bfe:	89 e5                	mov    %esp,%ebp
  801c00:	83 ec 04             	sub    $0x4,%esp
  801c03:	8b 45 14             	mov    0x14(%ebp),%eax
  801c06:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c09:	8b 55 18             	mov    0x18(%ebp),%edx
  801c0c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c10:	52                   	push   %edx
  801c11:	50                   	push   %eax
  801c12:	ff 75 10             	pushl  0x10(%ebp)
  801c15:	ff 75 0c             	pushl  0xc(%ebp)
  801c18:	ff 75 08             	pushl  0x8(%ebp)
  801c1b:	6a 27                	push   $0x27
  801c1d:	e8 17 fb ff ff       	call   801739 <syscall>
  801c22:	83 c4 18             	add    $0x18,%esp
	return ;
  801c25:	90                   	nop
}
  801c26:	c9                   	leave  
  801c27:	c3                   	ret    

00801c28 <chktst>:
void chktst(uint32 n)
{
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	ff 75 08             	pushl  0x8(%ebp)
  801c36:	6a 29                	push   $0x29
  801c38:	e8 fc fa ff ff       	call   801739 <syscall>
  801c3d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c40:	90                   	nop
}
  801c41:	c9                   	leave  
  801c42:	c3                   	ret    

00801c43 <inctst>:

void inctst()
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 2a                	push   $0x2a
  801c52:	e8 e2 fa ff ff       	call   801739 <syscall>
  801c57:	83 c4 18             	add    $0x18,%esp
	return ;
  801c5a:	90                   	nop
}
  801c5b:	c9                   	leave  
  801c5c:	c3                   	ret    

00801c5d <gettst>:
uint32 gettst()
{
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 2b                	push   $0x2b
  801c6c:	e8 c8 fa ff ff       	call   801739 <syscall>
  801c71:	83 c4 18             	add    $0x18,%esp
}
  801c74:	c9                   	leave  
  801c75:	c3                   	ret    

00801c76 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
  801c79:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	6a 2c                	push   $0x2c
  801c88:	e8 ac fa ff ff       	call   801739 <syscall>
  801c8d:	83 c4 18             	add    $0x18,%esp
  801c90:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c93:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c97:	75 07                	jne    801ca0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c99:	b8 01 00 00 00       	mov    $0x1,%eax
  801c9e:	eb 05                	jmp    801ca5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ca0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ca5:	c9                   	leave  
  801ca6:	c3                   	ret    

00801ca7 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
  801caa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 2c                	push   $0x2c
  801cb9:	e8 7b fa ff ff       	call   801739 <syscall>
  801cbe:	83 c4 18             	add    $0x18,%esp
  801cc1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801cc4:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801cc8:	75 07                	jne    801cd1 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801cca:	b8 01 00 00 00       	mov    $0x1,%eax
  801ccf:	eb 05                	jmp    801cd6 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801cd1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cd6:	c9                   	leave  
  801cd7:	c3                   	ret    

00801cd8 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801cd8:	55                   	push   %ebp
  801cd9:	89 e5                	mov    %esp,%ebp
  801cdb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 2c                	push   $0x2c
  801cea:	e8 4a fa ff ff       	call   801739 <syscall>
  801cef:	83 c4 18             	add    $0x18,%esp
  801cf2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801cf5:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801cf9:	75 07                	jne    801d02 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801cfb:	b8 01 00 00 00       	mov    $0x1,%eax
  801d00:	eb 05                	jmp    801d07 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d02:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d07:	c9                   	leave  
  801d08:	c3                   	ret    

00801d09 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d09:	55                   	push   %ebp
  801d0a:	89 e5                	mov    %esp,%ebp
  801d0c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 2c                	push   $0x2c
  801d1b:	e8 19 fa ff ff       	call   801739 <syscall>
  801d20:	83 c4 18             	add    $0x18,%esp
  801d23:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d26:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d2a:	75 07                	jne    801d33 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d2c:	b8 01 00 00 00       	mov    $0x1,%eax
  801d31:	eb 05                	jmp    801d38 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d38:	c9                   	leave  
  801d39:	c3                   	ret    

00801d3a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d3a:	55                   	push   %ebp
  801d3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	ff 75 08             	pushl  0x8(%ebp)
  801d48:	6a 2d                	push   $0x2d
  801d4a:	e8 ea f9 ff ff       	call   801739 <syscall>
  801d4f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d52:	90                   	nop
}
  801d53:	c9                   	leave  
  801d54:	c3                   	ret    

00801d55 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d55:	55                   	push   %ebp
  801d56:	89 e5                	mov    %esp,%ebp
  801d58:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d59:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d5c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d62:	8b 45 08             	mov    0x8(%ebp),%eax
  801d65:	6a 00                	push   $0x0
  801d67:	53                   	push   %ebx
  801d68:	51                   	push   %ecx
  801d69:	52                   	push   %edx
  801d6a:	50                   	push   %eax
  801d6b:	6a 2e                	push   $0x2e
  801d6d:	e8 c7 f9 ff ff       	call   801739 <syscall>
  801d72:	83 c4 18             	add    $0x18,%esp
}
  801d75:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d78:	c9                   	leave  
  801d79:	c3                   	ret    

00801d7a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d80:	8b 45 08             	mov    0x8(%ebp),%eax
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	52                   	push   %edx
  801d8a:	50                   	push   %eax
  801d8b:	6a 2f                	push   $0x2f
  801d8d:	e8 a7 f9 ff ff       	call   801739 <syscall>
  801d92:	83 c4 18             	add    $0x18,%esp
}
  801d95:	c9                   	leave  
  801d96:	c3                   	ret    
  801d97:	90                   	nop

00801d98 <__udivdi3>:
  801d98:	55                   	push   %ebp
  801d99:	57                   	push   %edi
  801d9a:	56                   	push   %esi
  801d9b:	53                   	push   %ebx
  801d9c:	83 ec 1c             	sub    $0x1c,%esp
  801d9f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801da3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801da7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801dab:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801daf:	89 ca                	mov    %ecx,%edx
  801db1:	89 f8                	mov    %edi,%eax
  801db3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801db7:	85 f6                	test   %esi,%esi
  801db9:	75 2d                	jne    801de8 <__udivdi3+0x50>
  801dbb:	39 cf                	cmp    %ecx,%edi
  801dbd:	77 65                	ja     801e24 <__udivdi3+0x8c>
  801dbf:	89 fd                	mov    %edi,%ebp
  801dc1:	85 ff                	test   %edi,%edi
  801dc3:	75 0b                	jne    801dd0 <__udivdi3+0x38>
  801dc5:	b8 01 00 00 00       	mov    $0x1,%eax
  801dca:	31 d2                	xor    %edx,%edx
  801dcc:	f7 f7                	div    %edi
  801dce:	89 c5                	mov    %eax,%ebp
  801dd0:	31 d2                	xor    %edx,%edx
  801dd2:	89 c8                	mov    %ecx,%eax
  801dd4:	f7 f5                	div    %ebp
  801dd6:	89 c1                	mov    %eax,%ecx
  801dd8:	89 d8                	mov    %ebx,%eax
  801dda:	f7 f5                	div    %ebp
  801ddc:	89 cf                	mov    %ecx,%edi
  801dde:	89 fa                	mov    %edi,%edx
  801de0:	83 c4 1c             	add    $0x1c,%esp
  801de3:	5b                   	pop    %ebx
  801de4:	5e                   	pop    %esi
  801de5:	5f                   	pop    %edi
  801de6:	5d                   	pop    %ebp
  801de7:	c3                   	ret    
  801de8:	39 ce                	cmp    %ecx,%esi
  801dea:	77 28                	ja     801e14 <__udivdi3+0x7c>
  801dec:	0f bd fe             	bsr    %esi,%edi
  801def:	83 f7 1f             	xor    $0x1f,%edi
  801df2:	75 40                	jne    801e34 <__udivdi3+0x9c>
  801df4:	39 ce                	cmp    %ecx,%esi
  801df6:	72 0a                	jb     801e02 <__udivdi3+0x6a>
  801df8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801dfc:	0f 87 9e 00 00 00    	ja     801ea0 <__udivdi3+0x108>
  801e02:	b8 01 00 00 00       	mov    $0x1,%eax
  801e07:	89 fa                	mov    %edi,%edx
  801e09:	83 c4 1c             	add    $0x1c,%esp
  801e0c:	5b                   	pop    %ebx
  801e0d:	5e                   	pop    %esi
  801e0e:	5f                   	pop    %edi
  801e0f:	5d                   	pop    %ebp
  801e10:	c3                   	ret    
  801e11:	8d 76 00             	lea    0x0(%esi),%esi
  801e14:	31 ff                	xor    %edi,%edi
  801e16:	31 c0                	xor    %eax,%eax
  801e18:	89 fa                	mov    %edi,%edx
  801e1a:	83 c4 1c             	add    $0x1c,%esp
  801e1d:	5b                   	pop    %ebx
  801e1e:	5e                   	pop    %esi
  801e1f:	5f                   	pop    %edi
  801e20:	5d                   	pop    %ebp
  801e21:	c3                   	ret    
  801e22:	66 90                	xchg   %ax,%ax
  801e24:	89 d8                	mov    %ebx,%eax
  801e26:	f7 f7                	div    %edi
  801e28:	31 ff                	xor    %edi,%edi
  801e2a:	89 fa                	mov    %edi,%edx
  801e2c:	83 c4 1c             	add    $0x1c,%esp
  801e2f:	5b                   	pop    %ebx
  801e30:	5e                   	pop    %esi
  801e31:	5f                   	pop    %edi
  801e32:	5d                   	pop    %ebp
  801e33:	c3                   	ret    
  801e34:	bd 20 00 00 00       	mov    $0x20,%ebp
  801e39:	89 eb                	mov    %ebp,%ebx
  801e3b:	29 fb                	sub    %edi,%ebx
  801e3d:	89 f9                	mov    %edi,%ecx
  801e3f:	d3 e6                	shl    %cl,%esi
  801e41:	89 c5                	mov    %eax,%ebp
  801e43:	88 d9                	mov    %bl,%cl
  801e45:	d3 ed                	shr    %cl,%ebp
  801e47:	89 e9                	mov    %ebp,%ecx
  801e49:	09 f1                	or     %esi,%ecx
  801e4b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801e4f:	89 f9                	mov    %edi,%ecx
  801e51:	d3 e0                	shl    %cl,%eax
  801e53:	89 c5                	mov    %eax,%ebp
  801e55:	89 d6                	mov    %edx,%esi
  801e57:	88 d9                	mov    %bl,%cl
  801e59:	d3 ee                	shr    %cl,%esi
  801e5b:	89 f9                	mov    %edi,%ecx
  801e5d:	d3 e2                	shl    %cl,%edx
  801e5f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e63:	88 d9                	mov    %bl,%cl
  801e65:	d3 e8                	shr    %cl,%eax
  801e67:	09 c2                	or     %eax,%edx
  801e69:	89 d0                	mov    %edx,%eax
  801e6b:	89 f2                	mov    %esi,%edx
  801e6d:	f7 74 24 0c          	divl   0xc(%esp)
  801e71:	89 d6                	mov    %edx,%esi
  801e73:	89 c3                	mov    %eax,%ebx
  801e75:	f7 e5                	mul    %ebp
  801e77:	39 d6                	cmp    %edx,%esi
  801e79:	72 19                	jb     801e94 <__udivdi3+0xfc>
  801e7b:	74 0b                	je     801e88 <__udivdi3+0xf0>
  801e7d:	89 d8                	mov    %ebx,%eax
  801e7f:	31 ff                	xor    %edi,%edi
  801e81:	e9 58 ff ff ff       	jmp    801dde <__udivdi3+0x46>
  801e86:	66 90                	xchg   %ax,%ax
  801e88:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e8c:	89 f9                	mov    %edi,%ecx
  801e8e:	d3 e2                	shl    %cl,%edx
  801e90:	39 c2                	cmp    %eax,%edx
  801e92:	73 e9                	jae    801e7d <__udivdi3+0xe5>
  801e94:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801e97:	31 ff                	xor    %edi,%edi
  801e99:	e9 40 ff ff ff       	jmp    801dde <__udivdi3+0x46>
  801e9e:	66 90                	xchg   %ax,%ax
  801ea0:	31 c0                	xor    %eax,%eax
  801ea2:	e9 37 ff ff ff       	jmp    801dde <__udivdi3+0x46>
  801ea7:	90                   	nop

00801ea8 <__umoddi3>:
  801ea8:	55                   	push   %ebp
  801ea9:	57                   	push   %edi
  801eaa:	56                   	push   %esi
  801eab:	53                   	push   %ebx
  801eac:	83 ec 1c             	sub    $0x1c,%esp
  801eaf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801eb3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801eb7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ebb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801ebf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ec3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ec7:	89 f3                	mov    %esi,%ebx
  801ec9:	89 fa                	mov    %edi,%edx
  801ecb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ecf:	89 34 24             	mov    %esi,(%esp)
  801ed2:	85 c0                	test   %eax,%eax
  801ed4:	75 1a                	jne    801ef0 <__umoddi3+0x48>
  801ed6:	39 f7                	cmp    %esi,%edi
  801ed8:	0f 86 a2 00 00 00    	jbe    801f80 <__umoddi3+0xd8>
  801ede:	89 c8                	mov    %ecx,%eax
  801ee0:	89 f2                	mov    %esi,%edx
  801ee2:	f7 f7                	div    %edi
  801ee4:	89 d0                	mov    %edx,%eax
  801ee6:	31 d2                	xor    %edx,%edx
  801ee8:	83 c4 1c             	add    $0x1c,%esp
  801eeb:	5b                   	pop    %ebx
  801eec:	5e                   	pop    %esi
  801eed:	5f                   	pop    %edi
  801eee:	5d                   	pop    %ebp
  801eef:	c3                   	ret    
  801ef0:	39 f0                	cmp    %esi,%eax
  801ef2:	0f 87 ac 00 00 00    	ja     801fa4 <__umoddi3+0xfc>
  801ef8:	0f bd e8             	bsr    %eax,%ebp
  801efb:	83 f5 1f             	xor    $0x1f,%ebp
  801efe:	0f 84 ac 00 00 00    	je     801fb0 <__umoddi3+0x108>
  801f04:	bf 20 00 00 00       	mov    $0x20,%edi
  801f09:	29 ef                	sub    %ebp,%edi
  801f0b:	89 fe                	mov    %edi,%esi
  801f0d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801f11:	89 e9                	mov    %ebp,%ecx
  801f13:	d3 e0                	shl    %cl,%eax
  801f15:	89 d7                	mov    %edx,%edi
  801f17:	89 f1                	mov    %esi,%ecx
  801f19:	d3 ef                	shr    %cl,%edi
  801f1b:	09 c7                	or     %eax,%edi
  801f1d:	89 e9                	mov    %ebp,%ecx
  801f1f:	d3 e2                	shl    %cl,%edx
  801f21:	89 14 24             	mov    %edx,(%esp)
  801f24:	89 d8                	mov    %ebx,%eax
  801f26:	d3 e0                	shl    %cl,%eax
  801f28:	89 c2                	mov    %eax,%edx
  801f2a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f2e:	d3 e0                	shl    %cl,%eax
  801f30:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f34:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f38:	89 f1                	mov    %esi,%ecx
  801f3a:	d3 e8                	shr    %cl,%eax
  801f3c:	09 d0                	or     %edx,%eax
  801f3e:	d3 eb                	shr    %cl,%ebx
  801f40:	89 da                	mov    %ebx,%edx
  801f42:	f7 f7                	div    %edi
  801f44:	89 d3                	mov    %edx,%ebx
  801f46:	f7 24 24             	mull   (%esp)
  801f49:	89 c6                	mov    %eax,%esi
  801f4b:	89 d1                	mov    %edx,%ecx
  801f4d:	39 d3                	cmp    %edx,%ebx
  801f4f:	0f 82 87 00 00 00    	jb     801fdc <__umoddi3+0x134>
  801f55:	0f 84 91 00 00 00    	je     801fec <__umoddi3+0x144>
  801f5b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801f5f:	29 f2                	sub    %esi,%edx
  801f61:	19 cb                	sbb    %ecx,%ebx
  801f63:	89 d8                	mov    %ebx,%eax
  801f65:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801f69:	d3 e0                	shl    %cl,%eax
  801f6b:	89 e9                	mov    %ebp,%ecx
  801f6d:	d3 ea                	shr    %cl,%edx
  801f6f:	09 d0                	or     %edx,%eax
  801f71:	89 e9                	mov    %ebp,%ecx
  801f73:	d3 eb                	shr    %cl,%ebx
  801f75:	89 da                	mov    %ebx,%edx
  801f77:	83 c4 1c             	add    $0x1c,%esp
  801f7a:	5b                   	pop    %ebx
  801f7b:	5e                   	pop    %esi
  801f7c:	5f                   	pop    %edi
  801f7d:	5d                   	pop    %ebp
  801f7e:	c3                   	ret    
  801f7f:	90                   	nop
  801f80:	89 fd                	mov    %edi,%ebp
  801f82:	85 ff                	test   %edi,%edi
  801f84:	75 0b                	jne    801f91 <__umoddi3+0xe9>
  801f86:	b8 01 00 00 00       	mov    $0x1,%eax
  801f8b:	31 d2                	xor    %edx,%edx
  801f8d:	f7 f7                	div    %edi
  801f8f:	89 c5                	mov    %eax,%ebp
  801f91:	89 f0                	mov    %esi,%eax
  801f93:	31 d2                	xor    %edx,%edx
  801f95:	f7 f5                	div    %ebp
  801f97:	89 c8                	mov    %ecx,%eax
  801f99:	f7 f5                	div    %ebp
  801f9b:	89 d0                	mov    %edx,%eax
  801f9d:	e9 44 ff ff ff       	jmp    801ee6 <__umoddi3+0x3e>
  801fa2:	66 90                	xchg   %ax,%ax
  801fa4:	89 c8                	mov    %ecx,%eax
  801fa6:	89 f2                	mov    %esi,%edx
  801fa8:	83 c4 1c             	add    $0x1c,%esp
  801fab:	5b                   	pop    %ebx
  801fac:	5e                   	pop    %esi
  801fad:	5f                   	pop    %edi
  801fae:	5d                   	pop    %ebp
  801faf:	c3                   	ret    
  801fb0:	3b 04 24             	cmp    (%esp),%eax
  801fb3:	72 06                	jb     801fbb <__umoddi3+0x113>
  801fb5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801fb9:	77 0f                	ja     801fca <__umoddi3+0x122>
  801fbb:	89 f2                	mov    %esi,%edx
  801fbd:	29 f9                	sub    %edi,%ecx
  801fbf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801fc3:	89 14 24             	mov    %edx,(%esp)
  801fc6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801fca:	8b 44 24 04          	mov    0x4(%esp),%eax
  801fce:	8b 14 24             	mov    (%esp),%edx
  801fd1:	83 c4 1c             	add    $0x1c,%esp
  801fd4:	5b                   	pop    %ebx
  801fd5:	5e                   	pop    %esi
  801fd6:	5f                   	pop    %edi
  801fd7:	5d                   	pop    %ebp
  801fd8:	c3                   	ret    
  801fd9:	8d 76 00             	lea    0x0(%esi),%esi
  801fdc:	2b 04 24             	sub    (%esp),%eax
  801fdf:	19 fa                	sbb    %edi,%edx
  801fe1:	89 d1                	mov    %edx,%ecx
  801fe3:	89 c6                	mov    %eax,%esi
  801fe5:	e9 71 ff ff ff       	jmp    801f5b <__umoddi3+0xb3>
  801fea:	66 90                	xchg   %ax,%ax
  801fec:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801ff0:	72 ea                	jb     801fdc <__umoddi3+0x134>
  801ff2:	89 d9                	mov    %ebx,%ecx
  801ff4:	e9 62 ff ff ff       	jmp    801f5b <__umoddi3+0xb3>
