
obj/user/tst_buffer_2_slave:     file format elf32-i386


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
  800031:	e8 7e 06 00 00       	call   8006b4 <libmain>
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
  80003b:	83 ec 68             	sub    $0x68,%esp



	//("STEP 0: checking Initial WS entries ...\n");
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=   0x200000)  	panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  80003e:	a1 20 30 80 00       	mov    0x803020,%eax
  800043:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800049:	8b 00                	mov    (%eax),%eax
  80004b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80004e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800051:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800056:	3d 00 00 20 00       	cmp    $0x200000,%eax
  80005b:	74 14                	je     800071 <_main+0x39>
  80005d:	83 ec 04             	sub    $0x4,%esp
  800060:	68 c0 21 80 00       	push   $0x8021c0
  800065:	6a 17                	push   $0x17
  800067:	68 08 22 80 00       	push   $0x802208
  80006c:	e8 7f 07 00 00       	call   8007f0 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=   0x201000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  800071:	a1 20 30 80 00       	mov    0x803020,%eax
  800076:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80007c:	83 c0 18             	add    $0x18,%eax
  80007f:	8b 00                	mov    (%eax),%eax
  800081:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800084:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800087:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80008c:	3d 00 10 20 00       	cmp    $0x201000,%eax
  800091:	74 14                	je     8000a7 <_main+0x6f>
  800093:	83 ec 04             	sub    $0x4,%esp
  800096:	68 c0 21 80 00       	push   $0x8021c0
  80009b:	6a 18                	push   $0x18
  80009d:	68 08 22 80 00       	push   $0x802208
  8000a2:	e8 49 07 00 00       	call   8007f0 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=   0x202000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  8000a7:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ac:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8000b2:	83 c0 30             	add    $0x30,%eax
  8000b5:	8b 00                	mov    (%eax),%eax
  8000b7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8000ba:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8000bd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000c2:	3d 00 20 20 00       	cmp    $0x202000,%eax
  8000c7:	74 14                	je     8000dd <_main+0xa5>
  8000c9:	83 ec 04             	sub    $0x4,%esp
  8000cc:	68 c0 21 80 00       	push   $0x8021c0
  8000d1:	6a 19                	push   $0x19
  8000d3:	68 08 22 80 00       	push   $0x802208
  8000d8:	e8 13 07 00 00       	call   8007f0 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=   0x203000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  8000dd:	a1 20 30 80 00       	mov    0x803020,%eax
  8000e2:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8000e8:	83 c0 48             	add    $0x48,%eax
  8000eb:	8b 00                	mov    (%eax),%eax
  8000ed:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8000f0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000f3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000f8:	3d 00 30 20 00       	cmp    $0x203000,%eax
  8000fd:	74 14                	je     800113 <_main+0xdb>
  8000ff:	83 ec 04             	sub    $0x4,%esp
  800102:	68 c0 21 80 00       	push   $0x8021c0
  800107:	6a 1a                	push   $0x1a
  800109:	68 08 22 80 00       	push   $0x802208
  80010e:	e8 dd 06 00 00       	call   8007f0 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=   0x204000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  800113:	a1 20 30 80 00       	mov    0x803020,%eax
  800118:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80011e:	83 c0 60             	add    $0x60,%eax
  800121:	8b 00                	mov    (%eax),%eax
  800123:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800126:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800129:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80012e:	3d 00 40 20 00       	cmp    $0x204000,%eax
  800133:	74 14                	je     800149 <_main+0x111>
  800135:	83 ec 04             	sub    $0x4,%esp
  800138:	68 c0 21 80 00       	push   $0x8021c0
  80013d:	6a 1b                	push   $0x1b
  80013f:	68 08 22 80 00       	push   $0x802208
  800144:	e8 a7 06 00 00       	call   8007f0 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=   0x205000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  800149:	a1 20 30 80 00       	mov    0x803020,%eax
  80014e:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800154:	83 c0 78             	add    $0x78,%eax
  800157:	8b 00                	mov    (%eax),%eax
  800159:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80015c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80015f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800164:	3d 00 50 20 00       	cmp    $0x205000,%eax
  800169:	74 14                	je     80017f <_main+0x147>
  80016b:	83 ec 04             	sub    $0x4,%esp
  80016e:	68 c0 21 80 00       	push   $0x8021c0
  800173:	6a 1c                	push   $0x1c
  800175:	68 08 22 80 00       	push   $0x802208
  80017a:	e8 71 06 00 00       	call   8007f0 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=   0x800000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  80017f:	a1 20 30 80 00       	mov    0x803020,%eax
  800184:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80018a:	05 90 00 00 00       	add    $0x90,%eax
  80018f:	8b 00                	mov    (%eax),%eax
  800191:	89 45 c0             	mov    %eax,-0x40(%ebp)
  800194:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800197:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80019c:	3d 00 00 80 00       	cmp    $0x800000,%eax
  8001a1:	74 14                	je     8001b7 <_main+0x17f>
  8001a3:	83 ec 04             	sub    $0x4,%esp
  8001a6:	68 c0 21 80 00       	push   $0x8021c0
  8001ab:	6a 1d                	push   $0x1d
  8001ad:	68 08 22 80 00       	push   $0x802208
  8001b2:	e8 39 06 00 00       	call   8007f0 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x801000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  8001b7:	a1 20 30 80 00       	mov    0x803020,%eax
  8001bc:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8001c2:	05 a8 00 00 00       	add    $0xa8,%eax
  8001c7:	8b 00                	mov    (%eax),%eax
  8001c9:	89 45 bc             	mov    %eax,-0x44(%ebp)
  8001cc:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8001cf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001d4:	3d 00 10 80 00       	cmp    $0x801000,%eax
  8001d9:	74 14                	je     8001ef <_main+0x1b7>
  8001db:	83 ec 04             	sub    $0x4,%esp
  8001de:	68 c0 21 80 00       	push   $0x8021c0
  8001e3:	6a 1e                	push   $0x1e
  8001e5:	68 08 22 80 00       	push   $0x802208
  8001ea:	e8 01 06 00 00       	call   8007f0 <_panic>
		//if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x802000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=   0x802000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  8001ef:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f4:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8001fa:	05 c0 00 00 00       	add    $0xc0,%eax
  8001ff:	8b 00                	mov    (%eax),%eax
  800201:	89 45 b8             	mov    %eax,-0x48(%ebp)
  800204:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800207:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80020c:	3d 00 20 80 00       	cmp    $0x802000,%eax
  800211:	74 14                	je     800227 <_main+0x1ef>
  800213:	83 ec 04             	sub    $0x4,%esp
  800216:	68 c0 21 80 00       	push   $0x8021c0
  80021b:	6a 20                	push   $0x20
  80021d:	68 08 22 80 00       	push   $0x802208
  800222:	e8 c9 05 00 00       	call   8007f0 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0x803000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  800227:	a1 20 30 80 00       	mov    0x803020,%eax
  80022c:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800232:	05 d8 00 00 00       	add    $0xd8,%eax
  800237:	8b 00                	mov    (%eax),%eax
  800239:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80023c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80023f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800244:	3d 00 30 80 00       	cmp    $0x803000,%eax
  800249:	74 14                	je     80025f <_main+0x227>
  80024b:	83 ec 04             	sub    $0x4,%esp
  80024e:	68 c0 21 80 00       	push   $0x8021c0
  800253:	6a 21                	push   $0x21
  800255:	68 08 22 80 00       	push   $0x802208
  80025a:	e8 91 05 00 00       	call   8007f0 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[10].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  80025f:	a1 20 30 80 00       	mov    0x803020,%eax
  800264:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80026a:	05 f0 00 00 00       	add    $0xf0,%eax
  80026f:	8b 00                	mov    (%eax),%eax
  800271:	89 45 b0             	mov    %eax,-0x50(%ebp)
  800274:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800277:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80027c:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  800281:	74 14                	je     800297 <_main+0x25f>
  800283:	83 ec 04             	sub    $0x4,%esp
  800286:	68 c0 21 80 00       	push   $0x8021c0
  80028b:	6a 22                	push   $0x22
  80028d:	68 08 22 80 00       	push   $0x802208
  800292:	e8 59 05 00 00       	call   8007f0 <_panic>
		if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review sizes of the two WS's..!!");
  800297:	a1 20 30 80 00       	mov    0x803020,%eax
  80029c:	8b 80 2c 05 00 00    	mov    0x52c(%eax),%eax
  8002a2:	85 c0                	test   %eax,%eax
  8002a4:	74 14                	je     8002ba <_main+0x282>
  8002a6:	83 ec 04             	sub    $0x4,%esp
  8002a9:	68 24 22 80 00       	push   $0x802224
  8002ae:	6a 23                	push   $0x23
  8002b0:	68 08 22 80 00       	push   $0x802208
  8002b5:	e8 36 05 00 00       	call   8007f0 <_panic>
	}

	int initModBufCnt = sys_calculate_modified_frames();
  8002ba:	e8 74 16 00 00       	call   801933 <sys_calculate_modified_frames>
  8002bf:	89 45 ac             	mov    %eax,-0x54(%ebp)
	int initFreeBufCnt = sys_calculate_notmod_frames();
  8002c2:	e8 85 16 00 00       	call   80194c <sys_calculate_notmod_frames>
  8002c7:	89 45 a8             	mov    %eax,-0x58(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  8002ca:	e8 eb 16 00 00       	call   8019ba <sys_pf_calculate_allocated_pages>
  8002cf:	89 45 a4             	mov    %eax,-0x5c(%ebp)

	//[1]Bring 7 pages and modify them (7 unmodified will be buffered)
	int i=0;
  8002d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int dstSum1 = 0;
  8002d9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
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
		dummy += sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  800303:	e8 44 16 00 00       	call   80194c <sys_calculate_notmod_frames>
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
	int dummy = 0;
	for(i=(PAGE_SIZE/4);i<arrSize;i+=PAGE_SIZE/4)
  80031c:	81 45 f4 00 04 00 00 	addl   $0x400,-0xc(%ebp)
  800323:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  80032a:	7e c4                	jle    8002f0 <_main+0x2b8>
		dummy += sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
	}



	if (sys_calculate_notmod_frames()  - initFreeBufCnt != 7)  panic("Error in BUFFERING/RESTORING of free frames... WRONG number of buffered pages in FREE frame list");
  80032c:	e8 1b 16 00 00       	call   80194c <sys_calculate_notmod_frames>
  800331:	89 c2                	mov    %eax,%edx
  800333:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800336:	29 c2                	sub    %eax,%edx
  800338:	89 d0                	mov    %edx,%eax
  80033a:	83 f8 07             	cmp    $0x7,%eax
  80033d:	74 14                	je     800353 <_main+0x31b>
  80033f:	83 ec 04             	sub    $0x4,%esp
  800342:	68 74 22 80 00       	push   $0x802274
  800347:	6a 37                	push   $0x37
  800349:	68 08 22 80 00       	push   $0x802208
  80034e:	e8 9d 04 00 00       	call   8007f0 <_panic>
	if (sys_calculate_modified_frames() - initModBufCnt  != 0)  panic("Error in BUFFERING/RESTORING of modified frames... WRONG number of buffered pages in MODIFIED frame list");
  800353:	e8 db 15 00 00       	call   801933 <sys_calculate_modified_frames>
  800358:	89 c2                	mov    %eax,%edx
  80035a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80035d:	39 c2                	cmp    %eax,%edx
  80035f:	74 14                	je     800375 <_main+0x33d>
  800361:	83 ec 04             	sub    $0x4,%esp
  800364:	68 d8 22 80 00       	push   $0x8022d8
  800369:	6a 38                	push   $0x38
  80036b:	68 08 22 80 00       	push   $0x802208
  800370:	e8 7b 04 00 00       	call   8007f0 <_panic>

	initFreeBufCnt = sys_calculate_notmod_frames();
  800375:	e8 d2 15 00 00       	call   80194c <sys_calculate_notmod_frames>
  80037a:	89 45 a8             	mov    %eax,-0x58(%ebp)
	initModBufCnt = sys_calculate_modified_frames();
  80037d:	e8 b1 15 00 00       	call   801933 <sys_calculate_modified_frames>
  800382:	89 45 ac             	mov    %eax,-0x54(%ebp)

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
		dummy += sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  8003a2:	e8 a5 15 00 00       	call   80194c <sys_calculate_notmod_frames>
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
		dummy += sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
	}

	//cprintf("sys_calculate_notmod_frames()  - initFreeBufCnt = %d\n", sys_calculate_notmod_frames()  - initFreeBufCnt);
	if (sys_calculate_notmod_frames()  - initFreeBufCnt != 0)  panic("Error in BUFFERING/RESTORING of free frames... WRONG number of buffered pages in FREE frame list");
  8003cb:	e8 7c 15 00 00       	call   80194c <sys_calculate_notmod_frames>
  8003d0:	89 c2                	mov    %eax,%edx
  8003d2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003d5:	39 c2                	cmp    %eax,%edx
  8003d7:	74 14                	je     8003ed <_main+0x3b5>
  8003d9:	83 ec 04             	sub    $0x4,%esp
  8003dc:	68 74 22 80 00       	push   $0x802274
  8003e1:	6a 47                	push   $0x47
  8003e3:	68 08 22 80 00       	push   $0x802208
  8003e8:	e8 03 04 00 00       	call   8007f0 <_panic>
	if (sys_calculate_modified_frames() - initModBufCnt  != 7)  panic("Error in BUFFERING/RESTORING of modified frames... WRONG number of buffered pages in MODIFIED frame list");
  8003ed:	e8 41 15 00 00       	call   801933 <sys_calculate_modified_frames>
  8003f2:	89 c2                	mov    %eax,%edx
  8003f4:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8003f7:	29 c2                	sub    %eax,%edx
  8003f9:	89 d0                	mov    %edx,%eax
  8003fb:	83 f8 07             	cmp    $0x7,%eax
  8003fe:	74 14                	je     800414 <_main+0x3dc>
  800400:	83 ec 04             	sub    $0x4,%esp
  800403:	68 d8 22 80 00       	push   $0x8022d8
  800408:	6a 48                	push   $0x48
  80040a:	68 08 22 80 00       	push   $0x802208
  80040f:	e8 dc 03 00 00       	call   8007f0 <_panic>
	initFreeBufCnt = sys_calculate_notmod_frames();
  800414:	e8 33 15 00 00       	call   80194c <sys_calculate_notmod_frames>
  800419:	89 45 a8             	mov    %eax,-0x58(%ebp)
	initModBufCnt = sys_calculate_modified_frames();
  80041c:	e8 12 15 00 00       	call   801933 <sys_calculate_modified_frames>
  800421:	89 45 ac             	mov    %eax,-0x54(%ebp)

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
		dummy += sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  800448:	e8 ff 14 00 00       	call   80194c <sys_calculate_notmod_frames>
  80044d:	89 c2                	mov    %eax,%edx
  80044f:	a1 20 30 80 00       	mov    0x803020,%eax
  800454:	8b 40 4c             	mov    0x4c(%eax),%eax
  800457:	01 c2                	add    %eax,%edx
  800459:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80045c:	01 d0                	add    %edx,%eax
  80045e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	//[3]Bring the 7 modified pages again and ensure their values are correct (7 unmodified will be buffered)

	i = 0;
	int dstSum2 = 0 ;
	for(i=PAGE_SIZE/4;i<arrSize;i+=PAGE_SIZE/4)
  800461:	81 45 f4 00 04 00 00 	addl   $0x400,-0xc(%ebp)
  800468:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  80046f:	7e ca                	jle    80043b <_main+0x403>
	{
		dstSum2 += dst[i];
		dummy += sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
	}

	if (sys_calculate_notmod_frames()  - initFreeBufCnt != 7)  panic("Error in BUFFERING/RESTORING of free frames... WRONG number of buffered pages in FREE frame list");
  800471:	e8 d6 14 00 00       	call   80194c <sys_calculate_notmod_frames>
  800476:	89 c2                	mov    %eax,%edx
  800478:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80047b:	29 c2                	sub    %eax,%edx
  80047d:	89 d0                	mov    %edx,%eax
  80047f:	83 f8 07             	cmp    $0x7,%eax
  800482:	74 14                	je     800498 <_main+0x460>
  800484:	83 ec 04             	sub    $0x4,%esp
  800487:	68 74 22 80 00       	push   $0x802274
  80048c:	6a 56                	push   $0x56
  80048e:	68 08 22 80 00       	push   $0x802208
  800493:	e8 58 03 00 00       	call   8007f0 <_panic>
	if (sys_calculate_modified_frames() - initModBufCnt  != -7)  panic("Error in BUFFERING/RESTORING of modified frames... WRONG number of buffered pages in MODIFIED frame list");
  800498:	e8 96 14 00 00       	call   801933 <sys_calculate_modified_frames>
  80049d:	89 c2                	mov    %eax,%edx
  80049f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8004a2:	29 c2                	sub    %eax,%edx
  8004a4:	89 d0                	mov    %edx,%eax
  8004a6:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8004a9:	74 14                	je     8004bf <_main+0x487>
  8004ab:	83 ec 04             	sub    $0x4,%esp
  8004ae:	68 d8 22 80 00       	push   $0x8022d8
  8004b3:	6a 57                	push   $0x57
  8004b5:	68 08 22 80 00       	push   $0x802208
  8004ba:	e8 31 03 00 00       	call   8007f0 <_panic>

	initFreeBufCnt = sys_calculate_notmod_frames();
  8004bf:	e8 88 14 00 00       	call   80194c <sys_calculate_notmod_frames>
  8004c4:	89 45 a8             	mov    %eax,-0x58(%ebp)
	initModBufCnt = sys_calculate_modified_frames();
  8004c7:	e8 67 14 00 00       	call   801933 <sys_calculate_modified_frames>
  8004cc:	89 45 ac             	mov    %eax,-0x54(%ebp)

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
		dummy += sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  8004f3:	e8 54 14 00 00       	call   80194c <sys_calculate_notmod_frames>
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
		dummy += sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
	}

	if (sys_calculate_notmod_frames()  - initFreeBufCnt != -7)  panic("Error in BUFFERING/RESTORING of free frames... WRONG number of buffered pages in FREE frame list");
  80051c:	e8 2b 14 00 00       	call   80194c <sys_calculate_notmod_frames>
  800521:	89 c2                	mov    %eax,%edx
  800523:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800526:	29 c2                	sub    %eax,%edx
  800528:	89 d0                	mov    %edx,%eax
  80052a:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80052d:	74 14                	je     800543 <_main+0x50b>
  80052f:	83 ec 04             	sub    $0x4,%esp
  800532:	68 74 22 80 00       	push   $0x802274
  800537:	6a 65                	push   $0x65
  800539:	68 08 22 80 00       	push   $0x802208
  80053e:	e8 ad 02 00 00       	call   8007f0 <_panic>
	if (sys_calculate_modified_frames() - initModBufCnt  != 7)  panic("Error in BUFFERING/RESTORING of modified frames... WRONG number of buffered pages in MODIFIED frame list");
  800543:	e8 eb 13 00 00       	call   801933 <sys_calculate_modified_frames>
  800548:	89 c2                	mov    %eax,%edx
  80054a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80054d:	29 c2                	sub    %eax,%edx
  80054f:	89 d0                	mov    %edx,%eax
  800551:	83 f8 07             	cmp    $0x7,%eax
  800554:	74 14                	je     80056a <_main+0x532>
  800556:	83 ec 04             	sub    $0x4,%esp
  800559:	68 d8 22 80 00       	push   $0x8022d8
  80055e:	6a 66                	push   $0x66
  800560:	68 08 22 80 00       	push   $0x802208
  800565:	e8 86 02 00 00       	call   8007f0 <_panic>

	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Unexpected extra/less pages have been added to page file.. NOT Expected to add any new page to the page file");
  80056a:	e8 4b 14 00 00       	call   8019ba <sys_pf_calculate_allocated_pages>
  80056f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  800572:	74 14                	je     800588 <_main+0x550>
  800574:	83 ec 04             	sub    $0x4,%esp
  800577:	68 44 23 80 00       	push   $0x802344
  80057c:	6a 68                	push   $0x68
  80057e:	68 08 22 80 00       	push   $0x802208
  800583:	e8 68 02 00 00       	call   8007f0 <_panic>

	if (srcSum1 != srcSum2 || dstSum1 != dstSum2) 	panic("Error in buffering/restoring modified/not modified pages") ;
  800588:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80058b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80058e:	75 08                	jne    800598 <_main+0x560>
  800590:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800593:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800596:	74 14                	je     8005ac <_main+0x574>
  800598:	83 ec 04             	sub    $0x4,%esp
  80059b:	68 b4 23 80 00       	push   $0x8023b4
  8005a0:	6a 6a                	push   $0x6a
  8005a2:	68 08 22 80 00       	push   $0x802208
  8005a7:	e8 44 02 00 00       	call   8007f0 <_panic>

	/*[5] BUSY-WAIT FOR A WHILE TILL FINISHING THE MASTER PROGRAM */
	env_sleep(5000);
  8005ac:	83 ec 0c             	sub    $0xc,%esp
  8005af:	68 88 13 00 00       	push   $0x1388
  8005b4:	e8 d3 18 00 00       	call   801e8c <env_sleep>
  8005b9:	83 c4 10             	add    $0x10,%esp

	/*[6] Read the modified pages of this slave program (after they have been written on page file) */
	initFreeBufCnt = sys_calculate_notmod_frames();
  8005bc:	e8 8b 13 00 00       	call   80194c <sys_calculate_notmod_frames>
  8005c1:	89 45 a8             	mov    %eax,-0x58(%ebp)
	initModBufCnt = sys_calculate_modified_frames();
  8005c4:	e8 6a 13 00 00       	call   801933 <sys_calculate_modified_frames>
  8005c9:	89 45 ac             	mov    %eax,-0x54(%ebp)
	i = 0;
  8005cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int dstSum3 = 0 ;
  8005d3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	dummy = 0;
  8005da:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	for(i=0;i<arrSize;i+=PAGE_SIZE/4)
  8005e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8005e8:	eb 2d                	jmp    800617 <_main+0x5df>
	{
		dstSum3 += dst[i];
  8005ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005ed:	8b 04 85 20 31 80 00 	mov    0x803120(,%eax,4),%eax
  8005f4:	01 45 dc             	add    %eax,-0x24(%ebp)
		dummy += sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  8005f7:	e8 50 13 00 00       	call   80194c <sys_calculate_notmod_frames>
  8005fc:	89 c2                	mov    %eax,%edx
  8005fe:	a1 20 30 80 00       	mov    0x803020,%eax
  800603:	8b 40 4c             	mov    0x4c(%eax),%eax
  800606:	01 c2                	add    %eax,%edx
  800608:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80060b:	01 d0                	add    %edx,%eax
  80060d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	initFreeBufCnt = sys_calculate_notmod_frames();
	initModBufCnt = sys_calculate_modified_frames();
	i = 0;
	int dstSum3 = 0 ;
	dummy = 0;
	for(i=0;i<arrSize;i+=PAGE_SIZE/4)
  800610:	81 45 f4 00 04 00 00 	addl   $0x400,-0xc(%ebp)
  800617:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  80061e:	7e ca                	jle    8005ea <_main+0x5b2>
	{
		dstSum3 += dst[i];
		dummy += sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
	}

	if (sys_calculate_notmod_frames()  - initFreeBufCnt != 0)  panic("Error in BUFFERING/RESTORING of free frames... WRONG number of buffered pages in FREE frame list");
  800620:	e8 27 13 00 00       	call   80194c <sys_calculate_notmod_frames>
  800625:	89 c2                	mov    %eax,%edx
  800627:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80062a:	39 c2                	cmp    %eax,%edx
  80062c:	74 14                	je     800642 <_main+0x60a>
  80062e:	83 ec 04             	sub    $0x4,%esp
  800631:	68 74 22 80 00       	push   $0x802274
  800636:	6a 7b                	push   $0x7b
  800638:	68 08 22 80 00       	push   $0x802208
  80063d:	e8 ae 01 00 00       	call   8007f0 <_panic>
	if (sys_calculate_modified_frames() - initModBufCnt  != 0)  panic("Error in BUFFERING/RESTORING of modified frames... WRONG number of buffered pages in MODIFIED frame list");
  800642:	e8 ec 12 00 00       	call   801933 <sys_calculate_modified_frames>
  800647:	89 c2                	mov    %eax,%edx
  800649:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80064c:	39 c2                	cmp    %eax,%edx
  80064e:	74 14                	je     800664 <_main+0x62c>
  800650:	83 ec 04             	sub    $0x4,%esp
  800653:	68 d8 22 80 00       	push   $0x8022d8
  800658:	6a 7c                	push   $0x7c
  80065a:	68 08 22 80 00       	push   $0x802208
  80065f:	e8 8c 01 00 00       	call   8007f0 <_panic>

	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Unexpected extra/less pages have been added to page file.. NOT Expected to add any new page to the page file");
  800664:	e8 51 13 00 00       	call   8019ba <sys_pf_calculate_allocated_pages>
  800669:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80066c:	74 14                	je     800682 <_main+0x64a>
  80066e:	83 ec 04             	sub    $0x4,%esp
  800671:	68 44 23 80 00       	push   $0x802344
  800676:	6a 7e                	push   $0x7e
  800678:	68 08 22 80 00       	push   $0x802208
  80067d:	e8 6e 01 00 00       	call   8007f0 <_panic>

	if (dstSum1 != dstSum3) 	panic("Error in buffering/restoring modified pages after freeing the modified list") ;
  800682:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800685:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800688:	74 17                	je     8006a1 <_main+0x669>
  80068a:	83 ec 04             	sub    $0x4,%esp
  80068d:	68 f0 23 80 00       	push   $0x8023f0
  800692:	68 80 00 00 00       	push   $0x80
  800697:	68 08 22 80 00       	push   $0x802208
  80069c:	e8 4f 01 00 00       	call   8007f0 <_panic>

	cprintf("Congratulations!! modified list is cleared and updated successfully.\n");
  8006a1:	83 ec 0c             	sub    $0xc,%esp
  8006a4:	68 3c 24 80 00       	push   $0x80243c
  8006a9:	e8 f6 03 00 00       	call   800aa4 <cprintf>
  8006ae:	83 c4 10             	add    $0x10,%esp

	return;
  8006b1:	90                   	nop

}
  8006b2:	c9                   	leave  
  8006b3:	c3                   	ret    

008006b4 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8006b4:	55                   	push   %ebp
  8006b5:	89 e5                	mov    %esp,%ebp
  8006b7:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8006ba:	e8 3b 15 00 00       	call   801bfa <sys_getenvindex>
  8006bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8006c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006c5:	89 d0                	mov    %edx,%eax
  8006c7:	c1 e0 03             	shl    $0x3,%eax
  8006ca:	01 d0                	add    %edx,%eax
  8006cc:	01 c0                	add    %eax,%eax
  8006ce:	01 d0                	add    %edx,%eax
  8006d0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006d7:	01 d0                	add    %edx,%eax
  8006d9:	c1 e0 04             	shl    $0x4,%eax
  8006dc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8006e1:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8006e6:	a1 20 30 80 00       	mov    0x803020,%eax
  8006eb:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8006f1:	84 c0                	test   %al,%al
  8006f3:	74 0f                	je     800704 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8006f5:	a1 20 30 80 00       	mov    0x803020,%eax
  8006fa:	05 5c 05 00 00       	add    $0x55c,%eax
  8006ff:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800704:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800708:	7e 0a                	jle    800714 <libmain+0x60>
		binaryname = argv[0];
  80070a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80070d:	8b 00                	mov    (%eax),%eax
  80070f:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800714:	83 ec 08             	sub    $0x8,%esp
  800717:	ff 75 0c             	pushl  0xc(%ebp)
  80071a:	ff 75 08             	pushl  0x8(%ebp)
  80071d:	e8 16 f9 ff ff       	call   800038 <_main>
  800722:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800725:	e8 dd 12 00 00       	call   801a07 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80072a:	83 ec 0c             	sub    $0xc,%esp
  80072d:	68 9c 24 80 00       	push   $0x80249c
  800732:	e8 6d 03 00 00       	call   800aa4 <cprintf>
  800737:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80073a:	a1 20 30 80 00       	mov    0x803020,%eax
  80073f:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800745:	a1 20 30 80 00       	mov    0x803020,%eax
  80074a:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800750:	83 ec 04             	sub    $0x4,%esp
  800753:	52                   	push   %edx
  800754:	50                   	push   %eax
  800755:	68 c4 24 80 00       	push   $0x8024c4
  80075a:	e8 45 03 00 00       	call   800aa4 <cprintf>
  80075f:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800762:	a1 20 30 80 00       	mov    0x803020,%eax
  800767:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80076d:	a1 20 30 80 00       	mov    0x803020,%eax
  800772:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800778:	a1 20 30 80 00       	mov    0x803020,%eax
  80077d:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800783:	51                   	push   %ecx
  800784:	52                   	push   %edx
  800785:	50                   	push   %eax
  800786:	68 ec 24 80 00       	push   $0x8024ec
  80078b:	e8 14 03 00 00       	call   800aa4 <cprintf>
  800790:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800793:	a1 20 30 80 00       	mov    0x803020,%eax
  800798:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80079e:	83 ec 08             	sub    $0x8,%esp
  8007a1:	50                   	push   %eax
  8007a2:	68 44 25 80 00       	push   $0x802544
  8007a7:	e8 f8 02 00 00       	call   800aa4 <cprintf>
  8007ac:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8007af:	83 ec 0c             	sub    $0xc,%esp
  8007b2:	68 9c 24 80 00       	push   $0x80249c
  8007b7:	e8 e8 02 00 00       	call   800aa4 <cprintf>
  8007bc:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8007bf:	e8 5d 12 00 00       	call   801a21 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8007c4:	e8 19 00 00 00       	call   8007e2 <exit>
}
  8007c9:	90                   	nop
  8007ca:	c9                   	leave  
  8007cb:	c3                   	ret    

008007cc <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8007cc:	55                   	push   %ebp
  8007cd:	89 e5                	mov    %esp,%ebp
  8007cf:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8007d2:	83 ec 0c             	sub    $0xc,%esp
  8007d5:	6a 00                	push   $0x0
  8007d7:	e8 ea 13 00 00       	call   801bc6 <sys_destroy_env>
  8007dc:	83 c4 10             	add    $0x10,%esp
}
  8007df:	90                   	nop
  8007e0:	c9                   	leave  
  8007e1:	c3                   	ret    

008007e2 <exit>:

void
exit(void)
{
  8007e2:	55                   	push   %ebp
  8007e3:	89 e5                	mov    %esp,%ebp
  8007e5:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8007e8:	e8 3f 14 00 00       	call   801c2c <sys_exit_env>
}
  8007ed:	90                   	nop
  8007ee:	c9                   	leave  
  8007ef:	c3                   	ret    

008007f0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8007f0:	55                   	push   %ebp
  8007f1:	89 e5                	mov    %esp,%ebp
  8007f3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8007f6:	8d 45 10             	lea    0x10(%ebp),%eax
  8007f9:	83 c0 04             	add    $0x4,%eax
  8007fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8007ff:	a1 74 31 81 00       	mov    0x813174,%eax
  800804:	85 c0                	test   %eax,%eax
  800806:	74 16                	je     80081e <_panic+0x2e>
		cprintf("%s: ", argv0);
  800808:	a1 74 31 81 00       	mov    0x813174,%eax
  80080d:	83 ec 08             	sub    $0x8,%esp
  800810:	50                   	push   %eax
  800811:	68 58 25 80 00       	push   $0x802558
  800816:	e8 89 02 00 00       	call   800aa4 <cprintf>
  80081b:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80081e:	a1 00 30 80 00       	mov    0x803000,%eax
  800823:	ff 75 0c             	pushl  0xc(%ebp)
  800826:	ff 75 08             	pushl  0x8(%ebp)
  800829:	50                   	push   %eax
  80082a:	68 5d 25 80 00       	push   $0x80255d
  80082f:	e8 70 02 00 00       	call   800aa4 <cprintf>
  800834:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800837:	8b 45 10             	mov    0x10(%ebp),%eax
  80083a:	83 ec 08             	sub    $0x8,%esp
  80083d:	ff 75 f4             	pushl  -0xc(%ebp)
  800840:	50                   	push   %eax
  800841:	e8 f3 01 00 00       	call   800a39 <vcprintf>
  800846:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800849:	83 ec 08             	sub    $0x8,%esp
  80084c:	6a 00                	push   $0x0
  80084e:	68 79 25 80 00       	push   $0x802579
  800853:	e8 e1 01 00 00       	call   800a39 <vcprintf>
  800858:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80085b:	e8 82 ff ff ff       	call   8007e2 <exit>

	// should not return here
	while (1) ;
  800860:	eb fe                	jmp    800860 <_panic+0x70>

00800862 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800862:	55                   	push   %ebp
  800863:	89 e5                	mov    %esp,%ebp
  800865:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800868:	a1 20 30 80 00       	mov    0x803020,%eax
  80086d:	8b 50 74             	mov    0x74(%eax),%edx
  800870:	8b 45 0c             	mov    0xc(%ebp),%eax
  800873:	39 c2                	cmp    %eax,%edx
  800875:	74 14                	je     80088b <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800877:	83 ec 04             	sub    $0x4,%esp
  80087a:	68 7c 25 80 00       	push   $0x80257c
  80087f:	6a 26                	push   $0x26
  800881:	68 c8 25 80 00       	push   $0x8025c8
  800886:	e8 65 ff ff ff       	call   8007f0 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80088b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800892:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800899:	e9 c2 00 00 00       	jmp    800960 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80089e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008a1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8008a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ab:	01 d0                	add    %edx,%eax
  8008ad:	8b 00                	mov    (%eax),%eax
  8008af:	85 c0                	test   %eax,%eax
  8008b1:	75 08                	jne    8008bb <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8008b3:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8008b6:	e9 a2 00 00 00       	jmp    80095d <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8008bb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008c2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8008c9:	eb 69                	jmp    800934 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8008cb:	a1 20 30 80 00       	mov    0x803020,%eax
  8008d0:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8008d6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008d9:	89 d0                	mov    %edx,%eax
  8008db:	01 c0                	add    %eax,%eax
  8008dd:	01 d0                	add    %edx,%eax
  8008df:	c1 e0 03             	shl    $0x3,%eax
  8008e2:	01 c8                	add    %ecx,%eax
  8008e4:	8a 40 04             	mov    0x4(%eax),%al
  8008e7:	84 c0                	test   %al,%al
  8008e9:	75 46                	jne    800931 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008eb:	a1 20 30 80 00       	mov    0x803020,%eax
  8008f0:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8008f6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008f9:	89 d0                	mov    %edx,%eax
  8008fb:	01 c0                	add    %eax,%eax
  8008fd:	01 d0                	add    %edx,%eax
  8008ff:	c1 e0 03             	shl    $0x3,%eax
  800902:	01 c8                	add    %ecx,%eax
  800904:	8b 00                	mov    (%eax),%eax
  800906:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800909:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80090c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800911:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800913:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800916:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80091d:	8b 45 08             	mov    0x8(%ebp),%eax
  800920:	01 c8                	add    %ecx,%eax
  800922:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800924:	39 c2                	cmp    %eax,%edx
  800926:	75 09                	jne    800931 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800928:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80092f:	eb 12                	jmp    800943 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800931:	ff 45 e8             	incl   -0x18(%ebp)
  800934:	a1 20 30 80 00       	mov    0x803020,%eax
  800939:	8b 50 74             	mov    0x74(%eax),%edx
  80093c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80093f:	39 c2                	cmp    %eax,%edx
  800941:	77 88                	ja     8008cb <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800943:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800947:	75 14                	jne    80095d <CheckWSWithoutLastIndex+0xfb>
			panic(
  800949:	83 ec 04             	sub    $0x4,%esp
  80094c:	68 d4 25 80 00       	push   $0x8025d4
  800951:	6a 3a                	push   $0x3a
  800953:	68 c8 25 80 00       	push   $0x8025c8
  800958:	e8 93 fe ff ff       	call   8007f0 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80095d:	ff 45 f0             	incl   -0x10(%ebp)
  800960:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800963:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800966:	0f 8c 32 ff ff ff    	jl     80089e <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80096c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800973:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80097a:	eb 26                	jmp    8009a2 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80097c:	a1 20 30 80 00       	mov    0x803020,%eax
  800981:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800987:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80098a:	89 d0                	mov    %edx,%eax
  80098c:	01 c0                	add    %eax,%eax
  80098e:	01 d0                	add    %edx,%eax
  800990:	c1 e0 03             	shl    $0x3,%eax
  800993:	01 c8                	add    %ecx,%eax
  800995:	8a 40 04             	mov    0x4(%eax),%al
  800998:	3c 01                	cmp    $0x1,%al
  80099a:	75 03                	jne    80099f <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80099c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80099f:	ff 45 e0             	incl   -0x20(%ebp)
  8009a2:	a1 20 30 80 00       	mov    0x803020,%eax
  8009a7:	8b 50 74             	mov    0x74(%eax),%edx
  8009aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009ad:	39 c2                	cmp    %eax,%edx
  8009af:	77 cb                	ja     80097c <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8009b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009b4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8009b7:	74 14                	je     8009cd <CheckWSWithoutLastIndex+0x16b>
		panic(
  8009b9:	83 ec 04             	sub    $0x4,%esp
  8009bc:	68 28 26 80 00       	push   $0x802628
  8009c1:	6a 44                	push   $0x44
  8009c3:	68 c8 25 80 00       	push   $0x8025c8
  8009c8:	e8 23 fe ff ff       	call   8007f0 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8009cd:	90                   	nop
  8009ce:	c9                   	leave  
  8009cf:	c3                   	ret    

008009d0 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8009d0:	55                   	push   %ebp
  8009d1:	89 e5                	mov    %esp,%ebp
  8009d3:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8009d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d9:	8b 00                	mov    (%eax),%eax
  8009db:	8d 48 01             	lea    0x1(%eax),%ecx
  8009de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009e1:	89 0a                	mov    %ecx,(%edx)
  8009e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8009e6:	88 d1                	mov    %dl,%cl
  8009e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009eb:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8009ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f2:	8b 00                	mov    (%eax),%eax
  8009f4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009f9:	75 2c                	jne    800a27 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8009fb:	a0 24 30 80 00       	mov    0x803024,%al
  800a00:	0f b6 c0             	movzbl %al,%eax
  800a03:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a06:	8b 12                	mov    (%edx),%edx
  800a08:	89 d1                	mov    %edx,%ecx
  800a0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a0d:	83 c2 08             	add    $0x8,%edx
  800a10:	83 ec 04             	sub    $0x4,%esp
  800a13:	50                   	push   %eax
  800a14:	51                   	push   %ecx
  800a15:	52                   	push   %edx
  800a16:	e8 3e 0e 00 00       	call   801859 <sys_cputs>
  800a1b:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800a1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a21:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800a27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2a:	8b 40 04             	mov    0x4(%eax),%eax
  800a2d:	8d 50 01             	lea    0x1(%eax),%edx
  800a30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a33:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a36:	90                   	nop
  800a37:	c9                   	leave  
  800a38:	c3                   	ret    

00800a39 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a39:	55                   	push   %ebp
  800a3a:	89 e5                	mov    %esp,%ebp
  800a3c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a42:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a49:	00 00 00 
	b.cnt = 0;
  800a4c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a53:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a56:	ff 75 0c             	pushl  0xc(%ebp)
  800a59:	ff 75 08             	pushl  0x8(%ebp)
  800a5c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a62:	50                   	push   %eax
  800a63:	68 d0 09 80 00       	push   $0x8009d0
  800a68:	e8 11 02 00 00       	call   800c7e <vprintfmt>
  800a6d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a70:	a0 24 30 80 00       	mov    0x803024,%al
  800a75:	0f b6 c0             	movzbl %al,%eax
  800a78:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a7e:	83 ec 04             	sub    $0x4,%esp
  800a81:	50                   	push   %eax
  800a82:	52                   	push   %edx
  800a83:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a89:	83 c0 08             	add    $0x8,%eax
  800a8c:	50                   	push   %eax
  800a8d:	e8 c7 0d 00 00       	call   801859 <sys_cputs>
  800a92:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a95:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800a9c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800aa2:	c9                   	leave  
  800aa3:	c3                   	ret    

00800aa4 <cprintf>:

int cprintf(const char *fmt, ...) {
  800aa4:	55                   	push   %ebp
  800aa5:	89 e5                	mov    %esp,%ebp
  800aa7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800aaa:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800ab1:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ab4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aba:	83 ec 08             	sub    $0x8,%esp
  800abd:	ff 75 f4             	pushl  -0xc(%ebp)
  800ac0:	50                   	push   %eax
  800ac1:	e8 73 ff ff ff       	call   800a39 <vcprintf>
  800ac6:	83 c4 10             	add    $0x10,%esp
  800ac9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800acc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800acf:	c9                   	leave  
  800ad0:	c3                   	ret    

00800ad1 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800ad1:	55                   	push   %ebp
  800ad2:	89 e5                	mov    %esp,%ebp
  800ad4:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800ad7:	e8 2b 0f 00 00       	call   801a07 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800adc:	8d 45 0c             	lea    0xc(%ebp),%eax
  800adf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae5:	83 ec 08             	sub    $0x8,%esp
  800ae8:	ff 75 f4             	pushl  -0xc(%ebp)
  800aeb:	50                   	push   %eax
  800aec:	e8 48 ff ff ff       	call   800a39 <vcprintf>
  800af1:	83 c4 10             	add    $0x10,%esp
  800af4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800af7:	e8 25 0f 00 00       	call   801a21 <sys_enable_interrupt>
	return cnt;
  800afc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800aff:	c9                   	leave  
  800b00:	c3                   	ret    

00800b01 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b01:	55                   	push   %ebp
  800b02:	89 e5                	mov    %esp,%ebp
  800b04:	53                   	push   %ebx
  800b05:	83 ec 14             	sub    $0x14,%esp
  800b08:	8b 45 10             	mov    0x10(%ebp),%eax
  800b0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b0e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b11:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b14:	8b 45 18             	mov    0x18(%ebp),%eax
  800b17:	ba 00 00 00 00       	mov    $0x0,%edx
  800b1c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b1f:	77 55                	ja     800b76 <printnum+0x75>
  800b21:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b24:	72 05                	jb     800b2b <printnum+0x2a>
  800b26:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b29:	77 4b                	ja     800b76 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b2b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800b2e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b31:	8b 45 18             	mov    0x18(%ebp),%eax
  800b34:	ba 00 00 00 00       	mov    $0x0,%edx
  800b39:	52                   	push   %edx
  800b3a:	50                   	push   %eax
  800b3b:	ff 75 f4             	pushl  -0xc(%ebp)
  800b3e:	ff 75 f0             	pushl  -0x10(%ebp)
  800b41:	e8 fa 13 00 00       	call   801f40 <__udivdi3>
  800b46:	83 c4 10             	add    $0x10,%esp
  800b49:	83 ec 04             	sub    $0x4,%esp
  800b4c:	ff 75 20             	pushl  0x20(%ebp)
  800b4f:	53                   	push   %ebx
  800b50:	ff 75 18             	pushl  0x18(%ebp)
  800b53:	52                   	push   %edx
  800b54:	50                   	push   %eax
  800b55:	ff 75 0c             	pushl  0xc(%ebp)
  800b58:	ff 75 08             	pushl  0x8(%ebp)
  800b5b:	e8 a1 ff ff ff       	call   800b01 <printnum>
  800b60:	83 c4 20             	add    $0x20,%esp
  800b63:	eb 1a                	jmp    800b7f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b65:	83 ec 08             	sub    $0x8,%esp
  800b68:	ff 75 0c             	pushl  0xc(%ebp)
  800b6b:	ff 75 20             	pushl  0x20(%ebp)
  800b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b71:	ff d0                	call   *%eax
  800b73:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b76:	ff 4d 1c             	decl   0x1c(%ebp)
  800b79:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b7d:	7f e6                	jg     800b65 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b7f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b82:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b8d:	53                   	push   %ebx
  800b8e:	51                   	push   %ecx
  800b8f:	52                   	push   %edx
  800b90:	50                   	push   %eax
  800b91:	e8 ba 14 00 00       	call   802050 <__umoddi3>
  800b96:	83 c4 10             	add    $0x10,%esp
  800b99:	05 94 28 80 00       	add    $0x802894,%eax
  800b9e:	8a 00                	mov    (%eax),%al
  800ba0:	0f be c0             	movsbl %al,%eax
  800ba3:	83 ec 08             	sub    $0x8,%esp
  800ba6:	ff 75 0c             	pushl  0xc(%ebp)
  800ba9:	50                   	push   %eax
  800baa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bad:	ff d0                	call   *%eax
  800baf:	83 c4 10             	add    $0x10,%esp
}
  800bb2:	90                   	nop
  800bb3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bb6:	c9                   	leave  
  800bb7:	c3                   	ret    

00800bb8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800bb8:	55                   	push   %ebp
  800bb9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bbb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bbf:	7e 1c                	jle    800bdd <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc4:	8b 00                	mov    (%eax),%eax
  800bc6:	8d 50 08             	lea    0x8(%eax),%edx
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	89 10                	mov    %edx,(%eax)
  800bce:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd1:	8b 00                	mov    (%eax),%eax
  800bd3:	83 e8 08             	sub    $0x8,%eax
  800bd6:	8b 50 04             	mov    0x4(%eax),%edx
  800bd9:	8b 00                	mov    (%eax),%eax
  800bdb:	eb 40                	jmp    800c1d <getuint+0x65>
	else if (lflag)
  800bdd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800be1:	74 1e                	je     800c01 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800be3:	8b 45 08             	mov    0x8(%ebp),%eax
  800be6:	8b 00                	mov    (%eax),%eax
  800be8:	8d 50 04             	lea    0x4(%eax),%edx
  800beb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bee:	89 10                	mov    %edx,(%eax)
  800bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf3:	8b 00                	mov    (%eax),%eax
  800bf5:	83 e8 04             	sub    $0x4,%eax
  800bf8:	8b 00                	mov    (%eax),%eax
  800bfa:	ba 00 00 00 00       	mov    $0x0,%edx
  800bff:	eb 1c                	jmp    800c1d <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	8b 00                	mov    (%eax),%eax
  800c06:	8d 50 04             	lea    0x4(%eax),%edx
  800c09:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0c:	89 10                	mov    %edx,(%eax)
  800c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c11:	8b 00                	mov    (%eax),%eax
  800c13:	83 e8 04             	sub    $0x4,%eax
  800c16:	8b 00                	mov    (%eax),%eax
  800c18:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c1d:	5d                   	pop    %ebp
  800c1e:	c3                   	ret    

00800c1f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c22:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c26:	7e 1c                	jle    800c44 <getint+0x25>
		return va_arg(*ap, long long);
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	8b 00                	mov    (%eax),%eax
  800c2d:	8d 50 08             	lea    0x8(%eax),%edx
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	89 10                	mov    %edx,(%eax)
  800c35:	8b 45 08             	mov    0x8(%ebp),%eax
  800c38:	8b 00                	mov    (%eax),%eax
  800c3a:	83 e8 08             	sub    $0x8,%eax
  800c3d:	8b 50 04             	mov    0x4(%eax),%edx
  800c40:	8b 00                	mov    (%eax),%eax
  800c42:	eb 38                	jmp    800c7c <getint+0x5d>
	else if (lflag)
  800c44:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c48:	74 1a                	je     800c64 <getint+0x45>
		return va_arg(*ap, long);
  800c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4d:	8b 00                	mov    (%eax),%eax
  800c4f:	8d 50 04             	lea    0x4(%eax),%edx
  800c52:	8b 45 08             	mov    0x8(%ebp),%eax
  800c55:	89 10                	mov    %edx,(%eax)
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	8b 00                	mov    (%eax),%eax
  800c5c:	83 e8 04             	sub    $0x4,%eax
  800c5f:	8b 00                	mov    (%eax),%eax
  800c61:	99                   	cltd   
  800c62:	eb 18                	jmp    800c7c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c64:	8b 45 08             	mov    0x8(%ebp),%eax
  800c67:	8b 00                	mov    (%eax),%eax
  800c69:	8d 50 04             	lea    0x4(%eax),%edx
  800c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6f:	89 10                	mov    %edx,(%eax)
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
  800c74:	8b 00                	mov    (%eax),%eax
  800c76:	83 e8 04             	sub    $0x4,%eax
  800c79:	8b 00                	mov    (%eax),%eax
  800c7b:	99                   	cltd   
}
  800c7c:	5d                   	pop    %ebp
  800c7d:	c3                   	ret    

00800c7e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c7e:	55                   	push   %ebp
  800c7f:	89 e5                	mov    %esp,%ebp
  800c81:	56                   	push   %esi
  800c82:	53                   	push   %ebx
  800c83:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c86:	eb 17                	jmp    800c9f <vprintfmt+0x21>
			if (ch == '\0')
  800c88:	85 db                	test   %ebx,%ebx
  800c8a:	0f 84 af 03 00 00    	je     80103f <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800c90:	83 ec 08             	sub    $0x8,%esp
  800c93:	ff 75 0c             	pushl  0xc(%ebp)
  800c96:	53                   	push   %ebx
  800c97:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9a:	ff d0                	call   *%eax
  800c9c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c9f:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca2:	8d 50 01             	lea    0x1(%eax),%edx
  800ca5:	89 55 10             	mov    %edx,0x10(%ebp)
  800ca8:	8a 00                	mov    (%eax),%al
  800caa:	0f b6 d8             	movzbl %al,%ebx
  800cad:	83 fb 25             	cmp    $0x25,%ebx
  800cb0:	75 d6                	jne    800c88 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800cb2:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800cb6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800cbd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800cc4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800ccb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800cd2:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd5:	8d 50 01             	lea    0x1(%eax),%edx
  800cd8:	89 55 10             	mov    %edx,0x10(%ebp)
  800cdb:	8a 00                	mov    (%eax),%al
  800cdd:	0f b6 d8             	movzbl %al,%ebx
  800ce0:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800ce3:	83 f8 55             	cmp    $0x55,%eax
  800ce6:	0f 87 2b 03 00 00    	ja     801017 <vprintfmt+0x399>
  800cec:	8b 04 85 b8 28 80 00 	mov    0x8028b8(,%eax,4),%eax
  800cf3:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800cf5:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800cf9:	eb d7                	jmp    800cd2 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800cfb:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800cff:	eb d1                	jmp    800cd2 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d01:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800d08:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d0b:	89 d0                	mov    %edx,%eax
  800d0d:	c1 e0 02             	shl    $0x2,%eax
  800d10:	01 d0                	add    %edx,%eax
  800d12:	01 c0                	add    %eax,%eax
  800d14:	01 d8                	add    %ebx,%eax
  800d16:	83 e8 30             	sub    $0x30,%eax
  800d19:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800d1c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d1f:	8a 00                	mov    (%eax),%al
  800d21:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d24:	83 fb 2f             	cmp    $0x2f,%ebx
  800d27:	7e 3e                	jle    800d67 <vprintfmt+0xe9>
  800d29:	83 fb 39             	cmp    $0x39,%ebx
  800d2c:	7f 39                	jg     800d67 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d2e:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d31:	eb d5                	jmp    800d08 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d33:	8b 45 14             	mov    0x14(%ebp),%eax
  800d36:	83 c0 04             	add    $0x4,%eax
  800d39:	89 45 14             	mov    %eax,0x14(%ebp)
  800d3c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d3f:	83 e8 04             	sub    $0x4,%eax
  800d42:	8b 00                	mov    (%eax),%eax
  800d44:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d47:	eb 1f                	jmp    800d68 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d49:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d4d:	79 83                	jns    800cd2 <vprintfmt+0x54>
				width = 0;
  800d4f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d56:	e9 77 ff ff ff       	jmp    800cd2 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d5b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d62:	e9 6b ff ff ff       	jmp    800cd2 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d67:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d68:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d6c:	0f 89 60 ff ff ff    	jns    800cd2 <vprintfmt+0x54>
				width = precision, precision = -1;
  800d72:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d78:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d7f:	e9 4e ff ff ff       	jmp    800cd2 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d84:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d87:	e9 46 ff ff ff       	jmp    800cd2 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d8c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d8f:	83 c0 04             	add    $0x4,%eax
  800d92:	89 45 14             	mov    %eax,0x14(%ebp)
  800d95:	8b 45 14             	mov    0x14(%ebp),%eax
  800d98:	83 e8 04             	sub    $0x4,%eax
  800d9b:	8b 00                	mov    (%eax),%eax
  800d9d:	83 ec 08             	sub    $0x8,%esp
  800da0:	ff 75 0c             	pushl  0xc(%ebp)
  800da3:	50                   	push   %eax
  800da4:	8b 45 08             	mov    0x8(%ebp),%eax
  800da7:	ff d0                	call   *%eax
  800da9:	83 c4 10             	add    $0x10,%esp
			break;
  800dac:	e9 89 02 00 00       	jmp    80103a <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800db1:	8b 45 14             	mov    0x14(%ebp),%eax
  800db4:	83 c0 04             	add    $0x4,%eax
  800db7:	89 45 14             	mov    %eax,0x14(%ebp)
  800dba:	8b 45 14             	mov    0x14(%ebp),%eax
  800dbd:	83 e8 04             	sub    $0x4,%eax
  800dc0:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800dc2:	85 db                	test   %ebx,%ebx
  800dc4:	79 02                	jns    800dc8 <vprintfmt+0x14a>
				err = -err;
  800dc6:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800dc8:	83 fb 64             	cmp    $0x64,%ebx
  800dcb:	7f 0b                	jg     800dd8 <vprintfmt+0x15a>
  800dcd:	8b 34 9d 00 27 80 00 	mov    0x802700(,%ebx,4),%esi
  800dd4:	85 f6                	test   %esi,%esi
  800dd6:	75 19                	jne    800df1 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800dd8:	53                   	push   %ebx
  800dd9:	68 a5 28 80 00       	push   $0x8028a5
  800dde:	ff 75 0c             	pushl  0xc(%ebp)
  800de1:	ff 75 08             	pushl  0x8(%ebp)
  800de4:	e8 5e 02 00 00       	call   801047 <printfmt>
  800de9:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800dec:	e9 49 02 00 00       	jmp    80103a <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800df1:	56                   	push   %esi
  800df2:	68 ae 28 80 00       	push   $0x8028ae
  800df7:	ff 75 0c             	pushl  0xc(%ebp)
  800dfa:	ff 75 08             	pushl  0x8(%ebp)
  800dfd:	e8 45 02 00 00       	call   801047 <printfmt>
  800e02:	83 c4 10             	add    $0x10,%esp
			break;
  800e05:	e9 30 02 00 00       	jmp    80103a <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e0a:	8b 45 14             	mov    0x14(%ebp),%eax
  800e0d:	83 c0 04             	add    $0x4,%eax
  800e10:	89 45 14             	mov    %eax,0x14(%ebp)
  800e13:	8b 45 14             	mov    0x14(%ebp),%eax
  800e16:	83 e8 04             	sub    $0x4,%eax
  800e19:	8b 30                	mov    (%eax),%esi
  800e1b:	85 f6                	test   %esi,%esi
  800e1d:	75 05                	jne    800e24 <vprintfmt+0x1a6>
				p = "(null)";
  800e1f:	be b1 28 80 00       	mov    $0x8028b1,%esi
			if (width > 0 && padc != '-')
  800e24:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e28:	7e 6d                	jle    800e97 <vprintfmt+0x219>
  800e2a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800e2e:	74 67                	je     800e97 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e30:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e33:	83 ec 08             	sub    $0x8,%esp
  800e36:	50                   	push   %eax
  800e37:	56                   	push   %esi
  800e38:	e8 0c 03 00 00       	call   801149 <strnlen>
  800e3d:	83 c4 10             	add    $0x10,%esp
  800e40:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e43:	eb 16                	jmp    800e5b <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e45:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e49:	83 ec 08             	sub    $0x8,%esp
  800e4c:	ff 75 0c             	pushl  0xc(%ebp)
  800e4f:	50                   	push   %eax
  800e50:	8b 45 08             	mov    0x8(%ebp),%eax
  800e53:	ff d0                	call   *%eax
  800e55:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e58:	ff 4d e4             	decl   -0x1c(%ebp)
  800e5b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e5f:	7f e4                	jg     800e45 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e61:	eb 34                	jmp    800e97 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e63:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e67:	74 1c                	je     800e85 <vprintfmt+0x207>
  800e69:	83 fb 1f             	cmp    $0x1f,%ebx
  800e6c:	7e 05                	jle    800e73 <vprintfmt+0x1f5>
  800e6e:	83 fb 7e             	cmp    $0x7e,%ebx
  800e71:	7e 12                	jle    800e85 <vprintfmt+0x207>
					putch('?', putdat);
  800e73:	83 ec 08             	sub    $0x8,%esp
  800e76:	ff 75 0c             	pushl  0xc(%ebp)
  800e79:	6a 3f                	push   $0x3f
  800e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7e:	ff d0                	call   *%eax
  800e80:	83 c4 10             	add    $0x10,%esp
  800e83:	eb 0f                	jmp    800e94 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e85:	83 ec 08             	sub    $0x8,%esp
  800e88:	ff 75 0c             	pushl  0xc(%ebp)
  800e8b:	53                   	push   %ebx
  800e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8f:	ff d0                	call   *%eax
  800e91:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e94:	ff 4d e4             	decl   -0x1c(%ebp)
  800e97:	89 f0                	mov    %esi,%eax
  800e99:	8d 70 01             	lea    0x1(%eax),%esi
  800e9c:	8a 00                	mov    (%eax),%al
  800e9e:	0f be d8             	movsbl %al,%ebx
  800ea1:	85 db                	test   %ebx,%ebx
  800ea3:	74 24                	je     800ec9 <vprintfmt+0x24b>
  800ea5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ea9:	78 b8                	js     800e63 <vprintfmt+0x1e5>
  800eab:	ff 4d e0             	decl   -0x20(%ebp)
  800eae:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800eb2:	79 af                	jns    800e63 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800eb4:	eb 13                	jmp    800ec9 <vprintfmt+0x24b>
				putch(' ', putdat);
  800eb6:	83 ec 08             	sub    $0x8,%esp
  800eb9:	ff 75 0c             	pushl  0xc(%ebp)
  800ebc:	6a 20                	push   $0x20
  800ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec1:	ff d0                	call   *%eax
  800ec3:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ec6:	ff 4d e4             	decl   -0x1c(%ebp)
  800ec9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ecd:	7f e7                	jg     800eb6 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ecf:	e9 66 01 00 00       	jmp    80103a <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ed4:	83 ec 08             	sub    $0x8,%esp
  800ed7:	ff 75 e8             	pushl  -0x18(%ebp)
  800eda:	8d 45 14             	lea    0x14(%ebp),%eax
  800edd:	50                   	push   %eax
  800ede:	e8 3c fd ff ff       	call   800c1f <getint>
  800ee3:	83 c4 10             	add    $0x10,%esp
  800ee6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ee9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800eec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ef2:	85 d2                	test   %edx,%edx
  800ef4:	79 23                	jns    800f19 <vprintfmt+0x29b>
				putch('-', putdat);
  800ef6:	83 ec 08             	sub    $0x8,%esp
  800ef9:	ff 75 0c             	pushl  0xc(%ebp)
  800efc:	6a 2d                	push   $0x2d
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	ff d0                	call   *%eax
  800f03:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800f06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f0c:	f7 d8                	neg    %eax
  800f0e:	83 d2 00             	adc    $0x0,%edx
  800f11:	f7 da                	neg    %edx
  800f13:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f16:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800f19:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f20:	e9 bc 00 00 00       	jmp    800fe1 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f25:	83 ec 08             	sub    $0x8,%esp
  800f28:	ff 75 e8             	pushl  -0x18(%ebp)
  800f2b:	8d 45 14             	lea    0x14(%ebp),%eax
  800f2e:	50                   	push   %eax
  800f2f:	e8 84 fc ff ff       	call   800bb8 <getuint>
  800f34:	83 c4 10             	add    $0x10,%esp
  800f37:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f3a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f3d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f44:	e9 98 00 00 00       	jmp    800fe1 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f49:	83 ec 08             	sub    $0x8,%esp
  800f4c:	ff 75 0c             	pushl  0xc(%ebp)
  800f4f:	6a 58                	push   $0x58
  800f51:	8b 45 08             	mov    0x8(%ebp),%eax
  800f54:	ff d0                	call   *%eax
  800f56:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f59:	83 ec 08             	sub    $0x8,%esp
  800f5c:	ff 75 0c             	pushl  0xc(%ebp)
  800f5f:	6a 58                	push   $0x58
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
  800f64:	ff d0                	call   *%eax
  800f66:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f69:	83 ec 08             	sub    $0x8,%esp
  800f6c:	ff 75 0c             	pushl  0xc(%ebp)
  800f6f:	6a 58                	push   $0x58
  800f71:	8b 45 08             	mov    0x8(%ebp),%eax
  800f74:	ff d0                	call   *%eax
  800f76:	83 c4 10             	add    $0x10,%esp
			break;
  800f79:	e9 bc 00 00 00       	jmp    80103a <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800f7e:	83 ec 08             	sub    $0x8,%esp
  800f81:	ff 75 0c             	pushl  0xc(%ebp)
  800f84:	6a 30                	push   $0x30
  800f86:	8b 45 08             	mov    0x8(%ebp),%eax
  800f89:	ff d0                	call   *%eax
  800f8b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f8e:	83 ec 08             	sub    $0x8,%esp
  800f91:	ff 75 0c             	pushl  0xc(%ebp)
  800f94:	6a 78                	push   $0x78
  800f96:	8b 45 08             	mov    0x8(%ebp),%eax
  800f99:	ff d0                	call   *%eax
  800f9b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f9e:	8b 45 14             	mov    0x14(%ebp),%eax
  800fa1:	83 c0 04             	add    $0x4,%eax
  800fa4:	89 45 14             	mov    %eax,0x14(%ebp)
  800fa7:	8b 45 14             	mov    0x14(%ebp),%eax
  800faa:	83 e8 04             	sub    $0x4,%eax
  800fad:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800faf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fb2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800fb9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800fc0:	eb 1f                	jmp    800fe1 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800fc2:	83 ec 08             	sub    $0x8,%esp
  800fc5:	ff 75 e8             	pushl  -0x18(%ebp)
  800fc8:	8d 45 14             	lea    0x14(%ebp),%eax
  800fcb:	50                   	push   %eax
  800fcc:	e8 e7 fb ff ff       	call   800bb8 <getuint>
  800fd1:	83 c4 10             	add    $0x10,%esp
  800fd4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fd7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800fda:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800fe1:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800fe5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fe8:	83 ec 04             	sub    $0x4,%esp
  800feb:	52                   	push   %edx
  800fec:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fef:	50                   	push   %eax
  800ff0:	ff 75 f4             	pushl  -0xc(%ebp)
  800ff3:	ff 75 f0             	pushl  -0x10(%ebp)
  800ff6:	ff 75 0c             	pushl  0xc(%ebp)
  800ff9:	ff 75 08             	pushl  0x8(%ebp)
  800ffc:	e8 00 fb ff ff       	call   800b01 <printnum>
  801001:	83 c4 20             	add    $0x20,%esp
			break;
  801004:	eb 34                	jmp    80103a <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801006:	83 ec 08             	sub    $0x8,%esp
  801009:	ff 75 0c             	pushl  0xc(%ebp)
  80100c:	53                   	push   %ebx
  80100d:	8b 45 08             	mov    0x8(%ebp),%eax
  801010:	ff d0                	call   *%eax
  801012:	83 c4 10             	add    $0x10,%esp
			break;
  801015:	eb 23                	jmp    80103a <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801017:	83 ec 08             	sub    $0x8,%esp
  80101a:	ff 75 0c             	pushl  0xc(%ebp)
  80101d:	6a 25                	push   $0x25
  80101f:	8b 45 08             	mov    0x8(%ebp),%eax
  801022:	ff d0                	call   *%eax
  801024:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801027:	ff 4d 10             	decl   0x10(%ebp)
  80102a:	eb 03                	jmp    80102f <vprintfmt+0x3b1>
  80102c:	ff 4d 10             	decl   0x10(%ebp)
  80102f:	8b 45 10             	mov    0x10(%ebp),%eax
  801032:	48                   	dec    %eax
  801033:	8a 00                	mov    (%eax),%al
  801035:	3c 25                	cmp    $0x25,%al
  801037:	75 f3                	jne    80102c <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801039:	90                   	nop
		}
	}
  80103a:	e9 47 fc ff ff       	jmp    800c86 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80103f:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801040:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801043:	5b                   	pop    %ebx
  801044:	5e                   	pop    %esi
  801045:	5d                   	pop    %ebp
  801046:	c3                   	ret    

00801047 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801047:	55                   	push   %ebp
  801048:	89 e5                	mov    %esp,%ebp
  80104a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80104d:	8d 45 10             	lea    0x10(%ebp),%eax
  801050:	83 c0 04             	add    $0x4,%eax
  801053:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801056:	8b 45 10             	mov    0x10(%ebp),%eax
  801059:	ff 75 f4             	pushl  -0xc(%ebp)
  80105c:	50                   	push   %eax
  80105d:	ff 75 0c             	pushl  0xc(%ebp)
  801060:	ff 75 08             	pushl  0x8(%ebp)
  801063:	e8 16 fc ff ff       	call   800c7e <vprintfmt>
  801068:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80106b:	90                   	nop
  80106c:	c9                   	leave  
  80106d:	c3                   	ret    

0080106e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80106e:	55                   	push   %ebp
  80106f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801071:	8b 45 0c             	mov    0xc(%ebp),%eax
  801074:	8b 40 08             	mov    0x8(%eax),%eax
  801077:	8d 50 01             	lea    0x1(%eax),%edx
  80107a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801080:	8b 45 0c             	mov    0xc(%ebp),%eax
  801083:	8b 10                	mov    (%eax),%edx
  801085:	8b 45 0c             	mov    0xc(%ebp),%eax
  801088:	8b 40 04             	mov    0x4(%eax),%eax
  80108b:	39 c2                	cmp    %eax,%edx
  80108d:	73 12                	jae    8010a1 <sprintputch+0x33>
		*b->buf++ = ch;
  80108f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801092:	8b 00                	mov    (%eax),%eax
  801094:	8d 48 01             	lea    0x1(%eax),%ecx
  801097:	8b 55 0c             	mov    0xc(%ebp),%edx
  80109a:	89 0a                	mov    %ecx,(%edx)
  80109c:	8b 55 08             	mov    0x8(%ebp),%edx
  80109f:	88 10                	mov    %dl,(%eax)
}
  8010a1:	90                   	nop
  8010a2:	5d                   	pop    %ebp
  8010a3:	c3                   	ret    

008010a4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010a4:	55                   	push   %ebp
  8010a5:	89 e5                	mov    %esp,%ebp
  8010a7:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b9:	01 d0                	add    %edx,%eax
  8010bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8010c5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010c9:	74 06                	je     8010d1 <vsnprintf+0x2d>
  8010cb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010cf:	7f 07                	jg     8010d8 <vsnprintf+0x34>
		return -E_INVAL;
  8010d1:	b8 03 00 00 00       	mov    $0x3,%eax
  8010d6:	eb 20                	jmp    8010f8 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8010d8:	ff 75 14             	pushl  0x14(%ebp)
  8010db:	ff 75 10             	pushl  0x10(%ebp)
  8010de:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8010e1:	50                   	push   %eax
  8010e2:	68 6e 10 80 00       	push   $0x80106e
  8010e7:	e8 92 fb ff ff       	call   800c7e <vprintfmt>
  8010ec:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8010ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010f2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8010f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8010f8:	c9                   	leave  
  8010f9:	c3                   	ret    

008010fa <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010fa:	55                   	push   %ebp
  8010fb:	89 e5                	mov    %esp,%ebp
  8010fd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801100:	8d 45 10             	lea    0x10(%ebp),%eax
  801103:	83 c0 04             	add    $0x4,%eax
  801106:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801109:	8b 45 10             	mov    0x10(%ebp),%eax
  80110c:	ff 75 f4             	pushl  -0xc(%ebp)
  80110f:	50                   	push   %eax
  801110:	ff 75 0c             	pushl  0xc(%ebp)
  801113:	ff 75 08             	pushl  0x8(%ebp)
  801116:	e8 89 ff ff ff       	call   8010a4 <vsnprintf>
  80111b:	83 c4 10             	add    $0x10,%esp
  80111e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801121:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801124:	c9                   	leave  
  801125:	c3                   	ret    

00801126 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801126:	55                   	push   %ebp
  801127:	89 e5                	mov    %esp,%ebp
  801129:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80112c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801133:	eb 06                	jmp    80113b <strlen+0x15>
		n++;
  801135:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801138:	ff 45 08             	incl   0x8(%ebp)
  80113b:	8b 45 08             	mov    0x8(%ebp),%eax
  80113e:	8a 00                	mov    (%eax),%al
  801140:	84 c0                	test   %al,%al
  801142:	75 f1                	jne    801135 <strlen+0xf>
		n++;
	return n;
  801144:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801147:	c9                   	leave  
  801148:	c3                   	ret    

00801149 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801149:	55                   	push   %ebp
  80114a:	89 e5                	mov    %esp,%ebp
  80114c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80114f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801156:	eb 09                	jmp    801161 <strnlen+0x18>
		n++;
  801158:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80115b:	ff 45 08             	incl   0x8(%ebp)
  80115e:	ff 4d 0c             	decl   0xc(%ebp)
  801161:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801165:	74 09                	je     801170 <strnlen+0x27>
  801167:	8b 45 08             	mov    0x8(%ebp),%eax
  80116a:	8a 00                	mov    (%eax),%al
  80116c:	84 c0                	test   %al,%al
  80116e:	75 e8                	jne    801158 <strnlen+0xf>
		n++;
	return n;
  801170:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801173:	c9                   	leave  
  801174:	c3                   	ret    

00801175 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801175:	55                   	push   %ebp
  801176:	89 e5                	mov    %esp,%ebp
  801178:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80117b:	8b 45 08             	mov    0x8(%ebp),%eax
  80117e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801181:	90                   	nop
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	8d 50 01             	lea    0x1(%eax),%edx
  801188:	89 55 08             	mov    %edx,0x8(%ebp)
  80118b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80118e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801191:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801194:	8a 12                	mov    (%edx),%dl
  801196:	88 10                	mov    %dl,(%eax)
  801198:	8a 00                	mov    (%eax),%al
  80119a:	84 c0                	test   %al,%al
  80119c:	75 e4                	jne    801182 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80119e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8011a1:	c9                   	leave  
  8011a2:	c3                   	ret    

008011a3 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8011a3:	55                   	push   %ebp
  8011a4:	89 e5                	mov    %esp,%ebp
  8011a6:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8011a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ac:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8011af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011b6:	eb 1f                	jmp    8011d7 <strncpy+0x34>
		*dst++ = *src;
  8011b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bb:	8d 50 01             	lea    0x1(%eax),%edx
  8011be:	89 55 08             	mov    %edx,0x8(%ebp)
  8011c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011c4:	8a 12                	mov    (%edx),%dl
  8011c6:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8011c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cb:	8a 00                	mov    (%eax),%al
  8011cd:	84 c0                	test   %al,%al
  8011cf:	74 03                	je     8011d4 <strncpy+0x31>
			src++;
  8011d1:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011d4:	ff 45 fc             	incl   -0x4(%ebp)
  8011d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011da:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011dd:	72 d9                	jb     8011b8 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8011df:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011e2:	c9                   	leave  
  8011e3:	c3                   	ret    

008011e4 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8011e4:	55                   	push   %ebp
  8011e5:	89 e5                	mov    %esp,%ebp
  8011e7:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8011f0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011f4:	74 30                	je     801226 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8011f6:	eb 16                	jmp    80120e <strlcpy+0x2a>
			*dst++ = *src++;
  8011f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fb:	8d 50 01             	lea    0x1(%eax),%edx
  8011fe:	89 55 08             	mov    %edx,0x8(%ebp)
  801201:	8b 55 0c             	mov    0xc(%ebp),%edx
  801204:	8d 4a 01             	lea    0x1(%edx),%ecx
  801207:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80120a:	8a 12                	mov    (%edx),%dl
  80120c:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80120e:	ff 4d 10             	decl   0x10(%ebp)
  801211:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801215:	74 09                	je     801220 <strlcpy+0x3c>
  801217:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121a:	8a 00                	mov    (%eax),%al
  80121c:	84 c0                	test   %al,%al
  80121e:	75 d8                	jne    8011f8 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801220:	8b 45 08             	mov    0x8(%ebp),%eax
  801223:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801226:	8b 55 08             	mov    0x8(%ebp),%edx
  801229:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80122c:	29 c2                	sub    %eax,%edx
  80122e:	89 d0                	mov    %edx,%eax
}
  801230:	c9                   	leave  
  801231:	c3                   	ret    

00801232 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801232:	55                   	push   %ebp
  801233:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801235:	eb 06                	jmp    80123d <strcmp+0xb>
		p++, q++;
  801237:	ff 45 08             	incl   0x8(%ebp)
  80123a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80123d:	8b 45 08             	mov    0x8(%ebp),%eax
  801240:	8a 00                	mov    (%eax),%al
  801242:	84 c0                	test   %al,%al
  801244:	74 0e                	je     801254 <strcmp+0x22>
  801246:	8b 45 08             	mov    0x8(%ebp),%eax
  801249:	8a 10                	mov    (%eax),%dl
  80124b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124e:	8a 00                	mov    (%eax),%al
  801250:	38 c2                	cmp    %al,%dl
  801252:	74 e3                	je     801237 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801254:	8b 45 08             	mov    0x8(%ebp),%eax
  801257:	8a 00                	mov    (%eax),%al
  801259:	0f b6 d0             	movzbl %al,%edx
  80125c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125f:	8a 00                	mov    (%eax),%al
  801261:	0f b6 c0             	movzbl %al,%eax
  801264:	29 c2                	sub    %eax,%edx
  801266:	89 d0                	mov    %edx,%eax
}
  801268:	5d                   	pop    %ebp
  801269:	c3                   	ret    

0080126a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80126a:	55                   	push   %ebp
  80126b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80126d:	eb 09                	jmp    801278 <strncmp+0xe>
		n--, p++, q++;
  80126f:	ff 4d 10             	decl   0x10(%ebp)
  801272:	ff 45 08             	incl   0x8(%ebp)
  801275:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801278:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80127c:	74 17                	je     801295 <strncmp+0x2b>
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	8a 00                	mov    (%eax),%al
  801283:	84 c0                	test   %al,%al
  801285:	74 0e                	je     801295 <strncmp+0x2b>
  801287:	8b 45 08             	mov    0x8(%ebp),%eax
  80128a:	8a 10                	mov    (%eax),%dl
  80128c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128f:	8a 00                	mov    (%eax),%al
  801291:	38 c2                	cmp    %al,%dl
  801293:	74 da                	je     80126f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801295:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801299:	75 07                	jne    8012a2 <strncmp+0x38>
		return 0;
  80129b:	b8 00 00 00 00       	mov    $0x0,%eax
  8012a0:	eb 14                	jmp    8012b6 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a5:	8a 00                	mov    (%eax),%al
  8012a7:	0f b6 d0             	movzbl %al,%edx
  8012aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ad:	8a 00                	mov    (%eax),%al
  8012af:	0f b6 c0             	movzbl %al,%eax
  8012b2:	29 c2                	sub    %eax,%edx
  8012b4:	89 d0                	mov    %edx,%eax
}
  8012b6:	5d                   	pop    %ebp
  8012b7:	c3                   	ret    

008012b8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012b8:	55                   	push   %ebp
  8012b9:	89 e5                	mov    %esp,%ebp
  8012bb:	83 ec 04             	sub    $0x4,%esp
  8012be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8012c4:	eb 12                	jmp    8012d8 <strchr+0x20>
		if (*s == c)
  8012c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c9:	8a 00                	mov    (%eax),%al
  8012cb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8012ce:	75 05                	jne    8012d5 <strchr+0x1d>
			return (char *) s;
  8012d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d3:	eb 11                	jmp    8012e6 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012d5:	ff 45 08             	incl   0x8(%ebp)
  8012d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012db:	8a 00                	mov    (%eax),%al
  8012dd:	84 c0                	test   %al,%al
  8012df:	75 e5                	jne    8012c6 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8012e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012e6:	c9                   	leave  
  8012e7:	c3                   	ret    

008012e8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012e8:	55                   	push   %ebp
  8012e9:	89 e5                	mov    %esp,%ebp
  8012eb:	83 ec 04             	sub    $0x4,%esp
  8012ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8012f4:	eb 0d                	jmp    801303 <strfind+0x1b>
		if (*s == c)
  8012f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f9:	8a 00                	mov    (%eax),%al
  8012fb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8012fe:	74 0e                	je     80130e <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801300:	ff 45 08             	incl   0x8(%ebp)
  801303:	8b 45 08             	mov    0x8(%ebp),%eax
  801306:	8a 00                	mov    (%eax),%al
  801308:	84 c0                	test   %al,%al
  80130a:	75 ea                	jne    8012f6 <strfind+0xe>
  80130c:	eb 01                	jmp    80130f <strfind+0x27>
		if (*s == c)
			break;
  80130e:	90                   	nop
	return (char *) s;
  80130f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801312:	c9                   	leave  
  801313:	c3                   	ret    

00801314 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801314:	55                   	push   %ebp
  801315:	89 e5                	mov    %esp,%ebp
  801317:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80131a:	8b 45 08             	mov    0x8(%ebp),%eax
  80131d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801320:	8b 45 10             	mov    0x10(%ebp),%eax
  801323:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801326:	eb 0e                	jmp    801336 <memset+0x22>
		*p++ = c;
  801328:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80132b:	8d 50 01             	lea    0x1(%eax),%edx
  80132e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801331:	8b 55 0c             	mov    0xc(%ebp),%edx
  801334:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801336:	ff 4d f8             	decl   -0x8(%ebp)
  801339:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80133d:	79 e9                	jns    801328 <memset+0x14>
		*p++ = c;

	return v;
  80133f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801342:	c9                   	leave  
  801343:	c3                   	ret    

00801344 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801344:	55                   	push   %ebp
  801345:	89 e5                	mov    %esp,%ebp
  801347:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80134a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801350:	8b 45 08             	mov    0x8(%ebp),%eax
  801353:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801356:	eb 16                	jmp    80136e <memcpy+0x2a>
		*d++ = *s++;
  801358:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80135b:	8d 50 01             	lea    0x1(%eax),%edx
  80135e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801361:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801364:	8d 4a 01             	lea    0x1(%edx),%ecx
  801367:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80136a:	8a 12                	mov    (%edx),%dl
  80136c:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80136e:	8b 45 10             	mov    0x10(%ebp),%eax
  801371:	8d 50 ff             	lea    -0x1(%eax),%edx
  801374:	89 55 10             	mov    %edx,0x10(%ebp)
  801377:	85 c0                	test   %eax,%eax
  801379:	75 dd                	jne    801358 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80137b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80137e:	c9                   	leave  
  80137f:	c3                   	ret    

00801380 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
  801383:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801386:	8b 45 0c             	mov    0xc(%ebp),%eax
  801389:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80138c:	8b 45 08             	mov    0x8(%ebp),%eax
  80138f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801392:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801395:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801398:	73 50                	jae    8013ea <memmove+0x6a>
  80139a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80139d:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a0:	01 d0                	add    %edx,%eax
  8013a2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8013a5:	76 43                	jbe    8013ea <memmove+0x6a>
		s += n;
  8013a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8013aa:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8013ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b0:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8013b3:	eb 10                	jmp    8013c5 <memmove+0x45>
			*--d = *--s;
  8013b5:	ff 4d f8             	decl   -0x8(%ebp)
  8013b8:	ff 4d fc             	decl   -0x4(%ebp)
  8013bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013be:	8a 10                	mov    (%eax),%dl
  8013c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013c3:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8013c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013cb:	89 55 10             	mov    %edx,0x10(%ebp)
  8013ce:	85 c0                	test   %eax,%eax
  8013d0:	75 e3                	jne    8013b5 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8013d2:	eb 23                	jmp    8013f7 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8013d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013d7:	8d 50 01             	lea    0x1(%eax),%edx
  8013da:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013dd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013e0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013e3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8013e6:	8a 12                	mov    (%edx),%dl
  8013e8:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8013ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ed:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013f0:	89 55 10             	mov    %edx,0x10(%ebp)
  8013f3:	85 c0                	test   %eax,%eax
  8013f5:	75 dd                	jne    8013d4 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8013f7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013fa:	c9                   	leave  
  8013fb:	c3                   	ret    

008013fc <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8013fc:	55                   	push   %ebp
  8013fd:	89 e5                	mov    %esp,%ebp
  8013ff:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801402:	8b 45 08             	mov    0x8(%ebp),%eax
  801405:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801408:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140b:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80140e:	eb 2a                	jmp    80143a <memcmp+0x3e>
		if (*s1 != *s2)
  801410:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801413:	8a 10                	mov    (%eax),%dl
  801415:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801418:	8a 00                	mov    (%eax),%al
  80141a:	38 c2                	cmp    %al,%dl
  80141c:	74 16                	je     801434 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80141e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801421:	8a 00                	mov    (%eax),%al
  801423:	0f b6 d0             	movzbl %al,%edx
  801426:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801429:	8a 00                	mov    (%eax),%al
  80142b:	0f b6 c0             	movzbl %al,%eax
  80142e:	29 c2                	sub    %eax,%edx
  801430:	89 d0                	mov    %edx,%eax
  801432:	eb 18                	jmp    80144c <memcmp+0x50>
		s1++, s2++;
  801434:	ff 45 fc             	incl   -0x4(%ebp)
  801437:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80143a:	8b 45 10             	mov    0x10(%ebp),%eax
  80143d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801440:	89 55 10             	mov    %edx,0x10(%ebp)
  801443:	85 c0                	test   %eax,%eax
  801445:	75 c9                	jne    801410 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801447:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80144c:	c9                   	leave  
  80144d:	c3                   	ret    

0080144e <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80144e:	55                   	push   %ebp
  80144f:	89 e5                	mov    %esp,%ebp
  801451:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801454:	8b 55 08             	mov    0x8(%ebp),%edx
  801457:	8b 45 10             	mov    0x10(%ebp),%eax
  80145a:	01 d0                	add    %edx,%eax
  80145c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80145f:	eb 15                	jmp    801476 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801461:	8b 45 08             	mov    0x8(%ebp),%eax
  801464:	8a 00                	mov    (%eax),%al
  801466:	0f b6 d0             	movzbl %al,%edx
  801469:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146c:	0f b6 c0             	movzbl %al,%eax
  80146f:	39 c2                	cmp    %eax,%edx
  801471:	74 0d                	je     801480 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801473:	ff 45 08             	incl   0x8(%ebp)
  801476:	8b 45 08             	mov    0x8(%ebp),%eax
  801479:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80147c:	72 e3                	jb     801461 <memfind+0x13>
  80147e:	eb 01                	jmp    801481 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801480:	90                   	nop
	return (void *) s;
  801481:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801484:	c9                   	leave  
  801485:	c3                   	ret    

00801486 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801486:	55                   	push   %ebp
  801487:	89 e5                	mov    %esp,%ebp
  801489:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80148c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801493:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80149a:	eb 03                	jmp    80149f <strtol+0x19>
		s++;
  80149c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80149f:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a2:	8a 00                	mov    (%eax),%al
  8014a4:	3c 20                	cmp    $0x20,%al
  8014a6:	74 f4                	je     80149c <strtol+0x16>
  8014a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ab:	8a 00                	mov    (%eax),%al
  8014ad:	3c 09                	cmp    $0x9,%al
  8014af:	74 eb                	je     80149c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8014b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b4:	8a 00                	mov    (%eax),%al
  8014b6:	3c 2b                	cmp    $0x2b,%al
  8014b8:	75 05                	jne    8014bf <strtol+0x39>
		s++;
  8014ba:	ff 45 08             	incl   0x8(%ebp)
  8014bd:	eb 13                	jmp    8014d2 <strtol+0x4c>
	else if (*s == '-')
  8014bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c2:	8a 00                	mov    (%eax),%al
  8014c4:	3c 2d                	cmp    $0x2d,%al
  8014c6:	75 0a                	jne    8014d2 <strtol+0x4c>
		s++, neg = 1;
  8014c8:	ff 45 08             	incl   0x8(%ebp)
  8014cb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8014d2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014d6:	74 06                	je     8014de <strtol+0x58>
  8014d8:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8014dc:	75 20                	jne    8014fe <strtol+0x78>
  8014de:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e1:	8a 00                	mov    (%eax),%al
  8014e3:	3c 30                	cmp    $0x30,%al
  8014e5:	75 17                	jne    8014fe <strtol+0x78>
  8014e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ea:	40                   	inc    %eax
  8014eb:	8a 00                	mov    (%eax),%al
  8014ed:	3c 78                	cmp    $0x78,%al
  8014ef:	75 0d                	jne    8014fe <strtol+0x78>
		s += 2, base = 16;
  8014f1:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8014f5:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8014fc:	eb 28                	jmp    801526 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8014fe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801502:	75 15                	jne    801519 <strtol+0x93>
  801504:	8b 45 08             	mov    0x8(%ebp),%eax
  801507:	8a 00                	mov    (%eax),%al
  801509:	3c 30                	cmp    $0x30,%al
  80150b:	75 0c                	jne    801519 <strtol+0x93>
		s++, base = 8;
  80150d:	ff 45 08             	incl   0x8(%ebp)
  801510:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801517:	eb 0d                	jmp    801526 <strtol+0xa0>
	else if (base == 0)
  801519:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80151d:	75 07                	jne    801526 <strtol+0xa0>
		base = 10;
  80151f:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801526:	8b 45 08             	mov    0x8(%ebp),%eax
  801529:	8a 00                	mov    (%eax),%al
  80152b:	3c 2f                	cmp    $0x2f,%al
  80152d:	7e 19                	jle    801548 <strtol+0xc2>
  80152f:	8b 45 08             	mov    0x8(%ebp),%eax
  801532:	8a 00                	mov    (%eax),%al
  801534:	3c 39                	cmp    $0x39,%al
  801536:	7f 10                	jg     801548 <strtol+0xc2>
			dig = *s - '0';
  801538:	8b 45 08             	mov    0x8(%ebp),%eax
  80153b:	8a 00                	mov    (%eax),%al
  80153d:	0f be c0             	movsbl %al,%eax
  801540:	83 e8 30             	sub    $0x30,%eax
  801543:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801546:	eb 42                	jmp    80158a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801548:	8b 45 08             	mov    0x8(%ebp),%eax
  80154b:	8a 00                	mov    (%eax),%al
  80154d:	3c 60                	cmp    $0x60,%al
  80154f:	7e 19                	jle    80156a <strtol+0xe4>
  801551:	8b 45 08             	mov    0x8(%ebp),%eax
  801554:	8a 00                	mov    (%eax),%al
  801556:	3c 7a                	cmp    $0x7a,%al
  801558:	7f 10                	jg     80156a <strtol+0xe4>
			dig = *s - 'a' + 10;
  80155a:	8b 45 08             	mov    0x8(%ebp),%eax
  80155d:	8a 00                	mov    (%eax),%al
  80155f:	0f be c0             	movsbl %al,%eax
  801562:	83 e8 57             	sub    $0x57,%eax
  801565:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801568:	eb 20                	jmp    80158a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80156a:	8b 45 08             	mov    0x8(%ebp),%eax
  80156d:	8a 00                	mov    (%eax),%al
  80156f:	3c 40                	cmp    $0x40,%al
  801571:	7e 39                	jle    8015ac <strtol+0x126>
  801573:	8b 45 08             	mov    0x8(%ebp),%eax
  801576:	8a 00                	mov    (%eax),%al
  801578:	3c 5a                	cmp    $0x5a,%al
  80157a:	7f 30                	jg     8015ac <strtol+0x126>
			dig = *s - 'A' + 10;
  80157c:	8b 45 08             	mov    0x8(%ebp),%eax
  80157f:	8a 00                	mov    (%eax),%al
  801581:	0f be c0             	movsbl %al,%eax
  801584:	83 e8 37             	sub    $0x37,%eax
  801587:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80158a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80158d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801590:	7d 19                	jge    8015ab <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801592:	ff 45 08             	incl   0x8(%ebp)
  801595:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801598:	0f af 45 10          	imul   0x10(%ebp),%eax
  80159c:	89 c2                	mov    %eax,%edx
  80159e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a1:	01 d0                	add    %edx,%eax
  8015a3:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8015a6:	e9 7b ff ff ff       	jmp    801526 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8015ab:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8015ac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015b0:	74 08                	je     8015ba <strtol+0x134>
		*endptr = (char *) s;
  8015b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8015b8:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8015ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015be:	74 07                	je     8015c7 <strtol+0x141>
  8015c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015c3:	f7 d8                	neg    %eax
  8015c5:	eb 03                	jmp    8015ca <strtol+0x144>
  8015c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8015ca:	c9                   	leave  
  8015cb:	c3                   	ret    

008015cc <ltostr>:

void
ltostr(long value, char *str)
{
  8015cc:	55                   	push   %ebp
  8015cd:	89 e5                	mov    %esp,%ebp
  8015cf:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8015d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8015d9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8015e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015e4:	79 13                	jns    8015f9 <ltostr+0x2d>
	{
		neg = 1;
  8015e6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8015ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f0:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8015f3:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8015f6:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8015f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fc:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801601:	99                   	cltd   
  801602:	f7 f9                	idiv   %ecx
  801604:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801607:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80160a:	8d 50 01             	lea    0x1(%eax),%edx
  80160d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801610:	89 c2                	mov    %eax,%edx
  801612:	8b 45 0c             	mov    0xc(%ebp),%eax
  801615:	01 d0                	add    %edx,%eax
  801617:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80161a:	83 c2 30             	add    $0x30,%edx
  80161d:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80161f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801622:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801627:	f7 e9                	imul   %ecx
  801629:	c1 fa 02             	sar    $0x2,%edx
  80162c:	89 c8                	mov    %ecx,%eax
  80162e:	c1 f8 1f             	sar    $0x1f,%eax
  801631:	29 c2                	sub    %eax,%edx
  801633:	89 d0                	mov    %edx,%eax
  801635:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801638:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80163b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801640:	f7 e9                	imul   %ecx
  801642:	c1 fa 02             	sar    $0x2,%edx
  801645:	89 c8                	mov    %ecx,%eax
  801647:	c1 f8 1f             	sar    $0x1f,%eax
  80164a:	29 c2                	sub    %eax,%edx
  80164c:	89 d0                	mov    %edx,%eax
  80164e:	c1 e0 02             	shl    $0x2,%eax
  801651:	01 d0                	add    %edx,%eax
  801653:	01 c0                	add    %eax,%eax
  801655:	29 c1                	sub    %eax,%ecx
  801657:	89 ca                	mov    %ecx,%edx
  801659:	85 d2                	test   %edx,%edx
  80165b:	75 9c                	jne    8015f9 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80165d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801664:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801667:	48                   	dec    %eax
  801668:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80166b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80166f:	74 3d                	je     8016ae <ltostr+0xe2>
		start = 1 ;
  801671:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801678:	eb 34                	jmp    8016ae <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80167a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80167d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801680:	01 d0                	add    %edx,%eax
  801682:	8a 00                	mov    (%eax),%al
  801684:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801687:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80168a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80168d:	01 c2                	add    %eax,%edx
  80168f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801692:	8b 45 0c             	mov    0xc(%ebp),%eax
  801695:	01 c8                	add    %ecx,%eax
  801697:	8a 00                	mov    (%eax),%al
  801699:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80169b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80169e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a1:	01 c2                	add    %eax,%edx
  8016a3:	8a 45 eb             	mov    -0x15(%ebp),%al
  8016a6:	88 02                	mov    %al,(%edx)
		start++ ;
  8016a8:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8016ab:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8016ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016b1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016b4:	7c c4                	jl     80167a <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8016b6:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8016b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016bc:	01 d0                	add    %edx,%eax
  8016be:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8016c1:	90                   	nop
  8016c2:	c9                   	leave  
  8016c3:	c3                   	ret    

008016c4 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8016c4:	55                   	push   %ebp
  8016c5:	89 e5                	mov    %esp,%ebp
  8016c7:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8016ca:	ff 75 08             	pushl  0x8(%ebp)
  8016cd:	e8 54 fa ff ff       	call   801126 <strlen>
  8016d2:	83 c4 04             	add    $0x4,%esp
  8016d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8016d8:	ff 75 0c             	pushl  0xc(%ebp)
  8016db:	e8 46 fa ff ff       	call   801126 <strlen>
  8016e0:	83 c4 04             	add    $0x4,%esp
  8016e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8016e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8016ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016f4:	eb 17                	jmp    80170d <strcconcat+0x49>
		final[s] = str1[s] ;
  8016f6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8016fc:	01 c2                	add    %eax,%edx
  8016fe:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801701:	8b 45 08             	mov    0x8(%ebp),%eax
  801704:	01 c8                	add    %ecx,%eax
  801706:	8a 00                	mov    (%eax),%al
  801708:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80170a:	ff 45 fc             	incl   -0x4(%ebp)
  80170d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801710:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801713:	7c e1                	jl     8016f6 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801715:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80171c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801723:	eb 1f                	jmp    801744 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801725:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801728:	8d 50 01             	lea    0x1(%eax),%edx
  80172b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80172e:	89 c2                	mov    %eax,%edx
  801730:	8b 45 10             	mov    0x10(%ebp),%eax
  801733:	01 c2                	add    %eax,%edx
  801735:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801738:	8b 45 0c             	mov    0xc(%ebp),%eax
  80173b:	01 c8                	add    %ecx,%eax
  80173d:	8a 00                	mov    (%eax),%al
  80173f:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801741:	ff 45 f8             	incl   -0x8(%ebp)
  801744:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801747:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80174a:	7c d9                	jl     801725 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80174c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80174f:	8b 45 10             	mov    0x10(%ebp),%eax
  801752:	01 d0                	add    %edx,%eax
  801754:	c6 00 00             	movb   $0x0,(%eax)
}
  801757:	90                   	nop
  801758:	c9                   	leave  
  801759:	c3                   	ret    

0080175a <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80175a:	55                   	push   %ebp
  80175b:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80175d:	8b 45 14             	mov    0x14(%ebp),%eax
  801760:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801766:	8b 45 14             	mov    0x14(%ebp),%eax
  801769:	8b 00                	mov    (%eax),%eax
  80176b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801772:	8b 45 10             	mov    0x10(%ebp),%eax
  801775:	01 d0                	add    %edx,%eax
  801777:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80177d:	eb 0c                	jmp    80178b <strsplit+0x31>
			*string++ = 0;
  80177f:	8b 45 08             	mov    0x8(%ebp),%eax
  801782:	8d 50 01             	lea    0x1(%eax),%edx
  801785:	89 55 08             	mov    %edx,0x8(%ebp)
  801788:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80178b:	8b 45 08             	mov    0x8(%ebp),%eax
  80178e:	8a 00                	mov    (%eax),%al
  801790:	84 c0                	test   %al,%al
  801792:	74 18                	je     8017ac <strsplit+0x52>
  801794:	8b 45 08             	mov    0x8(%ebp),%eax
  801797:	8a 00                	mov    (%eax),%al
  801799:	0f be c0             	movsbl %al,%eax
  80179c:	50                   	push   %eax
  80179d:	ff 75 0c             	pushl  0xc(%ebp)
  8017a0:	e8 13 fb ff ff       	call   8012b8 <strchr>
  8017a5:	83 c4 08             	add    $0x8,%esp
  8017a8:	85 c0                	test   %eax,%eax
  8017aa:	75 d3                	jne    80177f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	8a 00                	mov    (%eax),%al
  8017b1:	84 c0                	test   %al,%al
  8017b3:	74 5a                	je     80180f <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8017b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8017b8:	8b 00                	mov    (%eax),%eax
  8017ba:	83 f8 0f             	cmp    $0xf,%eax
  8017bd:	75 07                	jne    8017c6 <strsplit+0x6c>
		{
			return 0;
  8017bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c4:	eb 66                	jmp    80182c <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8017c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8017c9:	8b 00                	mov    (%eax),%eax
  8017cb:	8d 48 01             	lea    0x1(%eax),%ecx
  8017ce:	8b 55 14             	mov    0x14(%ebp),%edx
  8017d1:	89 0a                	mov    %ecx,(%edx)
  8017d3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017da:	8b 45 10             	mov    0x10(%ebp),%eax
  8017dd:	01 c2                	add    %eax,%edx
  8017df:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e2:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017e4:	eb 03                	jmp    8017e9 <strsplit+0x8f>
			string++;
  8017e6:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ec:	8a 00                	mov    (%eax),%al
  8017ee:	84 c0                	test   %al,%al
  8017f0:	74 8b                	je     80177d <strsplit+0x23>
  8017f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f5:	8a 00                	mov    (%eax),%al
  8017f7:	0f be c0             	movsbl %al,%eax
  8017fa:	50                   	push   %eax
  8017fb:	ff 75 0c             	pushl  0xc(%ebp)
  8017fe:	e8 b5 fa ff ff       	call   8012b8 <strchr>
  801803:	83 c4 08             	add    $0x8,%esp
  801806:	85 c0                	test   %eax,%eax
  801808:	74 dc                	je     8017e6 <strsplit+0x8c>
			string++;
	}
  80180a:	e9 6e ff ff ff       	jmp    80177d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80180f:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801810:	8b 45 14             	mov    0x14(%ebp),%eax
  801813:	8b 00                	mov    (%eax),%eax
  801815:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80181c:	8b 45 10             	mov    0x10(%ebp),%eax
  80181f:	01 d0                	add    %edx,%eax
  801821:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801827:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80182c:	c9                   	leave  
  80182d:	c3                   	ret    

0080182e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80182e:	55                   	push   %ebp
  80182f:	89 e5                	mov    %esp,%ebp
  801831:	57                   	push   %edi
  801832:	56                   	push   %esi
  801833:	53                   	push   %ebx
  801834:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801837:	8b 45 08             	mov    0x8(%ebp),%eax
  80183a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80183d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801840:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801843:	8b 7d 18             	mov    0x18(%ebp),%edi
  801846:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801849:	cd 30                	int    $0x30
  80184b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80184e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801851:	83 c4 10             	add    $0x10,%esp
  801854:	5b                   	pop    %ebx
  801855:	5e                   	pop    %esi
  801856:	5f                   	pop    %edi
  801857:	5d                   	pop    %ebp
  801858:	c3                   	ret    

00801859 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
  80185c:	83 ec 04             	sub    $0x4,%esp
  80185f:	8b 45 10             	mov    0x10(%ebp),%eax
  801862:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801865:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801869:	8b 45 08             	mov    0x8(%ebp),%eax
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	52                   	push   %edx
  801871:	ff 75 0c             	pushl  0xc(%ebp)
  801874:	50                   	push   %eax
  801875:	6a 00                	push   $0x0
  801877:	e8 b2 ff ff ff       	call   80182e <syscall>
  80187c:	83 c4 18             	add    $0x18,%esp
}
  80187f:	90                   	nop
  801880:	c9                   	leave  
  801881:	c3                   	ret    

00801882 <sys_cgetc>:

int
sys_cgetc(void)
{
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 01                	push   $0x1
  801891:	e8 98 ff ff ff       	call   80182e <syscall>
  801896:	83 c4 18             	add    $0x18,%esp
}
  801899:	c9                   	leave  
  80189a:	c3                   	ret    

0080189b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80189b:	55                   	push   %ebp
  80189c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80189e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	52                   	push   %edx
  8018ab:	50                   	push   %eax
  8018ac:	6a 05                	push   $0x5
  8018ae:	e8 7b ff ff ff       	call   80182e <syscall>
  8018b3:	83 c4 18             	add    $0x18,%esp
}
  8018b6:	c9                   	leave  
  8018b7:	c3                   	ret    

008018b8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
  8018bb:	56                   	push   %esi
  8018bc:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018bd:	8b 75 18             	mov    0x18(%ebp),%esi
  8018c0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018c3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cc:	56                   	push   %esi
  8018cd:	53                   	push   %ebx
  8018ce:	51                   	push   %ecx
  8018cf:	52                   	push   %edx
  8018d0:	50                   	push   %eax
  8018d1:	6a 06                	push   $0x6
  8018d3:	e8 56 ff ff ff       	call   80182e <syscall>
  8018d8:	83 c4 18             	add    $0x18,%esp
}
  8018db:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018de:	5b                   	pop    %ebx
  8018df:	5e                   	pop    %esi
  8018e0:	5d                   	pop    %ebp
  8018e1:	c3                   	ret    

008018e2 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	52                   	push   %edx
  8018f2:	50                   	push   %eax
  8018f3:	6a 07                	push   $0x7
  8018f5:	e8 34 ff ff ff       	call   80182e <syscall>
  8018fa:	83 c4 18             	add    $0x18,%esp
}
  8018fd:	c9                   	leave  
  8018fe:	c3                   	ret    

008018ff <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	ff 75 0c             	pushl  0xc(%ebp)
  80190b:	ff 75 08             	pushl  0x8(%ebp)
  80190e:	6a 08                	push   $0x8
  801910:	e8 19 ff ff ff       	call   80182e <syscall>
  801915:	83 c4 18             	add    $0x18,%esp
}
  801918:	c9                   	leave  
  801919:	c3                   	ret    

0080191a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 09                	push   $0x9
  801929:	e8 00 ff ff ff       	call   80182e <syscall>
  80192e:	83 c4 18             	add    $0x18,%esp
}
  801931:	c9                   	leave  
  801932:	c3                   	ret    

00801933 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801933:	55                   	push   %ebp
  801934:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 0a                	push   $0xa
  801942:	e8 e7 fe ff ff       	call   80182e <syscall>
  801947:	83 c4 18             	add    $0x18,%esp
}
  80194a:	c9                   	leave  
  80194b:	c3                   	ret    

0080194c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 0b                	push   $0xb
  80195b:	e8 ce fe ff ff       	call   80182e <syscall>
  801960:	83 c4 18             	add    $0x18,%esp
}
  801963:	c9                   	leave  
  801964:	c3                   	ret    

00801965 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801965:	55                   	push   %ebp
  801966:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	ff 75 0c             	pushl  0xc(%ebp)
  801971:	ff 75 08             	pushl  0x8(%ebp)
  801974:	6a 0f                	push   $0xf
  801976:	e8 b3 fe ff ff       	call   80182e <syscall>
  80197b:	83 c4 18             	add    $0x18,%esp
	return;
  80197e:	90                   	nop
}
  80197f:	c9                   	leave  
  801980:	c3                   	ret    

00801981 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801981:	55                   	push   %ebp
  801982:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	ff 75 0c             	pushl  0xc(%ebp)
  80198d:	ff 75 08             	pushl  0x8(%ebp)
  801990:	6a 10                	push   $0x10
  801992:	e8 97 fe ff ff       	call   80182e <syscall>
  801997:	83 c4 18             	add    $0x18,%esp
	return ;
  80199a:	90                   	nop
}
  80199b:	c9                   	leave  
  80199c:	c3                   	ret    

0080199d <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80199d:	55                   	push   %ebp
  80199e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	ff 75 10             	pushl  0x10(%ebp)
  8019a7:	ff 75 0c             	pushl  0xc(%ebp)
  8019aa:	ff 75 08             	pushl  0x8(%ebp)
  8019ad:	6a 11                	push   $0x11
  8019af:	e8 7a fe ff ff       	call   80182e <syscall>
  8019b4:	83 c4 18             	add    $0x18,%esp
	return ;
  8019b7:	90                   	nop
}
  8019b8:	c9                   	leave  
  8019b9:	c3                   	ret    

008019ba <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 0c                	push   $0xc
  8019c9:	e8 60 fe ff ff       	call   80182e <syscall>
  8019ce:	83 c4 18             	add    $0x18,%esp
}
  8019d1:	c9                   	leave  
  8019d2:	c3                   	ret    

008019d3 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019d3:	55                   	push   %ebp
  8019d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	ff 75 08             	pushl  0x8(%ebp)
  8019e1:	6a 0d                	push   $0xd
  8019e3:	e8 46 fe ff ff       	call   80182e <syscall>
  8019e8:	83 c4 18             	add    $0x18,%esp
}
  8019eb:	c9                   	leave  
  8019ec:	c3                   	ret    

008019ed <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019ed:	55                   	push   %ebp
  8019ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 0e                	push   $0xe
  8019fc:	e8 2d fe ff ff       	call   80182e <syscall>
  801a01:	83 c4 18             	add    $0x18,%esp
}
  801a04:	90                   	nop
  801a05:	c9                   	leave  
  801a06:	c3                   	ret    

00801a07 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 13                	push   $0x13
  801a16:	e8 13 fe ff ff       	call   80182e <syscall>
  801a1b:	83 c4 18             	add    $0x18,%esp
}
  801a1e:	90                   	nop
  801a1f:	c9                   	leave  
  801a20:	c3                   	ret    

00801a21 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a21:	55                   	push   %ebp
  801a22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 14                	push   $0x14
  801a30:	e8 f9 fd ff ff       	call   80182e <syscall>
  801a35:	83 c4 18             	add    $0x18,%esp
}
  801a38:	90                   	nop
  801a39:	c9                   	leave  
  801a3a:	c3                   	ret    

00801a3b <sys_cputc>:


void
sys_cputc(const char c)
{
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
  801a3e:	83 ec 04             	sub    $0x4,%esp
  801a41:	8b 45 08             	mov    0x8(%ebp),%eax
  801a44:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a47:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	50                   	push   %eax
  801a54:	6a 15                	push   $0x15
  801a56:	e8 d3 fd ff ff       	call   80182e <syscall>
  801a5b:	83 c4 18             	add    $0x18,%esp
}
  801a5e:	90                   	nop
  801a5f:	c9                   	leave  
  801a60:	c3                   	ret    

00801a61 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 16                	push   $0x16
  801a70:	e8 b9 fd ff ff       	call   80182e <syscall>
  801a75:	83 c4 18             	add    $0x18,%esp
}
  801a78:	90                   	nop
  801a79:	c9                   	leave  
  801a7a:	c3                   	ret    

00801a7b <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a7b:	55                   	push   %ebp
  801a7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	ff 75 0c             	pushl  0xc(%ebp)
  801a8a:	50                   	push   %eax
  801a8b:	6a 17                	push   $0x17
  801a8d:	e8 9c fd ff ff       	call   80182e <syscall>
  801a92:	83 c4 18             	add    $0x18,%esp
}
  801a95:	c9                   	leave  
  801a96:	c3                   	ret    

00801a97 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	52                   	push   %edx
  801aa7:	50                   	push   %eax
  801aa8:	6a 1a                	push   $0x1a
  801aaa:	e8 7f fd ff ff       	call   80182e <syscall>
  801aaf:	83 c4 18             	add    $0x18,%esp
}
  801ab2:	c9                   	leave  
  801ab3:	c3                   	ret    

00801ab4 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ab4:	55                   	push   %ebp
  801ab5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ab7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aba:	8b 45 08             	mov    0x8(%ebp),%eax
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	52                   	push   %edx
  801ac4:	50                   	push   %eax
  801ac5:	6a 18                	push   $0x18
  801ac7:	e8 62 fd ff ff       	call   80182e <syscall>
  801acc:	83 c4 18             	add    $0x18,%esp
}
  801acf:	90                   	nop
  801ad0:	c9                   	leave  
  801ad1:	c3                   	ret    

00801ad2 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ad2:	55                   	push   %ebp
  801ad3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ad5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	52                   	push   %edx
  801ae2:	50                   	push   %eax
  801ae3:	6a 19                	push   $0x19
  801ae5:	e8 44 fd ff ff       	call   80182e <syscall>
  801aea:	83 c4 18             	add    $0x18,%esp
}
  801aed:	90                   	nop
  801aee:	c9                   	leave  
  801aef:	c3                   	ret    

00801af0 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
  801af3:	83 ec 04             	sub    $0x4,%esp
  801af6:	8b 45 10             	mov    0x10(%ebp),%eax
  801af9:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801afc:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801aff:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b03:	8b 45 08             	mov    0x8(%ebp),%eax
  801b06:	6a 00                	push   $0x0
  801b08:	51                   	push   %ecx
  801b09:	52                   	push   %edx
  801b0a:	ff 75 0c             	pushl  0xc(%ebp)
  801b0d:	50                   	push   %eax
  801b0e:	6a 1b                	push   $0x1b
  801b10:	e8 19 fd ff ff       	call   80182e <syscall>
  801b15:	83 c4 18             	add    $0x18,%esp
}
  801b18:	c9                   	leave  
  801b19:	c3                   	ret    

00801b1a <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b1a:	55                   	push   %ebp
  801b1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b20:	8b 45 08             	mov    0x8(%ebp),%eax
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	52                   	push   %edx
  801b2a:	50                   	push   %eax
  801b2b:	6a 1c                	push   $0x1c
  801b2d:	e8 fc fc ff ff       	call   80182e <syscall>
  801b32:	83 c4 18             	add    $0x18,%esp
}
  801b35:	c9                   	leave  
  801b36:	c3                   	ret    

00801b37 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b3a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b40:	8b 45 08             	mov    0x8(%ebp),%eax
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	51                   	push   %ecx
  801b48:	52                   	push   %edx
  801b49:	50                   	push   %eax
  801b4a:	6a 1d                	push   $0x1d
  801b4c:	e8 dd fc ff ff       	call   80182e <syscall>
  801b51:	83 c4 18             	add    $0x18,%esp
}
  801b54:	c9                   	leave  
  801b55:	c3                   	ret    

00801b56 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b56:	55                   	push   %ebp
  801b57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b59:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	52                   	push   %edx
  801b66:	50                   	push   %eax
  801b67:	6a 1e                	push   $0x1e
  801b69:	e8 c0 fc ff ff       	call   80182e <syscall>
  801b6e:	83 c4 18             	add    $0x18,%esp
}
  801b71:	c9                   	leave  
  801b72:	c3                   	ret    

00801b73 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b73:	55                   	push   %ebp
  801b74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 1f                	push   $0x1f
  801b82:	e8 a7 fc ff ff       	call   80182e <syscall>
  801b87:	83 c4 18             	add    $0x18,%esp
}
  801b8a:	c9                   	leave  
  801b8b:	c3                   	ret    

00801b8c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b92:	6a 00                	push   $0x0
  801b94:	ff 75 14             	pushl  0x14(%ebp)
  801b97:	ff 75 10             	pushl  0x10(%ebp)
  801b9a:	ff 75 0c             	pushl  0xc(%ebp)
  801b9d:	50                   	push   %eax
  801b9e:	6a 20                	push   $0x20
  801ba0:	e8 89 fc ff ff       	call   80182e <syscall>
  801ba5:	83 c4 18             	add    $0x18,%esp
}
  801ba8:	c9                   	leave  
  801ba9:	c3                   	ret    

00801baa <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801baa:	55                   	push   %ebp
  801bab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bad:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	50                   	push   %eax
  801bb9:	6a 21                	push   $0x21
  801bbb:	e8 6e fc ff ff       	call   80182e <syscall>
  801bc0:	83 c4 18             	add    $0x18,%esp
}
  801bc3:	90                   	nop
  801bc4:	c9                   	leave  
  801bc5:	c3                   	ret    

00801bc6 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bc6:	55                   	push   %ebp
  801bc7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	50                   	push   %eax
  801bd5:	6a 22                	push   $0x22
  801bd7:	e8 52 fc ff ff       	call   80182e <syscall>
  801bdc:	83 c4 18             	add    $0x18,%esp
}
  801bdf:	c9                   	leave  
  801be0:	c3                   	ret    

00801be1 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 02                	push   $0x2
  801bf0:	e8 39 fc ff ff       	call   80182e <syscall>
  801bf5:	83 c4 18             	add    $0x18,%esp
}
  801bf8:	c9                   	leave  
  801bf9:	c3                   	ret    

00801bfa <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bfa:	55                   	push   %ebp
  801bfb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 03                	push   $0x3
  801c09:	e8 20 fc ff ff       	call   80182e <syscall>
  801c0e:	83 c4 18             	add    $0x18,%esp
}
  801c11:	c9                   	leave  
  801c12:	c3                   	ret    

00801c13 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 04                	push   $0x4
  801c22:	e8 07 fc ff ff       	call   80182e <syscall>
  801c27:	83 c4 18             	add    $0x18,%esp
}
  801c2a:	c9                   	leave  
  801c2b:	c3                   	ret    

00801c2c <sys_exit_env>:


void sys_exit_env(void)
{
  801c2c:	55                   	push   %ebp
  801c2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 23                	push   $0x23
  801c3b:	e8 ee fb ff ff       	call   80182e <syscall>
  801c40:	83 c4 18             	add    $0x18,%esp
}
  801c43:	90                   	nop
  801c44:	c9                   	leave  
  801c45:	c3                   	ret    

00801c46 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
  801c49:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c4c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c4f:	8d 50 04             	lea    0x4(%eax),%edx
  801c52:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	52                   	push   %edx
  801c5c:	50                   	push   %eax
  801c5d:	6a 24                	push   $0x24
  801c5f:	e8 ca fb ff ff       	call   80182e <syscall>
  801c64:	83 c4 18             	add    $0x18,%esp
	return result;
  801c67:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c6a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c6d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c70:	89 01                	mov    %eax,(%ecx)
  801c72:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c75:	8b 45 08             	mov    0x8(%ebp),%eax
  801c78:	c9                   	leave  
  801c79:	c2 04 00             	ret    $0x4

00801c7c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c7c:	55                   	push   %ebp
  801c7d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	ff 75 10             	pushl  0x10(%ebp)
  801c86:	ff 75 0c             	pushl  0xc(%ebp)
  801c89:	ff 75 08             	pushl  0x8(%ebp)
  801c8c:	6a 12                	push   $0x12
  801c8e:	e8 9b fb ff ff       	call   80182e <syscall>
  801c93:	83 c4 18             	add    $0x18,%esp
	return ;
  801c96:	90                   	nop
}
  801c97:	c9                   	leave  
  801c98:	c3                   	ret    

00801c99 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 25                	push   $0x25
  801ca8:	e8 81 fb ff ff       	call   80182e <syscall>
  801cad:	83 c4 18             	add    $0x18,%esp
}
  801cb0:	c9                   	leave  
  801cb1:	c3                   	ret    

00801cb2 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801cb2:	55                   	push   %ebp
  801cb3:	89 e5                	mov    %esp,%ebp
  801cb5:	83 ec 04             	sub    $0x4,%esp
  801cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cbe:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	50                   	push   %eax
  801ccb:	6a 26                	push   $0x26
  801ccd:	e8 5c fb ff ff       	call   80182e <syscall>
  801cd2:	83 c4 18             	add    $0x18,%esp
	return ;
  801cd5:	90                   	nop
}
  801cd6:	c9                   	leave  
  801cd7:	c3                   	ret    

00801cd8 <rsttst>:
void rsttst()
{
  801cd8:	55                   	push   %ebp
  801cd9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 28                	push   $0x28
  801ce7:	e8 42 fb ff ff       	call   80182e <syscall>
  801cec:	83 c4 18             	add    $0x18,%esp
	return ;
  801cef:	90                   	nop
}
  801cf0:	c9                   	leave  
  801cf1:	c3                   	ret    

00801cf2 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cf2:	55                   	push   %ebp
  801cf3:	89 e5                	mov    %esp,%ebp
  801cf5:	83 ec 04             	sub    $0x4,%esp
  801cf8:	8b 45 14             	mov    0x14(%ebp),%eax
  801cfb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cfe:	8b 55 18             	mov    0x18(%ebp),%edx
  801d01:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d05:	52                   	push   %edx
  801d06:	50                   	push   %eax
  801d07:	ff 75 10             	pushl  0x10(%ebp)
  801d0a:	ff 75 0c             	pushl  0xc(%ebp)
  801d0d:	ff 75 08             	pushl  0x8(%ebp)
  801d10:	6a 27                	push   $0x27
  801d12:	e8 17 fb ff ff       	call   80182e <syscall>
  801d17:	83 c4 18             	add    $0x18,%esp
	return ;
  801d1a:	90                   	nop
}
  801d1b:	c9                   	leave  
  801d1c:	c3                   	ret    

00801d1d <chktst>:
void chktst(uint32 n)
{
  801d1d:	55                   	push   %ebp
  801d1e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	ff 75 08             	pushl  0x8(%ebp)
  801d2b:	6a 29                	push   $0x29
  801d2d:	e8 fc fa ff ff       	call   80182e <syscall>
  801d32:	83 c4 18             	add    $0x18,%esp
	return ;
  801d35:	90                   	nop
}
  801d36:	c9                   	leave  
  801d37:	c3                   	ret    

00801d38 <inctst>:

void inctst()
{
  801d38:	55                   	push   %ebp
  801d39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 2a                	push   $0x2a
  801d47:	e8 e2 fa ff ff       	call   80182e <syscall>
  801d4c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d4f:	90                   	nop
}
  801d50:	c9                   	leave  
  801d51:	c3                   	ret    

00801d52 <gettst>:
uint32 gettst()
{
  801d52:	55                   	push   %ebp
  801d53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 2b                	push   $0x2b
  801d61:	e8 c8 fa ff ff       	call   80182e <syscall>
  801d66:	83 c4 18             	add    $0x18,%esp
}
  801d69:	c9                   	leave  
  801d6a:	c3                   	ret    

00801d6b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d6b:	55                   	push   %ebp
  801d6c:	89 e5                	mov    %esp,%ebp
  801d6e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 2c                	push   $0x2c
  801d7d:	e8 ac fa ff ff       	call   80182e <syscall>
  801d82:	83 c4 18             	add    $0x18,%esp
  801d85:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d88:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d8c:	75 07                	jne    801d95 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d8e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d93:	eb 05                	jmp    801d9a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d9a:	c9                   	leave  
  801d9b:	c3                   	ret    

00801d9c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d9c:	55                   	push   %ebp
  801d9d:	89 e5                	mov    %esp,%ebp
  801d9f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	6a 2c                	push   $0x2c
  801dae:	e8 7b fa ff ff       	call   80182e <syscall>
  801db3:	83 c4 18             	add    $0x18,%esp
  801db6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801db9:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801dbd:	75 07                	jne    801dc6 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801dbf:	b8 01 00 00 00       	mov    $0x1,%eax
  801dc4:	eb 05                	jmp    801dcb <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801dc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dcb:	c9                   	leave  
  801dcc:	c3                   	ret    

00801dcd <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801dcd:	55                   	push   %ebp
  801dce:	89 e5                	mov    %esp,%ebp
  801dd0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 2c                	push   $0x2c
  801ddf:	e8 4a fa ff ff       	call   80182e <syscall>
  801de4:	83 c4 18             	add    $0x18,%esp
  801de7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801dea:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801dee:	75 07                	jne    801df7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801df0:	b8 01 00 00 00       	mov    $0x1,%eax
  801df5:	eb 05                	jmp    801dfc <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801df7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dfc:	c9                   	leave  
  801dfd:	c3                   	ret    

00801dfe <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801dfe:	55                   	push   %ebp
  801dff:	89 e5                	mov    %esp,%ebp
  801e01:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 2c                	push   $0x2c
  801e10:	e8 19 fa ff ff       	call   80182e <syscall>
  801e15:	83 c4 18             	add    $0x18,%esp
  801e18:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e1b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e1f:	75 07                	jne    801e28 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e21:	b8 01 00 00 00       	mov    $0x1,%eax
  801e26:	eb 05                	jmp    801e2d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e2d:	c9                   	leave  
  801e2e:	c3                   	ret    

00801e2f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e2f:	55                   	push   %ebp
  801e30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	6a 00                	push   $0x0
  801e38:	6a 00                	push   $0x0
  801e3a:	ff 75 08             	pushl  0x8(%ebp)
  801e3d:	6a 2d                	push   $0x2d
  801e3f:	e8 ea f9 ff ff       	call   80182e <syscall>
  801e44:	83 c4 18             	add    $0x18,%esp
	return ;
  801e47:	90                   	nop
}
  801e48:	c9                   	leave  
  801e49:	c3                   	ret    

00801e4a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e4a:	55                   	push   %ebp
  801e4b:	89 e5                	mov    %esp,%ebp
  801e4d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e4e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e51:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e54:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e57:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5a:	6a 00                	push   $0x0
  801e5c:	53                   	push   %ebx
  801e5d:	51                   	push   %ecx
  801e5e:	52                   	push   %edx
  801e5f:	50                   	push   %eax
  801e60:	6a 2e                	push   $0x2e
  801e62:	e8 c7 f9 ff ff       	call   80182e <syscall>
  801e67:	83 c4 18             	add    $0x18,%esp
}
  801e6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e6d:	c9                   	leave  
  801e6e:	c3                   	ret    

00801e6f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e6f:	55                   	push   %ebp
  801e70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e72:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e75:	8b 45 08             	mov    0x8(%ebp),%eax
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	52                   	push   %edx
  801e7f:	50                   	push   %eax
  801e80:	6a 2f                	push   $0x2f
  801e82:	e8 a7 f9 ff ff       	call   80182e <syscall>
  801e87:	83 c4 18             	add    $0x18,%esp
}
  801e8a:	c9                   	leave  
  801e8b:	c3                   	ret    

00801e8c <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801e8c:	55                   	push   %ebp
  801e8d:	89 e5                	mov    %esp,%ebp
  801e8f:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801e92:	8b 55 08             	mov    0x8(%ebp),%edx
  801e95:	89 d0                	mov    %edx,%eax
  801e97:	c1 e0 02             	shl    $0x2,%eax
  801e9a:	01 d0                	add    %edx,%eax
  801e9c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ea3:	01 d0                	add    %edx,%eax
  801ea5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801eac:	01 d0                	add    %edx,%eax
  801eae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801eb5:	01 d0                	add    %edx,%eax
  801eb7:	c1 e0 04             	shl    $0x4,%eax
  801eba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801ebd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801ec4:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801ec7:	83 ec 0c             	sub    $0xc,%esp
  801eca:	50                   	push   %eax
  801ecb:	e8 76 fd ff ff       	call   801c46 <sys_get_virtual_time>
  801ed0:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801ed3:	eb 41                	jmp    801f16 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801ed5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801ed8:	83 ec 0c             	sub    $0xc,%esp
  801edb:	50                   	push   %eax
  801edc:	e8 65 fd ff ff       	call   801c46 <sys_get_virtual_time>
  801ee1:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801ee4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ee7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801eea:	29 c2                	sub    %eax,%edx
  801eec:	89 d0                	mov    %edx,%eax
  801eee:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801ef1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801ef4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ef7:	89 d1                	mov    %edx,%ecx
  801ef9:	29 c1                	sub    %eax,%ecx
  801efb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801efe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f01:	39 c2                	cmp    %eax,%edx
  801f03:	0f 97 c0             	seta   %al
  801f06:	0f b6 c0             	movzbl %al,%eax
  801f09:	29 c1                	sub    %eax,%ecx
  801f0b:	89 c8                	mov    %ecx,%eax
  801f0d:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801f10:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801f13:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f19:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801f1c:	72 b7                	jb     801ed5 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801f1e:	90                   	nop
  801f1f:	c9                   	leave  
  801f20:	c3                   	ret    

00801f21 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801f21:	55                   	push   %ebp
  801f22:	89 e5                	mov    %esp,%ebp
  801f24:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801f27:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801f2e:	eb 03                	jmp    801f33 <busy_wait+0x12>
  801f30:	ff 45 fc             	incl   -0x4(%ebp)
  801f33:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f36:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f39:	72 f5                	jb     801f30 <busy_wait+0xf>
	return i;
  801f3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f3e:	c9                   	leave  
  801f3f:	c3                   	ret    

00801f40 <__udivdi3>:
  801f40:	55                   	push   %ebp
  801f41:	57                   	push   %edi
  801f42:	56                   	push   %esi
  801f43:	53                   	push   %ebx
  801f44:	83 ec 1c             	sub    $0x1c,%esp
  801f47:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801f4b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801f4f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f53:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f57:	89 ca                	mov    %ecx,%edx
  801f59:	89 f8                	mov    %edi,%eax
  801f5b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801f5f:	85 f6                	test   %esi,%esi
  801f61:	75 2d                	jne    801f90 <__udivdi3+0x50>
  801f63:	39 cf                	cmp    %ecx,%edi
  801f65:	77 65                	ja     801fcc <__udivdi3+0x8c>
  801f67:	89 fd                	mov    %edi,%ebp
  801f69:	85 ff                	test   %edi,%edi
  801f6b:	75 0b                	jne    801f78 <__udivdi3+0x38>
  801f6d:	b8 01 00 00 00       	mov    $0x1,%eax
  801f72:	31 d2                	xor    %edx,%edx
  801f74:	f7 f7                	div    %edi
  801f76:	89 c5                	mov    %eax,%ebp
  801f78:	31 d2                	xor    %edx,%edx
  801f7a:	89 c8                	mov    %ecx,%eax
  801f7c:	f7 f5                	div    %ebp
  801f7e:	89 c1                	mov    %eax,%ecx
  801f80:	89 d8                	mov    %ebx,%eax
  801f82:	f7 f5                	div    %ebp
  801f84:	89 cf                	mov    %ecx,%edi
  801f86:	89 fa                	mov    %edi,%edx
  801f88:	83 c4 1c             	add    $0x1c,%esp
  801f8b:	5b                   	pop    %ebx
  801f8c:	5e                   	pop    %esi
  801f8d:	5f                   	pop    %edi
  801f8e:	5d                   	pop    %ebp
  801f8f:	c3                   	ret    
  801f90:	39 ce                	cmp    %ecx,%esi
  801f92:	77 28                	ja     801fbc <__udivdi3+0x7c>
  801f94:	0f bd fe             	bsr    %esi,%edi
  801f97:	83 f7 1f             	xor    $0x1f,%edi
  801f9a:	75 40                	jne    801fdc <__udivdi3+0x9c>
  801f9c:	39 ce                	cmp    %ecx,%esi
  801f9e:	72 0a                	jb     801faa <__udivdi3+0x6a>
  801fa0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801fa4:	0f 87 9e 00 00 00    	ja     802048 <__udivdi3+0x108>
  801faa:	b8 01 00 00 00       	mov    $0x1,%eax
  801faf:	89 fa                	mov    %edi,%edx
  801fb1:	83 c4 1c             	add    $0x1c,%esp
  801fb4:	5b                   	pop    %ebx
  801fb5:	5e                   	pop    %esi
  801fb6:	5f                   	pop    %edi
  801fb7:	5d                   	pop    %ebp
  801fb8:	c3                   	ret    
  801fb9:	8d 76 00             	lea    0x0(%esi),%esi
  801fbc:	31 ff                	xor    %edi,%edi
  801fbe:	31 c0                	xor    %eax,%eax
  801fc0:	89 fa                	mov    %edi,%edx
  801fc2:	83 c4 1c             	add    $0x1c,%esp
  801fc5:	5b                   	pop    %ebx
  801fc6:	5e                   	pop    %esi
  801fc7:	5f                   	pop    %edi
  801fc8:	5d                   	pop    %ebp
  801fc9:	c3                   	ret    
  801fca:	66 90                	xchg   %ax,%ax
  801fcc:	89 d8                	mov    %ebx,%eax
  801fce:	f7 f7                	div    %edi
  801fd0:	31 ff                	xor    %edi,%edi
  801fd2:	89 fa                	mov    %edi,%edx
  801fd4:	83 c4 1c             	add    $0x1c,%esp
  801fd7:	5b                   	pop    %ebx
  801fd8:	5e                   	pop    %esi
  801fd9:	5f                   	pop    %edi
  801fda:	5d                   	pop    %ebp
  801fdb:	c3                   	ret    
  801fdc:	bd 20 00 00 00       	mov    $0x20,%ebp
  801fe1:	89 eb                	mov    %ebp,%ebx
  801fe3:	29 fb                	sub    %edi,%ebx
  801fe5:	89 f9                	mov    %edi,%ecx
  801fe7:	d3 e6                	shl    %cl,%esi
  801fe9:	89 c5                	mov    %eax,%ebp
  801feb:	88 d9                	mov    %bl,%cl
  801fed:	d3 ed                	shr    %cl,%ebp
  801fef:	89 e9                	mov    %ebp,%ecx
  801ff1:	09 f1                	or     %esi,%ecx
  801ff3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801ff7:	89 f9                	mov    %edi,%ecx
  801ff9:	d3 e0                	shl    %cl,%eax
  801ffb:	89 c5                	mov    %eax,%ebp
  801ffd:	89 d6                	mov    %edx,%esi
  801fff:	88 d9                	mov    %bl,%cl
  802001:	d3 ee                	shr    %cl,%esi
  802003:	89 f9                	mov    %edi,%ecx
  802005:	d3 e2                	shl    %cl,%edx
  802007:	8b 44 24 08          	mov    0x8(%esp),%eax
  80200b:	88 d9                	mov    %bl,%cl
  80200d:	d3 e8                	shr    %cl,%eax
  80200f:	09 c2                	or     %eax,%edx
  802011:	89 d0                	mov    %edx,%eax
  802013:	89 f2                	mov    %esi,%edx
  802015:	f7 74 24 0c          	divl   0xc(%esp)
  802019:	89 d6                	mov    %edx,%esi
  80201b:	89 c3                	mov    %eax,%ebx
  80201d:	f7 e5                	mul    %ebp
  80201f:	39 d6                	cmp    %edx,%esi
  802021:	72 19                	jb     80203c <__udivdi3+0xfc>
  802023:	74 0b                	je     802030 <__udivdi3+0xf0>
  802025:	89 d8                	mov    %ebx,%eax
  802027:	31 ff                	xor    %edi,%edi
  802029:	e9 58 ff ff ff       	jmp    801f86 <__udivdi3+0x46>
  80202e:	66 90                	xchg   %ax,%ax
  802030:	8b 54 24 08          	mov    0x8(%esp),%edx
  802034:	89 f9                	mov    %edi,%ecx
  802036:	d3 e2                	shl    %cl,%edx
  802038:	39 c2                	cmp    %eax,%edx
  80203a:	73 e9                	jae    802025 <__udivdi3+0xe5>
  80203c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80203f:	31 ff                	xor    %edi,%edi
  802041:	e9 40 ff ff ff       	jmp    801f86 <__udivdi3+0x46>
  802046:	66 90                	xchg   %ax,%ax
  802048:	31 c0                	xor    %eax,%eax
  80204a:	e9 37 ff ff ff       	jmp    801f86 <__udivdi3+0x46>
  80204f:	90                   	nop

00802050 <__umoddi3>:
  802050:	55                   	push   %ebp
  802051:	57                   	push   %edi
  802052:	56                   	push   %esi
  802053:	53                   	push   %ebx
  802054:	83 ec 1c             	sub    $0x1c,%esp
  802057:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80205b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80205f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802063:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802067:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80206b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80206f:	89 f3                	mov    %esi,%ebx
  802071:	89 fa                	mov    %edi,%edx
  802073:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802077:	89 34 24             	mov    %esi,(%esp)
  80207a:	85 c0                	test   %eax,%eax
  80207c:	75 1a                	jne    802098 <__umoddi3+0x48>
  80207e:	39 f7                	cmp    %esi,%edi
  802080:	0f 86 a2 00 00 00    	jbe    802128 <__umoddi3+0xd8>
  802086:	89 c8                	mov    %ecx,%eax
  802088:	89 f2                	mov    %esi,%edx
  80208a:	f7 f7                	div    %edi
  80208c:	89 d0                	mov    %edx,%eax
  80208e:	31 d2                	xor    %edx,%edx
  802090:	83 c4 1c             	add    $0x1c,%esp
  802093:	5b                   	pop    %ebx
  802094:	5e                   	pop    %esi
  802095:	5f                   	pop    %edi
  802096:	5d                   	pop    %ebp
  802097:	c3                   	ret    
  802098:	39 f0                	cmp    %esi,%eax
  80209a:	0f 87 ac 00 00 00    	ja     80214c <__umoddi3+0xfc>
  8020a0:	0f bd e8             	bsr    %eax,%ebp
  8020a3:	83 f5 1f             	xor    $0x1f,%ebp
  8020a6:	0f 84 ac 00 00 00    	je     802158 <__umoddi3+0x108>
  8020ac:	bf 20 00 00 00       	mov    $0x20,%edi
  8020b1:	29 ef                	sub    %ebp,%edi
  8020b3:	89 fe                	mov    %edi,%esi
  8020b5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8020b9:	89 e9                	mov    %ebp,%ecx
  8020bb:	d3 e0                	shl    %cl,%eax
  8020bd:	89 d7                	mov    %edx,%edi
  8020bf:	89 f1                	mov    %esi,%ecx
  8020c1:	d3 ef                	shr    %cl,%edi
  8020c3:	09 c7                	or     %eax,%edi
  8020c5:	89 e9                	mov    %ebp,%ecx
  8020c7:	d3 e2                	shl    %cl,%edx
  8020c9:	89 14 24             	mov    %edx,(%esp)
  8020cc:	89 d8                	mov    %ebx,%eax
  8020ce:	d3 e0                	shl    %cl,%eax
  8020d0:	89 c2                	mov    %eax,%edx
  8020d2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8020d6:	d3 e0                	shl    %cl,%eax
  8020d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020dc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8020e0:	89 f1                	mov    %esi,%ecx
  8020e2:	d3 e8                	shr    %cl,%eax
  8020e4:	09 d0                	or     %edx,%eax
  8020e6:	d3 eb                	shr    %cl,%ebx
  8020e8:	89 da                	mov    %ebx,%edx
  8020ea:	f7 f7                	div    %edi
  8020ec:	89 d3                	mov    %edx,%ebx
  8020ee:	f7 24 24             	mull   (%esp)
  8020f1:	89 c6                	mov    %eax,%esi
  8020f3:	89 d1                	mov    %edx,%ecx
  8020f5:	39 d3                	cmp    %edx,%ebx
  8020f7:	0f 82 87 00 00 00    	jb     802184 <__umoddi3+0x134>
  8020fd:	0f 84 91 00 00 00    	je     802194 <__umoddi3+0x144>
  802103:	8b 54 24 04          	mov    0x4(%esp),%edx
  802107:	29 f2                	sub    %esi,%edx
  802109:	19 cb                	sbb    %ecx,%ebx
  80210b:	89 d8                	mov    %ebx,%eax
  80210d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802111:	d3 e0                	shl    %cl,%eax
  802113:	89 e9                	mov    %ebp,%ecx
  802115:	d3 ea                	shr    %cl,%edx
  802117:	09 d0                	or     %edx,%eax
  802119:	89 e9                	mov    %ebp,%ecx
  80211b:	d3 eb                	shr    %cl,%ebx
  80211d:	89 da                	mov    %ebx,%edx
  80211f:	83 c4 1c             	add    $0x1c,%esp
  802122:	5b                   	pop    %ebx
  802123:	5e                   	pop    %esi
  802124:	5f                   	pop    %edi
  802125:	5d                   	pop    %ebp
  802126:	c3                   	ret    
  802127:	90                   	nop
  802128:	89 fd                	mov    %edi,%ebp
  80212a:	85 ff                	test   %edi,%edi
  80212c:	75 0b                	jne    802139 <__umoddi3+0xe9>
  80212e:	b8 01 00 00 00       	mov    $0x1,%eax
  802133:	31 d2                	xor    %edx,%edx
  802135:	f7 f7                	div    %edi
  802137:	89 c5                	mov    %eax,%ebp
  802139:	89 f0                	mov    %esi,%eax
  80213b:	31 d2                	xor    %edx,%edx
  80213d:	f7 f5                	div    %ebp
  80213f:	89 c8                	mov    %ecx,%eax
  802141:	f7 f5                	div    %ebp
  802143:	89 d0                	mov    %edx,%eax
  802145:	e9 44 ff ff ff       	jmp    80208e <__umoddi3+0x3e>
  80214a:	66 90                	xchg   %ax,%ax
  80214c:	89 c8                	mov    %ecx,%eax
  80214e:	89 f2                	mov    %esi,%edx
  802150:	83 c4 1c             	add    $0x1c,%esp
  802153:	5b                   	pop    %ebx
  802154:	5e                   	pop    %esi
  802155:	5f                   	pop    %edi
  802156:	5d                   	pop    %ebp
  802157:	c3                   	ret    
  802158:	3b 04 24             	cmp    (%esp),%eax
  80215b:	72 06                	jb     802163 <__umoddi3+0x113>
  80215d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802161:	77 0f                	ja     802172 <__umoddi3+0x122>
  802163:	89 f2                	mov    %esi,%edx
  802165:	29 f9                	sub    %edi,%ecx
  802167:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80216b:	89 14 24             	mov    %edx,(%esp)
  80216e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802172:	8b 44 24 04          	mov    0x4(%esp),%eax
  802176:	8b 14 24             	mov    (%esp),%edx
  802179:	83 c4 1c             	add    $0x1c,%esp
  80217c:	5b                   	pop    %ebx
  80217d:	5e                   	pop    %esi
  80217e:	5f                   	pop    %edi
  80217f:	5d                   	pop    %ebp
  802180:	c3                   	ret    
  802181:	8d 76 00             	lea    0x0(%esi),%esi
  802184:	2b 04 24             	sub    (%esp),%eax
  802187:	19 fa                	sbb    %edi,%edx
  802189:	89 d1                	mov    %edx,%ecx
  80218b:	89 c6                	mov    %eax,%esi
  80218d:	e9 71 ff ff ff       	jmp    802103 <__umoddi3+0xb3>
  802192:	66 90                	xchg   %ax,%ax
  802194:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802198:	72 ea                	jb     802184 <__umoddi3+0x134>
  80219a:	89 d9                	mov    %ebx,%ecx
  80219c:	e9 62 ff ff ff       	jmp    802103 <__umoddi3+0xb3>
